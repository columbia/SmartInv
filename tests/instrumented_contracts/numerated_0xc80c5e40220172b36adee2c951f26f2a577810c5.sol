1 pragma solidity ^0.4.18;
2 /**
3  * Math operations with safety checks that throw on error
4  */
5 contract SafeMath {
6 
7 	function safeMul(uint256 a, uint256 b) public pure returns (uint256) {
8 		uint256 c = a * b;
9 		assert(a == 0 || c / a == b);
10 		return c;
11 	}
12 
13 	function safeDiv(uint256 a, uint256 b) public pure returns (uint256) {
14 		//assert(a > 0);// Solidity automatically throws when dividing by 0
15 		//assert(b > 0);// Solidity automatically throws when dividing by 0
16 		// uint256 c = a / b;
17 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
18 		return  a / b;
19 	}
20 
21 	function safeSub(uint256 a, uint256 b) public pure returns (uint256) {
22 		assert(b <= a);
23 		return a - b;
24 	}
25 
26 	function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {
27 		uint256 c = a + b;
28 		assert(c>=a && c>=b);
29 		return c;
30 	}
31 
32 }
33 /*
34  * ERC20 interface
35  * see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 {
38 
39 	function totalSupply() public constant returns (uint256);
40 	function balanceOf(address _owner) public constant returns (uint256);
41 	function transfer(address _to, uint256 _value) public returns (bool success);
42 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
43 	function approve(address _spender, uint256 _value) public returns (bool success);
44 	function allowance(address _owner, address _spender) public constant returns (uint256);
45 
46 	/* ERC20 Events */
47 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
48 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 contract ContractReceiver {
52 	function tokenFallback(address _from, uint256 _value, bytes _data) public;
53 }
54 
55 contract ERC223 is ERC20 {
56 
57 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
58 	function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success);
59 
60 	/* ERC223 Events */
61 	event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
62 }
63 
64 contract BankeraToken is ERC223, SafeMath {
65 
66 	string public constant name = "Banker Token";     // Set the name for display purposes
67 	string public constant symbol = "BNK";      // Set the symbol for display purposes
68 	uint8 public constant decimals = 8;         // Amount of decimals for display purposes
69 	uint256 private issued = 0;   				// tokens count issued to addresses
70 	uint256 private totalTokens = 25000000000 * 100000000; //25,000,000,000.0000 0000 BNK
71 
72 	address private contractOwner;
73 	address private rewardManager;
74 	address private roundManager;
75 	address private issueManager;
76 	uint64 public currentRound = 0;
77 
78 	bool public paused = false;
79 
80 	mapping (uint64 => Reward) public reward;	//key - round, value - reward in round
81 	mapping (address => AddressBalanceInfoStructure) public accountBalances;	//key - address, value - address balance info
82 	mapping (uint64 => uint256) public issuedTokensInRound;	//key - round, value - issued tokens
83 	mapping (address => mapping (address => uint256)) internal allowed;
84 
85 	uint256 public blocksPerRound; // blocks per round
86 	uint256 public lastBlockNumberInRound;
87 
88 	struct Reward {
89 		uint64 roundNumber;
90 		uint256 rewardInWei;
91 		uint256 rewardRate; //reward rate in wei. 1 sBNK - xxx wei
92 		bool isConfigured;
93 	}
94 
95 	struct AddressBalanceInfoStructure {
96 		uint256 addressBalance;
97 		mapping (uint256 => uint256) roundBalanceMap; //key - round number, value - total token amount in round
98 		mapping (uint64 => bool) wasModifiedInRoundMap; //key - round number, value - is modified in round
99 		uint64[] mapKeys;	//round balance map keys
100 		uint64 claimedRewardTillRound;
101 		uint256 totalClaimedReward;
102 	}
103 
104 	/* Initializes contract with initial blocks per round number*/
105 	function BankeraToken(uint256 _blocksPerRound, uint64 _round) public {
106 		contractOwner = msg.sender;
107 		lastBlockNumberInRound = block.number;
108 
109 		blocksPerRound = _blocksPerRound;
110 		currentRound = _round;
111 	}
112 
113 	function() public whenNotPaused payable {
114 	}
115 
116 	// Public functions
117 	/**
118 	 * @dev Reject all ERC223 compatible tokens
119 	 * @param _from address The address that is transferring the tokens
120 	 * @param _value uint256 the amount of the specified token
121 	 * @param _data Bytes The data passed from the caller.
122 	 */
123 	function tokenFallback(address _from, uint256 _value, bytes _data) public whenNotPaused view {
124 		revert();
125 	}
126 
127 	function setReward(uint64 _roundNumber, uint256 _roundRewardInWei) public whenNotPaused onlyRewardManager {
128 		isNewRound();
129 
130 		Reward storage rewardInfo = reward[_roundNumber];
131 
132 		//validations
133 		assert(rewardInfo.roundNumber == _roundNumber);
134 		assert(!rewardInfo.isConfigured); //allow just not configured reward configuration
135 
136 		rewardInfo.rewardInWei = _roundRewardInWei;
137 		if(_roundRewardInWei > 0){
138 			rewardInfo.rewardRate = safeDiv(_roundRewardInWei, issuedTokensInRound[_roundNumber]);
139 		}
140 		rewardInfo.isConfigured = true;
141 	}
142 
143 	/* Change contract owner */
144 	function changeContractOwner(address _newContractOwner) public onlyContractOwner {
145 		isNewRound();
146 		if (_newContractOwner != contractOwner) {
147 			contractOwner = _newContractOwner;
148 		} else {
149 			revert();
150 		}
151 	}
152 
153 	/* Change reward contract owner */
154 	function changeRewardManager(address _newRewardManager) public onlyContractOwner {
155 		isNewRound();
156 		if (_newRewardManager != rewardManager) {
157 			rewardManager = _newRewardManager;
158 		} else {
159 			revert();
160 		}
161 	}
162 
163 	/* Change round contract owner */
164 	function changeRoundManager(address _newRoundManager) public onlyContractOwner {
165 		isNewRound();
166 		if (_newRoundManager != roundManager) {
167 			roundManager = _newRoundManager;
168 		} else {
169 			revert();
170 		}
171 	}
172 
173 	/* Change issue contract owner */
174 	function changeIssueManager(address _newIssueManager) public onlyContractOwner {
175 		isNewRound();
176 		if (_newIssueManager != issueManager) {
177 			issueManager = _newIssueManager;
178 		} else {
179 			revert();
180 		}
181 	}
182 
183 	function setBlocksPerRound(uint64 _newBlocksPerRound) public whenNotPaused onlyRoundManager {
184 		blocksPerRound = _newBlocksPerRound;
185 	}
186 	/**
187    * @dev called by the owner to pause, triggers stopped state
188    */
189 	function pause() onlyContractOwner whenNotPaused public {
190 		paused = true;
191 	}
192 
193 	/**
194 	 * @dev called by the owner to resume, returns to normal state
195 	 */
196 	function resume() onlyContractOwner whenPaused public {
197 		paused = false;
198 	}
199 	/**
200 	 *
201 	 * permission checker
202 	 */
203 	modifier onlyContractOwner() {
204 		if(msg.sender != contractOwner){
205 			revert();
206 		}
207 		_;
208 	}
209 	/**
210 	* set reward for round (reward admin)
211 	*/
212 	modifier onlyRewardManager() {
213 		if(msg.sender != rewardManager && msg.sender != contractOwner){
214 			revert();
215 		}
216 		_;
217 	}
218 	/**
219 	* adjust round length (round admin)
220 	*/
221 	modifier onlyRoundManager() {
222 		if(msg.sender != roundManager && msg.sender != contractOwner){
223 			revert();
224 		}
225 		_;
226 	}
227 	/**
228 	* issue tokens to ETH addresses (issue admin)
229 	*/
230 	modifier onlyIssueManager() {
231 		if(msg.sender != issueManager && msg.sender != contractOwner){
232 			revert();
233 		}
234 		_;
235 	}
236 
237 	modifier notSelf(address _to) {
238 		if(msg.sender == _to){
239 			revert();
240 		}
241 		_;
242 	}
243 	/**
244    	* @dev Modifier to make a function callable only when the contract is not paused.
245    	*/
246 	modifier whenNotPaused() {
247 		require(!paused);
248 		_;
249 	}
250 
251 	/**
252 	 * @dev Modifier to make a function callable only when the contract is paused.
253 	 */
254 	modifier whenPaused() {
255 		require(paused);
256 		_;
257 	}
258 
259 	function getRoundBalance(address _address, uint256 _round) public view returns (uint256) {
260 		return accountBalances[_address].roundBalanceMap[_round];
261 	}
262 
263 	function isModifiedInRound(address _address, uint64 _round) public view returns (bool) {
264 		return accountBalances[_address].wasModifiedInRoundMap[_round];
265 	}
266 
267 	function getBalanceModificationRounds(address _address) public view returns (uint64[]) {
268 		return accountBalances[_address].mapKeys;
269 	}
270 
271 	//action for issue tokens
272 	function issueTokens(address _receiver, uint256 _tokenAmount) public whenNotPaused onlyIssueManager {
273 		isNewRound();
274 		issue(_receiver, _tokenAmount);
275 	}
276 
277 	function withdrawEther() public onlyContractOwner {
278 		isNewRound();
279 		if(this.balance > 0) {
280 			contractOwner.transfer(this.balance);
281 		} else {
282 			revert();
283 		}
284 	}
285 
286 	/* Send coins from owner to other address */
287 	/*Override*/
288 	function transfer(address _to, uint256 _value) public notSelf(_to) whenNotPaused returns (bool success){
289 		require(_to != address(0));
290 		//added due to backwards compatibility reasons
291 		bytes memory empty;
292 		if(isContract(_to)) {
293 			return transferToContract(msg.sender, _to, _value, empty);
294 		}
295 		else {
296 			return transferToAddress(msg.sender, _to, _value, empty);
297 		}
298 	}
299 
300 	/*Override*/
301 	function balanceOf(address _owner) public constant returns (uint256 balance) {
302 		return accountBalances[_owner].addressBalance;
303 	}
304 
305 	/*Override*/
306 	function totalSupply() public constant returns (uint256){
307 		return totalTokens;
308 	}
309 
310 	/**
311 	 * @dev Transfer tokens from one address to another
312 	 * @param _from address The address which you want to send tokens from
313 	 * @param _to address The address which you want to transfer to
314 	 * @param _value uint256 the amount of tokens to be transferred
315 	 */
316 	/*Override*/
317 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
318 		require(_to != address(0));
319 		require(_value <= allowed[_from][msg.sender]);
320 
321 		//added due to backwards compatibility reasons
322 		bytes memory empty;
323 		if(isContract(_to)) {
324 			require(transferToContract(_from, _to, _value, empty));
325 		}
326 		else {
327 			require(transferToAddress(_from, _to, _value, empty));
328 		}
329 		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
330 		return true;
331 	}
332 
333 	/**
334 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
335 	 *
336 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
337 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
338 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
339 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
340 	 * @param _spender The address which will spend the funds.
341 	 * @param _value The amount of tokens to be spent.
342 	 */
343 	/*Override*/
344 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
345 		allowed[msg.sender][_spender] = _value;
346 		Approval(msg.sender, _spender, _value);
347 		return true;
348 	}
349 
350 	/**
351 	  * @dev Function to check the amount of tokens that an owner allowed to a spender.
352 	  * @param _owner address The address which owns the funds.
353 	  * @param _spender address The address which will spend the funds.
354 	  * @return A uint256 specifying the amount of tokens still available for the spender.
355 	  */
356 	/*Override*/
357 	function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256) {
358 		return allowed[_owner][_spender];
359 	}
360 
361 	/**
362 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
363 	 *
364 	 * approve should be called when allowed[_spender] == 0. To increment
365 	 * allowed value is better to use this function to avoid 2 calls (and wait until
366 	 * the first transaction is mined)
367 	 * From MonolithDAO Token.sol
368 	 * @param _spender The address which will spend the funds.
369 	 * @param _addedValue The amount of tokens to increase the allowance by.
370 	 */
371 
372 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
373 		allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
374 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
375 		return true;
376 	}
377 
378 	/**
379 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
380 	 *
381 	 * approve should be called when allowed[_spender] == 0. To decrement
382 	 * allowed value is better to use this function to avoid 2 calls (and wait until
383 	 * the first transaction is mined)
384 	 * From MonolithDAO Token.sol
385 	 * @param _spender The address which will spend the funds.
386 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
387 	 */
388 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
389 		uint256 oldValue = allowed[msg.sender][_spender];
390 		if (_subtractedValue > oldValue) {
391 			allowed[msg.sender][_spender] = 0;
392 		} else {
393 			allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
394 		}
395 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
396 		return true;
397 	}
398 
399 	// Function that is called when a user or another contract wants to transfer funds .
400 	/*Override*/
401 	function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused notSelf(_to) returns (bool success){
402 		require(_to != address(0));
403 		if(isContract(_to)) {
404 			return transferToContract(msg.sender, _to, _value, _data);
405 		}
406 		else {
407 			return transferToAddress(msg.sender, _to, _value, _data);
408 		}
409 	}
410 
411 	// Function that is called when a user or another contract wants to transfer funds.
412 	/*Override*/
413 	function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public whenNotPaused notSelf(_to) returns (bool success){
414 		require(_to != address(0));
415 		if(isContract(_to)) {
416 			if(accountBalances[msg.sender].addressBalance < _value){		// Check if the sender has enough
417 				revert();
418 			}
419 			if(safeAdd(accountBalances[_to].addressBalance, _value) < accountBalances[_to].addressBalance){		// Check for overflows
420 				revert();
421 			}
422 
423 			isNewRound();
424 			subFromAddressBalancesInfo(msg.sender, _value);	// Subtract from the sender
425 			addToAddressBalancesInfo(_to, _value);	// Add the same to the recipient
426 
427 			assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
428 
429 			/* Notify anyone listening that this transfer took place */
430 			Transfer(msg.sender, _to, _value, _data);
431 			Transfer(msg.sender, _to, _value);
432 			return true;
433 		}
434 		else {
435 			return transferToAddress(msg.sender, _to, _value, _data);
436 		}
437 	}
438 
439 	function claimReward() public whenNotPaused returns (uint256 rewardAmountInWei) {
440 		isNewRound();
441 		return claimRewardTillRound(currentRound);
442 	}
443 
444 	function claimRewardTillRound(uint64 _claimTillRound) public whenNotPaused returns (uint256 rewardAmountInWei) {
445 		isNewRound();
446 		rewardAmountInWei = calculateClaimableRewardTillRound(msg.sender, _claimTillRound);
447 		accountBalances[msg.sender].claimedRewardTillRound = _claimTillRound;
448 
449 		if (rewardAmountInWei > 0){
450 			accountBalances[msg.sender].totalClaimedReward = safeAdd(accountBalances[msg.sender].totalClaimedReward, rewardAmountInWei);
451 			msg.sender.transfer(rewardAmountInWei);
452 		}
453 
454 		return rewardAmountInWei;
455 	}
456 
457 	function calculateClaimableReward(address _address) public constant returns (uint256 rewardAmountInWei) {
458 		return calculateClaimableRewardTillRound(_address, currentRound);
459 	}
460 
461 	function calculateClaimableRewardTillRound(address _address, uint64 _claimTillRound) public constant returns (uint256) {
462 		uint256 rewardAmountInWei = 0;
463 
464 		if (_claimTillRound > currentRound) { revert(); }
465 		if (currentRound < 1) { revert(); }
466 
467 		AddressBalanceInfoStructure storage accountBalanceInfo = accountBalances[_address];
468 		if(accountBalanceInfo.mapKeys.length == 0){	revert(); }
469 
470 		uint64 userLastClaimedRewardRound = accountBalanceInfo.claimedRewardTillRound;
471 		if (_claimTillRound < userLastClaimedRewardRound) { revert(); }
472 
473 		for (uint64 workRound = userLastClaimedRewardRound; workRound < _claimTillRound; workRound++) {
474 
475 			Reward storage rewardInfo = reward[workRound];
476 			assert(rewardInfo.isConfigured); //don't allow to withdraw reward if affected reward is not configured
477 
478 			if(accountBalanceInfo.wasModifiedInRoundMap[workRound]){
479 				rewardAmountInWei = safeAdd(rewardAmountInWei, safeMul(accountBalanceInfo.roundBalanceMap[workRound], rewardInfo.rewardRate));
480 			} else {
481 				uint64 lastBalanceModifiedRound = 0;
482 				for (uint256 i = accountBalanceInfo.mapKeys.length; i > 0; i--) {
483 					uint64 modificationInRound = accountBalanceInfo.mapKeys[i-1];
484 					if (modificationInRound <= workRound) {
485 						lastBalanceModifiedRound = modificationInRound;
486 						break;
487 					}
488 				}
489 				rewardAmountInWei = safeAdd(rewardAmountInWei, safeMul(accountBalanceInfo.roundBalanceMap[lastBalanceModifiedRound], rewardInfo.rewardRate));
490 			}
491 		}
492 		return rewardAmountInWei;
493 	}
494 
495 	function createRounds(uint256 maxRounds) public {
496 		uint256 blocksAfterLastRound = safeSub(block.number, lastBlockNumberInRound);	//current block number - last round block number = blocks after last round
497 
498 		if(blocksAfterLastRound >= blocksPerRound){	// need to increase reward round if blocks after last round is greater or equal blocks per round
499 
500 			uint256 roundsNeedToCreate = safeDiv(blocksAfterLastRound, blocksPerRound);	//calculate how many rounds need to create
501 			if(roundsNeedToCreate > maxRounds){
502 				roundsNeedToCreate = maxRounds;
503 			}
504 			lastBlockNumberInRound = safeAdd(lastBlockNumberInRound, safeMul(roundsNeedToCreate, blocksPerRound));
505 			for (uint256 i = 0; i < roundsNeedToCreate; i++) {
506 				updateRoundInformation();
507 			}
508 		}
509 	}
510 
511 	// Private functions
512 	//assemble the given address bytecode. If bytecode exists then the _address is a contract.
513 	function isContract(address _address) private view returns (bool is_contract) {
514 		uint256 length;
515 		assembly {
516 		//retrieve the size of the code on target address, this needs assembly
517 			length := extcodesize(_address)
518 		}
519 		return (length > 0);
520 	}
521 
522 	function isNewRound() private {
523 		uint256 blocksAfterLastRound = safeSub(block.number, lastBlockNumberInRound);	//current block number - last round block number = blocks after last round
524 		if(blocksAfterLastRound >= blocksPerRound){	// need to increase reward round if blocks after last round is greater or equal blocks per round
525 			updateRoundsInformation(blocksAfterLastRound);
526 		}
527 	}
528 
529 	function updateRoundsInformation(uint256 _blocksAfterLastRound) private {
530 		uint256 roundsNeedToCreate = safeDiv(_blocksAfterLastRound, blocksPerRound);	//calculate how many rounds need to create
531 		lastBlockNumberInRound = safeAdd(lastBlockNumberInRound, safeMul(roundsNeedToCreate, blocksPerRound));	//calculate last round creation block number
532 		for (uint256 i = 0; i < roundsNeedToCreate; i++) {
533 			updateRoundInformation();
534 		}
535 	}
536 
537 	function updateRoundInformation() private {
538 		issuedTokensInRound[currentRound] = issued;
539 
540 		Reward storage rewardInfo = reward[currentRound];
541 		rewardInfo.roundNumber = currentRound;
542 
543 		currentRound = currentRound + 1;
544 	}
545 
546 	function issue(address _receiver, uint256 _tokenAmount) private {
547 		if(_tokenAmount == 0){
548 			revert();
549 		}
550 		uint256 newIssuedAmount = safeAdd(_tokenAmount, issued);
551 		if(newIssuedAmount > totalTokens){
552 			revert();
553 		}
554 		addToAddressBalancesInfo(_receiver, _tokenAmount);
555 		issued = newIssuedAmount;
556 		bytes memory empty;
557 		if(isContract(_receiver)) {
558 			ContractReceiver receiverContract = ContractReceiver(_receiver);
559 			receiverContract.tokenFallback(msg.sender, _tokenAmount, empty);
560 		}
561 		/* Notify anyone listening that this transfer took place */
562 		Transfer(msg.sender, _receiver, _tokenAmount, empty);
563 		Transfer(msg.sender, _receiver, _tokenAmount);
564 	}
565 
566 	function addToAddressBalancesInfo(address _receiver, uint256 _tokenAmount) private {
567 		AddressBalanceInfoStructure storage accountBalance = accountBalances[_receiver];
568 
569 		if(!accountBalance.wasModifiedInRoundMap[currentRound]){	//allow just push one time per round
570 			// If user first time get update balance set user claimed reward round to round before.
571 			if(accountBalance.mapKeys.length == 0 && currentRound > 0){
572 				accountBalance.claimedRewardTillRound = currentRound;
573 			}
574 			accountBalance.mapKeys.push(currentRound);
575 			accountBalance.wasModifiedInRoundMap[currentRound] = true;
576 		}
577 		accountBalance.addressBalance = safeAdd(accountBalance.addressBalance, _tokenAmount);
578 		accountBalance.roundBalanceMap[currentRound] = accountBalance.addressBalance;
579 	}
580 
581 	function subFromAddressBalancesInfo(address _adr, uint256 _tokenAmount) private {
582 		AddressBalanceInfoStructure storage accountBalance = accountBalances[_adr];
583 		if(!accountBalance.wasModifiedInRoundMap[currentRound]){	//allow just push one time per round
584 			accountBalance.mapKeys.push(currentRound);
585 			accountBalance.wasModifiedInRoundMap[currentRound] = true;
586 		}
587 		accountBalance.addressBalance = safeSub(accountBalance.addressBalance, _tokenAmount);
588 		accountBalance.roundBalanceMap[currentRound] = accountBalance.addressBalance;
589 	}
590 	//function that is called when transaction target is an address
591 	function transferToAddress(address _from, address _to, uint256 _value, bytes _data) private returns (bool success) {
592 		if(accountBalances[_from].addressBalance < _value){		// Check if the sender has enough
593 			revert();
594 		}
595 		if(safeAdd(accountBalances[_to].addressBalance, _value) < accountBalances[_to].addressBalance){		// Check for overflows
596 			revert();
597 		}
598 
599 		isNewRound();
600 		subFromAddressBalancesInfo(_from, _value);	// Subtract from the sender
601 		addToAddressBalancesInfo(_to, _value);	// Add the same to the recipient
602 
603 		/* Notify anyone listening that this transfer took place */
604 		Transfer(_from, _to, _value, _data);
605 		Transfer(_from, _to, _value);
606 		return true;
607 	}
608 
609 	//function that is called when transaction target is a contract
610 	function transferToContract(address _from, address _to, uint256 _value, bytes _data) private returns (bool success) {
611 		if(accountBalances[_from].addressBalance < _value){		// Check if the sender has enough
612 			revert();
613 		}
614 		if(safeAdd(accountBalances[_to].addressBalance, _value) < accountBalances[_to].addressBalance){		// Check for overflows
615 			revert();
616 		}
617 
618 		isNewRound();
619 		subFromAddressBalancesInfo(_from, _value);	// Subtract from the sender
620 		addToAddressBalancesInfo(_to, _value);	// Add the same to the recipient
621 
622 		ContractReceiver receiver = ContractReceiver(_to);
623 		receiver.tokenFallback(_from, _value, _data);
624 
625 		/* Notify anyone listening that this transfer took place */
626 		Transfer(_from, _to, _value, _data);
627 		Transfer(_from, _to, _value);
628 		return true;
629 	}
630 }