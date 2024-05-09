1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender)
23     public view returns (uint256);
24 
25   function transferFrom(address from, address to, uint256 value)
26     public returns (bool);
27 
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, throws on overflow.
46   */
47   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
49     // benefit is lost if 'b' is also tested.
50     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51     if (a == 0) {
52       return 0;
53     }
54 
55     c = a * b;
56     assert(c / a == b);
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers, truncating the quotient.
62   */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     // uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return a / b;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   /**
79   * @dev Adds two numbers, throws on overflow.
80   */
81   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
82     c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 
89 /**
90  * @title Crowdsale
91  * @dev Crowdsale is a base contract for managing a token crowdsale,
92  * allowing investors to purchase tokens with ether. This contract implements
93  * such functionality in its most fundamental form and can be extended to provide additional
94  * functionality and/or custom behavior.
95  * The external interface represents the basic interface for purchasing tokens, and conform
96  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
97  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
98  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
99  * behavior.
100  */
101 contract Crowdsale {
102   using SafeMath for uint256;
103 
104   // The token being sold
105   ERC20 public token;
106 
107   // Address where funds are collected
108   address public wallet;
109 
110   // How many token units a buyer gets per wei.
111   // The rate is the conversion between wei and the smallest and indivisible token unit.
112   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
113   // 1 wei will give you 1 unit, or 0.001 TOK.
114   uint256 public rate;
115 
116   // Amount of wei raised
117   uint256 public weiRaised;
118 
119   /**
120    * Event for token purchase logging
121    * @param purchaser who paid for the tokens
122    * @param beneficiary who got the tokens
123    * @param value weis paid for purchase
124    * @param amount amount of tokens purchased
125    */
126   event TokenPurchase(
127     address indexed purchaser,
128     address indexed beneficiary,
129     uint256 value,
130     uint256 amount
131   );
132 
133   /**
134    * @param _rate Number of token units a buyer gets per wei
135    * @param _wallet Address where collected funds will be forwarded to
136    * @param _token Address of the token being sold
137    */
138   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
139     require(_rate > 0);
140     require(_wallet != address(0));
141     require(_token != address(0));
142 
143     rate = _rate;
144     wallet = _wallet;
145     token = _token;
146   }
147 
148   // -----------------------------------------
149   // Crowdsale external interface
150   // -----------------------------------------
151 
152   /**
153    * @dev fallback function ***DO NOT OVERRIDE***
154    */
155   function () external payable {
156     buyTokens(msg.sender);
157   }
158 
159   /**
160    * @dev low level token purchase ***DO NOT OVERRIDE***
161    * @param _beneficiary Address performing the token purchase
162    */
163   function buyTokens(address _beneficiary) public payable {
164 
165     uint256 weiAmount = msg.value;
166     _preValidatePurchase(_beneficiary, weiAmount);
167 
168     // calculate token amount to be created
169     uint256 tokens = _getTokenAmount(weiAmount);
170 
171     // update state
172     weiRaised = weiRaised.add(weiAmount);
173 
174     _processPurchase(_beneficiary, tokens);
175     emit TokenPurchase(
176       msg.sender,
177       _beneficiary,
178       weiAmount,
179       tokens
180     );
181 
182     _updatePurchasingState(_beneficiary, weiAmount);
183 
184     _forwardFunds();
185     _postValidatePurchase(_beneficiary, weiAmount);
186   }
187 
188   // -----------------------------------------
189   // Internal interface (extensible)
190   // -----------------------------------------
191 
192   /**
193    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
194    * @param _beneficiary Address performing the token purchase
195    * @param _weiAmount Value in wei involved in the purchase
196    */
197   function _preValidatePurchase(
198     address _beneficiary,
199     uint256 _weiAmount
200   )
201     internal
202   {
203     require(_beneficiary != address(0));
204     require(_weiAmount != 0);
205   }
206 
207   /**
208    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
209    * @param _beneficiary Address performing the token purchase
210    * @param _weiAmount Value in wei involved in the purchase
211    */
212   function _postValidatePurchase(
213     address _beneficiary,
214     uint256 _weiAmount
215   )
216     internal
217   {
218     // optional override
219   }
220 
221   /**
222    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
223    * @param _beneficiary Address performing the token purchase
224    * @param _tokenAmount Number of tokens to be emitted
225    */
226   function _deliverTokens(
227     address _beneficiary,
228     uint256 _tokenAmount
229   )
230     internal
231   {
232     token.transfer(_beneficiary, _tokenAmount);
233   }
234 
235   /**
236    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
237    * @param _beneficiary Address receiving the tokens
238    * @param _tokenAmount Number of tokens to be purchased
239    */
240   function _processPurchase(
241     address _beneficiary,
242     uint256 _tokenAmount
243   )
244     internal
245   {
246     _deliverTokens(_beneficiary, _tokenAmount);
247   }
248 
249   /**
250    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
251    * @param _beneficiary Address receiving the tokens
252    * @param _weiAmount Value in wei involved in the purchase
253    */
254   function _updatePurchasingState(
255     address _beneficiary,
256     uint256 _weiAmount
257   )
258     internal
259   {
260     // optional override
261   }
262 
263   /**
264    * @dev Override to extend the way in which ether is converted to tokens.
265    * @param _weiAmount Value in wei to be converted into tokens
266    * @return Number of tokens that can be purchased with the specified _weiAmount
267    */
268   function _getTokenAmount(uint256 _weiAmount)
269     internal view returns (uint256)
270   {
271     return _weiAmount.mul(rate);
272   }
273 
274   /**
275    * @dev Determines how ETH is stored/forwarded on purchases.
276    */
277   function _forwardFunds() internal {
278     wallet.transfer(msg.value);
279   }
280 }
281 
282 
283 
284 /**
285  * @title Ownable
286  * @dev The Ownable contract has an owner address, and provides basic authorization control
287  * functions, this simplifies the implementation of "user permissions".
288  */
289 contract Ownable {
290   address public owner;
291 
292 
293   event OwnershipRenounced(address indexed previousOwner);
294   event OwnershipTransferred(
295     address indexed previousOwner,
296     address indexed newOwner
297   );
298 
299 
300   /**
301    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
302    * account.
303    */
304   constructor() public {
305     owner = msg.sender;
306   }
307 
308   /**
309    * @dev Throws if called by any account other than the owner.
310    */
311   modifier onlyOwner() {
312     require(msg.sender == owner);
313     _;
314   }
315 
316   /**
317    * @dev Allows the current owner to relinquish control of the contract.
318    */
319   function renounceOwnership() public onlyOwner {
320     emit OwnershipRenounced(owner);
321     owner = address(0);
322   }
323 
324   /**
325    * @dev Allows the current owner to transfer control of the contract to a newOwner.
326    * @param _newOwner The address to transfer ownership to.
327    */
328   function transferOwnership(address _newOwner) public onlyOwner {
329     _transferOwnership(_newOwner);
330   }
331 
332   /**
333    * @dev Transfers control of the contract to a newOwner.
334    * @param _newOwner The address to transfer ownership to.
335    */
336   function _transferOwnership(address _newOwner) internal {
337     require(_newOwner != address(0));
338     emit OwnershipTransferred(owner, _newOwner);
339     owner = _newOwner;
340   }
341 }
342 
343 
344 /**
345  * @title TimedCrowdsale
346  * @dev Crowdsale accepting contributions only within a time frame.
347  */
348 contract TimedCrowdsale is Crowdsale {
349   using SafeMath for uint256;
350 
351   uint256 public openingTime;
352   uint256 public closingTime;
353 
354   /**
355    * @dev Reverts if not in crowdsale time range.
356    */
357   modifier onlyWhileOpen {
358     // solium-disable-next-line security/no-block-members
359     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
360     _;
361   }
362 
363   /**
364    * @dev Constructor, takes crowdsale opening and closing times.
365    * @param _openingTime Crowdsale opening time
366    * @param _closingTime Crowdsale closing time
367    */
368   constructor(uint256 _openingTime, uint256 _closingTime) public {
369     // solium-disable-next-line security/no-block-members
370     require(_openingTime >= block.timestamp);
371     require(_closingTime >= _openingTime);
372 
373     openingTime = _openingTime;
374     closingTime = _closingTime;
375   }
376 
377   /**
378    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
379    * @return Whether crowdsale period has elapsed
380    */
381   function hasClosed() public view returns (bool) {
382     // solium-disable-next-line security/no-block-members
383     return block.timestamp > closingTime;
384   }
385 
386   /**
387    * @dev Extend parent behavior requiring to be within contributing period
388    * @param _beneficiary Token purchaser
389    * @param _weiAmount Amount of wei contributed
390    */
391   function _preValidatePurchase(
392     address _beneficiary,
393     uint256 _weiAmount
394   )
395     internal
396     onlyWhileOpen
397   {
398     super._preValidatePurchase(_beneficiary, _weiAmount);
399   }
400 
401 }
402 
403 
404 
405 /**
406  * @title Basic token
407  * @dev Basic version of StandardToken, with no allowances.
408  */
409 contract BasicToken is ERC20Basic {
410   using SafeMath for uint256;
411 
412   mapping(address => uint256) balances;
413 
414   uint256 totalSupply_;
415 
416   /**
417   * @dev total number of tokens in existence
418   */
419   function totalSupply() public view returns (uint256) {
420     return totalSupply_;
421   }
422 
423   /**
424   * @dev transfer token for a specified address
425   * @param _to The address to transfer to.
426   * @param _value The amount to be transferred.
427   */
428   function transfer(address _to, uint256 _value) public returns (bool) {
429     require(_to != address(0));
430     require(_value <= balances[msg.sender]);
431 
432     balances[msg.sender] = balances[msg.sender].sub(_value);
433     balances[_to] = balances[_to].add(_value);
434     emit Transfer(msg.sender, _to, _value);
435     return true;
436   }
437 
438   /**
439   * @dev Gets the balance of the specified address.
440   * @param _owner The address to query the the balance of.
441   * @return An uint256 representing the amount owned by the passed address.
442   */
443   function balanceOf(address _owner) public view returns (uint256) {
444     return balances[_owner];
445   }
446 
447 }
448 
449 
450 /**
451  * @title Standard ERC20 token
452  *
453  * @dev Implementation of the basic standard token.
454  * @dev https://github.com/ethereum/EIPs/issues/20
455  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
456  */
457 contract StandardToken is ERC20, BasicToken {
458 
459   mapping (address => mapping (address => uint256)) internal allowed;
460 
461 
462   /**
463    * @dev Transfer tokens from one address to another
464    * @param _from address The address which you want to send tokens from
465    * @param _to address The address which you want to transfer to
466    * @param _value uint256 the amount of tokens to be transferred
467    */
468   function transferFrom(
469     address _from,
470     address _to,
471     uint256 _value
472   )
473     public
474     returns (bool)
475   {
476     require(_to != address(0));
477     require(_value <= balances[_from]);
478     require(_value <= allowed[_from][msg.sender]);
479 
480     balances[_from] = balances[_from].sub(_value);
481     balances[_to] = balances[_to].add(_value);
482     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
483     emit Transfer(_from, _to, _value);
484     return true;
485   }
486 
487   /**
488    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
489    *
490    * Beware that changing an allowance with this method brings the risk that someone may use both the old
491    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
492    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
493    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
494    * @param _spender The address which will spend the funds.
495    * @param _value The amount of tokens to be spent.
496    */
497   function approve(address _spender, uint256 _value) public returns (bool) {
498     allowed[msg.sender][_spender] = _value;
499     emit Approval(msg.sender, _spender, _value);
500     return true;
501   }
502 
503   /**
504    * @dev Function to check the amount of tokens that an owner allowed to a spender.
505    * @param _owner address The address which owns the funds.
506    * @param _spender address The address which will spend the funds.
507    * @return A uint256 specifying the amount of tokens still available for the spender.
508    */
509   function allowance(
510     address _owner,
511     address _spender
512    )
513     public
514     view
515     returns (uint256)
516   {
517     return allowed[_owner][_spender];
518   }
519 
520   /**
521    * @dev Increase the amount of tokens that an owner allowed to a spender.
522    *
523    * approve should be called when allowed[_spender] == 0. To increment
524    * allowed value is better to use this function to avoid 2 calls (and wait until
525    * the first transaction is mined)
526    * From MonolithDAO Token.sol
527    * @param _spender The address which will spend the funds.
528    * @param _addedValue The amount of tokens to increase the allowance by.
529    */
530   function increaseApproval(
531     address _spender,
532     uint _addedValue
533   )
534     public
535     returns (bool)
536   {
537     allowed[msg.sender][_spender] = (
538       allowed[msg.sender][_spender].add(_addedValue));
539     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
540     return true;
541   }
542 
543   /**
544    * @dev Decrease the amount of tokens that an owner allowed to a spender.
545    *
546    * approve should be called when allowed[_spender] == 0. To decrement
547    * allowed value is better to use this function to avoid 2 calls (and wait until
548    * the first transaction is mined)
549    * From MonolithDAO Token.sol
550    * @param _spender The address which will spend the funds.
551    * @param _subtractedValue The amount of tokens to decrease the allowance by.
552    */
553   function decreaseApproval(
554     address _spender,
555     uint _subtractedValue
556   )
557     public
558     returns (bool)
559   {
560     uint oldValue = allowed[msg.sender][_spender];
561     if (_subtractedValue > oldValue) {
562       allowed[msg.sender][_spender] = 0;
563     } else {
564       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
565     }
566     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
567     return true;
568   }
569 
570 }
571 
572 
573 /**
574  * @title Mintable token
575  * @dev Simple ERC20 Token example, with mintable token creation
576  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
577  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
578  */
579 contract MintableToken is StandardToken, Ownable {
580   event Mint(address indexed to, uint256 amount);
581   event MintFinished();
582 
583   bool public mintingFinished = false;
584 
585 
586   modifier canMint() {
587     require(!mintingFinished);
588     _;
589   }
590 
591   modifier hasMintPermission() {
592     require(msg.sender == owner);
593     _;
594   }
595 
596   /**
597    * @dev Function to mint tokens
598    * @param _to The address that will receive the minted tokens.
599    * @param _amount The amount of tokens to mint.
600    * @return A boolean that indicates if the operation was successful.
601    */
602   function mint(
603     address _to,
604     uint256 _amount
605   )
606     hasMintPermission
607     canMint
608     public
609     returns (bool)
610   {
611     totalSupply_ = totalSupply_.add(_amount);
612     balances[_to] = balances[_to].add(_amount);
613     emit Mint(_to, _amount);
614     emit Transfer(address(0), _to, _amount);
615     return true;
616   }
617 
618   /**
619    * @dev Function to stop minting new tokens.
620    * @return True if the operation was successful.
621    */
622   function finishMinting() onlyOwner canMint public returns (bool) {
623     mintingFinished = true;
624     emit MintFinished();
625     return true;
626   }
627 }
628 
629 
630 contract FreezableToken is StandardToken {
631     // freezing chains
632     mapping (bytes32 => uint64) internal chains;
633     // freezing amounts for each chain
634     mapping (bytes32 => uint) internal freezings;
635     // total freezing balance per address
636     mapping (address => uint) internal freezingBalance;
637 
638     event Freezed(address indexed to, uint64 release, uint amount);
639     event Released(address indexed owner, uint amount);
640 
641     /**
642      * @dev Gets the balance of the specified address include freezing tokens.
643      * @param _owner The address to query the the balance of.
644      * @return An uint256 representing the amount owned by the passed address.
645      */
646     function balanceOf(address _owner) public view returns (uint256 balance) {
647         return super.balanceOf(_owner) + freezingBalance[_owner];
648     }
649 
650     /**
651      * @dev Gets the balance of the specified address without freezing tokens.
652      * @param _owner The address to query the the balance of.
653      * @return An uint256 representing the amount owned by the passed address.
654      */
655     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
656         return super.balanceOf(_owner);
657     }
658 
659     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
660         return freezingBalance[_owner];
661     }
662 
663     /**
664      * @dev gets freezing count
665      * @param _addr Address of freeze tokens owner.
666      */
667     function freezingCount(address _addr) public view returns (uint count) {
668         uint64 release = chains[toKey(_addr, 0)];
669         while (release != 0) {
670             count++;
671             release = chains[toKey(_addr, release)];
672         }
673     }
674 
675     /**
676      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
677      * @param _addr Address of freeze tokens owner.
678      * @param _index Freezing portion index. It ordered by release date descending.
679      */
680     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
681         for (uint i = 0; i < _index + 1; i++) {
682             _release = chains[toKey(_addr, _release)];
683             if (_release == 0) {
684                 return;
685             }
686         }
687         _balance = freezings[toKey(_addr, _release)];
688     }
689 
690     /**
691      * @dev freeze your tokens to the specified address.
692      *      Be careful, gas usage is not deterministic,
693      *      and depends on how many freezes _to address already has.
694      * @param _to Address to which token will be freeze.
695      * @param _amount Amount of token to freeze.
696      * @param _until Release date, must be in future.
697      */
698     function freezeTo(address _to, uint _amount, uint64 _until) public {
699         require(_to != address(0));
700         require(_amount <= balances[msg.sender]);
701 
702         balances[msg.sender] = balances[msg.sender].sub(_amount);
703 
704         bytes32 currentKey = toKey(_to, _until);
705         freezings[currentKey] = freezings[currentKey].add(_amount);
706         freezingBalance[_to] = freezingBalance[_to].add(_amount);
707 
708         freeze(_to, _until);
709         emit Transfer(msg.sender, _to, _amount);
710         emit Freezed(_to, _until, _amount);
711     }
712 
713     /**
714      * @dev release first available freezing tokens.
715      */
716     function releaseOnce() public {
717         bytes32 headKey = toKey(msg.sender, 0);
718         uint64 head = chains[headKey];
719         require(head != 0);
720         require(uint64(block.timestamp) > head);
721         bytes32 currentKey = toKey(msg.sender, head);
722 
723         uint64 next = chains[currentKey];
724 
725         uint amount = freezings[currentKey];
726         delete freezings[currentKey];
727 
728         balances[msg.sender] = balances[msg.sender].add(amount);
729         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
730 
731         if (next == 0) {
732             delete chains[headKey];
733         } else {
734             chains[headKey] = next;
735             delete chains[currentKey];
736         }
737         emit Released(msg.sender, amount);
738     }
739 
740     /**
741      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
742      * @return how many tokens was released
743      */
744     function releaseAll() public returns (uint tokens) {
745         uint release;
746         uint balance;
747         (release, balance) = getFreezing(msg.sender, 0);
748         while (release != 0 && block.timestamp > release) {
749             releaseOnce();
750             tokens += balance;
751             (release, balance) = getFreezing(msg.sender, 0);
752         }
753     }
754 
755     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
756         // WISH masc to increase entropy
757         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
758         assembly {
759             result := or(result, mul(_addr, 0x10000000000000000))
760             result := or(result, _release)
761         }
762     }
763 
764     function freeze(address _to, uint64 _until) internal {
765         require(_until > block.timestamp);
766         bytes32 key = toKey(_to, _until);
767         bytes32 parentKey = toKey(_to, uint64(0));
768         uint64 next = chains[parentKey];
769 
770         if (next == 0) {
771             chains[parentKey] = _until;
772             return;
773         }
774 
775         bytes32 nextKey = toKey(_to, next);
776         uint parent;
777 
778         while (next != 0 && _until > next) {
779             parent = next;
780             parentKey = nextKey;
781 
782             next = chains[nextKey];
783             nextKey = toKey(_to, next);
784         }
785 
786         if (_until == next) {
787             return;
788         }
789 
790         if (next != 0) {
791             chains[key] = next;
792         }
793 
794         chains[parentKey] = _until;
795     }
796 }
797 
798 
799 /**
800  * @title Burnable Token
801  * @dev Token that can be irreversibly burned (destroyed).
802  */
803 contract BurnableToken is BasicToken {
804 
805   event Burn(address indexed burner, uint256 value);
806 
807   /**
808    * @dev Burns a specific amount of tokens.
809    * @param _value The amount of token to be burned.
810    */
811   function burn(uint256 _value) public {
812     _burn(msg.sender, _value);
813   }
814 
815   function _burn(address _who, uint256 _value) internal {
816     require(_value <= balances[_who]);
817     // no need to require value <= totalSupply, since that would imply the
818     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
819 
820     balances[_who] = balances[_who].sub(_value);
821     totalSupply_ = totalSupply_.sub(_value);
822     emit Burn(_who, _value);
823     emit Transfer(_who, address(0), _value);
824   }
825 }
826 
827 
828 
829 /**
830  * @title Pausable
831  * @dev Base contract which allows children to implement an emergency stop mechanism.
832  */
833 contract Pausable is Ownable {
834   event Pause();
835   event Unpause();
836 
837   bool public paused = false;
838 
839 
840   /**
841    * @dev Modifier to make a function callable only when the contract is not paused.
842    */
843   modifier whenNotPaused() {
844     require(!paused);
845     _;
846   }
847 
848   /**
849    * @dev Modifier to make a function callable only when the contract is paused.
850    */
851   modifier whenPaused() {
852     require(paused);
853     _;
854   }
855 
856   /**
857    * @dev called by the owner to pause, triggers stopped state
858    */
859   function pause() onlyOwner whenNotPaused public {
860     paused = true;
861     emit Pause();
862   }
863 
864   /**
865    * @dev called by the owner to unpause, returns to normal state
866    */
867   function unpause() onlyOwner whenPaused public {
868     paused = false;
869     emit Unpause();
870   }
871 }
872 
873 
874 contract FreezableMintableToken is FreezableToken, MintableToken {
875     /**
876      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
877      *      Be careful, gas usage is not deterministic,
878      *      and depends on how many freezes _to address already has.
879      * @param _to Address to which token will be freeze.
880      * @param _amount Amount of token to mint and freeze.
881      * @param _until Release date, must be in future.
882      * @return A boolean that indicates if the operation was successful.
883      */
884     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
885         totalSupply_ = totalSupply_.add(_amount);
886 
887         bytes32 currentKey = toKey(_to, _until);
888         freezings[currentKey] = freezings[currentKey].add(_amount);
889         freezingBalance[_to] = freezingBalance[_to].add(_amount);
890 
891         freeze(_to, _until);
892         emit Mint(_to, _amount);
893         emit Freezed(_to, _until, _amount);
894         emit Transfer(msg.sender, _to, _amount);
895         return true;
896     }
897 }
898 
899 
900 
901 contract Consts {
902     uint public constant TOKEN_DECIMALS = 18;
903     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
904     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
905 
906     string public constant TOKEN_NAME = "MediLiVes Token";
907     string public constant TOKEN_SYMBOL = "MLIV";
908     bool public constant PAUSED = false;
909     address public constant TARGET_USER = 0x3e9611D1b334C1631F756bF1F42BE071cCbE66d4;
910     
911     uint public constant START_TIME = 1563561000;
912     
913     bool public constant CONTINUE_MINTING = true;
914 }
915 
916 
917 
918 
919 /**
920  * @title FinalizableCrowdsale
921  * @dev Extension of Crowdsale where an owner can do extra work
922  * after finishing.
923  */
924 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
925   using SafeMath for uint256;
926 
927   bool public isFinalized = false;
928 
929   event Finalized();
930 
931   /**
932    * @dev Must be called after crowdsale ends, to do some extra finalization
933    * work. Calls the contract's finalization function.
934    */
935   function finalize() onlyOwner public {
936     require(!isFinalized);
937     require(hasClosed());
938 
939     finalization();
940     emit Finalized();
941 
942     isFinalized = true;
943   }
944 
945   /**
946    * @dev Can be overridden to add finalization logic. The overriding function
947    * should call super.finalization() to ensure the chain of finalization is
948    * executed entirely.
949    */
950   function finalization() internal {
951   }
952 
953 }
954 
955 
956 /**
957  * @title CappedCrowdsale
958  * @dev Crowdsale with a limit for total contributions.
959  */
960 contract CappedCrowdsale is Crowdsale {
961   using SafeMath for uint256;
962 
963   uint256 public cap;
964 
965   /**
966    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
967    * @param _cap Max amount of wei to be contributed
968    */
969   constructor(uint256 _cap) public {
970     require(_cap > 0);
971     cap = _cap;
972   }
973 
974   /**
975    * @dev Checks whether the cap has been reached.
976    * @return Whether the cap was reached
977    */
978   function capReached() public view returns (bool) {
979     return weiRaised >= cap;
980   }
981 
982   /**
983    * @dev Extend parent behavior requiring purchase to respect the funding cap.
984    * @param _beneficiary Token purchaser
985    * @param _weiAmount Amount of wei contributed
986    */
987   function _preValidatePurchase(
988     address _beneficiary,
989     uint256 _weiAmount
990   )
991     internal
992   {
993     super._preValidatePurchase(_beneficiary, _weiAmount);
994     require(weiRaised.add(_weiAmount) <= cap);
995   }
996 
997 }
998 
999 
1000 /**
1001  * @title MintedCrowdsale
1002  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1003  * Token ownership should be transferred to MintedCrowdsale for minting.
1004  */
1005 contract MintedCrowdsale is Crowdsale {
1006 
1007   /**
1008    * @dev Overrides delivery by minting tokens upon purchase.
1009    * @param _beneficiary Token purchaser
1010    * @param _tokenAmount Number of tokens to be minted
1011    */
1012   function _deliverTokens(
1013     address _beneficiary,
1014     uint256 _tokenAmount
1015   )
1016     internal
1017   {
1018     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
1019   }
1020 }
1021 
1022 
1023 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
1024     
1025 {
1026     
1027 
1028     function name() public pure returns (string _name) {
1029         return TOKEN_NAME;
1030     }
1031 
1032     function symbol() public pure returns (string _symbol) {
1033         return TOKEN_SYMBOL;
1034     }
1035 
1036     function decimals() public pure returns (uint8 _decimals) {
1037         return TOKEN_DECIMALS_UINT8;
1038     }
1039 
1040     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
1041         require(!paused);
1042         return super.transferFrom(_from, _to, _value);
1043     }
1044 
1045     function transfer(address _to, uint256 _value) public returns (bool _success) {
1046         require(!paused);
1047         return super.transfer(_to, _value);
1048     }
1049 
1050     
1051 }
1052 
1053 
1054 
1055 
1056 contract MainCrowdsale is Consts, FinalizableCrowdsale, MintedCrowdsale, CappedCrowdsale {
1057     function hasStarted() public view returns (bool) {
1058         return now >= openingTime;
1059     }
1060 
1061     function startTime() public view returns (uint256) {
1062         return openingTime;
1063     }
1064 
1065     function endTime() public view returns (uint256) {
1066         return closingTime;
1067     }
1068 
1069     function hasClosed() public view returns (bool) {
1070         return super.hasClosed() || capReached();
1071     }
1072 
1073     function hasEnded() public view returns (bool) {
1074         return hasClosed();
1075     }
1076 
1077     function finalization() internal {
1078         super.finalization();
1079 
1080         if (PAUSED) {
1081             MainToken(token).unpause();
1082         }
1083 
1084         if (!CONTINUE_MINTING) {
1085             require(MintableToken(token).finishMinting());
1086         }
1087 
1088         Ownable(token).transferOwnership(TARGET_USER);
1089     }
1090 
1091     /**
1092      * @dev Override to extend the way in which ether is converted to tokens.
1093      * @param _weiAmount Value in wei to be converted into tokens
1094      * @return Number of tokens that can be purchased with the specified _weiAmount
1095      */
1096     function _getTokenAmount(uint256 _weiAmount)
1097         internal view returns (uint256)
1098     {
1099         return _weiAmount.mul(rate).div(1 ether);
1100     }
1101 }
1102 
1103 
1104 contract BonusableCrowdsale is Consts, Crowdsale {
1105     /**
1106      * @dev Override to extend the way in which ether is converted to tokens.
1107      * @param _weiAmount Value in wei to be converted into tokens
1108      * @return Number of tokens that can be purchased with the specified _weiAmount
1109      */
1110     function _getTokenAmount(uint256 _weiAmount)
1111         internal view returns (uint256)
1112     {
1113         uint256 bonusRate = getBonusRate(_weiAmount);
1114         return _weiAmount.mul(bonusRate).div(1 ether);
1115     }
1116 
1117     function getBonusRate(uint256 _weiAmount) internal view returns (uint256) {
1118         uint256 bonusRate = rate;
1119 
1120         
1121 
1122         
1123         // apply amount
1124         uint[4] memory weiAmountBounds = [uint(50000000000000000000),uint(10000000000000000000),uint(10000000000000000000),uint(1000000000000000000)];
1125         uint[4] memory weiAmountRates = [uint(1000),uint(500),uint(0),uint(250)];
1126 
1127         for (uint j = 0; j < 4; j++) {
1128             if (_weiAmount >= weiAmountBounds[j]) {
1129                 bonusRate += bonusRate * weiAmountRates[j] / 1000;
1130                 break;
1131             }
1132         }
1133         
1134 
1135         return bonusRate;
1136     }
1137 }
1138 
1139 
1140 
1141 
1142 
1143 contract TemplateCrowdsale is Consts, MainCrowdsale
1144     
1145     , BonusableCrowdsale
1146     
1147     
1148     
1149     
1150 {
1151     event Initialized();
1152     event TimesChanged(uint startTime, uint endTime, uint oldStartTime, uint oldEndTime);
1153     bool public initialized = false;
1154 
1155     constructor(MintableToken _token) public
1156         Crowdsale(9000 * TOKEN_DECIMAL_MULTIPLIER, 0xFB262Fe4620e7027424488F6C471b13DE7662A95, _token)
1157         TimedCrowdsale(START_TIME > now ? START_TIME : now, 1568917800)
1158         CappedCrowdsale(111111111111111111111111)
1159         
1160     {
1161     }
1162 
1163     function init() public onlyOwner {
1164         require(!initialized);
1165         initialized = true;
1166 
1167         if (PAUSED) {
1168             MainToken(token).pause();
1169         }
1170 
1171         
1172         address[2] memory addresses = [address(0x57fc4fcd5e9d5954da2a8943743ca0e46291ea1d),address(0x5ba2168ddbf65df7c904b822fa1db73088d16e87)];
1173         uint[2] memory amounts = [uint(9000000000000000000000000000),uint(2000000000000000000000000000)];
1174         uint64[2] memory freezes = [uint64(0),uint64(0)];
1175 
1176         for (uint i = 0; i < addresses.length; i++) {
1177             if (freezes[i] == 0) {
1178                 MainToken(token).mint(addresses[i], amounts[i]);
1179             } else {
1180                 MainToken(token).mintAndFreeze(addresses[i], amounts[i], freezes[i]);
1181             }
1182         }
1183         
1184 
1185         transferOwnership(TARGET_USER);
1186 
1187         emit Initialized();
1188     }
1189 
1190     
1191     /**
1192      * @dev override hasClosed to add minimal value logic
1193      * @return true if remained to achieve less than minimal
1194      */
1195     function hasClosed() public view returns (bool) {
1196         bool remainValue = cap.sub(weiRaised) < 250000000000000000;
1197         return super.hasClosed() || remainValue;
1198     }
1199     
1200 
1201     
1202     function setStartTime(uint _startTime) public onlyOwner {
1203         // only if CS was not started
1204         require(now < openingTime);
1205         // only move time to future
1206         require(_startTime > openingTime);
1207         require(_startTime < closingTime);
1208         emit TimesChanged(_startTime, closingTime, openingTime, closingTime);
1209         openingTime = _startTime;
1210     }
1211     
1212 
1213     
1214     function setEndTime(uint _endTime) public onlyOwner {
1215         // only if CS was not ended
1216         require(now < closingTime);
1217         // only if new end time in future
1218         require(now < _endTime);
1219         require(_endTime > openingTime);
1220         emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
1221         closingTime = _endTime;
1222     }
1223     
1224 
1225     
1226     function setTimes(uint _startTime, uint _endTime) public onlyOwner {
1227         require(_endTime > _startTime);
1228         uint oldStartTime = openingTime;
1229         uint oldEndTime = closingTime;
1230         bool changed = false;
1231         if (_startTime != oldStartTime) {
1232             require(_startTime > now);
1233             // only if CS was not started
1234             require(now < oldStartTime);
1235             // only move time to future
1236             require(_startTime > oldStartTime);
1237 
1238             openingTime = _startTime;
1239             changed = true;
1240         }
1241         if (_endTime != oldEndTime) {
1242             // only if CS was not ended
1243             require(now < oldEndTime);
1244             // end time in future
1245             require(now < _endTime);
1246 
1247             closingTime = _endTime;
1248             changed = true;
1249         }
1250 
1251         if (changed) {
1252             emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
1253         }
1254     }
1255     
1256 
1257     
1258 
1259     
1260     /**
1261      * @dev override purchase validation to add extra value logic.
1262      * @return true if sended more than minimal value
1263      */
1264     function _preValidatePurchase(
1265         address _beneficiary,
1266         uint256 _weiAmount
1267     )
1268         internal
1269     {
1270         
1271         require(msg.value >= 250000000000000000);
1272         
1273         
1274         require(msg.value <= 1000000000000000000000);
1275         
1276         super._preValidatePurchase(_beneficiary, _weiAmount);
1277     }
1278     
1279 }