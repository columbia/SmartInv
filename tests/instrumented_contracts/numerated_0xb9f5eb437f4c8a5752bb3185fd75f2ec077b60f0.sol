1 // SPDX-License-Identifier: MIT
2 
3 //  _______  ______________________    _____  .__        __    _________ .__       ___.    
4 //  \      \ \_   _____/\__    ___/   /     \ |__| _____/  |_  \_   ___ \|  |  __ _\_ |__  
5 //  /   |   \ |    __)    |    |     /  \ /  \|  |/    \   __\ /    \  \/|  | |  |  \ __ \ 
6 // /    |    \|     \     |    |    /    Y    \  |   |  \  |   \     \___|  |_|  |  / \_\ \
7 // \____|__  /\___  /     |____|    \____|__  /__|___|  /__|    \______  /____/____/|___  /
8 //         \/     \/                        \/        \/               \/               \/ 
9 
10 // www.nftmintclub.com
11 
12 pragma solidity ^0.8.0;
13 
14 interface IERC165 {
15     function supportsInterface(bytes4 interfaceId) external view returns (bool);
16 }
17 
18 pragma solidity ^0.8.0;
19 
20 interface IERC721 is IERC165 {
21     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
22     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
23     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
24     function balanceOf(address owner) external view returns (uint256 balance);
25     function ownerOf(uint256 tokenId) external view returns (address owner);
26     function safeTransferFrom(
27         address from,
28         address to,
29         uint256 tokenId
30     ) external;
31     function transferFrom(
32         address from,
33         address to,
34         uint256 tokenId
35     ) external;
36     function approve(address to, uint256 tokenId) external;
37     function getApproved(uint256 tokenId) external view returns (address operator);
38     function setApprovalForAll(address operator, bool _approved) external;
39     function isApprovedForAll(address owner, address operator) external view returns (bool);
40     function safeTransferFrom(
41         address from,
42         address to,
43         uint256 tokenId,
44         bytes calldata data
45     ) external;
46 }
47 
48 pragma solidity ^0.8.0;
49 
50 interface IERC721Enumerable is IERC721 {
51     function totalSupply() external view returns (uint256);
52     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
53     function tokenByIndex(uint256 index) external view returns (uint256);
54 }
55 
56 pragma solidity ^0.8.0;
57 
58 abstract contract ERC165 is IERC165 {
59     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
60         return interfaceId == type(IERC165).interfaceId;
61     }
62 }
63 
64 pragma solidity ^0.8.0;
65 library Strings {
66     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
67     function toString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
100         bytes memory buffer = new bytes(2 * length + 2);
101         buffer[0] = "0";
102         buffer[1] = "x";
103         for (uint256 i = 2 * length + 1; i > 1; --i) {
104             buffer[i] = _HEX_SYMBOLS[value & 0xf];
105             value >>= 4;
106         }
107         require(value == 0, "Strings: hex length insufficient");
108         return string(buffer);
109     }
110 }
111 
112 pragma solidity ^0.8.0;
113 library Address {
114     function isContract(address account) internal view returns (bool) {
115         uint256 size;
116         assembly {
117             size := extcodesize(account)
118         }
119         return size > 0;
120     }
121     function sendValue(address payable recipient, uint256 amount) internal {
122         require(address(this).balance >= amount, "Address: insufficient balance");
123 
124         (bool success, ) = recipient.call{value: amount}("");
125         require(success, "Address: unable to send value, recipient may have reverted");
126     }
127     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
128         return functionCall(target, data, "Address: low-level call failed");
129     }
130     function functionCall(
131         address target,
132         bytes memory data,
133         string memory errorMessage
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, 0, errorMessage);
136     }
137     function functionCallWithValue(
138         address target,
139         bytes memory data,
140         uint256 value
141     ) internal returns (bytes memory) {
142         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
143     }
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         require(isContract(target), "Address: call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.call{value: value}(data);
154         return verifyCallResult(success, returndata, errorMessage);
155     }
156     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
157         return functionStaticCall(target, data, "Address: low-level static call failed");
158     }
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
171     }
172     function functionDelegateCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         require(isContract(target), "Address: delegate call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.delegatecall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182     function verifyCallResult(
183         bool success,
184         bytes memory returndata,
185         string memory errorMessage
186     ) internal pure returns (bytes memory) {
187         if (success) {
188             return returndata;
189         } else {
190             if (returndata.length > 0) {
191                 assembly {
192                     let returndata_size := mload(returndata)
193                     revert(add(32, returndata), returndata_size)
194                 }
195             } else {
196                 revert(errorMessage);
197             }
198         }
199     }
200 }
201 
202 pragma solidity ^0.8.0;
203 interface IERC721Metadata is IERC721 {
204     function name() external view returns (string memory);
205     function symbol() external view returns (string memory);
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
210 
211 pragma solidity ^0.8.0;
212 
213 /**
214  * @title ERC721 token receiver interface
215  * @dev Interface for any contract that wants to support safeTransfers
216  * from ERC721 asset contracts.
217  */
218 interface IERC721Receiver {
219     /**
220      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
221      * by `operator` from `from`, this function is called.
222      *
223      * It must return its Solidity selector to confirm the token transfer.
224      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
225      *
226      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
227      */
228     function onERC721Received(
229         address operator,
230         address from,
231         uint256 tokenId,
232         bytes calldata data
233     ) external returns (bytes4);
234 }
235 
236 // File: @openzeppelin/contracts/utils/Context.sol
237 pragma solidity ^0.8.0;
238 /**
239  * @dev Provides information about the current execution context, including the
240  * sender of the transaction and its data. While these are generally available
241  * via msg.sender and msg.data, they should not be accessed in such a direct
242  * manner, since when dealing with meta-transactions the account sending and
243  * paying for execution may not be the actual sender (as far as an application
244  * is concerned).
245  *
246  * This contract is only required for intermediate, library-like contracts.
247  */
248 abstract contract Context {
249     function _msgSender() internal view virtual returns (address) {
250         return msg.sender;
251     }
252 
253     function _msgData() internal view virtual returns (bytes calldata) {
254         return msg.data;
255     }
256 }
257 
258 
259 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
260 pragma solidity ^0.8.0;
261 /**
262  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
263  * the Metadata extension, but not including the Enumerable extension, which is available separately as
264  * {ERC721Enumerable}.
265  */
266 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
267     using Address for address;
268     using Strings for uint256;
269 
270     // Token name
271     string private _name;
272 
273     // Token symbol
274     string private _symbol;
275 
276     // Mapping from token ID to owner address
277     mapping(uint256 => address) private _owners;
278 
279     // Mapping owner address to token count
280     mapping(address => uint256) private _balances;
281 
282     // Mapping from token ID to approved address
283     mapping(uint256 => address) private _tokenApprovals;
284 
285     // Mapping from owner to operator approvals
286     mapping(address => mapping(address => bool)) private _operatorApprovals;
287 
288     /**
289      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
290      */
291     constructor(string memory name_, string memory symbol_) {
292         _name = name_;
293         _symbol = symbol_;
294     }
295 
296     /**
297      * @dev See {IERC165-supportsInterface}.
298      */
299     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
300         return
301             interfaceId == type(IERC721).interfaceId ||
302             interfaceId == type(IERC721Metadata).interfaceId ||
303             super.supportsInterface(interfaceId);
304     }
305 
306     /**
307      * @dev See {IERC721-balanceOf}.
308      */
309     function balanceOf(address owner) public view virtual override returns (uint256) {
310         require(owner != address(0), "ERC721: balance query for the zero address");
311         return _balances[owner];
312     }
313 
314     /**
315      * @dev See {IERC721-ownerOf}.
316      */
317     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
318         address owner = _owners[tokenId];
319         require(owner != address(0), "ERC721: owner query for nonexistent token");
320         return owner;
321     }
322 
323     /**
324      * @dev See {IERC721Metadata-name}.
325      */
326     function name() public view virtual override returns (string memory) {
327         return _name;
328     }
329 
330     /**
331      * @dev See {IERC721Metadata-symbol}.
332      */
333     function symbol() public view virtual override returns (string memory) {
334         return _symbol;
335     }
336 
337     /**
338      * @dev See {IERC721Metadata-tokenURI}.
339      */
340     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
341         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
342 
343         string memory baseURI = _baseURI();
344         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
345     }
346 
347     /**
348      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
349      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
350      * by default, can be overriden in child contracts.
351      */
352     function _baseURI() internal view virtual returns (string memory) {
353         return "";
354     }
355 
356     /**
357      * @dev See {IERC721-approve}.
358      */
359     function approve(address to, uint256 tokenId) public virtual override {
360         address owner = ERC721.ownerOf(tokenId);
361         require(to != owner, "ERC721: approval to current owner");
362 
363         require(
364             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
365             "ERC721: approve caller is not owner nor approved for all"
366         );
367 
368         _approve(to, tokenId);
369     }
370 
371     /**
372      * @dev See {IERC721-getApproved}.
373      */
374     function getApproved(uint256 tokenId) public view virtual override returns (address) {
375         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
376 
377         return _tokenApprovals[tokenId];
378     }
379 
380     /**
381      * @dev See {IERC721-setApprovalForAll}.
382      */
383     function setApprovalForAll(address operator, bool approved) public virtual override {
384         require(operator != _msgSender(), "ERC721: approve to caller");
385 
386         _operatorApprovals[_msgSender()][operator] = approved;
387         emit ApprovalForAll(_msgSender(), operator, approved);
388     }
389 
390     /**
391      * @dev See {IERC721-isApprovedForAll}.
392      */
393     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
394         return _operatorApprovals[owner][operator];
395     }
396 
397     /**
398      * @dev See {IERC721-transferFrom}.
399      */
400     function transferFrom(
401         address from,
402         address to,
403         uint256 tokenId
404     ) public virtual override {
405         //solhint-disable-next-line max-line-length
406         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
407 
408         _transfer(from, to, tokenId);
409     }
410 
411     /**
412      * @dev See {IERC721-safeTransferFrom}.
413      */
414     function safeTransferFrom(
415         address from,
416         address to,
417         uint256 tokenId
418     ) public virtual override {
419         safeTransferFrom(from, to, tokenId, "");
420     }
421 
422     /**
423      * @dev See {IERC721-safeTransferFrom}.
424      */
425     function safeTransferFrom(
426         address from,
427         address to,
428         uint256 tokenId,
429         bytes memory _data
430     ) public virtual override {
431         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
432         _safeTransfer(from, to, tokenId, _data);
433     }
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
437      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
438      *
439      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
440      *
441      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
442      * implement alternative mechanisms to perform token transfer, such as signature-based.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must exist and be owned by `from`.
449      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
450      *
451      * Emits a {Transfer} event.
452      */
453     function _safeTransfer(
454         address from,
455         address to,
456         uint256 tokenId,
457         bytes memory _data
458     ) internal virtual {
459         _transfer(from, to, tokenId);
460         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
461     }
462 
463     /**
464      * @dev Returns whether `tokenId` exists.
465      *
466      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
467      *
468      * Tokens start existing when they are minted (`_mint`),
469      * and stop existing when they are burned (`_burn`).
470      */
471     function _exists(uint256 tokenId) internal view virtual returns (bool) {
472         return _owners[tokenId] != address(0);
473     }
474 
475     /**
476      * @dev Returns whether `spender` is allowed to manage `tokenId`.
477      *
478      * Requirements:
479      *
480      * - `tokenId` must exist.
481      */
482     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
483         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
484         address owner = ERC721.ownerOf(tokenId);
485         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
486     }
487 
488     /**
489      * @dev Safely mints `tokenId` and transfers it to `to`.
490      *
491      * Requirements:
492      *
493      * - `tokenId` must not exist.
494      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
495      *
496      * Emits a {Transfer} event.
497      */
498     function _safeMint(address to, uint256 tokenId) internal virtual {
499         _safeMint(to, tokenId, "");
500     }
501 
502     /**
503      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
504      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
505      */
506     function _safeMint(
507         address to,
508         uint256 tokenId,
509         bytes memory _data
510     ) internal virtual {
511         _mint(to, tokenId);
512         require(
513             _checkOnERC721Received(address(0), to, tokenId, _data),
514             "ERC721: transfer to non ERC721Receiver implementer"
515         );
516     }
517 
518     /**
519      * @dev Mints `tokenId` and transfers it to `to`.
520      *
521      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
522      *
523      * Requirements:
524      *
525      * - `tokenId` must not exist.
526      * - `to` cannot be the zero address.
527      *
528      * Emits a {Transfer} event.
529      */
530     function _mint(address to, uint256 tokenId) internal virtual {
531         require(to != address(0), "ERC721: mint to the zero address");
532         require(!_exists(tokenId), "ERC721: token already minted");
533 
534         _beforeTokenTransfer(address(0), to, tokenId);
535 
536         _balances[to] += 1;
537         _owners[tokenId] = to;
538 
539         emit Transfer(address(0), to, tokenId);
540     }
541 
542     /**
543      * @dev Destroys `tokenId`.
544      * The approval is cleared when the token is burned.
545      *
546      * Requirements:
547      *
548      * - `tokenId` must exist.
549      *
550      * Emits a {Transfer} event.
551      */
552     function _burn(uint256 tokenId) internal virtual {
553         address owner = ERC721.ownerOf(tokenId);
554 
555         _beforeTokenTransfer(owner, address(0), tokenId);
556 
557         // Clear approvals
558         _approve(address(0), tokenId);
559 
560         _balances[owner] -= 1;
561         delete _owners[tokenId];
562 
563         emit Transfer(owner, address(0), tokenId);
564     }
565 
566     /**
567      * @dev Transfers `tokenId` from `from` to `to`.
568      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
569      *
570      * Requirements:
571      *
572      * - `to` cannot be the zero address.
573      * - `tokenId` token must be owned by `from`.
574      *
575      * Emits a {Transfer} event.
576      */
577     function _transfer(
578         address from,
579         address to,
580         uint256 tokenId
581     ) internal virtual {
582         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
583         require(to != address(0), "ERC721: transfer to the zero address");
584 
585         _beforeTokenTransfer(from, to, tokenId);
586 
587         // Clear approvals from the previous owner
588         _approve(address(0), tokenId);
589 
590         _balances[from] -= 1;
591         _balances[to] += 1;
592         _owners[tokenId] = to;
593 
594         emit Transfer(from, to, tokenId);
595     }
596 
597     /**
598      * @dev Approve `to` to operate on `tokenId`
599      *
600      * Emits a {Approval} event.
601      */
602     function _approve(address to, uint256 tokenId) internal virtual {
603         _tokenApprovals[tokenId] = to;
604         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
605     }
606 
607     /**
608      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
609      * The call is not executed if the target address is not a contract.
610      *
611      * @param from address representing the previous owner of the given token ID
612      * @param to target address that will receive the tokens
613      * @param tokenId uint256 ID of the token to be transferred
614      * @param _data bytes optional data to send along with the call
615      * @return bool whether the call correctly returned the expected magic value
616      */
617     function _checkOnERC721Received(
618         address from,
619         address to,
620         uint256 tokenId,
621         bytes memory _data
622     ) private returns (bool) {
623         if (to.isContract()) {
624             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
625                 return retval == IERC721Receiver.onERC721Received.selector;
626             } catch (bytes memory reason) {
627                 if (reason.length == 0) {
628                     revert("ERC721: transfer to non ERC721Receiver implementer");
629                 } else {
630                     assembly {
631                         revert(add(32, reason), mload(reason))
632                     }
633                 }
634             }
635         } else {
636             return true;
637         }
638     }
639 
640     /**
641      * @dev Hook that is called before any token transfer. This includes minting
642      * and burning.
643      *
644      * Calling conditions:
645      *
646      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
647      * transferred to `to`.
648      * - When `from` is zero, `tokenId` will be minted for `to`.
649      * - When `to` is zero, ``from``'s `tokenId` will be burned.
650      * - `from` and `to` are never both zero.
651      *
652      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
653      */
654     function _beforeTokenTransfer(
655         address from,
656         address to,
657         uint256 tokenId
658     ) internal virtual {}
659 }
660 
661 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
667  * enumerability of all the token ids in the contract as well as all token ids owned by each
668  * account.
669  */
670 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
671     // Mapping from owner to list of owned token IDs
672     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
673 
674     // Mapping from token ID to index of the owner tokens list
675     mapping(uint256 => uint256) private _ownedTokensIndex;
676 
677     // Array with all token ids, used for enumeration
678     uint256[] private _allTokens;
679 
680     // Mapping from token id to position in the allTokens array
681     mapping(uint256 => uint256) private _allTokensIndex;
682 
683     /**
684      * @dev See {IERC165-supportsInterface}.
685      */
686     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
687         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
688     }
689 
690     /**
691      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
692      */
693     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
694         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
695         return _ownedTokens[owner][index];
696     }
697 
698     /**
699      * @dev See {IERC721Enumerable-totalSupply}.
700      */
701     function totalSupply() public view virtual override returns (uint256) {
702         return _allTokens.length;
703     }
704 
705     /**
706      * @dev See {IERC721Enumerable-tokenByIndex}.
707      */
708     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
709         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
710         return _allTokens[index];
711     }
712 
713     /**
714      * @dev Hook that is called before any token transfer. This includes minting
715      * and burning.
716      *
717      * Calling conditions:
718      *
719      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
720      * transferred to `to`.
721      * - When `from` is zero, `tokenId` will be minted for `to`.
722      * - When `to` is zero, ``from``'s `tokenId` will be burned.
723      * - `from` cannot be the zero address.
724      * - `to` cannot be the zero address.
725      *
726      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
727      */
728     function _beforeTokenTransfer(
729         address from,
730         address to,
731         uint256 tokenId
732     ) internal virtual override {
733         super._beforeTokenTransfer(from, to, tokenId);
734 
735         if (from == address(0)) {
736             _addTokenToAllTokensEnumeration(tokenId);
737         } else if (from != to) {
738             _removeTokenFromOwnerEnumeration(from, tokenId);
739         }
740         if (to == address(0)) {
741             _removeTokenFromAllTokensEnumeration(tokenId);
742         } else if (to != from) {
743             _addTokenToOwnerEnumeration(to, tokenId);
744         }
745     }
746 
747     /**
748      * @dev Private function to add a token to this extension's ownership-tracking data structures.
749      * @param to address representing the new owner of the given token ID
750      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
751      */
752     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
753         uint256 length = ERC721.balanceOf(to);
754         _ownedTokens[to][length] = tokenId;
755         _ownedTokensIndex[tokenId] = length;
756     }
757 
758     /**
759      * @dev Private function to add a token to this extension's token tracking data structures.
760      * @param tokenId uint256 ID of the token to be added to the tokens list
761      */
762     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
763         _allTokensIndex[tokenId] = _allTokens.length;
764         _allTokens.push(tokenId);
765     }
766 
767     /**
768      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
769      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
770      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
771      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
772      * @param from address representing the previous owner of the given token ID
773      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
774      */
775     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
776         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
777         // then delete the last slot (swap and pop).
778 
779         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
780         uint256 tokenIndex = _ownedTokensIndex[tokenId];
781 
782         // When the token to delete is the last token, the swap operation is unnecessary
783         if (tokenIndex != lastTokenIndex) {
784             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
785 
786             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
787             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
788         }
789 
790         // This also deletes the contents at the last position of the array
791         delete _ownedTokensIndex[tokenId];
792         delete _ownedTokens[from][lastTokenIndex];
793     }
794 
795     /**
796      * @dev Private function to remove a token from this extension's token tracking data structures.
797      * This has O(1) time complexity, but alters the order of the _allTokens array.
798      * @param tokenId uint256 ID of the token to be removed from the tokens list
799      */
800     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
801         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
802         // then delete the last slot (swap and pop).
803 
804         uint256 lastTokenIndex = _allTokens.length - 1;
805         uint256 tokenIndex = _allTokensIndex[tokenId];
806 
807         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
808         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
809         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
810         uint256 lastTokenId = _allTokens[lastTokenIndex];
811 
812         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
813         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
814 
815         // This also deletes the contents at the last position of the array
816         delete _allTokensIndex[tokenId];
817         _allTokens.pop();
818     }
819 }
820 
821 
822 pragma solidity ^0.8.0;
823 
824 abstract contract Ownable is Context {
825     address private _owner;
826 
827     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
828 
829     constructor() {
830         _setOwner(_msgSender());
831     }
832 
833     function owner() public view virtual returns (address) {
834         return _owner;
835     }
836 
837     modifier onlyOwner() {
838         require(owner() == _msgSender(), "Ownable: caller is not the owner");
839         _;
840     }
841 
842     function renounceOwnership() public virtual onlyOwner {
843         _setOwner(address(0));
844     }
845 
846     function transferOwnership(address newOwner) public virtual onlyOwner {
847         require(newOwner != address(0), "Ownable: new owner is the zero address");
848         _setOwner(newOwner);
849     }
850 
851     function _setOwner(address newOwner) private {
852         address oldOwner = _owner;
853         _owner = newOwner;
854         emit OwnershipTransferred(oldOwner, newOwner);
855     }
856 }
857 
858 pragma solidity >=0.7.0 <0.9.0;
859 
860 contract NFT is ERC721Enumerable, Ownable {
861   using Strings for uint256;
862 
863   string baseURI;
864   string public baseExtension = ".json";
865   uint256 public cost = 0.02 ether;
866   uint256 public preSaleCost = 0.00 ether;
867   uint256 public maxSupply = 5000;
868   uint256 public maxMintAmount = 10;
869   bool public paused = false;
870   bool public revealed = false;
871   string public notRevealedUri;
872   bool public preSale = false;
873   address public publicKey = 0xB0F8f33DE6F715aACbFB56D3fe0570EbddcEf776;
874 
875     // mapping
876     mapping(bytes32 => bool) public executed;
877 
878   constructor(
879     string memory _name,
880     string memory _symbol,
881     string memory _initBaseURI,
882     string memory _initNotRevealedUri
883   ) ERC721(_name, _symbol) {
884     setBaseURI(_initBaseURI);
885     setNotRevealedURI(_initNotRevealedUri);
886   }
887 
888   // internal
889   function _baseURI() internal view virtual override returns (string memory) {
890     return baseURI;
891   }
892 
893 
894     function showText() public view returns (string memory) {
895            
896     //bytes memory stringContract = abi.encodePacked(address(this));
897     uint256 _allocation = 3;
898     string memory stringWallet = Strings.toHexString(uint256(uint160(msg.sender)), 20);
899     string memory stringAllocation = Strings.toString(_allocation);
900 
901     string memory stringContract = Strings.toHexString(uint256(uint160(address(this))), 20);
902    
903 string memory combinedData = string(bytes.concat(bytes(stringWallet), bytes(stringContract), bytes(stringAllocation)));
904 
905        return combinedData;
906     }
907 
908 
909   // public
910    function mint(uint256 _mintAmount, bytes memory _sig, uint256 _allocation) public payable {
911     uint256 supply = totalSupply();
912 
913     // DRM start
914   if (preSale == true) {
915 
916        cost = preSaleCost;
917 
918        string memory stringContract = Strings.toHexString(uint256(uint160(address(this))), 20);
919        string memory stringAllocation = Strings.toString(_allocation);
920        string memory stringWallet = Strings.toHexString(uint256(uint160(msg.sender)), 20);
921        stringContract = toUpper(stringContract);
922        stringAllocation = toUpper(stringAllocation);
923        stringWallet = toUpper(stringWallet);
924        string memory combinedData = string(bytes.concat(bytes(stringWallet), bytes(stringContract), bytes(stringAllocation)));
925 
926     bytes32 txHash = getMessageHash(combinedData);
927     require(!executed[txHash], "Transaction already executed: Mint process stopped");
928     require(verify(publicKey, combinedData, _sig), "Invalid signature: Mint process stopped");
929     require(_mintAmount <= _allocation, "Allocation breached: Mint process stopped");
930     executed[txHash] = true;    
931     
932     }
933     // DRM end
934 
935     require(!paused, "Contract paused: Mint process stopped");
936     require(_mintAmount > 0, "Mint amount too low:  Mint process stopped");
937     require(_mintAmount <= maxMintAmount, "Mint amount too high:  Mint process stopped");
938     require(supply + _mintAmount <= maxSupply, "Not enough supply:  Mint process stopped");
939 
940     if (msg.sender != owner()) {
941       require(msg.value >= cost * _mintAmount, "Price too low:  Mint process stopped");
942     }
943 
944     for (uint256 i = 1; i <= _mintAmount; i++) {
945       _safeMint(msg.sender, supply + i);
946     }
947   }
948 
949   function walletOfOwner(address _owner)
950     public
951     view
952     returns (uint256[] memory)
953   {
954     uint256 ownerTokenCount = balanceOf(_owner);
955     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
956     for (uint256 i; i < ownerTokenCount; i++) {
957       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
958     }
959     return tokenIds;
960   }
961 
962   function tokenURI(uint256 tokenId)
963     public
964     view
965     virtual
966     override
967     returns (string memory)
968   {
969     require(
970       _exists(tokenId),
971       "ERC721Metadata: URI query for nonexistent token"
972     );
973     
974     if(revealed == false) {
975         return notRevealedUri;
976     }
977 
978     string memory currentBaseURI = _baseURI();
979     return bytes(currentBaseURI).length > 0
980         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
981         : "";
982   }
983 
984   function reveal() public onlyOwner {
985       revealed = true;
986   }
987   
988   function setCost(uint256 _newCost) public onlyOwner {
989     cost = _newCost;
990   }
991 
992   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
993     maxMintAmount = _newmaxMintAmount;
994   }
995   
996   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
997     notRevealedUri = _notRevealedURI;
998   }
999 
1000   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1001     baseURI = _newBaseURI;
1002   }
1003 
1004   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1005     baseExtension = _newBaseExtension;
1006   }
1007 
1008   function pause(bool _state) public onlyOwner {
1009     paused = _state;
1010   }
1011 
1012     function preSaleState(bool _state) public onlyOwner {
1013     preSale = _state;
1014   }
1015  
1016   function withdraw() public payable onlyOwner {
1017     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1018     require(os);
1019   }
1020 
1021 // Signature code
1022 function verify(address _signer, string memory _message, bytes memory _sig) public pure returns (bool)
1023 {
1024     bytes32 messageHash = getMessageHash(_message);
1025     bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1026     return recover(ethSignedMessageHash, _sig) == _signer;
1027 }
1028 function getMessageHash(string memory _word) internal pure returns(bytes32)
1029 {
1030     bytes32 output = keccak256(abi.encodePacked(_word));
1031     return output;
1032 }
1033 function getEthSignedMessageHash(bytes32 _messageHash) internal pure returns(bytes32)
1034     {
1035     bytes32 output = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
1036     return output;
1037     }
1038 
1039 function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) internal pure returns (address)
1040     {
1041         (bytes32 r, bytes32 s, uint8 v) = split(_sig);
1042         return ecrecover(_ethSignedMessageHash, v, r, s);
1043     }
1044 
1045 function split(bytes memory _sig) internal pure returns (bytes32 r, bytes32 s, uint8 v)
1046     {
1047        require(_sig.length == 65, "Invlaid signature length");
1048        assembly {
1049            r := mload(add(_sig, 32))
1050            s := mload(add(_sig, 64))
1051            v := byte(0, mload(add(_sig, 96)))
1052        }
1053     }
1054 
1055 function toUpper(string memory str) internal pure returns (string memory) {
1056         bytes memory bStr = bytes(str);
1057         bytes memory bUpper = new bytes(bStr.length);
1058         for (uint i = 0; i < bStr.length; i++) {
1059             // Lowercase character...
1060             if ((uint8(bStr[i]) >= 97) && (uint8(bStr[i]) <= 122)) {
1061                 // So we subtract 32 to make it uppercase
1062                 bUpper[i] = bytes1(uint8(bStr[i]) - 32);
1063             } else {
1064                 bUpper[i] = bStr[i];
1065             }
1066         }
1067         return string(bUpper);
1068     }
1069 
1070 
1071 }