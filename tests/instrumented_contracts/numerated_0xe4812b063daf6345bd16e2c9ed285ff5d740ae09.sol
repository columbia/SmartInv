1 // SPDX-License-Identifier: MIT
2 
3 // OKAY AZUKIS
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `to`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address to, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `from` to `to` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address from,
71         address to,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Contract module that helps prevent reentrant calls to a function.
99  *
100  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
101  * available, which can be applied to functions to make sure there are no nested
102  * (reentrant) calls to them.
103  *
104  * Note that because there is a single `nonReentrant` guard, functions marked as
105  * `nonReentrant` may not call one another. This can be worked around by making
106  * those functions `private`, and then adding `external` `nonReentrant` entry
107  * points to them.
108  *
109  * TIP: If you would like to learn more about reentrancy and alternative ways
110  * to protect against it, check out our blog post
111  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
112  */
113 abstract contract ReentrancyGuard {
114     // Booleans are more expensive than uint256 or any type that takes up a full
115     // word because each write operation emits an extra SLOAD to first read the
116     // slot's contents, replace the bits taken up by the boolean, and then write
117     // back. This is the compiler's defense against contract upgrades and
118     // pointer aliasing, and it cannot be disabled.
119 
120     // The values being non-zero value makes deployment a bit more expensive,
121     // but in exchange the refund on every call to nonReentrant will be lower in
122     // amount. Since refunds are capped to a percentage of the total
123     // transaction's gas, it is best to keep them low in cases like this one, to
124     // increase the likelihood of the full refund coming into effect.
125     uint256 private constant _NOT_ENTERED = 1;
126     uint256 private constant _ENTERED = 2;
127 
128     uint256 private _status;
129 
130     constructor() {
131         _status = _NOT_ENTERED;
132     }
133 
134     /**
135      * @dev Prevents a contract from calling itself, directly or indirectly.
136      * Calling a `nonReentrant` function from another `nonReentrant`
137      * function is not supported. It is possible to prevent this from happening
138      * by making the `nonReentrant` function external, and making it call a
139      * `private` function that does the actual work.
140      */
141     modifier nonReentrant() {
142         // On the first call to nonReentrant, _notEntered will be true
143         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
144 
145         // Any calls to nonReentrant after this point will fail
146         _status = _ENTERED;
147 
148         _;
149 
150         // By storing the original value once again, a refund is triggered (see
151         // https://eips.ethereum.org/EIPS/eip-2200)
152         _status = _NOT_ENTERED;
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/Strings.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev String operations.
165  */
166 library Strings {
167     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
171      */
172     function toString(uint256 value) internal pure returns (string memory) {
173         // Inspired by OraclizeAPI's implementation - MIT licence
174         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
175 
176         if (value == 0) {
177             return "0";
178         }
179         uint256 temp = value;
180         uint256 digits;
181         while (temp != 0) {
182             digits++;
183             temp /= 10;
184         }
185         bytes memory buffer = new bytes(digits);
186         while (value != 0) {
187             digits -= 1;
188             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
189             value /= 10;
190         }
191         return string(buffer);
192     }
193 
194     /**
195      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
196      */
197     function toHexString(uint256 value) internal pure returns (string memory) {
198         if (value == 0) {
199             return "0x00";
200         }
201         uint256 temp = value;
202         uint256 length = 0;
203         while (temp != 0) {
204             length++;
205             temp >>= 8;
206         }
207         return toHexString(value, length);
208     }
209 
210     /**
211      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
212      */
213     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
214         bytes memory buffer = new bytes(2 * length + 2);
215         buffer[0] = "0";
216         buffer[1] = "x";
217         for (uint256 i = 2 * length + 1; i > 1; --i) {
218             buffer[i] = _HEX_SYMBOLS[value & 0xf];
219             value >>= 4;
220         }
221         require(value == 0, "Strings: hex length insufficient");
222         return string(buffer);
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/Context.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 abstract contract Context {
244     function _msgSender() internal view virtual returns (address) {
245         return msg.sender;
246     }
247 
248     function _msgData() internal view virtual returns (bytes calldata) {
249         return msg.data;
250     }
251 }
252 
253 // File: @openzeppelin/contracts/access/Ownable.sol
254 
255 
256 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * By default, the owner account will be the one that deploys the contract. This
267  * can later be changed with {transferOwnership}.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 abstract contract Ownable is Context {
274     address private _owner;
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278     /**
279      * @dev Initializes the contract setting the deployer as the initial owner.
280      */
281     constructor() {
282         _transferOwnership(_msgSender());
283     }
284 
285     /**
286      * @dev Returns the address of the current owner.
287      */
288     function owner() public view virtual returns (address) {
289         return _owner;
290     }
291 
292     /**
293      * @dev Throws if called by any account other than the owner.
294      */
295     modifier onlyOwner() {
296         require(owner() == _msgSender(), "Ownable: caller is not the owner");
297         _;
298     }
299 
300     /**
301      * @dev Leaves the contract without owner. It will not be possible to call
302      * `onlyOwner` functions anymore. Can only be called by the current owner.
303      *
304      * NOTE: Renouncing ownership will leave the contract without an owner,
305      * thereby removing any functionality that is only available to the owner.
306      */
307     function renounceOwnership() public virtual onlyOwner {
308         _transferOwnership(address(0));
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      * Can only be called by the current owner.
314      */
315     function transferOwnership(address newOwner) public virtual onlyOwner {
316         require(newOwner != address(0), "Ownable: new owner is the zero address");
317         _transferOwnership(newOwner);
318     }
319 
320     /**
321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
322      * Internal function without access restriction.
323      */
324     function _transferOwnership(address newOwner) internal virtual {
325         address oldOwner = _owner;
326         _owner = newOwner;
327         emit OwnershipTransferred(oldOwner, newOwner);
328     }
329 }
330 
331 // File: @openzeppelin/contracts/utils/Address.sol
332 
333 
334 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
335 
336 pragma solidity ^0.8.1;
337 
338 /**
339  * @dev Collection of functions related to the address type
340  */
341 library Address {
342     /**
343      * @dev Returns true if `account` is a contract.
344      *
345      * [IMPORTANT]
346      * ====
347      * It is unsafe to assume that an address for which this function returns
348      * false is an externally-owned account (EOA) and not a contract.
349      *
350      * Among others, `isContract` will return false for the following
351      * types of addresses:
352      *
353      *  - an externally-owned account
354      *  - a contract in construction
355      *  - an address where a contract will be created
356      *  - an address where a contract lived, but was destroyed
357      * ====
358      *
359      * [IMPORTANT]
360      * ====
361      * You shouldn't rely on `isContract` to protect against flash loan attacks!
362      *
363      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
364      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
365      * constructor.
366      * ====
367      */
368     function isContract(address account) internal view returns (bool) {
369         // This method relies on extcodesize/address.code.length, which returns 0
370         // for contracts in construction, since the code is only stored at the end
371         // of the constructor execution.
372 
373         return account.code.length > 0;
374     }
375 
376     /**
377      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
378      * `recipient`, forwarding all available gas and reverting on errors.
379      *
380      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
381      * of certain opcodes, possibly making contracts go over the 2300 gas limit
382      * imposed by `transfer`, making them unable to receive funds via
383      * `transfer`. {sendValue} removes this limitation.
384      *
385      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
386      *
387      * IMPORTANT: because control is transferred to `recipient`, care must be
388      * taken to not create reentrancy vulnerabilities. Consider using
389      * {ReentrancyGuard} or the
390      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
391      */
392     function sendValue(address payable recipient, uint256 amount) internal {
393         require(address(this).balance >= amount, "Address: insufficient balance");
394 
395         (bool success, ) = recipient.call{value: amount}("");
396         require(success, "Address: unable to send value, recipient may have reverted");
397     }
398 
399     /**
400      * @dev Performs a Solidity function call using a low level `call`. A
401      * plain `call` is an unsafe replacement for a function call: use this
402      * function instead.
403      *
404      * If `target` reverts with a revert reason, it is bubbled up by this
405      * function (like regular Solidity function calls).
406      *
407      * Returns the raw returned data. To convert to the expected return value,
408      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
409      *
410      * Requirements:
411      *
412      * - `target` must be a contract.
413      * - calling `target` with `data` must not revert.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionCall(target, data, "Address: low-level call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
423      * `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         return functionCallWithValue(target, data, 0, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but also transferring `value` wei to `target`.
438      *
439      * Requirements:
440      *
441      * - the calling contract must have an ETH balance of at least `value`.
442      * - the called Solidity function must be `payable`.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(
447         address target,
448         bytes memory data,
449         uint256 value
450     ) internal returns (bytes memory) {
451         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
456      * with `errorMessage` as a fallback revert reason when `target` reverts.
457      *
458      * _Available since v3.1._
459      */
460     function functionCallWithValue(
461         address target,
462         bytes memory data,
463         uint256 value,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         require(address(this).balance >= value, "Address: insufficient balance for call");
467         require(isContract(target), "Address: call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.call{value: value}(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a static call.
476      *
477      * _Available since v3.3._
478      */
479     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
480         return functionStaticCall(target, data, "Address: low-level static call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a static call.
486      *
487      * _Available since v3.3._
488      */
489     function functionStaticCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal view returns (bytes memory) {
494         require(isContract(target), "Address: static call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.staticcall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but performing a delegate call.
503      *
504      * _Available since v3.4._
505      */
506     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
507         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(
517         address target,
518         bytes memory data,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         require(isContract(target), "Address: delegate call to non-contract");
522 
523         (bool success, bytes memory returndata) = target.delegatecall(data);
524         return verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
529      * revert reason using the provided one.
530      *
531      * _Available since v4.3._
532      */
533     function verifyCallResult(
534         bool success,
535         bytes memory returndata,
536         string memory errorMessage
537     ) internal pure returns (bytes memory) {
538         if (success) {
539             return returndata;
540         } else {
541             // Look for revert reason and bubble it up if present
542             if (returndata.length > 0) {
543                 // The easiest way to bubble the revert reason is using memory via assembly
544 
545                 assembly {
546                     let returndata_size := mload(returndata)
547                     revert(add(32, returndata), returndata_size)
548                 }
549             } else {
550                 revert(errorMessage);
551             }
552         }
553     }
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 
565 /**
566  * @title SafeERC20
567  * @dev Wrappers around ERC20 operations that throw on failure (when the token
568  * contract returns false). Tokens that return no value (and instead revert or
569  * throw on failure) are also supported, non-reverting calls are assumed to be
570  * successful.
571  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
572  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
573  */
574 library SafeERC20 {
575     using Address for address;
576 
577     function safeTransfer(
578         IERC20 token,
579         address to,
580         uint256 value
581     ) internal {
582         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
583     }
584 
585     function safeTransferFrom(
586         IERC20 token,
587         address from,
588         address to,
589         uint256 value
590     ) internal {
591         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
592     }
593 
594     /**
595      * @dev Deprecated. This function has issues similar to the ones found in
596      * {IERC20-approve}, and its usage is discouraged.
597      *
598      * Whenever possible, use {safeIncreaseAllowance} and
599      * {safeDecreaseAllowance} instead.
600      */
601     function safeApprove(
602         IERC20 token,
603         address spender,
604         uint256 value
605     ) internal {
606         // safeApprove should only be called when setting an initial allowance,
607         // or when resetting it to zero. To increase and decrease it, use
608         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
609         require(
610             (value == 0) || (token.allowance(address(this), spender) == 0),
611             "SafeERC20: approve from non-zero to non-zero allowance"
612         );
613         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
614     }
615 
616     function safeIncreaseAllowance(
617         IERC20 token,
618         address spender,
619         uint256 value
620     ) internal {
621         uint256 newAllowance = token.allowance(address(this), spender) + value;
622         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
623     }
624 
625     function safeDecreaseAllowance(
626         IERC20 token,
627         address spender,
628         uint256 value
629     ) internal {
630         unchecked {
631             uint256 oldAllowance = token.allowance(address(this), spender);
632             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
633             uint256 newAllowance = oldAllowance - value;
634             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
635         }
636     }
637 
638     /**
639      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
640      * on the return value: the return value is optional (but if data is returned, it must not be false).
641      * @param token The token targeted by the call.
642      * @param data The call data (encoded using abi.encode or one of its variants).
643      */
644     function _callOptionalReturn(IERC20 token, bytes memory data) private {
645         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
646         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
647         // the target address contains contract code and also asserts for success in the low-level call.
648 
649         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
650         if (returndata.length > 0) {
651             // Return data is optional
652             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
653         }
654     }
655 }
656 
657 
658 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @title ERC721 token receiver interface
667  * @dev Interface for any contract that wants to support safeTransfers
668  * from ERC721 asset contracts.
669  */
670 interface IERC721Receiver {
671     /**
672      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
673      * by `operator` from `from`, this function is called.
674      *
675      * It must return its Solidity selector to confirm the token transfer.
676      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
677      *
678      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
679      */
680     function onERC721Received(
681         address operator,
682         address from,
683         uint256 tokenId,
684         bytes calldata data
685     ) external returns (bytes4);
686 }
687 
688 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @dev Interface of the ERC165 standard, as defined in the
697  * https://eips.ethereum.org/EIPS/eip-165[EIP].
698  *
699  * Implementers can declare support of contract interfaces, which can then be
700  * queried by others ({ERC165Checker}).
701  *
702  * For an implementation, see {ERC165}.
703  */
704 interface IERC165 {
705     /**
706      * @dev Returns true if this contract implements the interface defined by
707      * `interfaceId`. See the corresponding
708      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
709      * to learn more about how these ids are created.
710      *
711      * This function call must use less than 30 000 gas.
712      */
713     function supportsInterface(bytes4 interfaceId) external view returns (bool);
714 }
715 
716 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
717 
718 
719 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 
724 /**
725  * @dev Implementation of the {IERC165} interface.
726  *
727  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
728  * for the additional interface id that will be supported. For example:
729  *
730  * ```solidity
731  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
732  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
733  * }
734  * ```
735  *
736  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
737  */
738 abstract contract ERC165 is IERC165 {
739     /**
740      * @dev See {IERC165-supportsInterface}.
741      */
742     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
743         return interfaceId == type(IERC165).interfaceId;
744     }
745 }
746 
747 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
748 
749 
750 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 
755 /**
756  * @dev Required interface of an ERC721 compliant contract.
757  */
758 interface IERC721 is IERC165 {
759     /**
760      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
761      */
762     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
763 
764     /**
765      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
766      */
767     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
768 
769     /**
770      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
771      */
772     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
773 
774     /**
775      * @dev Returns the number of tokens in ``owner``'s account.
776      */
777     function balanceOf(address owner) external view returns (uint256 balance);
778 
779     /**
780      * @dev Returns the owner of the `tokenId` token.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must exist.
785      */
786     function ownerOf(uint256 tokenId) external view returns (address owner);
787 
788     /**
789      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
790      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must exist and be owned by `from`.
797      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) external;
807 
808     /**
809      * @dev Transfers `tokenId` token from `from` to `to`.
810      *
811      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must be owned by `from`.
818      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
819      *
820      * Emits a {Transfer} event.
821      */
822     function transferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) external;
827 
828     /**
829      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
830      * The approval is cleared when the token is transferred.
831      *
832      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
833      *
834      * Requirements:
835      *
836      * - The caller must own the token or be an approved operator.
837      * - `tokenId` must exist.
838      *
839      * Emits an {Approval} event.
840      */
841     function approve(address to, uint256 tokenId) external;
842 
843     /**
844      * @dev Returns the account approved for `tokenId` token.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      */
850     function getApproved(uint256 tokenId) external view returns (address operator);
851 
852     /**
853      * @dev Approve or remove `operator` as an operator for the caller.
854      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
855      *
856      * Requirements:
857      *
858      * - The `operator` cannot be the caller.
859      *
860      * Emits an {ApprovalForAll} event.
861      */
862     function setApprovalForAll(address operator, bool _approved) external;
863 
864     /**
865      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
866      *
867      * See {setApprovalForAll}
868      */
869     function isApprovedForAll(address owner, address operator) external view returns (bool);
870 
871     /**
872      * @dev Safely transfers `tokenId` token from `from` to `to`.
873      *
874      * Requirements:
875      *
876      * - `from` cannot be the zero address.
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must exist and be owned by `from`.
879      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
881      *
882      * Emits a {Transfer} event.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes calldata data
889     ) external;
890 }
891 
892 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
893 
894 
895 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 
900 /**
901  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
902  * @dev See https://eips.ethereum.org/EIPS/eip-721
903  */
904 interface IERC721Enumerable is IERC721 {
905     /**
906      * @dev Returns the total amount of tokens stored by the contract.
907      */
908     function totalSupply() external view returns (uint256);
909 
910     /**
911      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
912      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
913      */
914     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
915 
916     /**
917      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
918      * Use along with {totalSupply} to enumerate all tokens.
919      */
920     function tokenByIndex(uint256 index) external view returns (uint256);
921 }
922 
923 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
924 
925 
926 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
927 
928 pragma solidity ^0.8.0;
929 
930 
931 /**
932  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
933  * @dev See https://eips.ethereum.org/EIPS/eip-721
934  */
935 interface IERC721Metadata is IERC721 {
936     /**
937      * @dev Returns the token collection name.
938      */
939     function name() external view returns (string memory);
940 
941     /**
942      * @dev Returns the token collection symbol.
943      */
944     function symbol() external view returns (string memory);
945 
946     /**
947      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
948      */
949     function tokenURI(uint256 tokenId) external view returns (string memory);
950 }
951 
952 // File: contracts/TwistedToonz.sol
953 
954 
955 // Creator: Chiru Labs
956 
957 pragma solidity ^0.8.0;
958 
959 
960 
961 
962 
963 
964 
965 
966 
967 /**
968  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
969  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
970  *
971  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
972  *
973  * Does not support burning tokens to address(0).
974  *
975  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
976  */
977 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
978     using Address for address;
979     using Strings for uint256;
980 
981     struct TokenOwnership {
982         address addr;
983         uint64 startTimestamp;
984     }
985 
986     struct AddressData {
987         uint128 balance;
988         uint128 numberMinted;
989     }
990 
991     uint256 internal currentIndex;
992 
993     // Token name
994     string private _name;
995 
996     // Token symbol
997     string private _symbol;
998 
999     // Mapping from token ID to ownership details
1000     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1001     mapping(uint256 => TokenOwnership) internal _ownerships;
1002 
1003     // Mapping owner address to address data
1004     mapping(address => AddressData) private _addressData;
1005 
1006     // Mapping from token ID to approved address
1007     mapping(uint256 => address) private _tokenApprovals;
1008 
1009     // Mapping from owner to operator approvals
1010     mapping(address => mapping(address => bool)) private _operatorApprovals;
1011 
1012     constructor(string memory name_, string memory symbol_) {
1013         _name = name_;
1014         _symbol = symbol_;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Enumerable-totalSupply}.
1019      */
1020     function totalSupply() public view override returns (uint256) {
1021         return currentIndex;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Enumerable-tokenByIndex}.
1026      */
1027     function tokenByIndex(uint256 index) public view override returns (uint256) {
1028         require(index < totalSupply(), "ERC721A: global index out of bounds");
1029         return index;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1034      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1035      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1036      */
1037     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1038         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1039         uint256 numMintedSoFar = totalSupply();
1040         uint256 tokenIdsIdx;
1041         address currOwnershipAddr;
1042 
1043         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1044         unchecked {
1045             for (uint256 i; i < numMintedSoFar; i++) {
1046                 TokenOwnership memory ownership = _ownerships[i];
1047                 if (ownership.addr != address(0)) {
1048                     currOwnershipAddr = ownership.addr;
1049                 }
1050                 if (currOwnershipAddr == owner) {
1051                     if (tokenIdsIdx == index) {
1052                         return i;
1053                     }
1054                     tokenIdsIdx++;
1055                 }
1056             }
1057         }
1058 
1059         revert("ERC721A: unable to get token of owner by index");
1060     }
1061 
1062     /**
1063      * @dev See {IERC165-supportsInterface}.
1064      */
1065     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1066         return
1067             interfaceId == type(IERC721).interfaceId ||
1068             interfaceId == type(IERC721Metadata).interfaceId ||
1069             interfaceId == type(IERC721Enumerable).interfaceId ||
1070             super.supportsInterface(interfaceId);
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-balanceOf}.
1075      */
1076     function balanceOf(address owner) public view override returns (uint256) {
1077         require(owner != address(0), "ERC721A: balance query for the zero address");
1078         return uint256(_addressData[owner].balance);
1079     }
1080 
1081     function _numberMinted(address owner) internal view returns (uint256) {
1082         require(owner != address(0), "ERC721A: number minted query for the zero address");
1083         return uint256(_addressData[owner].numberMinted);
1084     }
1085 
1086     /**
1087      * Gas spent here starts off proportional to the maximum mint batch size.
1088      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1089      */
1090     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1091         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1092 
1093         unchecked {
1094             for (uint256 curr = tokenId; curr >= 0; curr--) {
1095                 TokenOwnership memory ownership = _ownerships[curr];
1096                 if (ownership.addr != address(0)) {
1097                     return ownership;
1098                 }
1099             }
1100         }
1101 
1102         revert("ERC721A: unable to determine the owner of token");
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-ownerOf}.
1107      */
1108     function ownerOf(uint256 tokenId) public view override returns (address) {
1109         return ownershipOf(tokenId).addr;
1110     }
1111 
1112     /**
1113      * @dev See {IERC721Metadata-name}.
1114      */
1115     function name() public view virtual override returns (string memory) {
1116         return _name;
1117     }
1118 
1119     /**
1120      * @dev See {IERC721Metadata-symbol}.
1121      */
1122     function symbol() public view virtual override returns (string memory) {
1123         return _symbol;
1124     }
1125 
1126     /**
1127      * @dev See {IERC721Metadata-tokenURI}.
1128      */
1129     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1130         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1131 
1132         string memory baseURI = _baseURI();
1133         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1134     }
1135 
1136     /**
1137      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1138      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1139      * by default, can be overriden in child contracts.
1140      */
1141     function _baseURI() internal view virtual returns (string memory) {
1142         return "";
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-approve}.
1147      */
1148     function approve(address to, uint256 tokenId) public override {
1149         address owner = ERC721A.ownerOf(tokenId);
1150         require(to != owner, "ERC721A: approval to current owner");
1151 
1152         require(
1153             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1154             "ERC721A: approve caller is not owner nor approved for all"
1155         );
1156 
1157         _approve(to, tokenId, owner);
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-getApproved}.
1162      */
1163     function getApproved(uint256 tokenId) public view override returns (address) {
1164         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1165 
1166         return _tokenApprovals[tokenId];
1167     }
1168 
1169     /**
1170      * @dev See {IERC721-setApprovalForAll}.
1171      */
1172     function setApprovalForAll(address operator, bool approved) public override {
1173         require(operator != _msgSender(), "ERC721A: approve to caller");
1174 
1175         _operatorApprovals[_msgSender()][operator] = approved;
1176         emit ApprovalForAll(_msgSender(), operator, approved);
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-isApprovedForAll}.
1181      */
1182     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1183         return _operatorApprovals[owner][operator];
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-transferFrom}.
1188      */
1189     function transferFrom(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) public virtual override {
1194         _transfer(from, to, tokenId);
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-safeTransferFrom}.
1199      */
1200     function safeTransferFrom(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) public virtual override {
1205         safeTransferFrom(from, to, tokenId, "");
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-safeTransferFrom}.
1210      */
1211     function safeTransferFrom(
1212         address from,
1213         address to,
1214         uint256 tokenId,
1215         bytes memory _data
1216     ) public override {
1217         _transfer(from, to, tokenId);
1218         require(
1219             _checkOnERC721Received(from, to, tokenId, _data),
1220             "ERC721A: transfer to non ERC721Receiver implementer"
1221         );
1222     }
1223 
1224     /**
1225      * @dev Returns whether `tokenId` exists.
1226      *
1227      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1228      *
1229      * Tokens start existing when they are minted (`_mint`),
1230      */
1231     function _exists(uint256 tokenId) internal view returns (bool) {
1232         return tokenId < currentIndex;
1233     }
1234 
1235     function _safeMint(address to, uint256 quantity) internal {
1236         _safeMint(to, quantity, "");
1237     }
1238 
1239     /**
1240      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1241      *
1242      * Requirements:
1243      *
1244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1245      * - `quantity` must be greater than 0.
1246      *
1247      * Emits a {Transfer} event.
1248      */
1249     function _safeMint(
1250         address to,
1251         uint256 quantity,
1252         bytes memory _data
1253     ) internal {
1254         _mint(to, quantity, _data, true);
1255     }
1256 
1257     /**
1258      * @dev Mints `quantity` tokens and transfers them to `to`.
1259      *
1260      * Requirements:
1261      *
1262      * - `to` cannot be the zero address.
1263      * - `quantity` must be greater than 0.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function _mint(
1268         address to,
1269         uint256 quantity,
1270         bytes memory _data,
1271         bool safe
1272     ) internal {
1273         uint256 startTokenId = currentIndex;
1274         require(to != address(0), "ERC721A: mint to the zero address");
1275         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1276 
1277         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1278 
1279         // Overflows are incredibly unrealistic.
1280         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1281         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1282         unchecked {
1283             _addressData[to].balance += uint128(quantity);
1284             _addressData[to].numberMinted += uint128(quantity);
1285 
1286             _ownerships[startTokenId].addr = to;
1287             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1288 
1289             uint256 updatedIndex = startTokenId;
1290 
1291             for (uint256 i; i < quantity; i++) {
1292                 emit Transfer(address(0), to, updatedIndex);
1293                 if (safe) {
1294                     require(
1295                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1296                         "ERC721A: transfer to non ERC721Receiver implementer"
1297                     );
1298                 }
1299 
1300                 updatedIndex++;
1301             }
1302 
1303             currentIndex = updatedIndex;
1304         }
1305 
1306         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1307     }
1308 
1309     /**
1310      * @dev Transfers `tokenId` from `from` to `to`.
1311      *
1312      * Requirements:
1313      *
1314      * - `to` cannot be the zero address.
1315      * - `tokenId` token must be owned by `from`.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function _transfer(
1320         address from,
1321         address to,
1322         uint256 tokenId
1323     ) private {
1324         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1325 
1326         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1327             getApproved(tokenId) == _msgSender() ||
1328             isApprovedForAll(prevOwnership.addr, _msgSender()));
1329 
1330         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1331 
1332         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1333         require(to != address(0), "ERC721A: transfer to the zero address");
1334 
1335         _beforeTokenTransfers(from, to, tokenId, 1);
1336 
1337         // Clear approvals from the previous owner
1338         _approve(address(0), tokenId, prevOwnership.addr);
1339 
1340         // Underflow of the sender's balance is impossible because we check for
1341         // ownership above and the recipient's balance can't realistically overflow.
1342         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1343         unchecked {
1344             _addressData[from].balance -= 1;
1345             _addressData[to].balance += 1;
1346 
1347             _ownerships[tokenId].addr = to;
1348             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1349 
1350             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1351             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1352             uint256 nextTokenId = tokenId + 1;
1353             if (_ownerships[nextTokenId].addr == address(0)) {
1354                 if (_exists(nextTokenId)) {
1355                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1356                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1357                 }
1358             }
1359         }
1360 
1361         emit Transfer(from, to, tokenId);
1362         _afterTokenTransfers(from, to, tokenId, 1);
1363     }
1364 
1365     /**
1366      * @dev Approve `to` to operate on `tokenId`
1367      *
1368      * Emits a {Approval} event.
1369      */
1370     function _approve(
1371         address to,
1372         uint256 tokenId,
1373         address owner
1374     ) private {
1375         _tokenApprovals[tokenId] = to;
1376         emit Approval(owner, to, tokenId);
1377     }
1378 
1379     /**
1380      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1381      * The call is not executed if the target address is not a contract.
1382      *
1383      * @param from address representing the previous owner of the given token ID
1384      * @param to target address that will receive the tokens
1385      * @param tokenId uint256 ID of the token to be transferred
1386      * @param _data bytes optional data to send along with the call
1387      * @return bool whether the call correctly returned the expected magic value
1388      */
1389     function _checkOnERC721Received(
1390         address from,
1391         address to,
1392         uint256 tokenId,
1393         bytes memory _data
1394     ) private returns (bool) {
1395         if (to.isContract()) {
1396             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1397                 return retval == IERC721Receiver(to).onERC721Received.selector;
1398             } catch (bytes memory reason) {
1399                 if (reason.length == 0) {
1400                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1401                 } else {
1402                     assembly {
1403                         revert(add(32, reason), mload(reason))
1404                     }
1405                 }
1406             }
1407         } else {
1408             return true;
1409         }
1410     }
1411 
1412     /**
1413      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1414      *
1415      * startTokenId - the first token id to be transferred
1416      * quantity - the amount to be transferred
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1421      * transferred to `to`.
1422      * - When `from` is zero, `tokenId` will be minted for `to`.
1423      */
1424     function _beforeTokenTransfers(
1425         address from,
1426         address to,
1427         uint256 startTokenId,
1428         uint256 quantity
1429     ) internal virtual {}
1430 
1431     /**
1432      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1433      * minting.
1434      *
1435      * startTokenId - the first token id to be transferred
1436      * quantity - the amount to be transferred
1437      *
1438      * Calling conditions:
1439      *
1440      * - when `from` and `to` are both non-zero.
1441      * - `from` and `to` are never both zero.
1442      */
1443     function _afterTokenTransfers(
1444         address from,
1445         address to,
1446         uint256 startTokenId,
1447         uint256 quantity
1448     ) internal virtual {}
1449 }
1450 
1451 contract OkayAzukis is ERC721A, Ownable, ReentrancyGuard {
1452 
1453   string public        baseURI;
1454   uint public          price             = 0.009 ether;
1455   uint public          maxPerTx          = 30;
1456   uint public          maxPerWallet      = 1000;
1457   uint public          totalFree         = 1000;
1458   uint public          maxSupply         = 10000;
1459   uint public          nextOwnerToExplicitlySet;
1460   bool public          mintEnabled;
1461 
1462   constructor() ERC721A("OkayAzukis", "OKAYA"){}
1463 
1464   function mint(uint256 amt) external payable
1465   {
1466     uint cost = price;
1467     if(totalSupply() + amt < totalFree + 1) {
1468       cost = 0;
1469     }
1470 
1471     require(msg.value == amt * cost,"Please send the exact amount.");
1472     require(msg.sender == tx.origin,"Be yourself.");
1473     require(totalSupply() + amt < maxSupply + 1,"No more okay azuki");
1474     require(mintEnabled, "Minting is not live yet, hold on okay azuki.");
1475     require(numberMinted(msg.sender) + amt <= maxPerWallet,"Too many per wallet!");
1476     require( amt < maxPerTx + 1, "Max per TX reached.");
1477 
1478     _safeMint(msg.sender, amt);
1479   }
1480 
1481   function ownerBatchMint(uint256 amt) external onlyOwner
1482   {
1483     require(totalSupply() + amt < maxSupply + 1,"too many!");
1484 
1485     _safeMint(msg.sender, amt);
1486   }
1487 
1488   function toggleMinting() external onlyOwner {
1489       mintEnabled = !mintEnabled;
1490   }
1491 
1492   function numberMinted(address owner) public view returns (uint256) {
1493     return _numberMinted(owner);
1494   }
1495 
1496   function setBaseURI(string calldata baseURI_) external onlyOwner {
1497     baseURI = baseURI_;
1498   }
1499 
1500   function setPrice(uint256 price_) external onlyOwner {
1501       price = price_;
1502   }
1503 
1504   function setTotalFree(uint256 totalFree_) external onlyOwner {
1505       totalFree = totalFree_;
1506   }
1507 
1508   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1509       maxPerTx = maxPerTx_;
1510   }
1511 
1512   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1513       maxPerWallet = maxPerWallet_;
1514   }
1515 
1516   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1517       maxSupply = maxSupply_;
1518   }
1519 
1520   function _baseURI() internal view virtual override returns (string memory) {
1521     return baseURI;
1522   }
1523 
1524   function withdraw() external onlyOwner nonReentrant {
1525     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1526     require(success, "Transfer failed.");
1527   }
1528 
1529   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1530     _setOwnersExplicit(quantity);
1531   }
1532 
1533   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1534   {
1535     return ownershipOf(tokenId);
1536   }
1537 
1538 
1539   /**
1540     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1541     */
1542   function _setOwnersExplicit(uint256 quantity) internal {
1543       require(quantity != 0, "quantity must be nonzero");
1544       require(currentIndex != 0, "no tokens minted yet");
1545       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1546       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1547 
1548       // Index underflow is impossible.
1549       // Counter or index overflow is incredibly unrealistic.
1550       unchecked {
1551           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1552 
1553           // Set the end index to be the last token index
1554           if (endIndex + 1 > currentIndex) {
1555               endIndex = currentIndex - 1;
1556           }
1557 
1558           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1559               if (_ownerships[i].addr == address(0)) {
1560                   TokenOwnership memory ownership = ownershipOf(i);
1561                   _ownerships[i].addr = ownership.addr;
1562                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1563               }
1564           }
1565 
1566           nextOwnerToExplicitlySet = endIndex + 1;
1567       }
1568   }
1569 }