1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract ERC20Basic {
47   function totalSupply() public view returns (uint256);
48   function balanceOf(address who) public view returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57 
58   uint256 totalSupply_;
59 
60   /**
61   * @dev total number of tokens in existence
62   */
63   function totalSupply() public view returns (uint256) {
64     return totalSupply_;
65   }
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75 
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of.
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public view returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * @dev Increase the amount of tokens that an owner allowed to a spender.
153    *
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    * @param _spender The address which will spend the funds.
159    * @param _addedValue The amount of tokens to increase the allowance by.
160    */
161   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   /**
168    * @dev Decrease the amount of tokens that an owner allowed to a spender.
169    *
170    * approve should be called when allowed[_spender] == 0. To decrement
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    * @param _spender The address which will spend the funds.
175    * @param _subtractedValue The amount of tokens to decrease the allowance by.
176    */
177   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 // NOT USING - using multiownable instead
191 // contract Ownable {
192 //   address public owner;
193 
194 
195 //   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197 
198 //   /**
199 //    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200 //    * account.
201 //    */
202 //   function Ownable() public {
203 //     owner = msg.sender;
204 //   }
205 
206 //   /**
207 //    * @dev Throws if called by any account other than the owner.
208 //    */
209 //   modifier onlyOwner() {
210 //     require(msg.sender == owner);
211 //     _;
212 //   }
213 
214 //   /**
215 //    * @dev Allows the current owner to transfer control of the contract to a newOwner.
216 //    * @param newOwner The address to transfer ownership to.
217 //    */
218 //   function transferOwnership(address newOwner) public onlyOwner {
219 //     require(newOwner != address(0));
220 //     OwnershipTransferred(owner, newOwner);
221 //     owner = newOwner;
222 //   }
223 // }
224 
225 contract MultiOwnable {
226 
227     mapping (address => bool) public isOwner;
228     address[] public ownerHistory;
229 
230     event OwnerAddedEvent(address indexed _newOwner);
231     event OwnerRemovedEvent(address indexed _oldOwner);
232 
233     function MultiOwnable() public {
234         // Add default owner
235         address owner = msg.sender;
236         ownerHistory.push(owner);
237         isOwner[owner] = true;
238     }
239 
240     modifier onlyOwner() {
241         require(isOwner[msg.sender]);
242         _;
243     }
244     
245     function ownerHistoryCount() public view returns (uint) {
246         return ownerHistory.length;
247     }
248 
249     /** Add extra owner. */
250     function addOwner(address owner) onlyOwner public {
251         require(owner != address(0));
252         require(!isOwner[owner]);
253         ownerHistory.push(owner);
254         isOwner[owner] = true;
255         OwnerAddedEvent(owner);
256     }
257 
258     /** Remove extra owner. */
259     function removeOwner(address owner) onlyOwner public {
260         require(isOwner[owner]);
261         isOwner[owner] = false;
262         OwnerRemovedEvent(owner);
263     }
264 }
265 
266 /**
267  * @title Pausable
268  * @dev Base contract which allows children to implement an emergency stop mechanism.
269  */
270 contract Pausable is MultiOwnable {
271   event Pause();
272   event Unpause();
273 
274   bool public paused = false;
275 
276 
277   /**
278    * @dev Modifier to make a function callable only when the contract is not paused.
279    */
280   modifier whenNotPaused() {
281     require(!paused);
282     _;
283   }
284 
285   /**
286    * @dev Modifier to make a function callable only when the contract is paused.
287    */
288   modifier whenPaused() {
289     require(paused);
290     _;
291   }
292 
293   /**
294    * @dev called by the owner to pause, triggers stopped state
295    */
296   function pause() onlyOwner whenNotPaused public {
297     paused = true;
298     Pause();
299   }
300 
301   /**
302    * @dev called by the owner to unpause, returns to normal state
303    */
304   function unpause() onlyOwner whenPaused public {
305     paused = false;
306     Unpause();
307   }
308 }
309 
310 contract PausableToken is StandardToken, Pausable {
311 
312   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
313     return super.transfer(_to, _value);
314   }
315 
316   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
317     return super.transferFrom(_from, _to, _value);
318   }
319 
320   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
321     return super.approve(_spender, _value);
322   }
323 
324   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
325     return super.increaseApproval(_spender, _addedValue);
326   }
327 
328   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
329     return super.decreaseApproval(_spender, _subtractedValue);
330   }
331 }
332 
333 
334 /**
335  * @title Mintable token
336  * @dev Simple ERC20 Token example, with mintable token creation
337  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
338  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
339  */
340 contract MintableToken is StandardToken, MultiOwnable {
341   event Mint(address indexed to, uint256 amount);
342   event MintFinished();
343 
344   bool public mintingFinished = false;
345 
346 
347   modifier canMint() {
348     require(!mintingFinished);
349     _;
350   }
351 
352   /**
353    * @dev Function to mint tokens
354    * @param _to The address that will receive the minted tokens.
355    * @param _amount The amount of tokens to mint.
356    * @return A boolean that indicates if the operation was successful.
357    */
358   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
359     totalSupply_ = totalSupply_.add(_amount);
360     balances[_to] = balances[_to].add(_amount);
361     Mint(_to, _amount);
362     Transfer(address(0), _to, _amount);
363     return true;
364   }
365 
366   /**
367    * @dev Function to stop minting new tokens.
368    * @return True if the operation was successful.
369    */
370   function finishMinting() onlyOwner canMint public returns (bool) {
371     mintingFinished = true;
372     MintFinished();
373     return true;
374   }
375 }
376 
377 contract Crowdsale {
378   using SafeMath for uint256;
379 
380   // The token being sold
381   ERC20 public token;
382 
383   // Address where funds are collected
384   address public wallet;
385 
386   // How many token units a buyer gets per wei
387   uint256 public rate;
388 
389   // Amount of wei raised
390   uint256 public weiRaised;
391 
392   /**
393    * Event for token purchase logging
394    * @param purchaser who paid for the tokens
395    * @param beneficiary who got the tokens
396    * @param value weis paid for purchase
397    * @param amount amount of tokens purchased
398    */
399   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
400 
401   /**
402    * @param _rate Number of token units a buyer gets per wei
403    * @param _wallet Address where collected funds will be forwarded to
404    * @param _token Address of the token being sold
405    */
406   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
407     require(_rate > 0);
408     require(_wallet != address(0));
409     require(_token != address(0));
410 
411     rate = _rate;
412     wallet = _wallet;
413     token = _token;
414   }
415 
416   // -----------------------------------------
417   // Crowdsale external interface
418   // -----------------------------------------
419 
420   /**
421    * @dev fallback function ***DO NOT OVERRIDE***
422    */
423   function () external payable {
424     buyTokens(msg.sender);
425   }
426 
427   /**
428    * @dev low level token purchase ***DO NOT OVERRIDE***
429    * @param _beneficiary Address performing the token purchase
430    */
431   function buyTokens(address _beneficiary) public payable {
432 
433     uint256 weiAmount = msg.value;
434     _preValidatePurchase(_beneficiary, weiAmount);
435 
436     // calculate token amount to be created
437     uint256 tokens = _getTokenAmount(weiAmount);
438 
439     // update state
440     weiRaised = weiRaised.add(weiAmount);
441 
442     _processPurchase(_beneficiary, tokens);
443     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
444 
445     _updatePurchasingState(_beneficiary, weiAmount);
446 
447     _forwardFunds();
448     _postValidatePurchase(_beneficiary, weiAmount);
449   }
450 
451   // -----------------------------------------
452   // Internal interface (extensible)
453   // -----------------------------------------
454 
455   /**
456    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
457    * @param _beneficiary Address performing the token purchase
458    * @param _weiAmount Value in wei involved in the purchase
459    */
460   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
461     require(_beneficiary != address(0));
462     require(_weiAmount != 0);
463   }
464 
465   /**
466    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
467    * @param _beneficiary Address performing the token purchase
468    * @param _weiAmount Value in wei involved in the purchase
469    */
470   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
471     // optional override
472   }
473 
474   /**
475    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
476    * @param _beneficiary Address performing the token purchase
477    * @param _tokenAmount Number of tokens to be emitted
478    */
479   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
480     token.transfer(_beneficiary, _tokenAmount);
481   }
482 
483   /**
484    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
485    * @param _beneficiary Address receiving the tokens
486    * @param _tokenAmount Number of tokens to be purchased
487    */
488   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
489     _deliverTokens(_beneficiary, _tokenAmount);
490   }
491 
492   /**
493    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
494    * @param _beneficiary Address receiving the tokens
495    * @param _weiAmount Value in wei involved in the purchase
496    */
497   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
498     // optional override
499   }
500 
501   /**
502    * @dev Override to extend the way in which ether is converted to tokens.
503    * @param _weiAmount Value in wei to be converted into tokens
504    * @return Number of tokens that can be purchased with the specified _weiAmount
505    */
506   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
507     return _weiAmount.mul(rate);
508   }
509 
510   /**
511    * @dev Determines how ETH is stored/forwarded on purchases.
512    */
513   function _forwardFunds() internal {
514     wallet.transfer(msg.value);
515   }
516 }
517 
518 contract TimedCrowdsale is Crowdsale {
519   using SafeMath for uint256;
520 
521   uint256 public openingTime;
522   uint256 public closingTime;
523 
524   /**
525    * @dev Reverts if not in crowdsale time range. 
526    */
527   modifier onlyWhileOpen {
528     require(now >= openingTime && now <= closingTime);
529     _;
530   }
531 
532   /**
533    * @dev Constructor, takes crowdsale opening and closing times.
534    * @param _openingTime Crowdsale opening time
535    * @param _closingTime Crowdsale closing time
536    */
537   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
538     // require(_openingTime >= now); // 
539     require(_closingTime >= _openingTime);
540 
541     openingTime = _openingTime;
542     closingTime = _closingTime;
543   }
544 
545   /**
546    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
547    * @return Whether crowdsale period has elapsed
548    */
549   function hasClosed() public view returns (bool) {
550     return now > closingTime;
551   }
552   
553   /**
554    * @dev Extend parent behavior requiring to be within contributing period
555    * @param _beneficiary Token purchaser
556    * @param _weiAmount Amount of wei contributed
557    */
558   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
559     super._preValidatePurchase(_beneficiary, _weiAmount);
560   }
561 
562 }
563 
564 contract FinalizableCrowdsale is TimedCrowdsale, MultiOwnable {
565   using SafeMath for uint256;
566 
567   bool public isFinalized = false;
568 
569   event Finalized();
570 
571   /**
572    * @dev Must be called after crowdsale ends, to do some extra finalization
573    * work. Calls the contract's finalization function.
574    */
575   function finalize() onlyOwner public {
576     require(!isFinalized);
577     require(hasClosed());
578 
579     finalization();
580     Finalized();
581 
582     isFinalized = true;
583   }
584 
585   /**
586    * @dev Can be overridden to add finalization logic. The overriding function
587    * should call super.finalization() to ensure the chain of finalization is
588    * executed entirely.
589    */
590   function finalization() internal {
591   }
592 }
593 
594 
595 
596 contract MintedCrowdsale is Crowdsale {
597 
598   /**
599   * @dev Overrides delivery by minting tokens upon purchase.
600   * @param _beneficiary Token purchaser
601   * @param _tokenAmount Number of tokens to be minted
602   */
603   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
604     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
605   }
606 }
607 
608 contract CappedCrowdsale is Crowdsale {
609   using SafeMath for uint256;
610 
611   uint256 public cap;
612 
613   /**
614    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
615    * @param _cap Max amount of wei to be contributed
616    */
617   function CappedCrowdsale(uint256 _cap) public {
618     require(_cap > 0);
619     cap = _cap;
620   }
621 
622   /**
623    * @dev Checks whether the cap has been reached. 
624    * @return Whether the cap was reached
625    */
626   function capReached() public view returns (bool) {
627     return weiRaised >= cap;
628   }
629 
630   /**
631    * @dev Extend parent behavior requiring purchase to respect the funding cap.
632    * @param _beneficiary Token purchaser
633    * @param _weiAmount Amount of wei contributed
634    */
635   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
636     super._preValidatePurchase(_beneficiary, _weiAmount);
637     require(weiRaised.add(_weiAmount) <= cap);
638   }
639 
640 }
641 
642 /**
643  * @title SampleCrowdsaleToken
644  * @dev Very simple ERC20 Token that can be minted.
645  * It is meant to be used in a crowdsale contract.
646  */
647 contract MailhustleToken is MintableToken, PausableToken {
648 
649   string public constant name = "Mailhustle Token"; // solium-disable-line uppercase
650   string public constant symbol = "MAIL"; // solium-disable-line uppercase
651   uint8 public constant decimals = 18; // solium-disable-line uppercase
652 
653 }
654 
655 /**
656  * @title SampleCrowdsale
657  * @dev This is an example of a fully fledged crowdsale.
658  * The way to add new features to a base crowdsale is by multiple inheritance.
659  * In this example we are providing following extensions:
660  * CappedCrowdsale - sets a max boundary for raised funds
661  *
662  * After adding multiple features it's good practice to run integration tests
663  * to ensure that subcontracts works together as intended.
664  */
665 contract MailhustleCrowdsale is CappedCrowdsale, MintedCrowdsale, TimedCrowdsale {
666   using SafeMath for uint256;
667     
668   uint256 _openingTime = 1520276997;
669   uint256 _closingTime = 1546214400; // + new Date(2018,11,31) // and remove three zeros because of JavaScript milliseconds
670   uint256 _rate = 1000;
671   address _wallet = 0xDB2f9f086561D378D8d701feDd5569B515F9e7f7; // Gnosis multisig: https://etherscan.io/address/0xdb2f9f086561d378d8d701fedd5569b515f9e7f7#code
672   uint256 _cap = 1000 ether;
673   MintableToken _token = MailhustleToken(0xD006d2f23CDC9949727D482Ec707A1C9d1d4abDb);
674 
675   function MailhustleCrowdsale() public
676     Crowdsale(_rate, _wallet, _token)
677     CappedCrowdsale(_cap)
678     TimedCrowdsale(_openingTime, _closingTime)
679   {
680       
681   }
682 
683   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
684 
685     // Floating point operations are too expensive: https://ethereum.stackexchange.com/questions/8674/how-can-i-perform-float-type-division-in-solidity
686     // So instead rather than doing x3.5 we need to x14 and then /4 (YES, multiply by 14 and then divide by 4)
687 
688     uint16 multiply;
689     uint16 divide = 4;
690 
691     if (weiRaised < 100 ether) {
692       multiply = 16;
693     } else if (weiRaised < 150 ether) {
694       multiply = 15;
695     } else if (weiRaised < 200 ether) {
696       multiply = 14;
697     } else if (weiRaised < 250 ether) {
698       multiply = 13;    
699     } else if (weiRaised < 300 ether) {
700       multiply = 12;
701     } else if (weiRaised < 350 ether) {
702       multiply = 11;
703     } else if (weiRaised < 400 ether) {
704       multiply = 10;
705     } else if (weiRaised < 450 ether) {
706       multiply = 9;    
707     } else {
708       multiply = 8;
709     } 
710 
711     return _weiAmount.mul(rate).mul(multiply).div(divide);
712   }
713 
714   // Please note the allocation
715   // Omega: £5k
716   // Wiktor: £2k
717   // (highly respecting my investors in the previous project, "carry on" their involvement here)
718 
719 }