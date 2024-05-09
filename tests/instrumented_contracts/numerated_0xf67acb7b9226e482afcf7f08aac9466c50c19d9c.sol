1 pragma solidity ^0.4.18;
2 
3 contract GenericCrowdsale {
4     address public icoBackend;
5     address public icoManager;
6     address public emergencyManager;
7 
8     // paused state
9     bool paused = false;
10 
11     /**
12      * @dev Confirms that token issuance for an off-chain purchase was processed successfully.
13      * @param _beneficiary Token holder.
14      * @param _contribution Money received (in USD cents). Copied from issueTokens call arguments.
15      * @param _tokensIssued The amount of tokens that was assigned to the holder, not counting bonuses.
16      */
17     event TokensAllocated(address _beneficiary, uint _contribution, uint _tokensIssued);
18 
19     /**
20      * @dev Notifies about bonus token issuance. Is raised even if the bonus is 0.
21      * @param _beneficiary Token holder.
22      * @param _bonusTokensIssued The amount of bonus tokens that was assigned to the holder.
23      */
24     event BonusIssued(address _beneficiary, uint _bonusTokensIssued);
25 
26     /**
27      * @dev Issues tokens for founders and partners and closes the current phase.
28      * @param foundersWallet Wallet address holding the vested tokens.
29      * @param tokensForFounders The amount of tokens vested for founders.
30      * @param partnersWallet Wallet address holding the tokens for early contributors.
31      * @param tokensForPartners The amount of tokens issued for rewarding early contributors.
32      */
33     event FoundersAndPartnersTokensIssued(address foundersWallet, uint tokensForFounders,
34                                           address partnersWallet, uint tokensForPartners);
35 
36     event Paused();
37     event Unpaused();
38 
39     /**
40      * @dev Issues tokens for the off-chain contributors by accepting calls from the trusted address.
41      *        Supposed to be run by the backend.
42      * @param _beneficiary Token holder.
43      * @param _contribution The equivalent (in USD cents) of the contribution received off-chain.
44      */
45     function issueTokens(address _beneficiary, uint _contribution) onlyBackend onlyUnpaused external;
46 
47     /**
48      * @dev Issues tokens for the off-chain contributors by accepting calls from the trusted address.
49      *      Supposed to be run by the backend.
50      * @param _beneficiary Token holder.
51      * @param _contribution The equivalent (in USD cents) of the contribution received off-chain.
52      * @param _tokens Total Tokens to issue for the contribution, must be > 0
53      * @param _bonus How many tokens are bonuses, less or equal to _tokens
54      */
55     function issueTokensWithCustomBonus(address _beneficiary, uint _contribution, uint _tokens, uint _bonus) onlyBackend onlyUnpaused external;
56 
57     /**
58      * @dev Pauses the token allocation process.
59      */
60     function pause() external onlyManager onlyUnpaused {
61         paused = true;
62         Paused();
63     }
64 
65     /**
66      * @dev Unpauses the token allocation process.
67      */
68     function unpause() external onlyManager onlyPaused {
69         paused = false;
70         Unpaused();
71     }
72 
73     /**
74      * @dev Allows the manager to change backends.
75      */
76     function changeicoBackend(address _icoBackend) external onlyManager {
77         icoBackend = _icoBackend;
78     }
79 
80     /**
81      * @dev Modifiers
82      */
83     modifier onlyManager() {
84         require(msg.sender == icoManager);
85         _;
86     }
87 
88     modifier onlyBackend() {
89         require(msg.sender == icoBackend);
90         _;
91     }
92 
93     modifier onlyEmergency() {
94         require(msg.sender == emergencyManager);
95         _;
96     }
97 
98     modifier onlyPaused() {
99         require(paused == true);
100         _;
101     }
102 
103     modifier onlyUnpaused() {
104         require(paused == false);
105         _;
106     }
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 {
114   uint public totalSupply;
115 
116   function balanceOf(address _owner) constant public returns (uint balance);
117   function transfer(address _to, uint _value) public returns (bool success);
118   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
119   function approve(address _spender, uint _value) public returns (bool success);
120   function allowance(address _owner, address _spender) constant public returns (uint remaining);
121 
122   event Transfer(address indexed _from, address indexed _to, uint value);
123   event Approval(address indexed _owner, address indexed _spender, uint value);
124 }
125 
126 library SafeMath {
127    function mul(uint a, uint b) internal pure returns (uint) {
128      if (a == 0) {
129         return 0;
130       }
131 
132       uint c = a * b;
133       assert(c / a == b);
134       return c;
135    }
136 
137    function sub(uint a, uint b) internal pure returns (uint) {
138       assert(b <= a);
139       return a - b;
140    }
141 
142    function add(uint a, uint b) internal pure returns (uint) {
143       uint c = a + b;
144       assert(c >= a);
145       return c;
146    }
147 
148   function div(uint a, uint b) internal pure returns (uint256) {
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150     uint c = a / b;
151     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return c;
153   }
154 }
155 
156 contract StandardToken is ERC20 {
157     using SafeMath for uint;
158 
159     mapping (address => uint) balances;
160     mapping (address => mapping (address => uint)) allowed;
161 
162     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool) {
163         if (balances[msg.sender] >= _value
164             && _value > 0
165             && _to != msg.sender
166             && _to != address(0)
167           ) {
168             balances[msg.sender] = balances[msg.sender].sub(_value);
169             balances[_to] = balances[_to].add(_value);
170 
171             Transfer(msg.sender, _to, _value);
172             return true;
173         }
174 
175         return false;
176     }
177 
178     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
179         if (balances[_from] >= _value
180             && allowed[_from][msg.sender] >= _value
181             && _value > 0
182             && _from != _to
183           ) {
184             balances[_to]   = balances[_to].add(_value);
185             balances[_from] = balances[_from].sub(_value);
186             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187             Transfer(_from, _to, _value);
188             return true;
189         }
190 
191         return false;
192     }
193 
194     function balanceOf(address _owner) constant public returns (uint) {
195         return balances[_owner];
196     }
197 
198     function allowance(address _owner, address _spender) constant public returns (uint) {
199         return allowed[_owner][_spender];
200     }
201 
202     function approve(address _spender, uint _value) public returns (bool) {
203         require(_spender != address(0));
204         // needs to be called twice -> first set to 0, then increase to another amount
205         // this is to avoid race conditions
206         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
207 
208         allowed[msg.sender][_spender] = _value;
209         Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
214         // useless operation
215         require(_spender != address(0));
216 
217         // perform operation
218         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222 
223     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
224         // useless operation
225         require(_spender != address(0));
226 
227         uint oldValue = allowed[msg.sender][_spender];
228         if (_subtractedValue > oldValue) {
229             allowed[msg.sender][_spender] = 0;
230         } else {
231             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232         }
233 
234         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235         return true;
236     }
237 
238     modifier onlyPayloadSize(uint _size) {
239         require(msg.data.length >= _size + 4);
240         _;
241     }
242 }
243 
244 contract Cappasity is StandardToken {
245 
246     // Constants
247     // =========
248     string public constant name = "Cappasity";
249     string public constant symbol = "CAPP";
250     uint8 public constant decimals = 2;
251     uint public constant TOKEN_LIMIT = 10 * 1e9 * 1e2; // 10 billion tokens, 2 decimals
252 
253     // State variables
254     // ===============
255     address public manager;
256 
257     // Block token transfers until ICO is finished.
258     bool public tokensAreFrozen = true;
259 
260     // Allow/Disallow minting
261     bool public mintingIsAllowed = true;
262 
263     // events for minting
264     event MintingAllowed();
265     event MintingDisabled();
266 
267     // Freeze/Unfreeze assets
268     event TokensFrozen();
269     event TokensUnfrozen();
270 
271     // Constructor
272     // ===========
273     function Cappasity(address _manager) public {
274         manager = _manager;
275     }
276 
277     // Fallback function
278     // Do not allow to send money directly to this contract
279     function() payable public {
280         revert();
281     }
282 
283     // ERC20 functions
284     // =========================
285     function transfer(address _to, uint _value) public returns (bool) {
286         require(!tokensAreFrozen);
287         return super.transfer(_to, _value);
288     }
289 
290     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
291         require(!tokensAreFrozen);
292         return super.transferFrom(_from, _to, _value);
293     }
294 
295     function approve(address _spender, uint _value) public returns (bool) {
296         require(!tokensAreFrozen);
297         return super.approve(_spender, _value);
298     }
299 
300     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
301         require(!tokensAreFrozen);
302         return super.increaseApproval(_spender, _addedValue);
303     }
304 
305     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
306         require(!tokensAreFrozen);
307         return super.decreaseApproval(_spender, _subtractedValue);
308     }
309 
310     // PRIVILEGED FUNCTIONS
311     // ====================
312     modifier onlyByManager() {
313         require(msg.sender == manager);
314         _;
315     }
316 
317     // Mint some tokens and assign them to an address
318     function mint(address _beneficiary, uint _value) external onlyByManager {
319         require(_value != 0);
320         require(totalSupply.add(_value) <= TOKEN_LIMIT);
321         require(mintingIsAllowed == true);
322 
323         balances[_beneficiary] = balances[_beneficiary].add(_value);
324         totalSupply = totalSupply.add(_value);
325     }
326 
327     // Disable minting. Can be enabled later, but TokenAllocation.sol only does that once.
328     function endMinting() external onlyByManager {
329         require(mintingIsAllowed == true);
330         mintingIsAllowed = false;
331         MintingDisabled();
332     }
333 
334     // Enable minting. See TokenAllocation.sol
335     function startMinting() external onlyByManager {
336         require(mintingIsAllowed == false);
337         mintingIsAllowed = true;
338         MintingAllowed();
339     }
340 
341     // Disable token transfer
342     function freeze() external onlyByManager {
343         require(tokensAreFrozen == false);
344         tokensAreFrozen = true;
345         TokensFrozen();
346     }
347 
348     // Allow token transfer
349     function unfreeze() external onlyByManager {
350         require(tokensAreFrozen == true);
351         tokensAreFrozen = false;
352         TokensUnfrozen();
353     }
354 }
355 
356 /**
357  * @dev For the tokens issued for founders.
358  */
359 contract VestingWallet {
360     using SafeMath for uint;
361 
362     event TokensReleased(uint _tokensReleased, uint _tokensRemaining, uint _nextPeriod);
363 
364     address public foundersWallet;
365     address public crowdsaleContract;
366     ERC20 public tokenContract;
367 
368     // Two-year vesting with 1 month cliff. Roughly.
369     bool public vestingStarted = false;
370     uint constant cliffPeriod = 30 days;
371     uint constant totalPeriods = 24;
372 
373     uint public periodsPassed = 0;
374     uint public nextPeriod;
375     uint public tokensRemaining;
376     uint public tokensPerBatch;
377 
378     // Constructor
379     // ===========
380     function VestingWallet(address _foundersWallet, address _tokenContract) public {
381         require(_foundersWallet != address(0));
382         require(_tokenContract != address(0));
383 
384         foundersWallet    = _foundersWallet;
385         tokenContract     = ERC20(_tokenContract);
386         crowdsaleContract = msg.sender;
387     }
388 
389     // PRIVILEGED FUNCTIONS
390     // ====================
391     function releaseBatch() external onlyFounders {
392         require(true == vestingStarted);
393         require(now > nextPeriod);
394         require(periodsPassed < totalPeriods);
395 
396         uint tokensToRelease = 0;
397         do {
398             periodsPassed   = periodsPassed.add(1);
399             nextPeriod      = nextPeriod.add(cliffPeriod);
400             tokensToRelease = tokensToRelease.add(tokensPerBatch);
401         } while (now > nextPeriod);
402 
403         // If vesting has finished, just transfer the remaining tokens.
404         if (periodsPassed >= totalPeriods) {
405             tokensToRelease = tokenContract.balanceOf(this);
406             nextPeriod = 0x0;
407         }
408 
409         tokensRemaining = tokensRemaining.sub(tokensToRelease);
410         tokenContract.transfer(foundersWallet, tokensToRelease);
411 
412         TokensReleased(tokensToRelease, tokensRemaining, nextPeriod);
413     }
414 
415     function launchVesting() public onlyCrowdsale {
416         require(false == vestingStarted);
417 
418         vestingStarted  = true;
419         tokensRemaining = tokenContract.balanceOf(this);
420         nextPeriod      = now.add(cliffPeriod);
421         tokensPerBatch  = tokensRemaining / totalPeriods;
422     }
423 
424     // INTERNAL FUNCTIONS
425     // ==================
426     modifier onlyFounders() {
427         require(msg.sender == foundersWallet);
428         _;
429     }
430 
431     modifier onlyCrowdsale() {
432         require(msg.sender == crowdsaleContract);
433         _;
434     }
435 }
436 
437 /**
438 * @dev Prepaid token allocation for a capped crowdsale with bonus structure sliding on sales
439 *      Written with OpenZeppelin sources as a rough reference.
440 */
441 contract TokenAllocation is GenericCrowdsale {
442     using SafeMath for uint;
443 
444     // Events
445     event TokensAllocated(address _beneficiary, uint _contribution, uint _tokensIssued);
446     event BonusIssued(address _beneficiary, uint _bonusTokensIssued);
447     event FoundersAndPartnersTokensIssued(address _foundersWallet, uint _tokensForFounders,
448                                           address _partnersWallet, uint _tokensForPartners);
449 
450     // Token information
451     uint public tokenRate = 125; // 1 USD = 125 CAPP; so 1 cent = 1.25 CAPP \
452                                  // assuming CAPP has 2 decimals (as set in token contract)
453     Cappasity public tokenContract;
454 
455     address public foundersWallet; // A wallet permitted to request tokens from the time vaults.
456     address public partnersWallet; // A wallet that distributes the tokens to early contributors.
457 
458     // Crowdsale progress
459     uint constant public hardCap     = 5 * 1e7 * 1e2; // 50 000 000 dollars * 100 cents per dollar
460     uint constant public phaseOneCap = 3 * 1e7 * 1e2; // 30 000 000 dollars * 100 cents per dollar
461     uint public totalCentsGathered = 0;
462 
463     // Total sum gathered in phase one, need this to adjust the bonus tiers in phase two.
464     // Updated only once, when the phase one is concluded.
465     uint public centsInPhaseOne = 0;
466     uint public totalTokenSupply = 0;     // Counting the bonuses, not counting the founders' share.
467 
468     // Total tokens issued in phase one, including bonuses. Need this to correctly calculate the founders' \
469     // share and issue it in parts, once after each round. Updated when issuing tokens.
470     uint public tokensDuringPhaseOne = 0;
471     VestingWallet public vestingWallet;
472 
473     enum CrowdsalePhase { PhaseOne, BetweenPhases, PhaseTwo, Finished }
474     enum BonusPhase { TenPercent, FivePercent, None }
475 
476     uint public constant bonusTierSize = 1 * 1e7 * 1e2; // 10 000 000 dollars * 100 cents per dollar
477     uint public constant bigContributionBound  = 1 * 1e5 * 1e2; // 100 000 dollars * 100 cents per dollar
478     uint public constant hugeContributionBound = 3 * 1e5 * 1e2; // 300 000 dollars * 100 cents per dollar
479     CrowdsalePhase public crowdsalePhase = CrowdsalePhase.PhaseOne;
480     BonusPhase public bonusPhase = BonusPhase.TenPercent;
481 
482     /**
483      * @dev Constructs the allocator.
484      * @param _icoBackend Wallet address that should be owned by the off-chain backend, from which \
485      *          \ it mints the tokens for contributions accepted in other currencies.
486      * @param _icoManager Allowed to start phase 2.
487      * @param _foundersWallet Where the founders' tokens to to after vesting.
488      * @param _partnersWallet A wallet that distributes tokens to early contributors.
489      */
490     function TokenAllocation(address _icoManager,
491                              address _icoBackend,
492                              address _foundersWallet,
493                              address _partnersWallet,
494                              address _emergencyManager
495                              ) public {
496         require(_icoManager != address(0));
497         require(_icoBackend != address(0));
498         require(_foundersWallet != address(0));
499         require(_partnersWallet != address(0));
500         require(_emergencyManager != address(0));
501 
502         tokenContract = new Cappasity(address(this));
503 
504         icoManager       = _icoManager;
505         icoBackend       = _icoBackend;
506         foundersWallet   = _foundersWallet;
507         partnersWallet   = _partnersWallet;
508         emergencyManager = _emergencyManager;
509     }
510 
511     // PRIVILEGED FUNCTIONS
512     // ====================
513     /**
514      * @dev Issues tokens for a particular address as for a contribution of size _contribution, \
515      *          \ then issues bonuses in proportion.
516      * @param _beneficiary Receiver of the tokens.
517      * @param _contribution Size of the contribution (in USD cents).
518      */
519     function issueTokens(address _beneficiary, uint _contribution) external onlyBackend onlyValidPhase onlyUnpaused {
520         // phase 1 cap less than hard cap
521         if (crowdsalePhase == CrowdsalePhase.PhaseOne) {
522             require(totalCentsGathered.add(_contribution) <= phaseOneCap);
523         } else {
524             require(totalCentsGathered.add(_contribution) <= hardCap);
525         }
526 
527         uint remainingContribution = _contribution;
528 
529         // Check if the contribution fills the current bonus phase. If so, break it up in parts,
530         // mint tokens for each part separately, assign bonuses, trigger events. For transparency.
531         do {
532             // 1 - calculate contribution part for current bonus stage
533             uint centsLeftInPhase = calculateCentsLeftInPhase(remainingContribution);
534             uint contributionPart = min(remainingContribution, centsLeftInPhase);
535 
536             // 3 - mint tokens
537             uint tokensToMint = tokenRate.mul(contributionPart);
538             mintAndUpdate(_beneficiary, tokensToMint);
539             TokensAllocated(_beneficiary, contributionPart, tokensToMint);
540 
541             // 4 - mint bonus
542             uint tierBonus = calculateTierBonus(contributionPart);
543             if (tierBonus > 0) {
544                 mintAndUpdate(_beneficiary, tierBonus);
545                 BonusIssued(_beneficiary, tierBonus);
546             }
547 
548             // 5 - advance bonus phase
549             if ((bonusPhase != BonusPhase.None) && (contributionPart == centsLeftInPhase)) {
550                 advanceBonusPhase();
551             }
552 
553             // 6 - log the processed part of the contribution
554             totalCentsGathered = totalCentsGathered.add(contributionPart);
555             remainingContribution = remainingContribution.sub(contributionPart);
556 
557             // 7 - continue?
558         } while (remainingContribution > 0);
559 
560         // Mint contribution size bonus
561         uint sizeBonus = calculateSizeBonus(_contribution);
562         if (sizeBonus > 0) {
563             mintAndUpdate(_beneficiary, sizeBonus);
564             BonusIssued(_beneficiary, sizeBonus);
565         }
566     }
567 
568     /**
569      * @dev Issues tokens for the off-chain contributors by accepting calls from the trusted address.
570      *        Supposed to be run by the backend. Used for distributing bonuses for affiliate transactions
571      *        and special offers
572      *
573      * @param _beneficiary Token holder.
574      * @param _contribution The equivalent (in USD cents) of the contribution received off-chain.
575      * @param _tokens Total token allocation size
576      * @param _bonus Bonus size
577      */
578     function issueTokensWithCustomBonus(address _beneficiary, uint _contribution, uint _tokens, uint _bonus)
579                                             external onlyBackend onlyValidPhase onlyUnpaused {
580 
581         // sanity check, ensure we allocate more than 0
582         require(_tokens > 0);
583         // all tokens can be bonuses, but they cant be less than bonuses
584         require(_tokens >= _bonus);
585         // check capps
586         if (crowdsalePhase == CrowdsalePhase.PhaseOne) {
587             // ensure we are not over phase 1 cap after this contribution
588             require(totalCentsGathered.add(_contribution) <= phaseOneCap);
589         } else {
590             // ensure we are not over hard cap after this contribution
591             require(totalCentsGathered.add(_contribution) <= hardCap);
592         }
593 
594         uint remainingContribution = _contribution;
595 
596         // Check if the contribution fills the current bonus phase. If so, break it up in parts,
597         // mint tokens for each part separately, assign bonuses, trigger events. For transparency.
598         do {
599           // 1 - calculate contribution part for current bonus stage
600           uint centsLeftInPhase = calculateCentsLeftInPhase(remainingContribution);
601           uint contributionPart = min(remainingContribution, centsLeftInPhase);
602 
603           // 3 - log the processed part of the contribution
604           totalCentsGathered = totalCentsGathered.add(contributionPart);
605           remainingContribution = remainingContribution.sub(contributionPart);
606 
607           // 4 - advance bonus phase
608           if ((remainingContribution == centsLeftInPhase) && (bonusPhase != BonusPhase.None)) {
609               advanceBonusPhase();
610           }
611 
612         } while (remainingContribution > 0);
613 
614         // add tokens to the beneficiary
615         mintAndUpdate(_beneficiary, _tokens);
616 
617         // if tokens arent equal to bonus
618         if (_tokens > _bonus) {
619           TokensAllocated(_beneficiary, _contribution, _tokens.sub(_bonus));
620         }
621 
622         // if bonus exists
623         if (_bonus > 0) {
624           BonusIssued(_beneficiary, _bonus);
625         }
626     }
627 
628     /**
629      * @dev Issues the rewards for founders and early contributors. 18% and 12% of the total token supply by the end
630      *   of the crowdsale, respectively, including all the token bonuses on early contributions. Can only be
631      *   called after the end of the crowdsale phase, ends the current phase.
632      */
633     function rewardFoundersAndPartners() external onlyManager onlyValidPhase onlyUnpaused {
634         uint tokensDuringThisPhase;
635         if (crowdsalePhase == CrowdsalePhase.PhaseOne) {
636             tokensDuringThisPhase = totalTokenSupply;
637         } else {
638             tokensDuringThisPhase = totalTokenSupply - tokensDuringPhaseOne;
639         }
640 
641         // Total tokens sold is 70% of the overall supply, founders' share is 18%, early contributors' is 12%
642         // So to obtain those from tokens sold, multiply them by 0.18 / 0.7 and 0.12 / 0.7 respectively.
643         uint tokensForFounders = tokensDuringThisPhase.mul(257).div(1000); // 0.257 of 0.7 is 0.18 of 1
644         uint tokensForPartners = tokensDuringThisPhase.mul(171).div(1000); // 0.171 of 0.7 is 0.12 of 1
645 
646         tokenContract.mint(partnersWallet, tokensForPartners);
647 
648         if (crowdsalePhase == CrowdsalePhase.PhaseOne) {
649             vestingWallet = new VestingWallet(foundersWallet, address(tokenContract));
650             tokenContract.mint(address(vestingWallet), tokensForFounders);
651             FoundersAndPartnersTokensIssued(address(vestingWallet), tokensForFounders,
652                                             partnersWallet,         tokensForPartners);
653 
654             // Store the total sum collected during phase one for calculations in phase two.
655             centsInPhaseOne = totalCentsGathered;
656             tokensDuringPhaseOne = totalTokenSupply;
657 
658             // Enable token transfer.
659             tokenContract.unfreeze();
660             crowdsalePhase = CrowdsalePhase.BetweenPhases;
661         } else {
662             tokenContract.mint(address(vestingWallet), tokensForFounders);
663             vestingWallet.launchVesting();
664 
665             FoundersAndPartnersTokensIssued(address(vestingWallet), tokensForFounders,
666                                             partnersWallet,         tokensForPartners);
667             crowdsalePhase = CrowdsalePhase.Finished;
668         }
669 
670         tokenContract.endMinting();
671    }
672 
673     /**
674      * @dev Set the CAPP / USD rate for Phase two, and then start the second phase of token allocation.
675      *        Can only be called by the crowdsale manager.
676      * _tokenRate How many CAPP per 1 USD cent. As dollars, CAPP has two decimals.
677      *            For instance: tokenRate = 125 means "1.25 CAPP per USD cent" <=> "125 CAPP per USD".
678      */
679     function beginPhaseTwo(uint _tokenRate) external onlyManager onlyUnpaused {
680         require(crowdsalePhase == CrowdsalePhase.BetweenPhases);
681         require(_tokenRate != 0);
682 
683         tokenRate = _tokenRate;
684         crowdsalePhase = CrowdsalePhase.PhaseTwo;
685         bonusPhase = BonusPhase.TenPercent;
686         tokenContract.startMinting();
687     }
688 
689     /**
690      * @dev Allows to freeze all token transfers in the future
691      * This is done to allow migrating to new contract in the future
692      * If such need ever arises (ie Migration to ERC23, or anything that community decides worth doing)
693      */
694     function freeze() external onlyUnpaused onlyEmergency {
695         require(crowdsalePhase != CrowdsalePhase.PhaseOne);
696         tokenContract.freeze();
697     }
698 
699     function unfreeze() external onlyUnpaused onlyEmergency {
700         require(crowdsalePhase != CrowdsalePhase.PhaseOne);
701         tokenContract.unfreeze();
702     }
703 
704     // INTERNAL FUNCTIONS
705     // ====================
706     function calculateCentsLeftInPhase(uint _remainingContribution) internal view returns(uint) {
707         // Ten percent bonuses happen in both Phase One and Phase two, therefore:
708         // Take the bonus tier size, subtract the total money gathered in the current phase
709         if (bonusPhase == BonusPhase.TenPercent) {
710             return bonusTierSize.sub(totalCentsGathered.sub(centsInPhaseOne));
711         }
712 
713         if (bonusPhase == BonusPhase.FivePercent) {
714           // Five percent bonuses only happen in Phase One, so no need to account
715           // for the first phase separately.
716           return bonusTierSize.mul(2).sub(totalCentsGathered);
717         }
718 
719         return _remainingContribution;
720     }
721 
722     function mintAndUpdate(address _beneficiary, uint _tokensToMint) internal {
723         tokenContract.mint(_beneficiary, _tokensToMint);
724         totalTokenSupply = totalTokenSupply.add(_tokensToMint);
725     }
726 
727     function calculateTierBonus(uint _contribution) constant internal returns (uint) {
728         // All bonuses are additive and not multiplicative
729         // Calculate bonus on contribution size, then convert it to bonus tokens.
730         uint tierBonus = 0;
731 
732         // tierBonus tier tierBonuses. We make sure in issueTokens that the processed contribution \
733         // falls entirely into one tier
734         if (bonusPhase == BonusPhase.TenPercent) {
735             tierBonus = _contribution.div(10); // multiply by 0.1
736         } else if (bonusPhase == BonusPhase.FivePercent) {
737             tierBonus = _contribution.div(20); // multiply by 0.05
738         }
739 
740         tierBonus = tierBonus.mul(tokenRate);
741         return tierBonus;
742     }
743 
744     function calculateSizeBonus(uint _contribution) constant internal returns (uint) {
745         uint sizeBonus = 0;
746         if (crowdsalePhase == CrowdsalePhase.PhaseOne) {
747             // 10% for huge contribution
748             if (_contribution >= hugeContributionBound) {
749                 sizeBonus = _contribution.div(10); // multiply by 0.1
750             // 5% for big one
751             } else if (_contribution >= bigContributionBound) {
752                 sizeBonus = _contribution.div(20); // multiply by 0.05
753             }
754 
755             sizeBonus = sizeBonus.mul(tokenRate);
756         }
757         return sizeBonus;
758     }
759 
760 
761     /**
762      * @dev Advance the bonus phase to next tier when appropriate, do nothing otherwise.
763      */
764     function advanceBonusPhase() internal onlyValidPhase {
765         if (crowdsalePhase == CrowdsalePhase.PhaseOne) {
766             if (bonusPhase == BonusPhase.TenPercent) {
767                 bonusPhase = BonusPhase.FivePercent;
768             } else if (bonusPhase == BonusPhase.FivePercent) {
769                 bonusPhase = BonusPhase.None;
770             }
771         } else if (bonusPhase == BonusPhase.TenPercent) {
772             bonusPhase = BonusPhase.None;
773         }
774     }
775 
776     function min(uint _a, uint _b) internal pure returns (uint result) {
777         return _a < _b ? _a : _b;
778     }
779 
780     /**
781      * Modifiers
782      */
783     modifier onlyValidPhase() {
784         require( crowdsalePhase == CrowdsalePhase.PhaseOne
785                  || crowdsalePhase == CrowdsalePhase.PhaseTwo );
786         _;
787     }
788 
789     // Do not allow to send money directly to this contract
790     function() payable public {
791         revert();
792     }
793 }