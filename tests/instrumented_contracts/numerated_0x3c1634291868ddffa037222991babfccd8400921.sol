1 pragma solidity 0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     /**
31      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      */
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 
49 contract owned {
50     address public owner;
51 
52     function owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address newOwner) onlyOwner public {
62         owner = newOwner;
63     }
64 }
65 
66 
67 interface tokenRecipient {
68     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
69 }
70 
71 
72 contract ParsecTokenERC20 {
73     // Public variables of the token
74     string public constant name = "Parsec Credits";
75     string public constant symbol = "PRSC";
76     uint8 public decimals = 6;
77     uint256 public initialSupply = 30856775800;
78     uint256 public totalSupply;
79 
80     // This creates an array with all balances
81     mapping (address => uint256) public balanceOf;
82     mapping (address => mapping (address => uint256)) public allowance;
83 
84     // This generates a public event on the blockchain that will notify clients
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     // This notifies clients about the amount burnt
88     event Burn(address indexed from, uint256 value);
89 
90     /**
91      * Constrctor function
92      *
93      * Initializes contract with initial supply tokens to the creator of the contract
94      */
95     function ParsecTokenERC20() public {
96         // Update total supply with the decimal amount
97         totalSupply = initialSupply * 10 ** uint256(decimals);
98 
99         // Give the creator all initial tokens
100         balanceOf[msg.sender] = totalSupply;
101     }
102 
103     /**
104      * Internal transfer, only can be called by this contract
105      */
106     function _transfer(address _from, address _to, uint _value) internal {
107         // Prevent transfer to 0x0 address. Use burn() instead
108         require(_to != 0x0);
109 
110         // Check if the sender has enough
111         require(balanceOf[_from] >= _value);
112 
113         // Check for overflows
114         require(balanceOf[_to] + _value > balanceOf[_to]);
115 
116         // Save this for an assertion in the future
117         uint previousBalances = balanceOf[_from] + balanceOf[_to];
118 
119         // Subtract from the sender
120         balanceOf[_from] -= _value;
121 
122         // Add the same to the recipient
123         balanceOf[_to] += _value;
124         Transfer(_from, _to, _value);
125 
126         // Asserts are used to use static analysis to find bugs in your code. They should never fail
127         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
128     }
129 
130     /**
131      * Transfer tokens
132      *
133      * Send `_value` tokens to `_to` from your account
134      *
135      * @param _to The address of the recipient
136      * @param _value the amount to send
137      */
138     function transfer(address _to, uint256 _value) public {
139         _transfer(msg.sender, _to, _value);
140     }
141 
142     /**
143      * Transfer tokens from other address
144      *
145      * Send `_value` tokens to `_to` in behalf of `_from`
146      *
147      * @param _from The address of the sender
148      * @param _to The address of the recipient
149      * @param _value the amount to send
150      */
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
152         // Check allowance
153         require(_value <= allowance[_from][msg.sender]);
154 
155         allowance[_from][msg.sender] -= _value;
156         _transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161      * Set allowance for other address
162      *
163      * Allows `_spender` to spend no more than `_value` tokens in your behalf
164      *
165      * @param _spender The address authorized to spend
166      * @param _value the max amount they can spend
167      */
168     function approve(address _spender, uint256 _value) public returns (bool success) {
169         allowance[msg.sender][_spender] = _value;
170         return true;
171     }
172 
173     /**
174      * Set allowance for other address and notify
175      *
176      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
177      *
178      * @param _spender The address authorized to spend
179      * @param _value the max amount they can spend
180      * @param _extraData some extra information to send to the approved contract
181      */
182     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
183         tokenRecipient spender = tokenRecipient(_spender);
184 
185         if (approve(_spender, _value)) {
186             spender.receiveApproval(msg.sender, _value, this, _extraData);
187             return true;
188         }
189     }
190 
191     /**
192      * Destroy tokens
193      *
194      * Remove `_value` tokens from the system irreversibly
195      *
196      * @param _value the amount of money to burn
197      */
198     function burn(uint256 _value) public returns (bool success) {
199         // Check if the sender has enough
200         require(balanceOf[msg.sender] >= _value);
201 
202         // Subtract from the sender
203         balanceOf[msg.sender] -= _value;
204 
205         // Updates totalSupply
206         totalSupply -= _value;
207 
208         // Notify clients about burned tokens
209         Burn(msg.sender, _value);
210 
211         return true;
212     }
213 
214     /**
215      * Destroy tokens from other account
216      *
217      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
218      *
219      * @param _from the address of the sender
220      * @param _value the amount of money to burn
221      */
222     function burnFrom(address _from, uint256 _value) public returns (bool success) {
223         // Check if the targeted balance is enough
224         require(balanceOf[_from] >= _value);
225 
226         // Check allowance
227         require(_value <= allowance[_from][msg.sender]);
228 
229         // Subtract from the targeted balance
230         balanceOf[_from] -= _value;
231 
232         // Subtract from the sender's allowance
233         allowance[_from][msg.sender] -= _value;
234 
235         // Update totalSupply
236         totalSupply -= _value;
237 
238         // Notify clients about burned tokens
239         Burn(_from, _value);
240 
241         return true;
242     }
243 }
244 
245 
246 contract ParsecCrowdsale is owned {
247     /// @notice Use OpenZeppelin's SafeMath
248     using SafeMath for uint256;
249 
250     /// @notice Define KYC states
251     enum KycState {
252         Undefined,  // 0
253         Pending,    // 1
254         Accepted,   // 2
255         Declined    // 3
256     }
257 
258     // -------------------------
259     // --- General constants ---
260     // -------------------------
261 
262     /// @notice Minimum ETH amount per transaction
263     uint256 public constant MINIMUM_PARTICIPATION_AMOUNT = 0.1 ether;
264 
265     /// @notice Base rate of parsec credits per 1 ETH
266     uint256 public constant PARSECS_PER_ETHER_BASE = 1300000000000;      // 1,300,000.000000 PRSC
267 
268     /// @notice Crowdsale hard cap in Parsecs
269     uint256 public constant PARSECS_TOTAL_AMOUNT = 16103862002000000;    // 16,103,862,002.000000 PRSC
270 
271     // ----------------------------
272     // --- Bonus tier constants ---
273     // ----------------------------
274     
275     uint256 public constant BONUS_TIER_1_LIMIT = 715 ether;     // 30.0 % bonus Parsecs
276     uint256 public constant BONUS_TIER_2_LIMIT = 1443 ether;    // 27.5 % bonus Parsecs
277     uint256 public constant BONUS_TIER_3_LIMIT = 2434 ether;    // 25.0 % bonus Parsecs
278     uint256 public constant BONUS_TIER_4_LIMIT = 3446 ether;    // 22.5 % bonus Parsecs
279     uint256 public constant BONUS_TIER_5_LIMIT = 4478 ether;    // 20.0 % bonus Parsecs
280     uint256 public constant BONUS_TIER_6_LIMIT = 5532 ether;    // 17.5 % bonus Parsecs
281     uint256 public constant BONUS_TIER_7_LIMIT = 6609 ether;    // 15.0 % bonus Parsecs
282     uint256 public constant BONUS_TIER_8_LIMIT = 7735 ether;    // 10.0 % bonus Parsecs
283     uint256 public constant BONUS_TIER_9_LIMIT = 9210 ether;    // 5.00 % bonus Parsecs
284 
285     // ------------------------
286     // --- Input parameters ---
287     // ------------------------
288 
289     /// @notice Parsec ERC20 token address (from previously deployed contract)
290     ParsecTokenERC20 private parsecToken;
291 
292     // @notice Multisig account address to collect accepted ETH
293     address public multisigAddress;
294 
295     // @notice Auditor account address to perform KYC accepts and declines
296     address public auditorAddress;
297 
298     // ---------------------------
299     // --- Power-up parameters ---
300     // ---------------------------
301 
302     /// @notice Keep track if contract is powered up (has enough Parsecs)
303     bool public contractPoweredUp = false;
304 
305     /// @notice Keep track if contract has enough ETH to perform refunds
306     bool public refundPoweredUp = false;
307 
308     // ---------------------------
309     // --- State parameters ---
310     // ---------------------------
311 
312     /// @notice Keep track if contract is started (permanently, works if contract is powered up) 
313     bool public contractStarted = false;
314 
315     /// @notice Keep track if contract is finished (permanently, works if contract is started) 
316     bool public contractFinished = false;
317 
318     /// @notice Keep track if contract is paused (transiently, works if contract started and not finished) 
319     bool public contractPaused = false;
320 
321     /// @notice Keep track if contract is failed (permanently, works if contract started and not finished) 
322     bool public contractFailed = false;
323 
324     /// @notice Keep track if contract refund is started
325     bool public contractRefundStarted = false;
326 
327     /// @notice Keep track if contract refund is finished
328     bool public contractRefundFinished = false;
329 
330     // ------------------------
331     // --- Funding tracking ---
332     // ------------------------
333 
334     /// @notice Keep track of total amount of funding raised and passed KYC
335     uint256 public raisedFunding;
336        
337     /// @notice Keep track of funding amount pending KYC check
338     uint256 public pendingFunding;
339 
340     /// @notice Keep track of refunded funding
341     uint256 public refundedFunding;
342 
343     // ------------------------
344     // --- Parsecs tracking ---
345     // ------------------------
346 
347     /// @notice Keep track of spent Parsecs amount (transferred to participants)
348     uint256 public spentParsecs;
349     
350     /// @notice Keep track of pending Parsecs amount (participant pending KYC)
351     uint256 public pendingParsecs;
352 
353     // ----------------
354     // --- Balances ---
355     // ----------------
356 
357     /// @notice Keep track of all contributions per account passed KYC
358     mapping (address => uint256) public contributionOf;
359 
360     /// @notice Keep track of all Parsecs granted to participants after they passed KYC
361     mapping (address => uint256) public parsecsOf;
362 
363     /// @notice Keep track of all contributions pending KYC
364     mapping (address => uint256) public pendingContributionOf;
365 
366     /// @notice Keep track of all Parsecs' rewards pending KYC
367     mapping (address => uint256) public pendingParsecsOf;
368 
369     /// @notice Keep track of all refunds per account
370     mapping (address => uint256) public refundOf;
371 
372     // -----------------------------------------
373     // --- KYC (Know-Your-Customer) tracking ---
374     // -----------------------------------------
375 
376     /// @notice Keep track of participants' KYC status
377     mapping (address => KycState) public kycStatus;
378 
379     // --------------
380     // --- Events ---
381     // --------------
382 
383     /// @notice Log an event for each KYC accept
384     event LogKycAccept(address indexed sender, uint256 value, uint256 timestamp);
385 
386     /// @notice Log an event for each KYC decline
387     event LogKycDecline(address indexed sender, uint256 value, uint256 timestamp);
388 
389     /// @notice Log an event for each contributed amount passed KYC
390     event LogContribution(address indexed sender, uint256 ethValue, uint256 parsecValue, uint256 timestamp);
391 
392     /**
393      * Constructor function
394      *
395      * Initializes smart contract
396      *
397      * @param _tokenAddress The address of the previously deployed ParsecTokenERC20 contract
398      * @param _multisigAddress The address of the Multisig wallet to redirect payments to
399      * @param _auditorAddress The address of the Auditor account which will accept or decline investors' KYC
400      */
401     function ParsecCrowdsale (address _tokenAddress, address _multisigAddress, address _auditorAddress) public {
402         // Get Parsec ERC20 token instance
403         parsecToken = ParsecTokenERC20(_tokenAddress);
404 
405         // Store Multisig wallet and Auditor addresses
406         multisigAddress = _multisigAddress;
407         auditorAddress = _auditorAddress;
408     }
409 
410     /// @notice Allows only contract owner or Multisig to proceed
411     modifier onlyOwnerOrMultisig {
412         require(msg.sender == owner || msg.sender == multisigAddress);
413         _;
414     }
415 
416     /// @notice Allows only contract owner or Auditor to proceed
417     modifier onlyOwnerOrAuditor {
418         require(msg.sender == owner || msg.sender == auditorAddress);
419         _;
420     }
421 
422     /// @notice A participant sends a contribution to the contract's address
423     ///         when contract is active, not failed and not paused 
424     /// @notice Only contributions above the MINIMUM_PARTICIPATION_AMOUNT are
425     ///         accepted. Otherwise the transaction is rejected and contributed
426     ///         amount is returned to the participant's account
427     /// @notice A participant's contribution will be rejected if it exceeds
428     ///         the hard cap
429     /// @notice A participant's contribution will be rejected if the hard
430     ///         cap is reached
431     function () public payable {
432         // Contract should be powered up
433         require(contractPoweredUp);
434 
435         // Сontract should BE started
436         require(contractStarted);
437 
438         // Сontract should NOT BE finished
439         require(!contractFinished);
440 
441         // Сontract should NOT BE paused
442         require(!contractPaused);
443 
444         // Сontract should NOT BE failed
445         require(!contractFailed);
446 
447         // A participant cannot send less than the minimum amount
448         require(msg.value >= MINIMUM_PARTICIPATION_AMOUNT);
449 
450         // Calculate amount of Parsecs to reward
451         uint256 parsecValue = calculateReward(msg.value);
452 
453         // Calculate maximum amount of Parsecs smart contract can provide
454         uint256 maxAcceptableParsecs = PARSECS_TOTAL_AMOUNT.sub(spentParsecs);
455         maxAcceptableParsecs = maxAcceptableParsecs.sub(pendingParsecs);
456 
457         // A participant cannot receive more Parsecs than contract has to offer
458         require(parsecValue <= maxAcceptableParsecs);
459 
460         // Check if participant's KYC state is Undefined and set it to Pending
461         if (kycStatus[msg.sender] == KycState.Undefined) {
462             kycStatus[msg.sender] = KycState.Pending;
463         }
464 
465         if (kycStatus[msg.sender] == KycState.Pending) {
466             // KYC is Pending: register pending contribution
467             addPendingContribution(msg.sender, msg.value, parsecValue);
468         } else if (kycStatus[msg.sender] == KycState.Accepted) {
469             // KYC is Accepted: register accepted contribution
470             addAcceptedContribution(msg.sender, msg.value, parsecValue);
471         } else {
472             // KYC is Declined: revert transaction
473             revert();
474         }
475     }
476 
477     /// @notice Contract owner or Multisig can withdraw Parsecs anytime in case of emergency
478     function emergencyWithdrawParsecs(uint256 value) external onlyOwnerOrMultisig {
479         // Amount of Parsecs to withdraw should not exceed current balance
480         require(value > 0);
481         require(value <= parsecToken.balanceOf(this));
482 
483         // Transfer parsecs
484         parsecToken.transfer(msg.sender, value);
485     }
486 
487     /// @notice Contract owner or Multisig can refund contract with ETH in case of failed Crowdsale
488     function emergencyRefundContract() external payable onlyOwnerOrMultisig {
489         // Contract should be failed previously
490         require(contractFailed);
491         
492         // Amount of ETH should be positive
493         require(msg.value > 0);
494     }
495 
496     /// @notice Contract owner or Multisig can clawback ether after refund period is finished
497     function emergencyClawbackEther(uint256 value) external onlyOwnerOrMultisig {
498         // Contract should be failed previously
499         require(contractFailed);
500 
501         // Contract refund should be started and finished previously
502         require(contractRefundStarted);
503         require(contractRefundFinished);
504         
505         // Amount of ETH should be positive and not exceed current contract balance
506         require(value > 0);
507         require(value <= address(this).balance);
508 
509         // Transfer ETH to Multisig
510         msg.sender.transfer(value);
511     }
512 
513     /// @notice Set Auditor account address to a new value
514     function ownerSetAuditor(address _auditorAddress) external onlyOwner {
515         // Auditor address cannot be zero
516         require(_auditorAddress != 0x0);
517 
518         // Change Auditor account address
519         auditorAddress = _auditorAddress;
520     }
521 
522     /// @notice Check if contract has enough Parsecs to cover hard cap
523     function ownerPowerUpContract() external onlyOwner {
524         // Contract should not be powered up previously
525         require(!contractPoweredUp);
526 
527         // Contract should have enough Parsec credits
528         require(parsecToken.balanceOf(this) >= PARSECS_TOTAL_AMOUNT);
529 
530         // Raise contract power-up flag
531         contractPoweredUp = true;
532     }
533 
534     /// @notice Start contract (permanently)
535     function ownerStartContract() external onlyOwner {
536         // Contract should be powered up previously
537         require(contractPoweredUp);
538 
539         // Contract should not be started previously
540         require(!contractStarted);
541 
542         // Raise contract started flag
543         contractStarted = true;
544     }
545 
546     /// @notice Finish contract (permanently)
547     function ownerFinishContract() external onlyOwner {
548         // Contract should be started previously
549         require(contractStarted);
550 
551         // Contract should not be finished previously
552         require(!contractFinished);
553 
554         // Raise contract finished flag
555         contractFinished = true;
556     }
557 
558     /// @notice Pause contract (transiently)
559     function ownerPauseContract() external onlyOwner {
560         // Contract should be started previously
561         require(contractStarted);
562 
563         // Contract should not be finished previously
564         require(!contractFinished);
565 
566         // Contract should not be paused previously
567         require(!contractPaused);
568 
569         // Raise contract paused flag
570         contractPaused = true;
571     }
572 
573     /// @notice Resume contract (transiently)
574     function ownerResumeContract() external onlyOwner {
575         // Contract should be paused previously
576         require(contractPaused);
577 
578         // Unset contract paused flag
579         contractPaused = false;
580     }
581 
582     /// @notice Declare Crowdsale failure (no more ETH are accepted from participants)
583     function ownerDeclareFailure() external onlyOwner {
584         // Contract should NOT BE failed previously
585         require(!contractFailed);
586 
587         // Raise contract failed flag
588         contractFailed = true;
589     }
590 
591     /// @notice Declare Crowdsale refund start
592     function ownerDeclareRefundStart() external onlyOwner {
593         // Contract should BE failed previously
594         require(contractFailed);
595 
596         // Contract refund should NOT BE started previously
597         require(!contractRefundStarted);
598 
599         // Contract should NOT have any pending KYC requests
600         require(pendingFunding == 0x0);
601 
602         // Contract should have enough ETH to perform refunds
603         require(address(this).balance >= raisedFunding);
604 
605         // Raise contract refund started flag
606         contractRefundStarted = true;
607     }
608 
609     /// @notice Declare Crowdsale refund finish
610     function ownerDeclareRefundFinish() external onlyOwner {
611         // Contract should BE failed previously
612         require(contractFailed);
613 
614         // Contract refund should BE started previously
615         require(contractRefundStarted);
616 
617         // Contract refund should NOT BE finished previously
618         require(!contractRefundFinished);
619 
620         // Raise contract refund finished flag
621         contractRefundFinished = true;
622     }
623 
624     /// @notice Owner can withdraw Parsecs only after contract is finished
625     function ownerWithdrawParsecs(uint256 value) external onlyOwner {
626         // Contract should be finished before any Parsecs could be withdrawn
627         require(contractFinished);
628 
629         // Get smart contract balance in Parsecs
630         uint256 parsecBalance = parsecToken.balanceOf(this);
631 
632         // Calculate maximal amount to withdraw
633         uint256 maxAmountToWithdraw = parsecBalance.sub(pendingParsecs);
634 
635         // Maximal amount to withdraw should be greater than zero and not greater than total balance
636         require(maxAmountToWithdraw > 0);
637         require(maxAmountToWithdraw <= parsecBalance);
638 
639         // Amount of Parsecs to withdraw should not exceed maxAmountToWithdraw
640         require(value > 0);
641         require(value <= maxAmountToWithdraw);
642 
643         // Transfer parsecs
644         parsecToken.transfer(owner, value);
645     }
646  
647     /// @dev Accept participant's KYC
648     function acceptKyc(address participant) external onlyOwnerOrAuditor {
649         // Set participant's KYC status to Accepted
650         kycStatus[participant] = KycState.Accepted;
651 
652         // Get pending amounts in ETH and Parsecs
653         uint256 pendingAmountOfEth = pendingContributionOf[participant];
654         uint256 pendingAmountOfParsecs = pendingParsecsOf[participant];
655 
656         // Log an event of the participant's KYC accept
657         LogKycAccept(participant, pendingAmountOfEth, now);
658 
659         if (pendingAmountOfEth > 0 || pendingAmountOfParsecs > 0) {
660             // Reset pending contribution
661             resetPendingContribution(participant);
662 
663             // Add accepted contribution
664             addAcceptedContribution(participant, pendingAmountOfEth, pendingAmountOfParsecs);
665         }
666     }
667 
668     /// @dev Decline participant's KYC
669     function declineKyc(address participant) external onlyOwnerOrAuditor {
670         // Set participant's KYC status to Declined
671         kycStatus[participant] = KycState.Declined;
672 
673         // Log an event of the participant's KYC decline
674         LogKycDecline(participant, pendingAmountOfEth, now);
675 
676         // Get pending ETH amount
677         uint256 pendingAmountOfEth = pendingContributionOf[participant];
678 
679         if (pendingAmountOfEth > 0) {
680             // Reset pending contribution
681             resetPendingContribution(participant);
682 
683             // Transfer ETH back to participant
684             participant.transfer(pendingAmountOfEth);
685         }
686     }
687 
688     /// @dev Allow participants to clawback ETH in case of Crowdsale failure
689     function participantClawbackEther(uint256 value) external {
690         // Participant cannot withdraw ETH if refund is not started or after it is finished
691         require(contractRefundStarted);
692         require(!contractRefundFinished);
693 
694         // Get total contribution of participant
695         uint256 totalContribution = contributionOf[msg.sender];
696 
697         // Get already refunded amount
698         uint256 alreadyRefunded = refundOf[msg.sender];
699 
700         // Calculate maximal withdrawal amount
701         uint256 maxWithdrawalAmount = totalContribution.sub(alreadyRefunded);
702 
703         // Maximal withdrawal amount should not be zero
704         require(maxWithdrawalAmount > 0);
705 
706         // Requested value should not exceed maximal withdrawal amount
707         require(value > 0);
708         require(value <= maxWithdrawalAmount);
709 
710         // Participant's refundOf is increased by the claimed amount
711         refundOf[msg.sender] = alreadyRefunded.add(value);
712 
713         // Total refound amount is increased
714         refundedFunding = refundedFunding.add(value);
715 
716         // Send ethers back to the participant's account
717         msg.sender.transfer(value);
718     }
719 
720     /// @dev Register pending contribution
721     function addPendingContribution(address participant, uint256 ethValue, uint256 parsecValue) private {
722         // Participant's pending contribution is increased by ethValue
723         pendingContributionOf[participant] = pendingContributionOf[participant].add(ethValue);
724 
725         // Parsecs pending to participant increased by parsecValue
726         pendingParsecsOf[participant] = pendingParsecsOf[participant].add(parsecValue);
727 
728         // Increase pending funding by ethValue
729         pendingFunding = pendingFunding.add(ethValue);
730 
731         // Increase pending Parsecs by parsecValue
732         pendingParsecs = pendingParsecs.add(parsecValue);
733     }
734 
735     /// @dev Register accepted contribution
736     function addAcceptedContribution(address participant, uint256 ethValue, uint256 parsecValue) private {
737         // Participant's contribution is increased by ethValue
738         contributionOf[participant] = contributionOf[participant].add(ethValue);
739 
740         // Parsecs rewarded to participant increased by parsecValue
741         parsecsOf[participant] = parsecsOf[participant].add(parsecValue);
742 
743         // Increase total raised funding by ethValue
744         raisedFunding = raisedFunding.add(ethValue);
745 
746         // Increase spent Parsecs by parsecValue
747         spentParsecs = spentParsecs.add(parsecValue);
748 
749         // Log an event of the participant's contribution
750         LogContribution(participant, ethValue, parsecValue, now);
751 
752         // Transfer ETH to Multisig
753         multisigAddress.transfer(ethValue);
754 
755         // Transfer Parsecs to participant
756         parsecToken.transfer(participant, parsecValue);
757     }
758 
759     /// @dev Reset pending contribution
760     function resetPendingContribution(address participant) private {
761         // Get amounts of pending ETH and Parsecs
762         uint256 pendingAmountOfEth = pendingContributionOf[participant];
763         uint256 pendingAmountOfParsecs = pendingParsecsOf[participant];
764 
765         // Decrease pending contribution by pendingAmountOfEth
766         pendingContributionOf[participant] = pendingContributionOf[participant].sub(pendingAmountOfEth);
767 
768         // Decrease pending Parsecs reward by pendingAmountOfParsecs
769         pendingParsecsOf[participant] = pendingParsecsOf[participant].sub(pendingAmountOfParsecs);
770 
771         // Decrease pendingFunding by pendingAmountOfEth
772         pendingFunding = pendingFunding.sub(pendingAmountOfEth);
773 
774         // Decrease pendingParsecs by pendingAmountOfParsecs
775         pendingParsecs = pendingParsecs.sub(pendingAmountOfParsecs);
776     }
777 
778     /// @dev Calculate amount of Parsecs to grant for ETH contribution
779     function calculateReward(uint256 ethValue) private view returns (uint256 amount) {
780         // Define base quotient
781         uint256 baseQuotient = 1000;
782 
783         // Calculate actual quotient according to current bonus tier
784         uint256 actualQuotient = baseQuotient.add(calculateBonusTierQuotient());
785 
786         // Calculate reward amount
787         uint256 reward = ethValue.mul(PARSECS_PER_ETHER_BASE);
788         reward = reward.mul(actualQuotient);
789         reward = reward.div(baseQuotient);
790         return reward.div(1 ether);
791     }
792 
793     /// @dev Calculate current bonus tier quotient
794     function calculateBonusTierQuotient() private view returns (uint256 quotient) {
795         uint256 funding = raisedFunding.add(pendingFunding);
796 
797         if (funding < BONUS_TIER_1_LIMIT) {
798             return 300;     // 30.0 % bonus Parsecs
799         } else if (funding < BONUS_TIER_2_LIMIT) {
800             return 275;     // 27.5 % bonus Parsecs
801         } else if (funding < BONUS_TIER_3_LIMIT) {
802             return 250;     // 25.0 % bonus Parsecs
803         } else if (funding < BONUS_TIER_4_LIMIT) {
804             return 225;     // 22.5 % bonus Parsecs
805         } else if (funding < BONUS_TIER_5_LIMIT) {
806             return 200;     // 20.0 % bonus Parsecs
807         } else if (funding < BONUS_TIER_6_LIMIT) {
808             return 175;     // 17.5 % bonus Parsecs
809         } else if (funding < BONUS_TIER_7_LIMIT) {
810             return 150;     // 15.0 % bonus Parsecs
811         } else if (funding < BONUS_TIER_8_LIMIT) {
812             return 100;     // 10.0 % bonus Parsecs
813         } else if (funding < BONUS_TIER_9_LIMIT) {
814             return 50;      // 5.00 % bonus Parsecs
815         } else {
816             return 0;       // 0.00 % bonus Parsecs
817         }
818     }
819 }