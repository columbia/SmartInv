1 // File: openzeppelin-eth/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that revert on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, reverts on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     uint256 c = a * b;
24     require(c / a == b);
25 
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     require(b > 0); // Solidity only automatically asserts when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37     return c;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     require(b <= a);
45     uint256 c = a - b;
46 
47     return c;
48   }
49 
50   /**
51   * @dev Adds two numbers, reverts on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     require(c >= a);
56 
57     return c;
58   }
59 
60   /**
61   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
62   * reverts when dividing by zero.
63   */
64   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65     require(b != 0);
66     return a % b;
67   }
68 }
69 
70 // File: zos-lib/contracts/Initializable.sol
71 
72 pragma solidity >=0.4.24 <0.6.0;
73 
74 
75 /**
76  * @title Initializable
77  *
78  * @dev Helper contract to support initializer functions. To use it, replace
79  * the constructor with a function that has the `initializer` modifier.
80  * WARNING: Unlike constructors, initializer functions must be manually
81  * invoked. This applies both to deploying an Initializable contract, as well
82  * as extending an Initializable contract via inheritance.
83  * WARNING: When used with inheritance, manual care must be taken to not invoke
84  * a parent initializer twice, or ensure that all initializers are idempotent,
85  * because this is not dealt with automatically as with constructors.
86  */
87 contract Initializable {
88 
89   /**
90    * @dev Indicates that the contract has been initialized.
91    */
92   bool private initialized;
93 
94   /**
95    * @dev Indicates that the contract is in the process of being initialized.
96    */
97   bool private initializing;
98 
99   /**
100    * @dev Modifier to use in the initializer function of a contract.
101    */
102   modifier initializer() {
103     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
104 
105     bool wasInitializing = initializing;
106     initializing = true;
107     initialized = true;
108 
109     _;
110 
111     initializing = wasInitializing;
112   }
113 
114   /// @dev Returns true if and only if the function is running in the constructor
115   function isConstructor() private view returns (bool) {
116     // extcodesize checks the size of the code stored in an address, and
117     // address returns the current address. Since the code is still not
118     // deployed when running a constructor, any checks on its code size will
119     // yield zero, making it an effective way to detect if a contract is
120     // under construction or not.
121     uint256 cs;
122     assembly { cs := extcodesize(address) }
123     return cs == 0;
124   }
125 
126   // Reserved storage space to allow for layout changes in the future.
127   uint256[50] private ______gap;
128 }
129 
130 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
131 
132 pragma solidity ^0.4.24;
133 
134 
135 /**
136  * @title Ownable
137  * @dev The Ownable contract has an owner address, and provides basic authorization control
138  * functions, this simplifies the implementation of "user permissions".
139  */
140 contract Ownable is Initializable {
141   address private _owner;
142 
143 
144   event OwnershipRenounced(address indexed previousOwner);
145   event OwnershipTransferred(
146     address indexed previousOwner,
147     address indexed newOwner
148   );
149 
150 
151   /**
152    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
153    * account.
154    */
155   function initialize(address sender) public initializer {
156     _owner = sender;
157   }
158 
159   /**
160    * @return the address of the owner.
161    */
162   function owner() public view returns(address) {
163     return _owner;
164   }
165 
166   /**
167    * @dev Throws if called by any account other than the owner.
168    */
169   modifier onlyOwner() {
170     require(isOwner());
171     _;
172   }
173 
174   /**
175    * @return true if `msg.sender` is the owner of the contract.
176    */
177   function isOwner() public view returns(bool) {
178     return msg.sender == _owner;
179   }
180 
181   /**
182    * @dev Allows the current owner to relinquish control of the contract.
183    * @notice Renouncing to ownership will leave the contract without an owner.
184    * It will not be possible to call the functions with the `onlyOwner`
185    * modifier anymore.
186    */
187   function renounceOwnership() public onlyOwner {
188     emit OwnershipRenounced(_owner);
189     _owner = address(0);
190   }
191 
192   /**
193    * @dev Allows the current owner to transfer control of the contract to a newOwner.
194    * @param newOwner The address to transfer ownership to.
195    */
196   function transferOwnership(address newOwner) public onlyOwner {
197     _transferOwnership(newOwner);
198   }
199 
200   /**
201    * @dev Transfers control of the contract to a newOwner.
202    * @param newOwner The address to transfer ownership to.
203    */
204   function _transferOwnership(address newOwner) internal {
205     require(newOwner != address(0));
206     emit OwnershipTransferred(_owner, newOwner);
207     _owner = newOwner;
208   }
209 
210   uint256[50] private ______gap;
211 }
212 
213 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
214 
215 pragma solidity ^0.4.24;
216 
217 
218 /**
219  * @title ERC20 interface
220  * @dev see https://github.com/ethereum/EIPs/issues/20
221  */
222 interface IERC20 {
223   function totalSupply() external view returns (uint256);
224 
225   function balanceOf(address who) external view returns (uint256);
226 
227   function allowance(address owner, address spender)
228     external view returns (uint256);
229 
230   function transfer(address to, uint256 value) external returns (bool);
231 
232   function approve(address spender, uint256 value)
233     external returns (bool);
234 
235   function transferFrom(address from, address to, uint256 value)
236     external returns (bool);
237 
238   event Transfer(
239     address indexed from,
240     address indexed to,
241     uint256 value
242   );
243 
244   event Approval(
245     address indexed owner,
246     address indexed spender,
247     uint256 value
248   );
249 }
250 
251 // File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol
252 
253 pragma solidity ^0.4.24;
254 
255 
256 
257 
258 /**
259  * @title ERC20Detailed token
260  * @dev The decimals are only for visualization purposes.
261  * All the operations are done using the smallest and indivisible token unit,
262  * just as on Ethereum all the operations are done in wei.
263  */
264 contract ERC20Detailed is Initializable, IERC20 {
265   string private _name;
266   string private _symbol;
267   uint8 private _decimals;
268 
269   function initialize(string name, string symbol, uint8 decimals) public initializer {
270     _name = name;
271     _symbol = symbol;
272     _decimals = decimals;
273   }
274 
275   /**
276    * @return the name of the token.
277    */
278   function name() public view returns(string) {
279     return _name;
280   }
281 
282   /**
283    * @return the symbol of the token.
284    */
285   function symbol() public view returns(string) {
286     return _symbol;
287   }
288 
289   /**
290    * @return the number of decimals of the token.
291    */
292   function decimals() public view returns(uint8) {
293     return _decimals;
294   }
295 
296   uint256[50] private ______gap;
297 }
298 
299 // File: contracts/lib/SafeMathInt.sol
300 
301 /*
302 MIT License
303 
304 Copyright (c) 2018 requestnetwork
305 Copyright (c) 2018 Fragments, Inc.
306 
307 Permission is hereby granted, free of charge, to any person obtaining a copy
308 of this software and associated documentation files (the "Software"), to deal
309 in the Software without restriction, including without limitation the rights
310 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
311 copies of the Software, and to permit persons to whom the Software is
312 furnished to do so, subject to the following conditions:
313 
314 The above copyright notice and this permission notice shall be included in all
315 copies or substantial portions of the Software.
316 
317 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
318 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
319 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
320 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
321 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
322 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
323 SOFTWARE.
324 */
325 
326 pragma solidity 0.4.24;
327 
328 
329 /**
330  * @title SafeMathInt
331  * @dev Math operations for int256 with overflow safety checks.
332  */
333 library SafeMathInt {
334     int256 private constant MIN_INT256 = int256(1) << 255;
335     int256 private constant MAX_INT256 = ~(int256(1) << 255);
336 
337     /**
338      * @dev Multiplies two int256 variables and fails on overflow.
339      */
340     function mul(int256 a, int256 b)
341         internal
342         pure
343         returns (int256)
344     {
345         int256 c = a * b;
346 
347         // Detect overflow when multiplying MIN_INT256 with -1
348         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
349         require((b == 0) || (c / b == a));
350         return c;
351     }
352 
353     /**
354      * @dev Division of two int256 variables and fails on overflow.
355      */
356     function div(int256 a, int256 b)
357         internal
358         pure
359         returns (int256)
360     {
361         // Prevent overflow when dividing MIN_INT256 by -1
362         require(b != -1 || a != MIN_INT256);
363 
364         // Solidity already throws when dividing by 0.
365         return a / b;
366     }
367 
368     /**
369      * @dev Subtracts two int256 variables and fails on overflow.
370      */
371     function sub(int256 a, int256 b)
372         internal
373         pure
374         returns (int256)
375     {
376         int256 c = a - b;
377         require((b >= 0 && c <= a) || (b < 0 && c > a));
378         return c;
379     }
380 
381     /**
382      * @dev Adds two int256 variables and fails on overflow.
383      */
384     function add(int256 a, int256 b)
385         internal
386         pure
387         returns (int256)
388     {
389         int256 c = a + b;
390         require((b >= 0 && c >= a) || (b < 0 && c < a));
391         return c;
392     }
393 
394     /**
395      * @dev Converts to absolute value, and fails on overflow.
396      */
397     function abs(int256 a)
398         internal
399         pure
400         returns (int256)
401     {
402         require(a != MIN_INT256);
403         return a < 0 ? -a : a;
404     }
405 }
406 
407 // File: contracts/uFragments.sol
408 
409 pragma solidity 0.4.24;
410 
411 
412 
413 
414 
415 
416 /**
417  * @title uFragments ERC20 token
418  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
419  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
420  *      combining tokens proportionally across all wallets.
421  *
422  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
423  *      We support splitting the currency in expansion and combining the currency on contraction by
424  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
425  */
426 contract UFragments is ERC20Detailed, Ownable {
427     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
428     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
429     // order to minimize this risk, we adhere to the following guidelines:
430     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
431     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
432     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
433     //    multiplying by the inverse rate, you should divide by the normal rate)
434     // 2) Gon balances converted into Fragments are always rounded down (truncated).
435     //
436     // We make the following guarantees:
437     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
438     //   be decreased by precisely x Fragments, and B's external balance will be precisely
439     //   increased by x Fragments.
440     //
441     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
442     // This is because, for any conversion function 'f()' that has non-zero rounding error,
443     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
444     using SafeMath for uint256;
445     using SafeMathInt for int256;
446 
447     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
448     event LogRebasePaused(bool paused);
449     event LogTokenPaused(bool paused);
450     event LogMonetaryPolicyUpdated(address monetaryPolicy);
451 
452     // Used for authentication
453     address public monetaryPolicy;
454 
455     modifier onlyMonetaryPolicy() {
456         require(msg.sender == monetaryPolicy);
457         _;
458     }
459 
460     // Precautionary emergency controls.
461     bool public rebasePaused;
462     bool public tokenPaused;
463 
464     modifier whenRebaseNotPaused() {
465         require(!rebasePaused);
466         _;
467     }
468 
469     modifier whenTokenNotPaused() {
470         require(!tokenPaused);
471         _;
472     }
473 
474     modifier validRecipient(address to) {
475         require(to != address(0x0));
476         require(to != address(this));
477         _;
478     }
479 
480     uint256 private constant DECIMALS = 9;
481     uint256 private constant MAX_UINT256 = ~uint256(0);
482     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 3 * 10**6 * 10**DECIMALS;
483 
484     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
485     // Use the highest value that fits in a uint256 for max granularity.
486     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
487 
488     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
489     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
490 
491     uint256 private _totalSupply;
492     uint256 private _gonsPerFragment;
493     mapping(address => uint256) private _gonBalances;
494 
495     // This is denominated in Fragments, because the gons-fragments conversion might change before
496     // it's fully paid.
497     mapping (address => mapping (address => uint256)) private _allowedFragments;
498 
499     /**
500      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
501      */
502     function setMonetaryPolicy(address monetaryPolicy_)
503         external
504         onlyOwner
505     {
506         monetaryPolicy = monetaryPolicy_;
507         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
508     }
509 
510     /**
511      * @dev Pauses or unpauses the execution of rebase operations.
512      * @param paused Pauses rebase operations if this is true.
513      */
514     function setRebasePaused(bool paused)
515         external
516         onlyOwner
517     {
518         rebasePaused = paused;
519         emit LogRebasePaused(paused);
520     }
521 
522     /**
523      * @dev Pauses or unpauses execution of ERC-20 transactions.
524      * @param paused Pauses ERC-20 transactions if this is true.
525      */
526     function setTokenPaused(bool paused)
527         external
528         onlyOwner
529     {
530         tokenPaused = paused;
531         emit LogTokenPaused(paused);
532     }
533 
534     /**
535      * @dev Notifies Fragments contract about a new rebase cycle.
536      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
537      * @return The total number of fragments after the supply adjustment.
538      */
539     function rebase(uint256 epoch, int256 supplyDelta)
540         external
541         onlyMonetaryPolicy
542         whenRebaseNotPaused
543         returns (uint256)
544     {
545         if (supplyDelta == 0) {
546             emit LogRebase(epoch, _totalSupply);
547             return _totalSupply;
548         }
549 
550         if (supplyDelta < 0) {
551             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
552         } else {
553             _totalSupply = _totalSupply.add(uint256(supplyDelta));
554         }
555 
556         if (_totalSupply > MAX_SUPPLY) {
557             _totalSupply = MAX_SUPPLY;
558         }
559 
560         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
561 
562         // From this point forward, _gonsPerFragment is taken as the source of truth.
563         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
564         // conversion rate.
565         // This means our applied supplyDelta can deviate from the requested supplyDelta,
566         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
567         //
568         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
569         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
570         // ever increased, it must be re-included.
571         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
572 
573         emit LogRebase(epoch, _totalSupply);
574         return _totalSupply;
575     }
576 
577     function initialize(address owner_)
578         public
579         initializer
580     {
581         ERC20Detailed.initialize("Coil", "COIL", uint8(DECIMALS));
582         Ownable.initialize(owner_);
583 
584         rebasePaused = false;
585         tokenPaused = false;
586 
587         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
588         _gonBalances[owner_] = TOTAL_GONS;
589         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
590 
591         emit Transfer(address(0x0), owner_, _totalSupply);
592     }
593 
594     /**
595      * @return The total number of fragments.
596      */
597     function totalSupply()
598         public
599         view
600         returns (uint256)
601     {
602         return _totalSupply;
603     }
604 
605     /**
606      * @param who The address to query.
607      * @return The balance of the specified address.
608      */
609     function balanceOf(address who)
610         public
611         view
612         returns (uint256)
613     {
614         return _gonBalances[who].div(_gonsPerFragment);
615     }
616 
617     /**
618      * @dev Transfer tokens to a specified address.
619      * @param to The address to transfer to.
620      * @param value The amount to be transferred.
621      * @return True on success, false otherwise.
622      */
623     function transfer(address to, uint256 value)
624         public
625         validRecipient(to)
626         whenTokenNotPaused
627         returns (bool)
628     {
629         uint256 gonValue = value.mul(_gonsPerFragment);
630         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
631         _gonBalances[to] = _gonBalances[to].add(gonValue);
632         emit Transfer(msg.sender, to, value);
633         return true;
634     }
635 
636     /**
637      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
638      * @param owner_ The address which owns the funds.
639      * @param spender The address which will spend the funds.
640      * @return The number of tokens still available for the spender.
641      */
642     function allowance(address owner_, address spender)
643         public
644         view
645         returns (uint256)
646     {
647         return _allowedFragments[owner_][spender];
648     }
649 
650     /**
651      * @dev Transfer tokens from one address to another.
652      * @param from The address you want to send tokens from.
653      * @param to The address you want to transfer to.
654      * @param value The amount of tokens to be transferred.
655      */
656     function transferFrom(address from, address to, uint256 value)
657         public
658         validRecipient(to)
659         whenTokenNotPaused
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
685         whenTokenNotPaused
686         returns (bool)
687     {
688         _allowedFragments[msg.sender][spender] = value;
689         emit Approval(msg.sender, spender, value);
690         return true;
691     }
692 
693     /**
694      * @dev Increase the amount of tokens that an owner has allowed to a spender.
695      * This method should be used instead of approve() to avoid the double approval vulnerability
696      * described above.
697      * @param spender The address which will spend the funds.
698      * @param addedValue The amount of tokens to increase the allowance by.
699      */
700     function increaseAllowance(address spender, uint256 addedValue)
701         public
702         whenTokenNotPaused
703         returns (bool)
704     {
705         _allowedFragments[msg.sender][spender] =
706             _allowedFragments[msg.sender][spender].add(addedValue);
707         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
708         return true;
709     }
710 
711     /**
712      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
713      *
714      * @param spender The address which will spend the funds.
715      * @param subtractedValue The amount of tokens to decrease the allowance by.
716      */
717     function decreaseAllowance(address spender, uint256 subtractedValue)
718         public
719         whenTokenNotPaused
720         returns (bool)
721     {
722         uint256 oldValue = _allowedFragments[msg.sender][spender];
723         if (subtractedValue >= oldValue) {
724             _allowedFragments[msg.sender][spender] = 0;
725         } else {
726             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
727         }
728         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
729         return true;
730     }
731 }