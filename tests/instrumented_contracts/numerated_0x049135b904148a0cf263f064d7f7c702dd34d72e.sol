1 pragma solidity ^ 0.4.21;
2 
3 pragma solidity ^0.4.10;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 pragma solidity ^0.4.10;
38 
39 interface ERC20 {
40   function balanceOf(address who) view returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   function allowance(address owner, address spender) view returns (uint256);
43   function transferFrom(address from, address to, uint256 value) returns (bool);
44   function approve(address spender, uint256 value) returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 pragma solidity ^0.4.10;
49 
50 interface ERC223 {
51     function transfer(address to, uint value, bytes data) returns (bool);
52     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
53 }
54 pragma solidity ^0.4.10;
55 
56 contract ERC223ReceivingContract { 
57     function tokenFallback(address _from, uint _value, bytes _data) public;
58 }
59 
60 pragma solidity ^0.4.21;
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68 	address public owner;
69 
70 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72 	/**
73 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74 	 * account.
75 	 */
76 	function Ownable()public {
77 		owner = msg.sender;
78 	}
79 
80 	/**
81 	 * @dev Throws if called by any account other than the owner.
82 	 */
83 	modifier onlyOwner() {
84 		require(msg.sender == owner);
85 		_;
86 	}
87 
88 	/**
89 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
90 	 * @param newOwner The address to transfer ownership to.
91 	 */
92 	function transferOwnership(address newOwner)public onlyOwner {
93 		require(newOwner != address(0));
94 		emit OwnershipTransferred(owner, newOwner);
95 		owner = newOwner;
96 	}
97 
98 }
99 
100 pragma solidity ^0.4.21;
101 
102 /**
103  * @title RefundVault
104  * @dev This contract is used for storing funds while a crowdsale
105  * is in progress. Supports refunding the money if crowdsale fails,
106  * and forwarding it if crowdsale is successful.
107  */
108 contract RefundVault is Ownable {
109 	using SafeMath for uint256;
110 
111 	enum State {
112 		Active,
113 		Refunding,
114 		Closed
115 	}
116 
117 	mapping(address => uint256)public deposited;
118 	address public wallet;
119 	State public state;
120 
121 	event Closed();
122 	event RefundsEnabled();
123 	event Refunded(address indexed beneficiary, uint256 weiAmount);
124 
125 	/**
126 	 * @param _wallet Vault address
127 	 */
128 	function RefundVault(address _wallet)public {
129 		require(_wallet != address(0));
130 		wallet = _wallet;
131 		state = State.Active;
132 	}
133 
134 	/**
135 	 * @param investor Investor address
136 	 */
137 	function deposit(address investor)onlyOwner public payable {
138 		require(state == State.Active);
139 		deposited[investor] = deposited[investor].add(msg.value);
140 	}
141 
142 	function close()onlyOwner public {
143 		require(state == State.Active);
144 		state = State.Closed;
145 		emit Closed();
146 		wallet.transfer(address(this).balance);
147 	}
148 
149 	function enableRefunds()onlyOwner public {
150 		require(state == State.Active);
151 		state = State.Refunding;
152 		emit RefundsEnabled();
153 	}
154 
155 	/**
156 	 * @param investor Investor address
157 	 */
158 	function refund(address investor)public {
159 		require(state == State.Refunding);
160 		uint256 depositedValue = deposited[investor];
161 		deposited[investor] = 0;
162 		investor.transfer(depositedValue);
163 		emit Refunded(investor, depositedValue);
164 	}
165 }
166 pragma solidity ^0.4.21;
167 
168 /**
169  * @title BonusScheme
170  * @dev This contract is used for storing and granting tokens calculated 
171  * according to bonus scheme while a crowdsale is in progress.
172  * When crowdsale ends the rest of tokens is transferred to developers.
173  */
174 contract BonusScheme is Ownable {
175 	using SafeMath for uint256;
176 
177 	/**
178 	* Defining timestamps for bonuscheme from White Paper. 
179 	* The start of bonuses is 15 May 2018 and the end is 23 June 2018. 
180 	* There are 2 seconds in between changing the phases.  */
181 	uint256 startOfFirstBonus = 1526021400;
182 	uint256 endOfFirstBonus = (startOfFirstBonus - 1) + 5 minutes;	
183 	uint256 startOfSecondBonus = (startOfFirstBonus + 1) + 5 minutes;
184 	uint256 endOfSecondBonus = (startOfSecondBonus - 1) + 5 minutes;
185 	uint256 startOfThirdBonus = (startOfSecondBonus + 1) + 5 minutes;
186 	uint256 endOfThirdBonus = (startOfThirdBonus - 1) + 5 minutes;
187 	uint256 startOfFourthBonus = (startOfThirdBonus + 1) + 5 minutes;
188 	uint256 endOfFourthBonus = (startOfFourthBonus - 1) + 5 minutes;
189 	uint256 startOfFifthBonus = (startOfFourthBonus + 1) + 5 minutes;
190 	uint256 endOfFifthBonus = (startOfFifthBonus - 1) + 5 minutes;
191 	
192 	/**
193 	* Defining bonuses according to White Paper.
194 	* First week there is bonus 35%.
195 	* Second week there is bonus 30%.
196 	* Third week there is bonus 20%.
197 	* Fourth week there is bonus 10%.
198 	* Fifth week there is bonus 5%.
199 	*/
200 	uint256 firstBonus = 35;
201 	uint256 secondBonus = 30;
202 	uint256 thirdBonus = 20;
203 	uint256 fourthBonus = 10;
204 	uint256 fifthBonus = 5;
205 
206 	event BonusCalculated(uint256 tokenAmount);
207 
208     function BonusScheme() public {
209         
210     }
211 
212 	/**
213 	 * @dev Calculates from Bonus Scheme how many tokens can be added to purchased _tokenAmount.
214 	 * @param _tokenAmount The amount of calculated tokens to sent Ether.
215 	 * @return Number of bonus tokens that can be granted with the specified _tokenAmount.
216 	 */
217 	function getBonusTokens(uint256 _tokenAmount)onlyOwner public returns(uint256) {
218 		if (block.timestamp >= startOfFirstBonus && block.timestamp <= endOfFirstBonus) {
219 			_tokenAmount = _tokenAmount.mul(firstBonus).div(100);
220 		} else if (block.timestamp >= startOfSecondBonus && block.timestamp <= endOfSecondBonus) {
221 			_tokenAmount = _tokenAmount.mul(secondBonus).div(100);
222 		} else if (block.timestamp >= startOfThirdBonus && block.timestamp <= endOfThirdBonus) {
223 			_tokenAmount = _tokenAmount.mul(thirdBonus).div(100);
224 		} else if (block.timestamp >= startOfFourthBonus && block.timestamp <= endOfFourthBonus) {
225 			_tokenAmount = _tokenAmount.mul(fourthBonus).div(100);
226 		} else if (block.timestamp >= startOfFifthBonus && block.timestamp <= endOfFifthBonus) {
227 			_tokenAmount = _tokenAmount.mul(fifthBonus).div(100);
228 		} else _tokenAmount=0;
229 		emit BonusCalculated(_tokenAmount);
230 		return _tokenAmount;
231 	}
232 }
233 
234 contract StandardToken is ERC20, ERC223, Ownable {
235 	using SafeMath for uint;
236 
237 	string internal _name;
238 	string internal _symbol;
239 	uint8 internal _decimals;
240 	uint256 internal _totalSupply;
241 	uint256 internal _bonusSupply;
242 
243 	uint256 public ethRate; // How many token units a buyer gets per eth
244 	uint256 public min_contribution; // Minimal contribution in ICO
245 	uint256 public totalWeiRaised; // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
246 	uint public tokensSold; // the number of tokens already sold
247 
248 	uint public softCap; //softcap in tokens
249 	uint public start; // the start date of the crowdsale
250 	uint public end; // the end date of the crowdsale
251 	bool public crowdsaleClosed; // indicates if the crowdsale has been closed already
252 	RefundVault public vault; // refund vault used to hold funds while crowdsale is running
253 	BonusScheme public bonusScheme; // contract used to hold and give tokens according to bonus scheme from white paper
254 
255 	address public fundsWallet; // Where should the raised ETH go?
256 
257 	mapping(address => bool)public frozenAccount;
258 	mapping(address => uint256)internal balances;
259 	mapping(address => mapping(address => uint256))internal allowed;
260 
261 	/* This generates a public event on the blockchain that will notify clients */
262 	event Burn(address indexed burner, uint256 value);
263 	event FrozenFunds(address target, bool frozen);
264 	event Finalized();
265 	event BonusSent(address indexed from, address indexed to, uint256 boughtTokens, uint256 bonusTokens);
266 
267 	/**
268 	 * Event for token purchase logging
269 	 * @param purchaser who paid for the tokens
270 	 * @param beneficiary who got the tokens
271 	 * @param value weis paid for purchase
272 	 * @param amount of tokens purchased
273 	 */
274 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
275 
276 	//TODO: correction of smart contract balance of tokens //done
277 	//TODO: change symbol and name of token
278 	//TODO: change start and end timestamps
279 	function StandardToken()public {
280 		_symbol = "AmTC1";
281 		_name = "AmTokenTestCase1";
282 		_decimals = 5;
283 		_totalSupply = 1100000 * (10 ** uint256(_decimals));
284 		//_creatorSupply = _totalSupply * 25 / 100; 			// The creator has 25% of tokens
285 		//_icoSupply = _totalSupply * 58 / 100; 				// Smart contract balance is 58% of tokens (638 000 tokens)
286 		_bonusSupply = _totalSupply * 17 / 100; // The Bonus scheme supply is 17% (187 000 tokens)
287 		
288 		fundsWallet = msg.sender; // The owner of the contract gets ETH
289 		vault = new RefundVault(fundsWallet);
290 		bonusScheme = new BonusScheme();
291 
292 		//balances[this] = _icoSupply;          				// Token balance to smart contract will be added manually from owners wallet
293 		balances[msg.sender] = _totalSupply.sub(_bonusSupply);
294 		balances[bonusScheme] = _bonusSupply;
295 		ethRate = 40000000; // Set the rate of token to ether exchange for the ICO
296 		min_contribution = 1 ether / (10**11); // 0.1 ETH is minimum deposit
297 		totalWeiRaised = 0;
298 		tokensSold = 0;
299 		softCap = 20000 * 10 ** uint(_decimals);
300 		start = 1526021100;
301 		end = 1526023500;
302 		crowdsaleClosed = false;
303 	}
304 
305 	modifier beforeICO() {
306 		require(block.timestamp <= start);
307 		_;
308 	}
309 	
310 	modifier afterDeadline() {
311 		require(block.timestamp > end);
312 		_;
313 	}
314 
315 	function name()
316 	public
317 	view
318 	returns(string) {
319 		return _name;
320 	}
321 
322 	function symbol()
323 	public
324 	view
325 	returns(string) {
326 		return _symbol;
327 	}
328 
329 	function decimals()
330 	public
331 	view
332 	returns(uint8) {
333 		return _decimals;
334 	}
335 
336 	function totalSupply()
337 	public
338 	view
339 	returns(uint256) {
340 		return _totalSupply;
341 	}
342 
343 	// -----------------------------------------
344 	// Crowdsale external interface
345 	// -----------------------------------------
346 
347 	/**
348 	 * @dev fallback function ***DO NOT OVERRIDE***
349 	 */
350 	function ()external payable {
351 		buyTokens(msg.sender);
352 	}
353 
354 	/**
355 	 * @dev low level token purchase ***DO NOT OVERRIDE***
356 	 * @param _beneficiary Address performing the token purchase
357 	 */
358 	//bad calculations, change  //should be ok
359 	//TODO: pre-ico phase to be defined and checked with other tokens, ICO-when closed check softcap, softcap-add pre-ico tokens, if isnt achieved revert all transactions, hardcap, timestamps&bonus scheme(will be discussed next week), minimum amount is 0,1ETH ...
360 	function buyTokens(address _beneficiary)public payable {
361 		uint256 weiAmount = msg.value;
362 		_preValidatePurchase(_beneficiary, weiAmount);
363 		uint256 tokens = _getTokenAmount(weiAmount); // calculate token amount to be sold
364 		require(balances[this] > tokens); //check if the contract has enough tokens
365 
366 		totalWeiRaised = totalWeiRaised.add(weiAmount); //update state
367 		tokensSold = tokensSold.add(tokens); //update state
368 
369 		_processPurchase(_beneficiary, tokens);
370 		emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
371 		_processBonus(_beneficiary, tokens);
372 
373 		_updatePurchasingState(_beneficiary, weiAmount);
374 
375 		_forwardFunds();
376 		_postValidatePurchase(_beneficiary, weiAmount);
377 
378 		/*
379 		balances[this] = balances[this].sub(weiAmount);
380 		balances[_beneficiary] = balances[_beneficiary].add(weiAmount);
381 
382 		emit Transfer(this, _beneficiary, weiAmount); 					// Broadcast a message to the blockchain
383 		 */
384 
385 	}
386 
387 	// -----------------------------------------
388 	// Crowdsale internal interface (extensible)
389 	// -----------------------------------------
390 
391 	/**
392 	 * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
393 	 * @param _beneficiary Address performing the token purchase
394 	 * @param _weiAmount Value in wei involved in the purchase
395 	 */
396 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)internal view {
397 		require(_beneficiary != address(0));
398 		require(_weiAmount >= min_contribution);
399 		require(!crowdsaleClosed && block.timestamp >= start && block.timestamp <= end);
400 	}
401 
402 	/**
403 	 * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
404 	 * @param _beneficiary Address performing the token purchase
405 	 * @param _weiAmount Value in wei involved in the purchase
406 	 */
407 	function _postValidatePurchase(address _beneficiary, uint256 _weiAmount)internal pure {
408 		// optional override
409 	}
410 
411 	/**
412 	 * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
413 	 * @param _beneficiary Address performing the token purchase
414 	 * @param _tokenAmount Number of tokens to be emitted
415 	 */
416 	function _deliverTokens(address _beneficiary, uint256 _tokenAmount)internal {
417 		this.transfer(_beneficiary, _tokenAmount);
418 	}
419 
420 	/**
421 	 * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
422 	 * @param _beneficiary Address receiving the tokens
423 	 * @param _tokenAmount Number of tokens to be purchased
424 	 */
425 	function _processPurchase(address _beneficiary, uint256 _tokenAmount)internal {
426 		_deliverTokens(_beneficiary, _tokenAmount);
427 	}
428 
429 	/**
430 	 * @dev Executed when a purchase has been validated and bonus tokens need to be calculated. Not necessarily emits/sends bonus tokens.
431 	 * @param _beneficiary Address receiving the tokens
432 	 * @param _tokenAmount Number of tokens from which is calculated bonus amount
433 	 */
434 	function _processBonus(address _beneficiary, uint256 _tokenAmount)internal {
435 		uint256 bonusTokens = bonusScheme.getBonusTokens(_tokenAmount); // Calculate bonus token amount
436 		if (balances[bonusScheme] < bonusTokens) { // If the bonus scheme does not have enough tokens, send all remaining
437 			bonusTokens = balances[bonusScheme];
438 		}
439 		if (bonusTokens > 0) { // If there are no tokens left in bonus scheme, we do not need transaction.
440 			balances[bonusScheme] = balances[bonusScheme].sub(bonusTokens);
441 			balances[_beneficiary] = balances[_beneficiary].add(bonusTokens);
442 			emit Transfer(address(bonusScheme), _beneficiary, bonusTokens);
443 			emit BonusSent(address(bonusScheme), _beneficiary, _tokenAmount, bonusTokens);
444 			tokensSold = tokensSold.add(bonusTokens); // update state
445 		}
446 	}
447 
448 	/**
449 	 * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
450 	 * @param _beneficiary Address receiving the tokens
451 	 * @param _weiAmount Value in wei involved in the purchase
452 	 */
453 	function _updatePurchasingState(address _beneficiary, uint256 _weiAmount)internal {
454 		// optional override
455 	}
456 
457 	/**
458 	 * @dev Override to extend the way in which ether is converted to tokens.
459 	 * @param _weiAmount Value in wei to be converted into tokens
460 	 * @return Number of tokens that can be purchased with the specified _weiAmount
461 	 */
462 	function _getTokenAmount(uint256 _weiAmount)internal view returns(uint256) {
463 		_weiAmount = _weiAmount.mul(ethRate);
464 		return _weiAmount.div(10 ** uint(18 - _decimals)); //as we have other decimals number than standard 18, we need to calculate
465 	}
466 
467 	/**
468 	 * @dev Determines how ETH is stored/forwarded on purchases, sending funds to vault.
469 	 */
470 	function _forwardFunds()internal {
471 		vault.deposit.value(msg.value)(msg.sender); //Transfer ether to vault
472 	}
473 
474 	///!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! bad function, refactor   //should be solved now
475 	//standard function transfer similar to ERC20 transfer with no _data
476 	//added due to backwards compatibility reasons
477 	function transfer(address _to, uint256 _value)public returns(bool) {
478 		require(_to != address(0));
479 		require(_value <= balances[msg.sender]);
480 		require(!frozenAccount[msg.sender]); // Check if sender is frozen
481 		require(!frozenAccount[_to]); // Check if recipient is frozen
482 		//require(!isContract(_to));
483 		balances[msg.sender] = balances[msg.sender].sub(_value);
484 		balances[_to] = balances[_to].add(_value);
485 		emit Transfer(msg.sender, _to, _value);
486 		return true;
487 	}
488 
489 	function balanceOf(address _owner)public view returns(uint256 balance) {
490 		return balances[_owner];
491 	}
492 
493 	//standard function transferFrom similar to ERC20 transferFrom with no _data
494 	//added due to backwards compatibility reasons
495 	function transferFrom(address _from, address _to, uint256 _value)public returns(bool) {
496 		require(_to != address(0));
497 		require(!frozenAccount[_from]); // Check if sender is frozen
498 		require(!frozenAccount[_to]); // Check if recipient is frozen
499 		require(_value <= balances[_from]);
500 		require(_value <= allowed[_from][msg.sender]);
501 
502 		balances[_from] = balances[_from].sub(_value);
503 		balances[_to] = balances[_to].add(_value);
504 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
505 		emit Transfer(_from, _to, _value);
506 		return true;
507 	}
508 
509 	function approve(address _spender, uint256 _value)public returns(bool) {
510 		allowed[msg.sender][_spender] = _value;
511 		emit Approval(msg.sender, _spender, _value);
512 		return true;
513 	}
514 
515 	function allowance(address _owner, address _spender)public view returns(uint256) {
516 		return allowed[_owner][_spender];
517 	}
518 
519 	function increaseApproval(address _spender, uint _addedValue)public returns(bool) {
520 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
521 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
522 		return true;
523 	}
524 
525 	function decreaseApproval(address _spender, uint _subtractedValue)public returns(bool) {
526 		uint oldValue = allowed[msg.sender][_spender];
527 		if (_subtractedValue > oldValue) {
528 			allowed[msg.sender][_spender] = 0;
529 		} else {
530 			allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
531 		}
532 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
533 		return true;
534 	}
535 
536 	// Function that is called when a user or another contract wants to transfer funds .    ///add trasnfertocontractwithcustomfallback  //done
537 	function transfer(address _to, uint _value, bytes _data, string _custom_fallback)public returns(bool success) {
538 		require(!frozenAccount[msg.sender]); // Check if sender is frozen
539 		require(!frozenAccount[_to]); // Check if recipient is frozen
540 		if (isContract(_to)) {
541 			return transferToContractWithCustomFallback(_to, _value, _data, _custom_fallback);
542 		} else {
543 			return transferToAddress(_to, _value, _data);
544 		}
545 	}
546 
547 	// Function that is called when a user or another contract wants to transfer funds .
548 	function transfer(address _to, uint _value, bytes _data)public returns(bool) {
549 		require(!frozenAccount[msg.sender]); // Check if sender is frozen
550 		require(!frozenAccount[_to]); // Check if recipient is frozen
551 		if (isContract(_to)) {
552 			return transferToContract(_to, _value, _data);
553 		} else {
554 			return transferToAddress(_to, _value, _data);
555 		}
556 		/*
557 		require(_to != address(0));
558 		require(_value > 0 && _value <= balances[msg.sender]);
559 		if(isContract(_to)) {
560 		ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
561 		receiver.tokenFallback(msg.sender, _value, _data);
562 		return true;
563 		}
564 		balances[msg.sender] = balances[msg.sender].sub(_value);
565 		balances[_to] = balances[_to].add(_value);
566 		emit Transfer(msg.sender, _to, _value, _data);
567 		 */
568 	}
569 
570 	function isContract(address _addr)private view returns(bool is_contract) {
571 		uint length;
572 		assembly {
573 			//retrieve the size of the code on target address, this needs assembly
574 			length := extcodesize(_addr)
575 		}
576 		return (length > 0);
577 	}
578 
579 	//function that is called when transaction target is an address
580 	function transferToAddress(address _to, uint _value, bytes _data)private returns(bool success) {
581 		require(balanceOf(msg.sender) > _value);
582 		balances[msg.sender] = balances[msg.sender].sub(_value);
583 		balances[_to] = balances[_to].add(_value);
584 		emit Transfer(msg.sender, _to, _value, _data);
585 		return true;
586 	}
587 
588 	//function that is called when transaction target is a contract
589 	function transferToContract(address _to, uint _value, bytes _data)private returns(bool success) {
590 		require(balanceOf(msg.sender) > _value);
591 		balances[msg.sender] = balances[msg.sender].sub(_value);
592 		balances[_to] = balances[_to].add(_value);
593 		ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
594 		receiver.tokenFallback(msg.sender, _value, _data);
595 		emit Transfer(msg.sender, _to, _value, _data);
596 		return true;
597 	}
598 
599 	//function that is called when transaction target is a contract with custom fallback
600 	function transferToContractWithCustomFallback(address _to, uint _value, bytes _data, string _custom_fallback)private returns(bool success) {
601 		require(balanceOf(msg.sender) > _value);
602 		balances[msg.sender] = balances[msg.sender].sub(_value);
603 		balances[_to] = balances[_to].add(_value);
604 		assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
605 		emit Transfer(msg.sender, _to, _value, _data);
606 		return true;
607 	}
608 
609 	function setPreICOSoldAmount(uint256 _soldTokens, uint256 _raisedWei)onlyOwner beforeICO public {
610 		tokensSold = tokensSold.add(_soldTokens);
611 		totalWeiRaised = totalWeiRaised.add(_raisedWei);
612 	}
613 	
614 	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
615 	/// @param target Address to be frozen
616 	/// @param freeze either to freeze it or not
617 	function freezeAccount(address target, bool freeze)onlyOwner public {
618 		frozenAccount[target] = freeze;
619 		emit FrozenFunds(target, freeze);
620 	}
621 
622 	/**
623 	 * Destroy tokens
624 	 *
625 	 * Remove `_value` tokens from the system irreversibly
626 	 *
627 	 * @param _value the amount of money to burn
628 	 */
629 	function burn(uint256 _value)onlyOwner public returns(bool success) {
630 		require(balances[msg.sender] >= _value); // Check if the sender has enough
631 		balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract from the sender
632 		_totalSupply = _totalSupply.sub(_value); // Updates totalSupply
633 		emit Burn(msg.sender, _value);
634 		emit Transfer(msg.sender, address(0), _value);
635 		return true;
636 	}
637 
638 	/* NOT NEEDED as ethers are in vault
639 	//check the functionality
640 	// @notice Failsafe drain
641 	function withdrawEther()onlyOwner public returns(bool) {
642 	owner.transfer(address(this).balance);
643 	return true;
644 	}
645 	 */
646 
647 	// @notice Failsafe transfer tokens for the team to given account
648 	function withdrawTokens()onlyOwner public returns(bool) {
649 		require(this.transfer(owner, balances[this]));
650 		uint256 bonusTokens = balances[address(bonusScheme)];
651 		balances[address(bonusScheme)] = 0;
652 		if (bonusTokens > 0) { // If there are no tokens left in bonus scheme, we do not need transaction.
653 			balances[owner] = balances[owner].add(bonusTokens);
654 			emit Transfer(address(bonusScheme), owner, bonusTokens);
655 		}
656 		return true;
657 	}
658 
659 	/**
660 	 * @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
661 	 * @param _tokenAddress The address of the ERC20 contract.
662 	 * @param _amount The amount of tokens to be transferred.
663 	 */
664 	function transferAnyERC20Token(address _tokenAddress, uint256 _amount)onlyOwner public returns(bool success) {
665 		return ERC20(_tokenAddress).transfer(owner, _amount);
666 	}
667 
668 	/**
669 	 * @dev Investors can claim refunds here if crowdsale is unsuccessful
670 	 */
671 	function claimRefund()public {
672 		require(crowdsaleClosed);
673 		require(!goalReached());
674 
675 		vault.refund(msg.sender);
676 	}
677 
678 	/**
679 	 * @dev Checks whether funding goal was reached.
680 	 * @return Whether funding goal was reached
681 	 */
682 	function goalReached()public view returns(bool) {
683 		return tokensSold >= softCap;
684 	}
685 
686 	/**
687 	 * @dev vault finalization task, called when owner calls finalize()
688 	 */
689 	function finalization()internal {
690 		if (goalReached()) {
691 			vault.close();
692 		} else {
693 			vault.enableRefunds();
694 		}
695 	}
696 
697 	/**
698 	 * @dev Must be called after crowdsale ends, to do some extra finalization
699 	 * work. Calls the contract's finalization function.
700 	 */
701 	function finalize()onlyOwner afterDeadline public {
702 		require(!crowdsaleClosed);
703 
704 		finalization();
705 		emit Finalized();
706 		withdrawTokens();
707 
708 		crowdsaleClosed = true;
709 	}
710 
711 }