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
59 	uint256 public _totalSupply = 1000000000000000000000000000000;  // Total Supply 100,000,000,000
60 	uint256 public icoMin = 1000000000000000000000000000000;				 //  Min ICO 100,000,000	
61 	uint256 public preIcoLimit = 1000000000000000000;		 // Pre Ico Limit 1
62 	uint256 public countHolders = 0;				// count how many unique holders have metadollars
63 	uint256 public amountOfInvestments = 0;	// amount of collected wei
64 	
65 	uint256 preICOprice;									// price of 1 metadollar in weis for the preICO time
66 	uint256 ICOprice;										// price of 1 metadollar in weis for the ICO time
67 	uint256 public currentTokenPrice;				// current metadollar price in weis
68 	uint256 public sellPrice;								// buyback price of one metadollar in weis
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
119 	function STARTMETADOLLAR() {
120 		preIcoIsRunning = true;
121 		minimalGoalReached = false;
122 		icoExitIsPossible = false;
123 		icoIsClosed = false;
124 		tokenBalanceOf[this] += _totalSupply;
125 		allowed[this][owner] = _totalSupply;
126 		allowed[this][supervisor] = _totalSupply;
127 		currentTokenPrice = 1 * 1000 ether;	// initial price of 1 metadollar
128 		preICOprice = 1 * 1000 ether; 			// price of 1 metadollar in weis for the preICO time 
129 		ICOprice = 1 * 1000 ether;				// price of 1 metadollar in weis for the ICO time
130 		sellPrice = 1 * 950 ether;
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
141 	/// @notice Returns a whole amount of metadollars
142 	function totalSupply() constant returns (uint256 totalAmount) {
143 		totalAmount = _totalSupply;
144 	}
145 
146 	/// @notice What is the balance of a particular account?
147 	function balanceOf(address _owner) constant returns (uint256 balance) {
148 		return tokenBalanceOf[_owner];
149 	}
150 
151 	/// @notice Shows how much metadollars _spender can spend from _owner address
152 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
153 		return allowed[_owner][_spender];
154 	}
155 	
156 	/// @notice Calculates amount of weis needed to buy more than one metadollar
157 	/// @param howManyTokenToBuy - Amount of metadollars to calculate
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
172 	/// @notice Buy metadollars from contract by sending ether
173 	function buy() payable public {
174 		require(!frozenAccount[msg.sender]);
175 		require(msg.value > 0);
176 		buyToken();
177 	}
178 
179 	/// @notice Sell metadollars and receive ether from contract
180 	function sell(uint256 amount) {
181 		require(!frozenAccount[msg.sender]);
182 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
183 		require(amount > 0);
184 		require(sellPrice > 0);
185 		_transfer(msg.sender, this, amount);
186 		uint256 revenue = amount * sellPrice;
187 		msg.sender.transfer(revenue);         // sends ether to the seller: it's important to do this last to prevent recursion attacks
188 	}
189 	
190 	/// @notice Allow user to sell maximum possible amount of metadollars, depend on ether amount on contract
191 	function sellMaximumPossibleAmountOfTokens() {
192 		require(!frozenAccount[msg.sender]);
193 		require(tokenBalanceOf[msg.sender] > 0);
194 		require(this.balance > sellPrice);
195 		if(tokenBalanceOf[msg.sender] * sellPrice <= this.balance) {
196 			sell(tokenBalanceOf[msg.sender]);
197 		}else {
198 			sell(this.balance / sellPrice);
199 		}
200 	}
201 
202 	/// @notice Transfer amount of metadollars from own wallet to someone else
203 	function transfer(address _to, uint256 _value) returns (bool success) {
204 		assert(msg.sender != address(0));
205 		assert(_to != address(0));
206 		require(!frozenAccount[msg.sender]);
207 		require(!frozenAccount[_to]);
208 		require(tokenBalanceOf[msg.sender] >= _value);
209 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
210 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
211 		require(_value > 0);
212 		_transfer(msg.sender, _to, _value);
213 		return true;
214 	}
215 
216 	/// @notice  Send _value amount of metadollars from address _from to address _to
217 	/// @notice  The transferFrom method is used for a withdraw workflow, allowing contracts to send
218 	/// @notice  tokens on your behalf, for example to "deposit" to a contract address and/or to charge
219 	/// @notice  fees in sub-currencies; the command should fail unless the _from account has
220 	/// @notice  deliberately authorized the sender of the message via some mechanism; we propose
221 	/// @notice  these standardized APIs for approval:
222 	function transferFrom(address _from,	address _to,	uint256 _value) returns (bool success) {
223 		assert(msg.sender != address(0));
224 		assert(_from != address(0));
225 		assert(_to != address(0));
226 		require(!frozenAccount[msg.sender]);
227 		require(!frozenAccount[_from]);
228 		require(!frozenAccount[_to]);
229 		require(tokenBalanceOf[_from] >= _value);
230 		require(allowed[_from][msg.sender] >= _value);
231 		require(tokenBalanceOf[_from] - _value < tokenBalanceOf[_from]);
232 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
233 		require(_value > 0);
234 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer metadollars from allowed account");
235 		_transfer(_from, _to, _value);
236 		allowed[_from][msg.sender] -= _value;
237 		return true;
238 	}
239 
240 	/// @notice Allow _spender to withdraw from your account, multiple times, up to the _value amount.
241 	/// @notice If this function is called again it overwrites the current allowance with _value.
242 	function approve(address _spender, uint256 _value) returns (bool success) {
243 		require(!frozenAccount[msg.sender]);
244 		assert(_spender != address(0));
245 		require(_value >= 0);
246 		allowed[msg.sender][_spender] = _value;
247 		return true;
248 	}
249 
250 	/// @notice Check if minimal goal of ICO is reached
251 	function checkMinimalGoal() internal {
252 		if(tokenBalanceOf[this] <= _totalSupply - icoMin) {
253 			minimalGoalReached = true;
254 			minGoalReached(icoMin, "Minimal goal of ICO is reached!");
255 		}
256 	}
257 
258 	/// @notice Check if preICO is ended
259 	function checkPreIcoStatus() internal {
260 		if(tokenBalanceOf[this] <= _totalSupply - preIcoLimit) {
261 			preIcoIsRunning = false;
262 			preIcoEnded(preIcoLimit, "Token amount for preICO sold!");
263 		}
264 	}
265 
266 	/// @notice Processing each buying
267 	function buyToken() internal {
268 		uint256 value = msg.value;
269 		address sender = msg.sender;
270 		require(!icoIsClosed);
271 		require(!frozenAccount[sender]);
272 		require(value > 0);
273 		require(currentTokenPrice > 0);
274 		uint256 amount = value / currentTokenPrice;			// calculates amount of metadollars
275 		uint256 moneyBack = value - (amount * currentTokenPrice);
276 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
277 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
278 		updatePrices();
279 		_transfer(this, sender, amount);
280 		if(!minimalGoalReached) {
281 			checkMinimalGoal();
282 		}
283 		if(moneyBack > 0) {
284 			sender.transfer(moneyBack);
285 		}
286 	}
287 
288 	/// @notice Internal transfer, can only be called by this contract
289 	function _transfer(address _from, address _to, uint256 _value) internal {
290 		assert(_from != address(0));
291 		assert(_to != address(0));
292 		require(_value > 0);
293 		require(tokenBalanceOf[_from] >= _value);
294 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
295 		require(!frozenAccount[_from]);
296 		require(!frozenAccount[_to]);
297 		if(tokenBalanceOf[_to] == 0){
298 			countHolders += 1;
299 		}
300 		tokenBalanceOf[_from] -= _value;
301 		if(tokenBalanceOf[_from] == 0){
302 			countHolders -= 1;
303 		}
304 		tokenBalanceOf[_to] += _value;
305 		allowed[this][owner] = tokenBalanceOf[this];
306 		allowed[this][supervisor] = tokenBalanceOf[this];
307 		Transfer(_from, _to, _value);
308 	}
309 
310 	/// @notice Set current ICO prices in wei for one metadollar
311 	function updatePrices() internal {
312 		uint256 oldPrice = currentTokenPrice;
313 		if(preIcoIsRunning) {
314 			checkPreIcoStatus();
315 		}
316 		if(preIcoIsRunning) {
317 			currentTokenPrice = preICOprice;
318 		}else{
319 			currentTokenPrice = ICOprice;
320 		}
321 		
322 		if(oldPrice != currentTokenPrice) {
323 			priceUpdated(oldPrice, currentTokenPrice, "Metadollar price updated!");
324 		}
325 	}
326 
327 	/// @notice Set current preICO price in wei for one metadollar
328 	/// @param priceForPreIcoInWei - is the amount in wei for one metadollar
329 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
330 		require(priceForPreIcoInWei > 0);
331 		require(preICOprice != priceForPreIcoInWei);
332 		preICOprice = priceForPreIcoInWei;
333 		updatePrices();
334 	}
335 	
336 
337 	/// @notice Set current ICO price price in wei for one metadollar
338 	/// @param priceForIcoInWei - is the amount in wei
339 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
340 		require(priceForIcoInWei > 0);
341 		require(ICOprice != priceForIcoInWei);
342 		ICOprice = priceForIcoInWei;
343 		updatePrices();
344 	}
345 	
346 	
347 
348 	/// @notice Set both prices at the same time
349 	/// @param priceForPreIcoInWei - Price of the metadollar in pre ICO
350 	/// @param priceForIcoInWei - Price of the metadollar in ICO
351 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
352 		require(priceForPreIcoInWei > 0);
353 		require(priceForIcoInWei > 0);
354 		preICOprice = priceForPreIcoInWei;
355 		ICOprice = priceForIcoInWei;
356 		updatePrices();
357 	}
358 	
359 	
360 
361 	/// @notice Set the current sell price in wei for one metadollar
362 	/// @param priceInWei - is the amount in wei for one metadollar
363 	function setSellPrice(uint256 priceInWei) isOwner {
364 		require(priceInWei >= 0);
365 		sellPrice = priceInWei;
366 	}
367 
368 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving metadollars
369 	/// @param account - address to be frozen
370 	/// @param freeze - select is the account frozen or not
371 	function freezeAccount(address account, bool freeze) isOwner {
372 		require(account != owner);
373 		require(account != supervisor);
374 		frozenAccount[account] = freeze;
375 		if(freeze) {
376 			FrozenFunds(msg.sender, account, "Account set frozen!");
377 		}else {
378 			FrozenFunds(msg.sender, account, "Account set free for use!");
379 		}
380 	}
381 
382 	/// @notice Create an amount of metadollars
383 	/// @param amount - metadollars to create
384 	function mintToken(uint256 amount) isOwner {
385 		require(amount > 0);
386 		require(tokenBalanceOf[this] <= icoMin);	// owner can create metadollars only if the initial amount is strongly not enough to supply and demand ICO
387 		require(_totalSupply + amount > _totalSupply);
388 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
389 		_totalSupply += amount;
390 		tokenBalanceOf[this] += amount;
391 		allowed[this][owner] = tokenBalanceOf[this];
392 		allowed[this][supervisor] = tokenBalanceOf[this];
393 		tokenCreated(msg.sender, amount, "Additional metadollars created!");
394 	}
395 
396 	/// @notice Destroy an amount of metadollars
397 	/// @param amount - token to destroy
398 	function destroyToken(uint256 amount) isOwner {
399 		require(amount > 0);
400 		require(tokenBalanceOf[this] >= amount);
401 		require(_totalSupply >= amount);
402 		require(tokenBalanceOf[this] - amount >= 0);
403 		require(_totalSupply - amount >= 0);
404 		tokenBalanceOf[this] -= amount;
405 		_totalSupply -= amount;
406 		allowed[this][owner] = tokenBalanceOf[this];
407 		allowed[this][supervisor] = tokenBalanceOf[this];
408 		tokenDestroyed(msg.sender, amount, "An amount of metadollars destroyed!");
409 	}
410 
411 	/// @notice Transfer the ownership to another account
412 	/// @param newOwner - address who get the ownership
413 	function transferOwnership(address newOwner) isOwner {
414 		assert(newOwner != address(0));
415 		address oldOwner = owner;
416 		owner = newOwner;
417 		ownerChanged(msg.sender, oldOwner, newOwner);
418 		allowed[this][oldOwner] = 0;
419 		allowed[this][newOwner] = tokenBalanceOf[this];
420 	}
421 
422 	/// @notice Transfer ether from smartcontract to owner
423 	function collect() isOwner {
424         require(this.balance > 0);
425 		withdraw(this.balance);
426     }
427 
428 	/// @notice Withdraw an amount of ether
429 	/// @param summeInWei - amout to withdraw
430 	function withdraw(uint256 summeInWei) isOwner {
431 		uint256 contractbalance = this.balance;
432 		address sender = msg.sender;
433 		require(contractbalance >= summeInWei);
434 		withdrawed(sender, summeInWei, "wei withdrawed");
435         sender.transfer(summeInWei);
436 	}
437 
438 	/// @notice Deposit an amount of ether
439 	function deposit() payable isOwner {
440 		require(msg.value > 0);
441 		require(msg.sender.balance >= msg.value);
442 		deposited(msg.sender, msg.value, "wei deposited");
443 	}
444 
445 	/// @notice Allow user to exit ICO
446 	/// @param exitAllowed - status if the exit is allowed
447 	function allowIcoExit(bool exitAllowed) isOwner {
448 		require(icoExitIsPossible != exitAllowed);
449 		icoExitIsPossible = exitAllowed;
450 	}
451 
452 	/// @notice Stop running ICO
453 	/// @param icoIsStopped - status if this ICO is stopped
454 	function stopThisIco(bool icoIsStopped) isOwner {
455 		require(icoIsClosed != icoIsStopped);
456 		icoIsClosed = icoIsStopped;
457 		if(icoIsStopped) {
458 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
459 		}else {
460 			icoStatusUpdated(msg.sender, "Coin offering is running!");
461 		}
462 	}
463 
464 	/// @notice Sell all metadollars for half of a price and exit this ICO
465 	function exitThisIcoForHalfOfTokenPrice() {
466 		require(icoExitIsPossible);
467 		require(!frozenAccount[msg.sender]);
468 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
469 		require(currentTokenPrice > 1);
470 		uint256 amount = tokenBalanceOf[msg.sender] ;
471 		uint256 revenue = amount * currentTokenPrice / 2;
472 		require(this.balance >= revenue);
473 		_transfer(msg.sender, this, amount);
474 		msg.sender.transfer(revenue);                	// sends ether to the seller: it's important to do this last to prevent recursion attacks
475 	}
476 
477 	/// @notice Sell all of metadollars for all ether of this smartcontract
478 	function getAllMyTokensForAllEtherOnContract() {
479 		require(icoExitIsPossible);
480 		require(!frozenAccount[msg.sender]);
481 		require(tokenBalanceOf[msg.sender] > 0);         	// checks if the sender has enough to sell
482 		require(currentTokenPrice > 1);
483 		uint256 amount = tokenBalanceOf[msg.sender] ;
484 		uint256 revenue = amount * currentTokenPrice / 2;
485 		require(this.balance <= revenue);
486 		_transfer(msg.sender, this, amount);
487 		msg.sender.transfer(this.balance); 
488 	}
489 }