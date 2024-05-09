1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7     
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b > 0);
19     uint256 c = a / b;
20     assert(a == b * c + a % b);
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34   
35 }
36 contract QYQ is SafeMath{
37     string public name;
38     string public symbol;
39     uint8 public decimals = 8;
40     uint256 public totalSupply;
41 	address public owner;
42 
43     /* This creates an array with all balances */
44     mapping (address => uint256) public balanceOf;
45 	mapping (address => uint256) public freezeOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47 
48     /* This generates a public event on the blockchain that will notify clients */
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     /* This notifies clients about the amount burnt */
52     event Burn(address indexed from, uint256 value);
53 	
54 	/* This notifies clients about the amount frozen */
55     event Freeze(address indexed from, uint256 value);
56 	
57 	/* This notifies clients about the amount unfrozen */
58     event Unfreeze(address indexed from, uint256 value);
59 
60     /* Initializes contract with initial supply tokens to the creator of the contract */
61     function QYQ(
62         uint256 initialSupply,
63         string tokenName,
64         string tokenSymbol,
65         address holder)  public{
66         totalSupply = initialSupply * 10 ** uint256(decimals); // Update total supply
67         balanceOf[holder] = totalSupply;                       // Give the creator all initial tokens
68         name = tokenName;                                      // Set the name for display purposes
69         symbol = tokenSymbol;                                  // Set the symbol for display purposes
70 		owner = holder;
71     }
72 
73     /* Send coins */
74     function transfer(address _to, uint256 _value) public{
75         require(_to != 0x0);  // Prevent transfer to 0x0 address. Use burn() instead
76 		require(_value > 0); 
77         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
78         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
79         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
80         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
81         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
82     }
83 
84     /* Allow another contract to spend some tokens in your behalf */
85     function approve(address _spender, uint256 _value) public
86         returns (bool success) {
87 		require(_value > 0); 
88         allowance[msg.sender][_spender] = _value;
89         return true;
90     }
91        
92     /* A contract attempts to get the coins */
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
95 		require(_value > 0); 
96         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
97         require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
98         require(_value <= allowance[_from][msg.sender]);     // Check allowance
99         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
100         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
101         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
102         Transfer(_from, _to, _value);
103         return true;
104     }
105 
106     function burn(uint256 _value) public returns (bool success) {
107         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
108 		require(_value > 0); 
109         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
110         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
111         Burn(msg.sender, _value);
112         return true;
113     }
114 	
115 	function freeze(uint256 _value) public returns (bool success) {
116         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
117 		require(_value > 0); 
118         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
119         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
120         Freeze(msg.sender, _value);
121         return true;
122     }
123 	
124 	function unfreeze(uint256 _value) public returns (bool success) {
125         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
126 		require(_value > 0); 
127         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
128 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
129         Unfreeze(msg.sender, _value);
130         return true;
131     }
132 
133 }