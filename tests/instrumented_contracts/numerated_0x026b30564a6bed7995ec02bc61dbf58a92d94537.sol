1 pragma solidity ^0.8.4;
2 
3 library Strings {
4     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
5 
6     /**
7      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
8      */
9     function toString(uint256 value) internal pure returns (string memory) {
10         // Inspired by OraclizeAPI's implementation - MIT licence
11         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
12 
13         if (value == 0) {
14             return "0";
15         }
16         uint256 temp = value;
17         uint256 digits;
18         while (temp != 0) {
19             digits++;
20             temp /= 10;
21         }
22         bytes memory buffer = new bytes(digits);
23         while (value != 0) {
24             digits -= 1;
25             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
26             value /= 10;
27         }
28         return string(buffer);
29     }
30 
31     /**
32      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
33      */
34     function toHexString(uint256 value) internal pure returns (string memory) {
35         if (value == 0) {
36             return "0x00";
37         }
38         uint256 temp = value;
39         uint256 length = 0;
40         while (temp != 0) {
41             length++;
42             temp >>= 8;
43         }
44         return toHexString(value, length);
45     }
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
49      */
50     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
51         bytes memory buffer = new bytes(2 * length + 2);
52         buffer[0] = "0";
53         buffer[1] = "x";
54         for (uint256 i = 2 * length + 1; i > 1; --i) {
55             buffer[i] = _HEX_SYMBOLS[value & 0xf];
56             value >>= 4;
57         }
58         require(value == 0, "Strings: hex length insufficient");
59         return string(buffer);
60     }
61 }
62 
63 library Counters {
64     struct Counter {
65         // This variable should never be directly accessed by users of the library: interactions must be restricted to
66         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
67         // this feature: see https://github.com/ethereum/solidity/issues/4637
68         uint256 _value; // default: 0
69     }
70 
71     function current(Counter storage counter) internal view returns (uint256) {
72         return counter._value;
73     }
74 
75     function increment(Counter storage counter) internal {
76         unchecked {
77             counter._value += 1;
78         }
79     }
80 
81     function decrement(Counter storage counter) internal {
82         uint256 value = counter._value;
83         require(value > 0, "Counter: decrement overflow");
84         unchecked {
85             counter._value = value - 1;
86         }
87     }
88 
89     function reset(Counter storage counter) internal {
90         counter._value = 0;
91     }
92 }
93 
94 abstract contract Context {
95     function _msgSender() internal view virtual returns (address) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes calldata) {
100         return msg.data;
101     }
102 }
103 
104 library Address {
105     /**
106      * @dev Returns true if `account` is a contract.
107      *
108      * [IMPORTANT]
109      * ====
110      * It is unsafe to assume that an address for which this function returns
111      * false is an externally-owned account (EOA) and not a contract.
112      *
113      * Among others, `isContract` will return false for the following
114      * types of addresses:
115      *
116      *  - an externally-owned account
117      *  - a contract in construction
118      *  - an address where a contract will be created
119      *  - an address where a contract lived, but was destroyed
120      * ====
121      */
122     function isContract(address account) internal view returns (bool) {
123         // This method relies on extcodesize, which returns 0 for contracts in
124         // construction, since the code is only stored at the end of the
125         // constructor execution.
126 
127         uint256 size;
128         assembly {
129             size := extcodesize(account)
130         }
131         return size > 0;
132     }
133 
134     /**
135      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
136      * `recipient`, forwarding all available gas and reverting on errors.
137      *
138      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
139      * of certain opcodes, possibly making contracts go over the 2300 gas limit
140      * imposed by `transfer`, making them unable to receive funds via
141      * `transfer`. {sendValue} removes this limitation.
142      *
143      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
144      *
145      * IMPORTANT: because control is transferred to `recipient`, care must be
146      * taken to not create reentrancy vulnerabilities. Consider using
147      * {ReentrancyGuard} or the
148      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
149      */
150     function sendValue(address payable recipient, uint256 amount) internal {
151         require(address(this).balance >= amount, "Address: insufficient balance");
152 
153         (bool success, ) = recipient.call{value: amount}("");
154         require(success, "Address: unable to send value, recipient may have reverted");
155     }
156 
157     /**
158      * @dev Performs a Solidity function call using a low level `call`. A
159      * plain `call` is an unsafe replacement for a function call: use this
160      * function instead.
161      *
162      * If `target` reverts with a revert reason, it is bubbled up by this
163      * function (like regular Solidity function calls).
164      *
165      * Returns the raw returned data. To convert to the expected return value,
166      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
167      *
168      * Requirements:
169      *
170      * - `target` must be a contract.
171      * - calling `target` with `data` must not revert.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
176         return functionCall(target, data, "Address: low-level call failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
181      * `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, 0, errorMessage);
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
195      * but also transferring `value` wei to `target`.
196      *
197      * Requirements:
198      *
199      * - the calling contract must have an ETH balance of at least `value`.
200      * - the called Solidity function must be `payable`.
201      *
202      * _Available since v3.1._
203      */
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value
208     ) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
214      * with `errorMessage` as a fallback revert reason when `target` reverts.
215      *
216      * _Available since v3.1._
217      */
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(address(this).balance >= value, "Address: insufficient balance for call");
225         require(isContract(target), "Address: call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.call{value: value}(data);
228         return verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
238         return functionStaticCall(target, data, "Address: low-level static call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(
248         address target,
249         bytes memory data,
250         string memory errorMessage
251     ) internal view returns (bytes memory) {
252         require(isContract(target), "Address: static call to non-contract");
253 
254         (bool success, bytes memory returndata) = target.staticcall(data);
255         return verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         require(isContract(target), "Address: delegate call to non-contract");
280 
281         (bool success, bytes memory returndata) = target.delegatecall(data);
282         return verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
287      * revert reason using the provided one.
288      *
289      * _Available since v4.3._
290      */
291     function verifyCallResult(
292         bool success,
293         bytes memory returndata,
294         string memory errorMessage
295     ) internal pure returns (bytes memory) {
296         if (success) {
297             return returndata;
298         } else {
299             // Look for revert reason and bubble it up if present
300             if (returndata.length > 0) {
301                 // The easiest way to bubble the revert reason is using memory via assembly
302 
303                 assembly {
304                     let returndata_size := mload(returndata)
305                     revert(add(32, returndata), returndata_size)
306                 }
307             } else {
308                 revert(errorMessage);
309             }
310         }
311     }
312 }
313 
314 interface IERC721Receiver {
315     /**
316      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
317      * by `operator` from `from`, this function is called.
318      *
319      * It must return its Solidity selector to confirm the token transfer.
320      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
321      *
322      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
323      */
324     function onERC721Received(
325         address operator,
326         address from,
327         uint256 tokenId,
328         bytes calldata data
329     ) external returns (bytes4);
330 }
331 
332 interface IERC165 {
333     /**
334      * @dev Returns true if this contract implements the interface defined by
335      * `interfaceId`. See the corresponding
336      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
337      * to learn more about how these ids are created.
338      *
339      * This function call must use less than 30 000 gas.
340      */
341     function supportsInterface(bytes4 interfaceId) external view returns (bool);
342 }
343 
344 abstract contract ERC165 is IERC165 {
345     /**
346      * @dev See {IERC165-supportsInterface}.
347      */
348     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
349         return interfaceId == type(IERC165).interfaceId;
350     }
351 }
352 
353 interface IERC721 is IERC165 {
354     /**
355      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
356      */
357     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
358 
359     /**
360      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
361      */
362     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
363 
364     /**
365      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
366      */
367     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
368 
369     /**
370      * @dev Returns the number of tokens in ``owner``'s account.
371      */
372     function balanceOf(address owner) external view returns (uint256 balance);
373 
374     /**
375      * @dev Returns the owner of the `tokenId` token.
376      *
377      * Requirements:
378      *
379      * - `tokenId` must exist.
380      */
381     function ownerOf(uint256 tokenId) external view returns (address owner);
382 
383     /**
384      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
385      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
386      *
387      * Requirements:
388      *
389      * - `from` cannot be the zero address.
390      * - `to` cannot be the zero address.
391      * - `tokenId` token must exist and be owned by `from`.
392      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
393      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
394      *
395      * Emits a {Transfer} event.
396      */
397     function safeTransferFrom(
398         address from,
399         address to,
400         uint256 tokenId
401     ) external;
402 
403     /**
404      * @dev Transfers `tokenId` token from `from` to `to`.
405      *
406      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must be owned by `from`.
413      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(
418         address from,
419         address to,
420         uint256 tokenId
421     ) external;
422 
423     /**
424      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
425      * The approval is cleared when the token is transferred.
426      *
427      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
428      *
429      * Requirements:
430      *
431      * - The caller must own the token or be an approved operator.
432      * - `tokenId` must exist.
433      *
434      * Emits an {Approval} event.
435      */
436     function approve(address to, uint256 tokenId) external;
437 
438     /**
439      * @dev Returns the account approved for `tokenId` token.
440      *
441      * Requirements:
442      *
443      * - `tokenId` must exist.
444      */
445     function getApproved(uint256 tokenId) external view returns (address operator);
446 
447     /**
448      * @dev Approve or remove `operator` as an operator for the caller.
449      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
450      *
451      * Requirements:
452      *
453      * - The `operator` cannot be the caller.
454      *
455      * Emits an {ApprovalForAll} event.
456      */
457     function setApprovalForAll(address operator, bool _approved) external;
458 
459     /**
460      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
461      *
462      * See {setApprovalForAll}
463      */
464     function isApprovedForAll(address owner, address operator) external view returns (bool);
465 
466     /**
467      * @dev Safely transfers `tokenId` token from `from` to `to`.
468      *
469      * Requirements:
470      *
471      * - `from` cannot be the zero address.
472      * - `to` cannot be the zero address.
473      * - `tokenId` token must exist and be owned by `from`.
474      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
475      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
476      *
477      * Emits a {Transfer} event.
478      */
479     function safeTransferFrom(
480         address from,
481         address to,
482         uint256 tokenId,
483         bytes calldata data
484     ) external;
485 }
486 
487 interface IERC721Metadata is IERC721 {
488     /**
489      * @dev Returns the token collection name.
490      */
491     function name() external view returns (string memory);
492 
493     /**
494      * @dev Returns the token collection symbol.
495      */
496     function symbol() external view returns (string memory);
497 
498     /**
499      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
500      */
501     function tokenURI(uint256 tokenId) external view returns (string memory);
502 }
503 
504 library SafeMath {
505     /**
506      * @dev Returns the addition of two unsigned integers, with an overflow flag.
507      *
508      * _Available since v3.4._
509      */
510     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
511         unchecked {
512             uint256 c = a + b;
513             if (c < a) return (false, 0);
514             return (true, c);
515         }
516     }
517 
518     /**
519      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
520      *
521      * _Available since v3.4._
522      */
523     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
524         unchecked {
525             if (b > a) return (false, 0);
526             return (true, a - b);
527         }
528     }
529 
530     /**
531      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
532      *
533      * _Available since v3.4._
534      */
535     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
536         unchecked {
537             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
538             // benefit is lost if 'b' is also tested.
539             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
540             if (a == 0) return (true, 0);
541             uint256 c = a * b;
542             if (c / a != b) return (false, 0);
543             return (true, c);
544         }
545     }
546 
547     /**
548      * @dev Returns the division of two unsigned integers, with a division by zero flag.
549      *
550      * _Available since v3.4._
551      */
552     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
553         unchecked {
554             if (b == 0) return (false, 0);
555             return (true, a / b);
556         }
557     }
558 
559     /**
560      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
561      *
562      * _Available since v3.4._
563      */
564     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
565         unchecked {
566             if (b == 0) return (false, 0);
567             return (true, a % b);
568         }
569     }
570 
571     /**
572      * @dev Returns the addition of two unsigned integers, reverting on
573      * overflow.
574      *
575      * Counterpart to Solidity's `+` operator.
576      *
577      * Requirements:
578      *
579      * - Addition cannot overflow.
580      */
581     function add(uint256 a, uint256 b) internal pure returns (uint256) {
582         return a + b;
583     }
584 
585     /**
586      * @dev Returns the subtraction of two unsigned integers, reverting on
587      * overflow (when the result is negative).
588      *
589      * Counterpart to Solidity's `-` operator.
590      *
591      * Requirements:
592      *
593      * - Subtraction cannot overflow.
594      */
595     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
596         return a - b;
597     }
598 
599     /**
600      * @dev Returns the multiplication of two unsigned integers, reverting on
601      * overflow.
602      *
603      * Counterpart to Solidity's `*` operator.
604      *
605      * Requirements:
606      *
607      * - Multiplication cannot overflow.
608      */
609     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
610         return a * b;
611     }
612 
613     /**
614      * @dev Returns the integer division of two unsigned integers, reverting on
615      * division by zero. The result is rounded towards zero.
616      *
617      * Counterpart to Solidity's `/` operator.
618      *
619      * Requirements:
620      *
621      * - The divisor cannot be zero.
622      */
623     function div(uint256 a, uint256 b) internal pure returns (uint256) {
624         return a / b;
625     }
626 
627     /**
628      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
629      * reverting when dividing by zero.
630      *
631      * Counterpart to Solidity's `%` operator. This function uses a `revert`
632      * opcode (which leaves remaining gas untouched) while Solidity uses an
633      * invalid opcode to revert (consuming all remaining gas).
634      *
635      * Requirements:
636      *
637      * - The divisor cannot be zero.
638      */
639     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
640         return a % b;
641     }
642 
643     /**
644      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
645      * overflow (when the result is negative).
646      *
647      * CAUTION: This function is deprecated because it requires allocating memory for the error
648      * message unnecessarily. For custom revert reasons use {trySub}.
649      *
650      * Counterpart to Solidity's `-` operator.
651      *
652      * Requirements:
653      *
654      * - Subtraction cannot overflow.
655      */
656     function sub(
657         uint256 a,
658         uint256 b,
659         string memory errorMessage
660     ) internal pure returns (uint256) {
661         unchecked {
662             require(b <= a, errorMessage);
663             return a - b;
664         }
665     }
666 
667     /**
668      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
669      * division by zero. The result is rounded towards zero.
670      *
671      * Counterpart to Solidity's `/` operator. Note: this function uses a
672      * `revert` opcode (which leaves remaining gas untouched) while Solidity
673      * uses an invalid opcode to revert (consuming all remaining gas).
674      *
675      * Requirements:
676      *
677      * - The divisor cannot be zero.
678      */
679     function div(
680         uint256 a,
681         uint256 b,
682         string memory errorMessage
683     ) internal pure returns (uint256) {
684         unchecked {
685             require(b > 0, errorMessage);
686             return a / b;
687         }
688     }
689 
690     /**
691      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
692      * reverting with custom message when dividing by zero.
693      *
694      * CAUTION: This function is deprecated because it requires allocating memory for the error
695      * message unnecessarily. For custom revert reasons use {tryMod}.
696      *
697      * Counterpart to Solidity's `%` operator. This function uses a `revert`
698      * opcode (which leaves remaining gas untouched) while Solidity uses an
699      * invalid opcode to revert (consuming all remaining gas).
700      *
701      * Requirements:
702      *
703      * - The divisor cannot be zero.
704      */
705     function mod(
706         uint256 a,
707         uint256 b,
708         string memory errorMessage
709     ) internal pure returns (uint256) {
710         unchecked {
711             require(b > 0, errorMessage);
712             return a % b;
713         }
714     }
715 }
716 
717 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
718     using Address for address;
719     using Strings for uint256;
720 
721     // Token name
722     string private _name;
723 
724     // Token symbol
725     string private _symbol;
726 
727     // Mapping from token ID to owner address
728     mapping(uint256 => address) private _owners;
729 
730     // Mapping owner address to token count
731     mapping(address => uint256) private _balances;
732 
733     // Mapping from token ID to approved address
734     mapping(uint256 => address) private _tokenApprovals;
735 
736     // Mapping from owner to operator approvals
737     mapping(address => mapping(address => bool)) private _operatorApprovals;
738 
739     /**
740      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
741      */
742     constructor(string memory name_, string memory symbol_) {
743         _name = name_;
744         _symbol = symbol_;
745     }
746 
747     /**
748      * @dev See {IERC165-supportsInterface}.
749      */
750     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
751         return
752             interfaceId == type(IERC721).interfaceId ||
753             interfaceId == type(IERC721Metadata).interfaceId ||
754             super.supportsInterface(interfaceId);
755     }
756 
757     /**
758      * @dev See {IERC721-balanceOf}.
759      */
760     function balanceOf(address owner) public view virtual override returns (uint256) {
761         require(owner != address(0), "ERC721: balance query for the zero address");
762         return _balances[owner];
763     }
764 
765     /**
766      * @dev See {IERC721-ownerOf}.
767      */
768     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
769         address owner = _owners[tokenId];
770         require(owner != address(0), "ERC721: owner query for nonexistent token");
771         return owner;
772     }
773 
774     /**
775      * @dev See {IERC721Metadata-name}.
776      */
777     function name() public view virtual override returns (string memory) {
778         return _name;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-symbol}.
783      */
784     function symbol() public view virtual override returns (string memory) {
785         return _symbol;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-tokenURI}.
790      */
791     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
792         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
793 
794         string memory baseURI = _baseURI();
795         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
796     }
797 
798     /**
799      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
800      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
801      * by default, can be overriden in child contracts.
802      */
803     function _baseURI() internal view virtual returns (string memory) {
804         return "";
805     }
806 
807     /**
808      * @dev See {IERC721-approve}.
809      */
810     function approve(address to, uint256 tokenId) public virtual override {
811         address owner = ERC721.ownerOf(tokenId);
812         require(to != owner, "ERC721: approval to current owner");
813 
814         require(
815             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
816             "ERC721: approve caller is not owner nor approved for all"
817         );
818 
819         _approve(to, tokenId);
820     }
821 
822     /**
823      * @dev See {IERC721-getApproved}.
824      */
825     function getApproved(uint256 tokenId) public view virtual override returns (address) {
826         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
827 
828         return _tokenApprovals[tokenId];
829     }
830 
831     /**
832      * @dev See {IERC721-setApprovalForAll}.
833      */
834     function setApprovalForAll(address operator, bool approved) public virtual override {
835         require(operator != _msgSender(), "ERC721: approve to caller");
836 
837         _operatorApprovals[_msgSender()][operator] = approved;
838         emit ApprovalForAll(_msgSender(), operator, approved);
839     }
840 
841     /**
842      * @dev See {IERC721-isApprovedForAll}.
843      */
844     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
845         return _operatorApprovals[owner][operator];
846     }
847 
848     /**
849      * @dev See {IERC721-transferFrom}.
850      */
851     function transferFrom(
852         address from,
853         address to,
854         uint256 tokenId
855     ) public virtual override {
856         //solhint-disable-next-line max-line-length
857         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
858 
859         _transfer(from, to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         safeTransferFrom(from, to, tokenId, "");
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) public virtual override {
882         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
883         _safeTransfer(from, to, tokenId, _data);
884     }
885 
886     /**
887      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
888      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
889      *
890      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
891      *
892      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
893      * implement alternative mechanisms to perform token transfer, such as signature-based.
894      *
895      * Requirements:
896      *
897      * - `from` cannot be the zero address.
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must exist and be owned by `from`.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _safeTransfer(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) internal virtual {
910         _transfer(from, to, tokenId);
911         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
912     }
913 
914     /**
915      * @dev Returns whether `tokenId` exists.
916      *
917      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
918      *
919      * Tokens start existing when they are minted (`_mint`),
920      * and stop existing when they are burned (`_burn`).
921      */
922     function _exists(uint256 tokenId) internal view virtual returns (bool) {
923         return _owners[tokenId] != address(0);
924     }
925 
926     /**
927      * @dev Returns whether `spender` is allowed to manage `tokenId`.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must exist.
932      */
933     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
934         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
935         address owner = ERC721.ownerOf(tokenId);
936         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
937     }
938 
939     /**
940      * @dev Safely mints `tokenId` and transfers it to `to`.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must not exist.
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _safeMint(address to, uint256 tokenId) internal virtual {
950         _safeMint(to, tokenId, "");
951     }
952 
953     /**
954      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
955      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
956      */
957     function _safeMint(
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) internal virtual {
962         _mint(to, tokenId);
963         require(
964             _checkOnERC721Received(address(0), to, tokenId, _data),
965             "ERC721: transfer to non ERC721Receiver implementer"
966         );
967     }
968 
969     /**
970      * @dev Mints `tokenId` and transfers it to `to`.
971      *
972      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
973      *
974      * Requirements:
975      *
976      * - `tokenId` must not exist.
977      * - `to` cannot be the zero address.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _mint(address to, uint256 tokenId) internal virtual {
982         require(to != address(0), "ERC721: mint to the zero address");
983         require(!_exists(tokenId), "ERC721: token already minted");
984 
985         _beforeTokenTransfer(address(0), to, tokenId);
986 
987         _balances[to] += 1;
988         _owners[tokenId] = to;
989 
990         emit Transfer(address(0), to, tokenId);
991     }
992 
993     /**
994      * @dev Destroys `tokenId`.
995      * The approval is cleared when the token is burned.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _burn(uint256 tokenId) internal virtual {
1004         address owner = ERC721.ownerOf(tokenId);
1005 
1006         _beforeTokenTransfer(owner, address(0), tokenId);
1007 
1008         // Clear approvals
1009         _approve(address(0), tokenId);
1010 
1011         _balances[owner] -= 1;
1012         delete _owners[tokenId];
1013 
1014         emit Transfer(owner, address(0), tokenId);
1015     }
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _transfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) internal virtual {
1033         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1034         require(to != address(0), "ERC721: transfer to the zero address");
1035 
1036         _beforeTokenTransfer(from, to, tokenId);
1037 
1038         // Clear approvals from the previous owner
1039         _approve(address(0), tokenId);
1040 
1041         _balances[from] -= 1;
1042         _balances[to] += 1;
1043         _owners[tokenId] = to;
1044 
1045         emit Transfer(from, to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev Approve `to` to operate on `tokenId`
1050      *
1051      * Emits a {Approval} event.
1052      */
1053     function _approve(address to, uint256 tokenId) internal virtual {
1054         _tokenApprovals[tokenId] = to;
1055         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1060      * The call is not executed if the target address is not a contract.
1061      *
1062      * @param from address representing the previous owner of the given token ID
1063      * @param to target address that will receive the tokens
1064      * @param tokenId uint256 ID of the token to be transferred
1065      * @param _data bytes optional data to send along with the call
1066      * @return bool whether the call correctly returned the expected magic value
1067      */
1068     function _checkOnERC721Received(
1069         address from,
1070         address to,
1071         uint256 tokenId,
1072         bytes memory _data
1073     ) private returns (bool) {
1074         if (to.isContract()) {
1075             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1076                 return retval == IERC721Receiver.onERC721Received.selector;
1077             } catch (bytes memory reason) {
1078                 if (reason.length == 0) {
1079                     revert("ERC721: transfer to non ERC721Receiver implementer");
1080                 } else {
1081                     assembly {
1082                         revert(add(32, reason), mload(reason))
1083                     }
1084                 }
1085             }
1086         } else {
1087             return true;
1088         }
1089     }
1090 
1091     /**
1092      * @dev Hook that is called before any token transfer. This includes minting
1093      * and burning.
1094      *
1095      * Calling conditions:
1096      *
1097      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1098      * transferred to `to`.
1099      * - When `from` is zero, `tokenId` will be minted for `to`.
1100      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1101      * - `from` and `to` are never both zero.
1102      *
1103      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1104      */
1105     function _beforeTokenTransfer(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) internal virtual {}
1110 }
1111 
1112 abstract contract Ownable is Context {
1113     address private _owner;
1114 
1115     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1116 
1117     /**
1118      * @dev Initializes the contract setting the deployer as the initial owner.
1119      */
1120     constructor() {
1121         _setOwner(_msgSender());
1122     }
1123 
1124     /**
1125      * @dev Returns the address of the current owner.
1126      */
1127     function owner() public view virtual returns (address) {
1128         return _owner;
1129     }
1130 
1131     /**
1132      * @dev Throws if called by any account other than the owner.
1133      */
1134     modifier onlyOwner() {
1135         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1136         _;
1137     }
1138 
1139     /**
1140      * @dev Leaves the contract without owner. It will not be possible to call
1141      * `onlyOwner` functions anymore. Can only be called by the current owner.
1142      *
1143      * NOTE: Renouncing ownership will leave the contract without an owner,
1144      * thereby removing any functionality that is only available to the owner.
1145      */
1146     function renounceOwnership() public virtual onlyOwner {
1147         _setOwner(address(0));
1148     }
1149 
1150     /**
1151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1152      * Can only be called by the current owner.
1153      */
1154     function transferOwnership(address newOwner) public virtual onlyOwner {
1155         require(newOwner != address(0), "Ownable: new owner is the zero address");
1156         _setOwner(newOwner);
1157     }
1158 
1159     function _setOwner(address newOwner) private {
1160         address oldOwner = _owner;
1161         _owner = newOwner;
1162         emit OwnershipTransferred(oldOwner, newOwner);
1163     }
1164 }
1165 
1166 interface IBMBuds{
1167     function balanceOf(address userAddress) external view returns (uint256);
1168 }
1169 
1170 contract FREESHIT is ERC721, Ownable
1171 {
1172     IBMBuds public BMBuds;
1173 
1174     using Counters for Counters.Counter;
1175     using SafeMath for uint256;
1176     using Address for uint256;
1177 
1178     uint256 public price = 0 ether;
1179     uint256 public maxSupply = 6969;
1180 
1181     string private baseURI;
1182     string public baseExtension = ".json";
1183     string public notRevealedURI;
1184 
1185     bool public mintOpen = false;
1186     bool public revealToken = false;
1187 
1188     mapping(address => uint256) balanceOfAddress;
1189     mapping(address => uint256) OgBalanceOfAddress;
1190 
1191     Counters.Counter private _tokenSupply;
1192 
1193     constructor(string memory _notRevealedURI) ERC721("FREE SHIT. Literally.", "FREESHIT")  {
1194         notRevealedURI = _notRevealedURI;
1195     }
1196 
1197     function totalSupply() public view returns (uint256) {
1198         return _tokenSupply.current();
1199     }
1200 
1201     function mintBulk(uint256 numberOfMints, address mintAddress) public payable onlyOwner{
1202         uint256 supply = _tokenSupply.current();
1203        for(uint256 i = 1; i <= numberOfMints; i++){
1204             _safeMint(mintAddress, supply + i);
1205             _tokenSupply.increment();
1206         }
1207     }
1208     
1209     function mint(uint256 numberOfMints) public payable{
1210         uint256 supply = _tokenSupply.current();
1211 
1212         if(balanceOfAddress[msg.sender] == 0){
1213             require(BMBuds.balanceOf(msg.sender) > 0, "Does not own Bear Market Buds");
1214             OgBalanceOfAddress[msg.sender] = BMBuds.balanceOf(msg.sender) + 1;
1215             balanceOfAddress[msg.sender] = BMBuds.balanceOf(msg.sender) + 1;
1216         }
1217 
1218         if(BMBuds.balanceOf(msg.sender) > OgBalanceOfAddress[msg.sender]){
1219             balanceOfAddress[msg.sender] = (BMBuds.balanceOf(msg.sender) - OgBalanceOfAddress[msg.sender]) + 1;
1220             OgBalanceOfAddress[msg.sender] = balanceOfAddress[msg.sender];
1221         }
1222 
1223         require(mintOpen, "Sale Needs To Be Active");
1224         require(balanceOfAddress[msg.sender] > 1, "No more Free Shits to claim");
1225         require((balanceOf(msg.sender) + numberOfMints) <= BMBuds.balanceOf(msg.sender), "Cannot claim more than Bear Market Buds owned!");
1226         require(supply.add(numberOfMints) <= maxSupply, "Payment exceeds total supply");
1227 
1228        for(uint256 i = 1; i <= numberOfMints; i++){
1229             _safeMint(msg.sender, supply + i);
1230             _tokenSupply.increment();
1231             balanceOfAddress[msg.sender] =  balanceOfAddress[msg.sender] - 1;
1232         }
1233     }
1234 
1235     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1236         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1237 
1238         if(revealToken == false) {
1239             return notRevealedURI;
1240         }
1241 
1242         string memory currentBaseURI = _baseURI();
1243         return bytes(currentBaseURI).length > 0
1244             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
1245             : "";
1246     }
1247 
1248     function linkBMBuds(address _BMBudsAddress) external onlyOwner(){
1249         BMBuds = IBMBuds(_BMBudsAddress);
1250     }
1251 
1252     function toggleSale() public onlyOwner {
1253         mintOpen = !mintOpen;
1254     }
1255 
1256     function _baseURI() internal view virtual override returns (string memory) {
1257         return baseURI;
1258     }
1259 
1260     function setbaseURI(string memory setBaseURI) public onlyOwner{
1261         baseURI = setBaseURI;
1262     }
1263 
1264     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1265         notRevealedURI = _notRevealedURI;
1266     }
1267 
1268     function reveal() public onlyOwner {
1269         revealToken = true;
1270     }
1271 
1272     function withdraw() public onlyOwner {
1273         uint256 balance = address(this).balance;
1274         payable(msg.sender).transfer(balance);
1275     }
1276 
1277 }