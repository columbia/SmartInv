1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
5 
6 // Empty proxy for deploying to an address first and then allows the deployer to upgrade
7 // to the implementation later.
8 contract EmptyProxy is UUPSUpgradeable {
9     address internal immutable deployer;
10 
11     constructor()  {
12         deployer = msg.sender;
13     }
14 
15     function _authorizeUpgrade(address newImplementation) internal override {
16         require(msg.sender == deployer);
17     }
18 }