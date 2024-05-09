1 pragma solidity ^0.5.0;
2 
3 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/introspection/IERC165.sol
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
19 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
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
45 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
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
71 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
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
137 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/utils/Address.sol
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
164 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/introspection/ERC165.sol
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
207 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
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
487 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
488 
489 /**
490  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
491  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
492  */
493 contract IERC721Metadata is IERC721 {
494     function name() external view returns (string memory);
495     function symbol() external view returns (string memory);
496     function tokenURI(uint256 tokenId) external view returns (string memory);
497 }
498 
499 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
500 
501 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
502     // Token name
503     string private _name;
504 
505     // Token symbol
506     string private _symbol;
507 
508     // Optional mapping for token URIs
509     mapping(uint256 => string) private _tokenURIs;
510 
511     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
512     /**
513      * 0x5b5e139f ===
514      *     bytes4(keccak256('name()')) ^
515      *     bytes4(keccak256('symbol()')) ^
516      *     bytes4(keccak256('tokenURI(uint256)'))
517      */
518 
519     /**
520      * @dev Constructor function
521      */
522     constructor (string memory name, string memory symbol) public {
523         _name = name;
524         _symbol = symbol;
525 
526         // register the supported interfaces to conform to ERC721 via ERC165
527         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
528     }
529 
530     /**
531      * @dev Gets the token name
532      * @return string representing the token name
533      */
534     function name() external view returns (string memory) {
535         return _name;
536     }
537 
538     /**
539      * @dev Gets the token symbol
540      * @return string representing the token symbol
541      */
542     function symbol() external view returns (string memory) {
543         return _symbol;
544     }
545 
546     /**
547      * @dev Returns an URI for a given token ID
548      * Throws if the token ID does not exist. May return an empty string.
549      * @param tokenId uint256 ID of the token to query
550      */
551     function tokenURI(uint256 tokenId) external view returns (string memory) {
552         require(_exists(tokenId));
553         return _tokenURIs[tokenId];
554     }
555 
556     /**
557      * @dev Internal function to set the token URI for a given token
558      * Reverts if the token ID does not exist
559      * @param tokenId uint256 ID of the token to set its URI
560      * @param uri string URI to assign
561      */
562     function _setTokenURI(uint256 tokenId, string memory uri) internal {
563         require(_exists(tokenId));
564         _tokenURIs[tokenId] = uri;
565     }
566 
567     /**
568      * @dev Internal function to burn a specific token
569      * Reverts if the token does not exist
570      * Deprecated, use _burn(uint256) instead
571      * @param owner owner of the token to burn
572      * @param tokenId uint256 ID of the token being burned by the msg.sender
573      */
574     function _burn(address owner, uint256 tokenId) internal {
575         super._burn(owner, tokenId);
576 
577         // Clear metadata (if any)
578         if (bytes(_tokenURIs[tokenId]).length != 0) {
579             delete _tokenURIs[tokenId];
580         }
581     }
582 }
583 
584 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/access/Roles.sol
585 
586 /**
587  * @title Roles
588  * @dev Library for managing addresses assigned to a Role.
589  */
590 library Roles {
591     struct Role {
592         mapping (address => bool) bearer;
593     }
594 
595     /**
596      * @dev give an account access to this role
597      */
598     function add(Role storage role, address account) internal {
599         require(account != address(0));
600         require(!has(role, account));
601 
602         role.bearer[account] = true;
603     }
604 
605     /**
606      * @dev remove an account's access to this role
607      */
608     function remove(Role storage role, address account) internal {
609         require(account != address(0));
610         require(has(role, account));
611 
612         role.bearer[account] = false;
613     }
614 
615     /**
616      * @dev check if an account has this role
617      * @return bool
618      */
619     function has(Role storage role, address account) internal view returns (bool) {
620         require(account != address(0));
621         return role.bearer[account];
622     }
623 }
624 
625 // File: /mnt/c/repos/RxCTicketNFT/node_modules/openzeppelin-solidity/contracts/access/roles/MinterRole.sol
626 
627 contract MinterRole {
628     using Roles for Roles.Role;
629 
630     event MinterAdded(address indexed account);
631     event MinterRemoved(address indexed account);
632 
633     Roles.Role private _minters;
634 
635     constructor () internal {
636         _addMinter(msg.sender);
637     }
638 
639     modifier onlyMinter() {
640         require(isMinter(msg.sender));
641         _;
642     }
643 
644     function isMinter(address account) public view returns (bool) {
645         return _minters.has(account);
646     }
647 
648     function addMinter(address account) public onlyMinter {
649         _addMinter(account);
650     }
651 
652     function renounceMinter() public {
653         _removeMinter(msg.sender);
654     }
655 
656     function _addMinter(address account) internal {
657         _minters.add(account);
658         emit MinterAdded(account);
659     }
660 
661     function _removeMinter(address account) internal {
662         _minters.remove(account);
663         emit MinterRemoved(account);
664     }
665 }
666 
667 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721MetadataMintable.sol
668 
669 /**
670  * @title ERC721MetadataMintable
671  * @dev ERC721 minting logic with metadata
672  */
673 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
674     /**
675      * @dev Function to mint tokens
676      * @param to The address that will receive the minted tokens.
677      * @param tokenId The token id to mint.
678      * @param tokenURI The token URI of the minted token.
679      * @return A boolean that indicates if the operation was successful.
680      */
681     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter returns (bool) {
682         _mint(to, tokenId);
683         _setTokenURI(tokenId, tokenURI);
684         return true;
685     }
686 }
687 
688 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
689 
690 /**
691  * @title Ownable
692  * @dev The Ownable contract has an owner address, and provides basic authorization control
693  * functions, this simplifies the implementation of "user permissions".
694  */
695 contract Ownable {
696     address private _owner;
697 
698     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
699 
700     /**
701      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
702      * account.
703      */
704     constructor () internal {
705         _owner = msg.sender;
706         emit OwnershipTransferred(address(0), _owner);
707     }
708 
709     /**
710      * @return the address of the owner.
711      */
712     function owner() public view returns (address) {
713         return _owner;
714     }
715 
716     /**
717      * @dev Throws if called by any account other than the owner.
718      */
719     modifier onlyOwner() {
720         require(isOwner());
721         _;
722     }
723 
724     /**
725      * @return true if `msg.sender` is the owner of the contract.
726      */
727     function isOwner() public view returns (bool) {
728         return msg.sender == _owner;
729     }
730 
731     /**
732      * @dev Allows the current owner to relinquish control of the contract.
733      * @notice Renouncing to ownership will leave the contract without an owner.
734      * It will not be possible to call the functions with the `onlyOwner`
735      * modifier anymore.
736      */
737     function renounceOwnership() public onlyOwner {
738         emit OwnershipTransferred(_owner, address(0));
739         _owner = address(0);
740     }
741 
742     /**
743      * @dev Allows the current owner to transfer control of the contract to a newOwner.
744      * @param newOwner The address to transfer ownership to.
745      */
746     function transferOwnership(address newOwner) public onlyOwner {
747         _transferOwnership(newOwner);
748     }
749 
750     /**
751      * @dev Transfers control of the contract to a newOwner.
752      * @param newOwner The address to transfer ownership to.
753      */
754     function _transferOwnership(address newOwner) internal {
755         require(newOwner != address(0));
756         emit OwnershipTransferred(_owner, newOwner);
757         _owner = newOwner;
758     }
759 }
760 
761 // File: contracts/RadxCollectible.sol
762 
763 /**
764  * @title RadxCollectible
765  * RxC Conference 2019 - a contract for a non-fungible conference ticket.
766  */
767 contract RadxCollectible is ERC721Metadata("RxC Conference 2019", "RxC"), Ownable, ERC721MetadataMintable {
768 
769 }