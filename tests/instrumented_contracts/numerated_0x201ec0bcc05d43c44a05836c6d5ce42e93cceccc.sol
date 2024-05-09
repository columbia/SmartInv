1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() public {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 
76 interface iContract {
77     function transferOwnership(address _newOwner) external;
78     function owner() external view returns (address);
79 }
80 
81 contract OwnerContract is Ownable {
82     iContract public ownedContract;
83     address origOwner;
84 
85     /**
86      * @dev bind a contract as its owner
87      *
88      * @param _contract the contract address that will be binded by this Owner Contract
89      */
90     function setContract(address _contract) public onlyOwner {
91         require(_contract != address(0));
92         ownedContract = iContract(_contract);
93         origOwner = ownedContract.owner();
94     }
95 
96     /**
97      * @dev change the owner of the contract from this contract address to the original one. 
98      *
99      */
100     function transferOwnershipBack() public onlyOwner {
101         ownedContract.transferOwnership(origOwner);
102         ownedContract = iContract(address(0));
103         origOwner = address(0);
104     }
105 }
106 
107 interface itoken {
108     // mapping (address => bool) public frozenAccount;
109     function freezeAccount(address _target, bool _freeze) external;
110     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
111     function balanceOf(address _owner) external view returns (uint256 balance);
112     // function transferOwnership(address newOwner) external;
113     function allowance(address _owner, address _spender) external view returns (uint256);
114     function frozenAccount(address _account) external view returns (bool);
115 }
116 
117 contract ReleaseToken is OwnerContract {
118     using SafeMath for uint256;
119 
120     // record lock time period and related token amount
121     struct TimeRec {
122         uint256 amount;
123         uint256 remain;
124         uint256 endTime;
125         uint256 releasePeriodEndTime;
126     }
127 
128     itoken public owned;
129 
130     address[] public frozenAccounts;
131     mapping (address => TimeRec[]) frozenTimes;
132     // mapping (address => uint256) releasedAmounts;
133     mapping (address => uint256) preReleaseAmounts;
134 
135     event ReleaseFunds(address _target, uint256 _amount);
136 
137     /**
138      * @dev bind a contract as its owner
139      *
140      * @param _contract the contract address that will be binded by this Owner Contract
141      */
142     function setContract(address _contract) onlyOwner public {
143         super.setContract(_contract);
144         owned = itoken(_contract);
145     }
146 
147     /**
148      * @dev remove an account from the frozen accounts list
149      *
150      * @param _ind the index of the account in the list
151      */
152     function removeAccount(uint _ind) internal returns (bool) {
153         require(_ind >= 0);
154         require(_ind < frozenAccounts.length);
155         
156         uint256 i = _ind;
157         while (i < frozenAccounts.length.sub(1)) {
158             frozenAccounts[i] = frozenAccounts[i.add(1)];
159             i = i.add(1);
160         }
161 
162         frozenAccounts.length = frozenAccounts.length.sub(1);
163         return true;
164     }
165 
166     /**
167      * @dev remove a time records from the time records list of one account
168      *
169      * @param _target the account that holds a list of time records which record the freeze period
170      */
171     function removeLockedTime(address _target, uint _ind) internal returns (bool) {
172         require(_ind >= 0);
173         require(_target != address(0));
174 
175         TimeRec[] storage lockedTimes = frozenTimes[_target];
176         require(_ind < lockedTimes.length);
177        
178         uint256 i = _ind;
179         while (i < lockedTimes.length.sub(1)) {
180             lockedTimes[i] = lockedTimes[i.add(1)];
181             i = i.add(1);
182         }
183 
184         lockedTimes.length = lockedTimes.length.sub(1);
185         return true;
186     }
187 
188     /**
189      * @dev get total remain locked tokens of an account
190      *
191      * @param _account the owner of some amount of tokens
192      */
193     function getRemainLockedOf(address _account) public view returns (uint256) {
194         require(_account != address(0));
195 
196         uint256 totalRemain = 0;
197         uint256 len = frozenAccounts.length;
198         uint256 i = 0;
199         while (i < len) {
200             address frozenAddr = frozenAccounts[i];
201             if (frozenAddr == _account) {
202                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
203                 uint256 j = 0;
204                 while (j < timeRecLen) {
205                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
206                     totalRemain = totalRemain.add(timePair.remain);
207 
208                     j = j.add(1);
209                 }
210             }
211 
212             i = i.add(1);
213         }
214 
215         return totalRemain;
216     }
217 
218     /**
219      * judge whether we need to release some of the locked token
220      *
221      */
222     function needRelease() public view returns (bool) {
223         uint256 len = frozenAccounts.length;
224         uint256 i = 0;
225         while (i < len) {
226             address frozenAddr = frozenAccounts[i];
227             uint256 timeRecLen = frozenTimes[frozenAddr].length;
228             uint256 j = 0;
229             while (j < timeRecLen) {
230                 TimeRec storage timePair = frozenTimes[frozenAddr][j];
231                 if (now >= timePair.endTime) {
232                     return true;
233                 }
234 
235                 j = j.add(1);
236             }
237 
238             i = i.add(1);
239         }
240 
241         return false;
242     }
243 
244     /**
245      * @dev freeze the amount of tokens of an account
246      *
247      * @param _target the owner of some amount of tokens
248      * @param _value the amount of the tokens
249      * @param _frozenEndTime the end time of the lock period, unit is second
250      * @param _releasePeriod the locking period, unit is second
251      */
252     function freeze(address _target, uint256 _value, uint256 _frozenEndTime, uint256 _releasePeriod) onlyOwner public returns (bool) {
253         //require(_tokenAddr != address(0));
254         require(_target != address(0));
255         require(_value > 0);
256         require(_frozenEndTime > 0 && _releasePeriod >= 0);
257 
258         uint256 len = frozenAccounts.length;
259         
260         for (uint256 i = 0; i < len; i = i.add(1)) {
261             if (frozenAccounts[i] == _target) {
262                 break;
263             }            
264         }
265 
266         if (i >= len) {
267             frozenAccounts.push(_target); // add new account
268         } 
269         
270         // each time the new locked time will be added to the backend
271         frozenTimes[_target].push(TimeRec(_value, _value, _frozenEndTime, _frozenEndTime.add(_releasePeriod)));
272         owned.freezeAccount(_target, true);
273         
274         return true;
275     }
276 
277     /**
278      * @dev transfer an amount of tokens to an account, and then freeze the tokens
279      *
280      * @param _target the account address that will hold an amount of the tokens
281      * @param _value the amount of the tokens which has been transferred
282      * @param _frozenEndTime the end time of the lock period, unit is second
283      * @param _releasePeriod the locking period, unit is second
284      */
285     function transferAndFreeze(address _target, uint256 _value, uint256 _frozenEndTime, uint256 _releasePeriod) onlyOwner public returns (bool) {
286         //require(_tokenOwner != address(0));
287         require(_target != address(0));
288         require(_value > 0);
289         require(_frozenEndTime > 0 && _releasePeriod >= 0);
290 
291         // check firstly that the allowance of this contract has been set
292         assert(owned.allowance(msg.sender, this) > 0);
293 
294         // freeze the account at first
295         if (!freeze(_target, _value, _frozenEndTime, _releasePeriod)) {
296             return false;
297         }
298 
299         return (owned.transferFrom(msg.sender, _target, _value));
300     }
301 
302     /**
303      * release the token which are locked for once and will be total released at once 
304      * after the end point of the lock period
305      */
306     function releaseAllOnceLock() onlyOwner public returns (bool) {
307         //require(_tokenAddr != address(0));
308 
309         uint256 len = frozenAccounts.length;
310         uint256 i = 0;
311         while (i < len) {
312             address target = frozenAccounts[i];
313             if (frozenTimes[target].length == 1 && frozenTimes[target][0].endTime == frozenTimes[target][0].releasePeriodEndTime && frozenTimes[target][0].endTime > 0 && now >= frozenTimes[target][0].endTime) {
314                 uint256 releasedAmount = frozenTimes[target][0].amount;
315                     
316                 // remove current release period time record
317                 if (!removeLockedTime(target, 0)) {
318                     return false;
319                 }
320 
321                 // remove the froze account
322                 bool res = removeAccount(i);
323                 if (!res) {
324                     return false;
325                 }
326                 
327                 owned.freezeAccount(target, false);
328                 //frozenTimes[destAddr][0].endTime = 0;
329                 //frozenTimes[destAddr][0].duration = 0;
330                 ReleaseFunds(target, releasedAmount);
331                 len = len.sub(1);
332                 //frozenTimes[destAddr][0].amount = 0;
333                 //frozenTimes[destAddr][0].remain = 0;
334             } else { 
335                 // no account has been removed
336                 i = i.add(1);
337             }
338         }
339         
340         return true;
341         //return (releaseMultiAccounts(frozenAccounts));
342     }
343 
344     /**
345      * @dev release the locked tokens owned by an account, which only have only one locked time
346      * and don't have release stage.
347      *
348      * @param _target the account address that hold an amount of locked tokens
349      */
350     function releaseAccount(address _target) onlyOwner public returns (bool) {
351         //require(_tokenAddr != address(0));
352         require(_target != address(0));
353 
354         uint256 len = frozenAccounts.length;
355         uint256 i = 0;
356         while (i < len) {
357             address destAddr = frozenAccounts[i];
358             if (destAddr == _target) {
359                 if (frozenTimes[destAddr].length == 1 && frozenTimes[destAddr][0].endTime == frozenTimes[destAddr][0].releasePeriodEndTime && frozenTimes[destAddr][0].endTime > 0 && now >= frozenTimes[destAddr][0].endTime) { 
360                     uint256 releasedAmount = frozenTimes[destAddr][0].amount;
361                     
362                     // remove current release period time record
363                     if (!removeLockedTime(destAddr, 0)) {
364                         return false;
365                     }
366 
367                     // remove the froze account
368                     bool res = removeAccount(i);
369                     if (!res) {
370                         return false;
371                     }
372 
373                     owned.freezeAccount(destAddr, false);
374                     // frozenTimes[destAddr][0].endTime = 0;
375                     // frozenTimes[destAddr][0].duration = 0;
376                     ReleaseFunds(destAddr, releasedAmount);
377                     // frozenTimes[destAddr][0].amount = 0;
378                     // frozenTimes[destAddr][0].remain = 0;
379 
380                 }
381 
382                 // if the account are not locked for once, we will do nothing here
383                 return true; 
384             }
385 
386             i = i.add(1);
387         }
388         
389         return false;
390     }    
391 
392     /**
393      * @dev release the locked tokens owned by an account with several stages
394      * this need the contract get approval from the account by call approve() in the token contract
395      *
396      * @param _target the account address that hold an amount of locked tokens
397      * @param _dest the secondary address that will hold the released tokens
398      */
399     function releaseWithStage(address _target, address _dest) onlyOwner public returns (bool) {
400         //require(_tokenaddr != address(0));
401         require(_target != address(0));
402         require(_dest != address(0));
403         // require(_value > 0);
404         
405         // check firstly that the allowance of this contract from _target account has been set
406         assert(owned.allowance(_target, this) > 0);
407 
408         uint256 len = frozenAccounts.length;
409         uint256 i = 0;
410         while (i < len) {
411             // firstly find the target address
412             address frozenAddr = frozenAccounts[i];
413             if (frozenAddr == _target) {
414                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
415 
416                 bool released = false;
417                 uint256 nowTime = now;
418                 for (uint256 j = 0; j < timeRecLen; released = false) {
419                     // iterate every time records to caculate how many tokens need to be released.
420                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
421                     if (nowTime > timePair.endTime && timePair.endTime > 0 && timePair.releasePeriodEndTime > timePair.endTime) {                        
422                         uint256 lastReleased = timePair.amount.sub(timePair.remain);
423                         uint256 value = (timePair.amount * nowTime.sub(timePair.endTime) / timePair.releasePeriodEndTime.sub(timePair.endTime)).sub(lastReleased);
424                         if (value > timePair.remain) {
425                             value = timePair.remain;
426                         } 
427                         
428                         // timePair.endTime = nowTime;        
429                         timePair.remain = timePair.remain.sub(value);
430                         ReleaseFunds(frozenAddr, value);
431                         preReleaseAmounts[frozenAddr] = preReleaseAmounts[frozenAddr].add(value);
432                         if (timePair.remain < 1e8) {
433                             if (!removeLockedTime(frozenAddr, j)) {
434                                 return false;
435                             }
436                             released = true;
437                             timeRecLen = timeRecLen.sub(1);
438                         }
439                         //owned.freezeAccount(frozenAddr, true);
440                     } else if (nowTime >= timePair.endTime && timePair.endTime > 0 && timePair.releasePeriodEndTime == timePair.endTime) {
441                         // owned.freezeAccount(frozenAddr, false);
442                         timePair.remain = 0;
443                         ReleaseFunds(frozenAddr, timePair.amount);
444                         preReleaseAmounts[frozenAddr] = preReleaseAmounts[frozenAddr].add(timePair.amount);
445                         if (!removeLockedTime(frozenAddr, j)) {
446                             return false;
447                         }
448                         released = true;
449                         timeRecLen = timeRecLen.sub(1);
450 
451                        //owned.freezeAccount(frozenAddr, true);
452                     } 
453 
454                     if (!released) {
455                         j = j.add(1);
456                     }
457                 }
458 
459                 // we got some amount need to be released
460                 if (preReleaseAmounts[frozenAddr] > 0) {
461                     owned.freezeAccount(frozenAddr, false);
462                     if (!owned.transferFrom(_target, _dest, preReleaseAmounts[frozenAddr])) {
463                         return false;
464                     }
465 
466                     // set the pre-release amount to 0 for next time
467                     preReleaseAmounts[frozenAddr] = 0;
468                 }
469 
470                 // if all the frozen amounts had been released, then unlock the account finally
471                 if (frozenTimes[frozenAddr].length == 0) {
472                     if (!removeAccount(i)) {
473                         return false;
474                     }                    
475                 } else {
476                     // still has some tokens need to be released in future
477                     owned.freezeAccount(frozenAddr, true);
478                 }
479 
480                 return true;
481             }          
482 
483             i = i.add(1);
484         }
485         
486         return false;
487     }
488 }
489 
490 contract ReleaseTokenV2 is ReleaseToken {
491     mapping (address => uint256) oldBalances;
492     mapping (address => address) public releaseAddrs;
493     
494     
495     /**
496      * @dev set the new endtime of the released time of an account
497      *
498      * @param _target the owner of some amount of tokens
499      * @param _oldEndTime the original endtime for the lock period
500      * @param _newEndTime the new endtime for the lock period
501      */
502     function setNewEndtime(address _target, uint256 _oldEndTime, uint256 _newEndTime) public returns (bool) {
503         require(_target != address(0));
504         require(_oldEndTime > 0 && _newEndTime > 0);
505 
506         uint256 len = frozenAccounts.length;
507         uint256 i = 0;
508         while (i < len) {
509             address frozenAddr = frozenAccounts[i];
510             if (frozenAddr == _target) {
511                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
512                 uint256 j = 0;
513                 while (j < timeRecLen) {
514                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
515                     if (_oldEndTime == timePair.endTime) {
516                         uint256 duration = timePair.releasePeriodEndTime.sub(timePair.endTime);
517                         timePair.endTime = _newEndTime;
518                         timePair.releasePeriodEndTime = timePair.endTime.add(duration);                        
519                         
520                         return true;
521                     }
522 
523                     j = j.add(1);
524                 }
525 
526                 return false;
527             }
528 
529             i = i.add(1);
530         }
531 
532         return false;
533     }
534 
535     /**
536      * @dev set the new released period length of an account
537      *
538      * @param _target the owner of some amount of tokens
539      * @param _origEndTime the original endtime for the lock period
540      * @param _duration the new releasing period
541      */
542     function setNewReleasePeriod(address _target, uint256 _origEndTime, uint256 _duration) public returns (bool) {
543         require(_target != address(0));
544         require(_origEndTime > 0 && _duration > 0);
545 
546         uint256 len = frozenAccounts.length;
547         uint256 i = 0;
548         while (i < len) {
549             address frozenAddr = frozenAccounts[i];
550             if (frozenAddr == _target) {
551                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
552                 uint256 j = 0;
553                 while (j < timeRecLen) {
554                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
555                     if (_origEndTime == timePair.endTime) {
556                         timePair.releasePeriodEndTime = _origEndTime.add(_duration);
557                         return true;
558                     }
559 
560                     j = j.add(1);
561                 }
562 
563                 return false;
564             }
565 
566             i = i.add(1);
567         }
568 
569         return false;
570     }
571 
572     /**
573      * @dev set the new released period length of an account
574      *
575      * @param _target the owner of some amount of tokens
576      * @param _releaseTo the address that will receive the released tokens
577      */
578     function setReleasedAddress(address _target, address _releaseTo) public {
579         require(_target != address(0));
580         require(_releaseTo != address(0));
581 
582         releaseAddrs[_target] = _releaseTo;
583     }
584 
585     /**
586      * @dev get the locked stages of an account
587      *
588      * @param _target the owner of some amount of tokens
589      */
590     function getLockedStages(address _target) public view returns (uint) {
591         require(_target != address(0));
592 
593         uint256 len = frozenAccounts.length;
594         uint256 i = 0;
595         while (i < len) {
596             address frozenAddr = frozenAccounts[i];
597             if (frozenAddr == _target) {
598                 return frozenTimes[frozenAddr].length;               
599             }
600 
601             i = i.add(1);
602         }
603 
604         return 0;
605     }
606 
607     /**
608      * @dev get the endtime of the locked stages of an account
609      *
610      * @param _target the owner of some amount of tokens
611      * @param _num the stage number of the releasing period
612      */
613     function getEndTimeOfStage(address _target, uint _num) public view returns (uint256) {
614         require(_target != address(0));
615 
616         uint256 len = frozenAccounts.length;
617         uint256 i = 0;
618         while (i < len) {
619             address frozenAddr = frozenAccounts[i];
620             if (frozenAddr == _target) {
621                 TimeRec storage timePair = frozenTimes[frozenAddr][_num];                
622                 return timePair.endTime;               
623             }
624 
625             i = i.add(1);
626         }
627 
628         return 0;
629     }
630 
631     /**
632      * @dev get the remain unrleased tokens of the locked stages of an account
633      *
634      * @param _target the owner of some amount of tokens
635      * @param _num the stage number of the releasing period
636      */
637     function getRemainOfStage(address _target, uint _num) public view returns (uint256) {
638         require(_target != address(0));
639 
640         uint256 len = frozenAccounts.length;
641         uint256 i = 0;
642         while (i < len) {
643             address frozenAddr = frozenAccounts[i];
644             if (frozenAddr == _target) {
645                 TimeRec storage timePair = frozenTimes[frozenAddr][_num];                
646                 return timePair.remain;               
647             }
648 
649             i = i.add(1);
650         }
651 
652         return 0;
653     }
654 
655     /**
656      * @dev get the remain releasing period of an account
657      *
658      * @param _target the owner of some amount of tokens
659      * @param _num the stage number of the releasing period
660      */
661     function getRemainReleaseTimeOfStage(address _target, uint _num) public view returns (uint256) {
662         require(_target != address(0));
663 
664         uint256 len = frozenAccounts.length;
665         uint256 i = 0;
666         while (i < len) {
667             address frozenAddr = frozenAccounts[i];
668             if (frozenAddr == _target) {
669                 TimeRec storage timePair = frozenTimes[frozenAddr][_num];  
670                 if (timePair.releasePeriodEndTime == timePair.endTime || now <= timePair.endTime ) {
671                     return (timePair.releasePeriodEndTime.sub(timePair.endTime));
672                 }    
673 
674                 if (timePair.releasePeriodEndTime < now) {
675                     return 0;
676                 }
677 
678                 return (timePair.releasePeriodEndTime.sub(now));               
679             }
680 
681             i = i.add(1);
682         }
683 
684         return 0;
685     }
686 
687     /**
688      * @dev get the remain original tokens belong to an account before this time locking
689      *
690      * @param _target the owner of some amount of tokens
691      */
692     function gatherOldBalanceOf(address _target) public returns (uint256) {
693         require(_target != address(0));
694         require(frozenTimes[_target].length == 0); // no freeze action on this address
695 
696         // store the original balance if this the new freeze
697         uint256 origBalance = owned.balanceOf(_target);
698         if (origBalance > 0) {
699             oldBalances[_target] = origBalance;
700         }
701 
702         return origBalance;
703     }
704 
705     /**
706      * @dev get all the remain original tokens belong to a serial of accounts before this time locking
707      *
708      * @param _targets the owner of some amount of tokens
709      */
710     function gatherAllOldBalanceOf(address[] _targets) public returns (uint256) {
711         require(_targets.length != 0);
712         
713         uint256 res = 0;
714         for (uint256 i = 0; i < _targets.length; i = i.add(1)) {
715             require(_targets[i] != address(0));
716             res = res.add(gatherOldBalanceOf(_targets[i]));
717         }
718 
719         return res;
720     }
721     
722     /**
723      * @dev freeze the amount of tokens of an account
724      *
725      * @param _target the owner of some amount of tokens
726      * @param _value the amount of the tokens
727      * @param _frozenEndTime the end time of the lock period, unit is second
728      * @param _releasePeriod the locking period, unit is second
729      */
730     function freeze(address _target, uint256 _value, uint256 _frozenEndTime, uint256 _releasePeriod) onlyOwner public returns (bool) {
731         if (frozenTimes[_target].length == 0) {
732             gatherOldBalanceOf(_target);
733         }
734         return super.freeze(_target, _value, _frozenEndTime, _releasePeriod);
735     }    
736 
737     /**
738      * @dev release the locked tokens owned by an account, which are the tokens
739      * that belong to this account before being locked.
740      * this need the releasing-to address has already been set.
741      *
742      * @param _target the account address that hold an amount of locked tokens
743      */
744     function releaseOldBalanceOf(address _target) onlyOwner public returns (bool) {
745         require(_target != address(0));
746         require(releaseAddrs[_target] != address(0));
747 
748         // check firstly that the allowance of this contract from _target account has been set
749         assert(owned.allowance(_target, this) > 0);
750 
751         // we got some amount need to be released
752         if (oldBalances[_target] > 0) {
753             bool freezeStatus = owned.frozenAccount(_target);
754             owned.freezeAccount(_target, false);
755             if (!owned.transferFrom(_target, releaseAddrs[_target], oldBalances[_target])) {
756                 return false;
757             }
758 
759             // in this situation, the account should be still in original locked status
760             owned.freezeAccount(_target, freezeStatus);
761         }
762 
763         return true;
764     }    
765 
766     /**
767      * @dev release the locked tokens owned by an account with several stages
768      * this need the contract get approval from the account by call approve() in the token contract
769      * and also need the releasing-to address has already been set.
770      *
771      * @param _target the account address that hold an amount of locked tokens
772      */
773     function releaseByStage(address _target) onlyOwner public returns (bool) {
774         require(_target != address(0));
775 
776         return releaseWithStage(_target, releaseAddrs[_target]);
777     }  
778 }