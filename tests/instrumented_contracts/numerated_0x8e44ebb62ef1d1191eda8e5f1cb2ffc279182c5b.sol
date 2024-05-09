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
464  * @title Non-Fungible Token
465  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
466  */
467 contract etherstar is ERC165, IERC721, IERC721Metadata, Pausable, MinterRole {
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
523     // Mapping Mapping from token ID to token DNAs
524     mapping (uint256 => uint256) private _dnas;
525 
526     // Mapping Mapping from token ID to token Name
527     mapping (uint256 => string) private _tokenNames;
528 
529     // Mapping from owner to number of owned token
530     mapping (address => uint256) private _ownedTokensCount;
531 
532     // Mapping from owner to operator approvals
533     mapping (address => mapping (address => bool)) private _operatorApprovals;
534 
535 
536     event TokenURI(uint256 indexed tokenId, string uri);
537 
538 
539     /**
540      * @dev Constructor function
541      */
542     constructor (string memory name, string memory symbol, string memory baseTokenURI) public {
543         _name = name;
544         _symbol = symbol;
545         _totalSupply = 0;
546         _baseTokenURI = baseTokenURI;
547         _ipfsMigrated = false;
548 
549         // register the supported interfaces to conform to ERC721 via ERC165
550         _registerInterface(_INTERFACE_ID_ERC721);
551         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
552     }
553 
554     /**
555      * @dev Gets the token name
556      * @return string representing the token name
557      */
558     function name() external view returns (string memory) {
559         return _name;
560     }
561 
562     /**
563      * @dev Gets the token symbol
564      * @return string representing the token symbol
565      */
566     function symbol() external view returns (string memory) {
567         return _symbol;
568     }
569 
570     /**
571      * @dev Gets the total amount of tokens stored by the contract
572      * @return uint256 representing the total amount of tokens
573      */
574     function totalSupply() public view returns (uint256) {
575         return _totalSupply;
576     }
577 
578     /**
579      * @dev Returns whether the specified token exists
580      * @param tokenId uint256 ID of the token to query the existence of
581      * @return whether the token exists
582      */
583     function exists(uint256 tokenId) external view returns (bool) {
584         return _exists(tokenId);
585     }
586 
587     /**
588      * @dev Sets IPFS migration flag true
589      */
590     function ipfsMigrationDone() public onlyMinter {
591         _ipfsMigrated = true;
592     }
593 
594     /**
595      * @dev public function to set the token URI for a given token
596      * Reverts if the token ID does not exist or metadata has migrated to IPFS
597      * @param tokenId uint256 ID of the token to set its URI
598      * @param uri string URI to assign
599      */
600     function setTokenURI(uint256 tokenId, string memory uri) public onlyMinter {
601         require(!_ipfsMigrated);
602         _setTokenURI(tokenId, uri);
603     }
604 
605     /**
606      * @dev Returns the URI for a given token ID
607      * Throws if the token ID does not exist. May return an empty string.
608      * @param tokenId uint256 ID of the token to query
609      */
610     function tokenURI(uint256 tokenId) external view returns (string memory) {
611         require(_exists(tokenId));
612 
613         if (bytes(_tokenURIs[tokenId]).length > 0)
614             return _tokenURIs[tokenId];
615 
616         return Strings.strConcat(baseTokenURI(),Strings.uint2str(tokenId));
617     }
618 
619     /**
620      * @dev Sets the prefix of token URI
621      * @param baseTokenURI token URI prefix to be set
622      */
623     function setBaseTokenURI(string memory baseTokenURI) public onlyMinter {
624         _baseTokenURI = baseTokenURI;
625     }
626 
627     /**
628      * @dev Returns prefix of token URI
629      * @return string representing the token URI prefix
630      */
631     function baseTokenURI() public view returns (string memory) {
632         return _baseTokenURI;
633     }
634 
635     /**
636      * @dev Returns the DNA for a given token ID
637      * Throws if the token ID does not exist.
638      * @param tokenId uint256 ID of the token to query
639      */
640     function tokenDNA(uint256 tokenId) public view returns (uint256) {
641         require(_exists(tokenId));
642         return _dnas[tokenId];
643     }
644 
645     /**
646      * @dev Returns the tokenName for a given token ID
647      * Throws if the token ID does not exist.
648      * @param tokenId uint256 ID of the token to query
649      */
650     function tokenName(uint256 tokenId) public view returns (string memory) {
651         require(_exists(tokenId));
652         return _tokenNames[tokenId];
653     }
654 
655     /**
656      * @dev Gets the balance of the specified address
657      * @param owner address to query the balance of
658      * @return uint256 representing the amount owned by the passed address
659      */
660     function balanceOf(address owner) public view returns (uint256) {
661         require(owner != address(0));
662         return _ownedTokensCount[owner];
663     }
664 
665     /**
666      * @dev Gets the owner of the specified token ID
667      * @param tokenId uint256 ID of the token to query the owner of
668      * @return owner address currently marked as the owner of the given token ID
669      */
670     function ownerOf(uint256 tokenId) public view returns (address) {
671         address owner = _tokenOwner[tokenId];
672         require(owner != address(0));
673         return owner;
674     }
675 
676     /**
677      * @dev Approves another address to transfer the given token ID
678      * The zero address indicates there is no approved address.
679      * There can only be one approved address per token at a given time.
680      * Can only be called by the token owner or an approved operator.
681      * @param to address to be approved for the given token ID
682      * @param tokenId uint256 ID of the token to be approved
683      */
684     function approve(address to, uint256 tokenId) public whenNotPaused {
685         address owner = ownerOf(tokenId);
686         require(to != owner);
687         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
688 
689         _tokenApprovals[tokenId] = to;
690         emit Approval(owner, to, tokenId);
691     }
692 
693     /**
694      * @dev Gets the approved address for a token ID, or zero if no address set
695      * Reverts if the token ID does not exist.
696      * @param tokenId uint256 ID of the token to query the approval of
697      * @return address currently approved for the given token ID
698      */
699     function getApproved(uint256 tokenId) public view returns (address) {
700         require(_exists(tokenId));
701         return _tokenApprovals[tokenId];
702     }
703 
704     /**
705      * @dev Sets or unsets the approval of a given operator
706      * An operator is allowed to transfer all tokens of the sender on their behalf
707      * @param to operator address to set the approval
708      * @param approved representing the status of the approval to be set
709      */
710     function setApprovalForAll(address to, bool approved) public whenNotPaused {
711         require(to != msg.sender);
712         _operatorApprovals[msg.sender][to] = approved;
713         emit ApprovalForAll(msg.sender, to, approved);
714     }
715 
716     /**
717      * @dev Tells whether an operator is approved by a given owner
718      * @param owner owner address which you want to query the approval of
719      * @param operator operator address which you want to query the approval of
720      * @return bool whether the given operator is approved by the given owner
721      */
722     function isApprovedForAll(address owner, address operator) public view returns (bool) {
723         return _operatorApprovals[owner][operator];
724     }
725 
726     /**
727      * @dev Transfers the ownership of a given token ID to another address
728      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
729      * Requires the msg sender to be the owner, approved, or operator
730      * @param from current owner of the token
731      * @param to address to receive the ownership of the given token ID
732      * @param tokenId uint256 ID of the token to be transferred
733     */
734     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
735         require(_isApprovedOrOwner(msg.sender, tokenId));
736 
737         _transferFrom(from, to, tokenId);
738     }
739 
740     /**
741      * @dev Safely transfers the ownership of a given token ID to another address
742      * If the target address is a contract, it must implement `onERC721Received`,
743      * which is called upon a safe transfer, and return the magic value
744      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
745      * the transfer is reverted.
746      *
747      * Requires the msg sender to be the owner, approved, or operator
748      * @param from current owner of the token
749      * @param to address to receive the ownership of the given token ID
750      * @param tokenId uint256 ID of the token to be transferred
751     */
752     function safeTransferFrom(address from, address to, uint256 tokenId) public {
753         safeTransferFrom(from, to, tokenId, "");
754     }
755 
756     /**
757      * @dev Safely transfers the ownership of a given token ID to another address
758      * If the target address is a contract, it must implement `onERC721Received`,
759      * which is called upon a safe transfer, and return the magic value
760      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
761      * the transfer is reverted.
762      * Requires the msg sender to be the owner, approved, or operator
763      * @param from current owner of the token
764      * @param to address to receive the ownership of the given token ID
765      * @param tokenId uint256 ID of the token to be transferred
766      * @param _data bytes data to send along with a safe transfer check
767      */
768     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
769         transferFrom(from, to, tokenId);
770         require(_checkOnERC721Received(from, to, tokenId, _data));
771     }
772 
773     /**
774      * @dev Public function to mint a new token
775      * Reverts if the given token ID already exists
776      * @param to address The address that will own the minted token
777      * @param tokenId uint256 ID of the token to be minted
778      * @param uri string Metadata URI of the token to be minted
779      * @param dna  uint256 DNAs of the token to be minted
780      */
781     function mint(address to, uint256 tokenId, string memory uri, uint256 dna , string memory tokenNms)
782         public onlyMinter
783     {
784         require(tokenId >= 0 && tokenId <= 9999);
785         _mint(to, tokenId, uri, dna, tokenNms);
786         _totalSupply += 1;
787     }
788 
789     /**
790      * @dev Returns whether the specified token exists
791      * @param tokenId uint256 ID of the token to query the existence of
792      * @return whether the token exists
793      */
794     function _exists(uint256 tokenId) internal view returns (bool) {
795         address owner = _tokenOwner[tokenId];
796         return owner != address(0);
797     }
798 
799     /**
800      * @dev Returns whether the given spender can transfer a given token ID
801      * @param spender address of the spender to query
802      * @param tokenId uint256 ID of the token to be transferred
803      * @return bool whether the msg.sender is approved for the given token ID,
804      *    is an operator of the owner, or is the owner of the token
805      */
806     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
807         address owner = ownerOf(tokenId);
808         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
809     }
810 
811     /**
812      * @dev Internal function to mint a new token
813      * Reverts if the given token ID already exists
814      * @param to The address that will own the minted token
815      * @param tokenId uint256 ID of the token to be minted
816      * @param uri string URI of the token to be minted metadata
817      * @param dna  uint256 DNAs of the token to be minted
818      */
819     function _mint(address to, uint256 tokenId, string memory uri, uint256 dna , string memory tokenNms) internal {
820         require(to != address(0));
821         require(!_exists(tokenId));
822 
823         _tokenOwner[tokenId] = to;
824         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
825         _setTokenURI(tokenId, uri);
826         _dnas[tokenId] = dna ;
827         _tokenNames[tokenId] = tokenNms;
828 
829         emit Transfer(address(0), to, tokenId);
830     }
831 
832     /**
833      * @dev Internal function to set the token URI for a given token
834      * Reverts if the token ID does not exist
835      * @param tokenId uint256 ID of the token to set its URI
836      * @param uri string URI to assign
837      */
838     function _setTokenURI(uint256 tokenId, string memory uri) internal {
839         require(_exists(tokenId));
840         _tokenURIs[tokenId] = uri;
841         emit TokenURI(tokenId, uri);
842     }
843 
844     /**
845      * @dev Internal function to transfer ownership of a given token ID to another address.
846      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
847      * @param from current owner of the token
848      * @param to address to receive the ownership of the given token ID
849      * @param tokenId uint256 ID of the token to be transferred
850     */
851     function _transferFrom(address from, address to, uint256 tokenId) internal {
852         require(ownerOf(tokenId) == from);
853         require(to != address(0));
854 
855         _clearApproval(tokenId);
856 
857         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
858         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
859 
860         _tokenOwner[tokenId] = to;
861 
862         emit Transfer(from, to, tokenId);
863     }
864 
865     /**
866      * @dev Internal function to invoke `onERC721Received` on a target address
867      * The call is not executed if the target address is not a contract
868      * @param from address representing the previous owner of the given token ID
869      * @param to target address that will receive the tokens
870      * @param tokenId uint256 ID of the token to be transferred
871      * @param _data bytes optional data to send along with the call
872      * @return whether the call correctly returned the expected magic value
873      */
874     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
875         internal returns (bool)
876     {
877         if (!to.isContract()) {
878             return true;
879         }
880 
881         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
882         return (retval == _ERC721_RECEIVED);
883     }
884 
885     /**
886      * @dev Private function to clear current approval of a given token ID
887      * @param tokenId uint256 ID of the token to be transferred
888      */
889     function _clearApproval(uint256 tokenId) private {
890         if (_tokenApprovals[tokenId] != address(0)) {
891             _tokenApprovals[tokenId] = address(0);
892         }
893     }
894 }