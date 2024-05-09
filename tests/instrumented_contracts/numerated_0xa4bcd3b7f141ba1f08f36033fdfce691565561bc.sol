1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-15
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.4;
7 
8 
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68 
69 library Counters {
70     struct Counter {
71         // This variable should never be directly accessed by users of the library: interactions must be restricted to
72         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
73         // this feature: see https://github.com/ethereum/solidity/issues/4637
74         uint256 _value; // default: 0
75     }
76 
77     function current(Counter storage counter) internal view returns (uint256) {
78         return counter._value;
79     }
80 
81     function increment(Counter storage counter) internal {
82         unchecked {
83             counter._value += 1;
84         }
85     }
86 
87     function decrement(Counter storage counter) internal {
88         uint256 value = counter._value;
89         require(value > 0, "Counter: decrement overflow");
90         unchecked {
91             counter._value = value - 1;
92         }
93     }
94 
95     function reset(Counter storage counter) internal {
96         counter._value = 0;
97     }
98 }
99 
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109 
110 library Address {
111     /**
112      * @dev Returns true if `account` is a contract.
113      *
114      * [IMPORTANT]
115      * ====
116      * It is unsafe to assume that an address for which this function returns
117      * false is an externally-owned account (EOA) and not a contract.
118      *
119      * Among others, `isContract` will return false for the following
120      * types of addresses:
121      *
122      *  - an externally-owned account
123      *  - a contract in construction
124      *  - an address where a contract will be created
125      *  - an address where a contract lived, but was destroyed
126      * ====
127      */
128     function isContract(address account) internal view returns (bool) {
129         // This method relies on extcodesize, which returns 0 for contracts in
130         // construction, since the code is only stored at the end of the
131         // constructor execution.
132 
133         uint256 size;
134         assembly {
135             size := extcodesize(account)
136         }
137         return size > 0;
138     }
139 
140     /**
141      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
142      * `recipient`, forwarding all available gas and reverting on errors.
143      *
144      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
145      * of certain opcodes, possibly making contracts go over the 2300 gas limit
146      * imposed by `transfer`, making them unable to receive funds via
147      * `transfer`. {sendValue} removes this limitation.
148      *
149      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
150      *
151      * IMPORTANT: because control is transferred to `recipient`, care must be
152      * taken to not create reentrancy vulnerabilities. Consider using
153      * {ReentrancyGuard} or the
154      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
155      */
156     function sendValue(address payable recipient, uint256 amount) internal {
157         require(address(this).balance >= amount, "Address: insufficient balance");
158 
159         (bool success, ) = recipient.call{value: amount}("");
160         require(success, "Address: unable to send value, recipient may have reverted");
161     }
162 
163     /**
164      * @dev Performs a Solidity function call using a low level `call`. A
165      * plain `call` is an unsafe replacement for a function call: use this
166      * function instead.
167      *
168      * If `target` reverts with a revert reason, it is bubbled up by this
169      * function (like regular Solidity function calls).
170      *
171      * Returns the raw returned data. To convert to the expected return value,
172      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
173      *
174      * Requirements:
175      *
176      * - `target` must be a contract.
177      * - calling `target` with `data` must not revert.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionCall(target, data, "Address: low-level call failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
187      * `errorMessage` as a fallback revert reason when `target` reverts.
188      *
189      * _Available since v3.1._
190      */
191     function functionCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, 0, errorMessage);
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
201      * but also transferring `value` wei to `target`.
202      *
203      * Requirements:
204      *
205      * - the calling contract must have an ETH balance of at least `value`.
206      * - the called Solidity function must be `payable`.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value
214     ) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
220      * with `errorMessage` as a fallback revert reason when `target` reverts.
221      *
222      * _Available since v3.1._
223      */
224     function functionCallWithValue(
225         address target,
226         bytes memory data,
227         uint256 value,
228         string memory errorMessage
229     ) internal returns (bytes memory) {
230         require(address(this).balance >= value, "Address: insufficient balance for call");
231         require(isContract(target), "Address: call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.call{value: value}(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
244         return functionStaticCall(target, data, "Address: low-level static call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a static call.
250      *
251      * _Available since v3.3._
252      */
253     function functionStaticCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal view returns (bytes memory) {
258         require(isContract(target), "Address: static call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.staticcall(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but performing a delegate call.
267      *
268      * _Available since v3.4._
269      */
270     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
276      * but performing a delegate call.
277      *
278      * _Available since v3.4._
279      */
280     function functionDelegateCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         require(isContract(target), "Address: delegate call to non-contract");
286 
287         (bool success, bytes memory returndata) = target.delegatecall(data);
288         return verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
293      * revert reason using the provided one.
294      *
295      * _Available since v4.3._
296      */
297     function verifyCallResult(
298         bool success,
299         bytes memory returndata,
300         string memory errorMessage
301     ) internal pure returns (bytes memory) {
302         if (success) {
303             return returndata;
304         } else {
305             // Look for revert reason and bubble it up if present
306             if (returndata.length > 0) {
307                 // The easiest way to bubble the revert reason is using memory via assembly
308 
309                 assembly {
310                     let returndata_size := mload(returndata)
311                     revert(add(32, returndata), returndata_size)
312                 }
313             } else {
314                 revert(errorMessage);
315             }
316         }
317     }
318 }
319 
320 interface IERC721Receiver {
321     /**
322      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
323      * by `operator` from `from`, this function is called.
324      *
325      * It must return its Solidity selector to confirm the token transfer.
326      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
327      *
328      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
329      */
330     function onERC721Received(
331         address operator,
332         address from,
333         uint256 tokenId,
334         bytes calldata data
335     ) external returns (bytes4);
336 }
337 
338 interface IERC165 {
339     /**
340      * @dev Returns true if this contract implements the interface defined by
341      * `interfaceId`. See the corresponding
342      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
343      * to learn more about how these ids are created.
344      *
345      * This function call must use less than 30 000 gas.
346      */
347     function supportsInterface(bytes4 interfaceId) external view returns (bool);
348 }
349 
350 abstract contract ERC165 is IERC165 {
351     /**
352      * @dev See {IERC165-supportsInterface}.
353      */
354     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
355         return interfaceId == type(IERC165).interfaceId;
356     }
357 }
358 
359 interface IERC721 is IERC165 {
360     /**
361      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
362      */
363     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
364 
365     /**
366      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
367      */
368     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
369 
370     /**
371      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
372      */
373     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
374 
375     /**
376      * @dev Returns the number of tokens in ``owner``'s account.
377      */
378     function balanceOf(address owner) external view returns (uint256 balance);
379 
380     /**
381      * @dev Returns the owner of the `tokenId` token.
382      *
383      * Requirements:
384      *
385      * - `tokenId` must exist.
386      */
387     function ownerOf(uint256 tokenId) external view returns (address owner);
388 
389     /**
390      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
391      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
392      *
393      * Requirements:
394      *
395      * - `from` cannot be the zero address.
396      * - `to` cannot be the zero address.
397      * - `tokenId` token must exist and be owned by `from`.
398      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
399      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
400      *
401      * Emits a {Transfer} event.
402      */
403     function safeTransferFrom(
404         address from,
405         address to,
406         uint256 tokenId
407     ) external;
408 
409     /**
410      * @dev Transfers `tokenId` token from `from` to `to`.
411      *
412      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must be owned by `from`.
419      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
420      *
421      * Emits a {Transfer} event.
422      */
423     function transferFrom(
424         address from,
425         address to,
426         uint256 tokenId
427     ) external;
428 
429     /**
430      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
431      * The approval is cleared when the token is transferred.
432      *
433      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
434      *
435      * Requirements:
436      *
437      * - The caller must own the token or be an approved operator.
438      * - `tokenId` must exist.
439      *
440      * Emits an {Approval} event.
441      */
442     function approve(address to, uint256 tokenId) external;
443 
444     /**
445      * @dev Returns the account approved for `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function getApproved(uint256 tokenId) external view returns (address operator);
452 
453     /**
454      * @dev Approve or remove `operator` as an operator for the caller.
455      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
456      *
457      * Requirements:
458      *
459      * - The `operator` cannot be the caller.
460      *
461      * Emits an {ApprovalForAll} event.
462      */
463     function setApprovalForAll(address operator, bool _approved) external;
464 
465     /**
466      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
467      *
468      * See {setApprovalForAll}
469      */
470     function isApprovedForAll(address owner, address operator) external view returns (bool);
471 
472     /**
473      * @dev Safely transfers `tokenId` token from `from` to `to`.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must exist and be owned by `from`.
480      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
481      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
482      *
483      * Emits a {Transfer} event.
484      */
485     function safeTransferFrom(
486         address from,
487         address to,
488         uint256 tokenId,
489         bytes calldata data
490     ) external;
491 }
492 
493 interface IERC721Metadata is IERC721 {
494     /**
495      * @dev Returns the token collection name.
496      */
497     function name() external view returns (string memory);
498 
499     /**
500      * @dev Returns the token collection symbol.
501      */
502     function symbol() external view returns (string memory);
503 
504     /**
505      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
506      */
507     function tokenURI(uint256 tokenId) external view returns (string memory);
508 }
509 
510 library SafeMath {
511     /**
512      * @dev Returns the addition of two unsigned integers, with an overflow flag.
513      *
514      * _Available since v3.4._
515      */
516     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
517         unchecked {
518             uint256 c = a + b;
519             if (c < a) return (false, 0);
520             return (true, c);
521         }
522     }
523 
524     /**
525      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
526      *
527      * _Available since v3.4._
528      */
529     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
530         unchecked {
531             if (b > a) return (false, 0);
532             return (true, a - b);
533         }
534     }
535 
536     /**
537      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
538      *
539      * _Available since v3.4._
540      */
541     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
542         unchecked {
543             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
544             // benefit is lost if 'b' is also tested.
545             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
546             if (a == 0) return (true, 0);
547             uint256 c = a * b;
548             if (c / a != b) return (false, 0);
549             return (true, c);
550         }
551     }
552 
553     /**
554      * @dev Returns the division of two unsigned integers, with a division by zero flag.
555      *
556      * _Available since v3.4._
557      */
558     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
559         unchecked {
560             if (b == 0) return (false, 0);
561             return (true, a / b);
562         }
563     }
564 
565     /**
566      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
567      *
568      * _Available since v3.4._
569      */
570     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
571         unchecked {
572             if (b == 0) return (false, 0);
573             return (true, a % b);
574         }
575     }
576 
577     /**
578      * @dev Returns the addition of two unsigned integers, reverting on
579      * overflow.
580      *
581      * Counterpart to Solidity's `+` operator.
582      *
583      * Requirements:
584      *
585      * - Addition cannot overflow.
586      */
587     function add(uint256 a, uint256 b) internal pure returns (uint256) {
588         return a + b;
589     }
590 
591     /**
592      * @dev Returns the subtraction of two unsigned integers, reverting on
593      * overflow (when the result is negative).
594      *
595      * Counterpart to Solidity's `-` operator.
596      *
597      * Requirements:
598      *
599      * - Subtraction cannot overflow.
600      */
601     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
602         return a - b;
603     }
604 
605     /**
606      * @dev Returns the multiplication of two unsigned integers, reverting on
607      * overflow.
608      *
609      * Counterpart to Solidity's `*` operator.
610      *
611      * Requirements:
612      *
613      * - Multiplication cannot overflow.
614      */
615     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
616         return a * b;
617     }
618 
619     /**
620      * @dev Returns the integer division of two unsigned integers, reverting on
621      * division by zero. The result is rounded towards zero.
622      *
623      * Counterpart to Solidity's `/` operator.
624      *
625      * Requirements:
626      *
627      * - The divisor cannot be zero.
628      */
629     function div(uint256 a, uint256 b) internal pure returns (uint256) {
630         return a / b;
631     }
632 
633     /**
634      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
635      * reverting when dividing by zero.
636      *
637      * Counterpart to Solidity's `%` operator. This function uses a `revert`
638      * opcode (which leaves remaining gas untouched) while Solidity uses an
639      * invalid opcode to revert (consuming all remaining gas).
640      *
641      * Requirements:
642      *
643      * - The divisor cannot be zero.
644      */
645     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
646         return a % b;
647     }
648 
649     /**
650      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
651      * overflow (when the result is negative).
652      *
653      * CAUTION: This function is deprecated because it requires allocating memory for the error
654      * message unnecessarily. For custom revert reasons use {trySub}.
655      *
656      * Counterpart to Solidity's `-` operator.
657      *
658      * Requirements:
659      *
660      * - Subtraction cannot overflow.
661      */
662     function sub(
663         uint256 a,
664         uint256 b,
665         string memory errorMessage
666     ) internal pure returns (uint256) {
667         unchecked {
668             require(b <= a, errorMessage);
669             return a - b;
670         }
671     }
672 
673     /**
674      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
675      * division by zero. The result is rounded towards zero.
676      *
677      * Counterpart to Solidity's `/` operator. Note: this function uses a
678      * `revert` opcode (which leaves remaining gas untouched) while Solidity
679      * uses an invalid opcode to revert (consuming all remaining gas).
680      *
681      * Requirements:
682      *
683      * - The divisor cannot be zero.
684      */
685     function div(
686         uint256 a,
687         uint256 b,
688         string memory errorMessage
689     ) internal pure returns (uint256) {
690         unchecked {
691             require(b > 0, errorMessage);
692             return a / b;
693         }
694     }
695 
696     /**
697      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
698      * reverting with custom message when dividing by zero.
699      *
700      * CAUTION: This function is deprecated because it requires allocating memory for the error
701      * message unnecessarily. For custom revert reasons use {tryMod}.
702      *
703      * Counterpart to Solidity's `%` operator. This function uses a `revert`
704      * opcode (which leaves remaining gas untouched) while Solidity uses an
705      * invalid opcode to revert (consuming all remaining gas).
706      *
707      * Requirements:
708      *
709      * - The divisor cannot be zero.
710      */
711     function mod(
712         uint256 a,
713         uint256 b,
714         string memory errorMessage
715     ) internal pure returns (uint256) {
716         unchecked {
717             require(b > 0, errorMessage);
718             return a % b;
719         }
720     }
721 }
722 
723 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
724     using Address for address;
725     using Strings for uint256;
726 
727     // Token name
728     string private _name;
729 
730     // Token symbol
731     string private _symbol;
732 
733     // Mapping from token ID to owner address
734     mapping(uint256 => address) private _owners;
735 
736     // Mapping owner address to token count
737     mapping(address => uint256) private _balances;
738 
739     // Mapping from token ID to approved address
740     mapping(uint256 => address) private _tokenApprovals;
741 
742     // Mapping from owner to operator approvals
743     mapping(address => mapping(address => bool)) private _operatorApprovals;
744 
745     /**
746      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
747      */
748     constructor(string memory name_, string memory symbol_) {
749         _name = name_;
750         _symbol = symbol_;
751     }
752 
753     /**
754      * @dev See {IERC165-supportsInterface}.
755      */
756     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
757         return
758             interfaceId == type(IERC721).interfaceId ||
759             interfaceId == type(IERC721Metadata).interfaceId ||
760             super.supportsInterface(interfaceId);
761     }
762 
763     /**
764      * @dev See {IERC721-balanceOf}.
765      */
766     function balanceOf(address owner) public view virtual override returns (uint256) {
767         require(owner != address(0), "ERC721: balance query for the zero address");
768         return _balances[owner];
769     }
770 
771     /**
772      * @dev See {IERC721-ownerOf}.
773      */
774     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
775         address owner = _owners[tokenId];
776         require(owner != address(0), "ERC721: owner query for nonexistent token");
777         return owner;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-name}.
782      */
783     function name() public view virtual override returns (string memory) {
784         return _name;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-symbol}.
789      */
790     function symbol() public view virtual override returns (string memory) {
791         return _symbol;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-tokenURI}.
796      */
797     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
798         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
799 
800         string memory baseURI = _baseURI();
801         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
802     }
803 
804     /**
805      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
806      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
807      * by default, can be overriden in child contracts.
808      */
809     function _baseURI() internal view virtual returns (string memory) {
810         return "";
811     }
812 
813     /**
814      * @dev See {IERC721-approve}.
815      */
816     function approve(address to, uint256 tokenId) public virtual override {
817         address owner = ERC721.ownerOf(tokenId);
818         require(to != owner, "ERC721: approval to current owner");
819 
820         require(
821             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
822             "ERC721: approve caller is not owner nor approved for all"
823         );
824 
825         _approve(to, tokenId);
826     }
827 
828     /**
829      * @dev See {IERC721-getApproved}.
830      */
831     function getApproved(uint256 tokenId) public view virtual override returns (address) {
832         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
833 
834         return _tokenApprovals[tokenId];
835     }
836 
837     /**
838      * @dev See {IERC721-setApprovalForAll}.
839      */
840     function setApprovalForAll(address operator, bool approved) public virtual override {
841         require(operator != _msgSender(), "ERC721: approve to caller");
842 
843         _operatorApprovals[_msgSender()][operator] = approved;
844         emit ApprovalForAll(_msgSender(), operator, approved);
845     }
846 
847     /**
848      * @dev See {IERC721-isApprovedForAll}.
849      */
850     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
851         return _operatorApprovals[owner][operator];
852     }
853 
854     /**
855      * @dev See {IERC721-transferFrom}.
856      */
857     function transferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public virtual override {
862         //solhint-disable-next-line max-line-length
863         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
864 
865         _transfer(from, to, tokenId);
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId
875     ) public virtual override {
876         safeTransferFrom(from, to, tokenId, "");
877     }
878 
879     /**
880      * @dev See {IERC721-safeTransferFrom}.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) public virtual override {
888         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
889         _safeTransfer(from, to, tokenId, _data);
890     }
891 
892     /**
893      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
894      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
895      *
896      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
897      *
898      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
899      * implement alternative mechanisms to perform token transfer, such as signature-based.
900      *
901      * Requirements:
902      *
903      * - `from` cannot be the zero address.
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must exist and be owned by `from`.
906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _safeTransfer(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) internal virtual {
916         _transfer(from, to, tokenId);
917         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
918     }
919 
920     /**
921      * @dev Returns whether `tokenId` exists.
922      *
923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
924      *
925      * Tokens start existing when they are minted (`_mint`),
926      * and stop existing when they are burned (`_burn`).
927      */
928     function _exists(uint256 tokenId) internal view virtual returns (bool) {
929         return _owners[tokenId] != address(0);
930     }
931 
932     /**
933      * @dev Returns whether `spender` is allowed to manage `tokenId`.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      */
939     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
940         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
941         address owner = ERC721.ownerOf(tokenId);
942         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
943     }
944 
945     /**
946      * @dev Safely mints `tokenId` and transfers it to `to`.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must not exist.
951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _safeMint(address to, uint256 tokenId) internal virtual {
956         _safeMint(to, tokenId, "");
957     }
958 
959     /**
960      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
961      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
962      */
963     function _safeMint(
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) internal virtual {
968         _mint(to, tokenId);
969         require(
970             _checkOnERC721Received(address(0), to, tokenId, _data),
971             "ERC721: transfer to non ERC721Receiver implementer"
972         );
973     }
974 
975     /**
976      * @dev Mints `tokenId` and transfers it to `to`.
977      *
978      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
979      *
980      * Requirements:
981      *
982      * - `tokenId` must not exist.
983      * - `to` cannot be the zero address.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _mint(address to, uint256 tokenId) internal virtual {
988         require(to != address(0), "ERC721: mint to the zero address");
989         require(!_exists(tokenId), "ERC721: token already minted");
990 
991         _beforeTokenTransfer(address(0), to, tokenId);
992 
993         _balances[to] += 1;
994         _owners[tokenId] = to;
995 
996         emit Transfer(address(0), to, tokenId);
997     }
998 
999     /**
1000      * @dev Destroys `tokenId`.
1001      * The approval is cleared when the token is burned.
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must exist.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _burn(uint256 tokenId) internal virtual {
1010         address owner = ERC721.ownerOf(tokenId);
1011 
1012         _beforeTokenTransfer(owner, address(0), tokenId);
1013 
1014         // Clear approvals
1015         _approve(address(0), tokenId);
1016 
1017         _balances[owner] -= 1;
1018         delete _owners[tokenId];
1019 
1020         emit Transfer(owner, address(0), tokenId);
1021     }
1022 
1023     /**
1024      * @dev Transfers `tokenId` from `from` to `to`.
1025      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1026      *
1027      * Requirements:
1028      *
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must be owned by `from`.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _transfer(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) internal virtual {
1039         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1040         require(to != address(0), "ERC721: transfer to the zero address");
1041 
1042         _beforeTokenTransfer(from, to, tokenId);
1043 
1044         // Clear approvals from the previous owner
1045         _approve(address(0), tokenId);
1046 
1047         _balances[from] -= 1;
1048         _balances[to] += 1;
1049         _owners[tokenId] = to;
1050 
1051         emit Transfer(from, to, tokenId);
1052     }
1053 
1054     /**
1055      * @dev Approve `to` to operate on `tokenId`
1056      *
1057      * Emits a {Approval} event.
1058      */
1059     function _approve(address to, uint256 tokenId) internal virtual {
1060         _tokenApprovals[tokenId] = to;
1061         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1066      * The call is not executed if the target address is not a contract.
1067      *
1068      * @param from address representing the previous owner of the given token ID
1069      * @param to target address that will receive the tokens
1070      * @param tokenId uint256 ID of the token to be transferred
1071      * @param _data bytes optional data to send along with the call
1072      * @return bool whether the call correctly returned the expected magic value
1073      */
1074     function _checkOnERC721Received(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) private returns (bool) {
1080         if (to.isContract()) {
1081             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1082                 return retval == IERC721Receiver.onERC721Received.selector;
1083             } catch (bytes memory reason) {
1084                 if (reason.length == 0) {
1085                     revert("ERC721: transfer to non ERC721Receiver implementer");
1086                 } else {
1087                     assembly {
1088                         revert(add(32, reason), mload(reason))
1089                     }
1090                 }
1091             }
1092         } else {
1093             return true;
1094         }
1095     }
1096 
1097     /**
1098      * @dev Hook that is called before any token transfer. This includes minting
1099      * and burning.
1100      *
1101      * Calling conditions:
1102      *
1103      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1104      * transferred to `to`.
1105      * - When `from` is zero, `tokenId` will be minted for `to`.
1106      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1107      * - `from` and `to` are never both zero.
1108      *
1109      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1110      */
1111     function _beforeTokenTransfer(
1112         address from,
1113         address to,
1114         uint256 tokenId
1115     ) internal virtual {}
1116 }
1117 
1118 abstract contract Ownable is Context {
1119     address private _owner;
1120 
1121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1122 
1123     /**
1124      * @dev Initializes the contract setting the deployer as the initial owner.
1125      */
1126     constructor() {
1127         _setOwner(_msgSender());
1128     }
1129 
1130     /**
1131      * @dev Returns the address of the current owner.
1132      */
1133     function owner() public view virtual returns (address) {
1134         return _owner;
1135     }
1136 
1137     /**
1138      * @dev Throws if called by any account other than the owner.
1139      */
1140     modifier onlyOwner() {
1141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1142         _;
1143     }
1144 
1145     /**
1146      * @dev Leaves the contract without owner. It will not be possible to call
1147      * `onlyOwner` functions anymore. Can only be called by the current owner.
1148      *
1149      * NOTE: Renouncing ownership will leave the contract without an owner,
1150      * thereby removing any functionality that is only available to the owner.
1151      */
1152     function renounceOwnership() public virtual onlyOwner {
1153         _setOwner(address(0));
1154     }
1155 
1156     /**
1157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1158      * Can only be called by the current owner.
1159      */
1160     function transferOwnership(address newOwner) public virtual onlyOwner {
1161         require(newOwner != address(0), "Ownable: new owner is the zero address");
1162         _setOwner(newOwner);
1163     }
1164 
1165     function _setOwner(address newOwner) private {
1166         address oldOwner = _owner;
1167         _owner = newOwner;
1168         emit OwnershipTransferred(oldOwner, newOwner);
1169     }
1170 }
1171 
1172 contract ArtsyMonke is ERC721, Ownable
1173 {
1174     using Counters for Counters.Counter;
1175     using SafeMath for uint256;
1176 
1177     uint256 public price = .01 ether;
1178     uint256 public maxSupply = 10000;
1179     uint256 private maxMint = 50;
1180 
1181     string private customBaseURI;
1182     string private baseExtension;
1183 
1184     bool public mintOpen = false;
1185 
1186     Counters.Counter private _tokenSupply;
1187 
1188     constructor(string memory _customBaseURI) ERC721("Artsy Monke", "ArtsyMonke")  {
1189         customBaseURI = _customBaseURI;
1190     }
1191 
1192     function totalSupply() public view returns (uint256) {
1193         return _tokenSupply.current();
1194     }
1195 
1196     function mintBulk(uint256 numberOfMints, address mintAddress) public payable onlyOwner{
1197         uint256 supply = _tokenSupply.current();
1198        for(uint256 i = 1; i <= numberOfMints; i++){
1199             _safeMint(mintAddress, supply + i);
1200             _tokenSupply.increment();
1201         }
1202     }
1203 
1204     function mint(uint256 numberOfMints) external payable {
1205         uint256 supply = _tokenSupply.current();
1206         require(mintOpen, "Sale Needs To Be Active");
1207         require(numberOfMints > 0 && numberOfMints <= maxMint, "Invalid purchase amount");
1208         require(supply.add(numberOfMints) <= maxSupply, "Payment exceeds total supply");
1209 
1210        for(uint256 i = 1; i <= numberOfMints; i++){
1211             _safeMint(msg.sender, supply + i);
1212             _tokenSupply.increment();
1213         }
1214     }
1215 
1216     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1217         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1218         string memory currentBaseURI = _baseURI();
1219         return bytes(currentBaseURI).length > 0
1220             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
1221             : "";
1222     }
1223 
1224     function toggleSale() public onlyOwner {
1225         mintOpen = !mintOpen;
1226     }
1227 
1228     function _baseURI() internal view virtual override returns (string memory) {
1229         return customBaseURI;
1230     }
1231 
1232     function setBaseURI(string calldata _newBaseURI) external onlyOwner {
1233         customBaseURI = _newBaseURI;
1234     }
1235 
1236     function setMaxMint(uint256 _maxMint) external onlyOwner {
1237         maxMint = _maxMint;
1238     }
1239 
1240     function withdraw() public onlyOwner {
1241         uint256 balance = address(this).balance;
1242         payable(msg.sender).transfer(balance);
1243     }
1244 
1245 }