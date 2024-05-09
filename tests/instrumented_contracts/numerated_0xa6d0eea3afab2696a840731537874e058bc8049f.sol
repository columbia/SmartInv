1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 // import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
5 // import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor () {
27         address msgSender = _msgSender();
28         _owner = msgSender;
29         emit OwnershipTransferred(address(0), msgSender);
30     }
31 
32     /**
33      * @dev Returns the address of the current owner.
34      */
35     function owner() public view returns (address) {
36         return _owner;
37     }
38 
39     /**
40      * @dev Throws if called by any account other than the owner.
41      */
42     modifier onlyOwner() {
43         require(_owner == _msgSender(), "Ownable: caller is not the owner");
44         _;
45     }
46 
47     /**
48      * @dev Leaves the contract without owner. It will not be possible to call
49      * `onlyOwner` functions anymore. Can only be called by the current owner.
50      *
51      * NOTE: Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public virtual onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68 }
69 
70 library SafeMath {
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
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the subtraction of two unsigned integers, reverting on
90      * overflow (when the result is negative).
91      *
92      * Counterpart to Solidity's `-` operator.
93      *
94      * Requirements:
95      *
96      * - Subtraction cannot overflow.
97      */
98     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99         return sub(a, b, "SafeMath: subtraction overflow");
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         require(b <= a, errorMessage);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `*` operator.
124      *
125      * Requirements:
126      *
127      * - Multiplication cannot overflow.
128      */
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131         // benefit is lost if 'b' is also tested.
132         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
133         if (a == 0) {
134             return 0;
135         }
136 
137         uint256 c = a * b;
138         require(c / a == b, "SafeMath: multiplication overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers. Reverts on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         return div(a, b, "SafeMath: division by zero");
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b > 0, errorMessage);
173         uint256 c = a / b;
174         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192         return mod(a, b, "SafeMath: modulo by zero");
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * Reverts with custom message when dividing by zero.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b != 0, errorMessage);
209         return a % b;
210     }
211 }
212 
213 interface IERC165 {
214     /**
215      * @dev Returns true if this contract implements the interface defined by
216      * `interfaceId`. See the corresponding
217      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
218      * to learn more about how these ids are created.
219      *
220      * This function call must use less than 30 000 gas.
221      */
222     function supportsInterface(bytes4 interfaceId) external view returns (bool);
223 }
224 
225 abstract contract ERC165 is IERC165 {
226     /**
227      * @dev See {IERC165-supportsInterface}.
228      */
229     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
230         return interfaceId == type(IERC165).interfaceId;
231     }
232 }
233 
234 interface IERC721 is IERC165 {
235     /**
236      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
237      */
238     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
239 
240     /**
241      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
242      */
243     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
244 
245     /**
246      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
247      */
248     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
249 
250     /**
251      * @dev Returns the number of tokens in ``owner``'s account.
252      */
253     function balanceOf(address owner) external view returns (uint256 balance);
254 
255     /**
256      * @dev Returns the owner of the `tokenId` token.
257      *
258      * Requirements:
259      *
260      * - `tokenId` must exist.
261      */
262     function ownerOf(uint256 tokenId) external view returns (address owner);
263 
264     /**
265      * @dev Safely transfers `tokenId` token from `from` to `to`.
266      *
267      * Requirements:
268      *
269      * - `from` cannot be the zero address.
270      * - `to` cannot be the zero address.
271      * - `tokenId` token must exist and be owned by `from`.
272      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
273      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
274      *
275      * Emits a {Transfer} event.
276      */
277     function safeTransferFrom(
278         address from,
279         address to,
280         uint256 tokenId,
281         bytes calldata data
282     ) external;
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
340      * @dev Approve or remove `operator` as an operator for the caller.
341      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
342      *
343      * Requirements:
344      *
345      * - The `operator` cannot be the caller.
346      *
347      * Emits an {ApprovalForAll} event.
348      */
349     function setApprovalForAll(address operator, bool _approved) external;
350 
351     /**
352      * @dev Returns the account approved for `tokenId` token.
353      *
354      * Requirements:
355      *
356      * - `tokenId` must exist.
357      */
358     function getApproved(uint256 tokenId) external view returns (address operator);
359 
360     /**
361      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
362      *
363      * See {setApprovalForAll}
364      */
365     function isApprovedForAll(address owner, address operator) external view returns (bool);
366 }
367 
368 interface IERC721Metadata is IERC721 {
369     /**
370      * @dev Returns the token collection name.
371      */
372     function name() external view returns (string memory);
373 
374     /**
375      * @dev Returns the token collection symbol.
376      */
377     function symbol() external view returns (string memory);
378 
379     /**
380      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
381      */
382     function tokenURI(uint256 tokenId) external view returns (string memory);
383 }
384 
385 library Address {
386     /**
387      * @dev Returns true if `account` is a contract.
388      *
389      * [IMPORTANT]
390      * ====
391      * It is unsafe to assume that an address for which this function returns
392      * false is an externally-owned account (EOA) and not a contract.
393      *
394      * Among others, `isContract` will return false for the following
395      * types of addresses:
396      *
397      *  - an externally-owned account
398      *  - a contract in construction
399      *  - an address where a contract will be created
400      *  - an address where a contract lived, but was destroyed
401      * ====
402      *
403      * [IMPORTANT]
404      * ====
405      * You shouldn't rely on `isContract` to protect against flash loan attacks!
406      *
407      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
408      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
409      * constructor.
410      * ====
411      */
412     function isContract(address account) internal view returns (bool) {
413         // This method relies on extcodesize/address.code.length, which returns 0
414         // for contracts in construction, since the code is only stored at the end
415         // of the constructor execution.
416 
417         return account.code.length > 0;
418     }
419 
420     /**
421      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
422      * `recipient`, forwarding all available gas and reverting on errors.
423      *
424      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
425      * of certain opcodes, possibly making contracts go over the 2300 gas limit
426      * imposed by `transfer`, making them unable to receive funds via
427      * `transfer`. {sendValue} removes this limitation.
428      *
429      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
430      *
431      * IMPORTANT: because control is transferred to `recipient`, care must be
432      * taken to not create reentrancy vulnerabilities. Consider using
433      * {ReentrancyGuard} or the
434      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
435      */
436     function sendValue(address payable recipient, uint256 amount) internal {
437         require(address(this).balance >= amount, "Address: insufficient balance");
438 
439         (bool success, ) = recipient.call{value: amount}("");
440         require(success, "Address: unable to send value, recipient may have reverted");
441     }
442 
443     /**
444      * @dev Performs a Solidity function call using a low level `call`. A
445      * plain `call` is an unsafe replacement for a function call: use this
446      * function instead.
447      *
448      * If `target` reverts with a revert reason, it is bubbled up by this
449      * function (like regular Solidity function calls).
450      *
451      * Returns the raw returned data. To convert to the expected return value,
452      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
453      *
454      * Requirements:
455      *
456      * - `target` must be a contract.
457      * - calling `target` with `data` must not revert.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionCall(target, data, "Address: low-level call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
467      * `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         return functionCallWithValue(target, data, 0, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but also transferring `value` wei to `target`.
482      *
483      * Requirements:
484      *
485      * - the calling contract must have an ETH balance of at least `value`.
486      * - the called Solidity function must be `payable`.
487      *
488      * _Available since v3.1._
489      */
490     function functionCallWithValue(
491         address target,
492         bytes memory data,
493         uint256 value
494     ) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
500      * with `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         require(address(this).balance >= value, "Address: insufficient balance for call");
511         require(isContract(target), "Address: call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.call{value: value}(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
524         return functionStaticCall(target, data, "Address: low-level static call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal view returns (bytes memory) {
538         require(isContract(target), "Address: static call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.staticcall(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but performing a delegate call.
547      *
548      * _Available since v3.4._
549      */
550     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
551         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(isContract(target), "Address: delegate call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.delegatecall(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
573      * revert reason using the provided one.
574      *
575      * _Available since v4.3._
576      */
577     function verifyCallResult(
578         bool success,
579         bytes memory returndata,
580         string memory errorMessage
581     ) internal pure returns (bytes memory) {
582         if (success) {
583             return returndata;
584         } else {
585             // Look for revert reason and bubble it up if present
586             if (returndata.length > 0) {
587                 // The easiest way to bubble the revert reason is using memory via assembly
588 
589                 assembly {
590                     let returndata_size := mload(returndata)
591                     revert(add(32, returndata), returndata_size)
592                 }
593             } else {
594                 revert(errorMessage);
595             }
596         }
597     }
598 }
599 
600 library Strings {
601     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
602 
603     /**
604      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
605      */
606     function toString(uint256 value) internal pure returns (string memory) {
607         // Inspired by OraclizeAPI's implementation - MIT licence
608         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
609 
610         if (value == 0) {
611             return "0";
612         }
613         uint256 temp = value;
614         uint256 digits;
615         while (temp != 0) {
616             digits++;
617             temp /= 10;
618         }
619         bytes memory buffer = new bytes(digits);
620         while (value != 0) {
621             digits -= 1;
622             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
623             value /= 10;
624         }
625         return string(buffer);
626     }
627 
628     /**
629      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
630      */
631     function toHexString(uint256 value) internal pure returns (string memory) {
632         if (value == 0) {
633             return "0x00";
634         }
635         uint256 temp = value;
636         uint256 length = 0;
637         while (temp != 0) {
638             length++;
639             temp >>= 8;
640         }
641         return toHexString(value, length);
642     }
643 
644     /**
645      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
646      */
647     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
648         bytes memory buffer = new bytes(2 * length + 2);
649         buffer[0] = "0";
650         buffer[1] = "x";
651         for (uint256 i = 2 * length + 1; i > 1; --i) {
652             buffer[i] = _HEX_SYMBOLS[value & 0xf];
653             value >>= 4;
654         }
655         require(value == 0, "Strings: hex length insufficient");
656         return string(buffer);
657     }
658 }
659 
660 interface IERC721Receiver {
661     /**
662      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
663      * by `operator` from `from`, this function is called.
664      *
665      * It must return its Solidity selector to confirm the token transfer.
666      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
667      *
668      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
669      */
670     function onERC721Received(
671         address operator,
672         address from,
673         uint256 tokenId,
674         bytes calldata data
675     ) external returns (bytes4);
676 }
677 
678 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
679     using Address for address;
680     using Strings for uint256;
681 
682     // Token name
683     string private _name;
684 
685     // Token symbol
686     string private _symbol;
687 
688     // Mapping from token ID to owner address
689     mapping(uint256 => address) private _owners;
690 
691     // Mapping owner address to token count
692     mapping(address => uint256) private _balances;
693 
694     // Mapping from token ID to approved address
695     mapping(uint256 => address) private _tokenApprovals;
696 
697     // Mapping from owner to operator approvals
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699 
700     /**
701      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
702      */
703     constructor(string memory name_, string memory symbol_) {
704         _name = name_;
705         _symbol = symbol_;
706     }
707 
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
712         return
713             interfaceId == type(IERC721).interfaceId ||
714             interfaceId == type(IERC721Metadata).interfaceId ||
715             super.supportsInterface(interfaceId);
716     }
717 
718     /**
719      * @dev See {IERC721-balanceOf}.
720      */
721     function balanceOf(address owner) public view virtual override returns (uint256) {
722         require(owner != address(0), "ERC721: balance query for the zero address");
723         return _balances[owner];
724     }
725 
726     /**
727      * @dev See {IERC721-ownerOf}.
728      */
729     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
730         address owner = _owners[tokenId];
731         require(owner != address(0), "ERC721: owner query for nonexistent token");
732         return owner;
733     }
734 
735     /**
736      * @dev See {IERC721Metadata-name}.
737      */
738     function name() public view virtual override returns (string memory) {
739         return _name;
740     }
741 
742     /**
743      * @dev See {IERC721Metadata-symbol}.
744      */
745     function symbol() public view virtual override returns (string memory) {
746         return _symbol;
747     }
748 
749     /**
750      * @dev See {IERC721Metadata-tokenURI}.
751      */
752     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
753         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
754 
755         string memory baseURI = _baseURI();
756         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
757     }
758 
759     /**
760      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
761      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
762      * by default, can be overridden in child contracts.
763      */
764     function _baseURI() internal view virtual returns (string memory) {
765         return "";
766     }
767 
768     /**
769      * @dev See {IERC721-approve}.
770      */
771     function approve(address to, uint256 tokenId) public virtual override {
772         address owner = ERC721.ownerOf(tokenId);
773         require(to != owner, "ERC721: approval to current owner");
774 
775         require(
776             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
777             "ERC721: approve caller is not owner nor approved for all"
778         );
779 
780         _approve(to, tokenId);
781     }
782 
783     /**
784      * @dev See {IERC721-getApproved}.
785      */
786     function getApproved(uint256 tokenId) public view virtual override returns (address) {
787         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
788 
789         return _tokenApprovals[tokenId];
790     }
791 
792     /**
793      * @dev See {IERC721-setApprovalForAll}.
794      */
795     function setApprovalForAll(address operator, bool approved) public virtual override {
796         _setApprovalForAll(_msgSender(), operator, approved);
797     }
798 
799     /**
800      * @dev See {IERC721-isApprovedForAll}.
801      */
802     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
803         return _operatorApprovals[owner][operator];
804     }
805 
806     /**
807      * @dev See {IERC721-transferFrom}.
808      */
809     function transferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) public virtual override {
814         //solhint-disable-next-line max-line-length
815         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
816 
817         _transfer(from, to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-safeTransferFrom}.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) public virtual override {
828         safeTransferFrom(from, to, tokenId, "");
829     }
830 
831     /**
832      * @dev See {IERC721-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) public virtual override {
840         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
841         _safeTransfer(from, to, tokenId, _data);
842     }
843 
844     /**
845      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
846      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
847      *
848      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
849      *
850      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
851      * implement alternative mechanisms to perform token transfer, such as signature-based.
852      *
853      * Requirements:
854      *
855      * - `from` cannot be the zero address.
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must exist and be owned by `from`.
858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _safeTransfer(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) internal virtual {
868         _transfer(from, to, tokenId);
869         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
870     }
871 
872     /**
873      * @dev Returns whether `tokenId` exists.
874      *
875      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
876      *
877      * Tokens start existing when they are minted (`_mint`),
878      * and stop existing when they are burned (`_burn`).
879      */
880     function _exists(uint256 tokenId) internal view virtual returns (bool) {
881         return _owners[tokenId] != address(0);
882     }
883 
884     /**
885      * @dev Returns whether `spender` is allowed to manage `tokenId`.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
892         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
893         address owner = ERC721.ownerOf(tokenId);
894         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
895     }
896 
897     /**
898      * @dev Safely mints `tokenId` and transfers it to `to`.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must not exist.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _safeMint(address to, uint256 tokenId) internal virtual {
908         _safeMint(to, tokenId, "");
909     }
910 
911     /**
912      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
913      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
914      */
915     function _safeMint(
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) internal virtual {
920         _mint(to, tokenId);
921         require(
922             _checkOnERC721Received(address(0), to, tokenId, _data),
923             "ERC721: transfer to non ERC721Receiver implementer"
924         );
925     }
926 
927     /**
928      * @dev Mints `tokenId` and transfers it to `to`.
929      *
930      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
931      *
932      * Requirements:
933      *
934      * - `tokenId` must not exist.
935      * - `to` cannot be the zero address.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _mint(address to, uint256 tokenId) internal virtual {
940         require(to != address(0), "ERC721: mint to the zero address");
941         require(!_exists(tokenId), "ERC721: token already minted");
942 
943         _beforeTokenTransfer(address(0), to, tokenId);
944 
945         _balances[to] += 1;
946         _owners[tokenId] = to;
947 
948         emit Transfer(address(0), to, tokenId);
949 
950         _afterTokenTransfer(address(0), to, tokenId);
951     }
952 
953     /**
954      * @dev Destroys `tokenId`.
955      * The approval is cleared when the token is burned.
956      *
957      * Requirements:
958      *
959      * - `tokenId` must exist.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _burn(uint256 tokenId) internal virtual {
964         address owner = ERC721.ownerOf(tokenId);
965 
966         _beforeTokenTransfer(owner, address(0), tokenId);
967 
968         // Clear approvals
969         _approve(address(0), tokenId);
970 
971         _balances[owner] -= 1;
972         delete _owners[tokenId];
973 
974         emit Transfer(owner, address(0), tokenId);
975 
976         _afterTokenTransfer(owner, address(0), tokenId);
977     }
978 
979     /**
980      * @dev Transfers `tokenId` from `from` to `to`.
981      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must be owned by `from`.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _transfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) internal virtual {
995         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
996         require(to != address(0), "ERC721: transfer to the zero address");
997 
998         _beforeTokenTransfer(from, to, tokenId);
999 
1000         // Clear approvals from the previous owner
1001         _approve(address(0), tokenId);
1002 
1003         _balances[from] -= 1;
1004         _balances[to] += 1;
1005         _owners[tokenId] = to;
1006 
1007         emit Transfer(from, to, tokenId);
1008 
1009         _afterTokenTransfer(from, to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Approve `to` to operate on `tokenId`
1014      *
1015      * Emits a {Approval} event.
1016      */
1017     function _approve(address to, uint256 tokenId) internal virtual {
1018         _tokenApprovals[tokenId] = to;
1019         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Approve `operator` to operate on all of `owner` tokens
1024      *
1025      * Emits a {ApprovalForAll} event.
1026      */
1027     function _setApprovalForAll(
1028         address owner,
1029         address operator,
1030         bool approved
1031     ) internal virtual {
1032         require(owner != operator, "ERC721: approve to caller");
1033         _operatorApprovals[owner][operator] = approved;
1034         emit ApprovalForAll(owner, operator, approved);
1035     }
1036 
1037     /**
1038      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1039      * The call is not executed if the target address is not a contract.
1040      *
1041      * @param from address representing the previous owner of the given token ID
1042      * @param to target address that will receive the tokens
1043      * @param tokenId uint256 ID of the token to be transferred
1044      * @param _data bytes optional data to send along with the call
1045      * @return bool whether the call correctly returned the expected magic value
1046      */
1047     function _checkOnERC721Received(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) private returns (bool) {
1053         if (to.isContract()) {
1054             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1055                 return retval == IERC721Receiver.onERC721Received.selector;
1056             } catch (bytes memory reason) {
1057                 if (reason.length == 0) {
1058                     revert("ERC721: transfer to non ERC721Receiver implementer");
1059                 } else {
1060                     assembly {
1061                         revert(add(32, reason), mload(reason))
1062                     }
1063                 }
1064             }
1065         } else {
1066             return true;
1067         }
1068     }
1069 
1070     /**
1071      * @dev Hook that is called before any token transfer. This includes minting
1072      * and burning.
1073      *
1074      * Calling conditions:
1075      *
1076      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1077      * transferred to `to`.
1078      * - When `from` is zero, `tokenId` will be minted for `to`.
1079      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1080      * - `from` and `to` are never both zero.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _beforeTokenTransfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) internal virtual {}
1089 
1090     /**
1091      * @dev Hook that is called after any transfer of tokens. This includes
1092      * minting and burning.
1093      *
1094      * Calling conditions:
1095      *
1096      * - when `from` and `to` are both non-zero.
1097      * - `from` and `to` are never both zero.
1098      *
1099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1100      */
1101     function _afterTokenTransfer(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) internal virtual {}
1106 }
1107 
1108 interface IERC721Enumerable is IERC721 {
1109     /**
1110      * @dev Returns the total amount of tokens stored by the contract.
1111      */
1112     function totalSupply() external view returns (uint256);
1113 
1114     /**
1115      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1116      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1117      */
1118     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1119 
1120     /**
1121      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1122      * Use along with {totalSupply} to enumerate all tokens.
1123      */
1124     function tokenByIndex(uint256 index) external view returns (uint256);
1125 }
1126 
1127 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1128     // Mapping from owner to list of owned token IDs
1129     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1130 
1131     // Mapping from token ID to index of the owner tokens list
1132     mapping(uint256 => uint256) private _ownedTokensIndex;
1133 
1134     // Array with all token ids, used for enumeration
1135     uint256[] private _allTokens;
1136 
1137     // Mapping from token id to position in the allTokens array
1138     mapping(uint256 => uint256) private _allTokensIndex;
1139 
1140     /**
1141      * @dev See {IERC165-supportsInterface}.
1142      */
1143     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1144         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1149      */
1150     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1151         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1152         return _ownedTokens[owner][index];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721Enumerable-totalSupply}.
1157      */
1158     function totalSupply() public view virtual override returns (uint256) {
1159         return _allTokens.length;
1160     }
1161 
1162     /**
1163      * @dev See {IERC721Enumerable-tokenByIndex}.
1164      */
1165     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1166         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1167         return _allTokens[index];
1168     }
1169 
1170     /**
1171      * @dev Hook that is called before any token transfer. This includes minting
1172      * and burning.
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` will be minted for `to`.
1179      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1180      * - `from` cannot be the zero address.
1181      * - `to` cannot be the zero address.
1182      *
1183      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1184      */
1185     function _beforeTokenTransfer(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) internal virtual override {
1190         super._beforeTokenTransfer(from, to, tokenId);
1191 
1192         if (from == address(0)) {
1193             _addTokenToAllTokensEnumeration(tokenId);
1194         } else if (from != to) {
1195             _removeTokenFromOwnerEnumeration(from, tokenId);
1196         }
1197         if (to == address(0)) {
1198             _removeTokenFromAllTokensEnumeration(tokenId);
1199         } else if (to != from) {
1200             _addTokenToOwnerEnumeration(to, tokenId);
1201         }
1202     }
1203 
1204     /**
1205      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1206      * @param to address representing the new owner of the given token ID
1207      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1208      */
1209     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1210         uint256 length = ERC721.balanceOf(to);
1211         _ownedTokens[to][length] = tokenId;
1212         _ownedTokensIndex[tokenId] = length;
1213     }
1214 
1215     /**
1216      * @dev Private function to add a token to this extension's token tracking data structures.
1217      * @param tokenId uint256 ID of the token to be added to the tokens list
1218      */
1219     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1220         _allTokensIndex[tokenId] = _allTokens.length;
1221         _allTokens.push(tokenId);
1222     }
1223 
1224     /**
1225      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1226      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1227      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1228      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1229      * @param from address representing the previous owner of the given token ID
1230      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1231      */
1232     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1233         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1234         // then delete the last slot (swap and pop).
1235 
1236         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1237         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1238 
1239         // When the token to delete is the last token, the swap operation is unnecessary
1240         if (tokenIndex != lastTokenIndex) {
1241             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1242 
1243             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1244             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1245         }
1246 
1247         // This also deletes the contents at the last position of the array
1248         delete _ownedTokensIndex[tokenId];
1249         delete _ownedTokens[from][lastTokenIndex];
1250     }
1251 
1252     /**
1253      * @dev Private function to remove a token from this extension's token tracking data structures.
1254      * This has O(1) time complexity, but alters the order of the _allTokens array.
1255      * @param tokenId uint256 ID of the token to be removed from the tokens list
1256      */
1257     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1258         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1259         // then delete the last slot (swap and pop).
1260 
1261         uint256 lastTokenIndex = _allTokens.length - 1;
1262         uint256 tokenIndex = _allTokensIndex[tokenId];
1263 
1264         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1265         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1266         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1267         uint256 lastTokenId = _allTokens[lastTokenIndex];
1268 
1269         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1270         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1271 
1272         // This also deletes the contents at the last position of the array
1273         delete _allTokensIndex[tokenId];
1274         _allTokens.pop();
1275     }
1276 }
1277 
1278 
1279 abstract contract ERC721URIStorage is ERC721Enumerable {
1280     using Strings for uint256;
1281 
1282     // Optional mapping for token URIs
1283     mapping(uint256 => string) private _tokenURIs;
1284 
1285     /**
1286      * @dev See {IERC721Metadata-tokenURI}.
1287      */
1288     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1289         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1290 
1291         string memory _tokenURI = _tokenURIs[tokenId];
1292         string memory base = _baseURI();
1293 
1294         // If there is no base URI, return the token URI.
1295         if (bytes(base).length == 0) {
1296             return _tokenURI;
1297         }
1298         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1299         if (bytes(_tokenURI).length > 0) {
1300             return string(abi.encodePacked(base, _tokenURI));
1301         }
1302 
1303         return super.tokenURI(tokenId);
1304     }
1305 
1306     /**
1307      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1308      *
1309      * Requirements:
1310      *
1311      * - `tokenId` must exist.
1312      */
1313     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1314         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1315         _tokenURIs[tokenId] = _tokenURI;
1316     }
1317 
1318     /**
1319      * @dev Destroys `tokenId`.
1320      * The approval is cleared when the token is burned.
1321      *
1322      * Requirements:
1323      *
1324      * - `tokenId` must exist.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function _burn(uint256 tokenId) internal virtual override {
1329         super._burn(tokenId);
1330 
1331         if (bytes(_tokenURIs[tokenId]).length != 0) {
1332             delete _tokenURIs[tokenId];
1333         }
1334     }
1335 }
1336 
1337 
1338 contract ScalesNFT is ERC721URIStorage, Ownable {
1339 
1340     using SafeMath for uint256;
1341     using Strings for uint256;
1342     address royaltyReceiver;
1343     uint256 royaltyFeesInBips;
1344 
1345     string private _tokenBaseURI;
1346 
1347     uint256 public max_mint_amount = 2;
1348     uint256 public newAddedAmount;
1349     uint256 public totalDroppedAmount;
1350     uint256 public totalMintedAmount = 0;
1351     
1352     mapping ( address => uint256 ) public whitelisted;
1353     mapping ( address => uint256 ) public mintedAmount;
1354 
1355     event ownerRegisterOneUserToWhitelist ( address user );
1356     event ownerRemoveOneUserFromWhitelist ( address user );
1357     event ownerRegisterSomeUsersToWhitelist ( address[] users );
1358     event ownerRemoveSomeUsersFromWhitelist ( address[] users );
1359     event userMintOneNFT( address user, uint256 tokenId);
1360     event userMintSomeNFTs ( address to, uint256[] tokenIds);
1361     event ownerSetNewAddedAmount ( uint256 amount );
1362     event ownerSetBaseURI ( string baseURI );
1363 
1364     constructor(string memory name, string memory symbol, uint256 _royaltyFeesInBips)
1365         ERC721(name, symbol)
1366     {
1367         royaltyReceiver = msg.sender;
1368         royaltyFeesInBips = _royaltyFeesInBips;
1369     }
1370 
1371     /**
1372      *  @dev EIP-2981
1373      *
1374      * bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
1375      *
1376      * => 0x2a55205a = 0x2a55205a
1377      */
1378     bytes4 private constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x2a55205a;
1379 
1380     /**
1381      * @dev See {IERC165-supportsInterface}.
1382      */
1383     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1384         return interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981 || super.supportsInterface(interfaceId);
1385     }
1386 
1387      function royaltyInfo(
1388         uint256 _tokenId,
1389         uint256 _salePrice
1390     ) external view returns (
1391         address receiver,
1392         uint256 royaltyAmount
1393     ) {
1394         return (royaltyReceiver, calculateRoyalty(_salePrice));
1395     }
1396 
1397     function calculateRoyalty(uint256 _salePrice) view public returns(uint256) {
1398         return (_salePrice / 10000) * royaltyFeesInBips;
1399     }
1400 
1401     function setRoyaltyInfo (address _receiver, uint256 _royaltyFeesInBips) public onlyOwner {
1402         royaltyReceiver = _receiver;
1403         royaltyFeesInBips = _royaltyFeesInBips;
1404     }
1405 
1406 
1407     function mint () public {
1408         if ( msg.sender != owner() ) {
1409             require( whitelisted[msg.sender] == 1, "Mint : This user is not whitelisted");
1410             require( mintedAmount[msg.sender] + 1 <= max_mint_amount, "Mint : You already minted Maximum Mint Amount" );
1411         }
1412         require(totalMintedAmount + 1 <= totalDroppedAmount, "Mint : NFTs on this drop are already minted");
1413         uint256 _tokenId;
1414         _tokenId = totalMintedAmount + 1;
1415         _mint(msg.sender, _tokenId);
1416         _setTokenURI(_tokenId, tokenURI(_tokenId));                   // token URI need to be changed
1417         totalMintedAmount++;
1418         mintedAmount[msg.sender]++;
1419         emit userMintOneNFT(msg.sender, _tokenId);
1420     }
1421 
1422     function mintBatch ( address to, uint256 amount) public {          // need to be changed
1423         require ( to != address(0), "mintBatch : You can't mint NFTs to zero address" );
1424         require ( amount > 0, "mintBatch : You need to mint at least one NFT" );
1425         require ( totalMintedAmount + amount <= totalDroppedAmount, "mintBatch : There are no enough NFTs in this drop");
1426         if ( msg.sender != owner() )
1427         {
1428             require ( msg.sender == to, "mintBatch : Target address must be your address because you are not the owner");
1429             require ( whitelisted[to] == 1, "mintBatch ; Target user is not whitelisted");
1430             require ( mintedAmount[to] + amount <= max_mint_amount, "mintBatch : Target user can't take more than Mamimum Mint Amount" );
1431         }
1432         uint256[] memory tokenIds = new uint256[](amount);
1433         for ( uint256 i = 0; i < amount; i++ )
1434         {
1435             tokenIds[i] = totalMintedAmount + 1;
1436             _mint( to, tokenIds[i] );
1437             _setTokenURI(tokenIds[i], tokenURI(tokenIds[i]));                   // token URI need to be changed
1438             totalMintedAmount++;
1439         }
1440         if (msg.sender == to) {
1441             mintedAmount[to] += amount;
1442         }        
1443         emit userMintSomeNFTs(to, tokenIds);
1444     }
1445 
1446     function registerToWhitelist ( address user ) public onlyOwner {
1447         require( whitelisted[user] == 0, "Register To Whitelist : This user is already whitelisted" );
1448         whitelisted[user] = 1;
1449         emit ownerRegisterOneUserToWhitelist(user);
1450     }
1451 
1452     function removeFromWhitelist ( address user) public onlyOwner {
1453         require(whitelisted[user] == 1, "Remove From Whitelist : This user have never been whitelisted");
1454         whitelisted[user] = 0;
1455         emit ownerRemoveOneUserFromWhitelist(user);
1456     }
1457 
1458     function registerToWhitelistBatch ( address[] memory users ) public onlyOwner {
1459         for ( uint i = 0; i < users.length; i++ ) {
1460             require(whitelisted[users[i]] == 0, "Batch Register To Whitelist : Some user of this input is already whitelisted");
1461         }
1462         for ( uint i = 0; i < users.length; i++ ) {
1463             whitelisted[users[i]] = 1;
1464         }
1465         emit ownerRegisterSomeUsersToWhitelist( users );
1466     }
1467 
1468     function removeFromWhitelistBatch ( address[] memory users ) public onlyOwner {
1469         for ( uint i = 0; i < users.length; i++ ) {
1470             require(whitelisted[users[i]] == 1, "Batch Remove From Whitelist : Some user of input have never been whitelisted");
1471         }
1472         for ( uint i = 0; i < users.length; i++ ) {
1473             whitelisted[users[i]] = 0;
1474         }
1475         emit ownerRemoveSomeUsersFromWhitelist( users );
1476     }
1477 
1478     function setNewAddedAmount ( uint256 _newAddedAmount ) public onlyOwner {
1479         newAddedAmount = _newAddedAmount;
1480         totalDroppedAmount += newAddedAmount;
1481         emit ownerSetNewAddedAmount(_newAddedAmount);
1482     }
1483 
1484     function setBaseURI ( string memory tokenBaseURI ) public onlyOwner {
1485         _tokenBaseURI = tokenBaseURI;
1486         emit ownerSetBaseURI( tokenBaseURI );
1487     }
1488 
1489     function setTokenURI ( uint256 tokenId, string memory _tokenURI ) public onlyOwner {
1490         _setTokenURI(tokenId, _tokenURI);
1491     }
1492 
1493     function setTokenURIWithBaseURI ( uint256 tokenId ) public onlyOwner {
1494         _setTokenURI(tokenId, tokenURI(tokenId));
1495     }
1496 
1497     function tokenURI ( uint256 tokenId ) public view override returns ( string memory ) {
1498         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1499     }
1500 
1501     function getNewAddedAmount() public view returns (uint256) {
1502         return newAddedAmount;
1503     }
1504 
1505     function getTotalDroppedAmount () public view returns (uint256) {
1506         return totalDroppedAmount;
1507     }
1508 
1509     function getTotalMintedAmount() public view returns (uint256) {
1510         return totalMintedAmount;
1511     }
1512 
1513     function isWhitelisted(address user) public view returns (bool) {
1514         return whitelisted[user] == 1;
1515     }
1516     
1517     function getMintedAmount(address user) public view returns ( uint256) {
1518         return mintedAmount[user];
1519     }
1520 }