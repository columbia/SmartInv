1 pragma solidity ^0.4.23;
2 
3 contract Base{
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8     uint256 public tokenUnit = 10 ** uint(decimals);
9     uint256 public kUnit = 1000 * tokenUnit;
10     uint256 public foundingTime;
11 
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16 
17     constructor() public {
18         foundingTime = now;
19     }
20 
21     function _transfer(address _from, address _to, uint256 _value) internal {
22         require(_to != 0x0);
23         require(balanceOf[_from] >= _value);
24         require(balanceOf[_to] + _value > balanceOf[_to]);
25         balanceOf[_from] -= _value;
26         balanceOf[_to] += _value;
27         emit Transfer(_from, _to, _value);
28     }
29 
30     function transfer(address _to, uint256 _value) public {
31         _transfer(msg.sender, _to, _value);
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
35         require(_value <= allowance[_from][msg.sender]);
36         allowance[_from][msg.sender] -= _value;
37         _transfer(_from, _to, _value);
38         return true;
39     }
40 
41     function approve(address _spender, uint256 _value) public returns (bool success) {
42         allowance[msg.sender][_spender] = _value;
43         return true;
44     }
45 }
46 
47 contract ADD is Base {
48     uint256 public release = 63000 * kUnit;
49     constructor() public {
50         totalSupply = release;
51         balanceOf[msg.sender] = totalSupply;
52         name = "Aladdin";
53         symbol = "ADD";
54     }
55 }