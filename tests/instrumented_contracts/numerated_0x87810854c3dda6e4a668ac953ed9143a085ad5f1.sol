1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 contract SafeMath {
8   function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
9     //uint256 c = a * b;
10     //require(a == 0 || c / a == b);
11     //return c;
12     
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
27     //require(b > 0);
28     //uint256 c = a / b;
29     //require(a == b * c + a % b);
30     //return c;
31     
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
40     //require(b <= a);
41     //return a - b;
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
49     //uint256 c = a + b;
50     //require(c>=a && c>=b);
51     //return c;
52     
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58   
59   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b != 0);
61     return a % b;
62   }
63 
64   /*function assert(bool assertion) internal {
65     if (!assertion) {
66       throw;
67     }
68   }*/
69 }
70 /**
71  * Smart Token Contract modified and developed by Marco Sanna,
72  * blockchain developer of Namacoin ICO Project.
73  */
74 contract Namacoin is SafeMath{
75     string public name;
76     string public symbol;
77     uint8 public decimals;
78     uint256 public totalSupply;
79 	address public owner;
80 
81     /* This creates an array with all balances */
82     mapping (address => uint256) public balanceOf;
83 	mapping (address => uint256) public freezeOf;
84     mapping (address => mapping (address => uint256)) public allowance;
85 
86     /* This generates a public event on the blockchain that will notify clients */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /* This notifies clients about the amount burnt */
90     event Burn(address indexed from, uint256 value);
91 	
92 	/* This notifies clients about the amount frozen */
93     event Freeze(address indexed from, uint256 value);
94 	
95 	/* This notifies clients about the amount unfrozen */
96     event Unfreeze(address indexed from, uint256 value);
97 	
98 	/* This notifies clients that owner withdraw the ether */
99 	event Withdraw(address indexed from, uint256 value);
100 	
101 	/* This notifies the first creation of the contract */
102 	event Creation(address indexed owner, uint256 value);
103 
104     /* Initializes contract with initial supply tokens to the creator of the contract */
105     constructor(
106         uint256 initialSupply,
107         string tokenName,
108         uint8 decimalUnits,
109         string tokenSymbol
110         ) public {
111         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
112         emit Creation(msg.sender, initialSupply);                // Notify anyone that the Tokes was create 
113         totalSupply = initialSupply;                        // Update total supply
114         name = tokenName;                                   // Set the name for display purposes
115         symbol = tokenSymbol;                               // Set the symbol for display purposes
116         decimals = decimalUnits;                            // Amount of decimals for display purposes
117 		owner = msg.sender;
118     }
119 
120     /* Send coins */
121     function transfer(address _to, uint256 _value) public {
122         require(_to != 0x0);
123         require(_value > 0);
124         require(balanceOf[msg.sender] >= _value);
125         require(balanceOf[_to] + _value >= balanceOf[_to]);
126         
127         //if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
128 		//if (_value <= 0) throw; 
129         //if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
130         //if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
131         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
132         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
133         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
134     }
135 
136     /* Allow another contract to spend some tokens in your behalf */
137     function approve(address _spender, uint256 _value) public
138         returns (bool success) {
139             
140         require(_value > 0);
141 		//if (_value <= 0) throw; 
142         allowance[msg.sender][_spender] = _value;
143         return true;
144     }
145        
146 
147     /* A contract attempts to get the coins */
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
149         
150         require(_to != 0x0);
151         require(_value > 0);
152         require(balanceOf[_from] >= _value);
153         require(balanceOf[_to] + _value >= balanceOf[_to]);
154         require(_value <= allowance[_from][msg.sender]);
155         
156         //if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
157 		//if (_value <= 0) throw; 
158         //if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
159         //if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
160         //if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
161         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
162         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
163         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
164         emit Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     function burn(uint256 _value) public returns (bool success) {
169         require(balanceOf[msg.sender] >= _value);
170         require(_value > 0);
171         //if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
172 		//if (_value <= 0) throw; 
173         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
174         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
175         emit Burn(msg.sender, _value);
176         return true;
177     }
178 	
179 	function freeze(uint256 _value) public returns (bool success) {
180 	    require(balanceOf[msg.sender] >= _value);
181 	    require(_value > 0);
182         //if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
183 		//if (_value <= 0) throw; 
184         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
185         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
186         emit Freeze(msg.sender, _value);
187         return true;
188     }
189 	
190 	function unfreeze(uint256 _value) public returns (bool success) {
191 	    require(freezeOf[msg.sender] >= _value);
192 	    require(_value > 0);
193         //if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
194 		//if (_value <= 0) throw; 
195         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
196 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
197         emit Unfreeze(msg.sender, _value);
198         return true;
199     }
200 	
201 	// transfer balance to owner
202 	function withdrawEther(uint256 amount) public returns (bool success){
203 	    require(msg.sender == owner);
204 	    //require(amount > 0);
205 		//if(msg.sender != owner)throw;
206 		owner.transfer(amount);
207 		emit Withdraw(msg.sender, amount);
208 		return true;
209 	}
210 	
211 	// can accept ether
212 	function() public payable {
213     }
214 }