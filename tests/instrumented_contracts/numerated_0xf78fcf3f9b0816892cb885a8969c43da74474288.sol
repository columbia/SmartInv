1 pragma solidity ^0.5.0;
2 
3 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/introspection/IERC165.sol
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
19 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
20 
21 /**
22  * @title ERC721 Non-Fungible Token Standard basic interface
23  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
24  */
25 contract IERC721 is IERC165 {
26     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
27     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
28     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
29 
30     function balanceOf(address owner) public view returns (uint256 balance);
31     function ownerOf(uint256 tokenId) public view returns (address owner);
32 
33     function approve(address to, uint256 tokenId) public;
34     function getApproved(uint256 tokenId) public view returns (address operator);
35 
36     function setApprovalForAll(address operator, bool _approved) public;
37     function isApprovedForAll(address owner, address operator) public view returns (bool);
38 
39     function transferFrom(address from, address to, uint256 tokenId) public;
40     function safeTransferFrom(address from, address to, uint256 tokenId) public;
41 
42     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
43 }
44 
45 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
46 
47 /**
48  * @title ERC721 token receiver interface
49  * @dev Interface for any contract that wants to support safeTransfers
50  * from ERC721 asset contracts.
51  */
52 contract IERC721Receiver {
53     /**
54      * @notice Handle the receipt of an NFT
55      * @dev The ERC721 smart contract calls this function on the recipient
56      * after a `safeTransfer`. This function MUST return the function selector,
57      * otherwise the caller will revert the transaction. The selector to be
58      * returned can be obtained as `this.onERC721Received.selector`. This
59      * function MAY throw to revert and reject the transfer.
60      * Note: the ERC721 contract address is always the message sender.
61      * @param operator The address which called `safeTransferFrom` function
62      * @param from The address which previously owned the token
63      * @param tokenId The NFT identifier which is being transferred
64      * @param data Additional data with no specified format
65      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
66      */
67     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
68     public returns (bytes4);
69 }
70 
71 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
72 
73 /**
74  * @title SafeMath
75  * @dev Unsigned math operations with safety checks that revert on error
76  */
77 library SafeMath {
78     /**
79     * @dev Multiplies two unsigned integers, reverts on overflow.
80     */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b);
91 
92         return c;
93     }
94 
95     /**
96     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
97     */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Solidity only automatically asserts when dividing by 0
100         require(b > 0);
101         uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104         return c;
105     }
106 
107     /**
108     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
109     */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b <= a);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118     * @dev Adds two unsigned integers, reverts on overflow.
119     */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a);
123 
124         return c;
125     }
126 
127     /**
128     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
129     * reverts when dividing by zero.
130     */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b != 0);
133         return a % b;
134     }
135 }
136 
137 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/utils/Address.sol
138 
139 /**
140  * Utility library of inline functions on addresses
141  */
142 library Address {
143     /**
144      * Returns whether the target address is a contract
145      * @dev This function will return false if invoked during the constructor of a contract,
146      * as the code is not actually created until after the constructor finishes.
147      * @param account address of the account to check
148      * @return whether the target address is a contract
149      */
150     function isContract(address account) internal view returns (bool) {
151         uint256 size;
152         // XXX Currently there is no better way to check if there is a contract in an address
153         // than to check the size of the code at that address.
154         // See https://ethereum.stackexchange.com/a/14016/36603
155         // for more details about how this works.
156         // TODO Check this again before the Serenity release, because all addresses will be
157         // contracts then.
158         // solhint-disable-next-line no-inline-assembly
159         assembly { size := extcodesize(account) }
160         return size > 0;
161     }
162 }
163 
164 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/introspection/ERC165.sol
165 
166 /**
167  * @title ERC165
168  * @author Matt Condon (@shrugs)
169  * @dev Implements ERC165 using a lookup table.
170  */
171 contract ERC165 is IERC165 {
172     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
173     /**
174      * 0x01ffc9a7 ===
175      *     bytes4(keccak256('supportsInterface(bytes4)'))
176      */
177 
178     /**
179      * @dev a mapping of interface id to whether or not it's supported
180      */
181     mapping(bytes4 => bool) private _supportedInterfaces;
182 
183     /**
184      * @dev A contract implementing SupportsInterfaceWithLookup
185      * implement ERC165 itself
186      */
187     constructor () internal {
188         _registerInterface(_INTERFACE_ID_ERC165);
189     }
190 
191     /**
192      * @dev implement supportsInterface(bytes4) using a lookup table
193      */
194     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
195         return _supportedInterfaces[interfaceId];
196     }
197 
198     /**
199      * @dev internal method for registering an interface
200      */
201     function _registerInterface(bytes4 interfaceId) internal {
202         require(interfaceId != 0xffffffff);
203         _supportedInterfaces[interfaceId] = true;
204     }
205 }
206 
207 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
208 
209 /**
210  * @title ERC721 Non-Fungible Token Standard basic implementation
211  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
212  */
213 contract ERC721 is ERC165, IERC721 {
214     using SafeMath for uint256;
215     using Address for address;
216 
217     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
218     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
219     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
220 
221     // Mapping from token ID to owner
222     mapping (uint256 => address) private _tokenOwner;
223 
224     // Mapping from token ID to approved address
225     mapping (uint256 => address) private _tokenApprovals;
226 
227     // Mapping from owner to number of owned token
228     mapping (address => uint256) private _ownedTokensCount;
229 
230     // Mapping from owner to operator approvals
231     mapping (address => mapping (address => bool)) private _operatorApprovals;
232 
233     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
234     /*
235      * 0x80ac58cd ===
236      *     bytes4(keccak256('balanceOf(address)')) ^
237      *     bytes4(keccak256('ownerOf(uint256)')) ^
238      *     bytes4(keccak256('approve(address,uint256)')) ^
239      *     bytes4(keccak256('getApproved(uint256)')) ^
240      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
241      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
242      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
243      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
244      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
245      */
246 
247     constructor () public {
248         // register the supported interfaces to conform to ERC721 via ERC165
249         _registerInterface(_INTERFACE_ID_ERC721);
250     }
251 
252     /**
253      * @dev Gets the balance of the specified address
254      * @param owner address to query the balance of
255      * @return uint256 representing the amount owned by the passed address
256      */
257     function balanceOf(address owner) public view returns (uint256) {
258         require(owner != address(0));
259         return _ownedTokensCount[owner];
260     }
261 
262     /**
263      * @dev Gets the owner of the specified token ID
264      * @param tokenId uint256 ID of the token to query the owner of
265      * @return owner address currently marked as the owner of the given token ID
266      */
267     function ownerOf(uint256 tokenId) public view returns (address) {
268         address owner = _tokenOwner[tokenId];
269         require(owner != address(0));
270         return owner;
271     }
272 
273     /**
274      * @dev Approves another address to transfer the given token ID
275      * The zero address indicates there is no approved address.
276      * There can only be one approved address per token at a given time.
277      * Can only be called by the token owner or an approved operator.
278      * @param to address to be approved for the given token ID
279      * @param tokenId uint256 ID of the token to be approved
280      */
281     function approve(address to, uint256 tokenId) public {
282         address owner = ownerOf(tokenId);
283         require(to != owner);
284         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
285 
286         _tokenApprovals[tokenId] = to;
287         emit Approval(owner, to, tokenId);
288     }
289 
290     /**
291      * @dev Gets the approved address for a token ID, or zero if no address set
292      * Reverts if the token ID does not exist.
293      * @param tokenId uint256 ID of the token to query the approval of
294      * @return address currently approved for the given token ID
295      */
296     function getApproved(uint256 tokenId) public view returns (address) {
297         require(_exists(tokenId));
298         return _tokenApprovals[tokenId];
299     }
300 
301     /**
302      * @dev Sets or unsets the approval of a given operator
303      * An operator is allowed to transfer all tokens of the sender on their behalf
304      * @param to operator address to set the approval
305      * @param approved representing the status of the approval to be set
306      */
307     function setApprovalForAll(address to, bool approved) public {
308         require(to != msg.sender);
309         _operatorApprovals[msg.sender][to] = approved;
310         emit ApprovalForAll(msg.sender, to, approved);
311     }
312 
313     /**
314      * @dev Tells whether an operator is approved by a given owner
315      * @param owner owner address which you want to query the approval of
316      * @param operator operator address which you want to query the approval of
317      * @return bool whether the given operator is approved by the given owner
318      */
319     function isApprovedForAll(address owner, address operator) public view returns (bool) {
320         return _operatorApprovals[owner][operator];
321     }
322 
323     /**
324      * @dev Transfers the ownership of a given token ID to another address
325      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
326      * Requires the msg sender to be the owner, approved, or operator
327      * @param from current owner of the token
328      * @param to address to receive the ownership of the given token ID
329      * @param tokenId uint256 ID of the token to be transferred
330     */
331     function transferFrom(address from, address to, uint256 tokenId) public {
332         require(_isApprovedOrOwner(msg.sender, tokenId));
333 
334         _transferFrom(from, to, tokenId);
335     }
336 
337     /**
338      * @dev Safely transfers the ownership of a given token ID to another address
339      * If the target address is a contract, it must implement `onERC721Received`,
340      * which is called upon a safe transfer, and return the magic value
341      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
342      * the transfer is reverted.
343      *
344      * Requires the msg sender to be the owner, approved, or operator
345      * @param from current owner of the token
346      * @param to address to receive the ownership of the given token ID
347      * @param tokenId uint256 ID of the token to be transferred
348     */
349     function safeTransferFrom(address from, address to, uint256 tokenId) public {
350         safeTransferFrom(from, to, tokenId, "");
351     }
352 
353     /**
354      * @dev Safely transfers the ownership of a given token ID to another address
355      * If the target address is a contract, it must implement `onERC721Received`,
356      * which is called upon a safe transfer, and return the magic value
357      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
358      * the transfer is reverted.
359      * Requires the msg sender to be the owner, approved, or operator
360      * @param from current owner of the token
361      * @param to address to receive the ownership of the given token ID
362      * @param tokenId uint256 ID of the token to be transferred
363      * @param _data bytes data to send along with a safe transfer check
364      */
365     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
366         transferFrom(from, to, tokenId);
367         require(_checkOnERC721Received(from, to, tokenId, _data));
368     }
369 
370     /**
371      * @dev Returns whether the specified token exists
372      * @param tokenId uint256 ID of the token to query the existence of
373      * @return whether the token exists
374      */
375     function _exists(uint256 tokenId) internal view returns (bool) {
376         address owner = _tokenOwner[tokenId];
377         return owner != address(0);
378     }
379 
380     /**
381      * @dev Returns whether the given spender can transfer a given token ID
382      * @param spender address of the spender to query
383      * @param tokenId uint256 ID of the token to be transferred
384      * @return bool whether the msg.sender is approved for the given token ID,
385      *    is an operator of the owner, or is the owner of the token
386      */
387     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
388         address owner = ownerOf(tokenId);
389         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
390     }
391 
392     /**
393      * @dev Internal function to mint a new token
394      * Reverts if the given token ID already exists
395      * @param to The address that will own the minted token
396      * @param tokenId uint256 ID of the token to be minted
397      */
398     function _mint(address to, uint256 tokenId) internal {
399         require(to != address(0));
400         require(!_exists(tokenId));
401 
402         _tokenOwner[tokenId] = to;
403         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
404 
405         emit Transfer(address(0), to, tokenId);
406     }
407 
408     /**
409      * @dev Internal function to burn a specific token
410      * Reverts if the token does not exist
411      * Deprecated, use _burn(uint256) instead.
412      * @param owner owner of the token to burn
413      * @param tokenId uint256 ID of the token being burned
414      */
415     function _burn(address owner, uint256 tokenId) internal {
416         require(ownerOf(tokenId) == owner);
417 
418         _clearApproval(tokenId);
419 
420         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
421         _tokenOwner[tokenId] = address(0);
422 
423         emit Transfer(owner, address(0), tokenId);
424     }
425 
426     /**
427      * @dev Internal function to burn a specific token
428      * Reverts if the token does not exist
429      * @param tokenId uint256 ID of the token being burned
430      */
431     function _burn(uint256 tokenId) internal {
432         _burn(ownerOf(tokenId), tokenId);
433     }
434 
435     /**
436      * @dev Internal function to transfer ownership of a given token ID to another address.
437      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
438      * @param from current owner of the token
439      * @param to address to receive the ownership of the given token ID
440      * @param tokenId uint256 ID of the token to be transferred
441     */
442     function _transferFrom(address from, address to, uint256 tokenId) internal {
443         require(ownerOf(tokenId) == from);
444         require(to != address(0));
445 
446         _clearApproval(tokenId);
447 
448         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
449         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
450 
451         _tokenOwner[tokenId] = to;
452 
453         emit Transfer(from, to, tokenId);
454     }
455 
456     /**
457      * @dev Internal function to invoke `onERC721Received` on a target address
458      * The call is not executed if the target address is not a contract
459      * @param from address representing the previous owner of the given token ID
460      * @param to target address that will receive the tokens
461      * @param tokenId uint256 ID of the token to be transferred
462      * @param _data bytes optional data to send along with the call
463      * @return whether the call correctly returned the expected magic value
464      */
465     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
466         internal returns (bool)
467     {
468         if (!to.isContract()) {
469             return true;
470         }
471 
472         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
473         return (retval == _ERC721_RECEIVED);
474     }
475 
476     /**
477      * @dev Private function to clear current approval of a given token ID
478      * @param tokenId uint256 ID of the token to be transferred
479      */
480     function _clearApproval(uint256 tokenId) private {
481         if (_tokenApprovals[tokenId] != address(0)) {
482             _tokenApprovals[tokenId] = address(0);
483         }
484     }
485 }
486 
487 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
488 
489 /**
490  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
491  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
492  */
493 contract IERC721Enumerable is IERC721 {
494     function totalSupply() public view returns (uint256);
495     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
496 
497     function tokenByIndex(uint256 index) public view returns (uint256);
498 }
499 
500 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
501 
502 /**
503  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
504  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
505  */
506 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
507     // Mapping from owner to list of owned token IDs
508     mapping(address => uint256[]) private _ownedTokens;
509 
510     // Mapping from token ID to index of the owner tokens list
511     mapping(uint256 => uint256) private _ownedTokensIndex;
512 
513     // Array with all token ids, used for enumeration
514     uint256[] private _allTokens;
515 
516     // Mapping from token id to position in the allTokens array
517     mapping(uint256 => uint256) private _allTokensIndex;
518 
519     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
520     /**
521      * 0x780e9d63 ===
522      *     bytes4(keccak256('totalSupply()')) ^
523      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
524      *     bytes4(keccak256('tokenByIndex(uint256)'))
525      */
526 
527     /**
528      * @dev Constructor function
529      */
530     constructor () public {
531         // register the supported interface to conform to ERC721 via ERC165
532         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
533     }
534 
535     /**
536      * @dev Gets the token ID at a given index of the tokens list of the requested owner
537      * @param owner address owning the tokens list to be accessed
538      * @param index uint256 representing the index to be accessed of the requested tokens list
539      * @return uint256 token ID at the given index of the tokens list owned by the requested address
540      */
541     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
542         require(index < balanceOf(owner));
543         return _ownedTokens[owner][index];
544     }
545 
546     /**
547      * @dev Gets the total amount of tokens stored by the contract
548      * @return uint256 representing the total amount of tokens
549      */
550     function totalSupply() public view returns (uint256) {
551         return _allTokens.length;
552     }
553 
554     /**
555      * @dev Gets the token ID at a given index of all the tokens in this contract
556      * Reverts if the index is greater or equal to the total number of tokens
557      * @param index uint256 representing the index to be accessed of the tokens list
558      * @return uint256 token ID at the given index of the tokens list
559      */
560     function tokenByIndex(uint256 index) public view returns (uint256) {
561         require(index < totalSupply());
562         return _allTokens[index];
563     }
564 
565     /**
566      * @dev Internal function to transfer ownership of a given token ID to another address.
567      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
568      * @param from current owner of the token
569      * @param to address to receive the ownership of the given token ID
570      * @param tokenId uint256 ID of the token to be transferred
571     */
572     function _transferFrom(address from, address to, uint256 tokenId) internal {
573         super._transferFrom(from, to, tokenId);
574 
575         _removeTokenFromOwnerEnumeration(from, tokenId);
576 
577         _addTokenToOwnerEnumeration(to, tokenId);
578     }
579 
580     /**
581      * @dev Internal function to mint a new token
582      * Reverts if the given token ID already exists
583      * @param to address the beneficiary that will own the minted token
584      * @param tokenId uint256 ID of the token to be minted
585      */
586     function _mint(address to, uint256 tokenId) internal {
587         super._mint(to, tokenId);
588 
589         _addTokenToOwnerEnumeration(to, tokenId);
590 
591         _addTokenToAllTokensEnumeration(tokenId);
592     }
593 
594     /**
595      * @dev Internal function to burn a specific token
596      * Reverts if the token does not exist
597      * Deprecated, use _burn(uint256) instead
598      * @param owner owner of the token to burn
599      * @param tokenId uint256 ID of the token being burned
600      */
601     function _burn(address owner, uint256 tokenId) internal {
602         super._burn(owner, tokenId);
603 
604         _removeTokenFromOwnerEnumeration(owner, tokenId);
605         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
606         _ownedTokensIndex[tokenId] = 0;
607 
608         _removeTokenFromAllTokensEnumeration(tokenId);
609     }
610 
611     /**
612      * @dev Gets the list of token IDs of the requested owner
613      * @param owner address owning the tokens
614      * @return uint256[] List of token IDs owned by the requested address
615      */
616     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
617         return _ownedTokens[owner];
618     }
619 
620     /**
621      * @dev Private function to add a token to this extension's ownership-tracking data structures.
622      * @param to address representing the new owner of the given token ID
623      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
624      */
625     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
626         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
627         _ownedTokens[to].push(tokenId);
628     }
629 
630     /**
631      * @dev Private function to add a token to this extension's token tracking data structures.
632      * @param tokenId uint256 ID of the token to be added to the tokens list
633      */
634     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
635         _allTokensIndex[tokenId] = _allTokens.length;
636         _allTokens.push(tokenId);
637     }
638 
639     /**
640      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
641      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
642      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
643      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
644      * @param from address representing the previous owner of the given token ID
645      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
646      */
647     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
648         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
649         // then delete the last slot (swap and pop).
650 
651         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
652         uint256 tokenIndex = _ownedTokensIndex[tokenId];
653 
654         // When the token to delete is the last token, the swap operation is unnecessary
655         if (tokenIndex != lastTokenIndex) {
656             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
657 
658             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
659             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
660         }
661 
662         // This also deletes the contents at the last position of the array
663         _ownedTokens[from].length--;
664 
665         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
666         // lasTokenId, or just over the end of the array if the token was the last one).
667     }
668 
669     /**
670      * @dev Private function to remove a token from this extension's token tracking data structures.
671      * This has O(1) time complexity, but alters the order of the _allTokens array.
672      * @param tokenId uint256 ID of the token to be removed from the tokens list
673      */
674     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
675         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
676         // then delete the last slot (swap and pop).
677 
678         uint256 lastTokenIndex = _allTokens.length.sub(1);
679         uint256 tokenIndex = _allTokensIndex[tokenId];
680 
681         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
682         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
683         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
684         uint256 lastTokenId = _allTokens[lastTokenIndex];
685 
686         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
687         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
688 
689         // This also deletes the contents at the last position of the array
690         _allTokens.length--;
691         _allTokensIndex[tokenId] = 0;
692     }
693 }
694 
695 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
696 
697 /**
698  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
699  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
700  */
701 contract IERC721Metadata is IERC721 {
702     function name() external view returns (string memory);
703     function symbol() external view returns (string memory);
704     function tokenURI(uint256 tokenId) external view returns (string memory);
705 }
706 
707 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
708 
709 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
710     // Token name
711     string private _name;
712 
713     // Token symbol
714     string private _symbol;
715 
716     // Optional mapping for token URIs
717     mapping(uint256 => string) private _tokenURIs;
718 
719     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
720     /**
721      * 0x5b5e139f ===
722      *     bytes4(keccak256('name()')) ^
723      *     bytes4(keccak256('symbol()')) ^
724      *     bytes4(keccak256('tokenURI(uint256)'))
725      */
726 
727     /**
728      * @dev Constructor function
729      */
730     constructor (string memory name, string memory symbol) public {
731         _name = name;
732         _symbol = symbol;
733 
734         // register the supported interfaces to conform to ERC721 via ERC165
735         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
736     }
737 
738     /**
739      * @dev Gets the token name
740      * @return string representing the token name
741      */
742     function name() external view returns (string memory) {
743         return _name;
744     }
745 
746     /**
747      * @dev Gets the token symbol
748      * @return string representing the token symbol
749      */
750     function symbol() external view returns (string memory) {
751         return _symbol;
752     }
753 
754     /**
755      * @dev Returns an URI for a given token ID
756      * Throws if the token ID does not exist. May return an empty string.
757      * @param tokenId uint256 ID of the token to query
758      */
759     function tokenURI(uint256 tokenId) external view returns (string memory) {
760         require(_exists(tokenId));
761         return _tokenURIs[tokenId];
762     }
763 
764     /**
765      * @dev Internal function to set the token URI for a given token
766      * Reverts if the token ID does not exist
767      * @param tokenId uint256 ID of the token to set its URI
768      * @param uri string URI to assign
769      */
770     function _setTokenURI(uint256 tokenId, string memory uri) internal {
771         require(_exists(tokenId));
772         _tokenURIs[tokenId] = uri;
773     }
774 
775     /**
776      * @dev Internal function to burn a specific token
777      * Reverts if the token does not exist
778      * Deprecated, use _burn(uint256) instead
779      * @param owner owner of the token to burn
780      * @param tokenId uint256 ID of the token being burned by the msg.sender
781      */
782     function _burn(address owner, uint256 tokenId) internal {
783         super._burn(owner, tokenId);
784 
785         // Clear metadata (if any)
786         if (bytes(_tokenURIs[tokenId]).length != 0) {
787             delete _tokenURIs[tokenId];
788         }
789     }
790 }
791 
792 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
793 
794 /**
795  * @title Full ERC721 Token
796  * This implementation includes all the required and some optional functionality of the ERC721 standard
797  * Moreover, it includes approve all functionality using operator terminology
798  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
799  */
800 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
801     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
802         // solhint-disable-previous-line no-empty-blocks
803     }
804 }
805 
806 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/access/Roles.sol
807 
808 /**
809  * @title Roles
810  * @dev Library for managing addresses assigned to a Role.
811  */
812 library Roles {
813     struct Role {
814         mapping (address => bool) bearer;
815     }
816 
817     /**
818      * @dev give an account access to this role
819      */
820     function add(Role storage role, address account) internal {
821         require(account != address(0));
822         require(!has(role, account));
823 
824         role.bearer[account] = true;
825     }
826 
827     /**
828      * @dev remove an account's access to this role
829      */
830     function remove(Role storage role, address account) internal {
831         require(account != address(0));
832         require(has(role, account));
833 
834         role.bearer[account] = false;
835     }
836 
837     /**
838      * @dev check if an account has this role
839      * @return bool
840      */
841     function has(Role storage role, address account) internal view returns (bool) {
842         require(account != address(0));
843         return role.bearer[account];
844     }
845 }
846 
847 // File: /Users/sugimura/reward/node_modules/openzeppelin-solidity/contracts/access/roles/MinterRole.sol
848 
849 contract MinterRole {
850     using Roles for Roles.Role;
851 
852     event MinterAdded(address indexed account);
853     event MinterRemoved(address indexed account);
854 
855     Roles.Role private _minters;
856 
857     constructor () internal {
858         _addMinter(msg.sender);
859     }
860 
861     modifier onlyMinter() {
862         require(isMinter(msg.sender));
863         _;
864     }
865 
866     function isMinter(address account) public view returns (bool) {
867         return _minters.has(account);
868     }
869 
870     function addMinter(address account) public onlyMinter {
871         _addMinter(account);
872     }
873 
874     function renounceMinter() public {
875         _removeMinter(msg.sender);
876     }
877 
878     function _addMinter(address account) internal {
879         _minters.add(account);
880         emit MinterAdded(account);
881     }
882 
883     function _removeMinter(address account) internal {
884         _minters.remove(account);
885         emit MinterRemoved(account);
886     }
887 }
888 
889 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721MetadataMintable.sol
890 
891 /**
892  * @title ERC721MetadataMintable
893  * @dev ERC721 minting logic with metadata
894  */
895 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
896     /**
897      * @dev Function to mint tokens
898      * @param to The address that will receive the minted tokens.
899      * @param tokenId The token id to mint.
900      * @param tokenURI The token URI of the minted token.
901      * @return A boolean that indicates if the operation was successful.
902      */
903     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter returns (bool) {
904         _mint(to, tokenId);
905         _setTokenURI(tokenId, tokenURI);
906         return true;
907     }
908 }
909 
910 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
911 
912 /**
913  * @title Ownable
914  * @dev The Ownable contract has an owner address, and provides basic authorization control
915  * functions, this simplifies the implementation of "user permissions".
916  */
917 contract Ownable {
918     address private _owner;
919 
920     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
921 
922     /**
923      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
924      * account.
925      */
926     constructor () internal {
927         _owner = msg.sender;
928         emit OwnershipTransferred(address(0), _owner);
929     }
930 
931     /**
932      * @return the address of the owner.
933      */
934     function owner() public view returns (address) {
935         return _owner;
936     }
937 
938     /**
939      * @dev Throws if called by any account other than the owner.
940      */
941     modifier onlyOwner() {
942         require(isOwner());
943         _;
944     }
945 
946     /**
947      * @return true if `msg.sender` is the owner of the contract.
948      */
949     function isOwner() public view returns (bool) {
950         return msg.sender == _owner;
951     }
952 
953     /**
954      * @dev Allows the current owner to relinquish control of the contract.
955      * @notice Renouncing to ownership will leave the contract without an owner.
956      * It will not be possible to call the functions with the `onlyOwner`
957      * modifier anymore.
958      */
959     function renounceOwnership() public onlyOwner {
960         emit OwnershipTransferred(_owner, address(0));
961         _owner = address(0);
962     }
963 
964     /**
965      * @dev Allows the current owner to transfer control of the contract to a newOwner.
966      * @param newOwner The address to transfer ownership to.
967      */
968     function transferOwnership(address newOwner) public onlyOwner {
969         _transferOwnership(newOwner);
970     }
971 
972     /**
973      * @dev Transfers control of the contract to a newOwner.
974      * @param newOwner The address to transfer ownership to.
975      */
976     function _transferOwnership(address newOwner) internal {
977         require(newOwner != address(0));
978         emit OwnershipTransferred(_owner, newOwner);
979         _owner = newOwner;
980     }
981 }
982 
983 // File: /Users/sugimura/reward/contracts/Solidity-Utility/contracts/StrConnect.sol
984 
985 contract StrConnect {
986 
987   function twoStrConnect(string memory _str1, string memory _str2) internal view returns(string memory){
988     string memory str1 = _str1;
989     string memory str2 = _str2;
990     bytes memory strbyte1 = bytes(str1);
991     bytes memory strbyte2 = bytes(str2);
992 
993     bytes memory str = new bytes(strbyte1.length + strbyte2.length);
994 
995     uint8 point = 0;
996     for(uint8 j = 0; j < strbyte1.length;j++){
997       str[point] = strbyte1[j];
998       point++;
999     }
1000     for(uint8 k = 0; k < strbyte2.length;k++){
1001       str[point] = strbyte2[k];
1002       point++;
1003     }
1004     return string(str);
1005   }
1006 
1007   function threeStrConnect(string memory _str1, string memory _str2, string memory _str3) internal view returns(string memory) {
1008     string memory str1 = _str1;
1009     string memory str2 = _str2;
1010     string memory str3 = _str3;
1011     bytes memory strbyte1 = bytes(str1);
1012     bytes memory strbyte2 = bytes(str2);
1013     bytes memory strbyte3 = bytes(str3);
1014 
1015     bytes memory str = new bytes(strbyte1.length + strbyte2.length + strbyte3.length);
1016 
1017     uint8 point = 0;
1018     for(uint8 j = 0; j < strbyte1.length;j++){
1019       str[point] = strbyte1[j];
1020       point++;
1021     }
1022     for(uint8 k = 0; k < strbyte2.length;k++){
1023       str[point] = strbyte2[k];
1024       point++;
1025     }
1026     for(uint8 k = 0; k < strbyte3.length;k++){
1027       str[point] = strbyte3[k];
1028       point++;
1029     }
1030     return string(str);
1031   }
1032 
1033 }
1034 
1035 // File: /Users/sugimura/reward/contracts/Solidity-Utility/contracts/TypeConversion.sol
1036 
1037 contract TypeConversion {
1038 
1039   function uintToBytes(uint v)view internal returns(bytes32 ret) {
1040     if (v == 0) {
1041       ret = '0';
1042     }
1043     else {
1044       while (v > 0) {
1045         ret = bytes32(uint(ret) / (2 ** 8));
1046         ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
1047         v /= 10;
1048       }
1049     }
1050     return ret;
1051   }
1052 
1053   function bytesToString(bytes memory _bytes) view internal returns(string memory) {
1054     bytes memory str = new bytes(_bytes.length);
1055 
1056     uint8 point = 0;
1057     for(uint8 j = 0; j < _bytes.length;j++){
1058       str[point] = _bytes[j];
1059       point++;
1060     }
1061     return string(str);
1062   }
1063 
1064   function uintToStrings(uint _uint) view internal returns(string memory) {
1065     bytes memory strBytes = abi.encodePacked(uintToBytes(_uint));
1066     return bytesToString(strBytes);
1067   }
1068 }
1069 
1070 // File: /Users/sugimura/reward/contracts/tokenURI.sol
1071 
1072 contract TokenURI is Ownable, StrConnect, TypeConversion {
1073   string private url;  //https://blockchain-nagoya.com/event/_id
1074 
1075 
1076 
1077   function setURL(string memory _url) public onlyOwner {
1078     url = _url;
1079   }
1080 
1081   function getURL() public view returns(string memory) {
1082     return url;
1083   }
1084 
1085   function connect(uint256 _id) internal view returns(string memory) {
1086     string memory id = uintToStrings(_id);
1087 
1088     string memory uri = twoStrConnect(url, id);
1089     return uri;
1090   }
1091 }
1092 
1093 // File: contracts/reward.sol
1094 
1095 contract reward is ERC721Full, ERC721MetadataMintable, Ownable, TokenURI {
1096   uint256 private identification;
1097   uint256 private count;
1098   uint256 private round;
1099   uint256 private limit;
1100 
1101   bool private paused;
1102 
1103   constructor(
1104     string memory _name, string memory _symbol,
1105     uint256 _round, uint256 _limit, string memory _url
1106   ) public ERC721Full(_name, _symbol) {
1107     identification = 1000000;
1108     round = _round;
1109     limit = _limit;
1110     pause();
1111     setURL(_url);
1112   }
1113 
1114   function getId() internal view returns(uint256) {
1115     return count;
1116   }
1117 
1118   function setEvent(uint256 _limit) public onlyOwner {
1119     require(_limit > 0);
1120 
1121     count = 0;
1122     round++;
1123     limit = _limit;
1124   }
1125 
1126   function addLimit(uint256 _add) public onlyOwner {
1127     require(limit + _add < 100);
1128     limit += _add;
1129   }
1130 
1131   function mint(address _to) public onlyOwner {
1132     require(count <= limit);
1133     uint256 _count = getId();
1134     count++;
1135 
1136     uint256 _id = identification + round * 1000 + _count;
1137 
1138     string memory _tokenURI = connect(_id);
1139 
1140     _mint(_to, _id);
1141     _setTokenURI(_id, _tokenURI);
1142   }
1143 
1144   function selfMint() public {
1145     require(
1146       count <= limit &&
1147       paused == false
1148     );
1149     uint256 _count = getId();
1150     count++;
1151 
1152     uint256 _id = identification + round * 1000 + _count;
1153 
1154     string memory _tokenURI = connect(_id);
1155 
1156     _mint(msg.sender, _id);
1157     _setTokenURI(_id, _tokenURI);
1158   }
1159 
1160 
1161   function pause() public onlyOwner {
1162     paused = true;
1163   }
1164   function unpause() public onlyOwner {
1165     paused = false;
1166   }
1167   function _paused() public view returns(bool) {
1168     return paused;
1169   }
1170 }