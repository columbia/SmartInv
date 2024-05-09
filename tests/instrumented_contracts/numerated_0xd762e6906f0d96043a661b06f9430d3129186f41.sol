1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   /**
56   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable {
80   address public owner;
81 
82 
83   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   function Ownable() public {
91     owner = msg.sender;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address newOwner) public onlyOwner {
107     require(newOwner != address(0));
108     OwnershipTransferred(owner, newOwner);
109     owner = newOwner;
110   }
111 
112 }
113 
114 
115 /**
116  * @title Crowdsale
117  * @dev Crowdsale is a base contract for managing a token crowdsale,
118  * allowing investors to purchase tokens with ether. This contract implements
119  * such functionality in its most fundamental form and can be extended to provide additional
120  * functionality and/or custom behavior.
121  * The external interface represents the basic interface for purchasing tokens, and conform
122  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
123  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
124  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
125  * behavior.
126  */
127 
128 contract Crowdsale {
129   using SafeMath for uint256;
130 
131   // The token being sold
132   ERC20 public token;
133 
134   // Address where funds are collected
135   address public wallet;
136 
137   // How many token units a buyer gets per wei
138   uint256 public rate;
139 
140   // Amount of wei raised
141   uint256 public weiRaised;
142 
143   /**
144    * Event for token purchase logging
145    * @param purchaser who paid for the tokens
146    * @param beneficiary who got the tokens
147    * @param value weis paid for purchase
148    * @param amount amount of tokens purchased
149    */
150   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
151 
152   /**
153    * @param _rate Number of token units a buyer gets per wei
154    * @param _wallet Address where collected funds will be forwarded to
155    * @param _token Address of the token being sold
156    */
157   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
158     require(_rate > 0);
159     require(_wallet != address(0));
160     require(_token != address(0));
161 
162     rate = _rate;
163     wallet = _wallet;
164     token = _token;
165   }
166 
167   // -----------------------------------------
168   // Crowdsale external interface
169   // -----------------------------------------
170 
171   /**
172    * @dev fallback function ***DO NOT OVERRIDE***
173    */
174   function () external payable {
175     buyTokens(msg.sender);
176   }
177 
178   /**
179    * @dev low level token purchase ***DO NOT OVERRIDE***
180    * @param _beneficiary Address performing the token purchase
181    */
182   function buyTokens(address _beneficiary) public payable {
183 
184     uint256 weiAmount = msg.value;
185     _preValidatePurchase(_beneficiary, weiAmount);
186 
187     // calculate token amount to be created
188     uint256 tokens = _getTokenAmount(weiAmount);
189 
190     // update state
191     weiRaised = weiRaised.add(weiAmount);
192 
193     _processPurchase(_beneficiary, tokens);
194     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
195 
196     _updatePurchasingState(_beneficiary, weiAmount);
197 
198     _forwardFunds();
199     _postValidatePurchase(_beneficiary, weiAmount);
200   }
201 
202   // -----------------------------------------
203   // Internal interface (extensible)
204   // -----------------------------------------
205 
206   /**
207    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
208    * @param _beneficiary Address performing the token purchase
209    * @param _weiAmount Value in wei involved in the purchase
210    */
211   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
212     require(_beneficiary != address(0));
213     require(_weiAmount != 0);
214   }
215 
216   /**
217    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
218    * @param _beneficiary Address performing the token purchase
219    * @param _weiAmount Value in wei involved in the purchase
220    */
221   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
222     // optional override
223   }
224 
225   /**
226    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
227    * @param _beneficiary Address performing the token purchase
228    * @param _tokenAmount Number of tokens to be emitted
229    */
230   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
231     token.transfer(_beneficiary, _tokenAmount);
232   }
233 
234   /**
235    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
236    * @param _beneficiary Address receiving the tokens
237    * @param _tokenAmount Number of tokens to be purchased
238    */
239   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
240     _deliverTokens(_beneficiary, _tokenAmount);
241   }
242 
243   /**
244    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
245    * @param _beneficiary Address receiving the tokens
246    * @param _weiAmount Value in wei involved in the purchase
247    */
248   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
249     // optional override
250   }
251 
252   /**
253    * @dev Override to extend the way in which ether is converted to tokens.
254    * @param _weiAmount Value in wei to be converted into tokens
255    * @return Number of tokens that can be purchased with the specified _weiAmount
256    */
257   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
258     return _weiAmount.mul(rate);
259   }
260 
261   /**
262    * @dev Determines how ETH is stored/forwarded on purchases.
263    */
264   function _forwardFunds() internal {
265     wallet.transfer(msg.value);
266   }
267   
268 
269 }
270 
271 
272 
273 /**
274  * @title Basic token
275  * @dev Basic version of StandardToken, with no allowances.
276  */
277 contract BasicToken is ERC20Basic {
278   using SafeMath for uint256;
279 
280   mapping(address => uint256) balances;
281 
282   uint256 totalSupply_;
283 
284   /**
285   * @dev total number of tokens in existence
286   */
287   function totalSupply() public view returns (uint256) {
288     return totalSupply_;
289   }
290 
291   /**
292   * @dev transfer token for a specified address
293   * @param _to The address to transfer to.
294   * @param _value The amount to be transferred.
295   */
296   function transfer(address _to, uint256 _value) public returns (bool) {
297     require(_to != address(0));
298     require(_value <= balances[msg.sender]);
299 
300     // SafeMath.sub will throw if there is not enough balance.
301     balances[msg.sender] = balances[msg.sender].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     Transfer(msg.sender, _to, _value);
304     return true;
305   }
306 
307   /**
308   * @dev Gets the balance of the specified address.
309   * @param _owner The address to query the the balance of.
310   * @return An uint256 representing the amount owned by the passed address.
311   */
312   function balanceOf(address _owner) public view returns (uint256 balance) {
313     return balances[_owner];
314   }
315 
316 }
317 
318 
319 /**
320  * @title Standard ERC20 token
321  *
322  * @dev Implementation of the basic standard token.
323  * @dev https://github.com/ethereum/EIPs/issues/20
324  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
325  */
326 contract StandardToken is ERC20, BasicToken {
327 
328   mapping (address => mapping (address => uint256)) internal allowed;
329 
330 
331   /**
332    * @dev Transfer tokens from one address to another
333    * @param _from address The address which you want to send tokens from
334    * @param _to address The address which you want to transfer to
335    * @param _value uint256 the amount of tokens to be transferred
336    */
337   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
338     require(_to != address(0));
339     require(_value <= balances[_from]);
340     require(_value <= allowed[_from][msg.sender]);
341 
342     balances[_from] = balances[_from].sub(_value);
343     balances[_to] = balances[_to].add(_value);
344     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
345     Transfer(_from, _to, _value);
346     return true;
347   }
348 
349   /**
350    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
351    *
352    * Beware that changing an allowance with this method brings the risk that someone may use both the old
353    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
354    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
355    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
356    * @param _spender The address which will spend the funds.
357    * @param _value The amount of tokens to be spent.
358    */
359   function approve(address _spender, uint256 _value) public returns (bool) {
360     allowed[msg.sender][_spender] = _value;
361     Approval(msg.sender, _spender, _value);
362     return true;
363   }
364 
365   /**
366    * @dev Function to check the amount of tokens that an owner allowed to a spender.
367    * @param _owner address The address which owns the funds.
368    * @param _spender address The address which will spend the funds.
369    * @return A uint256 specifying the amount of tokens still available for the spender.
370    */
371   function allowance(address _owner, address _spender) public view returns (uint256) {
372     return allowed[_owner][_spender];
373   }
374 
375   /**
376    * @dev Increase the amount of tokens that an owner allowed to a spender.
377    *
378    * approve should be called when allowed[_spender] == 0. To increment
379    * allowed value is better to use this function to avoid 2 calls (and wait until
380    * the first transaction is mined)
381    * From MonolithDAO Token.sol
382    * @param _spender The address which will spend the funds.
383    * @param _addedValue The amount of tokens to increase the allowance by.
384    */
385   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
386     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
387     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
388     return true;
389   }
390 
391   /**
392    * @dev Decrease the amount of tokens that an owner allowed to a spender.
393    *
394    * approve should be called when allowed[_spender] == 0. To decrement
395    * allowed value is better to use this function to avoid 2 calls (and wait until
396    * the first transaction is mined)
397    * From MonolithDAO Token.sol
398    * @param _spender The address which will spend the funds.
399    * @param _subtractedValue The amount of tokens to decrease the allowance by.
400    */
401   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
402     uint oldValue = allowed[msg.sender][_spender];
403     if (_subtractedValue > oldValue) {
404       allowed[msg.sender][_spender] = 0;
405     } else {
406       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
407     }
408     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
409     return true;
410   }
411 
412 }
413 
414 
415 
416 
417 /**
418  * @title Mintable token
419  * @dev Simple ERC20 Token example, with mintable token creation
420  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
421  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
422  */
423 contract MintableToken is StandardToken, Ownable {
424   event Mint(address indexed to, uint256 amount);
425   event MintFinished();
426 
427   bool public mintingFinished = false;
428 
429 
430   modifier canMint() {
431     require(!mintingFinished);
432     _;
433   }
434 
435   /**
436    * @dev Function to mint tokens
437    * @param _to The address that will receive the minted tokens.
438    * @param _amount The amount of tokens to mint.
439    * @return A boolean that indicates if the operation was successful.
440    */
441   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
442     totalSupply_ = totalSupply_.add(_amount);
443     balances[_to] = balances[_to].add(_amount);
444     Mint(_to, _amount);
445     Transfer(address(0), _to, _amount);
446     return true;
447   }
448 
449   /**
450    * @dev Function to stop minting new tokens.
451    * @return True if the operation was successful.
452    */
453   function finishMinting() onlyOwner canMint public returns (bool) {
454     mintingFinished = true;
455     MintFinished();
456     return true;
457   }
458 }
459 
460 
461 
462 
463 /**
464  * @title CappedCrowdsale
465  * @dev Crowdsale with a limit for total contributions.
466  */
467 contract CappedCrowdsale is Crowdsale {
468   using SafeMath for uint256;
469 
470   uint256 public cap;
471 
472   /**
473    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
474    * @param _cap Max amount of wei to be contributed
475    */
476   function CappedCrowdsale(uint256 _cap) public {
477     require(_cap > 0);
478     cap = _cap;
479   }
480 
481   /**
482    * @dev Checks whether the cap has been reached. 
483    * @return Whether the cap was reached
484    */
485   function capReached() public view returns (bool) {
486     return weiRaised >= cap;
487   }
488 
489   /**
490    * @dev Extend parent behavior requiring purchase to respect the funding cap.
491    * @param _beneficiary Token purchaser
492    * @param _weiAmount Amount of wei contributed
493    */
494   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
495     super._preValidatePurchase(_beneficiary, _weiAmount);
496     require(weiRaised.add(_weiAmount) <= cap);
497   }
498 
499 }
500 
501 
502 /**
503  * @title TimedCrowdsale
504  * @dev Crowdsale accepting contributions only within a time frame.
505  */
506 contract TimedCrowdsale is Crowdsale {
507   using SafeMath for uint256;
508 
509   uint256 public openingTime;
510   uint256 public closingTime;
511 
512   /**
513    * @dev Reverts if not in crowdsale time range. 
514    */
515   modifier onlyWhileOpen {
516     require(now >= openingTime && now <= closingTime);
517     _;
518   }
519 
520   /**
521    * @dev Constructor, takes crowdsale opening and closing times.
522    * @param _openingTime Crowdsale opening time
523    * @param _closingTime Crowdsale closing time
524    */
525   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
526     require(_openingTime >= now);
527     require(_closingTime >= _openingTime);
528 
529     openingTime = _openingTime;
530     closingTime = _closingTime;
531   }
532 
533   /**
534    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
535    * @return Whether crowdsale period has elapsed
536    */
537   function hasClosed() public view returns (bool) {
538     return now > closingTime;
539   }
540   
541   /**
542    * @dev Extend parent behavior requiring to be within contributing period
543    * @param _beneficiary Token purchaser
544    * @param _weiAmount Amount of wei contributed
545    */
546   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
547     super._preValidatePurchase(_beneficiary, _weiAmount);
548   }
549 
550 }
551 
552 
553 
554 /**
555  * @title Pausable
556  * @dev Base contract which allows children to implement an emergency stop mechanism.
557  */
558 contract Pausable is Ownable {
559   event Pause();
560   event Unpause();
561 
562   bool public paused = false;
563 
564 
565   /**
566    * @dev Modifier to make a function callable only when the contract is not paused.
567    */
568   modifier whenNotPaused() {
569     require(!paused);
570     _;
571   }
572 
573   /**
574    * @dev Modifier to make a function callable only when the contract is paused.
575    */
576   modifier whenPaused() {
577     require(paused);
578     _;
579   }
580 
581   /**
582    * @dev called by the owner to pause, triggers stopped state
583    */
584   function pause() onlyOwner whenNotPaused public {
585     paused = true;
586     Pause();
587   }
588 
589   /**
590    * @dev called by the owner to unpause, returns to normal state
591    */
592   function unpause() onlyOwner whenPaused public {
593     paused = false;
594     Unpause();
595   }
596 }
597 
598 
599 
600 
601 
602 
603 
604 
605 
606 
607 
608 //////////////////
609 
610 /**
611  * @title Pibble1stPresale
612  * @dev This is an example of a fully fledged crowdsale.
613  * The way to add new features to a base crowdsale is by multiple inheritance.
614  * In this example we are providing following extensions:
615  * CappedCrowdsale - sets a max boundary for raised funds
616  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
617  *
618  * After adding multiple features it's good practice to run integration tests
619  * to ensure that subcontracts works together as intended.
620  */
621 contract Pibble1stPresale is CappedCrowdsale, TimedCrowdsale, Pausable {
622 
623   uint256 public minValue;
624 
625 /**
626  * rate 200,000 PIB per 1 eth  
627  *  
628  */
629   function Pibble1stPresale(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, uint256 _cap, MintableToken _token, uint256 _minValue) public
630     Crowdsale(_rate, _wallet, _token)
631     CappedCrowdsale(_cap)
632     TimedCrowdsale(_openingTime, _closingTime)
633     {
634         require(_minValue >= 0);
635         minValue =_minValue;
636     }
637 
638 
639   /**
640    * @dev Allows the "TOKEN owner" to transfer control of the contract to a newOwner.
641    * @param newOwner The address to transfer ownership to.
642    */
643   function transferTokenOwnership(address newOwner) public onlyOwner {
644     require(newOwner != address(0));
645     OwnershipTransferred(owner, newOwner);
646     MintableToken(token).transferOwnership(newOwner);
647   }
648 
649 
650   function buyTokens(address _beneficiary) public payable whenNotPaused {
651 
652     require(msg.value >= minValue);
653     super.buyTokens(_beneficiary);
654     
655   }
656 
657   function _forwardFunds() internal whenNotPaused {
658     
659     super._forwardFunds();
660     
661   }
662 
663   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal whenNotPaused {
664 
665 //    do nothing at thistime.
666 //    super._deliverTokens(_beneficiary, _tokenAmount) 
667 
668   }
669 
670   function saleEnded() public view returns (bool) {
671     return (weiRaised >= cap || now > closingTime);
672   }
673  
674   function saleStatus() public view returns (uint, uint) {
675     return (cap, weiRaised);
676   } 
677   
678 }