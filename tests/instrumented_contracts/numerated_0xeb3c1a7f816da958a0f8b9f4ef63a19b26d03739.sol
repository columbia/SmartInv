1 pragma solidity ^0.4.2;
2 
3 contract storadge {
4     
5     event log(string description);
6     
7 	function save(
8         string mdhash
9     )
10     {
11         log(mdhash);
12     }
13 }