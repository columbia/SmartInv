1 /* Verified by 3esmit
2  
3 - Bytecode Verification performed was compared on second iteration -
4 
5 This file is part of the HONG.
6 
7 The HONG is free software: you can redistribute it and/or modify
8 it under the terms of the GNU lesser General Public License as published by
9 the Free Software Foundation, either version 3 of the License, or
10 (at your option) any later version.
11 
12 The HONG is distributed in the hope that it will be useful,
13 but WITHOUT ANY WARRANTY; without even the implied warranty of
14 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15 GNU lesser General Public License for more details.
16 
17 You should have received a copy of the GNU lesser General Public License
18 along with the HONG.  If not, see <http://www.gnu.org/licenses/>.
19 */
20 
21 /*
22  * Parent contract that contains all of the configurable parameters of the main contract.
23  */
24 contract HongConfiguration {
25     uint public closingTime;
26     uint public weiPerInitialHONG = 10**16;
27     string public name = "HONG";
28     string public symbol = "Ħ";
29     uint8 public decimals = 0;
30     uint public maxBountyTokens = 2 * (10**6);
31     uint public closingTimeExtensionPeriod = 30 days;
32     uint public minTokensToCreate = 100 * (10**6);
33     uint public maxTokensToCreate = 250 * (10**6);
34     uint public tokensPerTier = 50 * (10**6);
35     uint public lastKickoffDateBuffer = 304 days;
36 
37     uint public mgmtRewardPercentage = 20;
38     uint public mgmtFeePercentage = 8;
39 
40     uint public harvestQuorumPercent = 20;
41     uint public freezeQuorumPercent = 50;
42     uint public kickoffQuorumPercent = 20;
43 }
44 
45 contract ErrorHandler {
46     bool public isInTestMode = false;
47     event evRecord(address msg_sender, uint msg_value, string message);
48     function doThrow(string message) internal {
49         evRecord(msg.sender, msg.value, message);
50         if(!isInTestMode){
51             throw;
52         }
53     }
54 }
55 
56 contract TokenInterface is ErrorHandler {
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     uint256 public tokensCreated;
60 
61     function balanceOf(address _owner) constant returns (uint256 balance);
62     function transfer(address _to, uint256 _amount) returns (bool success);
63 
64     event evTransfer(address msg_sender, uint msg_value, address indexed _from, address indexed _to, uint256 _amount);
65 
66     // Modifier that allows only token holders to trigger
67     modifier onlyTokenHolders {
68         if (balanceOf(msg.sender) == 0) doThrow("onlyTokenHolders"); else {_}
69     }
70 }
71 
72 contract Token is TokenInterface {
73     // Protects users by preventing the execution of method calls that
74     // inadvertently also transferred ether
75     modifier noEther() {if (msg.value > 0) doThrow("noEther"); else{_}}
76     modifier hasEther() {if (msg.value <= 0) doThrow("hasEther"); else{_}}
77 
78     function balanceOf(address _owner) constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function transfer(address _to, uint256 _amount) noEther returns (bool success) {
83         if (_amount <= 0) return false;
84         if (balances[msg.sender] < _amount) return false;
85         if (balances[_to] + _amount < balances[_to]) return false;
86 
87         balances[msg.sender] -= _amount;
88         balances[_to] += _amount;
89 
90         evTransfer(msg.sender, msg.value, msg.sender, _to, _amount);
91 
92         return true;
93     }
94 }
95 
96 
97 contract OwnedAccount is ErrorHandler {
98     address public owner;
99     bool acceptDeposits = true;
100 
101     event evPayOut(address msg_sender, uint msg_value, address indexed _recipient, uint _amount);
102 
103     modifier onlyOwner() {
104         if (msg.sender != owner) doThrow("onlyOwner");
105         else {_}
106     }
107 
108     modifier noEther() {
109         if (msg.value > 0) doThrow("noEther");
110         else {_}
111     }
112 
113     function OwnedAccount(address _owner) {
114         owner = _owner;
115     }
116 
117     function payOutPercentage(address _recipient, uint _percent) internal onlyOwner noEther {
118         payOutAmount(_recipient, (this.balance * _percent) / 100);
119     }
120 
121     function payOutAmount(address _recipient, uint _amount) internal onlyOwner noEther {
122         // send does not forward enough gas to see that this is a managed account call
123         if (!_recipient.call.value(_amount)())
124             doThrow("payOut:sendFailed");
125         else
126             evPayOut(msg.sender, msg.value, _recipient, _amount);
127     }
128 
129     function () returns (bool success) {
130         if (!acceptDeposits) throw;
131         return true;
132     }
133 }
134 
135 contract ReturnWallet is OwnedAccount {
136     address public mgmtBodyWalletAddress;
137 
138     bool public inDistributionMode;
139     uint public amountToDistribute;
140     uint public totalTokens;
141     uint public weiPerToken;
142 
143     function ReturnWallet(address _mgmtBodyWalletAddress) OwnedAccount(msg.sender) {
144         mgmtBodyWalletAddress = _mgmtBodyWalletAddress;
145     }
146 
147     function payManagementBodyPercent(uint _percent) {
148         payOutPercentage(mgmtBodyWalletAddress, _percent);
149     }
150 
151     function switchToDistributionMode(uint _totalTokens) onlyOwner {
152         inDistributionMode = true;
153         acceptDeposits = false;
154         totalTokens = _totalTokens;
155         amountToDistribute = this.balance;
156         weiPerToken = amountToDistribute / totalTokens;
157     }
158 
159     function payTokenHolderBasedOnTokenCount(address _tokenHolderAddress, uint _tokens) onlyOwner {
160         payOutAmount(_tokenHolderAddress, weiPerToken * _tokens);
161     }
162 }
163 
164 contract ExtraBalanceWallet is OwnedAccount {
165     address returnWalletAddress;
166     function ExtraBalanceWallet(address _returnWalletAddress) OwnedAccount(msg.sender) {
167         returnWalletAddress = _returnWalletAddress;
168     }
169 
170     function returnBalanceToMainAccount() {
171         acceptDeposits = false;
172         payOutAmount(owner, this.balance);
173     }
174 
175     function returnAmountToMainAccount(uint _amount) {
176         payOutAmount(owner, _amount);
177     }
178 
179     function payBalanceToReturnWallet() {
180         acceptDeposits = false;
181         payOutAmount(returnWalletAddress, this.balance);
182     }
183 
184 }
185 
186 contract RewardWallet is OwnedAccount {
187     address public returnWalletAddress;
188     function RewardWallet(address _returnWalletAddress) OwnedAccount(msg.sender) {
189         returnWalletAddress = _returnWalletAddress;
190     }
191 
192     function payBalanceToReturnWallet() {
193         acceptDeposits = false;
194         payOutAmount(returnWalletAddress, this.balance);
195     }
196 }
197 
198 contract ManagementFeeWallet is OwnedAccount {
199     address public mgmtBodyAddress;
200     address public returnWalletAddress;
201     function ManagementFeeWallet(address _mgmtBodyAddress, address _returnWalletAddress) OwnedAccount(msg.sender) {
202         mgmtBodyAddress = _mgmtBodyAddress;
203         returnWalletAddress  = _returnWalletAddress;
204     }
205 
206     function payManagementBodyAmount(uint _amount) {
207         payOutAmount(mgmtBodyAddress, _amount);
208     }
209 
210     function payBalanceToReturnWallet() {
211         acceptDeposits = false;
212         payOutAmount(returnWalletAddress, this.balance);
213     }
214 }
215 
216 /*
217  * Token Creation contract, similar to other organization,for issuing tokens and initialize
218  * its ether fund.
219 */
220 contract TokenCreationInterface is HongConfiguration {
221 
222     address public managementBodyAddress;
223 
224     ExtraBalanceWallet public extraBalanceWallet;
225     mapping (address => uint256) weiGiven;
226     mapping (address => uint256) public taxPaid;
227 
228     function createTokenProxy(address _tokenHolder) internal returns (bool success);
229     function refundMyIcoInvestment();
230     function divisor() constant returns (uint divisor);
231 
232     event evMinTokensReached(address msg_sender, uint msg_value, uint value);
233     event evCreatedToken(address msg_sender, uint msg_value, address indexed to, uint amount);
234     event evRefund(address msg_sender, uint msg_value, address indexed to, uint value, bool result);
235 }
236 
237 contract GovernanceInterface is ErrorHandler, HongConfiguration {
238 
239     // The variable indicating whether the fund has achieved the inital goal or not.
240     // This value is automatically set, and CANNOT be reversed.
241     bool public isFundLocked;
242     bool public isFundReleased;
243 
244     modifier notLocked() {if (isFundLocked) doThrow("notLocked"); else {_}}
245     modifier onlyLocked() {if (!isFundLocked) doThrow("onlyLocked"); else {_}}
246     modifier notReleased() {if (isFundReleased) doThrow("notReleased"); else {_}}
247     modifier onlyHarvestEnabled() {if (!isHarvestEnabled) doThrow("onlyHarvestEnabled"); else {_}}
248     modifier onlyDistributionNotInProgress() {if (isDistributionInProgress) doThrow("onlyDistributionNotInProgress"); else {_}}
249     modifier onlyDistributionNotReady() {if (isDistributionReady) doThrow("onlyDistributionNotReady"); else {_}}
250     modifier onlyDistributionReady() {if (!isDistributionReady) doThrow("onlyDistributionReady"); else {_}}
251     modifier onlyCanIssueBountyToken(uint _amount) {
252         if (bountyTokensCreated + _amount > maxBountyTokens){
253             doThrow("hitMaxBounty");
254         }
255         else {_}
256     }
257     modifier onlyFinalFiscalYear() {
258         // Only call harvest() in the final fiscal year
259         if (currentFiscalYear < 4) doThrow("currentFiscalYear<4"); else {_}
260     }
261     modifier notFinalFiscalYear() {
262         // Token holders cannot freeze fund at the 4th Fiscal Year after passing `kickoff(4)` voting
263         if (currentFiscalYear >= 4) doThrow("currentFiscalYear>=4"); else {_}
264     }
265     modifier onlyNotFrozen() {
266         if (isFreezeEnabled) doThrow("onlyNotFrozen"); else {_}
267     }
268 
269     bool public isDayThirtyChecked;
270     bool public isDaySixtyChecked;
271 
272     uint256 public bountyTokensCreated;
273     uint public currentFiscalYear;
274     uint public lastKickoffDate;
275     mapping (uint => bool) public isKickoffEnabled;
276     bool public isFreezeEnabled;
277     bool public isHarvestEnabled;
278     bool public isDistributionInProgress;
279     bool public isDistributionReady;
280 
281     ReturnWallet public returnWallet;
282     RewardWallet public rewardWallet;
283     ManagementFeeWallet public managementFeeWallet;
284 
285     // define the governance of this organization and critical functions
286     function mgmtIssueBountyToken(address _recipientAddress, uint _amount) returns (bool);
287     function mgmtDistribute();
288 
289     function mgmtInvestProject(
290         address _projectWallet,
291         uint _amount
292     ) returns (bool);
293 
294     event evIssueManagementFee(address msg_sender, uint msg_value, uint _amount, bool _success);
295     event evMgmtIssueBountyToken(address msg_sender, uint msg_value, address _recipientAddress, uint _amount, bool _success);
296     event evMgmtDistributed(address msg_sender, uint msg_value, uint256 _amount, bool _success);
297     event evMgmtInvestProject(address msg_sender, uint msg_value, address _projectWallet, uint _amount, bool result);
298     event evLockFund(address msg_sender, uint msg_value);
299     event evReleaseFund(address msg_sender, uint msg_value);
300 }
301 
302 
303 contract TokenCreation is TokenCreationInterface, Token, GovernanceInterface {
304     modifier onlyManagementBody {
305         if(msg.sender != address(managementBodyAddress)) {doThrow("onlyManagementBody");} else {_}
306     }
307 
308     function TokenCreation(
309         address _managementBodyAddress,
310         uint _closingTime) {
311 
312         managementBodyAddress = _managementBodyAddress;
313         closingTime = _closingTime;
314     }
315 
316     function createTokenProxy(address _tokenHolder) internal notLocked notReleased hasEther returns (bool success) {
317 
318         // Business logic (but no state changes)
319         // setup transaction details
320         uint tokensSupplied = 0;
321         uint weiAccepted = 0;
322         bool wasMinTokensReached = isMinTokensReached();
323 
324         var weiPerLatestHONG = weiPerInitialHONG * divisor() / 100;
325         uint remainingWei = msg.value;
326         uint tokensAvailable = tokensAvailableAtCurrentTier();
327         if (tokensAvailable == 0) {
328             doThrow("noTokensToSell");
329             return false;
330         }
331 
332         // Sell tokens in batches based on the current price.
333         while (remainingWei >= weiPerLatestHONG) {
334             uint tokensRequested = remainingWei / weiPerLatestHONG;
335             uint tokensToSellInBatch = min(tokensAvailable, tokensRequested);
336 
337             // special case.  Allow the last purchase to go over the max
338             if (tokensAvailable == 0 && tokensCreated == maxTokensToCreate) {
339                 tokensToSellInBatch = tokensRequested;
340             }
341 
342             uint priceForBatch = tokensToSellInBatch * weiPerLatestHONG;
343 
344             // track to total wei accepted and total tokens supplied
345             weiAccepted += priceForBatch;
346             tokensSupplied += tokensToSellInBatch;
347 
348             // update state
349             balances[_tokenHolder] += tokensToSellInBatch;
350             tokensCreated += tokensToSellInBatch;
351             weiGiven[_tokenHolder] += priceForBatch;
352 
353             // update dependent values (state has changed)
354             weiPerLatestHONG = weiPerInitialHONG * divisor() / 100;
355             remainingWei = msg.value - weiAccepted;
356             tokensAvailable = tokensAvailableAtCurrentTier();
357         }
358 
359         // the caller will still pay this amount, even though it didn't buy any tokens.
360         weiGiven[_tokenHolder] += remainingWei;
361 
362         // when the caller is paying more than 10**16 wei (0.01 Ether) per token, the extra is basically a tax.
363         uint256 totalTaxLevied = weiAccepted - tokensSupplied * weiPerInitialHONG;
364         taxPaid[_tokenHolder] += totalTaxLevied;
365 
366         // State Changes (no external calls)
367         tryToLockFund();
368 
369         // External calls
370         if (totalTaxLevied > 0) {
371             if (!extraBalanceWallet.send(totalTaxLevied)){
372                 doThrow("extraBalance:sendFail");
373                 return;
374             }
375         }
376 
377         // Events.  Safe to publish these now that we know it all worked
378         evCreatedToken(msg.sender, msg.value, _tokenHolder, tokensSupplied);
379         if (!wasMinTokensReached && isMinTokensReached()) evMinTokensReached(msg.sender, msg.value, tokensCreated);
380         if (isFundLocked) evLockFund(msg.sender, msg.value);
381         if (isFundReleased) evReleaseFund(msg.sender, msg.value);
382         return true;
383     }
384 
385     function refundMyIcoInvestment() noEther notLocked onlyTokenHolders {
386         // 1: Preconditions
387         if (weiGiven[msg.sender] == 0) {
388             doThrow("noWeiGiven");
389             return;
390         }
391         if (balances[msg.sender] > tokensCreated) {
392             doThrow("invalidTokenCount");
393             return;
394          }
395 
396         // 2: Business logic
397         bool wasMinTokensReached = isMinTokensReached();
398         var tmpWeiGiven = weiGiven[msg.sender];
399         var tmpTaxPaidBySender = taxPaid[msg.sender];
400         var tmpSenderBalance = balances[msg.sender];
401 
402         var amountToRefund = tmpWeiGiven;
403 
404         // 3: state changes.
405         balances[msg.sender] = 0;
406         weiGiven[msg.sender] = 0;
407         taxPaid[msg.sender] = 0;
408         tokensCreated -= tmpSenderBalance;
409 
410         // 4: external calls
411         // Pull taxes paid back into this contract (they would have been paid into the extraBalance account)
412         extraBalanceWallet.returnAmountToMainAccount(tmpTaxPaidBySender);
413 
414         // If that works, then do a refund
415         if (!msg.sender.send(amountToRefund)) {
416             evRefund(msg.sender, msg.value, msg.sender, amountToRefund, false);
417             doThrow("refund:SendFailed");
418             return;
419         }
420 
421         evRefund(msg.sender, msg.value, msg.sender, amountToRefund, true);
422         if (!wasMinTokensReached && isMinTokensReached()) evMinTokensReached(msg.sender, msg.value, tokensCreated);
423     }
424 
425     // Using a function rather than a state variable, as it reduces the risk of inconsistent state
426     function isMinTokensReached() constant returns (bool) {
427         return tokensCreated >= minTokensToCreate;
428     }
429 
430     function isMaxTokensReached() constant returns (bool) {
431         return tokensCreated >= maxTokensToCreate;
432     }
433 
434     function mgmtIssueBountyToken(
435         address _recipientAddress,
436         uint _amount
437     ) noEther onlyManagementBody onlyCanIssueBountyToken(_amount) returns (bool){
438         // send token to the specified address
439         balances[_recipientAddress] += _amount;
440         bountyTokensCreated += _amount;
441 
442         // event
443         evMgmtIssueBountyToken(msg.sender, msg.value, _recipientAddress, _amount, true);
444 
445     }
446 
447     function mgmtDistribute() onlyManagementBody hasEther onlyHarvestEnabled onlyDistributionNotReady {
448         distributeDownstream(mgmtRewardPercentage);
449     }
450 
451     function distributeDownstream(uint _mgmtPercentage) internal onlyDistributionNotInProgress {
452 
453         // transfer all balance from the following accounts
454         // (1) HONG main account,
455         // (2) managementFeeWallet,
456         // (3) rewardWallet
457         // (4) extraBalanceWallet
458         // to returnWallet
459 
460         // And allocate _mgmtPercentage of the fund to ManagementBody
461 
462         // State changes first (even though it feels backwards)
463         isDistributionInProgress = true;
464         isDistributionReady = true;
465 
466         payBalanceToReturnWallet();
467         managementFeeWallet.payBalanceToReturnWallet();
468         rewardWallet.payBalanceToReturnWallet();
469         extraBalanceWallet.payBalanceToReturnWallet();
470 
471         // transfer _mgmtPercentage of returns to mgmt Wallet
472         if (_mgmtPercentage > 0) returnWallet.payManagementBodyPercent(_mgmtPercentage);
473         returnWallet.switchToDistributionMode(tokensCreated + bountyTokensCreated);
474 
475         // Token holder can claim the remaining fund (the total amount harvested/ to be distributed) starting from here
476         evMgmtDistributed(msg.sender, msg.value, returnWallet.balance, true);
477         isDistributionInProgress = false;
478     }
479 
480     function payBalanceToReturnWallet() internal {
481         if (!returnWallet.send(this.balance))
482             doThrow("payBalanceToReturnWallet:sendFailed");
483             return;
484     }
485 
486     function min(uint a, uint b) constant internal returns (uint) {
487         return (a < b) ? a : b;
488     }
489 
490     function tryToLockFund() internal {
491         // ICO Diagram: https://github.com/hongcoin/DO/wiki/ICO-Period-and-Target
492 
493         if (isFundReleased) {
494             // Do not change the state anymore
495             return;
496         }
497 
498         // Case A
499         isFundLocked = isMaxTokensReached();
500 
501         // if we've reached the 30 day mark, try to lock the fund
502         if (!isFundLocked && !isDayThirtyChecked && (now >= closingTime)) {
503             if (isMinTokensReached()) {
504                 // Case B
505                 isFundLocked = true;
506             }
507             isDayThirtyChecked = true;
508         }
509 
510         // if we've reached the 60 day mark, try to lock the fund
511         if (!isFundLocked && !isDaySixtyChecked && (now >= (closingTime + closingTimeExtensionPeriod))) {
512             if (isMinTokensReached()) {
513                 // Case C
514                 isFundLocked = true;
515             }
516             isDaySixtyChecked = true;
517         }
518 
519         if (isDaySixtyChecked && !isMinTokensReached()) {
520             // Case D
521             // Mark the release state. No fund should be accepted anymore
522             isFundReleased = true;
523         }
524     }
525 
526     function tokensAvailableAtTierInternal(uint8 _currentTier, uint _tokensPerTier, uint _tokensCreated) constant returns (uint) {
527         uint tierThreshold = (_currentTier+1) * _tokensPerTier;
528 
529         // never go above maxTokensToCreate, which could happen if the max is not a multiple of _tokensPerTier
530         if (tierThreshold > maxTokensToCreate) {
531             tierThreshold = maxTokensToCreate;
532         }
533 
534         // this can happen on the final purchase in the last tier
535         if (_tokensCreated > tierThreshold) {
536             return 0;
537         }
538 
539         return tierThreshold - _tokensCreated;
540     }
541 
542     function tokensAvailableAtCurrentTier() constant returns (uint) {
543         return tokensAvailableAtTierInternal(getCurrentTier(), tokensPerTier, tokensCreated);
544     }
545 
546     function getCurrentTier() constant returns (uint8) {
547         uint8 tier = (uint8) (tokensCreated / tokensPerTier);
548         return (tier > 4) ? 4 : tier;
549     }
550 
551     function pricePerTokenAtCurrentTier() constant returns (uint) {
552         return weiPerInitialHONG * divisor() / 100;
553     }
554 
555     function divisor() constant returns (uint divisor) {
556 
557         // Quantity divisor model: based on total quantity of coins issued
558         // Price ranged from 1.0 to 1.20 Ether for all HONG Tokens with a 0.05 ETH increase for each tier
559 
560         // The number of (base unit) tokens per wei is calculated
561         // as `msg.value` * 100 / `divisor`
562 
563         return 100 + getCurrentTier() * 5;
564     }
565 }
566 
567 
568 contract HONGInterface is ErrorHandler, HongConfiguration {
569 
570     // we do not have grace period. Once the goal is reached, the fund is secured
571 
572     address public managementBodyAddress;
573 
574     // 3 most important votings in blockchain
575     mapping (uint => mapping (address => uint)) public votedKickoff;
576     mapping (address => uint) public votedFreeze;
577     mapping (address => uint) public votedHarvest;
578     mapping (uint => uint256) public supportKickoffQuorum;
579     uint256 public supportFreezeQuorum;
580     uint256 public supportHarvestQuorum;
581     uint public totalInitialBalance;
582     uint public annualManagementFee;
583 
584     function voteToKickoffNewFiscalYear();
585     function voteToFreezeFund();
586     function recallVoteToFreezeFund();
587     function voteToHarvestFund();
588 
589     function collectMyReturn();
590 
591     // Trigger the following events when the voting result is available
592     event evKickoff(address msg_sender, uint msg_value, uint _fiscal);
593     event evFreeze(address msg_sender, uint msg_value);
594     event evHarvest(address msg_sender, uint msg_value);
595 }
596 
597 
598 
599 // The HONG contract itself
600 contract HONG is HONGInterface, Token, TokenCreation {
601 
602     function HONG(
603         address _managementBodyAddress,
604         uint _closingTime,
605         uint _closingTimeExtensionPeriod,
606         uint _lastKickoffDateBuffer,
607         uint _minTokensToCreate,
608         uint _maxTokensToCreate,
609         uint _tokensPerTier,
610         bool _isInTestMode
611     ) TokenCreation(_managementBodyAddress, _closingTime) {
612 
613         managementBodyAddress = _managementBodyAddress;
614         closingTimeExtensionPeriod = _closingTimeExtensionPeriod;
615         lastKickoffDateBuffer = _lastKickoffDateBuffer;
616 
617         minTokensToCreate = _minTokensToCreate;
618         maxTokensToCreate = _maxTokensToCreate;
619         tokensPerTier = _tokensPerTier;
620         isInTestMode = _isInTestMode;
621 
622         returnWallet = new ReturnWallet(managementBodyAddress);
623         rewardWallet = new RewardWallet(address(returnWallet));
624         managementFeeWallet = new ManagementFeeWallet(managementBodyAddress, address(returnWallet));
625         extraBalanceWallet = new ExtraBalanceWallet(address(returnWallet));
626 
627         if (address(extraBalanceWallet) == 0)
628             doThrow("extraBalanceWallet:0");
629         if (address(returnWallet) == 0)
630             doThrow("returnWallet:0");
631         if (address(rewardWallet) == 0)
632             doThrow("rewardWallet:0");
633         if (address(managementFeeWallet) == 0)
634             doThrow("managementFeeWallet:0");
635     }
636 
637     function () returns (bool success) {
638         if (!isFromManagedAccount()) {
639             // We do not accept donation here. Any extra amount sent to us after fund locking process, will be refunded
640             return createTokenProxy(msg.sender);
641         }
642         else {
643             evRecord(msg.sender, msg.value, "Recevied ether from ManagedAccount");
644             return true;
645         }
646     }
647 
648     function isFromManagedAccount() internal returns (bool) {
649         return msg.sender == address(extraBalanceWallet)
650             || msg.sender == address(returnWallet)
651             || msg.sender == address(rewardWallet)
652             || msg.sender == address(managementFeeWallet);
653     }
654 
655     /*
656      * Voting for some critical steps, on blockchain
657      */
658     function voteToKickoffNewFiscalYear() onlyTokenHolders noEther onlyLocked {
659         // this is the only valid fiscal year parameter, so there's no point in letting the caller pass it in.
660         // Best case is they get it wrong and we throw, worst case is the get it wrong and there's some exploit
661         uint _fiscal = currentFiscalYear + 1;
662 
663         if(!isKickoffEnabled[1]){  // if the first fiscal year is not kicked off yet
664             // accept voting
665 
666         }else if(currentFiscalYear <= 3){  // if there was any kickoff() enabled before already
667 
668             if(lastKickoffDate + lastKickoffDateBuffer < now){ // 2 months from the end of the fiscal year
669                 // accept voting
670             }else{
671                 // we do not accept early kickoff
672                 doThrow("kickOff:tooEarly");
673                 return;
674             }
675         }else{
676             // do not accept kickoff anymore after the 4th year
677             doThrow("kickOff:4thYear");
678             return;
679         }
680 
681 
682         supportKickoffQuorum[_fiscal] -= votedKickoff[_fiscal][msg.sender];
683         supportKickoffQuorum[_fiscal] += balances[msg.sender];
684         votedKickoff[_fiscal][msg.sender] = balances[msg.sender];
685 
686 
687         uint threshold = (kickoffQuorumPercent*(tokensCreated + bountyTokensCreated)) / 100;
688         if(supportKickoffQuorum[_fiscal] > threshold) {
689             if(_fiscal == 1){
690                 // transfer fund in extraBalance to main account
691                 extraBalanceWallet.returnBalanceToMainAccount();
692 
693                 // reserve mgmtFeePercentage of whole fund to ManagementFeePoolWallet
694                 totalInitialBalance = this.balance;
695                 uint fundToReserve = (totalInitialBalance * mgmtFeePercentage) / 100;
696                 annualManagementFee = fundToReserve / 4;
697                 if(!managementFeeWallet.send(fundToReserve)){
698                     doThrow("kickoff:ManagementFeePoolWalletFail");
699                     return;
700                 }
701 
702             }
703             isKickoffEnabled[_fiscal] = true;
704             currentFiscalYear = _fiscal;
705             lastKickoffDate = now;
706 
707             // transfer annual management fee from reservedWallet to mgmtWallet (external)
708             managementFeeWallet.payManagementBodyAmount(annualManagementFee);
709 
710             evKickoff(msg.sender, msg.value, _fiscal);
711             evIssueManagementFee(msg.sender, msg.value, annualManagementFee, true);
712         }
713     }
714 
715     function voteToFreezeFund() onlyTokenHolders noEther onlyLocked notFinalFiscalYear onlyDistributionNotInProgress {
716 
717         supportFreezeQuorum -= votedFreeze[msg.sender];
718         supportFreezeQuorum += balances[msg.sender];
719         votedFreeze[msg.sender] = balances[msg.sender];
720 
721         uint threshold = ((tokensCreated + bountyTokensCreated) * freezeQuorumPercent) / 100;
722         if(supportFreezeQuorum > threshold){
723             isFreezeEnabled = true;
724             distributeDownstream(0);
725             evFreeze(msg.sender, msg.value);
726         }
727     }
728 
729     function recallVoteToFreezeFund() onlyTokenHolders onlyNotFrozen noEther {
730         supportFreezeQuorum -= votedFreeze[msg.sender];
731         votedFreeze[msg.sender] = 0;
732     }
733 
734     function voteToHarvestFund() onlyTokenHolders noEther onlyLocked onlyFinalFiscalYear {
735 
736         supportHarvestQuorum -= votedHarvest[msg.sender];
737         supportHarvestQuorum += balances[msg.sender];
738         votedHarvest[msg.sender] = balances[msg.sender];
739 
740         uint threshold = ((tokensCreated + bountyTokensCreated) * harvestQuorumPercent) / 100;
741         if(supportHarvestQuorum > threshold) {
742             isHarvestEnabled = true;
743             evHarvest(msg.sender, msg.value);
744         }
745     }
746 
747     function collectMyReturn() onlyTokenHolders noEther onlyDistributionReady {
748         uint tokens = balances[msg.sender];
749         balances[msg.sender] = 0;
750         returnWallet.payTokenHolderBasedOnTokenCount(msg.sender, tokens);
751     }
752 
753     function mgmtInvestProject(
754         address _projectWallet,
755         uint _amount
756     ) onlyManagementBody hasEther returns (bool _success) {
757 
758         if(!isKickoffEnabled[currentFiscalYear] || isFreezeEnabled || isHarvestEnabled){
759             evMgmtInvestProject(msg.sender, msg.value, _projectWallet, _amount, false);
760             return;
761         }
762 
763         if(_amount >= this.balance){
764             doThrow("failed:mgmtInvestProject: amount >= actualBalance");
765             return;
766         }
767 
768         // send the balance (_amount) to _projectWallet
769         if (!_projectWallet.call.value(_amount)()) {
770             doThrow("failed:mgmtInvestProject: cannot send to _projectWallet");
771             return;
772         }
773 
774         evMgmtInvestProject(msg.sender, msg.value, _projectWallet, _amount, true);
775     }
776 
777     function transfer(address _to, uint256 _value) returns (bool success) {
778 
779         // Update kickoff voting record for the next fiscal year for an address, and the total quorum
780         if(currentFiscalYear < 4){
781             if(votedKickoff[currentFiscalYear+1][msg.sender] > _value){
782                 votedKickoff[currentFiscalYear+1][msg.sender] -= _value;
783                 supportKickoffQuorum[currentFiscalYear+1] -= _value;
784             }else{
785                 supportKickoffQuorum[currentFiscalYear+1] -= votedKickoff[currentFiscalYear+1][msg.sender];
786                 votedKickoff[currentFiscalYear+1][msg.sender] = 0;
787             }
788         }
789 
790         // Update Freeze and Harvest voting records for an address, and the total quorum
791         if(votedFreeze[msg.sender] > _value){
792             votedFreeze[msg.sender] -= _value;
793             supportFreezeQuorum -= _value;
794         }else{
795             supportFreezeQuorum -= votedFreeze[msg.sender];
796             votedFreeze[msg.sender] = 0;
797         }
798 
799         if(votedHarvest[msg.sender] > _value){
800             votedHarvest[msg.sender] -= _value;
801             supportHarvestQuorum -= _value;
802         }else{
803             supportHarvestQuorum -= votedHarvest[msg.sender];
804             votedHarvest[msg.sender] = 0;
805         }
806 
807         if (isFundLocked && super.transfer(_to, _value)) {
808             return true;
809         } else {
810             if(!isFundLocked){
811                 doThrow("failed:transfer: isFundLocked is false");
812             }else{
813                 doThrow("failed:transfer: cannot send send to _projectWallet");
814             }
815             return;
816         }
817     }
818 }