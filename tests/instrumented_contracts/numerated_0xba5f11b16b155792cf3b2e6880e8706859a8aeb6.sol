1 pragma solidity ^0.4.8;
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
33       revert();
34     }
35   }
36 }
37 
38 contract Aeron is SafeMath {
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42     uint256 public totalSupply;
43     address public owner;
44 
45     /* This creates an array with all balances */
46     mapping (address => uint256) public balanceOf;
47     mapping (address => uint256) public freezeOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     /* This generates a public event on the blockchain that will notify clients */
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     /* This notifies clients about the amount burnt */
54     event Burn(address indexed from, uint256 value);
55 
56     /* This notifies clients about the amount frozen */
57     event Freeze(address indexed from, uint256 value);
58 
59     /* This notifies clients about the amount unfrozen */
60     event Unfreeze(address indexed from, uint256 value);
61 
62     /* Initializes contract with initial supply tokens to the creator of the contract */
63     function Aeron() {
64         balanceOf[msg.sender] = 10000000000000000;       // Give the creator all initial tokens
65         totalSupply = 10000000000000000;                 // Update total supply
66         name = 'Aeron';                          // Set the name for display purposes
67         symbol = 'ARN';                          // Set the symbol for display purposes
68         decimals = 8;                            // Amount of decimals for display purposes
69 	owner = msg.sender;
70     }
71 
72     /* Send tokens */
73     function transfer(address _to, uint256 _value) {
74         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
75 	if (_value <= 0) revert();
76         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
77         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
78         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);              // Subtract from the sender
79         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
80         Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
81     }
82 
83     /* Allow another contract to spend some tokens in your behalf */
84     function approve(address _spender, uint256 _value) returns (bool success) {
85 	if (_value <= 0) revert();
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89 
90     /* Transfer tokens */
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
92         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
93 	 if (_value <= 0) revert();
94         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
95         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
96         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
97         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         // Subtract from the sender
98         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
99         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
100         Transfer(_from, _to, _value);
101         return true;
102     }
103 
104     /* Destruction of the token */
105     function burn(uint256 _value) returns (bool success) {
106         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
107 	if (_value <= 0) revert();
108         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);           // Subtract from the sender
109         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
110         Burn(msg.sender, _value);
111         return true;
112     }
113 
114     function freeze(uint256 _value) returns (bool success) {
115         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
116 	if (_value <= 0) revert();
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);             // Subtract from the sender
118         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);               // Updates frozen tokens
119         Freeze(msg.sender, _value);
120         return true;
121     }
122 
123     function unfreeze(uint256 _value) returns (bool success) {
124         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
125 	if (_value <= 0) revert();
126         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);              // Updates frozen tokens
127 	balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);            // Add to the sender
128         Unfreeze(msg.sender, _value);
129         return true;
130     }
131 
132   /* Prevents accidental sending of Ether */
133   function () {
134       revert();
135   }
136 }