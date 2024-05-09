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
54 contract METADOLLAR is ERC20Interface, owned{
55 
56 	string public constant name = "METADOLLAR";
57 	string public constant symbol = "DOL";
58 	uint public constant decimals = 18;
59 	uint256 public _totalSupply = 1000000000000000000000000000000;  // Total Supply 1000,000,000,000
60 	uint256 public icoMin = 1000000000000000000000000000000;				 //  Min ICO 1000,000,000,000	
61 	uint256 public preIcoLimit = 1000000000000000000;		 // Pre Ico Limit 1
62 	uint256 public countHolders = 0;				// count how many unique holders have metadollars
63 	uint256 public amountOfInvestments = 0;	// amount of collected wei
64 	
65 	
66 	uint256 public preICOprice;			// price of 1 metadollar in weis for the preICO time
67 	uint256 public ICOprice;				// price of 1 metadollar in weis for the ICO time
68 	uint256 public currentTokenPrice;			// current metadollar price in weis
69 	uint256 public sellPrice;					// buyback price of one metadollar in weis
70 	uint256 public buyRate;								// Commission on buy
71 	uint256 public sellRate;								// Commission on sell
72 	
73 	bool public preIcoIsRunning;
74 	bool public minimalGoalReached;
75 	bool public icoIsClosed;
76 	bool icoExitIsPossible;
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
123 		preIcoIsRunning = true;
124 		minimalGoalReached = false;
125 		icoExitIsPossible = false;
126 		icoIsClosed = false;
127 		tokenBalanceOf[this] += _totalSupply;
128 		allowed[this][owner] = _totalSupply;
129 		allowed[this][supervisor] = _totalSupply;
130 		currentTokenPrice = 1 * 1 ether;	// initial price of 1 metadollar
131 		preICOprice = 1000000000000000000 * 1000000000000000000 wei; 			// price of 1 token in weis for the preICO time, ca.6,- Euro
132 		ICOprice =  1000000000000000000 *  1000000000000000000 wei;   // price of 1 token in weis for the ICO time, ca.10,- Euro
133 		sellPrice = 1000000000000000000 * 1000000000000000000 wei;
134 		buyRate = 0;   // set 100 for 1% or 1000 for 0.1%
135 		sellRate = 0;   // set 100 for 1% or 1000 for 0.1%
136 		updatePrices();
137 		
138 	}
139 
140 	function () payable {
141 		require(!frozenAccount[msg.sender]);
142 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
143 			buyToken();
144 		}
145 	}
146 
147 	/// @notice Returns a whole amount of metadollars
148 	function totalSupply() constant returns (uint256 totalAmount) {
149 		totalAmount = _totalSupply;
150 	}
151 
152 	/// @notice What is the balance of a particular account?
153 	function balanceOf(address _owner) constant returns (uint256 balance) {
154 		return tokenBalanceOf[_owner];
155 	}
156 
157 	/// @notice Shows how much metadollars _spender can spend from _owner address
158 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
159 		return allowed[_owner][_spender];
160 	}
161 	
162 	/// @notice Calculates amount of weis needed to buy more than one metadollar
163 	/// @param howManyTokenToBuy - Amount of metadollars to calculate
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
178 	/// @notice Buy metadollars from contract by sending ether
179 	function buy() payable public {
180 		require(!frozenAccount[msg.sender]);
181 		require(msg.value > 0);
182 		uint commission = msg.value/buyRate; // Buy Commission x1000 of wei tx
183         require(address(this).send(commission));
184 		buyToken();
185 	}
186 
187 	/// @notice Sell metadollars and receive ether from contract
188 	function sell(uint256 amount) {
189 		require(!frozenAccount[msg.sender]);
190 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
191 		require(amount > 0);
192 		require(sellPrice > 0);
193 		_transfer(msg.sender, this, amount);
194 		uint256 revenue = amount * sellPrice;
195 		uint commission = msg.value/sellRate; // Sell Commission x1000 of wei tx
196         require(address(this).send(commission));
197 		msg.sender.transfer(revenue);         // sends ether to the seller: it's important to do this last to prevent recursion attacks
198 	}
199 	
200 	/// @notice Allow user to sell all amount of metadollars at once , depend on ether amount on contract
201 	function sellAllDolAtOnce() {
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
212 	/// @notice Transfer amount of metadollars from own wallet to someone else
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
226 	/// @notice  Send _value amount of metadollars from address _from to address _to
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
244 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer metadollars from allowed account");
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
284 		uint256 amount = value / currentTokenPrice;			// calculates amount of metadollars
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
320 	/// @notice Set current ICO prices in wei for one metadollar
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
333 			priceUpdated(oldPrice, currentTokenPrice, "Metadollar price updated!");
334 		}
335 	}
336 
337 	/// @notice Set current preICO price in wei for one metadollar
338 	/// @param priceForPreIcoInWei - is the amount in wei for one metadollar
339 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
340 		require(priceForPreIcoInWei > 0);
341 		require(preICOprice != priceForPreIcoInWei);
342 		preICOprice = priceForPreIcoInWei;
343 		updatePrices();
344 	}
345 	
346 
347 	/// @notice Set current ICO price price in wei for one metadollar
348 	/// @param priceForIcoInWei - is the amount in wei
349 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
350 		require(priceForIcoInWei > 0);
351 		require(ICOprice != priceForIcoInWei);
352 		ICOprice = priceForIcoInWei;
353 		updatePrices();
354 	}
355 	
356 	
357 
358 	/// @notice Set both prices at the same time
359 	/// @param priceForPreIcoInWei - Price of the metadollar in pre ICO
360 	/// @param priceForIcoInWei - Price of the metadollar in ICO
361 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
362 		require(priceForPreIcoInWei > 0);
363 		require(priceForIcoInWei > 0);
364 		preICOprice = priceForPreIcoInWei;
365 		ICOprice = priceForIcoInWei;
366 		updatePrices();
367 	}
368 	
369 
370 	/// @notice Set the current sell price in wei for one metadollar
371 	/// @param priceInWei - is the amount in wei for one metadollar
372 	function setSellPrice(uint256 priceInWei) isOwner {
373 		require(priceInWei >= 0);
374 		sellPrice = priceInWei;
375 	}
376 
377     /// @notice Set current Buy Commission price in wei
378 	/// @param buyRateInWei - is the amount in wei
379 	function setBuyRate(uint256 buyRateInWei) isOwner {
380 		require(buyRateInWei > 0);
381 		require(buyRate != buyRateInWei);
382 		buyRate = buyRateInWei;
383 		updatePrices();
384 	}
385 	
386 	/// @notice Set current Sell Commission price in wei for one metadollar
387 	/// @param sellRateInWei - is the amount in wei for one metadollar
388 	function setSellRate(uint256 sellRateInWei) isOwner {
389 		require(sellRateInWei > 0);
390 		require(sellRate != sellRateInWei);
391 		buyRate = sellRateInWei;
392 		updatePrices();
393 	}
394 
395 	
396 	
397 	/// @notice Set both commissions at the same time
398 	/// @param buyRateInWei - Commission for buy
399 	/// @param sellRateInWei - Commission for sell
400 	function setRates(uint256 buyRateInWei, uint256 sellRateInWei) isOwner {
401 		require( buyRateInWei> 0);
402 		require(sellRateInWei > 0);
403 		buyRate = buyRateInWei;
404 		sellRate = buyRateInWei;
405 		updatePrices();
406 	}
407 
408 
409 
410 
411 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving metadollars
412 	/// @param account - address to be frozen
413 	/// @param freeze - select is the account frozen or not
414 	function freezeAccount(address account, bool freeze) isOwner {
415 		require(account != owner);
416 		require(account != supervisor);
417 		frozenAccount[account] = freeze;
418 		if(freeze) {
419 			FrozenFunds(msg.sender, account, "Account set frozen!");
420 		}else {
421 			FrozenFunds(msg.sender, account, "Account set free for use!");
422 		}
423 	}
424 
425 	/// @notice Create an amount of metadollars
426 	/// @param amount - metadollars to create
427 	function mintToken(uint256 amount) isOwner {
428 		require(amount > 0);
429 		require(tokenBalanceOf[this] <= icoMin);	// owner can create metadollars only if the initial amount is strongly not enough to supply and demand ICO
430 		require(_totalSupply + amount > _totalSupply);
431 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
432 		_totalSupply += amount;
433 		tokenBalanceOf[this] += amount;
434 		allowed[this][owner] = tokenBalanceOf[this];
435 		allowed[this][supervisor] = tokenBalanceOf[this];
436 		tokenCreated(msg.sender, amount, "Additional metadollars created!");
437 	}
438 
439 	/// @notice Destroy an amount of metadollars
440 	/// @param amount - token to destroy
441 	function destroyToken(uint256 amount) isOwner {
442 		require(amount > 0);
443 		require(tokenBalanceOf[this] >= amount);
444 		require(_totalSupply >= amount);
445 		require(tokenBalanceOf[this] - amount >= 0);
446 		require(_totalSupply - amount >= 0);
447 		tokenBalanceOf[this] -= amount;
448 		_totalSupply -= amount;
449 		allowed[this][owner] = tokenBalanceOf[this];
450 		allowed[this][supervisor] = tokenBalanceOf[this];
451 		tokenDestroyed(msg.sender, amount, "An amount of metadollars destroyed!");
452 	}
453 
454 	/// @notice Transfer the ownership to another account
455 	/// @param newOwner - address who get the ownership
456 	function transferOwnership(address newOwner) isOwner {
457 		assert(newOwner != address(0));
458 		address oldOwner = owner;
459 		owner = newOwner;
460 		ownerChanged(msg.sender, oldOwner, newOwner);
461 		allowed[this][oldOwner] = 0;
462 		allowed[this][newOwner] = tokenBalanceOf[this];
463 	}
464 
465 	/// @notice Transfer ether from smartcontract to owner
466 	function collect() isOwner {
467         require(this.balance > 0);
468 		withdraw(this.balance);
469     }
470 
471 	/// @notice Withdraw an amount of ether
472 	/// @param summeInWei - amout to withdraw
473 	function withdraw(uint256 summeInWei) isOwner {
474 		uint256 contractbalance = this.balance;
475 		address sender = msg.sender;
476 		require(contractbalance >= summeInWei);
477 		withdrawed(sender, summeInWei, "wei withdrawed");
478         sender.transfer(summeInWei);
479 	}
480 
481 	/// @notice Deposit an amount of ether
482 	function deposit() payable isOwner {
483 		require(msg.value > 0);
484 		require(msg.sender.balance >= msg.value);
485 		deposited(msg.sender, msg.value, "wei deposited");
486 	}
487 
488 	/// @notice Allow user to exit ICO
489 	/// @param exitAllowed - status if the exit is allowed
490 	function allowIcoExit(bool exitAllowed) isOwner {
491 		require(icoExitIsPossible != exitAllowed);
492 		icoExitIsPossible = exitAllowed;
493 	}
494 
495 	/// @notice Stop running ICO
496 	/// @param icoIsStopped - status if this ICO is stopped
497 	function stopThisIco(bool icoIsStopped) isOwner {
498 		require(icoIsClosed != icoIsStopped);
499 		icoIsClosed = icoIsStopped;
500 		if(icoIsStopped) {
501 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
502 		}else {
503 			icoStatusUpdated(msg.sender, "Coin offering is running!");
504 		}
505 	}
506 
507 
508 	
509 }