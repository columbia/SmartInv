1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: zeppelin-solidity/contracts/token/BasicToken.sol
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 // File: zeppelin-solidity/contracts/token/ERC20.sol
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender) public view returns (uint256);
98   function transferFrom(address from, address to, uint256 value) public returns (bool);
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // File: zeppelin-solidity/contracts/token/StandardToken.sol
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * @dev https://github.com/ethereum/EIPs/issues/20
110  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amount of tokens to be transferred
122    */
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[_from]);
126     require(_value <= allowed[_from][msg.sender]);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    *
138    * Beware that changing an allowance with this method brings the risk that someone may use both the old
139    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifying the amount of tokens still available for the spender.
156    */
157   function allowance(address _owner, address _spender) public view returns (uint256) {
158     return allowed[_owner][_spender];
159   }
160 
161   /**
162    * approve should be called when allowed[_spender] == 0. To increment
163    * allowed value is better to use this function to avoid 2 calls (and wait until
164    * the first transaction is mined)
165    * From MonolithDAO Token.sol
166    */
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
174     uint oldValue = allowed[msg.sender][_spender];
175     if (_subtractedValue > oldValue) {
176       allowed[msg.sender][_spender] = 0;
177     } else {
178       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179     }
180     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184 }
185 
186 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
187 
188 /**
189  * @title Burnable Token
190  * @dev Token that can be irreversibly burned (destroyed).
191  */
192 contract BurnableToken is StandardToken {
193 
194     event Burn(address indexed burner, uint256 value);
195 
196     /**
197      * @dev Burns a specific amount of tokens.
198      * @param _value The amount of token to be burned.
199      */
200     function burn(uint256 _value) public {
201         require(_value > 0);
202         require(_value <= balances[msg.sender]);
203         // no need to require value <= totalSupply, since that would imply the
204         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
205 
206         address burner = msg.sender;
207         balances[burner] = balances[burner].sub(_value);
208         totalSupply = totalSupply.sub(_value);
209         Burn(burner, _value);
210     }
211 }
212 
213 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
214 
215 /**
216  * @title Ownable
217  * @dev The Ownable contract has an owner address, and provides basic authorization control
218  * functions, this simplifies the implementation of "user permissions".
219  */
220 contract Ownable {
221   address public owner;
222 
223 
224   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226 
227   /**
228    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
229    * account.
230    */
231   function Ownable() public {
232     owner = msg.sender;
233   }
234 
235 
236   /**
237    * @dev Throws if called by any account other than the owner.
238    */
239   modifier onlyOwner() {
240     require(msg.sender == owner);
241     _;
242   }
243 
244 
245   /**
246    * @dev Allows the current owner to transfer control of the contract to a newOwner.
247    * @param newOwner The address to transfer ownership to.
248    */
249   function transferOwnership(address newOwner) public onlyOwner {
250     require(newOwner != address(0));
251     OwnershipTransferred(owner, newOwner);
252     owner = newOwner;
253   }
254 
255 }
256 
257 // File: zeppelin-solidity/contracts/token/MintableToken.sol
258 
259 /**
260  * @title Mintable token
261  * @dev Simple ERC20 Token example, with mintable token creation
262  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
263  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
264  */
265 
266 contract MintableToken is StandardToken, Ownable {
267   event Mint(address indexed to, uint256 amount);
268   event MintFinished();
269 
270   bool public mintingFinished = false;
271 
272 
273   modifier canMint() {
274     require(!mintingFinished);
275     _;
276   }
277 
278   /**
279    * @dev Function to mint tokens
280    * @param _to The address that will receive the minted tokens.
281    * @param _amount The amount of tokens to mint.
282    * @return A boolean that indicates if the operation was successful.
283    */
284   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
285     totalSupply = totalSupply.add(_amount);
286     balances[_to] = balances[_to].add(_amount);
287     Mint(_to, _amount);
288     Transfer(address(0), _to, _amount);
289     return true;
290   }
291 
292   /**
293    * @dev Function to stop minting new tokens.
294    * @return True if the operation was successful.
295    */
296   function finishMinting() onlyOwner canMint public returns (bool) {
297     mintingFinished = true;
298     MintFinished();
299     return true;
300   }
301 }
302 
303 // File: zeppelin-solidity/contracts/token/CappedToken.sol
304 
305 /**
306  * @title Capped token
307  * @dev Mintable token with a token cap.
308  */
309 
310 contract CappedToken is MintableToken {
311 
312   uint256 public cap;
313 
314   function CappedToken(uint256 _cap) public {
315     require(_cap > 0);
316     cap = _cap;
317   }
318 
319   /**
320    * @dev Function to mint tokens
321    * @param _to The address that will receive the minted tokens.
322    * @param _amount The amount of tokens to mint.
323    * @return A boolean that indicates if the operation was successful.
324    */
325   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
326     require(totalSupply.add(_amount) <= cap);
327 
328     return super.mint(_to, _amount);
329   }
330 
331 }
332 
333 // File: contracts/DateCoin.sol
334 
335 contract DateCoin is CappedToken, BurnableToken {
336 
337   string public constant name = "DateCoin ICO Token";
338   string public constant symbol = "DTC";
339   uint256 public constant decimals = 18;
340 
341   function DateCoin(uint256 _cap) public CappedToken(_cap) {
342   }
343 }
344 
345 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
346 
347 /**
348  * @title Crowdsale
349  * @dev Crowdsale is a base contract for managing a token crowdsale.
350  * Crowdsales have a start and end timestamps, where investors can make
351  * token purchases and the crowdsale will assign them tokens based
352  * on a token per ETH rate. Funds collected are forwarded to a wallet
353  * as they arrive.
354  */
355 contract Crowdsale {
356   using SafeMath for uint256;
357 
358   // The token being sold
359   MintableToken public token;
360 
361   // start and end timestamps where investments are allowed (both inclusive)
362   uint256 public startTime;
363   uint256 public endTime;
364 
365   // address where funds are collected
366   address public wallet;
367 
368   // how many token units a buyer gets per wei
369   uint256 public rate;
370 
371   // amount of raised money in wei
372   uint256 public weiRaised;
373 
374   /**
375    * event for token purchase logging
376    * @param purchaser who paid for the tokens
377    * @param beneficiary who got the tokens
378    * @param value weis paid for purchase
379    * @param amount amount of tokens purchased
380    */
381   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
382 
383 
384   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
385     require(_startTime >= now);
386     require(_endTime >= _startTime);
387     require(_rate > 0);
388     require(_wallet != address(0));
389 
390     token = createTokenContract();
391     startTime = _startTime;
392     endTime = _endTime;
393     rate = _rate;
394     wallet = _wallet;
395   }
396 
397   // creates the token to be sold.
398   // override this method to have crowdsale of a specific mintable token.
399   function createTokenContract() internal returns (MintableToken) {
400     return new MintableToken();
401   }
402 
403 
404   // fallback function can be used to buy tokens
405   function () external payable {
406     buyTokens(msg.sender);
407   }
408 
409   // low level token purchase function
410   function buyTokens(address beneficiary) public payable {
411     require(beneficiary != address(0));
412     require(validPurchase());
413 
414     uint256 weiAmount = msg.value;
415 
416     // calculate token amount to be created
417     uint256 tokens = weiAmount.mul(rate);
418 
419     // update state
420     weiRaised = weiRaised.add(weiAmount);
421 
422     token.mint(beneficiary, tokens);
423     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
424 
425     forwardFunds();
426   }
427 
428   // send ether to the fund collection wallet
429   // override to create custom fund forwarding mechanisms
430   function forwardFunds() internal {
431     wallet.transfer(msg.value);
432   }
433 
434   // @return true if the transaction can buy tokens
435   function validPurchase() internal view returns (bool) {
436     bool withinPeriod = now >= startTime && now <= endTime;
437     bool nonZeroPurchase = msg.value != 0;
438     return withinPeriod && nonZeroPurchase;
439   }
440 
441   // @return true if crowdsale event has ended
442   function hasEnded() public view returns (bool) {
443     return now > endTime;
444   }
445 
446 
447 }
448 
449 // File: contracts/DateCoinCrowdsale.sol
450 
451 // DateCoin
452 
453 
454 // Zeppelin
455 
456 
457 
458 contract DateCoinCrowdsale is Crowdsale, Ownable {
459   enum ManualState {
460     WORKING, READY, NONE
461   }
462 
463   uint256 public decimals;
464   uint256 public emission;
465 
466   // Discount border-lines
467   mapping(uint8 => uint256) discountTokens;
468   mapping(address => uint256) pendingOrders;
469 
470   uint256 public totalSupply;
471   address public vault;
472   address public preSaleVault;
473   ManualState public manualState = ManualState.NONE;
474   bool public disabled = true;
475 
476   function DateCoinCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _tokenContractAddress, address _vault, address _preSaleVault) public
477     Crowdsale(_startTime, _endTime, _rate, _wallet)
478   {
479     require(_vault != address(0));
480 
481     vault = _vault;
482     preSaleVault = _preSaleVault;
483 
484     token = DateCoin(_tokenContractAddress);
485     decimals = DateCoin(token).decimals();
486 
487     totalSupply = token.balanceOf(vault);
488 
489     defineDiscountBorderLines();
490   }
491 
492   // overriding Crowdsale#buyTokens
493   function buyTokens(address beneficiary) public payable {
494     require(beneficiary != address(0));
495     require(validPurchase());
496 
497     if (disabled) {
498       pendingOrders[msg.sender] = pendingOrders[msg.sender].add(msg.value);
499       forwardFunds();
500       return;
501     }
502 
503     uint256 weiAmount = msg.value;
504     uint256 sold = totalSold();
505 
506     uint256 tokens;
507 
508     if (sold < _discount(25)) {
509       tokens = _calculateTokens(weiAmount, 25, sold);
510     }
511     else if (sold >= _discount(25) && sold < _discount(20)) {
512       tokens = _calculateTokens(weiAmount, 20, sold);
513     }
514     else if (sold >= _discount(20) && sold < _discount(15)) {
515       tokens = _calculateTokens(weiAmount, 15, sold);
516     }
517     else if (sold >= _discount(15) && sold < _discount(10)) {
518       tokens = _calculateTokens(weiAmount, 10, sold);
519     }
520     else if (sold >= _discount(10) && sold < _discount(5)) {
521       tokens = _calculateTokens(weiAmount, 5, sold);
522     }
523     else {
524       tokens = weiAmount.mul(rate);
525     }
526 
527     // Check limit
528     require(sold.add(tokens) <= totalSupply);
529 
530     weiRaised = weiRaised.add(weiAmount);
531     token.transferFrom(vault, beneficiary, tokens);
532     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
533 
534     forwardFunds();
535   }
536 
537   function totalSold() public view returns(uint256) {
538     return totalSupply.sub(token.balanceOf(vault));
539   }
540 
541   /**
542     * @dev This method is allowed to transfer tokens to _to account
543     * @param _to target account address
544     * @param _amount amout of buying tokens
545     */
546   function transferTokens(address _to, uint256 _amount) public onlyOwner {
547     require(!hasEnded());
548     require(_to != address(0));
549     require(_amount != 0);
550     require(token.balanceOf(vault) >= _amount);
551 
552     token.transferFrom(vault, _to, _amount);
553   }
554 
555   function transferPreSaleTokens(address _to, uint256 tokens) public onlyOwner {
556     require(_to != address(0));
557     require(tokens != 0);
558     require(tokens < token.balanceOf(preSaleVault));
559 
560     token.transferFrom(preSaleVault, _to, tokens);
561   }
562 
563 
564   function transferOwnership(address _newOwner) public onlyOwner {
565     token.transferOwnership(_newOwner);
566   }
567 
568   // This method is used for definition of discountTokens borderlines
569   function defineDiscountBorderLines() internal onlyOwner {
570     discountTokens[25] = 95 * (100000 ether);
571     discountTokens[20] = 285 * (100000 ether);
572     discountTokens[15] = 570 * (100000 ether);
573     discountTokens[10] = 950 * (100000 ether);
574     discountTokens[5] = 1425 * (100000 ether);
575   }
576 
577   /**
578     * @dev overriding Crowdsale#validPurchase to add extra sale limit logic
579     * @return true if investors can buy at the moment
580     */
581   function validPurchase() internal view returns(bool) {
582     uint256 weiValue = msg.value;
583 
584     bool defaultCase = super.validPurchase();
585     bool capCase = token.balanceOf(vault) > 0;
586     bool extraCase = weiValue != 0 && capCase && manualState == ManualState.WORKING;
587     return defaultCase && capCase || extraCase;
588   }
589 
590   /**
591     * @dev overriding Crowdsale#hasEnded to add sale limit logic
592     * @return true if crowdsale event has ended
593     */
594   function hasEnded() public view returns (bool) {
595     if (manualState == ManualState.WORKING) {
596       return false;
597     }
598     else if (manualState == ManualState.READY) {
599       return true;
600     }
601     bool icoLimitReached = token.balanceOf(vault) == 0;
602     return super.hasEnded() || icoLimitReached;
603   }
604 
605   /**
606     * @dev this method allows to finish crowdsale prematurely
607     */
608   function finishCrowdsale() public onlyOwner {
609     manualState = ManualState.READY;
610   }
611 
612 
613   /**
614     * @dev this method allows to start crowdsale prematurely
615     */
616   function startCrowdsale() public onlyOwner {
617     manualState = ManualState.WORKING;
618   }
619 
620   /**
621     * @dev this method allows to drop manual state of contract
622     */
623   function dropManualState() public onlyOwner {
624     manualState = ManualState.NONE;
625   }
626 
627   /**
628     * @dev disable automatically seller
629     */
630   function disableAutoSeller() public onlyOwner {
631     disabled = true;
632   }
633 
634   /**
635     * @dev enable automatically seller
636     */
637   function enableAutoSeller() public onlyOwner {
638     disabled = false;
639   }
640 
641   /**
642     * @dev this method is used for getting information about account pending orders
643     * @param _account which is checked
644     * @return has or not
645     */
646   function hasAccountPendingOrders(address _account) public view returns(bool) {
647     return pendingOrders[_account] > 0;
648   }
649 
650   /**
651     * @dev this method is used for getting account pending value
652     * @param _account which is checked
653     * @return if account doesn't have any pending orders, it will return 0
654     */
655   function getAccountPendingValue(address _account) public view returns(uint256) {
656     return pendingOrders[_account];
657   }
658 
659   function _discount(uint8 _percent) internal view returns (uint256) {
660     return discountTokens[_percent];
661   }
662 
663   function _calculateTokens(uint256 _value, uint8 _off, uint256 _sold) internal view returns (uint256) {
664     uint256 withoutDiscounts = _value.mul(rate);
665     uint256 byDiscount = withoutDiscounts.mul(100).div(100 - _off);
666     if (_sold.add(byDiscount) > _discount(_off)) {
667       uint256 couldBeSold = _discount(_off).sub(_sold);
668       uint256 weiByDiscount = couldBeSold.div(rate).div(100).mul(100 - _off);
669       uint256 weiLefts = _value.sub(weiByDiscount);
670       uint256 withoutDiscountLeft = weiLefts.mul(rate);
671       uint256 byNextDiscount = withoutDiscountLeft.mul(100).div(100 - _off + 5);
672       return couldBeSold.add(byNextDiscount);
673     }
674     return byDiscount;
675   }
676 }