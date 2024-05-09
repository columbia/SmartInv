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
846 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
847 
848 pragma solidity ^0.5.0;
849 
850 /**
851  * @title Ownable
852  * @dev The Ownable contract has an owner address, and provides basic authorization control
853  * functions, this simplifies the implementation of "user permissions".
854  */
855 contract Ownable {
856     address private _owner;
857 
858     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
859 
860     /**
861      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
862      * account.
863      */
864     constructor () internal {
865         _owner = msg.sender;
866         emit OwnershipTransferred(address(0), _owner);
867     }
868 
869     /**
870      * @return the address of the owner.
871      */
872     function owner() public view returns (address) {
873         return _owner;
874     }
875 
876     /**
877      * @dev Throws if called by any account other than the owner.
878      */
879     modifier onlyOwner() {
880         require(isOwner());
881         _;
882     }
883 
884     /**
885      * @return true if `msg.sender` is the owner of the contract.
886      */
887     function isOwner() public view returns (bool) {
888         return msg.sender == _owner;
889     }
890 
891     /**
892      * @dev Allows the current owner to relinquish control of the contract.
893      * @notice Renouncing to ownership will leave the contract without an owner.
894      * It will not be possible to call the functions with the `onlyOwner`
895      * modifier anymore.
896      */
897     function renounceOwnership() public onlyOwner {
898         emit OwnershipTransferred(_owner, address(0));
899         _owner = address(0);
900     }
901 
902     /**
903      * @dev Allows the current owner to transfer control of the contract to a newOwner.
904      * @param newOwner The address to transfer ownership to.
905      */
906     function transferOwnership(address newOwner) public onlyOwner {
907         _transferOwnership(newOwner);
908     }
909 
910     /**
911      * @dev Transfers control of the contract to a newOwner.
912      * @param newOwner The address to transfer ownership to.
913      */
914     function _transferOwnership(address newOwner) internal {
915         require(newOwner != address(0));
916         emit OwnershipTransferred(_owner, newOwner);
917         _owner = newOwner;
918     }
919 }
920 
921 // File: openzeppelin-solidity/contracts/access/Roles.sol
922 
923 pragma solidity ^0.5.0;
924 
925 /**
926  * @title Roles
927  * @dev Library for managing addresses assigned to a Role.
928  */
929 library Roles {
930     struct Role {
931         mapping (address => bool) bearer;
932     }
933 
934     /**
935      * @dev give an account access to this role
936      */
937     function add(Role storage role, address account) internal {
938         require(account != address(0));
939         require(!has(role, account));
940 
941         role.bearer[account] = true;
942     }
943 
944     /**
945      * @dev remove an account's access to this role
946      */
947     function remove(Role storage role, address account) internal {
948         require(account != address(0));
949         require(has(role, account));
950 
951         role.bearer[account] = false;
952     }
953 
954     /**
955      * @dev check if an account has this role
956      * @return bool
957      */
958     function has(Role storage role, address account) internal view returns (bool) {
959         require(account != address(0));
960         return role.bearer[account];
961     }
962 }
963 
964 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
965 
966 pragma solidity ^0.5.0;
967 
968 
969 /**
970  * @title WhitelistAdminRole
971  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
972  */
973 contract WhitelistAdminRole {
974     using Roles for Roles.Role;
975 
976     event WhitelistAdminAdded(address indexed account);
977     event WhitelistAdminRemoved(address indexed account);
978 
979     Roles.Role private _whitelistAdmins;
980 
981     constructor () internal {
982         _addWhitelistAdmin(msg.sender);
983     }
984 
985     modifier onlyWhitelistAdmin() {
986         require(isWhitelistAdmin(msg.sender));
987         _;
988     }
989 
990     function isWhitelistAdmin(address account) public view returns (bool) {
991         return _whitelistAdmins.has(account);
992     }
993 
994     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
995         _addWhitelistAdmin(account);
996     }
997 
998     function renounceWhitelistAdmin() public {
999         _removeWhitelistAdmin(msg.sender);
1000     }
1001 
1002     function _addWhitelistAdmin(address account) internal {
1003         _whitelistAdmins.add(account);
1004         emit WhitelistAdminAdded(account);
1005     }
1006 
1007     function _removeWhitelistAdmin(address account) internal {
1008         _whitelistAdmins.remove(account);
1009         emit WhitelistAdminRemoved(account);
1010     }
1011 }
1012 
1013 // File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
1014 
1015 pragma solidity ^0.5.0;
1016 
1017 
1018 
1019 /**
1020  * @title WhitelistedRole
1021  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
1022  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
1023  * it), and not Whitelisteds themselves.
1024  */
1025 contract WhitelistedRole is WhitelistAdminRole {
1026     using Roles for Roles.Role;
1027 
1028     event WhitelistedAdded(address indexed account);
1029     event WhitelistedRemoved(address indexed account);
1030 
1031     Roles.Role private _whitelisteds;
1032 
1033     modifier onlyWhitelisted() {
1034         require(isWhitelisted(msg.sender));
1035         _;
1036     }
1037 
1038     function isWhitelisted(address account) public view returns (bool) {
1039         return _whitelisteds.has(account);
1040     }
1041 
1042     function addWhitelisted(address account) public onlyWhitelistAdmin {
1043         _addWhitelisted(account);
1044     }
1045 
1046     function removeWhitelisted(address account) public onlyWhitelistAdmin {
1047         _removeWhitelisted(account);
1048     }
1049 
1050     function renounceWhitelisted() public {
1051         _removeWhitelisted(msg.sender);
1052     }
1053 
1054     function _addWhitelisted(address account) internal {
1055         _whitelisteds.add(account);
1056         emit WhitelistedAdded(account);
1057     }
1058 
1059     function _removeWhitelisted(address account) internal {
1060         _whitelisteds.remove(account);
1061         emit WhitelistedRemoved(account);
1062     }
1063 }
1064 
1065 // File: contracts/libs/Strings.sol
1066 
1067 pragma solidity 0.5.0;
1068 
1069 library Strings {
1070 
1071     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1072     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
1073         bytes memory _ba = bytes(_a);
1074         bytes memory _bb = bytes(_b);
1075         bytes memory _bc = bytes(_c);
1076         bytes memory _bd = bytes(_d);
1077         bytes memory _be = bytes(_e);
1078         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1079         bytes memory babcde = bytes(abcde);
1080         uint k = 0;
1081         uint i = 0;
1082         for (i = 0; i < _ba.length; i++) {
1083             babcde[k++] = _ba[i];
1084         }
1085         for (i = 0; i < _bb.length; i++) {
1086             babcde[k++] = _bb[i];
1087         }
1088         for (i = 0; i < _bc.length; i++) {
1089             babcde[k++] = _bc[i];
1090         }
1091         for (i = 0; i < _bd.length; i++) {
1092             babcde[k++] = _bd[i];
1093         }
1094         for (i = 0; i < _be.length; i++) {
1095             babcde[k++] = _be[i];
1096         }
1097         return string(babcde);
1098     }
1099 
1100     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1101         return strConcat(_a, _b, "", "", "");
1102     }
1103 
1104     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
1105         return strConcat(_a, _b, _c, "", "");
1106     }
1107 
1108     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1109         if (_i == 0) {
1110             return "0";
1111         }
1112         uint j = _i;
1113         uint len;
1114         while (j != 0) {
1115             len++;
1116             j /= 10;
1117         }
1118         bytes memory bstr = new bytes(len);
1119         uint k = len - 1;
1120         while (_i != 0) {
1121             bstr[k--] = byte(uint8(48 + _i % 10));
1122             _i /= 10;
1123         }
1124         return string(bstr);
1125     }
1126 }
1127 
1128 // File: contracts/erc721/ERC721MetadataWithoutTokenUri.sol
1129 
1130 pragma solidity 0.5.0;
1131 
1132 
1133 
1134 
1135 contract ERC721MetadataWithoutTokenUri is ERC165, ERC721, IERC721Metadata {
1136     // Token name
1137     string private _name;
1138 
1139     // Token symbol
1140     string private _symbol;
1141 
1142     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1143     /**
1144      * 0x5b5e139f ===
1145      *     bytes4(keccak256('name()')) ^
1146      *     bytes4(keccak256('symbol()')) ^
1147      *     bytes4(keccak256('tokenURI(uint256)'))
1148      */
1149 
1150     /**
1151      * @dev Constructor function
1152      */
1153     constructor (string memory name, string memory symbol) public {
1154         _name = name;
1155         _symbol = symbol;
1156 
1157         // register the supported interfaces to conform to ERC721 via ERC165
1158         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1159     }
1160 
1161     /**
1162      * @dev Gets the token name
1163      * @return string representing the token name
1164      */
1165     function name() external view returns (string memory) {
1166         return _name;
1167     }
1168 
1169     /**
1170      * @dev Gets the token symbol
1171      * @return string representing the token symbol
1172      */
1173     function symbol() external view returns (string memory) {
1174         return _symbol;
1175     }
1176 
1177     /**
1178      * @dev Internal function to burn a specific token
1179      * Reverts if the token does not exist
1180      * Deprecated, use _burn(uint256) instead
1181      * @param owner owner of the token to burn
1182      * @param tokenId uint256 ID of the token being burned by the msg.sender
1183      */
1184     function _burn(address owner, uint256 tokenId) internal {
1185         super._burn(owner, tokenId);
1186     }
1187 }
1188 
1189 // File: contracts/erc721/CustomERC721Full.sol
1190 
1191 pragma solidity 0.5.0;
1192 
1193 
1194 
1195 
1196 /**
1197  * @title Full ERC721 Token without token URI as this is handled in the base contract
1198  *
1199  * This implementation includes all the required and some optional functionality of the ERC721 standard
1200  * Moreover, it includes approve all functionality using operator terminology
1201  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1202  */
1203 contract CustomERC721Full is ERC721, ERC721Enumerable, ERC721MetadataWithoutTokenUri {
1204     constructor (string memory name, string memory symbol) public ERC721MetadataWithoutTokenUri(name, symbol) {
1205         // solhint-disable-previous-line no-empty-blocks
1206     }
1207 }
1208 
1209 // File: contracts/INiftyTradingCardCreator.sol
1210 
1211 pragma solidity 0.5.0;
1212 
1213 interface INiftyTradingCardCreator {
1214     function mintCard(
1215         uint256 _cardType,
1216         uint256 _nationality,
1217         uint256 _position,
1218         uint256 _ethnicity,
1219         uint256 _kit,
1220         uint256 _colour,
1221         address _to
1222     ) external returns (uint256 _tokenId);
1223 
1224     function setAttributes(
1225         uint256 _tokenId,
1226         uint256 _strength,
1227         uint256 _speed,
1228         uint256 _intelligence,
1229         uint256 _skill
1230     ) external returns (bool);
1231 
1232     function setName(
1233         uint256 _tokenId,
1234         uint256 _firstName,
1235         uint256 _lastName
1236     ) external returns (bool);
1237 
1238     function setAttributesAndName(
1239         uint256 _tokenId,
1240         uint256 _strength,
1241         uint256 _speed,
1242         uint256 _intelligence,
1243         uint256 _skill,
1244         uint256 _firstName,
1245         uint256 _lastName
1246     ) external returns (bool);
1247 }
1248 
1249 // File: contracts/INiftyTradingCardAttributes.sol
1250 
1251 pragma solidity 0.5.0;
1252 
1253 
1254 contract INiftyTradingCardAttributes is IERC721 {
1255 
1256     function attributesFlat(uint256 _tokenId) public view returns (
1257         uint256[5] memory attributes
1258     );
1259 
1260     function attributesAndName(uint256 _tokenId) public view returns (
1261         uint256 _strength,
1262         uint256 _speed,
1263         uint256 _intelligence,
1264         uint256 _skill,
1265         uint256 _special,
1266         uint256 _firstName,
1267         uint256 _lastName
1268     );
1269 
1270     function extras(uint256 _tokenId) public view returns (
1271         uint256 _badge,
1272         uint256 _sponsor,
1273         uint256 _number,
1274         uint256 _boots,
1275         uint256 _stars,
1276         uint256 _xp
1277     );
1278 
1279     function card(uint256 _tokenId) public view returns (
1280         uint256 _cardType,
1281         uint256 _nationality,
1282         uint256 _position,
1283         uint256 _ethnicity,
1284         uint256 _kit,
1285         uint256 _colour
1286     );
1287 
1288 }
1289 
1290 // File: contracts/NiftyTradingCard.sol
1291 
1292 pragma solidity 0.5.0;
1293 
1294 
1295 
1296 
1297 
1298 
1299 
1300 
1301 contract NiftyTradingCard is CustomERC721Full, WhitelistedRole, INiftyTradingCardCreator, INiftyTradingCardAttributes {
1302     using SafeMath for uint256;
1303 
1304     string public tokenBaseURI = "";
1305     string public tokenBaseIpfsURI = "https://ipfs.infura.io/ipfs/";
1306 
1307     event TokenBaseURIChanged(
1308         string _new
1309     );
1310 
1311     event TokenBaseIPFSURIChanged(
1312         string _new
1313     );
1314 
1315     event StaticIpfsTokenURISet(
1316         uint256 indexed _tokenId,
1317         string _ipfsHash
1318     );
1319 
1320     event StaticIpfsTokenURICleared(
1321         uint256 indexed _tokenId
1322     );
1323 
1324     event CardAttributesSet(
1325         uint256 indexed _tokenId,
1326         uint256 _strength,
1327         uint256 _speed,
1328         uint256 _intelligence,
1329         uint256 _skill
1330     );
1331 
1332     event NameSet(
1333         uint256 indexed _tokenId,
1334         uint256 _firstName,
1335         uint256 _lastName
1336     );
1337 
1338     event SpecialSet(
1339         uint256 indexed _tokenId,
1340         uint256 _value
1341     );
1342 
1343     event BadgeSet(
1344         uint256 indexed _tokenId,
1345         uint256 _value
1346     );
1347 
1348     event SponsorSet(
1349         uint256 indexed _tokenId,
1350         uint256 _value
1351     );
1352 
1353     event NumberSet(
1354         uint256 indexed _tokenId,
1355         uint256 _value
1356     );
1357 
1358     event BootsSet(
1359         uint256 indexed _tokenId,
1360         uint256 _value
1361     );
1362 
1363     event StarAdded(
1364         uint256 indexed _tokenId,
1365         uint256 _value
1366     );
1367 
1368     event XpAdded(
1369         uint256 indexed _tokenId,
1370         uint256 _value
1371     );
1372 
1373     struct Card {
1374         uint256 cardType;
1375 
1376         uint256 nationality;
1377         uint256 position;
1378 
1379         uint256 ethnicity;
1380 
1381         uint256 kit;
1382         uint256 colour;
1383     }
1384 
1385     struct Attributes {
1386         uint256 strength;
1387         uint256 speed;
1388         uint256 intelligence;
1389         uint256 skill;
1390         uint256 special;
1391     }
1392 
1393     struct Name {
1394         uint256 firstName;
1395         uint256 lastName;
1396     }
1397 
1398     struct Extras {
1399         uint256 badge;
1400         uint256 sponsor;
1401         uint256 number;
1402         uint256 boots;
1403         uint256 stars;
1404         uint256 xp;
1405     }
1406 
1407     modifier onlyWhitelistedOrTokenOwner(uint256 _tokenId){
1408         require(isWhitelisted(msg.sender) || ownerOf(_tokenId) == msg.sender, "Unable to set token image URI unless owner of whitelisted");
1409         _;
1410     }
1411 
1412     uint256 public tokenIdPointer = 0;
1413 
1414     mapping(uint256 => string) public staticIpfsImageLink;
1415     mapping(uint256 => Card) internal cardMapping;
1416     mapping(uint256 => Attributes) internal attributesMapping;
1417     mapping(uint256 => Name) internal namesMapping;
1418     mapping(uint256 => Extras) internal extrasMapping;
1419 
1420     function mintCard(
1421         uint256 _cardType,
1422         uint256 _nationality,
1423         uint256 _position,
1424         uint256 _ethnicity,
1425         uint256 _kit,
1426         uint256 _colour,
1427         address _to
1428     ) public onlyWhitelisted returns (uint256 _tokenId) {
1429 
1430         // increment pointer
1431         tokenIdPointer = tokenIdPointer.add(1);
1432 
1433         // create new card
1434         cardMapping[tokenIdPointer] = Card({
1435             cardType : _cardType,
1436             nationality : _nationality,
1437             position : _position,
1438             ethnicity : _ethnicity,
1439             kit : _kit,
1440             colour : _colour
1441             });
1442 
1443         // the magic bit!
1444         _mint(_to, tokenIdPointer);
1445 
1446         return tokenIdPointer;
1447     }
1448 
1449     function setAttributesAndName(
1450         uint256 _tokenId,
1451         uint256 _strength,
1452         uint256 _speed,
1453         uint256 _intelligence,
1454         uint256 _skill,
1455         uint256 _firstName,
1456         uint256 _lastName
1457     ) public onlyWhitelisted returns (bool) {
1458 
1459         attributesMapping[_tokenId] = Attributes({
1460             strength : _strength,
1461             speed : _speed,
1462             intelligence : _intelligence,
1463             skill : _skill,
1464             special : 0
1465             });
1466 
1467         namesMapping[_tokenId] = Name({
1468             firstName : _firstName,
1469             lastName : _lastName
1470             });
1471 
1472         return true;
1473     }
1474 
1475     function setAttributes(
1476         uint256 _tokenId,
1477         uint256 _strength,
1478         uint256 _speed,
1479         uint256 _intelligence,
1480         uint256 _skill
1481     ) public onlyWhitelisted returns (bool) {
1482         require(_exists(_tokenId), "Token does not exist");
1483 
1484         attributesMapping[_tokenId] = Attributes({
1485             strength : _strength,
1486             speed : _speed,
1487             intelligence : _intelligence,
1488             skill : _skill,
1489             special : 0
1490             });
1491 
1492         emit CardAttributesSet(
1493             _tokenId,
1494             _strength,
1495             _speed,
1496             _intelligence,
1497             _skill
1498         );
1499 
1500         return true;
1501     }
1502 
1503     function setName(
1504         uint256 _tokenId,
1505         uint256 _firstName,
1506         uint256 _lastName
1507     ) public onlyWhitelisted returns (bool) {
1508         require(_exists(_tokenId), "Token does not exist");
1509 
1510         namesMapping[_tokenId] = Name({
1511             firstName : _firstName,
1512             lastName : _lastName
1513             });
1514 
1515         emit NameSet(
1516             _tokenId,
1517             _firstName,
1518             _lastName
1519         );
1520 
1521         return true;
1522     }
1523 
1524     function card(uint256 _tokenId) public view returns (
1525         uint256 _cardType,
1526         uint256 _nationality,
1527         uint256 _position,
1528         uint256 _ethnicity,
1529         uint256 _kit,
1530         uint256 _colour
1531     ) {
1532         require(_exists(_tokenId), "Token does not exist");
1533         Card storage tokenCard = cardMapping[_tokenId];
1534         return (
1535         tokenCard.cardType,
1536         tokenCard.nationality,
1537         tokenCard.position,
1538         tokenCard.ethnicity,
1539         tokenCard.kit,
1540         tokenCard.colour
1541         );
1542     }
1543 
1544     function attributesAndName(uint256 _tokenId) public view returns (
1545         uint256 _strength,
1546         uint256 _speed,
1547         uint256 _intelligence,
1548         uint256 _skill,
1549         uint256 _special,
1550         uint256 _firstName,
1551         uint256 _lastName
1552     ) {
1553         require(_exists(_tokenId), "Token does not exist");
1554         Attributes storage tokenAttributes = attributesMapping[_tokenId];
1555         Name storage tokenName = namesMapping[_tokenId];
1556         return (
1557         tokenAttributes.strength,
1558         tokenAttributes.speed,
1559         tokenAttributes.intelligence,
1560         tokenAttributes.skill,
1561         tokenAttributes.special,
1562         tokenName.firstName,
1563         tokenName.lastName
1564         );
1565     }
1566 
1567     function extras(uint256 _tokenId) public view returns (
1568         uint256 _badge,
1569         uint256 _sponsor,
1570         uint256 _number,
1571         uint256 _boots,
1572         uint256 _stars,
1573         uint256 _xp
1574     ) {
1575         require(_exists(_tokenId), "Token does not exist");
1576         Extras storage tokenExtras = extrasMapping[_tokenId];
1577         return (
1578         tokenExtras.badge,
1579         tokenExtras.sponsor,
1580         tokenExtras.number,
1581         tokenExtras.boots,
1582         tokenExtras.stars,
1583         tokenExtras.xp
1584         );
1585     }
1586 
1587     function attributesFlat(uint256 _tokenId) public view returns (uint256[5] memory) {
1588         require(_exists(_tokenId), "Token does not exist");
1589         Attributes storage tokenAttributes = attributesMapping[_tokenId];
1590         uint256[5] memory tokenAttributesFlat = [
1591         tokenAttributes.strength,
1592         tokenAttributes.speed,
1593         tokenAttributes.intelligence,
1594         tokenAttributes.skill,
1595         tokenAttributes.special
1596         ];
1597         return tokenAttributesFlat;
1598     }
1599 
1600     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1601         return _tokensOfOwner(owner);
1602     }
1603 
1604     function burn(uint256 _tokenId) onlyWhitelisted public returns (bool) {
1605         require(_exists(_tokenId), "Token does not exist");
1606 
1607         delete staticIpfsImageLink[_tokenId];
1608         delete cardMapping[_tokenId];
1609         delete attributesMapping[_tokenId];
1610         delete namesMapping[_tokenId];
1611         delete extrasMapping[_tokenId];
1612 
1613         _burn(ownerOf(_tokenId), _tokenId);
1614 
1615         return true;
1616     }
1617 
1618     function setSpecial(uint256 _tokenId, uint256 _newSpecial) public onlyWhitelisted returns (bool) {
1619         require(_exists(_tokenId), "Token does not exist");
1620 
1621         Attributes storage tokenAttributes = attributesMapping[_tokenId];
1622         tokenAttributes.special = _newSpecial;
1623 
1624         emit SpecialSet(_tokenId, _newSpecial);
1625 
1626         return true;
1627     }
1628 
1629     function setBadge(uint256 _tokenId, uint256 _new) public onlyWhitelisted returns (bool) {
1630         require(_exists(_tokenId), "Token does not exist");
1631 
1632         Extras storage tokenExtras = extrasMapping[_tokenId];
1633         tokenExtras.badge = _new;
1634 
1635         emit BadgeSet(_tokenId, _new);
1636 
1637         return true;
1638     }
1639 
1640     function setSponsor(uint256 _tokenId, uint256 _new) public onlyWhitelisted returns (bool) {
1641         require(_exists(_tokenId), "Token does not exist");
1642 
1643         Extras storage tokenExtras = extrasMapping[_tokenId];
1644         tokenExtras.sponsor = _new;
1645 
1646         emit SponsorSet(_tokenId, _new);
1647 
1648         return true;
1649     }
1650 
1651     function setNumber(uint256 _tokenId, uint256 _new) public onlyWhitelisted returns (bool) {
1652         require(_exists(_tokenId), "Token does not exist");
1653 
1654         Extras storage tokenExtras = extrasMapping[_tokenId];
1655         tokenExtras.number = _new;
1656 
1657         emit NumberSet(_tokenId, _new);
1658 
1659         return true;
1660     }
1661 
1662     function setBoots(uint256 _tokenId, uint256 _new) public onlyWhitelisted returns (bool) {
1663         require(_exists(_tokenId), "Token does not exist");
1664 
1665         Extras storage tokenExtras = extrasMapping[_tokenId];
1666         tokenExtras.boots = _new;
1667 
1668         emit BootsSet(_tokenId, _new);
1669 
1670         return true;
1671     }
1672 
1673     function addStar(uint256 _tokenId) public onlyWhitelisted returns (bool) {
1674         require(_exists(_tokenId), "Token does not exist");
1675 
1676         Extras storage tokenExtras = extrasMapping[_tokenId];
1677         tokenExtras.stars = tokenExtras.stars.add(1);
1678 
1679         emit StarAdded(_tokenId, tokenExtras.stars);
1680 
1681         return true;
1682     }
1683 
1684     function addXp(uint256 _tokenId, uint256 _increment) public onlyWhitelisted returns (bool) {
1685         require(_exists(_tokenId), "Token does not exist");
1686 
1687         Extras storage tokenExtras = extrasMapping[_tokenId];
1688         tokenExtras.xp = tokenExtras.xp.add(_increment);
1689 
1690         emit XpAdded(_tokenId, tokenExtras.xp);
1691 
1692         return true;
1693     }
1694 
1695     function tokenURI(uint256 tokenId) external view returns (string memory) {
1696         require(_exists(tokenId));
1697 
1698         // If we have an override then use it
1699         if (bytes(staticIpfsImageLink[tokenId]).length > 0) {
1700             return Strings.strConcat(tokenBaseIpfsURI, staticIpfsImageLink[tokenId]);
1701         }
1702         return Strings.strConcat(tokenBaseURI, Strings.uint2str(tokenId));
1703     }
1704 
1705     function updateTokenBaseURI(string memory _newBaseURI) public onlyWhitelisted returns (bool) {
1706         require(bytes(_newBaseURI).length != 0, "Base URI invalid");
1707         tokenBaseURI = _newBaseURI;
1708 
1709         emit TokenBaseURIChanged(_newBaseURI);
1710 
1711         return true;
1712     }
1713 
1714     function updateTokenBaseIpfsURI(string memory _tokenBaseIpfsURI) public onlyWhitelisted returns (bool) {
1715         require(bytes(_tokenBaseIpfsURI).length != 0, "Base IPFS URI invalid");
1716         tokenBaseIpfsURI = _tokenBaseIpfsURI;
1717 
1718         emit TokenBaseIPFSURIChanged(_tokenBaseIpfsURI);
1719 
1720         return true;
1721     }
1722 
1723     function overrideDynamicImageWithIpfsLink(uint256 _tokenId, string memory _ipfsHash)
1724     public
1725     onlyWhitelistedOrTokenOwner(_tokenId)
1726     returns (bool) {
1727         require(bytes(_ipfsHash).length != 0, "Base IPFS URI invalid");
1728 
1729         staticIpfsImageLink[_tokenId] = _ipfsHash;
1730 
1731         emit StaticIpfsTokenURISet(_tokenId, _ipfsHash);
1732 
1733         return true;
1734     }
1735 
1736     function clearIpfsImageUri(uint256 _tokenId)
1737     public
1738     onlyWhitelistedOrTokenOwner(_tokenId)
1739     returns (bool) {
1740         delete staticIpfsImageLink[_tokenId];
1741 
1742         emit StaticIpfsTokenURICleared(_tokenId);
1743 
1744         return true;
1745     }
1746 }
1747 
1748 // File: contracts/NiftyFootballTradingCard.sol
1749 
1750 pragma solidity 0.5.0;
1751 
1752 
1753 contract NiftyFootballTradingCard is NiftyTradingCard {
1754 
1755     constructor (string memory _tokenBaseURI) public CustomERC721Full("Nifty Football Trading Card", "NFTFC") {
1756         super.addWhitelisted(msg.sender);
1757         tokenBaseURI = _tokenBaseURI;
1758     }
1759 }