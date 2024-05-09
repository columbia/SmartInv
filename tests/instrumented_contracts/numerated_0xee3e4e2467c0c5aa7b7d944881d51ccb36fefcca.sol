1 pragma solidity ^0.4.15;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  * Based on OpenZeppelin
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 // File: contracts/token/ERC20Basic.sol
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  *
43  * Based on OpenZeppelin
44  */
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) public constant returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: contracts/token/ERC20.sol
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  *
58  * Based on OpenZeppelin
59  */
60 
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public constant returns (uint256);
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64     function approve(address spender, uint256 value) public returns (bool);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 // File: contracts/token/StandardToken.sol
69 
70 /**
71  * @title Standard ERC20 token
72  *
73  * @dev Implementation of the basic standard token.
74  * @dev https://github.com/ethereum/EIPs/issues/20
75  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
76  *
77  * Based on OpenZeppelin
78  */
79 contract StandardToken is ERC20 {
80 
81     using SafeMath for uint256;
82 
83     mapping(address => uint256) balances;
84 
85     mapping (address => mapping (address => uint256)) internal allowed;
86 
87     /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92     function transfer(address _to, uint256 _value) public returns (bool) {
93         require(_to != address(0));
94         require(_value <= balances[msg.sender]);
95 
96         // SafeMath.sub will throw if there is not enough balance.
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         Transfer(msg.sender, _to, _value);
100         return true;
101     }
102 
103     /**
104     * @dev Gets the balance of the specified address.
105     * @param _owner The address to query the the balance of.
106     * @return An uint256 representing the amount owned by the passed address.
107     */
108     function balanceOf(address _owner) public constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     /**
113      * @dev Transfer tokens from one address to another
114      * @param _from address The address which you want to send tokens from
115      * @param _to address The address which you want to transfer to
116      * @param _value uint256 the amount of tokens to be transferred
117      */
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119         require(_to != address(0));
120         require(_value <= balances[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      *
133      * Beware that changing an allowance with this method brings the risk that someone may use both the old
134      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      * @param _spender The address which will spend the funds.
138      * @param _value The amount of tokens to be spent.
139      */
140     function approve(address _spender, uint256 _value) public returns (bool) {
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Function to check the amount of tokens that an owner allowed to a spender.
148      * @param _owner address The address which owns the funds.
149      * @param _spender address The address which will spend the funds.
150      * @return A uint256 specifying the amount of tokens still available for the spender.
151      */
152     function allowance(address _owner, address _spender) public constant returns (uint256) {
153         return allowed[_owner][_spender];
154     }
155 
156     /**
157      * approve should be called when allowed[_spender] == 0. To increment
158      * allowed value is better to use this function to avoid 2 calls (and wait until
159      * the first transaction is mined)
160      * From MonolithDAO Token.sol
161      */
162     function increaseApproval (address _spender, uint _addedValue) public returns (bool) {
163         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool) {
169         uint oldValue = allowed[msg.sender][_spender];
170         if (_subtractedValue > oldValue) {
171             allowed[msg.sender][_spender] = 0;
172         } else {
173             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174         }
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179 }
180 
181 // File: contracts/token/BurnableToken.sol
182 
183 /**
184  * @title Burnable Token
185  *
186  * @dev based on OpenZeppelin
187  */
188 contract BurnableToken is StandardToken {
189 
190     event Burn(address indexed burner, uint256 value);
191 
192     /**
193      * @dev Burns a specific amount of tokens.
194      * @param _value The amount of token to be burned.
195      */
196     function burn(uint256 _value) public {
197         require(_value > 0);
198         require(_value <= balances[msg.sender]);
199 
200         address burner = msg.sender;
201         balances[burner] = balances[burner].sub(_value);
202         totalSupply = totalSupply.sub(_value);
203         Burn(burner, _value);
204     }
205 }
206 
207 // File: contracts/ownership/Ownable.sol
208 
209 /**
210  * @title Ownable
211  * @dev The Ownable contract has an owner address, and provides basic authorization control
212  * functions, this simplifies the implementation of "user permissions".
213  * Based on OpenZeppelin
214  */
215 contract Ownable {
216   address public owner;
217 
218 
219   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
220 
221 
222   /**
223    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
224    * account.
225    */
226   function Ownable() {
227     owner = msg.sender;
228   }
229 
230 
231   /**
232    * @dev Throws if called by any account other than the owner.
233    */
234   modifier onlyOwner() {
235     require(msg.sender == owner);
236     _;
237   }
238 
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) onlyOwner public {
245     require(newOwner != address(0));
246     OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250 }
251 
252 // File: contracts/ownership/Claimable.sol
253 
254 /**
255  * @title Claimable
256  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
257  * This allows the new owner to accept the transfer.
258  * Based on OpenZeppelin
259  */
260 contract Claimable is Ownable {
261     address public pendingOwner;
262 
263     /**
264      * @dev Modifier throws if called by any account other than the pendingOwner.
265      */
266     modifier onlyPendingOwner() {
267         require(msg.sender == pendingOwner);
268         _;
269     }
270 
271     /**
272      * @dev Allows the current owner to set the pendingOwner address.
273      * @param newOwner The address to transfer ownership to.
274      */
275     function transferOwnership(address newOwner) onlyOwner public {
276         pendingOwner = newOwner;
277     }
278 
279     /**
280      * @dev Allows the pendingOwner address to finalize the transfer.
281      */
282     function claimOwnership() onlyPendingOwner public {
283         OwnershipTransferred(owner, pendingOwner);
284         owner = pendingOwner;
285         pendingOwner = address(0);
286     }
287 }
288 
289 // File: contracts/token/ReleasableToken.sol
290 
291 /**
292  * Define interface for releasing the token transfer after a successful crowdsale.
293  *
294  */
295 contract ReleasableToken is ERC20, Claimable {
296 
297     /* The finalizer contract that allows unlift the transfer limits on this token */
298     address public releaseAgent;
299 
300     /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
301     bool public released = false;
302 
303     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
304     mapping (address => bool) public transferAgents;
305 
306     /**
307      * Limit token transfer until the crowdsale is over.
308      *
309      */
310     modifier canTransfer(address _sender) {
311         if(!released) {
312             assert(transferAgents[_sender]);
313         }
314         _;
315     }
316 
317     /**
318      * Set the contract that can call release and make the token transferable.
319      *
320      * Design choice. Allow reset the release agent to fix fat finger mistakes.
321      */
322     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
323         require(addr != 0x0);
324         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
325         releaseAgent = addr;
326     }
327 
328     /**
329      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
330      */
331     function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
332         require(addr != 0x0);
333         transferAgents[addr] = state;
334     }
335 
336     /**
337      * One way function to release the tokens to the wild.
338      *
339      * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
340      */
341     function releaseTokenTransfer() public onlyReleaseAgent {
342         released = true;
343     }
344 
345     /** The function can be called only before or after the tokens have been releasesd */
346     modifier inReleaseState(bool releaseState) {
347         require(releaseState == released);
348         _;
349     }
350 
351     /** The function can be called only by a whitelisted release agent. */
352     modifier onlyReleaseAgent() {
353         require(msg.sender == releaseAgent);
354         _;
355     }
356 
357     function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
358         // Call StandardToken.transfer()
359         return super.transfer(_to, _value);
360     }
361 
362     function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
363         // Call StandardToken.transferForm()
364         return super.transferFrom(_from, _to, _value);
365     }
366 
367 }
368 
369 // File: contracts/token/CrowdsaleToken.sol
370 
371 /**
372  * @title Base crowdsale token interface
373  */
374 contract CrowdsaleToken is BurnableToken, ReleasableToken {
375     uint public decimals;
376 }
377 
378 // File: contracts/crowdsale/FinalizeAgent.sol
379 
380 /**
381  * @title Finalize Agent Abstract Contract
382  * Finalize agent defines what happens at the end of successful crowdsale.
383  */
384 contract FinalizeAgent {
385 
386   function isFinalizeAgent() public constant returns(bool) {
387     return true;
388   }
389 
390   function isSane() public constant returns (bool);
391 
392   function finalizeCrowdsale();
393 
394 }
395 
396 // File: contracts/lifecycle/Pausable.sol
397 
398 /**
399  * @title Pausable
400  * @dev Base contract which allows children to implement an emergency stop mechanism.
401  *
402  */
403 contract Pausable is Ownable {
404     event Pause();
405     event Unpause();
406 
407     bool public paused = false;
408 
409 
410     /**
411      * @dev Modifier to make a function callable only when the contract is not paused.
412      */
413     modifier whenNotPaused() {
414         require(!paused);
415         _;
416     }
417 
418     /**
419      * @dev Modifier to make a function callable only when the contract is paused.
420      */
421     modifier whenPaused() {
422         require(paused);
423         _;
424     }
425 
426     /**
427      * @dev called by the owner to pause, triggers stopped state
428      */
429     function pause() onlyOwner whenNotPaused public {
430         paused = true;
431         Pause();
432     }
433 
434     /**
435      * @dev called by the owner to unpause, returns to normal state
436      */
437     function unpause() onlyOwner whenPaused public {
438         paused = false;
439         Unpause();
440     }
441 }
442 
443 // File: contracts/crowdsale/InvestmentPolicyCrowdsale.sol
444 
445 /**
446  * @title Investment Policy Abstract Contract
447  *
448  * @dev based on TokenMarketNet
449  *
450  * Apache License, version 2.0 https://github.com/AlgoryProject/algory-ico/blob/master/LICENSE
451  */
452 contract InvestmentPolicyCrowdsale is Pausable {
453 
454     /* Do we need to have unique contributor id for each customer */
455     bool public requireCustomerId = false;
456 
457     /**
458       * Do we verify that contributor has been cleared on the server side (accredited investors only).
459       * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
460       */
461     bool public requiredSignedAddress = false;
462 
463     /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
464     address public signerAddress;
465 
466     event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
467 
468     /**
469      * Set policy do we need to have server-side customer ids for the investments.
470      *
471      */
472     function setRequireCustomerId(bool value) onlyOwner external{
473         requireCustomerId = value;
474         InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
475     }
476 
477     /**
478      * Set policy if all investors must be cleared on the server side first.
479      *
480      * This is e.g. for the accredited investor clearing.
481      *
482      */
483     function setRequireSignedAddress(bool value, address _signerAddress) external onlyOwner {
484         requiredSignedAddress = value;
485         signerAddress = _signerAddress;
486         InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
487     }
488 
489     /**
490      * Invest to tokens, recognize the payer and clear his address.
491      */
492     function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) external payable {
493         require(requiredSignedAddress);
494         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
495         bytes32 hash = sha3(prefix, sha3(msg.sender));
496         assert(ecrecover(hash, v, r, s) == signerAddress);
497         require(customerId != 0);  // UUIDv4 sanity check
498         investInternal(msg.sender, customerId);
499     }
500 
501     /**
502      * Invest to tokens, recognize the payer.
503      *
504      */
505     function buyWithCustomerId(uint128 customerId) external payable {
506         require(requireCustomerId);
507         require(customerId != 0);
508         investInternal(msg.sender, customerId);
509     }
510 
511 
512     function investInternal(address receiver, uint128 customerId) whenNotPaused internal;
513 }
514 
515 // File: contracts/crowdsale/PricingStrategy.sol
516 
517 /**
518  * Pricing Strategy - Abstract contract for defining crowdsale pricing.
519  */
520 contract PricingStrategy {
521 
522   // How many tokens per one investor is allowed in presale
523   uint public presaleMaxValue = 0;
524 
525   function isPricingStrategy() external constant returns (bool) {
526       return true;
527   }
528 
529   function getPresaleMaxValue() public constant returns (uint) {
530       return presaleMaxValue;
531   }
532 
533   function isPresaleFull(uint weiRaised) public constant returns (bool);
534 
535   function getAmountOfTokens(uint value, uint weiRaised) public constant returns (uint tokensAmount);
536 }
537 
538 // File: contracts/crowdsale/AlgoryCrowdsale.sol
539 
540 /**
541  * @title Algory Crowdsale
542  *
543  * @dev based on TokenMarketNet
544  *
545  * Apache License, version 2.0 https://github.com/AlgoryProject/algory-ico/blob/master/LICENSE
546  */
547 
548 contract AlgoryCrowdsale is InvestmentPolicyCrowdsale {
549 
550     /* Max investment count when we are still allowed to change the multisig address */
551     uint constant public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
552 
553     using SafeMath for uint;
554 
555     /* The token we are selling */
556     CrowdsaleToken public token;
557 
558     /* How we are going to price our offering */
559     PricingStrategy public pricingStrategy;
560 
561     /* Post-success callback */
562     FinalizeAgent public finalizeAgent;
563 
564     /* tokens will be transfered from this address */
565     address public multisigWallet;
566 
567     /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
568     address public beneficiary;
569 
570     /* the UNIX timestamp start date of the presale */
571     uint public presaleStartsAt;
572 
573     /* the UNIX timestamp start date of the crowdsale */
574     uint public startsAt;
575 
576     /* the UNIX timestamp end date of the crowdsale */
577     uint public endsAt;
578 
579     /* the number of tokens already sold through this contract*/
580     uint public tokensSold = 0;
581 
582     /* How many wei of funding we have raised */
583     uint public weiRaised = 0;
584 
585     /** How many wei we have in whitelist declarations*/
586     uint public whitelistWeiRaised = 0;
587 
588     /* Calculate incoming funds from presale contracts and addresses */
589     uint public presaleWeiRaised = 0;
590 
591     /* How many distinct addresses have invested */
592     uint public investorCount = 0;
593 
594     /* How much wei we have returned back to the contract after a failed crowdfund. */
595     uint public loadedRefund = 0;
596 
597     /* How much wei we have given back to investors.*/
598     uint public weiRefunded = 0;
599 
600     /* Has this crowdsale been finalized */
601     bool public finalized = false;
602 
603     /* Allow investors refund theirs money */
604     bool public allowRefund = false;
605 
606     // Has tokens preallocated */
607     bool private isPreallocated = false;
608 
609     /** How much ETH each address has invested to this crowdsale */
610     mapping (address => uint256) public investedAmountOf;
611 
612     /** How much tokens this crowdsale has credited for each investor address */
613     mapping (address => uint256) public tokenAmountOf;
614 
615     /** Addresses and amount in weis that are allowed to invest even before ICO official opens. */
616     mapping (address => uint) public earlyParticipantWhitelist;
617 
618     /** State machine
619      *
620      * - Preparing: All contract initialization calls and variables have not been set yet
621      * - PreFunding: We have not passed start time yet, allow buy for whitelisted participants
622      * - Funding: Active crowdsale
623      * - Success: Passed end time or crowdsale is full (all tokens sold)
624      * - Finalized: The finalized has been called and successfully executed
625      * - Refunding: Refunds are loaded on the contract for reclaim.
626      */
627     enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
628 
629     // A new investment was made
630     event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
631 
632     // Refund was processed for a contributor
633     event Refund(address investor, uint weiAmount);
634 
635     // Address early participation whitelist status changed
636     event Whitelisted(address addr, uint value);
637 
638     // Crowdsale time boundary has changed
639     event TimeBoundaryChanged(string timeBoundary, uint timestamp);
640 
641     /** Modified allowing execution only if the crowdsale is currently running.  */
642     modifier inState(State state) {
643         require(getState() == state);
644         _;
645     }
646 
647     function AlgoryCrowdsale(address _token, address _beneficiary, PricingStrategy _pricingStrategy, address _multisigWallet, uint _presaleStart, uint _start, uint _end) public {
648         owner = msg.sender;
649         token = CrowdsaleToken(_token);
650         beneficiary = _beneficiary;
651 
652         presaleStartsAt = _presaleStart;
653         startsAt = _start;
654         endsAt = _end;
655 
656         require(now < presaleStartsAt && presaleStartsAt <= startsAt && startsAt < endsAt);
657 
658         setPricingStrategy(_pricingStrategy);
659         setMultisigWallet(_multisigWallet);
660 
661         require(beneficiary != 0x0 && address(token) != 0x0);
662         assert(token.balanceOf(beneficiary) == token.totalSupply());
663 
664     }
665 
666     function prepareCrowdsale() onlyOwner external {
667         require(!isPreallocated);
668         require(isAllTokensApproved());
669         preallocateTokens();
670         isPreallocated = true;
671     }
672 
673     /**
674      * Allow to send money and get tokens.
675      */
676     function() payable {
677         require(!requireCustomerId); // Crowdsale needs to track participants for thank you email
678         require(!requiredSignedAddress); // Crowdsale allows only server-side signed participants
679         investInternal(msg.sender, 0);
680     }
681 
682     function setFinalizeAgent(FinalizeAgent agent) onlyOwner external{
683         finalizeAgent = agent;
684         require(finalizeAgent.isFinalizeAgent());
685         require(finalizeAgent.isSane());
686     }
687 
688     function setPresaleStartsAt(uint presaleStart) inState(State.Preparing) onlyOwner external {
689         require(presaleStart <= startsAt && presaleStart < endsAt);
690         presaleStartsAt = presaleStart;
691         TimeBoundaryChanged('presaleStartsAt', presaleStartsAt);
692     }
693 
694     function setStartsAt(uint start) onlyOwner external {
695         require(presaleStartsAt < start && start < endsAt);
696         State state = getState();
697         assert(state == State.Preparing || state == State.PreFunding);
698         startsAt = start;
699         TimeBoundaryChanged('startsAt', startsAt);
700     }
701 
702     function setEndsAt(uint end) onlyOwner external {
703         require(end > startsAt && end > presaleStartsAt);
704         endsAt = end;
705         TimeBoundaryChanged('endsAt', endsAt);
706     }
707 
708     function loadEarlyParticipantsWhitelist(address[] participantsArray, uint[] valuesArray) onlyOwner external {
709         address participant = 0x0;
710         uint value = 0;
711         for (uint i = 0; i < participantsArray.length; i++) {
712             participant = participantsArray[i];
713             value = valuesArray[i];
714             setEarlyParticipantWhitelist(participant, value);
715         }
716     }
717 
718     /**
719      * Finalize a successful crowdsale.
720      */
721     function finalize() inState(State.Success) onlyOwner whenNotPaused external {
722         require(!finalized);
723         finalizeAgent.finalizeCrowdsale();
724         finalized = true;
725     }
726 
727     function allowRefunding(bool val) onlyOwner external {
728         State state = getState();
729         require(paused || state == State.Success || state == State.Failure || state == State.Refunding);
730         allowRefund = val;
731     }
732 
733     function loadRefund() inState(State.Failure) external payable {
734         require(msg.value != 0);
735         loadedRefund = loadedRefund.add(msg.value);
736     }
737 
738     function refund() inState(State.Refunding) external {
739         require(allowRefund);
740         uint256 weiValue = investedAmountOf[msg.sender];
741         require(weiValue != 0);
742         investedAmountOf[msg.sender] = 0;
743         weiRefunded = weiRefunded.add(weiValue);
744         Refund(msg.sender, weiValue);
745         msg.sender.transfer(weiValue);
746     }
747 
748     function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner public {
749         State state = getState();
750         if (state == State.PreFunding || state == State.Funding) {
751             require(paused);
752         }
753         pricingStrategy = _pricingStrategy;
754         require(pricingStrategy.isPricingStrategy());
755     }
756 
757     function setMultisigWallet(address wallet) onlyOwner public {
758         require(wallet != 0x0);
759         require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
760         multisigWallet = wallet;
761     }
762 
763     function setEarlyParticipantWhitelist(address participant, uint value) onlyOwner public {
764         require(value != 0 && participant != 0x0);
765         require(value <= pricingStrategy.getPresaleMaxValue());
766         assert(!pricingStrategy.isPresaleFull(whitelistWeiRaised));
767         if(earlyParticipantWhitelist[participant] > 0) {
768             whitelistWeiRaised = whitelistWeiRaised.sub(earlyParticipantWhitelist[participant]);
769         }
770         earlyParticipantWhitelist[participant] = value;
771         whitelistWeiRaised = whitelistWeiRaised.add(value);
772         Whitelisted(participant, value);
773     }
774 
775     function getTokensLeft() public constant returns (uint) {
776         return token.allowance(beneficiary, this);
777     }
778 
779     function isCrowdsaleFull() public constant returns (bool) {
780         return getTokensLeft() == 0;
781     }
782 
783     function getState() public constant returns (State) {
784         if(finalized) return State.Finalized;
785         else if (!isPreallocated) return State.Preparing;
786         else if (address(finalizeAgent) == 0) return State.Preparing;
787         else if (block.timestamp < presaleStartsAt) return State.Preparing;
788         else if (block.timestamp >= presaleStartsAt && block.timestamp < startsAt) return State.PreFunding;
789         else if (block.timestamp <= endsAt && block.timestamp >= startsAt && !isCrowdsaleFull()) return State.Funding;
790         else if (!allowRefund && isCrowdsaleFull()) return State.Success;
791         else if (!allowRefund && block.timestamp > endsAt) return State.Success;
792         else if (allowRefund && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
793         else return State.Failure;
794     }
795 
796     /**
797      * Check is crowdsale can be able to transfer all tokens from beneficiary
798      */
799     function isAllTokensApproved() private constant returns (bool) {
800         return getTokensLeft() == token.totalSupply() - tokensSold
801                 && token.transferAgents(beneficiary);
802     }
803 
804     function isBreakingCap(uint tokenAmount) private constant returns (bool limitBroken) {
805         return tokenAmount > getTokensLeft();
806     }
807 
808     function investInternal(address receiver, uint128 customerId) whenNotPaused internal{
809         State state = getState();
810         require(state == State.PreFunding || state == State.Funding);
811         uint weiAmount = msg.value;
812         uint tokenAmount = 0;
813 
814 
815         if (state == State.PreFunding) {
816             require(earlyParticipantWhitelist[receiver] > 0);
817             require(weiAmount <= earlyParticipantWhitelist[receiver]);
818             assert(!pricingStrategy.isPresaleFull(presaleWeiRaised));
819         }
820 
821         tokenAmount = pricingStrategy.getAmountOfTokens(weiAmount, weiRaised);
822         require(tokenAmount > 0);
823         if (investedAmountOf[receiver] == 0) {
824             investorCount++;
825         }
826 
827         investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
828         tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
829         weiRaised = weiRaised.add(weiAmount);
830         tokensSold = tokensSold.add(tokenAmount);
831 
832         if (state == State.PreFunding) {
833             presaleWeiRaised = presaleWeiRaised.add(weiAmount);
834             earlyParticipantWhitelist[receiver] = earlyParticipantWhitelist[receiver].sub(weiAmount);
835         }
836 
837         require(!isBreakingCap(tokenAmount));
838 
839         assignTokens(receiver, tokenAmount);
840 
841         require(multisigWallet.send(weiAmount));
842 
843         Invested(receiver, weiAmount, tokenAmount, customerId);
844     }
845 
846     function assignTokens(address receiver, uint tokenAmount) private {
847         require(token.transferFrom(beneficiary, receiver, tokenAmount));
848     }
849 
850     /**
851      * Preallocate tokens for developers, company and bounty
852      */
853     function preallocateTokens() private {
854         uint multiplier = 10 ** 18;
855         assignTokens(0xc8337b3e03f5946854e6C5d2F5f3Ad0511Bb2599, 4300000 * multiplier); // developers
856         assignTokens(0x354d755460A677B60A2B5e025A3b7397856b518E, 4100000 * multiplier); // company
857         assignTokens(0x6AC724A02A4f47179A89d4A7532ED7030F55fD34, 2400000 * multiplier); // bounty
858     }
859 
860 }