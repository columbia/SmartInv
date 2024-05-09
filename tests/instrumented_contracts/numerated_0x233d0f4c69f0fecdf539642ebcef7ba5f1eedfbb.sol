1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
6         if (_a == 0) {
7             return 0;
8         }
9 
10         c = _a * _b;
11         assert(c / _a == _b);
12         return c;
13     }
14 
15     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
16         return _a / _b;
17     }
18 
19     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20         assert(_b <= _a);
21         return _a - _b;
22     }
23 
24     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25         c = _a + _b;
26         assert(c >= _a);
27         return c;
28     }
29 }
30 
31 
32 
33 
34 
35 
36 contract BaseCHIPSale {
37     using SafeMath for uint256;
38 
39     address public owner;
40     bool public paused = false;
41     // The beneficiary is the future recipient of the funds
42     address public beneficiary;
43 
44     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
45     uint public fundingGoal;
46     uint public fundingCap;
47     //uint public minContribution;
48     bool public fundingGoalReached = false;
49     bool public fundingCapReached = false;
50     bool public saleClosed = false;
51 
52     // Time period of sale (UNIX timestamps)
53     uint public startTime;
54     uint public endTime;
55 
56     // Keeps track of the amount of wei raised
57     uint public amountRaised;
58 
59     // Refund amount, should it be required
60     uint public refundAmount;
61 
62     // The ratio of CHP to Ether
63     uint public rate = 10000;
64     uint public withdrawRate = 10000;
65 
66     // prevent certain functions from being recursively called
67     bool private rentrancy_lock = false;
68 
69     // A map that tracks the amount of wei contributed by address
70     mapping(address => uint256) public balanceOf;
71 
72     // Events
73     event GoalReached(address _beneficiary, uint _amountRaised);
74     event CapReached(address _beneficiary, uint _amountRaised);
75     event FundTransfer(address _backer, uint _amount, bool _isContribution);
76     event Pause();
77     event Unpause();
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     // Modifiers
81     modifier onlyOwner() {
82         require(msg.sender == owner,"Only the owner is allowed to call this."); 
83         _; 
84     }
85 
86     // Modifiers
87     modifier beforeDeadline(){
88         require (currentTime() < endTime, "Validation: Before endtime");
89         _;
90     }
91     modifier afterDeadline(){
92         require (currentTime() >= endTime, "Validation: After endtime"); 
93         _;
94     }
95     modifier afterStartTime(){
96         require (currentTime() >= startTime, "Validation: After starttime"); 
97         _;
98     }
99 
100     modifier saleNotClosed(){
101         require (!saleClosed, "Sale is not yet ended"); 
102         _;
103     }
104 
105     modifier nonReentrant() {
106         require(!rentrancy_lock, "Validation: Reentrancy");
107         rentrancy_lock = true;
108         _;
109         rentrancy_lock = false;
110     }
111 
112     /**
113     * @dev Modifier to make a function callable only when the contract is not paused.
114     */
115     modifier whenNotPaused() {
116         require(!paused, "You are not allowed to access this time.");
117         _;
118     }
119 
120     /**
121     * @dev Modifier to make a function callable only when the contract is paused.
122     */
123     modifier whenPaused() {
124         require(paused, "You are not allowed to access this time.");
125         _;
126     }
127 
128     constructor() public{
129         owner = msg.sender;
130     }
131 
132     /**
133     * @dev Allows the current owner to transfer control of the contract to a newOwner.
134     * @param _newOwner The address to transfer ownership to.
135     */
136     function transferOwnership(address _newOwner) public onlyOwner {
137         _transferOwnership(_newOwner);
138     }
139 
140     /**
141     * @dev Transfers control of the contract to a newOwner.
142     * @param _newOwner The address to transfer ownership to.
143     */
144     function _transferOwnership(address _newOwner) internal {
145         require(_newOwner != address(0), "Owner cannot be 0 address.");
146         emit OwnershipTransferred(owner, _newOwner);
147         owner = _newOwner;
148     }
149 
150     /**
151     * @dev called by the owner to pause, triggers stopped state
152     */
153     function pause() public onlyOwner whenNotPaused {
154         paused = true;
155         emit Pause();
156     }
157 
158     /**
159     * @dev called by the owner to unpause, returns to normal state
160     */
161     function unpause() public onlyOwner whenPaused {
162         paused = false;
163         emit Unpause();
164     }
165 
166     /**
167      * Returns the current time.
168      * Useful to abstract calls to "now" for tests.
169     */
170     function currentTime() public view returns (uint _currentTime) {
171         return block.timestamp;
172     }
173 
174     /**
175      * The owner can terminate the crowdsale at any time.
176      */
177     function terminate() external onlyOwner {
178         saleClosed = true;
179     }
180 
181     /**
182      * The owner can update the rate (CHP to ETH).
183      *
184      * @param _rate  the new rate for converting CHP to ETH
185      */
186     function setRate(uint _rate) public onlyOwner {
187         //require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
188         rate = _rate;
189     }
190 
191     function setWithdrawRate(uint _rate) public onlyOwner {
192         //require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
193         withdrawRate = _rate;
194     }
195 
196     /**
197      * The owner can unlock the fund with this function. The use-
198      * case for this is when the owner decides after the deadline
199      * to allow contributors to be refunded their contributions.
200      * Note that the fund would be automatically unlocked if the
201      * minimum funding goal were not reached.
202      */
203     function ownerUnlockFund() external afterDeadline onlyOwner {
204         fundingGoalReached = false;
205     }
206 
207     /**
208      * Checks if the funding goal has been reached. If it has, then
209      * the GoalReached event is triggered.
210      */
211     function checkFundingGoal() internal {
212         if (!fundingGoalReached) {
213             if (amountRaised >= fundingGoal) {
214                 fundingGoalReached = true;
215                 emit GoalReached(beneficiary, amountRaised);
216             }
217         }
218     }
219 
220     /**
221      * Checks if the funding cap has been reached. If it has, then
222      * the CapReached event is triggered.
223      */
224     function checkFundingCap() internal {
225         if (!fundingCapReached) {
226             if (amountRaised >= fundingCap) {
227                 fundingCapReached = true;
228                 saleClosed = true;
229                 emit CapReached(beneficiary, amountRaised);
230             }
231         }
232     }
233 
234     /**
235      * These helper functions are exposed for changing the start and end time dynamically   
236      */
237     function changeStartTime(uint256 _startTime) external onlyOwner {startTime = _startTime;}
238     function changeEndTime(uint256 _endTime) external onlyOwner {endTime = _endTime;}
239 }
240 
241 
242 
243 
244 
245 
246 contract BaseCHIPToken {
247     using SafeMath for uint256;
248 
249     // Globals
250     address public owner;
251     mapping(address => uint256) internal balances;
252     mapping (address => mapping (address => uint256)) internal allowed;
253     uint256 internal totalSupply_;
254 
255     // Events
256     event Transfer(address indexed from, address indexed to, uint256 value);
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258     event Burn(address indexed burner, uint256 value);
259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
260     event Mint(address indexed to, uint256 amount);
261 
262     // Modifiers
263     modifier onlyOwner() {
264         require(msg.sender == owner,"Only the owner is allowed to call this."); 
265         _; 
266     }
267 
268     constructor() public{
269         owner = msg.sender;
270     }
271 
272     /**
273     * @dev Total number of tokens in existence
274     */
275     function totalSupply() public view returns (uint256) {
276         return totalSupply_;
277     }
278 
279     /**
280     * @dev Transfer token for a specified address
281     * @param _to The address to transfer to.
282     * @param _value The amount to be transferred.
283     */
284     function transfer(address _to, uint256 _value) public returns (bool) {
285         require(_value <= balances[msg.sender], "You do not have sufficient balance.");
286         require(_to != address(0), "You cannot send tokens to 0 address");
287 
288         balances[msg.sender] = balances[msg.sender].sub(_value);
289         balances[_to] = balances[_to].add(_value);
290         emit Transfer(msg.sender, _to, _value);
291         return true;
292     }
293 
294     /**
295     * @dev Gets the balance of the specified address.
296     * @param _owner The address to query the the balance of.
297     * @return An uint256 representing the amount owned by the passed address.
298     */
299     function balanceOf(address _owner) public view returns (uint256) {
300         return balances[_owner];
301     }
302 
303     /**
304     * @dev Transfer tokens from one address to another
305     * @param _from address The address which you want to send tokens from
306     * @param _to address The address which you want to transfer to
307     * @param _value uint256 the amount of tokens to be transferred
308     */
309     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
310         require(_value <= balances[_from], "You do not have sufficient balance.");
311         require(_value <= allowed[_from][msg.sender], "You do not have allowance.");
312         require(_to != address(0), "You cannot send tokens to 0 address");
313 
314         balances[_from] = balances[_from].sub(_value);
315         balances[_to] = balances[_to].add(_value);
316         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317         emit Transfer(_from, _to, _value);
318         return true;
319     }
320 
321     /**
322     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
323     * Beware that changing an allowance with this method brings the risk that someone may use both the old
324     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
325     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
326     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
327     * @param _spender The address which will spend the funds.
328     * @param _value The amount of tokens to be spent.
329     */
330     function approve(address _spender, uint256 _value) public returns (bool) {
331         allowed[msg.sender][_spender] = _value;
332         emit Approval(msg.sender, _spender, _value);
333         return true;
334     }
335 
336     /**
337     * @dev Function to check the amount of tokens that an owner allowed to a spender.
338     * @param _owner address The address which owns the funds.
339     * @param _spender address The address which will spend the funds.
340     * @return A uint256 specifying the amount of tokens still available for the spender.
341     */
342     function allowance(address _owner, address _spender) public view returns (uint256){
343         return allowed[_owner][_spender];
344     }
345 
346     /**
347     * @dev Increase the amount of tokens that an owner allowed to a spender.
348     * approve should be called when allowed[_spender] == 0. To increment
349     * allowed value is better to use this function to avoid 2 calls (and wait until
350     * the first transaction is mined)
351     * From MonolithDAO Token.sol
352     * @param _spender The address which will spend the funds.
353     * @param _addedValue The amount of tokens to increase the allowance by.
354     */
355     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool){
356         allowed[msg.sender][_spender] = (
357         allowed[msg.sender][_spender].add(_addedValue));
358         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359         return true;
360     }
361 
362     /**
363     * @dev Decrease the amount of tokens that an owner allowed to a spender.
364     * approve should be called when allowed[_spender] == 0. To decrement
365     * allowed value is better to use this function to avoid 2 calls (and wait until
366     * the first transaction is mined)
367     * From MonolithDAO Token.sol
368     * @param _spender The address which will spend the funds.
369     * @param _subtractedValue The amount of tokens to decrease the allowance by.
370     */
371     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool){
372         uint256 oldValue = allowed[msg.sender][_spender];
373         if (_subtractedValue >= oldValue) {
374             allowed[msg.sender][_spender] = 0;
375         } else {
376             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
377         }
378         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
379         return true;
380     }
381 
382     /**
383     * @dev Burns a specific amount of tokens.
384     * @param _value The amount of token to be burned.
385     */
386     function burn(uint256 _value) public {
387         _burn(msg.sender, _value);
388     }
389 
390     function _burn(address _who, uint256 _value) internal {
391         require(_value <= balances[_who], "Insufficient balance of tokens");
392         // no need to require value <= totalSupply, since that would imply the
393         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
394 
395         balances[_who] = balances[_who].sub(_value);
396         totalSupply_ = totalSupply_.sub(_value);
397         emit Burn(_who, _value);
398         emit Transfer(_who, address(0), _value);
399     }
400 
401     /**
402     * @dev Burns a specific amount of tokens from the target address and decrements allowance
403     * @param _from address The address which you want to send tokens from
404     * @param _value uint256 The amount of token to be burned
405     */
406     function burnFrom(address _from, uint256 _value) public {
407         require(_value <= allowed[_from][msg.sender], "Insufficient allowance to burn tokens.");
408         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
409         _burn(_from, _value);
410     }
411 
412     /**
413     * @dev Allows the current owner to transfer control of the contract to a newOwner.
414     * @param _newOwner The address to transfer ownership to.
415     */
416     function transferOwnership(address _newOwner) public onlyOwner {
417         _transferOwnership(_newOwner);
418     }
419 
420     /**
421     * @dev Transfers control of the contract to a newOwner.
422     * @param _newOwner The address to transfer ownership to.
423     */
424     function _transferOwnership(address _newOwner) internal {
425         require(_newOwner != address(0), "Owner cannot be 0 address.");
426         emit OwnershipTransferred(owner, _newOwner);
427         owner = _newOwner;
428     }
429 
430     /**
431     * @dev Function to mint tokens
432     * @param _to The address that will receive the minted tokens.
433     * @param _amount The amount of tokens to mint.
434     * @return A boolean that indicates if the operation was successful.
435     */
436     function mint(address _to, uint256 _amount) public onlyOwner returns (bool){
437         totalSupply_ = totalSupply_.add(_amount);
438         balances[_to] = balances[_to].add(_amount);
439         emit Mint(_to, _amount);
440         emit Transfer(address(0), _to, _amount);
441         return true;
442     }
443 
444 }
445 
446 contract CHIPToken is BaseCHIPToken {
447     
448     // Constants
449     string  public constant name = "Chips";
450     string  public constant symbol = "CHP";
451     uint8   public constant decimals = 18;
452 
453     uint256 public constant INITIAL_SUPPLY      =  2000000000 * (10 ** uint256(decimals));
454     uint256 public constant CROWDSALE_ALLOWANCE =  1000000000 * (10 ** uint256(decimals));
455     uint256 public constant ADMIN_ALLOWANCE     =  1000000000 * (10 ** uint256(decimals));
456     
457     // Properties
458     //uint256 public totalSupply;
459     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
460     uint256 public adminAllowance;          // the number of tokens available for the administrator
461     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
462     address public adminAddr;               // the address of a crowdsale currently selling this token
463     //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
464     bool    public transferEnabled = true;  // Enables everyone to transfer tokens
465 
466     /**
467      * The listed addresses are not valid recipients of tokens.
468      *
469      * 0x0           - the zero address is not valid
470      * this          - the contract itself should not receive tokens
471      * owner         - the owner has all the initial tokens, but cannot receive any back
472      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
473      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
474      */
475     modifier validDestination(address _to) {
476         require(_to != address(0x0), "Cannot send to 0 address");
477         require(_to != address(this), "Cannot send to contract address");
478         //require(_to != owner, "Cannot send to the owner");
479         //require(_to != address(adminAddr), "Cannot send to admin address");
480         require(_to != address(crowdSaleAddr), "Cannot send to crowdsale address");
481         _;
482     }
483 
484     modifier onlyCrowdsale {
485         require(msg.sender == crowdSaleAddr, "Only crowdsale contract can call this");
486         _;
487     }
488 
489     constructor(address _admin) public {
490         require(msg.sender != _admin, "Owner and admin cannot be the same");
491 
492         totalSupply_ = INITIAL_SUPPLY;
493         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
494         adminAllowance = ADMIN_ALLOWANCE;
495 
496         // mint all tokens
497         balances[msg.sender] = totalSupply_.sub(adminAllowance);
498         emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));
499 
500         balances[_admin] = adminAllowance;
501         emit Transfer(address(0x0), _admin, adminAllowance);
502 
503         adminAddr = _admin;
504         approve(adminAddr, adminAllowance);
505     }
506 
507     /**
508      * Overrides ERC20 transfer function with modifier that prevents the
509      * ability to transfer tokens until after transfers have been enabled.
510      */
511     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
512         return super.transfer(_to, _value);
513     }
514 
515     /**
516      * Overrides ERC20 transferFrom function with modifier that prevents the
517      * ability to transfer tokens until after transfers have been enabled.
518      */
519     function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
520         bool result = super.transferFrom(_from, _to, _value);
521         if (result) {
522             if (msg.sender == crowdSaleAddr)
523                 crowdSaleAllowance = crowdSaleAllowance.sub(_value);
524             if (msg.sender == adminAddr)
525                 adminAllowance = adminAllowance.sub(_value);
526         }
527         return result;
528     }
529 
530     /**
531      * Associates this token with a current crowdsale, giving the crowdsale
532      * an allowance of tokens from the crowdsale supply. This gives the
533      * crowdsale the ability to call transferFrom to transfer tokens to
534      * whomever has purchased them.
535      *
536      * Note that if _amountForSale is 0, then it is assumed that the full
537      * remaining crowdsale supply is made available to the crowdsale.
538      *
539      * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
540      * @param _amountForSale The supply of tokens provided to the crowdsale
541      */
542     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
543         require(_amountForSale <= crowdSaleAllowance, "Sale amount should be less than the crowdsale allowance limits.");
544 
545         // if 0, then full available crowdsale supply is assumed
546         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
547 
548         // Clear allowance of old, and set allowance of new
549         approve(crowdSaleAddr, 0);
550         approve(_crowdSaleAddr, amount);
551 
552         crowdSaleAddr = _crowdSaleAddr;
553     }
554 
555     function setAllowanceBeforeWithdrawal(address _from, address _to, uint _value) public onlyCrowdsale returns (bool) {
556         allowed[_from][_to] = _value;
557         emit Approval(_from, _to, _value);
558         return true;
559     }
560 }
561 
562 contract CHIPSale is BaseCHIPSale {
563     using SafeMath for uint256;
564 
565     // The token being sold
566     CHIPToken public tokenReward;
567 
568     /**
569      * Constructor for a crowdsale of CHPToken tokens.
570      *
571      * @param ifSuccessfulSendTo            the beneficiary of the fund
572      * @param fundingGoalInEthers           the minimum goal to be reached
573      * @param fundingCapInEthers            the cap (maximum) size of the fund
574      * @param start                         the start time (UNIX timestamp)
575      * @param end                           the end time (UNIX timestamp)
576      * @param rateCHPToEther                 the conversion rate from CHP to Ether
577      * @param addressOfTokenUsedAsReward    address of the token being sold
578      */
579     constructor(
580         address ifSuccessfulSendTo,
581         uint fundingGoalInEthers,
582         uint fundingCapInEthers,
583         //uint minimumContributionInWei,
584         uint start,
585         uint end,
586         uint rateCHPToEther,
587         address addressOfTokenUsedAsReward
588     ) public {
589         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this), "Beneficiary cannot be 0 address");
590         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this), "Token address cannot be 0 address");
591         require(fundingGoalInEthers <= fundingCapInEthers, "Funding goal should be less that funding cap.");
592         require(end > 0, "Endtime cannot be 0");
593         beneficiary = ifSuccessfulSendTo;
594         fundingGoal = fundingGoalInEthers * 1 ether;
595         fundingCap = fundingCapInEthers * 1 ether;
596         //minContribution = minimumContributionInWei;
597         startTime = start;
598         endTime = end; // TODO double check
599         rate = rateCHPToEther;
600         withdrawRate = rateCHPToEther;
601         tokenReward = CHIPToken(addressOfTokenUsedAsReward);
602     }
603 
604     /**
605      * This fallback function is called whenever Ether is sent to the
606      * smart contract. It can only be executed when the crowdsale is
607      * not paused, not closed, and before the deadline has been reached.
608      *
609      * This function will update state variables for whether or not the
610      * funding goal or cap have been reached. It also ensures that the
611      * tokens are transferred to the sender, and that the correct
612      * number of tokens are sent according to the current rate.
613      */
614     function () public payable whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
615         //require(msg.value >= minContribution, "Value should be greater than minimum contribution");
616 
617         // Update the sender's balance of wei contributed and the amount raised
618         uint amount = msg.value;
619         uint currentBalance = balanceOf[msg.sender];
620         balanceOf[msg.sender] = currentBalance.add(amount);
621         amountRaised = amountRaised.add(amount);
622 
623         // Compute the number of tokens to be rewarded to the sender
624         // Note: it's important for this calculation that both wei
625         // and CHP have the same number of decimal places (18)
626         uint numTokens = amount.mul(rate);
627 
628         // Transfer the tokens from the crowdsale supply to the sender
629         if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
630             emit FundTransfer(msg.sender, amount, true);
631             //contributions[msg.sender] = contributions[msg.sender].add(amount);
632             // Following code is to automatically transfer ETH to beneficiary
633             //uint balanceToSend = this.balance;
634             //beneficiary.transfer(balanceToSend);
635             //FundTransfer(beneficiary, balanceToSend, false);
636             // Check if the funding goal or cap have been reached
637             // TODO check impact on gas cost
638             checkFundingGoal();
639             checkFundingCap();
640         }
641         else {
642             revert("Transaction Failed. Please try again later.");
643         }
644     }
645 
646     // Any users can call this function to send their tokens and get Ethers
647     function withdrawToken(uint tokensToWithdraw) public {
648         uint tokensInWei = convertToMini(tokensToWithdraw);
649         require(
650             tokensInWei <= tokenReward.balanceOf(msg.sender), 
651             "You do not have sufficient balance to withdraw"
652         );
653         uint ethToGive = tokensInWei.div(withdrawRate);
654         require(ethToGive <= address(this).balance, "Insufficient ethers.");
655         //tokenReward.increaseApproval(address(this),tokensInWei);
656         tokenReward.setAllowanceBeforeWithdrawal(msg.sender, address(this), tokensInWei);
657         tokenReward.transferFrom(msg.sender, tokenReward.owner(), tokensInWei);
658         msg.sender.transfer(ethToGive);
659         emit FundTransfer(this.owner(), ethToGive, true);
660     }
661 
662     /**
663      * The owner can allocate the specified amount of tokens from the
664      * crowdsale allowance to the recipient (_to).
665      *
666      * NOTE: be extremely careful to get the amounts correct, which
667      * are in units of wei and mini-CHP. Every digit counts.
668      *
669      * @param _to            the recipient of the tokens
670      * @param amountWei     the amount contributed in wei
671      * @param amountMiniCHP the amount of tokens transferred in mini-CHP (18 decimals)
672      */
673     function ownerAllocateTokens(address _to, uint amountWei, uint amountMiniCHP) public
674             onlyOwner nonReentrant
675     {
676         if (!tokenReward.transferFrom(tokenReward.owner(), _to, amountMiniCHP)) {
677             revert("Transfer failed. Please check allowance");
678         }
679         balanceOf[_to] = balanceOf[_to].add(amountWei);
680         amountRaised = amountRaised.add(amountWei);
681         emit FundTransfer(_to, amountWei, true);
682         checkFundingGoal();
683         checkFundingCap();
684     }
685 
686     /**
687      * The owner can call this function to withdraw the funds that
688      * have been sent to this contract for the crowdsale subject to
689      * the funding goal having been reached. The funds will be sent
690      * to the beneficiary specified when the crowdsale was created.
691      */
692     function ownerSafeWithdrawal() public onlyOwner nonReentrant {
693         require(fundingGoalReached, "Check funding goal");
694         uint balanceToSend = address(this).balance;
695         beneficiary.transfer(balanceToSend);
696         emit FundTransfer(beneficiary, balanceToSend, false);
697     }
698 
699     /**
700      * This function permits anybody to withdraw the funds they have
701      * contributed if and only if the deadline has passed and the
702      * funding goal was not reached.
703      */
704     function safeWithdrawal() public afterDeadline nonReentrant {
705         if (!fundingGoalReached) {
706             uint amount = balanceOf[msg.sender];
707             balanceOf[msg.sender] = 0;
708             if (amount > 0) {
709                 msg.sender.transfer(amount);
710                 emit FundTransfer(msg.sender, amount, false);
711                 refundAmount = refundAmount.add(amount);
712             }
713         }
714     }
715     
716     function convertToMini(uint amount) internal view returns (uint) {
717         return amount * (10 ** uint(tokenReward.decimals()));
718     }    
719 }