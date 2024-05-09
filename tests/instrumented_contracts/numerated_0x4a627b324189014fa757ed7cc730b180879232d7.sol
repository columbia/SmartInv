1 pragma solidity ^0.5.0;
2 
3 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/utils/ReentrancyGuard.sol
4 
5 /**
6  * @title Helps contracts guard against reentrancy attacks.
7  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
8  * @dev If you mark a function `nonReentrant`, you should also
9  * mark it `external`.
10  */
11 contract ReentrancyGuard {
12     /// @dev counter to allow mutex lock with only one SSTORE operation
13     uint256 private _guardCounter;
14 
15     constructor () internal {
16         // The counter starts at one to prevent changing it from zero to a non-zero
17         // value, which is a more expensive operation.
18         _guardCounter = 1;
19     }
20 
21     /**
22      * @dev Prevents a contract from calling itself, directly or indirectly.
23      * Calling a `nonReentrant` function from another `nonReentrant`
24      * function is not supported. It is possible to prevent this from happening
25      * by making the `nonReentrant` function external, and make it call a
26      * `private` function that does the actual work.
27      */
28     modifier nonReentrant() {
29         _guardCounter += 1;
30         uint256 localCounter = _guardCounter;
31         _;
32         require(localCounter == _guardCounter);
33     }
34 }
35 
36 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/math/SafeMath.sol
37 
38 /**
39  * @title SafeMath
40  * @dev Unsigned math operations with safety checks that revert on error
41  */
42 library SafeMath {
43     /**
44     * @dev Multiplies two unsigned integers, reverts on overflow.
45     */
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b);
56 
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
62     */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Solidity only automatically asserts when dividing by 0
65         require(b > 0);
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     /**
73     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b <= a);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83     * @dev Adds two unsigned integers, reverts on overflow.
84     */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a);
88 
89         return c;
90     }
91 
92     /**
93     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
94     * reverts when dividing by zero.
95     */
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b != 0);
98         return a % b;
99     }
100 }
101 
102 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/Roles.sol
103 
104 /**
105  * @title Roles
106  * @dev Library for managing addresses assigned to a Role.
107  */
108 library Roles {
109     struct Role {
110         mapping (address => bool) bearer;
111     }
112 
113     /**
114      * @dev give an account access to this role
115      */
116     function add(Role storage role, address account) internal {
117         require(account != address(0));
118         require(!has(role, account));
119 
120         role.bearer[account] = true;
121     }
122 
123     /**
124      * @dev remove an account's access to this role
125      */
126     function remove(Role storage role, address account) internal {
127         require(account != address(0));
128         require(has(role, account));
129 
130         role.bearer[account] = false;
131     }
132 
133     /**
134      * @dev check if an account has this role
135      * @return bool
136      */
137     function has(Role storage role, address account) internal view returns (bool) {
138         require(account != address(0));
139         return role.bearer[account];
140     }
141 }
142 
143 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/roles/PauserRole.sol
144 
145 contract PauserRole {
146     using Roles for Roles.Role;
147 
148     event PauserAdded(address indexed account);
149     event PauserRemoved(address indexed account);
150 
151     Roles.Role private _pausers;
152 
153     constructor () internal {
154         _addPauser(msg.sender);
155     }
156 
157     modifier onlyPauser() {
158         require(isPauser(msg.sender));
159         _;
160     }
161 
162     function isPauser(address account) public view returns (bool) {
163         return _pausers.has(account);
164     }
165 
166     function addPauser(address account) public onlyPauser {
167         _addPauser(account);
168     }
169 
170     function renouncePauser() public {
171         _removePauser(msg.sender);
172     }
173 
174     function _addPauser(address account) internal {
175         _pausers.add(account);
176         emit PauserAdded(account);
177     }
178 
179     function _removePauser(address account) internal {
180         _pausers.remove(account);
181         emit PauserRemoved(account);
182     }
183 }
184 
185 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/lifecycle/Pausable.sol
186 
187 /**
188  * @title Pausable
189  * @dev Base contract which allows children to implement an emergency stop mechanism.
190  */
191 contract Pausable is PauserRole {
192     event Paused(address account);
193     event Unpaused(address account);
194 
195     bool private _paused;
196 
197     constructor () internal {
198         _paused = false;
199     }
200 
201     /**
202      * @return true if the contract is paused, false otherwise.
203      */
204     function paused() public view returns (bool) {
205         return _paused;
206     }
207 
208     /**
209      * @dev Modifier to make a function callable only when the contract is not paused.
210      */
211     modifier whenNotPaused() {
212         require(!_paused);
213         _;
214     }
215 
216     /**
217      * @dev Modifier to make a function callable only when the contract is paused.
218      */
219     modifier whenPaused() {
220         require(_paused);
221         _;
222     }
223 
224     /**
225      * @dev called by the owner to pause, triggers stopped state
226      */
227     function pause() public onlyPauser whenNotPaused {
228         _paused = true;
229         emit Paused(msg.sender);
230     }
231 
232     /**
233      * @dev called by the owner to unpause, returns to normal state
234      */
235     function unpause() public onlyPauser whenPaused {
236         _paused = false;
237         emit Unpaused(msg.sender);
238     }
239 }
240 
241 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/ownership/Ownable.sol
242 
243 /**
244  * @title Ownable
245  * @dev The Ownable contract has an owner address, and provides basic authorization control
246  * functions, this simplifies the implementation of "user permissions".
247  */
248 contract Ownable {
249     address private _owner;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     /**
254      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
255      * account.
256      */
257     constructor () internal {
258         _owner = msg.sender;
259         emit OwnershipTransferred(address(0), _owner);
260     }
261 
262     /**
263      * @return the address of the owner.
264      */
265     function owner() public view returns (address) {
266         return _owner;
267     }
268 
269     /**
270      * @dev Throws if called by any account other than the owner.
271      */
272     modifier onlyOwner() {
273         require(isOwner());
274         _;
275     }
276 
277     /**
278      * @return true if `msg.sender` is the owner of the contract.
279      */
280     function isOwner() public view returns (bool) {
281         return msg.sender == _owner;
282     }
283 
284     /**
285      * @dev Allows the current owner to relinquish control of the contract.
286      * @notice Renouncing to ownership will leave the contract without an owner.
287      * It will not be possible to call the functions with the `onlyOwner`
288      * modifier anymore.
289      */
290     function renounceOwnership() public onlyOwner {
291         emit OwnershipTransferred(_owner, address(0));
292         _owner = address(0);
293     }
294 
295     /**
296      * @dev Allows the current owner to transfer control of the contract to a newOwner.
297      * @param newOwner The address to transfer ownership to.
298      */
299     function transferOwnership(address newOwner) public onlyOwner {
300         _transferOwnership(newOwner);
301     }
302 
303     /**
304      * @dev Transfers control of the contract to a newOwner.
305      * @param newOwner The address to transfer ownership to.
306      */
307     function _transferOwnership(address newOwner) internal {
308         require(newOwner != address(0));
309         emit OwnershipTransferred(_owner, newOwner);
310         _owner = newOwner;
311     }
312 }
313 
314 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/introspection/IERC165.sol
315 
316 /**
317  * @title IERC165
318  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
319  */
320 interface IERC165 {
321     /**
322      * @notice Query if a contract implements an interface
323      * @param interfaceId The interface identifier, as specified in ERC-165
324      * @dev Interface identification is specified in ERC-165. This function
325      * uses less than 30,000 gas.
326      */
327     function supportsInterface(bytes4 interfaceId) external view returns (bool);
328 }
329 
330 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721.sol
331 
332 /**
333  * @title ERC721 Non-Fungible Token Standard basic interface
334  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
335  */
336 contract IERC721 is IERC165 {
337     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
338     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
339     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
340 
341     function balanceOf(address owner) public view returns (uint256 balance);
342     function ownerOf(uint256 tokenId) public view returns (address owner);
343 
344     function approve(address to, uint256 tokenId) public;
345     function getApproved(uint256 tokenId) public view returns (address operator);
346 
347     function setApprovalForAll(address operator, bool _approved) public;
348     function isApprovedForAll(address owner, address operator) public view returns (bool);
349 
350     function transferFrom(address from, address to, uint256 tokenId) public;
351     function safeTransferFrom(address from, address to, uint256 tokenId) public;
352 
353     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
354 }
355 
356 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721Receiver.sol
357 
358 /**
359  * @title ERC721 token receiver interface
360  * @dev Interface for any contract that wants to support safeTransfers
361  * from ERC721 asset contracts.
362  */
363 contract IERC721Receiver {
364     /**
365      * @notice Handle the receipt of an NFT
366      * @dev The ERC721 smart contract calls this function on the recipient
367      * after a `safeTransfer`. This function MUST return the function selector,
368      * otherwise the caller will revert the transaction. The selector to be
369      * returned can be obtained as `this.onERC721Received.selector`. This
370      * function MAY throw to revert and reject the transfer.
371      * Note: the ERC721 contract address is always the message sender.
372      * @param operator The address which called `safeTransferFrom` function
373      * @param from The address which previously owned the token
374      * @param tokenId The NFT identifier which is being transferred
375      * @param data Additional data with no specified format
376      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
377      */
378     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
379     public returns (bytes4);
380 }
381 
382 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/utils/Address.sol
383 
384 /**
385  * Utility library of inline functions on addresses
386  */
387 library Address {
388     /**
389      * Returns whether the target address is a contract
390      * @dev This function will return false if invoked during the constructor of a contract,
391      * as the code is not actually created until after the constructor finishes.
392      * @param account address of the account to check
393      * @return whether the target address is a contract
394      */
395     function isContract(address account) internal view returns (bool) {
396         uint256 size;
397         // XXX Currently there is no better way to check if there is a contract in an address
398         // than to check the size of the code at that address.
399         // See https://ethereum.stackexchange.com/a/14016/36603
400         // for more details about how this works.
401         // TODO Check this again before the Serenity release, because all addresses will be
402         // contracts then.
403         // solhint-disable-next-line no-inline-assembly
404         assembly { size := extcodesize(account) }
405         return size > 0;
406     }
407 }
408 
409 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/introspection/ERC165.sol
410 
411 /**
412  * @title ERC165
413  * @author Matt Condon (@shrugs)
414  * @dev Implements ERC165 using a lookup table.
415  */
416 contract ERC165 is IERC165 {
417     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
418     /**
419      * 0x01ffc9a7 ===
420      *     bytes4(keccak256('supportsInterface(bytes4)'))
421      */
422 
423     /**
424      * @dev a mapping of interface id to whether or not it's supported
425      */
426     mapping(bytes4 => bool) private _supportedInterfaces;
427 
428     /**
429      * @dev A contract implementing SupportsInterfaceWithLookup
430      * implement ERC165 itself
431      */
432     constructor () internal {
433         _registerInterface(_INTERFACE_ID_ERC165);
434     }
435 
436     /**
437      * @dev implement supportsInterface(bytes4) using a lookup table
438      */
439     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
440         return _supportedInterfaces[interfaceId];
441     }
442 
443     /**
444      * @dev internal method for registering an interface
445      */
446     function _registerInterface(bytes4 interfaceId) internal {
447         require(interfaceId != 0xffffffff);
448         _supportedInterfaces[interfaceId] = true;
449     }
450 }
451 
452 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721.sol
453 
454 /**
455  * @title ERC721 Non-Fungible Token Standard basic implementation
456  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
457  */
458 contract ERC721 is ERC165, IERC721 {
459     using SafeMath for uint256;
460     using Address for address;
461 
462     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
463     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
464     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
465 
466     // Mapping from token ID to owner
467     mapping (uint256 => address) private _tokenOwner;
468 
469     // Mapping from token ID to approved address
470     mapping (uint256 => address) private _tokenApprovals;
471 
472     // Mapping from owner to number of owned token
473     mapping (address => uint256) private _ownedTokensCount;
474 
475     // Mapping from owner to operator approvals
476     mapping (address => mapping (address => bool)) private _operatorApprovals;
477 
478     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
479     /*
480      * 0x80ac58cd ===
481      *     bytes4(keccak256('balanceOf(address)')) ^
482      *     bytes4(keccak256('ownerOf(uint256)')) ^
483      *     bytes4(keccak256('approve(address,uint256)')) ^
484      *     bytes4(keccak256('getApproved(uint256)')) ^
485      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
486      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
487      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
488      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
489      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
490      */
491 
492     constructor () public {
493         // register the supported interfaces to conform to ERC721 via ERC165
494         _registerInterface(_INTERFACE_ID_ERC721);
495     }
496 
497     /**
498      * @dev Gets the balance of the specified address
499      * @param owner address to query the balance of
500      * @return uint256 representing the amount owned by the passed address
501      */
502     function balanceOf(address owner) public view returns (uint256) {
503         require(owner != address(0));
504         return _ownedTokensCount[owner];
505     }
506 
507     /**
508      * @dev Gets the owner of the specified token ID
509      * @param tokenId uint256 ID of the token to query the owner of
510      * @return owner address currently marked as the owner of the given token ID
511      */
512     function ownerOf(uint256 tokenId) public view returns (address) {
513         address owner = _tokenOwner[tokenId];
514         require(owner != address(0));
515         return owner;
516     }
517 
518     /**
519      * @dev Approves another address to transfer the given token ID
520      * The zero address indicates there is no approved address.
521      * There can only be one approved address per token at a given time.
522      * Can only be called by the token owner or an approved operator.
523      * @param to address to be approved for the given token ID
524      * @param tokenId uint256 ID of the token to be approved
525      */
526     function approve(address to, uint256 tokenId) public {
527         address owner = ownerOf(tokenId);
528         require(to != owner);
529         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
530 
531         _tokenApprovals[tokenId] = to;
532         emit Approval(owner, to, tokenId);
533     }
534 
535     /**
536      * @dev Gets the approved address for a token ID, or zero if no address set
537      * Reverts if the token ID does not exist.
538      * @param tokenId uint256 ID of the token to query the approval of
539      * @return address currently approved for the given token ID
540      */
541     function getApproved(uint256 tokenId) public view returns (address) {
542         require(_exists(tokenId));
543         return _tokenApprovals[tokenId];
544     }
545 
546     /**
547      * @dev Sets or unsets the approval of a given operator
548      * An operator is allowed to transfer all tokens of the sender on their behalf
549      * @param to operator address to set the approval
550      * @param approved representing the status of the approval to be set
551      */
552     function setApprovalForAll(address to, bool approved) public {
553         require(to != msg.sender);
554         _operatorApprovals[msg.sender][to] = approved;
555         emit ApprovalForAll(msg.sender, to, approved);
556     }
557 
558     /**
559      * @dev Tells whether an operator is approved by a given owner
560      * @param owner owner address which you want to query the approval of
561      * @param operator operator address which you want to query the approval of
562      * @return bool whether the given operator is approved by the given owner
563      */
564     function isApprovedForAll(address owner, address operator) public view returns (bool) {
565         return _operatorApprovals[owner][operator];
566     }
567 
568     /**
569      * @dev Transfers the ownership of a given token ID to another address
570      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
571      * Requires the msg sender to be the owner, approved, or operator
572      * @param from current owner of the token
573      * @param to address to receive the ownership of the given token ID
574      * @param tokenId uint256 ID of the token to be transferred
575     */
576     function transferFrom(address from, address to, uint256 tokenId) public {
577         require(_isApprovedOrOwner(msg.sender, tokenId));
578 
579         _transferFrom(from, to, tokenId);
580     }
581 
582     /**
583      * @dev Safely transfers the ownership of a given token ID to another address
584      * If the target address is a contract, it must implement `onERC721Received`,
585      * which is called upon a safe transfer, and return the magic value
586      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
587      * the transfer is reverted.
588      *
589      * Requires the msg sender to be the owner, approved, or operator
590      * @param from current owner of the token
591      * @param to address to receive the ownership of the given token ID
592      * @param tokenId uint256 ID of the token to be transferred
593     */
594     function safeTransferFrom(address from, address to, uint256 tokenId) public {
595         safeTransferFrom(from, to, tokenId, "");
596     }
597 
598     /**
599      * @dev Safely transfers the ownership of a given token ID to another address
600      * If the target address is a contract, it must implement `onERC721Received`,
601      * which is called upon a safe transfer, and return the magic value
602      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
603      * the transfer is reverted.
604      * Requires the msg sender to be the owner, approved, or operator
605      * @param from current owner of the token
606      * @param to address to receive the ownership of the given token ID
607      * @param tokenId uint256 ID of the token to be transferred
608      * @param _data bytes data to send along with a safe transfer check
609      */
610     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
611         transferFrom(from, to, tokenId);
612         require(_checkOnERC721Received(from, to, tokenId, _data));
613     }
614 
615     /**
616      * @dev Returns whether the specified token exists
617      * @param tokenId uint256 ID of the token to query the existence of
618      * @return whether the token exists
619      */
620     function _exists(uint256 tokenId) internal view returns (bool) {
621         address owner = _tokenOwner[tokenId];
622         return owner != address(0);
623     }
624 
625     /**
626      * @dev Returns whether the given spender can transfer a given token ID
627      * @param spender address of the spender to query
628      * @param tokenId uint256 ID of the token to be transferred
629      * @return bool whether the msg.sender is approved for the given token ID,
630      *    is an operator of the owner, or is the owner of the token
631      */
632     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
633         address owner = ownerOf(tokenId);
634         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
635     }
636 
637     /**
638      * @dev Internal function to mint a new token
639      * Reverts if the given token ID already exists
640      * @param to The address that will own the minted token
641      * @param tokenId uint256 ID of the token to be minted
642      */
643     function _mint(address to, uint256 tokenId) internal {
644         require(to != address(0));
645         require(!_exists(tokenId));
646 
647         _tokenOwner[tokenId] = to;
648         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
649 
650         emit Transfer(address(0), to, tokenId);
651     }
652 
653     /**
654      * @dev Internal function to burn a specific token
655      * Reverts if the token does not exist
656      * Deprecated, use _burn(uint256) instead.
657      * @param owner owner of the token to burn
658      * @param tokenId uint256 ID of the token being burned
659      */
660     function _burn(address owner, uint256 tokenId) internal {
661         require(ownerOf(tokenId) == owner);
662 
663         _clearApproval(tokenId);
664 
665         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
666         _tokenOwner[tokenId] = address(0);
667 
668         emit Transfer(owner, address(0), tokenId);
669     }
670 
671     /**
672      * @dev Internal function to burn a specific token
673      * Reverts if the token does not exist
674      * @param tokenId uint256 ID of the token being burned
675      */
676     function _burn(uint256 tokenId) internal {
677         _burn(ownerOf(tokenId), tokenId);
678     }
679 
680     /**
681      * @dev Internal function to transfer ownership of a given token ID to another address.
682      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
683      * @param from current owner of the token
684      * @param to address to receive the ownership of the given token ID
685      * @param tokenId uint256 ID of the token to be transferred
686     */
687     function _transferFrom(address from, address to, uint256 tokenId) internal {
688         require(ownerOf(tokenId) == from);
689         require(to != address(0));
690 
691         _clearApproval(tokenId);
692 
693         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
694         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
695 
696         _tokenOwner[tokenId] = to;
697 
698         emit Transfer(from, to, tokenId);
699     }
700 
701     /**
702      * @dev Internal function to invoke `onERC721Received` on a target address
703      * The call is not executed if the target address is not a contract
704      * @param from address representing the previous owner of the given token ID
705      * @param to target address that will receive the tokens
706      * @param tokenId uint256 ID of the token to be transferred
707      * @param _data bytes optional data to send along with the call
708      * @return whether the call correctly returned the expected magic value
709      */
710     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
711         internal returns (bool)
712     {
713         if (!to.isContract()) {
714             return true;
715         }
716 
717         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
718         return (retval == _ERC721_RECEIVED);
719     }
720 
721     /**
722      * @dev Private function to clear current approval of a given token ID
723      * @param tokenId uint256 ID of the token to be transferred
724      */
725     function _clearApproval(uint256 tokenId) private {
726         if (_tokenApprovals[tokenId] != address(0)) {
727             _tokenApprovals[tokenId] = address(0);
728         }
729     }
730 }
731 
732 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/roles/MinterRole.sol
733 
734 contract MinterRole {
735     using Roles for Roles.Role;
736 
737     event MinterAdded(address indexed account);
738     event MinterRemoved(address indexed account);
739 
740     Roles.Role private _minters;
741 
742     constructor () internal {
743         _addMinter(msg.sender);
744     }
745 
746     modifier onlyMinter() {
747         require(isMinter(msg.sender));
748         _;
749     }
750 
751     function isMinter(address account) public view returns (bool) {
752         return _minters.has(account);
753     }
754 
755     function addMinter(address account) public onlyMinter {
756         _addMinter(account);
757     }
758 
759     function renounceMinter() public {
760         _removeMinter(msg.sender);
761     }
762 
763     function _addMinter(address account) internal {
764         _minters.add(account);
765         emit MinterAdded(account);
766     }
767 
768     function _removeMinter(address account) internal {
769         _minters.remove(account);
770         emit MinterRemoved(account);
771     }
772 }
773 
774 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Mintable.sol
775 
776 /**
777  * @title ERC721Mintable
778  * @dev ERC721 minting logic
779  */
780 contract ERC721Mintable is ERC721, MinterRole {
781     /**
782      * @dev Function to mint tokens
783      * @param to The address that will receive the minted tokens.
784      * @param tokenId The token id to mint.
785      * @return A boolean that indicates if the operation was successful.
786      */
787     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
788         _mint(to, tokenId);
789         return true;
790     }
791 }
792 
793 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Pausable.sol
794 
795 /**
796  * @title ERC721 Non-Fungible Pausable token
797  * @dev ERC721 modified with pausable transfers.
798  **/
799 contract ERC721Pausable is ERC721, Pausable {
800     function approve(address to, uint256 tokenId) public whenNotPaused {
801         super.approve(to, tokenId);
802     }
803 
804     function setApprovalForAll(address to, bool approved) public whenNotPaused {
805         super.setApprovalForAll(to, approved);
806     }
807 
808     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
809         super.transferFrom(from, to, tokenId);
810     }
811 }
812 
813 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721Enumerable.sol
814 
815 /**
816  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
817  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
818  */
819 contract IERC721Enumerable is IERC721 {
820     function totalSupply() public view returns (uint256);
821     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
822 
823     function tokenByIndex(uint256 index) public view returns (uint256);
824 }
825 
826 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Enumerable.sol
827 
828 /**
829  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
830  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
831  */
832 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
833     // Mapping from owner to list of owned token IDs
834     mapping(address => uint256[]) private _ownedTokens;
835 
836     // Mapping from token ID to index of the owner tokens list
837     mapping(uint256 => uint256) private _ownedTokensIndex;
838 
839     // Array with all token ids, used for enumeration
840     uint256[] private _allTokens;
841 
842     // Mapping from token id to position in the allTokens array
843     mapping(uint256 => uint256) private _allTokensIndex;
844 
845     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
846     /**
847      * 0x780e9d63 ===
848      *     bytes4(keccak256('totalSupply()')) ^
849      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
850      *     bytes4(keccak256('tokenByIndex(uint256)'))
851      */
852 
853     /**
854      * @dev Constructor function
855      */
856     constructor () public {
857         // register the supported interface to conform to ERC721 via ERC165
858         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
859     }
860 
861     /**
862      * @dev Gets the token ID at a given index of the tokens list of the requested owner
863      * @param owner address owning the tokens list to be accessed
864      * @param index uint256 representing the index to be accessed of the requested tokens list
865      * @return uint256 token ID at the given index of the tokens list owned by the requested address
866      */
867     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
868         require(index < balanceOf(owner));
869         return _ownedTokens[owner][index];
870     }
871 
872     /**
873      * @dev Gets the total amount of tokens stored by the contract
874      * @return uint256 representing the total amount of tokens
875      */
876     function totalSupply() public view returns (uint256) {
877         return _allTokens.length;
878     }
879 
880     /**
881      * @dev Gets the token ID at a given index of all the tokens in this contract
882      * Reverts if the index is greater or equal to the total number of tokens
883      * @param index uint256 representing the index to be accessed of the tokens list
884      * @return uint256 token ID at the given index of the tokens list
885      */
886     function tokenByIndex(uint256 index) public view returns (uint256) {
887         require(index < totalSupply());
888         return _allTokens[index];
889     }
890 
891     /**
892      * @dev Internal function to transfer ownership of a given token ID to another address.
893      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
894      * @param from current owner of the token
895      * @param to address to receive the ownership of the given token ID
896      * @param tokenId uint256 ID of the token to be transferred
897     */
898     function _transferFrom(address from, address to, uint256 tokenId) internal {
899         super._transferFrom(from, to, tokenId);
900 
901         _removeTokenFromOwnerEnumeration(from, tokenId);
902 
903         _addTokenToOwnerEnumeration(to, tokenId);
904     }
905 
906     /**
907      * @dev Internal function to mint a new token
908      * Reverts if the given token ID already exists
909      * @param to address the beneficiary that will own the minted token
910      * @param tokenId uint256 ID of the token to be minted
911      */
912     function _mint(address to, uint256 tokenId) internal {
913         super._mint(to, tokenId);
914 
915         _addTokenToOwnerEnumeration(to, tokenId);
916 
917         _addTokenToAllTokensEnumeration(tokenId);
918     }
919 
920     /**
921      * @dev Internal function to burn a specific token
922      * Reverts if the token does not exist
923      * Deprecated, use _burn(uint256) instead
924      * @param owner owner of the token to burn
925      * @param tokenId uint256 ID of the token being burned
926      */
927     function _burn(address owner, uint256 tokenId) internal {
928         super._burn(owner, tokenId);
929 
930         _removeTokenFromOwnerEnumeration(owner, tokenId);
931         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
932         _ownedTokensIndex[tokenId] = 0;
933 
934         _removeTokenFromAllTokensEnumeration(tokenId);
935     }
936 
937     /**
938      * @dev Gets the list of token IDs of the requested owner
939      * @param owner address owning the tokens
940      * @return uint256[] List of token IDs owned by the requested address
941      */
942     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
943         return _ownedTokens[owner];
944     }
945 
946     /**
947      * @dev Private function to add a token to this extension's ownership-tracking data structures.
948      * @param to address representing the new owner of the given token ID
949      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
950      */
951     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
952         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
953         _ownedTokens[to].push(tokenId);
954     }
955 
956     /**
957      * @dev Private function to add a token to this extension's token tracking data structures.
958      * @param tokenId uint256 ID of the token to be added to the tokens list
959      */
960     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
961         _allTokensIndex[tokenId] = _allTokens.length;
962         _allTokens.push(tokenId);
963     }
964 
965     /**
966      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
967      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
968      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
969      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
970      * @param from address representing the previous owner of the given token ID
971      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
972      */
973     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
974         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
975         // then delete the last slot (swap and pop).
976 
977         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
978         uint256 tokenIndex = _ownedTokensIndex[tokenId];
979 
980         // When the token to delete is the last token, the swap operation is unnecessary
981         if (tokenIndex != lastTokenIndex) {
982             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
983 
984             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
985             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
986         }
987 
988         // This also deletes the contents at the last position of the array
989         _ownedTokens[from].length--;
990 
991         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
992         // lasTokenId, or just over the end of the array if the token was the last one).
993     }
994 
995     /**
996      * @dev Private function to remove a token from this extension's token tracking data structures.
997      * This has O(1) time complexity, but alters the order of the _allTokens array.
998      * @param tokenId uint256 ID of the token to be removed from the tokens list
999      */
1000     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1001         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1002         // then delete the last slot (swap and pop).
1003 
1004         uint256 lastTokenIndex = _allTokens.length.sub(1);
1005         uint256 tokenIndex = _allTokensIndex[tokenId];
1006 
1007         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1008         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1009         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1010         uint256 lastTokenId = _allTokens[lastTokenIndex];
1011 
1012         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1013         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1014 
1015         // This also deletes the contents at the last position of the array
1016         _allTokens.length--;
1017         _allTokensIndex[tokenId] = 0;
1018     }
1019 }
1020 
1021 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721Metadata.sol
1022 
1023 /**
1024  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1025  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1026  */
1027 contract IERC721Metadata is IERC721 {
1028     function name() external view returns (string memory);
1029     function symbol() external view returns (string memory);
1030     function tokenURI(uint256 tokenId) external view returns (string memory);
1031 }
1032 
1033 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Metadata.sol
1034 
1035 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
1036     // Token name
1037     string private _name;
1038 
1039     // Token symbol
1040     string private _symbol;
1041 
1042     // Optional mapping for token URIs
1043     mapping(uint256 => string) private _tokenURIs;
1044 
1045     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1046     /**
1047      * 0x5b5e139f ===
1048      *     bytes4(keccak256('name()')) ^
1049      *     bytes4(keccak256('symbol()')) ^
1050      *     bytes4(keccak256('tokenURI(uint256)'))
1051      */
1052 
1053     /**
1054      * @dev Constructor function
1055      */
1056     constructor (string memory name, string memory symbol) public {
1057         _name = name;
1058         _symbol = symbol;
1059 
1060         // register the supported interfaces to conform to ERC721 via ERC165
1061         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1062     }
1063 
1064     /**
1065      * @dev Gets the token name
1066      * @return string representing the token name
1067      */
1068     function name() external view returns (string memory) {
1069         return _name;
1070     }
1071 
1072     /**
1073      * @dev Gets the token symbol
1074      * @return string representing the token symbol
1075      */
1076     function symbol() external view returns (string memory) {
1077         return _symbol;
1078     }
1079 
1080     /**
1081      * @dev Returns an URI for a given token ID
1082      * Throws if the token ID does not exist. May return an empty string.
1083      * @param tokenId uint256 ID of the token to query
1084      */
1085     function tokenURI(uint256 tokenId) external view returns (string memory) {
1086         require(_exists(tokenId));
1087         return _tokenURIs[tokenId];
1088     }
1089 
1090     /**
1091      * @dev Internal function to set the token URI for a given token
1092      * Reverts if the token ID does not exist
1093      * @param tokenId uint256 ID of the token to set its URI
1094      * @param uri string URI to assign
1095      */
1096     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1097         require(_exists(tokenId));
1098         _tokenURIs[tokenId] = uri;
1099     }
1100 
1101     /**
1102      * @dev Internal function to burn a specific token
1103      * Reverts if the token does not exist
1104      * Deprecated, use _burn(uint256) instead
1105      * @param owner owner of the token to burn
1106      * @param tokenId uint256 ID of the token being burned by the msg.sender
1107      */
1108     function _burn(address owner, uint256 tokenId) internal {
1109         super._burn(owner, tokenId);
1110 
1111         // Clear metadata (if any)
1112         if (bytes(_tokenURIs[tokenId]).length != 0) {
1113             delete _tokenURIs[tokenId];
1114         }
1115     }
1116 }
1117 
1118 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721FUll.sol
1119 
1120 /**
1121  * @title Full ERC721 Token
1122  * This implementation includes all the required and some optional functionality of the ERC721 standard
1123  * Moreover, it includes approve all functionality using operator terminology
1124  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1125  */
1126 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1127     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1128         // solhint-disable-previous-line no-empty-blocks
1129     }
1130 }
1131 
1132 // File: contracts/LandSectorAsset.sol
1133 
1134 /* solhint-disable indent*/
1135 pragma solidity 0.5.4;
1136 
1137 
1138 
1139 
1140 
1141 contract LandSectorAsset is ERC721Full, ERC721Mintable, ERC721Pausable {
1142 
1143 
1144   uint256 public constant SHARE_RATE_DECIMAL = 10**18;
1145 
1146   uint16 public constant LEGENDARY_RARITY = 5;
1147   uint16 public constant EPIC_RARITY = 4;
1148   uint16 public constant RARE_RARITY = 3;
1149   uint16 public constant UNCOMMON_RARITY = 2;
1150   uint16 public constant COMMON_RARITY = 1;
1151 
1152   uint16 public constant NO_LAND = 0;
1153 
1154   string public tokenURIPrefix = "https://www.mycryptoheroes.net/metadata/land/";
1155 
1156   mapping(uint16 => uint256) private landTypeToTotalVolume;
1157   mapping(uint16 => uint256) private landTypeToSectorSupplyLimit;
1158   mapping(uint16 => mapping(uint16 => uint256)) private landTypeAndRarityToSectorSupply;
1159   mapping(uint16 => uint256[]) private landTypeToLandSectorList;
1160   mapping(uint16 => uint256) private landTypeToLandSectorIndex;
1161   mapping(uint16 => mapping(uint16 => uint256)) private landTypeAndRarityToLandSectorCount;
1162   mapping(uint16 => uint256) private rarityToSectorVolume;
1163 
1164   event MintEvent(
1165     address indexed assetOwner,
1166     uint256 tokenId,
1167     uint256 at,
1168     bytes32 indexed eventHash
1169   );
1170 
1171   constructor() public ERC721Full("MyCryptoHeroes:Land", "MCHL") {
1172     rarityToSectorVolume[5] = 100;
1173     rarityToSectorVolume[4] = 20;
1174     rarityToSectorVolume[3] = 5;
1175     rarityToSectorVolume[2] = 2;
1176     rarityToSectorVolume[1] = 1;
1177     landTypeToTotalVolume[NO_LAND] = 0;
1178   }
1179 
1180   function setSupplyAndSector(
1181     uint16 _landType,
1182     uint256 _totalVolume,
1183     uint256 _sectorSupplyLimit,
1184     uint256 legendarySupply,
1185     uint256 epicSupply,
1186     uint256 rareSupply,
1187     uint256 uncommonSupply,
1188     uint256 commonSupply
1189   ) external onlyMinter {
1190     require(_landType != 0, "landType 0 is noland");
1191     require(_totalVolume != 0, "totalVolume must not be 0");
1192     require(getMintedSectorCount(_landType) == 0, "This LandType already exists");
1193     require(
1194       legendarySupply.mul(rarityToSectorVolume[LEGENDARY_RARITY])
1195       .add(epicSupply.mul(rarityToSectorVolume[EPIC_RARITY]))
1196       .add(rareSupply.mul(rarityToSectorVolume[RARE_RARITY]))
1197       .add(uncommonSupply.mul(rarityToSectorVolume[UNCOMMON_RARITY]))
1198       .add(commonSupply.mul(rarityToSectorVolume[COMMON_RARITY]))
1199       == _totalVolume
1200     );
1201     require(
1202       legendarySupply
1203       .add(epicSupply)
1204       .add(rareSupply)
1205       .add(uncommonSupply)
1206       .add(commonSupply)
1207       == _sectorSupplyLimit
1208     );
1209     landTypeToTotalVolume[_landType] = _totalVolume;
1210     landTypeToSectorSupplyLimit[_landType] = _sectorSupplyLimit;
1211     landTypeAndRarityToSectorSupply[_landType][LEGENDARY_RARITY] = legendarySupply;
1212     landTypeAndRarityToSectorSupply[_landType][EPIC_RARITY] = epicSupply;
1213     landTypeAndRarityToSectorSupply[_landType][RARE_RARITY] = rareSupply;
1214     landTypeAndRarityToSectorSupply[_landType][UNCOMMON_RARITY] = uncommonSupply;
1215     landTypeAndRarityToSectorSupply[_landType][COMMON_RARITY] = commonSupply;
1216   }
1217 
1218   function setTokenURIPrefix(string calldata _tokenURIPrefix) external onlyMinter {
1219     tokenURIPrefix = _tokenURIPrefix;
1220   }
1221 
1222   function isAlreadyMinted(uint256 _tokenId) public view returns (bool) {
1223     return _exists(_tokenId);
1224   }
1225 
1226   function isValidLandSector(uint256 _tokenId) public view returns (bool) {
1227     uint16 rarity = getRarity(_tokenId);
1228     if (!(rarityToSectorVolume[rarity] > 0)) {
1229       return false;
1230     }
1231     uint16 landType = getLandType(_tokenId);
1232     if (!(landTypeToTotalVolume[landType] > 0)) {
1233       return false;
1234     }
1235     uint256 serial = _tokenId % 10000;
1236     if (serial > landTypeAndRarityToSectorSupply[landType][rarity]) {
1237       return false;
1238     }
1239     return true;
1240   }
1241 
1242   function getTotalVolume(uint16 _landType) public view returns (uint256) {
1243     return landTypeToTotalVolume[_landType];
1244   }
1245 
1246   function getSectorSupplyLimit(uint16 _landType) public view returns (uint256) {
1247     return landTypeToSectorSupplyLimit[_landType];
1248   }
1249 
1250   function getLandType(uint256 _landSector) public view returns (uint16) {
1251     uint16 _landType = uint16((_landSector.div(10000)) % 1000);
1252     return _landType;
1253   }
1254 
1255   function getRarity(uint256 _landSector) public view returns (uint16) {
1256     return uint16(_landSector.div(10**7));
1257   }
1258 
1259   function getMintedSectorCount(uint16 _landType) public view returns (uint256) {
1260     return landTypeToLandSectorIndex[_landType];
1261   }
1262 
1263   function getMintedSectorCountByRarity(uint16 _landType, uint16 _rarity) public view returns (uint256) {
1264     return landTypeAndRarityToLandSectorCount[_landType][_rarity];
1265   }
1266 
1267   function getSectorSupplyByRarity(uint16 _landType, uint16 _rarity) public view returns (uint256) {
1268     return landTypeAndRarityToSectorSupply[_landType][_rarity];
1269   }
1270 
1271   function getMintedSectorList(uint16 _landType) public view returns (uint256[] memory) {
1272     return landTypeToLandSectorList[_landType];
1273   }
1274 
1275   function getSectorVolumeByRarity(uint16 _rarity) public view returns (uint256) {
1276     return rarityToSectorVolume[_rarity];
1277   }
1278 
1279   function getShareRateWithDecimal(uint256 _landSector) public view returns (uint256, uint256) {
1280     return (
1281       getSectorVolumeByRarity(getRarity(_landSector))
1282         .mul(SHARE_RATE_DECIMAL)
1283         .div(getTotalVolume(getLandType(_landSector))),
1284       SHARE_RATE_DECIMAL
1285     );
1286   }
1287 
1288   function mintLandSector(address _owner, uint256 _landSector, bytes32 _eventHash) public onlyMinter {
1289     require(!isAlreadyMinted(_landSector));
1290     require(isValidLandSector(_landSector));
1291     uint16 _landType = getLandType(_landSector);
1292     require(landTypeToLandSectorIndex[_landType] < landTypeToSectorSupplyLimit[_landType]);
1293     uint16 rarity = getRarity(_landSector);
1294     require(landTypeAndRarityToLandSectorCount[_landType][rarity] < landTypeAndRarityToSectorSupply[_landType][rarity], "supply over");
1295     _mint(_owner, _landSector);
1296     landTypeToLandSectorList[_landType].push(_landSector);
1297     landTypeToLandSectorIndex[_landType]++;
1298     landTypeAndRarityToLandSectorCount[_landType][rarity]++;
1299 
1300     emit MintEvent(
1301       _owner,
1302       _landSector,
1303       block.timestamp,
1304       _eventHash
1305     );
1306   }
1307 
1308   function tokenURI(uint256 tokenId) public view returns (string memory) {
1309     bytes32 tokenIdBytes;
1310     if (tokenId == 0) {
1311       tokenIdBytes = "0";
1312     } else {
1313       uint256 value = tokenId;
1314       while (value > 0) {
1315         tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
1316         tokenIdBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
1317         value /= 10;
1318       }
1319     }
1320 
1321     bytes memory prefixBytes = bytes(tokenURIPrefix);
1322     bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
1323 
1324     uint8 i;
1325     uint8 index = 0;
1326 
1327     for (i = 0; i < prefixBytes.length; i++) {
1328       tokenURIBytes[index] = prefixBytes[i];
1329       index++;
1330     }
1331 
1332     for (i = 0; i < tokenIdBytes.length; i++) {
1333       tokenURIBytes[index] = tokenIdBytes[i];
1334       index++;
1335     }
1336 
1337     return string(tokenURIBytes);
1338   }
1339 }
1340 /* solhint-enable indent*/
1341 
1342 // File: contracts/MCHLandPool.sol
1343 
1344 /* solhint-disable indent*/
1345 pragma solidity 0.5.4;
1346 
1347 
1348 
1349 
1350 
1351 
1352 
1353 contract MCHLandPool is Ownable, Pausable, ReentrancyGuard {
1354   using SafeMath for uint256;
1355 
1356 
1357   LandSectorAsset public landSectorAsset;
1358 
1359   mapping(uint16 => uint256) private landTypeToTotalAmount;
1360   mapping(uint256 => uint256) private landSectorToWithdrawnAmount;
1361   mapping(address => bool) private allowedAddresses;
1362 
1363   event EthAddedToPool(
1364     uint16 indexed landType,
1365     address txSender,
1366     address indexed purchaseBy,
1367     uint256 value,
1368     uint256 at
1369   );
1370 
1371   event WithdrawEther(
1372     uint256 indexed landSector,
1373     address indexed lord,
1374     uint256 value,
1375     uint256 at
1376   );
1377 
1378   event AllowedAddressSet(
1379     address allowedAddress,
1380     bool allowedStatus
1381   );
1382 
1383   constructor(address _landSectorAssetAddress) public {
1384     landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
1385   }
1386 
1387   function setLandSectorAssetAddress(address _landSectorAssetAddress) external onlyOwner() {
1388     landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
1389   }
1390 
1391   function setAllowedAddress(address _address, bool desired) external onlyOwner() {
1392     allowedAddresses[_address] = desired;
1393     emit AllowedAddressSet(
1394       _address,
1395       desired
1396     );
1397   }
1398 
1399   function addEthToLandPool(uint16 _landType, address _purchaseBy) external payable whenNotPaused() nonReentrant() {
1400     require(landSectorAsset.getTotalVolume(_landType) > 0);
1401     require(allowedAddresses[msg.sender]);
1402     landTypeToTotalAmount[_landType] += msg.value;
1403 
1404     emit EthAddedToPool(
1405       _landType,
1406       msg.sender,
1407       _purchaseBy,
1408       msg.value,
1409       block.timestamp
1410     );
1411   }
1412 
1413   function withdrawMyAllRewards() external whenNotPaused() nonReentrant() {
1414     require(getWithdrawableBalance(msg.sender) > 0);
1415 
1416     uint256 withdrawValue;
1417     uint256 balance = landSectorAsset.balanceOf(msg.sender);
1418     
1419     for (uint256 i=balance; i > 0; i--) {
1420       uint256 landSector = landSectorAsset.tokenOfOwnerByIndex(msg.sender, i-1);
1421       uint256 tmpAmount = getLandSectorWithdrawableBalance(landSector);
1422       withdrawValue += tmpAmount;
1423       landSectorToWithdrawnAmount[landSector] += tmpAmount;
1424 
1425       emit WithdrawEther(
1426         landSector,
1427         msg.sender,
1428         tmpAmount,
1429         block.timestamp
1430       );
1431     }
1432     msg.sender.transfer(withdrawValue);
1433   }
1434 
1435   function withdrawMyReward(uint256 _landSector) external whenNotPaused() nonReentrant() {
1436     require(landSectorAsset.ownerOf(_landSector) == msg.sender);
1437     uint256 withdrawableAmount = getLandSectorWithdrawableBalance(_landSector);
1438     require(withdrawableAmount > 0);
1439 
1440     landSectorToWithdrawnAmount[_landSector] += withdrawableAmount;
1441     msg.sender.transfer(withdrawableAmount);
1442 
1443     emit WithdrawEther(
1444       _landSector,
1445       msg.sender,
1446       withdrawableAmount,
1447       block.timestamp
1448     );
1449   }
1450 
1451   function getAllowedAddress(address _address) public view returns (bool) {
1452     return allowedAddresses[_address];
1453   }
1454 
1455   function getTotalEthBackAmountPerLandType(uint16 _landType) public view returns (uint256) {
1456     return landTypeToTotalAmount[_landType];
1457   }
1458 
1459   function getLandSectorWithdrawnAmount(uint256 _landSector) public view returns (uint256) {
1460     return landSectorToWithdrawnAmount[_landSector];
1461   }
1462 
1463   function getLandSectorWithdrawableBalance(uint256 _landSector) public view returns (uint256) {
1464     require(landSectorAsset.isValidLandSector(_landSector));
1465     uint16 _landType = landSectorAsset.getLandType(_landSector);
1466     (uint256 shareRate, uint256 decimal) = landSectorAsset.getShareRateWithDecimal(_landSector);
1467     uint256 maxAmount = landTypeToTotalAmount[_landType]
1468       .mul(shareRate)
1469       .div(decimal);
1470     return maxAmount.sub(landSectorToWithdrawnAmount[_landSector]);
1471   }
1472 
1473   function getWithdrawableBalance(address _lordAddress) public view returns (uint256) {
1474     uint256 balance = landSectorAsset.balanceOf(_lordAddress);
1475     uint256 withdrawableAmount;
1476 
1477     for (uint256 i=balance; i > 0; i--) {
1478       uint256 landSector = landSectorAsset.tokenOfOwnerByIndex(_lordAddress, i-1);
1479       withdrawableAmount += getLandSectorWithdrawableBalance(landSector);
1480     }
1481 
1482     return withdrawableAmount;
1483   }
1484 }
1485 /* solhint-enable indent*/