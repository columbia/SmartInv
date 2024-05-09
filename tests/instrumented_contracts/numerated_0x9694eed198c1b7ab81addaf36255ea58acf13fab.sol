1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-17
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
40     bool wasInitializing = initializing;
41     initializing = true;
42     initialized = true;
43 
44     _;
45 
46     initializing = wasInitializing;
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
406   function initialize(string name, string symbol, uint8 decimals) public initializer {
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
436 // File: contracts/UFragments.sol
437 pragma solidity 0.4.24;
438 /**
439  * @title uFragments ERC20 token
440  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
441  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
442  *      combining tokens proportionally across all wallets.
443  *
444  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
445  *      We support splitting the currency in expansion and combining the currency on contraction by
446  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
447  */
448 contract UFragments is ERC20Detailed, Ownable {
449     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
450     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
451     // order to minimize this risk, we adhere to the following guidelines:
452     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
453     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
454     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
455     //    multiplying by the inverse rate, you should divide by the normal rate)
456     // 2) Gon balances converted into Fragments are always rounded down (truncated).
457     //
458     // We make the following guarantees:
459     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
460     //   be decreased by precisely x Fragments, and B's external balance will be precisely
461     //   increased by x Fragments.
462     //
463     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
464     // This is because, for any conversion function 'f()' that has non-zero rounding error,
465     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
466     using SafeMath for uint256;
467     using SafeMathInt for int256;
468 
469     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
470     event LogRebasePaused(bool paused);
471     event LogTokenPaused(bool paused);
472     event LogMonetaryPolicyUpdated(address monetaryPolicy);
473 
474     // Used for authentication
475     address public monetaryPolicy;
476 
477     modifier onlyMonetaryPolicy() {
478         require(msg.sender == monetaryPolicy);
479         _;
480     }
481 
482     // Precautionary emergency controls.
483     bool public rebasePaused;
484     bool public tokenPaused;
485 
486     modifier whenRebaseNotPaused() {
487         require(!rebasePaused);
488         _;
489     }
490 
491     modifier whenTokenNotPaused() {
492         require(!tokenPaused);
493         _;
494     }
495 
496     modifier validRecipient(address to) {
497         require(to != address(0x0));
498         require(to != address(this));
499         _;
500     }
501 
502     uint256 private constant DECIMALS = 9;
503     uint256 private constant MAX_UINT256 = ~uint256(0);
504     // uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 50 * 10**6 * 10**DECIMALS;
505 
506     //初始值500万代币
507     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 50 * 10**5 * 10**DECIMALS;
508 
509     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
510     // Use the highest value that fits in a uint256 for max granularity.
511     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
512 
513     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
514     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
515 
516     uint256 private _totalSupply;
517     uint256 private _gonsPerFragment;
518     mapping(address => uint256) private _gonBalances;
519 
520     // This is denominated in Fragments, because the gons-fragments conversion might change before
521     // it's fully paid.
522     mapping (address => mapping (address => uint256)) private _allowedFragments;
523 
524     /**
525      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
526      */
527     function setMonetaryPolicy(address monetaryPolicy_)
528         external
529         onlyOwner
530     {
531         monetaryPolicy = monetaryPolicy_;
532         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
533     }
534 
535     /**
536      * @dev Pauses or unpauses the execution of rebase operations.
537      * @param paused Pauses rebase operations if this is true.
538      */
539     function setRebasePaused(bool paused)
540         external
541         onlyOwner
542     {
543         rebasePaused = paused;
544         emit LogRebasePaused(paused);
545     }
546 
547     /**
548      * @dev Pauses or unpauses execution of ERC-20 transactions.
549      * @param paused Pauses ERC-20 transactions if this is true.
550      */
551     function setTokenPaused(bool paused)
552         external
553         onlyOwner
554     {
555         tokenPaused = paused;
556         emit LogTokenPaused(paused);
557     }
558 
559     /**
560      * @dev Notifies Fragments contract about a new rebase cycle.
561      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
562      * @return The total number of fragments after the supply adjustment.
563      */
564     function rebase(uint256 epoch, int256 supplyDelta)
565         external
566         onlyMonetaryPolicy
567         whenRebaseNotPaused
568         returns (uint256)
569     {
570         if (supplyDelta == 0) {
571             emit LogRebase(epoch, _totalSupply);
572             return _totalSupply;
573         }
574 
575         if (supplyDelta < 0) {
576             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
577         } else {
578             _totalSupply = _totalSupply.add(uint256(supplyDelta));
579         }
580 
581         if (_totalSupply > MAX_SUPPLY) {
582             _totalSupply = MAX_SUPPLY;
583         }
584 
585         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
586 
587         // From this point forward, _gonsPerFragment is taken as the source of truth.
588         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
589         // conversion rate.
590         // This means our applied supplyDelta can deviate from the requested supplyDelta,
591         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
592         //
593         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
594         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
595         // ever increased, it must be re-included.
596         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
597 
598         emit LogRebase(epoch, _totalSupply);
599         return _totalSupply;
600     }
601 
602     function initialize(address owner_)
603         public
604         initializer
605     {
606         ERC20Detailed.initialize("DoubleHelix", "DHX", uint8(DECIMALS));
607         Ownable.initialize(owner_);
608 
609         rebasePaused = false;
610         tokenPaused = false;
611 
612         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
613         _gonBalances[owner_] = TOTAL_GONS;
614         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
615 
616         emit Transfer(address(0x0), owner_, _totalSupply);
617     }
618 
619     /**
620      * @return The total number of fragments.
621      */
622     function totalSupply()
623         public
624         view
625         returns (uint256)
626     {
627         return _totalSupply;
628     }
629 
630     /**
631      * @param who The address to query.
632      * @return The balance of the specified address.
633      */
634     function balanceOf(address who)
635         public
636         view
637         returns (uint256)
638     {
639         return _gonBalances[who].div(_gonsPerFragment);
640     }
641 
642     /**
643      * @dev Transfer tokens to a specified address.
644      * @param to The address to transfer to.
645      * @param value The amount to be transferred.
646      * @return True on success, false otherwise.
647      */
648     function transfer(address to, uint256 value)
649         public
650         validRecipient(to)
651         whenTokenNotPaused
652         returns (bool)
653     {
654         uint256 gonValue = value.mul(_gonsPerFragment);
655         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
656         _gonBalances[to] = _gonBalances[to].add(gonValue);
657         emit Transfer(msg.sender, to, value);
658         return true;
659     }
660 
661     /**
662      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
663      * @param owner_ The address which owns the funds.
664      * @param spender The address which will spend the funds.
665      * @return The number of tokens still available for the spender.
666      */
667     function allowance(address owner_, address spender)
668         public
669         view
670         returns (uint256)
671     {
672         return _allowedFragments[owner_][spender];
673     }
674 
675     /**
676      * @dev Transfer tokens from one address to another.
677      * @param from The address you want to send tokens from.
678      * @param to The address you want to transfer to.
679      * @param value The amount of tokens to be transferred.
680      */
681     function transferFrom(address from, address to, uint256 value)
682         public
683         validRecipient(to)
684         whenTokenNotPaused
685         returns (bool)
686     {
687         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
688 
689         uint256 gonValue = value.mul(_gonsPerFragment);
690         _gonBalances[from] = _gonBalances[from].sub(gonValue);
691         _gonBalances[to] = _gonBalances[to].add(gonValue);
692         emit Transfer(from, to, value);
693 
694         return true;
695     }
696 
697     /**
698      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
699      * msg.sender. This method is included for ERC20 compatibility.
700      * increaseAllowance and decreaseAllowance should be used instead.
701      * Changing an allowance with this method brings the risk that someone may transfer both
702      * the old and the new allowance - if they are both greater than zero - if a transfer
703      * transaction is mined before the later approve() call is mined.
704      *
705      * @param spender The address which will spend the funds.
706      * @param value The amount of tokens to be spent.
707      */
708     function approve(address spender, uint256 value)
709         public
710         whenTokenNotPaused
711         returns (bool)
712     {
713         _allowedFragments[msg.sender][spender] = value;
714         emit Approval(msg.sender, spender, value);
715         return true;
716     }
717 
718     /**
719      * @dev Increase the amount of tokens that an owner has allowed to a spender.
720      * This method should be used instead of approve() to avoid the double approval vulnerability
721      * described above.
722      * @param spender The address which will spend the funds.
723      * @param addedValue The amount of tokens to increase the allowance by.
724      */
725     function increaseAllowance(address spender, uint256 addedValue)
726         public
727         whenTokenNotPaused
728         returns (bool)
729     {
730         _allowedFragments[msg.sender][spender] =
731             _allowedFragments[msg.sender][spender].add(addedValue);
732         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
733         return true;
734     }
735 
736     /**
737      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
738      *
739      * @param spender The address which will spend the funds.
740      * @param subtractedValue The amount of tokens to decrease the allowance by.
741      */
742     function decreaseAllowance(address spender, uint256 subtractedValue)
743         public
744         whenTokenNotPaused
745         returns (bool)
746     {
747         uint256 oldValue = _allowedFragments[msg.sender][spender];
748         if (subtractedValue >= oldValue) {
749             _allowedFragments[msg.sender][spender] = 0;
750         } else {
751             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
752         }
753         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
754         return true;
755     }
756 }