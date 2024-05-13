1 1  // SPDX-License-Identifier: MIT
2 2  pragma solidity >=0.4.24 <0.6.0;
3 3  
4 4  contract Testoverflow{
5 5     function transfer (address from, address to, uint
6 6     value, uint fee) { 
7 7  
8 8         if (balance[from] < fee + value) revert();
9 9         if (balance[to] + value < balance[to] ||
10 10         balance[msg.sender] + fee < balance[msg.sender])
11 11         revert();
12 12 
13 13         balance[to] += value;
14 14         balance[msg.sender] += fee;
15 15         balance[from] -= value + fee;
16 16     }