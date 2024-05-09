1 pragma solidity ^0.4.16;
2 
3 contract ASCToken {
4 
5     string public name;
6     string public symbol;
7     uint8 public decimals = 2;
8 
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     function ASCToken() public {
17         totalSupply = 60000000000 * 10 ** uint256(decimals);
18         balanceOf[msg.sender] = totalSupply;
19         name = "Ascereum";
20         symbol = "ASC";
21     }
22 
23     function _transfer(address _from, address _to, uint _value) internal {
24         require(_to != 0x0);
25         require(balanceOf[_from] >= _value);
26         require(balanceOf[_to] + _value > balanceOf[_to]);
27         uint previousBalances = balanceOf[_from] + balanceOf[_to];
28         balanceOf[_from] -= _value;
29         balanceOf[_to] += _value;
30         Transfer(_from, _to, _value);
31         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
32     }
33 
34     function transfer(address _to, uint256 _value) public {
35         _transfer(msg.sender, _to, _value);
36     }
37 
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
39         require(_value <= allowance[_from][msg.sender]);     
40         allowance[_from][msg.sender] -= _value;
41         _transfer(_from, _to, _value);
42         return true;
43     }
44 
45     function approve(address _spender, uint256 _value) public returns (bool success) {
46         allowance[msg.sender][_spender] = _value;
47         return true;
48     }
49 }