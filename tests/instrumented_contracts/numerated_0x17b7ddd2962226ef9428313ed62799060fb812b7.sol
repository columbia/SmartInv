1 pragma solidity ^0.4.15;
2 
3 /** Github repository: https://github.com/CoinFabrik/ico/tree/hagglin-preico */
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control 
8  * functions, this simplifies the implementation of "user permissions". 
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   /** 
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner. 
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     require(newOwner != address(0));
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * Abstract contract that allows children to implement an
45  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
46  *
47  */
48 contract Haltable is Ownable {
49   bool public halted;
50 
51   event Halted(bool halted);
52 
53   modifier stopInEmergency {
54     require(!halted);
55     _;
56   }
57 
58   modifier onlyInEmergency {
59     require(halted);
60     _;
61   }
62 
63   // called by the owner on emergency, triggers stopped state
64   function halt() external onlyOwner {
65     halted = true;
66     Halted(true);
67   }
68 
69   // called by the owner on end of emergency, returns to normal state
70   function unhalt() external onlyOwner onlyInEmergency {
71     halted = false;
72     Halted(false);
73   }
74 
75 }
76 
77 /**
78  * Math operations with safety checks
79  */
80 library SafeMath {
81   function mul(uint a, uint b) internal returns (uint) {
82     uint c = a * b;
83     assert(a == 0 || c / a == b);
84     return c;
85   }
86 
87   function div(uint a, uint b) internal returns (uint) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint a, uint b) internal returns (uint) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint a, uint b) internal returns (uint) {
100     uint c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 
105   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
106     return a >= b ? a : b;
107   }
108 
109   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
110     return a < b ? a : b;
111   }
112 
113   function max256(uint a, uint b) internal constant returns (uint) {
114     return a >= b ? a : b;
115   }
116 
117   function min256(uint a, uint b) internal constant returns (uint) {
118     return a < b ? a : b;
119   }
120 }
121 
122 /**
123  * Finalize agent defines what happens at the end of a succesful crowdsale.
124  *
125  * - Allocate tokens for founders, bounties and community
126  * - Make tokens transferable
127  * - etc.
128  */
129 contract FinalizeAgent {
130 
131   function isFinalizeAgent() public constant returns(bool) {
132     return true;
133   }
134 
135   /** Return true if we can run finalizeCrowdsale() properly.
136    *
137    * This is a safety check function that doesn't allow crowdsale to begin
138    * unless the finalizer has been set up properly.
139    */
140   function isSane(CrowdsaleToken token) public constant returns (bool);
141 
142   /** Called once by crowdsale finalize() if the sale was a success. */
143   function finalizeCrowdsale(CrowdsaleToken token) public;
144 
145 }
146 
147 /**
148  * Abstract base contract for token sales.
149  *
150  * Handles
151  * - start and end dates
152  * - accepting investments
153  * - minimum funding goal and refund
154  * - various statistics during the crowdfund
155  * - different investment policies (require server side customer id, allow only whitelisted addresses)
156  *
157  */
158 contract GenericCrowdsale is Haltable {
159 
160   using SafeMath for uint;
161 
162   /* The token we are selling */
163   CrowdsaleToken public token;
164 
165   /* Post-success callback */
166   FinalizeAgent public finalizeAgent;
167 
168   /* ether will be transferred to this address */
169   address public multisigWallet;
170 
171   /* if the funding goal is not reached, investors may withdraw their funds */
172   uint public minimumFundingGoal;
173 
174   /* the starting block number of the crowdsale */
175   uint public startsAt;
176 
177   /* the ending block number of the crowdsale */
178   uint public endsAt;
179 
180   /* the number of tokens already sold through this contract*/
181   uint public tokensSold = 0;
182 
183   /* How many wei of funding we have raised */
184   uint public weiRaised = 0;
185 
186   /* How many distinct addresses have invested */
187   uint public investorCount = 0;
188 
189   /* How many wei we have returned back to the contract after a failed crowdfund. */
190   uint public loadedRefund = 0;
191 
192   /* How many wei we have given back to investors.*/
193   uint public weiRefunded = 0;
194 
195   /* Has this crowdsale been finalized */
196   bool public finalized = false;
197 
198   /* Do we need to have a unique contributor id for each customer */
199   bool public requireCustomerId = false;
200 
201   /** How many ETH each address has invested in this crowdsale */
202   mapping (address => uint) public investedAmountOf;
203 
204   /** How many tokens this crowdsale has credited for each investor address */
205   mapping (address => uint) public tokenAmountOf;
206 
207   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
208   mapping (address => bool) public earlyParticipantWhitelist;
209 
210   /** This is for manual testing of the interaction with the owner's wallet. You can set it to any value and inspect this in a blockchain explorer to see that crowdsale interaction works. */
211   uint8 public ownerTestValue;
212 
213   /** State machine
214    *
215    * - Prefunding: We have not reached the starting block yet
216    * - Funding: Active crowdsale
217    * - Success: Minimum funding goal reached
218    * - Failure: Minimum funding goal not reached before the ending block
219    * - Finalized: The finalize function has been called and succesfully executed
220    * - Refunding: Refunds are loaded on the contract to be reclaimed by investors.
221    */
222   enum State{Unknown, PreFunding, Funding, Success, Failure, Finalized, Refunding}
223 
224 
225   // A new investment was made
226   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
227 
228   // Refund was processed for a contributor
229   event Refund(address investor, uint weiAmount);
230 
231   // The rules about what kind of investments we accept were changed
232   event InvestmentPolicyChanged(bool requireCId);
233 
234   // Address early participation whitelist status changed
235   event Whitelisted(address addr, bool status);
236 
237   // Crowdsale's finalize function has been called
238   event Finalized();
239 
240 
241   function GenericCrowdsale(address team_multisig, uint start, uint end, uint min_goal) internal {
242     setMultisig(team_multisig);
243 
244     // Don't mess the dates
245     require(start != 0 && end != 0);
246     require(block.number < start && start < end);
247     startsAt = start;
248     endsAt = end;
249 
250     // Minimum funding goal can be zero
251     minimumFundingGoal = min_goal;
252   }
253 
254   /**
255    * Don't expect to just send in money and get tokens.
256    */
257   function() payable {
258     require(false);
259   }
260 
261   /**
262    * Make an investment.
263    *
264    * Crowdsale must be running for one to invest.
265    * We must have not pressed the emergency brake.
266    *
267    * @param receiver The Ethereum address who receives the tokens
268    * @param customerId (optional) UUID v4 to track the successful payments on the server side
269    *
270    */
271   function investInternal(address receiver, uint128 customerId) stopInEmergency notFinished private {
272     // Determine if it's a good time to accept investment from this participant
273     if (getState() == State.PreFunding) {
274       // Are we whitelisted for early deposit
275       require(earlyParticipantWhitelist[receiver]);
276     }
277 
278     uint weiAllowedAmount = weiAllowedToReceive(msg.value, receiver);
279     uint tokenAmount = calculatePrice(weiAllowedAmount, msg.sender);
280     
281     // Dust transaction if no tokens can be given
282     require(tokenAmount != 0);
283 
284     if (investedAmountOf[receiver] == 0) {
285       // A new investor
286       investorCount++;
287     }
288     updateInvestorFunds(tokenAmount, weiAllowedAmount, receiver, customerId);
289 
290     // Pocket the money
291     multisigWallet.transfer(weiAllowedAmount);
292 
293     // Return excess of money
294     uint weiToReturn = msg.value.sub(weiAllowedAmount);
295     if (weiToReturn > 0) {
296       msg.sender.transfer(weiToReturn);
297     }
298   }
299 
300   /** 
301    *  Calculate the size of the investment that we can accept from this address.
302    */
303   function weiAllowedToReceive(uint weiAmount, address customer) internal constant returns (uint weiAllowed);
304 
305   /** 
306    *  Calculate the amount of tokens that correspond to the received amount.
307    *  When there's an excedent due to rounding error, it should be returned to allow refunding.
308    */
309   function calculatePrice(uint weiAmount, address customer) internal constant returns (uint tokenAmount);
310 
311   /**
312    * Preallocate tokens for the early investors.
313    *
314    * Preallocated tokens have been sold before the actual crowdsale opens.
315    * This function mints the tokens and moves the crowdsale needle.
316    *
317    * No money is exchanged, as the crowdsale team already have received the payment.
318    *
319    * @param fullTokens tokens as full tokens - decimal places added internally
320    * @param weiPrice Price of a single full token in wei
321    *
322    */
323   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner notFinished {
324     require(receiver != address(0));
325     uint tokenAmount = fullTokens.mul(10**uint(token.decimals()));
326     require(tokenAmount != 0);
327     uint weiAmount = weiPrice.mul(tokenAmount); // This can also be 0, in which case we give out tokens for free
328     updateInvestorFunds(tokenAmount, weiAmount, receiver , 0);
329   }
330 
331   /**
332    * Private function to update accounting in the crowdsale.
333    */
334   function updateInvestorFunds(uint tokenAmount, uint weiAmount, address receiver, uint128 customerId) private {
335     // Update investor
336     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
337     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
338 
339     // Update totals
340     weiRaised = weiRaised.add(weiAmount);
341     tokensSold = tokensSold.add(tokenAmount);
342 
343     assignTokens(receiver, tokenAmount);
344     // Tell us that the investment was completed successfully
345     Invested(receiver, weiAmount, tokenAmount, customerId);
346   }
347 
348 
349 
350   /**
351    * Investing function that recognizes the payer.
352    * 
353    * @param customerId UUIDv4 that identifies this contributor
354    */
355   function buyWithCustomerId(uint128 customerId) public payable {
356     require(customerId != 0);  // UUIDv4 sanity check
357     investInternal(msg.sender, customerId);
358   }
359 
360   /**
361    * The basic entry point to participate in the crowdsale process.
362    *
363    * Pay for funding, get invested tokens back in the sender address.
364    */
365   function buy() public payable {
366     require(!requireCustomerId); // Crowdsale needs to track participants for thank you email
367     investInternal(msg.sender, 0);
368   }
369 
370   /**
371    * Finalize a succcesful crowdsale.
372    *
373    * The owner can trigger a call the contract that provides post-crowdsale actions, like releasing the tokens.
374    * Note that by default tokens are not in a released state.
375    */
376   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
377     if (address(finalizeAgent) != 0)
378       finalizeAgent.finalizeCrowdsale(token);
379     finalized = true;
380     Finalized();
381   }
382 
383   /**
384    * Set policy do we need to have server-side customer ids for the investments.
385    *
386    */
387   function setRequireCustomerId(bool value) public onlyOwner stopInEmergency {
388     requireCustomerId = value;
389     InvestmentPolicyChanged(requireCustomerId);
390   }
391 
392   /**
393    * Allow addresses to do early participation.
394    */
395   function setEarlyParticipantWhitelist(address addr, bool status) public onlyOwner notFinished stopInEmergency {
396     earlyParticipantWhitelist[addr] = status;
397     Whitelisted(addr, status);
398   }
399 
400   /**
401    * Allow to (re)set finalize agent.
402    */
403   function setFinalizeAgent(FinalizeAgent addr) internal {
404     // Disallow setting a bad agent
405     require(address(addr) == 0 || addr.isFinalizeAgent());
406     finalizeAgent = addr;
407     require(isFinalizerSane());
408   }
409 
410   /**
411    * Internal setter for the multisig wallet
412    */
413   function setMultisig(address addr) internal {
414     require(addr != 0);
415     multisigWallet = addr;
416   }
417 
418   /**
419    * Allow load refunds back on the contract for the refunding.
420    *
421    * The team can transfer the funds back on the smart contract in the case that the minimum goal was not reached.
422    */
423   function loadRefund() public payable inState(State.Failure) stopInEmergency {
424     require(msg.value >= weiRaised);
425     require(weiRefunded == 0);
426     uint excedent = msg.value.sub(weiRaised);
427     loadedRefund = loadedRefund.add(msg.value.sub(excedent));
428     investedAmountOf[msg.sender].add(excedent);
429   }
430 
431   /**
432    * Investors can claim refund.
433    */
434   function refund() public inState(State.Refunding) stopInEmergency {
435     uint weiValue = investedAmountOf[msg.sender];
436     require(weiValue != 0);
437     investedAmountOf[msg.sender] = 0;
438     weiRefunded = weiRefunded.add(weiValue);
439     Refund(msg.sender, weiValue);
440     msg.sender.transfer(weiValue);
441   }
442 
443   /**
444    * @return true if the crowdsale has raised enough money to be a success
445    */
446   function isMinimumGoalReached() public constant returns (bool reached) {
447     return weiRaised >= minimumFundingGoal;
448   }
449 
450   function isCrowdsaleFull() internal constant returns (bool full);
451 
452   /**
453    * Check if the contract relationship looks good.
454    */
455   function isFinalizerSane() public constant returns (bool sane) {
456     return address(finalizeAgent) == 0 || finalizeAgent.isSane(token);
457   }
458 
459   /**
460    * Crowdfund state machine management.
461    *
462    * This function has the timed transition builtin.
463    * So there is no chance of the variable being stale.
464    */
465   function getState() public constant returns (State) {
466     if (finalized) return State.Finalized;
467     else if (block.number < startsAt) return State.PreFunding;
468     else if (block.number <= endsAt && !isCrowdsaleFull()) return State.Funding;
469     else if (isMinimumGoalReached()) return State.Success;
470     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
471     else return State.Failure;
472   }
473 
474   /** This is for manual testing of multisig wallet interaction */
475   function setOwnerTestValue(uint8 val) public onlyOwner stopInEmergency {
476     ownerTestValue = val;
477   }
478 
479   /** Interface for the concrete instance to interact with the token contract in a customizable way */
480   function assignTokens(address receiver, uint tokenAmount) internal;
481 
482   /** Interface marker. */
483   function isCrowdsale() public constant returns (bool) {
484     return true;
485   }
486 
487   //
488   // Modifiers
489   //
490 
491   /** Modifier allowing execution only if the crowdsale is currently running.  */
492   modifier inState(State state) {
493     require(getState() == state);
494     _;
495   }
496 
497   modifier notFinished() {
498     State current_state = getState();
499     require(current_state == State.PreFunding || current_state == State.Funding);
500     _;
501   }
502 
503 }
504 
505 
506 contract CappedCrowdsale is GenericCrowdsale {
507 
508   // The funding cannot exceed this cap; it may be set later on during the crowdsale
509   uint public weiFundingCap = 0;
510 
511   // A new funding cap has been set
512   event FundingCapSet(uint newFundingCap);
513 
514 
515   /**
516    * Allow the owner to set a funding cap on the crowdsale.
517    * The new cap should be higher than the minimum funding goal.
518    * 
519    * @param newCap minimum target cap that may be relaxed if it was already broken.
520    */
521 
522 
523   function setFundingCap(uint newCap) internal onlyOwner notFinished {
524     weiFundingCap = newCap;
525     require(weiFundingCap >= minimumFundingGoal);
526     FundingCapSet(weiFundingCap);
527   }
528 }
529 
530 /**
531  * @title ERC20Basic
532  * @dev Simpler version of ERC20 interface
533  * @dev see https://github.com/ethereum/EIPs/issues/20
534  */
535 contract ERC20Basic {
536   uint public totalSupply;
537   function balanceOf(address who) public constant returns (uint);
538   function transfer(address to, uint value) public returns (bool ok);
539   event Transfer(address indexed from, address indexed to, uint value);
540 }
541 
542 
543 /**
544  * @title ERC20 interface
545  * @dev see https://github.com/ethereum/EIPs/issues/20
546  */
547 contract ERC20 is ERC20Basic {
548   function allowance(address owner, address spender) public constant returns (uint);
549   function transferFrom(address from, address to, uint value) public returns (bool ok);
550   function approve(address spender, uint value) public returns (bool ok);
551   event Approval(address indexed owner, address indexed spender, uint value);
552 }
553 
554 /**
555  * A token that defines fractional units as decimals.
556  */
557 contract FractionalERC20 is ERC20 {
558 
559   uint8 public decimals;
560 
561 }
562 
563 /**
564  * @title Basic token
565  * @dev Basic version of StandardToken, with no allowances. 
566  */
567 contract BasicToken is ERC20Basic {
568   using SafeMath for uint;
569 
570   mapping(address => uint) balances;
571 
572   /**
573    * Obsolete. Removed this check based on:
574    * https://blog.coinfabrik.com/smart-contract-short-address-attack-mitigation-failure/
575    * @dev Fix for the ERC20 short address attack.
576    *
577    * modifier onlyPayloadSize(uint size) {
578    *    require(msg.data.length >= size + 4);
579    *    _;
580    * }
581    */
582 
583   /**
584   * @dev transfer token for a specified address
585   * @param _to The address to transfer to.
586   * @param _value The amount to be transferred.
587   */
588   function transfer(address _to, uint _value) public returns (bool success) {
589     balances[msg.sender] = balances[msg.sender].sub(_value);
590     balances[_to] = balances[_to].add(_value);
591     Transfer(msg.sender, _to, _value);
592     return true;
593   }
594 
595   /**
596   * @dev Gets the balance of the specified address.
597   * @param _owner The address to query the the balance of. 
598   * @return An uint representing the amount owned by the passed address.
599   */
600   function balanceOf(address _owner) public constant returns (uint balance) {
601     return balances[_owner];
602   }
603   
604 }
605 
606 /**
607  * @title Standard ERC20 token
608  *
609  * @dev Implementation of the basic standard token.
610  * @dev https://github.com/ethereum/EIPs/issues/20
611  */
612 contract StandardToken is BasicToken, ERC20 {
613 
614   /* Token supply got increased and a new owner received these tokens */
615   event Minted(address receiver, uint amount);
616 
617   mapping (address => mapping (address => uint)) allowed;
618 
619   /* Interface declaration */
620   function isToken() public constant returns (bool weAre) {
621     return true;
622   }
623 
624   /**
625    * @dev Transfer tokens from one address to another
626    * @param _from address The address which you want to send tokens from
627    * @param _to address The address which you want to transfer to
628    * @param _value uint the amout of tokens to be transfered
629    */
630   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
631     uint _allowance = allowed[_from][msg.sender];
632 
633     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
634     // require(_value <= _allowance);
635     // SafeMath uses assert instead of require though, beware when using an analysis tool
636 
637     balances[_to] = balances[_to].add(_value);
638     balances[_from] = balances[_from].sub(_value);
639     allowed[_from][msg.sender] = _allowance.sub(_value);
640     Transfer(_from, _to, _value);
641     return true;
642   }
643 
644   /**
645    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
646    * @param _spender The address which will spend the funds.
647    * @param _value The amount of tokens to be spent.
648    */
649   function approve(address _spender, uint _value) public returns (bool success) {
650 
651     // To change the approve amount you first have to reduce the addresses'
652     //  allowance to zero by calling `approve(_spender, 0)` if it is not
653     //  already 0 to mitigate the race condition described here:
654     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
655     require (_value == 0 || allowed[msg.sender][_spender] == 0);
656 
657     allowed[msg.sender][_spender] = _value;
658     Approval(msg.sender, _spender, _value);
659     return true;
660   }
661 
662   /**
663    * @dev Function to check the amount of tokens than an owner allowed to a spender.
664    * @param _owner address The address which owns the funds.
665    * @param _spender address The address which will spend the funds.
666    * @return A uint specifing the amount of tokens still avaible for the spender.
667    */
668   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
669     return allowed[_owner][_spender];
670   }
671 
672   /**
673    * Atomic increment of approved spending
674    *
675    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
676    *
677    */
678   function addApproval(address _spender, uint _addedValue) public
679   returns (bool success) {
680       uint oldValue = allowed[msg.sender][_spender];
681       allowed[msg.sender][_spender] = oldValue.add(_addedValue);
682       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
683       return true;
684   }
685 
686   /**
687    * Atomic decrement of approved spending.
688    *
689    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
690    */
691   function subApproval(address _spender, uint _subtractedValue) public
692   returns (bool success) {
693 
694       uint oldVal = allowed[msg.sender][_spender];
695 
696       if (_subtractedValue > oldVal) {
697           allowed[msg.sender][_spender] = 0;
698       } else {
699           allowed[msg.sender][_spender] = oldVal.sub(_subtractedValue);
700       }
701       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
702       return true;
703   }
704   
705 }
706 
707 /**
708  * Define interface for releasing the token transfer after a successful crowdsale.
709  */
710 contract ReleasableToken is StandardToken, Ownable {
711 
712   /* The finalizer contract that allows lifting the transfer limits on this token */
713   address public releaseAgent;
714 
715   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
716   bool public released = false;
717 
718   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
719   mapping (address => bool) public transferAgents;
720 
721   /**
722    * Set the contract that can call release and make the token transferable.
723    *
724    * Since the owner of this contract is (or should be) the crowdsale,
725    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
726    */
727   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
728     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
729     releaseAgent = addr;
730   }
731 
732   /**
733    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
734    */
735   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
736     transferAgents[addr] = state;
737   }
738 
739   /**
740    * One way function to release the tokens into the wild.
741    *
742    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
743    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
744    */
745   function releaseTokenTransfer() public onlyReleaseAgent {
746     released = true;
747   }
748 
749   /**
750    * Limit token transfer until the crowdsale is over.
751    */
752   modifier canTransfer(address _sender) {
753     require(released || transferAgents[_sender]);
754     _;
755   }
756 
757   /** The function can be called only before or after the tokens have been released */
758   modifier inReleaseState(bool releaseState) {
759     require(releaseState == released);
760     _;
761   }
762 
763   /** The function can be called only by a whitelisted release agent. */
764   modifier onlyReleaseAgent() {
765     require(msg.sender == releaseAgent);
766     _;
767   }
768 
769   /** We restrict transfer by overriding it */
770   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
771     // Call StandardToken.transfer()
772    return super.transfer(_to, _value);
773   }
774 
775   /** We restrict transferFrom by overriding it */
776   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
777     // Call StandardToken.transferForm()
778     return super.transferFrom(_from, _to, _value);
779   }
780 
781 }
782 
783 /**
784  * A token that can increase its supply by another contract.
785  *
786  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
787  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
788  *
789  */
790 contract MintableToken is StandardToken, Ownable {
791 
792   using SafeMath for uint;
793 
794   bool public mintingFinished = false;
795 
796   /** List of agents that are allowed to create new tokens */
797   mapping (address => bool) public mintAgents;
798 
799   event MintingAgentChanged(address addr, bool state);
800 
801 
802   function MintableToken(uint _initialSupply, address _multisig, bool _mintable) internal {
803     require(_multisig != address(0));
804     // Cannot create a token without supply and no minting
805     require(_mintable || _initialSupply != 0);
806     // Create initially all balance on the team multisig
807     if (_initialSupply > 0)
808         mintInternal(_multisig, _initialSupply);
809     // No more new supply allowed after the token creation
810     mintingFinished = !_mintable;
811   }
812 
813   /**
814    * Create new tokens and allocate them to an address.
815    *
816    * Only callable by a crowdsale contract (mint agent).
817    */
818   function mint(address receiver, uint amount) onlyMintAgent public {
819     mintInternal(receiver, amount);
820   }
821 
822   function mintInternal(address receiver, uint amount) canMint private {
823     totalSupply = totalSupply.add(amount);
824     balances[receiver] = balances[receiver].add(amount);
825 
826     // This will make the mint transaction appear in EtherScan.io
827     // We can remove this after there is a standardized minting event
828     Transfer(0, receiver, amount);
829 
830     Minted(receiver, amount);
831   }
832 
833   /**
834    * Owner can allow a crowdsale contract to mint new tokens.
835    */
836   function setMintAgent(address addr, bool state) onlyOwner canMint public {
837     mintAgents[addr] = state;
838     MintingAgentChanged(addr, state);
839   }
840 
841   modifier onlyMintAgent() {
842     // Only mint agents are allowed to mint new tokens
843     require(mintAgents[msg.sender]);
844     _;
845   }
846 
847   /** Make sure we are not done yet. */
848   modifier canMint() {
849     require(!mintingFinished);
850     _;
851   }
852 }
853 
854 /**
855  * Upgrade agent transfers tokens to a new contract.
856  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
857  *
858  * The Upgrade agent is the interface used to implement a token
859  * migration in the case of an emergency.
860  * The function upgradeFrom has to implement the part of the creation
861  * of new tokens on behalf of the user doing the upgrade.
862  *
863  * The new token can implement this interface directly, or use.
864  */
865 contract UpgradeAgent {
866 
867   /** This value should be the same as the original token's total supply */
868   uint public originalSupply;
869 
870   /** Interface to ensure the contract is correctly configured */
871   function isUpgradeAgent() public constant returns (bool) {
872     return true;
873   }
874 
875   /**
876   Upgrade an account
877 
878   When the token contract is in the upgrade status the each user will
879   have to call `upgrade(value)` function from UpgradeableToken.
880 
881   The upgrade function adjust the balance of the user and the supply
882   of the previous token and then call `upgradeFrom(value)`.
883 
884   The UpgradeAgent is the responsible to create the tokens for the user
885   in the new contract.
886 
887   * @param _from Account to upgrade.
888   * @param _value Tokens to upgrade.
889 
890   */
891   function upgradeFrom(address _from, uint _value) public;
892 
893 }
894 
895 /**
896  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
897  *
898  */
899 contract UpgradeableToken is StandardToken {
900 
901   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
902   address public upgradeMaster;
903 
904   /** The next contract where the tokens will be migrated. */
905   UpgradeAgent public upgradeAgent;
906 
907   /** How many tokens we have upgraded by now. */
908   uint public totalUpgraded;
909 
910   /**
911    * Upgrade states.
912    *
913    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
914    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
915    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
916    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
917    *
918    */
919   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
920 
921   /**
922    * Somebody has upgraded some of his tokens.
923    */
924   event Upgrade(address indexed _from, address indexed _to, uint _value);
925 
926   /**
927    * New upgrade agent available.
928    */
929   event UpgradeAgentSet(address agent);
930 
931   /**
932    * Do not allow construction without upgrade master set.
933    */
934   function UpgradeableToken(address _upgradeMaster) {
935     setUpgradeMaster(_upgradeMaster);
936   }
937 
938   /**
939    * Allow the token holder to upgrade some of their tokens to a new contract.
940    */
941   function upgrade(uint value) public {
942     UpgradeState state = getUpgradeState();
943     // Ensure it's not called in a bad state
944     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
945 
946     // Validate input value.
947     require(value != 0);
948 
949     balances[msg.sender] = balances[msg.sender].sub(value);
950 
951     // Take tokens out from circulation
952     totalSupply = totalSupply.sub(value);
953     totalUpgraded = totalUpgraded.add(value);
954 
955     // Upgrade agent reissues the tokens
956     upgradeAgent.upgradeFrom(msg.sender, value);
957     Upgrade(msg.sender, upgradeAgent, value);
958   }
959 
960   /**
961    * Set an upgrade agent that handles the upgrade process
962    */
963   function setUpgradeAgent(address agent) external {
964     // Check whether the token is in a state that we could think of upgrading
965     require(canUpgrade());
966 
967     require(agent != 0x0);
968     // Only a master can designate the next agent
969     require(msg.sender == upgradeMaster);
970     // Upgrade has already begun for an agent
971     require(getUpgradeState() != UpgradeState.Upgrading);
972 
973     upgradeAgent = UpgradeAgent(agent);
974 
975     // Bad interface
976     require(upgradeAgent.isUpgradeAgent());
977     // Make sure that token supplies match in source and target
978     require(upgradeAgent.originalSupply() == totalSupply);
979 
980     UpgradeAgentSet(upgradeAgent);
981   }
982 
983   /**
984    * Get the state of the token upgrade.
985    */
986   function getUpgradeState() public constant returns(UpgradeState) {
987     if (!canUpgrade()) return UpgradeState.NotAllowed;
988     else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
989     else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
990     else return UpgradeState.Upgrading;
991   }
992 
993   /**
994    * Change the upgrade master.
995    *
996    * This allows us to set a new owner for the upgrade mechanism.
997    */
998   function changeUpgradeMaster(address new_master) public {
999     require(msg.sender == upgradeMaster);
1000     setUpgradeMaster(new_master);
1001   }
1002 
1003   /**
1004    * Internal upgrade master setter.
1005    */
1006   function setUpgradeMaster(address new_master) private {
1007     require(new_master != 0x0);
1008     upgradeMaster = new_master;
1009   }
1010 
1011   /**
1012    * Child contract can enable to provide the condition when the upgrade can begin.
1013    */
1014   function canUpgrade() public constant returns(bool) {
1015      return true;
1016   }
1017 
1018 }
1019 
1020 
1021 /**
1022  * A crowdsale token.
1023  *
1024  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
1025  *
1026  * - The token transfer() is disabled until the crowdsale is over
1027  * - The token contract gives an opt-in upgrade path to a new contract
1028  * - The same token can be part of several crowdsales through the approve() mechanism
1029  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
1030  *
1031  */
1032 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, FractionalERC20 {
1033 
1034   event UpdatedTokenInformation(string newName, string newSymbol);
1035 
1036   string public name;
1037 
1038   string public symbol;
1039 
1040   /**
1041    * Construct the token.
1042    *
1043    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
1044    *
1045    * @param _name Token name
1046    * @param _symbol Token symbol - typically it's all caps
1047    * @param _initialSupply How many tokens we start with
1048    * @param _decimals Number of decimal places
1049    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
1050    */
1051   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, address _multisig, bool _mintable)
1052     UpgradeableToken(_multisig) MintableToken(_initialSupply, _multisig, _mintable) {
1053     name = _name;
1054     symbol = _symbol;
1055     decimals = _decimals;
1056   }
1057 
1058   /**
1059    * When token is released to be transferable, prohibit new token creation.
1060    */
1061   function releaseTokenTransfer() public onlyReleaseAgent {
1062     mintingFinished = true;
1063     super.releaseTokenTransfer();
1064   }
1065 
1066   /**
1067    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
1068    */
1069   function canUpgrade() public constant returns(bool) {
1070     return released && super.canUpgrade();
1071   }
1072 
1073   /**
1074    * Owner can update token information here
1075    */
1076   function setTokenInformation(string _name, string _symbol) onlyOwner {
1077     name = _name;
1078     symbol = _symbol;
1079 
1080     UpdatedTokenInformation(name, symbol);
1081   }
1082 
1083 }
1084 
1085 // This contract has the sole objective of providing a sane concrete instance of the Crowdsale contract.
1086 contract Crowdsale is CappedCrowdsale {
1087   uint private constant minimum_funding = 0 * (10 ** 18); // in wei
1088 
1089   uint private constant token_initial_supply = 0;
1090   uint8 private constant token_decimals = 16;
1091   bool private constant token_mintable = true;
1092   string private constant token_name = "Ribbits";
1093   string private constant token_symbol = "RNT";
1094 
1095   uint private constant fundingCap = uint(100000000 * (10 ** 18)) / 2700;
1096 
1097 
1098   uint private constant decimalTokensPerWei2Eth = 25;
1099   uint private constant decimalTokensPerWei20Eth = 26;
1100   uint private constant decimalTokensPerWei50Eth = 27;
1101 
1102   mapping (address => bool) public discountedInvestors;
1103 
1104 
1105   function Crowdsale(address team_multisig, uint start, uint end) GenericCrowdsale(team_multisig, start, end, minimum_funding) public {
1106     // Testing values
1107     token = new CrowdsaleToken(token_name, token_symbol, token_initial_supply, token_decimals, team_multisig, token_mintable);
1108     token.setMintAgent(address(this), true);
1109     setFundingCap(fundingCap);
1110   }
1111 
1112   // We assign tokens through the minting mechanism.
1113   function assignTokens(address receiver, uint tokenAmount) internal {
1114     token.mint(receiver, tokenAmount);
1115   }
1116 
1117   // These two setters are present only to correct block numbers if they are off from their target date by more than, say, a day
1118   function setStartingBlock(uint startingBlock) public onlyOwner inState(State.PreFunding) {
1119     require(startingBlock > block.number && startingBlock < endsAt);
1120     startsAt = startingBlock;
1121   }
1122 
1123   function setEndingBlock(uint endingBlock) public onlyOwner notFinished {
1124     require(endingBlock > block.number && endingBlock > startsAt);
1125     endsAt = endingBlock;
1126   }
1127 
1128   modifier notLessThan2Eth() {
1129     require(investedAmountOf[msg.sender].add(msg.value) >= 2 * (10**18));
1130     _;
1131   }
1132 
1133   // Here we calculate the amount of tokens that corresponds to each price point.
1134   function calculatePrice(uint weiAmount, address customer) internal constant returns (uint) {
1135     uint investedAmount = investedAmountOf[customer].add(weiAmount);
1136     uint decimalTokensPerWei;
1137     if (investedAmount <= 20 * (10**18) && !discountedInvestors[customer]) {
1138       decimalTokensPerWei = decimalTokensPerWei2Eth;
1139     } else if (investedAmount <= 50 * (10**18)) {
1140       decimalTokensPerWei = decimalTokensPerWei20Eth;
1141     } else {
1142       decimalTokensPerWei = decimalTokensPerWei50Eth;
1143     }
1144     uint decimalTokens = weiAmount.mul(decimalTokensPerWei);
1145     return decimalTokens;
1146   }
1147 
1148   // We restrict investments to those with a minimum of 2 ETH
1149   function buy() public payable notLessThan2Eth {
1150     super.buy();
1151   }
1152 
1153   // Override the fallback function to allow simple transfers
1154   function() payable {
1155     buy();
1156   }
1157 
1158   // The owner is supposed to whitelist investors for the discounted price at lower price points
1159   function setDiscountedInvestor(address addr, bool status) public onlyOwner notFinished stopInEmergency {
1160     discountedInvestors[addr] = status;
1161   }
1162 
1163   // We set an upper bound for the sold tokens by limiting ether raised
1164   function weiAllowedToReceive(uint tentativeAmount, address) internal constant returns (uint) {
1165     // Then, we check the funding cap
1166     if (weiFundingCap == 0) return tentativeAmount;
1167     uint total = tentativeAmount.add(weiRaised);
1168     if (total < weiFundingCap) return tentativeAmount;
1169     else return weiFundingCap.sub(weiRaised);
1170   }
1171 
1172   function isCrowdsaleFull() internal constant returns (bool) {
1173     return weiFundingCap > 0 && weiRaised >= weiFundingCap;
1174   }
1175 }