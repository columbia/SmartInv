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
846 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
847 
848 pragma solidity ^0.5.0;
849 
850 /**
851  * @title ERC20 interface
852  * @dev see https://github.com/ethereum/EIPs/issues/20
853  */
854 interface IERC20 {
855     function transfer(address to, uint256 value) external returns (bool);
856 
857     function approve(address spender, uint256 value) external returns (bool);
858 
859     function transferFrom(address from, address to, uint256 value) external returns (bool);
860 
861     function totalSupply() external view returns (uint256);
862 
863     function balanceOf(address who) external view returns (uint256);
864 
865     function allowance(address owner, address spender) external view returns (uint256);
866 
867     event Transfer(address indexed from, address indexed to, uint256 value);
868 
869     event Approval(address indexed owner, address indexed spender, uint256 value);
870 }
871 
872 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
873 
874 pragma solidity ^0.5.0;
875 
876 /**
877  * @title Ownable
878  * @dev The Ownable contract has an owner address, and provides basic authorization control
879  * functions, this simplifies the implementation of "user permissions".
880  */
881 contract Ownable {
882     address private _owner;
883 
884     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
885 
886     /**
887      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
888      * account.
889      */
890     constructor () internal {
891         _owner = msg.sender;
892         emit OwnershipTransferred(address(0), _owner);
893     }
894 
895     /**
896      * @return the address of the owner.
897      */
898     function owner() public view returns (address) {
899         return _owner;
900     }
901 
902     /**
903      * @dev Throws if called by any account other than the owner.
904      */
905     modifier onlyOwner() {
906         require(isOwner());
907         _;
908     }
909 
910     /**
911      * @return true if `msg.sender` is the owner of the contract.
912      */
913     function isOwner() public view returns (bool) {
914         return msg.sender == _owner;
915     }
916 
917     /**
918      * @dev Allows the current owner to relinquish control of the contract.
919      * @notice Renouncing to ownership will leave the contract without an owner.
920      * It will not be possible to call the functions with the `onlyOwner`
921      * modifier anymore.
922      */
923     function renounceOwnership() public onlyOwner {
924         emit OwnershipTransferred(_owner, address(0));
925         _owner = address(0);
926     }
927 
928     /**
929      * @dev Allows the current owner to transfer control of the contract to a newOwner.
930      * @param newOwner The address to transfer ownership to.
931      */
932     function transferOwnership(address newOwner) public onlyOwner {
933         _transferOwnership(newOwner);
934     }
935 
936     /**
937      * @dev Transfers control of the contract to a newOwner.
938      * @param newOwner The address to transfer ownership to.
939      */
940     function _transferOwnership(address newOwner) internal {
941         require(newOwner != address(0));
942         emit OwnershipTransferred(_owner, newOwner);
943         _owner = newOwner;
944     }
945 }
946 
947 // File: openzeppelin-solidity/contracts/access/Roles.sol
948 
949 pragma solidity ^0.5.0;
950 
951 /**
952  * @title Roles
953  * @dev Library for managing addresses assigned to a Role.
954  */
955 library Roles {
956     struct Role {
957         mapping (address => bool) bearer;
958     }
959 
960     /**
961      * @dev give an account access to this role
962      */
963     function add(Role storage role, address account) internal {
964         require(account != address(0));
965         require(!has(role, account));
966 
967         role.bearer[account] = true;
968     }
969 
970     /**
971      * @dev remove an account's access to this role
972      */
973     function remove(Role storage role, address account) internal {
974         require(account != address(0));
975         require(has(role, account));
976 
977         role.bearer[account] = false;
978     }
979 
980     /**
981      * @dev check if an account has this role
982      * @return bool
983      */
984     function has(Role storage role, address account) internal view returns (bool) {
985         require(account != address(0));
986         return role.bearer[account];
987     }
988 }
989 
990 // File: contracts/strings.sol
991 
992 /*
993  * @title String & slice utility library for Solidity contracts.
994  * @author Nick Johnson <arachnid@notdot.net>
995  */
996 
997 pragma solidity ^0.5.0;
998 
999 library strings {
1000     struct slice {
1001         uint _len;
1002         uint _ptr;
1003     }
1004 
1005     function memcpy(uint dest, uint src, uint len) private pure {
1006         // Copy word-length chunks while possible
1007         for (; len >= 32; len -= 32) {
1008             assembly {
1009                 mstore(dest, mload(src))
1010             }
1011             dest += 32;
1012             src += 32;
1013         }
1014 
1015         // Copy remaining bytes
1016         uint mask = 256 ** (32 - len) - 1;
1017         assembly {
1018             let srcpart := and(mload(src), not(mask))
1019             let destpart := and(mload(dest), mask)
1020             mstore(dest, or(destpart, srcpart))
1021         }
1022     }
1023 
1024     /*
1025      * @dev Returns a slice containing the entire string.
1026      * @param self The string to make a slice from.
1027      * @return A newly allocated slice containing the entire string.
1028      */
1029     function toSlice(string memory self) internal pure returns (slice memory) {
1030         uint ptr;
1031         assembly {
1032             ptr := add(self, 0x20)
1033         }
1034         return slice(bytes(self).length, ptr);
1035     }
1036 
1037     /*
1038      * @dev Returns a newly allocated string containing the concatenation of
1039      *      `self` and `other`.
1040      * @param self The first slice to concatenate.
1041      * @param other The second slice to concatenate.
1042      * @return The concatenation of the two strings.
1043      */
1044     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1045         string memory ret = new string(self._len + other._len);
1046         uint retptr;
1047         assembly {
1048             retptr := add(ret, 32)
1049         }
1050         memcpy(retptr, self._ptr, self._len);
1051         memcpy(retptr + self._len, other._ptr, other._len);
1052         return ret;
1053     }
1054 }
1055 
1056 // File: contracts/Metadata.sol
1057 
1058 pragma solidity ^0.5.0;
1059 /**
1060 * Metadata contract is upgradeable and returns metadata about Token
1061 */
1062 
1063 
1064 contract Metadata {
1065     using strings for *;
1066 
1067     function tokenURI(uint _tokenId) public pure returns (string memory _infoUrl) {
1068         string memory base = "https://folia.app/v1/metadata/";
1069         string memory id = uint2str(_tokenId);
1070         return base.toSlice().concat(id.toSlice());
1071     }
1072     function uint2str(uint i) internal pure returns (string memory) {
1073         if (i == 0) return "0";
1074         uint j = i;
1075         uint length;
1076         while (j != 0) {
1077             length++;
1078             j /= 10;
1079         }
1080         bytes memory bstr = new bytes(length);
1081         uint k = length - 1;
1082         while (i != 0) {
1083             uint _uint = 48 + i % 10;
1084             bstr[k--] = toBytes(_uint)[31];
1085             i /= 10;
1086         }
1087         return string(bstr);
1088     }
1089     function toBytes(uint256 x) public pure returns (bytes memory b) {
1090         b = new bytes(32);
1091         assembly { mstore(add(b, 32), x) }
1092     }
1093 }
1094 
1095 // File: contracts/Folia.sol
1096 
1097 pragma solidity ^0.5.0;
1098 
1099 
1100 
1101 
1102 
1103 
1104 
1105 
1106 /**
1107  * The Token contract does this and that...
1108  */
1109 contract Folia is ERC721Full, Ownable {
1110     using Roles for Roles.Role;
1111     Roles.Role private _admins;
1112     uint8 admins;
1113 
1114     address public metadata;
1115     address public controller;
1116 
1117     modifier onlyAdminOrController() {
1118         require((_admins.has(msg.sender) || msg.sender == controller), "DOES_NOT_HAVE_ADMIN_OR_CONTROLLER_ROLE");
1119         _;
1120     }
1121 
1122     constructor(string memory name, string memory symbol, address _metadata) public ERC721Full(name, symbol) {
1123         metadata = _metadata;
1124         _admins.add(msg.sender);
1125         admins += 1;
1126     }
1127 
1128     function mint(address recepient, uint256 tokenId) public onlyAdminOrController {
1129         _mint(recepient, tokenId);
1130     }
1131     function burn(uint256 tokenId) public onlyAdminOrController {
1132         _burn(ownerOf(tokenId), tokenId);
1133     }
1134     function updateMetadata(address _metadata) public onlyAdminOrController {
1135         metadata = _metadata;
1136     }
1137     function updateController(address _controller) public onlyAdminOrController {
1138         controller = _controller;
1139     }
1140 
1141     function addAdmin(address _admin) public onlyOwner {
1142         _admins.add(_admin);
1143         admins += 1;
1144     }
1145     function removeAdmin(address _admin) public onlyOwner {
1146         require(admins > 1, "CANT_REMOVE_LAST_ADMIN");
1147         _admins.remove(_admin);
1148         admins -= 1;
1149     }
1150 
1151     function tokenURI(uint _tokenId) external view returns (string memory _infoUrl) {
1152         return Metadata(metadata).tokenURI(_tokenId);
1153     }
1154 
1155     /**
1156     * @dev Moves Eth to a certain address for use in the FoliaController
1157     * @param _to The address to receive the Eth.
1158     * @param _amount The amount of Eth to be transferred.
1159     */
1160     function moveEth(address payable _to, uint256 _amount) public onlyAdminOrController {
1161         require(_amount <= address(this).balance);
1162         _to.transfer(_amount);
1163     }
1164     /**
1165     * @dev Moves Token to a certain address for use in the FoliaController
1166     * @param _to The address to receive the Token.
1167     * @param _amount The amount of Token to be transferred.
1168     * @param _token The address of the Token to be transferred.
1169     */
1170     function moveToken(address _to, uint256 _amount, address _token) public onlyAdminOrController returns (bool) {
1171         require(_amount <= IERC20(_token).balanceOf(address(this)));
1172         return IERC20(_token).transfer(_to, _amount);
1173     }
1174 
1175 }
1176 
1177 // File: contracts/DotComSeance.sol
1178 
1179 pragma solidity ^0.5.0;
1180 
1181 
1182 /*
1183  ______   _______ _________ _______  _______  _______ 
1184 (  __  \ (  ___  )\__   __/(  ____ \(  ___  )(       )
1185 | (  \  )| (   ) |   ) (   | (    \/| (   ) || () () |
1186 | |   ) || |   | |   | |   | |      | |   | || || || |
1187 | |   | || |   | |   | |   | |      | |   | || |(_)| |
1188 | |   ) || |   | |   | |   | |      | |   | || |   | |
1189 | (__/  )| (___) |   | |   | (____/\| (___) || )   ( |
1190 (______/ (_______)   )_(   (_______/(_______)|/     \|
1191                                                       
1192  _______  _______  _______  _        _______  _______ 
1193 (  ____ \(  ____ \(  ___  )( (    /|(  ____ \(  ____ \
1194 | (    \/| (    \/| (   ) ||  \  ( || (    \/| (    \/
1195 | (_____ | (__    | (___) ||   \ | || |      | (__    
1196 (_____  )|  __)   |  ___  || (\ \) || |      |  __)   
1197       ) || (      | (   ) || | \   || |      | (      
1198 /\____) || (____/\| )   ( || )  \  || (____/\| (____/\
1199 \_______)(_______/|/     \||/    )_)(_______/(_______/
1200                                                       
1201 
1202 "There are no bad ideas in tech, only bad timing"
1203 - Marc Andreessen
1204 
1205 DotCom Seance — Simon Denny, Guile Twardowski, Cosmographia (David Holz)
1206 Published in partnership wth Folia (Billy Rennenkamp, Dan Denorch, Everett Williams)
1207 */
1208 
1209 contract DotComSeance is Folia {
1210     constructor(address _metadata) public Folia("DotCom Seance", "DOTCOM", _metadata){}
1211 }
1212 
1213 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
1214 
1215 pragma solidity ^0.5.0;
1216 
1217 /**
1218  * @title Helps contracts guard against reentrancy attacks.
1219  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
1220  * @dev If you mark a function `nonReentrant`, you should also
1221  * mark it `external`.
1222  */
1223 contract ReentrancyGuard {
1224     /// @dev counter to allow mutex lock with only one SSTORE operation
1225     uint256 private _guardCounter;
1226 
1227     constructor () internal {
1228         // The counter starts at one to prevent changing it from zero to a non-zero
1229         // value, which is a more expensive operation.
1230         _guardCounter = 1;
1231     }
1232 
1233     /**
1234      * @dev Prevents a contract from calling itself, directly or indirectly.
1235      * Calling a `nonReentrant` function from another `nonReentrant`
1236      * function is not supported. It is possible to prevent this from happening
1237      * by making the `nonReentrant` function external, and make it call a
1238      * `private` function that does the actual work.
1239      */
1240     modifier nonReentrant() {
1241         _guardCounter += 1;
1242         uint256 localCounter = _guardCounter;
1243         _;
1244         require(localCounter == _guardCounter);
1245     }
1246 }
1247 
1248 // File: contracts/DotComSeanceController.sol
1249 
1250 pragma solidity ^0.5.0;
1251 /**
1252  * The FoliaControllerV2 is an upgradeable endpoint for controlling Folia.sol
1253  */
1254 
1255 
1256 
1257 
1258 
1259 contract DotComSeanceController is Ownable, ReentrancyGuard {
1260 
1261     event newWork(uint256 workId, address payable artist, uint256 editions, uint256 price, bool _paused);
1262     event updatedWork(uint256 workId, address payable artist, uint256 editions, uint256 price, bool _paused);
1263     event editionBought(uint256 workId, uint256 editionId, uint256 tokenId, address recipient, uint256 paid, uint256 artistReceived, uint256 adminReceived);
1264 
1265     using SafeMath for uint256;
1266 
1267     enum SaleType {noID, ID}
1268 
1269     uint256 constant MAX_EDITIONS = 100;
1270     uint256 public latestWorkId = 0;
1271 
1272 
1273     mapping (uint256 => Work) public _works;
1274     struct Work {
1275         bool exists;
1276         bool paused;
1277         SaleType saleType;
1278         uint256 editions;
1279         uint256 printed;
1280         uint256 price;
1281         address payable artist;
1282     }
1283 
1284     DotComSeance public dotComSeance;
1285 
1286     uint256 public adminSplit = 20;
1287     address payable public adminWallet;
1288     bool public paused;
1289 
1290     modifier notPaused() {
1291         require(!paused, "Must not be paused");
1292         _;
1293     }
1294 
1295     constructor(
1296         DotComSeance _dotComSeance,
1297         address payable _adminWallet
1298     ) public {
1299         dotComSeance = _dotComSeance;
1300         adminWallet = _adminWallet;
1301     }
1302 
1303     function addArtwork(address payable artist, uint256 editions, uint256 price, bool _paused, SaleType saleType) public onlyOwner {
1304         require(editions < MAX_EDITIONS, "MAX_EDITIONS_EXCEEDED");
1305 
1306 
1307         _works[latestWorkId] = Work({
1308           exists: true,
1309           paused: _paused,
1310           saleType: saleType,
1311           editions: editions,
1312           printed: 0,
1313           price: price,
1314           artist: artist
1315         });
1316 
1317         latestWorkId += 1;
1318 
1319         emit newWork(latestWorkId, artist, editions, price, _paused);
1320     }
1321 
1322     function updateArtworkPaused(uint256 workId, bool _paused) public onlyOwner {
1323         Work storage work = _works[workId];
1324         require(work.exists, "WORK_DOES_NOT_EXIST");
1325         work.paused = _paused;
1326         emit updatedWork(workId, work.artist, work.editions, work.price, work.paused);
1327     }
1328 
1329     function updateArtworkEditions(uint256 workId, uint256 _editions) public onlyOwner {
1330         Work storage work = _works[workId];
1331         require(work.exists, "WORK_DOES_NOT_EXIST");
1332         require(work.printed < _editions, "WORK_EXCEEDS_EDITIONS");
1333         work.editions = _editions;
1334         emit updatedWork(workId, work.artist, work.editions, work.price, work.paused);
1335     }
1336 
1337     function updateArtworkPrice(uint256 workId, uint256 _price) public onlyOwner {
1338         Work storage work = _works[workId];
1339         require(work.exists, "WORK_DOES_NOT_EXIST");
1340         work.price = _price;
1341         emit updatedWork(workId, work.artist, work.editions, work.price, work.paused);
1342     }
1343 
1344     function updateArtworkArtist(uint256 workId, address payable _artist) public onlyOwner {
1345         Work storage work = _works[workId];
1346         require(work.exists, "WORK_DOES_NOT_EXIST");
1347         work.artist = _artist;
1348         emit updatedWork(workId, work.artist, work.editions, work.price, work.paused);
1349     }
1350 
1351     function buyByID(address recipient, uint256 workId, uint256 editionId) public payable notPaused nonReentrant returns(bool) {
1352         Work storage work = _works[workId];
1353         require(!work.paused, "WORK_NOT_YET_FOR_SALE");
1354         require(work.saleType == SaleType.ID, "WRONG_SALE_TYPE");
1355         require(work.exists, "WORK_DOES_NOT_EXIST");
1356 
1357         require(work.editions >= editionId && editionId > 0, "OUTSIDE_RANGE_OF_EDITIONS");
1358         uint256 tokenId = workId.mul(MAX_EDITIONS).add(editionId);
1359 
1360         require(msg.value == work.price, "DID_NOT_SEND_PRICE");
1361 
1362         work.printed += 1;
1363         dotComSeance.mint(recipient, tokenId);
1364         
1365         uint256 adminReceives = msg.value.mul(adminSplit).div(100);
1366         uint256 artistReceives = msg.value.sub(adminReceives);
1367 
1368         (bool success, ) = adminWallet.call.value(adminReceives)("");
1369         require(success, "admin failed to receive");
1370 
1371         (success, ) = work.artist.call.value(artistReceives)("");
1372         require(success, "artist failed to receive");
1373 
1374         emit editionBought(workId, editionId, tokenId, recipient,  work.price, artistReceives, adminReceives);
1375     }
1376 
1377     function buy(address recipient, uint256 workId) public payable notPaused nonReentrant returns (bool) {
1378         Work storage work = _works[workId];
1379         require(!work.paused, "WORK_NOT_YET_FOR_SALE");
1380         require(work.saleType == SaleType.noID, "WRONG_SALE_TYPE");
1381         require(work.exists, "WORK_DOES_NOT_EXIST");
1382         require(work.editions > work.printed, "EDITIONS_EXCEEDED");
1383         require(msg.value == work.price, "DID_NOT_SEND_PRICE");
1384 
1385         uint256 editionId = work.printed.add(1);
1386         work.printed = editionId;
1387         
1388         uint256 tokenId = workId.mul(MAX_EDITIONS).add(editionId);
1389 
1390         dotComSeance.mint(recipient, tokenId);
1391         
1392         uint256 adminReceives = msg.value.mul(adminSplit).div(100);
1393         uint256 artistReceives = msg.value.sub(adminReceives);
1394 
1395         (bool success, ) = adminWallet.call.value(adminReceives)("");
1396         require(success, "admin failed to receive");
1397         
1398         (success, ) = work.artist.call.value(artistReceives)("");
1399         require(success, "artist failed to receive");
1400 
1401         emit editionBought(workId, editionId, tokenId, recipient,  work.price, artistReceives, adminReceives);
1402     }
1403 
1404     function updateAdminSplit(uint256 _adminSplit) public onlyOwner {
1405         require(_adminSplit <= 100, "SPLIT_MUST_BE_LTE_100");
1406         adminSplit = _adminSplit;
1407     }
1408 
1409     function updateAdminWallet(address payable _adminWallet) public onlyOwner {
1410         adminWallet = _adminWallet;
1411     }
1412 
1413     function updatePaused(bool _paused) public onlyOwner {
1414         paused = _paused;
1415     }
1416 
1417 }