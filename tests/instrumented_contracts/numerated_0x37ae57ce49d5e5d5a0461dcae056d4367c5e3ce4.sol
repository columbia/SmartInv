1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 
49 /**
50  * @dev Required interface of an ERC721 compliant contract.
51  */
52 interface IERC721 is IERC165 {
53     /**
54      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
55      */
56     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
57 
58     /**
59      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
60      */
61     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
65      */
66     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(address from, address to, uint256 tokenId) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(uint256 tokenId) external view returns (address operator);
137 
138     /**
139      * @dev Approve or remove `operator` as an operator for the caller.
140      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
141      *
142      * Requirements:
143      *
144      * - The `operator` cannot be the caller.
145      *
146      * Emits an {ApprovalForAll} event.
147      */
148     function setApprovalForAll(address operator, bool _approved) external;
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator) external view returns (bool);
156 
157     /**
158       * @dev Safely transfers `tokenId` token from `from` to `to`.
159       *
160       * Requirements:
161       *
162       * - `from` cannot be the zero address.
163       * - `to` cannot be the zero address.
164       * - `tokenId` token must exist and be owned by `from`.
165       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
166       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167       *
168       * Emits a {Transfer} event.
169       */
170     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
171 }
172 
173 
174 /**
175  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
176  * @dev See https://eips.ethereum.org/EIPS/eip-721
177  */
178 interface IERC721Metadata is IERC721 {
179 
180     /**
181      * @dev Returns the token collection name.
182      */
183     function name() external view returns (string memory);
184 
185     /**
186      * @dev Returns the token collection symbol.
187      */
188     function symbol() external view returns (string memory);
189 
190     /**
191      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
192      */
193     function tokenURI(uint256 tokenId) external view returns (string memory);
194 }
195 
196 
197 /**
198  * @title ERC721 token receiver interface
199  * @dev Interface for any contract that wants to support safeTransfers
200  * from ERC721 asset contracts.
201  */
202 interface IERC721Receiver {
203     /**
204      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
205      * by `operator` from `from`, this function is called.
206      *
207      * It must return its Solidity selector to confirm the token transfer.
208      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
209      *
210      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
211      */
212     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
213 }
214 
215 
216 /**
217  * @dev Implementation of the {IERC165} interface.
218  *
219  * Contracts may inherit from this and call {_registerInterface} to declare
220  * their support of an interface.
221  */
222 abstract contract ERC165 is IERC165 {
223     /*
224      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
225      */
226     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
227 
228     /**
229      * @dev Mapping of interface ids to whether or not it's supported.
230      */
231     mapping(bytes4 => bool) private _supportedInterfaces;
232 
233     constructor () {
234         // Derived contracts need only register support for their own interfaces,
235         // we register support for ERC165 itself here
236         _registerInterface(_INTERFACE_ID_ERC165);
237     }
238 
239     /**
240      * @dev See {IERC165-supportsInterface}.
241      *
242      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
243      */
244     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
245         return _supportedInterfaces[interfaceId];
246     }
247 
248     /**
249      * @dev Registers the contract as an implementer of the interface defined by
250      * `interfaceId`. Support of the actual ERC165 interface is automatic and
251      * registering its interface id is not required.
252      *
253      * See {IERC165-supportsInterface}.
254      *
255      * Requirements:
256      *
257      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
258      */
259     function _registerInterface(bytes4 interfaceId) internal virtual {
260         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
261         _supportedInterfaces[interfaceId] = true;
262     }
263 }
264 
265 
266 /**
267  * @dev Wrappers over Solidity's arithmetic operations with added overflow
268  * checks.
269  *
270  * Arithmetic operations in Solidity wrap on overflow. This can easily result
271  * in bugs, because programmers usually assume that an overflow raises an
272  * error, which is the standard behavior in high level programming languages.
273  * `SafeMath` restores this intuition by reverting the transaction when an
274  * operation overflows.
275  *
276  * Using this library instead of the unchecked operations eliminates an entire
277  * class of bugs, so it's recommended to use it always.
278  */
279 library SafeMath {
280     /**
281      * @dev Returns the addition of two unsigned integers, with an overflow flag.
282      *
283      * _Available since v3.4._
284      */
285     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         uint256 c = a + b;
287         if (c < a) return (false, 0);
288         return (true, c);
289     }
290 
291     /**
292      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
293      *
294      * _Available since v3.4._
295      */
296     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
297         if (b > a) return (false, 0);
298         return (true, a - b);
299     }
300 
301     /**
302      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
303      *
304      * _Available since v3.4._
305      */
306     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
307         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
308         // benefit is lost if 'b' is also tested.
309         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
310         if (a == 0) return (true, 0);
311         uint256 c = a * b;
312         if (c / a != b) return (false, 0);
313         return (true, c);
314     }
315 
316     /**
317      * @dev Returns the division of two unsigned integers, with a division by zero flag.
318      *
319      * _Available since v3.4._
320      */
321     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
322         if (b == 0) return (false, 0);
323         return (true, a / b);
324     }
325 
326     /**
327      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
328      *
329      * _Available since v3.4._
330      */
331     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
332         if (b == 0) return (false, 0);
333         return (true, a % b);
334     }
335 
336     /**
337      * @dev Returns the addition of two unsigned integers, reverting on
338      * overflow.
339      *
340      * Counterpart to Solidity's `+` operator.
341      *
342      * Requirements:
343      *
344      * - Addition cannot overflow.
345      */
346     function add(uint256 a, uint256 b) internal pure returns (uint256) {
347         uint256 c = a + b;
348         require(c >= a, "SafeMath: addition overflow");
349         return c;
350     }
351 
352     /**
353      * @dev Returns the subtraction of two unsigned integers, reverting on
354      * overflow (when the result is negative).
355      *
356      * Counterpart to Solidity's `-` operator.
357      *
358      * Requirements:
359      *
360      * - Subtraction cannot overflow.
361      */
362     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
363         require(b <= a, "SafeMath: subtraction overflow");
364         return a - b;
365     }
366 
367     /**
368      * @dev Returns the multiplication of two unsigned integers, reverting on
369      * overflow.
370      *
371      * Counterpart to Solidity's `*` operator.
372      *
373      * Requirements:
374      *
375      * - Multiplication cannot overflow.
376      */
377     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
378         if (a == 0) return 0;
379         uint256 c = a * b;
380         require(c / a == b, "SafeMath: multiplication overflow");
381         return c;
382     }
383 
384     /**
385      * @dev Returns the integer division of two unsigned integers, reverting on
386      * division by zero. The result is rounded towards zero.
387      *
388      * Counterpart to Solidity's `/` operator. Note: this function uses a
389      * `revert` opcode (which leaves remaining gas untouched) while Solidity
390      * uses an invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      *
394      * - The divisor cannot be zero.
395      */
396     function div(uint256 a, uint256 b) internal pure returns (uint256) {
397         require(b > 0, "SafeMath: division by zero");
398         return a / b;
399     }
400 
401     /**
402      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
403      * reverting when dividing by zero.
404      *
405      * Counterpart to Solidity's `%` operator. This function uses a `revert`
406      * opcode (which leaves remaining gas untouched) while Solidity uses an
407      * invalid opcode to revert (consuming all remaining gas).
408      *
409      * Requirements:
410      *
411      * - The divisor cannot be zero.
412      */
413     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
414         require(b > 0, "SafeMath: modulo by zero");
415         return a % b;
416     }
417 
418     /**
419      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
420      * overflow (when the result is negative).
421      *
422      * CAUTION: This function is deprecated because it requires allocating memory for the error
423      * message unnecessarily. For custom revert reasons use {trySub}.
424      *
425      * Counterpart to Solidity's `-` operator.
426      *
427      * Requirements:
428      *
429      * - Subtraction cannot overflow.
430      */
431     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
432         require(b <= a, errorMessage);
433         return a - b;
434     }
435 
436     /**
437      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
438      * division by zero. The result is rounded towards zero.
439      *
440      * CAUTION: This function is deprecated because it requires allocating memory for the error
441      * message unnecessarily. For custom revert reasons use {tryDiv}.
442      *
443      * Counterpart to Solidity's `/` operator. Note: this function uses a
444      * `revert` opcode (which leaves remaining gas untouched) while Solidity
445      * uses an invalid opcode to revert (consuming all remaining gas).
446      *
447      * Requirements:
448      *
449      * - The divisor cannot be zero.
450      */
451     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
452         require(b > 0, errorMessage);
453         return a / b;
454     }
455 
456     /**
457      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
458      * reverting with custom message when dividing by zero.
459      *
460      * CAUTION: This function is deprecated because it requires allocating memory for the error
461      * message unnecessarily. For custom revert reasons use {tryMod}.
462      *
463      * Counterpart to Solidity's `%` operator. This function uses a `revert`
464      * opcode (which leaves remaining gas untouched) while Solidity uses an
465      * invalid opcode to revert (consuming all remaining gas).
466      *
467      * Requirements:
468      *
469      * - The divisor cannot be zero.
470      */
471     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
472         require(b > 0, errorMessage);
473         return a % b;
474     }
475 }
476 
477 
478 /**
479  * @dev Collection of functions related to the address type
480  */
481 library Address {
482     /**
483      * @dev Returns true if `account` is a contract.
484      *
485      * [IMPORTANT]
486      * ====
487      * It is unsafe to assume that an address for which this function returns
488      * false is an externally-owned account (EOA) and not a contract.
489      *
490      * Among others, `isContract` will return false for the following
491      * types of addresses:
492      *
493      *  - an externally-owned account
494      *  - a contract in construction
495      *  - an address where a contract will be created
496      *  - an address where a contract lived, but was destroyed
497      * ====
498      */
499     function isContract(address account) internal view returns (bool) {
500         // This method relies on extcodesize, which returns 0 for contracts in
501         // construction, since the code is only stored at the end of the
502         // constructor execution.
503 
504         uint256 size;
505         // solhint-disable-next-line no-inline-assembly
506         assembly { size := extcodesize(account) }
507         return size > 0;
508     }
509 
510     /**
511      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
512      * `recipient`, forwarding all available gas and reverting on errors.
513      *
514      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas price
515      * of certain opcodes, possibly making contracts go over the 2300 gas limit
516      * imposed by `transfer`, making them unable to receive funds via
517      * `transfer`. {sendValue} removes this limitation.
518      *
519      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
520      *
521      * IMPORTANT: because control is transferred to `recipient`, care must be
522      * taken to not create reentrancy vulnerabilities. Consider using
523      * {ReentrancyGuard} or the
524      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
525      */
526     function sendValue(address payable recipient, uint256 amount) internal {
527         require(address(this).balance >= amount, "Address: insufficient balance");
528 
529         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
530         (bool success, ) = recipient.call{ value: amount }("");
531         require(success, "Address: unable to send value, recipient may have reverted");
532     }
533 
534     /**
535      * @dev Performs a Solidity function call using a low level `call`. A
536      * plain`call` is an unsafe replacement for a function call: use this
537      * function instead.
538      *
539      * If `target` reverts with a revert reason, it is bubbled up by this
540      * function (like regular Solidity function calls).
541      *
542      * Returns the raw returned data. To convert to the expected return value,
543      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
544      *
545      * Requirements:
546      *
547      * - `target` must be a contract.
548      * - calling `target` with `data` must not revert.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
553       return functionCall(target, data, "Address: low-level call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
558      * `errorMessage` as a fallback revert reason when `target` reverts.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
563         return functionCallWithValue(target, data, 0, errorMessage);
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
568      * but also transferring `value` wei to `target`.
569      *
570      * Requirements:
571      *
572      * - the calling contract must have an ETH balance of at least `value`.
573      * - the called Solidity function must be `payable`.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
583      * with `errorMessage` as a fallback revert reason when `target` reverts.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
588         require(address(this).balance >= value, "Address: insufficient balance for call");
589         require(isContract(target), "Address: call to non-contract");
590 
591         // solhint-disable-next-line avoid-low-level-calls
592         (bool success, bytes memory returndata) = target.call{ value: value }(data);
593         return _verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
603         return functionStaticCall(target, data, "Address: low-level static call failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
608      * but performing a static call.
609      *
610      * _Available since v3.3._
611      */
612     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
613         require(isContract(target), "Address: static call to non-contract");
614 
615         // solhint-disable-next-line avoid-low-level-calls
616         (bool success, bytes memory returndata) = target.staticcall(data);
617         return _verifyCallResult(success, returndata, errorMessage);
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
627         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
632      * but performing a delegate call.
633      *
634      * _Available since v3.4._
635      */
636     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
637         require(isContract(target), "Address: delegate call to non-contract");
638 
639         // solhint-disable-next-line avoid-low-level-calls
640         (bool success, bytes memory returndata) = target.delegatecall(data);
641         return _verifyCallResult(success, returndata, errorMessage);
642     }
643 
644     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
645         if (success) {
646             return returndata;
647         } else {
648             // Look for revert reason and bubble it up if present
649             if (returndata.length > 0) {
650                 // The easiest way to bubble the revert reason is using memory via assembly
651 
652                 // solhint-disable-next-line no-inline-assembly
653                 assembly {
654                     let returndata_size := mload(returndata)
655                     revert(add(32, returndata), returndata_size)
656                 }
657             } else {
658                 revert(errorMessage);
659             }
660         }
661     }
662 }
663 
664 
665 /**
666  * @dev String operations.
667  */
668 library Strings {
669     bytes16 private constant alphabet = "0123456789abcdef";
670 
671     /**
672      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
673      */
674     function toString(uint256 value) internal pure returns (string memory) {
675         // Inspired by OraclizeAPI's implementation - MIT licence
676         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
677 
678         if (value == 0) {
679             return "0";
680         }
681         uint256 temp = value;
682         uint256 digits;
683         while (temp != 0) {
684             digits++;
685             temp /= 10;
686         }
687         bytes memory buffer = new bytes(digits);
688         while (value != 0) {
689             digits -= 1;
690             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
691             value /= 10;
692         }
693         return string(buffer);
694     }
695 
696     /**
697      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
698      */
699     function toHexString(uint256 value) internal pure returns (string memory) {
700         if (value == 0) {
701             return "0x00";
702         }
703         uint256 temp = value;
704         uint256 length = 0;
705         while (temp != 0) {
706             length++;
707             temp >>= 8;
708         }
709         return toHexString(value, length);
710     }
711 
712     /**
713      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
714      */
715     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
716         bytes memory buffer = new bytes(2 * length + 2);
717         buffer[0] = "0";
718         buffer[1] = "x";
719         for (uint256 i = 2 * length + 1; i > 1; --i) {
720             buffer[i] = alphabet[value & 0xf];
721             value >>= 4;
722         }
723         require(value == 0, "Strings: hex length insufficient");
724         return string(buffer);
725     }
726 
727 }
728 
729 
730 /**
731  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
732  * @dev See https://eips.ethereum.org/EIPS/eip-721
733  */
734 interface IERC721Enumerable is IERC721 {
735     /**
736      * @dev Returns the total amount of tokens stored by the contract.
737      */
738     function totalSupply() external view returns (uint256);
739 
740     /**
741      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
742      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
743      */
744     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
745 
746     /**
747      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
748      * Use along with {totalSupply} to enumerate all tokens.
749      */
750     function tokenByIndex(uint256 index) external view returns (uint256);
751 }
752 
753 
754 /**
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
757  *
758  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
759  *
760  * Does not support burning tokens to address(0).
761  *
762  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
763  */
764 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
765     using Address for address;
766     using Strings for uint256;
767 
768     struct TokenOwnership {
769         address addr;
770         uint64 startTimestamp;
771     }
772 
773     struct AddressData {
774         uint128 balance;
775         uint128 numberMinted;
776     }
777 
778     uint256 internal currentIndex;
779 
780     // Token name
781     string private _name;
782 
783     // Token symbol
784     string private _symbol;
785 
786     // Mapping from token ID to ownership details
787     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
788     mapping(uint256 => TokenOwnership) internal _ownerships;
789 
790     // Mapping owner address to address data
791     mapping(address => AddressData) private _addressData;
792 
793     // Mapping from token ID to approved address
794     mapping(uint256 => address) private _tokenApprovals;
795 
796     // Mapping from owner to operator approvals
797     mapping(address => mapping(address => bool)) private _operatorApprovals;
798 
799     constructor(string memory name_, string memory symbol_) {
800         _name = name_;
801         _symbol = symbol_;
802     }
803 
804     /**
805      * @dev See {IERC721Enumerable-totalSupply}.
806      */
807     function totalSupply() public view override returns (uint256) {
808         return currentIndex;
809     }
810 
811     /**
812      * @dev See {IERC721Enumerable-tokenByIndex}.
813      */
814     function tokenByIndex(uint256 index) public view override returns (uint256) {
815         require(index < totalSupply(), 'ERC721A: global index out of bounds');
816         return index;
817     }
818 
819     /**
820      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
821      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
822      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
823      */
824     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
825         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
826         uint256 numMintedSoFar = totalSupply();
827         uint256 tokenIdsIdx;
828         address currOwnershipAddr;
829 
830         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
831         unchecked {
832             for (uint256 i; i < numMintedSoFar; i++) {
833                 TokenOwnership memory ownership = _ownerships[i];
834                 if (ownership.addr != address(0)) {
835                     currOwnershipAddr = ownership.addr;
836                 }
837                 if (currOwnershipAddr == owner) {
838                     if (tokenIdsIdx == index) {
839                         return i;
840                     }
841                     tokenIdsIdx++;
842                 }
843             }
844         }
845 
846         revert('ERC721A: unable to get token of owner by index');
847     }
848 
849     /**
850      * @dev See {IERC165-supportsInterface}.
851      */
852     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
853         return
854             interfaceId == type(IERC721).interfaceId ||
855             interfaceId == type(IERC721Metadata).interfaceId ||
856             interfaceId == type(IERC721Enumerable).interfaceId ||
857             super.supportsInterface(interfaceId);
858     }
859 
860     /**
861      * @dev See {IERC721-balanceOf}.
862      */
863     function balanceOf(address owner) public view override returns (uint256) {
864         require(owner != address(0), 'ERC721A: balance query for the zero address');
865         return uint256(_addressData[owner].balance);
866     }
867 
868     function _numberMinted(address owner) internal view returns (uint256) {
869         require(owner != address(0), 'ERC721A: number minted query for the zero address');
870         return uint256(_addressData[owner].numberMinted);
871     }
872 
873     /**
874      * Gas spent here starts off proportional to the maximum mint batch size.
875      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
876      */
877     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
878         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
879 
880         unchecked {
881             for (uint256 curr = tokenId; curr >= 0; curr--) {
882                 TokenOwnership memory ownership = _ownerships[curr];
883                 if (ownership.addr != address(0)) {
884                     return ownership;
885                 }
886             }
887         }
888 
889         revert('ERC721A: unable to determine the owner of token');
890     }
891 
892     /**
893      * @dev See {IERC721-ownerOf}.
894      */
895     function ownerOf(uint256 tokenId) public view override returns (address) {
896         return ownershipOf(tokenId).addr;
897     }
898 
899     /**
900      * @dev See {IERC721Metadata-name}.
901      */
902     function name() public view virtual override returns (string memory) {
903         return _name;
904     }
905 
906     /**
907      * @dev See {IERC721Metadata-symbol}.
908      */
909     function symbol() public view virtual override returns (string memory) {
910         return _symbol;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-tokenURI}.
915      */
916     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
917         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
918 
919         string memory baseURI = _baseURI();
920         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
921     }
922 
923     /**
924      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
925      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
926      * by default, can be overriden in child contracts.
927      */
928     function _baseURI() internal view virtual returns (string memory) {
929         return '';
930     }
931 
932     /**
933      * @dev See {IERC721-approve}.
934      */
935     function approve(address to, uint256 tokenId) public override {
936         address owner = ERC721A.ownerOf(tokenId);
937         require(to != owner, 'ERC721A: approval to current owner');
938 
939         require(
940             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
941             'ERC721A: approve caller is not owner nor approved for all'
942         );
943 
944         _approve(to, tokenId, owner);
945     }
946 
947     /**
948      * @dev See {IERC721-getApproved}.
949      */
950     function getApproved(uint256 tokenId) public view override returns (address) {
951         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
952 
953         return _tokenApprovals[tokenId];
954     }
955 
956     /**
957      * @dev See {IERC721-setApprovalForAll}.
958      */
959     function setApprovalForAll(address operator, bool approved) public override {
960         require(operator != _msgSender(), 'ERC721A: approve to caller');
961 
962         _operatorApprovals[_msgSender()][operator] = approved;
963         emit ApprovalForAll(_msgSender(), operator, approved);
964     }
965 
966     /**
967      * @dev See {IERC721-isApprovedForAll}.
968      */
969     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
970         return _operatorApprovals[owner][operator];
971     }
972 
973     /**
974      * @dev See {IERC721-transferFrom}.
975      */
976     function transferFrom(
977         address from,
978         address to,
979         uint256 tokenId
980     ) public override {
981         _transfer(from, to, tokenId);
982     }
983 
984     /**
985      * @dev See {IERC721-safeTransferFrom}.
986      */
987     function safeTransferFrom(
988         address from,
989         address to,
990         uint256 tokenId
991     ) public override {
992         safeTransferFrom(from, to, tokenId, '');
993     }
994 
995     /**
996      * @dev See {IERC721-safeTransferFrom}.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) public override {
1004         _transfer(from, to, tokenId);
1005         require(
1006             _checkOnERC721Received(from, to, tokenId, _data),
1007             'ERC721A: transfer to non ERC721Receiver implementer'
1008         );
1009     }
1010 
1011     /**
1012      * @dev Returns whether `tokenId` exists.
1013      *
1014      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1015      *
1016      * Tokens start existing when they are minted (`_mint`),
1017      */
1018     function _exists(uint256 tokenId) internal view returns (bool) {
1019         return tokenId < currentIndex;
1020     }
1021 
1022     function _safeMint(address to, uint256 quantity) internal {
1023         _safeMint(to, quantity, '');
1024     }
1025 
1026     /**
1027      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1032      * - `quantity` must be greater than 0.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _safeMint(
1037         address to,
1038         uint256 quantity,
1039         bytes memory _data
1040     ) internal {
1041         _mint(to, quantity, _data, true);
1042     }
1043 
1044     /**
1045      * @dev Mints `quantity` tokens and transfers them to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `to` cannot be the zero address.
1050      * - `quantity` must be greater than 0.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054 
1055     function _mint(
1056         address to,
1057         uint256 quantity,
1058         bytes memory _data,
1059         bool safe
1060     ) internal {
1061         uint256 startTokenId = currentIndex;
1062         require(to != address(0), 'ERC721A: mint to the zero address');
1063         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1064 
1065         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1066 
1067         // Overflows are incredibly unrealistic.
1068         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1069         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1070         unchecked {
1071             _addressData[to].balance += uint128(quantity);
1072             _addressData[to].numberMinted += uint128(quantity);
1073 
1074             _ownerships[startTokenId].addr = to;
1075             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1076 
1077             uint256 updatedIndex = startTokenId;
1078 
1079             for (uint256 i; i < quantity; i++) {
1080                 emit Transfer(address(0), to, updatedIndex);
1081                 if (safe) {
1082                     require(
1083                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1084                         'ERC721A: transfer to non ERC721Receiver implementer'
1085                     );
1086                 }
1087 
1088                 updatedIndex++;
1089             }
1090 
1091             currentIndex = updatedIndex;
1092         }
1093 
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Transfers `tokenId` from `from` to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) private {
1112         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1113 
1114         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1115             getApproved(tokenId) == _msgSender() ||
1116             isApprovedForAll(prevOwnership.addr, _msgSender()));
1117 
1118         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1119 
1120         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1121         require(to != address(0), 'ERC721A: transfer to the zero address');
1122 
1123         _beforeTokenTransfers(from, to, tokenId, 1);
1124 
1125         // Clear approvals from the previous owner
1126         _approve(address(0), tokenId, prevOwnership.addr);
1127 
1128         // Underflow of the sender's balance is impossible because we check for
1129         // ownership above and the recipient's balance can't realistically overflow.
1130         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1131         unchecked {
1132             _addressData[from].balance -= 1;
1133             _addressData[to].balance += 1;
1134 
1135             _ownerships[tokenId].addr = to;
1136             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1137 
1138             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1139             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1140             uint256 nextTokenId = tokenId + 1;
1141             if (_ownerships[nextTokenId].addr == address(0)) {
1142                 if (_exists(nextTokenId)) {
1143                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1144                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1145                 }
1146             }
1147         }
1148 
1149         emit Transfer(from, to, tokenId);
1150         _afterTokenTransfers(from, to, tokenId, 1);
1151     }
1152 
1153     /**
1154      * @dev Approve `to` to operate on `tokenId`
1155      *
1156      * Emits a {Approval} event.
1157      */
1158     function _approve(
1159         address to,
1160         uint256 tokenId,
1161         address owner
1162     ) private {
1163         _tokenApprovals[tokenId] = to;
1164         emit Approval(owner, to, tokenId);
1165     }
1166 
1167     /**
1168      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1169      * The call is not executed if the target address is not a contract.
1170      *
1171      * @param from address representing the previous owner of the given token ID
1172      * @param to target address that will receive the tokens
1173      * @param tokenId uint256 ID of the token to be transferred
1174      * @param _data bytes optional data to send along with the call
1175      * @return bool whether the call correctly returned the expected magic value
1176      */
1177     function _checkOnERC721Received(
1178         address from,
1179         address to,
1180         uint256 tokenId,
1181         bytes memory _data
1182     ) private returns (bool) {
1183         if (to.isContract()) {
1184             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1185                 return retval == IERC721Receiver(to).onERC721Received.selector;
1186             } catch (bytes memory reason) {
1187                 if (reason.length == 0) {
1188                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1189                 } else {
1190                     assembly {
1191                         revert(add(32, reason), mload(reason))
1192                     }
1193                 }
1194             }
1195         } else {
1196             return true;
1197         }
1198     }
1199 
1200     /**
1201      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1202      *
1203      * startTokenId - the first token id to be transferred
1204      * quantity - the amount to be transferred
1205      *
1206      * Calling conditions:
1207      *
1208      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1209      * transferred to `to`.
1210      * - When `from` is zero, `tokenId` will be minted for `to`.
1211      */
1212     function _beforeTokenTransfers(
1213         address from,
1214         address to,
1215         uint256 startTokenId,
1216         uint256 quantity
1217     ) internal virtual {}
1218 
1219     /**
1220      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1221      * minting.
1222      *
1223      * startTokenId - the first token id to be transferred
1224      * quantity - the amount to be transferred
1225      *
1226      * Calling conditions:
1227      *
1228      * - when `from` and `to` are both non-zero.
1229      * - `from` and `to` are never both zero.
1230      */
1231     function _afterTokenTransfers(
1232         address from,
1233         address to,
1234         uint256 startTokenId,
1235         uint256 quantity
1236     ) internal virtual {}
1237 }
1238 
1239 
1240 /**
1241  * @dev Contract module which provides a basic access control mechanism, where
1242  * there is an account (an owner) that can be granted exclusive access to
1243  * specific functions.
1244  *
1245  * By default, the owner account will be the one that deploys the contract. This
1246  * can later be changed with {transferOwnership}.
1247  *
1248  * This module is used through inheritance. It will make available the modifier
1249  * `onlyOwner`, which can be applied to your functions to restrict their use to
1250  * the owner.
1251  */
1252 abstract contract Ownable is Context {
1253     address private _owner;
1254 
1255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1256 
1257     /**
1258      * @dev Initializes the contract setting the deployer as the initial owner.
1259      */
1260     constructor() {
1261         _transferOwnership(_msgSender());
1262     }
1263 
1264     /**
1265      * @dev Returns the address of the current owner.
1266      */
1267     function owner() public view virtual returns (address) {
1268         return _owner;
1269     }
1270 
1271     /**
1272      * @dev Throws if called by any account other than the owner.
1273      */
1274     modifier onlyOwner() {
1275         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1276         _;
1277     }
1278 
1279     /**
1280      * @dev Leaves the contract without owner. It will not be possible to call
1281      * `onlyOwner` functions anymore. Can only be called by the current owner.
1282      *
1283      * NOTE: Renouncing ownership will leave the contract without an owner,
1284      * thereby removing any functionality that is only available to the owner.
1285      */
1286     function renounceOwnership() public virtual onlyOwner {
1287         _transferOwnership(address(0));
1288     }
1289 
1290     /**
1291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1292      * Can only be called by the current owner.
1293      */
1294     function transferOwnership(address newOwner) public virtual onlyOwner {
1295         require(newOwner != address(0), "Ownable: new owner is the zero address");
1296         _transferOwnership(newOwner);
1297     }
1298 
1299     /**
1300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1301      * Internal function without access restriction.
1302      */
1303     function _transferOwnership(address newOwner) internal virtual {
1304         address oldOwner = _owner;
1305         _owner = newOwner;
1306         emit OwnershipTransferred(oldOwner, newOwner);
1307     }
1308 }
1309 
1310 
1311 /**
1312  * @title F NFT Smart Contract
1313  */
1314 contract CryptoFries is ERC721A, Ownable {
1315      string public baseExtension = ".json";
1316      uint256 public cost = 0.035 ether;
1317      string private baseTokenURI;
1318      string private notRevealedUri;
1319      bool public revealed = false;
1320      uint256 public maxSupply = 3210;
1321      uint256 public maxFreeMint = 640;
1322      uint256 public maxPaidMint = 2500;
1323      uint256 public maxAmountWallet = 50;
1324      uint256 public maxMintSupply =
1325         maxFreeMint + maxPaidMint;
1326      uint256 public maxFreeAmountPerWallet = 2;
1327      uint256 public mintedAmount = 0;
1328 
1329      bool public publicActive = false;
1330              mapping(address => uint256) public minterToTokenAmount;
1331      address proxyRegistryAddress;
1332 
1333 
1334 
1335 
1336     constructor(string memory _notRevealedUri) ERC721A("Crypto Fries", "CF") {
1337         notRevealedUri = _notRevealedUri;
1338     }
1339     
1340     
1341    function mint(uint256 quantity) external payable {
1342                 require(publicActive, "Sale must be active to mint a Fry");
1343         if (mintedAmount < maxFreeMint) {
1344             //Als de totale mintamount onder de maxFreeMint ligt
1345             if(balanceOf(msg.sender) < maxFreeAmountPerWallet){
1346                 //Als de balance van de minter onder het maximale per wallet ligt
1347                 //Dan free
1348                 require(mintedAmount + quantity <= maxFreeMint, "MAXL");
1349                 require(
1350                     minterToTokenAmount[msg.sender] + quantity <= maxFreeAmountPerWallet,
1351                     "MAXF"
1352                 );
1353             }
1354             
1355             else {
1356                 //ander paid
1357                 require(mintedAmount + quantity <= maxMintSupply, "MAXL");
1358                 require(
1359                     minterToTokenAmount[msg.sender] + quantity <= maxAmountWallet,
1360                     "MAXP"
1361                 );
1362                 require(msg.value >= cost * quantity, "SETH");
1363             }
1364         } else {
1365             //Als de totale mintamount boven de maxFreeMint ligt
1366             require(mintedAmount + quantity <= maxMintSupply, "MAXL");
1367             require(
1368                 minterToTokenAmount[msg.sender] + quantity <= maxAmountWallet,
1369                 "MAXP"
1370             );
1371             require(msg.value >= cost * quantity, "SETH");
1372         }
1373 
1374 
1375         mintedAmount += quantity;
1376         minterToTokenAmount[msg.sender] += quantity;
1377         _safeMint(msg.sender, quantity);
1378         
1379     }
1380 
1381     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
1382         notRevealedUri = _notRevealedURI;
1383     }
1384 
1385      function setBaseTokenURI(string memory _baseTokenURI) external onlyOwner {
1386         baseTokenURI = _baseTokenURI;
1387     } 
1388 
1389     function _baseURI() internal view override virtual returns (string memory) {
1390 	    return baseTokenURI;
1391 	}
1392    
1393     function setRevealed(bool _state) external  onlyOwner {
1394         revealed = _state;
1395     } 
1396 
1397 
1398         function reserve(address target, uint256 quantity) external onlyOwner {
1399         require(totalSupply() + quantity <= maxSupply, "Cryptofries/sold-out");
1400 
1401         _safeMint(target, quantity);
1402     }
1403 
1404 
1405 
1406     function tokenURI(uint256 tokenId)
1407         public
1408         view
1409         virtual
1410         override
1411         returns (string memory)
1412     {
1413         require(
1414         _exists(tokenId),
1415         "ERC721Metadata: URI query for nonexistent token"
1416         );
1417         
1418         if(!revealed) {
1419             return notRevealedUri;
1420         }
1421 
1422         string memory currentBaseURI = _baseURI();
1423 
1424         return bytes(currentBaseURI).length > 0
1425             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId)))
1426             : "";
1427     }
1428 
1429 
1430 
1431 
1432      function setMaxFreeAmountPerTx(uint256 _maxAmountPerTx) external onlyOwner {
1433         maxFreeAmountPerWallet = _maxAmountPerTx;
1434     }
1435 
1436     function setPublicActive(bool newStatus) external onlyOwner {
1437         publicActive = newStatus;
1438     }
1439 
1440      function setCost(uint256 _newCost) public onlyOwner {
1441     cost = _newCost;
1442     }
1443 
1444     function withdrawToSender() external onlyOwner {
1445         uint256 balance = address(this).balance;
1446         payable(msg.sender).transfer(balance);
1447     }
1448 
1449     function withdrawAll() external onlyOwner {
1450         require(address(this).balance > 0, "ZERO");
1451         payable(msg.sender).transfer(address(this).balance);
1452     }
1453 
1454      
1455   function withdraw() public payable onlyOwner {
1456     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1457     require(os);
1458   }
1459   
1460 }