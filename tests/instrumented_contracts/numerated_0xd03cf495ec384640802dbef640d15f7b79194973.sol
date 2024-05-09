1 pragma solidity ^0.4.11;
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
25   function Ownable() {
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
46  * @title BenebitICO
47  * @author Hamza Yasin || Junaid Mushtaq
48  * @dev BenibitCrowdsale is a base contract for managing a token crowdsale.
49  * Crowdsales have a start and end timestamps, where investors can make
50  * token purchases and the crowdsale will assign them BNE tokens based
51  * on a BNE token per ETH rate. Funds collected are forwarded to a wallet
52  * as they arrive.
53  */
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60   mapping(address => uint256) balances;
61   /**
62   * @dev transfer token for a specified address
63   * @param _to The address to transfer to.
64   * @param _value The amount to be transferred.
65   */
66   function transfer(address _to, uint256 _value) public returns (bool) {
67     require(_to != address(0));
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of.
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) public constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82 }
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public constant returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101   mapping (address => mapping (address => uint256)) allowed;
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amount of tokens to be transferred
107    */
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     uint256 _allowance = allowed[_from][msg.sender];
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = _allowance.sub(_value);
116     Transfer(_from, _to, _value);
117     return true;
118   }
119   /**
120    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    *
122    * Beware that changing an allowance with this method brings the risk that someone may use both the old
123    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
124    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
125    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) public returns (bool) {
130     allowed[msg.sender][_spender] = _value;
131     Approval(msg.sender, _spender, _value);
132     return true;
133   }
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param _owner address The address which owns the funds.
137    * @param _spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
141     return allowed[_owner][_spender];
142   }
143   /**
144    * approve should be called when allowed[_spender] == 0. To increment
145    * allowed value is better to use this function to avoid 2 calls (and wait until
146    * the first transaction is mined)
147    * From MonolithDAO Token.sol
148    */
149   function increaseApproval (address _spender, uint _addedValue)
150     returns (bool success) {
151     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155   function decreaseApproval (address _spender, uint _subtractedValue)
156     returns (bool success) {
157     uint oldValue = allowed[msg.sender][_spender];
158     if (_subtractedValue > oldValue) {
159       allowed[msg.sender][_spender] = 0;
160     } else {
161       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
162     }
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 }
167 /**
168  * @title Mintable token
169  * @dev Simple ERC20 Token example, with mintable token creation
170  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
171  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
172  */
173 contract MintableToken is StandardToken, Ownable {
174   event Mint(address indexed to, uint256 amount);
175   event MintFinished();
176   bool public mintingFinished = false;
177   modifier canMint() {
178     require(!mintingFinished);
179     _;
180   }
181   /**
182    * @dev Function to mint tokens
183    * @param _to The address that will receive the minted tokens.
184    * @param _amount The amount of tokens to mint.
185    * @return A boolean that indicates if the operation was successful.
186    */
187   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
188     //totalSupply = totalSupply.add(_amount);
189     balances[_to] = balances[_to].add(_amount);
190     Mint(_to, _amount);
191     Transfer(msg.sender, _to, _amount);
192     return true;
193   }
194   /**
195    * @dev Function to stop minting new tokens.
196    * @return True if the operation was successful.
197    */
198   function finishMinting() onlyOwner public returns (bool) {
199     mintingFinished = true;
200     MintFinished();
201     return true;
202   }
203   function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {
204     totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);
205   }
206 }
207 /**
208  * @title SafeMath
209  * @dev Math operations with safety checks that throw on error
210  */
211 library SafeMath {
212   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
213     uint256 c = a * b;
214     assert(a == 0 || c / a == b);
215     return c;
216   }
217   function div(uint256 a, uint256 b) internal constant returns (uint256) {
218     // assert(b > 0); // Solidity automatically throws when dividing by 0
219     uint256 c = a / b;
220     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221     return c;
222   }
223   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
224     assert(b <= a);
225     return a - b;
226   }
227   function add(uint256 a, uint256 b) internal constant returns (uint256) {
228     uint256 c = a + b;
229     assert(c >= a);
230     return c;
231   }
232 }
233 /**
234  * @title Benebit Crowdsale
235  * @author Junaid Mushtaq || Hamza Yasin
236  * @dev Crowdsale is a base contract for managing a token crowdsale.
237  * Crowdsales have a start and end timestamps, where investors can make
238  * token purchases and the crowdsale will assign them tokens based
239  * on a token per ETH rate. Funds collected are forwarded to a wallet
240  * as they arrive.
241  */
242 contract Crowdsale is Ownable {
243   using SafeMath for uint256;
244   // The token being sold
245   MintableToken private token;
246   // start and end timestamps where investments are allowed (both inclusive)
247   uint256 public preStartTime;
248   uint256 public preEndTime;
249   uint256 public ICOstartTime;
250   uint256 public ICOEndTime;
251   
252   // Bonuses will be calculated here of ICO and Pre-ICO (both inclusive)
253   uint256 private preICOBonus;
254   uint256 private firstWeekBonus;
255   uint256 private secondWeekBonus;
256   uint256 private thirdWeekBonus;
257   uint256 private forthWeekBonus;
258   
259   
260   // wallet address where funds will be saved
261   address internal wallet;
262   
263   // base-rate of a particular Benebit token
264   uint256 public rate;
265   // amount of raised money in wei
266   uint256 internal weiRaised;
267   // Weeks in UTC
268   uint256 weekOne;
269   uint256 weekTwo;
270   uint256 weekThree;
271   uint256 weekForth;
272   
273   // total supply of token 
274   uint256 private totalSupply = 300000000 * (10**18);
275   // public supply of token 
276   uint256 private publicSupply = SafeMath.mul(SafeMath.div(totalSupply,100),75);
277   // rewards supply of token 
278   uint256 private rewardsSupply = SafeMath.mul(SafeMath.div(totalSupply,100),15);
279   // team supply of token 
280   uint256 private teamSupply = SafeMath.mul(SafeMath.div(totalSupply,100),5);
281   // advisor supply of token 
282   uint256 private advisorSupply = SafeMath.mul(SafeMath.div(totalSupply,100),3);
283   // bounty supply of token 
284   uint256 private bountySupply = SafeMath.mul(SafeMath.div(totalSupply,100),2);
285   // preICO supply of token 
286   uint256 private preicoSupply = SafeMath.mul(SafeMath.div(publicSupply,100),15);
287   // ICO supply of token 
288   uint256 private icoSupply = SafeMath.mul(SafeMath.div(publicSupply,100),85);
289   // Remaining Public Supply of token 
290   uint256 private remainingPublicSupply = publicSupply;
291   // Remaining Reward Supply of token 
292   uint256 private remainingRewardsSupply = rewardsSupply;
293   // Remaining Bounty Supply of token 
294   uint256 private remainingBountySupply = bountySupply;
295   // Remaining Advisor Supply of token 
296   uint256 private remainingAdvisorSupply = advisorSupply;
297   // Remaining Team Supply of token 
298   uint256 private remainingTeamSupply = teamSupply;
299   // Time lock or vested period of token for team allocated token
300   uint256 private teamTimeLock;
301   // Time lock or vested period of token for Advisor allocated token
302   uint256 private advisorTimeLock;
303   /**
304    *  @bool checkBurnTokens
305    *  @bool upgradeICOSupply
306    *  @bool grantTeamSupply
307    *  @bool grantAdvisorSupply     
308   */
309   bool private checkBurnTokens;
310   bool private upgradeICOSupply;
311   bool private grantTeamSupply;
312   bool private grantAdvisorSupply;
313   /**
314    * event for token purchase logging
315    * @param purchaser who paid for the tokens
316    * @param beneficiary who got the tokens
317    * @param value weis paid for purchase
318    * @param amount amount of tokens purchased
319    */
320   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
321   // Benebit Crowdsale constructor
322   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
323     require(_startTime >= now);
324     require(_endTime >= _startTime);
325     require(_rate > 0);
326     require(_wallet != 0x0);
327     // Benebit token creation 
328     token = createTokenContract();
329     // Pre-ICO start Time
330     preStartTime = _startTime;
331     // Pre-ICO end time
332     preEndTime = 1521637200;
333     // ICO start Time
334     ICOstartTime = 1521982800;
335     // ICO end Time
336     ICOEndTime = _endTime;
337     // Base Rate of BNE Token
338     rate = _rate;
339     // Multi-sig wallet where funds will be saved
340     wallet = _wallet;
341     /** Calculations of Bonuses in ICO or Pre-ICO */
342     preICOBonus = SafeMath.div(SafeMath.mul(rate,30),100);
343     firstWeekBonus = SafeMath.div(SafeMath.mul(rate,20),100);
344     secondWeekBonus = SafeMath.div(SafeMath.mul(rate,15),100);
345     thirdWeekBonus = SafeMath.div(SafeMath.mul(rate,10),100);
346     forthWeekBonus = SafeMath.div(SafeMath.mul(rate,5),100);
347     /** ICO bonuses week calculations */
348     weekOne = SafeMath.add(ICOstartTime, 604800);
349     weekTwo = SafeMath.add(weekOne, 604800);
350     weekThree = SafeMath.add(weekTwo, 604800);
351     weekForth = SafeMath.add(weekThree, 604800);
352     /** Vested Period calculations for team and advisors*/
353     teamTimeLock = SafeMath.add(ICOEndTime, 31536000);
354     advisorTimeLock = SafeMath.add(ICOEndTime, 5356800);
355     
356     checkBurnTokens = false;
357     upgradeICOSupply = false;
358     grantAdvisorSupply = false;
359     grantTeamSupply = false;
360   }
361   // creates the token to be sold.
362   // override this method to have crowdsale of a specific mintable token.
363   function createTokenContract() internal returns (MintableToken) {
364     return new MintableToken();
365   }
366   
367   // fallback function can be used to buy tokens
368   function () payable {
369     buyTokens(msg.sender);
370     
371   }
372   // High level token purchase function
373   function buyTokens(address beneficiary) public payable {
374     require(beneficiary != 0x0);
375     require(validPurchase());
376     uint256 weiAmount = msg.value;
377     // minimum investment should be 0.05 ETH
378     require(weiAmount >= (0.05 * 1 ether));
379     
380     uint256 accessTime = now;
381     uint256 tokens = 0;
382   // calculating the ICO and Pre-ICO bonuses on the basis of timing
383     if ((accessTime >= preStartTime) && (accessTime < preEndTime)) {
384         require(preicoSupply > 0);
385         tokens = SafeMath.add(tokens, weiAmount.mul(preICOBonus));
386         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
387         
388         require(preicoSupply >= tokens);
389         
390         preicoSupply = preicoSupply.sub(tokens);        
391         remainingPublicSupply = remainingPublicSupply.sub(tokens);
392     } else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) {
393         if (!upgradeICOSupply) {
394           icoSupply = SafeMath.add(icoSupply,preicoSupply);
395           upgradeICOSupply = true;
396         }
397         if ( accessTime <= weekOne ) {
398           tokens = SafeMath.add(tokens, weiAmount.mul(firstWeekBonus));
399         } else if (accessTime <= weekTwo) {
400           tokens = SafeMath.add(tokens, weiAmount.mul(secondWeekBonus));
401         } else if ( accessTime < weekThree ) {
402           tokens = SafeMath.add(tokens, weiAmount.mul(thirdWeekBonus));
403         } else if ( accessTime < weekForth ) {
404           tokens = SafeMath.add(tokens, weiAmount.mul(forthWeekBonus));
405         }
406         
407         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
408         icoSupply = icoSupply.sub(tokens);        
409         remainingPublicSupply = remainingPublicSupply.sub(tokens);
410     } else if ((accessTime > preEndTime) && (accessTime < ICOstartTime)){
411       revert();
412     }
413     // update state
414     weiRaised = weiRaised.add(weiAmount);
415     // tokens are minting here
416     token.mint(beneficiary, tokens);
417     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
418     // funds are forwarding
419     forwardFunds();
420   }
421   // send ether to the fund collection wallet
422   // override to create custom fund forwarding mechanisms
423   function forwardFunds() internal {
424     wallet.transfer(msg.value);
425   }
426   // @return true if the transaction can buy tokens
427   function validPurchase() internal constant returns (bool) {
428     bool withinPeriod = now >= preStartTime && now <= ICOEndTime;
429     bool nonZeroPurchase = msg.value != 0;
430     return withinPeriod && nonZeroPurchase;
431   }
432   // @return true if crowdsale event has ended
433   function hasEnded() public constant returns (bool) {
434       return now > ICOEndTime;
435   }
436   // @return true if burnToken function has ended
437   function burnToken() onlyOwner public returns (bool) {
438     require(hasEnded());
439     require(!checkBurnTokens);
440     token.burnTokens(remainingPublicSupply);
441     totalSupply = SafeMath.sub(totalSupply, remainingPublicSupply);
442     remainingPublicSupply = 0;
443     checkBurnTokens = true;
444     return true;
445   }
446   /** 
447      * @return true if bountyFunds function has ended
448      * @param beneficiary address where owner wants to transfer tokens
449      * @param valueToken value of token
450   */
451   function bountyFunds(address beneficiary, uint256 valueToken) onlyOwner public { 
452     valueToken = SafeMath.mul(valueToken, 1 ether);
453     require(remainingBountySupply >= valueToken);
454     remainingBountySupply = SafeMath.sub(remainingBountySupply,valueToken);
455     token.mint(beneficiary, valueToken);
456   }
457   /** 
458      * @return true if rewardsFunds function has ended
459      * @param beneficiary address where owner wants to transfer tokens
460      * @param valueToken value of token
461   */
462   function rewardsFunds(address beneficiary, uint256 valueToken) onlyOwner public { 
463     valueToken = SafeMath.mul(valueToken, 1 ether);
464     require(remainingRewardsSupply >= valueToken);
465     remainingRewardsSupply = SafeMath.sub(remainingRewardsSupply,valueToken);
466     token.mint(beneficiary, valueToken);
467   } 
468   /**
469       @return true if grantAdvisorToken function has ended  
470   */
471   function grantAdvisorToken() onlyOwner public {
472     require(!grantAdvisorSupply);
473     require(now > advisorTimeLock);
474     uint256 valueToken = SafeMath.div(remainingAdvisorSupply,3);
475     require(remainingAdvisorSupply >= valueToken);
476     grantAdvisorSupply = true;
477     token.mint(0xAA855f6D87d5D443eDa49aA034fA99D9EeeA0337, valueToken);
478     token.mint(0x4B2e3E1BBEb117b781e71A10376A969860FBcEB3, valueToken);
479     token.mint(0xbb3b3799D1b31189b491C26B1D7c17307fb87F5d, valueToken);
480     remainingAdvisorSupply = 0;
481   }
482   /**
483       @return true if grantTeamToken function has ended  
484   */
485     function grantTeamToken() onlyOwner public {
486     require(!grantTeamSupply);
487     require(now > teamTimeLock);
488     uint256 valueToken = SafeMath.div(remainingTeamSupply, 5);
489     require(remainingTeamSupply >= valueToken);
490     grantTeamSupply = true;
491     token.mint(0xBEB9e4057f953AaBdF14Dc4018056888C67E40b0, valueToken);
492     token.mint(0x70fcd07629eB9b406223168AEB8De06E2564F558, valueToken);
493     token.mint(0x0e562f12239C660627bE186de6535c05983579E9, valueToken);
494     token.mint(0x42e045f4D119212AC1CF5820488E69AA9164DC70, valueToken);
495     token.mint(0x2f53678a33C0fEE8f30fc5cfaC4E5E140397b40D, valueToken);
496     remainingTeamSupply = 0;
497     
498   }
499 /** 
500    * Function transferToken works to transfer tokens to the specified address on the
501      call of owner within the crowdsale timestamp.
502    * @param beneficiary address where owner wants to transfer tokens
503    * @param tokens value of token
504  */
505   function transferToken(address beneficiary, uint256 tokens) onlyOwner public {
506     require(ICOEndTime > now);
507     tokens = SafeMath.mul(tokens,1 ether);
508     require(remainingPublicSupply >= tokens);
509     remainingPublicSupply = SafeMath.sub(remainingPublicSupply,tokens);
510     token.mint(beneficiary, tokens);
511   }
512   function getTokenAddress() onlyOwner public returns (address) {
513     return token;
514   }
515   function getPublicSupply() onlyOwner public returns (uint256) {
516     return remainingPublicSupply;
517   }
518 }
519 /**
520  * @title CappedCrowdsale
521  * @dev Extension of Crowdsale with a max amount of funds raised
522  */
523 contract CappedCrowdsale is Crowdsale {
524   using SafeMath for uint256;
525   uint256 public cap;
526   function CappedCrowdsale(uint256 _cap) {
527     require(_cap > 0);
528     cap = _cap;
529   }
530   // overriding Crowdsale#validPurchase to add extra cap logic
531   // @return true if investors can buy at the moment
532   function validPurchase() internal constant returns (bool) {
533     bool withinCap = weiRaised.add(msg.value) <= cap;
534     return super.validPurchase() && withinCap;
535   }
536   // overriding Crowdsale#hasEnded to add cap logic
537   // @return true if crowdsale event has ended
538   function hasEnded() public constant returns (bool) {
539     bool capReached = weiRaised >= cap;
540     return super.hasEnded() || capReached;
541   }
542 }
543 /**
544  * @title FinalizableCrowdsale
545  * @dev Extension of Crowdsale where an owner can do extra work
546  * after finishing.
547  */
548 contract FinalizableCrowdsale is Crowdsale {
549   using SafeMath for uint256;
550   bool isFinalized = false;
551   event Finalized();
552   /**
553    * @dev Must be called after crowdsale ends, to do some extra finalization
554    * work. Calls the contract's finalization function.
555    */
556   function finalize() onlyOwner public {
557     require(!isFinalized);
558     require(hasEnded());
559     finalization();
560     Finalized();
561     isFinalized = true;
562   }
563   /**
564    * @dev Can be overridden to add finalization logic. The overriding function
565    * should call super.finalization() to ensure the chain of finalization is
566    * executed entirely.
567    */
568   function finalization() internal {
569   }
570 }
571 /**
572  * @title RefundVault
573  * @dev This contract is used for storing funds while a crowdsale
574  * is in progress. Supports refunding the money if crowdsale fails,
575  * and forwarding it if crowdsale is successful.
576  */
577 contract RefundVault is Ownable {
578   using SafeMath for uint256;
579   enum State { Active, Refunding, Closed }
580   mapping (address => uint256) public deposited;
581   address public wallet;
582   State public state;
583   event Closed();
584   event RefundsEnabled();
585   event Refunded(address indexed beneficiary, uint256 weiAmount);
586   function RefundVault(address _wallet) {
587     require(_wallet != 0x0);
588     wallet = _wallet;
589     state = State.Active;
590   }
591   function deposit(address investor) onlyOwner public payable {
592     require(state == State.Active);
593     deposited[investor] = deposited[investor].add(msg.value);
594   }
595   function close() onlyOwner public {
596     require(state == State.Active);
597     state = State.Closed;
598     Closed();
599     wallet.transfer(this.balance);
600   }
601   function enableRefunds() onlyOwner public {
602     require(state == State.Active);
603     state = State.Refunding;
604     RefundsEnabled();
605   }
606   function refund(address investor) public {
607     require(state == State.Refunding);
608     uint256 depositedValue = deposited[investor];
609     deposited[investor] = 0;
610     investor.transfer(depositedValue);
611     Refunded(investor, depositedValue);
612   }
613 }
614 /**
615  * @title RefundableCrowdsale
616  * @dev Extension of Crowdsale contract that adds a funding goal, and
617  * the possibility of users getting a refund if goal is not met.
618  * Uses a RefundVault as the crowdsale's vault.
619  */
620 contract RefundableCrowdsale is FinalizableCrowdsale {
621   using SafeMath for uint256;
622   // minimum amount of funds to be raised in weis
623   uint256 public goal;
624   bool private _goalReached = false;
625   // refund vault used to hold funds while crowdsale is running
626   RefundVault private vault;
627   function RefundableCrowdsale(uint256 _goal) {
628     require(_goal > 0);
629     vault = new RefundVault(wallet);
630     goal = _goal;
631   }
632   // We're overriding the fund forwarding from Crowdsale.
633   // In addition to sending the funds, we want to call
634   // the RefundVault deposit function
635   function forwardFunds() internal {
636     vault.deposit.value(msg.value)(msg.sender);
637   }
638   // if crowdsale is unsuccessful, investors can claim refunds here
639   function claimRefund() public {
640     require(isFinalized);
641     require(!goalReached());
642     vault.refund(msg.sender);
643   }
644   // vault finalization task, called when owner calls finalize()
645   function finalization() internal {
646     if (goalReached()) {
647       vault.close();
648     } else {
649       vault.enableRefunds();
650     }
651     super.finalization();
652   }
653   function goalReached() public constant returns (bool) {
654     if (weiRaised >= goal) {
655       _goalReached = true;
656       return true;
657     } else if (_goalReached) {
658       return true;
659     } 
660     else {
661       return false;
662     }
663   }
664   function updateGoalCheck() onlyOwner public {
665     _goalReached = true;
666   }
667   function getVaultAddress() onlyOwner public returns (address) {
668     return vault;
669   }
670 }
671 /**
672  * @title BenebitToken
673  * @author Hamza Yasin || Junaid Mushtaq
674  */
675 contract BenebitToken is MintableToken {
676   string public constant name = "BenebitToken";
677   string public constant symbol = "BNE";
678   uint256 public constant decimals = 18;
679   uint256 public constant _totalSupply = 300000000 * 1 ether;
680   
681 /** Constructor BenebitToken */
682   function BenebitToken() {
683     totalSupply = _totalSupply;
684   }
685 }
686 contract BenebitICO is Crowdsale, CappedCrowdsale, RefundableCrowdsale {
687     uint256 _startTime = 1516626000;
688     uint256 _endTime = 1525093200; 
689     uint256 _rate = 3000;
690     uint256 _goal = 5000 * 1 ether;
691     uint256 _cap = 40000 * 1 ether;
692     address _wallet  = 0x88BfBd2B464C15b245A9f7a563D207bd8A161054;   
693     /** Constructor BenebitICO */
694     function BenebitICO() 
695     CappedCrowdsale(_cap)
696     FinalizableCrowdsale()
697     RefundableCrowdsale(_goal)
698     Crowdsale(_startTime,_endTime,_rate,_wallet) 
699     {
700         
701     }
702     /** BenebitToken Contract is generating from here */
703     function createTokenContract() internal returns (MintableToken) {
704         return new BenebitToken();
705     }
706 }