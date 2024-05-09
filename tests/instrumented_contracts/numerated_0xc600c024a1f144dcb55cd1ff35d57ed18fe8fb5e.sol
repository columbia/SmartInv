1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     Unpause();
84   }
85 }
86 
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     if (a == 0) {
99       return 0;
100     }
101     uint256 c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   /**
117   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/179
138  */
139 contract ERC20Basic {
140   function totalSupply() public view returns (uint256);
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances.
160  */
161 contract BasicToken is ERC20Basic {
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) balances;
165 
166   uint256 totalSupply_;
167 
168   /**
169   * @dev total number of tokens in existence
170   */
171   function totalSupply() public view returns (uint256) {
172     return totalSupply_;
173   }
174 
175   /**
176   * @dev transfer token for a specified address
177   * @param _to The address to transfer to.
178   * @param _value The amount to be transferred.
179   */
180   function transfer(address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[msg.sender]);
183 
184     // SafeMath.sub will throw if there is not enough balance.
185     balances[msg.sender] = balances[msg.sender].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     Transfer(msg.sender, _to, _value);
188     return true;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param _owner The address to query the the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address _owner) public view returns (uint256 balance) {
197     return balances[_owner];
198   }
199 
200 }
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * @dev https://github.com/ethereum/EIPs/issues/20
207  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[_from]);
223     require(_value <= allowed[_from][msg.sender]);
224 
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    *
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param _spender The address which will spend the funds.
240    * @param _value The amount of tokens to be spent.
241    */
242   function approve(address _spender, uint256 _value) public returns (bool) {
243     allowed[msg.sender][_spender] = _value;
244     Approval(msg.sender, _spender, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(address _owner, address _spender) public view returns (uint256) {
255     return allowed[_owner][_spender];
256   }
257 
258   /**
259    * @dev Increase the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _addedValue The amount of tokens to increase the allowance by.
267    */
268   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
269     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
270     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274   /**
275    * @dev Decrease the amount of tokens that an owner allowed to a spender.
276    *
277    * approve should be called when allowed[_spender] == 0. To decrement
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    * @param _spender The address which will spend the funds.
282    * @param _subtractedValue The amount of tokens to decrease the allowance by.
283    */
284   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
285     uint oldValue = allowed[msg.sender][_spender];
286     if (_subtractedValue > oldValue) {
287       allowed[msg.sender][_spender] = 0;
288     } else {
289       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290     }
291     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292     return true;
293   }
294 
295 }
296 
297 
298 /**
299  * @title Mintable token
300  * @dev Simple ERC20 Token example, with mintable token creation
301  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
302  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
303  */
304 contract MintableToken is StandardToken, Ownable {
305   event Mint(address indexed to, uint256 amount);
306   event MintFinished();
307 
308   bool public mintingFinished = false;
309 
310 
311   modifier canMint() {
312     require(!mintingFinished);
313     _;
314   }
315 
316   /**
317    * @dev Function to mint tokens
318    * @param _to The address that will receive the minted tokens.
319    * @param _amount The amount of tokens to mint.
320    * @return A boolean that indicates if the operation was successful.
321    */
322   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
323     totalSupply_ = totalSupply_.add(_amount);
324     balances[_to] = balances[_to].add(_amount);
325     Mint(_to, _amount);
326     Transfer(address(0), _to, _amount);
327     return true;
328   }
329 
330   /**
331    * @dev Function to stop minting new tokens.
332    * @return True if the operation was successful.
333    */
334   function finishMinting() onlyOwner canMint public returns (bool) {
335     mintingFinished = true;
336     MintFinished();
337     return true;
338   }
339 }
340 /**
341  * @title Pausable token
342  * @dev StandardToken modified with pausable transfers.
343  **/
344 contract PausableToken is StandardToken, Pausable {
345 
346   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
347     return super.transfer(_to, _value);
348   }
349 
350   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
351     return super.transferFrom(_from, _to, _value);
352   }
353 
354   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
355     return super.approve(_spender, _value);
356   }
357 
358   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
359     return super.increaseApproval(_spender, _addedValue);
360   }
361 
362   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
363     return super.decreaseApproval(_spender, _subtractedValue);
364   }
365 }
366 /**
367  * @title Capped token
368  * @dev Mintable token with a token cap.
369  */
370 contract CappedToken is MintableToken {
371 
372   uint256 public cap;
373 
374   function CappedToken(uint256 _cap) public {
375     require(_cap > 0);
376     cap = _cap;
377   }
378 
379   /**
380    * @dev Function to mint tokens
381    * @param _to The address that will receive the minted tokens.
382    * @param _amount The amount of tokens to mint.
383    * @return A boolean that indicates if the operation was successful.
384    */
385   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
386     require(totalSupply_.add(_amount) <= cap);
387 
388     return super.mint(_to, _amount);
389   }
390 
391 }
392 
393 contract CommunityCoin is CappedToken, PausableToken {
394 
395   using SafeMath for uint;
396 
397   string public constant symbol = "CTC";
398 
399   string public constant name = "Coin of The Community";
400 
401   uint8 public constant decimals = 18;
402 
403   uint public constant unit = 10 ** uint256(decimals);
404   
405   uint public lockPeriod = 90 days;
406   
407   uint public startTime;
408 
409   function CommunityCoin(uint _startTime,uint _tokenCap) CappedToken(_tokenCap.mul(unit)) public {
410       totalSupply_ = 0;
411       startTime=_startTime;
412       pause();
413     }
414     
415      function unpause() onlyOwner whenPaused public {
416     require(now > startTime + lockPeriod);
417     super.unpause();
418   }
419 
420   function setLockPeriod(uint _period) onlyOwner public {
421     lockPeriod = _period;
422   }
423 
424   function () payable public {
425         revert();
426     }
427 
428 
429 }
430 
431 
432 /**
433  * @title Crowdsale
434  * @dev Crowdsale is a base contract for managing a token crowdsale.
435  * Crowdsales have a start and end timestamps, where investors can make
436  * token purchases and the crowdsale will assign them tokens based
437  * on a token per ETH rate. Funds collected are forwarded to a wallet
438  * as they arrive.
439  */
440 contract Crowdsale {
441   using SafeMath for uint256;
442 
443   // The token being sold
444   MintableToken public token;
445 
446   // start and end timestamps where investments are allowed (both inclusive)
447   uint256 public startTime;
448   uint256 public endTime;
449 
450   // address where funds are collected
451   address public wallet;
452 
453   // how many token units a buyer gets per wei
454   uint256 public rate;
455 
456   // amount of raised money in wei
457   uint256 public weiRaised;
458 
459   /**
460    * event for token purchase logging
461    * @param purchaser who paid for the tokens
462    * @param beneficiary who got the tokens
463    * @param value weis paid for purchase
464    * @param amount amount of tokens purchased
465    */
466   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
467 
468 
469   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
470     require(_startTime >= now);
471     require(_endTime >= _startTime);
472     require(_rate > 0);
473     require(_wallet != address(0));
474 
475     token = createTokenContract();
476     startTime = _startTime;
477     endTime = _endTime;
478     rate = _rate;
479     wallet = _wallet;
480   }
481 
482   // fallback function can be used to buy tokens
483   function () external payable {
484     buyTokens(msg.sender);
485   }
486 
487   // low level token purchase function
488   function buyTokens(address beneficiary) public payable {
489     require(beneficiary != address(0));
490     require(validPurchase());
491 
492     uint256 weiAmount = msg.value;
493 
494     // calculate token amount to be created
495     uint256 tokens = getTokenAmount(weiAmount);
496 
497     // update state
498     weiRaised = weiRaised.add(weiAmount);
499 
500     token.mint(beneficiary, tokens);
501     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
502 
503     forwardFunds();
504   }
505 
506   // @return true if crowdsale event has ended
507   function hasEnded() public view returns (bool) {
508     return now > endTime;
509   }
510 
511   // creates the token to be sold.
512   // override this method to have crowdsale of a specific mintable token.
513   function createTokenContract() internal returns (MintableToken) {
514     return new MintableToken();
515   }
516 
517   // Override this method to have a way to add business logic to your crowdsale when buying
518   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
519     return weiAmount.mul(rate);
520   }
521 
522   // send ether to the fund collection wallet
523   // override to create custom fund forwarding mechanisms
524   function forwardFunds() internal {
525     wallet.transfer(msg.value);
526   }
527 
528   // @return true if the transaction can buy tokens
529   function validPurchase() internal view returns (bool) {
530     bool withinPeriod = now >= startTime && now <= endTime;
531     bool nonZeroPurchase = msg.value != 0;
532     return withinPeriod && nonZeroPurchase;
533   }
534 
535 }
536 
537 /**
538  * @title CappedCrowdsale
539  * @dev Extension of Crowdsale with a max amount of funds raised
540  */
541 contract CappedCrowdsale is Crowdsale {
542   using SafeMath for uint256;
543 
544   uint256 public cap;
545 
546   function CappedCrowdsale(uint256 _cap) public {
547     require(_cap > 0);
548     cap = _cap;
549   }
550 
551   // overriding Crowdsale#hasEnded to add cap logic
552   // @return true if crowdsale event has ended
553   function hasEnded() public view returns (bool) {
554     bool capReached = weiRaised >= cap;
555     return capReached || super.hasEnded();
556   }
557 
558   // overriding Crowdsale#validPurchase to add extra cap logic
559   // @return true if investors can buy at the moment
560   function validPurchase() internal view returns (bool) {
561     bool withinCap = weiRaised.add(msg.value) <= cap;
562     return withinCap && super.validPurchase();
563   }
564 
565 }
566 
567 /**
568  * @title FinalizableCrowdsale
569  * @dev Extension of Crowdsale where an owner can do extra work
570  * after finishing.
571  */
572 contract FinalizableCrowdsale is Crowdsale, Ownable {
573   using SafeMath for uint256;
574 
575   bool public isFinalized = false;
576 
577   event Finalized();
578 
579   /**
580    * @dev Must be called after crowdsale ends, to do some extra finalization
581    * work. Calls the contract's finalization function.
582    */
583   function finalize() onlyOwner public {
584     require(!isFinalized);
585     require(hasEnded());
586 
587     finalization();
588     Finalized();
589 
590     isFinalized = true;
591   }
592 
593   /**
594    * @dev Can be overridden to add finalization logic. The overriding function
595    * should call super.finalization() to ensure the chain of finalization is
596    * executed entirely.
597    */
598   function finalization() internal {
599   }
600 }
601 
602 /**
603  * @title RefundVault
604  * @dev This contract is used for storing funds while a crowdsale
605  * is in progress. Supports refunding the money if crowdsale fails,
606  * and forwarding it if crowdsale is successful.
607  */
608 contract RefundVault is Ownable {
609   using SafeMath for uint256;
610 
611   enum State { Active, Refunding, Closed }
612 
613   mapping (address => uint256) public deposited;
614   address public wallet;
615   State public state;
616 
617   event Closed();
618   event RefundsEnabled();
619   event Refunded(address indexed beneficiary, uint256 weiAmount);
620 
621   function RefundVault(address _wallet) public {
622     require(_wallet != address(0));
623     wallet = _wallet;
624     state = State.Active;
625   }
626 
627   function deposit(address investor) onlyOwner public payable {
628     require(state == State.Active);
629     deposited[investor] = deposited[investor].add(msg.value);
630   }
631 
632   function close() onlyOwner public {
633     require(state == State.Active);
634     state = State.Closed;
635     Closed();
636     wallet.transfer(this.balance);
637   }
638 
639   function enableRefunds() onlyOwner public {
640     require(state == State.Active);
641     state = State.Refunding;
642     RefundsEnabled();
643   }
644 
645   function refund(address investor) public {
646     require(state == State.Refunding);
647     uint256 depositedValue = deposited[investor];
648     deposited[investor] = 0;
649     investor.transfer(depositedValue);
650     Refunded(investor, depositedValue);
651   }
652 
653   function setWallet(address _wallet) onlyOwner public {
654         wallet = _wallet;
655     }
656 }
657 
658 /**
659  * @title RefundableCrowdsale
660  * @dev Extension of Crowdsale contract that adds a funding goal, and
661  * the possibility of users getting a refund if goal is not met.
662  * Uses a RefundVault as the crowdsale's vault.
663  */
664 contract RefundableCrowdsale is FinalizableCrowdsale {
665   using SafeMath for uint256;
666 
667   // minimum amount of funds to be raised in weis
668   uint256 public goal;
669 
670   // refund vault used to hold funds while crowdsale is running
671   RefundVault public vault;
672 
673   function RefundableCrowdsale(uint256 _goal) public {
674     require(_goal > 0);
675     vault = new RefundVault(wallet);
676     goal = _goal;
677   }
678 
679   // if crowdsale is unsuccessful, investors can claim refunds here
680   function claimRefund() public {
681     require(isFinalized);
682     require(!goalReached());
683 
684     vault.refund(msg.sender);
685   }
686 
687   function goalReached() public view returns (bool) {
688     return weiRaised >= goal;
689   }
690 
691   // vault finalization task, called when owner calls finalize()
692   function finalization() internal {
693     if (goalReached()) {
694       vault.close();
695     } else {
696       vault.enableRefunds();
697     }
698 
699     super.finalization();
700   }
701 
702   // We're overriding the fund forwarding from Crowdsale.
703   // In addition to sending the funds, we want to call
704   // the RefundVault deposit function
705   function forwardFunds() internal {
706     vault.deposit.value(msg.value)(msg.sender);
707   }
708 
709 }
710 
711 contract CTCSale is CappedCrowdsale, RefundableCrowdsale {
712 
713     using SafeMath for uint;
714 
715     uint constant private exa  =  10 ** 18;
716 
717     uint public minBuy;
718 
719     event WalletChanged(address _wallet);
720 
721     function CTCSale(uint _start,uint _end,uint _rate,uint _cap,address _wallet,CommunityCoin _tokenAddress,uint _goal,uint _minBuy)
722     Crowdsale(_start, _end,_rate,_wallet)
723     CappedCrowdsale(_cap * exa)
724     RefundableCrowdsale(_goal * exa) public {
725         token = CommunityCoin(_tokenAddress);
726         minBuy = _minBuy;
727     }
728 
729     function setToken(address _tokenAddress) onlyOwner public {
730         token = CommunityCoin(_tokenAddress);
731     }
732 
733     function transferToken(address newOwner) onlyOwner public {
734         require(newOwner != address(0));
735         token.transferOwnership(newOwner);
736     }
737 
738     function setWallet(address _wallet) onlyOwner public {
739         vault.setWallet(_wallet);
740         WalletChanged(_wallet);
741     }
742 
743     function setStartTime(uint _start) onlyOwner public {
744         startTime = _start;
745     }
746 
747     function setEndTime(uint _end) onlyOwner public {
748         endTime = _end;
749     }
750 
751     function remainToken() view public returns(uint) {
752         return (cap - weiRaised).mul(rate);
753     }
754 
755     function validPurchase() internal view returns (bool) {
756       return msg.value >= minBuy * exa && super.validPurchase();
757     }
758 
759     function finalization() internal {
760         super.finalization();
761         transferToken(msg.sender);
762     }
763 }