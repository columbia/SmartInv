1 pragma solidity ^0.4.16;
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
30 }
31 contract EthPredict is SafeMath{
32     string public name;
33     string public symbol;
34     address public owner;
35     uint8 public decimals;
36     uint256 public totalSupply;
37     address public icoContractAddress;
38     uint256 public  tokensTotalSupply =  1000 * (10**6) * 10**18;
39     mapping (address => bool) restrictedAddresses;
40     uint256 constant initialSupply = 100 * (10**6) * 10**18;
41     string constant  tokenName = 'EthPredictToken';
42     uint8 constant decimalUnits = 18;
43     string constant tokenSymbol = 'EPT';
44 
45 
46     /* This creates an array with all balances */
47     mapping (address => uint256) public balanceOf;
48 	  mapping (address => uint256) public freezeOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51     /* This generates a public event on the blockchain that will notify clients */
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     /* This notifies clients about the amount burnt */
55     event Burn(address indexed from, uint256 value);
56 
57 	/* This notifies clients about the amount frozen */
58     event Freeze(address indexed from, uint256 value);
59 
60 	/* This notifies clients about the amount unfrozen */
61     event Unfreeze(address indexed from, uint256 value);
62   //  Mint event
63     event Mint(address indexed _to, uint256 _value);
64 
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 
67     modifier onlyOwner {
68       assert(owner == msg.sender);
69       _;
70     }
71 
72     /* Initializes contract with initial supply tokens to the creator of the contract */
73     function EthPredict() {
74         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
75         totalSupply = initialSupply;                        // Update total supply
76         name = tokenName;                                   // Set the name for display purposes
77         symbol = tokenSymbol;                               // Set the symbol for display purposes
78         decimals = decimalUnits;                            // Amount of decimals for display purposes
79 		    owner = msg.sender;
80     }
81 
82     /* Send coins */
83     function transfer(address _to, uint256 _value) {                            // Prevent transfer to 0x0 address. Use burn() instead
84 		    require (_value > 0) ;
85         require (balanceOf[msg.sender] >= _value);           // Check if the sender has enough
86         require (balanceOf[_to] + _value >= balanceOf[_to]) ;     // Check for overflows
87         require (!restrictedAddresses[_to]);
88         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
89         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
90         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
91     }
92 
93     /* Allow another contract to spend some tokens in your behalf */
94     function approve(address _spender, uint256 _value)
95         returns (bool success) {
96           allowance[msg.sender][_spender] = _value;          // Set allowance
97       		Approval(msg.sender, _spender, _value);             // Raise Approval event
98       		return true;
99     }
100 
101     function mintTokens(address _to, uint256 _amount) {
102       require (msg.sender == icoContractAddress);			// Check if minter is ico Contract address;
103       require (_amount != 0 ) ;   // Check if values are not null;
104       require (balanceOf[_to] + _amount > balanceOf[_to]) ;// Check for overflows
105       require (totalSupply <=tokensTotalSupply);
106       //require (!restrictedAddresses[_to]); //restrictedAddresse
107       totalSupply += _amount;                                      // Update total supply
108       balanceOf[_to] += _amount;                    		    // Set minted coins to target
109       Mint(_to, _amount);                          		    // Create Mint event
110       Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
111     }
112 
113     function prodTokens(address _to, uint256 _amount)
114     onlyOwner {
115       require (_amount != 0 ) ;   // Check if values are not null;
116       require (balanceOf[_to] + _amount > balanceOf[_to]) ;     // Check for overflows
117       require (totalSupply <=tokensTotalSupply);
118       //require (!restrictedAddresses[_to]);
119       totalSupply += _amount;                                      // Update total supply
120       balanceOf[_to] += _amount;                    		    // Set minted coins to target
121       Mint(_to, _amount);                          		    // Create Mint event
122       Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
123     }
124 
125     /* A contract attempts to get the coins */
126     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
127         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
128         require (balanceOf[_to] + _value >= balanceOf[_to]) ;  // Check for overflows
129         require (_value <= allowance[_from][msg.sender]) ;     // Check allowance
130         require (!restrictedAddresses[_to]);
131         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
132         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
133         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
134         Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function burn(uint256 _value) returns (bool success) {
139         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
140 		    require (_value <= 0) ;
141         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
142         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
143         Burn(msg.sender, _value);
144         return true;
145     }
146 
147 	function freeze(uint256 _value) returns (bool success) {
148         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
149 		    require (_value > 0) ;
150         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
151         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
152         Freeze(msg.sender, _value);
153         return true;
154     }
155 
156 	function unfreeze(uint256 _value) returns (bool success) {
157         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
158         require (_value > 0) ;
159         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
160 		    balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
161         Unfreeze(msg.sender, _value);
162         return true;
163     }
164 
165 	// transfer balance to owner
166 	function withdrawEther(uint256 amount)
167   onlyOwner {
168 		owner.transfer(amount);
169 	}
170 
171   function totalSupply() constant returns (uint256 Supply) {
172 		return totalSupply;
173 	}
174 
175 	/* Get balance of specific address */
176 	function balanceOf(address _owner) constant returns (uint256 balance) {
177 		return balanceOf[_owner];
178 	}
179 
180 	// can accept ether
181 	function() payable {
182     }
183 
184   function changeICOAddress(address _newAddress) onlyOwner{
185   		icoContractAddress = _newAddress;
186   	}
187     /* Owner can add new restricted address or removes one */
188 	function editRestrictedAddress(address _newRestrictedAddress) onlyOwner {
189 		restrictedAddresses[_newRestrictedAddress] = !restrictedAddresses[_newRestrictedAddress];
190 	}
191 
192 	function isRestrictedAddress(address _querryAddress) constant returns (bool answer){
193 		return restrictedAddresses[_querryAddress];
194 	}
195 }