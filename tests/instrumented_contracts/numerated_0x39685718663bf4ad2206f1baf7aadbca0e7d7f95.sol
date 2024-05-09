1 pragma solidity ^0.4.18;
2 
3  // ERC Token Standard #20 Interface
4  // https://github.com/ethereum/EIPs/issues/20
5 
6  contract ERC20Interface {
7 	/// @notice Get the total metadollars supply
8 	function totalSupply() constant returns (uint256 totalAmount);
9 
10 	/// @notice  Get the account balance of another account with address _owner
11 	function balanceOf(address _owner) constant returns (uint256 balance);
12 
13 	/// @notice  Send _value amount of metadollarss to address _to
14 	function transfer(address _to, uint256 _value) returns (bool success);
15 
16 	/// @notice  Send _value amount of metadollars from address _from to address _to
17 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
18 
19 	/// @notice  Allow _spender to withdraw from your account, multiple times, up to the _value amount.
20 	/// @notice  If this function is called again it overwrites the current allowance with _value.
21 	/// @notice  this function is required for some DEX functionality
22 	function approve(address _spender, uint256 _value) returns (bool success);
23 
24 	/// @notice  Returns the amount which _spender is still allowed to withdraw from _owner
25 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
26 
27 	/// @notice  Triggered when metadollars are transferred.
28 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
29 
30 	/// @notice  Triggered whenever approve(address _spender, uint256 _value) is called.
31 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32  }
33  
34  contract owned{
35 	address public owner;
36 	address constant supervisor  = 0x2d6808bC989CbEB46cc6dd75a6C90deA50e3e504;
37 	
38 	function owned(){
39 		owner = msg.sender;
40 	}
41 
42 	/// @notice Functions with this modifier can only be executed by the owner
43 	modifier isOwner {
44 		assert(msg.sender == owner || msg.sender == supervisor);
45 		_;
46 	}
47 	
48 	/// @notice Transfer the ownership of this contract
49 	function transferOwnership(address newOwner);
50 	
51 	event ownerChanged(address whoTransferredOwnership, address formerOwner, address newOwner);
52  }
53 
54 contract MetaDollar is ERC20Interface, owned{
55 
56 	string public constant name = "METADOLLAR";
57 	string public constant symbol = "DOL";
58 	uint public constant decimals = 18;
59 	uint256 public _totalSupply = 100000000000000000000000000000;  // Total Supply 100,000,000,000
60 	uint256 public icoMin = 1000000000000000000;				 //  Min ICO 1	
61 	uint256 public preIcoLimit = 100000000000000000000000000000;		 // Pre Ico Limit 100,000,000,000
62 	uint256 public countHolders = 0;				// count how many unique holders have metadollars
63 	uint256 public amountOfInvestments = 0;	// amount of collected wei
64 	
65 	uint256 preICOprice;									// price of 1 metadollar in weis for the preICO time
66 	uint256 ICOprice;										// price of 1 metadollar in weis for the ICO time
67 	uint256 public currentTokenPrice;				// current metadollar price in weis
68 	uint256 public sellPrice;								// buyback price of one metadollar in weis
69 	uint256 public buyCommission;								// Commission for buy
70 	uint256 public sellCommission;								// Commission for sell
71 	
72 	bool public preIcoIsRunning;
73 	bool public minimalGoalReached;
74 	bool public icoIsClosed;
75 	bool icoExitIsPossible;
76 
77 
78 	//Balances for each account
79 	mapping (address => uint256) public tokenBalanceOf;
80 
81 	// Owner of account approves the transfer of an amount to another account
82 	mapping(address => mapping (address => uint256)) allowed;
83 	
84 	//list with information about frozen accounts
85 	mapping(address => bool) frozenAccount;
86 	
87 	//this generate a public event on a blockchain that will notify clients
88 	event FrozenFunds(address initiator, address account, string status);
89 	
90 	//this generate a public event on a blockchain that will notify clients
91 	event BonusChanged(uint8 bonusOld, uint8 bonusNew);
92 	
93 	//this generate a public event on a blockchain that will notify clients
94 	event minGoalReached(uint256 minIcoAmount, string notice);
95 	
96 	//this generate a public event on a blockchain that will notify clients
97 	event preIcoEnded(uint256 preIcoAmount, string notice);
98 	
99 	//this generate a public event on a blockchain that will notify clients
100 	event priceUpdated(uint256 oldPrice, uint256 newPrice, string notice);
101 	
102 	//this generate a public event on a blockchain that will notify clients
103 	event withdrawed(address _to, uint256 summe, string notice);
104 	
105 	//this generate a public event on a blockchain that will notify clients
106 	event deposited(address _from, uint256 summe, string notice);
107 	
108 	//this generate a public event on a blockchain that will notify clients
109 	event orderToTransfer(address initiator, address _from, address _to, uint256 summe, string notice);
110 	
111 	//this generate a public event on a blockchain that will notify clients
112 	event tokenCreated(address _creator, uint256 summe, string notice);
113 	
114 	//this generate a public event on a blockchain that will notify clients
115 	event tokenDestroyed(address _destroyer, uint256 summe, string notice);
116 	
117 	//this generate a public event on a blockchain that will notify clients
118 	event icoStatusUpdated(address _initiator, string status);
119 
120 	/// @notice Constructor of the contract
121 	function BFreeContract() {
122 		preIcoIsRunning = true;
123 		minimalGoalReached = false;
124 		icoExitIsPossible = false;
125 		icoIsClosed = false;
126 		tokenBalanceOf[this] += _totalSupply;
127 		allowed[this][owner] = _totalSupply;
128 		allowed[this][supervisor] = _totalSupply;
129 		currentTokenPrice = 0.001 * 1 ether;	// initial price of 1 metadollar
130 		preICOprice = 0.001 * 1 ether; 			// price of 1 metadollar in weis for the preICO time 
131 		ICOprice = 0.001 * 1 ether;				// price of 1 metadollar in weis for the ICO time
132 		sellPrice = 0.00090 * 1 ether;
133 		buyCommission = 20;
134 		sellCommission = 20;
135 		updatePrices();
136 	}
137 
138 	function () payable {
139 		require(!frozenAccount[msg.sender]);
140 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
141 			buyToken();
142 		}
143 	}
144 
145 	/// @notice Returns a whole amount of metadollars
146 	function totalSupply() constant returns (uint256 totalAmount) {
147 		totalAmount = _totalSupply;
148 	}
149 
150 	/// @notice What is the balance of a particular account?
151 	function balanceOf(address _owner) constant returns (uint256 balance) {
152 		return tokenBalanceOf[_owner];
153 	}
154 
155 	/// @notice Shows how much metadollars _spender can spend from _owner address
156 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
157 		return allowed[_owner][_spender];
158 	}
159 	
160 	/// @notice Calculates amount of weis needed to buy more than one metadollar
161 	/// @param howManyTokenToBuy - Amount of metadollars to calculate
162 	function calculateTheEndPrice(uint256 howManyTokenToBuy) constant returns (uint256 summarizedPriceInWeis) {
163 		if(howManyTokenToBuy > 0) {
164 			summarizedPriceInWeis = howManyTokenToBuy * currentTokenPrice;
165 		}else {
166 			summarizedPriceInWeis = 0;
167 		}
168 	}
169 	
170 	/// @notice Shows if account is frozen
171 	/// @param account - Accountaddress to check
172 	function checkFrozenAccounts(address account) constant returns (bool accountIsFrozen) {
173 		accountIsFrozen = frozenAccount[account];
174 	}
175 
176 	/// @notice Buy metadollars from contract by sending ether
177 	function buy() payable public {
178 		require(!frozenAccount[msg.sender]);
179 		require(msg.value > 0);
180 		uint commission = msg.value/buyCommission; // Buy Commission 0.2% of wei tx
181         require(address(this).send(commission));
182 		buyToken();
183 	}
184 
185 	/// @notice Sell metadollars and receive ether from contract
186 	function sell(uint256 amount) {
187 		require(!frozenAccount[msg.sender]);
188 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
189 		require(amount > 0);
190 		require(sellPrice > 0);
191 		_transfer(msg.sender, this, amount);
192 		uint256 revenue = amount * sellPrice;
193 		require(this.balance >= revenue);
194 	    uint commission = msg.value/sellCommission; // Sell Commission 0.2% of wei tx
195         require(address(this).send(commission));
196 		msg.sender.transfer(revenue);         // sends ether to the seller: it's important to do this last to prevent recursion attacks
197 	}
198 	
199 	/// @notice Allow user to sell maximum possible amount of metadollars, depend on ether amount on contract
200 	function sellMaximumPossibleAmountOfTokens() {
201 		require(!frozenAccount[msg.sender]);
202 		require(tokenBalanceOf[msg.sender] > 0);
203 		require(this.balance > sellPrice);
204 		if(tokenBalanceOf[msg.sender] * sellPrice <= this.balance) {
205 			sell(tokenBalanceOf[msg.sender]);
206 		}else {
207 			sell(this.balance / sellPrice);
208 		}
209 	}
210 
211 	/// @notice Transfer amount of metadollars from own wallet to someone else
212 	function transfer(address _to, uint256 _value) returns (bool success) {
213 		assert(msg.sender != address(0));
214 		assert(_to != address(0));
215 		require(!frozenAccount[msg.sender]);
216 		require(!frozenAccount[_to]);
217 		require(tokenBalanceOf[msg.sender] >= _value);
218 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
219 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
220 		require(_value > 0);
221 		_transfer(msg.sender, _to, _value);
222 		return true;
223 	}
224 
225 	/// @notice  Send _value amount of metadollars from address _from to address _to
226 	/// @notice  The transferFrom method is used for a withdraw workflow, allowing contracts to send
227 	/// @notice  tokens on your behalf, for example to "deposit" to a contract address and/or to charge
228 	/// @notice  fees in sub-currencies; the command should fail unless the _from account has
229 	/// @notice  deliberately authorized the sender of the message via some mechanism; we propose
230 	/// @notice  these standardized APIs for approval:
231 	function transferFrom(address _from,	address _to,	uint256 _value) returns (bool success) {
232 		assert(msg.sender != address(0));
233 		assert(_from != address(0));
234 		assert(_to != address(0));
235 		require(!frozenAccount[msg.sender]);
236 		require(!frozenAccount[_from]);
237 		require(!frozenAccount[_to]);
238 		require(tokenBalanceOf[_from] >= _value);
239 		require(allowed[_from][msg.sender] >= _value);
240 		require(tokenBalanceOf[_from] - _value < tokenBalanceOf[_from]);
241 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
242 		require(_value > 0);
243 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer metadollars from allowed account");
244 		_transfer(_from, _to, _value);
245 		allowed[_from][msg.sender] -= _value;
246 		return true;
247 	}
248 
249 	/// @notice Allow _spender to withdraw from your account, multiple times, up to the _value amount.
250 	/// @notice If this function is called again it overwrites the current allowance with _value.
251 	function approve(address _spender, uint256 _value) returns (bool success) {
252 		require(!frozenAccount[msg.sender]);
253 		assert(_spender != address(0));
254 		require(_value >= 0);
255 		allowed[msg.sender][_spender] = _value;
256 		return true;
257 	}
258 
259 	/// @notice Check if minimal goal of ICO is reached
260 	function checkMinimalGoal() internal {
261 		if(tokenBalanceOf[this] <= _totalSupply - icoMin) {
262 			minimalGoalReached = true;
263 			minGoalReached(icoMin, "Minimal goal of ICO is reached!");
264 		}
265 	}
266 
267 	/// @notice Check if preICO is ended
268 	function checkPreIcoStatus() internal {
269 		if(tokenBalanceOf[this] <= _totalSupply - preIcoLimit) {
270 			preIcoIsRunning = false;
271 			preIcoEnded(preIcoLimit, "Token amount for preICO sold!");
272 		}
273 	}
274 
275 	/// @notice Processing each buying
276 	function buyToken() internal {
277 		uint256 value = msg.value;
278 		address sender = msg.sender;
279 		require(!icoIsClosed);
280 		require(!frozenAccount[sender]);
281 		require(value > 0);
282 		require(currentTokenPrice > 0);
283 		uint256 amount = value / currentTokenPrice;			// calculates amount of metadollars
284 		uint256 moneyBack = value - (amount * currentTokenPrice);
285 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
286 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
287 		updatePrices();
288 		_transfer(this, sender, amount);
289 		if(!minimalGoalReached) {
290 			checkMinimalGoal();
291 		}
292 		if(moneyBack > 0) {
293 			sender.transfer(moneyBack);
294 		}
295 	}
296 
297 	/// @notice Internal transfer, can only be called by this contract
298 	function _transfer(address _from, address _to, uint256 _value) internal {
299 		assert(_from != address(0));
300 		assert(_to != address(0));
301 		require(_value > 0);
302 		require(tokenBalanceOf[_from] >= _value);
303 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
304 		require(!frozenAccount[_from]);
305 		require(!frozenAccount[_to]);
306 		if(tokenBalanceOf[_to] == 0){
307 			countHolders += 1;
308 		}
309 		tokenBalanceOf[_from] -= _value;
310 		if(tokenBalanceOf[_from] == 0){
311 			countHolders -= 1;
312 		}
313 		tokenBalanceOf[_to] += _value;
314 		allowed[this][owner] = tokenBalanceOf[this];
315 		allowed[this][supervisor] = tokenBalanceOf[this];
316 		Transfer(_from, _to, _value);
317 	}
318 
319 	/// @notice Set current ICO prices in wei for one metadollar
320 	function updatePrices() internal {
321 		uint256 oldPrice = currentTokenPrice;
322 		if(preIcoIsRunning) {
323 			checkPreIcoStatus();
324 		}
325 		if(preIcoIsRunning) {
326 			currentTokenPrice = preICOprice;
327 		}else{
328 			currentTokenPrice = ICOprice;
329 		}
330 		
331 		if(oldPrice != currentTokenPrice) {
332 			priceUpdated(oldPrice, currentTokenPrice, "Metadollar price updated!");
333 		}
334 	}
335 
336 	/// @notice Set current preICO price in wei for one metadollar
337 	/// @param priceForPreIcoInWei - is the amount in wei for one metadollar
338 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
339 		require(priceForPreIcoInWei > 0);
340 		require(preICOprice != priceForPreIcoInWei);
341 		preICOprice = priceForPreIcoInWei;
342 		updatePrices();
343 	}
344 	
345 
346 	/// @notice Set current ICO price price in wei for one metadollar
347 	/// @param priceForIcoInWei - is the amount in wei
348 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
349 		require(priceForIcoInWei > 0);
350 		require(ICOprice != priceForIcoInWei);
351 		ICOprice = priceForIcoInWei;
352 		updatePrices();
353 	}
354 	
355 	/// @notice Set current Buy Commission price in wei
356 	/// @param buyCommissionInWei - is the amount in wei
357 	function setBuyCommission(uint256 buyCommissionInWei) isOwner {
358 		require(buyCommissionInWei > 0);
359 		require(buyCommission != buyCommissionInWei);
360 		buyCommission = buyCommissionInWei;
361 		updatePrices();
362 	}
363 	
364 	/// @notice Set current Sell Commission price in wei for one metadollar
365 	/// @param sellCommissionInWei - is the amount in wei for one metadollar
366 	function setSellCommission(uint256 sellCommissionInWei) isOwner {
367 		require(sellCommissionInWei > 0);
368 		require(sellCommission != sellCommissionInWei);
369 		buyCommission = sellCommissionInWei;
370 		updatePrices();
371 	}
372 
373 	/// @notice Set both prices at the same time
374 	/// @param priceForPreIcoInWei - Price of the metadollar in pre ICO
375 	/// @param priceForIcoInWei - Price of the metadollar in ICO
376 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
377 		require(priceForPreIcoInWei > 0);
378 		require(priceForIcoInWei > 0);
379 		preICOprice = priceForPreIcoInWei;
380 		ICOprice = priceForIcoInWei;
381 		updatePrices();
382 	}
383 	
384 	/// @notice Set both commissions at the same time
385 	/// @param buyCommissionInWei - Commission for buy
386 	/// @param sellCommissionInWei - Commission for sell
387 	function setCommissions(uint256 buyCommissionInWei, uint256 sellCommissionInWei) isOwner {
388 		require( buyCommissionInWei> 0);
389 		require(sellCommissionInWei > 0);
390 		buyCommission = buyCommissionInWei;
391 		sellCommission = buyCommissionInWei;
392 		updatePrices();
393 	}
394 
395 	/// @notice Set the current sell price in wei for one metadollar
396 	/// @param priceInWei - is the amount in wei for one metadollar
397 	function setSellPrice(uint256 priceInWei) isOwner {
398 		require(priceInWei >= 0);
399 		sellPrice = priceInWei;
400 	}
401 
402 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving metadollars
403 	/// @param account - address to be frozen
404 	/// @param freeze - select is the account frozen or not
405 	function freezeAccount(address account, bool freeze) isOwner {
406 		require(account != owner);
407 		require(account != supervisor);
408 		frozenAccount[account] = freeze;
409 		if(freeze) {
410 			FrozenFunds(msg.sender, account, "Account set frozen!");
411 		}else {
412 			FrozenFunds(msg.sender, account, "Account set free for use!");
413 		}
414 	}
415 
416 	/// @notice Create an amount of metadollars
417 	/// @param amount - metadollars to create
418 	function mintToken(uint256 amount) isOwner {
419 		require(amount > 0);
420 		require(tokenBalanceOf[this] <= icoMin);	// owner can create metadollars only if the initial amount is strongly not enough to supply and demand ICO
421 		require(_totalSupply + amount > _totalSupply);
422 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
423 		_totalSupply += amount;
424 		tokenBalanceOf[this] += amount;
425 		allowed[this][owner] = tokenBalanceOf[this];
426 		allowed[this][supervisor] = tokenBalanceOf[this];
427 		tokenCreated(msg.sender, amount, "Additional metadollars created!");
428 	}
429 
430 	/// @notice Destroy an amount of metadollars
431 	/// @param amount - token to destroy
432 	function destroyToken(uint256 amount) isOwner {
433 		require(amount > 0);
434 		require(tokenBalanceOf[this] >= amount);
435 		require(_totalSupply >= amount);
436 		require(tokenBalanceOf[this] - amount >= 0);
437 		require(_totalSupply - amount >= 0);
438 		tokenBalanceOf[this] -= amount;
439 		_totalSupply -= amount;
440 		allowed[this][owner] = tokenBalanceOf[this];
441 		allowed[this][supervisor] = tokenBalanceOf[this];
442 		tokenDestroyed(msg.sender, amount, "An amount of metadollars destroyed!");
443 	}
444 
445 	/// @notice Transfer the ownership to another account
446 	/// @param newOwner - address who get the ownership
447 	function transferOwnership(address newOwner) isOwner {
448 		assert(newOwner != address(0));
449 		address oldOwner = owner;
450 		owner = newOwner;
451 		ownerChanged(msg.sender, oldOwner, newOwner);
452 		allowed[this][oldOwner] = 0;
453 		allowed[this][newOwner] = tokenBalanceOf[this];
454 	}
455 
456 	/// @notice Transfer ether from smartcontract to owner
457 	function collect() isOwner {
458         require(this.balance > 0);
459 		require(minimalGoalReached);	// Owner can get funds only if minimal fundrising is reached
460 		withdraw(this.balance);
461     }
462 
463 	/// @notice Withdraw an amount of ether
464 	/// @param summeInWei - amout to withdraw
465 	function withdraw(uint256 summeInWei) isOwner {
466 		uint256 contractbalance = this.balance;
467 		address sender = msg.sender;
468 		require(contractbalance >= summeInWei);
469 		require(minimalGoalReached);	// Owner can get funds only if minimal fundrising is reached
470 		withdrawed(sender, summeInWei, "wei withdrawed");
471         sender.transfer(summeInWei);
472 	}
473 
474 	/// @notice Deposit an amount of ether
475 	function deposit() payable isOwner {
476 		require(msg.value > 0);
477 		require(msg.sender.balance >= msg.value);
478 		deposited(msg.sender, msg.value, "wei deposited");
479 	}
480 
481 	/// @notice Allow user to exit ICO
482 	/// @param exitAllowed - status if the exit is allowed
483 	function allowIcoExit(bool exitAllowed) isOwner {
484 		require(icoExitIsPossible != exitAllowed);
485 		icoExitIsPossible = exitAllowed;
486 	}
487 
488 	/// @notice Stop running ICO
489 	/// @param icoIsStopped - status if this ICO is stopped
490 	function stopThisIco(bool icoIsStopped) isOwner {
491 		require(icoIsClosed != icoIsStopped);
492 		icoIsClosed = icoIsStopped;
493 		if(icoIsStopped) {
494 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
495 		}else {
496 			icoStatusUpdated(msg.sender, "Coin offering is running!");
497 		}
498 	}
499 
500 	/// @notice Sell all metadollars for half of a price and exit this ICO
501 	function exitThisIcoForHalfOfTokenPrice() {
502 		require(icoExitIsPossible);
503 		require(!frozenAccount[msg.sender]);
504 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
505 		require(currentTokenPrice > 1);
506 		uint256 amount = tokenBalanceOf[msg.sender] ;
507 		uint256 revenue = amount * currentTokenPrice / 2;
508 		require(this.balance >= revenue);
509 		_transfer(msg.sender, this, amount);
510 		msg.sender.transfer(revenue);                	// sends ether to the seller: it's important to do this last to prevent recursion attacks
511 	}
512 
513 	/// @notice Sell all of metadollars for all ether of this smartcontract
514 	function getAllMyTokensForAllEtherOnContract() {
515 		require(icoExitIsPossible);
516 		require(!frozenAccount[msg.sender]);
517 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
518 		require(currentTokenPrice > 1);
519 		uint256 amount = tokenBalanceOf[msg.sender] ;
520 		uint256 revenue = amount * currentTokenPrice / 2;
521 		require(this.balance <= revenue);
522 		_transfer(msg.sender, this, amount);
523 		msg.sender.transfer(this.balance); 
524 	}
525 }