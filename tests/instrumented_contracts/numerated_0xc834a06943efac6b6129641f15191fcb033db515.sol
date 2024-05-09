1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7     function safeMul(uint256 a, uint256 b) internal returns(uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function safeDiv(uint256 a, uint256 b) internal returns(uint256) {
14         assert(b > 0);
15         uint256 c = a / b;
16         assert(a == b * c + a % b);
17         return c;
18     }
19 
20     function safeSub(uint256 a, uint256 b) internal returns(uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint256 a, uint256 b) internal returns(uint256) {
26         uint256 c = a + b;
27         assert(c >= a && c >= b);
28         return c;
29     }
30 
31 }
32 
33 contract RoboTC is SafeMath {
34     string public name;
35     string public symbol;
36     uint8 public decimals;
37     uint256 public totalSupply;
38     address public owner;
39 
40     /* This creates an array with all balances */
41     mapping(address => uint256) public balanceOf;
42     mapping(address => uint256) public freezeOf;
43     mapping(address => mapping(address => uint256)) public allowance;
44 
45     /* This generates a public event on the blockchain that will notify clients */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /* This notifies clients about the amount burnt */
49     event Burn(address indexed from, uint256 value);
50 
51     /* This notifies clients about the amount frozen */
52     event Freeze(address indexed from, uint256 value);
53 
54     /* This notifies clients about the amount unfrozen */
55     event Unfreeze(address indexed from, uint256 value);
56 
57     /* Initializes contract with initial supply tokens to the creator of the contract */
58     function RoboTC() {
59         balanceOf[msg.sender] = 4500000000000000000; // Give the creator all initial tokens
60         totalSupply = 4500000000000000000; // Update total supply
61         name = 'RoboTC'; // Set the name for display purposes
62         symbol = 'RBTC'; // Set the symbol for display purposes
63         decimals = 8; // Amount of decimals for display purposes
64         owner = msg.sender;
65     }
66 
67     /* Send tokens */
68     function transfer(address _to, uint256 _value) {
69         if (_to == 0x0) revert(); // Prevent transfer to 0x0 address. Use burn() instead
70         if (_value <= 0) revert();
71         if (balanceOf[msg.sender] < _value) revert(); // Check if the sender has enough
72         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
73         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
74         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); // Add the same to the recipient
75         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
76     }
77 
78     /* Allow another contract to spend some tokens in your behalf */
79     function approve(address _spender, uint256 _value) returns(bool success) {
80         if (_value <= 0) revert();
81         allowance[msg.sender][_spender] = _value;
82         return true;
83     }
84 
85     /* Transfer tokens */
86     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
87         if (_to == 0x0) revert(); // Prevent transfer to 0x0 address. Use burn() instead
88         if (_value <= 0) revert();
89         if (balanceOf[_from] < _value) revert(); // Check if the sender has enough
90         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
91         if (_value > allowance[_from][msg.sender]) revert(); // Check allowance
92         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); // Subtract from the sender
93         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); // Add the same to the recipient
94         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
95         Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     /* Destruction of the token */
100     function burn(uint256 _value) returns(bool success) {
101         if (balanceOf[msg.sender] < _value) revert(); // Check if the sender has enough
102         if (_value <= 0) revert();
103         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
104         totalSupply = SafeMath.safeSub(totalSupply, _value); // Updates totalSupply
105         Burn(msg.sender, _value);
106         return true;
107     }
108 
109     function freeze(uint256 _value) returns(bool success) {
110         if (balanceOf[msg.sender] < _value) revert(); // Check if the sender has enough
111         if (_value <= 0) revert();
112         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
113         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value); // Updates frozen tokens
114         Freeze(msg.sender, _value);
115         return true;
116     }
117 
118     function unfreeze(uint256 _value) returns(bool success) {
119         if (freezeOf[msg.sender] < _value) revert(); // Check if the sender has enough
120         if (_value <= 0) revert();
121         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value); // Updates frozen tokens
122         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value); // Add to the sender
123         Unfreeze(msg.sender, _value);
124         return true;
125     }
126 
127     /* Prevents accidental sending of Ether */
128     function() {
129         revert();
130     }
131 }