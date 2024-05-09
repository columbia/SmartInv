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
293 contract CQSToken is StandardBurnableToken {
294     // Constants
295     string  public constant name = "CQS";
296     string  public constant symbol = "CQS";
297     uint8   public constant decimals = 18;
298     address public owner;
299     string  public website = "www.cqsexchange.io"; 
300     uint256 public constant INITIAL_SUPPLY      =  2000000000 * (10 ** uint256(decimals));
301     uint256 public constant CROWDSALE_ALLOWANCE =  1600000000 * (10 ** uint256(decimals));
302     uint256 public constant ADMIN_ALLOWANCE     =   400000000 * (10 ** uint256(decimals));
303 
304     // Properties
305     //uint256 public totalSupply;
306     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
307     uint256 public adminAllowance;          // the number of tokens available for the administrator
308     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
309     address public adminAddr;               // the address of a crowdsale currently selling this token
310     bool public icoStart = false;
311     mapping(address => uint256) public tokensTransferred;
312 
313     // Events
314     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
315 
316     // Modifiers
317     modifier validDestination(address _to) {
318         require(_to != address(0x0));
319         require(_to != address(this));
320         require(_to != owner);
321         //require(_to != address(adminAddr));
322         //require(_to != address(crowdSaleAddr));
323         _;
324     }
325 
326     modifier onlyOwner() {
327         require(msg.sender == owner);
328         _;
329     }
330 
331     constructor(address _admin) public {
332         // the owner is a custodian of tokens that can
333         // give an allowance of tokens for crowdsales
334         // or to the admin, but cannot itself transfer
335         // tokens; hence, this requirement
336         require(msg.sender != _admin);
337 
338         owner = msg.sender;
339 
340         //totalSupply = INITIAL_SUPPLY;
341         totalSupply_ = INITIAL_SUPPLY;
342         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
343         adminAllowance = ADMIN_ALLOWANCE;
344 
345         // mint all tokens
346         balances[msg.sender] = totalSupply_.sub(adminAllowance);
347         emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));
348 
349         balances[_admin] = adminAllowance;
350         emit Transfer(address(0x0), _admin, adminAllowance);
351 
352         adminAddr = _admin;
353         approve(adminAddr, adminAllowance);
354     }
355 
356     /**
357     * @dev called by the owner to start the ICO
358     */
359     function startICO() external onlyOwner {
360         icoStart = true;
361     }
362 
363     /**
364     * @dev called by the owner to stop the ICO
365     */
366     function stopICO() external onlyOwner {
367         icoStart = false;
368     }
369 
370 
371     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
372         require(_amountForSale <= crowdSaleAllowance);
373 
374         // if 0, then full available crowdsale supply is assumed
375         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
376 
377         // Clear allowance of old, and set allowance of new
378         approve(crowdSaleAddr, 0);
379         approve(_crowdSaleAddr, amount);
380 
381         crowdSaleAddr = _crowdSaleAddr;
382         //icoStart = true;
383     }
384 
385 
386     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
387         if(icoStart && (msg.sender != owner || msg.sender != adminAddr)){
388             require((tokensTransferred[msg.sender].add(_value)).mul(2)<=balances[msg.sender].add(tokensTransferred[msg.sender]));
389             tokensTransferred[msg.sender] = tokensTransferred[msg.sender].add(_value);
390             return super.transfer(_to, _value);
391         }else
392             return super.transfer(_to, _value);
393     }
394 
395     function transferOwnership(address newOwner) public onlyOwner {
396         require(newOwner != address(0));
397         emit OwnershipTransferred(owner, newOwner);
398         owner = newOwner;
399     }
400 
401 
402     function burn(uint256 _value) public {
403         require(msg.sender==owner || msg.sender==adminAddr);
404         _burn(msg.sender, _value);
405     }
406 
407 
408     function burnFromAdmin(uint256 _value) external onlyOwner {
409         _burn(adminAddr, _value);
410     }
411 
412     function changeWebsite(string _website) external onlyOwner {website = _website;}
413 
414 
415 }
416 
417 contract CQSSale {
418 
419     using SafeMath for uint256;
420 
421     // The beneficiary is the future recipient of the funds
422     address public beneficiary;
423 
424     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
425     uint public fundingGoal;
426     uint public fundingCap;
427     uint public minContribution;
428     bool public fundingGoalReached = false;
429     bool public fundingCapReached = false;
430     bool public saleClosed = false;
431 
432     // Time period of sale (UNIX timestamps)
433     uint public startTime;
434     uint public endTime;
435     address public owner;
436 
437     // Keeps track of the amount of wei raised
438     uint public amountRaised;
439 
440     // Refund amount, should it be required
441     uint public refundAmount;
442 
443     // The ratio of CQS to Ether
444     uint public rate = 50000;
445     uint public constant LOW_RANGE_RATE = 1;
446     uint public constant HIGH_RANGE_RATE = 500000;
447 
448     // prevent certain functions from being recursively called
449     bool private rentrancy_lock = false;
450     bool public paused = false;
451 
452     // The token being sold
453     CQSToken public tokenReward;
454 
455     // A map that tracks the amount of wei contributed by address
456     mapping(address => uint256) public balanceOf;
457 
458     mapping(address => uint256) public contributions;
459     //uint public maxUserContribution = 20 * 1 ether;
460     //mapping(address => uint256) public caps;
461 
462     // Events
463     event GoalReached(address _beneficiary, uint _amountRaised);
464     event CapReached(address _beneficiary, uint _amountRaised);
465     event FundTransfer(address _backer, uint _amount, bool _isContribution);
466     event Pause();
467     event Unpause();
468 
469     // Modifiers
470     modifier beforeDeadline()   {require (currentTime() < endTime); _;}
471     modifier afterDeadline()    {require (currentTime() >= endTime); _;}
472     modifier afterStartTime()    {require (currentTime() >= startTime); _;}
473 
474     modifier saleNotClosed()    {require (!saleClosed); _;}
475 
476     modifier nonReentrant() {
477         require(!rentrancy_lock);
478         rentrancy_lock = true;
479         _;
480         rentrancy_lock = false;
481     }
482 
483     modifier onlyOwner() {
484         require(msg.sender == owner);
485         _;
486     }
487 
488     
489     /**
490     * @dev Modifier to make a function callable only when the contract is not paused.
491     */
492     modifier whenNotPaused() {
493         require(!paused);
494         _;
495     }
496 
497     /**
498     * @dev Modifier to make a function callable only when the contract is paused.
499     */
500     modifier whenPaused() {
501         require(paused);
502         _;
503     }
504 
505     /**
506     * @dev called by the owner to pause, triggers stopped state
507     */
508     function pause() onlyOwner whenNotPaused public {
509         paused = true;
510         tokenReward.stopICO();
511         emit Pause();
512     }
513 
514     /**
515     * @dev called by the owner to unpause, returns to normal state
516     */
517     function unpause() onlyOwner whenPaused public {
518         paused = false;
519         tokenReward.startICO();
520         emit Unpause();
521     }
522 
523 
524     constructor(
525         address ifSuccessfulSendTo,
526         uint fundingGoalInEthers,
527         uint fundingCapInEthers,
528         uint minimumContributionInWei,
529         uint start,
530         uint end,
531         uint rateCQSToEther,
532         address addressOfTokenUsedAsReward
533     ) public {
534         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
535         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
536         require(fundingGoalInEthers <= fundingCapInEthers);
537         require(end > 0);
538         beneficiary = ifSuccessfulSendTo;
539         fundingGoal = fundingGoalInEthers * 1 ether;
540         fundingCap = fundingCapInEthers * 1 ether;
541         minContribution = minimumContributionInWei;
542         startTime = start;
543         endTime = end; // TODO double check
544         rate = rateCQSToEther;
545         tokenReward = CQSToken(addressOfTokenUsedAsReward);
546         owner = msg.sender;
547     }
548 
549 
550     function () external payable whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
551         require(msg.value >= minContribution);
552         //require(contributions[msg.sender].add(msg.value) <= maxUserContribution);
553 
554         // Update the sender's balance of wei contributed and the amount raised
555         uint amount = msg.value;
556         uint currentBalance = balanceOf[msg.sender];
557         balanceOf[msg.sender] = currentBalance.add(amount);
558         amountRaised = amountRaised.add(amount);
559 
560         // Compute the number of tokens to be rewarded to the sender
561         // Note: it's important for this calculation that both wei
562         // and CQS have the same number of decimal places (18)
563         uint numTokens = amount.mul(rate);
564 
565         // Transfer the tokens from the crowdsale supply to the sender
566         if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
567             emit FundTransfer(msg.sender, amount, true);
568             contributions[msg.sender] = contributions[msg.sender].add(amount);
569             // Following code is to automatically transfer ETH to beneficiary
570             //uint balanceToSend = this.balance;
571             //beneficiary.transfer(balanceToSend);
572             //FundTransfer(beneficiary, balanceToSend, false);
573             checkFundingGoal();
574             checkFundingCap();
575         }
576         else {
577             revert();
578         }
579     }
580 
581     function terminate() external onlyOwner {
582         saleClosed = true;
583         tokenReward.stopICO();
584     }
585 
586     function setRate(uint _rate) external onlyOwner {
587         require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
588         rate = _rate;
589     }
590 
591     function ownerAllocateTokens(address _to, uint amountWei, uint amountMiniCQS) external
592             onlyOwner nonReentrant
593     {
594         if (!tokenReward.transferFrom(tokenReward.owner(), _to, amountMiniCQS)) {
595             revert();
596         }
597         balanceOf[_to] = balanceOf[_to].add(amountWei);
598         amountRaised = amountRaised.add(amountWei);
599         emit FundTransfer(_to, amountWei, true);
600         checkFundingGoal();
601         checkFundingCap();
602     }
603 
604     function ownerSafeWithdrawal() external onlyOwner nonReentrant {
605         require(fundingGoalReached);
606         uint balanceToSend = address(this).balance;
607         beneficiary.transfer(balanceToSend);
608         emit FundTransfer(beneficiary, balanceToSend, false);
609     }
610 
611     function ownerUnlockFund() external afterDeadline onlyOwner {
612         fundingGoalReached = false;
613     }
614 
615     function safeWithdrawal() external afterDeadline nonReentrant {
616         if (!fundingGoalReached) {
617             uint amount = balanceOf[msg.sender];
618             balanceOf[msg.sender] = 0;
619             if (amount > 0) {
620                 msg.sender.transfer(amount);
621                 emit FundTransfer(msg.sender, amount, false);
622                 refundAmount = refundAmount.add(amount);
623             }
624         }
625     }
626 
627     function checkFundingGoal() internal {
628         if (!fundingGoalReached) {
629             if (amountRaised >= fundingGoal) {
630                 fundingGoalReached = true;
631                 emit GoalReached(beneficiary, amountRaised);
632             }
633         }
634     }
635 
636     function checkFundingCap() internal {
637         if (!fundingCapReached) {
638             if (amountRaised >= fundingCap) {
639                 fundingCapReached = true;
640                 saleClosed = true;
641                 emit CapReached(beneficiary, amountRaised);
642             }
643         }
644     }
645 
646     function currentTime() public view returns (uint _currentTime) {
647         return block.timestamp;
648     }
649 
650     function convertToMiniCQS(uint amount) internal view returns (uint) {
651         return amount * (10 ** uint(tokenReward.decimals()));
652     }
653 
654     function changeStartTime(uint256 _startTime) external onlyOwner {startTime = _startTime;}
655     function changeEndTime(uint256 _endTime) external onlyOwner {endTime = _endTime;}
656 
657 }