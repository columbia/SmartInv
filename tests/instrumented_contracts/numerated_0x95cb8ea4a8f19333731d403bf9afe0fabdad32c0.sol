1 // SPDX-License-Identifier: MIT
2 
3 
4 /**
5 
6 Welcome to spooky szn where roadmaps do not exist!
7 Halloween Apes are digital collectibles, meaning they are just art!
8 The only promise is the art!
9 
10 **/
11 
12 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
13 
14 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `to`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address to, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `from` to `to` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address from,
77         address to,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Contract module that helps prevent reentrant calls to a function.
105  *
106  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
107  * available, which can be applied to functions to make sure there are no nested
108  * (reentrant) calls to them.
109  *
110  * Note that because there is a single `nonReentrant` guard, functions marked as
111  * `nonReentrant` may not call one another. This can be worked around by making
112  * those functions `private`, and then adding `external` `nonReentrant` entry
113  * points to them.
114  *
115  * TIP: If you would like to learn more about reentrancy and alternative ways
116  * to protect against it, check out our blog post
117  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
118  */
119 abstract contract ReentrancyGuard {
120     // Booleans are more expensive than uint256 or any type that takes up a full
121     // word because each write operation emits an extra SLOAD to first read the
122     // slot's contents, replace the bits taken up by the boolean, and then write
123     // back. This is the compiler's defense against contract upgrades and
124     // pointer aliasing, and it cannot be disabled.
125 
126     // The values being non-zero value makes deployment a bit more expensive,
127     // but in exchange the refund on every call to nonReentrant will be lower in
128     // amount. Since refunds are capped to a percentage of the total
129     // transaction's gas, it is best to keep them low in cases like this one, to
130     // increase the likelihood of the full refund coming into effect.
131     uint256 private constant _NOT_ENTERED = 1;
132     uint256 private constant _ENTERED = 2;
133 
134     uint256 private _status;
135 
136     constructor() {
137         _status = _NOT_ENTERED;
138     }
139 
140     /**
141      * @dev Prevents a contract from calling itself, directly or indirectly.
142      * Calling a `nonReentrant` function from another `nonReentrant`
143      * function is not supported. It is possible to prevent this from happening
144      * by making the `nonReentrant` function external, and making it call a
145      * `private` function that does the actual work.
146      */
147     modifier nonReentrant() {
148         // On the first call to nonReentrant, _notEntered will be true
149         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
150 
151         // Any calls to nonReentrant after this point will fail
152         _status = _ENTERED;
153 
154         _;
155 
156         // By storing the original value once again, a refund is triggered (see
157         // https://eips.ethereum.org/EIPS/eip-2200)
158         _status = _NOT_ENTERED;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/utils/Strings.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @dev String operations.
171  */
172 library Strings {
173     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
174 
175     /**
176      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
177      */
178     function toString(uint256 value) internal pure returns (string memory) {
179         // Inspired by OraclizeAPI's implementation - MIT licence
180         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
181 
182         if (value == 0) {
183             return "0";
184         }
185         uint256 temp = value;
186         uint256 digits;
187         while (temp != 0) {
188             digits++;
189             temp /= 10;
190         }
191         bytes memory buffer = new bytes(digits);
192         while (value != 0) {
193             digits -= 1;
194             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
195             value /= 10;
196         }
197         return string(buffer);
198     }
199 
200     /**
201      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
202      */
203     function toHexString(uint256 value) internal pure returns (string memory) {
204         if (value == 0) {
205             return "0x00";
206         }
207         uint256 temp = value;
208         uint256 length = 0;
209         while (temp != 0) {
210             length++;
211             temp >>= 8;
212         }
213         return toHexString(value, length);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
218      */
219     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
220         bytes memory buffer = new bytes(2 * length + 2);
221         buffer[0] = "0";
222         buffer[1] = "x";
223         for (uint256 i = 2 * length + 1; i > 1; --i) {
224             buffer[i] = _HEX_SYMBOLS[value & 0xf];
225             value >>= 4;
226         }
227         require(value == 0, "Strings: hex length insufficient");
228         return string(buffer);
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/Context.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 abstract contract Context {
250     function _msgSender() internal view virtual returns (address) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes calldata) {
255         return msg.data;
256     }
257 }
258 
259 // File: @openzeppelin/contracts/access/Ownable.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 
267 /**
268  * @dev Contract module which provides a basic access control mechanism, where
269  * there is an account (an owner) that can be granted exclusive access to
270  * specific functions.
271  *
272  * By default, the owner account will be the one that deploys the contract. This
273  * can later be changed with {transferOwnership}.
274  *
275  * This module is used through inheritance. It will make available the modifier
276  * `onlyOwner`, which can be applied to your functions to restrict their use to
277  * the owner.
278  */
279 abstract contract Ownable is Context {
280     address private _owner;
281 
282     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
283 
284     /**
285      * @dev Initializes the contract setting the deployer as the initial owner.
286      */
287     constructor() {
288         _transferOwnership(_msgSender());
289     }
290 
291     /**
292      * @dev Returns the address of the current owner.
293      */
294     function owner() public view virtual returns (address) {
295         return _owner;
296     }
297 
298     /**
299      * @dev Throws if called by any account other than the owner.
300      */
301     modifier onlyOwner() {
302         require(owner() == _msgSender(), "Ownable: caller is not the owner");
303         _;
304     }
305 
306     /**
307      * @dev Leaves the contract without owner. It will not be possible to call
308      * `onlyOwner` functions anymore. Can only be called by the current owner.
309      *
310      * NOTE: Renouncing ownership will leave the contract without an owner,
311      * thereby removing any functionality that is only available to the owner.
312      */
313     function renounceOwnership() public virtual onlyOwner {
314         _transferOwnership(address(0));
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Can only be called by the current owner.
320      */
321     function transferOwnership(address newOwner) public virtual onlyOwner {
322         require(newOwner != address(0), "Ownable: new owner is the zero address");
323         _transferOwnership(newOwner);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Internal function without access restriction.
329      */
330     function _transferOwnership(address newOwner) internal virtual {
331         address oldOwner = _owner;
332         _owner = newOwner;
333         emit OwnershipTransferred(oldOwner, newOwner);
334     }
335 }
336 
337 // File: @openzeppelin/contracts/utils/Address.sol
338 
339 
340 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
341 
342 pragma solidity ^0.8.1;
343 
344 /**
345  * @dev Collection of functions related to the address type
346  */
347 library Address {
348     /**
349      * @dev Returns true if `account` is a contract.
350      *
351      * [IMPORTANT]
352      * ====
353      * It is unsafe to assume that an address for which this function returns
354      * false is an externally-owned account (EOA) and not a contract.
355      *
356      * Among others, `isContract` will return false for the following
357      * types of addresses:
358      *
359      *  - an externally-owned account
360      *  - a contract in construction
361      *  - an address where a contract will be created
362      *  - an address where a contract lived, but was destroyed
363      * ====
364      *
365      * [IMPORTANT]
366      * ====
367      * You shouldn't rely on `isContract` to protect against flash loan attacks!
368      *
369      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
370      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
371      * constructor.
372      * ====
373      */
374     function isContract(address account) internal view returns (bool) {
375         // This method relies on extcodesize/address.code.length, which returns 0
376         // for contracts in construction, since the code is only stored at the end
377         // of the constructor execution.
378 
379         return account.code.length > 0;
380     }
381 
382     /**
383      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
384      * `recipient`, forwarding all available gas and reverting on errors.
385      *
386      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
387      * of certain opcodes, possibly making contracts go over the 2300 gas limit
388      * imposed by `transfer`, making them unable to receive funds via
389      * `transfer`. {sendValue} removes this limitation.
390      *
391      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
392      *
393      * IMPORTANT: because control is transferred to `recipient`, care must be
394      * taken to not create reentrancy vulnerabilities. Consider using
395      * {ReentrancyGuard} or the
396      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
397      */
398     function sendValue(address payable recipient, uint256 amount) internal {
399         require(address(this).balance >= amount, "Address: insufficient balance");
400 
401         (bool success, ) = recipient.call{value: amount}("");
402         require(success, "Address: unable to send value, recipient may have reverted");
403     }
404 
405     /**
406      * @dev Performs a Solidity function call using a low level `call`. A
407      * plain `call` is an unsafe replacement for a function call: use this
408      * function instead.
409      *
410      * If `target` reverts with a revert reason, it is bubbled up by this
411      * function (like regular Solidity function calls).
412      *
413      * Returns the raw returned data. To convert to the expected return value,
414      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
415      *
416      * Requirements:
417      *
418      * - `target` must be a contract.
419      * - calling `target` with `data` must not revert.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionCall(target, data, "Address: low-level call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
429      * `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, 0, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but also transferring `value` wei to `target`.
444      *
445      * Requirements:
446      *
447      * - the calling contract must have an ETH balance of at least `value`.
448      * - the called Solidity function must be `payable`.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(
453         address target,
454         bytes memory data,
455         uint256 value
456     ) internal returns (bytes memory) {
457         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
462      * with `errorMessage` as a fallback revert reason when `target` reverts.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         require(address(this).balance >= value, "Address: insufficient balance for call");
473         require(isContract(target), "Address: call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.call{value: value}(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
486         return functionStaticCall(target, data, "Address: low-level static call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
491      * but performing a static call.
492      *
493      * _Available since v3.3._
494      */
495     function functionStaticCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal view returns (bytes memory) {
500         require(isContract(target), "Address: static call to non-contract");
501 
502         (bool success, bytes memory returndata) = target.staticcall(data);
503         return verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but performing a delegate call.
509      *
510      * _Available since v3.4._
511      */
512     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
513         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
518      * but performing a delegate call.
519      *
520      * _Available since v3.4._
521      */
522     function functionDelegateCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         require(isContract(target), "Address: delegate call to non-contract");
528 
529         (bool success, bytes memory returndata) = target.delegatecall(data);
530         return verifyCallResult(success, returndata, errorMessage);
531     }
532 
533     /**
534      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
535      * revert reason using the provided one.
536      *
537      * _Available since v4.3._
538      */
539     function verifyCallResult(
540         bool success,
541         bytes memory returndata,
542         string memory errorMessage
543     ) internal pure returns (bytes memory) {
544         if (success) {
545             return returndata;
546         } else {
547             // Look for revert reason and bubble it up if present
548             if (returndata.length > 0) {
549                 // The easiest way to bubble the revert reason is using memory via assembly
550 
551                 assembly {
552                     let returndata_size := mload(returndata)
553                     revert(add(32, returndata), returndata_size)
554                 }
555             } else {
556                 revert(errorMessage);
557             }
558         }
559     }
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 
571 /**
572  * @title SafeERC20
573  * @dev Wrappers around ERC20 operations that throw on failure (when the token
574  * contract returns false). Tokens that return no value (and instead revert or
575  * throw on failure) are also supported, non-reverting calls are assumed to be
576  * successful.
577  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
578  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
579  */
580 library SafeERC20 {
581     using Address for address;
582 
583     function safeTransfer(
584         IERC20 token,
585         address to,
586         uint256 value
587     ) internal {
588         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
589     }
590 
591     function safeTransferFrom(
592         IERC20 token,
593         address from,
594         address to,
595         uint256 value
596     ) internal {
597         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
598     }
599 
600     /**
601      * @dev Deprecated. This function has issues similar to the ones found in
602      * {IERC20-approve}, and its usage is discouraged.
603      *
604      * Whenever possible, use {safeIncreaseAllowance} and
605      * {safeDecreaseAllowance} instead.
606      */
607     function safeApprove(
608         IERC20 token,
609         address spender,
610         uint256 value
611     ) internal {
612         // safeApprove should only be called when setting an initial allowance,
613         // or when resetting it to zero. To increase and decrease it, use
614         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
615         require(
616             (value == 0) || (token.allowance(address(this), spender) == 0),
617             "SafeERC20: approve from non-zero to non-zero allowance"
618         );
619         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
620     }
621 
622     function safeIncreaseAllowance(
623         IERC20 token,
624         address spender,
625         uint256 value
626     ) internal {
627         uint256 newAllowance = token.allowance(address(this), spender) + value;
628         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
629     }
630 
631     function safeDecreaseAllowance(
632         IERC20 token,
633         address spender,
634         uint256 value
635     ) internal {
636         unchecked {
637             uint256 oldAllowance = token.allowance(address(this), spender);
638             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
639             uint256 newAllowance = oldAllowance - value;
640             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
641         }
642     }
643 
644     /**
645      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
646      * on the return value: the return value is optional (but if data is returned, it must not be false).
647      * @param token The token targeted by the call.
648      * @param data The call data (encoded using abi.encode or one of its variants).
649      */
650     function _callOptionalReturn(IERC20 token, bytes memory data) private {
651         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
652         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
653         // the target address contains contract code and also asserts for success in the low-level call.
654 
655         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
656         if (returndata.length > 0) {
657             // Return data is optional
658             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
659         }
660     }
661 }
662 
663 
664 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @title ERC721 token receiver interface
673  * @dev Interface for any contract that wants to support safeTransfers
674  * from ERC721 asset contracts.
675  */
676 interface IERC721Receiver {
677     /**
678      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
679      * by `operator` from `from`, this function is called.
680      *
681      * It must return its Solidity selector to confirm the token transfer.
682      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
683      *
684      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
685      */
686     function onERC721Received(
687         address operator,
688         address from,
689         uint256 tokenId,
690         bytes calldata data
691     ) external returns (bytes4);
692 }
693 
694 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 /**
702  * @dev Interface of the ERC165 standard, as defined in the
703  * https://eips.ethereum.org/EIPS/eip-165[EIP].
704  *
705  * Implementers can declare support of contract interfaces, which can then be
706  * queried by others ({ERC165Checker}).
707  *
708  * For an implementation, see {ERC165}.
709  */
710 interface IERC165 {
711     /**
712      * @dev Returns true if this contract implements the interface defined by
713      * `interfaceId`. See the corresponding
714      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
715      * to learn more about how these ids are created.
716      *
717      * This function call must use less than 30 000 gas.
718      */
719     function supportsInterface(bytes4 interfaceId) external view returns (bool);
720 }
721 
722 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 
730 /**
731  * @dev Implementation of the {IERC165} interface.
732  *
733  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
734  * for the additional interface id that will be supported. For example:
735  *
736  * ```solidity
737  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
739  * }
740  * ```
741  *
742  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
743  */
744 abstract contract ERC165 is IERC165 {
745     /**
746      * @dev See {IERC165-supportsInterface}.
747      */
748     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
749         return interfaceId == type(IERC165).interfaceId;
750     }
751 }
752 
753 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
754 
755 
756 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
757 
758 pragma solidity ^0.8.0;
759 
760 
761 /**
762  * @dev Required interface of an ERC721 compliant contract.
763  */
764 interface IERC721 is IERC165 {
765     /**
766      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
767      */
768     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
769 
770     /**
771      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
772      */
773     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
774 
775     /**
776      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
777      */
778     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
779 
780     /**
781      * @dev Returns the number of tokens in ``owner``'s account.
782      */
783     function balanceOf(address owner) external view returns (uint256 balance);
784 
785     /**
786      * @dev Returns the owner of the `tokenId` token.
787      *
788      * Requirements:
789      *
790      * - `tokenId` must exist.
791      */
792     function ownerOf(uint256 tokenId) external view returns (address owner);
793 
794     /**
795      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
796      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must exist and be owned by `from`.
803      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
804      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
805      *
806      * Emits a {Transfer} event.
807      */
808     function safeTransferFrom(
809         address from,
810         address to,
811         uint256 tokenId
812     ) external;
813 
814     /**
815      * @dev Transfers `tokenId` token from `from` to `to`.
816      *
817      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
818      *
819      * Requirements:
820      *
821      * - `from` cannot be the zero address.
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must be owned by `from`.
824      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
825      *
826      * Emits a {Transfer} event.
827      */
828     function transferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) external;
833 
834     /**
835      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
836      * The approval is cleared when the token is transferred.
837      *
838      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
839      *
840      * Requirements:
841      *
842      * - The caller must own the token or be an approved operator.
843      * - `tokenId` must exist.
844      *
845      * Emits an {Approval} event.
846      */
847     function approve(address to, uint256 tokenId) external;
848 
849     /**
850      * @dev Returns the account approved for `tokenId` token.
851      *
852      * Requirements:
853      *
854      * - `tokenId` must exist.
855      */
856     function getApproved(uint256 tokenId) external view returns (address operator);
857 
858     /**
859      * @dev Approve or remove `operator` as an operator for the caller.
860      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
861      *
862      * Requirements:
863      *
864      * - The `operator` cannot be the caller.
865      *
866      * Emits an {ApprovalForAll} event.
867      */
868     function setApprovalForAll(address operator, bool _approved) external;
869 
870     /**
871      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
872      *
873      * See {setApprovalForAll}
874      */
875     function isApprovedForAll(address owner, address operator) external view returns (bool);
876 
877     /**
878      * @dev Safely transfers `tokenId` token from `from` to `to`.
879      *
880      * Requirements:
881      *
882      * - `from` cannot be the zero address.
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must exist and be owned by `from`.
885      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
886      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
887      *
888      * Emits a {Transfer} event.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId,
894         bytes calldata data
895     ) external;
896 }
897 
898 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
899 
900 
901 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 
906 /**
907  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
908  * @dev See https://eips.ethereum.org/EIPS/eip-721
909  */
910 interface IERC721Enumerable is IERC721 {
911     /**
912      * @dev Returns the total amount of tokens stored by the contract.
913      */
914     function totalSupply() external view returns (uint256);
915 
916     /**
917      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
918      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
919      */
920     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
921 
922     /**
923      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
924      * Use along with {totalSupply} to enumerate all tokens.
925      */
926     function tokenByIndex(uint256 index) external view returns (uint256);
927 }
928 
929 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
930 
931 
932 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 
937 /**
938  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
939  * @dev See https://eips.ethereum.org/EIPS/eip-721
940  */
941 interface IERC721Metadata is IERC721 {
942     /**
943      * @dev Returns the token collection name.
944      */
945     function name() external view returns (string memory);
946 
947     /**
948      * @dev Returns the token collection symbol.
949      */
950     function symbol() external view returns (string memory);
951 
952     /**
953      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
954      */
955     function tokenURI(uint256 tokenId) external view returns (string memory);
956 }
957 
958 // File: contracts/TwistedToonz.sol
959 
960 
961 // Creator: Chiru Labs
962 
963 pragma solidity ^0.8.0;
964 
965 
966 
967 
968 
969 
970 
971 
972 
973 /**
974  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
975  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
976  *
977  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
978  *
979  * Does not support burning tokens to address(0).
980  *
981  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
982  */
983 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
984     using Address for address;
985     using Strings for uint256;
986 
987     struct TokenOwnership {
988         address addr;
989         uint64 startTimestamp;
990     }
991 
992     struct AddressData {
993         uint128 balance;
994         uint128 numberMinted;
995     }
996 
997     uint256 internal currentIndex;
998 
999     // Token name
1000     string private _name;
1001 
1002     // Token symbol
1003     string private _symbol;
1004 
1005     // Mapping from token ID to ownership details
1006     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1007     mapping(uint256 => TokenOwnership) internal _ownerships;
1008 
1009     // Mapping owner address to address data
1010     mapping(address => AddressData) private _addressData;
1011 
1012     // Mapping from token ID to approved address
1013     mapping(uint256 => address) private _tokenApprovals;
1014 
1015     // Mapping from owner to operator approvals
1016     mapping(address => mapping(address => bool)) private _operatorApprovals;
1017 
1018     constructor(string memory name_, string memory symbol_) {
1019         _name = name_;
1020         _symbol = symbol_;
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Enumerable-totalSupply}.
1025      */
1026     function totalSupply() public view override returns (uint256) {
1027         return currentIndex;
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Enumerable-tokenByIndex}.
1032      */
1033     function tokenByIndex(uint256 index) public view override returns (uint256) {
1034         require(index < totalSupply(), "ERC721A: global index out of bounds");
1035         return index;
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1040      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1041      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1042      */
1043     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1044         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1045         uint256 numMintedSoFar = totalSupply();
1046         uint256 tokenIdsIdx;
1047         address currOwnershipAddr;
1048 
1049         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1050         unchecked {
1051             for (uint256 i; i < numMintedSoFar; i++) {
1052                 TokenOwnership memory ownership = _ownerships[i];
1053                 if (ownership.addr != address(0)) {
1054                     currOwnershipAddr = ownership.addr;
1055                 }
1056                 if (currOwnershipAddr == owner) {
1057                     if (tokenIdsIdx == index) {
1058                         return i;
1059                     }
1060                     tokenIdsIdx++;
1061                 }
1062             }
1063         }
1064 
1065         revert("ERC721A: unable to get token of owner by index");
1066     }
1067 
1068     /**
1069      * @dev See {IERC165-supportsInterface}.
1070      */
1071     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1072         return
1073             interfaceId == type(IERC721).interfaceId ||
1074             interfaceId == type(IERC721Metadata).interfaceId ||
1075             interfaceId == type(IERC721Enumerable).interfaceId ||
1076             super.supportsInterface(interfaceId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-balanceOf}.
1081      */
1082     function balanceOf(address owner) public view override returns (uint256) {
1083         require(owner != address(0), "ERC721A: balance query for the zero address");
1084         return uint256(_addressData[owner].balance);
1085     }
1086 
1087     function _numberMinted(address owner) internal view returns (uint256) {
1088         require(owner != address(0), "ERC721A: number minted query for the zero address");
1089         return uint256(_addressData[owner].numberMinted);
1090     }
1091 
1092     /**
1093      * Gas spent here starts off proportional to the maximum mint batch size.
1094      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1095      */
1096     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1097         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1098 
1099         unchecked {
1100             for (uint256 curr = tokenId; curr >= 0; curr--) {
1101                 TokenOwnership memory ownership = _ownerships[curr];
1102                 if (ownership.addr != address(0)) {
1103                     return ownership;
1104                 }
1105             }
1106         }
1107 
1108         revert("ERC721A: unable to determine the owner of token");
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-ownerOf}.
1113      */
1114     function ownerOf(uint256 tokenId) public view override returns (address) {
1115         return ownershipOf(tokenId).addr;
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Metadata-name}.
1120      */
1121     function name() public view virtual override returns (string memory) {
1122         return _name;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Metadata-symbol}.
1127      */
1128     function symbol() public view virtual override returns (string memory) {
1129         return _symbol;
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Metadata-tokenURI}.
1134      */
1135     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1136         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1137 
1138         string memory baseURI = _baseURI();
1139         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1140     }
1141 
1142     /**
1143      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1144      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1145      * by default, can be overriden in child contracts.
1146      */
1147     function _baseURI() internal view virtual returns (string memory) {
1148         return "";
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-approve}.
1153      */
1154     function approve(address to, uint256 tokenId) public override {
1155         address owner = ERC721A.ownerOf(tokenId);
1156         require(to != owner, "ERC721A: approval to current owner");
1157 
1158         require(
1159             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1160             "ERC721A: approve caller is not owner nor approved for all"
1161         );
1162 
1163         _approve(to, tokenId, owner);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-getApproved}.
1168      */
1169     function getApproved(uint256 tokenId) public view override returns (address) {
1170         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1171 
1172         return _tokenApprovals[tokenId];
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-setApprovalForAll}.
1177      */
1178     function setApprovalForAll(address operator, bool approved) public override {
1179         require(operator != _msgSender(), "ERC721A: approve to caller");
1180 
1181         _operatorApprovals[_msgSender()][operator] = approved;
1182         emit ApprovalForAll(_msgSender(), operator, approved);
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-isApprovedForAll}.
1187      */
1188     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1189         return _operatorApprovals[owner][operator];
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-transferFrom}.
1194      */
1195     function transferFrom(
1196         address from,
1197         address to,
1198         uint256 tokenId
1199     ) public virtual override {
1200         _transfer(from, to, tokenId);
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-safeTransferFrom}.
1205      */
1206     function safeTransferFrom(
1207         address from,
1208         address to,
1209         uint256 tokenId
1210     ) public virtual override {
1211         safeTransferFrom(from, to, tokenId, "");
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-safeTransferFrom}.
1216      */
1217     function safeTransferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId,
1221         bytes memory _data
1222     ) public override {
1223         _transfer(from, to, tokenId);
1224         require(
1225             _checkOnERC721Received(from, to, tokenId, _data),
1226             "ERC721A: transfer to non ERC721Receiver implementer"
1227         );
1228     }
1229 
1230     /**
1231      * @dev Returns whether `tokenId` exists.
1232      *
1233      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1234      *
1235      * Tokens start existing when they are minted (`_mint`),
1236      */
1237     function _exists(uint256 tokenId) internal view returns (bool) {
1238         return tokenId < currentIndex;
1239     }
1240 
1241     function _safeMint(address to, uint256 quantity) internal {
1242         _safeMint(to, quantity, "");
1243     }
1244 
1245     /**
1246      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1247      *
1248      * Requirements:
1249      *
1250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1251      * - `quantity` must be greater than 0.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _safeMint(
1256         address to,
1257         uint256 quantity,
1258         bytes memory _data
1259     ) internal {
1260         _mint(to, quantity, _data, true);
1261     }
1262 
1263     /**
1264      * @dev Mints `quantity` tokens and transfers them to `to`.
1265      *
1266      * Requirements:
1267      *
1268      * - `to` cannot be the zero address.
1269      * - `quantity` must be greater than 0.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function _mint(
1274         address to,
1275         uint256 quantity,
1276         bytes memory _data,
1277         bool safe
1278     ) internal {
1279         uint256 startTokenId = currentIndex;
1280         require(to != address(0), "ERC721A: mint to the zero address");
1281         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1282 
1283         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1284 
1285         // Overflows are incredibly unrealistic.
1286         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1287         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1288         unchecked {
1289             _addressData[to].balance += uint128(quantity);
1290             _addressData[to].numberMinted += uint128(quantity);
1291 
1292             _ownerships[startTokenId].addr = to;
1293             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1294 
1295             uint256 updatedIndex = startTokenId;
1296 
1297             for (uint256 i; i < quantity; i++) {
1298                 emit Transfer(address(0), to, updatedIndex);
1299                 if (safe) {
1300                     require(
1301                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1302                         "ERC721A: transfer to non ERC721Receiver implementer"
1303                     );
1304                 }
1305 
1306                 updatedIndex++;
1307             }
1308 
1309             currentIndex = updatedIndex;
1310         }
1311 
1312         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1313     }
1314 
1315     /**
1316      * @dev Transfers `tokenId` from `from` to `to`.
1317      *
1318      * Requirements:
1319      *
1320      * - `to` cannot be the zero address.
1321      * - `tokenId` token must be owned by `from`.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function _transfer(
1326         address from,
1327         address to,
1328         uint256 tokenId
1329     ) private {
1330         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1331 
1332         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1333             getApproved(tokenId) == _msgSender() ||
1334             isApprovedForAll(prevOwnership.addr, _msgSender()));
1335 
1336         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1337 
1338         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1339         require(to != address(0), "ERC721A: transfer to the zero address");
1340 
1341         _beforeTokenTransfers(from, to, tokenId, 1);
1342 
1343         // Clear approvals from the previous owner
1344         _approve(address(0), tokenId, prevOwnership.addr);
1345 
1346         // Underflow of the sender's balance is impossible because we check for
1347         // ownership above and the recipient's balance can't realistically overflow.
1348         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1349         unchecked {
1350             _addressData[from].balance -= 1;
1351             _addressData[to].balance += 1;
1352 
1353             _ownerships[tokenId].addr = to;
1354             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1355 
1356             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1357             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1358             uint256 nextTokenId = tokenId + 1;
1359             if (_ownerships[nextTokenId].addr == address(0)) {
1360                 if (_exists(nextTokenId)) {
1361                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1362                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1363                 }
1364             }
1365         }
1366 
1367         emit Transfer(from, to, tokenId);
1368         _afterTokenTransfers(from, to, tokenId, 1);
1369     }
1370 
1371     /**
1372      * @dev Approve `to` to operate on `tokenId`
1373      *
1374      * Emits a {Approval} event.
1375      */
1376     function _approve(
1377         address to,
1378         uint256 tokenId,
1379         address owner
1380     ) private {
1381         _tokenApprovals[tokenId] = to;
1382         emit Approval(owner, to, tokenId);
1383     }
1384 
1385     /**
1386      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1387      * The call is not executed if the target address is not a contract.
1388      *
1389      * @param from address representing the previous owner of the given token ID
1390      * @param to target address that will receive the tokens
1391      * @param tokenId uint256 ID of the token to be transferred
1392      * @param _data bytes optional data to send along with the call
1393      * @return bool whether the call correctly returned the expected magic value
1394      */
1395     function _checkOnERC721Received(
1396         address from,
1397         address to,
1398         uint256 tokenId,
1399         bytes memory _data
1400     ) private returns (bool) {
1401         if (to.isContract()) {
1402             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1403                 return retval == IERC721Receiver(to).onERC721Received.selector;
1404             } catch (bytes memory reason) {
1405                 if (reason.length == 0) {
1406                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1407                 } else {
1408                     assembly {
1409                         revert(add(32, reason), mload(reason))
1410                     }
1411                 }
1412             }
1413         } else {
1414             return true;
1415         }
1416     }
1417 
1418     /**
1419      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1420      *
1421      * startTokenId - the first token id to be transferred
1422      * quantity - the amount to be transferred
1423      *
1424      * Calling conditions:
1425      *
1426      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1427      * transferred to `to`.
1428      * - When `from` is zero, `tokenId` will be minted for `to`.
1429      */
1430     function _beforeTokenTransfers(
1431         address from,
1432         address to,
1433         uint256 startTokenId,
1434         uint256 quantity
1435     ) internal virtual {}
1436 
1437     /**
1438      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1439      * minting.
1440      *
1441      * startTokenId - the first token id to be transferred
1442      * quantity - the amount to be transferred
1443      *
1444      * Calling conditions:
1445      *
1446      * - when `from` and `to` are both non-zero.
1447      * - `from` and `to` are never both zero.
1448      */
1449     function _afterTokenTransfers(
1450         address from,
1451         address to,
1452         uint256 startTokenId,
1453         uint256 quantity
1454     ) internal virtual {}
1455 }
1456 
1457 contract HalloweenApeYachtClub is ERC721A, Ownable, ReentrancyGuard {
1458 
1459   uint public     nextOwnerToExplicitlySet;
1460   string public   baseURI;
1461   uint public     maxPerTx          = 30;
1462   uint public     maxPerWallet      = 60;
1463   uint public     maxSupply         = 10000;
1464   uint public     price             = 0.001 ether;
1465   bool public     mintEnabled;
1466 
1467   constructor() ERC721A("Halloween Ape Yacht Club", "HAYC"){}
1468 
1469   function reserve(uint256 amt) external onlyOwner{
1470     require(totalSupply() + amt < maxSupply + 1,"Not enough to reserve.");
1471     _safeMint(msg.sender, amt);
1472   }
1473 
1474   function mint(uint256 amt) external payable{
1475     require( amt < maxPerTx + 1, "Max per transaction exceeded.");
1476     require(msg.sender == tx.origin,"You are not the sender.");
1477     require(numberMinted(msg.sender) + amt <= maxPerWallet,"Wallet limit reached!");
1478     require(totalSupply() + amt < maxSupply + 1,"SOLD OUT!");
1479     require(msg.value == amt * price,"The amount is not correct ser.");
1480     require(mintEnabled, "Not minting yet.");
1481     _safeMint(msg.sender, amt);
1482   }
1483 
1484   function setBaseURI(string calldata baseURI_) external onlyOwner {
1485     baseURI = baseURI_;
1486   }
1487 
1488   function setPrice(uint256 price_) external onlyOwner {
1489       price = price_;
1490   }
1491 
1492   function toggleMint() external onlyOwner {
1493       mintEnabled = !mintEnabled;
1494   }
1495 
1496   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1497       maxPerTx = maxPerTx_;
1498   }
1499 
1500   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1501       maxPerWallet = maxPerWallet_;
1502   }
1503 
1504   function setMaxSupply(uint256 maxSupply_) external onlyOwner {
1505       maxSupply = maxSupply_;
1506   }
1507 
1508   function _baseURI() internal view virtual override returns (string memory) {
1509     return baseURI;
1510   }
1511 
1512   function withdraw() external onlyOwner nonReentrant {
1513     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1514     require(success, "Transfer failed.");
1515   }
1516 
1517   function numberMinted(address owner) public view returns (uint256) {
1518     return _numberMinted(owner);
1519   }
1520 
1521   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1522     _setOwnersExplicit(quantity);
1523   }
1524 
1525   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1526     return ownershipOf(tokenId);
1527   }
1528 
1529 
1530   /**
1531     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1532     */
1533   function _setOwnersExplicit(uint256 quantity) internal {
1534       require(quantity != 0, "quantity must be nonzero");
1535       require(currentIndex != 0, "no tokens minted yet");
1536       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1537       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1538 
1539       // Index underflow is impossible.
1540       // Counter or index overflow is incredibly unrealistic.
1541       unchecked {
1542           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1543 
1544           // Set the end index to be the last token index
1545           if (endIndex + 1 > currentIndex) {
1546               endIndex = currentIndex - 1;
1547           }
1548 
1549           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1550               if (_ownerships[i].addr == address(0)) {
1551                   TokenOwnership memory ownership = ownershipOf(i);
1552                   _ownerships[i].addr = ownership.addr;
1553                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1554               }
1555           }
1556 
1557           nextOwnerToExplicitlySet = endIndex + 1;
1558       }
1559   }
1560 }