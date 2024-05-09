1 // File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol
2 
3 pragma solidity >=0.4.24 <0.7.0;
4 
5 /**
6  * @title Initializable
7  *
8  * @dev Helper contract to support initializer functions. To use it, replace
9  * the constructor with a function that has the `initializer` modifier.
10  * WARNING: Unlike constructors, initializer functions must be manually
11  * invoked. This applies both to deploying an Initializable contract, as well
12  * as extending an Initializable contract via inheritance.
13  * WARNING: When used with inheritance, manual care must be taken to not invoke
14  * a parent initializer twice, or ensure that all initializers are idempotent,
15  * because this is not dealt with automatically as with constructors.
16  */
17 contract Initializable {
18     /**
19      * @dev Indicates that the contract has been initialized.
20      */
21     bool private initialized;
22 
23     /**
24      * @dev Indicates that the contract is in the process of being initialized.
25      */
26     bool private initializing;
27 
28     /**
29      * @dev Modifier to use in the initializer function of a contract.
30      */
31     modifier initializer() {
32         require(
33             initializing || isConstructor() || !initialized,
34             "Contract instance has already been initialized"
35         );
36 
37         bool isTopLevelCall = !initializing;
38         if (isTopLevelCall) {
39             initializing = true;
40             initialized = true;
41         }
42 
43         _;
44 
45         if (isTopLevelCall) {
46             initializing = false;
47         }
48     }
49 
50     /// @dev Returns true if and only if the function is running in the constructor
51     function isConstructor() private view returns (bool) {
52         // extcodesize checks the size of the code stored in an address, and
53         // address returns the current address. Since the code is still not
54         // deployed when running a constructor, any checks on its code size will
55         // yield zero, making it an effective way to detect if a contract is
56         // under construction or not.
57         address self = address(this);
58         uint256 cs;
59         assembly {
60             cs := extcodesize(self)
61         }
62         return cs == 0;
63     }
64 
65     // Reserved storage space to allow for layout changes in the future.
66     uint256[50] private ______gap;
67 }
68 
69 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
70 
71 pragma solidity ^0.6.0;
72 
73 /*
74  * @dev Provides information about the current execution context, including the
75  * sender of the transaction and its data. While these are generally available
76  * via msg.sender and msg.data, they should not be accessed in such a direct
77  * manner, since when dealing with GSN meta-transactions the account sending and
78  * paying for execution may not be the actual sender (as far as an application
79  * is concerned).
80  *
81  * This contract is only required for intermediate, library-like contracts.
82  */
83 contract ContextUpgradeSafe is Initializable {
84     // Empty internal constructor, to prevent people from mistakenly deploying
85     // an instance of this contract, which should be used via inheritance.
86 
87     function __Context_init() internal initializer {
88         __Context_init_unchained();
89     }
90 
91     function __Context_init_unchained() internal initializer {}
92 
93     function _msgSender() internal virtual view returns (address payable) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal virtual view returns (bytes memory) {
98         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
99         return msg.data;
100     }
101 
102     uint256[50] private __gap;
103 }
104 
105 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol
106 
107 pragma solidity ^0.6.0;
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
122     address private _owner;
123 
124     event OwnershipTransferred(
125         address indexed previousOwner,
126         address indexed newOwner
127     );
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132 
133     function __Ownable_init() internal initializer {
134         __Context_init_unchained();
135         __Ownable_init_unchained();
136     }
137 
138     function __Ownable_init_unchained() internal initializer {
139         address msgSender = _msgSender();
140         _owner = msgSender;
141         emit OwnershipTransferred(address(0), msgSender);
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(_owner == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(
177             newOwner != address(0),
178             "Ownable: new owner is the zero address"
179         );
180         emit OwnershipTransferred(_owner, newOwner);
181         _owner = newOwner;
182     }
183 
184     uint256[49] private __gap;
185 }
186 
187 // File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol
188 
189 pragma solidity ^0.6.0;
190 
191 /**
192  * @dev Wrappers over Solidity's arithmetic operations with added overflow
193  * checks.
194  *
195  * Arithmetic operations in Solidity wrap on overflow. This can easily result
196  * in bugs, because programmers usually assume that an overflow raises an
197  * error, which is the standard behavior in high level programming languages.
198  * `SafeMath` restores this intuition by reverting the transaction when an
199  * operation overflows.
200  *
201  * Using this library instead of the unchecked operations eliminates an entire
202  * class of bugs, so it's recommended to use it always.
203  */
204 library SafeMath {
205     /**
206      * @dev Returns the addition of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `+` operator.
210      *
211      * Requirements:
212      * - Addition cannot overflow.
213      */
214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
215         uint256 c = a + b;
216         require(c >= a, "SafeMath: addition overflow");
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      * - Subtraction cannot overflow.
229      */
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         return sub(a, b, "SafeMath: subtraction overflow");
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
236      * overflow (when the result is negative).
237      *
238      * Counterpart to Solidity's `-` operator.
239      *
240      * Requirements:
241      * - Subtraction cannot overflow.
242      */
243     function sub(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         require(b <= a, errorMessage);
249         uint256 c = a - b;
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the multiplication of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `*` operator.
259      *
260      * Requirements:
261      * - Multiplication cannot overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b) internal pure returns (uint256) {
289         return div(a, b, "SafeMath: division by zero");
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * Counterpart to Solidity's `/` operator. Note: this function uses a
297      * `revert` opcode (which leaves remaining gas untouched) while Solidity
298      * uses an invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      * - The divisor cannot be zero.
302      */
303     function div(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         // Solidity only automatically asserts when dividing by 0
309         require(b > 0, errorMessage);
310         uint256 c = a / b;
311         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * Reverts when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
328         return mod(a, b, "SafeMath: modulo by zero");
329     }
330 
331     /**
332      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333      * Reverts with custom message when dividing by zero.
334      *
335      * Counterpart to Solidity's `%` operator. This function uses a `revert`
336      * opcode (which leaves remaining gas untouched) while Solidity uses an
337      * invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      * - The divisor cannot be zero.
341      */
342     function mod(
343         uint256 a,
344         uint256 b,
345         string memory errorMessage
346     ) internal pure returns (uint256) {
347         require(b != 0, errorMessage);
348         return a % b;
349     }
350 }
351 
352 // File: @openzeppelin/contracts-ethereum-package/contracts/math/Math.sol
353 
354 pragma solidity ^0.6.0;
355 
356 /**
357  * @dev Standard math utilities missing in the Solidity language.
358  */
359 library Math {
360     /**
361      * @dev Returns the largest of two numbers.
362      */
363     function max(uint256 a, uint256 b) internal pure returns (uint256) {
364         return a >= b ? a : b;
365     }
366 
367     /**
368      * @dev Returns the smallest of two numbers.
369      */
370     function min(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a < b ? a : b;
372     }
373 
374     /**
375      * @dev Returns the average of two numbers. The result is rounded towards
376      * zero.
377      */
378     function average(uint256 a, uint256 b) internal pure returns (uint256) {
379         // (a + b) / 2 can overflow, so we distribute
380         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
381     }
382 }
383 
384 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
385 
386 pragma solidity ^0.6.0;
387 
388 /**
389  * @dev Interface of the ERC20 standard as defined in the EIP.
390  */
391 interface IERC20 {
392     /**
393      * @dev Returns the amount of tokens in existence.
394      */
395     function totalSupply() external view returns (uint256);
396 
397     /**
398      * @dev Returns the amount of tokens owned by `account`.
399      */
400     function balanceOf(address account) external view returns (uint256);
401 
402     /**
403      * @dev Moves `amount` tokens from the caller's account to `recipient`.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transfer(address recipient, uint256 amount)
410         external
411         returns (bool);
412 
413     /**
414      * @dev Returns the remaining number of tokens that `spender` will be
415      * allowed to spend on behalf of `owner` through {transferFrom}. This is
416      * zero by default.
417      *
418      * This value changes when {approve} or {transferFrom} are called.
419      */
420     function allowance(address owner, address spender)
421         external
422         view
423         returns (uint256);
424 
425     /**
426      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
427      *
428      * Returns a boolean value indicating whether the operation succeeded.
429      *
430      * IMPORTANT: Beware that changing an allowance with this method brings the risk
431      * that someone may use both the old and the new allowance by unfortunate
432      * transaction ordering. One possible solution to mitigate this race
433      * condition is to first reduce the spender's allowance to 0 and set the
434      * desired value afterwards:
435      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
436      *
437      * Emits an {Approval} event.
438      */
439     function approve(address spender, uint256 amount) external returns (bool);
440 
441     /**
442      * @dev Moves `amount` tokens from `sender` to `recipient` using the
443      * allowance mechanism. `amount` is then deducted from the caller's
444      * allowance.
445      *
446      * Returns a boolean value indicating whether the operation succeeded.
447      *
448      * Emits a {Transfer} event.
449      */
450     function transferFrom(
451         address sender,
452         address recipient,
453         uint256 amount
454     ) external returns (bool);
455 
456     /**
457      * @dev Emitted when `value` tokens are moved from one account (`from`) to
458      * another (`to`).
459      *
460      * Note that `value` may be zero.
461      */
462     event Transfer(address indexed from, address indexed to, uint256 value);
463 
464     /**
465      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
466      * a call to {approve}. `value` is the new allowance.
467      */
468     event Approval(
469         address indexed owner,
470         address indexed spender,
471         uint256 value
472     );
473 }
474 
475 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol
476 
477 pragma solidity ^0.6.2;
478 
479 /**
480  * @dev Collection of functions related to the address type
481  */
482 library Address {
483     /**
484      * @dev Returns true if `account` is a contract.
485      *
486      * [IMPORTANT]
487      * ====
488      * It is unsafe to assume that an address for which this function returns
489      * false is an externally-owned account (EOA) and not a contract.
490      *
491      * Among others, `isContract` will return false for the following
492      * types of addresses:
493      *
494      *  - an externally-owned account
495      *  - a contract in construction
496      *  - an address where a contract will be created
497      *  - an address where a contract lived, but was destroyed
498      * ====
499      */
500     function isContract(address account) internal view returns (bool) {
501         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
502         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
503         // for accounts without code, i.e. `keccak256('')`
504         bytes32 codehash;
505 
506             bytes32 accountHash
507          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
508         // solhint-disable-next-line no-inline-assembly
509         assembly {
510             codehash := extcodehash(account)
511         }
512         return (codehash != accountHash && codehash != 0x0);
513     }
514 
515     /**
516      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
517      * `recipient`, forwarding all available gas and reverting on errors.
518      *
519      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
520      * of certain opcodes, possibly making contracts go over the 2300 gas limit
521      * imposed by `transfer`, making them unable to receive funds via
522      * `transfer`. {sendValue} removes this limitation.
523      *
524      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
525      *
526      * IMPORTANT: because control is transferred to `recipient`, care must be
527      * taken to not create reentrancy vulnerabilities. Consider using
528      * {ReentrancyGuard} or the
529      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
530      */
531     function sendValue(address payable recipient, uint256 amount) internal {
532         require(
533             address(this).balance >= amount,
534             "Address: insufficient balance"
535         );
536 
537         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
538         (bool success, ) = recipient.call{value: amount}("");
539         require(
540             success,
541             "Address: unable to send value, recipient may have reverted"
542         );
543     }
544 }
545 
546 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol
547 
548 pragma solidity ^0.6.0;
549 
550 /**
551  * @title SafeERC20
552  * @dev Wrappers around ERC20 operations that throw on failure (when the token
553  * contract returns false). Tokens that return no value (and instead revert or
554  * throw on failure) are also supported, non-reverting calls are assumed to be
555  * successful.
556  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
557  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
558  */
559 library SafeERC20 {
560     using SafeMath for uint256;
561     using Address for address;
562 
563     function safeTransfer(
564         IERC20 token,
565         address to,
566         uint256 value
567     ) internal {
568         _callOptionalReturn(
569             token,
570             abi.encodeWithSelector(token.transfer.selector, to, value)
571         );
572     }
573 
574     function safeTransferFrom(
575         IERC20 token,
576         address from,
577         address to,
578         uint256 value
579     ) internal {
580         _callOptionalReturn(
581             token,
582             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
583         );
584     }
585 
586     function safeApprove(
587         IERC20 token,
588         address spender,
589         uint256 value
590     ) internal {
591         // safeApprove should only be called when setting an initial allowance,
592         // or when resetting it to zero. To increase and decrease it, use
593         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
594         // solhint-disable-next-line max-line-length
595         require(
596             (value == 0) || (token.allowance(address(this), spender) == 0),
597             "SafeERC20: approve from non-zero to non-zero allowance"
598         );
599         _callOptionalReturn(
600             token,
601             abi.encodeWithSelector(token.approve.selector, spender, value)
602         );
603     }
604 
605     function safeIncreaseAllowance(
606         IERC20 token,
607         address spender,
608         uint256 value
609     ) internal {
610         uint256 newAllowance = token.allowance(address(this), spender).add(
611             value
612         );
613         _callOptionalReturn(
614             token,
615             abi.encodeWithSelector(
616                 token.approve.selector,
617                 spender,
618                 newAllowance
619             )
620         );
621     }
622 
623     function safeDecreaseAllowance(
624         IERC20 token,
625         address spender,
626         uint256 value
627     ) internal {
628         uint256 newAllowance = token.allowance(address(this), spender).sub(
629             value,
630             "SafeERC20: decreased allowance below zero"
631         );
632         _callOptionalReturn(
633             token,
634             abi.encodeWithSelector(
635                 token.approve.selector,
636                 spender,
637                 newAllowance
638             )
639         );
640     }
641 
642     /**
643      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
644      * on the return value: the return value is optional (but if data is returned, it must not be false).
645      * @param token The token targeted by the call.
646      * @param data The call data (encoded using abi.encode or one of its variants).
647      */
648     function _callOptionalReturn(IERC20 token, bytes memory data) private {
649         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
650         // we're implementing it ourselves.
651 
652         // A Solidity high level call has three parts:
653         //  1. The target address is checked to verify it contains contract code
654         //  2. The call itself is made, and success asserted
655         //  3. The return value is decoded, which in turn checks the size of the returned data.
656         // solhint-disable-next-line max-line-length
657         require(address(token).isContract(), "SafeERC20: call to non-contract");
658 
659         // solhint-disable-next-line avoid-low-level-calls
660         (bool success, bytes memory returndata) = address(token).call(data);
661         require(success, "SafeERC20: low-level call failed");
662 
663         if (returndata.length > 0) {
664             // Return data is optional
665             // solhint-disable-next-line max-line-length
666             require(
667                 abi.decode(returndata, (bool)),
668                 "SafeERC20: ERC20 operation did not succeed"
669             );
670         }
671     }
672 }
673 
674 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
675 
676 pragma solidity 0.6.12;
677 
678 interface IUniswapV2Pair {
679     event Approval(
680         address indexed owner,
681         address indexed spender,
682         uint256 value
683     );
684     event Transfer(address indexed from, address indexed to, uint256 value);
685 
686     function name() external pure returns (string memory);
687 
688     function symbol() external pure returns (string memory);
689 
690     function decimals() external pure returns (uint8);
691 
692     function totalSupply() external view returns (uint256);
693 
694     function balanceOf(address owner) external view returns (uint256);
695 
696     function allowance(address owner, address spender)
697         external
698         view
699         returns (uint256);
700 
701     function approve(address spender, uint256 value) external returns (bool);
702 
703     function transfer(address to, uint256 value) external returns (bool);
704 
705     function transferFrom(
706         address from,
707         address to,
708         uint256 value
709     ) external returns (bool);
710 
711     function DOMAIN_SEPARATOR() external view returns (bytes32);
712 
713     function PERMIT_TYPEHASH() external pure returns (bytes32);
714 
715     function nonces(address owner) external view returns (uint256);
716 
717     function permit(
718         address owner,
719         address spender,
720         uint256 value,
721         uint256 deadline,
722         uint8 v,
723         bytes32 r,
724         bytes32 s
725     ) external;
726 
727     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
728     event Burn(
729         address indexed sender,
730         uint256 amount0,
731         uint256 amount1,
732         address indexed to
733     );
734     event Swap(
735         address indexed sender,
736         uint256 amount0In,
737         uint256 amount1In,
738         uint256 amount0Out,
739         uint256 amount1Out,
740         address indexed to
741     );
742     event Sync(uint112 reserve0, uint112 reserve1);
743 
744     function MINIMUM_LIQUIDITY() external pure returns (uint256);
745 
746     function factory() external view returns (address);
747 
748     function token0() external view returns (address);
749 
750     function token1() external view returns (address);
751 
752     function getReserves()
753         external
754         view
755         returns (
756             uint112 reserve0,
757             uint112 reserve1,
758             uint32 blockTimestampLast
759         );
760 
761     function price0CumulativeLast() external view returns (uint256);
762 
763     function price1CumulativeLast() external view returns (uint256);
764 
765     function kLast() external view returns (uint256);
766 
767     function mint(address to) external returns (uint256 liquidity);
768 
769     function burn(address to)
770         external
771         returns (uint256 amount0, uint256 amount1);
772 
773     function swap(
774         uint256 amount0Out,
775         uint256 amount1Out,
776         address to,
777         bytes calldata data
778     ) external;
779 
780     function skim(address to) external;
781 
782     function sync() external;
783 
784     function initialize(address, address) external;
785 }
786 
787 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
788 
789 pragma solidity 0.6.12;
790 
791 interface IUniswapV2Factory {
792     event PairCreated(
793         address indexed token0,
794         address indexed token1,
795         address pair,
796         uint256
797     );
798 
799     function feeTo() external view returns (address);
800 
801     function feeToSetter() external view returns (address);
802 
803     function migrator() external view returns (address);
804 
805     function getPair(address tokenA, address tokenB)
806         external
807         view
808         returns (address pair);
809 
810     function allPairs(uint256) external view returns (address pair);
811 
812     function allPairsLength() external view returns (uint256);
813 
814     function createPair(address tokenA, address tokenB)
815         external
816         returns (address pair);
817 
818     function setFeeTo(address) external;
819 
820     function setFeeToSetter(address) external;
821 
822     function setMigrator(address) external;
823 }
824 
825 // File: contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
826 
827 pragma solidity 0.6.12;
828 
829 interface IUniswapV2Router01 {
830     function factory() external pure returns (address);
831 
832     function WETH() external pure returns (address);
833 
834     function addLiquidity(
835         address tokenA,
836         address tokenB,
837         uint256 amountADesired,
838         uint256 amountBDesired,
839         uint256 amountAMin,
840         uint256 amountBMin,
841         address to,
842         uint256 deadline
843     )
844         external
845         returns (
846             uint256 amountA,
847             uint256 amountB,
848             uint256 liquidity
849         );
850 
851     function addLiquidityETH(
852         address token,
853         uint256 amountTokenDesired,
854         uint256 amountTokenMin,
855         uint256 amountETHMin,
856         address to,
857         uint256 deadline
858     )
859         external
860         payable
861         returns (
862             uint256 amountToken,
863             uint256 amountETH,
864             uint256 liquidity
865         );
866 
867     function removeLiquidity(
868         address tokenA,
869         address tokenB,
870         uint256 liquidity,
871         uint256 amountAMin,
872         uint256 amountBMin,
873         address to,
874         uint256 deadline
875     ) external returns (uint256 amountA, uint256 amountB);
876 
877     function removeLiquidityETH(
878         address token,
879         uint256 liquidity,
880         uint256 amountTokenMin,
881         uint256 amountETHMin,
882         address to,
883         uint256 deadline
884     ) external returns (uint256 amountToken, uint256 amountETH);
885 
886     function removeLiquidityWithPermit(
887         address tokenA,
888         address tokenB,
889         uint256 liquidity,
890         uint256 amountAMin,
891         uint256 amountBMin,
892         address to,
893         uint256 deadline,
894         bool approveMax,
895         uint8 v,
896         bytes32 r,
897         bytes32 s
898     ) external returns (uint256 amountA, uint256 amountB);
899 
900     function removeLiquidityETHWithPermit(
901         address token,
902         uint256 liquidity,
903         uint256 amountTokenMin,
904         uint256 amountETHMin,
905         address to,
906         uint256 deadline,
907         bool approveMax,
908         uint8 v,
909         bytes32 r,
910         bytes32 s
911     ) external returns (uint256 amountToken, uint256 amountETH);
912 
913     function swapExactTokensForTokens(
914         uint256 amountIn,
915         uint256 amountOutMin,
916         address[] calldata path,
917         address to,
918         uint256 deadline
919     ) external returns (uint256[] memory amounts);
920 
921     function swapTokensForExactTokens(
922         uint256 amountOut,
923         uint256 amountInMax,
924         address[] calldata path,
925         address to,
926         uint256 deadline
927     ) external returns (uint256[] memory amounts);
928 
929     function swapExactETHForTokens(
930         uint256 amountOutMin,
931         address[] calldata path,
932         address to,
933         uint256 deadline
934     ) external payable returns (uint256[] memory amounts);
935 
936     function swapTokensForExactETH(
937         uint256 amountOut,
938         uint256 amountInMax,
939         address[] calldata path,
940         address to,
941         uint256 deadline
942     ) external returns (uint256[] memory amounts);
943 
944     function swapExactTokensForETH(
945         uint256 amountIn,
946         uint256 amountOutMin,
947         address[] calldata path,
948         address to,
949         uint256 deadline
950     ) external returns (uint256[] memory amounts);
951 
952     function swapETHForExactTokens(
953         uint256 amountOut,
954         address[] calldata path,
955         address to,
956         uint256 deadline
957     ) external payable returns (uint256[] memory amounts);
958 
959     function quote(
960         uint256 amountA,
961         uint256 reserveA,
962         uint256 reserveB
963     ) external pure returns (uint256 amountB);
964 
965     function getAmountOut(
966         uint256 amountIn,
967         uint256 reserveIn,
968         uint256 reserveOut
969     ) external pure returns (uint256 amountOut);
970 
971     function getAmountIn(
972         uint256 amountOut,
973         uint256 reserveIn,
974         uint256 reserveOut
975     ) external pure returns (uint256 amountIn);
976 
977     function getAmountsOut(uint256 amountIn, address[] calldata path)
978         external
979         view
980         returns (uint256[] memory amounts);
981 
982     function getAmountsIn(uint256 amountOut, address[] calldata path)
983         external
984         view
985         returns (uint256[] memory amounts);
986 }
987 
988 // File: contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
989 
990 pragma solidity 0.6.12;
991 
992 interface IUniswapV2Router02 is IUniswapV2Router01 {
993     function removeLiquidityETHSupportingFeeOnTransferTokens(
994         address token,
995         uint256 liquidity,
996         uint256 amountTokenMin,
997         uint256 amountETHMin,
998         address to,
999         uint256 deadline
1000     ) external returns (uint256 amountETH);
1001 
1002     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1003         address token,
1004         uint256 liquidity,
1005         uint256 amountTokenMin,
1006         uint256 amountETHMin,
1007         address to,
1008         uint256 deadline,
1009         bool approveMax,
1010         uint8 v,
1011         bytes32 r,
1012         bytes32 s
1013     ) external returns (uint256 amountETH);
1014 
1015     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1016         uint256 amountIn,
1017         uint256 amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint256 deadline
1021     ) external;
1022 
1023     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1024         uint256 amountOutMin,
1025         address[] calldata path,
1026         address to,
1027         uint256 deadline
1028     ) external payable;
1029 
1030     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1031         uint256 amountIn,
1032         uint256 amountOutMin,
1033         address[] calldata path,
1034         address to,
1035         uint256 deadline
1036     ) external;
1037 }
1038 
1039 // File: contracts/uniswapv2/interfaces/IWETH.sol
1040 
1041 pragma solidity 0.6.12;
1042 
1043 interface IWETH {
1044     function deposit() external payable;
1045 
1046     function transfer(address to, uint256 value) external returns (bool);
1047 
1048     function withdraw(uint256) external;
1049 
1050     function approve(address guy, uint256 wad) external returns (bool);
1051 
1052     function balanceOf(address addr) external view returns (uint256);
1053 }
1054 
1055 // File: contracts/INerdBaseToken.sol
1056 
1057 pragma solidity 0.6.12;
1058 
1059 /**
1060  * @dev Interface of the ERC20 standard as defined in the EIP.
1061  */
1062 interface INerdBaseToken {
1063     /**
1064      * @dev Returns the amount of tokens in existence.
1065      */
1066     function totalSupply() external view returns (uint256);
1067 
1068     /**
1069      * @dev Returns the amount of tokens owned by `account`.
1070      */
1071     function balanceOf(address account) external view returns (uint256);
1072 
1073     /**
1074      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1075      *
1076      * Returns a boolean value indicating whether the operation succeeded.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function transfer(address recipient, uint256 amount)
1081         external
1082         returns (bool);
1083 
1084     /**
1085      * @dev Returns the remaining number of tokens that `spender` will be
1086      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1087      * zero by default.
1088      *
1089      * This value changes when {approve} or {transferFrom} are called.
1090      */
1091     function allowance(address owner, address spender)
1092         external
1093         view
1094         returns (uint256);
1095 
1096     /**
1097      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1098      *
1099      * Returns a boolean value indicating whether the operation succeeded.
1100      *
1101      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1102      * that someone may use both the old and the new allowance by unfortunate
1103      * transaction ordering. One possible solution to mitigate this race
1104      * condition is to first reduce the spender's allowance to 0 and set the
1105      * desired value afterwards:
1106      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1107      *
1108      * Emits an {Approval} event.
1109      */
1110     function approve(address spender, uint256 amount) external returns (bool);
1111 
1112     /**
1113      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1114      * allowance mechanism. `amount` is then deducted from the caller's
1115      * allowance.
1116      *
1117      * Returns a boolean value indicating whether the operation succeeded.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function transferFrom(
1122         address sender,
1123         address recipient,
1124         uint256 amount
1125     ) external returns (bool);
1126 
1127     /**
1128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1129      * another (`to`).
1130      *
1131      * Note that `value` may be zero.
1132      */
1133     event Transfer(address indexed from, address indexed to, uint256 value);
1134 
1135     /**
1136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1137      * a call to {approve}. `value` is the new allowance.
1138      */
1139     event Approval(
1140         address indexed owner,
1141         address indexed spender,
1142         uint256 value
1143     );
1144 
1145     event Log(string log);
1146 }
1147 
1148 interface INerdBaseTokenLGE is INerdBaseToken {
1149     function getAllocatedLP(address _user) external view returns (uint256);
1150 
1151     function getLpReleaseStart() external view returns (uint256);
1152 
1153     function getTokenUniswapPair() external view returns (address);
1154 
1155     function getTotalLPTokensMinted() external view returns (uint256);
1156 
1157     function getReleasableLPTokensMinted() external view returns (uint256);
1158 
1159     function isLPGenerationCompleted() external view returns (bool);
1160 
1161     function tokenUniswapPair() external view returns (address);
1162 
1163     function getUniswapRouterV2() external view returns (address);
1164 
1165     function getUniswapFactory() external view returns (address);
1166 
1167     function devFundAddress() external view returns (address);
1168 
1169     function transferCheckerAddress() external view returns (address);
1170 
1171     function feeDistributor() external view returns (address);
1172 }
1173 
1174 // File: contracts/IFeeApprover.sol
1175 
1176 pragma solidity 0.6.12;
1177 
1178 interface IFeeApprover {
1179     function check(
1180         address sender,
1181         address recipient,
1182         uint256 amount
1183     ) external returns (bool);
1184 
1185     function setFeeMultiplier(uint256 _feeMultiplier) external;
1186 
1187     function feePercentX100() external view returns (uint256);
1188 
1189     function setTokenUniswapPair(address _tokenUniswapPair) external;
1190 
1191     function setNerdTokenAddress(address _nerdTokenAddress) external;
1192 
1193     function updateTxState() external;
1194 
1195     function calculateAmountsAfterFee(
1196         address sender,
1197         address recipient,
1198         uint256 amount
1199     )
1200         external
1201         returns (uint256 transferToAmount, uint256 transferToFeeBearerAmount);
1202 
1203     function setPaused() external;
1204 }
1205 
1206 // File: contracts/INerdVault.sol
1207 
1208 pragma solidity 0.6.12;
1209 
1210 interface INerdVault {
1211     function updatePendingRewards() external;
1212 
1213     function depositFor(
1214         address _depositFor,
1215         uint256 _pid,
1216         uint256 _amount
1217     ) external;
1218 
1219     function poolInfo(uint256 _pid)
1220         external
1221         view
1222         returns (
1223             address,
1224             uint256,
1225             uint256,
1226             uint256,
1227             bool,
1228             uint256,
1229             uint256,
1230             uint256,
1231             uint256
1232         );
1233 }
1234 
1235 // File: @nomiclabs/buidler/console.sol
1236 
1237 pragma solidity >=0.4.22 <0.8.0;
1238 
1239 library console {
1240     address constant CONSOLE_ADDRESS = address(
1241         0x000000000000000000636F6e736F6c652e6c6f67
1242     );
1243 
1244     function _sendLogPayload(bytes memory payload) private view {
1245         uint256 payloadLength = payload.length;
1246         address consoleAddress = CONSOLE_ADDRESS;
1247         assembly {
1248             let payloadStart := add(payload, 32)
1249             let r := staticcall(
1250                 gas(),
1251                 consoleAddress,
1252                 payloadStart,
1253                 payloadLength,
1254                 0,
1255                 0
1256             )
1257         }
1258     }
1259 
1260     function log() internal view {
1261         _sendLogPayload(abi.encodeWithSignature("log()"));
1262     }
1263 
1264     function logInt(int256 p0) internal view {
1265         _sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1266     }
1267 
1268     function logUint(uint256 p0) internal view {
1269         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1270     }
1271 
1272     function logString(string memory p0) internal view {
1273         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1274     }
1275 
1276     function logBool(bool p0) internal view {
1277         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1278     }
1279 
1280     function logAddress(address p0) internal view {
1281         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1282     }
1283 
1284     function logBytes(bytes memory p0) internal view {
1285         _sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1286     }
1287 
1288     function logByte(bytes1 p0) internal view {
1289         _sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
1290     }
1291 
1292     function logBytes1(bytes1 p0) internal view {
1293         _sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1294     }
1295 
1296     function logBytes2(bytes2 p0) internal view {
1297         _sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1298     }
1299 
1300     function logBytes3(bytes3 p0) internal view {
1301         _sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1302     }
1303 
1304     function logBytes4(bytes4 p0) internal view {
1305         _sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1306     }
1307 
1308     function logBytes5(bytes5 p0) internal view {
1309         _sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1310     }
1311 
1312     function logBytes6(bytes6 p0) internal view {
1313         _sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1314     }
1315 
1316     function logBytes7(bytes7 p0) internal view {
1317         _sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1318     }
1319 
1320     function logBytes8(bytes8 p0) internal view {
1321         _sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1322     }
1323 
1324     function logBytes9(bytes9 p0) internal view {
1325         _sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1326     }
1327 
1328     function logBytes10(bytes10 p0) internal view {
1329         _sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1330     }
1331 
1332     function logBytes11(bytes11 p0) internal view {
1333         _sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1334     }
1335 
1336     function logBytes12(bytes12 p0) internal view {
1337         _sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1338     }
1339 
1340     function logBytes13(bytes13 p0) internal view {
1341         _sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1342     }
1343 
1344     function logBytes14(bytes14 p0) internal view {
1345         _sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1346     }
1347 
1348     function logBytes15(bytes15 p0) internal view {
1349         _sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1350     }
1351 
1352     function logBytes16(bytes16 p0) internal view {
1353         _sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1354     }
1355 
1356     function logBytes17(bytes17 p0) internal view {
1357         _sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1358     }
1359 
1360     function logBytes18(bytes18 p0) internal view {
1361         _sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1362     }
1363 
1364     function logBytes19(bytes19 p0) internal view {
1365         _sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1366     }
1367 
1368     function logBytes20(bytes20 p0) internal view {
1369         _sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1370     }
1371 
1372     function logBytes21(bytes21 p0) internal view {
1373         _sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1374     }
1375 
1376     function logBytes22(bytes22 p0) internal view {
1377         _sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1378     }
1379 
1380     function logBytes23(bytes23 p0) internal view {
1381         _sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1382     }
1383 
1384     function logBytes24(bytes24 p0) internal view {
1385         _sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1386     }
1387 
1388     function logBytes25(bytes25 p0) internal view {
1389         _sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1390     }
1391 
1392     function logBytes26(bytes26 p0) internal view {
1393         _sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1394     }
1395 
1396     function logBytes27(bytes27 p0) internal view {
1397         _sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1398     }
1399 
1400     function logBytes28(bytes28 p0) internal view {
1401         _sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1402     }
1403 
1404     function logBytes29(bytes29 p0) internal view {
1405         _sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1406     }
1407 
1408     function logBytes30(bytes30 p0) internal view {
1409         _sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1410     }
1411 
1412     function logBytes31(bytes31 p0) internal view {
1413         _sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1414     }
1415 
1416     function logBytes32(bytes32 p0) internal view {
1417         _sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1418     }
1419 
1420     function log(uint256 p0) internal view {
1421         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1422     }
1423 
1424     function log(string memory p0) internal view {
1425         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1426     }
1427 
1428     function log(bool p0) internal view {
1429         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1430     }
1431 
1432     function log(address p0) internal view {
1433         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1434     }
1435 
1436     function log(uint256 p0, uint256 p1) internal view {
1437         _sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1438     }
1439 
1440     function log(uint256 p0, string memory p1) internal view {
1441         _sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1442     }
1443 
1444     function log(uint256 p0, bool p1) internal view {
1445         _sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1446     }
1447 
1448     function log(uint256 p0, address p1) internal view {
1449         _sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1450     }
1451 
1452     function log(string memory p0, uint256 p1) internal view {
1453         _sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1454     }
1455 
1456     function log(string memory p0, string memory p1) internal view {
1457         _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1458     }
1459 
1460     function log(string memory p0, bool p1) internal view {
1461         _sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1462     }
1463 
1464     function log(string memory p0, address p1) internal view {
1465         _sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1466     }
1467 
1468     function log(bool p0, uint256 p1) internal view {
1469         _sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1470     }
1471 
1472     function log(bool p0, string memory p1) internal view {
1473         _sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1474     }
1475 
1476     function log(bool p0, bool p1) internal view {
1477         _sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1478     }
1479 
1480     function log(bool p0, address p1) internal view {
1481         _sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1482     }
1483 
1484     function log(address p0, uint256 p1) internal view {
1485         _sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1486     }
1487 
1488     function log(address p0, string memory p1) internal view {
1489         _sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1490     }
1491 
1492     function log(address p0, bool p1) internal view {
1493         _sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1494     }
1495 
1496     function log(address p0, address p1) internal view {
1497         _sendLogPayload(
1498             abi.encodeWithSignature("log(address,address)", p0, p1)
1499         );
1500     }
1501 
1502     function log(
1503         uint256 p0,
1504         uint256 p1,
1505         uint256 p2
1506     ) internal view {
1507         _sendLogPayload(
1508             abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2)
1509         );
1510     }
1511 
1512     function log(
1513         uint256 p0,
1514         uint256 p1,
1515         string memory p2
1516     ) internal view {
1517         _sendLogPayload(
1518             abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2)
1519         );
1520     }
1521 
1522     function log(
1523         uint256 p0,
1524         uint256 p1,
1525         bool p2
1526     ) internal view {
1527         _sendLogPayload(
1528             abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2)
1529         );
1530     }
1531 
1532     function log(
1533         uint256 p0,
1534         uint256 p1,
1535         address p2
1536     ) internal view {
1537         _sendLogPayload(
1538             abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2)
1539         );
1540     }
1541 
1542     function log(
1543         uint256 p0,
1544         string memory p1,
1545         uint256 p2
1546     ) internal view {
1547         _sendLogPayload(
1548             abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2)
1549         );
1550     }
1551 
1552     function log(
1553         uint256 p0,
1554         string memory p1,
1555         string memory p2
1556     ) internal view {
1557         _sendLogPayload(
1558             abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2)
1559         );
1560     }
1561 
1562     function log(
1563         uint256 p0,
1564         string memory p1,
1565         bool p2
1566     ) internal view {
1567         _sendLogPayload(
1568             abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2)
1569         );
1570     }
1571 
1572     function log(
1573         uint256 p0,
1574         string memory p1,
1575         address p2
1576     ) internal view {
1577         _sendLogPayload(
1578             abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2)
1579         );
1580     }
1581 
1582     function log(
1583         uint256 p0,
1584         bool p1,
1585         uint256 p2
1586     ) internal view {
1587         _sendLogPayload(
1588             abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2)
1589         );
1590     }
1591 
1592     function log(
1593         uint256 p0,
1594         bool p1,
1595         string memory p2
1596     ) internal view {
1597         _sendLogPayload(
1598             abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2)
1599         );
1600     }
1601 
1602     function log(
1603         uint256 p0,
1604         bool p1,
1605         bool p2
1606     ) internal view {
1607         _sendLogPayload(
1608             abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2)
1609         );
1610     }
1611 
1612     function log(
1613         uint256 p0,
1614         bool p1,
1615         address p2
1616     ) internal view {
1617         _sendLogPayload(
1618             abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2)
1619         );
1620     }
1621 
1622     function log(
1623         uint256 p0,
1624         address p1,
1625         uint256 p2
1626     ) internal view {
1627         _sendLogPayload(
1628             abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2)
1629         );
1630     }
1631 
1632     function log(
1633         uint256 p0,
1634         address p1,
1635         string memory p2
1636     ) internal view {
1637         _sendLogPayload(
1638             abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2)
1639         );
1640     }
1641 
1642     function log(
1643         uint256 p0,
1644         address p1,
1645         bool p2
1646     ) internal view {
1647         _sendLogPayload(
1648             abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2)
1649         );
1650     }
1651 
1652     function log(
1653         uint256 p0,
1654         address p1,
1655         address p2
1656     ) internal view {
1657         _sendLogPayload(
1658             abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2)
1659         );
1660     }
1661 
1662     function log(
1663         string memory p0,
1664         uint256 p1,
1665         uint256 p2
1666     ) internal view {
1667         _sendLogPayload(
1668             abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2)
1669         );
1670     }
1671 
1672     function log(
1673         string memory p0,
1674         uint256 p1,
1675         string memory p2
1676     ) internal view {
1677         _sendLogPayload(
1678             abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2)
1679         );
1680     }
1681 
1682     function log(
1683         string memory p0,
1684         uint256 p1,
1685         bool p2
1686     ) internal view {
1687         _sendLogPayload(
1688             abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2)
1689         );
1690     }
1691 
1692     function log(
1693         string memory p0,
1694         uint256 p1,
1695         address p2
1696     ) internal view {
1697         _sendLogPayload(
1698             abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2)
1699         );
1700     }
1701 
1702     function log(
1703         string memory p0,
1704         string memory p1,
1705         uint256 p2
1706     ) internal view {
1707         _sendLogPayload(
1708             abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2)
1709         );
1710     }
1711 
1712     function log(
1713         string memory p0,
1714         string memory p1,
1715         string memory p2
1716     ) internal view {
1717         _sendLogPayload(
1718             abi.encodeWithSignature("log(string,string,string)", p0, p1, p2)
1719         );
1720     }
1721 
1722     function log(
1723         string memory p0,
1724         string memory p1,
1725         bool p2
1726     ) internal view {
1727         _sendLogPayload(
1728             abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2)
1729         );
1730     }
1731 
1732     function log(
1733         string memory p0,
1734         string memory p1,
1735         address p2
1736     ) internal view {
1737         _sendLogPayload(
1738             abi.encodeWithSignature("log(string,string,address)", p0, p1, p2)
1739         );
1740     }
1741 
1742     function log(
1743         string memory p0,
1744         bool p1,
1745         uint256 p2
1746     ) internal view {
1747         _sendLogPayload(
1748             abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2)
1749         );
1750     }
1751 
1752     function log(
1753         string memory p0,
1754         bool p1,
1755         string memory p2
1756     ) internal view {
1757         _sendLogPayload(
1758             abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2)
1759         );
1760     }
1761 
1762     function log(
1763         string memory p0,
1764         bool p1,
1765         bool p2
1766     ) internal view {
1767         _sendLogPayload(
1768             abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2)
1769         );
1770     }
1771 
1772     function log(
1773         string memory p0,
1774         bool p1,
1775         address p2
1776     ) internal view {
1777         _sendLogPayload(
1778             abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2)
1779         );
1780     }
1781 
1782     function log(
1783         string memory p0,
1784         address p1,
1785         uint256 p2
1786     ) internal view {
1787         _sendLogPayload(
1788             abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2)
1789         );
1790     }
1791 
1792     function log(
1793         string memory p0,
1794         address p1,
1795         string memory p2
1796     ) internal view {
1797         _sendLogPayload(
1798             abi.encodeWithSignature("log(string,address,string)", p0, p1, p2)
1799         );
1800     }
1801 
1802     function log(
1803         string memory p0,
1804         address p1,
1805         bool p2
1806     ) internal view {
1807         _sendLogPayload(
1808             abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2)
1809         );
1810     }
1811 
1812     function log(
1813         string memory p0,
1814         address p1,
1815         address p2
1816     ) internal view {
1817         _sendLogPayload(
1818             abi.encodeWithSignature("log(string,address,address)", p0, p1, p2)
1819         );
1820     }
1821 
1822     function log(
1823         bool p0,
1824         uint256 p1,
1825         uint256 p2
1826     ) internal view {
1827         _sendLogPayload(
1828             abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2)
1829         );
1830     }
1831 
1832     function log(
1833         bool p0,
1834         uint256 p1,
1835         string memory p2
1836     ) internal view {
1837         _sendLogPayload(
1838             abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2)
1839         );
1840     }
1841 
1842     function log(
1843         bool p0,
1844         uint256 p1,
1845         bool p2
1846     ) internal view {
1847         _sendLogPayload(
1848             abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2)
1849         );
1850     }
1851 
1852     function log(
1853         bool p0,
1854         uint256 p1,
1855         address p2
1856     ) internal view {
1857         _sendLogPayload(
1858             abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2)
1859         );
1860     }
1861 
1862     function log(
1863         bool p0,
1864         string memory p1,
1865         uint256 p2
1866     ) internal view {
1867         _sendLogPayload(
1868             abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2)
1869         );
1870     }
1871 
1872     function log(
1873         bool p0,
1874         string memory p1,
1875         string memory p2
1876     ) internal view {
1877         _sendLogPayload(
1878             abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2)
1879         );
1880     }
1881 
1882     function log(
1883         bool p0,
1884         string memory p1,
1885         bool p2
1886     ) internal view {
1887         _sendLogPayload(
1888             abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2)
1889         );
1890     }
1891 
1892     function log(
1893         bool p0,
1894         string memory p1,
1895         address p2
1896     ) internal view {
1897         _sendLogPayload(
1898             abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2)
1899         );
1900     }
1901 
1902     function log(
1903         bool p0,
1904         bool p1,
1905         uint256 p2
1906     ) internal view {
1907         _sendLogPayload(
1908             abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2)
1909         );
1910     }
1911 
1912     function log(
1913         bool p0,
1914         bool p1,
1915         string memory p2
1916     ) internal view {
1917         _sendLogPayload(
1918             abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2)
1919         );
1920     }
1921 
1922     function log(
1923         bool p0,
1924         bool p1,
1925         bool p2
1926     ) internal view {
1927         _sendLogPayload(
1928             abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2)
1929         );
1930     }
1931 
1932     function log(
1933         bool p0,
1934         bool p1,
1935         address p2
1936     ) internal view {
1937         _sendLogPayload(
1938             abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2)
1939         );
1940     }
1941 
1942     function log(
1943         bool p0,
1944         address p1,
1945         uint256 p2
1946     ) internal view {
1947         _sendLogPayload(
1948             abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2)
1949         );
1950     }
1951 
1952     function log(
1953         bool p0,
1954         address p1,
1955         string memory p2
1956     ) internal view {
1957         _sendLogPayload(
1958             abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2)
1959         );
1960     }
1961 
1962     function log(
1963         bool p0,
1964         address p1,
1965         bool p2
1966     ) internal view {
1967         _sendLogPayload(
1968             abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2)
1969         );
1970     }
1971 
1972     function log(
1973         bool p0,
1974         address p1,
1975         address p2
1976     ) internal view {
1977         _sendLogPayload(
1978             abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2)
1979         );
1980     }
1981 
1982     function log(
1983         address p0,
1984         uint256 p1,
1985         uint256 p2
1986     ) internal view {
1987         _sendLogPayload(
1988             abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2)
1989         );
1990     }
1991 
1992     function log(
1993         address p0,
1994         uint256 p1,
1995         string memory p2
1996     ) internal view {
1997         _sendLogPayload(
1998             abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2)
1999         );
2000     }
2001 
2002     function log(
2003         address p0,
2004         uint256 p1,
2005         bool p2
2006     ) internal view {
2007         _sendLogPayload(
2008             abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2)
2009         );
2010     }
2011 
2012     function log(
2013         address p0,
2014         uint256 p1,
2015         address p2
2016     ) internal view {
2017         _sendLogPayload(
2018             abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2)
2019         );
2020     }
2021 
2022     function log(
2023         address p0,
2024         string memory p1,
2025         uint256 p2
2026     ) internal view {
2027         _sendLogPayload(
2028             abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2)
2029         );
2030     }
2031 
2032     function log(
2033         address p0,
2034         string memory p1,
2035         string memory p2
2036     ) internal view {
2037         _sendLogPayload(
2038             abi.encodeWithSignature("log(address,string,string)", p0, p1, p2)
2039         );
2040     }
2041 
2042     function log(
2043         address p0,
2044         string memory p1,
2045         bool p2
2046     ) internal view {
2047         _sendLogPayload(
2048             abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2)
2049         );
2050     }
2051 
2052     function log(
2053         address p0,
2054         string memory p1,
2055         address p2
2056     ) internal view {
2057         _sendLogPayload(
2058             abi.encodeWithSignature("log(address,string,address)", p0, p1, p2)
2059         );
2060     }
2061 
2062     function log(
2063         address p0,
2064         bool p1,
2065         uint256 p2
2066     ) internal view {
2067         _sendLogPayload(
2068             abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2)
2069         );
2070     }
2071 
2072     function log(
2073         address p0,
2074         bool p1,
2075         string memory p2
2076     ) internal view {
2077         _sendLogPayload(
2078             abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2)
2079         );
2080     }
2081 
2082     function log(
2083         address p0,
2084         bool p1,
2085         bool p2
2086     ) internal view {
2087         _sendLogPayload(
2088             abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2)
2089         );
2090     }
2091 
2092     function log(
2093         address p0,
2094         bool p1,
2095         address p2
2096     ) internal view {
2097         _sendLogPayload(
2098             abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2)
2099         );
2100     }
2101 
2102     function log(
2103         address p0,
2104         address p1,
2105         uint256 p2
2106     ) internal view {
2107         _sendLogPayload(
2108             abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2)
2109         );
2110     }
2111 
2112     function log(
2113         address p0,
2114         address p1,
2115         string memory p2
2116     ) internal view {
2117         _sendLogPayload(
2118             abi.encodeWithSignature("log(address,address,string)", p0, p1, p2)
2119         );
2120     }
2121 
2122     function log(
2123         address p0,
2124         address p1,
2125         bool p2
2126     ) internal view {
2127         _sendLogPayload(
2128             abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2)
2129         );
2130     }
2131 
2132     function log(
2133         address p0,
2134         address p1,
2135         address p2
2136     ) internal view {
2137         _sendLogPayload(
2138             abi.encodeWithSignature("log(address,address,address)", p0, p1, p2)
2139         );
2140     }
2141 
2142     function log(
2143         uint256 p0,
2144         uint256 p1,
2145         uint256 p2,
2146         uint256 p3
2147     ) internal view {
2148         _sendLogPayload(
2149             abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3)
2150         );
2151     }
2152 
2153     function log(
2154         uint256 p0,
2155         uint256 p1,
2156         uint256 p2,
2157         string memory p3
2158     ) internal view {
2159         _sendLogPayload(
2160             abi.encodeWithSignature(
2161                 "log(uint,uint,uint,string)",
2162                 p0,
2163                 p1,
2164                 p2,
2165                 p3
2166             )
2167         );
2168     }
2169 
2170     function log(
2171         uint256 p0,
2172         uint256 p1,
2173         uint256 p2,
2174         bool p3
2175     ) internal view {
2176         _sendLogPayload(
2177             abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3)
2178         );
2179     }
2180 
2181     function log(
2182         uint256 p0,
2183         uint256 p1,
2184         uint256 p2,
2185         address p3
2186     ) internal view {
2187         _sendLogPayload(
2188             abi.encodeWithSignature(
2189                 "log(uint,uint,uint,address)",
2190                 p0,
2191                 p1,
2192                 p2,
2193                 p3
2194             )
2195         );
2196     }
2197 
2198     function log(
2199         uint256 p0,
2200         uint256 p1,
2201         string memory p2,
2202         uint256 p3
2203     ) internal view {
2204         _sendLogPayload(
2205             abi.encodeWithSignature(
2206                 "log(uint,uint,string,uint)",
2207                 p0,
2208                 p1,
2209                 p2,
2210                 p3
2211             )
2212         );
2213     }
2214 
2215     function log(
2216         uint256 p0,
2217         uint256 p1,
2218         string memory p2,
2219         string memory p3
2220     ) internal view {
2221         _sendLogPayload(
2222             abi.encodeWithSignature(
2223                 "log(uint,uint,string,string)",
2224                 p0,
2225                 p1,
2226                 p2,
2227                 p3
2228             )
2229         );
2230     }
2231 
2232     function log(
2233         uint256 p0,
2234         uint256 p1,
2235         string memory p2,
2236         bool p3
2237     ) internal view {
2238         _sendLogPayload(
2239             abi.encodeWithSignature(
2240                 "log(uint,uint,string,bool)",
2241                 p0,
2242                 p1,
2243                 p2,
2244                 p3
2245             )
2246         );
2247     }
2248 
2249     function log(
2250         uint256 p0,
2251         uint256 p1,
2252         string memory p2,
2253         address p3
2254     ) internal view {
2255         _sendLogPayload(
2256             abi.encodeWithSignature(
2257                 "log(uint,uint,string,address)",
2258                 p0,
2259                 p1,
2260                 p2,
2261                 p3
2262             )
2263         );
2264     }
2265 
2266     function log(
2267         uint256 p0,
2268         uint256 p1,
2269         bool p2,
2270         uint256 p3
2271     ) internal view {
2272         _sendLogPayload(
2273             abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3)
2274         );
2275     }
2276 
2277     function log(
2278         uint256 p0,
2279         uint256 p1,
2280         bool p2,
2281         string memory p3
2282     ) internal view {
2283         _sendLogPayload(
2284             abi.encodeWithSignature(
2285                 "log(uint,uint,bool,string)",
2286                 p0,
2287                 p1,
2288                 p2,
2289                 p3
2290             )
2291         );
2292     }
2293 
2294     function log(
2295         uint256 p0,
2296         uint256 p1,
2297         bool p2,
2298         bool p3
2299     ) internal view {
2300         _sendLogPayload(
2301             abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3)
2302         );
2303     }
2304 
2305     function log(
2306         uint256 p0,
2307         uint256 p1,
2308         bool p2,
2309         address p3
2310     ) internal view {
2311         _sendLogPayload(
2312             abi.encodeWithSignature(
2313                 "log(uint,uint,bool,address)",
2314                 p0,
2315                 p1,
2316                 p2,
2317                 p3
2318             )
2319         );
2320     }
2321 
2322     function log(
2323         uint256 p0,
2324         uint256 p1,
2325         address p2,
2326         uint256 p3
2327     ) internal view {
2328         _sendLogPayload(
2329             abi.encodeWithSignature(
2330                 "log(uint,uint,address,uint)",
2331                 p0,
2332                 p1,
2333                 p2,
2334                 p3
2335             )
2336         );
2337     }
2338 
2339     function log(
2340         uint256 p0,
2341         uint256 p1,
2342         address p2,
2343         string memory p3
2344     ) internal view {
2345         _sendLogPayload(
2346             abi.encodeWithSignature(
2347                 "log(uint,uint,address,string)",
2348                 p0,
2349                 p1,
2350                 p2,
2351                 p3
2352             )
2353         );
2354     }
2355 
2356     function log(
2357         uint256 p0,
2358         uint256 p1,
2359         address p2,
2360         bool p3
2361     ) internal view {
2362         _sendLogPayload(
2363             abi.encodeWithSignature(
2364                 "log(uint,uint,address,bool)",
2365                 p0,
2366                 p1,
2367                 p2,
2368                 p3
2369             )
2370         );
2371     }
2372 
2373     function log(
2374         uint256 p0,
2375         uint256 p1,
2376         address p2,
2377         address p3
2378     ) internal view {
2379         _sendLogPayload(
2380             abi.encodeWithSignature(
2381                 "log(uint,uint,address,address)",
2382                 p0,
2383                 p1,
2384                 p2,
2385                 p3
2386             )
2387         );
2388     }
2389 
2390     function log(
2391         uint256 p0,
2392         string memory p1,
2393         uint256 p2,
2394         uint256 p3
2395     ) internal view {
2396         _sendLogPayload(
2397             abi.encodeWithSignature(
2398                 "log(uint,string,uint,uint)",
2399                 p0,
2400                 p1,
2401                 p2,
2402                 p3
2403             )
2404         );
2405     }
2406 
2407     function log(
2408         uint256 p0,
2409         string memory p1,
2410         uint256 p2,
2411         string memory p3
2412     ) internal view {
2413         _sendLogPayload(
2414             abi.encodeWithSignature(
2415                 "log(uint,string,uint,string)",
2416                 p0,
2417                 p1,
2418                 p2,
2419                 p3
2420             )
2421         );
2422     }
2423 
2424     function log(
2425         uint256 p0,
2426         string memory p1,
2427         uint256 p2,
2428         bool p3
2429     ) internal view {
2430         _sendLogPayload(
2431             abi.encodeWithSignature(
2432                 "log(uint,string,uint,bool)",
2433                 p0,
2434                 p1,
2435                 p2,
2436                 p3
2437             )
2438         );
2439     }
2440 
2441     function log(
2442         uint256 p0,
2443         string memory p1,
2444         uint256 p2,
2445         address p3
2446     ) internal view {
2447         _sendLogPayload(
2448             abi.encodeWithSignature(
2449                 "log(uint,string,uint,address)",
2450                 p0,
2451                 p1,
2452                 p2,
2453                 p3
2454             )
2455         );
2456     }
2457 
2458     function log(
2459         uint256 p0,
2460         string memory p1,
2461         string memory p2,
2462         uint256 p3
2463     ) internal view {
2464         _sendLogPayload(
2465             abi.encodeWithSignature(
2466                 "log(uint,string,string,uint)",
2467                 p0,
2468                 p1,
2469                 p2,
2470                 p3
2471             )
2472         );
2473     }
2474 
2475     function log(
2476         uint256 p0,
2477         string memory p1,
2478         string memory p2,
2479         string memory p3
2480     ) internal view {
2481         _sendLogPayload(
2482             abi.encodeWithSignature(
2483                 "log(uint,string,string,string)",
2484                 p0,
2485                 p1,
2486                 p2,
2487                 p3
2488             )
2489         );
2490     }
2491 
2492     function log(
2493         uint256 p0,
2494         string memory p1,
2495         string memory p2,
2496         bool p3
2497     ) internal view {
2498         _sendLogPayload(
2499             abi.encodeWithSignature(
2500                 "log(uint,string,string,bool)",
2501                 p0,
2502                 p1,
2503                 p2,
2504                 p3
2505             )
2506         );
2507     }
2508 
2509     function log(
2510         uint256 p0,
2511         string memory p1,
2512         string memory p2,
2513         address p3
2514     ) internal view {
2515         _sendLogPayload(
2516             abi.encodeWithSignature(
2517                 "log(uint,string,string,address)",
2518                 p0,
2519                 p1,
2520                 p2,
2521                 p3
2522             )
2523         );
2524     }
2525 
2526     function log(
2527         uint256 p0,
2528         string memory p1,
2529         bool p2,
2530         uint256 p3
2531     ) internal view {
2532         _sendLogPayload(
2533             abi.encodeWithSignature(
2534                 "log(uint,string,bool,uint)",
2535                 p0,
2536                 p1,
2537                 p2,
2538                 p3
2539             )
2540         );
2541     }
2542 
2543     function log(
2544         uint256 p0,
2545         string memory p1,
2546         bool p2,
2547         string memory p3
2548     ) internal view {
2549         _sendLogPayload(
2550             abi.encodeWithSignature(
2551                 "log(uint,string,bool,string)",
2552                 p0,
2553                 p1,
2554                 p2,
2555                 p3
2556             )
2557         );
2558     }
2559 
2560     function log(
2561         uint256 p0,
2562         string memory p1,
2563         bool p2,
2564         bool p3
2565     ) internal view {
2566         _sendLogPayload(
2567             abi.encodeWithSignature(
2568                 "log(uint,string,bool,bool)",
2569                 p0,
2570                 p1,
2571                 p2,
2572                 p3
2573             )
2574         );
2575     }
2576 
2577     function log(
2578         uint256 p0,
2579         string memory p1,
2580         bool p2,
2581         address p3
2582     ) internal view {
2583         _sendLogPayload(
2584             abi.encodeWithSignature(
2585                 "log(uint,string,bool,address)",
2586                 p0,
2587                 p1,
2588                 p2,
2589                 p3
2590             )
2591         );
2592     }
2593 
2594     function log(
2595         uint256 p0,
2596         string memory p1,
2597         address p2,
2598         uint256 p3
2599     ) internal view {
2600         _sendLogPayload(
2601             abi.encodeWithSignature(
2602                 "log(uint,string,address,uint)",
2603                 p0,
2604                 p1,
2605                 p2,
2606                 p3
2607             )
2608         );
2609     }
2610 
2611     function log(
2612         uint256 p0,
2613         string memory p1,
2614         address p2,
2615         string memory p3
2616     ) internal view {
2617         _sendLogPayload(
2618             abi.encodeWithSignature(
2619                 "log(uint,string,address,string)",
2620                 p0,
2621                 p1,
2622                 p2,
2623                 p3
2624             )
2625         );
2626     }
2627 
2628     function log(
2629         uint256 p0,
2630         string memory p1,
2631         address p2,
2632         bool p3
2633     ) internal view {
2634         _sendLogPayload(
2635             abi.encodeWithSignature(
2636                 "log(uint,string,address,bool)",
2637                 p0,
2638                 p1,
2639                 p2,
2640                 p3
2641             )
2642         );
2643     }
2644 
2645     function log(
2646         uint256 p0,
2647         string memory p1,
2648         address p2,
2649         address p3
2650     ) internal view {
2651         _sendLogPayload(
2652             abi.encodeWithSignature(
2653                 "log(uint,string,address,address)",
2654                 p0,
2655                 p1,
2656                 p2,
2657                 p3
2658             )
2659         );
2660     }
2661 
2662     function log(
2663         uint256 p0,
2664         bool p1,
2665         uint256 p2,
2666         uint256 p3
2667     ) internal view {
2668         _sendLogPayload(
2669             abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3)
2670         );
2671     }
2672 
2673     function log(
2674         uint256 p0,
2675         bool p1,
2676         uint256 p2,
2677         string memory p3
2678     ) internal view {
2679         _sendLogPayload(
2680             abi.encodeWithSignature(
2681                 "log(uint,bool,uint,string)",
2682                 p0,
2683                 p1,
2684                 p2,
2685                 p3
2686             )
2687         );
2688     }
2689 
2690     function log(
2691         uint256 p0,
2692         bool p1,
2693         uint256 p2,
2694         bool p3
2695     ) internal view {
2696         _sendLogPayload(
2697             abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3)
2698         );
2699     }
2700 
2701     function log(
2702         uint256 p0,
2703         bool p1,
2704         uint256 p2,
2705         address p3
2706     ) internal view {
2707         _sendLogPayload(
2708             abi.encodeWithSignature(
2709                 "log(uint,bool,uint,address)",
2710                 p0,
2711                 p1,
2712                 p2,
2713                 p3
2714             )
2715         );
2716     }
2717 
2718     function log(
2719         uint256 p0,
2720         bool p1,
2721         string memory p2,
2722         uint256 p3
2723     ) internal view {
2724         _sendLogPayload(
2725             abi.encodeWithSignature(
2726                 "log(uint,bool,string,uint)",
2727                 p0,
2728                 p1,
2729                 p2,
2730                 p3
2731             )
2732         );
2733     }
2734 
2735     function log(
2736         uint256 p0,
2737         bool p1,
2738         string memory p2,
2739         string memory p3
2740     ) internal view {
2741         _sendLogPayload(
2742             abi.encodeWithSignature(
2743                 "log(uint,bool,string,string)",
2744                 p0,
2745                 p1,
2746                 p2,
2747                 p3
2748             )
2749         );
2750     }
2751 
2752     function log(
2753         uint256 p0,
2754         bool p1,
2755         string memory p2,
2756         bool p3
2757     ) internal view {
2758         _sendLogPayload(
2759             abi.encodeWithSignature(
2760                 "log(uint,bool,string,bool)",
2761                 p0,
2762                 p1,
2763                 p2,
2764                 p3
2765             )
2766         );
2767     }
2768 
2769     function log(
2770         uint256 p0,
2771         bool p1,
2772         string memory p2,
2773         address p3
2774     ) internal view {
2775         _sendLogPayload(
2776             abi.encodeWithSignature(
2777                 "log(uint,bool,string,address)",
2778                 p0,
2779                 p1,
2780                 p2,
2781                 p3
2782             )
2783         );
2784     }
2785 
2786     function log(
2787         uint256 p0,
2788         bool p1,
2789         bool p2,
2790         uint256 p3
2791     ) internal view {
2792         _sendLogPayload(
2793             abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3)
2794         );
2795     }
2796 
2797     function log(
2798         uint256 p0,
2799         bool p1,
2800         bool p2,
2801         string memory p3
2802     ) internal view {
2803         _sendLogPayload(
2804             abi.encodeWithSignature(
2805                 "log(uint,bool,bool,string)",
2806                 p0,
2807                 p1,
2808                 p2,
2809                 p3
2810             )
2811         );
2812     }
2813 
2814     function log(
2815         uint256 p0,
2816         bool p1,
2817         bool p2,
2818         bool p3
2819     ) internal view {
2820         _sendLogPayload(
2821             abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3)
2822         );
2823     }
2824 
2825     function log(
2826         uint256 p0,
2827         bool p1,
2828         bool p2,
2829         address p3
2830     ) internal view {
2831         _sendLogPayload(
2832             abi.encodeWithSignature(
2833                 "log(uint,bool,bool,address)",
2834                 p0,
2835                 p1,
2836                 p2,
2837                 p3
2838             )
2839         );
2840     }
2841 
2842     function log(
2843         uint256 p0,
2844         bool p1,
2845         address p2,
2846         uint256 p3
2847     ) internal view {
2848         _sendLogPayload(
2849             abi.encodeWithSignature(
2850                 "log(uint,bool,address,uint)",
2851                 p0,
2852                 p1,
2853                 p2,
2854                 p3
2855             )
2856         );
2857     }
2858 
2859     function log(
2860         uint256 p0,
2861         bool p1,
2862         address p2,
2863         string memory p3
2864     ) internal view {
2865         _sendLogPayload(
2866             abi.encodeWithSignature(
2867                 "log(uint,bool,address,string)",
2868                 p0,
2869                 p1,
2870                 p2,
2871                 p3
2872             )
2873         );
2874     }
2875 
2876     function log(
2877         uint256 p0,
2878         bool p1,
2879         address p2,
2880         bool p3
2881     ) internal view {
2882         _sendLogPayload(
2883             abi.encodeWithSignature(
2884                 "log(uint,bool,address,bool)",
2885                 p0,
2886                 p1,
2887                 p2,
2888                 p3
2889             )
2890         );
2891     }
2892 
2893     function log(
2894         uint256 p0,
2895         bool p1,
2896         address p2,
2897         address p3
2898     ) internal view {
2899         _sendLogPayload(
2900             abi.encodeWithSignature(
2901                 "log(uint,bool,address,address)",
2902                 p0,
2903                 p1,
2904                 p2,
2905                 p3
2906             )
2907         );
2908     }
2909 
2910     function log(
2911         uint256 p0,
2912         address p1,
2913         uint256 p2,
2914         uint256 p3
2915     ) internal view {
2916         _sendLogPayload(
2917             abi.encodeWithSignature(
2918                 "log(uint,address,uint,uint)",
2919                 p0,
2920                 p1,
2921                 p2,
2922                 p3
2923             )
2924         );
2925     }
2926 
2927     function log(
2928         uint256 p0,
2929         address p1,
2930         uint256 p2,
2931         string memory p3
2932     ) internal view {
2933         _sendLogPayload(
2934             abi.encodeWithSignature(
2935                 "log(uint,address,uint,string)",
2936                 p0,
2937                 p1,
2938                 p2,
2939                 p3
2940             )
2941         );
2942     }
2943 
2944     function log(
2945         uint256 p0,
2946         address p1,
2947         uint256 p2,
2948         bool p3
2949     ) internal view {
2950         _sendLogPayload(
2951             abi.encodeWithSignature(
2952                 "log(uint,address,uint,bool)",
2953                 p0,
2954                 p1,
2955                 p2,
2956                 p3
2957             )
2958         );
2959     }
2960 
2961     function log(
2962         uint256 p0,
2963         address p1,
2964         uint256 p2,
2965         address p3
2966     ) internal view {
2967         _sendLogPayload(
2968             abi.encodeWithSignature(
2969                 "log(uint,address,uint,address)",
2970                 p0,
2971                 p1,
2972                 p2,
2973                 p3
2974             )
2975         );
2976     }
2977 
2978     function log(
2979         uint256 p0,
2980         address p1,
2981         string memory p2,
2982         uint256 p3
2983     ) internal view {
2984         _sendLogPayload(
2985             abi.encodeWithSignature(
2986                 "log(uint,address,string,uint)",
2987                 p0,
2988                 p1,
2989                 p2,
2990                 p3
2991             )
2992         );
2993     }
2994 
2995     function log(
2996         uint256 p0,
2997         address p1,
2998         string memory p2,
2999         string memory p3
3000     ) internal view {
3001         _sendLogPayload(
3002             abi.encodeWithSignature(
3003                 "log(uint,address,string,string)",
3004                 p0,
3005                 p1,
3006                 p2,
3007                 p3
3008             )
3009         );
3010     }
3011 
3012     function log(
3013         uint256 p0,
3014         address p1,
3015         string memory p2,
3016         bool p3
3017     ) internal view {
3018         _sendLogPayload(
3019             abi.encodeWithSignature(
3020                 "log(uint,address,string,bool)",
3021                 p0,
3022                 p1,
3023                 p2,
3024                 p3
3025             )
3026         );
3027     }
3028 
3029     function log(
3030         uint256 p0,
3031         address p1,
3032         string memory p2,
3033         address p3
3034     ) internal view {
3035         _sendLogPayload(
3036             abi.encodeWithSignature(
3037                 "log(uint,address,string,address)",
3038                 p0,
3039                 p1,
3040                 p2,
3041                 p3
3042             )
3043         );
3044     }
3045 
3046     function log(
3047         uint256 p0,
3048         address p1,
3049         bool p2,
3050         uint256 p3
3051     ) internal view {
3052         _sendLogPayload(
3053             abi.encodeWithSignature(
3054                 "log(uint,address,bool,uint)",
3055                 p0,
3056                 p1,
3057                 p2,
3058                 p3
3059             )
3060         );
3061     }
3062 
3063     function log(
3064         uint256 p0,
3065         address p1,
3066         bool p2,
3067         string memory p3
3068     ) internal view {
3069         _sendLogPayload(
3070             abi.encodeWithSignature(
3071                 "log(uint,address,bool,string)",
3072                 p0,
3073                 p1,
3074                 p2,
3075                 p3
3076             )
3077         );
3078     }
3079 
3080     function log(
3081         uint256 p0,
3082         address p1,
3083         bool p2,
3084         bool p3
3085     ) internal view {
3086         _sendLogPayload(
3087             abi.encodeWithSignature(
3088                 "log(uint,address,bool,bool)",
3089                 p0,
3090                 p1,
3091                 p2,
3092                 p3
3093             )
3094         );
3095     }
3096 
3097     function log(
3098         uint256 p0,
3099         address p1,
3100         bool p2,
3101         address p3
3102     ) internal view {
3103         _sendLogPayload(
3104             abi.encodeWithSignature(
3105                 "log(uint,address,bool,address)",
3106                 p0,
3107                 p1,
3108                 p2,
3109                 p3
3110             )
3111         );
3112     }
3113 
3114     function log(
3115         uint256 p0,
3116         address p1,
3117         address p2,
3118         uint256 p3
3119     ) internal view {
3120         _sendLogPayload(
3121             abi.encodeWithSignature(
3122                 "log(uint,address,address,uint)",
3123                 p0,
3124                 p1,
3125                 p2,
3126                 p3
3127             )
3128         );
3129     }
3130 
3131     function log(
3132         uint256 p0,
3133         address p1,
3134         address p2,
3135         string memory p3
3136     ) internal view {
3137         _sendLogPayload(
3138             abi.encodeWithSignature(
3139                 "log(uint,address,address,string)",
3140                 p0,
3141                 p1,
3142                 p2,
3143                 p3
3144             )
3145         );
3146     }
3147 
3148     function log(
3149         uint256 p0,
3150         address p1,
3151         address p2,
3152         bool p3
3153     ) internal view {
3154         _sendLogPayload(
3155             abi.encodeWithSignature(
3156                 "log(uint,address,address,bool)",
3157                 p0,
3158                 p1,
3159                 p2,
3160                 p3
3161             )
3162         );
3163     }
3164 
3165     function log(
3166         uint256 p0,
3167         address p1,
3168         address p2,
3169         address p3
3170     ) internal view {
3171         _sendLogPayload(
3172             abi.encodeWithSignature(
3173                 "log(uint,address,address,address)",
3174                 p0,
3175                 p1,
3176                 p2,
3177                 p3
3178             )
3179         );
3180     }
3181 
3182     function log(
3183         string memory p0,
3184         uint256 p1,
3185         uint256 p2,
3186         uint256 p3
3187     ) internal view {
3188         _sendLogPayload(
3189             abi.encodeWithSignature(
3190                 "log(string,uint,uint,uint)",
3191                 p0,
3192                 p1,
3193                 p2,
3194                 p3
3195             )
3196         );
3197     }
3198 
3199     function log(
3200         string memory p0,
3201         uint256 p1,
3202         uint256 p2,
3203         string memory p3
3204     ) internal view {
3205         _sendLogPayload(
3206             abi.encodeWithSignature(
3207                 "log(string,uint,uint,string)",
3208                 p0,
3209                 p1,
3210                 p2,
3211                 p3
3212             )
3213         );
3214     }
3215 
3216     function log(
3217         string memory p0,
3218         uint256 p1,
3219         uint256 p2,
3220         bool p3
3221     ) internal view {
3222         _sendLogPayload(
3223             abi.encodeWithSignature(
3224                 "log(string,uint,uint,bool)",
3225                 p0,
3226                 p1,
3227                 p2,
3228                 p3
3229             )
3230         );
3231     }
3232 
3233     function log(
3234         string memory p0,
3235         uint256 p1,
3236         uint256 p2,
3237         address p3
3238     ) internal view {
3239         _sendLogPayload(
3240             abi.encodeWithSignature(
3241                 "log(string,uint,uint,address)",
3242                 p0,
3243                 p1,
3244                 p2,
3245                 p3
3246             )
3247         );
3248     }
3249 
3250     function log(
3251         string memory p0,
3252         uint256 p1,
3253         string memory p2,
3254         uint256 p3
3255     ) internal view {
3256         _sendLogPayload(
3257             abi.encodeWithSignature(
3258                 "log(string,uint,string,uint)",
3259                 p0,
3260                 p1,
3261                 p2,
3262                 p3
3263             )
3264         );
3265     }
3266 
3267     function log(
3268         string memory p0,
3269         uint256 p1,
3270         string memory p2,
3271         string memory p3
3272     ) internal view {
3273         _sendLogPayload(
3274             abi.encodeWithSignature(
3275                 "log(string,uint,string,string)",
3276                 p0,
3277                 p1,
3278                 p2,
3279                 p3
3280             )
3281         );
3282     }
3283 
3284     function log(
3285         string memory p0,
3286         uint256 p1,
3287         string memory p2,
3288         bool p3
3289     ) internal view {
3290         _sendLogPayload(
3291             abi.encodeWithSignature(
3292                 "log(string,uint,string,bool)",
3293                 p0,
3294                 p1,
3295                 p2,
3296                 p3
3297             )
3298         );
3299     }
3300 
3301     function log(
3302         string memory p0,
3303         uint256 p1,
3304         string memory p2,
3305         address p3
3306     ) internal view {
3307         _sendLogPayload(
3308             abi.encodeWithSignature(
3309                 "log(string,uint,string,address)",
3310                 p0,
3311                 p1,
3312                 p2,
3313                 p3
3314             )
3315         );
3316     }
3317 
3318     function log(
3319         string memory p0,
3320         uint256 p1,
3321         bool p2,
3322         uint256 p3
3323     ) internal view {
3324         _sendLogPayload(
3325             abi.encodeWithSignature(
3326                 "log(string,uint,bool,uint)",
3327                 p0,
3328                 p1,
3329                 p2,
3330                 p3
3331             )
3332         );
3333     }
3334 
3335     function log(
3336         string memory p0,
3337         uint256 p1,
3338         bool p2,
3339         string memory p3
3340     ) internal view {
3341         _sendLogPayload(
3342             abi.encodeWithSignature(
3343                 "log(string,uint,bool,string)",
3344                 p0,
3345                 p1,
3346                 p2,
3347                 p3
3348             )
3349         );
3350     }
3351 
3352     function log(
3353         string memory p0,
3354         uint256 p1,
3355         bool p2,
3356         bool p3
3357     ) internal view {
3358         _sendLogPayload(
3359             abi.encodeWithSignature(
3360                 "log(string,uint,bool,bool)",
3361                 p0,
3362                 p1,
3363                 p2,
3364                 p3
3365             )
3366         );
3367     }
3368 
3369     function log(
3370         string memory p0,
3371         uint256 p1,
3372         bool p2,
3373         address p3
3374     ) internal view {
3375         _sendLogPayload(
3376             abi.encodeWithSignature(
3377                 "log(string,uint,bool,address)",
3378                 p0,
3379                 p1,
3380                 p2,
3381                 p3
3382             )
3383         );
3384     }
3385 
3386     function log(
3387         string memory p0,
3388         uint256 p1,
3389         address p2,
3390         uint256 p3
3391     ) internal view {
3392         _sendLogPayload(
3393             abi.encodeWithSignature(
3394                 "log(string,uint,address,uint)",
3395                 p0,
3396                 p1,
3397                 p2,
3398                 p3
3399             )
3400         );
3401     }
3402 
3403     function log(
3404         string memory p0,
3405         uint256 p1,
3406         address p2,
3407         string memory p3
3408     ) internal view {
3409         _sendLogPayload(
3410             abi.encodeWithSignature(
3411                 "log(string,uint,address,string)",
3412                 p0,
3413                 p1,
3414                 p2,
3415                 p3
3416             )
3417         );
3418     }
3419 
3420     function log(
3421         string memory p0,
3422         uint256 p1,
3423         address p2,
3424         bool p3
3425     ) internal view {
3426         _sendLogPayload(
3427             abi.encodeWithSignature(
3428                 "log(string,uint,address,bool)",
3429                 p0,
3430                 p1,
3431                 p2,
3432                 p3
3433             )
3434         );
3435     }
3436 
3437     function log(
3438         string memory p0,
3439         uint256 p1,
3440         address p2,
3441         address p3
3442     ) internal view {
3443         _sendLogPayload(
3444             abi.encodeWithSignature(
3445                 "log(string,uint,address,address)",
3446                 p0,
3447                 p1,
3448                 p2,
3449                 p3
3450             )
3451         );
3452     }
3453 
3454     function log(
3455         string memory p0,
3456         string memory p1,
3457         uint256 p2,
3458         uint256 p3
3459     ) internal view {
3460         _sendLogPayload(
3461             abi.encodeWithSignature(
3462                 "log(string,string,uint,uint)",
3463                 p0,
3464                 p1,
3465                 p2,
3466                 p3
3467             )
3468         );
3469     }
3470 
3471     function log(
3472         string memory p0,
3473         string memory p1,
3474         uint256 p2,
3475         string memory p3
3476     ) internal view {
3477         _sendLogPayload(
3478             abi.encodeWithSignature(
3479                 "log(string,string,uint,string)",
3480                 p0,
3481                 p1,
3482                 p2,
3483                 p3
3484             )
3485         );
3486     }
3487 
3488     function log(
3489         string memory p0,
3490         string memory p1,
3491         uint256 p2,
3492         bool p3
3493     ) internal view {
3494         _sendLogPayload(
3495             abi.encodeWithSignature(
3496                 "log(string,string,uint,bool)",
3497                 p0,
3498                 p1,
3499                 p2,
3500                 p3
3501             )
3502         );
3503     }
3504 
3505     function log(
3506         string memory p0,
3507         string memory p1,
3508         uint256 p2,
3509         address p3
3510     ) internal view {
3511         _sendLogPayload(
3512             abi.encodeWithSignature(
3513                 "log(string,string,uint,address)",
3514                 p0,
3515                 p1,
3516                 p2,
3517                 p3
3518             )
3519         );
3520     }
3521 
3522     function log(
3523         string memory p0,
3524         string memory p1,
3525         string memory p2,
3526         uint256 p3
3527     ) internal view {
3528         _sendLogPayload(
3529             abi.encodeWithSignature(
3530                 "log(string,string,string,uint)",
3531                 p0,
3532                 p1,
3533                 p2,
3534                 p3
3535             )
3536         );
3537     }
3538 
3539     function log(
3540         string memory p0,
3541         string memory p1,
3542         string memory p2,
3543         string memory p3
3544     ) internal view {
3545         _sendLogPayload(
3546             abi.encodeWithSignature(
3547                 "log(string,string,string,string)",
3548                 p0,
3549                 p1,
3550                 p2,
3551                 p3
3552             )
3553         );
3554     }
3555 
3556     function log(
3557         string memory p0,
3558         string memory p1,
3559         string memory p2,
3560         bool p3
3561     ) internal view {
3562         _sendLogPayload(
3563             abi.encodeWithSignature(
3564                 "log(string,string,string,bool)",
3565                 p0,
3566                 p1,
3567                 p2,
3568                 p3
3569             )
3570         );
3571     }
3572 
3573     function log(
3574         string memory p0,
3575         string memory p1,
3576         string memory p2,
3577         address p3
3578     ) internal view {
3579         _sendLogPayload(
3580             abi.encodeWithSignature(
3581                 "log(string,string,string,address)",
3582                 p0,
3583                 p1,
3584                 p2,
3585                 p3
3586             )
3587         );
3588     }
3589 
3590     function log(
3591         string memory p0,
3592         string memory p1,
3593         bool p2,
3594         uint256 p3
3595     ) internal view {
3596         _sendLogPayload(
3597             abi.encodeWithSignature(
3598                 "log(string,string,bool,uint)",
3599                 p0,
3600                 p1,
3601                 p2,
3602                 p3
3603             )
3604         );
3605     }
3606 
3607     function log(
3608         string memory p0,
3609         string memory p1,
3610         bool p2,
3611         string memory p3
3612     ) internal view {
3613         _sendLogPayload(
3614             abi.encodeWithSignature(
3615                 "log(string,string,bool,string)",
3616                 p0,
3617                 p1,
3618                 p2,
3619                 p3
3620             )
3621         );
3622     }
3623 
3624     function log(
3625         string memory p0,
3626         string memory p1,
3627         bool p2,
3628         bool p3
3629     ) internal view {
3630         _sendLogPayload(
3631             abi.encodeWithSignature(
3632                 "log(string,string,bool,bool)",
3633                 p0,
3634                 p1,
3635                 p2,
3636                 p3
3637             )
3638         );
3639     }
3640 
3641     function log(
3642         string memory p0,
3643         string memory p1,
3644         bool p2,
3645         address p3
3646     ) internal view {
3647         _sendLogPayload(
3648             abi.encodeWithSignature(
3649                 "log(string,string,bool,address)",
3650                 p0,
3651                 p1,
3652                 p2,
3653                 p3
3654             )
3655         );
3656     }
3657 
3658     function log(
3659         string memory p0,
3660         string memory p1,
3661         address p2,
3662         uint256 p3
3663     ) internal view {
3664         _sendLogPayload(
3665             abi.encodeWithSignature(
3666                 "log(string,string,address,uint)",
3667                 p0,
3668                 p1,
3669                 p2,
3670                 p3
3671             )
3672         );
3673     }
3674 
3675     function log(
3676         string memory p0,
3677         string memory p1,
3678         address p2,
3679         string memory p3
3680     ) internal view {
3681         _sendLogPayload(
3682             abi.encodeWithSignature(
3683                 "log(string,string,address,string)",
3684                 p0,
3685                 p1,
3686                 p2,
3687                 p3
3688             )
3689         );
3690     }
3691 
3692     function log(
3693         string memory p0,
3694         string memory p1,
3695         address p2,
3696         bool p3
3697     ) internal view {
3698         _sendLogPayload(
3699             abi.encodeWithSignature(
3700                 "log(string,string,address,bool)",
3701                 p0,
3702                 p1,
3703                 p2,
3704                 p3
3705             )
3706         );
3707     }
3708 
3709     function log(
3710         string memory p0,
3711         string memory p1,
3712         address p2,
3713         address p3
3714     ) internal view {
3715         _sendLogPayload(
3716             abi.encodeWithSignature(
3717                 "log(string,string,address,address)",
3718                 p0,
3719                 p1,
3720                 p2,
3721                 p3
3722             )
3723         );
3724     }
3725 
3726     function log(
3727         string memory p0,
3728         bool p1,
3729         uint256 p2,
3730         uint256 p3
3731     ) internal view {
3732         _sendLogPayload(
3733             abi.encodeWithSignature(
3734                 "log(string,bool,uint,uint)",
3735                 p0,
3736                 p1,
3737                 p2,
3738                 p3
3739             )
3740         );
3741     }
3742 
3743     function log(
3744         string memory p0,
3745         bool p1,
3746         uint256 p2,
3747         string memory p3
3748     ) internal view {
3749         _sendLogPayload(
3750             abi.encodeWithSignature(
3751                 "log(string,bool,uint,string)",
3752                 p0,
3753                 p1,
3754                 p2,
3755                 p3
3756             )
3757         );
3758     }
3759 
3760     function log(
3761         string memory p0,
3762         bool p1,
3763         uint256 p2,
3764         bool p3
3765     ) internal view {
3766         _sendLogPayload(
3767             abi.encodeWithSignature(
3768                 "log(string,bool,uint,bool)",
3769                 p0,
3770                 p1,
3771                 p2,
3772                 p3
3773             )
3774         );
3775     }
3776 
3777     function log(
3778         string memory p0,
3779         bool p1,
3780         uint256 p2,
3781         address p3
3782     ) internal view {
3783         _sendLogPayload(
3784             abi.encodeWithSignature(
3785                 "log(string,bool,uint,address)",
3786                 p0,
3787                 p1,
3788                 p2,
3789                 p3
3790             )
3791         );
3792     }
3793 
3794     function log(
3795         string memory p0,
3796         bool p1,
3797         string memory p2,
3798         uint256 p3
3799     ) internal view {
3800         _sendLogPayload(
3801             abi.encodeWithSignature(
3802                 "log(string,bool,string,uint)",
3803                 p0,
3804                 p1,
3805                 p2,
3806                 p3
3807             )
3808         );
3809     }
3810 
3811     function log(
3812         string memory p0,
3813         bool p1,
3814         string memory p2,
3815         string memory p3
3816     ) internal view {
3817         _sendLogPayload(
3818             abi.encodeWithSignature(
3819                 "log(string,bool,string,string)",
3820                 p0,
3821                 p1,
3822                 p2,
3823                 p3
3824             )
3825         );
3826     }
3827 
3828     function log(
3829         string memory p0,
3830         bool p1,
3831         string memory p2,
3832         bool p3
3833     ) internal view {
3834         _sendLogPayload(
3835             abi.encodeWithSignature(
3836                 "log(string,bool,string,bool)",
3837                 p0,
3838                 p1,
3839                 p2,
3840                 p3
3841             )
3842         );
3843     }
3844 
3845     function log(
3846         string memory p0,
3847         bool p1,
3848         string memory p2,
3849         address p3
3850     ) internal view {
3851         _sendLogPayload(
3852             abi.encodeWithSignature(
3853                 "log(string,bool,string,address)",
3854                 p0,
3855                 p1,
3856                 p2,
3857                 p3
3858             )
3859         );
3860     }
3861 
3862     function log(
3863         string memory p0,
3864         bool p1,
3865         bool p2,
3866         uint256 p3
3867     ) internal view {
3868         _sendLogPayload(
3869             abi.encodeWithSignature(
3870                 "log(string,bool,bool,uint)",
3871                 p0,
3872                 p1,
3873                 p2,
3874                 p3
3875             )
3876         );
3877     }
3878 
3879     function log(
3880         string memory p0,
3881         bool p1,
3882         bool p2,
3883         string memory p3
3884     ) internal view {
3885         _sendLogPayload(
3886             abi.encodeWithSignature(
3887                 "log(string,bool,bool,string)",
3888                 p0,
3889                 p1,
3890                 p2,
3891                 p3
3892             )
3893         );
3894     }
3895 
3896     function log(
3897         string memory p0,
3898         bool p1,
3899         bool p2,
3900         bool p3
3901     ) internal view {
3902         _sendLogPayload(
3903             abi.encodeWithSignature(
3904                 "log(string,bool,bool,bool)",
3905                 p0,
3906                 p1,
3907                 p2,
3908                 p3
3909             )
3910         );
3911     }
3912 
3913     function log(
3914         string memory p0,
3915         bool p1,
3916         bool p2,
3917         address p3
3918     ) internal view {
3919         _sendLogPayload(
3920             abi.encodeWithSignature(
3921                 "log(string,bool,bool,address)",
3922                 p0,
3923                 p1,
3924                 p2,
3925                 p3
3926             )
3927         );
3928     }
3929 
3930     function log(
3931         string memory p0,
3932         bool p1,
3933         address p2,
3934         uint256 p3
3935     ) internal view {
3936         _sendLogPayload(
3937             abi.encodeWithSignature(
3938                 "log(string,bool,address,uint)",
3939                 p0,
3940                 p1,
3941                 p2,
3942                 p3
3943             )
3944         );
3945     }
3946 
3947     function log(
3948         string memory p0,
3949         bool p1,
3950         address p2,
3951         string memory p3
3952     ) internal view {
3953         _sendLogPayload(
3954             abi.encodeWithSignature(
3955                 "log(string,bool,address,string)",
3956                 p0,
3957                 p1,
3958                 p2,
3959                 p3
3960             )
3961         );
3962     }
3963 
3964     function log(
3965         string memory p0,
3966         bool p1,
3967         address p2,
3968         bool p3
3969     ) internal view {
3970         _sendLogPayload(
3971             abi.encodeWithSignature(
3972                 "log(string,bool,address,bool)",
3973                 p0,
3974                 p1,
3975                 p2,
3976                 p3
3977             )
3978         );
3979     }
3980 
3981     function log(
3982         string memory p0,
3983         bool p1,
3984         address p2,
3985         address p3
3986     ) internal view {
3987         _sendLogPayload(
3988             abi.encodeWithSignature(
3989                 "log(string,bool,address,address)",
3990                 p0,
3991                 p1,
3992                 p2,
3993                 p3
3994             )
3995         );
3996     }
3997 
3998     function log(
3999         string memory p0,
4000         address p1,
4001         uint256 p2,
4002         uint256 p3
4003     ) internal view {
4004         _sendLogPayload(
4005             abi.encodeWithSignature(
4006                 "log(string,address,uint,uint)",
4007                 p0,
4008                 p1,
4009                 p2,
4010                 p3
4011             )
4012         );
4013     }
4014 
4015     function log(
4016         string memory p0,
4017         address p1,
4018         uint256 p2,
4019         string memory p3
4020     ) internal view {
4021         _sendLogPayload(
4022             abi.encodeWithSignature(
4023                 "log(string,address,uint,string)",
4024                 p0,
4025                 p1,
4026                 p2,
4027                 p3
4028             )
4029         );
4030     }
4031 
4032     function log(
4033         string memory p0,
4034         address p1,
4035         uint256 p2,
4036         bool p3
4037     ) internal view {
4038         _sendLogPayload(
4039             abi.encodeWithSignature(
4040                 "log(string,address,uint,bool)",
4041                 p0,
4042                 p1,
4043                 p2,
4044                 p3
4045             )
4046         );
4047     }
4048 
4049     function log(
4050         string memory p0,
4051         address p1,
4052         uint256 p2,
4053         address p3
4054     ) internal view {
4055         _sendLogPayload(
4056             abi.encodeWithSignature(
4057                 "log(string,address,uint,address)",
4058                 p0,
4059                 p1,
4060                 p2,
4061                 p3
4062             )
4063         );
4064     }
4065 
4066     function log(
4067         string memory p0,
4068         address p1,
4069         string memory p2,
4070         uint256 p3
4071     ) internal view {
4072         _sendLogPayload(
4073             abi.encodeWithSignature(
4074                 "log(string,address,string,uint)",
4075                 p0,
4076                 p1,
4077                 p2,
4078                 p3
4079             )
4080         );
4081     }
4082 
4083     function log(
4084         string memory p0,
4085         address p1,
4086         string memory p2,
4087         string memory p3
4088     ) internal view {
4089         _sendLogPayload(
4090             abi.encodeWithSignature(
4091                 "log(string,address,string,string)",
4092                 p0,
4093                 p1,
4094                 p2,
4095                 p3
4096             )
4097         );
4098     }
4099 
4100     function log(
4101         string memory p0,
4102         address p1,
4103         string memory p2,
4104         bool p3
4105     ) internal view {
4106         _sendLogPayload(
4107             abi.encodeWithSignature(
4108                 "log(string,address,string,bool)",
4109                 p0,
4110                 p1,
4111                 p2,
4112                 p3
4113             )
4114         );
4115     }
4116 
4117     function log(
4118         string memory p0,
4119         address p1,
4120         string memory p2,
4121         address p3
4122     ) internal view {
4123         _sendLogPayload(
4124             abi.encodeWithSignature(
4125                 "log(string,address,string,address)",
4126                 p0,
4127                 p1,
4128                 p2,
4129                 p3
4130             )
4131         );
4132     }
4133 
4134     function log(
4135         string memory p0,
4136         address p1,
4137         bool p2,
4138         uint256 p3
4139     ) internal view {
4140         _sendLogPayload(
4141             abi.encodeWithSignature(
4142                 "log(string,address,bool,uint)",
4143                 p0,
4144                 p1,
4145                 p2,
4146                 p3
4147             )
4148         );
4149     }
4150 
4151     function log(
4152         string memory p0,
4153         address p1,
4154         bool p2,
4155         string memory p3
4156     ) internal view {
4157         _sendLogPayload(
4158             abi.encodeWithSignature(
4159                 "log(string,address,bool,string)",
4160                 p0,
4161                 p1,
4162                 p2,
4163                 p3
4164             )
4165         );
4166     }
4167 
4168     function log(
4169         string memory p0,
4170         address p1,
4171         bool p2,
4172         bool p3
4173     ) internal view {
4174         _sendLogPayload(
4175             abi.encodeWithSignature(
4176                 "log(string,address,bool,bool)",
4177                 p0,
4178                 p1,
4179                 p2,
4180                 p3
4181             )
4182         );
4183     }
4184 
4185     function log(
4186         string memory p0,
4187         address p1,
4188         bool p2,
4189         address p3
4190     ) internal view {
4191         _sendLogPayload(
4192             abi.encodeWithSignature(
4193                 "log(string,address,bool,address)",
4194                 p0,
4195                 p1,
4196                 p2,
4197                 p3
4198             )
4199         );
4200     }
4201 
4202     function log(
4203         string memory p0,
4204         address p1,
4205         address p2,
4206         uint256 p3
4207     ) internal view {
4208         _sendLogPayload(
4209             abi.encodeWithSignature(
4210                 "log(string,address,address,uint)",
4211                 p0,
4212                 p1,
4213                 p2,
4214                 p3
4215             )
4216         );
4217     }
4218 
4219     function log(
4220         string memory p0,
4221         address p1,
4222         address p2,
4223         string memory p3
4224     ) internal view {
4225         _sendLogPayload(
4226             abi.encodeWithSignature(
4227                 "log(string,address,address,string)",
4228                 p0,
4229                 p1,
4230                 p2,
4231                 p3
4232             )
4233         );
4234     }
4235 
4236     function log(
4237         string memory p0,
4238         address p1,
4239         address p2,
4240         bool p3
4241     ) internal view {
4242         _sendLogPayload(
4243             abi.encodeWithSignature(
4244                 "log(string,address,address,bool)",
4245                 p0,
4246                 p1,
4247                 p2,
4248                 p3
4249             )
4250         );
4251     }
4252 
4253     function log(
4254         string memory p0,
4255         address p1,
4256         address p2,
4257         address p3
4258     ) internal view {
4259         _sendLogPayload(
4260             abi.encodeWithSignature(
4261                 "log(string,address,address,address)",
4262                 p0,
4263                 p1,
4264                 p2,
4265                 p3
4266             )
4267         );
4268     }
4269 
4270     function log(
4271         bool p0,
4272         uint256 p1,
4273         uint256 p2,
4274         uint256 p3
4275     ) internal view {
4276         _sendLogPayload(
4277             abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3)
4278         );
4279     }
4280 
4281     function log(
4282         bool p0,
4283         uint256 p1,
4284         uint256 p2,
4285         string memory p3
4286     ) internal view {
4287         _sendLogPayload(
4288             abi.encodeWithSignature(
4289                 "log(bool,uint,uint,string)",
4290                 p0,
4291                 p1,
4292                 p2,
4293                 p3
4294             )
4295         );
4296     }
4297 
4298     function log(
4299         bool p0,
4300         uint256 p1,
4301         uint256 p2,
4302         bool p3
4303     ) internal view {
4304         _sendLogPayload(
4305             abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3)
4306         );
4307     }
4308 
4309     function log(
4310         bool p0,
4311         uint256 p1,
4312         uint256 p2,
4313         address p3
4314     ) internal view {
4315         _sendLogPayload(
4316             abi.encodeWithSignature(
4317                 "log(bool,uint,uint,address)",
4318                 p0,
4319                 p1,
4320                 p2,
4321                 p3
4322             )
4323         );
4324     }
4325 
4326     function log(
4327         bool p0,
4328         uint256 p1,
4329         string memory p2,
4330         uint256 p3
4331     ) internal view {
4332         _sendLogPayload(
4333             abi.encodeWithSignature(
4334                 "log(bool,uint,string,uint)",
4335                 p0,
4336                 p1,
4337                 p2,
4338                 p3
4339             )
4340         );
4341     }
4342 
4343     function log(
4344         bool p0,
4345         uint256 p1,
4346         string memory p2,
4347         string memory p3
4348     ) internal view {
4349         _sendLogPayload(
4350             abi.encodeWithSignature(
4351                 "log(bool,uint,string,string)",
4352                 p0,
4353                 p1,
4354                 p2,
4355                 p3
4356             )
4357         );
4358     }
4359 
4360     function log(
4361         bool p0,
4362         uint256 p1,
4363         string memory p2,
4364         bool p3
4365     ) internal view {
4366         _sendLogPayload(
4367             abi.encodeWithSignature(
4368                 "log(bool,uint,string,bool)",
4369                 p0,
4370                 p1,
4371                 p2,
4372                 p3
4373             )
4374         );
4375     }
4376 
4377     function log(
4378         bool p0,
4379         uint256 p1,
4380         string memory p2,
4381         address p3
4382     ) internal view {
4383         _sendLogPayload(
4384             abi.encodeWithSignature(
4385                 "log(bool,uint,string,address)",
4386                 p0,
4387                 p1,
4388                 p2,
4389                 p3
4390             )
4391         );
4392     }
4393 
4394     function log(
4395         bool p0,
4396         uint256 p1,
4397         bool p2,
4398         uint256 p3
4399     ) internal view {
4400         _sendLogPayload(
4401             abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3)
4402         );
4403     }
4404 
4405     function log(
4406         bool p0,
4407         uint256 p1,
4408         bool p2,
4409         string memory p3
4410     ) internal view {
4411         _sendLogPayload(
4412             abi.encodeWithSignature(
4413                 "log(bool,uint,bool,string)",
4414                 p0,
4415                 p1,
4416                 p2,
4417                 p3
4418             )
4419         );
4420     }
4421 
4422     function log(
4423         bool p0,
4424         uint256 p1,
4425         bool p2,
4426         bool p3
4427     ) internal view {
4428         _sendLogPayload(
4429             abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3)
4430         );
4431     }
4432 
4433     function log(
4434         bool p0,
4435         uint256 p1,
4436         bool p2,
4437         address p3
4438     ) internal view {
4439         _sendLogPayload(
4440             abi.encodeWithSignature(
4441                 "log(bool,uint,bool,address)",
4442                 p0,
4443                 p1,
4444                 p2,
4445                 p3
4446             )
4447         );
4448     }
4449 
4450     function log(
4451         bool p0,
4452         uint256 p1,
4453         address p2,
4454         uint256 p3
4455     ) internal view {
4456         _sendLogPayload(
4457             abi.encodeWithSignature(
4458                 "log(bool,uint,address,uint)",
4459                 p0,
4460                 p1,
4461                 p2,
4462                 p3
4463             )
4464         );
4465     }
4466 
4467     function log(
4468         bool p0,
4469         uint256 p1,
4470         address p2,
4471         string memory p3
4472     ) internal view {
4473         _sendLogPayload(
4474             abi.encodeWithSignature(
4475                 "log(bool,uint,address,string)",
4476                 p0,
4477                 p1,
4478                 p2,
4479                 p3
4480             )
4481         );
4482     }
4483 
4484     function log(
4485         bool p0,
4486         uint256 p1,
4487         address p2,
4488         bool p3
4489     ) internal view {
4490         _sendLogPayload(
4491             abi.encodeWithSignature(
4492                 "log(bool,uint,address,bool)",
4493                 p0,
4494                 p1,
4495                 p2,
4496                 p3
4497             )
4498         );
4499     }
4500 
4501     function log(
4502         bool p0,
4503         uint256 p1,
4504         address p2,
4505         address p3
4506     ) internal view {
4507         _sendLogPayload(
4508             abi.encodeWithSignature(
4509                 "log(bool,uint,address,address)",
4510                 p0,
4511                 p1,
4512                 p2,
4513                 p3
4514             )
4515         );
4516     }
4517 
4518     function log(
4519         bool p0,
4520         string memory p1,
4521         uint256 p2,
4522         uint256 p3
4523     ) internal view {
4524         _sendLogPayload(
4525             abi.encodeWithSignature(
4526                 "log(bool,string,uint,uint)",
4527                 p0,
4528                 p1,
4529                 p2,
4530                 p3
4531             )
4532         );
4533     }
4534 
4535     function log(
4536         bool p0,
4537         string memory p1,
4538         uint256 p2,
4539         string memory p3
4540     ) internal view {
4541         _sendLogPayload(
4542             abi.encodeWithSignature(
4543                 "log(bool,string,uint,string)",
4544                 p0,
4545                 p1,
4546                 p2,
4547                 p3
4548             )
4549         );
4550     }
4551 
4552     function log(
4553         bool p0,
4554         string memory p1,
4555         uint256 p2,
4556         bool p3
4557     ) internal view {
4558         _sendLogPayload(
4559             abi.encodeWithSignature(
4560                 "log(bool,string,uint,bool)",
4561                 p0,
4562                 p1,
4563                 p2,
4564                 p3
4565             )
4566         );
4567     }
4568 
4569     function log(
4570         bool p0,
4571         string memory p1,
4572         uint256 p2,
4573         address p3
4574     ) internal view {
4575         _sendLogPayload(
4576             abi.encodeWithSignature(
4577                 "log(bool,string,uint,address)",
4578                 p0,
4579                 p1,
4580                 p2,
4581                 p3
4582             )
4583         );
4584     }
4585 
4586     function log(
4587         bool p0,
4588         string memory p1,
4589         string memory p2,
4590         uint256 p3
4591     ) internal view {
4592         _sendLogPayload(
4593             abi.encodeWithSignature(
4594                 "log(bool,string,string,uint)",
4595                 p0,
4596                 p1,
4597                 p2,
4598                 p3
4599             )
4600         );
4601     }
4602 
4603     function log(
4604         bool p0,
4605         string memory p1,
4606         string memory p2,
4607         string memory p3
4608     ) internal view {
4609         _sendLogPayload(
4610             abi.encodeWithSignature(
4611                 "log(bool,string,string,string)",
4612                 p0,
4613                 p1,
4614                 p2,
4615                 p3
4616             )
4617         );
4618     }
4619 
4620     function log(
4621         bool p0,
4622         string memory p1,
4623         string memory p2,
4624         bool p3
4625     ) internal view {
4626         _sendLogPayload(
4627             abi.encodeWithSignature(
4628                 "log(bool,string,string,bool)",
4629                 p0,
4630                 p1,
4631                 p2,
4632                 p3
4633             )
4634         );
4635     }
4636 
4637     function log(
4638         bool p0,
4639         string memory p1,
4640         string memory p2,
4641         address p3
4642     ) internal view {
4643         _sendLogPayload(
4644             abi.encodeWithSignature(
4645                 "log(bool,string,string,address)",
4646                 p0,
4647                 p1,
4648                 p2,
4649                 p3
4650             )
4651         );
4652     }
4653 
4654     function log(
4655         bool p0,
4656         string memory p1,
4657         bool p2,
4658         uint256 p3
4659     ) internal view {
4660         _sendLogPayload(
4661             abi.encodeWithSignature(
4662                 "log(bool,string,bool,uint)",
4663                 p0,
4664                 p1,
4665                 p2,
4666                 p3
4667             )
4668         );
4669     }
4670 
4671     function log(
4672         bool p0,
4673         string memory p1,
4674         bool p2,
4675         string memory p3
4676     ) internal view {
4677         _sendLogPayload(
4678             abi.encodeWithSignature(
4679                 "log(bool,string,bool,string)",
4680                 p0,
4681                 p1,
4682                 p2,
4683                 p3
4684             )
4685         );
4686     }
4687 
4688     function log(
4689         bool p0,
4690         string memory p1,
4691         bool p2,
4692         bool p3
4693     ) internal view {
4694         _sendLogPayload(
4695             abi.encodeWithSignature(
4696                 "log(bool,string,bool,bool)",
4697                 p0,
4698                 p1,
4699                 p2,
4700                 p3
4701             )
4702         );
4703     }
4704 
4705     function log(
4706         bool p0,
4707         string memory p1,
4708         bool p2,
4709         address p3
4710     ) internal view {
4711         _sendLogPayload(
4712             abi.encodeWithSignature(
4713                 "log(bool,string,bool,address)",
4714                 p0,
4715                 p1,
4716                 p2,
4717                 p3
4718             )
4719         );
4720     }
4721 
4722     function log(
4723         bool p0,
4724         string memory p1,
4725         address p2,
4726         uint256 p3
4727     ) internal view {
4728         _sendLogPayload(
4729             abi.encodeWithSignature(
4730                 "log(bool,string,address,uint)",
4731                 p0,
4732                 p1,
4733                 p2,
4734                 p3
4735             )
4736         );
4737     }
4738 
4739     function log(
4740         bool p0,
4741         string memory p1,
4742         address p2,
4743         string memory p3
4744     ) internal view {
4745         _sendLogPayload(
4746             abi.encodeWithSignature(
4747                 "log(bool,string,address,string)",
4748                 p0,
4749                 p1,
4750                 p2,
4751                 p3
4752             )
4753         );
4754     }
4755 
4756     function log(
4757         bool p0,
4758         string memory p1,
4759         address p2,
4760         bool p3
4761     ) internal view {
4762         _sendLogPayload(
4763             abi.encodeWithSignature(
4764                 "log(bool,string,address,bool)",
4765                 p0,
4766                 p1,
4767                 p2,
4768                 p3
4769             )
4770         );
4771     }
4772 
4773     function log(
4774         bool p0,
4775         string memory p1,
4776         address p2,
4777         address p3
4778     ) internal view {
4779         _sendLogPayload(
4780             abi.encodeWithSignature(
4781                 "log(bool,string,address,address)",
4782                 p0,
4783                 p1,
4784                 p2,
4785                 p3
4786             )
4787         );
4788     }
4789 
4790     function log(
4791         bool p0,
4792         bool p1,
4793         uint256 p2,
4794         uint256 p3
4795     ) internal view {
4796         _sendLogPayload(
4797             abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3)
4798         );
4799     }
4800 
4801     function log(
4802         bool p0,
4803         bool p1,
4804         uint256 p2,
4805         string memory p3
4806     ) internal view {
4807         _sendLogPayload(
4808             abi.encodeWithSignature(
4809                 "log(bool,bool,uint,string)",
4810                 p0,
4811                 p1,
4812                 p2,
4813                 p3
4814             )
4815         );
4816     }
4817 
4818     function log(
4819         bool p0,
4820         bool p1,
4821         uint256 p2,
4822         bool p3
4823     ) internal view {
4824         _sendLogPayload(
4825             abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3)
4826         );
4827     }
4828 
4829     function log(
4830         bool p0,
4831         bool p1,
4832         uint256 p2,
4833         address p3
4834     ) internal view {
4835         _sendLogPayload(
4836             abi.encodeWithSignature(
4837                 "log(bool,bool,uint,address)",
4838                 p0,
4839                 p1,
4840                 p2,
4841                 p3
4842             )
4843         );
4844     }
4845 
4846     function log(
4847         bool p0,
4848         bool p1,
4849         string memory p2,
4850         uint256 p3
4851     ) internal view {
4852         _sendLogPayload(
4853             abi.encodeWithSignature(
4854                 "log(bool,bool,string,uint)",
4855                 p0,
4856                 p1,
4857                 p2,
4858                 p3
4859             )
4860         );
4861     }
4862 
4863     function log(
4864         bool p0,
4865         bool p1,
4866         string memory p2,
4867         string memory p3
4868     ) internal view {
4869         _sendLogPayload(
4870             abi.encodeWithSignature(
4871                 "log(bool,bool,string,string)",
4872                 p0,
4873                 p1,
4874                 p2,
4875                 p3
4876             )
4877         );
4878     }
4879 
4880     function log(
4881         bool p0,
4882         bool p1,
4883         string memory p2,
4884         bool p3
4885     ) internal view {
4886         _sendLogPayload(
4887             abi.encodeWithSignature(
4888                 "log(bool,bool,string,bool)",
4889                 p0,
4890                 p1,
4891                 p2,
4892                 p3
4893             )
4894         );
4895     }
4896 
4897     function log(
4898         bool p0,
4899         bool p1,
4900         string memory p2,
4901         address p3
4902     ) internal view {
4903         _sendLogPayload(
4904             abi.encodeWithSignature(
4905                 "log(bool,bool,string,address)",
4906                 p0,
4907                 p1,
4908                 p2,
4909                 p3
4910             )
4911         );
4912     }
4913 
4914     function log(
4915         bool p0,
4916         bool p1,
4917         bool p2,
4918         uint256 p3
4919     ) internal view {
4920         _sendLogPayload(
4921             abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3)
4922         );
4923     }
4924 
4925     function log(
4926         bool p0,
4927         bool p1,
4928         bool p2,
4929         string memory p3
4930     ) internal view {
4931         _sendLogPayload(
4932             abi.encodeWithSignature(
4933                 "log(bool,bool,bool,string)",
4934                 p0,
4935                 p1,
4936                 p2,
4937                 p3
4938             )
4939         );
4940     }
4941 
4942     function log(
4943         bool p0,
4944         bool p1,
4945         bool p2,
4946         bool p3
4947     ) internal view {
4948         _sendLogPayload(
4949             abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3)
4950         );
4951     }
4952 
4953     function log(
4954         bool p0,
4955         bool p1,
4956         bool p2,
4957         address p3
4958     ) internal view {
4959         _sendLogPayload(
4960             abi.encodeWithSignature(
4961                 "log(bool,bool,bool,address)",
4962                 p0,
4963                 p1,
4964                 p2,
4965                 p3
4966             )
4967         );
4968     }
4969 
4970     function log(
4971         bool p0,
4972         bool p1,
4973         address p2,
4974         uint256 p3
4975     ) internal view {
4976         _sendLogPayload(
4977             abi.encodeWithSignature(
4978                 "log(bool,bool,address,uint)",
4979                 p0,
4980                 p1,
4981                 p2,
4982                 p3
4983             )
4984         );
4985     }
4986 
4987     function log(
4988         bool p0,
4989         bool p1,
4990         address p2,
4991         string memory p3
4992     ) internal view {
4993         _sendLogPayload(
4994             abi.encodeWithSignature(
4995                 "log(bool,bool,address,string)",
4996                 p0,
4997                 p1,
4998                 p2,
4999                 p3
5000             )
5001         );
5002     }
5003 
5004     function log(
5005         bool p0,
5006         bool p1,
5007         address p2,
5008         bool p3
5009     ) internal view {
5010         _sendLogPayload(
5011             abi.encodeWithSignature(
5012                 "log(bool,bool,address,bool)",
5013                 p0,
5014                 p1,
5015                 p2,
5016                 p3
5017             )
5018         );
5019     }
5020 
5021     function log(
5022         bool p0,
5023         bool p1,
5024         address p2,
5025         address p3
5026     ) internal view {
5027         _sendLogPayload(
5028             abi.encodeWithSignature(
5029                 "log(bool,bool,address,address)",
5030                 p0,
5031                 p1,
5032                 p2,
5033                 p3
5034             )
5035         );
5036     }
5037 
5038     function log(
5039         bool p0,
5040         address p1,
5041         uint256 p2,
5042         uint256 p3
5043     ) internal view {
5044         _sendLogPayload(
5045             abi.encodeWithSignature(
5046                 "log(bool,address,uint,uint)",
5047                 p0,
5048                 p1,
5049                 p2,
5050                 p3
5051             )
5052         );
5053     }
5054 
5055     function log(
5056         bool p0,
5057         address p1,
5058         uint256 p2,
5059         string memory p3
5060     ) internal view {
5061         _sendLogPayload(
5062             abi.encodeWithSignature(
5063                 "log(bool,address,uint,string)",
5064                 p0,
5065                 p1,
5066                 p2,
5067                 p3
5068             )
5069         );
5070     }
5071 
5072     function log(
5073         bool p0,
5074         address p1,
5075         uint256 p2,
5076         bool p3
5077     ) internal view {
5078         _sendLogPayload(
5079             abi.encodeWithSignature(
5080                 "log(bool,address,uint,bool)",
5081                 p0,
5082                 p1,
5083                 p2,
5084                 p3
5085             )
5086         );
5087     }
5088 
5089     function log(
5090         bool p0,
5091         address p1,
5092         uint256 p2,
5093         address p3
5094     ) internal view {
5095         _sendLogPayload(
5096             abi.encodeWithSignature(
5097                 "log(bool,address,uint,address)",
5098                 p0,
5099                 p1,
5100                 p2,
5101                 p3
5102             )
5103         );
5104     }
5105 
5106     function log(
5107         bool p0,
5108         address p1,
5109         string memory p2,
5110         uint256 p3
5111     ) internal view {
5112         _sendLogPayload(
5113             abi.encodeWithSignature(
5114                 "log(bool,address,string,uint)",
5115                 p0,
5116                 p1,
5117                 p2,
5118                 p3
5119             )
5120         );
5121     }
5122 
5123     function log(
5124         bool p0,
5125         address p1,
5126         string memory p2,
5127         string memory p3
5128     ) internal view {
5129         _sendLogPayload(
5130             abi.encodeWithSignature(
5131                 "log(bool,address,string,string)",
5132                 p0,
5133                 p1,
5134                 p2,
5135                 p3
5136             )
5137         );
5138     }
5139 
5140     function log(
5141         bool p0,
5142         address p1,
5143         string memory p2,
5144         bool p3
5145     ) internal view {
5146         _sendLogPayload(
5147             abi.encodeWithSignature(
5148                 "log(bool,address,string,bool)",
5149                 p0,
5150                 p1,
5151                 p2,
5152                 p3
5153             )
5154         );
5155     }
5156 
5157     function log(
5158         bool p0,
5159         address p1,
5160         string memory p2,
5161         address p3
5162     ) internal view {
5163         _sendLogPayload(
5164             abi.encodeWithSignature(
5165                 "log(bool,address,string,address)",
5166                 p0,
5167                 p1,
5168                 p2,
5169                 p3
5170             )
5171         );
5172     }
5173 
5174     function log(
5175         bool p0,
5176         address p1,
5177         bool p2,
5178         uint256 p3
5179     ) internal view {
5180         _sendLogPayload(
5181             abi.encodeWithSignature(
5182                 "log(bool,address,bool,uint)",
5183                 p0,
5184                 p1,
5185                 p2,
5186                 p3
5187             )
5188         );
5189     }
5190 
5191     function log(
5192         bool p0,
5193         address p1,
5194         bool p2,
5195         string memory p3
5196     ) internal view {
5197         _sendLogPayload(
5198             abi.encodeWithSignature(
5199                 "log(bool,address,bool,string)",
5200                 p0,
5201                 p1,
5202                 p2,
5203                 p3
5204             )
5205         );
5206     }
5207 
5208     function log(
5209         bool p0,
5210         address p1,
5211         bool p2,
5212         bool p3
5213     ) internal view {
5214         _sendLogPayload(
5215             abi.encodeWithSignature(
5216                 "log(bool,address,bool,bool)",
5217                 p0,
5218                 p1,
5219                 p2,
5220                 p3
5221             )
5222         );
5223     }
5224 
5225     function log(
5226         bool p0,
5227         address p1,
5228         bool p2,
5229         address p3
5230     ) internal view {
5231         _sendLogPayload(
5232             abi.encodeWithSignature(
5233                 "log(bool,address,bool,address)",
5234                 p0,
5235                 p1,
5236                 p2,
5237                 p3
5238             )
5239         );
5240     }
5241 
5242     function log(
5243         bool p0,
5244         address p1,
5245         address p2,
5246         uint256 p3
5247     ) internal view {
5248         _sendLogPayload(
5249             abi.encodeWithSignature(
5250                 "log(bool,address,address,uint)",
5251                 p0,
5252                 p1,
5253                 p2,
5254                 p3
5255             )
5256         );
5257     }
5258 
5259     function log(
5260         bool p0,
5261         address p1,
5262         address p2,
5263         string memory p3
5264     ) internal view {
5265         _sendLogPayload(
5266             abi.encodeWithSignature(
5267                 "log(bool,address,address,string)",
5268                 p0,
5269                 p1,
5270                 p2,
5271                 p3
5272             )
5273         );
5274     }
5275 
5276     function log(
5277         bool p0,
5278         address p1,
5279         address p2,
5280         bool p3
5281     ) internal view {
5282         _sendLogPayload(
5283             abi.encodeWithSignature(
5284                 "log(bool,address,address,bool)",
5285                 p0,
5286                 p1,
5287                 p2,
5288                 p3
5289             )
5290         );
5291     }
5292 
5293     function log(
5294         bool p0,
5295         address p1,
5296         address p2,
5297         address p3
5298     ) internal view {
5299         _sendLogPayload(
5300             abi.encodeWithSignature(
5301                 "log(bool,address,address,address)",
5302                 p0,
5303                 p1,
5304                 p2,
5305                 p3
5306             )
5307         );
5308     }
5309 
5310     function log(
5311         address p0,
5312         uint256 p1,
5313         uint256 p2,
5314         uint256 p3
5315     ) internal view {
5316         _sendLogPayload(
5317             abi.encodeWithSignature(
5318                 "log(address,uint,uint,uint)",
5319                 p0,
5320                 p1,
5321                 p2,
5322                 p3
5323             )
5324         );
5325     }
5326 
5327     function log(
5328         address p0,
5329         uint256 p1,
5330         uint256 p2,
5331         string memory p3
5332     ) internal view {
5333         _sendLogPayload(
5334             abi.encodeWithSignature(
5335                 "log(address,uint,uint,string)",
5336                 p0,
5337                 p1,
5338                 p2,
5339                 p3
5340             )
5341         );
5342     }
5343 
5344     function log(
5345         address p0,
5346         uint256 p1,
5347         uint256 p2,
5348         bool p3
5349     ) internal view {
5350         _sendLogPayload(
5351             abi.encodeWithSignature(
5352                 "log(address,uint,uint,bool)",
5353                 p0,
5354                 p1,
5355                 p2,
5356                 p3
5357             )
5358         );
5359     }
5360 
5361     function log(
5362         address p0,
5363         uint256 p1,
5364         uint256 p2,
5365         address p3
5366     ) internal view {
5367         _sendLogPayload(
5368             abi.encodeWithSignature(
5369                 "log(address,uint,uint,address)",
5370                 p0,
5371                 p1,
5372                 p2,
5373                 p3
5374             )
5375         );
5376     }
5377 
5378     function log(
5379         address p0,
5380         uint256 p1,
5381         string memory p2,
5382         uint256 p3
5383     ) internal view {
5384         _sendLogPayload(
5385             abi.encodeWithSignature(
5386                 "log(address,uint,string,uint)",
5387                 p0,
5388                 p1,
5389                 p2,
5390                 p3
5391             )
5392         );
5393     }
5394 
5395     function log(
5396         address p0,
5397         uint256 p1,
5398         string memory p2,
5399         string memory p3
5400     ) internal view {
5401         _sendLogPayload(
5402             abi.encodeWithSignature(
5403                 "log(address,uint,string,string)",
5404                 p0,
5405                 p1,
5406                 p2,
5407                 p3
5408             )
5409         );
5410     }
5411 
5412     function log(
5413         address p0,
5414         uint256 p1,
5415         string memory p2,
5416         bool p3
5417     ) internal view {
5418         _sendLogPayload(
5419             abi.encodeWithSignature(
5420                 "log(address,uint,string,bool)",
5421                 p0,
5422                 p1,
5423                 p2,
5424                 p3
5425             )
5426         );
5427     }
5428 
5429     function log(
5430         address p0,
5431         uint256 p1,
5432         string memory p2,
5433         address p3
5434     ) internal view {
5435         _sendLogPayload(
5436             abi.encodeWithSignature(
5437                 "log(address,uint,string,address)",
5438                 p0,
5439                 p1,
5440                 p2,
5441                 p3
5442             )
5443         );
5444     }
5445 
5446     function log(
5447         address p0,
5448         uint256 p1,
5449         bool p2,
5450         uint256 p3
5451     ) internal view {
5452         _sendLogPayload(
5453             abi.encodeWithSignature(
5454                 "log(address,uint,bool,uint)",
5455                 p0,
5456                 p1,
5457                 p2,
5458                 p3
5459             )
5460         );
5461     }
5462 
5463     function log(
5464         address p0,
5465         uint256 p1,
5466         bool p2,
5467         string memory p3
5468     ) internal view {
5469         _sendLogPayload(
5470             abi.encodeWithSignature(
5471                 "log(address,uint,bool,string)",
5472                 p0,
5473                 p1,
5474                 p2,
5475                 p3
5476             )
5477         );
5478     }
5479 
5480     function log(
5481         address p0,
5482         uint256 p1,
5483         bool p2,
5484         bool p3
5485     ) internal view {
5486         _sendLogPayload(
5487             abi.encodeWithSignature(
5488                 "log(address,uint,bool,bool)",
5489                 p0,
5490                 p1,
5491                 p2,
5492                 p3
5493             )
5494         );
5495     }
5496 
5497     function log(
5498         address p0,
5499         uint256 p1,
5500         bool p2,
5501         address p3
5502     ) internal view {
5503         _sendLogPayload(
5504             abi.encodeWithSignature(
5505                 "log(address,uint,bool,address)",
5506                 p0,
5507                 p1,
5508                 p2,
5509                 p3
5510             )
5511         );
5512     }
5513 
5514     function log(
5515         address p0,
5516         uint256 p1,
5517         address p2,
5518         uint256 p3
5519     ) internal view {
5520         _sendLogPayload(
5521             abi.encodeWithSignature(
5522                 "log(address,uint,address,uint)",
5523                 p0,
5524                 p1,
5525                 p2,
5526                 p3
5527             )
5528         );
5529     }
5530 
5531     function log(
5532         address p0,
5533         uint256 p1,
5534         address p2,
5535         string memory p3
5536     ) internal view {
5537         _sendLogPayload(
5538             abi.encodeWithSignature(
5539                 "log(address,uint,address,string)",
5540                 p0,
5541                 p1,
5542                 p2,
5543                 p3
5544             )
5545         );
5546     }
5547 
5548     function log(
5549         address p0,
5550         uint256 p1,
5551         address p2,
5552         bool p3
5553     ) internal view {
5554         _sendLogPayload(
5555             abi.encodeWithSignature(
5556                 "log(address,uint,address,bool)",
5557                 p0,
5558                 p1,
5559                 p2,
5560                 p3
5561             )
5562         );
5563     }
5564 
5565     function log(
5566         address p0,
5567         uint256 p1,
5568         address p2,
5569         address p3
5570     ) internal view {
5571         _sendLogPayload(
5572             abi.encodeWithSignature(
5573                 "log(address,uint,address,address)",
5574                 p0,
5575                 p1,
5576                 p2,
5577                 p3
5578             )
5579         );
5580     }
5581 
5582     function log(
5583         address p0,
5584         string memory p1,
5585         uint256 p2,
5586         uint256 p3
5587     ) internal view {
5588         _sendLogPayload(
5589             abi.encodeWithSignature(
5590                 "log(address,string,uint,uint)",
5591                 p0,
5592                 p1,
5593                 p2,
5594                 p3
5595             )
5596         );
5597     }
5598 
5599     function log(
5600         address p0,
5601         string memory p1,
5602         uint256 p2,
5603         string memory p3
5604     ) internal view {
5605         _sendLogPayload(
5606             abi.encodeWithSignature(
5607                 "log(address,string,uint,string)",
5608                 p0,
5609                 p1,
5610                 p2,
5611                 p3
5612             )
5613         );
5614     }
5615 
5616     function log(
5617         address p0,
5618         string memory p1,
5619         uint256 p2,
5620         bool p3
5621     ) internal view {
5622         _sendLogPayload(
5623             abi.encodeWithSignature(
5624                 "log(address,string,uint,bool)",
5625                 p0,
5626                 p1,
5627                 p2,
5628                 p3
5629             )
5630         );
5631     }
5632 
5633     function log(
5634         address p0,
5635         string memory p1,
5636         uint256 p2,
5637         address p3
5638     ) internal view {
5639         _sendLogPayload(
5640             abi.encodeWithSignature(
5641                 "log(address,string,uint,address)",
5642                 p0,
5643                 p1,
5644                 p2,
5645                 p3
5646             )
5647         );
5648     }
5649 
5650     function log(
5651         address p0,
5652         string memory p1,
5653         string memory p2,
5654         uint256 p3
5655     ) internal view {
5656         _sendLogPayload(
5657             abi.encodeWithSignature(
5658                 "log(address,string,string,uint)",
5659                 p0,
5660                 p1,
5661                 p2,
5662                 p3
5663             )
5664         );
5665     }
5666 
5667     function log(
5668         address p0,
5669         string memory p1,
5670         string memory p2,
5671         string memory p3
5672     ) internal view {
5673         _sendLogPayload(
5674             abi.encodeWithSignature(
5675                 "log(address,string,string,string)",
5676                 p0,
5677                 p1,
5678                 p2,
5679                 p3
5680             )
5681         );
5682     }
5683 
5684     function log(
5685         address p0,
5686         string memory p1,
5687         string memory p2,
5688         bool p3
5689     ) internal view {
5690         _sendLogPayload(
5691             abi.encodeWithSignature(
5692                 "log(address,string,string,bool)",
5693                 p0,
5694                 p1,
5695                 p2,
5696                 p3
5697             )
5698         );
5699     }
5700 
5701     function log(
5702         address p0,
5703         string memory p1,
5704         string memory p2,
5705         address p3
5706     ) internal view {
5707         _sendLogPayload(
5708             abi.encodeWithSignature(
5709                 "log(address,string,string,address)",
5710                 p0,
5711                 p1,
5712                 p2,
5713                 p3
5714             )
5715         );
5716     }
5717 
5718     function log(
5719         address p0,
5720         string memory p1,
5721         bool p2,
5722         uint256 p3
5723     ) internal view {
5724         _sendLogPayload(
5725             abi.encodeWithSignature(
5726                 "log(address,string,bool,uint)",
5727                 p0,
5728                 p1,
5729                 p2,
5730                 p3
5731             )
5732         );
5733     }
5734 
5735     function log(
5736         address p0,
5737         string memory p1,
5738         bool p2,
5739         string memory p3
5740     ) internal view {
5741         _sendLogPayload(
5742             abi.encodeWithSignature(
5743                 "log(address,string,bool,string)",
5744                 p0,
5745                 p1,
5746                 p2,
5747                 p3
5748             )
5749         );
5750     }
5751 
5752     function log(
5753         address p0,
5754         string memory p1,
5755         bool p2,
5756         bool p3
5757     ) internal view {
5758         _sendLogPayload(
5759             abi.encodeWithSignature(
5760                 "log(address,string,bool,bool)",
5761                 p0,
5762                 p1,
5763                 p2,
5764                 p3
5765             )
5766         );
5767     }
5768 
5769     function log(
5770         address p0,
5771         string memory p1,
5772         bool p2,
5773         address p3
5774     ) internal view {
5775         _sendLogPayload(
5776             abi.encodeWithSignature(
5777                 "log(address,string,bool,address)",
5778                 p0,
5779                 p1,
5780                 p2,
5781                 p3
5782             )
5783         );
5784     }
5785 
5786     function log(
5787         address p0,
5788         string memory p1,
5789         address p2,
5790         uint256 p3
5791     ) internal view {
5792         _sendLogPayload(
5793             abi.encodeWithSignature(
5794                 "log(address,string,address,uint)",
5795                 p0,
5796                 p1,
5797                 p2,
5798                 p3
5799             )
5800         );
5801     }
5802 
5803     function log(
5804         address p0,
5805         string memory p1,
5806         address p2,
5807         string memory p3
5808     ) internal view {
5809         _sendLogPayload(
5810             abi.encodeWithSignature(
5811                 "log(address,string,address,string)",
5812                 p0,
5813                 p1,
5814                 p2,
5815                 p3
5816             )
5817         );
5818     }
5819 
5820     function log(
5821         address p0,
5822         string memory p1,
5823         address p2,
5824         bool p3
5825     ) internal view {
5826         _sendLogPayload(
5827             abi.encodeWithSignature(
5828                 "log(address,string,address,bool)",
5829                 p0,
5830                 p1,
5831                 p2,
5832                 p3
5833             )
5834         );
5835     }
5836 
5837     function log(
5838         address p0,
5839         string memory p1,
5840         address p2,
5841         address p3
5842     ) internal view {
5843         _sendLogPayload(
5844             abi.encodeWithSignature(
5845                 "log(address,string,address,address)",
5846                 p0,
5847                 p1,
5848                 p2,
5849                 p3
5850             )
5851         );
5852     }
5853 
5854     function log(
5855         address p0,
5856         bool p1,
5857         uint256 p2,
5858         uint256 p3
5859     ) internal view {
5860         _sendLogPayload(
5861             abi.encodeWithSignature(
5862                 "log(address,bool,uint,uint)",
5863                 p0,
5864                 p1,
5865                 p2,
5866                 p3
5867             )
5868         );
5869     }
5870 
5871     function log(
5872         address p0,
5873         bool p1,
5874         uint256 p2,
5875         string memory p3
5876     ) internal view {
5877         _sendLogPayload(
5878             abi.encodeWithSignature(
5879                 "log(address,bool,uint,string)",
5880                 p0,
5881                 p1,
5882                 p2,
5883                 p3
5884             )
5885         );
5886     }
5887 
5888     function log(
5889         address p0,
5890         bool p1,
5891         uint256 p2,
5892         bool p3
5893     ) internal view {
5894         _sendLogPayload(
5895             abi.encodeWithSignature(
5896                 "log(address,bool,uint,bool)",
5897                 p0,
5898                 p1,
5899                 p2,
5900                 p3
5901             )
5902         );
5903     }
5904 
5905     function log(
5906         address p0,
5907         bool p1,
5908         uint256 p2,
5909         address p3
5910     ) internal view {
5911         _sendLogPayload(
5912             abi.encodeWithSignature(
5913                 "log(address,bool,uint,address)",
5914                 p0,
5915                 p1,
5916                 p2,
5917                 p3
5918             )
5919         );
5920     }
5921 
5922     function log(
5923         address p0,
5924         bool p1,
5925         string memory p2,
5926         uint256 p3
5927     ) internal view {
5928         _sendLogPayload(
5929             abi.encodeWithSignature(
5930                 "log(address,bool,string,uint)",
5931                 p0,
5932                 p1,
5933                 p2,
5934                 p3
5935             )
5936         );
5937     }
5938 
5939     function log(
5940         address p0,
5941         bool p1,
5942         string memory p2,
5943         string memory p3
5944     ) internal view {
5945         _sendLogPayload(
5946             abi.encodeWithSignature(
5947                 "log(address,bool,string,string)",
5948                 p0,
5949                 p1,
5950                 p2,
5951                 p3
5952             )
5953         );
5954     }
5955 
5956     function log(
5957         address p0,
5958         bool p1,
5959         string memory p2,
5960         bool p3
5961     ) internal view {
5962         _sendLogPayload(
5963             abi.encodeWithSignature(
5964                 "log(address,bool,string,bool)",
5965                 p0,
5966                 p1,
5967                 p2,
5968                 p3
5969             )
5970         );
5971     }
5972 
5973     function log(
5974         address p0,
5975         bool p1,
5976         string memory p2,
5977         address p3
5978     ) internal view {
5979         _sendLogPayload(
5980             abi.encodeWithSignature(
5981                 "log(address,bool,string,address)",
5982                 p0,
5983                 p1,
5984                 p2,
5985                 p3
5986             )
5987         );
5988     }
5989 
5990     function log(
5991         address p0,
5992         bool p1,
5993         bool p2,
5994         uint256 p3
5995     ) internal view {
5996         _sendLogPayload(
5997             abi.encodeWithSignature(
5998                 "log(address,bool,bool,uint)",
5999                 p0,
6000                 p1,
6001                 p2,
6002                 p3
6003             )
6004         );
6005     }
6006 
6007     function log(
6008         address p0,
6009         bool p1,
6010         bool p2,
6011         string memory p3
6012     ) internal view {
6013         _sendLogPayload(
6014             abi.encodeWithSignature(
6015                 "log(address,bool,bool,string)",
6016                 p0,
6017                 p1,
6018                 p2,
6019                 p3
6020             )
6021         );
6022     }
6023 
6024     function log(
6025         address p0,
6026         bool p1,
6027         bool p2,
6028         bool p3
6029     ) internal view {
6030         _sendLogPayload(
6031             abi.encodeWithSignature(
6032                 "log(address,bool,bool,bool)",
6033                 p0,
6034                 p1,
6035                 p2,
6036                 p3
6037             )
6038         );
6039     }
6040 
6041     function log(
6042         address p0,
6043         bool p1,
6044         bool p2,
6045         address p3
6046     ) internal view {
6047         _sendLogPayload(
6048             abi.encodeWithSignature(
6049                 "log(address,bool,bool,address)",
6050                 p0,
6051                 p1,
6052                 p2,
6053                 p3
6054             )
6055         );
6056     }
6057 
6058     function log(
6059         address p0,
6060         bool p1,
6061         address p2,
6062         uint256 p3
6063     ) internal view {
6064         _sendLogPayload(
6065             abi.encodeWithSignature(
6066                 "log(address,bool,address,uint)",
6067                 p0,
6068                 p1,
6069                 p2,
6070                 p3
6071             )
6072         );
6073     }
6074 
6075     function log(
6076         address p0,
6077         bool p1,
6078         address p2,
6079         string memory p3
6080     ) internal view {
6081         _sendLogPayload(
6082             abi.encodeWithSignature(
6083                 "log(address,bool,address,string)",
6084                 p0,
6085                 p1,
6086                 p2,
6087                 p3
6088             )
6089         );
6090     }
6091 
6092     function log(
6093         address p0,
6094         bool p1,
6095         address p2,
6096         bool p3
6097     ) internal view {
6098         _sendLogPayload(
6099             abi.encodeWithSignature(
6100                 "log(address,bool,address,bool)",
6101                 p0,
6102                 p1,
6103                 p2,
6104                 p3
6105             )
6106         );
6107     }
6108 
6109     function log(
6110         address p0,
6111         bool p1,
6112         address p2,
6113         address p3
6114     ) internal view {
6115         _sendLogPayload(
6116             abi.encodeWithSignature(
6117                 "log(address,bool,address,address)",
6118                 p0,
6119                 p1,
6120                 p2,
6121                 p3
6122             )
6123         );
6124     }
6125 
6126     function log(
6127         address p0,
6128         address p1,
6129         uint256 p2,
6130         uint256 p3
6131     ) internal view {
6132         _sendLogPayload(
6133             abi.encodeWithSignature(
6134                 "log(address,address,uint,uint)",
6135                 p0,
6136                 p1,
6137                 p2,
6138                 p3
6139             )
6140         );
6141     }
6142 
6143     function log(
6144         address p0,
6145         address p1,
6146         uint256 p2,
6147         string memory p3
6148     ) internal view {
6149         _sendLogPayload(
6150             abi.encodeWithSignature(
6151                 "log(address,address,uint,string)",
6152                 p0,
6153                 p1,
6154                 p2,
6155                 p3
6156             )
6157         );
6158     }
6159 
6160     function log(
6161         address p0,
6162         address p1,
6163         uint256 p2,
6164         bool p3
6165     ) internal view {
6166         _sendLogPayload(
6167             abi.encodeWithSignature(
6168                 "log(address,address,uint,bool)",
6169                 p0,
6170                 p1,
6171                 p2,
6172                 p3
6173             )
6174         );
6175     }
6176 
6177     function log(
6178         address p0,
6179         address p1,
6180         uint256 p2,
6181         address p3
6182     ) internal view {
6183         _sendLogPayload(
6184             abi.encodeWithSignature(
6185                 "log(address,address,uint,address)",
6186                 p0,
6187                 p1,
6188                 p2,
6189                 p3
6190             )
6191         );
6192     }
6193 
6194     function log(
6195         address p0,
6196         address p1,
6197         string memory p2,
6198         uint256 p3
6199     ) internal view {
6200         _sendLogPayload(
6201             abi.encodeWithSignature(
6202                 "log(address,address,string,uint)",
6203                 p0,
6204                 p1,
6205                 p2,
6206                 p3
6207             )
6208         );
6209     }
6210 
6211     function log(
6212         address p0,
6213         address p1,
6214         string memory p2,
6215         string memory p3
6216     ) internal view {
6217         _sendLogPayload(
6218             abi.encodeWithSignature(
6219                 "log(address,address,string,string)",
6220                 p0,
6221                 p1,
6222                 p2,
6223                 p3
6224             )
6225         );
6226     }
6227 
6228     function log(
6229         address p0,
6230         address p1,
6231         string memory p2,
6232         bool p3
6233     ) internal view {
6234         _sendLogPayload(
6235             abi.encodeWithSignature(
6236                 "log(address,address,string,bool)",
6237                 p0,
6238                 p1,
6239                 p2,
6240                 p3
6241             )
6242         );
6243     }
6244 
6245     function log(
6246         address p0,
6247         address p1,
6248         string memory p2,
6249         address p3
6250     ) internal view {
6251         _sendLogPayload(
6252             abi.encodeWithSignature(
6253                 "log(address,address,string,address)",
6254                 p0,
6255                 p1,
6256                 p2,
6257                 p3
6258             )
6259         );
6260     }
6261 
6262     function log(
6263         address p0,
6264         address p1,
6265         bool p2,
6266         uint256 p3
6267     ) internal view {
6268         _sendLogPayload(
6269             abi.encodeWithSignature(
6270                 "log(address,address,bool,uint)",
6271                 p0,
6272                 p1,
6273                 p2,
6274                 p3
6275             )
6276         );
6277     }
6278 
6279     function log(
6280         address p0,
6281         address p1,
6282         bool p2,
6283         string memory p3
6284     ) internal view {
6285         _sendLogPayload(
6286             abi.encodeWithSignature(
6287                 "log(address,address,bool,string)",
6288                 p0,
6289                 p1,
6290                 p2,
6291                 p3
6292             )
6293         );
6294     }
6295 
6296     function log(
6297         address p0,
6298         address p1,
6299         bool p2,
6300         bool p3
6301     ) internal view {
6302         _sendLogPayload(
6303             abi.encodeWithSignature(
6304                 "log(address,address,bool,bool)",
6305                 p0,
6306                 p1,
6307                 p2,
6308                 p3
6309             )
6310         );
6311     }
6312 
6313     function log(
6314         address p0,
6315         address p1,
6316         bool p2,
6317         address p3
6318     ) internal view {
6319         _sendLogPayload(
6320             abi.encodeWithSignature(
6321                 "log(address,address,bool,address)",
6322                 p0,
6323                 p1,
6324                 p2,
6325                 p3
6326             )
6327         );
6328     }
6329 
6330     function log(
6331         address p0,
6332         address p1,
6333         address p2,
6334         uint256 p3
6335     ) internal view {
6336         _sendLogPayload(
6337             abi.encodeWithSignature(
6338                 "log(address,address,address,uint)",
6339                 p0,
6340                 p1,
6341                 p2,
6342                 p3
6343             )
6344         );
6345     }
6346 
6347     function log(
6348         address p0,
6349         address p1,
6350         address p2,
6351         string memory p3
6352     ) internal view {
6353         _sendLogPayload(
6354             abi.encodeWithSignature(
6355                 "log(address,address,address,string)",
6356                 p0,
6357                 p1,
6358                 p2,
6359                 p3
6360             )
6361         );
6362     }
6363 
6364     function log(
6365         address p0,
6366         address p1,
6367         address p2,
6368         bool p3
6369     ) internal view {
6370         _sendLogPayload(
6371             abi.encodeWithSignature(
6372                 "log(address,address,address,bool)",
6373                 p0,
6374                 p1,
6375                 p2,
6376                 p3
6377             )
6378         );
6379     }
6380 
6381     function log(
6382         address p0,
6383         address p1,
6384         address p2,
6385         address p3
6386     ) internal view {
6387         _sendLogPayload(
6388             abi.encodeWithSignature(
6389                 "log(address,address,address,address)",
6390                 p0,
6391                 p1,
6392                 p2,
6393                 p3
6394             )
6395         );
6396     }
6397 }
6398 
6399 // File: contracts/uniswapv2/libraries/SafeMath.sol
6400 
6401 pragma solidity 0.6.12;
6402 
6403 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
6404 
6405 library SafeMathUniswap {
6406     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
6407         require((z = x + y) >= x, "ds-math-add-overflow");
6408     }
6409 
6410     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
6411         require((z = x - y) <= x, "ds-math-sub-underflow");
6412     }
6413 
6414     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
6415         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
6416     }
6417 }
6418 
6419 // File: contracts/uniswapv2/libraries/UniswapV2Library.sol
6420 
6421 pragma solidity 0.6.12;
6422 
6423 library UniswapV2Library {
6424     using SafeMathUniswap for uint256;
6425 
6426     // returns sorted token addresses, used to handle return values from pairs sorted in this order
6427     function sortTokens(address tokenA, address tokenB)
6428         internal
6429         pure
6430         returns (address token0, address token1)
6431     {
6432         require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
6433         (token0, token1) = tokenA < tokenB
6434             ? (tokenA, tokenB)
6435             : (tokenB, tokenA);
6436         require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
6437     }
6438 
6439     // calculates the CREATE2 address for a pair without making any external calls
6440     function pairFor(
6441         address factory,
6442         address tokenA,
6443         address tokenB
6444     ) internal pure returns (address pair) {
6445         (address token0, address token1) = sortTokens(tokenA, tokenB);
6446         pair = address(
6447             uint256(
6448                 keccak256(
6449                     abi.encodePacked(
6450                         hex"ff",
6451                         factory,
6452                         keccak256(abi.encodePacked(token0, token1)),
6453                         hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f" // init code hash
6454                     )
6455                 )
6456             )
6457         );
6458     }
6459 
6460     // fetches and sorts the reserves for a pair
6461     function getReserves(
6462         address factory,
6463         address tokenA,
6464         address tokenB
6465     ) internal view returns (uint256 reserveA, uint256 reserveB) {
6466         (address token0, ) = sortTokens(tokenA, tokenB);
6467         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(
6468             IUniswapV2Factory(factory).getPair(tokenA, tokenB)
6469         )
6470             .getReserves();
6471         (reserveA, reserveB) = tokenA == token0
6472             ? (reserve0, reserve1)
6473             : (reserve1, reserve0);
6474     }
6475 
6476     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
6477     function quote(
6478         uint256 amountA,
6479         uint256 reserveA,
6480         uint256 reserveB
6481     ) internal pure returns (uint256 amountB) {
6482         require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
6483         require(
6484             reserveA > 0 && reserveB > 0,
6485             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
6486         );
6487         amountB = amountA.mul(reserveB) / reserveA;
6488     }
6489 
6490     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
6491     function getAmountOut(
6492         uint256 amountIn,
6493         uint256 reserveIn,
6494         uint256 reserveOut
6495     ) internal pure returns (uint256 amountOut) {
6496         require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
6497         require(
6498             reserveIn > 0 && reserveOut > 0,
6499             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
6500         );
6501         uint256 amountInWithFee = amountIn.mul(997);
6502         uint256 numerator = amountInWithFee.mul(reserveOut);
6503         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
6504         amountOut = numerator / denominator;
6505     }
6506 
6507     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
6508     function getAmountIn(
6509         uint256 amountOut,
6510         uint256 reserveIn,
6511         uint256 reserveOut
6512     ) internal pure returns (uint256 amountIn) {
6513         require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
6514         require(
6515             reserveIn > 0 && reserveOut > 0,
6516             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
6517         );
6518         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
6519         uint256 denominator = reserveOut.sub(amountOut).mul(997);
6520         amountIn = (numerator / denominator).add(1);
6521     }
6522 
6523     // performs chained getAmountOut calculations on any number of pairs
6524     function getAmountsOut(
6525         address factory,
6526         uint256 amountIn,
6527         address[] memory path
6528     ) internal view returns (uint256[] memory amounts) {
6529         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
6530         amounts = new uint256[](path.length);
6531         amounts[0] = amountIn;
6532         for (uint256 i; i < path.length - 1; i++) {
6533             (uint256 reserveIn, uint256 reserveOut) = getReserves(
6534                 factory,
6535                 path[i],
6536                 path[i + 1]
6537             );
6538             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
6539         }
6540     }
6541 
6542     // performs chained getAmountIn calculations on any number of pairs
6543     function getAmountsIn(
6544         address factory,
6545         uint256 amountOut,
6546         address[] memory path
6547     ) internal view returns (uint256[] memory amounts) {
6548         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
6549         amounts = new uint256[](path.length);
6550         amounts[amounts.length - 1] = amountOut;
6551         for (uint256 i = path.length - 1; i > 0; i--) {
6552             (uint256 reserveIn, uint256 reserveOut) = getReserves(
6553                 factory,
6554                 path[i - 1],
6555                 path[i]
6556             );
6557             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
6558         }
6559     }
6560 }
6561 
6562 // File: contracts/FarmETHRouter.sol
6563 
6564 pragma solidity 0.6.12;
6565 
6566 interface IStakingPool {
6567     function depositFor(address _depositFor, uint256 _originAmount) external;
6568 }
6569 
6570 contract FarmETHRouter is OwnableUpgradeSafe {
6571     using SafeMath for uint256;
6572     using SafeERC20 for IERC20;
6573     mapping(address => uint256) public hardNerd;
6574 
6575     address public _nerdToken;
6576     address public _nerdWETHPair;
6577     IFeeApprover public _feeApprover;
6578     INerdVault public _nerdVault;
6579     IWETH public _WETH;
6580     address public _uniV2Factory;
6581     address public _uniV2Router;
6582 
6583     function initialize() public initializer {
6584         OwnableUpgradeSafe.__Ownable_init();
6585         _nerdToken = 0x32C868F6318D6334B2250F323D914Bc2239E4EeE;
6586         _uniV2Factory = INerdBaseTokenLGE(_nerdToken).getUniswapFactory();
6587         _uniV2Router = INerdBaseTokenLGE(_nerdToken).getUniswapRouterV2();
6588         _WETH = IWETH(IUniswapV2Router02(_uniV2Router).WETH());
6589         _feeApprover = IFeeApprover(
6590             INerdBaseTokenLGE(_nerdToken).transferCheckerAddress()
6591         );
6592         _nerdWETHPair = INerdBaseTokenLGE(_nerdToken).getTokenUniswapPair();
6593         _nerdVault = INerdVault(0x47cE2237d7235Ff865E1C74bF3C6d9AF88d1bbfF);
6594         refreshApproval();
6595     }
6596 
6597     function refreshApproval() public {
6598         IUniswapV2Pair(_nerdWETHPair).approve(address(_nerdVault), uint256(-1));
6599     }
6600 
6601     event FeeApproverChanged(
6602         address indexed newAddress,
6603         address indexed oldAddress
6604     );
6605 
6606     fallback() external payable {
6607         if (msg.sender != address(_WETH)) {
6608             addLiquidityETHOnly(msg.sender, false);
6609         }
6610     }
6611 
6612     function safeTransferFrom(
6613         address token,
6614         address from,
6615         address to,
6616         uint256 value
6617     ) internal {
6618         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
6619         (bool success, bytes memory data) = token.call(
6620             abi.encodeWithSelector(0x23b872dd, from, to, value)
6621         );
6622         require(
6623             success && (data.length == 0 || abi.decode(data, (bool))),
6624             "TransferHelper: TRANSFER_FROM_FAILED"
6625         );
6626     }
6627 
6628     function safeTransferIn(address _source, uint256 _amount)
6629         internal
6630         returns (uint256)
6631     {
6632         uint256 sourceBalBefore = IERC20(_source).balanceOf(address(this));
6633         safeTransferFrom(_source, msg.sender, address(this), _amount);
6634         uint256 sourceBalAfter = IERC20(_source).balanceOf(address(this));
6635         return sourceBalAfter.sub(sourceBalBefore);
6636     }
6637 
6638     function stakeNerdByETH(address stakingPool) external payable {
6639         require(address(_WETH) != address(0), "invalid WETH");
6640         _WETH.deposit{value: msg.value}();
6641         stakeInternal(stakingPool, msg.value);
6642     }
6643 
6644     function stakeNerdByAnyToken(
6645         address stakingPool,
6646         address sourceToken,
6647         uint256 amount
6648     ) external {
6649         require(stakingPool != address(0), "invalid staking pool");
6650         uint256 sourceBal = safeTransferIn(sourceToken, amount);
6651         //get eth pair with source
6652         //swap source token for WETH
6653         IERC20(sourceToken).safeApprove(_uniV2Router, sourceBal);
6654         uint256 _ethAmount = sourceBal;
6655         if (address(_WETH) != sourceToken) {
6656             address[] memory path = new address[](2);
6657             path[0] = sourceToken;
6658             path[1] = address(_WETH);
6659             uint256 ethBefore = _WETH.balanceOf(address(this));
6660             IUniswapV2Router02(_uniV2Router).swapExactTokensForTokens(
6661                 sourceBal,
6662                 0,
6663                 path,
6664                 address(this),
6665                 block.timestamp + 100
6666             );
6667             _ethAmount = _WETH.balanceOf(address(this)).sub(ethBefore);
6668         }
6669         stakeInternal(stakingPool, _ethAmount);
6670     }
6671 
6672     function stakeInternal(address stakingPool, uint256 _ethAmount) internal {
6673         (uint256 reserveWeth, uint256 reservenerd) = getPairReserves(
6674             address(_nerdWETHPair)
6675         );
6676         uint256 outnerd = UniswapV2Library.getAmountOut(
6677             _ethAmount,
6678             reserveWeth,
6679             reservenerd
6680         );
6681         _WETH.transfer(_nerdWETHPair, _ethAmount);
6682         (address token0, address token1) = UniswapV2Library.sortTokens(
6683             address(_WETH),
6684             _nerdToken
6685         );
6686         IUniswapV2Pair(_nerdWETHPair).swap(
6687             _nerdToken == token0 ? outnerd : 0,
6688             _nerdToken == token1 ? outnerd : 0,
6689             address(this),
6690             ""
6691         );
6692         outnerd = IERC20(_nerdToken).balanceOf(address(this));
6693         IERC20(_nerdToken).approve(stakingPool, outnerd);
6694         IStakingPool(stakingPool).depositFor(msg.sender, outnerd);
6695     }
6696 
6697     function addLiquidityByTokenForPool(
6698         address sourceToken,
6699         uint256 amount,
6700         uint256 pid,
6701         address payable to,
6702         bool autoStake
6703     ) external {
6704         uint256 sourceBal = safeTransferIn(sourceToken, amount);
6705         //get eth pair with source
6706         //swap source token for WETH
6707         IERC20(sourceToken).safeApprove(_uniV2Router, sourceBal);
6708         uint256 _ethAmount = sourceBal;
6709         if (address(_WETH) != sourceToken) {
6710             address[] memory path = new address[](2);
6711             path[0] = sourceToken;
6712             path[1] = address(_WETH);
6713             uint256 ethBefore = _WETH.balanceOf(address(this));
6714             IUniswapV2Router02(_uniV2Router).swapExactTokensForTokens(
6715                 sourceBal,
6716                 0,
6717                 path,
6718                 address(this),
6719                 block.timestamp + 100
6720             );
6721             _ethAmount = _WETH.balanceOf(address(this)).sub(ethBefore);
6722         }
6723         _addLiquidityETHOnlyForPool(pid, to, autoStake, _ethAmount, false);
6724     }
6725 
6726     //this is only applied for pool 0: NERD-ETH
6727     function addLiquidityETHOnlyForPool(
6728         uint256 pid,
6729         address payable to,
6730         bool autoStake
6731     ) public payable {
6732         require(to != address(0), "Invalid address");
6733         _addLiquidityETHOnlyForPool(pid, to, autoStake, msg.value, true);
6734     }
6735 
6736     function _addLiquidityETHOnlyForPool(
6737         uint256 pid,
6738         address payable to,
6739         bool autoStake,
6740         uint256 _value,
6741         bool _needDeposit
6742     ) internal {
6743         hardNerd[msg.sender] = hardNerd[msg.sender].add(_value);
6744         uint256 buyAmount = _value.div(2);
6745         require(buyAmount > 0, "Insufficient ETH amount");
6746         (address lpAddress, , , , , , , , ) = _nerdVault.poolInfo(pid);
6747         IUniswapV2Pair pair = IUniswapV2Pair(lpAddress);
6748         address otherToken = pair.token0() == _nerdToken
6749             ? pair.token1()
6750             : pair.token0();
6751 
6752         require(
6753             otherToken != address(_WETH),
6754             "Please use addLiquidityETHOnly function"
6755         );
6756         if (_needDeposit) {
6757             _WETH.deposit{value: _value}();
6758         }
6759 
6760         uint256 outnerd = 0;
6761         uint256 outOther = 0;
6762         {
6763             //buy nerd
6764             address pairWithEth = _nerdWETHPair;
6765             (uint256 reserveWeth, uint256 reservenerd) = getPairReserves(
6766                 pairWithEth
6767             );
6768             outnerd = UniswapV2Library.getAmountOut(
6769                 buyAmount,
6770                 reserveWeth,
6771                 reservenerd
6772             );
6773             _WETH.transfer(pairWithEth, buyAmount);
6774             (address token0, address token1) = UniswapV2Library.sortTokens(
6775                 address(_WETH),
6776                 _nerdToken
6777             );
6778             IUniswapV2Pair(pairWithEth).swap(
6779                 _nerdToken == token0 ? outnerd : 0,
6780                 _nerdToken == token1 ? outnerd : 0,
6781                 address(this),
6782                 ""
6783             );
6784             outnerd = IERC20(_nerdToken).balanceOf(address(this));
6785         }
6786 
6787         {
6788             //buy other token
6789             address pairWithEth = IUniswapV2Factory(_uniV2Factory).getPair(
6790                 address(_WETH),
6791                 otherToken
6792             );
6793             (uint256 reserveWeth, uint256 reserveOther) = getPairReserves(
6794                 pairWithEth
6795             );
6796             outOther = UniswapV2Library.getAmountOut(
6797                 buyAmount,
6798                 reserveWeth,
6799                 reserveOther
6800             );
6801             _WETH.transfer(pairWithEth, buyAmount);
6802             (address token0, address token1) = UniswapV2Library.sortTokens(
6803                 address(_WETH),
6804                 otherToken
6805             );
6806             IUniswapV2Pair(pairWithEth).swap(
6807                 otherToken == token0 ? outOther : 0,
6808                 otherToken == token1 ? outOther : 0,
6809                 address(this),
6810                 ""
6811             );
6812             outOther = IERC20(otherToken).balanceOf(address(this));
6813         }
6814 
6815         _addLiquidityForPool(
6816             pid,
6817             address(pair),
6818             outnerd,
6819             otherToken,
6820             outOther,
6821             to,
6822             autoStake
6823         );
6824     }
6825 
6826     //this is only applied for pool 0: NERD-ETH
6827     function addLiquidityETHOnly(address payable to, bool autoStake)
6828         public
6829         payable
6830     {
6831         require(to != address(0), "Invalid address");
6832         hardNerd[msg.sender] = hardNerd[msg.sender].add(msg.value);
6833         uint256 buyAmount = msg.value.div(2);
6834         require(buyAmount > 0, "Insufficient ETH amount");
6835         require(address(_WETH) != address(0), "invalid WETH");
6836         _WETH.deposit{value: msg.value}();
6837         (uint256 reserveWeth, uint256 reservenerd) = getPairReserves(
6838             address(_nerdWETHPair)
6839         );
6840         uint256 outnerd = UniswapV2Library.getAmountOut(
6841             buyAmount,
6842             reserveWeth,
6843             reservenerd
6844         );
6845         _WETH.transfer(_nerdWETHPair, buyAmount);
6846         (address token0, address token1) = UniswapV2Library.sortTokens(
6847             address(_WETH),
6848             _nerdToken
6849         );
6850         IUniswapV2Pair(_nerdWETHPair).swap(
6851             _nerdToken == token0 ? outnerd : 0,
6852             _nerdToken == token1 ? outnerd : 0,
6853             address(this),
6854             ""
6855         );
6856         outnerd = IERC20(_nerdToken).balanceOf(address(this));
6857         _addLiquidityPool0(outnerd, buyAmount, to, autoStake);
6858     }
6859 
6860     function _addLiquidityForPool(
6861         uint256 pid,
6862         address pair,
6863         uint256 nerdAmount,
6864         address otherAddress,
6865         uint256 otherAmount,
6866         address payable to,
6867         bool autoStake
6868     ) internal {
6869         if (IERC20(pair).totalSupply() == 0) {
6870             IERC20(_nerdToken).approve(_uniV2Router, uint256(-1));
6871             IERC20(otherAddress).approve(_uniV2Router, uint256(-1));
6872             if (autoStake) {
6873                 IUniswapV2Router02(_uniV2Router).addLiquidity(
6874                     _nerdToken,
6875                     otherAddress,
6876                     nerdAmount,
6877                     otherAmount,
6878                     0,
6879                     0,
6880                     address(this),
6881                     block.timestamp + 100
6882                 );
6883                 IUniswapV2Pair(pair).approve(address(_nerdVault), uint256(-1));
6884                 _nerdVault.depositFor(
6885                     to,
6886                     pid,
6887                     IUniswapV2Pair(pair).balanceOf(address(this))
6888                 );
6889             } else {
6890                 IUniswapV2Router02(_uniV2Router).addLiquidity(
6891                     _nerdToken,
6892                     otherAddress,
6893                     nerdAmount,
6894                     otherAmount,
6895                     0,
6896                     0,
6897                     to,
6898                     block.timestamp + 100
6899                 );
6900             }
6901             return;
6902         }
6903         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pair)
6904             .getReserves();
6905         (uint256 nerdReserve, uint256 otherTokenReserve) = (IUniswapV2Pair(pair)
6906             .token0() == otherAddress)
6907             ? (reserve1, reserve0)
6908             : (reserve0, reserve1);
6909 
6910         uint256 optimalnerdAmount = UniswapV2Library.quote(
6911             otherAmount,
6912             otherTokenReserve,
6913             nerdReserve
6914         );
6915 
6916         uint256 optimalOtherAmount;
6917         if (optimalnerdAmount > nerdAmount) {
6918             optimalOtherAmount = UniswapV2Library.quote(
6919                 nerdAmount,
6920                 nerdReserve,
6921                 otherTokenReserve
6922             );
6923             optimalnerdAmount = nerdAmount;
6924         } else optimalOtherAmount = otherAmount;
6925 
6926         assert(IERC20(otherAddress).transfer(pair, optimalOtherAmount));
6927         assert(IERC20(_nerdToken).transfer(pair, optimalnerdAmount));
6928 
6929         if (autoStake) {
6930             IUniswapV2Pair(pair).mint(address(this));
6931             IUniswapV2Pair(pair).approve(address(_nerdVault), uint256(-1));
6932             _nerdVault.depositFor(
6933                 to,
6934                 pid,
6935                 IUniswapV2Pair(pair).balanceOf(address(this))
6936             );
6937         } else IUniswapV2Pair(pair).mint(to);
6938 
6939         //refund dust
6940         if (IERC20(_nerdToken).balanceOf(address(this)) > 0)
6941             IERC20(_nerdToken).transfer(
6942                 to,
6943                 IERC20(_nerdToken).balanceOf(address(this))
6944             );
6945 
6946         if (IERC20(otherAddress).balanceOf(address(this)) > 0) {
6947             IERC20(otherAddress).transfer(
6948                 to,
6949                 IERC20(otherAddress).balanceOf(address(this))
6950             );
6951         }
6952     }
6953 
6954     function _addLiquidityPool0(
6955         uint256 nerdAmount,
6956         uint256 wethAmount,
6957         address payable to,
6958         bool autoStake
6959     ) internal {
6960         (uint256 wethReserve, uint256 nerdReserve) = getPairReserves(
6961             address(_nerdWETHPair)
6962         );
6963 
6964         uint256 optimalnerdAmount = UniswapV2Library.quote(
6965             wethAmount,
6966             wethReserve,
6967             nerdReserve
6968         );
6969 
6970         uint256 optimalWETHAmount;
6971         if (optimalnerdAmount > nerdAmount) {
6972             optimalWETHAmount = UniswapV2Library.quote(
6973                 nerdAmount,
6974                 nerdReserve,
6975                 wethReserve
6976             );
6977             optimalnerdAmount = nerdAmount;
6978         } else optimalWETHAmount = wethAmount;
6979 
6980         assert(_WETH.transfer(_nerdWETHPair, optimalWETHAmount));
6981         assert(IERC20(_nerdToken).transfer(_nerdWETHPair, optimalnerdAmount));
6982 
6983         if (autoStake) {
6984             IUniswapV2Pair(_nerdWETHPair).mint(address(this));
6985             _nerdVault.depositFor(
6986                 to,
6987                 0,
6988                 IUniswapV2Pair(_nerdWETHPair).balanceOf(address(this))
6989             );
6990         } else IUniswapV2Pair(_nerdWETHPair).mint(to);
6991 
6992         //refund dust
6993         if (IERC20(_nerdToken).balanceOf(address(this)) > 0)
6994             IERC20(_nerdToken).transfer(
6995                 to,
6996                 IERC20(_nerdToken).balanceOf(address(this))
6997             );
6998 
6999         if (_WETH.balanceOf(address(this)) > 0) {
7000             uint256 withdrawAmount = _WETH.balanceOf(address(this));
7001             _WETH.withdraw(withdrawAmount);
7002             to.transfer(withdrawAmount);
7003         }
7004     }
7005 
7006     function changeFeeApprover(address feeApprover) external onlyOwner {
7007         address oldAddress = address(_feeApprover);
7008         _feeApprover = IFeeApprover(feeApprover);
7009 
7010         emit FeeApproverChanged(feeApprover, oldAddress);
7011     }
7012 
7013     function getLPTokenPerEthUnit(uint256 ethAmt)
7014         public
7015         view
7016         returns (uint256 liquidity)
7017     {
7018         (uint256 reserveWeth, uint256 reservenerd) = getPairReserves(
7019             _nerdWETHPair
7020         );
7021         uint256 outnerd = UniswapV2Library.getAmountOut(
7022             ethAmt.div(2),
7023             reserveWeth,
7024             reservenerd
7025         );
7026         uint256 _totalSupply = IUniswapV2Pair(_nerdWETHPair).totalSupply();
7027 
7028         (address token0, ) = UniswapV2Library.sortTokens(
7029             address(_WETH),
7030             _nerdToken
7031         );
7032         (uint256 amount0, uint256 amount1) = token0 == _nerdToken
7033             ? (outnerd, ethAmt.div(2))
7034             : (ethAmt.div(2), outnerd);
7035         (uint256 _reserve0, uint256 _reserve1) = token0 == _nerdToken
7036             ? (reservenerd, reserveWeth)
7037             : (reserveWeth, reservenerd);
7038         liquidity = Math.min(
7039             amount0.mul(_totalSupply) / _reserve0,
7040             amount1.mul(_totalSupply) / _reserve1
7041         );
7042     }
7043 
7044     function getPairReserves(address _pair)
7045         internal
7046         view
7047         returns (uint256 wethReserves, uint256 otherTokenReserves)
7048     {
7049         address token0 = IUniswapV2Pair(_pair).token0();
7050         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(_pair)
7051             .getReserves();
7052         (wethReserves, otherTokenReserves) = token0 == address(_WETH)
7053             ? (reserve0, reserve1)
7054             : (reserve1, reserve0);
7055     }
7056 }