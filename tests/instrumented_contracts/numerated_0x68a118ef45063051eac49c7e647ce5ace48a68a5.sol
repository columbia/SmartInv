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
73 // File contracts/v4/lib/SafeMathInt.sol
74 
75 /*
76 MIT License
77 
78 Copyright (c) 2018 requestnetwork
79 Copyright (c) 2018 Fragments, Inc.
80 
81 Permission is hereby granted, free of charge, to any person obtaining a copy
82 of this software and associated documentation files (the "Software"), to deal
83 in the Software without restriction, including without limitation the rights
84 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
85 copies of the Software, and to permit persons to whom the Software is
86 furnished to do so, subject to the following conditions:
87 
88 The above copyright notice and this permission notice shall be included in all
89 copies or substantial portions of the Software.
90 
91 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
92 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
93 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
94 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
95 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
96 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
97 SOFTWARE.
98 */
99 
100 pragma solidity 0.4.24;
101 
102 
103 /**
104  * @title SafeMathInt
105  * @dev Math operations for int256 with overflow safety checks.
106  */
107 library SafeMathInt {
108     int256 private constant MIN_INT256 = int256(1) << 255;
109     int256 private constant MAX_INT256 = ~(int256(1) << 255);
110 
111     /**
112      * @dev Multiplies two int256 variables and fails on overflow.
113      */
114     function mul(int256 a, int256 b)
115         internal
116         pure
117         returns (int256)
118     {
119         int256 c = a * b;
120 
121         // Detect overflow when multiplying MIN_INT256 with -1
122         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
123         require((b == 0) || (c / b == a));
124         return c;
125     }
126 
127     /**
128      * @dev Division of two int256 variables and fails on overflow.
129      */
130     function div(int256 a, int256 b)
131         internal
132         pure
133         returns (int256)
134     {
135         // Prevent overflow when dividing MIN_INT256 by -1
136         require(b != -1 || a != MIN_INT256);
137 
138         // Solidity already throws when dividing by 0.
139         return a / b;
140     }
141 
142     /**
143      * @dev Subtracts two int256 variables and fails on overflow.
144      */
145     function sub(int256 a, int256 b)
146         internal
147         pure
148         returns (int256)
149     {
150         int256 c = a - b;
151         require((b >= 0 && c <= a) || (b < 0 && c > a));
152         return c;
153     }
154 
155     /**
156      * @dev Adds two int256 variables and fails on overflow.
157      */
158     function add(int256 a, int256 b)
159         internal
160         pure
161         returns (int256)
162     {
163         int256 c = a + b;
164         require((b >= 0 && c >= a) || (b < 0 && c < a));
165         return c;
166     }
167 
168     /**
169      * @dev Converts to absolute value, and fails on overflow.
170      */
171     function abs(int256 a)
172         internal
173         pure
174         returns (int256)
175     {
176         require(a != MIN_INT256);
177         return a < 0 ? -a : a;
178     }
179 }
180 
181 
182 // File contracts/v4/lib/UInt256Lib.sol
183 
184 pragma solidity 0.4.24;
185 
186 
187 /**
188  * @title Various utilities useful for uint256.
189  */
190 library UInt256Lib {
191 
192     uint256 private constant MAX_INT256 = ~(uint256(1) << 255);
193 
194     /**
195      * @dev Safely converts a uint256 to an int256.
196      */
197     function toInt256Safe(uint256 a)
198         internal
199         pure
200         returns (int256)
201     {
202         require(a <= MAX_INT256);
203         return int256(a);
204     }
205 }
206 
207 
208 // File zos-lib/contracts/Initializable.sol@v2.1.0
209 
210 pragma solidity >=0.4.24 <0.6.0;
211 
212 
213 /**
214  * @title Initializable
215  *
216  * @dev Helper contract to support initializer functions. To use it, replace
217  * the constructor with a function that has the `initializer` modifier.
218  * WARNING: Unlike constructors, initializer functions must be manually
219  * invoked. This applies both to deploying an Initializable contract, as well
220  * as extending an Initializable contract via inheritance.
221  * WARNING: When used with inheritance, manual care must be taken to not invoke
222  * a parent initializer twice, or ensure that all initializers are idempotent,
223  * because this is not dealt with automatically as with constructors.
224  */
225 contract Initializable {
226 
227   /**
228    * @dev Indicates that the contract has been initialized.
229    */
230   bool private initialized;
231 
232   /**
233    * @dev Indicates that the contract is in the process of being initialized.
234    */
235   bool private initializing;
236 
237   /**
238    * @dev Modifier to use in the initializer function of a contract.
239    */
240   modifier initializer() {
241     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
242 
243     bool wasInitializing = initializing;
244     initializing = true;
245     initialized = true;
246 
247     _;
248 
249     initializing = wasInitializing;
250   }
251 
252   /// @dev Returns true if and only if the function is running in the constructor
253   function isConstructor() private view returns (bool) {
254     // extcodesize checks the size of the code stored in an address, and
255     // address returns the current address. Since the code is still not
256     // deployed when running a constructor, any checks on its code size will
257     // yield zero, making it an effective way to detect if a contract is
258     // under construction or not.
259     uint256 cs;
260     assembly { cs := extcodesize(address) }
261     return cs == 0;
262   }
263 
264   // Reserved storage space to allow for layout changes in the future.
265   uint256[50] private ______gap;
266 }
267 
268 
269 // File contracts/v4/openzeppelin-eth/Ownable.sol
270 
271 pragma solidity ^0.4.24;
272 
273 
274 /**
275  * @title Ownable
276  * @dev The Ownable contract has an owner address, and provides basic authorization control
277  * functions, this simplifies the implementation of "user permissions".
278  */
279 contract Ownable is Initializable {
280   address private _owner;
281 
282 
283   event OwnershipRenounced(address indexed previousOwner);
284   event OwnershipTransferred(
285     address indexed previousOwner,
286     address indexed newOwner
287   );
288 
289 
290   /**
291    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
292    * account.
293    */
294   function initialize(address sender) internal initializer {
295     _owner = sender;
296   }
297 
298   /**
299    * @return the address of the owner.
300    */
301   function owner() public view returns(address) {
302     return _owner;
303   }
304 
305   /**
306    * @dev Throws if called by any account other than the owner.
307    */
308   modifier onlyOwner() {
309     require(isOwner());
310     _;
311   }
312 
313   /**
314    * @return true if `msg.sender` is the owner of the contract.
315    */
316   function isOwner() public view returns(bool) {
317     return msg.sender == _owner;
318   }
319 
320   /**
321    * @dev Allows the current owner to relinquish control of the contract.
322    * @notice Renouncing to ownership will leave the contract without an owner.
323    * It will not be possible to call the functions with the `onlyOwner`
324    * modifier anymore.
325    */
326   function renounceOwnership() public onlyOwner {
327     emit OwnershipRenounced(_owner);
328     _owner = address(0);
329   }
330 
331   /**
332    * @dev Allows the current owner to transfer control of the contract to a newOwner.
333    * @param newOwner The address to transfer ownership to.
334    */
335   function transferOwnership(address newOwner) public onlyOwner {
336     _transferOwnership(newOwner);
337   }
338 
339   /**
340    * @dev Transfers control of the contract to a newOwner.
341    * @param newOwner The address to transfer ownership to.
342    */
343   function _transferOwnership(address newOwner) internal {
344     require(newOwner != address(0));
345     emit OwnershipTransferred(_owner, newOwner);
346     _owner = newOwner;
347   }
348 
349   uint256[50] private ______gap;
350 }
351 
352 
353 // File contracts/v4/openzeppelin-eth/IERC20.sol
354 
355 pragma solidity ^0.4.24;
356 
357 
358 /**
359  * @title ERC20 interface
360  * @dev see https://github.com/ethereum/EIPs/issues/20
361  */
362 interface IERC20 {
363   function totalSupply() external view returns (uint256);
364 
365   function balanceOf(address who) external view returns (uint256);
366 
367   function allowance(address owner, address spender)
368     external view returns (uint256);
369 
370   function transfer(address to, uint256 value) external returns (bool);
371 
372   function approve(address spender, uint256 value)
373     external returns (bool);
374 
375   function transferFrom(address from, address to, uint256 value)
376     external returns (bool);
377 
378   event Transfer(
379     address indexed from,
380     address indexed to,
381     uint256 value
382   );
383 
384   event Approval(
385     address indexed owner,
386     address indexed spender,
387     uint256 value
388   );
389 }
390 
391 
392 // File contracts/v4/openzeppelin-eth/ERC20Detailed.sol
393 
394 pragma solidity ^0.4.24;
395 
396 
397 
398 
399 /**
400  * @title ERC20Detailed token
401  * @dev The decimals are only for visualization purposes.
402  * All the operations are done using the smallest and indivisible token unit,
403  * just as on Ethereum all the operations are done in wei.
404  */
405 contract ERC20Detailed is Initializable, IERC20 {
406   string private _name;
407   string private _symbol;
408   uint8 private _decimals;
409 
410   function initialize(string name, string symbol, uint8 decimals) internal initializer {
411     _name = name;
412     _symbol = symbol;
413     _decimals = decimals;
414   }
415 
416   /**
417    * @return the name of the token.
418    */
419   function name() public view returns(string) {
420     return _name;
421   }
422 
423   /**
424    * @return the symbol of the token.
425    */
426   function symbol() public view returns(string) {
427     return _symbol;
428   }
429 
430   /**
431    * @return the number of decimals of the token.
432    */
433   function decimals() public view returns(uint8) {
434     return _decimals;
435   }
436 
437   uint256[50] private ______gap;
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
520     address public deployer;
521 
522     modifier onlyDeployer() {
523         require(msg.sender == deployer);
524         _;
525     }
526 
527     constructor () public {
528         deployer = msg.sender;
529     }
530     /**
531      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
532      */
533     function setMonetaryPolicy(address monetaryPolicy_)
534         external
535         onlyOwner
536     {
537         monetaryPolicy = monetaryPolicy_;
538         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
539     }
540 
541     /**
542      * @dev Notifies Fragments contract about a new rebase cycle.
543      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
544      * @return The total number of fragments after the supply adjustment.
545      */
546     function rebase(uint256 epoch, int256 supplyDelta)
547         external
548         onlyMonetaryPolicy
549         returns (uint256)
550     {
551         if (supplyDelta == 0) {
552             emit LogRebase(epoch, _totalSupply);
553             return _totalSupply;
554         }
555 
556         if (supplyDelta < 0) {
557             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
558         } else {
559             _totalSupply = _totalSupply.add(uint256(supplyDelta));
560         }
561 
562         if (_totalSupply > MAX_SUPPLY) {
563             _totalSupply = MAX_SUPPLY;
564         }
565 
566         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
567 
568         // From this point forward, _gonsPerFragment is taken as the source of truth.
569         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
570         // conversion rate.
571         // This means our applied supplyDelta can deviate from the requested supplyDelta,
572         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
573         //
574         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
575         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
576         // ever increased, it must be re-included.
577         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
578 
579         emit LogRebase(epoch, _totalSupply);
580         return _totalSupply;
581     }
582 
583     // deliberately changing function signature to prevent accidental v1 deploy script reuse
584     function initialize(string name_, string symbol_, address owner_, address migrator_, address pool1_)
585         public
586         onlyDeployer
587         initializer
588     {
589         ERC20Detailed.initialize(name_, symbol_, uint8(DECIMALS));
590         Ownable.initialize(owner_);
591 
592         rebasePausedDeprecated = false;
593         tokenPausedDeprecated = false;
594 
595         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
596         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
597 
598         uint256 pool1Val = 75000 * (10 ** DECIMALS);
599         uint256 pool1Gons = pool1Val.mul(_gonsPerFragment);
600 
601         _gonBalances[migrator_] = TOTAL_GONS.sub(pool1Gons);
602         _gonBalances[pool1_] = pool1Gons;
603 
604         emit Transfer(address(0x0), migrator_, _totalSupply.sub(pool1Val));
605         emit Transfer(address(0x0), pool1_, pool1Val);
606     }
607 
608     /**
609      * @return The total number of fragments.
610      */
611     function totalSupply()
612         public
613         view
614         returns (uint256)
615     {
616         return _totalSupply;
617     }
618 
619     /**
620      * @param who The address to query.
621      * @return The balance of the specified address.
622      */
623     function balanceOf(address who)
624         public
625         view
626         returns (uint256)
627     {
628         return _gonBalances[who].div(_gonsPerFragment);
629     }
630 
631     /**
632      * @dev Transfer tokens to a specified address.
633      * @param to The address to transfer to.
634      * @param value The amount to be transferred.
635      * @return True on success, false otherwise.
636      */
637     function transfer(address to, uint256 value)
638         public
639         validRecipient(to)
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
669     function transferFrom(address from, address to, uint256 value)
670         public
671         validRecipient(to)
672         returns (bool)
673     {
674         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
675 
676         uint256 gonValue = value.mul(_gonsPerFragment);
677         _gonBalances[from] = _gonBalances[from].sub(gonValue);
678         _gonBalances[to] = _gonBalances[to].add(gonValue);
679         emit Transfer(from, to, value);
680 
681         return true;
682     }
683 
684     /**
685      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
686      * msg.sender. This method is included for ERC20 compatibility.
687      * increaseAllowance and decreaseAllowance should be used instead.
688      * Changing an allowance with this method brings the risk that someone may transfer both
689      * the old and the new allowance - if they are both greater than zero - if a transfer
690      * transaction is mined before the later approve() call is mined.
691      *
692      * @param spender The address which will spend the funds.
693      * @param value The amount of tokens to be spent.
694      */
695     function approve(address spender, uint256 value)
696         public
697         returns (bool)
698     {
699         _allowedFragments[msg.sender][spender] = value;
700         emit Approval(msg.sender, spender, value);
701         return true;
702     }
703 
704     /**
705      * @dev Increase the amount of tokens that an owner has allowed to a spender.
706      * This method should be used instead of approve() to avoid the double approval vulnerability
707      * described above.
708      * @param spender The address which will spend the funds.
709      * @param addedValue The amount of tokens to increase the allowance by.
710      */
711     function increaseAllowance(address spender, uint256 addedValue)
712         public
713         returns (bool)
714     {
715         _allowedFragments[msg.sender][spender] =
716             _allowedFragments[msg.sender][spender].add(addedValue);
717         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
718         return true;
719     }
720 
721     /**
722      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
723      *
724      * @param spender The address which will spend the funds.
725      * @param subtractedValue The amount of tokens to decrease the allowance by.
726      */
727     function decreaseAllowance(address spender, uint256 subtractedValue)
728         public
729         returns (bool)
730     {
731         uint256 oldValue = _allowedFragments[msg.sender][spender];
732         if (subtractedValue >= oldValue) {
733             _allowedFragments[msg.sender][spender] = 0;
734         } else {
735             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
736         }
737         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
738         return true;
739     }
740 }