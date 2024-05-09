1 pragma solidity ^0.4.23;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         require(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         require(a == b * c + a % b);
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c>=a && c>=b);
28         return c;
29     }
30   }
31 
32 contract MyToken is SafeMath{   
33     address public owner;
34     uint8 public decimals = 18;
35     uint256 public totalSupply;
36     string public name;
37     string public symbol;
38      /* This creates an array with all balances */
39     mapping (address => uint256) public balanceOf;
40     mapping (address => uint256) public freezeOf;
41 
42     //events
43     /* This generates a public event on the blockchain that will notify clients */
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     /* This notifies clients about the amount burnt */
47     event Burn(address indexed from, uint256 value);
48 	
49 	/* This notifies clients about the amount frozen */
50     event Freeze(address indexed from, uint256 value);
51 	
52 	/* This notifies clients about the amount unfrozen */
53     event Unfreeze(address indexed from, uint256 value);
54 
55     constructor(
56         uint256 initSupply, 
57         string tokenName, 
58         string tokenSymbol, 
59         uint8 decimalUnits) public {
60         owner = msg.sender;
61         totalSupply = initSupply;
62         name = tokenName;
63         symbol = tokenSymbol;
64         decimals = decimalUnits;  
65         balanceOf[msg.sender] = totalSupply;
66         emit Transfer(address(0), msg.sender, totalSupply);
67     }
68 
69     // public functions
70     /// @return total amount of tokens
71     function totalSupply() public view returns (uint256){
72         return totalSupply;
73     }
74 
75     /// @param _owner The address from which the balance will be retrieved
76     /// @return The balance
77     function balanceOf(address _owner) public view returns (uint256) {
78         return balanceOf[_owner];
79     }
80     
81     /// @param _owner The address from which the freeze amount will be retrieved
82     /// @return The freeze amount
83     function freezeOf(address _owner) public view returns (uint256) {
84         return freezeOf[_owner];
85     }
86 
87     /* Send coins */
88     /* This generates a public event on the blockchain that will notify clients */
89     /// @notice send `_value` token to `_to` from `msg.sender`
90     /// @param _to The address of the recipient
91     /// @param _value The amount of token to be transferred
92     function transfer(address _to, uint256 _value) public {
93         require(_to != 0x0);                                // Prevent transfer to 0x0 address.
94         require(_value > 0);                                // Check send amount is greater than 0.
95         require(balanceOf[msg.sender] >= _value);           // Check balance of the sender is enough
96         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflow
97         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);// Subtract _value amount from the sender
98         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);// Add the same amount to the recipient
99         emit Transfer(msg.sender, _to, _value);// Notify anyone listening that this transfer took place
100     }
101 
102     /* Burn coins */
103     /// @notice burn `_value` token of owner
104     /// @param _value The amount of token to be burned
105     function burn(uint256 _value) public {
106         require(owner == msg.sender);                //Check owner
107         require(balanceOf[msg.sender] >= _value);    // Check if the sender has enough
108         require(_value > 0);                         //Check _value is valid
109         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);    // Subtract from the owner
110         totalSupply = SafeMath.sub(totalSupply,_value);                         // Updates totalSupply
111         emit Burn(msg.sender, _value);
112     }
113 	
114     /// @notice freeze `_value` token of '_addr' address
115     /// @param _addr The address to be freezed
116     /// @param _value The amount of token to be freezed
117 	function freeze(address _addr, uint256 _value) public {
118         require(owner == msg.sender);                //Check owner
119         require(balanceOf[_addr] >= _value);         // Check if the sender has enough
120 		require(_value > 0);                         //Check _value is valid
121         balanceOf[_addr] = SafeMath.sub(balanceOf[_addr], _value);              // Subtract _value amount from balance of _addr address
122         freezeOf[_addr] = SafeMath.add(freezeOf[_addr], _value);                // Add the same amount to freeze of _addr address
123         emit Freeze(_addr, _value);
124     }
125 	
126     /// @notice unfreeze `_value` token of '_addr' address
127     /// @param _addr The address to be unfreezed
128     /// @param _value The amount of token to be unfreezed
129 	function unfreeze(address _addr, uint256 _value) public {
130         require(owner == msg.sender);                //Check owner
131         require(freezeOf[_addr] >= _value);          // Check if the sender has enough
132 		require(_value > 0);                         //Check _value is valid
133         freezeOf[_addr] = SafeMath.sub(freezeOf[_addr], _value);                // Subtract _value amount from freeze of _addr address
134 		balanceOf[_addr] = SafeMath.add(balanceOf[_addr], _value);              // Add the same amount to balance of _addr address
135         emit Unfreeze(_addr, _value);
136     }
137 
138     // transfer balance to owner
139 	function withdrawEther(uint256 amount) public {
140 		require(owner == msg.sender);
141 		owner.transfer(amount);
142 	}
143 	
144 	// can accept ether
145 	function() payable public {
146     }
147 }