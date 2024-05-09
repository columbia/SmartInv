1 pragma solidity ^0.4.24;
2 
3 /**
4  *      _               _               _ _       _    
5  *     | |             | |             | (_)     | |   
6  *  ___| |__   __ _  __| | _____      _| |_ _ __ | | __
7  * / __| '_ \ / _` |/ _` |/ _ \ \ /\ / / | | '_ \| |/ /
8  * \__ \ | | | (_| | (_| | (_) \ V  V /| | | | | |   < 
9  * |___/_| |_|\__,_|\__,_|\___/ \_/\_(_)_|_|_| |_|_|\_\
10  *
11  *      
12  * 
13 **/
14  // 
15 // File: openzeppelin-eth/contracts/math/SafeMath.sol
16 //
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that revert on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, reverts on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (a == 0) {
31       return 0;
32     }
33 
34     uint256 c = a * b;
35     require(c / a == b);
36 
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     require(b > 0); // Solidity only automatically asserts when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48     return c;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     require(b <= a);
56     uint256 c = a - b;
57 
58     return c;
59   }
60 
61   /**
62   * @dev Adds two numbers, reverts on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     require(c >= a);
67 
68     return c;
69   }
70 
71   /**
72   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
73   * reverts when dividing by zero.
74   */
75   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76     require(b != 0);
77     return a % b;
78   }
79 }
80 
81 // File: zos-lib/contracts/Initializable.sol
82 
83 pragma solidity >=0.4.24 <0.6.0;
84 
85 
86 /**
87  * @title Initializable
88  *
89  * @dev Helper contract to support initializer functions. To use it, replace
90  * the constructor with a function that has the `initializer` modifier.
91  * WARNING: Unlike constructors, initializer functions must be manually
92  * invoked. This applies both to deploying an Initializable contract, as well
93  * as extending an Initializable contract via inheritance.
94  * WARNING: When used with inheritance, manual care must be taken to not invoke
95  * a parent initializer twice, or ensure that all initializers are idempotent,
96  * because this is not dealt with automatically as with constructors.
97  */
98 contract Initializable {
99 
100   /**
101    * @dev Indicates that the contract has been initialized.
102    */
103   bool private initialized;
104 
105   /**
106    * @dev Indicates that the contract is in the process of being initialized.
107    */
108   bool private initializing;
109 
110   /**
111    * @dev Modifier to use in the initializer function of a contract.
112    */
113   modifier initializer() {
114     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
115 
116     bool wasInitializing = initializing;
117     initializing = true;
118     initialized = true;
119 
120     _;
121 
122     initializing = wasInitializing;
123   }
124 
125   /// @dev Returns true if and only if the function is running in the constructor
126   function isConstructor() private view returns (bool) {
127     // extcodesize checks the size of the code stored in an address, and
128     // address returns the current address. Since the code is still not
129     // deployed when running a constructor, any checks on its code size will
130     // yield zero, making it an effective way to detect if a contract is
131     // under construction or not.
132     uint256 cs;
133     assembly { cs := extcodesize(address) }
134     return cs == 0;
135   }
136 
137   // Reserved storage space to allow for layout changes in the future.
138   uint256[50] private ______gap;
139 }
140 
141 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
142 
143 pragma solidity ^0.4.24;
144 
145 
146 /**
147  * @title Ownable
148  * @dev The Ownable contract has an owner address, and provides basic authorization control
149  * functions, this simplifies the implementation of "user permissions".
150  */
151 contract Ownable is Initializable {
152   address private _owner;
153 
154 
155   event OwnershipRenounced(address indexed previousOwner);
156   event OwnershipTransferred(
157     address indexed previousOwner,
158     address indexed newOwner
159   );
160 
161 
162   /**
163    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
164    * account.
165    */
166   function initialize(address sender) public initializer {
167     _owner = sender;
168   }
169 
170   /**
171    * @return the address of the owner.
172    */
173   function owner() public view returns(address) {
174     return _owner;
175   }
176 
177   /**
178    * @dev Throws if called by any account other than the owner.
179    */
180   modifier onlyOwner() {
181     require(isOwner());
182     _;
183   }
184 
185   /**
186    * @return true if `msg.sender` is the owner of the contract.
187    */
188   function isOwner() public view returns(bool) {
189     return msg.sender == _owner;
190   }
191 
192   /**
193    * @dev Allows the current owner to relinquish control of the contract.
194    * @notice Renouncing to ownership will leave the contract without an owner.
195    * It will not be possible to call the functions with the `onlyOwner`
196    * modifier anymore.
197    */
198   function renounceOwnership() public onlyOwner {
199     emit OwnershipRenounced(_owner);
200     _owner = address(0);
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     _transferOwnership(newOwner);
209   }
210 
211   /**
212    * @dev Transfers control of the contract to a newOwner.
213    * @param newOwner The address to transfer ownership to.
214    */
215   function _transferOwnership(address newOwner) internal {
216     require(newOwner != address(0));
217     emit OwnershipTransferred(_owner, newOwner);
218     _owner = newOwner;
219   }
220 
221   uint256[50] private ______gap;
222 }
223 
224 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
225 
226 pragma solidity ^0.4.24;
227 
228 
229 /**
230  * @title ERC20 interface
231  * @dev see https://github.com/ethereum/EIPs/issues/20
232  */
233 interface IERC20 {
234   function totalSupply() external view returns (uint256);
235 
236   function balanceOf(address who) external view returns (uint256);
237 
238   function allowance(address owner, address spender)
239     external view returns (uint256);
240 
241   function transfer(address to, uint256 value) external returns (bool);
242 
243   function approve(address spender, uint256 value)
244     external returns (bool);
245 
246   function transferFrom(address from, address to, uint256 value)
247     external returns (bool);
248 
249   event Transfer(
250     address indexed from,
251     address indexed to,
252     uint256 value
253   );
254 
255   event Approval(
256     address indexed owner,
257     address indexed spender,
258     uint256 value
259   );
260 }
261 
262 // File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol
263 
264 pragma solidity ^0.4.24;
265 
266 /**
267  * @title ERC20Detailed token
268  * @dev The decimals are only for visualization purposes.
269  * All the operations are done using the smallest and indivisible token unit,
270  * just as on Ethereum all the operations are done in wei.
271  */
272 contract ERC20Detailed is Initializable, IERC20 {
273   string private _name;
274   string private _symbol;
275   uint8 private _decimals;
276 
277   function initialize(string name, string symbol, uint8 decimals) public initializer {
278     _name = name;
279     _symbol = symbol;
280     _decimals = decimals;
281   }
282 
283   /**
284    * @return the name of the token.
285    */
286   function name() public view returns(string) {
287     return _name;
288   }
289 
290   /**
291    * @return the symbol of the token.
292    */
293   function symbol() public view returns(string) {
294     return _symbol;
295   }
296 
297   /**
298    * @return the number of decimals of the token.
299    */
300   function decimals() public view returns(uint8) {
301     return _decimals;
302   }
303 
304   uint256[50] private ______gap;
305 }
306 
307 // File: contracts/lib/SafeMathInt.sol
308 
309 /*
310 MIT License
311 
312 Copyright (c) 2018 requestnetwork
313 Copyright (c) 2018 Fragments, Inc.
314 
315 Permission is hereby granted, free of charge, to any person obtaining a copy
316 of this software and associated documentation files (the "Software"), to deal
317 in the Software without restriction, including without limitation the rights
318 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
319 copies of the Software, and to permit persons to whom the Software is
320 furnished to do so, subject to the following conditions:
321 
322 The above copyright notice and this permission notice shall be included in all
323 copies or substantial portions of the Software.
324 
325 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
326 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
327 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
328 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
329 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
330 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
331 SOFTWARE.
332 */
333 
334 pragma solidity 0.4.24;
335 
336 
337 /**
338  * @title SafeMathInt
339  * @dev Math operations for int256 with overflow safety checks.
340  */
341 library SafeMathInt {
342     int256 private constant MIN_INT256 = int256(1) << 255;
343     int256 private constant MAX_INT256 = ~(int256(1) << 255);
344 
345     /**
346      * @dev Multiplies two int256 variables and fails on overflow.
347      */
348     function mul(int256 a, int256 b)
349         internal
350         pure
351         returns (int256)
352     {
353         int256 c = a * b;
354 
355         // Detect overflow when multiplying MIN_INT256 with -1
356         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
357         require((b == 0) || (c / b == a));
358         return c;
359     }
360 
361     /**
362      * @dev Division of two int256 variables and fails on overflow.
363      */
364     function div(int256 a, int256 b)
365         internal
366         pure
367         returns (int256)
368     {
369         // Prevent overflow when dividing MIN_INT256 by -1
370         require(b != -1 || a != MIN_INT256);
371 
372         // Solidity already throws when dividing by 0.
373         return a / b;
374     }
375 
376     /**
377      * @dev Subtracts two int256 variables and fails on overflow.
378      */
379     function sub(int256 a, int256 b)
380         internal
381         pure
382         returns (int256)
383     {
384         int256 c = a - b;
385         require((b >= 0 && c <= a) || (b < 0 && c > a));
386         return c;
387     }
388 
389     /**
390      * @dev Adds two int256 variables and fails on overflow.
391      */
392     function add(int256 a, int256 b)
393         internal
394         pure
395         returns (int256)
396     {
397         int256 c = a + b;
398         require((b >= 0 && c >= a) || (b < 0 && c < a));
399         return c;
400     }
401 
402     /**
403      * @dev Converts to absolute value, and fails on overflow.
404      */
405     function abs(int256 a)
406         internal
407         pure
408         returns (int256)
409     {
410         require(a != MIN_INT256);
411         return a < 0 ? -a : a;
412     }
413 }
414 
415 // File: contracts/UFragments.sol
416 
417 pragma solidity 0.4.24;
418 
419 /**
420  * @title uFragments ERC20 token
421  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
422  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
423  *      combining tokens proportionally across all wallets.
424  *
425  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
426  *      We support splitting the currency in expansion and combining the currency on contraction by
427  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
428  */
429 contract UFragments is ERC20Detailed, Ownable {
430     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
431     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
432     // order to minimize this risk, we adhere to the following guidelines:
433     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
434     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
435     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
436     //    multiplying by the inverse rate, you should divide by the normal rate)
437     // 2) Gon balances converted into Fragments are always rounded down (truncated).
438     //
439     // We make the following guarantees:
440     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
441     //   be decreased by precisely x Fragments, and B's external balance will be precisely
442     //   increased by x Fragments.
443     //
444     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
445     // This is because, for any conversion function 'f()' that has non-zero rounding error,
446     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
447     using SafeMath for uint256;
448     using SafeMathInt for int256;
449 
450     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
451     event LogRebasePaused(bool paused);
452     event LogTokenPaused(bool paused);
453     event LogMonetaryPolicyUpdated(address monetaryPolicy);
454 
455     // Used for authentication
456     address public monetaryPolicy;
457 
458     modifier onlyMonetaryPolicy() {
459         require(msg.sender == monetaryPolicy);
460         _;
461     }
462 
463     // Precautionary emergency controls.
464     bool public rebasePaused;
465     bool public tokenPaused;
466 
467     modifier whenRebaseNotPaused() {
468         require(!rebasePaused);
469         _;
470     }
471 
472     modifier whenTokenNotPaused() {
473         require(!tokenPaused);
474         _;
475     }
476 
477     modifier validRecipient(address to) {
478         require(to != address(0x0));
479         require(to != address(this));
480         _;
481     }
482 
483     uint256 private constant DECIMALS = 9;
484     uint256 private constant MAX_UINT256 = ~uint256(0);
485     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 8.5 * 10**4 * 10**DECIMALS;
486 
487     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
488     // Use the highest value that fits in a uint256 for max granularity.
489     uint256 private constant TOTAL_GONS = MAX_UINT256 -
490         (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
491 
492     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
493     uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
494 
495     uint256 private _totalSupply;
496     uint256 private _gonsPerFragment;
497     mapping(address => uint256) private _gonBalances;
498 
499     // This is denominated in Fragments, because the gons-fragments conversion might change before
500     // it's fully paid.
501     mapping(address => mapping(address => uint256)) private _allowedFragments;
502 
503     /**
504      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
505      */
506     function setMonetaryPolicy(address monetaryPolicy_) external onlyOwner {
507         monetaryPolicy = monetaryPolicy_;
508         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
509     }
510 
511     /**
512      * @dev Pauses or unpauses the execution of rebase operations.
513      * @param paused Pauses rebase operations if this is true.
514      */
515     function setRebasePaused(bool paused) external onlyOwner {
516         rebasePaused = paused;
517         emit LogRebasePaused(paused);
518     }
519 
520     /**
521      * @dev Pauses or unpauses execution of ERC-20 transactions.
522      * @param paused Pauses ERC-20 transactions if this is true.
523      */
524     function setTokenPaused(bool paused) external onlyOwner {
525         tokenPaused = paused;
526         emit LogTokenPaused(paused);
527     }
528 
529     /**
530      * @dev Notifies Fragments contract about a new rebase cycle.
531      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
532      * @return The total number of fragments after the supply adjustment.
533      */
534     function rebase(uint256 epoch, int256 supplyDelta)
535         external
536         onlyMonetaryPolicy
537         whenRebaseNotPaused
538         returns (uint256)
539     {
540         if (supplyDelta == 0) {
541             emit LogRebase(epoch, _totalSupply);
542             return _totalSupply;
543         }
544 
545         if (supplyDelta < 0) {
546             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
547         } else {
548             _totalSupply = _totalSupply.add(uint256(supplyDelta));
549         }
550 
551         if (_totalSupply > MAX_SUPPLY) {
552             _totalSupply = MAX_SUPPLY;
553         }
554 
555         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
556 
557         // From this point forward, _gonsPerFragment is taken as the source of truth.
558         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
559         // conversion rate.
560         // This means our applied supplyDelta can deviate from the requested supplyDelta,
561         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
562         //
563         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
564         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
565         // ever increased, it must be re-included.
566         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
567 
568         emit LogRebase(epoch, _totalSupply);
569         return _totalSupply;
570     }
571 
572     function initialize(address owner_) public initializer {
573         ERC20Detailed.initialize("Shadow Link", "SHADOW", uint8(DECIMALS));
574         Ownable.initialize(owner_);
575 
576         rebasePaused = false;
577         tokenPaused = false;
578 
579         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
580         _gonBalances[owner_] = TOTAL_GONS;
581         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
582 
583         emit Transfer(address(0x0), owner_, _totalSupply);
584     }
585 
586     /**
587      * @return The total number of fragments.
588      */
589     function totalSupply() public view returns (uint256) {
590         return _totalSupply;
591     }
592 
593     /**
594      * @param who The address to query.
595      * @return The balance of the specified address.
596      */
597     function balanceOf(address who) public view returns (uint256) {
598         return _gonBalances[who].div(_gonsPerFragment);
599     }
600 
601     /**
602      * @dev Transfer tokens to a specified address.
603      * @param to The address to transfer to.
604      * @param value The amount to be transferred.
605      * @return True on success, false otherwise.
606      */
607     function transfer(address to, uint256 value)
608         public
609         validRecipient(to)
610         whenTokenNotPaused
611         returns (bool)
612     {
613         uint256 gonValue = value.mul(_gonsPerFragment);
614         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
615         _gonBalances[to] = _gonBalances[to].add(gonValue);
616         emit Transfer(msg.sender, to, value);
617         return true;
618     }
619 
620     /**
621      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
622      * @param owner_ The address which owns the funds.
623      * @param spender The address which will spend the funds.
624      * @return The number of tokens still available for the spender.
625      */
626     function allowance(address owner_, address spender)
627         public
628         view
629         returns (uint256)
630     {
631         return _allowedFragments[owner_][spender];
632     }
633 
634     /**
635      * @dev Transfer tokens from one address to another.
636      * @param from The address you want to send tokens from.
637      * @param to The address you want to transfer to.
638      * @param value The amount of tokens to be transferred.
639      */
640     function transferFrom(
641         address from,
642         address to,
643         uint256 value
644     ) public validRecipient(to) whenTokenNotPaused returns (bool) {
645         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg
646             .sender]
647             .sub(value);
648 
649         uint256 gonValue = value.mul(_gonsPerFragment);
650         _gonBalances[from] = _gonBalances[from].sub(gonValue);
651         _gonBalances[to] = _gonBalances[to].add(gonValue);
652         emit Transfer(from, to, value);
653 
654         return true;
655     }
656 
657     /**
658      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
659      * msg.sender. This method is included for ERC20 compatibility.
660      * increaseAllowance and decreaseAllowance should be used instead.
661      * Changing an allowance with this method brings the risk that someone may transfer both
662      * the old and the new allowance - if they are both greater than zero - if a transfer
663      * transaction is mined before the later approve() call is mined.
664      *
665      * @param spender The address which will spend the funds.
666      * @param value The amount of tokens to be spent.
667      */
668     function approve(address spender, uint256 value)
669         public
670         whenTokenNotPaused
671         returns (bool)
672     {
673         _allowedFragments[msg.sender][spender] = value;
674         emit Approval(msg.sender, spender, value);
675         return true;
676     }
677 
678     /**
679      * @dev Increase the amount of tokens that an owner has allowed to a spender.
680      * This method should be used instead of approve() to avoid the double approval vulnerability
681      * described above.
682      * @param spender The address which will spend the funds.
683      * @param addedValue The amount of tokens to increase the allowance by.
684      */
685     function increaseAllowance(address spender, uint256 addedValue)
686         public
687         whenTokenNotPaused
688         returns (bool)
689     {
690         _allowedFragments[msg.sender][spender] = _allowedFragments[msg
691             .sender][spender]
692             .add(addedValue);
693         emit Approval(
694             msg.sender,
695             spender,
696             _allowedFragments[msg.sender][spender]
697         );
698         return true;
699     }
700 
701     /**
702      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
703      *
704      * @param spender The address which will spend the funds.
705      * @param subtractedValue The amount of tokens to decrease the allowance by.
706      */
707     function decreaseAllowance(address spender, uint256 subtractedValue)
708         public
709         whenTokenNotPaused
710         returns (bool)
711     {
712         uint256 oldValue = _allowedFragments[msg.sender][spender];
713         if (subtractedValue >= oldValue) {
714             _allowedFragments[msg.sender][spender] = 0;
715         } else {
716             _allowedFragments[msg.sender][spender] = oldValue.sub(
717                 subtractedValue
718             );
719         }
720         emit Approval(
721             msg.sender,
722             spender,
723             _allowedFragments[msg.sender][spender]
724         );
725         return true;
726     }
727 }