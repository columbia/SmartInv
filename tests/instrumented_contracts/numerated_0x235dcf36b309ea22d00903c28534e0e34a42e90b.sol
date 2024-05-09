1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract FinalizeAgent {
46 
47   function isFinalizeAgent() public pure returns(bool) {
48     return true;
49   }
50 
51   /** Return true if we can run finalizeCrowdsale() properly.
52    *
53    * This is a safety check function that doesn't allow crowdsale to begin
54    * unless the finalizer has been set up properly.
55    */
56   function isSane() public view returns (bool);
57 
58   /** Called once by crowdsale finalize() if the sale was success. */
59   function finalizeCrowdsale() public;
60 
61 }
62 
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     require(newOwner != address(0));
92     OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 
96 }
97 
98 contract Haltable is Ownable {
99   bool public halted;
100 
101   modifier stopInEmergency {
102     if (halted) revert();
103     _;
104   }
105 
106   modifier stopNonOwnersInEmergency {
107     if (halted && msg.sender != owner) revert();
108     _;
109   }
110 
111   modifier onlyInEmergency {
112     if (!halted) revert();
113     _;
114   }
115 
116   // called by the owner on emergency, triggers stopped state
117   function halt() external onlyOwner {
118     halted = true;
119   }
120 
121   // called by the owner on end of emergency, returns to normal state
122   function unhalt() external onlyOwner onlyInEmergency {
123     halted = false;
124   }
125 
126 }
127 
128 contract CrowdsaleBase is Haltable {
129 
130   /* Max investment count when we are still allowed to change the multisig address */
131   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
132 
133   using SafeMath for uint;
134 
135   /* The token we are selling */
136   FractionalERC20 public token;
137 
138   /* How we are going to price our offering */
139   PricingStrategy public pricingStrategy;
140 
141   /* Post-success callback */
142   FinalizeAgent public finalizeAgent;
143 
144   /* tokens will be transfered from this address */
145   address public multisigWallet;
146 
147   /* if the funding goal is not reached, investors may withdraw their funds */
148   uint public minimumFundingGoal;
149 
150   /* the UNIX timestamp start date of the crowdsale */
151   uint public startsAt;
152 
153   /* the UNIX timestamp end date of the crowdsale */
154   uint public endsAt;
155 
156   /* the number of tokens already sold through this contract*/
157   uint public tokensSold = 0;
158 
159   /* How many wei of funding we have raised */
160   uint public weiRaised = 0;
161 
162   /* Calculate incoming funds from presale contracts and addresses */
163   uint public presaleWeiRaised = 0;
164 
165   /* How many distinct addresses have invested */
166   uint public investorCount = 0;
167 
168   /* How much wei we have returned back to the contract after a failed crowdfund. */
169   uint public loadedRefund = 0;
170 
171   /* How much wei we have given back to investors.*/
172   uint public weiRefunded = 0;
173 
174   /* Has this crowdsale been finalized */
175   bool public finalized;
176 
177   /** How much ETH each address has invested to this crowdsale */
178   mapping (address => uint256) public investedAmountOf;
179 
180   /** How much tokens this crowdsale has credited for each investor address */
181   mapping (address => uint256) public tokenAmountOf;
182 
183   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
184   mapping (address => bool) public earlyParticipantWhitelist;
185 
186   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
187   uint public ownerTestValue;
188 
189   /** State machine
190    *
191    * - Preparing: All contract initialization calls and variables have not been set yet
192    * - Prefunding: We have not passed start time yet
193    * - Funding: Active crowdsale
194    * - Success: Minimum funding goal reached
195    * - Failure: Minimum funding goal not reached before ending time
196    * - Finalized: The finalized has been called and succesfully executed
197    * - Refunding: Refunds are loaded on the contract for reclaim.
198    */
199   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
200 
201   // A new investment was made
202   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
203 
204   // Refund was processed for a contributor
205   event Refund(address investor, uint weiAmount);
206 
207   // The rules were changed what kind of investments we accept
208   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
209 
210   // Address early participation whitelist status changed
211   event Whitelisted(address addr, bool status);
212 
213   // Crowdsale end time has been changed
214   event EndsAtChanged(uint newEndsAt);
215 
216   State public testState;
217 
218   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) public {
219 
220     owner = msg.sender;
221 
222     token = FractionalERC20(_token);
223 
224     setPricingStrategy(_pricingStrategy);
225 
226     multisigWallet = _multisigWallet;
227     if(multisigWallet == 0) {
228         revert();
229     }
230 
231     if(_start == 0) {
232         revert();
233     }
234 
235     startsAt = _start;
236 
237     if(_end == 0) {
238         revert();
239     }
240 
241     endsAt = _end;
242 
243     // Don't mess the dates
244     if(startsAt >= endsAt) {
245         revert();
246     }
247 
248     // Minimum funding goal can be zero
249     minimumFundingGoal = _minimumFundingGoal;
250   }
251 
252   /**
253    * Don't expect to just send in money and get tokens.
254    */
255   function() payable public {
256     revert();
257   }
258 
259   /**
260    * Make an investment.
261    *
262    * Crowdsale must be running for one to invest.
263    * We must have not pressed the emergency brake.
264    *
265    * @param receiver The Ethereum address who receives the tokens
266    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
267    *
268    * @return tokenAmount How mony tokens were bought
269    */
270   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
271 
272     // Determine if it's a good time to accept investment from this participant
273     if(getState() == State.PreFunding) {
274       // Are we whitelisted for early deposit
275       if(!earlyParticipantWhitelist[receiver]) {
276         revert();
277       }
278     } else if(getState() == State.Funding) {
279       // Retail participants can only come in when the crowdsale is running
280       // pass
281     } else {
282       // Unwanted state
283       revert();
284     }
285 
286     uint weiAmount = msg.value;
287 
288     // Account presale sales separately, so that they do not count against pricing tranches
289     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
290 
291     // Dust transaction
292     require(tokenAmount != 0);
293 	
294 	// set minimum investment
295 	if(tokenAmount < 50) revert(); 
296 
297     if(investedAmountOf[receiver] == 0) {
298        // A new investor
299        investorCount++;
300     }
301 
302     // Update investor
303     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
304     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
305 
306     // Update totals
307     weiRaised = weiRaised.add(weiAmount);
308     tokensSold = tokensSold.add(tokenAmount);
309 
310     if(pricingStrategy.isPresalePurchase(receiver)) {
311         presaleWeiRaised = presaleWeiRaised.add(weiAmount);
312     }
313 
314     // Check that we did not bust the cap
315     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
316 
317     assignTokens(receiver, tokenAmount);
318 
319     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
320     if(!multisigWallet.send(weiAmount)) revert();
321 
322     // Tell us invest was success
323     Invested(receiver, weiAmount, tokenAmount, customerId);
324 
325     return tokenAmount;
326   }
327 
328   /**
329    * Finalize a succcesful crowdsale.
330    *
331    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
332    */
333   function doFinalize() public inState(State.Success) onlyOwner stopInEmergency {
334 
335     // Already finalized
336     if(finalized) {
337       revert();
338     }
339 
340     // Finalizing is optional. We only call it if we are given a finalizing agent.
341     if(address(finalizeAgent) != 0) {
342       finalizeAgent.finalizeCrowdsale();
343     }
344 
345     finalized = true;
346   }
347 
348   /**
349    * Allow to (re)set finalize agent.
350    *
351    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
352    */
353   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
354     finalizeAgent = addr;
355 
356     // Don't allow setting bad agent
357     if(!finalizeAgent.isFinalizeAgent()) {
358       revert();
359     }
360   }
361 
362   /**
363    * Allow crowdsale owner to close early or extend the crowdsale.
364    *
365    * This is useful e.g. for a manual soft cap implementation:
366    * - after X amount is reached determine manual closing
367    *
368    * This may put the crowdsale to an invalid state,
369    * but we trust owners know what they are doing.
370    *
371    */
372   function setEndsAt(uint time) public onlyOwner {
373 
374     if(now > time) {
375       revert(); // Don't change past
376     }
377 
378     if(startsAt > time) {
379       revert(); // Prevent human mistakes
380     }
381 
382     endsAt = time;
383     EndsAtChanged(endsAt);
384   }
385 
386   /**
387    * Allow to (re)set pricing strategy.
388    *
389    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
390    */
391   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
392     pricingStrategy = _pricingStrategy;
393 
394     // Don't allow setting bad agent
395     if(!pricingStrategy.isPricingStrategy()) {
396       revert();
397     }
398   }
399 
400   /**
401    * Allow to change the team multisig address in the case of emergency.
402    *
403    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
404    * (we have done only few test transactions). After the crowdsale is going
405    * then multisig address stays locked for the safety reasons.
406    */
407   function setMultisig(address addr) public onlyOwner {
408 
409     // Change
410     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
411       revert();
412     }
413 
414     multisigWallet = addr;
415   }
416 
417   /**
418    * Allow load refunds back on the contract for the refunding.
419    *
420    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
421    */
422   function loadRefund() public payable inState(State.Failure) {
423     if(msg.value == 0) revert();
424     loadedRefund = loadedRefund.add(msg.value);
425   }
426 
427   /**
428    * Investors can claim refund.
429    *
430    * Note that any refunds from proxy buyers should be handled separately,
431    * and not through this contract.
432    */
433   function refund() public inState(State.Refunding) {
434     uint256 weiValue = investedAmountOf[msg.sender];
435     if (weiValue == 0) revert();
436     investedAmountOf[msg.sender] = 0;
437     weiRefunded = weiRefunded.add(weiValue);
438     Refund(msg.sender, weiValue);
439     if (!msg.sender.send(weiValue)) revert();
440   }
441 
442   /**
443    * @return true if the crowdsale has raised enough money to be a successful.
444    */
445   function isMinimumGoalReached() public constant returns (bool reached) {
446     return weiRaised >= minimumFundingGoal;
447   }
448 
449   /**
450    * Check if the contract relationship looks good.
451    */
452   function isFinalizerSane() public constant returns (bool sane) {
453     return finalizeAgent.isSane();
454   }
455 
456   /**
457    * Check if the contract relationship looks good.
458    */
459   function isPricingSane() public constant returns (bool sane) {
460     return pricingStrategy.isSane(address(this));
461   }
462 
463   /**
464    * Crowdfund state machine management.
465    *
466    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
467    */
468   function getState() public constant returns (State) {
469     if(finalized) return State.Finalized;
470     else if (address(finalizeAgent) == 0) return State.Preparing;
471     else if (!finalizeAgent.isSane()) return State.Preparing;
472     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
473     else if (block.timestamp < startsAt) return State.PreFunding;
474     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
475     else if (isMinimumGoalReached()) return State.Success;
476     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
477     else return State.Failure;
478   }
479 
480   /** This is for manual testing of multisig wallet interaction */
481   function setOwnerTestValue(uint val) public onlyOwner {
482     ownerTestValue = val;
483   }
484 
485   /**
486    * Allow addresses to do early participation.
487    *
488    * TODO: Fix spelling error in the name
489    */
490   function setEarlyParicipantWhitelist(address addr, bool status) public onlyOwner {
491     earlyParticipantWhitelist[addr] = status;
492     Whitelisted(addr, status);
493   }
494 
495 
496   /** Interface marker. */
497   function isCrowdsale() public pure returns (bool) {
498     return true;
499   }
500 
501   //
502   // Modifiers
503   //
504 
505   /** Modified allowing execution only if the crowdsale is currently running.  */
506   modifier inState(State state) {
507     if(getState() != state) revert();
508     _;
509   }
510 
511 
512   //
513   // Abstract functions
514   //
515 
516   /**
517    * Check if the current invested breaks our cap rules.
518    *
519    *
520    * The child contract must define their own cap setting rules.
521    * We allow a lot of flexibility through different capping strategies (ETH, token count)
522    * Called from invest().
523    *
524    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
525    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
526    * @param weiRaisedTotal What would be our total raised balance after this transaction
527    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
528    *
529    * @return true if taking this investment would break our cap rules
530    */
531   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public view returns (bool limitBroken);
532 
533   /**
534    * Check if the current crowdsale is full and we can no longer sell any tokens.
535    */
536   function isCrowdsaleFull() public view returns (bool);
537 
538   /**
539    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
540    */
541   function assignTokens(address receiver, uint tokenAmount) internal;
542 }
543 
544 contract ERC20Basic {
545   function totalSupply() public view returns (uint256);
546   function balanceOf(address who) public view returns (uint256);
547   function transfer(address to, uint256 value) public returns (bool);
548   event Transfer(address indexed from, address indexed to, uint256 value);
549 }
550 
551 contract ERC20 is ERC20Basic {
552   function allowance(address owner, address spender) public view returns (uint256);
553   function transferFrom(address from, address to, uint256 value) public returns (bool);
554   function approve(address spender, uint256 value) public returns (bool);
555   event Approval(address indexed owner, address indexed spender, uint256 value);
556 }
557 
558 contract FractionalERC20 is ERC20 {
559 
560   uint public decimals;
561 
562 }
563 
564 contract PricingStrategy {
565 
566   /** Interface declaration. */
567   function isPricingStrategy() public pure returns (bool) {
568     return true;
569   }
570 
571   /** Self check if all references are correctly set.
572    *
573    * Checks that pricing strategy matches crowdsale parameters.
574    */
575   function isSane(address /*crowdsale*/) public pure returns (bool) {
576     return true;
577   }
578 
579   /**
580    * @dev Pricing tells if this is a presale purchase or not.
581      posible purchaser Address of the purchaser
582      @return False by default, true if a presale purchaser
583    */
584   function isPresalePurchase(address /*purchaser*/) public pure returns (bool) {
585     return false;
586   }
587 
588   /**
589    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
590    *
591    *
592    * @param value - What is the value of the transaction send in as wei
593    * @param tokensSold - how much tokens have been sold this far
594    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
595    * @param msgSender - who is the investor of this transaction
596    * @param decimals - how many decimal units the token has
597    * @return Amount of tokens the investor receives
598    */
599   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public view returns (uint tokenAmount);
600 }
601 
602 contract BasicToken is ERC20Basic {
603   using SafeMath for uint256;
604 
605   mapping(address => uint256) balances;
606 
607   uint256 totalSupply_;
608 
609   /**
610   * @dev total number of tokens in existence
611   */
612   function totalSupply() public view returns (uint256) {
613     return totalSupply_;
614   }
615 
616   /**
617   * @dev transfer token for a specified address
618   * @param _to The address to transfer to.
619   * @param _value The amount to be transferred.
620   */
621   function transfer(address _to, uint256 _value) public returns (bool) {
622     require(_to != address(0));
623     require(_value <= balances[msg.sender]);
624 
625     // SafeMath.sub will throw if there is not enough balance.
626     balances[msg.sender] = balances[msg.sender].sub(_value);
627     balances[_to] = balances[_to].add(_value);
628     Transfer(msg.sender, _to, _value);
629     return true;
630   }
631 
632   /**
633   * @dev Gets the balance of the specified address.
634   * @param _owner The address to query the the balance of.
635   * @return An uint256 representing the amount owned by the passed address.
636   */
637   function balanceOf(address _owner) public view returns (uint256 balance) {
638     return balances[_owner];
639   }
640 
641 }
642 
643 contract StandardToken is ERC20, BasicToken {
644 
645   mapping (address => mapping (address => uint256)) internal allowed;
646 
647 
648   /**
649    * @dev Transfer tokens from one address to another
650    * @param _from address The address which you want to send tokens from
651    * @param _to address The address which you want to transfer to
652    * @param _value uint256 the amount of tokens to be transferred
653    */
654   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
655     require(_to != address(0));
656     require(_value <= balances[_from]);
657     require(_value <= allowed[_from][msg.sender]);
658 
659     balances[_from] = balances[_from].sub(_value);
660     balances[_to] = balances[_to].add(_value);
661     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
662     Transfer(_from, _to, _value);
663     return true;
664   }
665 
666   /**
667    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
668    *
669    * Beware that changing an allowance with this method brings the risk that someone may use both the old
670    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
671    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
672    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
673    * @param _spender The address which will spend the funds.
674    * @param _value The amount of tokens to be spent.
675    */
676   function approve(address _spender, uint256 _value) public returns (bool) {
677     allowed[msg.sender][_spender] = _value;
678     Approval(msg.sender, _spender, _value);
679     return true;
680   }
681 
682   /**
683    * @dev Function to check the amount of tokens that an owner allowed to a spender.
684    * @param _owner address The address which owns the funds.
685    * @param _spender address The address which will spend the funds.
686    * @return A uint256 specifying the amount of tokens still available for the spender.
687    */
688   function allowance(address _owner, address _spender) public view returns (uint256) {
689     return allowed[_owner][_spender];
690   }
691 
692   /**
693    * @dev Increase the amount of tokens that an owner allowed to a spender.
694    *
695    * approve should be called when allowed[_spender] == 0. To increment
696    * allowed value is better to use this function to avoid 2 calls (and wait until
697    * the first transaction is mined)
698    * From MonolithDAO Token.sol
699    * @param _spender The address which will spend the funds.
700    * @param _addedValue The amount of tokens to increase the allowance by.
701    */
702   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
703     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
704     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
705     return true;
706   }
707 
708   /**
709    * @dev Decrease the amount of tokens that an owner allowed to a spender.
710    *
711    * approve should be called when allowed[_spender] == 0. To decrement
712    * allowed value is better to use this function to avoid 2 calls (and wait until
713    * the first transaction is mined)
714    * From MonolithDAO Token.sol
715    * @param _spender The address which will spend the funds.
716    * @param _subtractedValue The amount of tokens to decrease the allowance by.
717    */
718   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
719     uint oldValue = allowed[msg.sender][_spender];
720     if (_subtractedValue > oldValue) {
721       allowed[msg.sender][_spender] = 0;
722     } else {
723       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
724     }
725     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
726     return true;
727   }
728 
729 }
730 
731 contract StandardTokenExt is StandardToken {
732 
733   /* Interface declaration */
734   function isToken() public pure returns (bool weAre) {
735     return true;
736   }
737 }
738 
739 contract MintableToken is StandardTokenExt, Ownable {
740 
741   using SafeMath for uint;
742 
743   bool public mintingFinished = false;
744 
745   /** List of agents that are allowed to create new tokens */
746   mapping (address => bool) public mintAgents;
747 
748   event MintingAgentChanged(address addr, bool state);
749   event Minted(address receiver, uint amount);
750 
751   /**
752    * Create new tokens and allocate them to an address..
753    *
754    * Only callably by a crowdsale contract (mint agent).
755    */
756   function mint(address receiver, uint amount) onlyMintAgent canMint public {
757     totalSupply_ = 	totalSupply_.add(amount);
758     balances[receiver] = balances[receiver].add(amount);
759 
760     // This will make the mint transaction apper in EtherScan.io
761     // We can remove this after there is a standardized minting event
762     Transfer(0, receiver, amount);
763   }
764 
765   /**
766    * Owner can allow a crowdsale contract to mint new tokens.
767    */
768   function setMintAgent(address addr, bool state) onlyOwner canMint public {
769     mintAgents[addr] = state;
770     MintingAgentChanged(addr, state);
771   }
772 
773   modifier onlyMintAgent() {
774     // Only crowdsale contracts are allowed to mint new tokens
775     if(!mintAgents[msg.sender]) {
776         revert();
777     }
778     _;
779   }
780 
781   /** Make sure we are not done yet. */
782   modifier canMint() {
783     if(mintingFinished) revert();
784     _;
785   }
786 }
787 
788 contract WINCrowdsale is CrowdsaleBase {
789 
790   /* Do we need to have unique contributor id for each customer */
791   bool public requireCustomerId;
792 
793   /**
794     * Do we verify that contributor has been cleared on the server side (accredited investors only).
795     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
796     */
797   bool public requiredSignedAddress;
798 
799   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
800   address public signerAddress;
801 
802   function WINCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) public {
803   }
804 
805   /**
806    * Preallocate tokens for the early investors.
807    *
808    * Preallocated tokens have been sold before the actual crowdsale opens.
809    * This function mints the tokens and moves the crowdsale needle.
810    *
811    * Investor count is not handled; it is assumed this goes for multiple investors
812    * and the token distribution happens outside the smart contract flow.
813    *
814    * No money is exchanged, as the crowdsale team already have received the payment.
815    *
816    * @param fullTokens tokens as full tokens - decimal places added internally
817    * @param weiPrice Price of a single full token in wei
818    *
819    */
820   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
821 
822     uint tokenAmount = fullTokens * 10**token.decimals();
823     uint weiAmount = fullTokens * weiPrice; // This can be also 0, we give out tokens for free
824 
825     weiRaised = weiRaised.add(weiAmount);
826     tokensSold = tokensSold.add(tokenAmount);
827 
828     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
829     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
830 
831     assignTokens(receiver, tokenAmount);
832 
833     // Tell us invest was success
834     Invested(receiver, weiAmount, tokenAmount, 0);
835   }
836 
837   
838   
839   /**
840    * bitcoin invest 
841    *
842    * Send WIN token to bitcoin investors during the ICO session
843    * This function mints the tokens and updates the money raised based BTC/ETH ratio 
844    *
845    * Each investor has it own bitcoin investment address, investor count is updated
846    *
847    *
848    * @param fullTokens tokens as full tokens - decimal places added internally
849    * @param weiPrice Price of a single full token in wei
850    *
851    */
852   function bitcoinInvest(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
853 
854 	
855 	// Determine if it's a good time to accept investment from this participant
856     if(getState() == State.PreFunding) {
857       // Are we whitelisted for early deposit
858       if(!earlyParticipantWhitelist[receiver]) {
859         revert();
860       }
861     } else if(getState() == State.Funding) {
862       // Retail participants can only come in when the crowdsale is running
863       // pass
864     } else {
865       // Unwanted state
866       revert();
867     }
868 	
869     uint tokenAmount = fullTokens * 10**token.decimals();
870     uint weiAmount = fullTokens * weiPrice; // This can be also 0, we give out tokens for free
871 
872 
873 	// Dust transaction
874     require(tokenAmount != 0);
875 
876 	// increase investors count
877 	investorCount++;
878    
879     // Update investor
880     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
881     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
882 
883 	//Update Totals
884     weiRaised = weiRaised.add(weiAmount);
885     tokensSold = tokensSold.add(tokenAmount);
886 	
887 	
888     // Check that we did not bust the cap
889     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
890 
891     assignTokens(receiver, tokenAmount);
892 
893     // Tell us invest was success
894     Invested(receiver, weiAmount, tokenAmount, 0);
895 
896 	
897   }
898   
899   
900 
901   /**
902    * Allow anonymous contributions to this crowdsale.
903    */
904   function invest(address addr) public payable {
905     if(requireCustomerId) revert(); // Crowdsale needs to track participants for thank you email
906     if(requiredSignedAddress) revert(); // Crowdsale allows only server-side signed participants
907     investInternal(addr, 0);
908   }
909 
910  
911   /**
912    * Set policy do we need to have server-side customer ids for the investments.
913    *
914    */
915   function setRequireCustomerId(bool value) public onlyOwner {
916     requireCustomerId = value;
917     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
918   }
919 
920   /**
921    * Set policy if all investors must be cleared on the server side first.
922    *
923    * This is e.g. for the accredited investor clearing.
924    *
925    */
926   function setRequireSignedAddress(bool value, address _signerAddress) public onlyOwner {
927     requiredSignedAddress = value;
928     signerAddress = _signerAddress;
929     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
930   }
931 
932 }
933 
934 contract WaWlletTokenCrowdsale is WINCrowdsale {
935 
936   /* Maximum amount of tokens this crowdsale can sell. */
937   uint public maximumSellableTokens;
938 
939   function WaWlletTokenCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) WINCrowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) public {
940     maximumSellableTokens = _maximumSellableTokens;
941   }
942 
943   /**
944    * Called from invest() to confirm if the curret investment does not break our cap rule.
945    */
946   function isBreakingCap(uint /*weiAmount*/, uint /*tokenAmount*/, uint /*weiRaisedTotal*/, uint tokensSoldTotal) public view returns (bool /*limitBroke*/) {
947     return tokensSoldTotal > maximumSellableTokens;
948   }
949 
950   function isCrowdsaleFull() public view returns (bool) {
951     return tokensSold >= maximumSellableTokens;
952   }
953 
954   /**
955    * Dynamically create tokens and assign them to the investor.
956    */
957   function assignTokens(address receiver, uint tokenAmount) internal {
958     MintableToken mintableToken = MintableToken(token);
959     mintableToken.mint(receiver, tokenAmount);
960   }
961   
962   /**
963    * Dynamically create tokens and assign them to the investor.
964    */
965   /**
966    * Allow direct contributions to this crowdsale.
967    */
968   function () public payable {
969         invest(msg.sender);
970   }
971 }