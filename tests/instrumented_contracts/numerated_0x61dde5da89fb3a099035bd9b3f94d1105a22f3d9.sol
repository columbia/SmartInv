1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2021 zapper
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU Affero General Public License as published by
11 // the Free Software Foundation, either version 2 of the License, or
12 // (at your option) any later version.
13 //
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU Affero General Public License for more details.
18 //
19 
20 ///@author Zapper
21 ///@notice This contract migrates liquidity from the Sushi yveCRV/ETH Pickle Jar to the Sushi yvBOOST/ETH Pickle Jar
22 // SPDX-License-Identifier: GPLv2
23 
24 // File: oz/GSN/Context.sol
25 
26 pragma solidity ^0.5.0;
27 
28 /*
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with GSN meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 contract Context {
39     // Empty internal constructor, to prevent people from mistakenly deploying
40     // an instance of this contract, which should be used via inheritance.
41     constructor() internal {}
42 
43     // solhint-disable-previous-line no-empty-blocks
44 
45     function _msgSender() internal view returns (address payable) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 // File: oz/ownership/Ownable.sol
56 
57 pragma solidity ^0.5.0;
58 
59 /**
60  * @dev Contract module which provides a basic access control mechanism, where
61  * there is an account (an owner) that can be granted exclusive access to
62  * specific functions.
63  *
64  * This module is used through inheritance. It will make available the modifier
65  * `onlyOwner`, which can be applied to your functions to restrict their use to
66  * the owner.
67  */
68 contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(
72         address indexed previousOwner,
73         address indexed newOwner
74     );
75 
76     /**
77      * @dev Initializes the contract setting the deployer as the initial owner.
78      */
79     constructor() internal {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     /**
86      * @dev Returns the address of the current owner.
87      */
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     /**
93      * @dev Throws if called by any account other than the owner.
94      */
95     modifier onlyOwner() {
96         require(isOwner(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     /**
101      * @dev Returns true if the caller is the current owner.
102      */
103     function isOwner() public view returns (bool) {
104         return _msgSender() == _owner;
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Can only be called by the current owner.
122      */
123     function transferOwnership(address newOwner) public onlyOwner {
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
129      */
130     function _transferOwnership(address newOwner) internal {
131         require(
132             newOwner != address(0),
133             "Ownable: new owner is the zero address"
134         );
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 
140 // File: oz/token/ERC20/IERC20.sol
141 
142 pragma solidity ^0.5.0;
143 
144 /**
145  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
146  * the optional functions; to access them see {ERC20Detailed}.
147  */
148 interface IERC20 {
149     function decimals() external view returns (uint8);
150 
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `recipient`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address recipient, uint256 amount)
169         external
170         returns (bool);
171 
172     /**
173      * @dev Returns the remaining number of tokens that `spender` will be
174      * allowed to spend on behalf of `owner` through {transferFrom}. This is
175      * zero by default.
176      *
177      * This value changes when {approve} or {transferFrom} are called.
178      */
179     function allowance(address owner, address spender)
180         external
181         view
182         returns (uint256);
183 
184     /**
185      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * IMPORTANT: Beware that changing an allowance with this method brings the risk
190      * that someone may use both the old and the new allowance by unfortunate
191      * transaction ordering. One possible solution to mitigate this race
192      * condition is to first reduce the spender's allowance to 0 and set the
193      * desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      *
196      * Emits an {Approval} event.
197      */
198     function approve(address spender, uint256 amount) external returns (bool);
199 
200     /**
201      * @dev Moves `amount` tokens from `sender` to `recipient` using the
202      * allowance mechanism. `amount` is then deducted from the caller's
203      * allowance.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address sender,
211         address recipient,
212         uint256 amount
213     ) external returns (bool);
214 
215     /**
216      * @dev Emitted when `value` tokens are moved from one account (`from`) to
217      * another (`to`).
218      *
219      * Note that `value` may be zero.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 value);
222 
223     /**
224      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
225      * a call to {approve}. `value` is the new allowance.
226      */
227     event Approval(
228         address indexed owner,
229         address indexed spender,
230         uint256 value
231     );
232 }
233 
234 // File: oz/math/SafeMath.sol
235 
236 pragma solidity ^0.5.0;
237 
238 /**
239  * @dev Wrappers over Solidity's arithmetic operations with added overflow
240  * checks.
241  *
242  * Arithmetic operations in Solidity wrap on overflow. This can easily result
243  * in bugs, because programmers usually assume that an overflow raises an
244  * error, which is the standard behavior in high level programming languages.
245  * `SafeMath` restores this intuition by reverting the transaction when an
246  * operation overflows.
247  *
248  * Using this library instead of the unchecked operations eliminates an entire
249  * class of bugs, so it's recommended to use it always.
250  */
251 library SafeMath {
252     /**
253      * @dev Returns the addition of two unsigned integers, reverting on
254      * overflow.
255      *
256      * Counterpart to Solidity's `+` operator.
257      *
258      * Requirements:
259      * - Addition cannot overflow.
260      */
261     function add(uint256 a, uint256 b) internal pure returns (uint256) {
262         uint256 c = a + b;
263         require(c >= a, "SafeMath: addition overflow");
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the subtraction of two unsigned integers, reverting on
270      * overflow (when the result is negative).
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      * - Subtraction cannot overflow.
276      */
277     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
278         return sub(a, b, "SafeMath: subtraction overflow");
279     }
280 
281     /**
282      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
283      * overflow (when the result is negative).
284      *
285      * Counterpart to Solidity's `-` operator.
286      *
287      * Requirements:
288      * - Subtraction cannot overflow.
289      *
290      * _Available since v2.4.0._
291      */
292     function sub(
293         uint256 a,
294         uint256 b,
295         string memory errorMessage
296     ) internal pure returns (uint256) {
297         require(b <= a, errorMessage);
298         uint256 c = a - b;
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the multiplication of two unsigned integers, reverting on
305      * overflow.
306      *
307      * Counterpart to Solidity's `*` operator.
308      *
309      * Requirements:
310      * - Multiplication cannot overflow.
311      */
312     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
313         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
314         // benefit is lost if 'b' is also tested.
315         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
316         if (a == 0) {
317             return 0;
318         }
319 
320         uint256 c = a * b;
321         require(c / a == b, "SafeMath: multiplication overflow");
322 
323         return c;
324     }
325 
326     /**
327      * @dev Returns the integer division of two unsigned integers. Reverts on
328      * division by zero. The result is rounded towards zero.
329      *
330      * Counterpart to Solidity's `/` operator. Note: this function uses a
331      * `revert` opcode (which leaves remaining gas untouched) while Solidity
332      * uses an invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      * - The divisor cannot be zero.
336      */
337     function div(uint256 a, uint256 b) internal pure returns (uint256) {
338         return div(a, b, "SafeMath: division by zero");
339     }
340 
341     /**
342      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
343      * division by zero. The result is rounded towards zero.
344      *
345      * Counterpart to Solidity's `/` operator. Note: this function uses a
346      * `revert` opcode (which leaves remaining gas untouched) while Solidity
347      * uses an invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      * - The divisor cannot be zero.
351      *
352      * _Available since v2.4.0._
353      */
354     function div(
355         uint256 a,
356         uint256 b,
357         string memory errorMessage
358     ) internal pure returns (uint256) {
359         // Solidity only automatically asserts when dividing by 0
360         require(b > 0, errorMessage);
361         uint256 c = a / b;
362         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
369      * Reverts when dividing by zero.
370      *
371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
372      * opcode (which leaves remaining gas untouched) while Solidity uses an
373      * invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      * - The divisor cannot be zero.
377      */
378     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
379         return mod(a, b, "SafeMath: modulo by zero");
380     }
381 
382     /**
383      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
384      * Reverts with custom message when dividing by zero.
385      *
386      * Counterpart to Solidity's `%` operator. This function uses a `revert`
387      * opcode (which leaves remaining gas untouched) while Solidity uses an
388      * invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      * - The divisor cannot be zero.
392      *
393      * _Available since v2.4.0._
394      */
395     function mod(
396         uint256 a,
397         uint256 b,
398         string memory errorMessage
399     ) internal pure returns (uint256) {
400         require(b != 0, errorMessage);
401         return a % b;
402     }
403 }
404 
405 // File: oz/utils/Address.sol
406 
407 pragma solidity ^0.5.5;
408 
409 /**
410  * @dev Collection of functions related to the address type
411  */
412 library Address {
413     /**
414      * @dev Returns true if `account` is a contract.
415      *
416      * [IMPORTANT]
417      * ====
418      * It is unsafe to assume that an address for which this function returns
419      * false is an externally-owned account (EOA) and not a contract.
420      *
421      * Among others, `isContract` will return false for the following
422      * types of addresses:
423      *
424      *  - an externally-owned account
425      *  - a contract in construction
426      *  - an address where a contract will be created
427      *  - an address where a contract lived, but was destroyed
428      * ====
429      */
430     function isContract(address account) internal view returns (bool) {
431         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
432         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
433         // for accounts without code, i.e. `keccak256('')`
434         bytes32 codehash;
435 
436         bytes32 accountHash =
437             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
438         // solhint-disable-next-line no-inline-assembly
439         assembly {
440             codehash := extcodehash(account)
441         }
442         return (codehash != accountHash && codehash != 0x0);
443     }
444 
445     /**
446      * @dev Converts an `address` into `address payable`. Note that this is
447      * simply a type cast: the actual underlying value is not changed.
448      *
449      * _Available since v2.4.0._
450      */
451     function toPayable(address account)
452         internal
453         pure
454         returns (address payable)
455     {
456         return address(uint160(account));
457     }
458 
459     /**
460      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
461      * `recipient`, forwarding all available gas and reverting on errors.
462      *
463      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
464      * of certain opcodes, possibly making contracts go over the 2300 gas limit
465      * imposed by `transfer`, making them unable to receive funds via
466      * `transfer`. {sendValue} removes this limitation.
467      *
468      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
469      *
470      * IMPORTANT: because control is transferred to `recipient`, care must be
471      * taken to not create reentrancy vulnerabilities. Consider using
472      * {ReentrancyGuard} or the
473      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
474      *
475      * _Available since v2.4.0._
476      */
477     function sendValue(address payable recipient, uint256 amount) internal {
478         require(
479             address(this).balance >= amount,
480             "Address: insufficient balance"
481         );
482 
483         // solhint-disable-next-line avoid-call-value
484         (bool success, ) = recipient.call.value(amount)("");
485         require(
486             success,
487             "Address: unable to send value, recipient may have reverted"
488         );
489     }
490 }
491 
492 // File: oz/token/ERC20/SafeERC20.sol
493 
494 pragma solidity ^0.5.0;
495 
496 /**
497  * @title SafeERC20
498  * @dev Wrappers around ERC20 operations that throw on failure (when the token
499  * contract returns false). Tokens that return no value (and instead revert or
500  * throw on failure) are also supported, non-reverting calls are assumed to be
501  * successful.
502  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
503  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
504  */
505 library SafeERC20 {
506     using SafeMath for uint256;
507     using Address for address;
508 
509     function safeTransfer(
510         IERC20 token,
511         address to,
512         uint256 value
513     ) internal {
514         callOptionalReturn(
515             token,
516             abi.encodeWithSelector(token.transfer.selector, to, value)
517         );
518     }
519 
520     function safeTransferFrom(
521         IERC20 token,
522         address from,
523         address to,
524         uint256 value
525     ) internal {
526         callOptionalReturn(
527             token,
528             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
529         );
530     }
531 
532     function safeApprove(
533         IERC20 token,
534         address spender,
535         uint256 value
536     ) internal {
537         // safeApprove should only be called when setting an initial allowance,
538         // or when resetting it to zero. To increase and decrease it, use
539         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
540         // solhint-disable-next-line max-line-length
541         require(
542             (value == 0) || (token.allowance(address(this), spender) == 0),
543             "SafeERC20: approve from non-zero to non-zero allowance"
544         );
545         callOptionalReturn(
546             token,
547             abi.encodeWithSelector(token.approve.selector, spender, value)
548         );
549     }
550 
551     function safeIncreaseAllowance(
552         IERC20 token,
553         address spender,
554         uint256 value
555     ) internal {
556         uint256 newAllowance =
557             token.allowance(address(this), spender).add(value);
558         callOptionalReturn(
559             token,
560             abi.encodeWithSelector(
561                 token.approve.selector,
562                 spender,
563                 newAllowance
564             )
565         );
566     }
567 
568     function safeDecreaseAllowance(
569         IERC20 token,
570         address spender,
571         uint256 value
572     ) internal {
573         uint256 newAllowance =
574             token.allowance(address(this), spender).sub(
575                 value,
576                 "SafeERC20: decreased allowance below zero"
577             );
578         callOptionalReturn(
579             token,
580             abi.encodeWithSelector(
581                 token.approve.selector,
582                 spender,
583                 newAllowance
584             )
585         );
586     }
587 
588     /**
589      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
590      * on the return value: the return value is optional (but if data is returned, it must not be false).
591      * @param token The token targeted by the call.
592      * @param data The call data (encoded using abi.encode or one of its variants).
593      */
594     function callOptionalReturn(IERC20 token, bytes memory data) private {
595         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
596         // we're implementing it ourselves.
597 
598         // A Solidity high level call has three parts:
599         //  1. The target address is checked to verify it contains contract code
600         //  2. The call itself is made, and success asserted
601         //  3. The return value is decoded, which in turn checks the size of the returned data.
602         // solhint-disable-next-line max-line-length
603         require(address(token).isContract(), "SafeERC20: call to non-contract");
604 
605         // solhint-disable-next-line avoid-low-level-calls
606         (bool success, bytes memory returndata) = address(token).call(data);
607         require(success, "SafeERC20: low-level call failed");
608 
609         if (returndata.length > 0) {
610             // Return data is optional
611             // solhint-disable-next-line max-line-length
612             require(
613                 abi.decode(returndata, (bool)),
614                 "SafeERC20: ERC20 operation did not succeed"
615             );
616         }
617     }
618 }
619 
620 // File: contracts/yEarn/yvBoost_Migrator_V1.sol
621 
622 pragma solidity ^0.5.7;
623 
624 interface IPickleJar {
625     function token() external view returns (address);
626 
627     function withdraw(uint256 _shares) external;
628 
629     function getRatio() external view returns (uint256);
630 
631     function deposit(uint256 amount) external;
632 }
633 
634 interface IUniswapV2Router02 {
635     function WETH() external pure returns (address);
636 
637     function removeLiquidity(
638         address tokenA,
639         address tokenB,
640         uint256 liquidity,
641         uint256 amountAMin,
642         uint256 amountBMin,
643         address to,
644         uint256 deadline
645     ) external returns (uint256 amountA, uint256 amountB);
646 
647     function addLiquidity(
648         address tokenA,
649         address tokenB,
650         uint256 amountADesired,
651         uint256 amountBDesired,
652         uint256 amountAMin,
653         uint256 amountBMin,
654         address to,
655         uint256 deadline
656     )
657         external
658         returns (
659             uint256 amountA,
660             uint256 amountB,
661             uint256 liquidity
662         );
663 }
664 
665 interface IUniswapV2Pair {
666     function token0() external pure returns (address);
667 
668     function token1() external pure returns (address);
669 
670     function getReserves()
671         external
672         view
673         returns (
674             uint112 _reserve0,
675             uint112 _reserve1,
676             uint32 _blockTimestampLast
677         );
678 }
679 
680 interface IYearnZapIn {
681     function ZapIn(
682         address fromToken,
683         uint256 amountIn,
684         address toVault,
685         address superVault,
686         bool isAaveUnderlying,
687         uint256 minYVTokens,
688         address intermediateToken,
689         address swapTarget,
690         bytes calldata swapData,
691         address affiliate
692     ) external payable returns (uint256 yvBoostRec);
693 }
694 
695 contract yvBoost_Migrator_V1_0_1 is Ownable {
696     using SafeMath for uint256;
697     using SafeERC20 for IERC20;
698     bool public stopped = false;
699 
700     address constant yveCRV_ETH_Sushi =
701         0x10B47177E92Ef9D5C6059055d92DdF6290848991;
702     address constant yveCRV_ETH_pJar =
703         0x5Eff6d166D66BacBC1BF52E2C54dD391AE6b1f48;
704 
705     address constant yvBOOST_ETH_Sushi =
706         0x9461173740D27311b176476FA27e94C681b1Ea6b;
707     address constant yvBOOST_ETH_pJar =
708         0xCeD67a187b923F0E5ebcc77C7f2F7da20099e378;
709 
710     address constant yveCRV = 0xc5bDdf9843308380375a611c18B50Fb9341f502A;
711 
712     address constant yvBOOST = 0x9d409a0A012CFbA9B15F6D4B36Ac57A46966Ab9a;
713 
714     IUniswapV2Router02 private constant sushiSwapRouter =
715         IUniswapV2Router02(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);
716 
717     uint256 private constant deadline =
718         0xf000000000000000000000000000000000000000000000000000000000000000;
719 
720     IYearnZapIn yearnZapIn;
721 
722     constructor(address _yearnZapIn) public {
723         yearnZapIn = IYearnZapIn(_yearnZapIn);
724     }
725 
726     // circuit breaker modifiers
727     modifier stopInEmergency {
728         if (stopped) {
729             revert("Temporarily Paused");
730         } else {
731             _;
732         }
733     }
734 
735     /**
736     @notice This function migrates pTokens from pSushi yveCRV-ETH to pSushi yveBOOST-ETH 
737     @param IncomingLP Quantity of pSushi yveCRV-ETH tokens to migrate
738     @param minPTokens The minimum acceptable quantity vault tokens to receive. Reverts otherwise
739     @return pTokensRec- Quantity of pSushi yveBOOST-ETH tokens acquired
740      */
741     function Migrate(uint256 IncomingLP, uint256 minPTokens)
742         external
743         stopInEmergency
744         returns (uint256 pTokensRec)
745     {
746         IERC20(yveCRV_ETH_pJar).safeTransferFrom(
747             msg.sender,
748             address(this),
749             IncomingLP
750         );
751 
752         uint256 underlyingReceived = _jarWithdraw(yveCRV_ETH_pJar, IncomingLP);
753 
754         (uint256 amountA, uint256 amountB, address tokenA, ) =
755             _sushiWithdraw(underlyingReceived);
756 
757         uint256 wethRec = tokenA == yveCRV ? amountB : amountA;
758 
759         uint256 yvBoostRec =
760             _yearnDeposit(tokenA == yveCRV ? amountA : amountB);
761 
762         IUniswapV2Pair pair = IUniswapV2Pair(yvBOOST_ETH_Sushi);
763 
764         uint256 token0Amt = pair.token0() == yvBOOST ? yvBoostRec : wethRec;
765         uint256 token1Amt = pair.token1() == yvBOOST ? yvBoostRec : wethRec;
766 
767         uint256 sushiLpRec =
768             _sushiDeposit(pair.token0(), pair.token1(), token0Amt, token1Amt);
769 
770         pTokensRec = _jarDeposit(sushiLpRec);
771 
772         require(pTokensRec >= minPTokens, "ERR: High Slippage");
773 
774         IERC20(yvBOOST_ETH_pJar).transfer(msg.sender, pTokensRec);
775     }
776 
777     function _jarWithdraw(address fromJar, uint256 amount)
778         internal
779         returns (uint256 underlyingReceived)
780     {
781         uint256 iniUnderlyingBal = _getBalance(yveCRV_ETH_Sushi);
782         IPickleJar(fromJar).withdraw(amount);
783         underlyingReceived = _getBalance(yveCRV_ETH_Sushi).sub(
784             iniUnderlyingBal
785         );
786     }
787 
788     function _jarDeposit(uint256 amount)
789         internal
790         returns (uint256 pTokensReceived)
791     {
792         _approveToken(yvBOOST_ETH_Sushi, yvBOOST_ETH_pJar, amount);
793 
794         uint256 iniYVaultBal = _getBalance(yvBOOST_ETH_pJar);
795 
796         IPickleJar(yvBOOST_ETH_pJar).deposit(amount);
797 
798         pTokensReceived = _getBalance(yvBOOST_ETH_pJar).sub(iniYVaultBal);
799     }
800 
801     function _yearnDeposit(uint256 amountIn)
802         internal
803         returns (uint256 yvBoostRec)
804     {
805         _approveToken(yveCRV, address(yearnZapIn), amountIn);
806 
807         yvBoostRec = yearnZapIn.ZapIn(
808             yveCRV,
809             amountIn,
810             yvBOOST,
811             address(0),
812             false,
813             0,
814             yveCRV,
815             address(0),
816             "",
817             address(0)
818         );
819     }
820 
821     function _sushiWithdraw(uint256 IncomingLP)
822         internal
823         returns (
824             uint256 amountA,
825             uint256 amountB,
826             address tokenA,
827             address tokenB
828         )
829     {
830         _approveToken(yveCRV_ETH_Sushi, address(sushiSwapRouter), IncomingLP);
831 
832         IUniswapV2Pair pair = IUniswapV2Pair(yveCRV_ETH_Sushi);
833 
834         address token0 = pair.token0();
835         address token1 = pair.token1();
836         (amountA, amountB) = sushiSwapRouter.removeLiquidity(
837             token0,
838             token1,
839             IncomingLP,
840             1,
841             1,
842             address(this),
843             deadline
844         );
845         return (amountA, amountB, tokenA, tokenB);
846     }
847 
848     function _sushiDeposit(
849         address toUnipoolToken0,
850         address toUnipoolToken1,
851         uint256 token0Bought,
852         uint256 token1Bought
853     ) internal returns (uint256) {
854         _approveToken(toUnipoolToken0, address(sushiSwapRouter), token0Bought);
855         _approveToken(toUnipoolToken1, address(sushiSwapRouter), token1Bought);
856 
857         (uint256 amountA, uint256 amountB, uint256 LP) =
858             sushiSwapRouter.addLiquidity(
859                 toUnipoolToken0,
860                 toUnipoolToken1,
861                 token0Bought,
862                 token1Bought,
863                 1,
864                 1,
865                 address(this),
866                 deadline
867             );
868 
869         //Returning Residue in token0, if any
870         if (token0Bought.sub(amountA) > 0) {
871             IERC20(toUnipoolToken0).safeTransfer(
872                 msg.sender,
873                 token0Bought.sub(amountA)
874             );
875         }
876 
877         //Returning Residue in token1, if any
878         if (token1Bought.sub(amountB) > 0) {
879             IERC20(toUnipoolToken1).safeTransfer(
880                 msg.sender,
881                 token1Bought.sub(amountB)
882             );
883         }
884 
885         return LP;
886     }
887 
888     function _getBalance(address token)
889         internal
890         view
891         returns (uint256 balance)
892     {
893         if (token == address(0)) {
894             balance = address(this).balance;
895         } else {
896             balance = IERC20(token).balanceOf(address(this));
897         }
898     }
899 
900     function _approveToken(
901         address token,
902         address spender,
903         uint256 amount
904     ) internal {
905         IERC20 _token = IERC20(token);
906         _token.safeApprove(spender, 0);
907         _token.safeApprove(spender, amount);
908     }
909 
910     function withdrawTokens(address[] calldata tokens) external onlyOwner {
911         for (uint256 i = 0; i < tokens.length; i++) {
912             uint256 qty;
913 
914             if (tokens[i] == address(0)) {
915                 qty = address(this).balance;
916                 Address.sendValue(Address.toPayable(owner()), qty);
917             } else {
918                 qty = IERC20(tokens[i]).balanceOf(address(this));
919                 IERC20(tokens[i]).safeTransfer(owner(), qty);
920             }
921         }
922     }
923 
924     function updateYearnZapIn(address _yearnZapIn) external onlyOwner {
925         yearnZapIn = IYearnZapIn(_yearnZapIn);
926     }
927 
928     // - to Pause the contract
929     function toggleContractActive() public onlyOwner {
930         stopped = !stopped;
931     }
932 }