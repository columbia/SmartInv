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
33       throw;
34     }
35   }
36 }
37 contract TaiChiCoin is SafeMath{
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
61    /* Initializes contract with initial supply tokens to the creator of the contract */
62     function TaiChiCoin() {
63         name = "TaiChiCoin";                                   // Set the name for display purposes
64         symbol = "TCC";                               // Set the symbol for display purposes
65         owner = msg.sender;
66         decimals = 18;
67         totalSupply = 25000000000 * 10**uint(decimals);
68         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
69     }
70 
71     /* Send coins */
72     function transfer(address _to, uint256 _value) {
73         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
74         if (_value <= 0) throw; 
75         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
76         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
77         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
78         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
79         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
80     }
81 
82     /* Allow another contract to spend some tokens in your behalf */
83     function approve(address _spender, uint256 _value)
84         returns (bool success) {
85         if (_value <= 0) throw; 
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89        
90 
91     /* A contract attempts to get the coins */
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
94         if (_value <= 0) throw; 
95         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
96         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
97         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
98         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
99         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
100         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function burn(uint256 _value) returns (bool success) {
106         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
107         if (_value <= 0) throw; 
108         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
109         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
110         Burn(msg.sender, _value);
111         return true;
112     }
113     
114     function freeze(uint256 _value) returns (bool success) {
115         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
116         if (_value <= 0) throw; 
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
118         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
119         Freeze(msg.sender, _value);
120         return true;
121     }
122     
123     function unfreeze(uint256 _value) returns (bool success) {
124         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
125         if (_value <= 0) throw; 
126         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
127         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
128         Unfreeze(msg.sender, _value);
129         return true;
130     }
131     
132     // transfer balance to owner
133     function withdrawEther(uint256 amount) {
134         if(msg.sender != owner)throw;
135         owner.transfer(amount);
136     }
137     
138     // can accept ether
139     function() payable {
140     }
141 }