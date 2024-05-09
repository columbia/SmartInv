1 pragma solidity ^0.5.10;
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
31 contract AIOT is SafeMath{
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
55     /* This notifies clients about the amount approved */
56     event Approve(address indexed owner, address indexed spender, uint256 value);
57 
58     /* Initializes contract with initial supply tokens to the creator of the contract */
59     constructor(
60         uint256 initialSupply,
61         string memory tokenName,
62         uint8 decimalUnits,
63         string memory tokenSymbol
64         ) public{
65         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
66         totalSupply = initialSupply;                        // Update total supply
67         name = tokenName;                                   // Set the name for display purposes
68         symbol = tokenSymbol;                               // Set the symbol for display purposes
69         decimals = decimalUnits;                            // Amount of decimals for display purposes
70 		owner = msg.sender;
71     }
72 
73     /* Send coins */
74     function transfer(address _to, uint256 _value) public returns (bool success){
75         require(_to != address(0));                               // Prevent transfer to 0x0 address. Use burn() instead
76 		require(_value >= 0);
77         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
78         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
79         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
80         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
81         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
82         return true;
83     }
84 
85     /* Allow another contract to spend some tokens in your behalf */
86     function approve(address _spender, uint256 _value) public returns (bool success) {
87 		require(_value > 0 );
88         allowance[msg.sender][_spender] = _value;
89         emit Approve(msg.sender, _spender, _value);
90         return true;
91     }
92        
93 
94     /* A contract attempts to get the coins */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         require(_to != address(0));        // Prevent transfer to 0x0 address. Use burn() instead
97 		require(_value >= 0);
98         require(balanceOf[_from] >= _value);        // Check if the sender has enough coins
99         require(balanceOf[_to] + _value >= balanceOf[_to]);     // Check for overflows
100         require(_value <= allowance[_from][msg.sender]);      // Check allowance
101         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
102         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
103         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
104         emit Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function burn(uint256 _value) public returns (bool success) {
109         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
110 		require(_value > 0);
111         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
112         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
113         emit Burn(msg.sender, _value);
114         return true;
115     }
116 	
117 	function freeze(uint256 _value) public returns (bool success) {
118         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough coins
119 		require(_value > 0);
120         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
121         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
122         emit Freeze(msg.sender, _value);
123         return true;
124     }
125 	
126 	function unfreeze(uint256 _value) public returns (bool success) {
127         require(freezeOf[msg.sender] >= _value);        // Check if the sender has enough coins
128 		require(_value > 0);
129         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
130 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
131         emit Unfreeze(msg.sender, _value);
132         return true;
133     }
134 }