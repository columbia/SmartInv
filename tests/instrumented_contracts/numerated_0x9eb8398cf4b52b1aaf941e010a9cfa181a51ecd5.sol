1 /*
2 Name : Cryptonia Poker Chips
3 Descrition : Play poker online with cryptocurrency. This blockchain-powered platform lets you play in a fair and safe environment.
4 Url : www.cryptonia.poker
5 */
6 pragma solidity 0.4.23;
7 
8 
9 contract MintableTokenIface {
10     function mint(address beneficiary, uint256 amount) public returns (bool);
11     function transfer(address to, uint256 value) public returns (bool);
12 }
13 
14 
15 contract BatchAirDrop {
16     MintableTokenIface public token;
17     address public owner;
18 
19     constructor(MintableTokenIface _token) public {
20         owner = msg.sender;
21         token = _token;
22     }
23 
24     function batchSend(uint256 amount, address[] wallets) public {
25         require(msg.sender == owner);
26         require(amount != 0);
27         token.mint(this, amount * wallets.length);
28         for (uint256 i = 0; i < wallets.length; i++) {
29             token.transfer(wallets[i], amount);
30         }
31     }
32 }