1 pragma solidity ^0.4.24;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     require(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b > 0);
15     uint256 c = a / b;
16     require(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21     require(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     require(c>=a && c>=b);
28     return c;
29   }
30 }
31 
32 contract BEU {
33     using SafeMath for uint256;
34     string public name = "BitEDU";
35     string public symbol = "BEU";
36     uint8 public decimals = 18;
37     uint256 public totalSupply =   2000000000000000000000000000;
38 	uint256 public totalLimit  = 100000000000000000000000000000;
39     address public owner;
40 	bool public lockAll = false;
41 
42     /* This creates an array with all balances */
43     mapping (address => uint256) public balanceOf;
44 	mapping (address => uint256) public freezeOf;
45 	mapping (address => uint256) public lockOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47 
48     /* This generates a public event on the blockchain that will notify clients */
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     /* This generates a public event on the blockchain that will notify clients */
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 
54     /* This notifies clients about the amount frozen */
55     event Freeze(address indexed from, uint256 value);
56 
57     /* This notifies clients about the amount unfrozen */
58     event Unfreeze(address indexed from, uint256 value);
59 
60     /* Initializes contract with initial supply tokens to the creator of the contract */
61     constructor() public {
62         owner = msg.sender;
63 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
64     }
65 
66     /* Send coins */
67     function transfer(address _to, uint256 _value) public returns (bool success) {
68         require(!lockAll);                                                          // lock all transfor in critical situation
69         require(_to != 0x0);                                                        // Prevent transfer to 0x0 address. Use burn() instead
70 		require(_value > 0);                                                        // Check value
71         require(balanceOf[msg.sender] >= _value);                                   // Check if the sender has enough
72         require(balanceOf[_to] + _value >= balanceOf[_to]);                         // Check for overflows
73         require(balanceOf[_to] + _value >= _value);                                 // Check for overflows
74         require(balanceOf[msg.sender] >= lockOf[msg.sender] + _value);              // Check for lock
75         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    // Subtract from the sender
76         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                  // Add the same to the recipient
77         emit Transfer(msg.sender, _to, _value);                                     // Notify anyone listening that this transfer took place
78         return true;
79     }
80 
81     /* Allow another contract to spend some tokens in your behalf */
82     function approve(address _spender, uint256 _value) public returns (bool success) {
83 		require(_value >= 0);                                                        // Check Value
84         allowance[msg.sender][_spender] = _value;
85         emit Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     /* A contract attempts to get the coins */
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(!lockAll);                                                          // lock all transfor in critical situation cases
92         require(_to != 0x0);                                                        // Prevent transfer to 0x0 address. Use burn() instead
93 		require(_value > 0);                                                        // Check Value
94         require(balanceOf[_from] >= _value);                                        // Check if the sender has enough
95         require(balanceOf[_to] + _value > balanceOf[_to]);                          // Check for overflows
96         require(balanceOf[_to] + _value > _value);                                  // Check for overflows
97         require(allowance[_from][msg.sender] >= _value);                            // Check allowance
98         require(balanceOf[_from] >= lockOf[_from] + _value);                        // Check for lock
99         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);              // Subtract from the sender
100         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                  // Add the same to the recipient
101         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
102         emit Transfer(_from, _to, _value);
103         return true;
104     }
105 
106     function freeze(uint256 _value) public returns (bool success) {
107         require(_value > 0);
108         require(balanceOf[msg.sender] >= _value);                                   // Check if the sender has enough
109 	    require(freezeOf[msg.sender] + _value >= freezeOf[msg.sender]);             // Check for Overflows
110 	    require(freezeOf[msg.sender] + _value >= _value);                           // Check for Overflows
111         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    // Subtract from the sender
112         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);      // Updates totalSupply
113         emit Freeze(msg.sender, _value);
114         return true;
115     }
116 
117     function unfreeze(uint256 _value) public returns (bool success) {
118         require(_value > 0);                                                        // Check Value
119         require(freezeOf[msg.sender] >= _value);                                    // Check if the sender has enough
120         require(balanceOf[msg.sender] + _value > balanceOf[msg.sender]);            // Check for Overflows
121 	    require(balanceOf[msg.sender] + _value > _value);                           // Check for overflows
122         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);      // Subtract from the freeze
123 	    balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);    // Add to balance
124         emit Unfreeze(msg.sender, _value);
125         return true;
126     }
127 
128     function burn(uint256 _value) public returns (bool success) {
129         require(msg.sender == owner);                                               // Only Owner
130         require(_value > 0);                                                        // Check Value
131         require(balanceOf[msg.sender] >= _value);                                   // Check if the sender has enough
132         require(totalSupply >= _value);                                             // Check for overflows
133 	    balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    // Subtract from the sender
134         totalSupply = SafeMath.safeSub(totalSupply, _value);                        // Updates totalSupply
135         return true;
136     }
137 
138     function mint(uint256 _value) public returns (bool success) {
139         require(msg.sender == owner);                                               // Only Owner
140         require(_value > 0);                                                        // Check Value
141         require(balanceOf[msg.sender] + _value > balanceOf[msg.sender]);            // Check if the sender has enough
142         require(balanceOf[msg.sender] + _value > _value);                           // Check if the sender has enough
143         require(totalSupply + _value > totalSupply);                                // Check for overflows
144 		require(totalSupply + _value > _value);                                     // Check for overflows
145         require(totalSupply + _value <= totalLimit);                                // Check for limit
146         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);    // Subtract from the sender
147         totalSupply = SafeMath.safeAdd(totalSupply, _value);                        // Updates totalSupply
148         return true;
149     }
150 
151     function lock(address _to, uint256 _value) public returns (bool success) {
152 	    require(msg.sender == owner);                                                // Only Owner
153         require(_to != 0x0);                                                         // Prevent lock to 0x0 address
154 	    require(_value >= 0);                                                        // Check Value
155         lockOf[_to] = _value;
156         return true;
157     }
158 
159     function lockForAll(bool b) public returns (bool success) {
160 	    require(msg.sender == owner);                                                // Only Owner
161         lockAll = b;
162         return true;
163     }
164 
165     function () public payable {
166         revert();
167     }
168 }