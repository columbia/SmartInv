1 pragma solidity ^0.4.8;
2 
3 /**
4  * SafeMath
5  */
6 contract SafeMath {
7   function assert(bool assertion) internal {
8     if (!assertion) {
9       throw;
10     }
11   }
12   
13   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
20     assert(b > 0);
21     uint256 c = a / b;
22     assert(a == b * c + a % b);
23     return c;
24   }
25 
26   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
32     uint256 c = a + b;
33     assert(c>=a && c>=b);
34     return c;
35   }
36 }
37 
38 contract BKB is SafeMath{
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42     uint256 public totalSupply;
43 	address public owner;
44 
45     mapping (address => uint256) public balanceOf;
46 	mapping (address => uint256) public freezeOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     event Burn(address indexed from, uint256 value);
52 	
53     event Freeze(address indexed from, uint256 value);
54 	
55     event Unfreeze(address indexed from, uint256 value);
56 
57     /* Initial */
58     function BKB(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {
59         balanceOf[msg.sender] = initialSupply;    // Owner
60         totalSupply = initialSupply;              // Total Supply
61         name = tokenName;                         // Name
62         symbol = tokenSymbol;                     // Symbol
63         decimals = decimalUnits;                  // decimals
64 		owner = msg.sender;
65     }
66 
67     /* Transfer */
68     function transfer(address _to, uint256 _value) {
69         if (_to == 0x0) throw; 
70 		if (_value <= 0) throw; 
71         if (balanceOf[msg.sender] < _value) throw; 
72         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
73         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);   
74         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); 
75         Transfer(msg.sender, _to, _value);  
76     }
77 
78     /* Approve */
79     function approve(address _spender, uint256 _value) returns (bool success) {
80 		if (_spender == 0x0) throw;
81 		if (_value <= 0) throw; 
82         allowance[msg.sender][_spender] = _value;
83         return true;
84     }
85        
86 
87     /* transferFrom */
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89         if (_to == 0x0) throw;     
90 		if (_value <= 0) throw; 
91         if (balanceOf[_from] < _value) throw; 
92         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
93         if (_value > allowance[_from][msg.sender]) throw;
94         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); 
95         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); 
96         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function burn(uint256 _value) returns (bool success) {
102         if (balanceOf[msg.sender] < _value) throw; 
103 		if (_value <= 0) throw; 
104         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
105         totalSupply = SafeMath.safeSub(totalSupply,_value);
106         Burn(msg.sender, _value);
107         return true;
108     }
109 	
110 	function freeze(uint256 _value) returns (bool success) {
111         if (balanceOf[msg.sender] < _value) throw; 
112 		if (_value <= 0) throw; 
113         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); 
114         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);
115         Freeze(msg.sender, _value);
116         return true;
117     }
118 	
119 	function unfreeze(uint256 _value) returns (bool success) {
120         if (freezeOf[msg.sender] < _value) throw; 
121 		if (_value <= 0) throw; 
122         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value); 
123 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
124         Unfreeze(msg.sender, _value);
125         return true;
126     }
127 	
128 	function withdrawEther(uint256 amount) {
129 		if(msg.sender != owner)throw;
130 		owner.transfer(amount);
131 	}
132 	
133 	function() payable {
134     }
135 }