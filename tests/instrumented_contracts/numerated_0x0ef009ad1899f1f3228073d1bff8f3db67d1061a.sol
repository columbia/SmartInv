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
33 contract BTBToken is SafeMath {
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
47     mapping (address => string) public btbAddressMapping;
48 
49 
50     /* This generates a public event on the blockchain that will notify clients */
51     event Transfer(address indexed from, address indexed to, uint tokens);
52 
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54     /* This notifies clients about the amount burnt */
55     event Burn(address indexed from, uint256 value);
56 
57     /* This notifies clients about the contract frozen */
58     event Freeze(address indexed from, string content);
59 
60     /* This notifies clients about the contract unfrozen */
61     event Unfreeze(address indexed from, string content);
62 
63     /* Initializes contract with initial supply tokens to the creator of the contract */
64     function BTBToken() public {
65         totalSupply = 10*10**26;                        // Update total supply
66         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
67         name = "BiTBrothers";                                   // Set the name for display purposes
68         symbol = "BTB";                               // Set the symbol for display purposes
69         decimals = 18;                            // Amount of decimals for display purposes
70         owner = msg.sender;
71         isContractFrozen = false;
72     }
73 
74     /* Send coins */
75     function transfer(address _to, uint256 _value) external returns (bool success) {
76         assert(!isContractFrozen);
77         assert(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
78         assert(_value > 0);
79         assert(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
80         assert(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
81         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
82         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
83         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
84         return true;
85     }
86 
87     /* Allow another contract to spend some tokens in your behalf */
88     function approve(address _spender, uint256 _value) external returns (bool success) {
89         assert(!isContractFrozen);
90         assert(_value > 0);
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94        
95 
96     /* A contract attempts to get the coins */
97     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
98         assert(!isContractFrozen);
99         assert(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
100         assert(_value > 0);
101         assert(balanceOf[_from] >= _value);                 // Check if the sender has enough
102         assert(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
103         assert(_value <= allowance[_from][msg.sender]);     // Check allowance
104         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
105         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
106         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
107         emit Transfer(_from, _to, _value);
108         return true;
109     }
110 
111     function burn(uint256 _value) external returns (bool success) {
112         assert(!isContractFrozen);
113         assert(msg.sender == owner);
114         assert(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
115         assert(_value > 0);
116         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
117         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
118         emit Burn(msg.sender, _value);
119         return true;
120     }
121 	
122     function freeze() external returns (bool success) {
123         assert(!isContractFrozen);
124         assert(msg.sender == owner);
125         isContractFrozen = true;
126         emit Freeze(msg.sender, "contract is frozen");
127         return true;
128     }
129 	
130     function unfreeze() external returns (bool success) {
131         assert(isContractFrozen);
132         assert(msg.sender == owner);
133         isContractFrozen = false;
134         emit Unfreeze(msg.sender, "contract is unfrozen");
135         return true;
136     }
137 
138     function setBTBAddress(string btbAddress) external returns (bool success) {
139         assert(!isContractFrozen);
140         btbAddressMapping[msg.sender] = btbAddress;
141         return true;
142     }
143     // transfer balance to owner
144     function withdrawEther(uint256 amount) external {
145         assert(msg.sender == owner);
146         owner.transfer(amount);
147     }
148 	
149     // can accept ether
150     function() public payable {
151     }
152 }