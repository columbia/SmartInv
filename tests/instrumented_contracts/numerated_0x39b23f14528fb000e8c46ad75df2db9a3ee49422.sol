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
38 contract TixToken is SafeMath {
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42     uint256 public totalSupply;
43 
44     /* This creates an array with all balances */
45     mapping (address => uint256) public balanceOf;
46     mapping (address => uint256) public freezeOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     /* This generates a public event on the blockchain that will notify clients */
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     /* This notifies clients about the amount burnt */
53     event Burn(address indexed from, uint256 value);
54 
55     /* This notifies clients about the amount frozen */
56     event Freeze(address indexed from, uint256 value);
57 
58     /* This notifies clients about the amount unfrozen */
59     event Unfreeze(address indexed from, uint256 value);
60 
61     /* Initializes contract with initial supply tokens to the creator of the contract */
62     function TixToken() {
63         balanceOf[msg.sender] = 10000000000000000000;       // Give the creator all initial tokens
64         totalSupply = 10000000000000000000;                 // Update total supply
65         name = 'Lottery Tickets';                          // Set the name for display purposes
66         symbol = 'TIX';                          // Set the symbol for display purposes
67         decimals = 8;                            // Amount of decimals for display purposes
68     }
69 
70     /* Send tokens */
71     function transfer(address _to, uint256 _value) {
72         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
73         if (_value <= 0) revert();
74         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
75         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
76         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);              // Subtract from the sender
77         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
78         Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
79     }
80 
81     /* Allow another contract to spend some tokens in your behalf */
82     function approve(address _spender, uint256 _value) returns (bool success) {
83     if (_value <= 0) revert();
84         allowance[msg.sender][_spender] = _value;
85         return true;
86     }
87 
88     /* Transfer tokens */
89     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
90         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
91         if (_value <= 0) revert();
92         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
93         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
94         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
95         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         // Subtract from the sender
96         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
97         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
98         Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     /* Destruction of the token */
103     function burn(uint256 _value) returns (bool success) {
104         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
105         if (_value <= 0) revert();
106         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);           // Subtract from the sender
107         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
108         Burn(msg.sender, _value);
109         return true;
110     }
111 
112     function freeze(uint256 _value) returns (bool success) {
113         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
114         if (_value <= 0) revert();
115         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);             // Subtract from the sender
116         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);               // Updates frozen tokens
117         Freeze(msg.sender, _value);
118         return true;
119     }
120 
121     function unfreeze(uint256 _value) returns (bool success) {
122         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
123         if (_value <= 0) revert();
124         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);              // Updates frozen tokens
125         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);            // Add to the sender
126         Unfreeze(msg.sender, _value);
127         return true;
128     }
129 
130     /* Prevents accidental sending of Ether */
131     function () {
132         revert();
133     }
134 }