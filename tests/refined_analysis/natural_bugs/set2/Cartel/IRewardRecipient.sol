// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {DataTypes} from "../libraries/DataTypes.sol";

/**
 * @title IRewardRecipient
 * @notice Interface for managing rewards and penalties in the validator system.
 * @dev This interface defines functions related to dissolving and slashing validators in the Pirex protocol.
 * @author redactedcartel.finance
 */
interface IRewardRecipient {
    /**
     * @notice Dissolves a validator and transfers the specified ETH amount.
     * @dev This function is responsible for dissolving a validator and transferring the specified ETH amount.
     * @param _pubKey bytes   The public key of the validator to be dissolved.
     * @param _amount uint256 The amount of ETH to be transferred during the dissolution.
     */
    function dissolveValidator(
        bytes calldata _pubKey,
        uint256 _amount
    ) external;

    /**
     * @notice Slashes a validator for misconduct, optionally removing it in a gas-efficient way.
     * @dev This function is responsible for slashing a validator, removing it from the system, and handling burner accounts.
     * @param _pubKey         bytes                     The public key of the validator to be slashed.
     * @param _removeIndex    uint256                   The index of the validator's public key to be removed.
     * @param _amount         uint256                   The amount of ETH to be slashed from the validator.
     * @param _unordered      bool                      Flag indicating whether the removal is done in a gas-efficient way.
     * @param _burnerAccounts DataTypes.BurnerAccount[] Array of burner accounts associated with the slashed validator.
     */
    function slashValidator(
        bytes calldata _pubKey,
        uint256 _removeIndex,
        uint256 _amount,
        bool _unordered,
        DataTypes.BurnerAccount[] calldata _burnerAccounts
    ) external;
}
