1 pragma solidity ^0.4.18;
2 contract HangSengToken {
3     string public name;
4     string public symbol;
5     uint8 public decimals;
6     uint256 public totalSupply;
7     mapping (address => uint256) public balanceOf;
8     mapping (address => mapping (address => uint256)) public allowance;
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Burn(address indexed from, uint256 value);
11     function HangSengToken(
12         uint256 initialSupply,
13         string tokenName,
14         uint8 decimalUnits,
15         string tokenSymbol
16         ) {
17         balanceOf[msg.sender] = initialSupply;
18         totalSupply = initialSupply;
19         name = tokenName;
20         symbol = tokenSymbol;
21         decimals = decimalUnits;
22     }
23     function approve(address _spender, uint256 _value)
24         returns (bool success) {
25         allowance[msg.sender][_spender] = _value;
26         return true;
27     }
28     function transfer(address _to, uint256 _value) {
29         if (_to == 0x0) throw;
30         if (balanceOf[msg.sender] < _value) throw;
31         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
32         balanceOf[msg.sender] -= _value;
33         balanceOf[_to] += _value;
34         Transfer(msg.sender, _to, _value);
35     }
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
37         if (_to == 0x0) throw;
38         if (balanceOf[_from] < _value) throw;
39         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
40         if (_value > allowance[_from][msg.sender]) throw;
41         balanceOf[_from] -= _value;
42         balanceOf[_to] += _value;
43         allowance[_from][msg.sender] -= _value;
44         Transfer(_from, _to, _value);
45         return true;
46     }
47 }