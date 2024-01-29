// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Types} from "lens-modules/contracts/libraries/constants/Types.sol";
import {IPublicationActionModule} from "lens-modules/contracts/interfaces/IPublicationActionModule.sol";
import {HubRestricted} from "lens-modules/contracts/base/HubRestricted.sol";
import {LensModuleMetadata} from "lens-modules/contracts/modules/LensModuleMetadata.sol";

import {Order} from "./libraries/OrderStructs.sol";
import {ICTFExchange} from "./interfaces/ICTFExchange.sol";
import {IConditionalTokens} from "./interfaces/IConditionalTokens.sol";
import {LensModuleRegistrant} from "./base/LensModuleRegistrant.sol";

/**
 * @title PolymarketTradingActionModule
 * @dev Open Action Module for buying Polymarket markets.
 */
contract PolymarketTradingActionModule is
    IPublicationActionModule,
    HubRestricted,
    LensModuleMetadata,
    LensModuleRegistrant
{
    /**
     * @dev Emitted when a Polymarket market is registered.
     * @param publicationActedProfileId Profile ID of the publication to act on.
     * @param publicationActedId Publication ID of the publication to act on.
     * @param conditionId Polymarket Market Condition ID.
     */
    event MarketRegistered(
        uint256 indexed publicationActedProfileId,
        uint256 indexed publicationActedId,
        bytes32 indexed conditionId
    );

    /**
     * @dev Emitted when a Polymarket market order is placed.
     * @param publicationActedProfileId Profile ID of the publication acted on.
     * @param publicationActedId Publication ID of the publication acted on.
     * @param actorProfileId Profile ID of the actor.
     * @param actorProfileOwner Address of the owner of the actor profile.
     * @param conditionId Polymarket Market Condition ID.
     * @param order Polymarket market Order.
     */
    event MarketOrderPlaced(
        uint256 publicationActedProfileId,
        uint256 publicationActedId,
        uint256 actorProfileId,
        address indexed actorProfileOwner,
        bytes32 indexed conditionId,
        Order order
    );

    error ConditionIdMustBeProvided();
    error MarketNotFound();
    error ConditionIdNotRegistered();
    error ConditionIdDoesNotMatch();
    error OrderNotSignedByActor();

    /**
     * @dev Mapping of Polymarket Market Condition IDs for publications.
     */
    mapping(uint256 profileId => mapping(uint256 pubId => bytes32 conditionId))
        internal _conditionIds;

    /**
     * @dev Polymarket CTF Exchange contract.
     */
    ICTFExchange internal immutable _exchange;

    /**
     * @dev Polymarket The collateral token for the CTF.
     */
    IERC20 internal immutable _collateralToken;

    /**
     * @dev Polymarket Conditional Tokens contract.
     */
    IConditionalTokens internal immutable _conditionalTokens;

    /**
     * @dev Initializes the PolymarketTradingActionModule contract.
     * @param lensHub Address of the LensHub contract.
     * @param lensModuleRegistry Address of the Lens ModuleRegistry contract.
     * @param exchange Address of the Polymarket CTF Exchange contract.
     * @param collateralToken Address of the Polymarket CTF collateral token (USDC.e).
     * @param conditionalTokens Address of the Polymarket Conditional Tokens contract.
     */
    constructor(
        address lensHub,
        address lensModuleRegistry,
        ICTFExchange exchange,
        IERC20 collateralToken,
        IConditionalTokens conditionalTokens
    )
        Ownable(msg.sender)
        HubRestricted(lensHub)
        LensModuleMetadata()
        LensModuleRegistrant(lensModuleRegistry)
    {
        _exchange = exchange;
        _collateralToken = collateralToken;
        _conditionalTokens = conditionalTokens;
    }

    /**
     * @dev Returns the Polymarket Market Condition ID for a publication.
     * @param profileId ID of the profile.
     * @param pubId ID of the publication.
     * @return Polymarket Market Condition ID.
     */
    function getConditionId(
        uint256 profileId,
        uint256 pubId
    ) external view returns (bytes32) {
        return _conditionIds[profileId][pubId];
    }

    function supportsInterface(
        bytes4 interfaceID
    ) public pure virtual override returns (bool) {
        return
            interfaceID == type(IPublicationActionModule).interfaceId ||
            super.supportsInterface(interfaceID);
    }

    /**
     * @dev Returns the Gnosis PositionId for a Polymarket Market Condition ID and index.
     * @param conditionId Polymarket Market Condition ID.
     * @param index Index of the outcome.
     * @return Position ID.
     */
    function getPositionIdFromCondition(
        bytes32 conditionId,
        uint8 index
    ) internal view returns (uint256) {
        // Construct the outcome collection ID
        bytes32 collectionId = _conditionalTokens.getCollectionId(
            bytes32(0),
            conditionId,
            index
        );
        // Construct the PositionId
        return _conditionalTokens.getPositionId(_collateralToken, collectionId);
    }

    /**
     * @dev Initializes the module. The initialization calldata is just the Polymarket Market Condition ID.
     * Clients can use this to display Market data and related actions.
     * @param profileId ID of the profile.
     * @param pubId ID of the publication.
     * @param data Initialization calldata.
     * @return The Condition ID and array of the Position IDs (Binary Outcome Token IDs).
     */
    function initializePublicationAction(
        uint256 profileId,
        uint256 pubId,
        address /* transactionExecutor */,
        bytes calldata data
    ) external override onlyHub returns (bytes memory) {
        // Decode the conditionId from the call data
        bytes32 conditionId = abi.decode(data, (bytes32));

        // Check that the conditionId is not 0
        if (conditionId == 0) {
            revert ConditionIdMustBeProvided();
        }

        // Get the token IDs for the binary outcomes
        uint256 yesTokenId = getPositionIdFromCondition(conditionId, 1);
        uint256 noTokenId = getPositionIdFromCondition(conditionId, 2);

        if (yesTokenId == 0 || noTokenId == 0) {
            revert MarketNotFound();
        }

        // Register the conditionId
        _conditionIds[profileId][pubId] = conditionId;

        // Emit the MarketRegistered event
        emit MarketRegistered(profileId, pubId, conditionId);

        return abi.encode(conditionId, [yesTokenId, noTokenId]);
    }

    /**
     * @dev Processes a Polymarket market order. This function primarily ensures that the order
     * token matches the registered Condition ID for the publication, the signer of
     * the Order is the same as the Actor, and the order is valid.
     * @param params Parameters for the action module including the Order tuple.
     * @return The Order hash.
     */
    function processPublicationAction(
        Types.ProcessActionParams calldata params
    ) external override onlyHub returns (bytes memory) {
        // Check that the publication is registered
        bytes32 conditionId = _conditionIds[params.publicationActedProfileId][
            params.publicationActedId
        ];
        if (conditionId == 0) {
            revert ConditionIdNotRegistered();
        }

        Order memory order = abi.decode(params.actionModuleData, (Order));

        // Check that the conditionId matches the order
        bytes32 conditionIdFromToken = _exchange.getConditionId(order.tokenId);
        if (conditionId != conditionIdFromToken) {
            revert ConditionIdDoesNotMatch();
        }

        // Check that the order is signed by the actor
        if (order.signer != params.actorProfileOwner) {
            revert OrderNotSignedByActor();
        }

        // Validate the order with the exchange. This will revert if the order is invalid.
        _exchange.validateOrder(order);

        // Emit the MarketOrderPlaced event
        emit MarketOrderPlaced(
            params.publicationActedProfileId,
            params.publicationActedId,
            params.actorProfileId,
            params.actorProfileOwner,
            conditionId,
            order
        );

        // Return the order hash as the action module data
        bytes32 hash = _exchange.hashOrder(order);
        return abi.encode(hash);
    }
}
