1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 pragma solidity >=0.4.24 <0.6.0;
69 
70 
71 /**
72  * @title Initializable
73  *
74  * @dev Helper contract to support initializer functions. To use it, replace
75  * the constructor with a function that has the `initializer` modifier.
76  * WARNING: Unlike constructors, initializer functions must be manually
77  * invoked. This applies both to deploying an Initializable contract, as well
78  * as extending an Initializable contract via inheritance.
79  * WARNING: When used with inheritance, manual care must be taken to not invoke
80  * a parent initializer twice, or ensure that all initializers are idempotent,
81  * because this is not dealt with automatically as with constructors.
82  */
83 contract Initializable {
84 
85   /**
86    * @dev Indicates that the contract has been initialized.
87    */
88   bool private initialized;
89 
90   /**
91    * @dev Indicates that the contract is in the process of being initialized.
92    */
93   bool private initializing;
94 
95   /**
96    * @dev Modifier to use in the initializer function of a contract.
97    */
98   modifier initializer() {
99     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
100 
101     bool wasInitializing = initializing;
102     initializing = true;
103     initialized = true;
104 
105     _;
106 
107     initializing = wasInitializing;
108   }
109 
110   /// @dev Returns true if and only if the function is running in the constructor
111   function isConstructor() private view returns (bool) {
112     // extcodesize checks the size of the code stored in an address, and
113     // address returns the current address. Since the code is still not
114     // deployed when running a constructor, any checks on its code size will
115     // yield zero, making it an effective way to detect if a contract is
116     // under construction or not.
117     uint256 cs;
118     assembly { cs := extcodesize(address) }
119     return cs == 0;
120   }
121 
122   // Reserved storage space to allow for layout changes in the future.
123   uint256[50] private ______gap;
124 }
125 
126 pragma solidity ^0.4.24;
127 
128 
129 /**
130  * @title Ownable
131  * @dev The Ownable contract has an owner address, and provides basic authorization control
132  * functions, this simplifies the implementation of "user permissions".
133  */
134 contract Ownable is Initializable {
135   address private _owner;
136 
137 
138   event OwnershipRenounced(address indexed previousOwner);
139   event OwnershipTransferred(
140     address indexed previousOwner,
141     address indexed newOwner
142   );
143 
144 
145   /**
146    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147    * account.
148    */
149   function initialize(address sender) public initializer {
150     _owner = sender;
151   }
152 
153   /**
154    * @return the address of the owner.
155    */
156   function owner() public view returns(address) {
157     return _owner;
158   }
159 
160   /**
161    * @dev Throws if called by any account other than the owner.
162    */
163   modifier onlyOwner() {
164     require(isOwner());
165     _;
166   }
167 
168   /**
169    * @return true if `msg.sender` is the owner of the contract.
170    */
171   function isOwner() public view returns(bool) {
172     return msg.sender == _owner;
173   }
174 
175   /**
176    * @dev Allows the current owner to relinquish control of the contract.
177    * @notice Renouncing to ownership will leave the contract without an owner.
178    * It will not be possible to call the functions with the `onlyOwner`
179    * modifier anymore.
180    */
181   function renounceOwnership() public onlyOwner {
182     emit OwnershipRenounced(_owner);
183     _owner = address(0);
184   }
185 
186   /**
187    * @dev Allows the current owner to transfer control of the contract to a newOwner.
188    * @param newOwner The address to transfer ownership to.
189    */
190   function transferOwnership(address newOwner) public onlyOwner {
191     _transferOwnership(newOwner);
192   }
193 
194   /**
195    * @dev Transfers control of the contract to a newOwner.
196    * @param newOwner The address to transfer ownership to.
197    */
198   function _transferOwnership(address newOwner) internal {
199     require(newOwner != address(0));
200     emit OwnershipTransferred(_owner, newOwner);
201     _owner = newOwner;
202   }
203 
204   uint256[50] private ______gap;
205 }
206 
207 pragma solidity ^0.4.24;
208 
209 
210 /**
211  * @title ERC20 interface
212  * @dev see https://github.com/ethereum/EIPs/issues/20
213  */
214 interface IERC20 {
215   function totalSupply() external view returns (uint256);
216 
217   function balanceOf(address who) external view returns (uint256);
218 
219   function allowance(address owner, address spender)
220     external view returns (uint256);
221 
222   function transfer(address to, uint256 value) external returns (bool);
223 
224   function approve(address spender, uint256 value)
225     external returns (bool);
226 
227   function transferFrom(address from, address to, uint256 value)
228     external returns (bool);
229 
230   event Transfer(
231     address indexed from,
232     address indexed to,
233     uint256 value
234   );
235 
236   event Approval(
237     address indexed owner,
238     address indexed spender,
239     uint256 value
240   );
241 }
242 
243 pragma solidity ^0.4.24;
244 
245 
246 
247 
248 /**
249  * @title ERC20Detailed token
250  * @dev The decimals are only for visualization purposes.
251  * All the operations are done using the smallest and indivisible token unit,
252  * just as on Ethereum all the operations are done in wei.
253  */
254 contract ERC20Detailed is Initializable, IERC20 {
255   string private _name;
256   string private _symbol;
257   uint8 private _decimals;
258 
259   function initialize(string name, string symbol, uint8 decimals) public initializer {
260     _name = name;
261     _symbol = symbol;
262     _decimals = decimals;
263   }
264 
265   /**
266    * @return the name of the token.
267    */
268   function name() public view returns(string) {
269     return _name;
270   }
271 
272   /**
273    * @return the symbol of the token.
274    */
275   function symbol() public view returns(string) {
276     return _symbol;
277   }
278 
279   /**
280    * @return the number of decimals of the token.
281    */
282   function decimals() public view returns(uint8) {
283     return _decimals;
284   }
285 
286   uint256[50] private ______gap;
287 }
288 
289 
290 pragma solidity ^0.4.24;
291 
292 
293 /**
294  * @title Standard ERC20 token
295  *
296  * @dev Implementation of the basic standard token.
297  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
298  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
299  */
300 contract ERC20 is Initializable, IERC20 {
301   using SafeMath for uint256;
302 
303   mapping (address => uint256) private _balances;
304 
305   mapping (address => mapping (address => uint256)) private _allowed;
306 
307   uint256 private _totalSupply;
308 
309   /**
310   * @dev Total number of tokens in existence
311   */
312   function totalSupply() public view returns (uint256) {
313     return _totalSupply;
314   }
315 
316   /**
317   * @dev Gets the balance of the specified address.
318   * @param owner The address to query the the balance of.
319   * @return An uint256 representing the amount owned by the passed address.
320   */
321   function balanceOf(address owner) public view returns (uint256) {
322     return _balances[owner];
323   }
324 
325   /**
326    * @dev Function to check the amount of tokens that an owner allowed to a spender.
327    * @param owner address The address which owns the funds.
328    * @param spender address The address which will spend the funds.
329    * @return A uint256 specifying the amount of tokens still available for the spender.
330    */
331   function allowance(
332     address owner,
333     address spender
334    )
335     public
336     view
337     returns (uint256)
338   {
339     return _allowed[owner][spender];
340   }
341 
342   /**
343   * @dev Transfer token for a specified address
344   * @param to The address to transfer to.
345   * @param value The amount to be transferred.
346   */
347   function transfer(address to, uint256 value) public returns (bool) {
348     _transfer(msg.sender, to, value);
349     return true;
350   }
351 
352   /**
353    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
354    * Beware that changing an allowance with this method brings the risk that someone may use both the old
355    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
356    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
357    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
358    * @param spender The address which will spend the funds.
359    * @param value The amount of tokens to be spent.
360    */
361   function approve(address spender, uint256 value) public returns (bool) {
362     require(spender != address(0));
363 
364     _allowed[msg.sender][spender] = value;
365     emit Approval(msg.sender, spender, value);
366     return true;
367   }
368 
369   /**
370    * @dev Transfer tokens from one address to another
371    * @param from address The address which you want to send tokens from
372    * @param to address The address which you want to transfer to
373    * @param value uint256 the amount of tokens to be transferred
374    */
375   function transferFrom(
376     address from,
377     address to,
378     uint256 value
379   )
380     public
381     returns (bool)
382   {
383     require(value <= _allowed[from][msg.sender]);
384 
385     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
386     _transfer(from, to, value);
387     return true;
388   }
389 
390   /**
391    * @dev Increase the amount of tokens that an owner allowed to a spender.
392    * approve should be called when allowed_[_spender] == 0. To increment
393    * allowed value is better to use this function to avoid 2 calls (and wait until
394    * the first transaction is mined)
395    * From MonolithDAO Token.sol
396    * @param spender The address which will spend the funds.
397    * @param addedValue The amount of tokens to increase the allowance by.
398    */
399   function increaseAllowance(
400     address spender,
401     uint256 addedValue
402   )
403     public
404     returns (bool)
405   {
406     require(spender != address(0));
407 
408     _allowed[msg.sender][spender] = (
409       _allowed[msg.sender][spender].add(addedValue));
410     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
411     return true;
412   }
413 
414   /**
415    * @dev Decrease the amount of tokens that an owner allowed to a spender.
416    * approve should be called when allowed_[_spender] == 0. To decrement
417    * allowed value is better to use this function to avoid 2 calls (and wait until
418    * the first transaction is mined)
419    * From MonolithDAO Token.sol
420    * @param spender The address which will spend the funds.
421    * @param subtractedValue The amount of tokens to decrease the allowance by.
422    */
423   function decreaseAllowance(
424     address spender,
425     uint256 subtractedValue
426   )
427     public
428     returns (bool)
429   {
430     require(spender != address(0));
431 
432     _allowed[msg.sender][spender] = (
433       _allowed[msg.sender][spender].sub(subtractedValue));
434     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
435     return true;
436   }
437 
438   /**
439   * @dev Transfer token for a specified addresses
440   * @param from The address to transfer from.
441   * @param to The address to transfer to.
442   * @param value The amount to be transferred.
443   */
444   function _transfer(address from, address to, uint256 value) internal {
445     require(value <= _balances[from]);
446     require(to != address(0));
447 
448     _balances[from] = _balances[from].sub(value);
449     _balances[to] = _balances[to].add(value);
450     emit Transfer(from, to, value);
451   }
452 
453   /**
454    * @dev Internal function that mints an amount of the token and assigns it to
455    * an account. This encapsulates the modification of balances such that the
456    * proper events are emitted.
457    * @param account The account that will receive the created tokens.
458    * @param amount The amount that will be created.
459    */
460   function _mint(address account, uint256 amount) internal {
461     require(account != 0);
462     _totalSupply = _totalSupply.add(amount);
463     _balances[account] = _balances[account].add(amount);
464     emit Transfer(address(0), account, amount);
465   }
466 
467   /**
468    * @dev Internal function that burns an amount of the token of a given
469    * account.
470    * @param account The account whose tokens will be burnt.
471    * @param amount The amount that will be burnt.
472    */
473   function _burn(address account, uint256 amount) internal {
474     require(account != 0);
475     require(amount <= _balances[account]);
476 
477     _totalSupply = _totalSupply.sub(amount);
478     _balances[account] = _balances[account].sub(amount);
479     emit Transfer(account, address(0), amount);
480   }
481 
482   /**
483    * @dev Internal function that burns an amount of the token of a given
484    * account, deducting from the sender's allowance for said account. Uses the
485    * internal burn function.
486    * @param account The account whose tokens will be burnt.
487    * @param amount The amount that will be burnt.
488    */
489   function _burnFrom(address account, uint256 amount) internal {
490     require(amount <= _allowed[account][msg.sender]);
491 
492     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
493     // this function needs to emit an event with the updated approval.
494     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
495       amount);
496     _burn(account, amount);
497   }
498 
499   uint256[50] private ______gap;
500 }
501 
502 pragma solidity ^0.4.24;
503 
504 
505 /**
506  * @title SafeERC20
507  * @dev Wrappers around ERC20 operations that throw on failure.
508  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
509  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
510  */
511 library SafeERC20 {
512   function safeTransfer(
513     IERC20 token,
514     address to,
515     uint256 value
516   )
517     internal
518   {
519     require(token.transfer(to, value));
520   }
521 
522   function safeTransferFrom(
523     IERC20 token,
524     address from,
525     address to,
526     uint256 value
527   )
528     internal
529   {
530     require(token.transferFrom(from, to, value));
531   }
532 
533   function safeApprove(
534     IERC20 token,
535     address spender,
536     uint256 value
537   )
538     internal
539   {
540     require(token.approve(spender, value));
541   }
542 }
543 
544 pragma solidity ^0.4.24;
545 
546 
547 /**
548  * @title TokenTimelock
549  * @dev TokenTimelock is a token holder contract that will allow a
550  * beneficiary to extract the tokens after a given release time
551  */
552 contract TokenTimelock is Initializable {
553   using SafeERC20 for IERC20;
554 
555   // ERC20 basic token contract being held
556   IERC20 private _token;
557 
558   // beneficiary of tokens after they are released
559   address private _beneficiary;
560 
561   // timestamp when token release is enabled
562   uint256 private _releaseTime;
563 
564   function initialize(
565     IERC20 token,
566     address beneficiary,
567     uint256 releaseTime
568   )
569     public
570     initializer
571   {
572     // solium-disable-next-line security/no-block-members
573     require(releaseTime > block.timestamp);
574     _token = token;
575     _beneficiary = beneficiary;
576     _releaseTime = releaseTime;
577   }
578 
579   /**
580    * @return the token being held.
581    */
582   function token() public view returns(IERC20) {
583     return _token;
584   }
585 
586   /**
587    * @return the beneficiary of the tokens.
588    */
589   function beneficiary() public view returns(address) {
590     return _beneficiary;
591   }
592 
593   /**
594    * @return the time when the tokens are released.
595    */
596   function releaseTime() public view returns(uint256) {
597     return _releaseTime;
598   }
599 
600   /**
601    * @notice Transfers tokens held by timelock to beneficiary.
602    */
603   function release() public {
604     // solium-disable-next-line security/no-block-members
605     require(block.timestamp >= _releaseTime);
606 
607     uint256 amount = _token.balanceOf(address(this));
608     require(amount > 0);
609 
610     _token.safeTransfer(_beneficiary, amount);
611   }
612 
613   uint256[50] private ______gap;
614 }
615 
616 /*
617 MIT License
618 
619 Copyright (c) 2018 requestnetwork
620 Copyright (c) 2018 Fragments, Inc.
621 
622 Permission is hereby granted, free of charge, to any person obtaining a copy
623 of this software and associated documentation files (the "Software"), to deal
624 in the Software without restriction, including without limitation the rights
625 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
626 copies of the Software, and to permit persons to whom the Software is
627 furnished to do so, subject to the following conditions:
628 
629 The above copyright notice and this permission notice shall be included in all
630 copies or substantial portions of the Software.
631 
632 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
633 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
634 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
635 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
636 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
637 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
638 SOFTWARE.
639 */
640 
641 pragma solidity ^0.4.24;
642 
643 
644 /**
645  * @title SafeMathInt
646  * @dev Math operations for int256 with overflow safety checks.
647  */
648 library SafeMathInt {
649     int256 private constant MIN_INT256 = int256(1) << 255;
650     int256 private constant MAX_INT256 = ~(int256(1) << 255);
651 
652     /**
653      * @dev Multiplies two int256 variables and fails on overflow.
654      */
655     function mul(int256 a, int256 b)
656         internal
657         pure
658         returns (int256)
659     {
660         int256 c = a * b;
661 
662         // Detect overflow when multiplying MIN_INT256 with -1
663         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
664         require((b == 0) || (c / b == a));
665         return c;
666     }
667 
668     /**
669      * @dev Division of two int256 variables and fails on overflow.
670      */
671     function div(int256 a, int256 b)
672         internal
673         pure
674         returns (int256)
675     {
676         // Prevent overflow when dividing MIN_INT256 by -1
677         require(b != -1 || a != MIN_INT256);
678 
679         // Solidity already throws when dividing by 0.
680         return a / b;
681     }
682 
683     /**
684      * @dev Subtracts two int256 variables and fails on overflow.
685      */
686     function sub(int256 a, int256 b)
687         internal
688         pure
689         returns (int256)
690     {
691         int256 c = a - b;
692         require((b >= 0 && c <= a) || (b < 0 && c > a));
693         return c;
694     }
695 
696     /**
697      * @dev Adds two int256 variables and fails on overflow.
698      */
699     function add(int256 a, int256 b)
700         internal
701         pure
702         returns (int256)
703     {
704         int256 c = a + b;
705         require((b >= 0 && c >= a) || (b < 0 && c < a));
706         return c;
707     }
708 
709     /**
710      * @dev Converts to absolute value, and fails on overflow.
711      */
712     function abs(int256 a)
713         internal
714         pure
715         returns (int256)
716     {
717         require(a != MIN_INT256);
718         return a < 0 ? -a : a;
719     }
720 }
721 
722 pragma solidity ^0.4.24;
723 
724 
725 /**
726  * @title uFragments ERC20 token
727  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
728  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
729  *      combining tokens proportionally across all wallets.
730  *
731  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
732  *      We support splitting the currency in expansion and combining the currency on contraction by
733  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
734  */
735 contract XBaseToken is ERC20Detailed, Ownable {
736     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
737     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
738     // order to minimize this risk, we adhere to the following guidelines:
739     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
740     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
741     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
742     //    multiplying by the inverse rate, you should divide by the normal rate)
743     // 2) Gon balances converted into Fragments are always rounded down (truncated).
744     //
745     // We make the following guarantees:
746     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
747     //   be decreased by precisely x Fragments, and B's external balance will be precisely
748     //   increased by x Fragments.
749     //
750     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
751     // This is because, for any conversion function 'f()' that has non-zero rounding error,
752     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
753     using SafeMath for uint256;
754     using SafeMathInt for int256;
755     using SafeERC20 for IERC20;
756 
757     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
758     event LogMonetaryPolicyUpdated(address monetaryPolicy);
759 
760     // Used for authentication
761     address public monetaryPolicy;
762 
763     // Time farming reward valt, release 1 days
764     TokenTimelock public farmVault;
765 
766     modifier onlyMonetaryPolicy() {
767         require(msg.sender == monetaryPolicy);
768         _;
769     }
770 
771     bool private rebasePausedDeprecated;
772     bool private tokenPausedDeprecated;
773 
774     modifier validRecipient(address to) {
775         require(to != address(0x0));
776         require(to != address(this));
777         _;
778     }
779 
780     uint256 private constant DECIMALS = 8;
781     uint256 private constant MAX_UINT256 = ~uint256(0);
782     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 6500000 * 10**DECIMALS;
783     uint256 private constant INITIAL_FARM_SUPPLY = 6000000 * 10**DECIMALS;
784 
785     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
786     // Use the highest value that fits in a uint256 for max granularity.
787     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
788 
789     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
790     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
791 
792     uint256 private _totalSupply;
793     uint256 private _gonsPerFragment;
794     mapping(address => uint256) private _gonBalances;
795 
796     // This is denominated in Fragments, because the gons-fragments conversion might change before
797     // it's fully paid.
798     mapping (address => mapping (address => uint256)) private _allowedFragments;
799 
800     /**
801      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
802      */
803     function setMonetaryPolicy(address monetaryPolicy_)
804         external
805         onlyOwner
806     {
807         monetaryPolicy = monetaryPolicy_;
808         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
809     }
810 
811     /**
812      * @dev Notifies Fragments contract about a new rebase cycle.
813      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
814      * @return The total number of fragments after the supply adjustment.
815      */
816     function rebase(uint256 epoch, int256 supplyDelta)
817         external
818         onlyMonetaryPolicy
819         returns (uint256)
820     {
821         if (supplyDelta == 0) {
822             emit LogRebase(epoch, _totalSupply);
823             return _totalSupply;
824         }
825 
826         if (supplyDelta < 0) {
827             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
828         } else {
829             _totalSupply = _totalSupply.add(uint256(supplyDelta));
830         }
831 
832         if (_totalSupply > MAX_SUPPLY) {
833             _totalSupply = MAX_SUPPLY;
834         }
835 
836         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
837 
838         // From this point forward, _gonsPerFragment is taken as the source of truth.
839         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
840         // conversion rate.
841         // This means our applied supplyDelta can deviate from the requested supplyDelta,
842         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
843         //
844         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
845         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
846         // ever increased, it must be re-included.
847         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
848 
849         emit LogRebase(epoch, _totalSupply);
850         return _totalSupply;
851     }
852 
853     function initialize(address owner_, address farmAddress_)
854         public
855         initializer
856     {
857         ERC20Detailed.initialize("XBASE.Finance", "XBASE", uint8(DECIMALS));
858         Ownable.initialize(owner_);
859 
860         rebasePausedDeprecated = false;
861         tokenPausedDeprecated = false;
862 
863         farmVault = new TokenTimelock();
864         farmVault.initialize(IERC20(address(this)), farmAddress_, block.timestamp + 2 hours);
865 
866         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
867         _gonBalances[owner_] = TOTAL_GONS;
868         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
869 
870         emit Transfer(address(0x0), owner_, _totalSupply);
871 
872         // reserve the faming vault to contract. make sure owner call this func.
873         transfer(farmVault, INITIAL_FARM_SUPPLY);
874     }
875 
876     /**
877      * @return The total number of fragments.
878      */
879     function totalSupply()
880         public
881         view
882         returns (uint256)
883     {
884         return _totalSupply;
885     }
886 
887     /**
888      * @param who The address to query.
889      * @return The balance of the specified address.
890      */
891     function balanceOf(address who)
892         public
893         view
894         returns (uint256)
895     {
896         return _gonBalances[who].div(_gonsPerFragment);
897     }
898 
899     /**
900      * @dev Transfer tokens to a specified address.
901      * @param to The address to transfer to.
902      * @param value The amount to be transferred.
903      * @return True on success, false otherwise.
904      */
905     function transfer(address to, uint256 value)
906         public
907         validRecipient(to)
908         returns (bool)
909     {
910         uint256 gonValue = value.mul(_gonsPerFragment);
911         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
912         _gonBalances[to] = _gonBalances[to].add(gonValue);
913         emit Transfer(msg.sender, to, value);
914         return true;
915     }
916 
917     /**
918      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
919      * @param owner_ The address which owns the funds.
920      * @param spender The address which will spend the funds.
921      * @return The number of tokens still available for the spender.
922      */
923     function allowance(address owner_, address spender)
924         public
925         view
926         returns (uint256)
927     {
928         return _allowedFragments[owner_][spender];
929     }
930 
931     /**
932      * @dev Transfer tokens from one address to another.
933      * @param from The address you want to send tokens from.
934      * @param to The address you want to transfer to.
935      * @param value The amount of tokens to be transferred.
936      */
937     function transferFrom(address from, address to, uint256 value)
938         public
939         validRecipient(to)
940         returns (bool)
941     {
942         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
943 
944         uint256 gonValue = value.mul(_gonsPerFragment);
945         _gonBalances[from] = _gonBalances[from].sub(gonValue);
946         _gonBalances[to] = _gonBalances[to].add(gonValue);
947         emit Transfer(from, to, value);
948 
949         return true;
950     }
951 
952     /**
953      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
954      * msg.sender. This method is included for ERC20 compatibility.
955      * increaseAllowance and decreaseAllowance should be used instead.
956      * Changing an allowance with this method brings the risk that someone may transfer both
957      * the old and the new allowance - if they are both greater than zero - if a transfer
958      * transaction is mined before the later approve() call is mined.
959      *
960      * @param spender The address which will spend the funds.
961      * @param value The amount of tokens to be spent.
962      */
963     function approve(address spender, uint256 value)
964         public
965         returns (bool)
966     {
967         _allowedFragments[msg.sender][spender] = value;
968         emit Approval(msg.sender, spender, value);
969         return true;
970     }
971 
972     /**
973      * @dev Increase the amount of tokens that an owner has allowed to a spender.
974      * This method should be used instead of approve() to avoid the double approval vulnerability
975      * described above.
976      * @param spender The address which will spend the funds.
977      * @param addedValue The amount of tokens to increase the allowance by.
978      */
979     function increaseAllowance(address spender, uint256 addedValue)
980         public
981         returns (bool)
982     {
983         _allowedFragments[msg.sender][spender] =
984             _allowedFragments[msg.sender][spender].add(addedValue);
985         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
986         return true;
987     }
988 
989     /**
990      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
991      *
992      * @param spender The address which will spend the funds.
993      * @param subtractedValue The amount of tokens to decrease the allowance by.
994      */
995     function decreaseAllowance(address spender, uint256 subtractedValue)
996         public
997         returns (bool)
998     {
999         uint256 oldValue = _allowedFragments[msg.sender][spender];
1000         if (subtractedValue >= oldValue) {
1001             _allowedFragments[msg.sender][spender] = 0;
1002         } else {
1003             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
1004         }
1005         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
1006         return true;
1007     }
1008 }