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
36 	address constant supervisor  = 0x318B0f768f5c6c567227AA50B51B5b3078902f8C;
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
54 contract BFreeContract is ERC20Interface, owned{
55 
56 	string public constant name = "BFree";
57 	string public constant symbol = "BFR";
58 	uint public constant decimals = 0;
59 	uint256 public _totalSupply = 2240000;
60 	uint256 public icoMin = 300000;					// = 300000; amount is in Tokens, 1.800.000
61 	uint256 public preIcoLimit = 600000;			// = 600000; amount is in tokens, 3.600.000
62 	uint256 public countHolders = 0;				// count how many unique holders have tokens
63 	uint256 public amountOfInvestments = 0;	// amount of collected wei
64 	
65 	uint256 preICOprice;									// price of 1 token in weis for the preICO time
66 	uint256 ICOprice;										// price of 1 token in weis for the ICO time
67 	uint256 public currentTokenPrice;				// current token price in weis
68 	uint256 public sellPrice;								// buyback price of one token in weis
69 	
70 	bool public preIcoIsRunning;
71 	bool public minimalGoalReached;
72 	bool public icoIsClosed;
73 	bool icoExitIsPossible;
74 	
75 
76 	//Balances for each account
77 	mapping (address => uint256) public tokenBalanceOf;
78 
79 	// Owner of account approves the transfer of an amount to another account
80 	mapping(address => mapping (address => uint256)) allowed;
81 	
82 	//list with information about frozen accounts
83 	mapping(address => bool) frozenAccount;
84 	
85 	//this generate a public event on a blockchain that will notify clients
86 	event FrozenFunds(address initiator, address account, string status);
87 	
88 	//this generate a public event on a blockchain that will notify clients
89 	event BonusChanged(uint8 bonusOld, uint8 bonusNew);
90 	
91 	//this generate a public event on a blockchain that will notify clients
92 	event minGoalReached(uint256 minIcoAmount, string notice);
93 	
94 	//this generate a public event on a blockchain that will notify clients
95 	event preIcoEnded(uint256 preIcoAmount, string notice);
96 	
97 	//this generate a public event on a blockchain that will notify clients
98 	event priceUpdated(uint256 oldPrice, uint256 newPrice, string notice);
99 	
100 	//this generate a public event on a blockchain that will notify clients
101 	event withdrawed(address _to, uint256 summe, string notice);
102 	
103 	//this generate a public event on a blockchain that will notify clients
104 	event deposited(address _from, uint256 summe, string notice);
105 	
106 	//this generate a public event on a blockchain that will notify clients
107 	event orderToTransfer(address initiator, address _from, address _to, uint256 summe, string notice);
108 	
109 	//this generate a public event on a blockchain that will notify clients
110 	event tokenCreated(address _creator, uint256 summe, string notice);
111 	
112 	//this generate a public event on a blockchain that will notify clients
113 	event tokenDestroyed(address _destroyer, uint256 summe, string notice);
114 	
115 	//this generate a public event on a blockchain that will notify clients
116 	event icoStatusUpdated(address _initiator, string status);
117 
118 	/// @notice Constructor of the contract
119 	function BFreeContract() {
120 		preIcoIsRunning = true;
121 		minimalGoalReached = false;
122 		icoExitIsPossible = false;
123 		icoIsClosed = false;
124 		tokenBalanceOf[this] += _totalSupply;
125 		allowed[this][owner] = _totalSupply;
126 		allowed[this][supervisor] = _totalSupply;
127 		currentTokenPrice = 0.024340770791075100 * 1 ether;	// initial price of 1 Token
128 		preICOprice = 0.024340770791075100 * 1 ether; 			// price of 1 token in weis for the preICO time, ca.6,- Euro
129 		ICOprice = 0.040567951318458400 * 1 ether;				// price of 1 token in weis for the ICO time, ca.10,- Euro
130 		sellPrice = 0;
131 		updatePrices();
132 	}
133 
134 	function () payable {
135 		require(!frozenAccount[msg.sender]);
136 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
137 			buyToken();
138 		}
139 	}
140 
141 	/// @notice Returns a whole amount of tokens
142 	function totalSupply() constant returns (uint256 totalAmount) {
143 		totalAmount = _totalSupply;
144 	}
145 
146 	/// @notice What is the balance of a particular account?
147 	function balanceOf(address _owner) constant returns (uint256 balance) {
148 		return tokenBalanceOf[_owner];
149 	}
150 
151 	/// @notice Shows how much tokens _spender can spend from _owner address
152 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
153 		return allowed[_owner][_spender];
154 	}
155 	
156 	/// @notice Calculates amount of weis needed to buy more than one token
157 	/// @param howManyTokenToBuy - Amount of tokens to calculate
158 	function calculateTheEndPrice(uint256 howManyTokenToBuy) constant returns (uint256 summarizedPriceInWeis) {
159 		if(howManyTokenToBuy > 0) {
160 			summarizedPriceInWeis = howManyTokenToBuy * currentTokenPrice;
161 		}else {
162 			summarizedPriceInWeis = 0;
163 		}
164 	}
165 	
166 	/// @notice Shows if account is frozen
167 	/// @param account - Accountaddress to check
168 	function checkFrozenAccounts(address account) constant returns (bool accountIsFrozen) {
169 		accountIsFrozen = frozenAccount[account];
170 	}
171 
172 	/// @notice Buy tokens from contract by sending ether
173 	function buy() payable public {
174 		require(!frozenAccount[msg.sender]);
175 		require(msg.value > 0);
176 		buyToken();
177 	}
178 
179 	/// @notice Sell tokens and receive ether from contract
180 	function sell(uint256 amount) {
181 		require(!frozenAccount[msg.sender]);
182 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
183 		require(amount > 0);
184 		require(sellPrice > 0);
185 		_transfer(msg.sender, this, amount);
186 		uint256 revenue = amount * sellPrice;
187 		require(this.balance >= revenue);
188 		msg.sender.transfer(revenue);                		// sends ether to the seller: it's important to do this last to prevent recursion attacks
189 	}
190 	
191 	/// @notice Allow user to sell maximum possible amount of tokens, depend on ether amount on contract
192 	function sellMaximumPossibleAmountOfTokens() {
193 		require(!frozenAccount[msg.sender]);
194 		require(tokenBalanceOf[msg.sender] > 0);
195 		require(this.balance > sellPrice);
196 		if(tokenBalanceOf[msg.sender] * sellPrice <= this.balance) {
197 			sell(tokenBalanceOf[msg.sender]);
198 		}else {
199 			sell(this.balance / sellPrice);
200 		}
201 	}
202 
203 	/// @notice Transfer amount of tokens from own wallet to someone else
204 	function transfer(address _to, uint256 _value) returns (bool success) {
205 		assert(msg.sender != address(0));
206 		assert(_to != address(0));
207 		require(!frozenAccount[msg.sender]);
208 		require(!frozenAccount[_to]);
209 		require(tokenBalanceOf[msg.sender] >= _value);
210 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
211 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
212 		require(_value > 0);
213 		_transfer(msg.sender, _to, _value);
214 		return true;
215 	}
216 
217 	/// @notice  Send _value amount of tokens from address _from to address _to
218 	/// @notice  The transferFrom method is used for a withdraw workflow, allowing contracts to send
219 	/// @notice  tokens on your behalf, for example to "deposit" to a contract address and/or to charge
220 	/// @notice  fees in sub-currencies; the command should fail unless the _from account has
221 	/// @notice  deliberately authorized the sender of the message via some mechanism; we propose
222 	/// @notice  these standardized APIs for approval:
223 	function transferFrom(address _from,	address _to,	uint256 _value) returns (bool success) {
224 		assert(msg.sender != address(0));
225 		assert(_from != address(0));
226 		assert(_to != address(0));
227 		require(!frozenAccount[msg.sender]);
228 		require(!frozenAccount[_from]);
229 		require(!frozenAccount[_to]);
230 		require(tokenBalanceOf[_from] >= _value);
231 		require(allowed[_from][msg.sender] >= _value);
232 		require(tokenBalanceOf[_from] - _value < tokenBalanceOf[_from]);
233 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
234 		require(_value > 0);
235 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer tokens from allowed account");
236 		_transfer(_from, _to, _value);
237 		allowed[_from][msg.sender] -= _value;
238 		return true;
239 	}
240 
241 	/// @notice Allow _spender to withdraw from your account, multiple times, up to the _value amount.
242 	/// @notice If this function is called again it overwrites the current allowance with _value.
243 	function approve(address _spender, uint256 _value) returns (bool success) {
244 		require(!frozenAccount[msg.sender]);
245 		assert(_spender != address(0));
246 		require(_value >= 0);
247 		allowed[msg.sender][_spender] = _value;
248 		return true;
249 	}
250 
251 	/// @notice Check if minimal goal of ICO is reached
252 	function checkMinimalGoal() internal {
253 		if(tokenBalanceOf[this] <= _totalSupply - icoMin) {
254 			minimalGoalReached = true;
255 			minGoalReached(icoMin, "Minimal goal of ICO is reached!");
256 		}
257 	}
258 
259 	/// @notice Check if preICO is ended
260 	function checkPreIcoStatus() internal {
261 		if(tokenBalanceOf[this] <= _totalSupply - preIcoLimit) {
262 			preIcoIsRunning = false;
263 			preIcoEnded(preIcoLimit, "Token amount for preICO sold!");
264 		}
265 	}
266 
267 	/// @notice Processing each buying
268 	function buyToken() internal {
269 		uint256 value = msg.value;
270 		address sender = msg.sender;
271 		require(!icoIsClosed);
272 		require(!frozenAccount[sender]);
273 		require(value > 0);
274 		require(currentTokenPrice > 0);
275 		uint256 amount = value / currentTokenPrice;			// calculates amount of tokens
276 		uint256 moneyBack = value - (amount * currentTokenPrice);
277 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
278 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
279 		updatePrices();
280 		_transfer(this, sender, amount);
281 		if(!minimalGoalReached) {
282 			checkMinimalGoal();
283 		}
284 		if(moneyBack > 0) {
285 			sender.transfer(moneyBack);
286 		}
287 	}
288 
289 	/// @notice Internal transfer, can only be called by this contract
290 	function _transfer(address _from, address _to, uint256 _value) internal {
291 		assert(_from != address(0));
292 		assert(_to != address(0));
293 		require(_value > 0);
294 		require(tokenBalanceOf[_from] >= _value);
295 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
296 		require(!frozenAccount[_from]);
297 		require(!frozenAccount[_to]);
298 		if(tokenBalanceOf[_to] == 0){
299 			countHolders += 1;
300 		}
301 		tokenBalanceOf[_from] -= _value;
302 		if(tokenBalanceOf[_from] == 0){
303 			countHolders -= 1;
304 		}
305 		tokenBalanceOf[_to] += _value;
306 		allowed[this][owner] = tokenBalanceOf[this];
307 		allowed[this][supervisor] = tokenBalanceOf[this];
308 		Transfer(_from, _to, _value);
309 	}
310 
311 	/// @notice Set current ICO prices in wei for one token
312 	function updatePrices() internal {
313 		uint256 oldPrice = currentTokenPrice;
314 		if(preIcoIsRunning) {
315 			checkPreIcoStatus();
316 		}
317 		if(preIcoIsRunning) {
318 			currentTokenPrice = preICOprice;
319 		}else{
320 			currentTokenPrice = ICOprice;
321 		}
322 		
323 		if(oldPrice != currentTokenPrice) {
324 			priceUpdated(oldPrice, currentTokenPrice, "Token price updated!");
325 		}
326 	}
327 
328 	/// @notice Set current preICO price in wei for one token
329 	/// @param priceForPreIcoInWei - is the amount in wei for one token
330 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
331 		require(priceForPreIcoInWei > 0);
332 		require(preICOprice != priceForPreIcoInWei);
333 		preICOprice = priceForPreIcoInWei;
334 		updatePrices();
335 	}
336 
337 	/// @notice Set current ICO price in wei for one token
338 	/// @param priceForIcoInWei - is the amount in wei for one token
339 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
340 		require(priceForIcoInWei > 0);
341 		require(ICOprice != priceForIcoInWei);
342 		ICOprice = priceForIcoInWei;
343 		updatePrices();
344 	}
345 
346 	/// @notice Set both prices at the same time
347 	/// @param priceForPreIcoInWei - Price of the token in pre ICO
348 	/// @param priceForIcoInWei - Price of the token in ICO
349 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
350 		require(priceForPreIcoInWei > 0);
351 		require(priceForIcoInWei > 0);
352 		preICOprice = priceForPreIcoInWei;
353 		ICOprice = priceForIcoInWei;
354 		updatePrices();
355 	}
356 
357 	/// @notice Set the current sell price in wei for one token
358 	/// @param priceInWei - is the amount in wei for one token
359 	function setSellPrice(uint256 priceInWei) isOwner {
360 		require(priceInWei >= 0);
361 		sellPrice = priceInWei;
362 	}
363 
364 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving tokens
365 	/// @param account - address to be frozen
366 	/// @param freeze - select is the account frozen or not
367 	function freezeAccount(address account, bool freeze) isOwner {
368 		require(account != owner);
369 		require(account != supervisor);
370 		frozenAccount[account] = freeze;
371 		if(freeze) {
372 			FrozenFunds(msg.sender, account, "Account set frozen!");
373 		}else {
374 			FrozenFunds(msg.sender, account, "Account set free for use!");
375 		}
376 	}
377 
378 	/// @notice Create an amount of token
379 	/// @param amount - token to create
380 	function mintToken(uint256 amount) isOwner {
381 		require(amount > 0);
382 		require(tokenBalanceOf[this] <= icoMin);	// owner can create token only if the initial amount is strongly not enough to supply and demand ICO
383 		require(_totalSupply + amount > _totalSupply);
384 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
385 		_totalSupply += amount;
386 		tokenBalanceOf[this] += amount;
387 		allowed[this][owner] = tokenBalanceOf[this];
388 		allowed[this][supervisor] = tokenBalanceOf[this];
389 		tokenCreated(msg.sender, amount, "Additional tokens created!");
390 	}
391 
392 	/// @notice Destroy an amount of token
393 	/// @param amount - token to destroy
394 	function destroyToken(uint256 amount) isOwner {
395 		require(amount > 0);
396 		require(tokenBalanceOf[this] >= amount);
397 		require(_totalSupply >= amount);
398 		require(tokenBalanceOf[this] - amount >= 0);
399 		require(_totalSupply - amount >= 0);
400 		tokenBalanceOf[this] -= amount;
401 		_totalSupply -= amount;
402 		allowed[this][owner] = tokenBalanceOf[this];
403 		allowed[this][supervisor] = tokenBalanceOf[this];
404 		tokenDestroyed(msg.sender, amount, "An amount of tokens destroyed!");
405 	}
406 
407 	/// @notice Transfer the ownership to another account
408 	/// @param newOwner - address who get the ownership
409 	function transferOwnership(address newOwner) isOwner {
410 		assert(newOwner != address(0));
411 		address oldOwner = owner;
412 		owner = newOwner;
413 		ownerChanged(msg.sender, oldOwner, newOwner);
414 		allowed[this][oldOwner] = 0;
415 		allowed[this][newOwner] = tokenBalanceOf[this];
416 	}
417 
418 	/// @notice Transfer ether from smartcontract to owner
419 	function collect() isOwner {
420         require(this.balance > 0);
421 		require(minimalGoalReached);	// Owner can get funds only if minimal fundrising is reached
422 		withdraw(this.balance);
423     }
424 
425 	/// @notice Withdraw an amount of ether
426 	/// @param summeInWei - amout to withdraw
427 	function withdraw(uint256 summeInWei) isOwner {
428 		uint256 contractbalance = this.balance;
429 		address sender = msg.sender;
430 		require(contractbalance >= summeInWei);
431 		require(minimalGoalReached);	// Owner can get funds only if minimal fundrising is reached
432 		withdrawed(sender, summeInWei, "wei withdrawed");
433         sender.transfer(summeInWei);
434 	}
435 
436 	/// @notice Deposit an amount of ether
437 	function deposit() payable isOwner {
438 		require(msg.value > 0);
439 		require(msg.sender.balance >= msg.value);
440 		deposited(msg.sender, msg.value, "wei deposited");
441 	}
442 
443 	/// @notice Allow user to exit ICO
444 	/// @param exitAllowed - status if the exit is allowed
445 	function allowIcoExit(bool exitAllowed) isOwner {
446 		require(icoExitIsPossible != exitAllowed);
447 		icoExitIsPossible = exitAllowed;
448 	}
449 
450 	/// @notice Stop running ICO
451 	/// @param icoIsStopped - status if this ICO is stopped
452 	function stopThisIco(bool icoIsStopped) isOwner {
453 		require(icoIsClosed != icoIsStopped);
454 		icoIsClosed = icoIsStopped;
455 		if(icoIsStopped) {
456 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
457 		}else {
458 			icoStatusUpdated(msg.sender, "Coin offering is running!");
459 		}
460 	}
461 
462 	/// @notice Sell all tokens for half of a price and exit this ICO
463 	function exitThisIcoForHalfOfTokenPrice() {
464 		require(icoExitIsPossible);
465 		require(!frozenAccount[msg.sender]);
466 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
467 		require(currentTokenPrice > 1);
468 		uint256 amount = tokenBalanceOf[msg.sender] ;
469 		uint256 revenue = amount * currentTokenPrice / 2;
470 		require(this.balance >= revenue);
471 		_transfer(msg.sender, this, amount);
472 		msg.sender.transfer(revenue);                	// sends ether to the seller: it's important to do this last to prevent recursion attacks
473 	}
474 
475 	/// @notice Sell all of tokens for all ether of this smartcontract
476 	function getAllMyTokensForAllEtherOnContract() {
477 		require(icoExitIsPossible);
478 		require(!frozenAccount[msg.sender]);
479 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
480 		require(currentTokenPrice > 1);
481 		uint256 amount = tokenBalanceOf[msg.sender] ;
482 		uint256 revenue = amount * currentTokenPrice / 2;
483 		require(this.balance <= revenue);
484 		_transfer(msg.sender, this, amount);
485 		msg.sender.transfer(this.balance); 
486 	}
487 }