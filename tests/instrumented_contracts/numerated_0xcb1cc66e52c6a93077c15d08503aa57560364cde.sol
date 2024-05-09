1 pragma solidity ^ 0.4.21;
2 
3 pragma solidity ^0.4.10;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 pragma solidity ^0.4.10;
39 
40 interface ERC20 {
41   function balanceOf(address who) view returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   function allowance(address owner, address spender) view returns (uint256);
44   function transferFrom(address from, address to, uint256 value) returns (bool);
45   function approve(address spender, uint256 value) returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 pragma solidity ^0.4.10;
50 
51 interface ERC223 {
52     function transfer(address to, uint value, bytes data) returns (bool);
53     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
54 }
55 pragma solidity ^0.4.10;
56 
57 contract ERC223ReceivingContract { 
58     function tokenFallback(address _from, uint _value, bytes _data) public;
59 }
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
100 /**
101  * @title RefundVault
102  * @dev This contract is used for storing funds while a crowdsale
103  * is in progress. Supports refunding the money if crowdsale fails,
104  * and forwarding it if crowdsale is successful.
105  */
106 contract RefundVault is Ownable {
107 	using SafeMath for uint256;
108 
109 	enum State {
110 		Active,
111 		Refunding,
112 		Closed
113 	}
114 
115 	mapping(address => uint256)public deposited;
116 	address public wallet;
117 	State public state;
118 
119 	event Closed();
120 	event RefundsEnabled();
121 	event Refunded(address indexed beneficiary, uint256 weiAmount);
122 
123 	/**
124 	 * @param _wallet Vault address
125 	 */
126 	function RefundVault(address _wallet)public {
127 		require(_wallet != address(0));
128 		wallet = _wallet;
129 		state = State.Active;
130 	}
131 
132 	/**
133 	 * @param investor Investor address
134 	 */
135 	function deposit(address investor)onlyOwner public payable {
136 		require(state == State.Active);
137 		deposited[investor] = deposited[investor].add(msg.value);
138 	}
139 
140 	function close()onlyOwner public {
141 		require(state == State.Active);
142 		state = State.Closed;
143 		emit Closed();
144 		wallet.transfer(address(this).balance);
145 	}
146 
147 	function enableRefunds()onlyOwner public {
148 		require(state == State.Active);
149 		state = State.Refunding;
150 		emit RefundsEnabled();
151 	}
152 
153 	/**
154 	 * @param investor Investor address
155 	 */
156 	function refund(address investor)public {
157 		require(state == State.Refunding);
158 		uint256 depositedValue = deposited[investor];
159 		deposited[investor] = 0;
160 		investor.transfer(depositedValue);
161 		emit Refunded(investor, depositedValue);
162 	}
163 }
164 
165 /**
166  * @title BonusScheme
167  * @dev This contract is used for storing and granting tokens calculated 
168  * according to bonus scheme while a crowdsale is in progress.
169  * When crowdsale ends the rest of tokens is transferred to developers.
170  */
171 contract BonusScheme is Ownable {
172 	using SafeMath for uint256;
173 
174 	/**
175 	* Defining timestamps for bonuscheme from White Paper. 
176 	* The start of bonuses is 15 May 2018 and the end is 23 June 2018. 
177 	* There are 2 seconds in between changing the phases.  */
178 	uint256 startOfFirstBonus = 1525892100;
179 	uint256 endOfFirstBonus = (startOfFirstBonus - 1) + 5 minutes;	
180 	uint256 startOfSecondBonus = (startOfFirstBonus + 1) + 5 minutes;
181 	uint256 endOfSecondBonus = (startOfSecondBonus - 1) + 5 minutes;
182 	uint256 startOfThirdBonus = (startOfSecondBonus + 1) + 5 minutes;
183 	uint256 endOfThirdBonus = (startOfThirdBonus - 1) + 5 minutes;
184 	uint256 startOfFourthBonus = (startOfThirdBonus + 1) + 5 minutes;
185 	uint256 endOfFourthBonus = (startOfFourthBonus - 1) + 5 minutes;
186 	uint256 startOfFifthBonus = (startOfFourthBonus + 1) + 5 minutes;
187 	uint256 endOfFifthBonus = (startOfFifthBonus - 1) + 5 minutes;
188 	
189 	/**
190 	* Defining bonuses according to White Paper.
191 	* First week there is bonus 35%.
192 	* Second week there is bonus 30%.
193 	* Third week there is bonus 20%.
194 	* Fourth week there is bonus 10%.
195 	* Fifth week there is bonus 5%.
196 	*/
197 	uint256 firstBonus = 35;
198 	uint256 secondBonus = 30;
199 	uint256 thirdBonus = 20;
200 	uint256 fourthBonus = 10;
201 	uint256 fifthBonus = 5;
202 
203 	event BonusCalculated(uint256 tokenAmount);
204 
205     function BonusScheme() public {
206         
207     }
208 
209 	/**
210 	 * @dev Calculates from Bonus Scheme how many tokens can be added to purchased _tokenAmount.
211 	 * @param _tokenAmount The amount of calculated tokens to sent Ether.
212 	 * @return Number of bonus tokens that can be granted with the specified _tokenAmount.
213 	 */
214 	function getBonusTokens(uint256 _tokenAmount)onlyOwner public returns(uint256) {
215 		if (block.timestamp >= startOfFirstBonus && block.timestamp <= endOfFirstBonus) {
216 			_tokenAmount = _tokenAmount.mul(firstBonus).div(100);
217 		} else if (block.timestamp >= startOfSecondBonus && block.timestamp <= endOfSecondBonus) {
218 			_tokenAmount = _tokenAmount.mul(secondBonus).div(100);
219 		} else if (block.timestamp >= startOfThirdBonus && block.timestamp <= endOfThirdBonus) {
220 			_tokenAmount = _tokenAmount.mul(thirdBonus).div(100);
221 		} else if (block.timestamp >= startOfFourthBonus && block.timestamp <= endOfFourthBonus) {
222 			_tokenAmount = _tokenAmount.mul(fourthBonus).div(100);
223 		} else if (block.timestamp >= startOfFifthBonus && block.timestamp <= endOfFifthBonus) {
224 			_tokenAmount = _tokenAmount.mul(fifthBonus).div(100);
225 		} else _tokenAmount=0;
226 		emit BonusCalculated(_tokenAmount);
227 		return _tokenAmount;
228 	}
229 }
230 
231 contract StandardToken is ERC20, ERC223, Ownable {
232 	using SafeMath for uint;
233 
234 	string internal _name;
235 	string internal _symbol;
236 	uint8 internal _decimals;
237 	uint256 internal _totalSupply;
238 	uint256 internal _bonusSupply;
239 
240 	uint256 public ethRate; // How many token units a buyer gets per eth
241 	uint256 public min_contribution; // Minimal contribution in ICO
242 	uint256 public totalWeiRaised; // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
243 	uint public tokensSold; // the number of tokens already sold
244 
245 	uint public softCap; //softcap in tokens
246 	uint public start; // the start date of the crowdsale
247 	uint public end; // the end date of the crowdsale
248 	bool public crowdsaleClosed; // indicates if the crowdsale has been closed already
249 	RefundVault public vault; // refund vault used to hold funds while crowdsale is running
250 	BonusScheme public bonusScheme; // contract used to hold and give tokens according to bonus scheme from white paper
251 
252 	address public fundsWallet; // Where should the raised ETH go?
253 
254 	mapping(address => bool)public frozenAccount;
255 	mapping(address => uint256)internal balances;
256 	mapping(address => mapping(address => uint256))internal allowed;
257 
258 	/* This generates a public event on the blockchain that will notify clients */
259 	event Burn(address indexed burner, uint256 value);
260 	event FrozenFunds(address target, bool frozen);
261 	event Finalized();
262 	event BonusSent(address indexed from, address indexed to, uint256 boughtTokens, uint256 bonusTokens);
263 
264 	/**
265 	 * Event for token purchase logging
266 	 * @param purchaser who paid for the tokens
267 	 * @param beneficiary who got the tokens
268 	 * @param value weis paid for purchase
269 	 * @param amount of tokens purchased
270 	 */
271 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
272 
273 	//TODO: correction of smart contract balance of tokens //done
274 	//TODO: change symbol and name of token
275 	//TODO: change start and end timestamps
276 	function StandardToken()public {
277 		_symbol = "AmTC1";
278 		_name = "AmTokenTestCase1";
279 		_decimals = 5;
280 		_totalSupply = 1100000 * (10 ** uint256(_decimals));
281 		//_creatorSupply = _totalSupply * 25 / 100; 			// The creator has 25% of tokens
282 		//_icoSupply = _totalSupply * 58 / 100; 				// Smart contract balance is 58% of tokens (638 000 tokens)
283 		_bonusSupply = _totalSupply * 17 / 100; // The Bonus scheme supply is 17% (187 000 tokens)
284 		
285 		fundsWallet = msg.sender; // The owner of the contract gets ETH
286 		vault = new RefundVault(fundsWallet);
287 		bonusScheme = new BonusScheme();
288 
289 		//balances[this] = _icoSupply;          				// Token balance to smart contract will be added manually from owners wallet
290 		balances[msg.sender] = _totalSupply.sub(_bonusSupply);
291 		balances[bonusScheme] = _bonusSupply;
292 		ethRate = 40000000; // Set the rate of token to ether exchange for the ICO
293 		min_contribution = 1 ether / (10**11); // 0.1 ETH is minimum deposit
294 		totalWeiRaised = 0;
295 		tokensSold = 0;
296 		softCap = 20000 * 10 ** uint(_decimals);
297 		start = 1525891800;
298 		end = 1525893600;
299 		crowdsaleClosed = false;
300 	}
301 
302 	modifier beforeICO() {
303 		require(block.timestamp <= start);
304 		_;
305 	}
306 	
307 	modifier afterDeadline() {
308 		require(block.timestamp > end);
309 		_;
310 	}
311 
312 	function name()
313 	public
314 	view
315 	returns(string) {
316 		return _name;
317 	}
318 
319 	function symbol()
320 	public
321 	view
322 	returns(string) {
323 		return _symbol;
324 	}
325 
326 	function decimals()
327 	public
328 	view
329 	returns(uint8) {
330 		return _decimals;
331 	}
332 
333 	function totalSupply()
334 	public
335 	view
336 	returns(uint256) {
337 		return _totalSupply;
338 	}
339 
340 	// -----------------------------------------
341 	// Crowdsale external interface
342 	// -----------------------------------------
343 
344 	/**
345 	 * @dev fallback function ***DO NOT OVERRIDE***
346 	 */
347 	function ()external payable {
348 		buyTokens(msg.sender);
349 	}
350 
351 	/**
352 	 * @dev low level token purchase ***DO NOT OVERRIDE***
353 	 * @param _beneficiary Address performing the token purchase
354 	 */
355 	//bad calculations, change  //should be ok
356 	//TODO: pre-ico phase to be defined and checked with other tokens, ICO-when closed check softcap, softcap-add pre-ico tokens, if isnt achieved revert all transactions, hardcap, timestamps&bonus scheme(will be discussed next week), minimum amount is 0,1ETH ...
357 	function buyTokens(address _beneficiary)public payable {
358 		uint256 weiAmount = msg.value;
359 		_preValidatePurchase(_beneficiary, weiAmount);
360 		uint256 tokens = _getTokenAmount(weiAmount); // calculate token amount to be sold
361 		require(balances[this] > tokens); //check if the contract has enough tokens
362 
363 		totalWeiRaised = totalWeiRaised.add(weiAmount); //update state
364 		tokensSold = tokensSold.add(tokens); //update state
365 
366 		_processPurchase(_beneficiary, tokens);
367 		emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
368 		_processBonus(_beneficiary, tokens);
369 
370 		_updatePurchasingState(_beneficiary, weiAmount);
371 
372 		_forwardFunds();
373 		_postValidatePurchase(_beneficiary, weiAmount);
374 
375 		/*
376 		balances[this] = balances[this].sub(weiAmount);
377 		balances[_beneficiary] = balances[_beneficiary].add(weiAmount);
378 
379 		emit Transfer(this, _beneficiary, weiAmount); 					// Broadcast a message to the blockchain
380 		 */
381 
382 	}
383 
384 	// -----------------------------------------
385 	// Crowdsale internal interface (extensible)
386 	// -----------------------------------------
387 
388 	/**
389 	 * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
390 	 * @param _beneficiary Address performing the token purchase
391 	 * @param _weiAmount Value in wei involved in the purchase
392 	 */
393 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)internal view {
394 		require(_beneficiary != address(0));
395 		require(_weiAmount >= min_contribution);
396 		require(!crowdsaleClosed && block.timestamp >= start && block.timestamp <= end);
397 	}
398 
399 	/**
400 	 * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
401 	 * @param _beneficiary Address performing the token purchase
402 	 * @param _weiAmount Value in wei involved in the purchase
403 	 */
404 	function _postValidatePurchase(address _beneficiary, uint256 _weiAmount)internal pure {
405 		// optional override
406 	}
407 
408 	/**
409 	 * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
410 	 * @param _beneficiary Address performing the token purchase
411 	 * @param _tokenAmount Number of tokens to be emitted
412 	 */
413 	function _deliverTokens(address _beneficiary, uint256 _tokenAmount)internal {
414 		this.transfer(_beneficiary, _tokenAmount);
415 	}
416 
417 	/**
418 	 * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
419 	 * @param _beneficiary Address receiving the tokens
420 	 * @param _tokenAmount Number of tokens to be purchased
421 	 */
422 	function _processPurchase(address _beneficiary, uint256 _tokenAmount)internal {
423 		_deliverTokens(_beneficiary, _tokenAmount);
424 	}
425 
426 	/**
427 	 * @dev Executed when a purchase has been validated and bonus tokens need to be calculated. Not necessarily emits/sends bonus tokens.
428 	 * @param _beneficiary Address receiving the tokens
429 	 * @param _tokenAmount Number of tokens from which is calculated bonus amount
430 	 */
431 	function _processBonus(address _beneficiary, uint256 _tokenAmount)internal {
432 		uint256 bonusTokens = bonusScheme.getBonusTokens(_tokenAmount); // Calculate bonus token amount
433 		if (balances[bonusScheme] < bonusTokens) { // If the bonus scheme does not have enough tokens, send all remaining
434 			bonusTokens = balances[bonusScheme];
435 			balances[bonusScheme] = 0;
436 		}
437 		if (bonusTokens > 0) { // If there are no tokens left in bonus scheme, we do not need transaction.
438 			balances[bonusScheme] = balances[bonusScheme].sub(bonusTokens);
439 			balances[_beneficiary] = balances[_beneficiary].add(bonusTokens);
440 			emit Transfer(address(bonusScheme), _beneficiary, bonusTokens);
441 			emit BonusSent(address(bonusScheme), _beneficiary, _tokenAmount, bonusTokens);
442 			tokensSold = tokensSold.add(bonusTokens); // update state
443 		}
444 	}
445 
446 	/**
447 	 * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
448 	 * @param _beneficiary Address receiving the tokens
449 	 * @param _weiAmount Value in wei involved in the purchase
450 	 */
451 	function _updatePurchasingState(address _beneficiary, uint256 _weiAmount)internal {
452 		// optional override
453 	}
454 
455 	/**
456 	 * @dev Override to extend the way in which ether is converted to tokens.
457 	 * @param _weiAmount Value in wei to be converted into tokens
458 	 * @return Number of tokens that can be purchased with the specified _weiAmount
459 	 */
460 	function _getTokenAmount(uint256 _weiAmount)internal view returns(uint256) {
461 		_weiAmount = _weiAmount.mul(ethRate);
462 		return _weiAmount.div(10 ** uint(18 - _decimals)); //as we have other decimals number than standard 18, we need to calculate
463 	}
464 
465 	/**
466 	 * @dev Determines how ETH is stored/forwarded on purchases, sending funds to vault.
467 	 */
468 	function _forwardFunds()internal {
469 		vault.deposit.value(msg.value)(msg.sender); //Transfer ether to vault
470 	}
471 
472 	///!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! bad function, refactor   //should be solved now
473 	//standard function transfer similar to ERC20 transfer with no _data
474 	//added due to backwards compatibility reasons
475 	function transfer(address _to, uint256 _value)public returns(bool) {
476 		require(_to != address(0));
477 		require(_value <= balances[msg.sender]);
478 		require(!frozenAccount[msg.sender]); // Check if sender is frozen
479 		require(!frozenAccount[_to]); // Check if recipient is frozen
480 		//require(!isContract(_to));
481 		balances[msg.sender] = balances[msg.sender].sub(_value);
482 		balances[_to] = balances[_to].add(_value);
483 		emit Transfer(msg.sender, _to, _value);
484 		return true;
485 	}
486 
487 	function balanceOf(address _owner)public view returns(uint256 balance) {
488 		return balances[_owner];
489 	}
490 
491 	//standard function transferFrom similar to ERC20 transferFrom with no _data
492 	//added due to backwards compatibility reasons
493 	function transferFrom(address _from, address _to, uint256 _value)public returns(bool) {
494 		require(_to != address(0));
495 		require(!frozenAccount[_from]); // Check if sender is frozen
496 		require(!frozenAccount[_to]); // Check if recipient is frozen
497 		require(_value <= balances[_from]);
498 		require(_value <= allowed[_from][msg.sender]);
499 
500 		balances[_from] = balances[_from].sub(_value);
501 		balances[_to] = balances[_to].add(_value);
502 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
503 		emit Transfer(_from, _to, _value);
504 		return true;
505 	}
506 
507 	function approve(address _spender, uint256 _value)public returns(bool) {
508 		allowed[msg.sender][_spender] = _value;
509 		emit Approval(msg.sender, _spender, _value);
510 		return true;
511 	}
512 
513 	function allowance(address _owner, address _spender)public view returns(uint256) {
514 		return allowed[_owner][_spender];
515 	}
516 
517 	function increaseApproval(address _spender, uint _addedValue)public returns(bool) {
518 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
519 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
520 		return true;
521 	}
522 
523 	function decreaseApproval(address _spender, uint _subtractedValue)public returns(bool) {
524 		uint oldValue = allowed[msg.sender][_spender];
525 		if (_subtractedValue > oldValue) {
526 			allowed[msg.sender][_spender] = 0;
527 		} else {
528 			allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
529 		}
530 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
531 		return true;
532 	}
533 
534 	// Function that is called when a user or another contract wants to transfer funds .    ///add trasnfertocontractwithcustomfallback  //done
535 	function transfer(address _to, uint _value, bytes _data, string _custom_fallback)public returns(bool success) {
536 		require(!frozenAccount[msg.sender]); // Check if sender is frozen
537 		require(!frozenAccount[_to]); // Check if recipient is frozen
538 		if (isContract(_to)) {
539 			return transferToContractWithCustomFallback(_to, _value, _data, _custom_fallback);
540 		} else {
541 			return transferToAddress(_to, _value, _data);
542 		}
543 	}
544 
545 	// Function that is called when a user or another contract wants to transfer funds .
546 	function transfer(address _to, uint _value, bytes _data)public returns(bool) {
547 		require(!frozenAccount[msg.sender]); // Check if sender is frozen
548 		require(!frozenAccount[_to]); // Check if recipient is frozen
549 		if (isContract(_to)) {
550 			return transferToContract(_to, _value, _data);
551 		} else {
552 			return transferToAddress(_to, _value, _data);
553 		}
554 		/*
555 		require(_to != address(0));
556 		require(_value > 0 && _value <= balances[msg.sender]);
557 		if(isContract(_to)) {
558 		ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
559 		receiver.tokenFallback(msg.sender, _value, _data);
560 		return true;
561 		}
562 		balances[msg.sender] = balances[msg.sender].sub(_value);
563 		balances[_to] = balances[_to].add(_value);
564 		emit Transfer(msg.sender, _to, _value, _data);
565 		 */
566 	}
567 
568 	function isContract(address _addr)private view returns(bool is_contract) {
569 		uint length;
570 		assembly {
571 			//retrieve the size of the code on target address, this needs assembly
572 			length := extcodesize(_addr)
573 		}
574 		return (length > 0);
575 	}
576 
577 	//function that is called when transaction target is an address
578 	function transferToAddress(address _to, uint _value, bytes _data)private returns(bool success) {
579 		require(balanceOf(msg.sender) > _value);
580 		balances[msg.sender] = balances[msg.sender].sub(_value);
581 		balances[_to] = balances[_to].add(_value);
582 		emit Transfer(msg.sender, _to, _value, _data);
583 		return true;
584 	}
585 
586 	//function that is called when transaction target is a contract
587 	function transferToContract(address _to, uint _value, bytes _data)private returns(bool success) {
588 		require(balanceOf(msg.sender) > _value);
589 		balances[msg.sender] = balances[msg.sender].sub(_value);
590 		balances[_to] = balances[_to].add(_value);
591 		ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
592 		receiver.tokenFallback(msg.sender, _value, _data);
593 		emit Transfer(msg.sender, _to, _value, _data);
594 		return true;
595 	}
596 
597 	//function that is called when transaction target is a contract with custom fallback
598 	function transferToContractWithCustomFallback(address _to, uint _value, bytes _data, string _custom_fallback)private returns(bool success) {
599 		require(balanceOf(msg.sender) > _value);
600 		balances[msg.sender] = balances[msg.sender].sub(_value);
601 		balances[_to] = balances[_to].add(_value);
602 		assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
603 		emit Transfer(msg.sender, _to, _value, _data);
604 		return true;
605 	}
606 
607 	function setPreICOSoldAmount(uint256 _soldTokens, uint256 _raisedWei)onlyOwner beforeICO public {
608 		tokensSold = tokensSold.add(_soldTokens);
609 		totalWeiRaised = totalWeiRaised.add(_raisedWei);
610 	}
611 	
612 	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
613 	/// @param target Address to be frozen
614 	/// @param freeze either to freeze it or not
615 	function freezeAccount(address target, bool freeze)onlyOwner public {
616 		frozenAccount[target] = freeze;
617 		emit FrozenFunds(target, freeze);
618 	}
619 
620 	/**
621 	 * Destroy tokens
622 	 *
623 	 * Remove `_value` tokens from the system irreversibly
624 	 *
625 	 * @param _value the amount of money to burn
626 	 */
627 	function burn(uint256 _value)onlyOwner public returns(bool success) {
628 		require(balances[msg.sender] >= _value); // Check if the sender has enough
629 		balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract from the sender
630 		_totalSupply = _totalSupply.sub(_value); // Updates totalSupply
631 		emit Burn(msg.sender, _value);
632 		emit Transfer(msg.sender, address(0), _value);
633 		return true;
634 	}
635 
636 	/* NOT NEEDED as ethers are in vault
637 	//check the functionality
638 	// @notice Failsafe drain
639 	function withdrawEther()onlyOwner public returns(bool) {
640 	owner.transfer(address(this).balance);
641 	return true;
642 	}
643 	 */
644 
645 	// @notice Failsafe transfer tokens for the team to given account
646 	function withdrawTokens()onlyOwner public returns(bool) {
647 		require(this.transfer(owner, balances[this]));
648 		uint256 bonusTokens = balances[address(bonusScheme)];
649 		balances[address(bonusScheme)] = 0;
650 		if (bonusTokens > 0) { // If there are no tokens left in bonus scheme, we do not need transaction.
651 			balances[owner] = balances[owner].add(bonusTokens);
652 			emit Transfer(address(bonusScheme), owner, bonusTokens);
653 		}
654 		return true;
655 	}
656 
657 	/**
658 	 * @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
659 	 * @param _tokenAddress The address of the ERC20 contract.
660 	 * @param _amount The amount of tokens to be transferred.
661 	 */
662 	function transferAnyERC20Token(address _tokenAddress, uint256 _amount)onlyOwner public returns(bool success) {
663 		return ERC20(_tokenAddress).transfer(owner, _amount);
664 	}
665 
666 	/**
667 	 * @dev Investors can claim refunds here if crowdsale is unsuccessful
668 	 */
669 	function claimRefund()public {
670 		require(crowdsaleClosed);
671 		require(!goalReached());
672 
673 		vault.refund(msg.sender);
674 	}
675 
676 	/**
677 	 * @dev Checks whether funding goal was reached.
678 	 * @return Whether funding goal was reached
679 	 */
680 	function goalReached()public view returns(bool) {
681 		return tokensSold >= softCap;
682 	}
683 
684 	/**
685 	 * @dev vault finalization task, called when owner calls finalize()
686 	 */
687 	function finalization()internal {
688 		if (goalReached()) {
689 			vault.close();
690 		} else {
691 			vault.enableRefunds();
692 		}
693 	}
694 
695 	/**
696 	 * @dev Must be called after crowdsale ends, to do some extra finalization
697 	 * work. Calls the contract's finalization function.
698 	 */
699 	function finalize()onlyOwner afterDeadline public {
700 		require(!crowdsaleClosed);
701 
702 		finalization();
703 		emit Finalized();
704 		withdrawTokens();
705 
706 		crowdsaleClosed = true;
707 	}
708 
709 }