1 /*
2  @Globex Team 2018 - Globex Exchange ICO
3  */
4 pragma solidity ^0.4.23;
5 
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender)
26     public view returns (uint256);
27 
28   function transferFrom(address from, address to, uint256 value)
29     public returns (bool);
30 
31   function approve(address spender, uint256 value) public returns (bool);
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
52     // benefit is lost if 'b' is also tested.
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54     if (a == 0) {
55       return 0;
56     }
57 
58     c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     // uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return a / b;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 /**
93  * @title Crowdsale
94  * @dev Crowdsale is a base contract for managing a token crowdsale,
95  * allowing investors to purchase tokens with ether. This contract implements
96  * such functionality in its most fundamental form and can be extended to provide additional
97  * functionality and/or custom behavior.
98  * The external interface represents the basic interface for purchasing tokens, and conform
99  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
100  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
101  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
102  * behavior.
103  */
104 contract Crowdsale {
105   using SafeMath for uint256;
106 
107   // The token being sold
108   ERC20 public token;
109 
110   // Address where funds are collected
111   address public wallet;
112 
113   // How many token units a buyer gets per wei.
114   // The rate is the conversion between wei and the smallest and indivisible token unit.
115   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
116   // 1 wei will give you 1 unit, or 0.001 TOK.
117   uint256 public rate;
118 
119   // Amount of wei raised
120   uint256 public weiRaised;
121 
122   /**
123    * Event for token purchase logging
124    * @param purchaser who paid for the tokens
125    * @param beneficiary who got the tokens
126    * @param value weis paid for purchase
127    * @param amount amount of tokens purchased
128    */
129   event TokenPurchase(
130     address indexed purchaser,
131     address indexed beneficiary,
132     uint256 value,
133     uint256 amount
134   );
135 
136   /**
137    * @param _rate Number of token units a buyer gets per wei
138    * @param _wallet Address where collected funds will be forwarded to
139    * @param _token Address of the token being sold
140    */
141   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
142     require(_rate > 0);
143     require(_wallet != address(0));
144     require(_token != address(0));
145 
146     rate = _rate;
147     wallet = _wallet;
148     token = _token;
149   }
150 
151   // -----------------------------------------
152   // Crowdsale external interface
153   // -----------------------------------------
154 
155   /**
156    * @dev fallback function ***DO NOT OVERRIDE***
157    */
158   function () external payable {
159     buyTokens(msg.sender);
160   }
161 
162   /**
163    * @dev low level token purchase ***DO NOT OVERRIDE***
164    * @param _beneficiary Address performing the token purchase
165    */
166   function buyTokens(address _beneficiary) public payable {
167 
168     uint256 weiAmount = msg.value;
169     _preValidatePurchase(_beneficiary, weiAmount);
170 
171     // calculate token amount to be created
172     uint256 tokens = _getTokenAmount(weiAmount);
173 
174     // update state
175     weiRaised = weiRaised.add(weiAmount);
176 
177     _processPurchase(_beneficiary, tokens);
178     emit TokenPurchase(
179       msg.sender,
180       _beneficiary,
181       weiAmount,
182       tokens
183     );
184 
185     _updatePurchasingState(_beneficiary, weiAmount);
186 
187     _forwardFunds();
188     _postValidatePurchase(_beneficiary, weiAmount);
189   }
190 
191   // -----------------------------------------
192   // Internal interface (extensible)
193   // -----------------------------------------
194 
195   /**
196    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
197    * @param _beneficiary Address performing the token purchase
198    * @param _weiAmount Value in wei involved in the purchase
199    */
200   function _preValidatePurchase(
201     address _beneficiary,
202     uint256 _weiAmount
203   )
204     internal
205   {
206     require(_beneficiary != address(0));
207     require(_weiAmount != 0);
208   }
209 
210   /**
211    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
212    * @param _beneficiary Address performing the token purchase
213    * @param _weiAmount Value in wei involved in the purchase
214    */
215   function _postValidatePurchase(
216     address _beneficiary,
217     uint256 _weiAmount
218   )
219     internal
220   {
221     // optional override
222   }
223 
224   /**
225    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
226    * @param _beneficiary Address performing the token purchase
227    * @param _tokenAmount Number of tokens to be emitted
228    */
229   function _deliverTokens(
230     address _beneficiary,
231     uint256 _tokenAmount
232   )
233     internal
234   {
235     token.transfer(_beneficiary, _tokenAmount);
236   }
237 
238   /**
239    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
240    * @param _beneficiary Address receiving the tokens
241    * @param _tokenAmount Number of tokens to be purchased
242    */
243   function _processPurchase(
244     address _beneficiary,
245     uint256 _tokenAmount
246   )
247     internal
248   {
249     _deliverTokens(_beneficiary, _tokenAmount);
250   }
251 
252   /**
253    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
254    * @param _beneficiary Address receiving the tokens
255    * @param _weiAmount Value in wei involved in the purchase
256    */
257   function _updatePurchasingState(
258     address _beneficiary,
259     uint256 _weiAmount
260   )
261     internal
262   {
263     // optional override
264   }
265 
266   /**
267    * @dev Override to extend the way in which ether is converted to tokens.
268    * @param _weiAmount Value in wei to be converted into tokens
269    * @return Number of tokens that can be purchased with the specified _weiAmount
270    */
271   function _getTokenAmount(uint256 _weiAmount)
272     internal view returns (uint256)
273   {
274     return _weiAmount.mul(rate);
275   }
276 
277   /**
278    * @dev Determines how ETH is stored/forwarded on purchases.
279    */
280   function _forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283 }
284 
285 
286 
287 /**
288  * @title Ownable
289  * @dev The Ownable contract has an owner address, and provides basic authorization control
290  * functions, this simplifies the implementation of "user permissions".
291  */
292 contract Ownable {
293   address public owner;
294 
295 
296   event OwnershipRenounced(address indexed previousOwner);
297   event OwnershipTransferred(
298     address indexed previousOwner,
299     address indexed newOwner
300   );
301 
302 
303   /**
304    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
305    * account.
306    */
307   constructor() public {
308     owner = msg.sender;
309   }
310 
311   /**
312    * @dev Throws if called by any account other than the owner.
313    */
314   modifier onlyOwner() {
315     require(msg.sender == owner);
316     _;
317   }
318 
319   /**
320    * @dev Allows the current owner to relinquish control of the contract.
321    */
322   function renounceOwnership() public onlyOwner {
323     emit OwnershipRenounced(owner);
324     owner = address(0);
325   }
326 
327   /**
328    * @dev Allows the current owner to transfer control of the contract to a newOwner.
329    * @param _newOwner The address to transfer ownership to.
330    */
331   function transferOwnership(address _newOwner) public onlyOwner {
332     _transferOwnership(_newOwner);
333   }
334 
335   /**
336    * @dev Transfers control of the contract to a newOwner.
337    * @param _newOwner The address to transfer ownership to.
338    */
339   function _transferOwnership(address _newOwner) internal {
340     require(_newOwner != address(0));
341     emit OwnershipTransferred(owner, _newOwner);
342     owner = _newOwner;
343   }
344 }
345 
346 
347 /**
348  * @title TimedCrowdsale
349  * @dev Crowdsale accepting contributions only within a time frame.
350  */
351 contract TimedCrowdsale is Crowdsale {
352   using SafeMath for uint256;
353 
354   uint256 public openingTime;
355   uint256 public closingTime;
356 
357   /**
358    * @dev Reverts if not in crowdsale time range.
359    */
360   modifier onlyWhileOpen {
361     // solium-disable-next-line security/no-block-members
362     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
363     _;
364   }
365 
366   /**
367    * @dev Constructor, takes crowdsale opening and closing times.
368    * @param _openingTime Crowdsale opening time
369    * @param _closingTime Crowdsale closing time
370    */
371   constructor(uint256 _openingTime, uint256 _closingTime) public {
372     // solium-disable-next-line security/no-block-members
373     require(_openingTime >= block.timestamp);
374     require(_closingTime >= _openingTime);
375 
376     openingTime = _openingTime;
377     closingTime = _closingTime;
378   }
379 
380   /**
381    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
382    * @return Whether crowdsale period has elapsed
383    */
384   function hasClosed() public view returns (bool) {
385     // solium-disable-next-line security/no-block-members
386     return block.timestamp > closingTime;
387   }
388 
389   /**
390    * @dev Extend parent behavior requiring to be within contributing period
391    * @param _beneficiary Token purchaser
392    * @param _weiAmount Amount of wei contributed
393    */
394   function _preValidatePurchase(
395     address _beneficiary,
396     uint256 _weiAmount
397   )
398     internal
399     onlyWhileOpen
400   {
401     super._preValidatePurchase(_beneficiary, _weiAmount);
402   }
403 
404 }
405 
406 
407 /**
408  * @title FinalizableCrowdsale
409  * @dev Extension of Crowdsale where an owner can do extra work
410  * after finishing.
411  */
412 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
413   using SafeMath for uint256;
414 
415   bool public isFinalized = false;
416 
417   event Finalized();
418 
419   /**
420    * @dev Must be called after crowdsale ends, to do some extra finalization
421    * work. Calls the contract's finalization function.
422    */
423   function finalize() onlyOwner public {
424     require(!isFinalized);
425     require(hasClosed());
426 
427     finalization();
428     emit Finalized();
429 
430     isFinalized = true;
431   }
432 
433   /**
434    * @dev Can be overridden to add finalization logic. The overriding function
435    * should call super.finalization() to ensure the chain of finalization is
436    * executed entirely.
437    */
438   function finalization() internal {
439   }
440 
441 }
442 
443 
444 /**
445  * @title RefundVault
446  * @dev This contract is used for storing funds while a crowdsale
447  * is in progress. Supports refunding the money if crowdsale fails,
448  * and forwarding it if crowdsale is successful.
449  */
450 contract RefundVault is Ownable {
451   using SafeMath for uint256;
452 
453   enum State { Active, Refunding, Closed }
454 
455   mapping (address => uint256) public deposited;
456   address public wallet;
457   State public state;
458 
459   event Closed();
460   event RefundsEnabled();
461   event Refunded(address indexed beneficiary, uint256 weiAmount);
462 
463   /**
464    * @param _wallet Vault address
465    */
466   constructor(address _wallet) public {
467     require(_wallet != address(0));
468     wallet = _wallet;
469     state = State.Active;
470   }
471 
472   /**
473    * @param investor Investor address
474    */
475   function deposit(address investor) onlyOwner public payable {
476     require(state == State.Active);
477     deposited[investor] = deposited[investor].add(msg.value);
478   }
479 
480   function close() onlyOwner public {
481     require(state == State.Active);
482     state = State.Closed;
483     emit Closed();
484     wallet.transfer(address(this).balance);
485   }
486 
487   function enableRefunds() onlyOwner public {
488     require(state == State.Active);
489     state = State.Refunding;
490     emit RefundsEnabled();
491   }
492 
493   /**
494    * @param investor Investor address
495    */
496   function refund(address investor) public {
497     require(state == State.Refunding);
498     uint256 depositedValue = deposited[investor];
499     deposited[investor] = 0;
500     investor.transfer(depositedValue);
501     emit Refunded(investor, depositedValue);
502   }
503 }
504 
505 
506 
507 /**
508  * @title Basic token
509  * @dev Basic version of StandardToken, with no allowances.
510  */
511 contract BasicToken is ERC20Basic {
512   using SafeMath for uint256;
513 
514   mapping(address => uint256) balances;
515 
516   uint256 totalSupply_;
517 
518   /**
519   * @dev total number of tokens in existence
520   */
521   function totalSupply() public view returns (uint256) {
522     return totalSupply_;
523   }
524 
525   /**
526   * @dev transfer token for a specified address
527   * @param _to The address to transfer to.
528   * @param _value The amount to be transferred.
529   */
530   function transfer(address _to, uint256 _value) public returns (bool) {
531     require(_to != address(0));
532     require(_value <= balances[msg.sender]);
533 
534     balances[msg.sender] = balances[msg.sender].sub(_value);
535     balances[_to] = balances[_to].add(_value);
536     emit Transfer(msg.sender, _to, _value);
537     return true;
538   }
539 
540   /**
541   * @dev Gets the balance of the specified address.
542   * @param _owner The address to query the the balance of.
543   * @return An uint256 representing the amount owned by the passed address.
544   */
545   function balanceOf(address _owner) public view returns (uint256) {
546     return balances[_owner];
547   }
548 
549 }
550 
551 
552 /**
553  * @title Standard ERC20 token
554  *
555  * @dev Implementation of the basic standard token.
556  * @dev https://github.com/ethereum/EIPs/issues/20
557  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
558  */
559 contract StandardToken is ERC20, BasicToken {
560 
561   mapping (address => mapping (address => uint256)) internal allowed;
562 
563 
564   /**
565    * @dev Transfer tokens from one address to another
566    * @param _from address The address which you want to send tokens from
567    * @param _to address The address which you want to transfer to
568    * @param _value uint256 the amount of tokens to be transferred
569    */
570   function transferFrom(
571     address _from,
572     address _to,
573     uint256 _value
574   )
575     public
576     returns (bool)
577   {
578     require(_to != address(0));
579     require(_value <= balances[_from]);
580     require(_value <= allowed[_from][msg.sender]);
581 
582     balances[_from] = balances[_from].sub(_value);
583     balances[_to] = balances[_to].add(_value);
584     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
585     emit Transfer(_from, _to, _value);
586     return true;
587   }
588 
589   /**
590    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
591    *
592    * Beware that changing an allowance with this method brings the risk that someone may use both the old
593    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
594    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
595    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
596    * @param _spender The address which will spend the funds.
597    * @param _value The amount of tokens to be spent.
598    */
599   function approve(address _spender, uint256 _value) public returns (bool) {
600     allowed[msg.sender][_spender] = _value;
601     emit Approval(msg.sender, _spender, _value);
602     return true;
603   }
604 
605   /**
606    * @dev Function to check the amount of tokens that an owner allowed to a spender.
607    * @param _owner address The address which owns the funds.
608    * @param _spender address The address which will spend the funds.
609    * @return A uint256 specifying the amount of tokens still available for the spender.
610    */
611   function allowance(
612     address _owner,
613     address _spender
614    )
615     public
616     view
617     returns (uint256)
618   {
619     return allowed[_owner][_spender];
620   }
621 
622   /**
623    * @dev Increase the amount of tokens that an owner allowed to a spender.
624    *
625    * approve should be called when allowed[_spender] == 0. To increment
626    * allowed value is better to use this function to avoid 2 calls (and wait until
627    * the first transaction is mined)
628    * From MonolithDAO Token.sol
629    * @param _spender The address which will spend the funds.
630    * @param _addedValue The amount of tokens to increase the allowance by.
631    */
632   function increaseApproval(
633     address _spender,
634     uint _addedValue
635   )
636     public
637     returns (bool)
638   {
639     allowed[msg.sender][_spender] = (
640       allowed[msg.sender][_spender].add(_addedValue));
641     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
642     return true;
643   }
644 
645   /**
646    * @dev Decrease the amount of tokens that an owner allowed to a spender.
647    *
648    * approve should be called when allowed[_spender] == 0. To decrement
649    * allowed value is better to use this function to avoid 2 calls (and wait until
650    * the first transaction is mined)
651    * From MonolithDAO Token.sol
652    * @param _spender The address which will spend the funds.
653    * @param _subtractedValue The amount of tokens to decrease the allowance by.
654    */
655   function decreaseApproval(
656     address _spender,
657     uint _subtractedValue
658   )
659     public
660     returns (bool)
661   {
662     uint oldValue = allowed[msg.sender][_spender];
663     if (_subtractedValue > oldValue) {
664       allowed[msg.sender][_spender] = 0;
665     } else {
666       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
667     }
668     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
669     return true;
670   }
671 
672 }
673 
674 
675 /**
676  * @title Mintable token
677  * @dev Simple ERC20 Token example, with mintable token creation
678  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
679  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
680  */
681 contract MintableToken is StandardToken, Ownable {
682   event Mint(address indexed to, uint256 amount);
683   event MintFinished();
684 
685   bool public mintingFinished = false;
686 
687 
688   modifier canMint() {
689     require(!mintingFinished);
690     _;
691   }
692 
693   modifier hasMintPermission() {
694     require(msg.sender == owner);
695     _;
696   }
697 
698   /**
699    * @dev Function to mint tokens
700    * @param _to The address that will receive the minted tokens.
701    * @param _amount The amount of tokens to mint.
702    * @return A boolean that indicates if the operation was successful.
703    */
704   function mint(
705     address _to,
706     uint256 _amount
707   )
708     hasMintPermission
709     canMint
710     public
711     returns (bool)
712   {
713     totalSupply_ = totalSupply_.add(_amount);
714     balances[_to] = balances[_to].add(_amount);
715     emit Mint(_to, _amount);
716     emit Transfer(address(0), _to, _amount);
717     return true;
718   }
719 
720   /**
721    * @dev Function to stop minting new tokens.
722    * @return True if the operation was successful.
723    */
724   function finishMinting() onlyOwner canMint public returns (bool) {
725     mintingFinished = true;
726     emit MintFinished();
727     return true;
728   }
729 }
730 
731 
732 contract FreezableToken is StandardToken {
733     // freezing chains
734     mapping (bytes32 => uint64) internal chains;
735     // freezing amounts for each chain
736     mapping (bytes32 => uint) internal freezings;
737     // total freezing balance per address
738     mapping (address => uint) internal freezingBalance;
739 
740     event Freezed(address indexed to, uint64 release, uint amount);
741     event Released(address indexed owner, uint amount);
742 
743     /**
744      * @dev Gets the balance of the specified address include freezing tokens.
745      * @param _owner The address to query the the balance of.
746      * @return An uint256 representing the amount owned by the passed address.
747      */
748     function balanceOf(address _owner) public view returns (uint256 balance) {
749         return super.balanceOf(_owner) + freezingBalance[_owner];
750     }
751 
752     /**
753      * @dev Gets the balance of the specified address without freezing tokens.
754      * @param _owner The address to query the the balance of.
755      * @return An uint256 representing the amount owned by the passed address.
756      */
757     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
758         return super.balanceOf(_owner);
759     }
760 
761     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
762         return freezingBalance[_owner];
763     }
764 
765     /**
766      * @dev gets freezing count
767      * @param _addr Address of freeze tokens owner.
768      */
769     function freezingCount(address _addr) public view returns (uint count) {
770         uint64 release = chains[toKey(_addr, 0)];
771         while (release != 0) {
772             count++;
773             release = chains[toKey(_addr, release)];
774         }
775     }
776 
777     /**
778      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
779      * @param _addr Address of freeze tokens owner.
780      * @param _index Freezing portion index. It ordered by release date descending.
781      */
782     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
783         for (uint i = 0; i < _index + 1; i++) {
784             _release = chains[toKey(_addr, _release)];
785             if (_release == 0) {
786                 return;
787             }
788         }
789         _balance = freezings[toKey(_addr, _release)];
790     }
791 
792     /**
793      * @dev freeze your tokens to the specified address.
794      *      Be careful, gas usage is not deterministic,
795      *      and depends on how many freezes _to address already has.
796      * @param _to Address to which token will be freeze.
797      * @param _amount Amount of token to freeze.
798      * @param _until Release date, must be in future.
799      */
800     function freezeTo(address _to, uint _amount, uint64 _until) public {
801         require(_to != address(0));
802         require(_amount <= balances[msg.sender]);
803 
804         balances[msg.sender] = balances[msg.sender].sub(_amount);
805 
806         bytes32 currentKey = toKey(_to, _until);
807         freezings[currentKey] = freezings[currentKey].add(_amount);
808         freezingBalance[_to] = freezingBalance[_to].add(_amount);
809 
810         freeze(_to, _until);
811         emit Transfer(msg.sender, _to, _amount);
812         emit Freezed(_to, _until, _amount);
813     }
814 
815     /**
816      * @dev release first available freezing tokens.
817      */
818     function releaseOnce() public {
819         bytes32 headKey = toKey(msg.sender, 0);
820         uint64 head = chains[headKey];
821         require(head != 0);
822         require(uint64(block.timestamp) > head);
823         bytes32 currentKey = toKey(msg.sender, head);
824 
825         uint64 next = chains[currentKey];
826 
827         uint amount = freezings[currentKey];
828         delete freezings[currentKey];
829 
830         balances[msg.sender] = balances[msg.sender].add(amount);
831         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
832 
833         if (next == 0) {
834             delete chains[headKey];
835         } else {
836             chains[headKey] = next;
837             delete chains[currentKey];
838         }
839         emit Released(msg.sender, amount);
840     }
841 
842     /**
843      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
844      * @return how many tokens was released
845      */
846     function releaseAll() public returns (uint tokens) {
847         uint release;
848         uint balance;
849         (release, balance) = getFreezing(msg.sender, 0);
850         while (release != 0 && block.timestamp > release) {
851             releaseOnce();
852             tokens += balance;
853             (release, balance) = getFreezing(msg.sender, 0);
854         }
855     }
856 
857     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
858         // WISH masc to increase entropy
859         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
860         assembly {
861             result := or(result, mul(_addr, 0x10000000000000000))
862             result := or(result, _release)
863         }
864     }
865 
866     function freeze(address _to, uint64 _until) internal {
867         require(_until > block.timestamp);
868         bytes32 key = toKey(_to, _until);
869         bytes32 parentKey = toKey(_to, uint64(0));
870         uint64 next = chains[parentKey];
871 
872         if (next == 0) {
873             chains[parentKey] = _until;
874             return;
875         }
876 
877         bytes32 nextKey = toKey(_to, next);
878         uint parent;
879 
880         while (next != 0 && _until > next) {
881             parent = next;
882             parentKey = nextKey;
883 
884             next = chains[nextKey];
885             nextKey = toKey(_to, next);
886         }
887 
888         if (_until == next) {
889             return;
890         }
891 
892         if (next != 0) {
893             chains[key] = next;
894         }
895 
896         chains[parentKey] = _until;
897     }
898 }
899 
900 
901 /**
902  * @title Burnable Token
903  * @dev Token that can be irreversibly burned (destroyed).
904  */
905 contract BurnableToken is BasicToken {
906 
907   event Burn(address indexed burner, uint256 value);
908 
909   /**
910    * @dev Burns a specific amount of tokens.
911    * @param _value The amount of token to be burned.
912    */
913   function burn(uint256 _value) public {
914     _burn(msg.sender, _value);
915   }
916 
917   function _burn(address _who, uint256 _value) internal {
918     require(_value <= balances[_who]);
919     // no need to require value <= totalSupply, since that would imply the
920     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
921 
922     balances[_who] = balances[_who].sub(_value);
923     totalSupply_ = totalSupply_.sub(_value);
924     emit Burn(_who, _value);
925     emit Transfer(_who, address(0), _value);
926   }
927 }
928 
929 
930 
931 /**
932  * @title Pausable
933  * @dev Base contract which allows children to implement an emergency stop mechanism.
934  */
935 contract Pausable is Ownable {
936   event Pause();
937   event Unpause();
938 
939   bool public paused = false;
940 
941 
942   /**
943    * @dev Modifier to make a function callable only when the contract is not paused.
944    */
945   modifier whenNotPaused() {
946     require(!paused);
947     _;
948   }
949 
950   /**
951    * @dev Modifier to make a function callable only when the contract is paused.
952    */
953   modifier whenPaused() {
954     require(paused);
955     _;
956   }
957 
958   /**
959    * @dev called by the owner to pause, triggers stopped state
960    */
961   function pause() onlyOwner whenNotPaused public {
962     paused = true;
963     emit Pause();
964   }
965 
966   /**
967    * @dev called by the owner to unpause, returns to normal state
968    */
969   function unpause() onlyOwner whenPaused public {
970     paused = false;
971     emit Unpause();
972   }
973 }
974 
975 
976 contract FreezableMintableToken is FreezableToken, MintableToken {
977     /**
978      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
979      *      Be careful, gas usage is not deterministic,
980      *      and depends on how many freezes _to address already has.
981      * @param _to Address to which token will be freeze.
982      * @param _amount Amount of token to mint and freeze.
983      * @param _until Release date, must be in future.
984      * @return A boolean that indicates if the operation was successful.
985      */
986     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
987         totalSupply_ = totalSupply_.add(_amount);
988 
989         bytes32 currentKey = toKey(_to, _until);
990         freezings[currentKey] = freezings[currentKey].add(_amount);
991         freezingBalance[_to] = freezingBalance[_to].add(_amount);
992 
993         freeze(_to, _until);
994         emit Mint(_to, _amount);
995         emit Freezed(_to, _until, _amount);
996         emit Transfer(msg.sender, _to, _amount);
997         return true;
998     }
999 }
1000 
1001 
1002 
1003 contract Consts {
1004     uint public constant TOKEN_DECIMALS = 8;
1005     uint8 public constant TOKEN_DECIMALS_UINT8 = 8;
1006     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
1007 
1008     string public constant TOKEN_NAME = "GLOBEX";
1009     string public constant TOKEN_SYMBOL = "GEX";
1010     bool public constant PAUSED = true;
1011     address public constant TARGET_USER = 0xFB3F321f4BC12640a05a710b11Ec86FF55dA2699;
1012     
1013     uint public constant START_TIME = 1540476000;
1014     
1015     bool public constant CONTINUE_MINTING = false;
1016 }
1017 
1018 
1019 
1020 
1021 /**
1022  * @title CappedCrowdsale
1023  * @dev Crowdsale with a limit for total contributions.
1024  */
1025 contract CappedCrowdsale is Crowdsale {
1026   using SafeMath for uint256;
1027 
1028   uint256 public cap;
1029 
1030   /**
1031    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
1032    * @param _cap Max amount of wei to be contributed
1033    */
1034   constructor(uint256 _cap) public {
1035     require(_cap > 0);
1036     cap = _cap;
1037   }
1038 
1039   /**
1040    * @dev Checks whether the cap has been reached.
1041    * @return Whether the cap was reached
1042    */
1043   function capReached() public view returns (bool) {
1044     return weiRaised >= cap;
1045   }
1046 
1047   /**
1048    * @dev Extend parent behavior requiring purchase to respect the funding cap.
1049    * @param _beneficiary Token purchaser
1050    * @param _weiAmount Amount of wei contributed
1051    */
1052   function _preValidatePurchase(
1053     address _beneficiary,
1054     uint256 _weiAmount
1055   )
1056     internal
1057   {
1058     super._preValidatePurchase(_beneficiary, _weiAmount);
1059     require(weiRaised.add(_weiAmount) <= cap);
1060   }
1061 
1062 }
1063 
1064 
1065 /**
1066  * @title MintedCrowdsale
1067  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1068  * Token ownership should be transferred to MintedCrowdsale for minting.
1069  */
1070 contract MintedCrowdsale is Crowdsale {
1071 
1072   /**
1073    * @dev Overrides delivery by minting tokens upon purchase.
1074    * @param _beneficiary Token purchaser
1075    * @param _tokenAmount Number of tokens to be minted
1076    */
1077   function _deliverTokens(
1078     address _beneficiary,
1079     uint256 _tokenAmount
1080   )
1081     internal
1082   {
1083     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
1084   }
1085 }
1086 
1087 
1088 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
1089     
1090 {
1091     
1092 
1093     function name() public pure returns (string _name) {
1094         return TOKEN_NAME;
1095     }
1096 
1097     function symbol() public pure returns (string _symbol) {
1098         return TOKEN_SYMBOL;
1099     }
1100 
1101     function decimals() public pure returns (uint8 _decimals) {
1102         return TOKEN_DECIMALS_UINT8;
1103     }
1104 
1105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
1106         require(!paused);
1107         return super.transferFrom(_from, _to, _value);
1108     }
1109 
1110     function transfer(address _to, uint256 _value) public returns (bool _success) {
1111         require(!paused);
1112         return super.transfer(_to, _value);
1113     }
1114 
1115     
1116 }
1117 
1118 
1119 
1120 
1121 
1122 /**
1123  * @title RefundableCrowdsale
1124  * @dev Extension of Crowdsale contract that adds a funding goal, and
1125  * the possibility of users getting a refund if goal is not met.
1126  * Uses a RefundVault as the crowdsale's vault.
1127  */
1128 contract RefundableCrowdsale is FinalizableCrowdsale {
1129   using SafeMath for uint256;
1130 
1131   // minimum amount of funds to be raised in weis
1132   uint256 public goal;
1133 
1134   // refund vault used to hold funds while crowdsale is running
1135   RefundVault public vault;
1136 
1137   /**
1138    * @dev Constructor, creates RefundVault.
1139    * @param _goal Funding goal
1140    */
1141   constructor(uint256 _goal) public {
1142     require(_goal > 0);
1143     vault = new RefundVault(wallet);
1144     goal = _goal;
1145   }
1146 
1147   /**
1148    * @dev Investors can claim refunds here if crowdsale is unsuccessful
1149    */
1150   function claimRefund() public {
1151     require(isFinalized);
1152     require(!goalReached());
1153 
1154     vault.refund(msg.sender);
1155   }
1156 
1157   /**
1158    * @dev Checks whether funding goal was reached.
1159    * @return Whether funding goal was reached
1160    */
1161   function goalReached() public view returns (bool) {
1162     return weiRaised >= goal;
1163   }
1164 
1165   /**
1166    * @dev vault finalization task, called when owner calls finalize()
1167    */
1168   function finalization() internal {
1169     if (goalReached()) {
1170       vault.close();
1171     } else {
1172       vault.enableRefunds();
1173     }
1174 
1175     super.finalization();
1176   }
1177 
1178   /**
1179    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
1180    */
1181   function _forwardFunds() internal {
1182     vault.deposit.value(msg.value)(msg.sender);
1183   }
1184 
1185 }
1186 
1187 
1188 contract MainCrowdsale is Consts, FinalizableCrowdsale, MintedCrowdsale, CappedCrowdsale {
1189     function hasStarted() public view returns (bool) {
1190         return now >= openingTime;
1191     }
1192 
1193     function startTime() public view returns (uint256) {
1194         return openingTime;
1195     }
1196 
1197     function endTime() public view returns (uint256) {
1198         return closingTime;
1199     }
1200 
1201     function hasClosed() public view returns (bool) {
1202         return super.hasClosed() || capReached();
1203     }
1204 
1205     function hasEnded() public view returns (bool) {
1206         return hasClosed();
1207     }
1208 
1209     function finalization() internal {
1210         super.finalization();
1211 
1212         if (PAUSED) {
1213             MainToken(token).unpause();
1214         }
1215 
1216         if (!CONTINUE_MINTING) {
1217             require(MintableToken(token).finishMinting());
1218         }
1219 
1220         Ownable(token).transferOwnership(TARGET_USER);
1221     }
1222 
1223     /**
1224      * @dev Override to extend the way in which ether is converted to tokens.
1225      * @param _weiAmount Value in wei to be converted into tokens
1226      * @return Number of tokens that can be purchased with the specified _weiAmount
1227      */
1228     function _getTokenAmount(uint256 _weiAmount)
1229         internal view returns (uint256)
1230     {
1231         return _weiAmount.mul(rate).div(1 ether);
1232     }
1233 }
1234 
1235 
1236 contract BonusableCrowdsale is Consts, Crowdsale {
1237     /**
1238      * @dev Override to extend the way in which ether is converted to tokens.
1239      * @param _weiAmount Value in wei to be converted into tokens
1240      * @return Number of tokens that can be purchased with the specified _weiAmount
1241      */
1242     function _getTokenAmount(uint256 _weiAmount)
1243         internal view returns (uint256)
1244     {
1245         uint256 bonusRate = getBonusRate(_weiAmount);
1246         return _weiAmount.mul(bonusRate).div(1 ether);
1247     }
1248 
1249     function getBonusRate(uint256 _weiAmount) internal view returns (uint256) {
1250         uint256 bonusRate = rate;
1251 
1252         
1253         // apply bonus for time & weiRaised
1254         uint[3] memory weiRaisedStartsBounds = [uint(0),uint(300000000000000000000),uint(600000000000000000000)];
1255         uint[3] memory weiRaisedEndsBounds = [uint(300000000000000000000),uint(600000000000000000000),uint(900000000000000000000)];
1256         uint64[3] memory timeStartsBounds = [uint64(1540476000),uint64(1540911600),uint64(1541430000)];
1257         uint64[3] memory timeEndsBounds = [uint64(1540911600),uint64(1541430000),uint64(1541862000)];
1258         uint[3] memory weiRaisedAndTimeRates = [uint(100),uint(70),uint(50)];
1259 
1260         for (uint i = 0; i < 3; i++) {
1261             bool weiRaisedInBound = (weiRaisedStartsBounds[i] <= weiRaised) && (weiRaised < weiRaisedEndsBounds[i]);
1262             bool timeInBound = (timeStartsBounds[i] <= now) && (now < timeEndsBounds[i]);
1263             if (weiRaisedInBound && timeInBound) {
1264                 bonusRate += bonusRate * weiRaisedAndTimeRates[i] / 1000;
1265             }
1266         }
1267         
1268 
1269         
1270         // apply amount
1271         uint[2] memory weiAmountBounds = [uint(100000000000000000000),uint(20000000000000000000)];
1272         uint[2] memory weiAmountRates = [uint(0),uint(200)];
1273 
1274         for (uint j = 0; j < 2; j++) {
1275             if (_weiAmount >= weiAmountBounds[j]) {
1276                 bonusRate += bonusRate * weiAmountRates[j] / 1000;
1277                 break;
1278             }
1279         }
1280         
1281 
1282         return bonusRate;
1283     }
1284 }
1285 
1286 
1287 
1288 
1289 
1290 contract TemplateCrowdsale is Consts, MainCrowdsale
1291     
1292     , BonusableCrowdsale
1293     
1294     
1295     , RefundableCrowdsale
1296     
1297     
1298     
1299 {
1300     event Initialized();
1301     event TimesChanged(uint startTime, uint endTime, uint oldStartTime, uint oldEndTime);
1302     bool public initialized = false;
1303 
1304     constructor(MintableToken _token) public
1305         Crowdsale(10000000 * TOKEN_DECIMAL_MULTIPLIER, 0x2e2f33B0D829c844916b486ee1185B1186bc2f83, _token)
1306         TimedCrowdsale(START_TIME > now ? START_TIME : now, 1543158000)
1307         CappedCrowdsale(1300000000000000000000)
1308         
1309         RefundableCrowdsale(200000000000000000000)
1310         
1311     {
1312     }
1313 
1314     function init() public onlyOwner {
1315         require(!initialized);
1316         initialized = true;
1317 
1318         if (PAUSED) {
1319             MainToken(token).pause();
1320         }
1321 
1322         
1323         address[4] memory addresses = [address(0x65524cdb782c7a25677ff547e82982775caabe72),address(0xd7ccaccc5897c9733c4e9d4b79a2cf3fd8d78789),address(0x794e2f45fe976883fcfd1f0c9734a400aab1a053),address(0x5d58b04c9776ad8751121c68e92446c85cddf93a)];
1324         uint[4] memory amounts = [uint(100000000000000000),uint(200000000000000000),uint(200000000000000000),uint(200000000000000000)];
1325         uint64[4] memory freezes = [uint64(0),uint64(0),uint64(0),uint64(0)];
1326 
1327         for (uint i = 0; i < addresses.length; i++) {
1328             if (freezes[i] == 0) {
1329                 MainToken(token).mint(addresses[i], amounts[i]);
1330             } else {
1331                 MainToken(token).mintAndFreeze(addresses[i], amounts[i], freezes[i]);
1332             }
1333         }
1334         
1335 
1336         transferOwnership(TARGET_USER);
1337 
1338         emit Initialized();
1339     }
1340 
1341     
1342     /**
1343      * @dev override hasClosed to add minimal value logic
1344      * @return true if remained to achieve less than minimal
1345      */
1346     function hasClosed() public view returns (bool) {
1347         bool remainValue = cap.sub(weiRaised) < 100000000000000000;
1348         return super.hasClosed() || remainValue;
1349     }
1350     
1351 
1352     
1353 
1354     
1355     function setEndTime(uint _endTime) public onlyOwner {
1356         // only if CS was not ended
1357         require(now < closingTime);
1358         // only if new end time in future
1359         require(now < _endTime);
1360         require(_endTime > openingTime);
1361         emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
1362         closingTime = _endTime;
1363     }
1364     
1365 
1366     
1367 
1368     
1369 
1370     
1371     /**
1372      * @dev override purchase validation to add extra value logic.
1373      * @return true if sended more than minimal value
1374      */
1375     function _preValidatePurchase(
1376         address _beneficiary,
1377         uint256 _weiAmount
1378     )
1379         internal
1380     {
1381         
1382         require(msg.value >= 100000000000000000);
1383         
1384         
1385         require(msg.value <= 100000000000000000000);
1386         
1387         super._preValidatePurchase(_beneficiary, _weiAmount);
1388     }
1389     
1390 }