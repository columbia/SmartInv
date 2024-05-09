1 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: zeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev Total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
125 
126 pragma solidity ^0.4.24;
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender)
136     public view returns (uint256);
137 
138   function transferFrom(address from, address to, uint256 value)
139     public returns (bool);
140 
141   function approve(address spender, uint256 value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
150 
151 pragma solidity ^0.4.24;
152 
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/issues/20
161  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint256 _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint256 _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint256 oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue > oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
276 
277 pragma solidity ^0.4.24;
278 
279 
280 
281 /**
282  * @title DetailedERC20 token
283  * @dev The decimals are only for visualization purposes.
284  * All the operations are done using the smallest and indivisible token unit,
285  * just as on Ethereum all the operations are done in wei.
286  */
287 contract DetailedERC20 is ERC20 {
288   string public name;
289   string public symbol;
290   uint8 public decimals;
291 
292   constructor(string _name, string _symbol, uint8 _decimals) public {
293     name = _name;
294     symbol = _symbol;
295     decimals = _decimals;
296   }
297 }
298 
299 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
300 
301 pragma solidity ^0.4.24;
302 
303 
304 /**
305  * @title Ownable
306  * @dev The Ownable contract has an owner address, and provides basic authorization control
307  * functions, this simplifies the implementation of "user permissions".
308  */
309 contract Ownable {
310   address public owner;
311 
312 
313   event OwnershipRenounced(address indexed previousOwner);
314   event OwnershipTransferred(
315     address indexed previousOwner,
316     address indexed newOwner
317   );
318 
319 
320   /**
321    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
322    * account.
323    */
324   constructor() public {
325     owner = msg.sender;
326   }
327 
328   /**
329    * @dev Throws if called by any account other than the owner.
330    */
331   modifier onlyOwner() {
332     require(msg.sender == owner);
333     _;
334   }
335 
336   /**
337    * @dev Allows the current owner to relinquish control of the contract.
338    * @notice Renouncing to ownership will leave the contract without an owner.
339    * It will not be possible to call the functions with the `onlyOwner`
340    * modifier anymore.
341    */
342   function renounceOwnership() public onlyOwner {
343     emit OwnershipRenounced(owner);
344     owner = address(0);
345   }
346 
347   /**
348    * @dev Allows the current owner to transfer control of the contract to a newOwner.
349    * @param _newOwner The address to transfer ownership to.
350    */
351   function transferOwnership(address _newOwner) public onlyOwner {
352     _transferOwnership(_newOwner);
353   }
354 
355   /**
356    * @dev Transfers control of the contract to a newOwner.
357    * @param _newOwner The address to transfer ownership to.
358    */
359   function _transferOwnership(address _newOwner) internal {
360     require(_newOwner != address(0));
361     emit OwnershipTransferred(owner, _newOwner);
362     owner = _newOwner;
363   }
364 }
365 
366 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
367 
368 pragma solidity ^0.4.24;
369 
370 
371 
372 
373 /**
374  * @title Mintable token
375  * @dev Simple ERC20 Token example, with mintable token creation
376  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
377  */
378 contract MintableToken is StandardToken, Ownable {
379   event Mint(address indexed to, uint256 amount);
380   event MintFinished();
381 
382   bool public mintingFinished = false;
383 
384 
385   modifier canMint() {
386     require(!mintingFinished);
387     _;
388   }
389 
390   modifier hasMintPermission() {
391     require(msg.sender == owner);
392     _;
393   }
394 
395   /**
396    * @dev Function to mint tokens
397    * @param _to The address that will receive the minted tokens.
398    * @param _amount The amount of tokens to mint.
399    * @return A boolean that indicates if the operation was successful.
400    */
401   function mint(
402     address _to,
403     uint256 _amount
404   )
405     hasMintPermission
406     canMint
407     public
408     returns (bool)
409   {
410     totalSupply_ = totalSupply_.add(_amount);
411     balances[_to] = balances[_to].add(_amount);
412     emit Mint(_to, _amount);
413     emit Transfer(address(0), _to, _amount);
414     return true;
415   }
416 
417   /**
418    * @dev Function to stop minting new tokens.
419    * @return True if the operation was successful.
420    */
421   function finishMinting() onlyOwner canMint public returns (bool) {
422     mintingFinished = true;
423     emit MintFinished();
424     return true;
425   }
426 }
427 
428 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
429 
430 pragma solidity ^0.4.24;
431 
432 
433 
434 /**
435  * @title Burnable Token
436  * @dev Token that can be irreversibly burned (destroyed).
437  */
438 contract BurnableToken is BasicToken {
439 
440   event Burn(address indexed burner, uint256 value);
441 
442   /**
443    * @dev Burns a specific amount of tokens.
444    * @param _value The amount of token to be burned.
445    */
446   function burn(uint256 _value) public {
447     _burn(msg.sender, _value);
448   }
449 
450   function _burn(address _who, uint256 _value) internal {
451     require(_value <= balances[_who]);
452     // no need to require value <= totalSupply, since that would imply the
453     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
454 
455     balances[_who] = balances[_who].sub(_value);
456     totalSupply_ = totalSupply_.sub(_value);
457     emit Burn(_who, _value);
458     emit Transfer(_who, address(0), _value);
459   }
460 }
461 
462 // File: contracts/ClubToken.sol
463 
464 pragma solidity ^0.4.18;
465 
466 /**
467  * ClubToken adheres to ERC20
468  * it is a continuously mintable token administered by CloversController/ClubTokenController
469  */
470 
471 
472 
473 
474 
475 contract ClubToken is StandardToken, DetailedERC20, MintableToken, BurnableToken {
476 
477     address public cloversController;
478     address public clubTokenController;
479 
480     modifier hasMintPermission() {
481       require(
482           msg.sender == clubTokenController ||
483           msg.sender == cloversController ||
484           msg.sender == owner
485       );
486       _;
487     }
488 
489     /**
490     * @dev constructor for the ClubTokens contract
491     * @param _name The name of the token
492     * @param _symbol The symbol of the token
493     * @param _decimals The decimals of the token
494     */
495     constructor(string _name, string _symbol, uint8 _decimals) public
496         DetailedERC20(_name, _symbol, _decimals)
497     {}
498 
499     function () public payable {}
500 
501     function updateClubTokenControllerAddress(address _clubTokenController) public onlyOwner {
502         require(_clubTokenController != 0);
503         clubTokenController = _clubTokenController;
504     }
505 
506     function updateCloversControllerAddress(address _cloversController) public onlyOwner {
507         require(_cloversController != 0);
508         cloversController = _cloversController;
509     }
510 
511 
512       /**
513        * @dev Transfer tokens from one address to another
514        * @param _from address The address which you want to send tokens from
515        * @param _to address The address which you want to transfer to
516        * @param _value uint256 the amount of tokens to be transferred
517        */
518       function transferFrom(
519         address _from,
520         address _to,
521         uint256 _value
522       )
523         public
524         returns (bool)
525       {
526         require(_to != address(0));
527         require(_value <= balances[_from]);
528         if (msg.sender != cloversController && msg.sender != clubTokenController) {
529             require(_value <= allowed[_from][msg.sender]);
530             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
531         }
532         balances[_from] = balances[_from].sub(_value);
533         balances[_to] = balances[_to].add(_value);
534         emit Transfer(_from, _to, _value);
535         return true;
536       }
537 
538     /**
539      * @dev Burns a specific amount of tokens.
540      * @param _value The amount of token to be burned.
541      * NOTE: Disabled as tokens should not be burned under circumstances beside selling tokens.
542      */
543     function burn(uint256 _value) public {
544         _value;
545         revert();
546     }
547 
548     /**
549      * @dev Burns a specific amount of tokens.
550      * @param _burner The address of the token holder burning their tokens.
551      * @param _value The amount of token to be burned.
552      */
553     function burn(address _burner, uint256 _value) public hasMintPermission {
554       _burn(_burner, _value);
555     }
556 
557     /**
558     * @dev Moves Eth to a certain address for use in the ClubTokenController
559     * @param _to The address to receive the Eth.
560     * @param _amount The amount of Eth to be transferred.
561     */
562     function moveEth(address _to, uint256 _amount) public hasMintPermission {
563         require(this.balance >= _amount);
564         _to.transfer(_amount);
565     }
566     /**
567     * @dev Moves Tokens to a certain address for use in the ClubTokenController
568     * @param _to The address to receive the Tokens.
569     * @param _amount The amount of Tokens to be transferred.
570     * @param _token The address of the relevant token contract.
571     * @return bool Whether or not the move was successful
572     */
573     function moveToken(address _to, uint256 _amount, address _token) public hasMintPermission returns (bool) {
574         require(_amount <= StandardToken(_token).balanceOf(this));
575         return StandardToken(_token).transfer(_to, _amount);
576     }
577     /**
578     * @dev Approves Tokens to a certain address for use in the ClubTokenController
579     * @param _to The address to be approved.
580     * @param _amount The amount of Tokens to be approved.
581     * @param _token The address of the relevant token contract.
582     * @return bool Whether or not the approval was successful
583     */
584     function approveToken(address _to, uint256 _amount, address _token) public hasMintPermission returns (bool) {
585         return StandardToken(_token).approve(_to, _amount);
586     }
587 }
588 
589 // File: bancor-contracts/solidity/contracts/converter/interfaces/IBancorFormula.sol
590 
591 pragma solidity ^0.4.24;
592 
593 /*
594     Bancor Formula interface
595 */
596 contract IBancorFormula {
597     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
598     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
599     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
600 }
601 
602 // File: bancor-contracts/solidity/contracts/utility/Utils.sol
603 
604 pragma solidity ^0.4.24;
605 
606 /*
607     Utilities & Common Modifiers
608 */
609 contract Utils {
610     /**
611         constructor
612     */
613     constructor() public {
614     }
615 
616     // verifies that an amount is greater than zero
617     modifier greaterThanZero(uint256 _amount) {
618         require(_amount > 0);
619         _;
620     }
621 
622     // validates an address - currently only checks that it isn't null
623     modifier validAddress(address _address) {
624         require(_address != address(0));
625         _;
626     }
627 
628     // verifies that the address is different than this contract address
629     modifier notThis(address _address) {
630         require(_address != address(this));
631         _;
632     }
633 
634     // Overflow protected math functions
635 
636     /**
637         @dev returns the sum of _x and _y, asserts if the calculation overflows
638 
639         @param _x   value 1
640         @param _y   value 2
641 
642         @return sum
643     */
644     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
645         uint256 z = _x + _y;
646         assert(z >= _x);
647         return z;
648     }
649 
650     /**
651         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
652 
653         @param _x   minuend
654         @param _y   subtrahend
655 
656         @return difference
657     */
658     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
659         assert(_x >= _y);
660         return _x - _y;
661     }
662 
663     /**
664         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
665 
666         @param _x   factor 1
667         @param _y   factor 2
668 
669         @return product
670     */
671     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
672         uint256 z = _x * _y;
673         assert(_x == 0 || z / _x == _y);
674         return z;
675     }
676 }
677 
678 // File: bancor-contracts/solidity/contracts/converter/BancorFormula.sol
679 
680 pragma solidity ^0.4.24;
681 
682 
683 
684 contract BancorFormula is IBancorFormula, Utils {
685     string public version = '0.3';
686 
687     uint256 private constant ONE = 1;
688     uint32 private constant MAX_WEIGHT = 1000000;
689     uint8 private constant MIN_PRECISION = 32;
690     uint8 private constant MAX_PRECISION = 127;
691 
692     /**
693         Auto-generated via 'PrintIntScalingFactors.py'
694     */
695     uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
696     uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
697     uint256 private constant MAX_NUM = 0x200000000000000000000000000000000;
698 
699     /**
700         Auto-generated via 'PrintLn2ScalingFactors.py'
701     */
702     uint256 private constant LN2_NUMERATOR   = 0x3f80fe03f80fe03f80fe03f80fe03f8;
703     uint256 private constant LN2_DENOMINATOR = 0x5b9de1d10bf4103d647b0955897ba80;
704 
705     /**
706         Auto-generated via 'PrintFunctionOptimalLog.py' and 'PrintFunctionOptimalExp.py'
707     */
708     uint256 private constant OPT_LOG_MAX_VAL = 0x15bf0a8b1457695355fb8ac404e7a79e3;
709     uint256 private constant OPT_EXP_MAX_VAL = 0x800000000000000000000000000000000;
710 
711     /**
712         Auto-generated via 'PrintFunctionConstructor.py'
713     */
714     uint256[128] private maxExpArray;
715     constructor() public {
716     //  maxExpArray[  0] = 0x6bffffffffffffffffffffffffffffffff;
717     //  maxExpArray[  1] = 0x67ffffffffffffffffffffffffffffffff;
718     //  maxExpArray[  2] = 0x637fffffffffffffffffffffffffffffff;
719     //  maxExpArray[  3] = 0x5f6fffffffffffffffffffffffffffffff;
720     //  maxExpArray[  4] = 0x5b77ffffffffffffffffffffffffffffff;
721     //  maxExpArray[  5] = 0x57b3ffffffffffffffffffffffffffffff;
722     //  maxExpArray[  6] = 0x5419ffffffffffffffffffffffffffffff;
723     //  maxExpArray[  7] = 0x50a2ffffffffffffffffffffffffffffff;
724     //  maxExpArray[  8] = 0x4d517fffffffffffffffffffffffffffff;
725     //  maxExpArray[  9] = 0x4a233fffffffffffffffffffffffffffff;
726     //  maxExpArray[ 10] = 0x47165fffffffffffffffffffffffffffff;
727     //  maxExpArray[ 11] = 0x4429afffffffffffffffffffffffffffff;
728     //  maxExpArray[ 12] = 0x415bc7ffffffffffffffffffffffffffff;
729     //  maxExpArray[ 13] = 0x3eab73ffffffffffffffffffffffffffff;
730     //  maxExpArray[ 14] = 0x3c1771ffffffffffffffffffffffffffff;
731     //  maxExpArray[ 15] = 0x399e96ffffffffffffffffffffffffffff;
732     //  maxExpArray[ 16] = 0x373fc47fffffffffffffffffffffffffff;
733     //  maxExpArray[ 17] = 0x34f9e8ffffffffffffffffffffffffffff;
734     //  maxExpArray[ 18] = 0x32cbfd5fffffffffffffffffffffffffff;
735     //  maxExpArray[ 19] = 0x30b5057fffffffffffffffffffffffffff;
736     //  maxExpArray[ 20] = 0x2eb40f9fffffffffffffffffffffffffff;
737     //  maxExpArray[ 21] = 0x2cc8340fffffffffffffffffffffffffff;
738     //  maxExpArray[ 22] = 0x2af09481ffffffffffffffffffffffffff;
739     //  maxExpArray[ 23] = 0x292c5bddffffffffffffffffffffffffff;
740     //  maxExpArray[ 24] = 0x277abdcdffffffffffffffffffffffffff;
741     //  maxExpArray[ 25] = 0x25daf6657fffffffffffffffffffffffff;
742     //  maxExpArray[ 26] = 0x244c49c65fffffffffffffffffffffffff;
743     //  maxExpArray[ 27] = 0x22ce03cd5fffffffffffffffffffffffff;
744     //  maxExpArray[ 28] = 0x215f77c047ffffffffffffffffffffffff;
745     //  maxExpArray[ 29] = 0x1fffffffffffffffffffffffffffffffff;
746     //  maxExpArray[ 30] = 0x1eaefdbdabffffffffffffffffffffffff;
747     //  maxExpArray[ 31] = 0x1d6bd8b2ebffffffffffffffffffffffff;
748         maxExpArray[ 32] = 0x1c35fedd14ffffffffffffffffffffffff;
749         maxExpArray[ 33] = 0x1b0ce43b323fffffffffffffffffffffff;
750         maxExpArray[ 34] = 0x19f0028ec1ffffffffffffffffffffffff;
751         maxExpArray[ 35] = 0x18ded91f0e7fffffffffffffffffffffff;
752         maxExpArray[ 36] = 0x17d8ec7f0417ffffffffffffffffffffff;
753         maxExpArray[ 37] = 0x16ddc6556cdbffffffffffffffffffffff;
754         maxExpArray[ 38] = 0x15ecf52776a1ffffffffffffffffffffff;
755         maxExpArray[ 39] = 0x15060c256cb2ffffffffffffffffffffff;
756         maxExpArray[ 40] = 0x1428a2f98d72ffffffffffffffffffffff;
757         maxExpArray[ 41] = 0x13545598e5c23fffffffffffffffffffff;
758         maxExpArray[ 42] = 0x1288c4161ce1dfffffffffffffffffffff;
759         maxExpArray[ 43] = 0x11c592761c666fffffffffffffffffffff;
760         maxExpArray[ 44] = 0x110a688680a757ffffffffffffffffffff;
761         maxExpArray[ 45] = 0x1056f1b5bedf77ffffffffffffffffffff;
762         maxExpArray[ 46] = 0x0faadceceeff8bffffffffffffffffffff;
763         maxExpArray[ 47] = 0x0f05dc6b27edadffffffffffffffffffff;
764         maxExpArray[ 48] = 0x0e67a5a25da4107fffffffffffffffffff;
765         maxExpArray[ 49] = 0x0dcff115b14eedffffffffffffffffffff;
766         maxExpArray[ 50] = 0x0d3e7a392431239fffffffffffffffffff;
767         maxExpArray[ 51] = 0x0cb2ff529eb71e4fffffffffffffffffff;
768         maxExpArray[ 52] = 0x0c2d415c3db974afffffffffffffffffff;
769         maxExpArray[ 53] = 0x0bad03e7d883f69bffffffffffffffffff;
770         maxExpArray[ 54] = 0x0b320d03b2c343d5ffffffffffffffffff;
771         maxExpArray[ 55] = 0x0abc25204e02828dffffffffffffffffff;
772         maxExpArray[ 56] = 0x0a4b16f74ee4bb207fffffffffffffffff;
773         maxExpArray[ 57] = 0x09deaf736ac1f569ffffffffffffffffff;
774         maxExpArray[ 58] = 0x0976bd9952c7aa957fffffffffffffffff;
775         maxExpArray[ 59] = 0x09131271922eaa606fffffffffffffffff;
776         maxExpArray[ 60] = 0x08b380f3558668c46fffffffffffffffff;
777         maxExpArray[ 61] = 0x0857ddf0117efa215bffffffffffffffff;
778         maxExpArray[ 62] = 0x07ffffffffffffffffffffffffffffffff;
779         maxExpArray[ 63] = 0x07abbf6f6abb9d087fffffffffffffffff;
780         maxExpArray[ 64] = 0x075af62cbac95f7dfa7fffffffffffffff;
781         maxExpArray[ 65] = 0x070d7fb7452e187ac13fffffffffffffff;
782         maxExpArray[ 66] = 0x06c3390ecc8af379295fffffffffffffff;
783         maxExpArray[ 67] = 0x067c00a3b07ffc01fd6fffffffffffffff;
784         maxExpArray[ 68] = 0x0637b647c39cbb9d3d27ffffffffffffff;
785         maxExpArray[ 69] = 0x05f63b1fc104dbd39587ffffffffffffff;
786         maxExpArray[ 70] = 0x05b771955b36e12f7235ffffffffffffff;
787         maxExpArray[ 71] = 0x057b3d49dda84556d6f6ffffffffffffff;
788         maxExpArray[ 72] = 0x054183095b2c8ececf30ffffffffffffff;
789         maxExpArray[ 73] = 0x050a28be635ca2b888f77fffffffffffff;
790         maxExpArray[ 74] = 0x04d5156639708c9db33c3fffffffffffff;
791         maxExpArray[ 75] = 0x04a23105873875bd52dfdfffffffffffff;
792         maxExpArray[ 76] = 0x0471649d87199aa990756fffffffffffff;
793         maxExpArray[ 77] = 0x04429a21a029d4c1457cfbffffffffffff;
794         maxExpArray[ 78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;
795         maxExpArray[ 79] = 0x03eab73b3bbfe282243ce1ffffffffffff;
796         maxExpArray[ 80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;
797         maxExpArray[ 81] = 0x0399e96897690418f785257fffffffffff;
798         maxExpArray[ 82] = 0x0373fc456c53bb779bf0ea9fffffffffff;
799         maxExpArray[ 83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;
800         maxExpArray[ 84] = 0x032cbfd4a7adc790560b3337ffffffffff;
801         maxExpArray[ 85] = 0x030b50570f6e5d2acca94613ffffffffff;
802         maxExpArray[ 86] = 0x02eb40f9f620fda6b56c2861ffffffffff;
803         maxExpArray[ 87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;
804         maxExpArray[ 88] = 0x02af09481380a0a35cf1ba02ffffffffff;
805         maxExpArray[ 89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;
806         maxExpArray[ 90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;
807         maxExpArray[ 91] = 0x025daf6654b1eaa55fd64df5efffffffff;
808         maxExpArray[ 92] = 0x0244c49c648baa98192dce88b7ffffffff;
809         maxExpArray[ 93] = 0x022ce03cd5619a311b2471268bffffffff;
810         maxExpArray[ 94] = 0x0215f77c045fbe885654a44a0fffffffff;
811         maxExpArray[ 95] = 0x01ffffffffffffffffffffffffffffffff;
812         maxExpArray[ 96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;
813         maxExpArray[ 97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;
814         maxExpArray[ 98] = 0x01c35fedd14b861eb0443f7f133fffffff;
815         maxExpArray[ 99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;
816         maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;
817         maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;
818         maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;
819         maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;
820         maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;
821         maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;
822         maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;
823         maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;
824         maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;
825         maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;
826         maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;
827         maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;
828         maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;
829         maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;
830         maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;
831         maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;
832         maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;
833         maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;
834         maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;
835         maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;
836         maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;
837         maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;
838         maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;
839         maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;
840         maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;
841         maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;
842         maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;
843         maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;
844     }
845 
846     /**
847         @dev given a token supply, connector balance, weight and a deposit amount (in the connector token),
848         calculates the return for a given conversion (in the main token)
849 
850         Formula:
851         Return = _supply * ((1 + _depositAmount / _connectorBalance) ^ (_connectorWeight / 1000000) - 1)
852 
853         @param _supply              token total supply
854         @param _connectorBalance    total connector balance
855         @param _connectorWeight     connector weight, represented in ppm, 1-1000000
856         @param _depositAmount       deposit amount, in connector token
857 
858         @return purchase return amount
859     */
860     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256) {
861         // validate input
862         require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT);
863 
864         // special case for 0 deposit amount
865         if (_depositAmount == 0)
866             return 0;
867 
868         // special case if the weight = 100%
869         if (_connectorWeight == MAX_WEIGHT)
870             return safeMul(_supply, _depositAmount) / _connectorBalance;
871 
872         uint256 result;
873         uint8 precision;
874         uint256 baseN = safeAdd(_depositAmount, _connectorBalance);
875         (result, precision) = power(baseN, _connectorBalance, _connectorWeight, MAX_WEIGHT);
876         uint256 temp = safeMul(_supply, result) >> precision;
877         return temp - _supply;
878     }
879 
880     /**
881         @dev given a token supply, connector balance, weight and a sell amount (in the main token),
882         calculates the return for a given conversion (in the connector token)
883 
884         Formula:
885         Return = _connectorBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_connectorWeight / 1000000)))
886 
887         @param _supply              token total supply
888         @param _connectorBalance    total connector
889         @param _connectorWeight     constant connector Weight, represented in ppm, 1-1000000
890         @param _sellAmount          sell amount, in the token itself
891 
892         @return sale return amount
893     */
894     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256) {
895         // validate input
896         require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT && _sellAmount <= _supply);
897 
898         // special case for 0 sell amount
899         if (_sellAmount == 0)
900             return 0;
901 
902         // special case for selling the entire supply
903         if (_sellAmount == _supply)
904             return _connectorBalance;
905 
906         // special case if the weight = 100%
907         if (_connectorWeight == MAX_WEIGHT)
908             return safeMul(_connectorBalance, _sellAmount) / _supply;
909 
910         uint256 result;
911         uint8 precision;
912         uint256 baseD = _supply - _sellAmount;
913         (result, precision) = power(_supply, baseD, MAX_WEIGHT, _connectorWeight);
914         uint256 temp1 = safeMul(_connectorBalance, result);
915         uint256 temp2 = _connectorBalance << precision;
916         return (temp1 - temp2) / result;
917     }
918 
919     /**
920         @dev given two connector balances/weights and a sell amount (in the first connector token),
921         calculates the return for a conversion from the first connector token to the second connector token (in the second connector token)
922 
923         Formula:
924         Return = _toConnectorBalance * (1 - (_fromConnectorBalance / (_fromConnectorBalance + _amount)) ^ (_fromConnectorWeight / _toConnectorWeight))
925 
926         @param _fromConnectorBalance    input connector balance
927         @param _fromConnectorWeight     input connector weight, represented in ppm, 1-1000000
928         @param _toConnectorBalance      output connector balance
929         @param _toConnectorWeight       output connector weight, represented in ppm, 1-1000000
930         @param _amount                  input connector amount
931 
932         @return second connector amount
933     */
934     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256) {
935         // validate input
936         require(_fromConnectorBalance > 0 && _fromConnectorWeight > 0 && _fromConnectorWeight <= MAX_WEIGHT && _toConnectorBalance > 0 && _toConnectorWeight > 0 && _toConnectorWeight <= MAX_WEIGHT);
937 
938         // special case for equal weights
939         if (_fromConnectorWeight == _toConnectorWeight)
940             return safeMul(_toConnectorBalance, _amount) / safeAdd(_fromConnectorBalance, _amount);
941 
942         uint256 result;
943         uint8 precision;
944         uint256 baseN = safeAdd(_fromConnectorBalance, _amount);
945         (result, precision) = power(baseN, _fromConnectorBalance, _fromConnectorWeight, _toConnectorWeight);
946         uint256 temp1 = safeMul(_toConnectorBalance, result);
947         uint256 temp2 = _toConnectorBalance << precision;
948         return (temp1 - temp2) / result;
949     }
950 
951     /**
952         General Description:
953             Determine a value of precision.
954             Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.
955             Return the result along with the precision used.
956 
957         Detailed Description:
958             Instead of calculating "base ^ exp", we calculate "e ^ (log(base) * exp)".
959             The value of "log(base)" is represented with an integer slightly smaller than "log(base) * 2 ^ precision".
960             The larger "precision" is, the more accurately this value represents the real value.
961             However, the larger "precision" is, the more bits are required in order to store this value.
962             And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").
963             This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
964             Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.
965             This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.
966             This functions assumes that "_expN < 2 ^ 256 / log(MAX_NUM - 1)", otherwise the multiplication should be replaced with a "safeMul".
967     */
968     function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) internal view returns (uint256, uint8) {
969         require(_baseN < MAX_NUM);
970 
971         uint256 baseLog;
972         uint256 base = _baseN * FIXED_1 / _baseD;
973         if (base < OPT_LOG_MAX_VAL) {
974             baseLog = optimalLog(base);
975         }
976         else {
977             baseLog = generalLog(base);
978         }
979 
980         uint256 baseLogTimesExp = baseLog * _expN / _expD;
981         if (baseLogTimesExp < OPT_EXP_MAX_VAL) {
982             return (optimalExp(baseLogTimesExp), MAX_PRECISION);
983         }
984         else {
985             uint8 precision = findPositionInMaxExpArray(baseLogTimesExp);
986             return (generalExp(baseLogTimesExp >> (MAX_PRECISION - precision), precision), precision);
987         }
988     }
989 
990     /**
991         Compute log(x / FIXED_1) * FIXED_1.
992         This functions assumes that "x >= FIXED_1", because the output would be negative otherwise.
993     */
994     function generalLog(uint256 x) internal pure returns (uint256) {
995         uint256 res = 0;
996 
997         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
998         if (x >= FIXED_2) {
999             uint8 count = floorLog2(x / FIXED_1);
1000             x >>= count; // now x < 2
1001             res = count * FIXED_1;
1002         }
1003 
1004         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
1005         if (x > FIXED_1) {
1006             for (uint8 i = MAX_PRECISION; i > 0; --i) {
1007                 x = (x * x) / FIXED_1; // now 1 < x < 4
1008                 if (x >= FIXED_2) {
1009                     x >>= 1; // now 1 < x < 2
1010                     res += ONE << (i - 1);
1011                 }
1012             }
1013         }
1014 
1015         return res * LN2_NUMERATOR / LN2_DENOMINATOR;
1016     }
1017 
1018     /**
1019         Compute the largest integer smaller than or equal to the binary logarithm of the input.
1020     */
1021     function floorLog2(uint256 _n) internal pure returns (uint8) {
1022         uint8 res = 0;
1023 
1024         if (_n < 256) {
1025             // At most 8 iterations
1026             while (_n > 1) {
1027                 _n >>= 1;
1028                 res += 1;
1029             }
1030         }
1031         else {
1032             // Exactly 8 iterations
1033             for (uint8 s = 128; s > 0; s >>= 1) {
1034                 if (_n >= (ONE << s)) {
1035                     _n >>= s;
1036                     res |= s;
1037                 }
1038             }
1039         }
1040 
1041         return res;
1042     }
1043 
1044     /**
1045         The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:
1046         - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]
1047         - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]
1048     */
1049     function findPositionInMaxExpArray(uint256 _x) internal view returns (uint8) {
1050         uint8 lo = MIN_PRECISION;
1051         uint8 hi = MAX_PRECISION;
1052 
1053         while (lo + 1 < hi) {
1054             uint8 mid = (lo + hi) / 2;
1055             if (maxExpArray[mid] >= _x)
1056                 lo = mid;
1057             else
1058                 hi = mid;
1059         }
1060 
1061         if (maxExpArray[hi] >= _x)
1062             return hi;
1063         if (maxExpArray[lo] >= _x)
1064             return lo;
1065 
1066         require(false);
1067         return 0;
1068     }
1069 
1070     /**
1071         This function can be auto-generated by the script 'PrintFunctionGeneralExp.py'.
1072         It approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".
1073         It returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.
1074         The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".
1075         The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
1076     */
1077     function generalExp(uint256 _x, uint8 _precision) internal pure returns (uint256) {
1078         uint256 xi = _x;
1079         uint256 res = 0;
1080 
1081         xi = (xi * _x) >> _precision; res += xi * 0x3442c4e6074a82f1797f72ac0000000; // add x^02 * (33! / 02!)
1082         xi = (xi * _x) >> _precision; res += xi * 0x116b96f757c380fb287fd0e40000000; // add x^03 * (33! / 03!)
1083         xi = (xi * _x) >> _precision; res += xi * 0x045ae5bdd5f0e03eca1ff4390000000; // add x^04 * (33! / 04!)
1084         xi = (xi * _x) >> _precision; res += xi * 0x00defabf91302cd95b9ffda50000000; // add x^05 * (33! / 05!)
1085         xi = (xi * _x) >> _precision; res += xi * 0x002529ca9832b22439efff9b8000000; // add x^06 * (33! / 06!)
1086         xi = (xi * _x) >> _precision; res += xi * 0x00054f1cf12bd04e516b6da88000000; // add x^07 * (33! / 07!)
1087         xi = (xi * _x) >> _precision; res += xi * 0x0000a9e39e257a09ca2d6db51000000; // add x^08 * (33! / 08!)
1088         xi = (xi * _x) >> _precision; res += xi * 0x000012e066e7b839fa050c309000000; // add x^09 * (33! / 09!)
1089         xi = (xi * _x) >> _precision; res += xi * 0x000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)
1090         xi = (xi * _x) >> _precision; res += xi * 0x0000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)
1091         xi = (xi * _x) >> _precision; res += xi * 0x00000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)
1092         xi = (xi * _x) >> _precision; res += xi * 0x0000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)
1093         xi = (xi * _x) >> _precision; res += xi * 0x0000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)
1094         xi = (xi * _x) >> _precision; res += xi * 0x000000000057e22099c030d94100000; // add x^15 * (33! / 15!)
1095         xi = (xi * _x) >> _precision; res += xi * 0x0000000000057e22099c030d9410000; // add x^16 * (33! / 16!)
1096         xi = (xi * _x) >> _precision; res += xi * 0x00000000000052b6b54569976310000; // add x^17 * (33! / 17!)
1097         xi = (xi * _x) >> _precision; res += xi * 0x00000000000004985f67696bf748000; // add x^18 * (33! / 18!)
1098         xi = (xi * _x) >> _precision; res += xi * 0x000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)
1099         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000031880f2214b6e000; // add x^20 * (33! / 20!)
1100         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)
1101         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)
1102         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000001317c70077000; // add x^23 * (33! / 23!)
1103         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000cba84aafa00; // add x^24 * (33! / 24!)
1104         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000082573a0a00; // add x^25 * (33! / 25!)
1105         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000005035ad900; // add x^26 * (33! / 26!)
1106         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000000000002f881b00; // add x^27 * (33! / 27!)
1107         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000001b29340; // add x^28 * (33! / 28!)
1108         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000000000efc40; // add x^29 * (33! / 29!)
1109         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000007fe0; // add x^30 * (33! / 30!)
1110         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000420; // add x^31 * (33! / 31!)
1111         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000021; // add x^32 * (33! / 32!)
1112         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000001; // add x^33 * (33! / 33!)
1113 
1114         return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!
1115     }
1116 
1117     /**
1118         Return log(x / FIXED_1) * FIXED_1
1119         Input range: FIXED_1 <= x <= LOG_EXP_MAX_VAL - 1
1120         Auto-generated via 'PrintFunctionOptimalLog.py'
1121         Detailed description:
1122         - Rewrite the input as a product of natural exponents and a single residual r, such that 1 < r < 2
1123         - The natural logarithm of each (pre-calculated) exponent is the degree of the exponent
1124         - The natural logarithm of r is calculated via Taylor series for log(1 + x), where x = r - 1
1125         - The natural logarithm of the input is calculated by summing up the intermediate results above
1126         - For example: log(250) = log(e^4 * e^1 * e^0.5 * 1.021692859) = 4 + 1 + 0.5 + log(1 + 0.021692859)
1127     */
1128     function optimalLog(uint256 x) internal pure returns (uint256) {
1129         uint256 res = 0;
1130 
1131         uint256 y;
1132         uint256 z;
1133         uint256 w;
1134 
1135         if (x >= 0xd3094c70f034de4b96ff7d5b6f99fcd8) {res += 0x40000000000000000000000000000000; x = x * FIXED_1 / 0xd3094c70f034de4b96ff7d5b6f99fcd8;} // add 1 / 2^1
1136         if (x >= 0xa45af1e1f40c333b3de1db4dd55f29a7) {res += 0x20000000000000000000000000000000; x = x * FIXED_1 / 0xa45af1e1f40c333b3de1db4dd55f29a7;} // add 1 / 2^2
1137         if (x >= 0x910b022db7ae67ce76b441c27035c6a1) {res += 0x10000000000000000000000000000000; x = x * FIXED_1 / 0x910b022db7ae67ce76b441c27035c6a1;} // add 1 / 2^3
1138         if (x >= 0x88415abbe9a76bead8d00cf112e4d4a8) {res += 0x08000000000000000000000000000000; x = x * FIXED_1 / 0x88415abbe9a76bead8d00cf112e4d4a8;} // add 1 / 2^4
1139         if (x >= 0x84102b00893f64c705e841d5d4064bd3) {res += 0x04000000000000000000000000000000; x = x * FIXED_1 / 0x84102b00893f64c705e841d5d4064bd3;} // add 1 / 2^5
1140         if (x >= 0x8204055aaef1c8bd5c3259f4822735a2) {res += 0x02000000000000000000000000000000; x = x * FIXED_1 / 0x8204055aaef1c8bd5c3259f4822735a2;} // add 1 / 2^6
1141         if (x >= 0x810100ab00222d861931c15e39b44e99) {res += 0x01000000000000000000000000000000; x = x * FIXED_1 / 0x810100ab00222d861931c15e39b44e99;} // add 1 / 2^7
1142         if (x >= 0x808040155aabbbe9451521693554f733) {res += 0x00800000000000000000000000000000; x = x * FIXED_1 / 0x808040155aabbbe9451521693554f733;} // add 1 / 2^8
1143 
1144         z = y = x - FIXED_1;
1145         w = y * y / FIXED_1;
1146         res += z * (0x100000000000000000000000000000000 - y) / 0x100000000000000000000000000000000; z = z * w / FIXED_1; // add y^01 / 01 - y^02 / 02
1147         res += z * (0x0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa - y) / 0x200000000000000000000000000000000; z = z * w / FIXED_1; // add y^03 / 03 - y^04 / 04
1148         res += z * (0x099999999999999999999999999999999 - y) / 0x300000000000000000000000000000000; z = z * w / FIXED_1; // add y^05 / 05 - y^06 / 06
1149         res += z * (0x092492492492492492492492492492492 - y) / 0x400000000000000000000000000000000; z = z * w / FIXED_1; // add y^07 / 07 - y^08 / 08
1150         res += z * (0x08e38e38e38e38e38e38e38e38e38e38e - y) / 0x500000000000000000000000000000000; z = z * w / FIXED_1; // add y^09 / 09 - y^10 / 10
1151         res += z * (0x08ba2e8ba2e8ba2e8ba2e8ba2e8ba2e8b - y) / 0x600000000000000000000000000000000; z = z * w / FIXED_1; // add y^11 / 11 - y^12 / 12
1152         res += z * (0x089d89d89d89d89d89d89d89d89d89d89 - y) / 0x700000000000000000000000000000000; z = z * w / FIXED_1; // add y^13 / 13 - y^14 / 14
1153         res += z * (0x088888888888888888888888888888888 - y) / 0x800000000000000000000000000000000;                      // add y^15 / 15 - y^16 / 16
1154 
1155         return res;
1156     }
1157 
1158     /**
1159         Return e ^ (x / FIXED_1) * FIXED_1
1160         Input range: 0 <= x <= OPT_EXP_MAX_VAL - 1
1161         Auto-generated via 'PrintFunctionOptimalExp.py'
1162         Detailed description:
1163         - Rewrite the input as a sum of binary exponents and a single residual r, as small as possible
1164         - The exponentiation of each binary exponent is given (pre-calculated)
1165         - The exponentiation of r is calculated via Taylor series for e^x, where x = r
1166         - The exponentiation of the input is calculated by multiplying the intermediate results above
1167         - For example: e^5.021692859 = e^(4 + 1 + 0.5 + 0.021692859) = e^4 * e^1 * e^0.5 * e^0.021692859
1168     */
1169     function optimalExp(uint256 x) internal pure returns (uint256) {
1170         uint256 res = 0;
1171 
1172         uint256 y;
1173         uint256 z;
1174 
1175         z = y = x % 0x10000000000000000000000000000000; // get the input modulo 2^(-3)
1176         z = z * y / FIXED_1; res += z * 0x10e1b3be415a0000; // add y^02 * (20! / 02!)
1177         z = z * y / FIXED_1; res += z * 0x05a0913f6b1e0000; // add y^03 * (20! / 03!)
1178         z = z * y / FIXED_1; res += z * 0x0168244fdac78000; // add y^04 * (20! / 04!)
1179         z = z * y / FIXED_1; res += z * 0x004807432bc18000; // add y^05 * (20! / 05!)
1180         z = z * y / FIXED_1; res += z * 0x000c0135dca04000; // add y^06 * (20! / 06!)
1181         z = z * y / FIXED_1; res += z * 0x0001b707b1cdc000; // add y^07 * (20! / 07!)
1182         z = z * y / FIXED_1; res += z * 0x000036e0f639b800; // add y^08 * (20! / 08!)
1183         z = z * y / FIXED_1; res += z * 0x00000618fee9f800; // add y^09 * (20! / 09!)
1184         z = z * y / FIXED_1; res += z * 0x0000009c197dcc00; // add y^10 * (20! / 10!)
1185         z = z * y / FIXED_1; res += z * 0x0000000e30dce400; // add y^11 * (20! / 11!)
1186         z = z * y / FIXED_1; res += z * 0x000000012ebd1300; // add y^12 * (20! / 12!)
1187         z = z * y / FIXED_1; res += z * 0x0000000017499f00; // add y^13 * (20! / 13!)
1188         z = z * y / FIXED_1; res += z * 0x0000000001a9d480; // add y^14 * (20! / 14!)
1189         z = z * y / FIXED_1; res += z * 0x00000000001c6380; // add y^15 * (20! / 15!)
1190         z = z * y / FIXED_1; res += z * 0x000000000001c638; // add y^16 * (20! / 16!)
1191         z = z * y / FIXED_1; res += z * 0x0000000000001ab8; // add y^17 * (20! / 17!)
1192         z = z * y / FIXED_1; res += z * 0x000000000000017c; // add y^18 * (20! / 18!)
1193         z = z * y / FIXED_1; res += z * 0x0000000000000014; // add y^19 * (20! / 19!)
1194         z = z * y / FIXED_1; res += z * 0x0000000000000001; // add y^20 * (20! / 20!)
1195         res = res / 0x21c3677c82b40000 + y + FIXED_1; // divide by 20! and then add y^1 / 1! + y^0 / 0!
1196 
1197         if ((x & 0x010000000000000000000000000000000) != 0) res = res * 0x1c3d6a24ed82218787d624d3e5eba95f9 / 0x18ebef9eac820ae8682b9793ac6d1e776; // multiply by e^2^(-3)
1198         if ((x & 0x020000000000000000000000000000000) != 0) res = res * 0x18ebef9eac820ae8682b9793ac6d1e778 / 0x1368b2fc6f9609fe7aceb46aa619baed4; // multiply by e^2^(-2)
1199         if ((x & 0x040000000000000000000000000000000) != 0) res = res * 0x1368b2fc6f9609fe7aceb46aa619baed5 / 0x0bc5ab1b16779be3575bd8f0520a9f21f; // multiply by e^2^(-1)
1200         if ((x & 0x080000000000000000000000000000000) != 0) res = res * 0x0bc5ab1b16779be3575bd8f0520a9f21e / 0x0454aaa8efe072e7f6ddbab84b40a55c9; // multiply by e^2^(+0)
1201         if ((x & 0x100000000000000000000000000000000) != 0) res = res * 0x0454aaa8efe072e7f6ddbab84b40a55c5 / 0x00960aadc109e7a3bf4578099615711ea; // multiply by e^2^(+1)
1202         if ((x & 0x200000000000000000000000000000000) != 0) res = res * 0x00960aadc109e7a3bf4578099615711d7 / 0x0002bf84208204f5977f9a8cf01fdce3d; // multiply by e^2^(+2)
1203         if ((x & 0x400000000000000000000000000000000) != 0) res = res * 0x0002bf84208204f5977f9a8cf01fdc307 / 0x0000003c6ab775dd0b95b4cbee7e65d11; // multiply by e^2^(+3)
1204 
1205         return res;
1206     }
1207 }
1208 
1209 // File: contracts/helpers/Admin.sol
1210 
1211 pragma solidity ^0.4.24;
1212 
1213 
1214 /**
1215  * @title Ownable
1216  * @dev The Ownable contract has an admin address, and provides basic authorization control
1217  * functions, this simplifies the implementation of "user permissions".
1218  */
1219 contract Admin {
1220   mapping (address => bool) public admins;
1221 
1222 
1223   event AdminshipRenounced(address indexed previousAdmin);
1224   event AdminshipTransferred(
1225     address indexed previousAdmin,
1226     address indexed newAdmin
1227   );
1228 
1229 
1230   /**
1231    * @dev The Ownable constructor sets the original `admin` of the contract to the sender
1232    * account.
1233    */
1234   constructor() public {
1235     admins[msg.sender] = true;
1236   }
1237 
1238   /**
1239    * @dev Throws if called by any account other than the admin.
1240    */
1241   modifier onlyAdmin() {
1242     require(admins[msg.sender]);
1243     _;
1244   }
1245 
1246   function isAdmin(address _admin) public view returns(bool) {
1247     return admins[_admin];
1248   }
1249 
1250   /**
1251    * @dev Allows the current admin to relinquish control of the contract.
1252    * @notice Renouncing to adminship will leave the contract without an admin.
1253    * It will not be possible to call the functions with the `onlyAdmin`
1254    * modifier anymore.
1255    */
1256   function renounceAdminship(address _previousAdmin) public onlyAdmin {
1257     emit AdminshipRenounced(_previousAdmin);
1258     admins[_previousAdmin] = false;
1259   }
1260 
1261   /**
1262    * @dev Allows the current admin to transfer control of the contract to a newAdmin.
1263    * @param _newAdmin The address to transfer adminship to.
1264    */
1265   function transferAdminship(address _newAdmin) public onlyAdmin {
1266     _transferAdminship(_newAdmin);
1267   }
1268 
1269   /**
1270    * @dev Transfers control of the contract to a newAdmin.
1271    * @param _newAdmin The address to transfer adminship to.
1272    */
1273   function _transferAdminship(address _newAdmin) internal {
1274     require(_newAdmin != address(0));
1275     emit AdminshipTransferred(msg.sender, _newAdmin);
1276     admins[_newAdmin] = true;
1277   }
1278 }
1279 
1280 // File: contracts/ClubTokenController.sol
1281 
1282 pragma solidity ^0.4.18;
1283 
1284 /**
1285 * The ClubTokenController is a replaceable endpoint for minting and unminting ClubToken.sol
1286 */
1287 
1288 
1289 
1290 
1291 
1292 contract ClubTokenController is BancorFormula, Admin, Ownable {
1293     event Buy(address buyer, uint256 tokens, uint256 value, uint256 poolBalance, uint256 tokenSupply);
1294     event Sell(address seller, uint256 tokens, uint256 value, uint256 poolBalance, uint256 tokenSupply);
1295 
1296     bool public paused;
1297     address public clubToken;
1298     address public simpleCloversMarket;
1299     address public curationMarket;
1300     address public support;
1301 
1302     /* uint256 public poolBalance; */
1303     uint256 public virtualSupply;
1304     uint256 public virtualBalance;
1305     uint32 public reserveRatio; // represented in ppm, 1-1000000
1306 
1307     constructor(address _clubToken) public {
1308         clubToken = _clubToken;
1309         paused = true;
1310     }
1311 
1312     function () public payable {
1313         buy(msg.sender);
1314     }
1315 
1316     modifier notPaused() {
1317         require(!paused || owner == msg.sender || admins[tx.origin], "Contract must not be paused");
1318         _;
1319     }
1320 
1321     function poolBalance() public constant returns(uint256) {
1322         return clubToken.balance;
1323     }
1324 
1325     /**
1326     * @dev gets the amount of tokens returned from spending Eth
1327     * @param buyValue The amount of Eth to be spent
1328     * @return A uint256 representing the amount of tokens gained in exchange for the Eth.
1329     */
1330     function getBuy(uint256 buyValue) public constant returns(uint256) {
1331         return calculatePurchaseReturn(
1332             safeAdd(ClubToken(clubToken).totalSupply(), virtualSupply),
1333             safeAdd(poolBalance(), virtualBalance),
1334             reserveRatio,
1335             buyValue);
1336     }
1337 
1338 
1339     /**
1340     * @dev gets the amount of Eth returned from selling tokens
1341     * @param sellAmount The amount of tokens to be sold
1342     * @return A uint256 representing the amount of Eth gained in exchange for the tokens.
1343     */
1344 
1345     function getSell(uint256 sellAmount) public constant returns(uint256) {
1346         return calculateSaleReturn(
1347             safeAdd(ClubToken(clubToken).totalSupply(), virtualSupply),
1348             safeAdd(poolBalance(), virtualBalance),
1349             reserveRatio,
1350             sellAmount);
1351     }
1352 
1353     function updatePaused(bool _paused) public onlyOwner {
1354         paused = _paused;
1355     }
1356 
1357     /**
1358     * @dev updates the Reserve Ratio variable
1359     * @param _reserveRatio The reserve ratio that determines the curve
1360     * @return A boolean representing whether or not the update was successful.
1361     */
1362     function updateReserveRatio(uint32 _reserveRatio) public onlyOwner returns(bool){
1363         reserveRatio = _reserveRatio;
1364         return true;
1365     }
1366 
1367     /**
1368     * @dev updates the Virtual Supply variable
1369     * @param _virtualSupply The virtual supply of tokens used for calculating buys and sells
1370     * @return A boolean representing whether or not the update was successful.
1371     */
1372     function updateVirtualSupply(uint256 _virtualSupply) public onlyOwner returns(bool){
1373         virtualSupply = _virtualSupply;
1374         return true;
1375     }
1376 
1377     /**
1378     * @dev updates the Virtual Balance variable
1379     * @param _virtualBalance The virtual balance of the contract used for calculating buys and sells
1380     * @return A boolean representing whether or not the update was successful.
1381     */
1382     function updateVirtualBalance(uint256 _virtualBalance) public onlyOwner returns(bool){
1383         virtualBalance = _virtualBalance;
1384         return true;
1385     }
1386     /**
1387     * @dev updates the poolBalance
1388     * @param _poolBalance The eth balance of ClubToken.sol
1389     * @return A boolean representing whether or not the update was successful.
1390     */
1391     /* function updatePoolBalance(uint256 _poolBalance) public onlyOwner returns(bool){
1392         poolBalance = _poolBalance;
1393         return true;
1394     } */
1395 
1396     /**
1397     * @dev updates the SimpleCloversMarket address
1398     * @param _simpleCloversMarket The address of the simpleCloversMarket
1399     * @return A boolean representing whether or not the update was successful.
1400     */
1401     function updateSimpleCloversMarket(address _simpleCloversMarket) public onlyOwner returns(bool){
1402         simpleCloversMarket = _simpleCloversMarket;
1403         return true;
1404     }
1405 
1406     /**
1407     * @dev updates the CurationMarket address
1408     * @param _curationMarket The address of the curationMarket
1409     * @return A boolean representing whether or not the update was successful.
1410     */
1411     function updateCurationMarket(address _curationMarket) public onlyOwner returns(bool){
1412         curationMarket = _curationMarket;
1413         return true;
1414     }
1415 
1416     /**
1417     * @dev updates the Support address
1418     * @param _support The address of the Support
1419     * @return A boolean representing whether or not the update was successful.
1420     */
1421     function updateSupport(address _support) public onlyOwner returns(bool){
1422         support = _support;
1423         return true;
1424     }
1425 
1426     /**
1427     * @dev donate Donate Eth to the poolBalance without increasing the totalSupply
1428     */
1429     function donate() public payable {
1430         require(msg.value > 0);
1431         /* poolBalance = safeAdd(poolBalance, msg.value); */
1432         clubToken.transfer(msg.value);
1433     }
1434 
1435     function burn(address from, uint256 amount) public {
1436         require(msg.sender == simpleCloversMarket);
1437         ClubToken(clubToken).burn(from, amount);
1438     }
1439 
1440     function transferFrom(address from, address to, uint256 amount) public {
1441         require(msg.sender == simpleCloversMarket || msg.sender == curationMarket || msg.sender == support);
1442         ClubToken(clubToken).transferFrom(from, to, amount);
1443     }
1444 
1445     /**
1446     * @dev buy Buy ClubTokens with Eth
1447     * @param buyer The address that should receive the new tokens
1448     */
1449     function buy(address buyer) public payable notPaused returns(bool) {
1450         require(msg.value > 0);
1451         uint256 tokens = getBuy(msg.value);
1452         require(tokens > 0);
1453         require(ClubToken(clubToken).mint(buyer, tokens));
1454         /* poolBalance = safeAdd(poolBalance, msg.value); */
1455         clubToken.transfer(msg.value);
1456         emit Buy(buyer, tokens, msg.value, poolBalance(), ClubToken(clubToken).totalSupply());
1457     }
1458 
1459 
1460     /**
1461     * @dev sell Sell ClubTokens for Eth
1462     * @param sellAmount The amount of tokens to sell
1463     */
1464     function sell(uint256 sellAmount) public notPaused returns(bool) {
1465         require(sellAmount > 0);
1466         require(ClubToken(clubToken).balanceOf(msg.sender) >= sellAmount);
1467         uint256 saleReturn = getSell(sellAmount);
1468         require(saleReturn > 0);
1469         require(saleReturn <= poolBalance());
1470         require(saleReturn <= clubToken.balance);
1471         ClubToken(clubToken).burn(msg.sender, sellAmount);
1472         /* poolBalance = safeSub(poolBalance, saleReturn); */
1473         ClubToken(clubToken).moveEth(msg.sender, saleReturn);
1474         emit Sell(msg.sender, sellAmount, saleReturn, poolBalance(), ClubToken(clubToken).totalSupply());
1475     }
1476 
1477 
1478  }