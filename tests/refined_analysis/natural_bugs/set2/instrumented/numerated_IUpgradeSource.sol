1 //SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 interface IUpgradeSource {
6   function shouldUpgrade() external view returns (bool, address);
7   function finalizeUpgrade() external;
8 }
