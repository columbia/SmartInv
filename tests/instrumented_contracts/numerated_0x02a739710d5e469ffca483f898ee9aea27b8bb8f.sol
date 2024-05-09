1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 
70 // File contracts/v4/lib/SafeMathInt.sol
71 
72 /*
73 MIT License
74 
75 Copyright (c) 2018 requestnetwork
76 Copyright (c) 2018 Fragments, Inc.
77 
78 Permission is hereby granted, free of charge, to any person obtaining a copy
79 of this software and associated documentation files (the "Software"), to deal
80 in the Software without restriction, including without limitation the rights
81 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
82 copies of the Software, and to permit persons to whom the Software is
83 furnished to do so, subject to the following conditions:
84 
85 The above copyright notice and this permission notice shall be included in all
86 copies or substantial portions of the Software.
87 
88 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
89 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
90 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
91 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
92 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
93 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
94 SOFTWARE.
95 */
96 
97 pragma solidity 0.4.24;
98 
99 
100 /**
101  * @title SafeMathInt
102  * @dev Math operations for int256 with overflow safety checks.
103  */
104 library SafeMathInt {
105     int256 private constant MIN_INT256 = int256(1) << 255;
106     int256 private constant MAX_INT256 = ~(int256(1) << 255);
107 
108     /**
109      * @dev Multiplies two int256 variables and fails on overflow.
110      */
111     function mul(int256 a, int256 b)
112         internal
113         pure
114         returns (int256)
115     {
116         int256 c = a * b;
117 
118         // Detect overflow when multiplying MIN_INT256 with -1
119         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
120         require((b == 0) || (c / b == a));
121         return c;
122     }
123 
124     /**
125      * @dev Division of two int256 variables and fails on overflow.
126      */
127     function div(int256 a, int256 b)
128         internal
129         pure
130         returns (int256)
131     {
132         // Prevent overflow when dividing MIN_INT256 by -1
133         require(b != -1 || a != MIN_INT256);
134 
135         // Solidity already throws when dividing by 0.
136         return a / b;
137     }
138 
139     /**
140      * @dev Subtracts two int256 variables and fails on overflow.
141      */
142     function sub(int256 a, int256 b)
143         internal
144         pure
145         returns (int256)
146     {
147         int256 c = a - b;
148         require((b >= 0 && c <= a) || (b < 0 && c > a));
149         return c;
150     }
151 
152     /**
153      * @dev Adds two int256 variables and fails on overflow.
154      */
155     function add(int256 a, int256 b)
156         internal
157         pure
158         returns (int256)
159     {
160         int256 c = a + b;
161         require((b >= 0 && c >= a) || (b < 0 && c < a));
162         return c;
163     }
164 
165     /**
166      * @dev Converts to absolute value, and fails on overflow.
167      */
168     function abs(int256 a)
169         internal
170         pure
171         returns (int256)
172     {
173         require(a != MIN_INT256);
174         return a < 0 ? -a : a;
175     }
176 }
177 
178 
179 // File contracts/v4/lib/UInt256Lib.sol
180 
181 pragma solidity 0.4.24;
182 
183 
184 /**
185  * @title Various utilities useful for uint256.
186  */
187 library UInt256Lib {
188 
189     uint256 private constant MAX_INT256 = ~(uint256(1) << 255);
190 
191     /**
192      * @dev Safely converts a uint256 to an int256.
193      */
194     function toInt256Safe(uint256 a)
195         internal
196         pure
197         returns (int256)
198     {
199         require(a <= MAX_INT256);
200         return int256(a);
201     }
202 }
203 
204 
205 // File zos-lib/contracts/Initializable.sol@v2.1.0
206 
207 pragma solidity >=0.4.24 <0.6.0;
208 
209 
210 /**
211  * @title Initializable
212  *
213  * @dev Helper contract to support initializer functions. To use it, replace
214  * the constructor with a function that has the `initializer` modifier.
215  * WARNING: Unlike constructors, initializer functions must be manually
216  * invoked. This applies both to deploying an Initializable contract, as well
217  * as extending an Initializable contract via inheritance.
218  * WARNING: When used with inheritance, manual care must be taken to not invoke
219  * a parent initializer twice, or ensure that all initializers are idempotent,
220  * because this is not dealt with automatically as with constructors.
221  */
222 contract Initializable {
223 
224   /**
225    * @dev Indicates that the contract has been initialized.
226    */
227   bool private initialized;
228 
229   /**
230    * @dev Indicates that the contract is in the process of being initialized.
231    */
232   bool private initializing;
233 
234   /**
235    * @dev Modifier to use in the initializer function of a contract.
236    */
237   modifier initializer() {
238     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
239 
240     bool wasInitializing = initializing;
241     initializing = true;
242     initialized = true;
243 
244     _;
245 
246     initializing = wasInitializing;
247   }
248 
249   /// @dev Returns true if and only if the function is running in the constructor
250   function isConstructor() private view returns (bool) {
251     // extcodesize checks the size of the code stored in an address, and
252     // address returns the current address. Since the code is still not
253     // deployed when running a constructor, any checks on its code size will
254     // yield zero, making it an effective way to detect if a contract is
255     // under construction or not.
256     uint256 cs;
257     assembly { cs := extcodesize(address) }
258     return cs == 0;
259   }
260 
261   // Reserved storage space to allow for layout changes in the future.
262   uint256[50] private ______gap;
263 }
264 
265 
266 // File contracts/v4/openzeppelin-eth/Ownable.sol
267 
268 pragma solidity ^0.4.24;
269 
270 
271 /**
272  * @title Ownable
273  * @dev The Ownable contract has an owner address, and provides basic authorization control
274  * functions, this simplifies the implementation of "user permissions".
275  */
276 contract Ownable is Initializable {
277   address private _owner;
278 
279 
280   event OwnershipRenounced(address indexed previousOwner);
281   event OwnershipTransferred(
282     address indexed previousOwner,
283     address indexed newOwner
284   );
285 
286 
287   /**
288    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
289    * account.
290    */
291   function initialize(address sender) internal initializer {
292     _owner = sender;
293   }
294 
295   /**
296    * @return the address of the owner.
297    */
298   function owner() public view returns(address) {
299     return _owner;
300   }
301 
302   /**
303    * @dev Throws if called by any account other than the owner.
304    */
305   modifier onlyOwner() {
306     require(isOwner());
307     _;
308   }
309 
310   /**
311    * @return true if `msg.sender` is the owner of the contract.
312    */
313   function isOwner() public view returns(bool) {
314     return msg.sender == _owner;
315   }
316 
317   /**
318    * @dev Allows the current owner to relinquish control of the contract.
319    * @notice Renouncing to ownership will leave the contract without an owner.
320    * It will not be possible to call the functions with the `onlyOwner`
321    * modifier anymore.
322    */
323   function renounceOwnership() public onlyOwner {
324     emit OwnershipRenounced(_owner);
325     _owner = address(0);
326   }
327 
328   /**
329    * @dev Allows the current owner to transfer control of the contract to a newOwner.
330    * @param newOwner The address to transfer ownership to.
331    */
332   function transferOwnership(address newOwner) public onlyOwner {
333     _transferOwnership(newOwner);
334   }
335 
336   /**
337    * @dev Transfers control of the contract to a newOwner.
338    * @param newOwner The address to transfer ownership to.
339    */
340   function _transferOwnership(address newOwner) internal {
341     require(newOwner != address(0));
342     emit OwnershipTransferred(_owner, newOwner);
343     _owner = newOwner;
344   }
345 
346   uint256[50] private ______gap;
347 }
348 
349 
350 // File contracts/v4/openzeppelin-eth/IERC20.sol
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
388 
389 // File contracts/v4/openzeppelin-eth/ERC20Detailed.sol
390 
391 pragma solidity ^0.4.24;
392 
393 
394 
395 
396 /**
397  * @title ERC20Detailed token
398  * @dev The decimals are only for visualization purposes.
399  * All the operations are done using the smallest and indivisible token unit,
400  * just as on Ethereum all the operations are done in wei.
401  */
402 contract ERC20Detailed is Initializable, IERC20 {
403   string private _name;
404   string private _symbol;
405   uint8 private _decimals;
406 
407   function initialize(string name, string symbol, uint8 decimals) internal initializer {
408     _name = name;
409     _symbol = symbol;
410     _decimals = decimals;
411   }
412 
413   /**
414    * @return the name of the token.
415    */
416   function name() public view returns(string) {
417     return _name;
418   }
419 
420   /**
421    * @return the symbol of the token.
422    */
423   function symbol() public view returns(string) {
424     return _symbol;
425   }
426 
427   /**
428    * @return the number of decimals of the token.
429    */
430   function decimals() public view returns(uint8) {
431     return _decimals;
432   }
433 
434   uint256[50] private ______gap;
435 }
436 
437 
438 // File contracts/v4/UFragments.sol
439 
440 pragma solidity 0.4.24;
441 
442 
443 
444 
445 
446 
447 /**
448  * @title uFragments ERC20 token
449  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
450  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
451  *      combining tokens proportionally across all wallets.
452  *
453  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
454  *      We support splitting the currency in expansion and combining the currency on contraction by
455  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
456  */
457 contract UFragments is ERC20Detailed, Ownable {
458     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
459     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
460     // order to minimize this risk, we adhere to the following guidelines:
461     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
462     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
463     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
464     //    multiplying by the inverse rate, you should divide by the normal rate)
465     // 2) Gon balances converted into Fragments are always rounded down (truncated).
466     //
467     // We make the following guarantees:
468     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
469     //   be decreased by precisely x Fragments, and B's external balance will be precisely
470     //   increased by x Fragments.
471     //
472     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
473     // This is because, for any conversion function 'f()' that has non-zero rounding error,
474     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
475     using SafeMath for uint256;
476     using SafeMathInt for int256;
477 
478     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
479     event LogMonetaryPolicyUpdated(address monetaryPolicy);
480 
481     // Used for authentication
482     address public monetaryPolicy;
483 
484     modifier onlyMonetaryPolicy() {
485         require(msg.sender == monetaryPolicy);
486         _;
487     }
488 
489     bool private rebasePausedDeprecated;
490     bool private tokenPausedDeprecated;
491 
492     modifier validRecipient(address to) {
493         require(to != address(0x0));
494         require(to != address(this));
495         _;
496     }
497 
498     uint256 private constant DECIMALS = 18;
499     uint256 private constant MAX_UINT256 = ~uint256(0);
500     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 420690000000 * uint(10)**DECIMALS;
501 
502     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
503     // Use the highest value that fits in a uint256 for max granularity.
504     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
505 
506     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
507     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
508 
509     uint256 private _totalSupply;
510     uint256 private _gonsPerFragment;
511     mapping(address => uint256) private _gonBalances;
512 
513     // This is denominated in Fragments, because the gons-fragments conversion might change before
514     // it's fully paid.
515     mapping (address => mapping (address => uint256)) private _allowedFragments;
516 
517     address public deployer;
518 
519     modifier onlyDeployer() {
520         require(msg.sender == deployer);
521         _;
522     }
523 
524     constructor () public {
525         deployer = msg.sender;
526     }
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
539      * @dev Notifies Fragments contract about a new rebase cycle.
540      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
541      * @return The total number of fragments after the supply adjustment.
542      */
543     function rebase(uint256 epoch, int256 supplyDelta)
544         external
545         onlyMonetaryPolicy
546         returns (uint256)
547     {
548         if (supplyDelta == 0) {
549             emit LogRebase(epoch, _totalSupply);
550             return _totalSupply;
551         }
552 
553         if (supplyDelta < 0) {
554             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
555         } else {
556             _totalSupply = _totalSupply.add(uint256(supplyDelta));
557         }
558 
559         if (_totalSupply > MAX_SUPPLY) {
560             _totalSupply = MAX_SUPPLY;
561         }
562 
563         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
564 
565         // From this point forward, _gonsPerFragment is taken as the source of truth.
566         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
567         // conversion rate.
568         // This means our applied supplyDelta can deviate from the requested supplyDelta,
569         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
570         //
571         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
572         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
573         // ever increased, it must be re-included.
574         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
575 
576         emit LogRebase(epoch, _totalSupply);
577         return _totalSupply;
578     }
579 
580     function initialize(string name_, string symbol_, address owner_, address pool1_)
581         public
582         onlyDeployer
583         initializer
584     {
585         ERC20Detailed.initialize(name_, symbol_, uint8(DECIMALS));
586         Ownable.initialize(owner_);
587 
588         rebasePausedDeprecated = false;
589         tokenPausedDeprecated = false;
590 
591         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
592         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
593 
594         uint256 pool1Val =  420690000000 * (10 ** DECIMALS);
595         uint256 pool1Gons = pool1Val.mul(_gonsPerFragment);
596 
597         _gonBalances[pool1_] = pool1Gons;
598 
599         emit Transfer(address(0x0), pool1_, pool1Val);
600     }
601 
602     /**
603      * @return The total number of fragments.
604      */
605     function totalSupply()
606         public
607         view
608         returns (uint256)
609     {
610         return _totalSupply;
611     }
612 
613     /**
614      * @param who The address to query.
615      * @return The balance of the specified address.
616      */
617     function balanceOf(address who)
618         public
619         view
620         returns (uint256)
621     {
622         return _gonBalances[who].div(_gonsPerFragment);
623     }
624 
625     /**
626      * @dev Transfer tokens to a specified address.
627      * @param to The address to transfer to.
628      * @param value The amount to be transferred.
629      * @return True on success, false otherwise.
630      */
631     function transfer(address to, uint256 value)
632         public
633         validRecipient(to)
634         returns (bool)
635     {
636         uint256 gonValue = value.mul(_gonsPerFragment);
637         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
638         _gonBalances[to] = _gonBalances[to].add(gonValue);
639         emit Transfer(msg.sender, to, value);
640         return true;
641     }
642 
643     /**
644      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
645      * @param owner_ The address which owns the funds.
646      * @param spender The address which will spend the funds.
647      * @return The number of tokens still available for the spender.
648      */
649     function allowance(address owner_, address spender)
650         public
651         view
652         returns (uint256)
653     {
654         return _allowedFragments[owner_][spender];
655     }
656 
657     /**
658      * @dev Transfer tokens from one address to another.
659      * @param from The address you want to send tokens from.
660      * @param to The address you want to transfer to.
661      * @param value The amount of tokens to be transferred.
662      */
663     function transferFrom(address from, address to, uint256 value)
664         public
665         validRecipient(to)
666         returns (bool)
667     {
668         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
669 
670         uint256 gonValue = value.mul(_gonsPerFragment);
671         _gonBalances[from] = _gonBalances[from].sub(gonValue);
672         _gonBalances[to] = _gonBalances[to].add(gonValue);
673         emit Transfer(from, to, value);
674 
675         return true;
676     }
677 
678     /**
679      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
680      * msg.sender. This method is included for ERC20 compatibility.
681      * increaseAllowance and decreaseAllowance should be used instead.
682      * Changing an allowance with this method brings the risk that someone may transfer both
683      * the old and the new allowance - if they are both greater than zero - if a transfer
684      * transaction is mined before the later approve() call is mined.
685      *
686      * @param spender The address which will spend the funds.
687      * @param value The amount of tokens to be spent.
688      */
689     function approve(address spender, uint256 value)
690         public
691         returns (bool)
692     {
693         _allowedFragments[msg.sender][spender] = value;
694         emit Approval(msg.sender, spender, value);
695         return true;
696     }
697 
698     /**
699      * @dev Increase the amount of tokens that an owner has allowed to a spender.
700      * This method should be used instead of approve() to avoid the double approval vulnerability
701      * described above.
702      * @param spender The address which will spend the funds.
703      * @param addedValue The amount of tokens to increase the allowance by.
704      */
705     function increaseAllowance(address spender, uint256 addedValue)
706         public
707         returns (bool)
708     {
709         _allowedFragments[msg.sender][spender] =
710             _allowedFragments[msg.sender][spender].add(addedValue);
711         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
712         return true;
713     }
714 
715     /**
716      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
717      *
718      * @param spender The address which will spend the funds.
719      * @param subtractedValue The amount of tokens to decrease the allowance by.
720      */
721     function decreaseAllowance(address spender, uint256 subtractedValue)
722         public
723         returns (bool)
724     {
725         uint256 oldValue = _allowedFragments[msg.sender][spender];
726         if (subtractedValue >= oldValue) {
727             _allowedFragments[msg.sender][spender] = 0;
728         } else {
729             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
730         }
731         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
732         return true;
733     }
734 }