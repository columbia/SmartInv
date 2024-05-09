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
341  * The Intelligent Shipping Chain token (ETYC - ETYCToken) has a fixed supply
342  *
343  * The owner can associate the token with a token sale contract. In that
344  * case, the token balance is moved to the token sale contract, which
345  * in turn can transfer its tokens to contributors to the sale.
346  */
347 contract ETYCToken is StandardToken, BurnableToken, Ownable {
348 
349     // Constants
350     string  public constant name = "Intelligent Shipping Chain";
351     string  public constant symbol = "ETYC";
352     uint8   public constant decimals = 18;
353     string  public constant website = "www.etyc.io"; 
354     uint256 public constant INITIAL_SUPPLY      =  1000000000 * (10 ** uint256(decimals));
355     uint256 public constant CROWDSALE_ALLOWANCE =   800000000 * (10 ** uint256(decimals));
356     uint256 public constant ADMIN_ALLOWANCE     =   200000000 * (10 ** uint256(decimals));
357 
358     // Properties
359     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
360     uint256 public adminAllowance;          // the number of tokens available for the administrator
361     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
362     address public adminAddr;               // the address of a crowdsale currently selling this token
363     //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
364     bool    public transferEnabled = true;  // Enables everyone to transfer tokens 
365 
366     // Modifiers
367 
368     /**
369      * The listed addresses are not valid recipients of tokens.
370      *
371      * 0x0           - the zero address is not valid
372      * this          - the contract itself should not receive tokens
373      * owner         - the owner has all the initial tokens, but cannot receive any back
374      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
375      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
376      */
377     modifier validDestination(address _to) {
378         require(_to != address(0x0));
379         require(_to != address(this));
380         require(_to != owner);
381         require(_to != address(adminAddr));
382         require(_to != address(crowdSaleAddr));
383         _;
384     }
385 
386     /**
387      * Constructor - instantiates token supply and allocates balanace of
388      * to the owner (msg.sender).
389      */
390     function ETYCToken(address _admin) public {
391         // the owner is a custodian of tokens that can
392         // give an allowance of tokens for crowdsales
393         // or to the admin, but cannot itself transfer
394         // tokens; hence, this requirement
395         require(msg.sender != _admin);
396 
397         totalSupply = INITIAL_SUPPLY;
398         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
399         adminAllowance = ADMIN_ALLOWANCE;
400 
401         // mint all tokens
402         balances[msg.sender] = totalSupply.sub(adminAllowance);
403         Transfer(address(0x0), msg.sender, totalSupply.sub(adminAllowance));
404 
405         balances[_admin] = adminAllowance;
406         Transfer(address(0x0), _admin, adminAllowance);
407 
408         adminAddr = _admin;
409         approve(adminAddr, adminAllowance);
410     }
411 
412     /**
413      * Associates this token with a current crowdsale, giving the crowdsale
414      * an allowance of tokens from the crowdsale supply. This gives the
415      * crowdsale the ability to call transferFrom to transfer tokens to
416      * whomever has purchased them.
417      *
418      * Note that if _amountForSale is 0, then it is assumed that the full
419      * remaining crowdsale supply is made available to the crowdsale.
420      *
421      * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
422      * @param _amountForSale The supply of tokens provided to the crowdsale
423      */
424     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
425         require(_amountForSale <= crowdSaleAllowance);
426 
427         // if 0, then full available crowdsale supply is assumed
428         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
429 
430         // Clear allowance of old, and set allowance of new
431         approve(crowdSaleAddr, 0);
432         approve(_crowdSaleAddr, amount);
433 
434         crowdSaleAddr = _crowdSaleAddr;
435     }
436 
437     /**
438      * Overrides ERC20 transfer function with modifier that prevents the
439      * ability to transfer tokens until after transfers have been enabled.
440      */
441     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
442         return super.transfer(_to, _value);
443     }
444 
445     /**
446      * Overrides ERC20 transferFrom function with modifier that prevents the
447      * ability to transfer tokens until after transfers have been enabled.
448      */
449     function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
450         bool result = super.transferFrom(_from, _to, _value);
451         if (result) {
452             if (msg.sender == crowdSaleAddr)
453                 crowdSaleAllowance = crowdSaleAllowance.sub(_value);
454             if (msg.sender == adminAddr)
455                 adminAllowance = adminAllowance.sub(_value);
456         }
457         return result;
458     }
459 
460     /**
461      * Overrides the burn function so that it cannot be called until after
462      * transfers have been enabled.
463      *
464      * @param _value    The amount of tokens to burn in wei-ETYC
465      */
466     function burn(uint256 _value) public {
467         require(transferEnabled || msg.sender == owner);
468         super.burn(_value);
469         Transfer(msg.sender, address(0x0), _value);
470     }
471 }
472 
473 
474 /**
475  * The ETYCSale smart contract is used for selling ETYC tokens (ETYC).
476  * It does so by converting ETH received into a quantity of
477  * tokens that are transferred to the contributor via the ERC20-compatible
478  * transferFrom() function.
479  */
480 contract ETYCSale is Pausable {
481 
482     using SafeMath for uint256;
483 
484     // The beneficiary is the future recipient of the funds
485     address public beneficiary;
486 
487     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
488     uint public fundingGoal;
489     uint public fundingCap;
490     uint public minContribution;
491     bool public fundingGoalReached = false;
492     bool public fundingCapReached = false;
493     bool public saleClosed = false;
494 
495     // Time period of sale (UNIX timestamps)
496     uint public startTime;
497     uint public endTime;
498 
499     // Keeps track of the amount of wei raised
500     uint public amountRaised;
501 
502     // Refund amount, should it be required
503     uint public refundAmount;
504 
505     // The ratio of ETYC to Ether
506     uint public rate = 6000;
507     uint public constant LOW_RANGE_RATE = 500;
508     uint public constant HIGH_RANGE_RATE = 20000;
509 
510     // prevent certain functions from being recursively called
511     bool private rentrancy_lock = false;
512 
513     // The token being sold
514     ETYCToken public tokenReward;
515 
516     // A map that tracks the amount of wei contributed by address
517     mapping(address => uint256) public balanceOf;
518 
519     // Events
520     event GoalReached(address _beneficiary, uint _amountRaised);
521     event CapReached(address _beneficiary, uint _amountRaised);
522     event FundTransfer(address _backer, uint _amount, bool _isContribution);
523 
524     // Modifiers
525     modifier beforeDeadline()   { require (currentTime() < endTime); _; }
526     modifier afterDeadline()    { require (currentTime() >= endTime); _; }
527     modifier afterStartTime()    { require (currentTime() >= startTime); _; }
528 
529     modifier saleNotClosed()    { require (!saleClosed); _; }
530 
531     modifier nonReentrant() {
532         require(!rentrancy_lock);
533         rentrancy_lock = true;
534         _;
535         rentrancy_lock = false;
536     }
537 
538     /**
539      * Constructor for a crowdsale of QuantstampToken tokens.
540      *
541      * @param ifSuccessfulSendTo            the beneficiary of the fund
542      * @param fundingGoalInEthers           the minimum goal to be reached
543      * @param fundingCapInEthers            the cap (maximum) size of the fund
544      * @param minimumContributionInWei      minimum contribution (in wei)
545      * @param start                         the start time (UNIX timestamp)
546      * @param end                           the end time (UNIX timestamp)
547      * @param rateEtycToEther                the conversion rate from ETYC to Ether
548      * @param addressOfTokenUsedAsReward    address of the token being sold
549      */
550     function ETYCSale(
551         address ifSuccessfulSendTo,
552         uint fundingGoalInEthers,
553         uint fundingCapInEthers,
554         uint minimumContributionInWei,
555         uint start,
556         uint end,
557         uint rateEtycToEther,
558         address addressOfTokenUsedAsReward
559     ) public {
560         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
561         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
562         require(fundingGoalInEthers <= fundingCapInEthers);
563         require(end > 0);
564         beneficiary = ifSuccessfulSendTo;
565         fundingGoal = fundingGoalInEthers * 1 ether;
566         fundingCap = fundingCapInEthers * 1 ether;
567         minContribution = minimumContributionInWei;
568         startTime = start;
569         endTime = end; // TODO double check
570         setRate(rateEtycToEther);
571         tokenReward = ETYCToken(addressOfTokenUsedAsReward);
572     }
573 
574     /**
575      * This fallback function is called whenever Ether is sent to the
576      * smart contract. It can only be executed when the crowdsale is
577      * not paused, not closed, and before the deadline has been reached.
578      *
579      * This function will update state variables for whether or not the
580      * funding goal or cap have been reached. It also ensures that the
581      * tokens are transferred to the sender, and that the correct
582      * number of tokens are sent according to the current rate.
583      */
584     function () public payable whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
585         require(msg.value >= minContribution);
586 
587         // Update the sender's balance of wei contributed and the amount raised
588         uint amount = msg.value;
589         uint currentBalance = balanceOf[msg.sender];
590         balanceOf[msg.sender] = currentBalance.add(amount);
591         amountRaised = amountRaised.add(amount);
592 
593         // Compute the number of tokens to be rewarded to the sender
594         // Note: it's important for this calculation that both wei
595         // and ETYC have the same number of decimal places (18)
596         uint numTokens = amount.mul(rate);
597 
598         // Transfer the tokens from the crowdsale supply to the sender
599         if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
600             FundTransfer(msg.sender, amount, true);
601             // Check if the funding goal or cap have been reached
602             // TODO check impact on gas cost
603             checkFundingGoal();
604             checkFundingCap();
605         }
606         else {
607             revert();
608         }
609     }
610 
611     /**
612      * The owner can terminate the crowdsale at any time.
613      */
614     function terminate() external onlyOwner {
615         saleClosed = true;
616     }
617 
618     /**
619      * The owner can update the rate (ETYC to ETH).
620      *
621      * @param _rate  the new rate for converting ETYC to ETH
622      */
623     function setRate(uint _rate) public onlyOwner {
624         require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
625         rate = _rate;
626     }
627 
628     /**
629      * The owner can allocate the specified amount of tokens from the
630      * crowdsale allowance to the recipient (_to).
631      *
632      * NOTE: be extremely careful to get the amounts correct, which
633      * are in units of wei and mini-ETYC. Every digit counts.
634      *
635      * @param _to            the recipient of the tokens
636      * @param amountWei     the amount contributed in wei
637      * @param amountMiniEtyc the amount of tokens transferred in mini-ETYC (18 decimals)
638      */
639     function ownerAllocateTokens(address _to, uint amountWei, uint amountMiniEtyc) external
640             onlyOwner nonReentrant
641     {
642         if (!tokenReward.transferFrom(tokenReward.owner(), _to, amountMiniEtyc)) {
643             revert();
644         }
645         balanceOf[_to] = balanceOf[_to].add(amountWei);
646         amountRaised = amountRaised.add(amountWei);
647         FundTransfer(_to, amountWei, true);
648         checkFundingGoal();
649         checkFundingCap();
650     }
651 
652     /**
653      * The owner can call this function to withdraw the funds that
654      * have been sent to this contract for the crowdsale subject to
655      * the funding goal having been reached. The funds will be sent
656      * to the beneficiary specified when the crowdsale was created.
657      */
658     function ownerSafeWithdrawal() external onlyOwner nonReentrant {
659         require(fundingGoalReached);
660         uint balanceToSend = this.balance;
661         beneficiary.transfer(balanceToSend);
662         FundTransfer(beneficiary, balanceToSend, false);
663     }
664 
665     /**
666      * The owner can unlock the fund with this function. The use-
667      * case for this is when the owner decides after the deadline
668      * to allow contributors to be refunded their contributions.
669      * Note that the fund would be automatically unlocked if the
670      * minimum funding goal were not reached.
671      */
672     function ownerUnlockFund() external afterDeadline onlyOwner {
673         fundingGoalReached = false;
674     }
675 
676     /**
677      * This function permits anybody to withdraw the funds they have
678      * contributed if and only if the deadline has passed and the
679      * funding goal was not reached.
680      */
681     function safeWithdrawal() external afterDeadline nonReentrant {
682         if (!fundingGoalReached) {
683             uint amount = balanceOf[msg.sender];
684             balanceOf[msg.sender] = 0;
685             if (amount > 0) {
686                 msg.sender.transfer(amount);
687                 FundTransfer(msg.sender, amount, false);
688                 refundAmount = refundAmount.add(amount);
689             }
690         }
691     }
692 
693     /**
694      * Checks if the funding goal has been reached. If it has, then
695      * the GoalReached event is triggered.
696      */
697     function checkFundingGoal() internal {
698         if (!fundingGoalReached) {
699             if (amountRaised >= fundingGoal) {
700                 fundingGoalReached = true;
701                 GoalReached(beneficiary, amountRaised);
702             }
703         }
704     }
705 
706     /**
707      * Checks if the funding cap has been reached. If it has, then
708      * the CapReached event is triggered.
709      */
710     function checkFundingCap() internal {
711         if (!fundingCapReached) {
712             if (amountRaised >= fundingCap) {
713                 fundingCapReached = true;
714                 saleClosed = true;
715                 CapReached(beneficiary, amountRaised);
716             }
717         }
718     }
719 
720     /**
721      * Returns the current time.
722      * Useful to abstract calls to "now" for tests.
723     */
724     function currentTime() public constant returns (uint _currentTime) {
725         return now;
726     }
727 
728 
729     /**
730      * Given an amount in ETYC, this method returns the equivalent amount
731      * in mini-ETYC.
732      *
733      * @param amount    an amount expressed in units of ETYC
734      */
735     function convertToMiniEtyc(uint amount) internal constant returns (uint) {
736         return amount * (10 ** uint(tokenReward.decimals()));
737     }
738 
739     /**
740      * These helper functions are exposed for changing the start and end time dynamically   
741      */
742     function changeStartTime(uint256 _startTime) external onlyOwner {startTime = _startTime;}
743     function changeEndTime(uint256 _endTime) external onlyOwner {endTime = _endTime;}
744 }