1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function assert(bool assertion) internal {
29     if (!assertion) {
30       throw;
31     }
32   }
33 }
34 contract APH is SafeMath{
35     string public name;
36     string public symbol;
37     uint8 public decimals;
38     uint256 public totalSupply;
39 	address public owner;
40 
41     /* This creates an array with all balances */
42     mapping (address => uint256) public balanceOf;
43 	mapping (address => uint256) public freezeOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45 
46     /* This generates a public event on the blockchain that will notify clients */
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     /* This notifies clients about the amount burnt */
50     event Burn(address indexed from, uint256 value);
51 	
52 	/* This notifies clients about the amount frozen */
53     event Freeze(address indexed from, uint256 value);
54 	
55 	/* This notifies clients about the amount unfrozen */
56     event Unfreeze(address indexed from, uint256 value);
57 
58     /* Initializes contract with initial supply tokens to the creator of the contract */
59     function APH(uint256 initialSupply,string tokenName,uint8 decimalUnits,string tokenSymbol) {
60         balanceOf[msg.sender] = initialSupply;
61         totalSupply = initialSupply;
62         name = tokenName;
63         symbol = tokenSymbol;
64         decimals = decimalUnits;
65 		owner = msg.sender;
66     }
67 
68     /* Send coins */
69     function transfer(address _to, uint256 _value) {
70         if (_to == 0x0) throw;
71 		if (_value <= 0) throw;
72         if (balanceOf[msg.sender] < _value) throw;
73         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
74         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
75         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
76         Transfer(msg.sender, _to, _value);
77     }
78 
79     /* Allow another contract to spend some tokens in your behalf */
80     function approve(address _spender, uint256 _value)
81         returns (bool success) {
82 		if (_value <= 0) throw; 
83         allowance[msg.sender][_spender] = _value;
84         return true;
85     }
86        
87 
88     /* A contract attempts to get the coins */
89     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
90         if (_to == 0x0) throw;
91 		if (_value <= 0) throw;
92         if (balanceOf[_from] < _value) throw;
93         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
94         if (_value > allowance[_from][msg.sender]) throw;
95         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
96         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                        
97         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
98         Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function burn(uint256 _value) returns (bool success) {
103         if (balanceOf[msg.sender] < _value) throw;
104 		if (_value <= 0) throw;
105         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
106         totalSupply = SafeMath.safeSub(totalSupply,_value);           
107         Burn(msg.sender, _value);
108         return true;
109     }
110 	
111 	function freeze(uint256 _value) returns (bool success) {
112         if (balanceOf[msg.sender] < _value) throw;   
113 		if (_value <= 0) throw;
114         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
115         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                              
116         Freeze(msg.sender, _value);
117         return true;
118     }
119 	
120 	function unfreeze(uint256 _value) returns (bool success) {
121         if (freezeOf[msg.sender] < _value) throw;
122 		if (_value <= 0) throw;
123         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);
124 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
125         Unfreeze(msg.sender, _value);
126         return true;
127     }
128 	
129 	// transfer balance to owner
130 	function withdrawEther(uint256 amount) {
131 		if(msg.sender != owner)throw;
132 		owner.transfer(amount);
133 	}
134 }