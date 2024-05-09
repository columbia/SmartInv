1 pragma solidity ^0.4.21;
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
30 }
31 
32 
33 contract WGCToken is SafeMath {
34     string public name;
35     string public symbol;
36     uint8 public decimals;
37     uint256 public totalSupply;
38     address public owner;
39 
40     /* This creates an array with all balances */
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     mapping (address => uint256) public freezeOf;
45 
46     /* This generates a public event on the blockchain that will notify clients */
47     event Transfer(address indexed from, address indexed to, uint tokens);
48 
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50     /* This notifies clients about the amount burnt */
51     event Burn(address indexed from, uint256 value);
52 
53     /* This notifies clients about the contract unfrozen */
54     event Unfreeze(address indexed from, string content);
55 
56     /* change owner */
57     event ChangeOwner(address indexed from, address indexed to);
58 
59     /* Initializes contract with initial supply tokens to the creator of the contract */
60     function WGCToken() public {
61         totalSupply = 256*10**24;                        // Update total supply
62         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
63         name = "WGCToken";                                   // Set the name for display purposes
64         symbol = "WGC";                               // Set the symbol for display purposes
65         decimals = 18;                            // Amount of decimals for display purposes
66         owner = msg.sender;
67     }
68 
69     /* Send coins */
70     function transfer(address _to, uint256 _value) external returns (bool success) {
71         assert(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
72         assert(_value > 0);
73         assert(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
74         assert(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
75         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
76         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
77         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
78         return true;
79     }
80 
81     /* Allow another contract to spend some tokens in your behalf */
82     function approve(address _spender, uint256 _value) external returns (bool success) {
83         assert(_value > 0);
84         allowance[msg.sender][_spender] = _value;
85         return true;
86     }
87 
88     /* A contract attempts to get the coins */
89     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
90         assert(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
91         assert(_value > 0);
92         assert(balanceOf[_from] >= _value);                 // Check if the sender has enough
93         assert(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
94         assert(_value <= allowance[_from][msg.sender]);     // Check allowance
95         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
96         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
97         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
98         emit Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function burn(uint256 _value) external returns (bool success) {
103         assert(msg.sender == owner);
104         assert(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
105         assert(_value > 0);
106         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
107         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
108         emit Burn(msg.sender, _value);
109         return true;
110     }
111 
112     function changeOwner(address _toOwner) external returns (bool success) {
113         assert(msg.sender == owner);
114         owner = _toOwner;
115         emit ChangeOwner(msg.sender, _toOwner);
116         return true;
117     }
118 
119     // transfer balance to owner
120     function withdrawEther(uint256 amount) external {
121         assert(msg.sender == owner);
122         owner.transfer(amount);
123     }
124 
125     // can accept ether
126     function() public payable {
127     }
128 }