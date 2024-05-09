1 pragma solidity ^0.4.8;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
10     assert(b > 0);
11     uint256 c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
20     uint256 c = a + b;
21     assert(c>=a && c>=b);
22     return c;
23   }
24 
25   function assert(bool assertion) internal {
26     if (!assertion) {
27       throw;
28     }
29   }
30 }
31 
32 contract Falcon is SafeMath{
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint256 public totalSupply;
37 	address public owner;
38 
39     mapping (address => uint256) public balanceOf;
40 	mapping (address => uint256) public freezeOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     event Burn(address indexed from, uint256 value);
46 	
47     event Freeze(address indexed from, uint256 value);
48 	
49     event Unfreeze(address indexed from, uint256 value);
50 	
51 
52     function Falcon(
53         uint256 initialSupply,
54         string tokenName,
55         uint8 decimalUnits,
56         string tokenSymbol
57         ) {
58         balanceOf[msg.sender] = initialSupply;
59         totalSupply = initialSupply;
60         name = tokenName;
61         symbol = tokenSymbol;
62         decimals = decimalUnits;
63 		owner = msg.sender;
64     }
65 
66     function transfer(address _to, uint256 _value) {
67         if (_to == 0x0) throw;
68 		if (_value <= 0) throw; 
69         if (balanceOf[msg.sender] < _value) throw;
70         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
71         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
72         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
73         Transfer(msg.sender, _to, _value);
74     }
75 
76     function approve(address _spender, uint256 _value)
77         returns (bool success) {
78 		if (_value <= 0) throw; 
79         allowance[msg.sender][_spender] = _value;
80         return true;
81     }   
82 
83     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
84         if (_to == 0x0) throw;
85 		if (_value <= 0) throw; 
86         if (balanceOf[_from] < _value) throw;
87         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
88         if (_value > allowance[_from][msg.sender]) throw;
89         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
90         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
91         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
92         Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     function burn(uint256 _value) returns (bool success) {
97         if (balanceOf[msg.sender] < _value) throw;
98 		if (_value <= 0) throw; 
99         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
100         totalSupply = SafeMath.safeSub(totalSupply,_value);
101         Burn(msg.sender, _value);
102         return true;
103     }
104 	
105 	function freeze(uint256 _value) returns (bool success) {
106         if (balanceOf[msg.sender] < _value) throw;
107 		if (_value <= 0) throw; 
108         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
109         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);
110         Freeze(msg.sender, _value);
111         return true;
112     }
113 	
114 	function unfreeze(uint256 _value) returns (bool success) {
115         if (freezeOf[msg.sender] < _value) throw;
116 		if (_value <= 0) throw;
117         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);
118 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
119         Unfreeze(msg.sender, _value);
120         return true;
121     }
122 	
123 	function withdrawEther(uint256 amount) {
124 		if(msg.sender != owner)throw;
125 		owner.transfer(amount);
126 	}
127 	
128 	function() payable {
129     }
130 }