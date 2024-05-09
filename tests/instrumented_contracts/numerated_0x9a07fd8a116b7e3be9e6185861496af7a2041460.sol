1 pragma solidity 0.4.25;
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
310 contract EmcoTokenInterface is ERC20 {
311 
312     function setReferral(bytes32 _code) public;
313     function setReferralCode(bytes32 _code) public view returns (bytes32);
314 
315     function referralCodeOwners(bytes32 _code) public view returns (address);
316     function referrals(address _address) public view returns (address);
317     function userReferralCodes(address _address) public view returns (bytes32);
318 
319 }
320 
321 /**
322 * @title Emco token 2nd version
323 * @dev Emco token implementation
324 */
325 contract EmcoToken is StandardToken, Ownable {
326 
327     string public constant name = "EmcoToken";
328     string public constant symbol = "EMCO";
329     uint8 public constant decimals = 18;
330 
331     uint public constant MAX_SUPPLY = 36000000 * (10 ** uint(decimals));
332 
333     mapping (address => uint) public miningBalances;
334     mapping (address => uint) public lastMiningBalanceUpdateTime;
335 
336     address systemAddress;
337 
338     EmcoTokenInterface private oldContract;
339 
340     uint public constant DAY_MINING_DEPOSIT_LIMIT = 360000 * (10 ** uint(decimals));
341     uint public constant TOTAL_MINING_DEPOSIT_LIMIT = 3600000 * (10 ** uint(decimals));
342     uint private currentDay;
343     uint private currentDayDeposited;
344     uint public miningTotalDeposited;
345 
346     mapping(address => bytes32) private userRefCodes;
347     mapping(bytes32 => address) private refCodeOwners;
348     mapping(address => address) private refs;
349 
350     event Mine(address indexed beneficiary, uint value);
351 
352     event MiningBalanceUpdated(address indexed owner, uint amount, bool isDeposit);
353 
354     event Migrate(address indexed user, uint256 amount);
355 
356     event TransferComment(address indexed to, uint256 amount, bytes comment);
357 
358     event SetReferral(address whoSet, address indexed referrer);
359 
360     constructor(address emcoAddress) public {
361         systemAddress = msg.sender;
362         oldContract = EmcoTokenInterface(emcoAddress);
363     }
364 
365     /**
366     * @dev Function for migration from old token
367     * @param _amount Amount of old EMCO tokens to exchnage for new ones
368     */
369     function migrate(uint _amount) public {
370         require(oldContract.transferFrom(msg.sender, this, _amount), "old token transfer exception");
371         totalSupply_ = totalSupply_.add(_amount);
372         balances[msg.sender] = balances[msg.sender].add(_amount);
373         emit Migrate(msg.sender, _amount);
374         emit Transfer(address(0), msg.sender, _amount);
375     }
376 
377     /**
378     * @dev Set referral (inviter) code
379     * @param _code Code to be set. Code should be initially encoded with web3.utils.asciiToHex function
380     */
381     function setReferralCode(bytes32 _code) public returns (bytes32) {
382         require(_code != "", "code can't be empty");
383         require(referralCodeOwners(_code) == address(0), "code is already used");
384         require(userReferralCodes(msg.sender) == "", "another code is already set");
385         userRefCodes[msg.sender] = _code;
386         refCodeOwners[_code] = msg.sender;
387         return _code;
388     }
389 
390     /**
391     * @dev Get owner of referral (inviter) code
392     * @param _code code to check
393     * @return owner of code
394     */
395     function referralCodeOwners(bytes32 _code) public view returns (address owner) {
396         address refCodeOwner = refCodeOwners[_code];
397         if(refCodeOwner == address(0)) {
398             return oldContract.referralCodeOwners(_code);
399         } else {
400             return refCodeOwner;
401         }
402     }
403 
404     /**
405     * @dev Get account's referral (inviter) code
406     * @param _address address of user to check for code
407     * @return referral code of user
408     */
409     function userReferralCodes(address _address) public view returns (bytes32) {
410         bytes32 code = oldContract.userReferralCodes(_address);
411         if(code != "") {
412             return code;
413         } else {
414             return userRefCodes[_address];
415         }
416     }
417 
418     /**
419     * @dev Get referral (inviter) of account
420     * @param _address Account's address
421     * @return Address of referral (inviter)
422     */
423     function referrals(address _address) public view returns (address) {
424         address refInOldContract = oldContract.referrals(_address);
425         if(refInOldContract != address(0)) {
426             return refInOldContract;
427         } else {
428             return refs[_address];
429         }
430     }
431 
432     /**
433     * @dev Set referral (inviter) by his referral code
434     * @param _code Inviter's code
435     */
436     function setReferral(bytes32 _code) public {
437         require(referralCodeOwners(_code) != address(0), "no referral with this code");
438         require(referrals(msg.sender) == address(0), "referral is already set");
439         address referrer = referralCodeOwners(_code);
440         require(referrer != msg.sender, "Can not invite yourself");
441         refs[msg.sender] = referrer;
442         emit SetReferral(msg.sender, referrer);
443     }
444 
445     /**
446     * @dev Transfer token with comment
447     * @param _to The address to transfer to.
448     * @param _value The amount to be transferred.
449     @ @param _comment The comemnt of transaction
450     */
451     function transferWithComment(address _to, uint256 _value, bytes _comment) public returns (bool) {
452         emit TransferComment(_to, _value, _comment);
453         return transfer(_to, _value);
454     }
455 
456 	/**
457 	* @dev Gets the balance of specified address (amount of tokens on main balance 
458 	* plus amount of tokens on mining balance).
459 	* @param _owner The address to query the balance of.
460 	* @return An uint256 representing the amount owned by the passed address.
461 	*/
462     function balanceOf(address _owner) public view returns (uint balance) {
463         return balances[_owner].add(miningBalances[_owner]);
464     }
465 
466 	/**
467 	* @dev Gets the mining balance if caller.
468 	* @param _owner The address to query the balance of.
469 	* @return An uint256 representing the amount of tokens of caller's mining balance
470 	*/
471     function miningBalanceOf(address _owner) public view returns (uint balance) {
472         return miningBalances[_owner];
473     }
474 
475 	/**
476 	* @dev Moves specified amount of tokens from main balance to mining balance 
477 	* @param _amount An uint256 representing the amount of tokens to transfer to main balance
478 	*/
479     function depositToMiningBalance(uint _amount) public {
480         require(balances[msg.sender] >= _amount, "not enough tokens");
481         require(getCurrentDayDeposited().add(_amount) <= DAY_MINING_DEPOSIT_LIMIT, "Day mining deposit exceeded");
482         require(miningTotalDeposited.add(_amount) <= TOTAL_MINING_DEPOSIT_LIMIT, "Total mining deposit exceeded");
483 
484         balances[msg.sender] = balances[msg.sender].sub(_amount);
485         miningBalances[msg.sender] = miningBalances[msg.sender].add(_amount);
486         miningTotalDeposited = miningTotalDeposited.add(_amount);
487         updateCurrentDayDeposited(_amount);
488         lastMiningBalanceUpdateTime[msg.sender] = now;
489         emit MiningBalanceUpdated(msg.sender, _amount, true);
490     }
491 
492 	/**
493 	* @dev Moves specified amount of tokens from mining balance to main balance
494 	* @param _amount An uint256 representing the amount of tokens to transfer to mining balance
495 	*/
496     function withdrawFromMiningBalance(uint _amount) public {
497         require(miningBalances[msg.sender] >= _amount, "not enough mining tokens");
498 
499         miningBalances[msg.sender] = miningBalances[msg.sender].sub(_amount);
500         balances[msg.sender] = balances[msg.sender].add(_amount);
501 
502         //updating mining limits
503         miningTotalDeposited = miningTotalDeposited.sub(_amount);
504         lastMiningBalanceUpdateTime[msg.sender] = now;
505         emit MiningBalanceUpdated(msg.sender, _amount, false);
506     }
507 
508 	/**
509 	* @dev Mine tokens. For every 24h for each user�s token on mining balance, 
510 	* 1% is burnt on mining balance and Reward % is minted to the main balance. 15% fee of difference 
511 	* between minted coins and burnt coins goes to system address.
512 	*/ 
513     function mine() public {
514         require(totalSupply_ < MAX_SUPPLY, "mining is over");
515         uint reward = getReward(totalSupply_);
516         uint daysForReward = getDaysForReward();
517 
518         uint mintedAmount = miningBalances[msg.sender].mul(reward.sub(1000000000)).mul(daysForReward).div(100000000000);
519         require(mintedAmount != 0, "no reward");
520 
521         uint amountToBurn = miningBalances[msg.sender].mul(daysForReward).div(100);
522 
523         //check exceeding max number of tokens
524         if(totalSupply_.add(mintedAmount) > MAX_SUPPLY) {
525             uint availableToMint = MAX_SUPPLY.sub(totalSupply_);
526             amountToBurn = availableToMint.div(mintedAmount).mul(amountToBurn);
527             mintedAmount = availableToMint;
528         }
529 
530         miningBalances[msg.sender] = miningBalances[msg.sender].sub(amountToBurn);
531         balances[msg.sender] = balances[msg.sender].add(amountToBurn);
532 
533         uint userReward;
534         uint referrerReward = 0;
535         address referrer = referrals(msg.sender);
536 
537         if(referrer == address(0)) {
538             userReward = mintedAmount.mul(85).div(100);
539         } else {
540             userReward = mintedAmount.mul(86).div(100);
541             referrerReward = mintedAmount.div(100);
542             mineReward(referrer, referrerReward);
543         }
544         mineReward(msg.sender, userReward);
545 
546         totalSupply_ = totalSupply_.add(mintedAmount);
547 
548         //update limits
549         miningTotalDeposited = miningTotalDeposited.sub(amountToBurn);
550         emit MiningBalanceUpdated(msg.sender, amountToBurn, false);
551 
552         //set system fee
553         uint systemFee = mintedAmount.sub(userReward).sub(referrerReward);
554         mineReward(systemAddress, systemFee);
555 
556         lastMiningBalanceUpdateTime[msg.sender] = now;
557     }
558 
559     function mineReward(address _to, uint _amount) private {
560         balances[_to] = balances[_to].add(_amount);
561         emit Mine(_to, _amount);
562         emit Transfer(address(0), _to, _amount);
563     }
564 
565 	/**
566 	* @dev Set system address
567 	* @param _systemAddress An address to set
568 	*/
569     function setSystemAddress(address _systemAddress) public onlyOwner {
570         systemAddress = _systemAddress;
571     }
572 
573 	/**
574 	* @dev Get sum of deposits to mining accounts for current day
575     * @return sum of deposits to mining accounts for current day
576 	*/
577     function getCurrentDayDeposited() public view returns (uint) {
578         if(now / 1 days == currentDay) {
579             return currentDayDeposited;
580         } else {
581             return 0;
582         }
583     }
584 
585 	/**
586 	* @dev Get number of days for reward on mining. Maximum 100 days.
587 	* @return An uint256 representing number of days user will get reward for.
588 	*/
589     function getDaysForReward() public view returns (uint rewardDaysNum){
590         if(lastMiningBalanceUpdateTime[msg.sender] == 0) {
591             return 0;
592         } else {
593             uint value = (now - lastMiningBalanceUpdateTime[msg.sender]) / (1 days);
594             if(value > 100) {
595                 return 100;
596             } else {
597                 return value;
598             }
599         }
600     }
601 
602 	/**
603 	* @dev Calculate current mining reward based on total supply of tokens
604 	* @return An uint256 representing reward in percents multiplied by 1000000000
605 	*/
606     function getReward(uint _totalSupply) public pure returns (uint rewardPercent){
607         uint rewardFactor = 1000000 * (10 ** uint256(decimals));
608         uint decreaseFactor = 41666666;
609 
610         if(_totalSupply < 23 * rewardFactor) {
611             return 2000000000 - (decreaseFactor.mul(_totalSupply.div(rewardFactor)));
612         }
613 
614         if(_totalSupply < MAX_SUPPLY) {
615             return 1041666666;
616         } else {
617             return 1000000000;
618         } 
619     }
620 
621     function updateCurrentDayDeposited(uint _addedTokens) private {
622         if(now / 1 days == currentDay) {
623             currentDayDeposited = currentDayDeposited.add(_addedTokens);
624         } else {
625             currentDay = now / 1 days;
626             currentDayDeposited = _addedTokens;
627         }
628     }
629 }