1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "../mixins/roles/AdminRole.sol";
6 
7 import "../interfaces/ISendValueWithFallbackWithdraw.sol";
8 
9 /**
10  * @title Recovers funds in escrow.
11  * @notice Allows recovery of funds that were not successfully transferred directly by the market.
12  */
13 abstract contract WithdrawFromEscrow is AdminRole {
14   /**
15    * @notice Allows an admin to withdraw funds in the market escrow.
16    * @dev This only applies when funds were unable to send, such as due to an out of gas error.
17    * @param market The address of the contract to withdraw from.
18    */
19   function withdrawFromEscrow(ISendValueWithFallbackWithdraw market) external onlyAdmin {
20     market.withdraw();
21   }
22 }
