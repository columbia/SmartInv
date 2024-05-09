1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-11
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /**
8  * @title NotABC contract
9  * @dev Extends ERC721A - thanks azuki
10  */
11 
12 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
13 
14 
15 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `to`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address to, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `from` to `to` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address from,
78         address to,
79         uint256 amount
80     ) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Contract module that helps prevent reentrant calls to a function.
106  *
107  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
108  * available, which can be applied to functions to make sure there are no nested
109  * (reentrant) calls to them.
110  *
111  * Note that because there is a single `nonReentrant` guard, functions marked as
112  * `nonReentrant` may not call one another. This can be worked around by making
113  * those functions `private`, and then adding `external` `nonReentrant` entry
114  * points to them.
115  *
116  * TIP: If you would like to learn more about reentrancy and alternative ways
117  * to protect against it, check out our blog post
118  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
119  */
120 abstract contract ReentrancyGuard {
121     // Booleans are more expensive than uint256 or any type that takes up a full
122     // word because each write operation emits an extra SLOAD to first read the
123     // slot's contents, replace the bits taken up by the boolean, and then write
124     // back. This is the compiler's defense against contract upgrades and
125     // pointer aliasing, and it cannot be disabled.
126 
127     // The values being non-zero value makes deployment a bit more expensive,
128     // but in exchange the refund on every call to nonReentrant will be lower in
129     // amount. Since refunds are capped to a percentage of the total
130     // transaction's gas, it is best to keep them low in cases like this one, to
131     // increase the likelihood of the full refund coming into effect.
132     uint256 private constant _NOT_ENTERED = 1;
133     uint256 private constant _ENTERED = 2;
134 
135     uint256 private _status;
136 
137     constructor() {
138         _status = _NOT_ENTERED;
139     }
140 
141     /**
142      * @dev Prevents a contract from calling itself, directly or indirectly.
143      * Calling a `nonReentrant` function from another `nonReentrant`
144      * function is not supported. It is possible to prevent this from happening
145      * by making the `nonReentrant` function external, and making it call a
146      * `private` function that does the actual work.
147      */
148     modifier nonReentrant() {
149         // On the first call to nonReentrant, _notEntered will be true
150         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
151 
152         // Any calls to nonReentrant after this point will fail
153         _status = _ENTERED;
154 
155         _;
156 
157         // By storing the original value once again, a refund is triggered (see
158         // https://eips.ethereum.org/EIPS/eip-2200)
159         _status = _NOT_ENTERED;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/utils/Strings.sol
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 /**
171  * @dev String operations.
172  */
173 library Strings {
174     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
178      */
179     function toString(uint256 value) internal pure returns (string memory) {
180         // Inspired by OraclizeAPI's implementation - MIT licence
181         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
182 
183         if (value == 0) {
184             return "0";
185         }
186         uint256 temp = value;
187         uint256 digits;
188         while (temp != 0) {
189             digits++;
190             temp /= 10;
191         }
192         bytes memory buffer = new bytes(digits);
193         while (value != 0) {
194             digits -= 1;
195             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
196             value /= 10;
197         }
198         return string(buffer);
199     }
200 
201     /**
202      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
203      */
204     function toHexString(uint256 value) internal pure returns (string memory) {
205         if (value == 0) {
206             return "0x00";
207         }
208         uint256 temp = value;
209         uint256 length = 0;
210         while (temp != 0) {
211             length++;
212             temp >>= 8;
213         }
214         return toHexString(value, length);
215     }
216 
217     /**
218      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
219      */
220     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
221         bytes memory buffer = new bytes(2 * length + 2);
222         buffer[0] = "0";
223         buffer[1] = "x";
224         for (uint256 i = 2 * length + 1; i > 1; --i) {
225             buffer[i] = _HEX_SYMBOLS[value & 0xf];
226             value >>= 4;
227         }
228         require(value == 0, "Strings: hex length insufficient");
229         return string(buffer);
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/Context.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Provides information about the current execution context, including the
242  * sender of the transaction and its data. While these are generally available
243  * via msg.sender and msg.data, they should not be accessed in such a direct
244  * manner, since when dealing with meta-transactions the account sending and
245  * paying for execution may not be the actual sender (as far as an application
246  * is concerned).
247  *
248  * This contract is only required for intermediate, library-like contracts.
249  */
250 abstract contract Context {
251     function _msgSender() internal view virtual returns (address) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view virtual returns (bytes calldata) {
256         return msg.data;
257     }
258 }
259 
260 // File: @openzeppelin/contracts/access/Ownable.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 
268 /**
269  * @dev Contract module which provides a basic access control mechanism, where
270  * there is an account (an owner) that can be granted exclusive access to
271  * specific functions.
272  *
273  * By default, the owner account will be the one that deploys the contract. This
274  * can later be changed with {transferOwnership}.
275  *
276  * This module is used through inheritance. It will make available the modifier
277  * `onlyOwner`, which can be applied to your functions to restrict their use to
278  * the owner.
279  */
280 abstract contract Ownable is Context {
281     address private _owner;
282 
283     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285     /**
286      * @dev Initializes the contract setting the deployer as the initial owner.
287      */
288     constructor() {
289         _transferOwnership(_msgSender());
290     }
291 
292     /**
293      * @dev Returns the address of the current owner.
294      */
295     function owner() public view virtual returns (address) {
296         return _owner;
297     }
298 
299     /**
300      * @dev Throws if called by any account other than the owner.
301      */
302     modifier onlyOwner() {
303         require(owner() == _msgSender(), "Ownable: caller is not the owner");
304         _;
305     }
306 
307     /**
308      * @dev Leaves the contract without owner. It will not be possible to call
309      * `onlyOwner` functions anymore. Can only be called by the current owner.
310      *
311      * NOTE: Renouncing ownership will leave the contract without an owner,
312      * thereby removing any functionality that is only available to the owner.
313      */
314     function renounceOwnership() public virtual onlyOwner {
315         _transferOwnership(address(0));
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322     function transferOwnership(address newOwner) public virtual onlyOwner {
323         require(newOwner != address(0), "Ownable: new owner is the zero address");
324         _transferOwnership(newOwner);
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Internal function without access restriction.
330      */
331     function _transferOwnership(address newOwner) internal virtual {
332         address oldOwner = _owner;
333         _owner = newOwner;
334         emit OwnershipTransferred(oldOwner, newOwner);
335     }
336 }
337 
338 // File: @openzeppelin/contracts/utils/Address.sol
339 
340 
341 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
342 
343 pragma solidity ^0.8.1;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      *
366      * [IMPORTANT]
367      * ====
368      * You shouldn't rely on `isContract` to protect against flash loan attacks!
369      *
370      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
371      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
372      * constructor.
373      * ====
374      */
375     function isContract(address account) internal view returns (bool) {
376         // This method relies on extcodesize/address.code.length, which returns 0
377         // for contracts in construction, since the code is only stored at the end
378         // of the constructor execution.
379 
380         return account.code.length > 0;
381     }
382 
383     /**
384      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385      * `recipient`, forwarding all available gas and reverting on errors.
386      *
387      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388      * of certain opcodes, possibly making contracts go over the 2300 gas limit
389      * imposed by `transfer`, making them unable to receive funds via
390      * `transfer`. {sendValue} removes this limitation.
391      *
392      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393      *
394      * IMPORTANT: because control is transferred to `recipient`, care must be
395      * taken to not create reentrancy vulnerabilities. Consider using
396      * {ReentrancyGuard} or the
397      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398      */
399     function sendValue(address payable recipient, uint256 amount) internal {
400         require(address(this).balance >= amount, "Address: insufficient balance");
401 
402         (bool success, ) = recipient.call{value: amount}("");
403         require(success, "Address: unable to send value, recipient may have reverted");
404     }
405 
406     /**
407      * @dev Performs a Solidity function call using a low level `call`. A
408      * plain `call` is an unsafe replacement for a function call: use this
409      * function instead.
410      *
411      * If `target` reverts with a revert reason, it is bubbled up by this
412      * function (like regular Solidity function calls).
413      *
414      * Returns the raw returned data. To convert to the expected return value,
415      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
416      *
417      * Requirements:
418      *
419      * - `target` must be a contract.
420      * - calling `target` with `data` must not revert.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
425         return functionCall(target, data, "Address: low-level call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
430      * `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, 0, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but also transferring `value` wei to `target`.
445      *
446      * Requirements:
447      *
448      * - the calling contract must have an ETH balance of at least `value`.
449      * - the called Solidity function must be `payable`.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value
457     ) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
463      * with `errorMessage` as a fallback revert reason when `target` reverts.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(
468         address target,
469         bytes memory data,
470         uint256 value,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(address(this).balance >= value, "Address: insufficient balance for call");
474         require(isContract(target), "Address: call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.call{value: value}(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but performing a static call.
483      *
484      * _Available since v3.3._
485      */
486     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
487         return functionStaticCall(target, data, "Address: low-level static call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(
497         address target,
498         bytes memory data,
499         string memory errorMessage
500     ) internal view returns (bytes memory) {
501         require(isContract(target), "Address: static call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.staticcall(data);
504         return verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a delegate call.
510      *
511      * _Available since v3.4._
512      */
513     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
514         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
519      * but performing a delegate call.
520      *
521      * _Available since v3.4._
522      */
523     function functionDelegateCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal returns (bytes memory) {
528         require(isContract(target), "Address: delegate call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.delegatecall(data);
531         return verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
536      * revert reason using the provided one.
537      *
538      * _Available since v4.3._
539      */
540     function verifyCallResult(
541         bool success,
542         bytes memory returndata,
543         string memory errorMessage
544     ) internal pure returns (bytes memory) {
545         if (success) {
546             return returndata;
547         } else {
548             // Look for revert reason and bubble it up if present
549             if (returndata.length > 0) {
550                 // The easiest way to bubble the revert reason is using memory via assembly
551 
552                 assembly {
553                     let returndata_size := mload(returndata)
554                     revert(add(32, returndata), returndata_size)
555                 }
556             } else {
557                 revert(errorMessage);
558             }
559         }
560     }
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
564 
565 
566 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 
571 
572 /**
573  * @title SafeERC20
574  * @dev Wrappers around ERC20 operations that throw on failure (when the token
575  * contract returns false). Tokens that return no value (and instead revert or
576  * throw on failure) are also supported, non-reverting calls are assumed to be
577  * successful.
578  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
579  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
580  */
581 library SafeERC20 {
582     using Address for address;
583 
584     function safeTransfer(
585         IERC20 token,
586         address to,
587         uint256 value
588     ) internal {
589         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
590     }
591 
592     function safeTransferFrom(
593         IERC20 token,
594         address from,
595         address to,
596         uint256 value
597     ) internal {
598         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
599     }
600 
601     /**
602      * @dev Deprecated. This function has issues similar to the ones found in
603      * {IERC20-approve}, and its usage is discouraged.
604      *
605      * Whenever possible, use {safeIncreaseAllowance} and
606      * {safeDecreaseAllowance} instead.
607      */
608     function safeApprove(
609         IERC20 token,
610         address spender,
611         uint256 value
612     ) internal {
613         // safeApprove should only be called when setting an initial allowance,
614         // or when resetting it to zero. To increase and decrease it, use
615         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
616         require(
617             (value == 0) || (token.allowance(address(this), spender) == 0),
618             "SafeERC20: approve from non-zero to non-zero allowance"
619         );
620         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
621     }
622 
623     function safeIncreaseAllowance(
624         IERC20 token,
625         address spender,
626         uint256 value
627     ) internal {
628         uint256 newAllowance = token.allowance(address(this), spender) + value;
629         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
630     }
631 
632     function safeDecreaseAllowance(
633         IERC20 token,
634         address spender,
635         uint256 value
636     ) internal {
637         unchecked {
638             uint256 oldAllowance = token.allowance(address(this), spender);
639             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
640             uint256 newAllowance = oldAllowance - value;
641             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
642         }
643     }
644 
645     /**
646      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
647      * on the return value: the return value is optional (but if data is returned, it must not be false).
648      * @param token The token targeted by the call.
649      * @param data The call data (encoded using abi.encode or one of its variants).
650      */
651     function _callOptionalReturn(IERC20 token, bytes memory data) private {
652         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
653         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
654         // the target address contains contract code and also asserts for success in the low-level call.
655 
656         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
657         if (returndata.length > 0) {
658             // Return data is optional
659             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
660         }
661     }
662 }
663 
664 
665 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @title ERC721 token receiver interface
674  * @dev Interface for any contract that wants to support safeTransfers
675  * from ERC721 asset contracts.
676  */
677 interface IERC721Receiver {
678     /**
679      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
680      * by `operator` from `from`, this function is called.
681      *
682      * It must return its Solidity selector to confirm the token transfer.
683      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
684      *
685      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
686      */
687     function onERC721Received(
688         address operator,
689         address from,
690         uint256 tokenId,
691         bytes calldata data
692     ) external returns (bytes4);
693 }
694 
695 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
696 
697 
698 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 /**
703  * @dev Interface of the ERC165 standard, as defined in the
704  * https://eips.ethereum.org/EIPS/eip-165[EIP].
705  *
706  * Implementers can declare support of contract interfaces, which can then be
707  * queried by others ({ERC165Checker}).
708  *
709  * For an implementation, see {ERC165}.
710  */
711 interface IERC165 {
712     /**
713      * @dev Returns true if this contract implements the interface defined by
714      * `interfaceId`. See the corresponding
715      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
716      * to learn more about how these ids are created.
717      *
718      * This function call must use less than 30 000 gas.
719      */
720     function supportsInterface(bytes4 interfaceId) external view returns (bool);
721 }
722 
723 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @dev Implementation of the {IERC165} interface.
733  *
734  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
735  * for the additional interface id that will be supported. For example:
736  *
737  * ```solidity
738  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
739  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
740  * }
741  * ```
742  *
743  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
744  */
745 abstract contract ERC165 is IERC165 {
746     /**
747      * @dev See {IERC165-supportsInterface}.
748      */
749     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
750         return interfaceId == type(IERC165).interfaceId;
751     }
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @dev Required interface of an ERC721 compliant contract.
764  */
765 interface IERC721 is IERC165 {
766     /**
767      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
768      */
769     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
770 
771     /**
772      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
773      */
774     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
775 
776     /**
777      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
778      */
779     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
780 
781     /**
782      * @dev Returns the number of tokens in ``owner``'s account.
783      */
784     function balanceOf(address owner) external view returns (uint256 balance);
785 
786     /**
787      * @dev Returns the owner of the `tokenId` token.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must exist.
792      */
793     function ownerOf(uint256 tokenId) external view returns (address owner);
794 
795     /**
796      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
797      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
798      *
799      * Requirements:
800      *
801      * - `from` cannot be the zero address.
802      * - `to` cannot be the zero address.
803      * - `tokenId` token must exist and be owned by `from`.
804      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
805      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
806      *
807      * Emits a {Transfer} event.
808      */
809     function safeTransferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) external;
814 
815     /**
816      * @dev Transfers `tokenId` token from `from` to `to`.
817      *
818      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
819      *
820      * Requirements:
821      *
822      * - `from` cannot be the zero address.
823      * - `to` cannot be the zero address.
824      * - `tokenId` token must be owned by `from`.
825      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
826      *
827      * Emits a {Transfer} event.
828      */
829     function transferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) external;
834 
835     /**
836      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
837      * The approval is cleared when the token is transferred.
838      *
839      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
840      *
841      * Requirements:
842      *
843      * - The caller must own the token or be an approved operator.
844      * - `tokenId` must exist.
845      *
846      * Emits an {Approval} event.
847      */
848     function approve(address to, uint256 tokenId) external;
849 
850     /**
851      * @dev Returns the account approved for `tokenId` token.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      */
857     function getApproved(uint256 tokenId) external view returns (address operator);
858 
859     /**
860      * @dev Approve or remove `operator` as an operator for the caller.
861      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
862      *
863      * Requirements:
864      *
865      * - The `operator` cannot be the caller.
866      *
867      * Emits an {ApprovalForAll} event.
868      */
869     function setApprovalForAll(address operator, bool _approved) external;
870 
871     /**
872      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
873      *
874      * See {setApprovalForAll}
875      */
876     function isApprovedForAll(address owner, address operator) external view returns (bool);
877 
878     /**
879      * @dev Safely transfers `tokenId` token from `from` to `to`.
880      *
881      * Requirements:
882      *
883      * - `from` cannot be the zero address.
884      * - `to` cannot be the zero address.
885      * - `tokenId` token must exist and be owned by `from`.
886      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
887      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
888      *
889      * Emits a {Transfer} event.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes calldata data
896     ) external;
897 }
898 
899 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
900 
901 
902 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 
907 /**
908  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
909  * @dev See https://eips.ethereum.org/EIPS/eip-721
910  */
911 interface IERC721Enumerable is IERC721 {
912     /**
913      * @dev Returns the total amount of tokens stored by the contract.
914      */
915     function totalSupply() external view returns (uint256);
916 
917     /**
918      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
919      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
920      */
921     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
922 
923     /**
924      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
925      * Use along with {totalSupply} to enumerate all tokens.
926      */
927     function tokenByIndex(uint256 index) external view returns (uint256);
928 }
929 
930 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
931 
932 
933 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 
938 /**
939  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
940  * @dev See https://eips.ethereum.org/EIPS/eip-721
941  */
942 interface IERC721Metadata is IERC721 {
943     /**
944      * @dev Returns the token collection name.
945      */
946     function name() external view returns (string memory);
947 
948     /**
949      * @dev Returns the token collection symbol.
950      */
951     function symbol() external view returns (string memory);
952 
953     /**
954      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
955      */
956     function tokenURI(uint256 tokenId) external view returns (string memory);
957 }
958 
959 // File: contracts/TwistedToonz.sol
960 
961 
962 // Creator: Chiru Labs
963 
964 pragma solidity ^0.8.0;
965 
966 
967 
968 
969 
970 
971 
972 
973 
974 /**
975  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
976  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
977  *
978  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
979  *
980  * Does not support burning tokens to address(0).
981  *
982  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
983  */
984 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
985     using Address for address;
986     using Strings for uint256;
987 
988     struct TokenOwnership {
989         address addr;
990         uint64 startTimestamp;
991     }
992 
993     struct AddressData {
994         uint128 balance;
995         uint128 numberMinted;
996     }
997 
998     uint256 internal currentIndex;
999 
1000     // Token name
1001     string private _name;
1002 
1003     // Token symbol
1004     string private _symbol;
1005 
1006     // Mapping from token ID to ownership details
1007     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1008     mapping(uint256 => TokenOwnership) internal _ownerships;
1009 
1010     // Mapping owner address to address data
1011     mapping(address => AddressData) private _addressData;
1012 
1013     // Mapping from token ID to approved address
1014     mapping(uint256 => address) private _tokenApprovals;
1015 
1016     // Mapping from owner to operator approvals
1017     mapping(address => mapping(address => bool)) private _operatorApprovals;
1018 
1019     constructor(string memory name_, string memory symbol_) {
1020         _name = name_;
1021         _symbol = symbol_;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Enumerable-totalSupply}.
1026      */
1027     function totalSupply() public view override returns (uint256) {
1028         return currentIndex;
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Enumerable-tokenByIndex}.
1033      */
1034     function tokenByIndex(uint256 index) public view override returns (uint256) {
1035         require(index < totalSupply(), "ERC721A: global index out of bounds");
1036         return index;
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1041      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1042      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1043      */
1044     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1045         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1046         uint256 numMintedSoFar = totalSupply();
1047         uint256 tokenIdsIdx;
1048         address currOwnershipAddr;
1049 
1050         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1051         unchecked {
1052             for (uint256 i; i < numMintedSoFar; i++) {
1053                 TokenOwnership memory ownership = _ownerships[i];
1054                 if (ownership.addr != address(0)) {
1055                     currOwnershipAddr = ownership.addr;
1056                 }
1057                 if (currOwnershipAddr == owner) {
1058                     if (tokenIdsIdx == index) {
1059                         return i;
1060                     }
1061                     tokenIdsIdx++;
1062                 }
1063             }
1064         }
1065 
1066         revert("ERC721A: unable to get token of owner by index");
1067     }
1068 
1069     /**
1070      * @dev See {IERC165-supportsInterface}.
1071      */
1072     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1073         return
1074             interfaceId == type(IERC721).interfaceId ||
1075             interfaceId == type(IERC721Metadata).interfaceId ||
1076             interfaceId == type(IERC721Enumerable).interfaceId ||
1077             super.supportsInterface(interfaceId);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-balanceOf}.
1082      */
1083     function balanceOf(address owner) public view override returns (uint256) {
1084         require(owner != address(0), "ERC721A: balance query for the zero address");
1085         return uint256(_addressData[owner].balance);
1086     }
1087 
1088     function _numberMinted(address owner) internal view returns (uint256) {
1089         require(owner != address(0), "ERC721A: number minted query for the zero address");
1090         return uint256(_addressData[owner].numberMinted);
1091     }
1092 
1093     /**
1094      * Gas spent here starts off proportional to the maximum mint batch size.
1095      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1096      */
1097     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1098         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1099 
1100         unchecked {
1101             for (uint256 curr = tokenId; curr >= 0; curr--) {
1102                 TokenOwnership memory ownership = _ownerships[curr];
1103                 if (ownership.addr != address(0)) {
1104                     return ownership;
1105                 }
1106             }
1107         }
1108 
1109         revert("ERC721A: unable to determine the owner of token");
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-ownerOf}.
1114      */
1115     function ownerOf(uint256 tokenId) public view override returns (address) {
1116         return ownershipOf(tokenId).addr;
1117     }
1118 
1119     /**
1120      * @dev See {IERC721Metadata-name}.
1121      */
1122     function name() public view virtual override returns (string memory) {
1123         return _name;
1124     }
1125 
1126     /**
1127      * @dev See {IERC721Metadata-symbol}.
1128      */
1129     function symbol() public view virtual override returns (string memory) {
1130         return _symbol;
1131     }
1132 
1133     /**
1134      * @dev See {IERC721Metadata-tokenURI}.
1135      */
1136     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1137         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1138 
1139         string memory baseURI = _baseURI();
1140         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1141     }
1142 
1143     /**
1144      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1145      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1146      * by default, can be overriden in child contracts.
1147      */
1148     function _baseURI() internal view virtual returns (string memory) {
1149         return "";
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-approve}.
1154      */
1155     function approve(address to, uint256 tokenId) public override {
1156         address owner = ERC721A.ownerOf(tokenId);
1157         require(to != owner, "ERC721A: approval to current owner");
1158 
1159         require(
1160             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1161             "ERC721A: approve caller is not owner nor approved for all"
1162         );
1163 
1164         _approve(to, tokenId, owner);
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-getApproved}.
1169      */
1170     function getApproved(uint256 tokenId) public view override returns (address) {
1171         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1172 
1173         return _tokenApprovals[tokenId];
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-setApprovalForAll}.
1178      */
1179     function setApprovalForAll(address operator, bool approved) public override {
1180         require(operator != _msgSender(), "ERC721A: approve to caller");
1181 
1182         _operatorApprovals[_msgSender()][operator] = approved;
1183         emit ApprovalForAll(_msgSender(), operator, approved);
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-isApprovedForAll}.
1188      */
1189     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1190         return _operatorApprovals[owner][operator];
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-transferFrom}.
1195      */
1196     function transferFrom(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) public virtual override {
1201         _transfer(from, to, tokenId);
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-safeTransferFrom}.
1206      */
1207     function safeTransferFrom(
1208         address from,
1209         address to,
1210         uint256 tokenId
1211     ) public virtual override {
1212         safeTransferFrom(from, to, tokenId, "");
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-safeTransferFrom}.
1217      */
1218     function safeTransferFrom(
1219         address from,
1220         address to,
1221         uint256 tokenId,
1222         bytes memory _data
1223     ) public override {
1224         _transfer(from, to, tokenId);
1225         require(
1226             _checkOnERC721Received(from, to, tokenId, _data),
1227             "ERC721A: transfer to non ERC721Receiver implementer"
1228         );
1229     }
1230 
1231     /**
1232      * @dev Returns whether `tokenId` exists.
1233      *
1234      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1235      *
1236      * Tokens start existing when they are minted (`_mint`),
1237      */
1238     function _exists(uint256 tokenId) internal view returns (bool) {
1239         return tokenId < currentIndex;
1240     }
1241 
1242     function _safeMint(address to, uint256 quantity) internal {
1243         _safeMint(to, quantity, "");
1244     }
1245 
1246     /**
1247      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1248      *
1249      * Requirements:
1250      *
1251      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1252      * - `quantity` must be greater than 0.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _safeMint(
1257         address to,
1258         uint256 quantity,
1259         bytes memory _data
1260     ) internal {
1261         _mint(to, quantity, _data, true);
1262     }
1263 
1264     /**
1265      * @dev Mints `quantity` tokens and transfers them to `to`.
1266      *
1267      * Requirements:
1268      *
1269      * - `to` cannot be the zero address.
1270      * - `quantity` must be greater than 0.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _mint(
1275         address to,
1276         uint256 quantity,
1277         bytes memory _data,
1278         bool safe
1279     ) internal {
1280         uint256 startTokenId = currentIndex;
1281         require(to != address(0), "ERC721A: mint to the zero address");
1282         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1283 
1284         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1285 
1286         // Overflows are incredibly unrealistic.
1287         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1288         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1289         unchecked {
1290             _addressData[to].balance += uint128(quantity);
1291             _addressData[to].numberMinted += uint128(quantity);
1292 
1293             _ownerships[startTokenId].addr = to;
1294             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1295 
1296             uint256 updatedIndex = startTokenId;
1297 
1298             for (uint256 i; i < quantity; i++) {
1299                 emit Transfer(address(0), to, updatedIndex);
1300                 if (safe) {
1301                     require(
1302                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1303                         "ERC721A: transfer to non ERC721Receiver implementer"
1304                     );
1305                 }
1306 
1307                 updatedIndex++;
1308             }
1309 
1310             currentIndex = updatedIndex;
1311         }
1312 
1313         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1314     }
1315 
1316     /**
1317      * @dev Transfers `tokenId` from `from` to `to`.
1318      *
1319      * Requirements:
1320      *
1321      * - `to` cannot be the zero address.
1322      * - `tokenId` token must be owned by `from`.
1323      *
1324      * Emits a {Transfer} event.
1325      */
1326     function _transfer(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) private {
1331         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1332 
1333         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1334             getApproved(tokenId) == _msgSender() ||
1335             isApprovedForAll(prevOwnership.addr, _msgSender()));
1336 
1337         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1338 
1339         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1340         require(to != address(0), "ERC721A: transfer to the zero address");
1341 
1342         _beforeTokenTransfers(from, to, tokenId, 1);
1343 
1344         // Clear approvals from the previous owner
1345         _approve(address(0), tokenId, prevOwnership.addr);
1346 
1347         // Underflow of the sender's balance is impossible because we check for
1348         // ownership above and the recipient's balance can't realistically overflow.
1349         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1350         unchecked {
1351             _addressData[from].balance -= 1;
1352             _addressData[to].balance += 1;
1353 
1354             _ownerships[tokenId].addr = to;
1355             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1356 
1357             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1358             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1359             uint256 nextTokenId = tokenId + 1;
1360             if (_ownerships[nextTokenId].addr == address(0)) {
1361                 if (_exists(nextTokenId)) {
1362                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1363                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1364                 }
1365             }
1366         }
1367 
1368         emit Transfer(from, to, tokenId);
1369         _afterTokenTransfers(from, to, tokenId, 1);
1370     }
1371 
1372     /**
1373      * @dev Approve `to` to operate on `tokenId`
1374      *
1375      * Emits a {Approval} event.
1376      */
1377     function _approve(
1378         address to,
1379         uint256 tokenId,
1380         address owner
1381     ) private {
1382         _tokenApprovals[tokenId] = to;
1383         emit Approval(owner, to, tokenId);
1384     }
1385 
1386     /**
1387      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1388      * The call is not executed if the target address is not a contract.
1389      *
1390      * @param from address representing the previous owner of the given token ID
1391      * @param to target address that will receive the tokens
1392      * @param tokenId uint256 ID of the token to be transferred
1393      * @param _data bytes optional data to send along with the call
1394      * @return bool whether the call correctly returned the expected magic value
1395      */
1396     function _checkOnERC721Received(
1397         address from,
1398         address to,
1399         uint256 tokenId,
1400         bytes memory _data
1401     ) private returns (bool) {
1402         if (to.isContract()) {
1403             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1404                 return retval == IERC721Receiver(to).onERC721Received.selector;
1405             } catch (bytes memory reason) {
1406                 if (reason.length == 0) {
1407                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1408                 } else {
1409                     assembly {
1410                         revert(add(32, reason), mload(reason))
1411                     }
1412                 }
1413             }
1414         } else {
1415             return true;
1416         }
1417     }
1418 
1419     /**
1420      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1421      *
1422      * startTokenId - the first token id to be transferred
1423      * quantity - the amount to be transferred
1424      *
1425      * Calling conditions:
1426      *
1427      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1428      * transferred to `to`.
1429      * - When `from` is zero, `tokenId` will be minted for `to`.
1430      */
1431     function _beforeTokenTransfers(
1432         address from,
1433         address to,
1434         uint256 startTokenId,
1435         uint256 quantity
1436     ) internal virtual {}
1437 
1438     /**
1439      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1440      * minting.
1441      *
1442      * startTokenId - the first token id to be transferred
1443      * quantity - the amount to be transferred
1444      *
1445      * Calling conditions:
1446      *
1447      * - when `from` and `to` are both non-zero.
1448      * - `from` and `to` are never both zero.
1449      */
1450     function _afterTokenTransfers(
1451         address from,
1452         address to,
1453         uint256 startTokenId,
1454         uint256 quantity
1455     ) internal virtual {}
1456 }
1457 
1458 contract NotABC is ERC721A, Ownable, ReentrancyGuard {
1459 
1460   string public        baseURI;
1461   uint public          price             = 0.0025 ether;
1462   uint public          maxPerTx          = 10;
1463   uint public          maxFreePerWallet  = 2;
1464   uint public          totalFree         = 9997;
1465   uint public          maxSupply         = 9997;
1466   uint public          nextOwnerToExplicitlySet;
1467   bool public          mintEnabled;
1468 
1469   constructor() ERC721A("NotABC", "NotABC"){}
1470 
1471     modifier callerIsUser() {
1472         require(tx.origin == msg.sender, "The caller is another contract");
1473         _;
1474     }
1475 
1476   function freeMint(uint256 amt) external callerIsUser {
1477     require(mintEnabled, "Minting is not live yet, hold on...");
1478     require(totalSupply() + amt <= totalFree, "Reached max free supply");
1479     require(amt <= 10, "can not mint this many free at a time");
1480     require(numberMinted(msg.sender) + amt <= maxFreePerWallet,"Too many free per wallet!");
1481     _safeMint(msg.sender, amt);
1482     }
1483 
1484   function mint(uint256 amt) external payable
1485   {
1486     uint cost = price;
1487     require(msg.sender == tx.origin,"The caller is another contract");
1488     require(msg.value >= amt * cost,"Please send the exact amount.");
1489     require(totalSupply() + amt < maxSupply + 1,"Reached max supply");
1490     require(mintEnabled, "Minting is not live yet, hold on...");
1491     require( amt < maxPerTx + 1, "Max per TX reached.");
1492 
1493     _safeMint(msg.sender, amt);
1494   }
1495 
1496   function ownerMint(uint256 amt) external onlyOwner
1497   {
1498     require(totalSupply() + amt < maxSupply + 1,"too many!");
1499 
1500     _safeMint(msg.sender, amt);
1501   }
1502 
1503   function toggleMinting() external onlyOwner {
1504       mintEnabled = !mintEnabled;
1505   }
1506 
1507   function numberMinted(address owner) public view returns (uint256) {
1508     return _numberMinted(owner);
1509   }
1510 
1511   function setBaseURI(string calldata baseURI_) external onlyOwner {
1512     baseURI = baseURI_;
1513   }
1514 
1515   function setPrice(uint256 price_) external onlyOwner {
1516       price = price_;
1517   }
1518 
1519   function setTotalFree(uint256 totalFree_) external onlyOwner {
1520       totalFree = totalFree_;
1521   }
1522 
1523   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1524       maxPerTx = maxPerTx_;
1525   }
1526 
1527   function setMaxPerWallet(uint256 maxFreePerWallet_) external onlyOwner {
1528       maxFreePerWallet = maxFreePerWallet_;
1529   }
1530 
1531   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1532       maxSupply = maxSupply_;
1533   }
1534 
1535   function _baseURI() internal view virtual override returns (string memory) {
1536     return baseURI;
1537   }
1538 
1539   function withdraw() external onlyOwner nonReentrant {
1540     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1541     require(success, "Transfer failed.");
1542   }
1543 
1544   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1545     _setOwnersExplicit(quantity);
1546   }
1547 
1548   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1549   {
1550     return ownershipOf(tokenId);
1551   }
1552 
1553 
1554   /**
1555     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1556     */
1557   function _setOwnersExplicit(uint256 quantity) internal {
1558       require(quantity != 0, "quantity must be nonzero");
1559       require(currentIndex != 0, "no tokens minted yet");
1560       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1561       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1562 
1563       // Index underflow is impossible.
1564       // Counter or index overflow is incredibly unrealistic.
1565       unchecked {
1566           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1567 
1568           // Set the end index to be the last token index
1569           if (endIndex + 1 > currentIndex) {
1570               endIndex = currentIndex - 1;
1571           }
1572 
1573           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1574               if (_ownerships[i].addr == address(0)) {
1575                   TokenOwnership memory ownership = ownershipOf(i);
1576                   _ownerships[i].addr = ownership.addr;
1577                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1578               }
1579           }
1580 
1581           nextOwnerToExplicitlySet = endIndex + 1;
1582       }
1583   }
1584 }