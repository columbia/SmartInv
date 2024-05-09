1 pragma solidity ^0.4.10;
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
34 
35 contract DLT is SafeMath{
36     string public name;
37     string public symbol;
38     uint8 public decimals;
39     uint256 public totalSupply;
40     address public owner;
41 
42     mapping (address => uint256) public balanceOf;
43     mapping (address => uint256) public freezeOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     event Burn(address indexed from, uint256 value);
49 
50     event Freeze(address indexed from, uint256 value);
51 
52     event Unfreeze(address indexed from, uint256 value);
53 
54     function DLT(
55         uint256 initialSupply,
56         string tokenName,
57         uint8 decimalUnits,
58         string tokenSymbol
59         ) {
60         balanceOf[msg.sender] = initialSupply;              
61         totalSupply = initialSupply;                        
62         name = tokenName;                                   
63         symbol = tokenSymbol;                               
64         decimals = decimalUnits;                            
65         owner = msg.sender;
66     }
67 
68     function transfer(address _to, uint256 _value) {
69         if (_to == 0x0) throw;                               
70         if (_value <= 0) throw; 
71         if (balanceOf[msg.sender] < _value) throw;           
72         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
73         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     
74         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            
75         Transfer(msg.sender, _to, _value);                  
76     }
77 
78     function approve(address _spender, uint256 _value)
79         returns (bool success) {
80         if (_value <= 0) throw; 
81         allowance[msg.sender][_spender] = _value;
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
86         if (_to == 0x0) throw;                                
87         if (_value <= 0) throw; 
88         if (balanceOf[_from] < _value) throw;                 
89         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
90         if (_value > allowance[_from][msg.sender]) throw;     
91         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           
92         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             
93         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
94         Transfer(_from, _to, _value);
95         return true;
96     }
97 
98     function batch(address []toAddr, uint256 []value) returns (bool){
99         require(toAddr.length == value.length && toAddr.length >= 1);
100         for(uint256 i = 0 ; i < toAddr.length; i++){
101             transfer(toAddr[i], value[i]);
102         }   
103     }
104 
105     function burn(uint256 _value) returns (bool success) {
106         if (balanceOf[msg.sender] < _value) throw;            
107         if (_value <= 0) throw; 
108         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      
109         totalSupply = SafeMath.safeSub(totalSupply,_value);                                
110         Burn(msg.sender, _value);
111         return true;
112     }
113 
114     function freeze(uint256 _value) returns (bool success) {
115         if (balanceOf[msg.sender] < _value) throw;            
116         if (_value <= 0) throw; 
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      
118         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                
119         Freeze(msg.sender, _value);
120         return true;
121     }
122 
123     function unfreeze(uint256 _value) returns (bool success) {
124         if (freezeOf[msg.sender] < _value) throw;            
125         if (_value <= 0) throw; 
126         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      
127         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
128         Unfreeze(msg.sender, _value);
129         return true;
130     }
131 
132     function withdrawEther(uint256 amount) {
133         if(msg.sender != owner)throw;
134         owner.transfer(amount);
135     }
136 
137     function() payable {
138     }
139 }