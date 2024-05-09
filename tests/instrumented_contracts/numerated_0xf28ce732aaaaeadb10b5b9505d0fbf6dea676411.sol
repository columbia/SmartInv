1 pragma solidity 0.4.24;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 }
31 contract CPB is SafeMath{
32     string public name;
33     string public symbol;
34     uint8 public decimals;
35     uint256 public totalSupply;
36 	address public owner;
37 
38     /* This creates an array with all balances */
39     mapping (address => uint256) public balanceOf;
40 	mapping (address => uint256) public freezeOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     /* This generates a public event on the blockchain that will notify clients */
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     /* This notifies clients about the amount burnt */
47     event Burn(address indexed from, uint256 value);
48 	
49 	/* This notifies clients about the amount frozen */
50     event Freeze(address indexed from, uint256 value);
51 	
52 	/* This notifies clients about the amount unfrozen */
53     event Unfreeze(address indexed from, uint256 value);
54 
55     /* Initializes contract with initial supply tokens to the creator of the contract */
56     constructor (
57         uint256 initialSupply,
58         string tokenName,
59         uint8 decimalUnits,
60         string tokenSymbol
61         ) public {
62         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
63         totalSupply = initialSupply;                        // Update total supply
64         name = tokenName;                                   // Set the name for display purposes
65         symbol = tokenSymbol;                               // Set the symbol for display purposes
66         decimals = decimalUnits;                            // Amount of decimals for display purposes
67 		owner = msg.sender;
68     }
69 
70     /* Send coins */
71     function transfer(address _to, uint256 _value) public {
72         assert(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
73 		assert(_value > 0); 
74         assert(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
75         assert(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
76         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
77         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
78         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
79     }
80 
81     /* Allow another contract to spend some tokens in your behalf */
82     function approve(address _spender, uint256 _value) public
83         returns (bool success) {
84 		assert(_value > 0); 
85         allowance[msg.sender][_spender] = _value;
86         return true;
87     }
88 
89 
90     /* A contract attempts to get the coins */
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         assert(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
93 		assert(_value > 0); 
94         assert(balanceOf[_from] >= _value);                 // Check if the sender has enough
95         assert(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
96         assert(_value <= allowance[_from][msg.sender]);     // Check allowance
97         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
98         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
99         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
100         emit Transfer(_from, _to, _value);
101         return true;
102     }
103 
104     function burn(uint256 _value) public returns (bool success) {
105         assert(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
106 		assert(_value > 0); 
107         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
108         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
109         emit Burn(msg.sender, _value);
110         return true;
111     }
112 	
113 	function freeze(uint256 _value) public returns (bool success) {
114         assert(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
115 		assert(_value > 0); 
116         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
117         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
118         emit Freeze(msg.sender, _value);
119         return true;
120     }
121 	
122 	function unfreeze(uint256 _value) public returns (bool success) {
123         assert(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
124 		assert(_value > 0); 
125         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
126 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
127         emit Unfreeze(msg.sender, _value);
128         return true;
129     }
130 }