1 pragma solidity ^0.4.16;
2 
3  // ERC Token Standard #20 Interface
4  // https://github.com/ethereum/EIPs/issues/20
5 
6  contract ERC20Interface {
7 	/// @notice Get the total token supply
8 	function totalSupply() constant returns (uint256 totalAmount);
9 
10 	/// @notice  Get the account balance of another account with address _owner
11 	function balanceOf(address _owner) constant returns (uint256 balance);
12 
13 	/// @notice  Send _value amount of tokens to address _to
14 	function transfer(address _to, uint256 _value) returns (bool success);
15 
16 	/// @notice  Send _value amount of tokens from address _from to address _to
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
27 	/// @notice  Triggered when tokens are transferred.
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
54 contract METADOLLAR is ERC20Interface, owned{
55 
56 	string public constant name = "METADOLLAR";
57 	string public constant symbol = "MDL";
58 	uint public constant decimals = 18;
59 	uint256 public _totalSupply = 1000000000000000000;
60 	uint256 public icoMin = 1;					
61 	uint256 public preIcoLimit = 1;			
62 	uint256 public countHolders = 0;				// count how many unique holders have tokens
63 	uint256 public amountOfInvestments = 0;	// amount of collected wei
64 	
65 	uint256 preICOprice;									// price of 1 token in weis for the preICO time
66 	uint256 ICOprice;										// price of 1 token in weis for the ICO time
67 	uint256 public currentTokenPrice;				// current token price in weis
68 	uint256 public sellPrice;								// buyback price of one token in weis
69 	uint256 public buyCommission;								// Commission on buy
70 	uint256 public sellCommission;								// Commission on sell
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
121 	function STARTMETADOLLAR() {
122 		preIcoIsRunning = true;
123 		minimalGoalReached = false;
124 		icoExitIsPossible = false;
125 		icoIsClosed = false;
126 		tokenBalanceOf[this] += _totalSupply;
127 		allowed[this][owner] = _totalSupply;
128 		allowed[this][supervisor] = _totalSupply;
129 		currentTokenPrice = 1000000000000000000 * 1000000000000000000 ether;	// initial price of 1 Token
130 		preICOprice = 1000000000000000000 * 1000000000000000000 ether; 			// price of 1 token in weis for the preICO time, ca.6,- Euro
131 		ICOprice = 1000000000000000000 *  1000000000000000000 ether;				// price of 1 token in weis for the ICO time, ca.10,- Euro
132 		sellPrice = 900000000000000000;
133 		buyCommission = 0;
134 		sellCommission = 0;
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
145 	/// @notice Returns a whole amount of tokens
146 	function totalSupply() constant returns (uint256 totalAmount) {
147 		totalAmount = _totalSupply;
148 	}
149 
150 	/// @notice What is the balance of a particular account?
151 	function balanceOf(address _owner) constant returns (uint256 balance) {
152 		return tokenBalanceOf[_owner];
153 	}
154 
155 	/// @notice Shows how much tokens _spender can spend from _owner address
156 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
157 		return allowed[_owner][_spender];
158 	}
159 	
160 	/// @notice Calculates amount of weis needed to buy more than one token
161 	/// @param howManyTokenToBuy - Amount of tokens to calculate
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
176 	/// @notice Buy tokens from contract by sending ether
177 	function buy() payable public {
178 		require(!frozenAccount[msg.sender]);
179 		require(msg.value > 0);
180 		buyCommission = msg.value/1000; // Buy Commission x1000 of wei tx
181         require(address(this).send(buyCommission));
182 		buyToken();
183 	}
184 
185 	/// @notice Sell tokens and receive ether from contract
186 	function sell(uint256 amount) {
187 		require(!frozenAccount[msg.sender]);
188 		require(tokenBalanceOf[msg.sender] >= amount); //checks if the sender has enough to sell
189 		require(amount > 0);
190 		require(sellPrice > 0);
191 		sellCommission = msg.value/1000; // Sell Commission x1000 of wei tx
192         require(address(this).send(buyCommission));
193 		_transfer(msg.sender, this, amount);
194 		uint256 revenue = amount * sellPrice;
195 		require(this.balance >= revenue);
196 		msg.sender.transfer(revenue);                		// sends ether to the seller: it's important to do this last to prevent recursion attacks
197 	}
198 	
199 
200 
201 	/// @notice Transfer amount of tokens from own wallet to someone else
202 	function transfer(address _to, uint256 _value) returns (bool success) {
203 		assert(msg.sender != address(0));
204 		assert(_to != address(0));
205 		require(!frozenAccount[msg.sender]);
206 		require(!frozenAccount[_to]);
207 		require(tokenBalanceOf[msg.sender] >= _value);
208 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
209 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
210 		require(_value > 0);
211 		_transfer(msg.sender, _to, _value);
212 		return true;
213 	}
214 
215 	/// @notice  Send _value amount of tokens from address _from to address _to
216 	/// @notice  The transferFrom method is used for a withdraw workflow, allowing contracts to send
217 	/// @notice  tokens on your behalf, for example to "deposit" to a contract address and/or to charge
218 	/// @notice  fees in sub-currencies; the command should fail unless the _from account has
219 	/// @notice  deliberately authorized the sender of the message via some mechanism; we propose
220 	/// @notice  these standardized APIs for approval:
221 	function transferFrom(address _from,	address _to,	uint256 _value) returns (bool success) {
222 		assert(msg.sender != address(0));
223 		assert(_from != address(0));
224 		assert(_to != address(0));
225 		require(!frozenAccount[msg.sender]);
226 		require(!frozenAccount[_from]);
227 		require(!frozenAccount[_to]);
228 		require(tokenBalanceOf[_from] >= _value);
229 		require(allowed[_from][msg.sender] >= _value);
230 		require(tokenBalanceOf[_from] - _value < tokenBalanceOf[_from]);
231 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
232 		require(_value > 0);
233 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer tokens from allowed account");
234 		_transfer(_from, _to, _value);
235 		allowed[_from][msg.sender] -= _value;
236 		return true;
237 	}
238 
239 	/// @notice Allow _spender to withdraw from your account, multiple times, up to the _value amount.
240 	/// @notice If this function is called again it overwrites the current allowance with _value.
241 	function approve(address _spender, uint256 _value) returns (bool success) {
242 		require(!frozenAccount[msg.sender]);
243 		assert(_spender != address(0));
244 		require(_value >= 0);
245 		allowed[msg.sender][_spender] = _value;
246 		return true;
247 	}
248 
249 	/// @notice Check if minimal goal of ICO is reached
250 	function checkMinimalGoal() internal {
251 		if(tokenBalanceOf[this] <= _totalSupply - icoMin) {
252 			minimalGoalReached = true;
253 			minGoalReached(icoMin, "Minimal goal of ICO is reached!");
254 		}
255 	}
256 
257 	/// @notice Check if preICO is ended
258 	function checkPreIcoStatus() internal {
259 		if(tokenBalanceOf[this] <= _totalSupply - preIcoLimit) {
260 			preIcoIsRunning = false;
261 			preIcoEnded(preIcoLimit, "Token amount for preICO sold!");
262 		}
263 	}
264 
265 	/// @notice Processing each buying
266 	function buyToken() internal {
267 		uint256 value = msg.value;
268 		address sender = msg.sender;
269 		require(!icoIsClosed);
270 		require(!frozenAccount[sender]);
271 		require(value > 0);
272 		require(currentTokenPrice > 0);
273 		uint256 amount = value / currentTokenPrice;			// calculates amount of tokens
274 		uint256 moneyBack = value - (amount * currentTokenPrice);
275 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
276 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
277 		updatePrices();
278 		_transfer(this, sender, amount);
279 		if(!minimalGoalReached) {
280 			checkMinimalGoal();
281 		}
282 		if(moneyBack > 0) {
283 			sender.transfer(moneyBack);
284 		}
285 	}
286 
287 	/// @notice Internal transfer, can only be called by this contract
288 	function _transfer(address _from, address _to, uint256 _value) internal {
289 		assert(_from != address(0));
290 		assert(_to != address(0));
291 		require(_value > 0);
292 		require(tokenBalanceOf[_from] >= _value);
293 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
294 		require(!frozenAccount[_from]);
295 		require(!frozenAccount[_to]);
296 		if(tokenBalanceOf[_to] == 0){
297 			countHolders += 1;
298 		}
299 		tokenBalanceOf[_from] -= _value;
300 		if(tokenBalanceOf[_from] == 0){
301 			countHolders -= 1;
302 		}
303 		tokenBalanceOf[_to] += _value;
304 		allowed[this][owner] = tokenBalanceOf[this];
305 		allowed[this][supervisor] = tokenBalanceOf[this];
306 		Transfer(_from, _to, _value);
307 	}
308 
309 	/// @notice Set current ICO prices in wei for one token
310 	function updatePrices() internal {
311 		uint256 oldPrice = currentTokenPrice;
312 		if(preIcoIsRunning) {
313 			checkPreIcoStatus();
314 		}
315 		if(preIcoIsRunning) {
316 			currentTokenPrice = preICOprice;
317 		}else{
318 			currentTokenPrice = ICOprice;
319 		}
320 		
321 		if(oldPrice != currentTokenPrice) {
322 			priceUpdated(oldPrice, currentTokenPrice, "Token price updated!");
323 		}
324 	}
325 
326 	/// @notice Set current preICO price in wei for one token
327 	/// @param priceForPreIcoInWei - is the amount in wei for one token
328 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
329 		require(priceForPreIcoInWei > 0);
330 		require(preICOprice != priceForPreIcoInWei);
331 		preICOprice = priceForPreIcoInWei;
332 		updatePrices();
333 	}
334 
335 	/// @notice Set current ICO price in wei for one token
336 	/// @param priceForIcoInWei - is the amount in wei for one token
337 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
338 		require(priceForIcoInWei > 0);
339 		require(ICOprice != priceForIcoInWei);
340 		ICOprice = priceForIcoInWei;
341 		updatePrices();
342 	}
343 
344 	/// @notice Set both prices at the same time
345 	/// @param priceForPreIcoInWei - Price of the token in pre ICO
346 	/// @param priceForIcoInWei - Price of the token in ICO
347 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
348 		require(priceForPreIcoInWei > 0);
349 		require(priceForIcoInWei > 0);
350 		preICOprice = priceForPreIcoInWei;
351 		ICOprice = priceForIcoInWei;
352 		updatePrices();
353 	}
354 	
355 	/// @notice Set both ico min at the same time
356 	/// @param newPreIcoLimit - PreIco Limit
357 	/// @param newIcoMin - Ico Min
358 	function setIcosMinLimit(uint256 newIcoMin, uint256 newPreIcoLimit) isOwner {
359 		require(newIcoMin > 0);
360 		require(newPreIcoLimit > 0);
361 		icoMin = newIcoMin;
362 		preIcoLimit = newPreIcoLimit;
363 		updatePrices();
364 	}
365 
366 	/// @notice Set the current sell price in wei for one token
367 	/// @param priceInWei - is the amount in wei for one token
368 	function setSellPrice(uint256 priceInWei) isOwner {
369 		require(priceInWei >= 0);
370 		sellPrice = priceInWei;
371 	}
372 	
373 	/// @notice Set current Buy Commission price in wei
374 	/// @param buyCommissionInWei - is the amount in wei
375 	function setBuyCommission(uint256 buyCommissionInWei) isOwner {
376 		require(buyCommissionInWei > 0);
377 		require(buyCommission != buyCommissionInWei);
378 		buyCommission = buyCommissionInWei;
379 		updatePrices();
380 	}
381 	
382 	/// @notice Set current Sell Commission price in wei for one metadollar
383 	/// @param sellCommissionInWei - is the amount in wei for one metadollar
384 	function setSellCommission(uint256 sellCommissionInWei) isOwner {
385 		require(sellCommissionInWei > 0);
386 		require(sellCommission != sellCommissionInWei);
387 		buyCommission = sellCommissionInWei;
388 		updatePrices();
389 	}
390 
391 	
392 	
393 	/// @notice Set both commissions at the same time
394 	/// @param buyCommissionInWei - Commission for buy
395 	/// @param sellCommissionInWei - Commission for sell
396 	function setCommissions(uint256 buyCommissionInWei, uint256 sellCommissionInWei) isOwner {
397 		require( buyCommissionInWei> 0);
398 		require(sellCommissionInWei > 0);
399 		buyCommission = buyCommissionInWei;
400 		sellCommission = buyCommissionInWei;
401 		updatePrices();
402 	}
403 
404 
405 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving tokens
406 	/// @param account - address to be frozen
407 	/// @param freeze - select is the account frozen or not
408 	function freezeAccount(address account, bool freeze) isOwner {
409 		require(account != owner);
410 		require(account != supervisor);
411 		frozenAccount[account] = freeze;
412 		if(freeze) {
413 			FrozenFunds(msg.sender, account, "Account set frozen!");
414 		}else {
415 			FrozenFunds(msg.sender, account, "Account set free for use!");
416 		}
417 	}
418 
419 	/// @notice Create an amount of token
420 	/// @param amount - token to create
421 	function mintToken(uint256 amount) isOwner {
422 		require(amount > 0);
423 		require(tokenBalanceOf[this] <= icoMin);	// owner can create token only if the initial amount is strongly not enough to supply and demand ICO
424 		require(_totalSupply + amount > _totalSupply);
425 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
426 		_totalSupply += amount;
427 		tokenBalanceOf[this] += amount;
428 		allowed[this][owner] = tokenBalanceOf[this];
429 		allowed[this][supervisor] = tokenBalanceOf[this];
430 		tokenCreated(msg.sender, amount, "Additional tokens created!");
431 	}
432 
433 	/// @notice Destroy an amount of token
434 	/// @param amount - token to destroy
435 	function destroyToken(uint256 amount) isOwner {
436 		require(amount > 0);
437 		require(tokenBalanceOf[this] >= amount);
438 		require(_totalSupply >= amount);
439 		require(tokenBalanceOf[this] - amount >= 0);
440 		require(_totalSupply - amount >= 0);
441 		tokenBalanceOf[this] -= amount;
442 		_totalSupply -= amount;
443 		allowed[this][owner] = tokenBalanceOf[this];
444 		allowed[this][supervisor] = tokenBalanceOf[this];
445 		tokenDestroyed(msg.sender, amount, "An amount of tokens destroyed!");
446 	}
447 
448 	/// @notice Transfer the ownership to another account
449 	/// @param newOwner - address who get the ownership
450 	function transferOwnership(address newOwner) isOwner {
451 		assert(newOwner != address(0));
452 		address oldOwner = owner;
453 		owner = newOwner;
454 		ownerChanged(msg.sender, oldOwner, newOwner);
455 		allowed[this][oldOwner] = 0;
456 		allowed[this][newOwner] = tokenBalanceOf[this];
457 	}
458 
459 	/// @notice Transfer all ether from smartcontract to owner
460 	function collect() isOwner {
461         require(this.balance > 0);
462 		withdraw(this.balance);
463     }
464 
465 	/// @notice Withdraw an amount of ether
466 	/// @param summeInWei - amout to withdraw
467 	function withdraw(uint256 summeInWei) isOwner {
468 		uint256 contractbalance = this.balance;
469 		address sender = msg.sender;
470 		require(contractbalance >= summeInWei);
471 		withdrawed(sender, summeInWei, "wei withdrawed");
472         sender.transfer(summeInWei);
473 	}
474 
475 	/// @notice Deposit an amount of ether
476 	function deposit() payable isOwner {
477 		require(msg.value > 0);
478 		require(msg.sender.balance >= msg.value);
479 		deposited(msg.sender, msg.value, "wei deposited");
480 	}
481 
482 	/// @notice Allow user to exit ICO
483 	/// @param exitAllowed - status if the exit is allowed
484 	function allowIcoExit(bool exitAllowed) isOwner {
485 		require(icoExitIsPossible != exitAllowed);
486 		icoExitIsPossible = exitAllowed;
487 	}
488 
489 	/// @notice Stop running ICO
490 	/// @param icoIsStopped - status if this ICO is stopped
491 	function stopThisIco(bool icoIsStopped) isOwner {
492 		require(icoIsClosed != icoIsStopped);
493 		icoIsClosed = icoIsStopped;
494 		if(icoIsStopped) {
495 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
496 		}else {
497 			icoStatusUpdated(msg.sender, "Coin offering is running!");
498 		}
499 	}
500 
501 	/// @notice Sell all tokens for half of a price and exit this ICO
502 	function exitThisIcoForHalfOfTokenPrice() {
503 		require(icoExitIsPossible);
504 		require(!frozenAccount[msg.sender]);
505 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
506 		require(currentTokenPrice > 1);
507 		uint256 amount = tokenBalanceOf[msg.sender] ;
508 		uint256 revenue = amount * currentTokenPrice / 2;
509 		require(this.balance >= revenue);
510 		_transfer(msg.sender, this, amount);
511 		msg.sender.transfer(revenue);                	// sends ether to the seller: it's important to do this last to prevent recursion attacks
512 	}
513 
514 	/// @notice Sell all of tokens for all ether of this smartcontract
515 	function getAllMyTokensForAllEtherOnContract() {
516 		require(icoExitIsPossible);
517 		require(!frozenAccount[msg.sender]);
518 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
519 		require(currentTokenPrice > 1);
520 		uint256 amount = tokenBalanceOf[msg.sender] ;
521 		uint256 revenue = amount * currentTokenPrice / 2;
522 		require(this.balance <= revenue);
523 		_transfer(msg.sender, this, amount);
524 		msg.sender.transfer(this.balance); 
525 	}
526 }