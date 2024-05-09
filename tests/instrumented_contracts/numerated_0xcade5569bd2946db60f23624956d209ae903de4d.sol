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
631 // File: yVault_ZapInOut_General_V1_2.sol
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
772 interface ICurveZapOutGeneral {
773     function ZapOut(
774         address payable _toWhomToIssue,
775         address _curveExchangeAddress,
776         uint256 _tokenCount,
777         uint256 _IncomingCRV,
778         address _ToTokenAddress,
779         uint256 _minToTokens
780     ) external returns (uint256 ToTokensBought);
781 }
782 
783 interface IAaveLendingPoolAddressesProvider {
784     function getLendingPool() external view returns (address);
785 
786     function getLendingPoolCore() external view returns (address payable);
787 }
788 
789 interface IAaveLendingPool {
790     function deposit(
791         address _reserve,
792         uint256 _amount,
793         uint16 _referralCode
794     ) external payable;
795 }
796 
797 interface IAToken {
798     function redeem(uint256 _amount) external;
799 
800     function underlyingAssetAddress() external returns (address);
801 }
802 
803 interface IWETH {
804     function deposit() external payable;
805 
806     function withdraw(uint256) external;
807 }
808 
809 contract yVault_ZapInOut_General_V1_2 is ReentrancyGuard, Ownable {
810     using SafeMath for uint256;
811     using Address for address;
812     bool public stopped = false;
813     uint16 public goodwill;
814 
815     IUniswapV2Factory
816         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
817         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
818     );
819     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
820         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
821     );
822 
823     ICurveZapInGeneral public CurveZapInGeneral = ICurveZapInGeneral(
824         0x456974dF1042bA7A46FD49512A8778Ac3B840A21
825     );
826     ICurveZapOutGeneral public CurveZapOutGeneral = ICurveZapOutGeneral(
827         0x4bF331Aa2BfB0869315fB81a350d109F4839f81b
828     );
829     
830     IAaveLendingPoolAddressesProvider
831         private constant lendingPoolAddressProvider = IAaveLendingPoolAddressesProvider(
832         0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
833     );
834 
835     address
836         private yCurveExchangeAddress = 0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3;
837     address
838         private constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
839     address
840         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
841     address
842         private constant zgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
843 
844     uint256
845         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
846 
847     event Zapin(
848         address _toWhomToIssue,
849         address _toYVaultAddress,
850         uint256 _Outgoing
851     );
852 
853     event Zapout(
854         address _toWhomToIssue,
855         address _fromYVaultAddress,
856         address _toTokenAddress,
857         uint256 _tokensRecieved
858     );
859 
860     constructor(uint16 _goodwill) public {
861         goodwill = _goodwill;
862     }
863 
864     // circuit breaker modifiers
865     modifier stopInEmergency {
866         if (stopped) {
867             revert("Temporarily Paused");
868         } else {
869             _;
870         }
871     }
872 
873     function updateCurveZapIn(address CurveZapInGeneralAddress)
874         public
875         onlyOwner
876     {
877         require(CurveZapInGeneralAddress != address(0), "Invalid Address");
878         CurveZapInGeneral = ICurveZapInGeneral(CurveZapInGeneralAddress);
879     }
880     
881     function updateCurveZapOut(address CurveZapOutGeneralAddress)
882         public
883         onlyOwner
884     {
885         require(CurveZapOutGeneralAddress != address(0), "Invalid Address");
886         CurveZapOutGeneral = ICurveZapOutGeneral(CurveZapOutGeneralAddress);
887     }
888 
889     /**
890     @notice This function is used to add liquidity to yVaults
891     @param _toWhomToIssue recipient address
892     @param _toYVaultAddress The address of vault to add liquidity to
893     @param _vaultType Type of underlying token: 0 token; 1 aToken; 2 LP token
894     @param _fromTokenAddress The token used for investment (address(0x00) if ether)
895     @param _amount The amount of ERC to invest
896     @param _minTokensSwapped for slippage
897     @return yTokensRec
898      */
899     function ZapIn(
900         address _toWhomToIssue,
901         address _toYVaultAddress,
902         uint16 _vaultType,
903         address _fromTokenAddress,
904         uint256 _amount,
905         uint256 _minTokensSwapped
906     ) public payable nonReentrant stopInEmergency returns (uint256) {
907         yVault vaultToEnter = yVault(_toYVaultAddress);
908         address underlyingVaultToken = vaultToEnter.token();
909 
910         if (_fromTokenAddress == address(0)) {
911             require(msg.value > 0, "ERR: No ETH sent");
912         } else {
913             require(_amount > 0, "Err: No Tokens Sent");
914             require(msg.value == 0, "ERR: ETH sent with Token");
915 
916             TransferHelper.safeTransferFrom(
917                 _fromTokenAddress,
918                 msg.sender,
919                 address(this),
920                 _amount
921             );
922         }
923         if (underlyingVaultToken == _fromTokenAddress) {
924             IERC20(underlyingVaultToken).approve(
925                 address(vaultToEnter),
926                 _amount
927             );
928             vaultToEnter.deposit(_amount);
929         } else {
930             if (_vaultType == 2) {
931                 uint256 tokensBought;
932                 if (_fromTokenAddress == address(0)) {
933                     tokensBought = CurveZapInGeneral.ZapIn{value: msg.value}(
934                         address(this),
935                         address(0),
936                         yCurveExchangeAddress,
937                         msg.value,
938                         _minTokensSwapped
939                     );
940                 } else {
941                     IERC20(_fromTokenAddress).approve(
942                         address(CurveZapInGeneral),
943                         _amount
944                     );
945                     tokensBought = CurveZapInGeneral.ZapIn(
946                         address(this),
947                         _fromTokenAddress,
948                         yCurveExchangeAddress,
949                         _amount,
950                         _minTokensSwapped
951                     );
952                 }
953 
954                 IERC20(underlyingVaultToken).approve(
955                     address(vaultToEnter),
956                     tokensBought
957                 );
958                 vaultToEnter.deposit(tokensBought);
959             } else if (_vaultType == 1) {
960                 address underlyingAsset = IAToken(underlyingVaultToken)
961                     .underlyingAssetAddress();
962 
963                 uint256 tokensBought;
964                 if (_fromTokenAddress == address(0)) {
965                     tokensBought = _eth2Token(
966                         underlyingAsset,
967                         _minTokensSwapped
968                     );
969                 } else {
970                     tokensBought = _token2Token(
971                         _fromTokenAddress,
972                         underlyingAsset,
973                         _amount,
974                         _minTokensSwapped
975                     );
976                 }
977 
978                 IERC20(underlyingAsset).approve(
979                     lendingPoolAddressProvider.getLendingPoolCore(),
980                     tokensBought
981                 );
982 
983                 IAaveLendingPool(lendingPoolAddressProvider.getLendingPool())
984                     .deposit(underlyingAsset, tokensBought, 0);
985 
986                 uint256 aTokensBought = IERC20(underlyingVaultToken).balanceOf(
987                     address(this)
988                 );
989                 IERC20(underlyingVaultToken).approve(
990                     address(vaultToEnter),
991                     aTokensBought
992                 );
993                 vaultToEnter.deposit(aTokensBought);
994             } else {
995                 uint256 tokensBought;
996                 if (_fromTokenAddress == address(0)) {
997                     tokensBought = _eth2Token(
998                         underlyingVaultToken,
999                         _minTokensSwapped
1000                     );
1001                 } else {
1002                     tokensBought = _token2Token(
1003                         _fromTokenAddress,
1004                         underlyingVaultToken,
1005                         _amount,
1006                         _minTokensSwapped
1007                     );
1008                 }
1009 
1010                 IERC20(underlyingVaultToken).approve(
1011                     address(vaultToEnter),
1012                     tokensBought
1013                 );
1014                 vaultToEnter.deposit(tokensBought);
1015             }
1016         }
1017 
1018         uint256 yTokensRec = IERC20(address(vaultToEnter)).balanceOf(
1019             address(this)
1020         );
1021 
1022         //transfer goodwill
1023         uint256 goodwillPortion = _transferGoodwill(
1024             address(vaultToEnter),
1025             yTokensRec
1026         );
1027 
1028         IERC20(address(vaultToEnter)).transfer(
1029             _toWhomToIssue,
1030             yTokensRec.sub(goodwillPortion)
1031         );
1032 
1033         emit Zapin(
1034             _toWhomToIssue,
1035             address(vaultToEnter),
1036             yTokensRec.sub(goodwillPortion)
1037         );
1038 
1039         return (yTokensRec.sub(goodwillPortion));
1040     }
1041 
1042       /**
1043     @notice This function is used to add liquidity to yVaults
1044     @param _toWhomToIssue recipient address
1045     @param _ToTokenContractAddress The address of the token to withdraw
1046     @param _fromYVaultAddress The address of the vault to exit
1047     @param _vaultType Type of underlying token: 0 token; 1 aToken; 2 LP token
1048     @param _IncomingAmt The amount of vault tokens removed
1049     @param _minTokensRec for slippage
1050     @return toTokensReceived
1051      */  
1052     function ZapOut(
1053         address _toWhomToIssue,
1054         address _ToTokenContractAddress,
1055         address _fromYVaultAddress,
1056         uint16 _vaultType,
1057         uint256 _IncomingAmt,
1058         uint256 _minTokensRec
1059     ) public nonReentrant stopInEmergency returns (uint256) {
1060         yVault vaultToExit = yVault(_fromYVaultAddress);
1061         address underlyingVaultToken = vaultToExit.token();
1062 
1063         TransferHelper.safeTransferFrom(
1064             address(vaultToExit),
1065             msg.sender,
1066             address(this),
1067             _IncomingAmt
1068         );
1069         
1070         uint256 goodwillPortion = _transferGoodwill(
1071             address(vaultToExit),
1072             _IncomingAmt
1073         );
1074 
1075         vaultToExit.withdraw(_IncomingAmt.sub(goodwillPortion));
1076         uint256 underlyingReceived = IERC20(underlyingVaultToken).balanceOf(
1077             address(this)
1078         );
1079         
1080         uint256 toTokensReceived;
1081         if(_ToTokenContractAddress == underlyingVaultToken) {
1082             TransferHelper.safeTransfer(
1083                 underlyingVaultToken,
1084                 _toWhomToIssue,
1085                 underlyingReceived
1086             );
1087             toTokensReceived = underlyingReceived;
1088         } else {
1089             if(_vaultType == 2) {
1090                 // separate fx to avoid stack too deep error
1091                 toTokensReceived = _withdrawFromCurve(
1092                     underlyingVaultToken,
1093                     underlyingReceived,
1094                     _toWhomToIssue,
1095                     _ToTokenContractAddress,
1096                     _minTokensRec
1097                 );
1098             } else if(_vaultType == 1) {
1099                 // unwrap atoken
1100                 IAToken(underlyingVaultToken).redeem(underlyingReceived);
1101                 address underlyingAsset = IAToken(underlyingVaultToken)
1102                         .underlyingAssetAddress();
1103                 
1104                 // swap
1105                 if(_ToTokenContractAddress == address(0)) {
1106                     toTokensReceived = _token2Eth(
1107                         underlyingAsset,
1108                         underlyingReceived,
1109                         payable(_toWhomToIssue),
1110                         _minTokensRec
1111                     );
1112                 } else {
1113                     toTokensReceived = _token2Token(
1114                         underlyingAsset,
1115                         _ToTokenContractAddress,
1116                         underlyingReceived,
1117                         _minTokensRec
1118                     );
1119                     TransferHelper.safeTransfer(
1120                         _ToTokenContractAddress,
1121                         _toWhomToIssue,
1122                         toTokensReceived
1123                     );
1124                 }
1125             } else {
1126                 if(_ToTokenContractAddress == address(0)) {
1127                     toTokensReceived = _token2Eth(
1128                         underlyingVaultToken,
1129                         underlyingReceived,
1130                         payable(_toWhomToIssue),
1131                         _minTokensRec
1132                     );
1133                 } else {
1134                     toTokensReceived = _token2Token(
1135                         underlyingVaultToken,
1136                         _ToTokenContractAddress,
1137                         underlyingReceived,
1138                         _minTokensRec
1139                     );
1140                     
1141                     TransferHelper.safeTransfer(
1142                         _ToTokenContractAddress,
1143                         _toWhomToIssue,
1144                         toTokensReceived
1145                     );
1146                 }
1147             }
1148         }
1149         
1150         emit Zapout(
1151             _toWhomToIssue,
1152             _fromYVaultAddress,
1153             _ToTokenContractAddress,
1154             toTokensReceived
1155         );
1156         
1157         return toTokensReceived;
1158     }
1159     
1160     function _withdrawFromCurve(
1161         address _yCurveToken,
1162         uint256 _tokenAmt,
1163         address _toWhomToIssue,
1164         address _ToTokenContractAddress,
1165         uint256 _minTokensRec
1166     ) internal returns(uint256) {
1167         TransferHelper.safeApprove(
1168                 _yCurveToken,
1169                 address(CurveZapOutGeneral),
1170                 _tokenAmt
1171             );
1172             
1173         return(
1174             CurveZapOutGeneral.ZapOut(
1175                 payable(_toWhomToIssue),
1176                 yCurveExchangeAddress,
1177                 4,
1178                 _tokenAmt,
1179                 _ToTokenContractAddress,
1180                 _minTokensRec
1181             )
1182         );
1183     }
1184 
1185     /**
1186     @notice This function is used to swap eth for tokens
1187     @param _tokenContractAddress Token address which we want to buy
1188     @param minTokens recieved after swap for slippage
1189     @return tokensBought The quantity of token bought
1190      */
1191     function _eth2Token(address _tokenContractAddress, uint256 minTokens)
1192         internal
1193         returns (uint256 tokensBought)
1194     {
1195         if(_tokenContractAddress == wethTokenAddress) {
1196             IWETH(wethTokenAddress).deposit{value: msg.value}();
1197             return msg.value;
1198         }
1199 
1200         address[] memory path = new address[](2);
1201         path[0] = wethTokenAddress;
1202         path[1] = _tokenContractAddress;
1203         tokensBought = uniswapRouter.swapExactETHForTokens{value: msg.value}(
1204             1,
1205             path,
1206             address(this),
1207             deadline
1208         )[path.length - 1];
1209         require(tokensBought >= minTokens, "ERR: High Slippage");
1210     }
1211 
1212     /**
1213     @notice This function is used to swap tokens
1214     @param _FromTokenContractAddress The token address to swap from
1215     @param _ToTokenContractAddress The token address to swap to
1216     @param tokens2Trade The amount of tokens to swap
1217     @param minTokens recieved after swap for slippage
1218     @return tokenBought The quantity of tokens bought
1219     */
1220     function _token2Token(
1221         address _FromTokenContractAddress,
1222         address _ToTokenContractAddress,
1223         uint256 tokens2Trade,
1224         uint256 minTokens
1225     ) internal returns (uint256 tokenBought) {
1226         if (_FromTokenContractAddress == _ToTokenContractAddress) {
1227             return tokens2Trade;
1228         }
1229 
1230         TransferHelper.safeApprove(
1231             _FromTokenContractAddress,
1232             address(uniswapRouter),
1233             tokens2Trade
1234         );
1235 
1236         if (_FromTokenContractAddress != wethTokenAddress) {
1237             if (_ToTokenContractAddress != wethTokenAddress) {
1238                 address[] memory path = new address[](3);
1239                 path[0] = _FromTokenContractAddress;
1240                 path[1] = wethTokenAddress;
1241                 path[2] = _ToTokenContractAddress;
1242                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1243                     tokens2Trade,
1244                     1,
1245                     path,
1246                     address(this),
1247                     deadline
1248                 )[path.length - 1];
1249             } else {
1250                 address[] memory path = new address[](2);
1251                 path[0] = _FromTokenContractAddress;
1252                 path[1] = wethTokenAddress;
1253 
1254                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1255                     tokens2Trade,
1256                     1,
1257                     path,
1258                     address(this),
1259                     deadline
1260                 )[path.length - 1];
1261             }
1262         } else {
1263             address[] memory path = new address[](2);
1264             path[0] = wethTokenAddress;
1265             path[1] = _ToTokenContractAddress;
1266             tokenBought = uniswapRouter.swapExactTokensForTokens(
1267                 tokens2Trade,
1268                 1,
1269                 path,
1270                 address(this),
1271                 deadline
1272             )[path.length - 1];
1273         }
1274 
1275         require(tokenBought > minTokens, "ERR: High Slippage");
1276     }
1277     
1278     function _token2Eth(
1279         address _FromTokenContractAddress,
1280         uint256 tokens2Trade,
1281         address payable _toWhomToIssue,
1282         uint256 minTokens
1283     ) internal returns (uint256) {
1284         if (_FromTokenContractAddress == wethTokenAddress) {
1285             IWETH(wethTokenAddress).withdraw(tokens2Trade);
1286             _toWhomToIssue.transfer(tokens2Trade);
1287             return tokens2Trade;
1288         }
1289 
1290         IERC20(_FromTokenContractAddress).approve(
1291             address(uniswapRouter),
1292             tokens2Trade
1293         );
1294 
1295         address[] memory path = new address[](2);
1296         path[0] = _FromTokenContractAddress;
1297         path[1] = wethTokenAddress;
1298         uint256 ethBought = uniswapRouter.swapExactTokensForETH(
1299                             tokens2Trade,
1300                             1,
1301                             path,
1302                             _toWhomToIssue,
1303                             deadline
1304                         )[path.length - 1];
1305         
1306         require(ethBought > minTokens, "Error: High Slippage");
1307         return ethBought;
1308     }
1309 
1310     /**
1311     @notice This function is used to calculate and transfer goodwill
1312     @param _tokenContractAddress Token in which goodwill is deducted
1313     @param tokens2Trade The total amount of tokens to be zapped in
1314     @return goodwillPortion The quantity of goodwill deducted
1315      */
1316     function _transferGoodwill(
1317         address _tokenContractAddress,
1318         uint256 tokens2Trade
1319     ) internal returns (uint256 goodwillPortion) {
1320         goodwillPortion = SafeMath.div(
1321             SafeMath.mul(tokens2Trade, goodwill),
1322             10000
1323         );
1324 
1325         if (goodwillPortion == 0) {
1326             return 0;
1327         }
1328 
1329         TransferHelper.safeTransfer(
1330             _tokenContractAddress,
1331             zgoodwillAddress,
1332             goodwillPortion
1333         );
1334     }
1335 
1336     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1337         require(
1338             _new_goodwill >= 0 && _new_goodwill < 10000,
1339             "GoodWill Value not allowed"
1340         );
1341         goodwill = _new_goodwill;
1342     }
1343 
1344     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1345         uint256 qty = _TokenAddress.balanceOf(address(this));
1346         TransferHelper.safeTransfer(address(_TokenAddress), owner(), qty);
1347     }
1348 
1349     // - to Pause the contract
1350     function toggleContractActive() public onlyOwner {
1351         stopped = !stopped;
1352     }
1353 
1354     // - to withdraw any ETH balance sitting in the contract
1355     function withdraw() public onlyOwner {
1356         uint256 contractBalance = address(this).balance;
1357         address payable _to = payable(owner());
1358         _to.transfer(contractBalance);
1359     }
1360 }