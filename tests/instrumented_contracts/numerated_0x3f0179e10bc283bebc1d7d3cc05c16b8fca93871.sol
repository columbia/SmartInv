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
37 contract SQN is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42 	address public owner;
43 
44     /* This creates an array with all balances */
45     mapping (address => uint256) public balanceOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47 
48     /* This generates a public event on the blockchain that will notify clients */
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     /* Initializes contract with initial supply tokens to the creator of the contract */
52     function SQN() {
53         balanceOf[msg.sender] = 1000000000000000000;              // Give the creator all initial tokens
54         totalSupply = 1000000000000000000;                        // Update total supply
55         name = "Super Quantum Network";                                   // Set the name for display purposes
56         symbol = 'SQN';                               // Set the symbol for display purposes
57         decimals = 8;                            // Amount of decimals for display purposes
58 		owner = msg.sender;
59     }
60 
61     /* Send coins */
62     function transfer(address _to, uint256 _value) {
63         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address.
64 		if (_value <= 0) throw; 
65         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
66         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
67         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
68         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
69         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
70     }
71 
72     /* Allow another contract to spend some tokens in your behalf */
73     function approve(address _spender, uint256 _value)
74         returns (bool success) {
75 		if (_value <= 0) throw; 
76         allowance[msg.sender][_spender] = _value;
77         return true;
78     }
79        
80 
81     /* A contract attempts to get the coins */
82     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
83         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address.
84 		if (_value <= 0) throw; 
85         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
86         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
87         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
88         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
89         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
90         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
91         Transfer(_from, _to, _value);
92         return true;
93     }
94 
95 }