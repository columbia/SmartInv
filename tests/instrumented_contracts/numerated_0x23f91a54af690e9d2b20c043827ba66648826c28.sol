1 pragma solidity ^0.4.11;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract MyToken {
5     string public standard = 'Token 0.1';
6     string public name = 'One Thousand Coin';
7     string public symbol = '1000';
8     uint8 public decimals = 8;
9     uint256 public totalSupply = 100000000000;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18      function MyToken() {
19         balanceOf[msg.sender] = 100000000000;
20         totalSupply = 100000000000;
21         name = 'One Thousand Coin';
22         symbol = '1000';
23         decimals = 8;
24     }
25 
26     function transfer(address _to, uint256 _value) {
27         if (_to == 0x0) throw;
28         if (balanceOf[msg.sender] < _value) throw;
29         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
30         balanceOf[msg.sender] -= _value;
31         balanceOf[_to] += _value;          
32         Transfer(msg.sender, _to, _value);
33     }
34 
35     function approve(address _spender, uint256 _value)
36         returns (bool success) {
37         allowance[msg.sender][_spender] = _value;
38         return true;
39     }
40 
41     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
42         returns (bool success) {
43         tokenRecipient spender = tokenRecipient(_spender);
44         if (approve(_spender, _value)) {
45             spender.receiveApproval(msg.sender, _value, this, _extraData);
46             return true;
47         }
48     }        
49 
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
51         if (_to == 0x0) throw;
52         if (balanceOf[_from] < _value) throw;
53         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
54         if (_value > allowance[_from][msg.sender]) throw;
55         balanceOf[_from] -= _value;   
56         balanceOf[_to] += _value;
57         allowance[_from][msg.sender] -= _value;
58         Transfer(_from, _to, _value);
59         return true;
60     }
61 
62     function burn(uint256 _value) returns (bool success) {
63         if (balanceOf[msg.sender] < _value) throw;
64         balanceOf[msg.sender] -= _value;
65         totalSupply -= _value;
66         Burn(msg.sender, _value);
67         return true;
68     }
69 
70     function burnFrom(address _from, uint256 _value) returns (bool success) {
71         if (balanceOf[_from] < _value) throw;
72         if (_value > allowance[_from][msg.sender]) throw;
73         balanceOf[_from] -= _value;
74         totalSupply -= _value;
75         Burn(_from, _value);
76         return true;
77     }
78 }