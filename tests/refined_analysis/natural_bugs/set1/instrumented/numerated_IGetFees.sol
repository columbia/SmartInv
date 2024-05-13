1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @notice An interface for communicating fees to 3rd party marketplaces.
7  * @dev Originally implemented in mainnet contract 0x44d6e8933f8271abcf253c72f9ed7e0e4c0323b3
8  */
9 interface IGetFees {
10   function getFeeRecipients(uint256 id) external view returns (address payable[] memory);
11 
12   function getFeeBps(uint256 id) external view returns (uint256[] memory);
13 }
