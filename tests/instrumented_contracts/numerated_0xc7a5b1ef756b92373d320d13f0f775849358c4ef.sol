1 pragma solidity ^0.4.13;
2 
3 contract FinalizeAgent {
4 
5   function isFinalizeAgent() public constant returns(bool) {
6     return true;
7   }
8 
9   /** Return true if we can run finalizeCrowdsale() properly.
10    *
11    * This is a safety check function that doesn't allow crowdsale to begin
12    * unless the finalizer has been set up properly.
13    */
14   function isSane() public constant returns (bool);
15 
16   /** Called once by crowdsale finalize() if the sale was success. */
17   function finalizeCrowdsale();
18 
19 }
20 
21 contract ERC20Basic {
22   uint256 public totalSupply;
23   function balanceOf(address who) constant returns (uint256);
24   function transfer(address to, uint256 value) returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 library SafeMathLib {
29 
30   function times(uint a, uint b) returns (uint) {
31     uint c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function minus(uint a, uint b) returns (uint) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function plus(uint a, uint b) returns (uint) {
42     uint c = a + b;
43     assert(c>=a);
44     return c;
45   }
46 
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) onlyOwner {
76     require(newOwner != address(0));      
77     owner = newOwner;
78   }
79 
80 }
81 
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) constant returns (uint256);
84   function transferFrom(address from, address to, uint256 value) returns (bool);
85   function approve(address spender, uint256 value) returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 contract FractionalERC20 is ERC20 {
90 
91   uint public decimals;
92 
93 }
94 
95 library SafeMath {
96   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
97     uint256 c = a * b;
98     assert(a == 0 || c / a == b);
99     return c;
100   }
101 
102   function div(uint256 a, uint256 b) internal constant returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   function add(uint256 a, uint256 b) internal constant returns (uint256) {
115     uint256 c = a + b;
116     assert(c >= a);
117     return c;
118   }
119 }
120 
121 contract PricingStrategy {
122 
123   /** Interface declaration. */
124   function isPricingStrategy() public constant returns (bool) {
125     return true;
126   }
127 
128   /** Self check if all references are correctly set.
129    *
130    * Checks that pricing strategy matches crowdsale parameters.
131    */
132   function isSane(address crowdsale) public constant returns (bool) {
133     return true;
134   }
135 
136   /**
137    * @dev Pricing tells if this is a presale purchase or not.
138      @param purchaser Address of the purchaser
139      @return False by default, true if a presale purchaser
140    */
141   function isPresalePurchase(address purchaser) public constant returns (bool) {
142     return false;
143   }
144 
145   /**
146    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
147    *
148    *
149    * @param value - What is the value of the transaction send in as wei
150    * @param tokensSold - how much tokens have been sold this far
151    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
152    * @param msgSender - who is the investor of this transaction
153    * @param decimals - how many decimal units the token has
154    * @return Amount of tokens the investor receives
155    */
156   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
157 }
158 
159 contract Haltable is Ownable {
160   bool public halted;
161 
162   modifier stopInEmergency {
163     if (halted) throw;
164     _;
165   }
166 
167   modifier stopNonOwnersInEmergency {
168     if (halted && msg.sender != owner) throw;
169     _;
170   }
171 
172   modifier onlyInEmergency {
173     if (!halted) throw;
174     _;
175   }
176 
177   // called by the owner on emergency, triggers stopped state
178   function halt() external onlyOwner {
179     halted = true;
180   }
181 
182   // called by the owner on end of emergency, returns to normal state
183   function unhalt() external onlyOwner onlyInEmergency {
184     halted = false;
185   }
186 
187 }
188 
189 contract PreICOProxyBuyer is Ownable, Haltable {
190   using SafeMath for uint;
191 
192   /** How many investors we have now */
193   uint public investorCount;
194 
195   /** How many wei we have raised totla. */
196   uint public weiRaised;
197 
198   /** Who are our investors (iterable) */
199   address[] public investors;
200 
201   /** How much they have invested */
202   mapping(address => uint) public balances;
203 
204   /** How many tokens investors have claimed */
205   mapping(address => uint) public claimed;
206 
207   /** When our refund freeze is over (UNIT timestamp) */
208   uint public freezeEndsAt;
209 
210   /** What is the minimum buy in */
211   uint public weiMinimumLimit;
212 
213   /** What is the maximum buy in */
214   uint public weiMaximumLimit;
215 
216   /** How many weis total we are allowed to collect. */
217   uint public weiCap;
218 
219   /** How many tokens were bought */
220   uint public tokensBought;
221 
222    /** How many investors have claimed their tokens */
223   uint public claimCount;
224 
225   uint public totalClaimed;
226 
227   /** If timeLock > 0, claiming is possible only after the time has passed **/
228   uint public timeLock;
229 
230   /** This is used to signal that we want the refund **/
231   bool public forcedRefund;
232 
233   /** Our ICO contract where we will move the funds */
234   Crowdsale public crowdsale;
235 
236   /** What is our current state. */
237   enum State{Unknown, Funding, Distributing, Refunding}
238 
239   /** Somebody loaded their investment money */
240   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
241 
242   /** Refund claimed */
243   event Refunded(address investor, uint value);
244 
245   /** We executed our buy */
246   event TokensBoughts(uint count);
247 
248   /** We distributed tokens to an investor */
249   event Distributed(address investor, uint count);
250 
251   /**
252    * Create presale contract where lock up period is given days
253    */
254   function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiMaximumLimit, uint _weiCap) {
255 
256     owner = _owner;
257 
258     // Give argument
259     if(_freezeEndsAt == 0) {
260       throw;
261     }
262 
263     // Give argument
264     if(_weiMinimumLimit == 0) {
265       throw;
266     }
267 
268     if(_weiMaximumLimit == 0) {
269       throw;
270     }
271 
272     weiMinimumLimit = _weiMinimumLimit;
273     weiMaximumLimit = _weiMaximumLimit;
274     weiCap = _weiCap;
275     freezeEndsAt = _freezeEndsAt;
276   }
277 
278   /**
279    * Get the token we are distributing.
280    */
281   function getToken() public constant returns(FractionalERC20) {
282     if(address(crowdsale) == 0)  {
283       throw;
284     }
285 
286     return crowdsale.token();
287   }
288 
289   /**
290    * Participate to a presale.
291    */
292   function invest(uint128 customerId) private {
293 
294     // Cannot invest anymore through crowdsale when moving has begun
295     if(getState() != State.Funding) throw;
296 
297     if(msg.value == 0) throw; // No empty buys
298 
299     address investor = msg.sender;
300 
301     bool existing = balances[investor] > 0;
302 
303     balances[investor] = balances[investor].add(msg.value);
304 
305     // Need to satisfy minimum and maximum limits
306     if(balances[investor] < weiMinimumLimit || balances[investor] > weiMaximumLimit) {
307       throw;
308     }
309 
310     // This is a new investor
311     if(!existing) {
312       investors.push(investor);
313       investorCount++;
314     }
315 
316     weiRaised = weiRaised.add(msg.value);
317     if(weiRaised > weiCap) {
318       throw;
319     }
320 
321     // We will use the same event form the Crowdsale for compatibility reasons
322     // despite not having a token amount.
323     Invested(investor, msg.value, 0, customerId);
324   }
325 
326   function buyWithCustomerId(uint128 customerId) public stopInEmergency payable {
327     invest(customerId);
328   }
329 
330   function buy() public stopInEmergency payable {
331     invest(0x0);
332   }
333 
334 
335   /**
336    * Load funds to the crowdsale for all investors.
337    *
338    *
339    */
340   function buyForEverybody() stopNonOwnersInEmergency public {
341 
342     if(getState() != State.Funding) {
343       // Only allow buy once
344       throw;
345     }
346 
347     // Crowdsale not yet set
348     if(address(crowdsale) == 0) throw;
349 
350     // Buy tokens on the contract
351     crowdsale.invest.value(weiRaised)(address(this));
352 
353     // Record how many tokens we got
354     tokensBought = getToken().balanceOf(address(this));
355 
356     if(tokensBought == 0) {
357       // Did not get any tokens
358       throw;
359     }
360 
361     TokensBoughts(tokensBought);
362   }
363 
364   /**
365    * How may tokens each investor gets.
366    */
367   function getClaimAmount(address investor) public constant returns (uint) {
368 
369     // Claims can be only made if we manage to buy tokens
370     if(getState() != State.Distributing) {
371       throw;
372     }
373     return balances[investor].mul(tokensBought) / weiRaised;
374   }
375 
376   /**
377    * How many tokens remain unclaimed for an investor.
378    */
379   function getClaimLeft(address investor) public constant returns (uint) {
380     return getClaimAmount(investor).sub(claimed[investor]);
381   }
382 
383   /**
384    * Claim all remaining tokens for this investor.
385    */
386   function claimAll() {
387     claim(getClaimLeft(msg.sender));
388   }
389 
390   /**
391    * Claim N bought tokens to the investor as the msg sender.
392    *
393    */
394   function claim(uint amount) stopInEmergency {
395     require (now > timeLock);
396 
397     address investor = msg.sender;
398 
399     if(amount == 0) {
400       throw;
401     }
402 
403     if(getClaimLeft(investor) < amount) {
404       // Woops we cannot get more than we have left
405       throw;
406     }
407 
408     // We track who many investor have (partially) claimed their tokens
409     if(claimed[investor] == 0) {
410       claimCount++;
411     }
412 
413     claimed[investor] = claimed[investor].add(amount);
414     totalClaimed = totalClaimed.add(amount);
415     getToken().transfer(investor, amount);
416 
417     Distributed(investor, amount);
418   }
419 
420   /**
421    * ICO never happened. Allow refund.
422    */
423   function refund() stopInEmergency {
424 
425     // Trying to ask refund too soon
426     if(getState() != State.Refunding) throw;
427 
428     address investor = msg.sender;
429     if(balances[investor] == 0) throw;
430     uint amount = balances[investor];
431     delete balances[investor];
432     if(!(investor.call.value(amount)())) throw;
433     Refunded(investor, amount);
434   }
435 
436   /**
437    * Set the target crowdsale where we will move presale funds when the crowdsale opens.
438    */
439   function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {
440     crowdsale = _crowdsale;
441 
442     // Check interface
443     if(!crowdsale.isCrowdsale()) true;
444   }
445 
446   /// @dev Setting timelock (delay) for claiming
447   /// @param _timeLock Time after which claiming is possible
448   function setTimeLock(uint _timeLock) public onlyOwner {
449     timeLock = _timeLock;
450   }
451 
452   /// @dev This is used in the first case scenario, this will force the state
453   ///      to refunding. This can be also used when the ICO fails to meet the cap.
454   function forceRefund() public onlyOwner {
455     forcedRefund = true;
456   }
457 
458   /// @dev This should be used if the Crowdsale fails, to receive the refuld money.
459   ///      we can't use Crowdsale's refund, since our default function does not
460   ///      accept money in.
461   function loadRefund() public payable {
462     if(getState() != State.Refunding) throw;
463   }
464 
465   /**
466    * Resolve the contract umambigious state.
467    */
468   function getState() public returns(State) {
469     if (forcedRefund)
470       return State.Refunding;
471 
472     if(tokensBought == 0) {
473       if(now >= freezeEndsAt) {
474          return State.Refunding;
475       } else {
476         return State.Funding;
477       }
478     } else {
479       return State.Distributing;
480     }
481   }
482 
483   /** Interface marker. */
484   function isPresale() public constant returns (bool) {
485     return true;
486   }
487 
488   /** Explicitly call function from your wallet. */
489   function() payable {
490     throw;
491   }
492 }
493 
494 contract CrowdsaleBase is Haltable {
495 
496   /* Max investment count when we are still allowed to change the multisig address */
497   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
498 
499   using SafeMathLib for uint;
500 
501   /* The token we are selling */
502   FractionalERC20 public token;
503 
504   /* How we are going to price our offering */
505   PricingStrategy public pricingStrategy;
506 
507   /* Post-success callback */
508   FinalizeAgent public finalizeAgent;
509 
510   /* tokens will be transfered from this address */
511   address public multisigWallet;
512 
513   /* if the funding goal is not reached, investors may withdraw their funds */
514   uint public minimumFundingGoal;
515 
516   /* the UNIX timestamp start date of the crowdsale */
517   uint public startsAt;
518 
519   /* the UNIX timestamp end date of the crowdsale */
520   uint public endsAt;
521 
522   /* the number of tokens already sold through this contract*/
523   uint public tokensSold = 0;
524 
525   /* How many wei of funding we have raised */
526   uint public weiRaised = 0;
527 
528   /* Calculate incoming funds from presale contracts and addresses */
529   uint public presaleWeiRaised = 0;
530 
531   /* How many distinct addresses have invested */
532   uint public investorCount = 0;
533 
534   /* How much wei we have returned back to the contract after a failed crowdfund. */
535   uint public loadedRefund = 0;
536 
537   /* How much wei we have given back to investors.*/
538   uint public weiRefunded = 0;
539 
540   /* Has this crowdsale been finalized */
541   bool public finalized;
542 
543   /** How much ETH each address has invested to this crowdsale */
544   mapping (address => uint256) public investedAmountOf;
545 
546   /** How much tokens this crowdsale has credited for each investor address */
547   mapping (address => uint256) public tokenAmountOf;
548 
549   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
550   mapping (address => bool) public earlyParticipantWhitelist;
551 
552   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
553   uint public ownerTestValue;
554 
555   /** State machine
556    *
557    * - Preparing: All contract initialization calls and variables have not been set yet
558    * - Prefunding: We have not passed start time yet
559    * - Funding: Active crowdsale
560    * - Success: Minimum funding goal reached
561    * - Failure: Minimum funding goal not reached before ending time
562    * - Finalized: The finalized has been called and succesfully executed
563    * - Refunding: Refunds are loaded on the contract for reclaim.
564    */
565   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
566 
567   // A new investment was made
568   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
569 
570   // Refund was processed for a contributor
571   event Refund(address investor, uint weiAmount);
572 
573   // The rules were changed what kind of investments we accept
574   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
575 
576   // Address early participation whitelist status changed
577   event Whitelisted(address addr, bool status);
578 
579   // Crowdsale end time has been changed
580   event EndsAtChanged(uint newEndsAt);
581 
582   State public testState;
583 
584   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
585 
586     owner = msg.sender;
587 
588     token = FractionalERC20(_token);
589 
590     setPricingStrategy(_pricingStrategy);
591 
592     multisigWallet = _multisigWallet;
593     if(multisigWallet == 0) {
594         throw;
595     }
596 
597     if(_start == 0) {
598         throw;
599     }
600 
601     startsAt = _start;
602 
603     if(_end == 0) {
604         throw;
605     }
606 
607     endsAt = _end;
608 
609     // Don't mess the dates
610     if(startsAt >= endsAt) {
611         throw;
612     }
613 
614     // Minimum funding goal can be zero
615     minimumFundingGoal = _minimumFundingGoal;
616   }
617 
618   /**
619    * Don't expect to just send in money and get tokens.
620    */
621   function() payable {
622     throw;
623   }
624 
625   /**
626    * Make an investment.
627    *
628    * Crowdsale must be running for one to invest.
629    * We must have not pressed the emergency brake.
630    *
631    * @param receiver The Ethereum address who receives the tokens
632    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
633    *
634    * @return tokenAmount How mony tokens were bought
635    */
636   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
637 
638     // Determine if it's a good time to accept investment from this participant
639     if(getState() == State.PreFunding) {
640       // Are we whitelisted for early deposit
641       if(!earlyParticipantWhitelist[receiver]) {
642         throw;
643       }
644     } else if(getState() == State.Funding) {
645       // Retail participants can only come in when the crowdsale is running
646       // pass
647     } else {
648       // Unwanted state
649       throw;
650     }
651 
652     uint weiAmount = msg.value;
653 
654     // Account presale sales separately, so that they do not count against pricing tranches
655     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
656 
657     // Dust transaction
658     require(tokenAmount != 0);
659 
660     if(investedAmountOf[receiver] == 0) {
661        // A new investor
662        investorCount++;
663     }
664 
665     // Update investor
666     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
667     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
668 
669     // Update totals
670     weiRaised = weiRaised.plus(weiAmount);
671     tokensSold = tokensSold.plus(tokenAmount);
672 
673     if(pricingStrategy.isPresalePurchase(receiver)) {
674         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
675     }
676 
677     // Check that we did not bust the cap
678     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
679 
680     assignTokens(receiver, tokenAmount);
681 
682     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
683     if(!multisigWallet.send(weiAmount)) throw;
684 
685     // Tell us invest was success
686     Invested(receiver, weiAmount, tokenAmount, customerId);
687 
688     return tokenAmount;
689   }
690 
691   /**
692    * Finalize a succcesful crowdsale.
693    *
694    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
695    */
696   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
697 
698     // Already finalized
699     if(finalized) {
700       throw;
701     }
702 
703     // Finalizing is optional. We only call it if we are given a finalizing agent.
704     if(address(finalizeAgent) != 0) {
705       finalizeAgent.finalizeCrowdsale();
706     }
707 
708     finalized = true;
709   }
710 
711   /**
712    * Allow to (re)set finalize agent.
713    *
714    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
715    */
716   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
717     finalizeAgent = addr;
718 
719     // Don't allow setting bad agent
720     if(!finalizeAgent.isFinalizeAgent()) {
721       throw;
722     }
723   }
724 
725   /**
726    * Allow crowdsale owner to close early or extend the crowdsale.
727    *
728    * This is useful e.g. for a manual soft cap implementation:
729    * - after X amount is reached determine manual closing
730    *
731    * This may put the crowdsale to an invalid state,
732    * but we trust owners know what they are doing.
733    *
734    */
735   function setEndsAt(uint time) onlyOwner {
736 
737     if(now > time) {
738       throw; // Don't change past
739     }
740 
741     if(startsAt > time) {
742       throw; // Prevent human mistakes
743     }
744 
745     endsAt = time;
746     EndsAtChanged(endsAt);
747   }
748 
749   /**
750    * Allow to (re)set pricing strategy.
751    *
752    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
753    */
754   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
755     pricingStrategy = _pricingStrategy;
756 
757     // Don't allow setting bad agent
758     if(!pricingStrategy.isPricingStrategy()) {
759       throw;
760     }
761   }
762 
763   /**
764    * Allow to change the team multisig address in the case of emergency.
765    *
766    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
767    * (we have done only few test transactions). After the crowdsale is going
768    * then multisig address stays locked for the safety reasons.
769    */
770   function setMultisig(address addr) public onlyOwner {
771 
772     // Change
773     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
774       throw;
775     }
776 
777     multisigWallet = addr;
778   }
779 
780   /**
781    * Allow load refunds back on the contract for the refunding.
782    *
783    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
784    */
785   function loadRefund() public payable inState(State.Failure) {
786     if(msg.value == 0) throw;
787     loadedRefund = loadedRefund.plus(msg.value);
788   }
789 
790   /**
791    * Investors can claim refund.
792    *
793    * Note that any refunds from proxy buyers should be handled separately,
794    * and not through this contract.
795    */
796   function refund() public inState(State.Refunding) {
797     uint256 weiValue = investedAmountOf[msg.sender];
798     if (weiValue == 0) throw;
799     investedAmountOf[msg.sender] = 0;
800     weiRefunded = weiRefunded.plus(weiValue);
801     Refund(msg.sender, weiValue);
802     if (!msg.sender.send(weiValue)) throw;
803   }
804 
805   /**
806    * @return true if the crowdsale has raised enough money to be a successful.
807    */
808   function isMinimumGoalReached() public constant returns (bool reached) {
809     return weiRaised >= minimumFundingGoal;
810   }
811 
812   /**
813    * Check if the contract relationship looks good.
814    */
815   function isFinalizerSane() public constant returns (bool sane) {
816     return finalizeAgent.isSane();
817   }
818 
819   /**
820    * Check if the contract relationship looks good.
821    */
822   function isPricingSane() public constant returns (bool sane) {
823     return pricingStrategy.isSane(address(this));
824   }
825 
826   /**
827    * Crowdfund state machine management.
828    *
829    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
830    */
831   function getState() public constant returns (State) {
832     if(finalized) return State.Finalized;
833     else if (address(finalizeAgent) == 0) return State.Preparing;
834     else if (!finalizeAgent.isSane()) return State.Preparing;
835     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
836     else if (block.timestamp < startsAt) return State.PreFunding;
837     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
838     else if (isMinimumGoalReached()) return State.Success;
839     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
840     else return State.Failure;
841   }
842 
843   /** This is for manual testing of multisig wallet interaction */
844   function setOwnerTestValue(uint val) onlyOwner {
845     ownerTestValue = val;
846   }
847 
848   /**
849    * Allow addresses to do early participation.
850    *
851    * TODO: Fix spelling error in the name
852    */
853   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
854     earlyParticipantWhitelist[addr] = status;
855     Whitelisted(addr, status);
856   }
857 
858 
859   /** Interface marker. */
860   function isCrowdsale() public constant returns (bool) {
861     return true;
862   }
863 
864   //
865   // Modifiers
866   //
867 
868   /** Modified allowing execution only if the crowdsale is currently running.  */
869   modifier inState(State state) {
870     if(getState() != state) throw;
871     _;
872   }
873 
874 
875   //
876   // Abstract functions
877   //
878 
879   /**
880    * Check if the current invested breaks our cap rules.
881    *
882    *
883    * The child contract must define their own cap setting rules.
884    * We allow a lot of flexibility through different capping strategies (ETH, token count)
885    * Called from invest().
886    *
887    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
888    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
889    * @param weiRaisedTotal What would be our total raised balance after this transaction
890    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
891    *
892    * @return true if taking this investment would break our cap rules
893    */
894   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
895 
896   /**
897    * Check if the current crowdsale is full and we can no longer sell any tokens.
898    */
899   function isCrowdsaleFull() public constant returns (bool);
900 
901   /**
902    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
903    */
904   function assignTokens(address receiver, uint tokenAmount) internal;
905 }
906 
907 contract Crowdsale is CrowdsaleBase {
908 
909   /* Do we need to have unique contributor id for each customer */
910   bool public requireCustomerId;
911 
912   /**
913     * Do we verify that contributor has been cleared on the server side (accredited investors only).
914     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
915     */
916   bool public requiredSignedAddress;
917 
918   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
919   address public signerAddress;
920 
921   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
922   }
923 
924   /**
925    * Preallocate tokens for the early investors.
926    *
927    * Preallocated tokens have been sold before the actual crowdsale opens.
928    * This function mints the tokens and moves the crowdsale needle.
929    *
930    * Investor count is not handled; it is assumed this goes for multiple investors
931    * and the token distribution happens outside the smart contract flow.
932    *
933    * No money is exchanged, as the crowdsale team already have received the payment.
934    *
935    * @param fullTokens tokens as full tokens - decimal places added internally
936    * @param weiPrice Price of a single full token in wei
937    *
938    */
939   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
940 
941     uint tokenAmount = fullTokens * 10**token.decimals();
942     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
943 
944     weiRaised = weiRaised.plus(weiAmount);
945     tokensSold = tokensSold.plus(tokenAmount);
946 
947     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
948     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
949 
950     assignTokens(receiver, tokenAmount);
951 
952     // Tell us invest was success
953     Invested(receiver, weiAmount, tokenAmount, 0);
954   }
955 
956   /**
957    * Allow anonymous contributions to this crowdsale.
958    */
959   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
960      bytes32 hash = sha256(addr);
961      if (ecrecover(hash, v, r, s) != signerAddress) throw;
962      if(customerId == 0) throw;  // UUIDv4 sanity check
963      investInternal(addr, customerId);
964   }
965 
966   /**
967    * Track who is the customer making the payment so we can send thank you email.
968    */
969   function investWithCustomerId(address addr, uint128 customerId) public payable {
970     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
971     if(customerId == 0) throw;  // UUIDv4 sanity check
972     investInternal(addr, customerId);
973   }
974 
975   /**
976    * Allow anonymous contributions to this crowdsale.
977    */
978   function invest(address addr) public payable {
979     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
980     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
981     investInternal(addr, 0);
982   }
983 
984   /**
985    * Invest to tokens, recognize the payer and clear his address.
986    *
987    */
988   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
989     investWithSignedAddress(msg.sender, customerId, v, r, s);
990   }
991 
992   /**
993    * Invest to tokens, recognize the payer.
994    *
995    */
996   function buyWithCustomerIdWithChecksum(uint128 customerId, bytes1 checksum) public payable {
997     // see customerid.py
998     if (bytes1(sha3(customerId)) != checksum) throw;
999     investWithCustomerId(msg.sender, customerId);
1000   }
1001 
1002   /**
1003    * Legacy API signature.
1004    */
1005   function buyWithCustomerId(uint128 customerId) public payable {
1006     investWithCustomerId(msg.sender, customerId);
1007   }
1008 
1009   /**
1010    * The basic entry point to participate the crowdsale process.
1011    *
1012    * Pay for funding, get invested tokens back in the sender address.
1013    */
1014   function buy() public payable {
1015     invest(msg.sender);
1016   }
1017 
1018   /**
1019    * Set policy do we need to have server-side customer ids for the investments.
1020    *
1021    */
1022   function setRequireCustomerId(bool value) onlyOwner {
1023     requireCustomerId = value;
1024     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1025   }
1026 
1027   /**
1028    * Set policy if all investors must be cleared on the server side first.
1029    *
1030    * This is e.g. for the accredited investor clearing.
1031    *
1032    */
1033   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
1034     requiredSignedAddress = value;
1035     signerAddress = _signerAddress;
1036     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1037   }
1038 
1039 }