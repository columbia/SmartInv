1 pragma solidity ^0.4.23;
2 
3 
4 contract MintableTokenIface {
5     function mint(address beneficiary, uint256 amount) public returns (bool);
6     function transfer(address to, uint256 value) public returns (bool);
7 }
8 
9 
10 contract BatchAirDrop {
11     MintableTokenIface public token;
12     address public owner;
13 
14     constructor(MintableTokenIface _token) public {
15         owner = msg.sender;
16         token = _token;
17     }
18 
19     function batchSend(uint256 amount, address[] wallets) public {
20         require(msg.sender == owner);
21         require(amount != 0);
22         for (uint256 i = 0; i < wallets.length; i++) {
23             token.transfer(wallets[i], amount);
24         }
25     }
26 }