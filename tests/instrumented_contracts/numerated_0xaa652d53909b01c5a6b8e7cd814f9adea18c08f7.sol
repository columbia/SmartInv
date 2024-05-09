1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 /**
68  * @title Pausable
69  * @dev Base contract which allows children to implement an emergency stop mechanism.
70  */
71 contract Pausable is Ownable {
72   event Pause();
73   event Unpause();
74 
75   bool public paused = false;
76 
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is not paused.
80    */
81   modifier whenNotPaused() {
82     require(!paused);
83     _;
84   }
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is paused.
88    */
89   modifier whenPaused() {
90     require(paused);
91     _;
92   }
93 
94   /**
95    * @dev called by the owner to pause, triggers stopped state
96    */
97   function pause() onlyOwner whenNotPaused public {
98     paused = true;
99     Pause();
100   }
101 
102   /**
103    * @dev called by the owner to unpause, returns to normal state
104    */
105   function unpause() onlyOwner whenPaused public {
106     paused = false;
107     Unpause();
108   }
109 }
110 
111 
112 
113 
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that throw on error
117  */
118 library SafeMath {
119   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120     if (a == 0) {
121       return 0;
122     }
123     uint256 c = a * b;
124     assert(c / a == b);
125     return c;
126   }
127 
128   function div(uint256 a, uint256 b) internal pure returns (uint256) {
129     // assert(b > 0); // Solidity automatically throws when dividing by 0
130     uint256 c = a / b;
131     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132     return c;
133   }
134 
135   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   function add(uint256 a, uint256 b) internal pure returns (uint256) {
141     uint256 c = a + b;
142     assert(c >= a);
143     return c;
144   }
145 }
146 
147 
148 
149 
150 
151 
152 
153 
154 
155 
156 
157 
158 
159 /**
160  * @title Basic token
161  * @dev Basic version of StandardToken, with no allowances.
162  */
163 contract BasicToken is ERC20Basic {
164   using SafeMath for uint256;
165 
166   mapping(address => uint256) balances;
167 
168   /**
169   * @dev transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[msg.sender]);
176 
177     // SafeMath.sub will throw if there is not enough balance.
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256 balance) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 
196 
197 
198 
199 
200 
201 /**
202  * @title ERC20 interface
203  * @dev see https://github.com/ethereum/EIPs/issues/20
204  */
205 contract ERC20 is ERC20Basic {
206   function allowance(address owner, address spender) public view returns (uint256);
207   function transferFrom(address from, address to, uint256 value) public returns (bool);
208   function approve(address spender, uint256 value) public returns (bool);
209   event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * @dev https://github.com/ethereum/EIPs/issues/20
219  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
233     require(_to != address(0));
234     require(_value <= balances[_from]);
235     require(_value <= allowed[_from][msg.sender]);
236 
237     balances[_from] = balances[_from].sub(_value);
238     balances[_to] = balances[_to].add(_value);
239     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240     Transfer(_from, _to, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    *
247    * Beware that changing an allowance with this method brings the risk that someone may use both the old
248    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
249    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
250    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint256 _value) public returns (bool) {
255     allowed[msg.sender][_spender] = _value;
256     Approval(msg.sender, _spender, _value);
257     return true;
258   }
259 
260   /**
261    * @dev Function to check the amount of tokens that an owner allowed to a spender.
262    * @param _owner address The address which owns the funds.
263    * @param _spender address The address which will spend the funds.
264    * @return A uint256 specifying the amount of tokens still available for the spender.
265    */
266   function allowance(address _owner, address _spender) public view returns (uint256) {
267     return allowed[_owner][_spender];
268   }
269 
270   /**
271    * @dev Increase the amount of tokens that an owner allowed to a spender.
272    *
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
281     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   /**
287    * @dev Decrease the amount of tokens that an owner allowed to a spender.
288    *
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 
310 
311 
312 
313 /**
314  * @title Burnable Token
315  * @dev Token that can be irreversibly burned (destroyed).
316  */
317 contract BurnableToken is BasicToken {
318 
319     event Burn(address indexed burner, uint256 value);
320 
321     /**
322      * @dev Burns a specific amount of tokens.
323      * @param _value The amount of token to be burned.
324      */
325     function burn(uint256 _value) public {
326         require(_value <= balances[msg.sender]);
327         // no need to require value <= totalSupply, since that would imply the
328         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
329 
330         address burner = msg.sender;
331         balances[burner] = balances[burner].sub(_value);
332         totalSupply = totalSupply.sub(_value);
333         Burn(burner, _value);
334     }
335 }
336 
337 
338 
339 
340 /**
341  * The Transboundary Credit Rating token (TCR - TCRToken) has a fixed supply and restricts the ability
342  * to transfer tokens until the owner has called the enableTransfer()
343  * function.
344  *
345  * The owner can associate the token with a token sale contract. In that
346  * case, the token balance is moved to the token sale contract, which
347  * in turn can transfer its tokens to contributors to the sale.
348  */
349 contract TCRToken is StandardToken, BurnableToken, Ownable {
350 
351     // Constants
352     string  public constant name = "Transboundary Credit Rating";
353     string  public constant symbol = "TCR";
354     uint8   public constant decimals = 18;
355     string  public constant website = "www.tcr.legal"; 
356     uint256 public constant INITIAL_SUPPLY      =  280000000 * (10 ** uint256(decimals));
357     uint256 public constant CROWDSALE_ALLOWANCE =  218400000 * (10 ** uint256(decimals));
358     uint256 public constant ADMIN_ALLOWANCE     =   61600000 * (10 ** uint256(decimals));
359 
360     // Properties
361     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
362     uint256 public adminAllowance;          // the number of tokens available for the administrator
363     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
364     address public adminAddr;               // the address of a crowdsale currently selling this token
365     //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
366     bool    public transferEnabled = true;  // Enables everyone to transfer tokens 
367 
368     // Modifiers
369     modifier onlyWhenTransferEnabled() {
370         if (!transferEnabled) {
371             require(msg.sender == adminAddr || msg.sender == crowdSaleAddr);
372         }
373         _;
374     }
375 
376     /**
377      * The listed addresses are not valid recipients of tokens.
378      *
379      * 0x0           - the zero address is not valid
380      * this          - the contract itself should not receive tokens
381      * owner         - the owner has all the initial tokens, but cannot receive any back
382      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
383      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
384      */
385     modifier validDestination(address _to) {
386         require(_to != address(0x0));
387         require(_to != address(this));
388         require(_to != owner);
389         require(_to != address(adminAddr));
390         require(_to != address(crowdSaleAddr));
391         _;
392     }
393 
394     /**
395      * Constructor - instantiates token supply and allocates balanace of
396      * to the owner (msg.sender).
397      */
398     function TCRToken(address _admin) public {
399         // the owner is a custodian of tokens that can
400         // give an allowance of tokens for crowdsales
401         // or to the admin, but cannot itself transfer
402         // tokens; hence, this requirement
403         require(msg.sender != _admin);
404 
405         totalSupply = INITIAL_SUPPLY;
406         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
407         adminAllowance = ADMIN_ALLOWANCE;
408 
409         // mint all tokens
410         balances[msg.sender] = totalSupply.sub(adminAllowance);
411         Transfer(address(0x0), msg.sender, totalSupply.sub(adminAllowance));
412 
413         balances[_admin] = adminAllowance;
414         Transfer(address(0x0), _admin, adminAllowance);
415 
416         adminAddr = _admin;
417         approve(adminAddr, adminAllowance);
418     }
419 
420     /**
421      * Associates this token with a current crowdsale, giving the crowdsale
422      * an allowance of tokens from the crowdsale supply. This gives the
423      * crowdsale the ability to call transferFrom to transfer tokens to
424      * whomever has purchased them.
425      *
426      * Note that if _amountForSale is 0, then it is assumed that the full
427      * remaining crowdsale supply is made available to the crowdsale.
428      *
429      * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
430      * @param _amountForSale The supply of tokens provided to the crowdsale
431      */
432     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
433         //require(!transferEnabled);
434         require(_amountForSale <= crowdSaleAllowance);
435 
436         // if 0, then full available crowdsale supply is assumed
437         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
438 
439         // Clear allowance of old, and set allowance of new
440         approve(crowdSaleAddr, 0);
441         approve(_crowdSaleAddr, amount);
442 
443         crowdSaleAddr = _crowdSaleAddr;
444     }
445 
446     /**
447      * Enables the ability of anyone to transfer their tokens. This can
448      * only be called by the token owner. Once enabled, it is not
449      * possible to disable transfers.
450      */
451     /*function enableTransfer() external onlyOwner {
452         transferEnabled = true;
453         approve(crowdSaleAddr, 0);
454         approve(adminAddr, 0);
455         crowdSaleAllowance = 0;
456         adminAllowance = 0;
457     }*/
458 
459     /**
460      * Overrides ERC20 transfer function with modifier that prevents the
461      * ability to transfer tokens until after transfers have been enabled.
462      */
463     function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
464         return super.transfer(_to, _value);
465     }
466 
467     /**
468      * Overrides ERC20 transferFrom function with modifier that prevents the
469      * ability to transfer tokens until after transfers have been enabled.
470      */
471     function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
472         bool result = super.transferFrom(_from, _to, _value);
473         if (result) {
474             if (msg.sender == crowdSaleAddr)
475                 crowdSaleAllowance = crowdSaleAllowance.sub(_value);
476             if (msg.sender == adminAddr)
477                 adminAllowance = adminAllowance.sub(_value);
478         }
479         return result;
480     }
481 
482     /**
483      * Overrides the burn function so that it cannot be called until after
484      * transfers have been enabled.
485      *
486      * @param _value    The amount of tokens to burn in wei-TCR
487      */
488     function burn(uint256 _value) public {
489         require(transferEnabled || msg.sender == owner);
490         super.burn(_value);
491         Transfer(msg.sender, address(0x0), _value);
492     }
493 }
494 
495 
496 /**
497  * The TCRSale smart contract is used for selling TCR tokens (TCR).
498  * It does so by converting ETH received into a quantity of
499  * tokens that are transferred to the contributor via the ERC20-compatible
500  * transferFrom() function.
501  */
502 contract TCRSale is Pausable {
503 
504     using SafeMath for uint256;
505 
506     // The beneficiary is the future recipient of the funds
507     address public beneficiary;
508 
509     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
510     uint public fundingGoal;
511     uint public fundingCap;
512     uint public minContribution;
513     bool public fundingGoalReached = false;
514     bool public fundingCapReached = false;
515     bool public saleClosed = false;
516 
517     // Time period of sale (UNIX timestamps)
518     uint public startTime;
519     uint public endTime;
520 
521     // Keeps track of the amount of wei raised
522     uint public amountRaised;
523 
524     // Refund amount, should it be required
525     uint public refundAmount;
526 
527     // The ratio of TCR to Ether
528     uint public rate = 10000;
529     uint public constant LOW_RANGE_RATE = 500;
530     uint public constant HIGH_RANGE_RATE = 20000;
531 
532     // prevent certain functions from being recursively called
533     bool private rentrancy_lock = false;
534 
535     // The token being sold
536     TCRToken public tokenReward;
537 
538     // A map that tracks the amount of wei contributed by address
539     mapping(address => uint256) public balanceOf;
540 
541     // Events
542     event GoalReached(address _beneficiary, uint _amountRaised);
543     event CapReached(address _beneficiary, uint _amountRaised);
544     event FundTransfer(address _backer, uint _amount, bool _isContribution);
545 
546     // Modifiers
547     modifier beforeDeadline()   { require (currentTime() < endTime); _; }
548     modifier afterDeadline()    { require (currentTime() >= endTime); _; }
549     modifier afterStartTime()    { require (currentTime() >= startTime); _; }
550 
551     modifier saleNotClosed()    { require (!saleClosed); _; }
552 
553     modifier nonReentrant() {
554         require(!rentrancy_lock);
555         rentrancy_lock = true;
556         _;
557         rentrancy_lock = false;
558     }
559 
560     /**
561      * Constructor for a crowdsale of QuantstampToken tokens.
562      *
563      * @param ifSuccessfulSendTo            the beneficiary of the fund
564      * @param fundingGoalInEthers           the minimum goal to be reached
565      * @param fundingCapInEthers            the cap (maximum) size of the fund
566      * @param minimumContributionInWei      minimum contribution (in wei)
567      * @param start                         the start time (UNIX timestamp)
568      * @param end                           the end time (UNIX timestamp)
569      * @param rateTcrToEther                the conversion rate from TCR to Ether
570      * @param addressOfTokenUsedAsReward    address of the token being sold
571      */
572     function TCRSale(
573         address ifSuccessfulSendTo,
574         uint fundingGoalInEthers,
575         uint fundingCapInEthers,
576         uint minimumContributionInWei,
577         uint start,
578         uint end,
579         uint rateTcrToEther,
580         address addressOfTokenUsedAsReward
581     ) public {
582         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
583         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
584         require(fundingGoalInEthers <= fundingCapInEthers);
585         require(end > 0);
586         beneficiary = ifSuccessfulSendTo;
587         fundingGoal = fundingGoalInEthers * 1 ether;
588         fundingCap = fundingCapInEthers * 1 ether;
589         minContribution = minimumContributionInWei;
590         startTime = start;
591         endTime = end; // TODO double check
592         setRate(rateTcrToEther);
593         tokenReward = TCRToken(addressOfTokenUsedAsReward);
594     }
595 
596     /**
597      * This fallback function is called whenever Ether is sent to the
598      * smart contract. It can only be executed when the crowdsale is
599      * not paused, not closed, and before the deadline has been reached.
600      *
601      * This function will update state variables for whether or not the
602      * funding goal or cap have been reached. It also ensures that the
603      * tokens are transferred to the sender, and that the correct
604      * number of tokens are sent according to the current rate.
605      */
606     function () public payable whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
607         require(msg.value >= minContribution);
608 
609         // Update the sender's balance of wei contributed and the amount raised
610         uint amount = msg.value;
611         uint currentBalance = balanceOf[msg.sender];
612         balanceOf[msg.sender] = currentBalance.add(amount);
613         amountRaised = amountRaised.add(amount);
614 
615         // Compute the number of tokens to be rewarded to the sender
616         // Note: it's important for this calculation that both wei
617         // and TCR have the same number of decimal places (18)
618         uint numTokens = amount.mul(rate);
619 
620         // Transfer the tokens from the crowdsale supply to the sender
621         if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
622             FundTransfer(msg.sender, amount, true);
623             // Check if the funding goal or cap have been reached
624             // TODO check impact on gas cost
625             checkFundingGoal();
626             checkFundingCap();
627         }
628         else {
629             revert();
630         }
631     }
632 
633     /**
634      * The owner can terminate the crowdsale at any time.
635      */
636     function terminate() external onlyOwner {
637         saleClosed = true;
638     }
639 
640     /**
641      * The owner can update the rate (TCR to ETH).
642      *
643      * @param _rate  the new rate for converting TCR to ETH
644      */
645     function setRate(uint _rate) public onlyOwner {
646         require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
647         rate = _rate;
648     }
649 
650     /**
651      * The owner can allocate the specified amount of tokens from the
652      * crowdsale allowance to the recipient (_to).
653      *
654      * NOTE: be extremely careful to get the amounts correct, which
655      * are in units of wei and mini-TCR. Every digit counts.
656      *
657      * @param _to            the recipient of the tokens
658      * @param amountWei     the amount contributed in wei
659      * @param amountMiniTcr the amount of tokens transferred in mini-TCR (18 decimals)
660      */
661     function ownerAllocateTokens(address _to, uint amountWei, uint amountMiniTcr) external
662             onlyOwner nonReentrant
663     {
664         if (!tokenReward.transferFrom(tokenReward.owner(), _to, amountMiniTcr)) {
665             revert();
666         }
667         balanceOf[_to] = balanceOf[_to].add(amountWei);
668         amountRaised = amountRaised.add(amountWei);
669         FundTransfer(_to, amountWei, true);
670         checkFundingGoal();
671         checkFundingCap();
672     }
673 
674     /**
675      * The owner can call this function to withdraw the funds that
676      * have been sent to this contract for the crowdsale subject to
677      * the funding goal having been reached. The funds will be sent
678      * to the beneficiary specified when the crowdsale was created.
679      */
680     function ownerSafeWithdrawal() external onlyOwner nonReentrant {
681         require(fundingGoalReached);
682         uint balanceToSend = this.balance;
683         beneficiary.transfer(balanceToSend);
684         FundTransfer(beneficiary, balanceToSend, false);
685     }
686 
687     /**
688      * The owner can unlock the fund with this function. The use-
689      * case for this is when the owner decides after the deadline
690      * to allow contributors to be refunded their contributions.
691      * Note that the fund would be automatically unlocked if the
692      * minimum funding goal were not reached.
693      */
694     function ownerUnlockFund() external afterDeadline onlyOwner {
695         fundingGoalReached = false;
696     }
697 
698     /**
699      * This function permits anybody to withdraw the funds they have
700      * contributed if and only if the deadline has passed and the
701      * funding goal was not reached.
702      */
703     function safeWithdrawal() external afterDeadline nonReentrant {
704         if (!fundingGoalReached) {
705             uint amount = balanceOf[msg.sender];
706             balanceOf[msg.sender] = 0;
707             if (amount > 0) {
708                 msg.sender.transfer(amount);
709                 FundTransfer(msg.sender, amount, false);
710                 refundAmount = refundAmount.add(amount);
711             }
712         }
713     }
714 
715     /**
716      * Checks if the funding goal has been reached. If it has, then
717      * the GoalReached event is triggered.
718      */
719     function checkFundingGoal() internal {
720         if (!fundingGoalReached) {
721             if (amountRaised >= fundingGoal) {
722                 fundingGoalReached = true;
723                 GoalReached(beneficiary, amountRaised);
724             }
725         }
726     }
727 
728     /**
729      * Checks if the funding cap has been reached. If it has, then
730      * the CapReached event is triggered.
731      */
732     function checkFundingCap() internal {
733         if (!fundingCapReached) {
734             if (amountRaised >= fundingCap) {
735                 fundingCapReached = true;
736                 saleClosed = true;
737                 CapReached(beneficiary, amountRaised);
738             }
739         }
740     }
741 
742     /**
743      * Returns the current time.
744      * Useful to abstract calls to "now" for tests.
745     */
746     function currentTime() public constant returns (uint _currentTime) {
747         return now;
748     }
749 
750 
751     /**
752      * Given an amount in TCR, this method returns the equivalent amount
753      * in mini-TCR.
754      *
755      * @param amount    an amount expressed in units of TCR
756      */
757     function convertToMiniTcr(uint amount) internal constant returns (uint) {
758         return amount * (10 ** uint(tokenReward.decimals()));
759     }
760 
761     /**
762      * These helper functions are exposed for changing the start and end time dynamically   
763      */
764     function changeStartTime(uint256 _startTime) external onlyOwner {startTime = _startTime;}
765     function changeEndTime(uint256 _endTime) external onlyOwner {endTime = _endTime;}
766 }