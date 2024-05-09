1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-23
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2017-07-06
7 */
8 
9 pragma solidity ^0.4.12;
10 
11 /**   
12  * Math operations with safety checks
13  */
14 contract SafeMath {
15   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b > 0);  
23     uint256 c = a / b;   
24     assert(a == b * c + a % b);
25     return c;
26   }
27 
28   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
34     uint256 c = a + b;
35     assert(c>=a && c>=b);
36     return c;
37   }
38 
39   function assert(bool assertion) internal {
40     if (!assertion) {
41       throw;
42     }
43   }
44 }
45 
46  contract owned {
47         address public owner;
48 
49         function owned() {
50             owner = msg.sender;
51         }
52 
53         modifier onlyOwner {
54             require(msg.sender == owner);
55             _;
56         }
57 
58         //所有权转移
59         function transferOwnership(address newOwner) onlyOwner {
60             owner = newOwner;
61         }
62     }
63 
64 contract A13 is SafeMath,owned{
65     string public name;
66     string public symbol;
67     uint8 public decimals;
68     uint256 public totalSupply;
69 
70 
71     /* This creates an array with all balances */
72     mapping (address => uint256) public balanceOf;
73     mapping (address => mapping (address => uint256)) public allowance;
74     mapping (address => bool) public frozenAccount;
75    
76     event FrozenFunds(address target, bool frozen);
77 
78     /* This generates a public event on the blockchain that will notify clients */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81 	/* This notifies clients about the amount frozen */
82     event Freeze(address indexed from, uint256 value);
83 	
84 	/* This notifies clients about the amount unfrozen */
85     event Unfreeze(address indexed from, uint256 value);
86     
87     event Burn(address indexed from, uint256 value);
88 
89     /* Initializes contract with initial supply tokens to the creator of the contract */
90     function A13() {
91         decimals = 18;                            // Amount of decimals for display purposes
92         totalSupply = 130000000 * (10 ** uint256(decimals));                        // Update total supply
93         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
94         name = "A13";                                   // Set the name for display purposes
95         symbol = "A13";                               // Set the symbol for display purposes
96     }
97 
98     /* Send coins */
99     function transfer(address _to, uint256 _value) {
100         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
101 		if (_value <= 0) throw; 
102         require(!frozenAccount[msg.sender]);
103         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
104         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
105         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
106         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
107         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
108     }
109 
110     /* Allow another contract to spend some tokens in your behalf */
111     function approve(address _spender, uint256 _value)
112         returns (bool success) {
113 		if (_value <= 0) throw; 
114         allowance[msg.sender][_spender] = _value;
115         return true;
116     }
117        
118 
119     /* A contract attempts to get the coins */
120     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
121         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
122 		if (_value <= 0) throw; 
123         require(!frozenAccount[msg.sender]);
124         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
125         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
126         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
127         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
128         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
129         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
130         Transfer(_from, _to, _value);
131         return true;
132     }
133     
134  
135     function burn(uint256 _value) returns (bool success) {
136         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
137 		if (_value <= 0) throw; 
138         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
139         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
140         Burn(msg.sender, _value);
141         return true;
142     }
143 
144 
145 	function freezeAccount(address target, bool freeze) onlyOwner {
146         frozenAccount[target] = freeze;
147         FrozenFunds(target, freeze);
148     }
149 	
150 	// transfer balance to owner
151 	function withdrawEther(uint256 amount) {
152 		if(msg.sender != owner)throw;
153 		owner.transfer(amount);
154 	}
155 	
156 	// can accept ether
157 	function() payable {
158     }
159 }