1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
5 
6 contract nProxy is ERC1967Proxy {
7     constructor(
8         address _logic,
9         bytes memory _data
10     ) ERC1967Proxy(_logic, _data) {}
11 
12     receive() external payable override {
13         // Allow ETH transfers to succeed
14     }
15 
16     function getImplementation() external view returns (address) {
17         return _getImplementation();
18     }
19 }