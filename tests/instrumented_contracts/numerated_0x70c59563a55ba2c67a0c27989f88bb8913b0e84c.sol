1 pragma solidity ^0.4.6;
2 
3 contract SafeMath {
4     function mul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint a, uint b) internal returns (uint) {
11         assert(b > 0);
12         uint c = a / b;
13         assert(a == b * c + a % b);
14         return c;
15     }
16 
17     function sub(uint a, uint b) internal returns (uint) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint a, uint b) internal returns (uint) {
23         uint c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract TokenController {
30     function proxyPayment(address _owner) payable returns (bool);
31 
32     function onTransfer(address _from, address _to, uint _amount) returns (bool);
33 
34     function onApprove(address _owner, address _spender, uint _amount)
35     returns (bool);
36 }
37 
38 
39 contract Controlled {
40     modifier onlyController {if (msg.sender != controller) throw;
41         _;}
42 
43     address public controller;
44 
45     function Controlled() {controller = msg.sender;}
46 
47     function changeController(address _newController) onlyController {
48         controller = _newController;
49     }
50 }
51 
52 
53 contract ApproveAndCallFallBack {
54     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
55 }
56 
57 
58 contract ShineCoinToken is Controlled {
59     string public name;
60     uint8 public decimals;
61     string public symbol;
62     string public version = 'SHINE_0.1';
63 
64     struct Checkpoint {
65         uint128 fromBlock;
66         uint128 value;
67     }
68 
69     ShineCoinToken public parentToken;
70 
71     address public frozenReserveTeamRecipient;
72 
73     uint public parentSnapShotBlock;
74 
75     uint public creationBlock;
76 
77     // Periods
78     uint public firstRewardPeriodEndBlock;
79 
80     uint public secondRewardPeriodEndBlock;
81 
82     uint public thirdRewardPeriodEndBlock;
83 
84     uint public finalRewardPeriodEndBlock;
85 
86     // Loos
87     uint public firstLoos;
88 
89     uint public secondLoos;
90 
91     uint public thirdLoos;
92 
93     uint public finalLoos;
94 
95 
96     // Percents
97     uint public firstRewardPeriodPercent;
98 
99     uint public secondRewardPeriodPercent;
100 
101     uint public thirdRewardPeriodPercent;
102 
103     uint public finalRewardPeriodPercent;
104 
105     // Unfreeze team wallet for transfers
106     uint public unfreezeTeamRecepientBlock;
107 
108     mapping (address => Checkpoint[]) balances;
109 
110     mapping (address => mapping (address => uint256)) allowed;
111 
112     Checkpoint[] totalSupplyHistory;
113 
114     bool public transfersEnabled;
115 
116     ShineCoinTokenFactory public tokenFactory;
117 
118     function ShineCoinToken(
119         address _tokenFactory,
120         address _parentToken,
121         uint _parentSnapShotBlock,
122         string _tokenName,
123         uint8 _decimalUnits,
124         string _tokenSymbol,
125         bool _transfersEnabled
126     ) {
127         tokenFactory = ShineCoinTokenFactory(_tokenFactory);
128         name = _tokenName;
129         decimals = _decimalUnits;
130         symbol = _tokenSymbol;
131         parentToken = ShineCoinToken(_parentToken);
132         parentSnapShotBlock = _parentSnapShotBlock;
133         transfersEnabled = _transfersEnabled;
134         creationBlock = block.number;
135         unfreezeTeamRecepientBlock = block.number + ((396 * 24 * 3600) / 18); // 396 days
136 
137         firstRewardPeriodEndBlock = creationBlock + ((121 * 24 * 3600) / 18); // 121 days
138         secondRewardPeriodEndBlock = creationBlock + ((181 * 24 * 3600) / 18); // 181 days
139         thirdRewardPeriodEndBlock = creationBlock + ((211 * 24 * 3600) / 18); // 211 days
140         finalRewardPeriodEndBlock = creationBlock + ((760 * 24 * 3600) / 18); // 2 years
141 
142         firstRewardPeriodPercent = 29;
143         secondRewardPeriodPercent = 23;
144         thirdRewardPeriodPercent = 18;
145         finalRewardPeriodPercent = 12;
146 
147         firstLoos = ((15 * 24 * 3600) / 18); // 15 days;
148         secondLoos = ((10 * 24 * 3600) / 18); // 10 days;
149         thirdLoos = ((5 * 24 * 3600) / 18); // 5 days;
150         finalLoos = ((1 * 24 * 3600) / 18); // 1 days;
151     }
152 
153     function changeReserveTeamRecepient(address _newReserveTeamRecipient) onlyController returns (bool) {
154         frozenReserveTeamRecipient = _newReserveTeamRecipient;
155         return true;
156     }
157 
158     ///////////////////
159     // ERC20 Methods
160     ///////////////////
161 
162     function transfer(address _to, uint256 _amount) returns (bool success) {
163         if (!transfersEnabled) throw;
164         if ((address(msg.sender) == frozenReserveTeamRecipient) && (block.number < unfreezeTeamRecepientBlock)) throw;
165         if ((_to == frozenReserveTeamRecipient) && (block.number < unfreezeTeamRecepientBlock)) throw;
166         return doTransfer(msg.sender, _to, _amount);
167     }
168 
169     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
170         if (msg.sender != controller) {
171             if (!transfersEnabled) throw;
172 
173             if (allowed[_from][msg.sender] < _amount) return false;
174             allowed[_from][msg.sender] -= _amount;
175         }
176         return doTransfer(_from, _to, _amount);
177     }
178 
179     function doTransfer(address _from, address _to, uint _amount) internal returns (bool) {
180 
181         if (_amount == 0) {
182             return true;
183         }
184 
185         if (parentSnapShotBlock >= block.number) throw;
186 
187         if ((_to == 0) || (_to == address(this))) throw;
188 
189         var previousBalanceFrom = balanceOfAt(_from, block.number);
190         if (previousBalanceFrom < _amount) {
191             return false;
192         }
193 
194         if (isContract(controller)) {
195             if (!TokenController(controller).onTransfer(_from, _to, _amount))
196             throw;
197         }
198 
199         Checkpoint[] checkpoints = balances[_from];
200         uint lastBlock = checkpoints[checkpoints.length - 1].fromBlock;
201         uint blocksFromLastBlock = block.number - lastBlock;
202         uint rewardAmount = 0;
203 
204         if (block.number <= firstRewardPeriodEndBlock) {
205             if (blocksFromLastBlock > firstLoos) {
206                 rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * blocksFromLastBlock;
207             }
208         }
209         else if (block.number <= secondRewardPeriodEndBlock) {
210             if (blocksFromLastBlock > secondLoos) {
211                 if (lastBlock < firstRewardPeriodEndBlock) {
212                     rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * (firstRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * secondRewardPeriodPercent * (secondRewardPeriodEndBlock - block.number);
213                 }
214                 else {
215                     rewardAmount = previousBalanceFrom * secondRewardPeriodPercent * blocksFromLastBlock;
216                 }
217             }
218         }
219         else if (block.number <= thirdRewardPeriodEndBlock) {
220             if (blocksFromLastBlock > thirdLoos) {
221                 if (lastBlock < firstRewardPeriodEndBlock) {
222                     rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * (firstRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * secondRewardPeriodPercent * (thirdRewardPeriodEndBlock - secondRewardPeriodEndBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (thirdRewardPeriodEndBlock - block.number);
223                 }
224                 else if (lastBlock < secondRewardPeriodEndBlock) {
225                     rewardAmount = previousBalanceFrom * secondRewardPeriodPercent * (secondRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (thirdRewardPeriodEndBlock - block.number);
226                 }
227                 else {
228                     rewardAmount = previousBalanceFrom * thirdRewardPeriodPercent * blocksFromLastBlock;
229                 }
230             }
231         }
232         else if (block.number <= finalRewardPeriodEndBlock) {
233             if (blocksFromLastBlock > finalLoos) {
234                 if (lastBlock < firstRewardPeriodEndBlock) {
235                     rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * (firstRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * secondRewardPeriodPercent * (thirdRewardPeriodEndBlock - secondRewardPeriodEndBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
236                 }
237                 else if (lastBlock < secondRewardPeriodEndBlock) {
238                     rewardAmount = previousBalanceFrom * secondRewardPeriodPercent * (secondRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
239                 }
240                 else if (lastBlock < secondRewardPeriodEndBlock) {
241                     rewardAmount = previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
242                 }
243                 else {
244                     rewardAmount = previousBalanceFrom * finalRewardPeriodPercent * blocksFromLastBlock;
245                 }
246             }
247         }
248         else {
249             if (blocksFromLastBlock > finalLoos) {
250                 if (lastBlock < firstRewardPeriodEndBlock) {
251                     rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * (firstRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * secondRewardPeriodPercent * (thirdRewardPeriodEndBlock - secondRewardPeriodEndBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
252                 }
253                 else if (lastBlock < secondRewardPeriodEndBlock) {
254                     rewardAmount = previousBalanceFrom * secondRewardPeriodPercent * (secondRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
255                 }
256                 else if (lastBlock < secondRewardPeriodEndBlock) {
257                     rewardAmount = previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
258                 }
259                 else {
260                     rewardAmount = previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock);
261                 }
262             }
263         }
264 
265         rewardAmount = rewardAmount / 10000;
266         uint curTotalSupply = 0;
267 
268         updateValueAtNow(balances[_from], previousBalanceFrom - _amount + rewardAmount);
269 
270         // UPDATE TOTAL
271         if (rewardAmount > 0) {
272             curTotalSupply = getValueAt(totalSupplyHistory, block.number);
273             if (curTotalSupply + rewardAmount < curTotalSupply) throw; // Check for overflow
274             updateValueAtNow(totalSupplyHistory, curTotalSupply + rewardAmount);
275         }
276 
277         rewardAmount = 0;
278 
279         var previousBalanceTo = balanceOfAt(_to, block.number);
280         if (previousBalanceTo + _amount < previousBalanceTo) throw;
281 
282         checkpoints = balances[_to];
283         if (checkpoints.length > 0) {
284             lastBlock = checkpoints[checkpoints.length - 1].fromBlock;
285             blocksFromLastBlock = block.number - lastBlock;
286 
287             if (_amount >= (previousBalanceTo / 3)) {
288                 if (blocksFromLastBlock > finalLoos) {
289 
290                     if (block.number <= firstRewardPeriodEndBlock) {
291                         rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * blocksFromLastBlock;
292                     }
293                     else if (block.number <= secondRewardPeriodEndBlock) {
294 
295                         if (lastBlock < firstRewardPeriodEndBlock) {
296                             rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * (firstRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * secondRewardPeriodPercent * (secondRewardPeriodEndBlock - block.number);
297                         }
298                         else {
299                             rewardAmount = previousBalanceFrom * secondRewardPeriodPercent * blocksFromLastBlock;
300                         }
301 
302                     }
303                     else if (block.number <= thirdRewardPeriodEndBlock) {
304 
305                         if (lastBlock < firstRewardPeriodEndBlock) {
306                             rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * (firstRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * secondRewardPeriodPercent * (thirdRewardPeriodEndBlock - secondRewardPeriodEndBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (thirdRewardPeriodEndBlock - block.number);
307                         }
308                         else if (lastBlock < secondRewardPeriodEndBlock) {
309                             rewardAmount = previousBalanceFrom * secondRewardPeriodPercent * (secondRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (thirdRewardPeriodEndBlock - block.number);
310                         }
311                         else {
312                             rewardAmount = previousBalanceFrom * thirdRewardPeriodPercent * blocksFromLastBlock;
313                         }
314 
315                     }
316                     else if (block.number <= finalRewardPeriodEndBlock) {
317 
318                         if (lastBlock < firstRewardPeriodEndBlock) {
319                             rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * (firstRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * secondRewardPeriodPercent * (thirdRewardPeriodEndBlock - secondRewardPeriodEndBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
320                         }
321                         else if (lastBlock < secondRewardPeriodEndBlock) {
322                             rewardAmount = previousBalanceFrom * secondRewardPeriodPercent * (secondRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
323                         }
324                         else if (lastBlock < secondRewardPeriodEndBlock) {
325                             rewardAmount = previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
326                         }
327                         else {
328                             rewardAmount = previousBalanceFrom * finalRewardPeriodPercent * blocksFromLastBlock;
329                         }
330 
331                     }
332                     else {
333 
334                         if (lastBlock < firstRewardPeriodEndBlock) {
335                             rewardAmount = previousBalanceFrom * firstRewardPeriodPercent * (firstRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * secondRewardPeriodPercent * (thirdRewardPeriodEndBlock - secondRewardPeriodEndBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
336                         }
337                         else if (lastBlock < secondRewardPeriodEndBlock) {
338                             rewardAmount = previousBalanceFrom * secondRewardPeriodPercent * (secondRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
339                         }
340                         else if (lastBlock < secondRewardPeriodEndBlock) {
341                             rewardAmount = previousBalanceFrom * thirdRewardPeriodPercent * (finalRewardPeriodEndBlock - lastBlock) + previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - block.number);
342                         }
343                         else {
344                             rewardAmount = previousBalanceFrom * finalRewardPeriodPercent * (finalRewardPeriodEndBlock - thirdRewardPeriodEndBlock);
345                         }
346                     }
347 
348                 }
349             }
350 
351         }
352 
353         rewardAmount = rewardAmount / 10000;
354         updateValueAtNow(balances[_to], previousBalanceTo + _amount + rewardAmount);
355 
356         // UPDATE TOTAL
357         if (rewardAmount > 0) {
358             curTotalSupply = getValueAt(totalSupplyHistory, block.number);
359             if (curTotalSupply + rewardAmount < curTotalSupply) throw;
360             // Check for overflow
361             updateValueAtNow(totalSupplyHistory, curTotalSupply + rewardAmount);
362         }
363 
364         Transfer(_from, _to, _amount);
365 
366         return true;
367     }
368 
369     function balanceOf(address _owner) constant returns (uint256 balance) {
370         return balanceOfAt(_owner, block.number);
371     }
372 
373     function approve(address _spender, uint256 _amount) returns (bool success) {
374         if (!transfersEnabled) throw;
375 
376         if ((_amount != 0) && (allowed[msg.sender][_spender] != 0)) throw;
377 
378         if (isContract(controller)) {
379             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
380             throw;
381         }
382 
383         allowed[msg.sender][_spender] = _amount;
384         Approval(msg.sender, _spender, _amount);
385         return true;
386     }
387 
388     function allowance(address _owner, address _spender
389     ) constant returns (uint256 remaining) {
390         return allowed[_owner][_spender];
391     }
392 
393     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
394     ) returns (bool success) {
395         if (!approve(_spender, _amount)) throw;
396 
397         ApproveAndCallFallBack(_spender).receiveApproval(
398         msg.sender,
399         _amount,
400         this,
401         _extraData
402         );
403 
404         return true;
405     }
406 
407     function totalSupply() constant returns (uint) {
408         return totalSupplyAt(block.number);
409     }
410 
411     function getBalancesOfAddress(address _owner) onlyController returns (uint128, uint128) {
412         Checkpoint[] checkpoints = balances[_owner];
413         return (checkpoints[checkpoints.length - 1].value, checkpoints[checkpoints.length - 1].fromBlock);
414     }
415 
416     function balanceOfAt(address _owner, uint _blockNumber) constant
417     returns (uint) {
418 
419         if ((balances[_owner].length == 0)
420         || (balances[_owner][0].fromBlock > _blockNumber)) {
421             if (address(parentToken) != 0) {
422                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
423             }
424             else {
425                 return 0;
426             }
427         }
428         else {
429             return getValueAt(balances[_owner], _blockNumber);
430         }
431     }
432 
433     function totalSupplyAt(uint _blockNumber) constant returns (uint) {
434         if ((totalSupplyHistory.length == 0)
435         || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
436             if (address(parentToken) != 0) {
437                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
438             }
439             else {
440                 return 0;
441             }
442         }
443         else {
444             return getValueAt(totalSupplyHistory, _blockNumber);
445         }
446     }
447 
448 
449     function createCloneToken(
450         string _cloneTokenName,
451         uint8 _cloneDecimalUnits,
452         string _cloneTokenSymbol,
453         uint _snapshotBlock,
454         bool _transfersEnabled
455     ) returns (address) {
456         if (_snapshotBlock == 0) _snapshotBlock = block.number;
457         ShineCoinToken cloneToken = tokenFactory.createCloneToken(
458         this,
459         _snapshotBlock,
460         _cloneTokenName,
461         _cloneDecimalUnits,
462         _cloneTokenSymbol,
463         _transfersEnabled
464         );
465 
466         cloneToken.changeController(msg.sender);
467 
468         NewCloneToken(address(cloneToken), _snapshotBlock);
469         return address(cloneToken);
470     }
471 
472     function generateTokens(address _owner, uint _amount
473     ) onlyController returns (bool) {
474         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
475         if (curTotalSupply + _amount < curTotalSupply) throw;
476 
477         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
478         var previousBalanceTo = balanceOf(_owner);
479         if (previousBalanceTo + _amount < previousBalanceTo) throw;
480 
481         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
482         Transfer(0, _owner, _amount);
483         return true;
484     }
485 
486     function destroyTokens(address _owner, uint _amount
487     ) onlyController returns (bool) {
488         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
489         if (curTotalSupply < _amount) throw;
490         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
491         var previousBalanceFrom = balanceOf(_owner);
492         if (previousBalanceFrom < _amount) throw;
493         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
494         Transfer(_owner, 0, _amount);
495         return true;
496     }
497 
498     function enableTransfers(bool _transfersEnabled) onlyController {
499         transfersEnabled = _transfersEnabled;
500     }
501 
502     function getValueAt(Checkpoint[] storage checkpoints, uint _block
503     ) constant internal returns (uint) {
504         if (checkpoints.length == 0) return 0;
505 
506         if (_block >= checkpoints[checkpoints.length - 1].fromBlock)
507         return checkpoints[checkpoints.length - 1].value;
508         if (_block < checkpoints[0].fromBlock) return 0;
509 
510         uint min = 0;
511         uint max = checkpoints.length - 1;
512         while (max > min) {
513             uint mid = (max + min + 1) / 2;
514             if (checkpoints[mid].fromBlock <= _block) {
515                 min = mid;
516             }
517             else {
518                 max = mid - 1;
519             }
520         }
521         return checkpoints[min].value;
522     }
523 
524     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
525     ) internal {
526         if ((checkpoints.length == 0)
527         || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
528             Checkpoint newCheckPoint = checkpoints[checkpoints.length++];
529             newCheckPoint.fromBlock = uint128(block.number);
530             newCheckPoint.value = uint128(_value);
531         }
532         else {
533             Checkpoint oldCheckPoint = checkpoints[checkpoints.length - 1];
534             oldCheckPoint.value = uint128(_value);
535         }
536     }
537 
538     function isContract(address _addr) constant internal returns (bool) {
539         uint size;
540         if (_addr == 0) return false;
541         assembly {
542         size := extcodesize(_addr)
543         }
544         return size > 0;
545     }
546 
547     function min(uint a, uint b) internal returns (uint) {
548         return a < b ? a : b;
549     }
550 
551     function() payable {
552         if (isContract(controller)) {
553             if (!TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
554             throw;
555         }
556         else {
557             throw;
558         }
559     }
560 
561     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
562 
563     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
564 
565     event Approval(
566         address indexed _owner,
567         address indexed _spender,
568         uint256 _amount
569     );
570 
571 }
572 
573 contract ShineCoinTokenFactory {
574         function createCloneToken(
575         address _parentToken,
576         uint _snapshotBlock,
577         string _tokenName,
578         uint8 _decimalUnits,
579         string _tokenSymbol,
580         bool _transfersEnabled
581     ) returns (ShineCoinToken) {
582         ShineCoinToken newToken = new ShineCoinToken(
583         this,
584         _parentToken,
585         _snapshotBlock,
586         _tokenName,
587         _decimalUnits,
588         _tokenSymbol,
589         _transfersEnabled
590         );
591         newToken.changeController(msg.sender);
592         return newToken;
593     }
594 }
595 
596 contract ShineCrowdFunder is Controlled, SafeMath {
597     address public creator;
598 
599     address public fundRecipient;
600 
601     address public reserveTeamRecipient;
602 
603     address public reserveBountyRecipient;
604 
605     address public developersRecipient;
606 
607     address public marketingRecipient;
608 
609     bool public isReserveGenerated;
610 
611     State public state = State.Wait;
612 
613     uint investorCount;
614 
615     uint public minFundingGoal;
616 
617     uint public currentBalance;
618 
619     uint public tokensIssued;
620 
621     uint public capTokenAmount;
622 
623     uint public startBlockNumber;
624 
625     uint public endBlockNumber;
626 
627     uint public tokenExchangeRate;
628 
629     ShineCoinToken public exchangeToken;
630 
631     event GoalReached(address fundRecipient, uint amountRaised);
632 
633     event FundTransfer(address backer, uint amount, bool isContribution);
634 
635     event FrozenFunds(address target, bool frozen);
636 
637     event LogFundingReceived(address addr, uint amount, uint currentTotal);
638 
639     mapping (address => uint256) private balanceOf;
640 
641     mapping (address => uint) public fiatInvestorShare;
642 
643     address[] fiatInvestors;
644 
645     mapping (address => bool) private frozenAccount;
646 
647     enum State {
648         Wait,
649         Fundraising,
650         ExpiredRefund,
651         Successful,
652         Closed
653     }
654 
655     modifier inState(State _state) {
656         if (state != _state) throw;
657         _;
658     }
659 
660     modifier atEndOfFundraising() {
661         if (!((state == State.ExpiredRefund || state == State.Successful) && block.number > endBlockNumber)
662         ) {
663             throw;
664         }
665         _;
666     }
667 
668     modifier accountNotFrozen() {
669         if (frozenAccount[msg.sender] == true) throw;
670         _;
671     }
672 
673     modifier minInvestment() {
674         // User has to send at least 0.01 Eth
675         require(msg.value >= 10 ** 16);
676         _;
677     }
678 
679     function ShineCrowdFunder(
680     address _fundRecipient,
681     address _reserveTeamRecipient,
682     address _reserveBountyRecipient,
683     address _developersRecipient,
684     address _marketingRecipient,
685     ShineCoinToken _addressOfExchangeToken
686     ) {
687         creator = msg.sender;
688 
689         fundRecipient = _fundRecipient;
690         reserveTeamRecipient = _reserveTeamRecipient;
691         reserveBountyRecipient = _reserveBountyRecipient;
692 
693         developersRecipient = _developersRecipient;
694         marketingRecipient = _marketingRecipient;
695 
696         isReserveGenerated = false;
697 
698         minFundingGoal = 10 * 1 ether;
699         capTokenAmount = 10000000 * 10 ** 9;
700 
701         state = State.Wait;
702 
703         currentBalance = 0;
704         tokensIssued = 0;
705 
706         tokenExchangeRate = 1000 * 10 ** 9;
707 
708         exchangeToken = ShineCoinToken(_addressOfExchangeToken);
709     }
710 
711     function startFundraising() inState(State.Wait) onlyController {
712         startBlockNumber = block.number;
713         endBlockNumber = startBlockNumber + ((31 * 24 * 3600) / 18); // 31 days
714         state = State.Fundraising;
715     }
716 
717     function changeReserveTeamRecipient(address _reserveTeamRecipient) onlyController {
718         reserveTeamRecipient = _reserveTeamRecipient;
719     }
720 
721     function changeReserveBountyRecipient(address _reserveBountyRecipient) onlyController {
722         reserveBountyRecipient = _reserveBountyRecipient;
723     }
724 
725     function changeDevelopersRecipient(address _developersRecipient) onlyController {
726         developersRecipient = _developersRecipient;
727     }
728 
729     function changeMarketingRecipient(address _marketingRecipient) onlyController {
730         marketingRecipient = _marketingRecipient;
731     }
732 
733     function addInvestor(address target, uint share) onlyController {
734         if (fiatInvestorShare[target] == uint(0x0)) { // new address
735             fiatInvestorShare[target] = share;
736             fiatInvestors.push(target);
737         } else { // address already exists
738             if (share > 0) {
739                 uint prevShare = fiatInvestorShare[target];
740                 uint newShare = prevShare + share;
741 
742                 fiatInvestorShare[target] = newShare;
743             }
744         }
745     }
746 
747     function freezeAccount(address target, bool freeze) onlyController {
748         frozenAccount[target] = freeze;
749         FrozenFunds(target, freeze);
750     }
751 
752     function updateExchangeRate () {
753         if (tokensIssued >= (1000000 * 10 ** 9) && tokensIssued < (2000000 * 10 ** 9)) {
754             tokenExchangeRate = 600 * 10 ** 9;
755         }
756         if (tokensIssued >= (2000000 * 10 ** 9) && tokensIssued < (3500000 * 10 ** 9)) {
757             tokenExchangeRate = 500 * 10 ** 9;
758         }
759         if (tokensIssued >= (3500000 * 10 ** 9) && tokensIssued < (6000000 * 10 ** 9)) {
760             tokenExchangeRate = 400 * 10 ** 9;
761         }
762         if (tokensIssued >= (6000000 * 10 ** 9)) {
763             tokenExchangeRate = 300 * 10 ** 9;
764         }
765     }
766 
767     function getExchangeRate(uint amount) public constant returns (uint) {
768         return tokenExchangeRate * amount / 1 ether;
769     }
770 
771     function investment() public inState(State.Fundraising) accountNotFrozen minInvestment payable returns (uint)  {
772         uint amount = msg.value;
773         if (amount == 0) throw;
774 
775         balanceOf[msg.sender] += amount;
776         currentBalance += amount;
777 
778         updateExchangeRate();
779         uint tokenAmount = getExchangeRate(amount);
780         exchangeToken.generateTokens(msg.sender, tokenAmount);
781         tokensIssued += tokenAmount;
782         updateExchangeRate();
783 
784         FundTransfer(msg.sender, amount, true);
785         LogFundingReceived(msg.sender, tokenAmount, tokensIssued);
786 
787         checkIfFundingCompleteOrExpired();
788 
789         return balanceOf[msg.sender];
790     }
791 
792     function checkIfFundingCompleteOrExpired() {
793         if (block.number > endBlockNumber || tokensIssued >= capTokenAmount) {
794             if (currentBalance >= minFundingGoal) {
795                 state = State.Successful;
796                 payOut();
797 
798                 GoalReached(fundRecipient, currentBalance);
799             }
800             else {
801                 state = State.ExpiredRefund;
802                 // backers can now collect refunds by calling getRefund()
803             }
804         }
805     }
806 
807     function payOut() public inState(State.Successful) onlyController() {
808         var amount = currentBalance;
809         var balance = currentBalance;
810 
811         currentBalance = 0;
812         state = State.Closed;
813 
814         for (uint i = 0; i < fiatInvestors.length; i++) {
815             address investorAddress = fiatInvestors[i];
816             uint investorShare = fiatInvestorShare[investorAddress];
817             uint investorAmount = div(mul(balance, investorShare), 1000000);
818             investorAddress.transfer(investorAmount);
819             amount -= investorAmount;
820         }
821 
822         uint percentDevelopers = 5;
823         uint percentMarketing = 5;
824         uint amountDevelopers = div(mul(balance, percentDevelopers), 100);
825         uint amountMarketing = div(mul(balance, percentMarketing), 100);
826 
827         developersRecipient.transfer(amountDevelopers);
828         marketingRecipient.transfer(amountMarketing);
829 
830         amount -= (amountDevelopers + amountMarketing);
831 
832         fundRecipient.transfer(amount);
833 
834         generateReserve();
835 
836         exchangeToken.enableTransfers(true);
837         exchangeToken.changeReserveTeamRecepient(reserveTeamRecipient);
838         exchangeToken.changeController(controller);
839     }
840 
841     function getRefund() public inState(State.ExpiredRefund) {
842         uint amountToRefund = balanceOf[msg.sender];
843         balanceOf[msg.sender] = 0;
844 
845         msg.sender.transfer(amountToRefund);
846         currentBalance -= amountToRefund;
847 
848         FundTransfer(msg.sender, amountToRefund, false);
849     }
850 
851     function generateReserve() {
852         if (isReserveGenerated) {
853             throw;
854         }
855         else {
856             uint issued = tokensIssued;
857             uint percentTeam = 15;
858             uint percentBounty = 1;
859             uint reserveAmountTeam = div(mul(issued, percentTeam), 85);
860             uint reserveAmountBounty = div(mul(issued, percentBounty), 99);
861             exchangeToken.generateTokens(reserveTeamRecipient, reserveAmountTeam);
862             exchangeToken.generateTokens(reserveBountyRecipient, reserveAmountBounty);
863             isReserveGenerated = true;
864         }
865     }
866 
867     function removeContract() public atEndOfFundraising onlyController() {
868         if (state != State.Closed) {
869             exchangeToken.changeController(controller);
870         }
871         selfdestruct(msg.sender);
872     }
873 
874     /* default */
875     function() inState(State.Fundraising) accountNotFrozen payable {
876         investment();
877     }
878 
879 }