1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper, nodar, suhail, seb, sumit, apoorv
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
21 ///@notice This contract adds/removes liquidity to/from yEarn Vaults using ETH or ERC20 Tokens.
22 // SPDX-License-Identifier: GPLv2
23 
24 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
25 
26 pragma solidity ^0.6.0;
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations with added overflow
30  * checks.
31  *
32  * Arithmetic operations in Solidity wrap on overflow. This can easily result
33  * in bugs, because programmers usually assume that an overflow raises an
34  * error, which is the standard behavior in high level programming languages.
35  * `SafeMath` restores this intuition by reverting the transaction when an
36  * operation overflows.
37  *
38  * Using this library instead of the unchecked operations eliminates an entire
39  * class of bugs, so it's recommended to use it always.
40  */
41 library SafeMath {
42     /**
43      * @dev Returns the addition of two unsigned integers, reverting on
44      * overflow.
45      *
46      * Counterpart to Solidity's `+` operator.
47      *
48      * Requirements:
49      *
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      *
67      * - Subtraction cannot overflow.
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      *
81      * - Subtraction cannot overflow.
82      */
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the multiplication of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `*` operator.
99      *
100      * Requirements:
101      *
102      * - Multiplication cannot overflow.
103      */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      *
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator. Note: this function uses a
139      * `revert` opcode (which leaves remaining gas untouched) while Solidity
140      * uses an invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function div(
147         uint256 a,
148         uint256 b,
149         string memory errorMessage
150     ) internal pure returns (uint256) {
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return mod(a, b, "SafeMath: modulo by zero");
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
176      * Reverts with custom message when dividing by zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function mod(
187         uint256 a,
188         uint256 b,
189         string memory errorMessage
190     ) internal pure returns (uint256) {
191         require(b != 0, errorMessage);
192         return a % b;
193     }
194 }
195 
196 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol
197 
198 pragma solidity ^0.6.0;
199 
200 /**
201  * @dev Contract module that helps prevent reentrant calls to a function.
202  *
203  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
204  * available, which can be applied to functions to make sure there are no nested
205  * (reentrant) calls to them.
206  *
207  * Note that because there is a single `nonReentrant` guard, functions marked as
208  * `nonReentrant` may not call one another. This can be worked around by making
209  * those functions `private`, and then adding `external` `nonReentrant` entry
210  * points to them.
211  *
212  * TIP: If you would like to learn more about reentrancy and alternative ways
213  * to protect against it, check out our blog post
214  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
215  */
216 contract ReentrancyGuard {
217     // Booleans are more expensive than uint256 or any type that takes up a full
218     // word because each write operation emits an extra SLOAD to first read the
219     // slot's contents, replace the bits taken up by the boolean, and then write
220     // back. This is the compiler's defense against contract upgrades and
221     // pointer aliasing, and it cannot be disabled.
222 
223     // The values being non-zero value makes deployment a bit more expensive,
224     // but in exchange the refund on every call to nonReentrant will be lower in
225     // amount. Since refunds are capped to a percentage of the total
226     // transaction's gas, it is best to keep them low in cases like this one, to
227     // increase the likelihood of the full refund coming into effect.
228     uint256 private constant _NOT_ENTERED = 1;
229     uint256 private constant _ENTERED = 2;
230 
231     uint256 private _status;
232 
233     constructor() internal {
234         _status = _NOT_ENTERED;
235     }
236 
237     /**
238      * @dev Prevents a contract from calling itself, directly or indirectly.
239      * Calling a `nonReentrant` function from another `nonReentrant`
240      * function is not supported. It is possible to prevent this from happening
241      * by making the `nonReentrant` function external, and make it call a
242      * `private` function that does the actual work.
243      */
244     modifier nonReentrant() {
245         // On the first call to nonReentrant, _notEntered will be true
246         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
247 
248         // Any calls to nonReentrant after this point will fail
249         _status = _ENTERED;
250 
251         _;
252 
253         // By storing the original value once again, a refund is triggered (see
254         // https://eips.ethereum.org/EIPS/eip-2200)
255         _status = _NOT_ENTERED;
256     }
257 }
258 
259 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
260 
261 pragma solidity ^0.6.0;
262 
263 /**
264  * @dev Interface of the ERC20 standard as defined in the EIP.
265  */
266 interface IERC20 {
267     /**
268      * @dev Returns the amount of tokens in existence.
269      */
270     function totalSupply() external view returns (uint256);
271 
272     /**
273      * @dev Returns the amount of tokens owned by `account`.
274      */
275     function balanceOf(address account) external view returns (uint256);
276 
277     /**
278      * @dev Moves `amount` tokens from the caller's account to `recipient`.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transfer(address recipient, uint256 amount)
285         external
286         returns (bool);
287 
288     /**
289      * @dev Returns the remaining number of tokens that `spender` will be
290      * allowed to spend on behalf of `owner` through {transferFrom}. This is
291      * zero by default.
292      *
293      * This value changes when {approve} or {transferFrom} are called.
294      */
295     function allowance(address owner, address spender)
296         external
297         view
298         returns (uint256);
299 
300     /**
301      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * IMPORTANT: Beware that changing an allowance with this method brings the risk
306      * that someone may use both the old and the new allowance by unfortunate
307      * transaction ordering. One possible solution to mitigate this race
308      * condition is to first reduce the spender's allowance to 0 and set the
309      * desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      *
312      * Emits an {Approval} event.
313      */
314     function approve(address spender, uint256 amount) external returns (bool);
315 
316     /**
317      * @dev Moves `amount` tokens from `sender` to `recipient` using the
318      * allowance mechanism. `amount` is then deducted from the caller's
319      * allowance.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transferFrom(
326         address sender,
327         address recipient,
328         uint256 amount
329     ) external returns (bool);
330 
331     /**
332      * @dev Emitted when `value` tokens are moved from one account (`from`) to
333      * another (`to`).
334      *
335      * Note that `value` may be zero.
336      */
337     event Transfer(address indexed from, address indexed to, uint256 value);
338 
339     /**
340      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
341      * a call to {approve}. `value` is the new allowance.
342      */
343     event Approval(
344         address indexed owner,
345         address indexed spender,
346         uint256 value
347     );
348 }
349 
350 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
351 
352 pragma solidity ^0.6.2;
353 
354 /**
355  * @dev Collection of functions related to the address type
356  */
357 library Address {
358     /**
359      * @dev Returns true if `account` is a contract.
360      *
361      * [IMPORTANT]
362      * ====
363      * It is unsafe to assume that an address for which this function returns
364      * false is an externally-owned account (EOA) and not a contract.
365      *
366      * Among others, `isContract` will return false for the following
367      * types of addresses:
368      *
369      *  - an externally-owned account
370      *  - a contract in construction
371      *  - an address where a contract will be created
372      *  - an address where a contract lived, but was destroyed
373      * ====
374      */
375     function isContract(address account) internal view returns (bool) {
376         // This method relies in extcodesize, which returns 0 for contracts in
377         // construction, since the code is only stored at the end of the
378         // constructor execution.
379 
380         uint256 size;
381         // solhint-disable-next-line no-inline-assembly
382         assembly {
383             size := extcodesize(account)
384         }
385         return size > 0;
386     }
387 
388     /**
389      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
390      * `recipient`, forwarding all available gas and reverting on errors.
391      *
392      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
393      * of certain opcodes, possibly making contracts go over the 2300 gas limit
394      * imposed by `transfer`, making them unable to receive funds via
395      * `transfer`. {sendValue} removes this limitation.
396      *
397      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
398      *
399      * IMPORTANT: because control is transferred to `recipient`, care must be
400      * taken to not create reentrancy vulnerabilities. Consider using
401      * {ReentrancyGuard} or the
402      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
403      */
404     function sendValue(address payable recipient, uint256 amount) internal {
405         require(
406             address(this).balance >= amount,
407             "Address: insufficient balance"
408         );
409 
410         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
411         (bool success, ) = recipient.call{value: amount}("");
412         require(
413             success,
414             "Address: unable to send value, recipient may have reverted"
415         );
416     }
417 
418     /**
419      * @dev Performs a Solidity function call using a low level `call`. A
420      * plain`call` is an unsafe replacement for a function call: use this
421      * function instead.
422      *
423      * If `target` reverts with a revert reason, it is bubbled up by this
424      * function (like regular Solidity function calls).
425      *
426      * Returns the raw returned data. To convert to the expected return value,
427      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
428      *
429      * Requirements:
430      *
431      * - `target` must be a contract.
432      * - calling `target` with `data` must not revert.
433      *
434      * _Available since v3.1._
435      */
436     function functionCall(address target, bytes memory data)
437         internal
438         returns (bytes memory)
439     {
440         return functionCall(target, data, "Address: low-level call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
445      * `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         return _functionCallWithValue(target, data, 0, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but also transferring `value` wei to `target`.
460      *
461      * Requirements:
462      *
463      * - the calling contract must have an ETH balance of at least `value`.
464      * - the called Solidity function must be `payable`.
465      *
466      * _Available since v3.1._
467      */
468     function functionCallWithValue(
469         address target,
470         bytes memory data,
471         uint256 value
472     ) internal returns (bytes memory) {
473         return
474             functionCallWithValue(
475                 target,
476                 data,
477                 value,
478                 "Address: low-level call with value failed"
479             );
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
484      * with `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCallWithValue(
489         address target,
490         bytes memory data,
491         uint256 value,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(
495             address(this).balance >= value,
496             "Address: insufficient balance for call"
497         );
498         return _functionCallWithValue(target, data, value, errorMessage);
499     }
500 
501     function _functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 weiValue,
505         string memory errorMessage
506     ) private returns (bytes memory) {
507         require(isContract(target), "Address: call to non-contract");
508 
509         // solhint-disable-next-line avoid-low-level-calls
510         (bool success, bytes memory returndata) = target.call{value: weiValue}(
511             data
512         );
513         if (success) {
514             return returndata;
515         } else {
516             // Look for revert reason and bubble it up if present
517             if (returndata.length > 0) {
518                 // The easiest way to bubble the revert reason is using memory via assembly
519 
520                 // solhint-disable-next-line no-inline-assembly
521                 assembly {
522                     let returndata_size := mload(returndata)
523                     revert(add(32, returndata), returndata_size)
524                 }
525             } else {
526                 revert(errorMessage);
527             }
528         }
529     }
530 }
531 
532 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
533 
534 pragma solidity ^0.6.0;
535 
536 /*
537  * @dev Provides information about the current execution context, including the
538  * sender of the transaction and its data. While these are generally available
539  * via msg.sender and msg.data, they should not be accessed in such a direct
540  * manner, since when dealing with GSN meta-transactions the account sending and
541  * paying for execution may not be the actual sender (as far as an application
542  * is concerned).
543  *
544  * This contract is only required for intermediate, library-like contracts.
545  */
546 abstract contract Context {
547     function _msgSender() internal virtual view returns (address payable) {
548         return msg.sender;
549     }
550 
551     function _msgData() internal virtual view returns (bytes memory) {
552         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
553         return msg.data;
554     }
555 }
556 
557 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
558 
559 pragma solidity ^0.6.0;
560 
561 /**
562  * @dev Contract module which provides a basic access control mechanism, where
563  * there is an account (an owner) that can be granted exclusive access to
564  * specific functions.
565  *
566  * By default, the owner account will be the one that deploys the contract. This
567  * can later be changed with {transferOwnership}.
568  *
569  * This module is used through inheritance. It will make available the modifier
570  * `onlyOwner`, which can be applied to your functions to restrict their use to
571  * the owner.
572  */
573 contract Ownable is Context {
574     address private _owner;
575 
576     event OwnershipTransferred(
577         address indexed previousOwner,
578         address indexed newOwner
579     );
580 
581     /**
582      * @dev Initializes the contract setting the deployer as the initial owner.
583      */
584     constructor() internal {
585         address msgSender = _msgSender();
586         _owner = msgSender;
587         emit OwnershipTransferred(address(0), msgSender);
588     }
589 
590     /**
591      * @dev Returns the address of the current owner.
592      */
593     function owner() public view returns (address) {
594         return _owner;
595     }
596 
597     /**
598      * @dev Throws if called by any account other than the owner.
599      */
600     modifier onlyOwner() {
601         require(_owner == _msgSender(), "Ownable: caller is not the owner");
602         _;
603     }
604 
605     /**
606      * @dev Leaves the contract without owner. It will not be possible to call
607      * `onlyOwner` functions anymore. Can only be called by the current owner.
608      *
609      * NOTE: Renouncing ownership will leave the contract without an owner,
610      * thereby removing any functionality that is only available to the owner.
611      */
612     function renounceOwnership() public virtual onlyOwner {
613         emit OwnershipTransferred(_owner, address(0));
614         _owner = address(0);
615     }
616 
617     /**
618      * @dev Transfers ownership of the contract to a new account (`newOwner`).
619      * Can only be called by the current owner.
620      */
621     function transferOwnership(address newOwner) public virtual onlyOwner {
622         require(
623             newOwner != address(0),
624             "Ownable: new owner is the zero address"
625         );
626         emit OwnershipTransferred(_owner, newOwner);
627         _owner = newOwner;
628     }
629 }
630 
631 // File: yVault_ZapInOut_General_V1_1.sol
632 
633 pragma solidity ^0.6.0;
634 
635 library TransferHelper {
636     function safeApprove(
637         address token,
638         address to,
639         uint256 value
640     ) internal {
641         // bytes4(keccak256(bytes('approve(address,uint256)')));
642         (bool success, bytes memory data) = token.call(
643             abi.encodeWithSelector(0x095ea7b3, to, value)
644         );
645         require(
646             success && (data.length == 0 || abi.decode(data, (bool))),
647             "TransferHelper: APPROVE_FAILED"
648         );
649     }
650 
651     function safeTransfer(
652         address token,
653         address to,
654         uint256 value
655     ) internal {
656         // bytes4(keccak256(bytes('transfer(address,uint256)')));
657         (bool success, bytes memory data) = token.call(
658             abi.encodeWithSelector(0xa9059cbb, to, value)
659         );
660         require(
661             success && (data.length == 0 || abi.decode(data, (bool))),
662             "TransferHelper: TRANSFER_FAILED"
663         );
664     }
665 
666     function safeTransferFrom(
667         address token,
668         address from,
669         address to,
670         uint256 value
671     ) internal {
672         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
673         (bool success, bytes memory data) = token.call(
674             abi.encodeWithSelector(0x23b872dd, from, to, value)
675         );
676         require(
677             success && (data.length == 0 || abi.decode(data, (bool))),
678             "TransferHelper: TRANSFER_FROM_FAILED"
679         );
680     }
681 }
682 
683 interface IUniswapV2Factory {
684     function getPair(address tokenA, address tokenB)
685         external
686         view
687         returns (address);
688 }
689 
690 interface IUniswapRouter02 {
691     //get estimated amountOut
692     function getAmountsOut(uint256 amountIn, address[] calldata path)
693         external
694         view
695         returns (uint256[] memory amounts);
696 
697     function getAmountsIn(uint256 amountOut, address[] calldata path)
698         external
699         view
700         returns (uint256[] memory amounts);
701 
702     //token 2 token
703     function swapExactTokensForTokens(
704         uint256 amountIn,
705         uint256 amountOutMin,
706         address[] calldata path,
707         address to,
708         uint256 deadline
709     ) external returns (uint256[] memory amounts);
710 
711     function swapTokensForExactTokens(
712         uint256 amountOut,
713         uint256 amountInMax,
714         address[] calldata path,
715         address to,
716         uint256 deadline
717     ) external returns (uint256[] memory amounts);
718 
719     //eth 2 token
720     function swapExactETHForTokens(
721         uint256 amountOutMin,
722         address[] calldata path,
723         address to,
724         uint256 deadline
725     ) external payable returns (uint256[] memory amounts);
726 
727     function swapETHForExactTokens(
728         uint256 amountOut,
729         address[] calldata path,
730         address to,
731         uint256 deadline
732     ) external payable returns (uint256[] memory amounts);
733 
734     //token 2 eth
735     function swapTokensForExactETH(
736         uint256 amountOut,
737         uint256 amountInMax,
738         address[] calldata path,
739         address to,
740         uint256 deadline
741     ) external returns (uint256[] memory amounts);
742 
743     function swapExactTokensForETH(
744         uint256 amountIn,
745         uint256 amountOutMin,
746         address[] calldata path,
747         address to,
748         uint256 deadline
749     ) external returns (uint256[] memory amounts);
750 }
751 
752 interface yVault {
753     function deposit(uint256) external;
754 
755     function withdraw(uint256) external;
756 
757     function getPricePerFullShare() external view returns (uint256);
758 
759     function token() external view returns (address);
760 }
761 
762 interface ICurveZapInGeneral {
763     function ZapIn(
764         address _toWhomToIssue,
765         address _IncomingTokenAddress,
766         address _curvePoolExchangeAddress,
767         uint256 _IncomingTokenQty,
768         uint256 _minPoolTokens
769     ) external payable returns (uint256 crvTokensBought);
770 }
771 
772 interface IAaveLendingPoolAddressesProvider {
773     function getLendingPool() external view returns (address);
774 
775     function getLendingPoolCore() external view returns (address payable);
776 }
777 
778 interface IAaveLendingPool {
779     function deposit(
780         address _reserve,
781         uint256 _amount,
782         uint16 _referralCode
783     ) external payable;
784 }
785 
786 interface IAToken {
787     function redeem(uint256 _amount) external;
788 
789     function underlyingAssetAddress() external returns (address);
790 }
791 
792 contract yVault_ZapInOut_General_V1_1 is ReentrancyGuard, Ownable {
793     using SafeMath for uint256;
794     using Address for address;
795     bool public stopped = false;
796     uint16 public goodwill;
797 
798     IUniswapV2Factory
799         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
800         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
801     );
802     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
803         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
804     );
805 
806     ICurveZapInGeneral public CurveZapInGeneral = ICurveZapInGeneral(
807         0x456974dF1042bA7A46FD49512A8778Ac3B840A21
808     );
809     IAaveLendingPoolAddressesProvider
810         private constant lendingPoolAddressProvider = IAaveLendingPoolAddressesProvider(
811         0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
812     );
813 
814     address
815         private yCurveExchangeAddress = 0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3;
816     address
817         private constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
818     address
819         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
820     address
821         private constant zgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
822 
823     uint256
824         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
825 
826     mapping(address => bytes32) public supportedVaults; // Address => Vault Name
827 
828     event Zapin(
829         address _toWhomToIssue,
830         address _toYVaultAddress,
831         uint256 _Outgoing
832     );
833 
834     event Zapout(
835         address _toWhomToIssue,
836         address _fromYVaultAddress,
837         address _toTokenAddress,
838         uint256 _tokensRecieved
839     );
840 
841     constructor(uint16 _goodwill) public {
842         goodwill = _goodwill;
843         // Initial supported vaults
844         supportedVaults[0x5dbcF33D8c2E976c6b560249878e6F1491Bca25c] = keccak256(
845             bytes("yCurveVault")
846         );
847         supportedVaults[0x597aD1e0c13Bfe8025993D9e79C69E1c0233522e] = keccak256(
848             bytes("yUsdcVault")
849         );
850         supportedVaults[0x881b06da56BB5675c54E4Ed311c21E54C5025298] = keccak256(
851             bytes("yLinkVault")
852         );
853         supportedVaults[0x29E240CFD7946BA20895a7a02eDb25C210f9f324] = keccak256(
854             bytes("yaLinkVault")
855         );
856         supportedVaults[0x37d19d1c4E1fa9DC47bD1eA12f742a0887eDa74a] = keccak256(
857             bytes("yTusdVault")
858         );
859         supportedVaults[0xACd43E627e64355f1861cEC6d3a6688B31a6F952] = keccak256(
860             bytes("yDaiVault")
861         );
862         supportedVaults[0x2f08119C6f07c006695E079AAFc638b8789FAf18] = keccak256(
863             bytes("yUsdtVault")
864         );
865     }
866 
867     // circuit breaker modifiers
868     modifier stopInEmergency {
869         if (stopped) {
870             revert("Temporarily Paused");
871         } else {
872             _;
873         }
874     }
875 
876     function updateCurveZapIn(address CurveZapInGeneralAddress)
877         public
878         onlyOwner
879     {
880         require(CurveZapInGeneralAddress != address(0), "Invalid Address");
881         CurveZapInGeneral = ICurveZapInGeneral(CurveZapInGeneralAddress);
882     }
883 
884     function addNewYVault(address _vaultAddress, string calldata _vaultName)
885         external
886         onlyOwner
887     {
888         require(_vaultAddress != address(0), "Invalid Address");
889         require(
890             supportedVaults[_vaultAddress] == "",
891             "Err: Vault Already Exists"
892         );
893 
894         supportedVaults[_vaultAddress] = keccak256(bytes(_vaultName));
895     }
896 
897     /**
898     @notice This function is used to add liquidity to yVaults
899     @param _toWhomToIssue recipient address
900     @param _toYVaultAddress The address of vault to add liquidity to
901     @param _vaultType Type of underlying token: 0 token; 1 aToken; 2 LP token
902     @param _fromTokenAddress The token used for investment (address(0x00) if ether)
903     @param _amount The amount of ERC to invest
904     @param _minTokensSwapped for slippage
905     @return yTokensRec
906      */
907     function ZapIn(
908         address _toWhomToIssue,
909         address _toYVaultAddress,
910         uint16 _vaultType,
911         address _fromTokenAddress,
912         uint256 _amount,
913         uint256 _minTokensSwapped
914     ) public payable nonReentrant stopInEmergency returns (uint256) {
915         require(
916             supportedVaults[_toYVaultAddress] != "",
917             "ERR: Unsupported Vault"
918         );
919 
920         yVault vaultToEnter = yVault(_toYVaultAddress);
921         address underlyingVaultToken = vaultToEnter.token();
922 
923         if (_fromTokenAddress == address(0)) {
924             require(msg.value > 0, "ERR: No ETH sent");
925         } else {
926             require(_amount > 0, "Err: No Tokens Sent");
927             require(msg.value == 0, "ERR: ETH sent with Token");
928 
929             TransferHelper.safeTransferFrom(
930                 _fromTokenAddress,
931                 msg.sender,
932                 address(this),
933                 _amount
934             );
935         }
936         if (underlyingVaultToken == _fromTokenAddress) {
937             IERC20(underlyingVaultToken).approve(
938                 address(vaultToEnter),
939                 _amount
940             );
941             vaultToEnter.deposit(_amount);
942         } else {
943             if (_vaultType == 2) {
944                 uint256 tokensBought;
945                 if (_fromTokenAddress == address(0)) {
946                     tokensBought = CurveZapInGeneral.ZapIn{value: msg.value}(
947                         address(this),
948                         address(0),
949                         yCurveExchangeAddress,
950                         msg.value,
951                         _minTokensSwapped
952                     );
953                 } else {
954                     IERC20(_fromTokenAddress).approve(
955                         address(CurveZapInGeneral),
956                         _amount
957                     );
958                     tokensBought = CurveZapInGeneral.ZapIn(
959                         address(this),
960                         _fromTokenAddress,
961                         yCurveExchangeAddress,
962                         _amount,
963                         _minTokensSwapped
964                     );
965                 }
966 
967                 IERC20(underlyingVaultToken).approve(
968                     address(vaultToEnter),
969                     tokensBought
970                 );
971                 vaultToEnter.deposit(tokensBought);
972             } else if (_vaultType == 1) {
973                 address underlyingAsset = IAToken(underlyingVaultToken)
974                     .underlyingAssetAddress();
975 
976                 uint256 tokensBought;
977                 if (_fromTokenAddress == address(0)) {
978                     tokensBought = _eth2Token(
979                         underlyingAsset,
980                         _minTokensSwapped
981                     );
982                 } else {
983                     tokensBought = _token2Token(
984                         _fromTokenAddress,
985                         underlyingAsset,
986                         _amount,
987                         _minTokensSwapped
988                     );
989                 }
990 
991                 IERC20(underlyingAsset).approve(
992                     lendingPoolAddressProvider.getLendingPoolCore(),
993                     tokensBought
994                 );
995 
996                 IAaveLendingPool(lendingPoolAddressProvider.getLendingPool())
997                     .deposit(underlyingAsset, tokensBought, 0);
998 
999                 uint256 aTokensBought = IERC20(underlyingVaultToken).balanceOf(
1000                     address(this)
1001                 );
1002                 IERC20(underlyingVaultToken).approve(
1003                     address(vaultToEnter),
1004                     aTokensBought
1005                 );
1006                 vaultToEnter.deposit(aTokensBought);
1007             } else {
1008                 uint256 tokensBought;
1009                 if (_fromTokenAddress == address(0)) {
1010                     tokensBought = _eth2Token(
1011                         underlyingVaultToken,
1012                         _minTokensSwapped
1013                     );
1014                 } else {
1015                     tokensBought = _token2Token(
1016                         _fromTokenAddress,
1017                         underlyingVaultToken,
1018                         _amount,
1019                         _minTokensSwapped
1020                     );
1021                 }
1022 
1023                 IERC20(underlyingVaultToken).approve(
1024                     address(vaultToEnter),
1025                     tokensBought
1026                 );
1027                 vaultToEnter.deposit(tokensBought);
1028             }
1029         }
1030 
1031         uint256 yTokensRec = IERC20(address(vaultToEnter)).balanceOf(
1032             address(this)
1033         );
1034 
1035         //transfer goodwill
1036         uint256 goodwillPortion = _transferGoodwill(
1037             zgoodwillAddress,
1038             yTokensRec
1039         );
1040 
1041         IERC20(address(vaultToEnter)).transfer(
1042             _toWhomToIssue,
1043             yTokensRec.sub(goodwillPortion)
1044         );
1045 
1046         emit Zapin(
1047             _toWhomToIssue,
1048             address(vaultToEnter),
1049             yTokensRec.sub(goodwillPortion)
1050         );
1051 
1052         return (yTokensRec.sub(goodwillPortion));
1053     }
1054 
1055     function ZapOutToUnderlying(
1056         address _toWhomToIssue,
1057         address _fromYVaultAddress,
1058         uint256 _amount
1059     ) public nonReentrant stopInEmergency returns (uint256) {
1060         yVault vaultToExit = yVault(_fromYVaultAddress);
1061         address underlyingVaultToken = vaultToExit.token();
1062 
1063         TransferHelper.safeTransferFrom(
1064             address(vaultToExit),
1065             msg.sender,
1066             address(this),
1067             _amount
1068         );
1069 
1070         vaultToExit.withdraw(_amount);
1071         uint256 underlyingReceived = IERC20(underlyingVaultToken).balanceOf(
1072             address(this)
1073         );
1074 
1075         //transfer goodwill
1076         uint256 goodwillPortion = _transferGoodwill(
1077             underlyingVaultToken,
1078             underlyingReceived
1079         );
1080 
1081         TransferHelper.safeTransfer(
1082             underlyingVaultToken,
1083             _toWhomToIssue,
1084             underlyingReceived.sub(goodwillPortion)
1085         );
1086 
1087         emit Zapout(
1088             _toWhomToIssue,
1089             _fromYVaultAddress,
1090             underlyingVaultToken,
1091             underlyingReceived.sub(goodwillPortion)
1092         );
1093         return (underlyingReceived.sub(goodwillPortion));
1094     }
1095 
1096     /**
1097     @notice This function is used to swap eth for tokens
1098     @param _tokenContractAddress Token address which we want to buy
1099     @param minTokens recieved after swap for slippage
1100     @return tokensBought The quantity of token bought
1101      */
1102     function _eth2Token(address _tokenContractAddress, uint256 minTokens)
1103         internal
1104         returns (uint256 tokensBought)
1105     {
1106         require(
1107             _tokenContractAddress != wethTokenAddress,
1108             "ERR: Invalid Swap to ETH"
1109         );
1110 
1111         address[] memory path = new address[](2);
1112         path[0] = wethTokenAddress;
1113         path[1] = _tokenContractAddress;
1114         tokensBought = uniswapRouter.swapExactETHForTokens{value: msg.value}(
1115             1,
1116             path,
1117             address(this),
1118             deadline
1119         )[path.length - 1];
1120         require(tokensBought >= minTokens, "ERR: High Slippage");
1121     }
1122 
1123     /**
1124     @notice This function is used to swap tokens
1125     @param _FromTokenContractAddress The token address to swap from
1126     @param _ToTokenContractAddress The token address to swap to
1127     @param tokens2Trade The amount of tokens to swap
1128     @param minTokens recieved after swap for slippage
1129     @return tokenBought The quantity of tokens bought
1130     */
1131     function _token2Token(
1132         address _FromTokenContractAddress,
1133         address _ToTokenContractAddress,
1134         uint256 tokens2Trade,
1135         uint256 minTokens
1136     ) internal returns (uint256 tokenBought) {
1137         if (_FromTokenContractAddress == _ToTokenContractAddress) {
1138             return tokens2Trade;
1139         }
1140 
1141         TransferHelper.safeApprove(
1142             _FromTokenContractAddress,
1143             address(uniswapRouter),
1144             tokens2Trade
1145         );
1146 
1147         if (_FromTokenContractAddress != wethTokenAddress) {
1148             if (_ToTokenContractAddress != wethTokenAddress) {
1149                 address[] memory path = new address[](3);
1150                 path[0] = _FromTokenContractAddress;
1151                 path[1] = wethTokenAddress;
1152                 path[2] = _ToTokenContractAddress;
1153                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1154                     tokens2Trade,
1155                     1,
1156                     path,
1157                     address(this),
1158                     deadline
1159                 )[path.length - 1];
1160             } else {
1161                 address[] memory path = new address[](2);
1162                 path[0] = _FromTokenContractAddress;
1163                 path[1] = wethTokenAddress;
1164 
1165                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1166                     tokens2Trade,
1167                     1,
1168                     path,
1169                     address(this),
1170                     deadline
1171                 )[path.length - 1];
1172             }
1173         } else {
1174             address[] memory path = new address[](2);
1175             path[0] = wethTokenAddress;
1176             path[1] = _ToTokenContractAddress;
1177             tokenBought = uniswapRouter.swapExactTokensForTokens(
1178                 tokens2Trade,
1179                 1,
1180                 path,
1181                 address(this),
1182                 deadline
1183             )[path.length - 1];
1184         }
1185 
1186         require(tokenBought > minTokens, "ERR: High Slippage");
1187     }
1188 
1189     /**
1190     @notice This function is used to calculate and transfer goodwill
1191     @param _tokenContractAddress Token in which goodwill is deducted
1192     @param tokens2Trade The total amount of tokens to be zapped in
1193     @return goodwillPortion The quantity of goodwill deducted
1194      */
1195     function _transferGoodwill(
1196         address _tokenContractAddress,
1197         uint256 tokens2Trade
1198     ) internal returns (uint256 goodwillPortion) {
1199         goodwillPortion = SafeMath.div(
1200             SafeMath.mul(tokens2Trade, goodwill),
1201             10000
1202         );
1203 
1204         if (goodwillPortion == 0) {
1205             return 0;
1206         }
1207 
1208         TransferHelper.safeTransfer(
1209             _tokenContractAddress,
1210             zgoodwillAddress,
1211             goodwillPortion
1212         );
1213     }
1214 
1215     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1216         require(
1217             _new_goodwill >= 0 && _new_goodwill < 10000,
1218             "GoodWill Value not allowed"
1219         );
1220         goodwill = _new_goodwill;
1221     }
1222 
1223     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1224         uint256 qty = _TokenAddress.balanceOf(address(this));
1225         TransferHelper.safeTransfer(address(_TokenAddress), owner(), qty);
1226     }
1227 
1228     // - to Pause the contract
1229     function toggleContractActive() public onlyOwner {
1230         stopped = !stopped;
1231     }
1232 
1233     // - to withdraw any ETH balance sitting in the contract
1234     function withdraw() public onlyOwner {
1235         uint256 contractBalance = address(this).balance;
1236         address payable _to = payable(owner());
1237         _to.transfer(contractBalance);
1238     }
1239 }