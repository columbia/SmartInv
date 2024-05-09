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
321   // flag to signal testing mode and transactions are valid regardless of times
322   bool public isTesting;
323 
324   /**
325    * event for token purchase logging
326    * @param purchaser who paid for the tokens
327    * @param beneficiary who got the tokens
328    * @param value weis paid for purchase
329    * @param amount amount of tokens purchased
330    */
331   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
332 
333 
334   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
335     require(_startTime >= now);
336     require(_endTime >= _startTime);
337     require(_rate > 0);
338     require(_wallet != address(0));
339 
340     token = createTokenContract();
341     startTime = _startTime;
342     endTime = _endTime;
343     rate = _rate;
344     wallet = _wallet;
345   }
346 
347   // creates the token to be sold.
348   // override this method to have crowdsale of a specific mintable token.
349   function createTokenContract() internal returns (MintableToken) {
350     return new MintableToken();
351   }
352 
353 
354   // fallback function can be used to buy tokens
355   function () external payable {
356     buyTokens(msg.sender);
357   }
358 
359   // low level token purchase function
360   function buyTokens(address beneficiary) public payable {
361     require(beneficiary != address(0));
362     require(validPurchase());
363 
364     uint256 weiAmount = msg.value;
365 
366     // calculate token amount to be created
367     uint256 tokens = weiAmount.mul(rate);
368 
369     // update state
370     weiRaised = weiRaised.add(weiAmount);
371 
372     token.mint(beneficiary, tokens);
373     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
374   }
375 
376   // @return true if the transaction can buy tokens
377   function validPurchase() internal view returns (bool) {
378     bool withinPeriod = now >= startTime && now <= endTime;
379     bool nonZeroPurchase = msg.value != 0;
380     return (isTesting || withinPeriod) && nonZeroPurchase;
381   }
382 
383   // @return true if crowdsale event has ended
384   function hasEnded() public view returns (bool) {
385     return now > endTime;
386   }
387 
388 }
389 
390 // File: contracts/CappedCrowdsale.sol
391 
392 /**
393  * @title CappedCrowdsale
394  * @dev Extension of Crowdsale with a max amount of funds raised
395 
396  * this contract was kept the same as the original zeppelin version
397  * only change was to inheriet the modified crowdsale instead of the
398  * original one
399  */
400 contract CappedCrowdsale is Crowdsale {
401   using SafeMath for uint256;
402 
403   uint256 public cap;
404 
405   function CappedCrowdsale(uint256 _cap) public {
406     require(_cap > 0);
407     cap = _cap;
408   }
409 
410   // overriding Crowdsale#validPurchase to add extra cap logic
411   // @return true if investors can buy at the moment
412   function validPurchase() internal view returns (bool) {
413     bool withinCap = weiRaised.add(msg.value) <= cap;
414     return super.validPurchase() && withinCap;
415   }
416 
417   // overriding Crowdsale#hasEnded to add cap logic
418   // @return true if crowdsale event has ended
419   function hasEnded() public view returns (bool) {
420     bool capReached = weiRaised >= cap;
421     return super.hasEnded() || capReached;
422   }
423 
424 }
425 
426 // File: contracts/ERC223ReceivingContract.sol
427 
428 /**
429  * @title Contract that will work with ERC223 tokens.
430 **/
431  
432 contract ERC223ReceivingContract { 
433 
434   /**
435     * @dev Standard ERC223 function that will handle incoming token transfers.
436     *
437     * @param _from  Token sender address.
438     * @param _value Amount of tokens.
439     * @param _data  Transaction metadata.
440   */
441   function tokenFallback(address _from, uint _value, bytes _data);
442 
443 }
444 
445 // File: contracts/ERC223.sol
446 
447 contract ERC223 is BasicToken {
448 
449   function transfer(address _to, uint _value, bytes _data) public returns (bool) {
450     super.transfer(_to, _value);
451 
452     // Standard function transfer similar to ERC20 transfer with no _data .
453     // Added due to backwards compatibility reasons .
454     uint codeLength;
455 
456     assembly {
457       // Retrieve the size of the code on target address, this needs assembly .
458       codeLength := extcodesize(_to)
459     }
460     if (codeLength > 0) {
461       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
462       receiver.tokenFallback(msg.sender, _value, _data);
463     }
464     Transfer(msg.sender, _to, _value, _data);
465   }
466 
467   function transfer(address _to, uint _value) public returns (bool) {
468     super.transfer(_to, _value);
469 
470     // Standard function transfer similar to ERC20 transfer with no _data .
471     // Added due to backwards compatibility reasons .
472     uint codeLength;
473     bytes memory empty;
474 
475     assembly {
476       // Retrieve the size of the code on target address, this needs assembly .
477       codeLength := extcodesize(_to)
478     }
479     if (codeLength > 0) {
480       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
481       receiver.tokenFallback(msg.sender, _value, empty);
482     }
483     Transfer(msg.sender, _to, _value, empty);
484   }
485 
486   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
487 }
488 
489 // File: zeppelin-solidity/contracts/token/CappedToken.sol
490 
491 /**
492  * @title Capped token
493  * @dev Mintable token with a token cap.
494  */
495 
496 contract CappedToken is MintableToken {
497 
498   uint256 public cap;
499 
500   function CappedToken(uint256 _cap) public {
501     require(_cap > 0);
502     cap = _cap;
503   }
504 
505   /**
506    * @dev Function to mint tokens
507    * @param _to The address that will receive the minted tokens.
508    * @param _amount The amount of tokens to mint.
509    * @return A boolean that indicates if the operation was successful.
510    */
511   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
512     require(totalSupply.add(_amount) <= cap);
513 
514     return super.mint(_to, _amount);
515   }
516 
517 }
518 
519 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
520 
521 /**
522  * @title Pausable
523  * @dev Base contract which allows children to implement an emergency stop mechanism.
524  */
525 contract Pausable is Ownable {
526   event Pause();
527   event Unpause();
528 
529   bool public paused = false;
530 
531 
532   /**
533    * @dev Modifier to make a function callable only when the contract is not paused.
534    */
535   modifier whenNotPaused() {
536     require(!paused);
537     _;
538   }
539 
540   /**
541    * @dev Modifier to make a function callable only when the contract is paused.
542    */
543   modifier whenPaused() {
544     require(paused);
545     _;
546   }
547 
548   /**
549    * @dev called by the owner to pause, triggers stopped state
550    */
551   function pause() onlyOwner whenNotPaused public {
552     paused = true;
553     Pause();
554   }
555 
556   /**
557    * @dev called by the owner to unpause, returns to normal state
558    */
559   function unpause() onlyOwner whenPaused public {
560     paused = false;
561     Unpause();
562   }
563 }
564 
565 // File: zeppelin-solidity/contracts/token/PausableToken.sol
566 
567 /**
568  * @title Pausable token
569  *
570  * @dev StandardToken modified with pausable transfers.
571  **/
572 
573 contract PausableToken is StandardToken, Pausable {
574 
575   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
576     return super.transfer(_to, _value);
577   }
578 
579   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
580     return super.transferFrom(_from, _to, _value);
581   }
582 
583   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
584     return super.approve(_spender, _value);
585   }
586 
587   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
588     return super.increaseApproval(_spender, _addedValue);
589   }
590 
591   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
592     return super.decreaseApproval(_spender, _subtractedValue);
593   }
594 }
595 
596 // File: contracts/YoloToken.sol
597 
598 /** @title YoloToken - Token for the UltraYOLO lottery protocol
599   * @author UltraYOLO
600 
601   The totalSupply for YOLO token will be 4 Billion
602 **/
603 
604 contract YoloToken is CappedToken, PausableToken, ERC223 {
605 
606   string public constant name     = "Yolo";
607   string public constant symbol   = "YOLO";
608   uint   public constant decimals = 18;
609 
610   function YoloToken(uint256 _totalSupply) CappedToken(_totalSupply) {
611     paused = true;
612   }
613 
614 }
615 
616 // File: zeppelin-solidity/contracts/lifecycle/TokenDestructible.sol
617 
618 /**
619  * @title TokenDestructible:
620  * @author Remco Bloemen <remco@2π.com>
621  * @dev Base contract that can be destroyed by owner. All funds in contract including
622  * listed tokens will be sent to the owner.
623  */
624 contract TokenDestructible is Ownable {
625 
626   function TokenDestructible() public payable { }
627 
628   /**
629    * @notice Terminate contract and refund to owner
630    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
631    refund.
632    * @notice The called token contracts could try to re-enter this contract. Only
633    supply token contracts you trust.
634    */
635   function destroy(address[] tokens) onlyOwner public {
636 
637     // Transfer tokens to owner
638     for(uint256 i = 0; i < tokens.length; i++) {
639       ERC20Basic token = ERC20Basic(tokens[i]);
640       uint256 balance = token.balanceOf(this);
641       token.transfer(owner, balance);
642     }
643 
644     // Transfer Eth to owner and terminate contract
645     selfdestruct(owner);
646   }
647 }
648 
649 // File: contracts/YoloTokenPresale.sol
650 
651 /**
652  * @title YoloTokenPresale
653  * @author UltraYOLO
654  
655  * Based on widely-adopted OpenZepplin project
656  * A total of 200,000,000 YOLO tokens will be sold during presale at a discount rate of 25% ($0.00375)
657  * Supporters who purchase more than 25 ETH worth of YOLO token will have a discount of 35%
658  * Total supply of presale + mainsale will be 2,000,000,000
659 */
660 
661 contract YoloTokenPresale is CappedCrowdsale, Pausable, TokenDestructible {
662   using SafeMath for uint256;
663 
664   uint256 public rateTierHigher;
665   uint256 public rateTierNormal;
666 
667   function YoloTokenPresale (uint256 _cap, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,
668   	address _tokenAddress) 
669   	CappedCrowdsale(_cap)
670   	Crowdsale(_startTime, _endTime, _rate, _wallet)
671   {
672     token = YoloToken(_tokenAddress);
673     rateTierHigher = _rate.mul(27).div(20);
674     rateTierNormal = _rate.mul(5).div(4);
675   }
676 
677   function () external payable {
678     buyTokens(msg.sender);
679   }
680 
681   function buyTokens(address beneficiary) public payable {
682     require(validPurchase());
683 
684     if (msg.value >= 25 ether) {
685       rate = rateTierHigher;
686     } else {
687       rate = rateTierNormal;
688     }
689     super.buyTokens(beneficiary);
690   }
691 
692   function validPurchase() internal view returns (bool) {
693     return super.validPurchase() && !paused;
694   }
695 
696   function setCap(uint256 _cap) onlyOwner public {
697     cap = _cap;
698   }
699 
700   function setStartTime(uint256 _startTime) onlyOwner public {
701     startTime = _startTime;
702   }
703 
704   function setEndTime(uint256 _endTime) onlyOwner public {
705     endTime = _endTime;
706   }
707 
708   function setRate(uint256 _rate) onlyOwner public {
709     rate = _rate;
710     rateTierHigher = _rate.mul(27).div(20);
711     rateTierNormal = _rate.mul(5).div(4);
712   }
713 
714   function setIsTesting(bool _isTesting) onlyOwner public {
715     isTesting = _isTesting;
716   }
717 
718   function setWallet(address _wallet) onlyOwner public {
719     wallet = _wallet;
720   }
721 
722   function withdrawFunds(uint256 amount) onlyOwner public {
723     wallet.transfer(amount);
724   }
725 
726   function resetTokenOwnership() onlyOwner public { 
727     token.transferOwnership(owner);
728   }
729 }