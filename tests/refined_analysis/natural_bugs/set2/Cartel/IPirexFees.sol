// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title IPirexFees
 * @notice Interface for managing fee distribution in the PirexEth.
 * @dev This interface defines functions related to the distribution of fees in the Pirex protocol.
 * @author redactedcartel.finance
 */
interface IPirexFees {
    /**
     * @notice Distributes fees from a specified source.
     * @dev This function is responsible for distributing fees in the specified token amount.
     * @param from   address Address representing the source of fees.
     * @param token  address Address of the fee token.
     * @param amount uint256 The amount of the fee token to be distributed.
     */
    function distributeFees(
        address from,
        address token,
        uint256 amount
    ) external;
}
