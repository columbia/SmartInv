1 /**
2  *Submitted for verification at Etherscan.io on 2017-07-06
3 */
4 
5 pragma solidity ^0.4.12;
6 
7 /**   
8  * Math operations with safety checks
9  */
10 contract SafeMath {
11   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b > 0);  
19     uint256 c = a / b;   
20     assert(a == b * c + a % b);
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
30     uint256 c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34 
35   function assert(bool assertion) internal {
36     if (!assertion) {
37       throw;
38     }
39   }
40 }
41 
42  contract owned {
43         address public owner;
44 
45         function owned() {
46             owner = msg.sender;
47         }
48 
49         modifier onlyOwner {
50             require(msg.sender == owner);
51             _;
52         }
53 
54         //所有权转移
55         function transferOwnership(address newOwner) onlyOwner {
56             owner = newOwner;
57         }
58     }
59 
60 contract ALSC is SafeMath,owned{
61     string public name;
62     string public symbol;
63     uint8 public decimals;
64     uint256 public totalSupply;
65 
66 
67     /* This creates an array with all balances */
68     mapping (address => uint256) public balanceOf;
69     mapping (address => mapping (address => uint256)) public allowance;
70     mapping (address => bool) public frozenAccount;
71    
72     event FrozenFunds(address target, bool frozen);
73 
74     /* This generates a public event on the blockchain that will notify clients */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77 	/* This notifies clients about the amount frozen */
78     event Freeze(address indexed from, uint256 value);
79 	
80 	/* This notifies clients about the amount unfrozen */
81     event Unfreeze(address indexed from, uint256 value);
82     
83     event Burn(address indexed from, uint256 value);
84 
85     /* Initializes contract with initial supply tokens to the creator of the contract */
86     function ALSC() {
87         decimals = 18;                            // Amount of decimals for display purposes
88         totalSupply = 3100000000 * (10 ** uint256(decimals));                        // Update total supply
89         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
90         name = "Almighty Safely Chain";                                   // Set the name for display purposes
91         symbol = "ALSC";                               // Set the symbol for display purposes
92     }
93 
94     /* Send coins */
95     function transfer(address _to, uint256 _value) {
96         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
97 		if (_value <= 0) throw; 
98         require(!frozenAccount[msg.sender]);
99         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
100         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
101         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
102         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
103         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
104     }
105 
106     /* Allow another contract to spend some tokens in your behalf */
107     function approve(address _spender, uint256 _value)
108         returns (bool success) {
109 		if (_value <= 0) throw; 
110         allowance[msg.sender][_spender] = _value;
111         return true;
112     }
113        
114 
115     /* A contract attempts to get the coins */
116     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
117         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
118 		if (_value <= 0) throw; 
119         require(!frozenAccount[msg.sender]);
120         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
121         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
122         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
123         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
124         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
125         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129     
130  
131     function burn(uint256 _value) returns (bool success) {
132         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
133 		if (_value <= 0) throw; 
134         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
135         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
136         Burn(msg.sender, _value);
137         return true;
138     }
139 
140 
141 	function freezeAccount(address target, bool freeze) onlyOwner {
142         frozenAccount[target] = freeze;
143         FrozenFunds(target, freeze);
144     }
145 	
146 	// transfer balance to owner
147 	function withdrawEther(uint256 amount) {
148 		if(msg.sender != owner)throw;
149 		owner.transfer(amount);
150 	}
151 	
152 	// can accept ether
153 	function() payable {
154     }
155 }