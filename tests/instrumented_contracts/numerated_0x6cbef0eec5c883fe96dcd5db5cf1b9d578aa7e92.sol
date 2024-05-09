1 pragma solidity ^0.4.2;
2 
3 contract VouchCoin  {
4 
5   address public owner;
6   uint public constant totalSupply = 10000000000000000;
7   string public constant name = "VouchCoin";
8   string public constant symbol = "VHC";
9   uint public constant decimals = 8;
10   string public standard = "VouchCoin";
11 
12   mapping (address => uint) public balanceOf;
13 
14   event Transfer(address indexed from, address indexed to, uint value);
15 
16   function VouchCoin() {
17     owner = msg.sender;
18     balanceOf[msg.sender] = totalSupply;
19   }
20 
21   function transfer(address _to, uint _value) returns (bool success) {
22     if (_to == 0x0) throw;
23     if (balanceOf[owner] >= _value && _value > 0) {
24       balanceOf[owner] -= _value;
25       balanceOf[_to] += _value;
26       Transfer(owner, _to, _value);
27       return true;
28     }
29     return false;
30   }
31 
32   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
33     if (_from == 0x0 && _to == 0x0) throw;
34     if (balanceOf[_from] >= _value && _value > 0) {
35       balanceOf[_from] -= _value;
36       balanceOf[_to] += _value;
37       Transfer(_from, _to, _value);
38       return true;
39     }
40     return false;
41   }
42 
43   function () {
44     throw;
45   }
46 }