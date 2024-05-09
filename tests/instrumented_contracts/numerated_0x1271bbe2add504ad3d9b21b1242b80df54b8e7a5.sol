1 pragma solidity ^0.4.16;
2 
3 contract FAUT {
4     string public name = 'FAUT';
5     string public symbol = 'FAUT';
6     uint8 public decimals = 18;
7     uint256 public totalSupply = 1000000000000000000000000;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     function FAUT() public {
15         balanceOf[msg.sender] = totalSupply; 
16     }
17 
18     function _transfer(address _from, address _to, uint _value) internal {
19         require(_to != 0x0);
20         require(balanceOf[_from] >= _value);
21         require(balanceOf[_to] + _value > balanceOf[_to]);
22         uint previousBalances = balanceOf[_from] + balanceOf[_to];
23         balanceOf[_from] -= _value;
24         balanceOf[_to] += _value;
25         Transfer(_from, _to, _value);
26         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
27     }
28 
29     function transfer(address _to, uint256 _value) public {
30         _transfer(msg.sender, _to, _value);
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
34         require(_value <= allowance[_from][msg.sender]);     // Check allowance
35         allowance[_from][msg.sender] -= _value;
36         _transfer(_from, _to, _value);
37         return true;
38     }
39 
40     function approve(address _spender, uint256 _value) public returns (bool success) {
41         allowance[msg.sender][_spender] = _value;
42         return true;
43     }
44 }