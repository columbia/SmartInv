1 /*
2  __      __            .__       .___         _____                                     
3 /  \    /  \___________|  |    __| _/   _____/ ____\                                    
4 \   \/\/   /  _ \_  __ \  |   / __ |   /  _ \   __\                                     
5  \        (  <_> )  | \/  |__/ /_/ |  (  <_> )  |                                       
6   \__/\  / \____/|__|  |____/\____ |   \____/|__|                                       
7        \/                         \/                                                    
8       __      __.__    .__  __           ________            .___             
9       /  \    /  \  |__ |__|/  |_  ____   \______ \  __ __  __| _/____   ______
10       \   \/\/   /  |  \|  \   __\/ __ \   |    |  \|  |  \/ __ |/ __ \ /  ___/
11       \        /|   Y  \  ||  | \  ___/   |    `   \  |  / /_/ \  ___/ \___ \ 
12         \__/\  / |___|  /__||__|  \___  > /_______  /____/\____ |\___  >____  >
13             \/       \/              \/          \/           \/    \/     \/ 
14 
15          ___---___                    
16       .--         --.      
17     ./   ()     .-.  \.
18   /   o    .   (   )   \
19  | .            '-'     |
20  |   o .-..      ()     |
21  |    `.__.'    o   .   |
22   \                     /    
23   `\    o    ()       /'       _            _
24       `--___   ___--'           \   ____   /
25             ---                  \_( ツ )_/                                     
26 
27                                                    ____
28                                               .-'""p 8o""`-.
29                                            .-'8888P'Y.`Y[ ' `-.
30                                          ,']88888b.J8oo_      '`.
31                                        ,' ,88888888888["        Y`.
32                                       /   8888888888P            Y8\
33                                      /    Y8888888P'             ]88\
34                                     :     `Y88'   P              `888:
35                                     :       Y8.oP '- >            Y88:
36                                     |          `Yb  __             `'|
37                                     :            `'d8888bo.          :
38                                     :             d88888888ooo.      ;
39                                      \            Y88888888888P     /
40                                       \            `Y88888888P     /
41                                        `.            d88888P'    ,'
42                                          `.          888PP'    ,'
43                                            `-.      d8P'    ,-'   
44                                               `-.,,_'__,,.-'
45 
46 
47 */
48 // SPDX-License-Identifier: MIT
49 pragma solidity ^0.8.8;
50 
51 /**
52  * @dev Collection of functions related to the address type
53  */
54 library Address {
55     /**
56      * @dev Returns true if `account` is a contract.
57      *
58      * [IMPORTANT]
59      * ====
60      * It is unsafe to assume that an address for which this function returns
61      * false is an externally-owned account (EOA) and not a contract.
62      *
63      * Among others, `isContract` will return false for the following
64      * types of addresses:
65      *
66      *  - an externally-owned account
67      *  - a contract in construction
68      *  - an address where a contract will be created
69      *  - an address where a contract lived, but was destroyed
70      * ====
71      */
72     function isContract(address account) internal view returns (bool) {
73         // This method relies on extcodesize, which returns 0 for contracts in
74         // construction, since the code is only stored at the end of the
75         // constructor execution.
76 
77         uint256 size;
78         assembly {
79             size := extcodesize(account)
80         }
81         return size > 0;
82     }
83 
84     /**
85      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
86      * `recipient`, forwarding all available gas and reverting on errors.
87      *
88      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
89      * of certain opcodes, possibly making contracts go over the 2300 gas limit
90      * imposed by `transfer`, making them unable to receive funds via
91      * `transfer`. {sendValue} removes this limitation.
92      *
93      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
94      *
95      * IMPORTANT: because control is transferred to `recipient`, care must be
96      * taken to not create reentrancy vulnerabilities. Consider using
97      * {ReentrancyGuard} or the
98      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
99      */
100     function sendValue(address payable recipient, uint256 amount) internal {
101         require(
102             address(this).balance >= amount,
103             "Address: insufficient balance"
104         );
105 
106         (bool success, ) = recipient.call{value: amount}("");
107         require(
108             success,
109             "Address: unable to send value, recipient may have reverted"
110         );
111     }
112 
113     /**
114      * @dev Performs a Solidity function call using a low level `call`. A
115      * plain `call` is an unsafe replacement for a function call: use this
116      * function instead.
117      *
118      * If `target` reverts with a revert reason, it is bubbled up by this
119      * function (like regular Solidity function calls).
120      *
121      * Returns the raw returned data. To convert to the expected return value,
122      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
123      *
124      * Requirements:
125      *
126      * - `target` must be a contract.
127      * - calling `target` with `data` must not revert.
128      *
129      * _Available since v3.1._
130      */
131     function functionCall(address target, bytes memory data)
132         internal
133         returns (bytes memory)
134     {
135         return functionCall(target, data, "Address: low-level call failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
140      * `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCall(
145         address target,
146         bytes memory data,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         return functionCallWithValue(target, data, 0, errorMessage);
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
154      * but also transferring `value` wei to `target`.
155      *
156      * Requirements:
157      *
158      * - the calling contract must have an ETH balance of at least `value`.
159      * - the called Solidity function must be `payable`.
160      *
161      * _Available since v3.1._
162      */
163     function functionCallWithValue(
164         address target,
165         bytes memory data,
166         uint256 value
167     ) internal returns (bytes memory) {
168         return
169             functionCallWithValue(
170                 target,
171                 data,
172                 value,
173                 "Address: low-level call with value failed"
174             );
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
179      * with `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         require(
190             address(this).balance >= value,
191             "Address: insufficient balance for call"
192         );
193         require(isContract(target), "Address: call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.call{value: value}(
196             data
197         );
198         return _verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but performing a static call.
204      *
205      * _Available since v3.3._
206      */
207     function functionStaticCall(address target, bytes memory data)
208         internal
209         view
210         returns (bytes memory)
211     {
212         return
213             functionStaticCall(
214                 target,
215                 data,
216                 "Address: low-level static call failed"
217             );
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(
227         address target,
228         bytes memory data,
229         string memory errorMessage
230     ) internal view returns (bytes memory) {
231         require(isContract(target), "Address: static call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.staticcall(data);
234         return _verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(address target, bytes memory data)
244         internal
245         returns (bytes memory)
246     {
247         return
248             functionDelegateCall(
249                 target,
250                 data,
251                 "Address: low-level delegate call failed"
252             );
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(isContract(target), "Address: delegate call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.delegatecall(data);
269         return _verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     function _verifyCallResult(
273         bool success,
274         bytes memory returndata,
275         string memory errorMessage
276     ) private pure returns (bytes memory) {
277         if (success) {
278             return returndata;
279         } else {
280             // Look for revert reason and bubble it up if present
281             if (returndata.length > 0) {
282                 // The easiest way to bubble the revert reason is using memory via assembly
283 
284                 assembly {
285                     let returndata_size := mload(returndata)
286                     revert(add(32, returndata), returndata_size)
287                 }
288             } else {
289                 revert(errorMessage);
290             }
291         }
292     }
293 }
294 
295 /**
296  * @dev String operations.
297  */
298 library Strings {
299     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
300 
301     /**
302      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
303      */
304     function toString(uint256 value) internal pure returns (string memory) {
305         // Inspired by OraclizeAPI's implementation - MIT licence
306         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
307 
308         if (value == 0) {
309             return "0";
310         }
311         uint256 temp = value;
312         uint256 digits;
313         while (temp != 0) {
314             digits++;
315             temp /= 10;
316         }
317         bytes memory buffer = new bytes(digits);
318         while (value != 0) {
319             digits -= 1;
320             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
321             value /= 10;
322         }
323         return string(buffer);
324     }
325 
326     /**
327      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
328      */
329     function toHexString(uint256 value) internal pure returns (string memory) {
330         if (value == 0) {
331             return "0x00";
332         }
333         uint256 temp = value;
334         uint256 length = 0;
335         while (temp != 0) {
336             length++;
337             temp >>= 8;
338         }
339         return toHexString(value, length);
340     }
341 
342     /**
343      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
344      */
345     function toHexString(uint256 value, uint256 length)
346         internal
347         pure
348         returns (string memory)
349     {
350         bytes memory buffer = new bytes(2 * length + 2);
351         buffer[0] = "0";
352         buffer[1] = "x";
353         for (uint256 i = 2 * length + 1; i > 1; --i) {
354             buffer[i] = _HEX_SYMBOLS[value & 0xf];
355             value >>= 4;
356         }
357         require(value == 0, "Strings: hex length insufficient");
358         return string(buffer);
359     }
360 }
361 
362 abstract contract Context {
363     function _msgSender() internal view virtual returns (address) {
364         return msg.sender;
365     }
366 
367     function _msgData() internal view virtual returns (bytes calldata) {
368         return msg.data;
369     }
370 }
371 
372 abstract contract Ownable is Context {
373     address private _owner;
374 
375     event OwnershipTransferred(
376         address indexed previousOwner,
377         address indexed newOwner
378     );
379 
380     /**
381      * @dev Initializes the contract setting the deployer as the initial owner.
382      */
383     constructor() {
384         _setOwner(_msgSender());
385     }
386 
387     /**
388      * @dev Returns the address of the current owner.
389      */
390     function owner() public view virtual returns (address) {
391         return _owner;
392     }
393 
394     /**
395      * @dev Throws if called by any account other than the owner.
396      */
397     modifier onlyOwner() {
398         require(owner() == _msgSender(), "Ownable: caller is not the owner");
399         _;
400     }
401 
402     /**
403      * @dev Leaves the contract without owner. It will not be possible to call
404      * `onlyOwner` functions anymore. Can only be called by the current owner.
405      *
406      * NOTE: Renouncing ownership will leave the contract without an owner,
407      * thereby removing any functionality that is only available to the owner.
408      */
409     function renounceOwnership() public virtual onlyOwner {
410         _setOwner(address(0));
411     }
412 
413     /**
414      * @dev Transfers ownership of the contract to a new account (`newOwner`).
415      * Can only be called by the current owner.
416      */
417     function transferOwnership(address newOwner) public virtual onlyOwner {
418         require(
419             newOwner != address(0),
420             "Ownable: new owner is the zero address"
421         );
422         _setOwner(newOwner);
423     }
424 
425     function _setOwner(address newOwner) private {
426         address oldOwner = _owner;
427         _owner = newOwner;
428         emit OwnershipTransferred(oldOwner, newOwner);
429     }
430 }
431 
432 /**
433  * @dev Contract module which provides a basic access control mechanism, where
434  * there is an account (an owner) that can be granted exclusive access to
435  * specific functions.
436  *
437  * By default, the owner account will be the one that deploys the contract. This
438  * can later be changed with {transferOwnership}.
439  *
440  * This module is used through inheritance. It will make available the modifier
441  * `onlyOwner`, which can be applied to your functions to restrict their use to
442  * the owner.
443  */
444 
445 /**
446  * @dev Interface of the ERC165 standard, as defined in the
447  * https://eips.ethereum.org/EIPS/eip-165[EIP].
448  *
449  * Implementers can declare support of contract interfaces, which can then be
450  * queried by others ({ERC165Checker}).
451  *
452  * For an implementation, see {ERC165}.
453  */
454 interface IERC165 {
455     /**
456      * @dev Returns true if this contract implements the interface defined by
457      * `interfaceId`. See the corresponding
458      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
459      * to learn more about how these ids are created.
460      *
461      * This function call must use less than 30 000 gas.
462      */
463     function supportsInterface(bytes4 interfaceId) external view returns (bool);
464 }
465 
466 /**
467  * @dev Implementation of the {IERC165} interface.
468  *
469  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
470  * for the additional interface id that will be supported. For example:
471  *
472  * ```solidity
473  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
474  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
475  * }
476  * ```
477  *
478  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
479  */
480 abstract contract ERC165 is IERC165 {
481     /**
482      * @dev See {IERC165-supportsInterface}.
483      */
484     function supportsInterface(bytes4 interfaceId)
485         public
486         view
487         virtual
488         override
489         returns (bool)
490     {
491         return interfaceId == type(IERC165).interfaceId;
492     }
493 }
494 
495 /**
496  * @dev Required interface of an ERC721 compliant contract.
497  */
498 interface IERC721 is IERC165 {
499     /**
500      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
501      */
502     event Transfer(
503         address indexed from,
504         address indexed to,
505         uint256 indexed tokenId
506     );
507 
508     /**
509      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
510      */
511     event Approval(
512         address indexed owner,
513         address indexed approved,
514         uint256 indexed tokenId
515     );
516 
517     /**
518      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
519      */
520     event ApprovalForAll(
521         address indexed owner,
522         address indexed operator,
523         bool approved
524     );
525 
526     /**
527      * @dev Returns the number of tokens in ``owner``'s account.
528      */
529     function balanceOf(address owner) external view returns (uint256 balance);
530 
531     /**
532      * @dev Returns the owner of the `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function ownerOf(uint256 tokenId) external view returns (address owner);
539 
540     /**
541      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
542      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must exist and be owned by `from`.
549      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId
558     ) external;
559 
560     /**
561      * @dev Transfers `tokenId` token from `from` to `to`.
562      *
563      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must be owned by `from`.
570      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
571      *
572      * Emits a {Transfer} event.
573      */
574     function transferFrom(
575         address from,
576         address to,
577         uint256 tokenId
578     ) external;
579 
580     /**
581      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
582      * The approval is cleared when the token is transferred.
583      *
584      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
585      *
586      * Requirements:
587      *
588      * - The caller must own the token or be an approved operator.
589      * - `tokenId` must exist.
590      *
591      * Emits an {Approval} event.
592      */
593     function approve(address to, uint256 tokenId) external;
594 
595     /**
596      * @dev Returns the account approved for `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function getApproved(uint256 tokenId)
603         external
604         view
605         returns (address operator);
606 
607     /**
608      * @dev Approve or remove `operator` as an operator for the caller.
609      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
610      *
611      * Requirements:
612      *
613      * - The `operator` cannot be the caller.
614      *
615      * Emits an {ApprovalForAll} event.
616      */
617     function setApprovalForAll(address operator, bool _approved) external;
618 
619     /**
620      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
621      *
622      * See {setApprovalForAll}
623      */
624     function isApprovedForAll(address owner, address operator)
625         external
626         view
627         returns (bool);
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`.
631      *
632      * Requirements:
633      *
634      * - `from` cannot be the zero address.
635      * - `to` cannot be the zero address.
636      * - `tokenId` token must exist and be owned by `from`.
637      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
639      *
640      * Emits a {Transfer} event.
641      */
642     function safeTransferFrom(
643         address from,
644         address to,
645         uint256 tokenId,
646         bytes calldata data
647     ) external;
648 }
649 
650 /**
651  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
652  * @dev See https://eips.ethereum.org/EIPS/eip-721
653  */
654 interface IERC721Enumerable is IERC721 {
655     /**
656      * @dev Returns the total amount of tokens stored by the contract.
657      */
658     function totalSupply() external view returns (uint256);
659 
660     /**
661      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
662      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
663      */
664     function tokenOfOwnerByIndex(address owner, uint256 index)
665         external
666         view
667         returns (uint256 tokenId);
668 
669     /**
670      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
671      * Use along with {totalSupply} to enumerate all tokens.
672      */
673     function tokenByIndex(uint256 index) external view returns (uint256);
674 }
675 
676 /**
677  * @title ERC721 token receiver interface
678  * @dev Interface for any contract that wants to support safeTransfers
679  * from ERC721 asset contracts.
680  */
681 interface IERC721Receiver {
682     /**
683      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
684      * by `operator` from `from`, this function is called.
685      *
686      * It must return its Solidity selector to confirm the token transfer.
687      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
688      *
689      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
690      */
691     function onERC721Received(
692         address operator,
693         address from,
694         uint256 tokenId,
695         bytes calldata data
696     ) external returns (bytes4);
697 }
698 
699 /**
700  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
701  * @dev See https://eips.ethereum.org/EIPS/eip-721
702  */
703 interface IERC721Metadata is IERC721 {
704     /**
705      * @dev Returns the token collection name.
706      */
707     function name() external view returns (string memory);
708 
709     /**
710      * @dev Returns the token collection symbol.
711      */
712     function symbol() external view returns (string memory);
713 
714     /**
715      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
716      */
717     function tokenURI(uint256 tokenId) external view returns (string memory);
718 }
719 
720 /**
721  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
722  * the Metadata extension, but not including the Enumerable extension, which is available separately as
723  * {ERC721Enumerable}.
724  */
725 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
726     using Address for address;
727     using Strings for uint256;
728 
729     // Token name
730     string private _name;
731 
732     // Token symbol
733     string private _symbol;
734 
735     // Mapping from token ID to owner address
736     mapping(uint256 => address) private _owners;
737 
738     // Mapping owner address to token count
739     mapping(address => uint256) private _balances;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     /**
748      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
749      */
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753     }
754 
755     /**
756      * @dev See {IERC165-supportsInterface}.
757      */
758     function supportsInterface(bytes4 interfaceId)
759         public
760         view
761         virtual
762         override(ERC165, IERC165)
763         returns (bool)
764     {
765         return
766             interfaceId == type(IERC721).interfaceId ||
767             interfaceId == type(IERC721Metadata).interfaceId ||
768             super.supportsInterface(interfaceId);
769     }
770 
771     /**
772      * @dev See {IERC721-balanceOf}.
773      */
774     function balanceOf(address owner)
775         public
776         view
777         virtual
778         override
779         returns (uint256)
780     {
781         require(
782             owner != address(0),
783             "ERC721: balance query for the zero address"
784         );
785         return _balances[owner];
786     }
787 
788     /**
789      * @dev See {IERC721-ownerOf}.
790      */
791     function ownerOf(uint256 tokenId)
792         public
793         view
794         virtual
795         override
796         returns (address)
797     {
798         address owner = _owners[tokenId];
799         require(
800             owner != address(0),
801             "ERC721: owner query for nonexistent token"
802         );
803         return owner;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-name}.
808      */
809     function name() public view virtual override returns (string memory) {
810         return _name;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-symbol}.
815      */
816     function symbol() public view virtual override returns (string memory) {
817         return _symbol;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-tokenURI}.
822      */
823     function tokenURI(uint256 tokenId)
824         public
825         view
826         virtual
827         override
828         returns (string memory)
829     {
830         require(
831             _exists(tokenId),
832             "ERC721Metadata: URI query for nonexistent token"
833         );
834 
835         string memory baseURI = _baseURI();
836         return
837             bytes(baseURI).length > 0
838                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
839                 : "";
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, can be overriden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return "";
849     }
850 
851     /**
852      * @dev See {IERC721-approve}.
853      */
854     function approve(address to, uint256 tokenId) public virtual override {
855         address owner = ERC721.ownerOf(tokenId);
856         require(to != owner, "ERC721: approval to current owner");
857 
858         require(
859             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
860             "ERC721: approve caller is not owner nor approved for all"
861         );
862 
863         _approve(to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-getApproved}.
868      */
869     function getApproved(uint256 tokenId)
870         public
871         view
872         virtual
873         override
874         returns (address)
875     {
876         require(
877             _exists(tokenId),
878             "ERC721: approved query for nonexistent token"
879         );
880 
881         return _tokenApprovals[tokenId];
882     }
883 
884     /**
885      * @dev See {IERC721-setApprovalForAll}.
886      */
887     function setApprovalForAll(address operator, bool approved)
888         public
889         virtual
890         override
891     {
892         require(operator != _msgSender(), "ERC721: approve to caller");
893 
894         _operatorApprovals[_msgSender()][operator] = approved;
895         emit ApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     /**
899      * @dev See {IERC721-isApprovedForAll}.
900      */
901     function isApprovedForAll(address owner, address operator)
902         public
903         view
904         virtual
905         override
906         returns (bool)
907     {
908         return _operatorApprovals[owner][operator];
909     }
910 
911     /**
912      * @dev See {IERC721-transferFrom}.
913      */
914     function transferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public virtual override {
919         //solhint-disable-next-line max-line-length
920         require(
921             _isApprovedOrOwner(_msgSender(), tokenId),
922             "ERC721: transfer caller is not owner nor approved"
923         );
924 
925         _transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public virtual override {
936         safeTransferFrom(from, to, tokenId, "");
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) public virtual override {
948         require(
949             _isApprovedOrOwner(_msgSender(), tokenId),
950             "ERC721: transfer caller is not owner nor approved"
951         );
952         _safeTransfer(from, to, tokenId, _data);
953     }
954 
955     /**
956      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
957      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
958      *
959      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
960      *
961      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
962      * implement alternative mechanisms to perform token transfer, such as signature-based.
963      *
964      * Requirements:
965      *
966      * - `from` cannot be the zero address.
967      * - `to` cannot be the zero address.
968      * - `tokenId` token must exist and be owned by `from`.
969      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _safeTransfer(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) internal virtual {
979         _transfer(from, to, tokenId);
980         require(
981             _checkOnERC721Received(from, to, tokenId, _data),
982             "ERC721: transfer to non ERC721Receiver implementer"
983         );
984     }
985 
986     /**
987      * @dev Returns whether `tokenId` exists.
988      *
989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
990      *
991      * Tokens start existing when they are minted (`_mint`),
992      * and stop existing when they are burned (`_burn`).
993      */
994     function _exists(uint256 tokenId) internal view virtual returns (bool) {
995         return _owners[tokenId] != address(0);
996     }
997 
998     /**
999      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      */
1005     function _isApprovedOrOwner(address spender, uint256 tokenId)
1006         internal
1007         view
1008         virtual
1009         returns (bool)
1010     {
1011         require(
1012             _exists(tokenId),
1013             "ERC721: operator query for nonexistent token"
1014         );
1015         address owner = ERC721.ownerOf(tokenId);
1016         return (spender == owner ||
1017             getApproved(tokenId) == spender ||
1018             isApprovedForAll(owner, spender));
1019     }
1020 
1021     /**
1022      * @dev Safely mints `tokenId` and transfers it to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _safeMint(address to, uint256 tokenId) internal virtual {
1032         _safeMint(to, tokenId, "");
1033     }
1034 
1035     /**
1036      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1037      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1038      */
1039     function _safeMint(
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) internal virtual {
1044         _mint(to, tokenId);
1045         require(
1046             _checkOnERC721Received(address(0), to, tokenId, _data),
1047             "ERC721: transfer to non ERC721Receiver implementer"
1048         );
1049     }
1050 
1051     /**
1052      * @dev Mints `tokenId` and transfers it to `to`.
1053      *
1054      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must not exist.
1059      * - `to` cannot be the zero address.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _mint(address to, uint256 tokenId) internal virtual {
1064         require(to != address(0), "ERC721: mint to the zero address");
1065         require(!_exists(tokenId), "ERC721: token already minted");
1066 
1067         _beforeTokenTransfer(address(0), to, tokenId);
1068 
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(address(0), to, tokenId);
1073     }
1074     function _cheapmint(address to, uint256 tokenId) internal virtual {
1075         _beforeTokenTransfer(address(0), to, tokenId);
1076         _balances[to] += 1;
1077         _owners[tokenId] = to;
1078         emit Transfer(address(0), to, tokenId);
1079     }
1080     /**
1081      * @dev Destroys `tokenId`.
1082      * The approval is cleared when the token is burned.
1083      *
1084      * Requirements:
1085      *
1086      * - `tokenId` must exist.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _burn(uint256 tokenId) internal virtual {
1091         address owner = ERC721.ownerOf(tokenId);
1092 
1093         _beforeTokenTransfer(owner, address(0), tokenId);
1094 
1095         // Clear approvals
1096         _approve(address(0), tokenId);
1097 
1098         _balances[owner] -= 1;
1099         delete _owners[tokenId];
1100 
1101         emit Transfer(owner, address(0), tokenId);
1102     }
1103 
1104     /**
1105      * @dev Transfers `tokenId` from `from` to `to`.
1106      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1107      *
1108      * Requirements:
1109      *
1110      * - `to` cannot be the zero address.
1111      * - `tokenId` token must be owned by `from`.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _transfer(
1116         address from,
1117         address to,
1118         uint256 tokenId
1119     ) internal virtual {
1120         require(
1121             ERC721.ownerOf(tokenId) == from,
1122             "ERC721: transfer of token that is not own"
1123         );
1124         require(to != address(0), "ERC721: transfer to the zero address");
1125 
1126         _beforeTokenTransfer(from, to, tokenId);
1127 
1128         // Clear approvals from the previous owner
1129         _approve(address(0), tokenId);
1130 
1131         _balances[from] -= 1;
1132         _balances[to] += 1;
1133         _owners[tokenId] = to;
1134 
1135         emit Transfer(from, to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Approve `to` to operate on `tokenId`
1140      *
1141      * Emits a {Approval} event.
1142      */
1143     function _approve(address to, uint256 tokenId) internal virtual {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1150      * The call is not executed if the target address is not a contract.
1151      *
1152      * @param from address representing the previous owner of the given token ID
1153      * @param to target address that will receive the tokens
1154      * @param tokenId uint256 ID of the token to be transferred
1155      * @param _data bytes optional data to send along with the call
1156      * @return bool whether the call correctly returned the expected magic value
1157      */
1158     function _checkOnERC721Received(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes memory _data
1163     ) private returns (bool) {
1164         if (to.isContract()) {
1165             try
1166                 IERC721Receiver(to).onERC721Received(
1167                     _msgSender(),
1168                     from,
1169                     tokenId,
1170                     _data
1171                 )
1172             returns (bytes4 retval) {
1173                 return retval == IERC721Receiver(to).onERC721Received.selector;
1174             } catch (bytes memory reason) {
1175                 if (reason.length == 0) {
1176                     revert(
1177                         "ERC721: transfer to non ERC721Receiver implementer"
1178                     );
1179                 } else {
1180                     assembly {
1181                         revert(add(32, reason), mload(reason))
1182                     }
1183                 }
1184             }
1185         } else {
1186             return true;
1187         }
1188     }
1189 
1190     /**
1191      * @dev Hook that is called before any token transfer. This includes minting
1192      * and burning.
1193      *
1194      * Calling conditions:
1195      *
1196      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1197      * transferred to `to`.
1198      * - When `from` is zero, `tokenId` will be minted for `to`.
1199      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1200      * - `from` and `to` are never both zero.
1201      *
1202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1203      */
1204     function _beforeTokenTransfer(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) internal virtual {}
1209 }
1210 
1211 /**
1212  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1213  * enumerability of all the token ids in the contract as well as all token ids owned by each
1214  * account.
1215  */
1216 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1217     // Mapping from owner to list of owned token IDs
1218     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1219 
1220     // Mapping from token ID to index of the owner tokens list
1221     mapping(uint256 => uint256) private _ownedTokensIndex;
1222 
1223     // Array with all token ids, used for enumeration
1224     uint256[] private _allTokens;
1225 
1226     // Mapping from token id to position in the allTokens array
1227     mapping(uint256 => uint256) private _allTokensIndex;
1228 
1229     /**
1230      * @dev See {IERC165-supportsInterface}.
1231      */
1232     function supportsInterface(bytes4 interfaceId)
1233         public
1234         view
1235         virtual
1236         override(IERC165, ERC721)
1237         returns (bool)
1238     {
1239         return
1240             interfaceId == type(IERC721Enumerable).interfaceId ||
1241             super.supportsInterface(interfaceId);
1242     }
1243 
1244     /**
1245      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1246      */
1247     function tokenOfOwnerByIndex(address owner, uint256 index)
1248         public
1249         view
1250         virtual
1251         override
1252         returns (uint256)
1253     {
1254         require(
1255             index < ERC721.balanceOf(owner),
1256             "ERC721Enumerable: owner index out of bounds"
1257         );
1258         return _ownedTokens[owner][index];
1259     }
1260 
1261     /**
1262      * @dev See {IERC721Enumerable-totalSupply}.
1263      */
1264     function totalSupply() public view virtual override returns (uint256) {
1265         return _allTokens.length;
1266     }
1267 
1268     /**
1269      * @dev See {IERC721Enumerable-tokenByIndex}.
1270      */
1271     function tokenByIndex(uint256 index)
1272         public
1273         view
1274         virtual
1275         override
1276         returns (uint256)
1277     {
1278         require(
1279             index < ERC721Enumerable.totalSupply(),
1280             "ERC721Enumerable: global index out of bounds"
1281         );
1282         return _allTokens[index];
1283     }
1284 
1285     /**
1286      * @dev Hook that is called before any token transfer. This includes minting
1287      * and burning.
1288      *
1289      * Calling conditions:
1290      *
1291      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1292      * transferred to `to`.
1293      * - When `from` is zero, `tokenId` will be minted for `to`.
1294      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1295      * - `from` cannot be the zero address.
1296      * - `to` cannot be the zero address.
1297      *
1298      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1299      */
1300     function _beforeTokenTransfer(
1301         address from,
1302         address to,
1303         uint256 tokenId
1304     ) internal virtual override {
1305         super._beforeTokenTransfer(from, to, tokenId);
1306 
1307         if (from == address(0)) {
1308             _addTokenToAllTokensEnumeration(tokenId);
1309         } else if (from != to) {
1310             _removeTokenFromOwnerEnumeration(from, tokenId);
1311         }
1312         if (to == address(0)) {
1313             _removeTokenFromAllTokensEnumeration(tokenId);
1314         } else if (to != from) {
1315             _addTokenToOwnerEnumeration(to, tokenId);
1316         }
1317     }
1318 
1319     /**
1320      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1321      * @param to address representing the new owner of the given token ID
1322      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1323      */
1324     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1325         uint256 length = ERC721.balanceOf(to);
1326         _ownedTokens[to][length] = tokenId;
1327         _ownedTokensIndex[tokenId] = length;
1328     }
1329 
1330     /**
1331      * @dev Private function to add a token to this extension's token tracking data structures.
1332      * @param tokenId uint256 ID of the token to be added to the tokens list
1333      */
1334     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1335         _allTokensIndex[tokenId] = _allTokens.length;
1336         _allTokens.push(tokenId);
1337     }
1338 
1339     /**
1340      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1341      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1342      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1343      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1344      * @param from address representing the previous owner of the given token ID
1345      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1346      */
1347     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1348         private
1349     {
1350         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1351         // then delete the last slot (swap and pop).
1352 
1353         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1354         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1355 
1356         // When the token to delete is the last token, the swap operation is unnecessary
1357         if (tokenIndex != lastTokenIndex) {
1358             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1359 
1360             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1361             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1362         }
1363 
1364         // This also deletes the contents at the last position of the array
1365         delete _ownedTokensIndex[tokenId];
1366         delete _ownedTokens[from][lastTokenIndex];
1367     }
1368 
1369     /**
1370      * @dev Private function to remove a token from this extension's token tracking data structures.
1371      * This has O(1) time complexity, but alters the order of the _allTokens array.
1372      * @param tokenId uint256 ID of the token to be removed from the tokens list
1373      */
1374     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1375         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1376         // then delete the last slot (swap and pop).
1377 
1378         uint256 lastTokenIndex = _allTokens.length - 1;
1379         uint256 tokenIndex = _allTokensIndex[tokenId];
1380 
1381         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1382         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1383         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1384         uint256 lastTokenId = _allTokens[lastTokenIndex];
1385 
1386         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1387         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1388 
1389         // This also deletes the contents at the last position of the array
1390         delete _allTokensIndex[tokenId];
1391         _allTokens.pop();
1392     }
1393 }
1394 
1395 contract WorldOfWhiteDudes is ERC721, ERC721Enumerable, Ownable {
1396     uint256 public constant maxSupply = 10000;
1397     uint256 private _price = 0.085 ether;
1398     uint256 private _reserved = 250;
1399 
1400     uint256 public startingIndex;
1401 
1402     bool private _saleStarted;
1403     string public baseURI = "ipfs://QmXE4y9AwsmqJkaw4L1cvi21gn8AQ1XeSroBwc6ExaviXN/";
1404 
1405     address t1 = 0xA0e532440fe6F5B8F5AFAE2d72ACC1f90c1fCE0D;
1406 
1407     constructor() ERC721("World Of White Dudes", "WOWD") {
1408         _saleStarted = false;
1409     }
1410 
1411     modifier whenSaleStarted() {
1412         require(_saleStarted);
1413         _;
1414     }
1415 
1416     function mintOne() external payable whenSaleStarted {
1417         uint256 supply = totalSupply();
1418         require(
1419             msg.value >= _price && supply < (maxSupply - _reserved),
1420             "Not enough Money or Tokens left."
1421         );
1422         _safeMint(msg.sender, supply);
1423     }
1424 
1425     function mintTen() external payable whenSaleStarted {
1426         uint256 supply = totalSupply();
1427         require(
1428             msg.value >= (_price * 10) &&
1429                 (supply + 10) <= (maxSupply - _reserved),
1430             "Not enough Money or Tokens left."
1431         );
1432         _safeMint(msg.sender, supply);
1433         _safeMint(msg.sender, supply + 1);
1434         _safeMint(msg.sender, supply + 2);
1435         _safeMint(msg.sender, supply + 3);
1436         _safeMint(msg.sender, supply + 4);
1437         _safeMint(msg.sender, supply + 5);
1438         _safeMint(msg.sender, supply + 6);
1439         _safeMint(msg.sender, supply + 7);
1440         _safeMint(msg.sender, supply + 8);
1441         _safeMint(msg.sender, supply + 9);
1442     }
1443 
1444     function mint(uint256 _nbTokens) external payable whenSaleStarted {
1445         uint256 supply = totalSupply();
1446         require(_nbTokens < 11, "You cannot mint more than 10 Tokens at once!");
1447         require(
1448             supply + _nbTokens <= maxSupply - _reserved,
1449             "Not enough Tokens left."
1450         );
1451         require(_nbTokens * _price <= msg.value, "Inconsistent amount sent!");
1452 
1453         for (uint256 i; i < _nbTokens; i++) {
1454             _safeMint(msg.sender, supply + i);
1455         }
1456     }
1457 
1458     function changeSaleStarted() external onlyOwner {
1459         _saleStarted = !_saleStarted;
1460     }
1461 
1462     function saleStarted() public view returns (bool) {
1463         return _saleStarted;
1464     }
1465 
1466     function setBaseURI(string memory _URI) external onlyOwner {
1467         baseURI = _URI;
1468     }
1469 
1470     function _baseURI() internal view override(ERC721) returns (string memory) {
1471         return baseURI;
1472     }
1473 
1474     // Make it possible to change the price: just in case
1475     function setPrice(uint256 _newPrice) external onlyOwner {
1476         _price = _newPrice;
1477     }
1478 
1479     function getPrice() public view returns (uint256) {
1480         return _price;
1481     }
1482 
1483     function getReservedLeft() public view returns (uint256) {
1484         return _reserved;
1485     }
1486 
1487     function walletOfOwner(address _owner)
1488         public
1489         view
1490         returns (uint256[] memory)
1491     {
1492         uint256 tokenCount = balanceOf(_owner);
1493 
1494         uint256[] memory tokensId = new uint256[](tokenCount);
1495         for (uint256 i; i < tokenCount; i++) {
1496             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1497         }
1498         return tokensId;
1499     }
1500 
1501     function claimReserved(uint256 _number, address _receiver)
1502         external
1503         onlyOwner
1504     {
1505         require(_number <= _reserved, "That would exceed the max reserved.");
1506 
1507         uint256 _tokenId = totalSupply();
1508         for (uint256 i; i < _number; i++) {
1509             _safeMint(_receiver, _tokenId + i);
1510         }
1511 
1512         _reserved = _reserved - _number;
1513     }
1514 
1515 
1516 
1517     function withdraw() public onlyOwner {
1518         uint256 _balance = address(this).balance;
1519         require(payable(t1).send(_balance));
1520     }
1521 
1522     function withdrawTo(address toPay) public onlyOwner {
1523         uint256 _balance = address(this).balance;
1524         require(payable(toPay).send(_balance));
1525     }
1526 
1527     function _beforeTokenTransfer(
1528         address from,
1529         address to,
1530         uint256 tokenId
1531     ) internal override(ERC721, ERC721Enumerable) {
1532         super._beforeTokenTransfer(from, to, tokenId);
1533     }
1534 
1535     function supportsInterface(bytes4 interfaceId)
1536         public
1537         view
1538         override(ERC721, ERC721Enumerable)
1539         returns (bool)
1540     {
1541         return super.supportsInterface(interfaceId);
1542     }
1543 }