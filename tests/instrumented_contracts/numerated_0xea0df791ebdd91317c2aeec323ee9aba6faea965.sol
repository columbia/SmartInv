1 pragma solidity 0.5.2;
2 
3 
4 
5 contract Medianizer {
6     function read() external returns (bytes32);
7 }
8 
9 
10 contract Test {
11     Medianizer public medianizer;
12     
13     bytes32 public q;
14     uint public w;
15     
16     function get() public {
17         q = medianizer.read();
18     }
19     
20     function set(address _m) public {
21         medianizer = Medianizer(_m);
22     }
23 }