1 pragma solidity ^0.4.24;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         require(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         require(a == b * c + a % b);
17         return c;
18     }
19 
20     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c>=a && c>=b);
28         return c;
29     }
30 }
31 
32 contract BEU {
33     using SafeMath for uint256;
34     string public name = "BitEDU";
35     string public symbol = "BEU";
36     uint8 public decimals = 18;
37     uint256 public totalSupply = 2000000000000000000000000000;
38     address public owner;
39     bool public lockAll = false;
40 
41     /* This creates an array with all balances */
42     mapping (address => uint256) public balanceOf;
43     mapping (address => uint256) public freezeOf;
44     mapping (address => uint256) public lockOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     /* This generates a public event on the blockchain that will notify clients */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     /* This generates a public event on the blockchain that will notify clients */
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 
53     /* This notifies clients about the amount frozen */
54     event Freeze(address indexed from, uint256 value);
55 
56     /* This notifies clients about the amount unfrozen */
57     event Unfreeze(address indexed from, uint256 value);
58 
59     /* Initializes contract with initial supply tokens to the creator of the contract */
60     constructor() public {
61         owner = msg.sender;
62         balanceOf[msg.sender] = totalSupply;                                        // Give the creator all initial tokens
63     }
64 
65     /* Send coins */
66     function transfer(address _to, uint256 _value) public returns (bool success) {
67         require(!lockAll);                                                          // lock all transfor in critical situation
68         require(_to != 0x0);                                                        // Prevent transfer to 0x0 address. Use burn() instead
69         require(_value > 0);                                                        // Check value
70         require(balanceOf[msg.sender] >= _value);                                   // Check if the sender has enough
71         require(balanceOf[_to] + _value >= balanceOf[_to]);                         // Check for overflows
72         require(balanceOf[_to] + _value >= _value);                                 // Check for overflows
73         require(balanceOf[msg.sender] >= lockOf[msg.sender]);                                 // Check for lock
74         require(balanceOf[msg.sender] >= lockOf[msg.sender] + _value);              // Check for lock
75         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    // Subtract from the sender
76         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                  // Add the same to the recipient
77         emit Transfer(msg.sender, _to, _value);                                     // Notify anyone listening that this transfer took place
78         return true;
79     }
80 
81     /* Allow another contract to spend some tokens in your behalf */
82     function approve(address _spender, uint256 _value) public returns (bool success) {
83         require((_value == 0) || (allowance[msg.sender][_spender] == 0));           // Only Reset, not allowed to modify
84         allowance[msg.sender][_spender] = _value;
85         emit Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     /* A contract attempts to get the coins */
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(!lockAll);                                                          // lock all transfor in critical situation cases
92         require(_to != 0x0);                                                        // Prevent transfer to 0x0 address. Use burn() instead
93         require(_value > 0);                                                        // Check Value
94         require(balanceOf[_from] >= _value);                                        // Check if the sender has enough
95         require(balanceOf[_to] + _value > balanceOf[_to]);                          // Check for overflows
96         require(balanceOf[_to] + _value > _value);                                  // Check for overflows
97         require(allowance[_from][msg.sender] >= _value);                            // Check allowance
98         require(balanceOf[_from] >= lockOf[_from]);                                 // Check for lock
99         require(balanceOf[_from] >= lockOf[_from] + _value);                        // Check for lock
100         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);              // Subtract from the sender
101         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                  // Add the same to the recipient
102         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
103         emit Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function freeze(uint256 _value) public returns (bool success) {
108         require(_value > 0);
109         require(balanceOf[msg.sender] >= _value);                                   // Check if the sender has enough
110         require(freezeOf[msg.sender] + _value >= freezeOf[msg.sender]);             // Check for Overflows
111         require(freezeOf[msg.sender] + _value >= _value);                           // Check for Overflows
112         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    // Subtract from the sender
113         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);      // Updates totalSupply
114         emit Freeze(msg.sender, _value);
115         return true;
116     }
117 
118     function unfreeze(uint256 _value) public returns (bool success) {
119         require(_value > 0);                                                        // Check Value
120         require(freezeOf[msg.sender] >= _value);                                    // Check if the sender has enough
121         require(balanceOf[msg.sender] + _value > balanceOf[msg.sender]);            // Check for Overflows
122         require(balanceOf[msg.sender] + _value > _value);                           // Check for overflows
123         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);      // Subtract from the freeze
124         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);    // Add to balance
125         emit Unfreeze(msg.sender, _value);
126         return true;
127     }
128 
129     function burn(uint256 _value) public returns (bool success) {
130         require(msg.sender == owner);                                               // Only Owner
131         require(_value > 0);                                                        // Check Value
132         require(balanceOf[msg.sender] >= _value);                                   // Check if the sender has enough
133         require(totalSupply >= _value);                                             // Check for overflows
134         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    // Subtract from the sender
135         totalSupply = SafeMath.safeSub(totalSupply, _value);                        // Updates totalSupply
136         return true;
137     }
138 
139     function lock(address _to, uint256 _value) public returns (bool success) {
140         require(msg.sender == owner);                                                // Only Owner
141         require(_to != 0x0);                                                         // Prevent lock to 0x0 address
142         require((_value == 0) || (lockOf[_to] == 0));                                // Only Reset, not allowed to modify
143         require(balanceOf[_to] >= _value);                                           // Check for lock overflows
144         lockOf[_to] = _value;
145         return true;
146     }
147 
148     function lockForAll(bool b) public returns (bool success) {
149         require(msg.sender == owner);                                                // Only Owner
150         lockAll = b;
151         return true;
152     }
153 
154     function () public payable {
155         revert();
156     }
157 }