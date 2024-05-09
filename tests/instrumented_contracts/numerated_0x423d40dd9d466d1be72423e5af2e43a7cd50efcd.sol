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
322 * @title EMCO Clan
323 * @dev EMCO Clan
324 */
325 contract Clan is Ownable {
326     using SafeMath for uint256;
327 
328     mapping(address => uint256) public rewards;
329     mapping(uint256 => uint256) public epochRewards;
330     mapping(address => uint256) public epochJoined;
331     mapping(uint => uint256) private membersNumForEpoch;
332 
333     mapping(address => mapping(uint => bool)) public reclaimedRewards;
334 
335     uint public lastMembersNumber = 0;
336 
337     event UserJoined(address userAddress);
338     event UserLeaved(address userAddress);
339 
340     uint public startBlock;
341     uint public epochLength;
342 
343     uint public ownersReward;
344 
345     EmcoToken emco;
346 
347     address public clanOwner;
348 
349     constructor(address _clanOwner, address _emcoToken, uint256 _epochLength) public {
350         clanOwner = _clanOwner;
351         startBlock = block.number;
352         epochLength = _epochLength; 
353         emco = EmcoToken(_emcoToken);
354     }
355 
356     function replenish(uint amount) public onlyOwner {
357         //update members number for epoch if it was not set
358         //we should ensure that for each epoch that has a reward members num is set
359         uint currentEpoch = getCurrentEpoch();
360         if(membersNumForEpoch[currentEpoch] == 0) {
361             membersNumForEpoch[currentEpoch] = lastMembersNumber;
362         }
363         uint ownersPart;
364         if(membersNumForEpoch[currentEpoch] == 0) {
365             //first user joined, mines on current epoch, but user is able to redeem for next epoch
366             ownersPart = amount;
367         } else {
368             ownersPart = amount.div(10);
369             epochRewards[currentEpoch] = epochRewards[currentEpoch].add(amount - ownersPart);
370         }
371         ownersReward = ownersReward.add(ownersPart);
372     }
373 
374     function getMembersForEpoch(uint epochNumber) public view returns (uint membersNumber) {
375         return membersNumForEpoch[epochNumber];
376     }
377 
378     function getCurrentEpoch() public view returns (uint256) {
379         return (block.number - startBlock) / epochLength; 
380     }
381 
382     //only token can join a user to a clan. Owner is an EMCO Token contract 
383     function join(address user) public onlyOwner {
384         emit UserJoined(user);
385         uint currentEpoch = getCurrentEpoch();
386         epochJoined[user] = currentEpoch + 1;
387 
388         //increment members number
389         uint currentMembersNum = lastMembersNumber;
390         if(currentMembersNum == 0) {
391             membersNumForEpoch[currentEpoch + 1] = currentMembersNum + 1;
392         } else {
393             membersNumForEpoch[currentEpoch + 1] = membersNumForEpoch[currentEpoch + 1] + 1;
394         }
395         //update last members num
396         lastMembersNumber = membersNumForEpoch[currentEpoch + 1];
397     }
398 
399     function leaveClan(address user) public onlyOwner {
400         epochJoined[user] = 0;
401         emit UserLeaved(user);
402 
403         //decrement members number
404         uint currentEpoch = getCurrentEpoch();
405         uint currentMembersNum = lastMembersNumber;
406         if(currentMembersNum != 0) {
407             membersNumForEpoch[currentEpoch + 1] = membersNumForEpoch[currentEpoch + 1] - 1;
408         } 
409         //update last members num
410         lastMembersNumber = membersNumForEpoch[currentEpoch + 1];
411     }
412 
413     function calculateReward(uint256 epoch) public view returns (uint256) {
414         return epochRewards[epoch].div(membersNumForEpoch[epoch]);
415     }
416 
417     function reclaimOwnersReward() public {
418         require(msg.sender == clanOwner);
419         emco.transfer(msg.sender, ownersReward);
420         ownersReward = 0;
421     }
422 
423     //get your bonus for specific epoch
424     function reclaimReward(uint256 epoch) public {
425         uint currentEpoch = getCurrentEpoch();
426         require(currentEpoch > epoch);
427         require(epochJoined[msg.sender] != 0);
428         require(epochJoined[msg.sender] <= epoch);
429         require(reclaimedRewards[msg.sender][epoch] == false);
430 
431         uint userReward = calculateReward(epoch);
432         require(userReward > 0);
433 
434         require(emco.transfer(msg.sender, userReward));
435         reclaimedRewards[msg.sender][epoch] = true;
436     }
437 
438 }
439 
440 /**
441 * @title Emco token 2nd version
442 * @dev Emco token implementation
443 */
444 contract EmcoToken is StandardToken, Ownable {
445 
446     string public constant name = "EmcoToken";
447     string public constant symbol = "EMCO";
448     uint8 public constant decimals = 18;
449 
450     // uint public constant INITIAL_SUPPLY = 1500000 * (10 ** uint(decimals));
451     uint public constant MAX_SUPPLY = 36000000 * (10 ** uint(decimals));
452 
453     mapping (address => uint) public miningBalances;
454     mapping (address => uint) public lastMiningBalanceUpdateTime;
455 
456     //clans
457     mapping (address => address) public joinedClans;
458     mapping (address => address) public userClans;
459     mapping (address => bool) public clanRegistry;
460     mapping (address => uint256) public inviteeCount;
461 
462     address systemAddress;
463 
464     EmcoTokenInterface private oldContract;
465 
466     uint public constant DAY_MINING_DEPOSIT_LIMIT = 360000 * (10 ** uint(decimals));
467     uint public constant TOTAL_MINING_DEPOSIT_LIMIT = 3600000 * (10 ** uint(decimals));
468     uint currentDay;
469     uint currentDayDeposited;
470     uint public miningTotalDeposited;
471 
472     mapping(address => bytes32) private userRefCodes;
473     mapping(bytes32 => address) private refCodeOwners;
474     mapping(address => address) private refs;
475 
476     event Mine(address indexed beneficiary, uint value);
477 
478     event MiningBalanceUpdated(address indexed owner, uint amount, bool isDeposit);
479 
480     event Migrate(address indexed user, uint256 amount);
481 
482     event TransferComment(address indexed to, uint256 amount, bytes comment);
483 
484     event SetReferral(address whoSet, address indexed referrer);
485 
486     constructor(address emcoAddress) public {
487         systemAddress = msg.sender;
488         oldContract = EmcoTokenInterface(emcoAddress);
489     }
490 
491     function migrate(uint _amount) public {
492         require(oldContract.transferFrom(msg.sender, this, _amount));
493         totalSupply_ = totalSupply_.add(_amount);
494         balances[msg.sender] = balances[msg.sender].add(_amount);
495         emit Migrate(msg.sender, _amount);
496         emit Transfer(address(0), msg.sender, _amount);
497     }
498 
499     function setReferralCode(bytes32 _code) public returns (bytes32) {
500         require(_code != "");
501         require(refCodeOwners[_code] == address(0));
502         require(oldContract.referralCodeOwners(_code) == address(0));
503         require(userReferralCodes(msg.sender) == "");
504         userRefCodes[msg.sender] = _code;
505         refCodeOwners[_code] = msg.sender;
506         return _code;
507     }
508 
509     function referralCodeOwners(bytes32 _code) public view returns (address owner) {
510         address refCodeOwner = refCodeOwners[_code];
511         if(refCodeOwner == address(0)) {
512             return oldContract.referralCodeOwners(_code);
513         } else {
514             return refCodeOwner;
515         }
516     }
517 
518     function userReferralCodes(address _address) public view returns (bytes32) {
519         bytes32 code = oldContract.userReferralCodes(_address);
520         if(code != "") {
521             return code;
522         } else {
523             return userRefCodes[_address];
524         }
525     }
526 
527     function referrals(address _address) public view returns (address) {
528         address refInOldContract = oldContract.referrals(_address);
529         if(refInOldContract != address(0)) {
530             return refInOldContract;
531         } else {
532             return refs[_address];
533         }
534     }
535 
536     function setReferral(bytes32 _code) public {
537         require(refCodeOwners[_code] != address(0));
538         require(referrals(msg.sender) == address(0));
539         require(oldContract.referrals(msg.sender) == address(0));
540         address referrer = refCodeOwners[_code];
541         require(referrer != msg.sender, "Can not invite yourself");
542         refs[msg.sender] = referrer;
543         inviteeCount[referrer] = inviteeCount[referrer].add(1);
544         emit SetReferral(msg.sender, referrer);
545     }
546 
547     function transferWithComment(address _to, uint256 _value, bytes _comment) public returns (bool) {
548         emit TransferComment(_to, _value, _comment);
549         return transfer(_to, _value);
550     }
551 
552 	/**
553 	* Create a clan
554 	*/
555     function createClan(uint256 epochLength) public returns (address clanAddress) {
556         require(epochLength >= 175200); //min epoch length about a month
557 		//check if there is a clan already. If so, throw
558         require(userClans[msg.sender] == address(0x0));
559 		//check if user has at least 10 invitees
560         require(inviteeCount[msg.sender] >= 10);
561 
562 		//instantiate new instance of contract
563         Clan clan = new Clan(msg.sender, this, epochLength);
564 
565 		//register clan to mapping
566         userClans[msg.sender] = clan;
567         clanRegistry[clan] = true;
568         return clan;
569     }
570 
571 	function joinClan(address clanAddress) public {
572 		//ensure than such clan exists
573 		require(clanRegistry[clanAddress]);
574 		require(joinedClans[msg.sender] == address(0x0));
575 
576 		//join user to clan
577 		Clan clan = Clan(clanAddress);
578 		clan.join(msg.sender);
579 
580 		//set clan to user
581 		joinedClans[msg.sender] = clanAddress;
582 	}
583 
584 	function leaveClan() public {
585 		address clanAddress = joinedClans[msg.sender];
586 		require(clanAddress != address(0x0));
587 
588 		Clan clan = Clan(clanAddress);
589 		clan.leaveClan(msg.sender);
590 
591 		//unregister user from clan
592 		joinedClans[msg.sender] = address(0x0);
593 	}
594 
595 	/**
596 	* Update invitees count
597 	*/
598 	function updateInviteesCount(address invitee, uint256 count) public onlyOwner {
599 		inviteeCount[invitee] = count;
600 	}
601 
602 	/**
603 	* @dev Gets the balance of specified address (amount of tokens on main balance 
604 	* plus amount of tokens on mining balance).
605 	* @param _owner The address to query the balance of.
606 	* @return An uint256 representing the amount owned by the passed address.
607 	*/
608 	function balanceOf(address _owner) public view returns (uint balance) {
609 		return balances[_owner].add(miningBalances[_owner]);
610 	}
611 
612 	/**
613 	* @dev Gets the mining balance if caller.
614 	* @param _owner The address to query the balance of.
615 	* @return An uint256 representing the amount of tokens of caller's mining balance
616 	*/
617 	function miningBalanceOf(address _owner) public view returns (uint balance) {
618 		return miningBalances[_owner];
619 	}
620 
621 	/**
622 	* @dev Moves specified amount of tokens from main balance to mining balance 
623 	* @param _amount An uint256 representing the amount of tokens to transfer to main balance
624 	*/
625 	function depositToMiningBalance(uint _amount) public {
626 		require(balances[msg.sender] >= _amount, "not enough tokens");
627 		require(getCurrentDayDeposited().add(_amount) <= DAY_MINING_DEPOSIT_LIMIT,
628 			"Day mining deposit exceeded");
629 		require(miningTotalDeposited.add(_amount) <= TOTAL_MINING_DEPOSIT_LIMIT,
630 			"Total mining deposit exceeded");
631 
632 		balances[msg.sender] = balances[msg.sender].sub(_amount);
633 		miningBalances[msg.sender] = miningBalances[msg.sender].add(_amount);
634 		miningTotalDeposited = miningTotalDeposited.add(_amount);
635 		updateCurrentDayDeposited(_amount);
636 		lastMiningBalanceUpdateTime[msg.sender] = now;
637 		emit MiningBalanceUpdated(msg.sender, _amount, true);
638 	}
639 
640 	/**
641 	* @dev Moves specified amount of tokens from mining balance to main balance
642 	* @param _amount An uint256 representing the amount of tokens to transfer to mining balance
643 	*/
644 	function withdrawFromMiningBalance(uint _amount) public {
645 		require(miningBalances[msg.sender] >= _amount, "not enough mining tokens");
646 
647 		miningBalances[msg.sender] = miningBalances[msg.sender].sub(_amount);
648 		balances[msg.sender] = balances[msg.sender].add(_amount);
649 
650 		//updating mining limits
651 		miningTotalDeposited = miningTotalDeposited.sub(_amount);
652 		lastMiningBalanceUpdateTime[msg.sender] = now;
653 		emit MiningBalanceUpdated(msg.sender, _amount, false);
654 	}
655 
656 	/**
657 	* @dev Mine tokens. For every 24h for each user�s token on mining balance, 
658 	* 1% is burnt on mining balance and Reward % is minted to the main balance. 15% fee of difference 
659 	* between minted coins and burnt coins goes to system address.
660 	*/ 
661 	function mine() public {
662 		require(totalSupply_ < MAX_SUPPLY, "mining is over");
663 		uint reward = getReward(totalSupply_);
664 		uint daysForReward = getDaysForReward();
665 
666 		uint mintedAmount = miningBalances[msg.sender].mul(reward.sub(1000000000))
667 										.mul(daysForReward).div(100000000000);
668 		require(mintedAmount != 0);
669 
670 		uint amountToBurn = miningBalances[msg.sender].mul(daysForReward).div(100);
671 
672 		//check exceeding max number of tokens
673 		if(totalSupply_.add(mintedAmount) > MAX_SUPPLY) {
674 			uint availableToMint = MAX_SUPPLY.sub(totalSupply_);
675 			amountToBurn = availableToMint.div(mintedAmount).mul(amountToBurn);
676 			mintedAmount = availableToMint;
677 		}
678 
679 		totalSupply_ = totalSupply_.add(mintedAmount);
680 
681 		miningBalances[msg.sender] = miningBalances[msg.sender].sub(amountToBurn);
682 		balances[msg.sender] = balances[msg.sender].add(amountToBurn);
683 
684 		uint userReward;
685 		uint referrerReward = 0;
686 		address referrer = referrals(msg.sender);
687 		
688 		if(referrer == address(0)) {
689 			userReward = mintedAmount.mul(85).div(100);
690 		} else {
691 			userReward = mintedAmount.mul(86).div(100);
692 			referrerReward = mintedAmount.div(100);
693 			balances[referrer] = balances[referrer].add(referrerReward);
694 			emit Mine(referrer, referrerReward);
695 			emit Transfer(address(0), referrer, referrerReward);
696 		}
697 		balances[msg.sender] = balances[msg.sender].add(userReward);
698 
699 		emit Mine(msg.sender, userReward);
700 		emit Transfer(address(0), msg.sender, userReward);
701 
702 		//update limits
703 		miningTotalDeposited = miningTotalDeposited.sub(amountToBurn);
704 		emit MiningBalanceUpdated(msg.sender, amountToBurn, false);
705 
706 		//set system fee
707 		uint systemFee = mintedAmount.sub(userReward).sub(referrerReward);
708 		balances[systemAddress] = balances[systemAddress].add(systemFee);
709 
710 		emit Mine(systemAddress, systemFee);
711 		emit Transfer(address(0), systemAddress, systemFee);
712 
713 		lastMiningBalanceUpdateTime[msg.sender] = now;
714 
715 		//assign to clan address
716 		mintClanReward(mintedAmount.mul(5).div(1000));
717 	}
718 
719 	function mintClanReward(uint reward) private {
720 		//check if user has a clan
721 		address clanAddress = joinedClans[msg.sender];
722 		if(clanAddress != address(0x0)) {
723 			// check if this clan is registered
724 			require(clanRegistry[clanAddress], "clan is not registered");
725 
726 			// send appropriate amount of EMCO to clan address
727 			balances[clanAddress] = balances[clanAddress].add(reward);
728 			Clan clan = Clan(clanAddress);
729 			clan.replenish(reward);
730 			totalSupply_ = totalSupply_.add(reward);
731 		}
732 	}
733 
734 	/**
735 	* @dev Set system address
736 	* @param _systemAddress An address to set
737 	*/
738 	function setSystemAddress(address _systemAddress) public onlyOwner {
739 		systemAddress = _systemAddress;
740 	}
741 
742 	/**
743 	* @dev Get sum of deposits to mining accounts for current day
744 	*/
745 	function getCurrentDayDeposited() public view returns (uint) {
746 		if(now / 1 days == currentDay) {
747 			return currentDayDeposited;
748 		} else {
749 			return 0;
750 		}
751 	}
752 
753 	/**
754 	* @dev Get number of days for reward on mining. Maximum 100 days.
755 	* @return An uint256 representing number of days user will get reward for.
756 	*/
757 	function getDaysForReward() public view returns (uint rewardDaysNum){
758 		if(lastMiningBalanceUpdateTime[msg.sender] == 0) {
759 			return 0;
760 		} else {
761 			uint value = (now - lastMiningBalanceUpdateTime[msg.sender]) / (1 days);
762 			if(value > 100) {
763 				return 100;
764 			} else {
765 				return value;
766 			}
767 		}
768 	}
769 
770 	/**
771 	* @dev Calculate current mining reward based on total supply of tokens
772 	* @return An uint256 representing reward in percents multiplied by 1000000000
773 	*/
774 	function getReward(uint _totalSupply) public pure returns (uint rewardPercent){
775 		uint rewardFactor = 1000000 * (10 ** uint256(decimals));
776 		uint decreaseFactor = 41666666;
777 
778 		if(_totalSupply < 23 * rewardFactor) {
779 			return 2000000000 - (decreaseFactor.mul(_totalSupply.div(rewardFactor)));
780 		}
781 
782 		if(_totalSupply < MAX_SUPPLY) {
783 			return 1041666666;
784 		} else {
785 			return 1000000000;
786 		} 
787 	}
788 
789     function updateCurrentDayDeposited(uint _addedTokens) private {
790         if(now / 1 days == currentDay) {
791             currentDayDeposited = currentDayDeposited.add(_addedTokens);
792         } else {
793             currentDay = now / 1 days;
794             currentDayDeposited = _addedTokens;
795         }
796     }
797 }