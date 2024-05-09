1 pragma solidity ^0.5.2;
2 
3 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC20/IERC20.sol
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 interface IERC20 {
83     function transfer(address to, uint256 value) external returns (bool);
84 
85     function approve(address spender, uint256 value) external returns (bool);
86 
87     function transferFrom(address from, address to, uint256 value) external returns (bool);
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address who) external view returns (uint256);
92 
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 // File: contracts/lib/github.com/contract-library/contract-library-0.0.4/contracts/ownership/Withdrawable.sol
101 
102 contract Withdrawable is Ownable {
103   function withdrawEther() external onlyOwner {
104     msg.sender.transfer(address(this).balance);
105   }
106 
107   function withdrawToken(IERC20 _token) external onlyOwner {
108     require(_token.transfer(msg.sender, _token.balanceOf(address(this))));
109   }
110 }
111 
112 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/Roles.sol
113 
114 /**
115  * @title Roles
116  * @dev Library for managing addresses assigned to a Role.
117  */
118 library Roles {
119     struct Role {
120         mapping (address => bool) bearer;
121     }
122 
123     /**
124      * @dev give an account access to this role
125      */
126     function add(Role storage role, address account) internal {
127         require(account != address(0));
128         require(!has(role, account));
129 
130         role.bearer[account] = true;
131     }
132 
133     /**
134      * @dev remove an account's access to this role
135      */
136     function remove(Role storage role, address account) internal {
137         require(account != address(0));
138         require(has(role, account));
139 
140         role.bearer[account] = false;
141     }
142 
143     /**
144      * @dev check if an account has this role
145      * @return bool
146      */
147     function has(Role storage role, address account) internal view returns (bool) {
148         require(account != address(0));
149         return role.bearer[account];
150     }
151 }
152 
153 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/roles/PauserRole.sol
154 
155 contract PauserRole {
156     using Roles for Roles.Role;
157 
158     event PauserAdded(address indexed account);
159     event PauserRemoved(address indexed account);
160 
161     Roles.Role private _pausers;
162 
163     constructor () internal {
164         _addPauser(msg.sender);
165     }
166 
167     modifier onlyPauser() {
168         require(isPauser(msg.sender));
169         _;
170     }
171 
172     function isPauser(address account) public view returns (bool) {
173         return _pausers.has(account);
174     }
175 
176     function addPauser(address account) public onlyPauser {
177         _addPauser(account);
178     }
179 
180     function renouncePauser() public {
181         _removePauser(msg.sender);
182     }
183 
184     function _addPauser(address account) internal {
185         _pausers.add(account);
186         emit PauserAdded(account);
187     }
188 
189     function _removePauser(address account) internal {
190         _pausers.remove(account);
191         emit PauserRemoved(account);
192     }
193 }
194 
195 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/lifecycle/Pausable.sol
196 
197 /**
198  * @title Pausable
199  * @dev Base contract which allows children to implement an emergency stop mechanism.
200  */
201 contract Pausable is PauserRole {
202     event Paused(address account);
203     event Unpaused(address account);
204 
205     bool private _paused;
206 
207     constructor () internal {
208         _paused = false;
209     }
210 
211     /**
212      * @return true if the contract is paused, false otherwise.
213      */
214     function paused() public view returns (bool) {
215         return _paused;
216     }
217 
218     /**
219      * @dev Modifier to make a function callable only when the contract is not paused.
220      */
221     modifier whenNotPaused() {
222         require(!_paused);
223         _;
224     }
225 
226     /**
227      * @dev Modifier to make a function callable only when the contract is paused.
228      */
229     modifier whenPaused() {
230         require(_paused);
231         _;
232     }
233 
234     /**
235      * @dev called by the owner to pause, triggers stopped state
236      */
237     function pause() public onlyPauser whenNotPaused {
238         _paused = true;
239         emit Paused(msg.sender);
240     }
241 
242     /**
243      * @dev called by the owner to unpause, returns to normal state
244      */
245     function unpause() public onlyPauser whenPaused {
246         _paused = false;
247         emit Unpaused(msg.sender);
248     }
249 }
250 
251 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/math/SafeMath.sol
252 
253 /**
254  * @title SafeMath
255  * @dev Unsigned math operations with safety checks that revert on error
256  */
257 library SafeMath {
258     /**
259     * @dev Multiplies two unsigned integers, reverts on overflow.
260     */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b);
271 
272         return c;
273     }
274 
275     /**
276     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
277     */
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         // Solidity only automatically asserts when dividing by 0
280         require(b > 0);
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283 
284         return c;
285     }
286 
287     /**
288     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
289     */
290     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291         require(b <= a);
292         uint256 c = a - b;
293 
294         return c;
295     }
296 
297     /**
298     * @dev Adds two unsigned integers, reverts on overflow.
299     */
300     function add(uint256 a, uint256 b) internal pure returns (uint256) {
301         uint256 c = a + b;
302         require(c >= a);
303 
304         return c;
305     }
306 
307     /**
308     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
309     * reverts when dividing by zero.
310     */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         require(b != 0);
313         return a % b;
314     }
315 }
316 
317 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/utils/ReentrancyGuard.sol
318 
319 /**
320  * @title Helps contracts guard against reentrancy attacks.
321  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
322  * @dev If you mark a function `nonReentrant`, you should also
323  * mark it `external`.
324  */
325 contract ReentrancyGuard {
326     /// @dev counter to allow mutex lock with only one SSTORE operation
327     uint256 private _guardCounter;
328 
329     constructor () internal {
330         // The counter starts at one to prevent changing it from zero to a non-zero
331         // value, which is a more expensive operation.
332         _guardCounter = 1;
333     }
334 
335     /**
336      * @dev Prevents a contract from calling itself, directly or indirectly.
337      * Calling a `nonReentrant` function from another `nonReentrant`
338      * function is not supported. It is possible to prevent this from happening
339      * by making the `nonReentrant` function external, and make it call a
340      * `private` function that does the actual work.
341      */
342     modifier nonReentrant() {
343         _guardCounter += 1;
344         uint256 localCounter = _guardCounter;
345         _;
346         require(localCounter == _guardCounter);
347     }
348 }
349 
350 // File: contracts/lib/github.com/contract-library/contract-library-0.0.4/contracts/DJTBase.sol
351 
352 contract DJTBase is Withdrawable, Pausable, ReentrancyGuard {
353     using SafeMath for uint256;
354 }
355 
356 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/cryptography/ECDSA.sol
357 
358 /**
359  * @title Elliptic curve signature operations
360  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
361  * TODO Remove this library once solidity supports passing a signature to ecrecover.
362  * See https://github.com/ethereum/solidity/issues/864
363  */
364 
365 library ECDSA {
366     /**
367      * @dev Recover signer address from a message by using their signature
368      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
369      * @param signature bytes signature, the signature is generated using web3.eth.sign()
370      */
371     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
372         bytes32 r;
373         bytes32 s;
374         uint8 v;
375 
376         // Check the signature length
377         if (signature.length != 65) {
378             return (address(0));
379         }
380 
381         // Divide the signature in r, s and v variables
382         // ecrecover takes the signature parameters, and the only way to get them
383         // currently is to use assembly.
384         // solhint-disable-next-line no-inline-assembly
385         assembly {
386             r := mload(add(signature, 0x20))
387             s := mload(add(signature, 0x40))
388             v := byte(0, mload(add(signature, 0x60)))
389         }
390 
391         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
392         if (v < 27) {
393             v += 27;
394         }
395 
396         // If the version is correct return the signer address
397         if (v != 27 && v != 28) {
398             return (address(0));
399         } else {
400             return ecrecover(hash, v, r, s);
401         }
402     }
403 
404     /**
405      * toEthSignedMessageHash
406      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
407      * and hash the result
408      */
409     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
410         // 32 is the length in bytes of hash,
411         // enforced by the type signature above
412         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
413     }
414 }
415 
416 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/introspection/IERC165.sol
417 
418 /**
419  * @title IERC165
420  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
421  */
422 interface IERC165 {
423     /**
424      * @notice Query if a contract implements an interface
425      * @param interfaceId The interface identifier, as specified in ERC-165
426      * @dev Interface identification is specified in ERC-165. This function
427      * uses less than 30,000 gas.
428      */
429     function supportsInterface(bytes4 interfaceId) external view returns (bool);
430 }
431 
432 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721.sol
433 
434 /**
435  * @title ERC721 Non-Fungible Token Standard basic interface
436  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
437  */
438 contract IERC721 is IERC165 {
439     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
440     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
441     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
442 
443     function balanceOf(address owner) public view returns (uint256 balance);
444     function ownerOf(uint256 tokenId) public view returns (address owner);
445 
446     function approve(address to, uint256 tokenId) public;
447     function getApproved(uint256 tokenId) public view returns (address operator);
448 
449     function setApprovalForAll(address operator, bool _approved) public;
450     function isApprovedForAll(address owner, address operator) public view returns (bool);
451 
452     function transferFrom(address from, address to, uint256 tokenId) public;
453     function safeTransferFrom(address from, address to, uint256 tokenId) public;
454 
455     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
456 }
457 
458 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721Receiver.sol
459 
460 /**
461  * @title ERC721 token receiver interface
462  * @dev Interface for any contract that wants to support safeTransfers
463  * from ERC721 asset contracts.
464  */
465 contract IERC721Receiver {
466     /**
467      * @notice Handle the receipt of an NFT
468      * @dev The ERC721 smart contract calls this function on the recipient
469      * after a `safeTransfer`. This function MUST return the function selector,
470      * otherwise the caller will revert the transaction. The selector to be
471      * returned can be obtained as `this.onERC721Received.selector`. This
472      * function MAY throw to revert and reject the transfer.
473      * Note: the ERC721 contract address is always the message sender.
474      * @param operator The address which called `safeTransferFrom` function
475      * @param from The address which previously owned the token
476      * @param tokenId The NFT identifier which is being transferred
477      * @param data Additional data with no specified format
478      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
479      */
480     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
481     public returns (bytes4);
482 }
483 
484 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/utils/Address.sol
485 
486 /**
487  * Utility library of inline functions on addresses
488  */
489 library Address {
490     /**
491      * Returns whether the target address is a contract
492      * @dev This function will return false if invoked during the constructor of a contract,
493      * as the code is not actually created until after the constructor finishes.
494      * @param account address of the account to check
495      * @return whether the target address is a contract
496      */
497     function isContract(address account) internal view returns (bool) {
498         uint256 size;
499         // XXX Currently there is no better way to check if there is a contract in an address
500         // than to check the size of the code at that address.
501         // See https://ethereum.stackexchange.com/a/14016/36603
502         // for more details about how this works.
503         // TODO Check this again before the Serenity release, because all addresses will be
504         // contracts then.
505         // solhint-disable-next-line no-inline-assembly
506         assembly { size := extcodesize(account) }
507         return size > 0;
508     }
509 }
510 
511 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/introspection/ERC165.sol
512 
513 /**
514  * @title ERC165
515  * @author Matt Condon (@shrugs)
516  * @dev Implements ERC165 using a lookup table.
517  */
518 contract ERC165 is IERC165 {
519     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
520     /**
521      * 0x01ffc9a7 ===
522      *     bytes4(keccak256('supportsInterface(bytes4)'))
523      */
524 
525     /**
526      * @dev a mapping of interface id to whether or not it's supported
527      */
528     mapping(bytes4 => bool) private _supportedInterfaces;
529 
530     /**
531      * @dev A contract implementing SupportsInterfaceWithLookup
532      * implement ERC165 itself
533      */
534     constructor () internal {
535         _registerInterface(_INTERFACE_ID_ERC165);
536     }
537 
538     /**
539      * @dev implement supportsInterface(bytes4) using a lookup table
540      */
541     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
542         return _supportedInterfaces[interfaceId];
543     }
544 
545     /**
546      * @dev internal method for registering an interface
547      */
548     function _registerInterface(bytes4 interfaceId) internal {
549         require(interfaceId != 0xffffffff);
550         _supportedInterfaces[interfaceId] = true;
551     }
552 }
553 
554 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721.sol
555 
556 /**
557  * @title ERC721 Non-Fungible Token Standard basic implementation
558  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
559  */
560 contract ERC721 is ERC165, IERC721 {
561     using SafeMath for uint256;
562     using Address for address;
563 
564     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
565     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
566     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
567 
568     // Mapping from token ID to owner
569     mapping (uint256 => address) private _tokenOwner;
570 
571     // Mapping from token ID to approved address
572     mapping (uint256 => address) private _tokenApprovals;
573 
574     // Mapping from owner to number of owned token
575     mapping (address => uint256) private _ownedTokensCount;
576 
577     // Mapping from owner to operator approvals
578     mapping (address => mapping (address => bool)) private _operatorApprovals;
579 
580     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
581     /*
582      * 0x80ac58cd ===
583      *     bytes4(keccak256('balanceOf(address)')) ^
584      *     bytes4(keccak256('ownerOf(uint256)')) ^
585      *     bytes4(keccak256('approve(address,uint256)')) ^
586      *     bytes4(keccak256('getApproved(uint256)')) ^
587      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
588      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
589      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
590      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
591      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
592      */
593 
594     constructor () public {
595         // register the supported interfaces to conform to ERC721 via ERC165
596         _registerInterface(_INTERFACE_ID_ERC721);
597     }
598 
599     /**
600      * @dev Gets the balance of the specified address
601      * @param owner address to query the balance of
602      * @return uint256 representing the amount owned by the passed address
603      */
604     function balanceOf(address owner) public view returns (uint256) {
605         require(owner != address(0));
606         return _ownedTokensCount[owner];
607     }
608 
609     /**
610      * @dev Gets the owner of the specified token ID
611      * @param tokenId uint256 ID of the token to query the owner of
612      * @return owner address currently marked as the owner of the given token ID
613      */
614     function ownerOf(uint256 tokenId) public view returns (address) {
615         address owner = _tokenOwner[tokenId];
616         require(owner != address(0));
617         return owner;
618     }
619 
620     /**
621      * @dev Approves another address to transfer the given token ID
622      * The zero address indicates there is no approved address.
623      * There can only be one approved address per token at a given time.
624      * Can only be called by the token owner or an approved operator.
625      * @param to address to be approved for the given token ID
626      * @param tokenId uint256 ID of the token to be approved
627      */
628     function approve(address to, uint256 tokenId) public {
629         address owner = ownerOf(tokenId);
630         require(to != owner);
631         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
632 
633         _tokenApprovals[tokenId] = to;
634         emit Approval(owner, to, tokenId);
635     }
636 
637     /**
638      * @dev Gets the approved address for a token ID, or zero if no address set
639      * Reverts if the token ID does not exist.
640      * @param tokenId uint256 ID of the token to query the approval of
641      * @return address currently approved for the given token ID
642      */
643     function getApproved(uint256 tokenId) public view returns (address) {
644         require(_exists(tokenId));
645         return _tokenApprovals[tokenId];
646     }
647 
648     /**
649      * @dev Sets or unsets the approval of a given operator
650      * An operator is allowed to transfer all tokens of the sender on their behalf
651      * @param to operator address to set the approval
652      * @param approved representing the status of the approval to be set
653      */
654     function setApprovalForAll(address to, bool approved) public {
655         require(to != msg.sender);
656         _operatorApprovals[msg.sender][to] = approved;
657         emit ApprovalForAll(msg.sender, to, approved);
658     }
659 
660     /**
661      * @dev Tells whether an operator is approved by a given owner
662      * @param owner owner address which you want to query the approval of
663      * @param operator operator address which you want to query the approval of
664      * @return bool whether the given operator is approved by the given owner
665      */
666     function isApprovedForAll(address owner, address operator) public view returns (bool) {
667         return _operatorApprovals[owner][operator];
668     }
669 
670     /**
671      * @dev Transfers the ownership of a given token ID to another address
672      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
673      * Requires the msg sender to be the owner, approved, or operator
674      * @param from current owner of the token
675      * @param to address to receive the ownership of the given token ID
676      * @param tokenId uint256 ID of the token to be transferred
677     */
678     function transferFrom(address from, address to, uint256 tokenId) public {
679         require(_isApprovedOrOwner(msg.sender, tokenId));
680 
681         _transferFrom(from, to, tokenId);
682     }
683 
684     /**
685      * @dev Safely transfers the ownership of a given token ID to another address
686      * If the target address is a contract, it must implement `onERC721Received`,
687      * which is called upon a safe transfer, and return the magic value
688      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
689      * the transfer is reverted.
690      *
691      * Requires the msg sender to be the owner, approved, or operator
692      * @param from current owner of the token
693      * @param to address to receive the ownership of the given token ID
694      * @param tokenId uint256 ID of the token to be transferred
695     */
696     function safeTransferFrom(address from, address to, uint256 tokenId) public {
697         safeTransferFrom(from, to, tokenId, "");
698     }
699 
700     /**
701      * @dev Safely transfers the ownership of a given token ID to another address
702      * If the target address is a contract, it must implement `onERC721Received`,
703      * which is called upon a safe transfer, and return the magic value
704      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
705      * the transfer is reverted.
706      * Requires the msg sender to be the owner, approved, or operator
707      * @param from current owner of the token
708      * @param to address to receive the ownership of the given token ID
709      * @param tokenId uint256 ID of the token to be transferred
710      * @param _data bytes data to send along with a safe transfer check
711      */
712     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
713         transferFrom(from, to, tokenId);
714         require(_checkOnERC721Received(from, to, tokenId, _data));
715     }
716 
717     /**
718      * @dev Returns whether the specified token exists
719      * @param tokenId uint256 ID of the token to query the existence of
720      * @return whether the token exists
721      */
722     function _exists(uint256 tokenId) internal view returns (bool) {
723         address owner = _tokenOwner[tokenId];
724         return owner != address(0);
725     }
726 
727     /**
728      * @dev Returns whether the given spender can transfer a given token ID
729      * @param spender address of the spender to query
730      * @param tokenId uint256 ID of the token to be transferred
731      * @return bool whether the msg.sender is approved for the given token ID,
732      *    is an operator of the owner, or is the owner of the token
733      */
734     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
735         address owner = ownerOf(tokenId);
736         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
737     }
738 
739     /**
740      * @dev Internal function to mint a new token
741      * Reverts if the given token ID already exists
742      * @param to The address that will own the minted token
743      * @param tokenId uint256 ID of the token to be minted
744      */
745     function _mint(address to, uint256 tokenId) internal {
746         require(to != address(0));
747         require(!_exists(tokenId));
748 
749         _tokenOwner[tokenId] = to;
750         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
751 
752         emit Transfer(address(0), to, tokenId);
753     }
754 
755     /**
756      * @dev Internal function to burn a specific token
757      * Reverts if the token does not exist
758      * Deprecated, use _burn(uint256) instead.
759      * @param owner owner of the token to burn
760      * @param tokenId uint256 ID of the token being burned
761      */
762     function _burn(address owner, uint256 tokenId) internal {
763         require(ownerOf(tokenId) == owner);
764 
765         _clearApproval(tokenId);
766 
767         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
768         _tokenOwner[tokenId] = address(0);
769 
770         emit Transfer(owner, address(0), tokenId);
771     }
772 
773     /**
774      * @dev Internal function to burn a specific token
775      * Reverts if the token does not exist
776      * @param tokenId uint256 ID of the token being burned
777      */
778     function _burn(uint256 tokenId) internal {
779         _burn(ownerOf(tokenId), tokenId);
780     }
781 
782     /**
783      * @dev Internal function to transfer ownership of a given token ID to another address.
784      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
785      * @param from current owner of the token
786      * @param to address to receive the ownership of the given token ID
787      * @param tokenId uint256 ID of the token to be transferred
788     */
789     function _transferFrom(address from, address to, uint256 tokenId) internal {
790         require(ownerOf(tokenId) == from);
791         require(to != address(0));
792 
793         _clearApproval(tokenId);
794 
795         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
796         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
797 
798         _tokenOwner[tokenId] = to;
799 
800         emit Transfer(from, to, tokenId);
801     }
802 
803     /**
804      * @dev Internal function to invoke `onERC721Received` on a target address
805      * The call is not executed if the target address is not a contract
806      * @param from address representing the previous owner of the given token ID
807      * @param to target address that will receive the tokens
808      * @param tokenId uint256 ID of the token to be transferred
809      * @param _data bytes optional data to send along with the call
810      * @return whether the call correctly returned the expected magic value
811      */
812     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
813         internal returns (bool)
814     {
815         if (!to.isContract()) {
816             return true;
817         }
818 
819         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
820         return (retval == _ERC721_RECEIVED);
821     }
822 
823     /**
824      * @dev Private function to clear current approval of a given token ID
825      * @param tokenId uint256 ID of the token to be transferred
826      */
827     function _clearApproval(uint256 tokenId) private {
828         if (_tokenApprovals[tokenId] != address(0)) {
829             _tokenApprovals[tokenId] = address(0);
830         }
831     }
832 }
833 
834 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/access/roles/MinterRole.sol
835 
836 contract MinterRole {
837     using Roles for Roles.Role;
838 
839     event MinterAdded(address indexed account);
840     event MinterRemoved(address indexed account);
841 
842     Roles.Role private _minters;
843 
844     constructor () internal {
845         _addMinter(msg.sender);
846     }
847 
848     modifier onlyMinter() {
849         require(isMinter(msg.sender));
850         _;
851     }
852 
853     function isMinter(address account) public view returns (bool) {
854         return _minters.has(account);
855     }
856 
857     function addMinter(address account) public onlyMinter {
858         _addMinter(account);
859     }
860 
861     function renounceMinter() public {
862         _removeMinter(msg.sender);
863     }
864 
865     function _addMinter(address account) internal {
866         _minters.add(account);
867         emit MinterAdded(account);
868     }
869 
870     function _removeMinter(address account) internal {
871         _minters.remove(account);
872         emit MinterRemoved(account);
873     }
874 }
875 
876 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Mintable.sol
877 
878 /**
879  * @title ERC721Mintable
880  * @dev ERC721 minting logic
881  */
882 contract ERC721Mintable is ERC721, MinterRole {
883     /**
884      * @dev Function to mint tokens
885      * @param to The address that will receive the minted tokens.
886      * @param tokenId The token id to mint.
887      * @return A boolean that indicates if the operation was successful.
888      */
889     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
890         _mint(to, tokenId);
891         return true;
892     }
893 }
894 
895 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Pausable.sol
896 
897 /**
898  * @title ERC721 Non-Fungible Pausable token
899  * @dev ERC721 modified with pausable transfers.
900  **/
901 contract ERC721Pausable is ERC721, Pausable {
902     function approve(address to, uint256 tokenId) public whenNotPaused {
903         super.approve(to, tokenId);
904     }
905 
906     function setApprovalForAll(address to, bool approved) public whenNotPaused {
907         super.setApprovalForAll(to, approved);
908     }
909 
910     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
911         super.transferFrom(from, to, tokenId);
912     }
913 }
914 
915 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721Enumerable.sol
916 
917 /**
918  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
919  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
920  */
921 contract IERC721Enumerable is IERC721 {
922     function totalSupply() public view returns (uint256);
923     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
924 
925     function tokenByIndex(uint256 index) public view returns (uint256);
926 }
927 
928 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Enumerable.sol
929 
930 /**
931  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
932  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
933  */
934 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
935     // Mapping from owner to list of owned token IDs
936     mapping(address => uint256[]) private _ownedTokens;
937 
938     // Mapping from token ID to index of the owner tokens list
939     mapping(uint256 => uint256) private _ownedTokensIndex;
940 
941     // Array with all token ids, used for enumeration
942     uint256[] private _allTokens;
943 
944     // Mapping from token id to position in the allTokens array
945     mapping(uint256 => uint256) private _allTokensIndex;
946 
947     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
948     /**
949      * 0x780e9d63 ===
950      *     bytes4(keccak256('totalSupply()')) ^
951      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
952      *     bytes4(keccak256('tokenByIndex(uint256)'))
953      */
954 
955     /**
956      * @dev Constructor function
957      */
958     constructor () public {
959         // register the supported interface to conform to ERC721 via ERC165
960         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
961     }
962 
963     /**
964      * @dev Gets the token ID at a given index of the tokens list of the requested owner
965      * @param owner address owning the tokens list to be accessed
966      * @param index uint256 representing the index to be accessed of the requested tokens list
967      * @return uint256 token ID at the given index of the tokens list owned by the requested address
968      */
969     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
970         require(index < balanceOf(owner));
971         return _ownedTokens[owner][index];
972     }
973 
974     /**
975      * @dev Gets the total amount of tokens stored by the contract
976      * @return uint256 representing the total amount of tokens
977      */
978     function totalSupply() public view returns (uint256) {
979         return _allTokens.length;
980     }
981 
982     /**
983      * @dev Gets the token ID at a given index of all the tokens in this contract
984      * Reverts if the index is greater or equal to the total number of tokens
985      * @param index uint256 representing the index to be accessed of the tokens list
986      * @return uint256 token ID at the given index of the tokens list
987      */
988     function tokenByIndex(uint256 index) public view returns (uint256) {
989         require(index < totalSupply());
990         return _allTokens[index];
991     }
992 
993     /**
994      * @dev Internal function to transfer ownership of a given token ID to another address.
995      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
996      * @param from current owner of the token
997      * @param to address to receive the ownership of the given token ID
998      * @param tokenId uint256 ID of the token to be transferred
999     */
1000     function _transferFrom(address from, address to, uint256 tokenId) internal {
1001         super._transferFrom(from, to, tokenId);
1002 
1003         _removeTokenFromOwnerEnumeration(from, tokenId);
1004 
1005         _addTokenToOwnerEnumeration(to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev Internal function to mint a new token
1010      * Reverts if the given token ID already exists
1011      * @param to address the beneficiary that will own the minted token
1012      * @param tokenId uint256 ID of the token to be minted
1013      */
1014     function _mint(address to, uint256 tokenId) internal {
1015         super._mint(to, tokenId);
1016 
1017         _addTokenToOwnerEnumeration(to, tokenId);
1018 
1019         _addTokenToAllTokensEnumeration(tokenId);
1020     }
1021 
1022     /**
1023      * @dev Internal function to burn a specific token
1024      * Reverts if the token does not exist
1025      * Deprecated, use _burn(uint256) instead
1026      * @param owner owner of the token to burn
1027      * @param tokenId uint256 ID of the token being burned
1028      */
1029     function _burn(address owner, uint256 tokenId) internal {
1030         super._burn(owner, tokenId);
1031 
1032         _removeTokenFromOwnerEnumeration(owner, tokenId);
1033         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1034         _ownedTokensIndex[tokenId] = 0;
1035 
1036         _removeTokenFromAllTokensEnumeration(tokenId);
1037     }
1038 
1039     /**
1040      * @dev Gets the list of token IDs of the requested owner
1041      * @param owner address owning the tokens
1042      * @return uint256[] List of token IDs owned by the requested address
1043      */
1044     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1045         return _ownedTokens[owner];
1046     }
1047 
1048     /**
1049      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1050      * @param to address representing the new owner of the given token ID
1051      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1052      */
1053     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1054         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1055         _ownedTokens[to].push(tokenId);
1056     }
1057 
1058     /**
1059      * @dev Private function to add a token to this extension's token tracking data structures.
1060      * @param tokenId uint256 ID of the token to be added to the tokens list
1061      */
1062     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1063         _allTokensIndex[tokenId] = _allTokens.length;
1064         _allTokens.push(tokenId);
1065     }
1066 
1067     /**
1068      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1069      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
1070      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1071      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1072      * @param from address representing the previous owner of the given token ID
1073      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1074      */
1075     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1076         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1077         // then delete the last slot (swap and pop).
1078 
1079         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1080         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1081 
1082         // When the token to delete is the last token, the swap operation is unnecessary
1083         if (tokenIndex != lastTokenIndex) {
1084             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1085 
1086             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1087             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1088         }
1089 
1090         // This also deletes the contents at the last position of the array
1091         _ownedTokens[from].length--;
1092 
1093         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
1094         // lasTokenId, or just over the end of the array if the token was the last one).
1095     }
1096 
1097     /**
1098      * @dev Private function to remove a token from this extension's token tracking data structures.
1099      * This has O(1) time complexity, but alters the order of the _allTokens array.
1100      * @param tokenId uint256 ID of the token to be removed from the tokens list
1101      */
1102     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1103         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1104         // then delete the last slot (swap and pop).
1105 
1106         uint256 lastTokenIndex = _allTokens.length.sub(1);
1107         uint256 tokenIndex = _allTokensIndex[tokenId];
1108 
1109         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1110         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1111         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1112         uint256 lastTokenId = _allTokens[lastTokenIndex];
1113 
1114         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1115         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1116 
1117         // This also deletes the contents at the last position of the array
1118         _allTokens.length--;
1119         _allTokensIndex[tokenId] = 0;
1120     }
1121 }
1122 
1123 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/IERC721Metadata.sol
1124 
1125 /**
1126  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1127  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1128  */
1129 contract IERC721Metadata is IERC721 {
1130     function name() external view returns (string memory);
1131     function symbol() external view returns (string memory);
1132     function tokenURI(uint256 tokenId) external view returns (string memory);
1133 }
1134 
1135 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721Metadata.sol
1136 
1137 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
1138     // Token name
1139     string private _name;
1140 
1141     // Token symbol
1142     string private _symbol;
1143 
1144     // Optional mapping for token URIs
1145     mapping(uint256 => string) private _tokenURIs;
1146 
1147     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1148     /**
1149      * 0x5b5e139f ===
1150      *     bytes4(keccak256('name()')) ^
1151      *     bytes4(keccak256('symbol()')) ^
1152      *     bytes4(keccak256('tokenURI(uint256)'))
1153      */
1154 
1155     /**
1156      * @dev Constructor function
1157      */
1158     constructor (string memory name, string memory symbol) public {
1159         _name = name;
1160         _symbol = symbol;
1161 
1162         // register the supported interfaces to conform to ERC721 via ERC165
1163         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1164     }
1165 
1166     /**
1167      * @dev Gets the token name
1168      * @return string representing the token name
1169      */
1170     function name() external view returns (string memory) {
1171         return _name;
1172     }
1173 
1174     /**
1175      * @dev Gets the token symbol
1176      * @return string representing the token symbol
1177      */
1178     function symbol() external view returns (string memory) {
1179         return _symbol;
1180     }
1181 
1182     /**
1183      * @dev Returns an URI for a given token ID
1184      * Throws if the token ID does not exist. May return an empty string.
1185      * @param tokenId uint256 ID of the token to query
1186      */
1187     function tokenURI(uint256 tokenId) external view returns (string memory) {
1188         require(_exists(tokenId));
1189         return _tokenURIs[tokenId];
1190     }
1191 
1192     /**
1193      * @dev Internal function to set the token URI for a given token
1194      * Reverts if the token ID does not exist
1195      * @param tokenId uint256 ID of the token to set its URI
1196      * @param uri string URI to assign
1197      */
1198     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1199         require(_exists(tokenId));
1200         _tokenURIs[tokenId] = uri;
1201     }
1202 
1203     /**
1204      * @dev Internal function to burn a specific token
1205      * Reverts if the token does not exist
1206      * Deprecated, use _burn(uint256) instead
1207      * @param owner owner of the token to burn
1208      * @param tokenId uint256 ID of the token being burned by the msg.sender
1209      */
1210     function _burn(address owner, uint256 tokenId) internal {
1211         super._burn(owner, tokenId);
1212 
1213         // Clear metadata (if any)
1214         if (bytes(_tokenURIs[tokenId]).length != 0) {
1215             delete _tokenURIs[tokenId];
1216         }
1217     }
1218 }
1219 
1220 // File: contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.2/contracts/token/ERC721/ERC721FUll.sol
1221 
1222 /**
1223  * @title Full ERC721 Token
1224  * This implementation includes all the required and some optional functionality of the ERC721 standard
1225  * Moreover, it includes approve all functionality using operator terminology
1226  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1227  */
1228 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1229     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1230         // solhint-disable-previous-line no-empty-blocks
1231     }
1232 }
1233 
1234 // File: contracts/LandSectorAsset.sol
1235 
1236 /* solhint-disable indent*/
1237 pragma solidity 0.5.4;
1238 
1239 
1240 
1241 
1242 
1243 contract LandSectorAsset is ERC721Full, ERC721Mintable, ERC721Pausable {
1244 
1245 
1246   uint256 public constant SHARE_RATE_DECIMAL = 10**18;
1247 
1248   uint16 public constant LEGENDARY_RARITY = 5;
1249   uint16 public constant EPIC_RARITY = 4;
1250   uint16 public constant RARE_RARITY = 3;
1251   uint16 public constant UNCOMMON_RARITY = 2;
1252   uint16 public constant COMMON_RARITY = 1;
1253 
1254   uint16 public constant NO_LAND = 0;
1255 
1256   string public tokenURIPrefix = "https://www.mycryptoheroes.net/metadata/land/";
1257 
1258   mapping(uint16 => uint256) private landTypeToTotalVolume;
1259   mapping(uint16 => uint256) private landTypeToSectorSupplyLimit;
1260   mapping(uint16 => mapping(uint16 => uint256)) private landTypeAndRarityToSectorSupply;
1261   mapping(uint16 => uint256[]) private landTypeToLandSectorList;
1262   mapping(uint16 => uint256) private landTypeToLandSectorIndex;
1263   mapping(uint16 => mapping(uint16 => uint256)) private landTypeAndRarityToLandSectorCount;
1264   mapping(uint16 => uint256) private rarityToSectorVolume;
1265 
1266   event MintEvent(
1267     address indexed assetOwner,
1268     uint256 tokenId,
1269     uint256 at,
1270     bytes32 indexed eventHash
1271   );
1272 
1273   constructor() public ERC721Full("MyCryptoHeroes:Land", "MCHL") {
1274     rarityToSectorVolume[5] = 100;
1275     rarityToSectorVolume[4] = 20;
1276     rarityToSectorVolume[3] = 5;
1277     rarityToSectorVolume[2] = 2;
1278     rarityToSectorVolume[1] = 1;
1279     landTypeToTotalVolume[NO_LAND] = 0;
1280   }
1281 
1282   function setSupplyAndSector(
1283     uint16 _landType,
1284     uint256 _totalVolume,
1285     uint256 _sectorSupplyLimit,
1286     uint256 legendarySupply,
1287     uint256 epicSupply,
1288     uint256 rareSupply,
1289     uint256 uncommonSupply,
1290     uint256 commonSupply
1291   ) external onlyMinter {
1292     require(_landType != 0, "landType 0 is noland");
1293     require(_totalVolume != 0, "totalVolume must not be 0");
1294     require(getMintedSectorCount(_landType) == 0, "This LandType already exists");
1295     require(
1296       legendarySupply.mul(rarityToSectorVolume[LEGENDARY_RARITY])
1297       .add(epicSupply.mul(rarityToSectorVolume[EPIC_RARITY]))
1298       .add(rareSupply.mul(rarityToSectorVolume[RARE_RARITY]))
1299       .add(uncommonSupply.mul(rarityToSectorVolume[UNCOMMON_RARITY]))
1300       .add(commonSupply.mul(rarityToSectorVolume[COMMON_RARITY]))
1301       == _totalVolume
1302     );
1303     require(
1304       legendarySupply
1305       .add(epicSupply)
1306       .add(rareSupply)
1307       .add(uncommonSupply)
1308       .add(commonSupply)
1309       == _sectorSupplyLimit
1310     );
1311     landTypeToTotalVolume[_landType] = _totalVolume;
1312     landTypeToSectorSupplyLimit[_landType] = _sectorSupplyLimit;
1313     landTypeAndRarityToSectorSupply[_landType][LEGENDARY_RARITY] = legendarySupply;
1314     landTypeAndRarityToSectorSupply[_landType][EPIC_RARITY] = epicSupply;
1315     landTypeAndRarityToSectorSupply[_landType][RARE_RARITY] = rareSupply;
1316     landTypeAndRarityToSectorSupply[_landType][UNCOMMON_RARITY] = uncommonSupply;
1317     landTypeAndRarityToSectorSupply[_landType][COMMON_RARITY] = commonSupply;
1318   }
1319 
1320   function setTokenURIPrefix(string calldata _tokenURIPrefix) external onlyMinter {
1321     tokenURIPrefix = _tokenURIPrefix;
1322   }
1323 
1324   function isAlreadyMinted(uint256 _tokenId) public view returns (bool) {
1325     return _exists(_tokenId);
1326   }
1327 
1328   function isValidLandSector(uint256 _tokenId) public view returns (bool) {
1329     uint16 rarity = getRarity(_tokenId);
1330     if (!(rarityToSectorVolume[rarity] > 0)) {
1331       return false;
1332     }
1333     uint16 landType = getLandType(_tokenId);
1334     if (!(landTypeToTotalVolume[landType] > 0)) {
1335       return false;
1336     }
1337     uint256 serial = _tokenId % 10000;
1338     if (serial > landTypeAndRarityToSectorSupply[landType][rarity]) {
1339       return false;
1340     }
1341     return true;
1342   }
1343 
1344   function getTotalVolume(uint16 _landType) public view returns (uint256) {
1345     return landTypeToTotalVolume[_landType];
1346   }
1347 
1348   function getSectorSupplyLimit(uint16 _landType) public view returns (uint256) {
1349     return landTypeToSectorSupplyLimit[_landType];
1350   }
1351 
1352   function getLandType(uint256 _landSector) public view returns (uint16) {
1353     uint16 _landType = uint16((_landSector.div(10000)) % 1000);
1354     return _landType;
1355   }
1356 
1357   function getRarity(uint256 _landSector) public view returns (uint16) {
1358     return uint16(_landSector.div(10**7));
1359   }
1360 
1361   function getMintedSectorCount(uint16 _landType) public view returns (uint256) {
1362     return landTypeToLandSectorIndex[_landType];
1363   }
1364 
1365   function getMintedSectorCountByRarity(uint16 _landType, uint16 _rarity) public view returns (uint256) {
1366     return landTypeAndRarityToLandSectorCount[_landType][_rarity];
1367   }
1368 
1369   function getSectorSupplyByRarity(uint16 _landType, uint16 _rarity) public view returns (uint256) {
1370     return landTypeAndRarityToSectorSupply[_landType][_rarity];
1371   }
1372 
1373   function getMintedSectorList(uint16 _landType) public view returns (uint256[] memory) {
1374     return landTypeToLandSectorList[_landType];
1375   }
1376 
1377   function getSectorVolumeByRarity(uint16 _rarity) public view returns (uint256) {
1378     return rarityToSectorVolume[_rarity];
1379   }
1380 
1381   function getShareRateWithDecimal(uint256 _landSector) public view returns (uint256, uint256) {
1382     return (
1383       getSectorVolumeByRarity(getRarity(_landSector))
1384         .mul(SHARE_RATE_DECIMAL)
1385         .div(getTotalVolume(getLandType(_landSector))),
1386       SHARE_RATE_DECIMAL
1387     );
1388   }
1389 
1390   function mintLandSector(address _owner, uint256 _landSector, bytes32 _eventHash) public onlyMinter {
1391     require(!isAlreadyMinted(_landSector));
1392     require(isValidLandSector(_landSector));
1393     uint16 _landType = getLandType(_landSector);
1394     require(landTypeToLandSectorIndex[_landType] < landTypeToSectorSupplyLimit[_landType]);
1395     uint16 rarity = getRarity(_landSector);
1396     require(landTypeAndRarityToLandSectorCount[_landType][rarity] < landTypeAndRarityToSectorSupply[_landType][rarity], "supply over");
1397     _mint(_owner, _landSector);
1398     landTypeToLandSectorList[_landType].push(_landSector);
1399     landTypeToLandSectorIndex[_landType]++;
1400     landTypeAndRarityToLandSectorCount[_landType][rarity]++;
1401 
1402     emit MintEvent(
1403       _owner,
1404       _landSector,
1405       block.timestamp,
1406       _eventHash
1407     );
1408   }
1409 
1410   function tokenURI(uint256 tokenId) public view returns (string memory) {
1411     bytes32 tokenIdBytes;
1412     if (tokenId == 0) {
1413       tokenIdBytes = "0";
1414     } else {
1415       uint256 value = tokenId;
1416       while (value > 0) {
1417         tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
1418         tokenIdBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
1419         value /= 10;
1420       }
1421     }
1422 
1423     bytes memory prefixBytes = bytes(tokenURIPrefix);
1424     bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
1425 
1426     uint8 i;
1427     uint8 index = 0;
1428 
1429     for (i = 0; i < prefixBytes.length; i++) {
1430       tokenURIBytes[index] = prefixBytes[i];
1431       index++;
1432     }
1433 
1434     for (i = 0; i < tokenIdBytes.length; i++) {
1435       tokenURIBytes[index] = tokenIdBytes[i];
1436       index++;
1437     }
1438 
1439     return string(tokenURIBytes);
1440   }
1441 }
1442 /* solhint-enable indent*/
1443 
1444 // File: contracts/MCHLandPool.sol
1445 
1446 /* solhint-disable indent*/
1447 pragma solidity 0.5.4;
1448 
1449 
1450 
1451 
1452 
1453 
1454 
1455 contract MCHLandPool is Ownable, Pausable, ReentrancyGuard {
1456   using SafeMath for uint256;
1457 
1458 
1459   LandSectorAsset public landSectorAsset;
1460 
1461   mapping(uint16 => uint256) private landTypeToTotalAmount;
1462   mapping(uint256 => uint256) private landSectorToWithdrawnAmount;
1463   mapping(address => bool) private allowedAddresses;
1464 
1465   event EthAddedToPool(
1466     uint16 indexed landType,
1467     address txSender,
1468     address indexed purchaseBy,
1469     uint256 value,
1470     uint256 at
1471   );
1472 
1473   event WithdrawEther(
1474     uint256 indexed landSector,
1475     address indexed lord,
1476     uint256 value,
1477     uint256 at
1478   );
1479 
1480   event AllowedAddressSet(
1481     address allowedAddress,
1482     bool allowedStatus
1483   );
1484 
1485   constructor(address _landSectorAssetAddress) public {
1486     landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
1487   }
1488 
1489   function setLandSectorAssetAddress(address _landSectorAssetAddress) external onlyOwner() {
1490     landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
1491   }
1492 
1493   function setAllowedAddress(address _address, bool desired) external onlyOwner() {
1494     allowedAddresses[_address] = desired;
1495     emit AllowedAddressSet(
1496       _address,
1497       desired
1498     );
1499   }
1500 
1501   function addEthToLandPool(uint16 _landType, address _purchaseBy) external payable whenNotPaused() nonReentrant() {
1502     require(landSectorAsset.getTotalVolume(_landType) > 0);
1503     require(allowedAddresses[msg.sender]);
1504     landTypeToTotalAmount[_landType] += msg.value;
1505 
1506     emit EthAddedToPool(
1507       _landType,
1508       msg.sender,
1509       _purchaseBy,
1510       msg.value,
1511       block.timestamp
1512     );
1513   }
1514 
1515   function withdrawMyAllRewards() external whenNotPaused() nonReentrant() {
1516     require(getWithdrawableBalance(msg.sender) > 0);
1517 
1518     uint256 withdrawValue;
1519     uint256 balance = landSectorAsset.balanceOf(msg.sender);
1520     
1521     for (uint256 i=balance; i > 0; i--) {
1522       uint256 landSector = landSectorAsset.tokenOfOwnerByIndex(msg.sender, i-1);
1523       uint256 tmpAmount = getLandSectorWithdrawableBalance(landSector);
1524       withdrawValue += tmpAmount;
1525       landSectorToWithdrawnAmount[landSector] += tmpAmount;
1526 
1527       emit WithdrawEther(
1528         landSector,
1529         msg.sender,
1530         tmpAmount,
1531         block.timestamp
1532       );
1533     }
1534     msg.sender.transfer(withdrawValue);
1535   }
1536 
1537   function withdrawMyReward(uint256 _landSector) external whenNotPaused() nonReentrant() {
1538     require(landSectorAsset.ownerOf(_landSector) == msg.sender);
1539     uint256 withdrawableAmount = getLandSectorWithdrawableBalance(_landSector);
1540     require(withdrawableAmount > 0);
1541 
1542     landSectorToWithdrawnAmount[_landSector] += withdrawableAmount;
1543     msg.sender.transfer(withdrawableAmount);
1544 
1545     emit WithdrawEther(
1546       _landSector,
1547       msg.sender,
1548       withdrawableAmount,
1549       block.timestamp
1550     );
1551   }
1552 
1553   function getAllowedAddress(address _address) public view returns (bool) {
1554     return allowedAddresses[_address];
1555   }
1556 
1557   function getTotalEthBackAmountPerLandType(uint16 _landType) public view returns (uint256) {
1558     return landTypeToTotalAmount[_landType];
1559   }
1560 
1561   function getLandSectorWithdrawnAmount(uint256 _landSector) public view returns (uint256) {
1562     return landSectorToWithdrawnAmount[_landSector];
1563   }
1564 
1565   function getLandSectorWithdrawableBalance(uint256 _landSector) public view returns (uint256) {
1566     require(landSectorAsset.isValidLandSector(_landSector));
1567     uint16 _landType = landSectorAsset.getLandType(_landSector);
1568     (uint256 shareRate, uint256 decimal) = landSectorAsset.getShareRateWithDecimal(_landSector);
1569     uint256 maxAmount = landTypeToTotalAmount[_landType]
1570       .mul(shareRate)
1571       .div(decimal);
1572     return maxAmount.sub(landSectorToWithdrawnAmount[_landSector]);
1573   }
1574 
1575   function getWithdrawableBalance(address _lordAddress) public view returns (uint256) {
1576     uint256 balance = landSectorAsset.balanceOf(_lordAddress);
1577     uint256 withdrawableAmount;
1578 
1579     for (uint256 i=balance; i > 0; i--) {
1580       uint256 landSector = landSectorAsset.tokenOfOwnerByIndex(_lordAddress, i-1);
1581       withdrawableAmount += getLandSectorWithdrawableBalance(landSector);
1582     }
1583 
1584     return withdrawableAmount;
1585   }
1586 }
1587 /* solhint-enable indent*/
1588 
1589 // File: contracts/access/roles/OperatorRole.sol
1590 
1591 contract OperatorRole is Ownable {
1592     using Roles for Roles.Role;
1593 
1594     event OperatorAdded(address indexed account);
1595     event OperatorRemoved(address indexed account);
1596 
1597     Roles.Role private operators;
1598 
1599     constructor() public {
1600         operators.add(msg.sender);
1601     }
1602 
1603     modifier onlyOperator() {
1604         require(isOperator(msg.sender));
1605         _;
1606     }
1607     
1608     function isOperator(address account) public view returns (bool) {
1609         return operators.has(account);
1610     }
1611 
1612     function addOperator(address account) public onlyOwner() {
1613         operators.add(account);
1614         emit OperatorAdded(account);
1615     }
1616 
1617     function removeOperator(address account) public onlyOwner() {
1618         operators.remove(account);
1619         emit OperatorRemoved(account);
1620     }
1621 
1622 }
1623 
1624 // File: contracts/Referrers.sol
1625 
1626 contract Referrers is OperatorRole {
1627   using Roles for Roles.Role;
1628 
1629   event ReferrerAdded(address indexed account);
1630   event ReferrerRemoved(address indexed account);
1631 
1632   Roles.Role private referrers;
1633 
1634   uint32 internal index;
1635   uint16 public constant limit = 10;
1636   mapping(uint32 => address) internal indexToAddress;
1637   mapping(address => uint32) internal addressToIndex;
1638 
1639   modifier onlyReferrer() {
1640     require(isReferrer(msg.sender));
1641     _;
1642   }
1643 
1644   function getNumberOfAddresses() public view onlyOperator() returns (uint32) {
1645     return index;
1646   }
1647 
1648   function addressOfIndex(uint32 _index) onlyOperator() public view returns (address) {
1649     return indexToAddress[_index];
1650   }
1651   
1652   function isReferrer(address _account) public view returns (bool) {
1653     return referrers.has(_account);
1654   }
1655 
1656   function addReferrer(address _account) public onlyOperator() {
1657     referrers.add(_account);
1658     indexToAddress[index] = _account;
1659     addressToIndex[_account] = index;
1660     index++;
1661     emit ReferrerAdded(_account);
1662   }
1663 
1664   function addReferrers(address[limit] memory accounts) public onlyOperator() {
1665     for (uint16 i=0; i<limit; i++) {
1666       if (accounts[i] != address(0x0)) {
1667         addReferrer(accounts[i]);
1668       }
1669     }
1670   }
1671 
1672   function removeReferrer(address _account) public onlyOperator() {
1673     referrers.remove(_account);
1674     indexToAddress[addressToIndex[_account]] = address(0x0);
1675     emit ReferrerRemoved(_account);
1676   }
1677 }
1678 
1679 // File: contracts/MCHGUMGatewayV6.sol
1680 
1681 /* solhint-disable indent*/
1682 
1683 pragma solidity ^0.5.2;
1684 
1685 
1686 
1687 
1688 
1689 
1690 
1691 contract MCHGUMGatewayV6 is DJTBase {
1692 
1693   LandSectorAsset public landSectorAsset;
1694   MCHLandPool public landPool;
1695   Referrers public referrers;
1696   address public validater;
1697   bool public isInGUMUpTerm;
1698 
1699   uint256 public landPercentage;
1700   uint256 internal referralPercentage;
1701 
1702   mapping(uint256 => bool) private payableOption;
1703 
1704   // Define purchaseType
1705   // enum PurchaseType {
1706   //   PURCHASE_NORMAL = 0;
1707   //   PURCHASE_ETH_BACK = 1;
1708   //   PURCHASE_GUM_UP = 1;
1709   // }
1710   uint8 public purchaseTypeNormal = 0;
1711   // uint8 public purchaseTypeETHBack = 1;
1712   uint8 public purchaseTypeGUMUP;
1713   // uint8 public purchaseTypeRegular = 3;
1714 
1715   event LandPercentageUpdated(
1716     uint256 landPercentage
1717   );
1718 
1719   event Sold(
1720     address indexed user,
1721     address indexed referrer,
1722     uint8 purchaseType,
1723     uint256 grossValue,
1724     uint256 referralValue,
1725     uint256 landValue,
1726     uint256 netValue,
1727     uint256 indexed landType,
1728     uint256 at
1729   );
1730 
1731   event GUMUpTermUpdated(
1732     bool isInGUMUpTerm
1733   );
1734 
1735   event PurchaseTypeGUMUPUpdated(
1736     uint8 purchaseTypeGUMUP
1737   );
1738 
1739   constructor(
1740     address _validater,
1741     address _referrersAddress
1742   ) public {
1743     validater = _validater;
1744     referrers = Referrers(_referrersAddress);
1745     landPercentage = 30;
1746     referralPercentage = 20;
1747     purchaseTypeGUMUP = 2;
1748     payableOption[0.05 ether] = true;
1749     payableOption[0.1 ether] = true;
1750     payableOption[0.5 ether] = true;
1751     payableOption[1 ether] = true;
1752     payableOption[5 ether] = true;
1753     payableOption[10 ether] = true;
1754   }
1755 
1756   function setLandSectorAssetAddress(address _landSectorAssetAddress) external onlyOwner() {
1757     landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
1758   }
1759 
1760   function setLandPoolAddress(address payable _landPoolAddress) external onlyOwner() {
1761     landPool = MCHLandPool(_landPoolAddress);
1762   }
1763 
1764   function setValidater(address _varidater) external onlyOwner() {
1765     validater = _varidater;
1766   }
1767 
1768   function updateLandPercentage(uint256 _newLandPercentage) external onlyOwner() {
1769     landPercentage = _newLandPercentage;
1770     emit LandPercentageUpdated(
1771       landPercentage
1772     );
1773   }
1774 
1775   function setReferrersContractAddress(address _referrersAddress) external onlyOwner() {
1776     referrers = Referrers(_referrersAddress);
1777   }
1778 
1779   function setPurchaseTypeGUMUP(uint8 _newNum) external onlyOwner() {
1780     require(_newNum != 0 || _newNum != 1 || _newNum != 3);
1781     purchaseTypeGUMUP = _newNum;
1782     emit PurchaseTypeGUMUPUpdated(
1783       purchaseTypeGUMUP
1784     );
1785   }
1786 
1787   function setGUMUpTerm(bool _desired) external onlyOwner() {
1788     isInGUMUpTerm = _desired;
1789     emit GUMUpTermUpdated(
1790       isInGUMUpTerm
1791     );
1792   }
1793 
1794   function updateReferralPercentage(uint256 _newReferralPercentage) external onlyOwner() {
1795     referralPercentage = _newReferralPercentage;
1796   }
1797 
1798   function setPayableOption(uint256 _option, bool desired) external onlyOwner() {
1799     payableOption[_option] = desired;
1800   }
1801 
1802   function buyGUM(uint16 _landType, address payable _referrer, bytes calldata _signature) external payable whenNotPaused() nonReentrant() {
1803     require(payableOption[msg.value]);
1804     require(validateSig(_signature, _landType), "invalid signature");
1805 
1806     // Refarrer check
1807     address payable referrer;
1808     if (_referrer == msg.sender) {
1809       referrer = address(0x0);
1810     } else {
1811       referrer = _referrer;
1812     }
1813 
1814     uint256 netValue = msg.value;
1815     uint256 referralValue;
1816     uint256 landValue;
1817     if ((_referrer != address(0x0)) && referrers.isReferrer(_referrer)) {
1818       referralValue = msg.value.mul(referralPercentage).div(100);
1819       netValue = netValue.sub(referralValue);
1820       _referrer.transfer(referralValue);
1821     }
1822 
1823     if (landSectorAsset.getTotalVolume(_landType) != 0) {
1824       landValue = msg.value.mul(landPercentage).div(100);
1825       netValue = netValue.sub(landValue);
1826       landPool.addEthToLandPool.value(landValue)(_landType, msg.sender);
1827     }
1828 
1829     uint8 purchaseType;
1830     purchaseType = purchaseTypeNormal;
1831     if (isInGUMUpTerm) {
1832       purchaseType = purchaseTypeGUMUP;
1833     }
1834 
1835     emit Sold(
1836       msg.sender,
1837       referrer,
1838       purchaseType,
1839       msg.value,
1840       referralValue,
1841       landValue,
1842       netValue,
1843       _landType,
1844       block.timestamp
1845     );
1846   }
1847 
1848   function getPayableOption(uint256 _option) public view returns (bool) {
1849     return payableOption[_option];
1850   }
1851 
1852   function validateSig(bytes memory _signature, uint16 _landType) private view returns (bool) {
1853     require(validater != address(0));
1854     uint256 _message = uint256(msg.sender) + uint256(_landType);
1855     address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(bytes32(_message)), _signature);
1856     return (signer == validater);
1857   }
1858 }
1859 /* solhint-enable indent*/