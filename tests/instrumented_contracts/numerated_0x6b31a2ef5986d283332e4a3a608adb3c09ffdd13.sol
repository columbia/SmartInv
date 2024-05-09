1 pragma solidity ^0.4.25;
2 
3 // https://github.com/OpenZeppelin/zeppelin-solidity
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65 
66         return a % b;
67     }
68 
69     /**
70      * @dev gives square root of given x.
71      */
72     function sqrt(uint256 x) internal pure returns (uint256 y) {
73         uint256 z = ((add(x, 1)) / 2);
74         y = x;
75         while (z < y) {
76             y = z;
77             z = ((add((x / z), z)) / 2);
78         }
79     }
80     
81     /**
82      * @dev gives square. multiplies x by x
83      */
84     function sq(uint256 x) internal pure returns (uint256) {
85         return (mul(x, x));
86     }
87     
88     /**
89      * @dev x to the power of y 
90      */
91     function pwr(uint256 x, uint256 y) internal pure returns (uint256)
92     {
93         if (x == 0) {
94             return (0);
95         }
96         else if (y == 0) {
97             return 1;
98         }
99         else {
100             uint256 z = x;
101             for (uint256 i = 1; i < y; i++) {
102                 z = mul(z, x);
103             }
104             return z;
105         }
106     }
107 }
108 
109 /**
110  * Utility library of inline functions on addresses
111  */
112 library Address {
113     /**
114      * Returns whether the target address is a contract
115      * @dev This function will return false if invoked during the constructor of a contract,
116      * as the code is not actually created until after the constructor finishes.
117      * @param account address of the account to check
118      * @return whether the target address is a contract
119      */
120     function isContract(address account) internal view returns (bool) {
121         uint256 size;
122         // XXX Currently there is no better way to check if there is a contract in an address
123         // than to check the size of the code at that address.
124         // See https://ethereum.stackexchange.com/a/14016/36603
125         // for more details about how this works.
126         // TODO Check this again before the Serenity release, because all addresses will be
127         // contracts then.
128         // solium-disable-next-line security/no-inline-assembly
129         assembly { size := extcodesize(account) }
130         return size > 0;
131     }
132 }
133 
134 /**
135  * @title Ownable
136  * @dev The Ownable contract has an owner address, and provides basic authorization control
137  * functions, this simplifies the implementation of "user permissions".
138  */
139 contract Ownable {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     /**
145      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
146      * account.
147      */
148     constructor () internal {
149         _owner = msg.sender;
150         emit OwnershipTransferred(address(0), _owner);
151     }
152 
153     /**
154      * @return the address of the owner.
155      */
156     function owner() public view returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(isOwner());
165         _;
166     }
167 
168     /**
169      * @return true if `msg.sender` is the owner of the contract.
170      */
171     function isOwner() public view returns (bool) {
172         return msg.sender == _owner;
173     }
174 
175     /**
176      * @dev Allows the current owner to relinquish control of the contract.
177      * @notice Renouncing to ownership will leave the contract without an owner.
178      * It will not be possible to call the functions with the `onlyOwner`
179      * modifier anymore.
180      */
181     function renounceOwnership() public onlyOwner {
182         emit OwnershipTransferred(_owner, address(0));
183         _owner = address(0);
184     }
185 
186     /**
187      * @dev Allows the current owner to transfer control of the contract to a newOwner.
188      * @param newOwner The address to transfer ownership to.
189      */
190     function transferOwnership(address newOwner) public onlyOwner {
191         _transferOwnership(newOwner);
192     }
193 
194     /**
195      * @dev Transfers control of the contract to a newOwner.
196      * @param newOwner The address to transfer ownership to.
197      */
198     function _transferOwnership(address newOwner) internal {
199         require(newOwner != address(0));
200         emit OwnershipTransferred(_owner, newOwner);
201         _owner = newOwner;
202     }
203 }
204 
205 /**
206  * @title Roles
207  * @dev Library for managing addresses assigned to a Role.
208  */
209 library Roles {
210     struct Role {
211         mapping (address => bool) bearer;
212     }
213 
214     /**
215      * @dev give an account access to this role
216      */
217     function add(Role storage role, address account) internal {
218         require(account != address(0));
219         require(!has(role, account));
220 
221         role.bearer[account] = true;
222     }
223 
224     /**
225      * @dev remove an account's access to this role
226      */
227     function remove(Role storage role, address account) internal {
228         require(account != address(0));
229         require(has(role, account));
230 
231         role.bearer[account] = false;
232     }
233 
234     /**
235      * @dev check if an account has this role
236      * @return bool
237      */
238     function has(Role storage role, address account) internal view returns (bool) {
239         require(account != address(0));
240         return role.bearer[account];
241     }
242 }
243 
244 contract MinterRole is Ownable {
245     using Roles for Roles.Role;
246 
247     event MinterAdded(address indexed account);
248     event MinterRemoved(address indexed account);
249 
250     Roles.Role private _minters;
251 
252     constructor () internal {
253         _addMinter(msg.sender);
254     }
255 
256     modifier onlyMinter() {
257         require(isMinter(msg.sender));
258         _;
259     }
260 
261     function isMinter(address account) public view returns (bool) {
262         return _minters.has(account);
263     }
264 
265     function addMinter(address account) public onlyOwner {
266         _addMinter(account);
267     }
268 
269     function removeMinter(address account) public onlyOwner {
270       _removeMinter(account);
271     }
272 
273     function renounceMinter() public {
274         _removeMinter(msg.sender);
275     }
276 
277     function _addMinter(address account) internal {
278         _minters.add(account);
279         emit MinterAdded(account);
280     }
281 
282     function _removeMinter(address account) internal {
283         _minters.remove(account);
284         emit MinterRemoved(account);
285     }
286 }
287 
288 contract PauserRole is Ownable {
289     using Roles for Roles.Role;
290 
291     event PauserAdded(address indexed account);
292     event PauserRemoved(address indexed account);
293 
294     Roles.Role private _pausers;
295 
296     constructor () internal {
297         _addPauser(msg.sender);
298     }
299 
300     modifier onlyPauser() {
301         require(isPauser(msg.sender));
302         _;
303     }
304 
305     function isPauser(address account) public view returns (bool) {
306         return _pausers.has(account);
307     }
308 
309     function addPauser(address account) public onlyOwner {
310         _addPauser(account);
311     }
312 
313     function removePauser(address account) public onlyOwner {
314       _removePauser(account);
315     }
316 
317     function renouncePauser() public {
318         _removePauser(msg.sender);
319     }
320 
321     function _addPauser(address account) internal {
322         _pausers.add(account);
323         emit PauserAdded(account);
324     }
325 
326     function _removePauser(address account) internal {
327         _pausers.remove(account);
328         emit PauserRemoved(account);
329     }
330 }
331 
332 /**
333  * @title Pausable
334  * @dev Base contract which allows children to implement an emergency stop mechanism.
335  */
336 contract Pausable is PauserRole {
337     event Paused(address account);
338     event Unpaused(address account);
339 
340     bool private _paused;
341 
342     constructor () internal {
343         _paused = false;
344     }
345 
346     /**
347      * @return true if the contract is paused, false otherwise.
348      */
349     function paused() public view returns (bool) {
350         return _paused;
351     }
352 
353     /**
354      * @dev Modifier to make a function callable only when the contract is not paused.
355      */
356     modifier whenNotPaused() {
357         require(!_paused);
358         _;
359     }
360 
361     /**
362      * @dev Modifier to make a function callable only when the contract is paused.
363      */
364     modifier whenPaused() {
365         require(_paused);
366         _;
367     }
368 
369     /**
370      * @dev called by the owner to pause, triggers stopped state
371      */
372     function pause() public onlyPauser whenNotPaused {
373         _paused = true;
374         emit Paused(msg.sender);
375     }
376 
377     /**
378      * @dev called by the owner to unpause, returns to normal state
379      */
380     function unpause() public onlyPauser whenPaused {
381         _paused = false;
382         emit Unpaused(msg.sender);
383     }
384 }
385 
386 contract AdminRole is Ownable {
387     using Roles for Roles.Role;
388 
389     event AdminAdded(address indexed account);
390     event AdminRemoved(address indexed account);
391 
392     Roles.Role private _admins;
393 
394     constructor () internal {
395         _addAdmin(msg.sender);
396     }
397 
398     modifier onlyAdmin() {
399         require(isAdmin(msg.sender));
400         _;
401     }
402 
403     function isAdmin(address account) public view returns (bool) {
404         return _admins.has(account);
405     }
406 
407     function addAdmin(address account) public onlyOwner {
408         _addAdmin(account);
409     }
410 
411     function removeAdmin(address account) public onlyOwner {
412       _removeAdmin(account);
413     }
414 
415     function renounceAdmin() public {
416         _removeAdmin(msg.sender);
417     }
418 
419     function _addAdmin(address account) internal {
420         _admins.add(account);
421         emit AdminAdded(account);
422     }
423 
424     function _removeAdmin(address account) internal {
425         _admins.remove(account);
426         emit AdminRemoved(account);
427     }
428 }
429 
430 contract CommonConfig
431 {
432     uint32 constant public SECONDS_PER_DAY = 5 * 60; //fix me 测试时间修改为5分钟 //86400;
433 
434     uint32 constant public BASE_RATIO = 10000;
435 }
436 
437 /**
438  * @title IERC165
439  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
440  */
441 interface IERC165 {
442     /**
443      * @notice Query if a contract implements an interface
444      * @param interfaceId The interface identifier, as specified in ERC-165
445      * @dev Interface identification is specified in ERC-165. This function
446      * uses less than 30,000 gas.
447      */
448     function supportsInterface(bytes4 interfaceId) external view returns (bool);
449 }
450 
451 /**
452  * @title ERC165
453  * @author Matt Condon (@shrugs)
454  * @dev Implements ERC165 using a lookup table.
455  */
456 contract ERC165 is IERC165 {
457     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
458     /**
459      * 0x01ffc9a7 ===
460      *     bytes4(keccak256('supportsInterface(bytes4)'))
461      */
462 
463     /**
464      * @dev a mapping of interface id to whether or not it's supported
465      */
466     mapping(bytes4 => bool) private _supportedInterfaces;
467 
468     /**
469      * @dev A contract implementing SupportsInterfaceWithLookup
470      * implement ERC165 itself
471      */
472     constructor () internal {
473         _registerInterface(_InterfaceId_ERC165);
474     }
475 
476     /**
477      * @dev implement supportsInterface(bytes4) using a lookup table
478      */
479     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
480         return _supportedInterfaces[interfaceId];
481     }
482 
483     /**
484      * @dev internal method for registering an interface
485      */
486     function _registerInterface(bytes4 interfaceId) internal {
487         require(interfaceId != 0xffffffff);
488         _supportedInterfaces[interfaceId] = true;
489     }
490 }
491 
492 /**
493  * @title ERC721 Non-Fungible Token Standard basic interface
494  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
495  */
496 contract IERC721 is IERC165 {
497     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
498     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
499     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
500 
501     function balanceOf(address owner) public view returns (uint256 balance);
502     function ownerOf(uint256 tokenId) public view returns (address owner);
503 
504     function approve(address to, uint256 tokenId) public;
505     function getApproved(uint256 tokenId) public view returns (address operator);
506 
507     function setApprovalForAll(address operator, bool _approved) public;
508     function isApprovedForAll(address owner, address operator) public view returns (bool);
509 
510     function transferFrom(address from, address to, uint256 tokenId) public;
511     function safeTransferFrom(address from, address to, uint256 tokenId) public;
512 
513     function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) public;
514 }
515 
516 /**
517  * @title ERC721 token receiver interface
518  * @dev Interface for any contract that wants to support safeTransfers
519  * from ERC721 asset contracts.
520  */
521 contract IERC721Receiver {
522     /**
523      * @notice Handle the receipt of an NFT
524      * @dev The ERC721 smart contract calls this function on the recipient
525      * after a `safeTransfer`. This function MUST return the function selector,
526      * otherwise the caller will revert the transaction. The selector to be
527      * returned can be obtained as `this.onERC721Received.selector`. This
528      * function MAY throw to revert and reject the transfer.
529      * Note: the ERC721 contract address is always the message sender.
530      * @param operator The address which called `safeTransferFrom` function
531      * @param from The address which previously owned the token
532      * @param tokenId The NFT identifier which is being transferred
533      * @param data Additional data with no specified format
534      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
535      */
536     function onERC721Received(address operator, address from, uint256 tokenId, bytes data) public returns (bytes4);
537 }
538 
539 contract ERC721Holder is IERC721Receiver {
540     function onERC721Received(address, address, uint256, bytes) public returns (bytes4) {
541         return this.onERC721Received.selector;
542     }
543 }
544 
545 /**
546  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
547  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
548  */
549 contract IERC721Enumerable is IERC721 {
550     function totalSupply() public view returns (uint256);
551     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
552 
553     function tokenByIndex(uint256 index) public view returns (uint256);
554 }
555 
556 /**
557  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
558  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
559  */
560 contract IERC721Metadata is IERC721 {
561     function name() external view returns (string);
562     function symbol() external view returns (string);
563     function tokenURI(uint256 tokenId) external view returns (string);
564 }
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
568  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
569  */
570 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
571 }
572 
573 /**
574  * @title ERC721 Non-Fungible Token Standard basic implementation
575  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
576  */
577 contract ERC721 is ERC165, IERC721 {
578     using SafeMath for uint256;
579     using Address for address;
580 
581     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
582     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
583     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
584 
585     // Mapping from token ID to owner
586     mapping (uint256 => address) private _tokenOwner;
587 
588     // Mapping from token ID to approved address
589     mapping (uint256 => address) private _tokenApprovals;
590 
591     // Mapping from owner to number of owned token
592     mapping (address => uint256) private _ownedTokensCount;
593 
594     // Mapping from owner to operator approvals
595     mapping (address => mapping (address => bool)) private _operatorApprovals;
596 
597     bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
598     /*
599      * 0x80ac58cd ===
600      *     bytes4(keccak256('balanceOf(address)')) ^
601      *     bytes4(keccak256('ownerOf(uint256)')) ^
602      *     bytes4(keccak256('approve(address,uint256)')) ^
603      *     bytes4(keccak256('getApproved(uint256)')) ^
604      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
605      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
606      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
607      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
608      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
609      */
610 
611     constructor () public {
612         // register the supported interfaces to conform to ERC721 via ERC165
613         _registerInterface(_InterfaceId_ERC721);
614     }
615 
616     /**
617      * @dev Gets the balance of the specified address
618      * @param owner address to query the balance of
619      * @return uint256 representing the amount owned by the passed address
620      */
621     function balanceOf(address owner) public view returns (uint256) {
622         require(owner != address(0));
623         return _ownedTokensCount[owner];
624     }
625 
626     /**
627      * @dev Gets the owner of the specified token ID
628      * @param tokenId uint256 ID of the token to query the owner of
629      * @return owner address currently marked as the owner of the given token ID
630      */
631     function ownerOf(uint256 tokenId) public view returns (address) {
632         address owner = _tokenOwner[tokenId];
633         require(owner != address(0));
634         return owner;
635     }
636 
637     /**
638      * @dev Approves another address to transfer the given token ID
639      * The zero address indicates there is no approved address.
640      * There can only be one approved address per token at a given time.
641      * Can only be called by the token owner or an approved operator.
642      * @param to address to be approved for the given token ID
643      * @param tokenId uint256 ID of the token to be approved
644      */
645     function approve(address to, uint256 tokenId) public {
646         address owner = ownerOf(tokenId);
647         require(to != owner);
648         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
649 
650         _tokenApprovals[tokenId] = to;
651         emit Approval(owner, to, tokenId);
652     }
653 
654     /**
655      * @dev Gets the approved address for a token ID, or zero if no address set
656      * Reverts if the token ID does not exist.
657      * @param tokenId uint256 ID of the token to query the approval of
658      * @return address currently approved for the given token ID
659      */
660     function getApproved(uint256 tokenId) public view returns (address) {
661         require(_exists(tokenId));
662         return _tokenApprovals[tokenId];
663     }
664 
665     /**
666      * @dev Sets or unsets the approval of a given operator
667      * An operator is allowed to transfer all tokens of the sender on their behalf
668      * @param to operator address to set the approval
669      * @param approved representing the status of the approval to be set
670      */
671     function setApprovalForAll(address to, bool approved) public {
672         require(to != msg.sender);
673         _operatorApprovals[msg.sender][to] = approved;
674         emit ApprovalForAll(msg.sender, to, approved);
675     }
676 
677     /**
678      * @dev Tells whether an operator is approved by a given owner
679      * @param owner owner address which you want to query the approval of
680      * @param operator operator address which you want to query the approval of
681      * @return bool whether the given operator is approved by the given owner
682      */
683     function isApprovedForAll(address owner, address operator) public view returns (bool) {
684         return _operatorApprovals[owner][operator];
685     }
686 
687     /**
688      * @dev Transfers the ownership of a given token ID to another address
689      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
690      * Requires the msg sender to be the owner, approved, or operator
691      * @param from current owner of the token
692      * @param to address to receive the ownership of the given token ID
693      * @param tokenId uint256 ID of the token to be transferred
694     */
695     function transferFrom(address from, address to, uint256 tokenId) public {
696         require(_isApprovedOrOwner(msg.sender, tokenId));
697         require(to != address(0));
698 
699         _clearApproval(from, tokenId);
700         _removeTokenFrom(from, tokenId);
701         _addTokenTo(to, tokenId);
702 
703         emit Transfer(from, to, tokenId);
704     }
705 
706     /**
707      * @dev Safely transfers the ownership of a given token ID to another address
708      * If the target address is a contract, it must implement `onERC721Received`,
709      * which is called upon a safe transfer, and return the magic value
710      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
711      * the transfer is reverted.
712      *
713      * Requires the msg sender to be the owner, approved, or operator
714      * @param from current owner of the token
715      * @param to address to receive the ownership of the given token ID
716      * @param tokenId uint256 ID of the token to be transferred
717     */
718     function safeTransferFrom(address from, address to, uint256 tokenId) public {
719         // solium-disable-next-line arg-overflow
720         safeTransferFrom(from, to, tokenId, "");
721     }
722 
723     /**
724      * @dev Safely transfers the ownership of a given token ID to another address
725      * If the target address is a contract, it must implement `onERC721Received`,
726      * which is called upon a safe transfer, and return the magic value
727      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
728      * the transfer is reverted.
729      * Requires the msg sender to be the owner, approved, or operator
730      * @param from current owner of the token
731      * @param to address to receive the ownership of the given token ID
732      * @param tokenId uint256 ID of the token to be transferred
733      * @param _data bytes data to send along with a safe transfer check
734      */
735     function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public {
736         transferFrom(from, to, tokenId);
737         // solium-disable-next-line arg-overflow
738         require(_checkOnERC721Received(from, to, tokenId, _data));
739     }
740 
741     /**
742      * @dev Returns whether the specified token exists
743      * @param tokenId uint256 ID of the token to query the existence of
744      * @return whether the token exists
745      */
746     function _exists(uint256 tokenId) internal view returns (bool) {
747         address owner = _tokenOwner[tokenId];
748         return owner != address(0);
749     }
750 
751     /**
752      * @dev Returns whether the given spender can transfer a given token ID
753      * @param spender address of the spender to query
754      * @param tokenId uint256 ID of the token to be transferred
755      * @return bool whether the msg.sender is approved for the given token ID,
756      *    is an operator of the owner, or is the owner of the token
757      */
758     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
759         address owner = ownerOf(tokenId);
760         // Disable solium check because of
761         // https://github.com/duaraghav8/Solium/issues/175
762         // solium-disable-next-line operator-whitespace
763         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
764     }
765 
766     /**
767      * @dev Internal function to mint a new token
768      * Reverts if the given token ID already exists
769      * @param to The address that will own the minted token
770      * @param tokenId uint256 ID of the token to be minted by the msg.sender
771      */
772     function _mint(address to, uint256 tokenId) internal {
773         require(to != address(0));
774         _addTokenTo(to, tokenId);
775         emit Transfer(address(0), to, tokenId);
776     }
777 
778     /**
779      * @dev Internal function to burn a specific token
780      * Reverts if the token does not exist
781      * @param tokenId uint256 ID of the token being burned by the msg.sender
782      */
783     function _burn(address owner, uint256 tokenId) internal {
784         _clearApproval(owner, tokenId);
785         _removeTokenFrom(owner, tokenId);
786         emit Transfer(owner, address(0), tokenId);
787     }
788 
789     /**
790      * @dev Internal function to add a token ID to the list of a given address
791      * Note that this function is left internal to make ERC721Enumerable possible, but is not
792      * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
793      * @param to address representing the new owner of the given token ID
794      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
795      */
796     function _addTokenTo(address to, uint256 tokenId) internal {
797         require(_tokenOwner[tokenId] == address(0));
798         _tokenOwner[tokenId] = to;
799         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
800     }
801 
802     /**
803      * @dev Internal function to remove a token ID from the list of a given address
804      * Note that this function is left internal to make ERC721Enumerable possible, but is not
805      * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
806      * and doesn't clear approvals.
807      * @param from address representing the previous owner of the given token ID
808      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
809      */
810     function _removeTokenFrom(address from, uint256 tokenId) internal {
811         require(ownerOf(tokenId) == from);
812         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
813         _tokenOwner[tokenId] = address(0);
814     }
815 
816     /**
817      * @dev Internal function to invoke `onERC721Received` on a target address
818      * The call is not executed if the target address is not a contract
819      * @param from address representing the previous owner of the given token ID
820      * @param to target address that will receive the tokens
821      * @param tokenId uint256 ID of the token to be transferred
822      * @param _data bytes optional data to send along with the call
823      * @return whether the call correctly returned the expected magic value
824      */
825     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes _data) internal returns (bool) {
826         if (!to.isContract()) {
827             return true;
828         }
829 
830         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
831         return (retval == _ERC721_RECEIVED);
832     }
833 
834     /**
835      * @dev Private function to clear current approval of a given token ID
836      * Reverts if the given address is not indeed the owner of the token
837      * @param owner owner of the token
838      * @param tokenId uint256 ID of the token to be transferred
839      */
840     function _clearApproval(address owner, uint256 tokenId) private {
841         require(ownerOf(tokenId) == owner);
842         if (_tokenApprovals[tokenId] != address(0)) {
843             _tokenApprovals[tokenId] = address(0);
844         }
845     }
846 }
847 
848 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
849     // Token name
850     string private _name;
851 
852     // Token symbol
853     string private _symbol;
854 
855     // Optional mapping for token URIs
856     mapping(uint256 => string) private _tokenURIs;
857 
858     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
859     /**
860      * 0x5b5e139f ===
861      *     bytes4(keccak256('name()')) ^
862      *     bytes4(keccak256('symbol()')) ^
863      *     bytes4(keccak256('tokenURI(uint256)'))
864      */
865 
866     /**
867      * @dev Constructor function
868      */
869     constructor (string name, string symbol) public {
870         _name = name;
871         _symbol = symbol;
872 
873         // register the supported interfaces to conform to ERC721 via ERC165
874         _registerInterface(InterfaceId_ERC721Metadata);
875     }
876 
877     /**
878      * @dev Gets the token name
879      * @return string representing the token name
880      */
881     function name() external view returns (string) {
882         return _name;
883     }
884 
885     /**
886      * @dev Gets the token symbol
887      * @return string representing the token symbol
888      */
889     function symbol() external view returns (string) {
890         return _symbol;
891     }
892 
893     /**
894      * @dev Returns an URI for a given token ID
895      * Throws if the token ID does not exist. May return an empty string.
896      * @param tokenId uint256 ID of the token to query
897      */
898     function tokenURI(uint256 tokenId) external view returns (string) {
899         require(_exists(tokenId));
900         return _tokenURIs[tokenId];
901     }
902 
903     /**
904      * @dev Internal function to set the token URI for a given token
905      * Reverts if the token ID does not exist
906      * @param tokenId uint256 ID of the token to set its URI
907      * @param uri string URI to assign
908      */
909     function _setTokenURI(uint256 tokenId, string uri) internal {
910         require(_exists(tokenId));
911         _tokenURIs[tokenId] = uri;
912     }
913 
914     /**
915      * @dev Internal function to burn a specific token
916      * Reverts if the token does not exist
917      * @param owner owner of the token to burn
918      * @param tokenId uint256 ID of the token being burned by the msg.sender
919      */
920     function _burn(address owner, uint256 tokenId) internal {
921         super._burn(owner, tokenId);
922 
923         // Clear metadata (if any)
924         if (bytes(_tokenURIs[tokenId]).length != 0) {
925             delete _tokenURIs[tokenId];
926         }
927     }
928 }
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
947     bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
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
960         _registerInterface(_InterfaceId_ERC721Enumerable);
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
994      * @dev Internal function to add a token ID to the list of a given address
995      * This function is internal due to language limitations, see the note in ERC721.sol.
996      * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
997      * @param to address representing the new owner of the given token ID
998      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
999      */
1000     function _addTokenTo(address to, uint256 tokenId) internal {
1001         super._addTokenTo(to, tokenId);
1002         uint256 length = _ownedTokens[to].length;
1003         _ownedTokens[to].push(tokenId);
1004         _ownedTokensIndex[tokenId] = length;
1005     }
1006 
1007     /**
1008      * @dev Internal function to remove a token ID from the list of a given address
1009      * This function is internal due to language limitations, see the note in ERC721.sol.
1010      * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
1011      * and doesn't clear approvals.
1012      * @param from address representing the previous owner of the given token ID
1013      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1014      */
1015     function _removeTokenFrom(address from, uint256 tokenId) internal {
1016         super._removeTokenFrom(from, tokenId);
1017 
1018         // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1019         // then delete the last slot.
1020         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1021         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1022         uint256 lastToken = _ownedTokens[from][lastTokenIndex];
1023 
1024         _ownedTokens[from][tokenIndex] = lastToken;
1025         // This also deletes the contents at the last position of the array
1026         _ownedTokens[from].length--;
1027 
1028         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1029         // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
1030         // the lastToken to the first position, and then dropping the element placed in the last position of the list
1031 
1032         _ownedTokensIndex[tokenId] = 0;
1033         _ownedTokensIndex[lastToken] = tokenIndex;
1034     }
1035 
1036     /**
1037      * @dev Internal function to mint a new token
1038      * Reverts if the given token ID already exists
1039      * @param to address the beneficiary that will own the minted token
1040      * @param tokenId uint256 ID of the token to be minted by the msg.sender
1041      */
1042     function _mint(address to, uint256 tokenId) internal {
1043         super._mint(to, tokenId);
1044 
1045         _allTokensIndex[tokenId] = _allTokens.length;
1046         _allTokens.push(tokenId);
1047     }
1048 
1049     /**
1050      * @dev Internal function to burn a specific token
1051      * Reverts if the token does not exist
1052      * @param owner owner of the token to burn
1053      * @param tokenId uint256 ID of the token being burned by the msg.sender
1054      */
1055     function _burn(address owner, uint256 tokenId) internal {
1056         super._burn(owner, tokenId);
1057 
1058         // Reorg all tokens array
1059         uint256 tokenIndex = _allTokensIndex[tokenId];
1060         uint256 lastTokenIndex = _allTokens.length.sub(1);
1061         uint256 lastToken = _allTokens[lastTokenIndex];
1062 
1063         _allTokens[tokenIndex] = lastToken;
1064         _allTokens[lastTokenIndex] = 0;
1065 
1066         _allTokens.length--;
1067         _allTokensIndex[tokenId] = 0;
1068         _allTokensIndex[lastToken] = tokenIndex;
1069     }
1070 }
1071 
1072 /**
1073  * @title Full ERC721 Token
1074  * This implementation includes all the required and some optional functionality of the ERC721 standard
1075  * Moreover, it includes approve all functionality using operator terminology
1076  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1077  */
1078 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1079     constructor (string name, string symbol) ERC721Metadata(name, symbol) public {}
1080 }
1081 
1082 contract ITTicket is ERC721Full, AdminRole, Pausable
1083 {
1084     using SafeMath for uint256;
1085     using SafeMath for uint32;
1086     using Address for address;
1087 
1088     enum TICKET_TYPE
1089     {
1090         TICKET_TYPE_NULL,
1091         TICKET_TYPE_NORMAL,
1092         TICKET_TYPE_RARE,
1093         TICKET_TYPE_LEGENDARY
1094     }
1095 
1096     struct TicketHashInfo
1097     {
1098         address key;
1099         TICKET_TYPE ticketType;
1100         bool exchange;
1101     }
1102 
1103     struct TicketInfo
1104     {
1105         TICKET_TYPE ticketType;
1106         uint8 ticketFlag;
1107     }
1108 
1109     mapping(uint256 => TicketHashInfo) public _ticketHashMap;
1110 
1111     mapping(uint256 => TicketInfo) public _ticketMap;
1112 
1113     uint256 public _curTicketId;
1114 
1115     uint256 public _normalPrice;
1116 
1117     uint256 public _rarePrice;
1118 
1119     uint256 public _legendaryPrice;
1120 
1121     uint32 public _sellNormalTicketCount;
1122 
1123     uint32 public _rareTicketCount;
1124 
1125     uint32 public _legendaryTicketCount;
1126 
1127     uint32 public _baseAddRatio;
1128 
1129     uint32 public _rareAddCount;
1130 
1131     uint32 public _legendaryAddCount;
1132 
1133     uint8 public _ticketFlag;
1134 
1135     constructor() ERC721Full("ImperialThrone Ticket", "ITTK") public
1136     {
1137         _curTicketId = 1;
1138         _normalPrice = 0.01 ether;
1139         _rarePrice = 0.1 ether;
1140         _legendaryPrice = 1 ether;
1141 
1142         _rareTicketCount = 90;
1143 
1144         _legendaryTicketCount = 10;
1145 
1146         _baseAddRatio = 90;
1147 
1148         _rareAddCount = 9;
1149 
1150         _legendaryAddCount = 1;
1151 
1152         _ticketFlag = 1;
1153     }
1154 
1155     function setNormalTicketPrice(uint256 price) external onlyAdmin
1156     {
1157         _normalPrice = price;
1158     }
1159 
1160     function setRareTicketPrice(uint256 price) external onlyAdmin
1161     {
1162         _rarePrice = price;
1163     }
1164 
1165     function setLegendaryTicketPrice(uint256 price) external onlyAdmin
1166     {
1167         _legendaryPrice = price;
1168     }
1169 
1170     function setRareTicketCount(uint32 count) external onlyAdmin
1171     {
1172         _rareTicketCount = count;
1173     }
1174 
1175     function setLegendaryTicketCount(uint32 count) external onlyAdmin
1176     {
1177         _legendaryTicketCount = count;
1178     }
1179 
1180     function setBaseAddRatio(uint32 ratio) external onlyAdmin
1181     {
1182         _baseAddRatio = ratio;
1183     }
1184 
1185     function setRareAddCount(uint32 count) external onlyAdmin
1186     {
1187         _rareAddCount = count;
1188     }
1189 
1190     function setLegendaryAddCount(uint32 count) external onlyAdmin
1191     {
1192         _legendaryAddCount = count;
1193     }
1194 
1195     function setTicketFlag(uint8 flag) external onlyAdmin
1196     {
1197         _ticketFlag = flag;
1198     }
1199 
1200     function getHashExchangeState(uint256 id) external view returns(bool)
1201     {
1202         TicketHashInfo storage hashInfo = _ticketHashMap[id];
1203         return hashInfo.exchange;
1204     }
1205 
1206     function getTicketInfo(uint256 ticketId) external view returns(TICKET_TYPE ticketType, uint8 ticketFlag)
1207     {
1208         TicketInfo storage ticketInfo = _ticketMap[ticketId];
1209         ticketType = ticketInfo.ticketType;
1210         ticketFlag = ticketInfo.ticketFlag;
1211     }
1212 
1213     event AddTicketHash(uint256 id);
1214 
1215     function _addTicketHash(uint256 id, address key, TICKET_TYPE ticketType) internal
1216     {
1217         require(ticketType >= TICKET_TYPE.TICKET_TYPE_NORMAL
1218             && ticketType <= TICKET_TYPE.TICKET_TYPE_LEGENDARY);
1219 
1220         TicketHashInfo storage hashInfo = _ticketHashMap[id];
1221         require(hashInfo.ticketType == TICKET_TYPE.TICKET_TYPE_NULL);
1222                   
1223         hashInfo.key = key;
1224         hashInfo.ticketType = ticketType;
1225         hashInfo.exchange = false;
1226 
1227         emit AddTicketHash(id);
1228     }
1229 
1230     function addTicketHashList(uint256[] idList,
1231         address[] keyList, TICKET_TYPE[] ticketTypeList) external onlyAdmin
1232     {
1233         require(idList.length == keyList.length);
1234         require(idList.length == ticketTypeList.length);
1235 
1236         for(uint32 i = 0; i < idList.length; ++i)
1237         {
1238             _addTicketHash(idList[i], keyList[i], ticketTypeList[i]);
1239         }
1240     }
1241 
1242     function addTicketHash(uint256 id, address key, TICKET_TYPE ticketType) external onlyAdmin
1243     {
1244         _addTicketHash(id, key, ticketType);
1245     }
1246 
1247     function verifyOwnerTicket(uint256 id, uint8 v,
1248         bytes32 r, bytes32 s) external view returns(bool)
1249     {        
1250         TicketHashInfo storage hashInfo = _ticketHashMap[id];
1251 
1252         require(hashInfo.ticketType >= TICKET_TYPE.TICKET_TYPE_NORMAL
1253             && hashInfo.ticketType <= TICKET_TYPE.TICKET_TYPE_LEGENDARY);
1254 
1255         require(hashInfo.exchange == false);
1256 
1257         require(ecrecover(keccak256(abi.encodePacked(msg.sender)), v, r, s) == hashInfo.key);
1258 
1259         require(_ticketMap[_curTicketId].ticketType == TICKET_TYPE.TICKET_TYPE_NULL);
1260 
1261         return true;
1262     }
1263 
1264     event ExchangeOwnerTicket(uint8 indexed channelId, address owner, 
1265         uint256 id, uint256 ticketId, TICKET_TYPE ticketType);
1266 
1267     function _addOwnerTicket(uint8 channelId, address owner,
1268         uint256 id, uint8 v, bytes32 r, bytes32 s) internal
1269     {
1270         TicketHashInfo storage hashInfo = _ticketHashMap[id];
1271 
1272         require(hashInfo.ticketType >= TICKET_TYPE.TICKET_TYPE_NORMAL
1273             && hashInfo.ticketType <= TICKET_TYPE.TICKET_TYPE_LEGENDARY);
1274 
1275         require(hashInfo.exchange == false);
1276     
1277         require(ecrecover(keccak256(abi.encodePacked(owner)), v, r, s) == hashInfo.key);
1278 
1279         require(_ticketMap[_curTicketId].ticketType == TICKET_TYPE.TICKET_TYPE_NULL);
1280 
1281         //add ticket
1282         _mint(owner, _curTicketId);
1283 
1284         hashInfo.exchange = true;
1285     
1286         _ticketMap[_curTicketId].ticketType = hashInfo.ticketType;
1287 
1288         emit ExchangeOwnerTicket(channelId, owner, id, _curTicketId, hashInfo.ticketType);
1289 
1290         _curTicketId++;
1291     }
1292 
1293     function exchangeOwnerTicket(uint8 channelId, uint256 id,
1294         uint8 v, bytes32 r, bytes32 s) external
1295     {        
1296         _addOwnerTicket(channelId, msg.sender, id, v, r, s);
1297     }
1298 
1299     event BuyTicket(uint8 indexed channelId, address owner, TICKET_TYPE ticket_type);
1300 
1301     function buyTicket(uint8 channelId, TICKET_TYPE ticketType) public payable whenNotPaused
1302     {
1303         require(ticketType >= TICKET_TYPE.TICKET_TYPE_NORMAL
1304             && ticketType <= TICKET_TYPE.TICKET_TYPE_LEGENDARY);
1305 
1306         if(ticketType == TICKET_TYPE.TICKET_TYPE_NORMAL)
1307         {
1308             require(msg.value == _normalPrice);
1309             _sellNormalTicketCount++;
1310 
1311             if(_sellNormalTicketCount.div(_baseAddRatio) > 0
1312                 && _sellNormalTicketCount % _baseAddRatio == 0)
1313             {
1314                 _rareTicketCount = uint32(_rareTicketCount.add(_rareAddCount));
1315                 _legendaryTicketCount = uint32(_legendaryTicketCount.add(_legendaryAddCount));
1316             }
1317         }
1318         else if(ticketType == TICKET_TYPE.TICKET_TYPE_RARE)
1319         {
1320             require(_rareTicketCount > 0);
1321             require(msg.value == _rarePrice);
1322             _rareTicketCount--;
1323         }
1324         else if(ticketType == TICKET_TYPE.TICKET_TYPE_LEGENDARY)
1325         {
1326             require(_legendaryTicketCount > 0);
1327             require(msg.value == _legendaryPrice);
1328             _legendaryTicketCount--;
1329         }
1330 
1331         //add ticket
1332         _mint(msg.sender, _curTicketId);
1333 
1334         _ticketMap[_curTicketId].ticketType = ticketType;
1335         _ticketMap[_curTicketId].ticketFlag = _ticketFlag;
1336 
1337         _curTicketId++;
1338 
1339         emit BuyTicket(channelId, msg.sender, ticketType);
1340     }
1341 
1342     function withdrawETH(uint256 count) external onlyOwner
1343     {
1344         require(count <= address(this).balance);
1345         msg.sender.transfer(count);
1346     }
1347 }