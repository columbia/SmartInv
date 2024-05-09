1 pragma solidity 0.5.0;
2 
3 contract Proxy {
4     address private targetAddress;
5 
6     address private admin;
7     constructor() public {
8         targetAddress = 0x1a450D53Aa70650E7d9D7039A2Ee751252c14E16;
9         admin = msg.sender;
10     }
11 
12     function setTargetAddress(address _address) public {
13         require(msg.sender==admin , "Admin only function");
14         require(_address != address(0));
15         targetAddress = _address;
16     }
17 
18     function getContAdr() public view returns (address) {
19         require(msg.sender==admin , "Admin only function");
20         return targetAddress;
21         
22     }
23     function () external payable {
24         address contractAddr = targetAddress;
25         assembly {
26             let ptr := mload(0x40)
27             calldatacopy(ptr, 0, calldatasize)
28             let result := delegatecall(gas, contractAddr, ptr, calldatasize, 0, 0)
29             let size := returndatasize
30             returndatacopy(ptr, 0, size)
31 
32             switch result
33             case 0 { revert(ptr, size) }
34             default { return(ptr, size) }
35         }
36     }
37 }