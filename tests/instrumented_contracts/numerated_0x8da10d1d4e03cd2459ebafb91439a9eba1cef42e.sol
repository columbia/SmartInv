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
31 contract DBD is SafeMath{
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
57         ) public{
58         totalSupply = 1000000000000000000000000000000;                        // Update total supply
59         name = "DBE Token";                                   // Set the name for display purposes
60         symbol = "DBE";                               // Set the symbol for display purposes
61         decimals = 18;                            // Amount of decimals for display purposes
62 		owner = msg.sender;
63 		balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
64 
65     }
66 
67     /* Send coins */
68     function transfer(address _to, uint256 _value) public
69     returns (bool success){
70         require (_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
71 		require (_value > 0) ; 
72         require (balanceOf[msg.sender] >= _value) ;           // Check if the sender has enough
73         require (balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows
74         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
75         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
76         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
77         return true;
78     }
79 
80     /* Allow another contract to spend some tokens in your behalf */
81     function approve(address _spender, uint256 _value) public
82         returns (bool success) {
83 		require(_value > 0) ; 
84         allowance[msg.sender][_spender] = _value;
85         return true;
86     }
87        
88 
89     /* A contract attempts to get the coins */
90     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
91         require (_to != address(0x0)) ;                                // Prevent transfer to 0x0 address. Use burn() instead
92 		require (_value > 0) ; 
93         require (balanceOf[_from] >= _value) ;                 // Check if the sender has enough
94         require (balanceOf[_to] + _value >= balanceOf[_to]) ;  // Check for overflows
95         require (_value <= allowance[_from][msg.sender]) ;     // Check allowance
96         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
97         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
98         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
99         emit Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function burn(uint256 _value)public returns (bool success) {
104         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
105 		require (_value > 0) ; 
106         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
107         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
108         emit Burn(msg.sender, _value);
109         return true;
110     }
111 	
112 	function freeze(uint256 _value)public returns (bool success) {
113         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
114 		require (_value > 0) ; 
115         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
116         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
117         emit Freeze(msg.sender, _value);
118         return true;
119     }
120 	
121 	function unfreeze(uint256 _value)public returns (bool success) {
122         require (freezeOf[msg.sender] >= _value) ;            // Check if the sender has enough
123 		require (_value > 0) ; 
124         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
125 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
126         emit Unfreeze(msg.sender, _value);
127         return true;
128     }
129 	
130 	// transfer balance to owner
131 	function withdrawEther(uint256 amount) public {
132 		require(msg.sender == owner);
133 		owner.transfer(amount);
134 	}
135 	
136 	// can accept ether
137 	function() external payable  {
138     }
139 }