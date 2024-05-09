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
341  * The Tabs Tracking Chain token (TTC - TTCToken) has a fixed supply
342  *
343  * The owner can associate the token with a token sale contract. In that
344  * case, the token balance is moved to the token sale contract, which
345  * in turn can transfer its tokens to contributors to the sale.
346  */
347 contract TTCToken is StandardToken, BurnableToken, Ownable {
348 
349     // Constants
350     string  public constant name = "Tabs Tracking Chain";
351     string  public constant symbol = "TTC";
352     uint8   public constant decimals = 18;
353     uint256 public constant INITIAL_SUPPLY      =  600000000 * (10 ** uint256(decimals));
354     uint256 public constant CROWDSALE_ALLOWANCE =  480000000 * (10 ** uint256(decimals));
355     uint256 public constant ADMIN_ALLOWANCE     =  120000000 * (10 ** uint256(decimals));
356 
357     // Properties
358     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
359     uint256 public adminAllowance;          // the number of tokens available for the administrator
360     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
361     address public adminAddr;               // the address of a crowdsale currently selling this token
362     //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
363     bool    public transferEnabled = true;  // Enables everyone to transfer tokens 
364 
365     // Modifiers
366 
367     /**
368      * The listed addresses are not valid recipients of tokens.
369      *
370      * 0x0           - the zero address is not valid
371      * this          - the contract itself should not receive tokens
372      * owner         - the owner has all the initial tokens, but cannot receive any back
373      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
374      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
375      */
376     modifier validDestination(address _to) {
377         require(_to != address(0x0));
378         require(_to != address(this));
379         require(_to != owner);
380         require(_to != address(adminAddr));
381         require(_to != address(crowdSaleAddr));
382         _;
383     }
384 
385     /**
386      * Constructor - instantiates token supply and allocates balanace of
387      * to the owner (msg.sender).
388      */
389     function TTCToken(address _admin) public {
390         // the owner is a custodian of tokens that can
391         // give an allowance of tokens for crowdsales
392         // or to the admin, but cannot itself transfer
393         // tokens; hence, this requirement
394         require(msg.sender != _admin);
395 
396         totalSupply = INITIAL_SUPPLY;
397         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
398         adminAllowance = ADMIN_ALLOWANCE;
399 
400         // mint all tokens
401         balances[msg.sender] = totalSupply.sub(adminAllowance);
402         Transfer(address(0x0), msg.sender, totalSupply.sub(adminAllowance));
403 
404         balances[_admin] = adminAllowance;
405         Transfer(address(0x0), _admin, adminAllowance);
406 
407         adminAddr = _admin;
408         approve(adminAddr, adminAllowance);
409     }
410 
411     /**
412      * Associates this token with a current crowdsale, giving the crowdsale
413      * an allowance of tokens from the crowdsale supply. This gives the
414      * crowdsale the ability to call transferFrom to transfer tokens to
415      * whomever has purchased them.
416      *
417      * Note that if _amountForSale is 0, then it is assumed that the full
418      * remaining crowdsale supply is made available to the crowdsale.
419      *
420      * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
421      * @param _amountForSale The supply of tokens provided to the crowdsale
422      */
423     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
424         require(_amountForSale <= crowdSaleAllowance);
425 
426         // if 0, then full available crowdsale supply is assumed
427         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
428 
429         // Clear allowance of old, and set allowance of new
430         approve(crowdSaleAddr, 0);
431         approve(_crowdSaleAddr, amount);
432 
433         crowdSaleAddr = _crowdSaleAddr;
434     }
435 
436     /**
437      * Overrides ERC20 transfer function with modifier that prevents the
438      * ability to transfer tokens until after transfers have been enabled.
439      */
440     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
441         return super.transfer(_to, _value);
442     }
443 
444     /**
445      * Overrides ERC20 transferFrom function with modifier that prevents the
446      * ability to transfer tokens until after transfers have been enabled.
447      */
448     function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
449         bool result = super.transferFrom(_from, _to, _value);
450         if (result) {
451             if (msg.sender == crowdSaleAddr)
452                 crowdSaleAllowance = crowdSaleAllowance.sub(_value);
453             if (msg.sender == adminAddr)
454                 adminAllowance = adminAllowance.sub(_value);
455         }
456         return result;
457     }
458 
459     /**
460      * Overrides the burn function so that it cannot be called until after
461      * transfers have been enabled.
462      *
463      * @param _value    The amount of tokens to burn in wei-TTC
464      */
465     function burn(uint256 _value) public {
466         require(transferEnabled || msg.sender == owner);
467         super.burn(_value);
468         Transfer(msg.sender, address(0x0), _value);
469     }
470 }
471 
472 
473 /**
474  * The TTCSale smart contract is used for selling TTC tokens (TTC).
475  * It does so by converting ETH received into a quantity of
476  * tokens that are transferred to the contributor via the ERC20-compatible
477  * transferFrom() function.
478  */
479 contract TTCSale is Pausable {
480 
481     using SafeMath for uint256;
482 
483     // The beneficiary is the future recipient of the funds
484     address public beneficiary;
485 
486     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
487     uint public fundingGoal;
488     uint public fundingCap;
489     uint public minContribution;
490     bool public fundingGoalReached = false;
491     bool public fundingCapReached = false;
492     bool public saleClosed = false;
493 
494     // Time period of sale (UNIX timestamps)
495     uint public startTime;
496     uint public endTime;
497 
498     // Keeps track of the amount of wei raised
499     uint public amountRaised;
500 
501     // Refund amount, should it be required
502     uint public refundAmount;
503 
504     // The ratio of TTC to Ether
505     uint public rate = 10000;
506     uint public constant LOW_RANGE_RATE = 500;
507     uint public constant HIGH_RANGE_RATE = 30000;
508 
509     // prevent certain functions from being recursively called
510     bool private rentrancy_lock = false;
511 
512     // The token being sold
513     TTCToken public tokenReward;
514 
515     // A map that tracks the amount of wei contributed by address
516     mapping(address => uint256) public balanceOf;
517 
518     // Events
519     event GoalReached(address _beneficiary, uint _amountRaised);
520     event CapReached(address _beneficiary, uint _amountRaised);
521     event FundTransfer(address _backer, uint _amount, bool _isContribution);
522 
523     // Modifiers
524     modifier beforeDeadline()   { require (currentTime() < endTime); _; }
525     modifier afterDeadline()    { require (currentTime() >= endTime); _; }
526     modifier afterStartTime()    { require (currentTime() >= startTime); _; }
527 
528     modifier saleNotClosed()    { require (!saleClosed); _; }
529 
530     modifier nonReentrant() {
531         require(!rentrancy_lock);
532         rentrancy_lock = true;
533         _;
534         rentrancy_lock = false;
535     }
536 
537     /**
538      * Constructor for a crowdsale of QuantstampToken tokens.
539      *
540      * @param ifSuccessfulSendTo            the beneficiary of the fund
541      * @param fundingGoalInEthers           the minimum goal to be reached
542      * @param fundingCapInEthers            the cap (maximum) size of the fund
543      * @param minimumContributionInWei      minimum contribution (in wei)
544      * @param start                         the start time (UNIX timestamp)
545      * @param end                           the end time (UNIX timestamp)
546      * @param rateTtcToEther                the conversion rate from TTC to Ether
547      * @param addressOfTokenUsedAsReward    address of the token being sold
548      */
549     function TTCSale(
550         address ifSuccessfulSendTo,
551         uint fundingGoalInEthers,
552         uint fundingCapInEthers,
553         uint minimumContributionInWei,
554         uint start,
555         uint end,
556         uint rateTtcToEther,
557         address addressOfTokenUsedAsReward
558     ) public {
559         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
560         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
561         require(fundingGoalInEthers <= fundingCapInEthers);
562         require(end > 0);
563         beneficiary = ifSuccessfulSendTo;
564         fundingGoal = fundingGoalInEthers * 1 ether;
565         fundingCap = fundingCapInEthers * 1 ether;
566         minContribution = minimumContributionInWei;
567         startTime = start;
568         endTime = end; // TODO double check
569         setRate(rateTtcToEther);
570         tokenReward = TTCToken(addressOfTokenUsedAsReward);
571     }
572 
573     /**
574      * This fallback function is called whenever Ether is sent to the
575      * smart contract. It can only be executed when the crowdsale is
576      * not paused, not closed, and before the deadline has been reached.
577      *
578      * This function will update state variables for whether or not the
579      * funding goal or cap have been reached. It also ensures that the
580      * tokens are transferred to the sender, and that the correct
581      * number of tokens are sent according to the current rate.
582      */
583     function () public payable whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
584         require(msg.value >= minContribution);
585 
586         // Update the sender's balance of wei contributed and the amount raised
587         uint amount = msg.value;
588         uint currentBalance = balanceOf[msg.sender];
589         balanceOf[msg.sender] = currentBalance.add(amount);
590         amountRaised = amountRaised.add(amount);
591 
592         // Compute the number of tokens to be rewarded to the sender
593         // Note: it's important for this calculation that both wei
594         // and TTC have the same number of decimal places (18)
595         uint numTokens = amount.mul(rate);
596 
597         // Transfer the tokens from the crowdsale supply to the sender
598         if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
599             FundTransfer(msg.sender, amount, true);
600             uint balanceToSend = this.balance;
601             beneficiary.transfer(balanceToSend);
602             FundTransfer(beneficiary, balanceToSend, false);
603             // Check if the funding goal or cap have been reached
604             // TODO check impact on gas cost
605             checkFundingGoal();
606             checkFundingCap();
607         }
608         else {
609             revert();
610         }
611     }
612 
613     /**
614      * The owner can terminate the crowdsale at any time.
615      */
616     function terminate() external onlyOwner {
617         saleClosed = true;
618     }
619 
620     /**
621      * The owner can update the rate (TTC to ETH).
622      *
623      * @param _rate  the new rate for converting TTC to ETH
624      */
625     function setRate(uint _rate) public onlyOwner {
626         require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
627         rate = _rate;
628     }
629 
630     /**
631      * The owner can allocate the specified amount of tokens from the
632      * crowdsale allowance to the recipient (_to).
633      *
634      * NOTE: be extremely careful to get the amounts correct, which
635      * are in units of wei and mini-TTC. Every digit counts.
636      *
637      * @param _to            the recipient of the tokens
638      * @param amountWei     the amount contributed in wei
639      * @param amountMiniTtc the amount of tokens transferred in mini-TTC (18 decimals)
640      */
641     function ownerAllocateTokens(address _to, uint amountWei, uint amountMiniTtc) external
642             onlyOwner nonReentrant
643     {
644         if (!tokenReward.transferFrom(tokenReward.owner(), _to, amountMiniTtc)) {
645             revert();
646         }
647         balanceOf[_to] = balanceOf[_to].add(amountWei);
648         amountRaised = amountRaised.add(amountWei);
649         FundTransfer(_to, amountWei, true);
650         checkFundingGoal();
651         checkFundingCap();
652     }
653 
654     /**
655      * The owner can call this function to withdraw the funds that
656      * have been sent to this contract for the crowdsale subject to
657      * the funding goal having been reached. The funds will be sent
658      * to the beneficiary specified when the crowdsale was created.
659      */
660     function ownerSafeWithdrawal() external onlyOwner nonReentrant {
661         require(fundingGoalReached);
662         uint balanceToSend = this.balance;
663         beneficiary.transfer(balanceToSend);
664         FundTransfer(beneficiary, balanceToSend, false);
665     }
666 
667     /**
668      * The owner can unlock the fund with this function. The use-
669      * case for this is when the owner decides after the deadline
670      * to allow contributors to be refunded their contributions.
671      * Note that the fund would be automatically unlocked if the
672      * minimum funding goal were not reached.
673      */
674     function ownerUnlockFund() external afterDeadline onlyOwner {
675         fundingGoalReached = false;
676     }
677 
678     /**
679      * This function permits anybody to withdraw the funds they have
680      * contributed if and only if the deadline has passed and the
681      * funding goal was not reached.
682      */
683     function safeWithdrawal() external afterDeadline nonReentrant {
684         if (!fundingGoalReached) {
685             uint amount = balanceOf[msg.sender];
686             balanceOf[msg.sender] = 0;
687             if (amount > 0) {
688                 msg.sender.transfer(amount);
689                 FundTransfer(msg.sender, amount, false);
690                 refundAmount = refundAmount.add(amount);
691             }
692         }
693     }
694 
695     /**
696      * Checks if the funding goal has been reached. If it has, then
697      * the GoalReached event is triggered.
698      */
699     function checkFundingGoal() internal {
700         if (!fundingGoalReached) {
701             if (amountRaised >= fundingGoal) {
702                 fundingGoalReached = true;
703                 GoalReached(beneficiary, amountRaised);
704             }
705         }
706     }
707 
708     /**
709      * Checks if the funding cap has been reached. If it has, then
710      * the CapReached event is triggered.
711      */
712     function checkFundingCap() internal {
713         if (!fundingCapReached) {
714             if (amountRaised >= fundingCap) {
715                 fundingCapReached = true;
716                 saleClosed = true;
717                 CapReached(beneficiary, amountRaised);
718             }
719         }
720     }
721 
722     /**
723      * Returns the current time.
724      * Useful to abstract calls to "now" for tests.
725     */
726     function currentTime() public constant returns (uint _currentTime) {
727         return now;
728     }
729 
730 
731     /**
732      * Given an amount in TTC, this method returns the equivalent amount
733      * in mini-TTC.
734      *
735      * @param amount    an amount expressed in units of TTC
736      */
737     function convertToMiniTtc(uint amount) internal constant returns (uint) {
738         return amount * (10 ** uint(tokenReward.decimals()));
739     }
740 
741     /**
742      * These helper functions are exposed for changing the start and end time dynamically   
743      */
744     function changeStartTime(uint256 _startTime) external onlyOwner {startTime = _startTime;}
745     function changeEndTime(uint256 _endTime) external onlyOwner {endTime = _endTime;}
746 }