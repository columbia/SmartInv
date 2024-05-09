1 pragma solidity ^0.4.8;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract owned {
5     address public owner;
6 
7     function owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         if (msg.sender != owner) revert();
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner {
17         owner = newOwner;
18     }
19 }
20 
21 contract MyToken is owned {
22     string public standard = 'Token 0.1';
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34 
35     function MyToken(
36         uint256 initialSupply,
37         string tokenName,
38         uint8 decimalUnits,
39         string tokenSymbol
40         ) {
41         balanceOf[msg.sender] = initialSupply;
42         totalSupply = initialSupply; 
43         name = tokenName;
44         symbol = tokenSymbol;
45         decimals = decimalUnits;
46     }
47 
48     function transfer(address _to, uint256 _value) {
49         if (_to == 0x0) revert(); 
50         if (balanceOf[msg.sender] < _value) revert();
51         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
52         balanceOf[msg.sender] -= _value;
53         balanceOf[_to] += _value;
54         Transfer(msg.sender, _to, _value);
55     }
56 
57     function mintToken(address target, uint256 mintedAmount) onlyOwner {
58         balanceOf[target] += mintedAmount;
59         totalSupply += mintedAmount;
60         Transfer(0, owner, mintedAmount);
61         Transfer(owner, target, mintedAmount);
62     }
63 
64     function approve(address _spender, uint256 _value)
65         returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69 
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         returns (bool success) {
72         tokenRecipient spender = tokenRecipient(_spender);
73         if (approve(_spender, _value)) {
74             spender.receiveApproval(msg.sender, _value, this, _extraData);
75             return true;
76         }
77     }        
78 
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
80         if (_to == 0x0) revert();
81         if (balanceOf[_from] < _value) revert();
82         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
83         if (_value > allowance[_from][msg.sender]) revert();
84         balanceOf[_from] -= _value;
85         balanceOf[_to] += _value;
86         allowance[_from][msg.sender] -= _value;
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function burn(uint256 _value) returns (bool success) {
92         if (balanceOf[msg.sender] < _value) revert();
93         balanceOf[msg.sender] -= _value;
94         totalSupply -= _value;
95         Burn(msg.sender, _value);
96         return true;
97     }
98 
99     function burnFrom(address _from, uint256 _value) returns (bool success) {
100         if (balanceOf[_from] < _value) revert();
101         if (_value > allowance[_from][msg.sender]) revert();
102         balanceOf[_from] -= _value;
103         totalSupply -= _value;
104         Burn(_from, _value);
105         return true;
106     }
107 }