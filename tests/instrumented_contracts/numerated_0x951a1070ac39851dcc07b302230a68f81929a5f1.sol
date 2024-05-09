1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-06-21
7 */
8 
9 pragma solidity ^ 0.4.8;
10 
11 /**
12  * Math operations with safety checks
13  */
14 contract SafeMath {
15   function safeMul(uint256 a, uint256 b) internal returns(uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function safeDiv(uint256 a, uint256 b) internal returns(uint256) {
22     assert(b > 0);
23     uint256 c = a / b;
24     assert(a == b * c + a % b);
25     return c;
26   }
27 
28   function safeSub(uint256 a, uint256 b) internal returns(uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function safeAdd(uint256 a, uint256 b) internal returns(uint256) {
34     uint256 c = a + b;
35     assert(c >= a && c >= b);
36     return c;
37   }
38 
39   function assert(bool assertion) internal {
40     if (!assertion) {
41       revert();
42     }
43   }
44 }
45 
46 contract GTS is SafeMath {
47   string public name;
48   string public symbol;
49   uint8 public decimals;
50   uint256 public totalSupply;
51   address public owner;
52 
53   /* This creates an array with all balances */
54   mapping(address => uint256) public balanceOf;
55   mapping(address => uint256) public freezeOf;
56   mapping(address => mapping(address => uint256)) public allowance;
57 
58   /* This generates a public event on the blockchain that will notify clients */
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 
61   /* This notifies clients about the amount burnt */
62   event Burn(address indexed from, uint256 value);
63 
64   /* This notifies clients about the amount frozen */
65   event Freeze(address indexed from, uint256 value);
66 
67   /* This notifies clients about the amount unfrozen */
68   event Unfreeze(address indexed from, uint256 value);
69 
70   /* Initializes contract with initial supply tokens to the creator of the contract */
71   function GTS() {
72     balanceOf[msg.sender] = 10000000000000000;       // Give the creator all initial tokens
73     totalSupply = 10000000000000000;                 // Update total supply
74     name = 'GT STAR Token';                          // Set the name for display purposes
75     symbol = 'GTS';                          // Set the symbol for display purposes
76     decimals = 8;                            // Amount of decimals for display purposes
77     owner = msg.sender;
78   }
79 
80   /* Send tokens */
81   function transfer(address _to, uint256 _value) {
82     if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
83     if (_value <= 0) revert();
84     if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
85     if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
86     balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);              // Subtract from the sender
87     balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
88     Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
89   }
90 
91   /* Allow another contract to spend some tokens in your behalf */
92   function approve(address _spender, uint256 _value) returns(bool success) {
93     require((_value == 0) || (allowance[msg.sender][_spender] == 0));
94     if (_value <= 0) revert();
95     allowance[msg.sender][_spender] = _value;
96     return true;
97   }
98 
99   /* Transfer tokens */
100   function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
101     if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
102     if (_value <= 0) revert();
103     if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
104     if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
105     if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
106     balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         // Subtract from the sender
107     balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
108     allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   /* Destruction of the token */
114   function burn(uint256 _value) returns(bool success) {
115     if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
116     if (_value <= 0) revert();
117     balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);           // Subtract from the sender
118     totalSupply = SafeMath.safeSub(totalSupply, _value);                                // Updates totalSupply
119     Burn(msg.sender, _value);
120     return true;
121   }
122 
123   function freeze(uint256 _value) returns(bool success) {
124     if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
125     if (_value <= 0) revert();
126     balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);             // Subtract from the sender
127     freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);               // Updates frozen tokens
128     Freeze(msg.sender, _value);
129     return true;
130   }
131 
132   function unfreeze(uint256 _value) returns(bool success) {
133     if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
134     if (_value <= 0) revert();
135     freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);              // Updates frozen tokens
136     balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);            // Add to the sender
137     Unfreeze(msg.sender, _value);
138     return true;
139   }
140 
141   /* Prevents accidental sending of Ether */
142   function () {
143     revert();
144   }
145   /* token code by aminsire@gmail.com */
146 }