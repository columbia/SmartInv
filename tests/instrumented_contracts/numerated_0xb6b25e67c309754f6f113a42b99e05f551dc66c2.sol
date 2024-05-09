1 pragma solidity ^0.4.18;
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
37 contract ElectronicMusic is SafeMath {
38     string public name = "Electronic Music";
39     string public symbol = "EM";
40     uint8 public decimals = 18;
41     uint256 public totalSupply = 100000000e18;
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
62     function ElectronicMusic() {
63         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
64         owner = msg.sender;
65     }
66 
67     /* Send coins */
68     function transfer(address _to, uint256 _value) {
69         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
70         if (_value <= 0) throw; 
71         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
72         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
73         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
74         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
75         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
76     }
77 
78     /* Allow another contract to spend some tokens in your behalf */
79     function approve(address _spender, uint256 _value)
80         returns (bool success) {
81         if (_value <= 0) throw; 
82         allowance[msg.sender][_spender] = _value;
83         return true;
84     }
85        
86 
87     /* A contract attempts to get the coins */
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
90         if (_value <= 0) throw; 
91         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
92         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
93         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
94         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
95         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
96         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function burn(uint256 _value) returns (bool success) {
102         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
103         if (_value <= 0) throw; 
104         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
105         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
106         Burn(msg.sender, _value);
107         return true;
108     }
109     
110     function freeze(uint256 _value) returns (bool success) {
111         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
112         if (_value <= 0) throw; 
113         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
114         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
115         Freeze(msg.sender, _value);
116         return true;
117     }
118     
119     function unfreeze(uint256 _value) returns (bool success) {
120         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
121         if (_value <= 0) throw; 
122         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
123         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
124         Unfreeze(msg.sender, _value);
125         return true;
126     }
127     
128     // transfer balance to owner
129     function withdrawEther(uint256 amount) {
130         if(msg.sender != owner)throw;
131         owner.transfer(amount);
132     }
133     
134     // can accept ether
135     function() payable {
136     }
137 }