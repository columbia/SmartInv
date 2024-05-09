1 pragma solidity 0.4.17;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address internal owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 /**
46  * @title ArtToujourICO
47  * @dev ArtToujourCrowdsale is a base contract for managing a token crowdsale.
48  * Crowdsales have a start and end timestamps, where investors can make
49  * token purchases and the crowdsale will assign them ARTZ tokens based
50  * on a ARTZ token per ETH rate. Funds collected are forwarded to a wallet
51  * as they arrive.
52  */
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59   mapping(address => uint256) balances;
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public constant returns (uint256 balance) {
79     return balances[_owner];
80   }
81 }
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) public constant returns (uint256);
88   function transferFrom(address from, address to, uint256 value) public returns (bool);
89   function approve(address spender, uint256 value) public returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100   mapping (address => mapping (address => uint256)) allowed;
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amount of tokens to be transferred
106    */
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     uint256 _allowance = allowed[_from][msg.sender];
110     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111     // require (_value <= _allowance);
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118   /**
119    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
120    *
121    * Beware that changing an allowance with this method brings the risk that someone may use both the old
122    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
123    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
124    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128   function approve(address _spender, uint256 _value) public returns (bool) {
129     allowed[msg.sender][_spender] = _value;
130     Approval(msg.sender, _spender, _value);
131     return true;
132   }
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
140     return allowed[_owner][_spender];
141   }
142   /**
143    * approve should be called when allowed[_spender] == 0. To increment
144    * allowed value is better to use this function to avoid 2 calls (and wait until
145    * the first transaction is mined)
146    * From MonolithDAO Token.sol
147    */
148   function increaseApproval (address _spender, uint _addedValue)
149     returns (bool success) {
150     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154   function decreaseApproval (address _spender, uint _subtractedValue)
155     returns (bool success) {
156     uint oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 }
166 /**
167  * @title Mintable token
168  * @dev Simple ERC20 Token example, with mintable token creation
169  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
170  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
171  */
172 contract MintableToken is StandardToken, Ownable {
173   event Mint(address indexed to, uint256 amount);
174   event MintFinished();
175   bool public mintingFinished = false;
176   modifier canMint() {
177     require(!mintingFinished);
178     _;
179   }
180   /**
181    * @dev Function to mint tokens
182    * @param _to The address that will receive the minted tokens.
183    * @param _amount The amount of tokens to mint.
184    * @return A boolean that indicates if the operation was successful.
185    */
186   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
187     //totalSupply = totalSupply.add(_amount);
188     balances[_to] = balances[_to].add(_amount);
189     Mint(_to, _amount);
190     Transfer(msg.sender, _to, _amount);
191     return true;
192   }
193   /**
194    * @dev Function to stop minting new tokens.
195    * @return True if the operation was successful.
196    */
197   function finishMinting() onlyOwner public returns (bool) {
198     mintingFinished = true;
199     MintFinished();
200     return true;
201   }
202   function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {
203     totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);
204   }
205 }
206 /**
207  * @title Pausable
208  * @dev Base contract which allows children to implement an emergency stop mechanism.
209  */
210 contract Pausable is Ownable {
211   event Pause();
212   event Unpause();
213   bool public paused = false;
214   /**
215    * @dev Modifier to make a function callable only when the contract is not paused.
216    */
217   modifier whenNotPaused() {
218     require(!paused);
219     _;
220   }
221   /**
222    * @dev Modifier to make a function callable only when the contract is paused.
223    */
224   modifier whenPaused() {
225     require(paused);
226     _;
227   }
228   /**
229    * @dev called by the owner to pause, triggers stopped state
230    */
231   function pause() onlyOwner whenNotPaused public {
232     paused = true;
233     Pause();
234   }
235   /**
236    * @dev called by the owner to unpause, returns to normal state
237    */
238   function unpause() onlyOwner whenPaused public {
239     paused = false;
240     Unpause();
241   }
242 }
243 /**
244  * @title ArtToujour Crowdsale
245  * @dev Crowdsale is a base contract for managing a token crowdsale.
246  * Crowdsales have a start and end timestamps, where investors can make
247  * token purchases and the crowdsale will assign them tokens based
248  * on a token per ETH rate. Funds collected are forwarded to a wallet
249  * as they arrive.
250  */
251 contract Crowdsale is Ownable, Pausable {
252   using SafeMath for uint256;
253   /**
254    *  @MintableToken token - Token Object
255    *  @address wallet - Wallet Address
256    *  @uint8 rate - Tokens per Ether
257    *  @uint256 weiRaised - Total funds raised in Ethers
258   */
259   MintableToken internal token;
260   address internal wallet;
261   uint256 public rate;
262   uint256 internal weiRaised;
263   /**
264    *  @uint256 preSaleStartTime - Pre-Sale Start Time
265    *  @uint256 preSaleEndTime - Pre-Sale End Time
266    *  @uint256 preICOStartTime - Pre-ICO Start Time
267    *  @uint256 preICOEndTime - Pre-ICO End Time
268    *  @uint256 ICOstartTime - ICO Start Time
269    *  @uint256 ICOEndTime - ICO End Time
270   */
271   uint256 public preSaleStartTime;
272   uint256 public preSaleEndTime;
273   uint256 public preICOStartTime;
274   uint256 public preICOEndTime;
275   uint256 public ICOstartTime;
276   uint256 public ICOEndTime;
277   
278   /**
279    *  @uint preSaleBonus - Pre-Sale Start Time
280    *  @uint preICOBonus - Pre-Sale End Time
281    *  @uint firstWeekBonus - Pre-ICO Start Time
282    *  @uint secondWeekBonus - Pre-ICO End Time
283    *  @uint thirdWeekBonus - ICO Start Time
284   */
285   uint internal preSaleBonus;
286   uint internal preICOBonus;
287   uint internal firstWeekBonus;
288   uint internal secondWeekBonus;
289   uint internal thirdWeekBonus;
290   
291   /**
292    *  @uint256 weekOne - WeekOne Time 
293    *  @uint256 weekTwo - WeekTwo Time 
294    *  @uint256 weekThree - WeekThree Time 
295   */
296   uint256 internal weekOne;
297   uint256 internal weekTwo;
298   uint256 internal weekThree;
299   /**
300    *  @uint256 totalSupply - Total supply of tokens 
301    *  @uint256 publicSupply - Total public Supply 
302    *  @uint256 reserveSupply - Total Reserve Supply 
303    *  @uint256 bountySupply - Total Bounty Supply
304    *  @uint256 teamSupply - Total Team Supply divided by 4
305    *  @uint256 advisorSupply - Total Advisor Supply divided by 4
306    *  @uint256 founderSupply - Total Founder Supply divided by 4
307    *  @uint256 preSaleSupply - Total PreSale Supply from Public Supply 
308    *  @uint256 preICOSupply - Total PreICO Supply from Public Supply
309    *  @uint256 icoSupply - Total ICO Supply from Public Supply
310   */
311   uint256 public totalSupply = SafeMath.mul(700000000, 1 ether);
312   uint256 internal publicSupply = SafeMath.mul(SafeMath.div(totalSupply,100),50);
313   uint256 internal reserveSupply = SafeMath.mul(SafeMath.div(totalSupply,100),14);
314   uint256 internal teamSupply = SafeMath.div(SafeMath.mul(SafeMath.div(totalSupply,100),13),4);
315   uint256 internal advisorSupply = SafeMath.div(SafeMath.mul(SafeMath.div(totalSupply,100),3),4);
316   uint256 internal bountySupply = SafeMath.mul(SafeMath.div(totalSupply,100),5);
317   uint256 internal founderSupply = SafeMath.div(SafeMath.mul(SafeMath.div(totalSupply,100),15),4);
318   uint256 internal preSaleSupply = SafeMath.mul(SafeMath.div(totalSupply,100),2);
319   uint256 internal preICOSupply = SafeMath.mul(SafeMath.div(totalSupply,100),13);
320   uint256 internal icoSupply = SafeMath.mul(SafeMath.div(totalSupply,100),35);
321   /**
322    *  @uint256 advisorTimeLock - Advisor Timelock 
323    *  @uint256 founderTeamTimeLock - Founder and Team Timelock 
324   */
325   uint256 internal advisorTimeLock;
326   uint256 internal founderTeamTimeLock;
327   /**
328    *  @bool checkUnsoldTokens - 
329    *  @bool upgradePreICOSupply - Boolean variable updates when the PreSale tokens added to PreICO supply
330    *  @bool upgradeICOSupply - Boolean variable updates when the PreICO tokens added to ICO supply
331    *  @bool grantAdvisorSupply -  Boolean variable updates when Team tokens minted
332    *  @bool grantFounderTeamSupply - Boolean variable updates when Team and Founder tokens minted
333   */
334   bool internal checkUnsoldTokens;
335   bool internal upgradePreICOSupply;
336   bool internal upgradeICOSupply;
337   bool internal grantAdvisorSupply;
338   bool internal grantFounderTeamSupply;
339   /**
340    *  @uint vestedFounderTeamCheck - Variable count for vesting
341    *  @uint vestedAdvisorCheck - Variable count for vesting 
342   */
343   uint vestedFounderTeamCheck;
344   uint vestedAdvisorCheck;
345   /**
346    * event for token purchase logging
347    * @param purchaser who paid for the tokens
348    * @param beneficiary who got the tokens
349    * @param value Wei's paid for purchase
350    * @param amount amount of tokens purchased
351    */
352   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
353   /**
354    * function Crowdsale - Parameterized Constructor
355    * @param _startTime - StartTime of Crowdsale
356    * @param _endTime - EndTime of Crowdsale
357    * @param _rate - Tokens against Ether
358    * @param _wallet - MultiSignature Wallet Address
359    */
360   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) internal {
361     
362     require(_wallet != 0x0);
363     token = createTokenContract();
364     preSaleStartTime = _startTime;
365     preSaleEndTime = 1525352400;
366     preICOStartTime = preSaleEndTime;
367     preICOEndTime = 1528030800;
368     ICOstartTime = preICOEndTime;
369     ICOEndTime = _endTime;
370     rate = _rate;
371     wallet = _wallet;
372     preSaleBonus = SafeMath.div(SafeMath.mul(rate,40),100);
373     preICOBonus = SafeMath.div(SafeMath.mul(rate,30),100);
374     firstWeekBonus = SafeMath.div(SafeMath.mul(rate,20),100);
375     secondWeekBonus = SafeMath.div(SafeMath.mul(rate,15),100);
376     thirdWeekBonus = SafeMath.div(SafeMath.mul(rate,10),100);
377  
378     weekOne = SafeMath.add(ICOstartTime, 7 days);
379     weekTwo = SafeMath.add(weekOne, 7 days);
380     weekThree = SafeMath.add(weekTwo, 7 days);
381     advisorTimeLock = SafeMath.add(ICOEndTime, 180 days);
382     founderTeamTimeLock = SafeMath.add(ICOEndTime, 180 days);
383     checkUnsoldTokens = false;
384     upgradeICOSupply = false;
385     upgradePreICOSupply = false;
386     grantAdvisorSupply = false;
387     grantFounderTeamSupply = false;
388     vestedFounderTeamCheck = 0;
389     vestedAdvisorCheck = 0;
390     
391   }
392   /**
393    * function createTokenContract - Mintable Token Created
394    */
395   function createTokenContract() internal returns (MintableToken) {
396     return new MintableToken();
397   }
398   
399   /**
400    * function Fallback - Receives Ethers
401    */
402   function () payable {
403     buyTokens(msg.sender);
404   }
405   /**
406    * function preSaleTokens - Calculate Tokens in PreSale
407    */
408   function preSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
409         
410     require(preSaleSupply > 0);
411     tokens = SafeMath.add(tokens, weiAmount.mul(preSaleBonus));
412     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
413     require(preSaleSupply >= tokens);
414     preSaleSupply = preSaleSupply.sub(tokens);        
415     return tokens;
416   }
417   /**
418     * function preICOTokens - Calculate Tokens in PreICO
419     */
420   function preICOTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
421         
422     require(preICOSupply > 0);
423     if (!upgradePreICOSupply) {
424       preICOSupply = SafeMath.add(preICOSupply,preSaleSupply);
425       upgradePreICOSupply = true;
426     }
427     tokens = SafeMath.add(tokens, weiAmount.mul(preICOBonus));
428     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
429     
430     require(preICOSupply >= tokens);
431     
432     preICOSupply = preICOSupply.sub(tokens);        
433     return tokens;
434   }
435   /**
436    * function icoTokens - Calculate Tokens in ICO
437    */
438   
439   function icoTokens(uint256 weiAmount, uint256 tokens, uint256 accessTime) internal returns (uint256) {
440         
441     require(icoSupply > 0);
442     if (!upgradeICOSupply) {
443       icoSupply = SafeMath.add(icoSupply,preICOSupply);
444       upgradeICOSupply = true;
445     }
446     
447     if (accessTime <= weekOne) {
448       tokens = SafeMath.add(tokens, weiAmount.mul(firstWeekBonus));
449     } else if (accessTime <= weekTwo) {
450       tokens = SafeMath.add(tokens, weiAmount.mul(secondWeekBonus));
451     } else if ( accessTime < weekThree ) {
452       tokens = SafeMath.add(tokens, weiAmount.mul(thirdWeekBonus));
453     }
454     
455     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
456     icoSupply = icoSupply.sub(tokens);        
457     return tokens;
458   }
459   /**
460   * function buyTokens - Collect Ethers and transfer tokens
461   */
462   function buyTokens(address beneficiary) whenNotPaused public payable {
463     require(beneficiary != 0x0);
464     require(validPurchase());
465     uint256 accessTime = now;
466     uint256 tokens = 0;
467     uint256 weiAmount = msg.value;
468     require((weiAmount >= (100000000000000000)) && (weiAmount <= (25000000000000000000)));
469     if ((accessTime >= preSaleStartTime) && (accessTime < preSaleEndTime)) {
470       tokens = preSaleTokens(weiAmount, tokens);
471     } else if ((accessTime >= preICOStartTime) && (accessTime < preICOEndTime)) {
472       tokens = preICOTokens(weiAmount, tokens);
473     } else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) { 
474       tokens = icoTokens(weiAmount, tokens, accessTime);
475     } else {
476       revert();
477     }
478     
479     publicSupply = publicSupply.sub(tokens);
480     weiRaised = weiRaised.add(weiAmount);
481     token.mint(beneficiary, tokens);
482     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
483     forwardFunds();
484   }
485   /**
486    * function forwardFunds - Transfer funds to wallet
487    */
488   function forwardFunds() internal {
489     wallet.transfer(msg.value);
490   }
491   /**
492    * function validPurchase - Checks the purchase is valid or not
493    * @return true - Purchase is withPeriod and nonZero
494    */
495   function validPurchase() internal constant returns (bool) {
496     bool withinPeriod = now >= preSaleStartTime && now <= ICOEndTime;
497     bool nonZeroPurchase = msg.value != 0;
498     return withinPeriod && nonZeroPurchase;
499   }
500   /**
501    * function hasEnded - Checks the ICO ends or not
502    * @return true - ICO Ends
503    */
504   
505   function hasEnded() public constant returns (bool) {
506     return now > ICOEndTime;
507   }
508   /**
509    * function unsoldToken - Function used to transfer all 
510    *               unsold public tokens to reserve supply
511    */
512   function unsoldToken() onlyOwner public {
513     require(hasEnded());
514     require(!checkUnsoldTokens);
515     
516     checkUnsoldTokens = true;
517     reserveSupply = SafeMath.add(reserveSupply, publicSupply);
518     publicSupply = 0;
519   }
520   /** 
521    * function getTokenAddress - Get Token Address 
522    */
523   function getTokenAddress() onlyOwner public returns (address) {
524     return token;
525   }
526   /** 
527    * function getPublicSupply - Get Public Address 
528    */
529   function getPublicSupply() onlyOwner public returns (uint256) {
530     return publicSupply;
531   }
532 }
533 /**
534  * @title CappedCrowdsale
535  * @dev Extension of Crowdsale with a max amount of funds raised
536  */
537  
538 contract CappedCrowdsale is Crowdsale {
539   using SafeMath for uint256;
540   uint256 public cap;
541   function CappedCrowdsale(uint256 _cap) {
542     require(_cap > 0);
543     cap = _cap;
544   }
545   // overriding Crowdsale#validPurchase to add extra cap logic
546   // @return true if investors can buy at the moment
547   function validPurchase() internal constant returns (bool) {
548     bool withinCap = weiRaised.add(msg.value) <= cap;
549     return super.validPurchase() && withinCap;
550   }
551   // overriding Crowdsale#hasEnded to add cap logic
552   // @return true if crowdsale event has ended
553   function hasEnded() public constant returns (bool) {
554     bool capReached = weiRaised >= cap;
555     return super.hasEnded() || capReached;
556   }
557 }
558 /**
559  * @title FinalizableCrowdsale
560  * @dev Extension of Crowdsale where an owner can do extra work
561  * after finishing.
562  */
563 contract FinalizableCrowdsale is Crowdsale {
564   using SafeMath for uint256;
565   bool isFinalized = false;
566   event Finalized();
567   /**
568    * @dev Must be called after crowdsale ends, to do some extra finalization
569    * work. Calls the contract's finalization function.
570    */
571   function finalize() onlyOwner public {
572     require(!isFinalized);
573     require(hasEnded());
574     finalization();
575     Finalized();
576     isFinalized = true;
577   }
578   /**
579    * @dev Can be overridden to add finalization logic. The overriding function
580    * should call super.finalization() to ensure the chain of finalization is
581    * executed entirely.
582    */
583   function finalization() internal {
584   }
585 }
586 /**
587  * @title RefundVault
588  * @dev This contract is used for storing funds while a crowdsale
589  * is in progress. Supports refunding the money if crowdsale fails,
590  * and forwarding it if crowdsale is successful.
591  */
592 contract RefundVault is Ownable {
593   using SafeMath for uint256;
594   enum State { Active, Refunding, Closed }
595   mapping (address => uint256) public deposited;
596   address public wallet;
597   State public state;
598   event Closed();
599   event RefundsEnabled();
600   event Refunded(address indexed beneficiary, uint256 weiAmount);
601   function RefundVault(address _wallet) {
602     require(_wallet != 0x0);
603     wallet = _wallet;
604     state = State.Active;
605   }
606   function deposit(address investor) onlyOwner public payable {
607     require(state == State.Active);
608     deposited[investor] = deposited[investor].add(msg.value);
609   }
610   function close() onlyOwner public {
611     require(state == State.Active);
612     state = State.Closed;
613     Closed();
614     wallet.transfer(this.balance);
615   }
616   function enableRefunds() onlyOwner public {
617     require(state == State.Active);
618     state = State.Refunding;
619     RefundsEnabled();
620   }
621   function refund(address investor) public {
622     require(state == State.Refunding);
623     uint256 depositedValue = deposited[investor];
624     deposited[investor] = 0;
625     investor.transfer(depositedValue);
626     Refunded(investor, depositedValue);
627   }
628 }
629 /**
630  * @title RefundableCrowdsale
631  * @dev Extension of Crowdsale contract that adds a funding goal, and
632  * the possibility of users getting a refund if goal is not met.
633  * Uses a RefundVault as the crowdsale's vault.
634  */
635 contract RefundableCrowdsale is FinalizableCrowdsale {
636   using SafeMath for uint256;
637   // minimum amount of funds to be raised in weis
638   uint256 public goal;
639   bool private _goalReached = false;
640   // refund vault used to hold funds while crowdsale is running
641   RefundVault private vault;
642   function RefundableCrowdsale(uint256 _goal) {
643     require(_goal > 0);
644     vault = new RefundVault(wallet);
645     goal = _goal;
646   }
647   // We're overriding the fund forwarding from Crowdsale.
648   // In addition to sending the funds, we want to call
649   // the RefundVault deposit function
650   function forwardFunds() internal {
651     vault.deposit.value(msg.value)(msg.sender);
652   }
653   // if crowdsale is unsuccessful, investors can claim refunds here
654   function claimRefund() public {
655     require(isFinalized);
656     require(!goalReached());
657     vault.refund(msg.sender);
658   }
659   // vault finalization task, called when owner calls finalize()
660   function finalization() internal {
661     if (goalReached()) {
662       vault.close();
663     } else {
664       vault.enableRefunds();
665     }
666     super.finalization();
667   }
668   function goalReached() public constant returns (bool) {
669     if (weiRaised >= goal) {
670       _goalReached = true;
671       return true;
672     } else if (_goalReached) {
673       return true;
674     } 
675     else {
676       return false;
677     }
678   }
679   function updateGoalCheck() onlyOwner public {
680     _goalReached = true;
681   }
682   function getVaultAddress() onlyOwner public returns (address) {
683     return vault;
684   }
685 }
686 /**
687  * @title ArtToujourToken 
688  */
689  
690 contract ArtToujourToken is MintableToken {
691   /**
692    *  @string name - Token Name
693    *  @string symbol - Token Symbol
694    *  @uint8 decimals - Token Decimals
695    *  @uint256 _totalSupply - Token Total Supply
696   */
697   string public constant name = "ARISTON";
698   string public constant symbol = "ARTZ";
699   uint8 public constant decimals = 18;
700   uint256 public constant _totalSupply = 700000000 * 1 ether;
701   
702 /** Constructor ArtToujourToken */
703   function ArtToujourToken() {
704     totalSupply = _totalSupply;
705   }
706 }
707 /**
708  * @title SafeMath
709  * @dev Math operations with safety checks that throw on error
710  */
711 library SafeMath {
712   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
713     uint256 c = a * b;
714     assert(a == 0 || c / a == b);
715     return c;
716   }
717   function div(uint256 a, uint256 b) internal constant returns (uint256) {
718     // assert(b > 0); // Solidity automatically throws when dividing by 0
719     uint256 c = a / b;
720     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
721     return c;
722   }
723   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
724     assert(b <= a);
725     return a - b;
726   }
727   function add(uint256 a, uint256 b) internal constant returns (uint256) {
728     uint256 c = a + b;
729     assert(c >= a);
730     return c;
731   }
732 }
733 contract CrowdsaleFunctions is Crowdsale {
734  /** 
735   * function bountyFunds - Transfer bounty tokens via AirDrop
736   * @param beneficiary address where owner wants to transfer tokens
737   * @param tokens value of token
738   */
739   function bountyFunds(address[] beneficiary, uint256[] tokens) onlyOwner public {
740     for (uint256 i = 0; i < beneficiary.length; i++) {
741       tokens[i] = SafeMath.mul(tokens[i],1 ether); 
742       require(bountySupply >= tokens[i]);
743       bountySupply = SafeMath.sub(bountySupply,tokens[i]);
744       token.mint(beneficiary[i], tokens[i]);
745     }
746   }
747   /** 
748    * function reserveFunds - Transfer reserve tokens to wallet for future platform usage
749    */
750   function reserveFunds() onlyOwner public { 
751     require(reserveSupply > 0);
752     token.mint(0x3501C88dCEAC658014d6C4406E0D39e11a7e0340, reserveSupply);
753     reserveSupply = 0;
754   }
755   /** 
756   * function grantAdvisorToken - Transfer advisor tokens to advisor wallet 
757   */
758   function grantAdvisorToken() onlyOwner public {
759     require(!grantAdvisorSupply);
760     require(now > advisorTimeLock);
761     require(advisorSupply > 0);
762     
763     if (vestedAdvisorCheck < 4) {
764       vestedAdvisorCheck++;
765       advisorTimeLock = SafeMath.add(advisorTimeLock, 90 days);
766       token.mint(0x819acdf6731B51Dd7E68D5DfB6f602BBD8E62871, advisorSupply);
767   
768       if (vestedAdvisorCheck == 4) {
769         advisorSupply = 0;
770       }
771     }
772   }
773   /** 
774    * function grantFounderTeamToken - Transfer advisor tokens to Founder and Team wallets 
775    */
776   function grantFounderTeamToken() onlyOwner public {
777     require(!grantFounderTeamSupply);
778     require(now > founderTeamTimeLock);
779     require(founderSupply > 0);
780     
781     if (vestedFounderTeamCheck < 4) {
782        vestedFounderTeamCheck++;
783        founderTeamTimeLock = SafeMath.add(founderTeamTimeLock, 180 days);
784        token.mint(0x996f2959cE684B2cA221b9f0Da41899662220953, founderSupply);
785        token.mint(0x3c61fD8BDFf22C3Aa309f52793288CfB8A271325, teamSupply);
786        if (vestedFounderTeamCheck == 4) {
787           grantFounderTeamSupply = true;
788           founderSupply = 0;
789           teamSupply = 0;
790        }
791     }
792   }
793 /** 
794  *.function transferToken - Used to transfer tokens to investors who pays us other than Ethers
795  * @param beneficiary - Address where owner wants to transfer tokens
796  * @param tokens -  Number of tokens
797  */
798   function transferToken(address beneficiary, uint256 tokens) onlyOwner public {
799     require(publicSupply > 0);
800     tokens = SafeMath.mul(tokens,1 ether);
801     require(publicSupply >= tokens);
802     publicSupply = SafeMath.sub(publicSupply,tokens);
803     token.mint(beneficiary, tokens);
804   }
805 }
806 contract ArtToujourICO is Crowdsale, CappedCrowdsale, RefundableCrowdsale, CrowdsaleFunctions {
807   
808     /** Constructor ArtToujourICO */
809     function ArtToujourICO(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet) 
810     CappedCrowdsale(_cap)
811     FinalizableCrowdsale()
812     RefundableCrowdsale(_goal)   
813     Crowdsale(_startTime,_endTime,_rate,_wallet) 
814     {
815         require(_goal < _cap);
816     }
817     
818     /** ArtToujourToken Contract */
819     function createTokenContract() internal returns (MintableToken) {
820         return new ArtToujourToken();
821     }
822 }