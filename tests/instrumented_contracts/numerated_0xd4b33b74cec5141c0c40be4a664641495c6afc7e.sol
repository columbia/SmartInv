1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         simpleAssert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14         simpleAssert(b > 0);
15         uint256 c = a / b;
16         simpleAssert(a == b * c + a % b);
17         return c;
18     }
19 
20     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21         simpleAssert(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         simpleAssert(c>=a && c>=b);
28         return c;
29     }
30 
31     function simpleAssert(bool assertion) internal pure {
32         if (!assertion) {
33             revert();
34         }
35     }
36 }
37 contract CFC is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42     address public owner;
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
62     constructor(
63         uint256 initialSupply,
64         string tokenName,
65         uint8 decimalUnits,
66         string tokenSymbol
67     ) public {
68         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
69         totalSupply = initialSupply;                        // Update total supply
70         name = tokenName;                                   // Set the name for display purposes
71         symbol = tokenSymbol;                               // Set the symbol for display purposes
72         decimals = decimalUnits;                            // Amount of decimals for display purposes
73         owner = msg.sender;
74     }
75 
76     /* Send coins */
77     function transfer(address _to, uint256 _value) public {
78         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
79         if (_value <= 0) revert();
80         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
82         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
83         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
84         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
85     }
86 
87     /* Allow another contract to spend some tokens in your behalf */
88     // 批准另一个地址转币
89     function approve(address _spender, uint256 _value) public
90     returns (bool success) {
91         if (_value <= 0) revert();
92         allowance[msg.sender][_spender] = _value;
93         return true;
94     }
95 
96 
97     /* A contract attempts to get the coins */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
100         if (_value <= 0) revert();
101         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
102         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
103         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
104         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
105         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
106         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
107         emit Transfer(_from, _to, _value);
108         return true;
109     }
110 
111     // 代币销毁机制，该函数会直接影响区块链中的代币总量
112     function burn(uint256 _value) public returns (bool success) {
113         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
114         if (_value <= 0) revert();
115         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
116         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
117         emit Burn(msg.sender, _value);
118         return true;
119     }
120 
121     function freeze(uint256 _value) public returns (bool success) {
122         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
123         if (_value <= 0) revert();
124         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
125         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
126         emit Freeze(msg.sender, _value);
127         return true;
128     }
129 
130     function unfreeze(uint256 _value) public returns (bool success) {
131         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
132         if (_value <= 0) revert();
133         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
134         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
135         emit Unfreeze(msg.sender, _value);
136         return true;
137     }
138 
139     // transfer balance to owner
140     function withdrawEther(uint256 amount) public {
141         if(msg.sender != owner) revert();
142         owner.transfer(amount);
143     }
144 
145     // can accept ether
146     function() public payable {
147     }
148 }