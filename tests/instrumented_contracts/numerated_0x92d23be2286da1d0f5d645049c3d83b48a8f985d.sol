1 /**
2  *Submitted for verification at Etherscan.io on 2017-07-06
3 */
4 
5 pragma solidity ^0.4.11;
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
41 contract Token is SafeMath{
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     uint256 public totalSupply;
46 	address public owner;
47 
48     /* This creates an array with all balances */
49     mapping (address => uint256) public balanceOf;
50     mapping (address => mapping (address => uint256)) public allowance;
51 
52     /* This generates a public event on the blockchain that will notify clients */
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55 
56     /* Initializes contract with initial supply tokens to the creator of the contract */
57     function Token(
58         uint256 initialSupply,
59         string tokenName,
60         uint8 decimalUnits,
61         string tokenSymbol
62         ) {
63         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
64         totalSupply = initialSupply;                        // Update total supply
65         name = tokenName;                                   // Set the name for display purposes
66         symbol = tokenSymbol;                               // Set the symbol for display purposes
67         decimals = decimalUnits;                            // Amount of decimals for display purposes
68 		owner = msg.sender;
69     }
70 
71     /* Send coins */
72     function transfer(address _to, uint256 _value) {
73         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
74 		if (_value <= 0) throw; 
75         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
76         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
77         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
78         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
79         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
80     }
81 
82     /* Allow another contract to spend some tokens in your behalf */
83     function approve(address _spender, uint256 _value)
84         returns (bool success) {
85 		if (_value <= 0) throw; 
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89        
90 
91     /* A contract attempts to get the coins */
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
94 		if (_value <= 0) throw; 
95         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
96         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
97         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
98         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
99         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
100         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104 
105 	
106 	// can accept ether
107 	function() payable {
108     }
109 }