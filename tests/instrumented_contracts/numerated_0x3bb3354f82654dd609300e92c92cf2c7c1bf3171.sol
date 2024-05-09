1 // MarketPay-System-1.2.sol
2 
3 /*
4 MarketPay Solidity Libraries
5 developed by:
6 	MarketPay.io , 2018
7 	https://marketpay.io/
8 	https://goo.gl/kdECQu
9 
10 v1.2 
11 	+ Haltable by SC owner
12 	+ Constructors upgraded to new syntax
13 	
14 v1.1 
15 	+ Upgraded to Solidity 0.4.22
16 	
17 v1.0
18 	+ System functions
19 
20 */
21 
22 pragma solidity ^0.4.23;
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30 	/**
31     * @dev Multiplies two numbers, throws on overflow.
32     */
33 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
34 		if (a == 0) {
35 			return 0;
36 		}
37 		c = a * b;
38 		assert(c / a == b);
39 		return c;
40 	}
41 
42 	/**
43     * @dev Integer division of two numbers, truncating the quotient.
44     */
45 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
46 		// assert(b > 0); // Solidity automatically throws when dividing by 0
47 		// uint256 c = a / b;
48 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 		return a / b;
50 	}
51 
52 	/**
53     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54     */
55 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56 		assert(b <= a);
57 		return a - b;
58 	}
59 
60 	/**
61     * @dev Adds two numbers, throws on overflow.
62     */
63 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
64 		c = a + b;
65 		assert(c >= a);
66 		return c;
67 	}
68 }
69 /**
70  * @title System
71  * @dev Abstract contract that includes some useful generic functions.
72  * @author https://marketpay.io/ & https://goo.gl/kdECQu
73  */
74 contract System {
75 	using SafeMath for uint256;
76 	
77 	address owner;
78 	
79 	// **** MODIFIERS
80 
81 	// @notice To limit functions usage to contract owner
82 	modifier onlyOwner() {
83 		if (msg.sender != owner) {
84 			error('System: onlyOwner function called by user that is not owner');
85 		} else {
86 			_;
87 		}
88 	}
89 
90 	// **** FUNCTIONS
91 	
92 	// @notice Calls whenever an error occurs, logs it or reverts transaction
93 	function error(string _error) internal {
94 		revert(_error);
95 		// in case revert with error msg is not yet fully supported
96 		//	emit Error(_error);
97 		// throw;
98 	}
99 
100 	// @notice For debugging purposes when using solidity online browser, remix and sandboxes
101 	function whoAmI() public constant returns (address) {
102 		return msg.sender;
103 	}
104 	
105 	// @notice Get the current timestamp from last mined block
106 	function timestamp() public constant returns (uint256) {
107 		return block.timestamp;
108 	}
109 	
110 	// @notice Get the balance in weis of this contract
111 	function contractBalance() public constant returns (uint256) {
112 		return address(this).balance;
113 	}
114 	
115 	// @notice System constructor, defines owner
116 	constructor() public {
117 		// This is the constructor, so owner should be equal to msg.sender, and this method should be called just once
118 		owner = msg.sender;
119 		
120 		// make sure owner address is configured
121 		if(owner == 0x0) error('System constructor: Owner address is 0x0'); // Never should happen, but just in case...
122 	}
123 	
124 	// **** EVENTS
125 
126 	// @notice A generic error log
127 	event Error(string _error);
128 
129 	// @notice For debug purposes
130 	event DebugUint256(uint256 _data);
131 
132 }
133 
134 /**
135  * @title Haltable
136  * @dev Abstract contract that allows children to implement an emergency stop mechanism.
137  */
138 contract Haltable is System {
139 	bool public halted;
140 	
141 	// **** MODIFIERS
142 
143 	modifier stopInEmergency {
144 		if (halted) {
145 			error('Haltable: stopInEmergency function called and contract is halted');
146 		} else {
147 			_;
148 		}
149 	}
150 
151 	modifier onlyInEmergency {
152 		if (!halted) {
153 			error('Haltable: onlyInEmergency function called and contract is not halted');
154 		} {
155 			_;
156 		}
157 	}
158 
159 	// **** FUNCTIONS
160 	
161 	// called by the owner on emergency, triggers stopped state
162 	function halt() external onlyOwner {
163 		halted = true;
164 		emit Halt(true, msg.sender, timestamp()); // Event log
165 	}
166 
167 	// called by the owner on end of emergency, returns to normal state
168 	function unhalt() external onlyOwner onlyInEmergency {
169 		halted = false;
170 		emit Halt(false, msg.sender, timestamp()); // Event log
171 	}
172 	
173 	// **** EVENTS
174 	// @notice Triggered when owner halts contract
175 	event Halt(bool _switch, address _halter, uint256 _timestamp);
176 }
177 
178 /**
179  * @title Hardcoded Wallets
180  * @notice This contract is used to define oracle wallets
181  * @author https://marketpay.io/ & https://goo.gl/kdECQu
182  */
183 contract HardcodedWallets {
184 	// **** DATA
185 
186 	address public walletFounder1; // founder #1 wallet, CEO, compulsory
187 	address public walletFounder2; // founder #2 wallet
188 	address public walletFounder3; // founder #3 wallet
189 	address public walletCommunityReserve;	// Distribution wallet
190 	address public walletCompanyReserve;	// Distribution wallet
191 	address public walletTeamAdvisors;		// Distribution wallet
192 	address public walletBountyProgram;		// Distribution wallet
193 
194 
195 	// **** FUNCTIONS
196 
197 	/**
198 	 * @notice Constructor, set up the compliance officer oracle wallet
199 	 */
200 	constructor() public {
201 		// set up the founders' oracle wallets
202 		walletFounder1             = 0x5E69332F57Ac45F5fCA43B6b007E8A7b138c2938; // founder #1 (CEO) wallet
203 		walletFounder2             = 0x852f9a94a29d68CB95Bf39065BED6121ABf87607; // founder #2 wallet
204 		walletFounder3             = 0x0a339965e52dF2c6253989F5E9173f1F11842D83; // founder #3 wallet
205 
206 		// set up the wallets for distribution of the total supply of tokens
207 		walletCommunityReserve = 0xB79116a062939534042d932fe5DF035E68576547;
208 		walletCompanyReserve = 0xA6845689FE819f2f73a6b9C6B0D30aD6b4a006d8;
209 		walletTeamAdvisors = 0x0227038b2560dF1abf3F8C906016Af0040bc894a;
210 		walletBountyProgram = 0xdd401Df9a049F6788cA78b944c64D21760757D73;
211 
212 	}
213 }
214 
215 // Minimal interface of ERC20 token contract, just to cast the contract address and make it callable from the ICO and other contracts
216 contract ERC20 {
217 	function balanceOf(address _owner) public constant returns (uint256 balance);
218 	function transfer(address _to, uint256 _amount) public returns (bool success);
219 	function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
220 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
221 	function totalSupply() public constant returns (uint);
222 }
223 
224 /**
225  * @title Escrow
226  * @author https://marketpay.io/ & https://goo.gl/kdECQu
227  */
228 contract Escrow is System, HardcodedWallets {
229 	using SafeMath for uint256;
230 
231 	// **** DATA
232 	mapping (address => uint256) public deposited;
233 	uint256 nextStage;
234 
235 	// Circular reference to ICO contract
236 	address public addressSCICO;
237 
238 	// Circular reference to Tokens contract
239 	address public addressSCTokens;
240 	Tokens public SCTokens;
241 
242 
243 	// **** FUNCTIONS
244 
245 	/**
246 	 * @notice Constructor, set up the state
247 	 */
248 	constructor() public {
249 		// copy totalSupply from Tokens to save gas
250 		uint256 totalSupply = 1350000000 ether;
251 
252 
253 		deposited[this] = totalSupply.mul(50).div(100);
254 		deposited[walletCommunityReserve] = totalSupply.mul(20).div(100);
255 		deposited[walletCompanyReserve] = totalSupply.mul(14).div(100);
256 		deposited[walletTeamAdvisors] = totalSupply.mul(15).div(100);
257 		deposited[walletBountyProgram] = totalSupply.mul(1).div(100);
258 	}
259 
260 	function deposit(uint256 _amount) public returns (bool) {
261 		// only ICO could deposit
262 		if (msg.sender != addressSCICO) {
263 			error('Escrow: not allowed to deposit');
264 			return false;
265 		}
266 		deposited[this] = deposited[this].add(_amount);
267 		return true;
268 	}
269 
270 	/**
271 	 * @notice Withdraw funds from the tokens contract
272 	 */
273 	function withdraw(address _address, uint256 _amount) public onlyOwner returns (bool) {
274 		if (deposited[_address]<_amount) {
275 			error('Escrow: not enough balance');
276 			return false;
277 		}
278 		deposited[_address] = deposited[_address].sub(_amount);
279 		return SCTokens.transfer(_address, _amount);
280 	}
281 
282 	/**
283 	 * @notice Withdraw funds from the tokens contract
284 	 */
285 	function fundICO(uint256 _amount, uint8 _stage) public returns (bool) {
286 		if(nextStage !=_stage) {
287 			error('Escrow: ICO stage already funded');
288 			return false;
289 		}
290 
291 		if (msg.sender != addressSCICO || tx.origin != owner) {
292 			error('Escrow: not allowed to fund the ICO');
293 			return false;
294 		}
295 		if (deposited[this]<_amount) {
296 			error('Escrow: not enough balance');
297 			return false;
298 		}
299 		bool success = SCTokens.transfer(addressSCICO, _amount);
300 		if(success) {
301 			deposited[this] = deposited[this].sub(_amount);
302 			nextStage++;
303 			emit FundICO(addressSCICO, _amount);
304 		}
305 		return success;
306 	}
307 
308 	/**
309  	* @notice The owner can specify which ICO contract is allowed to transfer tokens while timelock is on
310  	*/
311 	function setMyICOContract(address _SCICO) public onlyOwner {
312 		addressSCICO = _SCICO;
313 	}
314 
315 	/**
316  	* @notice Set the tokens contract
317  	*/
318 	function setTokensContract(address _addressSCTokens) public onlyOwner {
319 		addressSCTokens = _addressSCTokens;
320 		SCTokens = Tokens(_addressSCTokens);
321 	}
322 
323 	/**
324 	 * @notice Returns balance of given address
325 	 */
326 	function balanceOf(address _address) public constant returns (uint256 balance) {
327 		return deposited[_address];
328 	}
329 
330 
331 	// **** EVENTS
332 
333 	// Triggered when an investor buys some tokens directly with Ethers
334 	event FundICO(address indexed _addressICO, uint256 _amount);
335 
336 
337 }
338 
339 contract ComplianceService {
340 	function validate(address _from, address _to, uint256 _amount) public returns (bool allowed) {
341 		return true;
342 	}
343 }
344 
345 
346 
347 /**
348  * @title Tokens
349  * @notice ERC20 implementation of TRT tokens
350  * @author https://marketpay.io/ & https://goo.gl/kdECQu
351  */
352 contract Tokens is HardcodedWallets, ERC20, Haltable {
353 
354 	// **** DATA
355 
356 	mapping (address => uint256) balances;
357 	mapping (address => mapping (address => uint256)) allowed;
358 	uint256 public _totalSupply; 
359 
360 	// Public variables of the token, all used for display
361 	string public name;
362 	string public symbol;
363 	uint8 public decimals;
364 	string public standard = 'H0.1'; // HumanStandardToken is a specialisation of ERC20 defining these parameters
365 
366 	// Timelock
367 	uint256 public timelockEndTime;
368 
369 	// Circular reference to ICO contract
370 	address public addressSCICO;
371 
372 	// Circular reference to Escrow contract
373 	address public addressSCEscrow;
374 
375 	// Reference to ComplianceService contract
376 	address public addressSCComplianceService;
377 	ComplianceService public SCComplianceService;
378 
379 	// **** MODIFIERS
380 
381 	// @notice To limit token transfers while timelocked
382 	modifier notTimeLocked() {
383 		if (now < timelockEndTime && msg.sender != addressSCICO && msg.sender != addressSCEscrow) {
384 			error('notTimeLocked: Timelock still active. Function is yet unavailable.');
385 		} else {
386 			_;
387 		}
388 	}
389 
390 
391 	// **** FUNCTIONS
392 	/**
393 	 * @notice Constructor: set up token properties and owner token balance
394 	 */
395 	constructor(address _addressSCEscrow, address _addressSCComplianceService) public {
396 		name = "TheRentalsToken";
397 		symbol = "TRT";
398 		decimals = 18; // 18 decimal places, the same as ETH
399 
400 		// initialSupply = 2000000000 ether; // 2018-04-21: ICO summary.docx: ...Dicho valor generaría un Total Supply de 2.000 millones de TRT.
401         _totalSupply = 1350000000 ether; // 2018-05-10: alvaro.ariet@lacomunity.com ...tenemos una emisión de 1.350 millones de Tokens
402 
403 		timelockEndTime = timestamp().add(45 days); // Default timelock
404 
405 		addressSCEscrow = _addressSCEscrow;
406 		addressSCComplianceService = _addressSCComplianceService;
407 		SCComplianceService = ComplianceService(addressSCComplianceService);
408 
409 		// Token distribution
410 		balances[_addressSCEscrow] = _totalSupply;
411 		emit Transfer(0x0, _addressSCEscrow, _totalSupply);
412 
413 	}
414 
415     /**
416      * @notice Get the token total supply
417      */
418     function totalSupply() public constant returns (uint) {
419 
420         return _totalSupply  - balances[address(0)];
421 
422     }
423 
424 	/**
425 	 * @notice Get the token balance of a wallet with address _owner
426 	 */
427 	function balanceOf(address _owner) public constant returns (uint256 balance) {
428 		return balances[_owner];
429 	}
430 
431 	/**
432 	 * @notice Send _amount amount of tokens to address _to
433 	 */
434 	function transfer(address _to, uint256 _amount) public notTimeLocked stopInEmergency returns (bool success) {
435 		if (balances[msg.sender] < _amount) {
436 			error('transfer: the amount to transfer is higher than your token balance');
437 			return false;
438 		}
439 
440 		if(!SCComplianceService.validate(msg.sender, _to, _amount)) {
441 			error('transfer: not allowed by the compliance service');
442 			return false;
443 		}
444 
445 		balances[msg.sender] = balances[msg.sender].sub(_amount);
446 		balances[_to] = balances[_to].add(_amount);
447 		emit Transfer(msg.sender, _to, _amount); // Event log
448 
449 		return true;
450 	}
451 
452 	/**
453 	 * @notice Send _amount amount of tokens from address _from to address _to
454  	 * @notice The transferFrom method is used for a withdraw workflow, allowing contracts to send 
455  	 * @notice tokens on your behalf, for example to "deposit" to a contract address and/or to charge 
456  	 * @notice fees in sub-currencies; the command should fail unless the _from account has 
457  	 * @notice deliberately authorized the sender of the message via some mechanism
458  	 */
459 	function transferFrom(address _from, address _to, uint256 _amount) public notTimeLocked stopInEmergency returns (bool success) {
460 		if (balances[_from] < _amount) {
461 			error('transferFrom: the amount to transfer is higher than the token balance of the source');
462 			return false;
463 		}
464 		if (allowed[_from][msg.sender] < _amount) {
465 			error('transferFrom: the amount to transfer is higher than the maximum token transfer allowed by the source');
466 			return false;
467 		}
468 
469 		if(!SCComplianceService.validate(_from, _to, _amount)) {
470 			error('transfer: not allowed by the compliance service');
471 			return false;
472 		}
473 
474 		balances[_from] = balances[_from].sub(_amount);
475 		balances[_to] = balances[_to].add(_amount);
476 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
477 		emit Transfer(_from, _to, _amount); // Event log
478 
479 		return true;
480 	}
481 
482 	/**
483 	 * @notice Allow _spender to withdraw from your account, multiple times, up to the _amount amount. 
484  	 * @notice If this function is called again it overwrites the current allowance with _amount.
485 	 */
486 	function approve(address _spender, uint256 _amount) public returns (bool success) {
487 		allowed[msg.sender][_spender] = _amount;
488 		emit Approval(msg.sender, _spender, _amount); // Event log
489 
490 		return true;
491 	}
492 
493 	/**
494 	 * @notice Returns the amount which _spender is still allowed to withdraw from _owner
495 	 */
496 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
497 		return allowed[_owner][_spender];
498 	}
499 
500 	/**
501        * @dev Increase the amount of tokens that an owner allowed to a spender.
502        *
503        * approve should be called when allowed[_spender] == 0. To increment
504        * allowed value is better to use this function to avoid 2 calls (and wait until
505        * the first transaction is mined)
506        * From MonolithDAO Token.sol
507        * @param _spender The address which will spend the funds.
508        * @param _addedValue The amount of tokens to increase the allowance by.
509        */
510 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
511 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
512 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
513 		return true;
514 	}
515 
516 	/**
517      * @dev Decrease the amount of tokens that an owner allowed to a spender.
518      *
519      * approve should be called when allowed[_spender] == 0. To decrement
520      * allowed value is better to use this function to avoid 2 calls (and wait until
521      * the first transaction is mined)
522      * From MonolithDAO Token.sol
523      * @param _spender The address which will spend the funds.
524      * @param _subtractedValue The amount of tokens to decrease the allowance by.
525      */
526 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
527 		uint oldValue = allowed[msg.sender][_spender];
528 		if (_subtractedValue > oldValue) {
529 			allowed[msg.sender][_spender] = 0;
530 		} else {
531 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
532 		}
533 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
534 		return true;
535 	}
536 	
537 	/**
538 	 * @notice This is out of ERC20 standard but it is necessary to build market escrow contracts of assets
539 	 * @notice Send _amount amount of tokens to from tx.origin to address _to
540 	 */
541 	function refundTokens(address _from, uint256 _amount) public notTimeLocked stopInEmergency returns (bool success) {
542         if (tx.origin != _from) {
543             error('refundTokens: tx.origin did not request the refund directly');
544             return false;
545         }
546 
547         if (addressSCICO != msg.sender) {
548             error('refundTokens: caller is not the current ICO address');
549             return false;
550         }
551 
552         if (balances[_from] < _amount) {
553             error('refundTokens: the amount to transfer is higher than your token balance');
554             return false;
555         }
556 
557         if(!SCComplianceService.validate(_from, addressSCICO, _amount)) {
558 			error('transfer: not allowed by the compliance service');
559 			return false;
560 		}
561 
562 		balances[_from] = balances[_from].sub(_amount);
563 		balances[addressSCICO] = balances[addressSCICO].add(_amount);
564 		emit Transfer(_from, addressSCICO, _amount); // Event log
565 
566 		return true;
567 	}
568 
569 	/**
570 	 * @notice The owner can specify which ICO contract is allowed to transfer tokens while timelock is on
571 	 */
572 	function setMyICOContract(address _SCICO) public onlyOwner {
573 		addressSCICO = _SCICO;
574 	}
575 
576 	function setComplianceService(address _addressSCComplianceService) public onlyOwner {
577 		addressSCComplianceService = _addressSCComplianceService;
578 		SCComplianceService = ComplianceService(addressSCComplianceService);
579 	}
580 
581 	/**
582 	 * @notice Called by owner to alter the token timelock
583 	 */
584 	function updateTimeLock(uint256 _timelockEndTime) onlyOwner public returns (bool) {
585 		timelockEndTime = _timelockEndTime;
586 
587 		emit UpdateTimeLock(_timelockEndTime); // Event log
588 
589 		return true;
590 	}
591 
592 
593 	// **** EVENTS
594 
595 	// Triggered when tokens are transferred
596 	event Transfer(address indexed _from, address indexed _to, uint256 _amount);
597 
598 	// Triggered when someone approves a spender to move its tokens
599 	event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
600 
601 	// Triggered when Owner updates token timelock
602 	event UpdateTimeLock(uint256 _timelockEndTime);
603 }