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
32     if (!assertion) {
33       throw;
34     }
35   }
36 }
37 contract BixcPro is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42 	address public owner;
43 
44     /* This creates an array with all balances */
45     mapping (address => uint256) public balanceOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47     
48     bool public stopped = false;
49 
50     modifier isOwner{
51         assert(owner == msg.sender);
52         _;
53     }
54     
55     modifier isRunning{
56         assert(!stopped);
57         _;
58     }
59 
60 
61     /* Initializes contract with initial supply tokens to the creator of the contract */
62     function BixcPro(
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
76     /* Send coins */
77     function transfer(address _to, uint256 _value) isRunning returns (bool success) {
78         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
79 		if (_value <= 0) throw; 
80         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
82         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
83         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
84         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
85         return true;
86     }
87 
88     /* Allow another contract to spend some tokens in your behalf */
89     function approve(address _spender, uint256 _value) isRunning returns (bool success) {
90 		if (_value <= 0) throw; 
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94        
95 
96     /* A contract attempts to get the coins */
97     function transferFrom(address _from, address _to, uint256 _value) isRunning returns (bool success) {
98         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
99 		if (_value <= 0) throw; 
100         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
101         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
102         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
103         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
104         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
105         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
106         Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     function burn(uint256 _value) isRunning returns (bool success) {
111         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
112 		if (_value <= 0) throw; 
113         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
114         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
115         Burn(msg.sender, _value);
116         return true;
117     }
118     
119     function ownerShipTransfer(address newOwner) isOwner{
120         owner = newOwner;
121     }
122     
123     function stop() isOwner {
124         stopped = true;
125     }
126 
127     function start() isOwner {
128         stopped = false;
129     }
130 	
131 	// can accept ether
132 	function() payable {
133 	    revert();
134     }
135     
136         /* This generates a public event on the blockchain that will notify clients */
137     event Transfer(address indexed from, address indexed to, uint256 value);
138     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
139     /* This notifies clients about the amount burnt */
140     event Burn(address indexed from, uint256 value);
141 
142 }