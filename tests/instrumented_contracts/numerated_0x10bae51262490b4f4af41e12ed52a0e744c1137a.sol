1 pragma solidity ^0.4.24;
2 
3 /**
4  *    A Chainlink pegged base-money that is
5  *  adaptive, transparent, and community-driven.
6  *           _      _____ _   _ _  __
7  *          | |    |_   _| \ | | |/ /
8  *       ___| |      | | |  \| | ' / 
9  *      / __| |      | | | . ` |  <  
10  *      \__ \ |____ _| |_| |\  | . \ 
11  *      |___/______|_____|_| \_|_|\_\
12  *                              
13  *         https://slink.finance/
14  * 
15 **/
16                               
17 // File: openzeppelin-eth/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that revert on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, reverts on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     uint256 c = a * b;
37     require(c / a == b);
38 
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     require(b > 0); // Solidity only automatically asserts when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 
50     return c;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     require(b <= a);
58     uint256 c = a - b;
59 
60     return c;
61   }
62 
63   /**
64   * @dev Adds two numbers, reverts on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     require(c >= a);
69 
70     return c;
71   }
72 
73   /**
74   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
75   * reverts when dividing by zero.
76   */
77   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b != 0);
79     return a % b;
80   }
81 }
82 
83 // File: zos-lib/contracts/Initializable.sol
84 
85 pragma solidity >=0.4.24 <0.6.0;
86 
87 
88 /**
89  * @title Initializable
90  *
91  * @dev Helper contract to support initializer functions. To use it, replace
92  * the constructor with a function that has the `initializer` modifier.
93  * WARNING: Unlike constructors, initializer functions must be manually
94  * invoked. This applies both to deploying an Initializable contract, as well
95  * as extending an Initializable contract via inheritance.
96  * WARNING: When used with inheritance, manual care must be taken to not invoke
97  * a parent initializer twice, or ensure that all initializers are idempotent,
98  * because this is not dealt with automatically as with constructors.
99  */
100 contract Initializable {
101 
102   /**
103    * @dev Indicates that the contract has been initialized.
104    */
105   bool private initialized;
106 
107   /**
108    * @dev Indicates that the contract is in the process of being initialized.
109    */
110   bool private initializing;
111 
112   /**
113    * @dev Modifier to use in the initializer function of a contract.
114    */
115   modifier initializer() {
116     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
117 
118     bool wasInitializing = initializing;
119     initializing = true;
120     initialized = true;
121 
122     _;
123 
124     initializing = wasInitializing;
125   }
126 
127   /// @dev Returns true if and only if the function is running in the constructor
128   function isConstructor() private view returns (bool) {
129     // extcodesize checks the size of the code stored in an address, and
130     // address returns the current address. Since the code is still not
131     // deployed when running a constructor, any checks on its code size will
132     // yield zero, making it an effective way to detect if a contract is
133     // under construction or not.
134     uint256 cs;
135     assembly { cs := extcodesize(address) }
136     return cs == 0;
137   }
138 
139   // Reserved storage space to allow for layout changes in the future.
140   uint256[50] private ______gap;
141 }
142 
143 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
144 
145 pragma solidity ^0.4.24;
146 
147 
148 /**
149  * @title Ownable
150  * @dev The Ownable contract has an owner address, and provides basic authorization control
151  * functions, this simplifies the implementation of "user permissions".
152  */
153 contract Ownable is Initializable {
154   address private _owner;
155 
156 
157   event OwnershipRenounced(address indexed previousOwner);
158   event OwnershipTransferred(
159     address indexed previousOwner,
160     address indexed newOwner
161   );
162 
163 
164   /**
165    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
166    * account.
167    */
168   function initialize(address sender) public initializer {
169     _owner = sender;
170   }
171 
172   /**
173    * @return the address of the owner.
174    */
175   function owner() public view returns(address) {
176     return _owner;
177   }
178 
179   /**
180    * @dev Throws if called by any account other than the owner.
181    */
182   modifier onlyOwner() {
183     require(isOwner());
184     _;
185   }
186 
187   /**
188    * @return true if `msg.sender` is the owner of the contract.
189    */
190   function isOwner() public view returns(bool) {
191     return msg.sender == _owner;
192   }
193 
194   /**
195    * @dev Allows the current owner to relinquish control of the contract.
196    * @notice Renouncing to ownership will leave the contract without an owner.
197    * It will not be possible to call the functions with the `onlyOwner`
198    * modifier anymore.
199    */
200   function renounceOwnership() public onlyOwner {
201     emit OwnershipRenounced(_owner);
202     _owner = address(0);
203   }
204 
205   /**
206    * @dev Allows the current owner to transfer control of the contract to a newOwner.
207    * @param newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address newOwner) public onlyOwner {
210     _transferOwnership(newOwner);
211   }
212 
213   /**
214    * @dev Transfers control of the contract to a newOwner.
215    * @param newOwner The address to transfer ownership to.
216    */
217   function _transferOwnership(address newOwner) internal {
218     require(newOwner != address(0));
219     emit OwnershipTransferred(_owner, newOwner);
220     _owner = newOwner;
221   }
222 
223   uint256[50] private ______gap;
224 }
225 
226 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
227 
228 pragma solidity ^0.4.24;
229 
230 
231 /**
232  * @title ERC20 interface
233  * @dev see https://github.com/ethereum/EIPs/issues/20
234  */
235 interface IERC20 {
236   function totalSupply() external view returns (uint256);
237 
238   function balanceOf(address who) external view returns (uint256);
239 
240   function allowance(address owner, address spender)
241     external view returns (uint256);
242 
243   function transfer(address to, uint256 value) external returns (bool);
244 
245   function approve(address spender, uint256 value)
246     external returns (bool);
247 
248   function transferFrom(address from, address to, uint256 value)
249     external returns (bool);
250 
251   event Transfer(
252     address indexed from,
253     address indexed to,
254     uint256 value
255   );
256 
257   event Approval(
258     address indexed owner,
259     address indexed spender,
260     uint256 value
261   );
262 }
263 
264 // File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol
265 
266 pragma solidity ^0.4.24;
267 
268 /**
269  * @title ERC20Detailed token
270  * @dev The decimals are only for visualization purposes.
271  * All the operations are done using the smallest and indivisible token unit,
272  * just as on Ethereum all the operations are done in wei.
273  */
274 contract ERC20Detailed is Initializable, IERC20 {
275   string private _name;
276   string private _symbol;
277   uint8 private _decimals;
278 
279   function initialize(string name, string symbol, uint8 decimals) public initializer {
280     _name = name;
281     _symbol = symbol;
282     _decimals = decimals;
283   }
284 
285   /**
286    * @return the name of the token.
287    */
288   function name() public view returns(string) {
289     return _name;
290   }
291 
292   /**
293    * @return the symbol of the token.
294    */
295   function symbol() public view returns(string) {
296     return _symbol;
297   }
298 
299   /**
300    * @return the number of decimals of the token.
301    */
302   function decimals() public view returns(uint8) {
303     return _decimals;
304   }
305 
306   uint256[50] private ______gap;
307 }
308 
309 // File: contracts/lib/SafeMathInt.sol
310 
311 /*
312 MIT License
313 
314 Copyright (c) 2018 requestnetwork
315 Copyright (c) 2018 Fragments, Inc.
316 
317 Permission is hereby granted, free of charge, to any person obtaining a copy
318 of this software and associated documentation files (the "Software"), to deal
319 in the Software without restriction, including without limitation the rights
320 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
321 copies of the Software, and to permit persons to whom the Software is
322 furnished to do so, subject to the following conditions:
323 
324 The above copyright notice and this permission notice shall be included in all
325 copies or substantial portions of the Software.
326 
327 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
328 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
329 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
330 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
331 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
332 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
333 SOFTWARE.
334 */
335 
336 pragma solidity 0.4.24;
337 
338 
339 /**
340  * @title SafeMathInt
341  * @dev Math operations for int256 with overflow safety checks.
342  */
343 library SafeMathInt {
344     int256 private constant MIN_INT256 = int256(1) << 255;
345     int256 private constant MAX_INT256 = ~(int256(1) << 255);
346 
347     /**
348      * @dev Multiplies two int256 variables and fails on overflow.
349      */
350     function mul(int256 a, int256 b)
351         internal
352         pure
353         returns (int256)
354     {
355         int256 c = a * b;
356 
357         // Detect overflow when multiplying MIN_INT256 with -1
358         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
359         require((b == 0) || (c / b == a));
360         return c;
361     }
362 
363     /**
364      * @dev Division of two int256 variables and fails on overflow.
365      */
366     function div(int256 a, int256 b)
367         internal
368         pure
369         returns (int256)
370     {
371         // Prevent overflow when dividing MIN_INT256 by -1
372         require(b != -1 || a != MIN_INT256);
373 
374         // Solidity already throws when dividing by 0.
375         return a / b;
376     }
377 
378     /**
379      * @dev Subtracts two int256 variables and fails on overflow.
380      */
381     function sub(int256 a, int256 b)
382         internal
383         pure
384         returns (int256)
385     {
386         int256 c = a - b;
387         require((b >= 0 && c <= a) || (b < 0 && c > a));
388         return c;
389     }
390 
391     /**
392      * @dev Adds two int256 variables and fails on overflow.
393      */
394     function add(int256 a, int256 b)
395         internal
396         pure
397         returns (int256)
398     {
399         int256 c = a + b;
400         require((b >= 0 && c >= a) || (b < 0 && c < a));
401         return c;
402     }
403 
404     /**
405      * @dev Converts to absolute value, and fails on overflow.
406      */
407     function abs(int256 a)
408         internal
409         pure
410         returns (int256)
411     {
412         require(a != MIN_INT256);
413         return a < 0 ? -a : a;
414     }
415 }
416 
417 // File: contracts/UFragments.sol
418 
419 pragma solidity 0.4.24;
420 
421 /**
422  * @title uFragments ERC20 token
423  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
424  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
425  *      combining tokens proportionally across all wallets.
426  *
427  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
428  *      We support splitting the currency in expansion and combining the currency on contraction by
429  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
430  */
431 contract UFragments is ERC20Detailed, Ownable {
432     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
433     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
434     // order to minimize this risk, we adhere to the following guidelines:
435     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
436     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
437     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
438     //    multiplying by the inverse rate, you should divide by the normal rate)
439     // 2) Gon balances converted into Fragments are always rounded down (truncated).
440     //
441     // We make the following guarantees:
442     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
443     //   be decreased by precisely x Fragments, and B's external balance will be precisely
444     //   increased by x Fragments.
445     //
446     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
447     // This is because, for any conversion function 'f()' that has non-zero rounding error,
448     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
449     using SafeMath for uint256;
450     using SafeMathInt for int256;
451 
452     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
453     event LogRebasePaused(bool paused);
454     event LogTokenPaused(bool paused);
455     event LogMonetaryPolicyUpdated(address monetaryPolicy);
456 
457     // Used for authentication
458     address public monetaryPolicy;
459 
460     modifier onlyMonetaryPolicy() {
461         require(msg.sender == monetaryPolicy);
462         _;
463     }
464 
465     // Precautionary emergency controls.
466     bool public rebasePaused;
467     bool public tokenPaused;
468 
469     modifier whenRebaseNotPaused() {
470         require(!rebasePaused);
471         _;
472     }
473 
474     modifier whenTokenNotPaused() {
475         require(!tokenPaused);
476         _;
477     }
478 
479     modifier validRecipient(address to) {
480         require(to != address(0x0));
481         require(to != address(this));
482         _;
483     }
484 
485     uint256 private constant DECIMALS = 9;
486     uint256 private constant MAX_UINT256 = ~uint256(0);
487     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 25 * 10**4 * 10**DECIMALS;
488 
489     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
490     // Use the highest value that fits in a uint256 for max granularity.
491     uint256 private constant TOTAL_GONS = MAX_UINT256 -
492         (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
493 
494     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
495     uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
496 
497     uint256 private _totalSupply;
498     uint256 private _gonsPerFragment;
499     mapping(address => uint256) private _gonBalances;
500 
501     // This is denominated in Fragments, because the gons-fragments conversion might change before
502     // it's fully paid.
503     mapping(address => mapping(address => uint256)) private _allowedFragments;
504 
505     /**
506      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
507      */
508     function setMonetaryPolicy(address monetaryPolicy_) external onlyOwner {
509         monetaryPolicy = monetaryPolicy_;
510         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
511     }
512 
513     /**
514      * @dev Pauses or unpauses the execution of rebase operations.
515      * @param paused Pauses rebase operations if this is true.
516      */
517     function setRebasePaused(bool paused) external onlyOwner {
518         rebasePaused = paused;
519         emit LogRebasePaused(paused);
520     }
521 
522     /**
523      * @dev Pauses or unpauses execution of ERC-20 transactions.
524      * @param paused Pauses ERC-20 transactions if this is true.
525      */
526     function setTokenPaused(bool paused) external onlyOwner {
527         tokenPaused = paused;
528         emit LogTokenPaused(paused);
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
539         whenRebaseNotPaused
540         returns (uint256)
541     {
542         if (supplyDelta == 0) {
543             emit LogRebase(epoch, _totalSupply);
544             return _totalSupply;
545         }
546 
547         if (supplyDelta < 0) {
548             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
549         } else {
550             _totalSupply = _totalSupply.add(uint256(supplyDelta));
551         }
552 
553         if (_totalSupply > MAX_SUPPLY) {
554             _totalSupply = MAX_SUPPLY;
555         }
556 
557         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
558 
559         // From this point forward, _gonsPerFragment is taken as the source of truth.
560         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
561         // conversion rate.
562         // This means our applied supplyDelta can deviate from the requested supplyDelta,
563         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
564         //
565         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
566         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
567         // ever increased, it must be re-included.
568         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
569 
570         emit LogRebase(epoch, _totalSupply);
571         return _totalSupply;
572     }
573 
574     function initialize(address owner_) public initializer {
575         ERC20Detailed.initialize("Soft Link", "SLINK", uint8(DECIMALS));
576         Ownable.initialize(owner_);
577 
578         rebasePaused = false;
579         tokenPaused = false;
580 
581         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
582         _gonBalances[owner_] = TOTAL_GONS;
583         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
584 
585         emit Transfer(address(0x0), owner_, _totalSupply);
586     }
587 
588     /**
589      * @return The total number of fragments.
590      */
591     function totalSupply() public view returns (uint256) {
592         return _totalSupply;
593     }
594 
595     /**
596      * @param who The address to query.
597      * @return The balance of the specified address.
598      */
599     function balanceOf(address who) public view returns (uint256) {
600         return _gonBalances[who].div(_gonsPerFragment);
601     }
602 
603     /**
604      * @dev Transfer tokens to a specified address.
605      * @param to The address to transfer to.
606      * @param value The amount to be transferred.
607      * @return True on success, false otherwise.
608      */
609     function transfer(address to, uint256 value)
610         public
611         validRecipient(to)
612         whenTokenNotPaused
613         returns (bool)
614     {
615         uint256 gonValue = value.mul(_gonsPerFragment);
616         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
617         _gonBalances[to] = _gonBalances[to].add(gonValue);
618         emit Transfer(msg.sender, to, value);
619         return true;
620     }
621 
622     /**
623      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
624      * @param owner_ The address which owns the funds.
625      * @param spender The address which will spend the funds.
626      * @return The number of tokens still available for the spender.
627      */
628     function allowance(address owner_, address spender)
629         public
630         view
631         returns (uint256)
632     {
633         return _allowedFragments[owner_][spender];
634     }
635 
636     /**
637      * @dev Transfer tokens from one address to another.
638      * @param from The address you want to send tokens from.
639      * @param to The address you want to transfer to.
640      * @param value The amount of tokens to be transferred.
641      */
642     function transferFrom(
643         address from,
644         address to,
645         uint256 value
646     ) public validRecipient(to) whenTokenNotPaused returns (bool) {
647         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg
648             .sender]
649             .sub(value);
650 
651         uint256 gonValue = value.mul(_gonsPerFragment);
652         _gonBalances[from] = _gonBalances[from].sub(gonValue);
653         _gonBalances[to] = _gonBalances[to].add(gonValue);
654         emit Transfer(from, to, value);
655 
656         return true;
657     }
658 
659     /**
660      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
661      * msg.sender. This method is included for ERC20 compatibility.
662      * increaseAllowance and decreaseAllowance should be used instead.
663      * Changing an allowance with this method brings the risk that someone may transfer both
664      * the old and the new allowance - if they are both greater than zero - if a transfer
665      * transaction is mined before the later approve() call is mined.
666      *
667      * @param spender The address which will spend the funds.
668      * @param value The amount of tokens to be spent.
669      */
670     function approve(address spender, uint256 value)
671         public
672         whenTokenNotPaused
673         returns (bool)
674     {
675         _allowedFragments[msg.sender][spender] = value;
676         emit Approval(msg.sender, spender, value);
677         return true;
678     }
679 
680     /**
681      * @dev Increase the amount of tokens that an owner has allowed to a spender.
682      * This method should be used instead of approve() to avoid the double approval vulnerability
683      * described above.
684      * @param spender The address which will spend the funds.
685      * @param addedValue The amount of tokens to increase the allowance by.
686      */
687     function increaseAllowance(address spender, uint256 addedValue)
688         public
689         whenTokenNotPaused
690         returns (bool)
691     {
692         _allowedFragments[msg.sender][spender] = _allowedFragments[msg
693             .sender][spender]
694             .add(addedValue);
695         emit Approval(
696             msg.sender,
697             spender,
698             _allowedFragments[msg.sender][spender]
699         );
700         return true;
701     }
702 
703     /**
704      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
705      *
706      * @param spender The address which will spend the funds.
707      * @param subtractedValue The amount of tokens to decrease the allowance by.
708      */
709     function decreaseAllowance(address spender, uint256 subtractedValue)
710         public
711         whenTokenNotPaused
712         returns (bool)
713     {
714         uint256 oldValue = _allowedFragments[msg.sender][spender];
715         if (subtractedValue >= oldValue) {
716             _allowedFragments[msg.sender][spender] = 0;
717         } else {
718             _allowedFragments[msg.sender][spender] = oldValue.sub(
719                 subtractedValue
720             );
721         }
722         emit Approval(
723             msg.sender,
724             spender,
725             _allowedFragments[msg.sender][spender]
726         );
727         return true;
728     }
729 }