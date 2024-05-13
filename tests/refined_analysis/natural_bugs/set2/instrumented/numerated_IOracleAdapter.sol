1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 /**
5  * @title IOracleAdapter
6  * @notice Interface for Oracle Adapters
7  * @dev This interface defines the methods for interacting with OracleAdapter.
8  * @author redactedcartel.finance
9  */
10 
11 interface IOracleAdapter {
12     /**
13      * @notice Requests a voluntary exit for a specific public key
14      * @dev This function is used to initiate a voluntary exit process.
15      * @param _pubKey bytes The public key of the entity requesting the exit.
16      */
17     function requestVoluntaryExit(bytes calldata _pubKey) external;
18 }
