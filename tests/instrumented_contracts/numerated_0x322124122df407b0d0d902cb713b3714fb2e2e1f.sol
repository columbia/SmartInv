1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-05
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 // File: openzeppelin-eth/contracts/math/SafeMath.sol
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that revert on error
13  */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, reverts on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21     // benefit is lost if 'b' is also tested.
22     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23     if (a == 0) {
24       return 0;
25     }
26 
27     uint256 c = a * b;
28     require(c / a == b);
29 
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b > 0); // Solidity only automatically asserts when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40 
41     return c;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b <= a);
49     uint256 c = a - b;
50 
51     return c;
52   }
53 
54   /**
55   * @dev Adds two numbers, reverts on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     require(c >= a);
60 
61     return c;
62   }
63 
64   /**
65   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
66   * reverts when dividing by zero.
67   */
68   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b != 0);
70     return a % b;
71   }
72 }
73 
74 // File: zos-lib/contracts/Initializable.sol
75 
76 pragma solidity >=0.4.24 <0.6.0;
77 
78 
79 /**
80  * @title Initializable
81  *
82  * @dev Helper contract to support initializer functions. To use it, replace
83  * the constructor with a function that has the `initializer` modifier.
84  * WARNING: Unlike constructors, initializer functions must be manually
85  * invoked. This applies both to deploying an Initializable contract, as well
86  * as extending an Initializable contract via inheritance.
87  * WARNING: When used with inheritance, manual care must be taken to not invoke
88  * a parent initializer twice, or ensure that all initializers are idempotent,
89  * because this is not dealt with automatically as with constructors.
90  */
91 contract Initializable {
92 
93   /**
94    * @dev Indicates that the contract has been initialized.
95    */
96   bool private initialized;
97 
98   /**
99    * @dev Indicates that the contract is in the process of being initialized.
100    */
101   bool private initializing;
102 
103   /**
104    * @dev Modifier to use in the initializer function of a contract.
105    */
106   modifier initializer() {
107     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
108 
109     bool wasInitializing = initializing;
110     initializing = true;
111     initialized = true;
112 
113     _;
114 
115     initializing = wasInitializing;
116   }
117 
118   /// @dev Returns true if and only if the function is running in the constructor
119   function isConstructor() private view returns (bool) {
120     // extcodesize checks the size of the code stored in an address, and
121     // address returns the current address. Since the code is still not
122     // deployed when running a constructor, any checks on its code size will
123     // yield zero, making it an effective way to detect if a contract is
124     // under construction or not.
125     uint256 cs;
126     assembly { cs := extcodesize(address) }
127     return cs == 0;
128   }
129 
130   // Reserved storage space to allow for layout changes in the future.
131   uint256[50] private ______gap;
132 }
133 
134 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
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
217 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
218 
219 pragma solidity ^0.4.24;
220 
221 
222 /**
223  * @title ERC20 interface
224  * @dev see https://github.com/ethereum/EIPs/issues/20
225  */
226 interface IERC20 {
227   function totalSupply() external view returns (uint256);
228 
229   function balanceOf(address who) external view returns (uint256);
230 
231   function allowance(address owner, address spender)
232     external view returns (uint256);
233 
234   function transfer(address to, uint256 value) external returns (bool);
235 
236   function approve(address spender, uint256 value)
237     external returns (bool);
238 
239   function transferFrom(address from, address to, uint256 value)
240     external returns (bool);
241 
242   event Transfer(
243     address indexed from,
244     address indexed to,
245     uint256 value
246   );
247 
248   event Approval(
249     address indexed owner,
250     address indexed spender,
251     uint256 value
252   );
253 }
254 
255 // File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol
256 
257 pragma solidity ^0.4.24;
258 
259 
260 
261 
262 /**
263  * @title ERC20Detailed token
264  * @dev The decimals are only for visualization purposes.
265  * All the operations are done using the smallest and indivisible token unit,
266  * just as on Ethereum all the operations are done in wei.
267  */
268 contract ERC20Detailed is Initializable, IERC20 {
269   string private _name;
270   string private _symbol;
271   uint8 private _decimals;
272 
273   function initialize(string name, string symbol, uint8 decimals) public initializer {
274     _name = name;
275     _symbol = symbol;
276     _decimals = decimals;
277   }
278 
279   /**
280    * @return the name of the token.
281    */
282   function name() public view returns(string) {
283     return _name;
284   }
285 
286   /**
287    * @return the symbol of the token.
288    */
289   function symbol() public view returns(string) {
290     return _symbol;
291   }
292 
293   /**
294    * @return the number of decimals of the token.
295    */
296   function decimals() public view returns(uint8) {
297     return _decimals;
298   }
299 
300   uint256[50] private ______gap;
301 }
302 
303 // File: contracts/lib/SafeMathInt.sol
304 
305 /*
306 MIT License
307 
308 Copyright (c) 2018 requestnetwork
309 Copyright (c) 2018 Fragments, Inc.
310 
311 Permission is hereby granted, free of charge, to any person obtaining a copy
312 of this software and associated documentation files (the "Software"), to deal
313 in the Software without restriction, including without limitation the rights
314 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
315 copies of the Software, and to permit persons to whom the Software is
316 furnished to do so, subject to the following conditions:
317 
318 The above copyright notice and this permission notice shall be included in all
319 copies or substantial portions of the Software.
320 
321 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
322 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
323 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
324 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
325 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
326 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
327 SOFTWARE.
328 */
329 
330 pragma solidity 0.4.24;
331 
332 
333 /**
334  * @title SafeMathInt
335  * @dev Math operations for int256 with overflow safety checks.
336  */
337 library SafeMathInt {
338     int256 private constant MIN_INT256 = int256(1) << 255;
339     int256 private constant MAX_INT256 = ~(int256(1) << 255);
340 
341     /**
342      * @dev Multiplies two int256 variables and fails on overflow.
343      */
344     function mul(int256 a, int256 b)
345         internal
346         pure
347         returns (int256)
348     {
349         int256 c = a * b;
350 
351         // Detect overflow when multiplying MIN_INT256 with -1
352         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
353         require((b == 0) || (c / b == a));
354         return c;
355     }
356 
357     /**
358      * @dev Division of two int256 variables and fails on overflow.
359      */
360     function div(int256 a, int256 b)
361         internal
362         pure
363         returns (int256)
364     {
365         // Prevent overflow when dividing MIN_INT256 by -1
366         require(b != -1 || a != MIN_INT256);
367 
368         // Solidity already throws when dividing by 0.
369         return a / b;
370     }
371 
372     /**
373      * @dev Subtracts two int256 variables and fails on overflow.
374      */
375     function sub(int256 a, int256 b)
376         internal
377         pure
378         returns (int256)
379     {
380         int256 c = a - b;
381         require((b >= 0 && c <= a) || (b < 0 && c > a));
382         return c;
383     }
384 
385     /**
386      * @dev Adds two int256 variables and fails on overflow.
387      */
388     function add(int256 a, int256 b)
389         internal
390         pure
391         returns (int256)
392     {
393         int256 c = a + b;
394         require((b >= 0 && c >= a) || (b < 0 && c < a));
395         return c;
396     }
397 
398     /**
399      * @dev Converts to absolute value, and fails on overflow.
400      */
401     function abs(int256 a)
402         internal
403         pure
404         returns (int256)
405     {
406         require(a != MIN_INT256);
407         return a < 0 ? -a : a;
408     }
409 }
410 
411 // File: contracts/UFragments.sol
412 
413 pragma solidity 0.4.24;
414 
415 /**
416  * @title uFragments ERC20 token
417  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
418  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
419  *      combining tokens proportionally across all wallets.
420  *
421  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
422  *      We support splitting the currency in expansion and combining the currency on contraction by
423  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
424  */
425 contract UFragments is ERC20Detailed, Ownable {
426     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
427     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
428     // order to minimize this risk, we adhere to the following guidelines:
429     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
430     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
431     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
432     //    multiplying by the inverse rate, you should divide by the normal rate)
433     // 2) Gon balances converted into Fragments are always rounded down (truncated).
434     //
435     // We make the following guarantees:
436     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
437     //   be decreased by precisely x Fragments, and B's external balance will be precisely
438     //   increased by x Fragments.
439     //
440     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
441     // This is because, for any conversion function 'f()' that has non-zero rounding error,
442     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
443     using SafeMath for uint256;
444     using SafeMathInt for int256;
445 
446     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
447     event LogRebasePaused(bool paused);
448     event LogTokenPaused(bool paused);
449     event LogMonetaryPolicyUpdated(address monetaryPolicy);
450 
451     // Used for authentication
452     address public monetaryPolicy;
453 
454     modifier onlyMonetaryPolicy() {
455         require(msg.sender == monetaryPolicy);
456         _;
457     }
458 
459     // Precautionary emergency controls.
460     bool public rebasePaused;
461     bool public tokenPaused;
462 
463     modifier whenRebaseNotPaused() {
464         require(!rebasePaused);
465         _;
466     }
467 
468     modifier whenTokenNotPaused() {
469         require(!tokenPaused);
470         _;
471     }
472 
473     modifier validRecipient(address to) {
474         require(to != address(0x0));
475         require(to != address(this));
476         _;
477     }
478 
479     uint256 private constant DECIMALS = 9;
480     uint256 private constant MAX_UINT256 = ~uint256(0);
481     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 6 * (10**4) * (10**DECIMALS);
482 
483     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
484     // Use the highest value that fits in a uint256 for max granularity.
485     uint256 private constant TOTAL_GONS = MAX_UINT256 -
486         (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
487 
488     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
489     uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
490 
491     uint256 private _totalSupply;
492     uint256 private _gonsPerFragment;
493     mapping(address => uint256) private _gonBalances;
494 
495     // This is denominated in Fragments, because the gons-fragments conversion might change before
496     // it's fully paid.
497     mapping(address => mapping(address => uint256)) private _allowedFragments;
498 
499     /**
500      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
501      */
502     function setMonetaryPolicy(address monetaryPolicy_) external onlyOwner {
503         monetaryPolicy = monetaryPolicy_;
504         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
505     }
506 
507     /**
508      * @dev Pauses or unpauses the execution of rebase operations.
509      * @param paused Pauses rebase operations if this is true.
510      */
511     function setRebasePaused(bool paused) external onlyOwner {
512         rebasePaused = paused;
513         emit LogRebasePaused(paused);
514     }
515 
516     /**
517      * @dev Pauses or unpauses execution of ERC-20 transactions.
518      * @param paused Pauses ERC-20 transactions if this is true.
519      */
520     function setTokenPaused(bool paused) external onlyOwner {
521         tokenPaused = paused;
522         emit LogTokenPaused(paused);
523     }
524 
525     /**
526      * @dev Notifies Fragments contract about a new rebase cycle.
527      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
528      * @return The total number of fragments after the supply adjustment.
529      */
530     function rebase(uint256 epoch, int256 supplyDelta)
531         external
532         onlyMonetaryPolicy
533         whenRebaseNotPaused
534         returns (uint256)
535     {
536         if (supplyDelta == 0) {
537             emit LogRebase(epoch, _totalSupply);
538             return _totalSupply;
539         }
540 
541         if (supplyDelta < 0) {
542             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
543         } else {
544             _totalSupply = _totalSupply.add(uint256(supplyDelta));
545         }
546 
547         if (_totalSupply > MAX_SUPPLY) {
548             _totalSupply = MAX_SUPPLY;
549         }
550 
551         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
552 
553         // From this point forward, _gonsPerFragment is taken as the source of truth.
554         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
555         // conversion rate.
556         // This means our applied supplyDelta can deviate from the requested supplyDelta,
557         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
558         //
559         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
560         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
561         // ever increased, it must be re-included.
562         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
563 
564         emit LogRebase(epoch, _totalSupply);
565         return _totalSupply;
566     }
567 
568     function initialize(address owner_) public initializer {
569         ERC20Detailed.initialize("Soft Yearn Finance", "SYFI", uint8(DECIMALS));
570         Ownable.initialize(owner_);
571 
572         rebasePaused = false;
573         tokenPaused = false;
574 
575         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
576         _gonBalances[owner_] = TOTAL_GONS;
577         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
578 
579         emit Transfer(address(0x0), owner_, _totalSupply);
580     }
581 
582     /**
583      * @return The total number of fragments.
584      */
585     function totalSupply() public view returns (uint256) {
586         return _totalSupply;
587     }
588 
589     /**
590      * @param who The address to query.
591      * @return The balance of the specified address.
592      */
593     function balanceOf(address who) public view returns (uint256) {
594         return _gonBalances[who].div(_gonsPerFragment);
595     }
596 
597     /**
598      * @dev Transfer tokens to a specified address.
599      * @param to The address to transfer to.
600      * @param value The amount to be transferred.
601      * @return True on success, false otherwise.
602      */
603     function transfer(address to, uint256 value)
604         public
605         validRecipient(to)
606         whenTokenNotPaused
607         returns (bool)
608     {
609         uint256 gonValue = value.mul(_gonsPerFragment);
610         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
611         _gonBalances[to] = _gonBalances[to].add(gonValue);
612         emit Transfer(msg.sender, to, value);
613         return true;
614     }
615 
616     /**
617      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
618      * @param owner_ The address which owns the funds.
619      * @param spender The address which will spend the funds.
620      * @return The number of tokens still available for the spender.
621      */
622     function allowance(address owner_, address spender)
623         public
624         view
625         returns (uint256)
626     {
627         return _allowedFragments[owner_][spender];
628     }
629 
630     /**
631      * @dev Transfer tokens from one address to another.
632      * @param from The address you want to send tokens from.
633      * @param to The address you want to transfer to.
634      * @param value The amount of tokens to be transferred.
635      */
636     function transferFrom(
637         address from,
638         address to,
639         uint256 value
640     ) public validRecipient(to) whenTokenNotPaused returns (bool) {
641         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg
642             .sender]
643             .sub(value);
644 
645         uint256 gonValue = value.mul(_gonsPerFragment);
646         _gonBalances[from] = _gonBalances[from].sub(gonValue);
647         _gonBalances[to] = _gonBalances[to].add(gonValue);
648         emit Transfer(from, to, value);
649 
650         return true;
651     }
652 
653     /**
654      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
655      * msg.sender. This method is included for ERC20 compatibility.
656      * increaseAllowance and decreaseAllowance should be used instead.
657      * Changing an allowance with this method brings the risk that someone may transfer both
658      * the old and the new allowance - if they are both greater than zero - if a transfer
659      * transaction is mined before the later approve() call is mined.
660      *
661      * @param spender The address which will spend the funds.
662      * @param value The amount of tokens to be spent.
663      */
664     function approve(address spender, uint256 value)
665         public
666         whenTokenNotPaused
667         returns (bool)
668     {
669         _allowedFragments[msg.sender][spender] = value;
670         emit Approval(msg.sender, spender, value);
671         return true;
672     }
673 
674     /**
675      * @dev Increase the amount of tokens that an owner has allowed to a spender.
676      * This method should be used instead of approve() to avoid the double approval vulnerability
677      * described above.
678      * @param spender The address which will spend the funds.
679      * @param addedValue The amount of tokens to increase the allowance by.
680      */
681     function increaseAllowance(address spender, uint256 addedValue)
682         public
683         whenTokenNotPaused
684         returns (bool)
685     {
686         _allowedFragments[msg.sender][spender] = _allowedFragments[msg
687             .sender][spender]
688             .add(addedValue);
689         emit Approval(
690             msg.sender,
691             spender,
692             _allowedFragments[msg.sender][spender]
693         );
694         return true;
695     }
696 
697     /**
698      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
699      *
700      * @param spender The address which will spend the funds.
701      * @param subtractedValue The amount of tokens to decrease the allowance by.
702      */
703     function decreaseAllowance(address spender, uint256 subtractedValue)
704         public
705         whenTokenNotPaused
706         returns (bool)
707     {
708         uint256 oldValue = _allowedFragments[msg.sender][spender];
709         if (subtractedValue >= oldValue) {
710             _allowedFragments[msg.sender][spender] = 0;
711         } else {
712             _allowedFragments[msg.sender][spender] = oldValue.sub(
713                 subtractedValue
714             );
715         }
716         emit Approval(
717             msg.sender,
718             spender,
719             _allowedFragments[msg.sender][spender]
720         );
721         return true;
722     }
723 }