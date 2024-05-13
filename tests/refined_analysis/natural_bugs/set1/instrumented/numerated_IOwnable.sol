1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IOwnable {
6   /**
7    * @dev Returns the address of the current owner.
8    */
9   function owner() external view returns (address);
10 }
