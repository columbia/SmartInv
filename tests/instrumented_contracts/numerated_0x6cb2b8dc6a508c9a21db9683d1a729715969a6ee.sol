1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Interface to communicate with ICO token contract
5  */
6  // FRACTAL PRE REALEASE "IOU" TOKEN - FPRT 
7  
8 contract IToken {
9    
10   function balanceOf(address _address) constant returns (uint balance);
11   function transferFromOwner(address _to, uint256 _value) returns (bool success);
12 }
13 
14 /**
15  * @title Presale token contract
16  */
17 contract TokenEscrow {
18 	// Token-related properties/description to display in Wallet client / UI
19 	string public standard = 'FractalPreRelease 1.0';
20 	string public name = 'FractalPreReleaseToken';
21 	string public symbol = 'FPRT';
22 	uint public decimals = 4;
23     uint public totalSupply = 50000000000;
24    
25 	
26 	IToken icoToken;
27 	
28 	event Converted(address indexed from, uint256 value); // Event to inform about the fact of token burning/destroying
29     	event Transfer(address indexed from, address indexed to, uint256 value);
30 	event Error(bytes32 error);
31 	
32 	mapping (address => uint) balanceFor; // Presale token balance for each of holders
33 	
34 	address owner;  // Contract owner
35 	
36 	uint public exchangeRate; // preICO -> ICO token exchange rate
37 
38 	// Token supply and discount policy structure
39 	struct TokenSupply {
40 		uint limit;                 // Total amount of tokens
41 		uint totalSupply;           // Current amount of sold tokens
42 		uint tokenPriceInWei;  // Number of token per 1 Eth
43 		
44 	}
45 	
46 	TokenSupply[3] public tokenSupplies;
47 
48 	// Modifiers
49 	modifier owneronly { if (msg.sender == owner) _; }
50 
51 	/**
52 	 * @dev Set/change contract owner
53 	 * @param _owner owner address
54 	 */
55 	function setOwner(address _owner) owneronly {
56 		owner = _owner;
57 	}
58 	
59 	function setRate(uint _exchangeRate) owneronly {
60 		exchangeRate = _exchangeRate;
61 	}
62 	
63 	function setToken(address _icoToken) owneronly {
64 		icoToken = IToken(_icoToken);
65 	}
66 	
67 	/**
68 	 * @dev Returns balance/token quanity owned by address
69 	 * @param _address Account address to get balance for
70 	 * @return balance value / token quantity
71 	 */
72 	function balanceOf(address _address) constant returns (uint balance) {
73 		return balanceFor[_address];
74 	}
75 	
76 	/**
77 	 * @dev Transfers tokens from caller/method invoker/message sender to specified recipient
78 	 * @param _to Recipient address
79 	 * @param _value Token quantity to transfer
80 	 * @return success/failure of transfer
81 	 */	
82 	function transfer(address _to, uint _value) returns (bool success) {
83 		if(_to != owner) {
84 			if (balanceFor[msg.sender] < _value) return false;           // Check if the sender has enough
85 			if (balanceFor[_to] + _value < balanceFor[_to]) return false; // Check for overflows
86 			if (msg.sender == owner) {
87 				transferByOwner(_value);
88 			}
89 			balanceFor[msg.sender] -= _value;                     // Subtract from the sender
90 			balanceFor[_to] += _value;                            // Add the same to the recipient
91 			Transfer(owner,_to,_value);
92 			return true;
93 		}
94 		return false;
95 	}
96 	
97 	function transferByOwner(uint _value) private {
98 		for (uint discountIndex = 0; discountIndex < tokenSupplies.length; discountIndex++) {
99 			TokenSupply storage tokenSupply = tokenSupplies[discountIndex];
100 			if(tokenSupply.totalSupply < tokenSupply.limit) {
101 				if (tokenSupply.totalSupply + _value > tokenSupply.limit) {
102 					_value -= tokenSupply.limit - tokenSupply.totalSupply;
103 					tokenSupply.totalSupply = tokenSupply.limit;
104 				} else {
105 					tokenSupply.totalSupply += _value;
106 					break;
107 				}
108 			}
109 		}
110 	}
111 	
112 	/**
113 	 * @dev Burns/destroys specified amount of Presale tokens for caller/method invoker/message sender
114 	 * @return success/failure of transfer
115 	 */	
116 	function convert() returns (bool success) {
117 		if (balanceFor[msg.sender] == 0) return false;            // Check if the sender has enough
118 		if (!exchangeToIco(msg.sender)) return false; // Try to exchange preICO tokens to ICO tokens
119 		Converted(msg.sender, balanceFor[msg.sender]);
120 		balanceFor[msg.sender] = 0;                      // Subtract from the sender
121 		return true;
122 	} 
123 	
124 	/**
125 	 * @dev Converts/exchanges sold Presale tokens to ICO ones according to provided exchange rate
126 	 * @param owner address
127 		 */
128 	function exchangeToIco(address owner) private returns (bool) {
129 	    if(icoToken != address(0)) {
130 		    return icoToken.transferFromOwner(owner, balanceFor[owner] * exchangeRate);
131 	    }
132 	    return false;
133 	}
134 
135 	/**
136 	 * @dev Presale contract constructor
137 	 */
138 	function TokenEscrow() {
139 		owner = msg.sender;
140 		
141 		balanceFor[msg.sender] = 50000000000; // Give the creator all initial tokens
142 		
143 		// Discount policy
144 		tokenSupplies[0] = TokenSupply(10000000000, 0, 50000000000); // First million of tokens will go 2000 tokens for 1 eth
145 		tokenSupplies[1] = TokenSupply(20000000000, 0, 50000000000); // Following Two millions of tokens will go 2000 tokens for 1 eth
146 		tokenSupplies[2] = TokenSupply(20000000000, 0, 50000000000); // Two last millions of tokens will go 2000 tokens for 1 eth
147 	    
148 }
149 
150 
151 	// Incoming transfer from the Presale token buyer
152 	function() payable {
153 		
154 		uint tokenAmount; // Amount of tokens which is possible to buy for incoming transfer/payment
155 		uint amountToBePaid; // Amount to be paid
156 		uint amountTransfered = msg.value; // Cost/price in WEI of incoming transfer/payment
157 		
158 		
159 		if (amountTransfered <= 0) {
160 		      	Error('no eth was transfered');
161               		msg.sender.transfer(msg.value);
162 		  	return;
163 		}
164 
165 		if(balanceFor[owner] <= 0) {
166 		      	Error('all tokens sold');
167               		msg.sender.transfer(msg.value);
168 		      	return;
169 		}
170 		
171 		// Determine amount of tokens can be bought according to available supply and discount policy
172 		for (uint discountIndex = 0; discountIndex < tokenSupplies.length; discountIndex++) {
173 			// If it's not possible to buy any tokens at all skip the rest of discount policy
174 			
175 			TokenSupply storage tokenSupply = tokenSupplies[discountIndex];
176 			
177 			if(tokenSupply.totalSupply < tokenSupply.limit) {
178 			
179 				uint tokensPossibleToBuy = amountTransfered / tokenSupply.tokenPriceInWei;
180 
181                 if (tokensPossibleToBuy > balanceFor[owner]) 
182                     tokensPossibleToBuy = balanceFor[owner];
183 
184 				if (tokenSupply.totalSupply + tokensPossibleToBuy > tokenSupply.limit) {
185 					tokensPossibleToBuy = tokenSupply.limit - tokenSupply.totalSupply;
186 				}
187 
188 				tokenSupply.totalSupply += tokensPossibleToBuy;
189 				tokenAmount += tokensPossibleToBuy;
190 
191 				uint delta = tokensPossibleToBuy * tokenSupply.tokenPriceInWei;
192 
193 				amountToBePaid += delta;
194                 		amountTransfered -= delta;
195 			
196 			}
197 		}
198 		
199 		// Do not waste gas if there is no tokens to buy
200 		if (tokenAmount == 0) {
201 		    	Error('no token to buy');
202             		msg.sender.transfer(msg.value);
203 			return;
204         	}
205 		
206 		// Transfer tokens to buyer
207 		transferFromOwner(msg.sender, tokenAmount);
208 
209 		// Transfer money to seller
210 		owner.transfer(amountToBePaid);
211 		
212 		// Refund buyer if overpaid / no tokens to sell
213 		msg.sender.transfer(msg.value - amountToBePaid);
214 		
215 	}
216   
217 	/**
218 	 * @dev Removes/deletes contract
219 	 */
220 	function kill() owneronly {
221 		selfdestruct(msg.sender);
222 	}
223 	
224   
225 	/**
226 	 * @dev Transfers tokens from owner to specified recipient
227 	 * @param _to Recipient address
228 	 * @param _value Token quantity to transfer
229 	 * @return success/failure of transfer
230 	 */
231 	function transferFromOwner(address _to, uint256 _value) private returns (bool success) {
232 		if (balanceFor[owner] < _value) return false;                 // Check if the owner has enough
233 		if (balanceFor[_to] + _value < balanceFor[_to]) return false;  // Check for overflows
234 		balanceFor[owner] -= _value;                          // Subtract from the owner
235 		balanceFor[_to] += _value;                            // Add the same to the recipient
236         	Transfer(owner,_to,_value);
237 		return true;
238 	}
239   
240 }