1 pragma solidity ^0.5.5;
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
31 contract DBE is SafeMath{
32     string public name;
33     string public symbol;
34     uint8 public decimals;
35     uint256 public totalSupply;
36 	address payable public owner;
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
58         string memory tokenName,
59         uint8 decimalUnits,
60         string memory tokenSymbol
61         ) public{
62         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
63         totalSupply = initialSupply;                        // Update total supply
64         name = tokenName;                                   // Set the name for display purposes
65         symbol = tokenSymbol;                               // Set the symbol for display purposes
66         decimals = decimalUnits;                            // Amount of decimals for display purposes
67 		owner = msg.sender;
68     }
69 
70     /* Send coins */
71     function transfer(address _to, uint256 _value) public
72     returns (bool success){
73         require (_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
74 		require (_value > 0) ; 
75         require (balanceOf[msg.sender] >= _value) ;           // Check if the sender has enough
76         require (balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows
77         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
78         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
79         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
80         return true;
81     }
82 
83     /* Allow another contract to spend some tokens in your behalf */
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86 		require(_value > 0) ; 
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90        
91 
92     /* A contract attempts to get the coins */
93     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
94         require (_to != address(0x0)) ;                                // Prevent transfer to 0x0 address. Use burn() instead
95 		require (_value > 0) ; 
96         require (balanceOf[_from] >= _value) ;                 // Check if the sender has enough
97         require (balanceOf[_to] + _value >= balanceOf[_to]) ;  // Check for overflows
98         require (_value <= allowance[_from][msg.sender]) ;     // Check allowance
99         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
100         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
101         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
102         emit Transfer(_from, _to, _value);
103         return true;
104     }
105 
106     function burn(uint256 _value)public returns (bool success) {
107         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
108 		require (_value > 0) ; 
109         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
110         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
111         emit Burn(msg.sender, _value);
112         return true;
113     }
114 	
115 	function freeze(uint256 _value)public returns (bool success) {
116         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
117 		require (_value > 0) ; 
118         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
119         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
120         emit Freeze(msg.sender, _value);
121         return true;
122     }
123 	
124 	function unfreeze(uint256 _value)public returns (bool success) {
125         require (freezeOf[msg.sender] >= _value) ;            // Check if the sender has enough
126 		require (_value > 0) ; 
127         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
128 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
129         emit Unfreeze(msg.sender, _value);
130         return true;
131     }
132 	
133 	// transfer balance to owner
134 	function withdrawEther(uint256 amount) public {
135 		require(msg.sender == owner);
136 		owner.transfer(amount);
137 	}
138 	
139 	// can accept ether
140 	function() external payable  {
141     }
142 }