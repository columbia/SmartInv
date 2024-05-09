1 /*
2  * This program is free software: you can redistribute it and/or modify
3  * it under the terms of the GNU Lesser General Public License as published by
4  * the Free Software Foundation, either version 3 of the License, or
5  * (at your option) any later version.
6  *
7  * This program is distributed in the hope that it will be useful,
8  * but WITHOUT ANY WARRANTY; without even the implied warranty of
9  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
10  * GNU Lesser General Public License for more details.
11  *
12  * You should have received a copy of the GNU Lesser General Public License
13  * along with this program. If not, see <http://www.gnu.org/licenses/>.
14  */
15 pragma solidity ^0.4.23;
16 
17 
18 /**
19  * @title ERC20Basic
20  * @dev Simpler version of ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/179
22  */
23 contract ERC20Basic {
24   function totalSupply() public view returns (uint256);
25   function balanceOf(address who) public view returns (uint256);
26   function transfer(address to, uint256 value) public returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 
31 /**
32  * @title ERC20 interface
33  * @dev see https://github.com/ethereum/EIPs/issues/20
34  */
35 contract ERC20 is ERC20Basic {
36   function allowance(address owner, address spender)
37     public view returns (uint256);
38 
39   function transferFrom(address from, address to, uint256 value)
40     public returns (bool);
41 
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(
44     address indexed owner,
45     address indexed spender,
46     uint256 value
47   );
48 }
49 
50 
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, throws on overflow.
60   */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
63     // benefit is lost if 'b' is also tested.
64     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
65     if (a == 0) {
66       return 0;
67     }
68 
69     c = a * b;
70     assert(c / a == b);
71     return c;
72   }
73 
74   /**
75   * @dev Integer division of two numbers, truncating the quotient.
76   */
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     // uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return a / b;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     assert(b <= a);
89     return a - b;
90   }
91 
92   /**
93   * @dev Adds two numbers, throws on overflow.
94   */
95   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
96     c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 
103 /**
104  * @title Crowdsale
105  * @dev Crowdsale is a base contract for managing a token crowdsale,
106  * allowing investors to purchase tokens with ether. This contract implements
107  * such functionality in its most fundamental form and can be extended to provide additional
108  * functionality and/or custom behavior.
109  * The external interface represents the basic interface for purchasing tokens, and conform
110  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
111  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
112  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
113  * behavior.
114  */
115 contract Crowdsale {
116   using SafeMath for uint256;
117 
118   // The token being sold
119   ERC20 public token;
120 
121   // Address where funds are collected
122   address public wallet;
123 
124   // How many token units a buyer gets per wei.
125   // The rate is the conversion between wei and the smallest and indivisible token unit.
126   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
127   // 1 wei will give you 1 unit, or 0.001 TOK.
128   uint256 public rate;
129 
130   // Amount of wei raised
131   uint256 public weiRaised;
132 
133   /**
134    * Event for token purchase logging
135    * @param purchaser who paid for the tokens
136    * @param beneficiary who got the tokens
137    * @param value weis paid for purchase
138    * @param amount amount of tokens purchased
139    */
140   event TokenPurchase(
141     address indexed purchaser,
142     address indexed beneficiary,
143     uint256 value,
144     uint256 amount
145   );
146 
147   /**
148    * @param _rate Number of token units a buyer gets per wei
149    * @param _wallet Address where collected funds will be forwarded to
150    * @param _token Address of the token being sold
151    */
152   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
153     require(_rate > 0);
154     require(_wallet != address(0));
155     require(_token != address(0));
156 
157     rate = _rate;
158     wallet = _wallet;
159     token = _token;
160   }
161 
162   // -----------------------------------------
163   // Crowdsale external interface
164   // -----------------------------------------
165 
166   /**
167    * @dev fallback function ***DO NOT OVERRIDE***
168    */
169   function () external payable {
170     buyTokens(msg.sender);
171   }
172 
173   /**
174    * @dev low level token purchase ***DO NOT OVERRIDE***
175    * @param _beneficiary Address performing the token purchase
176    */
177   function buyTokens(address _beneficiary) public payable {
178 
179     uint256 weiAmount = msg.value;
180     _preValidatePurchase(_beneficiary, weiAmount);
181 
182     // calculate token amount to be created
183     uint256 tokens = _getTokenAmount(weiAmount);
184 
185     // update state
186     weiRaised = weiRaised.add(weiAmount);
187 
188     _processPurchase(_beneficiary, tokens);
189     emit TokenPurchase(
190       msg.sender,
191       _beneficiary,
192       weiAmount,
193       tokens
194     );
195 
196     _updatePurchasingState(_beneficiary, weiAmount);
197 
198     _forwardFunds();
199     _postValidatePurchase(_beneficiary, weiAmount);
200   }
201 
202   // -----------------------------------------
203   // Internal interface (extensible)
204   // -----------------------------------------
205 
206   /**
207    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
208    * @param _beneficiary Address performing the token purchase
209    * @param _weiAmount Value in wei involved in the purchase
210    */
211   function _preValidatePurchase(
212     address _beneficiary,
213     uint256 _weiAmount
214   )
215     internal
216   {
217     require(_beneficiary != address(0));
218     require(_weiAmount != 0);
219   }
220 
221   /**
222    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
223    * @param _beneficiary Address performing the token purchase
224    * @param _weiAmount Value in wei involved in the purchase
225    */
226   function _postValidatePurchase(
227     address _beneficiary,
228     uint256 _weiAmount
229   )
230     internal
231   {
232     // optional override
233   }
234 
235   /**
236    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
237    * @param _beneficiary Address performing the token purchase
238    * @param _tokenAmount Number of tokens to be emitted
239    */
240   function _deliverTokens(
241     address _beneficiary,
242     uint256 _tokenAmount
243   )
244     internal
245   {
246     token.transfer(_beneficiary, _tokenAmount);
247   }
248 
249   /**
250    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
251    * @param _beneficiary Address receiving the tokens
252    * @param _tokenAmount Number of tokens to be purchased
253    */
254   function _processPurchase(
255     address _beneficiary,
256     uint256 _tokenAmount
257   )
258     internal
259   {
260     _deliverTokens(_beneficiary, _tokenAmount);
261   }
262 
263   /**
264    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
265    * @param _beneficiary Address receiving the tokens
266    * @param _weiAmount Value in wei involved in the purchase
267    */
268   function _updatePurchasingState(
269     address _beneficiary,
270     uint256 _weiAmount
271   )
272     internal
273   {
274     // optional override
275   }
276 
277   /**
278    * @dev Override to extend the way in which ether is converted to tokens.
279    * @param _weiAmount Value in wei to be converted into tokens
280    * @return Number of tokens that can be purchased with the specified _weiAmount
281    */
282   function _getTokenAmount(uint256 _weiAmount)
283     internal view returns (uint256)
284   {
285     return _weiAmount.mul(rate);
286   }
287 
288   /**
289    * @dev Determines how ETH is stored/forwarded on purchases.
290    */
291   function _forwardFunds() internal {
292     wallet.transfer(msg.value);
293   }
294 }
295 
296 
297 
298 /**
299  * @title Ownable
300  * @dev The Ownable contract has an owner address, and provides basic authorization control
301  * functions, this simplifies the implementation of "user permissions".
302  */
303 contract Ownable {
304   address public owner;
305 
306 
307   event OwnershipRenounced(address indexed previousOwner);
308   event OwnershipTransferred(
309     address indexed previousOwner,
310     address indexed newOwner
311   );
312 
313 
314   /**
315    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
316    * account.
317    */
318   constructor() public {
319     owner = msg.sender;
320   }
321 
322   /**
323    * @dev Throws if called by any account other than the owner.
324    */
325   modifier onlyOwner() {
326     require(msg.sender == owner);
327     _;
328   }
329 
330   /**
331    * @dev Allows the current owner to relinquish control of the contract.
332    */
333   function renounceOwnership() public onlyOwner {
334     emit OwnershipRenounced(owner);
335     owner = address(0);
336   }
337 
338   /**
339    * @dev Allows the current owner to transfer control of the contract to a newOwner.
340    * @param _newOwner The address to transfer ownership to.
341    */
342   function transferOwnership(address _newOwner) public onlyOwner {
343     _transferOwnership(_newOwner);
344   }
345 
346   /**
347    * @dev Transfers control of the contract to a newOwner.
348    * @param _newOwner The address to transfer ownership to.
349    */
350   function _transferOwnership(address _newOwner) internal {
351     require(_newOwner != address(0));
352     emit OwnershipTransferred(owner, _newOwner);
353     owner = _newOwner;
354   }
355 }
356 
357 
358 /**
359  * @title TimedCrowdsale
360  * @dev Crowdsale accepting contributions only within a time frame.
361  */
362 contract TimedCrowdsale is Crowdsale {
363   using SafeMath for uint256;
364 
365   uint256 public openingTime;
366   uint256 public closingTime;
367 
368   /**
369    * @dev Reverts if not in crowdsale time range.
370    */
371   modifier onlyWhileOpen {
372     // solium-disable-next-line security/no-block-members
373     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
374     _;
375   }
376 
377   /**
378    * @dev Constructor, takes crowdsale opening and closing times.
379    * @param _openingTime Crowdsale opening time
380    * @param _closingTime Crowdsale closing time
381    */
382   constructor(uint256 _openingTime, uint256 _closingTime) public {
383     // solium-disable-next-line security/no-block-members
384     require(_openingTime >= block.timestamp);
385     require(_closingTime >= _openingTime);
386 
387     openingTime = _openingTime;
388     closingTime = _closingTime;
389   }
390 
391   /**
392    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
393    * @return Whether crowdsale period has elapsed
394    */
395   function hasClosed() public view returns (bool) {
396     // solium-disable-next-line security/no-block-members
397     return block.timestamp > closingTime;
398   }
399 
400   /**
401    * @dev Extend parent behavior requiring to be within contributing period
402    * @param _beneficiary Token purchaser
403    * @param _weiAmount Amount of wei contributed
404    */
405   function _preValidatePurchase(
406     address _beneficiary,
407     uint256 _weiAmount
408   )
409     internal
410     onlyWhileOpen
411   {
412     super._preValidatePurchase(_beneficiary, _weiAmount);
413   }
414 
415 }
416 
417 
418 /**
419  * @title FinalizableCrowdsale
420  * @dev Extension of Crowdsale where an owner can do extra work
421  * after finishing.
422  */
423 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
424   using SafeMath for uint256;
425 
426   bool public isFinalized = false;
427 
428   event Finalized();
429 
430   /**
431    * @dev Must be called after crowdsale ends, to do some extra finalization
432    * work. Calls the contract's finalization function.
433    */
434   function finalize() onlyOwner public {
435     require(!isFinalized);
436     require(hasClosed());
437 
438     finalization();
439     emit Finalized();
440 
441     isFinalized = true;
442   }
443 
444   /**
445    * @dev Can be overridden to add finalization logic. The overriding function
446    * should call super.finalization() to ensure the chain of finalization is
447    * executed entirely.
448    */
449   function finalization() internal {
450   }
451 
452 }
453 
454 
455 /**
456  * @title RefundVault
457  * @dev This contract is used for storing funds while a crowdsale
458  * is in progress. Supports refunding the money if crowdsale fails,
459  * and forwarding it if crowdsale is successful.
460  */
461 contract RefundVault is Ownable {
462   using SafeMath for uint256;
463 
464   enum State { Active, Refunding, Closed }
465 
466   mapping (address => uint256) public deposited;
467   address public wallet;
468   State public state;
469 
470   event Closed();
471   event RefundsEnabled();
472   event Refunded(address indexed beneficiary, uint256 weiAmount);
473 
474   /**
475    * @param _wallet Vault address
476    */
477   constructor(address _wallet) public {
478     require(_wallet != address(0));
479     wallet = _wallet;
480     state = State.Active;
481   }
482 
483   /**
484    * @param investor Investor address
485    */
486   function deposit(address investor) onlyOwner public payable {
487     require(state == State.Active);
488     deposited[investor] = deposited[investor].add(msg.value);
489   }
490 
491   function close() onlyOwner public {
492     require(state == State.Active);
493     state = State.Closed;
494     emit Closed();
495     wallet.transfer(address(this).balance);
496   }
497 
498   function enableRefunds() onlyOwner public {
499     require(state == State.Active);
500     state = State.Refunding;
501     emit RefundsEnabled();
502   }
503 
504   /**
505    * @param investor Investor address
506    */
507   function refund(address investor) public {
508     require(state == State.Refunding);
509     uint256 depositedValue = deposited[investor];
510     deposited[investor] = 0;
511     investor.transfer(depositedValue);
512     emit Refunded(investor, depositedValue);
513   }
514 }
515 
516 
517 
518 /**
519  * @title Basic token
520  * @dev Basic version of StandardToken, with no allowances.
521  */
522 contract BasicToken is ERC20Basic {
523   using SafeMath for uint256;
524 
525   mapping(address => uint256) balances;
526 
527   uint256 totalSupply_;
528 
529   /**
530   * @dev total number of tokens in existence
531   */
532   function totalSupply() public view returns (uint256) {
533     return totalSupply_;
534   }
535 
536   /**
537   * @dev transfer token for a specified address
538   * @param _to The address to transfer to.
539   * @param _value The amount to be transferred.
540   */
541   function transfer(address _to, uint256 _value) public returns (bool) {
542     require(_to != address(0));
543     require(_value <= balances[msg.sender]);
544 
545     balances[msg.sender] = balances[msg.sender].sub(_value);
546     balances[_to] = balances[_to].add(_value);
547     emit Transfer(msg.sender, _to, _value);
548     return true;
549   }
550 
551   /**
552   * @dev Gets the balance of the specified address.
553   * @param _owner The address to query the the balance of.
554   * @return An uint256 representing the amount owned by the passed address.
555   */
556   function balanceOf(address _owner) public view returns (uint256) {
557     return balances[_owner];
558   }
559 
560 }
561 
562 
563 /**
564  * @title Standard ERC20 token
565  *
566  * @dev Implementation of the basic standard token.
567  * @dev https://github.com/ethereum/EIPs/issues/20
568  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
569  */
570 contract StandardToken is ERC20, BasicToken {
571 
572   mapping (address => mapping (address => uint256)) internal allowed;
573 
574 
575   /**
576    * @dev Transfer tokens from one address to another
577    * @param _from address The address which you want to send tokens from
578    * @param _to address The address which you want to transfer to
579    * @param _value uint256 the amount of tokens to be transferred
580    */
581   function transferFrom(
582     address _from,
583     address _to,
584     uint256 _value
585   )
586     public
587     returns (bool)
588   {
589     require(_to != address(0));
590     require(_value <= balances[_from]);
591     require(_value <= allowed[_from][msg.sender]);
592 
593     balances[_from] = balances[_from].sub(_value);
594     balances[_to] = balances[_to].add(_value);
595     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
596     emit Transfer(_from, _to, _value);
597     return true;
598   }
599 
600   /**
601    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
602    *
603    * Beware that changing an allowance with this method brings the risk that someone may use both the old
604    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
605    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
606    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
607    * @param _spender The address which will spend the funds.
608    * @param _value The amount of tokens to be spent.
609    */
610   function approve(address _spender, uint256 _value) public returns (bool) {
611     allowed[msg.sender][_spender] = _value;
612     emit Approval(msg.sender, _spender, _value);
613     return true;
614   }
615 
616   /**
617    * @dev Function to check the amount of tokens that an owner allowed to a spender.
618    * @param _owner address The address which owns the funds.
619    * @param _spender address The address which will spend the funds.
620    * @return A uint256 specifying the amount of tokens still available for the spender.
621    */
622   function allowance(
623     address _owner,
624     address _spender
625    )
626     public
627     view
628     returns (uint256)
629   {
630     return allowed[_owner][_spender];
631   }
632 
633   /**
634    * @dev Increase the amount of tokens that an owner allowed to a spender.
635    *
636    * approve should be called when allowed[_spender] == 0. To increment
637    * allowed value is better to use this function to avoid 2 calls (and wait until
638    * the first transaction is mined)
639    * From MonolithDAO Token.sol
640    * @param _spender The address which will spend the funds.
641    * @param _addedValue The amount of tokens to increase the allowance by.
642    */
643   function increaseApproval(
644     address _spender,
645     uint _addedValue
646   )
647     public
648     returns (bool)
649   {
650     allowed[msg.sender][_spender] = (
651       allowed[msg.sender][_spender].add(_addedValue));
652     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
653     return true;
654   }
655 
656   /**
657    * @dev Decrease the amount of tokens that an owner allowed to a spender.
658    *
659    * approve should be called when allowed[_spender] == 0. To decrement
660    * allowed value is better to use this function to avoid 2 calls (and wait until
661    * the first transaction is mined)
662    * From MonolithDAO Token.sol
663    * @param _spender The address which will spend the funds.
664    * @param _subtractedValue The amount of tokens to decrease the allowance by.
665    */
666   function decreaseApproval(
667     address _spender,
668     uint _subtractedValue
669   )
670     public
671     returns (bool)
672   {
673     uint oldValue = allowed[msg.sender][_spender];
674     if (_subtractedValue > oldValue) {
675       allowed[msg.sender][_spender] = 0;
676     } else {
677       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
678     }
679     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
680     return true;
681   }
682 
683 }
684 
685 
686 /**
687  * @title Mintable token
688  * @dev Simple ERC20 Token example, with mintable token creation
689  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
690  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
691  */
692 contract MintableToken is StandardToken, Ownable {
693   event Mint(address indexed to, uint256 amount);
694   event MintFinished();
695 
696   bool public mintingFinished = false;
697 
698 
699   modifier canMint() {
700     require(!mintingFinished);
701     _;
702   }
703 
704   modifier hasMintPermission() {
705     require(msg.sender == owner);
706     _;
707   }
708 
709   /**
710    * @dev Function to mint tokens
711    * @param _to The address that will receive the minted tokens.
712    * @param _amount The amount of tokens to mint.
713    * @return A boolean that indicates if the operation was successful.
714    */
715   function mint(
716     address _to,
717     uint256 _amount
718   )
719     hasMintPermission
720     canMint
721     public
722     returns (bool)
723   {
724     totalSupply_ = totalSupply_.add(_amount);
725     balances[_to] = balances[_to].add(_amount);
726     emit Mint(_to, _amount);
727     emit Transfer(address(0), _to, _amount);
728     return true;
729   }
730 
731   /**
732    * @dev Function to stop minting new tokens.
733    * @return True if the operation was successful.
734    */
735   function finishMinting() onlyOwner canMint public returns (bool) {
736     mintingFinished = true;
737     emit MintFinished();
738     return true;
739   }
740 }
741 
742 
743 contract FreezableToken is StandardToken {
744     // freezing chains
745     mapping (bytes32 => uint64) internal chains;
746     // freezing amounts for each chain
747     mapping (bytes32 => uint) internal freezings;
748     // total freezing balance per address
749     mapping (address => uint) internal freezingBalance;
750 
751     event Freezed(address indexed to, uint64 release, uint amount);
752     event Released(address indexed owner, uint amount);
753 
754     /**
755      * @dev Gets the balance of the specified address include freezing tokens.
756      * @param _owner The address to query the the balance of.
757      * @return An uint256 representing the amount owned by the passed address.
758      */
759     function balanceOf(address _owner) public view returns (uint256 balance) {
760         return super.balanceOf(_owner) + freezingBalance[_owner];
761     }
762 
763     /**
764      * @dev Gets the balance of the specified address without freezing tokens.
765      * @param _owner The address to query the the balance of.
766      * @return An uint256 representing the amount owned by the passed address.
767      */
768     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
769         return super.balanceOf(_owner);
770     }
771 
772     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
773         return freezingBalance[_owner];
774     }
775 
776     /**
777      * @dev gets freezing count
778      * @param _addr Address of freeze tokens owner.
779      */
780     function freezingCount(address _addr) public view returns (uint count) {
781         uint64 release = chains[toKey(_addr, 0)];
782         while (release != 0) {
783             count++;
784             release = chains[toKey(_addr, release)];
785         }
786     }
787 
788     /**
789      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
790      * @param _addr Address of freeze tokens owner.
791      * @param _index Freezing portion index. It ordered by release date descending.
792      */
793     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
794         for (uint i = 0; i < _index + 1; i++) {
795             _release = chains[toKey(_addr, _release)];
796             if (_release == 0) {
797                 return;
798             }
799         }
800         _balance = freezings[toKey(_addr, _release)];
801     }
802 
803     /**
804      * @dev freeze your tokens to the specified address.
805      *      Be careful, gas usage is not deterministic,
806      *      and depends on how many freezes _to address already has.
807      * @param _to Address to which token will be freeze.
808      * @param _amount Amount of token to freeze.
809      * @param _until Release date, must be in future.
810      */
811     function freezeTo(address _to, uint _amount, uint64 _until) public {
812         require(_to != address(0));
813         require(_amount <= balances[msg.sender]);
814 
815         balances[msg.sender] = balances[msg.sender].sub(_amount);
816 
817         bytes32 currentKey = toKey(_to, _until);
818         freezings[currentKey] = freezings[currentKey].add(_amount);
819         freezingBalance[_to] = freezingBalance[_to].add(_amount);
820 
821         freeze(_to, _until);
822         emit Transfer(msg.sender, _to, _amount);
823         emit Freezed(_to, _until, _amount);
824     }
825 
826     /**
827      * @dev release first available freezing tokens.
828      */
829     function releaseOnce() public {
830         bytes32 headKey = toKey(msg.sender, 0);
831         uint64 head = chains[headKey];
832         require(head != 0);
833         require(uint64(block.timestamp) > head);
834         bytes32 currentKey = toKey(msg.sender, head);
835 
836         uint64 next = chains[currentKey];
837 
838         uint amount = freezings[currentKey];
839         delete freezings[currentKey];
840 
841         balances[msg.sender] = balances[msg.sender].add(amount);
842         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
843 
844         if (next == 0) {
845             delete chains[headKey];
846         } else {
847             chains[headKey] = next;
848             delete chains[currentKey];
849         }
850         emit Released(msg.sender, amount);
851     }
852 
853     /**
854      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
855      * @return how many tokens was released
856      */
857     function releaseAll() public returns (uint tokens) {
858         uint release;
859         uint balance;
860         (release, balance) = getFreezing(msg.sender, 0);
861         while (release != 0 && block.timestamp > release) {
862             releaseOnce();
863             tokens += balance;
864             (release, balance) = getFreezing(msg.sender, 0);
865         }
866     }
867 
868     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
869         // WISH masc to increase entropy
870         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
871         assembly {
872             result := or(result, mul(_addr, 0x10000000000000000))
873             result := or(result, _release)
874         }
875     }
876 
877     function freeze(address _to, uint64 _until) internal {
878         require(_until > block.timestamp);
879         bytes32 key = toKey(_to, _until);
880         bytes32 parentKey = toKey(_to, uint64(0));
881         uint64 next = chains[parentKey];
882 
883         if (next == 0) {
884             chains[parentKey] = _until;
885             return;
886         }
887 
888         bytes32 nextKey = toKey(_to, next);
889         uint parent;
890 
891         while (next != 0 && _until > next) {
892             parent = next;
893             parentKey = nextKey;
894 
895             next = chains[nextKey];
896             nextKey = toKey(_to, next);
897         }
898 
899         if (_until == next) {
900             return;
901         }
902 
903         if (next != 0) {
904             chains[key] = next;
905         }
906 
907         chains[parentKey] = _until;
908     }
909 }
910 
911 
912 /**
913  * @title Burnable Token
914  * @dev Token that can be irreversibly burned (destroyed).
915  */
916 contract BurnableToken is BasicToken {
917 
918   event Burn(address indexed burner, uint256 value);
919 
920   /**
921    * @dev Burns a specific amount of tokens.
922    * @param _value The amount of token to be burned.
923    */
924   function burn(uint256 _value) public {
925     _burn(msg.sender, _value);
926   }
927 
928   function _burn(address _who, uint256 _value) internal {
929     require(_value <= balances[_who]);
930     // no need to require value <= totalSupply, since that would imply the
931     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
932 
933     balances[_who] = balances[_who].sub(_value);
934     totalSupply_ = totalSupply_.sub(_value);
935     emit Burn(_who, _value);
936     emit Transfer(_who, address(0), _value);
937   }
938 }
939 
940 
941 
942 /**
943  * @title Pausable
944  * @dev Base contract which allows children to implement an emergency stop mechanism.
945  */
946 contract Pausable is Ownable {
947   event Pause();
948   event Unpause();
949 
950   bool public paused = false;
951 
952 
953   /**
954    * @dev Modifier to make a function callable only when the contract is not paused.
955    */
956   modifier whenNotPaused() {
957     require(!paused);
958     _;
959   }
960 
961   /**
962    * @dev Modifier to make a function callable only when the contract is paused.
963    */
964   modifier whenPaused() {
965     require(paused);
966     _;
967   }
968 
969   /**
970    * @dev called by the owner to pause, triggers stopped state
971    */
972   function pause() onlyOwner whenNotPaused public {
973     paused = true;
974     emit Pause();
975   }
976 
977   /**
978    * @dev called by the owner to unpause, returns to normal state
979    */
980   function unpause() onlyOwner whenPaused public {
981     paused = false;
982     emit Unpause();
983   }
984 }
985 
986 
987 contract FreezableMintableToken is FreezableToken, MintableToken {
988     /**
989      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
990      *      Be careful, gas usage is not deterministic,
991      *      and depends on how many freezes _to address already has.
992      * @param _to Address to which token will be freeze.
993      * @param _amount Amount of token to mint and freeze.
994      * @param _until Release date, must be in future.
995      * @return A boolean that indicates if the operation was successful.
996      */
997     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
998         totalSupply_ = totalSupply_.add(_amount);
999 
1000         bytes32 currentKey = toKey(_to, _until);
1001         freezings[currentKey] = freezings[currentKey].add(_amount);
1002         freezingBalance[_to] = freezingBalance[_to].add(_amount);
1003 
1004         freeze(_to, _until);
1005         emit Mint(_to, _amount);
1006         emit Freezed(_to, _until, _amount);
1007         emit Transfer(msg.sender, _to, _amount);
1008         return true;
1009     }
1010 }
1011 
1012 
1013 
1014 contract Consts {
1015     uint public constant TOKEN_DECIMALS = 18;
1016     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
1017     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
1018 
1019     string public constant TOKEN_NAME = "Cpollo";
1020     string public constant TOKEN_SYMBOL = "CPLO";
1021     bool public constant PAUSED = false;
1022     address public constant TARGET_USER = 0x1415241a0025290E03B97Ab3922DF216D0d77d15;
1023     
1024     uint public constant START_TIME = 1534737600;
1025     
1026     bool public constant CONTINUE_MINTING = false;
1027 }
1028 
1029 
1030 
1031 
1032 /**
1033  * @title CappedCrowdsale
1034  * @dev Crowdsale with a limit for total contributions.
1035  */
1036 contract CappedCrowdsale is Crowdsale {
1037   using SafeMath for uint256;
1038 
1039   uint256 public cap;
1040 
1041   /**
1042    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
1043    * @param _cap Max amount of wei to be contributed
1044    */
1045   constructor(uint256 _cap) public {
1046     require(_cap > 0);
1047     cap = _cap;
1048   }
1049 
1050   /**
1051    * @dev Checks whether the cap has been reached.
1052    * @return Whether the cap was reached
1053    */
1054   function capReached() public view returns (bool) {
1055     return weiRaised >= cap;
1056   }
1057 
1058   /**
1059    * @dev Extend parent behavior requiring purchase to respect the funding cap.
1060    * @param _beneficiary Token purchaser
1061    * @param _weiAmount Amount of wei contributed
1062    */
1063   function _preValidatePurchase(
1064     address _beneficiary,
1065     uint256 _weiAmount
1066   )
1067     internal
1068   {
1069     super._preValidatePurchase(_beneficiary, _weiAmount);
1070     require(weiRaised.add(_weiAmount) <= cap);
1071   }
1072 
1073 }
1074 
1075 
1076 /**
1077  * @title MintedCrowdsale
1078  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1079  * Token ownership should be transferred to MintedCrowdsale for minting.
1080  */
1081 contract MintedCrowdsale is Crowdsale {
1082 
1083   /**
1084    * @dev Overrides delivery by minting tokens upon purchase.
1085    * @param _beneficiary Token purchaser
1086    * @param _tokenAmount Number of tokens to be minted
1087    */
1088   function _deliverTokens(
1089     address _beneficiary,
1090     uint256 _tokenAmount
1091   )
1092     internal
1093   {
1094     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
1095   }
1096 }
1097 
1098 
1099 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
1100     
1101 {
1102     
1103 
1104     function name() public pure returns (string _name) {
1105         return TOKEN_NAME;
1106     }
1107 
1108     function symbol() public pure returns (string _symbol) {
1109         return TOKEN_SYMBOL;
1110     }
1111 
1112     function decimals() public pure returns (uint8 _decimals) {
1113         return TOKEN_DECIMALS_UINT8;
1114     }
1115 
1116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
1117         require(!paused);
1118         return super.transferFrom(_from, _to, _value);
1119     }
1120 
1121     function transfer(address _to, uint256 _value) public returns (bool _success) {
1122         require(!paused);
1123         return super.transfer(_to, _value);
1124     }
1125 
1126     
1127 }
1128 
1129 
1130 
1131 
1132 
1133 /**
1134  * @title RefundableCrowdsale
1135  * @dev Extension of Crowdsale contract that adds a funding goal, and
1136  * the possibility of users getting a refund if goal is not met.
1137  * Uses a RefundVault as the crowdsale's vault.
1138  */
1139 contract RefundableCrowdsale is FinalizableCrowdsale {
1140   using SafeMath for uint256;
1141 
1142   // minimum amount of funds to be raised in weis
1143   uint256 public goal;
1144 
1145   // refund vault used to hold funds while crowdsale is running
1146   RefundVault public vault;
1147 
1148   /**
1149    * @dev Constructor, creates RefundVault.
1150    * @param _goal Funding goal
1151    */
1152   constructor(uint256 _goal) public {
1153     require(_goal > 0);
1154     vault = new RefundVault(wallet);
1155     goal = _goal;
1156   }
1157 
1158   /**
1159    * @dev Investors can claim refunds here if crowdsale is unsuccessful
1160    */
1161   function claimRefund() public {
1162     require(isFinalized);
1163     require(!goalReached());
1164 
1165     vault.refund(msg.sender);
1166   }
1167 
1168   /**
1169    * @dev Checks whether funding goal was reached.
1170    * @return Whether funding goal was reached
1171    */
1172   function goalReached() public view returns (bool) {
1173     return weiRaised >= goal;
1174   }
1175 
1176   /**
1177    * @dev vault finalization task, called when owner calls finalize()
1178    */
1179   function finalization() internal {
1180     if (goalReached()) {
1181       vault.close();
1182     } else {
1183       vault.enableRefunds();
1184     }
1185 
1186     super.finalization();
1187   }
1188 
1189   /**
1190    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
1191    */
1192   function _forwardFunds() internal {
1193     vault.deposit.value(msg.value)(msg.sender);
1194   }
1195 
1196 }
1197 
1198 
1199 contract MainCrowdsale is Consts, FinalizableCrowdsale, MintedCrowdsale, CappedCrowdsale {
1200     function hasStarted() public view returns (bool) {
1201         return now >= openingTime;
1202     }
1203 
1204     function startTime() public view returns (uint256) {
1205         return openingTime;
1206     }
1207 
1208     function endTime() public view returns (uint256) {
1209         return closingTime;
1210     }
1211 
1212     function hasClosed() public view returns (bool) {
1213         return super.hasClosed() || capReached();
1214     }
1215 
1216     function hasEnded() public view returns (bool) {
1217         return hasClosed();
1218     }
1219 
1220     function finalization() internal {
1221         super.finalization();
1222 
1223         if (PAUSED) {
1224             MainToken(token).unpause();
1225         }
1226 
1227         if (!CONTINUE_MINTING) {
1228             require(MintableToken(token).finishMinting());
1229         }
1230 
1231         Ownable(token).transferOwnership(TARGET_USER);
1232     }
1233 
1234     /**
1235      * @dev Override to extend the way in which ether is converted to tokens.
1236      * @param _weiAmount Value in wei to be converted into tokens
1237      * @return Number of tokens that can be purchased with the specified _weiAmount
1238      */
1239     function _getTokenAmount(uint256 _weiAmount)
1240         internal view returns (uint256)
1241     {
1242         return _weiAmount.mul(rate).div(1 ether);
1243     }
1244 }
1245 
1246 
1247 
1248 contract TemplateCrowdsale is Consts, MainCrowdsale
1249     
1250     
1251     , RefundableCrowdsale
1252     
1253     
1254     
1255 {
1256     event Initialized();
1257     event TimesChanged(uint startTime, uint endTime, uint oldStartTime, uint oldEndTime);
1258     bool public initialized = false;
1259 
1260     constructor(MintableToken _token) public
1261         Crowdsale(200000 * TOKEN_DECIMAL_MULTIPLIER, 0x1415241a0025290E03B97Ab3922DF216D0d77d15, _token)
1262         TimedCrowdsale(START_TIME > now ? START_TIME : now, 1538366400)
1263         CappedCrowdsale(50000000000000000000000)
1264         
1265         RefundableCrowdsale(300000000000000000000)
1266         
1267     {
1268     }
1269 
1270     function init() public onlyOwner {
1271         require(!initialized);
1272         initialized = true;
1273 
1274         if (PAUSED) {
1275             MainToken(token).pause();
1276         }
1277 
1278         
1279         address[4] memory addresses = [address(0x1415241a0025290e03b97ab3922df216d0d77d15),address(0x1415241a0025290e03b97ab3922df216d0d77d15),address(0x1415241a0025290e03b97ab3922df216d0d77d15),address(0xf0cc0bd6f0b597d8d9e1f4e11785764c0d171499)];
1280         uint[4] memory amounts = [uint(1500000000000000000000000000),uint(1500000000000000000000000000),uint(2000000000000000000000000000),uint(5000000000000000000000000000)];
1281         uint64[4] memory freezes = [uint64(0),uint64(0),uint64(0),uint64(1538366461)];
1282 
1283         for (uint i = 0; i < addresses.length; i++) {
1284             if (freezes[i] == 0) {
1285                 MainToken(token).mint(addresses[i], amounts[i]);
1286             } else {
1287                 MainToken(token).mintAndFreeze(addresses[i], amounts[i], freezes[i]);
1288             }
1289         }
1290         
1291 
1292         transferOwnership(TARGET_USER);
1293 
1294         emit Initialized();
1295     }
1296 
1297     
1298 
1299     
1300     function setStartTime(uint _startTime) public onlyOwner {
1301         // only if CS was not started
1302         require(now < openingTime);
1303         // only move time to future
1304         require(_startTime > openingTime);
1305         require(_startTime < closingTime);
1306         emit TimesChanged(_startTime, closingTime, openingTime, closingTime);
1307         openingTime = _startTime;
1308     }
1309     
1310 
1311     
1312     function setEndTime(uint _endTime) public onlyOwner {
1313         // only if CS was not ended
1314         require(now < closingTime);
1315         // only if new end time in future
1316         require(now < _endTime);
1317         require(_endTime > openingTime);
1318         emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
1319         closingTime = _endTime;
1320     }
1321     
1322 
1323     
1324     function setTimes(uint _startTime, uint _endTime) public onlyOwner {
1325         require(_endTime > _startTime);
1326         uint oldStartTime = openingTime;
1327         uint oldEndTime = closingTime;
1328         bool changed = false;
1329         if (_startTime != oldStartTime) {
1330             require(_startTime > now);
1331             // only if CS was not started
1332             require(now < oldStartTime);
1333             // only move time to future
1334             require(_startTime > oldStartTime);
1335 
1336             openingTime = _startTime;
1337             changed = true;
1338         }
1339         if (_endTime != oldEndTime) {
1340             // only if CS was not ended
1341             require(now < oldEndTime);
1342             // end time in future
1343             require(now < _endTime);
1344 
1345             closingTime = _endTime;
1346             changed = true;
1347         }
1348 
1349         if (changed) {
1350             emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
1351         }
1352     }
1353     
1354 
1355     
1356 
1357     
1358 }