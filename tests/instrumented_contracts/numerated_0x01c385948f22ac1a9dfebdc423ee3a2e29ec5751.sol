1 pragma solidity ^0.4.13;
2 
3 interface IFlyDropTokenMgr {
4     // Send tokens to other multi addresses in one function
5     function prepare(uint256 _rand,
6                      address _from,
7                      address _token,
8                      uint256 _value) external returns (bool);
9 
10     // Send tokens to other multi addresses in one function
11     function flyDrop(address[] _destAddrs, uint256[] _values) external returns (uint256);
12 
13     // getter to determine if address has poweruser role
14     function isPoweruser(address _addr) external view returns (bool);
15 }
16 
17 interface ILockedStorage {
18     // get frozen status for the _wallet address
19     function frozenAccounts(address _wallet) external view returns (bool);
20 
21     // get a wallet address by the account address and the index
22     function isExisted(address _wallet) external view returns (bool);
23 
24     // get a wallet name by the account address and the index
25     function walletName(address _wallet) external view returns (string);
26 
27     // get the frozen amount of the account address
28     function frozenAmount(address _wallet) external view returns (uint256);
29 
30     // get the balance of the account address
31     function balanceOf(address _wallet) external view returns (uint256);
32 
33     // get the account address by index
34     function addressByIndex(uint256 _ind) external view returns (address);
35 
36     // get the number of the locked stage of the target address
37     function lockedStagesNum(address _target) external view returns (uint256);
38 
39     // get the endtime of the locked stages of an account
40     function endTimeOfStage(address _target, uint _ind) external view returns (uint256);
41 
42     // get the remain unrleased tokens of the locked stages of an account
43     function remainOfStage(address _target, uint _ind) external view returns (uint256);
44 
45     // get the remain unrleased tokens of the locked stages of an account
46     function amountOfStage(address _target, uint _ind) external view returns (uint256);
47 
48     // get the remain releasing period end time of an account
49     function releaseEndTimeOfStage(address _target, uint _ind) external view returns (uint256);
50 
51     // get the frozen amount of the account address
52     function size() external view returns (uint256);
53 
54     // add one account address for that wallet
55     function addAccount(address _wallet, string _name, uint256 _value) external returns (bool);
56 
57     // add a time record of one account
58     function addLockedTime(address _target,
59                            uint256 _value,
60                            uint256 _frozenEndTime,
61                            uint256 _releasePeriod) external returns (bool);
62 
63     // freeze or release the tokens that has been locked in the account address.
64     function freezeTokens(address _wallet, bool _freeze, uint256 _value) external returns (bool);
65 
66     // increase balance of this account address
67     function increaseBalance(address _wallet, uint256 _value) external returns (bool);
68 
69     // decrease balance of this account address
70     function decreaseBalance(address _wallet, uint256 _value) external returns (bool);
71 
72     // remove account contract address from storage
73     function removeAccount(address _wallet) external returns (bool);
74 
75     // remove a time records from the time records list of one account
76     function removeLockedTime(address _target, uint _ind) external returns (bool);
77 
78     // set the new endtime of the released time of an account
79     function changeEndTime(address _target, uint256 _ind, uint256 _newEndTime) external returns (bool);
80 
81     // set the new released period end time of an account
82     function setNewReleaseEndTime(address _target, uint256 _ind, uint256 _newReleaseEndTime) external returns (bool);
83 
84     // decrease the remaining locked amount of an account
85     function decreaseRemainLockedOf(address _target, uint256 _ind, uint256 _value) external returns (bool);
86 
87     // withdraw tokens from this contract
88     function withdrawToken(address _token, address _to, uint256 _value) external returns (bool);
89 }
90 
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, throws on overflow.
95   */
96   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
97     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
98     // benefit is lost if 'b' is also tested.
99     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100     if (_a == 0) {
101       return 0;
102     }
103 
104     c = _a * _b;
105     assert(c / _a == _b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     // assert(_b > 0); // Solidity automatically throws when dividing by 0
114     // uint256 c = _a / _b;
115     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
116     return _a / _b;
117   }
118 
119   /**
120   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
123     assert(_b <= _a);
124     return _a - _b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
131     c = _a + _b;
132     assert(c >= _a);
133     return c;
134   }
135 }
136 
137 contract Ownable {
138   address public owner;
139 
140 
141   event OwnershipRenounced(address indexed previousOwner);
142   event OwnershipTransferred(
143     address indexed previousOwner,
144     address indexed newOwner
145   );
146 
147 
148   /**
149    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
150    * account.
151    */
152   constructor() public {
153     owner = msg.sender;
154   }
155 
156   /**
157    * @dev Throws if called by any account other than the owner.
158    */
159   modifier onlyOwner() {
160     require(msg.sender == owner);
161     _;
162   }
163 
164   /**
165    * @dev Allows the current owner to relinquish control of the contract.
166    * @notice Renouncing to ownership will leave the contract without an owner.
167    * It will not be possible to call the functions with the `onlyOwner`
168    * modifier anymore.
169    */
170   function renounceOwnership() public onlyOwner {
171     emit OwnershipRenounced(owner);
172     owner = address(0);
173   }
174 
175   /**
176    * @dev Allows the current owner to transfer control of the contract to a newOwner.
177    * @param _newOwner The address to transfer ownership to.
178    */
179   function transferOwnership(address _newOwner) public onlyOwner {
180     _transferOwnership(_newOwner);
181   }
182 
183   /**
184    * @dev Transfers control of the contract to a newOwner.
185    * @param _newOwner The address to transfer ownership to.
186    */
187   function _transferOwnership(address _newOwner) internal {
188     require(_newOwner != address(0));
189     emit OwnershipTransferred(owner, _newOwner);
190     owner = _newOwner;
191   }
192 }
193 
194 contract Claimable is Ownable {
195   address public pendingOwner;
196 
197   /**
198    * @dev Modifier throws if called by any account other than the pendingOwner.
199    */
200   modifier onlyPendingOwner() {
201     require(msg.sender == pendingOwner);
202     _;
203   }
204 
205   /**
206    * @dev Allows the current owner to set the pendingOwner address.
207    * @param newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address newOwner) public onlyOwner {
210     pendingOwner = newOwner;
211   }
212 
213   /**
214    * @dev Allows the pendingOwner address to finalize the transfer.
215    */
216   function claimOwnership() public onlyPendingOwner {
217     emit OwnershipTransferred(owner, pendingOwner);
218     owner = pendingOwner;
219     pendingOwner = address(0);
220   }
221 }
222 
223 contract DelayedClaimable is Claimable {
224 
225   uint256 public end;
226   uint256 public start;
227 
228   /**
229    * @dev Used to specify the time period during which a pending
230    * owner can claim ownership.
231    * @param _start The earliest time ownership can be claimed.
232    * @param _end The latest time ownership can be claimed.
233    */
234   function setLimits(uint256 _start, uint256 _end) public onlyOwner {
235     require(_start <= _end);
236     end = _end;
237     start = _start;
238   }
239 
240   /**
241    * @dev Allows the pendingOwner address to finalize the transfer, as long as it is called within
242    * the specified start and end time.
243    */
244   function claimOwnership() public onlyPendingOwner {
245     require((block.number <= end) && (block.number >= start));
246     emit OwnershipTransferred(owner, pendingOwner);
247     owner = pendingOwner;
248     pendingOwner = address(0);
249     end = 0;
250   }
251 
252 }
253 
254 contract OwnerContract is DelayedClaimable {
255     Claimable public ownedContract;
256     address public pendingOwnedOwner;
257     // address internal origOwner;
258 
259     /**
260      * @dev bind a contract as its owner
261      *
262      * @param _contract the contract address that will be binded by this Owner Contract
263      */
264     function bindContract(address _contract) onlyOwner public returns (bool) {
265         require(_contract != address(0));
266         ownedContract = Claimable(_contract);
267         // origOwner = ownedContract.owner();
268 
269         // take ownership of the owned contract
270         if (ownedContract.owner() != address(this)) {
271             ownedContract.claimOwnership();
272         }
273 
274         return true;
275     }
276 
277     /**
278      * @dev change the owner of the contract from this contract address to the original one.
279      *
280      */
281     // function transferOwnershipBack() onlyOwner public {
282     //     ownedContract.transferOwnership(origOwner);
283     //     ownedContract = Claimable(address(0));
284     //     origOwner = address(0);
285     // }
286 
287     /**
288      * @dev change the owner of the contract from this contract address to another one.
289      *
290      * @param _nextOwner the contract address that will be next Owner of the original Contract
291      */
292     function changeOwnershipto(address _nextOwner)  onlyOwner public {
293         require(ownedContract != address(0));
294 
295         if (ownedContract.owner() != pendingOwnedOwner) {
296             ownedContract.transferOwnership(_nextOwner);
297             pendingOwnedOwner = _nextOwner;
298             // ownedContract = Claimable(address(0));
299             // origOwner = address(0);
300         } else {
301             // the pending owner has already taken the ownership
302             ownedContract = Claimable(address(0));
303             pendingOwnedOwner = address(0);
304         }
305     }
306 
307     /**
308      * @dev to confirm the owner of the owned contract has already been transferred.
309      *
310      */
311     function ownedOwnershipTransferred() onlyOwner public returns (bool) {
312         require(ownedContract != address(0));
313         if (ownedContract.owner() == pendingOwnedOwner) {
314             // the pending owner has already taken the ownership
315             ownedContract = Claimable(address(0));
316             pendingOwnedOwner = address(0);
317             return true;
318         } else {
319             return false;
320         }
321     }
322 }
323 
324 contract ReleaseAndLockToken is OwnerContract {
325     using SafeMath for uint256;
326 
327     ILockedStorage lockedStorage;
328     IFlyDropTokenMgr flyDropMgr;
329     // ERC20 public erc20tk;
330     mapping (address => uint256) preReleaseAmounts;
331 
332     event ReleaseFunds(address indexed _target, uint256 _amount);
333 
334     /**
335      * @dev bind a contract as its owner
336      *
337      * @param _contract the LockedStorage contract address that will be binded by this Owner Contract
338      * @param _flyDropContract the flydrop contract for transfer tokens from the fixed main accounts
339      */
340     function initialize(address _contract, address _flyDropContract) onlyOwner public returns (bool) {
341         require(_contract != address(0));
342         require(_flyDropContract != address(0));
343 
344         require(super.bindContract(_contract));
345         lockedStorage = ILockedStorage(_contract);
346         flyDropMgr = IFlyDropTokenMgr(_flyDropContract);
347         // erc20tk = ERC20(_tk);
348 
349         return true;
350     }
351 
352     /**
353      * judge whether we need to release some of the locked token
354      *
355      */
356     function needRelease() public view returns (bool) {
357         uint256 len = lockedStorage.size();
358         uint256 i = 0;
359         while (i < len) {
360             address frozenAddr = lockedStorage.addressByIndex(i);
361             uint256 timeRecLen = lockedStorage.lockedStagesNum(frozenAddr);
362             uint256 j = 0;
363             while (j < timeRecLen) {
364                 if (now >= lockedStorage.endTimeOfStage(frozenAddr, j)) {
365                     return true;
366                 }
367 
368                 j = j.add(1);
369             }
370 
371             i = i.add(1);
372         }
373 
374         return false;
375     }
376 
377     /**
378      * @dev judge whether we need to release the locked token of the target address
379      * @param _target the owner of the amount of tokens
380      *
381      */
382     function needReleaseFor(address _target) public view returns (bool) {
383         require(_target != address(0));
384 
385         uint256 timeRecLen = lockedStorage.lockedStagesNum(_target);
386         uint256 j = 0;
387         while (j < timeRecLen) {
388             if (now >= lockedStorage.endTimeOfStage(_target, j)) {
389                 return true;
390             }
391 
392             j = j.add(1);
393         }
394 
395         return false;
396     }
397 
398     /**
399      * @dev freeze the amount of tokens of an account
400      *
401      * @param _target the owner of some amount of tokens
402      * @param _name the user name of the _target
403      * @param _value the amount of the tokens
404      * @param _frozenEndTime the end time of the lock period, unit is second
405      * @param _releasePeriod the locking period, unit is second
406      */
407     function freeze(address _target, string _name, uint256 _value, uint256 _frozenEndTime, uint256 _releasePeriod) onlyOwner public returns (bool) {
408         //require(_tokenAddr != address(0));
409         require(_target != address(0));
410         require(_value > 0);
411         require(_frozenEndTime > 0);
412 
413         if (!lockedStorage.isExisted(_target)) {
414             lockedStorage.addAccount(_target, _name, _value); // add new account
415         }
416 
417         // each time the new locked time will be added to the backend
418         require(lockedStorage.addLockedTime(_target, _value, _frozenEndTime, _releasePeriod));
419         require(lockedStorage.freezeTokens(_target, true, _value));
420 
421         return true;
422     }
423 
424     /**
425      * @dev transfer an amount of tokens to an account, and then freeze the tokens
426      *
427      * @param _target the account address that will hold an amount of the tokens
428      * @param _name the user name of the _target
429      * @param _from the tokens holder who will transfer the tokens to target address
430      * @param _tk the erc20 token need to be transferred
431      * @param _value the amount of the tokens which has been transferred
432      * @param _frozenEndTime the end time of the lock period, unit is second
433      * @param _releasePeriod the locking period, unit is second
434      */
435     function transferAndFreeze(address _target,
436                                string _name,
437                                address _from,
438                                address _tk,
439                                uint256 _value,
440                                uint256 _frozenEndTime,
441                                uint256 _releasePeriod) onlyOwner public returns (bool) {
442         require(_from != address(0));
443         require(_target != address(0));
444         require(_value > 0);
445         require(_frozenEndTime > 0);
446 
447         // check firstly that the allowance of this contract has been set
448         // require(owned.allowance(msg.sender, this) > 0);
449         uint rand = now % 6 + 7; // random number between 7 to 12
450         require(flyDropMgr.prepare(rand, _from, _tk, _value));
451 
452         // now we need transfer the funds before freeze them
453         // require(owned.transferFrom(msg.sender, lockedStorage, _value));
454         address[] memory dests = new address[](1);
455         dests[0] = address(lockedStorage);
456         uint256[] memory amounts = new uint256[](1);
457         amounts[0] = _value;
458         require(flyDropMgr.flyDrop(dests, amounts) >= 1);
459         if (!lockedStorage.isExisted(_target)) {
460             require(lockedStorage.addAccount(_target, _name, _value));
461         } else {
462             require(lockedStorage.increaseBalance(_target, _value));
463         }
464 
465         // freeze the account after transfering funds
466         require(freeze(_target, _name, _value, _frozenEndTime, _releasePeriod));
467         return true;
468     }
469 
470     /**
471      * @dev transfer an amount of tokens to an account, and then freeze the tokens
472      *
473      * @param _target the account address that will hold an amount of the tokens
474      * @param _tk the erc20 token need to be transferred
475      * @param _value the amount of the tokens which has been transferred
476      */
477     function releaseTokens(address _target, address _tk, uint256 _value) internal {
478         require(lockedStorage.withdrawToken(_tk, _target, _value));
479         require(lockedStorage.freezeTokens(_target, false, _value));
480         require(lockedStorage.decreaseBalance(_target, _value));
481     }
482 
483     /**
484      * @dev release the token which are locked for once and will be total released at once
485      * after the end point of the lock period
486      * @param _tk the erc20 token need to be transferred
487      */
488     function releaseAllOnceLock(address _tk) onlyOwner public returns (bool) {
489         require(_tk != address(0));
490 
491         uint256 len = lockedStorage.size();
492         uint256 i = 0;
493         while (i < len) {
494             address target = lockedStorage.addressByIndex(i);
495             if (lockedStorage.lockedStagesNum(target) == 1
496                 && lockedStorage.endTimeOfStage(target, 0) == lockedStorage.releaseEndTimeOfStage(target, 0)
497                 && lockedStorage.endTimeOfStage(target, 0) > 0
498                 && now >= lockedStorage.endTimeOfStage(target, 0)) {
499                 uint256 releasedAmount = lockedStorage.amountOfStage(target, 0);
500 
501                 // remove current release period time record
502                 if (!lockedStorage.removeLockedTime(target, 0)) {
503                     return false;
504                 }
505 
506                 // remove the froze account
507                 if (!lockedStorage.removeAccount(target)) {
508                     return false;
509                 }
510 
511                 releaseTokens(target, _tk, releasedAmount);
512                 emit ReleaseFunds(target, releasedAmount);
513                 len = len.sub(1);
514             } else {
515                 // no account has been removed
516                 i = i.add(1);
517             }
518         }
519 
520         return true;
521     }
522 
523     /**
524      * @dev release the locked tokens owned by an account, which only have only one locked time
525      * and don't have release stage.
526      *
527      * @param _target the account address that hold an amount of locked tokens
528      * @param _tk the erc20 token need to be transferred
529      */
530     function releaseAccount(address _target, address _tk) onlyOwner public returns (bool) {
531         require(_tk != address(0));
532 
533         if (!lockedStorage.isExisted(_target)) {
534             return false;
535         }
536 
537         if (lockedStorage.lockedStagesNum(_target) == 1
538             && lockedStorage.endTimeOfStage(_target, 0) == lockedStorage.releaseEndTimeOfStage(_target, 0)
539             && lockedStorage.endTimeOfStage(_target, 0) > 0
540             && now >= lockedStorage.endTimeOfStage(_target, 0)) {
541             uint256 releasedAmount = lockedStorage.amountOfStage(_target, 0);
542 
543             // remove current release period time record
544             if (!lockedStorage.removeLockedTime(_target, 0)) {
545                 return false;
546             }
547 
548             // remove the froze account
549             if (!lockedStorage.removeAccount(_target)) {
550                 return false;
551             }
552 
553             releaseTokens(_target, _tk, releasedAmount);
554             emit ReleaseFunds(_target, releasedAmount);
555         }
556 
557         // if the account are not locked for once, we will do nothing here
558         return true;
559     }
560 
561     /**
562      * @dev release the locked tokens owned by an account with several stages
563      * this need the contract get approval from the account by call approve() in the token contract
564      *
565      * @param _target the account address that hold an amount of locked tokens
566      * @param _tk the erc20 token need to be transferred
567      */
568     function releaseWithStage(address _target, address _tk) onlyOwner public returns (bool) {
569         require(_tk != address(0));
570 
571         address frozenAddr = _target;
572         if (!lockedStorage.isExisted(frozenAddr)) {
573             return false;
574         }
575 
576         uint256 timeRecLen = lockedStorage.lockedStagesNum(frozenAddr);
577         bool released = false;
578         uint256 nowTime = now;
579         for (uint256 j = 0; j < timeRecLen; released = false) {
580             // iterate every time records to caculate how many tokens need to be released.
581             uint256 endTime = lockedStorage.endTimeOfStage(frozenAddr, j);
582             uint256 releasedEndTime = lockedStorage.releaseEndTimeOfStage(frozenAddr, j);
583             uint256 amount = lockedStorage.amountOfStage(frozenAddr, j);
584             uint256 remain = lockedStorage.remainOfStage(frozenAddr, j);
585             if (nowTime > endTime && endTime > 0 && releasedEndTime > endTime) {
586                 uint256 lastReleased = amount.sub(remain);
587                 uint256 value = (amount * nowTime.sub(endTime) / releasedEndTime.sub(endTime)).sub(lastReleased);
588 
589                 if (value > remain) {
590                     value = remain;
591                 }
592                 lockedStorage.decreaseRemainLockedOf(frozenAddr, j, value);
593                 emit ReleaseFunds(_target, value);
594 
595                 preReleaseAmounts[frozenAddr] = preReleaseAmounts[frozenAddr].add(value);
596                 if (lockedStorage.remainOfStage(frozenAddr, j) < 1e8) {
597                     if (!lockedStorage.removeLockedTime(frozenAddr, j)) {
598                         return false;
599                     }
600                     released = true;
601                     timeRecLen = timeRecLen.sub(1);
602                 }
603             } else if (nowTime >= endTime && endTime > 0 && releasedEndTime == endTime) {
604                 lockedStorage.decreaseRemainLockedOf(frozenAddr, j, remain);
605                 emit ReleaseFunds(frozenAddr, amount);
606                 preReleaseAmounts[frozenAddr] = preReleaseAmounts[frozenAddr].add(amount);
607                 if (!lockedStorage.removeLockedTime(frozenAddr, j)) {
608                     return false;
609                 }
610                 released = true;
611                 timeRecLen = timeRecLen.sub(1);
612             }
613 
614             if (!released) {
615                 j = j.add(1);
616             }
617         }
618 
619         // we got some amount need to be released
620         if (preReleaseAmounts[frozenAddr] > 0) {
621             releaseTokens(frozenAddr, _tk, preReleaseAmounts[frozenAddr]);
622 
623             // set the pre-release amount to 0 for next time
624             preReleaseAmounts[frozenAddr] = 0;
625         }
626 
627         // if all the frozen amounts had been released, then unlock the account finally
628         if (lockedStorage.lockedStagesNum(frozenAddr) == 0) {
629             if (!lockedStorage.removeAccount(frozenAddr)) {
630                 return false;
631             }
632         }
633 
634         return true;
635     }
636 
637     /**
638      * @dev set the new endtime of the released time of an account
639      *
640      * @param _target the owner of some amount of tokens
641      * @param _oldEndTime the original endtime for the lock period, unit is second
642      * @param _oldDuration the original duration time for the released period, unit is second
643      * @param _newEndTime the new endtime for the lock period
644      */
645     function setNewEndtime(address _target, uint256 _oldEndTime, uint256 _oldDuration, uint256 _newEndTime) onlyOwner public returns (bool) {
646         require(_target != address(0));
647         require(_oldEndTime > 0 && _newEndTime > 0);
648 
649         if (!lockedStorage.isExisted(_target)) {
650             return false;
651         }
652 
653         uint256 timeRecLen = lockedStorage.lockedStagesNum(_target);
654         uint256 j = 0;
655         while (j < timeRecLen) {
656             uint256 endTime = lockedStorage.endTimeOfStage(_target, j);
657             uint256 releasedEndTime = lockedStorage.releaseEndTimeOfStage(_target, j);
658             uint256 duration = releasedEndTime.sub(endTime);
659             if (_oldEndTime == endTime && _oldDuration == duration) {
660                 bool res = lockedStorage.changeEndTime(_target, j, _newEndTime);
661                 res = lockedStorage.setNewReleaseEndTime(_target, j, _newEndTime.add(duration)) && res;
662                 return res;
663             }
664 
665             j = j.add(1);
666         }
667 
668         return false;
669     }
670 
671     /**
672      * @dev set the new released period length of an account
673      *
674      * @param _target the owner of some amount of tokens
675      * @param _origEndTime the original endtime for the lock period
676      * @param _origDuration the original duration time for the released period, unit is second
677      * @param _newDuration the new releasing period
678      */
679     function setNewReleasePeriod(address _target, uint256 _origEndTime, uint256 _origDuration, uint256 _newDuration) onlyOwner public returns (bool) {
680         require(_target != address(0));
681         require(_origEndTime > 0);
682 
683         if (!lockedStorage.isExisted(_target)) {
684             return false;
685         }
686 
687         uint256 timeRecLen = lockedStorage.lockedStagesNum(_target);
688         uint256 j = 0;
689         while (j < timeRecLen) {
690             uint256 endTime = lockedStorage.endTimeOfStage(_target, j);
691             uint256 releasedEndTime = lockedStorage.releaseEndTimeOfStage(_target, j);
692             if (_origEndTime == endTime && _origDuration == releasedEndTime.sub(endTime)) {
693                 return lockedStorage.setNewReleaseEndTime(_target, j, _origEndTime.add(_newDuration));
694             }
695 
696             j = j.add(1);
697         }
698 
699         return false;
700     }
701 
702     /**
703      * @dev get the locked stages of an account
704      *
705      * @param _target the owner of some amount of tokens
706      */
707     function getLockedStages(address _target) public view returns (uint) {
708         require(_target != address(0));
709 
710         return lockedStorage.lockedStagesNum(_target);
711     }
712 
713     /**
714      * @dev get the endtime of the locked stages of an account
715      *
716      * @param _target the owner of some amount of tokens
717      * @param _num the stage number of the releasing period
718      */
719     function getEndTimeOfStage(address _target, uint _num) public view returns (uint256) {
720         require(_target != address(0));
721 
722         return lockedStorage.endTimeOfStage(_target, _num);
723     }
724 
725     /**
726      * @dev get the remain unrleased tokens of the locked stages of an account
727      *
728      * @param _target the owner of some amount of tokens
729      * @param _num the stage number of the releasing period
730      */
731     function getRemainOfStage(address _target, uint _num) public view returns (uint256) {
732         require(_target != address(0));
733 
734         return lockedStorage.remainOfStage(_target, _num);
735     }
736 
737     /**
738      * @dev get total remain locked tokens of an account
739      *
740      * @param _account the owner of some amount of tokens
741      */
742     function getRemainLockedOf(address _account) public view returns (uint256) {
743         require(_account != address(0));
744 
745         uint256 totalRemain = 0;
746         if(lockedStorage.isExisted(_account)) {
747             uint256 timeRecLen = lockedStorage.lockedStagesNum(_account);
748             uint256 j = 0;
749             while (j < timeRecLen) {
750                 totalRemain = totalRemain.add(lockedStorage.remainOfStage(_account, j));
751                 j = j.add(1);
752             }
753         }
754 
755         return totalRemain;
756     }
757 
758     /**
759      * @dev get the remain releasing period of an account
760      *
761      * @param _target the owner of some amount of tokens
762      * @param _num the stage number of the releasing period
763      */
764     function getRemainReleaseTimeOfStage(address _target, uint _num) public view returns (uint256) {
765         require(_target != address(0));
766 
767         uint256 nowTime = now;
768         uint256 releaseEndTime = lockedStorage.releaseEndTimeOfStage(_target, _num);
769 
770         if (releaseEndTime == 0 || releaseEndTime < nowTime) {
771             return 0;
772         }
773 
774         uint256 endTime = lockedStorage.endTimeOfStage(_target, _num);
775         if (releaseEndTime == endTime || nowTime <= endTime ) {
776             return (releaseEndTime.sub(endTime));
777         }
778 
779         return (releaseEndTime.sub(nowTime));
780     }
781 
782     /**
783      * @dev release the locked tokens owned by a number of accounts
784      *
785      * @param _targets the accounts list that hold an amount of locked tokens
786      * @param _tk the erc20 token need to be transferred
787      */
788     function releaseMultiAccounts(address[] _targets, address _tk) onlyOwner public returns (bool) {
789         require(_targets.length != 0);
790 
791         bool res = false;
792         uint256 i = 0;
793         while (i < _targets.length) {
794             res = releaseAccount(_targets[i], _tk) || res;
795             i = i.add(1);
796         }
797 
798         return res;
799     }
800 
801     /**
802      * @dev release the locked tokens owned by an account
803      *
804      * @param _targets the account addresses list that hold amounts of locked tokens
805      * @param _tk the erc20 token need to be transferred
806      */
807     function releaseMultiWithStage(address[] _targets, address _tk) onlyOwner public returns (bool) {
808         require(_targets.length != 0);
809 
810         bool res = false;
811         uint256 i = 0;
812         while (i < _targets.length) {
813             res = releaseWithStage(_targets[i], _tk) || res; // as long as there is one true transaction, then the result will be true
814             i = i.add(1);
815         }
816 
817         return res;
818     }
819 
820     /**
821      * @dev convert bytes32 stream to string
822      *
823      * @param _b32 the bytes32 that hold a string in content
824      */
825     function bytes32ToString(bytes32 _b32) internal pure returns (string) {
826         bytes memory bytesString = new bytes(32);
827         uint charCount = 0;
828         for (uint j = 0; j < 32; j++) {
829             byte char = byte(bytes32(uint(_b32) * 2 ** (8 * j)));
830             if (char != 0) {
831                 bytesString[charCount] = char;
832                 charCount++;
833             }
834         }
835         bytes memory bytesStringTrimmed = new bytes(charCount);
836         for (j = 0; j < charCount; j++) {
837             bytesStringTrimmed[j] = bytesString[j];
838         }
839         return string(bytesStringTrimmed);
840     }
841 
842      /**
843      * @dev freeze multiple of the accounts
844      *
845      * @param _targets the owners of some amount of tokens
846      * @param _names the user names of the _targets
847      * @param _values the amounts of the tokens
848      * @param _frozenEndTimes the list of the end time of the lock period, unit is second
849      * @param _releasePeriods the list of the locking period, unit is second
850      */
851     function freezeMulti(address[] _targets, bytes32[] _names, uint256[] _values, uint256[] _frozenEndTimes, uint256[] _releasePeriods) onlyOwner public returns (bool) {
852         require(_targets.length != 0);
853         require(_names.length != 0);
854         require(_values.length != 0);
855         require(_frozenEndTimes.length != 0);
856         require(_releasePeriods.length != 0);
857         require(_targets.length == _names.length && _names.length == _values.length && _values.length == _frozenEndTimes.length && _frozenEndTimes.length == _releasePeriods.length);
858 
859         bool res = true;
860         for (uint256 i = 0; i < _targets.length; i = i.add(1)) {
861             // as long as one transaction failed, then the result will be failure
862             res = freeze(_targets[i], bytes32ToString(_names[i]), _values[i], _frozenEndTimes[i], _releasePeriods[i]) && res;
863         }
864 
865         return res;
866     }
867 
868     /**
869      * @dev transfer a list of amounts of tokens to a list of accounts, and then freeze the tokens
870      *
871      * @param _targets the account addresses that will hold a list of amounts of the tokens
872      * @param _names the user names of the _targets
873      * @param _from the tokens holder who will transfer the tokens to target address
874      * @param _tk the erc20 token need to be transferred
875      * @param _values the amounts of the tokens which have been transferred
876      * @param _frozenEndTimes the end time list of the locked periods, unit is second
877      * @param _releasePeriods the list of locking periods, unit is second
878      */
879     function transferAndFreezeMulti(address[] _targets, bytes32[] _names, address _from, address _tk, uint256[] _values, uint256[] _frozenEndTimes, uint256[] _releasePeriods) onlyOwner public returns (bool) {
880         require(_targets.length != 0);
881         require(_names.length != 0);
882         require(_values.length != 0);
883         require(_frozenEndTimes.length != 0);
884         require(_releasePeriods.length != 0);
885         require(_targets.length == _names.length && _names.length == _values.length && _values.length == _frozenEndTimes.length && _frozenEndTimes.length == _releasePeriods.length);
886 
887         bool res = true;
888         for (uint256 i = 0; i < _targets.length; i = i.add(1)) {
889             // as long as one transaction failed, then the result will be failure
890             res = transferAndFreeze(_targets[i], bytes32ToString(_names[i]), _from, _tk, _values[i], _frozenEndTimes[i], _releasePeriods[i]) && res;
891         }
892 
893         return res;
894     }
895 }
896 
897 contract ERC20Basic {
898   function totalSupply() public view returns (uint256);
899   function balanceOf(address _who) public view returns (uint256);
900   function transfer(address _to, uint256 _value) public returns (bool);
901   event Transfer(address indexed from, address indexed to, uint256 value);
902 }
903 
904 contract ERC20 is ERC20Basic {
905   function allowance(address _owner, address _spender)
906     public view returns (uint256);
907 
908   function transferFrom(address _from, address _to, uint256 _value)
909     public returns (bool);
910 
911   function approve(address _spender, uint256 _value) public returns (bool);
912   event Approval(
913     address indexed owner,
914     address indexed spender,
915     uint256 value
916   );
917 }