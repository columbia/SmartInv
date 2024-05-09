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
68 
69 // File contracts/v4/lib/SafeMathInt.sol
70 
71 /*
72 MIT License
73 
74 Copyright (c) 2018 requestnetwork
75 Copyright (c) 2018 Fragments, Inc.
76 
77 Permission is hereby granted, free of charge, to any person obtaining a copy
78 of this software and associated documentation files (the "Software"), to deal
79 in the Software without restriction, including without limitation the rights
80 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
81 copies of the Software, and to permit persons to whom the Software is
82 furnished to do so, subject to the following conditions:
83 
84 The above copyright notice and this permission notice shall be included in all
85 copies or substantial portions of the Software.
86 
87 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
88 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
89 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
90 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
91 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
92 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
93 SOFTWARE.
94 */
95 
96 pragma solidity 0.4.24;
97 
98 
99 /**
100  * @title SafeMathInt
101  * @dev Math operations for int256 with overflow safety checks.
102  */
103 library SafeMathInt {
104     int256 private constant MIN_INT256 = int256(1) << 255;
105     int256 private constant MAX_INT256 = ~(int256(1) << 255);
106 
107     /**
108      * @dev Multiplies two int256 variables and fails on overflow.
109      */
110     function mul(int256 a, int256 b)
111         internal
112         pure
113         returns (int256)
114     {
115         int256 c = a * b;
116 
117         // Detect overflow when multiplying MIN_INT256 with -1
118         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
119         require((b == 0) || (c / b == a));
120         return c;
121     }
122 
123     /**
124      * @dev Division of two int256 variables and fails on overflow.
125      */
126     function div(int256 a, int256 b)
127         internal
128         pure
129         returns (int256)
130     {
131         // Prevent overflow when dividing MIN_INT256 by -1
132         require(b != -1 || a != MIN_INT256);
133 
134         // Solidity already throws when dividing by 0.
135         return a / b;
136     }
137 
138     /**
139      * @dev Subtracts two int256 variables and fails on overflow.
140      */
141     function sub(int256 a, int256 b)
142         internal
143         pure
144         returns (int256)
145     {
146         int256 c = a - b;
147         require((b >= 0 && c <= a) || (b < 0 && c > a));
148         return c;
149     }
150 
151     /**
152      * @dev Adds two int256 variables and fails on overflow.
153      */
154     function add(int256 a, int256 b)
155         internal
156         pure
157         returns (int256)
158     {
159         int256 c = a + b;
160         require((b >= 0 && c >= a) || (b < 0 && c < a));
161         return c;
162     }
163 
164     /**
165      * @dev Converts to absolute value, and fails on overflow.
166      */
167     function abs(int256 a)
168         internal
169         pure
170         returns (int256)
171     {
172         require(a != MIN_INT256);
173         return a < 0 ? -a : a;
174     }
175 }
176 
177 
178 // File contracts/v4/lib/UInt256Lib.sol
179 
180 pragma solidity 0.4.24;
181 
182 
183 /**
184  * @title Various utilities useful for uint256.
185  */
186 library UInt256Lib {
187 
188     uint256 private constant MAX_INT256 = ~(uint256(1) << 255);
189 
190     /**
191      * @dev Safely converts a uint256 to an int256.
192      */
193     function toInt256Safe(uint256 a)
194         internal
195         pure
196         returns (int256)
197     {
198         require(a <= MAX_INT256);
199         return int256(a);
200     }
201 }
202 
203 
204 // File zos-lib/contracts/Initializable.sol@v2.1.0
205 
206 pragma solidity >=0.4.24 <0.6.0;
207 
208 
209 /**
210  * @title Initializable
211  *
212  * @dev Helper contract to support initializer functions. To use it, replace
213  * the constructor with a function that has the `initializer` modifier.
214  * WARNING: Unlike constructors, initializer functions must be manually
215  * invoked. This applies both to deploying an Initializable contract, as well
216  * as extending an Initializable contract via inheritance.
217  * WARNING: When used with inheritance, manual care must be taken to not invoke
218  * a parent initializer twice, or ensure that all initializers are idempotent,
219  * because this is not dealt with automatically as with constructors.
220  */
221 contract Initializable {
222 
223   /**
224    * @dev Indicates that the contract has been initialized.
225    */
226   bool private initialized;
227 
228   /**
229    * @dev Indicates that the contract is in the process of being initialized.
230    */
231   bool private initializing;
232 
233   /**
234    * @dev Modifier to use in the initializer function of a contract.
235    */
236   modifier initializer() {
237     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
238 
239     bool wasInitializing = initializing;
240     initializing = true;
241     initialized = true;
242 
243     _;
244 
245     initializing = wasInitializing;
246   }
247 
248   /// @dev Returns true if and only if the function is running in the constructor
249   function isConstructor() private view returns (bool) {
250     // extcodesize checks the size of the code stored in an address, and
251     // address returns the current address. Since the code is still not
252     // deployed when running a constructor, any checks on its code size will
253     // yield zero, making it an effective way to detect if a contract is
254     // under construction or not.
255     uint256 cs;
256     assembly { cs := extcodesize(address) }
257     return cs == 0;
258   }
259 
260   // Reserved storage space to allow for layout changes in the future.
261   uint256[50] private ______gap;
262 }
263 
264 
265 // File contracts/v4/openzeppelin-eth/Ownable.sol
266 
267 pragma solidity ^0.4.24;
268 
269 
270 /**
271  * @title Ownable
272  * @dev The Ownable contract has an owner address, and provides basic authorization control
273  * functions, this simplifies the implementation of "user permissions".
274  */
275 contract Ownable is Initializable {
276   address private _owner;
277 
278 
279   event OwnershipRenounced(address indexed previousOwner);
280   event OwnershipTransferred(
281     address indexed previousOwner,
282     address indexed newOwner
283   );
284 
285 
286   /**
287    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
288    * account.
289    */
290   function initialize(address sender) internal initializer {
291     _owner = sender;
292   }
293 
294   /**
295    * @return the address of the owner.
296    */
297   function owner() public view returns(address) {
298     return _owner;
299   }
300 
301   /**
302    * @dev Throws if called by any account other than the owner.
303    */
304   modifier onlyOwner() {
305     require(isOwner());
306     _;
307   }
308 
309   /**
310    * @return true if `msg.sender` is the owner of the contract.
311    */
312   function isOwner() public view returns(bool) {
313     return msg.sender == _owner;
314   }
315 
316   /**
317    * @dev Allows the current owner to relinquish control of the contract.
318    * @notice Renouncing to ownership will leave the contract without an owner.
319    * It will not be possible to call the functions with the `onlyOwner`
320    * modifier anymore.
321    */
322   function renounceOwnership() public onlyOwner {
323     emit OwnershipRenounced(_owner);
324     _owner = address(0);
325   }
326 
327   /**
328    * @dev Allows the current owner to transfer control of the contract to a newOwner.
329    * @param newOwner The address to transfer ownership to.
330    */
331   function transferOwnership(address newOwner) public onlyOwner {
332     _transferOwnership(newOwner);
333   }
334 
335   /**
336    * @dev Transfers control of the contract to a newOwner.
337    * @param newOwner The address to transfer ownership to.
338    */
339   function _transferOwnership(address newOwner) internal {
340     require(newOwner != address(0));
341     emit OwnershipTransferred(_owner, newOwner);
342     _owner = newOwner;
343   }
344 
345   uint256[50] private ______gap;
346 }
347 
348 
349 // File contracts/v4/openzeppelin-eth/IERC20.sol
350 
351 pragma solidity ^0.4.24;
352 
353 
354 /**
355  * @title ERC20 interface
356  * @dev see https://github.com/ethereum/EIPs/issues/20
357  */
358 interface IERC20 {
359   function totalSupply() external view returns (uint256);
360 
361   function balanceOf(address who) external view returns (uint256);
362 
363   function allowance(address owner, address spender)
364     external view returns (uint256);
365 
366   function transfer(address to, uint256 value) external returns (bool);
367 
368   function approve(address spender, uint256 value)
369     external returns (bool);
370 
371   function transferFrom(address from, address to, uint256 value)
372     external returns (bool);
373 
374   event Transfer(
375     address indexed from,
376     address indexed to,
377     uint256 value
378   );
379 
380   event Approval(
381     address indexed owner,
382     address indexed spender,
383     uint256 value
384   );
385 }
386 
387 
388 // File contracts/v4/openzeppelin-eth/ERC20Detailed.sol
389 
390 pragma solidity ^0.4.24;
391 
392 
393 
394 
395 /**
396  * @title ERC20Detailed token
397  * @dev The decimals are only for visualization purposes.
398  * All the operations are done using the smallest and indivisible token unit,
399  * just as on Ethereum all the operations are done in wei.
400  */
401 contract ERC20Detailed is Initializable, IERC20 {
402   string private _name;
403   string private _symbol;
404   uint8 private _decimals;
405 
406   function initialize(string name, string symbol, uint8 decimals) internal initializer {
407     _name = name;
408     _symbol = symbol;
409     _decimals = decimals;
410   }
411 
412   /**
413    * @return the name of the token.
414    */
415   function name() public view returns(string) {
416     return _name;
417   }
418 
419   /**
420    * @return the symbol of the token.
421    */
422   function symbol() public view returns(string) {
423     return _symbol;
424   }
425 
426   /**
427    * @return the number of decimals of the token.
428    */
429   function decimals() public view returns(uint8) {
430     return _decimals;
431   }
432 
433   uint256[50] private ______gap;
434 }
435 
436 
437 // File contracts/v4/UFragments.sol
438 
439 pragma solidity 0.4.24;
440 
441 
442 
443 
444 
445 
446 /**
447  * @title uFragments ERC20 token
448  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
449  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
450  *      combining tokens proportionally across all wallets.
451  *
452  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
453  *      We support splitting the currency in expansion and combining the currency on contraction by
454  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
455  */
456 contract UFragments is ERC20Detailed, Ownable {
457     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
458     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
459     // order to minimize this risk, we adhere to the following guidelines:
460     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
461     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
462     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
463     //    multiplying by the inverse rate, you should divide by the normal rate)
464     // 2) Gon balances converted into Fragments are always rounded down (truncated).
465     //
466     // We make the following guarantees:
467     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
468     //   be decreased by precisely x Fragments, and B's external balance will be precisely
469     //   increased by x Fragments.
470     //
471     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
472     // This is because, for any conversion function 'f()' that has non-zero rounding error,
473     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
474     using SafeMath for uint256;
475     using SafeMathInt for int256;
476 
477     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
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
488     bool private rebasePausedDeprecated;
489     bool private tokenPausedDeprecated;
490 
491     modifier validRecipient(address to) {
492         require(to != address(0x0));
493         require(to != address(this));
494         _;
495     }
496 
497     uint256 private constant DECIMALS = 18;
498     uint256 private constant MAX_UINT256 = ~uint256(0);
499     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 100000 * uint(10)**DECIMALS;
500 
501     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
502     // Use the highest value that fits in a uint256 for max granularity.
503     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
504 
505     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
506     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
507 
508     uint256 private _totalSupply;
509     uint256 private _gonsPerFragment;
510     mapping(address => uint256) private _gonBalances;
511 
512     // This is denominated in Fragments, because the gons-fragments conversion might change before
513     // it's fully paid.
514     mapping (address => mapping (address => uint256)) private _allowedFragments;
515 
516     address public deployer;
517 
518     modifier onlyDeployer() {
519         require(msg.sender == deployer);
520         _;
521     }
522 
523     constructor () public {
524         deployer = msg.sender;
525     }
526     /**
527      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
528      */
529     function setMonetaryPolicy(address monetaryPolicy_)
530         external
531         onlyOwner
532     {
533         monetaryPolicy = monetaryPolicy_;
534         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
535     }
536 
537     /**
538      * @dev Notifies Fragments contract about a new rebase cycle.
539      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
540      * @return The total number of fragments after the supply adjustment.
541      */
542     function rebase(uint256 epoch, int256 supplyDelta)
543         external
544         onlyMonetaryPolicy
545         returns (uint256)
546     {
547         if (supplyDelta == 0) {
548             emit LogRebase(epoch, _totalSupply);
549             return _totalSupply;
550         }
551 
552         if (supplyDelta < 0) {
553             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
554         } else {
555             _totalSupply = _totalSupply.add(uint256(supplyDelta));
556         }
557 
558         if (_totalSupply > MAX_SUPPLY) {
559             _totalSupply = MAX_SUPPLY;
560         }
561 
562         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
563 
564         // From this point forward, _gonsPerFragment is taken as the source of truth.
565         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
566         // conversion rate.
567         // This means our applied supplyDelta can deviate from the requested supplyDelta,
568         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
569         //
570         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
571         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
572         // ever increased, it must be re-included.
573         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
574 
575         emit LogRebase(epoch, _totalSupply);
576         return _totalSupply;
577     }
578 
579     // deliberately changing function signature to prevent accidental v1 deploy script reuse
580     function initialize(string name_, string symbol_, address owner_, address migrator_, address pool1_)
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
594         uint256 pool1Val = 75000 * (10 ** DECIMALS);
595         uint256 pool1Gons = pool1Val.mul(_gonsPerFragment);
596 
597         _gonBalances[migrator_] = TOTAL_GONS.sub(pool1Gons);
598         _gonBalances[pool1_] = pool1Gons;
599 
600         emit Transfer(address(0x0), migrator_, _totalSupply.sub(pool1Val));
601         emit Transfer(address(0x0), pool1_, pool1Val);
602     }
603 
604     /**
605      * @return The total number of fragments.
606      */
607     function totalSupply()
608         public
609         view
610         returns (uint256)
611     {
612         return _totalSupply;
613     }
614 
615     /**
616      * @param who The address to query.
617      * @return The balance of the specified address.
618      */
619     function balanceOf(address who)
620         public
621         view
622         returns (uint256)
623     {
624         return _gonBalances[who].div(_gonsPerFragment);
625     }
626 
627     /**
628      * @dev Transfer tokens to a specified address.
629      * @param to The address to transfer to.
630      * @param value The amount to be transferred.
631      * @return True on success, false otherwise.
632      */
633     function transfer(address to, uint256 value)
634         public
635         validRecipient(to)
636         returns (bool)
637     {
638         uint256 gonValue = value.mul(_gonsPerFragment);
639         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
640         _gonBalances[to] = _gonBalances[to].add(gonValue);
641         emit Transfer(msg.sender, to, value);
642         return true;
643     }
644 
645     /**
646      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
647      * @param owner_ The address which owns the funds.
648      * @param spender The address which will spend the funds.
649      * @return The number of tokens still available for the spender.
650      */
651     function allowance(address owner_, address spender)
652         public
653         view
654         returns (uint256)
655     {
656         return _allowedFragments[owner_][spender];
657     }
658 
659     /**
660      * @dev Transfer tokens from one address to another.
661      * @param from The address you want to send tokens from.
662      * @param to The address you want to transfer to.
663      * @param value The amount of tokens to be transferred.
664      */
665     function transferFrom(address from, address to, uint256 value)
666         public
667         validRecipient(to)
668         returns (bool)
669     {
670         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
671 
672         uint256 gonValue = value.mul(_gonsPerFragment);
673         _gonBalances[from] = _gonBalances[from].sub(gonValue);
674         _gonBalances[to] = _gonBalances[to].add(gonValue);
675         emit Transfer(from, to, value);
676 
677         return true;
678     }
679 
680     /**
681      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
682      * msg.sender. This method is included for ERC20 compatibility.
683      * increaseAllowance and decreaseAllowance should be used instead.
684      * Changing an allowance with this method brings the risk that someone may transfer both
685      * the old and the new allowance - if they are both greater than zero - if a transfer
686      * transaction is mined before the later approve() call is mined.
687      *
688      * @param spender The address which will spend the funds.
689      * @param value The amount of tokens to be spent.
690      */
691     function approve(address spender, uint256 value)
692         public
693         returns (bool)
694     {
695         _allowedFragments[msg.sender][spender] = value;
696         emit Approval(msg.sender, spender, value);
697         return true;
698     }
699 
700     /**
701      * @dev Increase the amount of tokens that an owner has allowed to a spender.
702      * This method should be used instead of approve() to avoid the double approval vulnerability
703      * described above.
704      * @param spender The address which will spend the funds.
705      * @param addedValue The amount of tokens to increase the allowance by.
706      */
707     function increaseAllowance(address spender, uint256 addedValue)
708         public
709         returns (bool)
710     {
711         _allowedFragments[msg.sender][spender] =
712             _allowedFragments[msg.sender][spender].add(addedValue);
713         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
714         return true;
715     }
716 
717     /**
718      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
719      *
720      * @param spender The address which will spend the funds.
721      * @param subtractedValue The amount of tokens to decrease the allowance by.
722      */
723     function decreaseAllowance(address spender, uint256 subtractedValue)
724         public
725         returns (bool)
726     {
727         uint256 oldValue = _allowedFragments[msg.sender][spender];
728         if (subtractedValue >= oldValue) {
729             _allowedFragments[msg.sender][spender] = 0;
730         } else {
731             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
732         }
733         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
734         return true;
735     }
736 }