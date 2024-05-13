1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @notice Interface for OperatorRole which wraps a role from
7  * OpenZeppelin's AccessControl for easy integration.
8  */
9 interface IOperatorRole {
10   function isOperator(address account) external view returns (bool);
11 }
