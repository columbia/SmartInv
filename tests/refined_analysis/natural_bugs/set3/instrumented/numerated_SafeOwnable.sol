1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.4;
4 
5 /**
6  * This is a contract copied from 'OwnableUpgradeable.sol'
7  * It has the same fundation of Ownable, besides it accept pendingOwner for mor Safe Use
8  */
9 abstract contract SafeOwnable {
10     address private _owner;
11     address private _pendingOwner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     constructor() {
16         _transferOwnership(msg.sender);
17     }
18 
19     function owner() public view returns (address) {
20         return _owner;
21     }
22 
23     modifier onlyOwner() {
24         require(owner() == msg.sender, "Ownable: caller is not the owner");
25         _;
26     }
27 
28     function pendingOwner() public view returns (address) {
29         return _pendingOwner;
30     }
31 
32     function renounceOwnership() public virtual onlyOwner {
33         _transferOwnership(address(0));
34     }
35 
36     function setPendingOwner(address _addr) public onlyOwner {
37         _pendingOwner = _addr;
38     }
39 
40     function acceptOwner() public {
41         require(msg.sender == _pendingOwner, "Ownable: caller is not the pendingOwner"); 
42         _transferOwnership(_pendingOwner);
43         _pendingOwner = address(0);
44     }
45 
46     function _transferOwnership(address newOwner) internal virtual {
47         address oldOwner = _owner;
48         _owner = newOwner;
49         emit OwnershipTransferred(oldOwner, newOwner);
50     }
51 }
