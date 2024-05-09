1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
8     uint256 c = a * b;
9     sure(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
14     sure(b > 0);
15     uint256 c = a / b;
16     sure(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
21     sure(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
26     uint256 c = a + b;
27     sure(c>=a && c>=b);
28     return c;
29   }
30 
31   function sure(bool assertion) pure internal {
32     require(assertion==true);
33   }
34 }
35 contract LichCoin is SafeMath{
36     string public name;
37     string public symbol;
38     uint8 public decimals;
39     uint256 public totalSupply;
40 	address payable public owner;
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
60     constructor(
61         uint256 initialSupply,
62         string memory tokenName,
63         uint8 decimalUnits,
64         string memory tokenSymbol) public {
65         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
66         totalSupply = initialSupply;                        // Update total supply
67         name = tokenName;                                   // Set the name for display purposes
68         symbol = tokenSymbol;                               // Set the symbol for display purposes
69         decimals = decimalUnits;                            // Amount of decimals for display purposes
70 		owner = msg.sender;
71     }
72     
73 
74     /* Send coins */
75     function transfer(address _to, uint256 _value) public {
76         require(_to != 0x0000000000000000000000000000000000000000);                         // Prevent transfer to 0x0 address. Use burn() instead
77         require(_value > 0);
78 		require(balanceOf[msg.sender] >= _value);                                           // Check if the sender has enough
79         require(balanceOf[_to] + _value >= balanceOf[_to]);                                 // Check for overflows       
80         
81         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
82         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                          // Add the same to the recipient
83         emit Transfer(msg.sender, _to, _value);                                             // Notify anyone listening that this transfer took place
84     }
85 
86     /* Allow another contract to spend some tokens in your behalf */
87     function approve(address _spender, uint256 _value) public returns (bool success) {
88 		if (_value <= 0) revert();
89         allowance[msg.sender][_spender] = _value;
90         return true;
91     }
92        
93 
94     /* A contract attempts to get the coins */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         if (_to == 0x0000000000000000000000000000000000000000) revert();                    // Prevent transfer to 0x0 address. Use burn() instead
97 		if (_value <= 0) revert(); 
98         if (balanceOf[_from] < _value) revert();                                            // Check if the sender has enough
99         if (balanceOf[_to] + _value < balanceOf[_to]) revert();                             // Check for overflows
100         if (_value > allowance[_from][msg.sender]) revert();                                // Check allowance
101         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                      // Subtract from the sender
102         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                          // Add the same to the recipient
103         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
104         emit Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function burn(uint256 _value) public returns (bool success) {
109         if (balanceOf[msg.sender] < _value) revert();                                       // Check if the sender has enough
110 		if (_value <= 0) revert(); 
111         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
112         totalSupply = SafeMath.safeSub(totalSupply,_value);                                 // Updates totalSupply
113         emit Burn(msg.sender, _value);
114         return true;
115     }
116 	
117 	function freeze(uint256 _value) public returns (bool success) {
118         if (balanceOf[msg.sender] < _value) revert();                                       // Check if the sender has enough
119 		if (_value <= 0) revert(); 
120         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
121         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);              // Updates totalSupply
122         emit Freeze(msg.sender, _value);
123         return true;
124     }
125 	
126 	function unfreeze(uint256 _value) public returns (bool success) {
127         if (freezeOf[msg.sender] < _value) revert();                                        // Check if the sender has enough
128 		if (_value <= 0) revert(); 
129         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);              // Subtract from the sender
130 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
131         emit Unfreeze(msg.sender, _value);
132         return true;
133     }
134 	
135 	// transfer balance to owner
136 	function withdrawEther(uint256 amount) public {
137 		if(msg.sender != owner) revert();
138 		owner.transfer(amount);
139 	}
140 	
141 	// can accept ether
142 	function() payable external{
143     }
144 }