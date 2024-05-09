1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (a == 0) {
80       return 0;
81     }
82 
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183   function allowance(address owner, address spender)
184     public view returns (uint256);
185 
186   function transferFrom(address from, address to, uint256 value)
187     public returns (bool);
188 
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(
191     address indexed owner,
192     address indexed spender,
193     uint256 value
194   );
195 }
196 
197 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(
218     address _from,
219     address _to,
220     uint256 _value
221   )
222     public
223     returns (bool)
224   {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     emit Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    *
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) public returns (bool) {
247     allowed[msg.sender][_spender] = _value;
248     emit Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(
259     address _owner,
260     address _spender
261    )
262     public
263     view
264     returns (uint256)
265   {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(
280     address _spender,
281     uint _addedValue
282   )
283     public
284     returns (bool)
285   {
286     allowed[msg.sender][_spender] = (
287       allowed[msg.sender][_spender].add(_addedValue));
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    *
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue > oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   modifier hasMintPermission() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(
353     address _to,
354     uint256 _amount
355   )
356     hasMintPermission
357     canMint
358     public
359     returns (bool)
360   {
361     totalSupply_ = totalSupply_.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     emit Mint(_to, _amount);
364     emit Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() onlyOwner canMint public returns (bool) {
373     mintingFinished = true;
374     emit MintFinished();
375     return true;
376   }
377 }
378 
379 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
380 
381 /**
382  * @title Crowdsale
383  * @dev Crowdsale is a base contract for managing a token crowdsale,
384  * allowing investors to purchase tokens with ether. This contract implements
385  * such functionality in its most fundamental form and can be extended to provide additional
386  * functionality and/or custom behavior.
387  * The external interface represents the basic interface for purchasing tokens, and conform
388  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
389  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
390  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
391  * behavior.
392  */
393 contract Crowdsale {
394   using SafeMath for uint256;
395 
396   // The token being sold
397   ERC20 public token;
398 
399   // Address where funds are collected
400   address public wallet;
401 
402   // How many token units a buyer gets per wei.
403   // The rate is the conversion between wei and the smallest and indivisible token unit.
404   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
405   // 1 wei will give you 1 unit, or 0.001 TOK.
406   uint256 public rate;
407 
408   // Amount of wei raised
409   uint256 public weiRaised;
410 
411   /**
412    * Event for token purchase logging
413    * @param purchaser who paid for the tokens
414    * @param beneficiary who got the tokens
415    * @param value weis paid for purchase
416    * @param amount amount of tokens purchased
417    */
418   event TokenPurchase(
419     address indexed purchaser,
420     address indexed beneficiary,
421     uint256 value,
422     uint256 amount
423   );
424 
425   /**
426    * @param _rate Number of token units a buyer gets per wei
427    * @param _wallet Address where collected funds will be forwarded to
428    * @param _token Address of the token being sold
429    */
430   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
431     require(_rate > 0);
432     require(_wallet != address(0));
433     require(_token != address(0));
434 
435     rate = _rate;
436     wallet = _wallet;
437     token = _token;
438   }
439 
440   // -----------------------------------------
441   // Crowdsale external interface
442   // -----------------------------------------
443 
444   /**
445    * @dev fallback function ***DO NOT OVERRIDE***
446    */
447   function () external payable {
448     buyTokens(msg.sender);
449   }
450 
451   /**
452    * @dev low level token purchase ***DO NOT OVERRIDE***
453    * @param _beneficiary Address performing the token purchase
454    */
455   function buyTokens(address _beneficiary) public payable {
456 
457     uint256 weiAmount = msg.value;
458     _preValidatePurchase(_beneficiary, weiAmount);
459 
460     // calculate token amount to be created
461     uint256 tokens = _getTokenAmount(weiAmount);
462 
463     // update state
464     weiRaised = weiRaised.add(weiAmount);
465 
466     _processPurchase(_beneficiary, tokens);
467     emit TokenPurchase(
468       msg.sender,
469       _beneficiary,
470       weiAmount,
471       tokens
472     );
473 
474     _updatePurchasingState(_beneficiary, weiAmount);
475 
476     _forwardFunds();
477     _postValidatePurchase(_beneficiary, weiAmount);
478   }
479 
480   // -----------------------------------------
481   // Internal interface (extensible)
482   // -----------------------------------------
483 
484   /**
485    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
486    * @param _beneficiary Address performing the token purchase
487    * @param _weiAmount Value in wei involved in the purchase
488    */
489   function _preValidatePurchase(
490     address _beneficiary,
491     uint256 _weiAmount
492   )
493     internal
494   {
495     require(_beneficiary != address(0));
496     require(_weiAmount != 0);
497   }
498 
499   /**
500    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
501    * @param _beneficiary Address performing the token purchase
502    * @param _weiAmount Value in wei involved in the purchase
503    */
504   function _postValidatePurchase(
505     address _beneficiary,
506     uint256 _weiAmount
507   )
508     internal
509   {
510     // optional override
511   }
512 
513   /**
514    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
515    * @param _beneficiary Address performing the token purchase
516    * @param _tokenAmount Number of tokens to be emitted
517    */
518   function _deliverTokens(
519     address _beneficiary,
520     uint256 _tokenAmount
521   )
522     internal
523   {
524     token.transfer(_beneficiary, _tokenAmount);
525   }
526 
527   /**
528    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
529    * @param _beneficiary Address receiving the tokens
530    * @param _tokenAmount Number of tokens to be purchased
531    */
532   function _processPurchase(
533     address _beneficiary,
534     uint256 _tokenAmount
535   )
536     internal
537   {
538     _deliverTokens(_beneficiary, _tokenAmount);
539   }
540 
541   /**
542    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
543    * @param _beneficiary Address receiving the tokens
544    * @param _weiAmount Value in wei involved in the purchase
545    */
546   function _updatePurchasingState(
547     address _beneficiary,
548     uint256 _weiAmount
549   )
550     internal
551   {
552     // optional override
553   }
554 
555   /**
556    * @dev Override to extend the way in which ether is converted to tokens.
557    * @param _weiAmount Value in wei to be converted into tokens
558    * @return Number of tokens that can be purchased with the specified _weiAmount
559    */
560   function _getTokenAmount(uint256 _weiAmount)
561     internal view returns (uint256)
562   {
563     return _weiAmount.mul(rate);
564   }
565 
566   /**
567    * @dev Determines how ETH is stored/forwarded on purchases.
568    */
569   function _forwardFunds() internal {
570     wallet.transfer(msg.value);
571   }
572 }
573 
574 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
575 
576 /**
577  * @title MintedCrowdsale
578  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
579  * Token ownership should be transferred to MintedCrowdsale for minting.
580  */
581 contract MintedCrowdsale is Crowdsale {
582 
583   /**
584    * @dev Overrides delivery by minting tokens upon purchase.
585    * @param _beneficiary Token purchaser
586    * @param _tokenAmount Number of tokens to be minted
587    */
588   function _deliverTokens(
589     address _beneficiary,
590     uint256 _tokenAmount
591   )
592     internal
593   {
594     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
595   }
596 }
597 
598 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
599 
600 /**
601  * @title TimedCrowdsale
602  * @dev Crowdsale accepting contributions only within a time frame.
603  */
604 contract TimedCrowdsale is Crowdsale {
605   using SafeMath for uint256;
606 
607   uint256 public openingTime;
608   uint256 public closingTime;
609 
610   /**
611    * @dev Reverts if not in crowdsale time range.
612    */
613   modifier onlyWhileOpen {
614     // solium-disable-next-line security/no-block-members
615     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
616     _;
617   }
618 
619   /**
620    * @dev Constructor, takes crowdsale opening and closing times.
621    * @param _openingTime Crowdsale opening time
622    * @param _closingTime Crowdsale closing time
623    */
624   constructor(uint256 _openingTime, uint256 _closingTime) public {
625     // solium-disable-next-line security/no-block-members
626     require(_openingTime >= block.timestamp);
627     require(_closingTime >= _openingTime);
628 
629     openingTime = _openingTime;
630     closingTime = _closingTime;
631   }
632 
633   /**
634    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
635    * @return Whether crowdsale period has elapsed
636    */
637   function hasClosed() public view returns (bool) {
638     // solium-disable-next-line security/no-block-members
639     return block.timestamp > closingTime;
640   }
641 
642   /**
643    * @dev Extend parent behavior requiring to be within contributing period
644    * @param _beneficiary Token purchaser
645    * @param _weiAmount Amount of wei contributed
646    */
647   function _preValidatePurchase(
648     address _beneficiary,
649     uint256 _weiAmount
650   )
651     internal
652     onlyWhileOpen
653   {
654     super._preValidatePurchase(_beneficiary, _weiAmount);
655   }
656 
657 }
658 
659 // File: contracts/Tokensale.sol
660 
661 contract Tokensale is MintedCrowdsale, TimedCrowdsale {
662     constructor(
663         uint256 _start,
664         uint256 _end,
665         uint256 _rate,
666         address _wallet,
667         MintableToken _token
668     )
669         public
670         Crowdsale(_rate, _wallet, _token)
671         TimedCrowdsale(_start, _end)
672     {
673     }
674 }