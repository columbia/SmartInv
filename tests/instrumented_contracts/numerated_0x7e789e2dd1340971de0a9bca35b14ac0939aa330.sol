1 /*
2  * Crypto stamp
3  * Digitalphysical collectible postage stamp
4  *
5  * Developed by capacity.at
6  * for post.at
7  */
8 
9 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
10 
11 pragma solidity ^0.5.0;
12 
13 /**
14  * @title IERC165
15  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
16  */
17 interface IERC165 {
18     /**
19      * @notice Query if a contract implements an interface
20      * @param interfaceId The interface identifier, as specified in ERC-165
21      * @dev Interface identification is specified in ERC-165. This function
22      * uses less than 30,000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
28 
29 pragma solidity ^0.5.0;
30 
31 
32 /**
33  * @title ERC721 Non-Fungible Token Standard basic interface
34  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
35  */
36 contract IERC721 is IERC165 {
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
40 
41     function balanceOf(address owner) public view returns (uint256 balance);
42     function ownerOf(uint256 tokenId) public view returns (address owner);
43 
44     function approve(address to, uint256 tokenId) public;
45     function getApproved(uint256 tokenId) public view returns (address operator);
46 
47     function setApprovalForAll(address operator, bool _approved) public;
48     function isApprovedForAll(address owner, address operator) public view returns (bool);
49 
50     function transferFrom(address from, address to, uint256 tokenId) public;
51     function safeTransferFrom(address from, address to, uint256 tokenId) public;
52 
53     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
54 }
55 
56 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
57 
58 pragma solidity ^0.5.0;
59 
60 /**
61  * @title ERC721 token receiver interface
62  * @dev Interface for any contract that wants to support safeTransfers
63  * from ERC721 asset contracts.
64  */
65 contract IERC721Receiver {
66     /**
67      * @notice Handle the receipt of an NFT
68      * @dev The ERC721 smart contract calls this function on the recipient
69      * after a `safeTransfer`. This function MUST return the function selector,
70      * otherwise the caller will revert the transaction. The selector to be
71      * returned can be obtained as `this.onERC721Received.selector`. This
72      * function MAY throw to revert and reject the transfer.
73      * Note: the ERC721 contract address is always the message sender.
74      * @param operator The address which called `safeTransferFrom` function
75      * @param from The address which previously owned the token
76      * @param tokenId The NFT identifier which is being transferred
77      * @param data Additional data with no specified format
78      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
79      */
80     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
81     public returns (bytes4);
82 }
83 
84 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
85 
86 pragma solidity ^0.5.0;
87 
88 /**
89  * @title SafeMath
90  * @dev Unsigned math operations with safety checks that revert on error
91  */
92 library SafeMath {
93     /**
94     * @dev Multiplies two unsigned integers, reverts on overflow.
95     */
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98         // benefit is lost if 'b' is also tested.
99         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100         if (a == 0) {
101             return 0;
102         }
103 
104         uint256 c = a * b;
105         require(c / a == b);
106 
107         return c;
108     }
109 
110     /**
111     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
112     */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
124     */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b <= a);
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     /**
133     * @dev Adds two unsigned integers, reverts on overflow.
134     */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a);
138 
139         return c;
140     }
141 
142     /**
143     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
144     * reverts when dividing by zero.
145     */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         require(b != 0);
148         return a % b;
149     }
150 }
151 
152 // File: openzeppelin-solidity/contracts/utils/Address.sol
153 
154 pragma solidity ^0.5.0;
155 
156 /**
157  * Utility library of inline functions on addresses
158  */
159 library Address {
160     /**
161      * Returns whether the target address is a contract
162      * @dev This function will return false if invoked during the constructor of a contract,
163      * as the code is not actually created until after the constructor finishes.
164      * @param account address of the account to check
165      * @return whether the target address is a contract
166      */
167     function isContract(address account) internal view returns (bool) {
168         uint256 size;
169         // XXX Currently there is no better way to check if there is a contract in an address
170         // than to check the size of the code at that address.
171         // See https://ethereum.stackexchange.com/a/14016/36603
172         // for more details about how this works.
173         // TODO Check this again before the Serenity release, because all addresses will be
174         // contracts then.
175         // solhint-disable-next-line no-inline-assembly
176         assembly { size := extcodesize(account) }
177         return size > 0;
178     }
179 }
180 
181 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
182 
183 pragma solidity ^0.5.0;
184 
185 
186 /**
187  * @title ERC165
188  * @author Matt Condon (@shrugs)
189  * @dev Implements ERC165 using a lookup table.
190  */
191 contract ERC165 is IERC165 {
192     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
193     /**
194      * 0x01ffc9a7 ===
195      *     bytes4(keccak256('supportsInterface(bytes4)'))
196      */
197 
198     /**
199      * @dev a mapping of interface id to whether or not it's supported
200      */
201     mapping(bytes4 => bool) private _supportedInterfaces;
202 
203     /**
204      * @dev A contract implementing SupportsInterfaceWithLookup
205      * implement ERC165 itself
206      */
207     constructor () internal {
208         _registerInterface(_INTERFACE_ID_ERC165);
209     }
210 
211     /**
212      * @dev implement supportsInterface(bytes4) using a lookup table
213      */
214     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
215         return _supportedInterfaces[interfaceId];
216     }
217 
218     /**
219      * @dev internal method for registering an interface
220      */
221     function _registerInterface(bytes4 interfaceId) internal {
222         require(interfaceId != 0xffffffff);
223         _supportedInterfaces[interfaceId] = true;
224     }
225 }
226 
227 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
228 
229 pragma solidity ^0.5.0;
230 
231 
232 
233 
234 
235 
236 /**
237  * @title ERC721 Non-Fungible Token Standard basic implementation
238  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
239  */
240 contract ERC721 is ERC165, IERC721 {
241     using SafeMath for uint256;
242     using Address for address;
243 
244     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
245     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
246     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
247 
248     // Mapping from token ID to owner
249     mapping (uint256 => address) private _tokenOwner;
250 
251     // Mapping from token ID to approved address
252     mapping (uint256 => address) private _tokenApprovals;
253 
254     // Mapping from owner to number of owned token
255     mapping (address => uint256) private _ownedTokensCount;
256 
257     // Mapping from owner to operator approvals
258     mapping (address => mapping (address => bool)) private _operatorApprovals;
259 
260     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
261     /*
262      * 0x80ac58cd ===
263      *     bytes4(keccak256('balanceOf(address)')) ^
264      *     bytes4(keccak256('ownerOf(uint256)')) ^
265      *     bytes4(keccak256('approve(address,uint256)')) ^
266      *     bytes4(keccak256('getApproved(uint256)')) ^
267      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
268      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
269      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
270      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
271      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
272      */
273 
274     constructor () public {
275         // register the supported interfaces to conform to ERC721 via ERC165
276         _registerInterface(_INTERFACE_ID_ERC721);
277     }
278 
279     /**
280      * @dev Gets the balance of the specified address
281      * @param owner address to query the balance of
282      * @return uint256 representing the amount owned by the passed address
283      */
284     function balanceOf(address owner) public view returns (uint256) {
285         require(owner != address(0));
286         return _ownedTokensCount[owner];
287     }
288 
289     /**
290      * @dev Gets the owner of the specified token ID
291      * @param tokenId uint256 ID of the token to query the owner of
292      * @return owner address currently marked as the owner of the given token ID
293      */
294     function ownerOf(uint256 tokenId) public view returns (address) {
295         address owner = _tokenOwner[tokenId];
296         require(owner != address(0));
297         return owner;
298     }
299 
300     /**
301      * @dev Approves another address to transfer the given token ID
302      * The zero address indicates there is no approved address.
303      * There can only be one approved address per token at a given time.
304      * Can only be called by the token owner or an approved operator.
305      * @param to address to be approved for the given token ID
306      * @param tokenId uint256 ID of the token to be approved
307      */
308     function approve(address to, uint256 tokenId) public {
309         address owner = ownerOf(tokenId);
310         require(to != owner);
311         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
312 
313         _tokenApprovals[tokenId] = to;
314         emit Approval(owner, to, tokenId);
315     }
316 
317     /**
318      * @dev Gets the approved address for a token ID, or zero if no address set
319      * Reverts if the token ID does not exist.
320      * @param tokenId uint256 ID of the token to query the approval of
321      * @return address currently approved for the given token ID
322      */
323     function getApproved(uint256 tokenId) public view returns (address) {
324         require(_exists(tokenId));
325         return _tokenApprovals[tokenId];
326     }
327 
328     /**
329      * @dev Sets or unsets the approval of a given operator
330      * An operator is allowed to transfer all tokens of the sender on their behalf
331      * @param to operator address to set the approval
332      * @param approved representing the status of the approval to be set
333      */
334     function setApprovalForAll(address to, bool approved) public {
335         require(to != msg.sender);
336         _operatorApprovals[msg.sender][to] = approved;
337         emit ApprovalForAll(msg.sender, to, approved);
338     }
339 
340     /**
341      * @dev Tells whether an operator is approved by a given owner
342      * @param owner owner address which you want to query the approval of
343      * @param operator operator address which you want to query the approval of
344      * @return bool whether the given operator is approved by the given owner
345      */
346     function isApprovedForAll(address owner, address operator) public view returns (bool) {
347         return _operatorApprovals[owner][operator];
348     }
349 
350     /**
351      * @dev Transfers the ownership of a given token ID to another address
352      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
353      * Requires the msg sender to be the owner, approved, or operator
354      * @param from current owner of the token
355      * @param to address to receive the ownership of the given token ID
356      * @param tokenId uint256 ID of the token to be transferred
357     */
358     function transferFrom(address from, address to, uint256 tokenId) public {
359         require(_isApprovedOrOwner(msg.sender, tokenId));
360 
361         _transferFrom(from, to, tokenId);
362     }
363 
364     /**
365      * @dev Safely transfers the ownership of a given token ID to another address
366      * If the target address is a contract, it must implement `onERC721Received`,
367      * which is called upon a safe transfer, and return the magic value
368      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
369      * the transfer is reverted.
370      *
371      * Requires the msg sender to be the owner, approved, or operator
372      * @param from current owner of the token
373      * @param to address to receive the ownership of the given token ID
374      * @param tokenId uint256 ID of the token to be transferred
375     */
376     function safeTransferFrom(address from, address to, uint256 tokenId) public {
377         safeTransferFrom(from, to, tokenId, "");
378     }
379 
380     /**
381      * @dev Safely transfers the ownership of a given token ID to another address
382      * If the target address is a contract, it must implement `onERC721Received`,
383      * which is called upon a safe transfer, and return the magic value
384      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
385      * the transfer is reverted.
386      * Requires the msg sender to be the owner, approved, or operator
387      * @param from current owner of the token
388      * @param to address to receive the ownership of the given token ID
389      * @param tokenId uint256 ID of the token to be transferred
390      * @param _data bytes data to send along with a safe transfer check
391      */
392     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
393         transferFrom(from, to, tokenId);
394         require(_checkOnERC721Received(from, to, tokenId, _data));
395     }
396 
397     /**
398      * @dev Returns whether the specified token exists
399      * @param tokenId uint256 ID of the token to query the existence of
400      * @return whether the token exists
401      */
402     function _exists(uint256 tokenId) internal view returns (bool) {
403         address owner = _tokenOwner[tokenId];
404         return owner != address(0);
405     }
406 
407     /**
408      * @dev Returns whether the given spender can transfer a given token ID
409      * @param spender address of the spender to query
410      * @param tokenId uint256 ID of the token to be transferred
411      * @return bool whether the msg.sender is approved for the given token ID,
412      *    is an operator of the owner, or is the owner of the token
413      */
414     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
415         address owner = ownerOf(tokenId);
416         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
417     }
418 
419     /**
420      * @dev Internal function to mint a new token
421      * Reverts if the given token ID already exists
422      * @param to The address that will own the minted token
423      * @param tokenId uint256 ID of the token to be minted
424      */
425     function _mint(address to, uint256 tokenId) internal {
426         require(to != address(0));
427         require(!_exists(tokenId));
428 
429         _tokenOwner[tokenId] = to;
430         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
431 
432         emit Transfer(address(0), to, tokenId);
433     }
434 
435     /**
436      * @dev Internal function to burn a specific token
437      * Reverts if the token does not exist
438      * Deprecated, use _burn(uint256) instead.
439      * @param owner owner of the token to burn
440      * @param tokenId uint256 ID of the token being burned
441      */
442     function _burn(address owner, uint256 tokenId) internal {
443         require(ownerOf(tokenId) == owner);
444 
445         _clearApproval(tokenId);
446 
447         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
448         _tokenOwner[tokenId] = address(0);
449 
450         emit Transfer(owner, address(0), tokenId);
451     }
452 
453     /**
454      * @dev Internal function to burn a specific token
455      * Reverts if the token does not exist
456      * @param tokenId uint256 ID of the token being burned
457      */
458     function _burn(uint256 tokenId) internal {
459         _burn(ownerOf(tokenId), tokenId);
460     }
461 
462     /**
463      * @dev Internal function to transfer ownership of a given token ID to another address.
464      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
465      * @param from current owner of the token
466      * @param to address to receive the ownership of the given token ID
467      * @param tokenId uint256 ID of the token to be transferred
468     */
469     function _transferFrom(address from, address to, uint256 tokenId) internal {
470         require(ownerOf(tokenId) == from);
471         require(to != address(0));
472 
473         _clearApproval(tokenId);
474 
475         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
476         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
477 
478         _tokenOwner[tokenId] = to;
479 
480         emit Transfer(from, to, tokenId);
481     }
482 
483     /**
484      * @dev Internal function to invoke `onERC721Received` on a target address
485      * The call is not executed if the target address is not a contract
486      * @param from address representing the previous owner of the given token ID
487      * @param to target address that will receive the tokens
488      * @param tokenId uint256 ID of the token to be transferred
489      * @param _data bytes optional data to send along with the call
490      * @return whether the call correctly returned the expected magic value
491      */
492     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
493         internal returns (bool)
494     {
495         if (!to.isContract()) {
496             return true;
497         }
498 
499         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
500         return (retval == _ERC721_RECEIVED);
501     }
502 
503     /**
504      * @dev Private function to clear current approval of a given token ID
505      * @param tokenId uint256 ID of the token to be transferred
506      */
507     function _clearApproval(uint256 tokenId) private {
508         if (_tokenApprovals[tokenId] != address(0)) {
509             _tokenApprovals[tokenId] = address(0);
510         }
511     }
512 }
513 
514 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
515 
516 pragma solidity ^0.5.0;
517 
518 
519 /**
520  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
521  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
522  */
523 contract IERC721Enumerable is IERC721 {
524     function totalSupply() public view returns (uint256);
525     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
526 
527     function tokenByIndex(uint256 index) public view returns (uint256);
528 }
529 
530 // File: contracts/ERC721EnumerableSimple.sol
531 
532 pragma solidity ^0.5.0;
533 
534 /* This is a simplified (and cheaper) version of OpenZeppelin's ERC721Enumerable.
535  * ERC721Enumerable's allTokens array and allTokensIndex mapping are eliminated.
536  * Side effects: _burn cannot be used any more with this, and creation needs to be
537  * in ascending order, starting with 0, and have no holes in the sequence of IDs.
538  */
539 
540 
541 
542 
543 /**
544  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
545  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
546  */
547 contract ERC721EnumerableSimple is ERC165, ERC721, IERC721Enumerable {
548     // Mapping from owner to list of owned token IDs
549     mapping(address => uint256[]) private _ownedTokens;
550 
551     // Mapping from token ID to index of the owner tokens list
552     mapping(uint256 => uint256) private _ownedTokensIndex;
553 
554     uint256 internal totalSupply_;
555 
556     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
557     /**
558      * 0x780e9d63 ===
559      *     bytes4(keccak256('totalSupply()')) ^
560      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
561      *     bytes4(keccak256('tokenByIndex(uint256)'))
562      */
563 
564     /**
565      * @dev Constructor function
566      */
567     constructor () public {
568         // register the supported interface to conform to ERC721 via ERC165
569         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
570     }
571 
572     /**
573      * @dev Gets the token ID at a given index of the tokens list of the requested owner
574      * @param owner address owning the tokens list to be accessed
575      * @param index uint256 representing the index to be accessed of the requested tokens list
576      * @return uint256 token ID at the given index of the tokens list owned by the requested address
577      */
578     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
579         require(index < balanceOf(owner), "Index is higher than number of tokens owned.");
580         return _ownedTokens[owner][index];
581     }
582 
583     /**
584      * @dev Gets the total amount of tokens stored by the contract
585      * @return uint256 representing the total amount of tokens
586      */
587     function totalSupply() public view returns (uint256) {
588         return totalSupply_;
589     }
590 
591 
592     /**
593      * @dev Gets the token ID at a given index of all the tokens in this contract
594      * Reverts if the index is greater or equal to the total number of tokens
595      * @param index uint256 representing the index to be accessed of the tokens list
596      * @return uint256 token ID at the given index of the tokens list
597      */
598     function tokenByIndex(uint256 index) public view returns (uint256) {
599         require(index < totalSupply(), "Index is out of bounds.");
600         return index;
601     }
602 
603 
604     /**
605      * @dev Internal function to transfer ownership of a given token ID to another address.
606      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
607      * @param from current owner of the token
608      * @param to address to receive the ownership of the given token ID
609      * @param tokenId uint256 ID of the token to be transferred
610     */
611     function _transferFrom(address from, address to, uint256 tokenId) internal {
612         super._transferFrom(from, to, tokenId);
613 
614         _removeTokenFromOwnerEnumeration(from, tokenId);
615 
616         _addTokenToOwnerEnumeration(to, tokenId);
617     }
618 
619     /**
620      * @dev Internal function to mint a new token
621      * Reverts if the given token ID already exists
622      * @param to address the beneficiary that will own the minted token
623      * @param tokenId uint256 ID of the token to be minted
624      */
625     function _mint(address to, uint256 tokenId) internal {
626         super._mint(to, tokenId);
627 
628         _addTokenToOwnerEnumeration(to, tokenId);
629 
630         totalSupply_ = totalSupply_.add(1);
631     }
632 
633     /**
634      * @dev Internal function to burn a specific token
635      * Reverts if the token does not exist
636      * Deprecated, use _burn(uint256) instead
637      * param owner owner of the token to burn
638      * param tokenId uint256 ID of the token being burned
639      */
640     function _burn(address /*owner*/, uint256 /*tokenId*/) internal {
641         revert("This token cannot be burned.");
642     }
643 
644     /**
645      * @dev Gets the list of token IDs of the requested owner
646      * @param owner address owning the tokens
647      * @return uint256[] List of token IDs owned by the requested address
648      */
649     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
650         return _ownedTokens[owner];
651     }
652 
653     /**
654      * @dev Private function to add a token to this extension's ownership-tracking data structures.
655      * @param to address representing the new owner of the given token ID
656      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
657      */
658     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
659         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
660         _ownedTokens[to].push(tokenId);
661     }
662 
663     /**
664      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
665      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
666      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
667      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
668      * @param from address representing the previous owner of the given token ID
669      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
670      */
671     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
672         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
673         // then delete the last slot (swap and pop).
674 
675         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
676         uint256 tokenIndex = _ownedTokensIndex[tokenId];
677 
678         // When the token to delete is the last token, the swap operation is unnecessary
679         if (tokenIndex != lastTokenIndex) {
680             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
681 
682             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
683             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
684         }
685 
686         // This also deletes the contents at the last position of the array
687         _ownedTokens[from].length--;
688 
689         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
690         // lasTokenId, or just over the end of the array if the token was the last one).
691     }
692 }
693 
694 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
695 
696 pragma solidity ^0.5.0;
697 
698 
699 /**
700  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
701  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
702  */
703 contract IERC721Metadata is IERC721 {
704     function name() external view returns (string memory);
705     function symbol() external view returns (string memory);
706     function tokenURI(uint256 tokenId) external view returns (string memory);
707 }
708 
709 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
710 
711 pragma solidity ^0.5.0;
712 
713 
714 
715 
716 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
717     // Token name
718     string private _name;
719 
720     // Token symbol
721     string private _symbol;
722 
723     // Optional mapping for token URIs
724     mapping(uint256 => string) private _tokenURIs;
725 
726     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
727     /**
728      * 0x5b5e139f ===
729      *     bytes4(keccak256('name()')) ^
730      *     bytes4(keccak256('symbol()')) ^
731      *     bytes4(keccak256('tokenURI(uint256)'))
732      */
733 
734     /**
735      * @dev Constructor function
736      */
737     constructor (string memory name, string memory symbol) public {
738         _name = name;
739         _symbol = symbol;
740 
741         // register the supported interfaces to conform to ERC721 via ERC165
742         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
743     }
744 
745     /**
746      * @dev Gets the token name
747      * @return string representing the token name
748      */
749     function name() external view returns (string memory) {
750         return _name;
751     }
752 
753     /**
754      * @dev Gets the token symbol
755      * @return string representing the token symbol
756      */
757     function symbol() external view returns (string memory) {
758         return _symbol;
759     }
760 
761     /**
762      * @dev Returns an URI for a given token ID
763      * Throws if the token ID does not exist. May return an empty string.
764      * @param tokenId uint256 ID of the token to query
765      */
766     function tokenURI(uint256 tokenId) external view returns (string memory) {
767         require(_exists(tokenId));
768         return _tokenURIs[tokenId];
769     }
770 
771     /**
772      * @dev Internal function to set the token URI for a given token
773      * Reverts if the token ID does not exist
774      * @param tokenId uint256 ID of the token to set its URI
775      * @param uri string URI to assign
776      */
777     function _setTokenURI(uint256 tokenId, string memory uri) internal {
778         require(_exists(tokenId));
779         _tokenURIs[tokenId] = uri;
780     }
781 
782     /**
783      * @dev Internal function to burn a specific token
784      * Reverts if the token does not exist
785      * Deprecated, use _burn(uint256) instead
786      * @param owner owner of the token to burn
787      * @param tokenId uint256 ID of the token being burned by the msg.sender
788      */
789     function _burn(address owner, uint256 tokenId) internal {
790         super._burn(owner, tokenId);
791 
792         // Clear metadata (if any)
793         if (bytes(_tokenURIs[tokenId]).length != 0) {
794             delete _tokenURIs[tokenId];
795         }
796     }
797 }
798 
799 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
800 
801 pragma solidity ^0.5.0;
802 
803 /**
804  * @title ERC20 interface
805  * @dev see https://github.com/ethereum/EIPs/issues/20
806  */
807 interface IERC20 {
808     function transfer(address to, uint256 value) external returns (bool);
809 
810     function approve(address spender, uint256 value) external returns (bool);
811 
812     function transferFrom(address from, address to, uint256 value) external returns (bool);
813 
814     function totalSupply() external view returns (uint256);
815 
816     function balanceOf(address who) external view returns (uint256);
817 
818     function allowance(address owner, address spender) external view returns (uint256);
819 
820     event Transfer(address indexed from, address indexed to, uint256 value);
821 
822     event Approval(address indexed owner, address indexed spender, uint256 value);
823 }
824 
825 // File: contracts/Cryptostamp.sol
826 
827 /*
828 Implements ERC 721 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
829 */
830 pragma solidity ^0.5.0;
831 
832 
833 
834 
835 
836 /* The inheritance is very much the same as OpenZeppelin's ERC721Full,
837  * but using a simplified (and cheaper) version of ERC721Enumerable */
838 contract Cryptostamp is ERC721, ERC721EnumerableSimple, ERC721Metadata("Crypto stamp Edition 1", "CS1") {
839 
840     string public uribase;
841 
842     address public createControl;
843 
844     address public tokenAssignmentControl;
845 
846     bool public mintingFinished = false;
847 
848     constructor(address _createControl, address _tokenAssignmentControl)
849     public
850     {
851         createControl = _createControl;
852         tokenAssignmentControl = _tokenAssignmentControl;
853         uribase = "https://test.crypto.post.at/CS1/meta/";
854     }
855 
856     modifier onlyCreateControl()
857     {
858         require(msg.sender == createControl, "createControl key required for this function.");
859         _;
860     }
861 
862     modifier onlyTokenAssignmentControl() {
863         require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");
864         _;
865     }
866 
867     modifier requireMinting() {
868         require(mintingFinished == false, "This call only works when minting is not finished.");
869         _;
870     }
871 
872     // Issue a new crypto stamp asset, giving it to a specific owner address.
873     // As appending the ID into a URI in Solidity is complicated, generate both
874     // externally and hand them over to the asset here.
875     function create(uint256 _tokenId, address _owner)
876     public
877     onlyCreateControl
878     requireMinting
879     {
880         // Make sure we do not get any holes in Ids so we can do more optimizations.
881         require(_tokenId == 0 || _exists(_tokenId.sub(1)), "Previous token ID has to exist.");
882         // _mint already ends up checking if owner != 0 and that tokenId doesn't exist yet.
883         _mint(_owner, _tokenId);
884     }
885 
886     // Batch-issue multiple crypto stamp with adjacent IDs.
887     function createMulti(uint256 _tokenIdStart, address[] memory _owners)
888     public
889     onlyCreateControl
890     requireMinting
891     {
892         // Make sure we do not get any holes in Ids so we can do more optimizations.
893         require(_tokenIdStart == 0 || _exists(_tokenIdStart.sub(1)), "Previous token ID has to exist.");
894         uint256 addrcount = _owners.length;
895         for (uint256 i = 0; i < addrcount; i++) {
896             // Make sure this is in sync with what create() does.
897             _mint(_owners[i], _tokenIdStart + i);
898         }
899     }
900 
901     // Finish the creation/minting process.
902     function finishMinting()
903     public
904     onlyCreateControl
905     {
906         mintingFinished = true;
907     }
908 
909     // Set new base for the token URI.
910     function newUriBase(string memory _newUriBase)
911     public
912     onlyCreateControl
913     {
914         uribase = _newUriBase;
915     }
916 
917     // Override ERC721Metadata to create the URI from the base and ID.
918     function tokenURI(uint256 _tokenId)
919     external view
920     returns (string memory)
921     {
922         require(_exists(_tokenId), "Token ID does not exist.");
923         return string(abi.encodePacked(uribase, uint2str(_tokenId)));
924     }
925 
926     // Returns whether the specified token exists
927     function exists(uint256 tokenId) public view returns (bool) {
928         return _exists(tokenId);
929     }
930 
931     // Helper function from Oraclize
932     // https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
933     function uint2str(uint256 inp)
934     internal pure
935     returns (string memory)
936     {
937         if (inp == 0) return "0";
938         uint i = inp;
939         uint j = i;
940         uint length;
941         while (j != 0){
942             length++;
943             j /= 10;
944         }
945         bytes memory bstr = new bytes(length);
946         uint k = length - 1;
947         while (i != 0){
948             bstr[k--] = byte(uint8(48 + i % 10));
949             i /= 10;
950         }
951         return string(bstr);
952     }
953 
954     /*** Make sure currency doesn't get stranded in this contract ***/
955 
956     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
957     function rescueToken(IERC20 _foreignToken, address _to)
958     external
959     onlyTokenAssignmentControl
960     {
961         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
962     }
963 
964     // Make sure this contract cannot receive ETH.
965     function()
966     external payable
967     {
968         revert("The contract cannot receive ETH payments.");
969     }
970 }