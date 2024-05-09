1 pragma solidity ^0.4.24;
2 
3 
4 // Math operations with safety checks
5  
6 
7 contract SafeMath {
8   function safeMathMul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeMathDiv(uint256 a, uint256 b) internal returns (uint256) {
15     assert(b > 0);
16     uint256 c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeMathSub(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeMathAdd(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32   function assert(bool assertion) internal {
33     if (!assertion) {
34       throw;
35     }
36   }
37 }
38 
39 contract BicToken is SafeMath{
40     string public name;
41     string public symbol;
42     uint8 public decimals;
43     uint256 public totalSupply;
44     address public owner;
45 
46     mapping (address => uint256) public balanceOf;
47     mapping (address => uint256) public freezeOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     // Public event on the blockchain to notify clients
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     // Notifies clients about the burnt amount
54     event Burn(address indexed from, uint256 value);
55     
56     // Notifies clients about the amount frozen 
57     event Freeze(address indexed from, uint256 value);
58     
59     // Notifies clients about the amount unfrozen 
60     event Unfreeze(address indexed from, uint256 value);
61 
62     constructor(uint256 initialSupply,string tokenName,uint8 decimalUnits,string tokenSymbol ) {
63         balanceOf[msg.sender] = initialSupply;              
64         totalSupply = initialSupply;                        
65         name = tokenName;                                   
66         symbol = tokenSymbol;                               
67         decimals = decimalUnits;                            
68         owner = msg.sender;
69     }
70 
71     modifier validAddress {
72         assert(0x0 != msg.sender);
73         _;
74     }
75 
76     // Send coins
77     function transfer(address _to, uint256 _value) validAddress returns (bool success) {
78         require(_value > 0);
79         require(balanceOf[msg.sender] >= _value);
80         require(balanceOf[_to] + _value >= balanceOf[_to]);        
81         balanceOf[msg.sender] = SafeMath.safeMathSub(balanceOf[msg.sender], _value);
82         balanceOf[_to] = SafeMath.safeMathAdd(balanceOf[_to], _value);
83         emit Transfer(msg.sender, _to, _value);                   
84         return true;
85     }
86 
87     // Allow other contract to spend some tokens in your behalf 
88     function approve(address _spender, uint256 _value)
89         returns (bool success) {
90         require(_value > 0);
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94        
95 
96     // A contract attempts to get the coins
97     function transferFrom(address _from, address _to, uint256 _value) validAddress returns (bool success) {
98         require(_value > 0); 
99         require(balanceOf[_from] >= _value);
100         require(balanceOf[_to] + _value >= balanceOf[_to]);
101         require(allowance[_from][msg.sender] >= _value);
102         balanceOf[_from] = SafeMath.safeMathSub(balanceOf[_from], _value);                           
103         balanceOf[_to] = SafeMath.safeMathAdd(balanceOf[_to], _value);                             
104         allowance[_from][msg.sender] = SafeMath.safeMathSub(allowance[_from][msg.sender], _value);
105         emit Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function burn(uint256 _value) returns (bool success) {
110         require(balanceOf[msg.sender] >= _value);
111         require(_value > 0);
112         balanceOf[msg.sender] = SafeMath.safeMathSub(balanceOf[msg.sender], _value);
113         totalSupply = SafeMath.safeMathSub(totalSupply,_value);                     
114         emit Burn(msg.sender, _value);
115         return true;
116     }
117     
118     function freeze(uint256 _value) returns (bool success) {
119         require(balanceOf[msg.sender] >= _value);
120         require(_value > 0);
121         balanceOf[msg.sender] = SafeMath.safeMathSub(balanceOf[msg.sender], _value);                      
122         freezeOf[msg.sender] = SafeMath.safeMathAdd(freezeOf[msg.sender], _value);                        
123         emit Freeze(msg.sender, _value);
124         return true;
125     }
126     
127     function unfreeze(uint256 _value) returns (bool success) {
128         require(freezeOf[msg.sender] >= _value);
129         require(_value > 0);
130         freezeOf[msg.sender] = SafeMath.safeMathSub(freezeOf[msg.sender], _value);                      
131         balanceOf[msg.sender] = SafeMath.safeMathAdd(balanceOf[msg.sender], _value);
132         emit Unfreeze(msg.sender, _value);
133         return true;
134     }    
135 }