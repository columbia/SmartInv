1 pragma solidity ^0.4.8;
2 
3 
4 import '../token/linkStandardToken.sol';
5 
6 
7 contract StandardTokenMock is linkStandardToken {
8 
9   function StandardTokenMock(address initialAccount, uint initialBalance)
10   {
11     balances[initialAccount] = initialBalance;
12     totalSupply = initialBalance;
13   }
14 
15 }
