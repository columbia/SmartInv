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
365 // File: contracts/SintToken.sol
366 
367 contract SintToken is BurnableToken, CappedToken {
368 
369     event TransfersUnlocked();
370     event Timelock(address indexed beneficiary, uint256 releaseTime);
371 
372     string public constant name = "Sint Token";
373     string public constant symbol = "SIN";
374     uint8 public constant decimals = 18;
375 
376     mapping (address => uint256) private lockedUntil; // timestamps
377 
378     bool public lockedTransfers = true;
379 
380     function SintToken(
381         uint256 _cap
382     )
383         public
384         CappedToken(_cap.mul(1 ether))
385     {
386         //
387     }
388 
389     modifier whenLockedTransfers() {
390         require(lockedTransfers);
391         _;
392     }
393 
394     modifier whenUnlockedTransfers(address _sender) {
395         require(!lockedTransfers);
396         require(lockedUntil[_sender] < now, "Timelock"); // optional time lock
397         _;
398     }
399 
400     function unlockTransfers()
401         onlyOwner
402         whenLockedTransfers
403         public
404     {
405         lockedTransfers = false;
406         emit TransfersUnlocked();
407     }
408 
409     function timelock(address _beneficiary, uint256 _releaseTime)
410         onlyOwner
411         whenLockedTransfers
412         public
413         returns (bool)
414     {
415         lockedUntil[_beneficiary] = _releaseTime;
416         emit Timelock(_beneficiary, _releaseTime);
417         return true;
418     }
419 
420     function transfer(address _to, uint256 _value)
421         whenUnlockedTransfers(msg.sender)
422         public
423         returns (bool)
424     {
425         return super.transfer(_to, _value);
426     }
427 
428     function transferFrom(address _from, address _to, uint256 _value)
429         whenUnlockedTransfers(_from)
430         public
431         returns (bool)
432     {
433         return super.transferFrom(_from, _to, _value);
434     }
435 
436 }
437 
438 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
439 
440 /**
441  * @title Crowdsale
442  * @dev Crowdsale is a base contract for managing a token crowdsale,
443  * allowing investors to purchase tokens with ether. This contract implements
444  * such functionality in its most fundamental form and can be extended to provide additional
445  * functionality and/or custom behavior.
446  * The external interface represents the basic interface for purchasing tokens, and conform
447  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
448  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
449  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
450  * behavior.
451  */
452 
453 contract Crowdsale {
454   using SafeMath for uint256;
455 
456   // The token being sold
457   ERC20 public token;
458 
459   // Address where funds are collected
460   address public wallet;
461 
462   // How many token units a buyer gets per wei
463   uint256 public rate;
464 
465   // Amount of wei raised
466   uint256 public weiRaised;
467 
468   /**
469    * Event for token purchase logging
470    * @param purchaser who paid for the tokens
471    * @param beneficiary who got the tokens
472    * @param value weis paid for purchase
473    * @param amount amount of tokens purchased
474    */
475   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
476 
477   /**
478    * @param _rate Number of token units a buyer gets per wei
479    * @param _wallet Address where collected funds will be forwarded to
480    * @param _token Address of the token being sold
481    */
482   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
483     require(_rate > 0);
484     require(_wallet != address(0));
485     require(_token != address(0));
486 
487     rate = _rate;
488     wallet = _wallet;
489     token = _token;
490   }
491 
492   // -----------------------------------------
493   // Crowdsale external interface
494   // -----------------------------------------
495 
496   /**
497    * @dev fallback function ***DO NOT OVERRIDE***
498    */
499   function () external payable {
500     buyTokens(msg.sender);
501   }
502 
503   /**
504    * @dev low level token purchase ***DO NOT OVERRIDE***
505    * @param _beneficiary Address performing the token purchase
506    */
507   function buyTokens(address _beneficiary) public payable {
508 
509     uint256 weiAmount = msg.value;
510     _preValidatePurchase(_beneficiary, weiAmount);
511 
512     // calculate token amount to be created
513     uint256 tokens = _getTokenAmount(weiAmount);
514 
515     // update state
516     weiRaised = weiRaised.add(weiAmount);
517 
518     _processPurchase(_beneficiary, tokens);
519     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
520 
521     _updatePurchasingState(_beneficiary, weiAmount);
522 
523     _forwardFunds();
524     _postValidatePurchase(_beneficiary, weiAmount);
525   }
526 
527   // -----------------------------------------
528   // Internal interface (extensible)
529   // -----------------------------------------
530 
531   /**
532    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
533    * @param _beneficiary Address performing the token purchase
534    * @param _weiAmount Value in wei involved in the purchase
535    */
536   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
537     require(_beneficiary != address(0));
538     require(_weiAmount != 0);
539   }
540 
541   /**
542    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
543    * @param _beneficiary Address performing the token purchase
544    * @param _weiAmount Value in wei involved in the purchase
545    */
546   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
547     // optional override
548   }
549 
550   /**
551    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
552    * @param _beneficiary Address performing the token purchase
553    * @param _tokenAmount Number of tokens to be emitted
554    */
555   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
556     token.transfer(_beneficiary, _tokenAmount);
557   }
558 
559   /**
560    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
561    * @param _beneficiary Address receiving the tokens
562    * @param _tokenAmount Number of tokens to be purchased
563    */
564   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
565     _deliverTokens(_beneficiary, _tokenAmount);
566   }
567 
568   /**
569    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
570    * @param _beneficiary Address receiving the tokens
571    * @param _weiAmount Value in wei involved in the purchase
572    */
573   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
574     // optional override
575   }
576 
577   /**
578    * @dev Override to extend the way in which ether is converted to tokens.
579    * @param _weiAmount Value in wei to be converted into tokens
580    * @return Number of tokens that can be purchased with the specified _weiAmount
581    */
582   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
583     return _weiAmount.mul(rate);
584   }
585 
586   /**
587    * @dev Determines how ETH is stored/forwarded on purchases.
588    */
589   function _forwardFunds() internal {
590     wallet.transfer(msg.value);
591   }
592 }
593 
594 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
595 
596 /**
597  * @title MintedCrowdsale
598  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
599  * Token ownership should be transferred to MintedCrowdsale for minting.
600  */
601 contract MintedCrowdsale is Crowdsale {
602 
603   /**
604    * @dev Overrides delivery by minting tokens upon purchase.
605    * @param _beneficiary Token purchaser
606    * @param _tokenAmount Number of tokens to be minted
607    */
608   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
609     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
610   }
611 }
612 
613 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
614 
615 /**
616  * @title CappedCrowdsale
617  * @dev Crowdsale with a limit for total contributions.
618  */
619 contract CappedCrowdsale is Crowdsale {
620   using SafeMath for uint256;
621 
622   uint256 public cap;
623 
624   /**
625    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
626    * @param _cap Max amount of wei to be contributed
627    */
628   function CappedCrowdsale(uint256 _cap) public {
629     require(_cap > 0);
630     cap = _cap;
631   }
632 
633   /**
634    * @dev Checks whether the cap has been reached.
635    * @return Whether the cap was reached
636    */
637   function capReached() public view returns (bool) {
638     return weiRaised >= cap;
639   }
640 
641   /**
642    * @dev Extend parent behavior requiring purchase to respect the funding cap.
643    * @param _beneficiary Token purchaser
644    * @param _weiAmount Amount of wei contributed
645    */
646   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
647     super._preValidatePurchase(_beneficiary, _weiAmount);
648     require(weiRaised.add(_weiAmount) <= cap);
649   }
650 
651 }
652 
653 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
654 
655 /**
656  * @title TimedCrowdsale
657  * @dev Crowdsale accepting contributions only within a time frame.
658  */
659 contract TimedCrowdsale is Crowdsale {
660   using SafeMath for uint256;
661 
662   uint256 public openingTime;
663   uint256 public closingTime;
664 
665   /**
666    * @dev Reverts if not in crowdsale time range.
667    */
668   modifier onlyWhileOpen {
669     require(now >= openingTime && now <= closingTime);
670     _;
671   }
672 
673   /**
674    * @dev Constructor, takes crowdsale opening and closing times.
675    * @param _openingTime Crowdsale opening time
676    * @param _closingTime Crowdsale closing time
677    */
678   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
679     require(_openingTime >= now);
680     require(_closingTime >= _openingTime);
681 
682     openingTime = _openingTime;
683     closingTime = _closingTime;
684   }
685 
686   /**
687    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
688    * @return Whether crowdsale period has elapsed
689    */
690   function hasClosed() public view returns (bool) {
691     return now > closingTime;
692   }
693 
694   /**
695    * @dev Extend parent behavior requiring to be within contributing period
696    * @param _beneficiary Token purchaser
697    * @param _weiAmount Amount of wei contributed
698    */
699   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
700     super._preValidatePurchase(_beneficiary, _weiAmount);
701   }
702 
703 }
704 
705 // File: contracts/SintCrowdsale.sol
706 
707 contract SintCrowdsale is CappedCrowdsale, TimedCrowdsale, MintedCrowdsale, Ownable {
708 
709     uint256 public constant minAmount = 0.1 ether;
710 
711     // timestamps
712     uint256[3] internal bonusEndDates = [
713         1525687140, // 2018-05-07 23:59:59 CET
714         1526291940, // 2018-05-14 23:59:59 CET
715         1526896740 // 2018-05-21 23:59:59 CET
716     ];
717 
718     uint8[3] internal bonusPercentages = [
719         30,
720         20,
721         10
722     ];
723 
724     address[8] internal advisorWallets = [
725         0x542A625Ab5182Af9219B92A723e0B937a5edDCa5, // Bogdan Fiedur
726         0xBd8DD5e35C9935fCB48B7575FbF1A25FC3BD0dCd, // Bas Geelen
727         0xb5C51Ca28cbb7F07a8123275C3b51319588E767d, // Lin JC
728         0x31F9961B4b42221680C3d86eA08761E4E121f231, // Jakub Garszynski
729         0x8164876957be1bF660b81419421B16641af19dF9, // Tobias Schulz
730         0x3e2eDBE3cC53f5105D8451D73846de47B38931f6, // Denis Farnosov
731         0xcacc29637Ca90bC49F0aeD017C1eFCa50E0C2951, // Maciej Szafraniec
732         0xc7F218965226391B89e7aEC7c10dafF384Eee7C7 // Shams Hassan
733     ];
734 
735     address internal teamWallet = 0x78f1C69DcB99A5038e511e6f42F40ABd6bFA4d2a;
736 
737     function SintCrowdsale(
738         uint256 _openingTime,
739         uint256 _closingTime,
740         uint256 _rate,
741         address _wallet,
742         SintToken _token,
743         uint256 _cap
744     )
745         public
746         Crowdsale(_rate, _wallet, _token)
747         CappedCrowdsale(_cap.mul(1 ether))
748         TimedCrowdsale(_openingTime, _closingTime)
749     {
750         require(bonusEndDates.length == bonusPercentages.length);
751         require(advisorWallets.length > 0);
752     }
753 
754     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
755         internal
756     {
757         require(_weiAmount >= minAmount);
758         super._preValidatePurchase(_beneficiary, _weiAmount);
759     }
760 
761     function _getCurrentBonus()
762         internal
763         view
764         returns (uint8)
765     {
766         for (uint8 i = 0; i < bonusEndDates.length; i++)
767         {
768             if (bonusEndDates[i] > now)
769             {
770                 return 100 + bonusPercentages[i];
771             }
772         }
773 
774         return 100;
775     }
776 
777     function _getTokenAmount(uint256 _weiAmount)
778         internal
779         view
780         returns (uint256)
781     {
782         uint8 currentBonus = _getCurrentBonus();
783         return _weiAmount.mul(rate).mul(currentBonus).div(100);
784     }
785 
786     function distributeTeamTokens()
787         onlyOwner
788         public
789     {
790         require(hasClosed());
791 
792         uint256 tokenCap = CappedToken(token).cap();
793 
794         // advisors
795         // mint and split 3% of total token supply evenly between advisors
796         uint256 advisorAllowance = tokenCap.mul(3).div(100).div(advisorWallets.length);
797         for (uint8 i = 0; i < advisorWallets.length; i++)
798         {
799             require(MintableToken(token).mint(advisorWallets[i], advisorAllowance));
800         }
801 
802         // founders and team
803         // mint and lock for two years 6% of total supply
804         uint256 teamAllowance = tokenCap.mul(6).div(100);
805         require(MintableToken(token).mint(teamWallet, teamAllowance));
806         require(SintToken(token).timelock(teamWallet, closingTime + 60 * 60 * 24 * 365 * 2));
807     }
808 
809     function transferTokenOwnership(address newOwner)
810         onlyOwner
811         public
812     {
813         SintToken(token).transferOwnership(newOwner);
814     }
815 
816 }