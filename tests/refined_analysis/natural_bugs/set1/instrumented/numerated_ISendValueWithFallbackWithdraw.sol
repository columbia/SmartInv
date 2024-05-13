1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @notice Attempt to send ETH and if the transfer fails or runs out of gas, store the balance
7  * for future withdrawal instead.
8  */
9 interface ISendValueWithFallbackWithdraw {
10   /**
11    * @notice Allows a user to manually withdraw funds which originally failed to transfer.
12    */
13   function withdraw() external;
14 }
