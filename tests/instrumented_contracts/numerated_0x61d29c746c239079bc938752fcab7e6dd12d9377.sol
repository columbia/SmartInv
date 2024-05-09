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
21 contract PricingStrategy {
22 
23   /** Interface declaration. */
24   function isPricingStrategy() public constant returns (bool) {
25     return true;
26   }
27 
28   /** Self check if all references are correctly set.
29    *
30    * Checks that pricing strategy matches crowdsale parameters.
31    */
32   function isSane(address crowdsale) public constant returns (bool) {
33     return true;
34   }
35 
36   /**
37    * @dev Pricing tells if this is a presale purchase or not.
38      @param purchaser Address of the purchaser
39      @return False by default, true if a presale purchaser
40    */
41   function isPresalePurchase(address purchaser) public constant returns (bool) {
42     return false;
43   }
44 
45   /**
46    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
47    *
48    *
49    * @param value - What is the value of the transaction send in as wei
50    * @param tokensSold - how much tokens have been sold this far
51    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
52    * @param msgSender - who is the investor of this transaction
53    * @param decimals - how many decimal units the token has
54    * @return Amount of tokens the investor receives
55    */
56   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
57 }
58 
59 library SafeMathLib {
60 
61   function times(uint a, uint b) returns (uint) {
62     uint c = a * b;
63     assert(a == 0 || c / a == b);
64     return c;
65   }
66 
67   function minus(uint a, uint b) returns (uint) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function plus(uint a, uint b) returns (uint) {
73     uint c = a + b;
74     assert(c>=a);
75     return c;
76   }
77 
78 }
79 
80 contract Ownable {
81   address public owner;
82 
83 
84   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86 
87   /**
88    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89    * account.
90    */
91   function Ownable() public {
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address newOwner) public onlyOwner {
108     require(newOwner != address(0));
109     OwnershipTransferred(owner, newOwner);
110     owner = newOwner;
111   }
112 
113 }
114 
115 contract Recoverable is Ownable {
116 
117   /// @dev Empty constructor (for now)
118   function Recoverable() {
119   }
120 
121   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
122   /// @param token Token which will we rescue to the owner from the contract
123   function recoverTokens(ERC20Basic token) onlyOwner public {
124     token.transfer(owner, tokensToBeReturned(token));
125   }
126 
127   /// @dev Interface function, can be overwritten by the superclass
128   /// @param token Token which balance we will check and return
129   /// @return The amount of tokens (in smallest denominator) the contract owns
130   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
131     return token.balanceOf(this);
132   }
133 }
134 
135 contract Haltable is Ownable {
136   bool public halted;
137 
138   modifier stopInEmergency {
139     if (halted) throw;
140     _;
141   }
142 
143   modifier stopNonOwnersInEmergency {
144     if (halted && msg.sender != owner) throw;
145     _;
146   }
147 
148   modifier onlyInEmergency {
149     if (!halted) throw;
150     _;
151   }
152 
153   // called by the owner on emergency, triggers stopped state
154   function halt() external onlyOwner {
155     halted = true;
156   }
157 
158   // called by the owner on end of emergency, returns to normal state
159   function unhalt() external onlyOwner onlyInEmergency {
160     halted = false;
161   }
162 
163 }
164 
165 contract Whitelist is Ownable {
166   mapping(address => bool) public whitelist;
167   
168   event WhitelistedAddressAdded(address addr);
169   event WhitelistedAddressRemoved(address addr);
170 
171   /**
172    * @dev Throws if called by any account that's not whitelisted.
173    */
174   modifier onlyWhitelisted() {
175     require(whitelist[msg.sender]);
176     _;
177   }
178 
179   /**
180    * @dev add an address to the whitelist
181    * @param addr address
182    * @return true if the address was added to the whitelist, false if the address was already in the whitelist 
183    */
184   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
185     if (!whitelist[addr]) {
186       whitelist[addr] = true;
187       WhitelistedAddressAdded(addr);
188       success = true; 
189     }
190   }
191 
192   /**
193    * @dev add addresses to the whitelist
194    * @param addrs addresses
195    * @return true if at least one address was added to the whitelist, 
196    * false if all addresses were already in the whitelist  
197    */
198   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
199     for (uint256 i = 0; i < addrs.length; i++) {
200       if (addAddressToWhitelist(addrs[i])) {
201         success = true;
202       }
203     }
204   }
205 
206   /**
207    * @dev remove an address from the whitelist
208    * @param addr address
209    * @return true if the address was removed from the whitelist, 
210    * false if the address wasn't in the whitelist in the first place 
211    */
212   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
213     if (whitelist[addr]) {
214       whitelist[addr] = false;
215       WhitelistedAddressRemoved(addr);
216       success = true;
217     }
218   }
219 
220   /**
221    * @dev remove addresses from the whitelist
222    * @param addrs addresses
223    * @return true if at least one address was removed from the whitelist, 
224    * false if all addresses weren't in the whitelist in the first place
225    */
226   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
227     for (uint256 i = 0; i < addrs.length; i++) {
228       if (removeAddressFromWhitelist(addrs[i])) {
229         success = true;
230       }
231     }
232   }
233 
234 }
235 
236 contract ERC20Basic {
237   function totalSupply() public view returns (uint256);
238   function balanceOf(address who) public view returns (uint256);
239   function transfer(address to, uint256 value) public returns (bool);
240   event Transfer(address indexed from, address indexed to, uint256 value);
241 }
242 
243 contract ERC20 is ERC20Basic {
244   function allowance(address owner, address spender) public view returns (uint256);
245   function transferFrom(address from, address to, uint256 value) public returns (bool);
246   function approve(address spender, uint256 value) public returns (bool);
247   event Approval(address indexed owner, address indexed spender, uint256 value);
248 }
249 
250 contract FractionalERC20 is ERC20 {
251 
252   uint public decimals;
253 
254 }
255 
256 library SafeMath {
257 
258   /**
259   * @dev Multiplies two numbers, throws on overflow.
260   */
261   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262     if (a == 0) {
263       return 0;
264     }
265     uint256 c = a * b;
266     assert(c / a == b);
267     return c;
268   }
269 
270   /**
271   * @dev Integer division of two numbers, truncating the quotient.
272   */
273   function div(uint256 a, uint256 b) internal pure returns (uint256) {
274     // assert(b > 0); // Solidity automatically throws when dividing by 0
275     uint256 c = a / b;
276     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
277     return c;
278   }
279 
280   /**
281   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
282   */
283   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284     assert(b <= a);
285     return a - b;
286   }
287 
288   /**
289   * @dev Adds two numbers, throws on overflow.
290   */
291   function add(uint256 a, uint256 b) internal pure returns (uint256) {
292     uint256 c = a + b;
293     assert(c >= a);
294     return c;
295   }
296 }
297 
298 contract BasicToken is ERC20Basic {
299   using SafeMath for uint256;
300 
301   mapping(address => uint256) balances;
302 
303   uint256 totalSupply_;
304 
305   /**
306   * @dev total number of tokens in existence
307   */
308   function totalSupply() public view returns (uint256) {
309     return totalSupply_;
310   }
311 
312   /**
313   * @dev transfer token for a specified address
314   * @param _to The address to transfer to.
315   * @param _value The amount to be transferred.
316   */
317   function transfer(address _to, uint256 _value) public returns (bool) {
318     require(_to != address(0));
319     require(_value <= balances[msg.sender]);
320 
321     // SafeMath.sub will throw if there is not enough balance.
322     balances[msg.sender] = balances[msg.sender].sub(_value);
323     balances[_to] = balances[_to].add(_value);
324     Transfer(msg.sender, _to, _value);
325     return true;
326   }
327 
328   /**
329   * @dev Gets the balance of the specified address.
330   * @param _owner The address to query the the balance of.
331   * @return An uint256 representing the amount owned by the passed address.
332   */
333   function balanceOf(address _owner) public view returns (uint256 balance) {
334     return balances[_owner];
335   }
336 
337 }
338 
339 contract StandardToken is ERC20, BasicToken {
340 
341   mapping (address => mapping (address => uint256)) internal allowed;
342 
343 
344   /**
345    * @dev Transfer tokens from one address to another
346    * @param _from address The address which you want to send tokens from
347    * @param _to address The address which you want to transfer to
348    * @param _value uint256 the amount of tokens to be transferred
349    */
350   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
351     require(_to != address(0));
352     require(_value <= balances[_from]);
353     require(_value <= allowed[_from][msg.sender]);
354 
355     balances[_from] = balances[_from].sub(_value);
356     balances[_to] = balances[_to].add(_value);
357     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
358     Transfer(_from, _to, _value);
359     return true;
360   }
361 
362   /**
363    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
364    *
365    * Beware that changing an allowance with this method brings the risk that someone may use both the old
366    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
367    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
368    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
369    * @param _spender The address which will spend the funds.
370    * @param _value The amount of tokens to be spent.
371    */
372   function approve(address _spender, uint256 _value) public returns (bool) {
373     allowed[msg.sender][_spender] = _value;
374     Approval(msg.sender, _spender, _value);
375     return true;
376   }
377 
378   /**
379    * @dev Function to check the amount of tokens that an owner allowed to a spender.
380    * @param _owner address The address which owns the funds.
381    * @param _spender address The address which will spend the funds.
382    * @return A uint256 specifying the amount of tokens still available for the spender.
383    */
384   function allowance(address _owner, address _spender) public view returns (uint256) {
385     return allowed[_owner][_spender];
386   }
387 
388   /**
389    * @dev Increase the amount of tokens that an owner allowed to a spender.
390    *
391    * approve should be called when allowed[_spender] == 0. To increment
392    * allowed value is better to use this function to avoid 2 calls (and wait until
393    * the first transaction is mined)
394    * From MonolithDAO Token.sol
395    * @param _spender The address which will spend the funds.
396    * @param _addedValue The amount of tokens to increase the allowance by.
397    */
398   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
399     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
400     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
401     return true;
402   }
403 
404   /**
405    * @dev Decrease the amount of tokens that an owner allowed to a spender.
406    *
407    * approve should be called when allowed[_spender] == 0. To decrement
408    * allowed value is better to use this function to avoid 2 calls (and wait until
409    * the first transaction is mined)
410    * From MonolithDAO Token.sol
411    * @param _spender The address which will spend the funds.
412    * @param _subtractedValue The amount of tokens to decrease the allowance by.
413    */
414   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
415     uint oldValue = allowed[msg.sender][_spender];
416     if (_subtractedValue > oldValue) {
417       allowed[msg.sender][_spender] = 0;
418     } else {
419       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
420     }
421     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
422     return true;
423   }
424 
425 }
426 
427 contract CrowdsaleBase is Haltable, Whitelist {
428 
429   /* Max investment count when we are still allowed to change the multisig address */
430   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
431 
432   using SafeMathLib for uint;
433 
434   /* The token we are selling */
435   FractionalERC20 public token;
436 
437   /* How we are going to price our offering */
438   PricingStrategy public pricingStrategy;
439 
440   /* Post-success callback */
441   FinalizeAgent public finalizeAgent;
442 
443   /* tokens will be transfered from this address */
444   address public multisigWallet;
445 
446   /* if the funding goal is not reached, investors may withdraw their funds */
447   uint public minimumFundingGoal;
448 
449   /* the UNIX timestamp start date of the crowdsale */
450   uint public startsAt;
451 
452   /* the UNIX timestamp end date of the crowdsale */
453   uint public endsAt;
454 
455   /* the number of tokens already sold through this contract*/
456   uint public tokensSold = 0;
457 
458   /* How many wei of funding we have raised */
459   uint public weiRaised = 0;
460 
461   /* Calculate incoming funds from presale contracts and addresses */
462   uint public presaleWeiRaised = 0;
463 
464   /* How many distinct addresses have invested */
465   uint public investorCount = 0;
466 
467   /* How much wei we have returned back to the contract after a failed crowdfund. */
468   uint public loadedRefund = 0;
469 
470   /* How much wei we have given back to investors.*/
471   uint public weiRefunded = 0;
472 
473   /* Has this crowdsale been finalized */
474   bool public finalized;
475 
476   /** How much ETH each address has invested to this crowdsale */
477   mapping (address => uint256) public investedAmountOf;
478 
479   /** How much tokens this crowdsale has credited for each investor address */
480   mapping (address => uint256) public tokenAmountOf;
481 
482   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
483   mapping (address => bool) public earlyParticipantWhitelist;
484 
485   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
486   uint public ownerTestValue;
487 
488   /** State machine
489    *
490    * - Preparing: All contract initialization calls and variables have not been set yet
491    * - Prefunding: We have not passed start time yet
492    * - Funding: Active crowdsale
493    * - Success: Minimum funding goal reached
494    * - Failure: Minimum funding goal not reached before ending time
495    * - Finalized: The finalized has been called and succesfully executed
496    * - Refunding: Refunds are loaded on the contract for reclaim.
497    */
498   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
499 
500   // A new investment was made
501   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
502 
503   // Refund was processed for a contributor
504   event Refund(address investor, uint weiAmount);
505 
506   // The rules were changed what kind of investments we accept
507   event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
508 
509   // Address early participation whitelist status changed
510   event Whitelisted(address addr, bool status);
511 
512   // Crowdsale end time has been changed
513   event EndsAtChanged(uint newEndsAt);
514 
515   function CrowdsaleBase(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {
516 
517     owner = msg.sender;
518 
519     token = FractionalERC20(_token);
520     setPricingStrategy(_pricingStrategy);
521 
522     multisigWallet = _multisigWallet;
523     if(multisigWallet == 0) {
524         throw;
525     }
526 
527     if(_start == 0) {
528         throw;
529     }
530 
531     startsAt = _start;
532 
533     if(_end == 0) {
534         throw;
535     }
536 
537     endsAt = _end;
538 
539     // Don't mess the dates
540     if(startsAt >= endsAt) {
541         throw;
542     }
543 
544     // Minimum funding goal can be zero
545     minimumFundingGoal = _minimumFundingGoal;
546   }
547 
548   /**
549    * Don't expect to just send in money and get tokens.
550    *
551    * function() payable {
552    *  throw;
553    * }
554    */
555 
556   /**
557    * Make an investment.
558    *
559    * Crowdsale must be running for one to invest.
560    * We must have not pressed the emergency brake.
561    *
562    * @param receiver The Ethereum address who receives the tokens
563    * @param customerId (optional) UUID v4 to track the successful payments on the server side'
564    *
565    * @return tokenAmount How mony tokens were bought
566    */
567   function investInternal(address receiver, uint128 customerId) stopInEmergency internal returns(uint tokensBought) {
568 
569     // Determine reciever address is Whitelisted or not.
570 	//   require(whitelist[msg.sender]);
571 	//   require(whitelist[receiver]);
572     
573     // Define address of a pre-deployed Whitelist Contract and call the whitelist function on the contract to verify msg.sender and receiver
574     Whitelist dc;
575     address contract_addr = 0x062e41d1037745dc203e8c1AAcA651B8d157Da96;
576     dc = Whitelist(contract_addr);
577     require (dc.whitelist(msg.sender));
578     require (dc.whitelist(receiver));
579     
580     
581     // Determine if it's a good time to accept investment from this participant
582     if(getState() == State.PreFunding) {
583       // Are we whitelisted for early deposit
584       if(!earlyParticipantWhitelist[receiver]) {
585         throw;
586       }
587     } else if(getState() == State.Funding) {
588       // Retail participants can only come in when the crowdsale is running
589       // pass
590     } else {
591       // Unwanted state
592       throw;
593     }
594 
595     uint weiAmount = msg.value;
596     require(weiAmount >= minimumFundingGoal);
597     
598     // Account presale sales separately, so that they do not count against pricing tranches
599     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
600 
601     // Dust transaction
602     require(tokenAmount != 0);
603 
604     if(investedAmountOf[receiver] == 0) {
605        // A new investor
606        investorCount++;
607     }
608 
609     // Update investor
610     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
611     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
612 
613     // Update totals
614     weiRaised = weiRaised.plus(weiAmount);
615     tokensSold = tokensSold.plus(tokenAmount);
616 
617     if(pricingStrategy.isPresalePurchase(receiver)) {
618         presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
619     }
620 
621     // Check that we did not bust the cap
622     require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
623 
624     assignTokens(receiver, tokenAmount);
625 
626     // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our multisig
627     if(!multisigWallet.send(weiAmount)) throw;
628 
629     // Tell us invest was success
630     Invested(receiver, weiAmount, tokenAmount, customerId);
631 
632     return tokenAmount;
633   }
634 
635   /**
636    * Finalize a succcesful crowdsale.
637    *
638    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
639    */
640   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
641 
642     // Already finalized
643     if(finalized) {
644       throw;
645     }
646 
647     // Finalizing is optional. We only call it if we are given a finalizing agent.
648     if(address(finalizeAgent) != 0) {
649       finalizeAgent.finalizeCrowdsale();
650     }
651 
652     finalized = true;
653   }
654 
655   /**
656    * Allow to (re)set finalize agent.
657    *
658    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
659    */
660   function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
661     finalizeAgent = addr;
662 
663     // Don't allow setting bad agent
664     if(!finalizeAgent.isFinalizeAgent()) {
665       throw;
666     }
667   }
668 
669   /**
670    * Allow crowdsale owner to close early or extend the crowdsale.
671    *
672    * This is useful e.g. for a manual soft cap implementation:
673    * - after X amount is reached determine manual closing
674    *
675    * This may put the crowdsale to an invalid state,
676    * but we trust owners know what they are doing.
677    *
678    */
679   function setEndsAt(uint time) onlyOwner {
680 
681     if(now > time) {
682       throw; // Don't change past
683     }
684 
685     if(startsAt > time) {
686       throw; // Prevent human mistakes
687     }
688 
689     endsAt = time;
690     EndsAtChanged(endsAt);
691   }
692 
693   /**
694    * Allow to (re)set pricing strategy.
695    *
696    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
697    */
698   function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
699     pricingStrategy = _pricingStrategy;
700 
701     // Don't allow setting bad agent
702     if(!pricingStrategy.isPricingStrategy()) {
703       throw;
704     }
705   }
706 
707   /**
708    * Allow to change the team multisig address in the case of emergency.
709    *
710    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
711    * (we have done only few test transactions). After the crowdsale is going
712    * then multisig address stays locked for the safety reasons.
713    */
714   function setMultisig(address addr) public onlyOwner {
715 
716     // Change
717     if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
718       throw;
719     }
720 
721     multisigWallet = addr;
722   }
723 
724   /**
725    * Allow load refunds back on the contract for the refunding.
726    *
727    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
728    */
729   function loadRefund() public payable inState(State.Failure) {
730     if(msg.value == 0) throw;
731     loadedRefund = loadedRefund.plus(msg.value);
732   }
733 
734   /**
735    * Investors can claim refund.
736    *
737    * Note that any refunds from proxy buyers should be handled separately,
738    * and not through this contract.
739    */
740   function refund() public inState(State.Refunding) {
741     uint256 weiValue = investedAmountOf[msg.sender];
742     if (weiValue == 0) throw;
743     investedAmountOf[msg.sender] = 0;
744     weiRefunded = weiRefunded.plus(weiValue);
745     Refund(msg.sender, weiValue);
746     if (!msg.sender.send(weiValue)) throw;
747   }
748 
749   /**
750    * @return true if the crowdsale has raised enough money to be a successful.
751    */
752   function isMinimumGoalReached() public constant returns (bool reached) {
753     return weiRaised >= minimumFundingGoal;
754   }
755 
756   /**
757    * Check if the contract relationship looks good.
758    */
759   function isFinalizerSane() public constant returns (bool sane) {
760     return finalizeAgent.isSane();
761   }
762 
763   /**
764    * Check if the contract relationship looks good.
765    */
766   function isPricingSane() public constant returns (bool sane) {
767     return pricingStrategy.isSane(address(this));
768   }
769 
770   /**
771    * Crowdfund state machine management.
772    *
773    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
774    */
775   function getState() public constant returns (State) {
776     if(finalized) return State.Finalized;
777     else if (address(finalizeAgent) == 0) return State.Preparing;
778     else if (!finalizeAgent.isSane()) return State.Preparing;
779     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
780     else if (block.timestamp < startsAt) return State.PreFunding;
781     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
782     else if (isMinimumGoalReached()) return State.Success;
783     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
784     else return State.Failure;
785   }
786 
787   /** This is for manual testing of multisig wallet interaction */
788   function setOwnerTestValue(uint val) onlyOwner {
789     ownerTestValue = val;
790   }
791 
792   /**
793    * Allow addresses to do early participation.
794    *
795    * TODO: Fix spelling error in the name
796    */
797   function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
798     earlyParticipantWhitelist[addr] = status;
799     Whitelisted(addr, status);
800   }
801 
802 
803   /** Interface marker. */
804   function isCrowdsale() public constant returns (bool) {
805     return true;
806   }
807 
808   //
809   // Modifiers
810   //
811 
812   /** Modified allowing execution only if the crowdsale is currently running.  */
813   modifier inState(State state) {
814     if(getState() != state) throw;
815     _;
816   }
817 
818 
819   //
820   // Abstract functions
821   //
822 
823   /**
824    * Check if the current invested breaks our cap rules.
825    *
826    *
827    * The child contract must define their own cap setting rules.
828    * We allow a lot of flexibility through different capping strategies (ETH, token count)
829    * Called from invest().
830    *
831    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
832    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
833    * @param weiRaisedTotal What would be our total raised balance after this transaction
834    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
835    *
836    * @return true if taking this investment would break our cap rules
837    */
838   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
839 
840   /**
841    * Check if the current crowdsale is full and we can no longer sell any tokens.
842    */
843   function isCrowdsaleFull() public constant returns (bool);
844 
845   /**
846    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
847    */
848   function assignTokens(address receiver, uint tokenAmount) internal;
849 }
850 
851 contract Crowdsale is CrowdsaleBase {
852 
853   /* Do we need to have unique contributor id for each customer */
854   bool public requireCustomerId;
855 
856   /**
857     * Do we verify that contributor has been cleared on the server side (accredited investors only).
858     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
859     */
860   bool public requiredSignedAddress;
861 
862   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
863   address public signerAddress;
864 
865   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) CrowdsaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
866   }
867 
868   /**
869    * Preallocate tokens for the early investors.
870    *
871    * Preallocated tokens have been sold before the actual crowdsale opens.
872    * This function mints the tokens and moves the crowdsale needle.
873    *
874    * Investor count is not handled; it is assumed this goes for multiple investors
875    * and the token distribution happens outside the smart contract flow.
876    *
877    * No money is exchanged, as the crowdsale team already have received the payment.
878    *
879    * @param fullTokens tokens as full tokens - decimal places added internally
880    * @param weiPrice Price of a single full token in wei
881    *
882    */
883   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
884 
885     uint tokenAmount = fullTokens * 10**token.decimals();
886     uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
887 
888     weiRaised = weiRaised.plus(weiAmount);
889     tokensSold = tokensSold.plus(tokenAmount);
890 
891     investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
892     tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
893 
894     assignTokens(receiver, tokenAmount);
895 
896     // Tell us invest was success
897     Invested(receiver, weiAmount, tokenAmount, 0);
898   }
899 
900   /**
901    * Allow anonymous contributions to this crowdsale.
902    */
903   function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
904      bytes32 hash = sha256(addr);
905      if (ecrecover(hash, v, r, s) != signerAddress) throw;
906      if(customerId == 0) throw;  // UUIDv4 sanity check
907      investInternal(addr, customerId);
908   }
909 
910   /**
911    * Track who is the customer making the payment so we can send thank you email.
912    */
913   function investWithCustomerId(address addr, uint128 customerId) public payable {
914     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
915     if(customerId == 0) throw;  // UUIDv4 sanity check
916     investInternal(addr, customerId);
917   }
918 
919   /**
920    * Allow anonymous contributions to this crowdsale.
921    */
922   function invest(address addr) public payable {
923     if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
924     if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
925     investInternal(addr, 0);
926   }
927 
928   /**
929    * Invest to tokens, recognize the payer and clear his address.
930    *
931    */
932   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
933     investWithSignedAddress(msg.sender, customerId, v, r, s);
934   }
935 
936   /**
937    * Invest to tokens, recognize the payer.
938    *
939    */
940   function buyWithCustomerIdWithChecksum(uint128 customerId, bytes1 checksum) public payable {
941     // see customerid.py
942     if (bytes1(sha3(customerId)) != checksum) throw;
943     investWithCustomerId(msg.sender, customerId);
944   }
945 
946   /**
947    * Legacy API signature.
948    */
949   function buyWithCustomerId(uint128 customerId) public payable {
950     investWithCustomerId(msg.sender, customerId);
951   }
952 
953   /**
954    * The basic entry point to participate the crowdsale process.
955    *
956    * Pay for funding, get invested tokens back in the sender address.
957    */
958   function buy() public payable {
959     invest(msg.sender);
960   }
961 
962   /**
963    * Set policy do we need to have server-side customer ids for the investments.
964    *
965    */
966   function setRequireCustomerId(bool value) onlyOwner {
967     requireCustomerId = value;
968     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
969   }
970 
971   /**
972    * Set policy if all investors must be cleared on the server side first.
973    *
974    * This is e.g. for the accredited investor clearing.
975    *
976    */
977   function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
978     requiredSignedAddress = value;
979     signerAddress = _signerAddress;
980     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
981   }
982 
983 
984   /** Default function to allow for Sending Ether to contract and Recieving Tokens  */
985 	
986   function () public payable {
987      invest(msg.sender);
988   }
989 
990 }
991 
992 contract MintedTokenCappedCrowdsale is Crowdsale {
993 
994   /* Maximum amount of tokens this crowdsale can sell. */
995   uint public maximumSellableTokens;
996 
997   function MintedTokenCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens) Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
998     maximumSellableTokens = _maximumSellableTokens;
999   }
1000 
1001   /**
1002    * Called from invest() to confirm if the curret investment does not break our cap rule.
1003    */
1004   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1005     return tokensSoldTotal > maximumSellableTokens;
1006   }
1007 
1008   function isCrowdsaleFull() public constant returns (bool) {
1009     return tokensSold >= maximumSellableTokens;
1010   }
1011 
1012   /**
1013    * Dynamically create tokens and assign them to the investor.
1014    */
1015   function assignTokens(address receiver, uint tokenAmount) internal {
1016     MintableToken mintableToken = MintableToken(token);
1017     mintableToken.mint(receiver, tokenAmount);
1018   }
1019 }
1020 
1021 contract ERC827 is ERC20 {
1022 
1023   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
1024   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
1025   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
1026 
1027 }
1028 
1029 contract ERC827Token is ERC827, StandardToken {
1030 
1031   /**
1032      @dev Addition to ERC20 token methods. It allows to
1033      approve the transfer of value and execute a call with the sent data.
1034 
1035      Beware that changing an allowance with this method brings the risk that
1036      someone may use both the old and the new allowance by unfortunate
1037      transaction ordering. One possible solution to mitigate this race condition
1038      is to first reduce the spender's allowance to 0 and set the desired value
1039      afterwards:
1040      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1041 
1042      @param _spender The address that will spend the funds.
1043      @param _value The amount of tokens to be spent.
1044      @param _data ABI-encoded contract call to call `_to` address.
1045 
1046      @return true if the call function was executed successfully
1047    */
1048   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
1049     require(_spender != address(this));
1050 
1051     super.approve(_spender, _value);
1052 
1053     require(_spender.call(_data));
1054 
1055     return true;
1056   }
1057 
1058   /**
1059      @dev Addition to ERC20 token methods. Transfer tokens to a specified
1060      address and execute a call with the sent data on the same transaction
1061 
1062      @param _to address The address which you want to transfer to
1063      @param _value uint256 the amout of tokens to be transfered
1064      @param _data ABI-encoded contract call to call `_to` address.
1065 
1066      @return true if the call function was executed successfully
1067    */
1068   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
1069     require(_to != address(this));
1070 
1071     super.transfer(_to, _value);
1072 
1073     require(_to.call(_data));
1074     return true;
1075   }
1076 
1077   /**
1078      @dev Addition to ERC20 token methods. Transfer tokens from one address to
1079      another and make a contract call on the same transaction
1080 
1081      @param _from The address which you want to send tokens from
1082      @param _to The address which you want to transfer to
1083      @param _value The amout of tokens to be transferred
1084      @param _data ABI-encoded contract call to call `_to` address.
1085 
1086      @return true if the call function was executed successfully
1087    */
1088   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
1089     require(_to != address(this));
1090 
1091     super.transferFrom(_from, _to, _value);
1092 
1093     require(_to.call(_data));
1094     return true;
1095   }
1096 
1097   /**
1098    * @dev Addition to StandardToken methods. Increase the amount of tokens that
1099    * an owner allowed to a spender and execute a call with the sent data.
1100    *
1101    * approve should be called when allowed[_spender] == 0. To increment
1102    * allowed value is better to use this function to avoid 2 calls (and wait until
1103    * the first transaction is mined)
1104    * From MonolithDAO Token.sol
1105    * @param _spender The address which will spend the funds.
1106    * @param _addedValue The amount of tokens to increase the allowance by.
1107    * @param _data ABI-encoded contract call to call `_spender` address.
1108    */
1109   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
1110     require(_spender != address(this));
1111 
1112     super.increaseApproval(_spender, _addedValue);
1113 
1114     require(_spender.call(_data));
1115 
1116     return true;
1117   }
1118 
1119   /**
1120    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
1121    * an owner allowed to a spender and execute a call with the sent data.
1122    *
1123    * approve should be called when allowed[_spender] == 0. To decrement
1124    * allowed value is better to use this function to avoid 2 calls (and wait until
1125    * the first transaction is mined)
1126    * From MonolithDAO Token.sol
1127    * @param _spender The address which will spend the funds.
1128    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1129    * @param _data ABI-encoded contract call to call `_spender` address.
1130    */
1131   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
1132     require(_spender != address(this));
1133 
1134     super.decreaseApproval(_spender, _subtractedValue);
1135 
1136     require(_spender.call(_data));
1137 
1138     return true;
1139   }
1140 
1141 }
1142 
1143 contract StandardTokenExt is StandardToken, ERC827Token, Recoverable {
1144 
1145   /* Interface declaration */
1146   function isToken() public constant returns (bool weAre) {
1147     return true;
1148   }
1149 }
1150 
1151 contract MintableToken is StandardTokenExt {
1152 
1153   using SafeMathLib for uint;
1154 
1155   bool public mintingFinished = false;
1156 
1157   /** List of agents that are allowed to create new tokens */
1158   mapping (address => bool) public mintAgents;
1159 
1160   event MintingAgentChanged(address addr, bool state);
1161   event Minted(address receiver, uint amount);
1162 
1163   /**
1164    * Create new tokens and allocate them to an address..
1165    *
1166    * Only callably by a crowdsale contract (mint agent).
1167    */
1168   function mint(address receiver, uint amount) onlyMintAgent canMint public {
1169     totalSupply_ = totalSupply_.plus(amount);
1170     balances[receiver] = balances[receiver].plus(amount);
1171 
1172     // This will make the mint transaction apper in EtherScan.io
1173     // We can remove this after there is a standardized minting event
1174     Transfer(0, receiver, amount);
1175   }
1176 
1177   /**
1178    * Owner can allow a crowdsale contract to mint new tokens.
1179    */
1180   function setMintAgent(address addr, bool state) onlyOwner canMint public {
1181     mintAgents[addr] = state;
1182     MintingAgentChanged(addr, state);
1183   }
1184 
1185   modifier onlyMintAgent() {
1186     // Only crowdsale contracts are allowed to mint new tokens
1187     if(!mintAgents[msg.sender]) {
1188         throw;
1189     }
1190     _;
1191   }
1192 
1193   /** Make sure we are not done yet. */
1194   modifier canMint() {
1195     if(mintingFinished) throw;
1196     _;
1197   }
1198 }