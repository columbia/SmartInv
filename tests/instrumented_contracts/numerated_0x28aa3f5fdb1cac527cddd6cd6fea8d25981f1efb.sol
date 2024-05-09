1 // File: zos-lib/contracts/Initializable.sol
2 
3 pragma solidity >=0.4.24 <0.6.0;
4 
5 
6 /**
7  * @title Initializable
8  *
9  * @dev Helper contract to support initializer functions. To use it, replace
10  * the constructor with a function that has the `initializer` modifier.
11  * WARNING: Unlike constructors, initializer functions must be manually
12  * invoked. This applies both to deploying an Initializable contract, as well
13  * as extending an Initializable contract via inheritance.
14  * WARNING: When used with inheritance, manual care must be taken to not invoke
15  * a parent initializer twice, or ensure that all initializers are idempotent,
16  * because this is not dealt with automatically as with constructors.
17  */
18 contract Initializable {
19 
20   /**
21    * @dev Indicates that the contract has been initialized.
22    */
23   bool private initialized;
24 
25   /**
26    * @dev Indicates that the contract is in the process of being initialized.
27    */
28   bool private initializing;
29 
30   /**
31    * @dev Modifier to use in the initializer function of a contract.
32    */
33   modifier initializer() {
34     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
35 
36     bool isTopLevelCall = !initializing;
37     if (isTopLevelCall) {
38       initializing = true;
39       initialized = true;
40     }
41 
42     _;
43 
44     if (isTopLevelCall) {
45       initializing = false;
46     }
47   }
48 
49   /// @dev Returns true if and only if the function is running in the constructor
50   function isConstructor() private view returns (bool) {
51     // extcodesize checks the size of the code stored in an address, and
52     // address returns the current address. Since the code is still not
53     // deployed when running a constructor, any checks on its code size will
54     // yield zero, making it an effective way to detect if a contract is
55     // under construction or not.
56     uint256 cs;
57     assembly { cs := extcodesize(address) }
58     return cs == 0;
59   }
60 
61   // Reserved storage space to allow for layout changes in the future.
62   uint256[50] private ______gap;
63 }
64 
65 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
66 
67 pragma solidity ^0.4.24;
68 
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable is Initializable {
76   address private _owner;
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
90   function initialize(address sender) public initializer {
91     _owner = sender;
92   }
93 
94   /**
95    * @return the address of the owner.
96    */
97   function owner() public view returns(address) {
98     return _owner;
99   }
100 
101   /**
102    * @dev Throws if called by any account other than the owner.
103    */
104   modifier onlyOwner() {
105     require(isOwner());
106     _;
107   }
108 
109   /**
110    * @return true if `msg.sender` is the owner of the contract.
111    */
112   function isOwner() public view returns(bool) {
113     return msg.sender == _owner;
114   }
115 
116   /**
117    * @dev Allows the current owner to relinquish control of the contract.
118    * @notice Renouncing to ownership will leave the contract without an owner.
119    * It will not be possible to call the functions with the `onlyOwner`
120    * modifier anymore.
121    */
122   function renounceOwnership() public onlyOwner {
123     emit OwnershipRenounced(_owner);
124     _owner = address(0);
125   }
126 
127   /**
128    * @dev Allows the current owner to transfer control of the contract to a newOwner.
129    * @param newOwner The address to transfer ownership to.
130    */
131   function transferOwnership(address newOwner) public onlyOwner {
132     _transferOwnership(newOwner);
133   }
134 
135   /**
136    * @dev Transfers control of the contract to a newOwner.
137    * @param newOwner The address to transfer ownership to.
138    */
139   function _transferOwnership(address newOwner) internal {
140     require(newOwner != address(0));
141     emit OwnershipTransferred(_owner, newOwner);
142     _owner = newOwner;
143   }
144 
145   uint256[50] private ______gap;
146 }
147 
148 // File: openzeppelin-eth/contracts/math/SafeMath.sol
149 
150 pragma solidity ^0.4.24;
151 
152 
153 /**
154  * @title SafeMath
155  * @dev Math operations with safety checks that revert on error
156  */
157 library SafeMath {
158 
159   /**
160   * @dev Multiplies two numbers, reverts on overflow.
161   */
162   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164     // benefit is lost if 'b' is also tested.
165     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
166     if (a == 0) {
167       return 0;
168     }
169 
170     uint256 c = a * b;
171     require(c / a == b);
172 
173     return c;
174   }
175 
176   /**
177   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
178   */
179   function div(uint256 a, uint256 b) internal pure returns (uint256) {
180     require(b > 0); // Solidity only automatically asserts when dividing by 0
181     uint256 c = a / b;
182     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183 
184     return c;
185   }
186 
187   /**
188   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
189   */
190   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191     require(b <= a);
192     uint256 c = a - b;
193 
194     return c;
195   }
196 
197   /**
198   * @dev Adds two numbers, reverts on overflow.
199   */
200   function add(uint256 a, uint256 b) internal pure returns (uint256) {
201     uint256 c = a + b;
202     require(c >= a);
203 
204     return c;
205   }
206 
207   /**
208   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
209   * reverts when dividing by zero.
210   */
211   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212     require(b != 0);
213     return a % b;
214   }
215 }
216 
217 // File: contracts/lib/SafeMathInt.sol
218 
219 /*
220 MIT License
221 
222 Copyright (c) 2018 requestnetwork
223 Copyright (c) 2018 Fragments, Inc.
224 
225 Permission is hereby granted, free of charge, to any person obtaining a copy
226 of this software and associated documentation files (the "Software"), to deal
227 in the Software without restriction, including without limitation the rights
228 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
229 copies of the Software, and to permit persons to whom the Software is
230 furnished to do so, subject to the following conditions:
231 
232 The above copyright notice and this permission notice shall be included in all
233 copies or substantial portions of the Software.
234 
235 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
236 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
237 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
238 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
239 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
240 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
241 SOFTWARE.
242 */
243 
244 pragma solidity 0.4.24;
245 
246 
247 /**
248  * @title SafeMathInt
249  * @dev Math operations for int256 with overflow safety checks.
250  */
251 library SafeMathInt {
252     int256 private constant MIN_INT256 = int256(1) << 255;
253     int256 private constant MAX_INT256 = ~(int256(1) << 255);
254 
255     /**
256      * @dev Multiplies two int256 variables and fails on overflow.
257      */
258     function mul(int256 a, int256 b)
259         internal
260         pure
261         returns (int256)
262     {
263         int256 c = a * b;
264 
265         // Detect overflow when multiplying MIN_INT256 with -1
266         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
267         require((b == 0) || (c / b == a));
268         return c;
269     }
270 
271     /**
272      * @dev Division of two int256 variables and fails on overflow.
273      */
274     function div(int256 a, int256 b)
275         internal
276         pure
277         returns (int256)
278     {
279         // Prevent overflow when dividing MIN_INT256 by -1
280         require(b != -1 || a != MIN_INT256);
281 
282         // Solidity already throws when dividing by 0.
283         return a / b;
284     }
285 
286     /**
287      * @dev Subtracts two int256 variables and fails on overflow.
288      */
289     function sub(int256 a, int256 b)
290         internal
291         pure
292         returns (int256)
293     {
294         int256 c = a - b;
295         require((b >= 0 && c <= a) || (b < 0 && c > a));
296         return c;
297     }
298 
299     /**
300      * @dev Adds two int256 variables and fails on overflow.
301      */
302     function add(int256 a, int256 b)
303         internal
304         pure
305         returns (int256)
306     {
307         int256 c = a + b;
308         require((b >= 0 && c >= a) || (b < 0 && c < a));
309         return c;
310     }
311 
312     /**
313      * @dev Converts to absolute value, and fails on overflow.
314      */
315     function abs(int256 a)
316         internal
317         pure
318         returns (int256)
319     {
320         require(a != MIN_INT256);
321         return a < 0 ? -a : a;
322     }
323 }
324 
325 // File: contracts/lib/UInt256Lib.sol
326 
327 pragma solidity 0.4.24;
328 
329 
330 /**
331  * @title Various utilities useful for uint256.
332  */
333 library UInt256Lib {
334 
335     uint256 private constant MAX_INT256 = ~(uint256(1) << 255);
336 
337     /**
338      * @dev Safely converts a uint256 to an int256.
339      */
340     function toInt256Safe(uint256 a)
341         internal
342         pure
343         returns (int256)
344     {
345         require(a <= MAX_INT256);
346         return int256(a);
347     }
348 }
349 
350 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
351 
352 pragma solidity ^0.4.24;
353 
354 
355 /**
356  * @title ERC20 interface
357  * @dev see https://github.com/ethereum/EIPs/issues/20
358  */
359 interface IERC20 {
360   function totalSupply() external view returns (uint256);
361 
362   function balanceOf(address who) external view returns (uint256);
363 
364   function allowance(address owner, address spender)
365     external view returns (uint256);
366 
367   function transfer(address to, uint256 value) external returns (bool);
368 
369   function approve(address spender, uint256 value)
370     external returns (bool);
371 
372   function transferFrom(address from, address to, uint256 value)
373     external returns (bool);
374 
375   event Transfer(
376     address indexed from,
377     address indexed to,
378     uint256 value
379   );
380 
381   event Approval(
382     address indexed owner,
383     address indexed spender,
384     uint256 value
385   );
386 }
387 
388 // File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol
389 
390 pragma solidity ^0.4.24;
391 
392 
393 /**
394  * @title ERC20Detailed token
395  * @dev The decimals are only for visualization purposes.
396  * All the operations are done using the smallest and indivisible token unit,
397  * just as on Ethereum all the operations are done in wei.
398  */
399 contract ERC20Detailed is Initializable, IERC20 {
400   string private _name;
401   string private _symbol;
402   uint8 private _decimals;
403 
404   function initialize(string name, string symbol, uint8 decimals) public initializer {
405     _name = name;
406     _symbol = symbol;
407     _decimals = decimals;
408   }
409 
410   /**
411    * @return the name of the token.
412    */
413   function name() public view returns(string) {
414     return _name;
415   }
416 
417   /**
418    * @return the symbol of the token.
419    */
420   function symbol() public view returns(string) {
421     return _symbol;
422   }
423 
424   /**
425    * @return the number of decimals of the token.
426    */
427   function decimals() public view returns(uint8) {
428     return _decimals;
429   }
430 
431   uint256[50] private ______gap;
432 }
433 
434 
435 // File: contracts/UFragments.sol
436 
437 pragma solidity 0.4.24;
438 
439 
440 /**
441  * @title uFragments ERC20 token
442  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
443  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
444  *      combining tokens proportionally across all wallets.
445  *
446  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
447  *      We support splitting the currency in expansion and combining the currency on contraction by
448  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
449  */
450 contract UFragments is ERC20Detailed, Ownable {
451     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
452     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
453     // order to minimize this risk, we adhere to the following guidelines:
454     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
455     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
456     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
457     //    multiplying by the inverse rate, you should divide by the normal rate)
458     // 2) Gon balances converted into Fragments are always rounded down (truncated).
459     //
460     // We make the following guarantees:
461     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
462     //   be decreased by precisely x Fragments, and B's external balance will be precisely
463     //   increased by x Fragments.
464     //
465     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
466     // This is because, for any conversion function 'f()' that has non-zero rounding error,
467     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
468     using SafeMath for uint256;
469     using SafeMathInt for int256;
470 
471     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
472     event LogRebasePaused(bool paused);
473     event LogTokenPaused(bool paused);
474     event LogMonetaryPolicyUpdated(address monetaryPolicy);
475 
476     // Used for authentication
477     address public monetaryPolicy;
478 
479     modifier onlyMonetaryPolicy() {
480         require(msg.sender == monetaryPolicy);
481         _;
482     }
483 
484     // Precautionary emergency controls.
485     bool public rebasePaused;
486     bool public tokenPaused;
487 
488     modifier whenRebaseNotPaused() {
489         require(!rebasePaused);
490         _;
491     }
492 
493     modifier whenTokenNotPaused() {
494         require(!tokenPaused);
495         _;
496     }
497 
498     modifier validRecipient(address to) {
499         require(to != address(0x0));
500         require(to != address(this));
501         _;
502     }
503 
504     uint256 private constant DECIMALS = 9;
505     uint256 private constant MAX_UINT256 = ~uint256(0);
506     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 50 * 10**6 * 10**DECIMALS;
507 
508     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
509     // Use the highest value that fits in a uint256 for max granularity.
510     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
511 
512     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
513     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
514 
515     uint256 private _totalSupply;
516     uint256 private _gonsPerFragment;
517     mapping(address => uint256) private _gonBalances;
518 
519     // This is denominated in Fragments, because the gons-fragments conversion might change before
520     // it's fully paid.
521     mapping (address => mapping (address => uint256)) private _allowedFragments;
522 
523     /**
524      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
525      */
526     function setMonetaryPolicy(address monetaryPolicy_)
527         external
528         onlyOwner
529     {
530         monetaryPolicy = monetaryPolicy_;
531         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
532     }
533 
534     /**
535      * @dev Pauses or unpauses the execution of rebase operations.
536      * @param paused Pauses rebase operations if this is true.
537      */
538     function setRebasePaused(bool paused)
539         external
540         onlyOwner
541     {
542         rebasePaused = paused;
543         emit LogRebasePaused(paused);
544     }
545 
546     /**
547      * @dev Pauses or unpauses execution of ERC-20 transactions.
548      * @param paused Pauses ERC-20 transactions if this is true.
549      */
550     function setTokenPaused(bool paused)
551         external
552         onlyOwner
553     {
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
601     function initialize(address owner_)
602         public
603         initializer
604     {
605         ERC20Detailed.initialize("Ampleforth", "AMPL", uint8(DECIMALS));
606         Ownable.initialize(owner_);
607 
608         rebasePaused = false;
609         tokenPaused = false;
610 
611         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
612         _gonBalances[owner_] = TOTAL_GONS;
613         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
614 
615         emit Transfer(address(0x0), owner_, _totalSupply);
616     }
617 
618     /**
619      * @return The total number of fragments.
620      */
621     function totalSupply()
622         public
623         view
624         returns (uint256)
625     {
626         return _totalSupply;
627     }
628 
629     /**
630      * @param who The address to query.
631      * @return The balance of the specified address.
632      */
633     function balanceOf(address who)
634         public
635         view
636         returns (uint256)
637     {
638         return _gonBalances[who].div(_gonsPerFragment);
639     }
640 
641     /**
642      * @dev Transfer tokens to a specified address.
643      * @param to The address to transfer to.
644      * @param value The amount to be transferred.
645      * @return True on success, false otherwise.
646      */
647     function transfer(address to, uint256 value)
648         public
649         validRecipient(to)
650         whenTokenNotPaused
651         returns (bool)
652     {
653         uint256 gonValue = value.mul(_gonsPerFragment);
654         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
655         _gonBalances[to] = _gonBalances[to].add(gonValue);
656         emit Transfer(msg.sender, to, value);
657         return true;
658     }
659 
660     /**
661      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
662      * @param owner_ The address which owns the funds.
663      * @param spender The address which will spend the funds.
664      * @return The number of tokens still available for the spender.
665      */
666     function allowance(address owner_, address spender)
667         public
668         view
669         returns (uint256)
670     {
671         return _allowedFragments[owner_][spender];
672     }
673 
674     /**
675      * @dev Transfer tokens from one address to another.
676      * @param from The address you want to send tokens from.
677      * @param to The address you want to transfer to.
678      * @param value The amount of tokens to be transferred.
679      */
680     function transferFrom(address from, address to, uint256 value)
681         public
682         validRecipient(to)
683         whenTokenNotPaused
684         returns (bool)
685     {
686         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
687 
688         uint256 gonValue = value.mul(_gonsPerFragment);
689         _gonBalances[from] = _gonBalances[from].sub(gonValue);
690         _gonBalances[to] = _gonBalances[to].add(gonValue);
691         emit Transfer(from, to, value);
692 
693         return true;
694     }
695 
696     /**
697      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
698      * msg.sender. This method is included for ERC20 compatibility.
699      * increaseAllowance and decreaseAllowance should be used instead.
700      * Changing an allowance with this method brings the risk that someone may transfer both
701      * the old and the new allowance - if they are both greater than zero - if a transfer
702      * transaction is mined before the later approve() call is mined.
703      *
704      * @param spender The address which will spend the funds.
705      * @param value The amount of tokens to be spent.
706      */
707     function approve(address spender, uint256 value)
708         public
709         whenTokenNotPaused
710         returns (bool)
711     {
712         _allowedFragments[msg.sender][spender] = value;
713         emit Approval(msg.sender, spender, value);
714         return true;
715     }
716 
717     /**
718      * @dev Increase the amount of tokens that an owner has allowed to a spender.
719      * This method should be used instead of approve() to avoid the double approval vulnerability
720      * described above.
721      * @param spender The address which will spend the funds.
722      * @param addedValue The amount of tokens to increase the allowance by.
723      */
724     function increaseAllowance(address spender, uint256 addedValue)
725         public
726         whenTokenNotPaused
727         returns (bool)
728     {
729         _allowedFragments[msg.sender][spender] =
730             _allowedFragments[msg.sender][spender].add(addedValue);
731         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
732         return true;
733     }
734 
735     /**
736      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
737      *
738      * @param spender The address which will spend the funds.
739      * @param subtractedValue The amount of tokens to decrease the allowance by.
740      */
741     function decreaseAllowance(address spender, uint256 subtractedValue)
742         public
743         whenTokenNotPaused
744         returns (bool)
745     {
746         uint256 oldValue = _allowedFragments[msg.sender][spender];
747         if (subtractedValue >= oldValue) {
748             _allowedFragments[msg.sender][spender] = 0;
749         } else {
750             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
751         }
752         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
753         return true;
754     }
755 }
756 
757 // File: contracts/UFragmentsPolicy.sol
758 
759 pragma solidity 0.4.24;
760 
761 
762 interface IOracle {
763     function getData() external returns (uint256, bool);
764 }
765 
766 
767 /**
768  * @title uFragments Monetary Supply Policy
769  * @dev This is an implementation of the uFragments Ideal Money protocol.
770  *      uFragments operates symmetrically on expansion and contraction. It will both split and
771  *      combine coins to maintain a stable unit price.
772  *
773  *      This component regulates the token supply of the uFragments ERC20 token in response to
774  *      market oracles.
775  */
776 contract UFragmentsPolicy is Ownable {
777     using SafeMath for uint256;
778     using SafeMathInt for int256;
779     using UInt256Lib for uint256;
780 
781     event LogRebase(
782         uint256 indexed epoch,
783         uint256 exchangeRate,
784         uint256 cpi,
785         int256 requestedSupplyAdjustment,
786         uint256 timestampSec
787     );
788 
789     UFragments public uFrags;
790 
791     // Provides the current CPI, as an 18 decimal fixed point number.
792     IOracle public cpiOracle;
793 
794     // Market oracle provides the token/USD exchange rate as an 18 decimal fixed point number.
795     // (eg) An oracle value of 1.5e18 it would mean 1 Ample is trading for $1.50.
796     IOracle public marketOracle;
797 
798     // CPI value at the time of launch, as an 18 decimal fixed point number.
799     uint256 private baseCpi;
800 
801     // If the current exchange rate is within this fractional distance from the target, no supply
802     // update is performed. Fixed point number--same format as the rate.
803     // (ie) abs(rate - targetRate) / targetRate < deviationThreshold, then no supply change.
804     // DECIMALS Fixed point number.
805     uint256 public deviationThreshold;
806 
807     // The rebase lag parameter, used to dampen the applied supply adjustment by 1 / rebaseLag
808     // Check setRebaseLag comments for more details.
809     // Natural number, no decimal places.
810     uint256 public rebaseLag;
811 
812     // More than this much time must pass between rebase operations.
813     uint256 public minRebaseTimeIntervalSec;
814 
815     // Block timestamp of last rebase operation
816     uint256 public lastRebaseTimestampSec;
817 
818     // The rebase window begins this many seconds into the minRebaseTimeInterval period.
819     // For example if minRebaseTimeInterval is 24hrs, it represents the time of day in seconds.
820     uint256 public rebaseWindowOffsetSec;
821 
822     // The length of the time window where a rebase operation is allowed to execute, in seconds.
823     uint256 public rebaseWindowLengthSec;
824 
825     // The number of rebase cycles since inception
826     uint256 public epoch;
827 
828     uint256 private constant DECIMALS = 18;
829 
830     // Due to the expression in computeSupplyDelta(), MAX_RATE * MAX_SUPPLY must fit into an int256.
831     // Both are 18 decimals fixed point numbers.
832     uint256 private constant MAX_RATE = 10**6 * 10**DECIMALS;
833     // MAX_SUPPLY = MAX_INT256 / MAX_RATE
834     uint256 private constant MAX_SUPPLY = ~(uint256(1) << 255) / MAX_RATE;
835 
836     // This module orchestrates the rebase execution and downstream notification.
837     address public orchestrator;
838 
839     modifier onlyOrchestrator() {
840         require(msg.sender == orchestrator);
841         _;
842     }
843 
844     /**
845      * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
846      *
847      * @dev The supply adjustment equals (_totalSupply * DeviationFromTargetRate) / rebaseLag
848      *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
849      *      and targetRate is CpiOracleRate / baseCpi
850      */
851     function rebase() external onlyOrchestrator {
852         require(inRebaseWindow());
853 
854         // This comparison also ensures there is no reentrancy.
855         require(lastRebaseTimestampSec.add(minRebaseTimeIntervalSec) < now);
856 
857         // Snap the rebase time to the start of this window.
858         lastRebaseTimestampSec = now.sub(
859             now.mod(minRebaseTimeIntervalSec)).add(rebaseWindowOffsetSec);
860 
861         epoch = epoch.add(1);
862 
863         uint256 cpi;
864         bool cpiValid;
865         (cpi, cpiValid) = cpiOracle.getData();
866         require(cpiValid);
867 
868         uint256 targetRate = cpi.mul(10 ** DECIMALS).div(baseCpi);
869 
870         uint256 exchangeRate;
871         bool rateValid;
872         (exchangeRate, rateValid) = marketOracle.getData();
873         require(rateValid);
874 
875         if (exchangeRate > MAX_RATE) {
876             exchangeRate = MAX_RATE;
877         }
878 
879         int256 supplyDelta = computeSupplyDelta(exchangeRate, targetRate);
880 
881         // Apply the Dampening factor.
882         supplyDelta = supplyDelta.div(rebaseLag.toInt256Safe());
883 
884         if (supplyDelta > 0 && uFrags.totalSupply().add(uint256(supplyDelta)) > MAX_SUPPLY) {
885             supplyDelta = (MAX_SUPPLY.sub(uFrags.totalSupply())).toInt256Safe();
886         }
887 
888         uint256 supplyAfterRebase = uFrags.rebase(epoch, supplyDelta);
889         assert(supplyAfterRebase <= MAX_SUPPLY);
890         emit LogRebase(epoch, exchangeRate, cpi, supplyDelta, now);
891     }
892 
893     /**
894      * @notice Sets the reference to the CPI oracle.
895      * @param cpiOracle_ The address of the cpi oracle contract.
896      */
897     function setCpiOracle(IOracle cpiOracle_)
898         external
899         onlyOwner
900     {
901         cpiOracle = cpiOracle_;
902     }
903 
904     /**
905      * @notice Sets the reference to the market oracle.
906      * @param marketOracle_ The address of the market oracle contract.
907      */
908     function setMarketOracle(IOracle marketOracle_)
909         external
910         onlyOwner
911     {
912         marketOracle = marketOracle_;
913     }
914 
915     /**
916      * @notice Sets the reference to the orchestrator.
917      * @param orchestrator_ The address of the orchestrator contract.
918      */
919     function setOrchestrator(address orchestrator_)
920         external
921         onlyOwner
922     {
923         orchestrator = orchestrator_;
924     }
925 
926     /**
927      * @notice Sets the deviation threshold fraction. If the exchange rate given by the market
928      *         oracle is within this fractional distance from the targetRate, then no supply
929      *         modifications are made. DECIMALS fixed point number.
930      * @param deviationThreshold_ The new exchange rate threshold fraction.
931      */
932     function setDeviationThreshold(uint256 deviationThreshold_)
933         external
934         onlyOwner
935     {
936         deviationThreshold = deviationThreshold_;
937     }
938 
939     /**
940      * @notice Sets the rebase lag parameter.
941                It is used to dampen the applied supply adjustment by 1 / rebaseLag
942                If the rebase lag R, equals 1, the smallest value for R, then the full supply
943                correction is applied on each rebase cycle.
944                If it is greater than 1, then a correction of 1/R of is applied on each rebase.
945      * @param rebaseLag_ The new rebase lag parameter.
946      */
947     function setRebaseLag(uint256 rebaseLag_)
948         external
949         onlyOwner
950     {
951         require(rebaseLag_ > 0);
952         rebaseLag = rebaseLag_;
953     }
954 
955     /**
956      * @notice Sets the parameters which control the timing and frequency of
957      *         rebase operations.
958      *         a) the minimum time period that must elapse between rebase cycles.
959      *         b) the rebase window offset parameter.
960      *         c) the rebase window length parameter.
961      * @param minRebaseTimeIntervalSec_ More than this much time must pass between rebase
962      *        operations, in seconds.
963      * @param rebaseWindowOffsetSec_ The number of seconds from the beginning of
964               the rebase interval, where the rebase window begins.
965      * @param rebaseWindowLengthSec_ The length of the rebase window in seconds.
966      */
967     function setRebaseTimingParameters(
968         uint256 minRebaseTimeIntervalSec_,
969         uint256 rebaseWindowOffsetSec_,
970         uint256 rebaseWindowLengthSec_)
971         external
972         onlyOwner
973     {
974         require(minRebaseTimeIntervalSec_ > 0);
975         require(rebaseWindowOffsetSec_ < minRebaseTimeIntervalSec_);
976 
977         minRebaseTimeIntervalSec = minRebaseTimeIntervalSec_;
978         rebaseWindowOffsetSec = rebaseWindowOffsetSec_;
979         rebaseWindowLengthSec = rebaseWindowLengthSec_;
980     }
981 
982     /**
983      * @dev ZOS upgradable contract initialization method.
984      *      It is called at the time of contract creation to invoke parent class initializers and
985      *      initialize the contract's state variables.
986      */
987     function initialize(address owner_, UFragments uFrags_, uint256 baseCpi_)
988         public
989         initializer
990     {
991         Ownable.initialize(owner_);
992 
993         // deviationThreshold = 0.05e18 = 5e16
994         deviationThreshold = 5 * 10 ** (DECIMALS-2);
995 
996         rebaseLag = 30;
997         minRebaseTimeIntervalSec = 1 days;
998         rebaseWindowOffsetSec = 72000;  // 8PM UTC
999         rebaseWindowLengthSec = 15 minutes;
1000         lastRebaseTimestampSec = 0;
1001         epoch = 0;
1002 
1003         uFrags = uFrags_;
1004         baseCpi = baseCpi_;
1005     }
1006 
1007     /**
1008      * @return If the latest block timestamp is within the rebase time window it, returns true.
1009      *         Otherwise, returns false.
1010      */
1011     function inRebaseWindow() public view returns (bool) {
1012         return (
1013             now.mod(minRebaseTimeIntervalSec) >= rebaseWindowOffsetSec &&
1014             now.mod(minRebaseTimeIntervalSec) < (rebaseWindowOffsetSec.add(rebaseWindowLengthSec))
1015         );
1016     }
1017 
1018     /**
1019      * @return Computes the total supply adjustment in response to the exchange rate
1020      *         and the targetRate.
1021      */
1022     function computeSupplyDelta(uint256 rate, uint256 targetRate)
1023         private
1024         view
1025         returns (int256)
1026     {
1027         if (withinDeviationThreshold(rate, targetRate)) {
1028             return 0;
1029         }
1030 
1031         // supplyDelta = totalSupply * (rate - targetRate) / targetRate
1032         int256 targetRateSigned = targetRate.toInt256Safe();
1033         return uFrags.totalSupply().toInt256Safe()
1034             .mul(rate.toInt256Safe().sub(targetRateSigned))
1035             .div(targetRateSigned);
1036     }
1037 
1038     /**
1039      * @param rate The current exchange rate, an 18 decimal fixed point number.
1040      * @param targetRate The target exchange rate, an 18 decimal fixed point number.
1041      * @return If the rate is within the deviation threshold from the target rate, returns true.
1042      *         Otherwise, returns false.
1043      */
1044     function withinDeviationThreshold(uint256 rate, uint256 targetRate)
1045         private
1046         view
1047         returns (bool)
1048     {
1049         uint256 absoluteDeviationThreshold = targetRate.mul(deviationThreshold)
1050             .div(10 ** DECIMALS);
1051 
1052         return (rate >= targetRate && rate.sub(targetRate) < absoluteDeviationThreshold)
1053             || (rate < targetRate && targetRate.sub(rate) < absoluteDeviationThreshold);
1054     }
1055 }
1056 
1057 // File: contracts/Orchestrator.sol
1058 
1059 pragma solidity 0.4.24;
1060 
1061 
1062 
1063 
1064 /**
1065  * @title Orchestrator
1066  * @notice The orchestrator is the main entry point for rebase operations. It coordinates the policy
1067  * actions with external consumers.
1068  */
1069 contract Orchestrator is Ownable {
1070 
1071     struct Transaction {
1072         bool enabled;
1073         address destination;
1074         bytes data;
1075     }
1076 
1077     event TransactionFailed(address indexed destination, uint index, bytes data);
1078 
1079     // Stable ordering is not guaranteed.
1080     Transaction[] public transactions;
1081 
1082     UFragmentsPolicy public policy;
1083 
1084     /**
1085      * @param policy_ Address of the UFragments policy.
1086      */
1087     constructor(address policy_) public {
1088         Ownable.initialize(msg.sender);
1089         policy = UFragmentsPolicy(policy_);
1090     }
1091 
1092     /**
1093      * @notice Main entry point to initiate a rebase operation.
1094      *         The Orchestrator calls rebase on the policy and notifies downstream applications.
1095      *         Contracts are guarded from calling, to avoid flash loan attacks on liquidity
1096      *         providers.
1097      *         If a transaction in the transaction list reverts, it is swallowed and the remaining
1098      *         transactions are executed.
1099      */
1100     function rebase()
1101         external
1102     {
1103         require(msg.sender == tx.origin);  // solhint-disable-line avoid-tx-origin
1104 
1105         policy.rebase();
1106 
1107         for (uint i = 0; i < transactions.length; i++) {
1108             Transaction storage t = transactions[i];
1109             if (t.enabled) {
1110                 bool result =
1111                     externalCall(t.destination, t.data);
1112                 if (!result) {
1113                     emit TransactionFailed(t.destination, i, t.data);
1114                 }
1115             }
1116         }
1117     }
1118 
1119     /**
1120      * @notice Adds a transaction that gets called for a downstream receiver of rebases
1121      * @param destination Address of contract destination
1122      * @param data Transaction data payload
1123      */
1124     function addTransaction(address destination, bytes data)
1125         external
1126         onlyOwner
1127     {
1128         transactions.push(Transaction({
1129             enabled: true,
1130             destination: destination,
1131             data: data
1132         }));
1133     }
1134 
1135     /**
1136      * @param index Index of transaction to remove.
1137      *              Transaction ordering may have changed since adding.
1138      */
1139     function removeTransaction(uint index)
1140         external
1141         onlyOwner
1142     {
1143         require(index < transactions.length, "index out of bounds");
1144 
1145         if (index < transactions.length - 1) {
1146             transactions[index] = transactions[transactions.length - 1];
1147         }
1148 
1149         transactions.length--;
1150     }
1151 
1152     /**
1153      * @param index Index of transaction. Transaction ordering may have changed since adding.
1154      * @param enabled True for enabled, false for disabled.
1155      */
1156     function setTransactionEnabled(uint index, bool enabled)
1157         external
1158         onlyOwner
1159     {
1160         require(index < transactions.length, "index must be in range of stored tx list");
1161         transactions[index].enabled = enabled;
1162     }
1163 
1164     /**
1165      * @return Number of transactions, both enabled and disabled, in transactions list.
1166      */
1167     function transactionsSize()
1168         external
1169         view
1170         returns (uint256)
1171     {
1172         return transactions.length;
1173     }
1174 
1175     /**
1176      * @dev wrapper to call the encoded transactions on downstream consumers.
1177      * @param destination Address of destination contract.
1178      * @param data The encoded data payload.
1179      * @return True on success
1180      */
1181     function externalCall(address destination, bytes data)
1182         internal
1183         returns (bool)
1184     {
1185         bool result;
1186         assembly {  // solhint-disable-line no-inline-assembly
1187             // "Allocate" memory for output
1188             // (0x40 is where "free memory" pointer is stored by convention)
1189             let outputAddress := mload(0x40)
1190 
1191             // First 32 bytes are the padded length of data, so exclude that
1192             let dataAddress := add(data, 32)
1193 
1194             result := call(
1195                 // 34710 is the value that solidity is currently emitting
1196                 // It includes callGas (700) + callVeryLow (3, to pay for SUB)
1197                 // + callValueTransferGas (9000) + callNewAccountGas
1198                 // (25000, in case the destination address does not exist and needs creating)
1199                 sub(gas, 34710),
1200 
1201 
1202                 destination,
1203                 0, // transfer value in wei
1204                 dataAddress,
1205                 mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.
1206                 outputAddress,
1207                 0  // Output is ignored, therefore the output size is zero
1208             )
1209         }
1210         return result;
1211     }
1212 }