1 pragma solidity ^0.5;
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
30 
31   
32 }
33 contract test5cash is SafeMath{
34     string public name;
35     string public symbol;
36     uint8 public decimals;
37     uint256 public totalSupply;
38     address payable public  owner;
39 
40     /* This creates an array with all balances */
41     mapping (address => uint256) public balanceOf;
42 	mapping (address => uint256) public freezeOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     /* This generates a public event on the blockchain that will notify clients */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /* This notifies clients about the amount burnt */
49     event Burn(address indexed from, uint256 value);
50 	
51 	/* This notifies clients about the amount frozen */
52     event Freeze(address indexed from, uint256 value);
53 	
54 	/* This notifies clients about the amount unfrozen */
55     event Unfreeze(address indexed from, uint256 value);
56 
57     /* Initializes contract with initial supply tokens to the creator of the contract */
58      constructor() public {
59 
60         balanceOf[msg.sender] = 500000000000000000000000;              // Give the creator all initial tokens
61         totalSupply = 500000000000000000000000;                        // Update total supply
62         name = "TEST5CASH";                                   // Set the name for display purposes
63         symbol = "TEST5CASH";                               // Set the symbol for display purposes
64         decimals = 18;                            // Amount of decimals for display purposes
65 	owner = msg.sender;
66     }
67 
68     /* Send coins */
69     function transfer(address _to, uint256 _value) public {
70         if (_to == address(0)) revert('transfer');                               // Prevent transfer to 0x0 address. Use burn() instead
71 		if (_value <= 0) revert('transfer'); 
72         if (balanceOf[msg.sender] < _value) revert('transfer');           // Check if the sender has enough
73         if (balanceOf[_to] + _value < balanceOf[_to]) revert('transfer'); // Check for overflows
74         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
75         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
76         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
77     }
78 
79     /* Allow another contract to spend some tokens in your behalf */
80     function approve(address _spender, uint256 _value) public
81         returns (bool success) {
82 		if (_value <= 0) revert('approve'); 
83         allowance[msg.sender][_spender] = _value;
84         return true;
85     }
86        
87 
88     /* A contract attempts to get the coins */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)  {
90         if (_to == address(0)) revert('transferFrom');                                // Prevent transfer to 0x0 address. Use burn() instead
91 		if (_value <= 0) revert('transferFrom'); 
92         if (balanceOf[_from] < _value) revert('transferFrom');                 // Check if the sender has enough
93         if (balanceOf[_to] + _value < balanceOf[_to]) revert('transferFrom');  // Check for overflows
94         if (_value > allowance[_from][msg.sender]) revert('transferFrom');     // Check allowance
95         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
96         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
97         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
98         emit Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function burn(uint256 _value) public returns (bool success) {
103         if (balanceOf[msg.sender] < _value) revert('burn');            // Check if the sender has enough
104 		if (_value <= 0) revert('burn'); 
105         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
106         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
107         emit Burn(msg.sender, _value);
108         return true;
109     }
110 	
111 	function freeze(uint256 _value) public returns (bool success) {
112         if (balanceOf[msg.sender] < _value) revert('freeze');            // Check if the sender has enough
113 		if (_value <= 0) revert('freeze'); 
114         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
115         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
116         emit Freeze(msg.sender, _value);
117         return true;
118     }
119 	
120 	function unfreeze(uint256 _value) public returns (bool success) {
121         if (freezeOf[msg.sender] < _value) revert('unfreeze');            // Check if the sender has enough
122 		if (_value <= 0) revert('unfreeze'); 
123         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
124 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
125         emit Unfreeze(msg.sender, _value);
126         return true;
127     }
128 	
129 	// transfer balance to owner
130 	function withdrawEther(uint256 amount) public {
131 		if(msg.sender != owner) revert('withdrawEther');
132 		owner.transfer(amount);
133 	}
134 	
135 // can accept ether
136 	function () external payable {} 
137 }