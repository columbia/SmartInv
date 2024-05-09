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
339 contract WELToken is MintableToken, PausableToken {
340   string public constant name = "Welcome Coin";
341   string public constant symbol = "WEL";
342   uint8 public constant decimals = 18;
343 }
344 
345 
346 
347 /**
348  * @title RefundVault
349  * @dev This contract is used for storing funds while a crowdsale
350  * is in progress. Supports refunding the money if crowdsale fails,
351  * and forwarding it if crowdsale is successful.
352  */
353 contract RefundVault is Ownable {
354   using SafeMath for uint256;
355 
356   enum State { Active, Refunding, Closed }
357 
358   mapping (address => uint256) public deposited;
359   address public wallet;
360   State public state;
361 
362   event Closed();
363   event RefundsEnabled();
364   event Refunded(address indexed beneficiary, uint256 weiAmount);
365 
366   function RefundVault(address _wallet) {
367     require(_wallet != 0x0);
368     wallet = _wallet;
369     state = State.Active;
370   }
371 
372   function deposit(address investor) onlyOwner public payable {
373     require(state == State.Active);
374     deposited[investor] = deposited[investor].add(msg.value);
375   }
376 
377   function close() onlyOwner public {
378     require(state == State.Active);
379     state = State.Closed;
380     Closed();
381     wallet.transfer(this.balance);
382   }
383 
384   function enableRefunds() onlyOwner public {
385     require(state == State.Active);
386     state = State.Refunding;
387     RefundsEnabled();
388   }
389 
390   function refund(address investor) public {
391     require(state == State.Refunding);
392     uint256 depositedValue = deposited[investor];
393     deposited[investor] = 0;
394     investor.transfer(depositedValue);
395     Refunded(investor, depositedValue);
396   }
397 }
398 
399 
400 /**
401  * @title Crowdsale
402  * @dev Modified contract for managing a token crowdsale.
403  * WelCoinCrowdsale have pre-sale and main sale periods, where investors can make
404  * token purchases and the crowdsale will assign them tokens based
405  * on a token per ETH rate and the system of bonuses.
406  * Funds collected are forwarded to a wallet as they arrive.
407  * pre-sale and main sale periods both have caps defined in tokens
408  */
409 
410 contract WelCoinCrowdsale is Ownable {
411 
412   using SafeMath for uint256;
413 
414   struct Bonus {
415     uint bonusEndTime;
416     uint timePercent;
417     uint bonusMinAmount;
418     uint amountPercent;
419   }
420 
421   // minimum amount of funds to be raised in weis
422   uint256 public goal;
423 
424   // wel token emission
425   uint256 public tokenEmission;
426 
427   // refund vault used to hold funds while crowdsale is running
428   RefundVault public vault;
429 
430   // true for finalised crowdsale
431   bool public isFinalized;
432 
433   // The token being sold
434   MintableToken public token;
435 
436   // start and end timestamps where pre-investments are allowed (both inclusive)
437   uint256 public preSaleStartTime;
438   uint256 public preSaleEndTime;
439 
440   // start and end timestamps where main-investments are allowed (both inclusive)
441   uint256 public mainSaleStartTime;
442   uint256 public mainSaleEndTime;
443 
444   // maximum amout of wei for pre-sale and main sale
445   uint256 public preSaleWeiCap;
446   uint256 public mainSaleWeiCap;
447 
448   // address where funds are collected
449   address public wallet;
450 
451   // address where final 10% of funds will be collected
452   address public tokenWallet;
453 
454   // how many token units a buyer gets per wei
455   uint256 public rate;
456 
457   // amount of raised money in wei
458   uint256 public weiRaised;
459 
460   Bonus[] public preSaleBonuses;
461   Bonus[] public mainSaleBonuses;
462 
463   uint256 public preSaleMinimumWei;
464   uint256 public mainSaleMinimumWei;
465 
466   uint256 public defaultPercent;
467 
468   /**
469    * event for token purchase logging
470    * @param purchaser who paid for the tokens
471    * @param beneficiary who got the tokens
472    * @param value weis paid for purchase
473    * @param amount amount of tokens purchased
474    */
475   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
476   event FinalisedCrowdsale(uint256 totalSupply, uint256 minterBenefit);
477 
478   function WelCoinCrowdsale(uint256 _preSaleStartTime, uint256 _preSaleEndTime, uint256 _preSaleWeiCap, uint256 _mainSaleStartTime, uint256 _mainSaleEndTime, uint256 _mainSaleWeiCap, uint256 _goal, uint256 _rate, address _wallet, address _tokenWallet) public {
479 
480     //require(_goal > 0);
481 
482     // can't start pre-sale in the past
483     require(_preSaleStartTime >= now);
484 
485     // can't start main sale in the past
486     require(_mainSaleStartTime >= now);
487 
488     // can't start main sale before the end of pre-sale
489     require(_preSaleEndTime < _mainSaleStartTime);
490 
491     // the end of pre-sale can't happen before it's start
492     require(_preSaleStartTime < _preSaleEndTime);
493 
494     // the end of main sale can't happen before it's start
495     require(_mainSaleStartTime < _mainSaleEndTime);
496 
497     require(_rate > 0);
498     require(_preSaleWeiCap > 0);
499     require(_mainSaleWeiCap > 0);
500     require(_wallet != 0x0);
501     require(_tokenWallet != 0x0);
502 
503     preSaleMinimumWei = 300000000000000000;  // 0.3 Ether default minimum
504     mainSaleMinimumWei = 300000000000000000; // 0.3 Ether default minimum
505     defaultPercent = 0;
506 
507     tokenEmission = 150000000 ether;
508 
509     preSaleBonuses.push(Bonus({bonusEndTime: 3600 * 24 * 2, timePercent: 20, bonusMinAmount: 8500 ether, amountPercent: 25}));
510     preSaleBonuses.push(Bonus({bonusEndTime: 3600 * 24 * 4, timePercent: 20, bonusMinAmount: 0, amountPercent: 0}));
511     preSaleBonuses.push(Bonus({bonusEndTime: 3600 * 24 * 6, timePercent: 15, bonusMinAmount: 0, amountPercent: 0}));
512     preSaleBonuses.push(Bonus({bonusEndTime: 3600 * 24 * 7, timePercent: 10, bonusMinAmount: 20000 ether, amountPercent: 15}));
513 
514     mainSaleBonuses.push(Bonus({bonusEndTime: 3600 * 24 * 7,  timePercent: 9, bonusMinAmount: 0, amountPercent: 0}));
515     mainSaleBonuses.push(Bonus({bonusEndTime: 3600 * 24 * 14, timePercent: 6, bonusMinAmount: 0, amountPercent: 0}));
516     mainSaleBonuses.push(Bonus({bonusEndTime: 3600 * 24 * 21, timePercent: 4, bonusMinAmount: 0, amountPercent: 0}));
517     mainSaleBonuses.push(Bonus({bonusEndTime: 3600 * 24 * 28, timePercent: 0, bonusMinAmount: 0, amountPercent: 0}));
518 
519     preSaleStartTime = _preSaleStartTime;
520     preSaleEndTime = _preSaleEndTime;
521     preSaleWeiCap = _preSaleWeiCap;
522     mainSaleStartTime = _mainSaleStartTime;
523     mainSaleEndTime = _mainSaleEndTime;
524     mainSaleWeiCap = _mainSaleWeiCap;
525     goal = _goal;
526     rate = _rate;
527     wallet = _wallet;
528     tokenWallet = _tokenWallet;
529 
530     isFinalized = false;
531 
532     token = new WELToken();
533     vault = new RefundVault(wallet);
534   }
535 
536   // fallback function can be used to buy tokens
537   function () payable {
538     buyTokens(msg.sender);
539   }
540 
541   // low level token purchase function
542   function buyTokens(address beneficiary) public payable {
543 
544     require(beneficiary != 0x0);
545     require(msg.value != 0);
546     require(!isFinalized);
547 
548     uint256 weiAmount = msg.value;
549 
550     validateWithinPeriods();
551     validateWithinCaps(weiAmount);
552 
553     // calculate token amount to be created
554     uint256 tokens = weiAmount.mul(rate);
555 
556     uint256 percent = getBonusPercent(tokens, now);
557 
558     // add bonus to tokens depends on the period
559     uint256 bonusedTokens = applyBonus(tokens, percent);
560 
561     // update state
562     weiRaised = weiRaised.add(weiAmount);
563     token.mint(beneficiary, bonusedTokens);
564     TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
565 
566     forwardFunds();
567   }
568 
569   // owner can mint tokens during crowdsale withing defined caps
570   function mintTokens(address beneficiary, uint256 weiAmount, uint256 forcePercent) external onlyOwner returns (bool) {
571 
572     require(forcePercent <= 100);
573     require(beneficiary != 0x0);
574     require(weiAmount != 0);
575     require(!isFinalized);
576 
577     validateWithinCaps(weiAmount);
578 
579     uint256 percent = 0;
580 
581     // calculate token amount to be created
582     uint256 tokens = weiAmount.mul(rate);
583 
584     if (forcePercent == 0) {
585       percent = getBonusPercent(tokens, now);
586     } else {
587       percent = forcePercent;
588     }
589 
590     // add bonus to tokens depends on the period
591     uint256 bonusedTokens = applyBonus(tokens, percent);
592 
593     // update state
594     weiRaised = weiRaised.add(weiAmount);
595     token.mint(beneficiary, bonusedTokens);
596     TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
597   }
598 
599   // set new dates for pre-salev (emergency case)
600   function setPreSaleParameters(uint256 _preSaleStartTime, uint256 _preSaleEndTime, uint256 _preSaleWeiCap, uint256 _preSaleMinimumWei) public onlyOwner {
601     require(!isFinalized);
602     require(_preSaleStartTime < _preSaleEndTime);
603     require(_preSaleWeiCap > 0);
604     preSaleStartTime = _preSaleStartTime;
605     preSaleEndTime = _preSaleEndTime;
606     preSaleWeiCap = _preSaleWeiCap;
607     preSaleMinimumWei = _preSaleMinimumWei;
608   }
609 
610   // set new dates for main-sale (emergency case)
611   function setMainSaleParameters(uint256 _mainSaleStartTime, uint256 _mainSaleEndTime, uint256 _mainSaleWeiCap, uint256 _mainSaleMinimumWei) public onlyOwner {
612     require(!isFinalized);
613     require(_mainSaleStartTime < _mainSaleEndTime);
614     require(_mainSaleWeiCap > 0);
615     mainSaleStartTime = _mainSaleStartTime;
616     mainSaleEndTime = _mainSaleEndTime;
617     mainSaleWeiCap = _mainSaleWeiCap;
618     mainSaleMinimumWei = _mainSaleMinimumWei;
619   }
620 
621   // set new wallets (emergency case)
622   function setWallets(address _wallet, address _tokenWallet) public onlyOwner {
623     require(!isFinalized);
624     require(_wallet != 0x0);
625     require(_tokenWallet != 0x0);
626     wallet = _wallet;
627     tokenWallet = _tokenWallet;
628   }
629 
630     // set new rate (emergency case)
631   function setRate(uint256 _rate) public onlyOwner {
632     require(!isFinalized);
633     require(_rate > 0);
634     rate = _rate;
635   }
636 
637       // set new goal (emergency case)
638   function setGoal(uint256 _goal) public onlyOwner {
639     require(!isFinalized);
640     require(_goal > 0);
641     goal = _goal;
642   }
643 
644 
645   // set token on pause
646   function pauseToken() external onlyOwner {
647     require(!isFinalized);
648     WELToken(token).pause();
649   }
650 
651   // unset token's pause
652   function unpauseToken() external onlyOwner {
653     WELToken(token).unpause();
654   }
655 
656   // set token Ownership
657   function transferTokenOwnership(address newOwner) external onlyOwner {
658     WELToken(token).transferOwnership(newOwner);
659   }
660 
661   // @return true if main sale event has ended
662   function mainSaleHasEnded() external constant returns (bool) {
663     return now > mainSaleEndTime;
664   }
665 
666   // @return true if pre sale event has ended
667   function preSaleHasEnded() external constant returns (bool) {
668     return now > preSaleEndTime;
669   }
670 
671   // send ether to the fund collection wallet
672   function forwardFunds() internal {
673     //wallet.transfer(msg.value);
674     vault.deposit.value(msg.value)(msg.sender);
675   }
676 
677   // we want to be able to check all bonuses in already deployed contract
678   // that's why we pass currentTime as a parameter instead of using "now"
679   function getBonusPercent(uint256 tokens, uint256 currentTime) public constant returns (uint256 percent) {
680     //require(currentTime >= preSaleStartTime);
681     uint i = 0;
682     bool isPreSale = currentTime >= preSaleStartTime && currentTime <= preSaleEndTime;
683     if (isPreSale) {
684       uint256 preSaleDiffInSeconds = currentTime.sub(preSaleStartTime);
685       for (i = 0; i < preSaleBonuses.length; i++) {
686         if (preSaleDiffInSeconds <= preSaleBonuses[i].bonusEndTime) {
687           if (preSaleBonuses[i].bonusMinAmount > 0 && tokens >= preSaleBonuses[i].bonusMinAmount) {
688             return preSaleBonuses[i].amountPercent;
689           } else {
690             return preSaleBonuses[i].timePercent;
691           }
692         }
693       }
694     } else {
695       uint256 mainSaleDiffInSeconds = currentTime.sub(mainSaleStartTime);
696       for (i = 0; i < mainSaleBonuses.length; i++) {
697         if (mainSaleDiffInSeconds <= mainSaleBonuses[i].bonusEndTime) {
698           if (mainSaleBonuses[i].bonusMinAmount > 0 && tokens >= mainSaleBonuses[i].bonusMinAmount) {
699             return mainSaleBonuses[i].amountPercent;
700           } else {
701             return mainSaleBonuses[i].timePercent;
702           }
703         }
704       }
705     }
706     return defaultPercent;
707   }
708 
709   function applyBonus(uint256 tokens, uint256 percent) internal constant returns (uint256 bonusedTokens) {
710     uint256 tokensToAdd = tokens.mul(percent).div(100);
711     return tokens.add(tokensToAdd);
712   }
713 
714   function validateWithinPeriods() internal constant {
715     // within pre-sale or main sale
716     require((now >= preSaleStartTime && now <= preSaleEndTime) || (now >= mainSaleStartTime && now <= mainSaleEndTime));
717   }
718 
719   function validateWithinCaps(uint256 weiAmount) internal constant {
720     uint256 expectedWeiRaised = weiRaised.add(weiAmount);
721 
722     // within pre-sale
723     if (now >= preSaleStartTime && now <= preSaleEndTime) {
724       require(weiAmount >= preSaleMinimumWei);
725       require(expectedWeiRaised <= preSaleWeiCap);
726     }
727 
728     // within main sale
729     if (now >= mainSaleStartTime && now <= mainSaleEndTime) {
730       require(weiAmount >= mainSaleMinimumWei);
731       require(expectedWeiRaised <= mainSaleWeiCap);
732     }
733   }
734 
735   // if crowdsale is unsuccessful, investors can claim refunds here
736   function claimRefund() public {
737     require(isFinalized);
738     require(!goalReached());
739     vault.refund(msg.sender);
740   }
741 
742   function goalReached() public constant returns (bool) {
743     return weiRaised >= goal;
744   }
745 
746   // finish crowdsale,
747   // take totalSupply as 90% and mint 10% more to specified owner's wallet
748   // then stop minting forever
749 
750   function finaliseCrowdsale() external onlyOwner returns (bool) {
751     require(!isFinalized);
752     uint256 totalSupply = token.totalSupply();
753     uint256 minterBenefit = tokenEmission.sub(totalSupply);
754     if (goalReached()) {
755       token.mint(tokenWallet, minterBenefit);
756       vault.close();
757       //token.finishMinting();
758     } else {
759       vault.enableRefunds();
760     }
761 
762     FinalisedCrowdsale(totalSupply, minterBenefit);
763     isFinalized = true;
764     return true;
765   }
766 
767 }