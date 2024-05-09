1 pragma solidity ^0.4.24;
2 
3 // Math operations with safety checks
4 
5 contract SafeMath {
6   function safeMathMul(uint256 a, uint256 b) internal returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function safeMathDiv(uint256 a, uint256 b) internal returns (uint256) {
13     assert(b > 0);
14     uint256 c = a / b;
15     assert(a == b * c + a % b);
16     return c;
17   }
18 
19   function safeMathSub(uint256 a, uint256 b) internal returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function safeMathAdd(uint256 a, uint256 b) internal returns (uint256) {
25     uint256 c = a + b;
26     assert(c>=a && c>=b);
27     return c;
28   }
29 
30   function assert(bool assertion) internal {
31     if (!assertion) {
32       throw;
33     }
34   }
35 }
36 
37 
38 contract BicToken is SafeMath{
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42     uint256 public totalSupply;
43     address public owner;
44 
45     mapping (address => uint256) public balanceOf;
46     mapping (address => uint256) public freezeOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     // Public event on the blockchain to notify clients
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     // Notifies clients about the burnt amount
53     event Burn(address indexed from, uint256 value);
54     
55     // Notifies clients about the amount frozen 
56     event Freeze(address indexed from, uint256 value);
57     
58     // Notifies clients about the amount unfrozen 
59     event Unfreeze(address indexed from, uint256 value);
60 
61     constructor(uint256 initialSupply,string tokenName,uint8 decimalUnits,string tokenSymbol ) {
62         balanceOf[msg.sender] = initialSupply;  // Gives the creator all initial tokens            
63         totalSupply = initialSupply;                    // Update total supply    
64         name = tokenName;                                   // Set the token name
65         symbol = tokenSymbol;                               // Set the token symbol
66         decimals = decimalUnits;                            // Amount of decimals
67         owner = msg.sender;
68     }
69 
70     modifier validAddress {
71         assert(0x0 != msg.sender);
72         _;
73     }
74 
75     // Send coins
76     function transfer(address _to, uint256 _value) validAddress returns (bool success) {
77         require(_value > 0);
78         require(balanceOf[msg.sender] >= _value);
79         require(balanceOf[_to] + _value >= balanceOf[_to]);        
80         balanceOf[msg.sender] = SafeMath.safeMathSub(balanceOf[msg.sender], _value);
81         balanceOf[_to] = SafeMath.safeMathAdd(balanceOf[_to], _value);
82         emit Transfer(msg.sender, _to, _value);                   
83         return true;
84     }
85 
86     // Allow other contract to spend some tokens in your behalf 
87     function approve(address _spender, uint256 _value)
88         returns (bool success) {
89         require(_value > 0);
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93        
94 
95     // A contract attempts to get the coins
96     function transferFrom(address _from, address _to, uint256 _value) validAddress returns (bool success) {
97         require(_value > 0); 
98         require(balanceOf[_from] >= _value);
99         require(balanceOf[_to] + _value >= balanceOf[_to]);
100         require(allowance[_from][msg.sender] >= _value);
101         balanceOf[_from] = SafeMath.safeMathSub(balanceOf[_from], _value);                           
102         balanceOf[_to] = SafeMath.safeMathAdd(balanceOf[_to], _value);                             
103         allowance[_from][msg.sender] = SafeMath.safeMathSub(allowance[_from][msg.sender], _value);
104         emit Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function burn(uint256 _value) returns (bool success) {
109         require(balanceOf[msg.sender] >= _value);
110         require(_value > 0);
111         balanceOf[msg.sender] = SafeMath.safeMathSub(balanceOf[msg.sender], _value);
112         totalSupply = SafeMath.safeMathSub(totalSupply,_value);                     
113         emit Burn(msg.sender, _value);
114         return true;
115     }
116     
117     function freeze(uint256 _value) returns (bool success) {
118         require(balanceOf[msg.sender] >= _value);
119         require(_value > 0);
120         balanceOf[msg.sender] = SafeMath.safeMathSub(balanceOf[msg.sender], _value);                      
121         freezeOf[msg.sender] = SafeMath.safeMathAdd(freezeOf[msg.sender], _value);                        
122         emit Freeze(msg.sender, _value);
123         return true;
124     }
125     
126     function unfreeze(uint256 _value) returns (bool success) {
127         require(freezeOf[msg.sender] >= _value);
128         require(_value > 0);
129         freezeOf[msg.sender] = SafeMath.safeMathSub(freezeOf[msg.sender], _value);                      
130         balanceOf[msg.sender] = SafeMath.safeMathAdd(balanceOf[msg.sender], _value);
131         emit Unfreeze(msg.sender, _value);
132         return true;
133     }    
134 }