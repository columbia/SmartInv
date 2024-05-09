1 /*
2 **  CCT -- Community Credit Token
3 */
4 pragma solidity ^0.4.11;
5 
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
13     assert(b > 0);
14     uint256 c = a / b;
15     assert(a == b * c + a % b);
16     return c;
17   }
18   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27   function assert(bool assertion) internal {
28     if (!assertion) {
29       throw;
30     }
31   }
32 }
33 contract CCT is SafeMath{
34     string public version = "1.0";
35     string public name = "Community Credit Token";
36     string public symbol = "CCT";
37     uint8 public decimals = 18;
38     uint256 public totalSupply = 5 * (10**9) * (10 **18);
39 	address public admin;
40 
41     /* This creates an array with all balances */
42     mapping (address => uint256) public balanceOf;
43 	mapping (address => uint256) public lockOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45 
46     /* This generates a public event on the blockchain that will notify clients */
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     /* This notifies clients about the amount burnt */
49     event Burn(address indexed from, uint256 value);
50 	/* This notifies clients about the amount frozen */
51     event Lock(address indexed from, uint256 value);
52 	/* This notifies clients about the amount unfrozen */
53     event Unlock(address indexed from, uint256 value);
54 
55     /* Initializes contract with initial supply tokens to the creator of the contract */
56     function CCT() {
57         admin = msg.sender;
58         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
59     }
60     /**
61      * If we want to rebrand, we can.
62      */
63     function setName(string _name)
64     {
65         if(msg.sender == admin)
66             name = _name;
67     }
68     /**
69      * If we want to rebrand, we can.
70      */
71     function setSymbol(string _symbol)
72     {
73         if(msg.sender == admin)
74             symbol = _symbol;
75     }
76     /* Send coins */
77     function transfer(address _to, uint256 _value) {
78         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
79 		if (_value <= 0) throw; 
80         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
82         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);              // Subtract from the sender
83         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
84         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
85     }
86     /* Allow another contract to spend some tokens in your behalf */
87     function approve(address _spender, uint256 _value)
88         returns (bool success) {
89 		if (_value <= 0) throw; 
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93     /* A contract attempts to get the coins */
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
96 		if (_value <= 0) throw; 
97         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
98         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
99         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
100         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         // Subtract from the sender
101         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
102         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
103         Transfer(_from, _to, _value);
104         return true;
105     }
106     function burn(uint256 _value) returns (bool success) {
107         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
108 		if (_value <= 0) throw; 
109         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);           // Subtract from the sender
110         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
111         Burn(msg.sender, _value);
112         return true;
113     }
114 	function lock(uint256 _value) returns (bool success) {
115         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
116 		if (_value <= 0) throw; 
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
118         lockOf[msg.sender] = SafeMath.safeAdd(lockOf[msg.sender], _value);                           // Updates totalSupply
119         Lock(msg.sender, _value);
120         return true;
121     }
122 	function unlock(uint256 _value) returns (bool success) {
123         if (lockOf[msg.sender] < _value) throw;            // Check if the sender has enough
124 		if (_value <= 0) throw; 
125         lockOf[msg.sender] = SafeMath.safeSub(lockOf[msg.sender], _value);                      // Subtract from the sender
126 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
127         Unlock(msg.sender, _value);
128         return true;
129     }
130 	// transfer balance to admin
131 	function withdrawEther(uint256 amount) {
132 		if(msg.sender != admin) throw;
133 		admin.transfer(amount);
134 	}
135 	// can accept ether
136 	function() payable {
137     }
138 }