1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Interface of the ERC20 standard as defined in the EIP.
76  */
77 interface IERC20 {
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101 
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `to`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transfer(address to, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through {transferFrom}. This is
114      * zero by default.
115      *
116      * This value changes when {approve} or {transferFrom} are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119 
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * IMPORTANT: Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Moves `amount` tokens from `from` to `to` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(
146         address from,
147         address to,
148         uint256 amount
149     ) external returns (bool);
150 }
151 
152 // File: @openzeppelin/contracts/utils/Strings.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev String operations.
161  */
162 library Strings {
163     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
167      */
168     function toString(uint256 value) internal pure returns (string memory) {
169         // Inspired by OraclizeAPI's implementation - MIT licence
170         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
171 
172         if (value == 0) {
173             return "0";
174         }
175         uint256 temp = value;
176         uint256 digits;
177         while (temp != 0) {
178             digits++;
179             temp /= 10;
180         }
181         bytes memory buffer = new bytes(digits);
182         while (value != 0) {
183             digits -= 1;
184             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
185             value /= 10;
186         }
187         return string(buffer);
188     }
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
192      */
193     function toHexString(uint256 value) internal pure returns (string memory) {
194         if (value == 0) {
195             return "0x00";
196         }
197         uint256 temp = value;
198         uint256 length = 0;
199         while (temp != 0) {
200             length++;
201             temp >>= 8;
202         }
203         return toHexString(value, length);
204     }
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
208      */
209     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
210         bytes memory buffer = new bytes(2 * length + 2);
211         buffer[0] = "0";
212         buffer[1] = "x";
213         for (uint256 i = 2 * length + 1; i > 1; --i) {
214             buffer[i] = _HEX_SYMBOLS[value & 0xf];
215             value >>= 4;
216         }
217         require(value == 0, "Strings: hex length insufficient");
218         return string(buffer);
219     }
220 }
221 
222 // File: @openzeppelin/contracts/utils/Context.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Provides information about the current execution context, including the
231  * sender of the transaction and its data. While these are generally available
232  * via msg.sender and msg.data, they should not be accessed in such a direct
233  * manner, since when dealing with meta-transactions the account sending and
234  * paying for execution may not be the actual sender (as far as an application
235  * is concerned).
236  *
237  * This contract is only required for intermediate, library-like contracts.
238  */
239 abstract contract Context {
240     function _msgSender() internal view virtual returns (address) {
241         return msg.sender;
242     }
243 
244     function _msgData() internal view virtual returns (bytes calldata) {
245         return msg.data;
246     }
247 }
248 
249 // File: @openzeppelin/contracts/access/Ownable.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 
257 /**
258  * @dev Contract module which provides a basic access control mechanism, where
259  * there is an account (an owner) that can be granted exclusive access to
260  * specific functions.
261  *
262  * By default, the owner account will be the one that deploys the contract. This
263  * can later be changed with {transferOwnership}.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 abstract contract Ownable is Context {
270     address private _owner;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor() {
278         _transferOwnership(_msgSender());
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view virtual returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(owner() == _msgSender(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Leaves the contract without owner. It will not be possible to call
298      * `onlyOwner` functions anymore. Can only be called by the current owner.
299      *
300      * NOTE: Renouncing ownership will leave the contract without an owner,
301      * thereby removing any functionality that is only available to the owner.
302      */
303     function renounceOwnership() public virtual onlyOwner {
304         _transferOwnership(address(0));
305     }
306 
307     /**
308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
309      * Can only be called by the current owner.
310      */
311     function transferOwnership(address newOwner) public virtual onlyOwner {
312         require(newOwner != address(0), "Ownable: new owner is the zero address");
313         _transferOwnership(newOwner);
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Internal function without access restriction.
319      */
320     function _transferOwnership(address newOwner) internal virtual {
321         address oldOwner = _owner;
322         _owner = newOwner;
323         emit OwnershipTransferred(oldOwner, newOwner);
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/Address.sol
328 
329 
330 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
331 
332 pragma solidity ^0.8.1;
333 
334 /**
335  * @dev Collection of functions related to the address type
336  */
337 library Address {
338     /**
339      * @dev Returns true if `account` is a contract.
340      *
341      * [IMPORTANT]
342      * ====
343      * It is unsafe to assume that an address for which this function returns
344      * false is an externally-owned account (EOA) and not a contract.
345      *
346      * Among others, `isContract` will return false for the following
347      * types of addresses:
348      *
349      *  - an externally-owned account
350      *  - a contract in construction
351      *  - an address where a contract will be created
352      *  - an address where a contract lived, but was destroyed
353      * ====
354      *
355      * [IMPORTANT]
356      * ====
357      * You shouldn't rely on `isContract` to protect against flash loan attacks!
358      *
359      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
360      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
361      * constructor.
362      * ====
363      */
364     function isContract(address account) internal view returns (bool) {
365         // This method relies on extcodesize/address.code.length, which returns 0
366         // for contracts in construction, since the code is only stored at the end
367         // of the constructor execution.
368 
369         return account.code.length > 0;
370     }
371 
372     /**
373      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
374      * `recipient`, forwarding all available gas and reverting on errors.
375      *
376      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
377      * of certain opcodes, possibly making contracts go over the 2300 gas limit
378      * imposed by `transfer`, making them unable to receive funds via
379      * `transfer`. {sendValue} removes this limitation.
380      *
381      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
382      *
383      * IMPORTANT: because control is transferred to `recipient`, care must be
384      * taken to not create reentrancy vulnerabilities. Consider using
385      * {ReentrancyGuard} or the
386      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
387      */
388     function sendValue(address payable recipient, uint256 amount) internal {
389         require(address(this).balance >= amount, "Address: insufficient balance");
390 
391         (bool success, ) = recipient.call{value: amount}("");
392         require(success, "Address: unable to send value, recipient may have reverted");
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain `call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionCall(target, data, "Address: low-level call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
419      * `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, 0, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but also transferring `value` wei to `target`.
434      *
435      * Requirements:
436      *
437      * - the calling contract must have an ETH balance of at least `value`.
438      * - the called Solidity function must be `payable`.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(
443         address target,
444         bytes memory data,
445         uint256 value
446     ) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(address(this).balance >= value, "Address: insufficient balance for call");
463         require(isContract(target), "Address: call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.call{value: value}(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a static call.
472      *
473      * _Available since v3.3._
474      */
475     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
476         return functionStaticCall(target, data, "Address: low-level static call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal view returns (bytes memory) {
490         require(isContract(target), "Address: static call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.staticcall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
503         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
508      * but performing a delegate call.
509      *
510      * _Available since v3.4._
511      */
512     function functionDelegateCall(
513         address target,
514         bytes memory data,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         require(isContract(target), "Address: delegate call to non-contract");
518 
519         (bool success, bytes memory returndata) = target.delegatecall(data);
520         return verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
525      * revert reason using the provided one.
526      *
527      * _Available since v4.3._
528      */
529     function verifyCallResult(
530         bool success,
531         bytes memory returndata,
532         string memory errorMessage
533     ) internal pure returns (bytes memory) {
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 assembly {
542                     let returndata_size := mload(returndata)
543                     revert(add(32, returndata), returndata_size)
544                 }
545             } else {
546                 revert(errorMessage);
547             }
548         }
549     }
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 
561 /**
562  * @title SafeERC20
563  * @dev Wrappers around ERC20 operations that throw on failure (when the token
564  * contract returns false). Tokens that return no value (and instead revert or
565  * throw on failure) are also supported, non-reverting calls are assumed to be
566  * successful.
567  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
568  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
569  */
570 library SafeERC20 {
571     using Address for address;
572 
573     function safeTransfer(
574         IERC20 token,
575         address to,
576         uint256 value
577     ) internal {
578         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
579     }
580 
581     function safeTransferFrom(
582         IERC20 token,
583         address from,
584         address to,
585         uint256 value
586     ) internal {
587         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
588     }
589 
590     /**
591      * @dev Deprecated. This function has issues similar to the ones found in
592      * {IERC20-approve}, and its usage is discouraged.
593      *
594      * Whenever possible, use {safeIncreaseAllowance} and
595      * {safeDecreaseAllowance} instead.
596      */
597     function safeApprove(
598         IERC20 token,
599         address spender,
600         uint256 value
601     ) internal {
602         // safeApprove should only be called when setting an initial allowance,
603         // or when resetting it to zero. To increase and decrease it, use
604         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
605         require(
606             (value == 0) || (token.allowance(address(this), spender) == 0),
607             "SafeERC20: approve from non-zero to non-zero allowance"
608         );
609         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
610     }
611 
612     function safeIncreaseAllowance(
613         IERC20 token,
614         address spender,
615         uint256 value
616     ) internal {
617         uint256 newAllowance = token.allowance(address(this), spender) + value;
618         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
619     }
620 
621     function safeDecreaseAllowance(
622         IERC20 token,
623         address spender,
624         uint256 value
625     ) internal {
626         unchecked {
627             uint256 oldAllowance = token.allowance(address(this), spender);
628             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
629             uint256 newAllowance = oldAllowance - value;
630             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
631         }
632     }
633 
634     /**
635      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
636      * on the return value: the return value is optional (but if data is returned, it must not be false).
637      * @param token The token targeted by the call.
638      * @param data The call data (encoded using abi.encode or one of its variants).
639      */
640     function _callOptionalReturn(IERC20 token, bytes memory data) private {
641         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
642         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
643         // the target address contains contract code and also asserts for success in the low-level call.
644 
645         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
646         if (returndata.length > 0) {
647             // Return data is optional
648             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
649         }
650     }
651 }
652 
653 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
654 
655 
656 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @title ERC721 token receiver interface
662  * @dev Interface for any contract that wants to support safeTransfers
663  * from ERC721 asset contracts.
664  */
665 interface IERC721Receiver {
666     /**
667      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
668      * by `operator` from `from`, this function is called.
669      *
670      * It must return its Solidity selector to confirm the token transfer.
671      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
672      *
673      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
674      */
675     function onERC721Received(
676         address operator,
677         address from,
678         uint256 tokenId,
679         bytes calldata data
680     ) external returns (bytes4);
681 }
682 
683 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Interface of the ERC165 standard, as defined in the
692  * https://eips.ethereum.org/EIPS/eip-165[EIP].
693  *
694  * Implementers can declare support of contract interfaces, which can then be
695  * queried by others ({ERC165Checker}).
696  *
697  * For an implementation, see {ERC165}.
698  */
699 interface IERC165 {
700     /**
701      * @dev Returns true if this contract implements the interface defined by
702      * `interfaceId`. See the corresponding
703      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
704      * to learn more about how these ids are created.
705      *
706      * This function call must use less than 30 000 gas.
707      */
708     function supportsInterface(bytes4 interfaceId) external view returns (bool);
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @dev Required interface of an ERC1155 compliant contract, as defined in the
721  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
722  *
723  * _Available since v3.1._
724  */
725 interface IERC1155 is IERC165 {
726     /**
727      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
728      */
729     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
730 
731     /**
732      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
733      * transfers.
734      */
735     event TransferBatch(
736         address indexed operator,
737         address indexed from,
738         address indexed to,
739         uint256[] ids,
740         uint256[] values
741     );
742 
743     /**
744      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
745      * `approved`.
746      */
747     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
748 
749     /**
750      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
751      *
752      * If an {URI} event was emitted for `id`, the standard
753      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
754      * returned by {IERC1155MetadataURI-uri}.
755      */
756     event URI(string value, uint256 indexed id);
757 
758     /**
759      * @dev Returns the amount of tokens of token type `id` owned by `account`.
760      *
761      * Requirements:
762      *
763      * - `account` cannot be the zero address.
764      */
765     function balanceOf(address account, uint256 id) external view returns (uint256);
766 
767     /**
768      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
769      *
770      * Requirements:
771      *
772      * - `accounts` and `ids` must have the same length.
773      */
774     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
775         external
776         view
777         returns (uint256[] memory);
778 
779     /**
780      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
781      *
782      * Emits an {ApprovalForAll} event.
783      *
784      * Requirements:
785      *
786      * - `operator` cannot be the caller.
787      */
788     function setApprovalForAll(address operator, bool approved) external;
789 
790     /**
791      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
792      *
793      * See {setApprovalForAll}.
794      */
795     function isApprovedForAll(address account, address operator) external view returns (bool);
796 
797     /**
798      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
799      *
800      * Emits a {TransferSingle} event.
801      *
802      * Requirements:
803      *
804      * - `to` cannot be the zero address.
805      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
806      * - `from` must have a balance of tokens of type `id` of at least `amount`.
807      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
808      * acceptance magic value.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 id,
814         uint256 amount,
815         bytes calldata data
816     ) external;
817 
818     /**
819      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
820      *
821      * Emits a {TransferBatch} event.
822      *
823      * Requirements:
824      *
825      * - `ids` and `amounts` must have the same length.
826      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
827      * acceptance magic value.
828      */
829     function safeBatchTransferFrom(
830         address from,
831         address to,
832         uint256[] calldata ids,
833         uint256[] calldata amounts,
834         bytes calldata data
835     ) external;
836 }
837 
838 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
839 
840 
841 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
842 
843 pragma solidity ^0.8.0;
844 
845 
846 /**
847  * @dev Implementation of the {IERC165} interface.
848  *
849  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
850  * for the additional interface id that will be supported. For example:
851  *
852  * ```solidity
853  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
854  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
855  * }
856  * ```
857  *
858  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
859  */
860 abstract contract ERC165 is IERC165 {
861     /**
862      * @dev See {IERC165-supportsInterface}.
863      */
864     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
865         return interfaceId == type(IERC165).interfaceId;
866     }
867 }
868 
869 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
870 
871 
872 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 
877 /**
878  * @dev Required interface of an ERC721 compliant contract.
879  */
880 interface IERC721 is IERC165 {
881     /**
882      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
883      */
884     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
885 
886     /**
887      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
888      */
889     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
890 
891     /**
892      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
893      */
894     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
895 
896     /**
897      * @dev Returns the number of tokens in ``owner``'s account.
898      */
899     function balanceOf(address owner) external view returns (uint256 balance);
900 
901     /**
902      * @dev Returns the owner of the `tokenId` token.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      */
908     function ownerOf(uint256 tokenId) external view returns (address owner);
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must exist and be owned by `from`.
918      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes calldata data
928     ) external;
929 
930     /**
931      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
932      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
933      *
934      * Requirements:
935      *
936      * - `from` cannot be the zero address.
937      * - `to` cannot be the zero address.
938      * - `tokenId` token must exist and be owned by `from`.
939      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
941      *
942      * Emits a {Transfer} event.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) external;
949 
950     /**
951      * @dev Transfers `tokenId` token from `from` to `to`.
952      *
953      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
954      *
955      * Requirements:
956      *
957      * - `from` cannot be the zero address.
958      * - `to` cannot be the zero address.
959      * - `tokenId` token must be owned by `from`.
960      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
961      *
962      * Emits a {Transfer} event.
963      */
964     function transferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) external;
969 
970     /**
971      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
972      * The approval is cleared when the token is transferred.
973      *
974      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
975      *
976      * Requirements:
977      *
978      * - The caller must own the token or be an approved operator.
979      * - `tokenId` must exist.
980      *
981      * Emits an {Approval} event.
982      */
983     function approve(address to, uint256 tokenId) external;
984 
985     /**
986      * @dev Approve or remove `operator` as an operator for the caller.
987      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
988      *
989      * Requirements:
990      *
991      * - The `operator` cannot be the caller.
992      *
993      * Emits an {ApprovalForAll} event.
994      */
995     function setApprovalForAll(address operator, bool _approved) external;
996 
997     /**
998      * @dev Returns the account approved for `tokenId` token.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      */
1004     function getApproved(uint256 tokenId) external view returns (address operator);
1005 
1006     /**
1007      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1008      *
1009      * See {setApprovalForAll}
1010      */
1011     function isApprovedForAll(address owner, address operator) external view returns (bool);
1012 }
1013 
1014 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1015 
1016 
1017 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 
1022 /**
1023  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1024  * @dev See https://eips.ethereum.org/EIPS/eip-721
1025  */
1026 interface IERC721Enumerable is IERC721 {
1027     /**
1028      * @dev Returns the total amount of tokens stored by the contract.
1029      */
1030     function totalSupply() external view returns (uint256);
1031 
1032     /**
1033      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1034      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1035      */
1036     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1037 
1038     /**
1039      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1040      * Use along with {totalSupply} to enumerate all tokens.
1041      */
1042     function tokenByIndex(uint256 index) external view returns (uint256);
1043 }
1044 
1045 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1046 
1047 
1048 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1049 
1050 pragma solidity ^0.8.0;
1051 
1052 
1053 /**
1054  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1055  * @dev See https://eips.ethereum.org/EIPS/eip-721
1056  */
1057 interface IERC721Metadata is IERC721 {
1058     /**
1059      * @dev Returns the token collection name.
1060      */
1061     function name() external view returns (string memory);
1062 
1063     /**
1064      * @dev Returns the token collection symbol.
1065      */
1066     function symbol() external view returns (string memory);
1067 
1068     /**
1069      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1070      */
1071     function tokenURI(uint256 tokenId) external view returns (string memory);
1072 }
1073 
1074 // File: contracts/token/ERC721ME.sol
1075 
1076 
1077 // Creators: Meta Estates Labs
1078 pragma solidity ^0.8.4;
1079 
1080 
1081 
1082 
1083 
1084 
1085 
1086 
1087 
1088 contract ERC721ME is Context, ERC165, IERC721, IERC721Metadata {
1089     using Address for address;
1090     using Strings for uint256;
1091 
1092 //Varibles list
1093     struct AddressData {
1094         uint64 balance;
1095         uint64 numMinted;
1096         uint64 numBurned;
1097         uint64 numEvolved;
1098         uint64 actionScore;
1099     }
1100 
1101     struct TokenOwnership {
1102         address addr;
1103         uint64  startTime;
1104         bool    burned;
1105     }
1106 
1107     uint64  internal _maxSupply;
1108     uint64  internal _mintPerAddress;
1109     uint64  internal _currentIndex;
1110     uint64  internal _currentEvolveIndex;
1111     uint64  internal _burnCounter;
1112     uint64  internal _evoCounter;
1113 
1114     string  private _name;
1115     string  private _symbol;
1116 
1117     mapping(uint256 => address) internal _tokenApprovals;
1118     mapping(address => AddressData) internal _addressData;
1119     mapping(uint256 => TokenOwnership) internal _ownerships;
1120     mapping(address => mapping(address => bool)) internal _operatorApprovals;
1121 
1122 //Constructor
1123     constructor(
1124         string memory name_,
1125         string memory symbol_,
1126         uint64 maxSupply_,
1127         uint64 mintPerAddress_
1128     ){
1129         _name = name_;
1130         _symbol = symbol_;
1131         _maxSupply = maxSupply_;
1132         _mintPerAddress = mintPerAddress_; 
1133 
1134         _currentIndex = 1;
1135         _currentEvolveIndex = _maxSupply + 1;
1136     }
1137 
1138 //Modifier
1139     modifier addressZeroChecker(address owner) {
1140         require(owner != address(0),"address(0)");
1141         _;
1142     }
1143 
1144     modifier approvedOrOwnerChecker(uint256 tokenId) {
1145         address addr = _ownerships[tokenId].addr;
1146 
1147         bool isApprovedOrOwner = (_msgSender() == addr ||
1148              isApprovedForAll(addr, _msgSender()) ||
1149              getApproved(tokenId) == _msgSender());
1150 
1151         require(isApprovedOrOwner, "not qualified");
1152         _;
1153     }
1154 
1155     modifier exists(uint256 tokenId) {
1156         require((1 <= tokenId && tokenId < _currentIndex) || 
1157         (_maxSupply <= tokenId && tokenId < _currentEvolveIndex), "not mint");
1158         require(!_ownerships[tokenId].burned, "token burned");
1159         _;
1160     }
1161 
1162 
1163 //Contract amount relatived functions  
1164     function totalSupply() public view returns (uint256) {
1165         return _currentIndex + _evoCounter - _burnCounter - 1;
1166     }
1167 
1168     function maxSupply() public view returns (uint256) {
1169         return _maxSupply - totalBurned();
1170     }
1171 
1172     function totalMinted() public view returns (uint64) {
1173         return _currentIndex - 1;
1174     }
1175 
1176     function totalBurned() public view returns (uint64) {
1177         return _burnCounter - _evoCounter;
1178     }
1179 
1180     function totalEvolved() public view returns (uint64) {
1181         return _evoCounter;
1182     }
1183 
1184 
1185 //Contract Metadata relatived functions
1186     function name() public view override returns (string memory) {
1187         return _name;
1188     }
1189 
1190     function symbol() public view override returns (string memory) {
1191         return _symbol;
1192     }
1193 
1194     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1195     }
1196 
1197 //Owner address relatived function
1198 
1199     function balanceOf(address owner) public view override returns (uint256) {
1200         return _addressData[owner].balance;
1201     }
1202 
1203     function addressDataOf(address owner) public view returns (AddressData memory) {
1204         return _addressData[owner];
1205     }
1206 
1207     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1208         return _ownerships[tokenId];
1209     }
1210     
1211     function ownerOf(uint256 tokenId) public view override exists(tokenId) returns (address) {
1212         return _ownerships[tokenId].addr;
1213     }
1214 
1215 //Approve relatived functions
1216 
1217     function approve(address to, uint256 tokenId) public virtual override {
1218         address owner = _ownerships[tokenId].addr;
1219 
1220         require(to != owner, "approval to current owner");
1221         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "not approval");
1222         
1223         _approve(to, tokenId, owner);
1224     }
1225 
1226     function _approve(address to, uint256 tokenId, address owner) private {
1227         _tokenApprovals[tokenId] = to;
1228         emit Approval(owner, to, tokenId);
1229     }
1230 
1231     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1232         return _tokenApprovals[tokenId];
1233     }
1234 
1235     function setApprovalForAll(address operator, bool approved) public virtual override {
1236         require(operator != _msgSender(), "approve to caller");
1237 
1238         _operatorApprovals[_msgSender()][operator] = approved;
1239         emit ApprovalForAll(_msgSender(), operator, approved);
1240     }
1241 
1242     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1243         return _operatorApprovals[owner][operator];
1244     }
1245 
1246 
1247 //Transfer relatived functions
1248     function transferFrom(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) public virtual override {
1253         _transfer(from, to, tokenId);
1254     }
1255 
1256     function safeTransferFrom(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) public virtual override {
1261         safeTransferFrom(from, to, tokenId, '');
1262     }
1263 
1264     function safeTransferFrom(
1265         address from,
1266         address to,
1267         uint256 tokenId,
1268         bytes memory _data
1269     ) public virtual override {
1270         _transfer(from, to, tokenId);
1271         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1272             revert();
1273         }
1274     }
1275 
1276     function _transfer(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) private addressZeroChecker(to) approvedOrOwnerChecker(tokenId) {
1281         TokenOwnership storage ownership = _ownerships[tokenId];
1282 
1283         AddressData storage data = _addressData[from];
1284 
1285         _approve(address(0), tokenId, from);
1286 
1287         data.balance -= 1;
1288         data.actionScore += 1000;
1289         _addressData[to].balance += 1;
1290 
1291         ownership.addr = to;
1292         ownership.startTime = uint64(block.timestamp);
1293 
1294         emit Transfer(from, to, tokenId);
1295     }
1296 
1297 //Mint relatived functions
1298     function _safeMint(address to, uint256 quantity) internal {
1299         _safeMint(to, quantity, '');
1300     }
1301 
1302     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {
1303         _mint(to, uint64(quantity), _data);
1304     }
1305 
1306     function _mint(address to, uint64 quantity, bytes memory _data) internal {
1307         AddressData storage data = _addressData[to];
1308 
1309         if (to.isContract() && !_checkContractOnERC721Received(address(0), to, _currentIndex, _data)) { 
1310             revert();
1311         }  
1312 
1313         data.balance += quantity;
1314         data.numMinted += quantity;
1315 
1316         uint64 updatedIndex = _currentIndex;
1317         uint64 end = updatedIndex + quantity;
1318 
1319         for (updatedIndex; updatedIndex < end; updatedIndex++ ) {
1320             _ownerships[updatedIndex].addr = to;
1321             _ownerships[updatedIndex].startTime = uint64(block.timestamp);
1322             emit Transfer(address(0), to, updatedIndex);
1323         }
1324    
1325         _currentIndex = end;
1326     }
1327 
1328     function _evolve(address to) internal {
1329         AddressData storage data = _addressData[to];
1330 
1331         require(data.numBurned > 1, "burn token firstly");
1332 
1333         uint64 startTokenId = _currentEvolveIndex;
1334 
1335         data.balance += 1;
1336         data.numBurned -= 1;
1337         data.numEvolved += 1;
1338 
1339         _ownerships[startTokenId].addr = to;
1340         _ownerships[startTokenId].startTime = uint64(block.timestamp);
1341 
1342         _currentEvolveIndex++;
1343         _evoCounter++;
1344 
1345         emit Transfer(address(0), to, startTokenId);
1346     }
1347 
1348     function _checkContractOnERC721Received(
1349         address from,
1350         address to,
1351         uint256 tokenId,
1352         bytes memory _data
1353     ) private returns (bool) {
1354         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1355             return retval == IERC721Receiver(to).onERC721Received.selector;
1356         } catch (bytes memory reason) {
1357             if (reason.length == 0) {
1358                 revert();
1359             } else {
1360                 assembly {
1361                     revert (add(32, reason), mload(reason))
1362                 }
1363             }
1364         }
1365     }
1366 
1367 //Burn relatived functions
1368     function _burn(uint256 tokenId) internal virtual {
1369         TokenOwnership storage ownership = _ownerships[tokenId];
1370 
1371         address addr = ownership.addr;
1372 
1373         _approve(address(0), tokenId, addr);
1374 
1375         _addressData[addr].balance -=  1;
1376         _addressData[addr].numBurned +=  1;
1377 
1378         ownership.addr = address(0);
1379         ownership.startTime = uint64(block.timestamp);
1380         ownership.burned = true;    
1381 
1382         _burnCounter++;
1383 
1384         emit Transfer(addr, address(0), tokenId);
1385     }
1386 
1387 //Other functions
1388     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) 
1389     returns (bool) {
1390         return
1391             interfaceId == type(IERC721).interfaceId ||
1392             interfaceId == type(IERC721Metadata).interfaceId ||
1393             super.supportsInterface(interfaceId);
1394     }
1395 }
1396 // File: contracts/project_MNM/MetaNindom.sol
1397 
1398 
1399 // Creators: Meta Estates Labs;
1400 pragma solidity ^0.8.4;
1401 
1402 
1403 
1404 
1405 
1406 
1407 
1408 contract MetaNindomMEvolution is Ownable, ERC721ME, ReentrancyGuard {
1409   using Strings   for uint256;
1410   using SafeERC20 for IERC20;
1411 
1412 //Varibles list
1413   enum JutsuType {
1414     MEvolvedJutsu,
1415     CryptoJutsu,
1416     MetaJutsu,
1417     UltimateJutsu
1418   }
1419 
1420   uint64 immutable MINT_ACTIONSCORE   =  5000;
1421   uint64 immutable BURN_ACTIONSCORE   =  5000;
1422   uint64 immutable EVOLVE_ACTIONSCORE = 10000;
1423   uint64 immutable POWER_ACTIONSCORE  = 10000;
1424   uint64 immutable STRING_ACTIONSCORE =  1500;
1425 
1426   uint256 public publicPriceWei;
1427 
1428   string public baseURI;
1429   string private _baseExtension = ".json";
1430 
1431   address public tokenContract;
1432 
1433   mapping (uint256 => string) public soulBound;
1434   mapping (uint256 => mapping (JutsuType => uint64)) public soulBoundPowByTokenId;
1435 
1436 //Constructor
1437   constructor(
1438     uint64 amountForDev_,
1439     string memory initBaseURI_,
1440     address tokenContract_
1441   ) ERC721ME("Meta Nindom: MEvolution", "MNM", 12000, 50) {
1442     _safeMint(_msgSender(), amountForDev_);
1443     baseURI = initBaseURI_;
1444     tokenContract = tokenContract_;
1445   }
1446 
1447 //Modifier
1448   modifier callerIsUser() {
1449     require(tx.origin == msg.sender, "contract caller");
1450     _;
1451   }
1452 
1453 //Public sale relatived functions
1454   function publicMint(uint64 quantity) external payable callerIsUser {
1455     require(publicPriceWei != 0, "sale not begun");
1456     require(totalMinted() + quantity <= _maxSupply, "Max supply");
1457     require(msg.value >= publicPriceWei * quantity, "insufficient amount");
1458 
1459     AddressData storage data = _addressData[_msgSender()];
1460 
1461     require(data.numMinted + quantity <= _mintPerAddress, "Max mint");
1462     data.actionScore += MINT_ACTIONSCORE;
1463 
1464     _safeMint(msg.sender, quantity);   
1465   }
1466 
1467   function setPublicPriceWei(uint256 newPublicPriceWei) external onlyOwner {
1468     publicPriceWei = newPublicPriceWei;
1469   }
1470 
1471   function withdraw() external onlyOwner callerIsUser nonReentrant {
1472     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1473     require(success, "withdraw failed");
1474   }
1475 
1476 //Contract metadata relatived functions
1477   function tokenURI(uint256 tokenId) public view virtual override exists(tokenId) returns (string memory) {
1478 
1479     string memory currentBaseURI = _baseURI(); 
1480       return
1481       bytes(currentBaseURI).length > 0 
1482        ? string(abi.encodePacked(currentBaseURI,tokenId.toString(),_baseExtension))
1483        : "";
1484   }
1485 
1486   function _baseURI() internal view virtual returns (string memory) {
1487     return baseURI;
1488   }
1489 
1490 //Address score relatived functions
1491   function _spendActionScore(uint64 spendScore) private {
1492     AddressData storage data = _addressData[_msgSender()];
1493 
1494     require (data.actionScore >= spendScore, "invalid score");
1495 
1496     data.actionScore -= spendScore;
1497   }
1498 
1499   function burnActionScore(uint64 spendScore) public {
1500 
1501     _spendActionScore(spendScore);
1502   }
1503 
1504   function addActionScoreByBurnWei(uint256 burnWei) public callerIsUser {
1505     require (IERC20(tokenContract).balanceOf(_msgSender()) >= burnWei, "invalid amount");
1506 
1507     IERC20(tokenContract).safeTransferFrom(_msgSender(), address(this), burnWei); 
1508 
1509     _addressData[_msgSender()].actionScore += uint64(burnWei / (1 ether));
1510   }
1511 
1512   function burn(uint256 tokenId) public callerIsUser approvedOrOwnerChecker(tokenId) {
1513     AddressData storage data = _addressData[ownerOf(tokenId)];
1514 
1515     getHodlScore(tokenId);
1516 
1517     _burn(tokenId);
1518 
1519     data.actionScore += BURN_ACTIONSCORE;
1520   }
1521 
1522   function getHodlScore(uint256 tokenId) public callerIsUser approvedOrOwnerChecker(tokenId) {
1523     TokenOwnership storage ownership = _ownerships[tokenId];
1524 
1525     uint64 score = (uint64(block.timestamp) - ownership.startTime) / 600 seconds;
1526     _addressData[ownership.addr].actionScore += score;
1527 
1528     ownership.startTime = uint64(block.timestamp);
1529   }
1530 
1531 //Token score relatived function
1532   function evolveToken(uint256 tokenId) public callerIsUser approvedOrOwnerChecker(tokenId) {
1533     address owner = _ownerships[tokenId].addr;
1534     AddressData memory data = _addressData[owner];
1535 
1536     require(data.numBurned > 0, "burn token");
1537     require(data.actionScore >= EVOLVE_ACTIONSCORE, "invalid score");
1538 
1539     getHodlScore(tokenId);
1540 
1541     _spendActionScore(EVOLVE_ACTIONSCORE);
1542     _burn(tokenId);
1543     _evolve(owner);
1544   }
1545 
1546   function addSoulBound(uint256 tokenId, string memory newSoul) public approvedOrOwnerChecker(tokenId) {
1547     _spendActionScore(POWER_ACTIONSCORE);
1548     soulBound[tokenId] = newSoul;
1549   }
1550 
1551   function soulBoundPow(
1552     uint256 tokenId, 
1553     JutsuType jutsuType, 
1554     uint64 power
1555   ) external callerIsUser approvedOrOwnerChecker(tokenId) {
1556     _spendActionScore(power * POWER_ACTIONSCORE);
1557     soulBoundPowByTokenId[tokenId][jutsuType] += power;
1558   }
1559   
1560 }