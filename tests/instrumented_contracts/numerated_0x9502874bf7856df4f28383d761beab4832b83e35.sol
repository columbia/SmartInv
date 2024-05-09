1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic, Ownable {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256 balance) {
117     return balances[_owner];
118   }
119   
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public onlyOwner {
127     require(_value <= balances[msg.sender]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130     uint256 tokensToBurn = SafeMath.mul(_value,1000000000000000000);
131     address burner = msg.sender;
132     balances[burner] = balances[burner].sub(tokensToBurn);
133     totalSupply_ = totalSupply_.sub(tokensToBurn);
134     Burn(burner, tokensToBurn);
135   }
136 
137 }
138 
139 
140 
141 
142 
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 
253 
254 /**
255  * @title Mintable token
256  * @dev Simple ERC20 Token example, with mintable token creation
257  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
258  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
259  */
260 contract MintableToken is StandardToken {
261   event Mint(address indexed to, uint256 amount);
262   event MintFinished();
263 
264   bool public mintingFinished = false;
265   
266   uint256 public cap = 30000000000000000000000000; //30M token cap
267 
268 
269   modifier canMint() {
270     require(!mintingFinished);
271     _;
272   }
273 
274   /**
275    * @dev Function to mint tokens
276    * @param _to The address that will receive the minted tokens.
277    * @param _amount The amount of tokens to mint.
278    * @return A boolean that indicates if the operation was successful.
279    */
280   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
281     require(totalSupply_.add(_amount) <= cap);
282     totalSupply_ = totalSupply_.add(_amount);
283     balances[_to] = balances[_to].add(_amount);
284     Mint(_to, _amount);
285     Transfer(address(0), _to, _amount);
286     return true;
287   }
288 
289   /**
290    * @dev Function to stop minting new tokens.
291    * @return True if the operation was successful.
292    */
293   function finishMinting() onlyOwner canMint public returns (bool) {
294     mintingFinished = true;
295     MintFinished();
296     return true;
297   }
298 }
299 
300 
301 
302 
303 contract CocaCoinaCoin is MintableToken {
304 
305   string public constant name = "CocaCoina"; 
306   string public constant symbol = "COCA"; 
307   uint8 public constant decimals = 18;
308   
309   uint256 public constant founderTokens = 0; //0 tokens
310 
311     function CocaCoinaCoin() public {
312     totalSupply_ = founderTokens;
313     balances[msg.sender] = founderTokens;
314     Transfer(0x0, msg.sender, founderTokens);
315     }
316 
317 }
318 
319 
320 
321 /**
322  * @title SafeMath
323  * @dev Math operations with safety checks that throw on error
324  */
325 library SafeMath {
326 
327   /**
328   * @dev Multiplies two numbers, throws on overflow.
329   */
330   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
331     if (a == 0) {
332       return 0;
333     }
334     uint256 c = a * b;
335     assert(c / a == b);
336     return c;
337   }
338 
339   /**
340   * @dev Integer division of two numbers, truncating the quotient.
341   */
342   function div(uint256 a, uint256 b) internal pure returns (uint256) {
343     // assert(b > 0); // Solidity automatically throws when dividing by 0
344     uint256 c = a / b;
345     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
346     return c;
347   }
348 
349   /**
350   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
351   */
352   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
353     assert(b <= a);
354     return a - b;
355   }
356 
357   /**
358   * @dev Adds two numbers, throws on overflow.
359   */
360   function add(uint256 a, uint256 b) internal pure returns (uint256) {
361     uint256 c = a + b;
362     assert(c >= a);
363     return c;
364   }
365 }
366 
367 
368 
369 /**
370  * @title Crowdsale
371  * @dev Crowdsale is a base contract for managing a token crowdsale.
372  * Crowdsales have a start and end timestamps, where investors can make
373  * token purchases and the crowdsale will assign them tokens based
374  * on a token per ETH rate. Funds collected are forwarded to a wallet
375  * as they arrive.
376  */
377 contract Crowdsale is Ownable {
378   using SafeMath for uint256;
379   
380 
381   // The token being sold
382   CocaCoinaCoin public token;
383 
384   // start and end timestamps where investments are allowed (both inclusive)
385   uint256 public startTime;
386   uint256 public endTime;
387 
388   // address where funds are collected
389   address public fundsWallet;
390 
391   // how many token units a buyer gets per wei
392   uint256 public rate;
393 
394   // amount of raised money in wei
395   uint256 public amountRaised;
396   
397   uint256 public tokenCap;
398   
399   // current bonus applied (where 140 = 40%)
400   uint256 public bonus;
401   
402   
403 
404   /**
405    * event for token purchase logging
406    * @param purchaser who paid for the tokens
407    * @param beneficiary who got the tokens
408    * @param value weis paid for purchase
409    * @param amount amount of tokens purchased
410    */
411   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
412 
413 
414   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,CocaCoinaCoin _token) public {
415     require(_startTime >= now);
416     require(_endTime >= _startTime);
417     require(_rate > 0);
418     require(_wallet != address(0));
419 
420     token = _token;
421     startTime = _startTime;
422     endTime = _endTime;
423     rate = _rate;
424     fundsWallet = _wallet;
425     tokenCap = token.cap();
426     bonus = 100;
427   }
428 
429   // fallback function can be used to buy tokens
430   function () external payable {
431     buyTokens(msg.sender);
432   }
433 
434   // low level token purchase function
435   function buyTokens(address beneficiary) public payable {
436     require(beneficiary != address(0));
437     require(validPurchase());
438 
439     uint256 weiAmount = msg.value;
440 
441     // calculate token amount to be created
442     uint256 tokens = getTokenAmount(weiAmount);
443 
444     token.mint(beneficiary, tokens);
445     
446     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
447 
448     forwardFunds();
449     
450     // update state
451     amountRaised = amountRaised.add(weiAmount);
452   }
453   
454   function burnTokens(uint256 _value) external onlyOwner returns (bool) {
455         token.burn(_value);
456     return true;
457   }
458   
459   // @return true if crowdsale is live
460   function SaleIsLive() public view returns (bool) {
461     return now > startTime && now < endTime;
462   }
463 
464   // @return true if crowdsale event has ended
465   function SaleHasEnded() public view returns (bool) {
466     return now > endTime;
467   }
468 
469 
470   // Override this method to have a way to add business logic to your crowdsale when buying
471   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
472     uint256 bonusrate = (rate.mul(bonus)).div(100);
473     return weiAmount.mul(bonusrate);
474   }
475 
476   // send ether to the fund collection wallet
477   // override to create custom fund forwarding mechanisms
478   function forwardFunds() internal {
479     fundsWallet.transfer(msg.value);
480   }
481 
482   // @return true if the transaction can buy tokens
483   function validPurchase() internal view returns (bool) {
484     bool withinPeriod = now >= startTime && now <= endTime;
485     bool nonZeroPurchase = msg.value != 0;
486     return withinPeriod && nonZeroPurchase;
487   }
488 
489 }
490 
491 
492 
493 /**
494  * @title CappedCrowdsale
495  * @dev Extension of Crowdsale with a max amount of funds raised
496  */
497 contract CappedCrowdsale is Crowdsale {
498   using SafeMath for uint256;
499 
500   uint256 public cap;
501 
502   function CappedCrowdsale(uint256 _cap) public {
503     require(_cap > 0);
504     cap = _cap;
505   }
506 
507   // overriding Crowdsale#hasEnded to add cap logic
508   // @return true if crowdsale event has ended
509   function SaleHasEnded() public view returns (bool) {
510     bool capReached = amountRaised >= cap;
511     return capReached || super.SaleHasEnded();
512   }
513 
514   // overriding Crowdsale#validPurchase to add extra cap logic
515   // @return true if investors can buy at the moment
516   function validPurchase() internal view returns (bool) {
517     bool withinCap = amountRaised.add(msg.value) <= cap;
518     return withinCap && super.validPurchase();
519   }
520 
521 }
522 
523 
524 
525 
526 
527 
528 
529 
530 /**
531  * @title FinalizableCrowdsale
532  * @dev Extension of Crowdsale where an owner can do extra work
533  * after finishing.
534  */
535 contract FinalizableCrowdsale is Crowdsale {
536   using SafeMath for uint256;
537 
538   bool public isFinalized = false;
539 
540   event Finalized();
541 
542   /**
543    * @dev Must be called after crowdsale ends, to do some extra finalization
544    * work. Calls the contract's finalization function.
545    */
546   function finalize() onlyOwner public {
547     require(!isFinalized);
548     require(SaleHasEnded());
549 
550     finalization();
551     Finalized();
552 
553     isFinalized = true;
554   }
555 
556   /**
557    * @dev Can be overridden to add finalization logic. The overriding function
558    * should call super.finalization() to ensure the chain of finalization is
559    * executed entirely.
560    */
561   function finalization() internal {
562   }
563 }
564 
565 
566 
567 
568 
569 
570 
571 /**
572  * @title RefundVault
573  * @dev This contract is used for storing funds while a crowdsale
574  * is in progress. Supports refunding the money if crowdsale fails,
575  * and forwarding it if crowdsale is successful.
576  */
577 contract RefundVault is Ownable {
578   using SafeMath for uint256;
579 
580   enum State { Active, Refunding, Closed }
581 
582   mapping (address => uint256) public deposited;
583   address public wallet;
584   State public state;
585 
586   event Closed();
587   event RefundsEnabled();
588   event Refunded(address indexed beneficiary, uint256 weiAmount);
589 
590   function RefundVault(address _wallet) public {
591     require(_wallet != address(0));
592     wallet = _wallet;
593     state = State.Active;
594   }
595 
596   function deposit(address investor) onlyOwner public payable {
597     require(state == State.Active);
598     deposited[investor] = deposited[investor].add(msg.value);
599   }
600 
601   function close() onlyOwner public {
602     require(state == State.Active);
603     state = State.Closed;
604     Closed();
605     wallet.transfer(this.balance);
606   }
607 
608   function enableRefunds() onlyOwner public {
609     require(state == State.Active);
610     state = State.Refunding;
611     RefundsEnabled();
612   }
613 
614   function refund(address investor) public {
615     require(state == State.Refunding);
616     uint256 depositedValue = deposited[investor];
617     deposited[investor] = 0;
618     investor.transfer(depositedValue);
619     Refunded(investor, depositedValue);
620   }
621 }
622 
623 
624 
625 /**
626  * @title RefundableCrowdsale
627  * @dev Extension of Crowdsale contract that adds a funding goal, and
628  * the possibility of users getting a refund if goal is not met.
629  * Uses a RefundVault as the crowdsale's vault.
630  */
631 contract RefundableCrowdsale is FinalizableCrowdsale {
632   using SafeMath for uint256;
633 
634   // minimum amount of funds to be raised in weis
635   uint256 public goal;
636 
637   // refund vault used to hold funds while crowdsale is running
638   RefundVault public vault;
639 
640   function RefundableCrowdsale(uint256 _goal) public {
641     require(_goal > 0);
642     vault = new RefundVault(fundsWallet);
643     goal = _goal;
644   }
645 
646   // if crowdsale is unsuccessful, investors can claim refunds here
647   function claimRefund() public {
648     require(isFinalized);
649     require(!goalReached());
650 
651     vault.refund(msg.sender);
652   }
653 
654   function goalReached() public view returns (bool) {
655     return amountRaised >= goal;
656   }
657 
658   // vault finalization task, called when owner calls finalize()
659   function finalization() internal {
660     if (goalReached()) {
661       vault.close();
662     } else {
663       vault.enableRefunds();
664     }
665 
666     super.finalization();
667   }
668 
669   // We're overriding the fund forwarding from Crowdsale.
670   // In addition to sending the funds, we want to call
671   // the RefundVault deposit function
672   function forwardFunds() internal {
673     vault.deposit.value(msg.value)(msg.sender);
674   }
675 
676 }
677 
678 
679 
680 contract CocaCoinaCrowdsale is CappedCrowdsale, RefundableCrowdsale {
681     
682 
683   function CocaCoinaCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet, CocaCoinaCoin _token) public
684     CappedCrowdsale(_cap)
685     FinalizableCrowdsale()
686     RefundableCrowdsale(_goal)
687     Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
688   {
689     require(_goal <= _cap);
690   }
691   
692   
693   // Changes the rate of the tokensale against 1ETH -> ERA/ETH
694   function changeRate(uint256 newRate) public onlyOwner {
695     require(newRate > 0);
696     rate = newRate;
697   }
698   
699   // Changes the bonus rate of the tokensale in percentage (40% = 140 , 15% = 115 , 10% = 110 , 5% = 105)
700   function changeBonus(uint256 newBonus) public onlyOwner {
701     require(newBonus >= 100 && newBonus <= 140);
702     bonus = newBonus;
703   }
704   
705   // Mint new tokens and send them to specific address
706   function mintTokens(address addressToSend, uint256 tokensToMint) public onlyOwner {
707     require(tokensToMint > 0);
708     require(addressToSend != 0);
709     tokensToMint = SafeMath.mul(tokensToMint,1000000000000000000);
710     token.mint(addressToSend,tokensToMint);
711   }
712   
713   function changeTokenOwner(address newOwner) public onlyOwner {
714      token.transferOwnership(newOwner);
715   }
716 
717 }