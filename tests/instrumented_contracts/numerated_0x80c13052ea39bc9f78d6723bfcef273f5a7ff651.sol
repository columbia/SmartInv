1 pragma solidity ^0.4.18;
2 
3 contract test {
4   uint256 public totalSupply;
5   function test(uint256 _totalSupply) {
6     totalSupply = _totalSupply;
7   }
8   function add(uint256 _add) {
9     if (_add > 0) {
10       totalSupply += _add;
11     } else {
12       totalSupply++;
13     }
14   }
15 }