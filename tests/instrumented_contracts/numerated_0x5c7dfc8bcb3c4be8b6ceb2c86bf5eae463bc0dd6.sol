1 pragma solidity ^0.4.21;
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
112 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 // File: contracts/ERC20WithData.sol
223 
224 contract ERC20WithData is StandardToken {
225     /**
226      @dev Addition to ERC20 token methods. It allows to
227      approve the transfer of value and execute a call with the sent data.
228 
229      @param _spender The address that will spend the funds.
230      @param _value The amount of tokens to be spent.
231      @param _data ABI-encoded contract call to call `_to` address.
232 
233      @return true if the call function was executed successfully
234    */
235     function approveAndCall(address _spender, uint256 _value, bytes _data) public returns (bool) {
236         require(_spender != address(this));
237 
238         super.approve(_spender, _value);
239 
240         require(_spender.call(_data));
241 
242         return true;
243     }
244 
245     /**
246        @dev Addition to ERC20 token methods. Transfer tokens to a specified
247        address and execute a call with the sent data on the same transaction
248 
249        @param _to address The address which you want to transfer to
250        @param _value uint256 the amout of tokens to be transfered
251        @param _data ABI-encoded contract call to call `_to` address.
252 
253        @return true if the call function was executed successfully
254      */
255     function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool) {
256         require(_to != address(this));
257 
258         super.transfer(_to, _value);
259 
260         require(_to.call(_data));
261         return true;
262     }
263 
264     /**
265        @dev Addition to ERC20 token methods. Transfer tokens from one address to
266        another and make a contract call on the same transaction
267 
268        @param _from The address which you want to send tokens from
269        @param _to The address which you want to transfer to
270        @param _value The amout of tokens to be transferred
271        @param _data ABI-encoded contract call to call `_to` address.
272 
273        @return true if the call function was executed successfully
274      */
275     function transferFromAndCall(
276         address _from,
277         address _to,
278         uint256 _value,
279         bytes _data
280     ) public returns (bool)
281     {
282         require(_to != address(this));
283 
284         super.transferFrom(_from, _to, _value);
285 
286         require(_to.call(_data));
287         return true;
288     }
289 
290     /**
291      * @dev Addition to StandardToken methods. Increase the amount of tokens that
292      * an owner allowed to a spender and execute a call with the sent data.
293      *
294      * @param _spender The address which will spend the funds.
295      * @param _addedValue The amount of tokens to increase the allowance by.
296      * @param _data ABI-encoded contract call to call `_spender` address.
297      */
298     function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public returns (bool) {
299         require(_spender != address(this));
300 
301         super.increaseApproval(_spender, _addedValue);
302 
303         require(_spender.call(_data));
304 
305         return true;
306     }
307 
308     /**
309      * @dev Addition to StandardToken methods. Decrease the amount of tokens that
310      * an owner allowed to a spender and execute a call with the sent data.
311      *
312      * @param _spender The address which will spend the funds.
313      * @param _subtractedValue The amount of tokens to decrease the allowance by.
314      * @param _data ABI-encoded contract call to call `_spender` address.
315      */
316     function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
317         require(_spender != address(this));
318 
319         super.decreaseApproval(_spender, _subtractedValue);
320 
321         require(_spender.call(_data));
322 
323         return true;
324     }
325 }
326 
327 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
328 
329 /**
330  * @title Burnable Token
331  * @dev Token that can be irreversibly burned (destroyed).
332  */
333 contract BurnableToken is BasicToken {
334 
335   event Burn(address indexed burner, uint256 value);
336 
337   /**
338    * @dev Burns a specific amount of tokens.
339    * @param _value The amount of token to be burned.
340    */
341   function burn(uint256 _value) public {
342     require(_value <= balances[msg.sender]);
343     // no need to require value <= totalSupply, since that would imply the
344     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
345 
346     address burner = msg.sender;
347     balances[burner] = balances[burner].sub(_value);
348     totalSupply_ = totalSupply_.sub(_value);
349     Burn(burner, _value);
350     Transfer(burner, address(0), _value);
351   }
352 }
353 
354 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
355 
356 contract DetailedERC20 is ERC20 {
357   string public name;
358   string public symbol;
359   uint8 public decimals;
360 
361   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
362     name = _name;
363     symbol = _symbol;
364     decimals = _decimals;
365   }
366 }
367 
368 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
369 
370 /**
371  * @title Ownable
372  * @dev The Ownable contract has an owner address, and provides basic authorization control
373  * functions, this simplifies the implementation of "user permissions".
374  */
375 contract Ownable {
376   address public owner;
377 
378 
379   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381 
382   /**
383    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
384    * account.
385    */
386   function Ownable() public {
387     owner = msg.sender;
388   }
389 
390   /**
391    * @dev Throws if called by any account other than the owner.
392    */
393   modifier onlyOwner() {
394     require(msg.sender == owner);
395     _;
396   }
397 
398   /**
399    * @dev Allows the current owner to transfer control of the contract to a newOwner.
400    * @param newOwner The address to transfer ownership to.
401    */
402   function transferOwnership(address newOwner) public onlyOwner {
403     require(newOwner != address(0));
404     OwnershipTransferred(owner, newOwner);
405     owner = newOwner;
406   }
407 
408 }
409 
410 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
411 
412 /**
413  * @title Mintable token
414  * @dev Simple ERC20 Token example, with mintable token creation
415  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
416  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
417  */
418 contract MintableToken is StandardToken, Ownable {
419   event Mint(address indexed to, uint256 amount);
420   event MintFinished();
421 
422   bool public mintingFinished = false;
423 
424 
425   modifier canMint() {
426     require(!mintingFinished);
427     _;
428   }
429 
430   /**
431    * @dev Function to mint tokens
432    * @param _to The address that will receive the minted tokens.
433    * @param _amount The amount of tokens to mint.
434    * @return A boolean that indicates if the operation was successful.
435    */
436   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
437     totalSupply_ = totalSupply_.add(_amount);
438     balances[_to] = balances[_to].add(_amount);
439     Mint(_to, _amount);
440     Transfer(address(0), _to, _amount);
441     return true;
442   }
443 
444   /**
445    * @dev Function to stop minting new tokens.
446    * @return True if the operation was successful.
447    */
448   function finishMinting() onlyOwner canMint public returns (bool) {
449     mintingFinished = true;
450     MintFinished();
451     return true;
452   }
453 }
454 
455 // File: contracts/AleaCoin.sol
456 
457 contract AleaCoin is DetailedERC20, MintableToken, BurnableToken, ERC20WithData {
458 
459 
460     modifier canTransfer() {
461         require(mintingFinished);
462         _;
463     }
464 
465     function AleaCoin()
466     DetailedERC20("Alea Coin", "ALEA", 18) public
467     {}
468 
469     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
470         return super.transfer(_to, _value);
471     }
472 
473     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
474         return super.transferFrom(_from, _to, _value);
475     }
476 
477     function transferAndCall(address _to, uint256 _value, bytes _data) canTransfer public returns (bool) {
478         return super.transferAndCall(_to, _value, _data);
479     }
480 
481     function transferFromAndCall(
482         address _from,
483         address _to,
484         uint256 _value,
485         bytes _data)
486     canTransfer public returns (bool)
487     {
488         return super.transferFromAndCall(
489             _from,
490             _to,
491             _value,
492             _data
493         );
494     }
495 
496     function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) {
497         return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
498     }
499 }
500 
501 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
502 
503 /**
504  * @title Crowdsale
505  * @dev Crowdsale is a base contract for managing a token crowdsale,
506  * allowing investors to purchase tokens with ether. This contract implements
507  * such functionality in its most fundamental form and can be extended to provide additional
508  * functionality and/or custom behavior.
509  * The external interface represents the basic interface for purchasing tokens, and conform
510  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
511  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
512  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
513  * behavior.
514  */
515 
516 contract Crowdsale {
517   using SafeMath for uint256;
518 
519   // The token being sold
520   ERC20 public token;
521 
522   // Address where funds are collected
523   address public wallet;
524 
525   // How many token units a buyer gets per wei
526   uint256 public rate;
527 
528   // Amount of wei raised
529   uint256 public weiRaised;
530 
531   /**
532    * Event for token purchase logging
533    * @param purchaser who paid for the tokens
534    * @param beneficiary who got the tokens
535    * @param value weis paid for purchase
536    * @param amount amount of tokens purchased
537    */
538   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
539 
540   /**
541    * @param _rate Number of token units a buyer gets per wei
542    * @param _wallet Address where collected funds will be forwarded to
543    * @param _token Address of the token being sold
544    */
545   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
546     require(_rate > 0);
547     require(_wallet != address(0));
548     require(_token != address(0));
549 
550     rate = _rate;
551     wallet = _wallet;
552     token = _token;
553   }
554 
555   // -----------------------------------------
556   // Crowdsale external interface
557   // -----------------------------------------
558 
559   /**
560    * @dev fallback function ***DO NOT OVERRIDE***
561    */
562   function () external payable {
563     buyTokens(msg.sender);
564   }
565 
566   /**
567    * @dev low level token purchase ***DO NOT OVERRIDE***
568    * @param _beneficiary Address performing the token purchase
569    */
570   function buyTokens(address _beneficiary) public payable {
571 
572     uint256 weiAmount = msg.value;
573     _preValidatePurchase(_beneficiary, weiAmount);
574 
575     // calculate token amount to be created
576     uint256 tokens = _getTokenAmount(weiAmount);
577 
578     // update state
579     weiRaised = weiRaised.add(weiAmount);
580 
581     _processPurchase(_beneficiary, tokens);
582     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
583 
584     _updatePurchasingState(_beneficiary, weiAmount);
585 
586     _forwardFunds();
587     _postValidatePurchase(_beneficiary, weiAmount);
588   }
589 
590   // -----------------------------------------
591   // Internal interface (extensible)
592   // -----------------------------------------
593 
594   /**
595    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
596    * @param _beneficiary Address performing the token purchase
597    * @param _weiAmount Value in wei involved in the purchase
598    */
599   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
600     require(_beneficiary != address(0));
601     require(_weiAmount != 0);
602   }
603 
604   /**
605    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
606    * @param _beneficiary Address performing the token purchase
607    * @param _weiAmount Value in wei involved in the purchase
608    */
609   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
610     // optional override
611   }
612 
613   /**
614    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
615    * @param _beneficiary Address performing the token purchase
616    * @param _tokenAmount Number of tokens to be emitted
617    */
618   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
619     token.transfer(_beneficiary, _tokenAmount);
620   }
621 
622   /**
623    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
624    * @param _beneficiary Address receiving the tokens
625    * @param _tokenAmount Number of tokens to be purchased
626    */
627   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
628     _deliverTokens(_beneficiary, _tokenAmount);
629   }
630 
631   /**
632    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
633    * @param _beneficiary Address receiving the tokens
634    * @param _weiAmount Value in wei involved in the purchase
635    */
636   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
637     // optional override
638   }
639 
640   /**
641    * @dev Override to extend the way in which ether is converted to tokens.
642    * @param _weiAmount Value in wei to be converted into tokens
643    * @return Number of tokens that can be purchased with the specified _weiAmount
644    */
645   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
646     return _weiAmount.mul(rate);
647   }
648 
649   /**
650    * @dev Determines how ETH is stored/forwarded on purchases.
651    */
652   function _forwardFunds() internal {
653     wallet.transfer(msg.value);
654   }
655 }
656 
657 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
658 
659 /**
660  * @title MintedCrowdsale
661  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
662  * Token ownership should be transferred to MintedCrowdsale for minting. 
663  */
664 contract MintedCrowdsale is Crowdsale {
665 
666   /**
667    * @dev Overrides delivery by minting tokens upon purchase.
668    * @param _beneficiary Token purchaser
669    * @param _tokenAmount Number of tokens to be minted
670    */
671   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
672     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
673   }
674 }
675 
676 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
677 
678 /**
679  * @title TimedCrowdsale
680  * @dev Crowdsale accepting contributions only within a time frame.
681  */
682 contract TimedCrowdsale is Crowdsale {
683   using SafeMath for uint256;
684 
685   uint256 public openingTime;
686   uint256 public closingTime;
687 
688   /**
689    * @dev Reverts if not in crowdsale time range. 
690    */
691   modifier onlyWhileOpen {
692     require(now >= openingTime && now <= closingTime);
693     _;
694   }
695 
696   /**
697    * @dev Constructor, takes crowdsale opening and closing times.
698    * @param _openingTime Crowdsale opening time
699    * @param _closingTime Crowdsale closing time
700    */
701   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
702     require(_openingTime >= now);
703     require(_closingTime >= _openingTime);
704 
705     openingTime = _openingTime;
706     closingTime = _closingTime;
707   }
708 
709   /**
710    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
711    * @return Whether crowdsale period has elapsed
712    */
713   function hasClosed() public view returns (bool) {
714     return now > closingTime;
715   }
716   
717   /**
718    * @dev Extend parent behavior requiring to be within contributing period
719    * @param _beneficiary Token purchaser
720    * @param _weiAmount Amount of wei contributed
721    */
722   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
723     super._preValidatePurchase(_beneficiary, _weiAmount);
724   }
725 
726 }
727 
728 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
729 
730 /**
731  * @title SafeERC20
732  * @dev Wrappers around ERC20 operations that throw on failure.
733  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
734  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
735  */
736 library SafeERC20 {
737   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
738     assert(token.transfer(to, value));
739   }
740 
741   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
742     assert(token.transferFrom(from, to, value));
743   }
744 
745   function safeApprove(ERC20 token, address spender, uint256 value) internal {
746     assert(token.approve(spender, value));
747   }
748 }
749 
750 // File: zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
751 
752 /**
753  * @title TokenTimelock
754  * @dev TokenTimelock is a token holder contract that will allow a
755  * beneficiary to extract the tokens after a given release time
756  */
757 contract TokenTimelock {
758   using SafeERC20 for ERC20Basic;
759 
760   // ERC20 basic token contract being held
761   ERC20Basic public token;
762 
763   // beneficiary of tokens after they are released
764   address public beneficiary;
765 
766   // timestamp when token release is enabled
767   uint256 public releaseTime;
768 
769   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
770     require(_releaseTime > now);
771     token = _token;
772     beneficiary = _beneficiary;
773     releaseTime = _releaseTime;
774   }
775 
776   /**
777    * @notice Transfers tokens held by timelock to beneficiary.
778    */
779   function release() public {
780     require(now >= releaseTime);
781 
782     uint256 amount = token.balanceOf(this);
783     require(amount > 0);
784 
785     token.safeTransfer(beneficiary, amount);
786   }
787 }
788 
789 // File: contracts/AleaPrivateSale.sol
790 
791 contract AleaPrivateSale is TimedCrowdsale, MintedCrowdsale, Ownable {
792 
793     bool public initiated = false;
794 
795     uint256 public cap;
796 
797     // Company wallet
798     address public companyWallet;
799     // Team wallet
800     address public teamWallet;
801     // Advisor wallet
802     address public advisorWallet;
803     // Reserve tokens
804     address public reserveWallet;
805 
806 
807     TokenTimelock public companyTimeLock;
808     TokenTimelock public teamTimeLock;
809 
810     // reserved tokens
811     uint256 public companyTokens 	= 	40000000 * (10 ** 18);
812     uint256 public teamTokens 		= 	16000000 * (10 ** 18);
813     uint256 public advisorTokens 	= 	20000000 * (10 ** 18);
814     uint256 public reserveTokens 	= 	4000000 * (10 ** 18);
815 
816     function AleaPrivateSale(
817         uint256 _startTime,
818         uint256 _endTime,
819         uint256 _rate,
820         address _wallet,
821         uint256 _tokenCap,
822         address _token
823     )
824     TimedCrowdsale(_startTime, _endTime)
825     Crowdsale(_rate, _wallet, ERC20(_token))
826     public
827     {
828         require(_tokenCap != 0);
829 
830         cap = (_tokenCap * (10 ** 18)).div(_rate);
831     }
832 
833     function initSale(
834         address _companyWallet,
835         address _teamWallet,
836         address _advisorWallet,
837         address _reserveWallet
838     ) public onlyOwner
839     {
840         require(!initiated);
841         require(_companyWallet != 0x0);
842         require(_teamWallet != 0x0);
843         require(_advisorWallet != 0x0);
844         require(_reserveWallet != 0x0);
845 
846         companyWallet = _companyWallet;
847         teamWallet = _teamWallet;
848         advisorWallet = _advisorWallet;
849         reserveWallet = _reserveWallet;
850 
851         _deliverTokens(companyWallet, companyTokens.div(2)); //Half of company token is given directly
852 
853         //31 May 2019 23:59:00 GMT+02:00 DST
854         companyTimeLock = new TokenTimelock(token, companyWallet, uint64(1559339940)); //Half of company token is time locked
855         _deliverTokens(address(companyTimeLock), companyTokens.div(2));
856 
857         //31 December 2019 23:59:00 GMT+01:00
858         teamTimeLock = new TokenTimelock(token, teamWallet, uint64(1577833140)); //Team tokens are time locked for 1 year
859         _deliverTokens(address(teamTimeLock), teamTokens);
860 
861         _deliverTokens(advisorWallet, advisorTokens);
862         _deliverTokens(reserveWallet, reserveTokens);
863 
864         initiated = true;
865     }
866 
867     // Transfer ownership of token to a new address need for the next sale
868     function transferTokenOwnership(address _newOwner) public onlyOwner {
869         require(ended());
870         require(_newOwner != 0x0);
871 
872         // transfer token ownership
873         Ownable(token).transferOwnership(_newOwner);
874     }
875 
876     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
877     function started() public view returns(bool) {
878         return now >= openingTime;
879     }
880 
881     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
882     function ended() public view returns(bool) {
883         return hasClosed() || capReached();
884     }
885 
886     /**
887      * @dev Checks whether the cap has been reached.
888      * @return Whether the cap was reached
889      */
890     function capReached() public view returns (bool) {
891         return weiRaised >= cap;
892     }
893 
894     function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) {
895         return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
896     }
897 
898     /**
899      * @dev Extend parent behavior requiring purchase to respect the funding cap.
900      * @param _beneficiary Token purchaser
901      * @param _weiAmount Amount of wei contributed
902      */
903     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
904         super._preValidatePurchase(_beneficiary, _weiAmount);
905         require(weiRaised.add(_weiAmount) <= cap);
906     }
907 }