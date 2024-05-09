1 // Sources flattened with buidler v1.4.3 https://buidler.dev
2 
3 // File openzeppelin-eth/contracts/math/SafeMath.sol@v2.0.2
4 
5 pragma solidity ^0.4.24;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that revert on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, reverts on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (a == 0) {
22       return 0;
23     }
24 
25     uint256 c = a * b;
26     require(c / a == b);
27 
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b > 0); // Solidity only automatically asserts when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 
39     return c;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     require(b <= a);
47     uint256 c = a - b;
48 
49     return c;
50   }
51 
52   /**
53   * @dev Adds two numbers, reverts on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     require(c >= a);
58 
59     return c;
60   }
61 
62   /**
63   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
64   * reverts when dividing by zero.
65   */
66   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b != 0);
68     return a % b;
69   }
70 }
71 
72 
73 // File zos-lib/contracts/Initializable.sol@v2.1.0
74 
75 pragma solidity >=0.4.24 <0.6.0;
76 
77 
78 /**
79  * @title Initializable
80  *
81  * @dev Helper contract to support initializer functions. To use it, replace
82  * the constructor with a function that has the `initializer` modifier.
83  * WARNING: Unlike constructors, initializer functions must be manually
84  * invoked. This applies both to deploying an Initializable contract, as well
85  * as extending an Initializable contract via inheritance.
86  * WARNING: When used with inheritance, manual care must be taken to not invoke
87  * a parent initializer twice, or ensure that all initializers are idempotent,
88  * because this is not dealt with automatically as with constructors.
89  */
90 contract Initializable {
91 
92   /**
93    * @dev Indicates that the contract has been initialized.
94    */
95   bool private initialized;
96 
97   /**
98    * @dev Indicates that the contract is in the process of being initialized.
99    */
100   bool private initializing;
101 
102   /**
103    * @dev Modifier to use in the initializer function of a contract.
104    */
105   modifier initializer() {
106     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
107 
108     bool wasInitializing = initializing;
109     initializing = true;
110     initialized = true;
111 
112     _;
113 
114     initializing = wasInitializing;
115   }
116 
117   /// @dev Returns true if and only if the function is running in the constructor
118   function isConstructor() private view returns (bool) {
119     // extcodesize checks the size of the code stored in an address, and
120     // address returns the current address. Since the code is still not
121     // deployed when running a constructor, any checks on its code size will
122     // yield zero, making it an effective way to detect if a contract is
123     // under construction or not.
124     uint256 cs;
125     assembly { cs := extcodesize(address) }
126     return cs == 0;
127   }
128 
129   // Reserved storage space to allow for layout changes in the future.
130   uint256[50] private ______gap;
131 }
132 
133 
134 // File openzeppelin-eth/contracts/ownership/Ownable.sol@v2.0.2
135 
136 pragma solidity ^0.4.24;
137 
138 
139 /**
140  * @title Ownable
141  * @dev The Ownable contract has an owner address, and provides basic authorization control
142  * functions, this simplifies the implementation of "user permissions".
143  */
144 contract Ownable is Initializable {
145   address private _owner;
146 
147 
148   event OwnershipRenounced(address indexed previousOwner);
149   event OwnershipTransferred(
150     address indexed previousOwner,
151     address indexed newOwner
152   );
153 
154 
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   function initialize(address sender) public initializer {
160     _owner = sender;
161   }
162 
163   /**
164    * @return the address of the owner.
165    */
166   function owner() public view returns(address) {
167     return _owner;
168   }
169 
170   /**
171    * @dev Throws if called by any account other than the owner.
172    */
173   modifier onlyOwner() {
174     require(isOwner());
175     _;
176   }
177 
178   /**
179    * @return true if `msg.sender` is the owner of the contract.
180    */
181   function isOwner() public view returns(bool) {
182     return msg.sender == _owner;
183   }
184 
185   /**
186    * @dev Allows the current owner to relinquish control of the contract.
187    * @notice Renouncing to ownership will leave the contract without an owner.
188    * It will not be possible to call the functions with the `onlyOwner`
189    * modifier anymore.
190    */
191   function renounceOwnership() public onlyOwner {
192     emit OwnershipRenounced(_owner);
193     _owner = address(0);
194   }
195 
196   /**
197    * @dev Allows the current owner to transfer control of the contract to a newOwner.
198    * @param newOwner The address to transfer ownership to.
199    */
200   function transferOwnership(address newOwner) public onlyOwner {
201     _transferOwnership(newOwner);
202   }
203 
204   /**
205    * @dev Transfers control of the contract to a newOwner.
206    * @param newOwner The address to transfer ownership to.
207    */
208   function _transferOwnership(address newOwner) internal {
209     require(newOwner != address(0));
210     emit OwnershipTransferred(_owner, newOwner);
211     _owner = newOwner;
212   }
213 
214   uint256[50] private ______gap;
215 }
216 
217 
218 // File openzeppelin-eth/contracts/token/ERC20/IERC20.sol@v2.0.2
219 
220 pragma solidity ^0.4.24;
221 
222 
223 /**
224  * @title ERC20 interface
225  * @dev see https://github.com/ethereum/EIPs/issues/20
226  */
227 interface IERC20 {
228   function totalSupply() external view returns (uint256);
229 
230   function balanceOf(address who) external view returns (uint256);
231 
232   function allowance(address owner, address spender)
233     external view returns (uint256);
234 
235   function transfer(address to, uint256 value) external returns (bool);
236 
237   function approve(address spender, uint256 value)
238     external returns (bool);
239 
240   function transferFrom(address from, address to, uint256 value)
241     external returns (bool);
242 
243   event Transfer(
244     address indexed from,
245     address indexed to,
246     uint256 value
247   );
248 
249   event Approval(
250     address indexed owner,
251     address indexed spender,
252     uint256 value
253   );
254 }
255 
256 
257 // File openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol@v2.0.2
258 
259 pragma solidity ^0.4.24;
260 
261 
262 
263 
264 /**
265  * @title ERC20Detailed token
266  * @dev The decimals are only for visualization purposes.
267  * All the operations are done using the smallest and indivisible token unit,
268  * just as on Ethereum all the operations are done in wei.
269  */
270 contract ERC20Detailed is Initializable, IERC20 {
271   string private _name;
272   string private _symbol;
273   uint8 private _decimals;
274 
275   function initialize(string name, string symbol, uint8 decimals) public initializer {
276     _name = name;
277     _symbol = symbol;
278     _decimals = decimals;
279   }
280 
281   /**
282    * @return the name of the token.
283    */
284   function name() public view returns(string) {
285     return _name;
286   }
287 
288   /**
289    * @return the symbol of the token.
290    */
291   function symbol() public view returns(string) {
292     return _symbol;
293   }
294 
295   /**
296    * @return the number of decimals of the token.
297    */
298   function decimals() public view returns(uint8) {
299     return _decimals;
300   }
301 
302   uint256[50] private ______gap;
303 }
304 
305 
306 // File contracts/v4/lib/SafeMathInt.sol
307 
308 /*
309 MIT License
310 
311 Copyright (c) 2018 requestnetwork
312 Copyright (c) 2018 Fragments, Inc.
313 
314 Permission is hereby granted, free of charge, to any person obtaining a copy
315 of this software and associated documentation files (the "Software"), to deal
316 in the Software without restriction, including without limitation the rights
317 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
318 copies of the Software, and to permit persons to whom the Software is
319 furnished to do so, subject to the following conditions:
320 
321 The above copyright notice and this permission notice shall be included in all
322 copies or substantial portions of the Software.
323 
324 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
325 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
326 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
327 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
328 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
329 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
330 SOFTWARE.
331 */
332 
333 pragma solidity 0.4.24;
334 
335 
336 /**
337  * @title SafeMathInt
338  * @dev Math operations for int256 with overflow safety checks.
339  */
340 library SafeMathInt {
341     int256 private constant MIN_INT256 = int256(1) << 255;
342     int256 private constant MAX_INT256 = ~(int256(1) << 255);
343 
344     /**
345      * @dev Multiplies two int256 variables and fails on overflow.
346      */
347     function mul(int256 a, int256 b)
348         internal
349         pure
350         returns (int256)
351     {
352         int256 c = a * b;
353 
354         // Detect overflow when multiplying MIN_INT256 with -1
355         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
356         require((b == 0) || (c / b == a));
357         return c;
358     }
359 
360     /**
361      * @dev Division of two int256 variables and fails on overflow.
362      */
363     function div(int256 a, int256 b)
364         internal
365         pure
366         returns (int256)
367     {
368         // Prevent overflow when dividing MIN_INT256 by -1
369         require(b != -1 || a != MIN_INT256);
370 
371         // Solidity already throws when dividing by 0.
372         return a / b;
373     }
374 
375     /**
376      * @dev Subtracts two int256 variables and fails on overflow.
377      */
378     function sub(int256 a, int256 b)
379         internal
380         pure
381         returns (int256)
382     {
383         int256 c = a - b;
384         require((b >= 0 && c <= a) || (b < 0 && c > a));
385         return c;
386     }
387 
388     /**
389      * @dev Adds two int256 variables and fails on overflow.
390      */
391     function add(int256 a, int256 b)
392         internal
393         pure
394         returns (int256)
395     {
396         int256 c = a + b;
397         require((b >= 0 && c >= a) || (b < 0 && c < a));
398         return c;
399     }
400 
401     /**
402      * @dev Converts to absolute value, and fails on overflow.
403      */
404     function abs(int256 a)
405         internal
406         pure
407         returns (int256)
408     {
409         require(a != MIN_INT256);
410         return a < 0 ? -a : a;
411     }
412 }
413 
414 
415 // File contracts/v4/lib/UInt256Lib.sol
416 
417 pragma solidity 0.4.24;
418 
419 
420 /**
421  * @title Various utilities useful for uint256.
422  */
423 library UInt256Lib {
424 
425     uint256 private constant MAX_INT256 = ~(uint256(1) << 255);
426 
427     /**
428      * @dev Safely converts a uint256 to an int256.
429      */
430     function toInt256Safe(uint256 a)
431         internal
432         pure
433         returns (int256)
434     {
435         require(a <= MAX_INT256);
436         return int256(a);
437     }
438 }
439 
440 
441 // File contracts/v4/UFragments.sol
442 
443 pragma solidity 0.4.24;
444 
445 
446 
447 
448 
449 
450 /**
451  * @title uFragments ERC20 token
452  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
453  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
454  *      combining tokens proportionally across all wallets.
455  *
456  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
457  *      We support splitting the currency in expansion and combining the currency on contraction by
458  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
459  */
460 contract UFragments is ERC20Detailed, Ownable {
461     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
462     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
463     // order to minimize this risk, we adhere to the following guidelines:
464     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
465     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
466     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
467     //    multiplying by the inverse rate, you should divide by the normal rate)
468     // 2) Gon balances converted into Fragments are always rounded down (truncated).
469     //
470     // We make the following guarantees:
471     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
472     //   be decreased by precisely x Fragments, and B's external balance will be precisely
473     //   increased by x Fragments.
474     //
475     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
476     // This is because, for any conversion function 'f()' that has non-zero rounding error,
477     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
478     using SafeMath for uint256;
479     using SafeMathInt for int256;
480 
481     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
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
492     bool private rebasePausedDeprecated;
493     bool private tokenPausedDeprecated;
494 
495     modifier validRecipient(address to) {
496         require(to != address(0x0));
497         require(to != address(this));
498         _;
499     }
500 
501     uint256 private constant DECIMALS = 18;
502     uint256 private constant MAX_UINT256 = ~uint256(0);
503     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 100000 * uint(10)**DECIMALS;
504 
505     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
506     // Use the highest value that fits in a uint256 for max granularity.
507     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
508 
509     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
510     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
511 
512     uint256 private _totalSupply;
513     uint256 private _gonsPerFragment;
514     mapping(address => uint256) private _gonBalances;
515 
516     // This is denominated in Fragments, because the gons-fragments conversion might change before
517     // it's fully paid.
518     mapping (address => mapping (address => uint256)) private _allowedFragments;
519 
520     /**
521      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
522      */
523     function setMonetaryPolicy(address monetaryPolicy_)
524         external
525         onlyOwner
526     {
527         monetaryPolicy = monetaryPolicy_;
528         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
529     }
530 
531     /**
532      * @dev Notifies Fragments contract about a new rebase cycle.
533      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
534      * @return The total number of fragments after the supply adjustment.
535      */
536     function rebase(uint256 epoch, int256 supplyDelta)
537         external
538         onlyMonetaryPolicy
539         returns (uint256)
540     {
541         if (supplyDelta == 0) {
542             emit LogRebase(epoch, _totalSupply);
543             return _totalSupply;
544         }
545 
546         if (supplyDelta < 0) {
547             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
548         } else {
549             _totalSupply = _totalSupply.add(uint256(supplyDelta));
550         }
551 
552         if (_totalSupply > MAX_SUPPLY) {
553             _totalSupply = MAX_SUPPLY;
554         }
555 
556         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
557 
558         // From this point forward, _gonsPerFragment is taken as the source of truth.
559         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
560         // conversion rate.
561         // This means our applied supplyDelta can deviate from the requested supplyDelta,
562         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
563         //
564         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
565         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
566         // ever increased, it must be re-included.
567         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
568 
569         emit LogRebase(epoch, _totalSupply);
570         return _totalSupply;
571     }
572 
573     function initialize(address owner_, address pool0_, address pool1_, string name_, string symbol_)
574         public
575         initializer
576     {
577         ERC20Detailed.initialize(name_, symbol_, uint8(DECIMALS));
578         Ownable.initialize(owner_);
579 
580         rebasePausedDeprecated = false;
581         tokenPausedDeprecated = false;
582 
583         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
584         _gonBalances[pool0_] = TOTAL_GONS;
585         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
586 
587         uint256 value = 75000 * 10**DECIMALS;
588         uint256 gonValue = value.mul(_gonsPerFragment);
589         _gonBalances[pool0_] = _gonBalances[pool0_].sub(gonValue);
590         _gonBalances[pool1_] = _gonBalances[pool1_].add(gonValue);
591 
592         emit Transfer(address(0x0), pool0_, _totalSupply.sub(value));
593         emit Transfer(address(0x0), pool1_, value);
594     }
595 
596     /**
597      * @return The total number of fragments.
598      */
599     function totalSupply()
600         public
601         view
602         returns (uint256)
603     {
604         return _totalSupply;
605     }
606 
607     /**
608      * @param who The address to query.
609      * @return The balance of the specified address.
610      */
611     function balanceOf(address who)
612         public
613         view
614         returns (uint256)
615     {
616         return _gonBalances[who].div(_gonsPerFragment);
617     }
618 
619     /**
620      * @dev Transfer tokens to a specified address.
621      * @param to The address to transfer to.
622      * @param value The amount to be transferred.
623      * @return True on success, false otherwise.
624      */
625     function transfer(address to, uint256 value)
626         public
627         validRecipient(to)
628         returns (bool)
629     {
630         uint256 gonValue = value.mul(_gonsPerFragment);
631         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
632         _gonBalances[to] = _gonBalances[to].add(gonValue);
633         emit Transfer(msg.sender, to, value);
634         return true;
635     }
636 
637     /**
638      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
639      * @param owner_ The address which owns the funds.
640      * @param spender The address which will spend the funds.
641      * @return The number of tokens still available for the spender.
642      */
643     function allowance(address owner_, address spender)
644         public
645         view
646         returns (uint256)
647     {
648         return _allowedFragments[owner_][spender];
649     }
650 
651     /**
652      * @dev Transfer tokens from one address to another.
653      * @param from The address you want to send tokens from.
654      * @param to The address you want to transfer to.
655      * @param value The amount of tokens to be transferred.
656      */
657     function transferFrom(address from, address to, uint256 value)
658         public
659         validRecipient(to)
660         returns (bool)
661     {
662         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
663 
664         uint256 gonValue = value.mul(_gonsPerFragment);
665         _gonBalances[from] = _gonBalances[from].sub(gonValue);
666         _gonBalances[to] = _gonBalances[to].add(gonValue);
667         emit Transfer(from, to, value);
668 
669         return true;
670     }
671 
672     /**
673      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
674      * msg.sender. This method is included for ERC20 compatibility.
675      * increaseAllowance and decreaseAllowance should be used instead.
676      * Changing an allowance with this method brings the risk that someone may transfer both
677      * the old and the new allowance - if they are both greater than zero - if a transfer
678      * transaction is mined before the later approve() call is mined.
679      *
680      * @param spender The address which will spend the funds.
681      * @param value The amount of tokens to be spent.
682      */
683     function approve(address spender, uint256 value)
684         public
685         returns (bool)
686     {
687         _allowedFragments[msg.sender][spender] = value;
688         emit Approval(msg.sender, spender, value);
689         return true;
690     }
691 
692     /**
693      * @dev Increase the amount of tokens that an owner has allowed to a spender.
694      * This method should be used instead of approve() to avoid the double approval vulnerability
695      * described above.
696      * @param spender The address which will spend the funds.
697      * @param addedValue The amount of tokens to increase the allowance by.
698      */
699     function increaseAllowance(address spender, uint256 addedValue)
700         public
701         returns (bool)
702     {
703         _allowedFragments[msg.sender][spender] =
704             _allowedFragments[msg.sender][spender].add(addedValue);
705         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
706         return true;
707     }
708 
709     /**
710      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
711      *
712      * @param spender The address which will spend the funds.
713      * @param subtractedValue The amount of tokens to decrease the allowance by.
714      */
715     function decreaseAllowance(address spender, uint256 subtractedValue)
716         public
717         returns (bool)
718     {
719         uint256 oldValue = _allowedFragments[msg.sender][spender];
720         if (subtractedValue >= oldValue) {
721             _allowedFragments[msg.sender][spender] = 0;
722         } else {
723             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
724         }
725         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
726         return true;
727     }
728 }
729 
730 
731 // File contracts/v4/UFragmentsPolicy.sol
732 
733 pragma solidity 0.4.24;
734 
735 
736 
737 
738 
739 
740 
741 interface IOracle {
742     function getData() external returns (uint256, bool);
743 }
744 
745 
746 /**
747  * @title uFragments Monetary Supply Policy
748  * @dev This is an implementation of the uFragments Ideal Money protocol.
749  *      uFragments operates symmetrically on expansion and contraction. It will both split and
750  *      combine coins to maintain a stable unit price.
751  *
752  *      This component regulates the token supply of the uFragments ERC20 token in response to
753  *      market oracles.
754  */
755 contract UFragmentsPolicy is Ownable {
756     using SafeMath for uint256;
757     using SafeMathInt for int256;
758     using UInt256Lib for uint256;
759 
760     event LogRebase(
761         uint256 indexed epoch,
762         uint256 exchangeRate,
763         uint256 cpi,
764         int256 requestedSupplyAdjustment,
765         uint256 timestampSec
766     );
767 
768     UFragments public uFrags;
769 
770     // Provides the current CPI, as an 18 decimal fixed point number.
771     IOracle public cpiOracle;
772 
773     // Market oracle provides the token/USD exchange rate as an 18 decimal fixed point number.
774     // (eg) An oracle value of 1.5e18 it would mean 1 Ample is trading for $1.50.
775     IOracle public marketOracle;
776 
777     // CPI value at the time of launch, as an 18 decimal fixed point number.
778     uint256 private baseCpi;
779 
780     // If the current exchange rate is within this fractional distance from the target, no supply
781     // update is performed. Fixed point number--same format as the rate.
782     // (ie) abs(rate - targetRate) / targetRate < deviationThreshold, then no supply change.
783     // DECIMALS Fixed point number.
784     uint256 public deviationThreshold;
785 
786     // The rebase lag parameter, used to dampen the applied supply adjustment by 1 / rebaseLag
787     // Check setRebaseLag comments for more details.
788     // Natural number, no decimal places.
789     uint256 public rebaseLag;
790 
791     // More than this much time must pass between rebase operations.
792     uint256 public minRebaseTimeIntervalSec;
793 
794     // Block timestamp of last rebase operation
795     uint256 public lastRebaseTimestampSec;
796 
797     // The rebase window begins this many seconds into the minRebaseTimeInterval period.
798     // For example if minRebaseTimeInterval is 24hrs, it represents the time of day in seconds.
799     uint256 public rebaseWindowOffsetSec;
800 
801     // The length of the time window where a rebase operation is allowed to execute, in seconds.
802     uint256 public rebaseWindowLengthSec;
803 
804     // The number of rebase cycles since inception
805     uint256 public epoch;
806 
807     uint256 private constant DECIMALS = 18;
808 
809     // Due to the expression in computeSupplyDelta(), MAX_RATE * MAX_SUPPLY must fit into an int256.
810     // Both are 18 decimals fixed point numbers.
811     uint256 private constant MAX_RATE = 10**6 * 10**DECIMALS;
812     // MAX_SUPPLY = MAX_INT256 / MAX_RATE
813     uint256 private constant MAX_SUPPLY = ~(uint256(1) << 255) / MAX_RATE;
814 
815     // This module orchestrates the rebase execution and downstream notification.
816     address public orchestrator;
817 
818     address public deployer;
819 
820     modifier onlyOrchestrator() {
821         require(msg.sender == orchestrator);
822         _;
823     }
824 
825     modifier onlyDeployer() {
826         require(msg.sender == deployer);
827         _;
828     }
829 
830     /**
831      * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
832      *
833      * @dev The supply adjustment equals (_totalSupply * DeviationFromTargetRate) / rebaseLag
834      *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
835      *      and targetRate is CpiOracleRate / baseCpi
836      */
837     function rebase() external onlyOrchestrator {
838         require(inRebaseWindow());
839 
840         // This comparison also ensures there is no reentrancy.
841         require(lastRebaseTimestampSec.add(minRebaseTimeIntervalSec) < now);
842 
843         // Snap the rebase time to the start of this window.
844         lastRebaseTimestampSec = now.sub(
845             now.mod(minRebaseTimeIntervalSec)).add(rebaseWindowOffsetSec);
846 
847         epoch = epoch.add(1);
848 
849         uint256 cpi;
850         bool cpiValid;
851         (cpi, cpiValid) = cpiOracle.getData();
852         require(cpiValid);
853 
854         uint256 targetRate = cpi.mul(10 ** DECIMALS).div(baseCpi);
855 
856         uint256 exchangeRate;
857         bool rateValid;
858         (exchangeRate, rateValid) = marketOracle.getData();
859         require(rateValid);
860 
861         if (exchangeRate > MAX_RATE) {
862             exchangeRate = MAX_RATE;
863         }
864 
865         int256 supplyDelta = computeSupplyDelta(exchangeRate, targetRate);
866 
867         // Apply the Dampening factor.
868         supplyDelta = supplyDelta.div(rebaseLag.toInt256Safe());
869 
870         if (supplyDelta > 0 && uFrags.totalSupply().add(uint256(supplyDelta)) > MAX_SUPPLY) {
871             supplyDelta = (MAX_SUPPLY.sub(uFrags.totalSupply())).toInt256Safe();
872         }
873 
874         uint256 supplyAfterRebase = uFrags.rebase(epoch, supplyDelta);
875         assert(supplyAfterRebase <= MAX_SUPPLY);
876         emit LogRebase(epoch, exchangeRate, cpi, supplyDelta, now);
877     }
878 
879     /**
880      * @notice Sets the reference to the CPI oracle.
881      * @param cpiOracle_ The address of the cpi oracle contract.
882      */
883     function setCpiOracle(IOracle cpiOracle_)
884         external
885         onlyDeployer
886     {
887         // can be set only once
888         require(cpiOracle == address(0));
889         cpiOracle = cpiOracle_;
890     }
891 
892     /**
893      * @notice Sets the reference to the market oracle.
894      * @param marketOracle_ The address of the market oracle contract.
895      */
896     function setMarketOracle(IOracle marketOracle_)
897         external
898         onlyDeployer
899     {
900         // can be set only once
901         require(marketOracle == address(0));
902         marketOracle = marketOracle_;
903     }
904 
905     /**
906      * @notice Sets the reference to the orchestrator.
907      * @param orchestrator_ The address of the orchestrator contract.
908      */
909     function setOrchestrator(address orchestrator_)
910         external
911         onlyOwner
912     {
913         orchestrator = orchestrator_;
914     }
915 
916     /**
917      * @notice Sets the deviation threshold fraction. If the exchange rate given by the market
918      *         oracle is within this fractional distance from the targetRate, then no supply
919      *         modifications are made. DECIMALS fixed point number.
920      * @param deviationThreshold_ The new exchange rate threshold fraction.
921      */
922     function setDeviationThreshold(uint256 deviationThreshold_)
923         external
924         onlyOwner
925     {
926         deviationThreshold = deviationThreshold_;
927     }
928 
929     /**
930      * @notice Sets the rebase lag parameter.
931                It is used to dampen the applied supply adjustment by 1 / rebaseLag
932                If the rebase lag R, equals 1, the smallest value for R, then the full supply
933                correction is applied on each rebase cycle.
934                If it is greater than 1, then a correction of 1/R of is applied on each rebase.
935      * @param rebaseLag_ The new rebase lag parameter.
936      */
937     function setRebaseLag(uint256 rebaseLag_)
938         external
939         onlyOwner
940     {
941         require(rebaseLag_ > 0);
942         rebaseLag = rebaseLag_;
943     }
944 
945     /**
946      * @notice Sets the parameters which control the timing and frequency of
947      *         rebase operations.
948      *         a) the minimum time period that must elapse between rebase cycles.
949      *         b) the rebase window offset parameter.
950      *         c) the rebase window length parameter.
951      * @param minRebaseTimeIntervalSec_ More than this much time must pass between rebase
952      *        operations, in seconds.
953      * @param rebaseWindowOffsetSec_ The number of seconds from the beginning of
954               the rebase interval, where the rebase window begins.
955      * @param rebaseWindowLengthSec_ The length of the rebase window in seconds.
956      */
957     function setRebaseTimingParameters(
958         uint256 minRebaseTimeIntervalSec_,
959         uint256 rebaseWindowOffsetSec_,
960         uint256 rebaseWindowLengthSec_)
961         external
962         onlyOwner
963     {
964         require(minRebaseTimeIntervalSec_ > 0);
965         require(rebaseWindowOffsetSec_ < minRebaseTimeIntervalSec_);
966 
967         minRebaseTimeIntervalSec = minRebaseTimeIntervalSec_;
968         rebaseWindowOffsetSec = rebaseWindowOffsetSec_;
969         rebaseWindowLengthSec = rebaseWindowLengthSec_;
970     }
971 
972     /**
973      * @dev ZOS upgradable contract initialization method.
974      *      It is called at the time of contract creation to invoke parent class initializers and
975      *      initialize the contract's state variables.
976      */
977     function initialize(address owner_, UFragments uFrags_, uint256 baseCpi_)
978         public
979         initializer
980     {
981         Ownable.initialize(owner_);
982         deployer = msg.sender;
983 
984         // deviationThreshold = 0.05e18 = 5e16
985         deviationThreshold = 5 * 10 ** (DECIMALS-2);
986 
987         rebaseLag = 30;
988         minRebaseTimeIntervalSec = 1 days;
989         rebaseWindowOffsetSec = 72000;  // 8PM UTC
990         rebaseWindowLengthSec = 15 minutes;
991         lastRebaseTimestampSec = 0;
992         epoch = 0;
993 
994         uFrags = uFrags_;
995         baseCpi = baseCpi_;
996     }
997 
998     /**
999      * @return If the latest block timestamp is within the rebase time window it, returns true.
1000      *         Otherwise, returns false.
1001      */
1002     function inRebaseWindow() public view returns (bool) {
1003         return (
1004             now.mod(minRebaseTimeIntervalSec) >= rebaseWindowOffsetSec &&
1005             now.mod(minRebaseTimeIntervalSec) < (rebaseWindowOffsetSec.add(rebaseWindowLengthSec))
1006         );
1007     }
1008 
1009     /**
1010      * @return Computes the total supply adjustment in response to the exchange rate
1011      *         and the targetRate.
1012      */
1013     function computeSupplyDelta(uint256 rate, uint256 targetRate)
1014         private
1015         view
1016         returns (int256)
1017     {
1018         if (withinDeviationThreshold(rate, targetRate)) {
1019             return 0;
1020         }
1021 
1022         // supplyDelta = totalSupply * (rate - targetRate) / targetRate
1023         int256 targetRateSigned = targetRate.toInt256Safe();
1024         return uFrags.totalSupply().toInt256Safe()
1025             .mul(rate.toInt256Safe().sub(targetRateSigned))
1026             .div(targetRateSigned);
1027     }
1028 
1029     /**
1030      * @param rate The current exchange rate, an 18 decimal fixed point number.
1031      * @param targetRate The target exchange rate, an 18 decimal fixed point number.
1032      * @return If the rate is within the deviation threshold from the target rate, returns true.
1033      *         Otherwise, returns false.
1034      */
1035     function withinDeviationThreshold(uint256 rate, uint256 targetRate)
1036         private
1037         view
1038         returns (bool)
1039     {
1040         uint256 absoluteDeviationThreshold = targetRate.mul(deviationThreshold)
1041             .div(10 ** DECIMALS);
1042 
1043         return (rate >= targetRate && rate.sub(targetRate) < absoluteDeviationThreshold)
1044             || (rate < targetRate && targetRate.sub(rate) < absoluteDeviationThreshold);
1045     }
1046 }
1047 
1048 
1049 // File contracts/v4/YearnRewardsI.sol
1050 
1051 pragma solidity 0.4.24;
1052 
1053 interface YearnRewardsI {
1054     function starttime() external returns (uint256);
1055     function totalRewards() external returns (uint256);
1056 }
1057 
1058 
1059 // File contracts/v4/Orchestrator.sol
1060 
1061 pragma solidity 0.4.24;
1062 
1063 
1064 
1065 
1066 
1067 
1068 /**
1069  * @title Orchestrator
1070  * @notice The orchestrator is the main entry point for rebase operations. It coordinates the policy
1071  * actions with external consumers.
1072  */
1073 contract Orchestrator is Ownable {
1074     using SafeMath for uint256;
1075 
1076     struct Transaction {
1077         bool enabled;
1078         address destination;
1079         bytes data;
1080     }
1081 
1082     event TransactionFailed(address indexed destination, uint index, bytes data);
1083 
1084     // Stable ordering is not guaranteed.
1085     Transaction[] public transactions;
1086 
1087     UFragmentsPolicy public policy;
1088     YearnRewardsI public pool0;
1089     YearnRewardsI public pool1;
1090     ERC20Detailed public based;
1091     address public deployer;
1092     uint256 public rebaseRequiredSupply;
1093 
1094     constructor () public {
1095         deployer = msg.sender;
1096     }
1097     /**
1098      * @param policy_ Address of the UFragments policy.
1099      * @param pool0_ Address of the YearnRewards pool0.
1100      * @param pool1_ Address of the YearnRewards pool1.
1101      * @param based_ Address of the Based token.
1102      */
1103     function initialize(address policy_, address pool0_, address pool1_, address based_, uint256 rebaseRequiredSupply_) public initializer {
1104         // only deployer can initialize
1105         require(deployer == msg.sender);
1106 
1107         Ownable.initialize(msg.sender);
1108         policy = UFragmentsPolicy(policy_);
1109         pool0 = YearnRewardsI(pool0_);
1110         pool1 = YearnRewardsI(pool1_);
1111         based = ERC20Detailed(based_);
1112         rebaseRequiredSupply = rebaseRequiredSupply_;
1113     }
1114 
1115     /**
1116      * @notice Main entry point to initiate a rebase operation.
1117      *         The Orchestrator calls rebase on the policy and notifies downstream applications.
1118      *         Contracts are guarded from calling, to avoid flash loan attacks on liquidity
1119      *         providers.
1120      *         If a transaction in the transaction list reverts, it is swallowed and the remaining
1121      *         transactions are executed.
1122      */
1123     function rebase()
1124         external
1125     {
1126         // wait for `rebaseRequiredSupply` token supply to be rewarded until rebase is possible
1127         // timeout after 4 weeks if people don't claim rewards so it's not stuck
1128         uint256 rewardsDistributed = pool0.totalRewards().add(pool1.totalRewards());
1129         require(rewardsDistributed >= rebaseRequiredSupply || block.timestamp >= pool0.starttime() + 4 weeks);
1130 
1131         require(msg.sender == tx.origin);  // solhint-disable-line avoid-tx-origin
1132 
1133         policy.rebase();
1134 
1135         for (uint i = 0; i < transactions.length; i++) {
1136             Transaction storage t = transactions[i];
1137             if (t.enabled) {
1138                 bool result =
1139                     externalCall(t.destination, t.data);
1140                 if (!result) {
1141                     emit TransactionFailed(t.destination, i, t.data);
1142                     revert("Transaction Failed");
1143                 }
1144             }
1145         }
1146     }
1147 
1148     /**
1149      * @notice Adds a transaction that gets called for a downstream receiver of rebases
1150      * @param destination Address of contract destination
1151      * @param data Transaction data payload
1152      */
1153     function addTransaction(address destination, bytes data)
1154         external
1155         onlyOwner
1156     {
1157         transactions.push(Transaction({
1158             enabled: true,
1159             destination: destination,
1160             data: data
1161         }));
1162     }
1163 
1164     /**
1165      * @param index Index of transaction to remove.
1166      *              Transaction ordering may have changed since adding.
1167      */
1168     function removeTransaction(uint index)
1169         external
1170         onlyOwner
1171     {
1172         require(index < transactions.length, "index out of bounds");
1173 
1174         if (index < transactions.length - 1) {
1175             transactions[index] = transactions[transactions.length - 1];
1176         }
1177 
1178         transactions.length--;
1179     }
1180 
1181     /**
1182      * @param index Index of transaction. Transaction ordering may have changed since adding.
1183      * @param enabled True for enabled, false for disabled.
1184      */
1185     function setTransactionEnabled(uint index, bool enabled)
1186         external
1187         onlyOwner
1188     {
1189         require(index < transactions.length, "index must be in range of stored tx list");
1190         transactions[index].enabled = enabled;
1191     }
1192 
1193     /**
1194      * @return Number of transactions, both enabled and disabled, in transactions list.
1195      */
1196     function transactionsSize()
1197         external
1198         view
1199         returns (uint256)
1200     {
1201         return transactions.length;
1202     }
1203 
1204     /**
1205      * @dev wrapper to call the encoded transactions on downstream consumers.
1206      * @param destination Address of destination contract.
1207      * @param data The encoded data payload.
1208      * @return True on success
1209      */
1210     function externalCall(address destination, bytes data)
1211         internal
1212         returns (bool)
1213     {
1214         bool result;
1215         assembly {  // solhint-disable-line no-inline-assembly
1216             // "Allocate" memory for output
1217             // (0x40 is where "free memory" pointer is stored by convention)
1218             let outputAddress := mload(0x40)
1219 
1220             // First 32 bytes are the padded length of data, so exclude that
1221             let dataAddress := add(data, 32)
1222 
1223             result := call(
1224                 // 34710 is the value that solidity is currently emitting
1225                 // It includes callGas (700) + callVeryLow (3, to pay for SUB)
1226                 // + callValueTransferGas (9000) + callNewAccountGas
1227                 // (25000, in case the destination address does not exist and needs creating)
1228                 sub(gas, 34710),
1229 
1230 
1231                 destination,
1232                 0, // transfer value in wei
1233                 dataAddress,
1234                 mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.
1235                 outputAddress,
1236                 0  // Output is ignored, therefore the output size is zero
1237             )
1238         }
1239         return result;
1240     }
1241 }