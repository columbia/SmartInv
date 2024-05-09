1 pragma solidity ^0.4.16;
2 
3  // ERC Token Standard #20 Interface
4  // https://github.com/ethereum/EIPs/issues/20
5  
6 // ----------------------------------------------------------------------------
7 // Safe maths
8 // ----------------------------------------------------------------------------
9 contract SafeMath {
10     function safeAdd(uint a, uint b) public pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function safeMul(uint a, uint b) public pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function safeDiv(uint a, uint b) public pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29  contract ERC20Interface {
30 	/// @notice Get the total token supply
31 	function totalSupply() constant returns (uint256 totalAmount);
32 
33 	/// @notice  Get the account balance of another account with address _owner
34 	function balanceOf(address _owner) constant returns (uint256 balance);
35 
36 	/// @notice  Send _value amount of tokens to address _to
37 	function transfer(address _to, uint256 _value) returns (bool success);
38 
39 	/// @notice  Send _value amount of tokens from address _from to address _to
40 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41 
42 	/// @notice  Allow _spender to withdraw from your account, multiple times, up to the _value amount.
43 	/// @notice  If this function is called again it overwrites the current allowance with _value.
44 	/// @notice  this function is required for some DEX functionality
45 	function approve(address _spender, uint256 _value) returns (bool success);
46 
47 	/// @notice  Returns the amount which _spender is still allowed to withdraw from _owner
48 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
49 
50 	/// @notice  Triggered when tokens are transferred.
51 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
52 
53 	/// @notice  Triggered whenever approve(address _spender, uint256 _value) is called.
54 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55  }
56  
57  contract owned{
58 	address public owner;
59 	address constant supervisor  = 0xEB53fF97ae33B0733CE14E7FDd3C4F90c1c4709b;
60 	
61 	function owned(){
62 		owner = msg.sender;
63 	}
64 
65 	/// @notice Functions with this modifier can only be executed by the owner
66 	modifier isOwner {
67 		assert(msg.sender == owner || msg.sender == supervisor);
68 		_;
69 	}
70 	
71 	/// @notice Transfer the ownership of this contract
72 	function transferOwnership(address newOwner);
73 	
74 	event ownerChanged(address whoTransferredOwnership, address formerOwner, address newOwner);
75  }
76 
77 contract METADOLLAR is ERC20Interface, owned, SafeMath {
78 
79 	string public constant name = "METADOLLAR";
80 	string public constant symbol = "DOL";
81 	uint public constant decimals = 18;
82 	uint256 public _totalSupply = 1000000000000000000000000000;
83 	uint256 public icoMin = 1000000000000000000000000000;					// = 300000; amount is in Tokens, 1.800.000
84 	uint256 public preIcoLimit = 1000000000000000000;			// = 600000; amount is in tokens, 3.600.000
85 	uint256 public countHolders = 0;				// count how many unique holders have tokens
86 	uint256 public amountOfInvestments = 0;	// amount of collected wei
87 	
88 	uint256 preICOprice;									// price of 1 token in weis for the preICO time
89 	uint256 ICOprice;										// price of 1 token in weis for the ICO time
90 	uint256 public currentTokenPrice;				// current token price in weis
91 	uint256 public sellPrice;								// buyback price of one token in weis
92 	uint256 public commission1;
93 	uint256 public commission2;
94 	bool public preIcoIsRunning;
95 	bool public minimalGoalReached;
96 	bool public icoIsClosed;
97 	bool icoExitIsPossible;
98 	
99 
100 	//Balances for each account
101 	mapping (address => uint256) public tokenBalanceOf;
102 
103 	// Owner of account approves the transfer of an amount to another account
104 	mapping(address => mapping (address => uint256)) allowed;
105 	
106 	//list with information about frozen accounts
107 	mapping(address => bool) frozenAccount;
108 	
109 	//this generate a public event on a blockchain that will notify clients
110 	event FrozenFunds(address initiator, address account, string status);
111 	
112 	//this generate a public event on a blockchain that will notify clients
113 	event BonusChanged(uint8 bonusOld, uint8 bonusNew);
114 	
115 	//this generate a public event on a blockchain that will notify clients
116 	event minGoalReached(uint256 minIcoAmount, string notice);
117 	
118 	//this generate a public event on a blockchain that will notify clients
119 	event preIcoEnded(uint256 preIcoAmount, string notice);
120 	
121 	//this generate a public event on a blockchain that will notify clients
122 	event priceUpdated(uint256 oldPrice, uint256 newPrice, string notice);
123 	
124 	//this generate a public event on a blockchain that will notify clients
125 	event withdrawed(address _to, uint256 summe, string notice);
126 	
127 	//this generate a public event on a blockchain that will notify clients
128 	event deposited(address _from, uint256 summe, string notice);
129 	
130 	//this generate a public event on a blockchain that will notify clients
131 	event orderToTransfer(address initiator, address _from, address _to, uint256 summe, string notice);
132 	
133 	//this generate a public event on a blockchain that will notify clients
134 	event tokenCreated(address _creator, uint256 summe, string notice);
135 	
136 	//this generate a public event on a blockchain that will notify clients
137 	event tokenDestroyed(address _destroyer, uint256 summe, string notice);
138 	
139 	//this generate a public event on a blockchain that will notify clients
140 	event icoStatusUpdated(address _initiator, string status);
141 
142 	/// @notice Constructor of the contract
143 	function STARTMETADOLLAR() {
144 		preIcoIsRunning = true;
145 		minimalGoalReached = false;
146 		icoExitIsPossible = false;
147 		icoIsClosed = false;
148 		tokenBalanceOf[this] += _totalSupply;
149 		allowed[this][owner] = _totalSupply;
150 		allowed[this][supervisor] = _totalSupply;
151 		currentTokenPrice = 1000 * 1;	// initial price of 1 Token
152 		preICOprice = 1000 * 1; 			// price of 1 token in weis for the preICO time, ca.6,- Euro
153 		ICOprice = 1000 * 1;				// price of 1 token in weis for the ICO time, ca.10,- Euro
154 		sellPrice = 1000;
155 		commission1 = 1000;
156 		commission2 = 950;
157 		updatePrices();
158 	}
159 
160 	function () payable {
161 		require(!frozenAccount[msg.sender]);
162 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
163 			buyToken();
164 		}
165 	}
166 
167 	/// @notice Returns a whole amount of tokens
168 	function totalSupply() constant returns (uint256 totalAmount) {
169 		totalAmount = _totalSupply;
170 	}
171 
172 	/// @notice What is the balance of a particular account?
173 	function balanceOf(address _owner) constant returns (uint256 balance) {
174 		return tokenBalanceOf[_owner];
175 	}
176 
177 	/// @notice Shows how much tokens _spender can spend from _owner address
178 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
179 		return allowed[_owner][_spender];
180 	}
181 	
182 	/// @notice Calculates amount of weis needed to buy more than one token
183 	/// @param howManyTokenToBuy - Amount of tokens to calculate
184 	function calculateTheEndPrice(uint256 howManyTokenToBuy) constant returns (uint256 summarizedPriceInWeis) {
185 		if(howManyTokenToBuy > 0) {
186 			summarizedPriceInWeis = howManyTokenToBuy * currentTokenPrice;
187 		}else {
188 			summarizedPriceInWeis = 0;
189 		}
190 	}
191 	
192 	/// @notice Shows if account is frozen
193 	/// @param account - Accountaddress to check
194 	function checkFrozenAccounts(address account) constant returns (bool accountIsFrozen) {
195 		accountIsFrozen = frozenAccount[account];
196 	}
197 
198 	/// @notice Buy tokens from contract by sending ether
199 	function buy() payable public {
200 		require(!frozenAccount[msg.sender]);
201 		require(msg.value > 0);
202 		buyToken();
203 	}
204 
205 	/// @notice Sell tokens and receive ether from contract
206 	function sell(uint256 amount) {
207 		require(!frozenAccount[msg.sender]);
208 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
209 		require(amount > 0);
210 		require(sellPrice > 0);
211 		_transfer(msg.sender, this, amount);
212 		uint256 revenue = amount * sellPrice;
213 		require(this.balance >= revenue);
214 		msg.sender.transfer(revenue);                		// sends ether to the seller: it's important to do this last to prevent recursion attacks
215 	}
216 	
217 	/// @notice Allow user to sell maximum possible amount of tokens, depend on ether amount on contract
218 	function sellMaximumPossibleAmountOfTokens() {
219 		require(!frozenAccount[msg.sender]);
220 		require(tokenBalanceOf[msg.sender] > 0);
221 		require(this.balance > sellPrice);
222 		if(tokenBalanceOf[msg.sender] * sellPrice <= this.balance) {
223 			sell(tokenBalanceOf[msg.sender]);
224 		}else {
225 			sell(this.balance / sellPrice);
226 		}
227 	}
228 
229 	/// @notice Transfer amount of tokens from own wallet to someone else
230 	function transfer(address _to, uint256 _value) returns (bool success) {
231 		assert(msg.sender != address(0));
232 		assert(_to != address(0));
233 		require(!frozenAccount[msg.sender]);
234 		require(!frozenAccount[_to]);
235 		require(tokenBalanceOf[msg.sender] >= _value);
236 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
237 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
238 		require(_value > 0);
239 		_transfer(msg.sender, _to, _value);
240 		return true;
241 	}
242 
243 	/// @notice  Send _value amount of tokens from address _from to address _to
244 	/// @notice  The transferFrom method is used for a withdraw workflow, allowing contracts to send
245 	/// @notice  tokens on your behalf, for example to "deposit" to a contract address and/or to charge
246 	/// @notice  fees in sub-currencies; the command should fail unless the _from account has
247 	/// @notice  deliberately authorized the sender of the message via some mechanism; we propose
248 	/// @notice  these standardized APIs for approval:
249 	function transferFrom(address _from,	address _to,	uint256 _value) returns (bool success) {
250 		assert(msg.sender != address(0));
251 		assert(_from != address(0));
252 		assert(_to != address(0));
253 		require(!frozenAccount[msg.sender]);
254 		require(!frozenAccount[_from]);
255 		require(!frozenAccount[_to]);
256 		require(tokenBalanceOf[_from] >= _value);
257 		require(allowed[_from][msg.sender] >= _value);
258 		require(tokenBalanceOf[_from] - _value < tokenBalanceOf[_from]);
259 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
260 		require(_value > 0);
261 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer tokens from allowed account");
262 		_transfer(_from, _to, _value);
263 		allowed[_from][msg.sender] -= _value;
264 		return true;
265 	}
266 
267 	/// @notice Allow _spender to withdraw from your account, multiple times, up to the _value amount.
268 	/// @notice If this function is called again it overwrites the current allowance with _value.
269 	function approve(address _spender, uint256 _value) returns (bool success) {
270 		require(!frozenAccount[msg.sender]);
271 		assert(_spender != address(0));
272 		require(_value >= 0);
273 		allowed[msg.sender][_spender] = _value;
274 		return true;
275 	}
276 
277 	/// @notice Check if minimal goal of ICO is reached
278 	function checkMinimalGoal() internal {
279 		if(tokenBalanceOf[this] <= _totalSupply - icoMin) {
280 			minimalGoalReached = true;
281 			minGoalReached(icoMin, "Minimal goal of ICO is reached!");
282 		}
283 	}
284 
285 	/// @notice Check if preICO is ended
286 	function checkPreIcoStatus() internal {
287 		if(tokenBalanceOf[this] <= _totalSupply - preIcoLimit) {
288 			preIcoIsRunning = false;
289 			preIcoEnded(preIcoLimit, "Token amount for preICO sold!");
290 		}
291 	}
292 
293 	/// @notice Processing each buying
294 	function buyToken() internal {
295 		uint256 value = msg.value;
296 		address sender = msg.sender;
297 		require(!icoIsClosed);
298 		require(!frozenAccount[sender]);
299 		require(value > 0);
300 		require(currentTokenPrice > 0);
301 		uint256 detracted = currentTokenPrice / (commission1 * commission2);
302 		uint256 amount = value / detracted;			// calculates amount of tokens
303 		uint256 moneyBack = value - (amount * detracted);
304 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
305 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
306 		updatePrices();
307 		_transfer(this, sender, amount);
308 		if(!minimalGoalReached) {
309 			checkMinimalGoal();
310 		}
311 		if(moneyBack > 0) {
312 			sender.transfer(moneyBack);
313 		}
314 	}
315 
316 	/// @notice Internal transfer, can only be called by this contract
317 	function _transfer(address _from, address _to, uint256 _value) internal {
318 		assert(_from != address(0));
319 		assert(_to != address(0));
320 		require(_value > 0);
321 		require(tokenBalanceOf[_from] >= _value);
322 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
323 		require(!frozenAccount[_from]);
324 		require(!frozenAccount[_to]);
325 		if(tokenBalanceOf[_to] == 0){
326 			countHolders += 1;
327 		}
328 		tokenBalanceOf[_from] -= _value;
329 		if(tokenBalanceOf[_from] == 0){
330 			countHolders -= 1;
331 		}
332 		tokenBalanceOf[_to] += _value;
333 		allowed[this][owner] = tokenBalanceOf[this];
334 		allowed[this][supervisor] = tokenBalanceOf[this];
335 		Transfer(_from, _to, _value);
336 	}
337 
338 	/// @notice Set current ICO prices in wei for one token
339 	function updatePrices() internal {
340 		uint256 oldPrice = currentTokenPrice;
341 		if(preIcoIsRunning) {
342 			checkPreIcoStatus();
343 		}
344 		if(preIcoIsRunning) {
345 			currentTokenPrice = preICOprice;
346 		}else{
347 			currentTokenPrice = ICOprice;
348 		}
349 		
350 		if(oldPrice != currentTokenPrice) {
351 			priceUpdated(oldPrice, currentTokenPrice, "Token price updated!");
352 		}
353 	}
354 
355 	/// @notice Set current preICO price in wei for one token
356 	/// @param priceForPreIcoInWei - is the amount in wei for one token
357 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
358 		require(priceForPreIcoInWei > 0);
359 		require(preICOprice != priceForPreIcoInWei);
360 		preICOprice = priceForPreIcoInWei;
361 		updatePrices();
362 	}
363 
364 	/// @notice Set current ICO price in wei for one token
365 	/// @param priceForIcoInWei - is the amount in wei for one token
366 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
367 		require(priceForIcoInWei > 0);
368 		require(ICOprice != priceForIcoInWei);
369 		ICOprice = priceForIcoInWei;
370 		updatePrices();
371 	}
372 
373 	/// @notice Set both prices at the same time
374 	/// @param priceForPreIcoInWei - Price of the token in pre ICO
375 	/// @param priceForIcoInWei - Price of the token in ICO
376 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
377 		require(priceForPreIcoInWei > 0);
378 		require(priceForIcoInWei > 0);
379 		preICOprice = priceForPreIcoInWei;
380 		ICOprice = priceForIcoInWei;
381 		updatePrices();
382 	}
383 
384 	/// @notice Set the current sell price in wei for one token
385 	/// @param priceInWei - is the amount in wei for one token
386 	function setSellPrice(uint256 priceInWei) isOwner {
387 		require(priceInWei >= 0);
388 		sellPrice = priceInWei;
389 	}
390 
391 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving tokens
392 	/// @param account - address to be frozen
393 	/// @param freeze - select is the account frozen or not
394 	function freezeAccount(address account, bool freeze) isOwner {
395 		require(account != owner);
396 		require(account != supervisor);
397 		frozenAccount[account] = freeze;
398 		if(freeze) {
399 			FrozenFunds(msg.sender, account, "Account set frozen!");
400 		}else {
401 			FrozenFunds(msg.sender, account, "Account set free for use!");
402 		}
403 	}
404 
405 	/// @notice Create an amount of token
406 	/// @param amount - token to create
407 	function mintToken(uint256 amount) isOwner {
408 		require(amount > 0);
409 		require(tokenBalanceOf[this] <= icoMin);	// owner can create token only if the initial amount is strongly not enough to supply and demand ICO
410 		require(_totalSupply + amount > _totalSupply);
411 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
412 		_totalSupply += amount;
413 		tokenBalanceOf[this] += amount;
414 		allowed[this][owner] = tokenBalanceOf[this];
415 		allowed[this][supervisor] = tokenBalanceOf[this];
416 		tokenCreated(msg.sender, amount, "Additional tokens created!");
417 	}
418 
419 	/// @notice Destroy an amount of token
420 	/// @param amount - token to destroy
421 	function destroyToken(uint256 amount) isOwner {
422 		require(amount > 0);
423 		require(tokenBalanceOf[this] >= amount);
424 		require(_totalSupply >= amount);
425 		require(tokenBalanceOf[this] - amount >= 0);
426 		require(_totalSupply - amount >= 0);
427 		tokenBalanceOf[this] -= amount;
428 		_totalSupply -= amount;
429 		allowed[this][owner] = tokenBalanceOf[this];
430 		allowed[this][supervisor] = tokenBalanceOf[this];
431 		tokenDestroyed(msg.sender, amount, "An amount of tokens destroyed!");
432 	}
433 
434 	/// @notice Transfer the ownership to another account
435 	/// @param newOwner - address who get the ownership
436 	function transferOwnership(address newOwner) isOwner {
437 		assert(newOwner != address(0));
438 		address oldOwner = owner;
439 		owner = newOwner;
440 		ownerChanged(msg.sender, oldOwner, newOwner);
441 		allowed[this][oldOwner] = 0;
442 		allowed[this][newOwner] = tokenBalanceOf[this];
443 	}
444 
445 	/// @notice Transfer ether from smartcontract to owner
446 	function collect() isOwner {
447         require(this.balance > 0);
448 		withdraw(this.balance);
449     }
450 
451 	/// @notice Withdraw an amount of ether
452 	/// @param summeInWei - amout to withdraw
453 	function withdraw(uint256 summeInWei) isOwner {
454 		uint256 contractbalance = this.balance;
455 		address sender = msg.sender;
456 		require(contractbalance >= summeInWei);
457 		withdrawed(sender, summeInWei, "wei withdrawed");
458         sender.transfer(summeInWei);
459 	}
460 
461 	/// @notice Deposit an amount of ether
462 	function deposit() payable isOwner {
463 		require(msg.value > 0);
464 		require(msg.sender.balance >= msg.value);
465 		deposited(msg.sender, msg.value, "wei deposited");
466 	}
467 
468 	/// @notice Allow user to exit ICO
469 	/// @param exitAllowed - status if the exit is allowed
470 	function allowIcoExit(bool exitAllowed) isOwner {
471 		require(icoExitIsPossible != exitAllowed);
472 		icoExitIsPossible = exitAllowed;
473 	}
474 
475 	/// @notice Stop running ICO
476 	/// @param icoIsStopped - status if this ICO is stopped
477 	function stopThisIco(bool icoIsStopped) isOwner {
478 		require(icoIsClosed != icoIsStopped);
479 		icoIsClosed = icoIsStopped;
480 		if(icoIsStopped) {
481 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
482 		}else {
483 			icoStatusUpdated(msg.sender, "Coin offering is running!");
484 		}
485 	}
486 
487 }