1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5          _____          ________        __    __                 __________              __            
6   ______/ ____\____    /  _____/ __ ___/  |__/  |_  ___________  \______   \__ __  ____ |  | __  ______
7  /     \   __\/    \  /   \  ___|  |  \   __\   __\/ __ \_  __ \  |     ___/  |  \/    \|  |/ / /  ___/
8 |  Y Y  \  | |   |  \ \    \_\  \  |  /|  |  |  | \  ___/|  | \/  |    |   |  |  /   |  \    <  \___ \ 
9 |__|_|  /__| |___|  /  \______  /____/ |__|  |__|  \___  >__|     |____|   |____/|___|  /__|_ \/____  >
10       \/          \/          \/                       \/                             \/     \/     \/ 
11                                                                                                                        
12 
13 */
14 
15 pragma solidity ^0.8.9;
16 
17 
18 
19 
20 
21 
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 
44 
45 
46 /**
47  * @dev Interface of the ERC165 standard, as defined in the
48  * https://eips.ethereum.org/EIPS/eip-165[EIP].
49  *
50  * Implementers can declare support of contract interfaces, which can then be
51  * queried by others ({ERC165Checker}).
52  *
53  * For an implementation, see {ERC165}.
54  */
55 interface IERC165 {
56     /**
57      * @dev Returns true if this contract implements the interface defined by
58      * `interfaceId`. See the corresponding
59      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
60      * to learn more about how these ids are created.
61      *
62      * This function call must use less than 30 000 gas.
63      */
64     function supportsInterface(bytes4 interfaceId) external view returns (bool);
65 }
66 
67 
68 
69 
70 
71 /**
72  * @dev Required interface of an ERC721 compliant contract.
73  */
74 interface IERC721 is IERC165 {
75     /**
76      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
79 
80     /**
81      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
82      */
83     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
84 
85     /**
86      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
87      */
88     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
89 
90     /**
91      * @dev Returns the number of tokens in ``owner``'s account.
92      */
93     function balanceOf(address owner) external view returns (uint256 balance);
94 
95     /**
96      * @dev Returns the owner of the `tokenId` token.
97      *
98      * Requirements:
99      *
100      * - `tokenId` must exist.
101      */
102     function ownerOf(uint256 tokenId) external view returns (address owner);
103 
104     /**
105      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
106      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must exist and be owned by `from`.
113      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
114      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
115      *
116      * Emits a {Transfer} event.
117      */
118     function safeTransferFrom(
119         address from,
120         address to,
121         uint256 tokenId
122     ) external;
123 
124     /**
125      * @dev Transfers `tokenId` token from `from` to `to`.
126      *
127      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
128      *
129      * Requirements:
130      *
131      * - `from` cannot be the zero address.
132      * - `to` cannot be the zero address.
133      * - `tokenId` token must be owned by `from`.
134      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transferFrom(
139         address from,
140         address to,
141         uint256 tokenId
142     ) external;
143 
144     /**
145      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
146      * The approval is cleared when the token is transferred.
147      *
148      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
149      *
150      * Requirements:
151      *
152      * - The caller must own the token or be an approved operator.
153      * - `tokenId` must exist.
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address to, uint256 tokenId) external;
158 
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId) external view returns (address operator);
167 
168     /**
169      * @dev Approve or remove `operator` as an operator for the caller.
170      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
171      *
172      * Requirements:
173      *
174      * - The `operator` cannot be the caller.
175      *
176      * Emits an {ApprovalForAll} event.
177      */
178     function setApprovalForAll(address operator, bool _approved) external;
179 
180     /**
181      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
182      *
183      * See {setApprovalForAll}
184      */
185     function isApprovedForAll(address owner, address operator) external view returns (bool);
186 
187     /**
188      * @dev Safely transfers `tokenId` token from `from` to `to`.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must exist and be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
197      *
198      * Emits a {Transfer} event.
199      */
200     function safeTransferFrom(
201         address from,
202         address to,
203         uint256 tokenId,
204         bytes calldata data
205     ) external;
206 }
207 
208 
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 
257 
258 
259 
260 
261 /**
262  * @dev Implementation of the {IERC165} interface.
263  *
264  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
265  * for the additional interface id that will be supported. For example:
266  *
267  * ```solidity
268  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
269  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
270  * }
271  * ```
272  *
273  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
274  */
275 abstract contract ERC165 is IERC165 {
276     /**
277      * @dev See {IERC165-supportsInterface}.
278      */
279     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
280         return interfaceId == type(IERC165).interfaceId;
281     }
282 }
283 
284 
285 
286 
287 
288 
289 /**
290  * @dev Contract module which provides a basic access control mechanism, where
291  * there is an account (an owner) that can be granted exclusive access to
292  * specific functions.
293  *
294  * By default, the owner account will be the one that deploys the contract. This
295  * can later be changed with {transferOwnership}.
296  *
297  * This module is used through inheritance. It will make available the modifier
298  * `onlyOwner`, which can be applied to your functions to restrict their use to
299  * the owner.
300  */
301 abstract contract Ownable is Context {
302     address private _owner;
303 
304     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
305 
306     /**
307      * @dev Initializes the contract setting the deployer as the initial owner.
308      */
309     constructor() {
310         _transferOwnership(_msgSender());
311     }
312 
313     /**
314      * @dev Returns the address of the current owner.
315      */
316     function owner() public view virtual returns (address) {
317         return _owner;
318     }
319 
320     /**
321      * @dev Throws if called by any account other than the owner.
322      */
323     modifier onlyOwner() {
324         require(owner() == _msgSender(), "Ownable: caller is not the owner");
325         _;
326     }
327 
328     /**
329      * @dev Leaves the contract without owner. It will not be possible to call
330      * `onlyOwner` functions anymore. Can only be called by the current owner.
331      *
332      * NOTE: Renouncing ownership will leave the contract without an owner,
333      * thereby removing any functionality that is only available to the owner.
334      */
335     function renounceOwnership() public virtual onlyOwner {
336         _transferOwnership(address(0));
337     }
338 
339     function isContractOwner() public virtual returns (bool) {
340         return (_owner == _msgSender());
341     }
342 
343     /**
344      * @dev Transfers ownership of the contract to a new account (`newOwner`).
345      * Can only be called by the current owner.
346      */
347     function transferOwnership(address newOwner) public virtual onlyOwner {
348         require(newOwner != address(0), "Ownable: new owner is the zero address");
349         _transferOwnership(newOwner);
350     }
351 
352     /**
353      * @dev Transfers ownership of the contract to a new account (`newOwner`).
354      * Internal function without access restriction.
355      */
356     function _transferOwnership(address newOwner) internal virtual {
357         address oldOwner = _owner;
358         _owner = newOwner;
359         emit OwnershipTransferred(oldOwner, newOwner);
360     }
361 }
362 
363 
364 
365 
366 abstract contract Target721 { 
367     function ownerOf(uint256 tokenId) public view virtual returns (address);
368     function balanceOf(address owner) public view virtual returns (uint256);
369     function getApproved(uint256 tokenId) public view virtual returns (address);
370     function isApprovedForAll(address owner, address operator) public view virtual returns (bool);
371 }
372 
373 
374 
375 
376 /**
377  * @title mfnGutterPunks contract.
378  * @author The Gutter Punks team.
379  *
380  */
381 contract mfnGutterPunks is Context, ERC165, IERC721, IERC721Metadata, Ownable {
382     using Address for address;
383     using Strings for uint256;
384 
385     // Token name
386     string private _name;
387 
388     // Token symbol
389     string private _symbol;
390 
391     // Mapping from token ID to owner address
392     mapping(uint256 => address) private _owners;
393 
394     // Mapping from token ID to approved address
395     mapping(uint256 => address) private _tokenApprovals;
396 
397     // Mapping from owner to operator approvals
398     mapping(address => mapping(address => bool)) private _operatorApprovals;
399 
400     string internal _baseTokenURI;
401     string internal _contractURI;
402 
403     uint256 internal _totalSupply;
404     uint256 internal MAX_TOKEN_ID; 
405     string public constant TOKEN_URI_EXTENSION = ".json";
406     uint256 public constant LAST_MFER_TOKEN = 10020;
407     uint256 public constant MAX_SUPPLY = 15021;
408 	
409 	bool internal _burnAirdrop = false;
410 	bool internal _finalize = false; 
411 	address internal _burnAddress = 0x000000000000000000000000000000000000dEaD;
412 	
413 	address internal _mferAddress = 0x79FCDEF22feeD20eDDacbB2587640e45491b757f;
414 	address internal _gpAddress = 0x9a54988016E97Fdc388D1b084BcbfE32De91b70c; 
415 	
416     Target721 _mferTarget = Target721(0x79FCDEF22feeD20eDDacbB2587640e45491b757f);
417     Target721 _gpTarget = Target721(0x9a54988016E97Fdc388D1b084BcbfE32De91b70c);
418 
419 
420     constructor(string memory name_, string memory symbol_) {
421         _name = name_;
422         _symbol = symbol_;
423     }
424 
425     function name() public view virtual override returns (string memory) {
426         return _name;
427     }
428 
429     function symbol() public view virtual override returns (string memory) {
430         return _symbol;
431     }
432 
433     function setName(string memory name_) external onlyOwner {
434         require(!_finalize, "Cannot change name after finalized.");
435         _name = name_;
436     }
437 
438     function tokenURI(uint256 tokenId) public view override returns (string memory) {
439         require(
440             _exists(tokenId),
441             "ERC721Metadata: URI query for nonexistent token"
442         );
443 		
444 		string memory baseURI = _baseTokenURI;
445         return bytes(baseURI).length > 0
446             ? string(abi.encodePacked(baseURI, tokenId.toString(), TOKEN_URI_EXTENSION))
447             : "";
448     }
449 
450     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
451         return
452             interfaceId == type(IERC721).interfaceId ||
453             interfaceId == type(IERC721Metadata).interfaceId ||
454             super.supportsInterface(interfaceId);
455     }
456 
457     function setTargetMFERSContract(address contractAddress) external onlyOwner { 
458 		require(!_finalize, "Cannot set target contract after finalized."); 
459 		_mferAddress = contractAddress;
460         _mferTarget = Target721(contractAddress);
461     }
462 
463     function setGutterPunksTargetContract(address contractAddress) external onlyOwner { 
464 		require(!_finalize, "Cannot set target contract after finalized."); 
465 		_gpAddress = contractAddress;
466         _gpTarget = Target721(contractAddress);
467     }
468 
469     function setURI(string calldata baseURI) external onlyOwner {
470 		require(!_finalize, "Cannot edit base URI after finalized."); 
471         _baseTokenURI = baseURI;
472     }
473 
474     function setBurnAirdrop(bool setBurn) external onlyOwner {
475 		require(!_finalize, "Cannot burn entire contract after finalized."); 
476         _burnAirdrop = setBurn;
477     }
478 
479     function setFinalize(bool finalize) external onlyOwner {
480 		require(!_finalize, "Cannot change finalize after finalized."); 
481         _finalize = finalize;
482     }
483 
484     function airdrop(address[] calldata recipients) external onlyOwner {
485 		require(!_finalize, "Cannot airdrop after finalized."); 
486         uint256 startingSupply = _totalSupply;
487 		require(startingSupply + recipients.length <= MAX_SUPPLY, "Cannot airdrop more than max supply.");
488 		
489 
490         // Update the total supply.
491         _totalSupply = startingSupply + recipients.length;
492 
493         // Note: First token has ID #0.
494         for (uint256 i = 0; i < recipients.length; i++) {
495             _mint(recipients[i], startingSupply + i);
496         }
497         if((startingSupply + recipients.length - 1) > MAX_TOKEN_ID) { MAX_TOKEN_ID = (startingSupply + recipients.length - 1); } 
498     }
499 
500     function bifurcateToken(uint256[] calldata tokenId) external { 
501 		bool _isContractOwner = isContractOwner();
502 	    for(uint256 i = 0;i < tokenId.length;i++) {
503 			address owner = ownerOf(tokenId[i]);
504 			require(owner == _msgSender() || _isContractOwner, "Must own token to bifurcate.");
505 			unchecked { 
506 			   _owners[tokenId[i]] = owner;
507 			}
508 		}
509     }
510 	
511 	function tokenBifurcated(uint256 tokenId) public view returns (bool) {
512 		return tokenId > LAST_MFER_TOKEN || _owners[tokenId] != address(0);
513 	}
514 	
515     function burn(uint256 tokenId) external { 
516         _burn(tokenId);
517     }
518 
519     function emitTransfers(uint256[] calldata tokenId, address[] calldata from, address[] calldata to) external onlyOwner { 
520        require(tokenId.length == from.length && from.length == to.length, "Arrays do not match.");
521        for(uint256 i = 0;i < tokenId.length;i++) { 
522            if(_owners[tokenId[i]] == address(0)) { 
523               emit Transfer(from[i], to[i], tokenId[i]);
524            } 
525        } 
526     }
527 
528     function approve(address to, uint256 tokenId) public virtual override {
529         address owner = ownerOf(tokenId);
530         require(to != owner, "ERC721: approval to current owner");
531 
532         require(
533             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
534             "ERC721: approve caller is not owner nor approved for all"
535         );
536 
537         _approve(to, tokenId);
538     }
539 
540     function _approve(address to, uint256 tokenId) internal virtual {
541         _tokenApprovals[tokenId] = to;
542         emit Approval(ownerOf(tokenId), to, tokenId);
543     }
544 
545     function getApproved(uint256 tokenId) public view virtual override returns (address) {
546         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
547         address approved = _tokenApprovals[tokenId];
548         return approved;
549     }
550 
551     function _exists(uint256 tokenId) internal view virtual returns (bool) {
552 		if(tokenId >= _totalSupply) { return false; } 
553 		else if(tokenId > (MAX_SUPPLY-1)) { return false; }
554 		else if(_owners[tokenId] == _burnAddress) { return false; }
555 		else if(_owners[tokenId] != address(0)) { return true; }
556 		else if(tokenId <= LAST_MFER_TOKEN) {
557 			return _mferTarget.ownerOf(tokenId) != address(0);
558 		} else { 
559 			return _gpTarget.ownerOf((tokenId-LAST_MFER_TOKEN)) != address(0);
560 		}
561     }
562 
563     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
564         address owner = _ownerOf(tokenId);
565         require(owner != address(0), "ERC721: owner query for nonexistent token");
566         return owner;
567     }
568 
569     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
570         address owner = _owners[tokenId];
571         if(owner == address(0) && !_burnAirdrop) {
572 		   if(tokenId <= LAST_MFER_TOKEN) {
573               try _mferTarget.ownerOf(tokenId) returns (address result) { owner = result; } catch { owner = address(0); }
574 		   } else { 
575               try _gpTarget.ownerOf((tokenId-LAST_MFER_TOKEN)) returns (address result) { owner = result; } catch { owner = address(0); }
576 		   }
577         }
578         return owner;
579     }
580 
581     function setApprovalForAll(address operator, bool approved) public virtual override {
582         _setApprovalForAll(_msgSender(), operator, approved);
583     }
584 
585     function _setApprovalForAll(
586         address owner,
587         address operator,
588         bool approved
589     ) internal virtual {
590         require(owner != operator, "ERC721: approve to caller");
591         _operatorApprovals[owner][operator] = approved;
592         emit ApprovalForAll(owner, operator, approved);
593     }
594 
595     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
596         return _operatorApprovals[owner][operator];
597     }
598 
599     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
600         address owner = ownerOf(tokenId);
601         return (spender == owner || _tokenApprovals[tokenId] == spender || isApprovedForAll(owner, spender));
602     }
603 
604     function transferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) public virtual override {
609         //solhint-disable-next-line max-line-length
610         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
611 
612         _transfer(from, to, tokenId);
613     }
614 
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) public virtual override {
620         safeTransferFrom(from, to, tokenId, "");
621     }
622 
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId,
627         bytes memory _data
628     ) public virtual override {
629         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
630         _safeTransfer(from, to, tokenId, _data);
631     }
632 
633     function _safeTransfer(
634         address from,
635         address to,
636         uint256 tokenId,
637         bytes memory _data
638     ) internal virtual {
639         _transfer(from, to, tokenId);
640         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
641     }
642 
643     function _transfer(
644         address from,
645         address to,
646         uint256 tokenId
647     ) internal virtual {
648         require(_ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
649         require(to != address(0), "ERC721: transfer to the zero address");
650 
651         _beforeTokenTransfer(from, to, tokenId);
652 
653         // Clear approvals from the previous owner
654         _approve(address(0), tokenId);
655        
656         unchecked { 
657            _owners[tokenId] = to;
658         }
659 
660         emit Transfer(from, to, tokenId);
661     }
662 
663     function balanceOf(address owner) public view virtual override returns (uint256) {
664         require(owner != address(0), "ERC721: balance query for the zero address");
665         uint256 balance = 0;
666         for(uint256 i = 0;i <= MAX_TOKEN_ID;i++) {
667            if(_ownerOf(i) == owner) { balance++; }
668         }
669         return balance;
670     }
671 
672     function _mint(address to, uint256 tokenId) internal virtual {
673         emit Transfer(address(0), to, tokenId);
674     }
675 
676     function _burn(uint256 tokenId) internal virtual {
677         address owner = ownerOf(tokenId);
678 		address burnAddress = _burnAddress;
679         require(owner == _msgSender(), "Must own token to burn.");
680 
681         _beforeTokenTransfer(owner, burnAddress, tokenId);
682 
683         // Clear approvals
684         _approve(address(0), tokenId);
685 		_owners[tokenId] = burnAddress;
686 
687         emit Transfer(owner, burnAddress, tokenId);
688     }
689 
690     function _checkOnERC721Received(
691         address from,
692         address to,
693         uint256 tokenId,
694         bytes memory _data
695     ) private returns (bool) {
696         if (to.isContract()) {
697             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
698                 return retval == IERC721Receiver.onERC721Received.selector;
699             } catch (bytes memory reason) {
700                 if (reason.length == 0) {
701                     revert("ERC721: transfer to non ERC721Receiver implementer");
702                 } else {
703                     assembly {
704                         revert(add(32, reason), mload(reason))
705                     }
706                 }
707             }
708         } else {
709             return true;
710         }
711     }
712 
713     function _beforeTokenTransfer(
714         address from,
715         address to,
716         uint256 tokenId
717     ) internal virtual {}
718 
719 
720     function contractURI() external view returns (string memory) {
721         return _contractURI;
722     }
723 
724     function totalSupply() public view returns (uint256) {
725         return _totalSupply;
726     }
727 	
728 	function parentTokenTransferred(address from, uint256 tokenId) public virtual { 
729 		require(_msgSender() == _gpAddress, "This function must be called by the airdrop token parent.");
730 		// Only update token owner if current owner is unset
731 		tokenId = tokenId + LAST_MFER_TOKEN; // offset by mfers airdrop tokens - GP #1 -> MFNGP #10021
732 		if(tokenId < MAX_SUPPLY && _owners[tokenId] == address(0)) { _owners[tokenId] = from; }
733 	}
734 }
735 
736 
737 
738 
739 
740 
741 /**
742  * @dev String operations.
743  */
744 library Strings {
745     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
746 
747     /**
748      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
749      */
750     function toString(uint256 value) internal pure returns (string memory) {
751         // Inspired by OraclizeAPI's implementation - MIT licence
752         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
753 
754         if (value == 0) {
755             return "0";
756         }
757         uint256 temp = value;
758         uint256 digits;
759         while (temp != 0) {
760             digits++;
761             temp /= 10;
762         }
763         bytes memory buffer = new bytes(digits);
764         while (value != 0) {
765             digits -= 1;
766             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
767             value /= 10;
768         }
769         return string(buffer);
770     }
771 
772     /**
773      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
774      */
775     function toHexString(uint256 value) internal pure returns (string memory) {
776         if (value == 0) {
777             return "0x00";
778         }
779         uint256 temp = value;
780         uint256 length = 0;
781         while (temp != 0) {
782             length++;
783             temp >>= 8;
784         }
785         return toHexString(value, length);
786     }
787 
788     /**
789      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
790      */
791     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
792         bytes memory buffer = new bytes(2 * length + 2);
793         buffer[0] = "0";
794         buffer[1] = "x";
795         for (uint256 i = 2 * length + 1; i > 1; --i) {
796             buffer[i] = _HEX_SYMBOLS[value & 0xf];
797             value >>= 4;
798         }
799         require(value == 0, "Strings: hex length insufficient");
800         return string(buffer);
801     }
802 }
803 
804 
805 
806 
807 
808 /**
809  * @dev Collection of functions related to the address type
810  */
811 library Address {
812     /**
813      * @dev Returns true if `account` is a contract.
814      *
815      * [IMPORTANT]
816      * ====
817      * It is unsafe to assume that an address for which this function returns
818      * false is an externally-owned account (EOA) and not a contract.
819      *
820      * Among others, `isContract` will return false for the following
821      * types of addresses:
822      *
823      *  - an externally-owned account
824      *  - a contract in construction
825      *  - an address where a contract will be created
826      *  - an address where a contract lived, but was destroyed
827      * ====
828      */
829     function isContract(address account) internal view returns (bool) {
830         // This method relies on extcodesize, which returns 0 for contracts in
831         // construction, since the code is only stored at the end of the
832         // constructor execution.
833 
834         uint256 size;
835         assembly {
836             size := extcodesize(account)
837         }
838         return size > 0;
839     }
840 
841     /**
842      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
843      * `recipient`, forwarding all available gas and reverting on errors.
844      *
845      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
846      * of certain opcodes, possibly making contracts go over the 2300 gas limit
847      * imposed by `transfer`, making them unable to receive funds via
848      * `transfer`. {sendValue} removes this limitation.
849      *
850      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
851      *
852      * IMPORTANT: because control is transferred to `recipient`, care must be
853      * taken to not create reentrancy vulnerabilities. Consider using
854      * {ReentrancyGuard} or the
855      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
856      */
857     function sendValue(address payable recipient, uint256 amount) internal {
858         require(address(this).balance >= amount, "Address: insufficient balance");
859 
860         (bool success, ) = recipient.call{value: amount}("");
861         require(success, "Address: unable to send value, recipient may have reverted");
862     }
863 
864     /**
865      * @dev Performs a Solidity function call using a low level `call`. A
866      * plain `call` is an unsafe replacement for a function call: use this
867      * function instead.
868      *
869      * If `target` reverts with a revert reason, it is bubbled up by this
870      * function (like regular Solidity function calls).
871      *
872      * Returns the raw returned data. To convert to the expected return value,
873      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
874      *
875      * Requirements:
876      *
877      * - `target` must be a contract.
878      * - calling `target` with `data` must not revert.
879      *
880      * _Available since v3.1._
881      */
882     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
883         return functionCall(target, data, "Address: low-level call failed");
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
888      * `errorMessage` as a fallback revert reason when `target` reverts.
889      *
890      * _Available since v3.1._
891      */
892     function functionCall(
893         address target,
894         bytes memory data,
895         string memory errorMessage
896     ) internal returns (bytes memory) {
897         return functionCallWithValue(target, data, 0, errorMessage);
898     }
899 
900     /**
901      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
902      * but also transferring `value` wei to `target`.
903      *
904      * Requirements:
905      *
906      * - the calling contract must have an ETH balance of at least `value`.
907      * - the called Solidity function must be `payable`.
908      *
909      * _Available since v3.1._
910      */
911     function functionCallWithValue(
912         address target,
913         bytes memory data,
914         uint256 value
915     ) internal returns (bytes memory) {
916         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
917     }
918 
919     /**
920      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
921      * with `errorMessage` as a fallback revert reason when `target` reverts.
922      *
923      * _Available since v3.1._
924      */
925     function functionCallWithValue(
926         address target,
927         bytes memory data,
928         uint256 value,
929         string memory errorMessage
930     ) internal returns (bytes memory) {
931         require(address(this).balance >= value, "Address: insufficient balance for call");
932         require(isContract(target), "Address: call to non-contract");
933 
934         (bool success, bytes memory returndata) = target.call{value: value}(data);
935         return verifyCallResult(success, returndata, errorMessage);
936     }
937 
938     /**
939      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
940      * but performing a static call.
941      *
942      * _Available since v3.3._
943      */
944     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
945         return functionStaticCall(target, data, "Address: low-level static call failed");
946     }
947 
948     /**
949      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
950      * but performing a static call.
951      *
952      * _Available since v3.3._
953      */
954     function functionStaticCall(
955         address target,
956         bytes memory data,
957         string memory errorMessage
958     ) internal view returns (bytes memory) {
959         require(isContract(target), "Address: static call to non-contract");
960 
961         (bool success, bytes memory returndata) = target.staticcall(data);
962         return verifyCallResult(success, returndata, errorMessage);
963     }
964 
965     /**
966      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
967      * but performing a delegate call.
968      *
969      * _Available since v3.4._
970      */
971     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
972         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
973     }
974 
975     /**
976      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
977      * but performing a delegate call.
978      *
979      * _Available since v3.4._
980      */
981     function functionDelegateCall(
982         address target,
983         bytes memory data,
984         string memory errorMessage
985     ) internal returns (bytes memory) {
986         require(isContract(target), "Address: delegate call to non-contract");
987 
988         (bool success, bytes memory returndata) = target.delegatecall(data);
989         return verifyCallResult(success, returndata, errorMessage);
990     }
991 
992     /**
993      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
994      * revert reason using the provided one.
995      *
996      * _Available since v4.3._
997      */
998     function verifyCallResult(
999         bool success,
1000         bytes memory returndata,
1001         string memory errorMessage
1002     ) internal pure returns (bytes memory) {
1003         if (success) {
1004             return returndata;
1005         } else {
1006             // Look for revert reason and bubble it up if present
1007             if (returndata.length > 0) {
1008                 // The easiest way to bubble the revert reason is using memory via assembly
1009 
1010                 assembly {
1011                     let returndata_size := mload(returndata)
1012                     revert(add(32, returndata), returndata_size)
1013                 }
1014             } else {
1015                 revert(errorMessage);
1016             }
1017         }
1018     }
1019 }