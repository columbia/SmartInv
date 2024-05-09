1 pragma solidity ^0.4.10;
2 
3 /**
4  * @title Interface to communicate with ICO token contract
5  */
6 contract IToken {
7   function balanceOf(address _address) constant returns (uint balance);
8   function transferFromOwner(address _to, uint256 _value) returns (bool success);
9 }
10 
11 /**
12  * @title Presale token contract
13  */
14 contract TokenEscrow {
15 	// Token-related properties/description to display in Wallet client / UI
16 	string public standard = 'PBKXToken 0.3';
17 	string public name = 'PBKXToken';
18 	string public symbol = 'PBKX';
19 	uint public decimals = 2;
20     	uint public totalSupply = 300000000;
21 	
22 	IToken icoToken;
23 	
24 	event Converted(address indexed from, uint256 value); // Event to inform about the fact of token burning/destroying
25     	event Transfer(address indexed from, address indexed to, uint256 value);
26 	event Error(bytes32 error);
27 	
28 	mapping (address => uint) balanceFor; // Presale token balance for each of holders
29 	
30 	address owner;  // Contract owner
31 	
32 	uint public exchangeRate; // preICO -> ICO token exchange rate
33 
34 	// Token supply and discount policy structure
35 	struct TokenSupply {
36 		uint limit;                 // Total amount of tokens
37 		uint totalSupply;           // Current amount of sold tokens
38 		uint tokenPriceInWei;  // Number of token per 1 Eth
39 	}
40 	
41 	TokenSupply[3] public tokenSupplies;
42 
43 	// Modifiers
44 	modifier owneronly { if (msg.sender == owner) _; }
45 
46 	/**
47 	 * @dev Set/change contract owner
48 	 * @param _owner owner address
49 	 */
50 	function setOwner(address _owner) owneronly {
51 		owner = _owner;
52 	}
53 	
54 	function setRate(uint _exchangeRate) owneronly {
55 		exchangeRate = _exchangeRate;
56 	}
57 	
58 	function setToken(address _icoToken) owneronly {
59 		icoToken = IToken(_icoToken);
60 	}
61 	
62 	/**
63 	 * @dev Returns balance/token quanity owned by address
64 	 * @param _address Account address to get balance for
65 	 * @return balance value / token quantity
66 	 */
67 	function balanceOf(address _address) constant returns (uint balance) {
68 		return balanceFor[_address];
69 	}
70 	
71 	/**
72 	 * @dev Transfers tokens from caller/method invoker/message sender to specified recipient
73 	 * @param _to Recipient address
74 	 * @param _value Token quantity to transfer
75 	 * @return success/failure of transfer
76 	 */	
77 	function transfer(address _to, uint _value) returns (bool success) {
78 		if(_to != owner) {
79 			if (balanceFor[msg.sender] < _value) return false;           // Check if the sender has enough
80 			if (balanceFor[_to] + _value < balanceFor[_to]) return false; // Check for overflows
81 			if (msg.sender == owner) {
82 				transferByOwner(_value);
83 			}
84 			balanceFor[msg.sender] -= _value;                     // Subtract from the sender
85 			balanceFor[_to] += _value;                            // Add the same to the recipient
86 			Transfer(owner,_to,_value);
87 			return true;
88 		}
89 		return false;
90 	}
91 	
92 	function transferByOwner(uint _value) private {
93 		for (uint discountIndex = 0; discountIndex < tokenSupplies.length; discountIndex++) {
94 			TokenSupply storage tokenSupply = tokenSupplies[discountIndex];
95 			if(tokenSupply.totalSupply < tokenSupply.limit) {
96 				if (tokenSupply.totalSupply + _value > tokenSupply.limit) {
97 					_value -= tokenSupply.limit - tokenSupply.totalSupply;
98 					tokenSupply.totalSupply = tokenSupply.limit;
99 				} else {
100 					tokenSupply.totalSupply += _value;
101 					break;
102 				}
103 			}
104 		}
105 	}
106 	
107 	/**
108 	 * @dev Burns/destroys specified amount of Presale tokens for caller/method invoker/message sender
109 	 * @return success/failure of transfer
110 	 */	
111 	function convert() returns (bool success) {
112 		if (balanceFor[msg.sender] == 0) return false;            // Check if the sender has enough
113 		if (!exchangeToIco(msg.sender)) return false; // Try to exchange preICO tokens to ICO tokens
114 		Converted(msg.sender, balanceFor[msg.sender]);
115 		balanceFor[msg.sender] = 0;                      // Subtract from the sender
116 		return true;
117 	} 
118 	
119 	/**
120 	 * @dev Converts/exchanges sold Presale tokens to ICO ones according to provided exchange rate
121 	 * @param owner address
122 		 */
123 	function exchangeToIco(address owner) private returns (bool) {
124 	    if(icoToken != address(0)) {
125 		    return icoToken.transferFromOwner(owner, balanceFor[owner] * exchangeRate);
126 	    }
127 	    return false;
128 	}
129 
130 	/**
131 	 * @dev Presale contract constructor
132 	 */
133 	function TokenEscrow() {
134 		owner = msg.sender;
135 		
136 		balanceFor[msg.sender] = 300000000; // Give the creator all initial tokens
137 		
138 		// Discount policy
139 		tokenSupplies[0] = TokenSupply(100000000, 0, 11428571428571); // First million of tokens will go 11210762331838 wei for 1 token
140 		tokenSupplies[1] = TokenSupply(100000000, 0, 11848341232227); // Second million of tokens will go 12106537530266 wei for 1 token
141 		tokenSupplies[2] = TokenSupply(100000000, 0, 12500000000000); // Third million of tokens will go 13245033112582 wei for 1 token
142 	
143 		//Balances recovery
144 		transferFromOwner(0xa0c6c73e09b18d96927a3427f98ff07aa39539e2,875);
145 		transferByOwner(875);
146 		transferFromOwner(0xa0c6c73e09b18d96927a3427f98ff07aa39539e2,2150);
147 		transferByOwner(2150);
148 		transferFromOwner(0xa0c6c73e09b18d96927a3427f98ff07aa39539e2,975);
149 		transferByOwner(975);
150 		transferFromOwner(0xa0c6c73e09b18d96927a3427f98ff07aa39539e2,875000);
151 		transferByOwner(875000);
152 		transferFromOwner(0xa4a90f8d12ae235812a4770e0da76f5bc2fdb229,3500000);
153 		transferByOwner(3500000);
154 		transferFromOwner(0xbd08c225306f6b341ce5a896392e0f428b31799c,43750);
155 		transferByOwner(43750);
156 		transferFromOwner(0xf948fc5be2d2fd8a7ee20154a18fae145afd6905,3316981);
157 		transferByOwner(3316981);
158 		transferFromOwner(0x23f15982c111362125319fd4f35ac9e1ed2de9d6,2625);
159 		transferByOwner(2625);
160 		transferFromOwner(0x23f15982c111362125319fd4f35ac9e1ed2de9d6,5250);
161 		transferByOwner(5250);
162 		transferFromOwner(0x6ebff66a68655d88733df61b8e35fbcbd670018e,58625);
163 		transferByOwner(58625);
164 		transferFromOwner(0x1aaa29dffffc8ce0f0eb42031f466dbc3c5155ce,1043875);
165 		transferByOwner(1043875);
166 		transferFromOwner(0x5d47871df00083000811a4214c38d7609e8b1121,3300000);
167 		transferByOwner(3300000);
168 		transferFromOwner(0x30ced0c61ccecdd17246840e0d0acb342b9bd2e6,261070);
169 		transferByOwner(261070);
170 		transferFromOwner(0x1079827daefe609dc7721023f811b7bb86e365a8,2051875);
171 		transferByOwner(2051875);
172 		transferFromOwner(0x6c0b6a5ac81e07f89238da658a9f0e61be6a0076,10500000);
173 		transferByOwner(10500000);
174 		transferFromOwner(0xd16e29637a29d20d9e21b146fcfc40aca47656e5,1750);
175 		transferByOwner(1750);
176 		transferFromOwner(0x4c9ba33dcbb5876e1a83d60114f42c949da4ee22,7787500);
177 		transferByOwner(7787500);
178 		transferFromOwner(0x0d8cc80efe5b136865b9788393d828fd7ffb5887,100000000);
179 		transferByOwner(100000000);
180 	
181 	}
182   
183 	// Incoming transfer from the Presale token buyer
184 	function() payable {
185 		
186 		uint tokenAmount; // Amount of tokens which is possible to buy for incoming transfer/payment
187 		uint amountToBePaid; // Amount to be paid
188 		uint amountTransfered = msg.value; // Cost/price in WEI of incoming transfer/payment
189 		
190 		if (amountTransfered <= 0) {
191 		      	Error('no eth was transfered');
192               		msg.sender.transfer(msg.value);
193 		  	return;
194 		}
195 
196 		if(balanceFor[owner] <= 0) {
197 		      	Error('all tokens sold');
198               		msg.sender.transfer(msg.value);
199 		      	return;
200 		}
201 		
202 		// Determine amount of tokens can be bought according to available supply and discount policy
203 		for (uint discountIndex = 0; discountIndex < tokenSupplies.length; discountIndex++) {
204 			// If it's not possible to buy any tokens at all skip the rest of discount policy
205 			
206 			TokenSupply storage tokenSupply = tokenSupplies[discountIndex];
207 			
208 			if(tokenSupply.totalSupply < tokenSupply.limit) {
209 			
210 				uint tokensPossibleToBuy = amountTransfered / tokenSupply.tokenPriceInWei;
211 
212                 if (tokensPossibleToBuy > balanceFor[owner]) 
213                     tokensPossibleToBuy = balanceFor[owner];
214 
215 				if (tokenSupply.totalSupply + tokensPossibleToBuy > tokenSupply.limit) {
216 					tokensPossibleToBuy = tokenSupply.limit - tokenSupply.totalSupply;
217 				}
218 
219 				tokenSupply.totalSupply += tokensPossibleToBuy;
220 				tokenAmount += tokensPossibleToBuy;
221 
222 				uint delta = tokensPossibleToBuy * tokenSupply.tokenPriceInWei;
223 
224 				amountToBePaid += delta;
225                 		amountTransfered -= delta;
226 			
227 			}
228 		}
229 		
230 		// Do not waste gas if there is no tokens to buy
231 		if (tokenAmount == 0) {
232 		    	Error('no token to buy');
233             		msg.sender.transfer(msg.value);
234 			return;
235         	}
236 		
237 		// Transfer tokens to buyer
238 		transferFromOwner(msg.sender, tokenAmount);
239 
240 		// Transfer money to seller
241 		owner.transfer(amountToBePaid);
242 		
243 		// Refund buyer if overpaid / no tokens to sell
244 		msg.sender.transfer(msg.value - amountToBePaid);
245 	}
246   
247 	/**
248 	 * @dev Removes/deletes contract
249 	 */
250 	function kill() owneronly {
251 		suicide(msg.sender);
252 	}
253   
254 	/**
255 	 * @dev Transfers tokens from owner to specified recipient
256 	 * @param _to Recipient address
257 	 * @param _value Token quantity to transfer
258 	 * @return success/failure of transfer
259 	 */
260 	function transferFromOwner(address _to, uint256 _value) private returns (bool success) {
261 		if (balanceFor[owner] < _value) return false;                 // Check if the owner has enough
262 		if (balanceFor[_to] + _value < balanceFor[_to]) return false;  // Check for overflows
263 		balanceFor[owner] -= _value;                          // Subtract from the owner
264 		balanceFor[_to] += _value;                            // Add the same to the recipient
265         	Transfer(owner,_to,_value);
266 		return true;
267 	}
268   
269 }