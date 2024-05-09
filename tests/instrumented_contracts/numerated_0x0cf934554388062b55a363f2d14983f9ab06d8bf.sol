1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title IERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface IERC165 {
8     /**
9      * @notice Query if a contract implements an interface
10      * @param interfaceId The interface identifier, as specified in ERC-165
11      * @dev Interface identification is specified in ERC-165. This function
12      * uses less than 30,000 gas.
13      */
14     function supportsInterface(bytes4 interfaceId) external view returns (bool);
15 }
16 
17 
18 /**
19  * @title Roles
20  * @dev Library for managing addresses assigned to a Role.
21  */
22 library Roles {
23     struct Role {
24         mapping (address => bool) bearer;
25     }
26 
27     /**
28      * @dev give an account access to this role
29      */
30     function add(Role storage role, address account) internal {
31         require(account != address(0));
32         require(!has(role, account));
33 
34         role.bearer[account] = true;
35     }
36 
37     /**
38      * @dev remove an account's access to this role
39      */
40     function remove(Role storage role, address account) internal {
41         require(account != address(0));
42         require(has(role, account));
43 
44         role.bearer[account] = false;
45     }
46 
47     /**
48      * @dev check if an account has this role
49      * @return bool
50      */
51     function has(Role storage role, address account) internal view returns (bool) {
52         require(account != address(0));
53         return role.bearer[account];
54     }
55 }
56 
57 
58 
59 
60 contract PauserRole {
61     using Roles for Roles.Role;
62 
63     event PauserAdded(address indexed account);
64     event PauserRemoved(address indexed account);
65 
66     Roles.Role private _pausers;
67 
68     constructor () internal {
69         _addPauser(msg.sender);
70     }
71 
72     modifier onlyPauser() {
73         require(isPauser(msg.sender));
74         _;
75     }
76 
77     function isPauser(address account) public view returns (bool) {
78         return _pausers.has(account);
79     }
80 
81     function addPauser(address account) public onlyPauser {
82         _addPauser(account);
83     }
84 
85     function renouncePauser() public {
86         _removePauser(msg.sender);
87     }
88 
89     function _addPauser(address account) internal {
90         _pausers.add(account);
91         emit PauserAdded(account);
92     }
93 
94     function _removePauser(address account) internal {
95         _pausers.remove(account);
96         emit PauserRemoved(account);
97     }
98 }
99 
100 
101 
102 
103 /**
104  * @title ERC165
105  * @author Matt Condon (@shrugs)
106  * @dev Implements ERC165 using a lookup table.
107  */
108 contract ERC165 is IERC165 {
109     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
110     /**
111      * 0x01ffc9a7 ===
112      *     bytes4(keccak256('supportsInterface(bytes4)'))
113      */
114 
115     /**
116      * @dev a mapping of interface id to whether or not it's supported
117      */
118     mapping(bytes4 => bool) private _supportedInterfaces;
119 
120     /**
121      * @dev A contract implementing SupportsInterfaceWithLookup
122      * implement ERC165 itself
123      */
124     constructor () internal {
125         _registerInterface(_INTERFACE_ID_ERC165);
126     }
127 
128     /**
129      * @dev implement supportsInterface(bytes4) using a lookup table
130      */
131     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
132         return _supportedInterfaces[interfaceId];
133     }
134 
135     /**
136      * @dev internal method for registering an interface
137      */
138     function _registerInterface(bytes4 interfaceId) internal {
139         require(interfaceId != 0xffffffff);
140         _supportedInterfaces[interfaceId] = true;
141     }
142 }
143 
144 
145 
146 
147 
148 
149 /**
150  * @title ERC721 Non-Fungible Token Standard basic interface
151  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
152  */
153 contract IERC721 is IERC165 {
154     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
155     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
156     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
157 
158     function balanceOf(address owner) public view returns (uint256 balance);
159     function ownerOf(uint256 tokenId) public view returns (address owner);
160 
161     function approve(address to, uint256 tokenId) public;
162     function getApproved(uint256 tokenId) public view returns (address operator);
163 
164     function setApprovalForAll(address operator, bool _approved) public;
165     function isApprovedForAll(address owner, address operator) public view returns (bool);
166 
167     function transferFrom(address from, address to, uint256 tokenId) public;
168     function safeTransferFrom(address from, address to, uint256 tokenId) public;
169 
170     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
171 }
172 
173 
174 
175 /**
176  * @title ERC721 token receiver interface
177  * @dev Interface for any contract that wants to support safeTransfers
178  * from ERC721 asset contracts.
179  */
180 contract IERC721Receiver {
181     /**
182      * @notice Handle the receipt of an NFT
183      * @dev The ERC721 smart contract calls this function on the recipient
184      * after a `safeTransfer`. This function MUST return the function selector,
185      * otherwise the caller will revert the transaction. The selector to be
186      * returned can be obtained as `this.onERC721Received.selector`. This
187      * function MAY throw to revert and reject the transfer.
188      * Note: the ERC721 contract address is always the message sender.
189      * @param operator The address which called `safeTransferFrom` function
190      * @param from The address which previously owned the token
191      * @param tokenId The NFT identifier which is being transferred
192      * @param data Additional data with no specified format
193      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
194      */
195     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
196     public returns (bytes4);
197 }
198 
199 
200 
201 /**
202  * @title SafeMath
203  * @dev Unsigned math operations with safety checks that revert on error
204  */
205 library SafeMath {
206     /**
207     * @dev Multiplies two unsigned integers, reverts on overflow.
208     */
209     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
211         // benefit is lost if 'b' is also tested.
212         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
213         if (a == 0) {
214             return 0;
215         }
216 
217         uint256 c = a * b;
218         require(c / a == b);
219 
220         return c;
221     }
222 
223     /**
224     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
225     */
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
237     */
238     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
239         require(b <= a);
240         uint256 c = a - b;
241 
242         return c;
243     }
244 
245     /**
246     * @dev Adds two unsigned integers, reverts on overflow.
247     */
248     function add(uint256 a, uint256 b) internal pure returns (uint256) {
249         uint256 c = a + b;
250         require(c >= a);
251 
252         return c;
253     }
254 
255     /**
256     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
257     * reverts when dividing by zero.
258     */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         require(b != 0);
261         return a % b;
262     }
263 }
264 
265 
266 
267 /**
268  * Utility library of inline functions on addresses
269  */
270 library Address {
271     /**
272      * Returns whether the target address is a contract
273      * @dev This function will return false if invoked during the constructor of a contract,
274      * as the code is not actually created until after the constructor finishes.
275      * @param account address of the account to check
276      * @return whether the target address is a contract
277      */
278     function isContract(address account) internal view returns (bool) {
279         uint256 size;
280         // XXX Currently there is no better way to check if there is a contract in an address
281         // than to check the size of the code at that address.
282         // See https://ethereum.stackexchange.com/a/14016/36603
283         // for more details about how this works.
284         // TODO Check this again before the Serenity release, because all addresses will be
285         // contracts then.
286         // solhint-disable-next-line no-inline-assembly
287         assembly { size := extcodesize(account) }
288         return size > 0;
289     }
290 }
291 
292 
293 
294 /**
295  * @title ERC721 Non-Fungible Token Standard basic implementation
296  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
297  */
298 contract ERC721 is ERC165, IERC721 {
299     using SafeMath for uint256;
300     using Address for address;
301 
302     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
303     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
304     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
305 
306     // Mapping from token ID to owner
307     mapping (uint256 => address) private _tokenOwner;
308 
309     // Mapping from token ID to approved address
310     mapping (uint256 => address) private _tokenApprovals;
311 
312     // Mapping from owner to number of owned token
313     mapping (address => uint256) private _ownedTokensCount;
314 
315     // Mapping from owner to operator approvals
316     mapping (address => mapping (address => bool)) private _operatorApprovals;
317 
318     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
319     /*
320      * 0x80ac58cd ===
321      *     bytes4(keccak256('balanceOf(address)')) ^
322      *     bytes4(keccak256('ownerOf(uint256)')) ^
323      *     bytes4(keccak256('approve(address,uint256)')) ^
324      *     bytes4(keccak256('getApproved(uint256)')) ^
325      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
326      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
327      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
328      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
329      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
330      */
331 
332     constructor () public {
333         // register the supported interfaces to conform to ERC721 via ERC165
334         _registerInterface(_INTERFACE_ID_ERC721);
335     }
336 
337     /**
338      * @dev Gets the balance of the specified address
339      * @param owner address to query the balance of
340      * @return uint256 representing the amount owned by the passed address
341      */
342     function balanceOf(address owner) public view returns (uint256) {
343         require(owner != address(0));
344         return _ownedTokensCount[owner];
345     }
346 
347     /**
348      * @dev Gets the owner of the specified token ID
349      * @param tokenId uint256 ID of the token to query the owner of
350      * @return owner address currently marked as the owner of the given token ID
351      */
352     function ownerOf(uint256 tokenId) public view returns (address) {
353         address owner = _tokenOwner[tokenId];
354         require(owner != address(0));
355         return owner;
356     }
357 
358     /**
359      * @dev Approves another address to transfer the given token ID
360      * The zero address indicates there is no approved address.
361      * There can only be one approved address per token at a given time.
362      * Can only be called by the token owner or an approved operator.
363      * @param to address to be approved for the given token ID
364      * @param tokenId uint256 ID of the token to be approved
365      */
366     function approve(address to, uint256 tokenId) public {
367         address owner = ownerOf(tokenId);
368         require(to != owner);
369         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
370 
371         _tokenApprovals[tokenId] = to;
372         emit Approval(owner, to, tokenId);
373     }
374 
375     /**
376      * @dev Gets the approved address for a token ID, or zero if no address set
377      * Reverts if the token ID does not exist.
378      * @param tokenId uint256 ID of the token to query the approval of
379      * @return address currently approved for the given token ID
380      */
381     function getApproved(uint256 tokenId) public view returns (address) {
382         require(_exists(tokenId));
383         return _tokenApprovals[tokenId];
384     }
385 
386     /**
387      * @dev Sets or unsets the approval of a given operator
388      * An operator is allowed to transfer all tokens of the sender on their behalf
389      * @param to operator address to set the approval
390      * @param approved representing the status of the approval to be set
391      */
392     function setApprovalForAll(address to, bool approved) public {
393         require(to != msg.sender);
394         _operatorApprovals[msg.sender][to] = approved;
395         emit ApprovalForAll(msg.sender, to, approved);
396     }
397 
398     /**
399      * @dev Tells whether an operator is approved by a given owner
400      * @param owner owner address which you want to query the approval of
401      * @param operator operator address which you want to query the approval of
402      * @return bool whether the given operator is approved by the given owner
403      */
404     function isApprovedForAll(address owner, address operator) public view returns (bool) {
405         return _operatorApprovals[owner][operator];
406     }
407 
408     /**
409      * @dev Transfers the ownership of a given token ID to another address
410      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
411      * Requires the msg sender to be the owner, approved, or operator
412      * @param from current owner of the token
413      * @param to address to receive the ownership of the given token ID
414      * @param tokenId uint256 ID of the token to be transferred
415     */
416     function transferFrom(address from, address to, uint256 tokenId) public {
417         require(_isApprovedOrOwner(msg.sender, tokenId));
418 
419         _transferFrom(from, to, tokenId);
420     }
421 
422     /**
423      * @dev Safely transfers the ownership of a given token ID to another address
424      * If the target address is a contract, it must implement `onERC721Received`,
425      * which is called upon a safe transfer, and return the magic value
426      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
427      * the transfer is reverted.
428      *
429      * Requires the msg sender to be the owner, approved, or operator
430      * @param from current owner of the token
431      * @param to address to receive the ownership of the given token ID
432      * @param tokenId uint256 ID of the token to be transferred
433     */
434     function safeTransferFrom(address from, address to, uint256 tokenId) public {
435         safeTransferFrom(from, to, tokenId, "");
436     }
437 
438     /**
439      * @dev Safely transfers the ownership of a given token ID to another address
440      * If the target address is a contract, it must implement `onERC721Received`,
441      * which is called upon a safe transfer, and return the magic value
442      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
443      * the transfer is reverted.
444      * Requires the msg sender to be the owner, approved, or operator
445      * @param from current owner of the token
446      * @param to address to receive the ownership of the given token ID
447      * @param tokenId uint256 ID of the token to be transferred
448      * @param _data bytes data to send along with a safe transfer check
449      */
450     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
451         transferFrom(from, to, tokenId);
452         require(_checkOnERC721Received(from, to, tokenId, _data));
453     }
454 
455     /**
456      * @dev Returns whether the specified token exists
457      * @param tokenId uint256 ID of the token to query the existence of
458      * @return whether the token exists
459      */
460     function _exists(uint256 tokenId) internal view returns (bool) {
461         address owner = _tokenOwner[tokenId];
462         return owner != address(0);
463     }
464 
465     /**
466      * @dev Returns whether the given spender can transfer a given token ID
467      * @param spender address of the spender to query
468      * @param tokenId uint256 ID of the token to be transferred
469      * @return bool whether the msg.sender is approved for the given token ID,
470      *    is an operator of the owner, or is the owner of the token
471      */
472     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
473         address owner = ownerOf(tokenId);
474         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
475     }
476 
477     /**
478      * @dev Internal function to mint a new token
479      * Reverts if the given token ID already exists
480      * @param to The address that will own the minted token
481      * @param tokenId uint256 ID of the token to be minted
482      */
483     function _mint(address to, uint256 tokenId) internal {
484         require(to != address(0));
485         require(!_exists(tokenId));
486 
487         _tokenOwner[tokenId] = to;
488         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
489 
490         emit Transfer(address(0), to, tokenId);
491     }
492 
493     /**
494      * @dev Internal function to burn a specific token
495      * Reverts if the token does not exist
496      * Deprecated, use _burn(uint256) instead.
497      * @param owner owner of the token to burn
498      * @param tokenId uint256 ID of the token being burned
499      */
500     function _burn(address owner, uint256 tokenId) internal {
501         require(ownerOf(tokenId) == owner);
502 
503         _clearApproval(tokenId);
504 
505         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
506         _tokenOwner[tokenId] = address(0);
507 
508         emit Transfer(owner, address(0), tokenId);
509     }
510 
511     /**
512      * @dev Internal function to burn a specific token
513      * Reverts if the token does not exist
514      * @param tokenId uint256 ID of the token being burned
515      */
516     function _burn(uint256 tokenId) internal {
517         _burn(ownerOf(tokenId), tokenId);
518     }
519 
520     /**
521      * @dev Internal function to transfer ownership of a given token ID to another address.
522      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
523      * @param from current owner of the token
524      * @param to address to receive the ownership of the given token ID
525      * @param tokenId uint256 ID of the token to be transferred
526     */
527     function _transferFrom(address from, address to, uint256 tokenId) internal {
528         require(ownerOf(tokenId) == from);
529         require(to != address(0));
530 
531         _clearApproval(tokenId);
532 
533         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
534         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
535 
536         _tokenOwner[tokenId] = to;
537 
538         emit Transfer(from, to, tokenId);
539     }
540 
541     /**
542      * @dev Internal function to invoke `onERC721Received` on a target address
543      * The call is not executed if the target address is not a contract
544      * @param from address representing the previous owner of the given token ID
545      * @param to target address that will receive the tokens
546      * @param tokenId uint256 ID of the token to be transferred
547      * @param _data bytes optional data to send along with the call
548      * @return whether the call correctly returned the expected magic value
549      */
550     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
551         internal returns (bool)
552     {
553         if (!to.isContract()) {
554             return true;
555         }
556 
557         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
558         return (retval == _ERC721_RECEIVED);
559     }
560 
561     /**
562      * @dev Private function to clear current approval of a given token ID
563      * @param tokenId uint256 ID of the token to be transferred
564      */
565     function _clearApproval(uint256 tokenId) private {
566         if (_tokenApprovals[tokenId] != address(0)) {
567             _tokenApprovals[tokenId] = address(0);
568         }
569     }
570 }
571 
572 
573 
574 
575 
576 
577 
578 
579 
580 
581 
582 /**
583  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
584  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
585  */
586 contract IERC721Enumerable is IERC721 {
587     function totalSupply() public view returns (uint256);
588     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
589 
590     function tokenByIndex(uint256 index) public view returns (uint256);
591 }
592 
593 
594 
595 
596 /**
597  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
598  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
599  */
600 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
601     // Mapping from owner to list of owned token IDs
602     mapping(address => uint256[]) private _ownedTokens;
603 
604     // Mapping from token ID to index of the owner tokens list
605     mapping(uint256 => uint256) private _ownedTokensIndex;
606 
607     // Array with all token ids, used for enumeration
608     uint256[] private _allTokens;
609 
610     // Mapping from token id to position in the allTokens array
611     mapping(uint256 => uint256) private _allTokensIndex;
612 
613     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
614     /**
615      * 0x780e9d63 ===
616      *     bytes4(keccak256('totalSupply()')) ^
617      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
618      *     bytes4(keccak256('tokenByIndex(uint256)'))
619      */
620 
621     /**
622      * @dev Constructor function
623      */
624     constructor () public {
625         // register the supported interface to conform to ERC721 via ERC165
626         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
627     }
628 
629     /**
630      * @dev Gets the token ID at a given index of the tokens list of the requested owner
631      * @param owner address owning the tokens list to be accessed
632      * @param index uint256 representing the index to be accessed of the requested tokens list
633      * @return uint256 token ID at the given index of the tokens list owned by the requested address
634      */
635     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
636         require(index < balanceOf(owner));
637         return _ownedTokens[owner][index];
638     }
639 
640     /**
641      * @dev Gets the total amount of tokens stored by the contract
642      * @return uint256 representing the total amount of tokens
643      */
644     function totalSupply() public view returns (uint256) {
645         return _allTokens.length;
646     }
647 
648     /**
649      * @dev Gets the token ID at a given index of all the tokens in this contract
650      * Reverts if the index is greater or equal to the total number of tokens
651      * @param index uint256 representing the index to be accessed of the tokens list
652      * @return uint256 token ID at the given index of the tokens list
653      */
654     function tokenByIndex(uint256 index) public view returns (uint256) {
655         require(index < totalSupply());
656         return _allTokens[index];
657     }
658 
659     /**
660      * @dev Internal function to transfer ownership of a given token ID to another address.
661      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
662      * @param from current owner of the token
663      * @param to address to receive the ownership of the given token ID
664      * @param tokenId uint256 ID of the token to be transferred
665     */
666     function _transferFrom(address from, address to, uint256 tokenId) internal {
667         super._transferFrom(from, to, tokenId);
668 
669         _removeTokenFromOwnerEnumeration(from, tokenId);
670 
671         _addTokenToOwnerEnumeration(to, tokenId);
672     }
673 
674     /**
675      * @dev Internal function to mint a new token
676      * Reverts if the given token ID already exists
677      * @param to address the beneficiary that will own the minted token
678      * @param tokenId uint256 ID of the token to be minted
679      */
680     function _mint(address to, uint256 tokenId) internal {
681         super._mint(to, tokenId);
682 
683         _addTokenToOwnerEnumeration(to, tokenId);
684 
685         _addTokenToAllTokensEnumeration(tokenId);
686     }
687 
688     /**
689      * @dev Internal function to burn a specific token
690      * Reverts if the token does not exist
691      * Deprecated, use _burn(uint256) instead
692      * @param owner owner of the token to burn
693      * @param tokenId uint256 ID of the token being burned
694      */
695     function _burn(address owner, uint256 tokenId) internal {
696         super._burn(owner, tokenId);
697 
698         _removeTokenFromOwnerEnumeration(owner, tokenId);
699         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
700         _ownedTokensIndex[tokenId] = 0;
701 
702         _removeTokenFromAllTokensEnumeration(tokenId);
703     }
704 
705     /**
706      * @dev Gets the list of token IDs of the requested owner
707      * @param owner address owning the tokens
708      * @return uint256[] List of token IDs owned by the requested address
709      */
710     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
711         return _ownedTokens[owner];
712     }
713 
714     /**
715      * @dev Private function to add a token to this extension's ownership-tracking data structures.
716      * @param to address representing the new owner of the given token ID
717      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
718      */
719     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
720         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
721         _ownedTokens[to].push(tokenId);
722     }
723 
724     /**
725      * @dev Private function to add a token to this extension's token tracking data structures.
726      * @param tokenId uint256 ID of the token to be added to the tokens list
727      */
728     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
729         _allTokensIndex[tokenId] = _allTokens.length;
730         _allTokens.push(tokenId);
731     }
732 
733     /**
734      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
735      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
736      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
737      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
738      * @param from address representing the previous owner of the given token ID
739      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
740      */
741     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
742         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
743         // then delete the last slot (swap and pop).
744 
745         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
746         uint256 tokenIndex = _ownedTokensIndex[tokenId];
747 
748         // When the token to delete is the last token, the swap operation is unnecessary
749         if (tokenIndex != lastTokenIndex) {
750             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
751 
752             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
753             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
754         }
755 
756         // This also deletes the contents at the last position of the array
757         _ownedTokens[from].length--;
758 
759         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
760         // lasTokenId, or just over the end of the array if the token was the last one).
761     }
762 
763     /**
764      * @dev Private function to remove a token from this extension's token tracking data structures.
765      * This has O(1) time complexity, but alters the order of the _allTokens array.
766      * @param tokenId uint256 ID of the token to be removed from the tokens list
767      */
768     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
769         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
770         // then delete the last slot (swap and pop).
771 
772         uint256 lastTokenIndex = _allTokens.length.sub(1);
773         uint256 tokenIndex = _allTokensIndex[tokenId];
774 
775         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
776         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
777         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
778         uint256 lastTokenId = _allTokens[lastTokenIndex];
779 
780         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
781         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
782 
783         // This also deletes the contents at the last position of the array
784         _allTokens.length--;
785         _allTokensIndex[tokenId] = 0;
786     }
787 }
788 
789 
790 
791 
792 
793 
794 
795 
796 /**
797  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
798  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
799  */
800 contract IERC721Metadata is IERC721 {
801     function name() external view returns (string memory);
802     function symbol() external view returns (string memory);
803     function tokenURI(uint256 tokenId) external view returns (string memory);
804 }
805 
806 
807 
808 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Optional mapping for token URIs
816     mapping(uint256 => string) private _tokenURIs;
817 
818     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
819     /**
820      * 0x5b5e139f ===
821      *     bytes4(keccak256('name()')) ^
822      *     bytes4(keccak256('symbol()')) ^
823      *     bytes4(keccak256('tokenURI(uint256)'))
824      */
825 
826     /**
827      * @dev Constructor function
828      */
829     constructor (string memory name, string memory symbol) public {
830         _name = name;
831         _symbol = symbol;
832 
833         // register the supported interfaces to conform to ERC721 via ERC165
834         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
835     }
836 
837     /**
838      * @dev Gets the token name
839      * @return string representing the token name
840      */
841     function name() external view returns (string memory) {
842         return _name;
843     }
844 
845     /**
846      * @dev Gets the token symbol
847      * @return string representing the token symbol
848      */
849     function symbol() external view returns (string memory) {
850         return _symbol;
851     }
852 
853     /**
854      * @dev Returns an URI for a given token ID
855      * Throws if the token ID does not exist. May return an empty string.
856      * @param tokenId uint256 ID of the token to query
857      */
858     function tokenURI(uint256 tokenId) external view returns (string memory) {
859         require(_exists(tokenId));
860         return _tokenURIs[tokenId];
861     }
862 
863     /**
864      * @dev Internal function to set the token URI for a given token
865      * Reverts if the token ID does not exist
866      * @param tokenId uint256 ID of the token to set its URI
867      * @param uri string URI to assign
868      */
869     function _setTokenURI(uint256 tokenId, string memory uri) internal {
870         require(_exists(tokenId));
871         _tokenURIs[tokenId] = uri;
872     }
873 
874     /**
875      * @dev Internal function to burn a specific token
876      * Reverts if the token does not exist
877      * Deprecated, use _burn(uint256) instead
878      * @param owner owner of the token to burn
879      * @param tokenId uint256 ID of the token being burned by the msg.sender
880      */
881     function _burn(address owner, uint256 tokenId) internal {
882         super._burn(owner, tokenId);
883 
884         // Clear metadata (if any)
885         if (bytes(_tokenURIs[tokenId]).length != 0) {
886             delete _tokenURIs[tokenId];
887         }
888     }
889 }
890 
891 
892 /**
893  * @title Full ERC721 Token
894  * This implementation includes all the required and some optional functionality of the ERC721 standard
895  * Moreover, it includes approve all functionality using operator terminology
896  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
897  */
898 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
899     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
900         // solhint-disable-previous-line no-empty-blocks
901     }
902 }
903 
904 
905 
906 
907 
908 
909 
910 
911 /**
912  * @title Pausable
913  * @dev Base contract which allows children to implement an emergency stop mechanism.
914  */
915 contract Pausable is PauserRole {
916     event Paused(address account);
917     event Unpaused(address account);
918 
919     bool private _paused;
920 
921     constructor () internal {
922         _paused = false;
923     }
924 
925     /**
926      * @return true if the contract is paused, false otherwise.
927      */
928     function paused() public view returns (bool) {
929         return _paused;
930     }
931 
932     /**
933      * @dev Modifier to make a function callable only when the contract is not paused.
934      */
935     modifier whenNotPaused() {
936         require(!_paused);
937         _;
938     }
939 
940     /**
941      * @dev Modifier to make a function callable only when the contract is paused.
942      */
943     modifier whenPaused() {
944         require(_paused);
945         _;
946     }
947 
948     /**
949      * @dev called by the owner to pause, triggers stopped state
950      */
951     function pause() public onlyPauser whenNotPaused {
952         _paused = true;
953         emit Paused(msg.sender);
954     }
955 
956     /**
957      * @dev called by the owner to unpause, returns to normal state
958      */
959     function unpause() public onlyPauser whenPaused {
960         _paused = false;
961         emit Unpaused(msg.sender);
962     }
963 }
964 
965 
966 /**
967  * @title ERC721 Non-Fungible Pausable token
968  * @dev ERC721 modified with pausable transfers.
969  **/
970 contract ERC721Pausable is ERC721, Pausable {
971     function approve(address to, uint256 tokenId) public whenNotPaused {
972         super.approve(to, tokenId);
973     }
974 
975     function setApprovalForAll(address to, bool approved) public whenNotPaused {
976         super.setApprovalForAll(to, approved);
977     }
978 
979     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
980         super.transferFrom(from, to, tokenId);
981     }
982 }
983 
984 
985 
986 /**
987  * @title Ownable
988  * @dev The Ownable contract has an owner address, and provides basic authorization control
989  * functions, this simplifies the implementation of "user permissions".
990  */
991 contract Ownable {
992     address private _owner;
993 
994     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
995 
996     /**
997      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
998      * account.
999      */
1000     constructor () internal {
1001         _owner = msg.sender;
1002         emit OwnershipTransferred(address(0), _owner);
1003     }
1004 
1005     /**
1006      * @return the address of the owner.
1007      */
1008     function owner() public view returns (address) {
1009         return _owner;
1010     }
1011 
1012     /**
1013      * @dev Throws if called by any account other than the owner.
1014      */
1015     modifier onlyOwner() {
1016         require(isOwner());
1017         _;
1018     }
1019 
1020     /**
1021      * @return true if `msg.sender` is the owner of the contract.
1022      */
1023     function isOwner() public view returns (bool) {
1024         return msg.sender == _owner;
1025     }
1026 
1027     /**
1028      * @dev Allows the current owner to relinquish control of the contract.
1029      * @notice Renouncing to ownership will leave the contract without an owner.
1030      * It will not be possible to call the functions with the `onlyOwner`
1031      * modifier anymore.
1032      */
1033     function renounceOwnership() public onlyOwner {
1034         emit OwnershipTransferred(_owner, address(0));
1035         _owner = address(0);
1036     }
1037 
1038     /**
1039      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1040      * @param newOwner The address to transfer ownership to.
1041      */
1042     function transferOwnership(address newOwner) public onlyOwner {
1043         _transferOwnership(newOwner);
1044     }
1045 
1046     /**
1047      * @dev Transfers control of the contract to a newOwner.
1048      * @param newOwner The address to transfer ownership to.
1049      */
1050     function _transferOwnership(address newOwner) internal {
1051         require(newOwner != address(0));
1052         emit OwnershipTransferred(_owner, newOwner);
1053         _owner = newOwner;
1054     }
1055 }
1056 
1057 
1058 contract FCToken is ERC721Full, ERC721Pausable, Ownable {
1059 
1060   uint public last_completed_migration;
1061 
1062   string public constant name = "FCToken";
1063   string public constant symbol = "FCAT";
1064 
1065   address[16] public owners;
1066   uint[] public _prices;
1067   FC[] public _fcs;
1068 
1069   mapping(uint => FC[]) public _supplies;
1070   mapping(uint => uint[]) public _times;
1071   mapping(address => uint[]) public _owners;
1072   mapping(address => uint) public _ownersOfFree;
1073 
1074   constructor() ERC721Full("FCToken", "FCAT") public {
1075     _prices.push(0);
1076   }
1077 
1078   struct FC {
1079     uint _tokenID;
1080     uint _type;
1081   }  
1082 
1083   // EVENTS
1084   event EventBuy(address buyer, uint tokenId, uint cat_type, uint price);
1085   event EventCreatePrice(uint cat_type, uint price);
1086 
1087   // BASE BUY FUNCTION
1088 
1089   function buyKitty(uint p_type) public payable {
1090     
1091     require(!paused());
1092     require(p_type >= 0);
1093     require(_prices.length > p_type);
1094 
1095     uint price = _prices[p_type];
1096     require(price >= 0);
1097 
1098     if (msg.value != price) {
1099       revert();
1100     }
1101 
1102     if (p_type == 0 && _ownersOfFree[msg.sender] != 0) {
1103       revert();
1104     }
1105 
1106 
1107     FC memory cat = FC({_tokenID:_fcs.length, _type: p_type});
1108     _fcs.push(cat);
1109     _mint( msg.sender, cat._tokenID);
1110     _times[cat._tokenID].push(block.timestamp);
1111     _owners[msg.sender].push(cat._tokenID);
1112 
1113     if (p_type == 0) {
1114       _ownersOfFree[msg.sender] = 1;
1115     }
1116 
1117     emit EventBuy(msg.sender, cat._tokenID, p_type, price);
1118   }
1119 
1120   // VIEWS
1121 
1122   function getOwnersTokenIds(address p_owner) public view returns(uint[] memory) {
1123     return _owners[p_owner];
1124   }
1125 
1126   function getCatInfo( uint p_cat_id ) public view returns(uint, uint, uint[] memory ) {
1127     require(_fcs.length >= p_cat_id -1);
1128     return(_fcs[p_cat_id]._tokenID,_fcs[p_cat_id]._type,_times[p_cat_id]);
1129   }
1130 
1131   function getPricesCount() public view returns(uint) {
1132     return _prices.length;
1133   }
1134 
1135   function getExistingTokensAmount() public view returns(uint) {
1136     return _fcs.length;
1137   }
1138 
1139   /*function getSuppliesAmountForType(uint p_type) public view returns(uint) {
1140     return _supplies[p_type].length;
1141   }*/
1142 
1143   function getAmountOfFreeClaimed(address p_owner) public view returns(uint) {
1144     return _ownersOfFree[p_owner];
1145   }
1146 
1147   // ONLY OWNER FUNCTIONS
1148 
1149   /*function clearSuppliesForType(uint p_type) public onlyOwner {
1150     emit EventClearSupplies(p_type);
1151     delete _supplies[p_type];
1152   }*/
1153 
1154   function createNewKittyPrice(uint p_price) public onlyOwner returns(uint) {
1155     require(!paused());
1156     _prices.push(p_price);
1157 
1158     emit EventCreatePrice(_prices.length-1,p_price);
1159   }
1160 
1161   /*function createKitties(uint p_type, uint p_amount) public onlyOwner {
1162     require(!paused());
1163     for (uint i=0; i<p_amount; i++) {
1164       FC memory cat = FC({_tokenID:_fcs.length, _type: p_type});
1165       _supplies[p_type].push(cat);
1166       _fcs.push(cat);
1167       _mint(address(this),cat._tokenID);
1168 
1169     }
1170     emit EventCreateKitties(p_type,p_amount);
1171   }*/
1172 
1173   function clearPrices() public onlyOwner {
1174     delete _prices;
1175   }
1176 
1177   function release() public onlyOwner {
1178     msg.sender.transfer(address(this).balance);
1179   }
1180 
1181   // override
1182 
1183   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1184     if (spender != address(this)) {
1185       return false;
1186     }
1187     else super._isApprovedOrOwner(spender,tokenId);
1188   }
1189 }