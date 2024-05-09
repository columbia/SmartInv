1 /*
2  * Origin Protocol
3  * https://originprotocol.com
4  *
5  * Released under the MIT license
6  * https://github.com/OriginProtocol/origin-dollar
7  *
8  * Copyright 2020 Origin Protocol, Inc
9  *
10  * Permission is hereby granted, free of charge, to any person obtaining a copy
11  * of this software and associated documentation files (the "Software"), to deal
12  * in the Software without restriction, including without limitation the rights
13  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14  * copies of the Software, and to permit persons to whom the Software is
15  * furnished to do so, subject to the following conditions:
16  *
17  * The above copyright notice and this permission notice shall be included in
18  * all copies or substantial portions of the Software.
19  *
20  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
23  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
24  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
26  * SOFTWARE.
27  */
28 // File: contracts/governance/Governable.sol
29 
30 pragma solidity 0.5.11;
31 
32 /**
33  * @title OUSD Governable Contract
34  * @dev Copy of the openzeppelin Ownable.sol contract with nomenclature change
35  *      from owner to governor and renounce methods removed. Does not use
36  *      Context.sol like Ownable.sol does for simplification.
37  * @author Origin Protocol Inc
38  */
39 contract Governable {
40     // Storage position of the owner and pendingOwner of the contract
41     // keccak256("OUSD.governor");
42     bytes32
43         private constant governorPosition = 0x7bea13895fa79d2831e0a9e28edede30099005a50d652d8957cf8a607ee6ca4a;
44 
45     // keccak256("OUSD.pending.governor");
46     bytes32
47         private constant pendingGovernorPosition = 0x44c4d30b2eaad5130ad70c3ba6972730566f3e6359ab83e800d905c61b1c51db;
48 
49     // keccak256("OUSD.reentry.status");
50     bytes32
51         private constant reentryStatusPosition = 0x53bf423e48ed90e97d02ab0ebab13b2a235a6bfbe9c321847d5c175333ac4535;
52 
53     // See OpenZeppelin ReentrancyGuard implementation
54     uint256 constant _NOT_ENTERED = 1;
55     uint256 constant _ENTERED = 2;
56 
57     event PendingGovernorshipTransfer(
58         address indexed previousGovernor,
59         address indexed newGovernor
60     );
61 
62     event GovernorshipTransferred(
63         address indexed previousGovernor,
64         address indexed newGovernor
65     );
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial Governor.
69      */
70     constructor() internal {
71         _setGovernor(msg.sender);
72         emit GovernorshipTransferred(address(0), _governor());
73     }
74 
75     /**
76      * @dev Returns the address of the current Governor.
77      */
78     function governor() public view returns (address) {
79         return _governor();
80     }
81 
82     /**
83      * @dev Returns the address of the current Governor.
84      */
85     function _governor() internal view returns (address governorOut) {
86         bytes32 position = governorPosition;
87         assembly {
88             governorOut := sload(position)
89         }
90     }
91 
92     /**
93      * @dev Returns the address of the pending Governor.
94      */
95     function _pendingGovernor()
96         internal
97         view
98         returns (address pendingGovernor)
99     {
100         bytes32 position = pendingGovernorPosition;
101         assembly {
102             pendingGovernor := sload(position)
103         }
104     }
105 
106     /**
107      * @dev Throws if called by any account other than the Governor.
108      */
109     modifier onlyGovernor() {
110         require(isGovernor(), "Caller is not the Governor");
111         _;
112     }
113 
114     /**
115      * @dev Returns true if the caller is the current Governor.
116      */
117     function isGovernor() public view returns (bool) {
118         return msg.sender == _governor();
119     }
120 
121     function _setGovernor(address newGovernor) internal {
122         bytes32 position = governorPosition;
123         assembly {
124             sstore(position, newGovernor)
125         }
126     }
127 
128     /**
129      * @dev Prevents a contract from calling itself, directly or indirectly.
130      * Calling a `nonReentrant` function from another `nonReentrant`
131      * function is not supported. It is possible to prevent this from happening
132      * by making the `nonReentrant` function external, and make it call a
133      * `private` function that does the actual work.
134      */
135     modifier nonReentrant() {
136         bytes32 position = reentryStatusPosition;
137         uint256 _reentry_status;
138         assembly {
139             _reentry_status := sload(position)
140         }
141 
142         // On the first call to nonReentrant, _notEntered will be true
143         require(_reentry_status != _ENTERED, "Reentrant call");
144 
145         // Any calls to nonReentrant after this point will fail
146         assembly {
147             sstore(position, _ENTERED)
148         }
149 
150         _;
151 
152         // By storing the original value once again, a refund is triggered (see
153         // https://eips.ethereum.org/EIPS/eip-2200)
154         assembly {
155             sstore(position, _NOT_ENTERED)
156         }
157     }
158 
159     function _setPendingGovernor(address newGovernor) internal {
160         bytes32 position = pendingGovernorPosition;
161         assembly {
162             sstore(position, newGovernor)
163         }
164     }
165 
166     /**
167      * @dev Transfers Governance of the contract to a new account (`newGovernor`).
168      * Can only be called by the current Governor. Must be claimed for this to complete
169      * @param _newGovernor Address of the new Governor
170      */
171     function transferGovernance(address _newGovernor) external onlyGovernor {
172         _setPendingGovernor(_newGovernor);
173         emit PendingGovernorshipTransfer(_governor(), _newGovernor);
174     }
175 
176     /**
177      * @dev Claim Governance of the contract to a new account (`newGovernor`).
178      * Can only be called by the new Governor.
179      */
180     function claimGovernance() external {
181         require(
182             msg.sender == _pendingGovernor(),
183             "Only the pending Governor can complete the claim"
184         );
185         _changeGovernor(msg.sender);
186     }
187 
188     /**
189      * @dev Change Governance of the contract to a new account (`newGovernor`).
190      * @param _newGovernor Address of the new Governor
191      */
192     function _changeGovernor(address _newGovernor) internal {
193         require(_newGovernor != address(0), "New Governor is address(0)");
194         emit GovernorshipTransferred(_governor(), _newGovernor);
195         _setGovernor(_newGovernor);
196     }
197 }
198 
199 // File: @openzeppelin/contracts/math/SafeMath.sol
200 
201 pragma solidity ^0.5.0;
202 
203 /**
204  * @dev Wrappers over Solidity's arithmetic operations with added overflow
205  * checks.
206  *
207  * Arithmetic operations in Solidity wrap on overflow. This can easily result
208  * in bugs, because programmers usually assume that an overflow raises an
209  * error, which is the standard behavior in high level programming languages.
210  * `SafeMath` restores this intuition by reverting the transaction when an
211  * operation overflows.
212  *
213  * Using this library instead of the unchecked operations eliminates an entire
214  * class of bugs, so it's recommended to use it always.
215  */
216 library SafeMath {
217     /**
218      * @dev Returns the addition of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `+` operator.
222      *
223      * Requirements:
224      * - Addition cannot overflow.
225      */
226     function add(uint256 a, uint256 b) internal pure returns (uint256) {
227         uint256 c = a + b;
228         require(c >= a, "SafeMath: addition overflow");
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the subtraction of two unsigned integers, reverting on
235      * overflow (when the result is negative).
236      *
237      * Counterpart to Solidity's `-` operator.
238      *
239      * Requirements:
240      * - Subtraction cannot overflow.
241      */
242     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243         return sub(a, b, "SafeMath: subtraction overflow");
244     }
245 
246     /**
247      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
248      * overflow (when the result is negative).
249      *
250      * Counterpart to Solidity's `-` operator.
251      *
252      * Requirements:
253      * - Subtraction cannot overflow.
254      *
255      * _Available since v2.4.0._
256      */
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         uint256 c = a - b;
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the multiplication of two unsigned integers, reverting on
266      * overflow.
267      *
268      * Counterpart to Solidity's `*` operator.
269      *
270      * Requirements:
271      * - Multiplication cannot overflow.
272      */
273     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
275         // benefit is lost if 'b' is also tested.
276         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
277         if (a == 0) {
278             return 0;
279         }
280 
281         uint256 c = a * b;
282         require(c / a == b, "SafeMath: multiplication overflow");
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers. Reverts on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
299         return div(a, b, "SafeMath: division by zero");
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
304      * division by zero. The result is rounded towards zero.
305      *
306      * Counterpart to Solidity's `/` operator. Note: this function uses a
307      * `revert` opcode (which leaves remaining gas untouched) while Solidity
308      * uses an invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      * - The divisor cannot be zero.
312      *
313      * _Available since v2.4.0._
314      */
315     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         // Solidity only automatically asserts when dividing by 0
317         require(b > 0, errorMessage);
318         uint256 c = a / b;
319         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
320 
321         return c;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * Reverts when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         return mod(a, b, "SafeMath: modulo by zero");
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * Reverts with custom message when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      * - The divisor cannot be zero.
349      *
350      * _Available since v2.4.0._
351      */
352     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
353         require(b != 0, errorMessage);
354         return a % b;
355     }
356 }
357 
358 // File: @openzeppelin/upgrades/contracts/Initializable.sol
359 
360 pragma solidity >=0.4.24 <0.7.0;
361 
362 
363 /**
364  * @title Initializable
365  *
366  * @dev Helper contract to support initializer functions. To use it, replace
367  * the constructor with a function that has the `initializer` modifier.
368  * WARNING: Unlike constructors, initializer functions must be manually
369  * invoked. This applies both to deploying an Initializable contract, as well
370  * as extending an Initializable contract via inheritance.
371  * WARNING: When used with inheritance, manual care must be taken to not invoke
372  * a parent initializer twice, or ensure that all initializers are idempotent,
373  * because this is not dealt with automatically as with constructors.
374  */
375 contract Initializable {
376 
377   /**
378    * @dev Indicates that the contract has been initialized.
379    */
380   bool private initialized;
381 
382   /**
383    * @dev Indicates that the contract is in the process of being initialized.
384    */
385   bool private initializing;
386 
387   /**
388    * @dev Modifier to use in the initializer function of a contract.
389    */
390   modifier initializer() {
391     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
392 
393     bool isTopLevelCall = !initializing;
394     if (isTopLevelCall) {
395       initializing = true;
396       initialized = true;
397     }
398 
399     _;
400 
401     if (isTopLevelCall) {
402       initializing = false;
403     }
404   }
405 
406   /// @dev Returns true if and only if the function is running in the constructor
407   function isConstructor() private view returns (bool) {
408     // extcodesize checks the size of the code stored in an address, and
409     // address returns the current address. Since the code is still not
410     // deployed when running a constructor, any checks on its code size will
411     // yield zero, making it an effective way to detect if a contract is
412     // under construction or not.
413     address self = address(this);
414     uint256 cs;
415     assembly { cs := extcodesize(self) }
416     return cs == 0;
417   }
418 
419   // Reserved storage space to allow for layout changes in the future.
420   uint256[50] private ______gap;
421 }
422 
423 // File: @openzeppelin/contracts/utils/Address.sol
424 
425 pragma solidity ^0.5.5;
426 
427 /**
428  * @dev Collection of functions related to the address type
429  */
430 library Address {
431     /**
432      * @dev Returns true if `account` is a contract.
433      *
434      * [IMPORTANT]
435      * ====
436      * It is unsafe to assume that an address for which this function returns
437      * false is an externally-owned account (EOA) and not a contract.
438      *
439      * Among others, `isContract` will return false for the following 
440      * types of addresses:
441      *
442      *  - an externally-owned account
443      *  - a contract in construction
444      *  - an address where a contract will be created
445      *  - an address where a contract lived, but was destroyed
446      * ====
447      */
448     function isContract(address account) internal view returns (bool) {
449         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
450         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
451         // for accounts without code, i.e. `keccak256('')`
452         bytes32 codehash;
453         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
454         // solhint-disable-next-line no-inline-assembly
455         assembly { codehash := extcodehash(account) }
456         return (codehash != accountHash && codehash != 0x0);
457     }
458 
459     /**
460      * @dev Converts an `address` into `address payable`. Note that this is
461      * simply a type cast: the actual underlying value is not changed.
462      *
463      * _Available since v2.4.0._
464      */
465     function toPayable(address account) internal pure returns (address payable) {
466         return address(uint160(account));
467     }
468 
469     /**
470      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
471      * `recipient`, forwarding all available gas and reverting on errors.
472      *
473      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
474      * of certain opcodes, possibly making contracts go over the 2300 gas limit
475      * imposed by `transfer`, making them unable to receive funds via
476      * `transfer`. {sendValue} removes this limitation.
477      *
478      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
479      *
480      * IMPORTANT: because control is transferred to `recipient`, care must be
481      * taken to not create reentrancy vulnerabilities. Consider using
482      * {ReentrancyGuard} or the
483      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
484      *
485      * _Available since v2.4.0._
486      */
487     function sendValue(address payable recipient, uint256 amount) internal {
488         require(address(this).balance >= amount, "Address: insufficient balance");
489 
490         // solhint-disable-next-line avoid-call-value
491         (bool success, ) = recipient.call.value(amount)("");
492         require(success, "Address: unable to send value, recipient may have reverted");
493     }
494 }
495 
496 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
497 
498 pragma solidity ^0.5.0;
499 
500 /**
501  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
502  * the optional functions; to access them see {ERC20Detailed}.
503  */
504 interface IERC20 {
505     /**
506      * @dev Returns the amount of tokens in existence.
507      */
508     function totalSupply() external view returns (uint256);
509 
510     /**
511      * @dev Returns the amount of tokens owned by `account`.
512      */
513     function balanceOf(address account) external view returns (uint256);
514 
515     /**
516      * @dev Moves `amount` tokens from the caller's account to `recipient`.
517      *
518      * Returns a boolean value indicating whether the operation succeeded.
519      *
520      * Emits a {Transfer} event.
521      */
522     function transfer(address recipient, uint256 amount) external returns (bool);
523 
524     /**
525      * @dev Returns the remaining number of tokens that `spender` will be
526      * allowed to spend on behalf of `owner` through {transferFrom}. This is
527      * zero by default.
528      *
529      * This value changes when {approve} or {transferFrom} are called.
530      */
531     function allowance(address owner, address spender) external view returns (uint256);
532 
533     /**
534      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
535      *
536      * Returns a boolean value indicating whether the operation succeeded.
537      *
538      * IMPORTANT: Beware that changing an allowance with this method brings the risk
539      * that someone may use both the old and the new allowance by unfortunate
540      * transaction ordering. One possible solution to mitigate this race
541      * condition is to first reduce the spender's allowance to 0 and set the
542      * desired value afterwards:
543      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
544      *
545      * Emits an {Approval} event.
546      */
547     function approve(address spender, uint256 amount) external returns (bool);
548 
549     /**
550      * @dev Moves `amount` tokens from `sender` to `recipient` using the
551      * allowance mechanism. `amount` is then deducted from the caller's
552      * allowance.
553      *
554      * Returns a boolean value indicating whether the operation succeeded.
555      *
556      * Emits a {Transfer} event.
557      */
558     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
559 
560     /**
561      * @dev Emitted when `value` tokens are moved from one account (`from`) to
562      * another (`to`).
563      *
564      * Note that `value` may be zero.
565      */
566     event Transfer(address indexed from, address indexed to, uint256 value);
567 
568     /**
569      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
570      * a call to {approve}. `value` is the new allowance.
571      */
572     event Approval(address indexed owner, address indexed spender, uint256 value);
573 }
574 
575 // File: contracts/utils/InitializableERC20Detailed.sol
576 
577 pragma solidity 0.5.11;
578 
579 /**
580  * @dev Optional functions from the ERC20 standard.
581  * Converted from openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
582  */
583 contract InitializableERC20Detailed is IERC20 {
584     // Storage gap to skip storage from prior to OUSD reset
585     uint256[100] private _____gap;
586 
587     string private _name;
588     string private _symbol;
589     uint8 private _decimals;
590 
591     /**
592      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
593      * these values are immutable: they can only be set once during
594      * construction.
595      * @notice To avoid variable shadowing appended `Arg` after arguments name.
596      */
597     function _initialize(
598         string memory nameArg,
599         string memory symbolArg,
600         uint8 decimalsArg
601     ) internal {
602         _name = nameArg;
603         _symbol = symbolArg;
604         _decimals = decimalsArg;
605     }
606 
607     /**
608      * @dev Returns the name of the token.
609      */
610     function name() public view returns (string memory) {
611         return _name;
612     }
613 
614     /**
615      * @dev Returns the symbol of the token, usually a shorter version of the
616      * name.
617      */
618     function symbol() public view returns (string memory) {
619         return _symbol;
620     }
621 
622     /**
623      * @dev Returns the number of decimals used to get its user representation.
624      * For example, if `decimals` equals `2`, a balance of `505` tokens should
625      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
626      *
627      * Tokens usually opt for a value of 18, imitating the relationship between
628      * Ether and Wei.
629      *
630      * NOTE: This information is only used for _display_ purposes: it in
631      * no way affects any of the arithmetic of the contract, including
632      * {IERC20-balanceOf} and {IERC20-transfer}.
633      */
634     function decimals() public view returns (uint8) {
635         return _decimals;
636     }
637 }
638 
639 // File: contracts/utils/StableMath.sol
640 
641 pragma solidity 0.5.11;
642 
643 // Based on StableMath from Stability Labs Pty. Ltd.
644 // https://github.com/mstable/mStable-contracts/blob/master/contracts/shared/StableMath.sol
645 
646 library StableMath {
647     using SafeMath for uint256;
648 
649     /**
650      * @dev Scaling unit for use in specific calculations,
651      * where 1 * 10**18, or 1e18 represents a unit '1'
652      */
653     uint256 private constant FULL_SCALE = 1e18;
654 
655     /***************************************
656                     Helpers
657     ****************************************/
658 
659     /**
660      * @dev Adjust the scale of an integer
661      * @param adjustment Amount to adjust by e.g. scaleBy(1e18, -1) == 1e17
662      */
663     function scaleBy(uint256 x, int8 adjustment)
664         internal
665         pure
666         returns (uint256)
667     {
668         if (adjustment > 0) {
669             x = x.mul(10**uint256(adjustment));
670         } else if (adjustment < 0) {
671             x = x.div(10**uint256(adjustment * -1));
672         }
673         return x;
674     }
675 
676     /***************************************
677                Precise Arithmetic
678     ****************************************/
679 
680     /**
681      * @dev Multiplies two precise units, and then truncates by the full scale
682      * @param x Left hand input to multiplication
683      * @param y Right hand input to multiplication
684      * @return Result after multiplying the two inputs and then dividing by the shared
685      *         scale unit
686      */
687     function mulTruncate(uint256 x, uint256 y) internal pure returns (uint256) {
688         return mulTruncateScale(x, y, FULL_SCALE);
689     }
690 
691     /**
692      * @dev Multiplies two precise units, and then truncates by the given scale. For example,
693      * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
694      * @param x Left hand input to multiplication
695      * @param y Right hand input to multiplication
696      * @param scale Scale unit
697      * @return Result after multiplying the two inputs and then dividing by the shared
698      *         scale unit
699      */
700     function mulTruncateScale(
701         uint256 x,
702         uint256 y,
703         uint256 scale
704     ) internal pure returns (uint256) {
705         // e.g. assume scale = fullScale
706         // z = 10e18 * 9e17 = 9e36
707         uint256 z = x.mul(y);
708         // return 9e38 / 1e18 = 9e18
709         return z.div(scale);
710     }
711 
712     /**
713      * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
714      * @param x Left hand input to multiplication
715      * @param y Right hand input to multiplication
716      * @return Result after multiplying the two inputs and then dividing by the shared
717      *          scale unit, rounded up to the closest base unit.
718      */
719     function mulTruncateCeil(uint256 x, uint256 y)
720         internal
721         pure
722         returns (uint256)
723     {
724         // e.g. 8e17 * 17268172638 = 138145381104e17
725         uint256 scaled = x.mul(y);
726         // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
727         uint256 ceil = scaled.add(FULL_SCALE.sub(1));
728         // e.g. 13814538111.399...e18 / 1e18 = 13814538111
729         return ceil.div(FULL_SCALE);
730     }
731 
732     /**
733      * @dev Precisely divides two units, by first scaling the left hand operand. Useful
734      *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
735      * @param x Left hand input to division
736      * @param y Right hand input to division
737      * @return Result after multiplying the left operand by the scale, and
738      *         executing the division on the right hand input.
739      */
740     function divPrecisely(uint256 x, uint256 y)
741         internal
742         pure
743         returns (uint256)
744     {
745         // e.g. 8e18 * 1e18 = 8e36
746         uint256 z = x.mul(FULL_SCALE);
747         // e.g. 8e36 / 10e18 = 8e17
748         return z.div(y);
749     }
750 }
751 
752 // File: contracts/token/OUSD.sol
753 
754 pragma solidity 0.5.11;
755 
756 /**
757  * @title OUSD Token Contract
758  * @dev ERC20 compatible contract for OUSD
759  * @dev Implements an elastic supply
760  * @author Origin Protocol Inc
761  */
762 
763 
764 
765 
766 
767 /**
768  * NOTE that this is an ERC20 token but the invariant that the sum of
769  * balanceOf(x) for all x is not >= totalSupply(). This is a consequence of the
770  * rebasing design. Any integrations with OUSD should be aware.
771  */
772 
773 contract OUSD is Initializable, InitializableERC20Detailed, Governable {
774     using SafeMath for uint256;
775     using StableMath for uint256;
776 
777     event TotalSupplyUpdated(
778         uint256 totalSupply,
779         uint256 rebasingCredits,
780         uint256 rebasingCreditsPerToken
781     );
782 
783     enum RebaseOptions { NotSet, OptOut, OptIn }
784 
785     uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
786     uint256 public _totalSupply;
787     mapping(address => mapping(address => uint256)) private _allowances;
788     address public vaultAddress = address(0);
789     mapping(address => uint256) private _creditBalances;
790     uint256 public rebasingCredits;
791     uint256 public rebasingCreditsPerToken;
792     // Frozen address/credits are non rebasing (value is held in contracts which
793     // do not receive yield unless they explicitly opt in)
794     uint256 public nonRebasingSupply;
795     mapping(address => uint256) public nonRebasingCreditsPerToken;
796     mapping(address => RebaseOptions) public rebaseState;
797 
798     function initialize(
799         string calldata _nameArg,
800         string calldata _symbolArg,
801         address _vaultAddress
802     ) external onlyGovernor initializer {
803         InitializableERC20Detailed._initialize(_nameArg, _symbolArg, 18);
804         rebasingCreditsPerToken = 1e18;
805         vaultAddress = _vaultAddress;
806     }
807 
808     /**
809      * @dev Verifies that the caller is the Savings Manager contract
810      */
811     modifier onlyVault() {
812         require(vaultAddress == msg.sender, "Caller is not the Vault");
813         _;
814     }
815 
816     /**
817      * @return The total supply of OUSD.
818      */
819     function totalSupply() public view returns (uint256) {
820         return _totalSupply;
821     }
822 
823     /**
824      * @dev Gets the balance of the specified address.
825      * @param _account Address to query the balance of.
826      * @return A uint256 representing the _amount of base units owned by the
827      *         specified address.
828      */
829     function balanceOf(address _account) public view returns (uint256) {
830         if (_creditBalances[_account] == 0) return 0;
831         return
832             _creditBalances[_account].divPrecisely(_creditsPerToken(_account));
833     }
834 
835     /**
836      * @dev Gets the credits balance of the specified address.
837      * @param _account The address to query the balance of.
838      * @return (uint256, uint256) Credit balance and credits per token of the
839      *         address
840      */
841     function creditsBalanceOf(address _account)
842         public
843         view
844         returns (uint256, uint256)
845     {
846         return (_creditBalances[_account], _creditsPerToken(_account));
847     }
848 
849     /**
850      * @dev Transfer tokens to a specified address.
851      * @param _to the address to transfer to.
852      * @param _value the _amount to be transferred.
853      * @return true on success.
854      */
855     function transfer(address _to, uint256 _value) public returns (bool) {
856         require(_to != address(0), "Transfer to zero address");
857         require(
858             _value <= balanceOf(msg.sender),
859             "Transfer greater than balance"
860         );
861 
862         _executeTransfer(msg.sender, _to, _value);
863 
864         emit Transfer(msg.sender, _to, _value);
865 
866         return true;
867     }
868 
869     /**
870      * @dev Transfer tokens from one address to another.
871      * @param _from The address you want to send tokens from.
872      * @param _to The address you want to transfer to.
873      * @param _value The _amount of tokens to be transferred.
874      */
875     function transferFrom(
876         address _from,
877         address _to,
878         uint256 _value
879     ) public returns (bool) {
880         require(_to != address(0), "Transfer to zero address");
881         require(_value <= balanceOf(_from), "Transfer greater than balance");
882 
883         _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(
884             _value
885         );
886 
887         _executeTransfer(_from, _to, _value);
888 
889         emit Transfer(_from, _to, _value);
890 
891         return true;
892     }
893 
894     /**
895      * @dev Update the count of non rebasing credits in response to a transfer
896      * @param _from The address you want to send tokens from.
897      * @param _to The address you want to transfer to.
898      * @param _value Amount of OUSD to transfer
899      */
900     function _executeTransfer(
901         address _from,
902         address _to,
903         uint256 _value
904     ) internal {
905         bool isNonRebasingTo = _isNonRebasingAccount(_to);
906         bool isNonRebasingFrom = _isNonRebasingAccount(_from);
907 
908         // Credits deducted and credited might be different due to the
909         // differing creditsPerToken used by each account
910         uint256 creditsCredited = _value.mulTruncate(_creditsPerToken(_to));
911         uint256 creditsDeducted = _value.mulTruncate(_creditsPerToken(_from));
912 
913         _creditBalances[_from] = _creditBalances[_from].sub(
914             creditsDeducted,
915             "Transfer amount exceeds balance"
916         );
917         _creditBalances[_to] = _creditBalances[_to].add(creditsCredited);
918 
919         if (isNonRebasingTo && !isNonRebasingFrom) {
920             // Transfer to non-rebasing account from rebasing account, credits
921             // are removed from the non rebasing tally
922             nonRebasingSupply = nonRebasingSupply.add(_value);
923             // Update rebasingCredits by subtracting the deducted amount
924             rebasingCredits = rebasingCredits.sub(creditsDeducted);
925         } else if (!isNonRebasingTo && isNonRebasingFrom) {
926             // Transfer to rebasing account from non-rebasing account
927             // Decreasing non-rebasing credits by the amount that was sent
928             nonRebasingSupply = nonRebasingSupply.sub(_value);
929             // Update rebasingCredits by adding the credited amount
930             rebasingCredits = rebasingCredits.add(creditsCredited);
931         }
932     }
933 
934     /**
935      * @dev Function to check the _amount of tokens that an owner has allowed to a _spender.
936      * @param _owner The address which owns the funds.
937      * @param _spender The address which will spend the funds.
938      * @return The number of tokens still available for the _spender.
939      */
940     function allowance(address _owner, address _spender)
941         public
942         view
943         returns (uint256)
944     {
945         return _allowances[_owner][_spender];
946     }
947 
948     /**
949      * @dev Approve the passed address to spend the specified _amount of tokens on behalf of
950      * msg.sender. This method is included for ERC20 compatibility.
951      * increaseAllowance and decreaseAllowance should be used instead.
952      * Changing an allowance with this method brings the risk that someone may transfer both
953      * the old and the new allowance - if they are both greater than zero - if a transfer
954      * transaction is mined before the later approve() call is mined.
955      *
956      * @param _spender The address which will spend the funds.
957      * @param _value The _amount of tokens to be spent.
958      */
959     function approve(address _spender, uint256 _value) public returns (bool) {
960         _allowances[msg.sender][_spender] = _value;
961         emit Approval(msg.sender, _spender, _value);
962         return true;
963     }
964 
965     /**
966      * @dev Increase the _amount of tokens that an owner has allowed to a _spender.
967      * This method should be used instead of approve() to avoid the double approval vulnerability
968      * described above.
969      * @param _spender The address which will spend the funds.
970      * @param _addedValue The _amount of tokens to increase the allowance by.
971      */
972     function increaseAllowance(address _spender, uint256 _addedValue)
973         public
974         returns (bool)
975     {
976         _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender]
977             .add(_addedValue);
978         emit Approval(msg.sender, _spender, _allowances[msg.sender][_spender]);
979         return true;
980     }
981 
982     /**
983      * @dev Decrease the _amount of tokens that an owner has allowed to a _spender.
984      * @param _spender The address which will spend the funds.
985      * @param _subtractedValue The _amount of tokens to decrease the allowance by.
986      */
987     function decreaseAllowance(address _spender, uint256 _subtractedValue)
988         public
989         returns (bool)
990     {
991         uint256 oldValue = _allowances[msg.sender][_spender];
992         if (_subtractedValue >= oldValue) {
993             _allowances[msg.sender][_spender] = 0;
994         } else {
995             _allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
996         }
997         emit Approval(msg.sender, _spender, _allowances[msg.sender][_spender]);
998         return true;
999     }
1000 
1001     /**
1002      * @dev Mints new tokens, increasing totalSupply.
1003      */
1004     function mint(address _account, uint256 _amount) external onlyVault {
1005         _mint(_account, _amount);
1006     }
1007 
1008     /**
1009      * @dev Creates `_amount` tokens and assigns them to `_account`, increasing
1010      * the total supply.
1011      *
1012      * Emits a {Transfer} event with `from` set to the zero address.
1013      *
1014      * Requirements
1015      *
1016      * - `to` cannot be the zero address.
1017      */
1018     function _mint(address _account, uint256 _amount) internal nonReentrant {
1019         require(_account != address(0), "Mint to the zero address");
1020 
1021         bool isNonRebasingAccount = _isNonRebasingAccount(_account);
1022 
1023         uint256 creditAmount = _amount.mulTruncate(_creditsPerToken(_account));
1024         _creditBalances[_account] = _creditBalances[_account].add(creditAmount);
1025 
1026         // If the account is non rebasing and doesn't have a set creditsPerToken
1027         // then set it i.e. this is a mint from a fresh contract
1028         if (isNonRebasingAccount) {
1029             nonRebasingSupply = nonRebasingSupply.add(_amount);
1030         } else {
1031             rebasingCredits = rebasingCredits.add(creditAmount);
1032         }
1033 
1034         _totalSupply = _totalSupply.add(_amount);
1035 
1036         require(_totalSupply < MAX_SUPPLY, "Max supply");
1037 
1038         emit Transfer(address(0), _account, _amount);
1039     }
1040 
1041     /**
1042      * @dev Burns tokens, decreasing totalSupply.
1043      */
1044     function burn(address account, uint256 amount) external onlyVault {
1045         _burn(account, amount);
1046     }
1047 
1048     /**
1049      * @dev Destroys `_amount` tokens from `_account`, reducing the
1050      * total supply.
1051      *
1052      * Emits a {Transfer} event with `to` set to the zero address.
1053      *
1054      * Requirements
1055      *
1056      * - `_account` cannot be the zero address.
1057      * - `_account` must have at least `_amount` tokens.
1058      */
1059     function _burn(address _account, uint256 _amount) internal nonReentrant {
1060         require(_account != address(0), "Burn from the zero address");
1061         if (_amount == 0) {
1062             return;
1063         }
1064 
1065         bool isNonRebasingAccount = _isNonRebasingAccount(_account);
1066         uint256 creditAmount = _amount.mulTruncate(_creditsPerToken(_account));
1067         uint256 currentCredits = _creditBalances[_account];
1068 
1069         // Remove the credits, burning rounding errors
1070         if (
1071             currentCredits == creditAmount || currentCredits - 1 == creditAmount
1072         ) {
1073             // Handle dust from rounding
1074             _creditBalances[_account] = 0;
1075         } else if (currentCredits > creditAmount) {
1076             _creditBalances[_account] = _creditBalances[_account].sub(
1077                 creditAmount
1078             );
1079         } else {
1080             revert("Remove exceeds balance");
1081         }
1082 
1083         // Remove from the credit tallies and non-rebasing supply
1084         if (isNonRebasingAccount) {
1085             nonRebasingSupply = nonRebasingSupply.sub(_amount);
1086         } else {
1087             rebasingCredits = rebasingCredits.sub(creditAmount);
1088         }
1089 
1090         _totalSupply = _totalSupply.sub(_amount);
1091 
1092         emit Transfer(_account, address(0), _amount);
1093     }
1094 
1095     /**
1096      * @dev Get the credits per token for an account. Returns a fixed amount
1097      *      if the account is non-rebasing.
1098      * @param _account Address of the account.
1099      */
1100     function _creditsPerToken(address _account)
1101         internal
1102         view
1103         returns (uint256)
1104     {
1105         if (nonRebasingCreditsPerToken[_account] != 0) {
1106             return nonRebasingCreditsPerToken[_account];
1107         } else {
1108             return rebasingCreditsPerToken;
1109         }
1110     }
1111 
1112     /**
1113      * @dev Is an account using rebasing accounting or non-rebasing accounting?
1114      *      Also, ensure contracts are non-rebasing if they have not opted in.
1115      * @param _account Address of the account.
1116      */
1117     function _isNonRebasingAccount(address _account) internal returns (bool) {
1118         bool isContract = Address.isContract(_account);
1119         if (isContract && rebaseState[_account] == RebaseOptions.NotSet) {
1120             _ensureRebasingMigration(_account);
1121         }
1122         return nonRebasingCreditsPerToken[_account] > 0;
1123     }
1124 
1125     /**
1126      * @dev Ensures internal account for rebasing and non-rebasing credits and
1127      *      supply is updated following deployment of frozen yield change.
1128      */
1129     function _ensureRebasingMigration(address _account) internal {
1130         if (nonRebasingCreditsPerToken[_account] == 0) {
1131             // Set fixed credits per token for this account
1132             nonRebasingCreditsPerToken[_account] = rebasingCreditsPerToken;
1133             // Update non rebasing supply
1134             nonRebasingSupply = nonRebasingSupply.add(balanceOf(_account));
1135             // Update credit tallies
1136             rebasingCredits = rebasingCredits.sub(_creditBalances[_account]);
1137         }
1138     }
1139 
1140     /**
1141      * @dev Add a contract address to the non rebasing exception list. I.e. the
1142      * address's balance will be part of rebases so the account will be exposed
1143      * to upside and downside.
1144      */
1145     function rebaseOptIn() public nonReentrant {
1146         require(_isNonRebasingAccount(msg.sender), "Account has not opted out");
1147 
1148         // Convert balance into the same amount at the current exchange rate
1149         uint256 newCreditBalance = _creditBalances[msg.sender]
1150             .mul(rebasingCreditsPerToken)
1151             .div(_creditsPerToken(msg.sender));
1152 
1153         // Decreasing non rebasing supply
1154         nonRebasingSupply = nonRebasingSupply.sub(balanceOf(msg.sender));
1155 
1156         _creditBalances[msg.sender] = newCreditBalance;
1157 
1158         // Increase rebasing credits, totalSupply remains unchanged so no
1159         // adjustment necessary
1160         rebasingCredits = rebasingCredits.add(_creditBalances[msg.sender]);
1161 
1162         rebaseState[msg.sender] = RebaseOptions.OptIn;
1163 
1164         // Delete any fixed credits per token
1165         delete nonRebasingCreditsPerToken[msg.sender];
1166     }
1167 
1168     /**
1169      * @dev Remove a contract address to the non rebasing exception list.
1170      */
1171     function rebaseOptOut() public nonReentrant {
1172         require(!_isNonRebasingAccount(msg.sender), "Account has not opted in");
1173 
1174         // Increase non rebasing supply
1175         nonRebasingSupply = nonRebasingSupply.add(balanceOf(msg.sender));
1176         // Set fixed credits per token
1177         nonRebasingCreditsPerToken[msg.sender] = rebasingCreditsPerToken;
1178 
1179         // Decrease rebasing credits, total supply remains unchanged so no
1180         // adjustment necessary
1181         rebasingCredits = rebasingCredits.sub(_creditBalances[msg.sender]);
1182 
1183         // Mark explicitly opted out of rebasing
1184         rebaseState[msg.sender] = RebaseOptions.OptOut;
1185     }
1186 
1187     /**
1188      * @dev Modify the supply without minting new tokens. This uses a change in
1189      *      the exchange rate between "credits" and OUSD tokens to change balances.
1190      * @param _newTotalSupply New total supply of OUSD.
1191      * @return uint256 representing the new total supply.
1192      */
1193     function changeSupply(uint256 _newTotalSupply)
1194         external
1195         onlyVault
1196         nonReentrant
1197     {
1198         require(_totalSupply > 0, "Cannot increase 0 supply");
1199 
1200         if (_totalSupply == _newTotalSupply) {
1201             emit TotalSupplyUpdated(
1202                 _totalSupply,
1203                 rebasingCredits,
1204                 rebasingCreditsPerToken
1205             );
1206             return;
1207         }
1208 
1209         _totalSupply = _newTotalSupply > MAX_SUPPLY
1210             ? MAX_SUPPLY
1211             : _newTotalSupply;
1212 
1213         rebasingCreditsPerToken = rebasingCredits.divPrecisely(
1214             _totalSupply.sub(nonRebasingSupply)
1215         );
1216 
1217         require(rebasingCreditsPerToken > 0, "Invalid change in supply");
1218 
1219         _totalSupply = rebasingCredits
1220             .divPrecisely(rebasingCreditsPerToken)
1221             .add(nonRebasingSupply);
1222 
1223         emit TotalSupplyUpdated(
1224             _totalSupply,
1225             rebasingCredits,
1226             rebasingCreditsPerToken
1227         );
1228     }
1229 }
1230 
1231 // File: contracts/interfaces/Tether.sol
1232 
1233 pragma solidity 0.5.11;
1234 
1235 interface Tether {
1236     function transfer(address to, uint256 value) external;
1237 
1238     function transferFrom(
1239         address from,
1240         address to,
1241         uint256 value
1242     ) external;
1243 
1244     function balanceOf(address) external returns (uint256);
1245 }
1246 
1247 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
1248 
1249 pragma solidity ^0.5.0;
1250 
1251 
1252 
1253 /**
1254  * @title SafeERC20
1255  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1256  * contract returns false). Tokens that return no value (and instead revert or
1257  * throw on failure) are also supported, non-reverting calls are assumed to be
1258  * successful.
1259  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1260  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1261  */
1262 library SafeERC20 {
1263     using SafeMath for uint256;
1264     using Address for address;
1265 
1266     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1267         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1268     }
1269 
1270     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1271         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1272     }
1273 
1274     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1275         // safeApprove should only be called when setting an initial allowance,
1276         // or when resetting it to zero. To increase and decrease it, use
1277         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1278         // solhint-disable-next-line max-line-length
1279         require((value == 0) || (token.allowance(address(this), spender) == 0),
1280             "SafeERC20: approve from non-zero to non-zero allowance"
1281         );
1282         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1283     }
1284 
1285     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1286         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1287         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1288     }
1289 
1290     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1291         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1292         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1293     }
1294 
1295     /**
1296      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1297      * on the return value: the return value is optional (but if data is returned, it must not be false).
1298      * @param token The token targeted by the call.
1299      * @param data The call data (encoded using abi.encode or one of its variants).
1300      */
1301     function callOptionalReturn(IERC20 token, bytes memory data) private {
1302         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1303         // we're implementing it ourselves.
1304 
1305         // A Solidity high level call has three parts:
1306         //  1. The target address is checked to verify it contains contract code
1307         //  2. The call itself is made, and success asserted
1308         //  3. The return value is decoded, which in turn checks the size of the returned data.
1309         // solhint-disable-next-line max-line-length
1310         require(address(token).isContract(), "SafeERC20: call to non-contract");
1311 
1312         // solhint-disable-next-line avoid-low-level-calls
1313         (bool success, bytes memory returndata) = address(token).call(data);
1314         require(success, "SafeERC20: low-level call failed");
1315 
1316         if (returndata.length > 0) { // Return data is optional
1317             // solhint-disable-next-line max-line-length
1318             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1319         }
1320     }
1321 }
1322 
1323 // File: contracts/flipper/Flipper.sol
1324 
1325 pragma solidity 0.5.11;
1326 
1327 
1328 
1329 
1330 
1331 // Contract to exchange usdt, usdc, dai from and to ousd.
1332 //   - 1 to 1. No slippage
1333 //   - Optimized for low gas usage
1334 //   - No guarantee of availability
1335 
1336 
1337 contract Flipper is Governable {
1338     using SafeERC20 for IERC20;
1339 
1340     uint256 constant MAXIMUM_PER_TRADE = (25000 * 1e18);
1341 
1342     // -----------
1343     // Constructor
1344     // -----------
1345     // Saves approx 4K gas per swap by using hardcoded addresses.
1346     IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
1347     OUSD constant ousd = OUSD(0x2A8e1E676Ec238d8A992307B495b45B3fEAa5e86);
1348     IERC20 usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1349     Tether constant usdt = Tether(0xdAC17F958D2ee523a2206206994597C13D831ec7);
1350 
1351     constructor() public {}
1352 
1353     // -----------------
1354     // Trading functions
1355     // -----------------
1356 
1357     /// @notice Purchase OUSD with Dai
1358     /// @param amount Amount of OUSD to purchase, in 18 fixed decimals.
1359     function buyOusdWithDai(uint256 amount) external {
1360         require(amount <= MAXIMUM_PER_TRADE, "Amount too large");
1361         require(dai.transferFrom(msg.sender, address(this), amount));
1362         require(ousd.transfer(msg.sender, amount));
1363     }
1364 
1365     /// @notice Sell OUSD for Dai
1366     /// @param amount Amount of OUSD to sell, in 18 fixed decimals.
1367     function sellOusdForDai(uint256 amount) external {
1368         require(amount <= MAXIMUM_PER_TRADE, "Amount too large");
1369         require(dai.transfer(msg.sender, amount));
1370         require(ousd.transferFrom(msg.sender, address(this), amount));
1371     }
1372 
1373     /// @notice Purchase OUSD with USDC
1374     /// @param amount Amount of OUSD to purchase, in 18 fixed decimals.
1375     function buyOusdWithUsdc(uint256 amount) external {
1376         require(amount <= MAXIMUM_PER_TRADE, "Amount too large");
1377         // Potential rounding error is an intentional tradeoff
1378         require(usdc.transferFrom(msg.sender, address(this), amount / 1e12));
1379         require(ousd.transfer(msg.sender, amount));
1380     }
1381 
1382     /// @notice Sell OUSD for USDC
1383     /// @param amount Amount of OUSD to sell, in 18 fixed decimals.
1384     function sellOusdForUsdc(uint256 amount) external {
1385         require(amount <= MAXIMUM_PER_TRADE, "Amount too large");
1386         require(usdc.transfer(msg.sender, amount / 1e12));
1387         require(ousd.transferFrom(msg.sender, address(this), amount));
1388     }
1389 
1390     /// @notice Purchase OUSD with USDT
1391     /// @param amount Amount of OUSD to purchase, in 18 fixed decimals.
1392     function buyOusdWithUsdt(uint256 amount) external {
1393         require(amount <= MAXIMUM_PER_TRADE, "Amount too large");
1394         // Potential rounding error is an intentional tradeoff
1395         // USDT does not return a boolean and reverts,
1396         // so no need for a require.
1397         usdt.transferFrom(msg.sender, address(this), amount / 1e12);
1398         require(ousd.transfer(msg.sender, amount));
1399     }
1400 
1401     /// @notice Sell OUSD for USDT
1402     /// @param amount Amount of OUSD to sell, in 18 fixed decimals.
1403     function sellOusdForUsdt(uint256 amount) external {
1404         require(amount <= MAXIMUM_PER_TRADE, "Amount too large");
1405         // USDT does not return a boolean and reverts,
1406         // so no need for a require.
1407         usdt.transfer(msg.sender, amount / 1e12);
1408         require(ousd.transferFrom(msg.sender, address(this), amount));
1409     }
1410 
1411     // --------------------
1412     // Governance functions
1413     // --------------------
1414 
1415     /// @dev Opting into yield reduces the gas cost per transfer by about 4K, since
1416     /// ousd needs to do less accounting and one less storage write.
1417     function rebaseOptIn() external onlyGovernor nonReentrant {
1418         ousd.rebaseOptIn();
1419     }
1420 
1421     /// @notice Owner function to withdraw a specific amount of a token
1422     function withdraw(address token, uint256 amount)
1423         external
1424         onlyGovernor
1425         nonReentrant
1426     {
1427         IERC20(token).safeTransfer(_governor(), amount);
1428     }
1429 
1430     /// @notice Owner function to withdraw all tradable tokens
1431     /// @dev Equivalent to "pausing" the contract.
1432     function withdrawAll() external onlyGovernor nonReentrant {
1433         IERC20(dai).safeTransfer(_governor(), dai.balanceOf(address(this)));
1434         IERC20(ousd).safeTransfer(_governor(), ousd.balanceOf(address(this)));
1435         IERC20(address(usdt)).safeTransfer(
1436             _governor(),
1437             usdt.balanceOf(address(this))
1438         );
1439         IERC20(usdc).safeTransfer(_governor(), usdc.balanceOf(address(this)));
1440     }
1441 }
