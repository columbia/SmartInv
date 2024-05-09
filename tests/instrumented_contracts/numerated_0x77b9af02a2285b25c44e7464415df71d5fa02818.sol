1 pragma solidity ^0.4.21;
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
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
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
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
65 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public view returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
79 
80 /**
81  * @title Crowdsale
82  * @dev Crowdsale is a base contract for managing a token crowdsale,
83  * allowing investors to purchase tokens with ether. This contract implements
84  * such functionality in its most fundamental form and can be extended to provide additional
85  * functionality and/or custom behavior.
86  * The external interface represents the basic interface for purchasing tokens, and conform
87  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
88  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
89  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
90  * behavior.
91  */
92 contract Crowdsale {
93   using SafeMath for uint256;
94 
95   // The token being sold
96   ERC20 public token;
97 
98   // Address where funds are collected
99   address public wallet;
100 
101   // How many token units a buyer gets per wei
102   uint256 public rate;
103 
104   // Amount of wei raised
105   uint256 public weiRaised;
106 
107   /**
108    * Event for token purchase logging
109    * @param purchaser who paid for the tokens
110    * @param beneficiary who got the tokens
111    * @param value weis paid for purchase
112    * @param amount amount of tokens purchased
113    */
114   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
115 
116   /**
117    * @param _rate Number of token units a buyer gets per wei
118    * @param _wallet Address where collected funds will be forwarded to
119    * @param _token Address of the token being sold
120    */
121   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
122     require(_rate > 0);
123     require(_wallet != address(0));
124     require(_token != address(0));
125 
126     rate = _rate;
127     wallet = _wallet;
128     token = _token;
129   }
130 
131   // -----------------------------------------
132   // Crowdsale external interface
133   // -----------------------------------------
134 
135   /**
136    * @dev fallback function ***DO NOT OVERRIDE***
137    */
138   function () external payable {
139     buyTokens(msg.sender);
140   }
141 
142   /**
143    * @dev low level token purchase ***DO NOT OVERRIDE***
144    * @param _beneficiary Address performing the token purchase
145    */
146   function buyTokens(address _beneficiary) public payable {
147 
148     uint256 weiAmount = msg.value;
149     _preValidatePurchase(_beneficiary, weiAmount);
150 
151     // calculate token amount to be created
152     uint256 tokens = _getTokenAmount(weiAmount);
153 
154     // update state
155     weiRaised = weiRaised.add(weiAmount);
156 
157     _processPurchase(_beneficiary, tokens);
158     emit TokenPurchase(
159       msg.sender,
160       _beneficiary,
161       weiAmount,
162       tokens
163     );
164 
165     _updatePurchasingState(_beneficiary, weiAmount);
166 
167     _forwardFunds();
168     _postValidatePurchase(_beneficiary, weiAmount);
169   }
170 
171   // -----------------------------------------
172   // Internal interface (extensible)
173   // -----------------------------------------
174 
175   /**
176    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
177    * @param _beneficiary Address performing the token purchase
178    * @param _weiAmount Value in wei involved in the purchase
179    */
180   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
181     require(_beneficiary != address(0));
182     require(_weiAmount != 0);
183   }
184 
185   /**
186    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
187    * @param _beneficiary Address performing the token purchase
188    * @param _weiAmount Value in wei involved in the purchase
189    */
190   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
191     // optional override
192   }
193 
194   /**
195    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
196    * @param _beneficiary Address performing the token purchase
197    * @param _tokenAmount Number of tokens to be emitted
198    */
199   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
200     token.transfer(_beneficiary, _tokenAmount);
201   }
202 
203   /**
204    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
205    * @param _beneficiary Address receiving the tokens
206    * @param _tokenAmount Number of tokens to be purchased
207    */
208   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
209     _deliverTokens(_beneficiary, _tokenAmount);
210   }
211 
212   /**
213    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
214    * @param _beneficiary Address receiving the tokens
215    * @param _weiAmount Value in wei involved in the purchase
216    */
217   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
218     // optional override
219   }
220 
221   /**
222    * @dev Override to extend the way in which ether is converted to tokens.
223    * @param _weiAmount Value in wei to be converted into tokens
224    * @return Number of tokens that can be purchased with the specified _weiAmount
225    */
226   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
227     return _weiAmount.mul(rate);
228   }
229 
230   /**
231    * @dev Determines how ETH is stored/forwarded on purchases.
232    */
233   function _forwardFunds() internal {
234     wallet.transfer(msg.value);
235   }
236 }
237 
238 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
239 
240 /**
241  * @title CappedCrowdsale
242  * @dev Crowdsale with a limit for total contributions.
243  */
244 contract CappedCrowdsale is Crowdsale {
245   using SafeMath for uint256;
246 
247   uint256 public cap;
248 
249   /**
250    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
251    * @param _cap Max amount of wei to be contributed
252    */
253   function CappedCrowdsale(uint256 _cap) public {
254     require(_cap > 0);
255     cap = _cap;
256   }
257 
258   /**
259    * @dev Checks whether the cap has been reached. 
260    * @return Whether the cap was reached
261    */
262   function capReached() public view returns (bool) {
263     return weiRaised >= cap;
264   }
265 
266   /**
267    * @dev Extend parent behavior requiring purchase to respect the funding cap.
268    * @param _beneficiary Token purchaser
269    * @param _weiAmount Amount of wei contributed
270    */
271   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
272     super._preValidatePurchase(_beneficiary, _weiAmount);
273     require(weiRaised.add(_weiAmount) <= cap);
274   }
275 
276 }
277 
278 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
279 
280 /**
281  * @title Ownable
282  * @dev The Ownable contract has an owner address, and provides basic authorization control
283  * functions, this simplifies the implementation of "user permissions".
284  */
285 contract Ownable {
286   address public owner;
287 
288 
289   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
290 
291 
292   /**
293    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
294    * account.
295    */
296   function Ownable() public {
297     owner = msg.sender;
298   }
299 
300   /**
301    * @dev Throws if called by any account other than the owner.
302    */
303   modifier onlyOwner() {
304     require(msg.sender == owner);
305     _;
306   }
307 
308   /**
309    * @dev Allows the current owner to transfer control of the contract to a newOwner.
310    * @param newOwner The address to transfer ownership to.
311    */
312   function transferOwnership(address newOwner) public onlyOwner {
313     require(newOwner != address(0));
314     emit OwnershipTransferred(owner, newOwner);
315     owner = newOwner;
316   }
317 
318 }
319 
320 // File: openzeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
321 
322 /**
323  * @title WhitelistedCrowdsale
324  * @dev Crowdsale in which only whitelisted users can contribute.
325  */
326 contract WhitelistedCrowdsale is Crowdsale, Ownable {
327 
328   mapping(address => bool) public whitelist;
329 
330   /**
331    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
332    */
333   modifier isWhitelisted(address _beneficiary) {
334     require(whitelist[_beneficiary]);
335     _;
336   }
337 
338   /**
339    * @dev Adds single address to whitelist.
340    * @param _beneficiary Address to be added to the whitelist
341    */
342   function addToWhitelist(address _beneficiary) external onlyOwner {
343     whitelist[_beneficiary] = true;
344   }
345 
346   /**
347    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
348    * @param _beneficiaries Addresses to be added to the whitelist
349    */
350   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
351     for (uint256 i = 0; i < _beneficiaries.length; i++) {
352       whitelist[_beneficiaries[i]] = true;
353     }
354   }
355 
356   /**
357    * @dev Removes single address from whitelist.
358    * @param _beneficiary Address to be removed to the whitelist
359    */
360   function removeFromWhitelist(address _beneficiary) external onlyOwner {
361     whitelist[_beneficiary] = false;
362   }
363 
364   /**
365    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
366    * @param _beneficiary Token beneficiary
367    * @param _weiAmount Amount of wei contributed
368    */
369   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
370     super._preValidatePurchase(_beneficiary, _weiAmount);
371   }
372 
373 }
374 
375 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
376 
377 /**
378  * @title Pausable
379  * @dev Base contract which allows children to implement an emergency stop mechanism.
380  */
381 contract Pausable is Ownable {
382   event Pause();
383   event Unpause();
384 
385   bool public paused = false;
386 
387 
388   /**
389    * @dev Modifier to make a function callable only when the contract is not paused.
390    */
391   modifier whenNotPaused() {
392     require(!paused);
393     _;
394   }
395 
396   /**
397    * @dev Modifier to make a function callable only when the contract is paused.
398    */
399   modifier whenPaused() {
400     require(paused);
401     _;
402   }
403 
404   /**
405    * @dev called by the owner to pause, triggers stopped state
406    */
407   function pause() onlyOwner whenNotPaused public {
408     paused = true;
409     emit Pause();
410   }
411 
412   /**
413    * @dev called by the owner to unpause, returns to normal state
414    */
415   function unpause() onlyOwner whenPaused public {
416     paused = false;
417     emit Unpause();
418   }
419 }
420 
421 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
422 
423 /**
424  * @title Basic token
425  * @dev Basic version of StandardToken, with no allowances.
426  */
427 contract BasicToken is ERC20Basic {
428   using SafeMath for uint256;
429 
430   mapping(address => uint256) balances;
431 
432   uint256 totalSupply_;
433 
434   /**
435   * @dev total number of tokens in existence
436   */
437   function totalSupply() public view returns (uint256) {
438     return totalSupply_;
439   }
440 
441   /**
442   * @dev transfer token for a specified address
443   * @param _to The address to transfer to.
444   * @param _value The amount to be transferred.
445   */
446   function transfer(address _to, uint256 _value) public returns (bool) {
447     require(_to != address(0));
448     require(_value <= balances[msg.sender]);
449 
450     balances[msg.sender] = balances[msg.sender].sub(_value);
451     balances[_to] = balances[_to].add(_value);
452     emit Transfer(msg.sender, _to, _value);
453     return true;
454   }
455 
456   /**
457   * @dev Gets the balance of the specified address.
458   * @param _owner The address to query the the balance of.
459   * @return An uint256 representing the amount owned by the passed address.
460   */
461   function balanceOf(address _owner) public view returns (uint256) {
462     return balances[_owner];
463   }
464 
465 }
466 
467 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
468 
469 /**
470  * @title Burnable Token
471  * @dev Token that can be irreversibly burned (destroyed).
472  */
473 contract BurnableToken is BasicToken {
474 
475   event Burn(address indexed burner, uint256 value);
476 
477   /**
478    * @dev Burns a specific amount of tokens.
479    * @param _value The amount of token to be burned.
480    */
481   function burn(uint256 _value) public {
482     _burn(msg.sender, _value);
483   }
484 
485   function _burn(address _who, uint256 _value) internal {
486     require(_value <= balances[_who]);
487     // no need to require value <= totalSupply, since that would imply the
488     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
489 
490     balances[_who] = balances[_who].sub(_value);
491     totalSupply_ = totalSupply_.sub(_value);
492     emit Burn(_who, _value);
493     emit Transfer(_who, address(0), _value);
494   }
495 }
496 
497 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
498 
499 /**
500  * @title Standard ERC20 token
501  *
502  * @dev Implementation of the basic standard token.
503  * @dev https://github.com/ethereum/EIPs/issues/20
504  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
505  */
506 contract StandardToken is ERC20, BasicToken {
507 
508   mapping (address => mapping (address => uint256)) internal allowed;
509 
510 
511   /**
512    * @dev Transfer tokens from one address to another
513    * @param _from address The address which you want to send tokens from
514    * @param _to address The address which you want to transfer to
515    * @param _value uint256 the amount of tokens to be transferred
516    */
517   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
518     require(_to != address(0));
519     require(_value <= balances[_from]);
520     require(_value <= allowed[_from][msg.sender]);
521 
522     balances[_from] = balances[_from].sub(_value);
523     balances[_to] = balances[_to].add(_value);
524     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
525     emit Transfer(_from, _to, _value);
526     return true;
527   }
528 
529   /**
530    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
531    *
532    * Beware that changing an allowance with this method brings the risk that someone may use both the old
533    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
534    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
535    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
536    * @param _spender The address which will spend the funds.
537    * @param _value The amount of tokens to be spent.
538    */
539   function approve(address _spender, uint256 _value) public returns (bool) {
540     allowed[msg.sender][_spender] = _value;
541     emit Approval(msg.sender, _spender, _value);
542     return true;
543   }
544 
545   /**
546    * @dev Function to check the amount of tokens that an owner allowed to a spender.
547    * @param _owner address The address which owns the funds.
548    * @param _spender address The address which will spend the funds.
549    * @return A uint256 specifying the amount of tokens still available for the spender.
550    */
551   function allowance(address _owner, address _spender) public view returns (uint256) {
552     return allowed[_owner][_spender];
553   }
554 
555   /**
556    * @dev Increase the amount of tokens that an owner allowed to a spender.
557    *
558    * approve should be called when allowed[_spender] == 0. To increment
559    * allowed value is better to use this function to avoid 2 calls (and wait until
560    * the first transaction is mined)
561    * From MonolithDAO Token.sol
562    * @param _spender The address which will spend the funds.
563    * @param _addedValue The amount of tokens to increase the allowance by.
564    */
565   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
566     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
567     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
568     return true;
569   }
570 
571   /**
572    * @dev Decrease the amount of tokens that an owner allowed to a spender.
573    *
574    * approve should be called when allowed[_spender] == 0. To decrement
575    * allowed value is better to use this function to avoid 2 calls (and wait until
576    * the first transaction is mined)
577    * From MonolithDAO Token.sol
578    * @param _spender The address which will spend the funds.
579    * @param _subtractedValue The amount of tokens to decrease the allowance by.
580    */
581   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
582     uint oldValue = allowed[msg.sender][_spender];
583     if (_subtractedValue > oldValue) {
584       allowed[msg.sender][_spender] = 0;
585     } else {
586       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
587     }
588     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
589     return true;
590   }
591 
592 }
593 
594 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
595 
596 /**
597  * @title Mintable token
598  * @dev Simple ERC20 Token example, with mintable token creation
599  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
600  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
601  */
602 contract MintableToken is StandardToken, Ownable {
603   event Mint(address indexed to, uint256 amount);
604   event MintFinished();
605 
606   bool public mintingFinished = false;
607 
608 
609   modifier canMint() {
610     require(!mintingFinished);
611     _;
612   }
613 
614   /**
615    * @dev Function to mint tokens
616    * @param _to The address that will receive the minted tokens.
617    * @param _amount The amount of tokens to mint.
618    * @return A boolean that indicates if the operation was successful.
619    */
620   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
621     totalSupply_ = totalSupply_.add(_amount);
622     balances[_to] = balances[_to].add(_amount);
623     emit Mint(_to, _amount);
624     emit Transfer(address(0), _to, _amount);
625     return true;
626   }
627 
628   /**
629    * @dev Function to stop minting new tokens.
630    * @return True if the operation was successful.
631    */
632   function finishMinting() onlyOwner canMint public returns (bool) {
633     mintingFinished = true;
634     emit MintFinished();
635     return true;
636   }
637 }
638 
639 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
640 
641 /**
642  * @title Capped token
643  * @dev Mintable token with a token cap.
644  */
645 contract CappedToken is MintableToken {
646 
647   uint256 public cap;
648 
649   function CappedToken(uint256 _cap) public {
650     require(_cap > 0);
651     cap = _cap;
652   }
653 
654   /**
655    * @dev Function to mint tokens
656    * @param _to The address that will receive the minted tokens.
657    * @param _amount The amount of tokens to mint.
658    * @return A boolean that indicates if the operation was successful.
659    */
660   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
661     require(totalSupply_.add(_amount) <= cap);
662 
663     return super.mint(_to, _amount);
664   }
665 
666 }
667 
668 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
669 
670 /**
671  * @title Pausable token
672  * @dev StandardToken modified with pausable transfers.
673  **/
674 contract PausableToken is StandardToken, Pausable {
675 
676   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
677     return super.transfer(_to, _value);
678   }
679 
680   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
681     return super.transferFrom(_from, _to, _value);
682   }
683 
684   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
685     return super.approve(_spender, _value);
686   }
687 
688   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
689     return super.increaseApproval(_spender, _addedValue);
690   }
691 
692   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
693     return super.decreaseApproval(_spender, _subtractedValue);
694   }
695 }
696 
697 // File: contracts/CarryToken.sol
698 
699 // The Carry token and the tokensale contracts
700 // Copyright (C) 2018 Carry Protocol
701 //
702 // This program is free software: you can redistribute it and/or modify
703 // it under the terms of the GNU General Public License as published by
704 // the Free Software Foundation, either version 3 of the License, or
705 // (at your option) any later version.
706 //
707 // This program is distributed in the hope that it will be useful,
708 // but WITHOUT ANY WARRANTY; without even the implied warranty of
709 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
710 // GNU General Public License for more details.
711 //
712 // You should have received a copy of the GNU General Public License
713 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
714 pragma solidity ^0.4.23;
715 
716 
717 
718 
719 contract CarryToken is PausableToken, CappedToken, BurnableToken {
720     string public name = "CarryToken";
721     string public symbol = "CRE";
722     uint8 public decimals = 18;
723 
724     // See also <https://carryprotocol.io/#section-token-distribution>.
725     //                10 billion <---------|   |-----------------> 10^18
726     uint256 constant TOTAL_CAP = 10000000000 * 1000000000000000000;
727 
728     // FIXME: Here we've wanted to use constructor() keyword instead,
729     // but solium/solhint lint softwares don't parse it properly as of
730     // April 2018.
731     function CarryToken() public CappedToken(TOTAL_CAP) {
732     }
733 }
734 
735 // File: contracts/CarryTokenCrowdsale.sol
736 
737 // The Carry token and the tokensale contracts
738 // Copyright (C) 2018 Carry Protocol
739 //
740 // This program is free software: you can redistribute it and/or modify
741 // it under the terms of the GNU General Public License as published by
742 // the Free Software Foundation, either version 3 of the License, or
743 // (at your option) any later version.
744 //
745 // This program is distributed in the hope that it will be useful,
746 // but WITHOUT ANY WARRANTY; without even the implied warranty of
747 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
748 // GNU General Public License for more details.
749 //
750 // You should have received a copy of the GNU General Public License
751 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
752 pragma solidity ^0.4.23;
753 
754 
755 
756 
757 
758 
759 /**
760  * @title CarryTokenCrowdsale
761  * @dev The common base contract for both sales: the Carry token presale,
762  * and the Carry token public crowdsale.
763  */
764 contract CarryTokenCrowdsale is WhitelistedCrowdsale, CappedCrowdsale, Pausable {
765     using SafeMath for uint256;
766 
767     uint256 constant maxGasPrice = 40000000000;  // 40 gwei
768 
769     // Individual min and max purchases.
770     uint256 public individualMinPurchaseWei;
771     uint256 public individualMaxCapWei;
772 
773     mapping(address => uint256) public contributions;
774 
775     // FIXME: Here we've wanted to use constructor() keyword instead,
776     // but solium/solhint lint softwares don't parse it properly as of
777     // April 2018.
778     function CarryTokenCrowdsale(
779         address _wallet,
780         CarryToken _token,
781         uint256 _rate,
782         uint256 _cap,
783         uint256 _individualMinPurchaseWei,
784         uint256 _individualMaxCapWei
785     ) public CappedCrowdsale(_cap) Crowdsale(_rate, _wallet, _token) {
786         individualMinPurchaseWei = _individualMinPurchaseWei;
787         individualMaxCapWei = _individualMaxCapWei;
788     }
789 
790     function _preValidatePurchase(
791         address _beneficiary,
792         uint256 _weiAmount
793     ) internal whenNotPaused {
794         // Prevent gas war among purchasers.
795         require(tx.gasprice <= maxGasPrice);
796 
797         super._preValidatePurchase(_beneficiary, _weiAmount);
798         uint256 contribution = contributions[_beneficiary];
799         uint256 contributionAfterPurchase = contribution.add(_weiAmount);
800 
801         // If a contributor already has purchased a minimum amount, say 0.1 ETH,
802         // then they can purchase once again with less than a minimum amount,
803         // say 0.01 ETH, because they have already satisfied the minimum
804         // purchase.
805         require(contributionAfterPurchase >= individualMinPurchaseWei);
806 
807         require(contributionAfterPurchase <= individualMaxCapWei);
808     }
809 
810     function _updatePurchasingState(
811         address _beneficiary,
812         uint256 _weiAmount
813     ) internal {
814         super._updatePurchasingState(_beneficiary, _weiAmount);
815         contributions[_beneficiary] = contributions[_beneficiary].add(
816             _weiAmount
817         );
818     }
819 }
820 
821 // File: contracts/GradualDeliveryCrowdsale.sol
822 
823 // The Carry token and the tokensale contracts
824 // Copyright (C) 2018 Carry Protocol
825 //
826 // This program is free software: you can redistribute it and/or modify
827 // it under the terms of the GNU General Public License as published by
828 // the Free Software Foundation, either version 3 of the License, or
829 // (at your option) any later version.
830 //
831 // This program is distributed in the hope that it will be useful,
832 // but WITHOUT ANY WARRANTY; without even the implied warranty of
833 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
834 // GNU General Public License for more details.
835 //
836 // You should have received a copy of the GNU General Public License
837 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
838 pragma solidity ^0.4.23;
839 
840 
841 
842 
843 
844 /**
845  * @title GradualDeliveryCrowdsale
846  * @dev Crowdsale that does not deliver tokens to a beneficiary immediately
847  * after they have just purchased, but instead partially delivers tokens through
848  * several times when the contract owner calls deliverTokensInRatio() method.
849  * Note that it also provides methods to selectively refund some purchases.
850  */
851 contract GradualDeliveryCrowdsale is Crowdsale, Ownable {
852     using SafeMath for uint;
853     using SafeMath for uint256;
854 
855     mapping(address => uint256) public balances;
856     address[] beneficiaries;
857     mapping(address => uint256) public refundedDeposits;
858 
859     event TokenDelivered(address indexed beneficiary, uint256 tokenAmount);
860     event RefundDeposited(
861         address indexed beneficiary,
862         uint256 tokenAmount,
863         uint256 weiAmount
864     );
865     event Refunded(
866         address indexed beneficiary,
867         address indexed receiver,
868         uint256 weiAmount
869     );
870 
871     /**
872      * @dev Deliver only the given ratio of tokens to the beneficiaries.
873      * For example, where there are two beneficiaries of each balance 90 CRE and
874      * 60 CRE, deliverTokensInRatio(1, 3) delivers each 30 CRE and 20 CRE to
875      * them.  In the similar way, deliverTokensInRatio(1, 1) delivers
876      * their entire tokens.
877      */
878     function deliverTokensInRatio(
879         uint256 _numerator,
880         uint256 _denominator
881     ) external onlyOwner {
882         _deliverTokensInRatio(
883             _numerator,
884             _denominator,
885             0,
886             beneficiaries.length
887         );
888     }
889 
890     /**
891      * @dev It's mostly same to deliverTokensInRatio(), except it processes
892      * only a particular range of the list of beneficiaries.
893      */
894     function deliverTokensInRatioOfRange(
895         uint256 _numerator,
896         uint256 _denominator,
897         uint _startIndex,
898         uint _endIndex
899     ) external onlyOwner {
900         require(_startIndex < _endIndex);
901         _deliverTokensInRatio(_numerator, _denominator, _startIndex, _endIndex);
902     }
903 
904     function _deliverTokensInRatio(
905         uint256 _numerator,
906         uint256 _denominator,
907         uint _startIndex,
908         uint _endIndex
909     ) internal {
910         require(_denominator > 0);
911         require(_numerator <= _denominator);
912         uint endIndex = _endIndex;
913         if (endIndex > beneficiaries.length) {
914             endIndex = beneficiaries.length;
915         }
916         for (uint i = _startIndex; i < endIndex; i = i.add(1)) {
917             address beneficiary = beneficiaries[i];
918             uint256 balance = balances[beneficiary];
919             if (balance > 0) {
920                 uint256 amount = balance.mul(_numerator).div(_denominator);
921                 balances[beneficiary] = balance.sub(amount);
922                 _deliverTokens(beneficiary, amount);
923                 emit TokenDelivered(beneficiary, amount);
924             }
925         }
926     }
927 
928     function _processPurchase(
929         address _beneficiary,
930         uint256 _tokenAmount
931     ) internal {
932         if (_tokenAmount > 0) {
933             if (balances[_beneficiary] <= 0) {
934                 beneficiaries.push(_beneficiary);
935             }
936             balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
937         }
938     }
939     /**
940      * @dev Refund the given ether to a beneficiary.  It only can be called by
941      * either the contract owner or the wallet (i.e., Crowdsale.wallet) address.
942      * The only amount of the ether sent together in a transaction is refunded.
943      */
944     function depositRefund(address _beneficiary) public payable {
945         require(msg.sender == owner || msg.sender == wallet);
946         uint256 weiToRefund = msg.value;
947         require(weiToRefund <= weiRaised);
948         uint256 tokensToRefund = _getTokenAmount(weiToRefund);
949         uint256 tokenBalance = balances[_beneficiary];
950         require(tokenBalance >= tokensToRefund);
951         weiRaised = weiRaised.sub(weiToRefund);
952         balances[_beneficiary] = tokenBalance.sub(tokensToRefund);
953         refundedDeposits[_beneficiary] = refundedDeposits[_beneficiary].add(
954             weiToRefund
955         );
956         emit RefundDeposited(_beneficiary, tokensToRefund, weiToRefund);
957     }
958 
959     /**
960      * @dev Receive one's refunded ethers in the deposit.  It can be called by
961      * either the contract owner or the beneficiary of the refund.
962      * The deposited ether is sent to only the beneficiary regardless it is
963      * called by which address, either the contract owner or the beneficary.
964      * It usually can be systemically called together right after
965      * depositRefund() is called.
966      */
967     function receiveRefund(address _beneficiary) public {
968         require(msg.sender == owner || msg.sender == _beneficiary);
969         _transferRefund(_beneficiary, _beneficiary);
970     }
971 
972     /**
973      * @dev Similar to receiveRefund() except that it cannot be called by
974      * even the contract owner, but only the beneficiary of the refund.
975      * It also takes an additional parameter, a wallet address to receiver
976      * the deposited (refunded) ethers.
977      * The main purpose of this method is to receive the refunded ethers
978      * to the other address than the beneficiary address.  Usually after
979      * depositRefund() is called, receiveRefund() is immediately executed
980      * together by the automated system, but there could be cases that
981      * the the beneficiary address is a smart contract and it causes
982      * the transaction to transfer ethers in any reason.  In such cases,
983      * the deposit beneficiary need to "pull" his ethers to his another
984      * wallet address by calling this method.
985      */
986     function receiveRefundTo(address _beneficiary, address _wallet) public {
987         require(msg.sender == _beneficiary);
988         _transferRefund(_beneficiary, _wallet);
989     }
990 
991     function _transferRefund(address _beneficiary, address _wallet) internal {
992         uint256 depositedWeiAmount = refundedDeposits[_beneficiary];
993         require(depositedWeiAmount > 0);
994         refundedDeposits[_beneficiary] = 0;
995         _wallet.transfer(depositedWeiAmount);
996         emit Refunded(_beneficiary, _wallet, depositedWeiAmount);
997     }
998 }
999 
1000 // File: contracts/CarryTokenPresale.sol
1001 
1002 // The Carry token and the tokensale contracts
1003 // Copyright (C) 2018 Carry Protocol
1004 //
1005 // This program is free software: you can redistribute it and/or modify
1006 // it under the terms of the GNU General Public License as published by
1007 // the Free Software Foundation, either version 3 of the License, or
1008 // (at your option) any later version.
1009 //
1010 // This program is distributed in the hope that it will be useful,
1011 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1012 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1013 // GNU General Public License for more details.
1014 //
1015 // You should have received a copy of the GNU General Public License
1016 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
1017 pragma solidity ^0.4.23;
1018 
1019 
1020 
1021 /**
1022  * @title CarryTokenPresale
1023  * @dev The Carry token presale contract.
1024  */
1025 contract CarryTokenPresale is CarryTokenCrowdsale, GradualDeliveryCrowdsale {
1026     using SafeMath for uint256;
1027 
1028     // FIXME: Here we've wanted to use constructor() keyword instead,
1029     // but solium/solhint lint softwares don't parse it properly as of
1030     // April 2018.
1031     function CarryTokenPresale(
1032         address _wallet,
1033         CarryToken _token,
1034         uint256 _rate,
1035         uint256 _cap,
1036         uint256 _individualMinPurchaseWei,
1037         uint256 _individualMaxCapWei
1038     ) public CarryTokenCrowdsale(
1039         _wallet,
1040         _token,
1041         _rate,
1042         _cap,
1043         _individualMinPurchaseWei,
1044         _individualMaxCapWei
1045     ) {
1046     }
1047 
1048     function _transferRefund(address _beneficiary, address _wallet) internal {
1049         uint256 depositedWeiAmount = refundedDeposits[_beneficiary];
1050         super._transferRefund(_beneficiary, _wallet);
1051         contributions[_beneficiary] = contributions[_beneficiary].sub(
1052             depositedWeiAmount
1053         );
1054     }
1055 }