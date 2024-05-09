1 pragma solidity ^0.4.21;
2 
3 interface itoken {
4     function freezeAccount(address _target, bool _freeze) external;
5     function freezeAccountPartialy(address _target, uint256 _value) external;
6     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
7     function balanceOf(address _owner) external view returns (uint256 balance);
8     // function transferOwnership(address newOwner) external;
9     function allowance(address _owner, address _spender) external view returns (uint256);
10     function frozenAccount(address _account) external view returns (bool);
11     function frozenAmount(address _account) external view returns (uint256);
12 }
13 
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 contract Claimable is Ownable {
92   address public pendingOwner;
93 
94   /**
95    * @dev Modifier throws if called by any account other than the pendingOwner.
96    */
97   modifier onlyPendingOwner() {
98     require(msg.sender == pendingOwner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to set the pendingOwner address.
104    * @param newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address newOwner) onlyOwner public {
107     pendingOwner = newOwner;
108   }
109 
110   /**
111    * @dev Allows the pendingOwner address to finalize the transfer.
112    */
113   function claimOwnership() onlyPendingOwner public {
114     OwnershipTransferred(owner, pendingOwner);
115     owner = pendingOwner;
116     pendingOwner = address(0);
117   }
118 }
119 
120 contract OwnerContract is Claimable {
121     Claimable public ownedContract;
122     address internal origOwner;
123 
124     /**
125      * @dev bind a contract as its owner
126      *
127      * @param _contract the contract address that will be binded by this Owner Contract
128      */
129     function bindContract(address _contract) onlyOwner public returns (bool) {
130         require(_contract != address(0));
131         ownedContract = Claimable(_contract);
132         origOwner = ownedContract.owner();
133 
134         // take ownership of the owned contract
135         ownedContract.claimOwnership();
136 
137         return true;
138     }
139 
140     /**
141      * @dev change the owner of the contract from this contract address to the original one.
142      *
143      */
144     function transferOwnershipBack() onlyOwner public {
145         ownedContract.transferOwnership(origOwner);
146         ownedContract = Claimable(address(0));
147         origOwner = address(0);
148     }
149 
150     /**
151      * @dev change the owner of the contract from this contract address to another one.
152      *
153      * @param _nextOwner the contract address that will be next Owner of the original Contract
154      */
155     function changeOwnershipto(address _nextOwner)  onlyOwner public {
156         ownedContract.transferOwnership(_nextOwner);
157         ownedContract = Claimable(address(0));
158         origOwner = address(0);
159     }
160 }
161 
162 contract ReleaseToken is OwnerContract {
163     using SafeMath for uint256;
164 
165     // record lock time period and related token amount
166     struct TimeRec {
167         uint256 amount;
168         uint256 remain;
169         uint256 endTime;
170         uint256 releasePeriodEndTime;
171     }
172 
173     itoken internal owned;
174 
175     address[] public frozenAccounts;
176     mapping (address => TimeRec[]) frozenTimes;
177     // mapping (address => uint256) releasedAmounts;
178     mapping (address => uint256) preReleaseAmounts;
179 
180     event ReleaseFunds(address _target, uint256 _amount);
181 
182     /**
183      * @dev bind a contract as its owner
184      *
185      * @param _contract the contract address that will be binded by this Owner Contract
186      */
187     function bindContract(address _contract) onlyOwner public returns (bool) {
188         require(_contract != address(0));
189         owned = itoken(_contract);
190         return super.bindContract(_contract);
191     }
192 
193     /**
194      * @dev remove an account from the frozen accounts list
195      *
196      * @param _ind the index of the account in the list
197      */
198     function removeAccount(uint _ind) internal returns (bool) {
199         require(_ind < frozenAccounts.length);
200 
201         uint256 i = _ind;
202         while (i < frozenAccounts.length.sub(1)) {
203             frozenAccounts[i] = frozenAccounts[i.add(1)];
204             i = i.add(1);
205         }
206 
207         delete frozenAccounts[frozenAccounts.length.sub(1)];
208         frozenAccounts.length = frozenAccounts.length.sub(1);
209         return true;
210     }
211 
212     /**
213      * @dev remove a time records from the time records list of one account
214      *
215      * @param _target the account that holds a list of time records which record the freeze period
216      */
217     function removeLockedTime(address _target, uint _ind) internal returns (bool) {
218         require(_target != address(0));
219 
220         TimeRec[] storage lockedTimes = frozenTimes[_target];
221         require(_ind < lockedTimes.length);
222 
223         uint256 i = _ind;
224         while (i < lockedTimes.length.sub(1)) {
225             lockedTimes[i] = lockedTimes[i.add(1)];
226             i = i.add(1);
227         }
228 
229         delete lockedTimes[lockedTimes.length.sub(1)];
230         lockedTimes.length = lockedTimes.length.sub(1);
231         return true;
232     }
233 
234     /**
235      * @dev get total remain locked tokens of an account
236      *
237      * @param _account the owner of some amount of tokens
238      */
239     function getRemainLockedOf(address _account) public view returns (uint256) {
240         require(_account != address(0));
241 
242         uint256 totalRemain = 0;
243         uint256 len = frozenAccounts.length;
244         uint256 i = 0;
245         while (i < len) {
246             address frozenAddr = frozenAccounts[i];
247             if (frozenAddr == _account) {
248                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
249                 uint256 j = 0;
250                 while (j < timeRecLen) {
251                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
252                     totalRemain = totalRemain.add(timePair.remain);
253 
254                     j = j.add(1);
255                 }
256             }
257 
258             i = i.add(1);
259         }
260 
261         return totalRemain;
262     }
263 
264     /**
265      * judge whether we need to release some of the locked token
266      *
267      */
268     function needRelease() public view returns (bool) {
269         uint256 len = frozenAccounts.length;
270         uint256 i = 0;
271         while (i < len) {
272             address frozenAddr = frozenAccounts[i];
273             uint256 timeRecLen = frozenTimes[frozenAddr].length;
274             uint256 j = 0;
275             while (j < timeRecLen) {
276                 TimeRec storage timePair = frozenTimes[frozenAddr][j];
277                 if (now >= timePair.endTime) {
278                     return true;
279                 }
280 
281                 j = j.add(1);
282             }
283 
284             i = i.add(1);
285         }
286 
287         return false;
288     }
289 
290     /**
291      * @dev freeze the amount of tokens of an account
292      *
293      * @param _target the owner of some amount of tokens
294      * @param _value the amount of the tokens
295      * @param _frozenEndTime the end time of the lock period, unit is second
296      * @param _releasePeriod the locking period, unit is second
297      */
298     function freeze(address _target, uint256 _value, uint256 _frozenEndTime, uint256 _releasePeriod) onlyOwner public returns (bool) {
299         //require(_tokenAddr != address(0));
300         require(_target != address(0));
301         require(_value > 0);
302         require(_frozenEndTime > 0);
303 
304         uint256 len = frozenAccounts.length;
305 
306         uint256 i = 0;
307         for (; i < len; i = i.add(1)) {
308             if (frozenAccounts[i] == _target) {
309                 break;
310             }
311         }
312 
313         if (i >= len) {
314             frozenAccounts.push(_target); // add new account
315         }
316 
317         // each time the new locked time will be added to the backend
318         frozenTimes[_target].push(TimeRec(_value, _value, _frozenEndTime, _frozenEndTime.add(_releasePeriod)));
319         if (owned.frozenAccount(_target)) {
320             uint256 preFrozenAmount = owned.frozenAmount(_target);
321             owned.freezeAccountPartialy(_target, _value.add(preFrozenAmount));
322         } else {
323             owned.freezeAccountPartialy(_target, _value);
324         }
325 
326         return true;
327     }
328 
329     /**
330      * @dev transfer an amount of tokens to an account, and then freeze the tokens
331      *
332      * @param _target the account address that will hold an amount of the tokens
333      * @param _value the amount of the tokens which has been transferred
334      * @param _frozenEndTime the end time of the lock period, unit is second
335      * @param _releasePeriod the locking period, unit is second
336      */
337     function transferAndFreeze(address _target, uint256 _value, uint256 _frozenEndTime, uint256 _releasePeriod) onlyOwner public returns (bool) {
338         //require(_tokenOwner != address(0));
339         require(_target != address(0));
340         require(_value > 0);
341         require(_frozenEndTime > 0);
342 
343         // check firstly that the allowance of this contract has been set
344         require(owned.allowance(msg.sender, this) > 0);
345 
346         // now we need transfer the funds before freeze them
347         require(owned.transferFrom(msg.sender, _target, _value));
348 
349         // freeze the account after transfering funds
350         if (!freeze(_target, _value, _frozenEndTime, _releasePeriod)) {
351             return false;
352         }
353 
354         return true;
355     }
356 
357     /**
358      * release the token which are locked for once and will be total released at once
359      * after the end point of the lock period
360      */
361     function releaseAllOnceLock() onlyOwner public returns (bool) {
362         //require(_tokenAddr != address(0));
363 
364         uint256 len = frozenAccounts.length;
365         uint256 i = 0;
366         while (i < len) {
367             address target = frozenAccounts[i];
368             if (frozenTimes[target].length == 1 && frozenTimes[target][0].endTime == frozenTimes[target][0].releasePeriodEndTime && frozenTimes[target][0].endTime > 0 && now >= frozenTimes[target][0].endTime) {
369                 uint256 releasedAmount = frozenTimes[target][0].amount;
370 
371                 // remove current release period time record
372                 if (!removeLockedTime(target, 0)) {
373                     return false;
374                 }
375 
376                 // remove the froze account
377                 if (!removeAccount(i)) {
378                     return false;
379                 }
380 
381                 uint256 preFrozenAmount = owned.frozenAmount(target);
382                 if (preFrozenAmount > releasedAmount) {
383                     owned.freezeAccountPartialy(target, preFrozenAmount.sub(releasedAmount));
384                 } else {
385                     owned.freezeAccount(target, false);
386                 }
387 
388                 ReleaseFunds(target, releasedAmount);
389                 len = len.sub(1);
390             } else {
391                 // no account has been removed
392                 i = i.add(1);
393             }
394         }
395 
396         return true;
397     }
398 
399     /**
400      * @dev release the locked tokens owned by an account, which only have only one locked time
401      * and don't have release stage.
402      *
403      * @param _target the account address that hold an amount of locked tokens
404      */
405     function releaseAccount(address _target) onlyOwner public returns (bool) {
406         //require(_tokenAddr != address(0));
407         require(_target != address(0));
408 
409         uint256 len = frozenAccounts.length;
410         uint256 i = 0;
411         while (i < len) {
412             address destAddr = frozenAccounts[i];
413             if (destAddr == _target) {
414                 if (frozenTimes[destAddr].length == 1 && frozenTimes[destAddr][0].endTime == frozenTimes[destAddr][0].releasePeriodEndTime && frozenTimes[destAddr][0].endTime > 0 && now >= frozenTimes[destAddr][0].endTime) {
415                     uint256 releasedAmount = frozenTimes[destAddr][0].amount;
416 
417                     // remove current release period time record
418                     if (!removeLockedTime(destAddr, 0)) {
419                         return false;
420                     }
421 
422                     // remove the froze account
423                     if (!removeAccount(i)) {
424                         return false;
425                     }
426 
427                     uint256 preFrozenAmount = owned.frozenAmount(destAddr);
428                     if (preFrozenAmount > releasedAmount) {
429                         owned.freezeAccountPartialy(destAddr, preFrozenAmount.sub(releasedAmount));
430                     } else {
431                         owned.freezeAccount(destAddr, false);
432                     }
433 
434                     ReleaseFunds(destAddr, releasedAmount);
435                 }
436 
437                 // if the account are not locked for once, we will do nothing here
438                 return true;
439             }
440 
441             i = i.add(1);
442         }
443 
444         return false;
445     }
446 
447     /**
448      * @dev release the locked tokens owned by an account with several stages
449      * this need the contract get approval from the account by call approve() in the token contract
450      *
451      * @param _target the account address that hold an amount of locked tokens
452      */
453     function releaseWithStage(address _target/*, address _dest*/) onlyOwner public returns (bool) {
454         //require(_tokenaddr != address(0));
455         require(_target != address(0));
456         // require(_dest != address(0));
457         // require(_value > 0);
458 
459         // check firstly that the allowance of this contract from _target account has been set
460         // require(owned.allowance(_target, this) > 0);
461 
462         uint256 len = frozenAccounts.length;
463         uint256 i = 0;
464         while (i < len) {
465             // firstly find the target address
466             address frozenAddr = frozenAccounts[i];
467             if (frozenAddr == _target) {
468                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
469 
470                 bool released = false;
471                 uint256 nowTime = now;
472                 for (uint256 j = 0; j < timeRecLen; released = false) {
473                     // iterate every time records to caculate how many tokens need to be released.
474                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
475                     if (nowTime > timePair.endTime && timePair.endTime > 0 && timePair.releasePeriodEndTime > timePair.endTime) {
476                         uint256 lastReleased = timePair.amount.sub(timePair.remain);
477                         uint256 value = (timePair.amount * nowTime.sub(timePair.endTime) / timePair.releasePeriodEndTime.sub(timePair.endTime)).sub(lastReleased);
478                         if (value > timePair.remain) {
479                             value = timePair.remain;
480                         }
481 
482                         // timePair.endTime = nowTime;
483                         timePair.remain = timePair.remain.sub(value);
484                         ReleaseFunds(frozenAddr, value);
485                         preReleaseAmounts[frozenAddr] = preReleaseAmounts[frozenAddr].add(value);
486                         if (timePair.remain < 1e8) {
487                             if (!removeLockedTime(frozenAddr, j)) {
488                                 return false;
489                             }
490                             released = true;
491                             timeRecLen = timeRecLen.sub(1);
492                         }
493                     } else if (nowTime >= timePair.endTime && timePair.endTime > 0 && timePair.releasePeriodEndTime == timePair.endTime) {
494                         timePair.remain = 0;
495                         ReleaseFunds(frozenAddr, timePair.amount);
496                         preReleaseAmounts[frozenAddr] = preReleaseAmounts[frozenAddr].add(timePair.amount);
497                         if (!removeLockedTime(frozenAddr, j)) {
498                             return false;
499                         }
500                         released = true;
501                         timeRecLen = timeRecLen.sub(1);
502                     }
503 
504                     if (!released) {
505                         j = j.add(1);
506                     }
507                 }
508 
509                 // we got some amount need to be released
510                 if (preReleaseAmounts[frozenAddr] > 0) {
511                     uint256 preReleasedAmount = preReleaseAmounts[frozenAddr];
512                     uint256 preFrozenAmount = owned.frozenAmount(frozenAddr);
513 
514                     // set the pre-release amount to 0 for next time
515                     preReleaseAmounts[frozenAddr] = 0;
516                     if (preFrozenAmount > preReleasedAmount) {
517                         owned.freezeAccountPartialy(frozenAddr, preFrozenAmount.sub(preReleasedAmount));
518                     } else {
519                         owned.freezeAccount(frozenAddr, false);
520                     }
521                     // if (!owned.transferFrom(_target, _dest, preReleaseAmounts[frozenAddr])) {
522                     //     return false;
523                     // }
524                 }
525 
526                 // if all the frozen amounts had been released, then unlock the account finally
527                 if (frozenTimes[frozenAddr].length == 0) {
528                     if (!removeAccount(i)) {
529                         return false;
530                     }
531                 } /*else {
532                     // still has some tokens need to be released in future
533                     owned.freezeAccount(frozenAddr, true);
534                 }*/
535 
536                 return true;
537             }
538 
539             i = i.add(1);
540         }
541 
542         return false;
543     }
544 
545     /**
546      * @dev set the new endtime of the released time of an account
547      *
548      * @param _target the owner of some amount of tokens
549      * @param _oldEndTime the original endtime for the lock period
550      * @param _newEndTime the new endtime for the lock period
551      */
552     function setNewEndtime(address _target, uint256 _oldEndTime, uint256 _newEndTime) onlyOwner public returns (bool) {
553         require(_target != address(0));
554         require(_oldEndTime > 0 && _newEndTime > 0);
555 
556         uint256 len = frozenAccounts.length;
557         uint256 i = 0;
558         while (i < len) {
559             address frozenAddr = frozenAccounts[i];
560             if (frozenAddr == _target) {
561                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
562                 uint256 j = 0;
563                 while (j < timeRecLen) {
564                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
565                     if (_oldEndTime == timePair.endTime) {
566                         uint256 duration = timePair.releasePeriodEndTime.sub(timePair.endTime);
567                         timePair.endTime = _newEndTime;
568                         timePair.releasePeriodEndTime = timePair.endTime.add(duration);
569 
570                         return true;
571                     }
572 
573                     j = j.add(1);
574                 }
575 
576                 return false;
577             }
578 
579             i = i.add(1);
580         }
581 
582         return false;
583     }
584 
585     /**
586      * @dev set the new released period length of an account
587      *
588      * @param _target the owner of some amount of tokens
589      * @param _origEndTime the original endtime for the lock period
590      * @param _duration the new releasing period
591      */
592     function setNewReleasePeriod(address _target, uint256 _origEndTime, uint256 _duration) onlyOwner public returns (bool) {
593         require(_target != address(0));
594         require(_origEndTime > 0 && _duration > 0);
595 
596         uint256 len = frozenAccounts.length;
597         uint256 i = 0;
598         while (i < len) {
599             address frozenAddr = frozenAccounts[i];
600             if (frozenAddr == _target) {
601                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
602                 uint256 j = 0;
603                 while (j < timeRecLen) {
604                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
605                     if (_origEndTime == timePair.endTime) {
606                         timePair.releasePeriodEndTime = _origEndTime.add(_duration);
607                         return true;
608                     }
609 
610                     j = j.add(1);
611                 }
612 
613                 return false;
614             }
615 
616             i = i.add(1);
617         }
618 
619         return false;
620     }
621 
622     /**
623      * @dev get the locked stages of an account
624      *
625      * @param _target the owner of some amount of tokens
626      */
627     function getLockedStages(address _target) public view returns (uint) {
628         require(_target != address(0));
629 
630         uint256 len = frozenAccounts.length;
631         uint256 i = 0;
632         while (i < len) {
633             address frozenAddr = frozenAccounts[i];
634             if (frozenAddr == _target) {
635                 return frozenTimes[frozenAddr].length;
636             }
637 
638             i = i.add(1);
639         }
640 
641         return 0;
642     }
643 
644     /**
645      * @dev get the endtime of the locked stages of an account
646      *
647      * @param _target the owner of some amount of tokens
648      * @param _num the stage number of the releasing period
649      */
650     function getEndTimeOfStage(address _target, uint _num) public view returns (uint256) {
651         require(_target != address(0));
652 
653         uint256 len = frozenAccounts.length;
654         uint256 i = 0;
655         while (i < len) {
656             address frozenAddr = frozenAccounts[i];
657             if (frozenAddr == _target) {
658                 TimeRec storage timePair = frozenTimes[frozenAddr][_num];
659                 return timePair.endTime;
660             }
661 
662             i = i.add(1);
663         }
664 
665         return 0;
666     }
667 
668     /**
669      * @dev get the remain unrleased tokens of the locked stages of an account
670      *
671      * @param _target the owner of some amount of tokens
672      * @param _num the stage number of the releasing period
673      */
674     function getRemainOfStage(address _target, uint _num) public view returns (uint256) {
675         require(_target != address(0));
676 
677         uint256 len = frozenAccounts.length;
678         uint256 i = 0;
679         while (i < len) {
680             address frozenAddr = frozenAccounts[i];
681             if (frozenAddr == _target) {
682                 TimeRec storage timePair = frozenTimes[frozenAddr][_num];
683                 return timePair.remain;
684             }
685 
686             i = i.add(1);
687         }
688 
689         return 0;
690     }
691 
692     /**
693      * @dev get the remain releasing period of an account
694      *
695      * @param _target the owner of some amount of tokens
696      * @param _num the stage number of the releasing period
697      */
698     function getRemainReleaseTimeOfStage(address _target, uint _num) public view returns (uint256) {
699         require(_target != address(0));
700 
701         uint256 len = frozenAccounts.length;
702         uint256 i = 0;
703         while (i < len) {
704             address frozenAddr = frozenAccounts[i];
705             if (frozenAddr == _target) {
706                 TimeRec storage timePair = frozenTimes[frozenAddr][_num];
707                 uint256 nowTime = now;
708                 if (timePair.releasePeriodEndTime == timePair.endTime || nowTime <= timePair.endTime ) {
709                     return (timePair.releasePeriodEndTime.sub(timePair.endTime));
710                 }
711 
712                 if (timePair.releasePeriodEndTime < nowTime) {
713                     return 0;
714                 }
715 
716                 return (timePair.releasePeriodEndTime.sub(nowTime));
717             }
718 
719             i = i.add(1);
720         }
721 
722         return 0;
723     }
724 
725     /**
726      * @dev release the locked tokens owned by a number of accounts
727      *
728      * @param _targets the accounts list that hold an amount of locked tokens
729      */
730     function releaseMultiAccounts(address[] _targets) onlyOwner public returns (bool) {
731         //require(_tokenAddr != address(0));
732         require(_targets.length != 0);
733 
734         bool res = false;
735         uint256 i = 0;
736         while (i < _targets.length) {
737             res = releaseAccount(_targets[i]) || res;
738             i = i.add(1);
739         }
740 
741         return res;
742     }
743 
744     /**
745      * @dev release the locked tokens owned by an account
746      *
747      * @param _targets the account addresses list that hold amounts of locked tokens
748      */
749     function releaseMultiWithStage(address[] _targets) onlyOwner public returns (bool) {
750         require(_targets.length != 0);
751 
752         bool res = false;
753         uint256 i = 0;
754         while (i < _targets.length) {
755             require(_targets[i] != address(0));
756 
757             res = releaseWithStage(_targets[i]) || res; // as long as there is one true transaction, then the result will be true
758             i = i.add(1);
759         }
760 
761         return res;
762     }
763 
764      /**
765      * @dev freeze multiple of the accounts
766      *
767      * @param _targets the owners of some amount of tokens
768      * @param _values the amounts of the tokens
769      * @param _frozenEndTimes the list of the end time of the lock period, unit is second
770      * @param _releasePeriods the list of the locking period, unit is second
771      */
772     function freezeMulti(address[] _targets, uint256[] _values, uint256[] _frozenEndTimes, uint256[] _releasePeriods) onlyOwner public returns (bool) {
773         require(_targets.length != 0);
774         require(_values.length != 0);
775         require(_frozenEndTimes.length != 0);
776         require(_releasePeriods.length != 0);
777         require(_targets.length == _values.length && _values.length == _frozenEndTimes.length && _frozenEndTimes.length == _releasePeriods.length);
778 
779         bool res = true;
780         for (uint256 i = 0; i < _targets.length; i = i.add(1)) {
781             require(_targets[i] != address(0));
782             res = freeze(_targets[i], _values[i], _frozenEndTimes[i], _releasePeriods[i]) && res;
783         }
784 
785         return res;
786     }
787 
788     /**
789      * @dev transfer a list of amounts of tokens to a list of accounts, and then freeze the tokens
790      *
791      * @param _targets the account addresses that will hold a list of amounts of the tokens
792      * @param _values the amounts of the tokens which have been transferred
793      * @param _frozenEndTimes the end time list of the locked periods, unit is second
794      * @param _releasePeriods the list of locking periods, unit is second
795      */
796     function transferAndFreezeMulti(address[] _targets, uint256[] _values, uint256[] _frozenEndTimes, uint256[] _releasePeriods) onlyOwner public returns (bool) {
797         require(_targets.length != 0);
798         require(_values.length != 0);
799         require(_frozenEndTimes.length != 0);
800         require(_releasePeriods.length != 0);
801         require(_targets.length == _values.length && _values.length == _frozenEndTimes.length && _frozenEndTimes.length == _releasePeriods.length);
802 
803         bool res = true;
804         for (uint256 i = 0; i < _targets.length; i = i.add(1)) {
805             require(_targets[i] != address(0));
806             res = transferAndFreeze(_targets[i], _values[i], _frozenEndTimes[i], _releasePeriods[i]) && res;
807         }
808 
809         return res;
810     }
811 }