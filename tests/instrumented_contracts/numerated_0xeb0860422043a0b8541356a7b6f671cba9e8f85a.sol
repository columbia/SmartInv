1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-19
3 */
4 
5 /* solhint-disable indent*/
6 // produced by the Solididy File Flattener (c) David Appleton 2018
7 // contact : dave@akomba.com
8 // released under Apache 2.0 licence
9 // input  /Users/rmanzoku/src/github.com/doublejumptokyo/mch-land-contract/contracts/MCHGUMGatewayV8.sol
10 // flattened :  Wednesday, 19-Jun-19 06:54:11 UTC
11 library ECDSA {
12     /**
13      * @dev Recover signer address from a message by using their signature
14      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
15      * @param signature bytes signature, the signature is generated using web3.eth.sign()
16      */
17     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
18         bytes32 r;
19         bytes32 s;
20         uint8 v;
21 
22         // Check the signature length
23         if (signature.length != 65) {
24             return (address(0));
25         }
26 
27         // Divide the signature in r, s and v variables
28         // ecrecover takes the signature parameters, and the only way to get them
29         // currently is to use assembly.
30         // solhint-disable-next-line no-inline-assembly
31         assembly {
32             r := mload(add(signature, 0x20))
33             s := mload(add(signature, 0x40))
34             v := byte(0, mload(add(signature, 0x60)))
35         }
36 
37         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
38         if (v < 27) {
39             v += 27;
40         }
41 
42         // If the version is correct return the signer address
43         if (v != 27 && v != 28) {
44             return (address(0));
45         } else {
46             return ecrecover(hash, v, r, s);
47         }
48     }
49 
50     /**
51      * toEthSignedMessageHash
52      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
53      * and hash the result
54      */
55     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
56         // 32 is the length in bytes of hash,
57         // enforced by the type signature above
58         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
59     }
60 }
61 
62 library Roles {
63     struct Role {
64         mapping (address => bool) bearer;
65     }
66 
67     /**
68      * @dev give an account access to this role
69      */
70     function add(Role storage role, address account) internal {
71         require(account != address(0));
72         require(!has(role, account));
73 
74         role.bearer[account] = true;
75     }
76 
77     /**
78      * @dev remove an account's access to this role
79      */
80     function remove(Role storage role, address account) internal {
81         require(account != address(0));
82         require(has(role, account));
83 
84         role.bearer[account] = false;
85     }
86 
87     /**
88      * @dev check if an account has this role
89      * @return bool
90      */
91     function has(Role storage role, address account) internal view returns (bool) {
92         require(account != address(0));
93         return role.bearer[account];
94     }
95 }
96 
97 library Address {
98     /**
99      * Returns whether the target address is a contract
100      * @dev This function will return false if invoked during the constructor of a contract,
101      * as the code is not actually created until after the constructor finishes.
102      * @param account address of the account to check
103      * @return whether the target address is a contract
104      */
105     function isContract(address account) internal view returns (bool) {
106         uint256 size;
107         // XXX Currently there is no better way to check if there is a contract in an address
108         // than to check the size of the code at that address.
109         // See https://ethereum.stackexchange.com/a/14016/36603
110         // for more details about how this works.
111         // TODO Check this again before the Serenity release, because all addresses will be
112         // contracts then.
113         // solhint-disable-next-line no-inline-assembly
114         assembly { size := extcodesize(account) }
115         return size > 0;
116     }
117 }
118 
119 contract IERC721Receiver {
120     /**
121      * @notice Handle the receipt of an NFT
122      * @dev The ERC721 smart contract calls this function on the recipient
123      * after a `safeTransfer`. This function MUST return the function selector,
124      * otherwise the caller will revert the transaction. The selector to be
125      * returned can be obtained as `this.onERC721Received.selector`. This
126      * function MAY throw to revert and reject the transfer.
127      * Note: the ERC721 contract address is always the message sender.
128      * @param operator The address which called `safeTransferFrom` function
129      * @param from The address which previously owned the token
130      * @param tokenId The NFT identifier which is being transferred
131      * @param data Additional data with no specified format
132      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
133      */
134     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
135     public returns (bytes4);
136 }
137 
138 interface IERC165 {
139     /**
140      * @notice Query if a contract implements an interface
141      * @param interfaceId The interface identifier, as specified in ERC-165
142      * @dev Interface identification is specified in ERC-165. This function
143      * uses less than 30,000 gas.
144      */
145     function supportsInterface(bytes4 interfaceId) external view returns (bool);
146 }
147 
148 library SafeMath {
149     /**
150     * @dev Multiplies two unsigned integers, reverts on overflow.
151     */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b);
162 
163         return c;
164     }
165 
166     /**
167     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
168     */
169     function div(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Solidity only automatically asserts when dividing by 0
171         require(b > 0);
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174 
175         return c;
176     }
177 
178     /**
179     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
180     */
181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182         require(b <= a);
183         uint256 c = a - b;
184 
185         return c;
186     }
187 
188     /**
189     * @dev Adds two unsigned integers, reverts on overflow.
190     */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         uint256 c = a + b;
193         require(c >= a);
194 
195         return c;
196     }
197 
198     /**
199     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
200     * reverts when dividing by zero.
201     */
202     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b != 0);
204         return a % b;
205     }
206 }
207 
208 contract Ownable {
209     address private _owner;
210 
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213     /**
214      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
215      * account.
216      */
217     constructor () internal {
218         _owner = msg.sender;
219         emit OwnershipTransferred(address(0), _owner);
220     }
221 
222     /**
223      * @return the address of the owner.
224      */
225     function owner() public view returns (address) {
226         return _owner;
227     }
228 
229     /**
230      * @dev Throws if called by any account other than the owner.
231      */
232     modifier onlyOwner() {
233         require(isOwner());
234         _;
235     }
236 
237     /**
238      * @return true if `msg.sender` is the owner of the contract.
239      */
240     function isOwner() public view returns (bool) {
241         return msg.sender == _owner;
242     }
243 
244     /**
245      * @dev Allows the current owner to relinquish control of the contract.
246      * @notice Renouncing to ownership will leave the contract without an owner.
247      * It will not be possible to call the functions with the `onlyOwner`
248      * modifier anymore.
249      */
250     function renounceOwnership() public onlyOwner {
251         emit OwnershipTransferred(_owner, address(0));
252         _owner = address(0);
253     }
254 
255     /**
256      * @dev Allows the current owner to transfer control of the contract to a newOwner.
257      * @param newOwner The address to transfer ownership to.
258      */
259     function transferOwnership(address newOwner) public onlyOwner {
260         _transferOwnership(newOwner);
261     }
262 
263     /**
264      * @dev Transfers control of the contract to a newOwner.
265      * @param newOwner The address to transfer ownership to.
266      */
267     function _transferOwnership(address newOwner) internal {
268         require(newOwner != address(0));
269         emit OwnershipTransferred(_owner, newOwner);
270         _owner = newOwner;
271     }
272 }
273 
274 interface IERC20 {
275     function transfer(address to, uint256 value) external returns (bool);
276 
277     function approve(address spender, uint256 value) external returns (bool);
278 
279     function transferFrom(address from, address to, uint256 value) external returns (bool);
280 
281     function totalSupply() external view returns (uint256);
282 
283     function balanceOf(address who) external view returns (uint256);
284 
285     function allowance(address owner, address spender) external view returns (uint256);
286 
287     event Transfer(address indexed from, address indexed to, uint256 value);
288 
289     event Approval(address indexed owner, address indexed spender, uint256 value);
290 }
291 
292 contract ReentrancyGuard {
293     /// @dev counter to allow mutex lock with only one SSTORE operation
294     uint256 private _guardCounter;
295 
296     constructor () internal {
297         // The counter starts at one to prevent changing it from zero to a non-zero
298         // value, which is a more expensive operation.
299         _guardCounter = 1;
300     }
301 
302     /**
303      * @dev Prevents a contract from calling itself, directly or indirectly.
304      * Calling a `nonReentrant` function from another `nonReentrant`
305      * function is not supported. It is possible to prevent this from happening
306      * by making the `nonReentrant` function external, and make it call a
307      * `private` function that does the actual work.
308      */
309     modifier nonReentrant() {
310         _guardCounter += 1;
311         uint256 localCounter = _guardCounter;
312         _;
313         require(localCounter == _guardCounter);
314     }
315 }
316 
317 contract PauserRole {
318     using Roles for Roles.Role;
319 
320     event PauserAdded(address indexed account);
321     event PauserRemoved(address indexed account);
322 
323     Roles.Role private _pausers;
324 
325     constructor () internal {
326         _addPauser(msg.sender);
327     }
328 
329     modifier onlyPauser() {
330         require(isPauser(msg.sender));
331         _;
332     }
333 
334     function isPauser(address account) public view returns (bool) {
335         return _pausers.has(account);
336     }
337 
338     function addPauser(address account) public onlyPauser {
339         _addPauser(account);
340     }
341 
342     function renouncePauser() public {
343         _removePauser(msg.sender);
344     }
345 
346     function _addPauser(address account) internal {
347         _pausers.add(account);
348         emit PauserAdded(account);
349     }
350 
351     function _removePauser(address account) internal {
352         _pausers.remove(account);
353         emit PauserRemoved(account);
354     }
355 }
356 
357 contract IERC721 is IERC165 {
358     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
359     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
360     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
361 
362     function balanceOf(address owner) public view returns (uint256 balance);
363     function ownerOf(uint256 tokenId) public view returns (address owner);
364 
365     function approve(address to, uint256 tokenId) public;
366     function getApproved(uint256 tokenId) public view returns (address operator);
367 
368     function setApprovalForAll(address operator, bool _approved) public;
369     function isApprovedForAll(address owner, address operator) public view returns (bool);
370 
371     function transferFrom(address from, address to, uint256 tokenId) public;
372     function safeTransferFrom(address from, address to, uint256 tokenId) public;
373 
374     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
375 }
376 
377 contract ERC165 is IERC165 {
378     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
379     /**
380      * 0x01ffc9a7 ===
381      *     bytes4(keccak256('supportsInterface(bytes4)'))
382      */
383 
384     /**
385      * @dev a mapping of interface id to whether or not it's supported
386      */
387     mapping(bytes4 => bool) private _supportedInterfaces;
388 
389     /**
390      * @dev A contract implementing SupportsInterfaceWithLookup
391      * implement ERC165 itself
392      */
393     constructor () internal {
394         _registerInterface(_INTERFACE_ID_ERC165);
395     }
396 
397     /**
398      * @dev implement supportsInterface(bytes4) using a lookup table
399      */
400     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
401         return _supportedInterfaces[interfaceId];
402     }
403 
404     /**
405      * @dev internal method for registering an interface
406      */
407     function _registerInterface(bytes4 interfaceId) internal {
408         require(interfaceId != 0xffffffff);
409         _supportedInterfaces[interfaceId] = true;
410     }
411 }
412 
413 contract Pausable is PauserRole {
414     event Paused(address account);
415     event Unpaused(address account);
416 
417     bool private _paused;
418 
419     constructor () internal {
420         _paused = false;
421     }
422 
423     /**
424      * @return true if the contract is paused, false otherwise.
425      */
426     function paused() public view returns (bool) {
427         return _paused;
428     }
429 
430     /**
431      * @dev Modifier to make a function callable only when the contract is not paused.
432      */
433     modifier whenNotPaused() {
434         require(!_paused);
435         _;
436     }
437 
438     /**
439      * @dev Modifier to make a function callable only when the contract is paused.
440      */
441     modifier whenPaused() {
442         require(_paused);
443         _;
444     }
445 
446     /**
447      * @dev called by the owner to pause, triggers stopped state
448      */
449     function pause() public onlyPauser whenNotPaused {
450         _paused = true;
451         emit Paused(msg.sender);
452     }
453 
454     /**
455      * @dev called by the owner to unpause, returns to normal state
456      */
457     function unpause() public onlyPauser whenPaused {
458         _paused = false;
459         emit Unpaused(msg.sender);
460     }
461 }
462 
463 contract Withdrawable is Ownable {
464   function withdrawEther() external onlyOwner {
465     msg.sender.transfer(address(this).balance);
466   }
467 
468   function withdrawToken(IERC20 _token) external onlyOwner {
469     require(_token.transfer(msg.sender, _token.balanceOf(address(this))));
470   }
471 }
472 
473 contract MinterRole {
474     using Roles for Roles.Role;
475 
476     event MinterAdded(address indexed account);
477     event MinterRemoved(address indexed account);
478 
479     Roles.Role private _minters;
480 
481     constructor () internal {
482         _addMinter(msg.sender);
483     }
484 
485     modifier onlyMinter() {
486         require(isMinter(msg.sender));
487         _;
488     }
489 
490     function isMinter(address account) public view returns (bool) {
491         return _minters.has(account);
492     }
493 
494     function addMinter(address account) public onlyMinter {
495         _addMinter(account);
496     }
497 
498     function renounceMinter() public {
499         _removeMinter(msg.sender);
500     }
501 
502     function _addMinter(address account) internal {
503         _minters.add(account);
504         emit MinterAdded(account);
505     }
506 
507     function _removeMinter(address account) internal {
508         _minters.remove(account);
509         emit MinterRemoved(account);
510     }
511 }
512 
513 contract ERC721 is ERC165, IERC721 {
514     using SafeMath for uint256;
515     using Address for address;
516 
517     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
518     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
519     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
520 
521     // Mapping from token ID to owner
522     mapping (uint256 => address) private _tokenOwner;
523 
524     // Mapping from token ID to approved address
525     mapping (uint256 => address) private _tokenApprovals;
526 
527     // Mapping from owner to number of owned token
528     mapping (address => uint256) private _ownedTokensCount;
529 
530     // Mapping from owner to operator approvals
531     mapping (address => mapping (address => bool)) private _operatorApprovals;
532 
533     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
534     /*
535      * 0x80ac58cd ===
536      *     bytes4(keccak256('balanceOf(address)')) ^
537      *     bytes4(keccak256('ownerOf(uint256)')) ^
538      *     bytes4(keccak256('approve(address,uint256)')) ^
539      *     bytes4(keccak256('getApproved(uint256)')) ^
540      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
541      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
542      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
543      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
544      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
545      */
546 
547     constructor () public {
548         // register the supported interfaces to conform to ERC721 via ERC165
549         _registerInterface(_INTERFACE_ID_ERC721);
550     }
551 
552     /**
553      * @dev Gets the balance of the specified address
554      * @param owner address to query the balance of
555      * @return uint256 representing the amount owned by the passed address
556      */
557     function balanceOf(address owner) public view returns (uint256) {
558         require(owner != address(0));
559         return _ownedTokensCount[owner];
560     }
561 
562     /**
563      * @dev Gets the owner of the specified token ID
564      * @param tokenId uint256 ID of the token to query the owner of
565      * @return owner address currently marked as the owner of the given token ID
566      */
567     function ownerOf(uint256 tokenId) public view returns (address) {
568         address owner = _tokenOwner[tokenId];
569         require(owner != address(0));
570         return owner;
571     }
572 
573     /**
574      * @dev Approves another address to transfer the given token ID
575      * The zero address indicates there is no approved address.
576      * There can only be one approved address per token at a given time.
577      * Can only be called by the token owner or an approved operator.
578      * @param to address to be approved for the given token ID
579      * @param tokenId uint256 ID of the token to be approved
580      */
581     function approve(address to, uint256 tokenId) public {
582         address owner = ownerOf(tokenId);
583         require(to != owner);
584         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
585 
586         _tokenApprovals[tokenId] = to;
587         emit Approval(owner, to, tokenId);
588     }
589 
590     /**
591      * @dev Gets the approved address for a token ID, or zero if no address set
592      * Reverts if the token ID does not exist.
593      * @param tokenId uint256 ID of the token to query the approval of
594      * @return address currently approved for the given token ID
595      */
596     function getApproved(uint256 tokenId) public view returns (address) {
597         require(_exists(tokenId));
598         return _tokenApprovals[tokenId];
599     }
600 
601     /**
602      * @dev Sets or unsets the approval of a given operator
603      * An operator is allowed to transfer all tokens of the sender on their behalf
604      * @param to operator address to set the approval
605      * @param approved representing the status of the approval to be set
606      */
607     function setApprovalForAll(address to, bool approved) public {
608         require(to != msg.sender);
609         _operatorApprovals[msg.sender][to] = approved;
610         emit ApprovalForAll(msg.sender, to, approved);
611     }
612 
613     /**
614      * @dev Tells whether an operator is approved by a given owner
615      * @param owner owner address which you want to query the approval of
616      * @param operator operator address which you want to query the approval of
617      * @return bool whether the given operator is approved by the given owner
618      */
619     function isApprovedForAll(address owner, address operator) public view returns (bool) {
620         return _operatorApprovals[owner][operator];
621     }
622 
623     /**
624      * @dev Transfers the ownership of a given token ID to another address
625      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
626      * Requires the msg sender to be the owner, approved, or operator
627      * @param from current owner of the token
628      * @param to address to receive the ownership of the given token ID
629      * @param tokenId uint256 ID of the token to be transferred
630     */
631     function transferFrom(address from, address to, uint256 tokenId) public {
632         require(_isApprovedOrOwner(msg.sender, tokenId));
633 
634         _transferFrom(from, to, tokenId);
635     }
636 
637     /**
638      * @dev Safely transfers the ownership of a given token ID to another address
639      * If the target address is a contract, it must implement `onERC721Received`,
640      * which is called upon a safe transfer, and return the magic value
641      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
642      * the transfer is reverted.
643      *
644      * Requires the msg sender to be the owner, approved, or operator
645      * @param from current owner of the token
646      * @param to address to receive the ownership of the given token ID
647      * @param tokenId uint256 ID of the token to be transferred
648     */
649     function safeTransferFrom(address from, address to, uint256 tokenId) public {
650         safeTransferFrom(from, to, tokenId, "");
651     }
652 
653     /**
654      * @dev Safely transfers the ownership of a given token ID to another address
655      * If the target address is a contract, it must implement `onERC721Received`,
656      * which is called upon a safe transfer, and return the magic value
657      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
658      * the transfer is reverted.
659      * Requires the msg sender to be the owner, approved, or operator
660      * @param from current owner of the token
661      * @param to address to receive the ownership of the given token ID
662      * @param tokenId uint256 ID of the token to be transferred
663      * @param _data bytes data to send along with a safe transfer check
664      */
665     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
666         transferFrom(from, to, tokenId);
667         require(_checkOnERC721Received(from, to, tokenId, _data));
668     }
669 
670     /**
671      * @dev Returns whether the specified token exists
672      * @param tokenId uint256 ID of the token to query the existence of
673      * @return whether the token exists
674      */
675     function _exists(uint256 tokenId) internal view returns (bool) {
676         address owner = _tokenOwner[tokenId];
677         return owner != address(0);
678     }
679 
680     /**
681      * @dev Returns whether the given spender can transfer a given token ID
682      * @param spender address of the spender to query
683      * @param tokenId uint256 ID of the token to be transferred
684      * @return bool whether the msg.sender is approved for the given token ID,
685      *    is an operator of the owner, or is the owner of the token
686      */
687     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
688         address owner = ownerOf(tokenId);
689         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
690     }
691 
692     /**
693      * @dev Internal function to mint a new token
694      * Reverts if the given token ID already exists
695      * @param to The address that will own the minted token
696      * @param tokenId uint256 ID of the token to be minted
697      */
698     function _mint(address to, uint256 tokenId) internal {
699         require(to != address(0));
700         require(!_exists(tokenId));
701 
702         _tokenOwner[tokenId] = to;
703         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
704 
705         emit Transfer(address(0), to, tokenId);
706     }
707 
708     /**
709      * @dev Internal function to burn a specific token
710      * Reverts if the token does not exist
711      * Deprecated, use _burn(uint256) instead.
712      * @param owner owner of the token to burn
713      * @param tokenId uint256 ID of the token being burned
714      */
715     function _burn(address owner, uint256 tokenId) internal {
716         require(ownerOf(tokenId) == owner);
717 
718         _clearApproval(tokenId);
719 
720         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
721         _tokenOwner[tokenId] = address(0);
722 
723         emit Transfer(owner, address(0), tokenId);
724     }
725 
726     /**
727      * @dev Internal function to burn a specific token
728      * Reverts if the token does not exist
729      * @param tokenId uint256 ID of the token being burned
730      */
731     function _burn(uint256 tokenId) internal {
732         _burn(ownerOf(tokenId), tokenId);
733     }
734 
735     /**
736      * @dev Internal function to transfer ownership of a given token ID to another address.
737      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
738      * @param from current owner of the token
739      * @param to address to receive the ownership of the given token ID
740      * @param tokenId uint256 ID of the token to be transferred
741     */
742     function _transferFrom(address from, address to, uint256 tokenId) internal {
743         require(ownerOf(tokenId) == from);
744         require(to != address(0));
745 
746         _clearApproval(tokenId);
747 
748         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
749         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
750 
751         _tokenOwner[tokenId] = to;
752 
753         emit Transfer(from, to, tokenId);
754     }
755 
756     /**
757      * @dev Internal function to invoke `onERC721Received` on a target address
758      * The call is not executed if the target address is not a contract
759      * @param from address representing the previous owner of the given token ID
760      * @param to target address that will receive the tokens
761      * @param tokenId uint256 ID of the token to be transferred
762      * @param _data bytes optional data to send along with the call
763      * @return whether the call correctly returned the expected magic value
764      */
765     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
766         internal returns (bool)
767     {
768         if (!to.isContract()) {
769             return true;
770         }
771 
772         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
773         return (retval == _ERC721_RECEIVED);
774     }
775 
776     /**
777      * @dev Private function to clear current approval of a given token ID
778      * @param tokenId uint256 ID of the token to be transferred
779      */
780     function _clearApproval(uint256 tokenId) private {
781         if (_tokenApprovals[tokenId] != address(0)) {
782             _tokenApprovals[tokenId] = address(0);
783         }
784     }
785 }
786 
787 contract IERC721Enumerable is IERC721 {
788     function totalSupply() public view returns (uint256);
789     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
790 
791     function tokenByIndex(uint256 index) public view returns (uint256);
792 }
793 
794 contract DJTBase is Withdrawable, Pausable, ReentrancyGuard {
795     using SafeMath for uint256;
796 }
797 contract IERC721Metadata is IERC721 {
798     function name() external view returns (string memory);
799     function symbol() external view returns (string memory);
800     function tokenURI(uint256 tokenId) external view returns (string memory);
801 }
802 
803 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
804     // Mapping from owner to list of owned token IDs
805     mapping(address => uint256[]) private _ownedTokens;
806 
807     // Mapping from token ID to index of the owner tokens list
808     mapping(uint256 => uint256) private _ownedTokensIndex;
809 
810     // Array with all token ids, used for enumeration
811     uint256[] private _allTokens;
812 
813     // Mapping from token id to position in the allTokens array
814     mapping(uint256 => uint256) private _allTokensIndex;
815 
816     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
817     /**
818      * 0x780e9d63 ===
819      *     bytes4(keccak256('totalSupply()')) ^
820      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
821      *     bytes4(keccak256('tokenByIndex(uint256)'))
822      */
823 
824     /**
825      * @dev Constructor function
826      */
827     constructor () public {
828         // register the supported interface to conform to ERC721 via ERC165
829         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
830     }
831 
832     /**
833      * @dev Gets the token ID at a given index of the tokens list of the requested owner
834      * @param owner address owning the tokens list to be accessed
835      * @param index uint256 representing the index to be accessed of the requested tokens list
836      * @return uint256 token ID at the given index of the tokens list owned by the requested address
837      */
838     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
839         require(index < balanceOf(owner));
840         return _ownedTokens[owner][index];
841     }
842 
843     /**
844      * @dev Gets the total amount of tokens stored by the contract
845      * @return uint256 representing the total amount of tokens
846      */
847     function totalSupply() public view returns (uint256) {
848         return _allTokens.length;
849     }
850 
851     /**
852      * @dev Gets the token ID at a given index of all the tokens in this contract
853      * Reverts if the index is greater or equal to the total number of tokens
854      * @param index uint256 representing the index to be accessed of the tokens list
855      * @return uint256 token ID at the given index of the tokens list
856      */
857     function tokenByIndex(uint256 index) public view returns (uint256) {
858         require(index < totalSupply());
859         return _allTokens[index];
860     }
861 
862     /**
863      * @dev Internal function to transfer ownership of a given token ID to another address.
864      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
865      * @param from current owner of the token
866      * @param to address to receive the ownership of the given token ID
867      * @param tokenId uint256 ID of the token to be transferred
868     */
869     function _transferFrom(address from, address to, uint256 tokenId) internal {
870         super._transferFrom(from, to, tokenId);
871 
872         _removeTokenFromOwnerEnumeration(from, tokenId);
873 
874         _addTokenToOwnerEnumeration(to, tokenId);
875     }
876 
877     /**
878      * @dev Internal function to mint a new token
879      * Reverts if the given token ID already exists
880      * @param to address the beneficiary that will own the minted token
881      * @param tokenId uint256 ID of the token to be minted
882      */
883     function _mint(address to, uint256 tokenId) internal {
884         super._mint(to, tokenId);
885 
886         _addTokenToOwnerEnumeration(to, tokenId);
887 
888         _addTokenToAllTokensEnumeration(tokenId);
889     }
890 
891     /**
892      * @dev Internal function to burn a specific token
893      * Reverts if the token does not exist
894      * Deprecated, use _burn(uint256) instead
895      * @param owner owner of the token to burn
896      * @param tokenId uint256 ID of the token being burned
897      */
898     function _burn(address owner, uint256 tokenId) internal {
899         super._burn(owner, tokenId);
900 
901         _removeTokenFromOwnerEnumeration(owner, tokenId);
902         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
903         _ownedTokensIndex[tokenId] = 0;
904 
905         _removeTokenFromAllTokensEnumeration(tokenId);
906     }
907 
908     /**
909      * @dev Gets the list of token IDs of the requested owner
910      * @param owner address owning the tokens
911      * @return uint256[] List of token IDs owned by the requested address
912      */
913     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
914         return _ownedTokens[owner];
915     }
916 
917     /**
918      * @dev Private function to add a token to this extension's ownership-tracking data structures.
919      * @param to address representing the new owner of the given token ID
920      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
921      */
922     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
923         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
924         _ownedTokens[to].push(tokenId);
925     }
926 
927     /**
928      * @dev Private function to add a token to this extension's token tracking data structures.
929      * @param tokenId uint256 ID of the token to be added to the tokens list
930      */
931     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
932         _allTokensIndex[tokenId] = _allTokens.length;
933         _allTokens.push(tokenId);
934     }
935 
936     /**
937      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
938      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
939      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
940      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
941      * @param from address representing the previous owner of the given token ID
942      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
943      */
944     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
945         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
946         // then delete the last slot (swap and pop).
947 
948         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
949         uint256 tokenIndex = _ownedTokensIndex[tokenId];
950 
951         // When the token to delete is the last token, the swap operation is unnecessary
952         if (tokenIndex != lastTokenIndex) {
953             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
954 
955             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
956             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
957         }
958 
959         // This also deletes the contents at the last position of the array
960         _ownedTokens[from].length--;
961 
962         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
963         // lasTokenId, or just over the end of the array if the token was the last one).
964     }
965 
966     /**
967      * @dev Private function to remove a token from this extension's token tracking data structures.
968      * This has O(1) time complexity, but alters the order of the _allTokens array.
969      * @param tokenId uint256 ID of the token to be removed from the tokens list
970      */
971     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
972         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
973         // then delete the last slot (swap and pop).
974 
975         uint256 lastTokenIndex = _allTokens.length.sub(1);
976         uint256 tokenIndex = _allTokensIndex[tokenId];
977 
978         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
979         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
980         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
981         uint256 lastTokenId = _allTokens[lastTokenIndex];
982 
983         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
984         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
985 
986         // This also deletes the contents at the last position of the array
987         _allTokens.length--;
988         _allTokensIndex[tokenId] = 0;
989     }
990 }
991 
992 contract ERC721Mintable is ERC721, MinterRole {
993     /**
994      * @dev Function to mint tokens
995      * @param to The address that will receive the minted tokens.
996      * @param tokenId The token id to mint.
997      * @return A boolean that indicates if the operation was successful.
998      */
999     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
1000         _mint(to, tokenId);
1001         return true;
1002     }
1003 }
1004 
1005 contract ERC721Pausable is ERC721, Pausable {
1006     function approve(address to, uint256 tokenId) public whenNotPaused {
1007         super.approve(to, tokenId);
1008     }
1009 
1010     function setApprovalForAll(address to, bool approved) public whenNotPaused {
1011         super.setApprovalForAll(to, approved);
1012     }
1013 
1014     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
1015         super.transferFrom(from, to, tokenId);
1016     }
1017 }
1018 
1019 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
1020     // Token name
1021     string private _name;
1022 
1023     // Token symbol
1024     string private _symbol;
1025 
1026     // Optional mapping for token URIs
1027     mapping(uint256 => string) private _tokenURIs;
1028 
1029     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1030     /**
1031      * 0x5b5e139f ===
1032      *     bytes4(keccak256('name()')) ^
1033      *     bytes4(keccak256('symbol()')) ^
1034      *     bytes4(keccak256('tokenURI(uint256)'))
1035      */
1036 
1037     /**
1038      * @dev Constructor function
1039      */
1040     constructor (string memory name, string memory symbol) public {
1041         _name = name;
1042         _symbol = symbol;
1043 
1044         // register the supported interfaces to conform to ERC721 via ERC165
1045         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1046     }
1047 
1048     /**
1049      * @dev Gets the token name
1050      * @return string representing the token name
1051      */
1052     function name() external view returns (string memory) {
1053         return _name;
1054     }
1055 
1056     /**
1057      * @dev Gets the token symbol
1058      * @return string representing the token symbol
1059      */
1060     function symbol() external view returns (string memory) {
1061         return _symbol;
1062     }
1063 
1064     /**
1065      * @dev Returns an URI for a given token ID
1066      * Throws if the token ID does not exist. May return an empty string.
1067      * @param tokenId uint256 ID of the token to query
1068      */
1069     function tokenURI(uint256 tokenId) external view returns (string memory) {
1070         require(_exists(tokenId));
1071         return _tokenURIs[tokenId];
1072     }
1073 
1074     /**
1075      * @dev Internal function to set the token URI for a given token
1076      * Reverts if the token ID does not exist
1077      * @param tokenId uint256 ID of the token to set its URI
1078      * @param uri string URI to assign
1079      */
1080     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1081         require(_exists(tokenId));
1082         _tokenURIs[tokenId] = uri;
1083     }
1084 
1085     /**
1086      * @dev Internal function to burn a specific token
1087      * Reverts if the token does not exist
1088      * Deprecated, use _burn(uint256) instead
1089      * @param owner owner of the token to burn
1090      * @param tokenId uint256 ID of the token being burned by the msg.sender
1091      */
1092     function _burn(address owner, uint256 tokenId) internal {
1093         super._burn(owner, tokenId);
1094 
1095         // Clear metadata (if any)
1096         if (bytes(_tokenURIs[tokenId]).length != 0) {
1097             delete _tokenURIs[tokenId];
1098         }
1099     }
1100 }
1101 
1102 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1103     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1104         // solhint-disable-previous-line no-empty-blocks
1105     }
1106 }
1107 
1108 contract LandSectorAsset is ERC721Full, ERC721Mintable, ERC721Pausable {
1109 
1110 
1111   uint256 public constant SHARE_RATE_DECIMAL = 10**18;
1112 
1113   uint16 public constant LEGENDARY_RARITY = 5;
1114   uint16 public constant EPIC_RARITY = 4;
1115   uint16 public constant RARE_RARITY = 3;
1116   uint16 public constant UNCOMMON_RARITY = 2;
1117   uint16 public constant COMMON_RARITY = 1;
1118 
1119   uint16 public constant NO_LAND = 0;
1120 
1121   string public tokenURIPrefix = "https://www.mycryptoheroes.net/metadata/land/";
1122 
1123   mapping(uint16 => uint256) private landTypeToTotalVolume;
1124   mapping(uint16 => uint256) private landTypeToSectorSupplyLimit;
1125   mapping(uint16 => mapping(uint16 => uint256)) private landTypeAndRarityToSectorSupply;
1126   mapping(uint16 => uint256[]) private landTypeToLandSectorList;
1127   mapping(uint16 => uint256) private landTypeToLandSectorIndex;
1128   mapping(uint16 => mapping(uint16 => uint256)) private landTypeAndRarityToLandSectorCount;
1129   mapping(uint16 => uint256) private rarityToSectorVolume;
1130 
1131   mapping(uint256 => bool) private allowed;
1132 
1133   event MintEvent(
1134     address indexed assetOwner,
1135     uint256 tokenId,
1136     uint256 at,
1137     bytes32 indexed eventHash
1138   );
1139 
1140   constructor() public ERC721Full("MyCryptoHeroes:Land", "MCHL") {
1141     rarityToSectorVolume[5] = 100;
1142     rarityToSectorVolume[4] = 20;
1143     rarityToSectorVolume[3] = 5;
1144     rarityToSectorVolume[2] = 2;
1145     rarityToSectorVolume[1] = 1;
1146     landTypeToTotalVolume[NO_LAND] = 0;
1147   }
1148 
1149   function setSupplyAndSector(
1150     uint16 _landType,
1151     uint256 _totalVolume,
1152     uint256 _sectorSupplyLimit,
1153     uint256 legendarySupply,
1154     uint256 epicSupply,
1155     uint256 rareSupply,
1156     uint256 uncommonSupply,
1157     uint256 commonSupply
1158   ) external onlyMinter {
1159     require(_landType != 0, "landType 0 is noland");
1160     require(_totalVolume != 0, "totalVolume must not be 0");
1161     require(getMintedSectorCount(_landType) == 0, "This LandType already exists");
1162     require(
1163       legendarySupply.mul(rarityToSectorVolume[LEGENDARY_RARITY])
1164       .add(epicSupply.mul(rarityToSectorVolume[EPIC_RARITY]))
1165       .add(rareSupply.mul(rarityToSectorVolume[RARE_RARITY]))
1166       .add(uncommonSupply.mul(rarityToSectorVolume[UNCOMMON_RARITY]))
1167       .add(commonSupply.mul(rarityToSectorVolume[COMMON_RARITY]))
1168       == _totalVolume
1169     );
1170     require(
1171       legendarySupply
1172       .add(epicSupply)
1173       .add(rareSupply)
1174       .add(uncommonSupply)
1175       .add(commonSupply)
1176       == _sectorSupplyLimit
1177     );
1178     landTypeToTotalVolume[_landType] = _totalVolume;
1179     landTypeToSectorSupplyLimit[_landType] = _sectorSupplyLimit;
1180     landTypeAndRarityToSectorSupply[_landType][LEGENDARY_RARITY] = legendarySupply;
1181     landTypeAndRarityToSectorSupply[_landType][EPIC_RARITY] = epicSupply;
1182     landTypeAndRarityToSectorSupply[_landType][RARE_RARITY] = rareSupply;
1183     landTypeAndRarityToSectorSupply[_landType][UNCOMMON_RARITY] = uncommonSupply;
1184     landTypeAndRarityToSectorSupply[_landType][COMMON_RARITY] = commonSupply;
1185   }
1186 
1187   function approve(address _to, uint256 _tokenId) public {
1188     require(allowed[_tokenId]);
1189     super.approve(_to, _tokenId);
1190   }
1191 
1192   function transferFrom(address _from, address _to, uint256 _tokenId) public {
1193     require(allowed[_tokenId]);
1194     super.transferFrom(_from, _to, _tokenId);
1195   }
1196 
1197   function unLockToken(uint256 _tokenId) public onlyMinter {
1198     allowed[_tokenId] = true;
1199   }
1200 
1201   function setTokenURIPrefix(string calldata _tokenURIPrefix) external onlyMinter {
1202     tokenURIPrefix = _tokenURIPrefix;
1203   }
1204 
1205   function isAlreadyMinted(uint256 _tokenId) public view returns (bool) {
1206     return _exists(_tokenId);
1207   }
1208 
1209   function isValidLandSector(uint256 _tokenId) public view returns (bool) {
1210     uint16 rarity = getRarity(_tokenId);
1211     if (!(rarityToSectorVolume[rarity] > 0)) {
1212       return false;
1213     }
1214     uint16 landType = getLandType(_tokenId);
1215     if (!(landTypeToTotalVolume[landType] > 0)) {
1216       return false;
1217     }
1218     uint256 serial = _tokenId % 10000;
1219     if (serial == 0) {
1220       return false;
1221     }
1222     if (serial > landTypeAndRarityToSectorSupply[landType][rarity]) {
1223       return false;
1224     }
1225     return true;
1226   }
1227 
1228   function canTransfer(uint256 _tokenId) public view returns (bool) {
1229     return allowed[_tokenId];
1230   }
1231 
1232   function getTotalVolume(uint16 _landType) public view returns (uint256) {
1233     return landTypeToTotalVolume[_landType];
1234   }
1235 
1236   function getSectorSupplyLimit(uint16 _landType) public view returns (uint256) {
1237     return landTypeToSectorSupplyLimit[_landType];
1238   }
1239 
1240   function getLandType(uint256 _landSector) public view returns (uint16) {
1241     uint16 _landType = uint16((_landSector.div(10000)) % 1000);
1242     return _landType;
1243   }
1244 
1245   function getRarity(uint256 _landSector) public view returns (uint16) {
1246     return uint16(_landSector.div(10**7));
1247   }
1248 
1249   function getMintedSectorCount(uint16 _landType) public view returns (uint256) {
1250     return landTypeToLandSectorIndex[_landType];
1251   }
1252 
1253   function getMintedSectorCountByRarity(uint16 _landType, uint16 _rarity) public view returns (uint256) {
1254     return landTypeAndRarityToLandSectorCount[_landType][_rarity];
1255   }
1256 
1257   function getSectorSupplyByRarity(uint16 _landType, uint16 _rarity) public view returns (uint256) {
1258     return landTypeAndRarityToSectorSupply[_landType][_rarity];
1259   }
1260 
1261   function getMintedSectorList(uint16 _landType) public view returns (uint256[] memory) {
1262     return landTypeToLandSectorList[_landType];
1263   }
1264 
1265   function getSectorVolumeByRarity(uint16 _rarity) public view returns (uint256) {
1266     return rarityToSectorVolume[_rarity];
1267   }
1268 
1269   function getShareRateWithDecimal(uint256 _landSector) public view returns (uint256, uint256) {
1270     return (
1271       getSectorVolumeByRarity(getRarity(_landSector))
1272         .mul(SHARE_RATE_DECIMAL)
1273         .div(getTotalVolume(getLandType(_landSector))),
1274       SHARE_RATE_DECIMAL
1275     );
1276   }
1277 
1278   function mintLandSector(address _owner, uint256 _landSector, bytes32 _eventHash) public onlyMinter {
1279     require(!isAlreadyMinted(_landSector));
1280     require(isValidLandSector(_landSector));
1281     uint16 _landType = getLandType(_landSector);
1282     require(landTypeToLandSectorIndex[_landType] < landTypeToSectorSupplyLimit[_landType]);
1283     uint16 rarity = getRarity(_landSector);
1284     require(landTypeAndRarityToLandSectorCount[_landType][rarity] < landTypeAndRarityToSectorSupply[_landType][rarity], "supply over");
1285     _mint(_owner, _landSector);
1286     landTypeToLandSectorList[_landType].push(_landSector);
1287     landTypeToLandSectorIndex[_landType]++;
1288     landTypeAndRarityToLandSectorCount[_landType][rarity]++;
1289 
1290     emit MintEvent(
1291       _owner,
1292       _landSector,
1293       block.timestamp,
1294       _eventHash
1295     );
1296   }
1297 
1298   function tokenURI(uint256 _tokenId) public view returns (string memory) {
1299     bytes32 tokenIdBytes;
1300     if (_tokenId == 0) {
1301       tokenIdBytes = "0";
1302     } else {
1303       uint256 value = _tokenId;
1304       while (value > 0) {
1305         tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
1306         tokenIdBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
1307         value /= 10;
1308       }
1309     }
1310 
1311     bytes memory prefixBytes = bytes(tokenURIPrefix);
1312     bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
1313 
1314     uint8 i;
1315     uint8 index = 0;
1316 
1317     for (i = 0; i < prefixBytes.length; i++) {
1318       tokenURIBytes[index] = prefixBytes[i];
1319       index++;
1320     }
1321 
1322     for (i = 0; i < tokenIdBytes.length; i++) {
1323       tokenURIBytes[index] = tokenIdBytes[i];
1324       index++;
1325     }
1326 
1327     return string(tokenURIBytes);
1328   }
1329 }
1330 /* solhint-enable indent*/
1331 
1332 contract MCHLandPool is Ownable, Pausable, ReentrancyGuard {
1333   using SafeMath for uint256;
1334 
1335 
1336   LandSectorAsset public landSectorAsset;
1337 
1338   mapping(uint16 => uint256) private landTypeToTotalAmount;
1339   mapping(uint256 => uint256) private landSectorToWithdrawnAmount;
1340   mapping(address => bool) private allowedAddresses;
1341 
1342   event EthAddedToPool(
1343     uint16 indexed landType,
1344     address txSender,
1345     address indexed purchaseBy,
1346     uint256 value,
1347     uint256 at
1348   );
1349 
1350   event WithdrawEther(
1351     uint256 indexed landSector,
1352     address indexed lord,
1353     uint256 value,
1354     uint256 at
1355   );
1356 
1357   event AllowedAddressSet(
1358     address allowedAddress,
1359     bool allowedStatus
1360   );
1361 
1362   constructor(address _landSectorAssetAddress) public {
1363     landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
1364   }
1365 
1366   function setLandSectorAssetAddress(address _landSectorAssetAddress) external onlyOwner() {
1367     landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
1368   }
1369 
1370   function setAllowedAddress(address _address, bool desired) external onlyOwner() {
1371     allowedAddresses[_address] = desired;
1372     emit AllowedAddressSet(
1373       _address,
1374       desired
1375     );
1376   }
1377 
1378   function addEthToLandPool(uint16 _landType, address _purchaseBy) external payable whenNotPaused() nonReentrant() {
1379     require(landSectorAsset.getTotalVolume(_landType) > 0);
1380     require(allowedAddresses[msg.sender]);
1381     landTypeToTotalAmount[_landType] += msg.value;
1382 
1383     emit EthAddedToPool(
1384       _landType,
1385       msg.sender,
1386       _purchaseBy,
1387       msg.value,
1388       block.timestamp
1389     );
1390   }
1391 
1392   function withdrawMyAllRewards() external whenNotPaused() nonReentrant() {
1393     require(getWithdrawableBalance(msg.sender) > 0);
1394 
1395     uint256 withdrawValue;
1396     uint256 balance = landSectorAsset.balanceOf(msg.sender);
1397     
1398     for (uint256 i=balance; i > 0; i--) {
1399       uint256 landSector = landSectorAsset.tokenOfOwnerByIndex(msg.sender, i-1);
1400       uint256 tmpAmount = getLandSectorWithdrawableBalance(landSector);
1401       withdrawValue += tmpAmount;
1402       landSectorToWithdrawnAmount[landSector] += tmpAmount;
1403 
1404       emit WithdrawEther(
1405         landSector,
1406         msg.sender,
1407         tmpAmount,
1408         block.timestamp
1409       );
1410     }
1411     msg.sender.transfer(withdrawValue);
1412   }
1413 
1414   function withdrawMyReward(uint256 _landSector) external whenNotPaused() nonReentrant() {
1415     require(landSectorAsset.ownerOf(_landSector) == msg.sender);
1416     uint256 withdrawableAmount = getLandSectorWithdrawableBalance(_landSector);
1417     require(withdrawableAmount > 0);
1418 
1419     landSectorToWithdrawnAmount[_landSector] += withdrawableAmount;
1420     msg.sender.transfer(withdrawableAmount);
1421 
1422     emit WithdrawEther(
1423       _landSector,
1424       msg.sender,
1425       withdrawableAmount,
1426       block.timestamp
1427     );
1428   }
1429 
1430   function getAllowedAddress(address _address) public view returns (bool) {
1431     return allowedAddresses[_address];
1432   }
1433 
1434   function getTotalEthBackAmountPerLandType(uint16 _landType) public view returns (uint256) {
1435     return landTypeToTotalAmount[_landType];
1436   }
1437 
1438   function getLandSectorWithdrawnAmount(uint256 _landSector) public view returns (uint256) {
1439     return landSectorToWithdrawnAmount[_landSector];
1440   }
1441 
1442   function getLandSectorWithdrawableBalance(uint256 _landSector) public view returns (uint256) {
1443     require(landSectorAsset.isValidLandSector(_landSector));
1444     uint16 _landType = landSectorAsset.getLandType(_landSector);
1445     (uint256 shareRate, uint256 decimal) = landSectorAsset.getShareRateWithDecimal(_landSector);
1446     uint256 maxAmount = landTypeToTotalAmount[_landType]
1447       .mul(shareRate)
1448       .div(decimal);
1449     return maxAmount.sub(landSectorToWithdrawnAmount[_landSector]);
1450   }
1451 
1452   function getWithdrawableBalance(address _lordAddress) public view returns (uint256) {
1453     uint256 balance = landSectorAsset.balanceOf(_lordAddress);
1454     uint256 withdrawableAmount;
1455 
1456     for (uint256 i=balance; i > 0; i--) {
1457       uint256 landSector = landSectorAsset.tokenOfOwnerByIndex(_lordAddress, i-1);
1458       withdrawableAmount += getLandSectorWithdrawableBalance(landSector);
1459     }
1460 
1461     return withdrawableAmount;
1462   }
1463 }
1464 /* solhint-enable indent*/
1465 
1466 contract MCHGUMGatewayV8 is DJTBase {
1467 
1468   struct Campaign {
1469     uint256 since;
1470     uint256 until;
1471     uint8 purchaseType;
1472   }
1473 
1474   Campaign public campaign;
1475 
1476   mapping(uint256 => bool) public payableOptions;
1477   address public validater;
1478 
1479   LandSectorAsset public landSectorAsset;
1480   MCHLandPool public landPool;
1481   uint256 public landPercentage;
1482 
1483   event Sold(
1484     address indexed user,
1485     address indexed referrer,
1486     uint8 purchaseType,
1487     uint256 grossValue,
1488     uint256 referralValue,
1489     uint256 landValue,
1490     uint256 netValue,
1491     uint16 indexed landType
1492   );
1493 
1494   event CampaignUpdated(
1495     uint256 since,
1496     uint256 until,
1497     uint8 purchaseType
1498   );
1499 
1500   event LandPercentageUpdated(
1501     uint256 landPercentage
1502   );
1503 
1504   constructor(
1505               address _validater,
1506               address _landSectorAssetAddress,
1507               address _landPoolAddress
1508   ) public payable {
1509     validater = _validater;
1510     landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
1511     landPool = MCHLandPool(_landPoolAddress);
1512 
1513     campaign = Campaign(0, 0, 0);
1514     landPercentage = 30;
1515 
1516     payableOptions[0.05 ether] = true;
1517     payableOptions[0.1 ether] = true;
1518     payableOptions[0.5 ether] = true;
1519     payableOptions[1 ether] = true;
1520     payableOptions[5 ether] = true;
1521     payableOptions[10 ether] = true;
1522   }
1523 
1524   function setValidater(address _varidater) external onlyOwner() {
1525     validater = _varidater;
1526   }
1527 
1528   function setPayableOption(uint256 _option, bool desired) external onlyOwner() {
1529     payableOptions[_option] = desired;
1530   }
1531 
1532   function setCampaign(uint256 _since, uint256 _until, uint8 _purchaseType) external onlyOwner() {
1533     campaign = Campaign(_since, _until, _purchaseType);
1534     emit CampaignUpdated(_since, _until, _purchaseType);
1535   }
1536 
1537   function setLandSectorAssetAddress(address _landSectorAssetAddress) external onlyOwner() {
1538     landSectorAsset = LandSectorAsset(_landSectorAssetAddress);
1539   }
1540 
1541   function setLandPoolAddress(address payable _landPoolAddress) external onlyOwner() {
1542     landPool = MCHLandPool(_landPoolAddress);
1543   }
1544 
1545   function updateLandPercentage(uint256 _newLandPercentage) external onlyOwner() {
1546     landPercentage = _newLandPercentage;
1547     emit LandPercentageUpdated(
1548       landPercentage
1549     );
1550   }
1551 
1552   function buyGUM(
1553                   address payable _referrer,
1554                   uint256 _referralPercentage,
1555                   uint16 _landType,
1556                   bytes calldata _signature
1557                   ) external payable whenNotPaused() {
1558 
1559     require(_referralPercentage + landPercentage <= 100, "Invalid percentages");
1560     require(payableOptions[msg.value], "Invalid msg.value");
1561     require(validateSig(encodeData(msg.sender, _referrer, _referralPercentage, _landType), _signature), "Invalid signature");
1562 
1563     uint256 referralValue = _referrerBack(_referrer, _referralPercentage);
1564     uint256 landValue = _landPoolBack(_landType);
1565     uint256 netValue = msg.value.sub(referralValue).sub(landValue);
1566 
1567     emit Sold(
1568       msg.sender,
1569       _referrer,
1570       getPurchaseType(block.number),
1571       msg.value,
1572       referralValue,
1573       landValue,
1574       netValue,
1575       _landType
1576     );
1577   }
1578 
1579   function getPurchaseType(uint256 _block) public view returns (uint8) {
1580     // Define purchaseType
1581     // enum PurchaseType {
1582     //   PURCHASE_NORMAL = 0;
1583     //   PURCHASE_ETH_BACK = 1;
1584     // }
1585     if(campaign.until < _block) {
1586       return 0;
1587     }
1588     if(campaign.since > _block) {
1589       return 0;
1590     }
1591     return campaign.purchaseType;
1592   }
1593 
1594   function _landPoolBack(uint16 _landType) internal returns (uint256) {
1595     if(_landType == 0) {
1596       return 0;
1597     }
1598     require(landSectorAsset.getTotalVolume(_landType) != 0, "Invalid _landType");
1599 
1600     uint256 landValue;
1601     landValue = msg.value.mul(landPercentage).div(100);
1602     landPool.addEthToLandPool.value(landValue)(_landType, msg.sender);
1603     return landValue;
1604   }
1605 
1606   function _referrerBack(address payable _referrer, uint256 _referralPercentage) internal returns (uint256) {
1607     if(_referrer == address(0x0) || _referrer == msg.sender) {
1608       return 0;
1609     }
1610 
1611     uint256 referralValue;
1612     referralValue = msg.value.mul(_referralPercentage).div(100);
1613     _referrer.transfer(referralValue);
1614     return referralValue;
1615   }
1616 
1617   function encodeData(address _sender, address _referrer, uint256 _referralPercentage, uint16 _landType) public pure returns (bytes32) {
1618     return keccak256(abi.encode(
1619                                 _sender,
1620                                 _referrer,
1621                                 _referralPercentage,
1622                                 _landType
1623                                 )
1624                      );
1625   }
1626 
1627   function validateSig(bytes32 _message, bytes memory _signature) public view returns (bool) {
1628     require(validater != address(0), "validater must be setted");
1629     address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
1630     return (signer == validater);
1631   }
1632 
1633   function kill() external onlyOwner() {
1634     selfdestruct(msg.sender);
1635   }
1636 }
1637 /* solhint-enable indent*/