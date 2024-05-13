1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.9;
3 
4 /**
5  * Upgrade agent interface inspired by Lunyr.
6  *
7  * Upgrade agent transfers tokens to a new contract.
8  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
9  */
10 abstract contract IUpgradeAgent {
11     function isUpgradeAgent() external virtual pure returns (bool);
12     function upgradeFrom(address _from, uint256 _value) public virtual;
13     function originalSupply() public virtual view returns (uint256);
14     function originalToken() public virtual view returns (address);
15 }
