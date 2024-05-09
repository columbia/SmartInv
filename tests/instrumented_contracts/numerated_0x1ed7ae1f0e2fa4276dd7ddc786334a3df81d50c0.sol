1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99   address public owner;
100 
101 
102   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   function Ownable() {
110     owner = msg.sender;
111   }
112 
113 
114   /**
115    * @dev Throws if called by any account other than the owner.
116    */
117   modifier onlyOwner() {
118     require(msg.sender == owner);
119     _;
120   }
121 
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address newOwner) onlyOwner public {
128     require(newOwner != address(0));
129     OwnershipTransferred(owner, newOwner);
130     owner = newOwner;
131   }
132 
133 }
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176 
177     // To change the approve amount you first have to reduce the addresses`
178     //  allowance to zero by calling `approve(_spender, 0)` if it is not
179     //  already 0 to mitigate the race condition described here:
180     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
182 
183     allowed[msg.sender][_spender] = _value;
184     Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    */
204   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
205     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 
224 
225 
226 /**
227  * @title Mintable token
228  * @dev Simple ERC20 Token example, with mintable token creation
229  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
230  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
231  */
232 
233 contract MintableToken is StandardToken, Ownable {
234   event Mint(address indexed to, uint256 amount);
235   event MintFinished();
236 
237   bool public mintingFinished = false;
238 
239 
240   modifier canMint() {
241     require(!mintingFinished);
242     _;
243   }
244 
245   /**
246    * @dev Function to mint tokens
247    * @param _to The address that will receive the minted tokens.
248    * @param _amount The amount of tokens to mint.
249    * @return A boolean that indicates if the operation was successful.
250    */
251   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
252     totalSupply = totalSupply.add(_amount);
253     balances[_to] = balances[_to].add(_amount);
254     Mint(_to, _amount);
255     Transfer(0x0, _to, _amount);
256     return true;
257   }
258 
259   /**
260    * @dev Function to stop minting new tokens.
261    * @return True if the operation was successful.
262    */
263   function finishMinting() onlyOwner public returns (bool) {
264     mintingFinished = true;
265     MintFinished();
266     return true;
267   }
268 }
269 
270 
271 /**
272  * @title Pausable
273  * @dev Base contract which allows children to implement an emergency stop mechanism.
274  */
275 contract Pausable is Ownable {
276   event Pause();
277   event Unpause();
278 
279   bool public paused = false;
280 
281 
282   /**
283    * @dev Modifier to make a function callable only when the contract is not paused.
284    */
285   modifier whenNotPaused() {
286     require(!paused);
287     _;
288   }
289 
290   /**
291    * @dev Modifier to make a function callable only when the contract is paused.
292    */
293   modifier whenPaused() {
294     require(paused);
295     _;
296   }
297 
298   /**
299    * @dev called by the owner to pause, triggers stopped state
300    */
301   function pause() onlyOwner whenNotPaused public {
302     paused = true;
303     Pause();
304   }
305 
306   /**
307    * @dev called by the owner to unpause, returns to normal state
308    */
309   function unpause() onlyOwner whenPaused public {
310     paused = false;
311     Unpause();
312   }
313 }
314 
315 contract PausableToken is StandardToken, Pausable {
316 
317   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
318     return super.transfer(_to, _value);
319   }
320 
321   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
322     return super.transferFrom(_from, _to, _value);
323   }
324 
325   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
326     return super.approve(_spender, _value);
327   }
328 
329   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
330     return super.increaseApproval(_spender, _addedValue);
331   }
332 
333   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
334     return super.decreaseApproval(_spender, _subtractedValue);
335   }
336 }
337 
338 
339 contract FSBToken is MintableToken, PausableToken {
340   string public constant name = "Forty Seven Bank Token";
341   string public constant symbol = "FSBT";
342   uint8 public constant decimals = 18;
343   string public constant version = "H0.1"; //human 0.1 standard. Just an arbitrary versioning scheme.
344 }
345 
346 /**
347  * @title Crowdsale
348  * @dev Modified contract for managing a token crowdsale.
349  * FourtySevenTokenCrowdsale have pre-sale and main sale periods, where investors can make
350  * token purchases and the crowdsale will assign them tokens based
351  * on a token per ETH rate and the system of bonuses.
352  * Funds collected are forwarded to a wallet as they arrive.
353  * pre-sale and main sale periods both have caps defined in tokens
354  */
355 
356 contract FourtySevenTokenCrowdsale is Ownable {
357   using SafeMath for uint256;
358 
359   struct TimeBonus {
360     uint256 bonusPeriodEndTime;
361     uint percent;
362     bool isAmountDependent;
363   }
364 
365   struct AmountBonus {
366     uint256 amount;
367     uint percent;
368   }
369 
370   // true for finalised crowdsale
371   bool public isFinalised;
372 
373   // The token being sold
374   MintableToken public token;
375 
376   // start and end timestamps where pre-investments are allowed (both inclusive)
377   uint256 public preSaleStartTime;
378   uint256 public preSaleEndTime;
379 
380   // start and end timestamps where main-investments are allowed (both inclusive)
381   uint256 public mainSaleStartTime;
382   uint256 public mainSaleEndTime;
383 
384   // maximum amout of wei for pre-sale and main sale
385   uint256 public preSaleWeiCap;
386   uint256 public mainSaleWeiCap;
387 
388   // address where funds are collected
389   address public wallet;
390 
391   // address where final 10% of funds will be collected
392   address public tokenWallet;
393 
394   // how many token units a buyer gets per wei
395   uint256 public rate;
396 
397   // amount of raised money in wei
398   uint256 public weiRaised;
399 
400   TimeBonus[] public timeBonuses;
401   AmountBonus[] public amountBonuses;
402 
403   uint256 public preSaleBonus;
404   uint256 public preSaleMinimumWei;
405   uint256 public defaultPercent;
406 
407   /**
408    * event for token purchase logging
409    * @param purchaser who paid for the tokens
410    * @param beneficiary who got the tokens
411    * @param value weis paid for purchase
412    * @param amount amount of tokens purchased
413    */
414   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
415   event FinalisedCrowdsale(uint256 totalSupply, uint256 minterBenefit);
416 
417   function FourtySevenTokenCrowdsale(uint256 _preSaleStartTime, uint256 _preSaleEndTime, uint256 _preSaleWeiCap, uint256 _mainSaleStartTime, uint256 _mainSaleEndTime, uint256 _mainSaleWeiCap, uint256 _rate, address _wallet, address _tokenWallet) public {
418 
419     // can't start pre-sale in the past
420     require(_preSaleStartTime >= now);
421 
422     // can't start main sale in the past
423     require(_mainSaleStartTime >= now);
424 
425     // can't start main sale before the end of pre-sale
426     require(_preSaleEndTime < _mainSaleStartTime);
427 
428     // the end of pre-sale can't happen before it's start
429     require(_preSaleStartTime < _preSaleEndTime);
430 
431     // the end of main sale can't happen before it's start
432     require(_mainSaleStartTime < _mainSaleEndTime);
433 
434     require(_rate > 0);
435     require(_preSaleWeiCap > 0);
436     require(_mainSaleWeiCap > 0);
437     require(_wallet != 0x0);
438     require(_tokenWallet != 0x0);
439 
440     preSaleBonus = 30;
441     preSaleMinimumWei = 4700000000000000000;
442     defaultPercent = 0;
443 
444     timeBonuses.push(TimeBonus(86400 * 3, 15, false));
445     timeBonuses.push(TimeBonus(86400 * 7, 10, false));
446     timeBonuses.push(TimeBonus(86400 * 14, 5, false));
447     timeBonuses.push(TimeBonus(86400 * 28, 0, true));
448 
449     amountBonuses.push(AmountBonus(25000 ether, 15));
450     amountBonuses.push(AmountBonus(5000 ether, 10));
451     amountBonuses.push(AmountBonus(2500 ether, 5));
452     amountBonuses.push(AmountBonus(500 ether, 2));
453 
454     token = createTokenContract();
455 
456     preSaleStartTime = _preSaleStartTime;
457     preSaleEndTime = _preSaleEndTime;
458     preSaleWeiCap = _preSaleWeiCap;
459     mainSaleStartTime = _mainSaleStartTime;
460     mainSaleEndTime = _mainSaleEndTime;
461     mainSaleWeiCap = _mainSaleWeiCap;
462     rate = _rate;
463     wallet = _wallet;
464     tokenWallet = _tokenWallet;
465     isFinalised = false;
466   }
467 
468   // creates the token to be sold.
469   // override this method to have crowdsale of a specific mintable token.
470   function createTokenContract() internal returns (MintableToken) {
471     return new FSBToken();
472   }
473 
474   // fallback function can be used to buy tokens
475   function () payable {
476     buyTokens(msg.sender);
477   }
478 
479   // low level token purchase function
480   function buyTokens(address beneficiary) public payable {
481 
482     require(beneficiary != 0x0);
483     require(msg.value != 0);
484     require(!isFinalised);
485 
486     uint256 weiAmount = msg.value;
487 
488     validateWithinPeriods();
489     validateWithinCaps(weiAmount);
490 
491     // calculate token amount to be created
492     uint256 tokens = weiAmount.mul(rate);
493 
494     uint256 percent = getBonusPercent(tokens, now);
495 
496     // add bonus to tokens depends on the period
497     uint256 bonusedTokens = applyBonus(tokens, percent);
498 
499     // update state
500     weiRaised = weiRaised.add(weiAmount);
501     token.mint(beneficiary, bonusedTokens);
502     TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
503 
504     forwardFunds();
505   }
506 
507   // owner can mint tokens during crowdsale withing defined caps
508   function mintTokens(address beneficiary, uint256 weiAmount, uint256 forcePercent) external onlyOwner returns (bool) {
509 
510     require(forcePercent <= 100);
511     require(beneficiary != 0x0);
512     require(weiAmount != 0);
513     require(!isFinalised);
514 
515     validateWithinCaps(weiAmount);
516 
517     uint256 percent = 0;
518 
519     // calculate token amount to be created
520     uint256 tokens = weiAmount.mul(rate);
521 
522     if (forcePercent == 0) {
523       percent = getBonusPercent(tokens, now);
524     } else {
525       percent = forcePercent;
526     }
527 
528     // add bonus to tokens depends on the period
529     uint256 bonusedTokens = applyBonus(tokens, percent);
530 
531     // update state
532     weiRaised = weiRaised.add(weiAmount);
533     token.mint(beneficiary, bonusedTokens);
534     TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
535   }
536 
537   // finish crowdsale,
538   // take totalSupply as 90% and mint 10% more to specified owner's wallet
539   // then stop minting forever
540 
541   function finaliseCrowdsale() external onlyOwner {
542     require(!isFinalised);
543     uint256 totalSupply = token.totalSupply();
544     uint256 minterBenefit = totalSupply.mul(10).div(90);
545     token.mint(tokenWallet, minterBenefit);
546     token.finishMinting();
547     FinalisedCrowdsale(totalSupply, minterBenefit);
548     isFinalised = true;
549   }
550 
551   // set new dates for pre-salev (emergency case)
552   function setPreSaleParameters(uint256 _preSaleStartTime, uint256 _preSaleEndTime, uint256 _preSaleWeiCap, uint256 _preSaleBonus, uint256 _preSaleMinimumWei) public onlyOwner {
553     require(!isFinalised);
554     require(_preSaleStartTime < _preSaleEndTime);
555     require(_preSaleWeiCap > 0);
556     preSaleStartTime = _preSaleStartTime;
557     preSaleEndTime = _preSaleEndTime;
558     preSaleWeiCap = _preSaleWeiCap;
559     preSaleBonus = _preSaleBonus;
560     preSaleMinimumWei = _preSaleMinimumWei;
561   }
562 
563   // set new dates for main-sale (emergency case)
564   function setMainSaleParameters(uint256 _mainSaleStartTime, uint256 _mainSaleEndTime, uint256 _mainSaleWeiCap) public onlyOwner {
565     require(!isFinalised);
566     require(_mainSaleStartTime < _mainSaleEndTime);
567     require(_mainSaleWeiCap > 0);
568     mainSaleStartTime = _mainSaleStartTime;
569     mainSaleEndTime = _mainSaleEndTime;
570     mainSaleWeiCap = _mainSaleWeiCap;
571   }
572 
573   // set new wallets (emergency case)
574   function setWallets(address _wallet, address _tokenWallet) public onlyOwner {
575     require(!isFinalised);
576     require(_wallet != 0x0);
577     require(_tokenWallet != 0x0);
578     wallet = _wallet;
579     tokenWallet = _tokenWallet;
580   }
581 
582   // set new rate (emergency case)
583   function setRate(uint256 _rate) public onlyOwner {
584     require(!isFinalised);
585     require(_rate > 0);
586     rate = _rate;
587   }
588 
589   // set token on pause
590   function pauseToken() external onlyOwner {
591     require(!isFinalised);
592     FSBToken(token).pause();
593   }
594 
595   // unset token's pause
596   function unpauseToken() external onlyOwner {
597     FSBToken(token).unpause();
598   }
599 
600     // set token Ownership
601   function transferTokenOwnership(address newOwner) external onlyOwner {
602     FSBToken(token).transferOwnership(newOwner);
603   }
604 
605   // @return true if main sale event has ended
606   function mainSaleHasEnded() external constant returns (bool) {
607     return now > mainSaleEndTime;
608   }
609 
610   // @return true if pre sale event has ended
611   function preSaleHasEnded() external constant returns (bool) {
612     return now > preSaleEndTime;
613   }
614 
615   // send ether to the fund collection wallet
616   function forwardFunds() internal {
617     wallet.transfer(msg.value);
618   }
619 
620   // we want to be able to check all bonuses in already deployed contract
621   // that's why we pass currentTime as a parameter instead of using "now"
622 
623   function getBonusPercent(uint256 tokens, uint256 currentTime) public constant returns (uint256 percent) {
624     //require(currentTime >= preSaleStartTime);
625     bool isPreSale = currentTime >= preSaleStartTime && currentTime <= preSaleEndTime;
626     if (isPreSale) {
627       return preSaleBonus;
628     } else {
629       uint256 diffInSeconds = currentTime.sub(mainSaleStartTime);
630       for (uint i = 0; i < timeBonuses.length; i++) {
631         if (diffInSeconds <= timeBonuses[i].bonusPeriodEndTime && !timeBonuses[i].isAmountDependent) {
632           return timeBonuses[i].percent;
633         } else if (timeBonuses[i].isAmountDependent) {
634           for (uint j = 0; j < amountBonuses.length; j++) {
635             if (tokens >= amountBonuses[j].amount) {
636               return amountBonuses[j].percent;
637             }
638           }
639         }
640       }
641     }
642     return defaultPercent;
643   }
644 
645   function applyBonus(uint256 tokens, uint256 percent) internal constant returns (uint256 bonusedTokens) {
646     uint256 tokensToAdd = tokens.mul(percent).div(100);
647     return tokens.add(tokensToAdd);
648   }
649 
650   function validateWithinPeriods() internal constant {
651     // within pre-sale or main sale
652     require((now >= preSaleStartTime && now <= preSaleEndTime) || (now >= mainSaleStartTime && now <= mainSaleEndTime));
653   }
654 
655   function validateWithinCaps(uint256 weiAmount) internal constant {
656     uint256 expectedWeiRaised = weiRaised.add(weiAmount);
657 
658     // within pre-sale
659     if (now >= preSaleStartTime && now <= preSaleEndTime) {
660       require(weiAmount >= preSaleMinimumWei);
661       require(expectedWeiRaised <= preSaleWeiCap);
662     }
663 
664     // within main sale
665     if (now >= mainSaleStartTime && now <= mainSaleEndTime) {
666       require(expectedWeiRaised <= mainSaleWeiCap);
667     }
668   }
669 
670 }