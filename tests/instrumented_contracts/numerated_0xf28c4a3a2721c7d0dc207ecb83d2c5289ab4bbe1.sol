1 /*
2 GenPay ICO
3 http://genpay.io
4  */
5 pragma solidity ^0.4.23;
6 
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   function totalSupply() public view returns (uint256);
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender)
27     public view returns (uint256);
28 
29   function transferFrom(address from, address to, uint256 value)
30     public returns (bool);
31 
32   function approve(address spender, uint256 value) public returns (bool);
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, throws on overflow.
50   */
51   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
53     // benefit is lost if 'b' is also tested.
54     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55     if (a == 0) {
56       return 0;
57     }
58 
59     c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers, truncating the quotient.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     // uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return a / b;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   /**
83   * @dev Adds two numbers, throws on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
86     c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 
93 /**
94  * @title Crowdsale
95  * @dev Crowdsale is a base contract for managing a token crowdsale,
96  * allowing investors to purchase tokens with ether. This contract implements
97  * such functionality in its most fundamental form and can be extended to provide additional
98  * functionality and/or custom behavior.
99  * The external interface represents the basic interface for purchasing tokens, and conform
100  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
101  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
102  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
103  * behavior.
104  */
105 contract Crowdsale {
106   using SafeMath for uint256;
107 
108   // The token being sold
109   ERC20 public token;
110 
111   // Address where funds are collected
112   address public wallet;
113 
114   // How many token units a buyer gets per wei.
115   // The rate is the conversion between wei and the smallest and indivisible token unit.
116   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
117   // 1 wei will give you 1 unit, or 0.001 TOK.
118   uint256 public rate;
119 
120   // Amount of wei raised
121   uint256 public weiRaised;
122 
123   /**
124    * Event for token purchase logging
125    * @param purchaser who paid for the tokens
126    * @param beneficiary who got the tokens
127    * @param value weis paid for purchase
128    * @param amount amount of tokens purchased
129    */
130   event TokenPurchase(
131     address indexed purchaser,
132     address indexed beneficiary,
133     uint256 value,
134     uint256 amount
135   );
136 
137   /**
138    * @param _rate Number of token units a buyer gets per wei
139    * @param _wallet Address where collected funds will be forwarded to
140    * @param _token Address of the token being sold
141    */
142   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
143     require(_rate > 0);
144     require(_wallet != address(0));
145     require(_token != address(0));
146 
147     rate = _rate;
148     wallet = _wallet;
149     token = _token;
150   }
151 
152   // -----------------------------------------
153   // Crowdsale external interface
154   // -----------------------------------------
155 
156   /**
157    * @dev fallback function ***DO NOT OVERRIDE***
158    */
159   function () external payable {
160     buyTokens(msg.sender);
161   }
162 
163   /**
164    * @dev low level token purchase ***DO NOT OVERRIDE***
165    * @param _beneficiary Address performing the token purchase
166    */
167   function buyTokens(address _beneficiary) public payable {
168 
169     uint256 weiAmount = msg.value;
170     _preValidatePurchase(_beneficiary, weiAmount);
171 
172     // calculate token amount to be created
173     uint256 tokens = _getTokenAmount(weiAmount);
174 
175     // update state
176     weiRaised = weiRaised.add(weiAmount);
177 
178     _processPurchase(_beneficiary, tokens);
179     emit TokenPurchase(
180       msg.sender,
181       _beneficiary,
182       weiAmount,
183       tokens
184     );
185 
186     _updatePurchasingState(_beneficiary, weiAmount);
187 
188     _forwardFunds();
189     _postValidatePurchase(_beneficiary, weiAmount);
190   }
191 
192   // -----------------------------------------
193   // Internal interface (extensible)
194   // -----------------------------------------
195 
196   /**
197    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
198    * @param _beneficiary Address performing the token purchase
199    * @param _weiAmount Value in wei involved in the purchase
200    */
201   function _preValidatePurchase(
202     address _beneficiary,
203     uint256 _weiAmount
204   )
205     internal
206   {
207     require(_beneficiary != address(0));
208     require(_weiAmount != 0);
209   }
210 
211   /**
212    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
213    * @param _beneficiary Address performing the token purchase
214    * @param _weiAmount Value in wei involved in the purchase
215    */
216   function _postValidatePurchase(
217     address _beneficiary,
218     uint256 _weiAmount
219   )
220     internal
221   {
222     // optional override
223   }
224 
225   /**
226    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
227    * @param _beneficiary Address performing the token purchase
228    * @param _tokenAmount Number of tokens to be emitted
229    */
230   function _deliverTokens(
231     address _beneficiary,
232     uint256 _tokenAmount
233   )
234     internal
235   {
236     token.transfer(_beneficiary, _tokenAmount);
237   }
238 
239   /**
240    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
241    * @param _beneficiary Address receiving the tokens
242    * @param _tokenAmount Number of tokens to be purchased
243    */
244   function _processPurchase(
245     address _beneficiary,
246     uint256 _tokenAmount
247   )
248     internal
249   {
250     _deliverTokens(_beneficiary, _tokenAmount);
251   }
252 
253   /**
254    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
255    * @param _beneficiary Address receiving the tokens
256    * @param _weiAmount Value in wei involved in the purchase
257    */
258   function _updatePurchasingState(
259     address _beneficiary,
260     uint256 _weiAmount
261   )
262     internal
263   {
264     // optional override
265   }
266 
267   /**
268    * @dev Override to extend the way in which ether is converted to tokens.
269    * @param _weiAmount Value in wei to be converted into tokens
270    * @return Number of tokens that can be purchased with the specified _weiAmount
271    */
272   function _getTokenAmount(uint256 _weiAmount)
273     internal view returns (uint256)
274   {
275     return _weiAmount.mul(rate);
276   }
277 
278   /**
279    * @dev Determines how ETH is stored/forwarded on purchases.
280    */
281   function _forwardFunds() internal {
282     wallet.transfer(msg.value);
283   }
284 }
285 
286 
287 
288 /**
289  * @title Ownable
290  * @dev The Ownable contract has an owner address, and provides basic authorization control
291  * functions, this simplifies the implementation of "user permissions".
292  */
293 contract Ownable {
294   address public owner;
295 
296 
297   event OwnershipRenounced(address indexed previousOwner);
298   event OwnershipTransferred(
299     address indexed previousOwner,
300     address indexed newOwner
301   );
302 
303 
304   /**
305    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
306    * account.
307    */
308   constructor() public {
309     owner = msg.sender;
310   }
311 
312   /**
313    * @dev Throws if called by any account other than the owner.
314    */
315   modifier onlyOwner() {
316     require(msg.sender == owner);
317     _;
318   }
319 
320   /**
321    * @dev Allows the current owner to relinquish control of the contract.
322    */
323   function renounceOwnership() public onlyOwner {
324     emit OwnershipRenounced(owner);
325     owner = address(0);
326   }
327 
328   /**
329    * @dev Allows the current owner to transfer control of the contract to a newOwner.
330    * @param _newOwner The address to transfer ownership to.
331    */
332   function transferOwnership(address _newOwner) public onlyOwner {
333     _transferOwnership(_newOwner);
334   }
335 
336   /**
337    * @dev Transfers control of the contract to a newOwner.
338    * @param _newOwner The address to transfer ownership to.
339    */
340   function _transferOwnership(address _newOwner) internal {
341     require(_newOwner != address(0));
342     emit OwnershipTransferred(owner, _newOwner);
343     owner = _newOwner;
344   }
345 }
346 
347 
348 /**
349  * @title TimedCrowdsale
350  * @dev Crowdsale accepting contributions only within a time frame.
351  */
352 contract TimedCrowdsale is Crowdsale {
353   using SafeMath for uint256;
354 
355   uint256 public openingTime;
356   uint256 public closingTime;
357 
358   /**
359    * @dev Reverts if not in crowdsale time range.
360    */
361   modifier onlyWhileOpen {
362     // solium-disable-next-line security/no-block-members
363     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
364     _;
365   }
366 
367   /**
368    * @dev Constructor, takes crowdsale opening and closing times.
369    * @param _openingTime Crowdsale opening time
370    * @param _closingTime Crowdsale closing time
371    */
372   constructor(uint256 _openingTime, uint256 _closingTime) public {
373     // solium-disable-next-line security/no-block-members
374     require(_openingTime >= block.timestamp);
375     require(_closingTime >= _openingTime);
376 
377     openingTime = _openingTime;
378     closingTime = _closingTime;
379   }
380 
381   /**
382    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
383    * @return Whether crowdsale period has elapsed
384    */
385   function hasClosed() public view returns (bool) {
386     // solium-disable-next-line security/no-block-members
387     return block.timestamp > closingTime;
388   }
389 
390   /**
391    * @dev Extend parent behavior requiring to be within contributing period
392    * @param _beneficiary Token purchaser
393    * @param _weiAmount Amount of wei contributed
394    */
395   function _preValidatePurchase(
396     address _beneficiary,
397     uint256 _weiAmount
398   )
399     internal
400     onlyWhileOpen
401   {
402     super._preValidatePurchase(_beneficiary, _weiAmount);
403   }
404 
405 }
406 
407 
408 
409 /**
410  * @title Basic token
411  * @dev Basic version of StandardToken, with no allowances.
412  */
413 contract BasicToken is ERC20Basic {
414   using SafeMath for uint256;
415 
416   mapping(address => uint256) balances;
417 
418   uint256 totalSupply_;
419 
420   /**
421   * @dev total number of tokens in existence
422   */
423   function totalSupply() public view returns (uint256) {
424     return totalSupply_;
425   }
426 
427   /**
428   * @dev transfer token for a specified address
429   * @param _to The address to transfer to.
430   * @param _value The amount to be transferred.
431   */
432   function transfer(address _to, uint256 _value) public returns (bool) {
433     require(_to != address(0));
434     require(_value <= balances[msg.sender]);
435 
436     balances[msg.sender] = balances[msg.sender].sub(_value);
437     balances[_to] = balances[_to].add(_value);
438     emit Transfer(msg.sender, _to, _value);
439     return true;
440   }
441 
442   /**
443   * @dev Gets the balance of the specified address.
444   * @param _owner The address to query the the balance of.
445   * @return An uint256 representing the amount owned by the passed address.
446   */
447   function balanceOf(address _owner) public view returns (uint256) {
448     return balances[_owner];
449   }
450 
451 }
452 
453 
454 /**
455  * @title Standard ERC20 token
456  *
457  * @dev Implementation of the basic standard token.
458  * @dev https://github.com/ethereum/EIPs/issues/20
459  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
460  */
461 contract StandardToken is ERC20, BasicToken {
462 
463   mapping (address => mapping (address => uint256)) internal allowed;
464 
465 
466   /**
467    * @dev Transfer tokens from one address to another
468    * @param _from address The address which you want to send tokens from
469    * @param _to address The address which you want to transfer to
470    * @param _value uint256 the amount of tokens to be transferred
471    */
472   function transferFrom(
473     address _from,
474     address _to,
475     uint256 _value
476   )
477     public
478     returns (bool)
479   {
480     require(_to != address(0));
481     require(_value <= balances[_from]);
482     require(_value <= allowed[_from][msg.sender]);
483 
484     balances[_from] = balances[_from].sub(_value);
485     balances[_to] = balances[_to].add(_value);
486     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
487     emit Transfer(_from, _to, _value);
488     return true;
489   }
490 
491   /**
492    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
493    *
494    * Beware that changing an allowance with this method brings the risk that someone may use both the old
495    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
496    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
497    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
498    * @param _spender The address which will spend the funds.
499    * @param _value The amount of tokens to be spent.
500    */
501   function approve(address _spender, uint256 _value) public returns (bool) {
502     allowed[msg.sender][_spender] = _value;
503     emit Approval(msg.sender, _spender, _value);
504     return true;
505   }
506 
507   /**
508    * @dev Function to check the amount of tokens that an owner allowed to a spender.
509    * @param _owner address The address which owns the funds.
510    * @param _spender address The address which will spend the funds.
511    * @return A uint256 specifying the amount of tokens still available for the spender.
512    */
513   function allowance(
514     address _owner,
515     address _spender
516    )
517     public
518     view
519     returns (uint256)
520   {
521     return allowed[_owner][_spender];
522   }
523 
524   /**
525    * @dev Increase the amount of tokens that an owner allowed to a spender.
526    *
527    * approve should be called when allowed[_spender] == 0. To increment
528    * allowed value is better to use this function to avoid 2 calls (and wait until
529    * the first transaction is mined)
530    * From MonolithDAO Token.sol
531    * @param _spender The address which will spend the funds.
532    * @param _addedValue The amount of tokens to increase the allowance by.
533    */
534   function increaseApproval(
535     address _spender,
536     uint _addedValue
537   )
538     public
539     returns (bool)
540   {
541     allowed[msg.sender][_spender] = (
542       allowed[msg.sender][_spender].add(_addedValue));
543     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
544     return true;
545   }
546 
547   /**
548    * @dev Decrease the amount of tokens that an owner allowed to a spender.
549    *
550    * approve should be called when allowed[_spender] == 0. To decrement
551    * allowed value is better to use this function to avoid 2 calls (and wait until
552    * the first transaction is mined)
553    * From MonolithDAO Token.sol
554    * @param _spender The address which will spend the funds.
555    * @param _subtractedValue The amount of tokens to decrease the allowance by.
556    */
557   function decreaseApproval(
558     address _spender,
559     uint _subtractedValue
560   )
561     public
562     returns (bool)
563   {
564     uint oldValue = allowed[msg.sender][_spender];
565     if (_subtractedValue > oldValue) {
566       allowed[msg.sender][_spender] = 0;
567     } else {
568       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
569     }
570     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
571     return true;
572   }
573 
574 }
575 
576 
577 /**
578  * @title Mintable token
579  * @dev Simple ERC20 Token example, with mintable token creation
580  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
581  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
582  */
583 contract MintableToken is StandardToken, Ownable {
584   event Mint(address indexed to, uint256 amount);
585   event MintFinished();
586 
587   bool public mintingFinished = false;
588 
589 
590   modifier canMint() {
591     require(!mintingFinished);
592     _;
593   }
594 
595   modifier hasMintPermission() {
596     require(msg.sender == owner);
597     _;
598   }
599 
600   /**
601    * @dev Function to mint tokens
602    * @param _to The address that will receive the minted tokens.
603    * @param _amount The amount of tokens to mint.
604    * @return A boolean that indicates if the operation was successful.
605    */
606   function mint(
607     address _to,
608     uint256 _amount
609   )
610     hasMintPermission
611     canMint
612     public
613     returns (bool)
614   {
615     totalSupply_ = totalSupply_.add(_amount);
616     balances[_to] = balances[_to].add(_amount);
617     emit Mint(_to, _amount);
618     emit Transfer(address(0), _to, _amount);
619     return true;
620   }
621 
622   /**
623    * @dev Function to stop minting new tokens.
624    * @return True if the operation was successful.
625    */
626   function finishMinting() onlyOwner canMint public returns (bool) {
627     mintingFinished = true;
628     emit MintFinished();
629     return true;
630   }
631 }
632 
633 
634 contract FreezableToken is StandardToken {
635     // freezing chains
636     mapping (bytes32 => uint64) internal chains;
637     // freezing amounts for each chain
638     mapping (bytes32 => uint) internal freezings;
639     // total freezing balance per address
640     mapping (address => uint) internal freezingBalance;
641 
642     event Freezed(address indexed to, uint64 release, uint amount);
643     event Released(address indexed owner, uint amount);
644 
645     /**
646      * @dev Gets the balance of the specified address include freezing tokens.
647      * @param _owner The address to query the the balance of.
648      * @return An uint256 representing the amount owned by the passed address.
649      */
650     function balanceOf(address _owner) public view returns (uint256 balance) {
651         return super.balanceOf(_owner) + freezingBalance[_owner];
652     }
653 
654     /**
655      * @dev Gets the balance of the specified address without freezing tokens.
656      * @param _owner The address to query the the balance of.
657      * @return An uint256 representing the amount owned by the passed address.
658      */
659     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
660         return super.balanceOf(_owner);
661     }
662 
663     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
664         return freezingBalance[_owner];
665     }
666 
667     /**
668      * @dev gets freezing count
669      * @param _addr Address of freeze tokens owner.
670      */
671     function freezingCount(address _addr) public view returns (uint count) {
672         uint64 release = chains[toKey(_addr, 0)];
673         while (release != 0) {
674             count++;
675             release = chains[toKey(_addr, release)];
676         }
677     }
678 
679     /**
680      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
681      * @param _addr Address of freeze tokens owner.
682      * @param _index Freezing portion index. It ordered by release date descending.
683      */
684     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
685         for (uint i = 0; i < _index + 1; i++) {
686             _release = chains[toKey(_addr, _release)];
687             if (_release == 0) {
688                 return;
689             }
690         }
691         _balance = freezings[toKey(_addr, _release)];
692     }
693 
694     /**
695      * @dev freeze your tokens to the specified address.
696      *      Be careful, gas usage is not deterministic,
697      *      and depends on how many freezes _to address already has.
698      * @param _to Address to which token will be freeze.
699      * @param _amount Amount of token to freeze.
700      * @param _until Release date, must be in future.
701      */
702     function freezeTo(address _to, uint _amount, uint64 _until) public {
703         require(_to != address(0));
704         require(_amount <= balances[msg.sender]);
705 
706         balances[msg.sender] = balances[msg.sender].sub(_amount);
707 
708         bytes32 currentKey = toKey(_to, _until);
709         freezings[currentKey] = freezings[currentKey].add(_amount);
710         freezingBalance[_to] = freezingBalance[_to].add(_amount);
711 
712         freeze(_to, _until);
713         emit Transfer(msg.sender, _to, _amount);
714         emit Freezed(_to, _until, _amount);
715     }
716 
717     /**
718      * @dev release first available freezing tokens.
719      */
720     function releaseOnce() public {
721         bytes32 headKey = toKey(msg.sender, 0);
722         uint64 head = chains[headKey];
723         require(head != 0);
724         require(uint64(block.timestamp) > head);
725         bytes32 currentKey = toKey(msg.sender, head);
726 
727         uint64 next = chains[currentKey];
728 
729         uint amount = freezings[currentKey];
730         delete freezings[currentKey];
731 
732         balances[msg.sender] = balances[msg.sender].add(amount);
733         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
734 
735         if (next == 0) {
736             delete chains[headKey];
737         } else {
738             chains[headKey] = next;
739             delete chains[currentKey];
740         }
741         emit Released(msg.sender, amount);
742     }
743 
744     /**
745      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
746      * @return how many tokens was released
747      */
748     function releaseAll() public returns (uint tokens) {
749         uint release;
750         uint balance;
751         (release, balance) = getFreezing(msg.sender, 0);
752         while (release != 0 && block.timestamp > release) {
753             releaseOnce();
754             tokens += balance;
755             (release, balance) = getFreezing(msg.sender, 0);
756         }
757     }
758 
759     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
760         // WISH masc to increase entropy
761         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
762         assembly {
763             result := or(result, mul(_addr, 0x10000000000000000))
764             result := or(result, _release)
765         }
766     }
767 
768     function freeze(address _to, uint64 _until) internal {
769         require(_until > block.timestamp);
770         bytes32 key = toKey(_to, _until);
771         bytes32 parentKey = toKey(_to, uint64(0));
772         uint64 next = chains[parentKey];
773 
774         if (next == 0) {
775             chains[parentKey] = _until;
776             return;
777         }
778 
779         bytes32 nextKey = toKey(_to, next);
780         uint parent;
781 
782         while (next != 0 && _until > next) {
783             parent = next;
784             parentKey = nextKey;
785 
786             next = chains[nextKey];
787             nextKey = toKey(_to, next);
788         }
789 
790         if (_until == next) {
791             return;
792         }
793 
794         if (next != 0) {
795             chains[key] = next;
796         }
797 
798         chains[parentKey] = _until;
799     }
800 }
801 
802 
803 /**
804  * @title Burnable Token
805  * @dev Token that can be irreversibly burned (destroyed).
806  */
807 contract BurnableToken is BasicToken {
808 
809   event Burn(address indexed burner, uint256 value);
810 
811   /**
812    * @dev Burns a specific amount of tokens.
813    * @param _value The amount of token to be burned.
814    */
815   function burn(uint256 _value) public {
816     _burn(msg.sender, _value);
817   }
818 
819   function _burn(address _who, uint256 _value) internal {
820     require(_value <= balances[_who]);
821     // no need to require value <= totalSupply, since that would imply the
822     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
823 
824     balances[_who] = balances[_who].sub(_value);
825     totalSupply_ = totalSupply_.sub(_value);
826     emit Burn(_who, _value);
827     emit Transfer(_who, address(0), _value);
828   }
829 }
830 
831 
832 
833 /**
834  * @title Pausable
835  * @dev Base contract which allows children to implement an emergency stop mechanism.
836  */
837 contract Pausable is Ownable {
838   event Pause();
839   event Unpause();
840 
841   bool public paused = false;
842 
843 
844   /**
845    * @dev Modifier to make a function callable only when the contract is not paused.
846    */
847   modifier whenNotPaused() {
848     require(!paused);
849     _;
850   }
851 
852   /**
853    * @dev Modifier to make a function callable only when the contract is paused.
854    */
855   modifier whenPaused() {
856     require(paused);
857     _;
858   }
859 
860   /**
861    * @dev called by the owner to pause, triggers stopped state
862    */
863   function pause() onlyOwner whenNotPaused public {
864     paused = true;
865     emit Pause();
866   }
867 
868   /**
869    * @dev called by the owner to unpause, returns to normal state
870    */
871   function unpause() onlyOwner whenPaused public {
872     paused = false;
873     emit Unpause();
874   }
875 }
876 
877 
878 contract FreezableMintableToken is FreezableToken, MintableToken {
879     /**
880      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
881      *      Be careful, gas usage is not deterministic,
882      *      and depends on how many freezes _to address already has.
883      * @param _to Address to which token will be freeze.
884      * @param _amount Amount of token to mint and freeze.
885      * @param _until Release date, must be in future.
886      * @return A boolean that indicates if the operation was successful.
887      */
888     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
889         totalSupply_ = totalSupply_.add(_amount);
890 
891         bytes32 currentKey = toKey(_to, _until);
892         freezings[currentKey] = freezings[currentKey].add(_amount);
893         freezingBalance[_to] = freezingBalance[_to].add(_amount);
894 
895         freeze(_to, _until);
896         emit Mint(_to, _amount);
897         emit Freezed(_to, _until, _amount);
898         emit Transfer(msg.sender, _to, _amount);
899         return true;
900     }
901 }
902 
903 
904 
905 contract Consts {
906     uint public constant TOKEN_DECIMALS = 8;
907     uint8 public constant TOKEN_DECIMALS_UINT8 = 8;
908     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
909 
910     string public constant TOKEN_NAME = "GenPay";
911     string public constant TOKEN_SYMBOL = "GNP";
912     bool public constant PAUSED = true;
913     address public constant TARGET_USER = 0xD66d698d2367896bA7Eb0a20335C0c2A0E64Fbf2;
914     
915     uint public constant START_TIME = 1544468400;
916     
917     bool public constant CONTINUE_MINTING = true;
918 }
919 
920 
921 
922 
923 /**
924  * @title FinalizableCrowdsale
925  * @dev Extension of Crowdsale where an owner can do extra work
926  * after finishing.
927  */
928 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
929   using SafeMath for uint256;
930 
931   bool public isFinalized = false;
932 
933   event Finalized();
934 
935   /**
936    * @dev Must be called after crowdsale ends, to do some extra finalization
937    * work. Calls the contract's finalization function.
938    */
939   function finalize() onlyOwner public {
940     require(!isFinalized);
941     require(hasClosed());
942 
943     finalization();
944     emit Finalized();
945 
946     isFinalized = true;
947   }
948 
949   /**
950    * @dev Can be overridden to add finalization logic. The overriding function
951    * should call super.finalization() to ensure the chain of finalization is
952    * executed entirely.
953    */
954   function finalization() internal {
955   }
956 
957 }
958 
959 
960 /**
961  * @title CappedCrowdsale
962  * @dev Crowdsale with a limit for total contributions.
963  */
964 contract CappedCrowdsale is Crowdsale {
965   using SafeMath for uint256;
966 
967   uint256 public cap;
968 
969   /**
970    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
971    * @param _cap Max amount of wei to be contributed
972    */
973   constructor(uint256 _cap) public {
974     require(_cap > 0);
975     cap = _cap;
976   }
977 
978   /**
979    * @dev Checks whether the cap has been reached.
980    * @return Whether the cap was reached
981    */
982   function capReached() public view returns (bool) {
983     return weiRaised >= cap;
984   }
985 
986   /**
987    * @dev Extend parent behavior requiring purchase to respect the funding cap.
988    * @param _beneficiary Token purchaser
989    * @param _weiAmount Amount of wei contributed
990    */
991   function _preValidatePurchase(
992     address _beneficiary,
993     uint256 _weiAmount
994   )
995     internal
996   {
997     super._preValidatePurchase(_beneficiary, _weiAmount);
998     require(weiRaised.add(_weiAmount) <= cap);
999   }
1000 
1001 }
1002 
1003 
1004 /**
1005  * @title MintedCrowdsale
1006  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1007  * Token ownership should be transferred to MintedCrowdsale for minting.
1008  */
1009 contract MintedCrowdsale is Crowdsale {
1010 
1011   /**
1012    * @dev Overrides delivery by minting tokens upon purchase.
1013    * @param _beneficiary Token purchaser
1014    * @param _tokenAmount Number of tokens to be minted
1015    */
1016   function _deliverTokens(
1017     address _beneficiary,
1018     uint256 _tokenAmount
1019   )
1020     internal
1021   {
1022     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
1023   }
1024 }
1025 
1026 
1027 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
1028     
1029 {
1030     
1031 
1032     function name() public pure returns (string _name) {
1033         return TOKEN_NAME;
1034     }
1035 
1036     function symbol() public pure returns (string _symbol) {
1037         return TOKEN_SYMBOL;
1038     }
1039 
1040     function decimals() public pure returns (uint8 _decimals) {
1041         return TOKEN_DECIMALS_UINT8;
1042     }
1043 
1044     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
1045         require(!paused);
1046         return super.transferFrom(_from, _to, _value);
1047     }
1048 
1049     function transfer(address _to, uint256 _value) public returns (bool _success) {
1050         require(!paused);
1051         return super.transfer(_to, _value);
1052     }
1053 
1054     
1055 }
1056 
1057 
1058 
1059 
1060 contract MainCrowdsale is Consts, FinalizableCrowdsale, MintedCrowdsale, CappedCrowdsale {
1061     function hasStarted() public view returns (bool) {
1062         return now >= openingTime;
1063     }
1064 
1065     function startTime() public view returns (uint256) {
1066         return openingTime;
1067     }
1068 
1069     function endTime() public view returns (uint256) {
1070         return closingTime;
1071     }
1072 
1073     function hasClosed() public view returns (bool) {
1074         return super.hasClosed() || capReached();
1075     }
1076 
1077     function hasEnded() public view returns (bool) {
1078         return hasClosed();
1079     }
1080 
1081     function finalization() internal {
1082         super.finalization();
1083 
1084         if (PAUSED) {
1085             MainToken(token).unpause();
1086         }
1087 
1088         if (!CONTINUE_MINTING) {
1089             require(MintableToken(token).finishMinting());
1090         }
1091 
1092         Ownable(token).transferOwnership(TARGET_USER);
1093     }
1094 
1095     /**
1096      * @dev Override to extend the way in which ether is converted to tokens.
1097      * @param _weiAmount Value in wei to be converted into tokens
1098      * @return Number of tokens that can be purchased with the specified _weiAmount
1099      */
1100     function _getTokenAmount(uint256 _weiAmount)
1101         internal view returns (uint256)
1102     {
1103         return _weiAmount.mul(rate).div(1 ether);
1104     }
1105 }
1106 
1107 
1108 contract BonusableCrowdsale is Consts, Crowdsale {
1109     /**
1110      * @dev Override to extend the way in which ether is converted to tokens.
1111      * @param _weiAmount Value in wei to be converted into tokens
1112      * @return Number of tokens that can be purchased with the specified _weiAmount
1113      */
1114     function _getTokenAmount(uint256 _weiAmount)
1115         internal view returns (uint256)
1116     {
1117         uint256 bonusRate = getBonusRate(_weiAmount);
1118         return _weiAmount.mul(bonusRate).div(1 ether);
1119     }
1120 
1121     function getBonusRate(uint256 _weiAmount) internal view returns (uint256) {
1122         uint256 bonusRate = rate;
1123 
1124         
1125         // apply bonus for time & weiRaised
1126         uint[1] memory weiRaisedStartsBounds = [uint(0)];
1127         uint[1] memory weiRaisedEndsBounds = [uint(400000000000000000000)];
1128         uint64[1] memory timeStartsBounds = [uint64(1544468400)];
1129         uint64[1] memory timeEndsBounds = [uint64(1544900395)];
1130         uint[1] memory weiRaisedAndTimeRates = [uint(450)];
1131 
1132         for (uint i = 0; i < 1; i++) {
1133             bool weiRaisedInBound = (weiRaisedStartsBounds[i] <= weiRaised) && (weiRaised < weiRaisedEndsBounds[i]);
1134             bool timeInBound = (timeStartsBounds[i] <= now) && (now < timeEndsBounds[i]);
1135             if (weiRaisedInBound && timeInBound) {
1136                 bonusRate += bonusRate * weiRaisedAndTimeRates[i] / 1000;
1137             }
1138         }
1139         
1140 
1141         
1142 
1143         return bonusRate;
1144     }
1145 }
1146 
1147 
1148 
1149 
1150 contract WhitelistedCrowdsale is Crowdsale, Ownable {
1151     mapping (address => bool) private whitelist;
1152 
1153     event WhitelistedAddressAdded(address indexed _address);
1154     event WhitelistedAddressRemoved(address indexed _address);
1155 
1156     /**
1157      * @dev throws if buyer is not whitelisted.
1158      * @param _buyer address
1159      */
1160     modifier onlyIfWhitelisted(address _buyer) {
1161         require(whitelist[_buyer]);
1162         _;
1163     }
1164 
1165     /**
1166      * @dev add single address to whitelist
1167      */
1168     function addAddressToWhitelist(address _address) external onlyOwner {
1169         whitelist[_address] = true;
1170         emit WhitelistedAddressAdded(_address);
1171     }
1172 
1173     /**
1174      * @dev add addresses to whitelist
1175      */
1176     function addAddressesToWhitelist(address[] _addresses) external onlyOwner {
1177         for (uint i = 0; i < _addresses.length; i++) {
1178             whitelist[_addresses[i]] = true;
1179             emit WhitelistedAddressAdded(_addresses[i]);
1180         }
1181     }
1182 
1183     /**
1184      * @dev remove single address from whitelist
1185      */
1186     function removeAddressFromWhitelist(address _address) external onlyOwner {
1187         delete whitelist[_address];
1188         emit WhitelistedAddressRemoved(_address);
1189     }
1190 
1191     /**
1192      * @dev remove addresses from whitelist
1193      */
1194     function removeAddressesFromWhitelist(address[] _addresses) external onlyOwner {
1195         for (uint i = 0; i < _addresses.length; i++) {
1196             delete whitelist[_addresses[i]];
1197             emit WhitelistedAddressRemoved(_addresses[i]);
1198         }
1199     }
1200 
1201     /**
1202      * @dev getter to determine if address is in whitelist
1203      */
1204     function isWhitelisted(address _address) public view returns (bool) {
1205         return whitelist[_address];
1206     }
1207 
1208     /**
1209      * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1210      * @param _beneficiary Token beneficiary
1211      * @param _weiAmount Amount of wei contributed
1212      */
1213     function _preValidatePurchase(
1214         address _beneficiary,
1215         uint256 _weiAmount
1216     )
1217         internal
1218         onlyIfWhitelisted(_beneficiary)
1219     {
1220         super._preValidatePurchase(_beneficiary, _weiAmount);
1221     }
1222 }
1223 
1224 
1225 
1226 contract TemplateCrowdsale is Consts, MainCrowdsale
1227     
1228     , BonusableCrowdsale
1229     
1230     
1231     
1232     
1233     , WhitelistedCrowdsale
1234     
1235 {
1236     event Initialized();
1237     event TimesChanged(uint startTime, uint endTime, uint oldStartTime, uint oldEndTime);
1238     bool public initialized = false;
1239 
1240     constructor(MintableToken _token) public
1241         Crowdsale(2500000 * TOKEN_DECIMAL_MULTIPLIER, 0xD66d698d2367896bA7Eb0a20335C0c2A0E64Fbf2, _token)
1242         TimedCrowdsale(START_TIME > now ? START_TIME : now, 1544900400)
1243         CappedCrowdsale(400000000000000000000)
1244         
1245     {
1246     }
1247 
1248     function init() public onlyOwner {
1249         require(!initialized);
1250         initialized = true;
1251 
1252         if (PAUSED) {
1253             MainToken(token).pause();
1254         }
1255 
1256         
1257 
1258         transferOwnership(TARGET_USER);
1259 
1260         emit Initialized();
1261     }
1262 
1263     
1264 
1265     
1266 
1267     
1268 
1269     
1270 
1271     
1272 
1273     
1274 }