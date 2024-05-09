1 /**
2 
3                                           `-.`'.-'
4                                        `-.        .-'.
5                                     `-.    -./\.-    .-'
6                                         -.  /_|\  .-
7                                     `-.   `/____\'   .-'.
8                                  `-.    -./.-""-.\.-      '
9                                     `-.  /< (()) >\  .-'
10                                   -   .`/__`-..-'__\'   .-
11                                 ,...`-./___|____|___\.-'.,.
12                                    ,-'   ,` . . ',   `-,
13                                 ,-'   ________________  `-,
14                                    ,'/____|_____|_____\
15                                   / /__|_____|_____|___\
16                                  / /|_____|_____|_____|_\
17                                 ' /____|_____|_____|_____\
18                               .' /__|_____|_____|_____|___\
19                              ,' /|_____|_____|_____|_____|_\
20 ,,---''--...___...--'''--.. /../____|_____|_____|_____|_____\ ..--```--...___...--``---,,
21                            '../__|_____|_____|_____|_____|___\
22       \    )              '.:/|_____|_____|_____|_____|_____|_\               (    /
23       )\  / )           ,':./____|_____|_____|_____|_____|_____\             ( \  /(
24      / / ( (           /:../__|_____|_____|_____|_____|_____|___\             ) ) \ \
25     | |   \ \         /.../|_____|_____|_____|_____|_____|_____|_\           / /   | |
26  .-.\ \    \ \       '..:/____|_____|_____|_____|_____|_____|_____\         / /    / /.-.
27 (=  )\ `._.' |       \:./ _  _ ___  ____ ____ _    _ _ _ _ _  _ ___\        | `._.' /(  =)
28  \ (_)       )       \./  |\/| |__) |___ |___ |___ _X_ _X_  \/  _|_ \       (       (_) /
29   \    `----'         """"""""""""""""""""""""""""""""""""""""""""""""       `----'    /
30   
31 ███╗   ██╗ ██████╗ ████████╗     █████╗     ███████╗███████╗ ██████╗██████╗ ███████╗████████╗    ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗
32 ████╗  ██║██╔═══██╗╚══██╔══╝    ██╔══██╗    ██╔════╝██╔════╝██╔════╝██╔══██╗██╔════╝╚══██╔══╝    ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝
33 ██╔██╗ ██║██║   ██║   ██║       ███████║    ███████╗█████╗  ██║     ██████╔╝█████╗     ██║       ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║   
34 ██║╚██╗██║██║   ██║   ██║       ██╔══██║    ╚════██║██╔══╝  ██║     ██╔══██╗██╔══╝     ██║       ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║   
35 ██║ ╚████║╚██████╔╝   ██║       ██║  ██║    ███████║███████╗╚██████╗██║  ██║███████╗   ██║       ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║   
36 ╚═╝  ╚═══╝ ╚═════╝    ╚═╝       ╚═╝  ╚═╝    ╚══════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝   ╚═╝       ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝   
37                                                                                                                                                                                                                                                                                  
38  * 
39  * Hello world,
40  * 
41  * Nothing was intended to be obscured from you, you simply did not follow the clues.
42  * Journal 3 was left behind, allowing me to delve deep into your thoughts. 
43  * 
44  * -Bill
45  * 
46  *
47  * Founded By: @xxxxxx
48  * Developed By: @banteg & @0xcurio
49  * Optimization assistance credits: @0xca0a
50  */
51 
52 
53 
54 // File: Address.sol
55 
56 pragma solidity ^0.8.6;
57 
58 library Address {
59     function isContract(address account) internal view returns (bool) {
60         uint size;
61         assembly {
62             size := extcodesize(account)
63         }
64         return size > 0;
65     }
66 }
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @title ERC721 token receiver interface
146  * @dev Interface for any contract that wants to support safeTransfers
147  * from ERC721 asset contracts.
148  */
149 interface IERC721Receiver {
150     /**
151      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
152      * by `operator` from `from`, this function is called.
153      *
154      * It must return its Solidity selector to confirm the token transfer.
155      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
156      *
157      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
158      */
159     function onERC721Received(
160         address operator,
161         address from,
162         uint256 tokenId,
163         bytes calldata data
164     ) external returns (bytes4);
165 }
166 
167 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Interface of the ERC165 standard, as defined in the
176  * https://eips.ethereum.org/EIPS/eip-165[EIP].
177  *
178  * Implementers can declare support of contract interfaces, which can then be
179  * queried by others ({ERC165Checker}).
180  *
181  * For an implementation, see {ERC165}.
182  */
183 interface IERC165 {
184     /**
185      * @dev Returns true if this contract implements the interface defined by
186      * `interfaceId`. See the corresponding
187      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
188      * to learn more about how these ids are created.
189      *
190      * This function call must use less than 30 000 gas.
191      */
192     function supportsInterface(bytes4 interfaceId) external view returns (bool);
193 }
194 
195 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
196 
197 
198 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 
203 /**
204  * @dev Implementation of the {IERC165} interface.
205  *
206  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
207  * for the additional interface id that will be supported. For example:
208  *
209  * ```solidity
210  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
211  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
212  * }
213  * ```
214  *
215  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
216  */
217 abstract contract ERC165 is IERC165 {
218     /**
219      * @dev See {IERC165-supportsInterface}.
220      */
221     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
222         return interfaceId == type(IERC165).interfaceId;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 
234 /**
235  * @dev Required interface of an ERC721 compliant contract.
236  */
237 interface IERC721 is IERC165 {
238     /**
239      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
240      */
241     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
242 
243     /**
244      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
245      */
246     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
247 
248     /**
249      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
250      */
251     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
252 
253     /**
254      * @dev Returns the number of tokens in ``owner``'s account.
255      */
256     function balanceOf(address owner) external view returns (uint256 balance);
257 
258     /**
259      * @dev Returns the owner of the `tokenId` token.
260      *
261      * Requirements:
262      *
263      * - `tokenId` must exist.
264      */
265     function ownerOf(uint256 tokenId) external view returns (address owner);
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
269      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must exist and be owned by `from`.
276      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
277      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
278      *
279      * Emits a {Transfer} event.
280      */
281     function safeTransferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Transfers `tokenId` token from `from` to `to`.
289      *
290      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
291      *
292      * Requirements:
293      *
294      * - `from` cannot be the zero address.
295      * - `to` cannot be the zero address.
296      * - `tokenId` token must be owned by `from`.
297      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     /**
308      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
309      * The approval is cleared when the token is transferred.
310      *
311      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
312      *
313      * Requirements:
314      *
315      * - The caller must own the token or be an approved operator.
316      * - `tokenId` must exist.
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address to, uint256 tokenId) external;
321 
322     /**
323      * @dev Returns the account approved for `tokenId` token.
324      *
325      * Requirements:
326      *
327      * - `tokenId` must exist.
328      */
329     function getApproved(uint256 tokenId) external view returns (address operator);
330 
331     /**
332      * @dev Approve or remove `operator` as an operator for the caller.
333      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
334      *
335      * Requirements:
336      *
337      * - The `operator` cannot be the caller.
338      *
339      * Emits an {ApprovalForAll} event.
340      */
341     function setApprovalForAll(address operator, bool _approved) external;
342 
343     /**
344      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
345      *
346      * See {setApprovalForAll}
347      */
348     function isApprovedForAll(address owner, address operator) external view returns (bool);
349 
350     /**
351      * @dev Safely transfers `tokenId` token from `from` to `to`.
352      *
353      * Requirements:
354      *
355      * - `from` cannot be the zero address.
356      * - `to` cannot be the zero address.
357      * - `tokenId` token must exist and be owned by `from`.
358      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
359      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
360      *
361      * Emits a {Transfer} event.
362      */
363     function safeTransferFrom(
364         address from,
365         address to,
366         uint256 tokenId,
367         bytes calldata data
368     ) external;
369 }
370 
371 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 
379 /**
380  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
381  * @dev See https://eips.ethereum.org/EIPS/eip-721
382  */
383 interface IERC721Enumerable is IERC721 {
384     /**
385      * @dev Returns the total amount of tokens stored by the contract.
386      */
387     function totalSupply() external view returns (uint256);
388 
389     /**
390      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
391      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
392      */
393     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
394 
395     /**
396      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
397      * Use along with {totalSupply} to enumerate all tokens.
398      */
399     function tokenByIndex(uint256 index) external view returns (uint256);
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 
410 /**
411  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
412  * @dev See https://eips.ethereum.org/EIPS/eip-721
413  */
414 interface IERC721Metadata is IERC721 {
415     /**
416      * @dev Returns the token collection name.
417      */
418     function name() external view returns (string memory);
419 
420     /**
421      * @dev Returns the token collection symbol.
422      */
423     function symbol() external view returns (string memory);
424 
425     /**
426      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
427      */
428     function tokenURI(uint256 tokenId) external view returns (string memory);
429 }
430 
431 // File: @openzeppelin/contracts/utils/Context.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Provides information about the current execution context, including the
440  * sender of the transaction and its data. While these are generally available
441  * via msg.sender and msg.data, they should not be accessed in such a direct
442  * manner, since when dealing with meta-transactions the account sending and
443  * paying for execution may not be the actual sender (as far as an application
444  * is concerned).
445  *
446  * This contract is only required for intermediate, library-like contracts.
447  */
448 abstract contract Context {
449     function _msgSender() internal view virtual returns (address) {
450         return msg.sender;
451     }
452 
453     function _msgData() internal view virtual returns (bytes calldata) {
454         return msg.data;
455     }
456 }
457 
458 // File: ERC721.sol
459 
460 
461 
462 pragma solidity ^0.8.7;
463 
464 
465 
466 
467 
468 
469 
470 
471 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
472     using Address for address;
473     using Strings for uint256;
474     
475     string private _name;
476     string private _symbol;
477 
478     // Mapping from token ID to owner address
479     address[] internal _owners;
480 
481     mapping(uint256 => address) private _tokenApprovals;
482     mapping(address => mapping(address => bool)) private _operatorApprovals;
483 
484     /**
485      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
486      */
487     constructor(string memory name_, string memory symbol_) {
488         _name = name_;
489         _symbol = symbol_;
490     }
491 
492     /**
493      * @dev See {IERC165-supportsInterface}.
494      */
495     function supportsInterface(bytes4 interfaceId)
496         public
497         view
498         virtual
499         override(ERC165, IERC165)
500         returns (bool)
501     {
502         return
503             interfaceId == type(IERC721).interfaceId ||
504             interfaceId == type(IERC721Metadata).interfaceId ||
505             super.supportsInterface(interfaceId);
506     }
507 
508     /**
509      * @dev See {IERC721-balanceOf}.
510      */
511     function balanceOf(address owner) 
512         public 
513         view 
514         virtual 
515         override 
516         returns (uint) 
517     {
518         require(owner != address(0), "ERC721: balance query for the zero address");
519 
520         uint count;
521         for( uint i; i < _owners.length; ++i ){
522           if( owner == _owners[i] )
523             ++count;
524         }
525         return count;
526     }
527 
528     /**
529      * @dev See {IERC721-ownerOf}.
530      */
531     function ownerOf(uint256 tokenId)
532         public
533         view
534         virtual
535         override
536         returns (address)
537     {
538         address owner = _owners[tokenId];
539         require(
540             owner != address(0),
541             "ERC721: owner query for nonexistent token"
542         );
543         return owner;
544     }
545 
546     /**
547      * @dev See {IERC721Metadata-name}.
548      */
549     function name() public view virtual override returns (string memory) {
550         return _name;
551     }
552 
553     /**
554      * @dev See {IERC721Metadata-symbol}.
555      */
556     function symbol() public view virtual override returns (string memory) {
557         return _symbol;
558     }
559 
560     /**
561      * @dev See {IERC721-approve}.
562      */
563     function approve(address to, uint256 tokenId) public virtual override {
564         address owner = ERC721.ownerOf(tokenId);
565         require(to != owner, "ERC721: approval to current owner");
566 
567         require(
568             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
569             "ERC721: approve caller is not owner nor approved for all"
570         );
571 
572         _approve(to, tokenId);
573     }
574 
575     /**
576      * @dev See {IERC721-getApproved}.
577      */
578     function getApproved(uint256 tokenId)
579         public
580         view
581         virtual
582         override
583         returns (address)
584     {
585         require(
586             _exists(tokenId),
587             "ERC721: approved query for nonexistent token"
588         );
589 
590         return _tokenApprovals[tokenId];
591     }
592 
593     /**
594      * @dev See {IERC721-setApprovalForAll}.
595      */
596     function setApprovalForAll(address operator, bool approved)
597         public
598         virtual
599         override
600     {
601         require(operator != _msgSender(), "ERC721: approve to caller");
602 
603         _operatorApprovals[_msgSender()][operator] = approved;
604         emit ApprovalForAll(_msgSender(), operator, approved);
605     }
606 
607     /**
608      * @dev See {IERC721-isApprovedForAll}.
609      */
610     function isApprovedForAll(address owner, address operator)
611         public
612         view
613         virtual
614         override
615         returns (bool)
616     {
617         return _operatorApprovals[owner][operator];
618     }
619 
620     /**
621      * @dev See {IERC721-transferFrom}.
622      */
623     function transferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) public virtual override {
628         //solhint-disable-next-line max-line-length
629         require(
630             _isApprovedOrOwner(_msgSender(), tokenId),
631             "ERC721: transfer caller is not owner nor approved"
632         );
633 
634         _transfer(from, to, tokenId);
635     }
636 
637     /**
638      * @dev See {IERC721-safeTransferFrom}.
639      */
640     function safeTransferFrom(
641         address from,
642         address to,
643         uint256 tokenId
644     ) public virtual override {
645         safeTransferFrom(from, to, tokenId, "");
646     }
647 
648     /**
649      * @dev See {IERC721-safeTransferFrom}.
650      */
651     function safeTransferFrom(
652         address from,
653         address to,
654         uint256 tokenId,
655         bytes memory _data
656     ) public virtual override {
657         require(
658             _isApprovedOrOwner(_msgSender(), tokenId),
659             "ERC721: transfer caller is not owner nor approved"
660         );
661         _safeTransfer(from, to, tokenId, _data);
662     }
663 
664     /**
665      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
666      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
667      *
668      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
669      *
670      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
671      * implement alternative mechanisms to perform token transfer, such as signature-based.
672      *
673      * Requirements:
674      *
675      * - `from` cannot be the zero address.
676      * - `to` cannot be the zero address.
677      * - `tokenId` token must exist and be owned by `from`.
678      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
679      *
680      * Emits a {Transfer} event.
681      */
682     function _safeTransfer(
683         address from,
684         address to,
685         uint256 tokenId,
686         bytes memory _data
687     ) internal virtual {
688         _transfer(from, to, tokenId);
689         require(
690             _checkOnERC721Received(from, to, tokenId, _data),
691             "ERC721: transfer to non ERC721Receiver implementer"
692         );
693     }
694 
695     /**
696      * @dev Returns whether `tokenId` exists.
697      *
698      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
699      *
700      * Tokens start existing when they are minted (`_mint`),
701      * and stop existing when they are burned (`_burn`).
702      */
703     function _exists(uint256 tokenId) internal view virtual returns (bool) {
704         return tokenId < _owners.length && _owners[tokenId] != address(0);
705     }
706 
707     /**
708      * @dev Returns whether `spender` is allowed to manage `tokenId`.
709      *
710      * Requirements:
711      *
712      * - `tokenId` must exist.
713      */
714     function _isApprovedOrOwner(address spender, uint256 tokenId)
715         internal
716         view
717         virtual
718         returns (bool)
719     {
720         require(
721             _exists(tokenId),
722             "ERC721: operator query for nonexistent token"
723         );
724         address owner = ERC721.ownerOf(tokenId);
725         return (spender == owner ||
726             getApproved(tokenId) == spender ||
727             isApprovedForAll(owner, spender));
728     }
729 
730     /**
731      * @dev Safely mints `tokenId` and transfers it to `to`.
732      *
733      * Requirements:
734      *
735      * - `tokenId` must not exist.
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
737      *
738      * Emits a {Transfer} event.
739      */
740     function _safeMint(address to, uint256 tokenId) internal virtual {
741         _safeMint(to, tokenId, "");
742     }
743 
744     /**
745      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
746      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
747      */
748     function _safeMint(
749         address to,
750         uint256 tokenId,
751         bytes memory _data
752     ) internal virtual {
753         _mint(to, tokenId);
754         require(
755             _checkOnERC721Received(address(0), to, tokenId, _data),
756             "ERC721: transfer to non ERC721Receiver implementer"
757         );
758     }
759 
760     /**
761      * @dev Mints `tokenId` and transfers it to `to`.
762      *
763      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
764      *
765      * Requirements:
766      *
767      * - `tokenId` must not exist.
768      * - `to` cannot be the zero address.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _mint(address to, uint256 tokenId) internal virtual {
773         require(to != address(0), "ERC721: mint to the zero address");
774         require(!_exists(tokenId), "ERC721: token already minted");
775 
776         _beforeTokenTransfer(address(0), to, tokenId);
777         _owners.push(to);
778 
779         emit Transfer(address(0), to, tokenId);
780     }
781 
782     /**
783      * @dev Destroys `tokenId`.
784      * The approval is cleared when the token is burned.
785      *
786      * Requirements:
787      *
788      * - `tokenId` must exist.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _burn(uint256 tokenId) internal virtual {
793         address owner = ERC721.ownerOf(tokenId);
794 
795         _beforeTokenTransfer(owner, address(0), tokenId);
796 
797         // Clear approvals
798         _approve(address(0), tokenId);
799         _owners[tokenId] = address(0);
800 
801         emit Transfer(owner, address(0), tokenId);
802     }
803 
804     /**
805      * @dev Transfers `tokenId` from `from` to `to`.
806      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
807      *
808      * Requirements:
809      *
810      * - `to` cannot be the zero address.
811      * - `tokenId` token must be owned by `from`.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _transfer(
816         address from,
817         address to,
818         uint256 tokenId
819     ) internal virtual {
820         require(
821             ERC721.ownerOf(tokenId) == from,
822             "ERC721: transfer of token that is not own"
823         );
824         require(to != address(0), "ERC721: transfer to the zero address");
825 
826         _beforeTokenTransfer(from, to, tokenId);
827 
828         // Clear approvals from the previous owner
829         _approve(address(0), tokenId);
830         _owners[tokenId] = to;
831 
832         emit Transfer(from, to, tokenId);
833     }
834 
835     /**
836      * @dev Approve `to` to operate on `tokenId`
837      *
838      * Emits a {Approval} event.
839      */
840     function _approve(address to, uint256 tokenId) internal virtual {
841         _tokenApprovals[tokenId] = to;
842         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
843     }
844 
845     /**
846      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
847      * The call is not executed if the target address is not a contract.
848      *
849      * @param from address representing the previous owner of the given token ID
850      * @param to target address that will receive the tokens
851      * @param tokenId uint256 ID of the token to be transferred
852      * @param _data bytes optional data to send along with the call
853      * @return bool whether the call correctly returned the expected magic value
854      */
855     function _checkOnERC721Received(
856         address from,
857         address to,
858         uint256 tokenId,
859         bytes memory _data
860     ) private returns (bool) {
861         if (to.isContract()) {
862             try
863                 IERC721Receiver(to).onERC721Received(
864                     _msgSender(),
865                     from,
866                     tokenId,
867                     _data
868                 )
869             returns (bytes4 retval) {
870                 return retval == IERC721Receiver.onERC721Received.selector;
871             } catch (bytes memory reason) {
872                 if (reason.length == 0) {
873                     revert(
874                         "ERC721: transfer to non ERC721Receiver implementer"
875                     );
876                 } else {
877                     assembly {
878                         revert(add(32, reason), mload(reason))
879                     }
880                 }
881             }
882         } else {
883             return true;
884         }
885     }
886 
887     /**
888      * @dev Hook that is called before any token transfer. This includes minting
889      * and burning.
890      *
891      * Calling conditions:
892      *
893      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
894      * transferred to `to`.
895      * - When `from` is zero, `tokenId` will be minted for `to`.
896      * - When `to` is zero, ``from``'s `tokenId` will be burned.
897      * - `from` and `to` are never both zero.
898      *
899      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
900      */
901     function _beforeTokenTransfer(
902         address from,
903         address to,
904         uint256 tokenId
905     ) internal virtual {}
906 }
907 // File: ERC721Enumerable.sol
908 
909 
910 
911 pragma solidity ^0.8.7;
912 
913 
914 
915 /**
916  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
917  * enumerability of all the token ids in the contract as well as all token ids owned by each
918  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
919  */
920 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
921     /**
922      * @dev See {IERC165-supportsInterface}.
923      */
924     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
925         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
926     }
927 
928     /**
929      * @dev See {IERC721Enumerable-totalSupply}.
930      */
931     function totalSupply() public view virtual override returns (uint256) {
932         return _owners.length;
933     }
934 
935     /**
936      * @dev See {IERC721Enumerable-tokenByIndex}.
937      */
938     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
939         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
940         return index;
941     }
942 
943     /**
944      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
945      */
946     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
947         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
948 
949         uint count;
950         for(uint i; i < _owners.length; i++){
951             if(owner == _owners[i]){
952                 if(count == index) return i;
953                 else count++;
954             }
955         }
956 
957         revert("ERC721Enumerable: owner index out of bounds");
958     }
959 }
960 // File: @openzeppelin/contracts/access/Ownable.sol
961 
962 
963 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
964 
965 pragma solidity ^0.8.0;
966 
967 
968 /**
969  * @dev Contract module which provides a basic access control mechanism, where
970  * there is an account (an owner) that can be granted exclusive access to
971  * specific functions.
972  *
973  * By default, the owner account will be the one that deploys the contract. This
974  * can later be changed with {transferOwnership}.
975  *
976  * This module is used through inheritance. It will make available the modifier
977  * `onlyOwner`, which can be applied to your functions to restrict their use to
978  * the owner.
979  */
980 abstract contract Ownable is Context {
981     address private _owner;
982 
983     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
984 
985     /**
986      * @dev Initializes the contract setting the deployer as the initial owner.
987      */
988     constructor() {
989         _transferOwnership(_msgSender());
990     }
991 
992     /**
993      * @dev Returns the address of the current owner.
994      */
995     function owner() public view virtual returns (address) {
996         return _owner;
997     }
998 
999     /**
1000      * @dev Throws if called by any account other than the owner.
1001      */
1002     modifier onlyOwner() {
1003         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1004         _;
1005     }
1006 
1007     /**
1008      * @dev Leaves the contract without owner. It will not be possible to call
1009      * `onlyOwner` functions anymore. Can only be called by the current owner.
1010      *
1011      * NOTE: Renouncing ownership will leave the contract without an owner,
1012      * thereby removing any functionality that is only available to the owner.
1013      */
1014     function renounceOwnership() public virtual onlyOwner {
1015         _transferOwnership(address(0));
1016     }
1017 
1018     /**
1019      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1020      * Can only be called by the current owner.
1021      */
1022     function transferOwnership(address newOwner) public virtual onlyOwner {
1023         require(newOwner != address(0), "Ownable: new owner is the zero address");
1024         _transferOwnership(newOwner);
1025     }
1026 
1027     /**
1028      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1029      * Internal function without access restriction.
1030      */
1031     function _transferOwnership(address newOwner) internal virtual {
1032         address oldOwner = _owner;
1033         _owner = newOwner;
1034         emit OwnershipTransferred(oldOwner, newOwner);
1035     }
1036 }
1037 
1038 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1039 
1040 
1041 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 /**
1046  * @dev These functions deal with verification of Merkle Trees proofs.
1047  *
1048  * The proofs can be generated using the JavaScript library
1049  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1050  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1051  *
1052  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1053  */
1054 library MerkleProof {
1055     /**
1056      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1057      * defined by `root`. For this, a `proof` must be provided, containing
1058      * sibling hashes on the branch from the leaf to the root of the tree. Each
1059      * pair of leaves and each pair of pre-images are assumed to be sorted.
1060      */
1061     function verify(
1062         bytes32[] memory proof,
1063         bytes32 root,
1064         bytes32 leaf
1065     ) internal pure returns (bool) {
1066         return processProof(proof, leaf) == root;
1067     }
1068 
1069     /**
1070      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1071      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1072      * hash matches the root of the tree. When processing the proof, the pairs
1073      * of leafs & pre-images are assumed to be sorted.
1074      *
1075      * _Available since v4.4._
1076      */
1077     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1078         bytes32 computedHash = leaf;
1079         for (uint256 i = 0; i < proof.length; i++) {
1080             bytes32 proofElement = proof[i];
1081             if (computedHash <= proofElement) {
1082                 // Hash(current computed hash + current element of the proof)
1083                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1084             } else {
1085                 // Hash(current element of the proof + current computed hash)
1086                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1087             }
1088         }
1089         return computedHash;
1090     }
1091 }
1092 
1093 // File: not so secret project.sol
1094 
1095 
1096 
1097 pragma solidity ^0.8.7;
1098 
1099 
1100 interface IWasteland {
1101     function getScavengeRate(uint256 tokenId) external view returns (uint256);
1102 }
1103 
1104 contract notasecretproject is ERC721Enumerable, Ownable {
1105     string  public              baseURI;
1106     
1107     address public              proxyRegistryAddress;
1108     address public              wastelandAddress;
1109     address public              SecretAdd;
1110 
1111     bytes32 public              whitelistMerkleRoot;
1112     uint256 public              MAX_SUPPLY;
1113 
1114     uint256 public constant     MAX_PER_TX          = 11;
1115     uint256 public constant     RESERVES            = 5;
1116     uint256 public constant     priceInWei          = 0.05 ether;
1117 
1118     mapping(address => bool) public projectProxy;
1119     mapping(address => uint) public addressToMinted;
1120 
1121     constructor(
1122         string memory _baseURI, 
1123         address _proxyRegistryAddress, 
1124         address _SecretAdd
1125     )
1126         ERC721("notasecretproject", "SCRT")
1127     {
1128         baseURI = _baseURI;
1129         proxyRegistryAddress = _proxyRegistryAddress;
1130         SecretAdd = _SecretAdd;
1131     }
1132 
1133     function setBaseURI(string memory _baseURI) public onlyOwner {
1134         baseURI = _baseURI;
1135     }
1136 
1137     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1138         require(_exists(_tokenId), "Token does not exist.");
1139         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1140     }
1141 
1142     function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
1143         proxyRegistryAddress = _proxyRegistryAddress;
1144     }
1145 
1146     function setWastelandAddress(address _wastelandAddress) external onlyOwner {
1147         wastelandAddress = _wastelandAddress;
1148     }
1149 
1150     function flipProxyState(address proxyAddress) public onlyOwner {
1151         projectProxy[proxyAddress] = !projectProxy[proxyAddress];
1152     }
1153 
1154     function collectReserves() external onlyOwner {
1155         require(_owners.length == 0, 'Reserves already taken.');
1156         for(uint256 i; i < RESERVES; i++)
1157             _mint(_msgSender(), i);
1158     }
1159 
1160     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1161         whitelistMerkleRoot = _whitelistMerkleRoot;
1162     }
1163 
1164     function togglePublicSale(uint256 _MAX_SUPPLY) external onlyOwner {
1165         delete whitelistMerkleRoot;
1166         MAX_SUPPLY = _MAX_SUPPLY;
1167     }
1168 
1169     function _leaf(string memory allowance, string memory payload) internal pure returns (bytes32) {
1170         return keccak256(abi.encodePacked(payload, allowance));
1171     }
1172 
1173     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1174         return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1175     }
1176 
1177     function getAllowance(string memory allowance, bytes32[] calldata proof) public view returns (string memory) {
1178         string memory payload = string(abi.encodePacked(_msgSender()));
1179         require(_verify(_leaf(allowance, payload), proof), "Invalid Merkle Tree proof supplied.");
1180         return allowance;
1181     }
1182 
1183     function whitelistMint(uint256 count, uint256 allowance, bytes32[] calldata proof) public payable {
1184         string memory payload = string(abi.encodePacked(_msgSender()));
1185         require(_verify(_leaf(Strings.toString(allowance), payload), proof), "Invalid Merkle Tree proof supplied.");
1186         require(addressToMinted[_msgSender()] + count <= allowance, "Exceeds whitelist supply"); 
1187         require(count * priceInWei == msg.value, "Invalid funds provided.");
1188 
1189         addressToMinted[_msgSender()] += count;
1190         uint256 totalSupply = _owners.length;
1191         for(uint i; i < count; i++) { 
1192             _mint(_msgSender(), totalSupply + i);
1193         }
1194     }
1195 
1196     function publicMint(uint256 count) public payable {
1197         uint256 totalSupply = _owners.length;
1198         require(totalSupply + count < 10000, "Excedes max supply.");
1199         require(count < MAX_PER_TX, "Exceeds max per transaction.");
1200         require(count * priceInWei == msg.value, "Invalid funds provided.");
1201     
1202         for(uint i; i < count; i++) { 
1203             _mint(_msgSender(), totalSupply + i);
1204         }
1205     }
1206     
1207     function getScavengeRate(uint256 tokenId) public view returns (uint256) {
1208         require(wastelandAddress != address(0x0), "Wasteland not explored yet!");
1209         return IWasteland(wastelandAddress).getScavengeRate(tokenId);
1210     }
1211 
1212     function burn(uint256 tokenId) public { 
1213         require(_isApprovedOrOwner(_msgSender(), tokenId), "Not approved to burn.");
1214         _burn(tokenId);
1215     }
1216 
1217     function withdraw() public  {
1218         (bool success, ) = SecretAdd.call{value: address(this).balance}("");
1219         require(success, "Failed to send to scrt.");
1220     }
1221 
1222     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1223         uint256 tokenCount = balanceOf(_owner);
1224         if (tokenCount == 0) return new uint256[](0);
1225 
1226         uint256[] memory tokensId = new uint256[](tokenCount);
1227         for (uint256 i; i < tokenCount; i++) {
1228             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1229         }
1230         return tokensId;
1231     }
1232 
1233     function batchTransferFrom(address _from, address _to, uint256[] memory _tokenIds) public {
1234         for (uint256 i = 0; i < _tokenIds.length; i++) {
1235             transferFrom(_from, _to, _tokenIds[i]);
1236         }
1237     }
1238 
1239     function batchSafeTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory data_) public {
1240         for (uint256 i = 0; i < _tokenIds.length; i++) {
1241             safeTransferFrom(_from, _to, _tokenIds[i], data_);
1242         }
1243     }
1244 
1245     function isOwnerOf(address account, uint256[] calldata _tokenIds) external view returns (bool){
1246         for(uint256 i; i < _tokenIds.length; ++i ){
1247             if(_owners[_tokenIds[i]] != account)
1248                 return false;
1249         }
1250 
1251         return true;
1252     }
1253 
1254     function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1255         OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
1256         if (address(proxyRegistry.proxies(_owner)) == operator || projectProxy[operator]) return true;
1257         return super.isApprovedForAll(_owner, operator);
1258     }
1259 
1260     function _mint(address to, uint256 tokenId) internal virtual override {
1261         _owners.push(to);
1262         emit Transfer(address(0), to, tokenId);
1263     }
1264 }
1265 
1266 contract OwnableDelegateProxy { }
1267 contract OpenSeaProxyRegistry {
1268     mapping(address => OwnableDelegateProxy) public proxies;
1269 }