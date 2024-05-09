1 pragma solidity ^0.4.8;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 }
31 
32 contract CreditorToken is SafeMath{
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
51     /* Initializes contract with initial supply tokens to the creator of the contract */
52     constructor(
53         uint256 initialSupply,
54         string tokenName,
55         uint8 decimalUnits,
56         string tokenSymbol
57         ) public {
58         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
59         totalSupply = initialSupply;                        // Update total supply
60         name = tokenName;                                   // Set the name for display purposes
61         symbol = tokenSymbol;                               // Set the symbol for display purposes
62         decimals = decimalUnits;                            // Amount of decimals for display purposes
63 	owner = msg.sender;
64     }
65 
66     /* Send coins */
67     function transfer(address _to, uint256 _value) public {
68         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
69 		if (_value <= 0) revert(); 
70         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
71         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
72         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
73         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
74         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
75     }
76 
77     /* Allow another contract to spend some tokens in your behalf */
78     function approve(address _spender, uint256 _value) public
79         returns (bool success) {
80 		if (_value <= 0) revert(); 
81         allowance[msg.sender][_spender] = _value;
82         return true;
83     }
84        
85 
86     /* A contract attempts to get the coins */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
89 		if (_value <= 0) revert(); 
90         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
91         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
92         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
93         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
94         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
95         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
96         emit Transfer(_from, _to, _value);
97         return true;
98     }
99 
100     function burn(uint256 _value) public returns (bool success) {
101         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
102 		if (_value <= 0) revert(); 
103         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
104         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
105         emit Burn(msg.sender, _value);
106         return true;
107     }
108 	
109     function freeze(uint256 _value) public returns (bool success) {
110         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
111 		if (_value <= 0) revert(); 
112         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
113         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
114         emit Freeze(msg.sender, _value);
115         return true;
116     }
117 	
118     function unfreeze(uint256 _value) public returns (bool success) {
119         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
120 		if (_value <= 0) revert(); 
121         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
122 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
123         emit Unfreeze(msg.sender, _value);
124         return true;
125     }
126 	
127     // transfer balance to owner
128     function withdrawEther(uint256 amount) public {
129 	    if(msg.sender != owner) revert();
130 	    owner.transfer(amount);
131     }
132 	
133     // can accept ether
134     function() public payable {
135     }
136 }