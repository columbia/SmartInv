1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address who) public view returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76   address public owner;
77 
78 
79   event OwnershipRenounced(address indexed previousOwner);
80   event OwnershipTransferred(
81     address indexed previousOwner,
82     address indexed newOwner
83   );
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   constructor() public {
91     owner = msg.sender;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    */
105   function renounceOwnership() public onlyOwner {
106     emit OwnershipRenounced(owner);
107     owner = address(0);
108   }
109 
110   /**
111    * @dev Allows the current owner to transfer control of the contract to a newOwner.
112    * @param _newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address _newOwner) public onlyOwner {
115     _transferOwnership(_newOwner);
116   }
117 
118   /**
119    * @dev Transfers control of the contract to a newOwner.
120    * @param _newOwner The address to transfer ownership to.
121    */
122   function _transferOwnership(address _newOwner) internal {
123     require(_newOwner != address(0));
124     emit OwnershipTransferred(owner, _newOwner);
125     owner = _newOwner;
126   }
127 }
128 
129 
130 
131 
132 contract Distributable {
133 
134   using SafeMath for uint256;
135 
136   bool public distributed;
137   //Not all actual addresses
138   address[] public partners = [
139   0xb68342f2f4dd35d93b88081b03a245f64331c95c,
140   0x16CCc1e68D2165fb411cE5dae3556f823249233e,
141   0x8E176EDA10b41FA072464C29Eb10CfbbF4adCd05, //Auditors Traning
142   0x7c387c57f055993c857067A0feF6E81884656Cb0, //Reserve
143   0x4F21c073A9B8C067818113829053b60A6f45a817, //Airdrop
144   0xcB4b6B7c4a72754dEb99bB72F1274129D9C0A109, //Alex
145   0x7BF84E0244c05A11c57984e8dF7CC6481b8f4258, //Adam
146   0x20D2F4Be237F4320386AaaefD42f68495C6A3E81, //JG
147   0x12BEA633B83aA15EfF99F68C2E7e14f2709802A9, //Rob S
148   0xC1a29a165faD532520204B480D519686B8CB845B, //Nick
149   0xf5f5Eb6Ab1411935b321042Fa02a433FcbD029AC, //Rob H
150   0xaBff978f03d5ca81B089C5A2Fc321fB8152DC8f1]; //Ed
151 
152   address[] public partnerFixedAmount = [
153   0xA482D998DA4d361A6511c6847562234077F09748,
154   0xFa92F80f8B9148aDFBacC66aA7bbE6e9F0a0CD0e
155   ];
156 
157   mapping(address => uint256) public percentages;
158   mapping(address => uint256) public fixedAmounts;
159 
160   constructor() public{
161     percentages[0xb68342f2f4dd35d93b88081b03a245f64331c95c] = 40;
162     percentages[0x16CCc1e68D2165fb411cE5dae3556f823249233e] = 5;
163     percentages[0x8E176EDA10b41FA072464C29Eb10CfbbF4adCd05] = 100; //Auditors Training
164     percentages[0x7c387c57f055993c857067A0feF6E81884656Cb0] = 50; //Reserve
165     percentages[0x4F21c073A9B8C067818113829053b60A6f45a817] = 10; //Airdrop
166 
167     percentages[0xcB4b6B7c4a72754dEb99bB72F1274129D9C0A109] = 20; //Alex
168     percentages[0x7BF84E0244c05A11c57984e8dF7CC6481b8f4258] = 20; //Adam
169     percentages[0x20D2F4Be237F4320386AaaefD42f68495C6A3E81] = 20; //JG
170     percentages[0x12BEA633B83aA15EfF99F68C2E7e14f2709802A9] = 20; //Rob S
171 
172     percentages[0xC1a29a165faD532520204B480D519686B8CB845B] = 30; //Nick
173     percentages[0xf5f5Eb6Ab1411935b321042Fa02a433FcbD029AC] = 30; //Rob H
174 
175     percentages[0xaBff978f03d5ca81B089C5A2Fc321fB8152DC8f1] = 52; //Ed
176 
177     fixedAmounts[0xA482D998DA4d361A6511c6847562234077F09748] = 886228 * 10**16;
178     fixedAmounts[0xFa92F80f8B9148aDFBacC66aA7bbE6e9F0a0CD0e] = 697 ether;
179   }
180 }
181 
182 
183 
184 
185 
186 
187 
188 
189 
190 
191 
192 /**
193  * @title ERC20 interface
194  * @dev see https://github.com/ethereum/EIPs/issues/20
195  */
196 contract ERC20 is ERC20Basic {
197   function allowance(address owner, address spender)
198     public view returns (uint256);
199 
200   function transferFrom(address from, address to, uint256 value)
201     public returns (bool);
202 
203   function approve(address spender, uint256 value) public returns (bool);
204   event Approval(
205     address indexed owner,
206     address indexed spender,
207     uint256 value
208   );
209 }
210 
211 
212 
213 
214 /**
215  * @title Crowdsale
216  * @dev Crowdsale is a base contract for managing a token crowdsale,
217  * allowing investors to purchase tokens with ether. This contract implements
218  * such functionality in its most fundamental form and can be extended to provide additional
219  * functionality and/or custom behavior.
220  * The external interface represents the basic interface for purchasing tokens, and conform
221  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
222  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
223  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
224  * behavior.
225  */
226 contract Crowdsale {
227   using SafeMath for uint256;
228 
229   // The token being sold
230   ERC20 public token;
231 
232   // Address where funds are collected
233   address public wallet;
234 
235   // How many token units a buyer gets per wei.
236   // The rate is the conversion between wei and the smallest and indivisible token unit.
237   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
238   // 1 wei will give you 1 unit, or 0.001 TOK.
239   uint256 public rate;
240 
241   // Amount of wei raised
242   uint256 public weiRaised;
243 
244   /**
245    * Event for token purchase logging
246    * @param purchaser who paid for the tokens
247    * @param beneficiary who got the tokens
248    * @param value weis paid for purchase
249    * @param amount amount of tokens purchased
250    */
251   event TokenPurchase(
252     address indexed purchaser,
253     address indexed beneficiary,
254     uint256 value,
255     uint256 amount
256   );
257 
258   /**
259    * @param _rate Number of token units a buyer gets per wei
260    * @param _wallet Address where collected funds will be forwarded to
261    * @param _token Address of the token being sold
262    */
263   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
264     require(_rate > 0);
265     require(_wallet != address(0));
266     require(_token != address(0));
267 
268     rate = _rate;
269     wallet = _wallet;
270     token = _token;
271   }
272 
273   // -----------------------------------------
274   // Crowdsale external interface
275   // -----------------------------------------
276 
277   /**
278    * @dev fallback function ***DO NOT OVERRIDE***
279    */
280   function () external payable {
281     buyTokens(msg.sender);
282   }
283 
284   /**
285    * @dev low level token purchase ***DO NOT OVERRIDE***
286    * @param _beneficiary Address performing the token purchase
287    */
288   function buyTokens(address _beneficiary) public payable {
289 
290     uint256 weiAmount = msg.value;
291     _preValidatePurchase(_beneficiary, weiAmount);
292 
293     // calculate token amount to be created
294     uint256 tokens = _getTokenAmount(weiAmount);
295 
296     // update state
297     weiRaised = weiRaised.add(weiAmount);
298 
299     _processPurchase(_beneficiary, tokens);
300     emit TokenPurchase(
301       msg.sender,
302       _beneficiary,
303       weiAmount,
304       tokens
305     );
306 
307     _updatePurchasingState(_beneficiary, weiAmount);
308 
309     _forwardFunds();
310     _postValidatePurchase(_beneficiary, weiAmount);
311   }
312 
313   // -----------------------------------------
314   // Internal interface (extensible)
315   // -----------------------------------------
316 
317   /**
318    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
319    * @param _beneficiary Address performing the token purchase
320    * @param _weiAmount Value in wei involved in the purchase
321    */
322   function _preValidatePurchase(
323     address _beneficiary,
324     uint256 _weiAmount
325   )
326     internal
327   {
328     require(_beneficiary != address(0));
329     require(_weiAmount != 0);
330   }
331 
332   /**
333    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
334    * @param _beneficiary Address performing the token purchase
335    * @param _weiAmount Value in wei involved in the purchase
336    */
337   function _postValidatePurchase(
338     address _beneficiary,
339     uint256 _weiAmount
340   )
341     internal
342   {
343     // optional override
344   }
345 
346   /**
347    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
348    * @param _beneficiary Address performing the token purchase
349    * @param _tokenAmount Number of tokens to be emitted
350    */
351   function _deliverTokens(
352     address _beneficiary,
353     uint256 _tokenAmount
354   )
355     internal
356   {
357     token.transfer(_beneficiary, _tokenAmount);
358   }
359 
360   /**
361    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
362    * @param _beneficiary Address receiving the tokens
363    * @param _tokenAmount Number of tokens to be purchased
364    */
365   function _processPurchase(
366     address _beneficiary,
367     uint256 _tokenAmount
368   )
369     internal
370   {
371     _deliverTokens(_beneficiary, _tokenAmount);
372   }
373 
374   /**
375    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
376    * @param _beneficiary Address receiving the tokens
377    * @param _weiAmount Value in wei involved in the purchase
378    */
379   function _updatePurchasingState(
380     address _beneficiary,
381     uint256 _weiAmount
382   )
383     internal
384   {
385     // optional override
386   }
387 
388   /**
389    * @dev Override to extend the way in which ether is converted to tokens.
390    * @param _weiAmount Value in wei to be converted into tokens
391    * @return Number of tokens that can be purchased with the specified _weiAmount
392    */
393   function _getTokenAmount(uint256 _weiAmount)
394     internal view returns (uint256)
395   {
396     return _weiAmount.mul(rate);
397   }
398 
399   /**
400    * @dev Determines how ETH is stored/forwarded on purchases.
401    */
402   function _forwardFunds() internal {
403     wallet.transfer(msg.value);
404   }
405 }
406 
407 
408 
409 
410 
411 
412 
413 
414 
415 
416 
417 
418 /**
419  * @title Basic token
420  * @dev Basic version of StandardToken, with no allowances.
421  */
422 contract BasicToken is ERC20Basic {
423   using SafeMath for uint256;
424 
425   mapping(address => uint256) balances;
426 
427   uint256 totalSupply_;
428 
429   /**
430   * @dev total number of tokens in existence
431   */
432   function totalSupply() public view returns (uint256) {
433     return totalSupply_;
434   }
435 
436   /**
437   * @dev transfer token for a specified address
438   * @param _to The address to transfer to.
439   * @param _value The amount to be transferred.
440   */
441   function transfer(address _to, uint256 _value) public returns (bool) {
442     require(_to != address(0));
443     require(_value <= balances[msg.sender]);
444 
445     balances[msg.sender] = balances[msg.sender].sub(_value);
446     balances[_to] = balances[_to].add(_value);
447     emit Transfer(msg.sender, _to, _value);
448     return true;
449   }
450 
451   /**
452   * @dev Gets the balance of the specified address.
453   * @param _owner The address to query the the balance of.
454   * @return An uint256 representing the amount owned by the passed address.
455   */
456   function balanceOf(address _owner) public view returns (uint256) {
457     return balances[_owner];
458   }
459 
460 }
461 
462 
463 
464 
465 /**
466  * @title Standard ERC20 token
467  *
468  * @dev Implementation of the basic standard token.
469  * @dev https://github.com/ethereum/EIPs/issues/20
470  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
471  */
472 contract StandardToken is ERC20, BasicToken {
473 
474   mapping (address => mapping (address => uint256)) internal allowed;
475 
476 
477   /**
478    * @dev Transfer tokens from one address to another
479    * @param _from address The address which you want to send tokens from
480    * @param _to address The address which you want to transfer to
481    * @param _value uint256 the amount of tokens to be transferred
482    */
483   function transferFrom(
484     address _from,
485     address _to,
486     uint256 _value
487   )
488     public
489     returns (bool)
490   {
491     require(_to != address(0));
492     require(_value <= balances[_from]);
493     require(_value <= allowed[_from][msg.sender]);
494 
495     balances[_from] = balances[_from].sub(_value);
496     balances[_to] = balances[_to].add(_value);
497     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
498     emit Transfer(_from, _to, _value);
499     return true;
500   }
501 
502   /**
503    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
504    *
505    * Beware that changing an allowance with this method brings the risk that someone may use both the old
506    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
507    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
508    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
509    * @param _spender The address which will spend the funds.
510    * @param _value The amount of tokens to be spent.
511    */
512   function approve(address _spender, uint256 _value) public returns (bool) {
513     allowed[msg.sender][_spender] = _value;
514     emit Approval(msg.sender, _spender, _value);
515     return true;
516   }
517 
518   /**
519    * @dev Function to check the amount of tokens that an owner allowed to a spender.
520    * @param _owner address The address which owns the funds.
521    * @param _spender address The address which will spend the funds.
522    * @return A uint256 specifying the amount of tokens still available for the spender.
523    */
524   function allowance(
525     address _owner,
526     address _spender
527    )
528     public
529     view
530     returns (uint256)
531   {
532     return allowed[_owner][_spender];
533   }
534 
535   /**
536    * @dev Increase the amount of tokens that an owner allowed to a spender.
537    *
538    * approve should be called when allowed[_spender] == 0. To increment
539    * allowed value is better to use this function to avoid 2 calls (and wait until
540    * the first transaction is mined)
541    * From MonolithDAO Token.sol
542    * @param _spender The address which will spend the funds.
543    * @param _addedValue The amount of tokens to increase the allowance by.
544    */
545   function increaseApproval(
546     address _spender,
547     uint _addedValue
548   )
549     public
550     returns (bool)
551   {
552     allowed[msg.sender][_spender] = (
553       allowed[msg.sender][_spender].add(_addedValue));
554     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
555     return true;
556   }
557 
558   /**
559    * @dev Decrease the amount of tokens that an owner allowed to a spender.
560    *
561    * approve should be called when allowed[_spender] == 0. To decrement
562    * allowed value is better to use this function to avoid 2 calls (and wait until
563    * the first transaction is mined)
564    * From MonolithDAO Token.sol
565    * @param _spender The address which will spend the funds.
566    * @param _subtractedValue The amount of tokens to decrease the allowance by.
567    */
568   function decreaseApproval(
569     address _spender,
570     uint _subtractedValue
571   )
572     public
573     returns (bool)
574   {
575     uint oldValue = allowed[msg.sender][_spender];
576     if (_subtractedValue > oldValue) {
577       allowed[msg.sender][_spender] = 0;
578     } else {
579       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
580     }
581     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
582     return true;
583   }
584 
585 }
586 
587 
588 
589 
590 /**
591  * @title Mintable token
592  * @dev Simple ERC20 Token example, with mintable token creation
593  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
594  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
595  */
596 contract MintableToken is StandardToken, Ownable {
597   event Mint(address indexed to, uint256 amount);
598   event MintFinished();
599 
600   bool public mintingFinished = false;
601 
602 
603   modifier canMint() {
604     require(!mintingFinished);
605     _;
606   }
607 
608   modifier hasMintPermission() {
609     require(msg.sender == owner);
610     _;
611   }
612 
613   /**
614    * @dev Function to mint tokens
615    * @param _to The address that will receive the minted tokens.
616    * @param _amount The amount of tokens to mint.
617    * @return A boolean that indicates if the operation was successful.
618    */
619   function mint(
620     address _to,
621     uint256 _amount
622   )
623     hasMintPermission
624     canMint
625     public
626     returns (bool)
627   {
628     totalSupply_ = totalSupply_.add(_amount);
629     balances[_to] = balances[_to].add(_amount);
630     emit Mint(_to, _amount);
631     emit Transfer(address(0), _to, _amount);
632     return true;
633   }
634 
635   /**
636    * @dev Function to stop minting new tokens.
637    * @return True if the operation was successful.
638    */
639   function finishMinting() onlyOwner canMint public returns (bool) {
640     mintingFinished = true;
641     emit MintFinished();
642     return true;
643   }
644 }
645 
646 
647 
648 /**
649  * @title MintedCrowdsale
650  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
651  * Token ownership should be transferred to MintedCrowdsale for minting.
652  */
653 contract MintedCrowdsale is Crowdsale {
654 
655   /**
656    * @dev Overrides delivery by minting tokens upon purchase.
657    * @param _beneficiary Token purchaser
658    * @param _tokenAmount Number of tokens to be minted
659    */
660   function _deliverTokens(
661     address _beneficiary,
662     uint256 _tokenAmount
663   )
664     internal
665   {
666     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
667   }
668 }
669 
670 
671 
672 
673 
674 
675 
676 /**
677  * @title WhitelistedCrowdsale
678  * @dev Crowdsale in which only whitelisted users can contribute.
679  */
680 contract WhitelistedCrowdsale is Crowdsale, Ownable {
681 
682   mapping(address => bool) public whitelist;
683 
684   /**
685    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
686    */
687   modifier isWhitelisted(address _beneficiary) {
688     require(whitelist[_beneficiary]);
689     _;
690   }
691 
692   /**
693    * @dev Adds single address to whitelist.
694    * @param _beneficiary Address to be added to the whitelist
695    */
696   function addToWhitelist(address _beneficiary) external onlyOwner {
697     whitelist[_beneficiary] = true;
698   }
699 
700   /**
701    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
702    * @param _beneficiaries Addresses to be added to the whitelist
703    */
704   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
705     for (uint256 i = 0; i < _beneficiaries.length; i++) {
706       whitelist[_beneficiaries[i]] = true;
707     }
708   }
709 
710   /**
711    * @dev Removes single address from whitelist.
712    * @param _beneficiary Address to be removed to the whitelist
713    */
714   function removeFromWhitelist(address _beneficiary) external onlyOwner {
715     whitelist[_beneficiary] = false;
716   }
717 
718   /**
719    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
720    * @param _beneficiary Token beneficiary
721    * @param _weiAmount Amount of wei contributed
722    */
723   function _preValidatePurchase(
724     address _beneficiary,
725     uint256 _weiAmount
726   )
727     internal
728     isWhitelisted(_beneficiary)
729   {
730     super._preValidatePurchase(_beneficiary, _weiAmount);
731   }
732 
733 }
734 
735 
736 
737 
738 
739 contract SolidToken is MintableToken {
740 
741   string public constant name = "SolidToken";
742   string public constant symbol = "SOLID";
743   uint8  public constant decimals = 18;
744 
745   uint256 constant private DECIMAL_PLACES = 10 ** 18;
746   uint256 constant SUPPLY_CAP = 4000000 * DECIMAL_PLACES;
747 
748   bool public transfersEnabled = false;
749   uint256 public transferEnablingDate;
750 
751 
752   /**
753    * @dev Sets the date that the tokens becomes transferable
754    * @param date The timestamp of the date
755    * @return A boolean that indicates if the operation was successful.
756    */
757   function setTransferEnablingDate(uint256 date) public onlyOwner returns(bool success) {
758     transferEnablingDate = date;
759     return true;
760   }
761 
762 
763   /**
764    * @dev Enables the token transfer
765    */
766   function enableTransfer() public {
767     require(transferEnablingDate != 0 && now >= transferEnablingDate);
768     transfersEnabled = true;
769   }
770 
771 
772 
773   // OVERRIDES
774   /**
775    * @dev Function to mint tokens. Overriden to check for supply cap.
776    * @param _to The address that will receive the minted tokens.
777    * @param _amount The amount of tokens to mint.
778    * @return A boolean that indicates if the operation was successful.
779    */
780   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
781     require(totalSupply_.add(_amount) <= SUPPLY_CAP);
782     require(super.mint(_to, _amount));
783     return true;
784   }
785 
786   /**
787   * @dev transfer token for a specified address
788   * @param _to The address to transfer to.
789   * @param _value The amount to be transferred.
790   */
791   function transfer(address _to, uint256 _value) public returns (bool) {
792     require(transfersEnabled, "Tranfers are disabled");
793     require(super.transfer(_to, _value));
794     return true;
795   }
796 
797 
798   /**
799    * @dev Transfer tokens from one address to another
800    * @param _from address The address which you want to send tokens from
801    * @param _to address The address which you want to transfer to
802    * @param _value uint256 the amount of tokens to be transferred
803    */
804   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
805     require(transfersEnabled, "Tranfers are disabled");
806     require(super.transferFrom(_from, _to, _value));
807     return true;
808   }
809 
810 
811 }
812 
813 
814 
815 
816 
817 
818 
819 
820 /**
821  * @title Pausable
822  * @dev Base contract which allows children to implement an emergency stop mechanism.
823  */
824 contract Pausable is Ownable {
825   event Pause();
826   event Unpause();
827 
828   bool public paused = false;
829 
830 
831   /**
832    * @dev Modifier to make a function callable only when the contract is not paused.
833    */
834   modifier whenNotPaused() {
835     require(!paused);
836     _;
837   }
838 
839   /**
840    * @dev Modifier to make a function callable only when the contract is paused.
841    */
842   modifier whenPaused() {
843     require(paused);
844     _;
845   }
846 
847   /**
848    * @dev called by the owner to pause, triggers stopped state
849    */
850   function pause() onlyOwner whenNotPaused public {
851     paused = true;
852     emit Pause();
853   }
854 
855   /**
856    * @dev called by the owner to unpause, returns to normal state
857    */
858   function unpause() onlyOwner whenPaused public {
859     paused = false;
860     emit Unpause();
861   }
862 }
863 
864 
865 contract TokenSale is MintedCrowdsale, WhitelistedCrowdsale, Pausable, Distributable {
866 
867   //Global Variables
868   mapping(address => uint256) public contributions;
869   Stages public currentStage;
870 
871   //CONSTANTS
872   uint256 constant MINIMUM_CONTRIBUTION = 0.5 ether;  //the minimum conbtribution on Wei
873   uint256 constant MAXIMUM_CONTRIBUTION = 100 ether;  //the maximum contribution on Wei
874   uint256 constant BONUS_PERCENT = 250;                // The percentage of bonus in the fisrt stage, in;
875   uint256 constant TOKENS_ON_SALE_PERCENT = 600;       //The percentage of avaiable tokens for sale;
876   uint256 constant BONUSSALE_MAX_DURATION = 30 days ;
877   uint256 constant MAINSALE_MAX_DURATION = 62 days;
878   uint256 constant TOKEN_RELEASE_DELAY = 182 days;
879   uint256 constant HUNDRED_PERCENT = 1000;            //100% considering one extra decimal
880 
881   //BONUSSALE VARIABLES
882   uint256 public bonussale_Cap = 14400 ether;
883   uint256 public bonussale_TokenCap = 1200000 ether;
884 
885   uint256 public bonussale_StartDate;
886   uint256 public bonussale_EndDate;
887   uint256 public bonussale_TokesSold;
888   uint256 public bonussale_WeiRaised;
889 
890   //MAINSALE VARIABLES
891   uint256 public mainSale_Cap = 18000 ether;
892   uint256 public mainSale_TokenCap = 1200000 ether;
893 
894   uint256 public mainSale_StartDate;
895   uint256 public mainSale_EndDate;
896   uint256 public mainSale_TokesSold;
897   uint256 public mainSale_WeiRaised;
898 
899 
900   //TEMPORARY VARIABLES - USED TO AVOID OVERRIDING MORE OPEN ZEPPELING FUNCTIONS
901   uint256 private changeDue;
902   bool private capReached;
903 
904   enum Stages{
905     SETUP,
906     READY,
907     BONUSSALE,
908     MAINSALE,
909     FINALIZED
910   }
911 
912   /**
913       MODIFIERS
914   **/
915 
916   /**
917     @dev Garantee that contract has the desired satge
918   **/
919   modifier atStage(Stages _currentStage){
920       require(currentStage == _currentStage);
921       _;
922   }
923 
924   /**
925     @dev Execute automatically transitions between different Stages
926     based on time only
927   **/
928   modifier timedTransition(){
929     if(currentStage == Stages.READY && now >= bonussale_StartDate){
930       currentStage = Stages.BONUSSALE;
931     }
932     if(currentStage == Stages.BONUSSALE && now > bonussale_EndDate){
933       finalizePresale();
934     }
935     if(currentStage == Stages.MAINSALE && now > mainSale_EndDate){
936       finalizeSale();
937     }
938     _;
939   }
940 
941 
942   /**
943       CONSTRUCTOR
944   **/
945 
946   /**
947     @param _rate The exchange rate(multiplied by 1000) of tokens to eth(1 token = rate * ETH)
948     @param _wallet The address that recieves _forwardFunds
949     @param _token A token contract. Will be overriden later(needed fot OZ constructor)
950   **/
951   constructor(uint256 _rate, address _wallet, ERC20 _token) public Crowdsale(_rate,_wallet,_token) {
952     require(_rate == 15);
953     currentStage = Stages.SETUP;
954   }
955 
956 
957   /**
958       SETUP RELATED FUNCTIONS
959   **/
960 
961   /**
962    * @dev Sets the initial date and token.
963    * @param initialDate A timestamp representing the start of the bonussale
964     @param tokenAddress  The address of the deployed SolidToken
965    */
966   function setupSale(uint256 initialDate, address tokenAddress) onlyOwner atStage(Stages.SETUP) public {
967     bonussale_StartDate = initialDate;
968     bonussale_EndDate = bonussale_StartDate + BONUSSALE_MAX_DURATION;
969     token = ERC20(tokenAddress);
970 
971     require(SolidToken(tokenAddress).totalSupply() == 0, "Tokens have already been distributed");
972     require(SolidToken(tokenAddress).owner() == address(this), "Token has the wrong ownership");
973 
974     currentStage = Stages.READY;
975   }
976 
977 
978   /**
979       STAGE RELATED FUNCTIONS
980   **/
981 
982   /**
983    * @dev Returns de ETH cap of the current currentStage
984    * @return uint256 representing the cap
985    */
986   function getCurrentCap() public view returns(uint256 cap){
987     cap = bonussale_Cap;
988     if(currentStage == Stages.MAINSALE){
989       cap = mainSale_Cap;
990     }
991   }
992 
993   /**
994    * @dev Returns de ETH cap of the current currentStage
995    * @return uint256 representing the raised amount in the stage
996    */
997   function getRaisedForCurrentStage() public view returns(uint256 raised){
998     raised = bonussale_WeiRaised;
999     if(currentStage == Stages.MAINSALE)
1000       raised = mainSale_WeiRaised;
1001   }
1002 
1003   /**
1004    * @dev Returns the sale status.
1005    * @return True if open, false if closed
1006    */
1007   function saleOpen() public timedTransition whenNotPaused returns(bool open) {
1008     open = ((now >= bonussale_StartDate && now < bonussale_EndDate) ||
1009            (now >= mainSale_StartDate && now <   mainSale_EndDate)) &&
1010            (currentStage == Stages.BONUSSALE || currentStage == Stages.MAINSALE);
1011   }
1012 
1013 
1014 
1015   /**
1016     FINALIZATION RELATES FUNCTIONS
1017   **/
1018 
1019   /**
1020    * @dev Checks and distribute the remaining tokens. Finish minting afterwards
1021    * @return uint256 representing the cap
1022    */
1023   function distributeTokens() public onlyOwner atStage(Stages.FINALIZED) {
1024     require(!distributed);
1025     distributed = true;
1026 
1027     uint256 totalTokens = (bonussale_TokesSold.add(mainSale_TokesSold)).mul(HUNDRED_PERCENT).div(TOKENS_ON_SALE_PERCENT); //sold token will represent 60% of all tokens
1028     for(uint i = 0; i < partners.length; i++){
1029       uint256 amount = percentages[partners[i]].mul(totalTokens).div(HUNDRED_PERCENT);
1030       _deliverTokens(partners[i], amount);
1031     }
1032     for(uint j = 0; j < partnerFixedAmount.length; j++){
1033       _deliverTokens(partnerFixedAmount[j], fixedAmounts[partnerFixedAmount[j]]);
1034     }
1035     require(SolidToken(token).finishMinting());
1036   }
1037 
1038   /**
1039    * @dev Finalizes the bonussale and sets up the break and public sales
1040    *
1041    */
1042   function finalizePresale() atStage(Stages.BONUSSALE) internal{
1043     bonussale_EndDate = now;
1044     mainSale_StartDate = now;
1045     mainSale_EndDate = mainSale_StartDate + MAINSALE_MAX_DURATION;
1046     mainSale_TokenCap = mainSale_TokenCap.add(bonussale_TokenCap.sub(bonussale_TokesSold));
1047     mainSale_Cap = mainSale_Cap.add(bonussale_Cap.sub(weiRaised.sub(changeDue)));
1048     currentStage = Stages.MAINSALE;
1049   }
1050 
1051   /**
1052    * @dev Finalizes the public sale
1053    *
1054    */
1055   function finalizeSale() atStage(Stages.MAINSALE) internal {
1056     mainSale_EndDate = now;
1057     require(SolidToken(token).setTransferEnablingDate(now + TOKEN_RELEASE_DELAY));
1058     currentStage = Stages.FINALIZED;
1059   }
1060 
1061   /**
1062       OPEN ZEPPELIN OVERRIDES
1063   **/
1064 
1065   /**
1066    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
1067    * @param _beneficiary Address performing the token purchase
1068    * @param _weiAmount Value in wei involved in the purchase
1069    */
1070   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) isWhitelisted(_beneficiary) internal {
1071     require(_beneficiary == msg.sender);
1072     require(saleOpen(), "Sale is Closed");
1073 
1074     // Check for edge cases
1075     uint256 acceptedValue = _weiAmount;
1076     uint256 currentCap = getCurrentCap();
1077     uint256 raised = getRaisedForCurrentStage();
1078 
1079     if(contributions[_beneficiary].add(acceptedValue) > MAXIMUM_CONTRIBUTION){
1080       changeDue = (contributions[_beneficiary].add(acceptedValue)).sub(MAXIMUM_CONTRIBUTION);
1081       acceptedValue = acceptedValue.sub(changeDue);
1082     }
1083 
1084     if(raised.add(acceptedValue) >= currentCap){
1085       changeDue = changeDue.add(raised.add(acceptedValue).sub(currentCap));
1086       acceptedValue = _weiAmount.sub(changeDue);
1087       capReached = true;
1088     }
1089     require(capReached || contributions[_beneficiary].add(acceptedValue) >= MINIMUM_CONTRIBUTION ,"Contribution below minimum");
1090   }
1091 
1092   /**
1093    * @dev Override to extend the way in which ether is converted to tokens.
1094    * @param _weiAmount Value in wei to be converted into tokens
1095    * @return Number of tokens that can be purchased with the specified _weiAmount
1096    */
1097   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256 amount) {
1098     amount = (_weiAmount.sub(changeDue)).mul(HUNDRED_PERCENT).div(rate); // Multiplication to account for the decimal cases in the rate
1099     if(currentStage == Stages.BONUSSALE){
1100       amount = amount.add(amount.mul(BONUS_PERCENT).div(HUNDRED_PERCENT)); //Add bonus
1101     }
1102   }
1103 
1104   /**
1105    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
1106    * @param _beneficiary Address performing the token purchase
1107    * @param _weiAmount Value in wei involved in the purchase
1108    */
1109   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1110     if(currentStage == Stages.MAINSALE && capReached) finalizeSale();
1111     if(currentStage == Stages.BONUSSALE && capReached) finalizePresale();
1112 
1113 
1114     //Cleanup temp
1115     changeDue = 0;
1116     capReached = false;
1117 
1118   }
1119 
1120   /**
1121    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
1122    * @param _beneficiary Address receiving the tokens
1123    * @param _weiAmount Value in wei involved in the purchase
1124    */
1125   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
1126     uint256 tokenAmount = _getTokenAmount(_weiAmount);
1127 
1128     if(currentStage == Stages.BONUSSALE){
1129       bonussale_TokesSold = bonussale_TokesSold.add(tokenAmount);
1130       bonussale_WeiRaised = bonussale_WeiRaised.add(_weiAmount.sub(changeDue));
1131     } else {
1132       mainSale_TokesSold = mainSale_TokesSold.add(tokenAmount);
1133       mainSale_WeiRaised = mainSale_WeiRaised.add(_weiAmount.sub(changeDue));
1134     }
1135 
1136     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount).sub(changeDue);
1137     weiRaised = weiRaised.sub(changeDue);
1138   }
1139 
1140   /**
1141    * @dev Determines how ETH is stored/forwarded on purchases.
1142    */
1143   function _forwardFunds() internal {
1144     wallet.transfer(msg.value.sub(changeDue));
1145     msg.sender.transfer(changeDue); //Transfer change to _beneficiary
1146   }
1147 
1148 }