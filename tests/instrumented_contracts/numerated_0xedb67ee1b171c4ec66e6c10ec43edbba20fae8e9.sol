1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 interface IERC165 {
5     function supportsInterface(bytes4 interfaceId) external view returns (bool);
6 }
7 
8 
9 interface IERC721 is IERC165 {
10     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
11     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
12     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
13     function balanceOf(address owner) external view returns (uint256 balance);
14     function ownerOf(uint256 tokenId) external view returns (address owner);
15     function safeTransferFrom(
16         address from,
17         address to,
18         uint256 tokenId
19     ) external;
20     function transferFrom(
21         address from,
22         address to,
23         uint256 tokenId
24     ) external;
25     function approve(address to, uint256 tokenId) external;
26     function getApproved(uint256 tokenId) external view returns (address operator);
27     function setApprovalForAll(address operator, bool _approved) external;
28     function isApprovedForAll(address owner, address operator) external view returns (bool);
29     function safeTransferFrom(
30         address from,
31         address to,
32         uint256 tokenId,
33         bytes calldata data
34     ) external;
35 }
36 
37 library Strings {
38     function toString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 }
57 
58 interface IERC721Receiver {
59     function onERC721Received(
60         address operator,
61         address from,
62         uint256 tokenId,
63         bytes calldata data
64     ) external returns (bytes4);
65 }
66 
67 abstract contract ERC165 is IERC165 {
68     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
69         return interfaceId == type(IERC165).interfaceId;
70     }
71 }
72 
73 interface IERC721Metadata is IERC721 {
74     function name() external view returns (string memory);
75     function symbol() external view returns (string memory);
76     function tokenURI(uint256 tokenId) external view returns (string memory);
77 }
78 
79 contract ERC721 is ERC165, IERC721 {
80     using Strings for uint256;
81 
82     mapping(uint256 => address) private _owners;
83     mapping(address => uint256) private _balances;
84     mapping(uint256 => address) private _tokenApprovals;
85     mapping(address => mapping(address => bool)) private _operatorApprovals;
86 
87     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
88         return
89             interfaceId == type(IERC721).interfaceId ||
90             interfaceId == type(IERC721Metadata).interfaceId ||
91             super.supportsInterface(interfaceId);
92     }
93 
94     function balanceOf(address owner) public view virtual override returns (uint256) {
95         require(owner != address(0), "ERC721: balance query for the zero address");
96         return _balances[owner];
97     }
98 
99     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
100         address owner = _owners[tokenId];
101         require(owner != address(0), "ERC721: owner query for nonexistent token");
102         return owner;
103     }
104 
105     function _baseURI() internal view virtual returns (string memory) {
106         return "";
107     }
108 
109     function approve(address to, uint256 tokenId) public virtual override {
110         address owner = ERC721.ownerOf(tokenId);
111         require(to != owner, "ERC721: approval to current owner");
112 
113         require(
114             msg.sender == owner || isApprovedForAll(owner, msg.sender),
115             "ERC721: approve caller is not owner nor approved for all"
116         );
117 
118         _approve(to, tokenId);
119     }
120 
121     function getApproved(uint256 tokenId) public view virtual override returns (address) {
122         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
123 
124         return _tokenApprovals[tokenId];
125     }
126 
127     function setApprovalForAll(address operator, bool approved) public virtual override {
128         require(operator != msg.sender, "ERC721: approve to caller");
129 
130         _operatorApprovals[msg.sender][operator] = approved;
131         emit ApprovalForAll(msg.sender, operator, approved);
132     }
133 
134     function _isContract(address account) internal view returns (bool) {
135         uint256 size;
136         assembly {
137             size := extcodesize(account)
138         }
139         return size > 0;
140     }
141 
142     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
143         return _operatorApprovals[owner][operator];
144     }
145 
146     function transferFrom(
147         address from,
148         address to,
149         uint256 tokenId
150     ) public virtual override {
151         //solhint-disable-next-line max-line-length
152         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
153 
154         _transfer(from, to, tokenId);
155     }
156 
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId
161     ) public virtual override {
162         safeTransferFrom(from, to, tokenId, "");
163     }
164 
165     /**
166      * @dev See {IERC721-safeTransferFrom}.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes memory _data
173     ) public virtual override {
174         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
175         _safeTransfer(from, to, tokenId, _data);
176     }
177 
178     /**
179      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
180      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
181      *
182      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
183      *
184      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
185      * implement alternative mechanisms to perform token transfer, such as signature-based.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must exist and be owned by `from`.
192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
193      *
194      * Emits a {Transfer} event.
195      */
196     function _safeTransfer(
197         address from,
198         address to,
199         uint256 tokenId,
200         bytes memory _data
201     ) internal virtual {
202         _transfer(from, to, tokenId);
203         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
204     }
205 
206     /**
207      * @dev Returns whether `tokenId` exists.
208      *
209      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
210      *
211      * Tokens start existing when they are minted (`_mint`),
212      * and stop existing when they are burned (`_burn`).
213      */
214     function _exists(uint256 tokenId) internal view virtual returns (bool) {
215         return _owners[tokenId] != address(0);
216     }
217 
218     /**
219      * @dev Returns whether `spender` is allowed to manage `tokenId`.
220      *
221      * Requirements:
222      *
223      * - `tokenId` must exist.
224      */
225     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
226         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
227         address owner = ERC721.ownerOf(tokenId);
228         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
229     }
230 
231     /**
232      * @dev Safely mints `tokenId` and transfers it to `to`.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must not exist.
237      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
238      *
239      * Emits a {Transfer} event.
240      */
241     function _safeMint(address to, uint256 tokenId) internal virtual {
242         _safeMint(to, tokenId, "");
243     }
244 
245     /**
246      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
247      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
248      */
249     function _safeMint(
250         address to,
251         uint256 tokenId,
252         bytes memory _data
253     ) internal virtual {
254         _mint(to, tokenId);
255         require(
256             _checkOnERC721Received(address(0), to, tokenId, _data),
257             "ERC721: transfer to non ERC721Receiver implementer"
258         );
259     }
260 
261     /**
262      * @dev Mints `tokenId` and transfers it to `to`.
263      *
264      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
265      *
266      * Requirements:
267      *
268      * - `tokenId` must not exist.
269      * - `to` cannot be the zero address.
270      *
271      * Emits a {Transfer} event.
272      */
273     function _mint(address to, uint256 tokenId) internal virtual {
274         require(to != address(0), "ERC721: mint to the zero address");
275         require(!_exists(tokenId), "ERC721: token already minted");
276 
277         _beforeTokenTransfer(address(0), to, tokenId);
278 
279         _balances[to] += 1;
280         _owners[tokenId] = to;
281 
282         emit Transfer(address(0), to, tokenId);
283     }
284 
285     /**
286      * @dev Destroys `tokenId`.
287      * The approval is cleared when the token is burned.
288      *
289      * Requirements:
290      *
291      * - `tokenId` must exist.
292      *
293      * Emits a {Transfer} event.
294      */
295     function _burn(uint256 tokenId) internal virtual {
296         address owner = ERC721.ownerOf(tokenId);
297 
298         _beforeTokenTransfer(owner, address(0), tokenId);
299 
300         // Clear approvals
301         _approve(address(0), tokenId);
302 
303         _balances[owner] -= 1;
304         delete _owners[tokenId];
305 
306         emit Transfer(owner, address(0), tokenId);
307     }
308 
309     /**
310      * @dev Transfers `tokenId` from `from` to `to`.
311      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
312      *
313      * Requirements:
314      *
315      * - `to` cannot be the zero address.
316      * - `tokenId` token must be owned by `from`.
317      *
318      * Emits a {Transfer} event.
319      */
320     function _transfer(
321         address from,
322         address to,
323         uint256 tokenId
324     ) internal virtual {
325         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
326         require(to != address(0), "ERC721: transfer to the zero address");
327 
328         _beforeTokenTransfer(from, to, tokenId);
329 
330         // Clear approvals from the previous owner
331         _approve(address(0), tokenId);
332 
333         _balances[from] -= 1;
334         _balances[to] += 1;
335         _owners[tokenId] = to;
336 
337         emit Transfer(from, to, tokenId);
338     }
339 
340     /**
341      * @dev Approve `to` to operate on `tokenId`
342      *
343      * Emits a {Approval} event.
344      */
345     function _approve(address to, uint256 tokenId) internal virtual {
346         _tokenApprovals[tokenId] = to;
347         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
348     }
349 
350     /**
351      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
352      * The call is not executed if the target address is not a contract.
353      *
354      * @param from address representing the previous owner of the given token ID
355      * @param to target address that will receive the tokens
356      * @param tokenId uint256 ID of the token to be transferred
357      * @param _data bytes optional data to send along with the call
358      * @return bool whether the call correctly returned the expected magic value
359      */
360     function _checkOnERC721Received(
361         address from,
362         address to,
363         uint256 tokenId,
364         bytes memory _data
365     ) private returns (bool) {
366         if (_isContract(to)) {
367             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
368                 return retval == IERC721Receiver(to).onERC721Received.selector;
369             } catch (bytes memory reason) {
370                 if (reason.length == 0) {
371                     revert("ERC721: transfer to non ERC721Receiver implementer");
372                 } else {
373                     assembly {
374                         revert(add(32, reason), mload(reason))
375                     }
376                 }
377             }
378         } else {
379             return true;
380         }
381     }
382 
383     /**
384      * @dev Hook that is called before any token transfer. This includes minting
385      * and burning.
386      *
387      * Calling conditions:
388      *
389      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
390      * transferred to `to`.
391      * - When `from` is zero, `tokenId` will be minted for `to`.
392      * - When `to` is zero, ``from``'s `tokenId` will be burned.
393      * - `from` and `to` are never both zero.
394      *
395      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
396      */
397     function _beforeTokenTransfer(
398         address from,
399         address to,
400         uint256 tokenId
401     ) internal virtual {}
402 }
403 
404 
405 
406 
407 
408 
409 
410 /**
411  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
412  * @dev See https://eips.ethereum.org/EIPS/eip-721
413  */
414 interface IERC721Enumerable is IERC721 {
415     /**
416      * @dev Returns the total amount of tokens stored by the contract.
417      */
418     function totalSupply() external view returns (uint256);
419 
420     /**
421      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
422      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
423      */
424     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
425 
426     /**
427      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
428      * Use along with {totalSupply} to enumerate all tokens.
429      */
430     function tokenByIndex(uint256 index) external view returns (uint256);
431 }
432 
433 
434 /**
435  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
436  * enumerability of all the token ids in the contract as well as all token ids owned by each
437  * account.
438  */
439 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
440     // Mapping from owner to list of owned token IDs
441     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
442 
443     // Mapping from token ID to index of the owner tokens list
444     mapping(uint256 => uint256) private _ownedTokensIndex;
445 
446     // Array with all token ids, used for enumeration
447     uint256[] private _allTokens;
448 
449     // Mapping from token id to position in the allTokens array
450     mapping(uint256 => uint256) private _allTokensIndex;
451 
452     /**
453      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
454      */
455     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
456         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
457         return _ownedTokens[owner][index];
458     }
459 
460     /**
461      * @dev See {IERC721Enumerable-totalSupply}.
462      */
463     function totalSupply() public view virtual override returns (uint256) {
464         return _allTokens.length;
465     }
466 
467     /**
468      * @dev See {IERC721Enumerable-tokenByIndex}.
469      */
470     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
471         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
472         return _allTokens[index];
473     }
474 
475     /**
476      * @dev Hook that is called before any token transfer. This includes minting
477      * and burning.
478      *
479      * Calling conditions:
480      *
481      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
482      * transferred to `to`.
483      * - When `from` is zero, `tokenId` will be minted for `to`.
484      * - When `to` is zero, ``from``'s `tokenId` will be burned.
485      * - `from` cannot be the zero address.
486      * - `to` cannot be the zero address.
487      *
488      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
489      */
490     function _beforeTokenTransfer(
491         address from,
492         address to,
493         uint256 tokenId
494     ) internal virtual override {
495         super._beforeTokenTransfer(from, to, tokenId);
496 
497         if (from == address(0)) {
498             _addTokenToAllTokensEnumeration(tokenId);
499         } else if (from != to) {
500             _removeTokenFromOwnerEnumeration(from, tokenId);
501         }
502         if (to == address(0)) {
503             _removeTokenFromAllTokensEnumeration(tokenId);
504         } else if (to != from) {
505             _addTokenToOwnerEnumeration(to, tokenId);
506         }
507     }
508 
509     /**
510      * @dev Private function to add a token to this extension's ownership-tracking data structures.
511      * @param to address representing the new owner of the given token ID
512      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
513      */
514     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
515         uint256 length = ERC721.balanceOf(to);
516         _ownedTokens[to][length] = tokenId;
517         _ownedTokensIndex[tokenId] = length;
518     }
519 
520     /**
521      * @dev Private function to add a token to this extension's token tracking data structures.
522      * @param tokenId uint256 ID of the token to be added to the tokens list
523      */
524     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
525         _allTokensIndex[tokenId] = _allTokens.length;
526         _allTokens.push(tokenId);
527     }
528 
529     /**
530      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
531      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
532      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
533      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
534      * @param from address representing the previous owner of the given token ID
535      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
536      */
537     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
538         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
539         // then delete the last slot (swap and pop).
540 
541         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
542         uint256 tokenIndex = _ownedTokensIndex[tokenId];
543 
544         // When the token to delete is the last token, the swap operation is unnecessary
545         if (tokenIndex != lastTokenIndex) {
546             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
547 
548             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
549             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
550         }
551 
552         // This also deletes the contents at the last position of the array
553         delete _ownedTokensIndex[tokenId];
554         delete _ownedTokens[from][lastTokenIndex];
555     }
556 
557     /**
558      * @dev Private function to remove a token from this extension's token tracking data structures.
559      * This has O(1) time complexity, but alters the order of the _allTokens array.
560      * @param tokenId uint256 ID of the token to be removed from the tokens list
561      */
562     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
563         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
564         // then delete the last slot (swap and pop).
565 
566         uint256 lastTokenIndex = _allTokens.length - 1;
567         uint256 tokenIndex = _allTokensIndex[tokenId];
568 
569         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
570         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
571         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
572         uint256 lastTokenId = _allTokens[lastTokenIndex];
573 
574         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
575         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
576 
577         // This also deletes the contents at the last position of the array
578         delete _allTokensIndex[tokenId];
579         _allTokens.pop();
580     }
581 }
582 
583 library FullMath {
584     function mulDiv(
585         uint256 a,
586         uint256 b,
587         uint256 denominator
588     ) internal pure returns (uint256 result) {
589         uint256 prod0; // Least significant 256 bits of the product
590         uint256 prod1; // Most significant 256 bits of the product
591         assembly {
592             let mm := mulmod(a, b, not(0))
593             prod0 := mul(a, b)
594             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
595         }
596 
597         if (prod1 == 0) {
598             require(denominator > 0);
599             assembly {
600                 result := div(prod0, denominator)
601             }
602             return result;
603         }
604 
605         require(denominator > prod1);
606 
607         uint256 remainder;
608         assembly {
609             remainder := mulmod(a, b, denominator)
610         }
611         assembly {
612             prod1 := sub(prod1, gt(remainder, prod0))
613             prod0 := sub(prod0, remainder)
614         }
615         int256 _denominator = int256(denominator);
616         uint256 twos = uint256(-_denominator & _denominator);
617         assembly {
618             denominator := div(denominator, twos)
619         }
620 
621         assembly {
622             prod0 := div(prod0, twos)
623         }
624 
625         assembly {
626             twos := add(div(sub(0, twos), twos), 1)
627         }
628         prod0 |= prod1 * twos;
629 
630         uint256 inv = (3 * denominator) ^ 2;
631 
632         inv *= 2 - denominator * inv; // inverse mod 2**8
633         inv *= 2 - denominator * inv; // inverse mod 2**16
634         inv *= 2 - denominator * inv; // inverse mod 2**32
635         inv *= 2 - denominator * inv; // inverse mod 2**64
636         inv *= 2 - denominator * inv; // inverse mod 2**128
637         inv *= 2 - denominator * inv; // inverse mod 2**256
638 
639         result = prod0 * inv;
640         return result;
641     }
642 }
643 
644 library TickMath {
645     int24 internal constant MIN_TICK = -887272;
646     int24 internal constant MAX_TICK = -MIN_TICK;
647 
648     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
649         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
650         require(absTick <= uint256(int256(MAX_TICK)), 'T');
651 
652         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
653         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
654         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
655         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
656         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
657         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
658         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
659         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
660         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
661         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
662         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
663         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
664         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
665         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
666         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
667         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
668         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
669         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
670         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
671         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
672 
673         if (tick > 0) ratio = type(uint256).max / ratio;
674 
675         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
676     }
677 }
678 
679 interface IUniswapV3Pool {
680         function observe(uint32[] calldata secondsAgos)
681         external
682         view
683         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
684 }
685 
686 /// @title Oracle library
687 /// @notice Provides functions to integrate with V3 pool oracle
688 library OracleLibrary {
689     /// @notice Fetches time-weighted average tick using Uniswap V3 oracle
690     /// @param pool Address of Uniswap V3 pool that we want to observe
691     /// @param period Number of seconds in the past to start calculating time-weighted average
692     /// @return timeWeightedAverageTick The time-weighted average tick from (block.timestamp - period) to block.timestamp
693     function consult(address pool, uint32 period) internal view returns (int24 timeWeightedAverageTick) {
694         require(period != 0, 'BP');
695 
696         uint32[] memory secondAgos = new uint32[](2);
697         secondAgos[0] = period;
698         secondAgos[1] = 0;
699 
700         (int56[] memory tickCumulatives, ) = IUniswapV3Pool(pool).observe(secondAgos);
701         int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];
702 
703         timeWeightedAverageTick = int24(tickCumulativesDelta / int(uint(period)));
704 
705         // Always round to negative infinity
706         if (tickCumulativesDelta < 0 && (tickCumulativesDelta % int(uint(period)) != 0)) timeWeightedAverageTick--;
707     }
708 
709     /// @notice Given a tick and a token amount, calculates the amount of token received in exchange
710     /// @param tick Tick value used to calculate the quote
711     /// @param baseAmount Amount of token to be converted
712     /// @param baseToken Address of an ERC20 token contract used as the baseAmount denomination
713     /// @param quoteToken Address of an ERC20 token contract used as the quoteAmount denomination
714     /// @return quoteAmount Amount of quoteToken received for baseAmount of baseToken
715     function getQuoteAtTick(
716         int24 tick,
717         uint128 baseAmount,
718         address baseToken,
719         address quoteToken
720     ) internal pure returns (uint256 quoteAmount) {
721         uint160 sqrtRatioX96 = TickMath.getSqrtRatioAtTick(tick);
722 
723         // Calculate quoteAmount with better precision if it doesn't overflow when multiplied by itself
724         if (sqrtRatioX96 <= type(uint128).max) {
725             uint256 ratioX192 = uint256(sqrtRatioX96) * sqrtRatioX96;
726             quoteAmount = baseToken < quoteToken
727                 ? FullMath.mulDiv(ratioX192, baseAmount, 1 << 192)
728                 : FullMath.mulDiv(1 << 192, baseAmount, ratioX192);
729         } else {
730             uint256 ratioX128 = FullMath.mulDiv(sqrtRatioX96, sqrtRatioX96, 1 << 64);
731             quoteAmount = baseToken < quoteToken
732                 ? FullMath.mulDiv(ratioX128, baseAmount, 1 << 128)
733                 : FullMath.mulDiv(1 << 128, baseAmount, ratioX128);
734         }
735     }
736 }
737 
738 library PoolAddress {
739     bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
740 
741     struct PoolKey {
742         address token0;
743         address token1;
744         uint24 fee;
745     }function getPoolKey(
746         address tokenA,
747         address tokenB,
748         uint24 fee
749     ) internal pure returns (PoolKey memory) {
750         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
751         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
752     }
753 
754     function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
755         require(key.token0 < key.token1);
756         pool = address(
757             uint160(uint256(
758                 keccak256(
759                     abi.encodePacked(
760                         hex'ff',
761                         factory,
762                         keccak256(abi.encode(key.token0, key.token1, key.fee)),
763                         POOL_INIT_CODE_HASH
764                     )
765                 )
766             )
767         ));
768     }
769 }
770 
771 library SafeUint128 {
772     function toUint128(uint256 y) internal pure returns (uint128 z) {
773         require((z = uint128(y)) == y);
774     }
775 }
776 
777 interface erc20 {
778     function transfer(address recipient, uint amount) external returns (bool);
779     function balanceOf(address) external view returns (uint);
780     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
781 }
782 
783 contract Keep3rOptions is ERC721Enumerable {
784     string public constant name = "Keep3r Options";
785     string public constant symbol = "oKP3R";
786     address immutable rKP3R;
787 
788     constructor() {
789         rKP3R = msg.sender;
790     }
791 
792     function mint(address _user, uint _id) external returns (bool) {
793         require(msg.sender == rKP3R);
794         _safeMint(_user, _id);
795         return true;
796     }
797 
798     function burn(uint _id) external returns (bool) {
799         require(msg.sender == rKP3R);
800         _burn(_id);
801         return true;
802     }
803 
804     function isApprovedOrOwner(address _addr, uint _id) external view returns (bool) {
805         return _isApprovedOrOwner(_addr, _id);
806     }
807 }
808 
809 contract RedeemableKeep3r {
810     string public constant name = "Redeemable Keep3r";
811     string public constant symbol = "rKP3R";
812     uint8 public constant decimals = 18;
813 
814     address public gov;
815     address public nextGov;
816     uint public delayGov;
817 
818     uint public discount = 50;
819     uint public nextDiscount;
820     uint public delayDiscount;
821 
822     address public treasury;
823     address public nextTreasury;
824     uint public delayTreasury;
825 
826     struct option {
827         uint amount;
828         uint strike;
829         uint expiry;
830         bool exercised;
831     }
832 
833     option[] public options;
834     uint public nextIndex;
835 
836     address constant KP3R = address(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
837     address constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
838     address constant UNIv3 = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
839     address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
840 
841     uint32 constant TWAP_PERIOD = 86400;
842     uint32 constant TWAP_NOW = 60;
843     uint32 constant OPTION_EXPIRY = 1 days;
844     uint32 constant DELAY = 1 days;
845     uint32 constant BASE = 100;
846     Keep3rOptions immutable public oKP3R;
847 
848     event Created(address indexed owner, uint amount, uint strike, uint expiry, uint id);
849     event Redeem(address indexed from, address indexed owner, uint amount, uint strike, uint id);
850     event Refund(address indexed from, address indexed owner, uint amount, uint strike, uint id);
851 
852     constructor(address _treasury) {
853         gov = msg.sender;
854         treasury = _treasury;
855         oKP3R = new Keep3rOptions();
856     }
857 
858     modifier g() {
859         require(msg.sender == gov);
860         _;
861     }
862 
863     function setGov(address _gov) external g {
864         nextGov = _gov;
865         delayGov = block.timestamp + DELAY;
866     }
867 
868     function acceptGov() external {
869         require(msg.sender == nextGov && delayGov < block.timestamp);
870         gov = nextGov;
871     }
872 
873     function setDiscount(uint _discount) external g {
874         nextDiscount = _discount;
875         delayDiscount = block.timestamp + DELAY;
876     }
877 
878     function commitDiscount() external g {
879         require(delayDiscount < block.timestamp);
880         discount = nextDiscount;
881     }
882 
883     function setTreasury(address _treasury) external g {
884         nextTreasury = _treasury;
885         delayTreasury = block.timestamp + DELAY;
886     }
887 
888     function commitTreasury() external g {
889         require(delayTreasury < block.timestamp);
890         treasury = nextTreasury;
891     }
892 
893     /// @notice Total number of tokens in circulation
894     uint public totalSupply = 0;
895 
896     mapping(address => mapping (address => uint)) public allowance;
897     mapping(address => uint) public balanceOf;
898 
899     event Transfer(address indexed from, address indexed to, uint amount);
900     event Approval(address indexed owner, address indexed spender, uint amount);
901 
902     function refund(uint[] memory _ids) external {
903         for (uint i = 0; i < _ids.length; i++) {
904             option storage _opt = options[_ids[i]];
905             if (_opt.expiry < block.timestamp && !_opt.exercised) {
906                 _opt.exercised = true;
907                 _safeTransfer(KP3R, treasury, _opt.amount);
908                 address _owner = oKP3R.ownerOf(_ids[i]);
909                 oKP3R.burn(_ids[i]);
910                 emit Refund(msg.sender, _owner, _opt.amount, _opt.strike, _ids[i]);
911             }
912         }
913     }
914 
915     function _fetchTwap(
916         address _tokenIn,
917         address _tokenOut,
918         uint24 _poolFee,
919         uint32 _twapPeriod,
920         uint _amountIn
921     ) internal view returns (uint256 amountOut) {
922         address pool =
923             PoolAddress.computeAddress(UNIv3, PoolAddress.getPoolKey(_tokenIn, _tokenOut, _poolFee));
924         // Leave twapTick as a int256 to avoid solidity casting
925         int256 twapTick = OracleLibrary.consult(pool, _twapPeriod);
926         return
927             OracleLibrary.getQuoteAtTick(
928                 int24(twapTick), // can assume safe being result from consult()
929                 SafeUint128.toUint128(_amountIn),
930                 _tokenIn,
931                 _tokenOut
932             );
933     }
934 
935     function assetToAsset(
936         address _tokenIn,
937         uint _amountIn,
938         address _tokenOut,
939         uint32 _twapPeriod
940     ) public view returns (uint ethAmountOut) {
941         uint256 ethAmount = assetToEth(_tokenIn, _amountIn, _twapPeriod);
942         return ethToAsset(ethAmount, _tokenOut, _twapPeriod);
943     }
944 
945     function assetToEth(
946         address _tokenIn,
947         uint _amountIn,
948         uint32 _twapPeriod
949     ) public view returns (uint ethAmountOut) {
950         return _fetchTwap(_tokenIn, WETH, 10000, _twapPeriod, _amountIn);
951     }
952 
953     function ethToAsset(
954         uint _ethAmountIn,
955         address _tokenOut,
956         uint32 _twapPeriod
957     ) public view returns (uint256 amountOut) {
958         return _fetchTwap(WETH, _tokenOut, 3000, _twapPeriod, _ethAmountIn);
959     }
960 
961     function price() external view returns (uint) {
962         return assetToAsset(KP3R, 1e18, USDC, TWAP_PERIOD);
963     }
964 
965     function twap() external view returns (uint) {
966         return assetToAsset(KP3R, 1e18, USDC, TWAP_NOW);
967     }
968 
969     function calc(uint amount) public view returns (uint) {
970         uint _strike = assetToAsset(KP3R, amount, USDC, TWAP_PERIOD);
971         uint _price = assetToAsset(KP3R, amount, USDC, TWAP_NOW);
972         _strike = _strike * discount / BASE;
973         _price = _price * discount / BASE;
974         return _strike > _price ? _strike : _price;
975     }
976 
977     function deposit(uint _amount) external returns (bool) {
978         _safeTransferFrom(KP3R, msg.sender, address(this), _amount);
979         _mint(msg.sender, _amount);
980         return true;
981     }
982 
983     function claim() external returns (uint) {
984         uint _amount = balanceOf[msg.sender];
985         _burn(msg.sender, _amount);
986         return _claim(_amount);
987     }
988 
989     function claim(uint amount) external returns (uint) {
990         _burn(msg.sender, amount);
991         return _claim(amount);
992     }
993 
994     function _claim(uint amount) internal returns (uint) {
995         uint _strike = calc(amount);
996         uint _expiry = block.timestamp + OPTION_EXPIRY;
997         options.push(option(amount, _strike, _expiry, false));
998         oKP3R.mint(msg.sender, nextIndex);
999         emit Created(msg.sender, amount, _strike, _expiry, nextIndex);
1000         return nextIndex++;
1001     }
1002 
1003     function redeem(uint id) external {
1004         require(oKP3R.isApprovedOrOwner(msg.sender, id));
1005         option storage _opt = options[id];
1006         require(_opt.expiry >= block.timestamp && !_opt.exercised);
1007         _opt.exercised = true;
1008         _safeTransferFrom(USDC, msg.sender, treasury, _opt.strike);
1009         _safeTransfer(KP3R, msg.sender, _opt.amount);
1010         oKP3R.burn(id);
1011         emit Redeem(msg.sender, msg.sender, _opt.amount, _opt.strike, id);
1012     }
1013 
1014     function _mint(address to, uint amount) internal {
1015         // mint the amount
1016         totalSupply += amount;
1017         // transfer the amount to the recipient
1018         balanceOf[to] += amount;
1019         emit Transfer(address(0), to, amount);
1020     }
1021 
1022     function _burn(address from, uint amount) internal {
1023         // burn the amount
1024         totalSupply -= amount;
1025         // transfer the amount from the recipient
1026         balanceOf[from] -= amount;
1027         emit Transfer(from, address(0), amount);
1028     }
1029 
1030     function approve(address spender, uint amount) external returns (bool) {
1031         allowance[msg.sender][spender] = amount;
1032 
1033         emit Approval(msg.sender, spender, amount);
1034         return true;
1035     }
1036 
1037     function transfer(address dst, uint amount) external returns (bool) {
1038         _transferTokens(msg.sender, dst, amount);
1039         return true;
1040     }
1041 
1042     function transferFrom(address src, address dst, uint amount) external returns (bool) {
1043         address spender = msg.sender;
1044         uint spenderAllowance = allowance[src][spender];
1045 
1046         if (spender != src && spenderAllowance != type(uint).max) {
1047             uint newAllowance = spenderAllowance - amount;
1048             allowance[src][spender] = newAllowance;
1049 
1050             emit Approval(src, spender, newAllowance);
1051         }
1052 
1053         _transferTokens(src, dst, amount);
1054         return true;
1055     }
1056 
1057     function _transferTokens(address src, address dst, uint amount) internal {
1058         balanceOf[src] -= amount;
1059         balanceOf[dst] += amount;
1060 
1061         emit Transfer(src, dst, amount);
1062     }
1063 
1064     function _safeTransfer(address token, address to, uint256 value) internal {
1065         (bool success, bytes memory data) =
1066             token.call(abi.encodeWithSelector(erc20.transfer.selector, to, value));
1067         require(success && (data.length == 0 || abi.decode(data, (bool))));
1068     }
1069 
1070     function _safeTransferFrom(address token, address from, address to, uint256 value) internal {
1071         (bool success, bytes memory data) =
1072             token.call(abi.encodeWithSelector(erc20.transferFrom.selector, from, to, value));
1073         require(success && (data.length == 0 || abi.decode(data, (bool))));
1074     }
1075 }