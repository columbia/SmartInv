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
17 /**
18  * @title ERC165
19  * @author Matt Condon (@shrugs)
20  * @dev Implements ERC165 using a lookup table.
21  */
22 contract ERC165 is IERC165 {
23     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
24     /**
25      * 0x01ffc9a7 ===
26      *     bytes4(keccak256('supportsInterface(bytes4)'))
27      */
28 
29     /**
30      * @dev a mapping of interface id to whether or not it's supported
31      */
32     mapping(bytes4 => bool) private _supportedInterfaces;
33 
34     /**
35      * @dev A contract implementing SupportsInterfaceWithLookup
36      * implement ERC165 itself
37      */
38     constructor () internal {
39         _registerInterface(_INTERFACE_ID_ERC165);
40     }
41 
42     /**
43      * @dev implement supportsInterface(bytes4) using a lookup table
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
46         return _supportedInterfaces[interfaceId];
47     }
48 
49     /**
50      * @dev internal method for registering an interface
51      */
52     function _registerInterface(bytes4 interfaceId) internal {
53         require(interfaceId != 0xffffffff);
54         _supportedInterfaces[interfaceId] = true;
55     }
56 }
57 
58 /**
59  * @title ERC721 token receiver interface
60  * @dev Interface for any contract that wants to support safeTransfers
61  * from ERC721 asset contracts.
62  */
63 contract IERC721Receiver {
64     /**
65      * @notice Handle the receipt of an NFT
66      * @dev The ERC721 smart contract calls this function on the recipient
67      * after a `safeTransfer`. This function MUST return the function selector,
68      * otherwise the caller will revert the transaction. The selector to be
69      * returned can be obtained as `this.onERC721Received.selector`. This
70      * function MAY throw to revert and reject the transfer.
71      * Note: the ERC721 contract address is always the message sender.
72      * @param operator The address which called `safeTransferFrom` function
73      * @param from The address which previously owned the token
74      * @param tokenId The NFT identifier which is being transferred
75      * @param data Additional data with no specified format
76      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
77      */
78     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
79     public returns (bytes4);
80 }
81 
82 /**
83  * @title ERC721 Non-Fungible Token Standard basic interface
84  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
85  */
86 contract IERC721 is IERC165 {
87     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
88     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
89     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
90 
91     function balanceOf(address owner) public view returns (uint256 balance);
92     function ownerOf(uint256 tokenId) public view returns (address owner);
93 
94     function approve(address to, uint256 tokenId) public;
95     function getApproved(uint256 tokenId) public view returns (address operator);
96 
97     function setApprovalForAll(address operator, bool _approved) public;
98     function isApprovedForAll(address owner, address operator) public view returns (bool);
99 
100     function transferFrom(address from, address to, uint256 tokenId) public;
101     function safeTransferFrom(address from, address to, uint256 tokenId) public;
102 
103     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
104 }
105 
106 /**
107  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
108  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
109  */
110 contract IERC721Metadata is IERC721 {
111     function name() external view returns (string memory);
112     function symbol() external view returns (string memory);
113     function tokenURI(uint256 tokenId) external view returns (string memory);
114 }
115 
116 /**
117  * @title Roles
118  * @dev Library for managing addresses assigned to a Role.
119  */
120 library Roles {
121     struct Role {
122         mapping (address => bool) bearer;
123     }
124 
125     /**
126      * @dev give an account access to this role
127      */
128     function add(Role storage role, address account) internal {
129         require(account != address(0));
130         require(!has(role, account));
131 
132         role.bearer[account] = true;
133     }
134 
135     /**
136      * @dev remove an account's access to this role
137      */
138     function remove(Role storage role, address account) internal {
139         require(account != address(0));
140         require(has(role, account));
141 
142         role.bearer[account] = false;
143     }
144 
145     /**
146      * @dev check if an account has this role
147      * @return bool
148      */
149     function has(Role storage role, address account) internal view returns (bool) {
150         require(account != address(0));
151         return role.bearer[account];
152     }
153 }
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
195 /**
196  * @title Pausable
197  * @dev Base contract which allows children to implement an emergency stop mechanism.
198  */
199 contract Pausable is PauserRole {
200     event Paused(address account);
201     event Unpaused(address account);
202 
203     bool private _paused;
204 
205     constructor () internal {
206         _paused = false;
207     }
208 
209     /**
210      * @return true if the contract is paused, false otherwise.
211      */
212     function paused() public view returns (bool) {
213         return _paused;
214     }
215 
216     /**
217      * @dev Modifier to make a function callable only when the contract is not paused.
218      */
219     modifier whenNotPaused() {
220         require(!_paused);
221         _;
222     }
223 
224     /**
225      * @dev Modifier to make a function callable only when the contract is paused.
226      */
227     modifier whenPaused() {
228         require(_paused);
229         _;
230     }
231 
232     /**
233      * @dev called by the owner to pause, triggers stopped state
234      */
235     function pause() public onlyPauser whenNotPaused {
236         _paused = true;
237         emit Paused(msg.sender);
238     }
239 
240     /**
241      * @dev called by the owner to unpause, returns to normal state
242      */
243     function unpause() public onlyPauser whenPaused {
244         _paused = false;
245         emit Unpaused(msg.sender);
246     }
247 }
248 
249 contract MinterRole {
250     using Roles for Roles.Role;
251 
252     event MinterAdded(address indexed account);
253     event MinterRemoved(address indexed account);
254 
255     Roles.Role private _minters;
256 
257     constructor () internal {
258         _addMinter(msg.sender);
259     }
260 
261     modifier onlyMinter() {
262         require(isMinter(msg.sender));
263         _;
264     }
265 
266     function isMinter(address account) public view returns (bool) {
267         return _minters.has(account);
268     }
269 
270     function addMinter(address account) public onlyMinter {
271         _addMinter(account);
272     }
273 
274     function renounceMinter() public {
275         _removeMinter(msg.sender);
276     }
277 
278     function _addMinter(address account) internal {
279         _minters.add(account);
280         emit MinterAdded(account);
281     }
282 
283     function _removeMinter(address account) internal {
284         _minters.remove(account);
285         emit MinterRemoved(account);
286     }
287 }
288 
289 /**
290  * @title SafeMath
291  * @dev Unsigned math operations with safety checks that revert on error
292  */
293 library SafeMath {
294     /**
295     * @dev Multiplies two unsigned integers, reverts on overflow.
296     */
297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
299         // benefit is lost if 'b' is also tested.
300         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
301         if (a == 0) {
302             return 0;
303         }
304 
305         uint256 c = a * b;
306         require(c / a == b);
307 
308         return c;
309     }
310 
311     /**
312     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
313     */
314     function div(uint256 a, uint256 b) internal pure returns (uint256) {
315         // Solidity only automatically asserts when dividing by 0
316         require(b > 0);
317         uint256 c = a / b;
318         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
319 
320         return c;
321     }
322 
323     /**
324     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
325     */
326     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
327         require(b <= a);
328         uint256 c = a - b;
329 
330         return c;
331     }
332 
333     /**
334     * @dev Adds two unsigned integers, reverts on overflow.
335     */
336     function add(uint256 a, uint256 b) internal pure returns (uint256) {
337         uint256 c = a + b;
338         require(c >= a);
339 
340         return c;
341     }
342 
343     /**
344     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
345     * reverts when dividing by zero.
346     */
347     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
348         require(b != 0);
349         return a % b;
350     }
351 }
352 
353 /**
354  * Utility library of inline functions on addresses
355  */
356 library Address {
357     /**
358      * Returns whether the target address is a contract
359      * @dev This function will return false if invoked during the constructor of a contract,
360      * as the code is not actually created until after the constructor finishes.
361      * @param account address of the account to check
362      * @return whether the target address is a contract
363      */
364     function isContract(address account) internal view returns (bool) {
365         uint256 size;
366         // XXX Currently there is no better way to check if there is a contract in an address
367         // than to check the size of the code at that address.
368         // See https://ethereum.stackexchange.com/a/14016/36603
369         // for more details about how this works.
370         // TODO Check this again before the Serenity release, because all addresses will be
371         // contracts then.
372         // solhint-disable-next-line no-inline-assembly
373         assembly { size := extcodesize(account) }
374         return size > 0;
375     }
376 }
377 
378 library Strings {
379     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
380         bytes memory _ba = bytes(_a);
381         bytes memory _bb = bytes(_b);
382         bytes memory _bc = bytes(_c);
383         bytes memory _bd = bytes(_d);
384         bytes memory _be = bytes(_e);
385         bytes memory babcde = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
386         uint k = 0;
387         uint i = 0;
388         for (i = 0; i < _ba.length; i++) {
389             babcde[k++] = _ba[i];
390         }
391         for (i = 0; i < _bb.length; i++) {
392             babcde[k++] = _bb[i];
393         }
394         for (i = 0; i < _bc.length; i++) {
395             babcde[k++] = _bc[i];
396         }
397         for (i = 0; i < _bd.length; i++) {
398             babcde[k++] = _bd[i];
399         }
400         for (i = 0; i < _be.length; i++) {
401             babcde[k++] = _be[i];
402         }
403         return string(babcde);
404     }
405 
406     function strConcat(string  memory _a, string  memory _b, string  memory _c, string  memory _d) internal pure returns (string  memory) {
407         return strConcat(_a, _b, _c, _d, "");
408     }
409 
410     function strConcat(string  memory _a, string  memory _b, string  memory _c) internal pure returns (string  memory) {
411         return strConcat(_a, _b, _c, "", "");
412     }
413 
414     function strConcat(string  memory _a, string  memory _b) internal pure returns (string  memory) {
415         return strConcat(_a, _b, "", "", "");
416     }
417 
418     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
419         if (_i == 0) {
420             return "0";
421         }
422         uint j = _i;
423         uint len;
424         while (j != 0) {
425             len++;
426             j /= 10;
427         }
428         bytes memory bstr = new bytes(len);
429         uint k = len - 1;
430         while (_i != 0) {
431             bstr[k--] = byte(uint8(48 + _i % 10));
432             _i /= 10;
433         }
434         return string(bstr);
435     }
436 
437     function split(bytes memory _base, uint8[] memory _lengths) internal pure returns (bytes[] memory arr) {
438         uint _offset = 0;
439         bytes[] memory splitArr = new bytes[](_lengths.length);
440 
441         for(uint i = 0; i < _lengths.length; i++) {
442             bytes memory _tmpBytes = new bytes(_lengths[i]);
443 
444             for(uint j = 0; j < _lengths[i]; j++)
445                 _tmpBytes[j] = _base[_offset+j];
446 
447             splitArr[i] = _tmpBytes;
448             _offset += _lengths[i];
449         }
450 
451         return splitArr;
452     }
453 }
454 
455 
456 
457 
458 
459 
460 
461 
462 
463 /**
464  * @title F1 Delta Time Non-Fungible Token 
465  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
466  */
467 contract DeltaTimeNFTBase is ERC165, IERC721, IERC721Metadata, Pausable, MinterRole {
468 
469     using SafeMath for uint256;
470     using Address for address;
471     using Strings for string;
472 
473     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
474     /*
475      * 0x80ac58cd ===
476      *     bytes4(keccak256('balanceOf(address)')) ^
477      *     bytes4(keccak256('ownerOf(uint256)')) ^
478      *     bytes4(keccak256('approve(address,uint256)')) ^
479      *     bytes4(keccak256('getApproved(uint256)')) ^
480      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
481      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
482      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
483      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
484      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
485      */
486 
487     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
488     /**
489      * 0x5b5e139f ===
490      *     bytes4(keccak256('name()')) ^
491      *     bytes4(keccak256('symbol()')) ^
492      *     bytes4(keccak256('tokenURI(uint256)'))
493      */
494 
495     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
496     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
497     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
498 
499     // Token name
500     string private _name;
501 
502     // Token symbol
503     string private _symbol;
504 
505     // Token URI prefix
506     string private _baseTokenURI;
507 
508     // Flag representing if metadata migrated to IPFS
509     bool private _ipfsMigrated;
510 
511     // Token total Supply
512     uint256 private _totalSupply;
513 
514     // Mapping from token ID to owner
515     mapping (uint256 => address) private _tokenOwner;
516 
517     // Mapping from token ID to approved address
518     mapping (uint256 => address) private _tokenApprovals;
519 
520     // Mapping Mapping from token ID to token URI
521     mapping(uint256 => string) private _tokenURIs;
522 
523     // Mapping Mapping from token ID to token properties
524     mapping (uint256 => uint256) private _tokenProperties;
525 
526     // Mapping from owner to number of owned token
527     mapping (address => uint256) private _ownedTokensCount;
528 
529     // Mapping from owner to operator approvals
530     mapping (address => mapping (address => bool)) private _operatorApprovals;
531 
532 
533     event TokenURI(uint256 indexed tokenId, string uri);
534 
535 
536     /**
537      * @dev Constructor function
538      */
539     constructor (string memory name, string memory symbol, string memory baseTokenURI) public {
540         _name = name;
541         _symbol = symbol;
542         _totalSupply = 0;
543         _baseTokenURI = baseTokenURI;
544         _ipfsMigrated = false;
545 
546         // register the supported interfaces to conform to ERC721 via ERC165
547         _registerInterface(_INTERFACE_ID_ERC721);
548         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
549     }
550 
551     /**
552      * @dev Gets the token name
553      * @return string representing the token name
554      */
555     function name() external view returns (string memory) {
556         return _name;
557     }
558 
559     /**
560      * @dev Gets the token symbol
561      * @return string representing the token symbol
562      */
563     function symbol() external view returns (string memory) {
564         return _symbol;
565     }
566 
567     /**
568      * @dev Gets the total amount of tokens stored by the contract
569      * @return uint256 representing the total amount of tokens
570      */
571     function totalSupply() public view returns (uint256) {
572         return _totalSupply;
573     }
574 
575     /**
576      * @dev Returns whether the specified token exists
577      * @param tokenId uint256 ID of the token to query the existence of
578      * @return whether the token exists
579      */
580     function exists(uint256 tokenId) external view returns (bool) {
581         return _exists(tokenId);
582     }
583 
584     /**
585      * @dev Sets IPFS migration flag true
586      */
587     function ipfsMigrationDone() public onlyMinter {
588         _ipfsMigrated = true;
589     }
590 
591     /**
592      * @dev public function to set the token URI for a given token
593      * Reverts if the token ID does not exist or metadata has migrated to IPFS
594      * @param tokenId uint256 ID of the token to set its URI
595      * @param uri string URI to assign
596      */
597     function setTokenURI(uint256 tokenId, string memory uri) public onlyMinter {
598         require(!_ipfsMigrated);
599         _setTokenURI(tokenId, uri);
600     }
601 
602     /**
603      * @dev Returns the URI for a given token ID
604      * Throws if the token ID does not exist. May return an empty string.
605      * @param tokenId uint256 ID of the token to query
606      */
607     function tokenURI(uint256 tokenId) external view returns (string memory) {
608         require(_exists(tokenId));
609 
610         if (bytes(_tokenURIs[tokenId]).length > 0)
611             return _tokenURIs[tokenId];
612 
613         return Strings.strConcat(baseTokenURI(),Strings.uint2str(tokenId));
614     }
615 
616     /**
617      * @dev Sets the prefix of token URI
618      * @param baseTokenURI token URI prefix to be set
619      */
620     function setBaseTokenURI(string memory baseTokenURI) public onlyMinter {
621         _baseTokenURI = baseTokenURI;
622     }
623 
624     /**
625      * @dev Returns prefix of token URI
626      * @return string representing the token URI prefix
627      */
628     function baseTokenURI() public view returns (string memory) {
629         return _baseTokenURI;
630     }
631 
632     /**
633      * @dev Returns the properties for a given token ID
634      * Throws if the token ID does not exist.
635      * @param tokenId uint256 ID of the token to query
636      */
637     function tokenProperties(uint256 tokenId) public view returns (uint256) {
638         require(_exists(tokenId));
639         return _tokenProperties[tokenId];
640     }
641 
642     /**
643      * @dev Gets the balance of the specified address
644      * @param owner address to query the balance of
645      * @return uint256 representing the amount owned by the passed address
646      */
647     function balanceOf(address owner) public view returns (uint256) {
648         require(owner != address(0));
649         return _ownedTokensCount[owner];
650     }
651 
652     /**
653      * @dev Gets the owner of the specified token ID
654      * @param tokenId uint256 ID of the token to query the owner of
655      * @return owner address currently marked as the owner of the given token ID
656      */
657     function ownerOf(uint256 tokenId) public view returns (address) {
658         address owner = _tokenOwner[tokenId];
659         require(owner != address(0));
660         return owner;
661     }
662 
663     /**
664      * @dev Approves another address to transfer the given token ID
665      * The zero address indicates there is no approved address.
666      * There can only be one approved address per token at a given time.
667      * Can only be called by the token owner or an approved operator.
668      * @param to address to be approved for the given token ID
669      * @param tokenId uint256 ID of the token to be approved
670      */
671     function approve(address to, uint256 tokenId) public whenNotPaused {
672         address owner = ownerOf(tokenId);
673         require(to != owner);
674         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
675 
676         _tokenApprovals[tokenId] = to;
677         emit Approval(owner, to, tokenId);
678     }
679 
680     /**
681      * @dev Gets the approved address for a token ID, or zero if no address set
682      * Reverts if the token ID does not exist.
683      * @param tokenId uint256 ID of the token to query the approval of
684      * @return address currently approved for the given token ID
685      */
686     function getApproved(uint256 tokenId) public view returns (address) {
687         require(_exists(tokenId));
688         return _tokenApprovals[tokenId];
689     }
690 
691     /**
692      * @dev Sets or unsets the approval of a given operator
693      * An operator is allowed to transfer all tokens of the sender on their behalf
694      * @param to operator address to set the approval
695      * @param approved representing the status of the approval to be set
696      */
697     function setApprovalForAll(address to, bool approved) public whenNotPaused {
698         require(to != msg.sender);
699         _operatorApprovals[msg.sender][to] = approved;
700         emit ApprovalForAll(msg.sender, to, approved);
701     }
702 
703     /**
704      * @dev Tells whether an operator is approved by a given owner
705      * @param owner owner address which you want to query the approval of
706      * @param operator operator address which you want to query the approval of
707      * @return bool whether the given operator is approved by the given owner
708      */
709     function isApprovedForAll(address owner, address operator) public view returns (bool) {
710         return _operatorApprovals[owner][operator];
711     }
712 
713     /**
714      * @dev Transfers the ownership of a given token ID to another address
715      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
716      * Requires the msg sender to be the owner, approved, or operator
717      * @param from current owner of the token
718      * @param to address to receive the ownership of the given token ID
719      * @param tokenId uint256 ID of the token to be transferred
720     */
721     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
722         require(_isApprovedOrOwner(msg.sender, tokenId));
723 
724         _transferFrom(from, to, tokenId);
725     }
726 
727     /**
728      * @dev Safely transfers the ownership of a given token ID to another address
729      * If the target address is a contract, it must implement `onERC721Received`,
730      * which is called upon a safe transfer, and return the magic value
731      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
732      * the transfer is reverted.
733      *
734      * Requires the msg sender to be the owner, approved, or operator
735      * @param from current owner of the token
736      * @param to address to receive the ownership of the given token ID
737      * @param tokenId uint256 ID of the token to be transferred
738     */
739     function safeTransferFrom(address from, address to, uint256 tokenId) public {
740         safeTransferFrom(from, to, tokenId, "");
741     }
742 
743     /**
744      * @dev Safely transfers the ownership of a given token ID to another address
745      * If the target address is a contract, it must implement `onERC721Received`,
746      * which is called upon a safe transfer, and return the magic value
747      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
748      * the transfer is reverted.
749      * Requires the msg sender to be the owner, approved, or operator
750      * @param from current owner of the token
751      * @param to address to receive the ownership of the given token ID
752      * @param tokenId uint256 ID of the token to be transferred
753      * @param _data bytes data to send along with a safe transfer check
754      */
755     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
756         transferFrom(from, to, tokenId);
757         require(_checkOnERC721Received(from, to, tokenId, _data));
758     }
759 
760     /**
761      * @dev Public function to mint a new token
762      * Reverts if the given token ID already exists
763      * @param to address The address that will own the minted token
764      * @param tokenId uint256 ID of the token to be minted
765      * @param uri string Metadata URI of the token to be minted
766      * @param tokenProps uint256 Properties of the token to be minted
767      */
768     function mint(address to, uint256 tokenId, string memory uri, uint256 tokenProps)
769         public onlyMinter
770     {
771         _mint(to, tokenId, uri, tokenProps);
772         _totalSupply += 1;
773     }
774 
775     /**
776      * @dev Public function to mint a batch of new tokens
777      * Reverts if some the given token IDs already exist
778      * @param to address[] List of addresses that will own the minted tokens
779      * @param tokenIds uint256[] List of IDs of the tokens to be minted
780      * @param tokenURIs bytes[] Concatenated metadata URIs of the tokens to be minted
781      * @param urisLengths uint8[] Lengths of the metadata URIs in the tokenURIs parameter
782      * @param tokenProps uint256[] List of properties of the tokens to be minted
783      */
784     function batchMint(
785         address[] memory to,
786         uint256[] memory tokenIds,
787         bytes memory tokenURIs,
788         uint8[] memory urisLengths,
789         uint256[] memory tokenProps)
790         public onlyMinter
791     {
792         require(tokenIds.length == to.length &&
793                 tokenIds.length == urisLengths.length &&
794                 tokenIds.length == tokenProps.length);
795         bytes[] memory uris = Strings.split(tokenURIs, urisLengths);
796         for (uint i = 0; i < tokenIds.length; i++) {
797             _mint(to[i], tokenIds[i], string(uris[i]), tokenProps[i]);
798         }
799         _totalSupply += tokenIds.length;
800     }
801 
802     /**
803      * @dev Returns whether the specified token exists
804      * @param tokenId uint256 ID of the token to query the existence of
805      * @return whether the token exists
806      */
807     function _exists(uint256 tokenId) internal view returns (bool) {
808         address owner = _tokenOwner[tokenId];
809         return owner != address(0);
810     }
811 
812     /**
813      * @dev Returns whether the given spender can transfer a given token ID
814      * @param spender address of the spender to query
815      * @param tokenId uint256 ID of the token to be transferred
816      * @return bool whether the msg.sender is approved for the given token ID,
817      *    is an operator of the owner, or is the owner of the token
818      */
819     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
820         address owner = ownerOf(tokenId);
821         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
822     }
823 
824     /**
825      * @dev Internal function to mint a new token
826      * Reverts if the given token ID already exists
827      * @param to The address that will own the minted token
828      * @param tokenId uint256 ID of the token to be minted
829      * @param uri string URI of the token to be minted metadata
830      * @param tokenProps uint256 properties of the token to be minted
831      */
832     function _mint(address to, uint256 tokenId, string memory uri, uint256 tokenProps) internal {
833         require(to != address(0));
834         require(!_exists(tokenId));
835 
836         _tokenOwner[tokenId] = to;
837         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
838         _setTokenURI(tokenId, uri);
839         _tokenProperties[tokenId] = tokenProps;
840 
841         emit Transfer(address(0), to, tokenId);
842     }
843 
844     /**
845      * @dev Internal function to set the token URI for a given token
846      * Reverts if the token ID does not exist
847      * @param tokenId uint256 ID of the token to set its URI
848      * @param uri string URI to assign
849      */
850     function _setTokenURI(uint256 tokenId, string memory uri) internal {
851         require(_exists(tokenId));
852         _tokenURIs[tokenId] = uri;
853         emit TokenURI(tokenId, uri);
854     }
855 
856     /**
857      * @dev Internal function to transfer ownership of a given token ID to another address.
858      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
859      * @param from current owner of the token
860      * @param to address to receive the ownership of the given token ID
861      * @param tokenId uint256 ID of the token to be transferred
862     */
863     function _transferFrom(address from, address to, uint256 tokenId) internal {
864         require(ownerOf(tokenId) == from);
865         require(to != address(0));
866 
867         _clearApproval(tokenId);
868 
869         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
870         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
871 
872         _tokenOwner[tokenId] = to;
873 
874         emit Transfer(from, to, tokenId);
875     }
876 
877     /**
878      * @dev Internal function to invoke `onERC721Received` on a target address
879      * The call is not executed if the target address is not a contract
880      * @param from address representing the previous owner of the given token ID
881      * @param to target address that will receive the tokens
882      * @param tokenId uint256 ID of the token to be transferred
883      * @param _data bytes optional data to send along with the call
884      * @return whether the call correctly returned the expected magic value
885      */
886     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
887         internal returns (bool)
888     {
889         if (!to.isContract()) {
890             return true;
891         }
892 
893         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
894         return (retval == _ERC721_RECEIVED);
895     }
896 
897     /**
898      * @dev Private function to clear current approval of a given token ID
899      * @param tokenId uint256 ID of the token to be transferred
900      */
901     function _clearApproval(uint256 tokenId) private {
902         if (_tokenApprovals[tokenId] != address(0)) {
903             _tokenApprovals[tokenId] = address(0);
904         }
905     }
906 }
907 
908 contract DeltaTimeNFT is DeltaTimeNFTBase {
909 
910   constructor (string memory baseTokenURI) public DeltaTimeNFTBase("F1® Delta Time", "F1DT", baseTokenURI) {
911   }
912 
913   function tokenType(uint256 tokenId) public view returns (uint256) {
914       uint256 properties = tokenProperties(tokenId);
915       return properties & 0xFF;
916   }
917 
918   function tokenSubType(uint256 tokenId) public view returns (uint256) {
919     uint256 properties = tokenProperties(tokenId);
920     return (properties & (0xFF << 8)) >> 8;
921   }
922 
923   function tokenTeam(uint256 tokenId) public view returns (uint256) {
924     uint256 properties = tokenProperties(tokenId);
925     return (properties & (0xFF << 16)) >> 16;
926   }
927 
928   function tokenSeason(uint256 tokenId) public view returns (uint256) {
929     uint256 properties = tokenProperties(tokenId);
930     return (properties & (0xFF << 24)) >> 24;
931   }
932 
933   function tokenRarity(uint256 tokenId) public view returns (uint256) {
934     uint256 properties = tokenProperties(tokenId);
935     return (properties & (0xFF << 32)) >> 32;
936   }
937 
938   function tokenTrack(uint256 tokenId) public view returns (uint256) {
939     // only CarNFT, DriverNFT, CarCompNFT, DriverCompNFT and TyreNFT has a track id
940     uint256 properties = tokenProperties(tokenId);
941     return (properties & (0xFF << 40)) >> 40;
942   }
943 
944   function tokenCollection(uint256 tokenId) public view returns (uint256) {
945     uint256 properties = tokenProperties(tokenId);
946     return (properties & (0xFFFF << 48)) >> 48;
947   }
948 
949   function tokenDriverNumber(uint256 tokenId) public view returns (uint256) {
950     // only Car and Driver has a driver id
951     uint256 properties = tokenProperties(tokenId);
952     return (properties & (0xFFFF << 64)) >> 64;
953   }
954 
955   function tokenRacingProperty1(uint256 tokenId) public view returns (uint256) {
956     uint256 properties = tokenProperties(tokenId);
957     return (properties & (0xFFFF << 80)) >> 80;
958   }
959 
960   function tokenRacingProperty2(uint256 tokenId) public view returns (uint256) {
961     uint256 properties = tokenProperties(tokenId);
962     return (properties & (0xFFFF << 96)) >> 96;
963   }
964 
965   function tokenRacingProperty3(uint256 tokenId) public view returns (uint256) {
966     uint256 properties = tokenProperties(tokenId);
967     return (properties & (0xFFFF << 112)) >> 112;
968   }
969 
970   function tokenLuck(uint256 tokenId) public view returns (uint256) {
971     uint256 properties = tokenProperties(tokenId);
972     return (properties & (0xFFFF << 128)) >> 128;
973   }
974 
975   function tokenEffect(uint256 tokenId) public view returns (uint256) {
976     uint256 properties = tokenProperties(tokenId);
977     return (properties & (0xFF << 144)) >> 144;
978   }
979 
980   function tokenSpecial1(uint256 tokenId) public view returns (uint256) {
981     uint256 properties = tokenProperties(tokenId);
982     return (properties & (0xFFFF << 152)) >> 152;
983   }
984 
985   function tokenSpecial2(uint256 tokenId) public view returns (uint256) {
986     uint256 properties = tokenProperties(tokenId);
987     return (properties & (0xFFFF << 168)) >> 168;
988   }
989 }