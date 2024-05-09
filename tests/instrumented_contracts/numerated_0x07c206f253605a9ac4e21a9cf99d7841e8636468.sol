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
293 contract RYCToken is StandardBurnableToken {
294     // Constants
295     string  public constant name = "Ramon Y Cayal";
296     string  public constant symbol = "RYC";
297     uint8   public constant decimals = 18;
298     address public owner;
299     string  public website = "www.ramonycayal.io"; 
300     uint256 public constant INITIAL_SUPPLY      =  5000000000 * (10 ** uint256(decimals));
301     uint256 public constant CROWDSALE_ALLOWANCE =  4000000000 * (10 ** uint256(decimals));
302     uint256 public constant ADMIN_ALLOWANCE     =  1000000000 * (10 ** uint256(decimals));
303 
304     // Properties
305     //uint256 public totalSupply;
306     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
307     uint256 public adminAllowance;          // the number of tokens available for the administrator
308     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
309     address public adminAddr;               // the address of a crowdsale currently selling this token
310 
311     // Events
312     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
313 
314     // Modifiers
315     modifier validDestination(address _to) {
316         require(_to != address(0x0));
317         require(_to != address(this));
318         require(_to != owner);
319         //require(_to != address(adminAddr));
320         //require(_to != address(crowdSaleAddr));
321         _;
322     }
323 
324     modifier onlyOwner() {
325         require(msg.sender == owner);
326         _;
327     }
328 
329     constructor(address _admin) public {
330         // the owner is a custodian of tokens that can
331         // give an allowance of tokens for crowdsales
332         // or to the admin, but cannot itself transfer
333         // tokens; hence, this requirement
334         require(msg.sender != _admin);
335 
336         owner = msg.sender;
337 
338         //totalSupply = INITIAL_SUPPLY;
339         totalSupply_ = INITIAL_SUPPLY;
340         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
341         adminAllowance = ADMIN_ALLOWANCE;
342 
343         // mint all tokens
344         balances[msg.sender] = totalSupply_.sub(adminAllowance);
345         emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));
346 
347         balances[_admin] = adminAllowance;
348         emit Transfer(address(0x0), _admin, adminAllowance);
349 
350         adminAddr = _admin;
351         approve(adminAddr, adminAllowance);
352     }
353 
354 
355     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
356         require(_amountForSale <= crowdSaleAllowance);
357 
358         // if 0, then full available crowdsale supply is assumed
359         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
360 
361         // Clear allowance of old, and set allowance of new
362         approve(crowdSaleAddr, 0);
363         approve(_crowdSaleAddr, amount);
364 
365         crowdSaleAddr = _crowdSaleAddr;
366     }
367 
368 
369     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
370         return super.transfer(_to, _value);
371     }
372 
373     function transferOwnership(address newOwner) public onlyOwner {
374         require(newOwner != address(0));
375         emit OwnershipTransferred(owner, newOwner);
376         owner = newOwner;
377     }
378 
379 
380     function burn(uint256 _value) public {
381         require(msg.sender==owner || msg.sender==adminAddr);
382         _burn(msg.sender, _value);
383     }
384 
385 
386     function burnFromAdmin(uint256 _value) external onlyOwner {
387         _burn(adminAddr, _value);
388     }
389 
390     function changeWebsite(string _website) external onlyOwner {website = _website;}
391 
392 
393 }
394 
395 contract RYCSale {
396 
397     using SafeMath for uint256;
398 
399     // The beneficiary is the future recipient of the funds
400     address public beneficiary;
401 
402     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
403     uint public fundingGoal;
404     uint public fundingCap;
405     uint public minContribution;
406     bool public fundingGoalReached = false;
407     bool public fundingCapReached = false;
408     bool public saleClosed = false;
409 
410     // Time period of sale (UNIX timestamps)
411     uint public startTime;
412     uint public endTime;
413     address public owner;
414 
415     // Keeps track of the amount of wei raised
416     uint public amountRaised;
417 
418     // Refund amount, should it be required
419     uint public refundAmount;
420 
421     // The ratio of RYC to Ether
422     uint public rate = 5000;
423     uint public constant LOW_RANGE_RATE = 1;
424     uint public constant HIGH_RANGE_RATE = 30000;
425 
426     // prevent certain functions from being recursively called
427     bool private rentrancy_lock = false;
428     bool public paused = false;
429 
430     // The token being sold
431     RYCToken public tokenReward;
432 
433     // A map that tracks the amount of wei contributed by address
434     mapping(address => uint256) public balanceOf;
435 
436     mapping(address => uint256) public contributions;
437     //uint public maxUserContribution = 20 * 1 ether;
438     //mapping(address => uint256) public caps;
439 
440     // Events
441     event GoalReached(address _beneficiary, uint _amountRaised);
442     event CapReached(address _beneficiary, uint _amountRaised);
443     event FundTransfer(address _backer, uint _amount, bool _isContribution);
444     event Pause();
445     event Unpause();
446 
447     // Modifiers
448     modifier beforeDeadline()   {require (currentTime() < endTime); _;}
449     modifier afterDeadline()    {require (currentTime() >= endTime); _;}
450     modifier afterStartTime()    {require (currentTime() >= startTime); _;}
451 
452     modifier saleNotClosed()    {require (!saleClosed); _;}
453 
454     modifier nonReentrant() {
455         require(!rentrancy_lock);
456         rentrancy_lock = true;
457         _;
458         rentrancy_lock = false;
459     }
460 
461     modifier onlyOwner() {
462         require(msg.sender == owner);
463         _;
464     }
465 
466     
467     /**
468     * @dev Modifier to make a function callable only when the contract is not paused.
469     */
470     modifier whenNotPaused() {
471         require(!paused);
472         _;
473     }
474 
475     /**
476     * @dev Modifier to make a function callable only when the contract is paused.
477     */
478     modifier whenPaused() {
479         require(paused);
480         _;
481     }
482 
483     /**
484     * @dev called by the owner to pause, triggers stopped state
485     */
486     function pause() onlyOwner whenNotPaused public {
487         paused = true;
488         emit Pause();
489     }
490 
491     /**
492     * @dev called by the owner to unpause, returns to normal state
493     */
494     function unpause() onlyOwner whenPaused public {
495         paused = false;
496         emit Unpause();
497     }
498 
499 
500     constructor(
501         address ifSuccessfulSendTo,
502         uint fundingGoalInEthers,
503         uint fundingCapInEthers,
504         uint minimumContributionInWei,
505         uint start,
506         uint end,
507         uint rateRYCToEther,
508         address addressOfTokenUsedAsReward
509     ) public {
510         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
511         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
512         require(fundingGoalInEthers <= fundingCapInEthers);
513         require(end > 0);
514         beneficiary = ifSuccessfulSendTo;
515         fundingGoal = fundingGoalInEthers * 1 ether;
516         fundingCap = fundingCapInEthers * 1 ether;
517         minContribution = minimumContributionInWei;
518         startTime = start;
519         endTime = end; // TODO double check
520         rate = rateRYCToEther;
521         tokenReward = RYCToken(addressOfTokenUsedAsReward);
522         owner = msg.sender;
523     }
524 
525 
526     function () external payable whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
527         require(msg.value >= minContribution);
528         //require(contributions[msg.sender].add(msg.value) <= maxUserContribution);
529 
530         // Update the sender's balance of wei contributed and the amount raised
531         uint amount = msg.value;
532         uint currentBalance = balanceOf[msg.sender];
533         balanceOf[msg.sender] = currentBalance.add(amount);
534         amountRaised = amountRaised.add(amount);
535 
536         // Compute the number of tokens to be rewarded to the sender
537         // Note: it's important for this calculation that both wei
538         // and RYC have the same number of decimal places (18)
539         uint numTokens = amount.mul(rate);
540 
541         // Transfer the tokens from the crowdsale supply to the sender
542         if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
543             emit FundTransfer(msg.sender, amount, true);
544             contributions[msg.sender] = contributions[msg.sender].add(amount);
545             // Following code is to automatically transfer ETH to beneficiary
546             //uint balanceToSend = this.balance;
547             //beneficiary.transfer(balanceToSend);
548             //FundTransfer(beneficiary, balanceToSend, false);
549             checkFundingGoal();
550             checkFundingCap();
551         }
552         else {
553             revert();
554         }
555     }
556 
557     function terminate() external onlyOwner {
558         saleClosed = true;
559     }
560 
561     function setRate(uint _rate) external onlyOwner {
562         require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
563         rate = _rate;
564     }
565 
566     function ownerAllocateTokens(address _to, uint amountWei, uint amountMiniRYC) external
567             onlyOwner nonReentrant
568     {
569         if (!tokenReward.transferFrom(tokenReward.owner(), _to, amountMiniRYC)) {
570             revert();
571         }
572         balanceOf[_to] = balanceOf[_to].add(amountWei);
573         amountRaised = amountRaised.add(amountWei);
574         emit FundTransfer(_to, amountWei, true);
575         checkFundingGoal();
576         checkFundingCap();
577     }
578 
579     function ownerSafeWithdrawal() external onlyOwner nonReentrant {
580         require(fundingGoalReached);
581         uint balanceToSend = address(this).balance;
582         beneficiary.transfer(balanceToSend);
583         emit FundTransfer(beneficiary, balanceToSend, false);
584     }
585 
586     function ownerUnlockFund() external afterDeadline onlyOwner {
587         fundingGoalReached = false;
588     }
589 
590     function safeWithdrawal() external afterDeadline nonReentrant {
591         if (!fundingGoalReached) {
592             uint amount = balanceOf[msg.sender];
593             balanceOf[msg.sender] = 0;
594             if (amount > 0) {
595                 msg.sender.transfer(amount);
596                 emit FundTransfer(msg.sender, amount, false);
597                 refundAmount = refundAmount.add(amount);
598             }
599         }
600     }
601 
602     function checkFundingGoal() internal {
603         if (!fundingGoalReached) {
604             if (amountRaised >= fundingGoal) {
605                 fundingGoalReached = true;
606                 emit GoalReached(beneficiary, amountRaised);
607             }
608         }
609     }
610 
611     function checkFundingCap() internal {
612         if (!fundingCapReached) {
613             if (amountRaised >= fundingCap) {
614                 fundingCapReached = true;
615                 saleClosed = true;
616                 emit CapReached(beneficiary, amountRaised);
617             }
618         }
619     }
620 
621     function currentTime() public view returns (uint _currentTime) {
622         return block.timestamp;
623     }
624 
625     function convertToMiniRYC(uint amount) internal view returns (uint) {
626         return amount * (10 ** uint(tokenReward.decimals()));
627     }
628 
629     function changeStartTime(uint256 _startTime) external onlyOwner {startTime = _startTime;}
630     function changeEndTime(uint256 _endTime) external onlyOwner {endTime = _endTime;}
631 
632 }