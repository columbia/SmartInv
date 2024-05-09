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
80 	uint256 public icoLimit = 1000000000000000000000000000000;			
81 	uint256 public countHolders = 0;				// count how many unique holders have tokens
82 	uint256 public amountOfInvestments = 0;	// amount of collected wei
83 	
84 	
85 	uint256 public icoPrice;	
86 	uint256 public dolRate = 1000;
87 	uint256 public ethRate = 1;
88 	uint256 public sellRate = 900;
89 	uint256 public commissionRate = 1000;
90 	uint256 public sellPrice;
91 	uint256 public currentTokenPrice;				
92 	uint256 public commission;	
93 	
94 	
95 	bool public icoIsRunning;
96 	bool public minimalGoalReached;
97 	bool public icoIsClosed;
98 
99 	//Balances for each account
100 	mapping (address => uint256) public tokenBalanceOf;
101 
102 	// Owner of account approves the transfer of an amount to another account
103 	mapping(address => mapping (address => uint256)) allowed;
104 	
105 	//list with information about frozen accounts
106 	mapping(address => bool) frozenAccount;
107 	
108 	//this generate a public event on a blockchain that will notify clients
109 	event FrozenFunds(address initiator, address account, string status);
110 	
111 	//this generate a public event on a blockchain that will notify clients
112 	event BonusChanged(uint8 bonusOld, uint8 bonusNew);
113 	
114 	//this generate a public event on a blockchain that will notify clients
115 	event minGoalReached(uint256 minIcoAmount, string notice);
116 	
117 	//this generate a public event on a blockchain that will notify clients
118 	event preIcoEnded(uint256 preIcoAmount, string notice);
119 	
120 	//this generate a public event on a blockchain that will notify clients
121 	event priceUpdated(uint256 oldPrice, uint256 newPrice, string notice);
122 	
123 	//this generate a public event on a blockchain that will notify clients
124 	event withdrawed(address _to, uint256 summe, string notice);
125 	
126 	//this generate a public event on a blockchain that will notify clients
127 	event deposited(address _from, uint256 summe, string notice);
128 	
129 	//this generate a public event on a blockchain that will notify clients
130 	event orderToTransfer(address initiator, address _from, address _to, uint256 summe, string notice);
131 	
132 	//this generate a public event on a blockchain that will notify clients
133 	event tokenCreated(address _creator, uint256 summe, string notice);
134 	
135 	//this generate a public event on a blockchain that will notify clients
136 	event tokenDestroyed(address _destroyer, uint256 summe, string notice);
137 	
138 	//this generate a public event on a blockchain that will notify clients
139 	event icoStatusUpdated(address _initiator, string status);
140 
141 	/// @notice Constructor of the contract
142 	function STARTMETADOLLAR() {
143 		icoIsRunning = true;
144 		minimalGoalReached = false;
145 		icoIsClosed = false;
146 		tokenBalanceOf[this] += _totalSupply;
147 		allowed[this][owner] = _totalSupply;
148 		allowed[this][supervisor] = _totalSupply;
149 		currentTokenPrice = 1 * 1;	// initial price of 1 Token
150 		icoPrice = ethRate * dolRate;		
151 		sellPrice = sellRate * ethRate;
152 		updatePrices();
153 	}
154 
155 	function () payable {
156 		require(!frozenAccount[msg.sender]);
157 		if(msg.value > 0 && !frozenAccount[msg.sender]) {
158 			buyToken();
159 		}
160 	}
161 
162 	/// @notice Returns a whole amount of tokens
163 	function totalSupply() constant returns (uint256 totalAmount) {
164 		totalAmount = _totalSupply;
165 	}
166 
167 	/// @notice What is the balance of a particular account?
168 	function balanceOf(address _owner) constant returns (uint256 balance) {
169 		return tokenBalanceOf[_owner];
170 	}
171 
172 	/// @notice Shows how much tokens _spender can spend from _owner address
173 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
174 		return allowed[_owner][_spender];
175 	}
176 	
177 	/// @notice Calculates amount of weis needed to buy more than one token
178 	/// @param howManyTokenToBuy - Amount of tokens to calculate
179 	function calculateTheEndPrice(uint256 howManyTokenToBuy) constant returns (uint256 summarizedPriceInWeis) {
180 		if(howManyTokenToBuy > 0) {
181 			summarizedPriceInWeis = howManyTokenToBuy * currentTokenPrice;
182 		}else {
183 			summarizedPriceInWeis = 0;
184 		}
185 	}
186 	
187 	/// @notice Shows if account is frozen
188 	/// @param account - Accountaddress to check
189 	function checkFrozenAccounts(address account) constant returns (bool accountIsFrozen) {
190 		accountIsFrozen = frozenAccount[account];
191 	}
192 
193 	/// @notice Buy tokens from contract by sending ether
194 	function buy() payable public {
195 		require(!frozenAccount[msg.sender]);
196 		require(msg.value > 0);
197 		commission = msg.value/commissionRate; // % of wei tx
198         require(address(this).send(commission));
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
285 	/// @notice Check if ICO is ended
286 	function checkIcoStatus() internal {
287 		if(tokenBalanceOf[this] <= _totalSupply - icoLimit) {
288 			icoIsRunning = false;
289 		}
290 	}
291 
292 	/// @notice Processing each buying
293 	function buyToken() internal {
294 		uint256 value = msg.value;
295 		address sender = msg.sender;
296 		require(!icoIsClosed);
297 		require(!frozenAccount[sender]);
298 		require(value > 0);
299 		require(currentTokenPrice > 0);
300 		uint256 amount = value / currentTokenPrice;			// calculates amount of tokens
301 		uint256 moneyBack = value - (amount * sellPrice);
302 		require(tokenBalanceOf[this] >= amount);              		// checks if contract has enough to sell
303 		amountOfInvestments = amountOfInvestments + (value - moneyBack);
304 		updatePrices();
305 		_transfer(this, sender, amount);
306 		if(moneyBack > 0) {
307 			sender.transfer(moneyBack);
308 		}
309 	}
310 
311 	/// @notice Internal transfer, can only be called by this contract
312 	function _transfer(address _from, address _to, uint256 _value) internal {
313 		assert(_from != address(0));
314 		assert(_to != address(0));
315 		require(_value > 0);
316 		require(tokenBalanceOf[_from] >= _value);
317 		require(tokenBalanceOf[_to] + _value > tokenBalanceOf[_to]);
318 		require(!frozenAccount[_from]);
319 		require(!frozenAccount[_to]);
320 		if(tokenBalanceOf[_to] == 0){
321 			countHolders += 1;
322 		}
323 		tokenBalanceOf[_from] -= _value;
324 		if(tokenBalanceOf[_from] == 0){
325 			countHolders -= 1;
326 		}
327 		tokenBalanceOf[_to] += _value;
328 		allowed[this][owner] = tokenBalanceOf[this];
329 		allowed[this][supervisor] = tokenBalanceOf[this];
330 		Transfer(_from, _to, _value);
331 	}
332 
333 	/// @notice Set current ICO prices in wei for one token
334 	function updatePrices() internal {
335 		uint256 oldPrice = currentTokenPrice;
336 		if(icoIsRunning) {
337 			checkIcoStatus();
338 		}
339 		if(icoIsRunning) {
340 			currentTokenPrice = icoPrice;
341 		}else{
342 			currentTokenPrice = icoPrice;
343 		}
344 		
345 		if(oldPrice != currentTokenPrice) {
346 			priceUpdated(oldPrice, currentTokenPrice, "Token price updated!");
347 		}
348 	}
349 
350 	/// @notice Set current ICO price in wei for one token
351 	/// @param priceForIcoInWei - is the amount in wei for one token
352 	function setICOPrice(uint256 priceForIcoInWei) isOwner {
353 		require(priceForIcoInWei > 0);
354 		require(icoPrice != priceForIcoInWei);
355 		icoPrice = priceForIcoInWei;
356 		updatePrices();
357 	}
358 
359 	
360 
361 	/// @notice Set the current sell price in wei for one token
362 	/// @param priceInWei - is the amount in wei for one token
363 	function setSellRate(uint256 priceInWei) isOwner {
364 		require(priceInWei >= 0);
365 		sellRate = priceInWei;
366 	}
367 	
368 	/// @notice Set the current commission rate
369 	/// @param commissionRateInWei - commission rate
370 	function setCommissionRate(uint256 commissionRateInWei) isOwner {
371 		require(commissionRateInWei >= 0);
372 		commissionRate = commissionRateInWei;
373 	}
374 	
375 	/// @notice Set the current DOL rate in wei for one eth
376 	/// @param dolInWei - is the amount in wei for one ETH
377 	function setDolRate(uint256 dolInWei) isOwner {
378 		require(dolInWei >= 0);
379 		dolRate = dolInWei;
380 	}
381 	
382 	/// @notice Set the current ETH rate in wei for one DOL
383 	/// @param ethInWei - is the amount in wei for one DOL
384 	function setEthRate(uint256 ethInWei) isOwner {
385 		require(ethInWei >= 0);
386 		ethRate = ethInWei;
387 	}
388 
389 
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
445 	/// @notice Transfer all ether from smartcontract to owner
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
468 
469 	/// @notice Stop running ICO
470 	/// @param icoIsStopped - status if this ICO is stopped
471 	function stopThisIco(bool icoIsStopped) isOwner {
472 		require(icoIsClosed != icoIsStopped);
473 		icoIsClosed = icoIsStopped;
474 		if(icoIsStopped) {
475 			icoStatusUpdated(msg.sender, "Coin offering was stopped!");
476 		}else {
477 			icoStatusUpdated(msg.sender, "Coin offering is running!");
478 		}
479 	}
480 
481 }