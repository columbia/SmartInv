1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.fi
6  *  
7  *              ____    _______    _____        __   _ 
8  *             |  _ \  |__   __|  / ____|      / _| (_)
9  *        ___  | |_) |    | |    | |          | |_   _ 
10  *       / __| |  _ <     | |    | |          |  _| | |
11  *       \__ \ | |_) |    | |    | |____   _  | |   | |
12  *       |___/ |____/     |_|     \_____| (_) |_|   |_|                                              
13  *  
14  *        Unfolding the Power of Soft Bitcoin Economy.
15  *                                         
16  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.fi                                     
17  *
18 **/
19 
20 // File: openzeppelin-eth/contracts/math/SafeMath.sol
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that revert on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, reverts on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33     // benefit is lost if 'b' is also tested.
34     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35     if (a == 0) {
36       return 0;
37     }
38 
39     uint256 c = a * b;
40     require(c / a == b);
41 
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b > 0); // Solidity only automatically asserts when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53     return c;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b <= a);
61     uint256 c = a - b;
62 
63     return c;
64   }
65 
66   /**
67   * @dev Adds two numbers, reverts on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     require(c >= a);
72 
73     return c;
74   }
75 
76   /**
77   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
78   * reverts when dividing by zero.
79   */
80   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81     require(b != 0);
82     return a % b;
83   }
84 }
85 
86 // File: zos-lib/contracts/Initializable.sol
87 
88 pragma solidity >=0.4.24 <0.6.0;
89 
90 
91 /**
92  * @title Initializable
93  *
94  * @dev Helper contract to support initializer functions. To use it, replace
95  * the constructor with a function that has the `initializer` modifier.
96  * WARNING: Unlike constructors, initializer functions must be manually
97  * invoked. This applies both to deploying an Initializable contract, as well
98  * as extending an Initializable contract via inheritance.
99  * WARNING: When used with inheritance, manual care must be taken to not invoke
100  * a parent initializer twice, or ensure that all initializers are idempotent,
101  * because this is not dealt with automatically as with constructors.
102  */
103 contract Initializable {
104 
105   /**
106    * @dev Indicates that the contract has been initialized.
107    */
108   bool private initialized;
109 
110   /**
111    * @dev Indicates that the contract is in the process of being initialized.
112    */
113   bool private initializing;
114 
115   /**
116    * @dev Modifier to use in the initializer function of a contract.
117    */
118   modifier initializer() {
119     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
120 
121     bool wasInitializing = initializing;
122     initializing = true;
123     initialized = true;
124 
125     _;
126 
127     initializing = wasInitializing;
128   }
129 
130   /// @dev Returns true if and only if the function is running in the constructor
131   function isConstructor() private view returns (bool) {
132     // extcodesize checks the size of the code stored in an address, and
133     // address returns the current address. Since the code is still not
134     // deployed when running a constructor, any checks on its code size will
135     // yield zero, making it an effective way to detect if a contract is
136     // under construction or not.
137     uint256 cs;
138     assembly { cs := extcodesize(address) }
139     return cs == 0;
140   }
141 
142   // Reserved storage space to allow for layout changes in the future.
143   uint256[50] private ______gap;
144 }
145 
146 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
147 
148 pragma solidity ^0.4.24;
149 
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable is Initializable {
157   address private _owner;
158 
159 
160   event OwnershipRenounced(address indexed previousOwner);
161   event OwnershipTransferred(
162     address indexed previousOwner,
163     address indexed newOwner
164   );
165 
166 
167   /**
168    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
169    * account.
170    */
171   function initialize(address sender) public initializer {
172     _owner = sender;
173   }
174 
175   /**
176    * @return the address of the owner.
177    */
178   function owner() public view returns(address) {
179     return _owner;
180   }
181 
182   /**
183    * @dev Throws if called by any account other than the owner.
184    */
185   modifier onlyOwner() {
186     require(isOwner());
187     _;
188   }
189 
190   /**
191    * @return true if `msg.sender` is the owner of the contract.
192    */
193   function isOwner() public view returns(bool) {
194     return msg.sender == _owner;
195   }
196 
197   /**
198    * @dev Allows the current owner to relinquish control of the contract.
199    * @notice Renouncing to ownership will leave the contract without an owner.
200    * It will not be possible to call the functions with the `onlyOwner`
201    * modifier anymore.
202    */
203   function renounceOwnership() public onlyOwner {
204     emit OwnershipRenounced(_owner);
205     _owner = address(0);
206   }
207 
208   /**
209    * @dev Allows the current owner to transfer control of the contract to a newOwner.
210    * @param newOwner The address to transfer ownership to.
211    */
212   function transferOwnership(address newOwner) public onlyOwner {
213     _transferOwnership(newOwner);
214   }
215 
216   /**
217    * @dev Transfers control of the contract to a newOwner.
218    * @param newOwner The address to transfer ownership to.
219    */
220   function _transferOwnership(address newOwner) internal {
221     require(newOwner != address(0));
222     emit OwnershipTransferred(_owner, newOwner);
223     _owner = newOwner;
224   }
225 
226   uint256[50] private ______gap;
227 }
228 
229 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
230 
231 pragma solidity ^0.4.24;
232 
233 
234 /**
235  * @title ERC20 interface
236  * @dev see https://github.com/ethereum/EIPs/issues/20
237  */
238 interface IERC20 {
239   function totalSupply() external view returns (uint256);
240 
241   function balanceOf(address who) external view returns (uint256);
242 
243   function allowance(address owner, address spender)
244     external view returns (uint256);
245 
246   function transfer(address to, uint256 value) external returns (bool);
247 
248   function approve(address spender, uint256 value)
249     external returns (bool);
250 
251   function transferFrom(address from, address to, uint256 value)
252     external returns (bool);
253 
254   event Transfer(
255     address indexed from,
256     address indexed to,
257     uint256 value
258   );
259 
260   event Approval(
261     address indexed owner,
262     address indexed spender,
263     uint256 value
264   );
265 }
266 
267 // File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol
268 
269 pragma solidity ^0.4.24;
270 
271 
272 
273 
274 /**
275  * @title ERC20Detailed token
276  * @dev The decimals are only for visualization purposes.
277  * All the operations are done using the smallest and indivisible token unit,
278  * just as on Ethereum all the operations are done in wei.
279  */
280 contract ERC20Detailed is Initializable, IERC20 {
281   string private _name;
282   string private _symbol;
283   uint8 private _decimals;
284 
285   function initialize(string name, string symbol, uint8 decimals) public initializer {
286     _name = name;
287     _symbol = symbol;
288     _decimals = decimals;
289   }
290 
291   /**
292    * @return the name of the token.
293    */
294   function name() public view returns(string) {
295     return _name;
296   }
297 
298   /**
299    * @return the symbol of the token.
300    */
301   function symbol() public view returns(string) {
302     return _symbol;
303   }
304 
305   /**
306    * @return the number of decimals of the token.
307    */
308   function decimals() public view returns(uint8) {
309     return _decimals;
310   }
311 
312   uint256[50] private ______gap;
313 }
314 
315 // File: contracts/lib/SafeMathInt.sol
316 
317 /*
318 MIT License
319 
320 Copyright (c) 2018 requestnetwork
321 Copyright (c) 2018 Fragments, Inc.
322 
323 Permission is hereby granted, free of charge, to any person obtaining a copy
324 of this software and associated documentation files (the "Software"), to deal
325 in the Software without restriction, including without limitation the rights
326 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
327 copies of the Software, and to permit persons to whom the Software is
328 furnished to do so, subject to the following conditions:
329 
330 The above copyright notice and this permission notice shall be included in all
331 copies or substantial portions of the Software.
332 
333 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
334 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
335 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
336 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
337 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
338 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
339 SOFTWARE.
340 */
341 
342 pragma solidity 0.4.24;
343 
344 
345 /**
346  * @title SafeMathInt
347  * @dev Math operations for int256 with overflow safety checks.
348  */
349 library SafeMathInt {
350     int256 private constant MIN_INT256 = int256(1) << 255;
351     int256 private constant MAX_INT256 = ~(int256(1) << 255);
352 
353     /**
354      * @dev Multiplies two int256 variables and fails on overflow.
355      */
356     function mul(int256 a, int256 b)
357         internal
358         pure
359         returns (int256)
360     {
361         int256 c = a * b;
362 
363         // Detect overflow when multiplying MIN_INT256 with -1
364         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
365         require((b == 0) || (c / b == a));
366         return c;
367     }
368 
369     /**
370      * @dev Division of two int256 variables and fails on overflow.
371      */
372     function div(int256 a, int256 b)
373         internal
374         pure
375         returns (int256)
376     {
377         // Prevent overflow when dividing MIN_INT256 by -1
378         require(b != -1 || a != MIN_INT256);
379 
380         // Solidity already throws when dividing by 0.
381         return a / b;
382     }
383 
384     /**
385      * @dev Subtracts two int256 variables and fails on overflow.
386      */
387     function sub(int256 a, int256 b)
388         internal
389         pure
390         returns (int256)
391     {
392         int256 c = a - b;
393         require((b >= 0 && c <= a) || (b < 0 && c > a));
394         return c;
395     }
396 
397     /**
398      * @dev Adds two int256 variables and fails on overflow.
399      */
400     function add(int256 a, int256 b)
401         internal
402         pure
403         returns (int256)
404     {
405         int256 c = a + b;
406         require((b >= 0 && c >= a) || (b < 0 && c < a));
407         return c;
408     }
409 
410     /**
411      * @dev Converts to absolute value, and fails on overflow.
412      */
413     function abs(int256 a)
414         internal
415         pure
416         returns (int256)
417     {
418         require(a != MIN_INT256);
419         return a < 0 ? -a : a;
420     }
421 }
422 
423 // File: contracts/UFragments.sol
424 
425 pragma solidity 0.4.24;
426 
427 /**
428  *
429  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.ft
430  *  
431  *           ____  _______  _____      __  _ 
432  *          |  _ \|__   __|/ ____|    / _|(_)
433  *      ___ | |_) |  | |  | |        | |_  _ 
434  *     / __||  _ <   | |  | |        |  _|| |
435  *     \__ \| |_) |  | |  | |____  _ | |  | |
436  *     |___/|____/   |_|   \_____|(_)|_|  |_|
437  *  
438  *   Unfolding the Power of Soft Bitcoin Economy.
439  *                                         
440  *   https://sbtc.fi      https://sbtc.fi     https://sbtc.ft                                     
441  *
442 **/
443 
444 
445 
446 
447 
448 /**
449  * @title uFragments ERC20 token
450  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
451  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
452  *      combining tokens proportionally across all wallets.
453  *
454  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
455  *      We support splitting the currency in expansion and combining the currency on contraction by
456  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
457  */
458 contract UFragments is ERC20Detailed, Ownable {
459     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
460     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
461     // order to minimize this risk, we adhere to the following guidelines:
462     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
463     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
464     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
465     //    multiplying by the inverse rate, you should divide by the normal rate)
466     // 2) Gon balances converted into Fragments are always rounded down (truncated).
467     //
468     // We make the following guarantees:
469     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
470     //   be decreased by precisely x Fragments, and B's external balance will be precisely
471     //   increased by x Fragments.
472     //
473     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
474     // This is because, for any conversion function 'f()' that has non-zero rounding error,
475     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
476     using SafeMath for uint256;
477     using SafeMathInt for int256;
478 
479     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
480     event LogRebasePaused(bool paused);
481     event LogTokenPaused(bool paused);
482     event LogMonetaryPolicyUpdated(address monetaryPolicy);
483 
484     // Used for authentication
485     address public monetaryPolicy;
486 
487     modifier onlyMonetaryPolicy() {
488         require(msg.sender == monetaryPolicy);
489         _;
490     }
491 
492     // Precautionary emergency controls.
493     bool public rebasePaused;
494     bool public tokenPaused;
495 
496     modifier whenRebaseNotPaused() {
497         require(!rebasePaused);
498         _;
499     }
500 
501     modifier whenTokenNotPaused() {
502         require(!tokenPaused);
503         _;
504     }
505 
506     modifier validRecipient(address to) {
507         require(to != address(0x0));
508         require(to != address(this));
509         _;
510     }
511 
512     uint256 private constant DECIMALS = 9;
513     uint256 private constant MAX_UINT256 = ~uint256(0);
514     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 21 * 10**6 * 10**DECIMALS;
515 
516     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
517     // Use the highest value that fits in a uint256 for max granularity.
518     uint256 private constant TOTAL_GONS = MAX_UINT256 -
519         (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
520 
521     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
522     uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
523 
524     uint256 private _totalSupply;
525     uint256 private _gonsPerFragment;
526     mapping(address => uint256) private _gonBalances;
527 
528     // This is denominated in Fragments, because the gons-fragments conversion might change before
529     // it's fully paid.
530     mapping(address => mapping(address => uint256)) private _allowedFragments;
531 
532     /**
533      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
534      */
535     function setMonetaryPolicy(address monetaryPolicy_) external onlyOwner {
536         monetaryPolicy = monetaryPolicy_;
537         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
538     }
539 
540     /**
541      * @dev Pauses or unpauses the execution of rebase operations.
542      * @param paused Pauses rebase operations if this is true.
543      */
544     function setRebasePaused(bool paused) external onlyOwner {
545         rebasePaused = paused;
546         emit LogRebasePaused(paused);
547     }
548 
549     /**
550      * @dev Pauses or unpauses execution of ERC-20 transactions.
551      * @param paused Pauses ERC-20 transactions if this is true.
552      */
553     function setTokenPaused(bool paused) external onlyOwner {
554         tokenPaused = paused;
555         emit LogTokenPaused(paused);
556     }
557 
558     /**
559      * @dev Notifies Fragments contract about a new rebase cycle.
560      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
561      * @return The total number of fragments after the supply adjustment.
562      */
563     function rebase(uint256 epoch, int256 supplyDelta)
564         external
565         onlyMonetaryPolicy
566         whenRebaseNotPaused
567         returns (uint256)
568     {
569         if (supplyDelta == 0) {
570             emit LogRebase(epoch, _totalSupply);
571             return _totalSupply;
572         }
573 
574         if (supplyDelta < 0) {
575             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
576         } else {
577             _totalSupply = _totalSupply.add(uint256(supplyDelta));
578         }
579 
580         if (_totalSupply > MAX_SUPPLY) {
581             _totalSupply = MAX_SUPPLY;
582         }
583 
584         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
585 
586         // From this point forward, _gonsPerFragment is taken as the source of truth.
587         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
588         // conversion rate.
589         // This means our applied supplyDelta can deviate from the requested supplyDelta,
590         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
591         //
592         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
593         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
594         // ever increased, it must be re-included.
595         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
596 
597         emit LogRebase(epoch, _totalSupply);
598         return _totalSupply;
599     }
600 
601     function initialize(address owner_) public initializer {
602         ERC20Detailed.initialize("Soft Bitcoin", "SBTC", uint8(DECIMALS));
603         Ownable.initialize(owner_);
604 
605         rebasePaused = false;
606         tokenPaused = false;
607 
608         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
609         _gonBalances[owner_] = TOTAL_GONS;
610         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
611 
612         emit Transfer(address(0x0), owner_, _totalSupply);
613     }
614 
615     /**
616      * @return The total number of fragments.
617      */
618     function totalSupply() public view returns (uint256) {
619         return _totalSupply;
620     }
621 
622     /**
623      * @param who The address to query.
624      * @return The balance of the specified address.
625      */
626     function balanceOf(address who) public view returns (uint256) {
627         return _gonBalances[who].div(_gonsPerFragment);
628     }
629 
630     /**
631      * @dev Transfer tokens to a specified address.
632      * @param to The address to transfer to.
633      * @param value The amount to be transferred.
634      * @return True on success, false otherwise.
635      */
636     function transfer(address to, uint256 value)
637         public
638         validRecipient(to)
639         whenTokenNotPaused
640         returns (bool)
641     {
642         uint256 gonValue = value.mul(_gonsPerFragment);
643         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
644         _gonBalances[to] = _gonBalances[to].add(gonValue);
645         emit Transfer(msg.sender, to, value);
646         return true;
647     }
648 
649     /**
650      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
651      * @param owner_ The address which owns the funds.
652      * @param spender The address which will spend the funds.
653      * @return The number of tokens still available for the spender.
654      */
655     function allowance(address owner_, address spender)
656         public
657         view
658         returns (uint256)
659     {
660         return _allowedFragments[owner_][spender];
661     }
662 
663     /**
664      * @dev Transfer tokens from one address to another.
665      * @param from The address you want to send tokens from.
666      * @param to The address you want to transfer to.
667      * @param value The amount of tokens to be transferred.
668      */
669     function transferFrom(
670         address from,
671         address to,
672         uint256 value
673     ) public validRecipient(to) whenTokenNotPaused returns (bool) {
674         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg
675             .sender]
676             .sub(value);
677 
678         uint256 gonValue = value.mul(_gonsPerFragment);
679         _gonBalances[from] = _gonBalances[from].sub(gonValue);
680         _gonBalances[to] = _gonBalances[to].add(gonValue);
681         emit Transfer(from, to, value);
682 
683         return true;
684     }
685 
686     /**
687      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
688      * msg.sender. This method is included for ERC20 compatibility.
689      * increaseAllowance and decreaseAllowance should be used instead.
690      * Changing an allowance with this method brings the risk that someone may transfer both
691      * the old and the new allowance - if they are both greater than zero - if a transfer
692      * transaction is mined before the later approve() call is mined.
693      *
694      * @param spender The address which will spend the funds.
695      * @param value The amount of tokens to be spent.
696      */
697     function approve(address spender, uint256 value)
698         public
699         whenTokenNotPaused
700         returns (bool)
701     {
702         _allowedFragments[msg.sender][spender] = value;
703         emit Approval(msg.sender, spender, value);
704         return true;
705     }
706 
707     /**
708      * @dev Increase the amount of tokens that an owner has allowed to a spender.
709      * This method should be used instead of approve() to avoid the double approval vulnerability
710      * described above.
711      * @param spender The address which will spend the funds.
712      * @param addedValue The amount of tokens to increase the allowance by.
713      */
714     function increaseAllowance(address spender, uint256 addedValue)
715         public
716         whenTokenNotPaused
717         returns (bool)
718     {
719         _allowedFragments[msg.sender][spender] = _allowedFragments[msg
720             .sender][spender]
721             .add(addedValue);
722         emit Approval(
723             msg.sender,
724             spender,
725             _allowedFragments[msg.sender][spender]
726         );
727         return true;
728     }
729 
730     /**
731      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
732      *
733      * @param spender The address which will spend the funds.
734      * @param subtractedValue The amount of tokens to decrease the allowance by.
735      */
736     function decreaseAllowance(address spender, uint256 subtractedValue)
737         public
738         whenTokenNotPaused
739         returns (bool)
740     {
741         uint256 oldValue = _allowedFragments[msg.sender][spender];
742         if (subtractedValue >= oldValue) {
743             _allowedFragments[msg.sender][spender] = 0;
744         } else {
745             _allowedFragments[msg.sender][spender] = oldValue.sub(
746                 subtractedValue
747             );
748         }
749         emit Approval(
750             msg.sender,
751             spender,
752             _allowedFragments[msg.sender][spender]
753         );
754         return true;
755     }
756 }