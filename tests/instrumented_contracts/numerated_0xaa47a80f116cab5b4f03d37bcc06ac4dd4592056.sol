1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function transferFrom(address from, address to, uint tokens) public returns (bool success);
5 }
6 
7 contract BatchTransfer {
8     function transfer(address tokenAddress, address[] to, uint[] tokens) public returns (bool success) {
9         require(to.length > 0);
10         require(to.length <= 100);
11         require(to.length == tokens.length);
12         for (uint8 i = 0; i < to.length; i++) {
13             ERC20Interface(tokenAddress).transferFrom(msg.sender, to[i], tokens[i]);
14         }
15         return true;
16     }
17 }