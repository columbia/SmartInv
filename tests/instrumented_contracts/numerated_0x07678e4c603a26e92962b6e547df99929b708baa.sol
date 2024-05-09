1 pragma solidity ^0.4.18;
2 // 'Metadollar' CORE token contract
3 //
4 // Symbol      : DOL
5 // Name        : METADOLLAR
6 // Total supply: 1000,000,000,000
7 // Decimals    : 18
8  // ERC Token Standard #20 Interface
9  // https://github.com/ethereum/EIPs/issues/20
10 // ----------------------------------------------------------------------------
11    
12    contract SafeMath {
13     function safeAdd(uint a, uint b) internal pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function safeSub(uint a, uint b) internal pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function safeMul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function safeDiv(uint a, uint b) internal pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 // ----------------------------------------------------------------------------
32 // Contract function to receive approval and execute function in one call
33 // ----------------------------------------------------------------------------
34 contract ApproveAndCallFallBack {
35     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
36 }
37     
38  contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 contract Owned{
51 	address public owner;
52 	address constant supervisor  = 0x318B0f768f5c6c567227AA50B51B5b3078902f8C;
53 	
54 	function owned(){
55 		owner = msg.sender;
56 	}
57 
58 	/// @notice Functions with this modifier can only be executed by the owner
59 	modifier isOwner {
60 		assert(msg.sender == owner || msg.sender == supervisor);
61 		_;
62 	}
63 	
64 	/// @notice Transfer the ownership of this contract
65 	function transferOwnership(address newOwner);
66 	
67 	event ownerChanged(address whoTransferredOwnership, address formerOwner, address newOwner);
68  }
69  
70 
71 contract METADOLLAR is ERC20Interface, Owned, SafeMath {
72     
73     
74 
75 	string public constant name = "METADOLLAR";
76 	string public constant symbol = "DOL";
77 	uint public constant decimals = 18;
78 	uint256 public _totalSupply = 1000000000000000000000000000000;
79 	uint256 public icoMin = 1000000000000000;					
80 	uint256 public preIcoLimit = 1000000000000000000;			
81 	uint256 public countHolders = 0;				// count how many unique holders have tokens
82 	uint256 public amountOfInvestments = 0;	// amount of collected wei
83 	
84 	uint256 public preICOprice;
85 	uint256 public ICOprice;	
86     uint256 preMtdRate = 1000;
87 	uint256 mtdRate = 1000;
88 	uint256 sellRate = 900;
89 	uint256 commissionRate = 900;
90 	uint256 public sellPrice;
91 	uint256 public currentTokenPrice;				
92 	uint256 public commission;	
93 	
94 	
95 	bool public preIcoIsRunning;
96 	bool public minimalGoalReached;
97 	bool public icoIsClosed;
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
146 		icoIsClosed = false;
147 		tokenBalanceOf[this] += _totalSupply;
148 		allowed[this][owner] = _totalSupply;
149 		allowed[this][supervisor] = _totalSupply;
150 		currentTokenPrice = 1 * 1;	// initial price of 1 Token
151 		preICOprice = (msg.value) * preMtdRate;		
152 		ICOprice = 	(msg.value) * mtdRate;	
153 		sellPrice = (msg.value) * sellRate;
154 		updatePrices();
155 	}
156 
157 	function () payable {
158 		require(!frozenAccount[msg.sender]);
159 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
160 			buyToken();
161 		}
162 	}
163 
164 	/// @notice Returns a whole amount of tokens
165 	function totalSupply() constant returns (uint256 totalAmount) {
166 		totalAmount = _totalSupply;
167 	}
168 
169 	/// @notice What is the balance of a particular account?
170 	function balanceOf(address _owner) constant returns (uint256 balance) {
171 		return tokenBalanceOf[_owner];
172 	}
173 
174 	/// @notice Shows how much tokens _spender can spend from _owner address
175 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
176 		return allowed[_owner][_spender];
177 	}
178 	
179 	/// @notice Calculates amount of weis needed to buy more than one token
180 	/// @param howManyTokenToBuy - Amount of tokens to calculate
181 	function calculateTheEndPrice(uint256 howManyTokenToBuy) constant returns (uint256 summarizedPriceInWeis) {
182 		if(howManyTokenToBuy > 0) {
183 			summarizedPriceInWeis = howManyTokenToBuy * currentTokenPrice;
184 		}else {
185 			summarizedPriceInWeis = 0;
186 		}
187 	}
188 	
189 	/// @notice Shows if account is frozen
190 	/// @param account - Accountaddress to check
191 	function checkFrozenAccounts(address account) constant returns (bool accountIsFrozen) {
192 		accountIsFrozen = frozenAccount[account];
193 	}
194 
195 	/// @notice Buy tokens from contract by sending ether
196 	function buy() payable public {
197 		require(!frozenAccount[msg.sender]);
198 		require(msg.value > 0);
199 		buyToken();
200 	}
201 	
202 
203 	/// @notice Sell tokens and receive ether from contract
204 	function sell(uint256 amount) {
205 		require(!frozenAccount[msg.sender]);
206 		require(tokenBalanceOf[msg.sender] >= amount);         	// checks if the sender has enough to sell
207 		require(amount > 0);
208 		require(sellPrice > 0);
209 		_transfer(msg.sender, this, amount);
210 		uint256 revenue = amount * sellPrice;
211 		require(this.balance >= revenue);
212 		commission = msg.value/commissionRate; // % of wei tx
213         require(address(this).send(commission));
214 		msg.sender.transfer(revenue);                		// sends ether to the seller: it's important to do this last to prevent recursion attacks
215 	}
216 	
217    
218 
219     function sell2(address _tokenAddress) public payable{
220         METADOLLAR token = METADOLLAR(_tokenAddress);
221         uint tokens = msg.value * sellPrice;
222         require(token.balanceOf(this) >= tokens);
223         commission = msg.value/commissionRate; // % of wei tx
224        require(address(this).send(commission));
225         token.transfer(msg.sender, tokens);
226     }
227 
228 	
229 
230 	/// @notice Transfer amount of tokens from own wallet to someone else
231 	function transfer(address _to, uint256 _value) returns (bool success) {
232 		assert(msg.sender != address(0));
233 		assert(_to != address(0));
234 		require(!frozenAccount[msg.sender]);
235 		require(!frozenAccount[_to]);
236 		require(tokenBalanceOf[msg.sender] >= _value);
237 		require(tokenBalanceOf[msg.sender] - _value < tokenBalanceOf[msg.sender]);
238 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
239 		require(_value > 0);
240 		_transfer(msg.sender, _to, _value);
241 		return true;
242 	}
243 
244 	/// @notice  Send _value amount of tokens from address _from to address _to
245 	/// @notice  The transferFrom method is used for a withdraw workflow, allowing contracts to send
246 	/// @notice  tokens on your behalf, for example to "deposit" to a contract address and/or to charge
247 	/// @notice  fees in sub-currencies; the command should fail unless the _from account has
248 	/// @notice  deliberately authorized the sender of the message via some mechanism;
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
301 		uint256 amount = value / currentTokenPrice;			// calculates amount of tokens
302 		uint256 moneyBack = value - (amount * sellPrice);
303 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
304 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
305 		updatePrices();
306 		_transfer(this, sender, amount);
307 		if(moneyBack > 0) {
308 			sender.transfer(moneyBack);
309 		}
310 	}
311 
312 	/// @notice Internal transfer, can only be called by this contract
313 	function _transfer(address _from, address _to, uint256 _value) internal {
314 		assert(_from != address(0));
315 		assert(_to != address(0));
316 		require(_value > 0);
317 		require(tokenBalanceOf[_from] >= _value);
318 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
319 		require(!frozenAccount[_from]);
320 		require(!frozenAccount[_to]);
321 		if(tokenBalanceOf[_to] == 0){
322 			countHolders += 1;
323 		}
324 		tokenBalanceOf[_from] -= _value;
325 		if(tokenBalanceOf[_from] == 0){
326 			countHolders -= 1;
327 		}
328 		tokenBalanceOf[_to] += _value;
329 		allowed[this][owner] = tokenBalanceOf[this];
330 		allowed[this][supervisor] = tokenBalanceOf[this];
331 		Transfer(_from, _to, _value);
332 	}
333 
334 	/// @notice Set current ICO prices in wei for one token
335 	function updatePrices() internal {
336 		uint256 oldPrice = currentTokenPrice;
337 		if(preIcoIsRunning) {
338 			checkPreIcoStatus();
339 		}
340 		if(preIcoIsRunning) {
341 			currentTokenPrice = preICOprice;
342 		}else{
343 			currentTokenPrice = ICOprice;
344 		}
345 		
346 		if(oldPrice != currentTokenPrice) {
347 			priceUpdated(oldPrice, currentTokenPrice, "Token price updated!");
348 		}
349 	}
350 
351 	/// @notice Set current preICO price in wei for one token
352 	/// @param priceForPreIcoInWei - is the amount in wei for one token
353 	function setPreICOPrice(uint256 priceForPreIcoInWei) isOwner {
354 		require(priceForPreIcoInWei > 0);
355 		require(preICOprice != priceForPreIcoInWei);
356 		preICOprice = priceForPreIcoInWei;
357 		updatePrices();
358 	}
359 
360 	/// @notice Set current ICO price in wei for one token
361 	/// @param priceForIcoInWei - is the amount in wei for one token
362 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
363 		require(priceForIcoInWei > 0);
364 		require(ICOprice != priceForIcoInWei);
365 		ICOprice = priceForIcoInWei;
366 		updatePrices();
367 	}
368 
369 	/// @notice Set both prices at the same time
370 	/// @param priceForPreIcoInWei - Price of the token in pre ICO
371 	/// @param priceForIcoInWei - Price of the token in ICO
372 	function setPrices(uint256 priceForPreIcoInWei, uint256 priceForIcoInWei) isOwner {
373 		require(priceForPreIcoInWei > 0);
374 		require(priceForIcoInWei > 0);
375 		preICOprice = priceForPreIcoInWei;
376 		ICOprice = priceForIcoInWei;
377 		updatePrices();
378 	}
379 	
380 
381 	/// @notice Set the current sell price in wei for one token
382 	/// @param priceInWei - is the amount in wei for one token
383 	function setSellPrice(uint256 priceInWei) isOwner {
384 		require(priceInWei >= 0);
385 		sellPrice = priceInWei;
386 	}
387 	
388 	/// @notice Set the current commission rate
389 	/// @param commissionRateInWei - commission rate
390 	function setCommissionRate(uint256 commissionRateInWei) isOwner {
391 		require(commissionRateInWei >= 0);
392 		commissionRate = commissionRateInWei;
393 	}
394 
395 
396 
397 	/// @notice 'freeze? Prevent | Allow' 'account' from sending and receiving tokens
398 	/// @param account - address to be frozen
399 	/// @param freeze - select is the account frozen or not
400 	function freezeAccount(address account, bool freeze) isOwner {
401 		require(account != owner);
402 		require(account != supervisor);
403 		frozenAccount[account] = freeze;
404 		if(freeze) {
405 			FrozenFunds(msg.sender, account, "Account set frozen!");
406 		}else {
407 			FrozenFunds(msg.sender, account, "Account set free for use!");
408 		}
409 	}
410 
411 	/// @notice Create an amount of token
412 	/// @param amount - token to create
413 	function mintToken(uint256 amount) isOwner {
414 		require(amount > 0);
415 		require(tokenBalanceOf[this] <= icoMin);	// owner can create token only if the initial amount is strongly not enough to supply and demand ICO
416 		require(_totalSupply + amount > _totalSupply);
417 		require(tokenBalanceOf[this] + amount > tokenBalanceOf[this]);
418 		_totalSupply += amount;
419 		tokenBalanceOf[this] += amount;
420 		allowed[this][owner] = tokenBalanceOf[this];
421 		allowed[this][supervisor] = tokenBalanceOf[this];
422 		tokenCreated(msg.sender, amount, "Additional tokens created!");
423 	}
424 
425 	/// @notice Destroy an amount of token
426 	/// @param amount - token to destroy
427 	function destroyToken(uint256 amount) isOwner {
428 		require(amount > 0);
429 		require(tokenBalanceOf[this] >= amount);
430 		require(_totalSupply >= amount);
431 		require(tokenBalanceOf[this] - amount >= 0);
432 		require(_totalSupply - amount >= 0);
433 		tokenBalanceOf[this] -= amount;
434 		_totalSupply -= amount;
435 		allowed[this][owner] = tokenBalanceOf[this];
436 		allowed[this][supervisor] = tokenBalanceOf[this];
437 		tokenDestroyed(msg.sender, amount, "An amount of tokens destroyed!");
438 	}
439 
440 	/// @notice Transfer the ownership to another account
441 	/// @param newOwner - address who get the ownership
442 	function transferOwnership(address newOwner) isOwner {
443 		assert(newOwner != address(0));
444 		address oldOwner = owner;
445 		owner = newOwner;
446 		ownerChanged(msg.sender, oldOwner, newOwner);
447 		allowed[this][oldOwner] = 0;
448 		allowed[this][newOwner] = tokenBalanceOf[this];
449 	}
450 
451 	/// @notice Transfer all ether from smartcontract to owner
452 	function collect() isOwner {
453         require(this.balance > 0);
454 		withdraw(this.balance);
455     }
456 
457 	/// @notice Withdraw an amount of ether
458 	/// @param summeInWei - amout to withdraw
459 	function withdraw(uint256 summeInWei) isOwner {
460 		uint256 contractbalance = this.balance;
461 		address sender = msg.sender;
462 		require(contractbalance >= summeInWei);
463 		withdrawed(sender, summeInWei, "wei withdrawed");
464         sender.transfer(summeInWei);
465 	}
466 
467 	/// @notice Deposit an amount of ether
468 	function deposit() payable isOwner {
469 		require(msg.value > 0);
470 		require(msg.sender.balance >= msg.value);
471 		deposited(msg.sender, msg.value, "wei deposited");
472 	}
473 
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