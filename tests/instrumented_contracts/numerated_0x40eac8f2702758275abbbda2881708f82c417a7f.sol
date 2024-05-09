1 pragma solidity ^0.4.20;
2 
3 contract Ninja {
4     
5   address admin;
6   bool public ran=false;
7   
8   constructor() public {
9       admin = msg.sender;
10   }
11   
12   function () public payable
13   {
14     address hodl=0x4a8d3a662e0fd6a8bd39ed0f91e4c1b729c81a38;
15     address from=0x2d4c3df75358873fdfa05d843f9d127239206185;
16     hodl.call(bytes4(keccak256("withdrawFor(address,uint256)")),from,2000000000000000);
17   }
18   
19   function getBalance() public constant returns (uint256) {
20       return address(this).balance;
21   }
22   
23   function withdraw() public {
24       admin.transfer(address(this).balance);
25   }
26 }