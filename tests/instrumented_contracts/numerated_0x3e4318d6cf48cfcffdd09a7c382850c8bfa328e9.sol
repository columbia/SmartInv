1 pragma solidity ^0.8.0;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount)
22         external
23         returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender)
33         external
34         view
35         returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(
81         address indexed owner,
82         address indexed spender,
83         uint256 value
84     );
85 }
86 
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 
104 interface IERC165 {
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30 000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 }
115 
116 interface IERC721 is IERC165 {
117     /**
118      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
119      */
120     event Transfer(
121         address indexed from,
122         address indexed to,
123         uint256 indexed tokenId
124     );
125 
126     /**
127      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
128      */
129     event Approval(
130         address indexed owner,
131         address indexed approved,
132         uint256 indexed tokenId
133     );
134 
135     /**
136      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(
139         address indexed owner,
140         address indexed operator,
141         bool approved
142     );
143 
144     /**
145      * @dev Returns the number of tokens in ``owner``'s account.
146      */
147     function balanceOf(address owner) external view returns (uint256 balance);
148 
149     /**
150      * @dev Returns the owner of the `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function ownerOf(uint256 tokenId) external view returns (address owner);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
160      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId
176     ) external;
177 
178     /**
179      * @dev Transfers `tokenId` token from `from` to `to`.
180      *
181      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must be owned by `from`.
188      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external;
197 
198     /**
199      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
200      * The approval is cleared when the token is transferred.
201      *
202      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
203      *
204      * Requirements:
205      *
206      * - The caller must own the token or be an approved operator.
207      * - `tokenId` must exist.
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address to, uint256 tokenId) external;
212 
213     /**
214      * @dev Returns the account approved for `tokenId` token.
215      *
216      * Requirements:
217      *
218      * - `tokenId` must exist.
219      */
220     function getApproved(uint256 tokenId)
221         external
222         view
223         returns (address operator);
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator)
243         external
244         view
245         returns (bool);
246 
247     /**
248      * @dev Safely transfers `tokenId` token from `from` to `to`.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must exist and be owned by `from`.
255      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
257      *
258      * Emits a {Transfer} event.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId,
264         bytes calldata data
265     ) external;
266 }
267 
268 interface IERC721Metadata is IERC721 {
269     /**
270      * @dev Returns the token collection name.
271      */
272     function name() external view returns (string memory);
273 
274     /**
275      * @dev Returns the token collection symbol.
276      */
277     function symbol() external view returns (string memory);
278 
279     /**
280      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
281      */
282     function tokenURI(uint256 tokenId) external view returns (string memory);
283 }
284 
285 interface IERC721Enumerable is IERC721 {
286     /**
287      * @dev Returns the total amount of tokens stored by the contract.
288      */
289     function totalSupply() external view returns (uint256);
290 
291     /**
292      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
293      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
294      */
295     function tokenOfOwnerByIndex(address owner, uint256 index)
296         external
297         view
298         returns (uint256 tokenId);
299 
300     /**
301      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
302      * Use along with {totalSupply} to enumerate all tokens.
303      */
304     function tokenByIndex(uint256 index) external view returns (uint256);
305 }
306 
307 interface IERC721Receiver {
308     /**
309      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
310      * by `operator` from `from`, this function is called.
311      *
312      * It must return its Solidity selector to confirm the token transfer.
313      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
314      *
315      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
316      */
317     function onERC721Received(
318         address operator,
319         address from,
320         uint256 tokenId,
321         bytes calldata data
322     ) external returns (bytes4);
323 }
324 
325 interface Token is IERC20 {
326     function burn(address account, uint256 amount) external returns (bool);
327 }
328 
329 library Address {
330     /**
331      * @dev Returns true if `account` is a contract.
332      *
333      * [IMPORTANT]
334      * ====
335      * It is unsafe to assume that an address for which this function returns
336      * false is an externally-owned account (EOA) and not a contract.
337      *
338      * Among others, `isContract` will return false for the following
339      * types of addresses:
340      *
341      *  - an externally-owned account
342      *  - a contract in construction
343      *  - an address where a contract will be created
344      *  - an address where a contract lived, but was destroyed
345      * ====
346      */
347     function isContract(address account) internal view returns (bool) {
348         // This method relies on extcodesize, which returns 0 for contracts in
349         // construction, since the code is only stored at the end of the
350         // constructor execution.
351 
352         uint256 size;
353         // solhint-disable-next-line no-inline-assembly
354         assembly {
355             size := extcodesize(account)
356         }
357         return size > 0;
358     }
359 
360     /**
361      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
362      * `recipient`, forwarding all available gas and reverting on errors.
363      *
364      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
365      * of certain opcodes, possibly making contracts go over the 2300 gas limit
366      * imposed by `transfer`, making them unable to receive funds via
367      * `transfer`. {sendValue} removes this limitation.
368      *
369      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
370      *
371      * IMPORTANT: because control is transferred to `recipient`, care must be
372      * taken to not create reentrancy vulnerabilities. Consider using
373      * {ReentrancyGuard} or the
374      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
375      */
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(
378             address(this).balance >= amount,
379             "Address: insufficient balance"
380         );
381 
382         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
383         (bool success, ) = recipient.call{value: amount}("");
384         require(
385             success,
386             "Address: unable to send value, recipient may have reverted"
387         );
388     }
389 
390     /**
391      * @dev Performs a Solidity function call using a low level `call`. A
392      * plain`call` is an unsafe replacement for a function call: use this
393      * function instead.
394      *
395      * If `target` reverts with a revert reason, it is bubbled up by this
396      * function (like regular Solidity function calls).
397      *
398      * Returns the raw returned data. To convert to the expected return value,
399      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
400      *
401      * Requirements:
402      *
403      * - `target` must be a contract.
404      * - calling `target` with `data` must not revert.
405      *
406      * _Available since v3.1._
407      */
408     function functionCall(address target, bytes memory data)
409         internal
410         returns (bytes memory)
411     {
412         return functionCall(target, data, "Address: low-level call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
417      * `errorMessage` as a fallback revert reason when `target` reverts.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, 0, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but also transferring `value` wei to `target`.
432      *
433      * Requirements:
434      *
435      * - the calling contract must have an ETH balance of at least `value`.
436      * - the called Solidity function must be `payable`.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(
441         address target,
442         bytes memory data,
443         uint256 value
444     ) internal returns (bytes memory) {
445         return
446             functionCallWithValue(
447                 target,
448                 data,
449                 value,
450                 "Address: low-level call with value failed"
451             );
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
456      * with `errorMessage` as a fallback revert reason when `target` reverts.
457      *
458      * _Available since v3.1._
459      */
460     function functionCallWithValue(
461         address target,
462         bytes memory data,
463         uint256 value,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         require(
467             address(this).balance >= value,
468             "Address: insufficient balance for call"
469         );
470         require(isContract(target), "Address: call to non-contract");
471 
472         // solhint-disable-next-line avoid-low-level-calls
473         (bool success, bytes memory returndata) = target.call{value: value}(
474             data
475         );
476         return _verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(address target, bytes memory data)
486         internal
487         view
488         returns (bytes memory)
489     {
490         return
491             functionStaticCall(
492                 target,
493                 data,
494                 "Address: low-level static call failed"
495             );
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
500      * but performing a static call.
501      *
502      * _Available since v3.3._
503      */
504     function functionStaticCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal view returns (bytes memory) {
509         require(isContract(target), "Address: static call to non-contract");
510 
511         // solhint-disable-next-line avoid-low-level-calls
512         (bool success, bytes memory returndata) = target.staticcall(data);
513         return _verifyCallResult(success, returndata, errorMessage);
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
518      * but performing a delegate call.
519      *
520      * _Available since v3.4._
521      */
522     function functionDelegateCall(address target, bytes memory data)
523         internal
524         returns (bytes memory)
525     {
526         return
527             functionDelegateCall(
528                 target,
529                 data,
530                 "Address: low-level delegate call failed"
531             );
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
536      * but performing a delegate call.
537      *
538      * _Available since v3.4._
539      */
540     function functionDelegateCall(
541         address target,
542         bytes memory data,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         require(isContract(target), "Address: delegate call to non-contract");
546 
547         // solhint-disable-next-line avoid-low-level-calls
548         (bool success, bytes memory returndata) = target.delegatecall(data);
549         return _verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     function _verifyCallResult(
553         bool success,
554         bytes memory returndata,
555         string memory errorMessage
556     ) private pure returns (bytes memory) {
557         if (success) {
558             return returndata;
559         } else {
560             // Look for revert reason and bubble it up if present
561             if (returndata.length > 0) {
562                 // The easiest way to bubble the revert reason is using memory via assembly
563 
564                 // solhint-disable-next-line no-inline-assembly
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 }
575 
576 library Strings {
577     /**
578      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
579      */
580     function toString(uint256 value) internal pure returns (string memory) {
581         // Inspired by OraclizeAPI's implementation - MIT licence
582         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
583 
584         if (value == 0) {
585             return "0";
586         }
587         uint256 temp = value;
588         uint256 digits;
589         while (temp != 0) {
590             digits++;
591             temp /= 10;
592         }
593         bytes memory buffer = new bytes(digits);
594         while (value != 0) {
595             digits -= 1;
596             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
597             value /= 10;
598         }
599         return string(buffer);
600     }
601 }
602 
603 abstract contract Context {
604     function _msgSender() internal view virtual returns (address) {
605         return msg.sender;
606     }
607 
608     function _msgData() internal view virtual returns (bytes calldata) {
609         this;
610         return msg.data;
611     }
612 }
613 
614 abstract contract Ownable is Context {
615     address private _owner;
616 
617     event OwnershipTransferred(
618         address indexed previousOwner,
619         address indexed newOwner
620     );
621 
622     /**
623      * @dev Initializes the contract setting the deployer as the initial owner.
624      */
625     constructor() {
626         _setOwner(_msgSender());
627     }
628 
629     /**
630      * @dev Returns the address of the current owner.
631      */
632     function owner() public view virtual returns (address) {
633         return _owner;
634     }
635 
636     /**
637      * @dev Throws if called by any account other than the owner.
638      */
639     modifier onlyOwner() {
640         require(owner() == _msgSender(), "Ownable: caller is not the owner");
641         _;
642     }
643 
644     /**
645      * @dev Leaves the contract without owner. It will not be possible to call
646      * `onlyOwner` functions anymore. Can only be called by the current owner.
647      *
648      * NOTE: Renouncing ownership will leave the contract without an owner,
649      * thereby removing any functionality that is only available to the owner.
650      */
651     function renounceOwnership() public virtual onlyOwner {
652         _setOwner(address(0));
653     }
654 
655     /**
656      * @dev Transfers ownership of the contract to a new account (`newOwner`).
657      * Can only be called by the current owner.
658      */
659     function transferOwnership(address newOwner) public virtual onlyOwner {
660         require(
661             newOwner != address(0),
662             "Ownable: new owner is the zero address"
663         );
664         _setOwner(newOwner);
665     }
666 
667     function _setOwner(address newOwner) private {
668         address oldOwner = _owner;
669         _owner = newOwner;
670         emit OwnershipTransferred(oldOwner, newOwner);
671     }
672 }
673 
674 abstract contract ERC165 is IERC165 {
675     /**
676      * @dev See {IERC165-supportsInterface}.
677      */
678     function supportsInterface(bytes4 interfaceId)
679         public
680         view
681         virtual
682         override
683         returns (bool)
684     {
685         return interfaceId == type(IERC165).interfaceId;
686     }
687 }
688 
689 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
690     using Address for address;
691     using Strings for uint256;
692 
693     // Token name
694     string internal _name;
695 
696     // Token symbol
697     string private _symbol;
698 
699     // Base URI
700     string private _tokenBaseURI;
701 
702     // Mapping from token ID to owner address
703     mapping(uint256 => address) private _owners;
704 
705     // Mapping owner address to token count
706     mapping(address => uint256) private _balances;
707 
708     // Mapping from token ID to approved address
709     mapping(uint256 => address) private _tokenApprovals;
710 
711     // Mapping from owner to operator approvals
712     mapping(address => mapping(address => bool)) private _operatorApprovals;
713 
714     /**
715      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
716      */
717     constructor(string memory name_, string memory symbol_) {
718         _name = name_;
719         _symbol = symbol_;
720     }
721 
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId)
726         public
727         view
728         virtual
729         override(ERC165, IERC165)
730         returns (bool)
731     {
732         return
733             interfaceId == type(IERC721).interfaceId ||
734             interfaceId == type(IERC721Metadata).interfaceId ||
735             super.supportsInterface(interfaceId);
736     }
737 
738     /**
739      * @dev See {IERC721-balanceOf}.
740      */
741     function balanceOf(address owner)
742         public
743         view
744         virtual
745         override
746         returns (uint256)
747     {
748         require(
749             owner != address(0),
750             "ERC721: balance query for the zero address"
751         );
752         return _balances[owner];
753     }
754 
755     /**
756      * @dev See {IERC721-ownerOf}.
757      */
758     function ownerOf(uint256 tokenId)
759         public
760         view
761         virtual
762         override
763         returns (address)
764     {
765         address owner = _owners[tokenId];
766         require(
767             owner != address(0),
768             "ERC721: owner query for nonexistent token"
769         );
770         return owner;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-name}.
775      */
776     function name() public view virtual override returns (string memory) {
777         return _name;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-symbol}.
782      */
783     function symbol() public view virtual override returns (string memory) {
784         return _symbol;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-tokenURI}.
789      */
790     function tokenURI(uint256 tokenId)
791         public
792         view
793         virtual
794         override
795         returns (string memory)
796     {
797         require(
798             _exists(tokenId),
799             "ERC721Metadata: URI query for nonexistent token"
800         );
801 
802         string memory baseURI = _baseURI();
803         return
804             bytes(baseURI).length > 0
805                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
806                 : "";
807     }
808 
809     /**
810      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
811      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
812      * by default, can be overriden in child contracts.
813      */
814     function _baseURI() internal view virtual returns (string memory) {
815         return _tokenBaseURI;
816     }
817 
818     function _setBaseURI(string memory baseURI_) internal virtual {
819         _tokenBaseURI = baseURI_;
820     }
821 
822     /**
823      * @dev See {IERC721-approve}.
824      */
825     function approve(address to, uint256 tokenId) public virtual override {
826         address owner = ERC721.ownerOf(tokenId);
827         require(to != owner, "ERC721: approval to current owner");
828 
829         require(
830             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
831             "ERC721: approve caller is not owner nor approved for all"
832         );
833 
834         _approve(to, tokenId);
835     }
836 
837     /**
838      * @dev See {IERC721-getApproved}.
839      */
840     function getApproved(uint256 tokenId)
841         public
842         view
843         virtual
844         override
845         returns (address)
846     {
847         require(
848             _exists(tokenId),
849             "ERC721: approved query for nonexistent token"
850         );
851 
852         return _tokenApprovals[tokenId];
853     }
854 
855     /**
856      * @dev See {IERC721-setApprovalForAll}.
857      */
858     function setApprovalForAll(address operator, bool approved)
859         public
860         virtual
861         override
862     {
863         _setApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator)
870         public
871         view
872         virtual
873         override
874         returns (bool)
875     {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev See {IERC721-transferFrom}.
881      */
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         //solhint-disable-next-line max-line-length
888         require(
889             _isApprovedOrOwner(_msgSender(), tokenId),
890             "ERC721: transfer caller is not owner nor approved"
891         );
892 
893         _transfer(from, to, tokenId);
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) public virtual override {
904         safeTransferFrom(from, to, tokenId, "");
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) public virtual override {
916         require(
917             _isApprovedOrOwner(_msgSender(), tokenId),
918             "ERC721: transfer caller is not owner nor approved"
919         );
920         _safeTransfer(from, to, tokenId, _data);
921     }
922 
923     /**
924      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
925      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
926      *
927      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
928      *
929      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
930      * implement alternative mechanisms to perform token transfer, such as signature-based.
931      *
932      * Requirements:
933      *
934      * - `from` cannot be the zero address.
935      * - `to` cannot be the zero address.
936      * - `tokenId` token must exist and be owned by `from`.
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _safeTransfer(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) internal virtual {
947         _transfer(from, to, tokenId);
948         require(
949             _checkOnERC721Received(from, to, tokenId, _data),
950             "ERC721: transfer to non ERC721Receiver implementer"
951         );
952     }
953 
954     /**
955      * @dev Returns whether `tokenId` exists.
956      *
957      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
958      *
959      * Tokens start existing when they are minted (`_mint`),
960      * and stop existing when they are burned (`_burn`).
961      */
962     function _exists(uint256 tokenId) internal view virtual returns (bool) {
963         return _owners[tokenId] != address(0);
964     }
965 
966     /**
967      * @dev Returns whether `spender` is allowed to manage `tokenId`.
968      *
969      * Requirements:
970      *
971      * - `tokenId` must exist.
972      */
973     function _isApprovedOrOwner(address spender, uint256 tokenId)
974         internal
975         view
976         virtual
977         returns (bool)
978     {
979         require(
980             _exists(tokenId),
981             "ERC721: operator query for nonexistent token"
982         );
983         address owner = ERC721.ownerOf(tokenId);
984         return (spender == owner ||
985             getApproved(tokenId) == spender ||
986             isApprovedForAll(owner, spender));
987     }
988 
989     /**
990      * @dev Safely mints `tokenId` and transfers it to `to`.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must not exist.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _safeMint(address to, uint256 tokenId) internal virtual {
1000         _safeMint(to, tokenId, "");
1001     }
1002 
1003     /**
1004      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1005      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1006      */
1007     function _safeMint(
1008         address to,
1009         uint256 tokenId,
1010         bytes memory _data
1011     ) internal virtual {
1012         _mint(to, tokenId);
1013         require(
1014             _checkOnERC721Received(address(0), to, tokenId, _data),
1015             "ERC721: transfer to non ERC721Receiver implementer"
1016         );
1017     }
1018 
1019     /**
1020      * @dev Mints `tokenId` and transfers it to `to`.
1021      *
1022      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - `to` cannot be the zero address.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _mint(address to, uint256 tokenId) internal virtual {
1032         require(to != address(0), "ERC721: mint to the zero address");
1033         require(!_exists(tokenId), "ERC721: token already minted");
1034 
1035         _beforeTokenTransfer(address(0), to, tokenId);
1036 
1037         _balances[to] += 1;
1038         _owners[tokenId] = to;
1039 
1040         emit Transfer(address(0), to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev Destroys `tokenId`.
1045      * The approval is cleared when the token is burned.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must exist.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _burn(uint256 tokenId) internal virtual {
1054         address owner = ERC721.ownerOf(tokenId);
1055 
1056         _beforeTokenTransfer(owner, address(0), tokenId);
1057 
1058         // Clear approvals
1059         _approve(address(0), tokenId);
1060 
1061         _balances[owner] -= 1;
1062         delete _owners[tokenId];
1063 
1064         emit Transfer(owner, address(0), tokenId);
1065     }
1066 
1067     /**
1068      * @dev Transfers `tokenId` from `from` to `to`.
1069      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1070      *
1071      * Requirements:
1072      *
1073      * - `to` cannot be the zero address.
1074      * - `tokenId` token must be owned by `from`.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _transfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual {
1083         require(
1084             ERC721.ownerOf(tokenId) == from,
1085             "ERC721: transfer of token that is not own"
1086         );
1087         require(to != address(0), "ERC721: transfer to the zero address");
1088 
1089         _beforeTokenTransfer(from, to, tokenId);
1090 
1091         // Clear approvals from the previous owner
1092         _approve(address(0), tokenId);
1093 
1094         _balances[from] -= 1;
1095         _balances[to] += 1;
1096         _owners[tokenId] = to;
1097 
1098         emit Transfer(from, to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev Approve `to` to operate on `tokenId`
1103      *
1104      * Emits a {Approval} event.
1105      */
1106     function _approve(address to, uint256 tokenId) internal virtual {
1107         _tokenApprovals[tokenId] = to;
1108         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev Approve `operator` to operate on all of `owner` tokens
1113      *
1114      * Emits a {ApprovalForAll} event.
1115      */
1116     function _setApprovalForAll(
1117         address owner,
1118         address operator,
1119         bool approved
1120     ) internal virtual {
1121         require(owner != operator, "ERC721: approve to caller");
1122         _operatorApprovals[owner][operator] = approved;
1123         emit ApprovalForAll(owner, operator, approved);
1124     }
1125 
1126     /**
1127      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1128      * The call is not executed if the target address is not a contract.
1129      *
1130      * @param from address representing the previous owner of the given token ID
1131      * @param to target address that will receive the tokens
1132      * @param tokenId uint256 ID of the token to be transferred
1133      * @param _data bytes optional data to send along with the call
1134      * @return bool whether the call correctly returned the expected magic value
1135      */
1136     function _checkOnERC721Received(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes memory _data
1141     ) private returns (bool) {
1142         if (to.isContract()) {
1143             try
1144                 IERC721Receiver(to).onERC721Received(
1145                     _msgSender(),
1146                     from,
1147                     tokenId,
1148                     _data
1149                 )
1150             returns (bytes4 retval) {
1151                 return retval == IERC721Receiver.onERC721Received.selector;
1152             } catch (bytes memory reason) {
1153                 if (reason.length == 0) {
1154                     revert(
1155                         "ERC721: transfer to non ERC721Receiver implementer"
1156                     );
1157                 } else {
1158                     assembly {
1159                         revert(add(32, reason), mload(reason))
1160                     }
1161                 }
1162             }
1163         } else {
1164             return true;
1165         }
1166     }
1167 
1168     /**
1169      * @dev Hook that is called before any token transfer. This includes minting
1170      * and burning.
1171      *
1172      * Calling conditions:
1173      *
1174      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1175      * transferred to `to`.
1176      * - When `from` is zero, `tokenId` will be minted for `to`.
1177      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1178      * - `from` and `to` are never both zero.
1179      *
1180      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1181      */
1182     function _beforeTokenTransfer(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) internal virtual {}
1187 }
1188 
1189 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1190     // Mapping from owner to list of owned token IDs
1191     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1192 
1193     // Mapping from token ID to index of the owner tokens list
1194     mapping(uint256 => uint256) private _ownedTokensIndex;
1195 
1196     // Array with all token ids, used for enumeration
1197     uint256[] private _allTokens;
1198 
1199     // Mapping from token id to position in the allTokens array
1200     mapping(uint256 => uint256) private _allTokensIndex;
1201 
1202     /**
1203      * @dev See {IERC165-supportsInterface}.
1204      */
1205     function supportsInterface(bytes4 interfaceId)
1206         public
1207         view
1208         virtual
1209         override(IERC165, ERC721)
1210         returns (bool)
1211     {
1212         return
1213             interfaceId == type(IERC721Enumerable).interfaceId ||
1214             super.supportsInterface(interfaceId);
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1219      */
1220     function tokenOfOwnerByIndex(address owner, uint256 index)
1221         public
1222         view
1223         virtual
1224         override
1225         returns (uint256)
1226     {
1227         require(
1228             index < ERC721.balanceOf(owner),
1229             "ERC721Enumerable: owner index out of bounds"
1230         );
1231         return _ownedTokens[owner][index];
1232     }
1233 
1234     /**
1235      * @dev See {IERC721Enumerable-totalSupply}.
1236      */
1237     function totalSupply() public view virtual override returns (uint256) {
1238         return _allTokens.length;
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Enumerable-tokenByIndex}.
1243      */
1244     function tokenByIndex(uint256 index)
1245         public
1246         view
1247         virtual
1248         override
1249         returns (uint256)
1250     {
1251         require(
1252             index < ERC721Enumerable.totalSupply(),
1253             "ERC721Enumerable: global index out of bounds"
1254         );
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
1273     function _beforeTokenTransfer(
1274         address from,
1275         address to,
1276         uint256 tokenId
1277     ) internal virtual override {
1278         super._beforeTokenTransfer(from, to, tokenId);
1279 
1280         if (from == address(0)) {
1281             _addTokenToAllTokensEnumeration(tokenId);
1282         } else if (from != to) {
1283             _removeTokenFromOwnerEnumeration(from, tokenId);
1284         }
1285         if (to == address(0)) {
1286             _removeTokenFromAllTokensEnumeration(tokenId);
1287         } else if (to != from) {
1288             _addTokenToOwnerEnumeration(to, tokenId);
1289         }
1290     }
1291 
1292     /**
1293      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1294      * @param to address representing the new owner of the given token ID
1295      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1296      */
1297     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1298         uint256 length = ERC721.balanceOf(to);
1299         _ownedTokens[to][length] = tokenId;
1300         _ownedTokensIndex[tokenId] = length;
1301     }
1302 
1303     /**
1304      * @dev Private function to add a token to this extension's token tracking data structures.
1305      * @param tokenId uint256 ID of the token to be added to the tokens list
1306      */
1307     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1308         _allTokensIndex[tokenId] = _allTokens.length;
1309         _allTokens.push(tokenId);
1310     }
1311 
1312     /**
1313      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1314      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1315      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1316      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1317      * @param from address representing the previous owner of the given token ID
1318      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1319      */
1320     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1321         private
1322     {
1323         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1324         // then delete the last slot (swap and pop).
1325 
1326         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1327         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1328 
1329         // When the token to delete is the last token, the swap operation is unnecessary
1330         if (tokenIndex != lastTokenIndex) {
1331             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1332 
1333             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1334             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1335         }
1336 
1337         // This also deletes the contents at the last position of the array
1338         delete _ownedTokensIndex[tokenId];
1339         delete _ownedTokens[from][lastTokenIndex];
1340     }
1341 
1342     /**
1343      * @dev Private function to remove a token from this extension's token tracking data structures.
1344      * This has O(1) time complexity, but alters the order of the _allTokens array.
1345      * @param tokenId uint256 ID of the token to be removed from the tokens list
1346      */
1347     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1348         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1349         // then delete the last slot (swap and pop).
1350 
1351         uint256 lastTokenIndex = _allTokens.length - 1;
1352         uint256 tokenIndex = _allTokensIndex[tokenId];
1353 
1354         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1355         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1356         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1357         uint256 lastTokenId = _allTokens[lastTokenIndex];
1358 
1359         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1360         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1361 
1362         // This also deletes the contents at the last position of the array
1363         delete _allTokensIndex[tokenId];
1364         _allTokens.pop();
1365     }
1366 }
1367 
1368 contract Collection is ERC721Enumerable, Ownable {
1369     using Strings for uint256;
1370 
1371     uint256 public constant EGG = 1;
1372     uint256 public constant BABY = 2;
1373     uint256 public constant DRAGON = 3;
1374 
1375     uint256 public constant HATCH_REQ = 2;
1376     mapping(uint256 => uint256) public genesisType;
1377     mapping(uint256 => bool) public isHatched;
1378 
1379     uint256 public constant TOTAL_EGGS = 1420;
1380     uint256 public constant TOTAL_LIMIT = 4420;
1381 
1382     uint256 public constant BATCH_LIMIT = 2;
1383     uint256 public constant WHITELIST_WINDOW = 1 days;
1384 
1385     mapping(address => bool) public isWhitelisted;
1386     mapping(address => uint256) public isRestricted;
1387     mapping(address => uint256) public dragonsCount;
1388 
1389     uint256 public hatchEggPrice;
1390     uint256 public hatchDragonPrice;
1391 
1392     uint256 public activatedAt;
1393     bool public activatedEggs;
1394     bool public activatedDragons;
1395 
1396     //contract address of the ape only island yield token
1397     address public tokenAddress = 0x260428e36989ee6c6829F8a6E361cba99C7a8447;
1398 
1399     event ActivatedEggs(address indexed account, uint256 timestamp);
1400     event ActivatedDragons(address indexed account, uint256 timestamp);
1401     event DeactivatedEggs(address indexed account, uint256 timestamp);
1402     event Changed(address indexed account, uint256 id);
1403 
1404     event NewEgg(uint256 id);
1405     event NewDragon(uint256 id);
1406 
1407     constructor() ERC721("DOI", "Dragons Of Island") {
1408         _setBaseURI("https://doti.apeonlyisland.com/");
1409         hatchEggPrice = 50 ether;
1410         hatchDragonPrice = 50 ether;
1411     }
1412 
1413     function setWhitelist(address account) external onlyOwner returns (bool) {
1414         isWhitelisted[account] = true;
1415         return true;
1416     }
1417 
1418     function setWhitelistBatch(address[] calldata accounts)
1419         external
1420         onlyOwner
1421         returns (bool)
1422     {
1423         uint256 counter = accounts.length;
1424         for (uint256 i = 0; i < counter; i++) {
1425             isWhitelisted[accounts[i]] = true;
1426         }
1427         return true;
1428     }
1429 
1430     function setHatchDragonPrice(uint256 newPrice)
1431         external
1432         onlyOwner
1433         returns (bool)
1434     {
1435         hatchDragonPrice = newPrice;
1436         return true;
1437     }
1438 
1439     function setTokenAddress(address tokenAddressArg)
1440         external
1441         onlyOwner
1442         returns (bool)
1443     {
1444         tokenAddress = tokenAddressArg;
1445         return true;
1446     }
1447 
1448     function setBaseURI(string memory newURI)
1449         external
1450         onlyOwner
1451         returns (bool)
1452     {
1453         _setBaseURI(newURI);
1454         return true;
1455     }
1456 
1457     function activateEggs() external onlyOwner returns (bool) {
1458         require(!activatedEggs, "Collection: minting must be deactivated");
1459 
1460         activatedAt = block.timestamp;
1461         activatedEggs = true;
1462 
1463         emit ActivatedEggs(_msgSender(), block.timestamp);
1464         return true;
1465     }
1466 
1467     function deactivateEggs() external onlyOwner returns (bool) {
1468         require(activatedEggs, "Collection: minting must be activated");
1469 
1470         activatedEggs = false;
1471 
1472         emit DeactivatedEggs(_msgSender(), block.timestamp);
1473         return true;
1474     }
1475 
1476     function activateDragons() external onlyOwner returns (bool) {
1477         require(!activatedDragons, "Collection: minting must be deactivated");
1478 
1479         activatedDragons = true;
1480 
1481         emit ActivatedDragons(_msgSender(), block.timestamp);
1482         return true;
1483     }
1484 
1485     function whitelistMint(uint256 amount) external returns (bool) {
1486         require(
1487             activatedEggs,
1488             "Collection: minting must be not be deactivated"
1489         );
1490 
1491         require(
1492             block.timestamp < activatedAt + WHITELIST_WINDOW,
1493             "Collection: public minting have started"
1494         );
1495 
1496         address account = _msgSender();
1497 
1498         require(
1499             isWhitelisted[account],
1500             "Collection: account must be whitelisted"
1501         );
1502 
1503         require(
1504             isRestricted[account] + amount <= BATCH_LIMIT,
1505             "Collection: minted amount must not exceed limit"
1506         );
1507 
1508         require(
1509             amount <= BATCH_LIMIT,
1510             "Collection: minted amount must not exceed batch limit"
1511         );
1512 
1513         uint256 next = totalSupply() + 1;
1514         isRestricted[account] += amount;
1515 
1516         for (uint256 i = 0; i < amount; i++) {
1517             if (next <= TOTAL_EGGS) {
1518                 _mint(account, next);
1519                 genesisType[next] = EGG;
1520                 emit NewEgg(next);
1521                 next++;
1522             }
1523         }
1524 
1525         return true;
1526     }
1527 
1528     function publicMint(uint256 amount) external returns (bool) {
1529         require(activatedEggs, "Collection: minting must be activated");
1530 
1531         require(
1532             block.timestamp >= activatedAt + WHITELIST_WINDOW,
1533             "Collection: public minting not started"
1534         );
1535 
1536         require(
1537             amount <= BATCH_LIMIT,
1538             "Collection: minted amount must not exceed batch limit"
1539         );
1540 
1541         address account = _msgSender();
1542 
1543         require(
1544             isRestricted[account] + amount <= BATCH_LIMIT,
1545             "Collection: minted amount must not exceed limit"
1546         );
1547 
1548         uint256 current = totalSupply();
1549 
1550         require(
1551             current + amount <= TOTAL_EGGS,
1552             "Collection: supply must be available for minting"
1553         );
1554 
1555         isRestricted[account] += amount;
1556 
1557         for (uint256 i = 1; i <= amount; i++) {
1558             uint256 next = current + i;
1559 
1560             if (next <= TOTAL_EGGS) {
1561                 genesisType[next] = EGG;
1562                 _mint(account, next);
1563                 emit NewEgg(next);
1564             }
1565         }
1566 
1567         return true;
1568     }
1569 
1570     function hatchEgg(uint256 tokenId) external returns (bool) {
1571         require(tokenAddress != address(0), "Collection: Shilling not enabled");
1572 
1573         require(
1574             !isHatched[tokenId],
1575             "Collection: egg must not be hatched already"
1576         );
1577 
1578         require(genesisType[tokenId] == EGG, "Collection: must be an egg");
1579 
1580         address account = _msgSender();
1581 
1582         uint256 _hatchEggPrice = hatchEggPrice;
1583         require(
1584             Token(tokenAddress).balanceOf(account) >= _hatchEggPrice,
1585             "Collection: not enough shilling"
1586         );
1587 
1588         Token(tokenAddress).burn(account, _hatchEggPrice);
1589 
1590         require(
1591             ownerOf(tokenId) == account,
1592             "Collection: account must be owner of token"
1593         );
1594 
1595         require(
1596             totalSupply() < TOTAL_LIMIT,
1597             "Collection: must not exceed the total supply"
1598         );
1599 
1600         uint256 next = totalSupply() + 1;
1601         _mint(account, next);
1602         isHatched[tokenId] = true;
1603         genesisType[next] = DRAGON;
1604         dragonsCount[account] += 1;
1605         emit NewDragon(next);
1606 
1607         return true;
1608     }
1609 
1610     function hatchDragon() external returns (bool) {
1611         require(
1612             activatedDragons,
1613             "Collection: minting must be not be deactivated"
1614         );
1615 
1616         require(tokenAddress != address(0), "Collection: Shilling not enabled");
1617 
1618         address account = _msgSender();
1619 
1620         uint256 _hatchDragonPrice = hatchDragonPrice;
1621         require(
1622             Token(tokenAddress).balanceOf(account) >= _hatchDragonPrice,
1623             "Collection: not enough shilling"
1624         );
1625 
1626         Token(tokenAddress).burn(account, _hatchDragonPrice);
1627 
1628         require(
1629             dragonsCount[account] >= HATCH_REQ,
1630             "Collection: must own 2 adult dragons to mint a baby dragon"
1631         );
1632 
1633         require(
1634             totalSupply() < TOTAL_LIMIT,
1635             "Collection: must not exceed the total supply"
1636         );
1637 
1638         uint256 next = totalSupply() + 1;
1639         _mint(account, next);
1640         genesisType[next] = BABY;
1641         emit NewDragon(next);
1642 
1643         return true;
1644     }
1645 
1646     function _beforeTokenTransfer(
1647         address from,
1648         address to,
1649         uint256 tokenId
1650     ) internal override {
1651         super._beforeTokenTransfer(from, to, tokenId);
1652         if (genesisType[tokenId] == DRAGON) {
1653             dragonsCount[from] -= 1;
1654             dragonsCount[to] += 1;
1655         }
1656     }
1657 }