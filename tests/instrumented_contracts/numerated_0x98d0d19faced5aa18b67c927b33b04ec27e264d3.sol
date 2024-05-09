1 pragma solidity ^0.4.11;
2 
3 
4 /*
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 /*
57  * Ownable
58  *
59  * Base contract with an owner.
60  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
61  */
62 contract Ownable {
63   address public owner;
64 
65   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67   function Ownable() {
68     owner = msg.sender;
69   }
70 
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   function transferOwnership(address newOwner) onlyOwner public {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 
85 /*
86  * Haltable
87  *
88  * Abstract contract that allows children to implement an
89  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
90  *
91  *
92  * Originally envisioned in FirstBlood ICO contract.
93  */
94 contract Haltable is Ownable {
95   bool public halted;
96 
97   modifier stopInEmergency {
98     if (halted) throw;
99     _;
100   }
101 
102   modifier stopNonOwnersInEmergency {
103     if (halted && msg.sender != owner) throw;
104     _;
105   }
106 
107   modifier onlyInEmergency {
108     if (!halted) throw;
109     _;
110   }
111 
112   // called by the owner on emergency, triggers stopped state
113   function halt() external onlyOwner {
114     halted = true;
115   }
116 
117   // called by the owner on end of emergency, returns to normal state
118   function unhalt() external onlyOwner onlyInEmergency {
119     halted = false;
120   }
121 
122 }
123 
124 
125 /*
126  * Interface for defining crowdsale pricing.
127  */
128 contract PricingStrategy {
129 
130   /* Interface declaration. */
131   function isPricingStrategy() public constant returns (bool) {
132     return true;
133   }
134 
135   /* Self check if all references are correctly set.
136    *
137    * Checks that pricing strategy matches crowdsale parameters.
138    */
139   function isSane(address crowdsale) public constant returns (bool) {
140     return true;
141   }
142 
143   function isPresalePurchase(address purchaser) public constant returns (bool) {
144     return false;
145   }
146 
147   /*
148    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
149    *
150    *
151    * @param value - What is the value of the transaction send in as wei
152    * @param tokensSold - how much tokens have been sold this far
153    * @param weiRaised - how much money has been raised this far
154    * @param msgSender - who is the investor of this transaction
155    * @param decimals - how many decimal units the token has
156    * @return Amount of tokens the investor receives
157    */
158   function calculatePrice(uint value, uint tokensSold, uint weiRaised, address msgSender, uint decimals) public constant returns (uint tokenAmount);
159 }
160 
161 
162 /*
163  * Finalize agent defines what happens at the end of succeseful crowdsale.
164  *
165  * - Allocate tokens for founders, bounties and community
166  * - Make tokens transferable
167  * - etc.
168  */
169 contract FinalizeAgent {
170 
171   function isFinalizeAgent() public constant returns(bool) {
172     return true;
173   }
174 
175   /* Return true if we can run finalizeCrowdsale() properly.
176    *
177    * This is a safety check function that doesn't allow crowdsale to begin
178    * unless the finalizer has been set up properly.
179    */
180   function isSane() public constant returns (bool);
181 
182   /* Called once by crowdsale finalize() if the sale was success. */
183   function finalizeCrowdsale();
184 
185 }
186 
187 
188 /*
189  * ERC20 interface
190  * see https://github.com/ethereum/EIPs/issues/20
191  */
192 contract ERC20 {
193   uint public totalSupply;
194   function balanceOf(address who) constant returns (uint);
195   function allowance(address owner, address spender) constant returns (uint);
196 
197   function transfer(address to, uint value) returns (bool ok);
198   function transferFrom(address from, address to, uint value) returns (bool ok);
199   function approve(address spender, uint value) returns (bool ok);
200   event Transfer(address indexed from, address indexed to, uint value);
201   event Approval(address indexed owner, address indexed spender, uint value);
202 }
203 
204 
205 /*
206  * A token that defines fractional units as decimals.
207  */
208 contract FractionalERC20 is ERC20 {
209 
210   uint public decimals;
211 
212 }
213 
214 
215 /*
216  * Abstract base contract for token sales.
217  *
218  * Handle
219  * - start and end dates
220  * - accepting investments
221  * - minimum funding goal and refund
222  * - various statistics during the crowdfund
223  * - different pricing strategies
224  * - different investment policies (require server side customer id, allow only whitelisted addresses)
225  *
226  */
227 contract Crowdsale is Haltable {
228 
229   using SafeMath for uint;
230 
231   /* The token we are selling and to which decimal place */
232   FractionalERC20 public token;
233 
234   /* How we are going to price our offering */
235   PricingStrategy public pricingStrategy;
236 
237   /* Post-success callback */
238   FinalizeAgent public finalizeAgent;
239 
240   /* tokens will be transfered from this address */
241   address public multisigWallet;
242 
243   /* if the funding goal is not reached, investors may withdraw their funds */
244   uint public minimumFundingGoal;
245 
246   /* the UNIX timestamp start date of the crowdsale */
247   uint public startsAt;
248 
249   /* the UNIX timestamp end date of the crowdsale */
250   uint public endsAt;
251 
252   /* the number of tokens already sold through this contract*/
253   uint public tokensSold = 0;
254 
255   /* How many wei of funding we have raised */
256   uint public weiRaised = 0;
257 
258   /* How many distinct addresses have invested */
259   uint public investorCount = 0;
260 
261   /* How much wei we have returned back to the contract after a failed crowdfund. */
262   uint public loadedRefund = 0;
263 
264   /* How much wei we have given back to investors.*/
265   uint public weiRefunded = 0;
266 
267   /* Has this crowdsale been finalized */
268   bool public finalized;
269 
270   /* Do we need to have unique contributor id for each customer */
271   bool public requireCustomerId;
272 
273   /*
274     * Do we verify that contributor has been cleared on the server side (accredited investors only).
275     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
276     */
277   bool public requiredSignedAddress;
278 
279   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
280   address public signerAddress;
281 
282   /* How much ETH each address has invested to this crowdsale */
283   mapping (address => uint256) public investedAmountOf;
284 
285   /* How much tokens this crowdsale has credited for each investor address */
286   mapping (address => uint256) public tokenAmountOf;
287 
288   /* Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
289   mapping (address => bool) public earlyParticipantWhitelist;
290 
291   /* This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
292   uint public ownerTestValue;
293 
294   /* State machine oulines the current state of our contract
295    *
296    * - Preparing: 1
297    * - Prefunding: 2
298    * - Funding: 3
299    * - Success: 4
300    * - Failure: 5
301    * - Finalized: 6
302    * - Refunding: 7
303    */
304   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
305 
306   // A new investment was made
307   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
308 
309   // Refund was processed for a contributor
310   event Refund(address investor, uint weiAmount);
311 
312   // The rules were changed what kind of investments we accept
313   event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);
314 
315   // Address early participation whitelist status changed
316   event Whitelisted(address addr, bool status);
317 
318   // Crowdsale end time has been changed
319   event EndsAtChanged(uint endsAt);
320 
321   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
322 
323        // Minimum funding goal can be zero
324     minimumFundingGoal = _minimumFundingGoal;
325 
326     owner = msg.sender;
327 
328     token = FractionalERC20(_token);
329 
330     setPricingStrategy(_pricingStrategy);
331 
332     multisigWallet = _multisigWallet;
333     if(multisigWallet == 0) {
334         throw;
335     }
336 
337     if(_start == 0) {
338         throw;
339     }
340 
341     startsAt = _start;
342 
343     if(_end == 0) {
344         throw;
345     }
346 
347     endsAt = _end;
348 
349     // Don't mess the dates
350     if(startsAt >= endsAt) {
351         throw;
352     }
353 
354   }
355 
356   /*
357    * For those that just wish to send ethers the usual way
358    */
359    function() external payable {
360     investInternal(msg.sender, 0);
361   }
362 
363   /*
364    * Make an investment.
365    *
366    * Crowdsale must be running for one to invest.
367    * We must have not pressed the emergency brake.
368    *
369    * @param receiver The Ethereum address who receives the tokens
370    * @param customerId (optional) UUID v4 to track the successful payments on the server side
371    *
372    */
373   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
374 
375     // Determine if it's a good time to accept investment from this participant
376     if(getState() == State.PreFunding) {
377       // Are we whitelisted for early deposit
378       if(!earlyParticipantWhitelist[receiver]) {
379         throw;
380       }
381     } else if(getState() == State.Funding) {
382       // Retail participants can only come in when the crowdsale is running
383       // pass
384     } else {
385       // Unwanted state
386       throw;
387     }
388 
389     uint weiAmount = msg.value;
390     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
391 
392     if(tokenAmount == 0) {
393       // Dust transaction
394       throw;
395     }
396 
397     if(investedAmountOf[receiver] == 0) {
398        // A new investor
399        investorCount++;
400     }
401 
402     // Update investor
403     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
404     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
405 
406     // Update totals
407     weiRaised = weiRaised.add(weiAmount);
408     tokensSold = tokensSold.add(tokenAmount);
409 
410     // Check that we did not bust the cap
411     if(isBreakingCap(tokenAmount, weiAmount, weiRaised, tokensSold)) {
412       throw;
413     }
414 
415     assignTokens(receiver, tokenAmount);
416 
417     // Pocket the money
418     if(!multisigWallet.send(weiAmount)) throw;
419 
420     // Tell us invest was success
421     Invested(receiver, weiAmount, tokenAmount, customerId);
422 
423     // Call the invest hooks
424     // onInvest();
425   }
426 
427   // Get tokenSold count
428   function getTokensSold() public constant returns (uint) {
429     return tokensSold;
430   }
431 
432   /*
433    * Track who is the customer making the payment so we can send thank you email.
434    */
435   function investWithCustomerId(address addr, uint128 customerId) public payable {
436     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
437     if(customerId == 0) throw;  // UUIDv4 sanity check
438     investInternal(addr, customerId);
439   }
440 
441   /*
442    * Allow anonymous contributions to this crowdsale.
443    */
444   function invest(address addr) public payable {
445     if(requireCustomerId) throw; // Crowdsale needs to track partipants for thank you email
446     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
447     investInternal(addr, 0);
448   }
449 
450   /*
451    * Invest to tokens, recognize the payer.
452    *
453    */
454   function buyWithCustomerId(uint128 customerId) public payable {
455     investWithCustomerId(msg.sender, customerId);
456   }
457 
458   /*
459    * The basic entry point to participate the crowdsale process.
460    *
461    * Pay for funding, get invested tokens back in the sender address.
462    */
463   function buy() public payable {
464     invest(msg.sender);
465   }
466 
467   /*
468    * Finalize a succcesful crowdsale.
469    *
470    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
471    */
472   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
473 
474     // Already finalized
475     if(finalized) {
476       throw;
477     }
478 
479     // Finalizing is optional. We only call it if we are given a finalizing agent.
480     if(address(finalizeAgent) != 0) {
481       finalizeAgent.finalizeCrowdsale();
482     }
483 
484     finalized = true;
485   }
486 
487   /*
488    * Allow to (re)set finalize agent.
489    *
490    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
491    */
492   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
493     finalizeAgent = addr;
494 
495     // Don't allow setting bad agent
496     if(!finalizeAgent.isFinalizeAgent()) {
497       throw;
498     }
499   }
500 
501   /*
502    * Set policy do we need to have server-side customer ids for the investments.
503    *
504    */
505   function setRequireCustomerId(bool value) onlyOwner {
506     requireCustomerId = value;
507     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
508   }
509 
510   /*
511    * Allow verified investors to be added to early participant list.
512    *
513    */
514   function setEarlyParticipantWhitelist(address addr, bool status) onlyOwner {
515     earlyParticipantWhitelist[addr] = status;
516     Whitelisted(addr, status);
517   }
518 
519   /*
520    * Allow to (re)set pricing strategy.
521    *
522    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
523    */
524   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
525     pricingStrategy = _pricingStrategy;
526 
527     // If not legit, then throw thsi out.
528     if(!pricingStrategy.isPricingStrategy()) {
529       throw;
530     }
531   }
532 
533   /*
534    * Allow load refunds back on the contract for the refunding.
535    *
536    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
537    */
538   function loadRefund() public payable inState(State.Failure) {
539     if(msg.value == 0) throw;
540     loadedRefund = loadedRefund.add(msg.value);
541   }
542 
543   /*
544    * Investors can claim refund.
545    */
546   function refund() public inState(State.Refunding) {
547     uint256 weiValue = investedAmountOf[msg.sender];
548     if (weiValue == 0) throw;
549     investedAmountOf[msg.sender] = 0;
550     weiRefunded = weiRefunded.add(weiValue);
551     Refund(msg.sender, weiValue);
552     if (!msg.sender.send(weiValue)) throw;
553   }
554 
555   /*
556    * @return true if the crowdsale has raised enough money to be a succes
557    */
558   function isMinimumGoalReached() public constant returns (bool reached) {
559     return weiRaised >= minimumFundingGoal;
560   }
561 
562   /*
563    * Check if the contract relationship looks good.
564    */
565   function isFinalizerSane() public constant returns (bool sane) {
566     return finalizeAgent.isSane();
567   }
568 
569   /*
570    * Check if the contract relationship looks good.
571    */
572   function isPricingSane() public constant returns (bool sane) {
573     return pricingStrategy.isSane(address(this));
574   }
575 
576   /*
577    * Crowdfund state machine management.
578    *
579    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
580    */
581   function getState() public constant returns (State) {
582     if(finalized) return State.Finalized;
583     else if (address(finalizeAgent) == 0) return State.Preparing;
584     else if (!finalizeAgent.isSane()) return State.Preparing;
585     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
586     else if (block.timestamp < startsAt) return State.PreFunding;
587     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
588     else if (isMinimumGoalReached()) return State.Success;
589     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
590     else return State.Failure;
591   }
592 
593   /* This is for manual testing of multisig wallet interaction */
594   function setOwnerTestValue(uint val) onlyOwner {
595     ownerTestValue = val;
596   }
597 
598   /* Interface marker. */
599   function isCrowdsale() public constant returns (bool) {
600     return true;
601   }
602 
603   //
604   // Modifiers
605   //
606 
607   /* Modified allowing execution only if the crowdsale is currently running.  */
608   modifier inState(State state) {
609     if(getState() != state) throw;
610     _;
611   }
612 
613   /*
614    * Allow crowdsale owner to close early or extend the crowdsale.
615    *
616    * This is useful e.g. for a manual soft cap implementation:
617    * - after X amount is reached determine manual closing
618    *
619    * This may put the crowdsale to an invalid state,
620    * but we trust owners know what they are doing.
621    *
622    */
623   function setEndsAt(uint time) onlyOwner {
624 
625     if(now > time) {
626       throw; // Don't change past
627     }
628 
629     endsAt = time;
630     EndsAtChanged(endsAt);
631   }
632 
633   //
634   // Abstract functions
635   //
636 
637   /*
638    * Check if the current invested breaks our cap rules.
639    *
640    *
641    * The child contract must define their own cap setting rules.
642    * We allow a lot of flexibility through different capping strategies (ETH, token count)
643    * Called from invest().
644    *
645    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
646    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
647    * @param weiRaisedTotal What would be our total raised balance after this transaction
648    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
649    *
650    * @return true if taking this investment would break our cap rules
651    */
652   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
653 
654   /*
655    * Check if the current crowdsale is full and we can no longer sell any tokens.
656    */
657   function isCrowdsaleFull() public constant returns (bool);
658 
659   /*
660    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
661    */
662   function assignTokens(address receiver, uint tokenAmount) private;
663 }
664 
665 
666 /*
667  * Fixed crowdsale pricing - everybody gets the same price.
668  */
669 contract TapcoinPricing is PricingStrategy, Ownable {
670 
671   using SafeMath for uint;
672 
673 /* how many weis one token costs 
674  */
675   uint public oneTokenWei;
676 
677 /*
678  * Current locked in Eth/USD price at point of contract deployment
679  */
680   uint public ethUSD = 279; 
681 
682   uint public weiScale = 10**18;
683 
684   uint public softCapUSD = 419 * 10**3; // Soft cap set in USD. These values will change before mainnet
685 
686   //Address of the ICO contract:
687   Crowdsale public crowdsale;
688 
689   function TapcoinPricing(uint initialTokenWei) {
690     oneTokenWei = initialTokenWei;
691   }
692 
693   // @dev Setting crowdsale for setConversionRate()
694   // @param _crowdsale The address of our ICO contract
695   function setCrowdsale(Crowdsale _crowdsale) onlyOwner {
696 
697     if(!_crowdsale.isCrowdsale()) {
698       throw;
699     }
700 
701     crowdsale = _crowdsale;
702   }
703 
704   // @dev Here you can set the new oneTokeWei rate 
705   // @param _oneTokenWei - The new conversion price wei/token
706   function setConversionRate(uint _oneTokenWei) onlyOwner {
707     //Here check if ICO is active
708     // if(now > crowdsale.startsAt())
709     //   throw;
710 
711     oneTokenWei = _oneTokenWei;
712   }
713 
714   // @dev Here you can set the ethUSD price. Used for early contribution and main contribution
715  // @param _ethUSD - The new ETH to USD price
716  function setEthUSD(uint _ethUSD) onlyOwner {
717     ethUSD = _ethUSD;
718  }
719 
720   /*
721    * Allow to set soft cap.
722    */
723   function setSoftCapUSD(uint _softCapUSD) onlyOwner {
724     softCapUSD = _softCapUSD;
725   }
726 
727   /*
728    * USD \ ETH as a solid integer
729    *
730    */
731    function getEthUSDPrice() public constant returns(uint) {
732     return ethUSD;
733    }
734 
735 
736   /*
737    * Currency conversion
738    *
739    * @param  usd price * 10**18
740    * @return wei price
741    */
742   function convertToWei(uint usd) public constant returns(uint) {
743     return usd.mul(10**18) / ethUSD;
744   }
745 
746   // @dev Function which tranforms USD softcap to weis
747   function getSoftCapInWeis() public returns (uint) {
748     return convertToWei(softCapUSD);
749   }
750 
751   /*
752    * Calculate the current price for buy in amount.
753    *
754    * 
755    */
756   function calculatePrice(uint value, uint tokensSold, uint weiRaised, address msgSender, uint decimals) public constant returns (uint) {
757     uint multiplier = 10 ** decimals;
758     return value.mul(multiplier) / oneTokenWei; 
759   }
760 
761 }
762 
763 
764 /**
765  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
766  *
767  * Based on code by FirstBlood:
768  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
769  */
770 contract StandardToken is ERC20 {
771 
772   using SafeMath for uint;
773 
774   /* Token supply got increased and a new owner received these tokens */
775   event Minted(address receiver, uint amount);
776 
777   /* Actual balances of token holders */
778   mapping(address => uint) balances;
779 
780   /* approve() allowances */
781   mapping (address => mapping (address => uint)) allowed;
782 
783   /* Interface declaration */
784   function isToken() public constant returns (bool weAre) {
785     return true;
786   }
787 
788   function transfer(address _to, uint _value) returns (bool success) {
789     balances[msg.sender] = balances[msg.sender].sub(_value);
790     balances[_to] = balances[_to].add(_value);
791     Transfer(msg.sender, _to, _value);
792     return true;
793   }
794 
795   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
796     uint _allowance = allowed[_from][msg.sender];
797 
798     balances[_to] = balances[_to].add(_value);
799     balances[_from] = balances[_from].sub(_value);
800     allowed[_from][msg.sender] = _allowance.sub(_value);
801     Transfer(_from, _to, _value);
802     return true;
803   }
804 
805   function balanceOf(address _owner) constant returns (uint balance) {
806     return balances[_owner];
807   }
808 
809   function approve(address _spender, uint _value) returns (bool success) {
810 
811     // To change the approve amount you first have to reduce the addresses`
812     //  allowance to zero by calling `approve(_spender, 0)` if it is not
813     //  already 0 to mitigate the race condition described here:
814     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
815     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
816 
817     allowed[msg.sender][_spender] = _value;
818     Approval(msg.sender, _spender, _value);
819     return true;
820   }
821 
822   function allowance(address _owner, address _spender) constant returns (uint remaining) {
823     return allowed[_owner][_spender];
824   }
825 
826   function increaseApproval (address _spender, uint _addedValue)
827     returns (bool success) {
828     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
829     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
830     return true;
831   }
832 
833   function decreaseApproval (address _spender, uint _subtractedValue)
834     returns (bool success) {
835     uint oldValue = allowed[msg.sender][_spender];
836     if (_subtractedValue > oldValue) {
837       allowed[msg.sender][_spender] = 0;
838     } else {
839       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
840     }
841     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
842     return true;
843   }
844 
845 }
846 
847 
848 /*
849  * A token that can increase its supply by another contract.
850  *
851  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
852  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
853  *
854  */
855 contract MintableToken is StandardToken, Ownable {
856 
857   using SafeMath for uint;
858 
859   bool public mintingFinished = false;
860 
861   /* List of agents that are allowed to create new tokens */
862   mapping (address => bool) public mintAgents;
863 
864   event MintingAgentChanged(address addr, bool state  );
865 
866 
867   /*
868    * Create new tokens and allocate them to an address..
869    *
870    * Only callably by a crowdsale contract (mint agent).
871    */
872   function mint(address receiver, uint amount) onlyMintAgent canMint public {
873 
874     if(amount == 0) {
875       throw;
876     }
877 
878     totalSupply = totalSupply.add(amount);
879     balances[receiver] = balances[receiver].add(amount);
880     Transfer(0, receiver, amount);
881   }
882 
883   /*
884    * Owner can allow a crowdsale contract to mint new tokens.
885    */
886   function setMintAgent(address addr, bool state) onlyOwner canMint public {
887     mintAgents[addr] = state;
888     MintingAgentChanged(addr, state);
889   }
890 
891   modifier onlyMintAgent() {
892     // Only crowdsale contracts are allowed to mint new tokens
893     if(!mintAgents[msg.sender]) {
894         throw;
895     }
896     _;
897   }
898 
899   /* Make sure we are not done yet. */
900   modifier canMint() {
901     if(mintingFinished) throw;
902     _;
903   }
904 }
905 
906 
907 contract TapcoinCrowdsale is Crowdsale {
908   
909   using SafeMath for uint;
910 
911   // The default minimum funding limit 419,000 USD
912   uint public minimumFundingUSD = 419 * 10**3;
913 
914   // Max of 75k ETH.
915   uint public hardCapUSD = 22 * 10**6;
916 
917 
918   function TapcoinCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end)
919     Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, 0) {
920   }
921 
922   /*
923    * Get minimum funding goal in wei.
924    */
925   function getMinimumFundingGoal() public constant returns (uint goalInWei) {
926     return TapcoinPricing(pricingStrategy).convertToWei(minimumFundingUSD);
927   }
928 
929   /*
930    * Allow reset the threshold.
931    */
932   function setMinimumFundingLimit(uint usd) onlyOwner {
933     minimumFundingUSD = usd;
934   }
935 
936   /*
937    * @return true if the crowdsale has raised enough money to be a succes
938    */
939   function isMinimumGoalReached() public constant returns (bool reached) {
940     return weiRaised >= getMinimumFundingGoal();
941   }
942 
943   function getHardCap() public constant returns (uint capInWei) {
944     return TapcoinPricing(pricingStrategy).convertToWei(hardCapUSD);
945   }
946 
947   /*
948    * Reset hard cap.
949    *
950    * Assigns softcap in USD
951    */
952   function setHardCapUSD(uint _hardCapUSD) onlyOwner {
953     hardCapUSD = _hardCapUSD;
954   }
955 
956   /*
957    * Called from invest() to confirm if the current investment does not break our cap rule.
958    */
959   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
960     return weiRaisedTotal > getHardCap();
961   }
962 
963   function isCrowdsaleFull() public constant returns (bool) {
964     return weiRaised >= getHardCap();
965   }
966 
967   /*
968    * @return true we have reached our soft cap
969    */
970   function isSoftCapReached() public constant returns (bool reached) {
971     return weiRaised >= TapcoinPricing(pricingStrategy).getSoftCapInWeis();
972   }
973 
974 
975   /*
976    * Dynamically create tokens and assign them to the investor.
977    */
978   function assignTokens(address receiver, uint tokenAmount) private {
979     MintableToken mintableToken = MintableToken(token);
980     mintableToken.mint(receiver, tokenAmount);
981   }
982 }