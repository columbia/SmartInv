1 pragma solidity ^0.4.24;
2 
3 contract Sale {
4     address private owner80 = 0xf2b9DA535e8B8eF8aab29956823df7237f1863A3;
5     address private owner20 = 0x29FD9956553b9Ce92e658662b2F73d95CF90A969;
6     uint256 private ether80;
7     uint256 private ether20;
8 
9     function Sale() public {
10 
11     }
12     
13     function() external payable {
14         ether20 = (msg.value)/5;
15         ether80 = (msg.value)-ether20;
16         owner80.transfer(ether80);
17         owner20.transfer(ether20);
18     }
19 }