1 pragma solidity 0.4.24;
2 
3 
4 contract AddressrResolver {
5 
6     address public addr;
7     
8     address owner;
9     
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14     
15     constructor() public {
16         owner = msg.sender;
17     }
18     
19     function changeOwner(address newowner) external onlyOwner {
20         owner = newowner;
21     }
22     
23     function setAddr(address newaddr) external onlyOwner {
24         addr = newaddr;
25     }
26     
27 }