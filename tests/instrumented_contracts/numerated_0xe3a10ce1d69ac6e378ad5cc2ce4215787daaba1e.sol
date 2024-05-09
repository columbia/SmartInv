1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
6 // CAUTION
7 // This version of SafeMath should only be used with Solidity 0.8 or later,
8 // because it relies on the compiler's built in overflow checks.
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (b > a) return (false, 0);
37             return (true, a - b);
38         }
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49             // benefit is lost if 'b' is also tested.
50             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51             if (a == 0) return (true, 0);
52             uint256 c = a * b;
53             if (c / a != b) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a / b);
67         }
68     }
69 
70     /**
71      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a % b);
79         }
80     }
81 
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a + b;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a * b;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator.
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * reverting when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a % b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * CAUTION: This function is deprecated because it requires allocating memory for the error
159      * message unnecessarily. For custom revert reasons use {trySub}.
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172         unchecked {
173             require(b <= a, errorMessage);
174             return a - b;
175         }
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         unchecked {
196             require(b > 0, errorMessage);
197             return a / b;
198         }
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting with custom message when dividing by zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryMod}.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         unchecked {
222             require(b > 0, errorMessage);
223             return a % b;
224         }
225     }
226 }
227 
228 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
229 /**
230  * @dev Interface of the ERC165 standard, as defined in the
231  * https://eips.ethereum.org/EIPS/eip-165[EIP].
232  *
233  * Implementers can declare support of contract interfaces, which can then be
234  * queried by others ({ERC165Checker}).
235  *
236  * For an implementation, see {ERC165}.
237  */
238 interface IERC165 {
239     /**
240      * @dev Returns true if this contract implements the interface defined by
241      * `interfaceId`. See the corresponding
242      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
243      * to learn more about how these ids are created.
244      *
245      * This function call must use less than 30 000 gas.
246      */
247     function supportsInterface(bytes4 interfaceId) external view returns (bool);
248 }
249 
250 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
251 /**
252  * @dev Required interface of an ERC721 compliant contract.
253  */
254 interface IERC721 is IERC165 {
255     /**
256      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
259 
260     /**
261      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
262      */
263     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
264 
265     /**
266      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
267      */
268     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
269 
270     /**
271      * @dev Returns the number of tokens in ``owner``'s account.
272      */
273     function balanceOf(address owner) external view returns (uint256 balance);
274 
275     /**
276      * @dev Returns the owner of the `tokenId` token.
277      *
278      * Requirements:
279      *
280      * - `tokenId` must exist.
281      */
282     function ownerOf(uint256 tokenId) external view returns (address owner);
283 
284     /**
285      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
286      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
287      *
288      * Requirements:
289      *
290      * - `from` cannot be the zero address.
291      * - `to` cannot be the zero address.
292      * - `tokenId` token must exist and be owned by `from`.
293      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
294      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
295      *
296      * Emits a {Transfer} event.
297      */
298     function safeTransferFrom(
299         address from,
300         address to,
301         uint256 tokenId
302     ) external;
303 
304     /**
305      * @dev Transfers `tokenId` token from `from` to `to`.
306      *
307      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
308      *
309      * Requirements:
310      *
311      * - `from` cannot be the zero address.
312      * - `to` cannot be the zero address.
313      * - `tokenId` token must be owned by `from`.
314      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transferFrom(
319         address from,
320         address to,
321         uint256 tokenId
322     ) external;
323 
324     /**
325      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
326      * The approval is cleared when the token is transferred.
327      *
328      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
329      *
330      * Requirements:
331      *
332      * - The caller must own the token or be an approved operator.
333      * - `tokenId` must exist.
334      *
335      * Emits an {Approval} event.
336      */
337     function approve(address to, uint256 tokenId) external;
338 
339     /**
340      * @dev Returns the account approved for `tokenId` token.
341      *
342      * Requirements:
343      *
344      * - `tokenId` must exist.
345      */
346     function getApproved(uint256 tokenId) external view returns (address operator);
347 
348     /**
349      * @dev Approve or remove `operator` as an operator for the caller.
350      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
351      *
352      * Requirements:
353      *
354      * - The `operator` cannot be the caller.
355      *
356      * Emits an {ApprovalForAll} event.
357      */
358     function setApprovalForAll(address operator, bool _approved) external;
359 
360     /**
361      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
362      *
363      * See {setApprovalForAll}
364      */
365     function isApprovedForAll(address owner, address operator) external view returns (bool);
366 
367     /**
368      * @dev Safely transfers `tokenId` token from `from` to `to`.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must exist and be owned by `from`.
375      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
376      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
377      *
378      * Emits a {Transfer} event.
379      */
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 tokenId,
384         bytes calldata data
385     ) external;
386 }
387 
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
389 /**
390  * @title ERC721 token receiver interface
391  * @dev Interface for any contract that wants to support safeTransfers
392  * from ERC721 asset contracts.
393  */
394 interface IERC721Receiver {
395     /**
396      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
397      * by `operator` from `from`, this function is called.
398      *
399      * It must return its Solidity selector to confirm the token transfer.
400      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
401      *
402      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
403      */
404     function onERC721Received(
405         address operator,
406         address from,
407         uint256 tokenId,
408         bytes calldata data
409     ) external returns (bytes4);
410 }
411 
412 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
413 /**
414  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
415  * @dev See https://eips.ethereum.org/EIPS/eip-721
416  */
417 interface IERC721Metadata is IERC721 {
418     /**
419      * @dev Returns the token collection name.
420      */
421     function name() external view returns (string memory);
422 
423     /**
424      * @dev Returns the token collection symbol.
425      */
426     function symbol() external view returns (string memory);
427 
428     /**
429      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
430      */
431     function tokenURI(uint256 tokenId) external view returns (string memory);
432 }
433 
434 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
435 /**
436  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
437  * @dev See https://eips.ethereum.org/EIPS/eip-721
438  */
439 interface IERC721Enumerable is IERC721 {
440     /**
441      * @dev Returns the total amount of tokens stored by the contract.
442      */
443     function totalSupply() external view returns (uint256);
444 
445     /**
446      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
447      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
448      */
449     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
450 
451     /**
452      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
453      * Use along with {totalSupply} to enumerate all tokens.
454      */
455     function tokenByIndex(uint256 index) external view returns (uint256);
456 }
457 
458 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
459 /**
460  * @dev Collection of functions related to the address type
461  */
462 library Address {
463     /**
464      * @dev Returns true if `account` is a contract.
465      *
466      * [IMPORTANT]
467      * ====
468      * It is unsafe to assume that an address for which this function returns
469      * false is an externally-owned account (EOA) and not a contract.
470      *
471      * Among others, `isContract` will return false for the following
472      * types of addresses:
473      *
474      *  - an externally-owned account
475      *  - a contract in construction
476      *  - an address where a contract will be created
477      *  - an address where a contract lived, but was destroyed
478      * ====
479      *
480      * [IMPORTANT]
481      * ====
482      * You shouldn't rely on `isContract` to protect against flash loan attacks!
483      *
484      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
485      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
486      * constructor.
487      * ====
488      */
489     function isContract(address account) internal view returns (bool) {
490         // This method relies on extcodesize/address.code.length, which returns 0
491         // for contracts in construction, since the code is only stored at the end
492         // of the constructor execution.
493 
494         return account.code.length > 0;
495     }
496 
497     /**
498      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
499      * `recipient`, forwarding all available gas and reverting on errors.
500      *
501      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
502      * of certain opcodes, possibly making contracts go over the 2300 gas limit
503      * imposed by `transfer`, making them unable to receive funds via
504      * `transfer`. {sendValue} removes this limitation.
505      *
506      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
507      *
508      * IMPORTANT: because control is transferred to `recipient`, care must be
509      * taken to not create reentrancy vulnerabilities. Consider using
510      * {ReentrancyGuard} or the
511      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
512      */
513     function sendValue(address payable recipient, uint256 amount) internal {
514         require(address(this).balance >= amount, "Address: insufficient balance");
515 
516         (bool success, ) = recipient.call{value: amount}("");
517         require(success, "Address: unable to send value, recipient may have reverted");
518     }
519 
520     /**
521      * @dev Performs a Solidity function call using a low level `call`. A
522      * plain `call` is an unsafe replacement for a function call: use this
523      * function instead.
524      *
525      * If `target` reverts with a revert reason, it is bubbled up by this
526      * function (like regular Solidity function calls).
527      *
528      * Returns the raw returned data. To convert to the expected return value,
529      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
530      *
531      * Requirements:
532      *
533      * - `target` must be a contract.
534      * - calling `target` with `data` must not revert.
535      *
536      * _Available since v3.1._
537      */
538     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
539         return functionCall(target, data, "Address: low-level call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
544      * `errorMessage` as a fallback revert reason when `target` reverts.
545      *
546      * _Available since v3.1._
547      */
548     function functionCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, 0, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but also transferring `value` wei to `target`.
559      *
560      * Requirements:
561      *
562      * - the calling contract must have an ETH balance of at least `value`.
563      * - the called Solidity function must be `payable`.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(
568         address target,
569         bytes memory data,
570         uint256 value
571     ) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
577      * with `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(address(this).balance >= value, "Address: insufficient balance for call");
588         require(isContract(target), "Address: call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.call{value: value}(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but performing a static call.
597      *
598      * _Available since v3.3._
599      */
600     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
601         return functionStaticCall(target, data, "Address: low-level static call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
606      * but performing a static call.
607      *
608      * _Available since v3.3._
609      */
610     function functionStaticCall(
611         address target,
612         bytes memory data,
613         string memory errorMessage
614     ) internal view returns (bytes memory) {
615         require(isContract(target), "Address: static call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.staticcall(data);
618         return verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a delegate call.
624      *
625      * _Available since v3.4._
626      */
627     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
628         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
633      * but performing a delegate call.
634      *
635      * _Available since v3.4._
636      */
637     function functionDelegateCall(
638         address target,
639         bytes memory data,
640         string memory errorMessage
641     ) internal returns (bytes memory) {
642         require(isContract(target), "Address: delegate call to non-contract");
643 
644         (bool success, bytes memory returndata) = target.delegatecall(data);
645         return verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     /**
649      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
650      * revert reason using the provided one.
651      *
652      * _Available since v4.3._
653      */
654     function verifyCallResult(
655         bool success,
656         bytes memory returndata,
657         string memory errorMessage
658     ) internal pure returns (bytes memory) {
659         if (success) {
660             return returndata;
661         } else {
662             // Look for revert reason and bubble it up if present
663             if (returndata.length > 0) {
664                 // The easiest way to bubble the revert reason is using memory via assembly
665 
666                 assembly {
667                     let returndata_size := mload(returndata)
668                     revert(add(32, returndata), returndata_size)
669                 }
670             } else {
671                 revert(errorMessage);
672             }
673         }
674     }
675 }
676 
677 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
678 /**
679  * @dev Provides information about the current execution context, including the
680  * sender of the transaction and its data. While these are generally available
681  * via msg.sender and msg.data, they should not be accessed in such a direct
682  * manner, since when dealing with meta-transactions the account sending and
683  * paying for execution may not be the actual sender (as far as an application
684  * is concerned).
685  *
686  * This contract is only required for intermediate, library-like contracts.
687  */
688 abstract contract Context {
689     function _msgSender() internal view virtual returns (address) {
690         return msg.sender;
691     }
692 
693     function _msgData() internal view virtual returns (bytes calldata) {
694         return msg.data;
695     }
696 }
697 
698 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
699 /**
700  * @dev String operations.
701  */
702 library Strings {
703     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
704 
705     /**
706      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
707      */
708     function toString(uint256 value) internal pure returns (string memory) {
709         // Inspired by OraclizeAPI's implementation - MIT licence
710         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
711 
712         if (value == 0) {
713             return "0";
714         }
715         uint256 temp = value;
716         uint256 digits;
717         while (temp != 0) {
718             digits++;
719             temp /= 10;
720         }
721         bytes memory buffer = new bytes(digits);
722         while (value != 0) {
723             digits -= 1;
724             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
725             value /= 10;
726         }
727         return string(buffer);
728     }
729 
730     /**
731      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
732      */
733     function toHexString(uint256 value) internal pure returns (string memory) {
734         if (value == 0) {
735             return "0x00";
736         }
737         uint256 temp = value;
738         uint256 length = 0;
739         while (temp != 0) {
740             length++;
741             temp >>= 8;
742         }
743         return toHexString(value, length);
744     }
745 
746     /**
747      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
748      */
749     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
750         bytes memory buffer = new bytes(2 * length + 2);
751         buffer[0] = "0";
752         buffer[1] = "x";
753         for (uint256 i = 2 * length + 1; i > 1; --i) {
754             buffer[i] = _HEX_SYMBOLS[value & 0xf];
755             value >>= 4;
756         }
757         require(value == 0, "Strings: hex length insufficient");
758         return string(buffer);
759     }
760 }
761 
762 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
763 /**
764  * @dev Implementation of the {IERC165} interface.
765  *
766  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
767  * for the additional interface id that will be supported. For example:
768  *
769  * ```solidity
770  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
772  * }
773  * ```
774  *
775  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
776  */
777 abstract contract ERC165 is IERC165 {
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
782         return interfaceId == type(IERC165).interfaceId;
783     }
784 }
785 
786 error ApprovalCallerNotOwnerNorApproved ();
787 
788 error ApprovalQueryForNonexistentToken ();
789 
790 error ApproveToCaller ();
791 
792 error ApprovalToCurrentOwner ();
793 
794 error BalanceQueryForZeroAddress ();
795 
796 error MintedQueryForZeroAddress ();
797 
798 error BurnedQueryForZeroAddress ();
799 
800 error AuxQueryForZeroAddress ();
801 
802 error MintToZeroAddress ();
803 
804 error MintZeroQuantity ();
805 
806 error OwnerIndexOutOfBounds ();
807 
808 error OwnerQueryForNonexistentToken ();
809 
810 error TokenIndexOutOfBounds ();
811 
812 error TransferCallerNotOwnerNorApproved ();
813 
814 error TransferFromIncorrectOwner ();
815 
816 error TransferToNonERC721ReceiverImplementer ();
817 
818 error TransferToZeroAddress ();
819 
820 error URIQueryForNonexistentToken ();
821 
822 /**
823  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
824  * the Metadata extension. Built to optimize for lower gas during batch mints.
825  *
826  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
827  *
828  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
829  *
830  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
831  */
832 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
833     using Address for address;
834     using Strings for uint256;
835 
836     // Compiler will pack this into a single 256bit word.
837     struct TokenOwnership {
838         // The address of the owner.
839         address addr;
840         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
841         uint64 startTimestamp;
842         // Whether the token has been burned.
843         bool burned;
844     }
845 
846     // Compiler will pack this into a single 256bit word.
847     struct AddressData {
848         // Realistically, 2**64-1 is more than enough.
849         uint64 balance;
850         // Keeps track of mint count with minimal overhead for tokenomics.
851         uint64 numberMinted;
852         // Keeps track of burn count with minimal overhead for tokenomics.
853         uint64 numberBurned;
854         // For miscellaneous variable(s) pertaining to the address
855         // (e.g. number of whitelist mint slots used).
856         // If there are multiple variables, please pack them into a uint64.
857         uint64 aux;
858     }
859 
860     // The tokenId of the next token to be minted.
861     uint256 internal _currentIndex;
862 
863     // The number of tokens burned.
864     uint256 internal _burnCounter;
865 
866     // Token name
867     string private _name;
868 
869     // Token symbol
870     string private _symbol;
871 
872     // Mapping from token ID to ownership details
873     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
874     mapping(uint256 => TokenOwnership) internal _ownerships;
875 
876     // Mapping owner address to address data
877     mapping(address => AddressData) private _addressData;
878 
879     // Mapping from token ID to approved address
880     mapping(uint256 => address) private _tokenApprovals;
881 
882     // Mapping from owner to operator approvals
883     mapping(address => mapping(address => bool)) internal _operatorApprovals;
884 
885     constructor(string memory name_, string memory symbol_) {
886         _name = name_;
887         _symbol = symbol_;
888         _currentIndex = _startTokenId();
889     }
890 
891     /**
892      * To change the starting tokenId, please override this function.
893      */
894     function _startTokenId() internal view virtual returns (uint256) {
895         return 1;
896     }
897 
898     /**
899      * @dev See {IERC721Enumerable-totalSupply}.
900      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
901      */
902     function totalSupply() public view returns (uint256) {
903         // Counter underflow is impossible as _burnCounter cannot be incremented
904         // more than _currentIndex - _startTokenId() times
905         unchecked {
906             return _currentIndex - _burnCounter - _startTokenId();
907         }
908     }
909 
910     /**
911      * Returns the total amount of tokens minted in the contract.
912      */
913     function _totalMinted() internal view returns (uint256) {
914         // Counter underflow is impossible as _currentIndex does not decrement,
915         // and it is initialized to _startTokenId()
916         unchecked {
917             return _currentIndex - _startTokenId();
918         }
919     }
920 
921     /**
922      * @dev See {IERC165-supportsInterface}.
923      */
924     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
925         return
926             interfaceId == type(IERC721).interfaceId ||
927             interfaceId == type(IERC721Metadata).interfaceId ||
928             super.supportsInterface(interfaceId);
929     }
930 
931     /**
932      * @dev See {IERC721-balanceOf}.
933      */
934     function balanceOf(address owner) public view override returns (uint256) {
935         if (owner == address(0)) revert BalanceQueryForZeroAddress();
936         return uint256(_addressData[owner].balance);
937     }
938 
939     /**
940      * Returns the number of tokens minted by `owner`.
941      */
942     function _numberMinted(address owner) internal view returns (uint256) {
943         if (owner == address(0)) revert MintedQueryForZeroAddress();
944         return uint256(_addressData[owner].numberMinted);
945     }
946 
947     /**
948      * Returns the number of tokens burned by or on behalf of `owner`.
949      */
950     function _numberBurned(address owner) internal view returns (uint256) {
951         if (owner == address(0)) revert BurnedQueryForZeroAddress();
952         return uint256(_addressData[owner].numberBurned);
953     }
954 
955     /**
956      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
957      */
958     function _getAux(address owner) internal view returns (uint64) {
959         if (owner == address(0)) revert AuxQueryForZeroAddress();
960         return _addressData[owner].aux;
961     }
962 
963     /**
964      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
965      * If there are multiple variables, please pack them into a uint64.
966      */
967     function _setAux(address owner, uint64 aux) internal {
968         if (owner == address(0)) revert AuxQueryForZeroAddress();
969         _addressData[owner].aux = aux;
970     }
971 
972     /**
973      * Gas spent here starts off proportional to the maximum mint batch size.
974      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
975      */
976     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
977         uint256 curr = tokenId;
978 
979         unchecked {
980             if (_startTokenId() <= curr && curr < _currentIndex) {
981                 TokenOwnership memory ownership = _ownerships[curr];
982                 if (!ownership.burned) {
983                     if (ownership.addr != address(0)) {
984                         return ownership;
985                     }
986                     // Invariant:
987                     // There will always be an ownership that has an address and is not burned
988                     // before an ownership that does not have an address and is not burned.
989                     // Hence, curr will not underflow.
990                     while (true) {
991                         curr--;
992                         ownership = _ownerships[curr];
993                         if (ownership.addr != address(0)) {
994                             return ownership;
995                         }
996                     }
997                 }
998             }
999         }
1000         revert OwnerQueryForNonexistentToken();
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-ownerOf}.
1005      */
1006     function ownerOf(uint256 tokenId) public view override returns (address) {
1007         return ownershipOf(tokenId).addr;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-name}.
1012      */
1013     function name() public view virtual override returns (string memory) {
1014         return _name;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-symbol}.
1019      */
1020     function symbol() public view virtual override returns (string memory) {
1021         return _symbol;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Metadata-tokenURI}.
1026      */
1027     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1028         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1029 
1030         string memory baseURI = _baseURI();
1031         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1032     }
1033 
1034     /**
1035      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1036      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1037      * by default, can be overriden in child contracts.
1038      */
1039     function _baseURI() internal view virtual returns (string memory) {
1040         return '';
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-approve}.
1045      */
1046     function approve(address to, uint256 tokenId) public override {
1047         address owner = ERC721A.ownerOf(tokenId);
1048         if (to == owner) revert ApprovalToCurrentOwner();
1049 
1050         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1051             revert ApprovalCallerNotOwnerNorApproved();
1052         }
1053 
1054         _approve(to, tokenId, owner);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-getApproved}.
1059      */
1060     function getApproved(uint256 tokenId) public view override returns (address) {
1061         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1062 
1063         return _tokenApprovals[tokenId];
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-setApprovalForAll}.
1068      */
1069     function setApprovalForAll(address operator, bool approved) public override {
1070         if (operator == _msgSender()) revert ApproveToCaller();
1071 
1072         _operatorApprovals[_msgSender()][operator] = approved;
1073         emit ApprovalForAll(_msgSender(), operator, approved);
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-isApprovedForAll}.
1078      */
1079     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1080         return _operatorApprovals[owner][operator];
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-transferFrom}.
1085      */
1086     function transferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) public virtual override {
1091         _transfer(from, to, tokenId);
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-safeTransferFrom}.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) public virtual override {
1102         safeTransferFrom(from, to, tokenId, '');
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-safeTransferFrom}.
1107      */
1108     function safeTransferFrom(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory _data
1113     ) public virtual override {
1114         _transfer(from, to, tokenId);
1115         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1116             revert TransferToNonERC721ReceiverImplementer();
1117         }
1118     }
1119 
1120     /**
1121      * @dev Returns whether `tokenId` exists.
1122      *
1123      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1124      *
1125      * Tokens start existing when they are minted (`_mint`),
1126      */
1127     function _exists(uint256 tokenId) internal view returns (bool) {
1128         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1129             !_ownerships[tokenId].burned;
1130     }
1131 
1132     function _safeMint(address to, uint256 quantity) internal {
1133         _safeMint(to, quantity, '');
1134     }
1135 
1136     /**
1137      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1142      * - `quantity` must be greater than 0.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _safeMint(
1147         address to,
1148         uint256 quantity,
1149         bytes memory _data
1150     ) internal {
1151         _mint(to, quantity, _data, true);
1152     }
1153 
1154     /**
1155      * @dev Mints `quantity` tokens and transfers them to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - `to` cannot be the zero address.
1160      * - `quantity` must be greater than 0.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _mint(
1165         address to,
1166         uint256 quantity,
1167         bytes memory _data,
1168         bool safe
1169     ) internal {
1170         uint256 startTokenId = _currentIndex;
1171         if (to == address(0)) revert MintToZeroAddress();
1172         if (quantity == 0) revert MintZeroQuantity();
1173 
1174         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1175 
1176         // Overflows are incredibly unrealistic.
1177         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1178         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1179         unchecked {
1180             _addressData[to].balance += uint64(quantity);
1181             _addressData[to].numberMinted += uint64(quantity);
1182 
1183             _ownerships[startTokenId].addr = to;
1184             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1185 
1186             uint256 updatedIndex = startTokenId;
1187             uint256 end = updatedIndex + quantity;
1188 
1189             if (safe && to.isContract()) {
1190                 do {
1191                     emit Transfer(address(0), to, updatedIndex);
1192                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1193                         revert TransferToNonERC721ReceiverImplementer();
1194                     }
1195                 } while (updatedIndex != end);
1196                 // Reentrancy protection
1197                 if (_currentIndex != startTokenId) revert();
1198             } else {
1199                 do {
1200                     emit Transfer(address(0), to, updatedIndex++);
1201                 } while (updatedIndex != end);
1202             }
1203             _currentIndex = updatedIndex;
1204         }
1205         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1206     }
1207 
1208     /**
1209      * @dev Transfers `tokenId` from `from` to `to`.
1210      *
1211      * Requirements:
1212      *
1213      * - `to` cannot be the zero address.
1214      * - `tokenId` token must be owned by `from`.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _transfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) private {
1223         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1224 
1225         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1226             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1227             getApproved(tokenId) == _msgSender());
1228 
1229         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1230         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1231         if (to == address(0)) revert TransferToZeroAddress();
1232 
1233         _beforeTokenTransfers(from, to, tokenId, 1);
1234 
1235         // Clear approvals from the previous owner
1236         _approve(address(0), tokenId, prevOwnership.addr);
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1241         unchecked {
1242             _addressData[from].balance -= 1;
1243             _addressData[to].balance += 1;
1244 
1245             _ownerships[tokenId].addr = to;
1246             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1247 
1248             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1249             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1250             uint256 nextTokenId = tokenId + 1;
1251             if (_ownerships[nextTokenId].addr == address(0)) {
1252                 // This will suffice for checking _exists(nextTokenId),
1253                 // as a burned slot cannot contain the zero address.
1254                 if (nextTokenId < _currentIndex) {
1255                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1256                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(from, to, tokenId);
1262         _afterTokenTransfers(from, to, tokenId, 1);
1263     }
1264 
1265     /**
1266      * @dev Destroys `tokenId`.
1267      * The approval is cleared when the token is burned.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function _burn(uint256 tokenId) internal virtual {
1276         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1277 
1278         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1279 
1280         // Clear approvals from the previous owner
1281         _approve(address(0), tokenId, prevOwnership.addr);
1282 
1283         // Underflow of the sender's balance is impossible because we check for
1284         // ownership above and the recipient's balance can't realistically overflow.
1285         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1286         unchecked {
1287             _addressData[prevOwnership.addr].balance -= 1;
1288             _addressData[prevOwnership.addr].numberBurned += 1;
1289 
1290             // Keep track of who burned the token, and the timestamp of burning.
1291             _ownerships[tokenId].addr = prevOwnership.addr;
1292             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1293             _ownerships[tokenId].burned = true;
1294 
1295             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1296             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1297             uint256 nextTokenId = tokenId + 1;
1298             if (_ownerships[nextTokenId].addr == address(0)) {
1299                 // This will suffice for checking _exists(nextTokenId),
1300                 // as a burned slot cannot contain the zero address.
1301                 if (nextTokenId < _currentIndex) {
1302                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1303                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1304                 }
1305             }
1306         }
1307 
1308         emit Transfer(prevOwnership.addr, address(0), tokenId);
1309         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1310 
1311         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1312         unchecked {
1313             _burnCounter++;
1314         }
1315     }
1316 
1317     /**
1318      * @dev Approve `to` to operate on `tokenId`
1319      *
1320      * Emits a {Approval} event.
1321      */
1322     function _approve(
1323         address to,
1324         uint256 tokenId,
1325         address owner
1326     ) private {
1327         _tokenApprovals[tokenId] = to;
1328         emit Approval(owner, to, tokenId);
1329     }
1330 
1331     /**
1332      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1333      *
1334      * @param from address representing the previous owner of the given token ID
1335      * @param to target address that will receive the tokens
1336      * @param tokenId uint256 ID of the token to be transferred
1337      * @param _data bytes optional data to send along with the call
1338      * @return bool whether the call correctly returned the expected magic value
1339      */
1340     function _checkContractOnERC721Received(
1341         address from,
1342         address to,
1343         uint256 tokenId,
1344         bytes memory _data
1345     ) private returns (bool) {
1346         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1347             return retval == IERC721Receiver(to).onERC721Received.selector;
1348         } catch (bytes memory reason) {
1349             if (reason.length == 0) {
1350                 revert TransferToNonERC721ReceiverImplementer();
1351             } else {
1352                 assembly {
1353                     revert(add(32, reason), mload(reason))
1354                 }
1355             }
1356         }
1357     }
1358 
1359     /**
1360      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1361      * And also called before burning one token.
1362      *
1363      * startTokenId - the first token id to be transferred
1364      * quantity - the amount to be transferred
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` will be minted for `to`.
1371      * - When `to` is zero, `tokenId` will be burned by `from`.
1372      * - `from` and `to` are never both zero.
1373      */
1374     function _beforeTokenTransfers(
1375         address from,
1376         address to,
1377         uint256 startTokenId,
1378         uint256 quantity
1379     ) internal virtual {}
1380 
1381     /**
1382      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1383      * minting.
1384      * And also called after one token has been burned.
1385      *
1386      * startTokenId - the first token id to be transferred
1387      * quantity - the amount to be transferred
1388      *
1389      * Calling conditions:
1390      *
1391      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1392      * transferred to `to`.
1393      * - When `from` is zero, `tokenId` has been minted for `to`.
1394      * - When `to` is zero, `tokenId` has been burned by `from`.
1395      * - `from` and `to` are never both zero.
1396      */
1397     function _afterTokenTransfers(
1398         address from,
1399         address to,
1400         uint256 startTokenId,
1401         uint256 quantity
1402     ) internal virtual {}
1403 }
1404 
1405 interface IMAL {
1406   function depositMALFor(address user, uint256 amount) external;
1407 }
1408 
1409 interface ISTAKING {
1410   function balanceOf(address user) external view returns (uint256);
1411 }
1412 
1413 contract MoonTreasury is ERC721A {
1414     using SafeMath for uint256;
1415     using Strings for uint256;
1416 
1417     // Base URI
1418     string private _baseUri;
1419 
1420     // Max number of NFTs
1421     uint256 public constant MAX_SUPPLY = 5000;
1422     uint256 public constant INITIAL_DROP = 15000 ether;
1423 
1424     uint256 public treasuryPrice;
1425     mapping(address => bool) whitelisted;
1426     bool public whitelistSale;
1427 
1428     bool public saleIsActive;
1429     bool public apeOwnershipRequired;
1430     bool private metadataFinalised;
1431 
1432     mapping (address => bool) private _isAuthorised;
1433     address[] public authorisedLog;
1434     address public contract_owner;
1435 
1436     // Contracts
1437     IMAL public MAL;
1438     ISTAKING public STAKING;
1439     IERC721 public APES;
1440 
1441     event TreasuriesMinted(address indexed mintedBy, uint256 indexed tokensNumber);
1442 
1443     constructor(address _apes, address _staking, address _mal) ERC721A("Moon Treasury", "MAL_TREASURY") {
1444         APES = IERC721(address(_apes));
1445         STAKING = ISTAKING(address(_staking));
1446         MAL = IMAL(address(_mal));
1447         _isAuthorised[_staking] = true;
1448         contract_owner = _msgSender();
1449 
1450         _baseUri = "ipfs://QmYmi1MYWRd9Dt1VPTxZyGWHmd7scmi4AprEwevsJcLFAW/moon_treasury.json";
1451         apeOwnershipRequired = false;
1452         whitelistSale = true;
1453 
1454         treasuryPrice = 0.3 ether;
1455         saleIsActive = false;
1456     }
1457 
1458     modifier onlyAuthorised {
1459       require(_isAuthorised[_msgSender()], "Not Authorised");
1460       _;
1461     }
1462 
1463     modifier onlyOwner {
1464       require(_msgSender() == contract_owner, "Not contract owner");
1465       _;
1466     }
1467 
1468     function addWhitelisted(address[] memory wl_addresses) public onlyOwner{
1469         for (uint256 i = 0; i < wl_addresses.length; i++){
1470             whitelisted[wl_addresses[i]] = true;
1471         }
1472     }
1473 
1474     function isWhitelisted(address some_address) public view returns(bool){
1475         return whitelisted[some_address];
1476     }
1477 
1478     function disableWhitelistSale() public onlyOwner{
1479         require(whitelistSale, "Whitelist is already disabled");
1480         whitelistSale = false;
1481     }
1482 
1483     function authorise(address addressToAuth) public onlyOwner {
1484       _isAuthorised[addressToAuth] = true;
1485       authorisedLog.push(addressToAuth);
1486     }
1487 
1488     function unauthorise(address addressToUnAuth) public onlyOwner {
1489       _isAuthorised[addressToUnAuth] = false;
1490     }
1491 
1492     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1493         return (ERC721A._operatorApprovals[owner][operator] || _isAuthorised[operator]);
1494     }
1495 
1496     function owner() public view returns(address){
1497         return contract_owner;
1498     }
1499 
1500     function _validateApeOwnership(address user) internal view returns (bool) {
1501       if (!apeOwnershipRequired) return true;
1502       if (STAKING.balanceOf(user) > 0) {
1503         return true;
1504       }
1505       return APES.balanceOf(user) > 0;
1506     }
1507 
1508     function updateSaleStatus(bool is_sale_active) public onlyOwner {
1509       require(treasuryPrice != 0, "Price is not set");
1510       saleIsActive = is_sale_active;
1511     }
1512 
1513     function updateTreasuryPrice(uint256 _newPrice) public onlyOwner {
1514       require(!saleIsActive, "Pause sale before price update");
1515       treasuryPrice = _newPrice;
1516     }
1517 
1518     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1519       require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1520       return _baseUri;
1521     }
1522 
1523     function updateApeOwnershipRequirement(bool _isOwnershipRequired) public onlyOwner {
1524       apeOwnershipRequired = _isOwnershipRequired;
1525     }
1526 
1527     function withdraw() external onlyOwner {
1528       payable(contract_owner).transfer(address(this).balance);
1529     }
1530 
1531     function reserveForGiveaway(uint256 tokensToMint) public onlyOwner{
1532       require(tokensToMint > 0, "Min mint is 1 token");
1533       require(tokensToMint <= 50, "You can mint max 50 tokens per transaction");
1534       require(totalSupply().add(tokensToMint) <= MAX_SUPPLY, "Mint more tokens than allowed");
1535 
1536       _safeMint(_msgSender(), tokensToMint);
1537     }
1538 
1539     function giveaway(address[] memory receivers, uint256[] memory amounts) public onlyOwner{
1540         require(receivers.length == amounts.length, "Lists not same length");
1541         for (uint256 i = 0; i < receivers.length; i++){
1542             _safeMint(receivers[i], amounts[i]);
1543         }
1544     }
1545 
1546     function purchaseTreasury(uint256 tokensToMint) public payable {
1547       require(saleIsActive, "The mint has not started yet");
1548       require(_validateApeOwnership(_msgSender()), "You do not have any Moon Apes");
1549       if (whitelistSale){
1550           require(whitelisted[_msgSender()], "You are not whitelisted");
1551       }
1552       require(msg.value == treasuryPrice.mul(tokensToMint), "Wrong ETH value provided");
1553       require(tokensToMint > 0, "Min mint is 1 token");
1554       require(tokensToMint <= 50, "You can mint max 50 tokens per transaction");
1555       require(totalSupply().add(tokensToMint) <= MAX_SUPPLY, "Mint more tokens than allowed");
1556 
1557       _safeMint(_msgSender(), tokensToMint);
1558 
1559       MAL.depositMALFor(_msgSender(), INITIAL_DROP.mul(tokensToMint));
1560 
1561       emit TreasuriesMinted(_msgSender(), tokensToMint);
1562     }
1563 
1564 
1565 
1566 }