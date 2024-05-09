1 / SPDX-License-Identifier: MIT
2  pragma solidity >=0.4.24 <0.6.0;
3  
4  contract ethertest{
5         function pay(address[] recipients,
6                         uint256[] amounts) {
7         require(recipients.length==amounts.length);
8         for (uint i = 0; i < recipients.length; i++) {
9         recipients[i].send(amounts[i]);
10         }
11         }
12  }