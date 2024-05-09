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
57 	string public constant symbol = "DOL";
58 	uint public constant decimals = 18;
59 	uint256 public _totalSupply = 1000000000000000000000000000000;
60 	uint256 public icoMin = 1000000000000000000000000000000;					// = 300000; amount is in Tokens, 1.800.000
61 	uint256 public preIcoLimit = 1000000000000000000;			// = 600000; amount is in tokens, 3.600.000
62 	uint256 public countHolders = 0;				// count how many unique holders have tokens
63 	uint256 public amountOfInvestments = 0;	// amount of collected wei
64 	
65 	uint256 preICOprice;									// price of 1 token in weis for the preICO time
66 	uint256 ICOprice;										// price of 1 token in weis for the ICO time
67 	uint256 public currentTokenPrice;				// current token price in weis
68 	uint256 public sellPrice;      // buyback price of one token in weis
69 	uint256 public mtdPreAmount;
70 	uint256 public ethPreAmount;
71 	uint256 public mtdAmount;
72 	uint256 public ethAmount;
73 	
74 	bool public preIcoIsRunning;
75 	bool public minimalGoalReached;
76 	bool public icoIsClosed;
77 	bool icoExitIsPossible;
78 	
79 
80 	//Balances for each account
81 	mapping (address => uint256) public tokenBalanceOf;
82 
83 	// Owner of account approves the transfer of an amount to another account
84 	mapping(address => mapping (address => uint256)) allowed;
85 	
86 	//list with information about frozen accounts
87 	mapping(address => bool) frozenAccount;
88 	
89 	//this generate a public event on a blockchain that will notify clients
90 	event FrozenFunds(address initiator, address account, string status);
91 	
92 	//this generate a public event on a blockchain that will notify clients
93 	event BonusChanged(uint8 bonusOld, uint8 bonusNew);
94 	
95 	//this generate a public event on a blockchain that will notify clients
96 	event minGoalReached(uint256 minIcoAmount, string notice);
97 	
98 	//this generate a public event on a blockchain that will notify clients
99 	event preIcoEnded(uint256 preIcoAmount, string notice);
100 	
101 	//this generate a public event on a blockchain that will notify clients
102 	event priceUpdated(uint256 oldPrice, uint256 newPrice, string notice);
103 	
104 	//this generate a public event on a blockchain that will notify clients
105 	event withdrawed(address _to, uint256 summe, string notice);
106 	
107 	//this generate a public event on a blockchain that will notify clients
108 	event deposited(address _from, uint256 summe, string notice);
109 	
110 	//this generate a public event on a blockchain that will notify clients
111 	event orderToTransfer(address initiator, address _from, address _to, uint256 summe, string notice);
112 	
113 	//this generate a public event on a blockchain that will notify clients
114 	event tokenCreated(address _creator, uint256 summe, string notice);
115 	
116 	//this generate a public event on a blockchain that will notify clients
117 	event tokenDestroyed(address _destroyer, uint256 summe, string notice);
118 	
119 	//this generate a public event on a blockchain that will notify clients
120 	event icoStatusUpdated(address _initiator, string status);
121 
122 	/// @notice Constructor of the contract
123 	function STARTMETADOLLAR() {
124 	    sellPrice = 900000000000000;
125 	    mtdAmount = 1000000000000000000;
126 	    ethAmount = 1000000000000000;
127 	    mtdPreAmount = 1;
128 	    ethPreAmount = 1;
129 		preIcoIsRunning = true;
130 		minimalGoalReached = false;
131 		icoExitIsPossible = false;
132 		icoIsClosed = false;
133 		tokenBalanceOf[this] += _totalSupply;
134 		allowed[this][owner] = _totalSupply;
135 		allowed[this][supervisor] = _totalSupply;
136 		currentTokenPrice = mtdAmount * ethAmount;	// initial price of 1 Token
137 		preICOprice = mtdPreAmount * ethPreAmount; 			// price of 1 token in weis for the preICO time
138 		ICOprice = mtdAmount * ethAmount;				// price of 1 token in weis for the ICO time
139 		sellPrice = 0;
140 		updatePrices();
141 	}
142 
143 	function () payable {
144 		require(!frozenAccount[msg.sender]);
145 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
146 			buyToken();
147 		}
148 	}
149 
150 	/// @notice Returns a whole amount of tokens
151 	function totalSupply() constant returns (uint256 totalAmount) {
152 		totalAmount = _totalSupply;
153 	}
154 
155 	/// @notice What is the balance of a particular account?
156 	function balanceOf(address _owner) constant returns (uint256 balance) {
157 		return tokenBalanceOf[_owner];
158 	}
159 
160 	/// @notice Shows how much tokens _spender can spend from _owner address
161 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
162 		return allowed[_owner][_spender];
163 	}
164 	
165 	/// @notice Calculates amount of weis needed to buy more than one token
166 	/// @param howManyTokenToBuy - Amount of tokens to calculate
167 	function calculateTheEndPrice(uint256 howManyTokenToBuy) constant returns (uint256 summarizedPriceInWeis) {
168 		if(howManyTokenToBuy > 0) {
169 			summarizedPriceInWeis = howManyTokenToBuy * currentTokenPrice;
170 		}else {
171 			summarizedPriceInWeis = 0;
172 		}
173 	}
174 	
175 	/// @notice Shows if account is frozen
176 	/// @param account - Accountaddress to check
177 	function checkFrozenAccounts(address account) constant returns (bool accountIsFrozen) {
178 		accountIsFrozen = frozenAccount[account];
179 	}
180 
181 	/// @notice Buy tokens from contract by sending ether
182 	function buy() payable public {
183 		require(!frozenAccount[msg.sender]);
184 		require(msg.value > 0);
185 		buyToken();
186 	}
187 
188 	/// @notice Sell tokens and receive ether from contract
189 	function sell(uint256 amount) {
190 		require(!frozenAccount[msg.sender]);
191 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
192 		require(amount > 0);
193 		require(sellPrice > 0);
194 		_transfer(msg.sender, this, amount);
195 		uint256 revenue = amount * sellPrice;
196 		require(this.balance >= revenue);
197 		msg.sender.transfer(revenue);                		// sends ether to the seller: it's important to do this last to prevent recursion attacks
198 	}
199 	
200 	/// @notice Allow user to sell maximum possible amount of tokens, depend on ether amount on contract
201 	function sellMaximumPossibleAmountOfTokens() {
202 		require(!frozenAccount[msg.sender]);
203 		require(tokenBalanceOf[msg.sender] > 0);
204 		require(this.balance > sellPrice);
205 		if(tokenBalanceOf[msg.sender] * sellPrice <= this.balance) {
206 			sell(tokenBalanceOf[msg.sender]);
207 		}else {
208 			sell(this.balance / sellPrice);
209 		}
210 	}
211 
212 	/// @notice Transfer amount of tokens from own wallet to someone else
213 	function transfer(address _to, uint256 _value) returns (bool success) {
214 		assert(msg.sender != address(0));
215 		assert(_to != address(0));
216 		require(!frozenAccount[msg.sender]);
217 		require(!frozenAccount[_to]);
218 		require(tokenBalanceOf[msg.sender] >= _value);
219 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
220 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
221 		require(_value > 0);
222 		_transfer(msg.sender, _to, _value);
223 		return true;
224 	}
225 
226 	/// @notice  Send _value amount of tokens from address _from to address _to
227 	/// @notice  The transferFrom method is used for a withdraw workflow, allowing contracts to send
228 	/// @notice  tokens on your behalf, for example to "deposit" to a contract address and/or to charge
229 	/// @notice  fees in sub-currencies; the command should fail unless the _from account has
230 	/// @notice  deliberately authorized the sender of the message via some mechanism; we propose
231 	/// @notice  these standardized APIs for approval:
232 	function transferFrom(address _from,	address _to,	uint256 _value) returns (bool success) {
233 		assert(msg.sender != address(0));
234 		assert(_from != address(0));
235 		assert(_to != address(0));
236 		require(!frozenAccount[msg.sender]);
237 		require(!frozenAccount[_from]);
238 		require(!frozenAccount[_to]);
239 		require(tokenBalanceOf[_from] >= _value);
240 		require(allowed[_from][msg.sender] >= _value);
241 		require(tokenBalanceOf[_from] - _value < tokenBalanceOf[_from]);
242 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
243 		require(_value > 0);
244 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer tokens from allowed account");
245 		_transfer(_from, _to, _value);
246 		allowed[_from][msg.sender] -= _value;
247 		return true;
248 	}
249 
250 	/// @notice Allow _spender to withdraw from your account, multiple times, up to the _value amount.
251 	/// @notice If this function is called again it overwrites the current allowance with _value.
252 	function approve(address _spender, uint256 _value) returns (bool success) {
253 		require(!frozenAccount[msg.sender]);
254 		assert(_spender != address(0));
255 		require(_value >= 0);
256 		allowed[msg.sender][_spender] = _value;
257 		return true;
258 	}
259 
260 	/// @notice Check if minimal goal of ICO is reached
261 	function checkMinimalGoal() internal {
262 		if(tokenBalanceOf[this] <= _totalSupply - icoMin) {
263 			minimalGoalReached = true;
264 			minGoalReached(icoMin, "Minimal goal of ICO is reached!");
265 		}
266 	}
267 
268 	/// @notice Check if preICO is ended
269 	function checkPreIcoStatus() internal {
270 		if(tokenBalanceOf[this] <= _totalSupply - preIcoLimit) {
271 			preIcoIsRunning = false;
272 			preIcoEnded(preIcoLimit, "Token amount for preICO sold!");
273 		}
274 	}
275 
276 	/// @notice Processing each buying
277 	function buyToken() internal {
278 		uint256 value = msg.value;
279 		address sender = msg.sender;
280 		require(!icoIsClosed);
281 		require(!frozenAccount[sender]);
282 		require(value > 0);
283 		require(currentTokenPrice > 0);
284 		uint256 amount = value / currentTokenPrice;			// calculates amount of tokens
285 		uint256 moneyBack = value - (amount * currentTokenPrice);
286 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
287 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
288 		updatePrices();
289 		_transfer(this, sender, amount);
290 		if(!minimalGoalReached) {
291 			checkMinimalGoal();
292 		}
293 		if(moneyBack > 0) {
294 			sender.transfer(moneyBack);
295 		}
296 	}
297 
298 	/// @notice Internal transfer, can only be called by this contract
299 	function _transfer(address _from, address _to, uint256 _value) internal {
300 		assert(_from != address(0));
301 		assert(_to != address(0));
302 		require(_value > 0);
303 		require(tokenBalanceOf[_from] >= _value);
304 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
305 		require(!frozenAccount[_from]);
306 		require(!frozenAccount[_to]);
307 		if(tokenBalanceOf[_to] == 0){
308 			countHolders += 1;
309 		}
310 		tokenBalanceOf[_from] -= _value;
311 		if(tokenBalanceOf[_from] == 0){
312 			countHolders -= 1;
313 		}
314 		tokenBalanceOf[_to] += _value;
315 		allowed[this][owner] = tokenBalanceOf[this];
316 		allowed[this][supervisor] = tokenBalanceOf[this];
317 		Transfer(_from, _to, _value);
318 	}
319 
320 	/// @notice Set current ICO prices in wei for one token
321 	function updatePrices() internal {
322 		uint256 oldPrice = currentTokenPrice;
323 		if(preIcoIsRunning) {
324 			checkPreIcoStatus();
325 		}
326 		if(preIcoIsRunning) {
327 			currentTokenPrice = preICOprice;
328 		}else{
329 			currentTokenPrice = ICOprice;
330 		}
331 		
332 		if(oldPrice != currentTokenPrice) {
333 			priceUpdated(oldPrice, currentTokenPrice, "Token price updated!");
334 		}
335 	}
336 
337 	/// @notice Set current preICO price in wei for one token
338 	/// @param priceForPreIcoInWei - is the amount in wei for one token
339 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
340 		require(priceForPreIcoInWei > 0);
341 		require(preICOprice != priceForPreIcoInWei);
342 		preICOprice = priceForPreIcoInWei;
343 		updatePrices();
344 	}
345 
346 	/// @notice Set current ICO price in wei for one token
347 	/// @param priceForIcoInWei - is the amount in wei for one token
348 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
349 		require(priceForIcoInWei > 0);
350 		require(ICOprice != priceForIcoInWei);
351 		ICOprice = priceForIcoInWei;
352 		updatePrices();
353 	}
354 
355 	/// @notice Set both prices at the same time
356 	/// @param priceForPreIcoInWei - Price of the token in pre ICO
357 	/// @param priceForIcoInWei - Price of the token in ICO
358 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
359 		require(priceForPreIcoInWei > 0);
360 		require(priceForIcoInWei > 0);
361 		preICOprice = priceForPreIcoInWei;
362 		ICOprice = priceForIcoInWei;
363 		updatePrices();
364 	}
365 	
366 	/// @notice Set current mtdAmount price in wei for one token
367 	/// @param mtdAmountInWei - is the amount in wei for one token
368 	function setMtdAmount(uint256 mtdAmountInWei) isOwner {
369 		require(mtdAmountInWei > 0);
370 		require(mtdAmount != mtdAmountInWei);
371 		mtdAmount = mtdAmountInWei;
372 		updatePrices();
373 	}
374 
375 	/// @notice Set current ethAmount price in wei for one token
376 	/// @param ethAmountInWei - is the amount in wei for one token
377 	function setEthAmount(uint256 ethAmountInWei) isOwner {
378 		require(ethAmountInWei > 0);
379 		require(ethAmount != ethAmountInWei);
380 		ethAmount = ethAmountInWei;
381 		updatePrices();
382 	}
383 
384 	/// @notice Set both ethAmount and mtdAmount at the same time
385 	/// @param mtdAmountInWei - is the amount in wei for one token
386 	/// @param ethAmountInWei - is the amount in wei for one token
387 	function setAmounts(uint256 mtdAmountInWei, uint256 ethAmountInWei) isOwner {
388 		require(mtdAmountInWei > 0);
389 		require(ethAmountInWei > 0);
390 		mtdAmount = mtdAmountInWei;
391 		ethAmount = ethAmountInWei;
392 		updatePrices();
393 	}
394 
395 	/// @notice Set the current sell price in wei for one token
396 	/// @param priceInWei - is the amount in wei for one token
397 	function setSellPrice(uint256 priceInWei) isOwner {
398 		require(priceInWei >= 0);
399 		sellPrice = priceInWei;
400 	}
401 
402 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving tokens
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
416 	/// @notice Create an amount of token
417 	/// @param amount - token to create
418 	function mintToken(uint256 amount) isOwner {
419 		require(amount > 0);
420 		require(tokenBalanceOf[this] <= icoMin);	// owner can create token only if the initial amount is strongly not enough to supply and demand ICO
421 		require(_totalSupply + amount > _totalSupply);
422 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
423 		_totalSupply += amount;
424 		tokenBalanceOf[this] += amount;
425 		allowed[this][owner] = tokenBalanceOf[this];
426 		allowed[this][supervisor] = tokenBalanceOf[this];
427 		tokenCreated(msg.sender, amount, "Additional tokens created!");
428 	}
429 
430 	/// @notice Destroy an amount of token
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
442 		tokenDestroyed(msg.sender, amount, "An amount of tokens destroyed!");
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
459 		withdraw(this.balance);
460     }
461 
462 	/// @notice Withdraw an amount of ether
463 	/// @param summeInWei - amout to withdraw
464 	function withdraw(uint256 summeInWei) isOwner {
465 		uint256 contractbalance = this.balance;
466 		address sender = msg.sender;
467 		require(contractbalance >= summeInWei);
468 		withdrawed(sender, summeInWei, "wei withdrawed");
469         sender.transfer(summeInWei);
470 	}
471 
472 	/// @notice Deposit an amount of ether
473 	function deposit() payable isOwner {
474 		require(msg.value > 0);
475 		require(msg.sender.balance >= msg.value);
476 		deposited(msg.sender, msg.value, "wei deposited");
477 	}
478 
479 	/// @notice Allow user to exit ICO
480 	/// @param exitAllowed - status if the exit is allowed
481 	function allowIcoExit(bool exitAllowed) isOwner {
482 		require(icoExitIsPossible != exitAllowed);
483 		icoExitIsPossible = exitAllowed;
484 	}
485 
486 	/// @notice Stop running ICO
487 	/// @param icoIsStopped - status if this ICO is stopped
488 	function stopThisIco(bool icoIsStopped) isOwner {
489 		require(icoIsClosed != icoIsStopped);
490 		icoIsClosed = icoIsStopped;
491 		if(icoIsStopped) {
492 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
493 		}else {
494 			icoStatusUpdated(msg.sender, "Coin offering is running!");
495 		}
496 	}
497 
498 	/// @notice Sell all tokens for half of a price and exit this ICO
499 	function exitThisIcoForHalfOfTokenPrice() {
500 		require(icoExitIsPossible);
501 		require(!frozenAccount[msg.sender]);
502 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
503 		require(currentTokenPrice > 1);
504 		uint256 amount = tokenBalanceOf[msg.sender] ;
505 		uint256 revenue = amount * currentTokenPrice / 2;
506 		require(this.balance >= revenue);
507 		_transfer(msg.sender, this, amount);
508 		msg.sender.transfer(revenue);                	// sends ether to the seller: it's important to do this last to prevent recursion attacks
509 	}
510 
511 	/// @notice Sell all of tokens for all ether of this smartcontract
512 	function getAllMyTokensForAllEtherOnContract() {
513 		require(icoExitIsPossible);
514 		require(!frozenAccount[msg.sender]);
515 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
516 		require(currentTokenPrice > 1);
517 		uint256 amount = tokenBalanceOf[msg.sender] ;
518 		uint256 revenue = amount * currentTokenPrice / 2;
519 		require(this.balance <= revenue);
520 		_transfer(msg.sender, this, amount);
521 		msg.sender.transfer(this.balance); 
522 	}
523 }