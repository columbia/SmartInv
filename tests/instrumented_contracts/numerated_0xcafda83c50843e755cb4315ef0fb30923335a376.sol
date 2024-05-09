1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b > 0);
18     uint256 c = a / b;
19     assert(a == b * c + a % b);
20     return c;
21   }
22 
23   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c>=a && c>=b);
31     return c;
32   }
33   
34 }
35 contract BEB is SafeMath{
36     string public name;
37     string public symbol;
38     uint8 public decimals;
39     uint256 public totalSupply;
40 	address public owner;
41 
42     /* This creates an array with all balances */
43     mapping (address => uint256) public balanceOf;
44 	mapping (address => uint256) public freezeOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     /* This generates a public event on the blockchain that will notify clients */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     /* This notifies clients about the amount burnt */
51     event Burn(address indexed from, uint256 value);
52 	
53 	/* This notifies clients about the amount frozen */
54     event Freeze(address indexed from, uint256 value);
55 	
56 	/* This notifies clients about the amount unfrozen */
57     event Unfreeze(address indexed from, uint256 value);
58 
59     /* Initializes contract with initial supply tokens to the creator of the contract */
60     function BEB(
61         uint256 initialSupply,
62         string tokenName,
63         uint8 decimalUnits,
64         string tokenSymbol,
65         address holder
66         )  public{
67         balanceOf[holder] = initialSupply;              // Give the creator all initial tokens
68         totalSupply = initialSupply;                        // Update total supply
69         name = tokenName;                                   // Set the name for display purposes
70         symbol = tokenSymbol;                               // Set the symbol for display purposes
71         decimals = decimalUnits;                            // Amount of decimals for display purposes
72 		owner = holder;
73     }
74 
75     /* Send coins */
76     function transfer(address _to, uint256 _value) public{
77         require(_to != 0x0);  // Prevent transfer to 0x0 address. Use burn() instead
78 		require(_value > 0); 
79         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
80         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
81         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
82         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
83         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
84     }
85 
86     /* Allow another contract to spend some tokens in your behalf */
87     function approve(address _spender, uint256 _value) public
88         returns (bool success) {
89 		require(_value > 0); 
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93        
94 
95     /* A contract attempts to get the coins */
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
98 		require(_value > 0); 
99         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
100         require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
103         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
104         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
105         Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function burn(uint256 _value) public returns (bool success) {
110         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
111 		require(_value > 0); 
112         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
113         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
114         Burn(msg.sender, _value);
115         return true;
116     }
117 	
118 	function freeze(uint256 _value) public returns (bool success) {
119         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
120 		require(_value > 0); 
121         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
122         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
123         Freeze(msg.sender, _value);
124         return true;
125     }
126 	
127 	function unfreeze(uint256 _value) public returns (bool success) {
128         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
129 		require(_value > 0); 
130         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
131 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
132         Unfreeze(msg.sender, _value);
133         return true;
134     }
135 
136 	// can accept ether
137 	function() payable public{
138     }
139 }