1 pragma solidity ^0.8.13;
2 // SPDX-License-Identifier: MIT
3 
4 contract OriginStampContract {
5 
6     address private owner;
7 
8     event Submitted(bytes32 indexed pHash);
9 
10     // event for EVM logging
11     event OwnerSet(address indexed oldOwner, address indexed newOwner);
12 
13     modifier isOwner() {
14         require(msg.sender == owner, "Caller is not owner");
15         _;
16     }
17 
18     constructor() {
19 	    owner = msg.sender;
20 	    emit OwnerSet(address(0), owner);
21     }
22 
23     function submitHash(bytes32 pHash) public isOwner() {
24         emit Submitted(pHash);
25     }
26 
27     function getOwner() external view returns (address) {
28             return owner;
29     }
30 }