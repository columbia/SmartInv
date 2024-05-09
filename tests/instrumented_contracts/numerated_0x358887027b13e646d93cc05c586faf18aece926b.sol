1 pragma solidity ^0.4.18;
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
32     require (assertion);
33   }
34 }
35 contract REL is SafeMath{
36     uint previousBalances;
37     uint currentBalance;
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42 	address public owner;
43 
44     /* This creates an array with all balances */
45     mapping (address => uint256) public balanceOf;
46 	mapping (address => uint256) public freezeOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     /* This generates a public event on the blockchain that will notrequirey clients */
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     /* This notrequireies clients about the amount burnt */
53     event Burn(address indexed from, uint256 value);
54 	
55 	/* This notrequireies clients about the amount frozen */
56     event Freeze(address indexed from, uint256 value);
57 	
58 	/* This notrequireies clients about the amount unfrozen */
59     event Unfreeze(address indexed from, uint256 value);
60 
61     /* Initializes contract with initial supply tokens to the creator of the contract */
62     function REL(
63         uint256 initialSupply,
64         string tokenName,
65         uint8 decimalUnits,
66         string tokenSymbol
67         ) {
68         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
69         totalSupply = initialSupply;                        // Update total supply
70         name = tokenName;                                   // Set the name for display purposes
71         symbol = tokenSymbol;                               // Set the symbol for display purposes
72         decimals = decimalUnits;                            // Amount of decimals for display purposes
73 		owner = msg.sender;
74     }
75 	
76 	//change owner
77 	function changeowner(
78         address _newowner
79     )
80     public
81     returns (bool)  {
82         require(msg.sender == owner);
83         require(_newowner != address(0));
84         owner = _newowner;
85         return true;
86     }
87 
88     /* Send coins */
89     function transfer(address _to, uint256 _value) {
90         require (_to != 0x0) ;                               // Prevent transfer to 0x0 address. Use burn() instead
91 		require (_value >= 0); 
92         require (balanceOf[msg.sender] >= _value);           // Check require the sender has enough
93         require (balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows
94         previousBalances=safeAdd(balanceOf[msg.sender],balanceOf[_to]);
95         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
96         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
97         currentBalance=safeAdd(balanceOf[msg.sender],balanceOf[_to]);
98         require(previousBalances==currentBalance);
99         Transfer(msg.sender, _to, _value);                   // Notrequirey anyone listening that this transfer took place
100     }
101 
102     /* Allow another contract to spend some tokens in your behalf */
103     function approve(address _spender, uint256 _value)
104         returns (bool success) {
105 		require (_value >= 0) ; 
106         allowance[msg.sender][_spender] = _value;
107         return true;
108     }
109        
110 
111     /* A contract attempts to get the coins */
112     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
113         require (_to != 0x0) ;                                // Prevent transfer to 0x0 address. Use burn() instead
114 		require (_value >= 0) ; 
115         require (balanceOf[_from] >= _value) ;                 // Check require the sender has enough
116         require (balanceOf[_to] + _value >= balanceOf[_to])  ;  // Check for overflows
117         require (allowance[_from][msg.sender]>=_value) ;     // Check allowance
118         previousBalances=safeAdd(balanceOf[_from],balanceOf[_to]);
119         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
120         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
121         currentBalance=safeAdd(balanceOf[_from],balanceOf[_to]);
122         require(previousBalances==currentBalance);
123         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
124         Transfer(_from, _to, _value);
125         return true;
126     }
127 
128     function burn(uint256 _value) returns (bool success) {
129         require(msg.sender == owner);
130         require (balanceOf[msg.sender] >= _value) ;            // Check require the sender has enough
131 		require (_value >= 0) ; 
132         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
133         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
134         Burn(msg.sender, _value);
135         return true;
136     }
137 	
138 	function freeze(uint256 _value) returns (bool success) {
139         require(msg.sender == owner);
140         require (balanceOf[msg.sender] >= _value) ;            // Check require the sender has enough
141 		require (_value >= 0) ; 
142         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
143         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
144         Freeze(msg.sender, _value);
145         return true;
146     }
147 	
148 	function unfreeze(uint256 _value) returns (bool success) {
149         require(msg.sender == owner);
150         require (freezeOf[msg.sender] >= _value) ;            // Check require the sender has enough
151 		require (_value >= 0) ; 
152         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
153 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
154         Unfreeze(msg.sender, _value);
155         return true;
156     }
157 	
158 	// transfer balance to owner
159 	function withdrawEther(uint256 amount) {
160 		require(msg.sender == owner);
161 		owner.transfer(amount);
162 	}
163 	
164 	// can accept ether
165 	function() payable {
166     }
167 }