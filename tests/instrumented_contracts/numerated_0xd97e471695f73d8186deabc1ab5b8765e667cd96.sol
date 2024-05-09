1 pragma solidity 0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender)
71     public view returns (uint256);
72 
73   function transferFrom(address from, address to, uint256 value)
74     public returns (bool);
75 
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   uint256 totalSupply_;
94 
95   /**
96   * @dev total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[msg.sender]);
110 
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(
232     address _spender,
233     uint _subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 
251 /**
252  * @title Ownable
253  * @dev The Ownable contract has an owner address, and provides basic authorization control
254  * functions, this simplifies the implementation of "user permissions".
255  */
256 contract Ownable {
257   address public owner;
258 
259 
260   event OwnershipRenounced(address indexed previousOwner);
261   event OwnershipTransferred(
262     address indexed previousOwner,
263     address indexed newOwner
264   );
265 
266 
267   /**
268    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
269    * account.
270    */
271   constructor() public {
272     owner = msg.sender;
273   }
274 
275   /**
276    * @dev Throws if called by any account other than the owner.
277    */
278   modifier onlyOwner() {
279     require(msg.sender == owner);
280     _;
281   }
282 
283   /**
284    * @dev Allows the current owner to relinquish control of the contract.
285    */
286   function renounceOwnership() public onlyOwner {
287     emit OwnershipRenounced(owner);
288     owner = address(0);
289   }
290 
291   /**
292    * @dev Allows the current owner to transfer control of the contract to a newOwner.
293    * @param _newOwner The address to transfer ownership to.
294    */
295   function transferOwnership(address _newOwner) public onlyOwner {
296     _transferOwnership(_newOwner);
297   }
298 
299   /**
300    * @dev Transfers control of the contract to a newOwner.
301    * @param _newOwner The address to transfer ownership to.
302    */
303   function _transferOwnership(address _newOwner) internal {
304     require(_newOwner != address(0));
305     emit OwnershipTransferred(owner, _newOwner);
306     owner = _newOwner;
307   }
308 }
309 
310 /**
311 * @title Emco token
312 * @dev Emco token implementation
313 */
314 contract EmcoToken is StandardToken, Ownable {
315 
316 	string public constant name = "EmcoToken";
317 	string public constant symbol = "EMCO";
318 	uint8 public constant decimals = 18;
319 
320 	uint public constant INITIAL_SUPPLY = 1500000 * (10 ** uint(decimals));
321 	uint public constant MAX_SUPPLY = 36000000 * (10 ** uint(decimals));
322 
323 	mapping (address => uint) public miningBalances;
324 	mapping (address => uint) public lastMiningBalanceUpdateTime;
325 
326 	address systemAddress;
327 
328 	uint public constant DAY_MINING_DEPOSIT_LIMIT = 360000 * (10 ** uint(decimals));
329 	uint public constant TOTAL_MINING_DEPOSIT_LIMIT = 3600000 * (10 ** uint(decimals));
330 	uint currentDay;
331 	uint currentDayDeposited;
332 	uint public miningTotalDeposited;
333 
334 	mapping(address => bytes32) public userReferralCodes;
335 	mapping(bytes32 => address) public referralCodeOwners;
336 	mapping(address => address) public referrals;
337 
338 	event Mine(address indexed beneficiary, uint value);
339 
340 	event MiningBalanceUpdated(address indexed owner, uint amount, bool isDeposit);
341 
342 	constructor() public {
343 		balances[msg.sender] = INITIAL_SUPPLY;
344 		systemAddress = msg.sender;
345 		totalSupply_ = INITIAL_SUPPLY;
346 		emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
347 	}
348 
349 	function setReferralCode(bytes32 _code) public returns (bytes32) {
350 		require(_code != "", "Ref code should not be empty");
351 		require(referralCodeOwners[_code] == address(0), "This referral code is already used");
352 		require(userReferralCodes[msg.sender] == "", "Referal code is already set");
353 		userReferralCodes[msg.sender] = _code;
354 		referralCodeOwners[_code] = msg.sender;
355 		return userReferralCodes[msg.sender];
356 	}
357 
358 	function setReferral(bytes32 _code) public {
359 		require(referralCodeOwners[_code] != address(0), "Invalid referral code");
360 		require(referrals[msg.sender] == address(0), "You already have a referrer");
361 		address referrer = referralCodeOwners[_code];
362 		require(referrer != msg.sender, "Can not invite yourself");
363 		referrals[msg.sender] = referrer;
364 	}
365 
366 	/**
367 	* @dev Gets the balance of specified address (amount of tokens on main balance 
368 	* plus amount of tokens on mining balance).
369 	* @param _owner The address to query the balance of.
370 	* @return An uint256 representing the amount owned by the passed address.
371 	*/
372 	function balanceOf(address _owner) public view returns (uint balance) {
373 		return balances[_owner].add(miningBalances[_owner]);
374 	}
375 
376 	/**
377 	* @dev Gets the mining balance if caller.
378 	* @param _owner The address to query the balance of.
379 	* @return An uint256 representing the amount of tokens of caller's mining balance
380 	*/
381 	function miningBalanceOf(address _owner) public view returns (uint balance) {
382 		return miningBalances[_owner];
383 	}
384 
385 	/**
386 	* @dev Moves specified amount of tokens from main balance to mining balance 
387 	* @param _amount An uint256 representing the amount of tokens to transfer to main balance
388 	*/
389 	function depositToMiningBalance(uint _amount) public {
390 		require(balances[msg.sender] >= _amount, "not enough tokens");
391 		require(getCurrentDayDeposited().add(_amount) <= DAY_MINING_DEPOSIT_LIMIT,
392 			"Day mining deposit exceeded");
393 		require(miningTotalDeposited.add(_amount) <= TOTAL_MINING_DEPOSIT_LIMIT,
394 			"Total mining deposit exceeded");
395 
396 		balances[msg.sender] = balances[msg.sender].sub(_amount);
397 		miningBalances[msg.sender] = miningBalances[msg.sender].add(_amount);
398 		miningTotalDeposited = miningTotalDeposited.add(_amount);
399 		updateCurrentDayDeposited(_amount);
400 		lastMiningBalanceUpdateTime[msg.sender] = now;
401 		emit MiningBalanceUpdated(msg.sender, _amount, true);
402 	}
403 
404 	/**
405 	* @dev Moves specified amount of tokens from mining balance to main balance
406 	* @param _amount An uint256 representing the amount of tokens to transfer to mining balance
407 	*/
408 	function withdrawFromMiningBalance(uint _amount) public {
409 		require(miningBalances[msg.sender] >= _amount, "not enough tokens on mining balance");
410 
411 		miningBalances[msg.sender] = miningBalances[msg.sender].sub(_amount);
412 		balances[msg.sender] = balances[msg.sender].add(_amount);
413 
414 		//updating mining limits
415 		miningTotalDeposited.sub(_amount);
416 		lastMiningBalanceUpdateTime[msg.sender] = now;
417 		emit MiningBalanceUpdated(msg.sender, _amount, false);
418 	}
419 
420 	/**
421 	* @dev Mine tokens. For every 24h for each user�s token on mining balance, 
422 	* 1% is burnt on mining balance and Reward % is minted to the main balance. 15% fee of difference 
423 	* between minted coins and burnt coins goes to system address.
424 	*/ 
425 	function mine() public {
426 		require(totalSupply_ < MAX_SUPPLY, "mining is over");
427 		uint reward = getReward(totalSupply_);
428 		uint daysForReward = getDaysForReward();
429 
430 		uint mintedAmount = miningBalances[msg.sender].mul(reward.sub(1000000000))
431 										.mul(daysForReward).div(100000000000);
432 		require(mintedAmount != 0, "mining will not produce any reward");
433 
434 		uint amountToBurn = miningBalances[msg.sender].mul(daysForReward).div(100);
435 
436 		//check exceeding max number of tokens
437 		if(totalSupply_.add(mintedAmount) > MAX_SUPPLY) {
438 			uint availableToMint = MAX_SUPPLY.sub(totalSupply_);
439 			amountToBurn = availableToMint.div(mintedAmount).mul(amountToBurn);
440 			mintedAmount = availableToMint;
441 		}
442 
443 		totalSupply_ = totalSupply_.add(mintedAmount);
444 
445 		miningBalances[msg.sender] = miningBalances[msg.sender].sub(amountToBurn);
446 		balances[msg.sender] = balances[msg.sender].add(amountToBurn);
447 
448 		uint userReward;
449 		uint referrerReward = 0;
450 		address referrer = referrals[msg.sender];
451 		
452 		if(referrer == address(0)) {
453 			userReward = mintedAmount.mul(85).div(100);
454 		} else {
455 			userReward = mintedAmount.mul(86).div(100);
456 			referrerReward = mintedAmount.div(100);
457 			balances[referrer] = balances[referrer].add(referrerReward);
458 			emit Mine(referrer, referrerReward);
459 			emit Transfer(address(0), referrer, referrerReward);
460 		}
461 		balances[msg.sender] = balances[msg.sender].add(userReward);
462 
463 		emit Mine(msg.sender, userReward);
464 		emit Transfer(address(0), msg.sender, userReward);
465 
466 		//update limits
467 		miningTotalDeposited = miningTotalDeposited.sub(amountToBurn);
468 		emit MiningBalanceUpdated(msg.sender, amountToBurn, false);
469 
470 		//set system fee
471 		uint systemFee = mintedAmount.sub(userReward).sub(referrerReward);
472 		balances[systemAddress] = balances[systemAddress].add(systemFee);
473 
474 		emit Mine(systemAddress, systemFee);
475 		emit Transfer(address(0), systemAddress, systemFee);
476 
477 		lastMiningBalanceUpdateTime[msg.sender] = now;
478 	}
479 
480 	/**
481 	* @dev Set system address
482 	* @param _systemAddress An address to set
483 	*/
484 	function setSystemAddress(address _systemAddress) public onlyOwner {
485 		systemAddress = _systemAddress;
486 	}
487 
488 	/**
489 	* @dev Get sum of deposits to mining accounts for current day
490 	*/
491 	function getCurrentDayDeposited() public view returns (uint) {
492 		if(now / 1 days == currentDay) {
493 			return currentDayDeposited;
494 		} else {
495 			return 0;
496 		}
497 	}
498 
499 	/**
500 	* @dev Get number of days for reward on mining. Maximum 100 days.
501 	* @return An uint256 representing number of days user will get reward for.
502 	*/
503 	function getDaysForReward() public view returns (uint rewardDaysNum){
504 		if(lastMiningBalanceUpdateTime[msg.sender] == 0) {
505 			return 0;
506 		} else {
507 			uint value = (now - lastMiningBalanceUpdateTime[msg.sender]) / (1 days);
508 			if(value > 100) {
509 				return 100;
510 			} else {
511 				return value;
512 			}
513 		}
514 	}
515 
516 	/**
517 	* @dev Calculate current mining reward based on total supply of tokens
518 	* @return An uint256 representing reward in percents multiplied by 1000000000
519 	*/
520 	function getReward(uint _totalSupply) public pure returns (uint rewardPercent){
521 		uint rewardFactor = 1000000 * (10 ** uint256(decimals));
522 		uint decreaseFactor = 41666666;
523 
524 		if(_totalSupply < 23 * rewardFactor) {
525 			return 2000000000 - (decreaseFactor.mul(_totalSupply.div(rewardFactor)));
526 		}
527 
528 		if(_totalSupply < MAX_SUPPLY) {
529 			return 1041666666;
530 		} else {
531 			return 1000000000;
532 		} 
533 	}
534 
535 	function updateCurrentDayDeposited(uint _addedTokens) private {
536 		if(now / 1 days == currentDay) {
537 			currentDayDeposited = currentDayDeposited.add(_addedTokens);
538 		} else {
539 			currentDay = now / 1 days;
540 			currentDayDeposited = _addedTokens;
541 		}
542 	}
543 
544 }