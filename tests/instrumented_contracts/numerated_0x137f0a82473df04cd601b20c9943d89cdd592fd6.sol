1 pragma solidity ^0.4.18;
2 
3 // File: contracts/Vault.sol
4 
5 interface Vault {
6   function sendFunds() payable public returns (bool);
7   event Transfer(address beneficiary, uint256 amountWei);
8 }
9 
10 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 
52 // File: zeppelin-solidity/contracts/math/SafeMath.sol
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     if (a == 0) {
65       return 0;
66     }
67     uint256 c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   /**
83   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
101 
102 /**
103  * @title ERC20Basic
104  * @dev Simpler version of ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/179
106  */
107 contract ERC20Basic {
108   function totalSupply() public view returns (uint256);
109   function balanceOf(address who) public view returns (uint256);
110   function transfer(address to, uint256 value) public returns (bool);
111   event Transfer(address indexed from, address indexed to, uint256 value);
112 }
113 
114 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125   uint256 totalSupply_;
126 
127   /**
128   * @dev total number of tokens in existence
129   */
130   function totalSupply() public view returns (uint256) {
131     return totalSupply_;
132   }
133 
134   /**
135   * @dev transfer token for a specified address
136   * @param _to The address to transfer to.
137   * @param _value The amount to be transferred.
138   */
139   function transfer(address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[msg.sender]);
142 
143     // SafeMath.sub will throw if there is not enough balance.
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of.
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) public view returns (uint256 balance) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
162 
163 /**
164  * @title ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/20
166  */
167 contract ERC20 is ERC20Basic {
168   function allowance(address owner, address spender) public view returns (uint256);
169   function transferFrom(address from, address to, uint256 value) public returns (bool);
170   function approve(address spender, uint256 value) public returns (bool);
171   event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * @dev https://github.com/ethereum/EIPs/issues/20
181  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract StandardToken is ERC20, BasicToken {
184 
185   mapping (address => mapping (address => uint256)) internal allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(_value <= balances[_from]);
197     require(_value <= allowed[_from][msg.sender]);
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     Transfer(_from, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    *
209    * Beware that changing an allowance with this method brings the risk that someone may use both the old
210    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) public returns (bool) {
217     allowed[msg.sender][_spender] = _value;
218     Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint256 specifying the amount of tokens still available for the spender.
227    */
228   function allowance(address _owner, address _spender) public view returns (uint256) {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    *
235    * approve should be called when allowed[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _addedValue The amount of tokens to increase the allowance by.
241    */
242   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
243     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
244     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248   /**
249    * @dev Decrease the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
259     uint oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue > oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269 }
270 
271 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
272 
273 /**
274  * @title Mintable token
275  * @dev Simple ERC20 Token example, with mintable token creation
276  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
277  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
278  */
279 contract MintableToken is StandardToken, Ownable {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282 
283   bool public mintingFinished = false;
284 
285 
286   modifier canMint() {
287     require(!mintingFinished);
288     _;
289   }
290 
291   /**
292    * @dev Function to mint tokens
293    * @param _to The address that will receive the minted tokens.
294    * @param _amount The amount of tokens to mint.
295    * @return A boolean that indicates if the operation was successful.
296    */
297   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
298     totalSupply_ = totalSupply_.add(_amount);
299     balances[_to] = balances[_to].add(_amount);
300     Mint(_to, _amount);
301     Transfer(address(0), _to, _amount);
302     return true;
303   }
304 
305   /**
306    * @dev Function to stop minting new tokens.
307    * @return True if the operation was successful.
308    */
309   function finishMinting() onlyOwner canMint public returns (bool) {
310     mintingFinished = true;
311     MintFinished();
312     return true;
313   }
314 }
315 
316 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
317 
318 /**
319  * @title Capped token
320  * @dev Mintable token with a token cap.
321  */
322 contract CappedToken is MintableToken {
323 
324   uint256 public cap;
325 
326   function CappedToken(uint256 _cap) public {
327     require(_cap > 0);
328     cap = _cap;
329   }
330 
331   /**
332    * @dev Function to mint tokens
333    * @param _to The address that will receive the minted tokens.
334    * @param _amount The amount of tokens to mint.
335    * @return A boolean that indicates if the operation was successful.
336    */
337   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
338     require(totalSupply_.add(_amount) <= cap);
339 
340     return super.mint(_to, _amount);
341   }
342 
343 }
344 
345 // File: contracts/WebcoinToken.sol
346 
347 contract WebcoinToken is CappedToken {
348 	string constant public name = "Webcoin";
349 	string constant public symbol = "WEB";
350 	uint8 constant public decimals = 18;
351     address private miningWallet;
352 
353 	function WebcoinToken(uint256 _cap, address[] _wallets) public CappedToken(_cap) {
354         require(_wallets[0] != address(0) && _wallets[1] != address(0) && _wallets[2] != address(0) && _wallets[3] != address(0) && _wallets[4] != address(0) && _wallets[5] != address(0) && _wallets[6] != address(0));
355         
356         uint256 mil = (10**6);
357         uint256 teamSupply = mil.mul(5).mul(1 ether);
358         uint256 miningSupply = mil.mul(15).mul(1 ether);
359         uint256 marketingSupply = mil.mul(10).mul(1 ether);
360         uint256 developmentSupply = mil.mul(10).mul(1 ether);
361         uint256 legalSupply = mil.mul(2).mul(1 ether);
362         uint256 functionalCostsSupply = mil.mul(2).mul(1 ether);
363         uint256 earlyAdoptersSupply = mil.mul(1).mul(1 ether);
364         miningWallet = _wallets[1];
365         mint(_wallets[0], teamSupply);
366         mint(_wallets[1], miningSupply);
367         mint(_wallets[2], marketingSupply);
368         mint(_wallets[3], developmentSupply);
369         mint(_wallets[4], legalSupply);
370         mint(_wallets[5], functionalCostsSupply);
371         mint(_wallets[6], earlyAdoptersSupply);
372     }
373 
374     function finishMinting() onlyOwner canMint public returns (bool) {
375         mint(miningWallet, cap.sub(totalSupply()));
376         return super.finishMinting();
377     }
378 }
379 
380 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
381 
382 /**
383  * @title Crowdsale
384  * @dev Crowdsale is a base contract for managing a token crowdsale,
385  * allowing investors to purchase tokens with ether. This contract implements
386  * such functionality in its most fundamental form and can be extended to provide additional
387  * functionality and/or custom behavior.
388  * The external interface represents the basic interface for purchasing tokens, and conform
389  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
390  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
391  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
392  * behavior.
393  */
394 
395 contract Crowdsale {
396   using SafeMath for uint256;
397 
398   // The token being sold
399   ERC20 public token;
400 
401   // Address where funds are collected
402   address public wallet;
403 
404   // How many token units a buyer gets per wei
405   uint256 public rate;
406 
407   // Amount of wei raised
408   uint256 public weiRaised;
409 
410   /**
411    * Event for token purchase logging
412    * @param purchaser who paid for the tokens
413    * @param beneficiary who got the tokens
414    * @param value weis paid for purchase
415    * @param amount amount of tokens purchased
416    */
417   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
418 
419   /**
420    * @param _rate Number of token units a buyer gets per wei
421    * @param _wallet Address where collected funds will be forwarded to
422    * @param _token Address of the token being sold
423    */
424   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
425     require(_rate > 0);
426     require(_wallet != address(0));
427     require(_token != address(0));
428 
429     rate = _rate;
430     wallet = _wallet;
431     token = _token;
432   }
433 
434   // -----------------------------------------
435   // Crowdsale external interface
436   // -----------------------------------------
437 
438   /**
439    * @dev fallback function ***DO NOT OVERRIDE***
440    */
441   function () external payable {
442     buyTokens(msg.sender);
443   }
444 
445   /**
446    * @dev low level token purchase ***DO NOT OVERRIDE***
447    * @param _beneficiary Address performing the token purchase
448    */
449   function buyTokens(address _beneficiary) public payable {
450 
451     uint256 weiAmount = msg.value;
452     _preValidatePurchase(_beneficiary, weiAmount);
453 
454     // calculate token amount to be created
455     uint256 tokens = _getTokenAmount(weiAmount);
456 
457     // update state
458     weiRaised = weiRaised.add(weiAmount);
459 
460     _processPurchase(_beneficiary, tokens);
461     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
462 
463     _updatePurchasingState(_beneficiary, weiAmount);
464 
465     _forwardFunds();
466     _postValidatePurchase(_beneficiary, weiAmount);
467   }
468 
469   // -----------------------------------------
470   // Internal interface (extensible)
471   // -----------------------------------------
472 
473   /**
474    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
475    * @param _beneficiary Address performing the token purchase
476    * @param _weiAmount Value in wei involved in the purchase
477    */
478   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
479     require(_beneficiary != address(0));
480     require(_weiAmount != 0);
481   }
482 
483   /**
484    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
485    * @param _beneficiary Address performing the token purchase
486    * @param _weiAmount Value in wei involved in the purchase
487    */
488   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
489     // optional override
490   }
491 
492   /**
493    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
494    * @param _beneficiary Address performing the token purchase
495    * @param _tokenAmount Number of tokens to be emitted
496    */
497   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
498     token.transfer(_beneficiary, _tokenAmount);
499   }
500 
501   /**
502    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
503    * @param _beneficiary Address receiving the tokens
504    * @param _tokenAmount Number of tokens to be purchased
505    */
506   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
507     _deliverTokens(_beneficiary, _tokenAmount);
508   }
509 
510   /**
511    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
512    * @param _beneficiary Address receiving the tokens
513    * @param _weiAmount Value in wei involved in the purchase
514    */
515   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
516     // optional override
517   }
518 
519   /**
520    * @dev Override to extend the way in which ether is converted to tokens.
521    * @param _weiAmount Value in wei to be converted into tokens
522    * @return Number of tokens that can be purchased with the specified _weiAmount
523    */
524   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
525     return _weiAmount.mul(rate);
526   }
527 
528   /**
529    * @dev Determines how ETH is stored/forwarded on purchases.
530    */
531   function _forwardFunds() internal {
532     wallet.transfer(msg.value);
533   }
534 }
535 
536 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
537 
538 /**
539  * @title TimedCrowdsale
540  * @dev Crowdsale accepting contributions only within a time frame.
541  */
542 contract TimedCrowdsale is Crowdsale {
543   using SafeMath for uint256;
544 
545   uint256 public openingTime;
546   uint256 public closingTime;
547 
548   /**
549    * @dev Reverts if not in crowdsale time range. 
550    */
551   modifier onlyWhileOpen {
552     require(now >= openingTime && now <= closingTime);
553     _;
554   }
555 
556   /**
557    * @dev Constructor, takes crowdsale opening and closing times.
558    * @param _openingTime Crowdsale opening time
559    * @param _closingTime Crowdsale closing time
560    */
561   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
562     require(_openingTime >= now);
563     require(_closingTime >= _openingTime);
564 
565     openingTime = _openingTime;
566     closingTime = _closingTime;
567   }
568 
569   /**
570    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
571    * @return Whether crowdsale period has elapsed
572    */
573   function hasClosed() public view returns (bool) {
574     return now > closingTime;
575   }
576   
577   /**
578    * @dev Extend parent behavior requiring to be within contributing period
579    * @param _beneficiary Token purchaser
580    * @param _weiAmount Amount of wei contributed
581    */
582   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
583     super._preValidatePurchase(_beneficiary, _weiAmount);
584   }
585 
586 }
587 
588 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
589 
590 /**
591  * @title FinalizableCrowdsale
592  * @dev Extension of Crowdsale where an owner can do extra work
593  * after finishing.
594  */
595 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
596   using SafeMath for uint256;
597 
598   bool public isFinalized = false;
599 
600   event Finalized();
601 
602   /**
603    * @dev Must be called after crowdsale ends, to do some extra finalization
604    * work. Calls the contract's finalization function.
605    */
606   function finalize() onlyOwner public {
607     require(!isFinalized);
608     require(hasClosed());
609 
610     finalization();
611     Finalized();
612 
613     isFinalized = true;
614   }
615 
616   /**
617    * @dev Can be overridden to add finalization logic. The overriding function
618    * should call super.finalization() to ensure the chain of finalization is
619    * executed entirely.
620    */
621   function finalization() internal {
622   }
623 }
624 
625 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
626 
627 /**
628  * @title CappedCrowdsale
629  * @dev Crowdsale with a limit for total contributions.
630  */
631 contract CappedCrowdsale is Crowdsale {
632   using SafeMath for uint256;
633 
634   uint256 public cap;
635 
636   /**
637    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
638    * @param _cap Max amount of wei to be contributed
639    */
640   function CappedCrowdsale(uint256 _cap) public {
641     require(_cap > 0);
642     cap = _cap;
643   }
644 
645   /**
646    * @dev Checks whether the cap has been reached. 
647    * @return Whether the cap was reached
648    */
649   function capReached() public view returns (bool) {
650     return weiRaised >= cap;
651   }
652 
653   /**
654    * @dev Extend parent behavior requiring purchase to respect the funding cap.
655    * @param _beneficiary Token purchaser
656    * @param _weiAmount Amount of wei contributed
657    */
658   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
659     super._preValidatePurchase(_beneficiary, _weiAmount);
660     require(weiRaised.add(_weiAmount) <= cap);
661   }
662 
663 }
664 
665 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
666 
667 /**
668  * @title Pausable
669  * @dev Base contract which allows children to implement an emergency stop mechanism.
670  */
671 contract Pausable is Ownable {
672   event Pause();
673   event Unpause();
674 
675   bool public paused = false;
676 
677 
678   /**
679    * @dev Modifier to make a function callable only when the contract is not paused.
680    */
681   modifier whenNotPaused() {
682     require(!paused);
683     _;
684   }
685 
686   /**
687    * @dev Modifier to make a function callable only when the contract is paused.
688    */
689   modifier whenPaused() {
690     require(paused);
691     _;
692   }
693 
694   /**
695    * @dev called by the owner to pause, triggers stopped state
696    */
697   function pause() onlyOwner whenNotPaused public {
698     paused = true;
699     Pause();
700   }
701 
702   /**
703    * @dev called by the owner to unpause, returns to normal state
704    */
705   function unpause() onlyOwner whenPaused public {
706     paused = false;
707     Unpause();
708   }
709 }
710 
711 // File: contracts/WebcoinCrowdsale.sol
712 
713 /**
714  * @title SampleCrowdsale
715  * CappedCrowdsale - sets a max boundary for raised funds
716  *
717  * After adding multiple features it's good practice to run integration tests
718  * to ensure that subcontracts works together as intended.
719  */
720 contract WebcoinCrowdsale is CappedCrowdsale, TimedCrowdsale, FinalizableCrowdsale, Pausable {
721   Vault public vaultWallet;
722   WebcoinToken token;
723   address[] wallets;
724   uint256[] rates;
725   uint256 public softCap;
726   uint256 public initialSupply = 0;
727   
728   function WebcoinCrowdsale(uint256 _openingTime, uint256 _closingTime, uint256[] _rates, uint256 _softCap, uint256 _cap, address _vaultAddress, address[] _wallets, ERC20 _token) public
729     CappedCrowdsale(_cap)
730     TimedCrowdsale(_openingTime, _closingTime)
731     FinalizableCrowdsale()
732     Crowdsale(_rates[0], _wallets[0], _token) 
733     {
734         require(_softCap > 0);
735         require(_wallets[1] != address(0) && _wallets[2] != address(0) && _wallets[3] != address(0) && _vaultAddress != address(0));
736         require(_rates[1] > 0 && _rates[2] > 0 && _rates[3] > 0 && _rates[4] > 0 && _rates[5] > 0 && _rates[6] > 0 && _rates[7] > 0);
737         wallets = _wallets;
738         vaultWallet = Vault(_vaultAddress);
739         rates = _rates;
740         token = WebcoinToken(_token);
741         softCap = _softCap;
742         initialSupply = token.totalSupply();
743     }
744   
745   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
746     require(_weiAmount <= 1000 ether);
747     super._preValidatePurchase(_beneficiary, _weiAmount);
748   }
749   
750   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
751     token.mint(_beneficiary, _tokenAmount);
752   }
753   
754   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
755     uint256 crowdsaleSupply = token.totalSupply().sub(initialSupply);
756     uint256 mil = (10**6) * 1 ether;
757     if (crowdsaleSupply >= mil.mul(2) && crowdsaleSupply < mil.mul(5)) {
758       rate = rates[1];
759     } else if (crowdsaleSupply >= mil.mul(5) && crowdsaleSupply < mil.mul(11)) {
760       rate = rates[2];
761     } else if (crowdsaleSupply >= mil.mul(11) && crowdsaleSupply < mil.mul(16)) {
762       rate = rates[3];
763     } else if (crowdsaleSupply >= mil.mul(16) && crowdsaleSupply < mil.mul(20)) {
764       rate = rates[4];
765     } else if (crowdsaleSupply >= mil.mul(20) && crowdsaleSupply < mil.mul(22)) {
766       rate = rates[5];
767     } else if (crowdsaleSupply >= mil.mul(22) && crowdsaleSupply < mil.mul(24)) {
768       rate = rates[6];
769     } else if (crowdsaleSupply >= mil.mul(24)) {
770       rate = rates[7];
771     }
772   }
773   
774   function ceil(uint256 a, uint256 m) private pure returns (uint256) {
775     return ((a + m - 1) / m) * m;
776   }
777   
778   function _forwardFunds() internal {
779     if (softCapReached()) {
780         uint256 totalInvestment = msg.value;
781         uint256 miningFund = totalInvestment.mul(10).div(100);
782         uint256 teamFund = totalInvestment.mul(15).div(100);
783         uint256 devFund = totalInvestment.mul(35).div(100);
784         uint256 marketingFund = totalInvestment.mul(40).div(100);
785         require(wallets[0].send(miningFund) && wallets[1].send(teamFund) && wallets[2].send(devFund) && wallets[3].send(marketingFund));
786     } else {
787         require(vaultWallet.sendFunds.value(msg.value)());
788     }
789   }
790   
791   function softCapReached() public view returns (bool) {
792     return weiRaised > softCap;
793   }
794   
795   function capReached() public view returns (bool) {
796     return ceil(token.totalSupply(),1 ether).sub(initialSupply) >= cap;
797   }
798   
799   function hasClosed() public view returns (bool) {
800     return capReached() || super.hasClosed(); 
801   }
802   
803   function pause() onlyOwner whenNotPaused public {
804     token.transferOwnership(owner);
805     super.pause();
806   }
807   
808   function finalization() internal {
809     token.finishMinting();
810     token.transferOwnership(owner);  
811   }
812 }