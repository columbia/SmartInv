1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 /**
5  * @dev this contract abstracts the block number in order to allow for more flexible control in tests
6  */
7 abstract contract BlockNumber {
8     /**
9      * @dev returns the current block-number
10      */
11     function _blockNumber() internal view virtual returns (uint32) {
12         return uint32(block.number);
13     }
14 }
