1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * Safe unsigned safe math.
6  *
7  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
8  *
9  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
10  *
11  * Maintained here until merged to mainline zeppelin-solidity.
12  *
13  */
14 library SafeMathLibExt {
15 
16     function times(uint a, uint b) public pure returns (uint) {
17         uint c = a * b;
18         assert(a == 0 || c / a == b);
19         return c;
20     }
21 
22     function divides(uint a, uint b) public pure returns (uint) {
23         assert(b > 0);
24         uint c = a / b;
25         assert(a == b * c + a % b);
26         return c;
27     }
28 
29     function minus(uint a, uint b) public pure returns (uint) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function plus(uint a, uint b) public pure returns (uint) {
35         uint c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 
40 }
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48     address public owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54     * account.
55     */
56     constructor () public {
57         owner = msg.sender;
58     }
59 
60     /**
61     * @dev Throws if called by any account other than the owner.
62     */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69     * @dev Allows the current owner to transfer control of the contract to a newOwner.
70     * @param newOwner The address to transfer ownership to.
71     */
72     function transferOwnership(address newOwner) public onlyOwner {
73         require(newOwner != address(0));
74         emit OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 }
78 
79 /*
80  * Haltable
81  *
82  * Abstract contract that allows children to implement an
83  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
84  *
85  *
86  * Originally envisioned in FirstBlood ICO contract.
87  */
88 contract Haltable is Ownable {
89     bool public halted;
90 
91     modifier stopInEmergency {
92         if (halted) 
93             revert();
94         _;
95     }
96 
97     modifier stopNonOwnersInEmergency {
98         if (halted && msg.sender != owner) 
99             revert();
100         _;
101     }
102 
103     modifier onlyInEmergency {
104         if (!halted) 
105             revert();
106         _;
107     }
108 
109     // called by the owner on emergency, triggers stopped state
110     function halt() external onlyOwner {
111         halted = true;
112     }
113 
114     // called by the owner on end of emergency, returns to normal state
115     function unhalt() external onlyOwner onlyInEmergency {
116         halted = false;
117     }
118 
119 }
120 
121 /**
122  * Interface for defining crowdsale pricing.
123  */
124 contract PricingStrategy {
125 
126     address public tier;
127 
128     /** Interface declaration. */
129     function isPricingStrategy() public pure returns (bool) {
130         return true;
131     }
132 
133     /** Self check if all references are correctly set.
134     *
135     * Checks that pricing strategy matches crowdsale parameters.
136     */
137     function isSane() public pure returns (bool) {
138         return true;
139     }
140 
141     /**
142     * @dev Pricing tells if this is a presale purchase or not.  
143       @return False by default, true if a presale purchaser
144     */
145     function isPresalePurchase() public pure returns (bool) {
146         return false;
147     }
148 
149     /* How many weis one token costs */
150     function updateRate(uint oneTokenInCents) public;
151 
152     /**
153     * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
154     *
155     *
156     * @param value - What is the value of the transaction send in as wei
157     * @param tokensSold - how much tokens have been sold this far
158     * @param decimals - how many decimal units the token has
159     * @return Amount of tokens the investor receives
160     */
161     function calculatePrice(uint value, uint tokensSold, uint decimals) public view returns (uint tokenAmount);
162 
163     function oneTokenInWei(uint tokensSold, uint decimals) public view returns (uint);
164 }
165 
166 /**
167  * Finalize agent defines what happens at the end of succeseful crowdsale.
168  *
169  * - Allocate tokens for founders, bounties and community
170  * - Make tokens transferable
171  * - etc.
172  */
173 contract FinalizeAgent {
174 
175     bool public reservedTokensAreDistributed = false;
176 
177     function isFinalizeAgent() public pure returns(bool) {
178         return true;
179     }
180 
181     /** Return true if we can run finalizeCrowdsale() properly.
182     *
183     * This is a safety check function that doesn't allow crowdsale to begin
184     * unless the finalizer has been set up properly.
185     */
186     function isSane() public view returns (bool);
187 
188     function distributeReservedTokens(uint reservedTokensDistributionBatch) public;
189 
190     /** Called once by crowdsale finalize() if the sale was success. */
191     function finalizeCrowdsale() public;
192     
193     /**
194     * Allow to (re)set Token.
195     */
196     function setCrowdsaleTokenExtv1(address _token) public;
197 }
198 
199 /**
200  * @title ERC20Basic
201  * @dev Simpler version of ERC20 interface
202  * @dev see https://github.com/ethereum/EIPs/issues/179
203  */
204 contract ERC20Basic {
205     uint256 public totalSupply;
206     function balanceOf(address who) public view returns (uint256);
207     function transfer(address to, uint256 value) public returns (bool);
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 }
210 
211 /**
212  * @title ERC20 interface
213  * @dev see https://github.com/ethereum/EIPs/issues/20
214  */
215 contract ERC20 is ERC20Basic {
216     function allowance(address owner, address spender) public view returns (uint256);
217     function transferFrom(address from, address to, uint256 value) public returns (bool);
218     function approve(address spender, uint256 value) public returns (bool);
219     event Approval(address indexed owner, address indexed spender, uint256 value);
220 }
221 
222 /**
223  * A token that defines fractional units as decimals.
224  */
225 contract FractionalERC20Ext is ERC20 {
226     uint public decimals;
227     uint public minCap;
228 }
229 
230 contract Allocatable is Ownable {
231 
232   /** List of agents that are allowed to allocate new tokens */
233     mapping (address => bool) public allocateAgents;
234 
235     event AllocateAgentChanged(address addr, bool state  );
236 
237   /**
238    * Owner can allow a crowdsale contract to allocate new tokens.
239    */
240     function setAllocateAgent(address addr, bool state) public onlyOwner  
241     {
242         allocateAgents[addr] = state;
243         emit AllocateAgentChanged(addr, state);
244     }
245 
246     modifier onlyAllocateAgent() {
247         //Only crowdsale contracts are allowed to allocate new tokens
248         require(allocateAgents[msg.sender]);
249         _;
250     }
251 }
252 
253 /**
254  * Contract to enforce Token Vesting
255  */
256 contract TokenVesting is Allocatable {
257 
258     using SafeMathLibExt for uint;
259 
260     address public crowdSaleTokenAddress;
261 
262     /** keep track of total tokens yet to be released, 
263      * this should be less than or equal to UTIX tokens held by this contract. 
264      */
265     uint256 public totalUnreleasedTokens;
266 
267     // default vesting parameters
268     uint256 private startAt = 0;
269     uint256 private cliff = 1;
270     uint256 private duration = 4; 
271     uint256 private step = 300; //15778463;  //2592000;
272     bool private changeFreezed = false;
273 
274     struct VestingSchedule {
275         uint256 startAt;
276         uint256 cliff;
277         uint256 duration;
278         uint256 step;
279         uint256 amount;
280         uint256 amountReleased;
281         bool changeFreezed;
282     }
283 
284     mapping (address => VestingSchedule) public vestingMap;
285 
286     event VestedTokensReleased(address _adr, uint256 _amount);
287     
288     constructor(address _tokenAddress) public {
289         
290         crowdSaleTokenAddress = _tokenAddress;
291     }
292 
293     /** Modifier to check if changes to vesting is freezed  */
294     modifier changesToVestingFreezed(address _adr) {
295         require(vestingMap[_adr].changeFreezed);
296         _;
297     }
298 
299     /** Modifier to check if changes to vesting is not freezed yet  */
300     modifier changesToVestingNotFreezed(address adr) {
301         require(!vestingMap[adr].changeFreezed); // if vesting not set then also changeFreezed will be false
302         _;
303     }
304 
305     /** Function to set default vesting schedule parameters. */
306     function setDefaultVestingParameters(
307         uint256 _startAt, uint256 _cliff, uint256 _duration,
308         uint256 _step, bool _changeFreezed) public onlyAllocateAgent {
309 
310         // data validation
311         require(_step != 0);
312         require(_duration != 0);
313         require(_cliff <= _duration);
314 
315         startAt = _startAt;
316         cliff = _cliff;
317         duration = _duration; 
318         step = _step;
319         changeFreezed = _changeFreezed;
320 
321     }
322 
323     /** Function to set vesting with default schedule. */
324     function setVestingWithDefaultSchedule(address _adr, uint256 _amount) 
325     public 
326     changesToVestingNotFreezed(_adr) onlyAllocateAgent {
327        
328         setVesting(_adr, startAt, cliff, duration, step, _amount, changeFreezed);
329     }    
330 
331     /** Function to set/update vesting schedule. PS - Amount cannot be changed once set */
332     function setVesting(
333         address _adr,
334         uint256 _startAt,
335         uint256 _cliff,
336         uint256 _duration,
337         uint256 _step,
338         uint256 _amount,
339         bool _changeFreezed) 
340     public changesToVestingNotFreezed(_adr) onlyAllocateAgent {
341 
342         VestingSchedule storage vestingSchedule = vestingMap[_adr];
343 
344         // data validation
345         require(_step != 0);
346         require(_amount != 0 || vestingSchedule.amount > 0);
347         require(_duration != 0);
348         require(_cliff <= _duration);
349 
350         //if startAt is zero, set current time as start time.
351         if (_startAt == 0) 
352             _startAt = block.timestamp;
353 
354         vestingSchedule.startAt = _startAt;
355         vestingSchedule.cliff = _cliff;
356         vestingSchedule.duration = _duration;
357         vestingSchedule.step = _step;
358 
359         // special processing for first time vesting setting
360         if (vestingSchedule.amount == 0) {
361             // check if enough tokens are held by this contract
362             ERC20 token = ERC20(crowdSaleTokenAddress);
363             require(token.balanceOf(this) >= totalUnreleasedTokens.plus(_amount));
364             totalUnreleasedTokens = totalUnreleasedTokens.plus(_amount);
365             vestingSchedule.amount = _amount; 
366         }
367 
368         vestingSchedule.amountReleased = 0;
369         vestingSchedule.changeFreezed = _changeFreezed;
370     }
371 
372     function isVestingSet(address adr) public view returns (bool isSet) {
373         return vestingMap[adr].amount != 0;
374     }
375 
376     function freezeChangesToVesting(address _adr) public changesToVestingNotFreezed(_adr) onlyAllocateAgent {
377         require(isVestingSet(_adr)); // first check if vesting is set
378         vestingMap[_adr].changeFreezed = true;
379     }
380 
381     /** Release tokens as per vesting schedule, called by contributor  */
382     function releaseMyVestedTokens() public changesToVestingFreezed(msg.sender) {
383         releaseVestedTokens(msg.sender);
384     }
385 
386     /** Release tokens as per vesting schedule, called by anyone  */
387     function releaseVestedTokens(address _adr) public changesToVestingFreezed(_adr) {
388         VestingSchedule storage vestingSchedule = vestingMap[_adr];
389         
390         // check if all tokens are not vested
391         require(vestingSchedule.amount.minus(vestingSchedule.amountReleased) > 0);
392         
393         // calculate total vested tokens till now
394         uint256 totalTime = block.timestamp - vestingSchedule.startAt;
395         uint256 totalSteps = totalTime / vestingSchedule.step;
396 
397         // check if cliff is passed
398         require(vestingSchedule.cliff <= totalSteps);
399 
400         uint256 tokensPerStep = vestingSchedule.amount / vestingSchedule.duration;
401         // check if amount is divisble by duration
402         if (tokensPerStep * vestingSchedule.duration != vestingSchedule.amount) tokensPerStep++;
403 
404         uint256 totalReleasableAmount = tokensPerStep.times(totalSteps);
405 
406         // handle the case if user has not claimed even after vesting period is over or amount was not divisible
407         if (totalReleasableAmount > vestingSchedule.amount) totalReleasableAmount = vestingSchedule.amount;
408 
409         uint256 amountToRelease = totalReleasableAmount.minus(vestingSchedule.amountReleased);
410         vestingSchedule.amountReleased = vestingSchedule.amountReleased.plus(amountToRelease);
411 
412         // transfer vested tokens
413         ERC20 token = ERC20(crowdSaleTokenAddress);
414         token.transfer(_adr, amountToRelease);
415         // decrement overall unreleased token count
416         totalUnreleasedTokens = totalUnreleasedTokens.minus(amountToRelease);
417         emit VestedTokensReleased(_adr, amountToRelease);
418     }
419 
420     /**
421     * Allow to (re)set Token.
422     */
423     function setCrowdsaleTokenExtv1(address _token) public onlyAllocateAgent {       
424         crowdSaleTokenAddress = _token;
425     }
426 }
427 
428 /**
429  * Abstract base contract for token sales.
430  *
431  * Handle
432  * - start and end dates
433  * - accepting investments
434  * - minimum funding goal and refund
435  * - various statistics during the crowdfund
436  * - different pricing strategies
437  * - different investment policies (require server side customer id, allow only whitelisted addresses)
438  *
439  */
440 contract CrowdsaleExt is Allocatable, Haltable {
441 
442     /* Max investment count when we are still allowed to change the multisig address */
443     uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
444 
445     using SafeMathLibExt for uint;
446 
447     /* The token we are selling */
448     FractionalERC20Ext public token;
449 
450     /* How we are going to price our offering */
451     PricingStrategy public pricingStrategy;
452 
453     /* Post-success callback */
454     FinalizeAgent public finalizeAgent;
455 
456     TokenVesting public tokenVesting;
457 
458     /* name of the crowdsale tier */
459     string public name;
460 
461     /* tokens will be transfered from this address */
462     address public multisigWallet;
463 
464     /* if the funding goal is not reached, investors may withdraw their funds */
465     uint public minimumFundingGoal;
466 
467     /* the UNIX timestamp start date of the crowdsale */
468     uint public startsAt;
469 
470     /* the UNIX timestamp end date of the crowdsale */
471     uint public endsAt;
472 
473     /* the number of tokens already sold through this contract*/
474     uint public tokensSold = 0;
475 
476     /* How many wei of funding we have raised */
477     uint public weiRaised = 0;
478 
479     /* How many distinct addresses have invested */
480     uint public investorCount = 0;
481 
482     /* Has this crowdsale been finalized */
483     bool public finalized;
484 
485     bool public isWhiteListed;
486 
487       /* Token Vesting Contract */
488     address public tokenVestingAddress;
489 
490     address[] public joinedCrowdsales;
491     uint8 public joinedCrowdsalesLen = 0;
492     uint8 public joinedCrowdsalesLenMax = 50;
493 
494     struct JoinedCrowdsaleStatus {
495         bool isJoined;
496         uint8 position;
497     }
498 
499     mapping (address => JoinedCrowdsaleStatus) public joinedCrowdsaleState;
500 
501     /** How much ETH each address has invested to this crowdsale */
502     mapping (address => uint256) public investedAmountOf;
503 
504     /** How much tokens this crowdsale has credited for each investor address */
505     mapping (address => uint256) public tokenAmountOf;
506 
507     struct WhiteListData {
508         bool status;
509         uint minCap;
510         uint maxCap;
511     }
512 
513     //is crowdsale updatable
514     bool public isUpdatable;
515 
516     /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
517     mapping (address => WhiteListData) public earlyParticipantWhitelist;
518 
519     /** List of whitelisted addresses */
520     address[] public whitelistedParticipants;
521 
522     /** This is for manul testing for the interaction from owner wallet. 
523     You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
524     uint public ownerTestValue;
525 
526     /** State machine
527     *
528     * - Preparing: All contract initialization calls and variables have not been set yet
529     * - Prefunding: We have not passed start time yet
530     * - Funding: Active crowdsale
531     * - Success: Minimum funding goal reached
532     * - Failure: Minimum funding goal not reached before ending time
533     * - Finalized: The finalized has been called and succesfully executed
534     */
535     enum State { Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized }
536 
537     // A new investment was made
538     event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
539 
540     // Address early participation whitelist status changed
541     event Whitelisted(address addr, bool status, uint minCap, uint maxCap);
542     event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);
543 
544     // Crowdsale start time has been changed
545     event StartsAtChanged(uint newStartsAt);
546 
547     // Crowdsale end time has been changed
548     event EndsAtChanged(uint newEndsAt);
549 
550     constructor(string _name, address _token, PricingStrategy _pricingStrategy, 
551     address _multisigWallet, uint _start, uint _end, 
552     uint _minimumFundingGoal, bool _isUpdatable, 
553     bool _isWhiteListed, address _tokenVestingAddress) public {
554 
555         owner = msg.sender;
556 
557         name = _name;
558 
559         tokenVestingAddress = _tokenVestingAddress;
560 
561         token = FractionalERC20Ext(_token);
562 
563         setPricingStrategy(_pricingStrategy);
564 
565         multisigWallet = _multisigWallet;
566         if (multisigWallet == 0) {
567             revert();
568         }
569 
570         if (_start == 0) {
571             revert();
572         }
573 
574         startsAt = _start;
575 
576         if (_end == 0) {
577             revert();
578         }
579 
580         endsAt = _end;
581 
582         // Don't mess the dates
583         if (startsAt >= endsAt) {
584             revert();
585         }
586 
587         // Minimum funding goal can be zero
588         minimumFundingGoal = _minimumFundingGoal;
589 
590         isUpdatable = _isUpdatable;
591 
592         isWhiteListed = _isWhiteListed;
593     }
594 
595     /**
596     * Don't expect to just send in money and get tokens.
597     */
598     function() external payable {
599         buy();
600     }
601 
602     /**
603     * The basic entry point to participate the crowdsale process.
604     *
605     * Pay for funding, get invested tokens back in the sender address.
606     */
607     function buy() public payable {
608         invest(msg.sender);
609     }
610 
611     /**
612     * Allow anonymous contributions to this crowdsale.
613     */
614     function invest(address addr) public payable {
615         investInternal(addr, 0);
616     }
617 
618     /**
619     * Make an investment.
620     *
621     * Crowdsale must be running for one to invest.
622     * We must have not pressed the emergency brake.
623     *
624     * @param receiver The Ethereum address who receives the tokens
625     * @param customerId (optional) UUID v4 to track the successful payments on the server side
626     *
627     */
628     function investInternal(address receiver, uint128 customerId) private stopInEmergency {
629 
630         // Determine if it's a good time to accept investment from this participant
631         if (getState() == State.PreFunding) {
632             // Are we whitelisted for early deposit
633             revert();
634         } else if (getState() == State.Funding) {
635             // Retail participants can only come in when the crowdsale is running
636             // pass
637             if (isWhiteListed) {
638                 if (!earlyParticipantWhitelist[receiver].status) {
639                     revert();
640                 }
641             }
642         } else {
643             // Unwanted state
644             revert();
645         }
646 
647         uint weiAmount = msg.value;
648 
649         // Account presale sales separately, so that they do not count against pricing tranches
650         uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, tokensSold, token.decimals());
651 
652         if (tokenAmount == 0) {
653           // Dust transaction
654             revert();
655         }
656 
657         if (isWhiteListed) {
658             if (weiAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
659               // weiAmount < minCap for investor
660                 revert();
661             }
662 
663             // Check that we did not bust the investor's cap
664             if (isBreakingInvestorCap(receiver, weiAmount)) {
665                 revert();
666             }
667 
668             updateInheritedEarlyParticipantWhitelist(receiver, weiAmount);
669         } else {
670             if (weiAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
671                 revert();
672             }
673         }
674 
675         if (investedAmountOf[receiver] == 0) {
676           // A new investor
677             investorCount++;
678         }
679 
680         // Update investor
681         investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
682         tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
683 
684         // Update totals
685         weiRaised = weiRaised.plus(weiAmount);
686         tokensSold = tokensSold.plus(tokenAmount);
687 
688         // Check that we did not bust the cap
689         if (isBreakingCap(tokensSold)) {
690             revert();
691         }
692 
693         assignTokens(receiver, tokenAmount);
694 
695         // Pocket the money
696         if (!multisigWallet.send(weiAmount)) revert();
697 
698         // Tell us invest was success
699         emit Invested(receiver, weiAmount, tokenAmount, customerId);
700     }
701 
702     /**
703     * allocate tokens for the early investors.
704     *
705     * Preallocated tokens have been sold before the actual crowdsale opens.
706     * This function mints the tokens and moves the crowdsale needle.
707     *
708     * Investor count is not handled; it is assumed this goes for multiple investors
709     * and the token distribution happens outside the smart contract flow.
710     *
711     * No money is exchanged, as the crowdsale team already have received the payment.
712     *
713     * param weiPrice Price of a single full token in wei
714     *
715     */
716     function allocate(address receiver, uint256 tokenAmount, uint128 customerId, uint256 lockedTokenAmount) public onlyAllocateAgent {
717 
718       // cannot lock more than total tokens
719         require(lockedTokenAmount <= tokenAmount);
720         uint weiPrice = pricingStrategy.oneTokenInWei(tokensSold, token.decimals());
721         // This can be also 0, we give out tokens for free
722         uint256 weiAmount = (weiPrice * tokenAmount)/10**uint256(token.decimals());         
723 
724         weiRaised = weiRaised.plus(weiAmount);
725         tokensSold = tokensSold.plus(tokenAmount);
726 
727         investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
728         tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
729 
730         // assign locked token to Vesting contract
731         if (lockedTokenAmount > 0) {
732             tokenVesting = TokenVesting(tokenVestingAddress);
733             // to prevent minting of tokens which will be useless as vesting amount cannot be updated
734             require(!tokenVesting.isVestingSet(receiver));
735             assignTokens(tokenVestingAddress, lockedTokenAmount);
736             // set vesting with default schedule
737             tokenVesting.setVestingWithDefaultSchedule(receiver, lockedTokenAmount); 
738         }
739 
740         // assign remaining tokens to contributor
741         if (tokenAmount - lockedTokenAmount > 0) {
742             assignTokens(receiver, tokenAmount - lockedTokenAmount);
743         }
744 
745         // Tell us invest was success
746         emit Invested(receiver, weiAmount, tokenAmount, customerId);
747     }
748 
749     //
750     // Modifiers
751     //
752     /** Modified allowing execution only if the crowdsale is currently running.  */
753 
754     modifier inState(State state) {
755         if (getState() != state) 
756             revert();
757         _;
758     }
759 
760     function distributeReservedTokens(uint reservedTokensDistributionBatch) 
761     public inState(State.Success) onlyOwner stopInEmergency {
762       // Already finalized
763         if (finalized) {
764             revert();
765         }
766 
767         // Finalizing is optional. We only call it if we are given a finalizing agent.
768         if (address(finalizeAgent) != address(0)) {
769             finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);
770         }
771     }
772 
773     function areReservedTokensDistributed() public view returns (bool) {
774         return finalizeAgent.reservedTokensAreDistributed();
775     }
776 
777     function canDistributeReservedTokens() public view returns(bool) {
778         CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
779         if ((lastTierCntrct.getState() == State.Success) &&
780         !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed())
781             return true;
782         return false;
783     }
784 
785     /**
786     * Finalize a succcesful crowdsale.
787     *
788     * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
789     */
790     function finalize() public inState(State.Success) onlyOwner stopInEmergency {
791 
792       // Already finalized
793         if (finalized) {
794             revert();
795         }
796 
797       // Finalizing is optional. We only call it if we are given a finalizing agent.
798         if (address(finalizeAgent) != address(0)) {
799             finalizeAgent.finalizeCrowdsale();
800         }
801 
802         finalized = true;
803     }
804 
805     /**
806     * Allow to (re)set finalize agent.
807     *
808     * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
809     */
810     function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
811         assert(address(addr) != address(0));
812         assert(address(finalizeAgent) == address(0));
813         finalizeAgent = addr;
814 
815         // Don't allow setting bad agent
816         if (!finalizeAgent.isFinalizeAgent()) {
817             revert();
818         }
819     }
820 
821     /**
822     * Allow addresses to do early participation.
823     */
824     function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {
825         if (!isWhiteListed) revert();
826         assert(addr != address(0));
827         assert(maxCap > 0);
828         assert(minCap <= maxCap);
829         assert(now <= endsAt);
830 
831         if (!isAddressWhitelisted(addr)) {
832             whitelistedParticipants.push(addr);
833             emit Whitelisted(addr, status, minCap, maxCap);
834         } else {
835             emit WhitelistItemChanged(addr, status, minCap, maxCap);
836         }
837 
838         earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
839     }
840 
841     function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) 
842     public onlyOwner {
843         if (!isWhiteListed) revert();
844         assert(now <= endsAt);
845         assert(addrs.length == statuses.length);
846         assert(statuses.length == minCaps.length);
847         assert(minCaps.length == maxCaps.length);
848         for (uint iterator = 0; iterator < addrs.length; iterator++) {
849             setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
850         }
851     }
852 
853     function updateEarlyParticipantWhitelist(address addr, uint weiAmount) public {
854         if (!isWhiteListed) revert();
855         assert(addr != address(0));
856         assert(now <= endsAt);
857         assert(isTierJoined(msg.sender));
858         if (weiAmount < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) revert();
859         //if (addr != msg.sender && contractAddr != msg.sender) throw;
860         uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
861         newMaxCap = newMaxCap.minus(weiAmount);
862         earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
863     }
864 
865     function updateInheritedEarlyParticipantWhitelist(address reciever, uint weiAmount) private {
866         if (!isWhiteListed) revert();
867         if (weiAmount < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) revert();
868 
869         uint8 tierPosition = getTierPosition(this);
870 
871         for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
872             CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
873             crowdsale.updateEarlyParticipantWhitelist(reciever, weiAmount);
874         }
875     }
876 
877     function isAddressWhitelisted(address addr) public view returns(bool) {
878         for (uint i = 0; i < whitelistedParticipants.length; i++) {
879             if (whitelistedParticipants[i] == addr) {
880                 return true;
881                 break;
882             }
883         }
884 
885         return false;
886     }
887 
888     function whitelistedParticipantsLength() public view returns (uint) {
889         return whitelistedParticipants.length;
890     }
891 
892     function isTierJoined(address addr) public view returns(bool) {
893         return joinedCrowdsaleState[addr].isJoined;
894     }
895 
896     function getTierPosition(address addr) public view returns(uint8) {
897         return joinedCrowdsaleState[addr].position;
898     }
899 
900     function getLastTier() public view returns(address) {
901         if (joinedCrowdsalesLen > 0)
902             return joinedCrowdsales[joinedCrowdsalesLen - 1];
903         else
904             return address(0);
905     }
906 
907     function setJoinedCrowdsales(address addr) private onlyOwner {
908         assert(addr != address(0));
909         assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);
910         assert(!isTierJoined(addr));
911         joinedCrowdsales.push(addr);
912         joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({
913             isJoined: true,
914             position: joinedCrowdsalesLen
915         });
916         joinedCrowdsalesLen++;
917     }
918 
919     function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {
920         assert(addrs.length > 0);
921         assert(joinedCrowdsalesLen == 0);
922         assert(addrs.length <= joinedCrowdsalesLenMax);
923         for (uint8 iter = 0; iter < addrs.length; iter++) {
924             setJoinedCrowdsales(addrs[iter]);
925         }
926     }
927 
928     function setStartsAt(uint time) public onlyOwner {
929         assert(!finalized);
930         assert(isUpdatable);
931         assert(now <= time); // Don't change past
932         assert(time <= endsAt);
933         assert(now <= startsAt);
934 
935         CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
936         if (lastTierCntrct.finalized()) revert();
937 
938         uint8 tierPosition = getTierPosition(this);
939 
940         //start time should be greater then end time of previous tiers
941         for (uint8 j = 0; j < tierPosition; j++) {
942             CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
943             assert(time >= crowdsale.endsAt());
944         }
945 
946         startsAt = time;
947         emit StartsAtChanged(startsAt);
948     }
949 
950     /**
951     * Allow crowdsale owner to close early or extend the crowdsale.
952     *
953     * This is useful e.g. for a manual soft cap implementation:
954     * - after X amount is reached determine manual closing
955     *
956     * This may put the crowdsale to an invalid state,
957     * but we trust owners know what they are doing.
958     *
959     */
960     function setEndsAt(uint time) public onlyOwner {
961         assert(!finalized);
962         assert(isUpdatable);
963         assert(now <= time);// Don't change past
964         assert(startsAt <= time);
965         assert(now <= endsAt);
966 
967         CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
968         if (lastTierCntrct.finalized()) revert();
969 
970 
971         uint8 tierPosition = getTierPosition(this);
972 
973         for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {
974             CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
975             assert(time <= crowdsale.startsAt());
976         }
977 
978         endsAt = time;
979         emit EndsAtChanged(endsAt);
980     }
981 
982     /**
983     * Allow to (re)set pricing strategy.
984     *
985     * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
986     */
987     function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
988         assert(address(_pricingStrategy) != address(0));
989         assert(address(pricingStrategy) == address(0));
990         pricingStrategy = _pricingStrategy;
991 
992         // Don't allow setting bad agent
993         if (!pricingStrategy.isPricingStrategy()) {
994             revert();
995         }
996     }
997 
998     /**
999     * Allow to (re)set Token.
1000     * @param _token upgraded token address
1001     */
1002     function setCrowdsaleTokenExtv1(address _token) public onlyOwner {
1003         assert(_token != address(0));
1004         token = FractionalERC20Ext(_token);
1005         
1006         if (address(finalizeAgent) != address(0)) {
1007             finalizeAgent.setCrowdsaleTokenExtv1(_token);
1008         }
1009     }
1010 
1011     /**
1012     * Allow to change the team multisig address in the case of emergency.
1013     *
1014     * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
1015     * (we have done only few test transactions). After the crowdsale is going
1016     * then multisig address stays locked for the safety reasons.
1017     */
1018     function setMultisig(address addr) public onlyOwner {
1019 
1020       // Change
1021         if (investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
1022             revert();
1023         }
1024 
1025         multisigWallet = addr;
1026     }
1027 
1028     /**
1029     * @return true if the crowdsale has raised enough money to be a successful.
1030     */
1031     function isMinimumGoalReached() public view returns (bool reached) {
1032         return weiRaised >= minimumFundingGoal;
1033     }
1034 
1035     /**
1036     * Check if the contract relationship looks good.
1037     */
1038     function isFinalizerSane() public view returns (bool sane) {
1039         return finalizeAgent.isSane();
1040     }
1041 
1042     /**
1043     * Check if the contract relationship looks good.
1044     */
1045     function isPricingSane() public view returns (bool sane) {
1046         return pricingStrategy.isSane();
1047     }
1048 
1049     /**
1050     * Crowdfund state machine management.
1051     *
1052     * We make it a function and do not assign the result to a variable, 
1053     * so there is no chance of the variable being stale.
1054     */
1055     function getState() public view returns (State) {
1056         if(finalized) return State.Finalized;
1057         else if (address(finalizeAgent) == 0) return State.Preparing;
1058         else if (!finalizeAgent.isSane()) return State.Preparing;
1059         else if (!pricingStrategy.isSane()) return State.Preparing;
1060         else if (block.timestamp < startsAt) return State.PreFunding;
1061         else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1062         else if (isMinimumGoalReached()) return State.Success;
1063         else return State.Failure;
1064     }
1065 
1066     /** Interface marker. */
1067     function isCrowdsale() public pure returns (bool) {
1068         return true;
1069     }
1070 
1071     //
1072     // Abstract functions
1073     //
1074 
1075     /**
1076     * Check if the current invested breaks our cap rules.
1077     *
1078     *
1079     * The child contract must define their own cap setting rules.
1080     * We allow a lot of flexibility through different capping strategies (ETH, token count)
1081     * Called from invest().
1082     *  
1083     * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1084     *
1085     * @return true if taking this investment would break our cap rules
1086     */
1087     function isBreakingCap(uint tokensSoldTotal) public view returns (bool limitBroken);
1088 
1089     function isBreakingInvestorCap(address receiver, uint tokenAmount) public view returns (bool limitBroken);
1090 
1091     /**
1092     * Check if the current crowdsale is full and we can no longer sell any tokens.
1093     */
1094     function isCrowdsaleFull() public view returns (bool);
1095 
1096     /**
1097     * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1098     */
1099     function assignTokens(address receiver, uint tokenAmount) private;
1100 }
1101 
1102 /**
1103  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
1104  *
1105  * Based on code by FirstBlood:
1106  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1107  */
1108 contract StandardToken is ERC20 {
1109 
1110     using SafeMathLibExt for uint;
1111     /* Token supply got increased and a new owner received these tokens */
1112     event Minted(address receiver, uint amount);
1113 
1114     /* Actual balances of token holders */
1115     mapping(address => uint) public balances;
1116 
1117     /* approve() allowances */
1118     mapping (address => mapping (address => uint)) public allowed;
1119 
1120     /* Interface declaration */
1121     function isToken() public pure returns (bool weAre) {
1122         return true;
1123     }
1124 
1125     function transfer(address _to, uint _value) public returns (bool success) {
1126         balances[msg.sender] = balances[msg.sender].minus(_value);
1127         balances[_to] = balances[_to].plus(_value);
1128         emit Transfer(msg.sender, _to, _value);
1129         return true;
1130     }
1131 
1132     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
1133         uint _allowance = allowed[_from][msg.sender];
1134 
1135         balances[_to] = balances[_to].plus(_value);
1136         balances[_from] = balances[_from].minus(_value);
1137         allowed[_from][msg.sender] = _allowance.minus(_value);
1138         emit Transfer(_from, _to, _value);
1139         return true;
1140     }
1141 
1142     function balanceOf(address _owner) public view returns (uint balance) {
1143         return balances[_owner];
1144     }
1145 
1146     function approve(address _spender, uint _value) public returns (bool success) {
1147 
1148         // To change the approve amount you first have to reduce the addresses`
1149         //  allowance to zero by calling `approve(_spender, 0)` if it is not
1150         //  already 0 to mitigate the race condition described here:
1151         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1152         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
1153 
1154         allowed[msg.sender][_spender] = _value;
1155         emit Approval(msg.sender, _spender, _value);
1156         return true;
1157     }
1158 
1159     function allowance(address _owner, address _spender) public view returns (uint remaining) {
1160         return allowed[_owner][_spender];
1161     }
1162 
1163 }
1164 
1165 /**
1166  * A token that can increase its supply by another contract.
1167  *
1168  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
1169  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
1170  *
1171  */
1172 contract MintableTokenExt is StandardToken, Ownable {
1173 
1174     using SafeMathLibExt for uint;
1175 
1176     bool public mintingFinished = false;
1177 
1178     /** List of agents that are allowed to create new tokens */
1179     mapping (address => bool) public mintAgents;
1180 
1181     event MintingAgentChanged(address addr, bool state  );
1182 
1183     /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
1184     * For example, for reserved tokens in percents 2.54%
1185     * inPercentageUnit = 254
1186     * inPercentageDecimals = 2
1187     */
1188     struct ReservedTokensData {
1189         uint inTokens;
1190         uint inPercentageUnit;
1191         uint inPercentageDecimals;
1192         bool isReserved;
1193         bool isDistributed;
1194         bool isVested;
1195     }
1196 
1197     mapping (address => ReservedTokensData) public reservedTokensList;
1198     address[] public reservedTokensDestinations;
1199     uint public reservedTokensDestinationsLen = 0;
1200     bool private reservedTokensDestinationsAreSet = false;
1201 
1202     modifier onlyMintAgent() {
1203         // Only crowdsale contracts are allowed to mint new tokens
1204         if (!mintAgents[msg.sender]) {
1205             revert();
1206         }
1207         _;
1208     }
1209 
1210     /** Make sure we are not done yet. */
1211     modifier canMint() {
1212         if (mintingFinished) revert();
1213         _;
1214     }
1215 
1216     function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
1217         ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
1218         reservedTokensData.isDistributed = true;
1219     }
1220 
1221     function isAddressReserved(address addr) public view returns (bool isReserved) {
1222         return reservedTokensList[addr].isReserved;
1223     }
1224 
1225     function areTokensDistributedForAddress(address addr) public view returns (bool isDistributed) {
1226         return reservedTokensList[addr].isDistributed;
1227     }
1228 
1229     function getReservedTokens(address addr) public view returns (uint inTokens) {
1230         return reservedTokensList[addr].inTokens;
1231     }
1232 
1233     function getReservedPercentageUnit(address addr) public view returns (uint inPercentageUnit) {
1234         return reservedTokensList[addr].inPercentageUnit;
1235     }
1236 
1237     function getReservedPercentageDecimals(address addr) public view returns (uint inPercentageDecimals) {
1238         return reservedTokensList[addr].inPercentageDecimals;
1239     }
1240 
1241     function getReservedIsVested(address addr) public view returns (bool isVested) {
1242         return reservedTokensList[addr].isVested;
1243     }
1244 
1245     function setReservedTokensListMultiple(
1246         address[] addrs, 
1247         uint[] inTokens, 
1248         uint[] inPercentageUnit, 
1249         uint[] inPercentageDecimals,
1250         bool[] isVested
1251         ) public canMint onlyOwner {
1252         assert(!reservedTokensDestinationsAreSet);
1253         assert(addrs.length == inTokens.length);
1254         assert(inTokens.length == inPercentageUnit.length);
1255         assert(inPercentageUnit.length == inPercentageDecimals.length);
1256         for (uint iterator = 0; iterator < addrs.length; iterator++) {
1257             if (addrs[iterator] != address(0)) {
1258                 setReservedTokensList(
1259                     addrs[iterator],
1260                     inTokens[iterator],
1261                     inPercentageUnit[iterator],
1262                     inPercentageDecimals[iterator],
1263                     isVested[iterator]
1264                     );
1265             }
1266         }
1267         reservedTokensDestinationsAreSet = true;
1268     }
1269 
1270     /**
1271     * Create new tokens and allocate them to an address..
1272     *
1273     * Only callably by a crowdsale contract (mint agent).
1274     */
1275     function mint(address receiver, uint amount) public onlyMintAgent canMint {
1276         totalSupply = totalSupply.plus(amount);
1277         balances[receiver] = balances[receiver].plus(amount);
1278 
1279         // This will make the mint transaction apper in EtherScan.io
1280         // We can remove this after there is a standardized minting event
1281         emit Transfer(0, receiver, amount);
1282     }
1283 
1284     /**
1285     * Owner can allow a crowdsale contract to mint new tokens.
1286     */
1287     function setMintAgent(address addr, bool state) public onlyOwner canMint {
1288         mintAgents[addr] = state;
1289         emit MintingAgentChanged(addr, state);
1290     }
1291 
1292     function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals,bool isVested) 
1293     private canMint onlyOwner {
1294         assert(addr != address(0));
1295         if (!isAddressReserved(addr)) {
1296             reservedTokensDestinations.push(addr);
1297             reservedTokensDestinationsLen++;
1298         }
1299 
1300         reservedTokensList[addr] = ReservedTokensData({
1301             inTokens: inTokens,
1302             inPercentageUnit: inPercentageUnit,
1303             inPercentageDecimals: inPercentageDecimals,
1304             isReserved: true,
1305             isDistributed: false,
1306             isVested:isVested
1307         });
1308     }
1309 }
1310 
1311 /**
1312  * ICO crowdsale contract that is capped by amout of tokens.
1313  *
1314  * - Tokens are dynamically created during the crowdsale
1315  *
1316  *
1317  */
1318 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1319 
1320     /* Maximum amount of tokens this crowdsale can sell. */
1321     uint public maximumSellableTokens;
1322 
1323     constructor(
1324         string _name,
1325         address _token,
1326         PricingStrategy _pricingStrategy,
1327         address _multisigWallet,
1328         uint _start, uint _end,
1329         uint _minimumFundingGoal,
1330         uint _maximumSellableTokens,
1331         bool _isUpdatable,
1332         bool _isWhiteListed,
1333         address _tokenVestingAddress
1334     ) public CrowdsaleExt(_name, _token, _pricingStrategy, _multisigWallet, _start, _end,
1335     _minimumFundingGoal, _isUpdatable, _isWhiteListed, _tokenVestingAddress) {
1336         maximumSellableTokens = _maximumSellableTokens;
1337     }
1338 
1339     // Crowdsale maximumSellableTokens has been changed
1340     event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1341 
1342     /**
1343     * Called from invest() to confirm if the curret investment does not break our cap rule.
1344     */
1345     function isBreakingCap(uint tokensSoldTotal) public view returns (bool limitBroken) {
1346         return tokensSoldTotal > maximumSellableTokens;
1347     }
1348 
1349     function isBreakingInvestorCap(address addr, uint weiAmount) public view returns (bool limitBroken) {
1350         assert(isWhiteListed);
1351         uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1352         return (investedAmountOf[addr].plus(weiAmount)) > maxCap;
1353     }
1354 
1355     function isCrowdsaleFull() public view returns (bool) {
1356         return tokensSold >= maximumSellableTokens;
1357     }
1358 
1359     function setMaximumSellableTokens(uint tokens) public onlyOwner {
1360         assert(!finalized);
1361         assert(isUpdatable);
1362         assert(now <= startsAt);
1363 
1364         CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1365         assert(!lastTierCntrct.finalized());
1366 
1367         maximumSellableTokens = tokens;
1368         emit MaximumSellableTokensChanged(maximumSellableTokens);
1369     }
1370 
1371     function updateRate(uint oneTokenInCents) public onlyOwner {
1372         assert(!finalized);
1373         assert(isUpdatable);
1374         assert(now <= startsAt);
1375 
1376         CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
1377         assert(!lastTierCntrct.finalized());
1378 
1379         pricingStrategy.updateRate(oneTokenInCents);
1380     }
1381 
1382     /**
1383     * Dynamically create tokens and assign them to the investor.
1384     */
1385     function assignTokens(address receiver, uint tokenAmount) private {
1386         MintableTokenExt mintableToken = MintableTokenExt(token);
1387         mintableToken.mint(receiver, tokenAmount);
1388     }    
1389 }
1390 
1391 /**
1392  * ICO crowdsale contract that is capped by amout of tokens.
1393  *
1394  * - Tokens are dynamically created during the crowdsale
1395  *
1396  *
1397  */
1398 contract MintedTokenCappedCrowdsaleExtv1 is MintedTokenCappedCrowdsaleExt {
1399 
1400     address[] public investedAmountOfAddresses;
1401     MintedTokenCappedCrowdsaleExt public mintedTokenCappedCrowdsaleExt;
1402 
1403     constructor(
1404         string _name,
1405         address _token,
1406         PricingStrategy _pricingStrategy,
1407         address _multisigWallet,
1408         uint _start, uint _end,
1409         uint _minimumFundingGoal,
1410         uint _maximumSellableTokens,
1411         bool _isUpdatable,
1412         bool _isWhiteListed,
1413         address _tokenVestingAddress,
1414         MintedTokenCappedCrowdsaleExt _oldMintedTokenCappedCrowdsaleExtAddress
1415     ) public MintedTokenCappedCrowdsaleExt(_name, _token, _pricingStrategy, _multisigWallet, _start, _end,
1416     _minimumFundingGoal, _maximumSellableTokens, _isUpdatable, _isWhiteListed, _tokenVestingAddress) {
1417         
1418         mintedTokenCappedCrowdsaleExt = _oldMintedTokenCappedCrowdsaleExtAddress;
1419         tokensSold = mintedTokenCappedCrowdsaleExt.tokensSold();
1420         weiRaised = mintedTokenCappedCrowdsaleExt.weiRaised();
1421         investorCount = mintedTokenCappedCrowdsaleExt.investorCount();        
1422 
1423         
1424         for (uint i = 0; i < mintedTokenCappedCrowdsaleExt.whitelistedParticipantsLength(); i++) {
1425             address whitelistAddress = mintedTokenCappedCrowdsaleExt.whitelistedParticipants(i);
1426 
1427             //whitelistedParticipants.push(whitelistAddress);
1428 
1429             uint256 tokenAmount = mintedTokenCappedCrowdsaleExt.tokenAmountOf(whitelistAddress);
1430             if (tokenAmount != 0){               
1431                 tokenAmountOf[whitelistAddress] = tokenAmount;               
1432             }
1433 
1434             uint256 investedAmount = mintedTokenCappedCrowdsaleExt.investedAmountOf(whitelistAddress);
1435             if (investedAmount != 0){
1436                 investedAmountOf[whitelistAddress] = investedAmount;               
1437             }
1438 
1439             //setEarlyParticipantWhitelist(whitelistAddress, true, 1000000000000000000, 1000000000000000000000);
1440         }
1441     }
1442     
1443 }