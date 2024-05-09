1 /*
2  * 'BFCL L.L.C.' CROWDSALE ICO contract
3  *
4  * Symbol      : BFCL
5  * Name        : Bolton
6  * Total supply: 1,663,000,000
7  * Decimals    : 18
8  *
9  * Copyright (C) 2018 Raffaele Bini - 5esse Informatica (https://www.5esse.it)
10  *
11  * Made with passion with Bolton Team
12  *
13  * This program is free software: you can redistribute it and/or modify
14  * it under the terms of the GNU Lesser General Public License as published by
15  * the Free Software Foundation, either version 3 of the License, or
16  * (at your option) any later version.
17  *
18  * This program is distributed in the hope that it will be useful,
19  * but WITHOUT ANY WARRANTY; without even the implied warranty of
20  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
21  * GNU Lesser General Public License for more details.
22  *
23  * You should have received a copy of the GNU Lesser General Public License
24  * along with this program. If not, see <http://www.gnu.org/licenses/>.
25  */
26 pragma solidity ^0.4.23;
27 
28 
29 /**
30  * @title ERC20Basic
31  * @dev Simpler version of ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/179
33  */
34 contract ERC20Basic {
35   function totalSupply() public view returns (uint256);
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 
42 /**
43  * @title ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/20
45  */
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender)
48     public view returns (uint256);
49 
50   function transferFrom(address from, address to, uint256 value)
51     public returns (bool);
52 
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(
55     address indexed owner,
56     address indexed spender,
57     uint256 value
58   );
59 }
60 
61 
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
74     // benefit is lost if 'b' is also tested.
75     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76     if (a == 0) {
77       return 0;
78     }
79 
80     c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     // uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return a / b;
93   }
94 
95   /**
96   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
107     c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 
114 /**
115  * @title Crowdsale
116  * @dev Crowdsale is a base contract for managing a token crowdsale,
117  * allowing investors to purchase tokens with ether. This contract implements
118  * such functionality in its most fundamental form and can be extended to provide additional
119  * functionality and/or custom behavior.
120  * The external interface represents the basic interface for purchasing tokens, and conform
121  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
122  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
123  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
124  * behavior.
125  */
126 contract Crowdsale {
127   using SafeMath for uint256;
128 
129   // The token being sold
130   ERC20 public token;
131 
132   // Address where funds are collected
133   address public wallet;
134 
135   // How many token units a buyer gets per wei.
136   // The rate is the conversion between wei and the smallest and indivisible token unit.
137   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
138   // 1 wei will give you 1 unit, or 0.001 TOK.
139   uint256 public rate;
140 
141   // Amount of wei raised
142   uint256 public weiRaised;
143 
144   /**
145    * Event for token purchase logging
146    * @param purchaser who paid for the tokens
147    * @param beneficiary who got the tokens
148    * @param value weis paid for purchase
149    * @param amount amount of tokens purchased
150    */
151   event TokenPurchase(
152     address indexed purchaser,
153     address indexed beneficiary,
154     uint256 value,
155     uint256 amount
156   );
157 
158   /**
159    * @param _rate Number of token units a buyer gets per wei
160    * @param _wallet Address where collected funds will be forwarded to
161    * @param _token Address of the token being sold
162    */
163   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
164     require(_rate > 0);
165     require(_wallet != address(0));
166     require(_token != address(0));
167 
168     rate = _rate;
169     wallet = _wallet;
170     token = _token;
171   }
172 
173   // -----------------------------------------
174   // Crowdsale external interface
175   // -----------------------------------------
176 
177   /**
178    * @dev fallback function ***DO NOT OVERRIDE***
179    */
180   function () external payable {
181     buyTokens(msg.sender);
182   }
183 
184   /**
185    * @dev low level token purchase ***DO NOT OVERRIDE***
186    * @param _beneficiary Address performing the token purchase
187    */
188   function buyTokens(address _beneficiary) public payable {
189 
190     uint256 weiAmount = msg.value;
191     _preValidatePurchase(_beneficiary, weiAmount);
192 
193     // calculate token amount to be created
194     uint256 tokens = _getTokenAmount(weiAmount);
195 
196     // update state
197     weiRaised = weiRaised.add(weiAmount);
198 
199     _processPurchase(_beneficiary, tokens);
200     emit TokenPurchase(
201       msg.sender,
202       _beneficiary,
203       weiAmount,
204       tokens
205     );
206 
207     _updatePurchasingState(_beneficiary, weiAmount);
208 
209     _forwardFunds();
210     _postValidatePurchase(_beneficiary, weiAmount);
211   }
212 
213   // -----------------------------------------
214   // Internal interface (extensible)
215   // -----------------------------------------
216 
217   /**
218    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
219    * @param _beneficiary Address performing the token purchase
220    * @param _weiAmount Value in wei involved in the purchase
221    */
222   function _preValidatePurchase(
223     address _beneficiary,
224     uint256 _weiAmount
225   )
226     internal
227   {
228     require(_beneficiary != address(0));
229     require(_weiAmount != 0);
230   }
231 
232   /**
233    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
234    * @param _beneficiary Address performing the token purchase
235    * @param _weiAmount Value in wei involved in the purchase
236    */
237   function _postValidatePurchase(
238     address _beneficiary,
239     uint256 _weiAmount
240   )
241     internal
242   {
243     // optional override
244   }
245 
246   /**
247    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
248    * @param _beneficiary Address performing the token purchase
249    * @param _tokenAmount Number of tokens to be emitted
250    */
251   function _deliverTokens(
252     address _beneficiary,
253     uint256 _tokenAmount
254   )
255     internal
256   {
257     token.transfer(_beneficiary, _tokenAmount);
258   }
259 
260   /**
261    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
262    * @param _beneficiary Address receiving the tokens
263    * @param _tokenAmount Number of tokens to be purchased
264    */
265   function _processPurchase(
266     address _beneficiary,
267     uint256 _tokenAmount
268   )
269     internal
270   {
271     _deliverTokens(_beneficiary, _tokenAmount);
272   }
273 
274   /**
275    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
276    * @param _beneficiary Address receiving the tokens
277    * @param _weiAmount Value in wei involved in the purchase
278    */
279   function _updatePurchasingState(
280     address _beneficiary,
281     uint256 _weiAmount
282   )
283     internal
284   {
285     // optional override
286   }
287 
288   /**
289    * @dev Override to extend the way in which ether is converted to tokens.
290    * @param _weiAmount Value in wei to be converted into tokens
291    * @return Number of tokens that can be purchased with the specified _weiAmount
292    */
293   function _getTokenAmount(uint256 _weiAmount)
294     internal view returns (uint256)
295   {
296     return _weiAmount.mul(rate);
297   }
298 
299   /**
300    * @dev Determines how ETH is stored/forwarded on purchases.
301    */
302   function _forwardFunds() internal {
303     wallet.transfer(msg.value);
304   }
305 }
306 
307 
308 
309 /**
310  * @title Ownable
311  * @dev The Ownable contract has an owner address, and provides basic authorization control
312  * functions, this simplifies the implementation of "user permissions".
313  */
314 contract Ownable {
315   address public owner;
316 
317 
318   event OwnershipRenounced(address indexed previousOwner);
319   event OwnershipTransferred(
320     address indexed previousOwner,
321     address indexed newOwner
322   );
323 
324 
325   /**
326    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
327    * account.
328    */
329   constructor() public {
330     owner = msg.sender;
331   }
332 
333   /**
334    * @dev Throws if called by any account other than the owner.
335    */
336   modifier onlyOwner() {
337     require(msg.sender == owner);
338     _;
339   }
340 
341   /**
342    * @dev Allows the current owner to relinquish control of the contract.
343    */
344   function renounceOwnership() public onlyOwner {
345     emit OwnershipRenounced(owner);
346     owner = address(0);
347   }
348 
349   /**
350    * @dev Allows the current owner to transfer control of the contract to a newOwner.
351    * @param _newOwner The address to transfer ownership to.
352    */
353   function transferOwnership(address _newOwner) public onlyOwner {
354     _transferOwnership(_newOwner);
355   }
356 
357   /**
358    * @dev Transfers control of the contract to a newOwner.
359    * @param _newOwner The address to transfer ownership to.
360    */
361   function _transferOwnership(address _newOwner) internal {
362     require(_newOwner != address(0));
363     emit OwnershipTransferred(owner, _newOwner);
364     owner = _newOwner;
365   }
366 }
367 
368 
369 /**
370  * @title TimedCrowdsale
371  * @dev Crowdsale accepting contributions only within a time frame.
372  */
373 contract TimedCrowdsale is Crowdsale {
374   using SafeMath for uint256;
375 
376   uint256 public openingTime;
377   uint256 public closingTime;
378 
379   /**
380    * @dev Reverts if not in crowdsale time range.
381    */
382   modifier onlyWhileOpen {
383     // solium-disable-next-line security/no-block-members
384     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
385     _;
386   }
387 
388   /**
389    * @dev Constructor, takes crowdsale opening and closing times.
390    * @param _openingTime Crowdsale opening time
391    * @param _closingTime Crowdsale closing time
392    */
393   constructor(uint256 _openingTime, uint256 _closingTime) public {
394     // solium-disable-next-line security/no-block-members
395     require(_openingTime >= block.timestamp);
396     require(_closingTime >= _openingTime);
397 
398     openingTime = _openingTime;
399     closingTime = _closingTime;
400   }
401 
402   /**
403    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
404    * @return Whether crowdsale period has elapsed
405    */
406   function hasClosed() public view returns (bool) {
407     // solium-disable-next-line security/no-block-members
408     return block.timestamp > closingTime;
409   }
410 
411   /**
412    * @dev Extend parent behavior requiring to be within contributing period
413    * @param _beneficiary Token purchaser
414    * @param _weiAmount Amount of wei contributed
415    */
416   function _preValidatePurchase(
417     address _beneficiary,
418     uint256 _weiAmount
419   )
420     internal
421     onlyWhileOpen
422   {
423     super._preValidatePurchase(_beneficiary, _weiAmount);
424   }
425 
426 }
427 
428 
429 
430 /**
431  * @title Basic token
432  * @dev Basic version of StandardToken, with no allowances.
433  */
434 contract BasicToken is ERC20Basic {
435   using SafeMath for uint256;
436 
437   mapping(address => uint256) balances;
438 
439   uint256 totalSupply_;
440 
441   /**
442   * @dev total number of tokens in existence
443   */
444   function totalSupply() public view returns (uint256) {
445     return totalSupply_;
446   }
447 
448   /**
449   * @dev transfer token for a specified address
450   * @param _to The address to transfer to.
451   * @param _value The amount to be transferred.
452   */
453   function transfer(address _to, uint256 _value) public returns (bool) {
454     require(_to != address(0));
455     require(_value <= balances[msg.sender]);
456 
457     balances[msg.sender] = balances[msg.sender].sub(_value);
458     balances[_to] = balances[_to].add(_value);
459     emit Transfer(msg.sender, _to, _value);
460     return true;
461   }
462 
463   /**
464   * @dev Gets the balance of the specified address.
465   * @param _owner The address to query the the balance of.
466   * @return An uint256 representing the amount owned by the passed address.
467   */
468   function balanceOf(address _owner) public view returns (uint256) {
469     return balances[_owner];
470   }
471 
472 }
473 
474 
475 /**
476  * @title Standard ERC20 token
477  *
478  * @dev Implementation of the basic standard token.
479  * @dev https://github.com/ethereum/EIPs/issues/20
480  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
481  */
482 contract StandardToken is ERC20, BasicToken {
483 
484   mapping (address => mapping (address => uint256)) internal allowed;
485 
486 
487   /**
488    * @dev Transfer tokens from one address to another
489    * @param _from address The address which you want to send tokens from
490    * @param _to address The address which you want to transfer to
491    * @param _value uint256 the amount of tokens to be transferred
492    */
493   function transferFrom(
494     address _from,
495     address _to,
496     uint256 _value
497   )
498     public
499     returns (bool)
500   {
501     require(_to != address(0));
502     require(_value <= balances[_from]);
503     require(_value <= allowed[_from][msg.sender]);
504 
505     balances[_from] = balances[_from].sub(_value);
506     balances[_to] = balances[_to].add(_value);
507     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
508     emit Transfer(_from, _to, _value);
509     return true;
510   }
511 
512   /**
513    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
514    *
515    * Beware that changing an allowance with this method brings the risk that someone may use both the old
516    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
517    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
518    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
519    * @param _spender The address which will spend the funds.
520    * @param _value The amount of tokens to be spent.
521    */
522   function approve(address _spender, uint256 _value) public returns (bool) {
523     allowed[msg.sender][_spender] = _value;
524     emit Approval(msg.sender, _spender, _value);
525     return true;
526   }
527 
528   /**
529    * @dev Function to check the amount of tokens that an owner allowed to a spender.
530    * @param _owner address The address which owns the funds.
531    * @param _spender address The address which will spend the funds.
532    * @return A uint256 specifying the amount of tokens still available for the spender.
533    */
534   function allowance(
535     address _owner,
536     address _spender
537    )
538     public
539     view
540     returns (uint256)
541   {
542     return allowed[_owner][_spender];
543   }
544 
545   /**
546    * @dev Increase the amount of tokens that an owner allowed to a spender.
547    *
548    * approve should be called when allowed[_spender] == 0. To increment
549    * allowed value is better to use this function to avoid 2 calls (and wait until
550    * the first transaction is mined)
551    * From MonolithDAO Token.sol
552    * @param _spender The address which will spend the funds.
553    * @param _addedValue The amount of tokens to increase the allowance by.
554    */
555   function increaseApproval(
556     address _spender,
557     uint _addedValue
558   )
559     public
560     returns (bool)
561   {
562     allowed[msg.sender][_spender] = (
563       allowed[msg.sender][_spender].add(_addedValue));
564     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
565     return true;
566   }
567 
568   /**
569    * @dev Decrease the amount of tokens that an owner allowed to a spender.
570    *
571    * approve should be called when allowed[_spender] == 0. To decrement
572    * allowed value is better to use this function to avoid 2 calls (and wait until
573    * the first transaction is mined)
574    * From MonolithDAO Token.sol
575    * @param _spender The address which will spend the funds.
576    * @param _subtractedValue The amount of tokens to decrease the allowance by.
577    */
578   function decreaseApproval(
579     address _spender,
580     uint _subtractedValue
581   )
582     public
583     returns (bool)
584   {
585     uint oldValue = allowed[msg.sender][_spender];
586     if (_subtractedValue > oldValue) {
587       allowed[msg.sender][_spender] = 0;
588     } else {
589       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
590     }
591     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
592     return true;
593   }
594 
595 }
596 
597 
598 /**
599  * @title Mintable token
600  * @dev Simple ERC20 Token example, with mintable token creation
601  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
602  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
603  */
604 contract MintableToken is StandardToken, Ownable {
605   event Mint(address indexed to, uint256 amount);
606   event MintFinished();
607 
608   bool public mintingFinished = false;
609 
610 
611   modifier canMint() {
612     require(!mintingFinished);
613     _;
614   }
615 
616   modifier hasMintPermission() {
617     require(msg.sender == owner);
618     _;
619   }
620 
621   /**
622    * @dev Function to mint tokens
623    * @param _to The address that will receive the minted tokens.
624    * @param _amount The amount of tokens to mint.
625    * @return A boolean that indicates if the operation was successful.
626    */
627   function mint(
628     address _to,
629     uint256 _amount
630   )
631     hasMintPermission
632     canMint
633     public
634     returns (bool)
635   {
636     totalSupply_ = totalSupply_.add(_amount);
637     balances[_to] = balances[_to].add(_amount);
638     emit Mint(_to, _amount);
639     emit Transfer(address(0), _to, _amount);
640     return true;
641   }
642 
643   /**
644    * @dev Function to stop minting new tokens.
645    * @return True if the operation was successful.
646    */
647   function finishMinting() onlyOwner canMint public returns (bool) {
648     mintingFinished = true;
649     emit MintFinished();
650     return true;
651   }
652 }
653 
654 
655 contract FreezableToken is StandardToken {
656     // freezing chains
657     mapping (bytes32 => uint64) internal chains;
658     // freezing amounts for each chain
659     mapping (bytes32 => uint) internal freezings;
660     // total freezing balance per address
661     mapping (address => uint) internal freezingBalance;
662 
663     event Freezed(address indexed to, uint64 release, uint amount);
664     event Released(address indexed owner, uint amount);
665 
666     /**
667      * @dev Gets the balance of the specified address include freezing tokens.
668      * @param _owner The address to query the the balance of.
669      * @return An uint256 representing the amount owned by the passed address.
670      */
671     function balanceOf(address _owner) public view returns (uint256 balance) {
672         return super.balanceOf(_owner) + freezingBalance[_owner];
673     }
674 
675     /**
676      * @dev Gets the balance of the specified address without freezing tokens.
677      * @param _owner The address to query the the balance of.
678      * @return An uint256 representing the amount owned by the passed address.
679      */
680     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
681         return super.balanceOf(_owner);
682     }
683 
684     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
685         return freezingBalance[_owner];
686     }
687 
688     /**
689      * @dev gets freezing count
690      * @param _addr Address of freeze tokens owner.
691      */
692     function freezingCount(address _addr) public view returns (uint count) {
693         uint64 release = chains[toKey(_addr, 0)];
694         while (release != 0) {
695             count++;
696             release = chains[toKey(_addr, release)];
697         }
698     }
699 
700     /**
701      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
702      * @param _addr Address of freeze tokens owner.
703      * @param _index Freezing portion index. It ordered by release date descending.
704      */
705     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
706         for (uint i = 0; i < _index + 1; i++) {
707             _release = chains[toKey(_addr, _release)];
708             if (_release == 0) {
709                 return;
710             }
711         }
712         _balance = freezings[toKey(_addr, _release)];
713     }
714 
715     /**
716      * @dev freeze your tokens to the specified address.
717      *      Be careful, gas usage is not deterministic,
718      *      and depends on how many freezes _to address already has.
719      * @param _to Address to which token will be freeze.
720      * @param _amount Amount of token to freeze.
721      * @param _until Release date, must be in future.
722      */
723     function freezeTo(address _to, uint _amount, uint64 _until) public {
724         require(_to != address(0));
725         require(_amount <= balances[msg.sender]);
726 
727         balances[msg.sender] = balances[msg.sender].sub(_amount);
728 
729         bytes32 currentKey = toKey(_to, _until);
730         freezings[currentKey] = freezings[currentKey].add(_amount);
731         freezingBalance[_to] = freezingBalance[_to].add(_amount);
732 
733         freeze(_to, _until);
734         emit Transfer(msg.sender, _to, _amount);
735         emit Freezed(_to, _until, _amount);
736     }
737 
738     /**
739      * @dev release first available freezing tokens.
740      */
741     function releaseOnce() public {
742         bytes32 headKey = toKey(msg.sender, 0);
743         uint64 head = chains[headKey];
744         require(head != 0);
745         require(uint64(block.timestamp) > head);
746         bytes32 currentKey = toKey(msg.sender, head);
747 
748         uint64 next = chains[currentKey];
749 
750         uint amount = freezings[currentKey];
751         delete freezings[currentKey];
752 
753         balances[msg.sender] = balances[msg.sender].add(amount);
754         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
755 
756         if (next == 0) {
757             delete chains[headKey];
758         } else {
759             chains[headKey] = next;
760             delete chains[currentKey];
761         }
762         emit Released(msg.sender, amount);
763     }
764 
765     /**
766      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
767      * @return how many tokens was released
768      */
769     function releaseAll() public returns (uint tokens) {
770         uint release;
771         uint balance;
772         (release, balance) = getFreezing(msg.sender, 0);
773         while (release != 0 && block.timestamp > release) {
774             releaseOnce();
775             tokens += balance;
776             (release, balance) = getFreezing(msg.sender, 0);
777         }
778     }
779 
780     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
781         // WISH masc to increase entropy
782         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
783         assembly {
784             result := or(result, mul(_addr, 0x10000000000000000))
785             result := or(result, _release)
786         }
787     }
788 
789     function freeze(address _to, uint64 _until) internal {
790         require(_until > block.timestamp);
791         bytes32 key = toKey(_to, _until);
792         bytes32 parentKey = toKey(_to, uint64(0));
793         uint64 next = chains[parentKey];
794 
795         if (next == 0) {
796             chains[parentKey] = _until;
797             return;
798         }
799 
800         bytes32 nextKey = toKey(_to, next);
801         uint parent;
802 
803         while (next != 0 && _until > next) {
804             parent = next;
805             parentKey = nextKey;
806 
807             next = chains[nextKey];
808             nextKey = toKey(_to, next);
809         }
810 
811         if (_until == next) {
812             return;
813         }
814 
815         if (next != 0) {
816             chains[key] = next;
817         }
818 
819         chains[parentKey] = _until;
820     }
821 }
822 
823 
824 /**
825  * @title Burnable Token
826  * @dev Token that can be irreversibly burned (destroyed).
827  */
828 contract BurnableToken is BasicToken {
829 
830   event Burn(address indexed burner, uint256 value);
831 
832   /**
833    * @dev Burns a specific amount of tokens.
834    * @param _value The amount of token to be burned.
835    */
836   function burn(uint256 _value) public {
837     _burn(msg.sender, _value);
838   }
839 
840   function _burn(address _who, uint256 _value) internal {
841     require(_value <= balances[_who]);
842     // no need to require value <= totalSupply, since that would imply the
843     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
844 
845     balances[_who] = balances[_who].sub(_value);
846     totalSupply_ = totalSupply_.sub(_value);
847     emit Burn(_who, _value);
848     emit Transfer(_who, address(0), _value);
849   }
850 }
851 
852 
853 
854 /**
855  * @title Pausable
856  * @dev Base contract which allows children to implement an emergency stop mechanism.
857  */
858 contract Pausable is Ownable {
859   event Pause();
860   event Unpause();
861 
862   bool public paused = false;
863 
864 
865   /**
866    * @dev Modifier to make a function callable only when the contract is not paused.
867    */
868   modifier whenNotPaused() {
869     require(!paused);
870     _;
871   }
872 
873   /**
874    * @dev Modifier to make a function callable only when the contract is paused.
875    */
876   modifier whenPaused() {
877     require(paused);
878     _;
879   }
880 
881   /**
882    * @dev called by the owner to pause, triggers stopped state
883    */
884   function pause() onlyOwner whenNotPaused public {
885     paused = true;
886     emit Pause();
887   }
888 
889   /**
890    * @dev called by the owner to unpause, returns to normal state
891    */
892   function unpause() onlyOwner whenPaused public {
893     paused = false;
894     emit Unpause();
895   }
896 }
897 
898 
899 contract FreezableMintableToken is FreezableToken, MintableToken {
900     /**
901      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
902      *      Be careful, gas usage is not deterministic,
903      *      and depends on how many freezes _to address already has.
904      * @param _to Address to which token will be freeze.
905      * @param _amount Amount of token to mint and freeze.
906      * @param _until Release date, must be in future.
907      * @return A boolean that indicates if the operation was successful.
908      */
909     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
910         totalSupply_ = totalSupply_.add(_amount);
911 
912         bytes32 currentKey = toKey(_to, _until);
913         freezings[currentKey] = freezings[currentKey].add(_amount);
914         freezingBalance[_to] = freezingBalance[_to].add(_amount);
915 
916         freeze(_to, _until);
917         emit Mint(_to, _amount);
918         emit Freezed(_to, _until, _amount);
919         emit Transfer(msg.sender, _to, _amount);
920         return true;
921     }
922 }
923 
924 
925 
926 contract Consts {
927     uint public constant TOKEN_DECIMALS = 18;
928     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
929     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
930 
931     string public constant TOKEN_NAME = "Bolton";
932     string public constant TOKEN_SYMBOL = "BFCL";
933     bool public constant PAUSED = false;
934     address public constant TARGET_USER = 0xd0997F80aeA911C01D5D8C7E34e7A937226a360c;
935     
936     uint public constant START_TIME = 1546340400;
937     
938     bool public constant CONTINUE_MINTING = true;
939 }
940 
941 
942 
943 
944 /**
945  * @title FinalizableCrowdsale
946  * @dev Extension of Crowdsale where an owner can do extra work
947  * after finishing.
948  */
949 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
950   using SafeMath for uint256;
951 
952   bool public isFinalized = false;
953 
954   event Finalized();
955 
956   /**
957    * @dev Must be called after crowdsale ends, to do some extra finalization
958    * work. Calls the contract's finalization function.
959    */
960   function finalize() onlyOwner public {
961     require(!isFinalized);
962     require(hasClosed());
963 
964     finalization();
965     emit Finalized();
966 
967     isFinalized = true;
968   }
969 
970   /**
971    * @dev Can be overridden to add finalization logic. The overriding function
972    * should call super.finalization() to ensure the chain of finalization is
973    * executed entirely.
974    */
975   function finalization() internal {
976   }
977 
978 }
979 
980 
981 /**
982  * @title CappedCrowdsale
983  * @dev Crowdsale with a limit for total contributions.
984  */
985 contract CappedCrowdsale is Crowdsale {
986   using SafeMath for uint256;
987 
988   uint256 public cap;
989 
990   /**
991    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
992    * @param _cap Max amount of wei to be contributed
993    */
994   constructor(uint256 _cap) public {
995     require(_cap > 0);
996     cap = _cap;
997   }
998 
999   /**
1000    * @dev Checks whether the cap has been reached.
1001    * @return Whether the cap was reached
1002    */
1003   function capReached() public view returns (bool) {
1004     return weiRaised >= cap;
1005   }
1006 
1007   /**
1008    * @dev Extend parent behavior requiring purchase to respect the funding cap.
1009    * @param _beneficiary Token purchaser
1010    * @param _weiAmount Amount of wei contributed
1011    */
1012   function _preValidatePurchase(
1013     address _beneficiary,
1014     uint256 _weiAmount
1015   )
1016     internal
1017   {
1018     super._preValidatePurchase(_beneficiary, _weiAmount);
1019     require(weiRaised.add(_weiAmount) <= cap);
1020   }
1021 
1022 }
1023 
1024 
1025 /**
1026  * @title MintedCrowdsale
1027  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1028  * Token ownership should be transferred to MintedCrowdsale for minting.
1029  */
1030 contract MintedCrowdsale is Crowdsale {
1031 
1032   /**
1033    * @dev Overrides delivery by minting tokens upon purchase.
1034    * @param _beneficiary Token purchaser
1035    * @param _tokenAmount Number of tokens to be minted
1036    */
1037   function _deliverTokens(
1038     address _beneficiary,
1039     uint256 _tokenAmount
1040   )
1041     internal
1042   {
1043     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
1044   }
1045 }
1046 
1047 
1048 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
1049     
1050 {
1051     
1052 
1053     function name() public pure returns (string _name) {
1054         return TOKEN_NAME;
1055     }
1056 
1057     function symbol() public pure returns (string _symbol) {
1058         return TOKEN_SYMBOL;
1059     }
1060 
1061     function decimals() public pure returns (uint8 _decimals) {
1062         return TOKEN_DECIMALS_UINT8;
1063     }
1064 
1065     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
1066         require(!paused);
1067         return super.transferFrom(_from, _to, _value);
1068     }
1069 
1070     function transfer(address _to, uint256 _value) public returns (bool _success) {
1071         require(!paused);
1072         return super.transfer(_to, _value);
1073     }
1074 
1075     
1076 }
1077 
1078 
1079 
1080 
1081 contract MainCrowdsale is Consts, FinalizableCrowdsale, MintedCrowdsale, CappedCrowdsale {
1082     function hasStarted() public view returns (bool) {
1083         return now >= openingTime;
1084     }
1085 
1086     function startTime() public view returns (uint256) {
1087         return openingTime;
1088     }
1089 
1090     function endTime() public view returns (uint256) {
1091         return closingTime;
1092     }
1093 
1094     function hasClosed() public view returns (bool) {
1095         return super.hasClosed() || capReached();
1096     }
1097 
1098     function hasEnded() public view returns (bool) {
1099         return hasClosed();
1100     }
1101 
1102     function finalization() internal {
1103         super.finalization();
1104 
1105         if (PAUSED) {
1106             MainToken(token).unpause();
1107         }
1108 
1109         if (!CONTINUE_MINTING) {
1110             require(MintableToken(token).finishMinting());
1111         }
1112 
1113         Ownable(token).transferOwnership(TARGET_USER);
1114     }
1115 
1116     /**
1117      * @dev Override to extend the way in which ether is converted to tokens.
1118      * @param _weiAmount Value in wei to be converted into tokens
1119      * @return Number of tokens that can be purchased with the specified _weiAmount
1120      */
1121     function _getTokenAmount(uint256 _weiAmount)
1122         internal view returns (uint256)
1123     {
1124         return _weiAmount.mul(rate).div(1 ether);
1125     }
1126 }
1127 
1128 
1129 contract WhitelistedCrowdsale is Crowdsale, Ownable {
1130     mapping (address => bool) private whitelist;
1131 
1132     event WhitelistedAddressAdded(address indexed _address);
1133     event WhitelistedAddressRemoved(address indexed _address);
1134 
1135     /**
1136      * @dev throws if buyer is not whitelisted.
1137      * @param _buyer address
1138      */
1139     modifier onlyIfWhitelisted(address _buyer) {
1140         require(whitelist[_buyer]);
1141         _;
1142     }
1143 
1144     /**
1145      * @dev add single address to whitelist
1146      */
1147     function addAddressToWhitelist(address _address) external onlyOwner {
1148         whitelist[_address] = true;
1149         emit WhitelistedAddressAdded(_address);
1150     }
1151 
1152     /**
1153      * @dev add addresses to whitelist
1154      */
1155     function addAddressesToWhitelist(address[] _addresses) external onlyOwner {
1156         for (uint i = 0; i < _addresses.length; i++) {
1157             whitelist[_addresses[i]] = true;
1158             emit WhitelistedAddressAdded(_addresses[i]);
1159         }
1160     }
1161 
1162     /**
1163      * @dev remove single address from whitelist
1164      */
1165     function removeAddressFromWhitelist(address _address) external onlyOwner {
1166         delete whitelist[_address];
1167         emit WhitelistedAddressRemoved(_address);
1168     }
1169 
1170     /**
1171      * @dev remove addresses from whitelist
1172      */
1173     function removeAddressesFromWhitelist(address[] _addresses) external onlyOwner {
1174         for (uint i = 0; i < _addresses.length; i++) {
1175             delete whitelist[_addresses[i]];
1176             emit WhitelistedAddressRemoved(_addresses[i]);
1177         }
1178     }
1179 
1180     /**
1181      * @dev getter to determine if address is in whitelist
1182      */
1183     function isWhitelisted(address _address) public view returns (bool) {
1184         return whitelist[_address];
1185     }
1186 
1187     /**
1188      * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1189      * @param _beneficiary Token beneficiary
1190      * @param _weiAmount Amount of wei contributed
1191      */
1192     function _preValidatePurchase(
1193         address _beneficiary,
1194         uint256 _weiAmount
1195     )
1196         internal
1197         onlyIfWhitelisted(_beneficiary)
1198     {
1199         super._preValidatePurchase(_beneficiary, _weiAmount);
1200     }
1201 }
1202 
1203 
1204 
1205 contract TemplateCrowdsale is Consts, MainCrowdsale
1206     
1207     
1208     
1209     
1210     , WhitelistedCrowdsale
1211     
1212 {
1213     event Initialized();
1214     event TimesChanged(uint startTime, uint endTime, uint oldStartTime, uint oldEndTime);
1215     bool public initialized = false;
1216 
1217     constructor(MintableToken _token) public
1218         Crowdsale(250 * TOKEN_DECIMAL_MULTIPLIER, 0x0b22Dc940d491F52dbc690843e26de7DCBD9870e, _token)
1219         TimedCrowdsale(START_TIME > now ? START_TIME : now, 1554026400)
1220         CappedCrowdsale(2198960000000000000000000)
1221         
1222     {
1223     }
1224 
1225     function init() public onlyOwner {
1226         require(!initialized);
1227         initialized = true;
1228 
1229         if (PAUSED) {
1230             MainToken(token).pause();
1231         }
1232 
1233         
1234         address[4] memory addresses = [address(0xd7058911fe1118cf3125a845d545e80b800589d5),address(0x92baa03252d3da2bb677793d58e725b9f7146060),address(0xc778cbb75a191b7015ce09dbf2f9f5a4bfeb21a4),address(0x4ce1f034e2ba62e979470f326b268baf1882019a)];
1235         uint[4] memory amounts = [uint(900000000000000000000000000),uint(100000000000000000000000000),uint(13260000000000000000000000),uint(100000000000000000000000000)];
1236         uint64[4] memory freezes = [uint64(0),uint64(0),uint64(0),uint64(0)];
1237 
1238         for (uint i = 0; i < addresses.length; i++) {
1239             if (freezes[i] == 0) {
1240                 MainToken(token).mint(addresses[i], amounts[i]);
1241             } else {
1242                 MainToken(token).mintAndFreeze(addresses[i], amounts[i], freezes[i]);
1243             }
1244         }
1245         
1246 
1247         transferOwnership(TARGET_USER);
1248 
1249         emit Initialized();
1250     }
1251 
1252     
1253     /**
1254      * @dev override hasClosed to add minimal value logic
1255      * @return true if remained to achieve less than minimal
1256      */
1257     function hasClosed() public view returns (bool) {
1258         bool remainValue = cap.sub(weiRaised) < 1000000000000000000;
1259         return super.hasClosed() || remainValue;
1260     }
1261     
1262 
1263     
1264     function setStartTime(uint _startTime) public onlyOwner {
1265         // only if CS was not started
1266         require(now < openingTime);
1267         // only move time to future
1268         require(_startTime > openingTime);
1269         require(_startTime < closingTime);
1270         emit TimesChanged(_startTime, closingTime, openingTime, closingTime);
1271         openingTime = _startTime;
1272     }
1273     
1274 
1275     
1276     function setEndTime(uint _endTime) public onlyOwner {
1277         // only if CS was not ended
1278         require(now < closingTime);
1279         // only if new end time in future
1280         require(now < _endTime);
1281         require(_endTime > openingTime);
1282         emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
1283         closingTime = _endTime;
1284     }
1285     
1286 
1287     
1288     function setTimes(uint _startTime, uint _endTime) public onlyOwner {
1289         require(_endTime > _startTime);
1290         uint oldStartTime = openingTime;
1291         uint oldEndTime = closingTime;
1292         bool changed = false;
1293         if (_startTime != oldStartTime) {
1294             require(_startTime > now);
1295             // only if CS was not started
1296             require(now < oldStartTime);
1297             // only move time to future
1298             require(_startTime > oldStartTime);
1299 
1300             openingTime = _startTime;
1301             changed = true;
1302         }
1303         if (_endTime != oldEndTime) {
1304             // only if CS was not ended
1305             require(now < oldEndTime);
1306             // end time in future
1307             require(now < _endTime);
1308 
1309             closingTime = _endTime;
1310             changed = true;
1311         }
1312 
1313         if (changed) {
1314             emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
1315         }
1316     }
1317     
1318 
1319     
1320 
1321     
1322     /**
1323      * @dev override purchase validation to add extra value logic.
1324      * @return true if sended more than minimal value
1325      */
1326     function _preValidatePurchase(
1327         address _beneficiary,
1328         uint256 _weiAmount
1329     )
1330         internal
1331     {
1332         
1333         require(msg.value >= 1000000000000000000);
1334         
1335         
1336         require(msg.value <= 2000000000000000000000000);
1337         
1338         super._preValidatePurchase(_beneficiary, _weiAmount);
1339     }
1340     
1341 }