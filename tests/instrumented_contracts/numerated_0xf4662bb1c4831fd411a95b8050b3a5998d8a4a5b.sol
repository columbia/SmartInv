1 /**
2 Author: Loopring Foundation (Loopring Project Ltd)
3 */
4 
5 pragma solidity ^0.5.11;
6 
7 
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(
12         address indexed previousOwner,
13         address indexed newOwner
14     );
15 
16     
17     
18     constructor()
19         public
20     {
21         owner = msg.sender;
22     }
23 
24     
25     modifier onlyOwner()
26     {
27         require(msg.sender == owner, "UNAUTHORIZED");
28         _;
29     }
30 
31     
32     
33     
34     function transferOwnership(
35         address newOwner
36         )
37         public
38         onlyOwner
39     {
40         require(newOwner != address(0), "ZERO_ADDRESS");
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45     function renounceOwnership()
46         public
47         onlyOwner
48     {
49         emit OwnershipTransferred(owner, address(0));
50         owner = address(0);
51     }
52 }
53 
54 contract Claimable is Ownable
55 {
56     address public pendingOwner;
57 
58     
59     modifier onlyPendingOwner() {
60         require(msg.sender == pendingOwner, "UNAUTHORIZED");
61         _;
62     }
63 
64     
65     
66     function transferOwnership(
67         address newOwner
68         )
69         public
70         onlyOwner
71     {
72         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
73         pendingOwner = newOwner;
74     }
75 
76     
77     function claimOwnership()
78         public
79         onlyPendingOwner
80     {
81         emit OwnershipTransferred(owner, pendingOwner);
82         owner = pendingOwner;
83         pendingOwner = address(0);
84     }
85 }
86 
87 contract ERC20 {
88     function totalSupply()
89         public
90         view
91         returns (uint);
92 
93     function balanceOf(
94         address who
95         )
96         public
97         view
98         returns (uint);
99 
100     function allowance(
101         address owner,
102         address spender
103         )
104         public
105         view
106         returns (uint);
107 
108     function transfer(
109         address to,
110         uint value
111         )
112         public
113         returns (bool);
114 
115     function transferFrom(
116         address from,
117         address to,
118         uint    value
119         )
120         public
121         returns (bool);
122 
123     function approve(
124         address spender,
125         uint    value
126         )
127         public
128         returns (bool);
129 }
130 
131 library ERC20SafeTransfer {
132     function safeTransferAndVerify(
133         address token,
134         address to,
135         uint    value
136         )
137         internal
138     {
139         safeTransferWithGasLimitAndVerify(
140             token,
141             to,
142             value,
143             gasleft()
144         );
145     }
146 
147     function safeTransfer(
148         address token,
149         address to,
150         uint    value
151         )
152         internal
153         returns (bool)
154     {
155         return safeTransferWithGasLimit(
156             token,
157             to,
158             value,
159             gasleft()
160         );
161     }
162 
163     function safeTransferWithGasLimitAndVerify(
164         address token,
165         address to,
166         uint    value,
167         uint    gasLimit
168         )
169         internal
170     {
171         require(
172             safeTransferWithGasLimit(token, to, value, gasLimit),
173             "TRANSFER_FAILURE"
174         );
175     }
176 
177     function safeTransferWithGasLimit(
178         address token,
179         address to,
180         uint    value,
181         uint    gasLimit
182         )
183         internal
184         returns (bool)
185     {
186         
187         
188         
189 
190         
191         bytes memory callData = abi.encodeWithSelector(
192             bytes4(0xa9059cbb),
193             to,
194             value
195         );
196         (bool success, ) = token.call.gas(gasLimit)(callData);
197         return checkReturnValue(success);
198     }
199 
200     function safeTransferFromAndVerify(
201         address token,
202         address from,
203         address to,
204         uint    value
205         )
206         internal
207     {
208         safeTransferFromWithGasLimitAndVerify(
209             token,
210             from,
211             to,
212             value,
213             gasleft()
214         );
215     }
216 
217     function safeTransferFrom(
218         address token,
219         address from,
220         address to,
221         uint    value
222         )
223         internal
224         returns (bool)
225     {
226         return safeTransferFromWithGasLimit(
227             token,
228             from,
229             to,
230             value,
231             gasleft()
232         );
233     }
234 
235     function safeTransferFromWithGasLimitAndVerify(
236         address token,
237         address from,
238         address to,
239         uint    value,
240         uint    gasLimit
241         )
242         internal
243     {
244         bool result = safeTransferFromWithGasLimit(
245             token,
246             from,
247             to,
248             value,
249             gasLimit
250         );
251         require(result, "TRANSFER_FAILURE");
252     }
253 
254     function safeTransferFromWithGasLimit(
255         address token,
256         address from,
257         address to,
258         uint    value,
259         uint    gasLimit
260         )
261         internal
262         returns (bool)
263     {
264         
265         
266         
267 
268         
269         bytes memory callData = abi.encodeWithSelector(
270             bytes4(0x23b872dd),
271             from,
272             to,
273             value
274         );
275         (bool success, ) = token.call.gas(gasLimit)(callData);
276         return checkReturnValue(success);
277     }
278 
279     function checkReturnValue(
280         bool success
281         )
282         internal
283         pure
284         returns (bool)
285     {
286         
287         
288         
289         if (success) {
290             assembly {
291                 switch returndatasize()
292                 
293                 case 0 {
294                     success := 1
295                 }
296                 
297                 case 32 {
298                     returndatacopy(0, 0, 32)
299                     success := mload(0)
300                 }
301                 
302                 default {
303                     success := 0
304                 }
305             }
306         }
307         return success;
308     }
309 }
310 
311 library MathUint {
312     function mul(
313         uint a,
314         uint b
315         )
316         internal
317         pure
318         returns (uint c)
319     {
320         c = a * b;
321         require(a == 0 || c / a == b, "MUL_OVERFLOW");
322     }
323 
324     function sub(
325         uint a,
326         uint b
327         )
328         internal
329         pure
330         returns (uint)
331     {
332         require(b <= a, "SUB_UNDERFLOW");
333         return a - b;
334     }
335 
336     function add(
337         uint a,
338         uint b
339         )
340         internal
341         pure
342         returns (uint c)
343     {
344         c = a + b;
345         require(c >= a, "ADD_OVERFLOW");
346     }
347 
348     function decodeFloat(
349         uint f
350         )
351         internal
352         pure
353         returns (uint value)
354     {
355         uint numBitsMantissa = 23;
356         uint exponent = f >> numBitsMantissa;
357         uint mantissa = f & ((1 << numBitsMantissa) - 1);
358         value = mantissa * (10 ** exponent);
359     }
360 }
361 
362 contract ReentrancyGuard {
363     
364     uint private _guardValue;
365 
366     
367     modifier nonReentrant()
368     {
369         
370         require(_guardValue == 0, "REENTRANCY");
371 
372         
373         _guardValue = 1;
374 
375         
376         _;
377 
378         
379         _guardValue = 0;
380     }
381 }
382 
383 contract IProtocolFeeVault {
384     uint public constant REWARD_PERCENTAGE      = 70;
385     uint public constant DAO_PERDENTAGE         = 20;
386 
387     address public userStakingPoolAddress;
388     address public lrcAddress;
389     address public tokenSellerAddress;
390     address public daoAddress;
391 
392     uint claimedReward;
393     uint claimedDAOFund;
394     uint claimedBurn;
395 
396     event LRCClaimed(uint amount);
397     event DAOFunded(uint amountDAO, uint amountBurn);
398     event TokenSold(address token, uint amount);
399     event SettingsUpdated(uint time);
400 
401     
402     
403     
404     
405     function updateSettings(
406         address _userStakingPoolAddress,
407         address _tokenSellerAddress,
408         address _daoAddress
409         )
410         external;
411 
412     
413     
414     
415     
416     
417     function claimStakingReward(uint amount) external;
418 
419     
420     
421     function fundDAO() external;
422 
423     
424     
425     
426     
427     function sellTokenForLRC(
428         address token,
429         uint    amount
430         )
431         external;
432 
433     
434     
435     
436     
437     
438     
439     
440     
441     
442     function getProtocolFeeStats()
443         public
444         view
445         returns (
446             uint accumulatedFees,
447             uint accumulatedBurn,
448             uint accumulatedDAOFund,
449             uint accumulatedReward,
450             uint remainingFees,
451             uint remainingBurn,
452             uint remainingDAOFund,
453             uint remainingReward
454         );
455 }
456 
457 contract IUserStakingPool {
458     uint public constant MIN_CLAIM_DELAY        = 90 days;
459     uint public constant MIN_WITHDRAW_DELAY     = 90 days;
460 
461     address public lrcAddress;
462     address public protocolFeeVaultAddress;
463 
464     uint    public numAddresses;
465 
466     event ProtocolFeeVaultChanged (address feeVaultAddress);
467 
468     event LRCStaked       (address indexed user,  uint amount);
469     event LRCWithdrawn    (address indexed user,  uint amount);
470     event LRCRewarded     (address indexed user,  uint amount);
471 
472     
473     
474     function setProtocolFeeVault(address _protocolFeeVaultAddress)
475         external;
476 
477     
478     function getTotalStaking()
479         public
480         view
481         returns (uint);
482 
483     
484     
485     
486     
487     
488     
489     function getUserStaking(address user)
490         public
491         view
492         returns (
493             uint withdrawalWaitTime,
494             uint rewardWaitTime,
495             uint balance,
496             uint pendingReward
497         );
498 
499     
500     
501     
502     function stake(uint amount)
503         external;
504 
505     
506     
507     function withdraw(uint amount)
508         external;
509 
510     
511     
512     
513     function claim()
514         external
515         returns (uint claimedAmount);
516 }
517 
518 contract UserStakingPool is Claimable, ReentrancyGuard, IUserStakingPool
519 {
520     using ERC20SafeTransfer for address;
521     using MathUint          for uint;
522 
523     struct Staking {
524         uint   balance;        
525         uint64 depositedAt;
526         uint64 claimedAt;      
527     }
528 
529     Staking public total;
530     mapping (address => Staking) public stakings;
531 
532     constructor(address _lrcAddress)
533         Claimable()
534         public
535     {
536         require(_lrcAddress != address(0), "ZERO_ADDRESS");
537         lrcAddress = _lrcAddress;
538     }
539 
540     function setProtocolFeeVault(address _protocolFeeVaultAddress)
541         external
542         nonReentrant
543         onlyOwner
544     {
545         
546         protocolFeeVaultAddress = _protocolFeeVaultAddress;
547         emit ProtocolFeeVaultChanged(protocolFeeVaultAddress);
548     }
549 
550     function getTotalStaking()
551         public
552         view
553         returns (uint)
554     {
555         return total.balance;
556     }
557 
558     function getUserStaking(address user)
559         public
560         view
561         returns (
562             uint withdrawalWaitTime,
563             uint rewardWaitTime,
564             uint balance,
565             uint pendingReward
566         )
567     {
568         withdrawalWaitTime = getUserWithdrawalWaitTime(user);
569         rewardWaitTime = getUserClaimWaitTime(user);
570         balance = stakings[user].balance;
571         (, , pendingReward) = getUserPendingReward(user);
572     }
573 
574     function stake(uint amount)
575         external
576         nonReentrant
577     {
578         require(amount > 0, "ZERO_VALUE");
579 
580         
581         lrcAddress.safeTransferFromAndVerify(msg.sender, address(this), amount);
582 
583         Staking storage user = stakings[msg.sender];
584 
585         if (user.balance == 0) {
586             numAddresses += 1;
587         }
588 
589         
590         uint balance = user.balance.add(amount);
591 
592         user.depositedAt = uint64(
593             user.balance
594                 .mul(user.depositedAt)
595                 .add(amount.mul(now)) / balance
596         );
597 
598         user.claimedAt = uint64(
599             user.balance
600                 .mul(user.claimedAt)
601                 .add(amount.mul(now)) / balance
602         );
603 
604         user.balance = balance;
605 
606         
607         balance = total.balance.add(amount);
608 
609         total.claimedAt = uint64(
610             total.balance
611                 .mul(total.claimedAt)
612                 .add(amount.mul(now)) / balance
613         );
614 
615         total.balance = balance;
616 
617         emit LRCStaked(msg.sender, amount);
618     }
619 
620     function withdraw(uint amount)
621         external
622         nonReentrant
623     {
624         require(getUserWithdrawalWaitTime(msg.sender) == 0, "NEED_TO_WAIT");
625 
626         
627         if (protocolFeeVaultAddress != address(0) &&
628             getUserClaimWaitTime(msg.sender) == 0) {
629             claimReward();
630         }
631 
632         Staking storage user = stakings[msg.sender];
633 
634         uint _amount = (amount == 0 || amount > user.balance) ? user.balance : amount;
635         require(_amount > 0, "ZERO_BALANCE");
636 
637         total.balance = total.balance.sub(_amount);
638         user.balance = user.balance.sub(_amount);
639 
640         if (user.balance == 0) {
641             numAddresses -= 1;
642             delete stakings[msg.sender];
643         }
644 
645         
646         lrcAddress.safeTransferAndVerify(msg.sender, _amount);
647 
648         emit LRCWithdrawn(msg.sender, _amount);
649     }
650 
651     function claim()
652         external
653         nonReentrant
654         returns (uint claimedAmount)
655     {
656         return claimReward();
657     }
658 
659     
660 
661     function claimReward()
662         private
663         returns (uint claimedAmount)
664     {
665         require(protocolFeeVaultAddress != address(0), "ZERO_ADDRESS");
666         require(getUserClaimWaitTime(msg.sender) == 0, "NEED_TO_WAIT");
667 
668         uint totalPoints;
669         uint userPoints;
670 
671         (totalPoints, userPoints, claimedAmount) = getUserPendingReward(msg.sender);
672 
673         if (claimedAmount > 0) {
674             IProtocolFeeVault(protocolFeeVaultAddress).claimStakingReward(claimedAmount);
675 
676             total.balance = total.balance.add(claimedAmount);
677 
678             total.claimedAt = uint64(
679                 now.sub(totalPoints.sub(userPoints) / total.balance)
680             );
681 
682             Staking storage user = stakings[msg.sender];
683             user.balance = user.balance.add(claimedAmount);
684             user.claimedAt = uint64(now);
685         }
686         emit LRCRewarded(msg.sender, claimedAmount);
687     }
688 
689     function getUserWithdrawalWaitTime(address user)
690         private
691         view
692         returns (uint)
693     {
694         uint depositedAt = stakings[user].depositedAt;
695         if (depositedAt == 0) {
696             return MIN_WITHDRAW_DELAY;
697         } else {
698             uint time = depositedAt + MIN_WITHDRAW_DELAY;
699             return (time <= now) ? 0 : time.sub(now);
700         }
701     }
702 
703     function getUserClaimWaitTime(address user)
704         private
705         view
706         returns (uint)
707     {
708         uint claimedAt = stakings[user].claimedAt;
709         if (claimedAt == 0) {
710             return MIN_CLAIM_DELAY;
711         } else {
712             uint time = stakings[user].claimedAt + MIN_CLAIM_DELAY;
713             return (time <= now) ? 0 : time.sub(now);
714         }
715     }
716 
717     function getUserPendingReward(address user)
718         private
719         view
720         returns (
721             uint totalPoints,
722             uint userPoints,
723             uint pendingReward
724         )
725     {
726         Staking storage staking = stakings[user];
727 
728         
729         totalPoints = total.balance.mul(now.sub(total.claimedAt).add(1));
730         userPoints = staking.balance.mul(now.sub(staking.claimedAt));
731 
732         
733         if (totalPoints < userPoints) {
734             userPoints = totalPoints;
735         }
736 
737         if (protocolFeeVaultAddress != address(0) &&
738             totalPoints != 0 &&
739             userPoints != 0) {
740             (, , , , , , , pendingReward) = IProtocolFeeVault(
741                 protocolFeeVaultAddress
742             ).getProtocolFeeStats();
743             pendingReward = pendingReward.mul(userPoints) / totalPoints;
744         }
745     }
746 }