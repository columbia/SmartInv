1 pragma solidity ^0.4.8;
2 
3 //import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
4 
5 /*
6  * Math operations with safety checks
7  */
8 contract SafeMath {
9   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
16     assert(b > 0);
17     uint256 c = a / b;
18     assert(a == b * c + a % b);
19     return c;
20   }
21 
22   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c>=a && c>=b);
30     return c;
31   }
32 
33   function assert(bool assertion) internal {
34     if (!assertion) {
35       throw;
36     }
37   }
38 }
39 
40 contract ZTT is SafeMath{
41     string public name;
42     string public symbol;
43     uint8 public decimals;
44     uint256 public totalSupply;
45 	address public owner;
46 
47     /* This creates an array with all balances */
48     mapping (address => uint256) public balanceOf;
49 	mapping (address => uint256) public freezeOf;
50     mapping (address => mapping (address => uint256)) public allowance;
51 
52     /* This generates a public event on the blockchain that will notify clients */
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     /* This notifies clients about the amount burnt */
56     event Burn(address indexed from, uint256 value);
57 	
58 	/* This notifies clients about the amount frozen */
59     event Freeze(address indexed from, uint256 value);
60 	
61 	/* This notifies clients about the amount unfrozen */
62     event Unfreeze(address indexed from, uint256 value);
63 
64     /* Initializes contract with initial supply tokens to the creator of the contract */
65     constructor (
66         string tokenName,
67         string tokenSymbol,
68         uint256 initialSupply,
69         uint8 decimalUnits
70         ) public {
71         balanceOf[msg.sender] = SafeMath.safeMul(initialSupply,10 ** uint256(decimalUnits));  // Give the creator all initial tokens
72         totalSupply = balanceOf[msg.sender];                          // Update total supply
73         name = tokenName;                                             // Set the name for display purposes
74         symbol = tokenSymbol;                                         // Set the symbol for display purposes
75         decimals = decimalUnits;                                      // Amount of decimals for display purposes
76 		owner = msg.sender;
77 		emit Transfer(address(0), msg.sender, balanceOf[msg.sender]);
78 
79     }
80     
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85     
86     function mint(address account, uint256 amount) onlyOwner public  returns (bool){
87         require(account != address(0), "ERC20: mint to the zero address");
88 
89         //_beforeTokenTransfer(address(0), account, amount);
90 
91         totalSupply += amount;
92         balanceOf[account] += amount;
93         emit Transfer(address(0), account, amount);
94         return true;
95     }
96 
97     /* Send coins */
98     function transfer(address _to, uint256 _value) {
99         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
100 		if (_value <= 0) throw; 
101         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
102         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
103         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
104         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
105         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
106     }
107 
108     /* Allow another contract to spend some tokens in your behalf */
109     function approve(address _spender, uint256 _value)
110         returns (bool success) {
111 		if (_value <= 0) throw; 
112         allowance[msg.sender][_spender] = _value;
113         return true;
114     }
115        
116 
117     /* A contract attempts to get the coins */
118     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
119         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
120 		if (_value <= 0) throw; 
121         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
122         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
123         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
124         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
125         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
126         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     function burn(uint256 _value) onlyOwner returns (bool success){
132         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
133 		if (_value <= 0) throw; 
134         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
135         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
136         Burn(msg.sender, _value);
137         return true;
138     }
139 	
140 	function freeze(uint256 _value) onlyOwner public returns (bool success) {
141         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
142 		if (_value <= 0) throw; 
143         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
144         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
145         Freeze(msg.sender, _value);
146         return true;
147     }
148 	
149 	function unfreeze(uint256 _value) onlyOwner returns (bool success) {
150         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
151 		if (_value <= 0) throw; 
152         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
153 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
154         Unfreeze(msg.sender, _value);
155         return true;
156     }
157 	
158 	// transfer balance to owner
159 	function withdrawEther(uint256 amount) onlyOwner {
160 		if(msg.sender != owner)throw;
161 		owner.transfer(amount);
162 	}
163 	
164 	// can accept ether
165 	function() payable {
166     }
167 }