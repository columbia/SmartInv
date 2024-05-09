1 // Sources flattened with hardhat v2.7.0 https://hardhat.org
2 
3 // File sol-temple/src/tokens/ERC721.sol@v1.2.1
4 
5 pragma solidity >=0.8.0 <0.9.0;
6 /* ___       ___
7 *  \  \     /  /
8 *   \  \   /  /
9      \  \ /  /
10       \     /
11        |   |
12        |   |     
13        |   |    /'__`\  */
14  /*    |   |   (  ___/  */
15  /*    |___|   `\____)  */
16       
17 
18 /**
19  * @title ERC721
20  * @notice A complete ERC721 implementation including metadata and enumerable
21  * functions. Completely gas optimized and extensible.
22  */
23 abstract contract ERC721 {
24   /*         _           _            */
25   /*        ( )_        ( )_          */
26   /*    ___ | ,_)   _ _ | ,_)   __    */
27   /*  /',__)| |   /'__` )| |   /'__`\  */
28   /*  \__, \| |_ ( (_| || |_ (  ___/  */
29   /*  (____/`\__)`\__,_)`\__)`\____)  */
30 
31   /// @notice See {ERC721-Transfer}.
32   event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
33   /// @notice See {ERC721-Approval}.
34   event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
35   /// @notice See {ERC721-ApprovalForAll}.
36   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
37 
38   /// @notice See {ERC721Metadata-name}.
39   string public name;
40   /// @notice See {ERC721Metadata-symbol}.
41   string public symbol;
42 
43   /// @notice See {ERC721Enumerable-totalSupply}.
44   uint256 public totalSupply;
45 
46   /// @notice Array of all owners.
47   address[] private _owners;
48   /// @notice Mapping of all balances.
49   mapping(address => uint256) private _balanceOf;
50   /// @notice Mapping from token Id to it's approved address.
51   mapping(uint256 => address) private _tokenApprovals;
52   /// @notice Mapping of approvals between owner and operator.
53   mapping(address => mapping(address => bool)) private _isApprovedForAll;
54 
55   /*   _                            */
56   /*  (_ )                _         */
57   /*   | |    _      __  (_)   ___  */
58   /*   | |  /'_`\  /'_ `\| | /'___) */
59   /*   | | ( (_) )( (_) || |( (___  */
60   /*  (___)`\___/'`\__  |(_)`\____) */
61   /*              ( )_) |           */
62   /*               \___/'           */
63 
64   constructor(string memory name_, string memory symbol_) {
65     name = name_;
66     symbol = symbol_;
67   }
68 
69   /// @notice See {ERC721-balanceOf}.
70   function balanceOf(address account_) public view virtual returns (uint256) {
71     require(account_ != address(0), "ERC721: balance query for the zero address");
72     return _balanceOf[account_];
73   }
74 
75   /// @notice See {ERC721-ownerOf}.
76   function ownerOf(uint256 tokenId_) public view virtual returns (address) {
77     require(_exists(tokenId_), "ERC721: query for nonexistent token");
78     address owner = _owners[tokenId_];
79     return owner;
80   }
81 
82   /// @notice See {ERC721Metadata-tokenURI}.
83   function tokenURI(uint256) public view virtual returns (string memory);
84 
85   /// @notice See {ERC721-approve}.
86   function approve(address to_, uint256 tokenId_) public virtual {
87     address owner = ownerOf(tokenId_);
88     require(to_ != owner, "ERC721: approval to current owner");
89 
90     require(
91       msg.sender == owner || _isApprovedForAll[owner][msg.sender],
92       "ERC721: caller is not owner nor approved for all"
93     );
94 
95     _approve(to_, tokenId_);
96   }
97 
98   /// @notice See {ERC721-getApproved}.
99   function getApproved(uint256 tokenId_) public view virtual returns (address) {
100     require(_exists(tokenId_), "ERC721: query for nonexistent token");
101     return _tokenApprovals[tokenId_];
102   }
103 
104   /// @notice See {ERC721-setApprovalForAll}.
105   function setApprovalForAll(address operator_, bool approved_) public virtual {
106     _setApprovalForAll(msg.sender, operator_, approved_);
107   }
108 
109   /// @notice See {ERC721-isApprovedForAll}.
110   function isApprovedForAll(address account_, address operator_) public view virtual returns (bool) {
111     return _isApprovedForAll[account_][operator_];
112   }
113 
114   /// @notice See {ERC721-transferFrom}.
115   function transferFrom(
116     address from_,
117     address to_,
118     uint256 tokenId_
119   ) public virtual {
120     require(_isApprovedOrOwner(msg.sender, tokenId_), "ERC721: transfer caller is not owner nor approved");
121     _transfer(from_, to_, tokenId_);
122   }
123 
124   /// @notice See {ERC721-safeTransferFrom}.
125   function safeTransferFrom(
126     address from_,
127     address to_,
128     uint256 tokenId_
129   ) public virtual {
130     safeTransferFrom(from_, to_, tokenId_, "");
131   }
132 
133   /// @notice See {ERC721-safeTransferFrom}.
134   function safeTransferFrom(
135     address from_,
136     address to_,
137     uint256 tokenId_,
138     bytes memory data_
139   ) public virtual {
140     require(_isApprovedOrOwner(msg.sender, tokenId_), "ERC721: transfer caller is not owner nor approved");
141     _safeTransfer(from_, to_, tokenId_, data_);
142   }
143 
144   /// @notice See {ERC721Enumerable.tokenOfOwnerByIndex}.
145   function tokenOfOwnerByIndex(address account_, uint256 index_) public view returns (uint256 tokenId) {
146     require(index_ < balanceOf(account_), "ERC721Enumerable: Index out of bounds");
147     uint256 count;
148     for (uint256 i; i < _owners.length; ++i) {
149       if (account_ == _owners[i]) {
150         if (count == index_) return i;
151         else count++;
152       }
153     }
154     revert("ERC721Enumerable: Index out of bounds");
155   }
156 
157   /// @notice See {ERC721Enumerable.tokenByIndex}.
158   function tokenByIndex(uint256 index_) public view virtual returns (uint256) {
159     require(index_ < _owners.length, "ERC721Enumerable: Index out of bounds");
160     return index_;
161   }
162 
163   /// @notice Returns a list of all token Ids owned by `owner`.
164   function walletOfOwner(address account_) public view returns (uint256[] memory) {
165     uint256 balance = balanceOf(account_);
166     uint256[] memory ids = new uint256[](balance);
167     for (uint256 i = 0; i < balance; i++) {
168       ids[i] = tokenOfOwnerByIndex(account_, i);
169     }
170     return ids;
171   }
172 
173   /*             _                               _    */
174   /*   _        ( )_                            (_ )  */
175   /*  (_)  ___  | ,_)   __   _ __   ___     _ _  | |  */
176   /*  | |/' _ `\| |   /'__`\( '__)/' _ `\ /'__` ) | |  */
177   /*  | || ( ) || |_ (  ___/| |   | ( ) |( (_| | | |  */
178   /*  (_)(_) (_)`\__)`\____)(_)   (_) (_)`\__,_)(___) */
179 
180   /**
181    * @notice Safely transfers `tokenId_` token from `from_` to `to`, checking first that contract recipients
182    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
183    */
184   function _safeTransfer(
185     address from_,
186     address to_,
187     uint256 tokenId_,
188     bytes memory data_
189   ) internal virtual {
190     _transfer(from_, to_, tokenId_);
191     _checkOnERC721Received(from_, to_, tokenId_, data_);
192   }
193 
194   /// @notice Returns whether `tokenId_` exists.
195   function _exists(uint256 tokenId_) internal view virtual returns (bool) {
196     return tokenId_ < _owners.length && _owners[tokenId_] != address(0);
197   }
198 
199   /// @notice Returns whether `spender_` is allowed to manage `tokenId`.
200   function _isApprovedOrOwner(address spender_, uint256 tokenId_) internal view virtual returns (bool) {
201     require(_exists(tokenId_), "ERC721: query for nonexistent token");
202     address owner = _owners[tokenId_];
203     return (spender_ == owner || getApproved(tokenId_) == spender_ || isApprovedForAll(owner, spender_));
204   }
205 
206   /// @notice Safely mints `tokenId_` and transfers it to `to`.
207   function _safeMint(address to_, uint256 tokenId_) internal virtual {
208     _safeMint(to_, tokenId_, "");
209   }
210 
211   /**
212    * @notice Same as {_safeMint}, but with an additional `data_` parameter which is
213    * forwarded in {ERC721Receiver-onERC721Received} to contract recipients.
214    */
215   function _safeMint(
216     address to_,
217     uint256 tokenId_,
218     bytes memory data_
219   ) internal virtual {
220     _mint(to_, tokenId_);
221     _checkOnERC721Received(address(0), to_, tokenId_, data_);
222   }
223 
224   /// @notice Mints `tokenId_` and transfers it to `to_`.
225   function _mint(address to_, uint256 tokenId_) internal virtual {
226     require(!_exists(tokenId_), "ERC721: token already minted");
227 
228     _beforeTokenTransfer(address(0), to_, tokenId_);
229 
230     _owners.push(to_);
231     totalSupply++;
232     unchecked {
233       _balanceOf[to_]++;
234     }
235 
236     emit Transfer(address(0), to_, tokenId_);
237     _afterTokenTransfer(address(0), to_, tokenId_);
238   }
239 
240   /// @notice Destroys `tokenId`. The approval is cleared when the token is burned.
241   function _burn(uint256 tokenId_) internal virtual {
242     address owner = ownerOf(tokenId_);
243 
244     _beforeTokenTransfer(owner, address(0), tokenId_);
245 
246     // Clear approvals
247     _approve(address(0), tokenId_);
248     delete _owners[tokenId_];
249     totalSupply--;
250     _balanceOf[owner]--;
251 
252     emit Transfer(owner, address(0), tokenId_);
253     _afterTokenTransfer(owner, address(0), tokenId_);
254   }
255 
256   /// @notice Transfers `tokenId_` from `from_` to `to`.
257   function _transfer(
258     address from_,
259     address to_,
260     uint256 tokenId_
261   ) internal virtual {
262     require(_owners[tokenId_] == from_, "ERC721: transfer of token that is not own");
263 
264     _beforeTokenTransfer(from_, to_, tokenId_);
265 
266     // Clear approvals from the previous owner
267     _approve(address(0), tokenId_);
268 
269     _owners[tokenId_] = to_;
270     unchecked {
271       _balanceOf[from_]--;
272       _balanceOf[to_]++;
273     }
274 
275     emit Transfer(from_, to_, tokenId_);
276     _afterTokenTransfer(from_, to_, tokenId_);
277   }
278 
279   /// @notice Approve `to_` to operate on `tokenId_`
280   function _approve(address to_, uint256 tokenId_) internal virtual {
281     _tokenApprovals[tokenId_] = to_;
282     emit Approval(_owners[tokenId_], to_, tokenId_);
283   }
284 
285   /// @notice Approve `operator_` to operate on all of `account_` tokens.
286   function _setApprovalForAll(
287     address account_,
288     address operator_,
289     bool approved_
290   ) internal virtual {
291     require(account_ != operator_, "ERC721: approve to caller");
292     _isApprovedForAll[account_][operator_] = approved_;
293     emit ApprovalForAll(account_, operator_, approved_);
294   }
295 
296   /// @notice ERC721Receiver callback checking and calling helper.
297   function _checkOnERC721Received(
298     address from_,
299     address to_,
300     uint256 tokenId_,
301     bytes memory data_
302   ) private {
303     if (to_.code.length > 0) {
304       try IERC721Receiver(to_).onERC721Received(msg.sender, from_, tokenId_, data_) returns (bytes4 returned) {
305         require(returned == 0x150b7a02, "ERC721: safe transfer to non ERC721Receiver implementation");
306       } catch (bytes memory reason) {
307         if (reason.length == 0) {
308           revert("ERC721: safe transfer to non ERC721Receiver implementation");
309         } else {
310           assembly {
311             revert(add(32, reason), mload(reason))
312           }
313         }
314       }
315     }
316   }
317 
318   /// @notice Hook that is called before any token transfer.
319   function _beforeTokenTransfer(
320     address from_,
321     address to_,
322     uint256 tokenId_
323   ) internal virtual {}
324 
325   /// @notice Hook that is called after any token transfer.
326   function _afterTokenTransfer(
327     address from_,
328     address to_,
329     uint256 tokenId_
330   ) internal virtual {}
331 
332   /*    ___  _   _  _ _      __   _ __  */
333   /*  /',__)( ) ( )( '_`\  /'__`\( '__) */
334   /*  \__, \| (_) || (_) )(  ___/| |    */
335   /*  (____/`\___/'| ,__/'`\____)(_)    */
336   /*               | |                  */
337   /*               (_)                  */
338 
339   /// @notice See {IERC165-supportsInterface}.
340   function supportsInterface(bytes4 interfaceId_) public view virtual returns (bool) {
341     return
342       interfaceId_ == 0x80ac58cd || // ERC721
343       interfaceId_ == 0x5b5e139f || // ERC721Metadata
344       interfaceId_ == 0x780e9d63 || // ERC721Enumerable
345       interfaceId_ == 0x01ffc9a7; // ERC165
346   }
347 }
348 
349 interface IERC721Receiver {
350   function onERC721Received(
351     address operator,
352     address from,
353     uint256 tokenId,
354     bytes memory data
355   ) external returns (bytes4);
356 }
357 
358 
359 // File sol-temple/src/utils/Auth.sol@v1.2.1
360 
361 pragma solidity >=0.8.0 <0.9.0;
362 
363 /**
364  * @title Auth
365  * @notice Just a simple authing system.
366  */
367 abstract contract Auth {
368   /*         _           _            */
369   /*        ( )_        ( )_          */
370   /*    ___ | ,_)   _ _ | ,_)   __    */
371   /*  /',__)| |   /'_` )| |   /'__`\  */
372   /*  \__, \| |_ ( (_| || |_ (  ___/  */
373   /*  (____/`\__)`\__,_)`\__)`\____)  */
374 
375   /// @notice Emitted when the ownership is transfered.
376   event OwnershipTransfered(address indexed from, address indexed to);
377 
378   /// @notice Contract's owner address.
379   address public owner;
380 
381   /// @notice A simple modifier just to check whether the sender is the owner.
382   modifier onlyOwner() {
383     require(msg.sender == owner, "Auth: sender is not the owner");
384     _;
385   }
386 
387   /*   _                            */
388   /*  (_ )                _         */
389   /*   | |    _      __  (_)   ___  */
390   /*   | |  /'_`\  /'_ `\| | /'___) */
391   /*   | | ( (_) )( (_) || |( (___  */
392   /*  (___)`\___/'`\__  |(_)`\____) */
393   /*              ( )_) |           */
394   /*               \___/'           */
395 
396   constructor() {
397     _transferOwnership(msg.sender);
398   }
399 
400   /// @notice Set the owner address to `owner_`.
401   function transferOwnership(address owner_) public onlyOwner {
402     require(owner != owner_, "Auth: transfering ownership to current owner");
403     _transferOwnership(owner_);
404   }
405 
406   /// @notice Set the owner address to `owner_`. Does not require anything
407   function _transferOwnership(address owner_) internal {
408     address oldOwner = owner;
409     owner = owner_;
410 
411     emit OwnershipTransfered(oldOwner, owner_);
412   }
413 }
414 
415 
416 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
417 
418 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev String operations.
424  */
425 library Strings {
426     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
427 
428     /**
429      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
430      */
431     function toString(uint256 value) internal pure returns (string memory) {
432         // Inspired by OraclizeAPI's implementation - MIT licence
433         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
434 
435         if (value == 0) {
436             return "0";
437         }
438         uint256 temp = value;
439         uint256 digits;
440         while (temp != 0) {
441             digits++;
442             temp /= 10;
443         }
444         bytes memory buffer = new bytes(digits);
445         while (value != 0) {
446             digits -= 1;
447             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
448             value /= 10;
449         }
450         return string(buffer);
451     }
452 
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
455      */
456     function toHexString(uint256 value) internal pure returns (string memory) {
457         if (value == 0) {
458             return "0x00";
459         }
460         uint256 temp = value;
461         uint256 length = 0;
462         while (temp != 0) {
463             length++;
464             temp >>= 8;
465         }
466         return toHexString(value, length);
467     }
468 
469     /**
470      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
471      */
472     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
473         bytes memory buffer = new bytes(2 * length + 2);
474         buffer[0] = "0";
475         buffer[1] = "x";
476         for (uint256 i = 2 * length + 1; i > 1; --i) {
477             buffer[i] = _HEX_SYMBOLS[value & 0xf];
478             value >>= 4;
479         }
480         require(value == 0, "Strings: hex length insufficient");
481         return string(buffer);
482     }
483 }
484 
485 
486 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
487 
488 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @dev Interface of the ERC20 standard as defined in the EIP.
494  */
495 interface IERC20 {
496     /**
497      * @dev Returns the amount of tokens in existence.
498      */
499     function totalSupply() external view returns (uint256);
500 
501     /**
502      * @dev Returns the amount of tokens owned by `account`.
503      */
504     function balanceOf(address account) external view returns (uint256);
505 
506     /**
507      * @dev Moves `amount` tokens from the caller's account to `recipient`.
508      *
509      * Returns a boolean value indicating whether the operation succeeded.
510      *
511      * Emits a {Transfer} event.
512      */
513     function transfer(address recipient, uint256 amount) external returns (bool);
514 
515     /**
516      * @dev Returns the remaining number of tokens that `spender` will be
517      * allowed to spend on behalf of `owner` through {transferFrom}. This is
518      * zero by default.
519      *
520      * This value changes when {approve} or {transferFrom} are called.
521      */
522     function allowance(address owner, address spender) external view returns (uint256);
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
526      *
527      * Returns a boolean value indicating whether the operation succeeded.
528      *
529      * IMPORTANT: Beware that changing an allowance with this method brings the risk
530      * that someone may use both the old and the new allowance by unfortunate
531      * transaction ordering. One possible solution to mitigate this race
532      * condition is to first reduce the spender's allowance to 0 and set the
533      * desired value afterwards:
534      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
535      *
536      * Emits an {Approval} event.
537      */
538     function approve(address spender, uint256 amount) external returns (bool);
539 
540     /**
541      * @dev Moves `amount` tokens from `sender` to `recipient` using the
542      * allowance mechanism. `amount` is then deducted from the caller's
543      * allowance.
544      *
545      * Returns a boolean value indicating whether the operation succeeded.
546      *
547      * Emits a {Transfer} event.
548      */
549     function transferFrom(
550         address sender,
551         address recipient,
552         uint256 amount
553     ) external returns (bool);
554 
555     /**
556      * @dev Emitted when `value` tokens are moved from one account (`from`) to
557      * another (`to`).
558      *
559      * Note that `value` may be zero.
560      */
561     event Transfer(address indexed from, address indexed to, uint256 value);
562 
563     /**
564      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
565      * a call to {approve}. `value` is the new allowance.
566      */
567     event Approval(address indexed owner, address indexed spender, uint256 value);
568 }
569 
570 
571 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
572 
573 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Interface of the ERC165 standard, as defined in the
579  * https://eips.ethereum.org/EIPS/eip-165[EIP].
580  *
581  * Implementers can declare support of contract interfaces, which can then be
582  * queried by others ({ERC165Checker}).
583  *
584  * For an implementation, see {ERC165}.
585  */
586 interface IERC165 {
587     /**
588      * @dev Returns true if this contract implements the interface defined by
589      * `interfaceId`. See the corresponding
590      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
591      * to learn more about how these ids are created.
592      *
593      * This function call must use less than 30 000 gas.
594      */
595     function supportsInterface(bytes4 interfaceId) external view returns (bool);
596 }
597 
598 
599 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
600 
601 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Required interface of an ERC721 compliant contract.
607  */
608 interface IERC721 is IERC165 {
609     /**
610      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
611      */
612     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
613 
614     /**
615      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
616      */
617     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
618 
619     /**
620      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
621      */
622     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
623 
624     /**
625      * @dev Returns the number of tokens in ``owner``'s account.
626      */
627     function balanceOf(address owner) external view returns (uint256 balance);
628 
629     /**
630      * @dev Returns the owner of the `tokenId` token.
631      *
632      * Requirements:
633      *
634      * - `tokenId` must exist.
635      */
636     function ownerOf(uint256 tokenId) external view returns (address owner);
637 
638     /**
639      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
640      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must exist and be owned by `from`.
647      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
648      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
649      *
650      * Emits a {Transfer} event.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external;
657 
658     /**
659      * @dev Transfers `tokenId` token from `from` to `to`.
660      *
661      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must be owned by `from`.
668      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
669      *
670      * Emits a {Transfer} event.
671      */
672     function transferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external;
677 
678     /**
679      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
680      * The approval is cleared when the token is transferred.
681      *
682      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
683      *
684      * Requirements:
685      *
686      * - The caller must own the token or be an approved operator.
687      * - `tokenId` must exist.
688      *
689      * Emits an {Approval} event.
690      */
691     function approve(address to, uint256 tokenId) external;
692 
693     /**
694      * @dev Returns the account approved for `tokenId` token.
695      *
696      * Requirements:
697      *
698      * - `tokenId` must exist.
699      */
700     function getApproved(uint256 tokenId) external view returns (address operator);
701 
702     /**
703      * @dev Approve or remove `operator` as an operator for the caller.
704      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
705      *
706      * Requirements:
707      *
708      * - The `operator` cannot be the caller.
709      *
710      * Emits an {ApprovalForAll} event.
711      */
712     function setApprovalForAll(address operator, bool _approved) external;
713 
714     /**
715      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
716      *
717      * See {setApprovalForAll}
718      */
719     function isApprovedForAll(address owner, address operator) external view returns (bool);
720 
721     /**
722      * @dev Safely transfers `tokenId` token from `from` to `to`.
723      *
724      * Requirements:
725      *
726      * - `from` cannot be the zero address.
727      * - `to` cannot be the zero address.
728      * - `tokenId` token must exist and be owned by `from`.
729      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
730      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
731      *
732      * Emits a {Transfer} event.
733      */
734     function safeTransferFrom(
735         address from,
736         address to,
737         uint256 tokenId,
738         bytes calldata data
739     ) external;
740 }
741 
742 
743 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.4.2
744 
745 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 /**
750  * @dev Required interface of an ERC1155 compliant contract, as defined in the
751  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
752  *
753  * _Available since v3.1._
754  */
755 interface IERC1155 is IERC165 {
756     /**
757      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
758      */
759     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
760 
761     /**
762      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
763      * transfers.
764      */
765     event TransferBatch(
766         address indexed operator,
767         address indexed from,
768         address indexed to,
769         uint256[] ids,
770         uint256[] values
771     );
772 
773     /**
774      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
775      * `approved`.
776      */
777     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
778 
779     /**
780      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
781      *
782      * If an {URI} event was emitted for `id`, the standard
783      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
784      * returned by {IERC1155MetadataURI-uri}.
785      */
786     event URI(string value, uint256 indexed id);
787 
788     /**
789      * @dev Returns the amount of tokens of token type `id` owned by `account`.
790      *
791      * Requirements:
792      *
793      * - `account` cannot be the zero address.
794      */
795     function balanceOf(address account, uint256 id) external view returns (uint256);
796 
797     /**
798      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
799      *
800      * Requirements:
801      *
802      * - `accounts` and `ids` must have the same length.
803      */
804     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
805         external
806         view
807         returns (uint256[] memory);
808 
809     /**
810      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
811      *
812      * Emits an {ApprovalForAll} event.
813      *
814      * Requirements:
815      *
816      * - `operator` cannot be the caller.
817      */
818     function setApprovalForAll(address operator, bool approved) external;
819 
820     /**
821      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
822      *
823      * See {setApprovalForAll}.
824      */
825     function isApprovedForAll(address account, address operator) external view returns (bool);
826 
827     /**
828      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
829      *
830      * Emits a {TransferSingle} event.
831      *
832      * Requirements:
833      *
834      * - `to` cannot be the zero address.
835      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
836      * - `from` must have a balance of tokens of type `id` of at least `amount`.
837      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
838      * acceptance magic value.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 id,
844         uint256 amount,
845         bytes calldata data
846     ) external;
847 
848     /**
849      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
850      *
851      * Emits a {TransferBatch} event.
852      *
853      * Requirements:
854      *
855      * - `ids` and `amounts` must have the same length.
856      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
857      * acceptance magic value.
858      */
859     function safeBatchTransferFrom(
860         address from,
861         address to,
862         uint256[] calldata ids,
863         uint256[] calldata amounts,
864         bytes calldata data
865     ) external;
866 }
867 
868 
869 // File contracts/Yeee.sol
870 
871 // SPDX-License-Identifier: MIT
872 pragma solidity 0.8.11;
873 
874 contract YeeDontDoNFTs is Auth, ERC721 {
875   using Strings for uint256;
876 
877   /// @notice Max supply.
878   uint256 public constant SUPPLY_MAX = 1000;
879   /// @notice Max amount per claim.
880   uint256 public constant SUPPLY_PER_TX = 3;
881 
882   /// @notice 0 = CLOSED, 1 = WHITELIST, 2 = PUBLIC.
883   uint256 public saleState;
884 
885   /// @notice OpenSea proxy registry.
886   address public opensea = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
887   /// @notice LooksRare marketplace transfer manager.
888   address public looksrare = 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e;
889   /// @notice Check if marketplaces pre-approve is enabled.
890   bool public marketplacesApproved = true;
891 
892   /// @notice Unrevelead URI.
893   string public unrevealedURI;
894   /// @notice Metadata base URI.
895   string public baseURI;
896   /// @notice Metadata base file extension.
897   string public baseExtension;
898 
899   constructor(string memory newUnrevealedURI) ERC721("YeeDontDoNFTs", "YEE") {
900     unrevealedURI = newUnrevealedURI;
901   }
902 
903   /// @notice Claim one or more tokens.
904   function mint(uint256 amount) external payable {
905     uint256 supply = totalSupply;
906     require(supply + amount <= SUPPLY_MAX, "Max supply exceeded");
907     if (msg.sender != owner) {
908       require(saleState == 1, "Public sale is not open");
909       require(amount > 0 && amount <= SUPPLY_PER_TX, "Invalid claim amount");
910       if (supply <= 1000) require(msg.value == 0, "Invalid ether amount");
911       else require(msg.value == 0.00 ether, "Invalid ether amount");
912     }
913 
914     for (uint256 i = 0; i < amount; i++) _safeMint(msg.sender, supply++);
915   }
916 
917   /// @notice See {IERC721-tokenURI}.
918   function tokenURI(uint256 id) public view override returns (string memory) {
919     require(_exists(id), "ERC721Metadata: query for nonexisting token");
920 
921     if (bytes(unrevealedURI).length > 0) return unrevealedURI;
922     return string(abi.encodePacked(baseURI, id.toString(), baseExtension));
923   }
924 
925   /// @notice Set baseURI to `newBaseURI`.
926   function setBaseURI(string memory newBaseURI, string memory newBaseExtension) external onlyOwner {
927     baseURI = newBaseURI;
928     baseExtension = newBaseExtension;
929     delete unrevealedURI;
930   }
931 
932   /// @notice Set unrevealedURI to `newUnrevealedURI`.
933   function setUnrevealedURI(string memory newUnrevealedURI) external onlyOwner {
934     unrevealedURI = newUnrevealedURI;
935     
936   }
937 
938   /// @notice Set saleState to `newSaleState`.
939   function setSaleState(uint256 newSaleState) external onlyOwner {
940     saleState = newSaleState;
941   }
942 
943   /// @notice Set opensea to `newOpensea`.
944   function setOpensea(address newOpensea) external onlyOwner {
945     opensea = newOpensea;
946   }
947 
948   /// @notice Set looksrare to `newLooksrare`.
949   function setLooksrare(address newLooksrare) external onlyOwner {
950     looksrare = newLooksrare;
951   }
952 
953   /// @notice Toggle pre-approve feature state for sender.
954   function toggleMarketplacesApproved() external onlyOwner {
955     marketplacesApproved = !marketplacesApproved;
956   }
957 
958   /// @notice Withdraw `value` of ether to the sender.
959   function withdraw(address payable to, uint256 amount) external onlyOwner {
960     to.transfer(amount);
961   }
962 
963   /// @notice Withdraw `value` of `token` to the sender.
964   function withdrawERC20(IERC20 token, uint256 value) external onlyOwner {
965     token.transfer(msg.sender, value);
966   }
967 
968   /// @notice Withdraw `id` of `token` to the sender.
969   function withdrawERC721(IERC721 token, uint256 id) external onlyOwner {
970     token.safeTransferFrom(address(this), msg.sender, id);
971   }
972 
973   /// @notice Withdraw `id` with `value` from `token` to the sender.
974   function withdrawERC1155(
975     IERC1155 token,
976     uint256 id,
977     uint256 value
978   ) external onlyOwner {
979     token.safeTransferFrom(address(this), msg.sender, id, value, "");
980   }
981 
982   /// @dev Modified for opensea and looksrare pre-approve so users can make truly gasless sales.
983   function isApprovedForAll(address owner, address operator) public view override returns (bool) {
984     if (!marketplacesApproved) return super.isApprovedForAll(owner, operator);
985 
986     return
987       operator == address(ProxyRegistry(opensea).proxies(owner)) ||
988       operator == looksrare ||
989       super.isApprovedForAll(owner, operator);
990   }
991 }
992 
993 contract OwnableDelegateProxy {}
994 
995 contract ProxyRegistry {
996   mapping(address => OwnableDelegateProxy) public proxies;
997 }