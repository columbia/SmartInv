1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-02
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /*
8  *  _     _       _      _       _      _       _   
9  * (_)   | |     | |    | |     | |    | |     | |  
10  *  _  __| | ___ | |_ __| | ___ | |_ __| | ___ | |_ 
11  * | |/ _` |/ _ \| __/ _` |/ _ \| __/ _` |/ _ \| __|
12  * | | (_| | (_) | || (_| | (_) | || (_| | (_) | |_ 
13  * |_|\__,_|\___/ \__\__,_|\___/ \__\__,_|\___/ \__|
14  */
15 
16 pragma solidity ^0.8.0;
17 
18 // CAUTION
19 // This version of SafeMath should only be used with Solidity 0.8 or later,
20 // because it relies on the compiler's built in overflow checks.
21 
22 /**
23  * @dev Wrappers over Solidity's arithmetic operations.
24  *
25  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
26  * now has built in overflow checking.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35     unchecked {
36         uint256 c = a + b;
37         if (c < a) return (false, 0);
38         return (true, c);
39     }
40     }
41 
42     /**
43      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48     unchecked {
49         if (b > a) return (false, 0);
50         return (true, a - b);
51     }
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60     unchecked {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64         if (a == 0) return (true, 0);
65         uint256 c = a * b;
66         if (c / a != b) return (false, 0);
67         return (true, c);
68     }
69     }
70 
71     /**
72      * @dev Returns the division of two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77     unchecked {
78         if (b == 0) return (false, 0);
79         return (true, a / b);
80     }
81     }
82 
83     /**
84      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89     unchecked {
90         if (b == 0) return (false, 0);
91         return (true, a % b);
92     }
93     }
94 
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a + b;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a - b;
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `*` operator.
128      *
129      * Requirements:
130      *
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a * b;
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers, reverting on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator.
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a / b;
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * reverting when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         return a % b;
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * CAUTION: This function is deprecated because it requires allocating memory for the error
172      * message unnecessarily. For custom revert reasons use {trySub}.
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181     unchecked {
182         require(b <= a, errorMessage);
183         return a - b;
184     }
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `%` operator. This function uses a `revert`
192      * opcode (which leaves remaining gas untouched) while Solidity uses an
193      * invalid opcode to revert (consuming all remaining gas).
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204     unchecked {
205         require(b > 0, errorMessage);
206         return a / b;
207     }
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * reverting with custom message when dividing by zero.
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {tryMod}.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226     unchecked {
227         require(b > 0, errorMessage);
228         return a % b;
229     }
230     }
231 }
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev String operations.
238  */
239 library Strings {
240     bytes16 private constant alphabet = "0123456789abcdef";
241 
242     /**
243      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
244      */
245     function toString(uint256 value) internal pure returns (string memory) {
246         // Inspired by OraclizeAPI's implementation - MIT licence
247         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
248 
249         if (value == 0) {
250             return "0";
251         }
252         uint256 temp = value;
253         uint256 digits;
254         while (temp != 0) {
255             digits++;
256             temp /= 10;
257         }
258         bytes memory buffer = new bytes(digits);
259         while (value != 0) {
260             digits -= 1;
261             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
262             value /= 10;
263         }
264         return string(buffer);
265     }
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
269      */
270     function toHexString(uint256 value) internal pure returns (string memory) {
271         if (value == 0) {
272             return "0x00";
273         }
274         uint256 temp = value;
275         uint256 length = 0;
276         while (temp != 0) {
277             length++;
278             temp >>= 8;
279         }
280         return toHexString(value, length);
281     }
282 
283     /**
284      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
285      */
286     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
287         bytes memory buffer = new bytes(2 * length + 2);
288         buffer[0] = "0";
289         buffer[1] = "x";
290         for (uint256 i = 2 * length + 1; i > 1; --i) {
291             buffer[i] = alphabet[value & 0xf];
292             value >>= 4;
293         }
294         require(value == 0, "Strings: hex length insufficient");
295         return string(buffer);
296     }
297 
298 }
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
329         // solhint-disable-next-line no-inline-assembly
330         assembly { size := extcodesize(account) }
331         return size > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
354         (bool success, ) = recipient.call{ value: amount }("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain`call` is an unsafe replacement for a function call: use this
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
386     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but also transferring `value` wei to `target`.
393      *
394      * Requirements:
395      *
396      * - the calling contract must have an ETH balance of at least `value`.
397      * - the called Solidity function must be `payable`.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
412         require(address(this).balance >= value, "Address: insufficient balance for call");
413         require(isContract(target), "Address: call to non-contract");
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.call{ value: value }(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
427         return functionStaticCall(target, data, "Address: low-level static call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
437         require(isContract(target), "Address: static call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.staticcall(data);
441         return _verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
451         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.4._
459      */
460     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
461         require(isContract(target), "Address: delegate call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.delegatecall(data);
465         return _verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 // solhint-disable-next-line no-inline-assembly
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @title ERC721 token receiver interface
492  * @dev Interface for any contract that wants to support safeTransfers
493  * from ERC721 asset contracts.
494  */
495 interface IERC721Receiver {
496     /**
497      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
498      * by `operator` from `from`, this function is called.
499      *
500      * It must return its Solidity selector to confirm the token transfer.
501      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
502      *
503      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
504      */
505     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
506 }
507 
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Interface of the ERC165 standard, as defined in the
512  * https://eips.ethereum.org/EIPS/eip-165[EIP].
513  *
514  * Implementers can declare support of contract interfaces, which can then be
515  * queried by others ({ERC165Checker}).
516  *
517  * For an implementation, see {ERC165}.
518  */
519 interface IERC165 {
520     /**
521      * @dev Returns true if this contract implements the interface defined by
522      * `interfaceId`. See the corresponding
523      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
524      * to learn more about how these ids are created.
525      *
526      * This function call must use less than 30 000 gas.
527      */
528     function supportsInterface(bytes4 interfaceId) external view returns (bool);
529 }
530 
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev Implementation of the {IERC165} interface.
536  *
537  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
538  * for the additional interface id that will be supported. For example:
539  *
540  * ```solidity
541  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
543  * }
544  * ```
545  *
546  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
547  */
548 abstract contract ERC165 is IERC165 {
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         return interfaceId == type(IERC165).interfaceId;
554     }
555 }
556 
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Required interface of an ERC721 compliant contract.
562  */
563 interface IERC721 is IERC165 {
564     /**
565      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
571      */
572     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
576      */
577     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
578 
579     /**
580      * @dev Returns the number of tokens in ``owner``'s account.
581      */
582     function balanceOf(address owner) external view returns (uint256 balance);
583 
584     /**
585      * @dev Returns the owner of the `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function ownerOf(uint256 tokenId) external view returns (address owner);
592 
593     /**
594      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
595      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(address from, address to, uint256 tokenId) external;
608 
609     /**
610      * @dev Transfers `tokenId` token from `from` to `to`.
611      *
612      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
620      *
621      * Emits a {Transfer} event.
622      */
623     function transferFrom(address from, address to, uint256 tokenId) external;
624 
625     /**
626      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
627      * The approval is cleared when the token is transferred.
628      *
629      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
630      *
631      * Requirements:
632      *
633      * - The caller must own the token or be an approved operator.
634      * - `tokenId` must exist.
635      *
636      * Emits an {Approval} event.
637      */
638     function approve(address to, uint256 tokenId) external;
639 
640     /**
641      * @dev Returns the account approved for `tokenId` token.
642      *
643      * Requirements:
644      *
645      * - `tokenId` must exist.
646      */
647     function getApproved(uint256 tokenId) external view returns (address operator);
648 
649     /**
650      * @dev Approve or remove `operator` as an operator for the caller.
651      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
652      *
653      * Requirements:
654      *
655      * - The `operator` cannot be the caller.
656      *
657      * Emits an {ApprovalForAll} event.
658      */
659     function setApprovalForAll(address operator, bool _approved) external;
660 
661     /**
662      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
663      *
664      * See {setApprovalForAll}
665      */
666     function isApprovedForAll(address owner, address operator) external view returns (bool);
667 
668     /**
669       * @dev Safely transfers `tokenId` token from `from` to `to`.
670       *
671       * Requirements:
672       *
673       * - `from` cannot be the zero address.
674       * - `to` cannot be the zero address.
675       * - `tokenId` token must exist and be owned by `from`.
676       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
677       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
678       *
679       * Emits a {Transfer} event.
680       */
681     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
682 }
683 
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
688  * @dev See https://eips.ethereum.org/EIPS/eip-721
689  */
690 interface IERC721Enumerable is IERC721 {
691 
692     /**
693      * @dev Returns the total amount of tokens stored by the contract.
694      */
695     function totalSupply() external view returns (uint256);
696 
697     /**
698      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
699      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
700      */
701     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
702 
703     /**
704      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
705      * Use along with {totalSupply} to enumerate all tokens.
706      */
707     function tokenByIndex(uint256 index) external view returns (uint256);
708 }
709 
710 pragma solidity ^0.8.0;
711 
712 /**
713  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
714  * @dev See https://eips.ethereum.org/EIPS/eip-721
715  */
716 interface IERC721Metadata is IERC721 {
717 
718     /**
719      * @dev Returns the token collection name.
720      */
721     function name() external view returns (string memory);
722 
723     /**
724      * @dev Returns the token collection symbol.
725      */
726     function symbol() external view returns (string memory);
727 
728     /**
729      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
730      */
731     function tokenURI(uint256 tokenId) external view returns (string memory);
732 }
733 
734 
735 
736 
737 pragma solidity ^0.8.0;
738 
739 /*
740  * @dev Provides information about the current execution context, including the
741  * sender of the transaction and its data. While these are generally available
742  * via msg.sender and msg.data, they should not be accessed in such a direct
743  * manner, since when dealing with meta-transactions the account sending and
744  * paying for execution may not be the actual sender (as far as an application
745  * is concerned).
746  *
747  * This contract is only required for intermediate, library-like contracts.
748  */
749 abstract contract Context {
750     function _msgSender() internal view virtual returns (address) {
751         return msg.sender;
752     }
753 
754     function _msgData() internal view virtual returns (bytes calldata) {
755         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
756         return msg.data;
757     }
758 }
759 
760 pragma solidity ^0.8.0;
761 
762 /**
763  * @dev Contract module which provides a basic access control mechanism, where
764  * there is an account (an owner) that can be granted exclusive access to
765  * specific functions.
766  *
767  * By default, the owner account will be the one that deploys the contract. This
768  * can later be changed with {transferOwnership}.
769  *
770  * This module is used through inheritance. It will make available the modifier
771  * `onlyOwner`, which can be applied to your functions to restrict their use to
772  * the owner.
773  */
774 abstract contract Ownable is Context {
775     address private _owner;
776 
777     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
778 
779     /**
780      * @dev Initializes the contract setting the deployer as the initial owner.
781      */
782     constructor () {
783         address msgSender = _msgSender();
784         _owner = msgSender;
785         emit OwnershipTransferred(address(0), msgSender);
786     }
787 
788     /**
789      * @dev Returns the address of the current owner.
790      */
791     function owner() public view virtual returns (address) {
792         return _owner;
793     }
794 
795     /**
796      * @dev Throws if called by any account other than the owner.
797      */
798     modifier onlyOwner() {
799         require(owner() == _msgSender(), "Ownable: caller is not the owner");
800         _;
801     }
802 
803     /**
804      * @dev Leaves the contract without owner. It will not be possible to call
805      * `onlyOwner` functions anymore. Can only be called by the current owner.
806      *
807      * NOTE: Renouncing ownership will leave the contract without an owner,
808      * thereby removing any functionality that is only available to the owner.
809      */
810     function renounceOwnership() public virtual onlyOwner {
811         emit OwnershipTransferred(_owner, address(0));
812         _owner = address(0);
813     }
814 
815     /**
816      * @dev Transfers ownership of the contract to a new account (`newOwner`).
817      * Can only be called by the current owner.
818      */
819     function transferOwnership(address newOwner) public virtual onlyOwner {
820         require(newOwner != address(0), "Ownable: new owner is the zero address");
821         emit OwnershipTransferred(_owner, newOwner);
822         _owner = newOwner;
823     }
824 }
825 
826 
827 pragma solidity ^0.8.0;
828 
829 /**
830  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
831  * the Metadata extension, but not including the Enumerable extension, which is available separately as
832  * {ERC721Enumerable}.
833  */
834 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
835     using Address for address;
836     using Strings for uint256;
837 
838     // Token name
839     string private _name;
840 
841     // Token symbol
842     string private _symbol;
843 
844     // Mapping from token ID to owner address
845     mapping (uint256 => address) private _owners;
846 
847     // Mapping owner address to token count
848     mapping (address => uint256) private _balances;
849 
850     // Mapping from token ID to approved address
851     mapping (uint256 => address) private _tokenApprovals;
852 
853     // Mapping from owner to operator approvals
854     mapping (address => mapping (address => bool)) private _operatorApprovals;
855 
856     /**
857      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
858      */
859     constructor (string memory name_, string memory symbol_) {
860         _name = name_;
861         _symbol = symbol_;
862     }
863 
864     /**
865      * @dev See {IERC165-supportsInterface}.
866      */
867     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
868         return interfaceId == type(IERC721).interfaceId
869         || interfaceId == type(IERC721Metadata).interfaceId
870         || super.supportsInterface(interfaceId);
871     }
872 
873     /**
874      * @dev See {IERC721-balanceOf}.
875      */
876     function balanceOf(address owner) public view virtual override returns (uint256) {
877         require(owner != address(0), "ERC721: balance query for the zero address");
878         return _balances[owner];
879     }
880 
881     /**
882      * @dev See {IERC721-ownerOf}.
883      */
884     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
885         address owner = _owners[tokenId];
886         require(owner != address(0), "ERC721: owner query for nonexistent token");
887         return owner;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-name}.
892      */
893     function name() public view virtual override returns (string memory) {
894         return _name;
895     }
896 
897     /**
898      * @dev See {IERC721Metadata-symbol}.
899      */
900     function symbol() public view virtual override returns (string memory) {
901         return _symbol;
902     }
903 
904     /**
905      * @dev See {IERC721Metadata-tokenURI}.
906      */
907     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
908         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
909 
910         string memory baseURI = _baseURI();
911         return bytes(baseURI).length > 0
912         ? string(abi.encodePacked(baseURI, tokenId.toString()))
913         : '';
914     }
915 
916     /**
917      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
918      * in child contracts.
919      */
920     function _baseURI() internal view virtual returns (string memory) {
921         return "";
922     }
923 
924     /**
925      * @dev See {IERC721-approve}.
926      */
927     function approve(address to, uint256 tokenId) public virtual override {
928         address owner = ERC721.ownerOf(tokenId);
929         require(to != owner, "ERC721: approval to current owner");
930 
931         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
932             "ERC721: approve caller is not owner nor approved for all"
933         );
934 
935         _approve(to, tokenId);
936     }
937 
938     /**
939      * @dev See {IERC721-getApproved}.
940      */
941     function getApproved(uint256 tokenId) public view virtual override returns (address) {
942         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
943 
944         return _tokenApprovals[tokenId];
945     }
946 
947     /**
948      * @dev See {IERC721-setApprovalForAll}.
949      */
950     function setApprovalForAll(address operator, bool approved) public virtual override {
951         require(operator != _msgSender(), "ERC721: approve to caller");
952 
953         _operatorApprovals[_msgSender()][operator] = approved;
954         emit ApprovalForAll(_msgSender(), operator, approved);
955     }
956 
957     /**
958      * @dev See {IERC721-isApprovedForAll}.
959      */
960     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
961         return _operatorApprovals[owner][operator];
962     }
963 
964     /**
965      * @dev See {IERC721-transferFrom}.
966      */
967     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
968         //solhint-disable-next-line max-line-length
969         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
970 
971         _transfer(from, to, tokenId);
972     }
973 
974     /**
975      * @dev See {IERC721-safeTransferFrom}.
976      */
977     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
978         safeTransferFrom(from, to, tokenId, "");
979     }
980 
981     /**
982      * @dev See {IERC721-safeTransferFrom}.
983      */
984     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
985         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
986         _safeTransfer(from, to, tokenId, _data);
987     }
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
991      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
992      *
993      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
994      *
995      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
996      * implement alternative mechanisms to perform token transfer, such as signature-based.
997      *
998      * Requirements:
999      *
1000      * - `from` cannot be the zero address.
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must exist and be owned by `from`.
1003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1008         _transfer(from, to, tokenId);
1009         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1010     }
1011 
1012     /**
1013      * @dev Returns whether `tokenId` exists.
1014      *
1015      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1016      *
1017      * Tokens start existing when they are minted (`_mint`),
1018      * and stop existing when they are burned (`_burn`).
1019      */
1020     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1021         return _owners[tokenId] != address(0);
1022     }
1023 
1024     /**
1025      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1026      *
1027      * Requirements:
1028      *
1029      * - `tokenId` must exist.
1030      */
1031     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1032         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1033         address owner = ERC721.ownerOf(tokenId);
1034         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1035     }
1036 
1037     /**
1038      * @dev Safely mints `tokenId` and transfers it to `to`.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must not exist.
1043      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _safeMint(address to, uint256 tokenId) internal virtual {
1048         _safeMint(to, tokenId, "");
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1053      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1054      */
1055     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1056         _mint(to, tokenId);
1057         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1058     }
1059 
1060     /**
1061      * @dev Mints `tokenId` and transfers it to `to`.
1062      *
1063      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must not exist.
1068      * - `to` cannot be the zero address.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _mint(address to, uint256 tokenId) internal virtual {
1073         require(to != address(0), "ERC721: mint to the zero address");
1074         require(!_exists(tokenId), "ERC721: token already minted");
1075 
1076         _beforeTokenTransfer(address(0), to, tokenId, true);
1077 
1078         _balances[to] += 1;
1079         _owners[tokenId] = to;
1080 
1081         emit Transfer(address(0), to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev Destroys `tokenId`.
1086      * The approval is cleared when the token is burned.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _burn(uint256 tokenId) internal virtual {
1095         address owner = ERC721.ownerOf(tokenId);
1096 
1097         _beforeTokenTransfer(owner, address(0), tokenId, true);
1098 
1099         // Clear approvals
1100         _approve(address(0), tokenId);
1101 
1102         _balances[owner] -= 1;
1103         delete _owners[tokenId];
1104 
1105         emit Transfer(owner, address(0), tokenId);
1106     }
1107 
1108     function _burnSave(address owner, uint256 tokenId) internal virtual {
1109 
1110         _beforeTokenTransfer(owner, address(0), tokenId, false);
1111 
1112         // Clear approvals
1113         _approve(address(0), tokenId);
1114 
1115         _balances[owner] -= 1;
1116         delete _owners[tokenId];
1117 
1118         emit Transfer(owner, address(0), tokenId);
1119     }
1120 
1121     /**
1122      * @dev Transfers `tokenId` from `from` to `to`.
1123      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1124      *
1125      * Requirements:
1126      *
1127      * - `to` cannot be the zero address.
1128      * - `tokenId` token must be owned by `from`.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1133         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1134         require(to != address(0), "ERC721: transfer to the zero address");
1135 
1136         _beforeTokenTransfer(from, to, tokenId, true);
1137 
1138         // Clear approvals from the previous owner
1139         _approve(address(0), tokenId);
1140 
1141         _balances[from] -= 1;
1142         _balances[to] += 1;
1143         _owners[tokenId] = to;
1144 
1145         emit Transfer(from, to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Approve `to` to operate on `tokenId`
1150      *
1151      * Emits a {Approval} event.
1152      */
1153     function _approve(address to, uint256 tokenId) internal virtual {
1154         _tokenApprovals[tokenId] = to;
1155         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1156     }
1157 
1158     /**
1159      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1160      * The call is not executed if the target address is not a contract.
1161      *
1162      * @param from address representing the previous owner of the given token ID
1163      * @param to target address that will receive the tokens
1164      * @param tokenId uint256 ID of the token to be transferred
1165      * @param _data bytes optional data to send along with the call
1166      * @return bool whether the call correctly returned the expected magic value
1167      */
1168     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1169     private returns (bool)
1170     {
1171         if (to.isContract()) {
1172             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1173                 return retval == IERC721Receiver(to).onERC721Received.selector;
1174             } catch (bytes memory reason) {
1175                 if (reason.length == 0) {
1176                     revert("ERC721: transfer to non ERC721Receiver implementer");
1177                 } else {
1178                     // solhint-disable-next-line no-inline-assembly
1179                     assembly {
1180                         revert(add(32, reason), mload(reason))
1181                     }
1182                 }
1183             }
1184         } else {
1185             return true;
1186         }
1187     }
1188 
1189     /**
1190      * @dev Hook that is called before any token transfer. This includes minting
1191      * and burning.
1192      *
1193      * Calling conditions:
1194      *
1195      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1196      * transferred to `to`.
1197      * - When `from` is zero, `tokenId` will be minted for `to`.
1198      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1199      * - `from` cannot be the zero address.
1200      * - `to` cannot be the zero address.
1201      *
1202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1203      */
1204     function _beforeTokenTransfer(address from, address to, uint256 tokenId, bool isDelete) internal virtual { }
1205 }
1206 
1207 pragma solidity ^0.8.0;
1208 
1209 /**
1210  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1211  * enumerability of all the token ids in the contract as well as all token ids owned by each
1212  * account.
1213  */
1214 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1215     // Mapping from owner to list of owned token IDs
1216     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1217 
1218     // Mapping from token ID to index of the owner tokens list
1219     mapping(uint256 => uint256) private _ownedTokensIndex;
1220 
1221     // Array with all token ids, used for enumeration
1222     uint256[] private _allTokens;
1223 
1224     // Mapping from token id to position in the allTokens array
1225     mapping(uint256 => uint256) private _allTokensIndex;
1226 
1227     /**
1228      * @dev See {IERC165-supportsInterface}.
1229      */
1230     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1231         return interfaceId == type(IERC721Enumerable).interfaceId
1232         || super.supportsInterface(interfaceId);
1233     }
1234 
1235     /**
1236      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1237      */
1238     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1239         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1240         return _ownedTokens[owner][index];
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Enumerable-totalSupply}.
1245      */
1246     function totalSupply() public view virtual override returns (uint256) {
1247         return _allTokens.length;
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Enumerable-tokenByIndex}.
1252      */
1253     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1254         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1255         return _allTokens[index];
1256     }
1257 
1258     /**
1259      * @dev Hook that is called before any token transfer. This includes minting
1260      * and burning.
1261      *
1262      * Calling conditions:
1263      *
1264      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1265      * transferred to `to`.
1266      * - When `from` is zero, `tokenId` will be minted for `to`.
1267      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1268      * - `from` cannot be the zero address.
1269      * - `to` cannot be the zero address.
1270      *
1271      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1272      */
1273     function _beforeTokenTransfer(address from, address to, uint256 tokenId, bool isDelete) internal virtual override {
1274         super._beforeTokenTransfer(from, to, tokenId, isDelete);
1275 
1276         if (from == address(0)) {
1277             _addTokenToAllTokensEnumeration(tokenId);
1278         } else if (from != to) {
1279             _removeTokenFromOwnerEnumeration(from, tokenId);
1280         }
1281         if (to == address(0) && isDelete) {
1282             _removeTokenFromAllTokensEnumeration(tokenId);
1283         } else if (to != from && isDelete) {
1284             _addTokenToOwnerEnumeration(to, tokenId);
1285         }
1286     }
1287 
1288     /**
1289      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1290      * @param to address representing the new owner of the given token ID
1291      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1292      */
1293     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1294         uint256 length = ERC721.balanceOf(to);
1295         _ownedTokens[to][length] = tokenId;
1296         _ownedTokensIndex[tokenId] = length;
1297     }
1298 
1299     /**
1300      * @dev Private function to add a token to this extension's token tracking data structures.
1301      * @param tokenId uint256 ID of the token to be added to the tokens list
1302      */
1303     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1304         _allTokensIndex[tokenId] = _allTokens.length;
1305         _allTokens.push(tokenId);
1306     }
1307 
1308     /**
1309      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1310      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1311      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1312      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1313      * @param from address representing the previous owner of the given token ID
1314      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1315      */
1316     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1317         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1318         // then delete the last slot (swap and pop).
1319 
1320         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1321         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1322 
1323         // When the token to delete is the last token, the swap operation is unnecessary
1324         if (tokenIndex != lastTokenIndex) {
1325             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1326 
1327             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1328             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1329         }
1330 
1331         // This also deletes the contents at the last position of the array
1332         delete _ownedTokensIndex[tokenId];
1333         delete _ownedTokens[from][lastTokenIndex];
1334     }
1335 
1336     /**
1337      * @dev Private function to remove a token from this extension's token tracking data structures.
1338      * This has O(1) time complexity, but alters the order of the _allTokens array.
1339      * @param tokenId uint256 ID of the token to be removed from the tokens list
1340      */
1341     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1342         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1343         // then delete the last slot (swap and pop).
1344 
1345         uint256 lastTokenIndex = _allTokens.length - 1;
1346         uint256 tokenIndex = _allTokensIndex[tokenId];
1347 
1348         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1349         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1350         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1351         uint256 lastTokenId = _allTokens[lastTokenIndex];
1352 
1353         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1354         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1355 
1356         // This also deletes the contents at the last position of the array
1357         delete _allTokensIndex[tokenId];
1358         _allTokens.pop();
1359     }
1360 }
1361 
1362 pragma solidity ^0.8.0;
1363 
1364 
1365 contract idotdotdot is ERC721Enumerable, Ownable{
1366     using SafeMath for uint256;
1367     using Address for address;
1368     using Strings for uint256;
1369 
1370 
1371     uint256 public constant NFT_PRICE = 50000000000000000; // 0.05 ETH
1372     uint public constant MAX_NFT_PURCHASE = 5;
1373     uint256 public MAX_SUPPLY = 4360;
1374     bool public saleIsActive = true;
1375 
1376     uint256 public startingIndex;
1377     uint256 public startingIndexBlock;
1378 
1379     string private _baseURIExtended;
1380     mapping (uint256 => string) _tokenURIs;
1381 
1382     constructor() ERC721("idotdotdot","idotdotdot"){
1383          
1384     }
1385 
1386 
1387     function flipSaleState() public onlyOwner {
1388         saleIsActive = !saleIsActive;
1389     }
1390 
1391     function withdraw() public onlyOwner {
1392         uint balance = address(this).balance;
1393         payable(msg.sender).transfer(balance);
1394     }
1395 
1396     function reserveTokens(uint256 num) public onlyOwner {
1397         uint supply = totalSupply();
1398         uint i;
1399         for (i = 0; i < num; i++) {
1400             _safeMint(msg.sender, supply + i);
1401         }
1402 
1403         if (startingIndexBlock == 0) {
1404             startingIndexBlock = block.number;
1405         }
1406     }
1407 
1408     function setMaxTokenSupply(uint256 maxSupply) public onlyOwner {
1409         MAX_SUPPLY = maxSupply;
1410     }
1411     
1412     function getPrice(uint256 quantity) public view returns (uint256) {
1413         require(quantity <= MAX_SUPPLY);
1414         return quantity.mul(NFT_PRICE);
1415     }
1416 
1417 
1418     function mint(uint numberOfTokensMax5) public payable {
1419         require(saleIsActive, "Sale is not active at the moment");
1420         require(numberOfTokensMax5 > 0, "Number of tokens can not be less than or equal to 0");
1421         require(totalSupply().add(numberOfTokensMax5) <= MAX_SUPPLY, "Purchase would exceed max supply");
1422         require(numberOfTokensMax5 <= MAX_NFT_PURCHASE,"Can only mint up to 5 per purchase");
1423         
1424         uint256 price = getPrice(numberOfTokensMax5);
1425 
1426         // Ensure enough ETH
1427         require(msg.value >= price, "Not enough ETH sent");
1428 
1429         for (uint i = 0; i < numberOfTokensMax5; i++) {
1430             _safeMint(msg.sender, totalSupply());
1431         }
1432         
1433         // Return any remaining ether after the buy
1434         uint256 remaining = msg.value.sub(price);
1435 
1436         // Dont worry if you sent extra, We will return you the change.
1437         if (remaining > 0) {
1438             (bool success, ) = msg.sender.call{value: remaining}("");
1439             require(success);
1440         }
1441     }
1442 
1443 
1444     function calcStartingIndex() public onlyOwner {
1445         require(startingIndex == 0, "Starting index has already been set");
1446         require(startingIndexBlock != 0, "Starting index has not been set yet");
1447 
1448         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_SUPPLY;
1449         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1450         if(block.number.sub(startingIndexBlock) > 255) {
1451             startingIndex = uint(blockhash(block.number - 1)) % MAX_SUPPLY;
1452         }
1453 
1454         // To prevent original sequence
1455         if (startingIndex == 0) {
1456             startingIndex = startingIndex.add(1);
1457         }
1458     }
1459 
1460     function emergencySetStartingIndexBlock() public onlyOwner {
1461         require(startingIndex == 0, "Starting index is already set");
1462         startingIndexBlock = block.number;
1463     }
1464 
1465     function _baseURI() internal view virtual override returns (string memory) {
1466         return _baseURIExtended;
1467     }
1468 
1469     // Sets base URI for all tokens, only able to be called by contract owner
1470     function setBaseURI(string memory baseURI_) external onlyOwner {
1471         _baseURIExtended = baseURI_;
1472     }
1473 
1474     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1475         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1476 
1477         string memory _tokenURI = _tokenURIs[tokenId];
1478         string memory base = _baseURI();
1479 
1480         // If there is no base URI, return the token URI.
1481         if (bytes(base).length == 0) {
1482             return _tokenURI;
1483         }
1484         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1485         if (bytes(_tokenURI).length > 0) {
1486             return string(abi.encodePacked(base, _tokenURI));
1487         }
1488         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1489         return string(abi.encodePacked(base, tokenId.toString()));
1490     }
1491 }