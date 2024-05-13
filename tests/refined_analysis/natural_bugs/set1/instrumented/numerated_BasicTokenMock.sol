1 pragma solidity ^0.4.8;
2 
3 
4 import '../token/linkBasicToken.sol';
5 
6 
7 // mock class using BasicToken
8 contract BasicTokenMock is linkBasicToken {
9 
10   function BasicTokenMock(address initialAccount, uint initialBalance)
11   {
12     balances[initialAccount] = initialBalance;
13     totalSupply = initialBalance;
14   }
15 
16 }
