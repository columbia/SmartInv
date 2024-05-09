1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b > 0);
18     uint256 c = a / b;
19     assert(a == b * c + a % b);
20     return c;
21   }
22 
23   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c>=a && c>=b);
31     return c;
32   }
33 
34 }
35 contract SOT is SafeMath{
36     string public name='SOT token';
37     string public symbol='SOT';
38     uint8 public decimals = 18;
39     uint256 public totalSupply=500000000;
40     address public owner=0x9158D63b74dE4Aef6695B41F61B313f93f3cE6AE;
41 
42     /* This creates an array with all balances */
43     mapping (address => uint256) public balanceOf;
44     mapping (address => uint256) public freezeOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     /* This generates a public event on the blockchain that will notify clients */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     /* This notifies clients about the amount burnt */
51     event Burn(address indexed from, uint256 value);
52 
53     /* This notifies clients about the amount frozen */
54     event Freeze(address indexed from, uint256 value);
55 
56     /* This notifies clients about the amount unfrozen */
57     event Unfreeze(address indexed from, uint256 value);
58 
59     /* Initializes contract with initial supply tokens to the creator of the contract */
60     function AC(
61         uint256 initialSupply,
62         string tokenName,
63         string tokenSymbol,
64         address holder)  public{
65         totalSupply = initialSupply * 10 ** uint256(decimals); // Update total supply
66         balanceOf[holder] = totalSupply;                       // Give the creator all initial tokens
67         name = tokenName;                                      // Set the name for display purposes
68         symbol = tokenSymbol;                                  // Set the symbol for display purposes
69         owner = holder;
70     }
71 
72     /* Send coins */
73     function transfer(address _to, uint256 _value) public{
74         require(_to != 0x0);  // Prevent transfer to 0x0 address. Use burn() instead
75         require(_value > 0); 
76         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
77         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
78         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
79         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
80         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
81     }
82 
83     /* Allow another contract to spend some tokens in your behalf */
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86         require(_value > 0); 
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90 
91     /* A contract attempts to get the coins */
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
94         require(_value > 0); 
95         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
96         require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
97         require(_value <= allowance[_from][msg.sender]);     // Check allowance
98         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
99         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
100         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function burn(uint256 _value) public returns (bool success) {
106         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
107         require(_value > 0); 
108         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
109         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
110         Burn(msg.sender, _value);
111         return true;
112     }
113 
114     function freeze(uint256 _value) public returns (bool success) {
115         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
116         require(_value > 0); 
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
118         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
119         Freeze(msg.sender, _value);
120         return true;
121     }
122 
123     function unfreeze(uint256 _value) public returns (bool success) {
124         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
125         require(_value > 0); 
126         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
127         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
128         Unfreeze(msg.sender, _value);
129         return true;
130     }
131 }