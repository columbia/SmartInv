1 pragma solidity ^0.4.16;
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
32 contract CoinealToken is SafeMath{
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint256 public totalSupply;
37 
38     /* This creates an array with all balances */
39     mapping (address => uint256) public balanceOf;
40 	mapping (address => uint256) public freezeOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 	
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
57     function CoinealToken() public {
58 		totalSupply = 10*10**27; // Update total supply
59         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
60         name = "Coineal";                                   // Set the name for display purposes
61         symbol = "NEAL";                               // Set the symbol for display purposes
62         decimals = 18;                            // Amount of decimals for display purposes
63     }
64 
65 	
66 	 /**
67      * Internal transfer, only can be called by this contract
68      */
69     function _transfer(address _from, address _to, uint _value) internal {
70         // Prevent transfer to 0x0 address. Use burn() instead
71         require(_to != 0x0);
72         // Check if the sender has enough
73         require(balanceOf[_from] >= _value);
74         // Check for overflows
75         require(balanceOf[_to] + _value > balanceOf[_to]);
76         // Save this for an assertion in the future
77         uint previousBalances = balanceOf[_from] + balanceOf[_to];
78         // Subtract from the sender
79         balanceOf[_from] -= _value;
80         // Add the same to the recipient
81         balanceOf[_to] += _value;
82         Transfer(_from, _to, _value);
83         // Asserts are used to use static analysis to find bugs in your code. They should never fail
84         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
85     }
86 	
87 
88     /* Send coins */
89     function transfer(address _to, uint256 _value) public{
90 		_transfer(msg.sender,_to,_value);
91         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
92     }
93 
94     /* Allow another contract to spend some tokens in your behalf */
95     function approve(address _spender, uint256 _value) public
96         returns (bool success) {
97 		require(_value>0);
98         allowance[msg.sender][_spender] = _value;
99         return true;
100     }
101        
102 
103     /* A contract attempts to get the coins */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105 		require(_value <= allowance[_from][msg.sender]);  // Check allowance 
106         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
107 		_transfer(_from, _to, _value);
108         Transfer(_from, _to, _value);
109         return true;
110     }
111 
112     function burn(uint256 _value) public returns (bool success) {
113 		require(balanceOf[msg.sender] >= _value);
114 		require(_value > 0);
115         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
116         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
117         Burn(msg.sender, _value);
118         return true;
119     }
120 	
121 	function freeze(uint256 _value) public returns (bool success) {
122 		require(balanceOf[msg.sender] >= _value);
123 		require(_value > 0);
124         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
125         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
126         Freeze(msg.sender, _value);
127         return true;
128     }
129 	
130 	function unfreeze(uint256 _value) public returns (bool success){
131 		require(freezeOf[msg.sender] >= _value); // Check if the sender has enough
132 		require(_value > 0);
133         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
134 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
135         Unfreeze(msg.sender, _value);
136         return true;
137     }
138 	
139 }