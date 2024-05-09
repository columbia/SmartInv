1 pragma solidity >=0.4.22 <0.9.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 interface IERC721 is IERC165 {
26     /**
27      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
28      */
29     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
30 
31     /**
32      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
33      */
34     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
38      */
39     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
40 
41     /**
42      * @dev Returns the number of tokens in ``owner``'s account.
43      */
44     function balanceOf(address owner) external view returns (uint256 balance);
45 
46     /**
47      * @dev Returns the owner of the `tokenId` token.
48      *
49      * Requirements:
50      *
51      * - `tokenId` must exist.
52      */
53     function ownerOf(uint256 tokenId) external view returns (address owner);
54 
55     /**
56      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
57      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
58      *
59      * Requirements:
60      *
61      * - `from` cannot be the zero address.
62      * - `to` cannot be the zero address.
63      * - `tokenId` token must exist and be owned by `from`.
64      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
65      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
66      *
67      * Emits a {Transfer} event.
68      */
69     function safeTransferFrom(
70         address from,
71         address to,
72         uint256 tokenId
73     ) external;
74 
75     /**
76      * @dev Transfers `tokenId` token from `from` to `to`.
77      *
78      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
79      *
80      * Requirements:
81      *
82      * - `from` cannot be the zero address.
83      * - `to` cannot be the zero address.
84      * - `tokenId` token must be owned by `from`.
85      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(
90         address from,
91         address to,
92         uint256 tokenId
93     ) external;
94 
95     /**
96      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
97      * The approval is cleared when the token is transferred.
98      *
99      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
100      *
101      * Requirements:
102      *
103      * - The caller must own the token or be an approved operator.
104      * - `tokenId` must exist.
105      *
106      * Emits an {Approval} event.
107      */
108     function approve(address to, uint256 tokenId) external;
109 
110     /**
111      * @dev Returns the account approved for `tokenId` token.
112      *
113      * Requirements:
114      *
115      * - `tokenId` must exist.
116      */
117     function getApproved(uint256 tokenId) external view returns (address operator);
118 
119     /**
120      * @dev Approve or remove `operator` as an operator for the caller.
121      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
122      *
123      * Requirements:
124      *
125      * - The `operator` cannot be the caller.
126      *
127      * Emits an {ApprovalForAll} event.
128      */
129     function setApprovalForAll(address operator, bool _approved) external;
130 
131     /**
132      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
133      *
134      * See {setApprovalForAll}
135      */
136     function isApprovedForAll(address owner, address operator) external view returns (bool);
137 
138     /**
139      * @dev Safely transfers `tokenId` token from `from` to `to`.
140      *
141      * Requirements:
142      *
143      * - `from` cannot be the zero address.
144      * - `to` cannot be the zero address.
145      * - `tokenId` token must exist and be owned by `from`.
146      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
148      *
149      * Emits a {Transfer} event.
150      */
151     function safeTransferFrom(
152         address from,
153         address to,
154         uint256 tokenId,
155         bytes calldata data
156     ) external;
157 }
158 
159 /**
160  * @title ERC721 token receiver interface
161  * @dev Interface for any contract that wants to support safeTransfers
162  * from ERC721 asset contracts.
163  */
164 interface IERC721Receiver {
165     /**
166      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
167      * by `operator` from `from`, this function is called.
168      *
169      * It must return its Solidity selector to confirm the token transfer.
170      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
171      *
172      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
173      */
174     function onERC721Received(
175         address operator,
176         address from,
177         uint256 tokenId,
178         bytes calldata data
179     ) external returns (bytes4);
180 }
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Metadata is IERC721 {
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 /**
204  * @dev Collection of functions related to the address type
205  */
206 library Address {
207     /**
208      * @dev Returns true if `account` is a contract.
209      *
210      * [IMPORTANT]
211      * ====
212      * It is unsafe to assume that an address for which this function returns
213      * false is an externally-owned account (EOA) and not a contract.
214      *
215      * Among others, `isContract` will return false for the following
216      * types of addresses:
217      *
218      *  - an externally-owned account
219      *  - a contract in construction
220      *  - an address where a contract will be created
221      *  - an address where a contract lived, but was destroyed
222      * ====
223      */
224     function isContract(address account) internal view returns (bool) {
225         // This method relies on extcodesize, which returns 0 for contracts in
226         // construction, since the code is only stored at the end of the
227         // constructor execution.
228 
229         uint256 size;
230         assembly {
231             size := extcodesize(account)
232         }
233         return size > 0;
234     }
235 
236     /**
237      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
238      * `recipient`, forwarding all available gas and reverting on errors.
239      *
240      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
241      * of certain opcodes, possibly making contracts go over the 2300 gas limit
242      * imposed by `transfer`, making them unable to receive funds via
243      * `transfer`. {sendValue} removes this limitation.
244      *
245      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
246      *
247      * IMPORTANT: because control is transferred to `recipient`, care must be
248      * taken to not create reentrancy vulnerabilities. Consider using
249      * {ReentrancyGuard} or the
250      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
251      */
252     function sendValue(address payable recipient, uint256 amount) internal {
253         require(address(this).balance >= amount, "Address: insufficient balance");
254 
255         (bool success, ) = recipient.call{value: amount}("");
256         require(success, "Address: unable to send value, recipient may have reverted");
257     }
258 
259     /**
260      * @dev Performs a Solidity function call using a low level `call`. A
261      * plain `call` is an unsafe replacement for a function call: use this
262      * function instead.
263      *
264      * If `target` reverts with a revert reason, it is bubbled up by this
265      * function (like regular Solidity function calls).
266      *
267      * Returns the raw returned data. To convert to the expected return value,
268      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
269      *
270      * Requirements:
271      *
272      * - `target` must be a contract.
273      * - calling `target` with `data` must not revert.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionCall(target, data, "Address: low-level call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
283      * `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, 0, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but also transferring `value` wei to `target`.
298      *
299      * Requirements:
300      *
301      * - the calling contract must have an ETH balance of at least `value`.
302      * - the called Solidity function must be `payable`.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
316      * with `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         require(isContract(target), "Address: call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.call{value: value}(data);
330         return _verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
340         return functionStaticCall(target, data, "Address: low-level static call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal view returns (bytes memory) {
354         require(isContract(target), "Address: static call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return _verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(isContract(target), "Address: delegate call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.delegatecall(data);
384         return _verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     function _verifyCallResult(
388         bool success,
389         bytes memory returndata,
390         string memory errorMessage
391     ) private pure returns (bytes memory) {
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 /*
411  * @dev Provides information about the current execution context, including the
412  * sender of the transaction and its data. While these are generally available
413  * via msg.sender and msg.data, they should not be accessed in such a direct
414  * manner, since when dealing with meta-transactions the account sending and
415  * paying for execution may not be the actual sender (as far as an application
416  * is concerned).
417  *
418  * This contract is only required for intermediate, library-like contracts.
419  */
420 abstract contract Context {
421     function _msgSender() internal view virtual returns (address) {
422         return msg.sender;
423     }
424 
425     function _msgData() internal view virtual returns (bytes calldata) {
426         return msg.data;
427     }
428 }
429 
430 /**
431  * @dev String operations.
432  */
433 library Strings {
434     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
435 
436     /**
437      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
438      */
439     function toString(uint256 value) internal pure returns (string memory) {
440         // Inspired by OraclizeAPI's implementation - MIT licence
441         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
442 
443         if (value == 0) {
444             return "0";
445         }
446         uint256 temp = value;
447         uint256 digits;
448         while (temp != 0) {
449             digits++;
450             temp /= 10;
451         }
452         bytes memory buffer = new bytes(digits);
453         while (value != 0) {
454             digits -= 1;
455             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
456             value /= 10;
457         }
458         return string(buffer);
459     }
460 
461     /**
462      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
463      */
464     function toHexString(uint256 value) internal pure returns (string memory) {
465         if (value == 0) {
466             return "0x00";
467         }
468         uint256 temp = value;
469         uint256 length = 0;
470         while (temp != 0) {
471             length++;
472             temp >>= 8;
473         }
474         return toHexString(value, length);
475     }
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
479      */
480     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
481         bytes memory buffer = new bytes(2 * length + 2);
482         buffer[0] = "0";
483         buffer[1] = "x";
484         for (uint256 i = 2 * length + 1; i > 1; --i) {
485             buffer[i] = _HEX_SYMBOLS[value & 0xf];
486             value >>= 4;
487         }
488         require(value == 0, "Strings: hex length insufficient");
489         return string(buffer);
490     }
491 }
492 
493 /**
494  * @title Counters
495  * @author Matt Condon (@shrugs)
496  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
497  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
498  *
499  * Include with `using Counters for Counters.Counter;`
500  */
501 library Counters {
502     struct Counter {
503         // This variable should never be directly accessed by users of the library: interactions must be restricted to
504         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
505         // this feature: see https://github.com/ethereum/solidity/issues/4637
506         uint256 _value; // default: 0
507     }
508 
509     function current(Counter storage counter) internal view returns (uint256) {
510         return counter._value;
511     }
512 
513     function increment(Counter storage counter) internal {
514         unchecked {
515             counter._value += 1;
516         }
517     }
518 
519     function decrement(Counter storage counter) internal {
520         uint256 value = counter._value;
521         require(value > 0, "Counter: decrement overflow");
522         unchecked {
523             counter._value = value - 1;
524         }
525     }
526 
527     function reset(Counter storage counter) internal {
528         counter._value = 0;
529     }
530 }
531 
532 /**
533  * @dev Implementation of the {IERC165} interface.
534  *
535  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
536  * for the additional interface id that will be supported. For example:
537  *
538  * ```solidity
539  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
541  * }
542  * ```
543  *
544  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
545  */
546 abstract contract ERC165 is IERC165 {
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         return interfaceId == type(IERC165).interfaceId;
552     }
553 }
554 
555 /**
556  * @dev Contract module which provides a basic access control mechanism, where
557  * there is an account (an owner) that can be granted exclusive access to
558  * specific functions.
559  *
560  * By default, the owner account will be the one that deploys the contract. This
561  * can later be changed with {transferOwnership}.
562  *
563  * This module is used through inheritance. It will make available the modifier
564  * `onlyOwner`, which can be applied to your functions to restrict their use to
565  * the owner.
566  */
567 abstract contract Ownable is Context {
568     address private _owner;
569 
570     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
571 
572     /**
573      * @dev Initializes the contract setting the deployer as the initial owner.
574      */
575     constructor() {
576         _setOwner(_msgSender());
577     }
578 
579     /**
580      * @dev Returns the address of the current owner.
581      */
582     function owner() public view virtual returns (address) {
583         return _owner;
584     }
585 
586     /**
587      * @dev Throws if called by any account other than the owner.
588      */
589     modifier onlyOwner() {
590         require(owner() == _msgSender(), "Ownable: caller is not the owner");
591         _;
592     }
593 
594     /**
595      * @dev Leaves the contract without owner. It will not be possible to call
596      * `onlyOwner` functions anymore. Can only be called by the current owner.
597      *
598      * NOTE: Renouncing ownership will leave the contract without an owner,
599      * thereby removing any functionality that is only available to the owner.
600      */
601     function renounceOwnership() public virtual onlyOwner {
602         _setOwner(address(0));
603     }
604 
605     /**
606      * @dev Transfers ownership of the contract to a new account (`newOwner`).
607      * Can only be called by the current owner.
608      */
609     function transferOwnership(address newOwner) public virtual onlyOwner {
610         require(newOwner != address(0), "Ownable: new owner is the zero address");
611         _setOwner(newOwner);
612     }
613 
614     function _setOwner(address newOwner) private {
615         address oldOwner = _owner;
616         _owner = newOwner;
617         emit OwnershipTransferred(oldOwner, newOwner);
618     }
619 }
620 
621 
622 /**
623  * @dev Wrappers over Solidity's arithmetic operations.
624  *
625  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
626  * now has built in overflow checking.
627  */
628 library SafeMath {
629     /**
630      * @dev Returns the addition of two unsigned integers, with an overflow flag.
631      *
632      * _Available since v3.4._
633      */
634     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
635         unchecked {
636             uint256 c = a + b;
637             if (c < a) return (false, 0);
638             return (true, c);
639         }
640     }
641 
642     /**
643      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
644      *
645      * _Available since v3.4._
646      */
647     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
648         unchecked {
649             if (b > a) return (false, 0);
650             return (true, a - b);
651         }
652     }
653 
654     /**
655      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
656      *
657      * _Available since v3.4._
658      */
659     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
660         unchecked {
661             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
662             // benefit is lost if 'b' is also tested.
663             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
664             if (a == 0) return (true, 0);
665             uint256 c = a * b;
666             if (c / a != b) return (false, 0);
667             return (true, c);
668         }
669     }
670 
671     /**
672      * @dev Returns the division of two unsigned integers, with a division by zero flag.
673      *
674      * _Available since v3.4._
675      */
676     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
677         unchecked {
678             if (b == 0) return (false, 0);
679             return (true, a / b);
680         }
681     }
682 
683     /**
684      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
685      *
686      * _Available since v3.4._
687      */
688     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
689         unchecked {
690             if (b == 0) return (false, 0);
691             return (true, a % b);
692         }
693     }
694 
695     /**
696      * @dev Returns the addition of two unsigned integers, reverting on
697      * overflow.
698      *
699      * Counterpart to Solidity's `+` operator.
700      *
701      * Requirements:
702      *
703      * - Addition cannot overflow.
704      */
705     function add(uint256 a, uint256 b) internal pure returns (uint256) {
706         return a + b;
707     }
708 
709     /**
710      * @dev Returns the subtraction of two unsigned integers, reverting on
711      * overflow (when the result is negative).
712      *
713      * Counterpart to Solidity's `-` operator.
714      *
715      * Requirements:
716      *
717      * - Subtraction cannot overflow.
718      */
719     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a - b;
721     }
722 
723     /**
724      * @dev Returns the multiplication of two unsigned integers, reverting on
725      * overflow.
726      *
727      * Counterpart to Solidity's `*` operator.
728      *
729      * Requirements:
730      *
731      * - Multiplication cannot overflow.
732      */
733     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
734         return a * b;
735     }
736 
737     /**
738      * @dev Returns the integer division of two unsigned integers, reverting on
739      * division by zero. The result is rounded towards zero.
740      *
741      * Counterpart to Solidity's `/` operator.
742      *
743      * Requirements:
744      *
745      * - The divisor cannot be zero.
746      */
747     function div(uint256 a, uint256 b) internal pure returns (uint256) {
748         return a / b;
749     }
750 
751     /**
752      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
753      * reverting when dividing by zero.
754      *
755      * Counterpart to Solidity's `%` operator. This function uses a `revert`
756      * opcode (which leaves remaining gas untouched) while Solidity uses an
757      * invalid opcode to revert (consuming all remaining gas).
758      *
759      * Requirements:
760      *
761      * - The divisor cannot be zero.
762      */
763     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
764         return a % b;
765     }
766 
767     /**
768      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
769      * overflow (when the result is negative).
770      *
771      * CAUTION: This function is deprecated because it requires allocating memory for the error
772      * message unnecessarily. For custom revert reasons use {trySub}.
773      *
774      * Counterpart to Solidity's `-` operator.
775      *
776      * Requirements:
777      *
778      * - Subtraction cannot overflow.
779      */
780     function sub(
781         uint256 a,
782         uint256 b,
783         string memory errorMessage
784     ) internal pure returns (uint256) {
785         unchecked {
786             require(b <= a, errorMessage);
787             return a - b;
788         }
789     }
790 
791     /**
792      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
793      * division by zero. The result is rounded towards zero.
794      *
795      * Counterpart to Solidity's `/` operator. Note: this function uses a
796      * `revert` opcode (which leaves remaining gas untouched) while Solidity
797      * uses an invalid opcode to revert (consuming all remaining gas).
798      *
799      * Requirements:
800      *
801      * - The divisor cannot be zero.
802      */
803     function div(
804         uint256 a,
805         uint256 b,
806         string memory errorMessage
807     ) internal pure returns (uint256) {
808         unchecked {
809             require(b > 0, errorMessage);
810             return a / b;
811         }
812     }
813 
814     /**
815      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
816      * reverting with custom message when dividing by zero.
817      *
818      * CAUTION: This function is deprecated because it requires allocating memory for the error
819      * message unnecessarily. For custom revert reasons use {tryMod}.
820      *
821      * Counterpart to Solidity's `%` operator. This function uses a `revert`
822      * opcode (which leaves remaining gas untouched) while Solidity uses an
823      * invalid opcode to revert (consuming all remaining gas).
824      *
825      * Requirements:
826      *
827      * - The divisor cannot be zero.
828      */
829     function mod(
830         uint256 a,
831         uint256 b,
832         string memory errorMessage
833     ) internal pure returns (uint256) {
834         unchecked {
835             require(b > 0, errorMessage);
836             return a % b;
837         }
838     }
839 }
840 
841 struct TokenMeta {
842     uint256 id;
843     string name;
844     string uri;
845     string hash;
846     uint256 soldTimes;
847     address minter;
848 }
849 
850 abstract contract IVoiceStreetNft {
851     function totalSupply() public virtual view returns(uint256);
852 
853     function tokenMeta(uint256 _tokenId) public virtual view returns (TokenMeta memory);
854     
855     function setTokenAsset(uint256 _tokenId, string memory _uri, string memory _hash, address _minter) public virtual;
856 
857     function increaseSoldTimes(uint256 _tokenId) public virtual;
858 
859     function getSoldTimes(uint256 _tokenId) public virtual view returns(uint256);
860 }
861 
862 abstract contract ISaleContract {
863     function sale(uint256 tokenId, uint256[] memory _settings, address[] memory _addrs) public virtual;
864 
865     function offload(uint256 tokenId) public virtual;
866 }
867 
868 contract VoiceStreetNoWhiteListNftContract is IVoiceStreetNft, Context, ERC165, IERC721, IERC721Metadata, Ownable {
869     using Address for address;
870     using Strings for uint256;
871     using Counters for Counters.Counter;
872     Counters.Counter private _tokenIds;
873 
874     mapping (uint256 => TokenMeta) public tokenOnChainMeta;
875 
876     uint256 private max_supply = 10000;
877     uint256 private current_supply = 0;
878     uint256 private current_sold = 0;
879     string private baseURI;
880 
881     // Token name
882     string private _name;
883 
884     // Token symbol
885     string private _symbol;
886 
887     // Mapping from token ID to owner address
888     mapping(uint256 => address) internal _owners;
889 
890     // Mapping owner address to token count
891     mapping(address => uint256) private _balances;
892 
893     // Mapping from token ID to approved address
894     mapping(uint256 => address) private _tokenApprovals;
895 
896     // Mapping from owner to operator approvals
897     mapping(address => mapping(address => bool)) private _operatorApprovals;
898 
899     uint public price;
900 
901     uint public buy_limit_per_address = 10;
902 
903     uint public sell_begin_time = 0;
904 
905     constructor()
906     {
907         _name = "Daffy Panda Ganging Up";
908         _symbol = "DPGU";
909         setBaseURI("https://www.vsnft.org/token/");
910     }
911 
912     function setBaseURI(string memory _newBaseURI) public onlyOwner {
913         baseURI = _newBaseURI;
914     }
915 
916     function setMaxSupply(uint _value) public onlyOwner {
917         max_supply = _value;
918     }
919 
920     function setNames(string memory name_, string memory symbol_) public onlyOwner {
921         _name = name_;
922         _symbol = symbol_;
923     }
924 
925     function totalSupply() public override view returns(uint256) {
926         return max_supply;
927     }
928 
929     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
930         return
931             interfaceId == type(IERC721).interfaceId ||
932             interfaceId == type(IERC721Metadata).interfaceId ||
933             super.supportsInterface(interfaceId);
934     }
935 
936     function balanceOf(address owner) public view override returns (uint256) {
937         require(owner != address(0), "ERC721: balance query for the zero address");
938         return _balances[owner];
939     }
940 
941     function ownerOf(uint256 tokenId) public view override returns (address) {
942         address tokenOwner = _owners[tokenId];
943         return tokenOwner == address(0) ? owner() : tokenOwner;
944     }
945 
946     function name() public view override returns (string memory) {
947         return _name;
948     }
949 
950     function symbol() public view override returns (string memory) {
951         return _symbol;
952     }
953 
954     function tokenURI(uint256 tokenId) public view override returns (string memory) {
955         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
956     }
957 
958     function approve(address to, uint256 tokenId) public override {
959         address owner = ownerOf(tokenId);
960         require(to != owner, "ERC721: approval to current owner");
961 
962         require(
963             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
964             "ERC721: approve caller is not owner nor approved for all"
965         );
966 
967         _approve(to, tokenId);
968     }
969 
970     function getApproved(uint256 tokenId) public view override returns (address) {
971         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
972 
973         return _tokenApprovals[tokenId];
974     }
975 
976     function setApprovalForAll(address operator, bool approved) public override {
977         require(operator != _msgSender(), "ERC721: approve to caller");
978 
979         _operatorApprovals[_msgSender()][operator] = approved;
980         emit ApprovalForAll(_msgSender(), operator, approved);
981     }
982 
983     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
984         return _operatorApprovals[owner][operator];
985     }
986 
987     function transferFrom(
988         address from,
989         address to,
990         uint256 tokenId
991     ) public override {
992         //solhint-disable-next-line max-line-length
993         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
994 
995         _transfer(from, to, tokenId);
996     }
997 
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public override {
1003         safeTransferFrom(from, to, tokenId, "");
1004     }
1005 
1006     function safeTransferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId,
1010         bytes memory _data
1011     ) public override {
1012         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1013         _safeTransfer(from, to, tokenId, _data);
1014     }
1015 
1016     function _safeTransfer(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) internal {
1022         _transfer(from, to, tokenId);
1023         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1024     }
1025 
1026     function _exists(uint256 tokenId) internal view returns (bool) {
1027         return tokenId <= current_supply;
1028     }
1029 
1030     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1031         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1032         address owner = ownerOf(tokenId);
1033         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1034     }
1035 
1036     function _safeMint(address to, uint256 tokenId) internal {
1037         _safeMint(to, tokenId, "");
1038     }
1039 
1040     function _safeMint(
1041         address to,
1042         uint256 tokenId,
1043         bytes memory _data
1044     ) internal {
1045         _mint(to, tokenId, true);
1046         require(
1047             _checkOnERC721Received(address(0), to, tokenId, _data),
1048             "ERC721: transfer to non ERC721Receiver implementer"
1049         );
1050     }
1051 
1052     function _mint(address to, uint256 tokenId, bool emitting) internal {
1053         require(to != address(0), "ERC721: mint to the zero address");
1054         require(_owners[tokenId] == address(0), "ERC721: token already minted");
1055 
1056         _balances[to] += 1;
1057         _owners[tokenId] = to;
1058 
1059         if (emitting) {
1060             emit Transfer(address(0), to, tokenId);
1061         }
1062     }
1063 
1064     function _transfer(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) internal {
1069         address tokenOwner = _owners[tokenId];
1070         if (tokenOwner == address(0)) {
1071             require(from == owner(), "can only mint from contract owner");
1072             _mint(from, tokenId, true);
1073         }
1074 
1075         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1076         require(to != address(0), "ERC721: transfer to the zero address");
1077 
1078         // Clear approvals from the previous owner
1079         _approve(address(0), tokenId);
1080 
1081         _balances[from] -= 1;
1082         _balances[to] += 1;
1083         _owners[tokenId] = to;
1084 
1085         emit Transfer(from, to, tokenId);
1086     }
1087 
1088     function _approve(address to, uint256 tokenId) internal {
1089         _tokenApprovals[tokenId] = to;
1090         emit Approval(ownerOf(tokenId), to, tokenId);
1091     }
1092 
1093     function _checkOnERC721Received(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) private returns (bool) {
1099         if (to.isContract()) {
1100             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1101                 return retval == IERC721Receiver(to).onERC721Received.selector;
1102             } catch (bytes memory reason) {
1103                 if (reason.length == 0) {
1104                     revert("ERC721: transfer to non ERC721Receiver implementer");
1105                 } else {
1106                     assembly {
1107                         revert(add(32, reason), mload(reason))
1108                     }
1109                 }
1110             }
1111         } else {
1112             return true;
1113         }
1114     }
1115 
1116     function tokenMeta(uint256 _tokenId) public override view returns (TokenMeta memory) {
1117         return tokenOnChainMeta[_tokenId];
1118     }
1119 
1120     function mintAndPricing(uint256 _num, uint256 _price, uint256 _limit, uint256 _time) public onlyOwner {
1121         uint supply = SafeMath.add(current_supply, _num);
1122 
1123         current_supply = supply;
1124         price = _price;
1125         buy_limit_per_address = _limit;
1126         sell_begin_time = _time;
1127     }
1128 
1129     function setTokenAsset(uint256 _tokenId, string memory _uri, string memory _hash, address _minter) public override onlyOwner {
1130         require(_exists(_tokenId), "Vsnft_setTokenAsset_notoken");
1131         TokenMeta storage meta = tokenOnChainMeta[_tokenId];
1132         meta.uri = _uri;
1133         meta.hash = _hash;
1134         meta.minter = _minter;
1135         tokenOnChainMeta[_tokenId] = meta;
1136     }
1137 
1138     function setSale(uint256 _tokenId, address _contractAddr, uint256[] memory _settings, address[] memory _addrs) public {
1139         require(_exists(_tokenId), "Vsnft_setTokenAsset_notoken");
1140         address sender = _msgSender();
1141         require(owner() == sender || ownerOf(_tokenId) == sender, "Invalid_Owner");
1142         
1143         ISaleContract _contract = ISaleContract(_contractAddr);
1144         _contract.sale(_tokenId, _settings, _addrs);   
1145         _transfer(sender, _contractAddr, _tokenId);
1146     }
1147 
1148     function increaseSoldTimes(uint256 /* _tokenId */) public override {
1149     }
1150 
1151     function getSoldTimes(uint256 _tokenId) public override view returns(uint256) {
1152         TokenMeta memory meta = tokenOnChainMeta[_tokenId];
1153         return meta.soldTimes;
1154     }
1155 
1156     function buy(uint amount, uint adv_time) public payable {
1157         require(block.timestamp >= SafeMath.sub(sell_begin_time, adv_time), "Purchase_Not_Enabled");
1158         require(SafeMath.add(balanceOf(msg.sender), amount) <= buy_limit_per_address, "Exceed_Purchase_Limit");
1159         uint requiredValue = SafeMath.mul(amount, price);
1160         require(msg.value >= requiredValue, "Not_Enough_Payment");
1161         require(current_supply >= SafeMath.add(current_sold, amount), "Not_Enough_Stock");
1162 
1163         for (uint i = 0; i < amount; ++i) {
1164             _tokenIds.increment();
1165             uint256 newItemId = _tokenIds.current();
1166             _mint(msg.sender, newItemId, true);
1167 
1168             TokenMeta memory meta = TokenMeta(
1169                 newItemId, 
1170                 "", 
1171                 "",
1172                 "",
1173                 1,
1174                 owner());
1175 
1176             tokenOnChainMeta[newItemId] = meta;
1177         }
1178 
1179         current_sold = SafeMath.add(current_sold, amount);
1180     }
1181 
1182     function withdraw() public onlyOwner {
1183         uint balance = address(this).balance;
1184         Address.sendValue(payable(owner()), balance);
1185     }
1186 
1187     function stockAvailable(address account) public view returns (uint, uint, uint) {
1188         return (current_supply, current_sold, balanceOf(account));
1189     }
1190 }