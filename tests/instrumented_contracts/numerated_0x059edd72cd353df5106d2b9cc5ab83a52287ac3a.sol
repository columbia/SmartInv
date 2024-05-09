1 // Sources flattened with buidler v1.4.7 https://buidler.dev
2 
3 // File contracts/libs/IERC165.sol
4 
5 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
6 pragma solidity ^0.5.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others (`ERC165Checker`).
14  *
15  * For an implementation, see `ERC165`.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 
30 // File contracts/libs/ERC165.sol
31 
32 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
33 
34 pragma solidity ^0.5.0;
35 
36 
37 
38 /**
39  * @dev Implementation of the `IERC165` interface.
40  *
41  * Contracts may inherit from this and call `_registerInterface` to declare
42  * their support of an interface.
43  */
44 contract ERC165 is IERC165 {
45     /*
46      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
47      */
48     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
49 
50     /**
51      * @dev Mapping of interface ids to whether or not it's supported.
52      */
53     mapping(bytes4 => bool) private _supportedInterfaces;
54 
55     constructor () internal {
56         // Derived contracts need only register support for their own interfaces,
57         // we register support for ERC165 itself here
58         _registerInterface(_INTERFACE_ID_ERC165);
59     }
60 
61     /**
62      * @dev See `IERC165.supportsInterface`.
63      *
64      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
65      */
66     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
67         return _supportedInterfaces[interfaceId];
68     }
69 
70     /**
71      * @dev Registers the contract as an implementer of the interface defined by
72      * `interfaceId`. Support of the actual ERC165 interface is automatic and
73      * registering its interface id is not required.
74      *
75      * See `IERC165.supportsInterface`.
76      *
77      * Requirements:
78      *
79      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
80      */
81     function _registerInterface(bytes4 interfaceId) internal {
82         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
83         _supportedInterfaces[interfaceId] = true;
84     }
85 }
86 
87 
88 // File contracts/libs/IERC721.sol
89 
90 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
91 
92 pragma solidity ^0.5.0;
93 
94 
95 
96 /**
97  * @dev Required interface of an ERC721 compliant contract.
98  */
99 contract IERC721 is IERC165 {
100     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
101     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
102     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
103 
104     /**
105      * @dev Returns the number of NFTs in `owner`'s account.
106      */
107     function balanceOf(address owner) public view returns (uint256 balance);
108 
109     /**
110      * @dev Returns the owner of the NFT specified by `tokenId`.
111      */
112     function ownerOf(uint256 tokenId) public view returns (address owner);
113 
114     /**
115      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
116      * another (`to`).
117      *
118      *
119      *
120      * Requirements:
121      * - `from`, `to` cannot be zero.
122      * - `tokenId` must be owned by `from`.
123      * - If the caller is not `from`, it must be have been allowed to move this
124      * NFT by either `approve` or `setApproveForAll`.
125      */
126     function safeTransferFrom(address from, address to, uint256 tokenId) public;
127     /**
128      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
129      * another (`to`).
130      *
131      * Requirements:
132      * - If the caller is not `from`, it must be approved to move this NFT by
133      * either `approve` or `setApproveForAll`.
134      */
135     function transferFrom(address from, address to, uint256 tokenId) public;
136     function approve(address to, uint256 tokenId) public;
137     function getApproved(uint256 tokenId) public view returns (address operator);
138 
139     function setApprovalForAll(address operator, bool _approved) public;
140     function isApprovedForAll(address owner, address operator) public view returns (bool);
141 
142 
143     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
144 }
145 
146 
147 // File contracts/libs/SafeMath.sol
148 
149 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
150 
151 pragma solidity ^0.5.0;
152 
153 /**
154  * @dev Wrappers over Solidity's arithmetic operations with added overflow
155  * checks.
156  *
157  * Arithmetic operations in Solidity wrap on overflow. This can easily result
158  * in bugs, because programmers usually assume that an overflow raises an
159  * error, which is the standard behavior in high level programming languages.
160  * `SafeMath` restores this intuition by reverting the transaction when an
161  * operation overflows.
162  *
163  * Using this library instead of the unchecked operations eliminates an entire
164  * class of bugs, so it's recommended to use it always.
165  */
166 library SafeMath {
167     /**
168      * @dev Returns the addition of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `+` operator.
172      *
173      * Requirements:
174      * - Addition cannot overflow.
175      */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         uint256 c = a + b;
178         require(c >= a, "SafeMath: addition overflow");
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting on
185      * overflow (when the result is negative).
186      *
187      * Counterpart to Solidity's `-` operator.
188      *
189      * Requirements:
190      * - Subtraction cannot overflow.
191      */
192     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
193         require(b <= a, "SafeMath: subtraction overflow");
194         uint256 c = a - b;
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the multiplication of two unsigned integers, reverting on
201      * overflow.
202      *
203      * Counterpart to Solidity's `*` operator.
204      *
205      * Requirements:
206      * - Multiplication cannot overflow.
207      */
208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
210         // benefit is lost if 'b' is also tested.
211         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
212         if (a == 0) {
213             return 0;
214         }
215 
216         uint256 c = a * b;
217         require(c / a == b, "SafeMath: multiplication overflow");
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers. Reverts on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         // Solidity only automatically asserts when dividing by 0
235         require(b > 0, "SafeMath: division by zero");
236         uint256 c = a / b;
237         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
238 
239         return c;
240     }
241 }
242 
243 
244 // File contracts/libs/Address.sol
245 
246 // File: openzeppelin-solidity/contracts/utils/Address.sol
247 
248 pragma solidity ^0.5.0;
249 
250 /**
251  * @dev Collection of functions related to the address type,
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * This test is non-exhaustive, and there may be false-negatives: during the
258      * execution of a contract's constructor, its address will be reported as
259      * not containing a contract.
260      *
261      * > It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies in extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { size := extcodesize(account) }
272         return size > 0;
273     }
274 }
275 
276 
277 // File contracts/libs/Counters.sol
278 
279 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
280 
281 pragma solidity ^0.5.0;
282 
283 
284 
285 /**
286  * @title Counters
287  * @author Matt Condon (@shrugs)
288  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
289  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
290  *
291  * Include with `using Counters for Counters.Counter;`
292  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
293  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
294  * directly accessed.
295  */
296 library Counters {
297     using SafeMath for uint256;
298 
299     struct Counter {
300         // This variable should never be directly accessed by users of the library: interactions must be restricted to
301         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
302         // this feature: see https://github.com/ethereum/solidity/issues/4637
303         uint256 _value; // default: 0
304     }
305 
306     function current(Counter storage counter) internal view returns (uint256) {
307         return counter._value;
308     }
309 
310     function increment(Counter storage counter) internal {
311         counter._value += 1;
312     }
313 
314     function decrement(Counter storage counter) internal {
315         counter._value = counter._value.sub(1);
316     }
317 }
318 
319 
320 // File contracts/libs/IERC721Receiver.sol
321 
322 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
323 
324 pragma solidity ^0.5.0;
325 
326 /**
327  * @title ERC721 token receiver interface
328  * @dev Interface for any contract that wants to support safeTransfers
329  * from ERC721 asset contracts.
330  */
331 contract IERC721Receiver {
332     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
333     public returns (bytes4);
334 }
335 
336 
337 // File contracts/libs/ERC721.sol
338 
339 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
340 
341 pragma solidity ^0.5.0;
342 
343 
344 
345 
346 
347 
348 
349 /**
350  * @title ERC721 Non-Fungible Token Standard basic implementation
351  * @dev see https://eips.ethereum.org/EIPS/eip-721
352  */
353 contract ERC721 is ERC165, IERC721 {
354     using SafeMath for uint256;
355     using Address for address;
356     using Counters for Counters.Counter;
357 
358     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
359     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
360     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
361 
362     // Mapping from token ID to owner
363     mapping (uint256 => address) private _tokenOwner;
364 
365     // Mapping from token ID to approved address
366     mapping (uint256 => address) private _tokenApprovals;
367 
368     // Mapping from owner to number of owned token
369     mapping (address => Counters.Counter) private _ownedTokensCount;
370 
371     // Mapping from owner to operator approvals
372     mapping (address => mapping (address => bool)) private _operatorApprovals;
373     
374     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
375 
376     constructor () public {
377         // register the supported interfaces to conform to ERC721 via ERC165
378         _registerInterface(_INTERFACE_ID_ERC721);
379     }
380 
381 
382     function balanceOf(address owner) public view returns (uint256) {
383         require(owner != address(0), "ERC721: balance query for the zero address");
384 
385         return _ownedTokensCount[owner].current();
386     }
387 
388     function ownerOf(uint256 tokenId) public view returns (address) {
389         address owner = _tokenOwner[tokenId];
390         require(owner != address(0), "ERC721: owner query for nonexistent token");
391 
392         return owner;
393     }
394 
395     function approve(address to, uint256 tokenId) public {
396         address owner = ownerOf(tokenId);
397         require(to != owner, "ERC721: approval to current owner");
398 
399         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
400             "ERC721: approve caller is not owner nor approved for all"
401         );
402 
403         _tokenApprovals[tokenId] = to;
404         emit Approval(owner, to, tokenId);
405     }
406 
407     function getApproved(uint256 tokenId) public view returns (address) {
408         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
409 
410         return _tokenApprovals[tokenId];
411     }
412 
413     function setApprovalForAll(address to, bool approved) public {
414         require(to != msg.sender, "ERC721: approve to caller");
415 
416         _operatorApprovals[msg.sender][to] = approved;
417         emit ApprovalForAll(msg.sender, to, approved);
418     }
419 
420     function isApprovedForAll(address owner, address operator) public view returns (bool) {
421         return _operatorApprovals[owner][operator];
422     }
423 
424     function transferFrom(address from, address to, uint256 tokenId) public {
425         //solhint-disable-next-line max-line-length
426         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
427 
428         _transferFrom(from, to, tokenId);
429     }
430 
431     function safeTransferFrom(address from, address to, uint256 tokenId) public {
432         safeTransferFrom(from, to, tokenId, "");
433     }
434 
435     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
436         transferFrom(from, to, tokenId);
437         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
438     }
439 
440     function _exists(uint256 tokenId) internal view returns (bool) {
441         address owner = _tokenOwner[tokenId];
442         return owner != address(0);
443     }
444 
445     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
446         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
447         address owner = ownerOf(tokenId);
448         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
449     }
450 
451     function _mint(address to, uint256 tokenId) internal {
452         require(to != address(0), "ERC721: mint to the zero address");
453         require(!_exists(tokenId), "ERC721: token already minted");
454 
455         _tokenOwner[tokenId] = to;
456         _ownedTokensCount[to].increment();
457 
458         emit Transfer(address(0), to, tokenId);
459     }
460 
461     function _burn(address owner, uint256 tokenId) internal {
462         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
463 
464         _clearApproval(tokenId);
465 
466         _ownedTokensCount[owner].decrement();
467         _tokenOwner[tokenId] = address(0);
468 
469         emit Transfer(owner, address(0), tokenId);
470     }
471 
472     function _burn(uint256 tokenId) internal {
473         _burn(ownerOf(tokenId), tokenId);
474     }
475 
476     function _transferFrom(address from, address to, uint256 tokenId) internal {
477         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
478         require(to != address(0), "ERC721: transfer to the zero address");
479 
480         _clearApproval(tokenId);
481 
482         _ownedTokensCount[from].decrement();
483         _ownedTokensCount[to].increment();
484 
485         _tokenOwner[tokenId] = to;
486 
487         emit Transfer(from, to, tokenId);
488     }
489 
490     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
491     internal returns (bool)
492     {
493         if (!to.isContract()) {
494             return true;
495         }
496 
497         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
498         return (retval == _ERC721_RECEIVED);
499     }
500 
501     function _clearApproval(uint256 tokenId) private {
502         if (_tokenApprovals[tokenId] != address(0)) {
503             _tokenApprovals[tokenId] = address(0);
504         }
505     }
506 }
507 
508 
509 // File contracts/libs/IERC721Enumerable.sol
510 
511 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
512 
513 pragma solidity ^0.5.0;
514 
515 
516 
517 /**
518  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
519  * @dev See https://eips.ethereum.org/EIPS/eip-721
520  */
521 contract IERC721Enumerable is IERC721 {
522     function totalSupply() public view returns (uint256);
523     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
524 
525     function tokenByIndex(uint256 index) public view returns (uint256);
526 }
527 
528 
529 // File contracts/libs/ERC721Enumerable.sol
530 
531 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
532 
533 pragma solidity ^0.5.0;
534 
535 
536 
537 
538 
539 
540 
541 /**
542  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
543  * @dev See https://eips.ethereum.org/EIPS/eip-721
544  */
545 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
546     // Mapping from owner to list of owned token IDs
547     mapping(address => uint256[]) private _ownedTokens;
548 
549     // Mapping from token ID to index of the owner tokens list
550     mapping(uint256 => uint256) private _ownedTokensIndex;
551 
552     // Array with all token ids, used for enumeration
553     uint256[] private _allTokens;
554 
555     // Mapping from token id to position in the allTokens array
556     mapping(uint256 => uint256) private _allTokensIndex;
557 
558     /*
559      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
560      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
561      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
562      *
563      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
564      */
565     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
566 
567     /**
568      * @dev Constructor function.
569      */
570     constructor () public {
571         // register the supported interface to conform to ERC721Enumerable via ERC165
572         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
573     }
574 
575     /**
576      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
577      * @param owner address owning the tokens list to be accessed
578      * @param index uint256 representing the index to be accessed of the requested tokens list
579      * @return uint256 token ID at the given index of the tokens list owned by the requested address
580      */
581     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
582         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
583         return _ownedTokens[owner][index];
584     }
585 
586     /**
587      * @dev Gets the total amount of tokens stored by the contract.
588      * @return uint256 representing the total amount of tokens
589      */
590     function totalSupply() public view returns (uint256) {
591         return _allTokens.length;
592     }
593 
594     /**
595      * @dev Gets the token ID at a given index of all the tokens in this contract
596      * Reverts if the index is greater or equal to the total number of tokens.
597      * @param index uint256 representing the index to be accessed of the tokens list
598      * @return uint256 token ID at the given index of the tokens list
599      */
600     function tokenByIndex(uint256 index) public view returns (uint256) {
601         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
602         return _allTokens[index];
603     }
604 
605     /**
606      * @dev Internal function to transfer ownership of a given token ID to another address.
607      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
608      * @param from current owner of the token
609      * @param to address to receive the ownership of the given token ID
610      * @param tokenId uint256 ID of the token to be transferred
611      */
612     function _transferFrom(address from, address to, uint256 tokenId) internal {
613         super._transferFrom(from, to, tokenId);
614 
615         _removeTokenFromOwnerEnumeration(from, tokenId);
616 
617         _addTokenToOwnerEnumeration(to, tokenId);
618     }
619 
620     /**
621      * @dev Internal function to mint a new token.
622      * Reverts if the given token ID already exists.
623      * @param to address the beneficiary that will own the minted token
624      * @param tokenId uint256 ID of the token to be minted
625      */
626     function _mint(address to, uint256 tokenId) internal {
627         super._mint(to, tokenId);
628 
629         _addTokenToOwnerEnumeration(to, tokenId);
630 
631         _addTokenToAllTokensEnumeration(tokenId);
632     }
633 
634     /**
635      * @dev Internal function to burn a specific token.
636      * Reverts if the token does not exist.
637      * Deprecated, use _burn(uint256) instead.
638      * @param owner owner of the token to burn
639      * @param tokenId uint256 ID of the token being burned
640      */
641     function _burn(address owner, uint256 tokenId) internal {
642         super._burn(owner, tokenId);
643 
644         _removeTokenFromOwnerEnumeration(owner, tokenId);
645         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
646         _ownedTokensIndex[tokenId] = 0;
647 
648         _removeTokenFromAllTokensEnumeration(tokenId);
649     }
650 
651     /**
652      * @dev Gets the list of token IDs of the requested owner.
653      * @param owner address owning the tokens
654      * @return uint256[] List of token IDs owned by the requested address
655      */
656     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
657         return _ownedTokens[owner];
658     }
659 
660     /**
661      * @dev Private function to add a token to this extension's ownership-tracking data structures.
662      * @param to address representing the new owner of the given token ID
663      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
664      */
665     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
666         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
667         _ownedTokens[to].push(tokenId);
668     }
669 
670     /**
671      * @dev Private function to add a token to this extension's token tracking data structures.
672      * @param tokenId uint256 ID of the token to be added to the tokens list
673      */
674     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
675         _allTokensIndex[tokenId] = _allTokens.length;
676         _allTokens.push(tokenId);
677     }
678 
679     /**
680      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
681      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
682      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
683      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
684      * @param from address representing the previous owner of the given token ID
685      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
686      */
687     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
688         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
689         // then delete the last slot (swap and pop).
690 
691         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
692         uint256 tokenIndex = _ownedTokensIndex[tokenId];
693 
694         // When the token to delete is the last token, the swap operation is unnecessary
695         if (tokenIndex != lastTokenIndex) {
696             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
697 
698             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
699             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
700         }
701 
702         // This also deletes the contents at the last position of the array
703         _ownedTokens[from].length--;
704 
705         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
706         // lastTokenId, or just over the end of the array if the token was the last one).
707     }
708 
709     /**
710      * @dev Private function to remove a token from this extension's token tracking data structures.
711      * This has O(1) time complexity, but alters the order of the _allTokens array.
712      * @param tokenId uint256 ID of the token to be removed from the tokens list
713      */
714     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
715         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
716         // then delete the last slot (swap and pop).
717 
718         uint256 lastTokenIndex = _allTokens.length.sub(1);
719         uint256 tokenIndex = _allTokensIndex[tokenId];
720 
721         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
722         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
723         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
724         uint256 lastTokenId = _allTokens[lastTokenIndex];
725 
726         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
727         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
728 
729         // This also deletes the contents at the last position of the array
730         _allTokens.length--;
731         _allTokensIndex[tokenId] = 0;
732     }
733 }
734 
735 
736 // File contracts/libs/CustomERC721Metadata.sol
737 
738 // File: contracts/CustomERC721Metadata.sol
739 
740 pragma solidity ^0.5.0;
741 
742 
743 
744 
745 
746 
747 /**
748  * ERC721 base contract without the concept of tokenUri as this is managed by the parent
749  */
750 contract CustomERC721Metadata is ERC165, ERC721, ERC721Enumerable {
751 
752     // Token name
753     string private _name;
754 
755     // Token symbol
756     string private _symbol;
757 
758     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
759 
760     /**
761      * @dev Constructor function
762      */
763     constructor (string memory name, string memory symbol) public {
764         _name = name;
765         _symbol = symbol;
766 
767         // register the supported interfaces to conform to ERC721 via ERC165
768         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
769     }
770 
771     /**
772      * @dev Gets the token name
773      * @return string representing the token name
774      */
775     function name() external view returns (string memory) {
776         return _name;
777     }
778 
779     /**
780      * @dev Gets the token symbol
781      * @return string representing the token symbol
782      */
783     function symbol() external view returns (string memory) {
784         return _symbol;
785     }
786 
787 }
788 
789 
790 // File contracts/libs/Strings.sol
791 
792 // File: contracts/Strings.sol
793 
794 pragma solidity ^0.5.0;
795 
796 //https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
797 library Strings {
798 
799     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
800         return strConcat(_a, _b, "", "", "");
801     }
802 
803     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
804         return strConcat(_a, _b, _c, "", "");
805     }
806 
807     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
808         return strConcat(_a, _b, _c, _d, "");
809     }
810 
811     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
812         bytes memory _ba = bytes(_a);
813         bytes memory _bb = bytes(_b);
814         bytes memory _bc = bytes(_c);
815         bytes memory _bd = bytes(_d);
816         bytes memory _be = bytes(_e);
817         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
818         bytes memory babcde = bytes(abcde);
819         uint k = 0;
820         uint i = 0;
821         for (i = 0; i < _ba.length; i++) {
822             babcde[k++] = _ba[i];
823         }
824         for (i = 0; i < _bb.length; i++) {
825             babcde[k++] = _bb[i];
826         }
827         for (i = 0; i < _bc.length; i++) {
828             babcde[k++] = _bc[i];
829         }
830         for (i = 0; i < _bd.length; i++) {
831             babcde[k++] = _bd[i];
832         }
833         for (i = 0; i < _be.length; i++) {
834             babcde[k++] = _be[i];
835         }
836         return string(babcde);
837     }
838 
839     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
840         if (_i == 0) {
841             return "0";
842         }
843         uint j = _i;
844         uint len;
845         while (j != 0) {
846             len++;
847             j /= 10;
848         }
849         bytes memory bstr = new bytes(len);
850         uint k = len - 1;
851         while (_i != 0) {
852             bstr[k--] = byte(uint8(48 + _i % 10));
853             _i /= 10;
854         }
855         return string(bstr);
856     }
857 }
858 
859 
860 // File contracts/GenArt721.sol
861 
862 // File: contracts/GenArt721.sol
863 pragma solidity ^0.5.0;
864 
865 
866 
867 
868 contract GenArt721 is CustomERC721Metadata {
869     using SafeMath for uint256;
870 
871     event Mint(
872         address indexed _to,
873         uint256 indexed _tokenId,
874         uint256 indexed _projectId,
875         uint256 _invocations,
876         uint256 _value
877     );
878 
879     struct Project {
880         string name;
881         string artist;
882         string description;
883         string website;
884         string license;
885         bool dynamic;
886         address payable artistAddress;
887         address payable additionalPayee;
888         uint256 additionalPayeePercentage;
889         uint256 secondMarketRoyalty;
890         uint256 pricePerTokenInWei;
891         string projectBaseURI;
892         string projectBaseIpfsURI;
893         uint256 invocations;
894         uint256 maxInvocations;
895         string scriptJSON;
896         mapping(uint256 => string) scripts;
897         uint scriptCount;
898         string ipfsHash;
899         uint256 hashes;
900         bool useIpfs;
901         bool active;
902         bool locked;
903         bool paused;
904     }
905 
906     uint256 constant ONE_MILLION = 1_000_000;
907     mapping(uint256 => Project) projects;
908 
909     address payable public artblocksAddress;
910     uint256 public artblocksPercentage = 10;
911 
912     mapping(uint256 => string) public staticIpfsImageLink;
913     mapping(uint256 => uint256) public tokenIdToProjectId;
914     mapping(uint256 => uint256[]) internal projectIdToTokenIds;
915     mapping(uint256 => bytes32[]) internal tokenIdToHashes;
916     mapping(bytes32 => uint256) public hashToTokenId;
917 
918     address public admin;
919     mapping(address => bool) public isWhitelisted;
920 
921     uint256 public nextProjectId;
922 
923     modifier onlyValidTokenId(uint256 _tokenId) {
924         require(_exists(_tokenId), "Token ID does not exist");
925         _;
926     }
927 
928     modifier onlyUnlocked(uint256 _projectId) {
929         require(!projects[_projectId].locked, "Only if unlocked");
930         _;
931     }
932 
933     modifier onlyArtist(uint256 _projectId) {
934         require(msg.sender == projects[_projectId].artistAddress, "Only artist");
935         _;
936     }
937 
938     modifier onlyAdmin() {
939         require(msg.sender == admin, "Only admin");
940         _;
941     }
942 
943     modifier onlyWhitelisted() {
944         require(isWhitelisted[msg.sender], "Only whitelisted");
945         _;
946     }
947 
948     modifier onlyArtistOrWhitelisted(uint256 _projectId) {
949         require(isWhitelisted[msg.sender] || msg.sender == projects[_projectId].artistAddress, "Only artist or whitelisted");
950         _;
951     }
952 
953     constructor(string memory _tokenName, string memory _tokenSymbol) CustomERC721Metadata(_tokenName, _tokenSymbol) public {
954         admin = msg.sender;
955         isWhitelisted[msg.sender] = true;
956         artblocksAddress = msg.sender;
957     }
958 
959     function purchase(uint256 _projectId) public payable returns (uint256 _tokenId) {
960         return purchaseTo(msg.sender, _projectId);
961     }
962 
963     function purchaseTo(address _to, uint256 _projectId) public payable returns (uint256 _tokenId) {
964         require(msg.value >= projects[_projectId].pricePerTokenInWei, "Must send at least pricePerTokenInWei");
965         require(projects[_projectId].invocations.add(1) <= projects[_projectId].maxInvocations, "Must not exceed max invocations");
966         require(projects[_projectId].active || msg.sender == projects[_projectId].artistAddress, "Project must exist and be active");
967         require(!projects[_projectId].paused || msg.sender == projects[_projectId].artistAddress, "Purchases are paused.");
968 
969         uint256 tokenId = _mintToken(_to, _projectId);
970 
971         _splitFunds(_projectId);
972 
973         return tokenId;
974     }
975 
976     function _mintToken(address _to, uint256 _projectId) internal returns (uint256 _tokenId) {
977 
978         uint256 tokenIdToBe = (_projectId * ONE_MILLION) + projects[_projectId].invocations;
979 
980         projects[_projectId].invocations = projects[_projectId].invocations.add(1);
981 
982         for (uint256 i = 0; i < projects[_projectId].hashes; i++) {
983             bytes32 hash = keccak256(abi.encodePacked(projects[_projectId].invocations, block.number.add(i), msg.sender));
984             tokenIdToHashes[tokenIdToBe].push(hash);
985             hashToTokenId[hash] = tokenIdToBe;
986         }
987 
988         _mint(_to, tokenIdToBe);
989 
990         tokenIdToProjectId[tokenIdToBe] = _projectId;
991         projectIdToTokenIds[_projectId].push(tokenIdToBe);
992 
993         emit Mint(_to, tokenIdToBe, _projectId, projects[_projectId].invocations, projects[_projectId].pricePerTokenInWei);
994 
995         return tokenIdToBe;
996     }
997 
998     function _splitFunds(uint256 _projectId) internal {
999         if (msg.value > 0) {
1000 
1001             uint256 pricePerTokenInWei = projects[_projectId].pricePerTokenInWei;
1002             uint256 refund = msg.value.sub(projects[_projectId].pricePerTokenInWei);
1003 
1004             if (refund > 0) {
1005                 msg.sender.transfer(refund);
1006             }
1007 
1008             uint256 foundationAmount = pricePerTokenInWei.div(100).mul(artblocksPercentage);
1009             if (foundationAmount > 0) {
1010                 artblocksAddress.transfer(foundationAmount);
1011             }
1012 
1013             uint256 projectFunds = pricePerTokenInWei.sub(foundationAmount);
1014 
1015             uint256 additionalPayeeAmount;
1016             if (projects[_projectId].additionalPayeePercentage > 0) {
1017                 additionalPayeeAmount = projectFunds.div(100).mul(projects[_projectId].additionalPayeePercentage);
1018                 if (additionalPayeeAmount > 0) {
1019                     projects[_projectId].additionalPayee.transfer(additionalPayeeAmount);
1020                 }
1021             }
1022 
1023             uint256 creatorFunds = projectFunds.sub(additionalPayeeAmount);
1024             if (creatorFunds > 0) {
1025                 projects[_projectId].artistAddress.transfer(creatorFunds);
1026             }
1027         }
1028     }
1029 
1030     function updateArtblocksAddress(address payable _artblocksAddress) public onlyAdmin {
1031         artblocksAddress = _artblocksAddress;
1032     }
1033 
1034     function updateArtblocksPercentage(uint256 _artblocksPercentage) public onlyAdmin {
1035         require(_artblocksPercentage <= 25, "Max of 25%");
1036         artblocksPercentage = _artblocksPercentage;
1037     }
1038 
1039     function addWhitelisted(address _address) public onlyAdmin {
1040         isWhitelisted[_address] = true;
1041     }
1042 
1043     function removeWhitelisted(address _address) public onlyAdmin {
1044         isWhitelisted[_address] = false;
1045     }
1046 
1047     
1048     function toggleProjectIsLocked(uint256 _projectId) public onlyWhitelisted onlyUnlocked(_projectId) {
1049         projects[_projectId].locked = true;
1050     }
1051 
1052     function toggleProjectIsActive(uint256 _projectId) public onlyWhitelisted {
1053         projects[_projectId].active = !projects[_projectId].active;
1054     }
1055 
1056     function updateProjectArtistAddress(uint256 _projectId, address payable _artistAddress) public onlyArtistOrWhitelisted(_projectId) {
1057         projects[_projectId].artistAddress = _artistAddress;
1058     }
1059 
1060     function toggleProjectIsPaused(uint256 _projectId) public onlyArtist(_projectId) {
1061         projects[_projectId].paused = !projects[_projectId].paused;
1062     }
1063 
1064     function addProject(uint256 _pricePerTokenInWei, bool _dynamic) public onlyWhitelisted {
1065 
1066         uint256 projectId = nextProjectId;
1067         projects[projectId].artistAddress = msg.sender;
1068         projects[projectId].pricePerTokenInWei = _pricePerTokenInWei;
1069         projects[projectId].paused=true;
1070         projects[projectId].dynamic=_dynamic;
1071         projects[projectId].maxInvocations = ONE_MILLION;
1072         if (!_dynamic) {
1073             projects[projectId].hashes = 0;
1074         } else {
1075             projects[projectId].hashes = 1;
1076         }
1077         nextProjectId = nextProjectId.add(1);
1078     }
1079 
1080     function updateProjectPricePerTokenInWei(uint256 _projectId, uint256 _pricePerTokenInWei) onlyArtist(_projectId) public {
1081         projects[_projectId].pricePerTokenInWei = _pricePerTokenInWei;
1082     }
1083 
1084     function updateProjectName(uint256 _projectId, string memory _projectName) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1085         projects[_projectId].name = _projectName;
1086     }
1087 
1088     function updateProjectArtistName(uint256 _projectId, string memory _projectArtistName) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1089         projects[_projectId].artist = _projectArtistName;
1090     }
1091 
1092     function updateProjectAdditionalPayeeInfo(uint256 _projectId, address payable _additionalPayee, uint256 _additionalPayeePercentage) onlyArtist(_projectId) public {
1093         require(_additionalPayeePercentage <= 100, "Max of 100%");
1094         projects[_projectId].additionalPayee = _additionalPayee;
1095         projects[_projectId].additionalPayeePercentage = _additionalPayeePercentage;
1096     }
1097 
1098     function updateProjectSecondaryMarketRoyaltyPercentage(uint256 _projectId, uint256 _secondMarketRoyalty) onlyArtist(_projectId) public {
1099         require(_secondMarketRoyalty <= 100, "Max of 100%");
1100         projects[_projectId].secondMarketRoyalty = _secondMarketRoyalty;
1101     }
1102 
1103     function updateProjectDescription(uint256 _projectId, string memory _projectDescription) onlyArtist(_projectId) public {
1104         projects[_projectId].description = _projectDescription;
1105     }
1106 
1107     function updateProjectWebsite(uint256 _projectId, string memory _projectWebsite) onlyArtist(_projectId) public {
1108         projects[_projectId].website = _projectWebsite;
1109     }
1110 
1111     function updateProjectLicense(uint256 _projectId, string memory _projectLicense) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1112         projects[_projectId].license = _projectLicense;
1113     }
1114 
1115     function updateProjectMaxInvocations(uint256 _projectId, uint256 _maxInvocations) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1116         require(_maxInvocations > projects[_projectId].invocations, "You must set max invocations greater than current invocations");
1117         require(_maxInvocations <= ONE_MILLION, "Cannot exceed 1,000,000");
1118         projects[_projectId].maxInvocations = _maxInvocations;
1119     }
1120 
1121     function updateProjectHashesGenerated(uint256 _projectId, uint256 _hashes) onlyUnlocked(_projectId) onlyWhitelisted() public {
1122         require(projects[_projectId].invocations == 0, "Can not modify hashes generated after a token is minted.");
1123         require(projects[_projectId].dynamic, "Can only modify hashes on dynamic projects.");
1124         require(_hashes <= 100 && _hashes >= 0, "Hashes generated must be a positive integer and max hashes per invocation are 100");
1125         projects[_projectId].hashes = _hashes;
1126     }
1127 
1128     function addProjectScript(uint256 _projectId, string memory _script) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1129         projects[_projectId].scripts[projects[_projectId].scriptCount] = _script;
1130         projects[_projectId].scriptCount = projects[_projectId].scriptCount.add(1);
1131     }
1132 
1133     function updateProjectScript(uint256 _projectId, uint256 _scriptId, string memory _script) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1134         require(_scriptId < projects[_projectId].scriptCount, "scriptId out of range");
1135         projects[_projectId].scripts[_scriptId] = _script;
1136     }
1137 
1138     function removeProjectLastScript(uint256 _projectId) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1139         require(projects[_projectId].scriptCount > 0, "there are no scripts to remove");
1140         delete projects[_projectId].scripts[projects[_projectId].scriptCount - 1];
1141         projects[_projectId].scriptCount = projects[_projectId].scriptCount.sub(1);
1142     }
1143 
1144     function updateProjectScriptJSON(uint256 _projectId, string memory _projectScriptJSON) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1145         projects[_projectId].scriptJSON = _projectScriptJSON;
1146     }
1147 
1148     function updateProjectIpfsHash(uint256 _projectId, string memory _ipfsHash) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1149         projects[_projectId].ipfsHash = _ipfsHash;
1150     }
1151 
1152     function updateProjectBaseURI(uint256 _projectId, string memory _newBaseURI) onlyArtist(_projectId) public {
1153         projects[_projectId].projectBaseURI = _newBaseURI;
1154     }
1155 
1156     function updateProjectBaseIpfsURI(uint256 _projectId, string memory _projectBaseIpfsURI) onlyArtist(_projectId) public {
1157         projects[_projectId].projectBaseIpfsURI = _projectBaseIpfsURI;
1158     }
1159 
1160     function toggleProjectUseIpfsForStatic(uint256 _projectId) onlyArtist(_projectId) public {
1161         require(!projects[_projectId].dynamic, "can only set static IPFS hash for static projects");
1162         projects[_projectId].useIpfs = !projects[_projectId].useIpfs;
1163     }
1164 
1165     function toggleProjectIsDynamic(uint256 _projectId) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
1166       require(projects[_projectId].invocations == 0, "Can not switch after a token is minted.");
1167         if (projects[_projectId].dynamic) {
1168             projects[_projectId].hashes = 0;
1169         } else {
1170             projects[_projectId].hashes = 1;
1171         }
1172         projects[_projectId].dynamic = !projects[_projectId].dynamic;
1173     }
1174 
1175     function overrideTokenDynamicImageWithIpfsLink(uint256 _tokenId, string memory _ipfsHash) onlyArtist(tokenIdToProjectId[_tokenId]) public {
1176         staticIpfsImageLink[_tokenId] = _ipfsHash;
1177     }
1178 
1179     function clearTokenIpfsImageUri(uint256 _tokenId) onlyArtist(tokenIdToProjectId[_tokenId]) public {
1180         delete staticIpfsImageLink[tokenIdToProjectId[_tokenId]];
1181     }
1182 
1183     function projectDetails(uint256 _projectId) view public returns (string memory projectName, string memory artist, string memory description, string memory website, string memory license, bool dynamic) {
1184         projectName = projects[_projectId].name;
1185         artist = projects[_projectId].artist;
1186         description = projects[_projectId].description;
1187         website = projects[_projectId].website;
1188         license = projects[_projectId].license;
1189         dynamic = projects[_projectId].dynamic;
1190     }
1191 
1192     function projectTokenInfo(uint256 _projectId) view public returns (address artistAddress, uint256 pricePerTokenInWei, uint256 invocations, uint256 maxInvocations, bool active, address additionalPayee, uint256 additionalPayeePercentage) {
1193         artistAddress = projects[_projectId].artistAddress;
1194         pricePerTokenInWei = projects[_projectId].pricePerTokenInWei;
1195         invocations = projects[_projectId].invocations;
1196         maxInvocations = projects[_projectId].maxInvocations;
1197         active = projects[_projectId].active;
1198         additionalPayee = projects[_projectId].additionalPayee;
1199         additionalPayeePercentage = projects[_projectId].additionalPayeePercentage;
1200     }
1201 
1202     function projectScriptInfo(uint256 _projectId) view public returns (string memory scriptJSON, uint256 scriptCount, uint256 hashes, string memory ipfsHash, bool locked, bool paused) {
1203         scriptJSON = projects[_projectId].scriptJSON;
1204         scriptCount = projects[_projectId].scriptCount;
1205         hashes = projects[_projectId].hashes;
1206         ipfsHash = projects[_projectId].ipfsHash;
1207         locked = projects[_projectId].locked;
1208         paused = projects[_projectId].paused;
1209     }
1210 
1211     function projectScriptByIndex(uint256 _projectId, uint256 _index) view public returns (string memory){
1212         return projects[_projectId].scripts[_index];
1213     }
1214 
1215     function projectURIInfo(uint256 _projectId) view public returns (string memory projectBaseURI, string memory projectBaseIpfsURI, bool useIpfs) {
1216         projectBaseURI = projects[_projectId].projectBaseURI;
1217         projectBaseIpfsURI = projects[_projectId].projectBaseIpfsURI;
1218         useIpfs = projects[_projectId].useIpfs;
1219     }
1220 
1221     function projectShowAllTokens(uint _projectId) public view returns (uint256[] memory){
1222         return projectIdToTokenIds[_projectId];
1223     }
1224 
1225     function showTokenHashes(uint _tokenId) public view returns (bytes32[] memory){
1226         return tokenIdToHashes[_tokenId];
1227     }
1228 
1229     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1230         return _tokensOfOwner(owner);
1231     }
1232 
1233     function getRoyaltyData(uint256 _tokenId) public view returns (address artistAddress, address additionalPayee, uint256 additionalPayeePercentage, uint256 royaltyFeeByID) {
1234         artistAddress = projects[tokenIdToProjectId[_tokenId]].artistAddress;
1235         additionalPayee = projects[tokenIdToProjectId[_tokenId]].additionalPayee;
1236         additionalPayeePercentage = projects[tokenIdToProjectId[_tokenId]].additionalPayeePercentage;
1237         royaltyFeeByID = projects[tokenIdToProjectId[_tokenId]].secondMarketRoyalty;
1238     }
1239 
1240     function tokenURI(uint256 _tokenId) external view onlyValidTokenId(_tokenId) returns (string memory) {
1241         if (bytes(staticIpfsImageLink[_tokenId]).length > 0) {
1242             return Strings.strConcat(projects[tokenIdToProjectId[_tokenId]].projectBaseIpfsURI, staticIpfsImageLink[_tokenId]);
1243         }
1244 
1245         if (!projects[tokenIdToProjectId[_tokenId]].dynamic && projects[tokenIdToProjectId[_tokenId]].useIpfs) {
1246             return Strings.strConcat(projects[tokenIdToProjectId[_tokenId]].projectBaseIpfsURI, projects[tokenIdToProjectId[_tokenId]].ipfsHash);
1247         }
1248 
1249         return Strings.strConcat(projects[tokenIdToProjectId[_tokenId]].projectBaseURI, Strings.uint2str(_tokenId));
1250     }
1251 }
1252 
1253 
1254 // File contracts/mock/ERC721ReceiverMock.sol
1255 
1256 // SPDX-License-Identifier: MIT
1257 
1258 pragma solidity ^0.5.0;
1259 
1260 
1261 contract ERC721ReceiverMock is IERC721Receiver {
1262     bytes4 private _retval;
1263     bool private _reverts;
1264 
1265     event Received(address operator, address from, uint256 tokenId, bytes data, uint256 gas);
1266 
1267     constructor (bytes4 retval, bool reverts) public {
1268         _retval = retval;
1269         _reverts = reverts;
1270     }
1271 
1272     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
1273     public returns (bytes4)
1274     {
1275         require(!_reverts, "ERC721ReceiverMock: reverting");
1276         emit Received(operator, from, tokenId, data, gasleft());
1277         return _retval;
1278     }
1279 }