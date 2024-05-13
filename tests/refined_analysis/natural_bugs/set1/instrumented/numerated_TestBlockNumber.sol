1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { BlockNumber } from "../utility/BlockNumber.sol";
5 
6 contract TestBlockNumber is BlockNumber {
7     uint32 private _currentBlockNumber = 1;
8 
9     function setBlockNumber(uint32 newBlockNumber) external {
10         _currentBlockNumber = newBlockNumber;
11     }
12 
13     function currentBlockNumber() external view returns (uint32) {
14         return _currentBlockNumber;
15     }
16 
17     function realBlockNumber() external view returns (uint32) {
18         return super._blockNumber();
19     }
20 
21     function _blockNumber() internal view virtual override returns (uint32) {
22         return _currentBlockNumber;
23     }
24 }
