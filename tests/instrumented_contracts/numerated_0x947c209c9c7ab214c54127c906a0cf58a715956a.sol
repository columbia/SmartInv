1 pragma solidity ^0.4.18;
2 
3 contract TNUSD {
4     string public standard = 'https://www.tntoo.com';
5     string public name = 'Transaction Network USD';
6     string public symbol = 'TNUSD';
7     uint8 public decimals = 18;
8     // 200w  2000000 * 1000000000000000000
9     uint public totalSupply = 2000000000000000000000000;
10 
11     mapping (address => uint) public balanceOf;
12     mapping (address => mapping (address => uint)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint value);
15 
16     function TNUSD() public {
17         balanceOf[msg.sender] = totalSupply;
18     }
19 
20     function _transfer(address _from, address _to, uint _value) internal {
21         require(_to != 0x0);
22         require(balanceOf[_from] >= _value);
23         require(balanceOf[_to] + _value > balanceOf[_to]);
24         uint previousBalances = balanceOf[_from] + balanceOf[_to];
25         balanceOf[_from] -= _value;
26         balanceOf[_to] += _value;
27         Transfer(_from, _to, _value);
28         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
29     }
30 
31     function transfer(address _to, uint _value) public {
32         _transfer(msg.sender, _to, _value);
33     }
34 
35     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
36         require(_value <= allowance[_from][msg.sender]);  
37         allowance[_from][msg.sender] -= _value;
38         _transfer(_from, _to, _value);
39         return true;
40     }
41 
42     function approve(address _spender, uint _value) public returns (bool success) {
43         allowance[msg.sender][_spender] = _value;
44         return true;
45     }
46 }