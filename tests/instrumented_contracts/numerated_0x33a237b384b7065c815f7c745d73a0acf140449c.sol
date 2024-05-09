1 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title ERC721 token receiver interface
10  * @dev Interface for any contract that wants to support safeTransfers
11  * from ERC721 asset contracts.
12  */
13 interface IERC721Receiver {
14     /**
15      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
16      * by `operator` from `from`, this function is called.
17      *
18      * It must return its Solidity selector to confirm the token transfer.
19      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
20      *
21      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
22      */
23     function onERC721Received(
24         address operator,
25         address from,
26         uint256 tokenId,
27         bytes calldata data
28     ) external returns (bytes4);
29 }
30 
31 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Interface of the ERC165 standard, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-165[EIP].
41  *
42  * Implementers can declare support of contract interfaces, which can then be
43  * queried by others ({ERC165Checker}).
44  *
45  * For an implementation, see {ERC165}.
46  */
47 interface IERC165 {
48     /**
49      * @dev Returns true if this contract implements the interface defined by
50      * `interfaceId`. See the corresponding
51      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
52      * to learn more about how these ids are created.
53      *
54      * This function call must use less than 30 000 gas.
55      */
56     function supportsInterface(bytes4 interfaceId) external view returns (bool);
57 }
58 
59 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
60 
61 
62 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 
67 /**
68  * @dev Implementation of the {IERC165} interface.
69  *
70  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
71  * for the additional interface id that will be supported. For example:
72  *
73  * ```solidity
74  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
75  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
76  * }
77  * ```
78  *
79  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
80  */
81 abstract contract ERC165 is IERC165 {
82     /**
83      * @dev See {IERC165-supportsInterface}.
84      */
85     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
86         return interfaceId == type(IERC165).interfaceId;
87     }
88 }
89 
90 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 
98 /**
99  * @dev Required interface of an ERC721 compliant contract.
100  */
101 interface IERC721 is IERC165 {
102     /**
103      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
106 
107     /**
108      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
109      */
110     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
111 
112     /**
113      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
114      */
115     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
116 
117     /**
118      * @dev Returns the number of tokens in ``owner``'s account.
119      */
120     function balanceOf(address owner) external view returns (uint256 balance);
121 
122     /**
123      * @dev Returns the owner of the `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function ownerOf(uint256 tokenId) external view returns (address owner);
130 
131     /**
132      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
133      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
134      *
135      * Requirements:
136      *
137      * - `from` cannot be the zero address.
138      * - `to` cannot be the zero address.
139      * - `tokenId` token must exist and be owned by `from`.
140      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
141      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
142      *
143      * Emits a {Transfer} event.
144      */
145     function safeTransferFrom(
146         address from,
147         address to,
148         uint256 tokenId
149     ) external;
150 
151     /**
152      * @dev Transfers `tokenId` token from `from` to `to`.
153      *
154      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(
166         address from,
167         address to,
168         uint256 tokenId
169     ) external;
170 
171     /**
172      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
173      * The approval is cleared when the token is transferred.
174      *
175      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
176      *
177      * Requirements:
178      *
179      * - The caller must own the token or be an approved operator.
180      * - `tokenId` must exist.
181      *
182      * Emits an {Approval} event.
183      */
184     function approve(address to, uint256 tokenId) external;
185 
186     /**
187      * @dev Returns the account approved for `tokenId` token.
188      *
189      * Requirements:
190      *
191      * - `tokenId` must exist.
192      */
193     function getApproved(uint256 tokenId) external view returns (address operator);
194 
195     /**
196      * @dev Approve or remove `operator` as an operator for the caller.
197      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
198      *
199      * Requirements:
200      *
201      * - The `operator` cannot be the caller.
202      *
203      * Emits an {ApprovalForAll} event.
204      */
205     function setApprovalForAll(address operator, bool _approved) external;
206 
207     /**
208      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
209      *
210      * See {setApprovalForAll}
211      */
212     function isApprovedForAll(address owner, address operator) external view returns (bool);
213 
214     /**
215      * @dev Safely transfers `tokenId` token from `from` to `to`.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must exist and be owned by `from`.
222      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
223      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
224      *
225      * Emits a {Transfer} event.
226      */
227     function safeTransferFrom(
228         address from,
229         address to,
230         uint256 tokenId,
231         bytes calldata data
232     ) external;
233 }
234 
235 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 
243 /**
244  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
245  * @dev See https://eips.ethereum.org/EIPS/eip-721
246  */
247 interface IERC721Enumerable is IERC721 {
248     /**
249      * @dev Returns the total amount of tokens stored by the contract.
250      */
251     function totalSupply() external view returns (uint256);
252 
253     /**
254      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
255      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
256      */
257     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
258 
259     /**
260      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
261      * Use along with {totalSupply} to enumerate all tokens.
262      */
263     function tokenByIndex(uint256 index) external view returns (uint256);
264 }
265 
266 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
267 
268 
269 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 
274 /**
275  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
276  * @dev See https://eips.ethereum.org/EIPS/eip-721
277  */
278 interface IERC721Metadata is IERC721 {
279     /**
280      * @dev Returns the token collection name.
281      */
282     function name() external view returns (string memory);
283 
284     /**
285      * @dev Returns the token collection symbol.
286      */
287     function symbol() external view returns (string memory);
288 
289     /**
290      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
291      */
292     function tokenURI(uint256 tokenId) external view returns (string memory);
293 }
294 
295 // File: @openzeppelin/contracts/utils/Address.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies on extcodesize, which returns 0 for contracts in
325         // construction, since the code is only stored at the end of the
326         // constructor execution.
327 
328         uint256 size;
329         assembly {
330             size := extcodesize(account)
331         }
332         return size > 0;
333     }
334 
335     /**
336      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
337      * `recipient`, forwarding all available gas and reverting on errors.
338      *
339      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
340      * of certain opcodes, possibly making contracts go over the 2300 gas limit
341      * imposed by `transfer`, making them unable to receive funds via
342      * `transfer`. {sendValue} removes this limitation.
343      *
344      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
345      *
346      * IMPORTANT: because control is transferred to `recipient`, care must be
347      * taken to not create reentrancy vulnerabilities. Consider using
348      * {ReentrancyGuard} or the
349      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
350      */
351     function sendValue(address payable recipient, uint256 amount) internal {
352         require(address(this).balance >= amount, "Address: insufficient balance");
353 
354         (bool success, ) = recipient.call{value: amount}("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain `call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         return functionCallWithValue(target, data, 0, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but also transferring `value` wei to `target`.
397      *
398      * Requirements:
399      *
400      * - the calling contract must have an ETH balance of at least `value`.
401      * - the called Solidity function must be `payable`.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(
406         address target,
407         bytes memory data,
408         uint256 value
409     ) internal returns (bytes memory) {
410         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
415      * with `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(address(this).balance >= value, "Address: insufficient balance for call");
426         require(isContract(target), "Address: call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.call{value: value}(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
439         return functionStaticCall(target, data, "Address: low-level static call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal view returns (bytes memory) {
453         require(isContract(target), "Address: static call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.staticcall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461      * but performing a delegate call.
462      *
463      * _Available since v3.4._
464      */
465     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
466         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(
476         address target,
477         bytes memory data,
478         string memory errorMessage
479     ) internal returns (bytes memory) {
480         require(isContract(target), "Address: delegate call to non-contract");
481 
482         (bool success, bytes memory returndata) = target.delegatecall(data);
483         return verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
488      * revert reason using the provided one.
489      *
490      * _Available since v4.3._
491      */
492     function verifyCallResult(
493         bool success,
494         bytes memory returndata,
495         string memory errorMessage
496     ) internal pure returns (bytes memory) {
497         if (success) {
498             return returndata;
499         } else {
500             // Look for revert reason and bubble it up if present
501             if (returndata.length > 0) {
502                 // The easiest way to bubble the revert reason is using memory via assembly
503 
504                 assembly {
505                     let returndata_size := mload(returndata)
506                     revert(add(32, returndata), returndata_size)
507                 }
508             } else {
509                 revert(errorMessage);
510             }
511         }
512     }
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Interface of the ERC20 standard as defined in the EIP.
524  */
525 interface IERC20 {
526     /**
527      * @dev Returns the amount of tokens in existence.
528      */
529     function totalSupply() external view returns (uint256);
530 
531     /**
532      * @dev Returns the amount of tokens owned by `account`.
533      */
534     function balanceOf(address account) external view returns (uint256);
535 
536     /**
537      * @dev Moves `amount` tokens from the caller's account to `recipient`.
538      *
539      * Returns a boolean value indicating whether the operation succeeded.
540      *
541      * Emits a {Transfer} event.
542      */
543     function transfer(address recipient, uint256 amount) external returns (bool);
544 
545     /**
546      * @dev Returns the remaining number of tokens that `spender` will be
547      * allowed to spend on behalf of `owner` through {transferFrom}. This is
548      * zero by default.
549      *
550      * This value changes when {approve} or {transferFrom} are called.
551      */
552     function allowance(address owner, address spender) external view returns (uint256);
553 
554     /**
555      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
556      *
557      * Returns a boolean value indicating whether the operation succeeded.
558      *
559      * IMPORTANT: Beware that changing an allowance with this method brings the risk
560      * that someone may use both the old and the new allowance by unfortunate
561      * transaction ordering. One possible solution to mitigate this race
562      * condition is to first reduce the spender's allowance to 0 and set the
563      * desired value afterwards:
564      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
565      *
566      * Emits an {Approval} event.
567      */
568     function approve(address spender, uint256 amount) external returns (bool);
569 
570     /**
571      * @dev Moves `amount` tokens from `sender` to `recipient` using the
572      * allowance mechanism. `amount` is then deducted from the caller's
573      * allowance.
574      *
575      * Returns a boolean value indicating whether the operation succeeded.
576      *
577      * Emits a {Transfer} event.
578      */
579     function transferFrom(
580         address sender,
581         address recipient,
582         uint256 amount
583     ) external returns (bool);
584 
585     /**
586      * @dev Emitted when `value` tokens are moved from one account (`from`) to
587      * another (`to`).
588      *
589      * Note that `value` may be zero.
590      */
591     event Transfer(address indexed from, address indexed to, uint256 value);
592 
593     /**
594      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
595      * a call to {approve}. `value` is the new allowance.
596      */
597     event Approval(address indexed owner, address indexed spender, uint256 value);
598 }
599 
600 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 
608 
609 /**
610  * @title SafeERC20
611  * @dev Wrappers around ERC20 operations that throw on failure (when the token
612  * contract returns false). Tokens that return no value (and instead revert or
613  * throw on failure) are also supported, non-reverting calls are assumed to be
614  * successful.
615  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
616  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
617  */
618 library SafeERC20 {
619     using Address for address;
620 
621     function safeTransfer(
622         IERC20 token,
623         address to,
624         uint256 value
625     ) internal {
626         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
627     }
628 
629     function safeTransferFrom(
630         IERC20 token,
631         address from,
632         address to,
633         uint256 value
634     ) internal {
635         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
636     }
637 
638     /**
639      * @dev Deprecated. This function has issues similar to the ones found in
640      * {IERC20-approve}, and its usage is discouraged.
641      *
642      * Whenever possible, use {safeIncreaseAllowance} and
643      * {safeDecreaseAllowance} instead.
644      */
645     function safeApprove(
646         IERC20 token,
647         address spender,
648         uint256 value
649     ) internal {
650         // safeApprove should only be called when setting an initial allowance,
651         // or when resetting it to zero. To increase and decrease it, use
652         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
653         require(
654             (value == 0) || (token.allowance(address(this), spender) == 0),
655             "SafeERC20: approve from non-zero to non-zero allowance"
656         );
657         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
658     }
659 
660     function safeIncreaseAllowance(
661         IERC20 token,
662         address spender,
663         uint256 value
664     ) internal {
665         uint256 newAllowance = token.allowance(address(this), spender) + value;
666         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
667     }
668 
669     function safeDecreaseAllowance(
670         IERC20 token,
671         address spender,
672         uint256 value
673     ) internal {
674         unchecked {
675             uint256 oldAllowance = token.allowance(address(this), spender);
676             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
677             uint256 newAllowance = oldAllowance - value;
678             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
679         }
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
694         if (returndata.length > 0) {
695             // Return data is optional
696             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
697         }
698     }
699 }
700 
701 // File: @openzeppelin/contracts/utils/Strings.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @dev String operations.
710  */
711 library Strings {
712     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
713 
714     /**
715      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
716      */
717     function toString(uint256 value) internal pure returns (string memory) {
718         // Inspired by OraclizeAPI's implementation - MIT licence
719         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
720 
721         if (value == 0) {
722             return "0";
723         }
724         uint256 temp = value;
725         uint256 digits;
726         while (temp != 0) {
727             digits++;
728             temp /= 10;
729         }
730         bytes memory buffer = new bytes(digits);
731         while (value != 0) {
732             digits -= 1;
733             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
734             value /= 10;
735         }
736         return string(buffer);
737     }
738 
739     /**
740      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
741      */
742     function toHexString(uint256 value) internal pure returns (string memory) {
743         if (value == 0) {
744             return "0x00";
745         }
746         uint256 temp = value;
747         uint256 length = 0;
748         while (temp != 0) {
749             length++;
750             temp >>= 8;
751         }
752         return toHexString(value, length);
753     }
754 
755     /**
756      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
757      */
758     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
759         bytes memory buffer = new bytes(2 * length + 2);
760         buffer[0] = "0";
761         buffer[1] = "x";
762         for (uint256 i = 2 * length + 1; i > 1; --i) {
763             buffer[i] = _HEX_SYMBOLS[value & 0xf];
764             value >>= 4;
765         }
766         require(value == 0, "Strings: hex length insufficient");
767         return string(buffer);
768     }
769 }
770 
771 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
772 
773 
774 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 
779 /**
780  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
781  *
782  * These functions can be used to verify that a message was signed by the holder
783  * of the private keys of a given address.
784  */
785 library ECDSA {
786     enum RecoverError {
787         NoError,
788         InvalidSignature,
789         InvalidSignatureLength,
790         InvalidSignatureS,
791         InvalidSignatureV
792     }
793 
794     function _throwError(RecoverError error) private pure {
795         if (error == RecoverError.NoError) {
796             return; // no error: do nothing
797         } else if (error == RecoverError.InvalidSignature) {
798             revert("ECDSA: invalid signature");
799         } else if (error == RecoverError.InvalidSignatureLength) {
800             revert("ECDSA: invalid signature length");
801         } else if (error == RecoverError.InvalidSignatureS) {
802             revert("ECDSA: invalid signature 's' value");
803         } else if (error == RecoverError.InvalidSignatureV) {
804             revert("ECDSA: invalid signature 'v' value");
805         }
806     }
807 
808     /**
809      * @dev Returns the address that signed a hashed message (`hash`) with
810      * `signature` or error string. This address can then be used for verification purposes.
811      *
812      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
813      * this function rejects them by requiring the `s` value to be in the lower
814      * half order, and the `v` value to be either 27 or 28.
815      *
816      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
817      * verification to be secure: it is possible to craft signatures that
818      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
819      * this is by receiving a hash of the original message (which may otherwise
820      * be too long), and then calling {toEthSignedMessageHash} on it.
821      *
822      * Documentation for signature generation:
823      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
824      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
825      *
826      * _Available since v4.3._
827      */
828     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
829         // Check the signature length
830         // - case 65: r,s,v signature (standard)
831         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
832         if (signature.length == 65) {
833             bytes32 r;
834             bytes32 s;
835             uint8 v;
836             // ecrecover takes the signature parameters, and the only way to get them
837             // currently is to use assembly.
838             assembly {
839                 r := mload(add(signature, 0x20))
840                 s := mload(add(signature, 0x40))
841                 v := byte(0, mload(add(signature, 0x60)))
842             }
843             return tryRecover(hash, v, r, s);
844         } else if (signature.length == 64) {
845             bytes32 r;
846             bytes32 vs;
847             // ecrecover takes the signature parameters, and the only way to get them
848             // currently is to use assembly.
849             assembly {
850                 r := mload(add(signature, 0x20))
851                 vs := mload(add(signature, 0x40))
852             }
853             return tryRecover(hash, r, vs);
854         } else {
855             return (address(0), RecoverError.InvalidSignatureLength);
856         }
857     }
858 
859     /**
860      * @dev Returns the address that signed a hashed message (`hash`) with
861      * `signature`. This address can then be used for verification purposes.
862      *
863      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
864      * this function rejects them by requiring the `s` value to be in the lower
865      * half order, and the `v` value to be either 27 or 28.
866      *
867      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
868      * verification to be secure: it is possible to craft signatures that
869      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
870      * this is by receiving a hash of the original message (which may otherwise
871      * be too long), and then calling {toEthSignedMessageHash} on it.
872      */
873     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
874         (address recovered, RecoverError error) = tryRecover(hash, signature);
875         _throwError(error);
876         return recovered;
877     }
878 
879     /**
880      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
881      *
882      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
883      *
884      * _Available since v4.3._
885      */
886     function tryRecover(
887         bytes32 hash,
888         bytes32 r,
889         bytes32 vs
890     ) internal pure returns (address, RecoverError) {
891         bytes32 s;
892         uint8 v;
893         assembly {
894             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
895             v := add(shr(255, vs), 27)
896         }
897         return tryRecover(hash, v, r, s);
898     }
899 
900     /**
901      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
902      *
903      * _Available since v4.2._
904      */
905     function recover(
906         bytes32 hash,
907         bytes32 r,
908         bytes32 vs
909     ) internal pure returns (address) {
910         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
911         _throwError(error);
912         return recovered;
913     }
914 
915     /**
916      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
917      * `r` and `s` signature fields separately.
918      *
919      * _Available since v4.3._
920      */
921     function tryRecover(
922         bytes32 hash,
923         uint8 v,
924         bytes32 r,
925         bytes32 s
926     ) internal pure returns (address, RecoverError) {
927         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
928         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
929         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
930         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
931         //
932         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
933         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
934         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
935         // these malleable signatures as well.
936         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
937             return (address(0), RecoverError.InvalidSignatureS);
938         }
939         if (v != 27 && v != 28) {
940             return (address(0), RecoverError.InvalidSignatureV);
941         }
942 
943         // If the signature is valid (and not malleable), return the signer address
944         address signer = ecrecover(hash, v, r, s);
945         if (signer == address(0)) {
946             return (address(0), RecoverError.InvalidSignature);
947         }
948 
949         return (signer, RecoverError.NoError);
950     }
951 
952     /**
953      * @dev Overload of {ECDSA-recover} that receives the `v`,
954      * `r` and `s` signature fields separately.
955      */
956     function recover(
957         bytes32 hash,
958         uint8 v,
959         bytes32 r,
960         bytes32 s
961     ) internal pure returns (address) {
962         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
963         _throwError(error);
964         return recovered;
965     }
966 
967     /**
968      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
969      * produces hash corresponding to the one signed with the
970      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
971      * JSON-RPC method as part of EIP-191.
972      *
973      * See {recover}.
974      */
975     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
976         // 32 is the length in bytes of hash,
977         // enforced by the type signature above
978         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
979     }
980 
981     /**
982      * @dev Returns an Ethereum Signed Message, created from `s`. This
983      * produces hash corresponding to the one signed with the
984      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
985      * JSON-RPC method as part of EIP-191.
986      *
987      * See {recover}.
988      */
989     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
990         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
991     }
992 
993     /**
994      * @dev Returns an Ethereum Signed Typed Data, created from a
995      * `domainSeparator` and a `structHash`. This produces hash corresponding
996      * to the one signed with the
997      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
998      * JSON-RPC method as part of EIP-712.
999      *
1000      * See {recover}.
1001      */
1002     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1003         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1004     }
1005 }
1006 
1007 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 /**
1016  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1017  *
1018  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1019  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1020  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1021  *
1022  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1023  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1024  * ({_hashTypedDataV4}).
1025  *
1026  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1027  * the chain id to protect against replay attacks on an eventual fork of the chain.
1028  *
1029  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1030  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1031  *
1032  * _Available since v3.4._
1033  */
1034 abstract contract EIP712 {
1035     /* solhint-disable var-name-mixedcase */
1036     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1037     // invalidate the cached domain separator if the chain id changes.
1038     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1039     uint256 private immutable _CACHED_CHAIN_ID;
1040     address private immutable _CACHED_THIS;
1041 
1042     bytes32 private immutable _HASHED_NAME;
1043     bytes32 private immutable _HASHED_VERSION;
1044     bytes32 private immutable _TYPE_HASH;
1045 
1046     /* solhint-enable var-name-mixedcase */
1047 
1048     /**
1049      * @dev Initializes the domain separator and parameter caches.
1050      *
1051      * The meaning of `name` and `version` is specified in
1052      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1053      *
1054      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1055      * - `version`: the current major version of the signing domain.
1056      *
1057      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1058      * contract upgrade].
1059      */
1060     constructor(string memory name, string memory version) {
1061         bytes32 hashedName = keccak256(bytes(name));
1062         bytes32 hashedVersion = keccak256(bytes(version));
1063         bytes32 typeHash = keccak256(
1064             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1065         );
1066         _HASHED_NAME = hashedName;
1067         _HASHED_VERSION = hashedVersion;
1068         _CACHED_CHAIN_ID = block.chainid;
1069         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1070         _CACHED_THIS = address(this);
1071         _TYPE_HASH = typeHash;
1072     }
1073 
1074     /**
1075      * @dev Returns the domain separator for the current chain.
1076      */
1077     function _domainSeparatorV4() internal view returns (bytes32) {
1078         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1079             return _CACHED_DOMAIN_SEPARATOR;
1080         } else {
1081             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1082         }
1083     }
1084 
1085     function _buildDomainSeparator(
1086         bytes32 typeHash,
1087         bytes32 nameHash,
1088         bytes32 versionHash
1089     ) private view returns (bytes32) {
1090         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1091     }
1092 
1093     /**
1094      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1095      * function returns the hash of the fully encoded EIP712 message for this domain.
1096      *
1097      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1098      *
1099      * ```solidity
1100      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1101      *     keccak256("Mail(address to,string contents)"),
1102      *     mailTo,
1103      *     keccak256(bytes(mailContents))
1104      * )));
1105      * address signer = ECDSA.recover(digest, signature);
1106      * ```
1107      */
1108     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1109         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1110     }
1111 }
1112 
1113 // File: hardhat/console.sol
1114 
1115 
1116 pragma solidity >= 0.4.22 <0.9.0;
1117 
1118 library console {
1119 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1120 
1121 	function _sendLogPayload(bytes memory payload) private view {
1122 		uint256 payloadLength = payload.length;
1123 		address consoleAddress = CONSOLE_ADDRESS;
1124 		assembly {
1125 			let payloadStart := add(payload, 32)
1126 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1127 		}
1128 	}
1129 
1130 	function log() internal view {
1131 		_sendLogPayload(abi.encodeWithSignature("log()"));
1132 	}
1133 
1134 	function logInt(int p0) internal view {
1135 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1136 	}
1137 
1138 	function logUint(uint p0) internal view {
1139 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1140 	}
1141 
1142 	function logString(string memory p0) internal view {
1143 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1144 	}
1145 
1146 	function logBool(bool p0) internal view {
1147 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1148 	}
1149 
1150 	function logAddress(address p0) internal view {
1151 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1152 	}
1153 
1154 	function logBytes(bytes memory p0) internal view {
1155 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1156 	}
1157 
1158 	function logBytes1(bytes1 p0) internal view {
1159 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1160 	}
1161 
1162 	function logBytes2(bytes2 p0) internal view {
1163 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1164 	}
1165 
1166 	function logBytes3(bytes3 p0) internal view {
1167 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1168 	}
1169 
1170 	function logBytes4(bytes4 p0) internal view {
1171 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1172 	}
1173 
1174 	function logBytes5(bytes5 p0) internal view {
1175 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1176 	}
1177 
1178 	function logBytes6(bytes6 p0) internal view {
1179 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1180 	}
1181 
1182 	function logBytes7(bytes7 p0) internal view {
1183 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1184 	}
1185 
1186 	function logBytes8(bytes8 p0) internal view {
1187 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1188 	}
1189 
1190 	function logBytes9(bytes9 p0) internal view {
1191 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1192 	}
1193 
1194 	function logBytes10(bytes10 p0) internal view {
1195 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1196 	}
1197 
1198 	function logBytes11(bytes11 p0) internal view {
1199 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1200 	}
1201 
1202 	function logBytes12(bytes12 p0) internal view {
1203 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1204 	}
1205 
1206 	function logBytes13(bytes13 p0) internal view {
1207 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1208 	}
1209 
1210 	function logBytes14(bytes14 p0) internal view {
1211 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1212 	}
1213 
1214 	function logBytes15(bytes15 p0) internal view {
1215 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1216 	}
1217 
1218 	function logBytes16(bytes16 p0) internal view {
1219 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1220 	}
1221 
1222 	function logBytes17(bytes17 p0) internal view {
1223 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1224 	}
1225 
1226 	function logBytes18(bytes18 p0) internal view {
1227 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1228 	}
1229 
1230 	function logBytes19(bytes19 p0) internal view {
1231 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1232 	}
1233 
1234 	function logBytes20(bytes20 p0) internal view {
1235 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1236 	}
1237 
1238 	function logBytes21(bytes21 p0) internal view {
1239 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1240 	}
1241 
1242 	function logBytes22(bytes22 p0) internal view {
1243 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1244 	}
1245 
1246 	function logBytes23(bytes23 p0) internal view {
1247 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1248 	}
1249 
1250 	function logBytes24(bytes24 p0) internal view {
1251 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1252 	}
1253 
1254 	function logBytes25(bytes25 p0) internal view {
1255 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1256 	}
1257 
1258 	function logBytes26(bytes26 p0) internal view {
1259 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1260 	}
1261 
1262 	function logBytes27(bytes27 p0) internal view {
1263 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1264 	}
1265 
1266 	function logBytes28(bytes28 p0) internal view {
1267 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1268 	}
1269 
1270 	function logBytes29(bytes29 p0) internal view {
1271 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1272 	}
1273 
1274 	function logBytes30(bytes30 p0) internal view {
1275 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1276 	}
1277 
1278 	function logBytes31(bytes31 p0) internal view {
1279 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1280 	}
1281 
1282 	function logBytes32(bytes32 p0) internal view {
1283 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1284 	}
1285 
1286 	function log(uint p0) internal view {
1287 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1288 	}
1289 
1290 	function log(string memory p0) internal view {
1291 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1292 	}
1293 
1294 	function log(bool p0) internal view {
1295 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1296 	}
1297 
1298 	function log(address p0) internal view {
1299 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1300 	}
1301 
1302 	function log(uint p0, uint p1) internal view {
1303 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1304 	}
1305 
1306 	function log(uint p0, string memory p1) internal view {
1307 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1308 	}
1309 
1310 	function log(uint p0, bool p1) internal view {
1311 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1312 	}
1313 
1314 	function log(uint p0, address p1) internal view {
1315 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1316 	}
1317 
1318 	function log(string memory p0, uint p1) internal view {
1319 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1320 	}
1321 
1322 	function log(string memory p0, string memory p1) internal view {
1323 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1324 	}
1325 
1326 	function log(string memory p0, bool p1) internal view {
1327 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1328 	}
1329 
1330 	function log(string memory p0, address p1) internal view {
1331 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1332 	}
1333 
1334 	function log(bool p0, uint p1) internal view {
1335 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1336 	}
1337 
1338 	function log(bool p0, string memory p1) internal view {
1339 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1340 	}
1341 
1342 	function log(bool p0, bool p1) internal view {
1343 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1344 	}
1345 
1346 	function log(bool p0, address p1) internal view {
1347 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1348 	}
1349 
1350 	function log(address p0, uint p1) internal view {
1351 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1352 	}
1353 
1354 	function log(address p0, string memory p1) internal view {
1355 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1356 	}
1357 
1358 	function log(address p0, bool p1) internal view {
1359 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1360 	}
1361 
1362 	function log(address p0, address p1) internal view {
1363 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1364 	}
1365 
1366 	function log(uint p0, uint p1, uint p2) internal view {
1367 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1368 	}
1369 
1370 	function log(uint p0, uint p1, string memory p2) internal view {
1371 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1372 	}
1373 
1374 	function log(uint p0, uint p1, bool p2) internal view {
1375 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1376 	}
1377 
1378 	function log(uint p0, uint p1, address p2) internal view {
1379 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1380 	}
1381 
1382 	function log(uint p0, string memory p1, uint p2) internal view {
1383 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1384 	}
1385 
1386 	function log(uint p0, string memory p1, string memory p2) internal view {
1387 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1388 	}
1389 
1390 	function log(uint p0, string memory p1, bool p2) internal view {
1391 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1392 	}
1393 
1394 	function log(uint p0, string memory p1, address p2) internal view {
1395 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1396 	}
1397 
1398 	function log(uint p0, bool p1, uint p2) internal view {
1399 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1400 	}
1401 
1402 	function log(uint p0, bool p1, string memory p2) internal view {
1403 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1404 	}
1405 
1406 	function log(uint p0, bool p1, bool p2) internal view {
1407 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1408 	}
1409 
1410 	function log(uint p0, bool p1, address p2) internal view {
1411 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1412 	}
1413 
1414 	function log(uint p0, address p1, uint p2) internal view {
1415 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1416 	}
1417 
1418 	function log(uint p0, address p1, string memory p2) internal view {
1419 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1420 	}
1421 
1422 	function log(uint p0, address p1, bool p2) internal view {
1423 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1424 	}
1425 
1426 	function log(uint p0, address p1, address p2) internal view {
1427 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1428 	}
1429 
1430 	function log(string memory p0, uint p1, uint p2) internal view {
1431 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1432 	}
1433 
1434 	function log(string memory p0, uint p1, string memory p2) internal view {
1435 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1436 	}
1437 
1438 	function log(string memory p0, uint p1, bool p2) internal view {
1439 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1440 	}
1441 
1442 	function log(string memory p0, uint p1, address p2) internal view {
1443 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1444 	}
1445 
1446 	function log(string memory p0, string memory p1, uint p2) internal view {
1447 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1448 	}
1449 
1450 	function log(string memory p0, string memory p1, string memory p2) internal view {
1451 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1452 	}
1453 
1454 	function log(string memory p0, string memory p1, bool p2) internal view {
1455 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1456 	}
1457 
1458 	function log(string memory p0, string memory p1, address p2) internal view {
1459 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1460 	}
1461 
1462 	function log(string memory p0, bool p1, uint p2) internal view {
1463 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1464 	}
1465 
1466 	function log(string memory p0, bool p1, string memory p2) internal view {
1467 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1468 	}
1469 
1470 	function log(string memory p0, bool p1, bool p2) internal view {
1471 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1472 	}
1473 
1474 	function log(string memory p0, bool p1, address p2) internal view {
1475 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1476 	}
1477 
1478 	function log(string memory p0, address p1, uint p2) internal view {
1479 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1480 	}
1481 
1482 	function log(string memory p0, address p1, string memory p2) internal view {
1483 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1484 	}
1485 
1486 	function log(string memory p0, address p1, bool p2) internal view {
1487 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1488 	}
1489 
1490 	function log(string memory p0, address p1, address p2) internal view {
1491 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1492 	}
1493 
1494 	function log(bool p0, uint p1, uint p2) internal view {
1495 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1496 	}
1497 
1498 	function log(bool p0, uint p1, string memory p2) internal view {
1499 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1500 	}
1501 
1502 	function log(bool p0, uint p1, bool p2) internal view {
1503 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1504 	}
1505 
1506 	function log(bool p0, uint p1, address p2) internal view {
1507 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1508 	}
1509 
1510 	function log(bool p0, string memory p1, uint p2) internal view {
1511 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1512 	}
1513 
1514 	function log(bool p0, string memory p1, string memory p2) internal view {
1515 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1516 	}
1517 
1518 	function log(bool p0, string memory p1, bool p2) internal view {
1519 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1520 	}
1521 
1522 	function log(bool p0, string memory p1, address p2) internal view {
1523 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1524 	}
1525 
1526 	function log(bool p0, bool p1, uint p2) internal view {
1527 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1528 	}
1529 
1530 	function log(bool p0, bool p1, string memory p2) internal view {
1531 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1532 	}
1533 
1534 	function log(bool p0, bool p1, bool p2) internal view {
1535 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1536 	}
1537 
1538 	function log(bool p0, bool p1, address p2) internal view {
1539 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1540 	}
1541 
1542 	function log(bool p0, address p1, uint p2) internal view {
1543 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1544 	}
1545 
1546 	function log(bool p0, address p1, string memory p2) internal view {
1547 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1548 	}
1549 
1550 	function log(bool p0, address p1, bool p2) internal view {
1551 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1552 	}
1553 
1554 	function log(bool p0, address p1, address p2) internal view {
1555 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1556 	}
1557 
1558 	function log(address p0, uint p1, uint p2) internal view {
1559 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1560 	}
1561 
1562 	function log(address p0, uint p1, string memory p2) internal view {
1563 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1564 	}
1565 
1566 	function log(address p0, uint p1, bool p2) internal view {
1567 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1568 	}
1569 
1570 	function log(address p0, uint p1, address p2) internal view {
1571 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1572 	}
1573 
1574 	function log(address p0, string memory p1, uint p2) internal view {
1575 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1576 	}
1577 
1578 	function log(address p0, string memory p1, string memory p2) internal view {
1579 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1580 	}
1581 
1582 	function log(address p0, string memory p1, bool p2) internal view {
1583 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1584 	}
1585 
1586 	function log(address p0, string memory p1, address p2) internal view {
1587 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1588 	}
1589 
1590 	function log(address p0, bool p1, uint p2) internal view {
1591 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1592 	}
1593 
1594 	function log(address p0, bool p1, string memory p2) internal view {
1595 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1596 	}
1597 
1598 	function log(address p0, bool p1, bool p2) internal view {
1599 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1600 	}
1601 
1602 	function log(address p0, bool p1, address p2) internal view {
1603 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1604 	}
1605 
1606 	function log(address p0, address p1, uint p2) internal view {
1607 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1608 	}
1609 
1610 	function log(address p0, address p1, string memory p2) internal view {
1611 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1612 	}
1613 
1614 	function log(address p0, address p1, bool p2) internal view {
1615 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1616 	}
1617 
1618 	function log(address p0, address p1, address p2) internal view {
1619 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1620 	}
1621 
1622 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1623 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1624 	}
1625 
1626 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1627 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1628 	}
1629 
1630 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1631 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1632 	}
1633 
1634 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1635 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1636 	}
1637 
1638 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1639 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1640 	}
1641 
1642 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1643 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1644 	}
1645 
1646 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1647 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1648 	}
1649 
1650 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1651 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1652 	}
1653 
1654 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1655 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1656 	}
1657 
1658 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1659 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1660 	}
1661 
1662 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1663 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1664 	}
1665 
1666 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1667 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1668 	}
1669 
1670 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1671 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1672 	}
1673 
1674 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1675 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1676 	}
1677 
1678 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1679 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1680 	}
1681 
1682 	function log(uint p0, uint p1, address p2, address p3) internal view {
1683 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1684 	}
1685 
1686 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1687 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1688 	}
1689 
1690 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1691 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1692 	}
1693 
1694 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1695 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1696 	}
1697 
1698 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1699 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1700 	}
1701 
1702 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1703 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1704 	}
1705 
1706 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1707 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1708 	}
1709 
1710 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1711 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1712 	}
1713 
1714 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1715 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1716 	}
1717 
1718 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1719 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1720 	}
1721 
1722 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1723 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1724 	}
1725 
1726 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1727 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1728 	}
1729 
1730 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1731 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1732 	}
1733 
1734 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1735 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1736 	}
1737 
1738 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1739 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1740 	}
1741 
1742 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1743 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1744 	}
1745 
1746 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1747 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1748 	}
1749 
1750 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1751 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1752 	}
1753 
1754 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1755 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1756 	}
1757 
1758 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1759 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1760 	}
1761 
1762 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1763 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1764 	}
1765 
1766 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1767 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1768 	}
1769 
1770 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1771 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1772 	}
1773 
1774 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1775 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1776 	}
1777 
1778 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1779 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1780 	}
1781 
1782 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1783 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1784 	}
1785 
1786 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1787 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1788 	}
1789 
1790 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1791 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1792 	}
1793 
1794 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1795 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1796 	}
1797 
1798 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1799 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1800 	}
1801 
1802 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1803 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1804 	}
1805 
1806 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1807 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1808 	}
1809 
1810 	function log(uint p0, bool p1, address p2, address p3) internal view {
1811 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1812 	}
1813 
1814 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1815 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1816 	}
1817 
1818 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1819 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1820 	}
1821 
1822 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1823 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1824 	}
1825 
1826 	function log(uint p0, address p1, uint p2, address p3) internal view {
1827 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1828 	}
1829 
1830 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1831 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1832 	}
1833 
1834 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1835 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1836 	}
1837 
1838 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1839 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1840 	}
1841 
1842 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1843 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1844 	}
1845 
1846 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1847 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1848 	}
1849 
1850 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1851 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1852 	}
1853 
1854 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1855 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1856 	}
1857 
1858 	function log(uint p0, address p1, bool p2, address p3) internal view {
1859 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1860 	}
1861 
1862 	function log(uint p0, address p1, address p2, uint p3) internal view {
1863 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1864 	}
1865 
1866 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1867 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1868 	}
1869 
1870 	function log(uint p0, address p1, address p2, bool p3) internal view {
1871 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1872 	}
1873 
1874 	function log(uint p0, address p1, address p2, address p3) internal view {
1875 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1876 	}
1877 
1878 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1879 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1880 	}
1881 
1882 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1883 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1884 	}
1885 
1886 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1887 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1888 	}
1889 
1890 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1891 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1892 	}
1893 
1894 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1895 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1896 	}
1897 
1898 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1899 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1900 	}
1901 
1902 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1903 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1904 	}
1905 
1906 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1907 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1908 	}
1909 
1910 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1911 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1912 	}
1913 
1914 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1915 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1916 	}
1917 
1918 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1919 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1920 	}
1921 
1922 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1923 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1924 	}
1925 
1926 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1927 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1928 	}
1929 
1930 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1931 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1932 	}
1933 
1934 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1935 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1936 	}
1937 
1938 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1939 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1940 	}
1941 
1942 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1943 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1944 	}
1945 
1946 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1947 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1948 	}
1949 
1950 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1951 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1952 	}
1953 
1954 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1955 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1956 	}
1957 
1958 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1959 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1960 	}
1961 
1962 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1963 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1964 	}
1965 
1966 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1967 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1968 	}
1969 
1970 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1971 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1972 	}
1973 
1974 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1975 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1976 	}
1977 
1978 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1979 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1980 	}
1981 
1982 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1983 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1984 	}
1985 
1986 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1987 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1988 	}
1989 
1990 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1991 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1992 	}
1993 
1994 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1995 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1996 	}
1997 
1998 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1999 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2000 	}
2001 
2002 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2003 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2004 	}
2005 
2006 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2007 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2008 	}
2009 
2010 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2011 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2012 	}
2013 
2014 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2015 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2016 	}
2017 
2018 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2019 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2020 	}
2021 
2022 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2023 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2024 	}
2025 
2026 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2027 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2028 	}
2029 
2030 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2031 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2032 	}
2033 
2034 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2035 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2036 	}
2037 
2038 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2039 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2040 	}
2041 
2042 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2043 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2044 	}
2045 
2046 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2047 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2048 	}
2049 
2050 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2051 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2052 	}
2053 
2054 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2055 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2056 	}
2057 
2058 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2059 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2060 	}
2061 
2062 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2063 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2064 	}
2065 
2066 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2067 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2068 	}
2069 
2070 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2071 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2072 	}
2073 
2074 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2075 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2076 	}
2077 
2078 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2079 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2080 	}
2081 
2082 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2083 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2084 	}
2085 
2086 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2087 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2088 	}
2089 
2090 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2091 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2092 	}
2093 
2094 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2095 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2096 	}
2097 
2098 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2099 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2100 	}
2101 
2102 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2103 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2104 	}
2105 
2106 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2107 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2108 	}
2109 
2110 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2111 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2112 	}
2113 
2114 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2115 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2116 	}
2117 
2118 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2119 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2120 	}
2121 
2122 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2123 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2124 	}
2125 
2126 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2127 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2128 	}
2129 
2130 	function log(string memory p0, address p1, address p2, address p3) internal view {
2131 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2132 	}
2133 
2134 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2135 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2136 	}
2137 
2138 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2139 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2140 	}
2141 
2142 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2143 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2144 	}
2145 
2146 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2147 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2148 	}
2149 
2150 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2151 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2152 	}
2153 
2154 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2155 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2156 	}
2157 
2158 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2159 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2160 	}
2161 
2162 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2163 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2164 	}
2165 
2166 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2167 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2168 	}
2169 
2170 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2171 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2172 	}
2173 
2174 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2175 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2176 	}
2177 
2178 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2179 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2180 	}
2181 
2182 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2183 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2184 	}
2185 
2186 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2187 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2188 	}
2189 
2190 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2191 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2192 	}
2193 
2194 	function log(bool p0, uint p1, address p2, address p3) internal view {
2195 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2196 	}
2197 
2198 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2199 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2200 	}
2201 
2202 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2203 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2204 	}
2205 
2206 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2207 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2208 	}
2209 
2210 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2211 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2212 	}
2213 
2214 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2215 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2216 	}
2217 
2218 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2219 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2220 	}
2221 
2222 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2223 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2224 	}
2225 
2226 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2227 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2228 	}
2229 
2230 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2231 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2232 	}
2233 
2234 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2235 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2236 	}
2237 
2238 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2239 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2240 	}
2241 
2242 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2243 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2244 	}
2245 
2246 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2247 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2248 	}
2249 
2250 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2251 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2252 	}
2253 
2254 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2255 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2256 	}
2257 
2258 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2259 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2260 	}
2261 
2262 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2263 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2264 	}
2265 
2266 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2267 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2268 	}
2269 
2270 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2271 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2272 	}
2273 
2274 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2275 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2276 	}
2277 
2278 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2279 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2280 	}
2281 
2282 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2283 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2284 	}
2285 
2286 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2287 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2288 	}
2289 
2290 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2291 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2292 	}
2293 
2294 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2295 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2296 	}
2297 
2298 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2299 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2300 	}
2301 
2302 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2303 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2304 	}
2305 
2306 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2307 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2308 	}
2309 
2310 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2311 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2312 	}
2313 
2314 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2315 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2316 	}
2317 
2318 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2319 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2320 	}
2321 
2322 	function log(bool p0, bool p1, address p2, address p3) internal view {
2323 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2324 	}
2325 
2326 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2327 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2328 	}
2329 
2330 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2331 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2332 	}
2333 
2334 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2335 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2336 	}
2337 
2338 	function log(bool p0, address p1, uint p2, address p3) internal view {
2339 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2340 	}
2341 
2342 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2343 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2344 	}
2345 
2346 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2347 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2348 	}
2349 
2350 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2351 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2352 	}
2353 
2354 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2355 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2356 	}
2357 
2358 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2359 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2360 	}
2361 
2362 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2363 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2364 	}
2365 
2366 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2367 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2368 	}
2369 
2370 	function log(bool p0, address p1, bool p2, address p3) internal view {
2371 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2372 	}
2373 
2374 	function log(bool p0, address p1, address p2, uint p3) internal view {
2375 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2376 	}
2377 
2378 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2379 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2380 	}
2381 
2382 	function log(bool p0, address p1, address p2, bool p3) internal view {
2383 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2384 	}
2385 
2386 	function log(bool p0, address p1, address p2, address p3) internal view {
2387 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2388 	}
2389 
2390 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2391 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2392 	}
2393 
2394 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2395 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2396 	}
2397 
2398 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2399 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2400 	}
2401 
2402 	function log(address p0, uint p1, uint p2, address p3) internal view {
2403 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2404 	}
2405 
2406 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2407 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2408 	}
2409 
2410 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2411 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2412 	}
2413 
2414 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2415 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2416 	}
2417 
2418 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2419 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2420 	}
2421 
2422 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2423 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2424 	}
2425 
2426 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2427 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2428 	}
2429 
2430 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2431 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2432 	}
2433 
2434 	function log(address p0, uint p1, bool p2, address p3) internal view {
2435 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2436 	}
2437 
2438 	function log(address p0, uint p1, address p2, uint p3) internal view {
2439 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2440 	}
2441 
2442 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2443 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2444 	}
2445 
2446 	function log(address p0, uint p1, address p2, bool p3) internal view {
2447 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2448 	}
2449 
2450 	function log(address p0, uint p1, address p2, address p3) internal view {
2451 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2452 	}
2453 
2454 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2455 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2456 	}
2457 
2458 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2459 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2460 	}
2461 
2462 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2463 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2464 	}
2465 
2466 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2467 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2468 	}
2469 
2470 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2471 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2472 	}
2473 
2474 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2475 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2476 	}
2477 
2478 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2479 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2480 	}
2481 
2482 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2483 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2484 	}
2485 
2486 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2487 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2488 	}
2489 
2490 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2491 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2492 	}
2493 
2494 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2495 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2496 	}
2497 
2498 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2499 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2500 	}
2501 
2502 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2503 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2504 	}
2505 
2506 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2507 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2508 	}
2509 
2510 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2511 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2512 	}
2513 
2514 	function log(address p0, string memory p1, address p2, address p3) internal view {
2515 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2516 	}
2517 
2518 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2519 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2520 	}
2521 
2522 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2523 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2524 	}
2525 
2526 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2527 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2528 	}
2529 
2530 	function log(address p0, bool p1, uint p2, address p3) internal view {
2531 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2532 	}
2533 
2534 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2535 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2536 	}
2537 
2538 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2539 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2540 	}
2541 
2542 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2543 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2544 	}
2545 
2546 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2547 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2548 	}
2549 
2550 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2551 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2552 	}
2553 
2554 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2555 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2556 	}
2557 
2558 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2559 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2560 	}
2561 
2562 	function log(address p0, bool p1, bool p2, address p3) internal view {
2563 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2564 	}
2565 
2566 	function log(address p0, bool p1, address p2, uint p3) internal view {
2567 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2568 	}
2569 
2570 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2571 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2572 	}
2573 
2574 	function log(address p0, bool p1, address p2, bool p3) internal view {
2575 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2576 	}
2577 
2578 	function log(address p0, bool p1, address p2, address p3) internal view {
2579 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2580 	}
2581 
2582 	function log(address p0, address p1, uint p2, uint p3) internal view {
2583 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2584 	}
2585 
2586 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2587 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2588 	}
2589 
2590 	function log(address p0, address p1, uint p2, bool p3) internal view {
2591 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2592 	}
2593 
2594 	function log(address p0, address p1, uint p2, address p3) internal view {
2595 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2596 	}
2597 
2598 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2599 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2600 	}
2601 
2602 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2603 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2604 	}
2605 
2606 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2607 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2608 	}
2609 
2610 	function log(address p0, address p1, string memory p2, address p3) internal view {
2611 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2612 	}
2613 
2614 	function log(address p0, address p1, bool p2, uint p3) internal view {
2615 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2616 	}
2617 
2618 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2619 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2620 	}
2621 
2622 	function log(address p0, address p1, bool p2, bool p3) internal view {
2623 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2624 	}
2625 
2626 	function log(address p0, address p1, bool p2, address p3) internal view {
2627 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2628 	}
2629 
2630 	function log(address p0, address p1, address p2, uint p3) internal view {
2631 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2632 	}
2633 
2634 	function log(address p0, address p1, address p2, string memory p3) internal view {
2635 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2636 	}
2637 
2638 	function log(address p0, address p1, address p2, bool p3) internal view {
2639 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2640 	}
2641 
2642 	function log(address p0, address p1, address p2, address p3) internal view {
2643 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2644 	}
2645 
2646 }
2647 
2648 // File: @openzeppelin/contracts/utils/Context.sol
2649 
2650 
2651 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2652 
2653 pragma solidity ^0.8.0;
2654 
2655 /**
2656  * @dev Provides information about the current execution context, including the
2657  * sender of the transaction and its data. While these are generally available
2658  * via msg.sender and msg.data, they should not be accessed in such a direct
2659  * manner, since when dealing with meta-transactions the account sending and
2660  * paying for execution may not be the actual sender (as far as an application
2661  * is concerned).
2662  *
2663  * This contract is only required for intermediate, library-like contracts.
2664  */
2665 abstract contract Context {
2666     function _msgSender() internal view virtual returns (address) {
2667         return msg.sender;
2668     }
2669 
2670     function _msgData() internal view virtual returns (bytes calldata) {
2671         return msg.data;
2672     }
2673 }
2674 
2675 // File: erc721a/contracts/ERC721A.sol
2676 
2677 
2678 // Creator: Chiru Labs
2679 
2680 pragma solidity ^0.8.4;
2681 
2682 
2683 
2684 
2685 
2686 
2687 
2688 
2689 
2690 error ApprovalCallerNotOwnerNorApproved();
2691 error ApprovalQueryForNonexistentToken();
2692 error ApproveToCaller();
2693 error ApprovalToCurrentOwner();
2694 error BalanceQueryForZeroAddress();
2695 error MintedQueryForZeroAddress();
2696 error BurnedQueryForZeroAddress();
2697 error MintToZeroAddress();
2698 error MintZeroQuantity();
2699 error OwnerIndexOutOfBounds();
2700 error OwnerQueryForNonexistentToken();
2701 error TokenIndexOutOfBounds();
2702 error TransferCallerNotOwnerNorApproved();
2703 error TransferFromIncorrectOwner();
2704 error TransferToNonERC721ReceiverImplementer();
2705 error TransferToZeroAddress();
2706 error URIQueryForNonexistentToken();
2707 
2708 /**
2709  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2710  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
2711  *
2712  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
2713  *
2714  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2715  *
2716  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
2717  */
2718 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
2719     using Address for address;
2720     using Strings for uint256;
2721 
2722     // Compiler will pack this into a single 256bit word.
2723     struct TokenOwnership {
2724         // The address of the owner.
2725         address addr;
2726         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2727         uint64 startTimestamp;
2728         // Whether the token has been burned.
2729         bool burned;
2730     }
2731 
2732     // Compiler will pack this into a single 256bit word.
2733     struct AddressData {
2734         // Realistically, 2**64-1 is more than enough.
2735         uint64 balance;
2736         // Keeps track of mint count with minimal overhead for tokenomics.
2737         uint64 numberMinted;
2738         // Keeps track of burn count with minimal overhead for tokenomics.
2739         uint64 numberBurned;
2740     }
2741 
2742     // Compiler will pack the following 
2743     // _currentIndex and _burnCounter into a single 256bit word.
2744     
2745     // The tokenId of the next token to be minted.
2746     uint128 internal _currentIndex;
2747 
2748     // The number of tokens burned.
2749     uint128 internal _burnCounter;
2750 
2751     // Token name
2752     string private _name;
2753 
2754     // Token symbol
2755     string private _symbol;
2756 
2757     // Mapping from token ID to ownership details
2758     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
2759     mapping(uint256 => TokenOwnership) internal _ownerships;
2760 
2761     // Mapping owner address to address data
2762     mapping(address => AddressData) private _addressData;
2763 
2764     // Mapping from token ID to approved address
2765     mapping(uint256 => address) private _tokenApprovals;
2766 
2767     // Mapping from owner to operator approvals
2768     mapping(address => mapping(address => bool)) private _operatorApprovals;
2769 
2770     constructor(string memory name_, string memory symbol_) {
2771         _name = name_;
2772         _symbol = symbol_;
2773     }
2774 
2775     /**
2776      * @dev See {IERC721Enumerable-totalSupply}.
2777      */
2778     function totalSupply() public view override returns (uint256) {
2779         // Counter underflow is impossible as _burnCounter cannot be incremented
2780         // more than _currentIndex times
2781         unchecked {
2782             return _currentIndex - _burnCounter;    
2783         }
2784     }
2785 
2786     /**
2787      * @dev See {IERC721Enumerable-tokenByIndex}.
2788      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
2789      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
2790      */
2791     function tokenByIndex(uint256 index) public view override returns (uint256) {
2792         uint256 numMintedSoFar = _currentIndex;
2793         uint256 tokenIdsIdx;
2794 
2795         // Counter overflow is impossible as the loop breaks when
2796         // uint256 i is equal to another uint256 numMintedSoFar.
2797         unchecked {
2798             for (uint256 i; i < numMintedSoFar; i++) {
2799                 TokenOwnership memory ownership = _ownerships[i];
2800                 if (!ownership.burned) {
2801                     if (tokenIdsIdx == index) {
2802                         return i;
2803                     }
2804                     tokenIdsIdx++;
2805                 }
2806             }
2807         }
2808         revert TokenIndexOutOfBounds();
2809     }
2810 
2811     /**
2812      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2813      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
2814      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
2815      */
2816     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
2817         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
2818         uint256 numMintedSoFar = _currentIndex;
2819         uint256 tokenIdsIdx;
2820         address currOwnershipAddr;
2821 
2822         // Counter overflow is impossible as the loop breaks when
2823         // uint256 i is equal to another uint256 numMintedSoFar.
2824         unchecked {
2825             for (uint256 i; i < numMintedSoFar; i++) {
2826                 TokenOwnership memory ownership = _ownerships[i];
2827                 if (ownership.burned) {
2828                     continue;
2829                 }
2830                 if (ownership.addr != address(0)) {
2831                     currOwnershipAddr = ownership.addr;
2832                 }
2833                 if (currOwnershipAddr == owner) {
2834                     if (tokenIdsIdx == index) {
2835                         return i;
2836                     }
2837                     tokenIdsIdx++;
2838                 }
2839             }
2840         }
2841 
2842         // Execution should never reach this point.
2843         revert();
2844     }
2845 
2846     /**
2847      * @dev See {IERC165-supportsInterface}.
2848      */
2849     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2850         return
2851             interfaceId == type(IERC721).interfaceId ||
2852             interfaceId == type(IERC721Metadata).interfaceId ||
2853             interfaceId == type(IERC721Enumerable).interfaceId ||
2854             super.supportsInterface(interfaceId);
2855     }
2856 
2857     /**
2858      * @dev See {IERC721-balanceOf}.
2859      */
2860     function balanceOf(address owner) public view override returns (uint256) {
2861         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2862         return uint256(_addressData[owner].balance);
2863     }
2864 
2865     function _numberMinted(address owner) internal view returns (uint256) {
2866         if (owner == address(0)) revert MintedQueryForZeroAddress();
2867         return uint256(_addressData[owner].numberMinted);
2868     }
2869 
2870     function _numberBurned(address owner) internal view returns (uint256) {
2871         if (owner == address(0)) revert BurnedQueryForZeroAddress();
2872         return uint256(_addressData[owner].numberBurned);
2873     }
2874 
2875     /**
2876      * Gas spent here starts off proportional to the maximum mint batch size.
2877      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2878      */
2879     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2880         uint256 curr = tokenId;
2881 
2882         unchecked {
2883             if (curr < _currentIndex) {
2884                 TokenOwnership memory ownership = _ownerships[curr];
2885                 if (!ownership.burned) {
2886                     if (ownership.addr != address(0)) {
2887                         return ownership;
2888                     }
2889                     // Invariant: 
2890                     // There will always be an ownership that has an address and is not burned 
2891                     // before an ownership that does not have an address and is not burned.
2892                     // Hence, curr will not underflow.
2893                     while (true) {
2894                         curr--;
2895                         ownership = _ownerships[curr];
2896                         if (ownership.addr != address(0)) {
2897                             return ownership;
2898                         }
2899                     }
2900                 }
2901             }
2902         }
2903         revert OwnerQueryForNonexistentToken();
2904     }
2905 
2906     /**
2907      * @dev See {IERC721-ownerOf}.
2908      */
2909     function ownerOf(uint256 tokenId) public view override returns (address) {
2910         return ownershipOf(tokenId).addr;
2911     }
2912 
2913     /**
2914      * @dev See {IERC721Metadata-name}.
2915      */
2916     function name() public view virtual override returns (string memory) {
2917         return _name;
2918     }
2919 
2920     /**
2921      * @dev See {IERC721Metadata-symbol}.
2922      */
2923     function symbol() public view virtual override returns (string memory) {
2924         return _symbol;
2925     }
2926 
2927     /**
2928      * @dev See {IERC721Metadata-tokenURI}.
2929      */
2930     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2931         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2932 
2933         string memory baseURI = _baseURI();
2934         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2935     }
2936 
2937     /**
2938      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2939      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2940      * by default, can be overriden in child contracts.
2941      */
2942     function _baseURI() internal view virtual returns (string memory) {
2943         return '';
2944     }
2945 
2946     /**
2947      * @dev See {IERC721-approve}.
2948      */
2949     function approve(address to, uint256 tokenId) public override {
2950         address owner = ERC721A.ownerOf(tokenId);
2951         if (to == owner) revert ApprovalToCurrentOwner();
2952 
2953         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2954             revert ApprovalCallerNotOwnerNorApproved();
2955         }
2956 
2957         _approve(to, tokenId, owner);
2958     }
2959 
2960     /**
2961      * @dev See {IERC721-getApproved}.
2962      */
2963     function getApproved(uint256 tokenId) public view override returns (address) {
2964         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2965 
2966         return _tokenApprovals[tokenId];
2967     }
2968 
2969     /**
2970      * @dev See {IERC721-setApprovalForAll}.
2971      */
2972     function setApprovalForAll(address operator, bool approved) public override {
2973         if (operator == _msgSender()) revert ApproveToCaller();
2974 
2975         _operatorApprovals[_msgSender()][operator] = approved;
2976         emit ApprovalForAll(_msgSender(), operator, approved);
2977     }
2978 
2979     /**
2980      * @dev See {IERC721-isApprovedForAll}.
2981      */
2982     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2983         return _operatorApprovals[owner][operator];
2984     }
2985 
2986     /**
2987      * @dev See {IERC721-transferFrom}.
2988      */
2989     function transferFrom(
2990         address from,
2991         address to,
2992         uint256 tokenId
2993     ) public virtual override {
2994         _transfer(from, to, tokenId);
2995     }
2996 
2997     /**
2998      * @dev See {IERC721-safeTransferFrom}.
2999      */
3000     function safeTransferFrom(
3001         address from,
3002         address to,
3003         uint256 tokenId
3004     ) public virtual override {
3005         safeTransferFrom(from, to, tokenId, '');
3006     }
3007 
3008     /**
3009      * @dev See {IERC721-safeTransferFrom}.
3010      */
3011     function safeTransferFrom(
3012         address from,
3013         address to,
3014         uint256 tokenId,
3015         bytes memory _data
3016     ) public virtual override {
3017         _transfer(from, to, tokenId);
3018         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
3019             revert TransferToNonERC721ReceiverImplementer();
3020         }
3021     }
3022 
3023     /**
3024      * @dev Returns whether `tokenId` exists.
3025      *
3026      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3027      *
3028      * Tokens start existing when they are minted (`_mint`),
3029      */
3030     function _exists(uint256 tokenId) internal view returns (bool) {
3031         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
3032     }
3033 
3034     function _safeMint(address to, uint256 quantity) internal {
3035         _safeMint(to, quantity, '');
3036     }
3037 
3038     /**
3039      * @dev Safely mints `quantity` tokens and transfers them to `to`.
3040      *
3041      * Requirements:
3042      *
3043      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
3044      * - `quantity` must be greater than 0.
3045      *
3046      * Emits a {Transfer} event.
3047      */
3048     function _safeMint(
3049         address to,
3050         uint256 quantity,
3051         bytes memory _data
3052     ) internal {
3053         _mint(to, quantity, _data, true);
3054     }
3055 
3056     /**
3057      * @dev Mints `quantity` tokens and transfers them to `to`.
3058      *
3059      * Requirements:
3060      *
3061      * - `to` cannot be the zero address.
3062      * - `quantity` must be greater than 0.
3063      *
3064      * Emits a {Transfer} event.
3065      */
3066     function _mint(
3067         address to,
3068         uint256 quantity,
3069         bytes memory _data,
3070         bool safe
3071     ) internal {
3072         uint256 startTokenId = _currentIndex;
3073         if (to == address(0)) revert MintToZeroAddress();
3074         if (quantity == 0) revert MintZeroQuantity();
3075 
3076         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
3077 
3078         // Overflows are incredibly unrealistic.
3079         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
3080         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
3081         unchecked {
3082             _addressData[to].balance += uint64(quantity);
3083             _addressData[to].numberMinted += uint64(quantity);
3084 
3085             _ownerships[startTokenId].addr = to;
3086             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
3087 
3088             uint256 updatedIndex = startTokenId;
3089 
3090             for (uint256 i; i < quantity; i++) {
3091                 emit Transfer(address(0), to, updatedIndex);
3092                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
3093                     revert TransferToNonERC721ReceiverImplementer();
3094                 }
3095                 updatedIndex++;
3096             }
3097 
3098             _currentIndex = uint128(updatedIndex);
3099         }
3100         _afterTokenTransfers(address(0), to, startTokenId, quantity);
3101     }
3102 
3103     /**
3104      * @dev Transfers `tokenId` from `from` to `to`.
3105      *
3106      * Requirements:
3107      *
3108      * - `to` cannot be the zero address.
3109      * - `tokenId` token must be owned by `from`.
3110      *
3111      * Emits a {Transfer} event.
3112      */
3113     function _transfer(
3114         address from,
3115         address to,
3116         uint256 tokenId
3117     ) private {
3118         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
3119 
3120         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
3121             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
3122             getApproved(tokenId) == _msgSender());
3123 
3124         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
3125         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
3126         if (to == address(0)) revert TransferToZeroAddress();
3127 
3128         _beforeTokenTransfers(from, to, tokenId, 1);
3129 
3130         // Clear approvals from the previous owner
3131         _approve(address(0), tokenId, prevOwnership.addr);
3132 
3133         // Underflow of the sender's balance is impossible because we check for
3134         // ownership above and the recipient's balance can't realistically overflow.
3135         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
3136         unchecked {
3137             _addressData[from].balance -= 1;
3138             _addressData[to].balance += 1;
3139 
3140             _ownerships[tokenId].addr = to;
3141             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
3142 
3143             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
3144             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
3145             uint256 nextTokenId = tokenId + 1;
3146             if (_ownerships[nextTokenId].addr == address(0)) {
3147                 // This will suffice for checking _exists(nextTokenId),
3148                 // as a burned slot cannot contain the zero address.
3149                 if (nextTokenId < _currentIndex) {
3150                     _ownerships[nextTokenId].addr = prevOwnership.addr;
3151                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
3152                 }
3153             }
3154         }
3155 
3156         emit Transfer(from, to, tokenId);
3157         _afterTokenTransfers(from, to, tokenId, 1);
3158     }
3159 
3160     /**
3161      * @dev Destroys `tokenId`.
3162      * The approval is cleared when the token is burned.
3163      *
3164      * Requirements:
3165      *
3166      * - `tokenId` must exist.
3167      *
3168      * Emits a {Transfer} event.
3169      */
3170     function _burn(uint256 tokenId) internal virtual {
3171         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
3172 
3173         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
3174 
3175         // Clear approvals from the previous owner
3176         _approve(address(0), tokenId, prevOwnership.addr);
3177 
3178         // Underflow of the sender's balance is impossible because we check for
3179         // ownership above and the recipient's balance can't realistically overflow.
3180         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
3181         unchecked {
3182             _addressData[prevOwnership.addr].balance -= 1;
3183             _addressData[prevOwnership.addr].numberBurned += 1;
3184 
3185             // Keep track of who burned the token, and the timestamp of burning.
3186             _ownerships[tokenId].addr = prevOwnership.addr;
3187             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
3188             _ownerships[tokenId].burned = true;
3189 
3190             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
3191             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
3192             uint256 nextTokenId = tokenId + 1;
3193             if (_ownerships[nextTokenId].addr == address(0)) {
3194                 // This will suffice for checking _exists(nextTokenId),
3195                 // as a burned slot cannot contain the zero address.
3196                 if (nextTokenId < _currentIndex) {
3197                     _ownerships[nextTokenId].addr = prevOwnership.addr;
3198                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
3199                 }
3200             }
3201         }
3202 
3203         emit Transfer(prevOwnership.addr, address(0), tokenId);
3204         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
3205 
3206         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
3207         unchecked { 
3208             _burnCounter++;
3209         }
3210     }
3211 
3212     /**
3213      * @dev Approve `to` to operate on `tokenId`
3214      *
3215      * Emits a {Approval} event.
3216      */
3217     function _approve(
3218         address to,
3219         uint256 tokenId,
3220         address owner
3221     ) private {
3222         _tokenApprovals[tokenId] = to;
3223         emit Approval(owner, to, tokenId);
3224     }
3225 
3226     /**
3227      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3228      * The call is not executed if the target address is not a contract.
3229      *
3230      * @param from address representing the previous owner of the given token ID
3231      * @param to target address that will receive the tokens
3232      * @param tokenId uint256 ID of the token to be transferred
3233      * @param _data bytes optional data to send along with the call
3234      * @return bool whether the call correctly returned the expected magic value
3235      */
3236     function _checkOnERC721Received(
3237         address from,
3238         address to,
3239         uint256 tokenId,
3240         bytes memory _data
3241     ) private returns (bool) {
3242         if (to.isContract()) {
3243             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
3244                 return retval == IERC721Receiver(to).onERC721Received.selector;
3245             } catch (bytes memory reason) {
3246                 if (reason.length == 0) {
3247                     revert TransferToNonERC721ReceiverImplementer();
3248                 } else {
3249                     assembly {
3250                         revert(add(32, reason), mload(reason))
3251                     }
3252                 }
3253             }
3254         } else {
3255             return true;
3256         }
3257     }
3258 
3259     /**
3260      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
3261      * And also called before burning one token.
3262      *
3263      * startTokenId - the first token id to be transferred
3264      * quantity - the amount to be transferred
3265      *
3266      * Calling conditions:
3267      *
3268      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3269      * transferred to `to`.
3270      * - When `from` is zero, `tokenId` will be minted for `to`.
3271      * - When `to` is zero, `tokenId` will be burned by `from`.
3272      * - `from` and `to` are never both zero.
3273      */
3274     function _beforeTokenTransfers(
3275         address from,
3276         address to,
3277         uint256 startTokenId,
3278         uint256 quantity
3279     ) internal virtual {}
3280 
3281     /**
3282      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3283      * minting.
3284      * And also called after one token has been burned.
3285      *
3286      * startTokenId - the first token id to be transferred
3287      * quantity - the amount to be transferred
3288      *
3289      * Calling conditions:
3290      *
3291      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
3292      * transferred to `to`.
3293      * - When `from` is zero, `tokenId` has been minted for `to`.
3294      * - When `to` is zero, `tokenId` has been burned by `from`.
3295      * - `from` and `to` are never both zero.
3296      */
3297     function _afterTokenTransfers(
3298         address from,
3299         address to,
3300         uint256 startTokenId,
3301         uint256 quantity
3302     ) internal virtual {}
3303 }
3304 
3305 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
3306 
3307 
3308 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
3309 
3310 pragma solidity ^0.8.0;
3311 
3312 
3313 
3314 
3315 /**
3316  * @title PaymentSplitter
3317  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
3318  * that the Ether will be split in this way, since it is handled transparently by the contract.
3319  *
3320  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
3321  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
3322  * an amount proportional to the percentage of total shares they were assigned.
3323  *
3324  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
3325  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
3326  * function.
3327  *
3328  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
3329  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
3330  * to run tests before sending real value to this contract.
3331  */
3332 contract PaymentSplitter is Context {
3333     event PayeeAdded(address account, uint256 shares);
3334     event PaymentReleased(address to, uint256 amount);
3335     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
3336     event PaymentReceived(address from, uint256 amount);
3337 
3338     uint256 private _totalShares;
3339     uint256 private _totalReleased;
3340 
3341     mapping(address => uint256) private _shares;
3342     mapping(address => uint256) private _released;
3343     address[] private _payees;
3344 
3345     mapping(IERC20 => uint256) private _erc20TotalReleased;
3346     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
3347 
3348     /**
3349      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
3350      * the matching position in the `shares` array.
3351      *
3352      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
3353      * duplicates in `payees`.
3354      */
3355     constructor(address[] memory payees, uint256[] memory shares_) payable {
3356         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
3357         require(payees.length > 0, "PaymentSplitter: no payees");
3358 
3359         for (uint256 i = 0; i < payees.length; i++) {
3360             _addPayee(payees[i], shares_[i]);
3361         }
3362     }
3363 
3364     /**
3365      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
3366      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
3367      * reliability of the events, and not the actual splitting of Ether.
3368      *
3369      * To learn more about this see the Solidity documentation for
3370      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
3371      * functions].
3372      */
3373     receive() external payable virtual {
3374         emit PaymentReceived(_msgSender(), msg.value);
3375     }
3376 
3377     /**
3378      * @dev Getter for the total shares held by payees.
3379      */
3380     function totalShares() public view returns (uint256) {
3381         return _totalShares;
3382     }
3383 
3384     /**
3385      * @dev Getter for the total amount of Ether already released.
3386      */
3387     function totalReleased() public view returns (uint256) {
3388         return _totalReleased;
3389     }
3390 
3391     /**
3392      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
3393      * contract.
3394      */
3395     function totalReleased(IERC20 token) public view returns (uint256) {
3396         return _erc20TotalReleased[token];
3397     }
3398 
3399     /**
3400      * @dev Getter for the amount of shares held by an account.
3401      */
3402     function shares(address account) public view returns (uint256) {
3403         return _shares[account];
3404     }
3405 
3406     /**
3407      * @dev Getter for the amount of Ether already released to a payee.
3408      */
3409     function released(address account) public view returns (uint256) {
3410         return _released[account];
3411     }
3412 
3413     /**
3414      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
3415      * IERC20 contract.
3416      */
3417     function released(IERC20 token, address account) public view returns (uint256) {
3418         return _erc20Released[token][account];
3419     }
3420 
3421     /**
3422      * @dev Getter for the address of the payee number `index`.
3423      */
3424     function payee(uint256 index) public view returns (address) {
3425         return _payees[index];
3426     }
3427 
3428     /**
3429      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
3430      * total shares and their previous withdrawals.
3431      */
3432     function release(address payable account) public virtual {
3433         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3434 
3435         uint256 totalReceived = address(this).balance + totalReleased();
3436         uint256 payment = _pendingPayment(account, totalReceived, released(account));
3437 
3438         require(payment != 0, "PaymentSplitter: account is not due payment");
3439 
3440         _released[account] += payment;
3441         _totalReleased += payment;
3442 
3443         Address.sendValue(account, payment);
3444         emit PaymentReleased(account, payment);
3445     }
3446 
3447     /**
3448      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
3449      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
3450      * contract.
3451      */
3452     function release(IERC20 token, address account) public virtual {
3453         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3454 
3455         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
3456         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
3457 
3458         require(payment != 0, "PaymentSplitter: account is not due payment");
3459 
3460         _erc20Released[token][account] += payment;
3461         _erc20TotalReleased[token] += payment;
3462 
3463         SafeERC20.safeTransfer(token, account, payment);
3464         emit ERC20PaymentReleased(token, account, payment);
3465     }
3466 
3467     /**
3468      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
3469      * already released amounts.
3470      */
3471     function _pendingPayment(
3472         address account,
3473         uint256 totalReceived,
3474         uint256 alreadyReleased
3475     ) private view returns (uint256) {
3476         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
3477     }
3478 
3479     /**
3480      * @dev Add a new payee to the contract.
3481      * @param account The address of the payee to add.
3482      * @param shares_ The number of shares owned by the payee.
3483      */
3484     function _addPayee(address account, uint256 shares_) private {
3485         require(account != address(0), "PaymentSplitter: account is the zero address");
3486         require(shares_ > 0, "PaymentSplitter: shares are 0");
3487         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
3488 
3489         _payees.push(account);
3490         _shares[account] = shares_;
3491         _totalShares = _totalShares + shares_;
3492         emit PayeeAdded(account, shares_);
3493     }
3494 }
3495 
3496 // File: @openzeppelin/contracts/access/Ownable.sol
3497 
3498 
3499 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
3500 
3501 pragma solidity ^0.8.0;
3502 
3503 
3504 /**
3505  * @dev Contract module which provides a basic access control mechanism, where
3506  * there is an account (an owner) that can be granted exclusive access to
3507  * specific functions.
3508  *
3509  * By default, the owner account will be the one that deploys the contract. This
3510  * can later be changed with {transferOwnership}.
3511  *
3512  * This module is used through inheritance. It will make available the modifier
3513  * `onlyOwner`, which can be applied to your functions to restrict their use to
3514  * the owner.
3515  */
3516 abstract contract Ownable is Context {
3517     address private _owner;
3518 
3519     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3520 
3521     /**
3522      * @dev Initializes the contract setting the deployer as the initial owner.
3523      */
3524     constructor() {
3525         _transferOwnership(_msgSender());
3526     }
3527 
3528     /**
3529      * @dev Returns the address of the current owner.
3530      */
3531     function owner() public view virtual returns (address) {
3532         return _owner;
3533     }
3534 
3535     /**
3536      * @dev Throws if called by any account other than the owner.
3537      */
3538     modifier onlyOwner() {
3539         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3540         _;
3541     }
3542 
3543     /**
3544      * @dev Leaves the contract without owner. It will not be possible to call
3545      * `onlyOwner` functions anymore. Can only be called by the current owner.
3546      *
3547      * NOTE: Renouncing ownership will leave the contract without an owner,
3548      * thereby removing any functionality that is only available to the owner.
3549      */
3550     function renounceOwnership() public virtual onlyOwner {
3551         _transferOwnership(address(0));
3552     }
3553 
3554     /**
3555      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3556      * Can only be called by the current owner.
3557      */
3558     function transferOwnership(address newOwner) public virtual onlyOwner {
3559         require(newOwner != address(0), "Ownable: new owner is the zero address");
3560         _transferOwnership(newOwner);
3561     }
3562 
3563     /**
3564      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3565      * Internal function without access restriction.
3566      */
3567     function _transferOwnership(address newOwner) internal virtual {
3568         address oldOwner = _owner;
3569         _owner = newOwner;
3570         emit OwnershipTransferred(oldOwner, newOwner);
3571     }
3572 }
3573 
3574 // File: contracts/WhiteList.sol
3575 
3576 pragma solidity ^0.8.0;
3577 
3578 
3579 
3580 
3581 
3582 contract WhiteList is Ownable, EIP712 {
3583 
3584     bytes32 constant public MINT_CALL_HASH_TYPE = keccak256("mint(address receiver)");
3585 
3586     address public whitelistSigner;
3587 
3588     constructor() EIP712("TsukiWhiteList", "1") {}
3589 
3590     function setWhitelistSigner(address _address) external onlyOwner {
3591         whitelistSigner = _address;
3592     }
3593 
3594     function recoverSigner(address sender, bytes memory signature) public view returns (address) {
3595         return ECDSA.recover(getDigest(sender), signature);
3596     }
3597 
3598     function getDigest(address sender) public view returns (bytes32) {
3599        bytes32 messageDigest = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",
3600            ECDSA.toTypedDataHash(_domainSeparatorV4(),
3601                keccak256(abi.encode(MINT_CALL_HASH_TYPE, sender))
3602        )));
3603        return messageDigest;
3604    }
3605 
3606     modifier isUserWhileList(address sender, bytes memory signature) {
3607         require(recoverSigner(sender, signature) == whitelistSigner
3608             ,
3609             "User is not on whitelist"
3610         );
3611         _;
3612     }
3613 
3614     function getDomainSeparatorV4()  external view onlyOwner  returns (bytes32) {
3615         return _domainSeparatorV4();
3616     }
3617 }
3618 // File: contracts/PreSales.sol
3619 
3620 pragma solidity ^0.8.0;
3621 
3622 
3623 contract PreSales is Ownable {
3624     uint256 public preSalesStartTime;
3625     uint256 public preSalesEndTime;
3626 
3627     modifier isPreSalesActive() {
3628         require(
3629             isPreSalesActivated(),
3630             "PreSalesActivation: Sale is not activated"
3631         );
3632         _;
3633     }
3634 
3635     constructor() {
3636         //20 Feb 2022 09:00:00 EST == 20 Feb 2022 11:00:00 GMT at this site https://www.epochconverter.com/
3637         preSalesStartTime = 1645365600;
3638         //20 Feb 2022 20:59:59 EST == 20 Feb 2022 22:59:59 GMT at this site https://www.epochconverter.com/
3639         preSalesEndTime = 1645408799;
3640     }
3641 
3642     function isPreSalesActivated() public view returns (bool) {
3643         return
3644             preSalesStartTime > 0 &&
3645             preSalesEndTime > 0 &&
3646             block.timestamp >= preSalesStartTime &&
3647             block.timestamp <= preSalesEndTime;
3648     }
3649 
3650     // 1645365600: start time at 20 Feb 2022 09:00:00 EST in seconds
3651     // 1645408799: end time at 20 Feb 2022 20:59:59 EST in seconds
3652     function setPreSalesTime(uint256 _startTime, uint256 _endTime)
3653         external
3654         onlyOwner
3655     {
3656         require(
3657             _endTime >= _startTime,
3658             "PreSalesActivation: End time should be later than start time"
3659         );
3660         preSalesStartTime = _startTime;
3661         preSalesEndTime = _endTime;
3662     }
3663 }
3664 // File: contracts/PublicSales.sol
3665 
3666 pragma solidity ^0.8.0;
3667 
3668 
3669 contract PublicSales is Ownable {
3670     uint256 public publicSalesStartTime;
3671 
3672     modifier isPublicSalesActive() {
3673         require(
3674             isPublicSalesActivated(),
3675             "PublicSalesActivation: Sale is not activated"
3676         );
3677         _;
3678     }
3679 
3680     constructor() {
3681         //20 Feb 2022 23:00:00 GMT == 20 Feb 2022 21:00:00 GMT at this site https://www.epochconverter.com/
3682         publicSalesStartTime = 1645408800;
3683     }
3684 
3685     function isPublicSalesActivated() public view returns (bool) {
3686         return
3687             publicSalesStartTime > 0 && block.timestamp >= publicSalesStartTime;
3688     }
3689 
3690     // 1644069600: start time at 05 Feb 2022 (2 PM UTC+0) in seconds
3691     function setPublicSalesTime(uint256 _startTime) external onlyOwner {
3692         publicSalesStartTime = _startTime;
3693     }
3694 }
3695 // File: contracts/Tsuki.sol
3696 
3697 //SPDX-License-Identifier: MIT
3698 pragma solidity ^0.8.0;
3699 
3700 
3701 
3702 
3703 
3704 
3705 
3706 
3707 contract Tsuki is Ownable, PublicSales, PreSales, WhiteList, ERC721A, PaymentSplitter{
3708 
3709 //FOR PRODUCTION
3710     uint256 public constant TOTAL_MAX_QTY = 10000;
3711     uint256 public constant GIFT_MAX_QTY = 50;
3712     uint256 public constant SALES_MAX_QTY = TOTAL_MAX_QTY - GIFT_MAX_QTY;
3713     uint256 public constant PRESALES_MAX_QTY = 9000;
3714     uint256 public constant PRE_SALES_PRICE = 0.1 ether;
3715     uint256 public constant PUBLIC_SALES_PRICE = 0.15 ether;
3716     uint256 public constant MAX_QTY_PER_MINTER = 4;
3717     uint256 public constant MAX_QTY_PER_MINT = 2;
3718     uint256 public constant MAX_QTY_PER_MINTER_PRE_SALES = 2;
3719 
3720     address[] private addressList = [
3721 	0x30be53552A0d71c8AF783F453a92876E0A516a3a, //V1
3722 	0x6Fbf82ccaedD96A943A1BFFda209b9A48F796027, //V2
3723 	0x812B50c025f0d950Df1E9B4F59C79BB00b08401c, //ASU
3724     0x9AAB019c4C67e5501C0c84BBDBd2540972392145,  //ARU
3725     0xab73bE9C25F6963B6E5aD6574D0C2eeccb27288E //community          
3726 	];
3727 
3728 	uint256[] private shareList = [2375, 2375, 2375, 2375, 500];
3729 
3730     uint256 public preSalesMintedQty = 0;
3731     uint256 public publicSalesMintedQty = 0;
3732     uint256 public giftedQty = 0;
3733 
3734     mapping(address => uint256) public preSalesMinterToTokenQty;
3735     mapping(address => uint256) public publicSalesMinterToTokenQty;
3736 
3737     bool public canRenounceOwnership = false;
3738     bool public paused = false;
3739     bool public revealed = false;
3740 
3741     string private baseTokenURI;
3742     string private notRevealedUri;
3743 
3744     constructor(string memory _notRevealedUri) ERC721A("Tsuki", "TSUKI") PaymentSplitter( addressList, shareList) {
3745         notRevealedUri = _notRevealedUri;
3746     }
3747 
3748     function getPrice() public view returns (uint256) {
3749         if (isPublicSalesActivated()) {
3750             return PUBLIC_SALES_PRICE;
3751         }
3752         return PRE_SALES_PRICE;
3753     }
3754 
3755     function preSalesMint(
3756         uint256 _mintQty,
3757         bytes memory signature
3758     )
3759         external
3760         payable
3761         isPreSalesActive
3762         isUserWhileList(msg.sender, signature )
3763     {
3764         require(
3765             preSalesMintedQty + publicSalesMintedQty + _mintQty <=
3766                 TOTAL_MAX_QTY,
3767             "Exceed sales max limit"
3768         );
3769 
3770         require(
3771             preSalesMintedQty + _mintQty <= PRESALES_MAX_QTY,
3772             "Exceed pre-sales max limit"
3773         );
3774 
3775         require(
3776             preSalesMinterToTokenQty[msg.sender] + _mintQty <= MAX_QTY_PER_MINTER_PRE_SALES,
3777             "Exceed signed quantity"
3778         );
3779 
3780         require(tx.origin == msg.sender,"CONTRACTS_NOT_ALLOWED_TO_MINT");
3781 
3782         require(!paused, "The contract is paused!");
3783         
3784         require(msg.value >= _mintQty * getPrice(), "Incorrect ETH");
3785 
3786         preSalesMinterToTokenQty[msg.sender] += _mintQty;
3787         preSalesMintedQty += _mintQty;
3788 
3789         _safeMint(msg.sender, _mintQty);
3790     }
3791 
3792     function publicSalesMint(uint256 _mintQty)
3793         external
3794         payable
3795         isPublicSalesActive
3796     {     
3797          require(
3798             preSalesMintedQty + publicSalesMintedQty + _mintQty <=
3799                 SALES_MAX_QTY,
3800             "Exceed sales max limit"
3801         );
3802         require(_mintQty <= MAX_QTY_PER_MINT, 
3803         "Exceed max mint per mint.");
3804 
3805         require(
3806             publicSalesMinterToTokenQty[msg.sender] + _mintQty <=
3807                 MAX_QTY_PER_MINTER,
3808             "Exceed max mint per minter"
3809         );
3810 
3811         require(tx.origin == msg.sender,"CONTRACTS_NOT_ALLOWED_TO_MINT");
3812 
3813         require(!paused, "The contract is paused!");
3814         
3815         require(msg.value >= _mintQty * getPrice(), "Incorrect ETH");
3816 
3817         publicSalesMinterToTokenQty[msg.sender] += _mintQty;
3818         publicSalesMintedQty += _mintQty;
3819 
3820         _safeMint(msg.sender, _mintQty);
3821     }
3822 
3823     function gift(address[] calldata receivers) external onlyOwner {
3824         require(
3825             giftedQty + receivers.length <= GIFT_MAX_QTY,
3826             "Exceed gift max limit"
3827         );
3828 
3829         giftedQty += receivers.length;
3830 
3831         for (uint256 i = 0; i < receivers.length; i++) {
3832             _safeMint(receivers[i], 1);
3833         }
3834     }
3835 
3836     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
3837         notRevealedUri = _notRevealedURI;
3838     }
3839 
3840     function setBaseTokenURI(string memory _baseTokenURI) external onlyOwner {
3841         baseTokenURI = _baseTokenURI;
3842     } 
3843 
3844     function _baseURI() internal view override virtual returns (string memory) {
3845 	    return baseTokenURI;
3846 	}
3847    
3848     function setRevealed(bool _state) external  onlyOwner {
3849         revealed = _state;
3850     } 
3851 
3852     function setPaused(bool _state) external  onlyOwner {
3853         paused = _state;
3854     }
3855 
3856     function setCanRenounceOwnership(bool _state) external  onlyOwner {
3857         canRenounceOwnership = _state;
3858     }    
3859 
3860     function tokenURI(uint256 tokenId)
3861         public
3862         view
3863         virtual
3864         override
3865         returns (string memory)
3866     {
3867         require(
3868         _exists(tokenId),
3869         "ERC721Metadata: URI query for nonexistent token"
3870         );
3871         
3872         if(!revealed) {
3873             return notRevealedUri;
3874         }
3875 
3876         string memory currentBaseURI = _baseURI();
3877 
3878         return bytes(currentBaseURI).length > 0
3879             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId)))
3880             : "";
3881     }
3882 
3883     function renounceOwnership() override public onlyOwner{
3884         require(canRenounceOwnership,"Not the time to Renounce Ownership");
3885         _transferOwnership(address(0));
3886     }
3887 
3888     function withdraw() public payable onlyOwner {
3889         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
3890         require(success);
3891 	}
3892 
3893 	function withdrawSplit() public onlyOwner {
3894         for (uint256 i = 0; i < addressList.length; i++) {
3895             address payable wallet = payable(addressList[i]);
3896             release(wallet);
3897         }
3898     }
3899 
3900 }