1 pragma solidity ^0.4.26;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31 }
32 contract FOSS is SafeMath{
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint256 public totalSupply;
37     address public owner;
38 
39     /* This creates an array with all balances */
40     mapping (address => uint256) public balanceOf;
41     mapping (address => uint256) public freezeOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     /* This generates a public event on the blockchain that will notify clients */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     /* This notifies clients about the amount burnt */
48     event Burn(address indexed from, uint256 value);
49 
50 	/* This notifies clients about the amount frozen */
51     event Freeze(address indexed from, uint256 value);
52 
53 	/* This notifies clients about the amount unfrozen */
54     event Unfreeze(address indexed from, uint256 value);
55 
56 
57     /* Initializes contract with initial supply tokens to the creator of the contract */
58     constructor(
59         uint256 initialSupply,
60         string tokenName,
61         uint8 decimalUnits,
62         string tokenSymbol
63         ) public{
64         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
65         totalSupply = initialSupply;                        // Update total supply
66         name = tokenName;                                   // Set the name for display purposes
67         symbol = tokenSymbol;                               // Set the symbol for display purposes
68         decimals = decimalUnits;                            // Amount of decimals for display purposes
69 	      owner = msg.sender;
70     }
71 
72     /* Send coins */
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
75         require(_value > 0);
76         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
77         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
78         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
79         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
80         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
81         return true;
82     }
83 
84     /* Allow another contract to spend some tokens in your behalf */
85     function approve(address _spender, uint256 _value) public returns (bool success){
86 		    require(_value > 0);
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90 
91 
92     /* A contract attempts to get the coins */
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
95         require(_value > 0);
96         require(balanceOf[_from] >= _value);                // Check if the sender has enough
97         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
98         require(_value <= allowance[_from][msg.sender]);    // Check allowance
99         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
100         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
101         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
102         emit Transfer(_from, _to, _value);
103         return true;
104     }
105 
106     function burn(uint256 _value) public returns (bool success) {
107         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
108         require(_value > 0);
109         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
110         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
111         emit Burn(msg.sender, _value);
112         return true;
113     }
114 
115     function burnFrom(address _from, uint256 _value) public returns (bool success) {
116         require(balanceOf[_from] >= _value);                // Check if the sender has enough
117         require(_value > 0);
118         require(_value <= allowance[_from][msg.sender]);    // Check allowance
119         balanceOf[_from] -= _value;                         // Subtract from the sender
120         totalSupply -= _value;                              // Updates totalSupply
121         emit Burn(_from, _value);
122         return true;
123     }
124 
125     function freeze(uint256 _value) public returns (bool success) {
126         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
127         require(_value > 0);
128         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
129         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
130         emit Freeze(msg.sender, _value);
131         return true;
132     }
133 
134     function unfreeze(uint256 _value) public returns (bool success) {
135         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
136         require(_value > 0);
137         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
138         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
139         emit Unfreeze(msg.sender, _value);
140         return true;
141     }
142 
143     function withdrawEther(uint256 amount) public {
144       require(msg.sender == owner);
145       owner.transfer(amount);
146     }
147 
148     function transferOwnership(address newOwner) public returns (bool success) {
149       require(msg.sender == owner );
150       owner = newOwner;
151       return true;
152     }
153 
154     function () public payable {
155       revert();
156     }
157 }