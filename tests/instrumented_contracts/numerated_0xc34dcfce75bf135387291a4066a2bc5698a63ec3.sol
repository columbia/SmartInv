1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `to`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address to, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `from` to `to` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address from,
68         address to,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Contract module that helps prevent reentrant calls to a function.
96  *
97  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
98  * available, which can be applied to functions to make sure there are no nested
99  * (reentrant) calls to them.
100  *
101  * Note that because there is a single `nonReentrant` guard, functions marked as
102  * `nonReentrant` may not call one another. This can be worked around by making
103  * those functions `private`, and then adding `external` `nonReentrant` entry
104  * points to them.
105  *
106  * TIP: If you would like to learn more about reentrancy and alternative ways
107  * to protect against it, check out our blog post
108  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
109  */
110 abstract contract ReentrancyGuard {
111     // Booleans are more expensive than uint256 or any type that takes up a full
112     // word because each write operation emits an extra SLOAD to first read the
113     // slot's contents, replace the bits taken up by the boolean, and then write
114     // back. This is the compiler's defense against contract upgrades and
115     // pointer aliasing, and it cannot be disabled.
116 
117     // The values being non-zero value makes deployment a bit more expensive,
118     // but in exchange the refund on every call to nonReentrant will be lower in
119     // amount. Since refunds are capped to a percentage of the total
120     // transaction's gas, it is best to keep them low in cases like this one, to
121     // increase the likelihood of the full refund coming into effect.
122     uint256 private constant _NOT_ENTERED = 1;
123     uint256 private constant _ENTERED = 2;
124 
125     uint256 private _status;
126 
127     constructor() {
128         _status = _NOT_ENTERED;
129     }
130 
131     /**
132      * @dev Prevents a contract from calling itself, directly or indirectly.
133      * Calling a `nonReentrant` function from another `nonReentrant`
134      * function is not supported. It is possible to prevent this from happening
135      * by making the `nonReentrant` function external, and making it call a
136      * `private` function that does the actual work.
137      */
138     modifier nonReentrant() {
139         // On the first call to nonReentrant, _notEntered will be true
140         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
141 
142         // Any calls to nonReentrant after this point will fail
143         _status = _ENTERED;
144 
145         _;
146 
147         // By storing the original value once again, a refund is triggered (see
148         // https://eips.ethereum.org/EIPS/eip-2200)
149         _status = _NOT_ENTERED;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/utils/Strings.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @dev String operations.
162  */
163 library Strings {
164     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
168      */
169     function toString(uint256 value) internal pure returns (string memory) {
170         // Inspired by OraclizeAPI's implementation - MIT licence
171         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
172 
173         if (value == 0) {
174             return "0";
175         }
176         uint256 temp = value;
177         uint256 digits;
178         while (temp != 0) {
179             digits++;
180             temp /= 10;
181         }
182         bytes memory buffer = new bytes(digits);
183         while (value != 0) {
184             digits -= 1;
185             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
186             value /= 10;
187         }
188         return string(buffer);
189     }
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
193      */
194     function toHexString(uint256 value) internal pure returns (string memory) {
195         if (value == 0) {
196             return "0x00";
197         }
198         uint256 temp = value;
199         uint256 length = 0;
200         while (temp != 0) {
201             length++;
202             temp >>= 8;
203         }
204         return toHexString(value, length);
205     }
206 
207     /**
208      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
209      */
210     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
211         bytes memory buffer = new bytes(2 * length + 2);
212         buffer[0] = "0";
213         buffer[1] = "x";
214         for (uint256 i = 2 * length + 1; i > 1; --i) {
215             buffer[i] = _HEX_SYMBOLS[value & 0xf];
216             value >>= 4;
217         }
218         require(value == 0, "Strings: hex length insufficient");
219         return string(buffer);
220     }
221 }
222 
223 // File: @openzeppelin/contracts/utils/Context.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 abstract contract Context {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes calldata) {
246         return msg.data;
247     }
248 }
249 
250 // File: @openzeppelin/contracts/access/Ownable.sol
251 
252 
253 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * By default, the owner account will be the one that deploys the contract. This
264  * can later be changed with {transferOwnership}.
265  *
266  * This module is used through inheritance. It will make available the modifier
267  * `onlyOwner`, which can be applied to your functions to restrict their use to
268  * the owner.
269  */
270 abstract contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor() {
279         _transferOwnership(_msgSender());
280     }
281 
282     /**
283      * @dev Returns the address of the current owner.
284      */
285     function owner() public view virtual returns (address) {
286         return _owner;
287     }
288 
289     /**
290      * @dev Throws if called by any account other than the owner.
291      */
292     modifier onlyOwner() {
293         require(owner() == _msgSender(), "Ownable: caller is not the owner");
294         _;
295     }
296 
297     /**
298      * @dev Leaves the contract without owner. It will not be possible to call
299      * `onlyOwner` functions anymore. Can only be called by the current owner.
300      *
301      * NOTE: Renouncing ownership will leave the contract without an owner,
302      * thereby removing any functionality that is only available to the owner.
303      */
304     function renounceOwnership() public virtual onlyOwner {
305         _transferOwnership(address(0));
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      * Can only be called by the current owner.
311      */
312     function transferOwnership(address newOwner) public virtual onlyOwner {
313         require(newOwner != address(0), "Ownable: new owner is the zero address");
314         _transferOwnership(newOwner);
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Internal function without access restriction.
320      */
321     function _transferOwnership(address newOwner) internal virtual {
322         address oldOwner = _owner;
323         _owner = newOwner;
324         emit OwnershipTransferred(oldOwner, newOwner);
325     }
326 }
327 
328 // File: @openzeppelin/contracts/utils/Address.sol
329 
330 
331 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
332 
333 pragma solidity ^0.8.1;
334 
335 /**
336  * @dev Collection of functions related to the address type
337  */
338 library Address {
339     /**
340      * @dev Returns true if `account` is a contract.
341      *
342      * [IMPORTANT]
343      * ====
344      * It is unsafe to assume that an address for which this function returns
345      * false is an externally-owned account (EOA) and not a contract.
346      *
347      * Among others, `isContract` will return false for the following
348      * types of addresses:
349      *
350      *  - an externally-owned account
351      *  - a contract in construction
352      *  - an address where a contract will be created
353      *  - an address where a contract lived, but was destroyed
354      * ====
355      *
356      * [IMPORTANT]
357      * ====
358      * You shouldn't rely on `isContract` to protect against flash loan attacks!
359      *
360      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
361      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
362      * constructor.
363      * ====
364      */
365     function isContract(address account) internal view returns (bool) {
366         // This method relies on extcodesize/address.code.length, which returns 0
367         // for contracts in construction, since the code is only stored at the end
368         // of the constructor execution.
369 
370         return account.code.length > 0;
371     }
372 
373     /**
374      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375      * `recipient`, forwarding all available gas and reverting on errors.
376      *
377      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378      * of certain opcodes, possibly making contracts go over the 2300 gas limit
379      * imposed by `transfer`, making them unable to receive funds via
380      * `transfer`. {sendValue} removes this limitation.
381      *
382      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383      *
384      * IMPORTANT: because control is transferred to `recipient`, care must be
385      * taken to not create reentrancy vulnerabilities. Consider using
386      * {ReentrancyGuard} or the
387      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388      */
389     function sendValue(address payable recipient, uint256 amount) internal {
390         require(address(this).balance >= amount, "Address: insufficient balance");
391 
392         (bool success, ) = recipient.call{value: amount}("");
393         require(success, "Address: unable to send value, recipient may have reverted");
394     }
395 
396     /**
397      * @dev Performs a Solidity function call using a low level `call`. A
398      * plain `call` is an unsafe replacement for a function call: use this
399      * function instead.
400      *
401      * If `target` reverts with a revert reason, it is bubbled up by this
402      * function (like regular Solidity function calls).
403      *
404      * Returns the raw returned data. To convert to the expected return value,
405      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
406      *
407      * Requirements:
408      *
409      * - `target` must be a contract.
410      * - calling `target` with `data` must not revert.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
415         return functionCall(target, data, "Address: low-level call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
420      * `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, 0, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but also transferring `value` wei to `target`.
435      *
436      * Requirements:
437      *
438      * - the calling contract must have an ETH balance of at least `value`.
439      * - the called Solidity function must be `payable`.
440      *
441      * _Available since v3.1._
442      */
443     function functionCallWithValue(
444         address target,
445         bytes memory data,
446         uint256 value
447     ) internal returns (bytes memory) {
448         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
453      * with `errorMessage` as a fallback revert reason when `target` reverts.
454      *
455      * _Available since v3.1._
456      */
457     function functionCallWithValue(
458         address target,
459         bytes memory data,
460         uint256 value,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         require(address(this).balance >= value, "Address: insufficient balance for call");
464         require(isContract(target), "Address: call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.call{value: value}(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a static call.
473      *
474      * _Available since v3.3._
475      */
476     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
477         return functionStaticCall(target, data, "Address: low-level static call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a static call.
483      *
484      * _Available since v3.3._
485      */
486     function functionStaticCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal view returns (bytes memory) {
491         require(isContract(target), "Address: static call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.staticcall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
499      * but performing a delegate call.
500      *
501      * _Available since v3.4._
502      */
503     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
504         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
509      * but performing a delegate call.
510      *
511      * _Available since v3.4._
512      */
513     function functionDelegateCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(isContract(target), "Address: delegate call to non-contract");
519 
520         (bool success, bytes memory returndata) = target.delegatecall(data);
521         return verifyCallResult(success, returndata, errorMessage);
522     }
523 
524     /**
525      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
526      * revert reason using the provided one.
527      *
528      * _Available since v4.3._
529      */
530     function verifyCallResult(
531         bool success,
532         bytes memory returndata,
533         string memory errorMessage
534     ) internal pure returns (bytes memory) {
535         if (success) {
536             return returndata;
537         } else {
538             // Look for revert reason and bubble it up if present
539             if (returndata.length > 0) {
540                 // The easiest way to bubble the revert reason is using memory via assembly
541 
542                 assembly {
543                     let returndata_size := mload(returndata)
544                     revert(add(32, returndata), returndata_size)
545                 }
546             } else {
547                 revert(errorMessage);
548             }
549         }
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 
562 /**
563  * @title SafeERC20
564  * @dev Wrappers around ERC20 operations that throw on failure (when the token
565  * contract returns false). Tokens that return no value (and instead revert or
566  * throw on failure) are also supported, non-reverting calls are assumed to be
567  * successful.
568  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
569  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
570  */
571 library SafeERC20 {
572     using Address for address;
573 
574     function safeTransfer(
575         IERC20 token,
576         address to,
577         uint256 value
578     ) internal {
579         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
580     }
581 
582     function safeTransferFrom(
583         IERC20 token,
584         address from,
585         address to,
586         uint256 value
587     ) internal {
588         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
589     }
590 
591     /**
592      * @dev Deprecated. This function has issues similar to the ones found in
593      * {IERC20-approve}, and its usage is discouraged.
594      *
595      * Whenever possible, use {safeIncreaseAllowance} and
596      * {safeDecreaseAllowance} instead.
597      */
598     function safeApprove(
599         IERC20 token,
600         address spender,
601         uint256 value
602     ) internal {
603         // safeApprove should only be called when setting an initial allowance,
604         // or when resetting it to zero. To increase and decrease it, use
605         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
606         require(
607             (value == 0) || (token.allowance(address(this), spender) == 0),
608             "SafeERC20: approve from non-zero to non-zero allowance"
609         );
610         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
611     }
612 
613     function safeIncreaseAllowance(
614         IERC20 token,
615         address spender,
616         uint256 value
617     ) internal {
618         uint256 newAllowance = token.allowance(address(this), spender) + value;
619         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
620     }
621 
622     function safeDecreaseAllowance(
623         IERC20 token,
624         address spender,
625         uint256 value
626     ) internal {
627         unchecked {
628             uint256 oldAllowance = token.allowance(address(this), spender);
629             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
630             uint256 newAllowance = oldAllowance - value;
631             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
632         }
633     }
634 
635     /**
636      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
637      * on the return value: the return value is optional (but if data is returned, it must not be false).
638      * @param token The token targeted by the call.
639      * @param data The call data (encoded using abi.encode or one of its variants).
640      */
641     function _callOptionalReturn(IERC20 token, bytes memory data) private {
642         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
643         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
644         // the target address contains contract code and also asserts for success in the low-level call.
645 
646         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
647         if (returndata.length > 0) {
648             // Return data is optional
649             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
650         }
651     }
652 }
653 
654 
655 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
656 
657 
658 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @title ERC721 token receiver interface
664  * @dev Interface for any contract that wants to support safeTransfers
665  * from ERC721 asset contracts.
666  */
667 interface IERC721Receiver {
668     /**
669      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
670      * by `operator` from `from`, this function is called.
671      *
672      * It must return its Solidity selector to confirm the token transfer.
673      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
674      *
675      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
676      */
677     function onERC721Received(
678         address operator,
679         address from,
680         uint256 tokenId,
681         bytes calldata data
682     ) external returns (bytes4);
683 }
684 
685 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @dev Interface of the ERC165 standard, as defined in the
694  * https://eips.ethereum.org/EIPS/eip-165[EIP].
695  *
696  * Implementers can declare support of contract interfaces, which can then be
697  * queried by others ({ERC165Checker}).
698  *
699  * For an implementation, see {ERC165}.
700  */
701 interface IERC165 {
702     /**
703      * @dev Returns true if this contract implements the interface defined by
704      * `interfaceId`. See the corresponding
705      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
706      * to learn more about how these ids are created.
707      *
708      * This function call must use less than 30 000 gas.
709      */
710     function supportsInterface(bytes4 interfaceId) external view returns (bool);
711 }
712 
713 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @dev Implementation of the {IERC165} interface.
723  *
724  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
725  * for the additional interface id that will be supported. For example:
726  *
727  * ```solidity
728  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
729  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
730  * }
731  * ```
732  *
733  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
734  */
735 abstract contract ERC165 is IERC165 {
736     /**
737      * @dev See {IERC165-supportsInterface}.
738      */
739     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
740         return interfaceId == type(IERC165).interfaceId;
741     }
742 }
743 
744 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
745 
746 
747 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 /**
753  * @dev Required interface of an ERC721 compliant contract.
754  */
755 interface IERC721 is IERC165 {
756     /**
757      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
758      */
759     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
760 
761     /**
762      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
763      */
764     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
765 
766     /**
767      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
768      */
769     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
770 
771     /**
772      * @dev Returns the number of tokens in ``owner``'s account.
773      */
774     function balanceOf(address owner) external view returns (uint256 balance);
775 
776     /**
777      * @dev Returns the owner of the `tokenId` token.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function ownerOf(uint256 tokenId) external view returns (address owner);
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
787      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must exist and be owned by `from`.
794      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) external;
804 
805     /**
806      * @dev Transfers `tokenId` token from `from` to `to`.
807      *
808      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
816      *
817      * Emits a {Transfer} event.
818      */
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external;
824 
825     /**
826      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
827      * The approval is cleared when the token is transferred.
828      *
829      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
830      *
831      * Requirements:
832      *
833      * - The caller must own the token or be an approved operator.
834      * - `tokenId` must exist.
835      *
836      * Emits an {Approval} event.
837      */
838     function approve(address to, uint256 tokenId) external;
839 
840     /**
841      * @dev Returns the account approved for `tokenId` token.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must exist.
846      */
847     function getApproved(uint256 tokenId) external view returns (address operator);
848 
849     /**
850      * @dev Approve or remove `operator` as an operator for the caller.
851      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
852      *
853      * Requirements:
854      *
855      * - The `operator` cannot be the caller.
856      *
857      * Emits an {ApprovalForAll} event.
858      */
859     function setApprovalForAll(address operator, bool _approved) external;
860 
861     /**
862      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
863      *
864      * See {setApprovalForAll}
865      */
866     function isApprovedForAll(address owner, address operator) external view returns (bool);
867 
868     /**
869      * @dev Safely transfers `tokenId` token from `from` to `to`.
870      *
871      * Requirements:
872      *
873      * - `from` cannot be the zero address.
874      * - `to` cannot be the zero address.
875      * - `tokenId` token must exist and be owned by `from`.
876      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
877      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
878      *
879      * Emits a {Transfer} event.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes calldata data
886     ) external;
887 }
888 
889 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
890 
891 
892 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 
897 /**
898  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
899  * @dev See https://eips.ethereum.org/EIPS/eip-721
900  */
901 interface IERC721Enumerable is IERC721 {
902     /**
903      * @dev Returns the total amount of tokens stored by the contract.
904      */
905     function totalSupply() external view returns (uint256);
906 
907     /**
908      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
909      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
910      */
911     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
912 
913     /**
914      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
915      * Use along with {totalSupply} to enumerate all tokens.
916      */
917     function tokenByIndex(uint256 index) external view returns (uint256);
918 }
919 
920 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
921 
922 
923 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 
928 /**
929  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
930  * @dev See https://eips.ethereum.org/EIPS/eip-721
931  */
932 interface IERC721Metadata is IERC721 {
933     /**
934      * @dev Returns the token collection name.
935      */
936     function name() external view returns (string memory);
937 
938     /**
939      * @dev Returns the token collection symbol.
940      */
941     function symbol() external view returns (string memory);
942 
943     /**
944      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
945      */
946     function tokenURI(uint256 tokenId) external view returns (string memory);
947 }
948 
949 // File: contracts/TwistedToonz.sol
950 
951 
952 // Creator: Chiru Labs
953 
954 pragma solidity ^0.8.0;
955 
956 
957 
958 
959 
960 
961 
962 
963 
964 /**
965  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
966  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
967  *
968  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
969  *
970  * Does not support burning tokens to address(0).
971  *
972  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
973  */
974 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
975     using Address for address;
976     using Strings for uint256;
977 
978     struct TokenOwnership {
979         address addr;
980         uint64 startTimestamp;
981     }
982 
983     struct AddressData {
984         uint128 balance;
985         uint128 numberMinted;
986     }
987 
988     uint256 internal currentIndex;
989 
990     // Token name
991     string private _name;
992 
993     // Token symbol
994     string private _symbol;
995 
996     // Mapping from token ID to ownership details
997     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
998     mapping(uint256 => TokenOwnership) internal _ownerships;
999 
1000     // Mapping owner address to address data
1001     mapping(address => AddressData) private _addressData;
1002 
1003     // Mapping from token ID to approved address
1004     mapping(uint256 => address) private _tokenApprovals;
1005 
1006     // Mapping from owner to operator approvals
1007     mapping(address => mapping(address => bool)) private _operatorApprovals;
1008 
1009     constructor(string memory name_, string memory symbol_) {
1010         _name = name_;
1011         _symbol = symbol_;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Enumerable-totalSupply}.
1016      */
1017     function totalSupply() public view override returns (uint256) {
1018         return currentIndex;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-tokenByIndex}.
1023      */
1024     function tokenByIndex(uint256 index) public view override returns (uint256) {
1025         require(index < totalSupply(), "ERC721A: global index out of bounds");
1026         return index;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1031      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1032      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1033      */
1034     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1035         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1036         uint256 numMintedSoFar = totalSupply();
1037         uint256 tokenIdsIdx;
1038         address currOwnershipAddr;
1039 
1040         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1041         unchecked {
1042             for (uint256 i; i < numMintedSoFar; i++) {
1043                 TokenOwnership memory ownership = _ownerships[i];
1044                 if (ownership.addr != address(0)) {
1045                     currOwnershipAddr = ownership.addr;
1046                 }
1047                 if (currOwnershipAddr == owner) {
1048                     if (tokenIdsIdx == index) {
1049                         return i;
1050                     }
1051                     tokenIdsIdx++;
1052                 }
1053             }
1054         }
1055 
1056         revert("ERC721A: unable to get token of owner by index");
1057     }
1058 
1059     /**
1060      * @dev See {IERC165-supportsInterface}.
1061      */
1062     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1063         return
1064             interfaceId == type(IERC721).interfaceId ||
1065             interfaceId == type(IERC721Metadata).interfaceId ||
1066             interfaceId == type(IERC721Enumerable).interfaceId ||
1067             super.supportsInterface(interfaceId);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-balanceOf}.
1072      */
1073     function balanceOf(address owner) public view override returns (uint256) {
1074         require(owner != address(0), "ERC721A: balance query for the zero address");
1075         return uint256(_addressData[owner].balance);
1076     }
1077 
1078     function _numberMinted(address owner) internal view returns (uint256) {
1079         require(owner != address(0), "ERC721A: number minted query for the zero address");
1080         return uint256(_addressData[owner].numberMinted);
1081     }
1082 
1083     /**
1084      * Gas spent here starts off proportional to the maximum mint batch size.
1085      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1086      */
1087     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1088         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1089 
1090         unchecked {
1091             for (uint256 curr = tokenId; curr >= 0; curr--) {
1092                 TokenOwnership memory ownership = _ownerships[curr];
1093                 if (ownership.addr != address(0)) {
1094                     return ownership;
1095                 }
1096             }
1097         }
1098 
1099         revert("ERC721A: unable to determine the owner of token");
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-ownerOf}.
1104      */
1105     function ownerOf(uint256 tokenId) public view override returns (address) {
1106         return ownershipOf(tokenId).addr;
1107     }
1108 
1109     /**
1110      * @dev See {IERC721Metadata-name}.
1111      */
1112     function name() public view virtual override returns (string memory) {
1113         return _name;
1114     }
1115 
1116     /**
1117      * @dev See {IERC721Metadata-symbol}.
1118      */
1119     function symbol() public view virtual override returns (string memory) {
1120         return _symbol;
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Metadata-tokenURI}.
1125      */
1126     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1127         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1128 
1129         string memory baseURI = _baseURI();
1130         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1131     }
1132 
1133     /**
1134      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1135      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1136      * by default, can be overriden in child contracts.
1137      */
1138     function _baseURI() internal view virtual returns (string memory) {
1139         return "";
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-approve}.
1144      */
1145     function approve(address to, uint256 tokenId) public override {
1146         address owner = ERC721A.ownerOf(tokenId);
1147         require(to != owner, "ERC721A: approval to current owner");
1148 
1149         require(
1150             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1151             "ERC721A: approve caller is not owner nor approved for all"
1152         );
1153 
1154         _approve(to, tokenId, owner);
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-getApproved}.
1159      */
1160     function getApproved(uint256 tokenId) public view override returns (address) {
1161         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1162 
1163         return _tokenApprovals[tokenId];
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-setApprovalForAll}.
1168      */
1169     function setApprovalForAll(address operator, bool approved) public override {
1170         require(operator != _msgSender(), "ERC721A: approve to caller");
1171 
1172         _operatorApprovals[_msgSender()][operator] = approved;
1173         emit ApprovalForAll(_msgSender(), operator, approved);
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-isApprovedForAll}.
1178      */
1179     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1180         return _operatorApprovals[owner][operator];
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-transferFrom}.
1185      */
1186     function transferFrom(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) public virtual override {
1191         _transfer(from, to, tokenId);
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-safeTransferFrom}.
1196      */
1197     function safeTransferFrom(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) public virtual override {
1202         safeTransferFrom(from, to, tokenId, "");
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-safeTransferFrom}.
1207      */
1208     function safeTransferFrom(
1209         address from,
1210         address to,
1211         uint256 tokenId,
1212         bytes memory _data
1213     ) public override {
1214         _transfer(from, to, tokenId);
1215         require(
1216             _checkOnERC721Received(from, to, tokenId, _data),
1217             "ERC721A: transfer to non ERC721Receiver implementer"
1218         );
1219     }
1220 
1221     /**
1222      * @dev Returns whether `tokenId` exists.
1223      *
1224      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1225      *
1226      * Tokens start existing when they are minted (`_mint`),
1227      */
1228     function _exists(uint256 tokenId) internal view returns (bool) {
1229         return tokenId < currentIndex;
1230     }
1231 
1232     function _safeMint(address to, uint256 quantity) internal {
1233         _safeMint(to, quantity, "");
1234     }
1235 
1236     /**
1237      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1238      *
1239      * Requirements:
1240      *
1241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1242      * - `quantity` must be greater than 0.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _safeMint(
1247         address to,
1248         uint256 quantity,
1249         bytes memory _data
1250     ) internal {
1251         _mint(to, quantity, _data, true);
1252     }
1253 
1254     /**
1255      * @dev Mints `quantity` tokens and transfers them to `to`.
1256      *
1257      * Requirements:
1258      *
1259      * - `to` cannot be the zero address.
1260      * - `quantity` must be greater than 0.
1261      *
1262      * Emits a {Transfer} event.
1263      */
1264     function _mint(
1265         address to,
1266         uint256 quantity,
1267         bytes memory _data,
1268         bool safe
1269     ) internal {
1270         uint256 startTokenId = currentIndex;
1271         require(to != address(0), "ERC721A: mint to the zero address");
1272         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1273 
1274         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1275 
1276         // Overflows are incredibly unrealistic.
1277         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1278         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1279         unchecked {
1280             _addressData[to].balance += uint128(quantity);
1281             _addressData[to].numberMinted += uint128(quantity);
1282 
1283             _ownerships[startTokenId].addr = to;
1284             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1285 
1286             uint256 updatedIndex = startTokenId;
1287 
1288             for (uint256 i; i < quantity; i++) {
1289                 emit Transfer(address(0), to, updatedIndex);
1290                 if (safe) {
1291                     require(
1292                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1293                         "ERC721A: transfer to non ERC721Receiver implementer"
1294                     );
1295                 }
1296 
1297                 updatedIndex++;
1298             }
1299 
1300             currentIndex = updatedIndex;
1301         }
1302 
1303         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1304     }
1305 
1306     /**
1307      * @dev Transfers `tokenId` from `from` to `to`.
1308      *
1309      * Requirements:
1310      *
1311      * - `to` cannot be the zero address.
1312      * - `tokenId` token must be owned by `from`.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _transfer(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) private {
1321         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1322 
1323         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1324             getApproved(tokenId) == _msgSender() ||
1325             isApprovedForAll(prevOwnership.addr, _msgSender()));
1326 
1327         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1328 
1329         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1330         require(to != address(0), "ERC721A: transfer to the zero address");
1331 
1332         _beforeTokenTransfers(from, to, tokenId, 1);
1333 
1334         // Clear approvals from the previous owner
1335         _approve(address(0), tokenId, prevOwnership.addr);
1336 
1337         // Underflow of the sender's balance is impossible because we check for
1338         // ownership above and the recipient's balance can't realistically overflow.
1339         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1340         unchecked {
1341             _addressData[from].balance -= 1;
1342             _addressData[to].balance += 1;
1343 
1344             _ownerships[tokenId].addr = to;
1345             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1346 
1347             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1348             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1349             uint256 nextTokenId = tokenId + 1;
1350             if (_ownerships[nextTokenId].addr == address(0)) {
1351                 if (_exists(nextTokenId)) {
1352                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1353                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1354                 }
1355             }
1356         }
1357 
1358         emit Transfer(from, to, tokenId);
1359         _afterTokenTransfers(from, to, tokenId, 1);
1360     }
1361 
1362     /**
1363      * @dev Approve `to` to operate on `tokenId`
1364      *
1365      * Emits a {Approval} event.
1366      */
1367     function _approve(
1368         address to,
1369         uint256 tokenId,
1370         address owner
1371     ) private {
1372         _tokenApprovals[tokenId] = to;
1373         emit Approval(owner, to, tokenId);
1374     }
1375 
1376     /**
1377      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1378      * The call is not executed if the target address is not a contract.
1379      *
1380      * @param from address representing the previous owner of the given token ID
1381      * @param to target address that will receive the tokens
1382      * @param tokenId uint256 ID of the token to be transferred
1383      * @param _data bytes optional data to send along with the call
1384      * @return bool whether the call correctly returned the expected magic value
1385      */
1386     function _checkOnERC721Received(
1387         address from,
1388         address to,
1389         uint256 tokenId,
1390         bytes memory _data
1391     ) private returns (bool) {
1392         if (to.isContract()) {
1393             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1394                 return retval == IERC721Receiver(to).onERC721Received.selector;
1395             } catch (bytes memory reason) {
1396                 if (reason.length == 0) {
1397                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1398                 } else {
1399                     assembly {
1400                         revert(add(32, reason), mload(reason))
1401                     }
1402                 }
1403             }
1404         } else {
1405             return true;
1406         }
1407     }
1408 
1409     /**
1410      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1411      *
1412      * startTokenId - the first token id to be transferred
1413      * quantity - the amount to be transferred
1414      *
1415      * Calling conditions:
1416      *
1417      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1418      * transferred to `to`.
1419      * - When `from` is zero, `tokenId` will be minted for `to`.
1420      */
1421     function _beforeTokenTransfers(
1422         address from,
1423         address to,
1424         uint256 startTokenId,
1425         uint256 quantity
1426     ) internal virtual {}
1427 
1428     /**
1429      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1430      * minting.
1431      *
1432      * startTokenId - the first token id to be transferred
1433      * quantity - the amount to be transferred
1434      *
1435      * Calling conditions:
1436      *
1437      * - when `from` and `to` are both non-zero.
1438      * - `from` and `to` are never both zero.
1439      */
1440     function _afterTokenTransfers(
1441         address from,
1442         address to,
1443         uint256 startTokenId,
1444         uint256 quantity
1445     ) internal virtual {}
1446 }
1447 
1448 contract LordsOfTheTower is ERC721A, Ownable, ReentrancyGuard {
1449 
1450 
1451   using Strings for uint256;
1452   string public        baseURI;
1453   uint public          price             = 0.003 ether;
1454   uint public          maxPerTx          = 3;
1455   uint public          totalFree         = 1000;
1456   uint public          maxSupply         = 3333;
1457   bool public          mintEnabled;
1458 
1459 
1460   constructor() ERC721A("Lords of the Tower", "LordsOfTheTower"){
1461   }
1462 
1463   function mint(uint256 amount) external payable
1464   {
1465     uint cost = price;
1466     if(totalSupply() + amount < totalFree + 1) {
1467       cost = 0;
1468     }
1469     require(mintEnabled, "Minting is not live yet, hold on lords");
1470     require(totalSupply() + amount < maxSupply + 1,"No more lords");
1471     require(msg.value == amount * cost,"Please send the exact amount");
1472     require(amount < maxPerTx + 1, "Max per TX reached");
1473     
1474     _safeMint(msg.sender, amount);
1475   }
1476 
1477   function ownerBatchMint(uint256 amount) external onlyOwner
1478   {
1479     require(totalSupply() + amount < maxSupply + 1,"too many!");
1480 
1481     _safeMint(msg.sender, amount);
1482   }
1483 
1484   function toggleMinting() external onlyOwner {
1485       mintEnabled = !mintEnabled;
1486   }
1487 
1488   function numberMinted(address owner) public view returns (uint256) {
1489     return _numberMinted(owner);
1490   }
1491 
1492   function setBaseURI(string calldata baseURI_) external onlyOwner {
1493     baseURI = baseURI_;
1494   }
1495 
1496   function setPrice(uint256 price_) external onlyOwner {
1497       price = price_;
1498   }
1499 
1500   function setTotalFree(uint256 totalFree_) external onlyOwner {
1501       totalFree = totalFree_;
1502   }
1503 
1504   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1505       maxPerTx = maxPerTx_;
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
1517 }