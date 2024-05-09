1 pragma solidity ^0.4.16;
2 
3  // METADOLLAR (DOL) VAULT - COPYRIGHT 2018 METADOLLAR.ORG
4  // ERC Token Standard #20 Interface
5  // https://github.com/ethereum/EIPs/issues/20
6  
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeSub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function safeAdd(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c>=a && c>=b);
22     return c;
23   }
24 
25   function assert(bool assertion) internal {
26     if (!assertion) throw;
27   }
28 }
29 
30  contract ERC20Interface {
31 	/// @notice Total supply of Metadollar
32 	function totalSupply() constant returns (uint256 totalAmount);
33 
34 	/// @notice  Get the account balance of another account with address_owner
35 	function balanceOf(address _owner) constant returns (uint256 balance);
36 
37 	/// @notice  Send_value amount of tokens to address_to
38 	function transfer(address _to, uint256 _value) returns (bool success);
39 
40 	/// @notice  Send_value amount of tokens from address_from to address_to
41 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
42 
43 	/// @notice  Allow_spender to withdraw from your account, multiple times, up to the _value amount.
44 	/// @notice  If this function is called again it overwrites the current allowance with _value.
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
59 	address constant supervisor  = 0x97f7298435e5a8180747E89DBa7759674c5c35a5;
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
77 contract METADOLLAR is ERC20Interface, owned, SafeMath{
78 
79 	string public constant name = "METADOLLAR";
80 	string public constant symbol = "DOL";
81 	uint public constant decimals = 18;
82 	uint256 public _totalSupply = 1000000000000000000000000000;
83 	uint256 public icoMin = 1000000000000000000000000000;
84 	uint256 public preIcoLimit = 1000000000000000000000000000;
85 	uint256 public countHolders = 0;				// Number of DOL holders
86 	uint256 public amountOfInvestments = 0;	// amount of collected wei
87 	
88 	uint256 preICOprice;
89 	uint256 ICOprice;
90 	uint256 public currentTokenPrice;				// Current Price of DOL
91 	uint256 public commRate;
92 	bool public preIcoIsRunning;
93 	bool public minimalGoalReached;
94 	bool public icoIsClosed;
95 	bool icoExitIsPossible;
96 	
97 
98 	//Balances for each account
99 	mapping (address => uint256) public tokenBalanceOf;
100 
101 	// Owner of account approves the transfer of an amount to another account
102 	mapping(address => mapping (address => uint256)) allowed;
103 	
104 	//list with information about frozen accounts
105 	mapping(address => bool) frozenAccount;
106 	
107 	//this generate a public event on a blockchain that will notify clients
108 	event FrozenFunds(address initiator, address account, string status);
109 	
110 	//this generate a public event on a blockchain that will notify clients
111 	event BonusChanged(uint8 bonusOld, uint8 bonusNew);
112 	
113 	//this generate a public event on a blockchain that will notify clients
114 	event minGoalReached(uint256 minIcoAmount, string notice);
115 	
116 	//this generate a public event on a blockchain that will notify clients
117 	event preIcoEnded(uint256 preIcoAmount, string notice);
118 	
119 	//this generate a public event on a blockchain that will notify clients
120 	event priceUpdated(uint256 oldPrice, uint256 newPrice, string notice);
121 	
122 	//this generate a public event on a blockchain that will notify clients
123 	event withdrawed(address _to, uint256 summe, string notice);
124 	
125 	//this generate a public event on a blockchain that will notify clients
126 	event deposited(address _from, uint256 summe, string notice);
127 	
128 	//this generate a public event on a blockchain that will notify clients
129 	event orderToTransfer(address initiator, address _from, address _to, uint256 summe, string notice);
130 	
131 	//this generate a public event on a blockchain that will notify clients
132 	event tokenCreated(address _creator, uint256 summe, string notice);
133 	
134 	//this generate a public event on a blockchain that will notify clients
135 	event tokenDestroyed(address _destroyer, uint256 summe, string notice);
136 	
137 	//this generate a public event on a blockchain that will notify clients
138 	event icoStatusUpdated(address _initiator, string status);
139 
140 	/// @notice Constructor of the contract
141 	function METADOLLAR() {
142 		preIcoIsRunning = true;
143 		minimalGoalReached = true;
144 		icoExitIsPossible = false;
145 		icoIsClosed = false;
146 		tokenBalanceOf[this] += _totalSupply;
147 		allowed[this][owner] = _totalSupply;
148 		allowed[this][supervisor] = _totalSupply;
149 		currentTokenPrice = 1 * 1;
150 		preICOprice = 1 * 1;
151 		ICOprice = 1 * 1;
152 		commRate = 25;
153 		updatePrices();
154 	}
155 
156 	function () payable {
157 		require(!frozenAccount[msg.sender]);
158 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
159 			buyToken();
160 		}
161 	}
162 
163     	/// @notice Returns a whole amount of DOL
164 	function totalSupply() constant returns (uint256 totalAmount) {
165 		totalAmount = _totalSupply;
166 	}
167 
168 	/// @notice What is the balance of a particular account?
169 	function balanceOf(address _owner) constant returns (uint256 balance) {
170 		return tokenBalanceOf[_owner];
171 	}
172 
173 	/// @notice Shows how much tokens _spender can spend from _owner address
174 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
175 		return allowed[_owner][_spender];
176 	}
177 	
178 	/// @notice Calculates amount of ETH needed to buy DOL
179 	/// @param howManyTokenToBuy - Amount of tokens to calculate
180 	function calculateTheEndPrice(uint256 howManyTokenToBuy) constant returns (uint256 summarizedPriceInWeis) {
181 		if(howManyTokenToBuy > 0) {
182 			summarizedPriceInWeis = howManyTokenToBuy * currentTokenPrice;
183 		}else {
184 			summarizedPriceInWeis = 0;
185 		}
186 	}
187 	
188 	/// @notice Shows if account is frozen
189 	/// @param account - Accountaddress to check
190 	function checkFrozenAccounts(address account) constant returns (bool accountIsFrozen) {
191 		accountIsFrozen = frozenAccount[account];
192 	}
193 
194 	/// @notice Buy DOL from VAULT by sending ETH
195 	function buy() payable public {
196 		require(!frozenAccount[msg.sender]);
197 		require(msg.value > 0);
198 		buyToken();
199 	}
200 
201 	/// @notice Sell DOL and receive ETH from VAULT
202 	function sell(uint256 amount) {
203 		require(!frozenAccount[msg.sender]);
204 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
205 		require(amount > 0);
206 		require(currentTokenPrice > 0);
207 		_transfer(msg.sender, this, amount);
208 		uint256 revenue = amount * currentTokenPrice;
209 		uint256 detractSell = revenue / commRate;
210 		require(this.balance >= revenue);
211 		msg.sender.transfer(revenue - detractSell);  // sends ether to the seller: it's important to do this last to prevent recursion attacks
212 	}
213 	
214 	
215 	/// @notice Transfer amount of tokens from own wallet to someone else
216 	function transfer(address _to, uint256 _value) returns (bool success) {
217 		assert(msg.sender != address(0));
218 		assert(_to != address(0));
219 		require(!frozenAccount[msg.sender]);
220 		require(!frozenAccount[_to]);
221 		require(tokenBalanceOf[msg.sender] >= _value);
222 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
223 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
224 		require(_value > 0);
225 		_transfer(msg.sender, _to, _value);
226 		return true;
227 	}
228 
229 	/// @notice  Send _value amount of tokens from address _from to address _to
230 	function transferFrom(address _from,	address _to,	uint256 _value) returns (bool success) {
231 		assert(msg.sender != address(0));
232 		assert(_from != address(0));
233 		assert(_to != address(0));
234 		require(!frozenAccount[msg.sender]);
235 		require(!frozenAccount[_from]);
236 		require(!frozenAccount[_to]);
237 		require(tokenBalanceOf[_from] >= _value);
238 		require(allowed[_from][msg.sender] >= _value);
239 		require(tokenBalanceOf[_from] - _value < tokenBalanceOf[_from]);
240 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
241 		require(_value > 0);
242 		orderToTransfer(msg.sender, _from, _to, _value, "Order to transfer tokens from allowed account");
243 		_transfer(_from, _to, _value);
244 		allowed[_from][msg.sender] -= _value;
245 		return true;
246 	}
247 
248 	/// @notice Allow _spender to withdraw from your account, multiple times, up to the _value amount.
249 	/// @notice If this function is called again it overwrites the current allowance with _value.
250 	function approve(address _spender, uint256 _value) returns (bool success) {
251 		require(!frozenAccount[msg.sender]);
252 		assert(_spender != address(0));
253 		require(_value >= 0);
254 		allowed[msg.sender][_spender] = _value;
255 		return true;
256 	}
257 
258 	/// @notice Check if minimal goal is reached
259 	function checkMinimalGoal() internal {
260 		if(tokenBalanceOf[this] <= _totalSupply - icoMin) {
261 			minimalGoalReached = true;
262 			minGoalReached(icoMin, "Minimal goal of ICO is reached!");
263 		}
264 	}
265 
266 	/// @notice Check if service is ended
267 	function checkPreIcoStatus() internal {
268 		if(tokenBalanceOf[this] <= _totalSupply - preIcoLimit) {
269 			preIcoIsRunning = false;
270 			preIcoEnded(preIcoLimit, "Token amount for preICO sold!");
271 		}
272 	}
273 
274 	/// @notice Processing each buying
275 	function buyToken() internal {
276 		uint256 value = msg.value;
277 		address sender = msg.sender;
278 		require(!icoIsClosed);
279 		require(!frozenAccount[sender]);
280 		require(value > 0);
281 		require(currentTokenPrice > 0);
282 		uint256 amount = value / currentTokenPrice;	// calculates amount of tokens
283 		uint256 detract = amount / commRate;
284 		uint256 moneyBack = value - (amount * currentTokenPrice);
285 		uint256 detract2 = value / commRate;
286 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
287 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
288 		updatePrices();
289 		
290 		_transfer(this, sender, amount - detract);
291 		if(!minimalGoalReached) {
292 			checkMinimalGoal();
293 		}
294 		if(moneyBack > 0) {
295 			sender.transfer(moneyBack - detract2);
296 		}
297 	}
298 
299 	/// @notice Internal transfer, can only be called by this contract
300 	function _transfer(address _from, address _to, uint256 _value) internal {
301 		assert(_from != address(0));
302 		assert(_to != address(0));
303 		require(_value > 0);
304 		require(tokenBalanceOf[_from] >= _value);
305 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
306 		require(!frozenAccount[_from]);
307 		require(!frozenAccount[_to]);
308 		if(tokenBalanceOf[_to] == 0){
309 			countHolders += 1;
310 		}
311 		tokenBalanceOf[_from] -= _value;
312 		if(tokenBalanceOf[_from] == 0){
313 			countHolders -= 1;
314 		}
315 		tokenBalanceOf[_to] += _value;
316 		allowed[this][owner] = tokenBalanceOf[this];
317 		allowed[this][supervisor] = tokenBalanceOf[this];
318 		Transfer(_from, _to, _value);
319 	}
320 
321 	/// @notice Set current DOL prices
322 	function updatePrices() internal {
323 		uint256 oldPrice = currentTokenPrice;
324 		if(preIcoIsRunning) {
325 			checkPreIcoStatus();
326 		}
327 		if(preIcoIsRunning) {
328 			currentTokenPrice = preICOprice;
329 		}else{
330 			currentTokenPrice = ICOprice;
331 		}
332 		
333 		if(oldPrice != currentTokenPrice) {
334 			priceUpdated(oldPrice, currentTokenPrice, "Token price updated!");
335 		}
336 	}
337 
338     /// @notice Set current  price rate A
339 	/// @param priceForPreIcoInWei - is the amount in wei for one token
340 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
341 		require(priceForPreIcoInWei > 0);
342 		require(preICOprice != priceForPreIcoInWei);
343 		preICOprice = priceForPreIcoInWei;
344 		updatePrices();
345 	}
346 
347 	/// @notice Set current price rate B
348 	/// @param priceForIcoInWei - is the amount in wei for one token
349 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
350 		require(priceForIcoInWei > 0);
351 		require(ICOprice != priceForIcoInWei);
352 		ICOprice = priceForIcoInWei;
353 		updatePrices();
354 	}
355 
356 	/// @notice Set both prices at the same time
357 	/// @param priceForPreIcoInWei - Price of the token in pre ICO
358 	/// @param priceForIcoInWei - Price of the token in ICO
359 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
360 		require(priceForPreIcoInWei > 0);
361 		require(priceForIcoInWei > 0);
362 		preICOprice = priceForPreIcoInWei;
363 		ICOprice = priceForIcoInWei;
364 		updatePrices();
365 	}
366 	
367 	/// @notice Set current Commission Rate
368 	/// @param newCommRate - is the amount in wei for one token
369 	function commRate(uint256 newCommRate) isOwner {
370 		require(newCommRate > 0);
371 		require(commRate != newCommRate);
372 		commRate = newCommRate;
373 		updatePrices();
374 	}
375 
376 
377 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving tokens
378 	/// @param account - address to be frozen
379 	/// @param freeze - select is the account frozen or not
380 	function freezeAccount(address account, bool freeze) isOwner {
381 		require(account != owner);
382 		require(account != supervisor);
383 		frozenAccount[account] = freeze;
384 		if(freeze) {
385 			FrozenFunds(msg.sender, account, "Account set frozen!");
386 		}else {
387 			FrozenFunds(msg.sender, account, "Account set free for use!");
388 		}
389 	}
390 
391 	/// @notice Create an amount of DOL
392 	/// @param amount - DOL to create
393 	function mintToken(uint256 amount) isOwner {
394 		require(amount > 0);
395 		require(tokenBalanceOf[this] <= icoMin);	// owner can create token only if the initial amount is strongly not enough to supply and demand ICO
396 		require(_totalSupply + amount > _totalSupply);
397 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
398 		_totalSupply += amount;
399 		tokenBalanceOf[this] += amount;
400 		allowed[this][owner] = tokenBalanceOf[this];
401 		allowed[this][supervisor] = tokenBalanceOf[this];
402 		tokenCreated(msg.sender, amount, "Additional tokens created!");
403 	}
404 
405 	/// @notice Destroy an amount of DOL
406 	/// @param amount - DOL to destroy
407 	function destroyToken(uint256 amount) isOwner {
408 		require(amount > 0);
409 		require(tokenBalanceOf[this] >= amount);
410 		require(_totalSupply >= amount);
411 		require(tokenBalanceOf[this] - amount >= 0);
412 		require(_totalSupply - amount >= 0);
413 		tokenBalanceOf[this] -= amount;
414 		_totalSupply -= amount;
415 		allowed[this][owner] = tokenBalanceOf[this];
416 		allowed[this][supervisor] = tokenBalanceOf[this];
417 		tokenDestroyed(msg.sender, amount, "An amount of tokens destroyed!");
418 	}
419 
420 	/// @notice Transfer the ownership to another account
421 	/// @param newOwner - address who get the ownership
422 	function transferOwnership(address newOwner) isOwner {
423 		assert(newOwner != address(0));
424 		address oldOwner = owner;
425 		owner = newOwner;
426 		ownerChanged(msg.sender, oldOwner, newOwner);
427 		allowed[this][oldOwner] = 0;
428 		allowed[this][newOwner] = tokenBalanceOf[this];
429 	}
430 
431 	/// @notice Transfer ether from smartcontract to admin
432 	function collect() isOwner {
433         require(this.balance > 0);
434 		withdraw(this.balance);
435     }
436 
437 	/// @notice Withdraw an amount of ether from VAULT
438 	/// @param summeInWei - amout to withdraw
439 	function withdraw(uint256 summeInWei) isOwner {
440 		uint256 contractbalance = this.balance;
441 		address sender = msg.sender;
442 		require(contractbalance >= summeInWei);
443 		withdrawed(sender, summeInWei, "wei withdrawed");
444         sender.transfer(summeInWei);
445 	}
446 
447 	/// @notice Deposit an amount of ETH in the VAULT
448 	function deposit() payable isOwner {
449 		require(msg.value > 0);
450 		require(msg.sender.balance >= msg.value);
451 		deposited(msg.sender, msg.value, "wei deposited");
452 	}
453 
454 
455 	/// @notice Stop running VAULT
456 	/// @param icoIsStopped - status if this ICO is stopped
457 	function stopThisIco(bool icoIsStopped) isOwner {
458 		require(icoIsClosed != icoIsStopped);
459 		icoIsClosed = icoIsStopped;
460 		if(icoIsStopped) {
461 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
462 		}else {
463 			icoStatusUpdated(msg.sender, "Coin offering is running!");
464 		}
465 	}
466 
467 }