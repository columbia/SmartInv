1 pragma solidity ^0.4.23;
2 contract InternalTxsTest {
3     function batch(uint256[] amounts, address[] recipients)
4     public
5     payable
6     {
7         require(amounts.length == recipients.length);
8 
9         for (uint8 i = 0; i < amounts.length; i++) {
10             recipients[i].transfer(amounts[i]);
11         }
12     }
13 }