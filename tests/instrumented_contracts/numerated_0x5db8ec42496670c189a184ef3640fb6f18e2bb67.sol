1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 /**
21  * Math operations with safety checks
22  */
23 library SafeMath {
24     function add(uint a, uint b) internal pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28     function sub(uint a, uint b) internal pure returns (uint c) {
29         require(b <= a);
30         c = a - b;
31     }
32     function mul(uint a, uint b) internal pure returns (uint c) {
33         c = a * b;
34         require(a == 0 || c / a == b);
35     }
36     function div(uint a, uint b) internal pure returns (uint c) {
37         require(b > 0);
38         c = a / b;
39     }
40 }
41 
42 contract BTR is owned{
43     
44     using SafeMath for uint;
45     
46     string public name;
47     string public symbol;
48     uint8 public decimals;
49     uint256 public totalSupply;
50 
51     /* This creates an array with all balances */
52     mapping (address => uint256) public balanceOf;
53 	mapping (address => uint256) public freezeOf;
54     mapping (address => mapping (address => uint256)) public allowance;
55 
56     /* This generates a public event on the blockchain that will notify clients */
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 
59     /* This notifies clients about the amount burnt */
60     event Burn(address indexed from, uint256 value);
61 	
62 	/* This notifies clients about the amount frozen */
63     event Freeze(address indexed from, uint256 value);
64 	
65 	/* This notifies clients about the amount unfrozen */
66     event Unfreeze(address indexed from, uint256 value);
67 
68     /* Initializes contract with initial supply tokens to the creator of the contract */
69     constructor(string tokenName,string tokenSymbol,address tokenOwner) public {           
70         decimals = 18; // Amount of decimals for display purposes
71         totalSupply = 10000000000 * 10 ** uint(decimals); // Update total supply
72         balanceOf[tokenOwner] = totalSupply;// Give the creator all initial tokens
73         name = tokenName;                                   // Set the name for display purposes
74         symbol = tokenSymbol;                               // Set the symbol for display purposes
75 		owner = tokenOwner;
76     }
77 
78     /* Send coins */
79     function transfer(address _to, uint256 _value) public {
80         require (_to != address(0));                               // Prevent transfer to 0x0 address. Use burn() instead
81 		require (_value > 0); 
82         require (balanceOf[msg.sender] >= _value);           // Check if the sender has enough
83         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
84         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender
85         balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient
86         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
87     }
88 
89     /* Allow another contract to spend some tokens in your behalf */
90     function approve(address _spender, uint256 _value) public
91         returns (bool success) {
92 		require (_value > 0);
93 		require (balanceOf[msg.sender] >= _value);
94         allowance[msg.sender][_spender] = _value;
95         return true;
96     }
97        
98 
99     /* A contract attempts to get the coins */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         require (_to != address(0));                                // Prevent transfer to 0x0 address. Use burn() instead
102 		require (_value > 0); 
103         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
104         require (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
105         require (_value <= allowance[_from][msg.sender]);     // Check allowance
106         balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender
107         balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient
108         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
109         emit Transfer(_from, _to, _value);
110         return true;
111     }
112 
113     function burn(uint256 _value) public returns (bool success) {
114         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
115 		require (_value > 0); 
116         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                      // Subtract from the sender
117         totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
118         emit Burn(msg.sender, _value);
119         return true;
120     }
121 	
122 	function freeze(uint256 _value) public returns (bool success) {
123         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
124 		require (_value > 0); 
125         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                      // Subtract from the sender
126         freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);                                // Updates totalSupply
127         emit Freeze(msg.sender, _value);
128         return true;
129     }
130 	
131 	function unfreeze(uint256 _value) public returns (bool success) {
132         require (freezeOf[msg.sender] >= _value);            // Check if the sender has enough
133 		require (_value > 0); 
134         freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);                      // Subtract from the sender
135 		balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);
136         emit Unfreeze(msg.sender, _value);
137         return true;
138     }
139 	
140 	// transfer balance to owner
141 	function withdrawEther(uint256 amount) onlyOwner public {
142 	    msg.sender.transfer(amount);
143 	}
144 	
145 	// can accept ether
146 	function() external payable {
147     }
148 }