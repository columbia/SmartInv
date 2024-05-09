1 /**
2  * Interface for defining crowdsale pricing.
3  */
4 contract PricingStrategy {
5 
6   /** Interface declaration. */
7   function isPricingStrategy() public constant returns (bool) {
8     return true;
9   }
10 
11   /** Self check if all references are correctly set.
12    *
13    * Checks that pricing strategy matches crowdsale parameters.
14    */
15   function isSane(address crowdsale) public constant returns (bool) {
16     return true;
17   }
18 
19   /**
20    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
21    *
22    *
23    * @param value - What is the value of the transaction send in as wei
24    * @param tokensSold - how much tokens have been sold this far
25    * @param weiRaised - how much money has been raised this far
26    * @param msgSender - who is the investor of this transaction
27    * @param decimals - how many decimal units the token has
28    * @return Amount of tokens the investor receives
29    */
30   function calculatePrice(uint value, uint tokensSold, uint weiRaised, address msgSender, uint decimals) public constant returns (uint tokenAmount);
31 }
32 
33 
34 /**
35  * Safe unsigned safe math.
36  *
37  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
38  *
39  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
40  *
41  * Maintained here until merged to mainline zeppelin-solidity.
42  *
43  */
44 library SafeMathLib {
45 
46   function times(uint a, uint b) returns (uint) {
47     uint c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function minus(uint a, uint b) returns (uint) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function plus(uint a, uint b) returns (uint) {
58     uint c = a + b;
59     assert(c>=a && c>=b);
60     return c;
61   }
62 
63   function assert(bool assertion) private {
64     if (!assertion) throw;
65   }
66 }
67 
68 
69 
70 
71 
72 
73 /*
74  * Ownable
75  *
76  * Base contract with an owner.
77  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
78  */
79 contract Ownable {
80   address public owner;
81 
82   function Ownable() {
83     owner = msg.sender;
84   }
85 
86   modifier onlyOwner() {
87     if (msg.sender != owner) {
88       throw;
89     }
90     _;
91   }
92 
93   function transferOwnership(address newOwner) onlyOwner {
94     if (newOwner != address(0)) {
95       owner = newOwner;
96     }
97   }
98 
99 }
100 
101 
102 /*
103  * Haltable
104  *
105  * Abstract contract that allows children to implement an
106  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
107  *
108  *
109  * Originally envisioned in FirstBlood ICO contract.
110  */
111 contract Haltable is Ownable {
112   bool public halted;
113 
114   modifier stopInEmergency {
115     if (halted) throw;
116     _;
117   }
118 
119   modifier onlyInEmergency {
120     if (!halted) throw;
121     _;
122   }
123 
124   // called by the owner on emergency, triggers stopped state
125   function halt() external onlyOwner {
126     halted = true;
127   }
128 
129   // called by the owner on end of emergency, returns to normal state
130   function unhalt() external onlyOwner onlyInEmergency {
131     halted = false;
132   }
133 
134 }
135 
136 
137 
138 /**
139  * Finalize agent defines what happens at the end of succeseful crowdsale.
140  *
141  * - Allocate tokens for founders, bounties and community
142  * - Make tokens transferable
143  * - etc.
144  */
145 contract FinalizeAgent {
146 
147   function isFinalizeAgent() public constant returns(bool) {
148     return true;
149   }
150 
151   /** Return true if we can run finalizeCrowdsale() properly.
152    *
153    * This is a safety check function that doesn't allow crowdsale to begin
154    * unless the finalizer has been set up properly.
155    */
156   function isSane() public constant returns (bool);
157 
158   /** Called once by crowdsale finalize() if the sale was success. */
159   function finalizeCrowdsale();
160 
161 }
162 
163 
164 
165 
166 /*
167  * ERC20 interface
168  * see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 {
171   uint public totalSupply;
172   function balanceOf(address who) constant returns (uint);
173   function allowance(address owner, address spender) constant returns (uint);
174 
175   function transfer(address to, uint value) returns (bool ok);
176   function transferFrom(address from, address to, uint value) returns (bool ok);
177   function approve(address spender, uint value) returns (bool ok);
178   event Transfer(address indexed from, address indexed to, uint value);
179   event Approval(address indexed owner, address indexed spender, uint value);
180 }
181 
182 
183 /**
184  * A token that defines fractional units as decimals.
185  */
186 contract FractionalERC20 is ERC20 {
187 
188   uint public decimals;
189 
190 }
191 
192 
193 
194 /**
195  * Abstract base contract for token sales.
196  *
197  * Handle
198  * - start and end dates
199  * - accepting investments
200  * - minimum funding goal and refund
201  * - various statistics during the crowdfund
202  * - different pricing strategies
203  * - different investment policies (require server side customer id, allow only whitelisted addresses)
204  *
205  */
206 contract Crowdsale is Haltable {
207 
208   using SafeMathLib for uint;
209 
210   /* The token we are selling */
211   FractionalERC20 public token;
212 
213   /* How we are going to price our offering */
214   PricingStrategy public pricingStrategy;
215 
216   /* Post-success callback */
217   FinalizeAgent public finalizeAgent;
218 
219   /* tokens will be transfered from this address */
220   address public multisigWallet;
221 
222   /* if the funding goal is not reached, investors may withdraw their funds */
223   uint public minimumFundingGoal;
224 
225   /* the UNIX timestamp start date of the crowdsale */
226   uint public startsAt;
227 
228   /* the UNIX timestamp end date of the crowdsale */
229   uint public endsAt;
230 
231   /* the number of tokens already sold through this contract*/
232   uint public tokensSold = 0;
233 
234   /* How many wei of funding we have raised */
235   uint public weiRaised = 0;
236 
237   /* How many distinct addresses have invested */
238   uint public investorCount = 0;
239 
240   /* How much wei we have returned back to the contract after a failed crowdfund. */
241   uint public loadedRefund = 0;
242 
243   /* How much wei we have given back to investors.*/
244   uint public weiRefunded = 0;
245 
246   /* Has this crowdsale been finalized */
247   bool public finalized;
248 
249   /* Do we need to have unique contributor id for each customer */
250   bool public requireCustomerId;
251 
252   /**
253     * Do we verify that contributor has been cleared on the server side (accredited investors only).
254     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
255     */
256   bool public requiredSignedAddress;
257 
258   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
259   address public signerAddress;
260 
261   /** How much ETH each address has invested to this crowdsale */
262   mapping (address => uint256) public investedAmountOf;
263 
264   /** How much tokens this crowdsale has credited for each investor address */
265   mapping (address => uint256) public tokenAmountOf;
266 
267   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
268   mapping (address => bool) public earlyParticipantWhitelist;
269 
270   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
271   uint public ownerTestValue;
272 
273   /** State machine
274    *
275    * - Preparing: All contract initialization calls and variables have not been set yet
276    * - Prefunding: We have not passed start time yet
277    * - Funding: Active crowdsale
278    * - Success: Minimum funding goal reached
279    * - Failure: Minimum funding goal not reached before ending time
280    * - Finalized: The finalized has been called and succesfully executed
281    * - Refunding: Refunds are loaded on the contract for reclaim.
282    */
283   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
284 
285   // A new investment was made
286   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
287 
288   // Refund was processed for a contributor
289   event Refund(address investor, uint weiAmount);
290 
291   // The rules were changed what kind of investments we accept
292   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
293 
294   // Address early participation whitelist status changed
295   event Whitelisted(address addr, bool status);
296 
297   // Crowdsale end time has been changed
298   event EndsAtChanged(uint endsAt);
299 
300   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
301 
302     if(_minimumFundingGoal != 0) {
303       // Mysterium specific fix to allow funding goal only be set in CHF
304     }
305 
306     owner = msg.sender;
307 
308     token = FractionalERC20(_token);
309 
310     setPricingStrategy(_pricingStrategy);
311 
312     multisigWallet = _multisigWallet;
313     if(multisigWallet == 0) {
314         throw;
315     }
316 
317     if(_start == 0) {
318         throw;
319     }
320 
321     startsAt = _start;
322 
323     if(_end == 0) {
324         throw;
325     }
326 
327     endsAt = _end;
328 
329     // Don't mess the dates
330     if(startsAt >= endsAt) {
331         throw;
332     }
333 
334   }
335 
336   /**
337    * Don't expect to just send in money and get tokens.
338    */
339   function() payable {
340     throw;
341   }
342 
343   /**
344    * Make an investment.
345    *
346    * Crowdsale must be running for one to invest.
347    * We must have not pressed the emergency brake.
348    *
349    * @param receiver The Ethereum address who receives the tokens
350    * @param customerId (optional) UUID v4 to track the successful payments on the server side
351    *
352    */
353   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
354 
355     // Determine if it's a good time to accept investment from this participant
356     if(getState() == State.PreFunding) {
357       // Are we whitelisted for early deposit
358       if(!earlyParticipantWhitelist[receiver]) {
359         throw;
360       }
361     } else if(getState() == State.Funding) {
362       // Retail participants can only come in when the crowdsale is running
363       // pass
364     } else {
365       // Unwanted state
366       throw;
367     }
368 
369     uint weiAmount = msg.value;
370     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
371 
372     if(tokenAmount == 0) {
373       // Dust transaction
374       throw;
375     }
376 
377     if(investedAmountOf[receiver] == 0) {
378        // A new investor
379        investorCount++;
380     }
381 
382     // Update investor
383     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
384     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
385 
386     // Update totals
387     weiRaised = weiRaised.plus(weiAmount);
388     tokensSold = tokensSold.plus(tokenAmount);
389 
390     // Check that we did not bust the cap
391     if(isBreakingCap(tokenAmount, weiAmount, weiRaised, tokensSold)) {
392       throw;
393     }
394 
395     assignTokens(receiver, tokenAmount);
396 
397     // Pocket the money
398     if(!multisigWallet.send(weiAmount)) throw;
399 
400     // Tell us invest was success
401     Invested(receiver, weiAmount, tokenAmount, customerId);
402 
403     // Call the invest hooks
404     onInvest();
405   }
406 
407   /**
408    * Track who is the customer making the payment so we can send thank you email.
409    */
410   function investWithCustomerId(address addr, uint128 customerId) public payable {
411     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
412     if(customerId == 0) throw;  // UUIDv4 sanity check
413     investInternal(addr, customerId);
414   }
415 
416   /**
417    * Allow anonymous contributions to this crowdsale.
418    */
419   function invest(address addr) public payable {
420     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
421     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
422     investInternal(addr, 0);
423   }
424 
425   /**
426    * Invest to tokens, recognize the payer.
427    *
428    */
429   function buyWithCustomerId(uint128 customerId) public payable {
430     investWithCustomerId(msg.sender, customerId);
431   }
432 
433   /**
434    * The basic entry point to participate the crowdsale process.
435    *
436    * Pay for funding, get invested tokens back in the sender address.
437    */
438   function buy() public payable {
439     invest(msg.sender);
440   }
441 
442   /**
443    * Finalize a succcesful crowdsale.
444    *
445    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
446    */
447   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
448 
449     // Already finalized
450     if(finalized) {
451       throw;
452     }
453 
454     // Finalizing is optional. We only call it if we are given a finalizing agent.
455     if(address(finalizeAgent) != 0) {
456       finalizeAgent.finalizeCrowdsale();
457     }
458 
459     finalized = true;
460   }
461 
462   /**
463    * Allow to (re)set finalize agent.
464    *
465    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
466    */
467   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
468     finalizeAgent = addr;
469 
470     // Don't allow setting bad agent
471     if(!finalizeAgent.isFinalizeAgent()) {
472       throw;
473     }
474   }
475 
476   /**
477    * Set policy do we need to have server-side customer ids for the investments.
478    *
479    */
480   function setRequireCustomerId(bool value) onlyOwner {
481     requireCustomerId = value;
482     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
483   }
484 
485   /**
486    * Allow addresses to do early participation.
487    *
488    * TODO: Fix spelling error in the name
489    */
490   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
491     earlyParticipantWhitelist[addr] = status;
492     Whitelisted(addr, status);
493   }
494 
495   /**
496    * Allow to (re)set pricing strategy.
497    *
498    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
499    */
500   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
501     pricingStrategy = _pricingStrategy;
502 
503     // Don't allow setting bad agent
504     if(!pricingStrategy.isPricingStrategy()) {
505       throw;
506     }
507   }
508 
509   /**
510    * Allow load refunds back on the contract for the refunding.
511    *
512    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
513    */
514   function loadRefund() public payable inState(State.Failure) {
515     if(msg.value == 0) throw;
516     loadedRefund = loadedRefund.plus(msg.value);
517   }
518 
519   /**
520    * Investors can claim refund.
521    */
522   function refund() public inState(State.Refunding) {
523     uint256 weiValue = investedAmountOf[msg.sender];
524     if (weiValue == 0) throw;
525     investedAmountOf[msg.sender] = 0;
526     weiRefunded = weiRefunded.plus(weiValue);
527     Refund(msg.sender, weiValue);
528     if (!msg.sender.send(weiValue)) throw;
529   }
530 
531   /**
532    * @return true if the crowdsale has raised enough money to be a succes
533    */
534   function isMinimumGoalReached() public constant returns (bool reached) {
535     return weiRaised >= minimumFundingGoal;
536   }
537 
538   /**
539    * Check if the contract relationship looks good.
540    */
541   function isFinalizerSane() public constant returns (bool sane) {
542     return finalizeAgent.isSane();
543   }
544 
545   /**
546    * Check if the contract relationship looks good.
547    */
548   function isPricingSane() public constant returns (bool sane) {
549     return pricingStrategy.isSane(address(this));
550   }
551 
552   /**
553    * Crowdfund state machine management.
554    *
555    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
556    */
557   function getState() public constant returns (State) {
558     if(finalized) return State.Finalized;
559     else if (address(finalizeAgent) == 0) return State.Preparing;
560     else if (!finalizeAgent.isSane()) return State.Preparing;
561     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
562     else if (block.timestamp < startsAt) return State.PreFunding;
563     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
564     else if (isMinimumGoalReached()) return State.Success;
565     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
566     else return State.Failure;
567   }
568 
569   /** This is for manual testing of multisig wallet interaction */
570   function setOwnerTestValue(uint val) onlyOwner {
571     ownerTestValue = val;
572   }
573 
574   /** Interface marker. */
575   function isCrowdsale() public constant returns (bool) {
576     return true;
577   }
578 
579 
580   /**
581    * Allow subcontracts to take extra actions on a successful invet.
582    */
583   function onInvest() internal {
584 
585   }
586 
587   //
588   // Modifiers
589   //
590 
591   /** Modified allowing execution only if the crowdsale is currently running.  */
592   modifier inState(State state) {
593     if(getState() != state) throw;
594     _;
595   }
596 
597   /**
598    * Allow crowdsale owner to close early or extend the crowdsale.
599    *
600    * This is useful e.g. for a manual soft cap implementation:
601    * - after X amount is reached determine manual closing
602    *
603    * This may put the crowdsale to an invalid state,
604    * but we trust owners know what they are doing.
605    *
606    */
607   function setEndsAt(uint time) onlyOwner {
608 
609     if(now > time) {
610       throw; // Don't change past
611     }
612 
613     endsAt = time;
614     EndsAtChanged(endsAt);
615   }
616 
617   //
618   // Abstract functions
619   //
620 
621   /**
622    * Check if the current invested breaks our cap rules.
623    *
624    *
625    * The child contract must define their own cap setting rules.
626    * We allow a lot of flexibility through different capping strategies (ETH, token count)
627    * Called from invest().
628    *
629    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
630    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
631    * @param weiRaisedTotal What would be our total raised balance after this transaction
632    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
633    *
634    * @return true if taking this investment would break our cap rules
635    */
636   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
637 
638   /**
639    * Check if the current crowdsale is full and we can no longer sell any tokens.
640    */
641   function isCrowdsaleFull() public constant returns (bool);
642 
643   /**
644    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
645    */
646   function assignTokens(address receiver, uint tokenAmount) private;
647 }
648 
649 
650 
651 /**
652  * Fixed crowdsale pricing - everybody gets the same price.
653  */
654 contract MysteriumPricing is PricingStrategy, Ownable {
655 
656   using SafeMathLib for uint;
657 
658   // The conversion rate: how many weis is 1 CHF
659   // https://www.coingecko.com/en/price_charts/ethereum/chf
660   // 120.34587901 is 1203458
661   uint public chfRate;
662 
663   uint public chfScale = 10000;
664 
665   /* How many weis one token costs */
666   uint public hardCapPrice = 12000;  // 1.2 * 10000 Expressed as CFH base points
667 
668   uint public softCapPrice = 10000;  // 1.0 * 10000 Expressed as CFH base points
669 
670   uint public softCapCHF = 6000000 * 10000; // Soft cap set in CHF
671 
672   //Address of the ICO contract:
673   Crowdsale public crowdsale;
674 
675   function MysteriumPricing(uint initialChfRate) {
676     chfRate = initialChfRate;
677   }
678 
679   /// @dev Setting crowdsale for setConversionRate()
680   /// @param _crowdsale The address of our ICO contract
681   function setCrowdsale(Crowdsale _crowdsale) onlyOwner {
682 
683     if(!_crowdsale.isCrowdsale()) {
684       throw;
685     }
686 
687     crowdsale = _crowdsale;
688   }
689 
690   /// @dev Here you can set the new CHF/ETH rate
691   /// @param _chfRate The rate how many weis is one CHF
692   function setConversionRate(uint _chfRate) onlyOwner {
693     //Here check if ICO is active
694     if(now > crowdsale.startsAt())
695       throw;
696 
697     chfRate = _chfRate;
698   }
699 
700   /**
701    * Allow to set soft cap.
702    */
703   function setSoftCapCHF(uint _softCapCHF) onlyOwner {
704     softCapCHF = _softCapCHF;
705   }
706 
707   /**
708    * Get CHF/ETH pair as an integer.
709    *
710    * Used in distribution calculations.
711    */
712   function getEthChfPrice() public constant returns (uint) {
713     return chfRate / chfScale;
714   }
715 
716   /**
717    * Currency conversion
718    *
719    * @param  chf CHF price * 100000
720    * @return wei price
721    */
722   function convertToWei(uint chf) public constant returns(uint) {
723     return chf.times(10**18) / chfRate;
724   }
725 
726   /// @dev Function which tranforms CHF softcap to weis
727   function getSoftCapInWeis() public returns (uint) {
728     return convertToWei(softCapCHF);
729   }
730 
731   /**
732    * Calculate the current price for buy in amount.
733    *
734    * @param  {uint amount} How many tokens we get
735    */
736   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
737 
738     uint multiplier = 10 ** decimals;
739     if (weiRaised > getSoftCapInWeis()) {
740       //Here SoftCap is not active yet
741       return value.times(multiplier) / convertToWei(hardCapPrice);
742     } else {
743       return value.times(multiplier) / convertToWei(softCapPrice);
744     }
745   }
746 
747 }