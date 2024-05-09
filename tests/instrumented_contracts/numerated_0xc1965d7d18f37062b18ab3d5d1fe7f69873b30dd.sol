1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     require(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b > 0);
15     uint256 c = a / b;
16     require(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21     require(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     require(c>=a && c>=b);
28     return c;
29   }
30 }
31 
32 contract CNZ is SafeMath{
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint256 public totalSupply;
37 	address public owner;
38 
39     /* This creates an array with all balances */
40     mapping (address => uint256) public balanceOf;
41 	mapping (address => uint256) public freezeOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     /* This generates a public event on the blockchain that will notify clients */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     /* This notifies clients about the amount burnt */
48     event Burn(address indexed from, uint256 value);
49 	
50 	/* This notifies clients about the amount frozen */
51     event Freeze(address indexed from, uint256 value);
52 	
53 	/* This notifies clients about the amount unfrozen */
54     event Unfreeze(address indexed from, uint256 value);
55 
56     /* Initializes contract with initial supply tokens to the creator of the contract */
57     constructor(
58         uint256 initialSupply,
59         string tokenName,
60         uint8 decimalUnits,
61         string tokenSymbol
62         ) public {
63         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
64         totalSupply = initialSupply;                        // Update total supply
65         name = tokenName;                                   // Set the name for display purposes
66         symbol = tokenSymbol;                               // Set the symbol for display purposes
67         decimals = decimalUnits;                            // Amount of decimals for display purposes
68 		owner = msg.sender;
69     }
70 
71     /* Send coins */
72     function transfer(address _to, uint256 _value) public {
73         require(_to != 0x0);
74         require(_value > 0);
75         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
76         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
77         
78         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
79         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); // Add the same to the recipient
80         emit Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
81     }
82 
83     /* Allow another contract to spend some tokens in your behalf */
84     function approve(address _spender, uint256 _value) public 
85         returns (bool success) {
86         require(_value > 0);
87         
88         allowance[msg.sender][_spender] = _value;
89         return true;
90     }
91        
92 
93     /* A contract attempts to get the coins */
94     function transferFrom(address _from, address _to, uint256 _value) public
95     returns (bool success) {
96         require(_to != 0x0);
97         require(_value > 0);
98         require(balanceOf[_from] >= _value); // Check if the sender has enough
99         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
100         require(_value <= allowance[_from][msg.sender]); // Check for allowance
101         
102         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); // Subtract from the sender
103         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); // Add the same to the recipient
104         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
105         emit Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function burn(uint256 _value) public
110     returns (bool success) {
111         require(_value > 0);
112         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
113 		
114         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
115         totalSupply = SafeMath.safeSub(totalSupply,_value); // Updates totalSupply
116         emit Burn(msg.sender, _value);
117         return true;
118     }
119 	
120 	function freeze(uint256 _value) public
121 	returns (bool success) {
122 	    require(_value > 0);
123         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
124         
125         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
126         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value); // Updates totalSupply
127         emit Freeze(msg.sender, _value);
128         return true;
129     }
130 	
131 	function unfreeze(uint256 _value) public
132 	returns (bool success) {
133 	    require(_value > 0);
134         require(freezeOf[msg.sender] >= _value); // Check if the sender has enough
135         
136         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value); // Subtract from the sender
137 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
138         emit Unfreeze(msg.sender, _value);
139         return true;
140     }
141 	
142 	// transfer balance to owner
143 	function withdrawEther(uint256 amount) public {
144 	    require(msg.sender == owner);
145 		owner.transfer(amount);
146 	}
147 	
148 	// can accept ether
149 	function() payable public{
150     }
151 }