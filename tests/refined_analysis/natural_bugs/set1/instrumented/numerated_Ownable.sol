1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.9;
3 
4 contract Ownable {
5     address private _owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     function owner() public view returns (address) {
10         return _owner;
11     }
12 
13     modifier onlyOwner() {
14         require(_owner == msg.sender || _owner == address(0x0), "Ownable: caller is not the owner");
15         _;
16     }
17 
18     function transferOwnership(address newOwner) public virtual onlyOwner {
19         require(newOwner != address(0), "Ownable: new owner is the zero address");
20         emit OwnershipTransferred(_owner, newOwner);
21         _owner = newOwner;
22     }
23 }