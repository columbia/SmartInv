1 pragma solidity 0.5.4;
2 
3 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/introspection/IERC165.sol
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
19 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721.sol
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
45 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721Receiver.sol
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
71 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/math/SafeMath.sol
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
137 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/utils/Address.sol
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
164 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/introspection/ERC165.sol
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
207 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721.sol
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
487 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/Roles.sol
488 
489 /**
490  * @title Roles
491  * @dev Library for managing addresses assigned to a Role.
492  */
493 library Roles {
494     struct Role {
495         mapping (address => bool) bearer;
496     }
497 
498     /**
499      * @dev give an account access to this role
500      */
501     function add(Role storage role, address account) internal {
502         require(account != address(0));
503         require(!has(role, account));
504 
505         role.bearer[account] = true;
506     }
507 
508     /**
509      * @dev remove an account's access to this role
510      */
511     function remove(Role storage role, address account) internal {
512         require(account != address(0));
513         require(has(role, account));
514 
515         role.bearer[account] = false;
516     }
517 
518     /**
519      * @dev check if an account has this role
520      * @return bool
521      */
522     function has(Role storage role, address account) internal view returns (bool) {
523         require(account != address(0));
524         return role.bearer[account];
525     }
526 }
527 
528 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/roles/MinterRole.sol
529 
530 contract MinterRole {
531     using Roles for Roles.Role;
532 
533     event MinterAdded(address indexed account);
534     event MinterRemoved(address indexed account);
535 
536     Roles.Role private _minters;
537 
538     constructor () internal {
539         _addMinter(msg.sender);
540     }
541 
542     modifier onlyMinter() {
543         require(isMinter(msg.sender));
544         _;
545     }
546 
547     function isMinter(address account) public view returns (bool) {
548         return _minters.has(account);
549     }
550 
551     function addMinter(address account) public onlyMinter {
552         _addMinter(account);
553     }
554 
555     function renounceMinter() public {
556         _removeMinter(msg.sender);
557     }
558 
559     function _addMinter(address account) internal {
560         _minters.add(account);
561         emit MinterAdded(account);
562     }
563 
564     function _removeMinter(address account) internal {
565         _minters.remove(account);
566         emit MinterRemoved(account);
567     }
568 }
569 
570 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Mintable.sol
571 
572 /**
573  * @title ERC721Mintable
574  * @dev ERC721 minting logic
575  */
576 contract ERC721Mintable is ERC721, MinterRole {
577     /**
578      * @dev Function to mint tokens
579      * @param to The address that will receive the minted tokens.
580      * @param tokenId The token id to mint.
581      * @return A boolean that indicates if the operation was successful.
582      */
583     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
584         _mint(to, tokenId);
585         return true;
586     }
587 }
588 
589 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/roles/PauserRole.sol
590 
591 contract PauserRole {
592     using Roles for Roles.Role;
593 
594     event PauserAdded(address indexed account);
595     event PauserRemoved(address indexed account);
596 
597     Roles.Role private _pausers;
598 
599     constructor () internal {
600         _addPauser(msg.sender);
601     }
602 
603     modifier onlyPauser() {
604         require(isPauser(msg.sender));
605         _;
606     }
607 
608     function isPauser(address account) public view returns (bool) {
609         return _pausers.has(account);
610     }
611 
612     function addPauser(address account) public onlyPauser {
613         _addPauser(account);
614     }
615 
616     function renouncePauser() public {
617         _removePauser(msg.sender);
618     }
619 
620     function _addPauser(address account) internal {
621         _pausers.add(account);
622         emit PauserAdded(account);
623     }
624 
625     function _removePauser(address account) internal {
626         _pausers.remove(account);
627         emit PauserRemoved(account);
628     }
629 }
630 
631 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/lifecycle/Pausable.sol
632 
633 /**
634  * @title Pausable
635  * @dev Base contract which allows children to implement an emergency stop mechanism.
636  */
637 contract Pausable is PauserRole {
638     event Paused(address account);
639     event Unpaused(address account);
640 
641     bool private _paused;
642 
643     constructor () internal {
644         _paused = false;
645     }
646 
647     /**
648      * @return true if the contract is paused, false otherwise.
649      */
650     function paused() public view returns (bool) {
651         return _paused;
652     }
653 
654     /**
655      * @dev Modifier to make a function callable only when the contract is not paused.
656      */
657     modifier whenNotPaused() {
658         require(!_paused);
659         _;
660     }
661 
662     /**
663      * @dev Modifier to make a function callable only when the contract is paused.
664      */
665     modifier whenPaused() {
666         require(_paused);
667         _;
668     }
669 
670     /**
671      * @dev called by the owner to pause, triggers stopped state
672      */
673     function pause() public onlyPauser whenNotPaused {
674         _paused = true;
675         emit Paused(msg.sender);
676     }
677 
678     /**
679      * @dev called by the owner to unpause, returns to normal state
680      */
681     function unpause() public onlyPauser whenPaused {
682         _paused = false;
683         emit Unpaused(msg.sender);
684     }
685 }
686 
687 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Pausable.sol
688 
689 /**
690  * @title ERC721 Non-Fungible Pausable token
691  * @dev ERC721 modified with pausable transfers.
692  **/
693 contract ERC721Pausable is ERC721, Pausable {
694     function approve(address to, uint256 tokenId) public whenNotPaused {
695         super.approve(to, tokenId);
696     }
697 
698     function setApprovalForAll(address to, bool approved) public whenNotPaused {
699         super.setApprovalForAll(to, approved);
700     }
701 
702     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
703         super.transferFrom(from, to, tokenId);
704     }
705 }
706 
707 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721Enumerable.sol
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
711  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
712  */
713 contract IERC721Enumerable is IERC721 {
714     function totalSupply() public view returns (uint256);
715     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
716 
717     function tokenByIndex(uint256 index) public view returns (uint256);
718 }
719 
720 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Enumerable.sol
721 
722 /**
723  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
724  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
725  */
726 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
727     // Mapping from owner to list of owned token IDs
728     mapping(address => uint256[]) private _ownedTokens;
729 
730     // Mapping from token ID to index of the owner tokens list
731     mapping(uint256 => uint256) private _ownedTokensIndex;
732 
733     // Array with all token ids, used for enumeration
734     uint256[] private _allTokens;
735 
736     // Mapping from token id to position in the allTokens array
737     mapping(uint256 => uint256) private _allTokensIndex;
738 
739     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
740     /**
741      * 0x780e9d63 ===
742      *     bytes4(keccak256('totalSupply()')) ^
743      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
744      *     bytes4(keccak256('tokenByIndex(uint256)'))
745      */
746 
747     /**
748      * @dev Constructor function
749      */
750     constructor () public {
751         // register the supported interface to conform to ERC721 via ERC165
752         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
753     }
754 
755     /**
756      * @dev Gets the token ID at a given index of the tokens list of the requested owner
757      * @param owner address owning the tokens list to be accessed
758      * @param index uint256 representing the index to be accessed of the requested tokens list
759      * @return uint256 token ID at the given index of the tokens list owned by the requested address
760      */
761     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
762         require(index < balanceOf(owner));
763         return _ownedTokens[owner][index];
764     }
765 
766     /**
767      * @dev Gets the total amount of tokens stored by the contract
768      * @return uint256 representing the total amount of tokens
769      */
770     function totalSupply() public view returns (uint256) {
771         return _allTokens.length;
772     }
773 
774     /**
775      * @dev Gets the token ID at a given index of all the tokens in this contract
776      * Reverts if the index is greater or equal to the total number of tokens
777      * @param index uint256 representing the index to be accessed of the tokens list
778      * @return uint256 token ID at the given index of the tokens list
779      */
780     function tokenByIndex(uint256 index) public view returns (uint256) {
781         require(index < totalSupply());
782         return _allTokens[index];
783     }
784 
785     /**
786      * @dev Internal function to transfer ownership of a given token ID to another address.
787      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
788      * @param from current owner of the token
789      * @param to address to receive the ownership of the given token ID
790      * @param tokenId uint256 ID of the token to be transferred
791     */
792     function _transferFrom(address from, address to, uint256 tokenId) internal {
793         super._transferFrom(from, to, tokenId);
794 
795         _removeTokenFromOwnerEnumeration(from, tokenId);
796 
797         _addTokenToOwnerEnumeration(to, tokenId);
798     }
799 
800     /**
801      * @dev Internal function to mint a new token
802      * Reverts if the given token ID already exists
803      * @param to address the beneficiary that will own the minted token
804      * @param tokenId uint256 ID of the token to be minted
805      */
806     function _mint(address to, uint256 tokenId) internal {
807         super._mint(to, tokenId);
808 
809         _addTokenToOwnerEnumeration(to, tokenId);
810 
811         _addTokenToAllTokensEnumeration(tokenId);
812     }
813 
814     /**
815      * @dev Internal function to burn a specific token
816      * Reverts if the token does not exist
817      * Deprecated, use _burn(uint256) instead
818      * @param owner owner of the token to burn
819      * @param tokenId uint256 ID of the token being burned
820      */
821     function _burn(address owner, uint256 tokenId) internal {
822         super._burn(owner, tokenId);
823 
824         _removeTokenFromOwnerEnumeration(owner, tokenId);
825         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
826         _ownedTokensIndex[tokenId] = 0;
827 
828         _removeTokenFromAllTokensEnumeration(tokenId);
829     }
830 
831     /**
832      * @dev Gets the list of token IDs of the requested owner
833      * @param owner address owning the tokens
834      * @return uint256[] List of token IDs owned by the requested address
835      */
836     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
837         return _ownedTokens[owner];
838     }
839 
840     /**
841      * @dev Private function to add a token to this extension's ownership-tracking data structures.
842      * @param to address representing the new owner of the given token ID
843      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
844      */
845     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
846         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
847         _ownedTokens[to].push(tokenId);
848     }
849 
850     /**
851      * @dev Private function to add a token to this extension's token tracking data structures.
852      * @param tokenId uint256 ID of the token to be added to the tokens list
853      */
854     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
855         _allTokensIndex[tokenId] = _allTokens.length;
856         _allTokens.push(tokenId);
857     }
858 
859     /**
860      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
861      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
862      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
863      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
864      * @param from address representing the previous owner of the given token ID
865      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
866      */
867     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
868         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
869         // then delete the last slot (swap and pop).
870 
871         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
872         uint256 tokenIndex = _ownedTokensIndex[tokenId];
873 
874         // When the token to delete is the last token, the swap operation is unnecessary
875         if (tokenIndex != lastTokenIndex) {
876             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
877 
878             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
879             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
880         }
881 
882         // This also deletes the contents at the last position of the array
883         _ownedTokens[from].length--;
884 
885         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
886         // lasTokenId, or just over the end of the array if the token was the last one).
887     }
888 
889     /**
890      * @dev Private function to remove a token from this extension's token tracking data structures.
891      * This has O(1) time complexity, but alters the order of the _allTokens array.
892      * @param tokenId uint256 ID of the token to be removed from the tokens list
893      */
894     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
895         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
896         // then delete the last slot (swap and pop).
897 
898         uint256 lastTokenIndex = _allTokens.length.sub(1);
899         uint256 tokenIndex = _allTokensIndex[tokenId];
900 
901         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
902         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
903         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
904         uint256 lastTokenId = _allTokens[lastTokenIndex];
905 
906         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
907         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
908 
909         // This also deletes the contents at the last position of the array
910         _allTokens.length--;
911         _allTokensIndex[tokenId] = 0;
912     }
913 }
914 
915 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721Metadata.sol
916 
917 /**
918  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
919  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
920  */
921 contract IERC721Metadata is IERC721 {
922     function name() external view returns (string memory);
923     function symbol() external view returns (string memory);
924     function tokenURI(uint256 tokenId) external view returns (string memory);
925 }
926 
927 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Metadata.sol
928 
929 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
930     // Token name
931     string private _name;
932 
933     // Token symbol
934     string private _symbol;
935 
936     // Optional mapping for token URIs
937     mapping(uint256 => string) private _tokenURIs;
938 
939     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
940     /**
941      * 0x5b5e139f ===
942      *     bytes4(keccak256('name()')) ^
943      *     bytes4(keccak256('symbol()')) ^
944      *     bytes4(keccak256('tokenURI(uint256)'))
945      */
946 
947     /**
948      * @dev Constructor function
949      */
950     constructor (string memory name, string memory symbol) public {
951         _name = name;
952         _symbol = symbol;
953 
954         // register the supported interfaces to conform to ERC721 via ERC165
955         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
956     }
957 
958     /**
959      * @dev Gets the token name
960      * @return string representing the token name
961      */
962     function name() external view returns (string memory) {
963         return _name;
964     }
965 
966     /**
967      * @dev Gets the token symbol
968      * @return string representing the token symbol
969      */
970     function symbol() external view returns (string memory) {
971         return _symbol;
972     }
973 
974     /**
975      * @dev Returns an URI for a given token ID
976      * Throws if the token ID does not exist. May return an empty string.
977      * @param tokenId uint256 ID of the token to query
978      */
979     function tokenURI(uint256 tokenId) external view returns (string memory) {
980         require(_exists(tokenId));
981         return _tokenURIs[tokenId];
982     }
983 
984     /**
985      * @dev Internal function to set the token URI for a given token
986      * Reverts if the token ID does not exist
987      * @param tokenId uint256 ID of the token to set its URI
988      * @param uri string URI to assign
989      */
990     function _setTokenURI(uint256 tokenId, string memory uri) internal {
991         require(_exists(tokenId));
992         _tokenURIs[tokenId] = uri;
993     }
994 
995     /**
996      * @dev Internal function to burn a specific token
997      * Reverts if the token does not exist
998      * Deprecated, use _burn(uint256) instead
999      * @param owner owner of the token to burn
1000      * @param tokenId uint256 ID of the token being burned by the msg.sender
1001      */
1002     function _burn(address owner, uint256 tokenId) internal {
1003         super._burn(owner, tokenId);
1004 
1005         // Clear metadata (if any)
1006         if (bytes(_tokenURIs[tokenId]).length != 0) {
1007             delete _tokenURIs[tokenId];
1008         }
1009     }
1010 }
1011 
1012 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721FUll.sol
1013 
1014 /**
1015  * @title Full ERC721 Token
1016  * This implementation includes all the required and some optional functionality of the ERC721 standard
1017  * Moreover, it includes approve all functionality using operator terminology
1018  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1019  */
1020 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1021     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1022         // solhint-disable-previous-line no-empty-blocks
1023     }
1024 }
1025 
1026 // File: contracts/HeroAsset.sol
1027 
1028 contract HeroAsset is ERC721Full, ERC721Mintable, ERC721Pausable {
1029 
1030     uint16 public constant HERO_TYPE_OFFSET = 10000;
1031 
1032     string public tokenURIPrefix = "https://www.mycryptoheroes.net/metadata/hero/";
1033     mapping(uint16 => uint16) private heroTypeToSupplyLimit;
1034 
1035     constructor() public ERC721Full("MyCryptoHeroes:Hero", "MCHH") {}
1036 
1037     function setSupplyLimit(uint16 _heroType, uint16 _supplyLimit) external onlyMinter {
1038         require(heroTypeToSupplyLimit[_heroType] == 0 || _supplyLimit < heroTypeToSupplyLimit[_heroType],
1039             "_supplyLimit is bigger");
1040         heroTypeToSupplyLimit[_heroType] = _supplyLimit;
1041     }
1042 
1043     function setTokenURIPrefix(string calldata _tokenURIPrefix) external onlyMinter {
1044         tokenURIPrefix = _tokenURIPrefix;
1045     }
1046 
1047     function getSupplyLimit(uint16 _heroType) public view returns (uint16) {
1048         return heroTypeToSupplyLimit[_heroType];
1049     }
1050 
1051     function mintHeroAsset(address _owner, uint256 _tokenId) public onlyMinter {
1052         uint16 _heroType = uint16(_tokenId / HERO_TYPE_OFFSET);
1053         uint16 _heroTypeIndex = uint16(_tokenId % HERO_TYPE_OFFSET) - 1;
1054         require(_heroTypeIndex < heroTypeToSupplyLimit[_heroType], "supply over");
1055         _mint(_owner, _tokenId);
1056     }
1057 
1058     function tokenURI(uint256 tokenId) public view returns (string memory) {
1059         bytes32 tokenIdBytes;
1060         if (tokenId == 0) {
1061             tokenIdBytes = "0";
1062         } else {
1063             uint256 value = tokenId;
1064             while (value > 0) {
1065                 tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
1066                 tokenIdBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
1067                 value /= 10;
1068             }
1069         }
1070 
1071         bytes memory prefixBytes = bytes(tokenURIPrefix);
1072         bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
1073 
1074         uint8 i;
1075         uint8 index = 0;
1076         
1077         for (i = 0; i < prefixBytes.length; i++) {
1078             tokenURIBytes[index] = prefixBytes[i];
1079             index++;
1080         }
1081         
1082         for (i = 0; i < tokenIdBytes.length; i++) {
1083             tokenURIBytes[index] = tokenIdBytes[i];
1084             index++;
1085         }
1086         
1087         return string(tokenURIBytes);
1088     }
1089 
1090 }
1091 
1092 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/ownership/Ownable.sol
1093 
1094 /**
1095  * @title Ownable
1096  * @dev The Ownable contract has an owner address, and provides basic authorization control
1097  * functions, this simplifies the implementation of "user permissions".
1098  */
1099 contract Ownable {
1100     address private _owner;
1101 
1102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1103 
1104     /**
1105      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1106      * account.
1107      */
1108     constructor () internal {
1109         _owner = msg.sender;
1110         emit OwnershipTransferred(address(0), _owner);
1111     }
1112 
1113     /**
1114      * @return the address of the owner.
1115      */
1116     function owner() public view returns (address) {
1117         return _owner;
1118     }
1119 
1120     /**
1121      * @dev Throws if called by any account other than the owner.
1122      */
1123     modifier onlyOwner() {
1124         require(isOwner());
1125         _;
1126     }
1127 
1128     /**
1129      * @return true if `msg.sender` is the owner of the contract.
1130      */
1131     function isOwner() public view returns (bool) {
1132         return msg.sender == _owner;
1133     }
1134 
1135     /**
1136      * @dev Allows the current owner to relinquish control of the contract.
1137      * @notice Renouncing to ownership will leave the contract without an owner.
1138      * It will not be possible to call the functions with the `onlyOwner`
1139      * modifier anymore.
1140      */
1141     function renounceOwnership() public onlyOwner {
1142         emit OwnershipTransferred(_owner, address(0));
1143         _owner = address(0);
1144     }
1145 
1146     /**
1147      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1148      * @param newOwner The address to transfer ownership to.
1149      */
1150     function transferOwnership(address newOwner) public onlyOwner {
1151         _transferOwnership(newOwner);
1152     }
1153 
1154     /**
1155      * @dev Transfers control of the contract to a newOwner.
1156      * @param newOwner The address to transfer ownership to.
1157      */
1158     function _transferOwnership(address newOwner) internal {
1159         require(newOwner != address(0));
1160         emit OwnershipTransferred(_owner, newOwner);
1161         _owner = newOwner;
1162     }
1163 }
1164 
1165 // File: contracts/access/roles/OperatorRole.sol
1166 
1167 contract OperatorRole is Ownable {
1168     using Roles for Roles.Role;
1169 
1170     event OperatorAdded(address indexed account);
1171     event OperatorRemoved(address indexed account);
1172 
1173     Roles.Role private operators;
1174 
1175     constructor() public {
1176         operators.add(msg.sender);
1177     }
1178 
1179     modifier onlyOperator() {
1180         require(isOperator(msg.sender));
1181         _;
1182     }
1183     
1184     function isOperator(address account) public view returns (bool) {
1185         return operators.has(account);
1186     }
1187 
1188     function addOperator(address account) public onlyOwner() {
1189         operators.add(account);
1190         emit OperatorAdded(account);
1191     }
1192 
1193     function removeOperator(address account) public onlyOwner() {
1194         operators.remove(account);
1195         emit OperatorRemoved(account);
1196     }
1197 
1198 }
1199 
1200 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC20/IERC20.sol
1201 
1202 /**
1203  * @title ERC20 interface
1204  * @dev see https://github.com/ethereum/EIPs/issues/20
1205  */
1206 interface IERC20 {
1207     function transfer(address to, uint256 value) external returns (bool);
1208 
1209     function approve(address spender, uint256 value) external returns (bool);
1210 
1211     function transferFrom(address from, address to, uint256 value) external returns (bool);
1212 
1213     function totalSupply() external view returns (uint256);
1214 
1215     function balanceOf(address who) external view returns (uint256);
1216 
1217     function allowance(address owner, address spender) external view returns (uint256);
1218 
1219     event Transfer(address indexed from, address indexed to, uint256 value);
1220 
1221     event Approval(address indexed owner, address indexed spender, uint256 value);
1222 }
1223 
1224 // File: contracts/lib/github.com/contract-library/contract-library-0.0.4/contracts/ownership/Withdrawable.sol
1225 
1226 contract Withdrawable is Ownable {
1227   function withdrawEther() external onlyOwner {
1228     msg.sender.transfer(address(this).balance);
1229   }
1230 
1231   function withdrawToken(IERC20 _token) external onlyOwner {
1232     require(_token.transfer(msg.sender, _token.balanceOf(address(this))));
1233   }
1234 }
1235 
1236 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/utils/ReentrancyGuard.sol
1237 
1238 /**
1239  * @title Helps contracts guard against reentrancy attacks.
1240  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
1241  * @dev If you mark a function `nonReentrant`, you should also
1242  * mark it `external`.
1243  */
1244 contract ReentrancyGuard {
1245     /// @dev counter to allow mutex lock with only one SSTORE operation
1246     uint256 private _guardCounter;
1247 
1248     constructor () internal {
1249         // The counter starts at one to prevent changing it from zero to a non-zero
1250         // value, which is a more expensive operation.
1251         _guardCounter = 1;
1252     }
1253 
1254     /**
1255      * @dev Prevents a contract from calling itself, directly or indirectly.
1256      * Calling a `nonReentrant` function from another `nonReentrant`
1257      * function is not supported. It is possible to prevent this from happening
1258      * by making the `nonReentrant` function external, and make it call a
1259      * `private` function that does the actual work.
1260      */
1261     modifier nonReentrant() {
1262         _guardCounter += 1;
1263         uint256 localCounter = _guardCounter;
1264         _;
1265         require(localCounter == _guardCounter);
1266     }
1267 }
1268 
1269 // File: contracts/lib/github.com/contract-library/contract-library-0.0.4/contracts/DJTBase.sol
1270 
1271 contract DJTBase is Withdrawable, Pausable, ReentrancyGuard {
1272     using SafeMath for uint256;
1273 }
1274 
1275 // File: contracts/HeroGatewayV2.sol
1276 
1277 contract HeroGatewayV2 is OperatorRole, DJTBase {
1278 
1279   HeroAsset public heroAsset;
1280 
1281   event InComingEvent(
1282     address indexed locker,
1283     uint256 tokenId,
1284     uint256 at
1285   );
1286 
1287   event OutgoingEvent(
1288       address indexed assetOwner,
1289       uint256 tokenId,
1290       uint256 at,
1291       bytes32 indexed eventHash,
1292       uint8 eventType
1293   );
1294 
1295   uint public constant LIMIT = 10;
1296 
1297   mapping(bytes32 => bool) private isPastEvent;
1298 
1299   function transferAllTokensOfGateway(address _newAddress) external onlyOwner {
1300     uint256 balance = heroAsset.balanceOf(address(this));
1301 
1302     for (uint256 i=balance; i > 0; i--) {
1303       uint256 tokenId = heroAsset.tokenOfOwnerByIndex(address(this), i-1);
1304       _transferHeroAsset(address(this), _newAddress, tokenId);
1305     }
1306   }
1307 
1308   function setPastEventHash(bytes32 _eventHash, bool _desired) external onlyOperator {
1309     isPastEvent[_eventHash] = _desired;
1310   }
1311 
1312   function setHeroAssetAddress(address _heroAssetAddress) external onlyOwner {
1313     heroAsset = HeroAsset(_heroAssetAddress);
1314   }
1315 
1316   function depositHero(uint256 _tokenId) public whenNotPaused() {
1317     _transferHeroAsset(msg.sender, address(this), _tokenId);
1318     emit InComingEvent(msg.sender, _tokenId, block.timestamp);
1319   }
1320 
1321   function withdrawHeroToAssetOwnerByAdmin(address _assetOwner, uint256 _tokenId, bytes32 _eventHash) external onlyOperator {
1322     require(!checkIsPastEvent(_eventHash));
1323     _withdrawHero(_assetOwner, _tokenId, _eventHash);
1324     isPastEvent[_eventHash] = true;
1325   }
1326 
1327   function mintHero(address _assetOwner, uint256 _tokenId, bytes32 _eventHash) external onlyOperator {
1328     require(!checkIsPastEvent(_eventHash));
1329     _mintHero(_assetOwner, _tokenId, _eventHash);
1330     isPastEvent[_eventHash] = true;
1331   }
1332 
1333   function onERC721Received(
1334     address operator,
1335     address from,
1336     uint256 tokenId,
1337     bytes memory data
1338   )
1339   public
1340   returns(bytes4) { 
1341     return 0x150b7a02;
1342   }
1343 
1344   function checkIsPastEvent(bytes32 _eventHash) public view returns (bool) {
1345     return isPastEvent[_eventHash];
1346   }
1347   
1348   function _transferHeroAsset(address _from, address _to, uint256 _tokenId) private {
1349     heroAsset.safeTransferFrom(
1350       _from,
1351       _to,
1352       _tokenId
1353     );
1354   }
1355 
1356   function _withdrawHero(address _assetOwner, uint256 _tokenId, bytes32 _eventHash) private {
1357     _transferHeroAsset(address(this), _assetOwner, _tokenId);
1358     emit OutgoingEvent(_assetOwner, _tokenId, block.timestamp, _eventHash, 1);
1359   }
1360 
1361   function _mintHero(address _assetOwner, uint256 _tokenId, bytes32 _eventHash) private {
1362     heroAsset.mintHeroAsset(_assetOwner, _tokenId);
1363     emit OutgoingEvent(_assetOwner, _tokenId, block.timestamp, _eventHash, 0);
1364   }
1365 }