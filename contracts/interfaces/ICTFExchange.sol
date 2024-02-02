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
     * @dev Gets the status of an order.
     * @param orderHash Hash of the order.
     * @return Order status.
     */
    function getOrderStatus(
        bytes32 orderHash
    ) external view returns (OrderStatus memory);
}
