1 pragma solidity ^0.4.22;
2 
3 // File: contracts/ERC223/ERC223_receiving_contract.sol
4 
5 /**
6 * @title Contract that will work with ERC223 tokens.
7 */
8 
9 contract ERC223ReceivingContract {
10     /**
11      * @dev Standard ERC223 function that will handle incoming token transfers.
12      *
13      * @param _from  Token sender address.
14      * @param _value Amount of tokens.
15      * @param _data  Transaction metadata.
16      */
17     function tokenFallback(address _from, uint _value, bytes _data) public;
18 }
19 
20 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     emit OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 
60 }
61 
62 // File: zeppelin-solidity/contracts/math/SafeMath.sol
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
125 
126 /**
127  * @title Basic token
128  * @dev Basic version of StandardToken, with no allowances.
129  */
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   uint256 totalSupply_;
136 
137   /**
138   * @dev total number of tokens in existence
139   */
140   function totalSupply() public view returns (uint256) {
141     return totalSupply_;
142   }
143 
144   /**
145   * @dev transfer token for a specified address
146   * @param _to The address to transfer to.
147   * @param _value The amount to be transferred.
148   */
149   function transfer(address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[msg.sender]);
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     emit Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     emit Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
269     uint oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280 
281 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
282 
283 /**
284  * @title Mintable token
285  * @dev Simple ERC20 Token example, with mintable token creation
286  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
287  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
288  */
289 contract MintableToken is StandardToken, Ownable {
290   event Mint(address indexed to, uint256 amount);
291   event MintFinished();
292 
293   bool public mintingFinished = false;
294 
295 
296   modifier canMint() {
297     require(!mintingFinished);
298     _;
299   }
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    */
307   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
308     totalSupply_ = totalSupply_.add(_amount);
309     balances[_to] = balances[_to].add(_amount);
310     emit Mint(_to, _amount);
311     emit Transfer(address(0), _to, _amount);
312     return true;
313   }
314 
315   /**
316    * @dev Function to stop minting new tokens.
317    * @return True if the operation was successful.
318    */
319   function finishMinting() onlyOwner canMint public returns (bool) {
320     mintingFinished = true;
321     emit MintFinished();
322     return true;
323   }
324 }
325 
326 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
327 
328 /**
329  * @title Capped token
330  * @dev Mintable token with a token cap.
331  */
332 contract CappedToken is MintableToken {
333 
334   uint256 public cap;
335 
336   constructor(uint256 _cap) public {
337     require(_cap > 0);
338     cap = _cap;
339   }
340 
341   /**
342    * @dev Function to mint tokens
343    * @param _to The address that will receive the minted tokens.
344    * @param _amount The amount of tokens to mint.
345    * @return A boolean that indicates if the operation was successful.
346    */
347   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348     require(totalSupply_.add(_amount) <= cap);
349 
350     return super.mint(_to, _amount);
351   }
352 
353 }
354 
355 // File: contracts/SafeGuardsToken.sol
356 
357 contract SafeGuardsToken is CappedToken {
358 
359     string constant public name = "SafeGuards Coin";
360     string constant public symbol = "SGCT";
361     uint constant public decimals = 18;
362 
363     // address who can burn tokens
364     address public canBurnAddress;
365 
366     // list with frozen addresses
367     mapping (address => bool) public frozenList;
368 
369     // timestamp until investors in frozen list can't transfer tokens
370     uint256 public frozenPauseTime = now + 180 days;
371 
372     // timestamp until investors can't burn tokens
373     uint256 public burnPausedTime = now + 180 days;
374 
375 
376     constructor(address _canBurnAddress) CappedToken(61 * 1e6 * 1e18) public {
377         require(_canBurnAddress != 0x0);
378         canBurnAddress = _canBurnAddress;
379     }
380 
381 
382     // ===--- Presale frozen functionality ---===
383 
384     event ChangeFrozenPause(uint256 newFrozenPauseTime);
385 
386     /**
387      * @dev Function to mint frozen tokens
388      * @param _to The address that will receive the minted tokens.
389      * @param _amount The amount of tokens to mint.
390      * @return A boolean that indicates if the operation was successful.
391      */
392     function mintFrozen(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
393         frozenList[_to] = true;
394         return super.mint(_to, _amount);
395     }
396 
397     function changeFrozenTime(uint256 _newFrozenPauseTime) onlyOwner public returns (bool) {
398         require(_newFrozenPauseTime > now);
399 
400         frozenPauseTime = _newFrozenPauseTime;
401         emit ChangeFrozenPause(_newFrozenPauseTime);
402         return true;
403     }
404 
405 
406     // ===--- Override transfers with implementation of the ERC223 standard and frozen logic ---===
407 
408     event Transfer(address indexed from, address indexed to, uint value, bytes data);
409 
410     /**
411     * @dev transfer token for a specified address
412     * @param _to The address to transfer to.
413     * @param _value The amount to be transferred.
414     */
415     function transfer(address _to, uint _value) public returns (bool) {
416         bytes memory empty;
417         return transfer(_to, _value, empty);
418     }
419 
420     /**
421     * @dev transfer token for a specified address
422     * @param _to The address to transfer to.
423     * @param _value The amount to be transferred.
424     * @param _data Optional metadata.
425     */
426     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
427         require(now > frozenPauseTime || !frozenList[msg.sender]);
428 
429         super.transfer(_to, _value);
430 
431         if (isContract(_to)) {
432             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
433             receiver.tokenFallback(msg.sender, _value, _data);
434             emit Transfer(msg.sender, _to, _value, _data);
435         }
436 
437         return true;
438     }
439 
440     /**
441      * @dev Transfer tokens from one address to another
442      * @param _from address The address which you want to send tokens from
443      * @param _to address The address which you want to transfer to
444      * @param _value uint the amount of tokens to be transferred
445      */
446     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
447         bytes memory empty;
448         return transferFrom(_from, _to, _value, empty);
449     }
450 
451     /**
452      * @dev Transfer tokens from one address to another
453      * @param _from address The address which you want to send tokens from
454      * @param _to address The address which you want to transfer to
455      * @param _value uint the amount of tokens to be transferred
456      * @param _data Optional metadata.
457      */
458     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {
459         require(now > frozenPauseTime || !frozenList[msg.sender]);
460 
461         super.transferFrom(_from, _to, _value);
462 
463         if (isContract(_to)) {
464             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
465             receiver.tokenFallback(_from, _value, _data);
466         }
467 
468         emit Transfer(_from, _to, _value, _data);
469         return true;
470     }
471 
472     function isContract(address _addr) private view returns (bool) {
473         uint length;
474         assembly {
475         //retrieve the size of the code on target address, this needs assembly
476             length := extcodesize(_addr)
477         }
478         return (length>0);
479     }
480 
481 
482     // ===--- Burnable functionality ---===
483 
484     event Burn(address indexed burner, uint256 value);
485     event ChangeBurnPause(uint256 newBurnPauseTime);
486 
487     /**
488      * @dev Burns a specific amount of tokens.
489      * @param _value The amount of token to be burned.
490      */
491     function burn(uint256 _value) public {
492         require(burnPausedTime < now || msg.sender == canBurnAddress);
493 
494         require(_value <= balances[msg.sender]);
495 
496         address burner = msg.sender;
497         balances[burner] = balances[burner].sub(_value);
498         totalSupply_ = totalSupply_.sub(_value);
499         emit Burn(burner, _value);
500         emit Transfer(burner, address(0), _value);
501     }
502 
503     function changeBurnPausedTime(uint256 _newBurnPauseTime) onlyOwner public returns (bool) {
504         require(_newBurnPauseTime > burnPausedTime);
505 
506         burnPausedTime = _newBurnPauseTime;
507         emit ChangeBurnPause(_newBurnPauseTime);
508         return true;
509     }
510 }
511 
512 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
513 
514 /**
515  * @title Crowdsale
516  * @dev Crowdsale is a base contract for managing a token crowdsale,
517  * allowing investors to purchase tokens with ether. This contract implements
518  * such functionality in its most fundamental form and can be extended to provide additional
519  * functionality and/or custom behavior.
520  * The external interface represents the basic interface for purchasing tokens, and conform
521  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
522  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
523  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
524  * behavior.
525  */
526 
527 contract Crowdsale {
528   using SafeMath for uint256;
529 
530   // The token being sold
531   ERC20 public token;
532 
533   // Address where funds are collected
534   address public wallet;
535 
536   // How many token units a buyer gets per wei
537   uint256 public rate;
538 
539   // Amount of wei raised
540   uint256 public weiRaised;
541 
542   /**
543    * Event for token purchase logging
544    * @param purchaser who paid for the tokens
545    * @param beneficiary who got the tokens
546    * @param value weis paid for purchase
547    * @param amount amount of tokens purchased
548    */
549   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
550 
551   /**
552    * @param _rate Number of token units a buyer gets per wei
553    * @param _wallet Address where collected funds will be forwarded to
554    * @param _token Address of the token being sold
555    */
556   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
557     require(_rate > 0);
558     require(_wallet != address(0));
559     require(_token != address(0));
560 
561     rate = _rate;
562     wallet = _wallet;
563     token = _token;
564   }
565 
566   // -----------------------------------------
567   // Crowdsale external interface
568   // -----------------------------------------
569 
570   /**
571    * @dev fallback function ***DO NOT OVERRIDE***
572    */
573   function () external payable {
574     buyTokens(msg.sender);
575   }
576 
577   /**
578    * @dev low level token purchase ***DO NOT OVERRIDE***
579    * @param _beneficiary Address performing the token purchase
580    */
581   function buyTokens(address _beneficiary) public payable {
582 
583     uint256 weiAmount = msg.value;
584     _preValidatePurchase(_beneficiary, weiAmount);
585 
586     // calculate token amount to be created
587     uint256 tokens = _getTokenAmount(weiAmount);
588 
589     // update state
590     weiRaised = weiRaised.add(weiAmount);
591 
592     _processPurchase(_beneficiary, tokens);
593     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
594 
595     _updatePurchasingState(_beneficiary, weiAmount);
596 
597     _forwardFunds();
598     _postValidatePurchase(_beneficiary, weiAmount);
599   }
600 
601   // -----------------------------------------
602   // Internal interface (extensible)
603   // -----------------------------------------
604 
605   /**
606    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
607    * @param _beneficiary Address performing the token purchase
608    * @param _weiAmount Value in wei involved in the purchase
609    */
610   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
611     require(_beneficiary != address(0));
612     require(_weiAmount != 0);
613   }
614 
615   /**
616    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
617    * @param _beneficiary Address performing the token purchase
618    * @param _weiAmount Value in wei involved in the purchase
619    */
620   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
621     // optional override
622   }
623 
624   /**
625    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
626    * @param _beneficiary Address performing the token purchase
627    * @param _tokenAmount Number of tokens to be emitted
628    */
629   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
630     token.transfer(_beneficiary, _tokenAmount);
631   }
632 
633   /**
634    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
635    * @param _beneficiary Address receiving the tokens
636    * @param _tokenAmount Number of tokens to be purchased
637    */
638   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
639     _deliverTokens(_beneficiary, _tokenAmount);
640   }
641 
642   /**
643    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
644    * @param _beneficiary Address receiving the tokens
645    * @param _weiAmount Value in wei involved in the purchase
646    */
647   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
648     // optional override
649   }
650 
651   /**
652    * @dev Override to extend the way in which ether is converted to tokens.
653    * @param _weiAmount Value in wei to be converted into tokens
654    * @return Number of tokens that can be purchased with the specified _weiAmount
655    */
656   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
657     return _weiAmount.mul(rate);
658   }
659 
660   /**
661    * @dev Determines how ETH is stored/forwarded on purchases.
662    */
663   function _forwardFunds() internal {
664     wallet.transfer(msg.value);
665   }
666 }
667 
668 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
669 
670 /**
671  * @title TimedCrowdsale
672  * @dev Crowdsale accepting contributions only within a time frame.
673  */
674 contract TimedCrowdsale is Crowdsale {
675   using SafeMath for uint256;
676 
677   uint256 public openingTime;
678   uint256 public closingTime;
679 
680   /**
681    * @dev Reverts if not in crowdsale time range. 
682    */
683   modifier onlyWhileOpen {
684     require(now >= openingTime && now <= closingTime);
685     _;
686   }
687 
688   /**
689    * @dev Constructor, takes crowdsale opening and closing times.
690    * @param _openingTime Crowdsale opening time
691    * @param _closingTime Crowdsale closing time
692    */
693   constructor(uint256 _openingTime, uint256 _closingTime) public {
694     require(_openingTime >= now);
695     require(_closingTime >= _openingTime);
696 
697     openingTime = _openingTime;
698     closingTime = _closingTime;
699   }
700 
701   /**
702    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
703    * @return Whether crowdsale period has elapsed
704    */
705   function hasClosed() public view returns (bool) {
706     return now > closingTime;
707   }
708   
709   /**
710    * @dev Extend parent behavior requiring to be within contributing period
711    * @param _beneficiary Token purchaser
712    * @param _weiAmount Amount of wei contributed
713    */
714   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
715     super._preValidatePurchase(_beneficiary, _weiAmount);
716   }
717 
718 }
719 
720 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
721 
722 /**
723  * @title FinalizableCrowdsale
724  * @dev Extension of Crowdsale where an owner can do extra work
725  * after finishing.
726  */
727 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
728   using SafeMath for uint256;
729 
730   bool public isFinalized = false;
731 
732   event Finalized();
733 
734   /**
735    * @dev Must be called after crowdsale ends, to do some extra finalization
736    * work. Calls the contract's finalization function.
737    */
738   function finalize() onlyOwner public {
739     require(!isFinalized);
740     require(hasClosed());
741 
742     finalization();
743     emit Finalized();
744 
745     isFinalized = true;
746   }
747 
748   /**
749    * @dev Can be overridden to add finalization logic. The overriding function
750    * should call super.finalization() to ensure the chain of finalization is
751    * executed entirely.
752    */
753   function finalization() internal {
754   }
755 }
756 
757 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
758 
759 /**
760  * @title CappedCrowdsale
761  * @dev Crowdsale with a limit for total contributions.
762  */
763 contract CappedCrowdsale is Crowdsale {
764   using SafeMath for uint256;
765 
766   uint256 public cap;
767 
768   /**
769    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
770    * @param _cap Max amount of wei to be contributed
771    */
772   constructor(uint256 _cap) public {
773     require(_cap > 0);
774     cap = _cap;
775   }
776 
777   /**
778    * @dev Checks whether the cap has been reached. 
779    * @return Whether the cap was reached
780    */
781   function capReached() public view returns (bool) {
782     return weiRaised >= cap;
783   }
784 
785   /**
786    * @dev Extend parent behavior requiring purchase to respect the funding cap.
787    * @param _beneficiary Token purchaser
788    * @param _weiAmount Amount of wei contributed
789    */
790   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
791     super._preValidatePurchase(_beneficiary, _weiAmount);
792     require(weiRaised.add(_weiAmount) <= cap);
793   }
794 
795 }
796 
797 // File: contracts/SafeGuardsPreSale.sol
798 
799 contract SafeGuardsPreSale is FinalizableCrowdsale, CappedCrowdsale {
800     using SafeMath for uint256;
801 
802     // amount of tokens that was sold on the crowdsale
803     uint256 public tokensSold;
804 
805     // if minimumGoal will not be reached till _closingTime, buyers will be able to refund ETH
806     uint256 public minimumGoal;
807 
808     // how much wei we have returned back to the contract after a failed crowdfund
809     uint public loadedRefund;
810 
811     // how much wei we have given back to buyers
812     uint public weiRefunded;
813 
814     // how much ETH each address has bought to this crowdsale
815     mapping (address => uint) public boughtAmountOf;
816 
817     // minimum amount of wel, that can be contributed
818     uint256 constant public minimumAmountWei = 1e16;
819 
820     // timestamp until presale investors can't transfer tokens
821     uint256 public presaleTransfersPaused = now + 180 days;
822 
823     // timestamp until investors can't burn tokens
824     uint256 public presaleBurnPaused = now + 180 days;
825 
826     // ---====== BONUSES for presale users ======---
827 
828     // time presale bonuses
829     uint constant public preSaleBonus1Time = 1535155200; // 
830     uint constant public preSaleBonus1Percent = 25;
831     uint constant public preSaleBonus2Time = 1536019200; // 
832     uint constant public preSaleBonus2Percent = 15;
833     uint constant public preSaleBonus3Time = 1536883200; // 
834     uint constant public preSaleBonus3Percent = 5;
835 
836     // amount presale bonuses
837     uint constant public preSaleBonus1Amount = 155   * 1e15;
838     uint constant public preSaleBonus2Amount = 387   * 1e15;
839     uint constant public preSaleBonus3Amount = 1550  * 1e15;
840     uint constant public preSaleBonus4Amount = 15500 * 1e15;
841 
842     // ---=== Addresses of founders, team and bounty ===---
843     address constant public w_futureDevelopment = 0x4b297AB09bF4d2d8107fAa03cFF5377638Ec6C83;
844     address constant public w_Reserv = 0xbb67c6E089c7801ab3c7790158868970ea0d8a7C;
845     address constant public w_Founders = 0xa3b331037e29540F8BD30f3DE4fF4045a8115ff4;
846     address constant public w_Team = 0xa8324689c94eC3cbE9413C61b00E86A96978b4A7;
847     address constant public w_Advisers = 0x2516998954440b027171Ecb955A4C01DfF610F2d;
848     address constant public w_Bounty = 0x1792b603F233220e1E623a6ab3FEc68deFa15f2F;
849 
850 
851     event AddBonus(address indexed addr, uint256 amountWei, uint256 date, uint bonusType);
852 
853     struct Bonus {
854         address addr;
855         uint256 amountWei;
856         uint256 date;
857         uint bonusType;
858     }
859 
860     struct Bonuses {
861         address addr;
862         uint256 numBonusesInAddress;
863         uint256[] indexes;
864     }
865 
866     /**
867      * @dev Get all bonuses by account address
868      */
869     mapping(address => Bonuses) public bonuses;
870 
871     /**
872      * @dev Bonuses list
873      */
874     Bonus[] public bonusList;
875 
876     /**
877      * @dev Count of bonuses in list
878      */
879     function numBonuses() public view returns (uint256)
880     { return bonusList.length; }
881 
882     /**
883      * @dev Count of members in archive
884      */
885     function getBonusByAddressAndIndex(address _addr, uint256 _index) public view returns (uint256)
886     { return bonuses[_addr].indexes[_index]; }
887 
888 
889     /**
890      * @param _rate Number of token units a buyer gets per one ETH
891      * @param _wallet Address where collected funds will be forwarded to
892      * @param _token Address of the token being sold
893      * @param _openingTime Crowdsale opening time
894      * @param _closingTime Crowdsale closing time
895      * @param _minimumGoal Funding goal (soft cap)
896      * @param _cap Max amount of ETH to be contributed (hard cap)
897      */
898     constructor(
899         uint256 _rate,
900         address _wallet,
901         ERC20 _token,
902         uint256 _openingTime,
903         uint256 _closingTime,
904         uint256 _minimumGoal,
905         uint256 _cap
906     )
907     Crowdsale(_rate * 1 ether, _wallet, _token)
908     TimedCrowdsale(_openingTime, _closingTime)
909     CappedCrowdsale(_cap * 1 ether)
910     public
911     {
912         require(_rate > 0);
913         require(_wallet != address(0));
914 
915         rate = _rate;
916         wallet = _wallet;
917 
918         minimumGoal = _minimumGoal * 1 ether;
919     }
920 
921     /**
922      * @dev Allows the current owner to transfer token's control to a newOwner.
923      * @param _newTokenOwner The address to transfer token's ownership to.
924      */
925     function changeTokenOwner(address _newTokenOwner) external onlyOwner {
926         require(_newTokenOwner != 0x0);
927         require(hasClosed());
928 
929         SafeGuardsToken(token).transferOwnership(_newTokenOwner);
930     }
931 
932     /**
933    * @dev finalization task, called when owner calls finalize()
934    */
935     function finalization() internal {
936         require(isMinimumGoalReached());
937 
938         SafeGuardsToken(token).mint(w_futureDevelopment, tokensSold.mul(20).div(43));
939         SafeGuardsToken(token).mint(w_Reserv, tokensSold.mul(20).div(43));
940         SafeGuardsToken(token).mint(w_Founders, tokensSold.mul(7).div(43));
941         SafeGuardsToken(token).mint(w_Team, tokensSold.mul(5).div(43));
942         SafeGuardsToken(token).mint(w_Advisers, tokensSold.mul(3).div(43));
943         SafeGuardsToken(token).mint(w_Bounty, tokensSold.mul(2).div(43));
944 
945         super.finalization();
946     }
947 
948     /**
949    * @dev Validation of an incoming purchase.
950    * @param _beneficiary Address performing the token purchase
951    * @param _weiAmount Value in wei involved in the purchase
952    */
953     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
954         require(_weiAmount >= minimumAmountWei);
955 
956         super._preValidatePurchase(_beneficiary, _weiAmount);
957     }
958 
959     /**
960      * @dev Overrides delivery by minting tokens upon purchase.
961      * @param _beneficiary Token purchaser
962      * @param _tokenAmount Number of tokens to be minted
963      */
964     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
965         require(SafeGuardsToken(token).mintFrozen(_beneficiary, _tokenAmount));
966         tokensSold = tokensSold.add(_tokenAmount);
967     }
968 
969     function changeTransfersPaused(uint256 _newFrozenPauseTime) onlyOwner public returns (bool) {
970         require(_newFrozenPauseTime > now);
971 
972         presaleTransfersPaused = _newFrozenPauseTime;
973         SafeGuardsToken(token).changeFrozenTime(_newFrozenPauseTime);
974         return true;
975     }
976 
977     function changeBurnPaused(uint256 _newBurnPauseTime) onlyOwner public returns (bool) {
978         require(_newBurnPauseTime > presaleBurnPaused);
979 
980         presaleBurnPaused = _newBurnPauseTime;
981         SafeGuardsToken(token).changeBurnPausedTime(_newBurnPauseTime);
982         return true;
983     }
984 
985 
986     // ===--- Bonuses functionality ---===
987 
988     /**
989      * @dev add bonuses for users
990      * @param _beneficiary Address receiving the tokens
991      * @param _weiAmount Value in wei involved in the purchase
992      */
993     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
994         require(_weiAmount >= minimumAmountWei);
995 
996         boughtAmountOf[msg.sender] = boughtAmountOf[msg.sender].add(_weiAmount);
997 
998         if (_weiAmount >= preSaleBonus1Amount) {
999             if (_weiAmount >= preSaleBonus2Amount) {
1000                 if (_weiAmount >= preSaleBonus3Amount) {
1001                     if (_weiAmount >= preSaleBonus4Amount) {
1002                         addBonusToUser(msg.sender, _weiAmount, preSaleBonus4Amount, 4);
1003                     } else {
1004                         addBonusToUser(msg.sender, _weiAmount, preSaleBonus3Amount, 3);
1005                     }
1006                 } else {
1007                     addBonusToUser(msg.sender, _weiAmount, preSaleBonus2Amount, 2);
1008                 }
1009             } else {
1010                 addBonusToUser(msg.sender, _weiAmount, preSaleBonus1Amount, 1);
1011             }
1012         }
1013     }
1014 
1015     function addBonusToUser(address _addr, uint256 _weiAmount, uint256 _bonusAmount, uint _bonusType) internal {
1016         uint256 countBonuses = _weiAmount.div(_bonusAmount);
1017 
1018         Bonus memory b;
1019         b.addr = _addr;
1020         b.amountWei = _weiAmount;
1021         b.date = now;
1022         b.bonusType = _bonusType;
1023 
1024         for (uint256 i = 0; i < countBonuses; i++) {
1025             bonuses[_addr].addr = _addr;
1026             bonuses[_addr].numBonusesInAddress++;
1027             bonuses[_addr].indexes.push(bonusList.push(b) - 1);
1028 
1029             emit AddBonus(_addr, _weiAmount, now, _bonusType);
1030         }
1031     }
1032 
1033     /**
1034    * @dev Returns the rate of tokens per wei at the present time.
1035    * Note that, as price _increases_ with time, the rate _decreases_.
1036    * @return The number of tokens a buyer gets per wei at a given time
1037    */
1038     function getCurrentRate() public view returns (uint256) {
1039         if (now > preSaleBonus3Time) {
1040             return rate;
1041         }
1042 
1043         if (now < preSaleBonus1Time) {
1044             return rate.add(rate.mul(preSaleBonus1Percent).div(100));
1045         }
1046 
1047         if (now < preSaleBonus2Time) {
1048             return rate.add(rate.mul(preSaleBonus2Percent).div(100));
1049         }
1050 
1051         if (now < preSaleBonus3Time) {
1052             return rate.add(rate.mul(preSaleBonus3Percent).div(100));
1053         }
1054 
1055         return rate;
1056     }
1057 
1058     /**
1059      * @dev Overrides parent method taking into account variable rate.
1060      * @param _weiAmount The value in wei to be converted into tokens
1061      * @return The number of tokens _weiAmount wei will buy at present time
1062      */
1063     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1064         uint256 currentRate = getCurrentRate();
1065         return currentRate.mul(_weiAmount);
1066     }
1067 
1068 
1069     // ===--- Refund functionality ---===
1070 
1071     // a refund was processed for an buyer
1072     event Refund(address buyer, uint weiAmount);
1073     event RefundLoaded(uint amount);
1074 
1075     // return true if the crowdsale has raised enough money to be a successful.
1076     function isMinimumGoalReached() public constant returns (bool) {
1077         return weiRaised >= minimumGoal;
1078     }
1079 
1080     /**
1081     * Allow load refunds back on the contract for the refunding.
1082     *
1083     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached.
1084     */
1085     function loadRefund() external payable {
1086         require(msg.sender == wallet);
1087         require(msg.value > 0);
1088         require(!isMinimumGoalReached());
1089 
1090         loadedRefund = loadedRefund.add(msg.value);
1091 
1092         emit RefundLoaded(msg.value);
1093     }
1094 
1095     /**
1096     * Buyers can claim refund.
1097     *
1098     * Note that any refunds from proxy buyers should be handled separately,
1099     * and not through this contract.
1100     */
1101     function refund() external {
1102         require(!isMinimumGoalReached() && loadedRefund > 0);
1103 
1104         uint weiValue = boughtAmountOf[msg.sender];
1105         require(weiValue > 0);
1106         require(weiValue <= loadedRefund);
1107 
1108         boughtAmountOf[msg.sender] = 0;
1109         weiRefunded = weiRefunded.add(weiValue);
1110         msg.sender.transfer(weiValue);
1111 
1112         emit Refund(msg.sender, weiValue);
1113     }
1114 }