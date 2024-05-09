1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 //import "../node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol";
18 
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     if (a == 0) {
32       return 0;
33     }
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 
125 
126 /**
127  * @title Burnable Token
128  * @dev Token that can be irreversibly burned (destroyed).
129  */
130 contract BurnableToken is BasicToken {
131 
132   event Burn(address indexed burner, uint256 value);
133 
134   /**
135    * @dev Burns a specific amount of tokens.
136    * @param _value The amount of token to be burned.
137    */
138   function burn(uint256 _value) public {
139     _burn(msg.sender, _value);
140   }
141 
142   function _burn(address _who, uint256 _value) internal {
143     require(_value <= balances[_who]);
144     // no need to require value <= totalSupply, since that would imply the
145     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
146 
147     balances[_who] = balances[_who].sub(_value);
148     totalSupply_ = totalSupply_.sub(_value);
149     emit Burn(_who, _value);
150     emit Transfer(_who, address(0), _value);
151   }
152 }
153 
154 
155 
156 
157 
158 
159 
160 
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167   function allowance(address owner, address spender) public view returns (uint256);
168   function transferFrom(address from, address to, uint256 value) public returns (bool);
169   function approve(address spender, uint256 value) public returns (bool);
170   event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 
174 
175 /**
176  * @title Standard ERC20 token
177  *
178  * @dev Implementation of the basic standard token.
179  * @dev https://github.com/ethereum/EIPs/issues/20
180  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
181  */
182 contract StandardToken is ERC20, BasicToken {
183 
184   mapping (address => mapping (address => uint256)) internal allowed;
185 
186 
187   /**
188    * @dev Transfer tokens from one address to another
189    * @param _from address The address which you want to send tokens from
190    * @param _to address The address which you want to transfer to
191    * @param _value uint256 the amount of tokens to be transferred
192    */
193   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
194     require(_to != address(0));
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    *
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217     emit Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Function to check the amount of tokens that an owner allowed to a spender.
223    * @param _owner address The address which owns the funds.
224    * @param _spender address The address which will spend the funds.
225    * @return A uint256 specifying the amount of tokens still available for the spender.
226    */
227   function allowance(address _owner, address _spender) public view returns (uint256) {
228     return allowed[_owner][_spender];
229   }
230 
231   /**
232    * @dev Increase the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To increment
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _addedValue The amount of tokens to increase the allowance by.
240    */
241   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
242     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To decrement
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _subtractedValue The amount of tokens to decrease the allowance by.
256    */
257   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
258     uint oldValue = allowed[msg.sender][_spender];
259     if (_subtractedValue > oldValue) {
260       allowed[msg.sender][_spender] = 0;
261     } else {
262       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263     }
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268 }
269 
270 
271 /**
272  * @title Standard Burnable Token
273  * @dev Adds burnFrom method to ERC20 implementations
274  */
275 contract StandardBurnableToken is BurnableToken, StandardToken {
276 
277   /**
278    * @dev Burns a specific amount of tokens from the target address and decrements allowance
279    * @param _from address The address which you want to send tokens from
280    * @param _value uint256 The amount of token to be burned
281    */
282   function burnFrom(address _from, uint256 _value) public {
283     require(_value <= allowed[_from][msg.sender]);
284     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
285     // this function needs to emit an event with the updated approval.
286     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
287     _burn(_from, _value);
288   }
289 }
290 
291 
292 
293 contract CFTToken is StandardBurnableToken {
294     // Constants
295     string  public constant name = "Crypto Financial Token";
296     string  public constant symbol = "CFT";
297     uint8   public constant decimals = 18;
298     string  public website = "www.cftoken.io"; 
299     uint256 public constant INITIAL_SUPPLY      =  9000000000 * (10 ** uint256(decimals));
300     uint256 public constant CROWDSALE_ALLOWANCE =  6000000000 * (10 ** uint256(decimals));
301     uint256 public constant ADMIN_ALLOWANCE     =  3000000000 * (10 ** uint256(decimals));
302 
303     address public owner;
304 
305     // Properties
306     //uint256 public totalSupply;
307     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
308     uint256 public adminAllowance;          // the number of tokens available for the administrator
309     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
310     address public adminAddr;               // the address of a crowdsale currently selling this token
311     bool public icoStart = false;
312     mapping(address => uint256) public tokensTransferred;
313 
314     // Events
315     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
316 
317     // Modifiers
318     modifier validDestination(address _to) {
319         require(_to != address(0x0));
320         require(_to != address(this));
321         require(_to != owner);
322         //require(_to != address(adminAddr));
323         //require(_to != address(crowdSaleAddr));
324         _;
325     }
326 
327     modifier onlyOwner() {
328         require(msg.sender == owner);
329         _;
330     }
331 
332     constructor(address _admin) public {
333         // the owner is a custodian of tokens that can
334         // give an allowance of tokens for crowdsales
335         // or to the admin, but cannot itself transfer
336         // tokens; hence, this requirement
337         require(msg.sender != _admin);
338 
339         owner = msg.sender;
340 
341         //totalSupply = INITIAL_SUPPLY;
342         totalSupply_ = INITIAL_SUPPLY;
343         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
344         adminAllowance = ADMIN_ALLOWANCE;
345 
346         // mint all tokens
347         balances[msg.sender] = totalSupply_.sub(adminAllowance);
348         emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));
349 
350         balances[_admin] = adminAllowance;
351         emit Transfer(address(0x0), _admin, adminAllowance);
352 
353         adminAddr = _admin;
354         approve(adminAddr, adminAllowance);
355     }
356 
357     /**
358     * @dev called by the owner to start the ICO
359     */
360     function startICO() external onlyOwner {
361         icoStart = true;
362     }
363 
364     /**
365     * @dev called by the owner to stop the ICO
366     */
367     function stopICO() external onlyOwner {
368         icoStart = false;
369     }
370 
371 
372     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
373         require(_amountForSale <= crowdSaleAllowance);
374 
375         // if 0, then full available crowdsale supply is assumed
376         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
377 
378         // Clear allowance of old, and set allowance of new
379         approve(crowdSaleAddr, 0);
380         approve(_crowdSaleAddr, amount);
381 
382         crowdSaleAddr = _crowdSaleAddr;
383         //icoStart = true;
384     }
385 
386 
387     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
388         if(icoStart && (msg.sender != owner || msg.sender != adminAddr)){
389             require((tokensTransferred[msg.sender].add(_value)).mul(2)<=balances[msg.sender].add(tokensTransferred[msg.sender]));
390             tokensTransferred[msg.sender] = tokensTransferred[msg.sender].add(_value);
391             return super.transfer(_to, _value);
392         }else
393             return super.transfer(_to, _value);
394     }
395 
396     function transferOwnership(address newOwner) public onlyOwner {
397         require(newOwner != address(0));
398         emit OwnershipTransferred(owner, newOwner);
399         owner = newOwner;
400     }
401 
402 
403     function burn(uint256 _value) public {
404         require(msg.sender==owner || msg.sender==adminAddr);
405         _burn(msg.sender, _value);
406     }
407 
408 
409     function burnFromAdmin(uint256 _value) external onlyOwner {
410         _burn(adminAddr, _value);
411     }
412 
413     function changeWebsite(string _website) external onlyOwner {website = _website;}
414 
415 
416 }
417 
418 contract CFTSale {
419 
420     using SafeMath for uint256;
421 
422     // The beneficiary is the future recipient of the funds
423     address public beneficiary;
424 
425     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
426     uint public fundingGoal;
427     uint public fundingCap;
428     uint public minContribution;
429     bool public fundingGoalReached = false;
430     bool public fundingCapReached = false;
431     bool public saleClosed = false;
432 
433     // Time period of sale (UNIX timestamps)
434     uint public startTime;
435     uint public endTime;
436     address public owner;
437 
438     // Keeps track of the amount of wei raised
439     uint public amountRaised;
440 
441     // Refund amount, should it be required
442     uint public refundAmount;
443 
444     // The ratio of CFT to Ether
445     uint public rate = 3000;
446     uint public constant LOW_RANGE_RATE = 1;
447     uint public constant HIGH_RANGE_RATE = 500000;
448 
449     // prevent certain functions from being recursively called
450     bool private rentrancy_lock = false;
451     bool public paused = false;
452 
453     // The token being sold
454     CFTToken public tokenReward;
455 
456     // A map that tracks the amount of wei contributed by address
457     mapping(address => uint256) public balanceOf;
458 
459     mapping(address => uint256) public contributions;
460     //uint public maxUserContribution = 20 * 1 ether;
461     //mapping(address => uint256) public caps;
462 
463     // Events
464     event GoalReached(address _beneficiary, uint _amountRaised);
465     event CapReached(address _beneficiary, uint _amountRaised);
466     event FundTransfer(address _backer, uint _amount, bool _isContribution);
467     event Pause();
468     event Unpause();
469 
470     // Modifiers
471     modifier beforeDeadline()   {require (currentTime() < endTime); _;}
472     modifier afterDeadline()    {require (currentTime() >= endTime); _;}
473     modifier afterStartTime()    {require (currentTime() >= startTime); _;}
474 
475     modifier saleNotClosed()    {require (!saleClosed); _;}
476 
477     modifier nonReentrant() {
478         require(!rentrancy_lock);
479         rentrancy_lock = true;
480         _;
481         rentrancy_lock = false;
482     }
483 
484     modifier onlyOwner() {
485         require(msg.sender == owner);
486         _;
487     }
488 
489     
490     /**
491     * @dev Modifier to make a function callable only when the contract is not paused.
492     */
493     modifier whenNotPaused() {
494         require(!paused);
495         _;
496     }
497 
498     /**
499     * @dev Modifier to make a function callable only when the contract is paused.
500     */
501     modifier whenPaused() {
502         require(paused);
503         _;
504     }
505 
506     /**
507     * @dev called by the owner to pause, triggers stopped state
508     */
509     function pause() onlyOwner whenNotPaused public {
510         paused = true;
511         tokenReward.stopICO();
512         emit Pause();
513     }
514 
515     /**
516     * @dev called by the owner to unpause, returns to normal state
517     */
518     function unpause() onlyOwner whenPaused public {
519         paused = false;
520         tokenReward.startICO();
521         emit Unpause();
522     }
523 
524 
525     constructor(
526         address ifSuccessfulSendTo,
527         uint fundingGoalInEthers,
528         uint fundingCapInEthers,
529         uint minimumContributionInWei,
530         uint start,
531         uint end,
532         uint rateCFTToEther,
533         address addressOfTokenUsedAsReward
534     ) public {
535         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
536         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
537         require(fundingGoalInEthers <= fundingCapInEthers);
538         require(end > 0);
539         beneficiary = ifSuccessfulSendTo;
540         fundingGoal = fundingGoalInEthers * 1 ether;
541         fundingCap = fundingCapInEthers * 1 ether;
542         minContribution = minimumContributionInWei;
543         startTime = start;
544         endTime = end; // TODO double check
545         rate = rateCFTToEther;
546         tokenReward = CFTToken(addressOfTokenUsedAsReward);
547         owner = msg.sender;
548     }
549 
550 
551     function () external payable whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
552         require(msg.value >= minContribution);
553         //require(contributions[msg.sender].add(msg.value) <= maxUserContribution);
554 
555         // Update the sender's balance of wei contributed and the amount raised
556         uint amount = msg.value;
557         uint currentBalance = balanceOf[msg.sender];
558         balanceOf[msg.sender] = currentBalance.add(amount);
559         amountRaised = amountRaised.add(amount);
560 
561         // Compute the number of tokens to be rewarded to the sender
562         // Note: it's important for this calculation that both wei
563         // and CFT have the same number of decimal places (18)
564         uint numTokens = amount.mul(rate);
565 
566         // Transfer the tokens from the crowdsale supply to the sender
567         if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
568             emit FundTransfer(msg.sender, amount, true);
569             contributions[msg.sender] = contributions[msg.sender].add(amount);
570             // Following code is to automatically transfer ETH to beneficiary
571             //uint balanceToSend = this.balance;
572             //beneficiary.transfer(balanceToSend);
573             //FundTransfer(beneficiary, balanceToSend, false);
574             checkFundingGoal();
575             checkFundingCap();
576         }
577         else {
578             revert();
579         }
580     }
581 
582     function terminate() external onlyOwner {
583         saleClosed = true;
584         tokenReward.stopICO();
585     }
586 
587     function setRate(uint _rate) external onlyOwner {
588         require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
589         rate = _rate;
590     }
591 
592     function ownerAllocateTokens(address _to, uint amountWei, uint amountMiniCFT) external
593             onlyOwner nonReentrant
594     {
595         if (!tokenReward.transferFrom(tokenReward.owner(), _to, amountMiniCFT)) {
596             revert();
597         }
598         balanceOf[_to] = balanceOf[_to].add(amountWei);
599         amountRaised = amountRaised.add(amountWei);
600         emit FundTransfer(_to, amountWei, true);
601         checkFundingGoal();
602         checkFundingCap();
603     }
604 
605     function ownerSafeWithdrawal() external onlyOwner nonReentrant {
606         require(fundingGoalReached);
607         uint balanceToSend = address(this).balance;
608         beneficiary.transfer(balanceToSend);
609         emit FundTransfer(beneficiary, balanceToSend, false);
610     }
611 
612     function ownerUnlockFund() external afterDeadline onlyOwner {
613         fundingGoalReached = false;
614     }
615 
616     function safeWithdrawal() external afterDeadline nonReentrant {
617         if (!fundingGoalReached) {
618             uint amount = balanceOf[msg.sender];
619             balanceOf[msg.sender] = 0;
620             if (amount > 0) {
621                 msg.sender.transfer(amount);
622                 emit FundTransfer(msg.sender, amount, false);
623                 refundAmount = refundAmount.add(amount);
624             }
625         }
626     }
627 
628     function checkFundingGoal() internal {
629         if (!fundingGoalReached) {
630             if (amountRaised >= fundingGoal) {
631                 fundingGoalReached = true;
632                 emit GoalReached(beneficiary, amountRaised);
633             }
634         }
635     }
636 
637     function checkFundingCap() internal {
638         if (!fundingCapReached) {
639             if (amountRaised >= fundingCap) {
640                 fundingCapReached = true;
641                 saleClosed = true;
642                 emit CapReached(beneficiary, amountRaised);
643             }
644         }
645     }
646 
647     function currentTime() public view returns (uint _currentTime) {
648         return block.timestamp;
649     }
650 
651     function convertToMiniCFT(uint amount) internal view returns (uint) {
652         return amount * (10 ** uint(tokenReward.decimals()));
653     }
654 
655     function changeStartTime(uint256 _startTime) external onlyOwner {startTime = _startTime;}
656     function changeEndTime(uint256 _endTime) external onlyOwner {endTime = _endTime;}
657 
658 }