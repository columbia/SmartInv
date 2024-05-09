1 pragma solidity ^0.4.18;
2 
3 /**
4  * XXP check. Math operations with safety checks
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
30 }
31 
32 contract CTB is SafeMath {
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint256 public totalSupply;
37 	address public owner;
38 
39     /* This creates an array with all balances */
40     mapping (address => uint256) public balanceOf;
41 	mapping (address => uint256) public freezeOf;
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
56     /* Initializes contract with initial supply tokens to the creator of the contract */
57     function CTB() public {
58         name = "CoinToBe";                                   // Set the name for display purposes
59         symbol = "CTB";                               // Set the symbol for display purposes
60         decimals = 18;                            // Amount of decimals for display purposes
61         totalSupply = 200000000 * 10 ** uint256(decimals);                        // Update total supply
62         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
63 		owner = msg.sender;
64     }
65 
66     /* Send coins */
67     function transfer(address _to, uint256 _value) public {
68         require(_to != 0x0);                              // Prevent transfer to 0x0 address. Use burn() instead
69         require(_value > 0);
70         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
71         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
72         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
73         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
74         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
75     }
76 
77     /* Allow another contract to spend some tokens in your behalf */
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79         require(_value > 0); 
80         allowance[msg.sender][_spender] = _value;
81         return true;
82     }
83        
84 
85     /* A contract attempts to get the coins */
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
88         require(_value > 0);
89         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
90         require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
91         require(_value <= allowance[_from][msg.sender]);     // Check allowance
92         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
93         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
94         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
95         Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function burn(uint256 _value) public returns (bool success) {
100         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
101         require(_value > 0); 
102         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
103         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
104         Burn(msg.sender, _value);
105         return true;
106     }
107 
108     function freeze(uint256 _value) public returns (bool success) {
109         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
110         require(_value > 0); 
111         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
112         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
113         Freeze(msg.sender, _value);
114         return true;
115     }
116 
117     function unfreeze(uint256 _value) public returns (bool success) {
118         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
119         require(_value > 0); 
120         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
121         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
122         Unfreeze(msg.sender, _value);
123         return true;
124     }
125 
126     // transfer balance to owner
127     function withdrawEther(uint256 amount) public {
128         require(msg.sender == owner);
129         owner.transfer(amount);
130     }
131 
132     // can accept ether
133     function() payable public {
134     }
135 }