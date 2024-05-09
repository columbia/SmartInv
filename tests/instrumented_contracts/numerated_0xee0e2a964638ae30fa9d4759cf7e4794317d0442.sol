1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity >=0.7.0 <0.9.0;
4 
5 library Counters {
6     struct Counter {
7         // This variable should never be directly accessed by users of the library: interactions must be restricted to
8         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
9         // this feature: see https://github.com/ethereum/solidity/issues/4637
10         uint256 _value; // default: 0
11     }
12 
13     function current(Counter storage counter) internal view returns (uint256) {
14         return counter._value;
15     }
16 
17     function increment(Counter storage counter) internal {
18         unchecked {
19             counter._value += 1;
20         }
21     }
22 
23     function decrement(Counter storage counter) internal {
24         uint256 value = counter._value;
25         require(value > 0, "Counter: decrement overflow");
26         unchecked {
27             counter._value = value - 1;
28         }
29     }
30 
31     function reset(Counter storage counter) internal {
32         counter._value = 0;
33     }
34 }
35 
36 library SafeMath {
37     /**
38      * @dev Returns the addition of two unsigned integers, with an overflow flag.
39      *
40      * _Available since v3.4._
41      */
42     function tryAdd(uint256 a, uint256 b)
43         internal
44         pure
45         returns (bool, uint256)
46     {
47         unchecked {
48             uint256 c = a + b;
49             if (c < a) return (false, 0);
50             return (true, c);
51         }
52     }
53 
54     /**
55      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function trySub(uint256 a, uint256 b)
60         internal
61         pure
62         returns (bool, uint256)
63     {
64         unchecked {
65             if (b > a) return (false, 0);
66             return (true, a - b);
67         }
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMul(uint256 a, uint256 b)
76         internal
77         pure
78         returns (bool, uint256)
79     {
80         unchecked {
81             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82             // benefit is lost if 'b' is also tested.
83             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84             if (a == 0) return (true, 0);
85             uint256 c = a * b;
86             if (c / a != b) return (false, 0);
87             return (true, c);
88         }
89     }
90 
91     /**
92      * @dev Returns the division of two unsigned integers, with a division by zero flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryDiv(uint256 a, uint256 b)
97         internal
98         pure
99         returns (bool, uint256)
100     {
101         unchecked {
102             if (b == 0) return (false, 0);
103             return (true, a / b);
104         }
105     }
106 
107     /**
108      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
109      *
110      * _Available since v3.4._
111      */
112     function tryMod(uint256 a, uint256 b)
113         internal
114         pure
115         returns (bool, uint256)
116     {
117         unchecked {
118             if (b == 0) return (false, 0);
119             return (true, a % b);
120         }
121     }
122 
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      *
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a + b;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a - b;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a * b;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers, reverting on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator.
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a / b;
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * reverting when dividing by zero.
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
192         return a % b;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
197      * overflow (when the result is negative).
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {trySub}.
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      *
206      * - Subtraction cannot overflow.
207      */
208     function sub(
209         uint256 a,
210         uint256 b,
211         string memory errorMessage
212     ) internal pure returns (uint256) {
213         unchecked {
214             require(b <= a, errorMessage);
215             return a - b;
216         }
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         unchecked {
237             require(b > 0, errorMessage);
238             return a / b;
239         }
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * reverting with custom message when dividing by zero.
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {tryMod}.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a % b;
265         }
266     }
267 }
268 
269 library Strings {
270     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
271 
272     /**
273      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
274      */
275     function toString(uint256 value) internal pure returns (string memory) {
276         // Inspired by OraclizeAPI's implementation - MIT licence
277         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
278 
279         if (value == 0) {
280             return "0";
281         }
282         uint256 temp = value;
283         uint256 digits;
284         while (temp != 0) {
285             digits++;
286             temp /= 10;
287         }
288         bytes memory buffer = new bytes(digits);
289         while (value != 0) {
290             digits -= 1;
291             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
292             value /= 10;
293         }
294         return string(buffer);
295     }
296 
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
299      */
300     function toHexString(uint256 value) internal pure returns (string memory) {
301         if (value == 0) {
302             return "0x00";
303         }
304         uint256 temp = value;
305         uint256 length = 0;
306         while (temp != 0) {
307             length++;
308             temp >>= 8;
309         }
310         return toHexString(value, length);
311     }
312 
313     /**
314      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
315      */
316     function toHexString(uint256 value, uint256 length)
317         internal
318         pure
319         returns (string memory)
320     {
321         bytes memory buffer = new bytes(2 * length + 2);
322         buffer[0] = "0";
323         buffer[1] = "x";
324         for (uint256 i = 2 * length + 1; i > 1; --i) {
325             buffer[i] = _HEX_SYMBOLS[value & 0xf];
326             value >>= 4;
327         }
328         require(value == 0, "Strings: hex length insufficient");
329         return string(buffer);
330     }
331 }
332 
333 abstract contract Context {
334     function _msgSender() internal view virtual returns (address) {
335         return msg.sender;
336     }
337 
338     function _msgData() internal view virtual returns (bytes calldata) {
339         return msg.data;
340     }
341 }
342 
343 abstract contract Ownable is Context {
344     address private _owner;
345 
346     event OwnershipTransferred(
347         address indexed previousOwner,
348         address indexed newOwner
349     );
350 
351     /**
352      * @dev Initializes the contract setting the deployer as the initial owner.
353      */
354     constructor() {
355         _setOwner(_msgSender());
356     }
357 
358     /**
359      * @dev Returns the address of the current owner.
360      */
361     function owner() public view virtual returns (address) {
362         return _owner;
363     }
364 
365     /**
366      * @dev Throws if called by any account other than the owner.
367      */
368     modifier onlyOwner() {
369         require(owner() == _msgSender(), "Ownable: caller is not the owner");
370         _;
371     }
372 
373     /**
374      * @dev Leaves the contract without owner. It will not be possible to call
375      * `onlyOwner` functions anymore. Can only be called by the current owner.
376      *
377      * NOTE: Renouncing ownership will leave the contract without an owner,
378      * thereby removing any functionality that is only available to the owner.
379      */
380     function renounceOwnership() public virtual onlyOwner {
381         _setOwner(address(0));
382     }
383 
384     /**
385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
386      * Can only be called by the current owner.
387      */
388     function transferOwnership(address newOwner) public virtual onlyOwner {
389         require(
390             newOwner != address(0),
391             "Ownable: new owner is the zero address"
392         );
393         _setOwner(newOwner);
394     }
395 
396     function _setOwner(address newOwner) private {
397         address oldOwner = _owner;
398         _owner = newOwner;
399         emit OwnershipTransferred(oldOwner, newOwner);
400     }
401 }
402 
403 library Address {
404     /**
405      * @dev Returns true if `account` is a contract.
406      *
407      * [IMPORTANT]
408      * ====
409      * It is unsafe to assume that an address for which this function returns
410      * false is an externally-owned account (EOA) and not a contract.
411      *
412      * Among others, `isContract` will return false for the following
413      * types of addresses:
414      *
415      *  - an externally-owned account
416      *  - a contract in construction
417      *  - an address where a contract will be created
418      *  - an address where a contract lived, but was destroyed
419      * ====
420      */
421     function isContract(address account) internal view returns (bool) {
422         // This method relies on extcodesize, which returns 0 for contracts in
423         // construction, since the code is only stored at the end of the
424         // constructor execution.
425 
426         uint256 size;
427         assembly {
428             size := extcodesize(account)
429         }
430         return size > 0;
431     }
432 
433     /**
434      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
435      * `recipient`, forwarding all available gas and reverting on errors.
436      *
437      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
438      * of certain opcodes, possibly making contracts go over the 2300 gas limit
439      * imposed by `transfer`, making them unable to receive funds via
440      * `transfer`. {sendValue} removes this limitation.
441      *
442      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
443      *
444      * IMPORTANT: because control is transferred to `recipient`, care must be
445      * taken to not create reentrancy vulnerabilities. Consider using
446      * {ReentrancyGuard} or the
447      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
448      */
449     function sendValue(address payable recipient, uint256 amount) internal {
450         require(
451             address(this).balance >= amount,
452             "Address: insufficient balance"
453         );
454 
455         (bool success, ) = recipient.call{value: amount}("");
456         require(
457             success,
458             "Address: unable to send value, recipient may have reverted"
459         );
460     }
461 
462     /**
463      * @dev Performs a Solidity function call using a low level `call`. A
464      * plain `call` is an unsafe replacement for a function call: use this
465      * function instead.
466      *
467      * If `target` reverts with a revert reason, it is bubbled up by this
468      * function (like regular Solidity function calls).
469      *
470      * Returns the raw returned data. To convert to the expected return value,
471      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
472      *
473      * Requirements:
474      *
475      * - `target` must be a contract.
476      * - calling `target` with `data` must not revert.
477      *
478      * _Available since v3.1._
479      */
480     function functionCall(address target, bytes memory data)
481         internal
482         returns (bytes memory)
483     {
484         return functionCall(target, data, "Address: low-level call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
489      * `errorMessage` as a fallback revert reason when `target` reverts.
490      *
491      * _Available since v3.1._
492      */
493     function functionCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         return functionCallWithValue(target, data, 0, errorMessage);
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
503      * but also transferring `value` wei to `target`.
504      *
505      * Requirements:
506      *
507      * - the calling contract must have an ETH balance of at least `value`.
508      * - the called Solidity function must be `payable`.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value
516     ) internal returns (bytes memory) {
517         return
518             functionCallWithValue(
519                 target,
520                 data,
521                 value,
522                 "Address: low-level call with value failed"
523             );
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
528      * with `errorMessage` as a fallback revert reason when `target` reverts.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(
539             address(this).balance >= value,
540             "Address: insufficient balance for call"
541         );
542         require(isContract(target), "Address: call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.call{value: value}(
545             data
546         );
547         return verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(address target, bytes memory data)
557         internal
558         view
559         returns (bytes memory)
560     {
561         return
562             functionStaticCall(
563                 target,
564                 data,
565                 "Address: low-level static call failed"
566             );
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
571      * but performing a static call.
572      *
573      * _Available since v3.3._
574      */
575     function functionStaticCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal view returns (bytes memory) {
580         require(isContract(target), "Address: static call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.staticcall(data);
583         return verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(address target, bytes memory data)
593         internal
594         returns (bytes memory)
595     {
596         return
597             functionDelegateCall(
598                 target,
599                 data,
600                 "Address: low-level delegate call failed"
601             );
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
606      * but performing a delegate call.
607      *
608      * _Available since v3.4._
609      */
610     function functionDelegateCall(
611         address target,
612         bytes memory data,
613         string memory errorMessage
614     ) internal returns (bytes memory) {
615         require(isContract(target), "Address: delegate call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.delegatecall(data);
618         return verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
623      * revert reason using the provided one.
624      *
625      * _Available since v4.3._
626      */
627     function verifyCallResult(
628         bool success,
629         bytes memory returndata,
630         string memory errorMessage
631     ) internal pure returns (bytes memory) {
632         if (success) {
633             return returndata;
634         } else {
635             // Look for revert reason and bubble it up if present
636             if (returndata.length > 0) {
637                 // The easiest way to bubble the revert reason is using memory via assembly
638 
639                 assembly {
640                     let returndata_size := mload(returndata)
641                     revert(add(32, returndata), returndata_size)
642                 }
643             } else {
644                 revert(errorMessage);
645             }
646         }
647     }
648 }
649 
650 interface IERC721Receiver {
651     /**
652      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
653      * by `operator` from `from`, this function is called.
654      *
655      * It must return its Solidity selector to confirm the token transfer.
656      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
657      *
658      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
659      */
660     function onERC721Received(
661         address operator,
662         address from,
663         uint256 tokenId,
664         bytes calldata data
665     ) external returns (bytes4);
666 }
667 
668 interface IERC165 {
669     /**
670      * @dev Returns true if this contract implements the interface defined by
671      * `interfaceId`. See the corresponding
672      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
673      * to learn more about how these ids are created.
674      *
675      * This function call must use less than 30 000 gas.
676      */
677     function supportsInterface(bytes4 interfaceId) external view returns (bool);
678 }
679 
680 abstract contract ERC165 is IERC165 {
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId)
685         public
686         view
687         virtual
688         override
689         returns (bool)
690     {
691         return interfaceId == type(IERC165).interfaceId;
692     }
693 }
694 
695 interface IERC721 is IERC165 {
696     /**
697      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
698      */
699     event Transfer(
700         address indexed from,
701         address indexed to,
702         uint256 indexed tokenId
703     );
704 
705     /**
706      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
707      */
708     event Approval(
709         address indexed owner,
710         address indexed approved,
711         uint256 indexed tokenId
712     );
713 
714     /**
715      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
716      */
717     event ApprovalForAll(
718         address indexed owner,
719         address indexed operator,
720         bool approved
721     );
722 
723     /**
724      * @dev Returns the number of tokens in ``owner``'s account.
725      */
726     function balanceOf(address owner) external view returns (uint256 balance);
727 
728     /**
729      * @dev Returns the owner of the `tokenId` token.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function ownerOf(uint256 tokenId) external view returns (address owner);
736 
737     /**
738      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
739      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
748      *
749      * Emits a {Transfer} event.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) external;
756 
757     /**
758      * @dev Transfers `tokenId` token from `from` to `to`.
759      *
760      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must be owned by `from`.
767      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
768      *
769      * Emits a {Transfer} event.
770      */
771     function transferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) external;
776 
777     /**
778      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
779      * The approval is cleared when the token is transferred.
780      *
781      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
782      *
783      * Requirements:
784      *
785      * - The caller must own the token or be an approved operator.
786      * - `tokenId` must exist.
787      *
788      * Emits an {Approval} event.
789      */
790     function approve(address to, uint256 tokenId) external;
791 
792     /**
793      * @dev Returns the account approved for `tokenId` token.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      */
799     function getApproved(uint256 tokenId)
800         external
801         view
802         returns (address operator);
803 
804     /**
805      * @dev Approve or remove `operator` as an operator for the caller.
806      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
807      *
808      * Requirements:
809      *
810      * - The `operator` cannot be the caller.
811      *
812      * Emits an {ApprovalForAll} event.
813      */
814     function setApprovalForAll(address operator, bool _approved) external;
815 
816     /**
817      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
818      *
819      * See {setApprovalForAll}
820      */
821     function isApprovedForAll(address owner, address operator)
822         external
823         view
824         returns (bool);
825 
826     /**
827      * @dev Safely transfers `tokenId` token from `from` to `to`.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must exist and be owned by `from`.
834      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
836      *
837      * Emits a {Transfer} event.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId,
843         bytes calldata data
844     ) external;
845 }
846 
847 interface IERC721Enumerable is IERC721 {
848     /**
849      * @dev Returns the total amount of tokens stored by the contract.
850      */
851     function totalSupply() external view returns (uint256);
852 
853     /**
854      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
855      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
856      */
857     function tokenOfOwnerByIndex(address owner, uint256 index)
858         external
859         view
860         returns (uint256 tokenId);
861 
862     /**
863      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
864      * Use along with {totalSupply} to enumerate all tokens.
865      */
866     function tokenByIndex(uint256 index) external view returns (uint256);
867 }
868 
869 interface IERC721Metadata is IERC721 {
870     /**
871      * @dev Returns the token collection name.
872      */
873     function name() external view returns (string memory);
874 
875     /**
876      * @dev Returns the token collection symbol.
877      */
878     function symbol() external view returns (string memory);
879 
880     /**
881      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
882      */
883     function tokenURI(uint256 tokenId) external view returns (string memory);
884 }
885 
886 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
887     using Address for address;
888     using Strings for uint256;
889 
890     // Token name
891     string private _name;
892 
893     // Token symbol
894     string private _symbol;
895 
896     // Mapping from token ID to owner address
897     mapping(uint256 => address) private _owners;
898 
899     // Mapping owner address to token count
900     mapping(address => uint256) private _balances;
901 
902     // Mapping from token ID to approved address
903     mapping(uint256 => address) private _tokenApprovals;
904 
905     // Mapping from owner to operator approvals
906     mapping(address => mapping(address => bool)) private _operatorApprovals;
907 
908     /**
909      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
910      */
911     constructor(string memory name_, string memory symbol_) {
912         _name = name_;
913         _symbol = symbol_;
914     }
915 
916     /**
917      * @dev See {IERC165-supportsInterface}.
918      */
919     function supportsInterface(bytes4 interfaceId)
920         public
921         view
922         virtual
923         override(ERC165, IERC165)
924         returns (bool)
925     {
926         return
927             interfaceId == type(IERC721).interfaceId ||
928             interfaceId == type(IERC721Metadata).interfaceId ||
929             super.supportsInterface(interfaceId);
930     }
931 
932     /**
933      * @dev See {IERC721-balanceOf}.
934      */
935     function balanceOf(address owner)
936         public
937         view
938         virtual
939         override
940         returns (uint256)
941     {
942         require(
943             owner != address(0),
944             "ERC721: balance query for the zero address"
945         );
946         return _balances[owner];
947     }
948 
949     /**
950      * @dev See {IERC721-ownerOf}.
951      */
952     function ownerOf(uint256 tokenId)
953         public
954         view
955         virtual
956         override
957         returns (address)
958     {
959         address owner = _owners[tokenId];
960         require(
961             owner != address(0),
962             "ERC721: owner query for nonexistent token"
963         );
964         return owner;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-name}.
969      */
970     function name() public view virtual override returns (string memory) {
971         return _name;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-symbol}.
976      */
977     function symbol() public view virtual override returns (string memory) {
978         return _symbol;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-tokenURI}.
983      */
984     function tokenURI(uint256 tokenId)
985         public
986         view
987         virtual
988         override
989         returns (string memory)
990     {
991         require(
992             _exists(tokenId),
993             "ERC721Metadata: URI query for nonexistent token"
994         );
995 
996         string memory baseURI = _baseURI();
997         return
998             bytes(baseURI).length > 0
999                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1000                 : "";
1001     }
1002 
1003     /**
1004      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1005      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1006      * by default, can be overriden in child contracts.
1007      */
1008     function _baseURI() internal view virtual returns (string memory) {
1009         return "";
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-approve}.
1014      */
1015     function approve(address to, uint256 tokenId) public virtual override {
1016         address owner = ERC721.ownerOf(tokenId);
1017         require(to != owner, "ERC721: approval to current owner");
1018 
1019         require(
1020             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1021             "ERC721: approve caller is not owner nor approved for all"
1022         );
1023 
1024         _approve(to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-getApproved}.
1029      */
1030     function getApproved(uint256 tokenId)
1031         public
1032         view
1033         virtual
1034         override
1035         returns (address)
1036     {
1037         require(
1038             _exists(tokenId),
1039             "ERC721: approved query for nonexistent token"
1040         );
1041 
1042         return _tokenApprovals[tokenId];
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-setApprovalForAll}.
1047      */
1048     function setApprovalForAll(address operator, bool approved)
1049         public
1050         virtual
1051         override
1052     {
1053         require(operator != _msgSender(), "ERC721: approve to caller");
1054 
1055         _operatorApprovals[_msgSender()][operator] = approved;
1056         emit ApprovalForAll(_msgSender(), operator, approved);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-isApprovedForAll}.
1061      */
1062     function isApprovedForAll(address owner, address operator)
1063         public
1064         view
1065         virtual
1066         override
1067         returns (bool)
1068     {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         //solhint-disable-next-line max-line-length
1081         require(
1082             _isApprovedOrOwner(_msgSender(), tokenId),
1083             "ERC721: transfer caller is not owner nor approved"
1084         );
1085 
1086         _transfer(from, to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-safeTransferFrom}.
1091      */
1092     function safeTransferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) public virtual override {
1097         safeTransferFrom(from, to, tokenId, "");
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-safeTransferFrom}.
1102      */
1103     function safeTransferFrom(
1104         address from,
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) public virtual override {
1109         require(
1110             _isApprovedOrOwner(_msgSender(), tokenId),
1111             "ERC721: transfer caller is not owner nor approved"
1112         );
1113         _safeTransfer(from, to, tokenId, _data);
1114     }
1115 
1116     /**
1117      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1118      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1119      *
1120      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1121      *
1122      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1123      * implement alternative mechanisms to perform token transfer, such as signature-based.
1124      *
1125      * Requirements:
1126      *
1127      * - `from` cannot be the zero address.
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must exist and be owned by `from`.
1130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _safeTransfer(
1135         address from,
1136         address to,
1137         uint256 tokenId,
1138         bytes memory _data
1139     ) internal virtual {
1140         _transfer(from, to, tokenId);
1141         require(
1142             _checkOnERC721Received(from, to, tokenId, _data),
1143             "ERC721: transfer to non ERC721Receiver implementer"
1144         );
1145     }
1146 
1147     /**
1148      * @dev Returns whether `tokenId` exists.
1149      *
1150      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1151      *
1152      * Tokens start existing when they are minted (`_mint`),
1153      * and stop existing when they are burned (`_burn`).
1154      */
1155     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1156         return _owners[tokenId] != address(0);
1157     }
1158 
1159     /**
1160      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1161      *
1162      * Requirements:
1163      *
1164      * - `tokenId` must exist.
1165      */
1166     function _isApprovedOrOwner(address spender, uint256 tokenId)
1167         internal
1168         view
1169         virtual
1170         returns (bool)
1171     {
1172         require(
1173             _exists(tokenId),
1174             "ERC721: operator query for nonexistent token"
1175         );
1176         address owner = ERC721.ownerOf(tokenId);
1177         return (spender == owner ||
1178             getApproved(tokenId) == spender ||
1179             isApprovedForAll(owner, spender));
1180     }
1181 
1182     /**
1183      * @dev Safely mints `tokenId` and transfers it to `to`.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must not exist.
1188      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function _safeMint(address to, uint256 tokenId) internal virtual {
1193         _safeMint(to, tokenId, "");
1194     }
1195 
1196     /**
1197      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1198      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1199      */
1200     function _safeMint(
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) internal virtual {
1205         _mint(to, tokenId);
1206         require(
1207             _checkOnERC721Received(address(0), to, tokenId, _data),
1208             "ERC721: transfer to non ERC721Receiver implementer"
1209         );
1210     }
1211 
1212     /**
1213      * @dev Mints `tokenId` and transfers it to `to`.
1214      *
1215      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must not exist.
1220      * - `to` cannot be the zero address.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function _mint(address to, uint256 tokenId) internal virtual {
1225         require(to != address(0), "ERC721: mint to the zero address");
1226         require(!_exists(tokenId), "ERC721: token already minted");
1227 
1228         _beforeTokenTransfer(address(0), to, tokenId);
1229 
1230         _balances[to] += 1;
1231         _owners[tokenId] = to;
1232 
1233         emit Transfer(address(0), to, tokenId);
1234     }
1235 
1236     /**
1237      * @dev Destroys `tokenId`.
1238      * The approval is cleared when the token is burned.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _burn(uint256 tokenId) internal virtual {
1247         address owner = ERC721.ownerOf(tokenId);
1248 
1249         _beforeTokenTransfer(owner, address(0), tokenId);
1250 
1251         // Clear approvals
1252         _approve(address(0), tokenId);
1253 
1254         _balances[owner] -= 1;
1255         delete _owners[tokenId];
1256 
1257         emit Transfer(owner, address(0), tokenId);
1258     }
1259 
1260     /**
1261      * @dev Transfers `tokenId` from `from` to `to`.
1262      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1263      *
1264      * Requirements:
1265      *
1266      * - `to` cannot be the zero address.
1267      * - `tokenId` token must be owned by `from`.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _transfer(
1272         address from,
1273         address to,
1274         uint256 tokenId
1275     ) internal virtual {
1276         require(
1277             ERC721.ownerOf(tokenId) == from,
1278             "ERC721: transfer of token that is not own"
1279         );
1280         require(to != address(0), "ERC721: transfer to the zero address");
1281 
1282         _beforeTokenTransfer(from, to, tokenId);
1283 
1284         // Clear approvals from the previous owner
1285         _approve(address(0), tokenId);
1286 
1287         _balances[from] -= 1;
1288         _balances[to] += 1;
1289         _owners[tokenId] = to;
1290 
1291         emit Transfer(from, to, tokenId);
1292     }
1293 
1294     /**
1295      * @dev Approve `to` to operate on `tokenId`
1296      *
1297      * Emits a {Approval} event.
1298      */
1299     function _approve(address to, uint256 tokenId) internal virtual {
1300         _tokenApprovals[tokenId] = to;
1301         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1306      * The call is not executed if the target address is not a contract.
1307      *
1308      * @param from address representing the previous owner of the given token ID
1309      * @param to target address that will receive the tokens
1310      * @param tokenId uint256 ID of the token to be transferred
1311      * @param _data bytes optional data to send along with the call
1312      * @return bool whether the call correctly returned the expected magic value
1313      */
1314     function _checkOnERC721Received(
1315         address from,
1316         address to,
1317         uint256 tokenId,
1318         bytes memory _data
1319     ) private returns (bool) {
1320         if (to.isContract()) {
1321             try
1322                 IERC721Receiver(to).onERC721Received(
1323                     _msgSender(),
1324                     from,
1325                     tokenId,
1326                     _data
1327                 )
1328             returns (bytes4 retval) {
1329                 return retval == IERC721Receiver.onERC721Received.selector;
1330             } catch (bytes memory reason) {
1331                 if (reason.length == 0) {
1332                     revert(
1333                         "ERC721: transfer to non ERC721Receiver implementer"
1334                     );
1335                 } else {
1336                     assembly {
1337                         revert(add(32, reason), mload(reason))
1338                     }
1339                 }
1340             }
1341         } else {
1342             return true;
1343         }
1344     }
1345 
1346     /**
1347      * @dev Hook that is called before any token transfer. This includes minting
1348      * and burning.
1349      *
1350      * Calling conditions:
1351      *
1352      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1353      * transferred to `to`.
1354      * - When `from` is zero, `tokenId` will be minted for `to`.
1355      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1356      * - `from` and `to` are never both zero.
1357      *
1358      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1359      */
1360     function _beforeTokenTransfer(
1361         address from,
1362         address to,
1363         uint256 tokenId
1364     ) internal virtual {}
1365 }
1366 
1367 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1368     // Mapping from owner to list of owned token IDs
1369     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1370 
1371     // Mapping from token ID to index of the owner tokens list
1372     mapping(uint256 => uint256) private _ownedTokensIndex;
1373 
1374     // Array with all token ids, used for enumeration
1375     uint256[] private _allTokens;
1376 
1377     // Mapping from token id to position in the allTokens array
1378     mapping(uint256 => uint256) private _allTokensIndex;
1379 
1380     /**
1381      * @dev See {IERC165-supportsInterface}.
1382      */
1383     function supportsInterface(bytes4 interfaceId)
1384         public
1385         view
1386         virtual
1387         override(IERC165, ERC721)
1388         returns (bool)
1389     {
1390         return
1391             interfaceId == type(IERC721Enumerable).interfaceId ||
1392             super.supportsInterface(interfaceId);
1393     }
1394 
1395     /**
1396      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1397      */
1398     function tokenOfOwnerByIndex(address owner, uint256 index)
1399         public
1400         view
1401         virtual
1402         override
1403         returns (uint256)
1404     {
1405         require(
1406             index < ERC721.balanceOf(owner),
1407             "ERC721Enumerable: owner index out of bounds"
1408         );
1409         return _ownedTokens[owner][index];
1410     }
1411 
1412     /**
1413      * @dev See {IERC721Enumerable-totalSupply}.
1414      */
1415     function totalSupply() public view virtual override returns (uint256) {
1416         return _allTokens.length;
1417     }
1418 
1419     /**
1420      * @dev See {IERC721Enumerable-tokenByIndex}.
1421      */
1422     function tokenByIndex(uint256 index)
1423         public
1424         view
1425         virtual
1426         override
1427         returns (uint256)
1428     {
1429         require(
1430             index < ERC721Enumerable.totalSupply(),
1431             "ERC721Enumerable: global index out of bounds"
1432         );
1433         return _allTokens[index];
1434     }
1435 
1436     /**
1437      * @dev Hook that is called before any token transfer. This includes minting
1438      * and burning.
1439      *
1440      * Calling conditions:
1441      *
1442      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1443      * transferred to `to`.
1444      * - When `from` is zero, `tokenId` will be minted for `to`.
1445      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1446      * - `from` cannot be the zero address.
1447      * - `to` cannot be the zero address.
1448      *
1449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1450      */
1451     function _beforeTokenTransfer(
1452         address from,
1453         address to,
1454         uint256 tokenId
1455     ) internal virtual override {
1456         super._beforeTokenTransfer(from, to, tokenId);
1457 
1458         if (from == address(0)) {
1459             _addTokenToAllTokensEnumeration(tokenId);
1460         } else if (from != to) {
1461             _removeTokenFromOwnerEnumeration(from, tokenId);
1462         }
1463         if (to == address(0)) {
1464             _removeTokenFromAllTokensEnumeration(tokenId);
1465         } else if (to != from) {
1466             _addTokenToOwnerEnumeration(to, tokenId);
1467         }
1468     }
1469 
1470     /**
1471      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1472      * @param to address representing the new owner of the given token ID
1473      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1474      */
1475     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1476         uint256 length = ERC721.balanceOf(to);
1477         _ownedTokens[to][length] = tokenId;
1478         _ownedTokensIndex[tokenId] = length;
1479     }
1480 
1481     /**
1482      * @dev Private function to add a token to this extension's token tracking data structures.
1483      * @param tokenId uint256 ID of the token to be added to the tokens list
1484      */
1485     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1486         _allTokensIndex[tokenId] = _allTokens.length;
1487         _allTokens.push(tokenId);
1488     }
1489 
1490     /**
1491      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1492      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1493      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1494      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1495      * @param from address representing the previous owner of the given token ID
1496      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1497      */
1498     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1499         private
1500     {
1501         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1502         // then delete the last slot (swap and pop).
1503 
1504         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1505         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1506 
1507         // When the token to delete is the last token, the swap operation is unnecessary
1508         if (tokenIndex != lastTokenIndex) {
1509             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1510 
1511             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1512             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1513         }
1514 
1515         // This also deletes the contents at the last position of the array
1516         delete _ownedTokensIndex[tokenId];
1517         delete _ownedTokens[from][lastTokenIndex];
1518     }
1519 
1520     /**
1521      * @dev Private function to remove a token from this extension's token tracking data structures.
1522      * This has O(1) time complexity, but alters the order of the _allTokens array.
1523      * @param tokenId uint256 ID of the token to be removed from the tokens list
1524      */
1525     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1526         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1527         // then delete the last slot (swap and pop).
1528 
1529         uint256 lastTokenIndex = _allTokens.length - 1;
1530         uint256 tokenIndex = _allTokensIndex[tokenId];
1531 
1532         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1533         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1534         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1535         uint256 lastTokenId = _allTokens[lastTokenIndex];
1536 
1537         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1538         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1539 
1540         // This also deletes the contents at the last position of the array
1541         delete _allTokensIndex[tokenId];
1542         _allTokens.pop();
1543     }
1544 }
1545 
1546 interface IERC20 {
1547     /**
1548      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1549      * another (`to`).
1550      *
1551      * Note that `value` may be zero.
1552      */
1553     event Transfer(address indexed from, address indexed to, uint256 value);
1554 
1555     /**
1556      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1557      * a call to {approve}. `value` is the new allowance.
1558      */
1559     event Approval(address indexed owner, address indexed spender, uint256 value);
1560 
1561     /**
1562      * @dev Returns the amount of tokens in existence.
1563      */
1564     function totalSupply() external view returns (uint256);
1565 
1566     /**
1567      * @dev Returns the amount of tokens owned by `account`.
1568      */
1569     function balanceOf(address account) external view returns (uint256);
1570 
1571     /**
1572      * @dev Moves `amount` tokens from the caller's account to `to`.
1573      *
1574      * Returns a boolean value indicating whether the operation succeeded.
1575      *
1576      * Emits a {Transfer} event.
1577      */
1578     function transfer(address to, uint256 amount) external returns (bool);
1579 
1580     /**
1581      * @dev Returns the remaining number of tokens that `spender` will be
1582      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1583      * zero by default.
1584      *
1585      * This value changes when {approve} or {transferFrom} are called.
1586      */
1587     function allowance(address owner, address spender) external view returns (uint256);
1588 
1589     /**
1590      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1591      *
1592      * Returns a boolean value indicating whether the operation succeeded.
1593      *
1594      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1595      * that someone may use both the old and the new allowance by unfortunate
1596      * transaction ordering. One possible solution to mitigate this race
1597      * condition is to first reduce the spender's allowance to 0 and set the
1598      * desired value afterwards:
1599      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1600      *
1601      * Emits an {Approval} event.
1602      */
1603     function approve(address spender, uint256 amount) external returns (bool);
1604 
1605     /**
1606      * @dev Moves `amount` tokens from `from` to `to` using the
1607      * allowance mechanism. `amount` is then deducted from the caller's
1608      * allowance.
1609      *
1610      * Returns a boolean value indicating whether the operation succeeded.
1611      *
1612      * Emits a {Transfer} event.
1613      */
1614     function transferFrom(
1615         address from,
1616         address to,
1617         uint256 amount
1618     ) external returns (bool);
1619 }
1620 
1621 interface IUniswapV2Router01 {
1622     function factory() external pure returns (address);
1623     function WETH() external pure returns (address);
1624 
1625     function addLiquidity(
1626         address tokenA,
1627         address tokenB,
1628         uint amountADesired,
1629         uint amountBDesired,
1630         uint amountAMin,
1631         uint amountBMin,
1632         address to,
1633         uint deadline
1634     ) external returns (uint amountA, uint amountB, uint liquidity);
1635     function addLiquidityETH(
1636         address token,
1637         uint amountTokenDesired,
1638         uint amountTokenMin,
1639         uint amountETHMin,
1640         address to,
1641         uint deadline
1642     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1643     function removeLiquidity(
1644         address tokenA,
1645         address tokenB,
1646         uint liquidity,
1647         uint amountAMin,
1648         uint amountBMin,
1649         address to,
1650         uint deadline
1651     ) external returns (uint amountA, uint amountB);
1652     function removeLiquidityETH(
1653         address token,
1654         uint liquidity,
1655         uint amountTokenMin,
1656         uint amountETHMin,
1657         address to,
1658         uint deadline
1659     ) external returns (uint amountToken, uint amountETH);
1660     function removeLiquidityWithPermit(
1661         address tokenA,
1662         address tokenB,
1663         uint liquidity,
1664         uint amountAMin,
1665         uint amountBMin,
1666         address to,
1667         uint deadline,
1668         bool approveMax, uint8 v, bytes32 r, bytes32 s
1669     ) external returns (uint amountA, uint amountB);
1670     function removeLiquidityETHWithPermit(
1671         address token,
1672         uint liquidity,
1673         uint amountTokenMin,
1674         uint amountETHMin,
1675         address to,
1676         uint deadline,
1677         bool approveMax, uint8 v, bytes32 r, bytes32 s
1678     ) external returns (uint amountToken, uint amountETH);
1679     function swapExactTokensForTokens(
1680         uint amountIn,
1681         uint amountOutMin,
1682         address[] calldata path,
1683         address to,
1684         uint deadline
1685     ) external returns (uint[] memory amounts);
1686     function swapTokensForExactTokens(
1687         uint amountOut,
1688         uint amountInMax,
1689         address[] calldata path,
1690         address to,
1691         uint deadline
1692     ) external returns (uint[] memory amounts);
1693     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1694         external
1695         payable
1696         returns (uint[] memory amounts);
1697     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1698         external
1699         returns (uint[] memory amounts);
1700     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1701         external
1702         returns (uint[] memory amounts);
1703     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1704         external
1705         payable
1706         returns (uint[] memory amounts);
1707 
1708     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1709     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1710     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1711     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1712     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1713 }
1714 
1715 interface IUniswapV2Router02 is IUniswapV2Router01 {
1716     function removeLiquidityETHSupportingFeeOnTransferTokens(
1717         address token,
1718         uint liquidity,
1719         uint amountTokenMin,
1720         uint amountETHMin,
1721         address to,
1722         uint deadline
1723     ) external returns (uint amountETH);
1724     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1725         address token,
1726         uint liquidity,
1727         uint amountTokenMin,
1728         uint amountETHMin,
1729         address to,
1730         uint deadline,
1731         bool approveMax, uint8 v, bytes32 r, bytes32 s
1732     ) external returns (uint amountETH);
1733 
1734     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1735         uint amountIn,
1736         uint amountOutMin,
1737         address[] calldata path,
1738         address to,
1739         uint deadline
1740     ) external;
1741     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1742         uint amountOutMin,
1743         address[] calldata path,
1744         address to,
1745         uint deadline
1746     ) external payable;
1747     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1748         uint amountIn,
1749         uint amountOutMin,
1750         address[] calldata path,
1751         address to,
1752         uint deadline
1753     ) external;
1754 }
1755 
1756 contract MEERKATNFTS is ERC721Enumerable, Ownable {
1757     using Strings for uint256;
1758     using SafeMath for uint256;
1759     using Counters for Counters.Counter;
1760 
1761     // Constants
1762     string public baseExtension = ".json";
1763     uint256 public cost = 0.00001 ether;
1764 
1765     // Supply
1766     uint256 public mintReward = 5; //20%
1767     uint256 private creatorReward = 10;
1768     uint256 private devReward = 10;
1769     uint256 public maxSupply = 500;
1770     uint256 public lastSupply = maxSupply;
1771     uint256 public maxMintAmount = 10;
1772 
1773     // Reflection
1774     uint256 public reflectionBalance;
1775     uint256 public totalDividend;
1776 
1777     // Lists
1778     uint256[500] public remainingIds;
1779     mapping(uint256 => uint256) public lastDividendAt;
1780     mapping(uint256 => address) public minters;
1781 
1782     // Params
1783     bool public paused = false;
1784     bool private paysInTokens = true;
1785     string private _baseTokenURI;
1786     address private _wallet;
1787 
1788     // Addresses
1789     address public DexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1790     address public RewardToken = 0xc2FD70fc04f7D15E63FF230075741957963B2152;
1791     address private TeamReceiver = 0x8486fBCab3531105b7fb86A7C80147f4e098bA46; // Team
1792     address private CreatorReceiver = 0x8486fBCab3531105b7fb86A7C80147f4e098bA46; // Team
1793     address private DevReceiver = 0x8486fBCab3531105b7fb86A7C80147f4e098bA46; //team
1794 
1795     //Contracts
1796     IUniswapV2Router02 public router;
1797     IERC20 public token;
1798 
1799     // Constructor
1800     constructor(
1801         string memory name,
1802         string memory symbol,
1803         string memory baseTokenURI
1804     ) ERC721(name, symbol) {
1805         // Save URI
1806         _baseTokenURI = baseTokenURI;
1807         // Save dev wallet
1808         _wallet = msg.sender;
1809         // Set router
1810         router = IUniswapV2Router02(DexRouter);
1811         // Set token
1812         token = IERC20(RewardToken);
1813     }
1814 
1815     // URI Handling
1816     function _baseURI() internal view virtual override returns (string memory) {
1817         return _baseTokenURI;
1818     }
1819 
1820     // Setters
1821     function setBaseURI(string memory baseURI) external onlyOwner {
1822         _baseTokenURI = baseURI;
1823     }
1824 
1825     function setCost(uint256 _newCost) public onlyOwner {
1826         cost = _newCost;
1827     }
1828 
1829      function setPaysInTokens(bool _state) public onlyOwner {
1830         paysInTokens = _state;
1831     }
1832 
1833     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1834         maxMintAmount = _newmaxMintAmount;
1835     }
1836 
1837     function setBaseExtension(string memory _newBaseExtension)
1838         public
1839         onlyOwner
1840     {
1841         baseExtension = _newBaseExtension;
1842     }
1843 
1844     function pause(bool _state) public onlyOwner {
1845         paused = _state;
1846     }
1847 
1848     function setRewardToken(address _newRewardToken) public onlyOwner {
1849         RewardToken = _newRewardToken;
1850         token = IERC20(RewardToken);
1851     }
1852 
1853     function setDexRouter(address _newDexRouter) public onlyOwner {
1854         DexRouter = _newDexRouter;
1855         router = IUniswapV2Router02(DexRouter);
1856     }
1857 
1858     function setTeamReceiver(address _newTeamReceiver) public onlyOwner {
1859         TeamReceiver = _newTeamReceiver;
1860     }
1861 
1862     function setFees(uint256 _newcreatorReward, uint256 _newdevReward, uint256 _newmintReward) public onlyOwner {
1863         devReward = _newdevReward;
1864         creatorReward = _newcreatorReward;
1865         mintReward = _newmintReward;
1866         require(_newcreatorReward <= 20);
1867         require(_newdevReward <= 20);
1868     }
1869 
1870     // Minting
1871     function mint(uint256 _mintAmount) public payable {
1872         // Checks
1873         require(!paused, "Minting has not started yet");
1874         require(_mintAmount > 0, "You have to mint at least one");
1875         require(
1876             _mintAmount <= maxMintAmount,
1877             "You can only mint 10 at a time"
1878         );
1879         require(
1880             lastSupply >= _mintAmount,
1881             "Sold Out!"
1882         );
1883         if (msg.sender != owner()) {
1884             require(
1885                 msg.value >= cost * _mintAmount,
1886                 "Cost Doesnt Match"
1887             );
1888         }
1889         // Minting
1890         for (uint256 i = 1; i <= _mintAmount; i++) {
1891             // Mint for caller
1892             _randomMint(msg.sender);
1893             // Split cost
1894             handleMintReward(msg.value / _mintAmount);
1895         }
1896     }
1897 
1898     // Give a random NFT to a contest winner
1899     function randomGiveaway(address _winner, uint256 _amount)
1900         external
1901         onlyOwner
1902     {
1903         // Checks
1904         require(_winner != address(0), "Cannot be zero address");
1905         require(_amount > 0, "You have to mint at least one");
1906         require(lastSupply != 0, "Collection is sold out");
1907         // Mint random NFTs for a winner
1908         for (uint256 i = 1; i <= _amount; i++) {
1909             _randomMint(_winner);
1910         }
1911     }
1912 
1913     // Random mint
1914     function _randomMint(address _target) internal returns (uint256) {
1915         // Get Random id to mint
1916         uint256 _index = _getRandom() % lastSupply;
1917         uint256 _realIndex = getValue(_index) + 1;
1918         // Reduce supply
1919         lastSupply--;
1920         // Replace used id by last
1921         remainingIds[_index] = getValue(lastSupply);
1922         // Mint
1923         _safeMint(_target, _realIndex);
1924         // Save Original minters
1925         minters[_realIndex] = msg.sender;
1926         // Save dividend
1927         lastDividendAt[_realIndex] = totalDividend;
1928         return _realIndex;
1929     }
1930 
1931     // Mint for reserved spots
1932     function _regularMint() internal returns (uint256) {
1933         // Get Actual id to mint
1934         uint256 _index = totalSupply();
1935         uint256 _realIndex = getValue(_index) + 1;
1936         // Reduce supply
1937         lastSupply--;
1938         // Replace used id by last
1939         remainingIds[_index] = getValue(lastSupply);
1940         // Mint
1941         _safeMint(msg.sender, _realIndex);
1942         // Save Original minters
1943         minters[_realIndex] = msg.sender;
1944         // Save dividend
1945         lastDividendAt[_realIndex] = totalDividend;
1946         return _realIndex;
1947     }
1948 
1949     // Get Token List
1950     function getTokenIds(address _owner)
1951         public
1952         view
1953         returns (uint256[] memory)
1954     {
1955         // Count owned Token
1956         uint256 ownerTokenCount = balanceOf(_owner);
1957         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1958         // Get ids of owned Token
1959         for (uint256 i; i < ownerTokenCount; i++) {
1960             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1961         }
1962         return tokenIds;
1963     }
1964 
1965     // Return compiled Token URI
1966     function tokenURI(uint256 _id)
1967         public
1968         view
1969         virtual
1970         override
1971         returns (string memory)
1972     {
1973         require(_exists(_id), "URI query for nonexistent token");
1974         string memory currentBaseURI = _baseURI();
1975         return
1976             bytes(currentBaseURI).length > 0
1977                 ? string(
1978                     abi.encodePacked(
1979                         currentBaseURI,
1980                         _id.toString(),
1981                         baseExtension
1982                     )
1983                 )
1984                 : "";
1985     }
1986 
1987     // Payments & Reflections
1988     
1989   function withdraw() public payable onlyOwner {
1990     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1991     require(success);
1992   }
1993   
1994 
1995     // Reflections
1996     function handleMintReward(uint256 _amount) private {
1997         // Split payment
1998         uint256 mintShare = _amount.div(mintReward);
1999         uint256 creatorShare = _amount.div(creatorReward);
2000         uint256 devShare = _amount.div(devReward);
2001         uint256 teamShare = _amount.sub(mintShare).sub(creatorShare).sub(devShare);
2002         
2003         // Save dividend for community
2004         reflectDividend(mintShare);
2005         // Send owner share
2006         payable(TeamReceiver).transfer(teamShare);
2007         payable(CreatorReceiver).transfer(creatorShare);
2008         payable(DevReceiver).transfer(devShare);
2009     }
2010 
2011     // Add dividend
2012     function reflectDividend(uint256 _amount) private {
2013         reflectionBalance = reflectionBalance.add(_amount);
2014         totalDividend = totalDividend.add((_amount.div(totalSupply())));
2015     }
2016 
2017     function reflectToOwners() public payable {
2018         reflectDividend(msg.value);
2019     }
2020 
2021     function getReflectionBalances(address _owner)
2022         public
2023         view
2024         returns (uint256)
2025     {
2026         uint256 count = balanceOf(_owner);
2027         uint256 total = 0;
2028         for (uint256 i = 0; i < count; i++) {
2029             uint256 tokenId = tokenOfOwnerByIndex(_owner, i);
2030             total = total.add(getReflectionBalance(tokenId));
2031         }
2032         return total;
2033     }
2034 
2035     function getReflectionBalance(uint256 tokenId)
2036         public
2037         view
2038         returns (uint256)
2039     {
2040         return totalDividend.sub(lastDividendAt[tokenId]);
2041     }
2042 
2043     function claimRewards() public {
2044         require(!paysInTokens, "Rewards are paid in tokens");
2045         uint256 count = balanceOf(msg.sender);
2046         uint256 balance = 0;
2047         for (uint256 i = 0; i < count; i++) {
2048             uint256 tokenId = tokenOfOwnerByIndex(msg.sender, i);
2049             balance = balance.add(getReflectionBalance(tokenId));
2050             lastDividendAt[tokenId] = totalDividend;
2051         }
2052         payable(msg.sender).transfer(balance);
2053     }
2054 
2055     function claimRewardsTokens() public {
2056         uint256 count = balanceOf(msg.sender);
2057         uint256 initialBalanceOf = token.balanceOf(address(this));
2058         uint256 balance = 0;
2059         for (uint256 i = 0; i < count; i++) {
2060             uint256 tokenId = tokenOfOwnerByIndex(msg.sender, i);
2061             balance = balance.add(getReflectionBalance(tokenId));
2062             lastDividendAt[tokenId] = totalDividend;
2063         }
2064         // Covert Balance to Tokens
2065         address[] memory path = new address[](2);
2066         path[0] = router.WETH();
2067         path[1] = RewardToken;
2068 
2069         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : balance}(
2070             0,
2071             path,
2072             address(this),
2073             block.timestamp
2074         );
2075 
2076         uint256 finalBalanceOf = token.balanceOf(address(this));
2077         uint256 tokens = finalBalanceOf.sub(initialBalanceOf);
2078         token.transfer(msg.sender, tokens);
2079     }
2080     // Utils
2081 
2082     // Get value from a remaining id node
2083     function getValue(uint256 _index) internal view returns (uint256) {
2084         if (remainingIds[_index] != 0) return remainingIds[_index];
2085         else return _index;
2086     }
2087 
2088     // Create a random id for minting
2089     function _getRandom() internal view returns (uint256) {
2090         return
2091             uint256(
2092                 keccak256(
2093                     abi.encodePacked(
2094                         block.difficulty,
2095                         block.timestamp,
2096                         lastSupply
2097                     )
2098                 )
2099             );
2100     }
2101 }