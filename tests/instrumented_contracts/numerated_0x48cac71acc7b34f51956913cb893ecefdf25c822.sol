1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, with an overflow flag.
7      *
8      * _Available since v3.4._
9      */
10     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
11         unchecked {
12             uint256 c = a + b;
13             if (c < a) return (false, 0);
14             return (true, c);
15         }
16     }
17 
18     /**
19      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             if (b > a) return (false, 0);
26             return (true, a - b);
27         }
28     }
29 
30     /**
31      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38             // benefit is lost if 'b' is also tested.
39             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40             if (a == 0) return (true, 0);
41             uint256 c = a * b;
42             if (c / a != b) return (false, 0);
43             return (true, c);
44         }
45     }
46 
47     /**
48      * @dev Returns the division of two unsigned integers, with a division by zero flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             if (b == 0) return (false, 0);
55             return (true, a / b);
56         }
57     }
58 
59     /**
60      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             if (b == 0) return (false, 0);
67             return (true, a % b);
68         }
69     }
70 
71     /**
72      * @dev Returns the addition of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `+` operator.
76      *
77      * Requirements:
78      *
79      * - Addition cannot overflow.
80      */
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a + b;
83     }
84 
85     /**
86      * @dev Returns the subtraction of two unsigned integers, reverting on
87      * overflow (when the result is negative).
88      *
89      * Counterpart to Solidity's `-` operator.
90      *
91      * Requirements:
92      *
93      * - Subtraction cannot overflow.
94      */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a - b;
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      *
107      * - Multiplication cannot overflow.
108      */
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a * b;
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers, reverting on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator.
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a / b;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * reverting when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a % b;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * CAUTION: This function is deprecated because it requires allocating memory for the error
148      * message unnecessarily. For custom revert reasons use {trySub}.
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(
157         uint256 a,
158         uint256 b,
159         string memory errorMessage
160     ) internal pure returns (uint256) {
161         unchecked {
162             require(b <= a, errorMessage);
163             return a - b;
164         }
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(
180         uint256 a,
181         uint256 b,
182         string memory errorMessage
183     ) internal pure returns (uint256) {
184         unchecked {
185             require(b > 0, errorMessage);
186             return a / b;
187         }
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * reverting with custom message when dividing by zero.
193      *
194      * CAUTION: This function is deprecated because it requires allocating memory for the error
195      * message unnecessarily. For custom revert reasons use {tryMod}.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(
206         uint256 a,
207         uint256 b,
208         string memory errorMessage
209     ) internal pure returns (uint256) {
210         unchecked {
211             require(b > 0, errorMessage);
212             return a % b;
213         }
214     }
215 }
216 
217 pragma solidity ^0.8.0;
218 library Strings {
219     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
220 
221     /**
222      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
223      */
224     function toString(uint256 value) internal pure returns (string memory) {
225         // Inspired by OraclizeAPI's implementation - MIT licence
226         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
227 
228         if (value == 0) {
229             return "0";
230         }
231         uint256 temp = value;
232         uint256 digits;
233         while (temp != 0) {
234             digits++;
235             temp /= 10;
236         }
237         bytes memory buffer = new bytes(digits);
238         while (value != 0) {
239             digits -= 1;
240             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
241             value /= 10;
242         }
243         return string(buffer);
244     }
245 
246     /**
247      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
248      */
249     function toHexString(uint256 value) internal pure returns (string memory) {
250         if (value == 0) {
251             return "0x00";
252         }
253         uint256 temp = value;
254         uint256 length = 0;
255         while (temp != 0) {
256             length++;
257             temp >>= 8;
258         }
259         return toHexString(value, length);
260     }
261 
262     /**
263      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
264      */
265     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
266         bytes memory buffer = new bytes(2 * length + 2);
267         buffer[0] = "0";
268         buffer[1] = "x";
269         for (uint256 i = 2 * length + 1; i > 1; --i) {
270             buffer[i] = _HEX_SYMBOLS[value & 0xf];
271             value >>= 4;
272         }
273         require(value == 0, "Strings: hex length insufficient");
274         return string(buffer);
275     }
276 }
277 
278 pragma solidity ^0.8.0;
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies on extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         uint256 size;
303         assembly {
304             size := extcodesize(account)
305         }
306         return size > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         (bool success, ) = recipient.call{value: amount}("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain `call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(address(this).balance >= value, "Address: insufficient balance for call");
400         require(isContract(target), "Address: call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.call{value: value}(data);
403         return _verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
413         return functionStaticCall(target, data, "Address: low-level static call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal view returns (bytes memory) {
427         require(isContract(target), "Address: static call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.staticcall(data);
430         return _verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
440         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a delegate call.
446      *
447      * _Available since v3.4._
448      */
449     function functionDelegateCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(isContract(target), "Address: delegate call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.delegatecall(data);
457         return _verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     function _verifyCallResult(
461         bool success,
462         bytes memory returndata,
463         string memory errorMessage
464     ) private pure returns (bytes memory) {
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 pragma solidity ^0.8.0;
484 interface IERC721Receiver {
485     /**
486      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
487      * by `operator` from `from`, this function is called.
488      *
489      * It must return its Solidity selector to confirm the token transfer.
490      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
491      *
492      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
493      */
494     function onERC721Received(
495         address operator,
496         address from,
497         uint256 tokenId,
498         bytes calldata data
499     ) external returns (bytes4);
500 }
501 
502 pragma solidity ^0.8.0;
503 interface IERC165 {
504     /**
505      * @dev Returns true if this contract implements the interface defined by
506      * `interfaceId`. See the corresponding
507      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
508      * to learn more about how these ids are created.
509      *
510      * This function call must use less than 30 000 gas.
511      */
512     function supportsInterface(bytes4 interfaceId) external view returns (bool);
513 }
514 
515 pragma solidity ^0.8.0;
516 abstract contract ERC165 is IERC165 {
517     /**
518      * @dev See {IERC165-supportsInterface}.
519      */
520     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
521         return interfaceId == type(IERC165).interfaceId;
522     }
523 }
524 
525 pragma solidity ^0.8.0;
526 interface IERC721 is IERC165 {
527     /**
528      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
529      */
530     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
534      */
535     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
539      */
540     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
541 
542     /**
543      * @dev Returns the number of tokens in ``owner``'s account.
544      */
545     function balanceOf(address owner) external view returns (uint256 balance);
546 
547     /**
548      * @dev Returns the owner of the `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function ownerOf(uint256 tokenId) external view returns (address owner);
555 
556     /**
557      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
558      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must exist and be owned by `from`.
565      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
567      *
568      * Emits a {Transfer} event.
569      */
570     function safeTransferFrom(
571         address from,
572         address to,
573         uint256 tokenId
574     ) external;
575 
576     /**
577      * @dev Transfers `tokenId` token from `from` to `to`.
578      *
579      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must be owned by `from`.
586      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
587      *
588      * Emits a {Transfer} event.
589      */
590     function transferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
598      * The approval is cleared when the token is transferred.
599      *
600      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
601      *
602      * Requirements:
603      *
604      * - The caller must own the token or be an approved operator.
605      * - `tokenId` must exist.
606      *
607      * Emits an {Approval} event.
608      */
609     function approve(address to, uint256 tokenId) external;
610 
611     /**
612      * @dev Returns the account approved for `tokenId` token.
613      *
614      * Requirements:
615      *
616      * - `tokenId` must exist.
617      */
618     function getApproved(uint256 tokenId) external view returns (address operator);
619 
620     /**
621      * @dev Approve or remove `operator` as an operator for the caller.
622      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
623      *
624      * Requirements:
625      *
626      * - The `operator` cannot be the caller.
627      *
628      * Emits an {ApprovalForAll} event.
629      */
630     function setApprovalForAll(address operator, bool _approved) external;
631 
632     /**
633      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
634      *
635      * See {setApprovalForAll}
636      */
637     function isApprovedForAll(address owner, address operator) external view returns (bool);
638 
639     /**
640      * @dev Safely transfers `tokenId` token from `from` to `to`.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must exist and be owned by `from`.
647      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
648      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
649      *
650      * Emits a {Transfer} event.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 tokenId,
656         bytes calldata data
657     ) external;
658 }
659 
660 pragma solidity ^0.8.0;
661 interface IERC721Enumerable is IERC721 {
662     /**
663      * @dev Returns the total amount of tokens stored by the contract.
664      */
665     function totalSupply() external view returns (uint256);
666 
667     /**
668      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
669      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
670      */
671     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
672 
673     /**
674      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
675      * Use along with {totalSupply} to enumerate all tokens.
676      */
677     function tokenByIndex(uint256 index) external view returns (uint256);
678 }
679 
680 pragma solidity ^0.8.0;
681 interface IERC721Metadata is IERC721 {
682     /**
683      * @dev Returns the token collection name.
684      */
685     function name() external view returns (string memory);
686 
687     /**
688      * @dev Returns the token collection symbol.
689      */
690     function symbol() external view returns (string memory);
691 
692     /**
693      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
694      */
695     function tokenURI(uint256 tokenId) external view returns (string memory);
696 }
697 
698 pragma solidity ^0.8.0;
699 abstract contract Context {
700     function _msgSender() internal view virtual returns (address) {
701         return msg.sender;
702     }
703 
704     function _msgData() internal view virtual returns (bytes calldata) {
705         return msg.data;
706     }
707 }
708 
709 pragma solidity ^0.8.0;
710 abstract contract Ownable is Context {
711     address private _owner;
712 
713     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
714 
715     /**
716      * @dev Initializes the contract setting the deployer as the initial owner.
717      */
718     constructor () {
719         address msgSender = _msgSender();
720         _owner = msgSender;
721         emit OwnershipTransferred(address(0), msgSender);
722     }
723 
724     /**
725      * @dev Returns the address of the current owner.
726      */
727     function owner() public view virtual returns (address) {
728         return _owner;
729     }
730 
731     /**
732      * @dev Throws if called by any account other than the owner.
733      */
734     modifier onlyOwner() {
735         require(owner() == _msgSender(), "Ownable: caller is not the owner");
736         _;
737     }
738 
739     /**
740      * @dev Leaves the contract without owner. It will not be possible to call
741      * `onlyOwner` functions anymore. Can only be called by the current owner.
742      *
743      * NOTE: Renouncing ownership will leave the contract without an owner,
744      * thereby removing any functionality that is only available to the owner.
745      */
746 
747     /**
748      * @dev Transfers ownership of the contract to a new account (`newOwner`).
749      * Can only be called by the current owner.
750      */
751     function transferOwnership(address newOwner) public virtual onlyOwner {
752         require(newOwner != address(0), "Ownable: new owner is the zero address");
753         _setOwner(newOwner);
754     }
755 
756     function _setOwner(address newOwner) private {
757         address oldOwner = _owner;
758         _owner = newOwner;
759         emit OwnershipTransferred(oldOwner, newOwner);
760     }
761 }
762 
763 pragma solidity ^0.8.0;
764 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
765     using Address for address;
766     using Strings for uint256;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to owner address
775     mapping(uint256 => address) private _owners;
776 
777     // Mapping owner address to token count
778     mapping(address => uint256) private _balances;
779 
780     // Mapping from token ID to approved address
781     mapping(uint256 => address) private _tokenApprovals;
782 
783     // Mapping from owner to operator approvals
784     mapping(address => mapping(address => bool)) private _operatorApprovals;
785 
786 
787     string public _baseURI;
788     /**
789      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
790      */
791     constructor(string memory name_, string memory symbol_) {
792         _name = name_;
793         _symbol = symbol_;
794     }
795 
796     /**
797      * @dev See {IERC165-supportsInterface}.
798      */
799     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
800         return
801             interfaceId == type(IERC721).interfaceId ||
802             interfaceId == type(IERC721Metadata).interfaceId ||
803             super.supportsInterface(interfaceId);
804     }
805 
806     /**
807      * @dev See {IERC721-balanceOf}.
808      */
809     function balanceOf(address owner) public view virtual override returns (uint256) {
810         require(owner != address(0), "ERC721: balance query for the zero address");
811         return _balances[owner];
812     }
813 
814     /**
815      * @dev See {IERC721-ownerOf}.
816      */
817     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
818         address owner = _owners[tokenId];
819         require(owner != address(0), "ERC721: owner query for nonexistent token");
820         return owner;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-name}.
825      */
826     function name() public view virtual override returns (string memory) {
827         return _name;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-symbol}.
832      */
833     function symbol() public view virtual override returns (string memory) {
834         return _symbol;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-tokenURI}.
839      */
840     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
841         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
842 
843         string memory base = baseURI();
844         return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString())) : "";
845     }
846 
847     /**
848      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
849      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
850      * by default, can be overriden in child contracts.
851      */
852     function baseURI() internal view virtual returns (string memory) {
853         return _baseURI;
854     }
855 
856     /**
857      * @dev See {IERC721-approve}.
858      */
859     function approve(address to, uint256 tokenId) public virtual override {
860         address owner = ERC721.ownerOf(tokenId);
861         require(to != owner, "ERC721: approval to current owner");
862 
863         require(
864             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
865             "ERC721: approve caller is not owner nor approved for all"
866         );
867 
868         _approve(to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-getApproved}.
873      */
874     function getApproved(uint256 tokenId) public view virtual override returns (address) {
875         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
876 
877         return _tokenApprovals[tokenId];
878     }
879 
880     /**
881      * @dev See {IERC721-setApprovalForAll}.
882      */
883     function setApprovalForAll(address operator, bool approved) public virtual override {
884         require(operator != _msgSender(), "ERC721: approve to caller");
885 
886         _operatorApprovals[_msgSender()][operator] = approved;
887         emit ApprovalForAll(_msgSender(), operator, approved);
888     }
889 
890     /**
891      * @dev See {IERC721-isApprovedForAll}.
892      */
893     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
894         return _operatorApprovals[owner][operator];
895     }
896 
897     /**
898      * @dev See {IERC721-transferFrom}.
899      */
900     function transferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         //solhint-disable-next-line max-line-length
906         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
907 
908         _transfer(from, to, tokenId);
909     }
910 
911     /**
912      * @dev See {IERC721-safeTransferFrom}.
913      */
914     function safeTransferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public virtual override {
919         safeTransferFrom(from, to, tokenId, "");
920     }
921 
922     /**
923      * @dev See {IERC721-safeTransferFrom}.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory _data
930     ) public virtual override {
931         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
932         _safeTransfer(from, to, tokenId, _data);
933     }
934 
935     /**
936      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
937      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
938      *
939      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
940      *
941      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
942      * implement alternative mechanisms to perform token transfer, such as signature-based.
943      *
944      * Requirements:
945      *
946      * - `from` cannot be the zero address.
947      * - `to` cannot be the zero address.
948      * - `tokenId` token must exist and be owned by `from`.
949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _safeTransfer(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) internal virtual {
959         _transfer(from, to, tokenId);
960         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
961     }
962 
963     /**
964      * @dev Returns whether `tokenId` exists.
965      *
966      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
967      *
968      * Tokens start existing when they are minted (`_mint`),
969      * and stop existing when they are burned (`_burn`).
970      */
971     function _exists(uint256 tokenId) internal view virtual returns (bool) {
972         return _owners[tokenId] != address(0);
973     }
974 
975     /**
976      * @dev Returns whether `spender` is allowed to manage `tokenId`.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must exist.
981      */
982     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
983         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
984         address owner = ERC721.ownerOf(tokenId);
985         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
986     }
987 
988     /**
989      * @dev Safely mints `tokenId` and transfers it to `to`.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must not exist.
994      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _safeMint(address to, uint256 tokenId) internal virtual {
999         _safeMint(to, tokenId, "");
1000     }
1001 
1002     /**
1003      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1004      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1005      */
1006     function _safeMint(
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) internal virtual {
1011         _mint(to, tokenId);
1012         require(
1013             _checkOnERC721Received(address(0), to, tokenId, _data),
1014             "ERC721: transfer to non ERC721Receiver implementer"
1015         );
1016     }
1017 
1018     /**
1019      * @dev Mints `tokenId` and transfers it to `to`.
1020      *
1021      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must not exist.
1026      * - `to` cannot be the zero address.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _mint(address to, uint256 tokenId) internal virtual {
1031         require(to != address(0), "ERC721: mint to the zero address");
1032         require(!_exists(tokenId), "ERC721: token already minted");
1033 
1034         _beforeTokenTransfer(address(0), to, tokenId);
1035 
1036         _balances[to] += 1;
1037         _owners[tokenId] = to;
1038 
1039         emit Transfer(address(0), to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev Destroys `tokenId`.
1044      * The approval is cleared when the token is burned.
1045      *
1046      * Requirements:
1047      *
1048      * - `tokenId` must exist.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _burn(uint256 tokenId) internal virtual {
1053         address owner = ERC721.ownerOf(tokenId);
1054 
1055         _beforeTokenTransfer(owner, address(0), tokenId);
1056 
1057         // Clear approvals
1058         _approve(address(0), tokenId);
1059 
1060         _balances[owner] -= 1;
1061         delete _owners[tokenId];
1062 
1063         emit Transfer(owner, address(0), tokenId);
1064     }
1065 
1066     /**
1067      * @dev Transfers `tokenId` from `from` to `to`.
1068      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1069      *
1070      * Requirements:
1071      *
1072      * - `to` cannot be the zero address.
1073      * - `tokenId` token must be owned by `from`.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _transfer(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) internal virtual {
1082         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1083         require(to != address(0), "ERC721: transfer to the zero address");
1084 
1085         _beforeTokenTransfer(from, to, tokenId);
1086 
1087         // Clear approvals from the previous owner
1088         _approve(address(0), tokenId);
1089 
1090         _balances[from] -= 1;
1091         _balances[to] += 1;
1092         _owners[tokenId] = to;
1093 
1094         emit Transfer(from, to, tokenId);
1095     }
1096 
1097     /**
1098      * @dev Approve `to` to operate on `tokenId`
1099      *
1100      * Emits a {Approval} event.
1101      */
1102     function _approve(address to, uint256 tokenId) internal virtual {
1103         _tokenApprovals[tokenId] = to;
1104         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1109      * The call is not executed if the target address is not a contract.
1110      *
1111      * @param from address representing the previous owner of the given token ID
1112      * @param to target address that will receive the tokens
1113      * @param tokenId uint256 ID of the token to be transferred
1114      * @param _data bytes optional data to send along with the call
1115      * @return bool whether the call correctly returned the expected magic value
1116      */
1117     function _checkOnERC721Received(
1118         address from,
1119         address to,
1120         uint256 tokenId,
1121         bytes memory _data
1122     ) private returns (bool) {
1123         if (to.isContract()) {
1124             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1125                 return retval == IERC721Receiver(to).onERC721Received.selector;
1126             } catch (bytes memory reason) {
1127                 if (reason.length == 0) {
1128                     revert("ERC721: transfer to non ERC721Receiver implementer");
1129                 } else {
1130                     assembly {
1131                         revert(add(32, reason), mload(reason))
1132                     }
1133                 }
1134             }
1135         } else {
1136             return true;
1137         }
1138     }
1139 
1140     /**
1141      * @dev Hook that is called before any token transfer. This includes minting
1142      * and burning.
1143      *
1144      * Calling conditions:
1145      *
1146      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1147      * transferred to `to`.
1148      * - When `from` is zero, `tokenId` will be minted for `to`.
1149      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1150      * - `from` and `to` are never both zero.
1151      *
1152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1153      */
1154     function _beforeTokenTransfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) internal virtual {}
1159 }
1160 
1161 pragma solidity ^0.8.0;
1162 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1163     // Mapping from owner to list of owned token IDs
1164     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1165 
1166     // Mapping from token ID to index of the owner tokens list
1167     mapping(uint256 => uint256) private _ownedTokensIndex;
1168 
1169     // Array with all token ids, used for enumeration
1170     uint256[] private _allTokens;
1171 
1172     // Mapping from token id to position in the allTokens array
1173     mapping(uint256 => uint256) private _allTokensIndex;
1174 
1175     /**
1176      * @dev See {IERC165-supportsInterface}.
1177      */
1178     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1179         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1180     }
1181 
1182     /**
1183      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1184      */
1185     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1186         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1187         return _ownedTokens[owner][index];
1188     }
1189 
1190     /**
1191      * @dev See {IERC721Enumerable-totalSupply}.
1192      */
1193     function totalSupply() public view virtual override returns (uint256) {
1194         return _allTokens.length;
1195     }
1196 
1197     /**
1198      * @dev See {IERC721Enumerable-tokenByIndex}.
1199      */
1200     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1201         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1202         return _allTokens[index];
1203     }
1204 
1205     /**
1206      * @dev Hook that is called before any token transfer. This includes minting
1207      * and burning.
1208      *
1209      * Calling conditions:
1210      *
1211      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1212      * transferred to `to`.
1213      * - When `from` is zero, `tokenId` will be minted for `to`.
1214      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1215      * - `from` cannot be the zero address.
1216      * - `to` cannot be the zero address.
1217      *
1218      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1219      */
1220     function _beforeTokenTransfer(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) internal virtual override {
1225         super._beforeTokenTransfer(from, to, tokenId);
1226 
1227         if (from == address(0)) {
1228             _addTokenToAllTokensEnumeration(tokenId);
1229         } else if (from != to) {
1230             _removeTokenFromOwnerEnumeration(from, tokenId);
1231         }
1232         if (to == address(0)) {
1233             _removeTokenFromAllTokensEnumeration(tokenId);
1234         } else if (to != from) {
1235             _addTokenToOwnerEnumeration(to, tokenId);
1236         }
1237     }
1238 
1239     /**
1240      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1241      * @param to address representing the new owner of the given token ID
1242      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1243      */
1244     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1245         uint256 length = ERC721.balanceOf(to);
1246         _ownedTokens[to][length] = tokenId;
1247         _ownedTokensIndex[tokenId] = length;
1248     }
1249 
1250     /**
1251      * @dev Private function to add a token to this extension's token tracking data structures.
1252      * @param tokenId uint256 ID of the token to be added to the tokens list
1253      */
1254     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1255         _allTokensIndex[tokenId] = _allTokens.length;
1256         _allTokens.push(tokenId);
1257     }
1258 
1259     /**
1260      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1261      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1262      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1263      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1264      * @param from address representing the previous owner of the given token ID
1265      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1266      */
1267     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1268         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1269         // then delete the last slot (swap and pop).
1270 
1271         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1272         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1273 
1274         // When the token to delete is the last token, the swap operation is unnecessary
1275         if (tokenIndex != lastTokenIndex) {
1276             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1277 
1278             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1279             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1280         }
1281 
1282         // This also deletes the contents at the last position of the array
1283         delete _ownedTokensIndex[tokenId];
1284         delete _ownedTokens[from][lastTokenIndex];
1285     }
1286 
1287     /**
1288      * @dev Private function to remove a token from this extension's token tracking data structures.
1289      * This has O(1) time complexity, but alters the order of the _allTokens array.
1290      * @param tokenId uint256 ID of the token to be removed from the tokens list
1291      */
1292     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1293         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1294         // then delete the last slot (swap and pop).
1295 
1296         uint256 lastTokenIndex = _allTokens.length - 1;
1297         uint256 tokenIndex = _allTokensIndex[tokenId];
1298 
1299         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1300         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1301         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1302         uint256 lastTokenId = _allTokens[lastTokenIndex];
1303 
1304         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1305         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1306 
1307         // This also deletes the contents at the last position of the array
1308         delete _allTokensIndex[tokenId];
1309         _allTokens.pop();
1310     }
1311 }
1312 
1313 pragma solidity ^0.8.0;
1314 library MerkleProof {
1315     /**
1316      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1317      * defined by `root`. For this, a `proof` must be provided, containing
1318      * sibling hashes on the branch from the leaf to the root of the tree. Each
1319      * pair of leaves and each pair of pre-images are assumed to be sorted.
1320      */
1321     function verify(
1322         bytes32[] memory proof,
1323         bytes32 root,
1324         bytes32 leaf
1325     ) internal pure returns (bool) {
1326         return processProof(proof, leaf) == root;
1327     }
1328 
1329     /**
1330      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1331      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1332      * hash matches the root of the tree. When processing the proof, the pairs
1333      * of leafs & pre-images are assumed to be sorted.
1334      *
1335      * _Available since v4.4._
1336      */
1337     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1338         bytes32 computedHash = leaf;
1339         for (uint256 i = 0; i < proof.length; i++) {
1340             bytes32 proofElement = proof[i];
1341             if (computedHash <= proofElement) {
1342                 // Hash(current computed hash + current element of the proof)
1343                 computedHash = _efficientHash(computedHash, proofElement);
1344             } else {
1345                 // Hash(current element of the proof + current computed hash)
1346                 computedHash = _efficientHash(proofElement, computedHash);
1347             }
1348         }
1349         return computedHash;
1350     }
1351 
1352     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1353         assembly {
1354             mstore(0x00, a)
1355             mstore(0x20, b)
1356             value := keccak256(0x00, 0x40)
1357         }
1358     }
1359 }
1360 
1361 
1362 pragma solidity ^0.8.0;
1363 contract  THLC  is ERC721Enumerable, Ownable {
1364     using SafeMath for uint256;
1365 
1366     struct userAddress {
1367         address userAddress;
1368         uint counter;
1369     }
1370 
1371     uint public constant _TOTALSUPPLY   = 7777;
1372     uint private tokenId                = 1;
1373     address freeFlowAddress             = 0x5B588e36FF358D4376A76FB163fd69Da02A2A9a5;
1374     address developerAddress            = 0x785178F8b4a67f05813d11B1A5322c193156bA60;
1375     bool public isSalePaused            = true;
1376 
1377     uint256 public preSalePrice         = 0.05 ether;
1378     uint public preSaleSupply           = 600;
1379     uint public preSaleMaxQuantity      = 2;
1380     mapping(address => userAddress) public _preSaleAddresses;
1381     mapping(address => bool) public _preSaleAddressExist;
1382 
1383     uint256 public publicSaleprice      = 0.077 ether;
1384     uint public publicSaleSupply        = 7177;
1385     uint public publicSaleMaxQuantity   = 20;
1386 
1387     constructor(string memory baseURI) ERC721("Happy Lions Circle", "THLC")  {
1388         setBaseURI(baseURI);
1389     }
1390     
1391     function setBaseURI(string memory baseURI) public onlyOwner {
1392         _baseURI = baseURI;
1393     }
1394     
1395     function totalsupply() private view returns (uint) {
1396         return tokenId;
1397     }
1398 
1399     modifier isSaleOpen {
1400         require(totalSupply() < _TOTALSUPPLY, "Sale Ended");
1401         _;
1402     }
1403 
1404     // Set Price Functions For PreSale & Public
1405     function setPublicPrice(uint256 _newPrice) public onlyOwner() {
1406         publicSaleprice = _newPrice;
1407     }
1408     function setPreSaleOnePrice(uint256 _newPrice) public onlyOwner() {
1409         preSalePrice = _newPrice;
1410     }
1411 
1412     // Flip Status Functions For Sale
1413     function flipPauseStatus() public onlyOwner {
1414         isSalePaused = !isSalePaused;
1415     }
1416 
1417     // Set Max Quantity Functions For PreSale & Public
1418     function setPublicSaleMaxQuantity(uint256 _quantity) public onlyOwner {
1419         publicSaleMaxQuantity =_quantity;
1420     }
1421     function setPreSaleMaxQuantity(uint256 _quantity) public onlyOwner {
1422         preSaleMaxQuantity =_quantity;
1423     }
1424 
1425     // Set Price Functions For PreSale & Public
1426     function getPublicPrice(uint256 _quantity) public view returns (uint256) { 
1427         return _quantity * publicSaleprice;
1428     }
1429     function getPreSalePrice(uint256 _quantity) public view returns (uint256) { 
1430         return _quantity * preSalePrice;
1431     }
1432 
1433     // Mint Functions For PreSale & Public
1434     function mint(uint chosenAmount) public payable isSaleOpen {
1435         require(_TOTALSUPPLY >= chosenAmount, "Chosen amount is greater than supply");
1436         require(isSalePaused == false, "Sale is not active at the moment");
1437         require(totalSupply() + chosenAmount <= _TOTALSUPPLY, "Quantity must be lesser then MaxSupply");
1438         require(chosenAmount <= publicSaleMaxQuantity && chosenAmount > 0, "Chosen Amount Should be greater then 0 and less then max quantity");
1439         require(publicSaleprice.mul(chosenAmount) == msg.value, "Sent ether value is incorrect");
1440         for (uint i = 0; i < chosenAmount; i++) {
1441             _safeMint(msg.sender, totalsupply());
1442             tokenId++;
1443         }
1444     }
1445     function whiteListMint(bytes32[] calldata _merkleProof, bytes32 merkleRoot, uint chosenAmount) public payable isSaleOpen {
1446         if (_preSaleAddressExist[msg.sender] == false) {
1447             _preSaleAddresses[msg.sender] = userAddress({
1448                 userAddress: msg.sender,
1449                 counter: 0
1450             });
1451             _preSaleAddressExist[msg.sender] = true;
1452         }
1453         require(_TOTALSUPPLY >= chosenAmount, "Chosen amount is greater than supply");
1454         require(chosenAmount > 0, "Number Of Tokens Can Not Be Less Than Or Equal To 0");
1455         require(isSalePaused == false, "Sale is not active at the moment");
1456         require(chosenAmount <= publicSaleMaxQuantity && chosenAmount > 0, "Chosen Amount Should be greater then 0 and less then max quantity");
1457         require(_preSaleAddresses[msg.sender].counter + chosenAmount <= preSaleMaxQuantity, "Quantity Must Be Lesser Than Max Supply");
1458         require(preSalePrice.mul(chosenAmount) == msg.value, "Sent Ether Value Is Incorrect");
1459         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1460         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid Proof");
1461         for (uint i = 0; i < chosenAmount; i++) {
1462             _safeMint(msg.sender, totalsupply());
1463             tokenId++;
1464         }
1465         _preSaleAddresses[msg.sender].counter += chosenAmount;
1466     }
1467 
1468 
1469     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
1470         uint256 count = balanceOf(_owner);
1471         uint256[] memory result = new uint256[](count);
1472         for (uint256 index = 0; index < count; index++) {
1473             result[index] = tokenOfOwnerByIndex(_owner, index);
1474         }
1475         return result;
1476     }
1477 
1478     function withdraw() public onlyOwner {
1479         uint totalBalance       = address(this).balance;
1480         uint ownerBalance       = totalBalance * 98 / 100;
1481         uint remainingBalance   = totalBalance * 2 / 100;
1482         uint developerBalance   = remainingBalance * 85 / 100;
1483         uint freeFLowBalance    = remainingBalance * 15 / 100;
1484         
1485         payable(msg.sender).transfer(ownerBalance);
1486         payable(developerAddress).transfer(developerBalance);
1487         payable(freeFlowAddress).transfer(freeFLowBalance);
1488     }
1489 }