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
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
135   }
136 }
137 
138 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
139 
140 /**
141  * @title Ownable
142  * @dev The Ownable contract has an owner address, and provides basic authorization control
143  * functions, this simplifies the implementation of "user permissions".
144  */
145 contract Ownable {
146   address public owner;
147 
148 
149   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151 
152   /**
153    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
154    * account.
155    */
156   function Ownable() public {
157     owner = msg.sender;
158   }
159 
160   /**
161    * @dev Throws if called by any account other than the owner.
162    */
163   modifier onlyOwner() {
164     require(msg.sender == owner);
165     _;
166   }
167 
168   /**
169    * @dev Allows the current owner to transfer control of the contract to a newOwner.
170    * @param newOwner The address to transfer ownership to.
171    */
172   function transferOwnership(address newOwner) public onlyOwner {
173     require(newOwner != address(0));
174     OwnershipTransferred(owner, newOwner);
175     owner = newOwner;
176   }
177 
178 }
179 
180 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 is ERC20Basic {
187   function allowance(address owner, address spender) public view returns (uint256);
188   function transferFrom(address from, address to, uint256 value) public returns (bool);
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
194 
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  */
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(address _owner, address _spender) public view returns (uint256) {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * @dev Increase the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
262     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
278     uint oldValue = allowed[msg.sender][_spender];
279     if (_subtractedValue > oldValue) {
280       allowed[msg.sender][_spender] = 0;
281     } else {
282       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288 }
289 
290 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
291 
292 /**
293  * @title Mintable token
294  * @dev Simple ERC20 Token example, with mintable token creation
295  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
296  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
297  */
298 contract MintableToken is StandardToken, Ownable {
299   event Mint(address indexed to, uint256 amount);
300   event MintFinished();
301 
302   bool public mintingFinished = false;
303 
304 
305   modifier canMint() {
306     require(!mintingFinished);
307     _;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
317     totalSupply_ = totalSupply_.add(_amount);
318     balances[_to] = balances[_to].add(_amount);
319     Mint(_to, _amount);
320     Transfer(address(0), _to, _amount);
321     return true;
322   }
323 
324   /**
325    * @dev Function to stop minting new tokens.
326    * @return True if the operation was successful.
327    */
328   function finishMinting() onlyOwner canMint public returns (bool) {
329     mintingFinished = true;
330     MintFinished();
331     return true;
332   }
333 }
334 
335 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
336 
337 /**
338  * @title Pausable
339  * @dev Base contract which allows children to implement an emergency stop mechanism.
340  */
341 contract Pausable is Ownable {
342   event Pause();
343   event Unpause();
344 
345   bool public paused = false;
346 
347 
348   /**
349    * @dev Modifier to make a function callable only when the contract is not paused.
350    */
351   modifier whenNotPaused() {
352     require(!paused);
353     _;
354   }
355 
356   /**
357    * @dev Modifier to make a function callable only when the contract is paused.
358    */
359   modifier whenPaused() {
360     require(paused);
361     _;
362   }
363 
364   /**
365    * @dev called by the owner to pause, triggers stopped state
366    */
367   function pause() onlyOwner whenNotPaused public {
368     paused = true;
369     Pause();
370   }
371 
372   /**
373    * @dev called by the owner to unpause, returns to normal state
374    */
375   function unpause() onlyOwner whenPaused public {
376     paused = false;
377     Unpause();
378   }
379 }
380 
381 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
382 
383 /**
384  * @title Pausable token
385  * @dev StandardToken modified with pausable transfers.
386  **/
387 contract PausableToken is StandardToken, Pausable {
388 
389   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
390     return super.transfer(_to, _value);
391   }
392 
393   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
394     return super.transferFrom(_from, _to, _value);
395   }
396 
397   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
398     return super.approve(_spender, _value);
399   }
400 
401   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
402     return super.increaseApproval(_spender, _addedValue);
403   }
404 
405   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
406     return super.decreaseApproval(_spender, _subtractedValue);
407   }
408 }
409 
410 // File: contracts/FlyCareToken.sol
411 
412 contract FlyCareToken is MintableToken, PausableToken, BurnableToken {
413 
414     string public constant name = "flyCARE Token";
415     string public constant symbol = "FCC";
416     uint8 public constant decimals = 18;
417 
418     function FlyCareToken() public {
419         pause();
420     }
421 }
422 
423 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
424 
425 /**
426  * @title Crowdsale
427  * @dev Crowdsale is a base contract for managing a token crowdsale,
428  * allowing investors to purchase tokens with ether. This contract implements
429  * such functionality in its most fundamental form and can be extended to provide additional
430  * functionality and/or custom behavior.
431  * The external interface represents the basic interface for purchasing tokens, and conform
432  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
433  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
434  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
435  * behavior.
436  */
437 
438 contract Crowdsale {
439   using SafeMath for uint256;
440 
441   // The token being sold
442   ERC20 public token;
443 
444   // Address where funds are collected
445   address public wallet;
446 
447   // How many token units a buyer gets per wei
448   uint256 public rate;
449 
450   // Amount of wei raised
451   uint256 public weiRaised;
452 
453   /**
454    * Event for token purchase logging
455    * @param purchaser who paid for the tokens
456    * @param beneficiary who got the tokens
457    * @param value weis paid for purchase
458    * @param amount amount of tokens purchased
459    */
460   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
461 
462   /**
463    * @param _rate Number of token units a buyer gets per wei
464    * @param _wallet Address where collected funds will be forwarded to
465    * @param _token Address of the token being sold
466    */
467   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
468     require(_rate > 0);
469     require(_wallet != address(0));
470     require(_token != address(0));
471 
472     rate = _rate;
473     wallet = _wallet;
474     token = _token;
475   }
476 
477   // -----------------------------------------
478   // Crowdsale external interface
479   // -----------------------------------------
480 
481   /**
482    * @dev fallback function ***DO NOT OVERRIDE***
483    */
484   function () external payable {
485     buyTokens(msg.sender);
486   }
487 
488   /**
489    * @dev low level token purchase ***DO NOT OVERRIDE***
490    * @param _beneficiary Address performing the token purchase
491    */
492   function buyTokens(address _beneficiary) public payable {
493 
494     uint256 weiAmount = msg.value;
495     _preValidatePurchase(_beneficiary, weiAmount);
496 
497     // calculate token amount to be created
498     uint256 tokens = _getTokenAmount(weiAmount);
499 
500     // update state
501     weiRaised = weiRaised.add(weiAmount);
502 
503     _processPurchase(_beneficiary, tokens);
504     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
505 
506     _updatePurchasingState(_beneficiary, weiAmount);
507 
508     _forwardFunds();
509     _postValidatePurchase(_beneficiary, weiAmount);
510   }
511 
512   // -----------------------------------------
513   // Internal interface (extensible)
514   // -----------------------------------------
515 
516   /**
517    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
518    * @param _beneficiary Address performing the token purchase
519    * @param _weiAmount Value in wei involved in the purchase
520    */
521   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
522     require(_beneficiary != address(0));
523     require(_weiAmount != 0);
524   }
525 
526   /**
527    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
528    * @param _beneficiary Address performing the token purchase
529    * @param _weiAmount Value in wei involved in the purchase
530    */
531   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
532     // optional override
533   }
534 
535   /**
536    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
537    * @param _beneficiary Address performing the token purchase
538    * @param _tokenAmount Number of tokens to be emitted
539    */
540   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
541     token.transfer(_beneficiary, _tokenAmount);
542   }
543 
544   /**
545    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
546    * @param _beneficiary Address receiving the tokens
547    * @param _tokenAmount Number of tokens to be purchased
548    */
549   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
550     _deliverTokens(_beneficiary, _tokenAmount);
551   }
552 
553   /**
554    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
555    * @param _beneficiary Address receiving the tokens
556    * @param _weiAmount Value in wei involved in the purchase
557    */
558   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
559     // optional override
560   }
561 
562   /**
563    * @dev Override to extend the way in which ether is converted to tokens.
564    * @param _weiAmount Value in wei to be converted into tokens
565    * @return Number of tokens that can be purchased with the specified _weiAmount
566    */
567   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
568     return _weiAmount.mul(rate);
569   }
570 
571   /**
572    * @dev Determines how ETH is stored/forwarded on purchases.
573    */
574   function _forwardFunds() internal {
575     wallet.transfer(msg.value);
576   }
577 }
578 
579 // File: contracts/TokenCappedCrowdsale.sol
580 
581 /**
582  * @title TokenCappedCrowdsale
583  * @dev Extension of Crowdsale with a max amount of tokens sold
584  */
585 contract TokenCappedCrowdsale is Crowdsale {
586     using SafeMath for uint256;
587 
588     uint256 public tokenSold;
589     uint256 public tokenPresaleCap;
590     uint256 public tokenPresaleSold;
591     uint256 public saleStartTime;
592     uint256 public totalTokenSaleCap;
593 
594     /**
595      * @dev Constructor, takes presal cap, maximum number of tokens to be minted by the crowdsale and start date of regular sale period.
596      * @param _tokenPresaleCap Max number of tokens to be sold during presale
597      * @param _totalTokenSaleCap Max number of tokens to be minted
598      * @param _saleStartTime Start date of the sale period
599      */
600     function TokenCappedCrowdsale(uint256 _tokenPresaleCap, uint256 _totalTokenSaleCap, uint256 _saleStartTime) public {
601       require(_tokenPresaleCap > 0);
602       require(_totalTokenSaleCap > 0);
603       tokenPresaleCap = _tokenPresaleCap;
604       saleStartTime = _saleStartTime;
605       totalTokenSaleCap = _totalTokenSaleCap;
606     }
607 
608     /**
609      * @dev Checks whether the cap has been reached. 
610      * @return Whether the cap was reached
611      */
612     function tokenCapReached() public view returns (bool) {
613       return tokenSold >= totalTokenSaleCap;
614     }
615 
616     /**
617      * @dev Extend parent behavior requiring purchase to respect the minting cap.
618      * @param _beneficiary Token purchaser
619      * @param _weiAmount Amount of wei contributed
620      */
621     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
622         super._preValidatePurchase(_beneficiary, _weiAmount);
623         // calculate token amount to be created
624         uint256 tokenAmount = _getTokenAmount(_weiAmount);
625         // Enforce presale cap before the begining of the sale
626 	if (block.timestamp < saleStartTime) {
627             require(tokenPresaleSold.add(tokenAmount) <= tokenPresaleCap);
628         } else {
629         // Enfore total (presale + sale) token cap once the sale has started
630             require(tokenSold.add(tokenAmount) <= totalTokenSaleCap);
631         }
632     }
633 
634     /**
635      * @dev Extend parent behavior updating the number of token sold.
636      * @param _beneficiary Address receiving the tokens
637      * @param _tokenAmount Number of tokens to be purchased
638      */
639     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
640         super._processPurchase(_beneficiary, _tokenAmount);
641         // update state
642         // Keep track of all token sold in tokenSold
643         tokenSold = tokenSold.add(_tokenAmount);
644         // During presale only, keep track of token sold in tokenPresaleSold
645         if (block.timestamp < saleStartTime) {
646             tokenPresaleSold = tokenPresaleSold.add(_tokenAmount);
647         }
648     }
649 
650 }
651 
652 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
653 
654 /**
655  * @title TimedCrowdsale
656  * @dev Crowdsale accepting contributions only within a time frame.
657  */
658 contract TimedCrowdsale is Crowdsale {
659   using SafeMath for uint256;
660 
661   uint256 public openingTime;
662   uint256 public closingTime;
663 
664   /**
665    * @dev Reverts if not in crowdsale time range. 
666    */
667   modifier onlyWhileOpen {
668     require(now >= openingTime && now <= closingTime);
669     _;
670   }
671 
672   /**
673    * @dev Constructor, takes crowdsale opening and closing times.
674    * @param _openingTime Crowdsale opening time
675    * @param _closingTime Crowdsale closing time
676    */
677   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
678     //require(_openingTime >= now);
679     require(_closingTime >= _openingTime);
680 
681     openingTime = _openingTime;
682     closingTime = _closingTime;
683   }
684 
685   /**
686    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
687    * @return Whether crowdsale period has elapsed
688    */
689   function hasClosed() public view returns (bool) {
690     return now > closingTime;
691   }
692   
693   /**
694    * @dev Extend parent behavior requiring to be within contributing period
695    * @param _beneficiary Token purchaser
696    * @param _weiAmount Amount of wei contributed
697    */
698   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
699     super._preValidatePurchase(_beneficiary, _weiAmount);
700   }
701 
702 }
703 
704 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
705 
706 /**
707  * @title FinalizableCrowdsale
708  * @dev Extension of Crowdsale where an owner can do extra work
709  * after finishing.
710  */
711 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
712   using SafeMath for uint256;
713 
714   bool public isFinalized = false;
715 
716   event Finalized();
717 
718   /**
719    * @dev Must be called after crowdsale ends, to do some extra finalization
720    * work. Calls the contract's finalization function.
721    */
722   function finalize() onlyOwner public {
723     require(!isFinalized);
724     require(hasClosed());
725 
726     finalization();
727     Finalized();
728 
729     isFinalized = true;
730   }
731 
732   /**
733    * @dev Can be overridden to add finalization logic. The overriding function
734    * should call super.finalization() to ensure the chain of finalization is
735    * executed entirely.
736    */
737   function finalization() internal {
738   }
739 }
740 
741 // File: zeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
742 
743 /**
744  * @title RefundVault
745  * @dev This contract is used for storing funds while a crowdsale
746  * is in progress. Supports refunding the money if crowdsale fails,
747  * and forwarding it if crowdsale is successful.
748  */
749 contract RefundVault is Ownable {
750   using SafeMath for uint256;
751 
752   enum State { Active, Refunding, Closed }
753 
754   mapping (address => uint256) public deposited;
755   address public wallet;
756   State public state;
757 
758   event Closed();
759   event RefundsEnabled();
760   event Refunded(address indexed beneficiary, uint256 weiAmount);
761 
762   /**
763    * @param _wallet Vault address
764    */
765   function RefundVault(address _wallet) public {
766     require(_wallet != address(0));
767     wallet = _wallet;
768     state = State.Active;
769   }
770 
771   /**
772    * @param investor Investor address
773    */
774   function deposit(address investor) onlyOwner public payable {
775     require(state == State.Active);
776     deposited[investor] = deposited[investor].add(msg.value);
777   }
778 
779   function close() onlyOwner public {
780     require(state == State.Active);
781     state = State.Closed;
782     Closed();
783     wallet.transfer(this.balance);
784   }
785 
786   function enableRefunds() onlyOwner public {
787     require(state == State.Active);
788     state = State.Refunding;
789     RefundsEnabled();
790   }
791 
792   /**
793    * @param investor Investor address
794    */
795   function refund(address investor) public {
796     require(state == State.Refunding);
797     uint256 depositedValue = deposited[investor];
798     deposited[investor] = 0;
799     investor.transfer(depositedValue);
800     Refunded(investor, depositedValue);
801   }
802 }
803 
804 // File: zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
805 
806 /**
807  * @title RefundableCrowdsale
808  * @dev Extension of Crowdsale contract that adds a funding goal, and
809  * the possibility of users getting a refund if goal is not met.
810  * Uses a RefundVault as the crowdsale's vault.
811  */
812 contract RefundableCrowdsale is FinalizableCrowdsale {
813   using SafeMath for uint256;
814 
815   // minimum amount of funds to be raised in weis
816   uint256 public goal;
817 
818   // refund vault used to hold funds while crowdsale is running
819   RefundVault public vault;
820 
821   /**
822    * @dev Constructor, creates RefundVault. 
823    * @param _goal Funding goal
824    */
825   function RefundableCrowdsale(uint256 _goal) public {
826     require(_goal > 0);
827     vault = new RefundVault(wallet);
828     goal = _goal;
829   }
830 
831   /**
832    * @dev Investors can claim refunds here if crowdsale is unsuccessful
833    */
834   function claimRefund() public {
835     require(isFinalized);
836     require(!goalReached());
837 
838     vault.refund(msg.sender);
839   }
840 
841   /**
842    * @dev Checks whether funding goal was reached. 
843    * @return Whether funding goal was reached
844    */
845   function goalReached() public view returns (bool) {
846     return weiRaised >= goal;
847   }
848 
849   /**
850    * @dev vault finalization task, called when owner calls finalize()
851    */
852   function finalization() internal {
853     if (goalReached()) {
854       vault.close();
855     } else {
856       vault.enableRefunds();
857     }
858 
859     super.finalization();
860   }
861 
862   /**
863    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
864    */
865   function _forwardFunds() internal {
866     vault.deposit.value(msg.value)(msg.sender);
867   }
868 
869 }
870 
871 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
872 
873 /**
874  * @title MintedCrowdsale
875  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
876  * Token ownership should be transferred to MintedCrowdsale for minting. 
877  */
878 contract MintedCrowdsale is Crowdsale {
879 
880   /**
881   * @dev Overrides delivery by minting tokens upon purchase.
882   * @param _beneficiary Token purchaser
883   * @param _tokenAmount Number of tokens to be minted
884   */
885   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
886     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
887   }
888 }
889 
890 // File: zeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
891 
892 /**
893  * @title WhitelistedCrowdsale
894  * @dev Crowdsale in which only whitelisted users can contribute.
895  */
896 contract WhitelistedCrowdsale is Crowdsale, Ownable {
897 
898   mapping(address => bool) public whitelist;
899 
900   /**
901    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
902    */
903   modifier isWhitelisted(address _beneficiary) {
904     require(whitelist[_beneficiary]);
905     _;
906   }
907 
908   /**
909    * @dev Adds single address to whitelist.
910    * @param _beneficiary Address to be added to the whitelist
911    */
912   function addToWhitelist(address _beneficiary) external onlyOwner {
913     whitelist[_beneficiary] = true;
914   }
915   
916   /**
917    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing. 
918    * @param _beneficiaries Addresses to be added to the whitelist
919    */
920   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
921     for (uint256 i = 0; i < _beneficiaries.length; i++) {
922       whitelist[_beneficiaries[i]] = true;
923     }
924   }
925 
926   /**
927    * @dev Removes single address from whitelist. 
928    * @param _beneficiary Address to be removed to the whitelist
929    */
930   function removeFromWhitelist(address _beneficiary) external onlyOwner {
931     whitelist[_beneficiary] = false;
932   }
933 
934   /**
935    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
936    * @param _beneficiary Token beneficiary
937    * @param _weiAmount Amount of wei contributed
938    */
939   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
940     super._preValidatePurchase(_beneficiary, _weiAmount);
941   }
942 
943 }
944 
945 // File: contracts/FlyCareTokenSale.sol
946 
947 contract FlyCareTokenSale is RefundableCrowdsale, WhitelistedCrowdsale, TokenCappedCrowdsale, MintedCrowdsale, Pausable {
948     using SafeMath for uint256;
949 
950     // Constants
951     uint256 constant public RESERVE_AMOUNT = 70000000 * 10**18; // 50M FCC reserve + 20M FCC team and advisors
952     // MAX_TEAM_AMOUNT = 20000000
953     // PreSale CAP : 32500000
954     // MainSale CAP : 97500000
955 
956     uint256 constant public MIN_INVESTMENT = 0.1 * 10**18; // 0.1ETH minimal investment
957 
958     // Private
959     uint64[5] private salePeriods;
960 
961     // Public
962     address public whitelister;
963 
964     // Events
965     event AddToWhitelist(address _beneficiary);
966 
967     function FlyCareTokenSale (
968         address _whitelister,
969         uint256 _startTime,
970         uint256 _endTime,
971         uint256 _rate,
972         uint256 _goal,
973         uint256 _presaleCap,
974         uint256 _totalTokenSaleCap,
975         address _wallet,
976         uint64[5] _salePeriods
977       ) public
978       Crowdsale(_rate, _wallet, new FlyCareToken())
979       TokenCappedCrowdsale(_presaleCap, _totalTokenSaleCap, _salePeriods[2])
980       TimedCrowdsale(_startTime, _endTime)
981       RefundableCrowdsale(_goal)
982     {
983         require(_goal.mul(_rate) <= _totalTokenSaleCap);
984         require(_whitelister != address(0));
985 
986         for (uint8 i = 0; i < _salePeriods.length; i++) {
987             require(_salePeriods[i] > 0);
988         }
989         salePeriods = _salePeriods;
990         whitelister = _whitelister;
991     }
992 
993     /**
994      * @dev Extend parent behavior requiring the sale not to be paused.
995      * @param _beneficiary Token purchaser
996      * @param _weiAmount Amount of wei contributed
997      */
998     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
999         require(!paused);
1000         require(_weiAmount >= MIN_INVESTMENT);
1001         super._preValidatePurchase(_beneficiary, _weiAmount);
1002     }
1003 
1004     // descending rate
1005     function getCurrentRate() public view returns (uint256) {
1006         uint256 time = now;
1007         if (time <= salePeriods[0]) {
1008             return 4031;
1009         }
1010         
1011         if (time <= salePeriods[1]) {
1012             return 3794;
1013         }
1014 
1015         if (time <= salePeriods[2]) {
1016             return 3583;
1017         }
1018 
1019         if (time <= salePeriods[3]) {
1020             return 3395;
1021         }
1022 
1023         if (time <= salePeriods[4]) {
1024             return 3225;
1025         }
1026         return rate;
1027     }
1028 
1029     /**
1030      * @dev Overrides parent method taking into account variable rate.
1031      * @param _weiAmount The value in wei to be converted into tokens
1032      * @return The number of tokens _weiAmount wei will buy at present time
1033      */
1034     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1035         uint256 currentRate = getCurrentRate();
1036         return currentRate.mul(_weiAmount);
1037     }
1038 
1039     /**
1040      * @dev Overrides TimedCrowdsale#hasClosed method to end sale permaturely if token cap has been reached.
1041      * @return Whether crowdsale has finished
1042      */
1043     function hasClosed() public view returns (bool) {
1044         return tokenCapReached() || super.hasClosed();
1045     }
1046 
1047 
1048     /*******************************************
1049      * Whitelisting related functions*
1050      *******************************************/
1051 
1052     /**
1053      * @dev Change whitelister address to another one if provided by owner
1054      * @param _whitelister address of the new whitelister
1055      */
1056 
1057     function setWhitelisterAddress(address _whitelister) external onlyOwner {
1058         require(_whitelister != address(0));
1059         whitelister = _whitelister;
1060     }
1061 
1062     /**
1063      * @dev Modifier for address whith whitelisting rights
1064     */
1065     modifier onlyWhitelister(){
1066         require(msg.sender == whitelister);
1067         _;
1068     }
1069 
1070     /**
1071      * @dev Overrides addToWhitelist from WhitelistedCrowdsale to use a dedicated address instead of Owner
1072      * @param _beneficiary Address to be added to the whitelist
1073      */
1074     function addToWhitelist(address _beneficiary) external onlyWhitelister {
1075         whitelist[_beneficiary] = true;
1076         AddToWhitelist(_beneficiary);
1077     }
1078 
1079     /**
1080      * @dev Overrides addToWhitelist from WhitelistedCrowdsale to use a dedicated address instead of Owner
1081      * @param _beneficiaries Addresses to be added to the whitelist
1082      */
1083     function addManyToWhitelist(address[] _beneficiaries) external onlyWhitelister {
1084         for (uint256 i = 0; i < _beneficiaries.length; i++) {
1085             whitelist[_beneficiaries[i]] = true;
1086             AddToWhitelist(_beneficiaries[i]);
1087         }
1088     }
1089 
1090     /**
1091      * @dev Overrides addToWhitelist from WhitelistedCrowdsale to use a dedicated address instead of Owner
1092      * @param _beneficiary Address to be removed to the whitelist
1093      */
1094     function removeFromWhitelist(address _beneficiary) external onlyWhitelister {
1095         whitelist[_beneficiary] = false;
1096     }
1097 
1098     function finalization() internal {
1099         if (goalReached()) {
1100             if (!tokenCapReached()) {
1101                 uint256 tokenUnsold = totalTokenSaleCap.sub(tokenSold);
1102                 // Mint unsold tokens to sale's address & burn them immediately
1103                 _deliverTokens(this, tokenUnsold);
1104                 FlyCareToken(token).burn(tokenUnsold);
1105             }
1106           
1107             // Allocate remaining reserve to multisig wallet
1108             _deliverTokens(wallet, RESERVE_AMOUNT);
1109 
1110             // Finish token minting & unpause transfers
1111             require(FlyCareToken(token).finishMinting());
1112             FlyCareToken(token).unpause();
1113         }
1114 
1115         super.finalization();
1116     }
1117 
1118 }