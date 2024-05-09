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
46  * @title GoldiamICO
47  * @dev GoldiamCrowdsale is a base contract for managing a token crowdsale.
48  * Crowdsales have a start and end timestamps, where investors can make
49  * token purchases and the crowdsale will assign them GOL tokens based
50  * on a GOL token per ETH rate. Funds collected are forwarded to a wallet
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
207  * @title SafeMath
208  * @dev Math operations with safety checks that throw on error
209  */
210 library SafeMath {
211   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
212     uint256 c = a * b;
213     assert(a == 0 || c / a == b);
214     return c;
215   }
216   function div(uint256 a, uint256 b) internal constant returns (uint256) {
217     // assert(b > 0); // Solidity automatically throws when dividing by 0
218     uint256 c = a / b;
219     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220     return c;
221   }
222   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
223     assert(b <= a);
224     return a - b;
225   }
226   function add(uint256 a, uint256 b) internal constant returns (uint256) {
227     uint256 c = a + b;
228     assert(c >= a);
229     return c;
230   }
231 }
232 /**
233  * @title Goldiam Crowdsale
234  * @dev Crowdsale is a base contract for managing a token crowdsale.
235  * Crowdsales have a start and end timestamps, where investors can make
236  * token purchases and the crowdsale will assign them tokens based
237  * on a token per ETH rate. Funds collected are forwarded to a wallet
238  * as they arrive.
239  */
240 contract Crowdsale is Ownable {
241   using SafeMath for uint256;
242   // The token being sold
243   MintableToken private token;
244   // start and end timestamps where investments are allowed (both inclusive)
245   uint256 public preStartTime;
246   uint256 public preEndTime;
247   uint256 public preIcoStartTime;
248   uint256 public preIcoEndTime;
249   uint256 public ICOstartTime;
250   uint256 public ICOEndTime;
251   
252   // Bonuses will be calculated here of ICO and Pre-ICO (both inclusive)
253   uint256 private preSaleBonus;
254   uint256 private preICOBonus;
255   uint256 private firstWeekBonus;
256   uint256 private secondWeekBonus;
257   uint256 private thirdWeekBonus;
258   
259   
260   // wallet address where funds will be saved
261   address internal wallet;
262   
263   // base-rate of a particular Goldiam token
264   uint256 public rate;
265   // amount of raised money in wei
266   uint256 internal weiRaised;
267   // Weeks in UTC
268   // uint256 weekOne;
269   // uint256 weekTwo;
270   // uint256 weekThree;
271   
272   uint256 weekOneStart;
273   uint256 weekOneEnd;
274   uint256 weekTwoStart;
275   uint256 weekTwoEnd;
276   uint256 weekThreeStart;
277   uint256 weekThreeEnd;
278   uint256 lastWeekStart;
279   uint256 lastWeekEnd;
280   // total supply of token 
281   uint256 public totalSupply = 32300000 * 1 ether;
282   // public supply of token 
283   uint256 public publicSupply = 28300000 * 1 ether;
284   // reward supply of token 
285   uint256 public reserveSupply = 3000000 * 1 ether;
286   // bounty supply of token 
287   uint256 public bountySupply = 1000000 * 1 ether;
288   // preSale supply of the token
289   uint256 public preSaleSupply = 8000000 * 1 ether;
290   // preICO supply of token 
291   uint256 public preicoSupply = 8000000 * 1 ether;
292   // ICO supply of token 
293   uint256 public icoSupply = 12300000 * 1 ether;
294   // Remaining Public Supply of token 
295   uint256 public remainingPublicSupply = publicSupply;
296   // Remaining Bounty Supply of token 
297   uint256 public remainingBountySupply = bountySupply;
298   // Remaining company Supply of token 
299   uint256 public remainingReserveSupply = reserveSupply;
300   /**
301    *  @bool checkBurnTokens
302    *  @bool upgradeICOSupply
303    *  @bool grantCompanySupply
304    *  @bool grantAdvisorSupply     
305   */
306   bool public paused = false;
307   bool private checkBurnTokens;
308   bool private upgradePreICOSupply;
309   bool private upgradeICOSupply;
310   bool private grantReserveSupply;
311   bool private grantBountySupply;
312   
313   /**
314    * event for token purchase logging
315    * @param purchaser who paid for the tokens
316    * @param beneficiary who got the tokens
317    * @param value weis paid for purchase
318    * @param amount amount of tokens purchased
319    */
320   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
321   // Goldiam Crowdsale constructor
322   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
323     require(_startTime >= now);
324     require(_endTime >= _startTime);
325     require(_rate > 0);
326     require(_wallet != 0x0);
327     // Goldiam token creation 
328     token = createTokenContract();
329     // Pre-sale start Time
330     preStartTime = _startTime; //1521532800
331     
332     // Pre-sale end time
333      preEndTime = 1522367999;
334     // Pre-ICO start time
335     preIcoStartTime = 1522396800; 
336     // Pre-ICO end time
337     preIcoEndTime = 1523231999; 
338     // // ICO start Time
339      ICOstartTime = 1523260800; 
340     // ICO end Time
341     ICOEndTime = _endTime;
342     // Base Rate of GOL Token
343     rate = _rate;
344     // Multi-sig wallet where funds will be saved
345     wallet = _wallet;
346     /** Calculations of Bonuses in ICO or Pre-ICO */
347     preSaleBonus = SafeMath.div(SafeMath.mul(rate,30),100); 
348     preICOBonus = SafeMath.div(SafeMath.mul(rate,25),100);
349     firstWeekBonus = SafeMath.div(SafeMath.mul(rate,20),100);
350     secondWeekBonus = SafeMath.div(SafeMath.mul(rate,10),100);
351     thirdWeekBonus = SafeMath.div(SafeMath.mul(rate,5),100);
352     /** ICO bonuses week calculations */
353     weekOneStart = 1523260800; 
354     weekOneEnd = 1524095999; 
355     weekTwoStart = 1524124800;
356     weekTwoEnd = 1524916799;
357     weekThreeStart = 1524988800; 
358     weekThreeEnd = 1525823999;
359     lastWeekStart = 1525852800; 
360     lastWeekEnd = 1526687999;
361     checkBurnTokens = false;
362     grantReserveSupply = false;
363     grantBountySupply = false;
364     upgradePreICOSupply = false;
365     upgradeICOSupply = false;
366   }
367   // creates the token to be sold.
368   // override this method to have crowdsale of a specific mintable token.
369   function createTokenContract() internal returns (MintableToken) {
370     return new MintableToken();
371   }
372   
373   // fallback function can be used to buy tokens
374   function () payable {
375     buyTokens(msg.sender);  
376   }
377 modifier whenNotPaused() {
378     require(!paused);
379     _;
380   }
381   modifier whenPaused() {
382     require(paused);
383     _;
384   }
385     /**
386    * @dev called by the owner to pause, triggers stopped state
387    */
388   function pause() onlyOwner whenNotPaused public {
389     paused = true;
390   }
391   /**
392    * @dev called by the owner to unpause, returns to normal state
393    */
394   function unpause() onlyOwner whenPaused public {
395     paused = false;
396   }
397   // High level token purchase function
398   function buyTokens(address beneficiary) whenNotPaused public payable {
399     require(beneficiary != 0x0);
400     require(validPurchase());
401     uint256 weiAmount = msg.value;
402     // minimum investment should be 0.05 ETH 
403     require(weiAmount >= 0.05 * 1 ether);
404     
405     uint256 accessTime = now;
406     uint256 tokens = 0;
407     uint256 supplyTokens = 0;
408     uint256 bonusTokens = 0;
409   // calculating the Pre-Sale, Pre-ICO and ICO bonuses on the basis of timing
410     if ((accessTime >= preStartTime) && (accessTime < preEndTime)) {
411         require(preSaleSupply > 0);
412         
413         bonusTokens = SafeMath.add(bonusTokens, weiAmount.mul(preSaleBonus));
414         supplyTokens = SafeMath.add(supplyTokens, weiAmount.mul(rate));
415         tokens = SafeMath.add(bonusTokens, supplyTokens);
416         
417         require(preSaleSupply >= supplyTokens);
418         require(icoSupply >= bonusTokens);
419         preSaleSupply = preSaleSupply.sub(supplyTokens);
420         icoSupply = icoSupply.sub(bonusTokens);
421         remainingPublicSupply = remainingPublicSupply.sub(tokens);
422     }else if ((accessTime >= preIcoStartTime) && (accessTime < preIcoEndTime)) {
423         if (!upgradePreICOSupply) {
424           preicoSupply = preicoSupply.add(preSaleSupply);
425           upgradePreICOSupply = true;
426         }
427         require(preicoSupply > 0);
428         bonusTokens = SafeMath.add(bonusTokens, weiAmount.mul(preICOBonus));
429         supplyTokens = SafeMath.add(supplyTokens, weiAmount.mul(rate));
430         tokens = SafeMath.add(bonusTokens, supplyTokens);
431         
432         require(preicoSupply >= supplyTokens);
433         require(icoSupply >= bonusTokens);
434         preicoSupply = preicoSupply.sub(supplyTokens);
435         icoSupply = icoSupply.sub(bonusTokens);        
436         remainingPublicSupply = remainingPublicSupply.sub(tokens);
437     } else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) {
438         if (!upgradeICOSupply) {
439           icoSupply = SafeMath.add(icoSupply,preicoSupply);
440           upgradeICOSupply = true;
441         }
442         require(icoSupply > 0);
443         if ( accessTime <= weekOneEnd ) {
444           tokens = SafeMath.add(tokens, weiAmount.mul(firstWeekBonus));
445         } else if (accessTime <= weekTwoEnd) {
446             if(accessTime >= weekTwoStart) {
447               tokens = SafeMath.add(tokens, weiAmount.mul(secondWeekBonus));
448             }else {
449               revert();
450             }
451         } else if ( accessTime <= weekThreeEnd ) {
452             if(accessTime >= weekThreeStart) {
453               tokens = SafeMath.add(tokens, weiAmount.mul(thirdWeekBonus));
454             }else {
455               revert();
456             }
457         } else if ( accessTime <= lastWeekEnd ) {
458             if(accessTime >= lastWeekStart) {
459               tokens = 0;
460             }else {
461               revert();
462             }
463         }
464         
465         tokens = SafeMath.add(tokens, weiAmount.mul(rate));
466         icoSupply = icoSupply.sub(tokens);        
467         remainingPublicSupply = remainingPublicSupply.sub(tokens);
468     } else {
469       revert();
470     }
471     // update state
472     weiRaised = weiRaised.add(weiAmount);
473     // tokens are minting here
474     token.mint(beneficiary, tokens);
475     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
476     // funds are forwarding
477     forwardFunds();
478   }
479   // send ether to the fund collection wallet
480   // override to create custom fund forwarding mechanisms
481   function forwardFunds() internal {
482     wallet.transfer(msg.value);
483   }
484   // @return true if the transaction can buy tokens
485   function validPurchase() internal constant returns (bool) {
486     bool withinPeriod = now >= preStartTime && now <= ICOEndTime;
487     bool nonZeroPurchase = msg.value != 0;
488     return withinPeriod && nonZeroPurchase;
489   }
490   // @return true if crowdsale event has ended
491   function hasEnded() public constant returns (bool) {
492       return now > ICOEndTime;
493   }
494   // @return true if burnToken function has ended
495   function burnToken() onlyOwner whenNotPaused public returns (bool) {
496     require(hasEnded());
497     require(!checkBurnTokens);
498     checkBurnTokens = true;
499     token.burnTokens(remainingPublicSupply);
500     totalSupply = SafeMath.sub(totalSupply, remainingPublicSupply);
501     remainingPublicSupply = 0;
502     preSaleSupply = 0;
503     preicoSupply = 0;
504     icoSupply = 0;
505     return true;
506   }
507   /** 
508      * @return true if bountyFunds function has ended
509   */
510   function bountyFunds() onlyOwner whenNotPaused public { 
511     require(!grantBountySupply);
512     grantBountySupply = true;
513     token.mint(0x4311E7B5a249B8D2CC7CcD98Dc7bE45d8ce94e39, remainingBountySupply);
514     
515     remainingBountySupply = 0;
516   }  
517   /**
518       @return true if grantRewardToken function has ended  
519   */
520     function grantReserveToken() onlyOwner whenNotPaused public {
521     require(!grantReserveSupply);
522     grantReserveSupply = true;
523     token.mint(0x4C355A270bC49A18791905c1016603906461977a, remainingReserveSupply);
524     
525     remainingReserveSupply = 0;
526     
527   }
528 /** 
529    * Function transferToken works to transfer tokens to the specified address on the
530      call of owner within the crowdsale timestamp.
531    * @param beneficiary address where owner wants to transfer tokens
532    * @param tokens value of token
533  */
534   function transferToken(address beneficiary, uint256 tokens) onlyOwner whenNotPaused public {
535     require(ICOEndTime > now);
536     tokens = SafeMath.mul(tokens,1 ether);
537     require(remainingPublicSupply >= tokens);
538     remainingPublicSupply = SafeMath.sub(remainingPublicSupply,tokens);
539     token.mint(beneficiary, tokens);
540   }
541   function getTokenAddress() onlyOwner public returns (address) {
542     return token;
543   }
544   function getPublicSupply() onlyOwner public returns (uint256) {
545     return remainingPublicSupply;
546   }
547 }
548 /**
549  * @title CappedCrowdsale
550  * @dev Extension of Crowdsale with a max amount of funds raised
551  */
552 contract CappedCrowdsale is Crowdsale {
553   using SafeMath for uint256;
554   uint256 public cap;
555   function CappedCrowdsale(uint256 _cap) {
556     require(_cap > 0);
557     cap = _cap;
558   }
559   // overriding Crowdsale#validPurchase to add extra cap logic
560   // @return true if investors can buy at the moment
561   function validPurchase() internal constant returns (bool) {
562     bool withinCap = weiRaised.add(msg.value) <= cap;
563     return super.validPurchase() && withinCap;
564   }
565   // overriding Crowdsale#hasEnded to add cap logic
566   // @return true if crowdsale event has ended
567   function hasEnded() public constant returns (bool) {
568     bool capReached = weiRaised >= cap;
569     return super.hasEnded() || capReached;
570   }
571 }
572 /**
573  * @title FinalizableCrowdsale
574  * @dev Extension of Crowdsale where an owner can do extra work
575  * after finishing.
576  */
577 contract FinalizableCrowdsale is Crowdsale {
578   using SafeMath for uint256;
579   bool isFinalized = false;
580   event Finalized();
581   /**
582    * @dev Must be called after crowdsale ends, to do some extra finalization
583    * work. Calls the contract's finalization function.
584    */
585   function finalize() onlyOwner public {
586     require(!isFinalized);
587     require(hasEnded());
588     finalization();
589     Finalized();
590     isFinalized = true;
591   }
592   /**
593    * @dev Can be overridden to add finalization logic. The overriding function
594    * should call super.finalization() to ensure the chain of finalization is
595    * executed entirely.
596    */
597   function finalization() internal {
598   }
599 }
600 /**
601  * @title RefundVault
602  * @dev This contract is used for storing funds while a crowdsale
603  * is in progress. Supports refunding the money if crowdsale fails,
604  * and forwarding it if crowdsale is successful.
605  */
606 contract RefundVault is Ownable {
607   using SafeMath for uint256;
608   enum State { Active, Refunding, Closed }
609   mapping (address => uint256) public deposited;
610   address public wallet;
611   State public state;
612   event Closed();
613   event RefundsEnabled();
614   event Refunded(address indexed beneficiary, uint256 weiAmount);
615   function RefundVault(address _wallet) {
616     require(_wallet != 0x0);
617     wallet = _wallet;
618     state = State.Active;
619   }
620   function deposit(address investor) onlyOwner public payable {
621     require(state == State.Active);
622     deposited[investor] = deposited[investor].add(msg.value);
623   }
624   function close() onlyOwner public {
625     require(state == State.Active);
626     state = State.Closed;
627     Closed();
628     wallet.transfer(this.balance);
629   }
630   function enableRefunds() onlyOwner public {
631     require(state == State.Active);
632     state = State.Refunding;
633     RefundsEnabled();
634   }
635   function refund(address investor) public {
636     require(state == State.Refunding);
637     uint256 depositedValue = deposited[investor];
638     deposited[investor] = 0;
639     investor.transfer(depositedValue);
640     Refunded(investor, depositedValue);
641   }
642 }
643 /**
644  * @title RefundableCrowdsale
645  * @dev Extension of Crowdsale contract that adds a funding goal, and
646  * the possibility of users getting a refund if goal is not met.
647  * Uses a RefundVault as the crowdsale's vault.
648  */
649 contract RefundableCrowdsale is FinalizableCrowdsale {
650   using SafeMath for uint256;
651   // minimum amount of funds to be raised in weis
652   uint256 public goal;
653   bool private _goalReached = false;
654   // refund vault used to hold funds while crowdsale is running
655   RefundVault private vault;
656   function RefundableCrowdsale(uint256 _goal) {
657     require(_goal > 0);
658     vault = new RefundVault(wallet);
659     goal = _goal;
660   }
661   // We're overriding the fund forwarding from Crowdsale.
662   // In addition to sending the funds, we want to call
663   // the RefundVault deposit function
664   function forwardFunds() internal {
665     vault.deposit.value(msg.value)(msg.sender);
666   }
667   // if crowdsale is unsuccessful, investors can claim refunds here
668   function claimRefund() public {
669     require(isFinalized);
670     require(!goalReached());
671     vault.refund(msg.sender);
672   }
673   // vault finalization task, called when owner calls finalize()
674   function finalization() internal {
675     if (goalReached()) {
676       vault.close();
677     } else {
678       vault.enableRefunds();
679     }
680     super.finalization();
681   }
682   function goalReached() public constant returns (bool) {
683     if (weiRaised >= goal) {
684       _goalReached = true;
685       return true;
686     } else if (_goalReached) {
687       return true;
688     } 
689     else {
690       return false;
691     }
692   }
693   function updateGoalCheck() onlyOwner public {
694     _goalReached = true;
695   }
696   function getVaultAddress() onlyOwner public returns (address) {
697     return vault;
698   }
699 }
700 /**
701  * @title GoldiamToken
702  */
703 contract GoldiamToken is MintableToken {
704   string public constant name = "Goldiam";
705   string public constant symbol = "GOL";
706   uint256 public constant decimals = 18;
707   uint256 public constant _totalSupply = 32300000 * 1 ether;
708   
709 /** Constructor GoldiamToken */
710   function GoldiamToken() {
711     totalSupply = _totalSupply;
712   }
713 }
714 contract GoldiamICO is Crowdsale, CappedCrowdsale, RefundableCrowdsale {
715     uint256 _startTime = 1521532800;
716     uint256 _endTime = 1526687999; 
717     uint256 _rate = 1300;
718     uint256 _goal = 2000 * 1 ether;
719     uint256 _cap = 17000 * 1 ether;
720     address _wallet  = 0x2fdDc70C97b11496d3183F014166BC0849C119d6;   
721     /** Constructor GoldiamICO */
722     function GoldiamICO() 
723     CappedCrowdsale(_cap)
724     FinalizableCrowdsale()
725     RefundableCrowdsale(_goal)
726     Crowdsale(_startTime,_endTime,_rate,_wallet) {
727         
728     }
729     /** GoldiamToken Contract is generating from here */
730     function createTokenContract() internal returns (MintableToken) {
731         return new GoldiamToken();
732     }
733 }