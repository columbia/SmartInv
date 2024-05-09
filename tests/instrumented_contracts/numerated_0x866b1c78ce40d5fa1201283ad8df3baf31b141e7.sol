1 pragma solidity ^0.4.19;
2 
3 contract Token {
4     function balanceOf(address) public constant returns (uint);
5     function transfer(address, uint) public returns (bool);
6 }
7 
8 contract Vault {
9     Token constant public token = Token(0xa645264C5603E96c3b0B078cdab68733794B0A71);
10     address constant public recipient = 0x002AE208AD6064F75Fa78e7bbeF9B12DB850f559;
11     // UNIX timestamp
12     uint constant public unlockedAt = 1564704000;
13     
14     function unlock() public {
15         require(now > unlockedAt);
16         uint vaultBalance = token.balanceOf(address(this));
17         token.transfer(recipient, vaultBalance);
18     }
19 }