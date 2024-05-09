1 pragma solidity ^0.5.0;
2 
3 contract Counter {
4    uint256 c;
5 
6    constructor() public {
7        c = 1;
8    }   
9    function inc() external {
10         c = c + 1;
11    }
12    function get() public view returns (uint256)  {
13        return c;
14    }
15 }