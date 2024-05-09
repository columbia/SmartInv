1 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title IERC165
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 interface IERC165 {
10     /**
11      * @notice Query if a contract implements an interface
12      * @param interfaceId The interface identifier, as specified in ERC-165
13      * @dev Interface identification is specified in ERC-165. This function
14      * uses less than 30,000 gas.
15      */
16     function supportsInterface(bytes4 interfaceId) external view returns (bool);
17 }
18 
19 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
20 
21 pragma solidity ^0.5.0;
22 
23 
24 /**
25  * @title ERC721 Non-Fungible Token Standard basic interface
26  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
27  */
28 contract IERC721 is IERC165 {
29     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
30     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
31     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
32 
33     function balanceOf(address owner) public view returns (uint256 balance);
34     function ownerOf(uint256 tokenId) public view returns (address owner);
35 
36     function approve(address to, uint256 tokenId) public;
37     function getApproved(uint256 tokenId) public view returns (address operator);
38 
39     function setApprovalForAll(address operator, bool _approved) public;
40     function isApprovedForAll(address owner, address operator) public view returns (bool);
41 
42     function transferFrom(address from, address to, uint256 tokenId) public;
43     function safeTransferFrom(address from, address to, uint256 tokenId) public;
44 
45     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
46 }
47 
48 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
49 
50 pragma solidity ^0.5.0;
51 
52 /**
53  * @title ERC721 token receiver interface
54  * @dev Interface for any contract that wants to support safeTransfers
55  * from ERC721 asset contracts.
56  */
57 contract IERC721Receiver {
58     /**
59      * @notice Handle the receipt of an NFT
60      * @dev The ERC721 smart contract calls this function on the recipient
61      * after a `safeTransfer`. This function MUST return the function selector,
62      * otherwise the caller will revert the transaction. The selector to be
63      * returned can be obtained as `this.onERC721Received.selector`. This
64      * function MAY throw to revert and reject the transfer.
65      * Note: the ERC721 contract address is always the message sender.
66      * @param operator The address which called `safeTransferFrom` function
67      * @param from The address which previously owned the token
68      * @param tokenId The NFT identifier which is being transferred
69      * @param data Additional data with no specified format
70      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
71      */
72     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
73     public returns (bytes4);
74 }
75 
76 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
77 
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @title SafeMath
82  * @dev Unsigned math operations with safety checks that revert on error
83  */
84 library SafeMath {
85     /**
86     * @dev Multiplies two unsigned integers, reverts on overflow.
87     */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
104     */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116     */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125     * @dev Adds two unsigned integers, reverts on overflow.
126     */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a);
130 
131         return c;
132     }
133 
134     /**
135     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
136     * reverts when dividing by zero.
137     */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         require(b != 0);
140         return a % b;
141     }
142 }
143 
144 // File: openzeppelin-solidity/contracts/utils/Address.sol
145 
146 pragma solidity ^0.5.0;
147 
148 /**
149  * Utility library of inline functions on addresses
150  */
151 library Address {
152     /**
153      * Returns whether the target address is a contract
154      * @dev This function will return false if invoked during the constructor of a contract,
155      * as the code is not actually created until after the constructor finishes.
156      * @param account address of the account to check
157      * @return whether the target address is a contract
158      */
159     function isContract(address account) internal view returns (bool) {
160         uint256 size;
161         // XXX Currently there is no better way to check if there is a contract in an address
162         // than to check the size of the code at that address.
163         // See https://ethereum.stackexchange.com/a/14016/36603
164         // for more details about how this works.
165         // TODO Check this again before the Serenity release, because all addresses will be
166         // contracts then.
167         // solhint-disable-next-line no-inline-assembly
168         assembly { size := extcodesize(account) }
169         return size > 0;
170     }
171 }
172 
173 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
174 
175 pragma solidity ^0.5.0;
176 
177 
178 /**
179  * @title ERC165
180  * @author Matt Condon (@shrugs)
181  * @dev Implements ERC165 using a lookup table.
182  */
183 contract ERC165 is IERC165 {
184     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
185     /**
186      * 0x01ffc9a7 ===
187      *     bytes4(keccak256('supportsInterface(bytes4)'))
188      */
189 
190     /**
191      * @dev a mapping of interface id to whether or not it's supported
192      */
193     mapping(bytes4 => bool) private _supportedInterfaces;
194 
195     /**
196      * @dev A contract implementing SupportsInterfaceWithLookup
197      * implement ERC165 itself
198      */
199     constructor () internal {
200         _registerInterface(_INTERFACE_ID_ERC165);
201     }
202 
203     /**
204      * @dev implement supportsInterface(bytes4) using a lookup table
205      */
206     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
207         return _supportedInterfaces[interfaceId];
208     }
209 
210     /**
211      * @dev internal method for registering an interface
212      */
213     function _registerInterface(bytes4 interfaceId) internal {
214         require(interfaceId != 0xffffffff);
215         _supportedInterfaces[interfaceId] = true;
216     }
217 }
218 
219 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
220 
221 pragma solidity ^0.5.0;
222 
223 
224 
225 
226 
227 
228 /**
229  * @title ERC721 Non-Fungible Token Standard basic implementation
230  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
231  */
232 contract ERC721 is ERC165, IERC721 {
233     using SafeMath for uint256;
234     using Address for address;
235 
236     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
237     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
238     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
239 
240     // Mapping from token ID to owner
241     mapping (uint256 => address) private _tokenOwner;
242 
243     // Mapping from token ID to approved address
244     mapping (uint256 => address) private _tokenApprovals;
245 
246     // Mapping from owner to number of owned token
247     mapping (address => uint256) private _ownedTokensCount;
248 
249     // Mapping from owner to operator approvals
250     mapping (address => mapping (address => bool)) private _operatorApprovals;
251 
252     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
253     /*
254      * 0x80ac58cd ===
255      *     bytes4(keccak256('balanceOf(address)')) ^
256      *     bytes4(keccak256('ownerOf(uint256)')) ^
257      *     bytes4(keccak256('approve(address,uint256)')) ^
258      *     bytes4(keccak256('getApproved(uint256)')) ^
259      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
260      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
261      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
262      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
263      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
264      */
265 
266     constructor () public {
267         // register the supported interfaces to conform to ERC721 via ERC165
268         _registerInterface(_INTERFACE_ID_ERC721);
269     }
270 
271     /**
272      * @dev Gets the balance of the specified address
273      * @param owner address to query the balance of
274      * @return uint256 representing the amount owned by the passed address
275      */
276     function balanceOf(address owner) public view returns (uint256) {
277         require(owner != address(0));
278         return _ownedTokensCount[owner];
279     }
280 
281     /**
282      * @dev Gets the owner of the specified token ID
283      * @param tokenId uint256 ID of the token to query the owner of
284      * @return owner address currently marked as the owner of the given token ID
285      */
286     function ownerOf(uint256 tokenId) public view returns (address) {
287         address owner = _tokenOwner[tokenId];
288         require(owner != address(0));
289         return owner;
290     }
291 
292     /**
293      * @dev Approves another address to transfer the given token ID
294      * The zero address indicates there is no approved address.
295      * There can only be one approved address per token at a given time.
296      * Can only be called by the token owner or an approved operator.
297      * @param to address to be approved for the given token ID
298      * @param tokenId uint256 ID of the token to be approved
299      */
300     function approve(address to, uint256 tokenId) public {
301         address owner = ownerOf(tokenId);
302         require(to != owner);
303         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
304 
305         _tokenApprovals[tokenId] = to;
306         emit Approval(owner, to, tokenId);
307     }
308 
309     /**
310      * @dev Gets the approved address for a token ID, or zero if no address set
311      * Reverts if the token ID does not exist.
312      * @param tokenId uint256 ID of the token to query the approval of
313      * @return address currently approved for the given token ID
314      */
315     function getApproved(uint256 tokenId) public view returns (address) {
316         require(_exists(tokenId));
317         return _tokenApprovals[tokenId];
318     }
319 
320     /**
321      * @dev Sets or unsets the approval of a given operator
322      * An operator is allowed to transfer all tokens of the sender on their behalf
323      * @param to operator address to set the approval
324      * @param approved representing the status of the approval to be set
325      */
326     function setApprovalForAll(address to, bool approved) public {
327         require(to != msg.sender);
328         _operatorApprovals[msg.sender][to] = approved;
329         emit ApprovalForAll(msg.sender, to, approved);
330     }
331 
332     /**
333      * @dev Tells whether an operator is approved by a given owner
334      * @param owner owner address which you want to query the approval of
335      * @param operator operator address which you want to query the approval of
336      * @return bool whether the given operator is approved by the given owner
337      */
338     function isApprovedForAll(address owner, address operator) public view returns (bool) {
339         return _operatorApprovals[owner][operator];
340     }
341 
342     /**
343      * @dev Transfers the ownership of a given token ID to another address
344      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
345      * Requires the msg sender to be the owner, approved, or operator
346      * @param from current owner of the token
347      * @param to address to receive the ownership of the given token ID
348      * @param tokenId uint256 ID of the token to be transferred
349     */
350     function transferFrom(address from, address to, uint256 tokenId) public {
351         require(_isApprovedOrOwner(msg.sender, tokenId));
352 
353         _transferFrom(from, to, tokenId);
354     }
355 
356     /**
357      * @dev Safely transfers the ownership of a given token ID to another address
358      * If the target address is a contract, it must implement `onERC721Received`,
359      * which is called upon a safe transfer, and return the magic value
360      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
361      * the transfer is reverted.
362      *
363      * Requires the msg sender to be the owner, approved, or operator
364      * @param from current owner of the token
365      * @param to address to receive the ownership of the given token ID
366      * @param tokenId uint256 ID of the token to be transferred
367     */
368     function safeTransferFrom(address from, address to, uint256 tokenId) public {
369         safeTransferFrom(from, to, tokenId, "");
370     }
371 
372     /**
373      * @dev Safely transfers the ownership of a given token ID to another address
374      * If the target address is a contract, it must implement `onERC721Received`,
375      * which is called upon a safe transfer, and return the magic value
376      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
377      * the transfer is reverted.
378      * Requires the msg sender to be the owner, approved, or operator
379      * @param from current owner of the token
380      * @param to address to receive the ownership of the given token ID
381      * @param tokenId uint256 ID of the token to be transferred
382      * @param _data bytes data to send along with a safe transfer check
383      */
384     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
385         transferFrom(from, to, tokenId);
386         require(_checkOnERC721Received(from, to, tokenId, _data));
387     }
388 
389     /**
390      * @dev Returns whether the specified token exists
391      * @param tokenId uint256 ID of the token to query the existence of
392      * @return whether the token exists
393      */
394     function _exists(uint256 tokenId) internal view returns (bool) {
395         address owner = _tokenOwner[tokenId];
396         return owner != address(0);
397     }
398 
399     /**
400      * @dev Returns whether the given spender can transfer a given token ID
401      * @param spender address of the spender to query
402      * @param tokenId uint256 ID of the token to be transferred
403      * @return bool whether the msg.sender is approved for the given token ID,
404      *    is an operator of the owner, or is the owner of the token
405      */
406     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
407         address owner = ownerOf(tokenId);
408         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
409     }
410 
411     /**
412      * @dev Internal function to mint a new token
413      * Reverts if the given token ID already exists
414      * @param to The address that will own the minted token
415      * @param tokenId uint256 ID of the token to be minted
416      */
417     function _mint(address to, uint256 tokenId) internal {
418         require(to != address(0));
419         require(!_exists(tokenId));
420 
421         _tokenOwner[tokenId] = to;
422         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
423 
424         emit Transfer(address(0), to, tokenId);
425     }
426 
427     /**
428      * @dev Internal function to burn a specific token
429      * Reverts if the token does not exist
430      * Deprecated, use _burn(uint256) instead.
431      * @param owner owner of the token to burn
432      * @param tokenId uint256 ID of the token being burned
433      */
434     function _burn(address owner, uint256 tokenId) internal {
435         require(ownerOf(tokenId) == owner);
436 
437         _clearApproval(tokenId);
438 
439         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
440         _tokenOwner[tokenId] = address(0);
441 
442         emit Transfer(owner, address(0), tokenId);
443     }
444 
445     /**
446      * @dev Internal function to burn a specific token
447      * Reverts if the token does not exist
448      * @param tokenId uint256 ID of the token being burned
449      */
450     function _burn(uint256 tokenId) internal {
451         _burn(ownerOf(tokenId), tokenId);
452     }
453 
454     /**
455      * @dev Internal function to transfer ownership of a given token ID to another address.
456      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
457      * @param from current owner of the token
458      * @param to address to receive the ownership of the given token ID
459      * @param tokenId uint256 ID of the token to be transferred
460     */
461     function _transferFrom(address from, address to, uint256 tokenId) internal {
462         require(ownerOf(tokenId) == from);
463         require(to != address(0));
464 
465         _clearApproval(tokenId);
466 
467         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
468         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
469 
470         _tokenOwner[tokenId] = to;
471 
472         emit Transfer(from, to, tokenId);
473     }
474 
475     /**
476      * @dev Internal function to invoke `onERC721Received` on a target address
477      * The call is not executed if the target address is not a contract
478      * @param from address representing the previous owner of the given token ID
479      * @param to target address that will receive the tokens
480      * @param tokenId uint256 ID of the token to be transferred
481      * @param _data bytes optional data to send along with the call
482      * @return whether the call correctly returned the expected magic value
483      */
484     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
485         internal returns (bool)
486     {
487         if (!to.isContract()) {
488             return true;
489         }
490 
491         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
492         return (retval == _ERC721_RECEIVED);
493     }
494 
495     /**
496      * @dev Private function to clear current approval of a given token ID
497      * @param tokenId uint256 ID of the token to be transferred
498      */
499     function _clearApproval(uint256 tokenId) private {
500         if (_tokenApprovals[tokenId] != address(0)) {
501             _tokenApprovals[tokenId] = address(0);
502         }
503     }
504 }
505 
506 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
507 
508 pragma solidity ^0.5.0;
509 
510 
511 /**
512  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
513  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
514  */
515 contract IERC721Enumerable is IERC721 {
516     function totalSupply() public view returns (uint256);
517     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
518 
519     function tokenByIndex(uint256 index) public view returns (uint256);
520 }
521 
522 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
523 
524 pragma solidity ^0.5.0;
525 
526 
527 
528 
529 /**
530  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
531  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
532  */
533 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
534     // Mapping from owner to list of owned token IDs
535     mapping(address => uint256[]) private _ownedTokens;
536 
537     // Mapping from token ID to index of the owner tokens list
538     mapping(uint256 => uint256) private _ownedTokensIndex;
539 
540     // Array with all token ids, used for enumeration
541     uint256[] private _allTokens;
542 
543     // Mapping from token id to position in the allTokens array
544     mapping(uint256 => uint256) private _allTokensIndex;
545 
546     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
547     /**
548      * 0x780e9d63 ===
549      *     bytes4(keccak256('totalSupply()')) ^
550      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
551      *     bytes4(keccak256('tokenByIndex(uint256)'))
552      */
553 
554     /**
555      * @dev Constructor function
556      */
557     constructor () public {
558         // register the supported interface to conform to ERC721 via ERC165
559         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
560     }
561 
562     /**
563      * @dev Gets the token ID at a given index of the tokens list of the requested owner
564      * @param owner address owning the tokens list to be accessed
565      * @param index uint256 representing the index to be accessed of the requested tokens list
566      * @return uint256 token ID at the given index of the tokens list owned by the requested address
567      */
568     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
569         require(index < balanceOf(owner));
570         return _ownedTokens[owner][index];
571     }
572 
573     /**
574      * @dev Gets the total amount of tokens stored by the contract
575      * @return uint256 representing the total amount of tokens
576      */
577     function totalSupply() public view returns (uint256) {
578         return _allTokens.length;
579     }
580 
581     /**
582      * @dev Gets the token ID at a given index of all the tokens in this contract
583      * Reverts if the index is greater or equal to the total number of tokens
584      * @param index uint256 representing the index to be accessed of the tokens list
585      * @return uint256 token ID at the given index of the tokens list
586      */
587     function tokenByIndex(uint256 index) public view returns (uint256) {
588         require(index < totalSupply());
589         return _allTokens[index];
590     }
591 
592     /**
593      * @dev Internal function to transfer ownership of a given token ID to another address.
594      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
595      * @param from current owner of the token
596      * @param to address to receive the ownership of the given token ID
597      * @param tokenId uint256 ID of the token to be transferred
598     */
599     function _transferFrom(address from, address to, uint256 tokenId) internal {
600         super._transferFrom(from, to, tokenId);
601 
602         _removeTokenFromOwnerEnumeration(from, tokenId);
603 
604         _addTokenToOwnerEnumeration(to, tokenId);
605     }
606 
607     /**
608      * @dev Internal function to mint a new token
609      * Reverts if the given token ID already exists
610      * @param to address the beneficiary that will own the minted token
611      * @param tokenId uint256 ID of the token to be minted
612      */
613     function _mint(address to, uint256 tokenId) internal {
614         super._mint(to, tokenId);
615 
616         _addTokenToOwnerEnumeration(to, tokenId);
617 
618         _addTokenToAllTokensEnumeration(tokenId);
619     }
620 
621     /**
622      * @dev Internal function to burn a specific token
623      * Reverts if the token does not exist
624      * Deprecated, use _burn(uint256) instead
625      * @param owner owner of the token to burn
626      * @param tokenId uint256 ID of the token being burned
627      */
628     function _burn(address owner, uint256 tokenId) internal {
629         super._burn(owner, tokenId);
630 
631         _removeTokenFromOwnerEnumeration(owner, tokenId);
632         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
633         _ownedTokensIndex[tokenId] = 0;
634 
635         _removeTokenFromAllTokensEnumeration(tokenId);
636     }
637 
638     /**
639      * @dev Gets the list of token IDs of the requested owner
640      * @param owner address owning the tokens
641      * @return uint256[] List of token IDs owned by the requested address
642      */
643     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
644         return _ownedTokens[owner];
645     }
646 
647     /**
648      * @dev Private function to add a token to this extension's ownership-tracking data structures.
649      * @param to address representing the new owner of the given token ID
650      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
651      */
652     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
653         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
654         _ownedTokens[to].push(tokenId);
655     }
656 
657     /**
658      * @dev Private function to add a token to this extension's token tracking data structures.
659      * @param tokenId uint256 ID of the token to be added to the tokens list
660      */
661     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
662         _allTokensIndex[tokenId] = _allTokens.length;
663         _allTokens.push(tokenId);
664     }
665 
666     /**
667      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
668      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
669      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
670      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
671      * @param from address representing the previous owner of the given token ID
672      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
673      */
674     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
675         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
676         // then delete the last slot (swap and pop).
677 
678         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
679         uint256 tokenIndex = _ownedTokensIndex[tokenId];
680 
681         // When the token to delete is the last token, the swap operation is unnecessary
682         if (tokenIndex != lastTokenIndex) {
683             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
684 
685             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
686             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
687         }
688 
689         // This also deletes the contents at the last position of the array
690         _ownedTokens[from].length--;
691 
692         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
693         // lasTokenId, or just over the end of the array if the token was the last one).
694     }
695 
696     /**
697      * @dev Private function to remove a token from this extension's token tracking data structures.
698      * This has O(1) time complexity, but alters the order of the _allTokens array.
699      * @param tokenId uint256 ID of the token to be removed from the tokens list
700      */
701     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
702         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
703         // then delete the last slot (swap and pop).
704 
705         uint256 lastTokenIndex = _allTokens.length.sub(1);
706         uint256 tokenIndex = _allTokensIndex[tokenId];
707 
708         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
709         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
710         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
711         uint256 lastTokenId = _allTokens[lastTokenIndex];
712 
713         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
714         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
715 
716         // This also deletes the contents at the last position of the array
717         _allTokens.length--;
718         _allTokensIndex[tokenId] = 0;
719     }
720 }
721 
722 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
723 
724 pragma solidity ^0.5.0;
725 
726 
727 /**
728  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
729  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
730  */
731 contract IERC721Metadata is IERC721 {
732     function name() external view returns (string memory);
733     function symbol() external view returns (string memory);
734     function tokenURI(uint256 tokenId) external view returns (string memory);
735 }
736 
737 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
738 
739 pragma solidity ^0.5.0;
740 
741 
742 
743 
744 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
745     // Token name
746     string private _name;
747 
748     // Token symbol
749     string private _symbol;
750 
751     // Optional mapping for token URIs
752     mapping(uint256 => string) private _tokenURIs;
753 
754     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
755     /**
756      * 0x5b5e139f ===
757      *     bytes4(keccak256('name()')) ^
758      *     bytes4(keccak256('symbol()')) ^
759      *     bytes4(keccak256('tokenURI(uint256)'))
760      */
761 
762     /**
763      * @dev Constructor function
764      */
765     constructor (string memory name, string memory symbol) public {
766         _name = name;
767         _symbol = symbol;
768 
769         // register the supported interfaces to conform to ERC721 via ERC165
770         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
771     }
772 
773     /**
774      * @dev Gets the token name
775      * @return string representing the token name
776      */
777     function name() external view returns (string memory) {
778         return _name;
779     }
780 
781     /**
782      * @dev Gets the token symbol
783      * @return string representing the token symbol
784      */
785     function symbol() external view returns (string memory) {
786         return _symbol;
787     }
788 
789     /**
790      * @dev Returns an URI for a given token ID
791      * Throws if the token ID does not exist. May return an empty string.
792      * @param tokenId uint256 ID of the token to query
793      */
794     function tokenURI(uint256 tokenId) external view returns (string memory) {
795         require(_exists(tokenId));
796         return _tokenURIs[tokenId];
797     }
798 
799     /**
800      * @dev Internal function to set the token URI for a given token
801      * Reverts if the token ID does not exist
802      * @param tokenId uint256 ID of the token to set its URI
803      * @param uri string URI to assign
804      */
805     function _setTokenURI(uint256 tokenId, string memory uri) internal {
806         require(_exists(tokenId));
807         _tokenURIs[tokenId] = uri;
808     }
809 
810     /**
811      * @dev Internal function to burn a specific token
812      * Reverts if the token does not exist
813      * Deprecated, use _burn(uint256) instead
814      * @param owner owner of the token to burn
815      * @param tokenId uint256 ID of the token being burned by the msg.sender
816      */
817     function _burn(address owner, uint256 tokenId) internal {
818         super._burn(owner, tokenId);
819 
820         // Clear metadata (if any)
821         if (bytes(_tokenURIs[tokenId]).length != 0) {
822             delete _tokenURIs[tokenId];
823         }
824     }
825 }
826 
827 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
828 
829 pragma solidity ^0.5.0;
830 
831 
832 
833 
834 /**
835  * @title Full ERC721 Token
836  * This implementation includes all the required and some optional functionality of the ERC721 standard
837  * Moreover, it includes approve all functionality using operator terminology
838  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
839  */
840 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
841     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
842         // solhint-disable-previous-line no-empty-blocks
843     }
844 }
845 
846 // File: openzeppelin-solidity/contracts/access/Roles.sol
847 
848 pragma solidity ^0.5.0;
849 
850 /**
851  * @title Roles
852  * @dev Library for managing addresses assigned to a Role.
853  */
854 library Roles {
855     struct Role {
856         mapping (address => bool) bearer;
857     }
858 
859     /**
860      * @dev give an account access to this role
861      */
862     function add(Role storage role, address account) internal {
863         require(account != address(0));
864         require(!has(role, account));
865 
866         role.bearer[account] = true;
867     }
868 
869     /**
870      * @dev remove an account's access to this role
871      */
872     function remove(Role storage role, address account) internal {
873         require(account != address(0));
874         require(has(role, account));
875 
876         role.bearer[account] = false;
877     }
878 
879     /**
880      * @dev check if an account has this role
881      * @return bool
882      */
883     function has(Role storage role, address account) internal view returns (bool) {
884         require(account != address(0));
885         return role.bearer[account];
886     }
887 }
888 
889 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
890 
891 pragma solidity ^0.5.0;
892 
893 
894 contract MinterRole {
895     using Roles for Roles.Role;
896 
897     event MinterAdded(address indexed account);
898     event MinterRemoved(address indexed account);
899 
900     Roles.Role private _minters;
901 
902     constructor () internal {
903         _addMinter(msg.sender);
904     }
905 
906     modifier onlyMinter() {
907         require(isMinter(msg.sender));
908         _;
909     }
910 
911     function isMinter(address account) public view returns (bool) {
912         return _minters.has(account);
913     }
914 
915     function addMinter(address account) public onlyMinter {
916         _addMinter(account);
917     }
918 
919     function renounceMinter() public {
920         _removeMinter(msg.sender);
921     }
922 
923     function _addMinter(address account) internal {
924         _minters.add(account);
925         emit MinterAdded(account);
926     }
927 
928     function _removeMinter(address account) internal {
929         _minters.remove(account);
930         emit MinterRemoved(account);
931     }
932 }
933 
934 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol
935 
936 pragma solidity ^0.5.0;
937 
938 
939 
940 /**
941  * @title ERC721Mintable
942  * @dev ERC721 minting logic
943  */
944 contract ERC721Mintable is ERC721, MinterRole {
945     /**
946      * @dev Function to mint tokens
947      * @param to The address that will receive the minted tokens.
948      * @param tokenId The token id to mint.
949      * @return A boolean that indicates if the operation was successful.
950      */
951     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
952         _mint(to, tokenId);
953         return true;
954     }
955 }
956 
957 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721MetadataMintable.sol
958 
959 pragma solidity ^0.5.0;
960 
961 
962 
963 
964 /**
965  * @title ERC721MetadataMintable
966  * @dev ERC721 minting logic with metadata
967  */
968 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
969     /**
970      * @dev Function to mint tokens
971      * @param to The address that will receive the minted tokens.
972      * @param tokenId The token id to mint.
973      * @param tokenURI The token URI of the minted token.
974      * @return A boolean that indicates if the operation was successful.
975      */
976     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter returns (bool) {
977         _mint(to, tokenId);
978         _setTokenURI(tokenId, tokenURI);
979         return true;
980     }
981 }
982 
983 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Burnable.sol
984 
985 pragma solidity ^0.5.0;
986 
987 
988 /**
989  * @title ERC721 Burnable Token
990  * @dev ERC721 Token that can be irreversibly burned (destroyed).
991  */
992 contract ERC721Burnable is ERC721 {
993     /**
994      * @dev Burns a specific ERC721 token.
995      * @param tokenId uint256 id of the ERC721 token to be burned.
996      */
997     function burn(uint256 tokenId) public {
998         require(_isApprovedOrOwner(msg.sender, tokenId));
999         _burn(tokenId);
1000     }
1001 }
1002 
1003 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1004 
1005 pragma solidity ^0.5.0;
1006 
1007 /**
1008  * @title Ownable
1009  * @dev The Ownable contract has an owner address, and provides basic authorization control
1010  * functions, this simplifies the implementation of "user permissions".
1011  */
1012 contract Ownable {
1013     address private _owner;
1014 
1015     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1016 
1017     /**
1018      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1019      * account.
1020      */
1021     constructor () internal {
1022         _owner = msg.sender;
1023         emit OwnershipTransferred(address(0), _owner);
1024     }
1025 
1026     /**
1027      * @return the address of the owner.
1028      */
1029     function owner() public view returns (address) {
1030         return _owner;
1031     }
1032 
1033     /**
1034      * @dev Throws if called by any account other than the owner.
1035      */
1036     modifier onlyOwner() {
1037         require(isOwner());
1038         _;
1039     }
1040 
1041     /**
1042      * @return true if `msg.sender` is the owner of the contract.
1043      */
1044     function isOwner() public view returns (bool) {
1045         return msg.sender == _owner;
1046     }
1047 
1048     /**
1049      * @dev Allows the current owner to relinquish control of the contract.
1050      * @notice Renouncing to ownership will leave the contract without an owner.
1051      * It will not be possible to call the functions with the `onlyOwner`
1052      * modifier anymore.
1053      */
1054     function renounceOwnership() public onlyOwner {
1055         emit OwnershipTransferred(_owner, address(0));
1056         _owner = address(0);
1057     }
1058 
1059     /**
1060      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1061      * @param newOwner The address to transfer ownership to.
1062      */
1063     function transferOwnership(address newOwner) public onlyOwner {
1064         _transferOwnership(newOwner);
1065     }
1066 
1067     /**
1068      * @dev Transfers control of the contract to a newOwner.
1069      * @param newOwner The address to transfer ownership to.
1070      */
1071     function _transferOwnership(address newOwner) internal {
1072         require(newOwner != address(0));
1073         emit OwnershipTransferred(_owner, newOwner);
1074         _owner = newOwner;
1075     }
1076 }
1077 
1078 // File: contracts/key/DozerDollKeyBase.sol
1079 
1080 pragma solidity ^0.5.0;
1081 
1082 
1083 
1084 
1085 
1086 
1087 
1088 contract DozerDollKeyBase is ERC721Full, ERC721Mintable, ERC721MetadataMintable, ERC721Burnable, Ownable {
1089     using SafeMath for uint256;
1090     uint256 internal itemsIndex;
1091     uint256 internal currentPrice;
1092     address payable ownerAddress;
1093 
1094     event EventWithdraw(address _to, uint256 _value);
1095 
1096     function mintUniqueTokenTo(address _to, uint256 _tokenId, string memory _tokenURI) internal {
1097         _mint(_to, _tokenId);
1098         _setTokenURI(_tokenId, _tokenURI);
1099 
1100         itemsIndex = itemsIndex.add(1);
1101     }
1102 
1103     function mintUniqueTokenToOnlyOwner(address _to, uint256 _tokenId, string memory _tokenURI) public onlyOwner {
1104         _mint(_to, _tokenId);
1105         _setTokenURI(_tokenId, _tokenURI);
1106 
1107         itemsIndex = itemsIndex.add(1);
1108     }
1109 
1110 
1111     function getCurrentPrice() public view onlyOwner returns (uint256) {
1112         return currentPrice;
1113     }
1114 
1115 
1116     function setCurrentPrice(uint256 _currentPrice) public onlyOwner{
1117         require(_currentPrice > 0);
1118         currentPrice = _currentPrice;
1119     }
1120 
1121 
1122     function withdraw() public onlyOwner{
1123         ownerAddress.transfer(address(this).balance);
1124         emit EventWithdraw(msg.sender, address(this).balance);
1125     }
1126 }
1127 
1128 // File: contracts/key/DozerDollKey.sol
1129 
1130 pragma solidity ^0.5.0;
1131 
1132 
1133 contract DozerDollKey is DozerDollKeyBase {
1134     using SafeMath for uint256;
1135 
1136     string tokenURI;
1137     uint256 public prefix;
1138 
1139     event KeyMint(address _to, uint256 tokenId);
1140     event KeyExchange(address _to, uint256 tokenId);
1141 
1142     constructor (
1143         string memory _name, 
1144         string memory _symbol,
1145         string memory _tokenURI, 
1146         uint256 _currentPrice,
1147         uint256 _prefix
1148     ) 
1149         ERC721Mintable()
1150         ERC721Full(_name, _symbol) public {
1151 
1152         ownerAddress = msg.sender;
1153         tokenURI = _tokenURI;
1154         currentPrice = _currentPrice;
1155         prefix = _prefix;
1156     }
1157 
1158 
1159     function () external payable{
1160         require(address(msg.sender) != address(0) && address(msg.sender) != address(this));
1161         require(uint256(SafeMath.mod(uint256(msg.value), uint256(currentPrice))) == 0);
1162         
1163         uint256 amount = uint256(SafeMath.div(uint256(msg.value), uint256(currentPrice)));
1164 
1165         keyMint(msg.sender, amount);
1166     }
1167 
1168     function keyMint(
1169         address _to, 
1170         uint256 _amount) private {
1171 
1172         uint256 tokenId = 0;
1173 
1174         for (uint i = 0; i < _amount; i++) {
1175             tokenId = prefix + itemsIndex;
1176             mintUniqueTokenTo(_to, tokenId, tokenURI);
1177             emit KeyMint(_to, tokenId);
1178         }
1179     }
1180 
1181 
1182     function keyExchange(
1183         uint256 _tokenId) public {
1184 
1185         burn(_tokenId);
1186         emit KeyExchange(msg.sender, _tokenId);
1187     }
1188 
1189 
1190     function keyExchangeMultiple(
1191         uint256[] memory _tokenId) public {
1192 
1193         for (uint i = 0; i < _tokenId.length; i++) {
1194             keyExchange(_tokenId[i]);
1195         }
1196     }
1197 }