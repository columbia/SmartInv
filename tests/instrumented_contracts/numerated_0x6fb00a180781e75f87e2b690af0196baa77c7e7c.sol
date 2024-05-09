1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-27
3 */
4 
5 // File: zos-lib/contracts/Initializable.sol
6 
7 pragma solidity >=0.4.24 <0.6.0;
8 
9 
10 /**
11  * @title Initializable
12  *
13  * @dev Helper contract to support initializer functions. To use it, replace
14  * the constructor with a function that has the `initializer` modifier.
15  * WARNING: Unlike constructors, initializer functions must be manually
16  * invoked. This applies both to deploying an Initializable contract, as well
17  * as extending an Initializable contract via inheritance.
18  * WARNING: When used with inheritance, manual care must be taken to not invoke
19  * a parent initializer twice, or ensure that all initializers are idempotent,
20  * because this is not dealt with automatically as with constructors.
21  */
22 contract Initializable {
23 
24   /**
25    * @dev Indicates that the contract has been initialized.
26    */
27   bool private initialized;
28 
29   /**
30    * @dev Indicates that the contract is in the process of being initialized.
31    */
32   bool private initializing;
33 
34   /**
35    * @dev Modifier to use in the initializer function of a contract.
36    */
37   modifier initializer() {
38     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
39 
40     bool isTopLevelCall = !initializing;
41     if (isTopLevelCall) {
42       initializing = true;
43       initialized = true;
44     }
45 
46     _;
47 
48     if (isTopLevelCall) {
49       initializing = false;
50     }
51   }
52 
53   /// @dev Returns true if and only if the function is running in the constructor
54   function isConstructor() private view returns (bool) {
55     // extcodesize checks the size of the code stored in an address, and
56     // address returns the current address. Since the code is still not
57     // deployed when running a constructor, any checks on its code size will
58     // yield zero, making it an effective way to detect if a contract is
59     // under construction or not.
60     uint256 cs;
61     assembly { cs := extcodesize(address) }
62     return cs == 0;
63   }
64 
65   // Reserved storage space to allow for layout changes in the future.
66   uint256[50] private ______gap;
67 }
68 
69 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
70 
71 pragma solidity ^0.4.24;
72 
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable is Initializable {
80   address private _owner;
81 
82 
83   event OwnershipRenounced(address indexed previousOwner);
84   event OwnershipTransferred(
85     address indexed previousOwner,
86     address indexed newOwner
87   );
88 
89 
90   /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94   function initialize(address sender) public initializer {
95     _owner = sender;
96   }
97 
98   /**
99    * @return the address of the owner.
100    */
101   function owner() public view returns(address) {
102     return _owner;
103   }
104 
105   /**
106    * @dev Throws if called by any account other than the owner.
107    */
108   modifier onlyOwner() {
109     require(isOwner());
110     _;
111   }
112 
113   /**
114    * @return true if `msg.sender` is the owner of the contract.
115    */
116   function isOwner() public view returns(bool) {
117     return msg.sender == _owner;
118   }
119 
120   /**
121    * @dev Allows the current owner to relinquish control of the contract.
122    * @notice Renouncing to ownership will leave the contract without an owner.
123    * It will not be possible to call the functions with the `onlyOwner`
124    * modifier anymore.
125    */
126   function renounceOwnership() public onlyOwner {
127     emit OwnershipRenounced(_owner);
128     _owner = address(0);
129   }
130 
131   /**
132    * @dev Allows the current owner to transfer control of the contract to a newOwner.
133    * @param newOwner The address to transfer ownership to.
134    */
135   function transferOwnership(address newOwner) public onlyOwner {
136     _transferOwnership(newOwner);
137   }
138 
139   /**
140    * @dev Transfers control of the contract to a newOwner.
141    * @param newOwner The address to transfer ownership to.
142    */
143   function _transferOwnership(address newOwner) internal {
144     require(newOwner != address(0));
145     emit OwnershipTransferred(_owner, newOwner);
146     _owner = newOwner;
147   }
148 
149   uint256[50] private ______gap;
150 }
151 
152 // File: openzeppelin-eth/contracts/math/SafeMath.sol
153 
154 pragma solidity ^0.4.24;
155 
156 
157 /**
158  * @title SafeMath
159  * @dev Math operations with safety checks that revert on error
160  */
161 library SafeMath {
162 
163   /**
164   * @dev Multiplies two numbers, reverts on overflow.
165   */
166   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168     // benefit is lost if 'b' is also tested.
169     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
170     if (a == 0) {
171       return 0;
172     }
173 
174     uint256 c = a * b;
175     require(c / a == b);
176 
177     return c;
178   }
179 
180   /**
181   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
182   */
183   function div(uint256 a, uint256 b) internal pure returns (uint256) {
184     require(b > 0); // Solidity only automatically asserts when dividing by 0
185     uint256 c = a / b;
186     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
187 
188     return c;
189   }
190 
191   /**
192   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
193   */
194   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195     require(b <= a);
196     uint256 c = a - b;
197 
198     return c;
199   }
200 
201   /**
202   * @dev Adds two numbers, reverts on overflow.
203   */
204   function add(uint256 a, uint256 b) internal pure returns (uint256) {
205     uint256 c = a + b;
206     require(c >= a);
207 
208     return c;
209   }
210 
211   /**
212   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
213   * reverts when dividing by zero.
214   */
215   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216     require(b != 0);
217     return a % b;
218   }
219 }
220 
221 // File: contracts/lib/SafeMathInt.sol
222 
223 /*
224 MIT License
225 
226 Copyright (c) 2018 requestnetwork
227 Copyright (c) 2018 Fragments, Inc.
228 
229 Permission is hereby granted, free of charge, to any person obtaining a copy
230 of this software and associated documentation files (the "Software"), to deal
231 in the Software without restriction, including without limitation the rights
232 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
233 copies of the Software, and to permit persons to whom the Software is
234 furnished to do so, subject to the following conditions:
235 
236 The above copyright notice and this permission notice shall be included in all
237 copies or substantial portions of the Software.
238 
239 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
240 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
241 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
242 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
243 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
244 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
245 SOFTWARE.
246 */
247 
248 pragma solidity 0.4.24;
249 
250 
251 /**
252  * @title SafeMathInt
253  * @dev Math operations for int256 with overflow safety checks.
254  */
255 library SafeMathInt {
256     int256 private constant MIN_INT256 = int256(1) << 255;
257     int256 private constant MAX_INT256 = ~(int256(1) << 255);
258 
259     /**
260      * @dev Multiplies two int256 variables and fails on overflow.
261      */
262     function mul(int256 a, int256 b)
263         internal
264         pure
265         returns (int256)
266     {
267         int256 c = a * b;
268 
269         // Detect overflow when multiplying MIN_INT256 with -1
270         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
271         require((b == 0) || (c / b == a));
272         return c;
273     }
274 
275     /**
276      * @dev Division of two int256 variables and fails on overflow.
277      */
278     function div(int256 a, int256 b)
279         internal
280         pure
281         returns (int256)
282     {
283         // Prevent overflow when dividing MIN_INT256 by -1
284         require(b != -1 || a != MIN_INT256);
285 
286         // Solidity already throws when dividing by 0.
287         return a / b;
288     }
289 
290     /**
291      * @dev Subtracts two int256 variables and fails on overflow.
292      */
293     function sub(int256 a, int256 b)
294         internal
295         pure
296         returns (int256)
297     {
298         int256 c = a - b;
299         require((b >= 0 && c <= a) || (b < 0 && c > a));
300         return c;
301     }
302 
303     /**
304      * @dev Adds two int256 variables and fails on overflow.
305      */
306     function add(int256 a, int256 b)
307         internal
308         pure
309         returns (int256)
310     {
311         int256 c = a + b;
312         require((b >= 0 && c >= a) || (b < 0 && c < a));
313         return c;
314     }
315 
316     /**
317      * @dev Converts to absolute value, and fails on overflow.
318      */
319     function abs(int256 a)
320         internal
321         pure
322         returns (int256)
323     {
324         require(a != MIN_INT256);
325         return a < 0 ? -a : a;
326     }
327 }
328 
329 // File: contracts/lib/UInt256Lib.sol
330 
331 pragma solidity 0.4.24;
332 
333 
334 /**
335  * @title Various utilities useful for uint256.
336  */
337 library UInt256Lib {
338 
339     uint256 private constant MAX_INT256 = ~(uint256(1) << 255);
340 
341     /**
342      * @dev Safely converts a uint256 to an int256.
343      */
344     function toInt256Safe(uint256 a)
345         internal
346         pure
347         returns (int256)
348     {
349         require(a <= MAX_INT256);
350         return int256(a);
351     }
352 }
353 
354 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
355 
356 pragma solidity ^0.4.24;
357 
358 
359 /**
360  * @title ERC20 interface
361  * @dev see https://github.com/ethereum/EIPs/issues/20
362  */
363 interface IERC20 {
364   function totalSupply() external view returns (uint256);
365 
366   function balanceOf(address who) external view returns (uint256);
367 
368   function allowance(address owner, address spender)
369     external view returns (uint256);
370 
371   function transfer(address to, uint256 value) external returns (bool);
372 
373   function approve(address spender, uint256 value)
374     external returns (bool);
375 
376   function transferFrom(address from, address to, uint256 value)
377     external returns (bool);
378 
379   event Transfer(
380     address indexed from,
381     address indexed to,
382     uint256 value
383   );
384 
385   event Approval(
386     address indexed owner,
387     address indexed spender,
388     uint256 value
389   );
390 }
391 
392 // File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol
393 
394 pragma solidity ^0.4.24;
395 
396 
397 /**
398  * @title ERC20Detailed token
399  * @dev The decimals are only for visualization purposes.
400  * All the operations are done using the smallest and indivisible token unit,
401  * just as on Ethereum all the operations are done in wei.
402  */
403 contract ERC20Detailed is Initializable, IERC20 {
404   string private _name;
405   string private _symbol;
406   uint8 private _decimals;
407 
408   function initialize(string name, string symbol, uint8 decimals) public initializer {
409     _name = name;
410     _symbol = symbol;
411     _decimals = decimals;
412   }
413 
414   /**
415    * @return the name of the token.
416    */
417   function name() public view returns(string) {
418     return _name;
419   }
420 
421   /**
422    * @return the symbol of the token.
423    */
424   function symbol() public view returns(string) {
425     return _symbol;
426   }
427 
428   /**
429    * @return the number of decimals of the token.
430    */
431   function decimals() public view returns(uint8) {
432     return _decimals;
433   }
434 
435   uint256[50] private ______gap;
436 }
437 
438 
439 // File: contracts/UFragments.sol
440 
441 pragma solidity 0.4.24;
442 
443 
444 /**
445  * @title uFragments ERC20 token
446  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
447  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
448  *      combining tokens proportionally across all wallets.
449  *
450  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
451  *      We support splitting the currency in expansion and combining the currency on contraction by
452  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
453  */
454 contract UFragments is ERC20Detailed, Ownable {
455     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
456     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
457     // order to minimize this risk, we adhere to the following guidelines:
458     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
459     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
460     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
461     //    multiplying by the inverse rate, you should divide by the normal rate)
462     // 2) Gon balances converted into Fragments are always rounded down (truncated).
463     //
464     // We make the following guarantees:
465     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
466     //   be decreased by precisely x Fragments, and B's external balance will be precisely
467     //   increased by x Fragments.
468     //
469     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
470     // This is because, for any conversion function 'f()' that has non-zero rounding error,
471     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
472     using SafeMath for uint256;
473     using SafeMathInt for int256;
474 
475     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
476     event LogRebasePaused(bool paused);
477     event LogTokenPaused(bool paused);
478     event LogMonetaryPolicyUpdated(address monetaryPolicy);
479 
480     // Used for authentication
481     address public monetaryPolicy;
482 
483     modifier onlyMonetaryPolicy() {
484         require(msg.sender == monetaryPolicy);
485         _;
486     }
487 
488     // Precautionary emergency controls.
489     bool public rebasePaused;
490     bool public tokenPaused;
491 
492     modifier whenRebaseNotPaused() {
493         require(!rebasePaused);
494         _;
495     }
496 
497     modifier whenTokenNotPaused() {
498         require(!tokenPaused);
499         _;
500     }
501 
502     modifier validRecipient(address to) {
503         require(to != address(0x0));
504         require(to != address(this));
505         _;
506     }
507 
508     uint256 private constant DECIMALS = 9;
509     uint256 private constant MAX_UINT256 = ~uint256(0);
510     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 50 * 10**6 * 10**DECIMALS;
511 
512     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
513     // Use the highest value that fits in a uint256 for max granularity.
514     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
515 
516     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
517     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
518 
519     uint256 private _totalSupply;
520     uint256 private _gonsPerFragment;
521     mapping(address => uint256) private _gonBalances;
522 
523     // This is denominated in Fragments, because the gons-fragments conversion might change before
524     // it's fully paid.
525     mapping (address => mapping (address => uint256)) private _allowedFragments;
526 
527     /**
528      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
529      */
530     function setMonetaryPolicy(address monetaryPolicy_)
531         external
532         onlyOwner
533     {
534         monetaryPolicy = monetaryPolicy_;
535         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
536     }
537 
538     /**
539      * @dev Pauses or unpauses the execution of rebase operations.
540      * @param paused Pauses rebase operations if this is true.
541      */
542     function setRebasePaused(bool paused)
543         external
544         onlyOwner
545     {
546         rebasePaused = paused;
547         emit LogRebasePaused(paused);
548     }
549 
550     /**
551      * @dev Pauses or unpauses execution of ERC-20 transactions.
552      * @param paused Pauses ERC-20 transactions if this is true.
553      */
554     function setTokenPaused(bool paused)
555         external
556         onlyOwner
557     {
558         tokenPaused = paused;
559         emit LogTokenPaused(paused);
560     }
561 
562     /**
563      * @dev Notifies Fragments contract about a new rebase cycle.
564      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
565      * @return The total number of fragments after the supply adjustment.
566      */
567     function rebase(uint256 epoch, int256 supplyDelta)
568         external
569         onlyMonetaryPolicy
570         whenRebaseNotPaused
571         returns (uint256)
572     {
573         if (supplyDelta == 0) {
574             emit LogRebase(epoch, _totalSupply);
575             return _totalSupply;
576         }
577 
578         if (supplyDelta < 0) {
579             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
580         } else {
581             _totalSupply = _totalSupply.add(uint256(supplyDelta));
582         }
583 
584         if (_totalSupply > MAX_SUPPLY) {
585             _totalSupply = MAX_SUPPLY;
586         }
587 
588         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
589 
590         // From this point forward, _gonsPerFragment is taken as the source of truth.
591         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
592         // conversion rate.
593         // This means our applied supplyDelta can deviate from the requested supplyDelta,
594         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
595         //
596         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
597         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
598         // ever increased, it must be re-included.
599         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
600 
601         emit LogRebase(epoch, _totalSupply);
602         return _totalSupply;
603     }
604 
605     function initialize(address owner_)
606         public
607         initializer
608     {
609         ERC20Detailed.initialize("Ampleforth", "AMPL", uint8(DECIMALS));
610         Ownable.initialize(owner_);
611 
612         rebasePaused = false;
613         tokenPaused = false;
614 
615         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
616         _gonBalances[owner_] = TOTAL_GONS;
617         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
618 
619         emit Transfer(address(0x0), owner_, _totalSupply);
620     }
621 
622     /**
623      * @return The total number of fragments.
624      */
625     function totalSupply()
626         public
627         view
628         returns (uint256)
629     {
630         return _totalSupply;
631     }
632 
633     /**
634      * @param who The address to query.
635      * @return The balance of the specified address.
636      */
637     function balanceOf(address who)
638         public
639         view
640         returns (uint256)
641     {
642         return _gonBalances[who].div(_gonsPerFragment);
643     }
644 
645     /**
646      * @dev Transfer tokens to a specified address.
647      * @param to The address to transfer to.
648      * @param value The amount to be transferred.
649      * @return True on success, false otherwise.
650      */
651     function transfer(address to, uint256 value)
652         public
653         validRecipient(to)
654         whenTokenNotPaused
655         returns (bool)
656     {
657         uint256 gonValue = value.mul(_gonsPerFragment);
658         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
659         _gonBalances[to] = _gonBalances[to].add(gonValue);
660         emit Transfer(msg.sender, to, value);
661         return true;
662     }
663 
664     /**
665      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
666      * @param owner_ The address which owns the funds.
667      * @param spender The address which will spend the funds.
668      * @return The number of tokens still available for the spender.
669      */
670     function allowance(address owner_, address spender)
671         public
672         view
673         returns (uint256)
674     {
675         return _allowedFragments[owner_][spender];
676     }
677 
678     /**
679      * @dev Transfer tokens from one address to another.
680      * @param from The address you want to send tokens from.
681      * @param to The address you want to transfer to.
682      * @param value The amount of tokens to be transferred.
683      */
684     function transferFrom(address from, address to, uint256 value)
685         public
686         validRecipient(to)
687         whenTokenNotPaused
688         returns (bool)
689     {
690         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
691 
692         uint256 gonValue = value.mul(_gonsPerFragment);
693         _gonBalances[from] = _gonBalances[from].sub(gonValue);
694         _gonBalances[to] = _gonBalances[to].add(gonValue);
695         emit Transfer(from, to, value);
696 
697         return true;
698     }
699 
700     /**
701      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
702      * msg.sender. This method is included for ERC20 compatibility.
703      * increaseAllowance and decreaseAllowance should be used instead.
704      * Changing an allowance with this method brings the risk that someone may transfer both
705      * the old and the new allowance - if they are both greater than zero - if a transfer
706      * transaction is mined before the later approve() call is mined.
707      *
708      * @param spender The address which will spend the funds.
709      * @param value The amount of tokens to be spent.
710      */
711     function approve(address spender, uint256 value)
712         public
713         whenTokenNotPaused
714         returns (bool)
715     {
716         _allowedFragments[msg.sender][spender] = value;
717         emit Approval(msg.sender, spender, value);
718         return true;
719     }
720 
721     /**
722      * @dev Increase the amount of tokens that an owner has allowed to a spender.
723      * This method should be used instead of approve() to avoid the double approval vulnerability
724      * described above.
725      * @param spender The address which will spend the funds.
726      * @param addedValue The amount of tokens to increase the allowance by.
727      */
728     function increaseAllowance(address spender, uint256 addedValue)
729         public
730         whenTokenNotPaused
731         returns (bool)
732     {
733         _allowedFragments[msg.sender][spender] =
734             _allowedFragments[msg.sender][spender].add(addedValue);
735         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
736         return true;
737     }
738 
739     /**
740      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
741      *
742      * @param spender The address which will spend the funds.
743      * @param subtractedValue The amount of tokens to decrease the allowance by.
744      */
745     function decreaseAllowance(address spender, uint256 subtractedValue)
746         public
747         whenTokenNotPaused
748         returns (bool)
749     {
750         uint256 oldValue = _allowedFragments[msg.sender][spender];
751         if (subtractedValue >= oldValue) {
752             _allowedFragments[msg.sender][spender] = 0;
753         } else {
754             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
755         }
756         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
757         return true;
758     }
759 }
760 
761 // File: contracts/UFragmentsPolicy.sol
762 
763 pragma solidity 0.4.24;
764 
765 
766 interface IOracle {
767     function getData() external returns (uint256, bool);
768 }
769 
770 
771 /**
772  * @title uFragments Monetary Supply Policy
773  * @dev This is an implementation of the uFragments Ideal Money protocol.
774  *      uFragments operates symmetrically on expansion and contraction. It will both split and
775  *      combine coins to maintain a stable unit price.
776  *
777  *      This component regulates the token supply of the uFragments ERC20 token in response to
778  *      market oracles.
779  */
780 contract UFragmentsPolicy is Ownable {
781     using SafeMath for uint256;
782     using SafeMathInt for int256;
783     using UInt256Lib for uint256;
784 
785     event LogRebase(
786         uint256 indexed epoch,
787         uint256 exchangeRate,
788         uint256 cpi,
789         int256 requestedSupplyAdjustment,
790         uint256 timestampSec
791     );
792 
793     UFragments public uFrags;
794 
795     // Provides the current CPI, as an 18 decimal fixed point number.
796     IOracle public cpiOracle;
797 
798     // Market oracle provides the token/USD exchange rate as an 18 decimal fixed point number.
799     // (eg) An oracle value of 1.5e18 it would mean 1 Ample is trading for $1.50.
800     IOracle public marketOracle;
801 
802     // CPI value at the time of launch, as an 18 decimal fixed point number.
803     uint256 private baseCpi;
804 
805     // If the current exchange rate is within this fractional distance from the target, no supply
806     // update is performed. Fixed point number--same format as the rate.
807     // (ie) abs(rate - targetRate) / targetRate < deviationThreshold, then no supply change.
808     // DECIMALS Fixed point number.
809     uint256 public deviationThreshold;
810 
811     // The rebase lag parameter, used to dampen the applied supply adjustment by 1 / rebaseLag
812     // Check setRebaseLag comments for more details.
813     // Natural number, no decimal places.
814     uint256 public rebaseLag;
815 
816     // More than this much time must pass between rebase operations.
817     uint256 public minRebaseTimeIntervalSec;
818 
819     // Block timestamp of last rebase operation
820     uint256 public lastRebaseTimestampSec;
821 
822     // The rebase window begins this many seconds into the minRebaseTimeInterval period.
823     // For example if minRebaseTimeInterval is 24hrs, it represents the time of day in seconds.
824     uint256 public rebaseWindowOffsetSec;
825 
826     // The length of the time window where a rebase operation is allowed to execute, in seconds.
827     uint256 public rebaseWindowLengthSec;
828 
829     // The number of rebase cycles since inception
830     uint256 public epoch;
831 
832     uint256 private constant DECIMALS = 18;
833 
834     // Due to the expression in computeSupplyDelta(), MAX_RATE * MAX_SUPPLY must fit into an int256.
835     // Both are 18 decimals fixed point numbers.
836     uint256 private constant MAX_RATE = 10**6 * 10**DECIMALS;
837     // MAX_SUPPLY = MAX_INT256 / MAX_RATE
838     uint256 private constant MAX_SUPPLY = ~(uint256(1) << 255) / MAX_RATE;
839 
840     // This module orchestrates the rebase execution and downstream notification.
841     address public orchestrator;
842 
843     modifier onlyOrchestrator() {
844         require(msg.sender == orchestrator);
845         _;
846     }
847 
848     /**
849      * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
850      *
851      * @dev The supply adjustment equals (_totalSupply * DeviationFromTargetRate) / rebaseLag
852      *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
853      *      and targetRate is CpiOracleRate / baseCpi
854      */
855     function rebase() external onlyOrchestrator {
856         require(inRebaseWindow());
857 
858         // This comparison also ensures there is no reentrancy.
859         require(lastRebaseTimestampSec.add(minRebaseTimeIntervalSec) < now);
860 
861         // Snap the rebase time to the start of this window.
862         lastRebaseTimestampSec = now.sub(
863             now.mod(minRebaseTimeIntervalSec)).add(rebaseWindowOffsetSec);
864 
865         epoch = epoch.add(1);
866 
867         uint256 cpi;
868         bool cpiValid;
869         (cpi, cpiValid) = cpiOracle.getData();
870         require(cpiValid);
871 
872         uint256 targetRate = cpi.mul(10 ** DECIMALS).div(baseCpi);
873 
874         uint256 exchangeRate;
875         bool rateValid;
876         (exchangeRate, rateValid) = marketOracle.getData();
877         require(rateValid);
878 
879         if (exchangeRate > MAX_RATE) {
880             exchangeRate = MAX_RATE;
881         }
882 
883         int256 supplyDelta = computeSupplyDelta(exchangeRate, targetRate);
884 
885         // Apply the Dampening factor.
886         supplyDelta = supplyDelta.div(rebaseLag.toInt256Safe());
887 
888         if (supplyDelta > 0 && uFrags.totalSupply().add(uint256(supplyDelta)) > MAX_SUPPLY) {
889             supplyDelta = (MAX_SUPPLY.sub(uFrags.totalSupply())).toInt256Safe();
890         }
891 
892         uint256 supplyAfterRebase = uFrags.rebase(epoch, supplyDelta);
893         assert(supplyAfterRebase <= MAX_SUPPLY);
894         emit LogRebase(epoch, exchangeRate, cpi, supplyDelta, now);
895     }
896 
897     /**
898      * @notice Sets the reference to the CPI oracle.
899      * @param cpiOracle_ The address of the cpi oracle contract.
900      */
901     function setCpiOracle(IOracle cpiOracle_)
902         external
903         onlyOwner
904     {
905         cpiOracle = cpiOracle_;
906     }
907 
908     /**
909      * @notice Sets the reference to the market oracle.
910      * @param marketOracle_ The address of the market oracle contract.
911      */
912     function setMarketOracle(IOracle marketOracle_)
913         external
914         onlyOwner
915     {
916         marketOracle = marketOracle_;
917     }
918 
919     /**
920      * @notice Sets the reference to the orchestrator.
921      * @param orchestrator_ The address of the orchestrator contract.
922      */
923     function setOrchestrator(address orchestrator_)
924         external
925         onlyOwner
926     {
927         orchestrator = orchestrator_;
928     }
929 
930     /**
931      * @notice Sets the deviation threshold fraction. If the exchange rate given by the market
932      *         oracle is within this fractional distance from the targetRate, then no supply
933      *         modifications are made. DECIMALS fixed point number.
934      * @param deviationThreshold_ The new exchange rate threshold fraction.
935      */
936     function setDeviationThreshold(uint256 deviationThreshold_)
937         external
938         onlyOwner
939     {
940         deviationThreshold = deviationThreshold_;
941     }
942 
943     /**
944      * @notice Sets the rebase lag parameter.
945                It is used to dampen the applied supply adjustment by 1 / rebaseLag
946                If the rebase lag R, equals 1, the smallest value for R, then the full supply
947                correction is applied on each rebase cycle.
948                If it is greater than 1, then a correction of 1/R of is applied on each rebase.
949      * @param rebaseLag_ The new rebase lag parameter.
950      */
951     function setRebaseLag(uint256 rebaseLag_)
952         external
953         onlyOwner
954     {
955         require(rebaseLag_ > 0);
956         rebaseLag = rebaseLag_;
957     }
958 
959     /**
960      * @notice Sets the parameters which control the timing and frequency of
961      *         rebase operations.
962      *         a) the minimum time period that must elapse between rebase cycles.
963      *         b) the rebase window offset parameter.
964      *         c) the rebase window length parameter.
965      * @param minRebaseTimeIntervalSec_ More than this much time must pass between rebase
966      *        operations, in seconds.
967      * @param rebaseWindowOffsetSec_ The number of seconds from the beginning of
968               the rebase interval, where the rebase window begins.
969      * @param rebaseWindowLengthSec_ The length of the rebase window in seconds.
970      */
971     function setRebaseTimingParameters(
972         uint256 minRebaseTimeIntervalSec_,
973         uint256 rebaseWindowOffsetSec_,
974         uint256 rebaseWindowLengthSec_)
975         external
976         onlyOwner
977     {
978         require(minRebaseTimeIntervalSec_ > 0);
979         require(rebaseWindowOffsetSec_ < minRebaseTimeIntervalSec_);
980 
981         minRebaseTimeIntervalSec = minRebaseTimeIntervalSec_;
982         rebaseWindowOffsetSec = rebaseWindowOffsetSec_;
983         rebaseWindowLengthSec = rebaseWindowLengthSec_;
984     }
985 
986     /**
987      * @dev ZOS upgradable contract initialization method.
988      *      It is called at the time of contract creation to invoke parent class initializers and
989      *      initialize the contract's state variables.
990      */
991     function initialize(address owner_, UFragments uFrags_, uint256 baseCpi_)
992         public
993         initializer
994     {
995         Ownable.initialize(owner_);
996 
997         // deviationThreshold = 0.05e18 = 5e16
998         deviationThreshold = 5 * 10 ** (DECIMALS-2);
999 
1000         rebaseLag = 30;
1001         minRebaseTimeIntervalSec = 1 days;
1002         rebaseWindowOffsetSec = 72000;  // 8PM UTC
1003         rebaseWindowLengthSec = 15 minutes;
1004         lastRebaseTimestampSec = 0;
1005         epoch = 0;
1006 
1007         uFrags = uFrags_;
1008         baseCpi = baseCpi_;
1009     }
1010 
1011     /**
1012      * @return If the latest block timestamp is within the rebase time window it, returns true.
1013      *         Otherwise, returns false.
1014      */
1015     function inRebaseWindow() public view returns (bool) {
1016         return (
1017             now.mod(minRebaseTimeIntervalSec) >= rebaseWindowOffsetSec &&
1018             now.mod(minRebaseTimeIntervalSec) < (rebaseWindowOffsetSec.add(rebaseWindowLengthSec))
1019         );
1020     }
1021 
1022     /**
1023      * @return Computes the total supply adjustment in response to the exchange rate
1024      *         and the targetRate.
1025      */
1026     function computeSupplyDelta(uint256 rate, uint256 targetRate)
1027         private
1028         view
1029         returns (int256)
1030     {
1031         if (withinDeviationThreshold(rate, targetRate)) {
1032             return 0;
1033         }
1034 
1035         // supplyDelta = totalSupply * (rate - targetRate) / targetRate
1036         int256 targetRateSigned = targetRate.toInt256Safe();
1037         return uFrags.totalSupply().toInt256Safe()
1038             .mul(rate.toInt256Safe().sub(targetRateSigned))
1039             .div(targetRateSigned);
1040     }
1041 
1042     /**
1043      * @param rate The current exchange rate, an 18 decimal fixed point number.
1044      * @param targetRate The target exchange rate, an 18 decimal fixed point number.
1045      * @return If the rate is within the deviation threshold from the target rate, returns true.
1046      *         Otherwise, returns false.
1047      */
1048     function withinDeviationThreshold(uint256 rate, uint256 targetRate)
1049         private
1050         view
1051         returns (bool)
1052     {
1053         uint256 absoluteDeviationThreshold = targetRate.mul(deviationThreshold)
1054             .div(10 ** DECIMALS);
1055 
1056         return (rate >= targetRate && rate.sub(targetRate) < absoluteDeviationThreshold)
1057             || (rate < targetRate && targetRate.sub(rate) < absoluteDeviationThreshold);
1058     }
1059 }
1060 
1061 // File: contracts/Orchestrator.sol
1062 
1063 pragma solidity 0.4.24;
1064 
1065 
1066 /**
1067  * @title Orchestrator
1068  * @notice The orchestrator is the main entry point for rebase operations. It coordinates the policy
1069  * actions with external consumers.
1070  */
1071 contract Orchestrator is Ownable {
1072 
1073     struct Transaction {
1074         bool enabled;
1075         address destination;
1076         bytes data;
1077     }
1078 
1079     event TransactionFailed(address indexed destination, uint index, bytes data);
1080 
1081     // Stable ordering is not guaranteed.
1082     Transaction[] public transactions;
1083 
1084     UFragmentsPolicy public policy;
1085 
1086     /**
1087      * @param policy_ Address of the UFragments policy.
1088      */
1089     constructor(address policy_) public {
1090         Ownable.initialize(msg.sender);
1091         policy = UFragmentsPolicy(policy_);
1092     }
1093 
1094     /**
1095      * @notice Main entry point to initiate a rebase operation.
1096      *         The Orchestrator calls rebase on the policy and notifies downstream applications.
1097      *         Contracts are guarded from calling, to avoid flash loan attacks on liquidity
1098      *         providers.
1099      *         If a transaction in the transaction list reverts, it is swallowed and the remaining
1100      *         transactions are executed.
1101      */
1102     function rebase()
1103         external
1104     {
1105         require(msg.sender == tx.origin);  // solhint-disable-line avoid-tx-origin
1106 
1107         policy.rebase();
1108 
1109         for (uint i = 0; i < transactions.length; i++) {
1110             Transaction storage t = transactions[i];
1111             if (t.enabled) {
1112                 bool result =
1113                     externalCall(t.destination, t.data);
1114                 if (!result) {
1115                     emit TransactionFailed(t.destination, i, t.data);
1116                     revert("Transaction Failed");
1117                 }
1118             }
1119         }
1120     }
1121 
1122     /**
1123      * @notice Adds a transaction that gets called for a downstream receiver of rebases
1124      * @param destination Address of contract destination
1125      * @param data Transaction data payload
1126      */
1127     function addTransaction(address destination, bytes data)
1128         external
1129         onlyOwner
1130     {
1131         transactions.push(Transaction({
1132             enabled: true,
1133             destination: destination,
1134             data: data
1135         }));
1136     }
1137 
1138     /**
1139      * @param index Index of transaction to remove.
1140      *              Transaction ordering may have changed since adding.
1141      */
1142     function removeTransaction(uint index)
1143         external
1144         onlyOwner
1145     {
1146         require(index < transactions.length, "index out of bounds");
1147 
1148         if (index < transactions.length - 1) {
1149             transactions[index] = transactions[transactions.length - 1];
1150         }
1151 
1152         transactions.length--;
1153     }
1154 
1155     /**
1156      * @param index Index of transaction. Transaction ordering may have changed since adding.
1157      * @param enabled True for enabled, false for disabled.
1158      */
1159     function setTransactionEnabled(uint index, bool enabled)
1160         external
1161         onlyOwner
1162     {
1163         require(index < transactions.length, "index must be in range of stored tx list");
1164         transactions[index].enabled = enabled;
1165     }
1166 
1167     /**
1168      * @return Number of transactions, both enabled and disabled, in transactions list.
1169      */
1170     function transactionsSize()
1171         external
1172         view
1173         returns (uint256)
1174     {
1175         return transactions.length;
1176     }
1177 
1178     /**
1179      * @dev wrapper to call the encoded transactions on downstream consumers.
1180      * @param destination Address of destination contract.
1181      * @param data The encoded data payload.
1182      * @return True on success
1183      */
1184     function externalCall(address destination, bytes data)
1185         internal
1186         returns (bool)
1187     {
1188         bool result;
1189         assembly {  // solhint-disable-line no-inline-assembly
1190             // "Allocate" memory for output
1191             // (0x40 is where "free memory" pointer is stored by convention)
1192             let outputAddress := mload(0x40)
1193 
1194             // First 32 bytes are the padded length of data, so exclude that
1195             let dataAddress := add(data, 32)
1196 
1197             result := call(
1198                 // 34710 is the value that solidity is currently emitting
1199                 // It includes callGas (700) + callVeryLow (3, to pay for SUB)
1200                 // + callValueTransferGas (9000) + callNewAccountGas
1201                 // (25000, in case the destination address does not exist and needs creating)
1202                 sub(gas, 34710),
1203 
1204 
1205                 destination,
1206                 0, // transfer value in wei
1207                 dataAddress,
1208                 mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.
1209                 outputAddress,
1210                 0  // Output is ignored, therefore the output size is zero
1211             )
1212         }
1213         return result;
1214     }
1215 }