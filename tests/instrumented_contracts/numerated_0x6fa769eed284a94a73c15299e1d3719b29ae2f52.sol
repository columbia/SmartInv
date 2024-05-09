1 // Copyright (c) 2018-2020 double jump.tokyo inc.
2 pragma solidity 0.5.12;
3 
4 interface IERC721Metadata /* is ERC721 */ {
5     /// @notice A descriptive name for a collection of NFTs in this contract
6     function name() external view returns (string memory _name);
7 
8     /// @notice An abbreviated name for NFTs in this contract
9     function symbol() external view returns (string memory _symbol);
10 
11     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
12     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
13     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
14     ///  Metadata JSON Schema".
15     function tokenURI(uint256 _tokenId) external view returns (string memory);
16 }
17 
18 interface IERC721TokenReceiver {
19     /// @notice Handle the receipt of an NFT
20     /// @dev The ERC721 smart contract calls this function on the recipient
21     ///  after a `transfer`. This function MAY throw to revert and reject the
22     ///  transfer. Return of other than the magic value MUST result in the
23     ///  transaction being reverted.
24     ///  Note: the contract address is always the message sender.
25     /// @param _operator The address which called `safeTransferFrom` function
26     /// @param _from The address which previously owned the token
27     /// @param _tokenId The NFT identifier which is being transferred
28     /// @param _data Additional data with no specified format
29     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
30     ///  unless throwing
31     function onERC721Received(
32         address _operator,
33         address _from,
34         uint256 _tokenId,
35         bytes calldata _data
36     )
37         external
38         returns(bytes4);
39 }
40 
41 library Uint32 {
42 
43     function add(uint32 a, uint32 b) internal pure returns (uint32) {
44         uint32 c = a + b;
45         require(c >= a, "addition overflow");
46         return c;
47     }
48 
49     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
50         require(a >= b, "subtraction overflow");
51         return a - b;
52     }
53 
54     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
55         if (a == 0) {
56             return 0;
57         }
58         uint32 c = a * b;
59         require(c / a == b, "multiplication overflow");
60         return c;
61     }
62 
63     function div(uint32 a, uint32 b) internal pure returns (uint32) {
64         require(b != 0, "division by 0");
65         return a / b;
66     }
67 
68     function mod(uint32 a, uint32 b) internal pure returns (uint32) {
69         require(b != 0, "modulo by 0");
70         return a % b;
71     }
72 
73 }
74 
75 library String {
76 
77     function compare(string memory _a, string memory _b) public pure returns (bool) {
78         return (keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b)));
79     }
80 
81     function cut(string memory _s, uint256 _from, uint256 _range) public pure returns (string memory) {
82         bytes memory s = bytes(_s);
83         require(s.length >= _from + _range, "_s length must be longer than _from + _range");
84         bytes memory ret = new bytes(_range);
85 
86         for (uint256 i = 0; i < _range; i++) {
87             ret[i] = s[_from+i];
88         }
89         return string(ret);
90     }
91 
92     function concat(string memory _a, string memory _b) internal pure returns (string memory) {
93         return string(abi.encodePacked(_a, _b));
94     }
95 }
96 
97 library Address {
98 
99     function isContract(address account) internal view returns (bool) {
100         uint256 size;
101         assembly { size := extcodesize(account) }
102         return size > 0;
103     }
104 
105     function toPayable(address account) internal pure returns (address payable) {
106         return address(uint160(account));
107     }
108 
109     function toHex(address account) internal pure returns (string memory) {
110         bytes32 value = bytes32(uint256(account));
111         bytes memory alphabet = "0123456789abcdef";
112 
113         bytes memory str = new bytes(42);
114         str[0] = '0';
115         str[1] = 'x';
116         for (uint i = 0; i < 20; i++) {
117             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
118             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
119         }
120         return string(str);
121     }
122 }
123 interface IERC165 {
124     function supportsInterface(bytes4 interfaceID) external view returns (bool);
125 }
126 
127 /// @title ERC-165 Standard Interface Detection
128 /// @dev See https://eips.ethereum.org/EIPS/eip-165
129 contract ERC165 is IERC165 {
130     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
131     mapping(bytes4 => bool) private _supportedInterfaces;
132 
133     constructor () internal {
134         _registerInterface(_INTERFACE_ID_ERC165);
135     }
136 
137     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
138         return _supportedInterfaces[interfaceId];
139     }
140 
141     function _registerInterface(bytes4 interfaceId) internal {
142         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
143         _supportedInterfaces[interfaceId] = true;
144     }
145 }
146 
147 interface IApprovalProxy {
148   function setApprovalForAll(address _owner, address _spender, bool _approved) external;
149   function isApprovedForAll(address _owner, address _spender, bool _original) external view returns (bool);
150 }
151 library Uint256 {
152 
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, "addition overflow");
156         return c;
157     }
158 
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         require(a >= b, "subtraction overflow");
161         return a - b;
162     }
163 
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         if (a == 0) {
166             return 0;
167         }
168         uint256 c = a * b;
169         require(c / a == b, "multiplication overflow");
170         return c;
171     }
172 
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         require(b != 0, "division by 0");
175         return a / b;
176     }
177 
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b != 0, "modulo by 0");
180         return a % b;
181     }
182 
183     function toString(uint256 a) internal pure returns (string memory) {
184         bytes32 retBytes32;
185         uint256 len = 0;
186         if (a == 0) {
187             retBytes32 = "0";
188             len++;
189         } else {
190             uint256 value = a;
191             while (value > 0) {
192                 retBytes32 = bytes32(uint256(retBytes32) / (2 ** 8));
193                 retBytes32 |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
194                 value /= 10;
195                 len++;
196             }
197         }
198 
199         bytes memory ret = new bytes(len);
200         uint256 i;
201 
202         for (i = 0; i < len; i++) {
203             ret[i] = retBytes32[i];
204         }
205         return string(ret);
206     }
207 }
208 
209 interface IERC721 /* is ERC165 */ {
210     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
211     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
212     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
213     function balanceOf(address _owner) external view returns (uint256);
214     function ownerOf(uint256 _tokenId) external view returns (address);
215     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
216     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
217     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
218     function approve(address _approved, uint256 _tokenId) external payable;
219     function setApprovalForAll(address _operator, bool _approved) external;
220     function getApproved(uint256 _tokenId) external view returns (address);
221     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
222 }
223 
224 library Roles {
225     struct Role {
226         mapping (address => bool) bearer;
227     }
228 
229     function add(Role storage role, address account) internal {
230         require(!has(role, account), "role already has the account");
231         role.bearer[account] = true;
232     }
233 
234     function remove(Role storage role, address account) internal {
235         require(has(role, account), "role dosen't have the account");
236         role.bearer[account] = false;
237     }
238 
239     function has(Role storage role, address account) internal view returns (bool) {
240         return role.bearer[account];
241     }
242 }
243 
244 contract ERC721 is IERC721, ERC165 {
245     using Uint256 for uint256;
246     using Address for address;
247 
248     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
249     bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
250 
251     mapping (uint256 => address) private _tokenOwner;
252     mapping (address => uint256) private _balance;
253     mapping (uint256 => address) private _tokenApproved;
254     mapping (address => mapping (address => bool)) private _operatorApprovals;
255 
256     constructor () public {
257         _registerInterface(_InterfaceId_ERC721);
258     }
259 
260     function balanceOf(address _owner) public view returns (uint256) {
261         return _balance[_owner];
262     }
263 
264     function ownerOf(uint256 _tokenId) public view returns (address) {
265         require(_exist(_tokenId),
266                 "`_tokenId` is not a valid NFT.");
267         return _tokenOwner[_tokenId];
268     }
269 
270     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public payable {
271         require(_data.length == 0, "data is not implemented");
272         safeTransferFrom(_from, _to, _tokenId);
273     }
274 
275     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable {
276         require(_checkOnERC721Received(_from, _to, _tokenId, ""),
277                 "`_to` is a smart contract and onERC721Received is invalid");
278         transferFrom(_from, _to, _tokenId);
279     }
280 
281     function transferFrom(address _from, address _to, uint256 _tokenId) public payable {
282         require(_transferable(msg.sender, _tokenId),
283                 "Unless `msg.sender` is the current owner, an authorized operator, or the approved address for this NFT."); // solhint-disable-line
284         require(ownerOf(_tokenId) == _from,
285                 "`_from` is not the current owner.");
286         require(_to != address(0),
287                 "`_to` is the zero address.");
288         require(_exist(_tokenId),
289                 "`_tokenId` is not a valid NFT.");
290         _transfer(_from, _to, _tokenId);
291     }
292 
293     function approve(address _approved, uint256 _tokenId) public payable {
294         address owner = ownerOf(_tokenId);
295         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
296                 "Unless `msg.sender` is the current NFT owner, or an authorized operator of the current owner.");
297 
298         _tokenApproved[_tokenId] = _approved;
299         emit Approval(msg.sender, _approved, _tokenId);
300     }
301 
302     function setApprovalForAll(address _operator, bool _approved) public {
303         _setApprovalForAll(msg.sender, _operator, _approved);
304     }
305 
306     function _setApprovalForAll(address _owner, address _operator, bool _approved) internal {
307         _operatorApprovals[_owner][_operator] = _approved;
308         emit ApprovalForAll(_owner, _operator, _approved);
309     }
310 
311     function getApproved(uint256 _tokenId) public view returns (address) {
312         require(_exist(_tokenId),
313                 "`_tokenId` is not a valid NFT.");
314         return _tokenApproved[_tokenId];
315     }
316 
317     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
318         return _isApprovedForAll(_owner, _operator);
319     }
320     
321     function _isApprovedForAll(address _owner, address _operator) internal view returns (bool) {
322         return _operatorApprovals[_owner][_operator];
323     }
324 
325     function _transferable(address _spender, uint256 _tokenId) internal view returns (bool){
326         address owner = ownerOf(_tokenId);
327         return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
328     }
329 
330     function _transfer(address _from, address _to, uint256 _tokenId) internal {
331         _clearApproval(_tokenId);
332         _tokenOwner[_tokenId] = _to;
333         _balance[_from] = _balance[_from].sub(1);
334         _balance[_to] = _balance[_to].add(1);
335         emit Transfer(_from, _to, _tokenId);
336     }
337   
338     function _mint(address _to, uint256 _tokenId) internal {
339         require(!_exist(_tokenId), "mint token already exists");
340         _tokenOwner[_tokenId] = _to;
341         _balance[_to] = _balance[_to].add(1);
342         emit Transfer(address(0), _to, _tokenId);
343     }
344   
345     function _burn(uint256 _tokenId) internal {
346         require(_exist(_tokenId), "burn token does not already exists");
347         address owner = ownerOf(_tokenId);
348         _clearApproval(_tokenId);
349         _tokenOwner[_tokenId] = address(0);
350         _balance[owner] = _balance[owner].sub(1);
351         emit Transfer(owner, address(0), _tokenId);
352     }
353 
354     function _exist(uint256 _tokenId) internal view returns (bool) {
355         address owner = _tokenOwner[_tokenId];
356         return owner != address(0);
357     }
358 
359     function _checkOnERC721Received(
360         address _from,
361         address _to,
362         uint256 _tokenId,
363         bytes memory _data
364     ) 
365         internal
366         returns (bool) 
367     {
368         if (!_to.isContract()) {
369             return true;
370         }
371         bytes4 retval = IERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
372         return (retval == _ERC721_RECEIVED);
373     }
374 
375     function _clearApproval(uint256 tokenId) internal {
376         if (_tokenApproved[tokenId] != address(0)) {
377             _tokenApproved[tokenId] = address(0);
378         }
379     }
380 }
381 
382 interface IERC173 /* is ERC165 */ {
383     /// @dev This emits when ownership of a contract changes.
384     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
385 
386     /// @notice Get the address of the owner
387     /// @return The address of the owner.
388     function owner() external view returns (address);
389 
390     /// @notice Set the address of the new owner of the contract
391     /// @param _newOwner The address of the new owner of the contract
392     function transferOwnership(address _newOwner) external;
393 }
394 
395 contract ERC173 is IERC173, ERC165  {
396     address private _owner;
397 
398     constructor() public {
399         _registerInterface(0x7f5828d0);
400         _transferOwnership(msg.sender);
401     }
402 
403     modifier onlyOwner() {
404         require(msg.sender == owner(), "Must be owner");
405         _;
406     }
407 
408     function owner() public view returns (address) {
409         return _owner;
410     }
411 
412     function transferOwnership(address _newOwner) public onlyOwner() {
413         _transferOwnership(_newOwner);
414     }
415 
416     function _transferOwnership(address _newOwner) internal {
417         address previousOwner = owner();
418 	_owner = _newOwner;
419         emit OwnershipTransferred(previousOwner, _newOwner);
420     }
421 }
422 
423 contract Operatable is ERC173 {
424     using Roles for Roles.Role;
425 
426     event OperatorAdded(address indexed account);
427     event OperatorRemoved(address indexed account);
428 
429     event Paused(address account);
430     event Unpaused(address account);
431 
432     bool private _paused;
433     Roles.Role private operators;
434 
435     constructor() public {
436         operators.add(msg.sender);
437         _paused = false;
438     }
439 
440     modifier onlyOperator() {
441         require(isOperator(msg.sender), "Must be operator");
442         _;
443     }
444 
445     modifier whenNotPaused() {
446         require(!_paused, "Pausable: paused");
447         _;
448     }
449 
450     modifier whenPaused() {
451         require(_paused, "Pausable: not paused");
452         _;
453     }
454 
455     function transferOwnership(address _newOwner) public onlyOperator() {
456         _transferOwnership(_newOwner);
457     }
458 
459     function isOperator(address account) public view returns (bool) {
460         return operators.has(account);
461     }
462 
463     function addOperator(address account) public onlyOperator() {
464         operators.add(account);
465         emit OperatorAdded(account);
466     }
467 
468     function removeOperator(address account) public onlyOperator() {
469         operators.remove(account);
470         emit OperatorRemoved(account);
471     }
472 
473     function paused() public view returns (bool) {
474         return _paused;
475     }
476 
477     function pause() public onlyOperator() whenNotPaused() {
478         _paused = true;
479         emit Paused(msg.sender);
480     }
481 
482     function unpause() public onlyOperator() whenPaused() {
483         _paused = false;
484         emit Unpaused(msg.sender);
485     }
486 
487     function withdrawEther() public onlyOperator() {
488         msg.sender.transfer(address(this).balance);
489     }
490 
491 }
492 
493 contract ERC721Metadata is IERC721Metadata, ERC721, Operatable {
494     using Uint256 for uint256;
495     using String for string;
496 
497     event UpdateTokenURIPrefix(
498         string tokenUriPrefix
499     );
500 
501     // Metadata
502     string private __name;
503     string private __symbol;
504     string private __tokenUriPrefix;
505 
506     constructor(string memory _name,
507                 string memory _symbol,
508                 string memory _tokenUriPrefix) public {
509         // ERC721Metadata
510         __name = _name;
511         __symbol = _symbol;
512         setTokenURIPrefix(_tokenUriPrefix);
513     }
514 
515     function setTokenURIPrefix(string memory _tokenUriPrefix) public onlyOperator() {
516         __tokenUriPrefix = _tokenUriPrefix;
517         emit UpdateTokenURIPrefix(_tokenUriPrefix);
518     }
519 
520     function name() public view returns (string memory) {
521         return __name;
522     }
523 
524     function symbol() public view returns (string memory) {
525         return __symbol;
526     }
527 
528     function tokenURI(uint256 _tokenId) public view returns (string memory) {
529         return __tokenUriPrefix.concat(_tokenId.toString());
530     }
531 }
532 
533 contract ERC721TokenPausable is ERC721,Operatable {
534     using Roles for Roles.Role;
535     Roles.Role private tokenPauser;
536 
537     event TokenPauserAdded(address indexed account);
538     event TokenPauserRemoved(address indexed account);
539 
540     event TokenPaused(uint256 indexed tokenId);
541     event TokenUnpaused(uint256 indexed tokenId);
542 
543     mapping (uint256 => bool) private _tokenPaused;
544 
545     constructor() public {
546         tokenPauser.add(msg.sender);
547     }
548 
549     modifier onlyTokenPauser() {
550         require(isTokenPauser(msg.sender), "Only token pauser can call this method");
551         _;
552     }
553 
554     modifier whenNotTokenPaused(uint256 _tokenId) {
555         require(!isTokenPaused(_tokenId), "TokenPausable: paused");
556         _;
557     }
558 
559     modifier whenTokenPaused(uint256 _tokenId) {
560         require(isTokenPaused(_tokenId), "TokenPausable: not paused");
561         _;
562     }
563 
564     function pauseToken(uint256 _tokenId) public onlyTokenPauser() {
565         require(!isTokenPaused(_tokenId), "Token is already paused");
566         _tokenPaused[_tokenId] = true;
567         emit TokenPaused(_tokenId);
568     }
569 
570     function unpauseToken(uint256 _tokenId) public onlyTokenPauser() {
571         require(isTokenPaused(_tokenId), "Token is not paused");
572         _tokenPaused[_tokenId] = false;
573         emit TokenUnpaused(_tokenId);
574     }
575 
576     function isTokenPaused(uint256 _tokenId) public view returns (bool) {
577         return _tokenPaused[_tokenId];
578     }
579 
580     function isTokenPauser(address account) public view returns (bool) {
581         return tokenPauser.has(account);
582     }
583 
584     function addTokenPauser(address account) public onlyOperator() {
585         tokenPauser.add(account);
586         emit TokenPauserAdded(account);
587     }
588 
589     function removeTokenPauser(address account) public onlyOperator() {
590         tokenPauser.remove(account);
591         emit TokenPauserRemoved(account);
592     }
593 
594     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public payable
595                             whenNotPaused() whenNotTokenPaused(_tokenId) {
596         super.safeTransferFrom(_from, _to, _tokenId, _data);
597     }
598 
599     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable
600                             whenNotPaused() whenNotTokenPaused(_tokenId) {
601         super.safeTransferFrom(_from, _to, _tokenId);
602     }
603 
604     function transferFrom(address _from, address _to, uint256 _tokenId) public payable
605                             whenNotPaused() whenNotTokenPaused(_tokenId) {
606         super.transferFrom(_from, _to, _tokenId);
607     }
608 }
609 
610 interface IERC721Mintable {
611     event MinterAdded(address indexed account);
612     event MinterRemoved(address indexed account);
613     function exist(uint256 _tokenId) external view returns (bool);
614     function mint(address _to, uint256 _tokenId) external;
615     function isMinter(address account) external view returns (bool);
616     function addMinter(address account) external;
617     function removeMinter(address account) external;
618 }
619 
620 contract ERC721Mintable is ERC721, IERC721Mintable, Operatable {
621     using Roles for Roles.Role;
622     Roles.Role private minters;
623 
624     constructor() public {
625         addMinter(msg.sender);
626     }
627 
628     modifier onlyMinter() {
629         require(isMinter(msg.sender), "Must be minter");
630         _;
631     }
632 
633     function isMinter(address account) public view returns (bool) {
634         return minters.has(account);
635     }
636 
637     function addMinter(address account) public onlyOperator() {
638         minters.add(account);
639         emit MinterAdded(account);
640     }
641 
642     function removeMinter(address account) public onlyOperator() {
643         minters.remove(account);
644         emit MinterRemoved(account);
645     }
646     
647     function exist(uint256 tokenId) public view returns (bool) {
648         return _exist(tokenId);
649     }
650 
651     function mint(address to, uint256 tokenId) public onlyMinter() {
652         _mint(to, tokenId);
653     }
654 }
655 interface IERC721CappedSupply /* IERC721Mintable, IERC721 */ {
656     event SetUnitCap(uint32 _assetType, uint32 _unitCap);
657     event SetTypeCap(uint256 _typeCap);
658     function totalSupply() external view returns (uint256);
659     function getTypeOffset() external view returns (uint256);
660     function getTypeCap() external view returns (uint256);
661     function setTypeCap(uint32 _newTypeCap) external;
662     function getTypeCount() external view returns (uint256);
663     function existingType(uint32 _assetType) external view returns (bool);
664     function getUnitCap(uint32 _assetType) external view returns (uint32);
665     function setUnitCap(uint32 _assetType, uint32 _newUnitCap) external;
666     function mint(address _to, uint256 _tokenId) external;
667 }
668 
669 /// @title ERC-721 Capped Supply
670 /// @author double jump.tokyo inc.
671 /// @dev see https://medium.com/@makzent/ca1008866871
672 contract ERC721CappedSupply is IERC721CappedSupply, ERC721Mintable {
673     using Uint256 for uint256;
674     using Uint32 for uint32;
675 
676     uint32 private assetTypeOffset;
677     mapping(uint32 => uint32) private unitCap;
678     mapping(uint32 => uint32) private unitCount;
679     mapping(uint32 => bool) private unitCapIsSet;
680     uint256 private assetTypeCap = 2**256-1;
681     uint256 private assetTypeCount = 0;
682     uint256 private totalCount = 0;
683 
684     constructor(uint32 _assetTypeOffset) public {
685         setTypeOffset(_assetTypeOffset);
686     }
687 
688     function isValidOffset(uint32 _offset) private pure returns (bool) {
689         for (uint32 i = _offset; i > 0; i = i.div(10)) {
690             if (i == 10) {
691                 return true;
692             }
693             if (i.mod(10) != 0) {
694                 return false;
695             }
696         }
697         return false;
698     }
699 
700     function totalSupply() public view returns (uint256) {
701         return totalCount;
702     }
703 
704     function setTypeOffset(uint32 _assetTypeOffset) private {
705         require(isValidOffset(_assetTypeOffset),  "Offset is invalid");
706         assetTypeCap = assetTypeCap / _assetTypeOffset;
707         assetTypeOffset = _assetTypeOffset;
708     }
709 
710     function getTypeOffset() public view returns (uint256) {
711         return assetTypeOffset;
712     }
713 
714     function setTypeCap(uint32 _newTypeCap) public onlyMinter() {
715         require(_newTypeCap < assetTypeCap, "New type cap cannot be less than existing type cap");
716         require(_newTypeCap >= assetTypeCount, "New type cap must be more than current type count");
717         assetTypeCap = _newTypeCap;
718         emit SetTypeCap(_newTypeCap);
719     }
720 
721     function getTypeCap() public view returns (uint256) {
722         return assetTypeCap;
723     }
724 
725     function getTypeCount() public view returns (uint256) {
726         return assetTypeCount;
727     }
728 
729     function existingType(uint32 _assetType) public view returns (bool) {
730         return unitCapIsSet[_assetType];
731     }
732 
733     function setUnitCap(uint32 _assetType, uint32 _newUnitCap) public onlyMinter() {
734         require(_assetType != 0, "Asset Type must not be 0");
735         require(_newUnitCap < assetTypeOffset, "New unit cap must be less than asset type offset");
736 
737         if (!existingType(_assetType)) {
738             unitCapIsSet[_assetType] = true;
739             assetTypeCount = assetTypeCount.add(1);
740             require(assetTypeCount <= assetTypeCap, "Asset type cap is exceeded");
741         } else {
742             require(_newUnitCap < getUnitCap(_assetType), "New unit cap must be less than previous unit cap");
743             require(_newUnitCap >= getUnitCount(_assetType), "New unit cap must be more than current unit count");
744         }
745 
746         unitCap[_assetType] = _newUnitCap;
747         emit SetUnitCap(_assetType, _newUnitCap);
748     }
749 
750     function getUnitCap(uint32 _assetType) public view returns (uint32) {
751         require(existingType(_assetType), "Asset type does not exist");
752         return unitCap[_assetType];
753     }
754 
755     function getUnitCount(uint32 _assetType) public view returns (uint32) {
756         return unitCount[_assetType];
757     }
758 
759     function mint(address _to, uint256 _tokenId) public onlyMinter() {
760         require(_tokenId.mod(assetTypeOffset) != 0, "Index must not be 0");
761         uint32 assetType = uint32(_tokenId.div(assetTypeOffset));
762         unitCount[assetType] = unitCount[assetType].add(1);
763         totalCount = totalCount.add(1);
764         require(unitCount[assetType] <= getUnitCap(assetType), "Asset unit cap is exceed");
765         super.mint(_to, _tokenId);
766     }
767 }
768 
769 contract BFHUnit is
770                     ERC721TokenPausable,
771                     ERC721CappedSupply(10000),
772                     ERC721Metadata("BFH:Unit", "BFHU", "https://bravefrontierheroes.com/metadata/units/")
773                     {
774 
775     event UpdateApprovalProxy(address _newProxyContract);
776     IApprovalProxy public approvalProxy;
777     constructor(address _approvalProxy) public {
778         setApprovalProxy(_approvalProxy);
779     }
780 
781     function setApprovalProxy(address _new) public onlyOperator() {
782         approvalProxy = IApprovalProxy(_new);
783         emit UpdateApprovalProxy(_new);
784     }
785 
786     function setApprovalForAll(address _spender, bool _approved) public {
787         if (address(approvalProxy) != address(0x0) && _spender.isContract()) {
788             approvalProxy.setApprovalForAll(msg.sender, _spender, _approved);
789         }
790         super.setApprovalForAll(_spender, _approved);
791     }
792 
793     function isApprovedForAll(address _owner, address _spender) public view returns (bool) {
794         bool original = super.isApprovedForAll(_owner, _spender);
795         if (address(approvalProxy) != address(0x0)) {
796             return approvalProxy.isApprovedForAll(_owner, _spender, original);
797         }
798         return original;
799     }
800 }