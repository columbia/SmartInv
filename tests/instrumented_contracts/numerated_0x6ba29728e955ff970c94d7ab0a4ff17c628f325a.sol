1 /**
2  * The edgeless casino contract v2 holds the players's funds and provides state channel functionality.
3  * The casino has at no time control over the players's funds.
4  * State channels can be updated and closed from both parties: the player and the casino.
5  * author: Julia Altenried
6  **/
7 
8 pragma solidity ^0.4.19;
9 
10 contract SafeMath {
11 
12 	function safeSub(uint a, uint b) pure internal returns(uint) {
13 		assert(b <= a);
14 		return a - b;
15 	}
16 	
17 	function safeSub(int a, int b) pure internal returns(int) {
18 		if(b < 0) assert(a - b > a);
19 		else assert(a - b <= a);
20 		return a - b;
21 	}
22 
23 	function safeAdd(uint a, uint b) pure internal returns(uint) {
24 		uint c = a + b;
25 		assert(c >= a && c >= b);
26 		return c;
27 	}
28 
29 	function safeMul(uint a, uint b) pure internal returns (uint) {
30     uint c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 }
35 
36 contract Token {
37 	function transferFrom(address sender, address receiver, uint amount) public returns(bool success) {}
38 
39 	function transfer(address receiver, uint amount) public returns(bool success) {}
40 
41 	function balanceOf(address holder) public constant returns(uint) {}
42 }
43 
44 contract owned {
45   address public owner;
46   modifier onlyOwner {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   function owned() public{
52     owner = msg.sender;
53   }
54 
55 }
56 
57 /** owner should be able to close the contract is nobody has been using it for at least 30 days */
58 contract mortal is owned {
59 	/** contract can be closed by the owner anytime after this timestamp if non-zero */
60 	uint public closeAt;
61 	/** the edgeless token contract */
62 	Token edg;
63 	
64 	function mortal(address tokenContract) internal{
65 		edg = Token(tokenContract);
66 	}
67 	/**
68 	* lets the owner close the contract if there are no player funds on it or if nobody has been using it for at least 30 days
69 	*/
70   function closeContract(uint playerBalance) internal{
71 		if(closeAt == 0) closeAt = now + 30 days;
72 		if(closeAt < now || playerBalance == 0){
73 			edg.transfer(owner, edg.balanceOf(address(this)));
74 			selfdestruct(owner);
75 		} 
76   }
77 
78 	/**
79 	* in case close has been called accidentally.
80 	**/
81 	function open() onlyOwner public{
82 		closeAt = 0;
83 	}
84 
85 	/**
86 	* make sure the contract is not in process of being closed.
87 	**/
88 	modifier isAlive {
89 		require(closeAt == 0);
90 		_;
91 	}
92 
93 	/**
94 	* delays the time of closing.
95 	**/
96 	modifier keepAlive {
97 		if(closeAt > 0) closeAt = now + 30 days;
98 		_;
99 	}
100 }
101 
102 
103 contract requiringAuthorization is mortal {
104 	/** indicates if an address is authorized to act in the casino's name  */
105 	mapping(address => bool) public authorized;
106 	/** tells if an address is allowed to receive funds from the bankroll **/
107 	mapping(address => bool) public allowedReceiver;
108 
109 	modifier onlyAuthorized {
110 		require(authorized[msg.sender]);
111 		_;
112 	}
113 
114 	/**
115 	 * Constructor. Authorize the owner.
116 	 * */
117 	function requiringAuthorization() internal {
118 		authorized[msg.sender] = true;
119 		allowedReceiver[msg.sender] = true;
120 	}
121 
122 	/**
123 	 * authorize a address to call game functions and set configs.
124 	 * @param addr the address to be authorized
125 	 **/
126 	function authorize(address addr) public onlyOwner {
127 		authorized[addr] = true;
128 	}
129 
130 	/**
131 	 * deauthorize a address to call game functions and set configs.
132 	 * @param addr the address to be deauthorized
133 	 **/
134 	function deauthorize(address addr) public onlyOwner {
135 		authorized[addr] = false;
136 	}
137 
138 	/**
139 	 * allow authorized wallets to withdraw funds from the bonkroll to this address
140 	 * @param receiver the receiver's address
141 	 * */
142 	function allowReceiver(address receiver) public onlyOwner {
143 		allowedReceiver[receiver] = true;
144 	}
145 
146 	/**
147 	 * disallow authorized wallets to withdraw funds from the bonkroll to this address
148 	 * @param receiver the receiver's address
149 	 * */
150 	function disallowReceiver(address receiver) public onlyOwner {
151 		allowedReceiver[receiver] = false;
152 	}
153 
154 	/**
155 	 * changes the owner of the contract. revokes authorization of the old owner and authorizes the new one.
156 	 * @param newOwner the address of the new owner
157 	 * */
158 	function changeOwner(address newOwner) public onlyOwner {
159 		deauthorize(owner);
160 		authorize(newOwner);
161 		disallowReceiver(owner);
162 		allowReceiver(newOwner);
163 		owner = newOwner;
164 	}
165 }
166 
167 
168 contract chargingGas is requiringAuthorization, SafeMath {
169 	/** 1 EDG has 5 decimals **/
170 	uint public constant oneEDG = 100000;
171 	/** the price per kgas and GWei in tokens (with decimals) */
172 	uint public gasPrice;
173 	/** the amount of gas used per transaction in kGas */
174 	mapping(bytes4 => uint) public gasPerTx;
175 	/** the number of tokens (5 decimals) payed by the users to cover the gas cost */
176 	uint public gasPayback;
177 	
178 	function chargingGas(uint kGasPrice) internal{
179 		//deposit, withdrawFor, updateChannel, updateBatch, transferToNewContract
180 	    bytes4[5] memory signatures = [bytes4(0x3edd1128),0x9607610a, 0xde48ff52, 0xc97b6d1f, 0x6bf06fde];
181 	    //amount of gas consumed by the above methods in GWei
182 	    uint[5] memory gasUsage = [uint(146), 100, 65, 50, 85];
183 	    setGasUsage(signatures, gasUsage);
184 	    setGasPrice(kGasPrice);
185 	}
186 	/**
187 	 * sets the amount of gas consumed by methods with the given sigantures.
188 	 * only called from the edgeless casino constructor.
189 	 * @param signatures an array of method-signatures
190 	 *        gasNeeded  the amount of gas consumed by these methods
191 	 * */
192 	function setGasUsage(bytes4[5] signatures, uint[5] gasNeeded) public onlyOwner {
193 		require(signatures.length == gasNeeded.length);
194 		for (uint8 i = 0; i < signatures.length; i++)
195 			gasPerTx[signatures[i]] = gasNeeded[i];
196 	}
197 
198 	/**
199 	 * updates the price per 1000 gas in EDG.
200 	 * @param price the new gas price (with decimals, max 0.1 EDG)
201 	 **/
202 	function setGasPrice(uint price) public onlyAuthorized {
203 		require(price < oneEDG/10);
204 		gasPrice = price;
205 	}
206 
207 	/**
208 	 * returns the gas cost of the called function.
209 	 * */
210 	function getGasCost() internal view returns(uint) {
211 		return safeMul(safeMul(gasPerTx[msg.sig], gasPrice), tx.gasprice) / 1000000000;
212 	}
213 
214 }
215 
216 
217 contract CasinoBank is chargingGas {
218 	/** the total balance of all players with virtual decimals **/
219 	uint public playerBalance;
220 	/** the balance per player in edgeless tokens with virtual decimals */
221 	mapping(address => uint) public balanceOf;
222 	/** in case the user wants/needs to call the withdraw function from his own wallet, he first needs to request a withdrawal */
223 	mapping(address => uint) public withdrawAfter;
224 	/** a number to count withdrawal signatures to ensure each signature is different even if withdrawing the same amount to the same address */
225 	mapping(address => uint) public withdrawCount;
226 	/** the maximum amount of tokens the user is allowed to deposit (with decimals) */
227 	uint public maxDeposit;
228 	/** the maximum withdrawal of tokens the user is allowed to withdraw on one day (only enforced when the tx is not sent from an authorized wallet) **/
229 	uint public maxWithdrawal;
230 	/** waiting time for withdrawal if not requested via the server **/
231 	uint public waitingTime;
232 	/** the address of the predecessor **/
233 	address public predecessor;
234 
235 	/** informs listeners how many tokens were deposited for a player */
236 	event Deposit(address _player, uint _numTokens, uint _gasCost);
237 	/** informs listeners how many tokens were withdrawn from the player to the receiver address */
238 	event Withdrawal(address _player, address _receiver, uint _numTokens, uint _gasCost);
239 	
240 	
241 	/**
242 	 * Constructor.
243 	 * @param depositLimit    the maximum deposit allowed
244 	 *		  predecessorAddr the address of the predecessing contract
245 	 * */
246 	function CasinoBank(uint depositLimit, address predecessorAddr) internal {
247 		maxDeposit = depositLimit * oneEDG;
248 		maxWithdrawal = maxDeposit;
249 		waitingTime = 24 hours;
250 		predecessor = predecessorAddr;
251 	}
252 
253 	/**
254 	 * accepts deposits for an arbitrary address.
255 	 * retrieves tokens from the message sender and adds them to the balance of the specified address.
256 	 * edgeless tokens do not have any decimals, but are represented on this contract with decimals.
257 	 * @param receiver  address of the receiver
258 	 *        numTokens number of tokens to deposit (0 decimals)
259 	 *				 chargeGas indicates if the gas cost is subtracted from the user's edgeless token balance
260 	 **/
261 	function deposit(address receiver, uint numTokens, bool chargeGas) public isAlive {
262 		require(numTokens > 0);
263 		uint value = safeMul(numTokens, oneEDG);
264 		uint gasCost;
265 		if (chargeGas) {
266 			gasCost = getGasCost();
267 			value = safeSub(value, gasCost);
268 			gasPayback = safeAdd(gasPayback, gasCost);
269 		}
270 		uint newBalance = safeAdd(balanceOf[receiver], value);
271 		require(newBalance <= maxDeposit);
272 		assert(edg.transferFrom(msg.sender, address(this), numTokens));
273 		balanceOf[receiver] = newBalance;
274 		playerBalance = safeAdd(playerBalance, value);
275 		Deposit(receiver, numTokens, gasCost);
276 	}
277 
278 	/**
279 	 * If the user wants/needs to withdraw his funds himself, he needs to request the withdrawal first.
280 	 * This method sets the earliest possible withdrawal date to 'waitingTime from now (default 90m, but up to 24h).
281 	 * Reason: The user should not be able to withdraw his funds, while the the last game methods have not yet been mined.
282 	 **/
283 	function requestWithdrawal() public {
284 		withdrawAfter[msg.sender] = now + waitingTime;
285 	}
286 
287 	/**
288 	 * In case the user requested a withdrawal and changes his mind.
289 	 * Necessary to be able to continue playing.
290 	 **/
291 	function cancelWithdrawalRequest() public {
292 		withdrawAfter[msg.sender] = 0;
293 	}
294 
295 	/**
296 	 * withdraws an amount from the user balance if the waiting time passed since the request.
297 	 * @param amount the amount of tokens to withdraw
298 	 **/
299 	function withdraw(uint amount) public keepAlive {
300 		require(amount <= maxWithdrawal);
301 		require(withdrawAfter[msg.sender] > 0 && now > withdrawAfter[msg.sender]);
302 		withdrawAfter[msg.sender] = 0;
303 		uint value = safeMul(amount, oneEDG);
304 		balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], value);
305 		playerBalance = safeSub(playerBalance, value);
306 		assert(edg.transfer(msg.sender, amount));
307 		Withdrawal(msg.sender, msg.sender, amount, 0);
308 	}
309 
310 	/**
311 	 * lets the owner withdraw from the bankroll
312 	 * @param receiver the receiver's address
313 	 *				numTokens the number of tokens to withdraw (0 decimals)
314 	 **/
315 	function withdrawBankroll(address receiver, uint numTokens) public onlyAuthorized {
316 		require(numTokens <= bankroll());
317 		require(allowedReceiver[receiver]);
318 		assert(edg.transfer(receiver, numTokens));
319 	}
320 
321 	/**
322 	 * withdraw the gas payback to the owner
323 	 **/
324 	function withdrawGasPayback() public onlyAuthorized {
325 		uint payback = gasPayback / oneEDG;
326 		assert(payback > 0);
327 		gasPayback = safeSub(gasPayback, payback * oneEDG);
328 		assert(edg.transfer(owner, payback));
329 	}
330 
331 	/**
332 	 * returns the current bankroll in tokens with 0 decimals
333 	 **/
334 	function bankroll() constant public returns(uint) {
335 		return safeSub(edg.balanceOf(address(this)), safeAdd(playerBalance, gasPayback) / oneEDG);
336 	}
337 
338 
339 	/**
340 	 * updates the maximum deposit.
341 	 * @param newMax the new maximum deposit (0 decimals)
342 	 **/
343 	function setMaxDeposit(uint newMax) public onlyAuthorized {
344 		maxDeposit = newMax * oneEDG;
345 	}
346 	
347 	/**
348 	 * updates the maximum withdrawal.
349 	 * @param newMax the new maximum withdrawal (0 decimals)
350 	 **/
351 	function setMaxWithdrawal(uint newMax) public onlyAuthorized {
352 		maxWithdrawal = newMax * oneEDG;
353 	}
354 
355 	/**
356 	 * sets the time the player has to wait for his funds to be unlocked before withdrawal (if not withdrawing with help of the casino server).
357 	 * the time may not be longer than 24 hours.
358 	 * @param newWaitingTime the new waiting time in seconds
359 	 * */
360 	function setWaitingTime(uint newWaitingTime) public onlyAuthorized  {
361 		require(newWaitingTime <= 24 hours);
362 		waitingTime = newWaitingTime;
363 	}
364 
365 	/**
366 	 * transfers an amount from the contract balance to the owner's wallet.
367 	 * @param receiver the receiver address
368 	 *				 amount   the amount of tokens to withdraw (0 decimals)
369 	 *				 v,r,s 		the signature of the player
370 	 **/
371 	function withdrawFor(address receiver, uint amount, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized keepAlive {
372 		address player = ecrecover(keccak256(receiver, amount, withdrawCount[receiver]), v, r, s);
373 		withdrawCount[receiver]++;
374 		uint gasCost = getGasCost();
375 		uint value = safeAdd(safeMul(amount, oneEDG), gasCost);
376 		gasPayback = safeAdd(gasPayback, gasCost);
377 		balanceOf[player] = safeSub(balanceOf[player], value);
378 		playerBalance = safeSub(playerBalance, value);
379 		assert(edg.transfer(receiver, amount));
380 		Withdrawal(player, receiver, amount, gasCost);
381 	}
382 	
383 	/**
384 	 * transfers the player's tokens directly to the new casino contract after an update.
385 	 * @param newCasino the address of the new casino contract
386 	 *		  v, r, s   the signature of the player
387 	 *		  chargeGas indicates if the gas cost is payed by the player.
388 	 * */
389 	function transferToNewContract(address newCasino, uint8 v, bytes32 r, bytes32 s, bool chargeGas) public onlyAuthorized keepAlive {
390 		address player = ecrecover(keccak256(address(this), newCasino), v, r, s);
391 		uint gasCost = 0;
392 		if(chargeGas) gasCost = getGasCost();
393 		uint value = safeSub(balanceOf[player], gasCost);
394 		require(value > oneEDG);
395 		//fractions of one EDG cannot be withdrawn 
396 		value /= oneEDG;
397 		playerBalance = safeSub(playerBalance, balanceOf[player]);
398 		balanceOf[player] = 0;
399 		assert(edg.transfer(newCasino, value));
400 		Withdrawal(player, newCasino, value, gasCost);
401 		CasinoBank cb = CasinoBank(newCasino);
402 		assert(cb.credit(player, value));
403 	}
404 	
405 	/**
406 	 * receive a player balance from the predecessor contract.
407 	 * @param player the address of the player to credit the value for
408 	 *				value  the number of tokens to credit (0 decimals)
409 	 * */
410 	function credit(address player, uint value) public returns(bool) {
411 		require(msg.sender == predecessor);
412 		uint valueWithDecimals = safeMul(value, oneEDG);
413 		balanceOf[player] = safeAdd(balanceOf[player], valueWithDecimals);
414 		playerBalance = safeAdd(playerBalance, valueWithDecimals);
415 		Deposit(player, value, 0);
416 		return true;
417 	}
418 
419 	/**
420 	 * lets the owner close the contract if there are no player funds on it or if nobody has been using it for at least 30 days
421 	 * */
422 	function close() public onlyOwner {
423 		closeContract(playerBalance);
424 	}
425 }
426 
427 
428 contract EdgelessCasino is CasinoBank{
429 	/** the most recent known state of a state channel */
430 	mapping(address => State) public lastState;
431 	/** fired when the state is updated */
432 	event StateUpdate(address player, uint128 count, int128 winBalance, int difference, uint gasCost);
433   /** fired if one of the parties chooses to log the seeds and results */
434   event GameData(address player, bytes32[] serverSeeds, bytes32[] clientSeeds, int[] results, uint gasCost);
435   
436 	struct State{
437 		uint128 count;
438 		int128 winBalance;
439 	}
440 
441 
442   /**
443   * creates a new edgeless casino contract.
444   * @param predecessorAddress the address of the predecessing contract
445 	*				 tokenContract      the address of the Edgeless token contract
446 	* 			 depositLimit       the maximum deposit allowed
447 	* 			 kGasPrice				  the price per kGas in WEI
448   **/
449   function EdgelessCasino(address predecessorAddress, address tokenContract, uint depositLimit, uint kGasPrice) CasinoBank(depositLimit, predecessorAddress) mortal(tokenContract) chargingGas(kGasPrice) public{
450 
451   }
452   
453   /**
454    * updates several state channels at once. can be called by authorized wallets only.
455    * 1. determines the player address from the signature.
456    * 2. verifies if the signed game-count is higher than the last known game-count of this channel.
457    * 3. updates the balances accordingly. This means: It checks the already performed updates for this channel and computes
458    *    the new balance difference to add or subtract from the player‘s balance.
459    * @param winBalances array of the current wins or losses
460    *				gameCounts  array of the numbers of signed game moves
461    *				v,r,s       array of the players's signatures
462    *        chargeGas   indicates if the gas costs should be subtracted from the players's balances
463    * */
464   function updateBatch(int128[] winBalances,  uint128[] gameCounts, uint8[] v, bytes32[] r, bytes32[] s, bool chargeGas) public onlyAuthorized{
465     require(winBalances.length == gameCounts.length);
466     require(winBalances.length == v.length);
467     require(winBalances.length == r.length);
468     require(winBalances.length == s.length);
469     require(winBalances.length <= 50);
470     address player;
471     uint gasCost = 0;
472     if(chargeGas) 
473       gasCost = getGasCost();
474     gasPayback = safeAdd(gasPayback, safeMul(gasCost, winBalances.length));
475     for(uint8 i = 0; i < winBalances.length; i++){
476       player = ecrecover(keccak256(winBalances[i], gameCounts[i]), v[i], r[i], s[i]);
477       _updateState(player, winBalances[i], gameCounts[i], gasCost);
478     }
479   }
480 
481   /**
482    * updates a state channel. can be called by both parties.
483    * 1. verifies the signature.
484    * 2. verifies if the signed game-count is higher than the last known game-count of this channel.
485    * 3. updates the balances accordingly. This means: It checks the already performed updates for this channel and computes
486    *    the new balance difference to add or subtract from the player‘s balance.
487    * @param winBalance the current win or loss
488    *				gameCount  the number of signed game moves
489    *				v,r,s      the signature of either the casino or the player
490    *        chargeGas  indicates if the gas costs should be subtracted from the player's balance
491    * */
492   function updateState(int128 winBalance,  uint128 gameCount, uint8 v, bytes32 r, bytes32 s, bool chargeGas) public{
493   	address player = determinePlayer(winBalance, gameCount, v, r, s);
494   	uint gasCost = 0;
495   	if(player == msg.sender)//if the player closes the state channel himself, make sure the signer is a casino wallet
496   		require(authorized[ecrecover(keccak256(player, winBalance, gameCount), v, r, s)]);
497   	else if (chargeGas){//subtract the gas costs from the player balance only if the casino wallet is the sender
498   		gasCost = getGasCost();
499   		gasPayback = safeAdd(gasPayback, gasCost);
500   	}
501   	_updateState(player, winBalance, gameCount, gasCost);
502   }
503   
504   /**
505    * internal method to perform the actual state update.
506    * @param player the player address
507    *        winBalance the player's win balance
508    *        gameCount  the player's game count
509    * */
510   function _updateState(address player, int128 winBalance,  uint128 gameCount, uint gasCost) internal {
511     State storage last = lastState[player];
512   	require(gameCount > last.count);
513   	int difference = updatePlayerBalance(player, winBalance, last.winBalance, gasCost);
514   	lastState[player] = State(gameCount, winBalance);
515   	StateUpdate(player, gameCount, winBalance, difference, gasCost);
516   }
517 
518   /**
519    * determines if the msg.sender or the signer of the passed signature is the player. returns the player's address
520    * @param winBalance the current winBalance, used to calculate the msg hash
521    *				gameCount  the current gameCount, used to calculate the msg.hash
522    *				v, r, s    the signature of the non-sending party
523    * */
524   function determinePlayer(int128 winBalance, uint128 gameCount, uint8 v, bytes32 r, bytes32 s) constant internal returns(address){
525   	if (authorized[msg.sender])//casino is the sender -> player is the signer
526   		return ecrecover(keccak256(winBalance, gameCount), v, r, s);
527   	else
528   		return msg.sender;
529   }
530 
531 	/**
532 	 * computes the difference of the win balance relative to the last known state and adds it to the player's balance.
533 	 * in case the casino is the sender, the gas cost in EDG gets subtracted from the player's balance.
534 	 * @param player the address of the player
535 	 *				winBalance the current win-balance
536 	 *				lastWinBalance the win-balance of the last known state
537 	 *				gasCost the gas cost of the tx
538 	 * */
539   function updatePlayerBalance(address player, int128 winBalance, int128 lastWinBalance, uint gasCost) internal returns(int difference){
540   	difference = safeSub(winBalance, lastWinBalance);
541   	int outstanding = safeSub(difference, int(gasCost));
542   	uint outs;
543   	if(outstanding < 0){
544   		outs = uint256(outstanding * (-1));
545   		playerBalance = safeSub(playerBalance, outs);
546   		balanceOf[player] = safeSub(balanceOf[player], outs);
547   	}
548   	else{
549   		outs = uint256(outstanding);
550   		assert(bankroll() * oneEDG > outs);
551   	  playerBalance = safeAdd(playerBalance, outs);
552   	  balanceOf[player] = safeAdd(balanceOf[player], outs);
553   	}
554   }
555   
556   /**
557    * logs some seeds and game results for players wishing to have their game history logged by the contract
558    * @param serverSeeds array containing the server seeds
559    *        clientSeeds array containing the client seeds
560    *        results     array containing the results
561    *        v, r, s     the signature of the non-sending party (to make sure the correct results are logged)
562    * */
563   function logGameData(bytes32[] serverSeeds, bytes32[] clientSeeds, int[] results, uint8 v, bytes32 r, bytes32 s) public{
564     address player = determinePlayer(serverSeeds, clientSeeds, results, v, r, s);
565     uint gasCost;
566     //charge gas in case the server is logging the results for the player
567     if(player != msg.sender){
568       gasCost = (57 + 768 * serverSeeds.length / 1000)*gasPrice;
569       balanceOf[player] = safeSub(balanceOf[player], gasCost);
570       playerBalance = safeSub(playerBalance, gasCost);
571       gasPayback = safeAdd(gasPayback, gasCost);
572     }
573     GameData(player, serverSeeds, clientSeeds, results, gasCost);
574   }
575   
576   /**
577    * determines if the msg.sender or the signer of the passed signature is the player. returns the player's address
578    * @param serverSeeds array containing the server seeds
579    *        clientSeeds array containing the client seeds
580    *        results     array containing the results
581    *				v, r, s    the signature of the non-sending party
582    * */
583   function determinePlayer(bytes32[] serverSeeds, bytes32[] clientSeeds, int[] results, uint8 v, bytes32 r, bytes32 s) constant internal returns(address){
584   	address signer = ecrecover(keccak256(serverSeeds, clientSeeds, results), v, r, s);
585   	if (authorized[msg.sender])//casino is the sender -> player is the signer
586   		return signer;
587   	else if (authorized[signer])
588   		return msg.sender;
589   	else 
590   	  revert();
591   }
592 
593 }