1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-03
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
8 
9 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `to`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address to, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `from` to `to` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address from,
72         address to,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
92 
93 
94 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Contract module that helps prevent reentrant calls to a function.
100  *
101  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
102  * available, which can be applied to functions to make sure there are no nested
103  * (reentrant) calls to them.
104  *
105  * Note that because there is a single `nonReentrant` guard, functions marked as
106  * `nonReentrant` may not call one another. This can be worked around by making
107  * those functions `private`, and then adding `external` `nonReentrant` entry
108  * points to them.
109  *
110  * TIP: If you would like to learn more about reentrancy and alternative ways
111  * to protect against it, check out our blog post
112  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
113  */
114 abstract contract ReentrancyGuard {
115     // Booleans are more expensive than uint256 or any type that takes up a full
116     // word because each write operation emits an extra SLOAD to first read the
117     // slot's contents, replace the bits taken up by the boolean, and then write
118     // back. This is the compiler's defense against contract upgrades and
119     // pointer aliasing, and it cannot be disabled.
120 
121     // The values being non-zero value makes deployment a bit more expensive,
122     // but in exchange the refund on every call to nonReentrant will be lower in
123     // amount. Since refunds are capped to a percentage of the total
124     // transaction's gas, it is best to keep them low in cases like this one, to
125     // increase the likelihood of the full refund coming into effect.
126     uint256 private constant _NOT_ENTERED = 1;
127     uint256 private constant _ENTERED = 2;
128 
129     uint256 private _status;
130 
131     constructor() {
132         _status = _NOT_ENTERED;
133     }
134 
135     /**
136      * @dev Prevents a contract from calling itself, directly or indirectly.
137      * Calling a `nonReentrant` function from another `nonReentrant`
138      * function is not supported. It is possible to prevent this from happening
139      * by making the `nonReentrant` function external, and making it call a
140      * `private` function that does the actual work.
141      */
142     modifier nonReentrant() {
143         // On the first call to nonReentrant, _notEntered will be true
144         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
145 
146         // Any calls to nonReentrant after this point will fail
147         _status = _ENTERED;
148 
149         _;
150 
151         // By storing the original value once again, a refund is triggered (see
152         // https://eips.ethereum.org/EIPS/eip-2200)
153         _status = _NOT_ENTERED;
154     }
155 }
156 
157 // File: @openzeppelin/contracts/utils/Strings.sol
158 
159 
160 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 /**
165  * @dev String operations.
166  */
167 library Strings {
168     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
169 
170     /**
171      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
172      */
173     function toString(uint256 value) internal pure returns (string memory) {
174         // Inspired by OraclizeAPI's implementation - MIT licence
175         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
176 
177         if (value == 0) {
178             return "0";
179         }
180         uint256 temp = value;
181         uint256 digits;
182         while (temp != 0) {
183             digits++;
184             temp /= 10;
185         }
186         bytes memory buffer = new bytes(digits);
187         while (value != 0) {
188             digits -= 1;
189             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
190             value /= 10;
191         }
192         return string(buffer);
193     }
194 
195     /**
196      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
197      */
198     function toHexString(uint256 value) internal pure returns (string memory) {
199         if (value == 0) {
200             return "0x00";
201         }
202         uint256 temp = value;
203         uint256 length = 0;
204         while (temp != 0) {
205             length++;
206             temp >>= 8;
207         }
208         return toHexString(value, length);
209     }
210 
211     /**
212      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
213      */
214     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
215         bytes memory buffer = new bytes(2 * length + 2);
216         buffer[0] = "0";
217         buffer[1] = "x";
218         for (uint256 i = 2 * length + 1; i > 1; --i) {
219             buffer[i] = _HEX_SYMBOLS[value & 0xf];
220             value >>= 4;
221         }
222         require(value == 0, "Strings: hex length insufficient");
223         return string(buffer);
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/Context.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes calldata) {
250         return msg.data;
251     }
252 }
253 
254 // File: @openzeppelin/contracts/access/Ownable.sol
255 
256 
257 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * By default, the owner account will be the one that deploys the contract. This
268  * can later be changed with {transferOwnership}.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 abstract contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor() {
283         _transferOwnership(_msgSender());
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view virtual returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
298         _;
299     }
300 
301     /**
302      * @dev Leaves the contract without owner. It will not be possible to call
303      * `onlyOwner` functions anymore. Can only be called by the current owner.
304      *
305      * NOTE: Renouncing ownership will leave the contract without an owner,
306      * thereby removing any functionality that is only available to the owner.
307      */
308     function renounceOwnership() public virtual onlyOwner {
309         _transferOwnership(address(0));
310     }
311 
312     /**
313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
314      * Can only be called by the current owner.
315      */
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(newOwner != address(0), "Ownable: new owner is the zero address");
318         _transferOwnership(newOwner);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Internal function without access restriction.
324      */
325     function _transferOwnership(address newOwner) internal virtual {
326         address oldOwner = _owner;
327         _owner = newOwner;
328         emit OwnershipTransferred(oldOwner, newOwner);
329     }
330 }
331 
332 // File: @openzeppelin/contracts/utils/Address.sol
333 
334 
335 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
336 
337 pragma solidity ^0.8.1;
338 
339 /**
340  * @dev Collection of functions related to the address type
341  */
342 library Address {
343     /**
344      * @dev Returns true if `account` is a contract.
345      *
346      * [IMPORTANT]
347      * ====
348      * It is unsafe to assume that an address for which this function returns
349      * false is an externally-owned account (EOA) and not a contract.
350      *
351      * Among others, `isContract` will return false for the following
352      * types of addresses:
353      *
354      *  - an externally-owned account
355      *  - a contract in construction
356      *  - an address where a contract will be created
357      *  - an address where a contract lived, but was destroyed
358      * ====
359      *
360      * [IMPORTANT]
361      * ====
362      * You shouldn't rely on `isContract` to protect against flash loan attacks!
363      *
364      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
365      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
366      * constructor.
367      * ====
368      */
369     function isContract(address account) internal view returns (bool) {
370         // This method relies on extcodesize/address.code.length, which returns 0
371         // for contracts in construction, since the code is only stored at the end
372         // of the constructor execution.
373 
374         return account.code.length > 0;
375     }
376 
377     /**
378      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
379      * `recipient`, forwarding all available gas and reverting on errors.
380      *
381      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
382      * of certain opcodes, possibly making contracts go over the 2300 gas limit
383      * imposed by `transfer`, making them unable to receive funds via
384      * `transfer`. {sendValue} removes this limitation.
385      *
386      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
387      *
388      * IMPORTANT: because control is transferred to `recipient`, care must be
389      * taken to not create reentrancy vulnerabilities. Consider using
390      * {ReentrancyGuard} or the
391      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
392      */
393     function sendValue(address payable recipient, uint256 amount) internal {
394         require(address(this).balance >= amount, "Address: insufficient balance");
395 
396         (bool success, ) = recipient.call{value: amount}("");
397         require(success, "Address: unable to send value, recipient may have reverted");
398     }
399 
400     /**
401      * @dev Performs a Solidity function call using a low level `call`. A
402      * plain `call` is an unsafe replacement for a function call: use this
403      * function instead.
404      *
405      * If `target` reverts with a revert reason, it is bubbled up by this
406      * function (like regular Solidity function calls).
407      *
408      * Returns the raw returned data. To convert to the expected return value,
409      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
410      *
411      * Requirements:
412      *
413      * - `target` must be a contract.
414      * - calling `target` with `data` must not revert.
415      *
416      * _Available since v3.1._
417      */
418     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
419         return functionCall(target, data, "Address: low-level call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
424      * `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, 0, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but also transferring `value` wei to `target`.
439      *
440      * Requirements:
441      *
442      * - the calling contract must have an ETH balance of at least `value`.
443      * - the called Solidity function must be `payable`.
444      *
445      * _Available since v3.1._
446      */
447     function functionCallWithValue(
448         address target,
449         bytes memory data,
450         uint256 value
451     ) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
457      * with `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCallWithValue(
462         address target,
463         bytes memory data,
464         uint256 value,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         require(address(this).balance >= value, "Address: insufficient balance for call");
468         require(isContract(target), "Address: call to non-contract");
469 
470         (bool success, bytes memory returndata) = target.call{value: value}(data);
471         return verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but performing a static call.
477      *
478      * _Available since v3.3._
479      */
480     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
481         return functionStaticCall(target, data, "Address: low-level static call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
486      * but performing a static call.
487      *
488      * _Available since v3.3._
489      */
490     function functionStaticCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal view returns (bytes memory) {
495         require(isContract(target), "Address: static call to non-contract");
496 
497         (bool success, bytes memory returndata) = target.staticcall(data);
498         return verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
503      * but performing a delegate call.
504      *
505      * _Available since v3.4._
506      */
507     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
508         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
513      * but performing a delegate call.
514      *
515      * _Available since v3.4._
516      */
517     function functionDelegateCall(
518         address target,
519         bytes memory data,
520         string memory errorMessage
521     ) internal returns (bytes memory) {
522         require(isContract(target), "Address: delegate call to non-contract");
523 
524         (bool success, bytes memory returndata) = target.delegatecall(data);
525         return verifyCallResult(success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
530      * revert reason using the provided one.
531      *
532      * _Available since v4.3._
533      */
534     function verifyCallResult(
535         bool success,
536         bytes memory returndata,
537         string memory errorMessage
538     ) internal pure returns (bytes memory) {
539         if (success) {
540             return returndata;
541         } else {
542             // Look for revert reason and bubble it up if present
543             if (returndata.length > 0) {
544                 // The easiest way to bubble the revert reason is using memory via assembly
545 
546                 assembly {
547                     let returndata_size := mload(returndata)
548                     revert(add(32, returndata), returndata_size)
549                 }
550             } else {
551                 revert(errorMessage);
552             }
553         }
554     }
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 
566 /**
567  * @title SafeERC20
568  * @dev Wrappers around ERC20 operations that throw on failure (when the token
569  * contract returns false). Tokens that return no value (and instead revert or
570  * throw on failure) are also supported, non-reverting calls are assumed to be
571  * successful.
572  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
573  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
574  */
575 library SafeERC20 {
576     using Address for address;
577 
578     function safeTransfer(
579         IERC20 token,
580         address to,
581         uint256 value
582     ) internal {
583         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
584     }
585 
586     function safeTransferFrom(
587         IERC20 token,
588         address from,
589         address to,
590         uint256 value
591     ) internal {
592         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
593     }
594 
595     /**
596      * @dev Deprecated. This function has issues similar to the ones found in
597      * {IERC20-approve}, and its usage is discouraged.
598      *
599      * Whenever possible, use {safeIncreaseAllowance} and
600      * {safeDecreaseAllowance} instead.
601      */
602     function safeApprove(
603         IERC20 token,
604         address spender,
605         uint256 value
606     ) internal {
607         // safeApprove should only be called when setting an initial allowance,
608         // or when resetting it to zero. To increase and decrease it, use
609         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
610         require(
611             (value == 0) || (token.allowance(address(this), spender) == 0),
612             "SafeERC20: approve from non-zero to non-zero allowance"
613         );
614         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
615     }
616 
617     function safeIncreaseAllowance(
618         IERC20 token,
619         address spender,
620         uint256 value
621     ) internal {
622         uint256 newAllowance = token.allowance(address(this), spender) + value;
623         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
624     }
625 
626     function safeDecreaseAllowance(
627         IERC20 token,
628         address spender,
629         uint256 value
630     ) internal {
631         unchecked {
632             uint256 oldAllowance = token.allowance(address(this), spender);
633             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
634             uint256 newAllowance = oldAllowance - value;
635             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
636         }
637     }
638 
639     /**
640      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
641      * on the return value: the return value is optional (but if data is returned, it must not be false).
642      * @param token The token targeted by the call.
643      * @param data The call data (encoded using abi.encode or one of its variants).
644      */
645     function _callOptionalReturn(IERC20 token, bytes memory data) private {
646         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
647         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
648         // the target address contains contract code and also asserts for success in the low-level call.
649 
650         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
651         if (returndata.length > 0) {
652             // Return data is optional
653             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
654         }
655     }
656 }
657 
658 
659 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @title ERC721 token receiver interface
668  * @dev Interface for any contract that wants to support safeTransfers
669  * from ERC721 asset contracts.
670  */
671 interface IERC721Receiver {
672     /**
673      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
674      * by `operator` from `from`, this function is called.
675      *
676      * It must return its Solidity selector to confirm the token transfer.
677      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
678      *
679      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
680      */
681     function onERC721Received(
682         address operator,
683         address from,
684         uint256 tokenId,
685         bytes calldata data
686     ) external returns (bytes4);
687 }
688 
689 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 /**
697  * @dev Interface of the ERC165 standard, as defined in the
698  * https://eips.ethereum.org/EIPS/eip-165[EIP].
699  *
700  * Implementers can declare support of contract interfaces, which can then be
701  * queried by others ({ERC165Checker}).
702  *
703  * For an implementation, see {ERC165}.
704  */
705 interface IERC165 {
706     /**
707      * @dev Returns true if this contract implements the interface defined by
708      * `interfaceId`. See the corresponding
709      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
710      * to learn more about how these ids are created.
711      *
712      * This function call must use less than 30 000 gas.
713      */
714     function supportsInterface(bytes4 interfaceId) external view returns (bool);
715 }
716 
717 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
718 
719 
720 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @dev Implementation of the {IERC165} interface.
727  *
728  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
729  * for the additional interface id that will be supported. For example:
730  *
731  * ```solidity
732  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
733  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
734  * }
735  * ```
736  *
737  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
738  */
739 abstract contract ERC165 is IERC165 {
740     /**
741      * @dev See {IERC165-supportsInterface}.
742      */
743     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
744         return interfaceId == type(IERC165).interfaceId;
745     }
746 }
747 
748 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
749 
750 
751 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
752 
753 pragma solidity ^0.8.0;
754 
755 
756 /**
757  * @dev Required interface of an ERC721 compliant contract.
758  */
759 interface IERC721 is IERC165 {
760     /**
761      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
762      */
763     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
764 
765     /**
766      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
767      */
768     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
769 
770     /**
771      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
772      */
773     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
774 
775     /**
776      * @dev Returns the number of tokens in ``owner``'s account.
777      */
778     function balanceOf(address owner) external view returns (uint256 balance);
779 
780     /**
781      * @dev Returns the owner of the `tokenId` token.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      */
787     function ownerOf(uint256 tokenId) external view returns (address owner);
788 
789     /**
790      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
791      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must exist and be owned by `from`.
798      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
799      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
800      *
801      * Emits a {Transfer} event.
802      */
803     function safeTransferFrom(
804         address from,
805         address to,
806         uint256 tokenId
807     ) external;
808 
809     /**
810      * @dev Transfers `tokenId` token from `from` to `to`.
811      *
812      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
813      *
814      * Requirements:
815      *
816      * - `from` cannot be the zero address.
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must be owned by `from`.
819      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
820      *
821      * Emits a {Transfer} event.
822      */
823     function transferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) external;
828 
829     /**
830      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
831      * The approval is cleared when the token is transferred.
832      *
833      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
834      *
835      * Requirements:
836      *
837      * - The caller must own the token or be an approved operator.
838      * - `tokenId` must exist.
839      *
840      * Emits an {Approval} event.
841      */
842     function approve(address to, uint256 tokenId) external;
843 
844     /**
845      * @dev Returns the account approved for `tokenId` token.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      */
851     function getApproved(uint256 tokenId) external view returns (address operator);
852 
853     /**
854      * @dev Approve or remove `operator` as an operator for the caller.
855      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
856      *
857      * Requirements:
858      *
859      * - The `operator` cannot be the caller.
860      *
861      * Emits an {ApprovalForAll} event.
862      */
863     function setApprovalForAll(address operator, bool _approved) external;
864 
865     /**
866      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
867      *
868      * See {setApprovalForAll}
869      */
870     function isApprovedForAll(address owner, address operator) external view returns (bool);
871 
872     /**
873      * @dev Safely transfers `tokenId` token from `from` to `to`.
874      *
875      * Requirements:
876      *
877      * - `from` cannot be the zero address.
878      * - `to` cannot be the zero address.
879      * - `tokenId` token must exist and be owned by `from`.
880      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
881      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
882      *
883      * Emits a {Transfer} event.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes calldata data
890     ) external;
891 }
892 
893 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
894 
895 
896 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
897 
898 pragma solidity ^0.8.0;
899 
900 
901 /**
902  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
903  * @dev See https://eips.ethereum.org/EIPS/eip-721
904  */
905 interface IERC721Enumerable is IERC721 {
906     /**
907      * @dev Returns the total amount of tokens stored by the contract.
908      */
909     function totalSupply() external view returns (uint256);
910 
911     /**
912      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
913      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
914      */
915     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
916 
917     /**
918      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
919      * Use along with {totalSupply} to enumerate all tokens.
920      */
921     function tokenByIndex(uint256 index) external view returns (uint256);
922 }
923 
924 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
925 
926 
927 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
928 
929 pragma solidity ^0.8.0;
930 
931 
932 /**
933  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
934  * @dev See https://eips.ethereum.org/EIPS/eip-721
935  */
936 interface IERC721Metadata is IERC721 {
937     /**
938      * @dev Returns the token collection name.
939      */
940     function name() external view returns (string memory);
941 
942     /**
943      * @dev Returns the token collection symbol.
944      */
945     function symbol() external view returns (string memory);
946 
947     /**
948      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
949      */
950     function tokenURI(uint256 tokenId) external view returns (string memory);
951 }
952 
953 // File: contracts/TwistedToonz.sol
954 
955 
956 // Creator: Chiru Labs
957 
958 pragma solidity ^0.8.0;
959 
960 
961 
962 
963 
964 
965 
966 
967 
968 /**
969  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
970  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
971  *
972  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
973  *
974  * Does not support burning tokens to address(0).
975  *
976  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
977  */
978 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
979     using Address for address;
980     using Strings for uint256;
981 
982     struct TokenOwnership {
983         address addr;
984         uint64 startTimestamp;
985     }
986 
987     struct AddressData {
988         uint128 balance;
989         uint128 numberMinted;
990     }
991 
992     uint256 internal currentIndex;
993 
994     // Token name
995     string private _name;
996 
997     // Token symbol
998     string private _symbol;
999 
1000     // Mapping from token ID to ownership details
1001     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1002     mapping(uint256 => TokenOwnership) internal _ownerships;
1003 
1004     // Mapping owner address to address data
1005     mapping(address => AddressData) private _addressData;
1006 
1007     // Mapping from token ID to approved address
1008     mapping(uint256 => address) private _tokenApprovals;
1009 
1010     // Mapping from owner to operator approvals
1011     mapping(address => mapping(address => bool)) private _operatorApprovals;
1012 
1013     constructor(string memory name_, string memory symbol_) {
1014         _name = name_;
1015         _symbol = symbol_;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Enumerable-totalSupply}.
1020      */
1021     function totalSupply() public view override returns (uint256) {
1022         return currentIndex;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-tokenByIndex}.
1027      */
1028     function tokenByIndex(uint256 index) public view override returns (uint256) {
1029         require(index < totalSupply(), "ERC721A: global index out of bounds");
1030         return index;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1035      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1036      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1037      */
1038     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1039         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1040         uint256 numMintedSoFar = totalSupply();
1041         uint256 tokenIdsIdx;
1042         address currOwnershipAddr;
1043 
1044         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1045         unchecked {
1046             for (uint256 i; i < numMintedSoFar; i++) {
1047                 TokenOwnership memory ownership = _ownerships[i];
1048                 if (ownership.addr != address(0)) {
1049                     currOwnershipAddr = ownership.addr;
1050                 }
1051                 if (currOwnershipAddr == owner) {
1052                     if (tokenIdsIdx == index) {
1053                         return i;
1054                     }
1055                     tokenIdsIdx++;
1056                 }
1057             }
1058         }
1059 
1060         revert("ERC721A: unable to get token of owner by index");
1061     }
1062 
1063     /**
1064      * @dev See {IERC165-supportsInterface}.
1065      */
1066     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1067         return
1068             interfaceId == type(IERC721).interfaceId ||
1069             interfaceId == type(IERC721Metadata).interfaceId ||
1070             interfaceId == type(IERC721Enumerable).interfaceId ||
1071             super.supportsInterface(interfaceId);
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-balanceOf}.
1076      */
1077     function balanceOf(address owner) public view override returns (uint256) {
1078         require(owner != address(0), "ERC721A: balance query for the zero address");
1079         return uint256(_addressData[owner].balance);
1080     }
1081 
1082     function _numberMinted(address owner) internal view returns (uint256) {
1083         require(owner != address(0), "ERC721A: number minted query for the zero address");
1084         return uint256(_addressData[owner].numberMinted);
1085     }
1086 
1087     /**
1088      * Gas spent here starts off proportional to the maximum mint batch size.
1089      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1090      */
1091     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1092         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1093 
1094         unchecked {
1095             for (uint256 curr = tokenId; curr >= 0; curr--) {
1096                 TokenOwnership memory ownership = _ownerships[curr];
1097                 if (ownership.addr != address(0)) {
1098                     return ownership;
1099                 }
1100             }
1101         }
1102 
1103         revert("ERC721A: unable to determine the owner of token");
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-ownerOf}.
1108      */
1109     function ownerOf(uint256 tokenId) public view override returns (address) {
1110         return ownershipOf(tokenId).addr;
1111     }
1112 
1113     /**
1114      * @dev See {IERC721Metadata-name}.
1115      */
1116     function name() public view virtual override returns (string memory) {
1117         return _name;
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Metadata-symbol}.
1122      */
1123     function symbol() public view virtual override returns (string memory) {
1124         return _symbol;
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Metadata-tokenURI}.
1129      */
1130     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1131         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1132 
1133         string memory baseURI = _baseURI();
1134         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1135     }
1136 
1137     /**
1138      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1139      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1140      * by default, can be overriden in child contracts.
1141      */
1142     function _baseURI() internal view virtual returns (string memory) {
1143         return "";
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-approve}.
1148      */
1149     function approve(address to, uint256 tokenId) public override {
1150         address owner = ERC721A.ownerOf(tokenId);
1151         require(to != owner, "ERC721A: approval to current owner");
1152 
1153         require(
1154             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1155             "ERC721A: approve caller is not owner nor approved for all"
1156         );
1157 
1158         _approve(to, tokenId, owner);
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-getApproved}.
1163      */
1164     function getApproved(uint256 tokenId) public view override returns (address) {
1165         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1166 
1167         return _tokenApprovals[tokenId];
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-setApprovalForAll}.
1172      */
1173     function setApprovalForAll(address operator, bool approved) public override {
1174         require(operator != _msgSender(), "ERC721A: approve to caller");
1175 
1176         _operatorApprovals[_msgSender()][operator] = approved;
1177         emit ApprovalForAll(_msgSender(), operator, approved);
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-isApprovedForAll}.
1182      */
1183     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1184         return _operatorApprovals[owner][operator];
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-transferFrom}.
1189      */
1190     function transferFrom(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) public virtual override {
1195         _transfer(from, to, tokenId);
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-safeTransferFrom}.
1200      */
1201     function safeTransferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) public virtual override {
1206         safeTransferFrom(from, to, tokenId, "");
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-safeTransferFrom}.
1211      */
1212     function safeTransferFrom(
1213         address from,
1214         address to,
1215         uint256 tokenId,
1216         bytes memory _data
1217     ) public override {
1218         _transfer(from, to, tokenId);
1219         require(
1220             _checkOnERC721Received(from, to, tokenId, _data),
1221             "ERC721A: transfer to non ERC721Receiver implementer"
1222         );
1223     }
1224 
1225     /**
1226      * @dev Returns whether `tokenId` exists.
1227      *
1228      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1229      *
1230      * Tokens start existing when they are minted (`_mint`),
1231      */
1232     function _exists(uint256 tokenId) internal view returns (bool) {
1233         return tokenId < currentIndex;
1234     }
1235 
1236     function _safeMint(address to, uint256 quantity) internal {
1237         _safeMint(to, quantity, "");
1238     }
1239 
1240     /**
1241      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1242      *
1243      * Requirements:
1244      *
1245      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1246      * - `quantity` must be greater than 0.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _safeMint(
1251         address to,
1252         uint256 quantity,
1253         bytes memory _data
1254     ) internal {
1255         _mint(to, quantity, _data, true);
1256     }
1257 
1258     /**
1259      * @dev Mints `quantity` tokens and transfers them to `to`.
1260      *
1261      * Requirements:
1262      *
1263      * - `to` cannot be the zero address.
1264      * - `quantity` must be greater than 0.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _mint(
1269         address to,
1270         uint256 quantity,
1271         bytes memory _data,
1272         bool safe
1273     ) internal {
1274         uint256 startTokenId = currentIndex;
1275         require(to != address(0), "ERC721A: mint to the zero address");
1276         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1277 
1278         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1279 
1280         // Overflows are incredibly unrealistic.
1281         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1282         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1283         unchecked {
1284             _addressData[to].balance += uint128(quantity);
1285             _addressData[to].numberMinted += uint128(quantity);
1286 
1287             _ownerships[startTokenId].addr = to;
1288             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1289 
1290             uint256 updatedIndex = startTokenId;
1291 
1292             for (uint256 i; i < quantity; i++) {
1293                 emit Transfer(address(0), to, updatedIndex);
1294                 if (safe) {
1295                     require(
1296                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1297                         "ERC721A: transfer to non ERC721Receiver implementer"
1298                     );
1299                 }
1300 
1301                 updatedIndex++;
1302             }
1303 
1304             currentIndex = updatedIndex;
1305         }
1306 
1307         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1308     }
1309 
1310     /**
1311      * @dev Transfers `tokenId` from `from` to `to`.
1312      *
1313      * Requirements:
1314      *
1315      * - `to` cannot be the zero address.
1316      * - `tokenId` token must be owned by `from`.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function _transfer(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) private {
1325         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1326 
1327         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1328             getApproved(tokenId) == _msgSender() ||
1329             isApprovedForAll(prevOwnership.addr, _msgSender()));
1330 
1331         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1332 
1333         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1334         require(to != address(0), "ERC721A: transfer to the zero address");
1335 
1336         _beforeTokenTransfers(from, to, tokenId, 1);
1337 
1338         // Clear approvals from the previous owner
1339         _approve(address(0), tokenId, prevOwnership.addr);
1340 
1341         // Underflow of the sender's balance is impossible because we check for
1342         // ownership above and the recipient's balance can't realistically overflow.
1343         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1344         unchecked {
1345             _addressData[from].balance -= 1;
1346             _addressData[to].balance += 1;
1347 
1348             _ownerships[tokenId].addr = to;
1349             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1350 
1351             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1352             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1353             uint256 nextTokenId = tokenId + 1;
1354             if (_ownerships[nextTokenId].addr == address(0)) {
1355                 if (_exists(nextTokenId)) {
1356                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1357                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1358                 }
1359             }
1360         }
1361 
1362         emit Transfer(from, to, tokenId);
1363         _afterTokenTransfers(from, to, tokenId, 1);
1364     }
1365 
1366     /**
1367      * @dev Approve `to` to operate on `tokenId`
1368      *
1369      * Emits a {Approval} event.
1370      */
1371     function _approve(
1372         address to,
1373         uint256 tokenId,
1374         address owner
1375     ) private {
1376         _tokenApprovals[tokenId] = to;
1377         emit Approval(owner, to, tokenId);
1378     }
1379 
1380     /**
1381      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1382      * The call is not executed if the target address is not a contract.
1383      *
1384      * @param from address representing the previous owner of the given token ID
1385      * @param to target address that will receive the tokens
1386      * @param tokenId uint256 ID of the token to be transferred
1387      * @param _data bytes optional data to send along with the call
1388      * @return bool whether the call correctly returned the expected magic value
1389      */
1390     function _checkOnERC721Received(
1391         address from,
1392         address to,
1393         uint256 tokenId,
1394         bytes memory _data
1395     ) private returns (bool) {
1396         if (to.isContract()) {
1397             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1398                 return retval == IERC721Receiver(to).onERC721Received.selector;
1399             } catch (bytes memory reason) {
1400                 if (reason.length == 0) {
1401                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1402                 } else {
1403                     assembly {
1404                         revert(add(32, reason), mload(reason))
1405                     }
1406                 }
1407             }
1408         } else {
1409             return true;
1410         }
1411     }
1412 
1413     /**
1414      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1415      *
1416      * startTokenId - the first token id to be transferred
1417      * quantity - the amount to be transferred
1418      *
1419      * Calling conditions:
1420      *
1421      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1422      * transferred to `to`.
1423      * - When `from` is zero, `tokenId` will be minted for `to`.
1424      */
1425     function _beforeTokenTransfers(
1426         address from,
1427         address to,
1428         uint256 startTokenId,
1429         uint256 quantity
1430     ) internal virtual {}
1431 
1432     /**
1433      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1434      * minting.
1435      *
1436      * startTokenId - the first token id to be transferred
1437      * quantity - the amount to be transferred
1438      *
1439      * Calling conditions:
1440      *
1441      * - when `from` and `to` are both non-zero.
1442      * - `from` and `to` are never both zero.
1443      */
1444     function _afterTokenTransfers(
1445         address from,
1446         address to,
1447         uint256 startTokenId,
1448         uint256 quantity
1449     ) internal virtual {}
1450 }
1451 
1452 contract CyberWarrior is ERC721A, Ownable, ReentrancyGuard {
1453 
1454   string public        baseURI;
1455   uint public          price             = 0.005 ether;
1456   uint public          maxPerTx          = 30;
1457   uint public          totalFree         = 1333;
1458   uint public          maxSupply         = 3333;
1459   uint256 public        maxFreePerWallet = 3;
1460   bool public          mintEnabled;
1461   mapping(address => uint256) private _mintedFreeAmount;
1462 
1463   constructor() ERC721A("Cyber Warrior", "CB"){
1464   }
1465 
1466   function mint(uint256 amount) external payable
1467   {
1468     uint cost = price;
1469     
1470     bool isFree = ((totalSupply() + amount < totalFree + 1) &&
1471             (_mintedFreeAmount[msg.sender] + amount <= maxFreePerWallet));
1472 
1473     if(isFree) {
1474       cost = 0;
1475     }
1476     require(mintEnabled, "Minting is not live yet, hold on Zombie");
1477     require(totalSupply() + amount < maxSupply + 1,"No more Zombies");
1478     require(msg.value == amount * cost,"Please send the exact amount");
1479     require(amount < maxPerTx + 1, "Max per TX reached");
1480     
1481     if (isFree) {
1482             _mintedFreeAmount[msg.sender] += amount;
1483         }
1484 
1485     _safeMint(msg.sender, amount);
1486   }
1487 
1488   function ownerBatchMint(uint256 amount) external onlyOwner
1489   {
1490     require(totalSupply() + amount < maxSupply + 1,"too many!");
1491 
1492     _safeMint(msg.sender, amount);
1493   }
1494 
1495   function toggleMinting() external onlyOwner {
1496       mintEnabled = !mintEnabled;
1497   }
1498 
1499   function numberMinted(address owner) public view returns (uint256) {
1500     return _numberMinted(owner);
1501   }
1502 
1503   function setBaseURI(string calldata baseURI_) external onlyOwner {
1504     baseURI = baseURI_;
1505   }
1506 
1507   function setPrice(uint256 price_) external onlyOwner {
1508       price = price_;
1509   }
1510 
1511   function setTotalFree(uint256 totalFree_) external onlyOwner {
1512       totalFree = totalFree_;
1513   }
1514 
1515   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1516       maxPerTx = maxPerTx_;
1517   }
1518 
1519   function _baseURI() internal view virtual override returns (string memory) {
1520     return baseURI;
1521   }
1522 
1523   function withdraw() external onlyOwner nonReentrant {
1524     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1525     require(success, "Transfer failed.");
1526   }
1527 
1528 }