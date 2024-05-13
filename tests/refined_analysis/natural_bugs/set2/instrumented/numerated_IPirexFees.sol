1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 /**
5  * @title IPirexFees
6  * @notice Interface for managing fee distribution in the PirexEth.
7  * @dev This interface defines functions related to the distribution of fees in the Pirex protocol.
8  * @author redactedcartel.finance
9  */
10 interface IPirexFees {
11     /**
12      * @notice Distributes fees from a specified source.
13      * @dev This function is responsible for distributing fees in the specified token amount.
14      * @param from   address Address representing the source of fees.
15      * @param token  address Address of the fee token.
16      * @param amount uint256 The amount of the fee token to be distributed.
17      */
18     function distributeFees(
19         address from,
20         address token,
21         uint256 amount
22     ) external;
23 }
