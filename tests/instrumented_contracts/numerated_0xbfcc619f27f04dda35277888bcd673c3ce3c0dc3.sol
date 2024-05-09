1 pragma solidity ^0.4.8;
2 	contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public ; }
3 
4 	/*
5 	 * Standard token contract with ability to hold some amount on some balances before single initially specified deadline
6 	 * Which is useful for example for holding unsold tokens for a year for next step of project management
7 	 *
8 	 * Implements initial supply and allows additional supply based on coordinator agreement
9 	 * Coordinators list can be altered by owner
10 	 * Once minimal count of coordinators stated that they're agree for some value, emission is made
11 	 *
12 	 * Allows to change name, symbol and owner when in unlocked, can be locked by owner
13 	 * Once locked, can't be unlocked and reconfigured anymore
14 	 */ 
15 
16 	contract MetalExchangeToken {
17 		/* Public variables of the token */
18 		string public standard = 'Token 0.1';
19 		string public name;
20 		string public symbol;
21 		address public owner;
22 		uint8 public decimals;
23 		uint256 public totalSupply;
24 		bool public nameLocked=false;
25 		bool public symbolLocked=false;
26 		bool public ownerLocked=false;	
27 		uint256 public unholdTime;//deadline for unhold
28 
29 		/* This creates an array with all balances */
30 		mapping (address => uint256) public balanceOf;
31 		mapping (address => uint256) public holdBalanceOf;
32 		mapping (address => mapping (address => uint256)) public allowance;
33 		
34 		// Holds agreements for emission for Coordinators
35 		mapping (address => uint256) public coordinatorAgreeForEmission;
36 		mapping (uint256 => address) public coordinatorAccountIndex;
37 		uint256 public coordinatorAccountCount;
38 		
39 		// Keeps required count of coordinators to perform emission
40 		uint256 public minCoordinatorCount;
41 
42 		/* This generates a public event on the blockchain that will notify clients */
43 		event Transfer(address indexed from, address indexed to, uint256 value);
44 		event Emission(uint256 value);		
45 		
46 		event Hold(address indexed from, uint256 value);
47 		event Unhold(address indexed from, uint256 value);
48 
49 		/* This notifies clients about the amount burnt */
50 		event Burn(address indexed from, uint256 value);
51 		
52 		modifier canUnhold() { if (block.timestamp >= unholdTime) _; }
53 		modifier canHold() { if (block.timestamp < unholdTime) _; }
54 
55 		/* Initializes contract with initial supply tokens to the creator of the contract */
56 		function MetalExchangeToken() public {
57 			owner=msg.sender;
58 			totalSupply = 40000000000;	 				    // Update total supply
59 			balanceOf[owner] = totalSupply;				// Give the creator all initial tokens			
60 			name = 'MetalExchangeToken';				// Set the name for display purposes
61 			symbol = 'MET';								// Set the symbol for display purposes
62 			decimals = 4;								// Amount of decimals for display purposes
63 			unholdTime = 0;								// Time of automatic unhold of hold tokens
64 			coordinatorAccountCount = 0;
65 			minCoordinatorCount = 2;
66 		}
67 		
68 		// Adds new coordinator
69 		function addCoordinator(address newCoordinator) public {
70 			if (msg.sender!=owner) revert();
71 			coordinatorAccountIndex[coordinatorAccountCount]=newCoordinator;
72 			coordinatorAgreeForEmission[newCoordinator]=0;
73 			coordinatorAccountCount++;
74 		}
75 		
76 		// Removes exist coordinator from list of coordinators
77 		function removeCoordinator(address coordinator) public {
78 			if (msg.sender!=owner) revert();
79 			delete coordinatorAgreeForEmission[coordinator];
80 			for (uint256 i=0;i<coordinatorAccountCount;i++)
81 				if (coordinatorAccountIndex[i]==coordinator){
82 					for (uint256 j=i;j<coordinatorAccountCount-1;j++)
83 						coordinatorAccountIndex[j]=coordinatorAccountIndex[j+1];
84 						
85 					coordinatorAccountCount--;
86 					delete coordinatorAccountIndex[coordinatorAccountCount];
87 					i=coordinatorAccountCount;
88 				}
89 		}
90 		
91 		// Accepts the vote of coordinator for upcoming emission: which amount he or she is agree to emit
92 		function coordinatorSetAgreeForEmission(uint256 value_) public {
93 			bool found=false;
94 			for (uint256 i=0;i<coordinatorAccountCount;i++)
95 				if (coordinatorAccountIndex[i]==msg.sender){
96 					found=true;
97 					i=coordinatorAccountCount;
98 				}
99 			if (!found) revert();
100 			coordinatorAgreeForEmission[msg.sender]=value_;
101 			emit(value_);
102 		}
103 		
104 		// Attempts to make emission of specified value
105 		// Emission will be processed if required count of coordinators are agree
106 		function emit(uint256 value_) private {
107 			if (value_ <= 0) revert();
108 			
109 			bool found=false;
110 			if (msg.sender==owner) found=true;
111 			for (uint256 i=0;(!found)&&(i<coordinatorAccountCount);i++)
112 				if (coordinatorAccountIndex[i]==msg.sender){
113 					found=true;
114 					i=coordinatorAccountCount;
115 				}
116 			if (!found) revert();
117 			
118 			uint256 agree=0;
119 			for (i=0;i<coordinatorAccountCount;i++)
120 				if (coordinatorAgreeForEmission[coordinatorAccountIndex[i]]>=value_)
121 					agree++;
122 					
123 			if (agree<minCoordinatorCount) revert();
124 			
125 			for (i=0;i<coordinatorAccountCount;i++)
126 				if (coordinatorAgreeForEmission[coordinatorAccountIndex[i]]>=value_)
127 					coordinatorAgreeForEmission[coordinatorAccountIndex[i]]-=value_;
128 			
129 			balanceOf[owner] += value_;
130 			totalSupply += value_;
131 			Emission(value_);
132 		}
133 		
134 		function lockName() public {
135 			if (msg.sender!=owner) revert();
136 			if (nameLocked) revert();
137 			nameLocked=true;
138 		}
139 		
140 		function changeName(string new_name) public {
141 			if (msg.sender!=owner) revert();
142 			if (nameLocked) revert();
143 			name=new_name;
144 		}
145 		
146 		function lockSymbol() public {
147 			if (msg.sender!=owner) revert();
148 			if (symbolLocked) revert();
149 			symbolLocked=true;
150 		}
151 		
152 		function changeSymbol(string new_symbol) public {
153 			if (msg.sender!=owner) revert();
154 			if (symbolLocked) revert();
155 			symbol=new_symbol;
156 		}
157 		
158 		function lockOwner() public {
159 			if (msg.sender!=owner) revert();
160 			if (ownerLocked) revert();
161 			ownerLocked=true;
162 		}
163 		
164 		function changeOwner(address new_owner) public {
165 			if (msg.sender!=owner) revert();
166 			if (ownerLocked) revert();
167 			owner=new_owner;
168 		}
169 		
170 		/* Hold coins */
171 		function hold(uint256 _value) canHold payable public {
172 			if (balanceOf[msg.sender] < _value) revert();		   		// Check if the sender has enough to hold
173 			if (holdBalanceOf[msg.sender] + _value < holdBalanceOf[msg.sender]) revert(); // Check for overflows
174 				balanceOf[msg.sender] -= _value;					// Subtract from the sender
175 			holdBalanceOf[msg.sender] += _value;					// Add the same to the sender's hold
176 			Hold(msg.sender, _value);				   				// Notify anyone listening that this hold took place
177 		}
178 		
179 		/* Unhold coins */
180 		function unhold(uint256 _value) canUnhold payable public {
181 			if (holdBalanceOf[msg.sender] < _value) revert();		   	// Check if the sender has enough hold
182 			if (balanceOf[msg.sender] + _value < balanceOf[msg.sender]) revert(); // Check for overflows
183 			holdBalanceOf[msg.sender] -= _value;					// Subtract from the sender hold
184 			balanceOf[msg.sender] += _value;						// Add the same to the sender
185 			Unhold(msg.sender, _value);				   			 	// Notify anyone listening that this unhold took place
186 		}
187 
188 		/* Send coins */
189 		function transfer(address _to, uint256 _value) payable public {
190 			if (_to == 0x0) revert();							   		// Prevent transfer to 0x0 address. Use burn() instead
191 			if (balanceOf[msg.sender] < _value) revert();		   		// Check if the sender has enough
192 			if (balanceOf[_to] + _value < balanceOf[_to]) revert(); 	// Check for overflows
193 			balanceOf[msg.sender] -= _value;					 	// Subtract from the sender
194 			balanceOf[_to] += _value;								// Add the same to the recipient
195 			Transfer(msg.sender, _to, _value);				   		// Notify anyone listening that this transfer took place
196 		}
197 
198 		/* Allow another contract to spend some tokens in your behalf */
199 		function approve(address _spender, uint256 _value)
200 			public
201 			returns (bool success) {
202 			allowance[msg.sender][_spender] = _value;
203 			return true;
204 		}
205 
206 		/* Approve and then communicate the approved contract in a single tx */
207 		function approveAndCall(address _spender, uint256 _value, bytes _extraData)
208 			public
209 			returns (bool success) {
210 			tokenRecipient spender = tokenRecipient(_spender);
211 			if (approve(_spender, _value)) {
212 				spender.receiveApproval(msg.sender, _value, this, _extraData);
213 				return true;
214 			}
215 		}		
216 
217 		/* A contract attempts to get the coins */
218 		function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
219 			if (_to == 0x0) revert();									// Prevent transfer to 0x0 address. Use burn() instead
220 			if (balanceOf[_from] < _value) revert();				 	// Check if the sender has enough
221 			if (balanceOf[_to] + _value < balanceOf[_to]) revert();  	// Check for overflows
222 			if (_value > allowance[_from][msg.sender]) revert();	 	// Check allowance
223 			balanceOf[_from] -= _value;						   		// Subtract from the sender
224 			balanceOf[_to] += _value;							 	// Add the same to the recipient
225 			allowance[_from][msg.sender] -= _value;
226 			Transfer(_from, _to, _value);
227 			return true;
228 		}
229 
230 		function burn(uint256 _value) public returns (bool success) {
231 			if (balanceOf[msg.sender] < _value) revert();				// Check if the sender has enough
232 			balanceOf[msg.sender] -= _value;					  	// Subtract from the sender
233 			totalSupply -= _value;									// Updates totalSupply
234 			Burn(msg.sender, _value);								// Fires the event about token burn
235 			return true;
236 		}
237 
238 		function burnFrom(address _from, uint256 _value) public returns (bool success){
239 			if (balanceOf[_from] < _value) revert();					// Check if the sender has enough
240 			if (_value > allowance[_from][msg.sender]) revert();		// Check allowance
241 			balanceOf[_from] -= _value;						  		// Subtract from the sender
242 			totalSupply -= _value;							   		// Updates totalSupply
243 			Burn(_from, _value);									// Fires the event about token burn
244 			return true;
245 		}
246 	}