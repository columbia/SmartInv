1 pragma solidity ^0.4.8;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function assert(bool assertion) internal {
32     if (!assertion) {
33       throw;
34     }
35   }
36 }
37 contract BITXOXO is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42     address public owner;
43     // uint256 public myBalance = this.balance;
44 
45     /* This creates an array with all balances */
46     mapping (address => uint256) public balanceOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     /* This generates a public event on the blockchain that will notify clients */
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52 
53 
54     /* Initializes contract with initial supply tokens to the creator of the contract */
55     function BITXOXO() {
56         balanceOf[msg.sender] = 20000000000000000000000000;              // Give the creator all initial tokens
57         totalSupply = 20000000000000000000000000;                        // Update total supply
58         name = "BITXOXO";                                   // Set the name for display purposes
59         symbol = "XOXO";                               // Set the symbol for display purposes
60         decimals = 18;                            // Amount of decimals for display purposes
61         owner = msg.sender;
62     }
63 
64     /* Send coins */
65     function transfer(address _to, uint256 _value) {
66         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
67 		if (_value <= 0) throw; 
68         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
69         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
70         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
71         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
72         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
73     }
74 
75     /* Allow another contract to spend some tokens in your behalf */
76     function approve(address _spender, uint256 _value)
77         returns (bool success) {
78 		if (_value <= 0) throw; 
79         allowance[msg.sender][_spender] = _value;
80         return true;
81     }
82        
83 
84     /* A contract attempts to get the coins */
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
86         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
87 		if (_value <= 0) throw; 
88         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
89         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
90         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
91         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
92         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
93         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
94         Transfer(_from, _to, _value);
95         return true;
96     }
97 
98   
99 	 
100     function distributeToken(address[] addresses, uint256[] _value) onlyCreator {
101      for (uint i = 0; i < addresses.length; i++) {
102          balanceOf[msg.sender] -= _value[i];
103          balanceOf[addresses[i]] += _value[i];
104          Transfer(msg.sender, addresses[i], _value[i]);
105         }
106     }
107 
108 modifier onlyCreator() {
109         require(msg.sender == owner);   
110         _;
111     }
112 	
113 	// transfer balance to owner
114     function withdrawEther(uint256 amount) {
115 		if(msg.sender != owner)throw;
116 		owner.transfer(amount);
117     }
118 	
119 	// can accept ether
120 	function() payable {
121     }
122 
123     function transferOwnership(address newOwner) onlyCreator public {
124         require(newOwner != address(0));
125         uint256 _leftOverTokens = balanceOf[msg.sender];
126         balanceOf[newOwner] = SafeMath.safeAdd(balanceOf[newOwner], _leftOverTokens);                            // Add the same to the recipient
127         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _leftOverTokens);                     // Subtract from the sender
128         Transfer(msg.sender, newOwner, _leftOverTokens);     
129         owner = newOwner;
130     }
131 
132 }