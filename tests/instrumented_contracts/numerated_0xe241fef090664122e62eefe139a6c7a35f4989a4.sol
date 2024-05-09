1 pragma solidity ^0.4.21;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b > 0);
15         uint256 c = a / b;
16         assert(a == b * c + a % b);
17         return c;
18     }
19 
20     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c>=a && c>=b);
28         return c;
29    }
30 }
31 
32 
33 contract StoneToken is SafeMath {
34     string public name;
35     string public symbol;
36     uint8 public decimals;
37     uint256 public totalSupply;
38     address public owner;
39     bool public isContractFrozen;
40 
41     /* This creates an array with all balances */
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     mapping (address => uint256) public freezeOf;
46 
47 
48     /* This generates a public event on the blockchain that will notify clients */
49     event Transfer(address indexed from, address indexed to, uint tokens);
50 
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 
53     /* This notifies clients about the amount burnt */
54     event Burn(address indexed from, uint256 value);
55 
56     /* This notifies clients about the amount burnt */
57     event Mint(address indexed from, uint256 value);
58 
59     /* This notifies clients about the contract frozen */
60     event Freeze(address indexed from, string content);
61 
62     /* This notifies clients about the contract unfrozen */
63     event Unfreeze(address indexed from, string content);
64 
65     /* Initializes contract with initial supply tokens to the creator of the contract */
66     function StoneToken() public {
67         totalSupply = 1*10**26;                        // Update total supply
68         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
69         name = "StoneCoin";                                   // Set the name for display purposes
70         symbol = "STO";                               // Set the symbol for display purposes
71         decimals = 18;                            // Amount of decimals for display purposes
72         owner = msg.sender;
73         isContractFrozen = false;
74     }
75 
76     /* Send coins */
77     function transfer(address _to, uint256 _value) external returns (bool success) {
78         assert(!isContractFrozen);
79         assert(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
80         assert(_value > 0);
81         assert(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
82         assert(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
83         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
84         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
85         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
86         return true;
87     }
88 
89     /* Allow another contract to spend some tokens in your behalf */
90     function approve(address _spender, uint256 _value) external returns (bool success) {
91         assert(!isContractFrozen);
92         assert(_value > 0);
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96        
97 
98     /* A contract attempts to get the coins */
99     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
100         assert(!isContractFrozen);
101         assert(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
102         assert(_value > 0);
103         assert(balanceOf[_from] >= _value);                 // Check if the sender has enough
104         assert(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
105         assert(_value <= allowance[_from][msg.sender]);     // Check allowance
106         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
107         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
108         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
109         emit Transfer(_from, _to, _value);
110         return true;
111     }
112 
113     function burn(uint256 _value) external returns (bool success) {
114         assert(!isContractFrozen);
115         assert(msg.sender == owner);
116         assert(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
117         assert(_value > 0);
118         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
119         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
120         emit Burn(msg.sender, _value);
121         return true;
122     }
123 
124     function mint(uint256 _value) external returns (bool success) {
125         assert(!isContractFrozen);
126         assert(msg.sender == owner);
127         assert(_value > 0);
128         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);                      // Subtract from the sender
129         totalSupply = SafeMath.safeAdd(totalSupply, _value);                                // Updates totalSupply
130         emit Mint(msg.sender, _value);
131         return true;
132     }
133 
134     function freeze() external returns (bool success) {
135         assert(!isContractFrozen);
136         assert(msg.sender == owner);
137         isContractFrozen = true;
138         emit Freeze(msg.sender, "contract is frozen");
139         return true;
140     }
141 	
142     function unfreeze() external returns (bool success) {
143         assert(isContractFrozen);
144         assert(msg.sender == owner);
145         isContractFrozen = false;
146         emit Unfreeze(msg.sender, "contract is unfrozen");
147         return true;
148     }
149 
150     // transfer balance to owner
151     function withdrawEther(uint256 amount) external {
152         assert(msg.sender == owner);
153         owner.transfer(amount);
154     }
155 	
156     // can accept ether
157     function() public payable {
158     }
159 }