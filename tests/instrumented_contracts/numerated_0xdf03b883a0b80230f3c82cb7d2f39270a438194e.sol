1 // solium-disable linebreak-style
2 pragma solidity ^0.4.24;
3 
4 /**
5  * Math operations with safety checks
6  */
7 contract SafeMath 
8 {
9     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) 
10     {
11         uint256 c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) 
17     {
18         assert(b > 0);
19         uint256 c = a / b;
20         assert(a == b * c + a % b);
21         return c;
22     }
23 
24     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) 
25     {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) 
31     {
32         uint256 c = a + b;
33         assert(c>=a && c>=b);
34         return c;
35     }
36 }
37 contract EdraSave is SafeMath
38 {
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
63     constructor( uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol ) public 
64     {
65         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
66         totalSupply = initialSupply;                        // Update total supply
67         name = tokenName;                                   // Set the name for display purposes
68         symbol = tokenSymbol;                               // Set the symbol for display purposes
69         decimals = decimalUnits;                            // Amount of decimals for display purposes
70         owner = msg.sender;
71     }
72 
73     /* Send coins */
74     function transfer(address _to, uint256 _value) public 
75     {
76         require(_to != 0x0, "Receiver must be specified "); 
77         require(_value > 0, "Amount must greater than zero");
78         require(balanceOf[msg.sender] >= _value, "Sender's balance less than amount");
79         require(balanceOf[_to] + _value >= balanceOf[_to], "Overflow!");
80 
81         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
82         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
83         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
84     }
85 
86     /* Allow another contract to spend some tokens in your behalf */
87     function approve(address _spender, uint256 _value) public returns (bool success) 
88     {
89         require(_value > 0, "Amount must greater than zero");
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93 
94     /* A contract attempts to get the coins */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
96     {
97         require(_to != 0x0, "Receiver must be specified "); 
98         require(_value > 0, "Amount must greater than zero");
99         require(balanceOf[msg.sender] >= _value, "Sender's balance less than amount");
100         require(balanceOf[_to] + _value >= balanceOf[_to], "Overflow!");
101         require(_value <= allowance[_from][msg.sender], "Check allowance!");
102         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
103         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
104         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
105         emit Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function burn(uint256 _value) public returns (bool success) 
110     {
111         require(balanceOf[msg.sender] >= _value, "Balance is not enough");
112         require(_value > 0, "Amount must greater than zero");
113         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);           // Subtract from the sender
114         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
115         emit Burn(msg.sender, _value);
116         return true;
117     }
118 
119     function freeze(uint256 _value) public returns (bool success) 
120     {
121         require(balanceOf[msg.sender] >= _value, "Balance is not enough");
122         require(_value > 0, "Amount must greater than zero");
123         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
124         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
125         emit Freeze(msg.sender, _value);
126         return true;
127     }
128 
129     function unfreeze(uint256 _value) public returns (bool success) 
130     {
131         require(balanceOf[msg.sender] >= _value, "Balance is not enough");
132         require(_value > 0, "Amount must greater than zero");
133         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
134         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
135         emit Unfreeze(msg.sender, _value);
136         return true;
137     }
138 
139 	// transfer balance to owner
140     function withdrawEther(uint256 amount) public
141     {
142         require(msg.sender == owner, "Just owner can withdraw");
143         owner.transfer(amount);
144     }
145 
146 	// can accept ether
147     // function() payable {}
148 }