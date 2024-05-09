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
333      preEndTime = 1519045200;
334     // // ICO start Time
335      ICOstartTime = 1519304400;
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
413     } else {
414       revert();
415     }
416     // update state
417     weiRaised = weiRaised.add(weiAmount);
418     // tokens are minting here
419     token.mint(beneficiary, tokens);
420     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
421     // funds are forwarding
422     forwardFunds();
423   }
424   // send ether to the fund collection wallet
425   // override to create custom fund forwarding mechanisms
426   function forwardFunds() internal {
427     wallet.transfer(msg.value);
428   }
429   // @return true if the transaction can buy tokens
430   function validPurchase() internal constant returns (bool) {
431     bool withinPeriod = now >= preStartTime && now <= ICOEndTime;
432     bool nonZeroPurchase = msg.value != 0;
433     return withinPeriod && nonZeroPurchase;
434   }
435   // @return true if crowdsale event has ended
436   function hasEnded() public constant returns (bool) {
437       return now > ICOEndTime;
438   }
439   // @return true if burnToken function has ended
440   function burnToken() onlyOwner public returns (bool) {
441     require(hasEnded());
442     require(!checkBurnTokens);
443     checkBurnTokens = true;
444     token.burnTokens(remainingPublicSupply);
445     totalSupply = SafeMath.sub(totalSupply, remainingPublicSupply);
446     remainingPublicSupply = 0;
447     return true;
448   }
449   /** 
450      * @return true if bountyFunds function has ended
451      * @param beneficiary address where owner wants to transfer tokens
452      * @param valueToken value of token
453   */
454   function bountyFunds(address beneficiary, uint256 valueToken) onlyOwner public { 
455     valueToken = SafeMath.mul(valueToken, 1 ether);
456     require(remainingBountySupply >= valueToken);
457     remainingBountySupply = SafeMath.sub(remainingBountySupply,valueToken);
458     token.mint(beneficiary, valueToken);
459   }
460   /** 
461      * @return true if rewardsFunds function has ended
462      * @param beneficiary address where owner wants to transfer tokens
463      * @param valueToken value of token
464   */
465   function rewardsFunds(address beneficiary, uint256 valueToken) onlyOwner public { 
466     valueToken = SafeMath.mul(valueToken, 1 ether);
467     require(remainingRewardsSupply >= valueToken);
468     remainingRewardsSupply = SafeMath.sub(remainingRewardsSupply,valueToken);
469     token.mint(beneficiary, valueToken);
470   } 
471   /**
472       @return true if grantAdvisorToken function has ended  
473   */
474   function grantAdvisorToken() onlyOwner public {
475     require(!grantAdvisorSupply);
476     require(now > advisorTimeLock);
477     uint256 valueToken = SafeMath.div(remainingAdvisorSupply,3);
478     require(remainingAdvisorSupply >= valueToken);
479     grantAdvisorSupply = true;
480     token.mint(0xAA855f6D87d5D443eDa49aA034fA99D9EeeA0337, valueToken);
481     token.mint(0x4B2e3E1BBEb117b781e71A10376A969860FBcEB3, valueToken);
482     token.mint(0xbb3b3799D1b31189b491C26B1D7c17307fb87F5d, valueToken);
483     remainingAdvisorSupply = 0;
484   }
485   /**
486       @return true if grantTeamToken function has ended  
487   */
488     function grantTeamToken() onlyOwner public {
489     require(!grantTeamSupply);
490     require(now > teamTimeLock);
491     uint256 valueToken = SafeMath.div(remainingTeamSupply, 5);
492     require(remainingTeamSupply >= valueToken);
493     grantTeamSupply = true;
494     token.mint(0xBEB9e4057f953AaBdF14Dc4018056888C67E40b0, valueToken);
495     token.mint(0x70fcd07629eB9b406223168AEB8De06E2564F558, valueToken);
496     token.mint(0x0e562f12239C660627bE186de6535c05983579E9, valueToken);
497     token.mint(0x42e045f4D119212AC1CF5820488E69AA9164DC70, valueToken);
498     token.mint(0x2f53678a33C0fEE8f30fc5cfaC4E5E140397b40D, valueToken);
499     remainingTeamSupply = 0;
500     
501   }
502 /** 
503    * Function transferToken works to transfer tokens to the specified address on the
504      call of owner within the crowdsale timestamp.
505    * @param beneficiary address where owner wants to transfer tokens
506    * @param tokens value of token
507  */
508   function transferToken(address beneficiary, uint256 tokens) onlyOwner public {
509    
510     require ((now >= preStartTime) && (now <= ICOEndTime));
511     tokens = SafeMath.mul(tokens,1 ether);
512     require(remainingPublicSupply >= tokens);
513     remainingPublicSupply = SafeMath.sub(remainingPublicSupply, tokens);
514     token.mint(beneficiary, tokens);
515   }
516   function getTokenAddress() onlyOwner public returns (address) {
517     return token;
518   }
519   function getPublicSupply() onlyOwner public returns (uint256) {
520     return remainingPublicSupply;
521   }
522 }
523 /**
524  * @title CappedCrowdsale
525  * @dev Extension of Crowdsale with a max amount of funds raised
526  */
527 contract CappedCrowdsale is Crowdsale {
528   using SafeMath for uint256;
529   uint256 public cap;
530   function CappedCrowdsale(uint256 _cap) {
531     require(_cap > 0);
532     cap = _cap;
533   }
534   // overriding Crowdsale#validPurchase to add extra cap logic
535   // @return true if investors can buy at the moment
536   function validPurchase() internal constant returns (bool) {
537     bool withinCap = weiRaised.add(msg.value) <= cap;
538     return super.validPurchase() && withinCap;
539   }
540   // overriding Crowdsale#hasEnded to add cap logic
541   // @return true if crowdsale event has ended
542   function hasEnded() public constant returns (bool) {
543     bool capReached = weiRaised >= cap;
544     return super.hasEnded() || capReached;
545   }
546 }
547 /**
548  * @title FinalizableCrowdsale
549  * @dev Extension of Crowdsale where an owner can do extra work
550  * after finishing.
551  */
552 contract FinalizableCrowdsale is Crowdsale {
553   using SafeMath for uint256;
554   bool isFinalized = false;
555   event Finalized();
556   /**
557    * @dev Must be called after crowdsale ends, to do some extra finalization
558    * work. Calls the contract's finalization function.
559    */
560   function finalize() onlyOwner public {
561     require(!isFinalized);
562     require(hasEnded());
563     finalization();
564     Finalized();
565     isFinalized = true;
566   }
567   /**
568    * @dev Can be overridden to add finalization logic. The overriding function
569    * should call super.finalization() to ensure the chain of finalization is
570    * executed entirely.
571    */
572   function finalization() internal {
573   }
574 }
575 /**
576  * @title RefundVault
577  * @dev This contract is used for storing funds while a crowdsale
578  * is in progress. Supports refunding the money if crowdsale fails,
579  * and forwarding it if crowdsale is successful.
580  */
581 contract RefundVault is Ownable {
582   using SafeMath for uint256;
583   enum State { Active, Refunding, Closed }
584   mapping (address => uint256) public deposited;
585   address public wallet;
586   State public state;
587   event Closed();
588   event RefundsEnabled();
589   event Refunded(address indexed beneficiary, uint256 weiAmount);
590   function RefundVault(address _wallet) {
591     require(_wallet != 0x0);
592     wallet = _wallet;
593     state = State.Active;
594   }
595   function deposit(address investor) onlyOwner public payable {
596     require(state == State.Active);
597     deposited[investor] = deposited[investor].add(msg.value);
598   }
599   function close() onlyOwner public {
600     require(state == State.Active);
601     state = State.Closed;
602     Closed();
603     wallet.transfer(this.balance);
604   }
605   function enableRefunds() onlyOwner public {
606     require(state == State.Active);
607     state = State.Refunding;
608     RefundsEnabled();
609   }
610   function refund(address investor) public {
611     require(state == State.Refunding);
612     uint256 depositedValue = deposited[investor];
613     deposited[investor] = 0;
614     investor.transfer(depositedValue);
615     Refunded(investor, depositedValue);
616   }
617 }
618 /**
619  * @title RefundableCrowdsale
620  * @dev Extension of Crowdsale contract that adds a funding goal, and
621  * the possibility of users getting a refund if goal is not met.
622  * Uses a RefundVault as the crowdsale's vault.
623  */
624 contract RefundableCrowdsale is FinalizableCrowdsale {
625   using SafeMath for uint256;
626   // minimum amount of funds to be raised in weis
627   uint256 public goal;
628   bool private _goalReached = false;
629   // refund vault used to hold funds while crowdsale is running
630   RefundVault private vault;
631   function RefundableCrowdsale(uint256 _goal) {
632     require(_goal > 0);
633     vault = new RefundVault(wallet);
634     goal = _goal;
635   }
636   // We're overriding the fund forwarding from Crowdsale.
637   // In addition to sending the funds, we want to call
638   // the RefundVault deposit function
639   function forwardFunds() internal {
640     vault.deposit.value(msg.value)(msg.sender);
641   }
642   // if crowdsale is unsuccessful, investors can claim refunds here
643   function claimRefund() public {
644     require(isFinalized);
645     require(!goalReached());
646     vault.refund(msg.sender);
647   }
648   // vault finalization task, called when owner calls finalize()
649   function finalization() internal {
650     if (goalReached()) {
651       vault.close();
652     } else {
653       vault.enableRefunds();
654     }
655     super.finalization();
656   }
657   function goalReached() public constant returns (bool) {
658     if (weiRaised >= goal) {
659       _goalReached = true;
660       return true;
661     } else if (_goalReached) {
662       return true;
663     } 
664     else {
665       return false;
666     }
667   }
668   function updateGoalCheck() onlyOwner public {
669     _goalReached = true;
670   }
671   function getVaultAddress() onlyOwner public returns (address) {
672     return vault;
673   }
674 }
675 /**
676  * @title BenebitToken
677  * @author Hamza Yasin || Junaid Mushtaq
678  */
679 contract BenebitToken is MintableToken {
680   string public constant name = "BenebitToken";
681   string public constant symbol = "BNE";
682   uint256 public constant decimals = 18;
683   uint256 public constant _totalSupply = 300000000 * 1 ether;
684   
685 /** Constructor BenebitToken */
686   function BenebitToken() {
687     totalSupply = _totalSupply;
688   }
689 }
690 contract BenebitICO is Crowdsale, CappedCrowdsale, RefundableCrowdsale {
691     uint256 _startTime = 1516626000;
692     uint256 _endTime = 1523365200; 
693     uint256 _rate = 5800;
694     uint256 _goal = 5000 * 1 ether;
695     uint256 _cap = 22500 * 1 ether;
696     address _wallet  = 0x88BfBd2B464C15b245A9f7a563D207bd8A161054;   
697     /** Constructor BenebitICO */
698     function BenebitICO() 
699     CappedCrowdsale(_cap)
700     FinalizableCrowdsale()
701     RefundableCrowdsale(_goal)
702     Crowdsale(_startTime,_endTime,_rate,_wallet) 
703     {
704         
705     }
706     /** BenebitToken Contract is generating from here */
707     function createTokenContract() internal returns (MintableToken) {
708         return new BenebitToken();
709     }
710 }