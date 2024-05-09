1 pragma solidity ^0.4.18;
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 pragma solidity ^0.4.18;
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 }
91 
92 pragma solidity ^0.4.18;
93 
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   mapping(address => uint256) balances;
126 
127   uint256 totalSupply_;
128 
129   /**
130   * @dev total number of tokens in existence
131   */
132   function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134   }
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     Transfer(msg.sender, _to, _value);
148     return true;
149   }
150  
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public view returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161 }
162 
163 
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * @dev https://github.com/ethereum/EIPs/issues/20
170  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
171  */
172 contract StandardToken is ERC20, BasicToken {
173 
174   mapping (address => mapping (address => uint256)) internal allowed;
175 
176 
177   /**
178    * @dev Transfer tokens from one address to another
179    * @param _from address The address which you want to send tokens from
180    * @param _to address The address which you want to transfer to
181    * @param _value uint256 the amount of tokens to be transferred
182    */
183   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    *
198    * Beware that changing an allowance with this method brings the risk that someone may use both the old
199    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(address _owner, address _spender) public view returns (uint256) {
218     return allowed[_owner][_spender];
219   }
220 
221   /**
222    * @dev Increase the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To increment
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _addedValue The amount of tokens to increase the allowance by.
230    */
231   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
232     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
233     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To decrement
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _subtractedValue The amount of tokens to decrease the allowance by.
246    */
247   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 
261 
262 /**
263  * @title Burnable Token
264  * @dev Token that can be irreversibly burned (destroyed).
265  */
266 contract BurnableToken is StandardToken {
267 
268   event Burn(address indexed burner, uint256 value);
269 
270   /**
271    * @dev Burns a specific amount of tokens.
272    * @param _value The amount of token to be burned.
273    */
274   function burn(uint256 _value) public {
275     require(_value <= balances[msg.sender]);
276     // no need to require value <= totalSupply, since that would imply the
277     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
278 
279     address burner = msg.sender;
280     balances[burner] = balances[burner].sub(_value);
281     totalSupply_ = totalSupply_.sub(_value);
282     Burn(burner, _value);
283     Transfer(burner, address(0), _value);
284   }
285 }
286 
287 
288 
289 
290 
291 /**
292  * @title Pausable
293  * @dev Base contract which allows children to implement an emergency stop mechanism.
294  */
295 contract Pausable is Ownable {
296   
297   event Pause();
298   event Unpause();
299 
300   bool public paused = false;
301 
302 
303   /**
304    * @dev Modifier to make a function callable only when the contract is not paused.
305    */
306   modifier whenNotPaused() {
307     require(!paused);
308     _;
309   }
310   
311 
312   /**
313    * @dev Modifier to make a function callable only when the contract is paused.
314    */
315   modifier whenPaused() {
316     require(paused);
317     _;
318   }
319 
320   /**
321    * @dev called by the owner to pause, triggers stopped state
322    */
323   function pause() onlyOwner whenNotPaused public {
324     paused = true;
325     Pause();
326   }
327 
328   /**
329    * @dev called by the owner to unpause, returns to normal state
330    */
331   function unpause() onlyOwner whenPaused public {
332     paused = false;
333     Unpause();
334   }
335 }
336 
337 
338 
339 /**
340  * @title Pausable token
341  * @dev StandardToken modified with pausable transfers.
342  **/
343 contract PausableToken is BurnableToken, Pausable {
344     
345   address public icoContract;
346   
347   function setIcoContract(address _icoContract) public onlyOwner {
348     require(_icoContract != address(0));
349     icoContract = _icoContract;
350   }
351   function removeIcoContract() public onlyOwner {
352     icoContract = address(0);
353   }
354   
355   modifier whenNotPausedOrIcoContract() {
356     require(icoContract == msg.sender || !paused);
357     _;
358   }
359   
360   function transfer(address _to, uint256 _value) public whenNotPausedOrIcoContract returns (bool) {
361     return super.transfer(_to, _value);
362   }
363 
364   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
365     return super.transferFrom(_from, _to, _value);
366   }
367 
368   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
369     return super.approve(_spender, _value);
370   }
371 
372   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
373     return super.increaseApproval(_spender, _addedValue);
374   }
375 
376   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
377     return super.decreaseApproval(_spender, _subtractedValue);
378   }
379 }
380 
381 
382 /**
383  * @title Mintable token
384  * @dev Simple ERC20 Token example, with mintable token creation
385  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
386  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
387  */
388 contract MintableToken is PausableToken {
389   event Mint(address indexed to, uint256 amount);
390   event MintFinished();
391 
392   bool public mintingFinished = false;
393 
394 
395   modifier canMint() {
396     require(!mintingFinished);
397     _;
398   }
399 
400   /**
401    * @dev Function to mint tokens
402    * @param _to The address that will receive the minted tokens.
403    * @param _amount The amount of tokens to mint.
404    * @return A boolean that indicates if the operation was successful.
405    */
406   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
407     totalSupply_ = totalSupply_.add(_amount);
408     balances[_to] = balances[_to].add(_amount);
409     Mint(_to, _amount);
410     Transfer(address(0), _to, _amount);
411     return true;
412   }
413 
414   /**
415    * @dev Function to stop minting new tokens.
416    * @return True if the operation was successful.
417    */
418   function finishMinting() onlyOwner canMint public returns (bool) {
419     mintingFinished = true;
420     MintFinished();
421     return true;
422   }
423 }
424 
425 
426 
427 contract DetailedERC20 {
428   string public name;
429   string public symbol;
430   uint8 public decimals;
431 
432   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
433     name = _name;
434     symbol = _symbol;
435     decimals = _decimals;
436   }
437 }
438 
439 
440 
441 contract MonsterBitToken is MintableToken, DetailedERC20 {
442     
443   function MonsterBitToken() public DetailedERC20("MonsterBit", "MB", 18) {
444   }
445   
446 }
447 
448 
449 /**
450  * @title Crowdsale
451  * @dev Crowdsale is a base contract for managing a token crowdsale,
452  * allowing investors to purchase tokens with ether. This contract implements
453  * such functionality in its most fundamental form and can be extended to provide additional
454  * functionality and/or custom behavior.
455  * The external interface represents the basic interface for purchasing tokens, and conform
456  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
457  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
458  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
459  * behavior.
460  */
461 contract Crowdsale {
462   using SafeMath for uint256;
463 
464   // The token being sold
465   MonsterBitToken public token;
466 
467   // Address where funds are collected
468   address public wallet;
469 
470   // How many token units a buyer gets per wei
471   uint256 public rate;
472 
473   // Amount of wei raised
474   uint256 public weiRaised;
475 
476   /**
477    * Event for token purchase logging
478    * @param purchaser who paid for the tokens
479    * @param beneficiary who got the tokens
480    * @param value weis paid for purchase
481    * @param amount amount of tokens purchased
482    */
483   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
484   
485   event TokenSending(address indexed beneficiary, uint256 amount);
486 
487   /**
488    * @param _rate Number of token units a buyer gets per wei
489    * @param _wallet Address where collected funds will be forwarded to
490    * @param _token Address of the token being sold
491    */
492   function Crowdsale(uint256 _rate, address _wallet, MonsterBitToken _token) public {
493     require(_rate > 0);
494     require(_wallet != address(0));
495     require(_token != address(0));
496 
497     rate = _rate;
498     wallet = _wallet;
499     token = _token;
500   }
501 
502   // -----------------------------------------
503   // Crowdsale external interface
504   // -----------------------------------------
505 
506   /**
507    * @dev fallback function ***DO NOT OVERRIDE***
508    */
509   function () external payable {
510     buyTokens(msg.sender);
511   }
512 
513   /**
514    * @dev low level token purchase ***DO NOT OVERRIDE***
515    * @param _beneficiary Address performing the token purchase
516    */
517   function buyTokens(address _beneficiary) public payable {
518 
519     uint256 weiAmount = msg.value;
520     _preValidatePurchase(_beneficiary, weiAmount);
521 
522     // calculate token amount to be created
523     uint256 tokens = _getTokenAmount(weiAmount);
524 
525     // update state
526     weiRaised = weiRaised.add(weiAmount);
527 
528     _processPurchase(_beneficiary, tokens);
529     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
530 
531     _updatePurchasingState(_beneficiary, weiAmount);
532 
533     _forwardFunds();
534     _postValidatePurchase(_beneficiary, weiAmount);
535   }
536 
537   // -----------------------------------------
538   // Internal interface (extensible)
539   // -----------------------------------------
540 
541   /**
542    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
543    * @param _beneficiary Address performing the token purchase
544    * @param _weiAmount Value in wei involved in the purchase
545    */
546   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
547     require(_beneficiary != address(0));
548     require(_weiAmount != 0);
549   }
550 
551   /**
552    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
553    * @param _beneficiary Address performing the token purchase
554    * @param _weiAmount Value in wei involved in the purchase
555    */
556   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
557     // optional override
558   }
559 
560   /**
561    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
562    * @param _beneficiary Address performing the token purchase
563    * @param _tokenAmount Number of tokens to be emitted
564    */
565   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
566     token.transfer(_beneficiary, _tokenAmount);
567   }
568 
569   /**
570    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
571    * @param _beneficiary Address receiving the tokens
572    * @param _tokenAmount Number of tokens to be purchased
573    */
574   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
575     _deliverTokens(_beneficiary, _tokenAmount);
576   }
577 
578   /**
579    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
580    * @param _beneficiary Address receiving the tokens
581    * @param _weiAmount Value in wei involved in the purchase
582    */
583   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
584     // optional override
585   }
586 
587   /**
588    * @dev Override to extend the way in which ether is converted to tokens.
589    * @param _weiAmount Value in wei to be converted into tokens
590    * @return Number of tokens that can be purchased with the specified _weiAmount
591    */
592   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
593     return _weiAmount.mul(rate);
594   }
595 
596   /**
597    * @dev Determines how ETH is stored/forwarded on purchases.
598    */
599   function _forwardFunds() internal {
600     wallet.transfer(msg.value);
601   }
602 }
603 
604 
605 
606 /**
607  * @title TimedCrowdsale
608  * @dev Crowdsale accepting contributions only within a time frame.
609  */
610 contract TimedCrowdsale is Crowdsale {
611   using SafeMath for uint256;
612 
613   uint256 public openingTime;
614   uint256 public closingTime;
615 
616   /**
617    * @dev Reverts if not in crowdsale time range.
618    */
619   modifier onlyWhileOpen {
620     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
621     _;
622   }
623 
624   /**
625    * @dev Constructor, takes crowdsale opening and closing times.
626    * @param _openingTime Crowdsale opening time
627    * @param _closingTime Crowdsale closing time
628    */
629   function TimedCrowdsale(uint256 _rate, address _wallet, MonsterBitToken _token, uint256 _openingTime, uint256 _closingTime) public
630     Crowdsale(_rate, _wallet, _token) 
631   {
632     //require(_openingTime >= block.timestamp);
633     require(_closingTime >= _openingTime);
634 
635     openingTime = _openingTime;
636     closingTime = _closingTime;
637   }
638 
639   /**
640    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
641    * @return Whether crowdsale period has elapsed
642    */
643   function hasClosed() public view returns (bool) {
644     return block.timestamp > closingTime;
645   }
646 
647   /**
648    * @dev Extend parent behavior requiring to be within contributing period
649    * @param _beneficiary Token purchaser
650    * @param _weiAmount Amount of wei contributed
651    */
652   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
653     super._preValidatePurchase(_beneficiary, _weiAmount);
654   }
655   
656     // todo add additional functions overrides with onlyWhileOpen here
657 }
658 
659 
660 /**
661  * @title FinalizableCrowdsale
662  * @dev Extension of Crowdsale where an owner can do extra work
663  * after finishing.
664  */
665 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
666   using SafeMath for uint256;
667 
668   bool public isFinalized = false;
669 
670   event Finalized();
671   
672   function FinalizableCrowdsale(uint256 _rate, address _wallet, MonsterBitToken _token, uint256 _openingTime, uint256 _closingTime) public
673     TimedCrowdsale(_rate, _wallet, _token, _openingTime, _closingTime) 
674   {
675   }
676   
677   /**
678    * @dev Must be called after crowdsale ends, to do some extra finalization
679    * work. Calls the contract's finalization function.
680    */
681   function finalize() onlyOwner public {
682     require(!isFinalized);
683     require(hasClosed());
684 
685     finalization();
686     Finalized();
687 
688     isFinalized = true;
689   }
690 
691   /**
692    * @dev Can be overridden to add finalization logic. The overriding function
693    * should call super.finalization() to ensure the chain of finalization is
694    * executed entirely.
695    */
696   function finalization() internal {
697       token.burn(tokenBalance());
698   }
699   
700   function tokenBalance() public view returns (uint256) {
701       return token.balanceOf(this);
702   }
703 }
704 
705 
706 contract MonsterTokenCrowdsale is FinalizableCrowdsale {
707     
708   function MonsterTokenCrowdsale(uint256 _rate, address _wallet, address _token, uint256 _openingTime, uint256 _closingTime) public
709     FinalizableCrowdsale(_rate, _wallet, MonsterBitToken(_token),  _openingTime, _closingTime) {
710   }
711   
712   function setRate(uint256 newRate) public onlyOwner {
713       rate = newRate;
714   }
715   
716   function sendTokens(address beneficiary, uint256 tokensAmount) public onlyOwner {
717     require(beneficiary != address(0));
718     _processPurchase(beneficiary, tokensAmount);
719     TokenSending(beneficiary, tokensAmount); // event
720   }
721 }