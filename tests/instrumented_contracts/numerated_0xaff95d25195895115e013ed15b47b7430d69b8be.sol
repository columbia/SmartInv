1 pragma solidity ^0.5.2;
2 contract Smartcontract_counter {
3     int private count = 0;
4     function incrementCounter() public {
5         count += 1;
6     }
7     function decrementCounter()public {
8         count -= 1;
9     }
10     function getCount() public view returns (int) {
11         return count;
12     }
13 }