1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     // SafeMath.sub will throw if there is not enough balance.
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 /**
138  * @title Burnable Token
139  * @dev Token that can be irreversibly burned (destroyed).
140  */
141 contract BurnableToken is BasicToken {
142 
143     event Burn(address indexed burner, uint256 value);
144 
145     /**
146      * @dev Burns a specific amount of tokens.
147      * @param _value The amount of token to be burned.
148      */
149     function burn(uint256 _value) public {
150         require(_value <= balances[msg.sender]);
151         // no need to require value <= totalSupply, since that would imply the
152         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
153 
154         address burner = msg.sender;
155         balances[burner] = balances[burner].sub(_value);
156         totalSupply = totalSupply.sub(_value);
157         Burn(burner, _value);
158     }
159 }
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public view returns (uint256) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To decrement
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _subtractedValue The amount of tokens to decrease the allowance by.
242    */
243   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 /**
257 * @title LendingBlockToken
258 * @dev LND or LendingBlock Token
259 * Max supply of 1 billion
260 * 18 decimals
261 * not transferable before end of token generation event
262 * transferable time can be set
263 */
264 contract LendingBlockToken is StandardToken, BurnableToken, Ownable {
265 	string public constant name = "Lendingblock";
266 	string public constant symbol = "LND";
267 	uint8 public constant decimals = 18;
268 	uint256 public transferableTime = 1546300800;// 1/1/2019
269 	address public tokenEventAddress;
270 
271 	/**
272 	* @dev before transferableTime, only the token event contract and owner
273 	* can transfer tokens
274 	*/
275 	modifier afterTransferableTime() {
276 		if (now <= transferableTime) {
277 			require(msg.sender == tokenEventAddress || msg.sender == owner);
278 		}
279 		_;
280 	}
281 
282 	/**
283 	* @dev constructor to initiate values
284 	* msg.sender is the token event contract
285 	* supply is 1 billion
286 	* @param _owner address that has can transfer tokens and access to change transferableTime
287 	*/
288 	function LendingBlockToken(address _owner) public {
289 		tokenEventAddress = msg.sender;
290 		owner = _owner;
291 		totalSupply = 1e9 * 1e18;
292 		balances[_owner] = totalSupply;
293 		Transfer(address(0), _owner, totalSupply);
294 	}
295 
296 	/**
297 	* @dev transferableTime restrictions on the parent function
298 	* @param _to address that will receive tokens
299 	* @param _value amount of tokens to transfer
300 	* @return boolean that indicates if the operation was successful
301 	*/
302 	function transfer(address _to, uint256 _value)
303 		public
304 		afterTransferableTime
305 		returns (bool)
306 	{
307 		return super.transfer(_to, _value);
308 	}
309 
310 	/**
311 	* @dev transferableTime restrictions on the parent function
312 	* @param _from address that is approving the tokens
313 	* @param _to address that will receive approval for the tokens
314 	* @param _value amount of tokens to approve
315 	* @return boolean that indicates if the operation was successful
316 	*/
317 	function transferFrom(address _from, address _to, uint256 _value)
318 		public
319 		afterTransferableTime
320 		returns (bool)
321 	{
322 		return super.transferFrom(_from, _to, _value);
323 	}
324 
325 	/**
326 	* @dev set transferableTime
327 	* transferableTime can only be set earlier, not later
328 	* once tokens are transferable, it cannot be paused
329 	* @param _transferableTime epoch time for transferableTime
330 	*/
331 	function setTransferableTime(uint256 _transferableTime)
332 		external
333 		onlyOwner
334 	{
335 		require(_transferableTime < transferableTime);
336 		transferableTime = _transferableTime;
337 	}
338 }
339 
340 /**
341 * @title LendingBlockTokenEvent
342 * @dev sale contract that accepts eth and sends LND tokens in return
343 * only the owner can change parameters
344 * deploys LND token when this contract is deployed
345 * 2 separate list of participants, mainly pre sale and main sale
346 * multiple rounds are possible for pre sale and main sale
347 * within a round, all participants have the same contribution min, max and rate
348 */
349 contract LendingBlockTokenEvent is Ownable {
350 	using SafeMath for uint256;
351 
352 	LendingBlockToken public token;
353 	address public wallet;
354 	bool public eventEnded;
355 	uint256 public startTimePre;
356 	uint256 public startTimeMain;
357 	uint256 public endTimePre;
358 	uint256 public endTimeMain;
359 	uint256 public ratePre;
360 	uint256 public rateMain;
361 	uint256 public minCapPre;
362 	uint256 public minCapMain;
363 	uint256 public maxCapPre;
364 	uint256 public maxCapMain;
365 	uint256 public weiTotal;
366 	mapping(address => bool) public whitelistedAddressPre;
367 	mapping(address => bool) public whitelistedAddressMain;
368 	mapping(address => uint256) public contributedValue;
369 
370 	event TokenPre(address indexed participant, uint256 value, uint256 tokens);
371 	event TokenMain(address indexed participant, uint256 value, uint256 tokens);
372 	event SetPre(uint256 startTimePre, uint256 endTimePre, uint256 minCapPre, uint256 maxCapPre, uint256 ratePre);
373 	event SetMain(uint256 startTimeMain, uint256 endTimeMain, uint256 minCapMain, uint256 maxCapMain, uint256 rateMain);
374 	event WhitelistPre(address indexed whitelistedAddress, bool whitelistedStatus);
375 	event WhitelistMain(address indexed whitelistedAddress, bool whitelistedStatus);
376 
377 	/**
378 	* @dev all functions can only be called before event has ended
379 	*/
380 	modifier eventNotEnded() {
381 		require(eventEnded == false);
382 		_;
383 	}
384 
385 	/**
386 	* @dev constructor to initiate values
387 	* @param _wallet address that will receive the contributed eth
388 	*/
389 	function LendingBlockTokenEvent(address _wallet) public {
390 		token = new LendingBlockToken(msg.sender);
391 		wallet = _wallet;
392 	}
393 
394 	/**
395 	* @dev function to join the pre sale
396 	* associated with variables, functions, events of suffix Pre
397 	*/
398 	function joinPre()
399 		public
400 		payable
401 		eventNotEnded
402 	{
403 		require(now >= startTimePre);//after start time
404 		require(now <= endTimePre);//before end time
405 		require(msg.value >= minCapPre);//contribution is at least minimum
406 		require(whitelistedAddressPre[msg.sender] == true);//sender is whitelisted
407 
408 		uint256 weiValue = msg.value;
409 		contributedValue[msg.sender] = contributedValue[msg.sender].add(weiValue);//store amount contributed
410 		require(contributedValue[msg.sender] <= maxCapPre);//total contribution not above maximum
411 
412 		uint256 tokens = weiValue.mul(ratePre);//find amount of tokens
413 		weiTotal = weiTotal.add(weiValue);//store total collected eth
414 
415 		token.transfer(msg.sender, tokens);//send token to participant
416 		TokenPre(msg.sender, weiValue, tokens);//record contribution in logs
417 
418 		forwardFunds();//send eth for safekeeping
419 	}
420 
421 	/**
422 	* @dev function to join the main sale
423 	* associated with variables, functions, events of suffix Main
424 	*/
425 	function joinMain()
426 		public
427 		payable
428 		eventNotEnded
429 	{
430 		require(now >= startTimeMain);//after start time
431 		require(now <= endTimeMain);//before end time
432 		require(msg.value >= minCapMain);//contribution is at least minimum
433 		require(whitelistedAddressMain[msg.sender] == true);//sender is whitelisted
434 
435 		uint256 weiValue = msg.value;
436 		contributedValue[msg.sender] = contributedValue[msg.sender].add(weiValue);//store amount contributed
437 		require(contributedValue[msg.sender] <= maxCapMain);//total contribution not above maximum
438 
439 		uint256 tokens = weiValue.mul(rateMain);//find amount of tokens
440 		weiTotal = weiTotal.add(weiValue);//store total collected eth
441 
442 		token.transfer(msg.sender, tokens);//send token to participant
443 		TokenMain(msg.sender, weiValue, tokens);//record contribution in logs
444 
445 		forwardFunds();//send eth for safekeeping
446 	}
447 
448 	/**
449 	* @dev send eth for safekeeping
450 	*/
451 	function forwardFunds() internal {
452 		wallet.transfer(msg.value);
453 	}
454 
455 	/**
456 	* @dev set the parameters for the contribution round
457 	* associated with variables, functions, events of suffix Pre
458 	* @param _startTimePre start time of contribution round
459 	* @param _endTimePre end time of contribution round
460 	* @param _minCapPre minimum contribution for this round
461 	* @param _maxCapPre maximum contribution for this round
462 	* @param _ratePre token exchange rate for this round
463 	*/
464 	function setPre(
465 		uint256 _startTimePre,
466 		uint256 _endTimePre,
467 		uint256 _minCapPre,
468 		uint256 _maxCapPre,
469 		uint256 _ratePre
470 	)
471 		external
472 		onlyOwner
473 		eventNotEnded
474 	{
475 		require(now < _startTimePre);//start time must be in the future
476 		require(_startTimePre < _endTimePre);//end time must be later than start time
477 		require(_minCapPre <= _maxCapPre);//minimum must be smaller or equal to maximum
478 		startTimePre = _startTimePre;
479 		endTimePre = _endTimePre;
480 		minCapPre = _minCapPre;
481 		maxCapPre = _maxCapPre;
482 		ratePre = _ratePre;
483 		SetPre(_startTimePre, _endTimePre, _minCapPre, _maxCapPre, _ratePre);
484 	}
485 
486 	/**
487 	* @dev set the parameters for the contribution round
488 	* associated with variables, functions, events of suffix Main
489 	* @param _startTimeMain start time of contribution round
490 	* @param _endTimeMain end time of contribution round
491 	* @param _minCapMain minimum contribution for this round
492 	* @param _maxCapMain maximum contribution for this round
493 	* @param _rateMain token exchange rate for this round
494 	*/
495 	function setMain(
496 		uint256 _startTimeMain,
497 		uint256 _endTimeMain,
498 		uint256 _minCapMain,
499 		uint256 _maxCapMain,
500 		uint256 _rateMain
501 	)
502 		external
503 		onlyOwner
504 		eventNotEnded
505 	{
506 		require(now < _startTimeMain);//start time must be in the future
507 		require(_startTimeMain < _endTimeMain);//end time must be later than start time
508 		require(_minCapMain <= _maxCapMain);//minimum must be smaller or equal to maximum
509 		require(_startTimeMain > endTimePre);//main round should be after pre round
510 		startTimeMain = _startTimeMain;
511 		endTimeMain = _endTimeMain;
512 		minCapMain = _minCapMain;
513 		maxCapMain = _maxCapMain;
514 		rateMain = _rateMain;
515 		SetMain(_startTimeMain, _endTimeMain, _minCapMain, _maxCapMain, _rateMain);
516 	}
517 
518 	/**
519 	* @dev change the whitelist status of an address for pre sale
520 	* associated with variables, functions, events of suffix Pre
521 	* @param whitelistedAddress list of addresses for whitelist status change
522 	* @param whitelistedStatus set the address whitelist status to true or false
523 	*/
524 	function setWhitelistedAddressPre(address[] whitelistedAddress, bool whitelistedStatus)
525 		external
526 		onlyOwner
527 		eventNotEnded
528 	{
529 		for (uint256 i = 0; i < whitelistedAddress.length; i++) {
530 			whitelistedAddressPre[whitelistedAddress[i]] = whitelistedStatus;
531 			WhitelistPre(whitelistedAddress[i], whitelistedStatus);
532 		}
533 	}
534 
535 	/**
536 	* @dev change the whitelist status of an address for main sale
537 	* associated with variables, functions, events of suffix Main
538 	* @param whitelistedAddress list of addresses for whitelist status change
539 	* @param whitelistedStatus set the address whitelist status to true or false
540 	*/
541 	function setWhitelistedAddressMain(address[] whitelistedAddress, bool whitelistedStatus)
542 		external
543 		onlyOwner
544 		eventNotEnded
545 	{
546 		for (uint256 i = 0; i < whitelistedAddress.length; i++) {
547 			whitelistedAddressMain[whitelistedAddress[i]] = whitelistedStatus;
548 			WhitelistMain(whitelistedAddress[i], whitelistedStatus);
549 		}
550 	}
551 
552 	/**
553 	* @dev end the token generation event and deactivates all functions
554 	* can only be called after end time
555 	* burn all remaining tokens in this contract that are not exchanged
556 	*/
557 	function endEvent()
558 		external
559 		onlyOwner
560 		eventNotEnded
561 	{
562 		require(now > endTimeMain);//can only be called after end time
563 		require(endTimeMain > 0);//can only be called after end time has been set
564 		uint256 leftTokens = token.balanceOf(this);//find if any tokens are left
565 		if (leftTokens > 0) {
566 			token.burn(leftTokens);//burn all remaining tokens
567 		}
568 		eventEnded = true;//deactivates all functions
569 	}
570 
571 	/**
572 	* @dev default function to call the right function for exchanging tokens
573 	* main sale should start only after pre sale
574 	*/
575 	function () external payable {
576 		if (now <= endTimePre) {//call pre function if before pre sale end time
577 			joinPre();
578 		} else if (now <= endTimeMain) {//call main function if before main sale end time
579 			joinMain();
580 		} else {
581 			revert();
582 		}
583 	}
584 
585 }