1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'C4F' Coins4Favors contracts
5 //
6 // contracts for C4FEscrow and C4FToken Crowdsale
7 //
8 // (c) C4F Ltd Hongkong 2018
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function mul(uint a, uint b) internal pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function div(uint a, uint b) internal pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     function Owned() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78     }
79 }
80 
81 // ----------------------------------------------------------------------------
82 // 'C4F' FavorEscrow contract
83 //
84 // Escrow contract for favor request
85 // allows to reserve tokens till a favor is completed, cancelled or arbitrated
86 // handles requester and provider interaction, payout, cancellation and
87 // arbitration if needed.
88 //
89 // (c) C4F Ltd Hongkong 2018
90 // ----------------------------------------------------------------------------
91 
92 contract C4FEscrow {
93 
94     using SafeMath for uint;
95     
96     address public owner;
97     address public requester;
98     address public provider;
99 
100     uint256 public startTime;
101     uint256 public closeTime;
102     uint256 public deadline;
103     
104     uint256 public C4FID;
105     uint8   public status;
106     bool    public requesterLocked;
107     bool    public providerLocked;
108     bool    public providerCompleted;
109     bool    public requesterDisputed;
110     bool    public providerDisputed;
111     uint8   public arbitrationCosts;
112 
113     event ownerChanged(address oldOwner, address newOwner);   
114     event deadlineChanged(uint256 oldDeadline, uint256 newDeadline);
115     event favorDisputed(address disputer);
116     event favorUndisputed(address undisputer);
117     event providerSet(address provider);
118     event providerLockSet(bool lockstat);
119     event providerCompletedSet(bool completed_status);
120     event requesterLockSet(bool lockstat);
121     event favorCompleted(address provider, uint256 tokenspaid);
122     event favorCancelled(uint256 tokensreturned);
123     event tokenOfferChanged(uint256 oldValue, uint256 newValue);
124     event escrowArbitrated(address provider, uint256 coinsreturned, uint256 fee);
125 
126 // ----------------------------------------------------------------------------
127 // modifiers used in this contract to restrict function calls
128 // ----------------------------------------------------------------------------
129 
130     modifier onlyOwner {
131         require(msg.sender == owner);
132         _;
133     }   
134 
135     modifier onlyRequester {
136         require(msg.sender == requester);
137         _;
138     }   
139     
140     modifier onlyProvider {
141         require(msg.sender == provider);
142         _;
143     }   
144 
145     modifier onlyOwnerOrRequester {
146         require((msg.sender == owner) || (msg.sender == requester)) ;
147         _;
148     }   
149     
150     modifier onlyOwnerOrProvider {
151         require((msg.sender == owner) || (msg.sender == provider)) ;
152         _;        
153     }
154     
155     modifier onlyProviderOrRequester {
156         require((msg.sender == requester) || (msg.sender == provider)) ;
157         _;        
158     }
159 
160     // ----------------------------------------------------------------------------
161     // Constructor
162     // ----------------------------------------------------------------------------
163     function C4FEscrow(address newOwner, uint256 ID, address req, uint256 deadl, uint8 arbCostPercent) public {
164         owner       = newOwner; // main contract
165         C4FID       = ID;
166         requester   = req;
167         provider    = address(0);
168         startTime   = now;
169         deadline    = deadl;
170         status      = 1;        // 1 = open, 2 = cancelled, 3=closed, 4=arbitrated
171         arbitrationCosts    = arbCostPercent;
172         requesterLocked     = false;
173         providerLocked      = false;
174         providerCompleted   = false;
175         requesterDisputed   = false;
176         providerDisputed    = false;
177     }
178     
179     // ----------------------------------------------------------------------------
180     // returns the owner of the Escrow contract. This is the main C4F Token contract
181     // ----------------------------------------------------------------------------
182     function getOwner() public view returns (address ownner) {
183         return owner;
184     } 
185     
186     function setOwner(address newOwner) public onlyOwner returns (bool success) {
187         require(newOwner != address(0));
188         ownerChanged(owner,newOwner);
189         owner = newOwner;
190         return true;
191     }
192     // ----------------------------------------------------------------------------
193     // returns the Requester of the Escrow contract. This is the originator of the favor request
194     // ----------------------------------------------------------------------------
195     function getRequester() public view returns (address req) {
196         return requester;
197     }
198 
199     // ----------------------------------------------------------------------------
200     // returns the Provider of the Escrow contract. This is the favor provider
201     // ----------------------------------------------------------------------------
202     function getProvider() public view returns (address prov) {
203         return provider;
204     }
205 
206     // ----------------------------------------------------------------------------
207     // returns the startTime of the Escrow contract which is the time it was created
208     // ----------------------------------------------------------------------------
209     function getStartTime() public view returns (uint256 st) {
210         return startTime;
211     }    
212 
213     // ----------------------------------------------------------------------------
214     // returns the Deadline of the Escrow contract by which completion is needed
215     // Reqeuster can cancel the Escrow 12 hours after deadline expires if favor
216     // is not marked as completed by provider
217     // ----------------------------------------------------------------------------
218     function getDeadline() public view returns (uint256 actDeadline) {
219         actDeadline = deadline;
220         return actDeadline;
221     }
222     
223     // ----------------------------------------------------------------------------
224     // adjusts the Deadline of the Escrow contract by which completion is needed
225     // Reqeuster can only change this till a provider accepted (locked) the contract
226     // ----------------------------------------------------------------------------
227     function changeDeadline(uint newDeadline) public onlyRequester returns (bool success) {
228         // deadline can only be changed if not locked by provider and not completed
229         require ((!providerLocked) && (!providerDisputed) && (!providerCompleted) && (status==1));
230         deadlineChanged(newDeadline, deadline);
231         deadline = newDeadline;
232         return true;
233     }
234 
235     // ----------------------------------------------------------------------------
236     // returns the status of the Escrow contract
237     // ----------------------------------------------------------------------------
238     function getStatus() public view returns (uint8 s) {
239         return status;
240     }
241 
242     // ----------------------------------------------------------------------------
243     // Initiates dispute of the Escrow contract. Once requester or provider disputeFavor
244     // because they cannot agree on completion, the C4F system can arbitrate the Escrow
245     // based on the internal juror system.
246     // ----------------------------------------------------------------------------
247     function disputeFavor() public onlyProviderOrRequester returns (bool success) {
248         if(msg.sender == requester) {
249             requesterDisputed = true;
250         }
251         if(msg.sender == provider) {
252             providerDisputed = true;
253             providerLocked = true;
254         }
255         favorDisputed(msg.sender);
256         return true;
257     }
258     // ----------------------------------------------------------------------------
259     // Allows to take back a dispute on the Escrow if conflict has been resolved
260     // ----------------------------------------------------------------------------
261     function undisputeFavor() public onlyProviderOrRequester returns (bool success) {
262         if(msg.sender == requester) {
263             requesterDisputed = false;
264         }
265         if(msg.sender == provider) {
266             providerDisputed = false;
267         }
268         favorUndisputed(msg.sender);
269         return true;
270     }
271     
272     // ----------------------------------------------------------------------------
273     // allows to set the address of the provider for the Favor
274     // this can be done by the requester or the C4F system
275     // once the provider accepts, the providerLock flag disables changes to this
276     // ----------------------------------------------------------------------------
277     function setProvider(address newProvider) public onlyOwnerOrRequester returns (bool success) {
278         // can only change provider if not locked by current provider
279         require(!providerLocked);
280         require(!requesterLocked);
281         provider = newProvider;
282         providerSet(provider);
283         return true;
284     }
285     
286     // ----------------------------------------------------------------------------
287     // switches the ProviderLock on or off. Once provider lock is switched on, 
288     // it means the provider has formally accepted the offer and changes are 
289     // blocked
290     // ----------------------------------------------------------------------------
291     function setProviderLock(bool lock) public onlyOwnerOrProvider returns (bool res) {
292         providerLocked = lock;
293         providerLockSet(lock);
294         return providerLocked;
295     }
296 
297     // ----------------------------------------------------------------------------
298     // allows to set Favor to completed from Provider view, indicating that 
299     // provider sess Favor as delivered
300     // ----------------------------------------------------------------------------
301     function setProviderCompleted(bool c) public onlyOwnerOrProvider returns (bool res) {
302         providerCompleted = c;
303         providerCompletedSet(c);
304         return c;
305     }
306     
307     // ----------------------------------------------------------------------------
308     // allows to set requester lock, indicating requester accepted favor provider
309     // ----------------------------------------------------------------------------
310     function setRequesterLock(bool lock) public onlyOwnerOrRequester returns (bool res) {
311         requesterLocked = lock;
312         requesterLockSet(lock);
313         return requesterLocked;
314     }
315     
316 
317     function getRequesterLock() public onlyOwnerOrRequester view returns (bool res) {
318         res = requesterLocked;
319         return res;
320     }
321 
322 
323     // ----------------------------------------------------------------------------
324     // allows the C4F system to change the status of an Escrow contract
325     // ----------------------------------------------------------------------------
326     function setStatus(uint8 newStatus) public onlyOwner returns (uint8 stat) {
327         status = newStatus;    
328         stat = status;
329         return stat;
330     }
331 
332     // ----------------------------------------------------------------------------
333     // returns the current Token value of the escrow for competing the favor
334     // this is the token balance of the escrow contract in the main contract
335     // ----------------------------------------------------------------------------
336     function getTokenValue() public view returns (uint256 tokens) {
337         C4FToken C4F = C4FToken(owner);
338         return C4F.balanceOf(address(this));
339     }
340 
341     // ----------------------------------------------------------------------------
342     // completes the favor Escrow and pays out the tokens minus the commission fee
343     // ----------------------------------------------------------------------------
344     function completeFavor() public onlyRequester returns (bool success) {
345         // check if provider has been set
346         require(provider != address(0));
347         
348         // payout tokens to provider with commission
349         uint256 actTokenvalue = getTokenValue();
350         C4FToken C4F = C4FToken(owner);
351         if(!C4F.transferWithCommission(provider, actTokenvalue)) revert();
352         closeTime = now;
353         status = 3;
354         favorCompleted(provider,actTokenvalue);
355         return true;
356     }
357 
358     // ----------------------------------------------------------------------------
359     // this function cancels a favor request on behalf of the requester
360     // only possible as long as no provider accepted the contract or 12 hours
361     // after the deadline if the provider did not indicate completion or disputed
362     // ----------------------------------------------------------------------------
363     function cancelFavor() public onlyRequester returns (bool success) {
364         // cannot cancel if locked by provider unless deadline expired by 12 hours and not completed/disputed
365         require((!providerLocked) || ((now > deadline.add(12*3600)) && (!providerCompleted) && (!providerDisputed)));
366         // cannot cancel after completed or arbitrated
367         require(status==1);
368         // send tokens back to requester
369         uint256 actTokenvalue = getTokenValue();
370         C4FToken C4F = C4FToken(owner);
371         if(!C4F.transfer(requester,actTokenvalue)) revert();
372         closeTime = now;
373         status = 2;
374         favorCancelled(actTokenvalue);
375         return true;
376     }
377     
378     // ----------------------------------------------------------------------------
379     // allows the favor originator to reduce the token offer
380     // This can only be done until a provider has accepted (locked) the favor request
381     // ----------------------------------------------------------------------------
382     function changeTokenOffer(uint256 newOffer) public onlyRequester returns (bool success) {
383         // cannot change if locked by provider
384         require((!providerLocked) && (!providerDisputed) && (!providerCompleted));
385         // cannot change if cancelled, closed or arbitrated
386         require(status==1);
387         // only use for reducing tokens (to increase simply transfer tokens to contract)
388         uint256 actTokenvalue = getTokenValue();
389         require(newOffer < actTokenvalue);
390         // cannot set to 0, use cancel to do that
391         require(newOffer > 0);
392         // pay back tokens to reach new offer level
393         C4FToken C4F = C4FToken(owner);
394         if(!C4F.transfer(requester, actTokenvalue.sub(newOffer))) revert();
395         tokenOfferChanged(actTokenvalue,newOffer);
396         return true;
397     }
398     
399     // ----------------------------------------------------------------------------
400     // arbitration can be done by the C4F system once requester or provider have
401     // disputed the favor contract. An independent juror system on the platform 
402     // will vote on the outcome and define a split of the tokens between the two
403     // parties. The jurors get a percentage which is preset in the contratct for
404     // the arbitration
405     // ----------------------------------------------------------------------------
406     function arbitrateC4FContract(uint8 percentReturned) public onlyOwner returns (bool success) {
407         // can only arbitrate if one of the two parties has disputed 
408         require((providerDisputed) || (requesterDisputed));
409         // C4F System owner can arbitrate and provide a split of tokens between 0-100%
410         uint256 actTokens = getTokenValue();
411         
412         // calc. arbitration fee based on percent costs
413         uint256 arbitrationTokens = actTokens.mul(arbitrationCosts);
414         arbitrationTokens = arbitrationTokens.div(100);
415         // subtract these from the tokens to be distributed between requester and provider
416         actTokens = actTokens.sub(arbitrationTokens);
417         
418         // now split the tokens up using provided percentage
419         uint256 requesterTokens = actTokens.mul(percentReturned);
420         requesterTokens = requesterTokens.div(100);
421         // actTokens to hold what gets forwarded to provider
422         actTokens = actTokens.sub(requesterTokens);
423         
424         // distribute the Tokens
425         C4FToken C4F = C4FToken(owner);
426         // arbitration tokens go to commissiontarget of master contract
427         address commissionTarget = C4F.getCommissionTarget();
428         // requester gets refunded his split
429         if(!C4F.transfer(requester, requesterTokens)) revert();
430         // provider gets his split of tokens
431         if(!C4F.transfer(provider, actTokens)) revert();
432         // arbitration fee to system for distribution
433         if(!C4F.transfer(commissionTarget, arbitrationTokens)) revert();
434         
435         // set status & closeTime
436         status = 4;
437         closeTime = now;
438         success = true;
439         escrowArbitrated(provider,requesterTokens,arbitrationTokens);
440         return success;
441     }
442 
443 }
444 
445 // ----------------------------------------------------------------------------
446 // 'C4F' 'Coins4Favors FavorCoin contract
447 //
448 // Symbol      : C4F
449 // Name        : FavorCoin
450 // Total supply: 100,000,000,000.000000000000000000
451 // Decimals    : 18
452 //
453 // includes the crowdsale price, PreICO bonus structure, limits on sellable tokens
454 // function to pause sale, commission fee transfer and favorcontract management
455 //
456 // (c) C4F Ltd Hongkong 2018
457 // ----------------------------------------------------------------------------
458 
459 contract C4FToken is ERC20Interface, Owned {
460     using SafeMath for uint;
461 
462     string public symbol;
463     string public  name;
464     uint8 public decimals;
465     uint8 public _crowdsalePaused;
466     uint public _totalSupply;
467     uint public _salesprice;
468     uint public _endOfICO;
469     uint public _endOfPreICO;
470     uint public _beginOfICO;
471     uint public _bonusTime1;
472     uint public _bonusTime2;
473     uint public _bonusRatio1;
474     uint public _bonusRatio2;
475     uint public _percentSoldInPreICO;
476     uint public _maxTokenSoldPreICO;
477     uint public _percentSoldInICO;
478     uint public _maxTokenSoldICO;
479     uint public _total_sold;
480     uint public _commission;
481     uint8 public _arbitrationPercent;
482     address public _commissionTarget;
483     uint public _minimumContribution;
484     address[]   EscrowAddresses;
485     uint public _escrowIndex;
486 
487     mapping(address => uint) balances;
488     mapping(address => mapping(address => uint)) allowed;
489     mapping(address => uint) whitelisted_amount;
490     mapping(address => bool) C4FEscrowContracts;
491     
492     
493     event newEscrowCreated(uint ID, address contractAddress, address requester);   
494     event ICOStartSet(uint256 starttime);
495     event ICOEndSet(uint256 endtime);
496     event PreICOEndSet(uint256 endtime);
497     event BonusTime1Set(uint256 bonustime);
498     event BonusTime2Set(uint256 bonustime);
499     event accountWhitelisted(address account, uint256 limit);
500     event crowdsalePaused(bool paused);
501     event crowdsaleResumed(bool resumed);
502     event commissionSet(uint256 commission);
503     event commissionTargetSet(address target);
504     event arbitrationPctSet(uint8 arbpercent);
505     event contractOwnerChanged(address escrowcontract, address newOwner);
506     event contractProviderChanged(address C4Fcontract, address provider);
507     event contractArbitrated(address C4Fcontract, uint8 percentSplit);
508     
509     // ------------------------------------------------------------------------
510     // Constructor
511     // ------------------------------------------------------------------------
512     function C4FToken() public {
513         symbol          = "C4F";
514         name            = "C4F FavorCoins";
515         decimals        = 18;
516         
517         _totalSupply    = 100000000000 * 10**uint(decimals);
518 
519         _salesprice     = 2000000;      // C4Fs per 1 Eth
520         _minimumContribution = 0.05 * 10**18;    // minimum amount is 0.05 Ether
521         
522         _endOfICO       = 1532908800;   // end of ICO is 30.07.18
523         _beginOfICO     = 1526342400;   // begin is 15.05.18
524         _bonusRatio1    = 110;          // 10% Bonus in second week of PreICO
525         _bonusRatio2    = 125;          // 25% Bonus in first week of PreICO
526         _bonusTime1     = 1527638400;   // prior to 30.05.18 add bonusRatio1
527         _bonusTime2     = 1526947200;   // prior to 22.05.18 add bonusRatio2
528         _endOfPreICO    = 1527811200;   // Pre ICO ends 01.06.2018
529         
530         _percentSoldInPreICO = 10;      // we only offer 10% of total Supply during PreICO
531         _maxTokenSoldPreICO = _totalSupply.mul(_percentSoldInPreICO);
532         _maxTokenSoldPreICO = _maxTokenSoldPreICO.div(100);
533         
534         _percentSoldInICO   = 60;      // in addition to 10% sold in PreICO, 60% sold in ICO 
535         _maxTokenSoldICO    = _totalSupply.mul(_percentSoldInPreICO.add(_percentSoldInICO));
536         _maxTokenSoldICO    = _maxTokenSoldICO.div(100);
537         
538         _total_sold         = 0;            // total coins sold 
539         
540         _commission         = 0;            // no comission on transfers 
541         _commissionTarget   = owner;        // default any commission goes to the owner of the contract
542         _arbitrationPercent = 10;           // default costs for arbitration of an escrow contract
543                                             // is transferred to escrow contract at time of creation and kept there
544         
545         _crowdsalePaused    = 0;
546 
547         balances[owner]     = _totalSupply;
548         Transfer(address(0), owner, _totalSupply);
549     }
550 
551     // ------------------------------------------------------------------------
552     // notLocked: ensure no coins are moved by owners prior to end of ICO
553     // ------------------------------------------------------------------------
554     
555     modifier notLocked {
556         require((msg.sender == owner) || (now >= _endOfICO));
557         _;
558     }
559     
560     // ------------------------------------------------------------------------
561     // onlyDuringICO: FavorCoins can only be bought via contract during ICO
562     // ------------------------------------------------------------------------
563     
564     modifier onlyDuringICO {
565         require((now >= _beginOfICO) && (now <= _endOfICO));
566         _;
567     }
568     
569     // ------------------------------------------------------------------------
570     // notPaused: ability to stop crowdsale if problems occur
571     // ------------------------------------------------------------------------
572     
573     modifier notPaused {
574         require(_crowdsalePaused == 0);
575         _;
576     }
577     
578     // ------------------------------------------------------------------------
579     // set ICO and PRE ICO Dates
580     // ------------------------------------------------------------------------
581 
582     function setICOStart(uint ICOdate) public onlyOwner returns (bool success) {
583         _beginOfICO  = ICOdate;
584         ICOStartSet(_beginOfICO);
585         return true;
586     }
587     
588     function setICOEnd(uint ICOdate) public onlyOwner returns (bool success) {
589         _endOfICO  = ICOdate;
590         ICOEndSet(_endOfICO);
591         return true;
592     }
593     
594     function setPreICOEnd(uint ICOdate) public onlyOwner returns (bool success) {
595         _endOfPreICO = ICOdate;
596         PreICOEndSet(_endOfPreICO);
597         return true;
598     }
599     
600     function setBonusDate1(uint ICOdate) public onlyOwner returns (bool success) {
601         _bonusTime1 = ICOdate;
602         BonusTime1Set(_bonusTime1);
603         return true;
604     }
605 
606     function setBonusDate2(uint ICOdate) public onlyOwner returns (bool success) {
607         _bonusTime2 = ICOdate;
608         BonusTime2Set(_bonusTime2);
609         return true;
610     }
611 
612     // ------------------------------------------------------------------------
613     // Total supply
614     // ------------------------------------------------------------------------
615     function totalSupply() public constant returns (uint) {
616         return _totalSupply  - balances[address(0)];
617     }
618 
619 
620     // ------------------------------------------------------------------------
621     // Get the token balance for account `tokenOwner`
622     // ------------------------------------------------------------------------
623     function balanceOf(address tokenOwner) public constant returns (uint balance) {
624         return balances[tokenOwner];
625     }
626 
627     // ------------------------------------------------------------------------
628     // Whitelist address up to maximum spending (AML and KYC)
629     // ------------------------------------------------------------------------
630     function whitelistAccount(address account, uint limit) public onlyOwner {
631         whitelisted_amount[account] = limit*10**18;
632         accountWhitelisted(account,limit);
633     }
634     
635     // ------------------------------------------------------------------------
636     // return maximum remaining whitelisted amount for account 
637     // ------------------------------------------------------------------------
638     function getWhitelistLimit(address account) public constant returns (uint limit) {
639         return whitelisted_amount[account];
640     }
641 
642     // ------------------------------------------------------------------------
643     // Pause crowdsale in case of any problems
644     // ------------------------------------------------------------------------
645     function pauseCrowdsale() public onlyOwner returns (bool success) {
646         _crowdsalePaused = 1;
647         crowdsalePaused(true);
648         return true;
649     }
650 
651     function resumeCrowdsale() public onlyOwner returns (bool success) {
652         _crowdsalePaused = 0;
653         crowdsaleResumed(true);
654         return true;
655     }
656     
657     
658     // ------------------------------------------------------------------------
659     // Commission can be added later to a percentage of the transferred
660     // C4F tokens for operating costs of the system. Percentage is capped at 2%
661     // ------------------------------------------------------------------------
662     function setCommission(uint comm) public onlyOwner returns (bool success) {
663         require(comm < 200); // we allow a maximum of 2% commission
664         _commission = comm;
665         commissionSet(comm);
666         return true;
667     }
668 
669     function setArbitrationPercentage(uint8 arbitPct) public onlyOwner returns (bool success) {
670         require(arbitPct <= 15); // we allow a maximum of 15% arbitration costs
671         _arbitrationPercent = arbitPct;
672         arbitrationPctSet(_arbitrationPercent);
673         return true;
674     }
675 
676     function setCommissionTarget(address ct) public onlyOwner returns (bool success) {
677         _commissionTarget = ct;
678         commissionTargetSet(_commissionTarget);
679         return true;
680     }
681     
682     function getCommissionTarget() public view returns (address ct) {
683         ct = _commissionTarget;
684         return ct;
685     }
686 
687     // ------------------------------------------------------------------------
688     // Transfer the balance from token owner's account to `to` account
689     // - Owner's account must have sufficient balance to transfer
690     // - 0 value transfers are allowed
691     // - users cannot transfer C4Fs prior to close of ICO
692     // - only owner can transfer anytime to do airdrops, etc.
693     // ------------------------------------------------------------------------
694     function transfer(address to, uint tokens) public notLocked notPaused returns (bool success) {
695         balances[msg.sender] = balances[msg.sender].sub(tokens);
696         balances[to] = balances[to].add(tokens);
697         Transfer(msg.sender, to, tokens);
698         return true;
699     }
700     
701     // ------------------------------------------------------------------------
702     // this function will be used by the C4F app to charge a Commission
703     // on transfers later
704     // ------------------------------------------------------------------------
705     function transferWithCommission(address to, uint tokens) public notLocked notPaused returns (bool success) {
706         balances[msg.sender] = balances[msg.sender].sub(tokens);
707         // split tokens using commission Percentage
708         uint comTokens = tokens.mul(_commission);
709         comTokens = comTokens.div(10000);
710         // adjust balances
711         balances[to] = balances[to].add(tokens.sub(comTokens));
712         balances[_commissionTarget] = balances[_commissionTarget].add(comTokens);
713         // trigger events
714         Transfer(msg.sender, to, tokens.sub(comTokens));
715         Transfer(msg.sender, _commissionTarget, comTokens);
716         return true;
717     }
718 
719     
720     // ------------------------------------------------------------------------
721     // TransferInternal handles Transfer of Tokens from Owner during ICO and Pre-ICO
722     // ------------------------------------------------------------------------
723     function transferInternal(address to, uint tokens) private returns (bool success) {
724         balances[owner] = balances[owner].sub(tokens);
725         balances[to] = balances[to].add(tokens);
726         Transfer(msg.sender, to, tokens);
727         return true;
728     }
729 
730 
731     // ------------------------------------------------------------------------
732     // Token owner can approve for `spender` to transferFrom(...) `tokens`
733     // from the token owner's account
734     //
735     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
736     // recommends that there are no checks for the approval double-spend attack
737     // as this should be implemented in user interfaces 
738     // ------------------------------------------------------------------------
739     function approve(address spender, uint tokens) public notLocked notPaused returns (bool success) {
740         allowed[msg.sender][spender] = tokens;
741         Approval(msg.sender, spender, tokens);
742         return true;
743     }
744 
745 
746     // ------------------------------------------------------------------------
747     // Transfer `tokens` from the `from` account to the `to` account
748     // not possivbe before end of ICO
749     // The calling account must already have sufficient tokens approve(...)-d
750     // for spending from the `from` account and
751     // - From account must have sufficient balance to transfer
752     // - Spender must have sufficient allowance to transfer
753     // - 0 value transfers are allowed
754     // ------------------------------------------------------------------------
755     function transferFrom(address from, address to, uint tokens) public notLocked notPaused returns (bool success) {
756         // check allowance is high enough
757         require(allowed[from][msg.sender] >= tokens);
758         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
759         balances[from] = balances[from].sub(tokens);
760         balances[to] = balances[to].add(tokens);
761         Transfer(from, to, tokens);
762         return true;
763     }
764 
765 
766     // ------------------------------------------------------------------------
767     // Returns the amount of tokens approved by the owner that can be
768     // transferred to the spender's account
769     // ------------------------------------------------------------------------
770     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
771         return allowed[tokenOwner][spender];
772     }
773 
774     // ------------------------------------------------------------------------
775     // startEscrow FavorContract
776     // starts an escrow contract and transfers the tokens into the contract
777     // ------------------------------------------------------------------------
778     
779     function startFavorEscrow(uint256 ID, uint256 deadl, uint tokens) public notLocked returns (address C4FFavorContractAddr) {
780         // check if sufficient coins available
781         require(balanceOf(msg.sender) >= tokens);
782         // create contract
783         address newFavor = new C4FEscrow(address(this), ID, msg.sender, deadl, _arbitrationPercent);
784         // add to list of C4FEscrowContratcs
785         EscrowAddresses.push(newFavor);
786         C4FEscrowContracts[newFavor] = true;
787         // transfer tokens to contract
788         if(!transfer(newFavor, tokens)) revert();
789         C4FFavorContractAddr = newFavor;
790         newEscrowCreated(ID, newFavor, msg.sender);
791         return C4FFavorContractAddr;
792     }
793 
794     function isFavorEscrow(uint id, address c4fes) public view returns (bool res) {
795         if(EscrowAddresses[id] == c4fes) {
796                 res = true;
797             } else {
798                 res = false;
799             }
800         return res;
801     }
802     
803     function getEscrowCount() public view returns (uint) {
804         return EscrowAddresses.length;
805     }
806     
807     function getEscrowAddress(uint ind) public view returns(address esa) {
808         require (ind <= EscrowAddresses.length);
809         esa = EscrowAddresses[ind];
810         return esa;
811     }
812     
813     
814     // use this function to allow C4F System to adjust owner of C4FEscrows 
815     function setC4FContractOwner(address C4Fcontract, address newOwner) public onlyOwner returns (bool success) {
816         require(C4FEscrowContracts[C4Fcontract]);
817         C4FEscrow c4fec = C4FEscrow(C4Fcontract);
818         // call setProvider from there
819         if(!c4fec.setOwner(newOwner)) revert();
820         contractOwnerChanged(C4Fcontract,newOwner);
821         return true;
822     }
823     
824     // use this function to allow C4F System to adjust provider of C4F Favorcontract    
825     function setC4FContractProvider(address C4Fcontract, address provider) public onlyOwner returns (bool success) {
826         // ensure this is a C4FEscrowContract initiated by C4F system
827         require(C4FEscrowContracts[C4Fcontract]);
828         C4FEscrow c4fec = C4FEscrow(C4Fcontract);
829         // call setProvider from there
830         if(!c4fec.setProvider(provider)) revert();
831         contractProviderChanged(C4Fcontract, provider);
832         return true;
833     }
834     
835     // use this function to allow C4F System to adjust providerLock 
836     function setC4FContractProviderLock(address C4Fcontract, bool lock) public onlyOwner returns (bool res) {
837         // ensure this is a C4FEscrowContract initiated by C4F system
838         require(C4FEscrowContracts[C4Fcontract]);
839         C4FEscrow c4fec = C4FEscrow(C4Fcontract);
840         // call setProviderLock from there
841         res = c4fec.setProviderLock(lock);
842         return res;
843     }
844     
845     // use this function to allow C4F System to adjust providerCompleted status
846     function setC4FContractProviderCompleted(address C4Fcontract, bool completed) public onlyOwner returns (bool res) {
847         // ensure this is a C4FEscrowContract initiated by C4F system
848         require(C4FEscrowContracts[C4Fcontract]);
849         C4FEscrow c4fec = C4FEscrow(C4Fcontract);
850         // call setProviderCompleted from there
851         res = c4fec.setProviderCompleted(completed);
852         return res;
853     }
854     
855         // use this function to allow C4F System to adjust providerLock 
856     function setC4FContractRequesterLock(address C4Fcontract, bool lock) public onlyOwner returns (bool res) {
857         // ensure this is a C4FEscrowContract initiated by C4F system
858         require(C4FEscrowContracts[C4Fcontract]);
859         C4FEscrow c4fec = C4FEscrow(C4Fcontract);
860         // call setRequesterLock from there
861         res = c4fec.setRequesterLock(lock);
862         return res;
863     }
864 
865     function setC4FContractStatus(address C4Fcontract, uint8 newStatus) public onlyOwner returns (uint8 s) {
866         // ensure this is a C4FEscrowContract initiated by C4F system
867         require(C4FEscrowContracts[C4Fcontract]);
868         C4FEscrow c4fec = C4FEscrow(C4Fcontract);
869         // call setStatus from there
870         s = c4fec.setStatus(newStatus);
871         return s;
872     }
873     
874     function arbitrateC4FContract(address C4Fcontract, uint8 percentSplit) public onlyOwner returns (bool success) {
875         // ensure this is a C4FEscrowContract initiated by C4F system
876         require(C4FEscrowContracts[C4Fcontract]);
877         C4FEscrow c4fec = C4FEscrow(C4Fcontract);
878         // call arbitration
879         if(!c4fec.arbitrateC4FContract(percentSplit)) revert();
880         contractArbitrated(C4Fcontract, percentSplit);
881         return true;
882     }
883 
884     
885     // ------------------------------------------------------------------------
886     // Convert to C4Fs using salesprice and bonus period and forward Eth to owner
887     // ------------------------------------------------------------------------
888     function () public onlyDuringICO notPaused payable  {
889         // check bonus ratio
890         uint bonusratio = 100;
891         // check for second week bonus
892         if(now <= _bonusTime1) {
893             bonusratio = _bonusRatio1;    
894         }
895         // check for first week bonus
896         if(now <= _bonusTime2) {
897             bonusratio = _bonusRatio2;    
898         }
899         
900         // minimum contribution met ?
901         require (msg.value >= _minimumContribution);
902         
903         // send C4F tokens back to sender based on Ether received
904         if (msg.value > 0) {
905             
906             // check if whitelisted and sufficient contribution left (AML & KYC)
907             if(!(whitelisted_amount[msg.sender] >= msg.value)) revert();
908             // reduce remaining contribution limit
909             whitelisted_amount[msg.sender] = whitelisted_amount[msg.sender].sub(msg.value);
910             
911             // determine amount of C4Fs 
912             uint256 token_amount = msg.value.mul(_salesprice);
913             token_amount = token_amount.mul(bonusratio);
914             token_amount = token_amount.div(100);
915             
916             uint256 new_total = _total_sold.add(token_amount);
917             // check if PreICO volume sold off 
918             if(now <= _endOfPreICO){
919                 // check if we are above the limit with this transfer, then bounce
920                 if(new_total > _maxTokenSoldPreICO) revert();
921             }
922             
923             // check if exceeding total ICO sale tokens
924             if(new_total > _maxTokenSoldICO) revert();
925             
926             // transfer tokens from owner account to sender
927             if(!transferInternal(msg.sender, token_amount)) revert();
928             _total_sold = new_total;
929             // forward received ether to owner account
930             if (!owner.send(msg.value)) revert(); // also reverts the transfer.
931         }
932     }
933 }