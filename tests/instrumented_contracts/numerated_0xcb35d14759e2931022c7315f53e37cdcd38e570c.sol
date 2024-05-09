1 pragma solidity 0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 /**
75  * @title IERC165
76  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
77  */
78 interface IERC165 {
79     /**
80      * @notice Query if a contract implements an interface
81      * @param interfaceId The interface identifier, as specified in ERC-165
82      * @dev Interface identification is specified in ERC-165. This function
83      * uses less than 30,000 gas.
84      */
85     function supportsInterface(bytes4 interfaceId) external view returns (bool);
86 }
87 
88 /**
89  * @title ERC721 Non-Fungible Token Standard basic interface
90  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
91  */
92 contract IERC721 is IERC165 {
93     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
94     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
95     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
96 
97     function balanceOf(address owner) public view returns (uint256 balance);
98     function ownerOf(uint256 tokenId) public view returns (address owner);
99 
100     function approve(address to, uint256 tokenId) public;
101     function getApproved(uint256 tokenId) public view returns (address operator);
102 
103     function setApprovalForAll(address operator, bool _approved) public;
104     function isApprovedForAll(address owner, address operator) public view returns (bool);
105 
106     function transferFrom(address from, address to, uint256 tokenId) public;
107     function safeTransferFrom(address from, address to, uint256 tokenId) public;
108 
109     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
110 }
111 
112 /**
113  * @title ERC721 token receiver interface
114  * @dev Interface for any contract that wants to support safeTransfers
115  * from ERC721 asset contracts.
116  */
117 contract IERC721Receiver {
118     /**
119      * @notice Handle the receipt of an NFT
120      * @dev The ERC721 smart contract calls this function on the recipient
121      * after a `safeTransfer`. This function MUST return the function selector,
122      * otherwise the caller will revert the transaction. The selector to be
123      * returned can be obtained as `this.onERC721Received.selector`. This
124      * function MAY throw to revert and reject the transfer.
125      * Note: the ERC721 contract address is always the message sender.
126      * @param operator The address which called `safeTransferFrom` function
127      * @param from The address which previously owned the token
128      * @param tokenId The NFT identifier which is being transferred
129      * @param data Additional data with no specified format
130      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
131      */
132     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
133     public returns (bytes4);
134 }
135 
136 /**
137  * @title SafeMath
138  * @dev Unsigned math operations with safety checks that revert on error
139  */
140 library SafeMath {
141     /**
142     * @dev Multiplies two unsigned integers, reverts on overflow.
143     */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b);
154 
155         return c;
156     }
157 
158     /**
159     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
160     */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Solidity only automatically asserts when dividing by 0
163         require(b > 0);
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167         return c;
168     }
169 
170     /**
171     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
172     */
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         require(b <= a);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181     * @dev Adds two unsigned integers, reverts on overflow.
182     */
183     function add(uint256 a, uint256 b) internal pure returns (uint256) {
184         uint256 c = a + b;
185         require(c >= a);
186 
187         return c;
188     }
189 
190     /**
191     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
192     * reverts when dividing by zero.
193     */
194     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195         require(b != 0);
196         return a % b;
197     }
198 }
199 
200 /**
201  * Utility library of inline functions on addresses
202  */
203 library Address {
204     /**
205      * Returns whether the target address is a contract
206      * @dev This function will return false if invoked during the constructor of a contract,
207      * as the code is not actually created until after the constructor finishes.
208      * @param account address of the account to check
209      * @return whether the target address is a contract
210      */
211     function isContract(address account) internal view returns (bool) {
212         uint256 size;
213         // XXX Currently there is no better way to check if there is a contract in an address
214         // than to check the size of the code at that address.
215         // See https://ethereum.stackexchange.com/a/14016/36603
216         // for more details about how this works.
217         // TODO Check this again before the Serenity release, because all addresses will be
218         // contracts then.
219         // solhint-disable-next-line no-inline-assembly
220         assembly { size := extcodesize(account) }
221         return size > 0;
222     }
223 }
224 
225 /**
226  * @title ERC165
227  * @author Matt Condon (@shrugs)
228  * @dev Implements ERC165 using a lookup table.
229  */
230 contract ERC165 is IERC165 {
231     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
232     /**
233      * 0x01ffc9a7 ===
234      *     bytes4(keccak256('supportsInterface(bytes4)'))
235      */
236 
237     /**
238      * @dev a mapping of interface id to whether or not it's supported
239      */
240     mapping(bytes4 => bool) private _supportedInterfaces;
241 
242     /**
243      * @dev A contract implementing SupportsInterfaceWithLookup
244      * implement ERC165 itself
245      */
246     constructor () internal {
247         _registerInterface(_INTERFACE_ID_ERC165);
248     }
249 
250     /**
251      * @dev implement supportsInterface(bytes4) using a lookup table
252      */
253     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
254         return _supportedInterfaces[interfaceId];
255     }
256 
257     /**
258      * @dev internal method for registering an interface
259      */
260     function _registerInterface(bytes4 interfaceId) internal {
261         require(interfaceId != 0xffffffff);
262         _supportedInterfaces[interfaceId] = true;
263     }
264 }
265 
266 /**
267  * @title ERC721 Non-Fungible Token Standard basic implementation
268  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
269  */
270 contract ERC721 is ERC165, IERC721 {
271     using SafeMath for uint256;
272     using Address for address;
273 
274     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
275     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
276     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
277 
278     // Mapping from token ID to owner
279     mapping (uint256 => address) private _tokenOwner;
280 
281     // Mapping from token ID to approved address
282     mapping (uint256 => address) private _tokenApprovals;
283 
284     // Mapping from owner to number of owned token
285     mapping (address => uint256) private _ownedTokensCount;
286 
287     // Mapping from owner to operator approvals
288     mapping (address => mapping (address => bool)) private _operatorApprovals;
289 
290     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
291     /*
292      * 0x80ac58cd ===
293      *     bytes4(keccak256('balanceOf(address)')) ^
294      *     bytes4(keccak256('ownerOf(uint256)')) ^
295      *     bytes4(keccak256('approve(address,uint256)')) ^
296      *     bytes4(keccak256('getApproved(uint256)')) ^
297      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
298      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
299      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
300      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
301      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
302      */
303 
304     constructor () public {
305         // register the supported interfaces to conform to ERC721 via ERC165
306         _registerInterface(_INTERFACE_ID_ERC721);
307     }
308 
309     /**
310      * @dev Gets the balance of the specified address
311      * @param owner address to query the balance of
312      * @return uint256 representing the amount owned by the passed address
313      */
314     function balanceOf(address owner) public view returns (uint256) {
315         require(owner != address(0));
316         return _ownedTokensCount[owner];
317     }
318 
319     /**
320      * @dev Gets the owner of the specified token ID
321      * @param tokenId uint256 ID of the token to query the owner of
322      * @return owner address currently marked as the owner of the given token ID
323      */
324     function ownerOf(uint256 tokenId) public view returns (address) {
325         address owner = _tokenOwner[tokenId];
326         require(owner != address(0));
327         return owner;
328     }
329 
330     /**
331      * @dev Approves another address to transfer the given token ID
332      * The zero address indicates there is no approved address.
333      * There can only be one approved address per token at a given time.
334      * Can only be called by the token owner or an approved operator.
335      * @param to address to be approved for the given token ID
336      * @param tokenId uint256 ID of the token to be approved
337      */
338     function approve(address to, uint256 tokenId) public {
339         address owner = ownerOf(tokenId);
340         require(to != owner);
341         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
342 
343         _tokenApprovals[tokenId] = to;
344         emit Approval(owner, to, tokenId);
345     }
346 
347     /**
348      * @dev Gets the approved address for a token ID, or zero if no address set
349      * Reverts if the token ID does not exist.
350      * @param tokenId uint256 ID of the token to query the approval of
351      * @return address currently approved for the given token ID
352      */
353     function getApproved(uint256 tokenId) public view returns (address) {
354         require(_exists(tokenId));
355         return _tokenApprovals[tokenId];
356     }
357 
358     /**
359      * @dev Sets or unsets the approval of a given operator
360      * An operator is allowed to transfer all tokens of the sender on their behalf
361      * @param to operator address to set the approval
362      * @param approved representing the status of the approval to be set
363      */
364     function setApprovalForAll(address to, bool approved) public {
365         require(to != msg.sender);
366         _operatorApprovals[msg.sender][to] = approved;
367         emit ApprovalForAll(msg.sender, to, approved);
368     }
369 
370     /**
371      * @dev Tells whether an operator is approved by a given owner
372      * @param owner owner address which you want to query the approval of
373      * @param operator operator address which you want to query the approval of
374      * @return bool whether the given operator is approved by the given owner
375      */
376     function isApprovedForAll(address owner, address operator) public view returns (bool) {
377         return _operatorApprovals[owner][operator];
378     }
379 
380     /**
381      * @dev Transfers the ownership of a given token ID to another address
382      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
383      * Requires the msg sender to be the owner, approved, or operator
384      * @param from current owner of the token
385      * @param to address to receive the ownership of the given token ID
386      * @param tokenId uint256 ID of the token to be transferred
387     */
388     function transferFrom(address from, address to, uint256 tokenId) public {
389         require(_isApprovedOrOwner(msg.sender, tokenId));
390 
391         _transferFrom(from, to, tokenId);
392     }
393 
394     /**
395      * @dev Safely transfers the ownership of a given token ID to another address
396      * If the target address is a contract, it must implement `onERC721Received`,
397      * which is called upon a safe transfer, and return the magic value
398      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
399      * the transfer is reverted.
400      *
401      * Requires the msg sender to be the owner, approved, or operator
402      * @param from current owner of the token
403      * @param to address to receive the ownership of the given token ID
404      * @param tokenId uint256 ID of the token to be transferred
405     */
406     function safeTransferFrom(address from, address to, uint256 tokenId) public {
407         safeTransferFrom(from, to, tokenId, "");
408     }
409 
410     /**
411      * @dev Safely transfers the ownership of a given token ID to another address
412      * If the target address is a contract, it must implement `onERC721Received`,
413      * which is called upon a safe transfer, and return the magic value
414      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
415      * the transfer is reverted.
416      * Requires the msg sender to be the owner, approved, or operator
417      * @param from current owner of the token
418      * @param to address to receive the ownership of the given token ID
419      * @param tokenId uint256 ID of the token to be transferred
420      * @param _data bytes data to send along with a safe transfer check
421      */
422     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
423         transferFrom(from, to, tokenId);
424         require(_checkOnERC721Received(from, to, tokenId, _data));
425     }
426 
427     /**
428      * @dev Returns whether the specified token exists
429      * @param tokenId uint256 ID of the token to query the existence of
430      * @return whether the token exists
431      */
432     function _exists(uint256 tokenId) internal view returns (bool) {
433         address owner = _tokenOwner[tokenId];
434         return owner != address(0);
435     }
436 
437     /**
438      * @dev Returns whether the given spender can transfer a given token ID
439      * @param spender address of the spender to query
440      * @param tokenId uint256 ID of the token to be transferred
441      * @return bool whether the msg.sender is approved for the given token ID,
442      *    is an operator of the owner, or is the owner of the token
443      */
444     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
445         address owner = ownerOf(tokenId);
446         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
447     }
448 
449     /**
450      * @dev Internal function to mint a new token
451      * Reverts if the given token ID already exists
452      * @param to The address that will own the minted token
453      * @param tokenId uint256 ID of the token to be minted
454      */
455     function _mint(address to, uint256 tokenId) internal {
456         require(to != address(0));
457         require(!_exists(tokenId));
458 
459         _tokenOwner[tokenId] = to;
460         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
461 
462         emit Transfer(address(0), to, tokenId);
463     }
464 
465     /**
466      * @dev Internal function to burn a specific token
467      * Reverts if the token does not exist
468      * Deprecated, use _burn(uint256) instead.
469      * @param owner owner of the token to burn
470      * @param tokenId uint256 ID of the token being burned
471      */
472     function _burn(address owner, uint256 tokenId) internal {
473         require(ownerOf(tokenId) == owner);
474 
475         _clearApproval(tokenId);
476 
477         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
478         _tokenOwner[tokenId] = address(0);
479 
480         emit Transfer(owner, address(0), tokenId);
481     }
482 
483     /**
484      * @dev Internal function to burn a specific token
485      * Reverts if the token does not exist
486      * @param tokenId uint256 ID of the token being burned
487      */
488     function _burn(uint256 tokenId) internal {
489         _burn(ownerOf(tokenId), tokenId);
490     }
491 
492     /**
493      * @dev Internal function to transfer ownership of a given token ID to another address.
494      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
495      * @param from current owner of the token
496      * @param to address to receive the ownership of the given token ID
497      * @param tokenId uint256 ID of the token to be transferred
498     */
499     function _transferFrom(address from, address to, uint256 tokenId) internal {
500         require(ownerOf(tokenId) == from);
501         require(to != address(0));
502 
503         _clearApproval(tokenId);
504 
505         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
506         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
507 
508         _tokenOwner[tokenId] = to;
509 
510         emit Transfer(from, to, tokenId);
511     }
512 
513     /**
514      * @dev Internal function to invoke `onERC721Received` on a target address
515      * The call is not executed if the target address is not a contract
516      * @param from address representing the previous owner of the given token ID
517      * @param to target address that will receive the tokens
518      * @param tokenId uint256 ID of the token to be transferred
519      * @param _data bytes optional data to send along with the call
520      * @return whether the call correctly returned the expected magic value
521      */
522     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
523         internal returns (bool)
524     {
525         if (!to.isContract()) {
526             return true;
527         }
528 
529         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
530         return (retval == _ERC721_RECEIVED);
531     }
532 
533     /**
534      * @dev Private function to clear current approval of a given token ID
535      * @param tokenId uint256 ID of the token to be transferred
536      */
537     function _clearApproval(uint256 tokenId) private {
538         if (_tokenApprovals[tokenId] != address(0)) {
539             _tokenApprovals[tokenId] = address(0);
540         }
541     }
542 }
543 
544 /**
545  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
546  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
547  */
548 contract IERC721Enumerable is IERC721 {
549     function totalSupply() public view returns (uint256);
550     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
551 
552     function tokenByIndex(uint256 index) public view returns (uint256);
553 }
554 
555 /**
556  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
557  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
558  */
559 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
560     // Mapping from owner to list of owned token IDs
561     mapping(address => uint256[]) private _ownedTokens;
562 
563     // Mapping from token ID to index of the owner tokens list
564     mapping(uint256 => uint256) private _ownedTokensIndex;
565 
566     // Array with all token ids, used for enumeration
567     uint256[] private _allTokens;
568 
569     // Mapping from token id to position in the allTokens array
570     mapping(uint256 => uint256) private _allTokensIndex;
571 
572     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
573     /**
574      * 0x780e9d63 ===
575      *     bytes4(keccak256('totalSupply()')) ^
576      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
577      *     bytes4(keccak256('tokenByIndex(uint256)'))
578      */
579 
580     /**
581      * @dev Constructor function
582      */
583     constructor () public {
584         // register the supported interface to conform to ERC721 via ERC165
585         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
586     }
587 
588     /**
589      * @dev Gets the token ID at a given index of the tokens list of the requested owner
590      * @param owner address owning the tokens list to be accessed
591      * @param index uint256 representing the index to be accessed of the requested tokens list
592      * @return uint256 token ID at the given index of the tokens list owned by the requested address
593      */
594     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
595         require(index < balanceOf(owner));
596         return _ownedTokens[owner][index];
597     }
598 
599     /**
600      * @dev Gets the total amount of tokens stored by the contract
601      * @return uint256 representing the total amount of tokens
602      */
603     function totalSupply() public view returns (uint256) {
604         return _allTokens.length;
605     }
606 
607     /**
608      * @dev Gets the token ID at a given index of all the tokens in this contract
609      * Reverts if the index is greater or equal to the total number of tokens
610      * @param index uint256 representing the index to be accessed of the tokens list
611      * @return uint256 token ID at the given index of the tokens list
612      */
613     function tokenByIndex(uint256 index) public view returns (uint256) {
614         require(index < totalSupply());
615         return _allTokens[index];
616     }
617 
618     /**
619      * @dev Internal function to transfer ownership of a given token ID to another address.
620      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
621      * @param from current owner of the token
622      * @param to address to receive the ownership of the given token ID
623      * @param tokenId uint256 ID of the token to be transferred
624     */
625     function _transferFrom(address from, address to, uint256 tokenId) internal {
626         super._transferFrom(from, to, tokenId);
627 
628         _removeTokenFromOwnerEnumeration(from, tokenId);
629 
630         _addTokenToOwnerEnumeration(to, tokenId);
631     }
632 
633     /**
634      * @dev Internal function to mint a new token
635      * Reverts if the given token ID already exists
636      * @param to address the beneficiary that will own the minted token
637      * @param tokenId uint256 ID of the token to be minted
638      */
639     function _mint(address to, uint256 tokenId) internal {
640         super._mint(to, tokenId);
641 
642         _addTokenToOwnerEnumeration(to, tokenId);
643 
644         _addTokenToAllTokensEnumeration(tokenId);
645     }
646 
647     /**
648      * @dev Internal function to burn a specific token
649      * Reverts if the token does not exist
650      * Deprecated, use _burn(uint256) instead
651      * @param owner owner of the token to burn
652      * @param tokenId uint256 ID of the token being burned
653      */
654     function _burn(address owner, uint256 tokenId) internal {
655         super._burn(owner, tokenId);
656 
657         _removeTokenFromOwnerEnumeration(owner, tokenId);
658         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
659         _ownedTokensIndex[tokenId] = 0;
660 
661         _removeTokenFromAllTokensEnumeration(tokenId);
662     }
663 
664     /**
665      * @dev Gets the list of token IDs of the requested owner
666      * @param owner address owning the tokens
667      * @return uint256[] List of token IDs owned by the requested address
668      */
669     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
670         return _ownedTokens[owner];
671     }
672 
673     /**
674      * @dev Private function to add a token to this extension's ownership-tracking data structures.
675      * @param to address representing the new owner of the given token ID
676      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
677      */
678     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
679         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
680         _ownedTokens[to].push(tokenId);
681     }
682 
683     /**
684      * @dev Private function to add a token to this extension's token tracking data structures.
685      * @param tokenId uint256 ID of the token to be added to the tokens list
686      */
687     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
688         _allTokensIndex[tokenId] = _allTokens.length;
689         _allTokens.push(tokenId);
690     }
691 
692     /**
693      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
694      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
695      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
696      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
697      * @param from address representing the previous owner of the given token ID
698      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
699      */
700     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
701         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
702         // then delete the last slot (swap and pop).
703 
704         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
705         uint256 tokenIndex = _ownedTokensIndex[tokenId];
706 
707         // When the token to delete is the last token, the swap operation is unnecessary
708         if (tokenIndex != lastTokenIndex) {
709             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
710 
711             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
712             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
713         }
714 
715         // This also deletes the contents at the last position of the array
716         _ownedTokens[from].length--;
717 
718         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
719         // lasTokenId, or just over the end of the array if the token was the last one).
720     }
721 
722     /**
723      * @dev Private function to remove a token from this extension's token tracking data structures.
724      * This has O(1) time complexity, but alters the order of the _allTokens array.
725      * @param tokenId uint256 ID of the token to be removed from the tokens list
726      */
727     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
728         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
729         // then delete the last slot (swap and pop).
730 
731         uint256 lastTokenIndex = _allTokens.length.sub(1);
732         uint256 tokenIndex = _allTokensIndex[tokenId];
733 
734         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
735         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
736         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
737         uint256 lastTokenId = _allTokens[lastTokenIndex];
738 
739         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
740         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
741 
742         // This also deletes the contents at the last position of the array
743         _allTokens.length--;
744         _allTokensIndex[tokenId] = 0;
745     }
746 }
747 
748 /**
749  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
750  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
751  */
752 contract IERC721Metadata is IERC721 {
753     function name() external view returns (string memory);
754     function symbol() external view returns (string memory);
755     function tokenURI(uint256 tokenId) external view returns (string memory);
756 }
757 
758 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
759     // Token name
760     string private _name;
761 
762     // Token symbol
763     string private _symbol;
764 
765     // Optional mapping for token URIs
766     mapping(uint256 => string) private _tokenURIs;
767 
768     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
769     /**
770      * 0x5b5e139f ===
771      *     bytes4(keccak256('name()')) ^
772      *     bytes4(keccak256('symbol()')) ^
773      *     bytes4(keccak256('tokenURI(uint256)'))
774      */
775 
776     /**
777      * @dev Constructor function
778      */
779     constructor (string memory name, string memory symbol) public {
780         _name = name;
781         _symbol = symbol;
782 
783         // register the supported interfaces to conform to ERC721 via ERC165
784         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
785     }
786 
787     /**
788      * @dev Gets the token name
789      * @return string representing the token name
790      */
791     function name() external view returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev Gets the token symbol
797      * @return string representing the token symbol
798      */
799     function symbol() external view returns (string memory) {
800         return _symbol;
801     }
802 
803     /**
804      * @dev Returns an URI for a given token ID
805      * Throws if the token ID does not exist. May return an empty string.
806      * @param tokenId uint256 ID of the token to query
807      */
808     function tokenURI(uint256 tokenId) external view returns (string memory) {
809         require(_exists(tokenId));
810         return _tokenURIs[tokenId];
811     }
812 
813     /**
814      * @dev Internal function to set the token URI for a given token
815      * Reverts if the token ID does not exist
816      * @param tokenId uint256 ID of the token to set its URI
817      * @param uri string URI to assign
818      */
819     function _setTokenURI(uint256 tokenId, string memory uri) internal {
820         require(_exists(tokenId));
821         _tokenURIs[tokenId] = uri;
822     }
823 
824     /**
825      * @dev Internal function to burn a specific token
826      * Reverts if the token does not exist
827      * Deprecated, use _burn(uint256) instead
828      * @param owner owner of the token to burn
829      * @param tokenId uint256 ID of the token being burned by the msg.sender
830      */
831     function _burn(address owner, uint256 tokenId) internal {
832         super._burn(owner, tokenId);
833 
834         // Clear metadata (if any)
835         if (bytes(_tokenURIs[tokenId]).length != 0) {
836             delete _tokenURIs[tokenId];
837         }
838     }
839 }
840 
841 /**
842  * @title Full ERC721 Token
843  * This implementation includes all the required and some optional functionality of the ERC721 standard
844  * Moreover, it includes approve all functionality using operator terminology
845  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
846  */
847 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
848     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
849         // solhint-disable-previous-line no-empty-blocks
850     }
851 }
852 
853 /**
854  * @title Roles
855  * @dev Library for managing addresses assigned to a Role.
856  */
857 library Roles {
858     struct Role {
859         mapping (address => bool) bearer;
860     }
861 
862     /**
863      * @dev give an account access to this role
864      */
865     function add(Role storage role, address account) internal {
866         require(account != address(0));
867         require(!has(role, account));
868 
869         role.bearer[account] = true;
870     }
871 
872     /**
873      * @dev remove an account's access to this role
874      */
875     function remove(Role storage role, address account) internal {
876         require(account != address(0));
877         require(has(role, account));
878 
879         role.bearer[account] = false;
880     }
881 
882     /**
883      * @dev check if an account has this role
884      * @return bool
885      */
886     function has(Role storage role, address account) internal view returns (bool) {
887         require(account != address(0));
888         return role.bearer[account];
889     }
890 }
891 
892 contract MinterRole {
893     using Roles for Roles.Role;
894 
895     event MinterAdded(address indexed account);
896     event MinterRemoved(address indexed account);
897 
898     Roles.Role private _minters;
899 
900     constructor () internal {
901         _addMinter(msg.sender);
902     }
903 
904     modifier onlyMinter() {
905         require(isMinter(msg.sender));
906         _;
907     }
908 
909     function isMinter(address account) public view returns (bool) {
910         return _minters.has(account);
911     }
912 
913     function addMinter(address account) public onlyMinter {
914         _addMinter(account);
915     }
916 
917     function renounceMinter() public {
918         _removeMinter(msg.sender);
919     }
920 
921     function _addMinter(address account) internal {
922         _minters.add(account);
923         emit MinterAdded(account);
924     }
925 
926     function _removeMinter(address account) internal {
927         _minters.remove(account);
928         emit MinterRemoved(account);
929     }
930 }
931 
932 /**
933  * @title ERC721MetadataMintable
934  * @dev ERC721 minting logic with metadata
935  */
936 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
937     /**
938      * @dev Function to mint tokens
939      * @param to The address that will receive the minted tokens.
940      * @param tokenId The token id to mint.
941      * @param tokenURI The token URI of the minted token.
942      * @return A boolean that indicates if the operation was successful.
943      */
944     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter returns (bool) {
945         _mint(to, tokenId);
946         _setTokenURI(tokenId, tokenURI);
947         return true;
948     }
949 }
950 
951 /**
952  * Phat Cats - Crypto-Cards
953  *  - https://crypto-cards.io
954  *  - https://phatcats.co
955  *
956  * Copyright 2019 (c) Phat Cats, Inc.
957  *
958  * Contract Audits:
959  *   - SmartDEC International - https://smartcontracts.smartdec.net
960  *   - Callisto Security Department - https://callisto.network/
961  */
962 
963 contract OwnableDelegateProxy { }
964 
965 contract ProxyRegistry {
966     mapping(address => OwnableDelegateProxy) public proxies;
967 }
968 
969 /**
970  * @title Crypto-Cards ERC721 Token
971  */
972 contract CryptoCardsERC721 is Ownable, ERC721Full, ERC721MetadataMintable {
973     address internal proxyRegistryAddress;
974     mapping(uint256 => bool) internal tokenFrozenById; // Applies to Opened Packs and Printed Cards
975 
976     constructor(string memory name, string memory symbol) public ERC721Full(name, symbol) { }
977 
978     function setProxyRegistryAddress(address _proxyRegistryAddress) public onlyOwner {
979         proxyRegistryAddress = _proxyRegistryAddress;
980     }
981 
982     function isApprovedForAll(address owner, address operator) public view returns (bool) {
983         // Whitelist OpenSea proxy contract for easy trading.
984         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
985         if (address(proxyRegistry.proxies(owner)) == operator) {
986             return true;
987         }
988 
989         return super.isApprovedForAll(owner, operator);
990     }
991 
992     function isTokenFrozen(uint256 _tokenId) public view returns (bool) {
993         return tokenFrozenById[_tokenId];
994     }
995 
996     function freezeToken(uint256 _tokenId) public onlyMinter {
997         tokenFrozenById[_tokenId] = true;
998     }
999 
1000     function tokenTransfer(address _from, address _to, uint256 _tokenId) public onlyMinter {
1001         _transferFrom(_from, _to, _tokenId);
1002     }
1003 
1004     function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
1005         require(tokenFrozenById[_tokenId] != true);
1006         super._transferFrom(_from, _to, _tokenId);
1007     }
1008 }
1009 
1010 /**
1011  * Phat Cats - Crypto-Cards
1012  *  - https://crypto-cards.io
1013  *  - https://phatcats.co
1014  *
1015  * Copyright 2019 (c) Phat Cats, Inc.
1016  *
1017  * Contract Audits:
1018  *   - SmartDEC International - https://smartcontracts.smartdec.net
1019  *   - Callisto Security Department - https://callisto.network/
1020  */
1021 
1022 /**
1023  * @title Crypto-Cards ERC721 Card Token
1024  * ERC721-compliant token representing individual Cards
1025  */
1026 contract CryptoCardsCardToken is CryptoCardsERC721 {
1027     constructor() public CryptoCardsERC721("CryptoCards Cards", "CARDS") { }
1028 }