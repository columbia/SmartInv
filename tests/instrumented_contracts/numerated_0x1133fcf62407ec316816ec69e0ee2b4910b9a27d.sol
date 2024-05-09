1 pragma solidity ^0.4.18;
2 
3 contract GOLD {
4     string public name = "GOLD";
5     string public symbol = "GOLD";
6     uint8 public decimals = 0;
7     uint256 public totalSupply = 30000000;
8     mapping (address => uint256) public balanceOf;
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     function GOLD() public {
11         balanceOf[msg.sender] = totalSupply;
12     }
13 
14     function transfer(address _to, uint256 _value) public {
15         require(balanceOf[msg.sender] >= _value);
16         require(balanceOf[_to] + _value > balanceOf[_to]);
17         uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];
18         balanceOf[msg.sender] -= _value;
19         balanceOf[_to] += _value;
20         Transfer(msg.sender, _to, _value);
21         assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
22     }
23 
24 }