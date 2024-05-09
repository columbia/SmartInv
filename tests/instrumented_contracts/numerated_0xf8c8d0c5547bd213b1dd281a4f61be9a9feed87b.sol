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
633 /**
634  * @title SafeERC20
635  * @dev Wrappers around ERC20 operations that throw on failure (when the token
636  * contract returns false). Tokens that return no value (and instead revert or
637  * throw on failure) are also supported, non-reverting calls are assumed to be
638  * successful.
639  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
640  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
641  */
642 library SafeERC20 {
643     using SafeMath for uint256;
644     using Address for address;
645 
646     function safeTransfer(IERC20 token, address to, uint256 value) internal {
647         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
648     }
649 
650     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
651         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
652     }
653 
654     /**
655      * @dev Deprecated. This function has issues similar to the ones found in
656      * {IERC20-approve}, and its usage is discouraged.
657      *
658      * Whenever possible, use {safeIncreaseAllowance} and
659      * {safeDecreaseAllowance} instead.
660      */
661     function safeApprove(IERC20 token, address spender, uint256 value) internal {
662         // safeApprove should only be called when setting an initial allowance,
663         // or when resetting it to zero. To increase and decrease it, use
664         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
665         // solhint-disable-next-line max-line-length
666         require((value == 0) || (token.allowance(address(this), spender) == 0),
667             "SafeERC20: approve from non-zero to non-zero allowance"
668         );
669         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
670     }
671 
672     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
673         uint256 newAllowance = token.allowance(address(this), spender).add(value);
674         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
675     }
676 
677     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
678         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
679         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
680     }
681 
682     /**
683      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
684      * on the return value: the return value is optional (but if data is returned, it must not be false).
685      * @param token The token targeted by the call.
686      * @param data The call data (encoded using abi.encode or one of its variants).
687      */
688     function _callOptionalReturn(IERC20 token, bytes memory data) private {
689         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
690         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
691         // the target address contains contract code and also asserts for success in the low-level call.
692 
693         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
694         if (returndata.length > 0) { // Return data is optional
695             // solhint-disable-next-line max-line-length
696             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
697         }
698     }
699 }
700 
701 interface IUniswapV2Factory {
702     function getPair(address tokenA, address tokenB)
703         external
704         view
705         returns (address);
706 }
707 
708 interface IUniswapRouter02 {
709     //get estimated amountOut
710     function getAmountsOut(uint256 amountIn, address[] calldata path)
711         external
712         view
713         returns (uint256[] memory amounts);
714 
715     function getAmountsIn(uint256 amountOut, address[] calldata path)
716         external
717         view
718         returns (uint256[] memory amounts);
719 
720     //token 2 token
721     function swapExactTokensForTokens(
722         uint256 amountIn,
723         uint256 amountOutMin,
724         address[] calldata path,
725         address to,
726         uint256 deadline
727     ) external returns (uint256[] memory amounts);
728 
729     function swapTokensForExactTokens(
730         uint256 amountOut,
731         uint256 amountInMax,
732         address[] calldata path,
733         address to,
734         uint256 deadline
735     ) external returns (uint256[] memory amounts);
736 
737     //eth 2 token
738     function swapExactETHForTokens(
739         uint256 amountOutMin,
740         address[] calldata path,
741         address to,
742         uint256 deadline
743     ) external payable returns (uint256[] memory amounts);
744 
745     function swapETHForExactTokens(
746         uint256 amountOut,
747         address[] calldata path,
748         address to,
749         uint256 deadline
750     ) external payable returns (uint256[] memory amounts);
751 
752     //token 2 eth
753     function swapTokensForExactETH(
754         uint256 amountOut,
755         uint256 amountInMax,
756         address[] calldata path,
757         address to,
758         uint256 deadline
759     ) external returns (uint256[] memory amounts);
760 
761     function swapExactTokensForETH(
762         uint256 amountIn,
763         uint256 amountOutMin,
764         address[] calldata path,
765         address to,
766         uint256 deadline
767     ) external returns (uint256[] memory amounts);
768 }
769 
770 interface yVault {
771     function deposit(uint256) external;
772 
773     function withdraw(uint256) external;
774 
775     function getPricePerFullShare() external view returns (uint256);
776 
777     function token() external view returns (address);
778 }
779 
780 interface ICurveZapInGeneral {
781     function ZapIn(
782         address _toWhomToIssue,
783         address _IncomingTokenAddress,
784         address _curvePoolExchangeAddress,
785         uint256 _IncomingTokenQty,
786         uint256 _minPoolTokens
787     ) external payable returns (uint256 crvTokensBought);
788 }
789 
790 interface ICurveZapOutGeneral {
791     function ZapOut(
792         address payable _toWhomToIssue,
793         address _curveExchangeAddress,
794         uint256 _tokenCount,
795         uint256 _IncomingCRV,
796         address _ToTokenAddress,
797         uint256 _minToTokens
798     ) external returns (uint256 ToTokensBought);
799 }
800 
801 interface IAaveLendingPoolAddressesProvider {
802     function getLendingPool() external view returns (address);
803 
804     function getLendingPoolCore() external view returns (address payable);
805 }
806 
807 interface IAaveLendingPool {
808     function deposit(
809         address _reserve,
810         uint256 _amount,
811         uint16 _referralCode
812     ) external payable;
813 }
814 
815 interface IAToken {
816     function redeem(uint256 _amount) external;
817 
818     function underlyingAssetAddress() external returns (address);
819 }
820 
821 interface IWETH {
822     function deposit() external payable;
823 
824     function withdraw(uint256) external;
825 }
826 
827 contract yVault_ZapInOut_General_V1_3 is ReentrancyGuard, Ownable {
828     using SafeMath for uint256;
829     using Address for address;
830     using SafeERC20 for IERC20;
831     bool public stopped = false;
832     uint16 public goodwill;
833 
834     IUniswapV2Factory
835         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
836         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
837     );
838     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
839         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
840     );
841 
842     ICurveZapInGeneral public CurveZapInGeneral = ICurveZapInGeneral(
843         0x456974dF1042bA7A46FD49512A8778Ac3B840A21
844     );
845     ICurveZapOutGeneral public CurveZapOutGeneral = ICurveZapOutGeneral(
846         0x4bF331Aa2BfB0869315fB81a350d109F4839f81b
847     );
848     
849     IAaveLendingPoolAddressesProvider
850         private constant lendingPoolAddressProvider = IAaveLendingPoolAddressesProvider(
851         0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
852     );
853 
854     address private constant yCurveExchangeAddress = 0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3;
855     address private constant sBtcCurveExchangeAddress = 0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714;
856     address private constant bUSDCurveExchangeAddress = 0xb6c057591E073249F2D9D88Ba59a46CFC9B59EdB;
857     
858     address private constant yCurvePoolTokenAddress = 0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8;
859     address private constant sBtcCurvePoolTokenAddress = 0x075b1bb99792c9E1041bA13afEf80C91a1e70fB3;
860     address private constant bUSDCurvePoolTokenAddress = 0x3B3Ac5386837Dc563660FB6a0937DFAa5924333B;
861     
862     mapping(address => address) internal token2Exchange;
863 
864     address
865         private constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
866     address
867         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
868     address
869         private constant zgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
870 
871     uint256
872         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
873 
874     event Zapin(
875         address _toWhomToIssue,
876         address _toYVaultAddress,
877         uint256 _Outgoing
878     );
879 
880     event Zapout(
881         address _toWhomToIssue,
882         address _fromYVaultAddress,
883         address _toTokenAddress,
884         uint256 _tokensRecieved
885     );
886 
887     constructor(uint16 _goodwill) public {
888         goodwill = _goodwill;
889         
890         token2Exchange[yCurvePoolTokenAddress] = yCurveExchangeAddress;
891         token2Exchange[bUSDCurvePoolTokenAddress] = bUSDCurveExchangeAddress;
892         token2Exchange[sBtcCurvePoolTokenAddress] = sBtcCurveExchangeAddress;
893     }
894 
895     // circuit breaker modifiers
896     modifier stopInEmergency {
897         if (stopped) {
898             revert("Temporarily Paused");
899         } else {
900             _;
901         }
902     }
903 
904     function updateCurveZapIn(address CurveZapInGeneralAddress)
905         public
906         onlyOwner
907     {
908         require(CurveZapInGeneralAddress != address(0), "Invalid Address");
909         CurveZapInGeneral = ICurveZapInGeneral(CurveZapInGeneralAddress);
910     }
911     
912     function updateCurveZapOut(address CurveZapOutGeneralAddress)
913         public
914         onlyOwner
915     {
916         require(CurveZapOutGeneralAddress != address(0), "Invalid Address");
917         CurveZapOutGeneral = ICurveZapOutGeneral(CurveZapOutGeneralAddress);
918     }
919     
920     function addNewCurveExchange(address curvePoolToken, address curveExchangeAddress)
921         public
922         onlyOwner
923     {
924         require(curvePoolToken != address(0) && curveExchangeAddress != address(0), "Invalid Address");
925         token2Exchange[curvePoolToken] = curveExchangeAddress;
926     }
927 
928     /**
929     @notice This function is used to add liquidity to yVaults
930     @param _toWhomToIssue recipient address
931     @param _toYVaultAddress The address of vault to add liquidity to
932     @param _vaultType Type of underlying token: 0 token; 1 aToken; 2 LP token
933     @param _fromTokenAddress The token used for investment (address(0x00) if ether)
934     @param _amount The amount of ERC to invest
935     @param _minTokensSwapped for slippage
936     @return yTokensRec
937      */
938     function ZapIn(
939         address _toWhomToIssue,
940         address _toYVaultAddress,
941         uint16 _vaultType,
942         address _fromTokenAddress,
943         uint256 _amount,
944         uint256 _minTokensSwapped
945     ) public payable nonReentrant stopInEmergency returns (uint256) {
946         yVault vaultToEnter = yVault(_toYVaultAddress);
947         address underlyingVaultToken = vaultToEnter.token();
948 
949         if (_fromTokenAddress == address(0)) {
950             require(msg.value > 0, "ERR: No ETH sent");
951         } else {
952             require(_amount > 0, "Err: No Tokens Sent");
953             require(msg.value == 0, "ERR: ETH sent with Token");
954 
955             IERC20(_fromTokenAddress).safeTransferFrom(
956                 msg.sender,
957                 address(this),
958                 _amount
959             );
960         }
961         if (underlyingVaultToken == _fromTokenAddress) {
962             IERC20(underlyingVaultToken).safeApprove(
963                 address(vaultToEnter),
964                 _amount
965             );
966             vaultToEnter.deposit(_amount);
967         } else {
968             // Curve Vaults
969             if (_vaultType == 2) {
970                 address curveExchangeAddr = token2Exchange[underlyingVaultToken];
971                 
972                 uint256 tokensBought;
973                 if (_fromTokenAddress == address(0)) {
974                     tokensBought = CurveZapInGeneral.ZapIn{value: msg.value}(
975                         address(this),
976                         address(0),
977                         curveExchangeAddr,
978                         msg.value,
979                         _minTokensSwapped
980                     );
981                 } else {
982                     IERC20(_fromTokenAddress).safeApprove(
983                         address(CurveZapInGeneral),
984                         _amount
985                     );
986                     tokensBought = CurveZapInGeneral.ZapIn(
987                         address(this),
988                         _fromTokenAddress,
989                         curveExchangeAddr,
990                         _amount,
991                         _minTokensSwapped
992                     );
993                 }
994 
995                 IERC20(underlyingVaultToken).safeApprove(
996                     address(vaultToEnter),
997                     tokensBought
998                 );
999                 vaultToEnter.deposit(tokensBought);
1000             } else if (_vaultType == 1) {
1001                 address underlyingAsset = IAToken(underlyingVaultToken)
1002                     .underlyingAssetAddress();
1003 
1004                 uint256 tokensBought;
1005                 if (_fromTokenAddress == address(0)) {
1006                     tokensBought = _eth2Token(
1007                         underlyingAsset,
1008                         _minTokensSwapped
1009                     );
1010                 } else {
1011                     tokensBought = _token2Token(
1012                         _fromTokenAddress,
1013                         underlyingAsset,
1014                         _amount,
1015                         _minTokensSwapped
1016                     );
1017                 }
1018 
1019                 IERC20(underlyingAsset).safeApprove(
1020                     lendingPoolAddressProvider.getLendingPoolCore(),
1021                     tokensBought
1022                 );
1023 
1024                 IAaveLendingPool(lendingPoolAddressProvider.getLendingPool())
1025                     .deposit(underlyingAsset, tokensBought, 0);
1026 
1027                 uint256 aTokensBought = IERC20(underlyingVaultToken).balanceOf(
1028                     address(this)
1029                 );
1030                 IERC20(underlyingVaultToken).safeApprove(
1031                     address(vaultToEnter),
1032                     aTokensBought
1033                 );
1034                 vaultToEnter.deposit(aTokensBought);
1035             } else {
1036                 uint256 tokensBought;
1037                 if (_fromTokenAddress == address(0)) {
1038                     tokensBought = _eth2Token(
1039                         underlyingVaultToken,
1040                         _minTokensSwapped
1041                     );
1042                 } else {
1043                     tokensBought = _token2Token(
1044                         _fromTokenAddress,
1045                         underlyingVaultToken,
1046                         _amount,
1047                         _minTokensSwapped
1048                     );
1049                 }
1050 
1051                 IERC20(underlyingVaultToken).safeApprove(
1052                     address(vaultToEnter),
1053                     tokensBought
1054                 );
1055                 vaultToEnter.deposit(tokensBought);
1056             }
1057         }
1058 
1059         uint256 yTokensRec = IERC20(address(vaultToEnter)).balanceOf(
1060             address(this)
1061         );
1062 
1063         //transfer goodwill
1064         uint256 goodwillPortion = _transferGoodwill(
1065             address(vaultToEnter),
1066             yTokensRec
1067         );
1068 
1069         IERC20(address(vaultToEnter)).safeTransfer(
1070             _toWhomToIssue,
1071             yTokensRec.sub(goodwillPortion)
1072         );
1073 
1074         emit Zapin(
1075             _toWhomToIssue,
1076             address(vaultToEnter),
1077             yTokensRec.sub(goodwillPortion)
1078         );
1079 
1080         return (yTokensRec.sub(goodwillPortion));
1081     }
1082 
1083     /**
1084     @notice This function is used to remove liquidity from yVaults
1085     @param _toWhomToIssue recipient address
1086     @param _ToTokenContractAddress The address of the token to withdraw
1087     @param _fromYVaultAddress The address of the vault to exit
1088     @param _vaultType Type of underlying token: 0 token; 1 aToken; 2 LP token
1089     @param _IncomingAmt The amount of vault tokens removed
1090     @param _minTokensRec for slippage
1091     @return toTokensReceived
1092      */  
1093     function ZapOut(
1094         address _toWhomToIssue,
1095         address _ToTokenContractAddress,
1096         address _fromYVaultAddress,
1097         uint16 _vaultType,
1098         uint256 _IncomingAmt,
1099         uint256 _minTokensRec
1100     ) public nonReentrant stopInEmergency returns (uint256) {
1101         yVault vaultToExit = yVault(_fromYVaultAddress);
1102         address underlyingVaultToken = vaultToExit.token();
1103 
1104         IERC20(address(vaultToExit)).safeTransferFrom(
1105             msg.sender,
1106             address(this),
1107             _IncomingAmt
1108         );
1109         
1110         uint256 goodwillPortion = _transferGoodwill(
1111             address(vaultToExit),
1112             _IncomingAmt
1113         );
1114 
1115         vaultToExit.withdraw(_IncomingAmt.sub(goodwillPortion));
1116         uint256 underlyingReceived = IERC20(underlyingVaultToken).balanceOf(
1117             address(this)
1118         );
1119         
1120         uint256 toTokensReceived;
1121         if(_ToTokenContractAddress == underlyingVaultToken) {
1122             IERC20(underlyingVaultToken).safeTransfer(
1123                 _toWhomToIssue,
1124                 underlyingReceived
1125             );
1126             toTokensReceived = underlyingReceived;
1127         } else {
1128             if(_vaultType == 2) {
1129                 toTokensReceived = _withdrawFromCurve(
1130                     underlyingVaultToken,
1131                     underlyingReceived,
1132                     _toWhomToIssue,
1133                     _ToTokenContractAddress,
1134                     _minTokensRec
1135                 );
1136             } else if(_vaultType == 1) {
1137                 // unwrap atoken
1138                 IAToken(underlyingVaultToken).redeem(underlyingReceived);
1139                 address underlyingAsset = IAToken(underlyingVaultToken)
1140                         .underlyingAssetAddress();
1141                 
1142                 // swap
1143                 if(_ToTokenContractAddress == address(0)) {
1144                     toTokensReceived = _token2Eth(
1145                         underlyingAsset,
1146                         underlyingReceived,
1147                         payable(_toWhomToIssue),
1148                         _minTokensRec
1149                     );
1150                 } else {
1151                     toTokensReceived = _token2Token(
1152                         underlyingAsset,
1153                         _ToTokenContractAddress,
1154                         underlyingReceived,
1155                         _minTokensRec
1156                     );
1157                     IERC20(_ToTokenContractAddress).safeTransfer(
1158                         _toWhomToIssue,
1159                         toTokensReceived
1160                     );
1161                 }
1162             } else {
1163                 if(_ToTokenContractAddress == address(0)) {
1164                     toTokensReceived = _token2Eth(
1165                         underlyingVaultToken,
1166                         underlyingReceived,
1167                         payable(_toWhomToIssue),
1168                         _minTokensRec
1169                     );
1170                 } else {
1171                     toTokensReceived = _token2Token(
1172                         underlyingVaultToken,
1173                         _ToTokenContractAddress,
1174                         underlyingReceived,
1175                         _minTokensRec
1176                     );
1177                     
1178                     IERC20(_ToTokenContractAddress).safeTransfer(
1179                         _toWhomToIssue,
1180                         toTokensReceived
1181                     );
1182                 }
1183             }
1184         }
1185         
1186         emit Zapout(
1187             _toWhomToIssue,
1188             _fromYVaultAddress,
1189             _ToTokenContractAddress,
1190             toTokensReceived
1191         );
1192         
1193         return toTokensReceived;
1194     }
1195     
1196     function _withdrawFromCurve(
1197         address _CurvePoolToken,
1198         uint256 _tokenAmt,
1199         address _toWhomToIssue,
1200         address _ToTokenContractAddress,
1201         uint256 _minTokensRec
1202     ) internal returns(uint256) {
1203         IERC20(_CurvePoolToken).safeApprove(
1204             address(CurveZapOutGeneral),
1205             _tokenAmt
1206         );
1207         
1208         address curveExchangeAddr = token2Exchange[_CurvePoolToken];
1209         uint256 tokenCount = 4;
1210         
1211         if(curveExchangeAddr == sBtcCurveExchangeAddress) {
1212             tokenCount = 3;
1213         }
1214             
1215         return(
1216             CurveZapOutGeneral.ZapOut(
1217                 payable(_toWhomToIssue),
1218                 curveExchangeAddr,
1219                 tokenCount,
1220                 _tokenAmt,
1221                 _ToTokenContractAddress,
1222                 _minTokensRec
1223             )
1224         );
1225     }
1226 
1227     /**
1228     @notice This function is used to swap eth for tokens
1229     @param _tokenContractAddress Token address which we want to buy
1230     @param minTokens recieved after swap for slippage
1231     @return tokensBought The quantity of token bought
1232      */
1233     function _eth2Token(address _tokenContractAddress, uint256 minTokens)
1234         internal
1235         returns (uint256 tokensBought)
1236     {
1237         if(_tokenContractAddress == wethTokenAddress) {
1238             IWETH(wethTokenAddress).deposit{value: msg.value}();
1239             return msg.value;
1240         }
1241 
1242         address[] memory path = new address[](2);
1243         path[0] = wethTokenAddress;
1244         path[1] = _tokenContractAddress;
1245         tokensBought = uniswapRouter.swapExactETHForTokens{value: msg.value}(
1246             1,
1247             path,
1248             address(this),
1249             deadline
1250         )[path.length - 1];
1251         require(tokensBought >= minTokens, "ERR: High Slippage");
1252     }
1253 
1254     /**
1255     @notice This function is used to swap tokens
1256     @param _FromTokenContractAddress The token address to swap from
1257     @param _ToTokenContractAddress The token address to swap to
1258     @param tokens2Trade The amount of tokens to swap
1259     @param minTokens recieved after swap for slippage
1260     @return tokenBought The quantity of tokens bought
1261     */
1262     function _token2Token(
1263         address _FromTokenContractAddress,
1264         address _ToTokenContractAddress,
1265         uint256 tokens2Trade,
1266         uint256 minTokens
1267     ) internal returns (uint256 tokenBought) {
1268         if (_FromTokenContractAddress == _ToTokenContractAddress) {
1269             return tokens2Trade;
1270         }
1271 
1272         IERC20(_FromTokenContractAddress).safeApprove(
1273             address(uniswapRouter),
1274             tokens2Trade
1275         );
1276 
1277         if (_FromTokenContractAddress != wethTokenAddress) {
1278             if (_ToTokenContractAddress != wethTokenAddress) {
1279                 address[] memory path = new address[](3);
1280                 path[0] = _FromTokenContractAddress;
1281                 path[1] = wethTokenAddress;
1282                 path[2] = _ToTokenContractAddress;
1283                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1284                     tokens2Trade,
1285                     1,
1286                     path,
1287                     address(this),
1288                     deadline
1289                 )[path.length - 1];
1290             } else {
1291                 address[] memory path = new address[](2);
1292                 path[0] = _FromTokenContractAddress;
1293                 path[1] = wethTokenAddress;
1294 
1295                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1296                     tokens2Trade,
1297                     1,
1298                     path,
1299                     address(this),
1300                     deadline
1301                 )[path.length - 1];
1302             }
1303         } else {
1304             address[] memory path = new address[](2);
1305             path[0] = wethTokenAddress;
1306             path[1] = _ToTokenContractAddress;
1307             tokenBought = uniswapRouter.swapExactTokensForTokens(
1308                 tokens2Trade,
1309                 1,
1310                 path,
1311                 address(this),
1312                 deadline
1313             )[path.length - 1];
1314         }
1315 
1316         require(tokenBought > minTokens, "ERR: High Slippage");
1317     }
1318     
1319     function _token2Eth(
1320         address _FromTokenContractAddress,
1321         uint256 tokens2Trade,
1322         address payable _toWhomToIssue,
1323         uint256 minTokens
1324     ) internal returns (uint256) {
1325         if (_FromTokenContractAddress == wethTokenAddress) {
1326             IWETH(wethTokenAddress).withdraw(tokens2Trade);
1327             _toWhomToIssue.transfer(tokens2Trade);
1328             return tokens2Trade;
1329         }
1330 
1331         IERC20(_FromTokenContractAddress).safeApprove(
1332             address(uniswapRouter),
1333             tokens2Trade
1334         );
1335 
1336         address[] memory path = new address[](2);
1337         path[0] = _FromTokenContractAddress;
1338         path[1] = wethTokenAddress;
1339         uint256 ethBought = uniswapRouter.swapExactTokensForETH(
1340                             tokens2Trade,
1341                             1,
1342                             path,
1343                             _toWhomToIssue,
1344                             deadline
1345                         )[path.length - 1];
1346         
1347         require(ethBought > minTokens, "Error: High Slippage");
1348         return ethBought;
1349     }
1350 
1351     /**
1352     @notice This function is used to calculate and transfer goodwill
1353     @param _tokenContractAddress Token in which goodwill is deducted
1354     @param tokens2Trade The total amount of tokens to be zapped in
1355     @return goodwillPortion The quantity of goodwill deducted
1356      */
1357     function _transferGoodwill(
1358         address _tokenContractAddress,
1359         uint256 tokens2Trade
1360     ) internal returns (uint256 goodwillPortion) {
1361         goodwillPortion = SafeMath.div(
1362             SafeMath.mul(tokens2Trade, goodwill),
1363             10000
1364         );
1365 
1366         if (goodwillPortion == 0) {
1367             return 0;
1368         }
1369 
1370         IERC20(_tokenContractAddress).safeTransfer(
1371             zgoodwillAddress,
1372             goodwillPortion
1373         );
1374     }
1375 
1376     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1377         require(
1378             _new_goodwill >= 0 && _new_goodwill < 10000,
1379             "GoodWill Value not allowed"
1380         );
1381         goodwill = _new_goodwill;
1382     }
1383 
1384     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1385         uint256 qty = _TokenAddress.balanceOf(address(this));
1386         IERC20(address(_TokenAddress)).safeTransfer(owner(), qty);
1387     }
1388 
1389     // - to Pause the contract
1390     function toggleContractActive() public onlyOwner {
1391         stopped = !stopped;
1392     }
1393 
1394     // - to withdraw any ETH balance sitting in the contract
1395     function withdraw() public onlyOwner {
1396         uint256 contractBalance = address(this).balance;
1397         address payable _to = payable(owner());
1398         _to.transfer(contractBalance);
1399     }
1400 }