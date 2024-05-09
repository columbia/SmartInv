1 pragma solidity ^0.5.0;
2 
3 interface IERC165 {
4     /**
5      * @notice Query if a contract implements an interface
6      * @param interfaceId The interface identifier, as specified in ERC-165
7      * @dev Interface identification is specified in ERC-165. This function
8      * uses less than 30,000 gas.
9      */
10     function supportsInterface(bytes4 interfaceId) external view returns (bool);
11 }
12 
13 contract ERC165 is IERC165 {
14     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
15     /**
16      * 0x01ffc9a7 ===
17      *     bytes4(keccak256('supportsInterface(bytes4)'))
18      */
19 
20     /**
21      * @dev a mapping of interface id to whether or not it's supported
22      */
23     mapping(bytes4 => bool) private _supportedInterfaces;
24 
25     /**
26      * @dev A contract implementing SupportsInterfaceWithLookup
27      * implement ERC165 itself
28      */
29     constructor () internal {
30         _registerInterface(_INTERFACE_ID_ERC165);
31     }
32 
33     /**
34      * @dev implement supportsInterface(bytes4) using a lookup table
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
37         return _supportedInterfaces[interfaceId];
38     }
39 
40     /**
41      * @dev internal method for registering an interface
42      */
43     function _registerInterface(bytes4 interfaceId) internal {
44         require(interfaceId != 0xffffffff);
45         _supportedInterfaces[interfaceId] = true;
46     }
47 }
48 
49 library SafeMath {
50     /**
51     * @dev Multiplies two unsigned integers, reverts on overflow.
52     */
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55         // benefit is lost if 'b' is also tested.
56         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint256 c = a * b;
62         require(c / a == b);
63 
64         return c;
65     }
66 
67     /**
68     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
69     */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Solidity only automatically asserts when dividing by 0
72         require(b > 0);
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     /**
80     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
81     */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b <= a);
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89     /**
90     * @dev Adds two unsigned integers, reverts on overflow.
91     */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a);
95 
96         return c;
97     }
98 
99     /**
100     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
101     * reverts when dividing by zero.
102     */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0);
105         return a % b;
106     }
107 }
108 
109 
110 contract IERC721 is IERC165 {
111     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
112     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
113     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
114 
115     function balanceOf(address owner) public view returns (uint256 balance);
116     function ownerOf(uint256 tokenId) public view returns (address owner);
117 
118     function approve(address to, uint256 tokenId) public;
119     function getApproved(uint256 tokenId) public view returns (address operator);
120 
121     function setApprovalForAll(address operator, bool _approved) public;
122     function isApprovedForAll(address owner, address operator) public view returns (bool);
123 
124     function transferFrom(address from, address to, uint256 tokenId) public;
125     function safeTransferFrom(address from, address to, uint256 tokenId) public;
126 
127     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
128 }
129 
130 contract ERC721 is ERC165, IERC721 {
131     using SafeMath for uint256;
132     using Address for address;
133 
134     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
135     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
136     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
137 
138     // Mapping from token ID to owner
139     mapping (uint256 => address) private _tokenOwner;
140 
141     // Mapping from token ID to approved address
142     mapping (uint256 => address) private _tokenApprovals;
143 
144     // Mapping from owner to number of owned token
145     mapping (address => uint256) private _ownedTokensCount;
146 
147     // Mapping from owner to operator approvals
148     mapping (address => mapping (address => bool)) private _operatorApprovals;
149 
150     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
151     /*
152      * 0x80ac58cd ===
153      *     bytes4(keccak256('balanceOf(address)')) ^
154      *     bytes4(keccak256('ownerOf(uint256)')) ^
155      *     bytes4(keccak256('approve(address,uint256)')) ^
156      *     bytes4(keccak256('getApproved(uint256)')) ^
157      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
158      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
159      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
160      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
161      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
162      */
163 
164     constructor () public {
165         // register the supported interfaces to conform to ERC721 via ERC165
166         _registerInterface(_INTERFACE_ID_ERC721);
167     }
168 
169     /**
170      * @dev Gets the balance of the specified address
171      * @param owner address to query the balance of
172      * @return uint256 representing the amount owned by the passed address
173      */
174     function balanceOf(address owner) public view returns (uint256) {
175         require(owner != address(0));
176         return _ownedTokensCount[owner];
177     }
178 
179     /**
180      * @dev Gets the owner of the specified token ID
181      * @param tokenId uint256 ID of the token to query the owner of
182      * @return owner address currently marked as the owner of the given token ID
183      */
184     function ownerOf(uint256 tokenId) public view returns (address) {
185         address owner = _tokenOwner[tokenId];
186         require(owner != address(0));
187         return owner;
188     }
189 
190     /**
191      * @dev Approves another address to transfer the given token ID
192      * The zero address indicates there is no approved address.
193      * There can only be one approved address per token at a given time.
194      * Can only be called by the token owner or an approved operator.
195      * @param to address to be approved for the given token ID
196      * @param tokenId uint256 ID of the token to be approved
197      */
198     function approve(address to, uint256 tokenId) public {
199         address owner = ownerOf(tokenId);
200         require(to != owner);
201         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
202 
203         _tokenApprovals[tokenId] = to;
204         emit Approval(owner, to, tokenId);
205     }
206 
207     /**
208      * @dev Gets the approved address for a token ID, or zero if no address set
209      * Reverts if the token ID does not exist.
210      * @param tokenId uint256 ID of the token to query the approval of
211      * @return address currently approved for the given token ID
212      */
213     function getApproved(uint256 tokenId) public view returns (address) {
214         require(_exists(tokenId));
215         return _tokenApprovals[tokenId];
216     }
217 
218     /**
219      * @dev Sets or unsets the approval of a given operator
220      * An operator is allowed to transfer all tokens of the sender on their behalf
221      * @param to operator address to set the approval
222      * @param approved representing the status of the approval to be set
223      */
224     function setApprovalForAll(address to, bool approved) public {
225         require(to != msg.sender);
226         _operatorApprovals[msg.sender][to] = approved;
227         emit ApprovalForAll(msg.sender, to, approved);
228     }
229 
230     /**
231      * @dev Tells whether an operator is approved by a given owner
232      * @param owner owner address which you want to query the approval of
233      * @param operator operator address which you want to query the approval of
234      * @return bool whether the given operator is approved by the given owner
235      */
236     function isApprovedForAll(address owner, address operator) public view returns (bool) {
237         return _operatorApprovals[owner][operator];
238     }
239 
240     /**
241      * @dev Transfers the ownership of a given token ID to another address
242      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
243      * Requires the msg sender to be the owner, approved, or operator
244      * @param from current owner of the token
245      * @param to address to receive the ownership of the given token ID
246      * @param tokenId uint256 ID of the token to be transferred
247     */
248     function transferFrom(address from, address to, uint256 tokenId) public {
249         require(_isApprovedOrOwner(msg.sender, tokenId));
250 
251         _transferFrom(from, to, tokenId);
252     }
253 
254     /**
255      * @dev Safely transfers the ownership of a given token ID to another address
256      * If the target address is a contract, it must implement `onERC721Received`,
257      * which is called upon a safe transfer, and return the magic value
258      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
259      * the transfer is reverted.
260      *
261      * Requires the msg sender to be the owner, approved, or operator
262      * @param from current owner of the token
263      * @param to address to receive the ownership of the given token ID
264      * @param tokenId uint256 ID of the token to be transferred
265     */
266     function safeTransferFrom(address from, address to, uint256 tokenId) public {
267         safeTransferFrom(from, to, tokenId, "");
268     }
269 
270     /**
271      * @dev Safely transfers the ownership of a given token ID to another address
272      * If the target address is a contract, it must implement `onERC721Received`,
273      * which is called upon a safe transfer, and return the magic value
274      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
275      * the transfer is reverted.
276      * Requires the msg sender to be the owner, approved, or operator
277      * @param from current owner of the token
278      * @param to address to receive the ownership of the given token ID
279      * @param tokenId uint256 ID of the token to be transferred
280      * @param _data bytes data to send along with a safe transfer check
281      */
282     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
283         transferFrom(from, to, tokenId);
284         require(_checkOnERC721Received(from, to, tokenId, _data));
285     }
286 
287     /**
288      * @dev Returns whether the specified token exists
289      * @param tokenId uint256 ID of the token to query the existence of
290      * @return whether the token exists
291      */
292     function _exists(uint256 tokenId) internal view returns (bool) {
293         address owner = _tokenOwner[tokenId];
294         return owner != address(0);
295     }
296 
297     /**
298      * @dev Returns whether the given spender can transfer a given token ID
299      * @param spender address of the spender to query
300      * @param tokenId uint256 ID of the token to be transferred
301      * @return bool whether the msg.sender is approved for the given token ID,
302      *    is an operator of the owner, or is the owner of the token
303      */
304     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
305         address owner = ownerOf(tokenId);
306         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
307     }
308 
309     /**
310      * @dev Internal function to mint a new token
311      * Reverts if the given token ID already exists
312      * @param to The address that will own the minted token
313      * @param tokenId uint256 ID of the token to be minted
314      */
315     function _mint(address to, uint256 tokenId) internal {
316         require(to != address(0));
317         require(!_exists(tokenId));
318 
319         _tokenOwner[tokenId] = to;
320         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
321 
322         emit Transfer(address(0), to, tokenId);
323     }
324 
325     /**
326      * @dev Internal function to burn a specific token
327      * Reverts if the token does not exist
328      * Deprecated, use _burn(uint256) instead.
329      * @param owner owner of the token to burn
330      * @param tokenId uint256 ID of the token being burned
331      */
332     function _burn(address owner, uint256 tokenId) internal {
333         require(ownerOf(tokenId) == owner);
334 
335         _clearApproval(tokenId);
336 
337         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
338         _tokenOwner[tokenId] = address(0);
339 
340         emit Transfer(owner, address(0), tokenId);
341     }
342 
343     /**
344      * @dev Internal function to burn a specific token
345      * Reverts if the token does not exist
346      * @param tokenId uint256 ID of the token being burned
347      */
348     function _burn(uint256 tokenId) internal {
349         _burn(ownerOf(tokenId), tokenId);
350     }
351 
352     /**
353      * @dev Internal function to transfer ownership of a given token ID to another address.
354      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
355      * @param from current owner of the token
356      * @param to address to receive the ownership of the given token ID
357      * @param tokenId uint256 ID of the token to be transferred
358     */
359     function _transferFrom(address from, address to, uint256 tokenId) internal {
360         require(ownerOf(tokenId) == from);
361         require(to != address(0));
362 
363         _clearApproval(tokenId);
364 
365         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
366         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
367 
368         _tokenOwner[tokenId] = to;
369 
370         emit Transfer(from, to, tokenId);
371     }
372 
373     /**
374      * @dev Internal function to invoke `onERC721Received` on a target address
375      * The call is not executed if the target address is not a contract
376      * @param from address representing the previous owner of the given token ID
377      * @param to target address that will receive the tokens
378      * @param tokenId uint256 ID of the token to be transferred
379      * @param _data bytes optional data to send along with the call
380      * @return whether the call correctly returned the expected magic value
381      */
382     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
383         internal returns (bool)
384     {
385         if (!to.isContract()) {
386             return true;
387         }
388 
389         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
390         return (retval == _ERC721_RECEIVED);
391     }
392 
393     /**
394      * @dev Private function to clear current approval of a given token ID
395      * @param tokenId uint256 ID of the token to be transferred
396      */
397     function _clearApproval(uint256 tokenId) private {
398         if (_tokenApprovals[tokenId] != address(0)) {
399             _tokenApprovals[tokenId] = address(0);
400         }
401     }
402 }
403 
404 contract IERC721Enumerable is IERC721 {
405     function totalSupply() public view returns (uint256);
406     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
407 
408     function tokenByIndex(uint256 index) public view returns (uint256);
409 }
410 
411 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
412     // Mapping from owner to list of owned token IDs
413     mapping(address => uint256[]) private _ownedTokens;
414 
415     // Mapping from token ID to index of the owner tokens list
416     mapping(uint256 => uint256) private _ownedTokensIndex;
417 
418     // Array with all token ids, used for enumeration
419     uint256[] private _allTokens;
420 
421     // Mapping from token id to position in the allTokens array
422     mapping(uint256 => uint256) private _allTokensIndex;
423 
424     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
425     /**
426      * 0x780e9d63 ===
427      *     bytes4(keccak256('totalSupply()')) ^
428      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
429      *     bytes4(keccak256('tokenByIndex(uint256)'))
430      */
431 
432     /**
433      * @dev Constructor function
434      */
435     constructor () public {
436         // register the supported interface to conform to ERC721 via ERC165
437         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
438     }
439 
440     /**
441      * @dev Gets the token ID at a given index of the tokens list of the requested owner
442      * @param owner address owning the tokens list to be accessed
443      * @param index uint256 representing the index to be accessed of the requested tokens list
444      * @return uint256 token ID at the given index of the tokens list owned by the requested address
445      */
446     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
447         require(index < balanceOf(owner));
448         return _ownedTokens[owner][index];
449     }
450 
451     /**
452      * @dev Gets the total amount of tokens stored by the contract
453      * @return uint256 representing the total amount of tokens
454      */
455     function totalSupply() public view returns (uint256) {
456         return _allTokens.length;
457     }
458 
459     /**
460      * @dev Gets the token ID at a given index of all the tokens in this contract
461      * Reverts if the index is greater or equal to the total number of tokens
462      * @param index uint256 representing the index to be accessed of the tokens list
463      * @return uint256 token ID at the given index of the tokens list
464      */
465     function tokenByIndex(uint256 index) public view returns (uint256) {
466         require(index < totalSupply());
467         return _allTokens[index];
468     }
469 
470     /**
471      * @dev Internal function to transfer ownership of a given token ID to another address.
472      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
473      * @param from current owner of the token
474      * @param to address to receive the ownership of the given token ID
475      * @param tokenId uint256 ID of the token to be transferred
476     */
477     function _transferFrom(address from, address to, uint256 tokenId) internal {
478         super._transferFrom(from, to, tokenId);
479 
480         _removeTokenFromOwnerEnumeration(from, tokenId);
481 
482         _addTokenToOwnerEnumeration(to, tokenId);
483     }
484 
485     /**
486      * @dev Internal function to mint a new token
487      * Reverts if the given token ID already exists
488      * @param to address the beneficiary that will own the minted token
489      * @param tokenId uint256 ID of the token to be minted
490      */
491     function _mint(address to, uint256 tokenId) internal {
492         super._mint(to, tokenId);
493 
494         _addTokenToOwnerEnumeration(to, tokenId);
495 
496         _addTokenToAllTokensEnumeration(tokenId);
497     }
498 
499     /**
500      * @dev Internal function to burn a specific token
501      * Reverts if the token does not exist
502      * Deprecated, use _burn(uint256) instead
503      * @param owner owner of the token to burn
504      * @param tokenId uint256 ID of the token being burned
505      */
506     function _burn(address owner, uint256 tokenId) internal {
507         super._burn(owner, tokenId);
508 
509         _removeTokenFromOwnerEnumeration(owner, tokenId);
510         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
511         _ownedTokensIndex[tokenId] = 0;
512 
513         _removeTokenFromAllTokensEnumeration(tokenId);
514     }
515 
516     /**
517      * @dev Gets the list of token IDs of the requested owner
518      * @param owner address owning the tokens
519      * @return uint256[] List of token IDs owned by the requested address
520      */
521     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
522         return _ownedTokens[owner];
523     }
524 
525     /**
526      * @dev Private function to add a token to this extension's ownership-tracking data structures.
527      * @param to address representing the new owner of the given token ID
528      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
529      */
530     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
531         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
532         _ownedTokens[to].push(tokenId);
533     }
534 
535     /**
536      * @dev Private function to add a token to this extension's token tracking data structures.
537      * @param tokenId uint256 ID of the token to be added to the tokens list
538      */
539     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
540         _allTokensIndex[tokenId] = _allTokens.length;
541         _allTokens.push(tokenId);
542     }
543 
544     /**
545      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
546      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
547      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
548      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
549      * @param from address representing the previous owner of the given token ID
550      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
551      */
552     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
553         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
554         // then delete the last slot (swap and pop).
555 
556         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
557         uint256 tokenIndex = _ownedTokensIndex[tokenId];
558 
559         // When the token to delete is the last token, the swap operation is unnecessary
560         if (tokenIndex != lastTokenIndex) {
561             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
562 
563             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
564             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
565         }
566 
567         // This also deletes the contents at the last position of the array
568         _ownedTokens[from].length--;
569 
570         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
571         // lasTokenId, or just over the end of the array if the token was the last one).
572     }
573 
574     /**
575      * @dev Private function to remove a token from this extension's token tracking data structures.
576      * This has O(1) time complexity, but alters the order of the _allTokens array.
577      * @param tokenId uint256 ID of the token to be removed from the tokens list
578      */
579     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
580         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
581         // then delete the last slot (swap and pop).
582 
583         uint256 lastTokenIndex = _allTokens.length.sub(1);
584         uint256 tokenIndex = _allTokensIndex[tokenId];
585 
586         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
587         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
588         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
589         uint256 lastTokenId = _allTokens[lastTokenIndex];
590 
591         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
592         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
593 
594         // This also deletes the contents at the last position of the array
595         _allTokens.length--;
596         _allTokensIndex[tokenId] = 0;
597     }
598 }
599 
600 contract IERC721Metadata is IERC721 {
601     function name() external view returns (string memory);
602     function symbol() external view returns (string memory);
603     function tokenURI(uint256 tokenId) external view returns (string memory);
604 }
605 
606 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
607     // Token name
608     string private _name;
609 
610     // Token symbol
611     string private _symbol;
612 
613     // Optional mapping for token URIs
614     mapping(uint256 => string) private _tokenURIs;
615 
616     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
617     /**
618      * 0x5b5e139f ===
619      *     bytes4(keccak256('name()')) ^
620      *     bytes4(keccak256('symbol()')) ^
621      *     bytes4(keccak256('tokenURI(uint256)'))
622      */
623 
624     /**
625      * @dev Constructor function
626      */
627     constructor (string memory name, string memory symbol) public {
628         _name = name;
629         _symbol = symbol;
630 
631         // register the supported interfaces to conform to ERC721 via ERC165
632         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
633     }
634 
635     /**
636      * @dev Gets the token name
637      * @return string representing the token name
638      */
639     function name() external view returns (string memory) {
640         return _name;
641     }
642 
643     /**
644      * @dev Gets the token symbol
645      * @return string representing the token symbol
646      */
647     function symbol() external view returns (string memory) {
648         return _symbol;
649     }
650 
651     /**
652      * @dev Returns an URI for a given token ID
653      * Throws if the token ID does not exist. May return an empty string.
654      * @param tokenId uint256 ID of the token to query
655      */
656     function tokenURI(uint256 tokenId) external view returns (string memory) {
657         require(_exists(tokenId));
658         return _tokenURIs[tokenId];
659     }
660 
661     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
662         require(_exists(tokenId));
663         return _tokenURIs[tokenId];
664     }
665 
666     /**
667      * @dev Internal function to set the token URI for a given token
668      * Reverts if the token ID does not exist
669      * @param tokenId uint256 ID of the token to set its URI
670      * @param uri string URI to assign
671      */
672     function _setTokenURI(uint256 tokenId, string memory uri) internal {
673         require(_exists(tokenId));
674         _tokenURIs[tokenId] = uri;
675     }
676 
677     /**
678      * @dev Internal function to burn a specific token
679      * Reverts if the token does not exist
680      * Deprecated, use _burn(uint256) instead
681      * @param owner owner of the token to burn
682      * @param tokenId uint256 ID of the token being burned by the msg.sender
683      */
684     function _burn(address owner, uint256 tokenId) internal {
685         super._burn(owner, tokenId);
686 
687         // Clear metadata (if any)
688         if (bytes(_tokenURIs[tokenId]).length != 0) {
689             delete _tokenURIs[tokenId];
690         }
691     }
692 }
693 
694 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
695     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
696         // solhint-disable-previous-line no-empty-blocks
697     }
698 }
699 
700 contract IERC721Receiver {
701     /**
702      * @notice Handle the receipt of an NFT
703      * @dev The ERC721 smart contract calls this function on the recipient
704      * after a `safeTransfer`. This function MUST return the function selector,
705      * otherwise the caller will revert the transaction. The selector to be
706      * returned can be obtained as `this.onERC721Received.selector`. This
707      * function MAY throw to revert and reject the transfer.
708      * Note: the ERC721 contract address is always the message sender.
709      * @param operator The address which called `safeTransferFrom` function
710      * @param from The address which previously owned the token
711      * @param tokenId The NFT identifier which is being transferred
712      * @param data Additional data with no specified format
713      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
714      */
715     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
716     public returns (bytes4);
717 }
718 
719 library Address {
720     /**
721      * Returns whether the target address is a contract
722      * @dev This function will return false if invoked during the constructor of a contract,
723      * as the code is not actually created until after the constructor finishes.
724      * @param account address of the account to check
725      * @return whether the target address is a contract
726      */
727     function isContract(address account) internal view returns (bool) {
728         uint256 size;
729         // XXX Currently there is no better way to check if there is a contract in an address
730         // than to check the size of the code at that address.
731         // See https://ethereum.stackexchange.com/a/14016/36603
732         // for more details about how this works.
733         // TODO Check this again before the Serenity release, because all addresses will be
734         // contracts then.
735         // solhint-disable-next-line no-inline-assembly
736         assembly { size := extcodesize(account) }
737         return size > 0;
738     }
739 }
740 
741 
742 /**************************************************************************
743 VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch
744 ***************************************************************************/
745 /**************************************************************************
746 VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch
747 ***************************************************************************/
748 /**************************************************************************
749 VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch
750 ***************************************************************************/
751 /**************************************************************************
752 VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch
753 ***************************************************************************/
754 /**************************************************************************
755 VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch VonAesch
756 ***************************************************************************/
757 
758 
759 contract VonAeschERC721 is ERC721Full {
760 
761     uint256 public liveTokenId;
762 
763 
764     mapping(bytes32 => uint256) private PatternToken;
765     mapping(uint256 => bytes32) private TokenPattern;
766     mapping(uint256 => string) private _tokenMSGs;
767 
768     string public info = "Von Aesch Offcial Token https://von-aesch.com";
769 
770     string public baseTokenURI = "https://von-aesch.com/tokenURI.php?colors=";
771     string public basefallbackTokenURI = "https://cloudflare-ipfs.com/ipfs/Qmes4xg8qpfrpBnfCgcm1i9235gSszMS7pDTStWRAFNmYv#colors=";
772 
773     address private constant emergency_admin = 0x59ab67D9BA5a748591bB79Ce223606A8C2892E6d;
774     address private constant first_admin = 0x9a203e2E251849a26566EBF94043D74FEeb0011c;
775     address private admin = 0x9a203e2E251849a26566EBF94043D74FEeb0011c;
776 
777 
778     constructor()
779         ERC721Full("VonAeschPattern", "VA")
780         public
781     {}
782 
783     /**************************************************************************
784     * modifiers
785     ***************************************************************************/
786 
787     modifier onlyAdmin {
788         require(msg.sender == admin);
789         _;
790     }
791 
792     modifier onlyEAdmin {
793         require(msg.sender == emergency_admin);
794         _;
795     }
796 
797 
798     /* function currentId (bytes32 patternid) public view
799     returns(bool)
800     {
801       if(Pattern[patternid].owner == address(0)){
802         return false;
803       }else{
804         return true;
805       }
806     } */
807 
808     /**************************************************************************
809     * Overrides
810     ***************************************************************************/
811 
812     function strConcat(string memory a, string memory b) internal pure returns (string memory) {
813         return string(abi.encodePacked(a, b));
814     }
815 
816     function tokenURI(uint256 tokenId) external view returns (string memory) {
817         require(_exists(tokenId));
818         return strConcat(
819             baseTokenURI,
820             _tokenURI(tokenId)
821         );
822     }
823 
824     function fallbackTokenURI(uint256 tokenId) external view returns (string memory) {
825         require(_exists(tokenId));
826         return strConcat(
827             basefallbackTokenURI,
828             _tokenURI(tokenId)
829         );
830     }
831 
832     /* function tokenURI22(uint256 tokenId) external view returns (string memory) {
833         require(_exists(tokenId));
834         return strConcat(
835             baseTokenURI,
836             _tokenURI(tokenId)
837         );
838     } */
839 
840     function tokenMessage(uint256 tokenId) external view returns (string memory) {
841         require(_exists(tokenId));
842         return _tokenMSGs[tokenId];
843     }
844 
845 
846     /**************************************************************************
847     * functionS
848     ***************************************************************************/
849 
850 
851     function patternIdToTokenId(bytes32 patternid) public view returns(uint256){
852       return PatternToken[patternid];
853     }
854 
855     function tokenIdToPatternId(uint256 tokenId) public view returns(bytes32){
856       return TokenPattern[tokenId];
857     }
858 
859 
860     function _setTokenMSG(uint256 tokenId, string memory _msg) internal {
861         require(_exists(tokenId));
862         _tokenMSGs[tokenId] = _msg;
863     }
864 
865     function setMessage(uint256 tokenId, string memory _msg) public {
866       address owner = ownerOf(tokenId);
867       require(msg.sender == owner);
868       _setTokenMSG(tokenId,_msg);
869     }
870 
871 
872     function checkPatternExistance (bytes32 patternid) public view
873     returns(bool)
874     {
875     //get tokenid from PATTERNID
876     uint256 t_tokenId = PatternToken[patternid];
877       return _exists(t_tokenId);
878     }
879 
880     function exists(uint256 tokenId) public view returns(bool){
881       return _exists(tokenId);
882     }
883 
884     function nextTokenId() internal returns(uint256) {
885       liveTokenId = liveTokenId + 1;
886       return liveTokenId;
887     }
888 
889     function createPattern(bytes32 patternid, string memory dataMixed, address newowner, string memory message)
890         onlyAdmin
891         public
892         returns(string memory)
893     {
894 
895       //CONVERT DATA to UPPERCASE
896       string memory data = toUpper(dataMixed);
897 
898       //hash the color data
899       bytes32 colordatahash = keccak256(abi.encodePacked(data));
900 
901       //check if _exists. continue if it doesnt.
902       require(PatternToken[colordatahash] == 0);
903 
904       //generate new tokenId
905       uint256 newTokenId = nextTokenId();
906 
907       //assign token id to pattern mapping
908       PatternToken[colordatahash] = newTokenId;
909       //and vice versa
910       TokenPattern[newTokenId] = colordatahash;
911 
912       //mint new token
913       _mint(newowner, newTokenId);
914       _setTokenURI(newTokenId, data);
915       _setTokenMSG(newTokenId, message);
916 
917       return "ok";
918 
919 
920     }
921     function transferPattern(bytes32 patternid,address newowner,string memory message, uint8 v, bytes32 r, bytes32 s)
922       public
923       returns(string memory)
924     {
925         //anyone can transfer a token BUT needs to supply a new address signed by the old owner
926 
927         //get tokenid from PATTERNID
928         uint256 t_tokenId = PatternToken[patternid];
929 
930         //get old owner
931         address t_oldowner = ownerOf(t_tokenId);
932         require(t_oldowner != address(0));
933 
934         //generate the hash for the new address
935         bytes32 h = prefixedHash2(newowner);
936 
937         //check if eveything adds up.
938         require(ecrecover(h, v, r, s) == t_oldowner);
939 
940         _transferFrom(t_oldowner, newowner, t_tokenId);
941         _setTokenMSG(t_tokenId, message);
942 
943         return "ok";
944 
945     }
946 
947     function changeMessage(bytes32 patternid,string memory message, uint8 v, bytes32 r, bytes32 s)
948       public
949       returns(string memory)
950     {
951       //anyone can change the message of a token BUT needs to supply a new message signed by the owner
952 
953       //get tokenid from PATTERNID
954       uint256 t_tokenId = PatternToken[patternid];
955 
956       //get owner
957       address t_owner = ownerOf(t_tokenId);
958       require(t_owner != address(0));
959 
960       //generate the hash for the new message
961       bytes32 h = prefixedHash(message);
962 
963       //check if eveything adds up.
964       require(ecrecover(h, v, r, s) == t_owner);
965 
966       _setTokenMSG(t_tokenId, message);
967 
968       return "ok";
969 
970     }
971 
972     function verifyOwner(bytes32 patternid, address owner, uint8 v, bytes32 r, bytes32 s)
973       public
974       view
975       returns(bool)
976     {
977       //get tokenid from PATTERNID
978       uint256 t_tokenId = PatternToken[patternid];
979 
980       //get owner
981       address t_owner = ownerOf(t_tokenId);
982       require(t_owner != address(0));
983 
984       //generate the hash for the new message
985       bytes32 h = prefixedHash2(owner);
986 
987       //check if eveything adds up.
988       address owner2 = ecrecover(h, v, r, s);
989 
990       //check if owner actually owns item in question
991       if(t_owner == owner2 && owner == owner2){
992         return true;
993       }else{
994         return false;
995       }
996     }
997 
998     function prefixedHash(string memory message)
999       private
1000       pure
1001       returns (bytes32)
1002     {
1003         bytes32 h = keccak256(abi.encodePacked(message));
1004         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", h));
1005     }
1006 
1007     function prefixedHash2(address message)
1008       private
1009       pure
1010       returns (bytes32)
1011     {
1012         bytes32 h = keccak256(abi.encodePacked(message));
1013         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", h));
1014     }
1015 
1016 
1017     /* okokokokokoikokokokokokok */
1018 
1019     function userHasPattern(address account)
1020       public
1021       view
1022       returns(bool)
1023     {
1024       if(balanceOf(account) >=1 )
1025       {
1026         return true;
1027       }else{
1028         return false;
1029       }
1030     }
1031 
1032     function emergency(address newa)
1033       public
1034       onlyEAdmin
1035     {
1036       require(newa != address(0));
1037       admin = newa;
1038     }
1039 
1040     function changeInfo(string memory newstring)
1041       public
1042       onlyAdmin
1043     {
1044       info = newstring;
1045     }
1046 
1047     function changeBaseTokenURI(string memory newstring)
1048       public
1049       onlyAdmin
1050     {
1051       baseTokenURI = newstring;
1052     }
1053 
1054     function changeFallbackTokenURI(string memory newstring)
1055       public
1056       onlyAdmin
1057     {
1058       basefallbackTokenURI = newstring;
1059     }
1060 
1061 
1062     function toUpper(string memory str)
1063       pure
1064       private
1065       returns (string memory)
1066     {
1067       bytes memory bStr = bytes(str);
1068       bytes memory bLower = new bytes(bStr.length);
1069       for (uint i = 0; i < bStr.length; i++) {
1070         // lowercase character...
1071         if ((uint8(bStr[i]) >= 65+32) && (uint8(bStr[i]) <= 90+32)) {
1072           // So we remove 32 to make it uppercase
1073           bLower[i] = bytes1(uint8(bStr[i]) - 32);
1074         } else {
1075           bLower[i] = bStr[i];
1076         }
1077       }
1078       return string(bLower);
1079     }
1080 
1081 
1082 
1083 
1084 
1085 }