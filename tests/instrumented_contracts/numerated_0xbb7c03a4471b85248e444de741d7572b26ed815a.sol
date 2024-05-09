1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @title SafeERC20
90  * @dev Wrappers around ERC20 operations that throw on failure (when the token
91  * contract returns false). Tokens that return no value (and instead revert or
92  * throw on failure) are also supported, non-reverting calls are assumed to be
93  * successful.
94  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
95  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
96  */
97 library SafeERC20 {
98     using Address for address;
99 
100     function safeTransfer(
101         IERC20 token,
102         address to,
103         uint256 value
104     ) internal {
105         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
106     }
107 
108     function safeTransferFrom(
109         IERC20 token,
110         address from,
111         address to,
112         uint256 value
113     ) internal {
114         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
115     }
116 
117     /**
118      * @dev Deprecated. This function has issues similar to the ones found in
119      * {IERC20-approve}, and its usage is discouraged.
120      *
121      * Whenever possible, use {safeIncreaseAllowance} and
122      * {safeDecreaseAllowance} instead.
123      */
124     function safeApprove(
125         IERC20 token,
126         address spender,
127         uint256 value
128     ) internal {
129         // safeApprove should only be called when setting an initial allowance,
130         // or when resetting it to zero. To increase and decrease it, use
131         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
132         require(
133             (value == 0) || (token.allowance(address(this), spender) == 0),
134             "SafeERC20: approve from non-zero to non-zero allowance"
135         );
136         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
137     }
138 
139     function safeIncreaseAllowance(
140         IERC20 token,
141         address spender,
142         uint256 value
143     ) internal {
144         uint256 newAllowance = token.allowance(address(this), spender) + value;
145         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
146     }
147 
148     function safeDecreaseAllowance(
149         IERC20 token,
150         address spender,
151         uint256 value
152     ) internal {
153         unchecked {
154             uint256 oldAllowance = token.allowance(address(this), spender);
155             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
156             uint256 newAllowance = oldAllowance - value;
157             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
158         }
159     }
160 
161     /**
162      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
163      * on the return value: the return value is optional (but if data is returned, it must not be false).
164      * @param token The token targeted by the call.
165      * @param data The call data (encoded using abi.encode or one of its variants).
166      */
167     function _callOptionalReturn(IERC20 token, bytes memory data) private {
168         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
169         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
170         // the target address contains contract code and also asserts for success in the low-level call.
171 
172         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
173         if (returndata.length > 0) {
174             // Return data is optional
175             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
176         }
177     }
178 }
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev Interface of the ERC165 standard, as defined in the
184  * https://eips.ethereum.org/EIPS/eip-165[EIP].
185  *
186  * Implementers can declare support of contract interfaces, which can then be
187  * queried by others ({ERC165Checker}).
188  *
189  * For an implementation, see {ERC165}.
190  */
191 interface IERC165 {
192     /**
193      * @dev Returns true if this contract implements the interface defined by
194      * `interfaceId`. See the corresponding
195      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
196      * to learn more about how these ids are created.
197      *
198      * This function call must use less than 30 000 gas.
199      */
200     function supportsInterface(bytes4 interfaceId) external view returns (bool);
201 }
202 
203 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721.sol
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Required interface of an ERC721 compliant contract.
209  */
210 interface IERC721 is IERC165 {
211     /**
212      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
213      */
214     event Transfer(
215         address indexed from,
216         address indexed to,
217         uint256 indexed tokenId
218     );
219 
220     /**
221      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
222      */
223     event Approval(
224         address indexed owner,
225         address indexed approved,
226         uint256 indexed tokenId
227     );
228 
229     /**
230      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
231      */
232     event ApprovalForAll(
233         address indexed owner,
234         address indexed operator,
235         bool approved
236     );
237 
238     /**
239      * @dev Returns the number of tokens in ``owner``'s account.
240      */
241     function balanceOf(address owner) external view returns (uint256 balance);
242 
243     /**
244      * @dev Returns the owner of the `tokenId` token.
245      *
246      * Requirements:
247      *
248      * - `tokenId` must exist.
249      */
250     function ownerOf(uint256 tokenId) external view returns (address owner);
251 
252     /**
253      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
254      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must exist and be owned by `from`.
261      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
262      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
263      *
264      * Emits a {Transfer} event.
265      */
266     function safeTransferFrom(
267         address from,
268         address to,
269         uint256 tokenId
270     ) external;
271 
272     /**
273      * @dev Transfers `tokenId` token from `from` to `to`.
274      *
275      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must be owned by `from`.
282      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
283      *
284      * Emits a {Transfer} event.
285      */
286     function transferFrom(
287         address from,
288         address to,
289         uint256 tokenId
290     ) external;
291 
292     /**
293      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
294      * The approval is cleared when the token is transferred.
295      *
296      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
297      *
298      * Requirements:
299      *
300      * - The caller must own the token or be an approved operator.
301      * - `tokenId` must exist.
302      *
303      * Emits an {Approval} event.
304      */
305     function approve(address to, uint256 tokenId) external;
306 
307     /**
308      * @dev Returns the account approved for `tokenId` token.
309      *
310      * Requirements:
311      *
312      * - `tokenId` must exist.
313      */
314     function getApproved(uint256 tokenId)
315         external
316         view
317         returns (address operator);
318 
319     /**
320      * @dev Approve or remove `operator` as an operator for the caller.
321      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
322      *
323      * Requirements:
324      *
325      * - The `operator` cannot be the caller.
326      *
327      * Emits an {ApprovalForAll} event.
328      */
329     function setApprovalForAll(address operator, bool _approved) external;
330 
331     /**
332      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
333      *
334      * See {setApprovalForAll}
335      */
336     function isApprovedForAll(address owner, address operator)
337         external
338         view
339         returns (bool);
340 
341     /**
342      * @dev Safely transfers `tokenId` token from `from` to `to`.
343      *
344      * Requirements:
345      *
346      * - `from` cannot be the zero address.
347      * - `to` cannot be the zero address.
348      * - `tokenId` token must exist and be owned by `from`.
349      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
350      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
351      *
352      * Emits a {Transfer} event.
353      */
354     function safeTransferFrom(
355         address from,
356         address to,
357         uint256 tokenId,
358         bytes calldata data
359     ) external;
360 }
361 
362 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Receiver.sol
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @title ERC721 token receiver interface
368  * @dev Interface for any contract that wants to support safeTransfers
369  * from ERC721 asset contracts.
370  */
371 interface IERC721Receiver {
372     /**
373      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
374      * by `operator` from `from`, this function is called.
375      *
376      * It must return its Solidity selector to confirm the token transfer.
377      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
378      *
379      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
380      */
381     function onERC721Received(
382         address operator,
383         address from,
384         uint256 tokenId,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Metadata.sol
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
395  * @dev See https://eips.ethereum.org/EIPS/eip-721
396  */
397 interface IERC721Metadata is IERC721 {
398     /**
399      * @dev Returns the token collection name.
400      */
401     function name() external view returns (string memory);
402 
403     /**
404      * @dev Returns the token collection symbol.
405      */
406     function symbol() external view returns (string memory);
407 
408     /**
409      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
410      */
411     function tokenURI(uint256 tokenId) external view returns (string memory);
412 }
413 
414 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @dev Collection of functions related to the address type
420  */
421 library Address {
422     /**
423      * @dev Returns true if `account` is a contract.
424      *
425      * [IMPORTANT]
426      * ====
427      * It is unsafe to assume that an address for which this function returns
428      * false is an externally-owned account (EOA) and not a contract.
429      *
430      * Among others, `isContract` will return false for the following
431      * types of addresses:
432      *
433      *  - an externally-owned account
434      *  - a contract in construction
435      *  - an address where a contract will be created
436      *  - an address where a contract lived, but was destroyed
437      * ====
438      */
439     function isContract(address account) internal view returns (bool) {
440         // This method relies on extcodesize, which returns 0 for contracts in
441         // construction, since the code is only stored at the end of the
442         // constructor execution.
443 
444         uint256 size;
445         // solhint-disable-next-line no-inline-assembly
446         assembly {
447             size := extcodesize(account)
448         }
449         return size > 0;
450     }
451 
452     /**
453      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
454      * `recipient`, forwarding all available gas and reverting on errors.
455      *
456      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
457      * of certain opcodes, possibly making contracts go over the 2300 gas limit
458      * imposed by `transfer`, making them unable to receive funds via
459      * `transfer`. {sendValue} removes this limitation.
460      *
461      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
462      *
463      * IMPORTANT: because control is transferred to `recipient`, care must be
464      * taken to not create reentrancy vulnerabilities. Consider using
465      * {ReentrancyGuard} or the
466      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
467      */
468     function sendValue(address payable recipient, uint256 amount) internal {
469         require(
470             address(this).balance >= amount,
471             "Address: insufficient balance"
472         );
473 
474         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
475         (bool success, ) = recipient.call{value: amount}("");
476         require(
477             success,
478             "Address: unable to send value, recipient may have reverted"
479         );
480     }
481 
482     /**
483      * @dev Performs a Solidity function call using a low level `call`. A
484      * plain`call` is an unsafe replacement for a function call: use this
485      * function instead.
486      *
487      * If `target` reverts with a revert reason, it is bubbled up by this
488      * function (like regular Solidity function calls).
489      *
490      * Returns the raw returned data. To convert to the expected return value,
491      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
492      *
493      * Requirements:
494      *
495      * - `target` must be a contract.
496      * - calling `target` with `data` must not revert.
497      *
498      * _Available since v3.1._
499      */
500     function functionCall(address target, bytes memory data)
501         internal
502         returns (bytes memory)
503     {
504         return functionCall(target, data, "Address: low-level call failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
509      * `errorMessage` as a fallback revert reason when `target` reverts.
510      *
511      * _Available since v3.1._
512      */
513     function functionCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         return functionCallWithValue(target, data, 0, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but also transferring `value` wei to `target`.
524      *
525      * Requirements:
526      *
527      * - the calling contract must have an ETH balance of at least `value`.
528      * - the called Solidity function must be `payable`.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value
536     ) internal returns (bytes memory) {
537         return
538             functionCallWithValue(
539                 target,
540                 data,
541                 value,
542                 "Address: low-level call with value failed"
543             );
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
548      * with `errorMessage` as a fallback revert reason when `target` reverts.
549      *
550      * _Available since v3.1._
551      */
552     function functionCallWithValue(
553         address target,
554         bytes memory data,
555         uint256 value,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         require(
559             address(this).balance >= value,
560             "Address: insufficient balance for call"
561         );
562         require(isContract(target), "Address: call to non-contract");
563 
564         // solhint-disable-next-line avoid-low-level-calls
565         (bool success, bytes memory returndata) = target.call{value: value}(
566             data
567         );
568         return _verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but performing a static call.
574      *
575      * _Available since v3.3._
576      */
577     function functionStaticCall(address target, bytes memory data)
578         internal
579         view
580         returns (bytes memory)
581     {
582         return
583             functionStaticCall(
584                 target,
585                 data,
586                 "Address: low-level static call failed"
587             );
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal view returns (bytes memory) {
601         require(isContract(target), "Address: static call to non-contract");
602 
603         // solhint-disable-next-line avoid-low-level-calls
604         (bool success, bytes memory returndata) = target.staticcall(data);
605         return _verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(address target, bytes memory data)
615         internal
616         returns (bytes memory)
617     {
618         return
619             functionDelegateCall(
620                 target,
621                 data,
622                 "Address: low-level delegate call failed"
623             );
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
628      * but performing a delegate call.
629      *
630      * _Available since v3.4._
631      */
632     function functionDelegateCall(
633         address target,
634         bytes memory data,
635         string memory errorMessage
636     ) internal returns (bytes memory) {
637         require(isContract(target), "Address: delegate call to non-contract");
638 
639         // solhint-disable-next-line avoid-low-level-calls
640         (bool success, bytes memory returndata) = target.delegatecall(data);
641         return _verifyCallResult(success, returndata, errorMessage);
642     }
643 
644     function _verifyCallResult(
645         bool success,
646         bytes memory returndata,
647         string memory errorMessage
648     ) private pure returns (bytes memory) {
649         if (success) {
650             return returndata;
651         } else {
652             // Look for revert reason and bubble it up if present
653             if (returndata.length > 0) {
654                 // The easiest way to bubble the revert reason is using memory via assembly
655 
656                 // solhint-disable-next-line no-inline-assembly
657                 assembly {
658                     let returndata_size := mload(returndata)
659                     revert(add(32, returndata), returndata_size)
660                 }
661             } else {
662                 revert(errorMessage);
663             }
664         }
665     }
666 }
667 
668 // File: node_modules\openzeppelin-solidity\contracts\utils\Context.sol
669 
670 pragma solidity ^0.8.0;
671 
672 /*
673  * @dev Provides information about the current execution context, including the
674  * sender of the transaction and its data. While these are generally available
675  * via msg.sender and msg.data, they should not be accessed in such a direct
676  * manner, since when dealing with meta-transactions the account sending and
677  * paying for execution may not be the actual sender (as far as an application
678  * is concerned).
679  *
680  * This contract is only required for intermediate, library-like contracts.
681  */
682 abstract contract Context {
683     function _msgSender() internal view virtual returns (address) {
684         return msg.sender;
685     }
686 
687     function _msgData() internal view virtual returns (bytes calldata) {
688         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
689         return msg.data;
690     }
691 }
692 
693 // File: node_modules\openzeppelin-solidity\contracts\utils\Strings.sol
694 
695 pragma solidity ^0.8.0;
696 
697 /**
698  * @dev String operations.
699  */
700 library Strings {
701     bytes16 private constant alphabet = "0123456789abcdef";
702 
703     /**
704      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
705      */
706     function toString(uint256 value) internal pure returns (string memory) {
707         // Inspired by OraclizeAPI's implementation - MIT licence
708         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
709 
710         if (value == 0) {
711             return "0";
712         }
713         uint256 temp = value;
714         uint256 digits;
715         while (temp != 0) {
716             digits++;
717             temp /= 10;
718         }
719         bytes memory buffer = new bytes(digits);
720         while (value != 0) {
721             digits -= 1;
722             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
723             value /= 10;
724         }
725         return string(buffer);
726     }
727 
728     /**
729      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
730      */
731     function toHexString(uint256 value) internal pure returns (string memory) {
732         if (value == 0) {
733             return "0x00";
734         }
735         uint256 temp = value;
736         uint256 length = 0;
737         while (temp != 0) {
738             length++;
739             temp >>= 8;
740         }
741         return toHexString(value, length);
742     }
743 
744     /**
745      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
746      */
747     function toHexString(uint256 value, uint256 length)
748         internal
749         pure
750         returns (string memory)
751     {
752         bytes memory buffer = new bytes(2 * length + 2);
753         buffer[0] = "0";
754         buffer[1] = "x";
755         for (uint256 i = 2 * length + 1; i > 1; --i) {
756             buffer[i] = alphabet[value & 0xf];
757             value >>= 4;
758         }
759         require(value == 0, "Strings: hex length insufficient");
760         return string(buffer);
761     }
762 }
763 
764 // File: node_modules\openzeppelin-solidity\contracts\utils\introspection\ERC165.sol
765 
766 pragma solidity ^0.8.0;
767 
768 /**
769  * @dev Implementation of the {IERC165} interface.
770  *
771  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
772  * for the additional interface id that will be supported. For example:
773  *
774  * ```solidity
775  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
776  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
777  * }
778  * ```
779  *
780  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
781  */
782 abstract contract ERC165 is IERC165 {
783     /**
784      * @dev See {IERC165-supportsInterface}.
785      */
786     function supportsInterface(bytes4 interfaceId)
787         public
788         view
789         virtual
790         override
791         returns (bool)
792     {
793         return interfaceId == type(IERC165).interfaceId;
794     }
795 }
796 
797 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721.sol
798 
799 pragma solidity ^0.8.0;
800 
801 /**
802  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
803  * the Metadata extension, but not including the Enumerable extension, which is available separately as
804  * {ERC721Enumerable}.
805  */
806 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
807     using Address for address;
808     using Strings for uint256;
809 
810     // Token name
811     string private _name;
812 
813     // Token symbol
814     string private _symbol;
815 
816     // Mapping from token ID to owner address
817     mapping(uint256 => address) private _owners;
818 
819     // Mapping owner address to token count
820     mapping(address => uint256) private _balances;
821 
822     // Mapping from token ID to approved address
823     mapping(uint256 => address) private _tokenApprovals;
824 
825     // Mapping from owner to operator approvals
826     mapping(address => mapping(address => bool)) private _operatorApprovals;
827 
828     /**
829      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
830      */
831     constructor(string memory name_, string memory symbol_) {
832         _name = name_;
833         _symbol = symbol_;
834     }
835 
836     /**
837      * @dev See {IERC165-supportsInterface}.
838      */
839     function supportsInterface(bytes4 interfaceId)
840         public
841         view
842         virtual
843         override(ERC165, IERC165)
844         returns (bool)
845     {
846         return
847             interfaceId == type(IERC721).interfaceId ||
848             interfaceId == type(IERC721Metadata).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev See {IERC721-balanceOf}.
854      */
855     function balanceOf(address owner)
856         public
857         view
858         virtual
859         override
860         returns (uint256)
861     {
862         require(
863             owner != address(0),
864             "ERC721: balance query for the zero address"
865         );
866         return _balances[owner];
867     }
868 
869     /**
870      * @dev See {IERC721-ownerOf}.
871      */
872     function ownerOf(uint256 tokenId)
873         public
874         view
875         virtual
876         override
877         returns (address)
878     {
879         address owner = _owners[tokenId];
880         require(
881             owner != address(0),
882             "ERC721: owner query for nonexistent token"
883         );
884         return owner;
885     }
886 
887     /**
888      * @dev See {IERC721Metadata-name}.
889      */
890     function name() public view virtual override returns (string memory) {
891         return _name;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-symbol}.
896      */
897     function symbol() public view virtual override returns (string memory) {
898         return _symbol;
899     }
900 
901     /**
902      * @dev See {IERC721Metadata-tokenURI}.
903      */
904     function tokenURI(uint256 tokenId)
905         public
906         view
907         virtual
908         override
909         returns (string memory)
910     {
911         require(
912             _exists(tokenId),
913             "ERC721Metadata: URI query for nonexistent token"
914         );
915 
916         string memory baseURI = _baseURI();
917         return
918             bytes(baseURI).length > 0
919                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
920                 : "";
921     }
922 
923     /**
924      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
925      * in child contracts.
926      */
927     function _baseURI() internal view virtual returns (string memory) {
928         return "";
929     }
930 
931     /**
932      * @dev See {IERC721-approve}.
933      */
934     function approve(address to, uint256 tokenId) public virtual override {
935         address owner = ERC721.ownerOf(tokenId);
936         require(to != owner, "ERC721: approval to current owner");
937 
938         require(
939             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
940             "ERC721: approve caller is not owner nor approved for all"
941         );
942 
943         _approve(to, tokenId);
944     }
945 
946     /**
947      * @dev See {IERC721-getApproved}.
948      */
949     function getApproved(uint256 tokenId)
950         public
951         view
952         virtual
953         override
954         returns (address)
955     {
956         require(
957             _exists(tokenId),
958             "ERC721: approved query for nonexistent token"
959         );
960 
961         return _tokenApprovals[tokenId];
962     }
963 
964     /**
965      * @dev See {IERC721-setApprovalForAll}.
966      */
967     function setApprovalForAll(address operator, bool approved)
968         public
969         virtual
970         override
971     {
972         require(operator != _msgSender(), "ERC721: approve to caller");
973 
974         _operatorApprovals[_msgSender()][operator] = approved;
975         emit ApprovalForAll(_msgSender(), operator, approved);
976     }
977 
978     /**
979      * @dev See {IERC721-isApprovedForAll}.
980      */
981     function isApprovedForAll(address owner, address operator)
982         public
983         view
984         virtual
985         override
986         returns (bool)
987     {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev See {IERC721-transferFrom}.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         //solhint-disable-next-line max-line-length
1000         require(
1001             _isApprovedOrOwner(_msgSender(), tokenId),
1002             "ERC721: transfer caller is not owner nor approved"
1003         );
1004 
1005         _transfer(from, to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-safeTransferFrom}.
1010      */
1011     function safeTransferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) public virtual override {
1016         safeTransferFrom(from, to, tokenId, "");
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-safeTransferFrom}.
1021      */
1022     function safeTransferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId,
1026         bytes memory _data
1027     ) public virtual override {
1028         require(
1029             _isApprovedOrOwner(_msgSender(), tokenId),
1030             "ERC721: transfer caller is not owner nor approved"
1031         );
1032         _safeTransfer(from, to, tokenId, _data);
1033     }
1034 
1035     /**
1036      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1037      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1038      *
1039      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1040      *
1041      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1042      * implement alternative mechanisms to perform token transfer, such as signature-based.
1043      *
1044      * Requirements:
1045      *
1046      * - `from` cannot be the zero address.
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must exist and be owned by `from`.
1049      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _safeTransfer(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory _data
1058     ) internal virtual {
1059         _transfer(from, to, tokenId);
1060         require(
1061             _checkOnERC721Received(from, to, tokenId, _data),
1062             "ERC721: transfer to non ERC721Receiver implementer"
1063         );
1064     }
1065 
1066     /**
1067      * @dev Returns whether `tokenId` exists.
1068      *
1069      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1070      *
1071      * Tokens start existing when they are minted (`_mint`),
1072      * and stop existing when they are burned (`_burn`).
1073      */
1074     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1075         return _owners[tokenId] != address(0);
1076     }
1077 
1078     /**
1079      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must exist.
1084      */
1085     function _isApprovedOrOwner(address spender, uint256 tokenId)
1086         internal
1087         view
1088         virtual
1089         returns (bool)
1090     {
1091         require(
1092             _exists(tokenId),
1093             "ERC721: operator query for nonexistent token"
1094         );
1095         address owner = ERC721.ownerOf(tokenId);
1096         return (spender == owner ||
1097             getApproved(tokenId) == spender ||
1098             isApprovedForAll(owner, spender));
1099     }
1100 
1101     /**
1102      * @dev Safely mints `tokenId` and transfers it to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must not exist.
1107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _safeMint(address to, uint256 tokenId) internal virtual {
1112         _safeMint(to, tokenId, "");
1113     }
1114 
1115     /**
1116      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1117      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1118      */
1119     function _safeMint(
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) internal virtual {
1124         _mint(to, tokenId);
1125         require(
1126             _checkOnERC721Received(address(0), to, tokenId, _data),
1127             "ERC721: transfer to non ERC721Receiver implementer"
1128         );
1129     }
1130 
1131     /**
1132      * @dev Mints `tokenId` and transfers it to `to`.
1133      *
1134      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must not exist.
1139      * - `to` cannot be the zero address.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _mint(address to, uint256 tokenId) internal virtual {
1144         require(to != address(0), "ERC721: mint to the zero address");
1145         require(!_exists(tokenId), "ERC721: token already minted");
1146 
1147         _beforeTokenTransfer(address(0), to, tokenId);
1148 
1149         _balances[to] += 1;
1150         _owners[tokenId] = to;
1151 
1152         emit Transfer(address(0), to, tokenId);
1153     }
1154 
1155     /**
1156      * @dev Destroys `tokenId`.
1157      * The approval is cleared when the token is burned.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must exist.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _burn(uint256 tokenId) internal virtual {
1166         address owner = ERC721.ownerOf(tokenId);
1167 
1168         _beforeTokenTransfer(owner, address(0), tokenId);
1169 
1170         // Clear approvals
1171         _approve(address(0), tokenId);
1172 
1173         _balances[owner] -= 1;
1174         delete _owners[tokenId];
1175 
1176         emit Transfer(owner, address(0), tokenId);
1177     }
1178 
1179     /**
1180      * @dev Transfers `tokenId` from `from` to `to`.
1181      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _transfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) internal virtual {
1195         require(
1196             ERC721.ownerOf(tokenId) == from,
1197             "ERC721: transfer of token that is not own"
1198         );
1199         require(to != address(0), "ERC721: transfer to the zero address");
1200 
1201         _beforeTokenTransfer(from, to, tokenId);
1202 
1203         // Clear approvals from the previous owner
1204         _approve(address(0), tokenId);
1205 
1206         _balances[from] -= 1;
1207         _balances[to] += 1;
1208         _owners[tokenId] = to;
1209 
1210         emit Transfer(from, to, tokenId);
1211     }
1212 
1213     /**
1214      * @dev Approve `to` to operate on `tokenId`
1215      *
1216      * Emits a {Approval} event.
1217      */
1218     function _approve(address to, uint256 tokenId) internal virtual {
1219         _tokenApprovals[tokenId] = to;
1220         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1221     }
1222 
1223     /**
1224      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1225      * The call is not executed if the target address is not a contract.
1226      *
1227      * @param from address representing the previous owner of the given token ID
1228      * @param to target address that will receive the tokens
1229      * @param tokenId uint256 ID of the token to be transferred
1230      * @param _data bytes optional data to send along with the call
1231      * @return bool whether the call correctly returned the expected magic value
1232      */
1233     function _checkOnERC721Received(
1234         address from,
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) private returns (bool) {
1239         if (to.isContract()) {
1240             try
1241                 IERC721Receiver(to).onERC721Received(
1242                     _msgSender(),
1243                     from,
1244                     tokenId,
1245                     _data
1246                 )
1247             returns (bytes4 retval) {
1248                 return retval == IERC721Receiver(to).onERC721Received.selector;
1249             } catch (bytes memory reason) {
1250                 if (reason.length == 0) {
1251                     revert(
1252                         "ERC721: transfer to non ERC721Receiver implementer"
1253                     );
1254                 } else {
1255                     // solhint-disable-next-line no-inline-assembly
1256                     assembly {
1257                         revert(add(32, reason), mload(reason))
1258                     }
1259                 }
1260             }
1261         } else {
1262             return true;
1263         }
1264     }
1265 
1266     /**
1267      * @dev Hook that is called before any token transfer. This includes minting
1268      * and burning.
1269      *
1270      * Calling conditions:
1271      *
1272      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1273      * transferred to `to`.
1274      * - When `from` is zero, `tokenId` will be minted for `to`.
1275      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1276      * - `from` cannot be the zero address.
1277      * - `to` cannot be the zero address.
1278      *
1279      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1280      */
1281     function _beforeTokenTransfer(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) internal virtual {}
1286 }
1287 
1288 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Enumerable.sol
1289 
1290 pragma solidity ^0.8.0;
1291 
1292 /**
1293  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1294  * @dev See https://eips.ethereum.org/EIPS/eip-721
1295  */
1296 interface IERC721Enumerable is IERC721 {
1297     /**
1298      * @dev Returns the total amount of tokens stored by the contract.
1299      */
1300     function totalSupply() external view returns (uint256);
1301 
1302     /**
1303      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1304      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1305      */
1306     function tokenOfOwnerByIndex(address owner, uint256 index)
1307         external
1308         view
1309         returns (uint256 tokenId);
1310 
1311     /**
1312      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1313      * Use along with {totalSupply} to enumerate all tokens.
1314      */
1315     function tokenByIndex(uint256 index) external view returns (uint256);
1316 }
1317 
1318 // File: openzeppelin-solidity\contracts\access\Ownable.sol
1319 
1320 pragma solidity ^0.8.0;
1321 
1322 /**
1323  * @dev Contract module which provides a basic access control mechanism, where
1324  * there is an account (an owner) that can be granted exclusive access to
1325  * specific functions.
1326  *
1327  * By default, the owner account will be the one that deploys the contract. This
1328  * can later be changed with {transferOwnership}.
1329  *
1330  * This module is used through inheritance. It will make available the modifier
1331  * `onlyOwner`, which can be applied to your functions to restrict their use to
1332  * the owner.
1333  */
1334 abstract contract Ownable is Context {
1335     address private _owner;
1336 
1337     event OwnershipTransferred(
1338         address indexed previousOwner,
1339         address indexed newOwner
1340     );
1341 
1342     /**
1343      * @dev Initializes the contract setting the deployer as the initial owner.
1344      */
1345     constructor() {
1346         address msgSender = _msgSender();
1347         _owner = msgSender;
1348         emit OwnershipTransferred(address(0), msgSender);
1349     }
1350 
1351     /**
1352      * @dev Returns the address of the current owner.
1353      */
1354     function owner() public view virtual returns (address) {
1355         return _owner;
1356     }
1357 
1358     /**
1359      * @dev Throws if called by any account other than the owner.
1360      */
1361     modifier onlyOwner() {
1362         require(
1363             owner() == _msgSender(),
1364             "Ownable: caller is not the owner"
1365         );
1366         _;
1367     }
1368 
1369     /**
1370      * @dev Leaves the contract without owner. It will not be possible to call
1371      * `onlyOwner` functions anymore. Can only be called by the current owner.
1372      *
1373      * NOTE: Renouncing ownership will leave the contract without an owner,
1374      * thereby removing any functionality that is only available to the owner.
1375      */
1376     function renounceOwnership() public virtual onlyOwner {
1377         emit OwnershipTransferred(_owner, address(0));
1378         _owner = address(0);
1379     }
1380 
1381     /**
1382      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1383      * Can only be called by the current owner.
1384      */
1385     function transferOwnership(address newOwner) public virtual onlyOwner {
1386         require(
1387             newOwner != address(0),
1388             "Ownable: new owner is the zero address"
1389         );
1390         emit OwnershipTransferred(_owner, newOwner);
1391         _owner = newOwner;
1392     }
1393 }
1394 
1395 // File: openzeppelin-solidity\contracts\token\ERC721\extensions\ERC721Enumerable.sol
1396 
1397 pragma solidity ^0.8.0;
1398 
1399 /**
1400  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1401  * enumerability of all the token ids in the contract as well as all token ids owned by each
1402  * account.
1403  */
1404 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1405     // Mapping from owner to list of owned token IDs
1406     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1407 
1408     // Mapping from token ID to index of the owner tokens list
1409     mapping(uint256 => uint256) private _ownedTokensIndex;
1410 
1411     // Array with all token ids, used for enumeration
1412     uint256[] private _allTokens;
1413 
1414     // Mapping from token id to position in the allTokens array
1415     mapping(uint256 => uint256) private _allTokensIndex;
1416 
1417     /**
1418      * @dev See {IERC165-supportsInterface}.
1419      */
1420     function supportsInterface(bytes4 interfaceId)
1421         public
1422         view
1423         virtual
1424         override(IERC165, ERC721)
1425         returns (bool)
1426     {
1427         return
1428             interfaceId == type(IERC721Enumerable).interfaceId ||
1429             super.supportsInterface(interfaceId);
1430     }
1431 
1432     /**
1433      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1434      */
1435     function tokenOfOwnerByIndex(address owner, uint256 index)
1436         public
1437         view
1438         virtual
1439         override
1440         returns (uint256)
1441     {
1442         require(
1443             index < ERC721.balanceOf(owner),
1444             "ERC721Enumerable: owner index out of bounds"
1445         );
1446         return _ownedTokens[owner][index];
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Enumerable-totalSupply}.
1451      */
1452     function totalSupply() public view virtual override returns (uint256) {
1453         return _allTokens.length;
1454     }
1455 
1456     /**
1457      * @dev See {IERC721Enumerable-tokenByIndex}.
1458      */
1459     function tokenByIndex(uint256 index)
1460         public
1461         view
1462         virtual
1463         override
1464         returns (uint256)
1465     {
1466         require(
1467             index < ERC721Enumerable.totalSupply(),
1468             "ERC721Enumerable: global index out of bounds"
1469         );
1470         return _allTokens[index];
1471     }
1472 
1473     /**
1474      * @dev Hook that is called before any token transfer. This includes minting
1475      * and burning.
1476      *
1477      * Calling conditions:
1478      *
1479      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1480      * transferred to `to`.
1481      * - When `from` is zero, `tokenId` will be minted for `to`.
1482      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1483      * - `from` cannot be the zero address.
1484      * - `to` cannot be the zero address.
1485      *
1486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1487      */
1488     function _beforeTokenTransfer(
1489         address from,
1490         address to,
1491         uint256 tokenId
1492     ) internal virtual override {
1493         super._beforeTokenTransfer(from, to, tokenId);
1494 
1495         if (from == address(0)) {
1496             _addTokenToAllTokensEnumeration(tokenId);
1497         } else if (from != to) {
1498             _removeTokenFromOwnerEnumeration(from, tokenId);
1499         }
1500         if (to == address(0)) {
1501             _removeTokenFromAllTokensEnumeration(tokenId);
1502         } else if (to != from) {
1503             _addTokenToOwnerEnumeration(to, tokenId);
1504         }
1505     }
1506 
1507     /**
1508      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1509      * @param to address representing the new owner of the given token ID
1510      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1511      */
1512     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1513         uint256 length = ERC721.balanceOf(to);
1514         _ownedTokens[to][length] = tokenId;
1515         _ownedTokensIndex[tokenId] = length;
1516     }
1517 
1518     /**
1519      * @dev Private function to add a token to this extension's token tracking data structures.
1520      * @param tokenId uint256 ID of the token to be added to the tokens list
1521      */
1522     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1523         _allTokensIndex[tokenId] = _allTokens.length;
1524         _allTokens.push(tokenId);
1525     }
1526 
1527     /**
1528      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1529      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1530      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1531      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1532      * @param from address representing the previous owner of the given token ID
1533      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1534      */
1535     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1536         private
1537     {
1538         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1539         // then delete the last slot (swap and pop).
1540 
1541         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1542         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1543 
1544         // When the token to delete is the last token, the swap operation is unnecessary
1545         if (tokenIndex != lastTokenIndex) {
1546             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1547 
1548             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1549             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1550         }
1551 
1552         // This also deletes the contents at the last position of the array
1553         delete _ownedTokensIndex[tokenId];
1554         delete _ownedTokens[from][lastTokenIndex];
1555     }
1556 
1557     /**
1558      * @dev Private function to remove a token from this extension's token tracking data structures.
1559      * This has O(1) time complexity, but alters the order of the _allTokens array.
1560      * @param tokenId uint256 ID of the token to be removed from the tokens list
1561      */
1562     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1563         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1564         // then delete the last slot (swap and pop).
1565 
1566         uint256 lastTokenIndex = _allTokens.length - 1;
1567         uint256 tokenIndex = _allTokensIndex[tokenId];
1568 
1569         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1570         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1571         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1572         uint256 lastTokenId = _allTokens[lastTokenIndex];
1573 
1574         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1575         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1576 
1577         // This also deletes the contents at the last position of the array
1578         delete _allTokensIndex[tokenId];
1579         _allTokens.pop();
1580     }
1581 }
1582 
1583 // File: contracts\lib\Counters.sol
1584 
1585 pragma solidity ^0.8.0;
1586 
1587 /**
1588  * @title Counters
1589  * @author Matt Condon (@shrugs)
1590  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1591  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1592  *
1593  * Include with `using Counters for Counters.Counter;`
1594  */
1595 library Counters {
1596     struct Counter {
1597         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1598         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1599         // this feature: see https://github.com/ethereum/solidity/issues/4637
1600         uint256 _value; // default: 0
1601     }
1602 
1603     function current(Counter storage counter) internal view returns (uint256) {
1604         return counter._value;
1605     }
1606 
1607     function increment(Counter storage counter) internal {
1608         {
1609             counter._value += 1;
1610         }
1611     }
1612 
1613     function decrement(Counter storage counter) internal {
1614         uint256 value = counter._value;
1615         require(value > 0, "Counter: decrement overflow");
1616         {
1617             counter._value = value - 1;
1618         }
1619     }
1620 }
1621 
1622 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1623 
1624 
1625 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1626 
1627 pragma solidity ^0.8.0;
1628 
1629 /**
1630  * @dev These functions deal with verification of Merkle Trees proofs.
1631  *
1632  * The proofs can be generated using the JavaScript library
1633  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1634  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1635  *
1636  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1637  */
1638 library MerkleProof {
1639     /**
1640      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1641      * defined by `root`. For this, a `proof` must be provided, containing
1642      * sibling hashes on the branch from the leaf to the root of the tree. Each
1643      * pair of leaves and each pair of pre-images are assumed to be sorted.
1644      */
1645     function verify(
1646         bytes32[] memory proof,
1647         bytes32 root,
1648         bytes32 leaf
1649     ) internal pure returns (bool) {
1650         return processProof(proof, leaf) == root;
1651     }
1652 
1653     /**
1654      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1655      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1656      * hash matches the root of the tree. When processing the proof, the pairs
1657      * of leafs & pre-images are assumed to be sorted.
1658      *
1659      * _Available since v4.4._
1660      */
1661     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1662         bytes32 computedHash = leaf;
1663         for (uint256 i = 0; i < proof.length; i++) {
1664             bytes32 proofElement = proof[i];
1665             if (computedHash <= proofElement) {
1666                 // Hash(current computed hash + current element of the proof)
1667                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1668             } else {
1669                 // Hash(current element of the proof + current computed hash)
1670                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1671             }
1672         }
1673         return computedHash;
1674     }
1675 }
1676 
1677 // File openzeppelin-solidity/contracts/utils/math/SafeMath.sol@v4.4.1
1678 
1679 
1680 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1681 
1682 pragma solidity ^0.8.0;
1683 
1684 // CAUTION
1685 // This version of SafeMath should only be used with Solidity 0.8 or later,
1686 // because it relies on the compiler's built in overflow checks.
1687 
1688 /**
1689  * @dev Wrappers over Solidity's arithmetic operations.
1690  *
1691  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1692  * now has built in overflow checking.
1693  */
1694 library SafeMath {
1695     /**
1696      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1697      *
1698      * _Available since v3.4._
1699      */
1700     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1701         unchecked {
1702             uint256 c = a + b;
1703             if (c < a) return (false, 0);
1704             return (true, c);
1705         }
1706     }
1707 
1708     /**
1709      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1710      *
1711      * _Available since v3.4._
1712      */
1713     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1714         unchecked {
1715             if (b > a) return (false, 0);
1716             return (true, a - b);
1717         }
1718     }
1719 
1720     /**
1721      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1722      *
1723      * _Available since v3.4._
1724      */
1725     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1726         unchecked {
1727             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1728             // benefit is lost if 'b' is also tested.
1729             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1730             if (a == 0) return (true, 0);
1731             uint256 c = a * b;
1732             if (c / a != b) return (false, 0);
1733             return (true, c);
1734         }
1735     }
1736 
1737     /**
1738      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1739      *
1740      * _Available since v3.4._
1741      */
1742     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1743         unchecked {
1744             if (b == 0) return (false, 0);
1745             return (true, a / b);
1746         }
1747     }
1748 
1749     /**
1750      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1751      *
1752      * _Available since v3.4._
1753      */
1754     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1755         unchecked {
1756             if (b == 0) return (false, 0);
1757             return (true, a % b);
1758         }
1759     }
1760 
1761     /**
1762      * @dev Returns the addition of two unsigned integers, reverting on
1763      * overflow.
1764      *
1765      * Counterpart to Solidity's `+` operator.
1766      *
1767      * Requirements:
1768      *
1769      * - Addition cannot overflow.
1770      */
1771     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1772         return a + b;
1773     }
1774 
1775     /**
1776      * @dev Returns the subtraction of two unsigned integers, reverting on
1777      * overflow (when the result is negative).
1778      *
1779      * Counterpart to Solidity's `-` operator.
1780      *
1781      * Requirements:
1782      *
1783      * - Subtraction cannot overflow.
1784      */
1785     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1786         return a - b;
1787     }
1788 
1789     /**
1790      * @dev Returns the multiplication of two unsigned integers, reverting on
1791      * overflow.
1792      *
1793      * Counterpart to Solidity's `*` operator.
1794      *
1795      * Requirements:
1796      *
1797      * - Multiplication cannot overflow.
1798      */
1799     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1800         return a * b;
1801     }
1802 
1803     /**
1804      * @dev Returns the integer division of two unsigned integers, reverting on
1805      * division by zero. The result is rounded towards zero.
1806      *
1807      * Counterpart to Solidity's `/` operator.
1808      *
1809      * Requirements:
1810      *
1811      * - The divisor cannot be zero.
1812      */
1813     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1814         return a / b;
1815     }
1816 
1817     /**
1818      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1819      * reverting when dividing by zero.
1820      *
1821      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1822      * opcode (which leaves remaining gas untouched) while Solidity uses an
1823      * invalid opcode to revert (consuming all remaining gas).
1824      *
1825      * Requirements:
1826      *
1827      * - The divisor cannot be zero.
1828      */
1829     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1830         return a % b;
1831     }
1832 
1833     /**
1834      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1835      * overflow (when the result is negative).
1836      *
1837      * CAUTION: This function is deprecated because it requires allocating memory for the error
1838      * message unnecessarily. For custom revert reasons use {trySub}.
1839      *
1840      * Counterpart to Solidity's `-` operator.
1841      *
1842      * Requirements:
1843      *
1844      * - Subtraction cannot overflow.
1845      */
1846     function sub(
1847         uint256 a,
1848         uint256 b,
1849         string memory errorMessage
1850     ) internal pure returns (uint256) {
1851         unchecked {
1852             require(b <= a, errorMessage);
1853             return a - b;
1854         }
1855     }
1856 
1857     /**
1858      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1859      * division by zero. The result is rounded towards zero.
1860      *
1861      * Counterpart to Solidity's `/` operator. Note: this function uses a
1862      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1863      * uses an invalid opcode to revert (consuming all remaining gas).
1864      *
1865      * Requirements:
1866      *
1867      * - The divisor cannot be zero.
1868      */
1869     function div(
1870         uint256 a,
1871         uint256 b,
1872         string memory errorMessage
1873     ) internal pure returns (uint256) {
1874         unchecked {
1875             require(b > 0, errorMessage);
1876             return a / b;
1877         }
1878     }
1879 
1880     /**
1881      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1882      * reverting with custom message when dividing by zero.
1883      *
1884      * CAUTION: This function is deprecated because it requires allocating memory for the error
1885      * message unnecessarily. For custom revert reasons use {tryMod}.
1886      *
1887      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1888      * opcode (which leaves remaining gas untouched) while Solidity uses an
1889      * invalid opcode to revert (consuming all remaining gas).
1890      *
1891      * Requirements:
1892      *
1893      * - The divisor cannot be zero.
1894      */
1895     function mod(
1896         uint256 a,
1897         uint256 b,
1898         string memory errorMessage
1899     ) internal pure returns (uint256) {
1900         unchecked {
1901             require(b > 0, errorMessage);
1902             return a % b;
1903         }
1904     }
1905 }
1906 
1907 // File openzeppelin-solidity/contracts/utils/structs/EnumerableSet.sol@v4.4.1
1908 
1909 
1910 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
1911 
1912 pragma solidity ^0.8.0;
1913 
1914 /**
1915  * @dev Library for managing
1916  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1917  * types.
1918  *
1919  * Sets have the following properties:
1920  *
1921  * - Elements are added, removed, and checked for existence in constant time
1922  * (O(1)).
1923  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1924  *
1925  * ```
1926  * contract Example {
1927  *     // Add the library methods
1928  *     using EnumerableSet for EnumerableSet.AddressSet;
1929  *
1930  *     // Declare a set state variable
1931  *     EnumerableSet.AddressSet private mySet;
1932  * }
1933  * ```
1934  *
1935  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1936  * and `uint256` (`UintSet`) are supported.
1937  */
1938 library EnumerableSet {
1939     // To implement this library for multiple types with as little code
1940     // repetition as possible, we write it in terms of a generic Set type with
1941     // bytes32 values.
1942     // The Set implementation uses private functions, and user-facing
1943     // implementations (such as AddressSet) are just wrappers around the
1944     // underlying Set.
1945     // This means that we can only create new EnumerableSets for types that fit
1946     // in bytes32.
1947 
1948     struct Set {
1949         // Storage of set values
1950         bytes32[] _values;
1951         // Position of the value in the `values` array, plus 1 because index 0
1952         // means a value is not in the set.
1953         mapping(bytes32 => uint256) _indexes;
1954     }
1955 
1956     /**
1957      * @dev Add a value to a set. O(1).
1958      *
1959      * Returns true if the value was added to the set, that is if it was not
1960      * already present.
1961      */
1962     function _add(Set storage set, bytes32 value) private returns (bool) {
1963         if (!_contains(set, value)) {
1964             set._values.push(value);
1965             // The value is stored at length-1, but we add 1 to all indexes
1966             // and use 0 as a sentinel value
1967             set._indexes[value] = set._values.length;
1968             return true;
1969         } else {
1970             return false;
1971         }
1972     }
1973 
1974     /**
1975      * @dev Removes a value from a set. O(1).
1976      *
1977      * Returns true if the value was removed from the set, that is if it was
1978      * present.
1979      */
1980     function _remove(Set storage set, bytes32 value) private returns (bool) {
1981         // We read and store the value's index to prevent multiple reads from the same storage slot
1982         uint256 valueIndex = set._indexes[value];
1983 
1984         if (valueIndex != 0) {
1985             // Equivalent to contains(set, value)
1986             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1987             // the array, and then remove the last element (sometimes called as 'swap and pop').
1988             // This modifies the order of the array, as noted in {at}.
1989 
1990             uint256 toDeleteIndex = valueIndex - 1;
1991             uint256 lastIndex = set._values.length - 1;
1992 
1993             if (lastIndex != toDeleteIndex) {
1994                 bytes32 lastvalue = set._values[lastIndex];
1995 
1996                 // Move the last value to the index where the value to delete is
1997                 set._values[toDeleteIndex] = lastvalue;
1998                 // Update the index for the moved value
1999                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
2000             }
2001 
2002             // Delete the slot where the moved value was stored
2003             set._values.pop();
2004 
2005             // Delete the index for the deleted slot
2006             delete set._indexes[value];
2007 
2008             return true;
2009         } else {
2010             return false;
2011         }
2012     }
2013 
2014     /**
2015      * @dev Returns true if the value is in the set. O(1).
2016      */
2017     function _contains(Set storage set, bytes32 value) private view returns (bool) {
2018         return set._indexes[value] != 0;
2019     }
2020 
2021     /**
2022      * @dev Returns the number of values on the set. O(1).
2023      */
2024     function _length(Set storage set) private view returns (uint256) {
2025         return set._values.length;
2026     }
2027 
2028     /**
2029      * @dev Returns the value stored at position `index` in the set. O(1).
2030      *
2031      * Note that there are no guarantees on the ordering of values inside the
2032      * array, and it may change when more values are added or removed.
2033      *
2034      * Requirements:
2035      *
2036      * - `index` must be strictly less than {length}.
2037      */
2038     function _at(Set storage set, uint256 index) private view returns (bytes32) {
2039         return set._values[index];
2040     }
2041 
2042     /**
2043      * @dev Return the entire set in an array
2044      *
2045      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2046      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2047      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2048      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2049      */
2050     function _values(Set storage set) private view returns (bytes32[] memory) {
2051         return set._values;
2052     }
2053 
2054     // Bytes32Set
2055 
2056     struct Bytes32Set {
2057         Set _inner;
2058     }
2059 
2060     /**
2061      * @dev Add a value to a set. O(1).
2062      *
2063      * Returns true if the value was added to the set, that is if it was not
2064      * already present.
2065      */
2066     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2067         return _add(set._inner, value);
2068     }
2069 
2070     /**
2071      * @dev Removes a value from a set. O(1).
2072      *
2073      * Returns true if the value was removed from the set, that is if it was
2074      * present.
2075      */
2076     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2077         return _remove(set._inner, value);
2078     }
2079 
2080     /**
2081      * @dev Returns true if the value is in the set. O(1).
2082      */
2083     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
2084         return _contains(set._inner, value);
2085     }
2086 
2087     /**
2088      * @dev Returns the number of values in the set. O(1).
2089      */
2090     function length(Bytes32Set storage set) internal view returns (uint256) {
2091         return _length(set._inner);
2092     }
2093 
2094     /**
2095      * @dev Returns the value stored at position `index` in the set. O(1).
2096      *
2097      * Note that there are no guarantees on the ordering of values inside the
2098      * array, and it may change when more values are added or removed.
2099      *
2100      * Requirements:
2101      *
2102      * - `index` must be strictly less than {length}.
2103      */
2104     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
2105         return _at(set._inner, index);
2106     }
2107 
2108     /**
2109      * @dev Return the entire set in an array
2110      *
2111      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2112      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2113      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2114      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2115      */
2116     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
2117         return _values(set._inner);
2118     }
2119 
2120     // AddressSet
2121 
2122     struct AddressSet {
2123         Set _inner;
2124     }
2125 
2126     /**
2127      * @dev Add a value to a set. O(1).
2128      *
2129      * Returns true if the value was added to the set, that is if it was not
2130      * already present.
2131      */
2132     function add(AddressSet storage set, address value) internal returns (bool) {
2133         return _add(set._inner, bytes32(uint256(uint160(value))));
2134     }
2135 
2136     /**
2137      * @dev Removes a value from a set. O(1).
2138      *
2139      * Returns true if the value was removed from the set, that is if it was
2140      * present.
2141      */
2142     function remove(AddressSet storage set, address value) internal returns (bool) {
2143         return _remove(set._inner, bytes32(uint256(uint160(value))));
2144     }
2145 
2146     /**
2147      * @dev Returns true if the value is in the set. O(1).
2148      */
2149     function contains(AddressSet storage set, address value) internal view returns (bool) {
2150         return _contains(set._inner, bytes32(uint256(uint160(value))));
2151     }
2152 
2153     /**
2154      * @dev Returns the number of values in the set. O(1).
2155      */
2156     function length(AddressSet storage set) internal view returns (uint256) {
2157         return _length(set._inner);
2158     }
2159 
2160     /**
2161      * @dev Returns the value stored at position `index` in the set. O(1).
2162      *
2163      * Note that there are no guarantees on the ordering of values inside the
2164      * array, and it may change when more values are added or removed.
2165      *
2166      * Requirements:
2167      *
2168      * - `index` must be strictly less than {length}.
2169      */
2170     function at(AddressSet storage set, uint256 index) internal view returns (address) {
2171         return address(uint160(uint256(_at(set._inner, index))));
2172     }
2173 
2174     /**
2175      * @dev Return the entire set in an array
2176      *
2177      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2178      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2179      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2180      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2181      */
2182     function values(AddressSet storage set) internal view returns (address[] memory) {
2183         bytes32[] memory store = _values(set._inner);
2184         address[] memory result;
2185 
2186         assembly {
2187             result := store
2188         }
2189 
2190         return result;
2191     }
2192 
2193     // UintSet
2194 
2195     struct UintSet {
2196         Set _inner;
2197     }
2198 
2199     /**
2200      * @dev Add a value to a set. O(1).
2201      *
2202      * Returns true if the value was added to the set, that is if it was not
2203      * already present.
2204      */
2205     function add(UintSet storage set, uint256 value) internal returns (bool) {
2206         return _add(set._inner, bytes32(value));
2207     }
2208 
2209     /**
2210      * @dev Removes a value from a set. O(1).
2211      *
2212      * Returns true if the value was removed from the set, that is if it was
2213      * present.
2214      */
2215     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2216         return _remove(set._inner, bytes32(value));
2217     }
2218 
2219     /**
2220      * @dev Returns true if the value is in the set. O(1).
2221      */
2222     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2223         return _contains(set._inner, bytes32(value));
2224     }
2225 
2226     /**
2227      * @dev Returns the number of values on the set. O(1).
2228      */
2229     function length(UintSet storage set) internal view returns (uint256) {
2230         return _length(set._inner);
2231     }
2232 
2233     /**
2234      * @dev Returns the value stored at position `index` in the set. O(1).
2235      *
2236      * Note that there are no guarantees on the ordering of values inside the
2237      * array, and it may change when more values are added or removed.
2238      *
2239      * Requirements:
2240      *
2241      * - `index` must be strictly less than {length}.
2242      */
2243     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2244         return uint256(_at(set._inner, index));
2245     }
2246 
2247     /**
2248      * @dev Return the entire set in an array
2249      *
2250      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2251      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2252      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2253      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2254      */
2255     function values(UintSet storage set) internal view returns (uint256[] memory) {
2256         bytes32[] memory store = _values(set._inner);
2257         uint256[] memory result;
2258 
2259         assembly {
2260             result := store
2261         }
2262 
2263         return result;
2264     }
2265 }
2266 
2267 // File openzeppelin-solidity/contracts/security/ReentrancyGuard.sol@v4.4.1
2268 
2269 
2270 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
2271 
2272 pragma solidity ^0.8.0;
2273 
2274 /**
2275  * @dev Contract module that helps prevent reentrant calls to a function.
2276  *
2277  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2278  * available, which can be applied to functions to make sure there are no nested
2279  * (reentrant) calls to them.
2280  *
2281  * Note that because there is a single `nonReentrant` guard, functions marked as
2282  * `nonReentrant` may not call one another. This can be worked around by making
2283  * those functions `private`, and then adding `external` `nonReentrant` entry
2284  * points to them.
2285  *
2286  * TIP: If you would like to learn more about reentrancy and alternative ways
2287  * to protect against it, check out our blog post
2288  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2289  */
2290 abstract contract ReentrancyGuard {
2291     // Booleans are more expensive than uint256 or any type that takes up a full
2292     // word because each write operation emits an extra SLOAD to first read the
2293     // slot's contents, replace the bits taken up by the boolean, and then write
2294     // back. This is the compiler's defense against contract upgrades and
2295     // pointer aliasing, and it cannot be disabled.
2296 
2297     // The values being non-zero value makes deployment a bit more expensive,
2298     // but in exchange the refund on every call to nonReentrant will be lower in
2299     // amount. Since refunds are capped to a percentage of the total
2300     // transaction's gas, it is best to keep them low in cases like this one, to
2301     // increase the likelihood of the full refund coming into effect.
2302     uint256 private constant _NOT_ENTERED = 1;
2303     uint256 private constant _ENTERED = 2;
2304 
2305     uint256 private _status;
2306 
2307     constructor() {
2308         _status = _NOT_ENTERED;
2309     }
2310 
2311     /**
2312      * @dev Prevents a contract from calling itself, directly or indirectly.
2313      * Calling a `nonReentrant` function from another `nonReentrant`
2314      * function is not supported. It is possible to prevent this from happening
2315      * by making the `nonReentrant` function external, and making it call a
2316      * `private` function that does the actual work.
2317      */
2318     modifier nonReentrant() {
2319         // On the first call to nonReentrant, _notEntered will be true
2320         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2321 
2322         // Any calls to nonReentrant after this point will fail
2323         _status = _ENTERED;
2324 
2325         _;
2326 
2327         // By storing the original value once again, a refund is triggered (see
2328         // https://eips.ethereum.org/EIPS/eip-2200)
2329         _status = _NOT_ENTERED;
2330     }
2331 }
2332 
2333 // File openzeppelin-solidity/contracts/security/Pausable.sol@v4.4.1
2334 
2335 
2336 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
2337 
2338 pragma solidity ^0.8.0;
2339 
2340 /**
2341  * @dev Contract module which allows children to implement an emergency stop
2342  * mechanism that can be triggered by an authorized account.
2343  *
2344  * This module is used through inheritance. It will make available the
2345  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2346  * the functions of your contract. Note that they will not be pausable by
2347  * simply including this module, only once the modifiers are put in place.
2348  */
2349 abstract contract Pausable is Context {
2350     /**
2351      * @dev Emitted when the pause is triggered by `account`.
2352      */
2353     event Paused(address account);
2354 
2355     /**
2356      * @dev Emitted when the pause is lifted by `account`.
2357      */
2358     event Unpaused(address account);
2359 
2360     bool private _paused;
2361 
2362     /**
2363      * @dev Initializes the contract in unpaused state.
2364      */
2365     constructor() {
2366         _paused = false;
2367     }
2368 
2369     /**
2370      * @dev Returns true if the contract is paused, and false otherwise.
2371      */
2372     function paused() public view virtual returns (bool) {
2373         return _paused;
2374     }
2375 
2376     /**
2377      * @dev Modifier to make a function callable only when the contract is not paused.
2378      *
2379      * Requirements:
2380      *
2381      * - The contract must not be paused.
2382      */
2383     modifier whenNotPaused() {
2384         require(!paused(), "Pausable: paused");
2385         _;
2386     }
2387 
2388     /**
2389      * @dev Modifier to make a function callable only when the contract is paused.
2390      *
2391      * Requirements:
2392      *
2393      * - The contract must be paused.
2394      */
2395     modifier whenPaused() {
2396         require(paused(), "Pausable: not paused");
2397         _;
2398     }
2399 
2400     /**
2401      * @dev Triggers stopped state.
2402      *
2403      * Requirements:
2404      *
2405      * - The contract must not be paused.
2406      */
2407     function _pause() internal virtual whenNotPaused {
2408         _paused = true;
2409         emit Paused(_msgSender());
2410     }
2411 
2412     /**
2413      * @dev Returns to normal state.
2414      *
2415      * Requirements:
2416      *
2417      * - The contract must be paused.
2418      */
2419     function _unpause() internal virtual whenPaused {
2420         _paused = false;
2421         emit Unpaused(_msgSender());
2422     }
2423 }
2424 
2425 
2426 
2427 pragma solidity ^0.8.0;
2428 
2429 contract KOBOLNFT is ReentrancyGuard, Pausable, ERC721Enumerable, Ownable, IERC721Receiver {
2430     using Counters for Counters.Counter;
2431     using Strings for uint256;
2432     using SafeMath for uint256;
2433     using EnumerableSet for EnumerableSet.UintSet;
2434     using SafeERC20 for IERC20;
2435 
2436     /* ------------------------ NFT Minting ------------------------- */
2437     uint256 public MAX_SUPPLY = 6000;
2438     uint256 public PRICE = 3 ether;
2439 
2440     string private _tokenBaseURI = "";
2441     
2442     Counters.Counter internal _publicCounter;
2443 
2444     /* ------------------------ NFT Staking ------------------------- */
2445     bool public _enableHarvest = false;
2446 
2447     bytes32 private HASH_ROOT;
2448 
2449     address public REWARD_TOKEN_ADDRESS;
2450 
2451     uint256 public TOKEN_REWARD_PER_DAY_MYSTIC = 2904.30321 ether;
2452     uint256 public TOKEN_REWARD_PER_DAY_LEGUNDARY = 1936.20214 ether;
2453     uint256 public TOKEN_REWARD_PER_DAY_EPIC = 193.62021 ether;
2454     uint256 public TOKEN_REWARD_PER_DAY_RARE = 48.40505 ether;
2455     
2456     struct UserInfo {
2457         uint256 rewards;
2458         uint256 lastUpdated;
2459     }
2460 
2461     mapping(address => EnumerableSet.UintSet) private Mystic_Blanaces;
2462     mapping(address => EnumerableSet.UintSet) private Legundary_Blanaces;
2463     mapping(address => EnumerableSet.UintSet) private Epic_Blanaces;
2464     mapping(address => EnumerableSet.UintSet) private Rare_Blanaces;
2465 
2466     mapping(address => UserInfo) public userInfo;
2467 
2468     address[] public stakerList;
2469 
2470     /* --------------------------------------------------------------------------------- */
2471     
2472     constructor() ERC721("KOBOLD GENESIS", "KOBOLNFT") {
2473         _publicCounter.increment(); // Start from 1 : TokenID
2474     }
2475 
2476     function setMintPrice(uint256 mintPrice) external onlyOwner {
2477         PRICE = mintPrice;
2478     }
2479 
2480     function setMaxLimit(uint256 maxLimit) external onlyOwner {
2481         MAX_SUPPLY = maxLimit;
2482     }
2483 
2484     function setBaseURI(string memory baseURI) external onlyOwner {
2485         _tokenBaseURI = baseURI;
2486     }
2487 
2488     function airdrop(address[] memory airdropAddress, uint256 numberOfTokens) external onlyOwner {
2489         for (uint256 k = 0; k < airdropAddress.length; k++) {
2490             for (uint256 i = 0; i < numberOfTokens; i++) {
2491                 uint256 tokenId = _publicCounter.current();
2492 
2493                 if (_publicCounter.current() < MAX_SUPPLY) {
2494                     _publicCounter.increment();
2495                     if (!_exists(tokenId)) {
2496                         _safeMint(airdropAddress[k], tokenId);
2497                     }
2498                 }
2499             }
2500         }
2501     }
2502 
2503     function purchase(uint256 numberOfTokens) external payable {
2504         require(_publicCounter.current() + numberOfTokens <= MAX_SUPPLY,"Purchase would exceed MAX_SUPPLY");
2505 
2506         if (_msgSender() != owner()) {
2507             require(PRICE * numberOfTokens <= msg.value,"ETH amount is not sufficient");
2508         }
2509 
2510         for (uint256 i = 0; i < numberOfTokens; i++) {
2511             uint256 tokenId = _publicCounter.current();
2512 
2513             if (_publicCounter.current() < MAX_SUPPLY) {
2514                 _publicCounter.increment();
2515                 if (!_exists(tokenId)) {
2516                     _safeMint(_msgSender(), tokenId);
2517                 }
2518             }
2519         }
2520     }
2521 
2522     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
2523         require(_exists(tokenId), "Token does not exist");
2524         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString(), ".json"));
2525     }
2526 
2527     function withdraw() external onlyOwner {
2528         uint256 balance = address(this).balance;
2529         payable(_msgSender()).transfer(balance);
2530     }
2531 
2532     function withdrawToken() external onlyOwner {
2533         IERC20(REWARD_TOKEN_ADDRESS).safeTransfer(_msgSender(), IERC20(REWARD_TOKEN_ADDRESS).balanceOf(address(this)));
2534     }
2535 
2536     function userHoldNFT(address _owner) public view returns(uint256[] memory){
2537         uint256 tokenCount = balanceOf(_owner);
2538         if (tokenCount == 0) {
2539             return new uint256[](0);
2540         } else {
2541             uint256[] memory result = new uint256[](tokenCount);
2542             uint256 index;
2543             for (index = 0; index < tokenCount; index++) {
2544                 result[index] = tokenOfOwnerByIndex(_owner, index);
2545             }
2546             return result;
2547         }
2548     }
2549 
2550     /* --------------------------------------------------------------------- */
2551     function setTokenRewardAddress(address _tokenAddress) public onlyOwner {
2552         REWARD_TOKEN_ADDRESS = _tokenAddress;
2553     }
2554 
2555     function setTokenRewardAmountPerDay(uint256 mysticReward, uint256 legundaryReward, uint256 epicReward, uint256 rareReward) public onlyOwner {
2556         TOKEN_REWARD_PER_DAY_MYSTIC = mysticReward;
2557         TOKEN_REWARD_PER_DAY_LEGUNDARY = legundaryReward;
2558         TOKEN_REWARD_PER_DAY_EPIC = epicReward;
2559         TOKEN_REWARD_PER_DAY_RARE = rareReward;
2560     }
2561 
2562     function setHashRoot(bytes32 _root) public onlyOwner {
2563         HASH_ROOT = _root;
2564     }
2565     // Verify that a given leaf is in the tree.
2566     function isHashValid(bytes32 _leafNode, bytes32[] memory _proof) public view returns (bool) {
2567         return MerkleProof.verify(_proof, HASH_ROOT, _leafNode);
2568     }
2569 
2570     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
2571     function toLeaf(uint256 tokenID, uint256 index, uint256 grade) public pure returns (bytes32) {
2572         return keccak256(abi.encodePacked(index, tokenID, grade));
2573     }
2574 
2575     function addStakerList(address _user) internal{
2576         for (uint256 i = 0; i < stakerList.length; i++) {
2577             if (stakerList[i] == _user)
2578                 return;
2579         }
2580         stakerList.push(_user);
2581     }
2582 
2583     function userStakeInfo(address _owner) external view returns(UserInfo memory){
2584          return userInfo[_owner];
2585     }
2586     
2587     function userStakedNFT_Mystic(address _owner) public view returns(uint256[] memory){
2588         uint256 tokenCount = Mystic_Blanaces[_owner].length();
2589         if (tokenCount == 0) {
2590             return new uint256[](0);
2591         } else {
2592             uint256[] memory result = new uint256[](tokenCount);
2593             uint256 index;
2594             for (index = 0; index < tokenCount; index++) {
2595                 result[index] = Mystic_Blanaces[_owner].at(index);
2596             }
2597             return result;
2598         }
2599     }
2600 
2601     function userStakedNFT_Legundary(address _owner) public view returns(uint256[] memory){
2602         uint256 tokenCount = Legundary_Blanaces[_owner].length();
2603         if (tokenCount == 0) {
2604             return new uint256[](0);
2605         } else {
2606             uint256[] memory result = new uint256[](tokenCount);
2607             uint256 index;
2608             for (index = 0; index < tokenCount; index++) {
2609                 result[index] = Legundary_Blanaces[_owner].at(index);
2610             }
2611             return result;
2612         }
2613     }
2614 
2615     function userStakedNFT_Epic(address _owner) public view returns(uint256[] memory){
2616         uint256 tokenCount = Epic_Blanaces[_owner].length();
2617         if (tokenCount == 0) {
2618             return new uint256[](0);
2619         } else {
2620             uint256[] memory result = new uint256[](tokenCount);
2621             uint256 index;
2622             for (index = 0; index < tokenCount; index++) {
2623                 result[index] = Epic_Blanaces[_owner].at(index);
2624             }
2625             return result;
2626         }
2627     }
2628 
2629     function userStakedNFT_Rare(address _owner) public view returns(uint256[] memory){
2630         uint256 tokenCount = Rare_Blanaces[_owner].length();
2631         if (tokenCount == 0) {
2632             return new uint256[](0);
2633         } else {
2634             uint256[] memory result = new uint256[](tokenCount);
2635             uint256 index;
2636             for (index = 0; index < tokenCount; index++) {
2637                 result[index] = Rare_Blanaces[_owner].at(index);
2638             }
2639             return result;
2640         }
2641     }
2642 
2643     function isStaked_Mystic( address account ,uint256 tokenId) public view returns (bool) {
2644         return Mystic_Blanaces[account].contains(tokenId);
2645     }
2646     function isStaked_Legundary( address account ,uint256 tokenId) public view returns (bool) {
2647         return Legundary_Blanaces[account].contains(tokenId);
2648     }
2649     function isStaked_Epic( address account ,uint256 tokenId) public view returns (bool) {
2650         return Epic_Blanaces[account].contains(tokenId);
2651     }
2652     function isStaked_Rare( address account ,uint256 tokenId) public view returns (bool) {
2653         return Rare_Blanaces[account].contains(tokenId);
2654     }
2655 
2656     function earned(address account) public view returns (uint256) {
2657         uint256 blockTime = block.timestamp;
2658 
2659         UserInfo memory user = userInfo[account];
2660 
2661         uint256 amount_mystic = blockTime.sub(user.lastUpdated).mul(Mystic_Blanaces[account].length()).mul(TOKEN_REWARD_PER_DAY_MYSTIC).div(1 days);
2662         uint256 amount_legundary = blockTime.sub(user.lastUpdated).mul(Legundary_Blanaces[account].length()).mul(TOKEN_REWARD_PER_DAY_LEGUNDARY).div(1 days);
2663         uint256 amount_epic = blockTime.sub(user.lastUpdated).mul(Epic_Blanaces[account].length()).mul(TOKEN_REWARD_PER_DAY_EPIC).div(1 days);
2664         uint256 amount_rare = blockTime.sub(user.lastUpdated).mul(Rare_Blanaces[account].length()).mul(TOKEN_REWARD_PER_DAY_RARE).div(1 days);
2665 
2666         return user.rewards.add(amount_mystic).add(amount_legundary).add(amount_epic).add(amount_rare);
2667     }
2668 
2669     function totalEarned() public view returns (uint256) {
2670         uint256 totalEarning = 0;
2671         for (uint256 i = 0; i < stakerList.length; i++) {
2672             totalEarning += earned(stakerList[i]);
2673         }
2674         return totalEarning;
2675     }
2676 
2677     function totalStakedCount_Mystic() public view returns (uint256) {
2678         uint256 totalCount = 0;
2679         for (uint256 i = 0; i < stakerList.length; i++) {
2680             totalCount += Mystic_Blanaces[stakerList[i]].length();
2681         }
2682         return totalCount;
2683     }
2684 
2685     function totalStakedCount_Legundary() public view returns (uint256) {
2686         uint256 totalCount = 0;
2687         for (uint256 i = 0; i < stakerList.length; i++) {
2688             totalCount += Legundary_Blanaces[stakerList[i]].length();
2689         }
2690         return totalCount;
2691     }
2692 
2693     function totalStakedCount_Epic() public view returns (uint256) {
2694         uint256 totalCount = 0;
2695         for (uint256 i = 0; i < stakerList.length; i++) {
2696             totalCount += Epic_Blanaces[stakerList[i]].length();
2697         }
2698         return totalCount;
2699     }
2700 
2701     function totalStakedCount_Rare() public view returns (uint256) {
2702         uint256 totalCount = 0;
2703         for (uint256 i = 0; i < stakerList.length; i++) {
2704             totalCount += Rare_Blanaces[stakerList[i]].length();
2705         }
2706         return totalCount;
2707     }
2708 
2709     function totalStakedMembers_Mystic() public view returns (uint256) {
2710         uint256 totalMembers = 0;
2711         for (uint256 i = 0; i < stakerList.length; i++) {
2712             if (Mystic_Blanaces[stakerList[i]].length() > 0) totalMembers += 1;
2713         }
2714         return totalMembers;
2715     }
2716 
2717     function totalStakedMembers_Legundary() public view returns (uint256) {
2718         uint256 totalMembers = 0;
2719         for (uint256 i = 0; i < stakerList.length; i++) {
2720             if (Legundary_Blanaces[stakerList[i]].length() > 0) totalMembers += 1;
2721         }
2722         return totalMembers;
2723     }
2724 
2725     function totalStakedMembers_Epic() public view returns (uint256) {
2726         uint256 totalMembers = 0;
2727         for (uint256 i = 0; i < stakerList.length; i++) {
2728             if (Epic_Blanaces[stakerList[i]].length() > 0) totalMembers += 1;
2729         }
2730         return totalMembers;
2731     }
2732 
2733     function totalStakedMembers_Rare() public view returns (uint256) {
2734         uint256 totalMembers = 0;
2735         for (uint256 i = 0; i < stakerList.length; i++) {
2736             if (Rare_Blanaces[stakerList[i]].length() > 0) totalMembers += 1;
2737         }
2738         return totalMembers;
2739     }
2740 
2741     
2742     function stake( uint256[] calldata _tokenIDList, uint256[] calldata _indexList, uint256[] calldata _gradeList, bytes32[][] calldata _proofList) public nonReentrant whenNotPaused {
2743         require(isApprovedForAll(_msgSender(),address(this)),"Not approve nft to staker address");
2744 
2745         addStakerList(_msgSender());
2746 
2747         UserInfo storage user = userInfo[_msgSender()];
2748         user.rewards = earned(_msgSender());
2749         user.lastUpdated = block.timestamp;
2750 
2751         for (uint256 i = 0; i < _tokenIDList.length; i++) {
2752             require (isHashValid(toLeaf(_tokenIDList[i], _indexList[i], _gradeList[i]), _proofList[i]), "Invalid Hash");
2753             
2754             safeTransferFrom(_msgSender(), address(this), _tokenIDList[i]);
2755             
2756             if (_gradeList[i] == 0) {
2757 
2758                 Mystic_Blanaces[_msgSender()].add(_tokenIDList[i]);
2759             
2760             } else if (_gradeList[i] == 1) {
2761                 
2762                 Legundary_Blanaces[_msgSender()].add(_tokenIDList[i]);
2763             
2764             } else if (_gradeList[i] == 2) {
2765                 
2766                 Epic_Blanaces[_msgSender()].add(_tokenIDList[i]);
2767             
2768             } else if (_gradeList[i] == 3) {
2769                 
2770                 Rare_Blanaces[_msgSender()].add(_tokenIDList[i]);
2771             
2772             }
2773         }
2774     }
2775 
2776     function unstake( uint256[] memory  tokenIdList) public nonReentrant {
2777         UserInfo storage user = userInfo[_msgSender()];
2778         user.rewards = earned(_msgSender());
2779         user.lastUpdated = block.timestamp;
2780 
2781         for (uint256 i = 0; i < tokenIdList.length; i++) {
2782 
2783             require(
2784                 isStaked_Mystic(_msgSender(), tokenIdList[i]) || 
2785                 isStaked_Legundary(_msgSender(), tokenIdList[i]) || 
2786                 isStaked_Epic(_msgSender(), tokenIdList[i]) || 
2787                 isStaked_Rare(_msgSender(), tokenIdList[i]), "Not staked this nft");        
2788 
2789             _safeTransfer(address(this) , _msgSender(), tokenIdList[i], "");
2790 
2791             if (isStaked_Mystic(_msgSender(), tokenIdList[i])) {
2792                 
2793                 Mystic_Blanaces[_msgSender()].remove(tokenIdList[i]);
2794             
2795             } else if (isStaked_Legundary(_msgSender(), tokenIdList[i])) {
2796                 
2797                 Legundary_Blanaces[_msgSender()].remove(tokenIdList[i]);
2798             
2799             } else if (isStaked_Epic(_msgSender(), tokenIdList[i])) {
2800                 
2801                 Epic_Blanaces[_msgSender()].remove(tokenIdList[i]);
2802             
2803             } else if (isStaked_Rare(_msgSender(), tokenIdList[i])) {
2804                 
2805                 Rare_Blanaces[_msgSender()].remove(tokenIdList[i]);
2806             
2807             }
2808         }
2809     }
2810 
2811     function harvest() public nonReentrant {
2812         require(_enableHarvest == true, "Harvest is not activated");
2813         
2814         UserInfo storage user = userInfo[_msgSender()];
2815         user.rewards = earned(_msgSender());
2816         user.lastUpdated = block.timestamp;
2817 
2818         require(IERC20(REWARD_TOKEN_ADDRESS).balanceOf(address(this)) >= user.rewards,"Reward token amount is small");
2819 
2820         if (user.rewards > 0) {
2821             IERC20(REWARD_TOKEN_ADDRESS).safeTransfer(_msgSender(), user.rewards);
2822         }
2823 
2824         user.rewards = 0;
2825     }
2826 
2827     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
2828         return this.onERC721Received.selector;
2829     }
2830 
2831     receive() external payable {}
2832 }