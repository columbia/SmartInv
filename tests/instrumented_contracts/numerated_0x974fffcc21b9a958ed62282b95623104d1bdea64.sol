1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Whitelist
91  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
92  * @dev This simplifies the implementation of "user permissions".
93  */
94 contract Whitelist is Ownable {
95   mapping(address => bool) public whitelist;
96 
97   event WhitelistedAddressAdded(address addr);
98   event WhitelistedAddressRemoved(address addr);
99 
100   /**
101    * @dev Throws if called by any account that's not whitelisted.
102    */
103   modifier onlyWhitelisted() {
104     require(whitelist[msg.sender]);
105     _;
106   }
107 
108   /**
109    * @dev add an address to the whitelist
110    * @param addr address
111    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
112    */
113   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
114     if (!whitelist[addr]) {
115       whitelist[addr] = true;
116       emit WhitelistedAddressAdded(addr);
117       success = true;
118     }
119   }
120 
121   /**
122    * @dev add addresses to the whitelist
123    * @param addrs addresses
124    * @return true if at least one address was added to the whitelist,
125    * false if all addresses were already in the whitelist
126    */
127   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
128     for (uint256 i = 0; i < addrs.length; i++) {
129       if (addAddressToWhitelist(addrs[i])) {
130         success = true;
131       }
132     }
133   }
134 
135   /**
136    * @dev remove an address from the whitelist
137    * @param addr address
138    * @return true if the address was removed from the whitelist,
139    * false if the address wasn't in the whitelist in the first place
140    */
141   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
142     if (whitelist[addr]) {
143       whitelist[addr] = false;
144       emit WhitelistedAddressRemoved(addr);
145       success = true;
146     }
147   }
148 
149   /**
150    * @dev remove addresses from the whitelist
151    * @param addrs addresses
152    * @return true if at least one address was removed from the whitelist,
153    * false if all addresses weren't in the whitelist in the first place
154    */
155   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
156     for (uint256 i = 0; i < addrs.length; i++) {
157       if (removeAddressFromWhitelist(addrs[i])) {
158         success = true;
159       }
160     }
161   }
162 
163 }
164 
165 /**
166  * @title Pausable
167  * @dev Base contract which allows children to implement an emergency stop mechanism.
168  */
169 contract Pausable is Ownable {
170   event Pause();
171   event Unpause();
172 
173   bool public paused = false;
174 
175 
176   /**
177    * @dev Modifier to make a function callable only when the contract is not paused.
178    */
179   modifier whenNotPaused() {
180     require(!paused);
181     _;
182   }
183 
184   /**
185    * @dev Modifier to make a function callable only when the contract is paused.
186    */
187   modifier whenPaused() {
188     require(paused);
189     _;
190   }
191 
192   /**
193    * @dev called by the owner to pause, triggers stopped state
194    */
195   function pause() onlyOwner whenNotPaused public {
196     paused = true;
197     emit Pause();
198   }
199 
200   /**
201    * @dev called by the owner to unpause, returns to normal state
202    */
203   function unpause() onlyOwner whenPaused public {
204     paused = false;
205     emit Unpause();
206   }
207 }
208 
209 /**
210  * @title ERC20Basic
211  * @dev Simpler version of ERC20 interface
212  * @dev see https://github.com/ethereum/EIPs/issues/179
213  */
214 contract ERC20Basic {
215   function totalSupply() public view returns (uint256);
216   function balanceOf(address who) public view returns (uint256);
217   function transfer(address to, uint256 value) public returns (bool);
218   event Transfer(address indexed from, address indexed to, uint256 value);
219 }
220 
221 /**
222  * @title ERC20 interface
223  * @dev see https://github.com/ethereum/EIPs/issues/20
224  */
225 contract ERC20 is ERC20Basic {
226   function allowance(address owner, address spender) public view returns (uint256);
227   function transferFrom(address from, address to, uint256 value) public returns (bool);
228   function approve(address spender, uint256 value) public returns (bool);
229   event Approval(address indexed owner, address indexed spender, uint256 value);
230 }
231 
232 contract TTTToken is ERC20, Ownable {
233 	using SafeMath for uint;
234 
235 	string public constant name = "The Tip Token";
236 	string public constant symbol = "TTT";
237 
238 	uint8 public decimals = 18;
239 
240 	mapping(address=>uint256) balances;
241 	mapping(address=>mapping(address=>uint256)) allowed;
242 
243 	// Supply variables
244 	uint256 public totalSupply_;
245 	uint256 public presaleSupply;
246 	uint256 public crowdsaleSupply;
247 	uint256 public privatesaleSupply;
248 	uint256 public airdropSupply;
249 	uint256 public teamSupply;
250 	uint256 public ecoSupply;
251 
252 	// Vest variables
253 	uint256 public firstVestStartsAt;
254 	uint256 public secondVestStartsAt;
255 	uint256 public firstVestAmount;
256 	uint256 public secondVestAmount;
257 	uint256 public currentVestedAmount;
258 
259 	uint256 public crowdsaleBurnAmount;
260 
261 	// Token sale addresses
262 	address public privatesaleAddress;
263 	address public presaleAddress;
264 	address public crowdsaleAddress;
265 	address public teamSupplyAddress;
266 	address public ecoSupplyAddress;
267 	address public crowdsaleAirdropAddress;
268 	address public crowdsaleBurnAddress;
269 	address public tokenSaleAddress;
270 
271 	// Token sale state variables
272 	bool public privatesaleFinalized;
273 	bool public presaleFinalized;
274 	bool public crowdsaleFinalized;
275 
276 	event PrivatesaleFinalized(uint tokensRemaining);
277 	event PresaleFinalized(uint tokensRemaining);
278 	event CrowdsaleFinalized(uint tokensRemaining);
279 	event Burn(address indexed burner, uint256 value);
280 	event TokensaleAddressSet(address tSeller, address from);
281 
282 	modifier onlyTokenSale() {
283 		require(msg.sender == tokenSaleAddress);
284 		_;
285 	}
286 
287 	modifier canItoSend() {
288 		require(crowdsaleFinalized == true || (crowdsaleFinalized == false && msg.sender == ecoSupplyAddress));
289 		_;
290 	}
291 
292 	function TTTToken() {
293 		// 600 million total supply divided into
294 		//		90 million to privatesale address
295 		//		120 million to presale address
296 		//		180 million to crowdsale address
297 		//		90 million to eco supply address
298 		//		120 million to team supply address
299 		totalSupply_ = 600000000 * 10**uint(decimals);
300 		privatesaleSupply = 90000000 * 10**uint(decimals);
301 		presaleSupply = 120000000 * 10**uint(decimals);
302 		crowdsaleSupply = 180000000 * 10**uint(decimals);
303 		ecoSupply = 90000000 * 10**uint(decimals);
304 		teamSupply = 120000000 * 10**uint(decimals);
305 
306 		firstVestAmount = teamSupply.div(2);
307 		secondVestAmount = firstVestAmount;
308 		currentVestedAmount = 0;
309 
310 		privatesaleAddress = 0xE67EE1935bf160B48BA331074bb743630ee8aAea;
311 		presaleAddress = 0x4A41D67748D16aEB12708E88270d342751223870;
312 		crowdsaleAddress = 0x2eDf855e5A90DF003a5c1039bEcf4a721C9c3f9b;
313 		teamSupplyAddress = 0xc4146EcE2645038fbccf79784a6DcbE3C6586c03;
314 		ecoSupplyAddress = 0xdBA99B92a18930dA39d1e4B52177f84a0C27C8eE;
315 		crowdsaleAirdropAddress = 0x6BCb947a8e8E895d1258C1b2fc84A5d22632E6Fa;
316 		crowdsaleBurnAddress = 0xDF1CAf03FA89AfccdAbDd55bAF5C9C4b9b1ceBaB;
317 
318 		addToBalance(privatesaleAddress, privatesaleSupply);
319 		addToBalance(presaleAddress, presaleSupply);
320 		addToBalance(crowdsaleAddress, crowdsaleSupply);
321 		addToBalance(teamSupplyAddress, teamSupply);
322 		addToBalance(ecoSupplyAddress, ecoSupply);
323 
324 		// 12/01/2018 @ 12:00am (UTC)
325 		firstVestStartsAt = 1543622400;
326 		// 06/01/2019 @ 12:00am (UTC)
327 		secondVestStartsAt = 1559347200;
328 	}
329 
330 	// Transfer
331 	function transfer(address _to, uint256 _amount) public canItoSend returns (bool success) {
332 		require(balanceOf(msg.sender) >= _amount);
333 		addToBalance(_to, _amount);
334 		decrementBalance(msg.sender, _amount);
335 		Transfer(msg.sender, _to, _amount);
336 		return true;
337 	}
338 
339 	// Transfer from one address to another
340 	function transferFrom(address _from, address _to, uint256 _amount) public canItoSend returns (bool success) {
341 		require(allowance(_from, msg.sender) >= _amount);
342 		decrementBalance(_from, _amount);
343 		addToBalance(_to, _amount);
344 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
345 		Transfer(_from, _to, _amount);
346 		return true;
347 	}
348 
349 	// Function for token sell contract to call on transfers
350 	function transferFromTokenSell(address _to, address _from, uint256 _amount) external onlyTokenSale returns (bool success) {
351 		require(_amount > 0);
352 		require(_to != 0x0);
353 		require(balanceOf(_from) >= _amount);
354 		decrementBalance(_from, _amount);
355 		addToBalance(_to, _amount);
356 		Transfer(_from, _to, _amount);
357 		return true;
358 	}
359 
360 	// Approve another address a certain amount of TTT
361 	function approve(address _spender, uint256 _value) public returns (bool success) {
362 		require((_value == 0) || (allowance(msg.sender, _spender) == 0));
363 		allowed[msg.sender][_spender] = _value;
364 		Approval(msg.sender, _spender, _value);
365 		return true;
366 	}
367 
368 	// Get an address's TTT allowance
369 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
370 		return allowed[_owner][_spender];
371 	}
372 
373 	// Get TTT balance of an address
374 	function balanceOf(address _owner) public view returns (uint256 balance) {
375 		return balances[_owner];
376 	}
377 
378 	// Return total supply
379 	function totalSupply() public view returns (uint256 totalSupply) {
380 		return totalSupply_;
381 	}
382 
383 	// Set the tokenSell contract address, can only be set once
384 	function setTokenSaleAddress(address _tokenSaleAddress) external onlyOwner {
385 		require(tokenSaleAddress == 0x0);
386 		tokenSaleAddress = _tokenSaleAddress;
387 		TokensaleAddressSet(tokenSaleAddress, msg.sender);
388 	}
389 
390 	// Finalize private. If there are leftover TTT, overflow to presale
391 	function finalizePrivatesale() external onlyTokenSale returns (bool success) {
392 		require(privatesaleFinalized == false);
393 		uint256 amount = balanceOf(privatesaleAddress);
394 		if (amount != 0) {
395 			addToBalance(presaleAddress, amount);
396 			decrementBalance(privatesaleAddress, amount);
397 		}
398 		privatesaleFinalized = true;
399 		PrivatesaleFinalized(amount);
400 		return true;
401 	}
402 
403 	// Finalize presale. If there are leftover TTT, overflow to crowdsale
404 	function finalizePresale() external onlyTokenSale returns (bool success) {
405 		require(presaleFinalized == false && privatesaleFinalized == true);
406 		uint256 amount = balanceOf(presaleAddress);
407 		if (amount != 0) {
408 			addToBalance(crowdsaleAddress, amount);
409 			decrementBalance(presaleAddress, amount);
410 		}
411 		presaleFinalized = true;
412 		PresaleFinalized(amount);
413 		return true;
414 	}
415 
416 	// Finalize crowdsale. If there are leftover TTT, add 10% to airdrop, 20% to ecosupply, burn 70% at a later date
417 	function finalizeCrowdsale(uint256 _burnAmount, uint256 _ecoAmount, uint256 _airdropAmount) external onlyTokenSale returns(bool success) {
418 		require(presaleFinalized == true && crowdsaleFinalized == false);
419 		uint256 amount = balanceOf(crowdsaleAddress);
420 		assert((_burnAmount.add(_ecoAmount).add(_airdropAmount)) == amount);
421 		if (amount > 0) {
422 			crowdsaleBurnAmount = _burnAmount;
423 			addToBalance(ecoSupplyAddress, _ecoAmount);
424 			addToBalance(crowdsaleBurnAddress, crowdsaleBurnAmount);
425 			addToBalance(crowdsaleAirdropAddress, _airdropAmount);
426 			decrementBalance(crowdsaleAddress, amount);
427 			assert(balanceOf(crowdsaleAddress) == 0);
428 		}
429 		crowdsaleFinalized = true;
430 		CrowdsaleFinalized(amount);
431 		return true;
432 	}
433 
434 	/**
435 	* @dev Burns a specific amount of tokens. * added onlyOwner, as this will only happen from owner, if there are crowdsale leftovers
436 	* @param _value The amount of token to be burned.
437 	* @dev imported from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
438 	*/
439 	function burn(uint256 _value) public onlyOwner {
440 		require(_value <= balances[msg.sender]);
441 		require(crowdsaleFinalized == true);
442 		// no need to require value <= totalSupply, since that would imply the
443 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
444 
445 		address burner = msg.sender;
446 		balances[burner] = balances[burner].sub(_value);
447 		totalSupply_ = totalSupply_.sub(_value);
448 		Burn(burner, _value);
449 		Transfer(burner, address(0), _value);
450 	}
451 
452 	// Transfer tokens from the vested address. 50% available 12/01/2018, the rest available 06/01/2019
453 	function transferFromVest(uint256 _amount) public onlyOwner {
454 		require(block.timestamp > firstVestStartsAt);
455 		require(crowdsaleFinalized == true);
456 		require(_amount > 0);
457 		if(block.timestamp > secondVestStartsAt) {
458 			// all tokens available for vest withdrawl
459 			require(_amount <= teamSupply);
460 			require(_amount <= balanceOf(teamSupplyAddress));
461 		} else {
462 			// only first vest available
463 			require(_amount <= (firstVestAmount - currentVestedAmount));
464 			require(_amount <= balanceOf(teamSupplyAddress));
465 		}
466 		currentVestedAmount = currentVestedAmount.add(_amount);
467 		addToBalance(msg.sender, _amount);
468 		decrementBalance(teamSupplyAddress, _amount);
469 		Transfer(teamSupplyAddress, msg.sender, _amount);
470 	}
471 
472 	// Add to balance
473 	function addToBalance(address _address, uint _amount) internal {
474 		balances[_address] = balances[_address].add(_amount);
475 	}
476 
477 	// Remove from balance
478 	function decrementBalance(address _address, uint _amount) internal {
479 		balances[_address] = balances[_address].sub(_amount);
480 	}
481 
482 }
483 
484 contract TTTTokenSell is Whitelist, Pausable {
485 	using SafeMath for uint;
486 
487 	uint public decimals = 18;
488 
489 	// TTTToken contract address
490 	address public tokenAddress;
491 	address public wallet;
492 	// Wallets for each phase - hardcap of each is balanceOf
493 	address public privatesaleAddress;
494 	address public presaleAddress;
495 	address public crowdsaleAddress;
496 
497 	// Amount of wei currently raised
498 	uint256 public weiRaised;
499 
500 	// Variables for phase start/end
501 	uint256 public startsAt;
502 	uint256 public endsAt;
503 
504 	// minimum and maximum
505 	uint256 public ethMin;
506 	uint256 public ethMax;
507 
508 	enum CurrentPhase { Privatesale, Presale, Crowdsale, None }
509 
510 	CurrentPhase public currentPhase;
511 	uint public currentPhaseRate;
512 	address public currentPhaseAddress;
513 
514 	TTTToken public token;
515 
516 	event AmountRaised(address beneficiary, uint amountRaised);
517 	event TokenPurchased(address indexed purchaser, uint256 value, uint256 wieAmount);
518 	event TokenPhaseStarted(CurrentPhase phase, uint256 startsAt, uint256 endsAt);
519 	event TokenPhaseEnded(CurrentPhase phase);
520 
521 	modifier tokenPhaseIsActive() {
522 		assert(now >= startsAt && now <= endsAt);
523 		_;
524 	}
525 
526 	function TTTTokenSell() {
527 		wallet = 0xE6CB27F5fA75e0B75422c9B8A8da8697C9631cC6;
528 
529 		privatesaleAddress = 0xE67EE1935bf160B48BA331074bb743630ee8aAea;
530 		presaleAddress = 0x4A41D67748D16aEB12708E88270d342751223870;
531 		crowdsaleAddress = 0x2eDf855e5A90DF003a5c1039bEcf4a721C9c3f9b;
532 
533 		currentPhase = CurrentPhase.None;
534 		currentPhaseAddress = privatesaleAddress;
535 		startsAt = 0;
536 		endsAt = 0;
537 		ethMin = 0;
538 		ethMax = numToWei(1000, decimals);
539 	}
540 
541 	function setTokenAddress(address _tokenAddress) external onlyOwner {
542 		require(tokenAddress == 0x0);
543 		tokenAddress = _tokenAddress;
544 		token = TTTToken(tokenAddress);
545 	}
546 
547 	function startPhase(uint _phase, uint _currentPhaseRate, uint256 _startsAt, uint256 _endsAt) external onlyOwner {
548 		require(_phase >= 0 && _phase <= 2);
549 		require(_startsAt > endsAt && _endsAt > _startsAt);
550 		require(_currentPhaseRate > 0);
551 		currentPhase = CurrentPhase(_phase);
552 		currentPhaseAddress = getPhaseAddress();
553 		assert(currentPhaseAddress != 0x0);
554 		currentPhaseRate = _currentPhaseRate;
555 		if(currentPhase == CurrentPhase.Privatesale) ethMin = numToWei(10, decimals);
556 		else {
557 			ethMin = 0;
558 			ethMax = numToWei(15, decimals);
559 		}
560 		startsAt = _startsAt;
561 		endsAt = _endsAt;
562 		TokenPhaseStarted(currentPhase, startsAt, endsAt);
563 	}
564 
565 	function buyTokens(address _to) tokenPhaseIsActive whenNotPaused payable {
566 		require(whitelist[_to]);
567 		require(msg.value >= ethMin && msg.value <= ethMax);
568 		require(_to != 0x0);
569 		uint256 weiAmount = msg.value;
570 		uint256 tokens = weiAmount.mul(currentPhaseRate);
571 		// 100% bonus for privatesale
572 		if(currentPhase == CurrentPhase.Privatesale) tokens = tokens.add(tokens);
573 		weiRaised = weiRaised.add(weiAmount);
574 		wallet.transfer(weiAmount);
575 		if(!token.transferFromTokenSell(_to, currentPhaseAddress, tokens)) revert();
576 		TokenPurchased(_to, tokens, weiAmount);
577 	}
578 
579 	// To contribute, send a value transaction to the token sell Address.
580 	// Please include at least 100 000 gas.
581 	function () payable {
582 		buyTokens(msg.sender);
583 	}
584 
585 	function finalizePhase() external onlyOwner {
586 		if(currentPhase == CurrentPhase.Privatesale) token.finalizePrivatesale();
587 		else if(currentPhase == CurrentPhase.Presale) token.finalizePresale();
588 		endsAt = block.timestamp;
589 		currentPhase = CurrentPhase.None;
590 		TokenPhaseEnded(currentPhase);
591 	}
592 
593 	function finalizeIto(uint256 _burnAmount, uint256 _ecoAmount, uint256 _airdropAmount) external onlyOwner {
594 		token.finalizeCrowdsale(numToWei(_burnAmount, decimals), numToWei(_ecoAmount, decimals), numToWei(_airdropAmount, decimals));
595 		endsAt = block.timestamp;
596 		currentPhase = CurrentPhase.None;
597 		TokenPhaseEnded(currentPhase);
598 	}
599 
600 	function getPhaseAddress() internal view returns (address phase) {
601 		if(currentPhase == CurrentPhase.Privatesale) return privatesaleAddress;
602 		else if(currentPhase == CurrentPhase.Presale) return presaleAddress;
603 		else if(currentPhase == CurrentPhase.Crowdsale) return crowdsaleAddress;
604 		return 0x0;
605 	}
606 
607 	function numToWei(uint256 _num, uint _decimals) internal pure returns (uint256 w) {
608 		return _num.mul(10**_decimals);
609 	}
610 }