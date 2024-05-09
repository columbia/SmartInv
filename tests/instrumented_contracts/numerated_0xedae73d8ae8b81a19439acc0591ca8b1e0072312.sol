1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: zeppelin-solidity/contracts/token/MintableToken.sol
245 
246 /**
247  * @title Mintable token
248  * @dev Simple ERC20 Token example, with mintable token creation
249  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
250  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
251  */
252 
253 contract MintableToken is StandardToken, Ownable {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258 
259   modifier canMint() {
260     require(!mintingFinished);
261     _;
262   }
263 
264   /**
265    * @dev Function to mint tokens
266    * @param _to The address that will receive the minted tokens.
267    * @param _amount The amount of tokens to mint.
268    * @return A boolean that indicates if the operation was successful.
269    */
270   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
271     totalSupply = totalSupply.add(_amount);
272     balances[_to] = balances[_to].add(_amount);
273     Mint(_to, _amount);
274     Transfer(address(0), _to, _amount);
275     return true;
276   }
277 
278   /**
279    * @dev Function to stop minting new tokens.
280    * @return True if the operation was successful.
281    */
282   function finishMinting() onlyOwner canMint public returns (bool) {
283     mintingFinished = true;
284     MintFinished();
285     return true;
286   }
287 }
288 
289 // File: contracts/Crowdsale.sol
290 
291 /**
292  * @title Crowdsale
293  * @dev Crowdsale is a base contract for managing a token crowdsale.
294  * Crowdsales have a start and end timestamps, where investors can make
295  * token purchases and the crowdsale will assign them tokens based
296  * on a token per ETH rate. Funds collected are forwarded to a wallet
297  * as they arrive.
298 
299  * this contract is slightly modified from original zeppelin version to 
300  * enable testing mode and not forward to fundraiser address on every payment
301  */
302 contract Crowdsale {
303   using SafeMath for uint256;
304 
305   // The token being sold
306   MintableToken public token;
307 
308   // start and end timestamps where investments are allowed (both inclusive)
309   uint256 public startTime;
310   uint256 public endTime;
311 
312   // address where funds are collected
313   address public wallet;
314 
315   // how many token units a buyer gets per wei
316   uint256 public rate;
317 
318   // amount of raised money in wei
319   uint256 public weiRaised;
320 
321   /**
322    * event for token purchase logging
323    * @param purchaser who paid for the tokens
324    * @param beneficiary who got the tokens
325    * @param value weis paid for purchase
326    * @param amount amount of tokens purchased
327    */
328   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
329 
330 
331   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
332     require(_startTime >= now);
333     require(_endTime >= _startTime);
334     require(_rate > 0);
335     require(_wallet != address(0));
336 
337     token = createTokenContract();
338     startTime = _startTime;
339     endTime = _endTime;
340     rate = _rate;
341     wallet = _wallet;
342   }
343 
344   // creates the token to be sold.
345   // override this method to have crowdsale of a specific mintable token.
346   function createTokenContract() internal returns (MintableToken) {
347     return new MintableToken();
348   }
349 
350   // fallback function can be used to buy tokens
351   function () external payable {
352     buyTokens(msg.sender);
353   }
354 
355   // low level token purchase function
356   function buyTokens(address beneficiary) public payable {
357     require(beneficiary != address(0));
358     require(validPurchase());
359 
360     uint256 weiAmount = msg.value;
361 
362     // calculate token amount to be created
363     uint256 tokens = weiAmount.mul(rate);
364 
365     // update state
366     weiRaised = weiRaised.add(weiAmount);
367 
368     token.mint(beneficiary, tokens);
369     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
370   }
371 
372   // @return true if the transaction can buy tokens
373   function validPurchase() internal view returns (bool) {
374     bool withinPeriod = now >= startTime && now <= endTime;
375     bool nonZeroPurchase = msg.value != 0;
376     return withinPeriod && nonZeroPurchase;
377   }
378 
379   // @return true if crowdsale event has ended
380   function hasEnded() public view returns (bool) {
381     return now > endTime;
382   }
383 
384 }
385 
386 // File: contracts/CappedCrowdsale.sol
387 
388 /**
389  * @title CappedCrowdsale
390  * @dev Extension of Crowdsale with a max amount of funds raised
391 
392  * this contract was kept the same as the original zeppelin version
393  * only change was to inheriet the modified crowdsale instead of the
394  * original one
395  */
396 contract CappedCrowdsale is Crowdsale {
397   using SafeMath for uint256;
398 
399   uint256 public cap;
400 
401   function CappedCrowdsale(uint256 _cap) public {
402     require(_cap > 0);
403     cap = _cap;
404   }
405 
406   // overriding Crowdsale#validPurchase to add extra cap logic
407   // @return true if investors can buy at the moment
408   function validPurchase() internal view returns (bool) {
409     bool withinCap = weiRaised.add(msg.value) <= cap;
410     return super.validPurchase() && withinCap;
411   }
412 
413   // overriding Crowdsale#hasEnded to add cap logic
414   // @return true if crowdsale event has ended
415   function hasEnded() public view returns (bool) {
416     bool capReached = weiRaised >= cap;
417     return super.hasEnded() || capReached;
418   }
419 
420 }
421 
422 // File: zeppelin-solidity/contracts/lifecycle/TokenDestructible.sol
423 
424 /**
425  * @title TokenDestructible:
426  * @author Remco Bloemen <remco@2π.com>
427  * @dev Base contract that can be destroyed by owner. All funds in contract including
428  * listed tokens will be sent to the owner.
429  */
430 contract TokenDestructible is Ownable {
431 
432   function TokenDestructible() public payable { }
433 
434   /**
435    * @notice Terminate contract and refund to owner
436    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
437    refund.
438    * @notice The called token contracts could try to re-enter this contract. Only
439    supply token contracts you trust.
440    */
441   function destroy(address[] tokens) onlyOwner public {
442 
443     // Transfer tokens to owner
444     for(uint256 i = 0; i < tokens.length; i++) {
445       ERC20Basic token = ERC20Basic(tokens[i]);
446       uint256 balance = token.balanceOf(this);
447       token.transfer(owner, balance);
448     }
449 
450     // Transfer Eth to owner and terminate contract
451     selfdestruct(owner);
452   }
453 }
454 
455 // File: contracts/SpecialRatedCrowdsale.sol
456 
457 /**
458  * SpecialRatedCrowdsale contract
459 
460  * donors putting in more than a certain number of ethers will receive a special rate
461  */
462 contract SpecialRatedCrowdsale is Crowdsale, TokenDestructible {
463   mapping(address => uint) addressToSpecialRates;
464 
465   function SpecialRatedCrowdsale() { }
466 
467   function addToSpecialRatesMapping(address _address, uint specialRate) onlyOwner public {
468     addressToSpecialRates[_address] = specialRate;
469   }
470 
471   function removeFromSpecialRatesMapping(address _address) onlyOwner public {
472     delete addressToSpecialRates[_address];
473   }
474 
475   function querySpecialRateForAddress(address _address) onlyOwner public returns(uint) {
476     return addressToSpecialRates[_address];
477   }
478 
479   function buyTokens(address beneficiary) public payable {
480     if (addressToSpecialRates[beneficiary] != 0) {
481       rate = addressToSpecialRates[beneficiary];
482     }
483 
484     super.buyTokens(beneficiary);
485   }
486 }
487 
488 // File: contracts/ERC223ReceivingContract.sol
489 
490 /**
491  * @title Contract that will work with ERC223 tokens.
492 **/
493  
494 contract ERC223ReceivingContract { 
495 
496   /**
497     * @dev Standard ERC223 function that will handle incoming token transfers.
498     *
499     * @param _from  Token sender address.
500     * @param _value Amount of tokens.
501     * @param _data  Transaction metadata.
502   */
503   function tokenFallback(address _from, uint _value, bytes _data);
504 
505 }
506 
507 // File: contracts/ERC223.sol
508 
509 contract ERC223 is BasicToken {
510 
511   function transfer(address _to, uint _value, bytes _data) public returns (bool) {
512     super.transfer(_to, _value);
513 
514     // Standard function transfer similar to ERC20 transfer with no _data .
515     // Added due to backwards compatibility reasons .
516     uint codeLength;
517 
518     assembly {
519       // Retrieve the size of the code on target address, this needs assembly .
520       codeLength := extcodesize(_to)
521     }
522     if (codeLength > 0) {
523       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
524       receiver.tokenFallback(msg.sender, _value, _data);
525     }
526     Transfer(msg.sender, _to, _value, _data);
527   }
528 
529   function transfer(address _to, uint _value) public returns (bool) {
530     super.transfer(_to, _value);
531 
532     // Standard function transfer similar to ERC20 transfer with no _data .
533     // Added due to backwards compatibility reasons .
534     uint codeLength;
535     bytes memory empty;
536 
537     assembly {
538       // Retrieve the size of the code on target address, this needs assembly .
539       codeLength := extcodesize(_to)
540     }
541     if (codeLength > 0) {
542       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
543       receiver.tokenFallback(msg.sender, _value, empty);
544     }
545     Transfer(msg.sender, _to, _value, empty);
546   }
547 
548   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
549 }
550 
551 // File: zeppelin-solidity/contracts/token/CappedToken.sol
552 
553 /**
554  * @title Capped token
555  * @dev Mintable token with a token cap.
556  */
557 
558 contract CappedToken is MintableToken {
559 
560   uint256 public cap;
561 
562   function CappedToken(uint256 _cap) public {
563     require(_cap > 0);
564     cap = _cap;
565   }
566 
567   /**
568    * @dev Function to mint tokens
569    * @param _to The address that will receive the minted tokens.
570    * @param _amount The amount of tokens to mint.
571    * @return A boolean that indicates if the operation was successful.
572    */
573   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
574     require(totalSupply.add(_amount) <= cap);
575 
576     return super.mint(_to, _amount);
577   }
578 
579 }
580 
581 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
582 
583 /**
584  * @title Pausable
585  * @dev Base contract which allows children to implement an emergency stop mechanism.
586  */
587 contract Pausable is Ownable {
588   event Pause();
589   event Unpause();
590 
591   bool public paused = false;
592 
593 
594   /**
595    * @dev Modifier to make a function callable only when the contract is not paused.
596    */
597   modifier whenNotPaused() {
598     require(!paused);
599     _;
600   }
601 
602   /**
603    * @dev Modifier to make a function callable only when the contract is paused.
604    */
605   modifier whenPaused() {
606     require(paused);
607     _;
608   }
609 
610   /**
611    * @dev called by the owner to pause, triggers stopped state
612    */
613   function pause() onlyOwner whenNotPaused public {
614     paused = true;
615     Pause();
616   }
617 
618   /**
619    * @dev called by the owner to unpause, returns to normal state
620    */
621   function unpause() onlyOwner whenPaused public {
622     paused = false;
623     Unpause();
624   }
625 }
626 
627 // File: zeppelin-solidity/contracts/token/PausableToken.sol
628 
629 /**
630  * @title Pausable token
631  *
632  * @dev StandardToken modified with pausable transfers.
633  **/
634 
635 contract PausableToken is StandardToken, Pausable {
636 
637   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
638     return super.transfer(_to, _value);
639   }
640 
641   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
642     return super.transferFrom(_from, _to, _value);
643   }
644 
645   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
646     return super.approve(_spender, _value);
647   }
648 
649   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
650     return super.increaseApproval(_spender, _addedValue);
651   }
652 
653   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
654     return super.decreaseApproval(_spender, _subtractedValue);
655   }
656 }
657 
658 // File: contracts/YoloToken.sol
659 
660 /** @title YoloToken - Token for the UltraYOLO lottery protocol
661   * @author UltraYOLO
662 
663   The totalSupply for YOLO token will be 4 Billion
664 **/
665 
666 contract YoloToken is CappedToken, PausableToken, ERC223 {
667 
668   string public constant name     = "Yolo";
669   string public constant symbol   = "YOLO";
670   uint   public constant decimals = 18;
671 
672   function YoloToken(uint256 _totalSupply) CappedToken(_totalSupply) {
673     paused = true;
674   }
675 
676 }
677 
678 // File: contracts/YoloTokenPresaleRound2.sol
679 
680 /**
681  * @title YoloTokenPresaleRound2
682  * @author UltraYOLO
683  
684  * Based on widely-adopted OpenZepplin project
685  * A total of 200,000,000 YOLO tokens will be sold during presale at a discount rate of 25%
686  * Supporters who purchase more than 10 ETH worth of YOLO token will have a discount of 35%
687  * Total supply of presale + presale_round_2 + mainsale will be 2,000,000,000
688 */
689 contract YoloTokenPresaleRound2 is SpecialRatedCrowdsale, CappedCrowdsale, Pausable {
690   using SafeMath for uint256;
691 
692   uint256 public rateTierHigher;
693   uint256 public rateTierNormal;
694 
695   function YoloTokenPresaleRound2 (uint256 _cap, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,
696   	address _tokenAddress) 
697   CappedCrowdsale(_cap)
698   Crowdsale(_startTime, _endTime, _rate, _wallet)
699   {
700     token = YoloToken(_tokenAddress);
701     rateTierHigher = _rate.mul(27).div(20);
702     rateTierNormal = _rate.mul(5).div(4);
703   }
704 
705   function () external payable {
706     buyTokens(msg.sender);
707   }
708 
709   function buyTokens(address beneficiary) public payable {
710     require(validPurchase());
711     if (msg.value >= 10 ether) {
712       rate = rateTierHigher;
713     } else {
714       rate = rateTierNormal;
715     }
716     super.buyTokens(beneficiary);
717   }
718 
719   function validPurchase() internal view returns (bool) {
720     return super.validPurchase() && !paused;
721   }
722 
723   function setCap(uint256 _cap) onlyOwner public {
724     cap = _cap;
725   }
726 
727   function setStartTime(uint256 _startTime) onlyOwner public {
728     startTime = _startTime;
729   }
730 
731   function setEndTime(uint256 _endTime) onlyOwner public {
732     endTime = _endTime;
733   }
734 
735   function setRate(uint256 _rate) onlyOwner public {
736     rate = _rate;
737     rateTierHigher = _rate.mul(27).div(20);
738     rateTierNormal = _rate.mul(5).div(4);
739   }
740 
741   function setWallet(address _wallet) onlyOwner public {
742     wallet = _wallet;
743   }
744 
745   function withdrawFunds(uint256 amount) onlyOwner public {
746     wallet.transfer(amount);
747   }
748 
749   function resetTokenOwnership() onlyOwner public {
750     token.transferOwnership(owner);
751   }
752 
753 }