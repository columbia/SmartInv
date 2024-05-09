1 pragma solidity ^0.4.18;
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
60 	uint256 public icoMin = 1000000000000000;					
61 	uint256 public preIcoLimit = 1000000000000000000;			
62 	uint256 public countHolders = 0;				// count how many unique holders have tokens
63 	uint256 public amountOfInvestments = 0;	// amount of collected wei
64 	
65 	uint256 preICOprice;								
66 	uint256 ICOprice;										
67 	uint256 public currentTokenPrice;				
68 	uint256 public sellPrice;      
69 	uint256 public mtdPreAmount;
70 	uint256 public ethPreAmount;
71 	uint256 public mtdAmount;
72 	uint256 public ethAmount;
73 	
74 	bool public preIcoIsRunning;
75 	bool public minimalGoalReached;
76 	bool public icoIsClosed;
77 	
78 
79 	//Balances for each account
80 	mapping (address => uint256) public tokenBalanceOf;
81 
82 	// Owner of account approves the transfer of an amount to another account
83 	mapping(address => mapping (address => uint256)) allowed;
84 	
85 	//list with information about frozen accounts
86 	mapping(address => bool) frozenAccount;
87 	
88 	//this generate a public event on a blockchain that will notify clients
89 	event FrozenFunds(address initiator, address account, string status);
90 	
91 	//this generate a public event on a blockchain that will notify clients
92 	event BonusChanged(uint8 bonusOld, uint8 bonusNew);
93 	
94 	//this generate a public event on a blockchain that will notify clients
95 	event minGoalReached(uint256 minIcoAmount, string notice);
96 	
97 	//this generate a public event on a blockchain that will notify clients
98 	event preIcoEnded(uint256 preIcoAmount, string notice);
99 	
100 	//this generate a public event on a blockchain that will notify clients
101 	event priceUpdated(uint256 oldPrice, uint256 newPrice, string notice);
102 	
103 	//this generate a public event on a blockchain that will notify clients
104 	event withdrawed(address _to, uint256 summe, string notice);
105 	
106 	//this generate a public event on a blockchain that will notify clients
107 	event deposited(address _from, uint256 summe, string notice);
108 	
109 	//this generate a public event on a blockchain that will notify clients
110 	event orderToTransfer(address initiator, address _from, address _to, uint256 summe, string notice);
111 	
112 	//this generate a public event on a blockchain that will notify clients
113 	event tokenCreated(address _creator, uint256 summe, string notice);
114 	
115 	//this generate a public event on a blockchain that will notify clients
116 	event tokenDestroyed(address _destroyer, uint256 summe, string notice);
117 	
118 	//this generate a public event on a blockchain that will notify clients
119 	event icoStatusUpdated(address _initiator, string status);
120 
121 	/// @notice Constructor of the contract
122 	function STARTMETADOLLAR() {
123 	    mtdAmount = 1000000000000000000;
124 	    ethAmount = 1000000000000000;
125 	    mtdPreAmount = 1000000000000000000;
126 	    ethPreAmount = 1000000000000000;
127 		preIcoIsRunning = true;
128 		minimalGoalReached = false;
129 		icoIsClosed = false;
130 		tokenBalanceOf[this] += _totalSupply;
131 		allowed[this][owner] = _totalSupply;
132 		allowed[this][supervisor] = _totalSupply;
133 		currentTokenPrice = mtdAmount * ethAmount;	// initial price of 1 Token
134 		preICOprice = mtdPreAmount * ethPreAmount; 			
135 		ICOprice = mtdAmount * ethAmount;			
136 		sellPrice = 900000000000000;
137 		updatePrices();
138 	}
139 
140 	function () payable {
141 		require(!frozenAccount[msg.sender]);
142 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
143 			buyToken();
144 		}
145 	}
146 
147 	/// @notice Returns a whole amount of tokens
148 	function totalSupply() constant returns (uint256 totalAmount) {
149 		totalAmount = _totalSupply;
150 	}
151 
152 	/// @notice What is the balance of a particular account?
153 	function balanceOf(address _owner) constant returns (uint256 balance) {
154 		return tokenBalanceOf[_owner];
155 	}
156 
157 	/// @notice Shows how much tokens _spender can spend from _owner address
158 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
159 		return allowed[_owner][_spender];
160 	}
161 	
162 	/// @notice Calculates amount of weis needed to buy more than one token
163 	/// @param howManyTokenToBuy - Amount of tokens to calculate
164 	function calculateTheEndPrice(uint256 howManyTokenToBuy) constant returns (uint256 summarizedPriceInWeis) {
165 		if(howManyTokenToBuy > 0) {
166 			summarizedPriceInWeis = howManyTokenToBuy * currentTokenPrice;
167 		}else {
168 			summarizedPriceInWeis = 0;
169 		}
170 	}
171 	
172 	/// @notice Shows if account is frozen
173 	/// @param account - Accountaddress to check
174 	function checkFrozenAccounts(address account) constant returns (bool accountIsFrozen) {
175 		accountIsFrozen = frozenAccount[account];
176 	}
177 
178 	/// @notice Buy tokens from contract by sending ether
179 	function buy() payable public {
180 		require(!frozenAccount[msg.sender]);
181 		require(msg.value > 0);
182 		buyToken();
183 	}
184 
185 	/// @notice Sell tokens and receive ether from contract
186 	function sell(uint256 amount) {
187 		require(!frozenAccount[msg.sender]);
188 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
189 		require(amount > 0);
190 		require(sellPrice > 0);
191 		_transfer(msg.sender, this, amount);
192 		uint256 revenue = amount * sellPrice;
193 		require(this.balance >= revenue);
194 		msg.sender.transfer(revenue);                		// sends ether to the seller: it's important to do this last to prevent recursion attacks
195 	}
196 	
197 	/// @notice Allow user to sell maximum possible amount of tokens, depend on ether amount on contract
198 	function sellMaximumPossibleAmountOfTokens() {
199 		require(!frozenAccount[msg.sender]);
200 		require(tokenBalanceOf[msg.sender] > 0);
201 		require(this.balance > sellPrice);
202 		if(tokenBalanceOf[msg.sender] * sellPrice <= this.balance) {
203 			sell(tokenBalanceOf[msg.sender]);
204 		}else {
205 			sell(this.balance / sellPrice);
206 		}
207 	}
208 
209 	/// @notice Transfer amount of tokens from own wallet to someone else
210 	function transfer(address _to, uint256 _value) returns (bool success) {
211 		assert(msg.sender != address(0));
212 		assert(_to != address(0));
213 		require(!frozenAccount[msg.sender]);
214 		require(!frozenAccount[_to]);
215 		require(tokenBalanceOf[msg.sender] >= _value);
216 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
217 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
218 		require(_value > 0);
219 		_transfer(msg.sender, _to, _value);
220 		return true;
221 	}
222 
223 	/// @notice  Send _value amount of tokens from address _from to address _to
224 	/// @notice  The transferFrom method is used for a withdraw workflow, allowing contracts to send
225 	/// @notice  tokens on your behalf, for example to "deposit" to a contract address and/or to charge
226 	/// @notice  fees in sub-currencies; the command should fail unless the _from account has
227 	/// @notice  deliberately authorized the sender of the message via some mechanism; we propose
228 	/// @notice  these standardized APIs for approval:
229 	function transferFrom(address _from,	address _to,	uint256 _value) returns (bool success) {
230 		assert(msg.sender != address(0));
231 		assert(_from != address(0));
232 		assert(_to != address(0));
233 		require(!frozenAccount[msg.sender]);
234 		require(!frozenAccount[_from]);
235 		require(!frozenAccount[_to]);
236 		require(tokenBalanceOf[_from] >= _value);
237 		require(allowed[_from][msg.sender] >= _value);
238 		require(tokenBalanceOf[_from] - _value < tokenBalanceOf[_from]);
239 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
240 		require(_value > 0);
241 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer tokens from allowed account");
242 		_transfer(_from, _to, _value);
243 		allowed[_from][msg.sender] -= _value;
244 		return true;
245 	}
246 
247 	/// @notice Allow _spender to withdraw from your account, multiple times, up to the _value amount.
248 	/// @notice If this function is called again it overwrites the current allowance with _value.
249 	function approve(address _spender, uint256 _value) returns (bool success) {
250 		require(!frozenAccount[msg.sender]);
251 		assert(_spender != address(0));
252 		require(_value >= 0);
253 		allowed[msg.sender][_spender] = _value;
254 		return true;
255 	}
256 
257 	/// @notice Check if minimal goal of ICO is reached
258 	function checkMinimalGoal() internal {
259 		if(tokenBalanceOf[this] <= _totalSupply - icoMin) {
260 			minimalGoalReached = true;
261 			minGoalReached(icoMin, "Minimal goal of ICO is reached!");
262 		}
263 	}
264 
265 	/// @notice Check if preICO is ended
266 	function checkPreIcoStatus() internal {
267 		if(tokenBalanceOf[this] <= _totalSupply - preIcoLimit) {
268 			preIcoIsRunning = false;
269 			preIcoEnded(preIcoLimit, "Token amount for preICO sold!");
270 		}
271 	}
272 
273 	/// @notice Processing each buying
274 	function buyToken() internal {
275 		uint256 value = msg.value;
276 		address sender = msg.sender;
277 		require(!icoIsClosed);
278 		require(!frozenAccount[sender]);
279 		require(value > 0);
280 		require(currentTokenPrice > 0);
281 		uint256 amount = value / currentTokenPrice;			// calculates amount of tokens
282 		uint256 moneyBack = value - (amount * currentTokenPrice);
283 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
284 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
285 		updatePrices();
286 		_transfer(this, sender, amount);
287 		if(!minimalGoalReached) {
288 			checkMinimalGoal();
289 		}
290 		if(moneyBack > 0) {
291 			sender.transfer(moneyBack);
292 		}
293 	}
294 
295 	/// @notice Internal transfer, can only be called by this contract
296 	function _transfer(address _from, address _to, uint256 _value) internal {
297 		assert(_from != address(0));
298 		assert(_to != address(0));
299 		require(_value > 0);
300 		require(tokenBalanceOf[_from] >= _value);
301 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
302 		require(!frozenAccount[_from]);
303 		require(!frozenAccount[_to]);
304 		if(tokenBalanceOf[_to] == 0){
305 			countHolders += 1;
306 		}
307 		tokenBalanceOf[_from] -= _value;
308 		if(tokenBalanceOf[_from] == 0){
309 			countHolders -= 1;
310 		}
311 		tokenBalanceOf[_to] += _value;
312 		allowed[this][owner] = tokenBalanceOf[this];
313 		allowed[this][supervisor] = tokenBalanceOf[this];
314 		Transfer(_from, _to, _value);
315 	}
316 
317 	/// @notice Set current ICO prices in wei for one token
318 	function updatePrices() internal {
319 		uint256 oldPrice = currentTokenPrice;
320 		if(preIcoIsRunning) {
321 			checkPreIcoStatus();
322 		}
323 		if(preIcoIsRunning) {
324 			currentTokenPrice = preICOprice;
325 		}else{
326 			currentTokenPrice = ICOprice;
327 		}
328 		
329 		if(oldPrice != currentTokenPrice) {
330 			priceUpdated(oldPrice, currentTokenPrice, "Token price updated!");
331 		}
332 	}
333 
334 	/// @notice Set current preICO price in wei for one token
335 	/// @param priceForPreIcoInWei - is the amount in wei for one token
336 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
337 		require(priceForPreIcoInWei > 0);
338 		require(preICOprice != priceForPreIcoInWei);
339 		preICOprice = priceForPreIcoInWei;
340 		updatePrices();
341 	}
342 
343 	/// @notice Set current ICO price in wei for one token
344 	/// @param priceForIcoInWei - is the amount in wei for one token
345 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
346 		require(priceForIcoInWei > 0);
347 		require(ICOprice != priceForIcoInWei);
348 		ICOprice = priceForIcoInWei;
349 		updatePrices();
350 	}
351 
352 	/// @notice Set both prices at the same time
353 	/// @param priceForPreIcoInWei - Price of the token in pre ICO
354 	/// @param priceForIcoInWei - Price of the token in ICO
355 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
356 		require(priceForPreIcoInWei > 0);
357 		require(priceForIcoInWei > 0);
358 		preICOprice = priceForPreIcoInWei;
359 		ICOprice = priceForIcoInWei;
360 		updatePrices();
361 	}
362 	
363 	/// @notice Set current mtdAmount price in wei for one token
364 	/// @param mtdAmountInWei - is the amount in wei for one token
365 	function setMtdAmount(uint256 mtdAmountInWei) isOwner {
366 		require(mtdAmountInWei > 0);
367 		require(mtdAmount != mtdAmountInWei);
368 		mtdAmount = mtdAmountInWei;
369 		updatePrices();
370 	}
371 
372 	/// @notice Set current ethAmount price in wei for one token
373 	/// @param ethAmountInWei - is the amount in wei for one token
374 	function setEthAmount(uint256 ethAmountInWei) isOwner {
375 		require(ethAmountInWei > 0);
376 		require(ethAmount != ethAmountInWei);
377 		ethAmount = ethAmountInWei;
378 		updatePrices();
379 	}
380 
381 	/// @notice Set both ethAmount and mtdAmount at the same time
382 	/// @param mtdAmountInWei - is the amount in wei for one token
383 	/// @param ethAmountInWei - is the amount in wei for one token
384 	function setAmounts(uint256 mtdAmountInWei, uint256 ethAmountInWei) isOwner {
385 		require(mtdAmountInWei > 0);
386 		require(ethAmountInWei > 0);
387 		mtdAmount = mtdAmountInWei;
388 		ethAmount = ethAmountInWei;
389 		updatePrices();
390 	}
391 	
392 	/// @notice Set current mtdPreAmount price in wei for one token
393 	/// @param mtdPreAmountInWei - is the amount in wei for one token
394 	function setMtdPreAmount(uint256 mtdPreAmountInWei) isOwner {
395 		require(mtdPreAmountInWei > 0);
396 		require(mtdPreAmount != mtdPreAmountInWei);
397 		mtdPreAmount = mtdPreAmountInWei;
398 		updatePrices();
399 	}
400 
401 	/// @notice Set current ethPreAmount price in wei for one token
402 	/// @param ethPreAmountInWei - is the amount in wei for one token
403 	function setEthPreAmount(uint256 ethPreAmountInWei) isOwner {
404 		require(ethPreAmountInWei > 0);
405 		require(ethPreAmount != ethPreAmountInWei);
406 		ethPreAmount = ethPreAmountInWei;
407 		updatePrices();
408 	}
409 
410 	/// @notice Set both ethPreAmount and mtdPreAmount at the same time
411 	/// @param mtdPreAmountInWei - is the amount in wei for one token
412 	/// @param ethPreAmountInWei - is the amount in wei for one token
413 	function setPreAmounts(uint256 mtdPreAmountInWei, uint256 ethPreAmountInWei) isOwner {
414 		require(mtdPreAmountInWei > 0);
415 		require(ethPreAmountInWei > 0);
416 		mtdPreAmount = mtdPreAmountInWei;
417 		ethPreAmount = ethPreAmountInWei;
418 		updatePrices();
419 	}
420 
421 	/// @notice Set the current sell price in wei for one token
422 	/// @param priceInWei - is the amount in wei for one token
423 	function setSellPrice(uint256 priceInWei) isOwner {
424 		require(priceInWei >= 0);
425 		sellPrice = priceInWei;
426 	}
427 
428 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving tokens
429 	/// @param account - address to be frozen
430 	/// @param freeze - select is the account frozen or not
431 	function freezeAccount(address account, bool freeze) isOwner {
432 		require(account != owner);
433 		require(account != supervisor);
434 		frozenAccount[account] = freeze;
435 		if(freeze) {
436 			FrozenFunds(msg.sender, account, "Account set frozen!");
437 		}else {
438 			FrozenFunds(msg.sender, account, "Account set free for use!");
439 		}
440 	}
441 
442 	/// @notice Create an amount of token
443 	/// @param amount - token to create
444 	function mintToken(uint256 amount) isOwner {
445 		require(amount > 0);
446 		require(tokenBalanceOf[this] <= icoMin);	// owner can create token only if the initial amount is strongly not enough to supply and demand ICO
447 		require(_totalSupply + amount > _totalSupply);
448 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
449 		_totalSupply += amount;
450 		tokenBalanceOf[this] += amount;
451 		allowed[this][owner] = tokenBalanceOf[this];
452 		allowed[this][supervisor] = tokenBalanceOf[this];
453 		tokenCreated(msg.sender, amount, "Additional tokens created!");
454 	}
455 
456 	/// @notice Destroy an amount of token
457 	/// @param amount - token to destroy
458 	function destroyToken(uint256 amount) isOwner {
459 		require(amount > 0);
460 		require(tokenBalanceOf[this] >= amount);
461 		require(_totalSupply >= amount);
462 		require(tokenBalanceOf[this] - amount >= 0);
463 		require(_totalSupply - amount >= 0);
464 		tokenBalanceOf[this] -= amount;
465 		_totalSupply -= amount;
466 		allowed[this][owner] = tokenBalanceOf[this];
467 		allowed[this][supervisor] = tokenBalanceOf[this];
468 		tokenDestroyed(msg.sender, amount, "An amount of tokens destroyed!");
469 	}
470 
471 	/// @notice Transfer the ownership to another account
472 	/// @param newOwner - address who get the ownership
473 	function transferOwnership(address newOwner) isOwner {
474 		assert(newOwner != address(0));
475 		address oldOwner = owner;
476 		owner = newOwner;
477 		ownerChanged(msg.sender, oldOwner, newOwner);
478 		allowed[this][oldOwner] = 0;
479 		allowed[this][newOwner] = tokenBalanceOf[this];
480 	}
481 
482 	/// @notice Transfer ether from smartcontract to owner
483 	function collect() isOwner {
484         require(this.balance > 0);
485 		withdraw(this.balance);
486     }
487 
488 	/// @notice Withdraw an amount of ether
489 	/// @param summeInWei - amout to withdraw
490 	function withdraw(uint256 summeInWei) isOwner {
491 		uint256 contractbalance = this.balance;
492 		address sender = msg.sender;
493 		require(contractbalance >= summeInWei);
494 		withdrawed(sender, summeInWei, "wei withdrawed");
495         sender.transfer(summeInWei);
496 	}
497 
498 	/// @notice Deposit an amount of ether
499 	function deposit() payable isOwner {
500 		require(msg.value > 0);
501 		require(msg.sender.balance >= msg.value);
502 		deposited(msg.sender, msg.value, "wei deposited");
503 	}
504 
505 
506 	/// @notice Stop running ICO
507 	/// @param icoIsStopped - status if this ICO is stopped
508 	function stopThisIco(bool icoIsStopped) isOwner {
509 		require(icoIsClosed != icoIsStopped);
510 		icoIsClosed = icoIsStopped;
511 		if(icoIsStopped) {
512 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
513 		}else {
514 			icoStatusUpdated(msg.sender, "Coin offering is running!");
515 		}
516 	}
517 
518 }