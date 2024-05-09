1 pragma solidity 0.5.0;
2 
3 contract Proxy {
4     address private targetAddress;
5 
6     address private admin;
7     constructor() public {
8         targetAddress = 0xea265f4004D4536dE02b96E0556200c9Ef68374D;
9         //targetAddress = 0xC139a8c21239f1A6ee193C21388183e33ecA48c7;
10         admin = msg.sender;
11     }
12 
13     function setTargetAddress(address _address) public {
14         require(msg.sender==admin , "Admin only function");
15         require(_address != address(0));
16         targetAddress = _address;
17     }
18 
19     function getContAdr() public view returns (address) {
20         require(msg.sender==admin , "Admin only function");
21         return targetAddress;
22         
23     }
24     function () external payable {
25         address contractAddr = targetAddress;
26         assembly {
27             let ptr := mload(0x40)
28             calldatacopy(ptr, 0, calldatasize)
29             let result := delegatecall(gas, contractAddr, ptr, calldatasize, 0, 0)
30             let size := returndatasize
31             returndatacopy(ptr, 0, size)
32 
33             switch result
34             case 0 { revert(ptr, size) }
35             default { return(ptr, size) }
36         }
37     }
38 }