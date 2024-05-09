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
331     
332     // Pre-ICO end time
333      preEndTime = 1521637200;
334     // // ICO start Time
335      ICOstartTime = 1521982800;
336     // ICO end Time
337     ICOEndTime = _endTime;
338     // Base Rate of BNE Token
339     rate = _rate;
340     // Multi-sig wallet where funds will be saved
341     wallet = _wallet;
342     /** Calculations of Bonuses in ICO or Pre-ICO */
343     preICOBonus = SafeMath.div(SafeMath.mul(rate,30),100);
344     firstWeekBonus = SafeMath.div(SafeMath.mul(rate,20),100);
345     secondWeekBonus = SafeMath.div(SafeMath.mul(rate,15),100);
346     thirdWeekBonus = SafeMath.div(SafeMath.mul(rate,10),100);
347     forthWeekBonus = SafeMath.div(SafeMath.mul(rate,5),100);
348     /** ICO bonuses week calculations */
349     weekOne = SafeMath.add(ICOstartTime, 604800);
350     weekTwo = SafeMath.add(weekOne, 604800);
351     weekThree = SafeMath.add(weekTwo, 604800);
352     weekForth = SafeMath.add(weekThree, 604800);
353     /** Vested Period calculations for team and advisors*/
354     teamTimeLock = SafeMath.add(ICOEndTime, 31536000);
355     advisorTimeLock = SafeMath.add(ICOEndTime, 5356800);
356     
357     checkBurnTokens = false;
358     upgradeICOSupply = false;
359     grantAdvisorSupply = false;
360     grantTeamSupply = false;
361   }
362   // creates the token to be sold.
363   // override this method to have crowdsale of a specific mintable token.
364   function createTokenContract() internal returns (MintableToken) {
365     return new MintableToken();
366   }
367   
368   // fallback function can be used to buy tokens
369   function () payable {
370     buyTokens(msg.sender);
371     
372   }
373   // High level token purchase function
374   function buyTokens(address beneficiary) public payable {
375     require(beneficiary != 0x0);
376     require(validPurchase());
377     uint256 weiAmount = msg.value;
378     // minimum investment should be 0.05 ETH
379     require(weiAmount >= (0.05 * 1 ether));
380     
381     uint256 accessTime = now;
382     uint256 tokens = 0;
383   // calculating the ICO and Pre-ICO bonuses on the basis of timing
384     if ((accessTime >= preStartTime) && (accessTime < preEndTime)) {
385         require(preicoSupply > 0);
386         tokens = SafeMath.add(tokens, weiAmount.mul(preICOBonus));
387         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
388         
389         require(preicoSupply >= tokens);
390         
391         preicoSupply = preicoSupply.sub(tokens);        
392         remainingPublicSupply = remainingPublicSupply.sub(tokens);
393     } else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) {
394         if (!upgradeICOSupply) {
395           icoSupply = SafeMath.add(icoSupply,preicoSupply);
396           upgradeICOSupply = true;
397         }
398         if ( accessTime <= weekOne ) {
399           tokens = SafeMath.add(tokens, weiAmount.mul(firstWeekBonus));
400         } else if (accessTime <= weekTwo) {
401           tokens = SafeMath.add(tokens, weiAmount.mul(secondWeekBonus));
402         } else if ( accessTime < weekThree ) {
403           tokens = SafeMath.add(tokens, weiAmount.mul(thirdWeekBonus));
404         } else if ( accessTime < weekForth ) {
405           tokens = SafeMath.add(tokens, weiAmount.mul(forthWeekBonus));
406         }
407         
408         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
409         icoSupply = icoSupply.sub(tokens);        
410         remainingPublicSupply = remainingPublicSupply.sub(tokens);
411     } else if ((accessTime > preEndTime) && (accessTime < ICOstartTime)){
412       revert();
413     }
414     // update state
415     weiRaised = weiRaised.add(weiAmount);
416     // tokens are minting here
417     token.mint(beneficiary, tokens);
418     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
419     // funds are forwarding
420     forwardFunds();
421   }
422   // send ether to the fund collection wallet
423   // override to create custom fund forwarding mechanisms
424   function forwardFunds() internal {
425     wallet.transfer(msg.value);
426   }
427   // @return true if the transaction can buy tokens
428   function validPurchase() internal constant returns (bool) {
429     bool withinPeriod = now >= preStartTime && now <= ICOEndTime;
430     bool nonZeroPurchase = msg.value != 0;
431     return withinPeriod && nonZeroPurchase;
432   }
433   // @return true if crowdsale event has ended
434   function hasEnded() public constant returns (bool) {
435       return now > ICOEndTime;
436   }
437   // @return true if burnToken function has ended
438   function burnToken() onlyOwner public returns (bool) {
439     require(hasEnded());
440     require(!checkBurnTokens);
441     token.burnTokens(remainingPublicSupply);
442     totalSupply = SafeMath.sub(totalSupply, remainingPublicSupply);
443     remainingPublicSupply = 0;
444     checkBurnTokens = true;
445     return true;
446   }
447   /** 
448      * @return true if bountyFunds function has ended
449      * @param beneficiary address where owner wants to transfer tokens
450      * @param valueToken value of token
451   */
452   function bountyFunds(address beneficiary, uint256 valueToken) onlyOwner public { 
453     valueToken = SafeMath.mul(valueToken, 1 ether);
454     require(remainingBountySupply >= valueToken);
455     remainingBountySupply = SafeMath.sub(remainingBountySupply,valueToken);
456     token.mint(beneficiary, valueToken);
457   }
458   /** 
459      * @return true if rewardsFunds function has ended
460      * @param beneficiary address where owner wants to transfer tokens
461      * @param valueToken value of token
462   */
463   function rewardsFunds(address beneficiary, uint256 valueToken) onlyOwner public { 
464     valueToken = SafeMath.mul(valueToken, 1 ether);
465     require(remainingRewardsSupply >= valueToken);
466     remainingRewardsSupply = SafeMath.sub(remainingRewardsSupply,valueToken);
467     token.mint(beneficiary, valueToken);
468   } 
469   /**
470       @return true if grantAdvisorToken function has ended  
471   */
472   function grantAdvisorToken() onlyOwner public {
473     require(!grantAdvisorSupply);
474     require(now > advisorTimeLock);
475     uint256 valueToken = SafeMath.div(remainingAdvisorSupply,3);
476     require(remainingAdvisorSupply >= valueToken);
477     grantAdvisorSupply = true;
478     token.mint(0xAA855f6D87d5D443eDa49aA034fA99D9EeeA0337, valueToken);
479     token.mint(0x4B2e3E1BBEb117b781e71A10376A969860FBcEB3, valueToken);
480     token.mint(0xbb3b3799D1b31189b491C26B1D7c17307fb87F5d, valueToken);
481     remainingAdvisorSupply = 0;
482   }
483   /**
484       @return true if grantTeamToken function has ended  
485   */
486     function grantTeamToken() onlyOwner public {
487     require(!grantTeamSupply);
488     require(now > teamTimeLock);
489     uint256 valueToken = SafeMath.div(remainingTeamSupply, 5);
490     require(remainingTeamSupply >= valueToken);
491     grantTeamSupply = true;
492     token.mint(0xBEB9e4057f953AaBdF14Dc4018056888C67E40b0, valueToken);
493     token.mint(0x70fcd07629eB9b406223168AEB8De06E2564F558, valueToken);
494     token.mint(0x0e562f12239C660627bE186de6535c05983579E9, valueToken);
495     token.mint(0x42e045f4D119212AC1CF5820488E69AA9164DC70, valueToken);
496     token.mint(0x2f53678a33C0fEE8f30fc5cfaC4E5E140397b40D, valueToken);
497     remainingTeamSupply = 0;
498     
499   }
500 /** 
501    * Function transferToken works to transfer tokens to the specified address on the
502      call of owner within the crowdsale timestamp.
503    * @param beneficiary address where owner wants to transfer tokens
504    * @param tokens value of token
505  */
506   function transferToken(address beneficiary, uint256 tokens) onlyOwner public {
507     require(ICOEndTime > now);
508     tokens = SafeMath.mul(tokens,1 ether);
509     require(remainingPublicSupply >= tokens);
510     remainingPublicSupply = SafeMath.sub(remainingPublicSupply,tokens);
511     token.mint(beneficiary, tokens);
512   }
513   function getTokenAddress() onlyOwner public returns (address) {
514     return token;
515   }
516   function getPublicSupply() onlyOwner public returns (uint256) {
517     return remainingPublicSupply;
518   }
519 }
520 /**
521  * @title CappedCrowdsale
522  * @dev Extension of Crowdsale with a max amount of funds raised
523  */
524 contract CappedCrowdsale is Crowdsale {
525   using SafeMath for uint256;
526   uint256 public cap;
527   function CappedCrowdsale(uint256 _cap) {
528     require(_cap > 0);
529     cap = _cap;
530   }
531   // overriding Crowdsale#validPurchase to add extra cap logic
532   // @return true if investors can buy at the moment
533   function validPurchase() internal constant returns (bool) {
534     bool withinCap = weiRaised.add(msg.value) <= cap;
535     return super.validPurchase() && withinCap;
536   }
537   // overriding Crowdsale#hasEnded to add cap logic
538   // @return true if crowdsale event has ended
539   function hasEnded() public constant returns (bool) {
540     bool capReached = weiRaised >= cap;
541     return super.hasEnded() || capReached;
542   }
543 }
544 /**
545  * @title FinalizableCrowdsale
546  * @dev Extension of Crowdsale where an owner can do extra work
547  * after finishing.
548  */
549 contract FinalizableCrowdsale is Crowdsale {
550   using SafeMath for uint256;
551   bool isFinalized = false;
552   event Finalized();
553   /**
554    * @dev Must be called after crowdsale ends, to do some extra finalization
555    * work. Calls the contract's finalization function.
556    */
557   function finalize() onlyOwner public {
558     require(!isFinalized);
559     require(hasEnded());
560     finalization();
561     Finalized();
562     isFinalized = true;
563   }
564   /**
565    * @dev Can be overridden to add finalization logic. The overriding function
566    * should call super.finalization() to ensure the chain of finalization is
567    * executed entirely.
568    */
569   function finalization() internal {
570   }
571 }
572 /**
573  * @title RefundVault
574  * @dev This contract is used for storing funds while a crowdsale
575  * is in progress. Supports refunding the money if crowdsale fails,
576  * and forwarding it if crowdsale is successful.
577  */
578 contract RefundVault is Ownable {
579   using SafeMath for uint256;
580   enum State { Active, Refunding, Closed }
581   mapping (address => uint256) public deposited;
582   address public wallet;
583   State public state;
584   event Closed();
585   event RefundsEnabled();
586   event Refunded(address indexed beneficiary, uint256 weiAmount);
587   function RefundVault(address _wallet) {
588     require(_wallet != 0x0);
589     wallet = _wallet;
590     state = State.Active;
591   }
592   function deposit(address investor) onlyOwner public payable {
593     require(state == State.Active);
594     deposited[investor] = deposited[investor].add(msg.value);
595   }
596   function close() onlyOwner public {
597     require(state == State.Active);
598     state = State.Closed;
599     Closed();
600     wallet.transfer(this.balance);
601   }
602   function enableRefunds() onlyOwner public {
603     require(state == State.Active);
604     state = State.Refunding;
605     RefundsEnabled();
606   }
607   function refund(address investor) public {
608     require(state == State.Refunding);
609     uint256 depositedValue = deposited[investor];
610     deposited[investor] = 0;
611     investor.transfer(depositedValue);
612     Refunded(investor, depositedValue);
613   }
614 }
615 /**
616  * @title RefundableCrowdsale
617  * @dev Extension of Crowdsale contract that adds a funding goal, and
618  * the possibility of users getting a refund if goal is not met.
619  * Uses a RefundVault as the crowdsale's vault.
620  */
621 contract RefundableCrowdsale is FinalizableCrowdsale {
622   using SafeMath for uint256;
623   // minimum amount of funds to be raised in weis
624   uint256 public goal;
625   bool private _goalReached = false;
626   // refund vault used to hold funds while crowdsale is running
627   RefundVault private vault;
628   function RefundableCrowdsale(uint256 _goal) {
629     require(_goal > 0);
630     vault = new RefundVault(wallet);
631     goal = _goal;
632   }
633   // We're overriding the fund forwarding from Crowdsale.
634   // In addition to sending the funds, we want to call
635   // the RefundVault deposit function
636   function forwardFunds() internal {
637     vault.deposit.value(msg.value)(msg.sender);
638   }
639   // if crowdsale is unsuccessful, investors can claim refunds here
640   function claimRefund() public {
641     require(isFinalized);
642     require(!goalReached());
643     vault.refund(msg.sender);
644   }
645   // vault finalization task, called when owner calls finalize()
646   function finalization() internal {
647     if (goalReached()) {
648       vault.close();
649     } else {
650       vault.enableRefunds();
651     }
652     super.finalization();
653   }
654   function goalReached() public constant returns (bool) {
655     if (weiRaised >= goal) {
656       _goalReached = true;
657       return true;
658     } else if (_goalReached) {
659       return true;
660     } 
661     else {
662       return false;
663     }
664   }
665   function updateGoalCheck() onlyOwner public {
666     _goalReached = true;
667   }
668   function getVaultAddress() onlyOwner public returns (address) {
669     return vault;
670   }
671 }
672 /**
673  * @title BenebitToken
674  * @author Hamza Yasin || Junaid Mushtaq
675  */
676 contract BenebitToken is MintableToken {
677   string public constant name = "BenebitToken";
678   string public constant symbol = "BNE";
679   uint256 public constant decimals = 18;
680   uint256 public constant _totalSupply = 300000000 * 1 ether;
681   
682 /** Constructor BenebitToken */
683   function BenebitToken() {
684     totalSupply = _totalSupply;
685   }
686 }
687 contract BenebitICO is Crowdsale, CappedCrowdsale, RefundableCrowdsale {
688     uint256 _startTime = 1516626000;
689     uint256 _endTime = 1525093200; 
690     uint256 _rate = 3000;
691     uint256 _goal = 5000 * 1 ether;
692     uint256 _cap = 40000 * 1 ether;
693     address _wallet  = 0x88BfBd2B464C15b245A9f7a563D207bd8A161054;   
694     /** Constructor BenebitICO */
695     function BenebitICO() 
696     CappedCrowdsale(_cap)
697     FinalizableCrowdsale()
698     RefundableCrowdsale(_goal)
699     Crowdsale(_startTime,_endTime,_rate,_wallet) 
700     {
701         
702     }
703     /** BenebitToken Contract is generating from here */
704     function createTokenContract() internal returns (MintableToken) {
705         return new BenebitToken();
706     }
707 }