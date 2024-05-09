1 /**
2  *Submitted for verification at Etherscan.io on 2020-010-23
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 /**
8  * Math operations with safety checks
9  */
10 contract SafeMath {
11   function safeMul(uint256 a, uint256 b) internal pure returns(uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal pure returns(uint256) {
18     assert(b > 0);
19     uint256 c = a / b;
20     assert(a == b * c + a % b);
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal pure returns(uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal pure returns(uint256) {
30     uint256 c = a + b;
31     assert(c >= a && c >= b);
32     return c;
33   }
34 
35 }
36 
37 contract BTCB is SafeMath {
38   string public name;
39   string public symbol;
40   uint8 public decimals;
41   uint256 public totalSupply;
42   address public owner;
43 
44   /* This creates an array with all balances */
45   mapping(address => uint256) public balanceOf;
46   mapping(address => uint256) public freezeOf;
47   mapping(address => mapping(address => uint256)) public allowance;
48 
49   /* This generates a public event on the blockchain that will notify clients */
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 
52   /* This notifies clients about the amount burnt */
53   event Burn(address indexed from, uint256 value);
54 
55   /* This notifies clients about the amount frozen */
56   event Freeze(address indexed from, uint256 value);
57 
58   /* This notifies clients about the amount unfrozen */
59   event Unfreeze(address indexed from, uint256 value);
60 
61   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62   /* Initializes contract with initial supply tokens to the creator of the contract */
63   constructor() public{
64     balanceOf[msg.sender] = 3000000000000;       // Give the creator all initial tokens
65     totalSupply = 3000000000000;                 // Update total supply
66     name = 'Bitcoin Bless';                          // Set the name for display purposes
67     symbol = 'BTCB';                          // Set the symbol for display purposes
68     decimals = 8;                            // Amount of decimals for display purposes
69     owner = msg.sender;
70   }
71 
72   /* Send tokens */
73   function transfer(address _to, uint256 _value) public returns(bool){
74     if (_to == 0x0) return false;                               // Prevent transfer to 0x0 address. Use burn() instead
75     if (_value <= 0) return false;
76     if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
77     if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
78     balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);              // Subtract from the sender
79     balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
80     emit Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
81 	return true;
82   }
83 
84   /* Allow another contract to spend some tokens in your behalf */
85   function approve(address _spender, uint256 _value) public returns(bool success) {
86     require((_value == 0) || (allowance[msg.sender][_spender] == 0));
87     allowance[msg.sender][_spender] = _value;
88 	emit Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   /* Transfer tokens */
93   function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
94     if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
95     if (_value <= 0) revert();
96     if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
97     if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
98     if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
99     balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         // Subtract from the sender
100     balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
101     allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
102     emit Transfer(_from, _to, _value);
103     return true;
104   }
105 
106   /* Destruction of the token */
107   function burn(uint256 _value) public returns(bool success) {
108     if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
109     if (_value <= 0) revert();
110     balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);           // Subtract from the sender
111     totalSupply = SafeMath.safeSub(totalSupply, _value);                                // Updates totalSupply
112     emit Burn(msg.sender, _value);
113     return true;
114   }
115 
116   function freeze(uint256 _value) public returns(bool success) {
117     if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
118     if (_value <= 0) revert();
119     balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);             // Subtract from the sender
120     freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);               // Updates frozen tokens
121     emit Freeze(msg.sender, _value);
122     return true;
123   }
124 
125   function unfreeze(uint256 _value) public returns(bool success) {
126     if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
127     if (_value <= 0) revert();
128     freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);              // Updates frozen tokens
129     balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);            // Add to the sender
130     emit Unfreeze(msg.sender, _value);
131     return true;
132   }
133 
134   /* Prevents accidental sending of Ether */
135   function () public{
136     revert();
137   }
138   /* token code by kay */
139 }