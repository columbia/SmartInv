1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 
5 library Strings {
6     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
7 
8     /**
9      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
10      */
11     function toString(uint256 value) internal pure returns (string memory) {
12         // Inspired by OraclizeAPI's implementation - MIT licence
13         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
14 
15         if (value == 0) {
16             return "0";
17         }
18         uint256 temp = value;
19         uint256 digits;
20         while (temp != 0) {
21             digits++;
22             temp /= 10;
23         }
24         bytes memory buffer = new bytes(digits);
25         while (value != 0) {
26             digits -= 1;
27             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
28             value /= 10;
29         }
30         return string(buffer);
31     }
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
35      */
36     function toHexString(uint256 value) internal pure returns (string memory) {
37         if (value == 0) {
38             return "0x00";
39         }
40         uint256 temp = value;
41         uint256 length = 0;
42         while (temp != 0) {
43             length++;
44             temp >>= 8;
45         }
46         return toHexString(value, length);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
51      */
52     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
53         bytes memory buffer = new bytes(2 * length + 2);
54         buffer[0] = "0";
55         buffer[1] = "x";
56         for (uint256 i = 2 * length + 1; i > 1; --i) {
57             buffer[i] = _HEX_SYMBOLS[value & 0xf];
58             value >>= 4;
59         }
60         require(value == 0, "Strings: hex length insufficient");
61         return string(buffer);
62     }
63 }
64 
65 library Counters {
66     struct Counter {
67         // This variable should never be directly accessed by users of the library: interactions must be restricted to
68         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
69         // this feature: see https://github.com/ethereum/solidity/issues/4637
70         uint256 _value; // default: 0
71     }
72 
73     function current(Counter storage counter) internal view returns (uint256) {
74         return counter._value;
75     }
76 
77     function increment(Counter storage counter) internal {
78         unchecked {
79             counter._value += 1;
80         }
81     }
82 
83     function decrement(Counter storage counter) internal {
84         uint256 value = counter._value;
85         require(value > 0, "Counter: decrement overflow");
86         unchecked {
87             counter._value = value - 1;
88         }
89     }
90 
91     function reset(Counter storage counter) internal {
92         counter._value = 0;
93     }
94 }
95 
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 library Address {
107     /**
108      * @dev Returns true if `account` is a contract.
109      *
110      * [IMPORTANT]
111      * ====
112      * It is unsafe to assume that an address for which this function returns
113      * false is an externally-owned account (EOA) and not a contract.
114      *
115      * Among others, `isContract` will return false for the following
116      * types of addresses:
117      *
118      *  - an externally-owned account
119      *  - a contract in construction
120      *  - an address where a contract will be created
121      *  - an address where a contract lived, but was destroyed
122      * ====
123      */
124     function isContract(address account) internal view returns (bool) {
125         // This method relies on extcodesize, which returns 0 for contracts in
126         // construction, since the code is only stored at the end of the
127         // constructor execution.
128 
129         uint256 size;
130         assembly {
131             size := extcodesize(account)
132         }
133         return size > 0;
134     }
135 
136     /**
137      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
138      * `recipient`, forwarding all available gas and reverting on errors.
139      *
140      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
141      * of certain opcodes, possibly making contracts go over the 2300 gas limit
142      * imposed by `transfer`, making them unable to receive funds via
143      * `transfer`. {sendValue} removes this limitation.
144      *
145      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
146      *
147      * IMPORTANT: because control is transferred to `recipient`, care must be
148      * taken to not create reentrancy vulnerabilities. Consider using
149      * {ReentrancyGuard} or the
150      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
151      */
152     function sendValue(address payable recipient, uint256 amount) internal {
153         require(address(this).balance >= amount, "Address: insufficient balance");
154 
155         (bool success, ) = recipient.call{value: amount}("");
156         require(success, "Address: unable to send value, recipient may have reverted");
157     }
158 
159     /**
160      * @dev Performs a Solidity function call using a low level `call`. A
161      * plain `call` is an unsafe replacement for a function call: use this
162      * function instead.
163      *
164      * If `target` reverts with a revert reason, it is bubbled up by this
165      * function (like regular Solidity function calls).
166      *
167      * Returns the raw returned data. To convert to the expected return value,
168      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
169      *
170      * Requirements:
171      *
172      * - `target` must be a contract.
173      * - calling `target` with `data` must not revert.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionCall(target, data, "Address: low-level call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
183      * `errorMessage` as a fallback revert reason when `target` reverts.
184      *
185      * _Available since v3.1._
186      */
187     function functionCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, 0, errorMessage);
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
197      * but also transferring `value` wei to `target`.
198      *
199      * Requirements:
200      *
201      * - the calling contract must have an ETH balance of at least `value`.
202      * - the called Solidity function must be `payable`.
203      *
204      * _Available since v3.1._
205      */
206     function functionCallWithValue(
207         address target,
208         bytes memory data,
209         uint256 value
210     ) internal returns (bytes memory) {
211         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
216      * with `errorMessage` as a fallback revert reason when `target` reverts.
217      *
218      * _Available since v3.1._
219      */
220     function functionCallWithValue(
221         address target,
222         bytes memory data,
223         uint256 value,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         require(address(this).balance >= value, "Address: insufficient balance for call");
227         require(isContract(target), "Address: call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.call{value: value}(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
240         return functionStaticCall(target, data, "Address: low-level static call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal view returns (bytes memory) {
254         require(isContract(target), "Address: static call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.staticcall(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
267         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a delegate call.
273      *
274      * _Available since v3.4._
275      */
276     function functionDelegateCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         require(isContract(target), "Address: delegate call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.delegatecall(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
289      * revert reason using the provided one.
290      *
291      * _Available since v4.3._
292      */
293     function verifyCallResult(
294         bool success,
295         bytes memory returndata,
296         string memory errorMessage
297     ) internal pure returns (bytes memory) {
298         if (success) {
299             return returndata;
300         } else {
301             // Look for revert reason and bubble it up if present
302             if (returndata.length > 0) {
303                 // The easiest way to bubble the revert reason is using memory via assembly
304 
305                 assembly {
306                     let returndata_size := mload(returndata)
307                     revert(add(32, returndata), returndata_size)
308                 }
309             } else {
310                 revert(errorMessage);
311             }
312         }
313     }
314 }
315 
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
325      */
326     function onERC721Received(
327         address operator,
328         address from,
329         uint256 tokenId,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 interface IERC165 {
335     /**
336      * @dev Returns true if this contract implements the interface defined by
337      * `interfaceId`. See the corresponding
338      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
339      * to learn more about how these ids are created.
340      *
341      * This function call must use less than 30 000 gas.
342      */
343     function supportsInterface(bytes4 interfaceId) external view returns (bool);
344 }
345 
346 abstract contract ERC165 is IERC165 {
347     /**
348      * @dev See {IERC165-supportsInterface}.
349      */
350     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
351         return interfaceId == type(IERC165).interfaceId;
352     }
353 }
354 
355 interface IERC721 is IERC165 {
356     /**
357      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
358      */
359     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
360 
361     /**
362      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
363      */
364     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
365 
366     /**
367      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
368      */
369     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
370 
371     /**
372      * @dev Returns the number of tokens in ``owner``'s account.
373      */
374     function balanceOf(address owner) external view returns (uint256 balance);
375 
376     /**
377      * @dev Returns the owner of the `tokenId` token.
378      *
379      * Requirements:
380      *
381      * - `tokenId` must exist.
382      */
383     function ownerOf(uint256 tokenId) external view returns (address owner);
384 
385     /**
386      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
387      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
388      *
389      * Requirements:
390      *
391      * - `from` cannot be the zero address.
392      * - `to` cannot be the zero address.
393      * - `tokenId` token must exist and be owned by `from`.
394      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
395      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
396      *
397      * Emits a {Transfer} event.
398      */
399     function safeTransferFrom(
400         address from,
401         address to,
402         uint256 tokenId
403     ) external;
404 
405     /**
406      * @dev Transfers `tokenId` token from `from` to `to`.
407      *
408      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
409      *
410      * Requirements:
411      *
412      * - `from` cannot be the zero address.
413      * - `to` cannot be the zero address.
414      * - `tokenId` token must be owned by `from`.
415      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
416      *
417      * Emits a {Transfer} event.
418      */
419     function transferFrom(
420         address from,
421         address to,
422         uint256 tokenId
423     ) external;
424 
425     /**
426      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
427      * The approval is cleared when the token is transferred.
428      *
429      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
430      *
431      * Requirements:
432      *
433      * - The caller must own the token or be an approved operator.
434      * - `tokenId` must exist.
435      *
436      * Emits an {Approval} event.
437      */
438     function approve(address to, uint256 tokenId) external;
439 
440     /**
441      * @dev Returns the account approved for `tokenId` token.
442      *
443      * Requirements:
444      *
445      * - `tokenId` must exist.
446      */
447     function getApproved(uint256 tokenId) external view returns (address operator);
448 
449     /**
450      * @dev Approve or remove `operator` as an operator for the caller.
451      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
452      *
453      * Requirements:
454      *
455      * - The `operator` cannot be the caller.
456      *
457      * Emits an {ApprovalForAll} event.
458      */
459     function setApprovalForAll(address operator, bool _approved) external;
460 
461     /**
462      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
463      *
464      * See {setApprovalForAll}
465      */
466     function isApprovedForAll(address owner, address operator) external view returns (bool);
467 
468     /**
469      * @dev Safely transfers `tokenId` token from `from` to `to`.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must exist and be owned by `from`.
476      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
477      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
478      *
479      * Emits a {Transfer} event.
480      */
481     function safeTransferFrom(
482         address from,
483         address to,
484         uint256 tokenId,
485         bytes calldata data
486     ) external;
487 }
488 
489 interface IERC721Metadata is IERC721 {
490     /**
491      * @dev Returns the token collection name.
492      */
493     function name() external view returns (string memory);
494 
495     /**
496      * @dev Returns the token collection symbol.
497      */
498     function symbol() external view returns (string memory);
499 
500     /**
501      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
502      */
503     function tokenURI(uint256 tokenId) external view returns (string memory);
504 }
505 
506 library SafeMath {
507     /**
508      * @dev Returns the addition of two unsigned integers, with an overflow flag.
509      *
510      * _Available since v3.4._
511      */
512     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
513         unchecked {
514             uint256 c = a + b;
515             if (c < a) return (false, 0);
516             return (true, c);
517         }
518     }
519 
520     /**
521      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
522      *
523      * _Available since v3.4._
524      */
525     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
526         unchecked {
527             if (b > a) return (false, 0);
528             return (true, a - b);
529         }
530     }
531 
532     /**
533      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
534      *
535      * _Available since v3.4._
536      */
537     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
538         unchecked {
539             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
540             // benefit is lost if 'b' is also tested.
541             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
542             if (a == 0) return (true, 0);
543             uint256 c = a * b;
544             if (c / a != b) return (false, 0);
545             return (true, c);
546         }
547     }
548 
549     /**
550      * @dev Returns the division of two unsigned integers, with a division by zero flag.
551      *
552      * _Available since v3.4._
553      */
554     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
555         unchecked {
556             if (b == 0) return (false, 0);
557             return (true, a / b);
558         }
559     }
560 
561     /**
562      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
563      *
564      * _Available since v3.4._
565      */
566     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
567         unchecked {
568             if (b == 0) return (false, 0);
569             return (true, a % b);
570         }
571     }
572 
573     /**
574      * @dev Returns the addition of two unsigned integers, reverting on
575      * overflow.
576      *
577      * Counterpart to Solidity's `+` operator.
578      *
579      * Requirements:
580      *
581      * - Addition cannot overflow.
582      */
583     function add(uint256 a, uint256 b) internal pure returns (uint256) {
584         return a + b;
585     }
586 
587     /**
588      * @dev Returns the subtraction of two unsigned integers, reverting on
589      * overflow (when the result is negative).
590      *
591      * Counterpart to Solidity's `-` operator.
592      *
593      * Requirements:
594      *
595      * - Subtraction cannot overflow.
596      */
597     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
598         return a - b;
599     }
600 
601     /**
602      * @dev Returns the multiplication of two unsigned integers, reverting on
603      * overflow.
604      *
605      * Counterpart to Solidity's `*` operator.
606      *
607      * Requirements:
608      *
609      * - Multiplication cannot overflow.
610      */
611     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
612         return a * b;
613     }
614 
615     /**
616      * @dev Returns the integer division of two unsigned integers, reverting on
617      * division by zero. The result is rounded towards zero.
618      *
619      * Counterpart to Solidity's `/` operator.
620      *
621      * Requirements:
622      *
623      * - The divisor cannot be zero.
624      */
625     function div(uint256 a, uint256 b) internal pure returns (uint256) {
626         return a / b;
627     }
628 
629     /**
630      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
631      * reverting when dividing by zero.
632      *
633      * Counterpart to Solidity's `%` operator. This function uses a `revert`
634      * opcode (which leaves remaining gas untouched) while Solidity uses an
635      * invalid opcode to revert (consuming all remaining gas).
636      *
637      * Requirements:
638      *
639      * - The divisor cannot be zero.
640      */
641     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
642         return a % b;
643     }
644 
645     /**
646      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
647      * overflow (when the result is negative).
648      *
649      * CAUTION: This function is deprecated because it requires allocating memory for the error
650      * message unnecessarily. For custom revert reasons use {trySub}.
651      *
652      * Counterpart to Solidity's `-` operator.
653      *
654      * Requirements:
655      *
656      * - Subtraction cannot overflow.
657      */
658     function sub(
659         uint256 a,
660         uint256 b,
661         string memory errorMessage
662     ) internal pure returns (uint256) {
663         unchecked {
664             require(b <= a, errorMessage);
665             return a - b;
666         }
667     }
668 
669     /**
670      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
671      * division by zero. The result is rounded towards zero.
672      *
673      * Counterpart to Solidity's `/` operator. Note: this function uses a
674      * `revert` opcode (which leaves remaining gas untouched) while Solidity
675      * uses an invalid opcode to revert (consuming all remaining gas).
676      *
677      * Requirements:
678      *
679      * - The divisor cannot be zero.
680      */
681     function div(
682         uint256 a,
683         uint256 b,
684         string memory errorMessage
685     ) internal pure returns (uint256) {
686         unchecked {
687             require(b > 0, errorMessage);
688             return a / b;
689         }
690     }
691 
692     /**
693      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
694      * reverting with custom message when dividing by zero.
695      *
696      * CAUTION: This function is deprecated because it requires allocating memory for the error
697      * message unnecessarily. For custom revert reasons use {tryMod}.
698      *
699      * Counterpart to Solidity's `%` operator. This function uses a `revert`
700      * opcode (which leaves remaining gas untouched) while Solidity uses an
701      * invalid opcode to revert (consuming all remaining gas).
702      *
703      * Requirements:
704      *
705      * - The divisor cannot be zero.
706      */
707     function mod(
708         uint256 a,
709         uint256 b,
710         string memory errorMessage
711     ) internal pure returns (uint256) {
712         unchecked {
713             require(b > 0, errorMessage);
714             return a % b;
715         }
716     }
717 }
718 
719 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
720     using Address for address;
721     using Strings for uint256;
722 
723     // Token name
724     string private _name;
725 
726     // Token symbol
727     string private _symbol;
728 
729     // Mapping from token ID to owner address
730     mapping(uint256 => address) private _owners;
731 
732     // Mapping owner address to token count
733     mapping(address => uint256) private _balances;
734 
735     // Mapping from token ID to approved address
736     mapping(uint256 => address) private _tokenApprovals;
737 
738     // Mapping from owner to operator approvals
739     mapping(address => mapping(address => bool)) private _operatorApprovals;
740 
741     /**
742      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
743      */
744     constructor(string memory name_, string memory symbol_) {
745         _name = name_;
746         _symbol = symbol_;
747     }
748 
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
753         return
754             interfaceId == type(IERC721).interfaceId ||
755             interfaceId == type(IERC721Metadata).interfaceId ||
756             super.supportsInterface(interfaceId);
757     }
758 
759     /**
760      * @dev See {IERC721-balanceOf}.
761      */
762     function balanceOf(address owner) public view virtual override returns (uint256) {
763         require(owner != address(0), "ERC721: balance query for the zero address");
764         return _balances[owner];
765     }
766 
767     /**
768      * @dev See {IERC721-ownerOf}.
769      */
770     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
771         address owner = _owners[tokenId];
772         require(owner != address(0), "ERC721: owner query for nonexistent token");
773         return owner;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-name}.
778      */
779     function name() public view virtual override returns (string memory) {
780         return _name;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-symbol}.
785      */
786     function symbol() public view virtual override returns (string memory) {
787         return _symbol;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-tokenURI}.
792      */
793     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
794         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
795 
796         string memory baseURI = _baseURI();
797         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
798     }
799 
800     /**
801      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
802      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
803      * by default, can be overriden in child contracts.
804      */
805     function _baseURI() internal view virtual returns (string memory) {
806         return "";
807     }
808 
809     /**
810      * @dev See {IERC721-approve}.
811      */
812     function approve(address to, uint256 tokenId) public virtual override {
813         address owner = ERC721.ownerOf(tokenId);
814         require(to != owner, "ERC721: approval to current owner");
815 
816         require(
817             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
818             "ERC721: approve caller is not owner nor approved for all"
819         );
820 
821         _approve(to, tokenId);
822     }
823 
824     /**
825      * @dev See {IERC721-getApproved}.
826      */
827     function getApproved(uint256 tokenId) public view virtual override returns (address) {
828         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
829 
830         return _tokenApprovals[tokenId];
831     }
832 
833     /**
834      * @dev See {IERC721-setApprovalForAll}.
835      */
836     function setApprovalForAll(address operator, bool approved) public virtual override {
837         require(operator != _msgSender(), "ERC721: approve to caller");
838 
839         _operatorApprovals[_msgSender()][operator] = approved;
840         emit ApprovalForAll(_msgSender(), operator, approved);
841     }
842 
843     /**
844      * @dev See {IERC721-isApprovedForAll}.
845      */
846     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
847         return _operatorApprovals[owner][operator];
848     }
849 
850     /**
851      * @dev See {IERC721-transferFrom}.
852      */
853     function transferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         //solhint-disable-next-line max-line-length
859         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
860 
861         _transfer(from, to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-safeTransferFrom}.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) public virtual override {
872         safeTransferFrom(from, to, tokenId, "");
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) public virtual override {
884         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
885         _safeTransfer(from, to, tokenId, _data);
886     }
887 
888     /**
889      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
890      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
891      *
892      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
893      *
894      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
895      * implement alternative mechanisms to perform token transfer, such as signature-based.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must exist and be owned by `from`.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _safeTransfer(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) internal virtual {
912         _transfer(from, to, tokenId);
913         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
914     }
915 
916     /**
917      * @dev Returns whether `tokenId` exists.
918      *
919      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
920      *
921      * Tokens start existing when they are minted (`_mint`),
922      * and stop existing when they are burned (`_burn`).
923      */
924     function _exists(uint256 tokenId) internal view virtual returns (bool) {
925         return _owners[tokenId] != address(0);
926     }
927 
928     /**
929      * @dev Returns whether `spender` is allowed to manage `tokenId`.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must exist.
934      */
935     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
936         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
937         address owner = ERC721.ownerOf(tokenId);
938         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
939     }
940 
941     /**
942      * @dev Safely mints `tokenId` and transfers it to `to`.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must not exist.
947      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _safeMint(address to, uint256 tokenId) internal virtual {
952         _safeMint(to, tokenId, "");
953     }
954 
955     /**
956      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
957      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
958      */
959     function _safeMint(
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) internal virtual {
964         _mint(to, tokenId);
965         require(
966             _checkOnERC721Received(address(0), to, tokenId, _data),
967             "ERC721: transfer to non ERC721Receiver implementer"
968         );
969     }
970 
971     /**
972      * @dev Mints `tokenId` and transfers it to `to`.
973      *
974      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
975      *
976      * Requirements:
977      *
978      * - `tokenId` must not exist.
979      * - `to` cannot be the zero address.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _mint(address to, uint256 tokenId) internal virtual {
984         require(to != address(0), "ERC721: mint to the zero address");
985         require(!_exists(tokenId), "ERC721: token already minted");
986 
987         _beforeTokenTransfer(address(0), to, tokenId);
988 
989         _balances[to] += 1;
990         _owners[tokenId] = to;
991 
992         emit Transfer(address(0), to, tokenId);
993     }
994 
995     /**
996      * @dev Destroys `tokenId`.
997      * The approval is cleared when the token is burned.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must exist.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _burn(uint256 tokenId) internal virtual {
1006         address owner = ERC721.ownerOf(tokenId);
1007 
1008         _beforeTokenTransfer(owner, address(0), tokenId);
1009 
1010         // Clear approvals
1011         _approve(address(0), tokenId);
1012 
1013         _balances[owner] -= 1;
1014         delete _owners[tokenId];
1015 
1016         emit Transfer(owner, address(0), tokenId);
1017     }
1018 
1019     /**
1020      * @dev Transfers `tokenId` from `from` to `to`.
1021      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) internal virtual {
1035         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1036         require(to != address(0), "ERC721: transfer to the zero address");
1037 
1038         _beforeTokenTransfer(from, to, tokenId);
1039 
1040         // Clear approvals from the previous owner
1041         _approve(address(0), tokenId);
1042 
1043         _balances[from] -= 1;
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Approve `to` to operate on `tokenId`
1052      *
1053      * Emits a {Approval} event.
1054      */
1055     function _approve(address to, uint256 tokenId) internal virtual {
1056         _tokenApprovals[tokenId] = to;
1057         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1062      * The call is not executed if the target address is not a contract.
1063      *
1064      * @param from address representing the previous owner of the given token ID
1065      * @param to target address that will receive the tokens
1066      * @param tokenId uint256 ID of the token to be transferred
1067      * @param _data bytes optional data to send along with the call
1068      * @return bool whether the call correctly returned the expected magic value
1069      */
1070     function _checkOnERC721Received(
1071         address from,
1072         address to,
1073         uint256 tokenId,
1074         bytes memory _data
1075     ) private returns (bool) {
1076         if (to.isContract()) {
1077             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1078                 return retval == IERC721Receiver.onERC721Received.selector;
1079             } catch (bytes memory reason) {
1080                 if (reason.length == 0) {
1081                     revert("ERC721: transfer to non ERC721Receiver implementer");
1082                 } else {
1083                     assembly {
1084                         revert(add(32, reason), mload(reason))
1085                     }
1086                 }
1087             }
1088         } else {
1089             return true;
1090         }
1091     }
1092 
1093     /**
1094      * @dev Hook that is called before any token transfer. This includes minting
1095      * and burning.
1096      *
1097      * Calling conditions:
1098      *
1099      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1100      * transferred to `to`.
1101      * - When `from` is zero, `tokenId` will be minted for `to`.
1102      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1103      * - `from` and `to` are never both zero.
1104      *
1105      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1106      */
1107     function _beforeTokenTransfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) internal virtual {}
1112 }
1113 
1114 abstract contract Ownable is Context {
1115     address private _owner;
1116 
1117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1118 
1119     /**
1120      * @dev Initializes the contract setting the deployer as the initial owner.
1121      */
1122     constructor() {
1123         _setOwner(_msgSender());
1124     }
1125 
1126     /**
1127      * @dev Returns the address of the current owner.
1128      */
1129     function owner() public view virtual returns (address) {
1130         return _owner;
1131     }
1132 
1133     /**
1134      * @dev Throws if called by any account other than the owner.
1135      */
1136     modifier onlyOwner() {
1137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1138         _;
1139     }
1140 
1141     /**
1142      * @dev Leaves the contract without owner. It will not be possible to call
1143      * `onlyOwner` functions anymore. Can only be called by the current owner.
1144      *
1145      * NOTE: Renouncing ownership will leave the contract without an owner,
1146      * thereby removing any functionality that is only available to the owner.
1147      */
1148     function renounceOwnership() public virtual onlyOwner {
1149         _setOwner(address(0));
1150     }
1151 
1152     /**
1153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1154      * Can only be called by the current owner.
1155      */
1156     function transferOwnership(address newOwner) public virtual onlyOwner {
1157         require(newOwner != address(0), "Ownable: new owner is the zero address");
1158         _setOwner(newOwner);
1159     }
1160 
1161     function _setOwner(address newOwner) private {
1162         address oldOwner = _owner;
1163         _owner = newOwner;
1164         emit OwnershipTransferred(oldOwner, newOwner);
1165     }
1166 }
1167 
1168 contract BearMarketBuds is ERC721, Ownable
1169 {
1170     using Counters for Counters.Counter;
1171     using SafeMath for uint256;
1172 
1173     uint256 public price = 0 ether;
1174     uint256 public maxSupply = 6969;
1175     uint256 private maxMint = 2;
1176 
1177     string private customBaseURI;
1178     string private baseExtension = ".json";
1179 
1180     bool public mintOpen = false;
1181 
1182     Counters.Counter private _tokenSupply;
1183 
1184     constructor(string memory _customBaseURI) ERC721("Bear Market Buds", "BMBUDS")  {
1185         customBaseURI = _customBaseURI;
1186     }
1187 
1188     function totalSupply() public view returns (uint256) {
1189         return _tokenSupply.current();
1190     }
1191 
1192     function mintBulk(uint256 numberOfMints, address mintAddress) public payable onlyOwner{
1193         uint256 supply = _tokenSupply.current();
1194        for(uint256 i = 1; i <= numberOfMints; i++){
1195             _safeMint(mintAddress, supply + i);
1196             _tokenSupply.increment();
1197         }
1198     }
1199 
1200     function mint(uint256 numberOfMints) external payable {
1201         uint256 supply = _tokenSupply.current();
1202         require(mintOpen, "Sale Needs To Be Active");
1203         require(numberOfMints > 0 && numberOfMints <= maxMint, "Invalid purchase amount");
1204         require(supply.add(numberOfMints) <= maxSupply, "Payment exceeds total supply");
1205 
1206        for(uint256 i = 1; i <= numberOfMints; i++){
1207             _safeMint(msg.sender, supply + i);
1208             _tokenSupply.increment();
1209         }
1210     }
1211 
1212     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1213         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1214         string memory currentBaseURI = _baseURI();
1215         return bytes(currentBaseURI).length > 0
1216             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
1217             : "";
1218     }
1219 
1220     function toggleSale() public onlyOwner {
1221         mintOpen = !mintOpen;
1222     }
1223 
1224     function _baseURI() internal view virtual override returns (string memory) {
1225         return customBaseURI;
1226     }
1227 
1228     function setBaseURI(string calldata _newBaseURI) external onlyOwner {
1229         customBaseURI = _newBaseURI;
1230     }
1231 
1232     function setMaxMint(uint256 _maxMint) external onlyOwner {
1233         maxMint = _maxMint;
1234     }
1235 
1236     function withdraw() public onlyOwner {
1237         uint256 balance = address(this).balance;
1238         payable(msg.sender).transfer(balance);
1239     }
1240 
1241 }