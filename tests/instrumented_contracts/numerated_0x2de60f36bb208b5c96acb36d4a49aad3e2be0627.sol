1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract Pausable is Ownable {
67   event Pause();
68   event Unpause();
69 
70   bool public paused = false;
71 
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is not paused.
75    */
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is paused.
83    */
84   modifier whenPaused() {
85     require(paused);
86     _;
87   }
88 
89   /**
90    * @dev called by the owner to pause, triggers stopped state
91    */
92   function pause() onlyOwner whenNotPaused public {
93     paused = true;
94     Pause();
95   }
96 
97   /**
98    * @dev called by the owner to unpause, returns to normal state
99    */
100   function unpause() onlyOwner whenPaused public {
101     paused = false;
102     Unpause();
103   }
104 }
105 
106 contract GJCICO is Pausable{
107   using SafeMath for uint256;
108 
109   //Gas/GWei
110   uint constant public minContribAmount = 0.01 ether;
111 
112   // The token being sold
113   GJCToken public token;
114   uint256 constant public tokenDecimals = 18;
115 
116   // The vesting contract
117   TokenVesting public vesting;
118   uint256 constant public VESTING_TIMES = 4;
119   uint256 constant public DURATION_PER_VESTING = 52 weeks;
120 
121   // start and end timestamps where investments are allowed (both inclusive)
122   uint256 public startTime;
123   uint256 public endTime;
124 
125   // need to be enabled to allow investor to participate in the ico
126   bool public icoEnabled;
127 
128   // address where funds are collected
129   address public multisignWallet;
130 
131   // amount of raised money in wei
132   uint256 public weiRaised;
133 
134   // totalSupply
135   uint256 constant public totalSupply = 100000000 * (10 ** tokenDecimals);
136   //pre sale cap
137   uint256 constant public preSaleCap = 10000000 * (10 ** tokenDecimals);
138   //sale cap
139   uint256 constant public initialICOCap = 60000000 * (10 ** tokenDecimals);
140   //founder share
141   uint256 constant public tokensForFounder = 10000000 * (10 ** tokenDecimals);
142   //dev team share
143   uint256 constant public tokensForDevteam = 10000000 * (10 ** tokenDecimals);
144   //Partners share
145   uint256 constant public tokensForPartners = 5000000 * (10 ** tokenDecimals);
146   //Charity share
147   uint256 constant public tokensForCharity = 3000000 * (10 ** tokenDecimals);
148   //Bounty share
149   uint256 constant public tokensForBounty = 2000000 * (10 ** tokenDecimals);
150     
151   //Sold presale tokens
152   uint256 public soldPreSaleTokens; 
153   uint256 public sentPreSaleTokens;
154 
155   //ICO tokens
156   //Is calcluated as: initialICOCap + preSaleCap - soldPreSaleTokens
157   uint256 public icoCap; 
158   uint256 public icoSoldTokens; 
159   bool public icoEnded = false;
160 
161   //Sale rates
162   uint256 constant public RATE_FOR_WEEK1 = 525;
163   uint256 constant public RATE_FOR_WEEK2 = 455;
164   uint256 constant public RATE_FOR_WEEK3 = 420;
165   uint256 constant public RATE_NO_DISCOUNT = 350;
166 
167 
168   /**
169    * event for token purchase logging
170    * @param purchaser who paid for the tokens
171    * @param beneficiary who got the tokens
172    * @param value weis paid for purchase
173    * @param amount amount of tokens purchased
174    */ 
175   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
176 
177 
178   function GJCICO(address _multisignWallet) {
179     require(_multisignWallet != address(0));
180     token = createTokenContract();
181     //send all dao tokens to multiwallet
182     uint256 tokensToDao = tokensForDevteam.add(tokensForPartners).add(tokensForBounty).add(tokensForCharity);
183     multisignWallet = _multisignWallet;
184     token.transfer(multisignWallet, tokensToDao);
185   }
186 
187   function createVestingForFounder(address founderAddress) external onlyOwner(){
188     require(founderAddress != address(0));
189     //create only once
190     require(address(vesting) == address(0));
191     vesting = createTokenVestingContract(address(token));
192     // create vesting schema for founders from now, total token amount is divided in 4 periods of 12 months each
193     vesting.createVestingByDurationAndSplits(founderAddress, tokensForFounder, now, DURATION_PER_VESTING, VESTING_TIMES);
194     //send tokens to vesting contracts
195     token.transfer(address(vesting), tokensForFounder);
196   }
197 
198   //
199   // Token related operations
200   //
201 
202   // creates the token to be sold. 
203   
204   function createTokenContract() internal returns (GJCToken) {
205     return new GJCToken();
206   }
207 
208   // creates the token to be sold.
209   // override this method to have crowdsale of a specific mintable token.
210   function createTokenVestingContract(address tokenAddress) internal returns (TokenVesting) {
211     require(address(token) != address(0));
212     return new TokenVesting(tokenAddress);
213   }
214 
215 
216   // enable token tranferability
217   function enableTokenTransferability() external onlyOwner {
218     require(token != address(0));
219     token.unpause(); 
220   }
221 
222   // disable token tranferability
223   function disableTokenTransferability() external onlyOwner {
224     require(token != address(0));
225     token.pause(); 
226   }
227 
228 
229   //
230   // Presale related operations
231   //
232 
233   // set total pre sale sold token
234   // can not be changed once the ico is enabled
235   // Ico cap is determined by SaleCap + PreSaleCap - soldPreSaleTokens 
236   function setSoldPreSaleTokens(uint256 _soldPreSaleTokens) external onlyOwner{
237     require(!icoEnabled);
238     require(_soldPreSaleTokens <= preSaleCap);
239     soldPreSaleTokens = _soldPreSaleTokens;
240   }
241 
242   // transfer pre sale tokend to investors
243   // soldPreSaleTokens need to be set beforehand, and bigger than 0
244   // the total amount to tranfered need to be less or equal to soldPreSaleTokens 
245   function transferPreSaleTokens(uint256 tokens, address beneficiary) external onlyOwner {
246     require(beneficiary != address(0));
247     require(soldPreSaleTokens > 0);
248     uint256 newSentPreSaleTokens = sentPreSaleTokens.add(tokens);
249     require(newSentPreSaleTokens <= soldPreSaleTokens);
250     sentPreSaleTokens = newSentPreSaleTokens;
251     token.transfer(beneficiary, tokens);
252   }
253 
254 
255   //
256   // ICO related operations
257   //
258 
259   // set multisign wallet
260   function setMultisignWallet(address _multisignWallet) external onlyOwner{
261     // need to be set before the ico start
262     require(!icoEnabled || now < startTime);
263     require(_multisignWallet != address(0));
264     multisignWallet = _multisignWallet;
265   }
266 
267   // delegate vesting contract owner
268   function delegateVestingContractOwner(address newOwner) external onlyOwner{
269     vesting.transferOwnership(newOwner);
270   }
271 
272   // set contribution dates
273   function setContributionDates(uint256 _startTime, uint256 _endTime) external onlyOwner{
274     require(!icoEnabled);
275     require(_startTime >= now);
276     require(_endTime >= _startTime);
277     startTime = _startTime;
278     endTime = _endTime;
279   }
280 
281   // enable ICO, need to be true to actually start ico
282   // multisign wallet need to be set, because once ico started, invested funds is transfered to this address
283   // once ico is enabled, following parameters can not be changed anymore:
284   // startTime, endTime, soldPreSaleTokens
285   function enableICO() external onlyOwner{
286     require(startTime >= now);
287 
288     require(multisignWallet != address(0));
289     icoEnabled = true;
290     icoCap = initialICOCap.add(preSaleCap).sub(soldPreSaleTokens);
291   }
292 
293 
294   // fallback function can be used to buy tokens
295   function () payable whenNotPaused {
296     buyTokens(msg.sender);
297   }
298 
299   // low level token purchase function
300   function buyTokens(address beneficiary) public payable whenNotPaused {
301     require(beneficiary != address(0));
302     require(validPurchase());
303 
304     uint256 weiAmount = msg.value;
305     uint256 returnWeiAmount;
306 
307     // calculate token amount to be created
308     uint rate = getRate();
309     assert(rate > 0);
310     uint256 tokens = weiAmount.mul(rate);
311 
312     uint256 newIcoSoldTokens = icoSoldTokens.add(tokens);
313 
314     if (newIcoSoldTokens > icoCap) {
315         newIcoSoldTokens = icoCap;
316         tokens = icoCap.sub(icoSoldTokens);
317         uint256 newWeiAmount = tokens.div(rate);
318         returnWeiAmount = weiAmount.sub(newWeiAmount);
319         weiAmount = newWeiAmount;
320     }
321 
322     // update state
323     weiRaised = weiRaised.add(weiAmount);
324 
325     token.transfer(beneficiary, tokens);
326     icoSoldTokens = newIcoSoldTokens;
327     if (returnWeiAmount > 0){
328         msg.sender.transfer(returnWeiAmount);
329     }
330 
331     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
332 
333     forwardFunds();
334   }
335 
336   // send ether to the fund collection wallet
337   
338   function forwardFunds() internal {
339     multisignWallet.transfer(this.balance);
340   }
341 
342   // unsold ico tokens transfer automatically in endIco
343   // function transferUnsoldIcoTokens() onlyOwner {
344   // require(hasEnded());
345   // require(icoSoldTokens < icoCap);
346   // uint256 unsoldTokens = icoCap.sub(icoSoldTokens);
347   // token.transfer(multisignWallet, unsoldTokens);
348   //}
349 
350   // @return true if the transaction can buy tokens
351   function validPurchase() internal constant returns (bool) {
352     bool withinPeriod = now >= startTime && now <= endTime;
353     bool nonMinimumPurchase = msg.value >= minContribAmount;
354     bool icoTokensAvailable = icoSoldTokens < icoCap;
355     return !icoEnded && icoEnabled && withinPeriod && nonMinimumPurchase && icoTokensAvailable;
356   }
357 
358   // end ico by owner, not really needed in normal situation
359   function endIco() external onlyOwner {
360     require(!icoEnded);
361     icoEnded = true;
362     // send unsold tokens to multi-sign wallet
363     uint256 unsoldTokens = icoCap.sub(icoSoldTokens);
364     token.transfer(multisignWallet, unsoldTokens);
365   }
366 
367   // @return true if crowdsale event has ended
368   function hasEnded() public constant returns (bool) {
369     return (icoEnded || icoSoldTokens >= icoCap || now > endTime);
370   }
371 
372 
373   function getRate() public constant returns(uint){
374     require(now >= startTime);
375     if (now < startTime.add(1 weeks)){
376       // week 1
377       return RATE_FOR_WEEK1;
378     }else if (now < startTime.add(2 weeks)){
379       // week 2
380       return RATE_FOR_WEEK2;
381     }else if (now < startTime.add(3 weeks)){
382       // week 3
383       return RATE_FOR_WEEK3;
384     }else if (now < endTime){
385       // no discount
386       return RATE_NO_DISCOUNT;
387     }
388     return 0;
389   }
390 
391   // drain all eth for owner in an emergency situation
392   function drain() external onlyOwner {
393     owner.transfer(this.balance);
394   }
395 }
396 
397 contract ERC20Basic {
398   uint256 public totalSupply;
399   function balanceOf(address who) public constant returns (uint256);
400   function transfer(address to, uint256 value) public returns (bool);
401   event Transfer(address indexed from, address indexed to, uint256 value);
402 }
403 
404 contract BasicToken is ERC20Basic {
405   using SafeMath for uint256;
406 
407   mapping(address => uint256) balances;
408 
409   /**
410   * @dev transfer token for a specified address
411   * @param _to The address to transfer to.
412   * @param _value The amount to be transferred.
413   */
414   function transfer(address _to, uint256 _value) public returns (bool) {
415     require(_to != address(0));
416     require(_value <= balances[msg.sender]);
417 
418     // SafeMath.sub will throw if there is not enough balance.
419     balances[msg.sender] = balances[msg.sender].sub(_value);
420     balances[_to] = balances[_to].add(_value);
421     Transfer(msg.sender, _to, _value);
422     return true;
423   }
424 
425   /**
426   * @dev Gets the balance of the specified address.
427   * @param _owner The address to query the the balance of.
428   * @return An uint256 representing the amount owned by the passed address.
429   */
430   function balanceOf(address _owner) public constant returns (uint256 balance) {
431     return balances[_owner];
432   }
433 
434 }
435 
436 contract ERC20 is ERC20Basic {
437   function allowance(address owner, address spender) public constant returns (uint256);
438   function transferFrom(address from, address to, uint256 value) public returns (bool);
439   function approve(address spender, uint256 value) public returns (bool);
440   event Approval(address indexed owner, address indexed spender, uint256 value);
441 }
442 
443 library SafeERC20 {
444   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
445     assert(token.transfer(to, value));
446   }
447 
448   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
449     assert(token.transferFrom(from, to, value));
450   }
451 
452   function safeApprove(ERC20 token, address spender, uint256 value) internal {
453     assert(token.approve(spender, value));
454   }
455 }
456 
457 contract TokenVesting is Ownable {
458     using SafeMath for uint256;
459     using SafeERC20 for ERC20Basic;
460 
461     ERC20Basic token;
462     // vesting
463     mapping (address => uint256) totalVestedAmount;
464 
465     struct Vesting {
466         uint256 amount;
467         uint256 vestingDate;
468     }
469 
470     address[] accountKeys;
471     mapping (address => Vesting[]) public vestingAccounts;
472 
473     // events
474     event Vest(address indexed beneficiary, uint256 amount);
475     event VestingCreated(address indexed beneficiary, uint256 amount, uint256 vestingDate);
476 
477     // modifiers here
478     modifier tokenSet() {
479         require(address(token) != address(0));
480         _;
481     }
482 
483     // vesting constructor
484     function TokenVesting(address token_address){
485        require(token_address != address(0));
486        token = ERC20Basic(token_address);
487     }
488 
489     // set vesting token address
490     function setVestingToken(address token_address) external onlyOwner {
491         require(token_address != address(0));
492         token = ERC20Basic(token_address);
493     }
494 
495     // create vesting by introducing beneficiary addres, total token amount, start date, duration for each vest period and number of periods
496     function createVestingByDurationAndSplits(address user, uint256 total_amount, uint256 startDate, uint256 durationPerVesting, uint256 times) public onlyOwner tokenSet {
497         require(user != address(0));
498         require(startDate >= now);
499         require(times > 0);
500         require(durationPerVesting > 0);
501         uint256 vestingDate = startDate;
502         uint256 i;
503         uint256 amount = total_amount.div(times);
504         for (i = 0; i < times; i++) {
505             vestingDate = vestingDate.add(durationPerVesting);
506             if (vestingAccounts[user].length == 0){
507                 accountKeys.push(user);
508             }
509             vestingAccounts[user].push(Vesting(amount, vestingDate));
510             VestingCreated(user, amount, vestingDate);
511         }
512     }
513 
514     // get current user total granted token amount
515     function getVestingAmountByNow(address user) constant returns (uint256){
516         uint256 amount;
517         uint256 i;
518         for (i = 0; i < vestingAccounts[user].length; i++) {
519             if (vestingAccounts[user][i].vestingDate < now) {
520                 amount = amount.add(vestingAccounts[user][i].amount);
521             }
522         }
523 
524     }
525 
526     // get user available vesting amount, total amount - received amount
527     function getAvailableVestingAmount(address user) constant returns (uint256){
528         uint256 amount;
529         amount = getVestingAmountByNow(user);
530         amount = amount.sub(totalVestedAmount[user]);
531         return amount;
532     }
533 
534     // get list of vesting users address
535     function getAccountKeys(uint256 page) external constant returns (address[10]){
536         address[10] memory accountList;
537         uint256 i;
538         for (i=0 + page * 10; i<10; i++){
539             if (i < accountKeys.length){
540                 accountList[i - page * 10] = accountKeys[i];
541             }
542         }
543         return accountList;
544     }
545 
546     // vest
547     function vest() external tokenSet {
548         uint256 availableAmount = getAvailableVestingAmount(msg.sender);
549         require(availableAmount > 0);
550         totalVestedAmount[msg.sender] = totalVestedAmount[msg.sender].add(availableAmount);
551         token.transfer(msg.sender, availableAmount);
552         Vest(msg.sender, availableAmount);
553     }
554 
555     // drain all eth and tokens to owner in an emergency situation
556     function drain() external onlyOwner {
557         owner.transfer(this.balance);
558         token.transfer(owner, this.balance);
559     }
560 }
561 
562 contract StandardToken is ERC20, BasicToken {
563 
564   mapping (address => mapping (address => uint256)) internal allowed;
565 
566 
567   /**
568    * @dev Transfer tokens from one address to another
569    * @param _from address The address which you want to send tokens from
570    * @param _to address The address which you want to transfer to
571    * @param _value uint256 the amount of tokens to be transferred
572    */
573   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
574     require(_to != address(0));
575     require(_value <= balances[_from]);
576     require(_value <= allowed[_from][msg.sender]);
577 
578     balances[_from] = balances[_from].sub(_value);
579     balances[_to] = balances[_to].add(_value);
580     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
581     Transfer(_from, _to, _value);
582     return true;
583   }
584 
585   /**
586    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
587    *
588    * Beware that changing an allowance with this method brings the risk that someone may use both the old
589    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
590    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
591    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
592    * @param _spender The address which will spend the funds.
593    * @param _value The amount of tokens to be spent.
594    */
595   function approve(address _spender, uint256 _value) public returns (bool) {
596     allowed[msg.sender][_spender] = _value;
597     Approval(msg.sender, _spender, _value);
598     return true;
599   }
600 
601   /**
602    * @dev Function to check the amount of tokens that an owner allowed to a spender.
603    * @param _owner address The address which owns the funds.
604    * @param _spender address The address which will spend the funds.
605    * @return A uint256 specifying the amount of tokens still available for the spender.
606    */
607   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
608     return allowed[_owner][_spender];
609   }
610 
611   /**
612    * approve should be called when allowed[_spender] == 0. To increment
613    * allowed value is better to use this function to avoid 2 calls (and wait until
614    * the first transaction is mined)
615    * From MonolithDAO Token.sol
616    */
617   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
618     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
619     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
620     return true;
621   }
622 
623   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
624     uint oldValue = allowed[msg.sender][_spender];
625     if (_subtractedValue > oldValue) {
626       allowed[msg.sender][_spender] = 0;
627     } else {
628       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
629     }
630     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
631     return true;
632   }
633 
634 }
635 
636 contract PausableToken is StandardToken, Pausable {
637   /**
638    * @dev modifier to allow actions only when the contract is not paused or
639    * the sender is the owner of the contract
640    */
641   modifier whenNotPausedOrOwner() {
642     require(msg.sender == owner || !paused);
643     _;
644   }
645 
646   function transfer(address _to, uint256 _value) public whenNotPausedOrOwner returns (bool) {
647     return super.transfer(_to, _value);
648   }
649 
650   function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrOwner returns (bool) {
651     return super.transferFrom(_from, _to, _value);
652   }
653 
654   function approve(address _spender, uint256 _value) public whenNotPausedOrOwner returns (bool) {
655     return super.approve(_spender, _value);
656   }
657 
658   function increaseApproval(address _spender, uint _addedValue) public whenNotPausedOrOwner returns (bool success) {
659     return super.increaseApproval(_spender, _addedValue);
660   }
661 
662   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPausedOrOwner returns (bool success) {
663     return super.decreaseApproval(_spender, _subtractedValue);
664   }
665 }
666 
667 contract GJCToken is PausableToken {
668   string constant public name = "GJC";
669   string constant public symbol = "GJC";
670   uint256 constant public decimals = 18;
671   uint256 constant TOKEN_UNIT = 10 ** uint256(decimals);
672   uint256 constant INITIAL_SUPPLY = 100000000 * TOKEN_UNIT;
673 
674   function GJCToken() {
675     // Set untransferable by default to the token
676     paused = true;
677     // asign all tokens to the contract creator
678     totalSupply = INITIAL_SUPPLY;
679     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
680     balances[msg.sender] = INITIAL_SUPPLY;
681   }
682 }