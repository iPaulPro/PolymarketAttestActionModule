// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Order} from "../libraries/OrderStructs.sol";

/**
 * @title ICTFExchange
 * @dev Interface for the Polymarket CTF Exchange contract.
 */
interface ICTFExchange {
    /**
     * @dev Gets the conditionId from a tokenId.
     * @param tokenId Token ID of the CTF ERC1155 asset.
     * @return Condition ID of the CTF ERC1155 asset.
     */
    function getConditionId(uint256 tokenId) external view returns (bytes32);

    /**
     * @dev Computes the hash for an order.
     * @param order Order to be hashed.
     * @return Hash of the order.
     */
    function hashOrder(Order memory order) external view returns (bytes32);

    /**
     * @dev Validates an order.
     * @param order Order to be validated.
     */
    function validateOrder(Order memory order) external view;
}
