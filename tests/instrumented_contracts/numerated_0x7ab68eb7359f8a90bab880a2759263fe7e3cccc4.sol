1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-06
3 */
4 
5 pragma solidity ^0.4.8;
6 
7 /**
8  * Math operations with safety checks
9  */
10 contract SafeMath {
11   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b > 0);
19     uint256 c = a / b;
20     assert(a == b * c + a % b);
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
30     uint256 c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34 
35   function assert(bool assertion) internal {
36     if (!assertion) {
37       throw;
38     }
39   }
40 }
41 contract ESP is SafeMath{
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     uint256 public totalSupply;
46 	address public owner;
47 
48     /* This creates an array with all balances */
49     mapping (address => uint256) public balanceOf;
50 	mapping (address => uint256) public freezeOf;
51     mapping (address => mapping (address => uint256)) public allowance;
52 
53     /* This generates a public event on the blockchain that will notify clients */
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     /* This notifies clients about the amount burnt */
57     event Burn(address indexed from, uint256 value);
58 	
59 
60     /* Initializes contract with initial supply tokens to the creator of the contract */
61     function ESP(
62         // uint256 initialSupply,
63         // string tokenName,
64         // uint8 decimalUnits,
65         // string tokenSymbol
66         ) {
67         balanceOf[msg.sender] = 83000000*(10**18);              // Give the creator all initial tokens
68         totalSupply = 83000000*(10**18);                        // Update total supply
69         name = 'EasyPay';                                   // Set the name for display purposes
70         symbol = 'ESP';                               // Set the symbol for display purposes
71         decimals = 18;                            // Amount of decimals for display purposes
72 		owner = msg.sender;
73     }
74 
75     /* Send coins */
76     function transfer(address _to, uint256 _value) {
77         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
78 		if (_value <= 0) throw; 
79         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
80         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
81         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
82         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
83         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
84     }
85 
86     /* Allow another contract to spend some tokens in your behalf */
87     function approve(address _spender, uint256 _value)
88         returns (bool success) {
89 		if (_value <= 0) throw; 
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93        
94 
95     /* A contract attempts to get the coins */
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
98 		if (_value <= 0) throw; 
99         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
100         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
101         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
102         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
103         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
104         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
105         Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function burn(uint256 _value) returns (bool success) {
110         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
111 		if (_value <= 0) throw; 
112         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
113         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
114         Burn(msg.sender, _value);
115         return true;
116     }
117 	
118 }