1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
100     require(token.transfer(to, value));
101   }
102 
103   function safeTransferFrom(
104     ERC20 token,
105     address from,
106     address to,
107     uint256 value
108   )
109     internal
110   {
111     require(token.transferFrom(from, to, value));
112   }
113 
114   function safeApprove(ERC20 token, address spender, uint256 value) internal {
115     require(token.approve(spender, value));
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
120 
121 /**
122  * @title Crowdsale
123  * @dev Crowdsale is a base contract for managing a token crowdsale,
124  * allowing investors to purchase tokens with ether. This contract implements
125  * such functionality in its most fundamental form and can be extended to provide additional
126  * functionality and/or custom behavior.
127  * The external interface represents the basic interface for purchasing tokens, and conform
128  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
129  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
130  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
131  * behavior.
132  */
133 contract Crowdsale {
134   using SafeMath for uint256;
135   using SafeERC20 for ERC20;
136 
137   // The token being sold
138   ERC20 public token;
139 
140   // Address where funds are collected
141   address public wallet;
142 
143   // How many token units a buyer gets per wei.
144   // The rate is the conversion between wei and the smallest and indivisible token unit.
145   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
146   // 1 wei will give you 1 unit, or 0.001 TOK.
147   uint256 public rate;
148 
149   // Amount of wei raised
150   uint256 public weiRaised;
151 
152   /**
153    * Event for token purchase logging
154    * @param purchaser who paid for the tokens
155    * @param beneficiary who got the tokens
156    * @param value weis paid for purchase
157    * @param amount amount of tokens purchased
158    */
159   event TokenPurchase(
160     address indexed purchaser,
161     address indexed beneficiary,
162     uint256 value,
163     uint256 amount
164   );
165 
166   /**
167    * @param _rate Number of token units a buyer gets per wei
168    * @param _wallet Address where collected funds will be forwarded to
169    * @param _token Address of the token being sold
170    */
171   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
172     require(_rate > 0);
173     require(_wallet != address(0));
174     require(_token != address(0));
175 
176     rate = _rate;
177     wallet = _wallet;
178     token = _token;
179   }
180 
181   // -----------------------------------------
182   // Crowdsale external interface
183   // -----------------------------------------
184 
185   /**
186    * @dev fallback function ***DO NOT OVERRIDE***
187    */
188   function () external payable {
189     buyTokens(msg.sender);
190   }
191 
192   /**
193    * @dev low level token purchase ***DO NOT OVERRIDE***
194    * @param _beneficiary Address performing the token purchase
195    */
196   function buyTokens(address _beneficiary) public payable {
197 
198     uint256 weiAmount = msg.value;
199     _preValidatePurchase(_beneficiary, weiAmount);
200 
201     // calculate token amount to be created
202     uint256 tokens = _getTokenAmount(weiAmount);
203 
204     // update state
205     weiRaised = weiRaised.add(weiAmount);
206 
207     _processPurchase(_beneficiary, tokens);
208     emit TokenPurchase(
209       msg.sender,
210       _beneficiary,
211       weiAmount,
212       tokens
213     );
214 
215     _updatePurchasingState(_beneficiary, weiAmount);
216 
217     _forwardFunds();
218     _postValidatePurchase(_beneficiary, weiAmount);
219   }
220 
221   // -----------------------------------------
222   // Internal interface (extensible)
223   // -----------------------------------------
224 
225   /**
226    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
227    * @param _beneficiary Address performing the token purchase
228    * @param _weiAmount Value in wei involved in the purchase
229    */
230   function _preValidatePurchase(
231     address _beneficiary,
232     uint256 _weiAmount
233   )
234     internal
235   {
236     require(_beneficiary != address(0));
237     require(_weiAmount != 0);
238   }
239 
240   /**
241    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
242    * @param _beneficiary Address performing the token purchase
243    * @param _weiAmount Value in wei involved in the purchase
244    */
245   function _postValidatePurchase(
246     address _beneficiary,
247     uint256 _weiAmount
248   )
249     internal
250   {
251     // optional override
252   }
253 
254   /**
255    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
256    * @param _beneficiary Address performing the token purchase
257    * @param _tokenAmount Number of tokens to be emitted
258    */
259   function _deliverTokens(
260     address _beneficiary,
261     uint256 _tokenAmount
262   )
263     internal
264   {
265     token.safeTransfer(_beneficiary, _tokenAmount);
266   }
267 
268   /**
269    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
270    * @param _beneficiary Address receiving the tokens
271    * @param _tokenAmount Number of tokens to be purchased
272    */
273   function _processPurchase(
274     address _beneficiary,
275     uint256 _tokenAmount
276   )
277     internal
278   {
279     _deliverTokens(_beneficiary, _tokenAmount);
280   }
281 
282   /**
283    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
284    * @param _beneficiary Address receiving the tokens
285    * @param _weiAmount Value in wei involved in the purchase
286    */
287   function _updatePurchasingState(
288     address _beneficiary,
289     uint256 _weiAmount
290   )
291     internal
292   {
293     // optional override
294   }
295 
296   /**
297    * @dev Override to extend the way in which ether is converted to tokens.
298    * @param _weiAmount Value in wei to be converted into tokens
299    * @return Number of tokens that can be purchased with the specified _weiAmount
300    */
301   function _getTokenAmount(uint256 _weiAmount)
302     internal view returns (uint256)
303   {
304     return _weiAmount.mul(rate);
305   }
306 
307   /**
308    * @dev Determines how ETH is stored/forwarded on purchases.
309    */
310   function _forwardFunds() internal {
311     wallet.transfer(msg.value);
312   }
313 }
314 
315 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
316 
317 /**
318  * @title CappedCrowdsale
319  * @dev Crowdsale with a limit for total contributions.
320  */
321 contract CappedCrowdsale is Crowdsale {
322   using SafeMath for uint256;
323 
324   uint256 public cap;
325 
326   /**
327    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
328    * @param _cap Max amount of wei to be contributed
329    */
330   constructor(uint256 _cap) public {
331     require(_cap > 0);
332     cap = _cap;
333   }
334 
335   /**
336    * @dev Checks whether the cap has been reached.
337    * @return Whether the cap was reached
338    */
339   function capReached() public view returns (bool) {
340     return weiRaised >= cap;
341   }
342 
343   /**
344    * @dev Extend parent behavior requiring purchase to respect the funding cap.
345    * @param _beneficiary Token purchaser
346    * @param _weiAmount Amount of wei contributed
347    */
348   function _preValidatePurchase(
349     address _beneficiary,
350     uint256 _weiAmount
351   )
352     internal
353   {
354     super._preValidatePurchase(_beneficiary, _weiAmount);
355     require(weiRaised.add(_weiAmount) <= cap);
356   }
357 
358 }
359 
360 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
361 
362 /**
363  * @title Ownable
364  * @dev The Ownable contract has an owner address, and provides basic authorization control
365  * functions, this simplifies the implementation of "user permissions".
366  */
367 contract Ownable {
368   address public owner;
369 
370 
371   event OwnershipRenounced(address indexed previousOwner);
372   event OwnershipTransferred(
373     address indexed previousOwner,
374     address indexed newOwner
375   );
376 
377 
378   /**
379    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
380    * account.
381    */
382   constructor() public {
383     owner = msg.sender;
384   }
385 
386   /**
387    * @dev Throws if called by any account other than the owner.
388    */
389   modifier onlyOwner() {
390     require(msg.sender == owner);
391     _;
392   }
393 
394   /**
395    * @dev Allows the current owner to relinquish control of the contract.
396    * @notice Renouncing to ownership will leave the contract without an owner.
397    * It will not be possible to call the functions with the `onlyOwner`
398    * modifier anymore.
399    */
400   function renounceOwnership() public onlyOwner {
401     emit OwnershipRenounced(owner);
402     owner = address(0);
403   }
404 
405   /**
406    * @dev Allows the current owner to transfer control of the contract to a newOwner.
407    * @param _newOwner The address to transfer ownership to.
408    */
409   function transferOwnership(address _newOwner) public onlyOwner {
410     _transferOwnership(_newOwner);
411   }
412 
413   /**
414    * @dev Transfers control of the contract to a newOwner.
415    * @param _newOwner The address to transfer ownership to.
416    */
417   function _transferOwnership(address _newOwner) internal {
418     require(_newOwner != address(0));
419     emit OwnershipTransferred(owner, _newOwner);
420     owner = _newOwner;
421   }
422 }
423 
424 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
425 
426 /**
427  * @title Pausable
428  * @dev Base contract which allows children to implement an emergency stop mechanism.
429  */
430 contract Pausable is Ownable {
431   event Pause();
432   event Unpause();
433 
434   bool public paused = false;
435 
436 
437   /**
438    * @dev Modifier to make a function callable only when the contract is not paused.
439    */
440   modifier whenNotPaused() {
441     require(!paused);
442     _;
443   }
444 
445   /**
446    * @dev Modifier to make a function callable only when the contract is paused.
447    */
448   modifier whenPaused() {
449     require(paused);
450     _;
451   }
452 
453   /**
454    * @dev called by the owner to pause, triggers stopped state
455    */
456   function pause() onlyOwner whenNotPaused public {
457     paused = true;
458     emit Pause();
459   }
460 
461   /**
462    * @dev called by the owner to unpause, returns to normal state
463    */
464   function unpause() onlyOwner whenPaused public {
465     paused = false;
466     emit Unpause();
467   }
468 }
469 
470 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
471 
472 /**
473  * @title Basic token
474  * @dev Basic version of StandardToken, with no allowances.
475  */
476 contract BasicToken is ERC20Basic {
477   using SafeMath for uint256;
478 
479   mapping(address => uint256) balances;
480 
481   uint256 totalSupply_;
482 
483   /**
484   * @dev Total number of tokens in existence
485   */
486   function totalSupply() public view returns (uint256) {
487     return totalSupply_;
488   }
489 
490   /**
491   * @dev Transfer token for a specified address
492   * @param _to The address to transfer to.
493   * @param _value The amount to be transferred.
494   */
495   function transfer(address _to, uint256 _value) public returns (bool) {
496     require(_to != address(0));
497     require(_value <= balances[msg.sender]);
498 
499     balances[msg.sender] = balances[msg.sender].sub(_value);
500     balances[_to] = balances[_to].add(_value);
501     emit Transfer(msg.sender, _to, _value);
502     return true;
503   }
504 
505   /**
506   * @dev Gets the balance of the specified address.
507   * @param _owner The address to query the the balance of.
508   * @return An uint256 representing the amount owned by the passed address.
509   */
510   function balanceOf(address _owner) public view returns (uint256) {
511     return balances[_owner];
512   }
513 
514 }
515 
516 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
517 
518 /**
519  * @title Burnable Token
520  * @dev Token that can be irreversibly burned (destroyed).
521  */
522 contract BurnableToken is BasicToken {
523 
524   event Burn(address indexed burner, uint256 value);
525 
526   /**
527    * @dev Burns a specific amount of tokens.
528    * @param _value The amount of token to be burned.
529    */
530   function burn(uint256 _value) public {
531     _burn(msg.sender, _value);
532   }
533 
534   function _burn(address _who, uint256 _value) internal {
535     require(_value <= balances[_who]);
536     // no need to require value <= totalSupply, since that would imply the
537     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
538 
539     balances[_who] = balances[_who].sub(_value);
540     totalSupply_ = totalSupply_.sub(_value);
541     emit Burn(_who, _value);
542     emit Transfer(_who, address(0), _value);
543   }
544 }
545 
546 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
547 
548 /**
549  * @title Standard ERC20 token
550  *
551  * @dev Implementation of the basic standard token.
552  * https://github.com/ethereum/EIPs/issues/20
553  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
554  */
555 contract StandardToken is ERC20, BasicToken {
556 
557   mapping (address => mapping (address => uint256)) internal allowed;
558 
559 
560   /**
561    * @dev Transfer tokens from one address to another
562    * @param _from address The address which you want to send tokens from
563    * @param _to address The address which you want to transfer to
564    * @param _value uint256 the amount of tokens to be transferred
565    */
566   function transferFrom(
567     address _from,
568     address _to,
569     uint256 _value
570   )
571     public
572     returns (bool)
573   {
574     require(_to != address(0));
575     require(_value <= balances[_from]);
576     require(_value <= allowed[_from][msg.sender]);
577 
578     balances[_from] = balances[_from].sub(_value);
579     balances[_to] = balances[_to].add(_value);
580     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
581     emit Transfer(_from, _to, _value);
582     return true;
583   }
584 
585   /**
586    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
587    * Beware that changing an allowance with this method brings the risk that someone may use both the old
588    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
589    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
590    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
591    * @param _spender The address which will spend the funds.
592    * @param _value The amount of tokens to be spent.
593    */
594   function approve(address _spender, uint256 _value) public returns (bool) {
595     allowed[msg.sender][_spender] = _value;
596     emit Approval(msg.sender, _spender, _value);
597     return true;
598   }
599 
600   /**
601    * @dev Function to check the amount of tokens that an owner allowed to a spender.
602    * @param _owner address The address which owns the funds.
603    * @param _spender address The address which will spend the funds.
604    * @return A uint256 specifying the amount of tokens still available for the spender.
605    */
606   function allowance(
607     address _owner,
608     address _spender
609    )
610     public
611     view
612     returns (uint256)
613   {
614     return allowed[_owner][_spender];
615   }
616 
617   /**
618    * @dev Increase the amount of tokens that an owner allowed to a spender.
619    * approve should be called when allowed[_spender] == 0. To increment
620    * allowed value is better to use this function to avoid 2 calls (and wait until
621    * the first transaction is mined)
622    * From MonolithDAO Token.sol
623    * @param _spender The address which will spend the funds.
624    * @param _addedValue The amount of tokens to increase the allowance by.
625    */
626   function increaseApproval(
627     address _spender,
628     uint256 _addedValue
629   )
630     public
631     returns (bool)
632   {
633     allowed[msg.sender][_spender] = (
634       allowed[msg.sender][_spender].add(_addedValue));
635     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
636     return true;
637   }
638 
639   /**
640    * @dev Decrease the amount of tokens that an owner allowed to a spender.
641    * approve should be called when allowed[_spender] == 0. To decrement
642    * allowed value is better to use this function to avoid 2 calls (and wait until
643    * the first transaction is mined)
644    * From MonolithDAO Token.sol
645    * @param _spender The address which will spend the funds.
646    * @param _subtractedValue The amount of tokens to decrease the allowance by.
647    */
648   function decreaseApproval(
649     address _spender,
650     uint256 _subtractedValue
651   )
652     public
653     returns (bool)
654   {
655     uint256 oldValue = allowed[msg.sender][_spender];
656     if (_subtractedValue > oldValue) {
657       allowed[msg.sender][_spender] = 0;
658     } else {
659       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
660     }
661     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
662     return true;
663   }
664 
665 }
666 
667 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
668 
669 /**
670  * @title Mintable token
671  * @dev Simple ERC20 Token example, with mintable token creation
672  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
673  */
674 contract MintableToken is StandardToken, Ownable {
675   event Mint(address indexed to, uint256 amount);
676   event MintFinished();
677 
678   bool public mintingFinished = false;
679 
680 
681   modifier canMint() {
682     require(!mintingFinished);
683     _;
684   }
685 
686   modifier hasMintPermission() {
687     require(msg.sender == owner);
688     _;
689   }
690 
691   /**
692    * @dev Function to mint tokens
693    * @param _to The address that will receive the minted tokens.
694    * @param _amount The amount of tokens to mint.
695    * @return A boolean that indicates if the operation was successful.
696    */
697   function mint(
698     address _to,
699     uint256 _amount
700   )
701     hasMintPermission
702     canMint
703     public
704     returns (bool)
705   {
706     totalSupply_ = totalSupply_.add(_amount);
707     balances[_to] = balances[_to].add(_amount);
708     emit Mint(_to, _amount);
709     emit Transfer(address(0), _to, _amount);
710     return true;
711   }
712 
713   /**
714    * @dev Function to stop minting new tokens.
715    * @return True if the operation was successful.
716    */
717   function finishMinting() onlyOwner canMint public returns (bool) {
718     mintingFinished = true;
719     emit MintFinished();
720     return true;
721   }
722 }
723 
724 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
725 
726 /**
727  * @title Capped token
728  * @dev Mintable token with a token cap.
729  */
730 contract CappedToken is MintableToken {
731 
732   uint256 public cap;
733 
734   constructor(uint256 _cap) public {
735     require(_cap > 0);
736     cap = _cap;
737   }
738 
739   /**
740    * @dev Function to mint tokens
741    * @param _to The address that will receive the minted tokens.
742    * @param _amount The amount of tokens to mint.
743    * @return A boolean that indicates if the operation was successful.
744    */
745   function mint(
746     address _to,
747     uint256 _amount
748   )
749     public
750     returns (bool)
751   {
752     require(totalSupply_.add(_amount) <= cap);
753 
754     return super.mint(_to, _amount);
755   }
756 
757 }
758 
759 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
760 
761 /**
762  * @title Pausable token
763  * @dev StandardToken modified with pausable transfers.
764  **/
765 contract PausableToken is StandardToken, Pausable {
766 
767   function transfer(
768     address _to,
769     uint256 _value
770   )
771     public
772     whenNotPaused
773     returns (bool)
774   {
775     return super.transfer(_to, _value);
776   }
777 
778   function transferFrom(
779     address _from,
780     address _to,
781     uint256 _value
782   )
783     public
784     whenNotPaused
785     returns (bool)
786   {
787     return super.transferFrom(_from, _to, _value);
788   }
789 
790   function approve(
791     address _spender,
792     uint256 _value
793   )
794     public
795     whenNotPaused
796     returns (bool)
797   {
798     return super.approve(_spender, _value);
799   }
800 
801   function increaseApproval(
802     address _spender,
803     uint _addedValue
804   )
805     public
806     whenNotPaused
807     returns (bool success)
808   {
809     return super.increaseApproval(_spender, _addedValue);
810   }
811 
812   function decreaseApproval(
813     address _spender,
814     uint _subtractedValue
815   )
816     public
817     whenNotPaused
818     returns (bool success)
819   {
820     return super.decreaseApproval(_spender, _subtractedValue);
821   }
822 }
823 
824 // File: contracts/CarryToken.sol
825 
826 // The Carry token and the tokensale contracts
827 // Copyright (C) 2018 Carry Protocol
828 //
829 // This program is free software: you can redistribute it and/or modify
830 // it under the terms of the GNU General Public License as published by
831 // the Free Software Foundation, either version 3 of the License, or
832 // (at your option) any later version.
833 //
834 // This program is distributed in the hope that it will be useful,
835 // but WITHOUT ANY WARRANTY; without even the implied warranty of
836 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
837 // GNU General Public License for more details.
838 //
839 // You should have received a copy of the GNU General Public License
840 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
841 pragma solidity ^0.4.24;
842 
843 
844 
845 
846 contract CarryToken is PausableToken, CappedToken, BurnableToken {
847     string public name = "CarryToken";
848     string public symbol = "CRE";
849     uint8 public decimals = 18;
850 
851     // See also <https://carryprotocol.io/#section-token-distribution>.
852     //                10 billion <---------|   |-----------------> 10^18
853     uint256 constant TOTAL_CAP = 10000000000 * (10 ** uint256(decimals));
854 
855     constructor() public CappedToken(TOTAL_CAP) {
856     }
857 }
858 
859 // File: contracts/CarryPublicTokenCrowdsale.sol
860 
861 // The Carry token and the tokensale contracts
862 // Copyright (C) 2018 Carry Protocol
863 //
864 // This program is free software: you can redistribute it and/or modify
865 // it under the terms of the GNU General Public License as published by
866 // the Free Software Foundation, either version 3 of the License, or
867 // (at your option) any later version.
868 //
869 // This program is distributed in the hope that it will be useful,
870 // but WITHOUT ANY WARRANTY; without even the implied warranty of
871 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
872 // GNU General Public License for more details.
873 //
874 // You should have received a copy of the GNU General Public License
875 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
876 pragma solidity ^0.4.24;
877 
878 
879 
880 
881 
882 /**
883  * @title CarryPublicTokenCrowdsale
884  * @dev The Carry token public sale contract.
885  */
886 contract CarryPublicTokenCrowdsale is CappedCrowdsale, Pausable {
887     using SafeMath for uint256;
888 
889     uint256 constant maxGasPrice = 40000000000;  // 40 gwei
890 
891     // Individual min purchases.
892     uint256 public individualMinPurchaseWei;
893 
894     struct IndividualMaxCap {
895         uint256 timestamp;
896         uint256 maxWei;
897     }
898 
899     // Individual max purchases differ by time.  The mapping keys are timestamps
900     // and values are weis an individual can purchase at most
901     // If the transaction is made later than a timestamp it can accept
902     // the corresponding cap at most.
903     //
904     // Where individualMaxCaps = [
905     //   IndividualMaxCap(1533081600, 5 ether),
906     //   IndividualMaxCap(1533686400, 10 ether)
907     // ]
908     // If a transaction is made before 1533081600 (2018-08-01 sharp UTC)
909     // it disallows any purchase.
910     // If a transaction is made between 1533081600 (2018-08-01 sharp UTC)
911     // 1533686400 (2018-08-08 sharp UTC) it takes 5 ethers at most.
912     // If a transaction is made after 1533686400 (2018-08-08 sharp UTC)
913     // it takes 10 ethers at most.
914     IndividualMaxCap[] public individualMaxCaps;
915 
916     mapping(address => uint256) public contributions;
917 
918     // Each index represents the grade (the order is arbitrary) and its value
919     // represents a timestamp when people (i.e., addresses) belonging to that
920     // grade becomes available to purchase tokens.  Note that the first value
921     // (i.e., whitelistGrades[0]) must be zero since the index 0 must represent
922     // the state of "not whitelisted."
923     //
924     // The index numbers are used by the whitelist mapping (see below).
925     // As the key type of the whitelist mapping is uint8, there cannot be more
926     // than 2^8 grades.
927     uint256[] public whitelistGrades;
928 
929     // This mapping represents what grade each address belongs to.  Values are
930     // an index number and refer to a grade (see the whitelistGrades array).
931     // A special value 0 represents the predefined state that "it is not
932     // whitelisted and does not belong to any grade."
933     //
934     // Where whitelistGrades = [0, 1533686400, 1533081600]
935     //   and whitelist = [X => 2, Y => 1, Z => 0]
936     //
937     // X cannot purchase any tokens until 1533081600 (2018-08-01 sharp UTC),
938     // but became to able to purchase tokens after that.
939     // Y cannot purchase any tokens until 1533686400 (2018-08-08 sharp
940     // UTC), but became to able to purchase tokens after that.
941     // Z cannot purchase any tokens since it is not whitelisted and does not
942     // belong to any grade.
943     //
944     // As values of a mapping in solidity are virtually all zeros by default,
945     // addresses never associated by the whitelist mapping are not whitelisted
946     // by default.
947     mapping(address => uint8) public whitelist;
948 
949     // Token amounts people purchased.  Keys are an address and values are
950     // CRE tokens (in minor units).  If X purchased 5 CRE it is represented as
951     // [X => 5 * 10**18].
952     mapping(address => uint256) public balances;
953 
954     // Whether to allow purchasers to withdraw their tokens.  Intended to be
955     // false at first, and then become true at some point.
956     bool public withdrawable;
957 
958     // The fixed due date (timestamp) of token delivery.  Even if withdrawable
959     // if not set to true, since the due date purchasers become able to withdraw
960     // tokens.  See also whenWithdrawable modifier below.
961     uint256 public tokenDeliveryDue;
962 
963     mapping(address => uint256) public refundedDeposits;
964 
965     constructor(
966         address _wallet,
967         CarryToken _token,
968         uint256 _rate,
969         uint256 _cap,
970         uint256 _tokenDeliveryDue,
971         uint256[] _whitelistGrades,
972         uint256 _individualMinPurchaseWei,
973 
974         // Since Solidity currently doesn't allows parameters to take array of
975         // structs, we work around this by taking two arrays for each field
976         // (timestmap and maxWei) separately.  It fails unless two arrays are
977         // of equal length.
978         uint256[] _individualMaxCapTimestamps,
979         uint256[] _individualMaxCapWeis
980     ) public CappedCrowdsale(_cap) Crowdsale(_rate, _wallet, _token) {
981         require(
982             _individualMaxCapTimestamps.length == _individualMaxCapWeis.length,
983             "_individualMaxCap{Timestamps,Weis} do not have equal length."
984         );
985         tokenDeliveryDue = _tokenDeliveryDue;
986         if (_whitelistGrades.length < 1) {
987             whitelistGrades = [0];
988         } else {
989             require(
990                 _whitelistGrades.length < 0x100,
991                 "The grade number must be less than 2^8."
992             );
993             require(
994                 _whitelistGrades[0] == 0,
995                 "The _whitelistGrades[0] must be zero."
996             );
997             whitelistGrades = _whitelistGrades;
998         }
999         individualMinPurchaseWei = _individualMinPurchaseWei;
1000         for (uint i = 0; i < _individualMaxCapTimestamps.length; i++) {
1001             uint256 timestamp = _individualMaxCapTimestamps[i];
1002             require(
1003                 i < 1 || timestamp > _individualMaxCapTimestamps[i - 1],
1004                 "_individualMaxCapTimestamps have to be in ascending order and no duplications."
1005             );
1006             individualMaxCaps.push(
1007                 IndividualMaxCap(
1008                     timestamp,
1009                     _individualMaxCapWeis[i]
1010                 )
1011             );
1012         }
1013     }
1014 
1015     function _preValidatePurchase(
1016         address _beneficiary,
1017         uint256 _weiAmount
1018     ) internal whenNotPaused {
1019         // Prevent gas war among purchasers.
1020         require(
1021             tx.gasprice <= maxGasPrice,
1022             "Gas price is too expensive. Don't be competitive."
1023         );
1024 
1025         super._preValidatePurchase(_beneficiary, _weiAmount);
1026 
1027         uint8 grade = whitelist[_beneficiary];
1028         require(grade > 0, "Not whitelisted.");
1029         uint openingTime = whitelistGrades[grade];
1030         require(
1031             // solium-disable-next-line security/no-block-members
1032             block.timestamp >= openingTime,
1033             "Currently unavailable to purchase tokens."
1034         );
1035 
1036         uint256 contribution = contributions[_beneficiary];
1037         uint256 contributionAfterPurchase = contribution.add(_weiAmount);
1038 
1039         // If a contributor already has purchased a minimum amount, say 0.1 ETH,
1040         // then they can purchase once again with less than a minimum amount,
1041         // say 0.01 ETH, because they have already satisfied the minimum
1042         // purchase.
1043         require(
1044             contributionAfterPurchase >= individualMinPurchaseWei,
1045             "Sent ethers is not enough."
1046         );
1047 
1048         // See also the comment on the individualMaxCaps above.
1049         uint256 individualMaxWei = 0;
1050         for (uint i = 0; i < individualMaxCaps.length; i++) {
1051             uint256 capTimestamp = individualMaxCaps[i].timestamp;
1052             // solium-disable-next-line security/no-block-members
1053             if (capTimestamp <= block.timestamp) {
1054                 individualMaxWei = individualMaxCaps[i].maxWei;
1055             } else {
1056                 // Optimize gas consumption by trimming timestamps no more used.
1057                 if (i > 1) {
1058                     uint offset = i - 1;
1059                     uint trimmedLength = individualMaxCaps.length - offset;
1060                     for (uint256 j = 0; j < trimmedLength; j++) {
1061                         individualMaxCaps[j] = individualMaxCaps[offset + j];
1062                     }
1063                     individualMaxCaps.length = trimmedLength;
1064                 }
1065                 break;
1066             }
1067         }
1068         require(
1069             contributionAfterPurchase <= individualMaxWei,
1070             individualMaxWei > 0
1071                 ? "Total ethers you've purchased is too much."
1072                 : "Purchase is currently disallowed."
1073         );
1074     }
1075 
1076     function _updatePurchasingState(
1077         address _beneficiary,
1078         uint256 _weiAmount
1079     ) internal {
1080         super._updatePurchasingState(_beneficiary, _weiAmount);
1081         contributions[_beneficiary] = contributions[_beneficiary].add(
1082             _weiAmount
1083         );
1084     }
1085 
1086     function addAddressesToWhitelist(
1087         address[] _beneficiaries,
1088         uint8 _grade
1089     ) external onlyOwner {
1090         require(_grade < whitelistGrades.length, "No such grade number.");
1091         for (uint256 i = 0; i < _beneficiaries.length; i++) {
1092             whitelist[_beneficiaries[i]] = _grade;
1093         }
1094     }
1095 
1096     // Override to prevent immediate delivery of tokens.
1097     function _processPurchase(
1098         address _beneficiary,
1099         uint256 _tokenAmount
1100     ) internal {
1101         balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
1102     }
1103 
1104     function setWithdrawable(bool _withdrawable) external onlyOwner {
1105         withdrawable = _withdrawable;
1106     }
1107 
1108     modifier whenWithdrawable() {
1109         require(
1110             // solium-disable-next-line security/no-block-members
1111             withdrawable || block.timestamp >= tokenDeliveryDue,
1112             "Currently tokens cannot be withdrawn."
1113         );
1114         _;
1115     }
1116 
1117     event TokenDelivered(address indexed beneficiary, uint256 tokenAmount);
1118 
1119     function _deliverTokens(address _beneficiary) internal {
1120         uint256 amount = balances[_beneficiary];
1121         if (amount > 0) {
1122             balances[_beneficiary] = 0;
1123             _deliverTokens(_beneficiary, amount);
1124             emit TokenDelivered(_beneficiary, amount);
1125         }
1126     }
1127 
1128     function withdrawTokens() public whenWithdrawable {
1129         _deliverTokens(msg.sender);
1130     }
1131 
1132     function deliverTokens(
1133         address[] _beneficiaries
1134     ) public onlyOwner whenWithdrawable {
1135         for (uint256 i = 0; i < _beneficiaries.length; i++) {
1136             _deliverTokens(_beneficiaries[i]);
1137         }
1138     }
1139 
1140     event RefundDeposited(
1141         address indexed beneficiary,
1142         uint256 tokenAmount,
1143         uint256 weiAmount
1144     );
1145     event Refunded(
1146         address indexed beneficiary,
1147         address indexed receiver,
1148         uint256 weiAmount
1149     );
1150 
1151     /**
1152      * @dev Refund the given ether to a beneficiary.  It only can be called by
1153      * either the contract owner or the wallet (i.e., Crowdsale.wallet) address.
1154      * The only amount of the ether sent together in a transaction is refunded.
1155      */
1156     function depositRefund(address _beneficiary) public payable {
1157         require(
1158             msg.sender == owner || msg.sender == wallet,
1159             "No permission to access."
1160         );
1161         uint256 weiToRefund = msg.value;
1162         require(
1163             weiToRefund <= weiRaised,
1164             "Sent ethers is higher than even the total raised ethers."
1165         );
1166         uint256 tokensToRefund = _getTokenAmount(weiToRefund);
1167         uint256 tokenBalance = balances[_beneficiary];
1168         require(
1169             tokenBalance >= tokensToRefund,
1170             "Sent ethers is higher than the ethers _beneficiary has purchased."
1171         );
1172         weiRaised = weiRaised.sub(weiToRefund);
1173         balances[_beneficiary] = tokenBalance.sub(tokensToRefund);
1174         refundedDeposits[_beneficiary] = refundedDeposits[_beneficiary].add(
1175             weiToRefund
1176         );
1177         emit RefundDeposited(_beneficiary, tokensToRefund, weiToRefund);
1178     }
1179 
1180     /**
1181      * @dev Receive one's refunded ethers in the deposit.  It can be called by
1182      * only a beneficiary of refunds.
1183      * It takes a parameter, a wallet address to receive the deposited
1184      * (refunded) ethers.  (Usually it would be the same to the beneficiary
1185      * address unless the beneficiary address is a smart contract unable to
1186      * receive ethers.)
1187      */
1188     function receiveRefund(address _wallet) public {
1189         _transferRefund(msg.sender, _wallet);
1190     }
1191 
1192     function _transferRefund(address _beneficiary, address _wallet) internal {
1193         uint256 depositedWeiAmount = refundedDeposits[_beneficiary];
1194         require(depositedWeiAmount > 0, "_beneficiary has never purchased.");
1195         refundedDeposits[_beneficiary] = 0;
1196         contributions[_beneficiary] = contributions[_beneficiary].sub(
1197             depositedWeiAmount
1198         );
1199         _wallet.transfer(depositedWeiAmount);
1200         emit Refunded(_beneficiary, _wallet, depositedWeiAmount);
1201     }
1202 }