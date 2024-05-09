1 /**
2  * Source Code first verified at https://etherscan.io
3  * WorldTrade asset Smart Contract v4.1
4 */
5 
6 pragma solidity ^0.4.16;
7 
8 
9 /*
10  * @title Standard Token Contract
11  *
12  * ERC20-compliant tokens => https://github.com/ethereum/EIPs/issues/20
13  * A token is a fungible virtual good that can be traded.
14  * ERC-20 Tokens comply to the standard described in the Ethereum ERC-20 proposal.
15  * Basic, standardized Token contract. Defines the functions to check token balances
16  * send tokens, send tokens on behalf of a 3rd party and the corresponding approval process.
17  *
18  */
19 contract Token {
20 
21 	// **** BASE FUNCTIONALITY
22 	// @notice For debugging purposes when using solidity online browser
23 	function whoAmI()  constant returns (address) {
24 	    return msg.sender;
25 	}
26 
27 	// SC owners:
28 	
29 	address owner;
30 	
31 	function isOwner() returns (bool) {
32 		if (msg.sender == owner) return true;
33 		return false;
34 	}
35 
36 	// **** EVENTS
37 
38 	// @notice A generic error log
39 	event Error(string error);
40 
41 
42 	// **** DATA
43 	mapping (address => uint256) balances;
44 	mapping (address => mapping (address => uint256)) allowed;
45 	uint256 public initialSupply; // Initial and total token supply
46 	uint256 public totalSupply;
47 	// bool allocated = false; // True after defining token parameters and initial mint
48 	
49 	// Public variables of the token, all used for display
50 	// HumanStandardToken is a specialisation of ERC20 defining these parameters
51 	string public name;
52 	string public symbol;
53 	uint8 public decimals;
54 	string public standard = 'H0.1';
55 
56 	// **** METHODS
57 	
58 	// Get total amount of tokens, totalSupply is a public var actually
59 	// function totalSupply() constant returns (uint256 totalSupply) {}
60 	
61 	// Get the account balance of another account with address _owner
62 	function balanceOf(address _owner) constant returns (uint256 balance) {
63 		return balances[_owner];
64 	}
65  
66  	// Send _amount amount of tokens to address _to
67 	function transfer(address _to, uint256 _amount) returns (bool success) {
68 		if (balances[msg.sender] < _amount) {
69 			Error('transfer: the amount to transfer is higher than your token balance');
70 			return false;
71 		}
72 		balances[msg.sender] -= _amount;
73 		balances[_to] += _amount;
74 		Transfer(msg.sender, _to, _amount);
75 
76 		return true;
77 	}
78  
79  	// Send _amount amount of tokens from address _from to address _to
80  	// The transferFrom method is used for a withdraw workflow, allowing contracts to send 
81  	// tokens on your behalf, for example to "deposit" to a contract address and/or to charge 
82  	// fees in sub-currencies; the command should fail unless the _from account has 
83  	// deliberately authorized the sender of the message via some mechanism
84 	function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
85 		if (balances[_from] < _amount) {
86 			Error('transfer: the amount to transfer is higher than the token balance of the source');
87 			return false;
88 		}
89 		if (allowed[_from][msg.sender] < _amount) {
90 			Error('transfer: the amount to transfer is higher than the maximum token transfer allowed by the source');
91 			return false;
92 		}
93 		balances[_from] -= _amount;
94 		balances[_to] += _amount;
95 		allowed[_from][msg.sender] -= _amount;
96 		Transfer(_from, _to, _amount);
97 
98 		return true;
99 	}
100  
101  	// Allow _spender to withdraw from your account, multiple times, up to the _amount amount. 
102  	// If this function is called again it overwrites the current allowance with _amount.
103 	function approve(address _spender, uint256 _amount) returns (bool success) {
104 		allowed[msg.sender][_spender] = _amount;
105 		Approval(msg.sender, _spender, _amount);
106 		
107 		return true;
108 	}
109  
110  	// Returns the amount which _spender is still allowed to withdraw from _owner
111 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
112 		return allowed[_owner][_spender];
113 	}
114 	
115 	// Constructor: set up token properties and owner token balance
116 	function Token() {
117 		// This is the constructor, so owner should be equal to msg.sender, and this method should be called just once
118 		owner = msg.sender;
119 		
120 		// make sure owner address is configured
121 		// if(owner == 0x0) throw;
122 
123 		// owner address can call this function
124 		// if (msg.sender != owner ) throw;
125 
126 		// call this function just once
127 		// if (allocated) throw;
128 
129 		initialSupply = 50000000 * 1000000; // 50M tokens, 6 decimals
130 		totalSupply = initialSupply;
131 		
132 		name = "WorldTrade";
133 		symbol = "WTE";
134 		decimals = 6;
135 
136 		balances[owner] = totalSupply;
137 		Transfer(this, owner, totalSupply);
138 
139 		// allocated = true;
140 	}
141 
142 	// **** EVENTS
143 	
144 	// Triggered when tokens are transferred
145 	event Transfer(address indexed _from, address indexed _to, uint256 _amount);
146 	
147 	// Triggered whenever approve(address _spender, uint256 _amount) is called
148 	event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
149 }
150 
151 
152 // Interface of issuer contract, just to cast the contract address and make it callable from the asset contract
153 contract IFIssuers {
154 	
155 	// **** DATA
156 	
157 	// **** FUNCTIONS
158 	function isIssuer(address _issuer) constant returns (bool);
159 }
160 
161 
162 contract Asset is Token {
163 	// **** DATA
164 	
165 	/** Asset states
166 	*
167 	* - Released: Once issued the asset stays as released until sent for free to someone specified by issuer
168 	* - ForSale: The asset belongs to a user and is open to be sold
169 	* - Unfungible: The asset cannot be sold, remaining to the user it belongs to.
170 	*/
171 	enum assetStatus { Released, ForSale, Unfungible }
172 	// https://ethereum.stackexchange.com/questions/1807/enums-in-solidity
173 	
174 	struct asst {
175 		uint256 assetId;
176 		address assetOwner;
177 		address issuer;
178 		string content; // a JSON object containing the image data of the asset and its title
179 		uint256 sellPrice; // in WorldTrade tokens, how many of them for this asset
180 		assetStatus status; // behaviour (tradability) of the asset depends upon its status
181 	}
182 
183 	mapping (uint256 => asst) assetsById;
184 	uint256 lastAssetId; // Last assetId
185 	address public SCIssuers; // Contract that defines who is an issuer and who is not
186 	uint256 assetFeeIssuer; // Fee percentage for Issuer on every asset sale transaction
187 	uint256 assetFeeWorldTrade; // Fee percentage for WorldTrade on every asset sale transaction
188 	
189 
190 	// **** METHODS
191 	
192 	// Constructor
193 	function Asset(address _SCIssuers) {
194 		SCIssuers = _SCIssuers;
195 	}
196 	
197 	// Queries the asset, knowing the id
198 	function getAssetById(uint256 assetId) constant returns (uint256 _assetId, address _assetOwner, address _issuer, string _content, uint256 _sellPrice, uint256 _status) {
199 		return (assetsById[assetId].assetId, assetsById[assetId].assetOwner, assetsById[assetId].issuer, assetsById[assetId].content, assetsById[assetId].sellPrice, uint256(assetsById[assetId].status));
200 	}
201 
202 	// Seller sends an owned asset to a buyer, providing its allowance matches token price and transfer the tokens from buyer
203 	function sendAssetTo(uint256 assetId, address assetBuyer) returns (bool) {
204 		// assetId must not be zero
205 		if (assetId == 0) {
206 			Error('sendAssetTo: assetId must not be zero');
207 			return false;
208 		}
209 
210 		// Check whether the asset belongs to the seller
211 		if (assetsById[assetId].assetOwner != msg.sender) {
212 			Error('sendAssetTo: the asset does not belong to you, the seller');
213 			return false;
214 		}
215 		
216 		if (assetsById[assetId].sellPrice > 0) { // for non-null token paid transactions
217 			// Check whether there is balance enough from the buyer to get its tokens
218 			if (balances[assetBuyer] < assetsById[assetId].sellPrice) {
219 				Error('sendAssetTo: there is not enough balance from the buyer to get its tokens');
220 				return false;
221 			}
222 
223 			// Check whether there is allowance enough from the buyer to get its tokens
224 			if (allowance(assetBuyer, msg.sender) < assetsById[assetId].sellPrice) {
225 				Error('sendAssetTo: there is not enough allowance from the buyer to get its tokens');
226 				return false;
227 			}
228 
229 			// Get the buyer tokens
230 			if (!transferFrom(assetBuyer, msg.sender, assetsById[assetId].sellPrice)) {
231 				Error('sendAssetTo: transferFrom failed'); // This shouldn't happen ever, but just in case...
232 				return false;
233 			}
234 		}
235 		
236 		// Set the asset status to Unfungible
237 		assetsById[assetId].status = assetStatus.Unfungible;
238 		
239 		// Transfer the asset to the buyer
240 		assetsById[assetId].assetOwner = assetBuyer;
241 		
242 		// Event log
243 		SendAssetTo(assetId, assetBuyer);
244 		
245 		return true;
246 	}
247 	
248 	// Buyer gets an asset providing it is in ForSale status, and pays the corresponding tokens to the seller/owner. amount must match assetPrice to have a deal.
249 	function buyAsset(uint256 assetId, uint256 amount) returns (bool) {
250 		// assetId must not be zero
251 		if (assetId == 0) {
252 			Error('buyAsset: assetId must not be zero');
253 			return false;
254 		}
255 
256 		// Check whether the asset is in ForSale status
257 		if (assetsById[assetId].status != assetStatus.ForSale) {
258 			Error('buyAsset: the asset is not for sale');
259 			return false;
260 		}
261 		
262 		// Check whether the asset price is the same as amount
263 		if (assetsById[assetId].sellPrice != amount) {
264 			Error('buyAsset: the asset price does not match the specified amount');
265 			return false;
266 		}
267 		
268 		if (assetsById[assetId].sellPrice > 0) { // for non-null token paid transactions
269 			// Check whether there is balance enough from the buyer to pay the asset
270 			if (balances[msg.sender] < assetsById[assetId].sellPrice) {
271 				Error('buyAsset: there is not enough token balance to buy this asset');
272 				return false;
273 			}
274 			
275 			// Calculate the seller income
276 			uint256 sellerIncome = assetsById[assetId].sellPrice * (1000 - assetFeeIssuer - assetFeeWorldTrade) / 1000;
277 
278 			// Send the buyer's tokens to the seller
279 			if (!transfer(assetsById[assetId].assetOwner, sellerIncome)) {
280 				Error('buyAsset: seller token transfer failed'); // This shouldn't happen ever, but just in case...
281 				return false;
282 			}
283 			
284 			// Send the issuer's fee
285 			uint256 issuerIncome = assetsById[assetId].sellPrice * assetFeeIssuer / 1000;
286 			if (!transfer(assetsById[assetId].issuer, issuerIncome)) {
287 				Error('buyAsset: issuer token transfer failed'); // This shouldn't happen ever, but just in case...
288 				return false;
289 			}
290 			
291 			// Send the WorldTrade's fee
292 			uint256 WorldTradeIncome = assetsById[assetId].sellPrice * assetFeeWorldTrade / 1000;
293 			if (!transfer(owner, WorldTradeIncome)) {
294 				Error('buyAsset: WorldTrade token transfer failed'); // This shouldn't happen ever, but just in case...
295 				return false;
296 			}
297 		}
298 				
299 		// Set the asset status to Unfungible
300 		assetsById[assetId].status = assetStatus.Unfungible;
301 		
302 		// Transfer the asset to the buyer
303 		assetsById[assetId].assetOwner = msg.sender;
304 		
305 		// Event log
306 		BuyAsset(assetId, amount);
307 		
308 		return true;
309 	}
310 	
311 	
312 	// To limit issue functions just to authorized issuers
313 	modifier onlyIssuer() {
314 	    if (!IFIssuers(SCIssuers).isIssuer(msg.sender)) {
315 	    	Error('onlyIssuer function called by user that is not an authorized issuer');
316 	    } else {
317 	    	_;
318 	    }
319 	}
320 
321 	
322 	// To be called by issueAssetTo() and properly authorized issuers
323 	function issueAsset(string content, uint256 sellPrice) onlyIssuer internal returns (uint256 nextAssetId) {
324 		// Find out next asset Id
325 		nextAssetId = lastAssetId + 1;
326 		
327 		assetsById[nextAssetId].assetId = nextAssetId;
328 		assetsById[nextAssetId].assetOwner = msg.sender;
329 		assetsById[nextAssetId].issuer = msg.sender;
330 		assetsById[nextAssetId].content = content;
331 		assetsById[nextAssetId].sellPrice = sellPrice;
332 		assetsById[nextAssetId].status = assetStatus.Released;
333 		
334 		// Update lastAssetId
335 		lastAssetId++;
336 
337 		// Event log
338 		IssueAsset(nextAssetId, msg.sender, sellPrice);
339 		
340 		return nextAssetId;
341 	}
342 	
343 	// Issuer sends a new free asset to a given user as a gift
344 	function issueAssetTo(string content, address to) returns (bool) {
345 		uint256 assetId = issueAsset(content, 0); // 0 tokens, as a gift
346 		if (assetId == 0) {
347 			Error('issueAssetTo: asset has not been properly issued');
348 			return (false);
349 		}
350 		
351 		// The brand new asset is inmediatly sent to the recipient
352 		return(sendAssetTo(assetId, to));
353 	}
354 	
355 	// Seller can block tradability of its assets
356 	function setAssetUnfungible(uint256 assetId) returns (bool) {
357 		// assetId must not be zero
358 		if (assetId == 0) {
359 			Error('setAssetUnfungible: assetId must not be zero');
360 			return false;
361 		}
362 
363 		// Check whether the asset belongs to the caller
364 		if (assetsById[assetId].assetOwner != msg.sender) {
365 			Error('setAssetUnfungible: only owners of the asset are allowed to update its status');
366 			return false;
367 		}
368 		
369 		assetsById[assetId].status = assetStatus.Unfungible;
370 
371 		// Event log
372 		SetAssetUnfungible(assetId, msg.sender);
373 		
374 		return true;
375 	}
376 
377 	// Seller updates the price of its assets and its status to ForSale
378 	function setAssetPrice(uint256 assetId, uint256 sellPrice) returns (bool) {
379 		// assetId must not be zero
380 		if (assetId == 0) {
381 			Error('setAssetPrice: assetId must not be zero');
382 			return false;
383 		}
384 
385 		// Check whether the asset belongs to the caller
386 		if (assetsById[assetId].assetOwner != msg.sender) {
387 			Error('setAssetPrice: only owners of the asset are allowed to set its price and update its status');
388 			return false;
389 		}
390 		
391 		assetsById[assetId].sellPrice = sellPrice;
392 		assetsById[assetId].status = assetStatus.ForSale;
393 
394 		// Event log
395 		SetAssetPrice(assetId, msg.sender, sellPrice);
396 		
397 		return true;
398 	}
399 
400 	// Owner updates the fees for assets sale transactions
401 	function setAssetSaleFees(uint256 feeIssuer, uint256 feeWorldTrade) returns (bool) {
402 		// Check this is called by owner
403 		if (!isOwner()) {
404 			Error('setAssetSaleFees: only Owner is authorized to update asset sale fees.');
405 			return false;
406 		}
407 		
408 		// Check new fees are consistent
409 		if (feeIssuer + feeWorldTrade > 1000) {
410 			Error('setAssetSaleFees: added fees exceed 100.0%. Not updated.');
411 			return false;
412 		}
413 		
414 		assetFeeIssuer = feeIssuer;
415 		assetFeeWorldTrade = feeWorldTrade;
416 
417 		// Event log
418 		SetAssetSaleFees(feeIssuer, feeWorldTrade);
419 		
420 		return true;
421 	}
422 
423 
424 
425 	// **** EVENTS
426 
427 	// Triggered when a seller sends its asset to a buyer and receives the corresponding tokens
428 	event SendAssetTo(uint256 assetId, address assetBuyer);
429 	
430 	// Triggered when a buyer sends its tokens to a seller and receives the specified asset
431 	event BuyAsset(uint256 assetId, uint256 amount);
432 
433 	// Triggered when the admin issues a new asset
434 	event IssueAsset(uint256 nextAssetId, address assetOwner, uint256 sellPrice);
435 	
436 	// Triggered when the user updates its asset status to Unfungible
437 	event SetAssetUnfungible(uint256 assetId, address assetOwner);
438 
439 	// Triggered when the user updates its asset price and status to ForSale
440 	event SetAssetPrice(uint256 assetId, address assetOwner, uint256 sellPrice);
441 	
442 	// Triggered when the owner updates the asset sale fees
443 	event SetAssetSaleFees(uint256 feeIssuer, uint256 feeWorldTrade);
444 }