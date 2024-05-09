1 pragma solidity ^0.4.11;
2 contract SamsungToken {
3     string public name;
4     string public symbol;
5     uint8 public decimals;
6     /* This creates an array with all balances */
7     mapping(address => uint256) public balanceOf;
8 
9     function SamsungToken() {
10         name = "SamsungToken";
11         symbol = "SamsungToken";
12         decimals = 2;
13         balanceOf[msg.sender] = 88800000000000;
14     }
15 
16     /* Send coins */
17     function transfer(address _to, uint256 _value) {
18         /* Add and subtract new balances */
19         balanceOf[msg.sender] -= _value;
20         balanceOf[_to] += _value;
21     }
22 }