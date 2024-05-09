// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DataTypes} from "../libraries/DataTypes.sol";

/**
 * @title IPirexEth
 * @notice Interface for the PirexEth contract
 * @dev This interface defines the methods for interacting with PirexEth.
 * @author redactedcartel.finance
 */
interface IPirexEth {
    /**
     * @notice Initiate redemption by burning pxETH in return for upxETH
     * @dev This function allows the initiation of redemption by burning pxETH in exchange for upxETH.
     * @param _assets                     uint256 The amount of assets to burn. If the caller is AutoPxEth, then apxETH; pxETH otherwise.
     * @param _receiver                   address The address to receive upxETH.
     * @param _shouldTriggerValidatorExit bool    Whether the initiation should trigger voluntary exit.
     * @return postFeeAmount              uint256 The amount of pxETH burnt for the receiver.
     * @return feeAmount                  uint256 The amount of pxETH distributed as fees.
     */
    function initiateRedemption(
        uint256 _assets,
        address _receiver,
        bool _shouldTriggerValidatorExit
    ) external returns (uint256 postFeeAmount, uint256 feeAmount);

    /**
     * @notice Dissolve validator
     * @dev This function dissolves a validator.
     * @param _pubKey bytes The public key of the validator.
     */
    function dissolveValidator(bytes calldata _pubKey) external payable;

    /**
     * @notice Update validator state to be slashed
     * @dev This function updates the validator state to be slashed.
     * @param _pubKey         bytes                     The public key of the validator.
     * @param _removeIndex    uint256                   The index of the validator to be slashed.
     * @param _amount         uint256                   The ETH amount released from the Beacon chain.
     * @param _unordered      bool                      Whether to remove from the staking validator queue in order or not.
     * @param _useBuffer      bool                      Whether to use a buffer to compensate for the loss.
     * @param _burnerAccounts DataTypes.BurnerAccount[] Burner accounts.
     */
    function slashValidator(
        bytes calldata _pubKey,
        uint256 _removeIndex,
        uint256 _amount,
        bool _unordered,
        bool _useBuffer,
        DataTypes.BurnerAccount[] calldata _burnerAccounts
    ) external payable;

    /**
     * @notice Harvest and mint staking rewards when available
     * @dev This function harvests and mints staking rewards when available.
     * @param _endBlock uint256 The block until which ETH rewards are computed.
     */
    function harvest(uint256 _endBlock) external payable;
}
