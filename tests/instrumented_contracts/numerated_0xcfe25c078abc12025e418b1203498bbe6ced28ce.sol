1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract Pausable is Ownable {
41   event Pause();
42   event Unpause();
43 
44   bool public paused = false;
45 
46 
47   /**
48    * @dev Modifier to make a function callable only when the contract is not paused.
49    */
50   modifier whenNotPaused() {
51     require(!paused);
52     _;
53   }
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is paused.
57    */
58   modifier whenPaused() {
59     require(paused);
60     _;
61   }
62 
63   /**
64    * @dev called by the owner to pause, triggers stopped state
65    */
66   function pause() onlyOwner whenNotPaused public {
67     paused = true;
68     Pause();
69   }
70 
71   /**
72    * @dev called by the owner to unpause, returns to normal state
73    */
74   function unpause() onlyOwner whenPaused public {
75     paused = false;
76     Unpause();
77   }
78 }
79 
80 library SafeMath {
81   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
82     uint256 c = a * b;
83     assert(a == 0 || c / a == b);
84     return c;
85   }
86 
87   function div(uint256 a, uint256 b) internal constant returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint256 a, uint256 b) internal constant returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 contract Crowdsale {
107   using SafeMath for uint256;
108 
109   // The token being sold
110   MintableToken public token;
111 
112   // start and end timestamps where investments are allowed (both inclusive)
113   uint256 public startTime;
114   uint256 public endTime;
115 
116   // address where funds are collected
117   address public wallet;
118 
119   // how many token units a buyer gets per wei
120   uint256 public rate;
121 
122   // amount of raised money in wei
123   uint256 public weiRaised;
124 
125   /**
126    * event for token purchase logging
127    * @param purchaser who paid for the tokens
128    * @param beneficiary who got the tokens
129    * @param value weis paid for purchase
130    * @param amount amount of tokens purchased
131    */
132   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
133 
134 
135   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
136     require(_startTime >= now);
137     require(_endTime >= _startTime);
138     require(_rate > 0);
139     require(_wallet != 0x0);
140 
141     token = createTokenContract();
142     startTime = _startTime;
143     endTime = _endTime;
144     rate = _rate;
145     wallet = _wallet;
146   }
147 
148   // creates the token to be sold.
149   // override this method to have crowdsale of a specific mintable token.
150   function createTokenContract() internal returns (MintableToken) {
151     return new MintableToken();
152   }
153 
154 
155   // fallback function can be used to buy tokens
156   function () payable {
157     buyTokens(msg.sender);
158   }
159 
160   // low level token purchase function
161   function buyTokens(address beneficiary) public payable {
162     require(beneficiary != 0x0);
163     require(validPurchase());
164 
165     uint256 weiAmount = msg.value;
166 
167     // calculate token amount to be created
168     uint256 tokens = weiAmount.mul(rate);
169 
170     // update state
171     weiRaised = weiRaised.add(weiAmount);
172 
173     token.mint(beneficiary, tokens);
174     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
175 
176     forwardFunds();
177   }
178 
179   // send ether to the fund collection wallet
180   // override to create custom fund forwarding mechanisms
181   function forwardFunds() internal {
182     wallet.transfer(msg.value);
183   }
184 
185   // @return true if the transaction can buy tokens
186   function validPurchase() internal constant returns (bool) {
187     bool withinPeriod = now >= startTime && now <= endTime;
188     bool nonZeroPurchase = msg.value != 0;
189     return withinPeriod && nonZeroPurchase;
190   }
191 
192   // @return true if crowdsale event has ended
193   function hasEnded() public constant returns (bool) {
194     return now > endTime;
195   }
196 
197 
198 }
199 
200 contract CappedCrowdsale is Crowdsale {
201   using SafeMath for uint256;
202 
203   uint256 public cap;
204 
205   function CappedCrowdsale(uint256 _cap) {
206     require(_cap > 0);
207     cap = _cap;
208   }
209 
210   // overriding Crowdsale#validPurchase to add extra cap logic
211   // @return true if investors can buy at the moment
212   function validPurchase() internal constant returns (bool) {
213     bool withinCap = weiRaised.add(msg.value) <= cap;
214     return super.validPurchase() && withinCap;
215   }
216 
217   // overriding Crowdsale#hasEnded to add cap logic
218   // @return true if crowdsale event has ended
219   function hasEnded() public constant returns (bool) {
220     bool capReached = weiRaised >= cap;
221     return super.hasEnded() || capReached;
222   }
223 
224 }
225 
226 contract ERC20Basic {
227   uint256 public totalSupply;
228   function balanceOf(address who) public constant returns (uint256);
229   function transfer(address to, uint256 value) public returns (bool);
230   event Transfer(address indexed from, address indexed to, uint256 value);
231 }
232 
233 contract ERC20 is ERC20Basic {
234   function allowance(address owner, address spender) public constant returns (uint256);
235   function transferFrom(address from, address to, uint256 value) public returns (bool);
236   function approve(address spender, uint256 value) public returns (bool);
237   event Approval(address indexed owner, address indexed spender, uint256 value);
238 }
239 
240 contract RefundVault is Ownable {
241   using SafeMath for uint256;
242 
243   enum State { Active, Refunding, Closed }
244 
245   mapping (address => uint256) public deposited;
246   address public wallet;
247   State public state;
248 
249   event Closed();
250   event RefundsEnabled();
251   event Refunded(address indexed beneficiary, uint256 weiAmount);
252 
253   function RefundVault(address _wallet) {
254     require(_wallet != 0x0);
255     wallet = _wallet;
256     state = State.Active;
257   }
258 
259   function deposit(address investor) onlyOwner public payable {
260     require(state == State.Active);
261     deposited[investor] = deposited[investor].add(msg.value);
262   }
263 
264   function close() onlyOwner public {
265     require(state == State.Active);
266     state = State.Closed;
267     Closed();
268     wallet.transfer(this.balance);
269   }
270 
271   function enableRefunds() onlyOwner public {
272     require(state == State.Active);
273     state = State.Refunding;
274     RefundsEnabled();
275   }
276 
277   function refund(address investor) public {
278     require(state == State.Refunding);
279     uint256 depositedValue = deposited[investor];
280     deposited[investor] = 0;
281     investor.transfer(depositedValue);
282     Refunded(investor, depositedValue);
283   }
284 }
285 
286 contract FinalizableCrowdsale is Crowdsale, Ownable {
287   using SafeMath for uint256;
288 
289   bool public isFinalized = false;
290 
291   event Finalized();
292 
293   /**
294    * @dev Must be called after crowdsale ends, to do some extra finalization
295    * work. Calls the contract's finalization function.
296    */
297   function finalize() onlyOwner public {
298     require(!isFinalized);
299     require(hasEnded());
300 
301     finalization();
302     Finalized();
303 
304     isFinalized = true;
305   }
306 
307   /**
308    * @dev Can be overridden to add finalization logic. The overriding function
309    * should call super.finalization() to ensure the chain of finalization is
310    * executed entirely.
311    */
312   function finalization() internal {
313   }
314 }
315 
316 contract RefundableCrowdsale is FinalizableCrowdsale {
317   using SafeMath for uint256;
318 
319   // minimum amount of funds to be raised in weis
320   uint256 public goal;
321 
322   // refund vault used to hold funds while crowdsale is running
323   RefundVault public vault;
324 
325   function RefundableCrowdsale(uint256 _goal) {
326     require(_goal > 0);
327     vault = new RefundVault(wallet);
328     goal = _goal;
329   }
330 
331   // We're overriding the fund forwarding from Crowdsale.
332   // In addition to sending the funds, we want to call
333   // the RefundVault deposit function
334   function forwardFunds() internal {
335     vault.deposit.value(msg.value)(msg.sender);
336   }
337 
338   // if crowdsale is unsuccessful, investors can claim refunds here
339   function claimRefund() public {
340     require(isFinalized);
341     require(!goalReached());
342 
343     vault.refund(msg.sender);
344   }
345 
346   // vault finalization task, called when owner calls finalize()
347   function finalization() internal {
348     if (goalReached()) {
349       vault.close();
350     } else {
351       vault.enableRefunds();
352     }
353 
354     super.finalization();
355   }
356 
357   function goalReached() public constant returns (bool) {
358     return weiRaised >= goal;
359   }
360 
361 }
362 
363 contract AmpleCoinCrowdsale is Crowdsale, Ownable, RefundableCrowdsale, CappedCrowdsale, Pausable {
364 
365   uint256 constant RATE_PRE_SALE = 1650;
366   uint256 constant VOLUME_DISCOUNT_FIRST = 150 ether;
367   uint256 constant VOLUME_DISCOUNT_SECOND = 300 ether;
368 
369   uint256 public presaleStartTime;
370   uint256 public presaleEndTime;
371   uint256 public tokensaleStartTime;
372   uint256 public tokensaleEndTime;
373   uint256 public tokenCap;
374 
375   function AmpleCoinCrowdsale(
376   uint256 _startTime,
377   uint256 _endTime,
378   uint256 _presaleStartTime,
379   uint256 _presaleEndTime,
380   uint256 _tokensaleStartTime,
381   uint256 _tokensaleEndTime,
382   uint256 _baseRate,
383   address _walletAmpleCoinFund,
384   address _walletPremiumWallet,
385   uint256 _cap,
386   uint256 _tokenCap,
387   uint256 _initialAmpleCoinFundBalance,
388   uint256 _initialPremiumWalletBalance,
389   uint256 _goal
390   )
391   Crowdsale(_startTime, _endTime, _baseRate, _walletAmpleCoinFund)
392   CappedCrowdsale(_cap)
393   RefundableCrowdsale(_goal)
394   {
395     presaleStartTime = _presaleStartTime;
396     presaleEndTime = _presaleEndTime;
397     tokensaleStartTime = _tokensaleStartTime;
398     tokensaleEndTime = _tokensaleEndTime;
399     tokenCap = _tokenCap;
400 
401     token.mint(_walletAmpleCoinFund, _initialAmpleCoinFundBalance);
402     token.mint(_walletPremiumWallet, _initialPremiumWalletBalance);
403   }
404 
405   function createTokenContract() internal returns (MintableToken) {
406     return new AmpleCoinToken();
407   }
408 
409   function validPurchase() internal constant returns (bool) {
410     bool withinTokenCap = token.totalSupply().add(msg.value.mul(getRate())) <= tokenCap;
411     return super.validPurchase() && withinTokenCap;
412   }
413 
414   function hasEnded() public constant returns (bool) {
415     bool tokenCapReached = token.totalSupply() >= tokenCap;
416     return super.hasEnded() || tokenCapReached;
417   }
418 
419   function finalization() internal {
420     token.transferOwnership(wallet);
421 
422     if (goalReached()) {
423       vault.close();
424     } else {
425       vault.enableRefunds();
426     }
427   }
428 
429   function buyTokens(address beneficiary) payable {
430     require(!paused);
431     require(beneficiary != 0x0);
432     require(validPurchase());
433     require(saleAccepting());
434 
435     uint256 weiAmount = msg.value;
436 
437     uint256 tokens = weiAmount.mul(getRate());
438 
439     weiRaised = weiRaised.add(weiAmount);
440 
441     token.mint(beneficiary, tokens);
442     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
443 
444     forwardFunds();
445   }
446 
447   function getRate() constant returns (uint256) {
448     uint256 currentRate = rate;
449 
450     if (isPresale()) {
451       currentRate = RATE_PRE_SALE;
452     }
453 
454     if (isVolumeDiscountSecond()) {
455       currentRate = currentRate.add(currentRate.mul(20).div(100));
456     } else if (isVolumeDiscountFirst()) {
457       currentRate = currentRate.add(currentRate.mul(10).div(100));
458     }
459 
460     return currentRate;
461   }
462 
463   function isPresale() internal constant returns (bool) {
464     return presaleStartTime <= now && now <= presaleEndTime;
465   }
466 
467   function isTokensale() internal constant returns (bool) {
468     return tokensaleStartTime <= now && now <= tokensaleEndTime;
469   }
470 
471   function saleAccepting() internal constant returns (bool) {
472     return !isDowntime();
473   }
474 
475   function isDowntime() internal constant returns (bool) {
476     return !isPresale() && !isTokensale();
477   }
478 
479   function isVolumeDiscountFirst() internal constant returns (bool) {
480     return VOLUME_DISCOUNT_FIRST <= msg.value;
481   }
482 
483   function isVolumeDiscountSecond() internal constant returns (bool) {
484     return VOLUME_DISCOUNT_SECOND <= msg.value;
485   }
486 }
487 
488 contract BasicToken is ERC20Basic {
489   using SafeMath for uint256;
490 
491   mapping(address => uint256) balances;
492 
493   /**
494   * @dev transfer token for a specified address
495   * @param _to The address to transfer to.
496   * @param _value The amount to be transferred.
497   */
498   function transfer(address _to, uint256 _value) public returns (bool) {
499     require(_to != address(0));
500 
501     // SafeMath.sub will throw if there is not enough balance.
502     balances[msg.sender] = balances[msg.sender].sub(_value);
503     balances[_to] = balances[_to].add(_value);
504     Transfer(msg.sender, _to, _value);
505     return true;
506   }
507 
508   /**
509   * @dev Gets the balance of the specified address.
510   * @param _owner The address to query the the balance of.
511   * @return An uint256 representing the amount owned by the passed address.
512   */
513   function balanceOf(address _owner) public constant returns (uint256 balance) {
514     return balances[_owner];
515   }
516 
517 }
518 
519 contract StandardToken is ERC20, BasicToken {
520 
521   mapping (address => mapping (address => uint256)) allowed;
522 
523 
524   /**
525    * @dev Transfer tokens from one address to another
526    * @param _from address The address which you want to send tokens from
527    * @param _to address The address which you want to transfer to
528    * @param _value uint256 the amount of tokens to be transferred
529    */
530   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
531     require(_to != address(0));
532 
533     uint256 _allowance = allowed[_from][msg.sender];
534 
535     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
536     // require (_value <= _allowance);
537 
538     balances[_from] = balances[_from].sub(_value);
539     balances[_to] = balances[_to].add(_value);
540     allowed[_from][msg.sender] = _allowance.sub(_value);
541     Transfer(_from, _to, _value);
542     return true;
543   }
544 
545   /**
546    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
547    *
548    * Beware that changing an allowance with this method brings the risk that someone may use both the old
549    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
550    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
551    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
552    * @param _spender The address which will spend the funds.
553    * @param _value The amount of tokens to be spent.
554    */
555   function approve(address _spender, uint256 _value) public returns (bool) {
556     allowed[msg.sender][_spender] = _value;
557     Approval(msg.sender, _spender, _value);
558     return true;
559   }
560 
561   /**
562    * @dev Function to check the amount of tokens that an owner allowed to a spender.
563    * @param _owner address The address which owns the funds.
564    * @param _spender address The address which will spend the funds.
565    * @return A uint256 specifying the amount of tokens still available for the spender.
566    */
567   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
568     return allowed[_owner][_spender];
569   }
570 
571   /**
572    * approve should be called when allowed[_spender] == 0. To increment
573    * allowed value is better to use this function to avoid 2 calls (and wait until
574    * the first transaction is mined)
575    * From MonolithDAO Token.sol
576    */
577   function increaseApproval (address _spender, uint _addedValue)
578     returns (bool success) {
579     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
580     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
581     return true;
582   }
583 
584   function decreaseApproval (address _spender, uint _subtractedValue)
585     returns (bool success) {
586     uint oldValue = allowed[msg.sender][_spender];
587     if (_subtractedValue > oldValue) {
588       allowed[msg.sender][_spender] = 0;
589     } else {
590       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
591     }
592     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
593     return true;
594   }
595 
596 }
597 
598 contract BurnableToken is StandardToken {
599 
600     event Burn(address indexed burner, uint256 value);
601 
602     /**
603      * @dev Burns a specific amount of tokens.
604      * @param _value The amount of token to be burned.
605      */
606     function burn(uint256 _value) public {
607         require(_value > 0);
608 
609         address burner = msg.sender;
610         balances[burner] = balances[burner].sub(_value);
611         totalSupply = totalSupply.sub(_value);
612         Burn(burner, _value);
613     }
614 }
615 
616 contract MintableToken is StandardToken, Ownable {
617   event Mint(address indexed to, uint256 amount);
618   event MintFinished();
619 
620   bool public mintingFinished = false;
621 
622 
623   modifier canMint() {
624     require(!mintingFinished);
625     _;
626   }
627 
628   /**
629    * @dev Function to mint tokens
630    * @param _to The address that will receive the minted tokens.
631    * @param _amount The amount of tokens to mint.
632    * @return A boolean that indicates if the operation was successful.
633    */
634   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
635     totalSupply = totalSupply.add(_amount);
636     balances[_to] = balances[_to].add(_amount);
637     Mint(_to, _amount);
638     Transfer(0x0, _to, _amount);
639     return true;
640   }
641 
642   /**
643    * @dev Function to stop minting new tokens.
644    * @return True if the operation was successful.
645    */
646   function finishMinting() onlyOwner public returns (bool) {
647     mintingFinished = true;
648     MintFinished();
649     return true;
650   }
651 }
652 
653 contract AmpleCoinToken is BasicToken, BurnableToken, MintableToken {
654   using SafeMath for uint256;
655 
656   string public constant name = 'AMPLE! Coin';
657 
658   string public constant symbol = 'ACO';
659 
660   // Using same decimal value as ETH
661   uint public constant decimals = 18;
662 }