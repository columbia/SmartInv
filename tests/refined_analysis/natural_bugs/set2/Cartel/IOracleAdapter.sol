// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title IOracleAdapter
 * @notice Interface for Oracle Adapters
 * @dev This interface defines the methods for interacting with OracleAdapter.
 * @author redactedcartel.finance
 */

interface IOracleAdapter {
    /**
     * @notice Requests a voluntary exit for a specific public key
     * @dev This function is used to initiate a voluntary exit process.
     * @param _pubKey bytes The public key of the entity requesting the exit.
     */
    function requestVoluntaryExit(bytes calldata _pubKey) external;
}
