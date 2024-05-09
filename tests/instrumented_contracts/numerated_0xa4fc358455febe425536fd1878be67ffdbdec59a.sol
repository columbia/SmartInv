1 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: @openzeppelin/upgrades/contracts/Initializable.sol
28 
29 pragma solidity >=0.4.24 <0.6.0;
30 
31 
32 /**
33  * @title Initializable
34  *
35  * @dev Helper contract to support initializer functions. To use it, replace
36  * the constructor with a function that has the `initializer` modifier.
37  * WARNING: Unlike constructors, initializer functions must be manually
38  * invoked. This applies both to deploying an Initializable contract, as well
39  * as extending an Initializable contract via inheritance.
40  * WARNING: When used with inheritance, manual care must be taken to not invoke
41  * a parent initializer twice, or ensure that all initializers are idempotent,
42  * because this is not dealt with automatically as with constructors.
43  */
44 contract Initializable {
45 
46   /**
47    * @dev Indicates that the contract has been initialized.
48    */
49   bool private initialized;
50 
51   /**
52    * @dev Indicates that the contract is in the process of being initialized.
53    */
54   bool private initializing;
55 
56   /**
57    * @dev Modifier to use in the initializer function of a contract.
58    */
59   modifier initializer() {
60     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
61 
62     bool isTopLevelCall = !initializing;
63     if (isTopLevelCall) {
64       initializing = true;
65       initialized = true;
66     }
67 
68     _;
69 
70     if (isTopLevelCall) {
71       initializing = false;
72     }
73   }
74 
75   /// @dev Returns true if and only if the function is running in the constructor
76   function isConstructor() private view returns (bool) {
77     // extcodesize checks the size of the code stored in an address, and
78     // address returns the current address. Since the code is still not
79     // deployed when running a constructor, any checks on its code size will
80     // yield zero, making it an effective way to detect if a contract is
81     // under construction or not.
82     uint256 cs;
83     assembly { cs := extcodesize(address) }
84     return cs == 0;
85   }
86 
87   // Reserved storage space to allow for layout changes in the future.
88   uint256[50] private ______gap;
89 }
90 
91 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol
92 
93 pragma solidity ^0.5.2;
94 
95 
96 /**
97  * @title Helps contracts guard against reentrancy attacks.
98  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
99  * @dev If you mark a function `nonReentrant`, you should also
100  * mark it `external`.
101  */
102 contract ReentrancyGuard is Initializable {
103     /// @dev counter to allow mutex lock with only one SSTORE operation
104     uint256 private _guardCounter;
105 
106     function initialize() public initializer {
107         // The counter starts at one to prevent changing it from zero to a non-zero
108         // value, which is a more expensive operation.
109         _guardCounter = 1;
110     }
111 
112     /**
113      * @dev Prevents a contract from calling itself, directly or indirectly.
114      * Calling a `nonReentrant` function from another `nonReentrant`
115      * function is not supported. It is possible to prevent this from happening
116      * by making the `nonReentrant` function external, and make it call a
117      * `private` function that does the actual work.
118      */
119     modifier nonReentrant() {
120         _guardCounter += 1;
121         uint256 localCounter = _guardCounter;
122         _;
123         require(localCounter == _guardCounter);
124     }
125 
126     uint256[50] private ______gap;
127 }
128 
129 // File: @sablier/shared-contracts/compound/CarefulMath.sol
130 
131 pragma solidity ^0.5.8;
132 
133 /**
134   * @title Careful Math
135   * @author Compound
136   * @notice Derived from OpenZeppelin's SafeMath library
137   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
138   */
139 contract CarefulMath {
140 
141     /**
142      * @dev Possible error codes that we can return
143      */
144     enum MathError {
145         NO_ERROR,
146         DIVISION_BY_ZERO,
147         INTEGER_OVERFLOW,
148         INTEGER_UNDERFLOW
149     }
150 
151     /**
152     * @dev Multiplies two numbers, returns an error on overflow.
153     */
154     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
155         if (a == 0) {
156             return (MathError.NO_ERROR, 0);
157         }
158 
159         uint c = a * b;
160 
161         if (c / a != b) {
162             return (MathError.INTEGER_OVERFLOW, 0);
163         } else {
164             return (MathError.NO_ERROR, c);
165         }
166     }
167 
168     /**
169     * @dev Integer division of two numbers, truncating the quotient.
170     */
171     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
172         if (b == 0) {
173             return (MathError.DIVISION_BY_ZERO, 0);
174         }
175 
176         return (MathError.NO_ERROR, a / b);
177     }
178 
179     /**
180     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
181     */
182     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
183         if (b <= a) {
184             return (MathError.NO_ERROR, a - b);
185         } else {
186             return (MathError.INTEGER_UNDERFLOW, 0);
187         }
188     }
189 
190     /**
191     * @dev Adds two numbers, returns an error on overflow.
192     */
193     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
194         uint c = a + b;
195 
196         if (c >= a) {
197             return (MathError.NO_ERROR, c);
198         } else {
199             return (MathError.INTEGER_OVERFLOW, 0);
200         }
201     }
202 
203     /**
204     * @dev add a and b and then subtract c
205     */
206     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
207         (MathError err0, uint sum) = addUInt(a, b);
208 
209         if (err0 != MathError.NO_ERROR) {
210             return (err0, 0);
211         }
212 
213         return subUInt(sum, c);
214     }
215 }
216 
217 // File: @sablier/shared-contracts/compound/Exponential.sol
218 
219 pragma solidity ^0.5.8;
220 
221 
222 /**
223  * @title Exponential module for storing fixed-decision decimals
224  * @author Compound
225  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
226  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
227  *         `Exp({mantissa: 5100000000000000000})`.
228  */
229 contract Exponential is CarefulMath {
230     uint constant expScale = 1e18;
231     uint constant halfExpScale = expScale/2;
232     uint constant mantissaOne = expScale;
233 
234     struct Exp {
235         uint mantissa;
236     }
237 
238     /**
239      * @dev Creates an exponential from numerator and denominator values.
240      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
241      *            or if `denom` is zero.
242      */
243     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
244         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
245         if (err0 != MathError.NO_ERROR) {
246             return (err0, Exp({mantissa: 0}));
247         }
248 
249         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
250         if (err1 != MathError.NO_ERROR) {
251             return (err1, Exp({mantissa: 0}));
252         }
253 
254         return (MathError.NO_ERROR, Exp({mantissa: rational}));
255     }
256 
257     /**
258      * @dev Adds two exponentials, returning a new exponential.
259      */
260     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
261         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
262 
263         return (error, Exp({mantissa: result}));
264     }
265 
266     /**
267      * @dev Subtracts two exponentials, returning a new exponential.
268      */
269     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
270         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
271 
272         return (error, Exp({mantissa: result}));
273     }
274 
275     /**
276      * @dev Multiply an Exp by a scalar, returning a new Exp.
277      */
278     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
279         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
280         if (err0 != MathError.NO_ERROR) {
281             return (err0, Exp({mantissa: 0}));
282         }
283 
284         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
285     }
286 
287     /**
288      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
289      */
290     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
291         (MathError err, Exp memory product) = mulScalar(a, scalar);
292         if (err != MathError.NO_ERROR) {
293             return (err, 0);
294         }
295 
296         return (MathError.NO_ERROR, truncate(product));
297     }
298 
299     /**
300      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
301      */
302     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
303         (MathError err, Exp memory product) = mulScalar(a, scalar);
304         if (err != MathError.NO_ERROR) {
305             return (err, 0);
306         }
307 
308         return addUInt(truncate(product), addend);
309     }
310 
311     /**
312      * @dev Divide an Exp by a scalar, returning a new Exp.
313      */
314     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
315         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
316         if (err0 != MathError.NO_ERROR) {
317             return (err0, Exp({mantissa: 0}));
318         }
319 
320         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
321     }
322 
323     /**
324      * @dev Divide a scalar by an Exp, returning a new Exp.
325      */
326     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
327         /*
328           We are doing this as:
329           getExp(mulUInt(expScale, scalar), divisor.mantissa)
330 
331           How it works:
332           Exp = a / b;
333           Scalar = s;
334           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
335         */
336         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
337         if (err0 != MathError.NO_ERROR) {
338             return (err0, Exp({mantissa: 0}));
339         }
340         return getExp(numerator, divisor.mantissa);
341     }
342 
343     /**
344      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
345      */
346     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
347         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
348         if (err != MathError.NO_ERROR) {
349             return (err, 0);
350         }
351 
352         return (MathError.NO_ERROR, truncate(fraction));
353     }
354 
355     /**
356      * @dev Multiplies two exponentials, returning a new exponential.
357      */
358     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
359 
360         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
361         if (err0 != MathError.NO_ERROR) {
362             return (err0, Exp({mantissa: 0}));
363         }
364 
365         // We add half the scale before dividing so that we get rounding instead of truncation.
366         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
367         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
368         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
369         if (err1 != MathError.NO_ERROR) {
370             return (err1, Exp({mantissa: 0}));
371         }
372 
373         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
374         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
375         assert(err2 == MathError.NO_ERROR);
376 
377         return (MathError.NO_ERROR, Exp({mantissa: product}));
378     }
379 
380     /**
381      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
382      */
383     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
384         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
385     }
386 
387     /**
388      * @dev Multiplies three exponentials, returning a new exponential.
389      */
390     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
391         (MathError err, Exp memory ab) = mulExp(a, b);
392         if (err != MathError.NO_ERROR) {
393             return (err, ab);
394         }
395         return mulExp(ab, c);
396     }
397 
398     /**
399      * @dev Divides two exponentials, returning a new exponential.
400      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
401      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
402      */
403     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
404         return getExp(a.mantissa, b.mantissa);
405     }
406 
407     /**
408      * @dev Truncates the given exp to a whole number value.
409      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
410      */
411     function truncate(Exp memory exp) pure internal returns (uint) {
412         // Note: We are not using careful math here as we're performing a division that cannot fail
413         return exp.mantissa / expScale;
414     }
415 
416     /**
417      * @dev Checks if first Exp is less than second Exp.
418      */
419     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
420         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
421     }
422 
423     /**
424      * @dev Checks if left Exp <= right Exp.
425      */
426     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
427         return left.mantissa <= right.mantissa;
428     }
429 
430     /**
431      * @dev Checks if left Exp > right Exp.
432      */
433     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
434         return left.mantissa > right.mantissa;
435     }
436 
437     /**
438      * @dev returns true if Exp is exactly zero
439      */
440     function isZeroExp(Exp memory value) pure internal returns (bool) {
441         return value.mantissa == 0;
442     }
443 }
444 
445 // File: @sablier/shared-contracts/interfaces/ICERC20.sol
446 
447 pragma solidity 0.5.11;
448 
449 /**
450  * @title CERC20 interface
451  * @author Sablier
452  * @dev See https://compound.finance/developers
453  */
454 interface ICERC20 {
455     function balanceOf(address who) external view returns (uint256);
456 
457     function isCToken() external view returns (bool);
458 
459     function approve(address spender, uint256 value) external returns (bool);
460 
461     function balanceOfUnderlying(address account) external returns (uint256);
462 
463     function exchangeRateCurrent() external returns (uint256);
464 
465     function mint(uint256 mintAmount) external returns (uint256);
466 
467     function redeem(uint256 redeemTokens) external returns (uint256);
468 
469     function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
470 
471     function transfer(address recipient, uint256 amount) external returns (bool);
472 
473     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
474 }
475 
476 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
477 
478 pragma solidity ^0.5.0;
479 
480 /*
481  * @dev Provides information about the current execution context, including the
482  * sender of the transaction and its data. While these are generally available
483  * via msg.sender and msg.data, they not should not be accessed in such a direct
484  * manner, since when dealing with GSN meta-transactions the account sending and
485  * paying for execution may not be the actual sender (as far as an application
486  * is concerned).
487  *
488  * This contract is only required for intermediate, library-like contracts.
489  */
490 contract Context {
491     // Empty internal constructor, to prevent people from mistakenly deploying
492     // an instance of this contract, with should be used via inheritance.
493     constructor () internal { }
494     // solhint-disable-previous-line no-empty-blocks
495 
496     function _msgSender() internal view returns (address) {
497         return msg.sender;
498     }
499 
500     function _msgData() internal view returns (bytes memory) {
501         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
502         return msg.data;
503     }
504 }
505 
506 // File: @sablier/shared-contracts/lifecycle/OwnableWithoutRenounce.sol
507 
508 pragma solidity 0.5.11;
509 
510 
511 
512 /**
513  * @title OwnableWithoutRenounce
514  * @author Sablier
515  * @dev Fork of OpenZeppelin's Ownable contract, which provides basic authorization control, but with
516  *  the `renounceOwnership` function removed to avoid fat-finger errors.
517  *  We inherit from `Context` to keep this contract compatible with the Gas Station Network.
518  * See https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/ownership/Ownable.sol
519  * See https://forum.openzeppelin.com/t/contract-request-ownable-without-renounceownership/1400
520  * See https://docs.openzeppelin.com/contracts/2.x/gsn#_msg_sender_and_msg_data
521  */
522 contract OwnableWithoutRenounce is Initializable, Context {
523     address private _owner;
524 
525     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
526 
527     /**
528      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
529      * account.
530      */
531     function initialize(address sender) public initializer {
532         _owner = sender;
533         emit OwnershipTransferred(address(0), _owner);
534     }
535 
536     /**
537      * @return the address of the owner.
538      */
539     function owner() public view returns (address) {
540         return _owner;
541     }
542 
543     /**
544      * @dev Throws if called by any account other than the owner.
545      */
546     modifier onlyOwner() {
547         require(isOwner());
548         _;
549     }
550 
551     /**
552      * @return true if `msg.sender` is the owner of the contract.
553      */
554     function isOwner() public view returns (bool) {
555         return _msgSender() == _owner;
556     }
557 
558     /**
559      * @dev Allows the current owner to transfer control of the contract to a newOwner.
560      * @param newOwner The address to transfer ownership to.
561      */
562     function transferOwnership(address newOwner) public onlyOwner {
563         _transferOwnership(newOwner);
564     }
565 
566     /**
567      * @dev Transfers control of the contract to a newOwner.
568      * @param newOwner The address to transfer ownership to.
569      */
570     function _transferOwnership(address newOwner) internal {
571         require(newOwner != address(0));
572         emit OwnershipTransferred(_owner, newOwner);
573         _owner = newOwner;
574     }
575 
576     uint256[50] private ______gap;
577 }
578 
579 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol
580 
581 pragma solidity ^0.5.2;
582 
583 /**
584  * @title Roles
585  * @dev Library for managing addresses assigned to a Role.
586  */
587 library Roles {
588     struct Role {
589         mapping (address => bool) bearer;
590     }
591 
592     /**
593      * @dev give an account access to this role
594      */
595     function add(Role storage role, address account) internal {
596         require(account != address(0));
597         require(!has(role, account));
598 
599         role.bearer[account] = true;
600     }
601 
602     /**
603      * @dev remove an account's access to this role
604      */
605     function remove(Role storage role, address account) internal {
606         require(account != address(0));
607         require(has(role, account));
608 
609         role.bearer[account] = false;
610     }
611 
612     /**
613      * @dev check if an account has this role
614      * @return bool
615      */
616     function has(Role storage role, address account) internal view returns (bool) {
617         require(account != address(0));
618         return role.bearer[account];
619     }
620 }
621 
622 // File: @sablier/shared-contracts/lifecycle/PauserRoleWithoutRenounce.sol
623 
624 pragma solidity ^0.5.0;
625 
626 
627 
628 
629 /**
630  * @title PauserRoleWithoutRenounce
631  * @author Sablier
632  * @notice Fork of OpenZeppelin's PauserRole, but with the `renouncePauser` function removed to avoid fat-finger errors.
633  *  We inherit from `Context` to keep this contract compatible with the Gas Station Network.
634  * See https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/access/roles/PauserRole.sol
635  */
636 
637 contract PauserRoleWithoutRenounce is Initializable, Context {
638     using Roles for Roles.Role;
639 
640     event PauserAdded(address indexed account);
641     event PauserRemoved(address indexed account);
642 
643     Roles.Role private _pausers;
644 
645     function initialize(address sender) public initializer {
646         if (!isPauser(sender)) {
647             _addPauser(sender);
648         }
649     }
650 
651     modifier onlyPauser() {
652         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
653         _;
654     }
655 
656     function isPauser(address account) public view returns (bool) {
657         return _pausers.has(account);
658     }
659 
660     function addPauser(address account) public onlyPauser {
661         _addPauser(account);
662     }
663 
664     function _addPauser(address account) internal {
665         _pausers.add(account);
666         emit PauserAdded(account);
667     }
668 
669     function _removePauser(address account) internal {
670         _pausers.remove(account);
671         emit PauserRemoved(account);
672     }
673 
674     uint256[50] private ______gap;
675 }
676 
677 // File: @sablier/shared-contracts/lifecycle/PausableWithoutRenounce.sol
678 
679 pragma solidity 0.5.11;
680 
681 
682 
683 
684 /**
685  * @title PausableWithoutRenounce
686  * @author Sablier
687  * @notice Fork of OpenZeppelin's Pausable, a contract module which allows children to implement an
688  *  emergency stop mechanism that can be triggered by an authorized account, but with the `renouncePauser`
689  *  function removed to avoid fat-finger errors.
690  *  We inherit from `Context` to keep this contract compatible with the Gas Station Network.
691  * See https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/lifecycle/Pausable.sol
692  * See https://docs.openzeppelin.com/contracts/2.x/gsn#_msg_sender_and_msg_data
693  */
694 contract PausableWithoutRenounce is Initializable, Context, PauserRoleWithoutRenounce {
695     /**
696      * @dev Emitted when the pause is triggered by a pauser (`account`).
697      */
698     event Paused(address account);
699 
700     /**
701      * @dev Emitted when the pause is lifted by a pauser (`account`).
702      */
703     event Unpaused(address account);
704 
705     bool private _paused;
706 
707     /**
708      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
709      * to the deployer.
710      */
711     function initialize(address sender) public initializer {
712         PauserRoleWithoutRenounce.initialize(sender);
713         _paused = false;
714     }
715 
716     /**
717      * @dev Returns true if the contract is paused, and false otherwise.
718      */
719     function paused() public view returns (bool) {
720         return _paused;
721     }
722 
723     /**
724      * @dev Modifier to make a function callable only when the contract is not paused.
725      */
726     modifier whenNotPaused() {
727         require(!_paused, "Pausable: paused");
728         _;
729     }
730 
731     /**
732      * @dev Modifier to make a function callable only when the contract is paused.
733      */
734     modifier whenPaused() {
735         require(_paused, "Pausable: not paused");
736         _;
737     }
738 
739     /**
740      * @dev Called by a pauser to pause, triggers stopped state.
741      */
742     function pause() public onlyPauser whenNotPaused {
743         _paused = true;
744         emit Paused(_msgSender());
745     }
746 
747     /**
748      * @dev Called by a pauser to unpause, returns to normal state.
749      */
750     function unpause() public onlyPauser whenPaused {
751         _paused = false;
752         emit Unpaused(_msgSender());
753     }
754 }
755 
756 // File: contracts/interfaces/ICTokenManager.sol
757 
758 pragma solidity 0.5.11;
759 
760 /**
761  * @title CTokenManager Interface
762  * @author Sablier
763  */
764 interface ICTokenManager {
765     /**
766      * @notice Emits when the owner discards a cToken.
767      */
768     event DiscardCToken(address indexed tokenAddress);
769 
770     /**
771      * @notice Emits when the owner whitelists a cToken.
772      */
773     event WhitelistCToken(address indexed tokenAddress);
774 
775     function whitelistCToken(address tokenAddress) external;
776 
777     function discardCToken(address tokenAddress) external;
778 
779     function isCToken(address tokenAddress) external view returns (bool);
780 }
781 
782 // File: contracts/interfaces/IERC1620.sol
783 
784 pragma solidity 0.5.11;
785 
786 /**
787  * @title ERC-1620 Money Streaming Standard
788  * @author Paul Razvan Berg - <paul@sablier.app>
789  * @dev See https://eips.ethereum.org/EIPS/eip-1620
790  */
791 interface IERC1620 {
792     /**
793      * @notice Emits when a stream is successfully created.
794      */
795     event CreateStream(
796         uint256 indexed streamId,
797         address indexed sender,
798         address indexed recipient,
799         uint256 deposit,
800         address tokenAddress,
801         uint256 startTime,
802         uint256 stopTime
803     );
804 
805     /**
806      * @notice Emits when the recipient of a stream withdraws a portion or all their pro rata share of the stream.
807      */
808     event WithdrawFromStream(uint256 indexed streamId, address indexed recipient, uint256 amount);
809 
810     /**
811      * @notice Emits when a stream is successfully cancelled and tokens are transferred back on a pro rata basis.
812      */
813     event CancelStream(
814         uint256 indexed streamId,
815         address indexed sender,
816         address indexed recipient,
817         uint256 senderBalance,
818         uint256 recipientBalance
819     );
820 
821     function balanceOf(uint256 streamId, address who) external view returns (uint256 balance);
822 
823     function getStream(uint256 streamId)
824         external
825         view
826         returns (
827             address sender,
828             address recipient,
829             uint256 deposit,
830             address token,
831             uint256 startTime,
832             uint256 stopTime,
833             uint256 balance,
834             uint256 rate
835         );
836 
837     function createStream(address recipient, uint256 deposit, address tokenAddress, uint256 startTime, uint256 stopTime)
838         external
839         returns (uint256 streamId);
840 
841     function withdrawFromStream(uint256 streamId, uint256 funds) external returns (bool);
842 
843     function cancelStream(uint256 streamId) external returns (bool);
844 }
845 
846 // File: contracts/Types.sol
847 
848 pragma solidity 0.5.11;
849 
850 
851 /**
852  * @title Sablier Types
853  * @author Sablier
854  */
855 library Types {
856     struct Stream {
857         uint256 deposit;
858         uint256 ratePerSecond;
859         uint256 remainingBalance;
860         uint256 startTime;
861         uint256 stopTime;
862         address recipient;
863         address sender;
864         address tokenAddress;
865         bool isEntity;
866     }
867 
868     struct CompoundingStreamVars {
869         Exponential.Exp exchangeRateInitial;
870         Exponential.Exp senderShare;
871         Exponential.Exp recipientShare;
872         bool isEntity;
873     }
874 }
875 
876 // File: contracts/Sablier.sol
877 
878 pragma solidity 0.5.11;
879 
880 
881 
882 
883 
884 
885 
886 
887 
888 
889 /**
890  * @title Sablier's Money Streaming
891  * @author Sablier
892  */
893 contract Sablier is IERC1620, OwnableWithoutRenounce, PausableWithoutRenounce, Exponential, ReentrancyGuard {
894     /*** Storage Properties ***/
895 
896     /**
897      * @notice In Exp terms, 1e18 is 1, or 100%
898      */
899     uint256 constant hundredPercent = 1e18;
900 
901     /**
902      * @notice In Exp terms, 1e16 is 0.01, or 1%
903      */
904     uint256 constant onePercent = 1e16;
905 
906     /**
907      * @notice Stores information about the initial state of the underlying of the cToken.
908      */
909     mapping(uint256 => Types.CompoundingStreamVars) private compoundingStreamsVars;
910 
911     /**
912      * @notice An instance of CTokenManager, responsible for whitelisting and discarding cTokens.
913      */
914     ICTokenManager public cTokenManager;
915 
916     /**
917      * @notice The amount of interest has been accrued per token address.
918      */
919     mapping(address => uint256) private earnings;
920 
921     /**
922      * @notice The percentage fee charged by the contract on the accrued interest.
923      */
924     Exp public fee;
925 
926     /**
927      * @notice Counter for new stream ids.
928      */
929     uint256 public nextStreamId;
930 
931     /**
932      * @notice The stream objects identifiable by their unsigned integer ids.
933      */
934     mapping(uint256 => Types.Stream) private streams;
935 
936     /*** Events ***/
937 
938     /**
939      * @notice Emits when a compounding stream is successfully created.
940      */
941     event CreateCompoundingStream(
942         uint256 indexed streamId,
943         uint256 exchangeRate,
944         uint256 senderSharePercentage,
945         uint256 recipientSharePercentage
946     );
947 
948     /**
949      * @notice Emits when the owner discards a cToken.
950      */
951     event PayInterest(
952         uint256 indexed streamId,
953         uint256 senderInterest,
954         uint256 recipientInterest,
955         uint256 sablierInterest
956     );
957 
958     /**
959      * @notice Emits when the owner takes the earnings.
960      */
961     event TakeEarnings(address indexed tokenAddress, uint256 indexed amount);
962 
963     /**
964      * @notice Emits when the owner updates the percentage fee.
965      */
966     event UpdateFee(uint256 indexed fee);
967 
968     /*** Modifiers ***/
969 
970     /**
971      * @dev Throws if the caller is not the sender of the recipient of the stream.
972      */
973     modifier onlySenderOrRecipient(uint256 streamId) {
974         require(
975             msg.sender == streams[streamId].sender || msg.sender == streams[streamId].recipient,
976             "caller is not the sender or the recipient of the stream"
977         );
978         _;
979     }
980 
981     /**
982      * @dev Throws if the id does not point to a valid stream.
983      */
984     modifier streamExists(uint256 streamId) {
985         require(streams[streamId].isEntity, "stream does not exist");
986         _;
987     }
988 
989     /**
990      * @dev Throws if the id does not point to a valid compounding stream.
991      */
992     modifier compoundingStreamExists(uint256 streamId) {
993         require(compoundingStreamsVars[streamId].isEntity, "compounding stream does not exist");
994         _;
995     }
996 
997     /*** Contract Logic Starts Here */
998 
999     constructor(address cTokenManagerAddress) public {
1000         require(cTokenManagerAddress != address(0x00), "cTokenManager contract is the zero address");
1001         OwnableWithoutRenounce.initialize(msg.sender);
1002         PausableWithoutRenounce.initialize(msg.sender);
1003         cTokenManager = ICTokenManager(cTokenManagerAddress);
1004         nextStreamId = 1;
1005     }
1006 
1007     /*** Owner Functions ***/
1008 
1009     struct UpdateFeeLocalVars {
1010         MathError mathErr;
1011         uint256 feeMantissa;
1012     }
1013 
1014     /**
1015      * @notice Updates the Sablier fee.
1016      * @dev Throws if the caller is not the owner of the contract.
1017      *  Throws if `feePercentage` is not lower or equal to 100.
1018      * @param feePercentage The new fee as a percentage.
1019      */
1020     function updateFee(uint256 feePercentage) external onlyOwner {
1021         require(feePercentage <= 100, "fee percentage higher than 100%");
1022         UpdateFeeLocalVars memory vars;
1023 
1024         /* `feePercentage` will be stored as a mantissa, so we scale it up by one percent in Exp terms. */
1025         (vars.mathErr, vars.feeMantissa) = mulUInt(feePercentage, onePercent);
1026         /*
1027          * `mulUInt` can only return MathError.INTEGER_OVERFLOW but we control `onePercent`
1028          * and we know `feePercentage` is maximum 100.
1029          */
1030         assert(vars.mathErr == MathError.NO_ERROR);
1031 
1032         fee = Exp({ mantissa: vars.feeMantissa });
1033         emit UpdateFee(feePercentage);
1034     }
1035 
1036     struct TakeEarningsLocalVars {
1037         MathError mathErr;
1038     }
1039 
1040     /**
1041      * @notice Withdraws the earnings for the given token address.
1042      * @dev Throws if `amount` exceeds the available balance.
1043      * @param tokenAddress The address of the token to withdraw earnings for.
1044      * @param amount The amount of tokens to withdraw.
1045      */
1046     function takeEarnings(address tokenAddress, uint256 amount) external onlyOwner nonReentrant {
1047         require(cTokenManager.isCToken(tokenAddress), "cToken is not whitelisted");
1048         require(amount > 0, "amount is zero");
1049         require(earnings[tokenAddress] >= amount, "amount exceeds the available balance");
1050 
1051         TakeEarningsLocalVars memory vars;
1052         (vars.mathErr, earnings[tokenAddress]) = subUInt(earnings[tokenAddress], amount);
1053         /*
1054          * `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know `earnings[tokenAddress]`
1055          * is at least as big as `amount`.
1056          */
1057         assert(vars.mathErr == MathError.NO_ERROR);
1058 
1059         emit TakeEarnings(tokenAddress, amount);
1060         require(IERC20(tokenAddress).transfer(msg.sender, amount), "token transfer failure");
1061     }
1062 
1063     /*** View Functions ***/
1064 
1065     /**
1066      * @notice Returns the compounding stream with all its properties.
1067      * @dev Throws if the id does not point to a valid stream.
1068      * @param streamId The id of the stream to query.
1069      * @return The stream object.
1070      */
1071     function getStream(uint256 streamId)
1072         external
1073         view
1074         streamExists(streamId)
1075         returns (
1076             address sender,
1077             address recipient,
1078             uint256 deposit,
1079             address tokenAddress,
1080             uint256 startTime,
1081             uint256 stopTime,
1082             uint256 remainingBalance,
1083             uint256 ratePerSecond
1084         )
1085     {
1086         sender = streams[streamId].sender;
1087         recipient = streams[streamId].recipient;
1088         deposit = streams[streamId].deposit;
1089         tokenAddress = streams[streamId].tokenAddress;
1090         startTime = streams[streamId].startTime;
1091         stopTime = streams[streamId].stopTime;
1092         remainingBalance = streams[streamId].remainingBalance;
1093         ratePerSecond = streams[streamId].ratePerSecond;
1094     }
1095 
1096     /**
1097      * @notice Returns either the delta in seconds between `block.timestamp` and `startTime` or
1098      *  between `stopTime` and `startTime, whichever is smaller. If `block.timestamp` is before
1099      *  `startTime`, it returns 0.
1100      * @dev Throws if the id does not point to a valid stream.
1101      * @param streamId The id of the stream for whom to query the delta.
1102      * @return The time delta in seconds.
1103      */
1104     function deltaOf(uint256 streamId) public view streamExists(streamId) returns (uint256 delta) {
1105         Types.Stream memory stream = streams[streamId];
1106         if (block.timestamp <= stream.startTime) return 0;
1107         if (block.timestamp < stream.stopTime) return block.timestamp - stream.startTime;
1108         return stream.stopTime - stream.startTime;
1109     }
1110 
1111     struct BalanceOfLocalVars {
1112         MathError mathErr;
1113         uint256 recipientBalance;
1114         uint256 withdrawalAmount;
1115         uint256 senderBalance;
1116     }
1117 
1118     /**
1119      * @notice Returns the available funds for the given stream id and address.
1120      * @dev Throws if the id does not point to a valid stream.
1121      * @param streamId The id of the stream for whom to query the balance.
1122      * @param who The address for whom to query the balance.
1123      * @return The total funds allocated to `who` as uint256.
1124      */
1125     function balanceOf(uint256 streamId, address who) public view streamExists(streamId) returns (uint256 balance) {
1126         Types.Stream memory stream = streams[streamId];
1127         BalanceOfLocalVars memory vars;
1128 
1129         uint256 delta = deltaOf(streamId);
1130         (vars.mathErr, vars.recipientBalance) = mulUInt(delta, stream.ratePerSecond);
1131         require(vars.mathErr == MathError.NO_ERROR, "recipient balance calculation error");
1132 
1133         /*
1134          * If the stream `balance` does not equal `deposit`, it means there have been withdrawals.
1135          * We have to subtract the total amount withdrawn from the amount of money that has been
1136          * streamed until now.
1137          */
1138         if (stream.deposit > stream.remainingBalance) {
1139             (vars.mathErr, vars.withdrawalAmount) = subUInt(stream.deposit, stream.remainingBalance);
1140             assert(vars.mathErr == MathError.NO_ERROR);
1141             (vars.mathErr, vars.recipientBalance) = subUInt(vars.recipientBalance, vars.withdrawalAmount);
1142             /* `withdrawalAmount` cannot and should not be bigger than `recipientBalance`. */
1143             assert(vars.mathErr == MathError.NO_ERROR);
1144         }
1145 
1146         if (who == stream.recipient) return vars.recipientBalance;
1147         if (who == stream.sender) {
1148             (vars.mathErr, vars.senderBalance) = subUInt(stream.remainingBalance, vars.recipientBalance);
1149             /* `recipientBalance` cannot and should not be bigger than `remainingBalance`. */
1150             assert(vars.mathErr == MathError.NO_ERROR);
1151             return vars.senderBalance;
1152         }
1153         return 0;
1154     }
1155 
1156     /**
1157      * @notice Checks if the given id points to a compounding stream.
1158      * @param streamId The id of the compounding stream to check.
1159      * @return bool true=it is compounding stream, otherwise false.
1160      */
1161     function isCompoundingStream(uint256 streamId) public view returns (bool) {
1162         return compoundingStreamsVars[streamId].isEntity;
1163     }
1164 
1165     /**
1166      * @notice Returns the compounding stream object with all its properties.
1167      * @dev Throws if the id does not point to a valid compounding stream.
1168      * @param streamId The id of the compounding stream to query.
1169      * @return The compounding stream object.
1170      */
1171     function getCompoundingStream(uint256 streamId)
1172         external
1173         view
1174         streamExists(streamId)
1175         compoundingStreamExists(streamId)
1176         returns (
1177             address sender,
1178             address recipient,
1179             uint256 deposit,
1180             address tokenAddress,
1181             uint256 startTime,
1182             uint256 stopTime,
1183             uint256 remainingBalance,
1184             uint256 ratePerSecond,
1185             uint256 exchangeRateInitial,
1186             uint256 senderSharePercentage,
1187             uint256 recipientSharePercentage
1188         )
1189     {
1190         sender = streams[streamId].sender;
1191         recipient = streams[streamId].recipient;
1192         deposit = streams[streamId].deposit;
1193         tokenAddress = streams[streamId].tokenAddress;
1194         startTime = streams[streamId].startTime;
1195         stopTime = streams[streamId].stopTime;
1196         remainingBalance = streams[streamId].remainingBalance;
1197         ratePerSecond = streams[streamId].ratePerSecond;
1198         exchangeRateInitial = compoundingStreamsVars[streamId].exchangeRateInitial.mantissa;
1199         senderSharePercentage = compoundingStreamsVars[streamId].senderShare.mantissa;
1200         recipientSharePercentage = compoundingStreamsVars[streamId].recipientShare.mantissa;
1201     }
1202 
1203     struct InterestOfLocalVars {
1204         MathError mathErr;
1205         Exp exchangeRateDelta;
1206         Exp underlyingInterest;
1207         Exp netUnderlyingInterest;
1208         Exp senderUnderlyingInterest;
1209         Exp recipientUnderlyingInterest;
1210         Exp sablierUnderlyingInterest;
1211         Exp senderInterest;
1212         Exp recipientInterest;
1213         Exp sablierInterest;
1214     }
1215 
1216     /**
1217      * @notice Computes the interest accrued by keeping the amount of tokens in the contract. Returns (0, 0, 0) if
1218      *  the stream is not a compounding stream.
1219      * @dev Throws if there is a math error. We do not assert the calculations which involve the current
1220      *  exchange rate, because we can't know what value we'll get back from the cToken contract.
1221      * @return The interest accrued by the sender, the recipient and sablier, respectively, as uint256s.
1222      */
1223     function interestOf(uint256 streamId, uint256 amount)
1224         public
1225         streamExists(streamId)
1226         returns (uint256 senderInterest, uint256 recipientInterest, uint256 sablierInterest)
1227     {
1228         if (!compoundingStreamsVars[streamId].isEntity) {
1229             return (0, 0, 0);
1230         }
1231         Types.Stream memory stream = streams[streamId];
1232         Types.CompoundingStreamVars memory compoundingStreamVars = compoundingStreamsVars[streamId];
1233         InterestOfLocalVars memory vars;
1234 
1235         /*
1236          * The exchange rate delta is a key variable, since it leads us to how much interest has been earned
1237          * since the compounding stream was created.
1238          */
1239         Exp memory exchangeRateCurrent = Exp({ mantissa: ICERC20(stream.tokenAddress).exchangeRateCurrent() });
1240         if (exchangeRateCurrent.mantissa <= compoundingStreamVars.exchangeRateInitial.mantissa) {
1241             return (0, 0, 0);
1242         }
1243         (vars.mathErr, vars.exchangeRateDelta) = subExp(exchangeRateCurrent, compoundingStreamVars.exchangeRateInitial);
1244         assert(vars.mathErr == MathError.NO_ERROR);
1245 
1246         /* Calculate how much interest has been earned by holding `amount` in the smart contract. */
1247         (vars.mathErr, vars.underlyingInterest) = mulScalar(vars.exchangeRateDelta, amount);
1248         require(vars.mathErr == MathError.NO_ERROR, "interest calculation error");
1249 
1250         /* Calculate our share from that interest. */
1251         if (fee.mantissa == hundredPercent) {
1252             (vars.mathErr, vars.sablierInterest) = divExp(vars.underlyingInterest, exchangeRateCurrent);
1253             require(vars.mathErr == MathError.NO_ERROR, "sablier interest conversion error");
1254             return (0, 0, truncate(vars.sablierInterest));
1255         } else if (fee.mantissa == 0) {
1256             vars.sablierUnderlyingInterest = Exp({ mantissa: 0 });
1257             vars.netUnderlyingInterest = vars.underlyingInterest;
1258         } else {
1259             (vars.mathErr, vars.sablierUnderlyingInterest) = mulExp(vars.underlyingInterest, fee);
1260             require(vars.mathErr == MathError.NO_ERROR, "sablier interest calculation error");
1261 
1262             /* Calculate how much interest is left for the sender and the recipient. */
1263             (vars.mathErr, vars.netUnderlyingInterest) = subExp(
1264                 vars.underlyingInterest,
1265                 vars.sablierUnderlyingInterest
1266             );
1267             /*
1268              * `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know that `sablierUnderlyingInterest`
1269              * is less or equal than `underlyingInterest`, because we control the value of `fee`.
1270              */
1271             assert(vars.mathErr == MathError.NO_ERROR);
1272         }
1273 
1274         /* Calculate the sender's share of the interest. */
1275         (vars.mathErr, vars.senderUnderlyingInterest) = mulExp(
1276             vars.netUnderlyingInterest,
1277             compoundingStreamVars.senderShare
1278         );
1279         require(vars.mathErr == MathError.NO_ERROR, "sender interest calculation error");
1280 
1281         /* Calculate the recipient's share of the interest. */
1282         (vars.mathErr, vars.recipientUnderlyingInterest) = subExp(
1283             vars.netUnderlyingInterest,
1284             vars.senderUnderlyingInterest
1285         );
1286         /*
1287          * `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know that `senderUnderlyingInterest`
1288          * is less or equal than `netUnderlyingInterest`, because `senderShare` is bounded between 1e16 and 1e18.
1289          */
1290         assert(vars.mathErr == MathError.NO_ERROR);
1291 
1292         /* Convert the interest to the equivalent cToken denomination. */
1293         (vars.mathErr, vars.senderInterest) = divExp(vars.senderUnderlyingInterest, exchangeRateCurrent);
1294         require(vars.mathErr == MathError.NO_ERROR, "sender interest conversion error");
1295 
1296         (vars.mathErr, vars.recipientInterest) = divExp(vars.recipientUnderlyingInterest, exchangeRateCurrent);
1297         require(vars.mathErr == MathError.NO_ERROR, "recipient interest conversion error");
1298 
1299         (vars.mathErr, vars.sablierInterest) = divExp(vars.sablierUnderlyingInterest, exchangeRateCurrent);
1300         require(vars.mathErr == MathError.NO_ERROR, "sablier interest conversion error");
1301 
1302         /* Truncating the results means losing everything on the last 1e18 positions of the mantissa */
1303         return (truncate(vars.senderInterest), truncate(vars.recipientInterest), truncate(vars.sablierInterest));
1304     }
1305 
1306     /**
1307      * @notice Returns the amount of interest that has been accrued for the given token address.
1308      * @param tokenAddress The address of the token to get the earnings for.
1309      * @return The amount of interest as uint256.
1310      */
1311     function getEarnings(address tokenAddress) external view returns (uint256) {
1312         require(cTokenManager.isCToken(tokenAddress), "token is not cToken");
1313         return earnings[tokenAddress];
1314     }
1315 
1316     /*** Public Effects & Interactions Functions ***/
1317 
1318     struct CreateStreamLocalVars {
1319         MathError mathErr;
1320         uint256 duration;
1321         uint256 ratePerSecond;
1322     }
1323 
1324     /**
1325      * @notice Creates a new stream funded by `msg.sender` and paid towards `recipient`.
1326      * @dev Throws if paused.
1327      *  Throws if the recipient is the zero address, the contract itself or the caller.
1328      *  Throws if the deposit is 0.
1329      *  Throws if the start time is before `block.timestamp`.
1330      *  Throws if the stop time is before the start time.
1331      *  Throws if the duration calculation has a math error.
1332      *  Throws if the deposit is smaller than the duration.
1333      *  Throws if the deposit is not a multiple of the duration.
1334      *  Throws if the rate calculation has a math error.
1335      *  Throws if the next stream id calculation has a math error.
1336      *  Throws if the contract is not allowed to transfer enough tokens.
1337      *  Throws if there is a token transfer failure.
1338      * @param recipient The address towards which the money is streamed.
1339      * @param deposit The amount of money to be streamed.
1340      * @param tokenAddress The ERC20 token to use as streaming currency.
1341      * @param startTime The unix timestamp for when the stream starts.
1342      * @param stopTime The unix timestamp for when the stream stops.
1343      * @return The uint256 id of the newly created stream.
1344      */
1345     function createStream(address recipient, uint256 deposit, address tokenAddress, uint256 startTime, uint256 stopTime)
1346         public
1347         whenNotPaused
1348         returns (uint256)
1349     {
1350         require(recipient != address(0x00), "stream to the zero address");
1351         require(recipient != address(this), "stream to the contract itself");
1352         require(recipient != msg.sender, "stream to the caller");
1353         require(deposit > 0, "deposit is zero");
1354         require(startTime >= block.timestamp, "start time before block.timestamp");
1355         require(stopTime > startTime, "stop time before the start time");
1356 
1357         CreateStreamLocalVars memory vars;
1358         (vars.mathErr, vars.duration) = subUInt(stopTime, startTime);
1359         /* `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know `stopTime` is higher than `startTime`. */
1360         assert(vars.mathErr == MathError.NO_ERROR);
1361 
1362         /* Without this, the rate per second would be zero. */
1363         require(deposit >= vars.duration, "deposit smaller than time delta");
1364 
1365         /* This condition avoids dealing with remainders */
1366         require(deposit % vars.duration == 0, "deposit not multiple of time delta");
1367 
1368         (vars.mathErr, vars.ratePerSecond) = divUInt(deposit, vars.duration);
1369         /* `divUInt` can only return MathError.DIVISION_BY_ZERO but we know `duration` is not zero. */
1370         assert(vars.mathErr == MathError.NO_ERROR);
1371 
1372         /* Create and store the stream object. */
1373         uint256 streamId = nextStreamId;
1374         streams[streamId] = Types.Stream({
1375             remainingBalance: deposit,
1376             deposit: deposit,
1377             isEntity: true,
1378             ratePerSecond: vars.ratePerSecond,
1379             recipient: recipient,
1380             sender: msg.sender,
1381             startTime: startTime,
1382             stopTime: stopTime,
1383             tokenAddress: tokenAddress
1384         });
1385 
1386         /* Increment the next stream id. */
1387         (vars.mathErr, nextStreamId) = addUInt(nextStreamId, uint256(1));
1388         require(vars.mathErr == MathError.NO_ERROR, "next stream id calculation error");
1389 
1390         require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), deposit), "token transfer failure");
1391         emit CreateStream(streamId, msg.sender, recipient, deposit, tokenAddress, startTime, stopTime);
1392         return streamId;
1393     }
1394 
1395     struct CreateCompoundingStreamLocalVars {
1396         MathError mathErr;
1397         uint256 shareSum;
1398         uint256 underlyingBalance;
1399         uint256 senderShareMantissa;
1400         uint256 recipientShareMantissa;
1401     }
1402 
1403     /**
1404      * @notice Creates a new compounding stream funded by `msg.sender` and paid towards `recipient`.
1405      * @dev Inherits all security checks from `createStream`.
1406      *  Throws if the cToken is not whitelisted.
1407      *  Throws if the sender share percentage and the recipient share percentage do not sum up to 100.
1408      *  Throws if the the sender share mantissa calculation has a math error.
1409      *  Throws if the the recipient share mantissa calculation has a math error.
1410      * @param recipient The address towards which the money is streamed.
1411      * @param deposit The amount of money to be streamed.
1412      * @param tokenAddress The ERC20 token to use as streaming currency.
1413      * @param startTime The unix timestamp for when the stream starts.
1414      * @param stopTime The unix timestamp for when the stream stops.
1415      * @param senderSharePercentage The sender's share of the interest, as a percentage.
1416      * @param recipientSharePercentage The recipient's share of the interest, as a percentage.
1417      * @return The uint256 id of the newly created compounding stream.
1418      */
1419     function createCompoundingStream(
1420         address recipient,
1421         uint256 deposit,
1422         address tokenAddress,
1423         uint256 startTime,
1424         uint256 stopTime,
1425         uint256 senderSharePercentage,
1426         uint256 recipientSharePercentage
1427     ) external whenNotPaused returns (uint256) {
1428         require(cTokenManager.isCToken(tokenAddress), "cToken is not whitelisted");
1429         CreateCompoundingStreamLocalVars memory vars;
1430 
1431         /* Ensure that the interest shares sum up to 100%. */
1432         (vars.mathErr, vars.shareSum) = addUInt(senderSharePercentage, recipientSharePercentage);
1433         require(vars.mathErr == MathError.NO_ERROR, "share sum calculation error");
1434         require(vars.shareSum == 100, "shares do not sum up to 100");
1435 
1436         uint256 streamId = createStream(recipient, deposit, tokenAddress, startTime, stopTime);
1437 
1438         /*
1439          * `senderSharePercentage` and `recipientSharePercentage` will be stored as mantissas, so we scale them up
1440          * by one percent in Exp terms.
1441          */
1442         (vars.mathErr, vars.senderShareMantissa) = mulUInt(senderSharePercentage, onePercent);
1443         /*
1444          * `mulUInt` can only return MathError.INTEGER_OVERFLOW but we control `onePercent` and
1445          * we know `senderSharePercentage` is maximum 100.
1446          */
1447         assert(vars.mathErr == MathError.NO_ERROR);
1448 
1449         (vars.mathErr, vars.recipientShareMantissa) = mulUInt(recipientSharePercentage, onePercent);
1450         /*
1451          * `mulUInt` can only return MathError.INTEGER_OVERFLOW but we control `onePercent` and
1452          * we know `recipientSharePercentage` is maximum 100.
1453          */
1454         assert(vars.mathErr == MathError.NO_ERROR);
1455 
1456         /* Create and store the compounding stream vars. */
1457         uint256 exchangeRateCurrent = ICERC20(tokenAddress).exchangeRateCurrent();
1458         compoundingStreamsVars[streamId] = Types.CompoundingStreamVars({
1459             exchangeRateInitial: Exp({ mantissa: exchangeRateCurrent }),
1460             isEntity: true,
1461             recipientShare: Exp({ mantissa: vars.recipientShareMantissa }),
1462             senderShare: Exp({ mantissa: vars.senderShareMantissa })
1463         });
1464 
1465         emit CreateCompoundingStream(streamId, exchangeRateCurrent, senderSharePercentage, recipientSharePercentage);
1466         return streamId;
1467     }
1468 
1469     /**
1470      * @notice Withdraws from the contract to the recipient's account.
1471      * @dev Throws if the id does not point to a valid stream.
1472      *  Throws if the caller is not the sender or the recipient of the stream.
1473      *  Throws if the amount exceeds the available balance.
1474      *  Throws if there is a token transfer failure.
1475      * @param streamId The id of the stream to withdraw tokens from.
1476      * @param amount The amount of tokens to withdraw.
1477      * @return bool true=success, otherwise false.
1478      */
1479     function withdrawFromStream(uint256 streamId, uint256 amount)
1480         external
1481         whenNotPaused
1482         nonReentrant
1483         streamExists(streamId)
1484         onlySenderOrRecipient(streamId)
1485         returns (bool)
1486     {
1487         require(amount > 0, "amount is zero");
1488         Types.Stream memory stream = streams[streamId];
1489         uint256 balance = balanceOf(streamId, stream.recipient);
1490         require(balance >= amount, "amount exceeds the available balance");
1491 
1492         if (!compoundingStreamsVars[streamId].isEntity) {
1493             withdrawFromStreamInternal(streamId, amount);
1494         } else {
1495             withdrawFromCompoundingStreamInternal(streamId, amount);
1496         }
1497         return true;
1498     }
1499 
1500     /**
1501      * @notice Cancels the stream and transfers the tokens back on a pro rata basis.
1502      * @dev Throws if the id does not point to a valid stream.
1503      *  Throws if the caller is not the sender or the recipient of the stream.
1504      *  Throws if there is a token transfer failure.
1505      * @param streamId The id of the stream to cancel.
1506      * @return bool true=success, otherwise false.
1507      */
1508     function cancelStream(uint256 streamId)
1509         external
1510         nonReentrant
1511         streamExists(streamId)
1512         onlySenderOrRecipient(streamId)
1513         returns (bool)
1514     {
1515         if (!compoundingStreamsVars[streamId].isEntity) {
1516             cancelStreamInternal(streamId);
1517         } else {
1518             cancelCompoundingStreamInternal(streamId);
1519         }
1520         return true;
1521     }
1522 
1523     /*** Internal Effects & Interactions Functions ***/
1524 
1525     struct WithdrawFromStreamInternalLocalVars {
1526         MathError mathErr;
1527     }
1528 
1529     /**
1530      * @notice Makes the withdrawal to the recipient of the stream.
1531      * @dev If the stream balance has been depleted to 0, the stream object is deleted
1532      *  to save gas and optimise contract storage.
1533      *  Throws if the stream balance calculation has a math error.
1534      *  Throws if there is a token transfer failure.
1535      */
1536     function withdrawFromStreamInternal(uint256 streamId, uint256 amount) internal {
1537         Types.Stream memory stream = streams[streamId];
1538         WithdrawFromStreamInternalLocalVars memory vars;
1539         (vars.mathErr, streams[streamId].remainingBalance) = subUInt(stream.remainingBalance, amount);
1540         /**
1541          * `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know that `remainingBalance` is at least
1542          * as big as `amount`. See the `require` check in `withdrawFromInternal`.
1543          */
1544         assert(vars.mathErr == MathError.NO_ERROR);
1545 
1546         if (streams[streamId].remainingBalance == 0) delete streams[streamId];
1547 
1548         require(IERC20(stream.tokenAddress).transfer(stream.recipient, amount), "token transfer failure");
1549         emit WithdrawFromStream(streamId, stream.recipient, amount);
1550     }
1551 
1552     struct WithdrawFromCompoundingStreamInternalLocalVars {
1553         MathError mathErr;
1554         uint256 amountWithoutSenderInterest;
1555         uint256 netWithdrawalAmount;
1556     }
1557 
1558     /**
1559      * @notice Withdraws to the recipient's account and pays the accrued interest to all parties.
1560      * @dev If the stream balance has been depleted to 0, the stream object to save gas and optimise
1561      *  contract storage.
1562      *  Throws if there is a math error.
1563      *  Throws if there is a token transfer failure.
1564      */
1565     function withdrawFromCompoundingStreamInternal(uint256 streamId, uint256 amount) internal {
1566         Types.Stream memory stream = streams[streamId];
1567         WithdrawFromCompoundingStreamInternalLocalVars memory vars;
1568 
1569         /* Calculate the interest earned by each party for keeping `stream.balance` in the smart contract. */
1570         (uint256 senderInterest, uint256 recipientInterest, uint256 sablierInterest) = interestOf(streamId, amount);
1571 
1572         /*
1573          * Calculate the net withdrawal amount by subtracting `senderInterest` and `sablierInterest`.
1574          * Because the decimal points are lost when we truncate Exponentials, the recipient will implicitly earn
1575          * `recipientInterest` plus a tiny-weeny amount of interest, max 2e-8 in cToken denomination.
1576          */
1577         (vars.mathErr, vars.amountWithoutSenderInterest) = subUInt(amount, senderInterest);
1578         require(vars.mathErr == MathError.NO_ERROR, "amount without sender interest calculation error");
1579         (vars.mathErr, vars.netWithdrawalAmount) = subUInt(vars.amountWithoutSenderInterest, sablierInterest);
1580         require(vars.mathErr == MathError.NO_ERROR, "net withdrawal amount calculation error");
1581 
1582         /* Subtract `amount` from the remaining balance of the stream. */
1583         (vars.mathErr, streams[streamId].remainingBalance) = subUInt(stream.remainingBalance, amount);
1584         require(vars.mathErr == MathError.NO_ERROR, "balance subtraction calculation error");
1585 
1586         /* Delete the objects from storage if the remaining balance has been depleted to 0. */
1587         if (streams[streamId].remainingBalance == 0) {
1588             delete streams[streamId];
1589             delete compoundingStreamsVars[streamId];
1590         }
1591 
1592         /* Add the sablier interest to the earnings for this cToken. */
1593         (vars.mathErr, earnings[stream.tokenAddress]) = addUInt(earnings[stream.tokenAddress], sablierInterest);
1594         require(vars.mathErr == MathError.NO_ERROR, "earnings addition calculation error");
1595 
1596         /* Transfer the tokens to the sender and the recipient. */
1597         ICERC20 cToken = ICERC20(stream.tokenAddress);
1598         if (senderInterest > 0)
1599             require(cToken.transfer(stream.sender, senderInterest), "sender token transfer failure");
1600         require(cToken.transfer(stream.recipient, vars.netWithdrawalAmount), "recipient token transfer failure");
1601 
1602         emit WithdrawFromStream(streamId, stream.recipient, vars.netWithdrawalAmount);
1603         emit PayInterest(streamId, senderInterest, recipientInterest, sablierInterest);
1604     }
1605 
1606     /**
1607      * @notice Cancels the stream and transfers the tokens back on a pro rata basis.
1608      * @dev The stream and compounding stream vars objects get deleted to save gas
1609      *  and optimise contract storage.
1610      *  Throws if there is a token transfer failure.
1611      */
1612     function cancelStreamInternal(uint256 streamId) internal {
1613         Types.Stream memory stream = streams[streamId];
1614         uint256 senderBalance = balanceOf(streamId, stream.sender);
1615         uint256 recipientBalance = balanceOf(streamId, stream.recipient);
1616 
1617         delete streams[streamId];
1618 
1619         IERC20 token = IERC20(stream.tokenAddress);
1620         if (recipientBalance > 0)
1621             require(token.transfer(stream.recipient, recipientBalance), "recipient token transfer failure");
1622         if (senderBalance > 0) require(token.transfer(stream.sender, senderBalance), "sender token transfer failure");
1623 
1624         emit CancelStream(streamId, stream.sender, stream.recipient, senderBalance, recipientBalance);
1625     }
1626 
1627     struct CancelCompoundingStreamInternal {
1628         MathError mathErr;
1629         uint256 netSenderBalance;
1630         uint256 recipientBalanceWithoutSenderInterest;
1631         uint256 netRecipientBalance;
1632     }
1633 
1634     /**
1635      * @notice Cancels the stream, transfers the tokens back on a pro rata basis and pays the accrued
1636      * interest to all parties.
1637      * @dev Importantly, the money that has not been streamed yet is not considered chargeable.
1638      *  All the interest generated by that underlying will be returned to the sender.
1639      *  Throws if there is a math error.
1640      *  Throws if there is a token transfer failure.
1641      */
1642     function cancelCompoundingStreamInternal(uint256 streamId) internal {
1643         Types.Stream memory stream = streams[streamId];
1644         CancelCompoundingStreamInternal memory vars;
1645 
1646         /*
1647          * The sender gets back all the money that has not been streamed so far. By that, we mean both
1648          * the underlying amount and the interest generated by it.
1649          */
1650         uint256 senderBalance = balanceOf(streamId, stream.sender);
1651         uint256 recipientBalance = balanceOf(streamId, stream.recipient);
1652 
1653         /* Calculate the interest earned by each party for keeping `recipientBalance` in the smart contract. */
1654         (uint256 senderInterest, uint256 recipientInterest, uint256 sablierInterest) = interestOf(
1655             streamId,
1656             recipientBalance
1657         );
1658 
1659         /*
1660          * We add `senderInterest` to `senderBalance` to compute the net balance for the sender.
1661          * After this, the rest of the function is similar to `withdrawFromCompoundingStreamInternal`, except
1662          * we add the sender's share of the interest generated by `recipientBalance` to `senderBalance`.
1663          */
1664         (vars.mathErr, vars.netSenderBalance) = addUInt(senderBalance, senderInterest);
1665         require(vars.mathErr == MathError.NO_ERROR, "net sender balance calculation error");
1666 
1667         /*
1668          * Calculate the net withdrawal amount by subtracting `senderInterest` and `sablierInterest`.
1669          * Because the decimal points are lost when we truncate Exponentials, the recipient will implicitly earn
1670          * `recipientInterest` plus a tiny-weeny amount of interest, max 2e-8 in cToken denomination.
1671          */
1672         (vars.mathErr, vars.recipientBalanceWithoutSenderInterest) = subUInt(recipientBalance, senderInterest);
1673         require(vars.mathErr == MathError.NO_ERROR, "recipient balance without sender interest calculation error");
1674         (vars.mathErr, vars.netRecipientBalance) = subUInt(vars.recipientBalanceWithoutSenderInterest, sablierInterest);
1675         require(vars.mathErr == MathError.NO_ERROR, "net recipient balance calculation error");
1676 
1677         /* Add the sablier interest to the earnings attributed to this cToken. */
1678         (vars.mathErr, earnings[stream.tokenAddress]) = addUInt(earnings[stream.tokenAddress], sablierInterest);
1679         require(vars.mathErr == MathError.NO_ERROR, "earnings addition calculation error");
1680 
1681         /* Delete the objects from storage. */
1682         delete streams[streamId];
1683         delete compoundingStreamsVars[streamId];
1684 
1685         /* Transfer the tokens to the sender and the recipient. */
1686         IERC20 token = IERC20(stream.tokenAddress);
1687         if (vars.netSenderBalance > 0)
1688             require(token.transfer(stream.sender, vars.netSenderBalance), "sender token transfer failure");
1689         if (vars.netRecipientBalance > 0)
1690             require(token.transfer(stream.recipient, vars.netRecipientBalance), "recipient token transfer failure");
1691 
1692         emit CancelStream(streamId, stream.sender, stream.recipient, vars.netSenderBalance, vars.netRecipientBalance);
1693         emit PayInterest(streamId, senderInterest, recipientInterest, sablierInterest);
1694     }
1695 }