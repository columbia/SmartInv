1 pragma solidity ^0.4.18;
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
34 contract FAR is SafeMath{
35     string public name;
36     string public symbol;
37     uint8 public decimals;
38     uint256 public totalSupply;
39 	address public owner;
40 
41     mapping (address => uint256) public balanceOf;
42 	mapping (address => uint256) public freezeOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Burn(address indexed from, uint256 value);
47     event Freeze(address indexed from, uint256 value);
48     event Unfreeze(address indexed from, uint256 value);
49 
50     function FAR(
51         uint256 initialSupply,
52         string tokenName,
53         uint8 decimalUnits,
54         string tokenSymbol
55         ) {
56         balanceOf[msg.sender] = initialSupply;              
57         totalSupply = initialSupply;                        
58         name = tokenName;                                   
59         symbol = tokenSymbol;                               
60         decimals = decimalUnits;                           
61 		owner = msg.sender;
62     }
63 
64     function transfer(address _to, uint256 _value) {
65         if (_to == 0x0) throw;                               
66 		if (_value <= 0) throw; 
67         if (balanceOf[msg.sender] < _value) throw;           
68         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
69         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                  
70         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                           
71         Transfer(msg.sender, _to, _value);                  
72     }
73 
74     function approve(address _spender, uint256 _value)
75         returns (bool success) {
76 		if (_value <= 0) throw; 
77         allowance[msg.sender][_spender] = _value;
78         return true;
79     }
80        
81     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
82         if (_to == 0x0) throw;                                
83 		if (_value <= 0) throw; 
84         if (balanceOf[_from] < _value) throw;                 
85         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
86         if (_value > allowance[_from][msg.sender]) throw;     
87         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         
88         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            
89         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
90         Transfer(_from, _to, _value);
91         return true;
92     }
93 
94     function burn(uint256 _value) returns (bool success) {
95         if (balanceOf[msg.sender] < _value) throw;          
96 		if (_value <= 0) throw; 
97         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                    
98         totalSupply = SafeMath.safeSub(totalSupply,_value);                               
99         Burn(msg.sender, _value);
100         return true;
101     }
102 	
103 	function freeze(uint256 _value) returns (bool success) {
104         if (balanceOf[msg.sender] < _value) throw;            
105 		if (_value <= 0) throw; 
106         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      
107         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                             
108         Freeze(msg.sender, _value);
109         return true;
110     }
111 	
112 	function unfreeze(uint256 _value) returns (bool success) {
113         if (freezeOf[msg.sender] < _value) throw;           
114 		if (_value <= 0) throw; 
115         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                     
116 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
117         Unfreeze(msg.sender, _value);
118         return true;
119     }
120 	
121 	function withdrawEther(uint256 amount) {
122 		if(msg.sender != owner)throw;
123 		owner.transfer(amount);
124 	}
125 	
126 	function() payable {
127     }
128 	
129 }