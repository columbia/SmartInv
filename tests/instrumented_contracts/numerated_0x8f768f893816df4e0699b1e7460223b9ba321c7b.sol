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
36 contract BaseLBSCSale {
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
47     uint public minContribution;
48     uint public decimals;
49     bool public fundingGoalReached = false;
50     bool public fundingCapReached = false;
51     bool public saleClosed = false;
52 
53     // Time period of sale (UNIX timestamps)
54     uint public startTime;
55     uint public endTime;
56 
57     // Keeps track of the amount of wei raised
58     uint public amountRaised;
59 
60     // Refund amount, should it be required
61     uint public refundAmount;
62 
63     // The ratio of CHP to Ether
64     uint public rate = 220;
65 
66     // prevent certain functions from being recursively called
67     bool private rentrancy_lock = false;
68 
69     // A map that tracks the amount of wei contributed by address
70     mapping(address => uint256) public balanceOf;
71 
72     address public manager;
73 
74     // Events
75     event GoalReached(address _beneficiary, uint _amountRaised);
76     event CapReached(address _beneficiary, uint _amountRaised);
77     event FundTransfer(address _backer, uint _amount, bool _isContribution);
78     event Pause();
79     event Unpause();
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     // Modifiers
83     modifier onlyOwner() {
84         require(msg.sender == owner,"Only the owner is allowed to call this."); 
85         _; 
86     }
87 
88     modifier onlyOwnerOrManager{
89         require(msg.sender == owner || msg.sender == manager, "Only owner or manager is allowed to call this");
90         _;
91     }
92 
93     modifier beforeDeadline(){
94         require (currentTime() < endTime, "Validation: Before endtime");
95         _;
96     }
97     modifier afterDeadline(){
98         require (currentTime() >= endTime, "Validation: After endtime"); 
99         _;
100     }
101     modifier afterStartTime(){
102         require (currentTime() >= startTime, "Validation: After starttime"); 
103         _;
104     }
105 
106     modifier saleNotClosed(){
107         require (!saleClosed, "Sale is not yet ended"); 
108         _;
109     }
110 
111     modifier nonReentrant() {
112         require(!rentrancy_lock, "Validation: Reentrancy");
113         rentrancy_lock = true;
114         _;
115         rentrancy_lock = false;
116     }
117 
118     /**
119     * @dev Modifier to make a function callable only when the contract is not paused.
120     */
121     modifier whenNotPaused() {
122         require(!paused, "You are not allowed to access this time.");
123         _;
124     }
125 
126     /**
127     * @dev Modifier to make a function callable only when the contract is paused.
128     */
129     modifier whenPaused() {
130         require(paused, "You are not allowed to access this time.");
131         _;
132     }
133 
134     constructor() public{
135         owner = msg.sender;
136     }
137 
138     /**
139     * @dev Allows the current owner to transfer control of the contract to a newOwner.
140     * @param _newOwner The address to transfer ownership to.
141     */
142     function transferOwnership(address _newOwner) public onlyOwner {
143         _transferOwnership(_newOwner);
144     }
145 
146     /**
147     * @dev Transfers control of the contract to a newOwner.
148     * @param _newOwner The address to transfer ownership to.
149     */
150     function _transferOwnership(address _newOwner) internal {
151         require(_newOwner != address(0), "Owner cannot be 0 address.");
152         emit OwnershipTransferred(owner, _newOwner);
153         owner = _newOwner;
154     }
155 
156     /**
157     * @dev called by the owner to pause, triggers stopped state
158     */
159     function pause() public onlyOwnerOrManager whenNotPaused {
160         paused = true;
161         emit Pause();
162     }
163 
164     /**
165     * @dev called by the owner to unpause, returns to normal state
166     */
167     function unpause() public onlyOwnerOrManager whenPaused {
168         paused = false;
169         emit Unpause();
170     }
171 
172     /**
173      * Returns the current time.
174      * Useful to abstract calls to "now" for tests.
175     */
176     function currentTime() public view returns (uint _currentTime) {
177         return block.timestamp;
178     }
179 
180     /**
181      * The owner can terminate the crowdsale at any time.
182      */
183     function terminate() external onlyOwnerOrManager {
184         saleClosed = true;
185     }
186 
187     /**
188      * The owner can update the rate (CHP to ETH).
189      *
190      * @param _rate  the new rate for converting CHP to ETH
191      */
192     function setRate(uint _rate) public onlyOwnerOrManager {
193         //require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
194         rate = _rate;
195     }
196 
197     /**
198      * The owner can unlock the fund with this function. The use-
199      * case for this is when the owner decides after the deadline
200      * to allow contributors to be refunded their contributions.
201      * Note that the fund would be automatically unlocked if the
202      * minimum funding goal were not reached.
203      */
204     function ownerUnlockFund() external afterDeadline onlyOwner {
205         fundingGoalReached = false;
206     }
207 
208     /**
209      * Checks if the funding goal has been reached. If it has, then
210      * the GoalReached event is triggered.
211      */
212     function checkFundingGoal() internal {
213         if (!fundingGoalReached) {
214             if (amountRaised >= fundingGoal) {
215                 fundingGoalReached = true;
216                 emit GoalReached(beneficiary, amountRaised);
217             }
218         }
219     }
220 
221     /**
222      * Checks if the funding cap has been reached. If it has, then
223      * the CapReached event is triggered.
224      */
225     function checkFundingCap() internal {
226         if (!fundingCapReached) {
227             if (amountRaised >= fundingCap) {
228                 fundingCapReached = true;
229                 saleClosed = true;
230                 emit CapReached(beneficiary, amountRaised);
231             }
232         }
233     }
234 
235     /**
236      * These helper functions are exposed for changing the start and end time dynamically   
237      */
238     function changeStartTime(uint256 _startTime) external onlyOwnerOrManager {startTime = _startTime;}
239     function changeEndTime(uint256 _endTime) external onlyOwnerOrManager {endTime = _endTime;}
240     function changeMinContribution(uint256 _newValue) external onlyOwnerOrManager {minContribution = _newValue * (10 ** decimals);}
241 }
242 
243 
244 
245 
246 
247 
248 contract BaseLBSCToken {
249     using SafeMath for uint256;
250 
251     // Globals
252     address public owner;
253     mapping(address => uint256) internal balances;
254     mapping (address => mapping (address => uint256)) internal allowed;
255     uint256 internal totalSupply_;
256 
257     // Events
258     event Transfer(address indexed from, address indexed to, uint256 value);
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260     event Burn(address indexed burner, uint256 value);
261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262     event Mint(address indexed to, uint256 amount);
263 
264     // Modifiers
265     modifier onlyOwner() {
266         require(msg.sender == owner,"Only the owner is allowed to call this."); 
267         _; 
268     }
269 
270     constructor() public{
271         owner = msg.sender;
272     }
273 
274     /**
275     * @dev Total number of tokens in existence
276     */
277     function totalSupply() public view returns (uint256) {
278         return totalSupply_;
279     }
280 
281     /**
282     * @dev Transfer token for a specified address
283     * @param _to The address to transfer to.
284     * @param _value The amount to be transferred.
285     */
286     function transfer(address _to, uint256 _value) public returns (bool) {
287         require(_value <= balances[msg.sender], "You do not have sufficient balance.");
288         require(_to != address(0), "You cannot send tokens to 0 address");
289 
290         balances[msg.sender] = balances[msg.sender].sub(_value);
291         balances[_to] = balances[_to].add(_value);
292         emit Transfer(msg.sender, _to, _value);
293         return true;
294     }
295 
296     /**
297     * @dev Gets the balance of the specified address.
298     * @param _owner The address to query the the balance of.
299     * @return An uint256 representing the amount owned by the passed address.
300     */
301     function balanceOf(address _owner) public view returns (uint256) {
302         return balances[_owner];
303     }
304 
305     /**
306     * @dev Transfer tokens from one address to another
307     * @param _from address The address which you want to send tokens from
308     * @param _to address The address which you want to transfer to
309     * @param _value uint256 the amount of tokens to be transferred
310     */
311     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
312         require(_value <= balances[_from], "You do not have sufficient balance.");
313         require(_value <= allowed[_from][msg.sender], "You do not have allowance.");
314         require(_to != address(0), "You cannot send tokens to 0 address");
315 
316         balances[_from] = balances[_from].sub(_value);
317         balances[_to] = balances[_to].add(_value);
318         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
319         emit Transfer(_from, _to, _value);
320         return true;
321     }
322 
323     /**
324     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
325     * Beware that changing an allowance with this method brings the risk that someone may use both the old
326     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
327     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
328     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
329     * @param _spender The address which will spend the funds.
330     * @param _value The amount of tokens to be spent.
331     */
332     function approve(address _spender, uint256 _value) public returns (bool) {
333         allowed[msg.sender][_spender] = _value;
334         emit Approval(msg.sender, _spender, _value);
335         return true;
336     }
337 
338     /**
339     * @dev Function to check the amount of tokens that an owner allowed to a spender.
340     * @param _owner address The address which owns the funds.
341     * @param _spender address The address which will spend the funds.
342     * @return A uint256 specifying the amount of tokens still available for the spender.
343     */
344     function allowance(address _owner, address _spender) public view returns (uint256){
345         return allowed[_owner][_spender];
346     }
347 
348     /**
349     * @dev Increase the amount of tokens that an owner allowed to a spender.
350     * approve should be called when allowed[_spender] == 0. To increment
351     * allowed value is better to use this function to avoid 2 calls (and wait until
352     * the first transaction is mined)
353     * From MonolithDAO Token.sol
354     * @param _spender The address which will spend the funds.
355     * @param _addedValue The amount of tokens to increase the allowance by.
356     */
357     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool){
358         allowed[msg.sender][_spender] = (
359         allowed[msg.sender][_spender].add(_addedValue));
360         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361         return true;
362     }
363 
364     /**
365     * @dev Decrease the amount of tokens that an owner allowed to a spender.
366     * approve should be called when allowed[_spender] == 0. To decrement
367     * allowed value is better to use this function to avoid 2 calls (and wait until
368     * the first transaction is mined)
369     * From MonolithDAO Token.sol
370     * @param _spender The address which will spend the funds.
371     * @param _subtractedValue The amount of tokens to decrease the allowance by.
372     */
373     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool){
374         uint256 oldValue = allowed[msg.sender][_spender];
375         if (_subtractedValue >= oldValue) {
376             allowed[msg.sender][_spender] = 0;
377         } else {
378             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
379         }
380         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
381         return true;
382     }
383 
384     /**
385     * @dev Burns a specific amount of tokens.
386     * @param _value The amount of token to be burned.
387     */
388     function burn(uint256 _value) public {
389         _burn(msg.sender, _value);
390     }
391 
392     function _burn(address _who, uint256 _value) internal {
393         require(_value <= balances[_who], "Insufficient balance of tokens");
394         // no need to require value <= totalSupply, since that would imply the
395         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
396 
397         balances[_who] = balances[_who].sub(_value);
398         totalSupply_ = totalSupply_.sub(_value);
399         emit Burn(_who, _value);
400         emit Transfer(_who, address(0), _value);
401     }
402 
403     /**
404     * @dev Burns a specific amount of tokens from the target address and decrements allowance
405     * @param _from address The address which you want to send tokens from
406     * @param _value uint256 The amount of token to be burned
407     */
408     function burnFrom(address _from, uint256 _value) public {
409         require(_value <= allowed[_from][msg.sender], "Insufficient allowance to burn tokens.");
410         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
411         _burn(_from, _value);
412     }
413 
414     /**
415     * @dev Allows the current owner to transfer control of the contract to a newOwner.
416     * @param _newOwner The address to transfer ownership to.
417     */
418     function transferOwnership(address _newOwner) public onlyOwner {
419         _transferOwnership(_newOwner);
420     }
421 
422     /**
423     * @dev Transfers control of the contract to a newOwner.
424     * @param _newOwner The address to transfer ownership to.
425     */
426     function _transferOwnership(address _newOwner) internal {
427         require(_newOwner != address(0), "Owner cannot be 0 address.");
428         emit OwnershipTransferred(owner, _newOwner);
429         owner = _newOwner;
430     }
431 
432 }
433 
434 contract LBSCToken is BaseLBSCToken {
435     
436     // Constants
437     string  public constant name = "LabelsCoin";
438     string  public constant symbol = "LBSC";
439     uint8   public constant decimals = 18;
440 
441     uint256 public constant INITIAL_SUPPLY      =  30000000 * (10 ** uint256(decimals));
442     //uint256 public constant CROWDSALE_ALLOWANCE =  1000000000 * (10 ** uint256(decimals));
443     uint256 public constant ADMIN_ALLOWANCE     =  30000000 * (10 ** uint256(decimals));
444     
445     // Properties
446     //uint256 public totalSupply;
447     //uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
448     uint256 public adminAllowance;          // the number of tokens available for the administrator
449     //address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
450     address public adminAddr;               // the address of a crowdsale currently selling this token
451     //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
452     bool    public transferEnabled = true;  // Enables everyone to transfer tokens
453 
454     /**
455      * The listed addresses are not valid recipients of tokens.
456      *
457      * 0x0           - the zero address is not valid
458      * this          - the contract itself should not receive tokens
459      * owner         - the owner has all the initial tokens, but cannot receive any back
460      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
461      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
462      */
463     modifier validDestination(address _to) {
464         require(_to != address(0x0), "Cannot send to 0 address");
465         require(_to != address(this), "Cannot send to contract address");
466         //require(_to != owner, "Cannot send to the owner");
467         //require(_to != address(adminAddr), "Cannot send to admin address");
468         //require(_to != address(crowdSaleAddr), "Cannot send to crowdsale address");
469         _;
470     }
471 
472     constructor(address _admin) public {
473         require(msg.sender != _admin, "Owner and admin cannot be the same");
474 
475         totalSupply_ = INITIAL_SUPPLY;
476         adminAllowance = ADMIN_ALLOWANCE;
477 
478         // mint all tokens
479         //balances[msg.sender] = totalSupply_.sub(adminAllowance);
480         //emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));
481 
482         balances[_admin] = adminAllowance;
483         emit Transfer(address(0x0), _admin, adminAllowance);
484 
485         adminAddr = _admin;
486         approve(adminAddr, adminAllowance);
487     }
488 
489     /**
490      * Overrides ERC20 transfer function with modifier that prevents the
491      * ability to transfer tokens until after transfers have been enabled.
492      */
493     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
494         return super.transfer(_to, _value);
495     }
496 
497     /**
498      * Overrides ERC20 transferFrom function with modifier that prevents the
499      * ability to transfer tokens until after transfers have been enabled.
500      */
501     function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
502         bool result = super.transferFrom(_from, _to, _value);
503         if (result) {
504             if (msg.sender == adminAddr)
505                 adminAllowance = adminAllowance.sub(_value);
506         }
507         return result;
508     }
509 }
510 
511 contract LBSCSale is BaseLBSCSale {
512     using SafeMath for uint256;
513 
514     // The token being sold
515     LBSCToken public tokenReward;
516 
517     mapping(address => bool) public approvedUsers;
518 
519     /**
520      * Constructor for a crowdsale of CHPToken tokens.
521      *
522      * @param ifSuccessfulSendTo            the beneficiary of the fund
523      * @param fundingGoalInEthers           the minimum goal to be reached
524      * @param fundingCapInEthers            the cap (maximum) size of the fund
525      * @param minimumContribution           Minimum contribution to participate in the crowdsale
526      * @param start                         the start time (UNIX timestamp)
527      * @param end                           the end time (UNIX timestamp)
528      * @param rateLBSCToEther                 the conversion rate from LBSC to Ether
529      * @param addressOfTokenUsedAsReward    address of the token being sold
530      * @param _manager                      Address that will manage the crowdsale 
531      */
532     constructor(
533         address ifSuccessfulSendTo,
534         uint fundingGoalInEthers,
535         uint fundingCapInEthers,
536         uint minimumContribution,
537         uint start,
538         uint end,
539         uint rateLBSCToEther,
540         address addressOfTokenUsedAsReward,
541         address _manager
542     ) public {
543         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this), "Beneficiary cannot be 0 address");
544         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this), "Token address cannot be 0 address");
545         require(fundingGoalInEthers <= fundingCapInEthers, "Funding goal should be less that funding cap.");
546         require(end > 0, "Endtime cannot be 0");
547         beneficiary = ifSuccessfulSendTo;
548         fundingGoal = fundingGoalInEthers;
549         fundingCap = fundingCapInEthers;
550         minContribution = minimumContribution;
551         startTime = start;
552         endTime = end; // TODO double check
553         rate = rateLBSCToEther;
554         tokenReward = LBSCToken(addressOfTokenUsedAsReward);
555         manager = _manager;
556         decimals = tokenReward.decimals();
557     }
558 
559     /**
560      * This fallback function is called whenever Ether is sent to the
561      * smart contract. It can only be executed when the crowdsale is
562      * not paused, not closed, and before the deadline has been reached.
563      *
564      * This function will update state variables for whether or not the
565      * funding goal or cap have been reached. It also ensures that the
566      * tokens are transferred to the sender, and that the correct
567      * number of tokens are sent according to the current rate.
568      */
569     function () public payable whenNotPaused beforeDeadline afterStartTime saleNotClosed nonReentrant {
570         require(msg.value >= minContribution, "Value should be greater than minimum contribution");
571         require(isApprovedUser(msg.sender), "Only the approved users are allowed to participate in ICO");
572         
573         // Update the sender's balance of wei contributed and the amount raised
574         uint amount = msg.value;
575         uint currentBalance = balanceOf[msg.sender];
576         balanceOf[msg.sender] = currentBalance.add(amount);
577         amountRaised = amountRaised.add(amount);
578 
579         // Compute the number of tokens to be rewarded to the sender
580         // Note: it's important for this calculation that both wei
581         // and CHP have the same number of decimal places (18)
582         uint numTokens = amount.mul(rate);
583 
584         // Transfer the tokens from the crowdsale supply to the sender
585         if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
586             emit FundTransfer(msg.sender, amount, true);
587             //contributions[msg.sender] = contributions[msg.sender].add(amount);
588             // Following code is to automatically transfer ETH to beneficiary
589             //uint balanceToSend = this.balance;
590             //beneficiary.transfer(balanceToSend);
591             //FundTransfer(beneficiary, balanceToSend, false);
592             // Check if the funding goal or cap have been reached
593             // TODO check impact on gas cost
594             checkFundingGoal();
595             checkFundingCap();
596         }
597         else {
598             revert("Transaction Failed. Please try again later.");
599         }
600     }
601 
602     /**
603      * The owner can allocate the specified amount of tokens from the
604      * crowdsale allowance to the recipient (_to).
605      *
606      * NOTE: be extremely careful to get the amounts correct, which
607      * are in units of wei and mini-LBSC. Every digit counts.
608      *
609      * @param _to            the recipient of the tokens
610      * @param amountInEth     the amount contributed in wei
611      * @param amountLBSC the amount of tokens transferred in mini-LBSC (18 decimals)
612      */
613     function ownerAllocateTokens(address _to, uint amountInEth, uint amountLBSC) public
614             onlyOwnerOrManager nonReentrant
615     {
616         if (!tokenReward.transferFrom(tokenReward.owner(), _to, convertToMini(amountLBSC))) {
617             revert("Transfer failed. Please check allowance");
618         }
619 
620         uint amountWei = convertToMini(amountInEth);
621         balanceOf[_to] = balanceOf[_to].add(amountWei);
622         amountRaised = amountRaised.add(amountWei);
623         emit FundTransfer(_to, amountWei, true);
624         checkFundingGoal();
625         checkFundingCap();
626     }
627 
628     /**
629      * The owner can call this function to withdraw the funds that
630      * have been sent to this contract for the crowdsale subject to
631      * the funding goal having been reached. The funds will be sent
632      * to the beneficiary specified when the crowdsale was created.
633      */
634     function ownerSafeWithdrawal() public onlyOwner nonReentrant {
635         require(fundingGoalReached, "Check funding goal");
636         uint balanceToSend = address(this).balance;
637         beneficiary.transfer(balanceToSend);
638         emit FundTransfer(beneficiary, balanceToSend, false);
639     }
640 
641     /**
642      * This function permits anybody to withdraw the funds they have
643      * contributed if and only if the deadline has passed and the
644      * funding goal was not reached.
645      */
646     function safeWithdrawal() public afterDeadline nonReentrant {
647         if (!fundingGoalReached) {
648             uint amount = balanceOf[msg.sender];
649             balanceOf[msg.sender] = 0;
650             if (amount > 0) {
651                 msg.sender.transfer(amount);
652                 emit FundTransfer(msg.sender, amount, false);
653                 refundAmount = refundAmount.add(amount);
654             }
655         }
656     }
657     
658     function convertToMini(uint amount) internal view returns (uint) {
659         return amount * (10 ** decimals);
660     }
661 
662     function approveUser(address _address) external onlyOwnerOrManager {
663         approvedUsers[_address] = true;
664     }
665 
666     function disapproveUser(address _address) external onlyOwnerOrManager {
667         approvedUsers[_address] = false;
668     }
669 
670     function changeManager(address _manager) external onlyOwnerOrManager {
671         manager = _manager;
672     }
673 
674     function isApprovedUser(address _address) internal view returns (bool) {
675         return approvedUsers[_address];
676     }
677 
678     function changeTokenAddress(address _address) external onlyOwnerOrManager {
679         tokenReward = LBSCToken(_address);
680     }
681 }