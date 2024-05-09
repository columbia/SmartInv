1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public {
127     require(_value <= balances[msg.sender]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131     address burner = msg.sender;
132     balances[burner] = balances[burner].sub(_value);
133     totalSupply_ = totalSupply_.sub(_value);
134     Burn(burner, _value);
135     Transfer(burner, address(0), _value);
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147   address public owner;
148 
149 
150   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   function Ownable() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) public onlyOwner {
174     require(newOwner != address(0));
175     OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 
179 }
180 
181 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
182 
183 /**
184  * @title ERC20 interface
185  * @dev see https://github.com/ethereum/EIPs/issues/20
186  */
187 contract ERC20 is ERC20Basic {
188   function allowance(address owner, address spender) public view returns (uint256);
189   function transferFrom(address from, address to, uint256 value) public returns (bool);
190   function approve(address spender, uint256 value) public returns (bool);
191   event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
195 
196 /**
197  * @title Standard ERC20 token
198  *
199  * @dev Implementation of the basic standard token.
200  * @dev https://github.com/ethereum/EIPs/issues/20
201  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
202  */
203 contract StandardToken is ERC20, BasicToken {
204 
205   mapping (address => mapping (address => uint256)) internal allowed;
206 
207 
208   /**
209    * @dev Transfer tokens from one address to another
210    * @param _from address The address which you want to send tokens from
211    * @param _to address The address which you want to transfer to
212    * @param _value uint256 the amount of tokens to be transferred
213    */
214   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
215     require(_to != address(0));
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     Transfer(_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    *
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(address _owner, address _spender) public view returns (uint256) {
249     return allowed[_owner][_spender];
250   }
251 
252   /**
253    * @dev Increase the amount of tokens that an owner allowed to a spender.
254    *
255    * approve should be called when allowed[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
263     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
264     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To decrement
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _subtractedValue The amount of tokens to decrease the allowance by.
277    */
278   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
279     uint oldValue = allowed[msg.sender][_spender];
280     if (_subtractedValue > oldValue) {
281       allowed[msg.sender][_spender] = 0;
282     } else {
283       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
284     }
285     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289 }
290 
291 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
292 
293 /**
294  * @title Mintable token
295  * @dev Simple ERC20 Token example, with mintable token creation
296  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
297  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
298  */
299 contract MintableToken is StandardToken, Ownable {
300   event Mint(address indexed to, uint256 amount);
301   event MintFinished();
302 
303   bool public mintingFinished = false;
304 
305 
306   modifier canMint() {
307     require(!mintingFinished);
308     _;
309   }
310 
311   /**
312    * @dev Function to mint tokens
313    * @param _to The address that will receive the minted tokens.
314    * @param _amount The amount of tokens to mint.
315    * @return A boolean that indicates if the operation was successful.
316    */
317   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
318     totalSupply_ = totalSupply_.add(_amount);
319     balances[_to] = balances[_to].add(_amount);
320     Mint(_to, _amount);
321     Transfer(address(0), _to, _amount);
322     return true;
323   }
324 
325   /**
326    * @dev Function to stop minting new tokens.
327    * @return True if the operation was successful.
328    */
329   function finishMinting() onlyOwner canMint public returns (bool) {
330     mintingFinished = true;
331     MintFinished();
332     return true;
333   }
334 }
335 
336 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
337 
338 /**
339  * @title Capped token
340  * @dev Mintable token with a token cap.
341  */
342 contract CappedToken is MintableToken {
343 
344   uint256 public cap;
345 
346   function CappedToken(uint256 _cap) public {
347     require(_cap > 0);
348     cap = _cap;
349   }
350 
351   /**
352    * @dev Function to mint tokens
353    * @param _to The address that will receive the minted tokens.
354    * @param _amount The amount of tokens to mint.
355    * @return A boolean that indicates if the operation was successful.
356    */
357   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
358     require(totalSupply_.add(_amount) <= cap);
359 
360     return super.mint(_to, _amount);
361   }
362 
363 }
364 
365 // File: contracts/HieToken.sol
366 
367 contract HieToken is BasicToken, BurnableToken, CappedToken {
368   using SafeMath for uint256;
369 
370   string public constant name = 'HIU TOKEN';
371 
372   string public constant symbol = 'HIE';
373 
374   uint public constant decimals = 18;
375 
376   uint256 constant CAP = 2000000000 * (10 ** decimals);
377 
378   function HieToken()
379     public
380     CappedToken(CAP)
381   {
382   }
383 }
384 
385 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
386 
387 /**
388  * @title Crowdsale
389  * @dev Crowdsale is a base contract for managing a token crowdsale,
390  * allowing investors to purchase tokens with ether. This contract implements
391  * such functionality in its most fundamental form and can be extended to provide additional
392  * functionality and/or custom behavior.
393  * The external interface represents the basic interface for purchasing tokens, and conform
394  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
395  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
396  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
397  * behavior.
398  */
399 
400 contract Crowdsale {
401   using SafeMath for uint256;
402 
403   // The token being sold
404   ERC20 public token;
405 
406   // Address where funds are collected
407   address public wallet;
408 
409   // How many token units a buyer gets per wei
410   uint256 public rate;
411 
412   // Amount of wei raised
413   uint256 public weiRaised;
414 
415   /**
416    * Event for token purchase logging
417    * @param purchaser who paid for the tokens
418    * @param beneficiary who got the tokens
419    * @param value weis paid for purchase
420    * @param amount amount of tokens purchased
421    */
422   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
423 
424   /**
425    * @param _rate Number of token units a buyer gets per wei
426    * @param _wallet Address where collected funds will be forwarded to
427    * @param _token Address of the token being sold
428    */
429   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
430     require(_rate > 0);
431     require(_wallet != address(0));
432     require(_token != address(0));
433 
434     rate = _rate;
435     wallet = _wallet;
436     token = _token;
437   }
438 
439   // -----------------------------------------
440   // Crowdsale external interface
441   // -----------------------------------------
442 
443   /**
444    * @dev fallback function ***DO NOT OVERRIDE***
445    */
446   function () external payable {
447     buyTokens(msg.sender);
448   }
449 
450   /**
451    * @dev low level token purchase ***DO NOT OVERRIDE***
452    * @param _beneficiary Address performing the token purchase
453    */
454   function buyTokens(address _beneficiary) public payable {
455 
456     uint256 weiAmount = msg.value;
457     _preValidatePurchase(_beneficiary, weiAmount);
458 
459     // calculate token amount to be created
460     uint256 tokens = _getTokenAmount(weiAmount);
461 
462     // update state
463     weiRaised = weiRaised.add(weiAmount);
464 
465     _processPurchase(_beneficiary, tokens);
466     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
467 
468     _updatePurchasingState(_beneficiary, weiAmount);
469 
470     _forwardFunds();
471     _postValidatePurchase(_beneficiary, weiAmount);
472   }
473 
474   // -----------------------------------------
475   // Internal interface (extensible)
476   // -----------------------------------------
477 
478   /**
479    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
480    * @param _beneficiary Address performing the token purchase
481    * @param _weiAmount Value in wei involved in the purchase
482    */
483   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
484     require(_beneficiary != address(0));
485     require(_weiAmount != 0);
486   }
487 
488   /**
489    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
490    * @param _beneficiary Address performing the token purchase
491    * @param _weiAmount Value in wei involved in the purchase
492    */
493   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
494     // optional override
495   }
496 
497   /**
498    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
499    * @param _beneficiary Address performing the token purchase
500    * @param _tokenAmount Number of tokens to be emitted
501    */
502   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
503     token.transfer(_beneficiary, _tokenAmount);
504   }
505 
506   /**
507    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
508    * @param _beneficiary Address receiving the tokens
509    * @param _tokenAmount Number of tokens to be purchased
510    */
511   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
512     _deliverTokens(_beneficiary, _tokenAmount);
513   }
514 
515   /**
516    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
517    * @param _beneficiary Address receiving the tokens
518    * @param _weiAmount Value in wei involved in the purchase
519    */
520   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
521     // optional override
522   }
523 
524   /**
525    * @dev Override to extend the way in which ether is converted to tokens.
526    * @param _weiAmount Value in wei to be converted into tokens
527    * @return Number of tokens that can be purchased with the specified _weiAmount
528    */
529   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
530     return _weiAmount.mul(rate);
531   }
532 
533   /**
534    * @dev Determines how ETH is stored/forwarded on purchases.
535    */
536   function _forwardFunds() internal {
537     wallet.transfer(msg.value);
538   }
539 }
540 
541 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
542 
543 /**
544  * @title TimedCrowdsale
545  * @dev Crowdsale accepting contributions only within a time frame.
546  */
547 contract TimedCrowdsale is Crowdsale {
548   using SafeMath for uint256;
549 
550   uint256 public openingTime;
551   uint256 public closingTime;
552 
553   /**
554    * @dev Reverts if not in crowdsale time range. 
555    */
556   modifier onlyWhileOpen {
557     require(now >= openingTime && now <= closingTime);
558     _;
559   }
560 
561   /**
562    * @dev Constructor, takes crowdsale opening and closing times.
563    * @param _openingTime Crowdsale opening time
564    * @param _closingTime Crowdsale closing time
565    */
566   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
567     require(_openingTime >= now);
568     require(_closingTime >= _openingTime);
569 
570     openingTime = _openingTime;
571     closingTime = _closingTime;
572   }
573 
574   /**
575    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
576    * @return Whether crowdsale period has elapsed
577    */
578   function hasClosed() public view returns (bool) {
579     return now > closingTime;
580   }
581   
582   /**
583    * @dev Extend parent behavior requiring to be within contributing period
584    * @param _beneficiary Token purchaser
585    * @param _weiAmount Amount of wei contributed
586    */
587   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
588     super._preValidatePurchase(_beneficiary, _weiAmount);
589   }
590 
591 }
592 
593 // File: zeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
594 
595 /**
596  * @title PostDeliveryCrowdsale
597  * @dev Crowdsale that locks tokens from withdrawal until it ends.
598  */
599 contract PostDeliveryCrowdsale is TimedCrowdsale {
600   using SafeMath for uint256;
601 
602   mapping(address => uint256) public balances;
603 
604   /**
605    * @dev Overrides parent by storing balances instead of issuing tokens right away.
606    * @param _beneficiary Token purchaser
607    * @param _tokenAmount Amount of tokens purchased
608    */
609   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
610     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
611   }
612 
613   /**
614    * @dev Withdraw tokens only after crowdsale ends.
615    */
616   function withdrawTokens() public {
617     require(hasClosed());
618     uint256 amount = balances[msg.sender];
619     require(amount > 0);
620     balances[msg.sender] = 0;
621     _deliverTokens(msg.sender, amount);
622   }
623 }
624 
625 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
626 
627 /**
628  * @title FinalizableCrowdsale
629  * @dev Extension of Crowdsale where an owner can do extra work
630  * after finishing.
631  */
632 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
633   using SafeMath for uint256;
634 
635   bool public isFinalized = false;
636 
637   event Finalized();
638 
639   /**
640    * @dev Must be called after crowdsale ends, to do some extra finalization
641    * work. Calls the contract's finalization function.
642    */
643   function finalize() onlyOwner public {
644     require(!isFinalized);
645     require(hasClosed());
646 
647     finalization();
648     Finalized();
649 
650     isFinalized = true;
651   }
652 
653   /**
654    * @dev Can be overridden to add finalization logic. The overriding function
655    * should call super.finalization() to ensure the chain of finalization is
656    * executed entirely.
657    */
658   function finalization() internal {
659   }
660 }
661 
662 // File: zeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
663 
664 /**
665  * @title RefundVault
666  * @dev This contract is used for storing funds while a crowdsale
667  * is in progress. Supports refunding the money if crowdsale fails,
668  * and forwarding it if crowdsale is successful.
669  */
670 contract RefundVault is Ownable {
671   using SafeMath for uint256;
672 
673   enum State { Active, Refunding, Closed }
674 
675   mapping (address => uint256) public deposited;
676   address public wallet;
677   State public state;
678 
679   event Closed();
680   event RefundsEnabled();
681   event Refunded(address indexed beneficiary, uint256 weiAmount);
682 
683   /**
684    * @param _wallet Vault address
685    */
686   function RefundVault(address _wallet) public {
687     require(_wallet != address(0));
688     wallet = _wallet;
689     state = State.Active;
690   }
691 
692   /**
693    * @param investor Investor address
694    */
695   function deposit(address investor) onlyOwner public payable {
696     require(state == State.Active);
697     deposited[investor] = deposited[investor].add(msg.value);
698   }
699 
700   function close() onlyOwner public {
701     require(state == State.Active);
702     state = State.Closed;
703     Closed();
704     wallet.transfer(this.balance);
705   }
706 
707   function enableRefunds() onlyOwner public {
708     require(state == State.Active);
709     state = State.Refunding;
710     RefundsEnabled();
711   }
712 
713   /**
714    * @param investor Investor address
715    */
716   function refund(address investor) public {
717     require(state == State.Refunding);
718     uint256 depositedValue = deposited[investor];
719     deposited[investor] = 0;
720     investor.transfer(depositedValue);
721     Refunded(investor, depositedValue);
722   }
723 }
724 
725 // File: zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
726 
727 /**
728  * @title RefundableCrowdsale
729  * @dev Extension of Crowdsale contract that adds a funding goal, and
730  * the possibility of users getting a refund if goal is not met.
731  * Uses a RefundVault as the crowdsale's vault.
732  */
733 contract RefundableCrowdsale is FinalizableCrowdsale {
734   using SafeMath for uint256;
735 
736   // minimum amount of funds to be raised in weis
737   uint256 public goal;
738 
739   // refund vault used to hold funds while crowdsale is running
740   RefundVault public vault;
741 
742   /**
743    * @dev Constructor, creates RefundVault. 
744    * @param _goal Funding goal
745    */
746   function RefundableCrowdsale(uint256 _goal) public {
747     require(_goal > 0);
748     vault = new RefundVault(wallet);
749     goal = _goal;
750   }
751 
752   /**
753    * @dev Investors can claim refunds here if crowdsale is unsuccessful
754    */
755   function claimRefund() public {
756     require(isFinalized);
757     require(!goalReached());
758 
759     vault.refund(msg.sender);
760   }
761 
762   /**
763    * @dev Checks whether funding goal was reached. 
764    * @return Whether funding goal was reached
765    */
766   function goalReached() public view returns (bool) {
767     return weiRaised >= goal;
768   }
769 
770   /**
771    * @dev vault finalization task, called when owner calls finalize()
772    */
773   function finalization() internal {
774     if (goalReached()) {
775       vault.close();
776     } else {
777       vault.enableRefunds();
778     }
779 
780     super.finalization();
781   }
782 
783   /**
784    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
785    */
786   function _forwardFunds() internal {
787     vault.deposit.value(msg.value)(msg.sender);
788   }
789 
790 }
791 
792 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
793 
794 /**
795  * @title CappedCrowdsale
796  * @dev Crowdsale with a limit for total contributions.
797  */
798 contract CappedCrowdsale is Crowdsale {
799   using SafeMath for uint256;
800 
801   uint256 public cap;
802 
803   /**
804    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
805    * @param _cap Max amount of wei to be contributed
806    */
807   function CappedCrowdsale(uint256 _cap) public {
808     require(_cap > 0);
809     cap = _cap;
810   }
811 
812   /**
813    * @dev Checks whether the cap has been reached. 
814    * @return Whether the cap was reached
815    */
816   function capReached() public view returns (bool) {
817     return weiRaised >= cap;
818   }
819 
820   /**
821    * @dev Extend parent behavior requiring purchase to respect the funding cap.
822    * @param _beneficiary Token purchaser
823    * @param _weiAmount Amount of wei contributed
824    */
825   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
826     super._preValidatePurchase(_beneficiary, _weiAmount);
827     require(weiRaised.add(_weiAmount) <= cap);
828   }
829 
830 }
831 
832 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
833 
834 /**
835  * @title Pausable
836  * @dev Base contract which allows children to implement an emergency stop mechanism.
837  */
838 contract Pausable is Ownable {
839   event Pause();
840   event Unpause();
841 
842   bool public paused = false;
843 
844 
845   /**
846    * @dev Modifier to make a function callable only when the contract is not paused.
847    */
848   modifier whenNotPaused() {
849     require(!paused);
850     _;
851   }
852 
853   /**
854    * @dev Modifier to make a function callable only when the contract is paused.
855    */
856   modifier whenPaused() {
857     require(paused);
858     _;
859   }
860 
861   /**
862    * @dev called by the owner to pause, triggers stopped state
863    */
864   function pause() onlyOwner whenNotPaused public {
865     paused = true;
866     Pause();
867   }
868 
869   /**
870    * @dev called by the owner to unpause, returns to normal state
871    */
872   function unpause() onlyOwner whenPaused public {
873     paused = false;
874     Unpause();
875   }
876 }
877 
878 // File: contracts/HieCrowdsale.sol
879 
880 contract HieCrowdsale is Crowdsale, CappedCrowdsale, RefundableCrowdsale, PostDeliveryCrowdsale, Pausable {
881 
882   uint256 constant RATE_SALE_1 = 40650;
883   uint256 constant RATE_SALE_2 = 27100;
884   uint256 constant RATE_SALE_3 = 20325;
885 
886   uint256 constant CAP_SALE_1 = 9850 ether;
887   uint256 constant CAP_SALE_2 = 7400 ether;
888   uint256 constant CAP_SALE_3 = 9850 ether;
889   uint256 constant CAP = 27100 ether;
890 
891   uint256 constant GOAL = 750 ether;
892 
893   uint256 constant INITIAL_ALLOCATE_TOKEN = 1198856250 * (10 ** 18);
894 
895   uint256 constant MINIMUM_WEI_AMOUNT_SALE_1 = 200 ether;
896   uint256 constant MINIMUM_WEI_AMOUNT_SALE_2 = 1 ether;
897 
898   uint256 public startTimeSale1;
899   uint256 public endTimeSale1;
900 
901   uint256 public startTimeSale2;
902   uint256 public endTimeSale2;
903 
904   uint256 public startTimeSale3;
905   uint256 public endTimeSale3;
906 
907   uint256 public totalWeiAmountSale1;
908   uint256 public totalWeiAmountSale2;
909   uint256 public totalWeiAmountSale3;
910 
911   uint256 public initialFundBalance;
912   bool public isInitialAllocated = false;
913 
914   function HieCrowdsale(
915     uint256 _startTime,
916     uint256 _endTime,
917     uint256[] _startTimeSales,
918     uint256[] _endTimeSales,
919     HieToken _token,
920     address _wallet
921   )
922     public
923     Crowdsale(RATE_SALE_1, _wallet, _token)
924     TimedCrowdsale(_startTime, _endTime)
925     CappedCrowdsale(CAP)
926     RefundableCrowdsale(GOAL)
927   {
928     require(_startTimeSales.length == 3);
929     require(_endTimeSales.length == 3);
930 
931     startTimeSale1 = _startTimeSales[0];
932     endTimeSale1 = _endTimeSales[0];
933     startTimeSale2 = _startTimeSales[1];
934     endTimeSale2 = _endTimeSales[1];
935     startTimeSale3 = _startTimeSales[2];
936     endTimeSale3 = _endTimeSales[2];
937   }
938 
939   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
940     uint256 currentRate = rate;
941 
942     if (sale1Accepting()) {
943       currentRate = RATE_SALE_1;
944     } else if (sale2Accepting()) {
945       currentRate = RATE_SALE_2;
946     } else {
947       currentRate = RATE_SALE_3;
948     }
949 
950     return _weiAmount.mul(currentRate);
951   }
952 
953   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
954     require(!paused);
955     require(saleAccepting());
956 
957     if (sale1Accepting()) {
958       require(_weiAmount >= MINIMUM_WEI_AMOUNT_SALE_1);
959       require(totalWeiAmountSale1.add(_weiAmount) <= CAP_SALE_1);
960     } else if (sale2Accepting()) {
961       require(_weiAmount >= MINIMUM_WEI_AMOUNT_SALE_2);
962       require(totalWeiAmountSale2.add(_weiAmount) <= CAP_SALE_2);
963     } else {
964       require(totalWeiAmountSale3.add(_weiAmount) <= CAP_SALE_3);
965     }
966 
967     super._preValidatePurchase(_beneficiary, _weiAmount);
968   }
969 
970   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
971     if (sale1Accepting()) {
972       totalWeiAmountSale1 = totalWeiAmountSale1.add(_weiAmount);
973     } else if (sale2Accepting()) {
974       totalWeiAmountSale2 = totalWeiAmountSale2.add(_weiAmount);
975     } else {
976       totalWeiAmountSale3 = totalWeiAmountSale3.add(_weiAmount);
977     }
978 
979     super._updatePurchasingState(_beneficiary, _weiAmount);
980   }
981 
982   function sale1Accepting() internal view returns (bool) {
983     return startTimeSale1 <= now && now <= endTimeSale1;
984   }
985 
986   function sale2Accepting() internal view returns (bool) {
987     return startTimeSale2 <= now && now <= endTimeSale2;
988   }
989 
990   function sale3Accepting() internal view returns (bool) {
991     return startTimeSale3 <= now && now <= endTimeSale3;
992   }
993 
994   function saleAccepting() internal view returns (bool) {
995     return sale1Accepting() || sale2Accepting() || sale3Accepting();
996   }
997 
998   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
999     HieToken(token).mint(this, _tokenAmount);
1000     super._processPurchase(_beneficiary, _tokenAmount);
1001   }
1002 
1003   function initialAllocation() public onlyOwner {
1004     require(!isInitialAllocated);
1005 
1006     HieToken(token).mint(wallet, INITIAL_ALLOCATE_TOKEN);
1007 
1008     isInitialAllocated = true;
1009   }
1010 
1011   function finalization() internal {
1012     HieToken(token).transferOwnership(wallet);
1013     if (goalReached()) {
1014       vault.close();
1015     } else {
1016       vault.enableRefunds();
1017     }
1018   }
1019 
1020   function withdrawTokens() public {
1021     require(isFinalized);
1022     require(goalReached());
1023     super.withdrawTokens();
1024   }
1025 }