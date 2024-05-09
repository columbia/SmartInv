1 /**
2  * The edgeless casino contract v2 holds the players's funds and provides state channel functionality.
3  * The casino has at no time control over the players's funds.
4  * State channels can be updated and closed from both parties: the player and the casino.
5  * author: Julia Altenried
6  **/
7 
8 pragma solidity ^0.4.25;
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
30 		uint c = a * b;
31 		assert(a == 0 || c / a == b);
32 		return c;
33 	}
34 }
35 
36 
37 contract Token {
38 	function transferFrom(address sender, address receiver, uint amount) public returns(bool success);
39 
40 	function transfer(address receiver, uint amount) public returns(bool success);
41 
42 	function balanceOf(address holder) public view returns(uint);
43 }
44 
45 contract Owned {
46   address public owner;
47   modifier onlyOwner {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function Owned() public{
53     owner = msg.sender;
54   }
55 
56 }
57 
58 /** owner should be able to close the contract is nobody has been using it for at least 30 days */
59 contract Mortal is Owned {
60 	/** contract can be closed by the owner anytime after this timestamp if non-zero */
61 	uint public closeAt;
62 	/** the edgeless token contract */
63 	Token edg;
64 	
65 	function Mortal(address tokenContract) internal{
66 		edg = Token(tokenContract);
67 	}
68 	/**
69 	* lets the owner close the contract if there are no player funds on it or if nobody has been using it for at least 30 days
70 	*/
71   function closeContract(uint playerBalance) internal{
72 		if(closeAt == 0) closeAt = now + 30 days;
73 		if(closeAt < now || playerBalance == 0){
74 			edg.transfer(owner, edg.balanceOf(address(this)));
75 			selfdestruct(owner);
76 		} 
77   }
78 
79 	/**
80 	* in case close has been called accidentally.
81 	**/
82 	function open() onlyOwner public{
83 		closeAt = 0;
84 	}
85 
86 	/**
87 	* make sure the contract is not in process of being closed.
88 	**/
89 	modifier isAlive {
90 		require(closeAt == 0);
91 		_;
92 	}
93 
94 	/**
95 	* delays the time of closing.
96 	**/
97 	modifier keepAlive {
98 		if(closeAt > 0) closeAt = now + 30 days;
99 		_;
100 	}
101 }
102 
103 contract RequiringAuthorization is Mortal {
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
117 	function RequiringAuthorization() internal {
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
167 contract ChargingGas is RequiringAuthorization, SafeMath {
168 	/** 1 EDG has 5 decimals **/
169 	uint public constant oneEDG = 100000;
170 	/** the price per kgas and GWei in tokens (with decimals) */
171 	uint public gasPrice;
172 	/** the amount of gas used per transaction in kGas */
173 	mapping(bytes4 => uint) public gasPerTx;
174 	/** the number of tokens (5 decimals) payed by the users to cover the gas cost */
175 	uint public gasPayback;
176 	
177 	function ChargingGas(uint kGasPrice) internal{
178 		//deposit, withdrawFor, updateChannel, updateBatch, transferToNewContract
179 	    bytes4[5] memory signatures = [bytes4(0x3edd1128),0x9607610a, 0xde48ff52, 0xc97b6d1f, 0x6bf06fde];
180 	    //amount of gas consumed by the above methods in GWei
181 	    uint[5] memory gasUsage = [uint(146), 100, 65, 50, 85];
182 	    setGasUsage(signatures, gasUsage);
183 	    setGasPrice(kGasPrice);
184 	}
185 	/**
186 	 * sets the amount of gas consumed by methods with the given sigantures.
187 	 * only called from the edgeless casino constructor.
188 	 * @param signatures an array of method-signatures
189 	 *        gasNeeded  the amount of gas consumed by these methods
190 	 * */
191 	function setGasUsage(bytes4[5] signatures, uint[5] gasNeeded) public onlyOwner {
192 		require(signatures.length == gasNeeded.length);
193 		for (uint8 i = 0; i < signatures.length; i++)
194 			gasPerTx[signatures[i]] = gasNeeded[i];
195 	}
196 
197 	/**
198 	 * updates the price per 1000 gas in EDG.
199 	 * @param price the new gas price (with decimals, max 0.1 EDG)
200 	 **/
201 	function setGasPrice(uint price) public onlyAuthorized {
202 		require(price < oneEDG/10);
203 		gasPrice = price;
204 	}
205 
206 	/**
207 	 * returns the gas cost of the called function.
208 	 * */
209 	function getGasCost() internal view returns(uint) {
210 		return safeMul(safeMul(gasPerTx[msg.sig], gasPrice), tx.gasprice) / 1000000000;
211 	}
212 
213 }
214 
215 
216 contract CasinoBank is ChargingGas {
217 	/** the total balance of all players with virtual decimals **/
218 	uint public playerBalance;
219 	/** the balance per player in edgeless tokens with virtual decimals */
220 	mapping(address => uint) public balanceOf;
221 	/** in case the user wants/needs to call the withdraw function from his own wallet, he first needs to request a withdrawal */
222 	mapping(address => uint) public withdrawAfter;
223 	/** a number to count withdrawal signatures to ensure each signature is different even if withdrawing the same amount to the same address */
224 	mapping(address => uint) public withdrawCount;
225 	/** the maximum amount of tokens the user is allowed to deposit (with decimals) */
226 	uint public maxDeposit;
227 	/** the maximum withdrawal of tokens the user is allowed to withdraw on one day (only enforced when the tx is not sent from an authorized wallet) **/
228 	uint public maxWithdrawal;
229 	/** waiting time for withdrawal if not requested via the server **/
230 	uint public waitingTime;
231 	/** the address of the predecessor **/
232 	address public predecessor;
233 
234 	/** informs listeners how many tokens were deposited for a player */
235 	event Deposit(address _player, uint _numTokens, uint _gasCost);
236 	/** informs listeners how many tokens were withdrawn from the player to the receiver address */
237 	event Withdrawal(address _player, address _receiver, uint _numTokens, uint _gasCost);
238 	
239 	
240 	/**
241 	 * Constructor.
242 	 * @param depositLimit    the maximum deposit allowed
243 	 *		  predecessorAddr the address of the predecessing contract
244 	 * */
245 	function CasinoBank(uint depositLimit, address predecessorAddr) internal {
246 		maxDeposit = depositLimit * oneEDG;
247 		maxWithdrawal = maxDeposit;
248 		waitingTime = 24 hours;
249 		predecessor = predecessorAddr;
250 	}
251 
252 	/**
253 	 * accepts deposits for an arbitrary address.
254 	 * retrieves tokens from the message sender and adds them to the balance of the specified address.
255 	 * edgeless tokens do not have any decimals, but are represented on this contract with decimals.
256 	 * @param receiver  address of the receiver
257 	 *        numTokens number of tokens to deposit (0 decimals)
258 	 *				 chargeGas indicates if the gas cost is subtracted from the user's edgeless token balance
259 	 **/
260 	function deposit(address receiver, uint numTokens, bool chargeGas) public isAlive {
261 		require(numTokens > 0);
262 		uint value = safeMul(numTokens, oneEDG);
263 		uint gasCost;
264 		if (chargeGas) {
265 			gasCost = getGasCost();
266 			value = safeSub(value, gasCost);
267 			gasPayback = safeAdd(gasPayback, gasCost);
268 		}
269 		uint newBalance = safeAdd(balanceOf[receiver], value);
270 		require(newBalance <= maxDeposit);
271 		assert(edg.transferFrom(msg.sender, address(this), numTokens));
272 		balanceOf[receiver] = newBalance;
273 		playerBalance = safeAdd(playerBalance, value);
274 		emit Deposit(receiver, numTokens, gasCost);
275 	}
276 
277 	/**
278 	 * If the user wants/needs to withdraw his funds himself, he needs to request the withdrawal first.
279 	 * This method sets the earliest possible withdrawal date to 'waitingTime from now (default 90m, but up to 24h).
280 	 * Reason: The user should not be able to withdraw his funds, while the the last game methods have not yet been mined.
281 	 **/
282 	function requestWithdrawal() public {
283 		withdrawAfter[msg.sender] = now + waitingTime;
284 	}
285 
286 	/**
287 	 * In case the user requested a withdrawal and changes his mind.
288 	 * Necessary to be able to continue playing.
289 	 **/
290 	function cancelWithdrawalRequest() public {
291 		withdrawAfter[msg.sender] = 0;
292 	}
293 
294 	/**
295 	 * withdraws an amount from the user balance if the waiting time passed since the request.
296 	 * @param amount the amount of tokens to withdraw
297 	 **/
298 	function withdraw(uint amount) public keepAlive {
299 		require(amount <= maxWithdrawal);
300 		require(withdrawAfter[msg.sender] > 0 && now > withdrawAfter[msg.sender]);
301 		withdrawAfter[msg.sender] = 0;
302 		uint value = safeMul(amount, oneEDG);
303 		balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], value);
304 		playerBalance = safeSub(playerBalance, value);
305 		assert(edg.transfer(msg.sender, amount));
306 		emit Withdrawal(msg.sender, msg.sender, amount, 0);
307 	}
308 
309 	/**
310 	 * lets the owner withdraw from the bankroll
311 	 * @param receiver the receiver's address
312 	 *				numTokens the number of tokens to withdraw (0 decimals)
313 	 **/
314 	function withdrawBankroll(address receiver, uint numTokens) public onlyAuthorized {
315 		require(numTokens <= bankroll());
316 		require(allowedReceiver[receiver]);
317 		assert(edg.transfer(receiver, numTokens));
318 	}
319 
320 	/**
321 	 * withdraw the gas payback to the owner
322 	 **/
323 	function withdrawGasPayback() public onlyAuthorized {
324 		uint payback = gasPayback / oneEDG;
325 		assert(payback > 0);
326 		gasPayback = safeSub(gasPayback, payback * oneEDG);
327 		assert(edg.transfer(owner, payback));
328 	}
329 
330 	/**
331 	 * returns the current bankroll in tokens with 0 decimals
332 	 **/
333 	function bankroll() view public returns(uint) {
334 		return safeSub(edg.balanceOf(address(this)), safeAdd(playerBalance, gasPayback) / oneEDG);
335 	}
336 
337 
338 	/**
339 	 * updates the maximum deposit.
340 	 * @param newMax the new maximum deposit (0 decimals)
341 	 **/
342 	function setMaxDeposit(uint newMax) public onlyAuthorized {
343 		maxDeposit = newMax * oneEDG;
344 	}
345 	
346 	/**
347 	 * updates the maximum withdrawal.
348 	 * @param newMax the new maximum withdrawal (0 decimals)
349 	 **/
350 	function setMaxWithdrawal(uint newMax) public onlyAuthorized {
351 		maxWithdrawal = newMax * oneEDG;
352 	}
353 
354 	/**
355 	 * sets the time the player has to wait for his funds to be unlocked before withdrawal (if not withdrawing with help of the casino server).
356 	 * the time may not be longer than 24 hours.
357 	 * @param newWaitingTime the new waiting time in seconds
358 	 * */
359 	function setWaitingTime(uint newWaitingTime) public onlyAuthorized  {
360 		require(newWaitingTime <= 24 hours);
361 		waitingTime = newWaitingTime;
362 	}
363 
364 	/**
365 	 * transfers an amount from the contract balance to the owner's wallet.
366 	 * @param receiver the receiver address
367 	 *				 amount   the amount of tokens to withdraw (0 decimals)
368 	 *				 v,r,s 		the signature of the player
369 	 **/
370 	function withdrawFor(address receiver, uint amount, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized keepAlive {
371 		address player = ecrecover(keccak256(receiver, amount, withdrawCount[receiver]), v, r, s);
372 		withdrawCount[receiver]++;
373 		uint gasCost = getGasCost();
374 		uint value = safeAdd(safeMul(amount, oneEDG), gasCost);
375 		gasPayback = safeAdd(gasPayback, gasCost);
376 		balanceOf[player] = safeSub(balanceOf[player], value);
377 		playerBalance = safeSub(playerBalance, value);
378 		assert(edg.transfer(receiver, amount));
379 		emit Withdrawal(player, receiver, amount, gasCost);
380 	}
381 	
382 	/**
383 	 * transfers the player's tokens directly to the new casino contract after an update.
384 	 * @param newCasino the address of the new casino contract
385 	 *		  v, r, s   the signature of the player
386 	 *		  chargeGas indicates if the gas cost is payed by the player.
387 	 * */
388 	function transferToNewContract(address newCasino, uint8 v, bytes32 r, bytes32 s, bool chargeGas) public onlyAuthorized keepAlive {
389 		address player = ecrecover(keccak256(address(this), newCasino), v, r, s);
390 		uint gasCost = 0;
391 		if(chargeGas) gasCost = getGasCost();
392 		uint value = safeSub(balanceOf[player], gasCost);
393 		require(value > oneEDG);
394 		//fractions of one EDG cannot be withdrawn 
395 		value /= oneEDG;
396 		playerBalance = safeSub(playerBalance, balanceOf[player]);
397 		balanceOf[player] = 0;
398 		assert(edg.transfer(newCasino, value));
399 		emit Withdrawal(player, newCasino, value, gasCost);
400 		CasinoBank cb = CasinoBank(newCasino);
401 		assert(cb.credit(player, value));
402 	}
403 	
404 	/**
405 	 * receive a player balance from the predecessor contract.
406 	 * @param player the address of the player to credit the value for
407 	 *				value  the number of tokens to credit (0 decimals)
408 	 * */
409 	function credit(address player, uint value) public returns(bool) {
410 		require(msg.sender == predecessor);
411 		uint valueWithDecimals = safeMul(value, oneEDG);
412 		balanceOf[player] = safeAdd(balanceOf[player], valueWithDecimals);
413 		playerBalance = safeAdd(playerBalance, valueWithDecimals);
414 		emit Deposit(player, value, 0);
415 		return true;
416 	}
417 
418 	/**
419 	 * lets the owner close the contract if there are no player funds on it or if nobody has been using it for at least 30 days
420 	 * */
421 	function close() public onlyOwner {
422 		closeContract(playerBalance);
423 	}
424 }
425 
426 
427 contract EdgelessCasino is CasinoBank{
428 	/** the most recent known state of a state channel */
429 	mapping(address => State) public lastState;
430 	/** fired when the state is updated */
431 	event StateUpdate(address player, uint128 count, int128 winBalance, int difference, uint gasCost);
432   /** fired if one of the parties chooses to log the seeds and results */
433   event GameData(address player, bytes32[] serverSeeds, bytes32[] clientSeeds, int[] results, uint gasCost);
434   
435 	struct State{
436 		uint128 count;
437 		int128 winBalance;
438 	}
439 
440 
441   /**
442   * creates a new edgeless casino contract.
443   * @param predecessorAddress the address of the predecessing contract
444 	*				 tokenContract      the address of the Edgeless token contract
445 	* 			 depositLimit       the maximum deposit allowed
446 	* 			 kGasPrice				  the price per kGas in WEI
447   **/
448   function EdgelessCasino(address predecessorAddress, address tokenContract, uint depositLimit, uint kGasPrice) CasinoBank(depositLimit, predecessorAddress) Mortal(tokenContract) ChargingGas(kGasPrice) public{
449 
450   }
451   
452   /**
453    * updates several state channels at once. can be called by authorized wallets only.
454    * 1. determines the player address from the signature.
455    * 2. verifies if the signed game-count is higher than the last known game-count of this channel.
456    * 3. updates the balances accordingly. This means: It checks the already performed updates for this channel and computes
457    *    the new balance difference to add or subtract from the player‘s balance.
458    * @param winBalances array of the current wins or losses
459    *				gameCounts  array of the numbers of signed game moves
460    *				v,r,s       array of the players's signatures
461    *        chargeGas   indicates if the gas costs should be subtracted from the players's balances
462    * */
463   function updateBatch(int128[] winBalances,  uint128[] gameCounts, uint8[] v, bytes32[] r, bytes32[] s, bool chargeGas) public onlyAuthorized{
464     require(winBalances.length == gameCounts.length);
465     require(winBalances.length == v.length);
466     require(winBalances.length == r.length);
467     require(winBalances.length == s.length);
468     require(winBalances.length <= 50);
469     address player;
470     uint gasCost = 0;
471     if(chargeGas) 
472       gasCost = getGasCost();
473     gasPayback = safeAdd(gasPayback, safeMul(gasCost, winBalances.length));
474     for(uint8 i = 0; i < winBalances.length; i++){
475       player = ecrecover(keccak256(winBalances[i], gameCounts[i]), v[i], r[i], s[i]);
476       _updateState(player, winBalances[i], gameCounts[i], gasCost);
477     }
478   }
479 
480   /**
481    * updates a state channel. can be called by both parties.
482    * 1. verifies the signature.
483    * 2. verifies if the signed game-count is higher than the last known game-count of this channel.
484    * 3. updates the balances accordingly. This means: It checks the already performed updates for this channel and computes
485    *    the new balance difference to add or subtract from the player‘s balance.
486    * @param winBalance the current win or loss
487    *				gameCount  the number of signed game moves
488    *				v,r,s      the signature of either the casino or the player
489    *        chargeGas  indicates if the gas costs should be subtracted from the player's balance
490    * */
491   function updateState(int128 winBalance,  uint128 gameCount, uint8 v, bytes32 r, bytes32 s, bool chargeGas) public{
492   	address player = determinePlayer(winBalance, gameCount, v, r, s);
493   	uint gasCost = 0;
494   	if(player == msg.sender)//if the player closes the state channel himself, make sure the signer is a casino wallet
495   		require(authorized[ecrecover(keccak256(player, winBalance, gameCount), v, r, s)]);
496   	else if (chargeGas){//subtract the gas costs from the player balance only if the casino wallet is the sender
497   		gasCost = getGasCost();
498   		gasPayback = safeAdd(gasPayback, gasCost);
499   	}
500   	_updateState(player, winBalance, gameCount, gasCost);
501   }
502   
503   /**
504    * internal method to perform the actual state update.
505    * @param player the player address
506    *        winBalance the player's win balance
507    *        gameCount  the player's game count
508    * */
509   function _updateState(address player, int128 winBalance,  uint128 gameCount, uint gasCost) internal {
510     State storage last = lastState[player];
511   	require(gameCount > last.count);
512   	int difference = updatePlayerBalance(player, winBalance, last.winBalance, gasCost);
513   	lastState[player] = State(gameCount, winBalance);
514   	emit StateUpdate(player, gameCount, winBalance, difference, gasCost);
515   }
516 
517   /**
518    * determines if the msg.sender or the signer of the passed signature is the player. returns the player's address
519    * @param winBalance the current winBalance, used to calculate the msg hash
520    *				gameCount  the current gameCount, used to calculate the msg.hash
521    *				v, r, s    the signature of the non-sending party
522    * */
523   function determinePlayer(int128 winBalance, uint128 gameCount, uint8 v, bytes32 r, bytes32 s) view internal returns(address){
524   	if (authorized[msg.sender])//casino is the sender -> player is the signer
525   		return ecrecover(keccak256(winBalance, gameCount), v, r, s);
526   	else
527   		return msg.sender;
528   }
529 
530 	/**
531 	 * computes the difference of the win balance relative to the last known state and adds it to the player's balance.
532 	 * in case the casino is the sender, the gas cost in EDG gets subtracted from the player's balance.
533 	 * @param player the address of the player
534 	 *				winBalance the current win-balance
535 	 *				lastWinBalance the win-balance of the last known state
536 	 *				gasCost the gas cost of the tx
537 	 * */
538   function updatePlayerBalance(address player, int128 winBalance, int128 lastWinBalance, uint gasCost) internal returns(int difference){
539   	difference = safeSub(winBalance, lastWinBalance);
540   	int outstanding = safeSub(difference, int(gasCost));
541   	uint outs;
542   	if(outstanding < 0){
543   		outs = uint256(outstanding * (-1));
544   		playerBalance = safeSub(playerBalance, outs);
545   		balanceOf[player] = safeSub(balanceOf[player], outs);
546   	}
547   	else{
548   		outs = uint256(outstanding);
549   		assert(bankroll() * oneEDG > outs);
550   	  playerBalance = safeAdd(playerBalance, outs);
551   	  balanceOf[player] = safeAdd(balanceOf[player], outs);
552   	}
553   }
554   
555   /**
556    * logs some seeds and game results for players wishing to have their game history logged by the contract
557    * @param serverSeeds array containing the server seeds
558    *        clientSeeds array containing the client seeds
559    *        results     array containing the results
560    *        v, r, s     the signature of the non-sending party (to make sure the correct results are logged)
561    * */
562   function logGameData(bytes32[] serverSeeds, bytes32[] clientSeeds, int[] results, uint8 v, bytes32 r, bytes32 s) public{
563     address player = determinePlayer(serverSeeds, clientSeeds, results, v, r, s);
564     uint gasCost;
565     //charge gas in case the server is logging the results for the player
566     if(player != msg.sender){
567       gasCost = (57 + 768 * serverSeeds.length / 1000)*gasPrice;
568       balanceOf[player] = safeSub(balanceOf[player], gasCost);
569       playerBalance = safeSub(playerBalance, gasCost);
570       gasPayback = safeAdd(gasPayback, gasCost);
571     }
572     emit GameData(player, serverSeeds, clientSeeds, results, gasCost);
573   }
574   
575   /**
576    * determines if the msg.sender or the signer of the passed signature is the player. returns the player's address
577    * @param serverSeeds array containing the server seeds
578    *        clientSeeds array containing the client seeds
579    *        results     array containing the results
580    *				v, r, s    the signature of the non-sending party
581    * */
582   function determinePlayer(bytes32[] serverSeeds, bytes32[] clientSeeds, int[] results, uint8 v, bytes32 r, bytes32 s) view internal returns(address){
583   	address signer = ecrecover(keccak256(serverSeeds, clientSeeds, results), v, r, s);
584   	if (authorized[msg.sender])//casino is the sender -> player is the signer
585   		return signer;
586   	else if (authorized[signer])
587   		return msg.sender;
588   	else 
589   	  revert();
590   }
591 
592 }