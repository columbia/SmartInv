1 pragma solidity ^0.4.8;
2 
3 contract Token {
4     function balanceOf(address) public constant returns (uint);
5     function transfer(address, uint) public returns (bool);
6 }
7 
8 contract Vault {
9     Token constant public token = Token(0xa645264C5603E96c3b0B078cdab68733794B0A71);
10     address constant public recipient = address(0x70f7F70E3E7497a2dbEA5a47010010be447483b9);
11     // UNIX timestamp
12     uint256 constant public unlockedAt = 1515600000;
13     
14     function unlock() public {
15         if (now < unlockedAt) throw;
16         uint vaultBalance = token.balanceOf(address(this));
17         if (!token.transfer(recipient, vaultBalance)) throw;
18     }
19 }