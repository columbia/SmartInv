1 pragma solidity ^0.4.25;
2 
3 contract Splitter {
4     address[] public addrs;
5     uint256[] public shares;
6     uint256 public denom;
7 
8     constructor(address[] _addrs, uint256[] _shares, uint256 _denom) public {
9         addrs = _addrs;
10         shares = _shares;
11         denom = _denom;
12     }
13     
14     function () payable public {
15         uint256 val = msg.value;
16         for (uint i = 0; i < addrs.length; i++) {
17             addrs[i].transfer(val * shares[i] / denom);
18         }
19     }
20 }