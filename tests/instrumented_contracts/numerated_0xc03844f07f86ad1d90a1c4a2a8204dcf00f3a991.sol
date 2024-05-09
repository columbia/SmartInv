1 pragma solidity 0.5.12;
2 
3 // Copyright (c) 2018-2020 double jump.tokyo inc.
4 
5 interface IApprovalProxy {
6   function setApprovalForAll(address _owner, address _spender, bool _approved) external;
7   function isApprovedForAll(address _owner, address _spender, bool _original) external view returns (bool);
8 }
9 library Address {
10 
11     function isContract(address account) internal view returns (bool) {
12         uint256 size;
13         assembly { size := extcodesize(account) }
14         return size > 0;
15     }
16 
17     function toPayable(address account) internal pure returns (address payable) {
18         return address(uint160(account));
19     }
20 
21     function toHex(address account) internal pure returns (string memory) {
22         bytes32 value = bytes32(uint256(account));
23         bytes memory alphabet = "0123456789abcdef";
24 
25         bytes memory str = new bytes(42);
26         str[0] = '0';
27         str[1] = 'x';
28         for (uint i = 0; i < 20; i++) {
29             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
30             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
31         }
32         return string(str);
33     }
34 }
35 library Roles {
36     struct Role {
37         mapping (address => bool) bearer;
38     }
39 
40     function add(Role storage role, address account) internal {
41         require(!has(role, account), "role already has the account");
42         role.bearer[account] = true;
43     }
44 
45     function remove(Role storage role, address account) internal {
46         require(has(role, account), "role dosen't have the account");
47         role.bearer[account] = false;
48     }
49 
50     function has(Role storage role, address account) internal view returns (bool) {
51         return role.bearer[account];
52     }
53 }
54 
55 library Uint256 {
56 
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "addition overflow");
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(a >= b, "subtraction overflow");
65         return a - b;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         if (a == 0) {
70             return 0;
71         }
72         uint256 c = a * b;
73         require(c / a == b, "multiplication overflow");
74         return c;
75     }
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b != 0, "division by 0");
79         return a / b;
80     }
81 
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0, "modulo by 0");
84         return a % b;
85     }
86 
87     function toString(uint256 a) internal pure returns (string memory) {
88         bytes32 retBytes32;
89         uint256 len = 0;
90         if (a == 0) {
91             retBytes32 = "0";
92             len++;
93         } else {
94             uint256 value = a;
95             while (value > 0) {
96                 retBytes32 = bytes32(uint256(retBytes32) / (2 ** 8));
97                 retBytes32 |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
98                 value /= 10;
99                 len++;
100             }
101         }
102 
103         bytes memory ret = new bytes(len);
104         uint256 i;
105 
106         for (i = 0; i < len; i++) {
107             ret[i] = retBytes32[i];
108         }
109         return string(ret);
110     }
111 }
112 
113 interface IERC721TokenReceiver {
114     /// @notice Handle the receipt of an NFT
115     /// @dev The ERC721 smart contract calls this function on the recipient
116     ///  after a `transfer`. This function MAY throw to revert and reject the
117     ///  transfer. Return of other than the magic value MUST result in the
118     ///  transaction being reverted.
119     ///  Note: the contract address is always the message sender.
120     /// @param _operator The address which called `safeTransferFrom` function
121     /// @param _from The address which previously owned the token
122     /// @param _tokenId The NFT identifier which is being transferred
123     /// @param _data Additional data with no specified format
124     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
125     ///  unless throwing
126     function onERC721Received(
127         address _operator,
128         address _from,
129         uint256 _tokenId,
130         bytes calldata _data
131     )
132         external
133         returns(bytes4);
134 }
135 
136 interface IERC721Metadata /* is ERC721 */ {
137     /// @notice A descriptive name for a collection of NFTs in this contract
138     function name() external view returns (string memory _name);
139 
140     /// @notice An abbreviated name for NFTs in this contract
141     function symbol() external view returns (string memory _symbol);
142 
143     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
144     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
145     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
146     ///  Metadata JSON Schema".
147     function tokenURI(uint256 _tokenId) external view returns (string memory);
148 }
149 
150 interface IERC165 {
151     function supportsInterface(bytes4 interfaceID) external view returns (bool);
152 }
153 
154 /// @title ERC-165 Standard Interface Detection
155 /// @dev See https://eips.ethereum.org/EIPS/eip-165
156 contract ERC165 is IERC165 {
157     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
158     mapping(bytes4 => bool) private _supportedInterfaces;
159 
160     constructor () internal {
161         _registerInterface(_INTERFACE_ID_ERC165);
162     }
163 
164     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
165         return _supportedInterfaces[interfaceId];
166     }
167 
168     function _registerInterface(bytes4 interfaceId) internal {
169         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
170         _supportedInterfaces[interfaceId] = true;
171     }
172 }
173 
174 interface IERC721 /* is ERC165 */ {
175     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
176     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
177     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
178     function balanceOf(address _owner) external view returns (uint256);
179     function ownerOf(uint256 _tokenId) external view returns (address);
180     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
181     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
182     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
183     function approve(address _approved, uint256 _tokenId) external payable;
184     function setApprovalForAll(address _operator, bool _approved) external;
185     function getApproved(uint256 _tokenId) external view returns (address);
186     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
187 }
188 
189 library Uint32 {
190 
191     function add(uint32 a, uint32 b) internal pure returns (uint32) {
192         uint32 c = a + b;
193         require(c >= a, "addition overflow");
194         return c;
195     }
196 
197     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
198         require(a >= b, "subtraction overflow");
199         return a - b;
200     }
201 
202     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
203         if (a == 0) {
204             return 0;
205         }
206         uint32 c = a * b;
207         require(c / a == b, "multiplication overflow");
208         return c;
209     }
210 
211     function div(uint32 a, uint32 b) internal pure returns (uint32) {
212         require(b != 0, "division by 0");
213         return a / b;
214     }
215 
216     function mod(uint32 a, uint32 b) internal pure returns (uint32) {
217         require(b != 0, "modulo by 0");
218         return a % b;
219     }
220 
221 }
222 
223 library String {
224 
225     function compare(string memory _a, string memory _b) public pure returns (bool) {
226         return (keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b)));
227     }
228 
229     function cut(string memory _s, uint256 _from, uint256 _range) public pure returns (string memory) {
230         bytes memory s = bytes(_s);
231         require(s.length >= _from + _range, "_s length must be longer than _from + _range");
232         bytes memory ret = new bytes(_range);
233 
234         for (uint256 i = 0; i < _range; i++) {
235             ret[i] = s[_from+i];
236         }
237         return string(ret);
238     }
239 
240     function concat(string memory _a, string memory _b) internal pure returns (string memory) {
241         return string(abi.encodePacked(_a, _b));
242     }
243 }
244 
245 contract ERC721 is IERC721, ERC165 {
246     using Uint256 for uint256;
247     using Address for address;
248 
249     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
250     bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
251 
252     mapping (uint256 => address) private _tokenOwner;
253     mapping (address => uint256) private _balance;
254     mapping (uint256 => address) private _tokenApproved;
255     mapping (address => mapping (address => bool)) private _operatorApprovals;
256 
257     constructor () public {
258         _registerInterface(_InterfaceId_ERC721);
259     }
260 
261     function balanceOf(address _owner) public view returns (uint256) {
262         return _balance[_owner];
263     }
264 
265     function ownerOf(uint256 _tokenId) public view returns (address) {
266         require(_exist(_tokenId),
267                 "`_tokenId` is not a valid NFT.");
268         return _tokenOwner[_tokenId];
269     }
270 
271     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public payable {
272         require(_data.length == 0, "data is not implemented");
273         safeTransferFrom(_from, _to, _tokenId);
274     }
275 
276     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable {
277         require(_checkOnERC721Received(_from, _to, _tokenId, ""),
278                 "`_to` is a smart contract and onERC721Received is invalid");
279         transferFrom(_from, _to, _tokenId);
280     }
281 
282     function transferFrom(address _from, address _to, uint256 _tokenId) public payable {
283         require(_transferable(msg.sender, _tokenId),
284                 "Unless `msg.sender` is the current owner, an authorized operator, or the approved address for this NFT."); // solhint-disable-line
285         require(ownerOf(_tokenId) == _from,
286                 "`_from` is not the current owner.");
287         require(_to != address(0),
288                 "`_to` is the zero address.");
289         require(_exist(_tokenId),
290                 "`_tokenId` is not a valid NFT.");
291         _transfer(_from, _to, _tokenId);
292     }
293 
294     function approve(address _approved, uint256 _tokenId) public payable {
295         address owner = ownerOf(_tokenId);
296         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
297                 "Unless `msg.sender` is the current NFT owner, or an authorized operator of the current owner.");
298 
299         _tokenApproved[_tokenId] = _approved;
300         emit Approval(msg.sender, _approved, _tokenId);
301     }
302 
303     function setApprovalForAll(address _operator, bool _approved) public {
304         _setApprovalForAll(msg.sender, _operator, _approved);
305     }
306 
307     function _setApprovalForAll(address _owner, address _operator, bool _approved) internal {
308         _operatorApprovals[_owner][_operator] = _approved;
309         emit ApprovalForAll(_owner, _operator, _approved);
310     }
311 
312     function getApproved(uint256 _tokenId) public view returns (address) {
313         require(_exist(_tokenId),
314                 "`_tokenId` is not a valid NFT.");
315         return _tokenApproved[_tokenId];
316     }
317 
318     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
319         return _isApprovedForAll(_owner, _operator);
320     }
321     
322     function _isApprovedForAll(address _owner, address _operator) internal view returns (bool) {
323         return _operatorApprovals[_owner][_operator];
324     }
325 
326     function _transferable(address _spender, uint256 _tokenId) internal view returns (bool){
327         address owner = ownerOf(_tokenId);
328         return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
329     }
330 
331     function _transfer(address _from, address _to, uint256 _tokenId) internal {
332         _clearApproval(_tokenId);
333         _tokenOwner[_tokenId] = _to;
334         _balance[_from] = _balance[_from].sub(1);
335         _balance[_to] = _balance[_to].add(1);
336         emit Transfer(_from, _to, _tokenId);
337     }
338   
339     function _mint(address _to, uint256 _tokenId) internal {
340         require(!_exist(_tokenId), "mint token already exists");
341         _tokenOwner[_tokenId] = _to;
342         _balance[_to] = _balance[_to].add(1);
343         emit Transfer(address(0), _to, _tokenId);
344     }
345   
346     function _burn(uint256 _tokenId) internal {
347         require(_exist(_tokenId), "burn token does not already exists");
348         address owner = ownerOf(_tokenId);
349         _clearApproval(_tokenId);
350         _tokenOwner[_tokenId] = address(0);
351         _balance[owner] = _balance[owner].sub(1);
352         emit Transfer(owner, address(0), _tokenId);
353     }
354 
355     function _exist(uint256 _tokenId) internal view returns (bool) {
356         address owner = _tokenOwner[_tokenId];
357         return owner != address(0);
358     }
359 
360     function _checkOnERC721Received(
361         address _from,
362         address _to,
363         uint256 _tokenId,
364         bytes memory _data
365     ) 
366         internal
367         returns (bool) 
368     {
369         if (!_to.isContract()) {
370             return true;
371         }
372         bytes4 retval = IERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
373         return (retval == _ERC721_RECEIVED);
374     }
375 
376     function _clearApproval(uint256 tokenId) internal {
377         if (_tokenApproved[tokenId] != address(0)) {
378             _tokenApproved[tokenId] = address(0);
379         }
380     }
381 }
382 
383 interface IERC173 /* is ERC165 */ {
384     /// @dev This emits when ownership of a contract changes.
385     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
386 
387     /// @notice Get the address of the owner
388     /// @return The address of the owner.
389     function owner() external view returns (address);
390 
391     /// @notice Set the address of the new owner of the contract
392     /// @param _newOwner The address of the new owner of the contract
393     function transferOwnership(address _newOwner) external;
394 }
395 
396 contract ERC173 is IERC173, ERC165  {
397     address private _owner;
398 
399     constructor() public {
400         _registerInterface(0x7f5828d0);
401         _transferOwnership(msg.sender);
402     }
403 
404     modifier onlyOwner() {
405         require(msg.sender == owner(), "Must be owner");
406         _;
407     }
408 
409     function owner() public view returns (address) {
410         return _owner;
411     }
412 
413     function transferOwnership(address _newOwner) public onlyOwner() {
414         _transferOwnership(_newOwner);
415     }
416 
417     function _transferOwnership(address _newOwner) internal {
418         address previousOwner = owner();
419 	_owner = _newOwner;
420         emit OwnershipTransferred(previousOwner, _newOwner);
421     }
422 }
423 
424 contract Operatable is ERC173 {
425     using Roles for Roles.Role;
426 
427     event OperatorAdded(address indexed account);
428     event OperatorRemoved(address indexed account);
429 
430     event Paused(address account);
431     event Unpaused(address account);
432 
433     bool private _paused;
434     Roles.Role private operators;
435 
436     constructor() public {
437         operators.add(msg.sender);
438         _paused = false;
439     }
440 
441     modifier onlyOperator() {
442         require(isOperator(msg.sender), "Must be operator");
443         _;
444     }
445 
446     modifier whenNotPaused() {
447         require(!_paused, "Pausable: paused");
448         _;
449     }
450 
451     modifier whenPaused() {
452         require(_paused, "Pausable: not paused");
453         _;
454     }
455 
456     function transferOwnership(address _newOwner) public onlyOperator() {
457         _transferOwnership(_newOwner);
458     }
459 
460     function isOperator(address account) public view returns (bool) {
461         return operators.has(account);
462     }
463 
464     function addOperator(address account) public onlyOperator() {
465         operators.add(account);
466         emit OperatorAdded(account);
467     }
468 
469     function removeOperator(address account) public onlyOperator() {
470         operators.remove(account);
471         emit OperatorRemoved(account);
472     }
473 
474     function paused() public view returns (bool) {
475         return _paused;
476     }
477 
478     function pause() public onlyOperator() whenNotPaused() {
479         _paused = true;
480         emit Paused(msg.sender);
481     }
482 
483     function unpause() public onlyOperator() whenPaused() {
484         _paused = false;
485         emit Unpaused(msg.sender);
486     }
487 
488     function withdrawEther() public onlyOperator() {
489         msg.sender.transfer(address(this).balance);
490     }
491 
492 }
493 
494 interface IERC721Mintable {
495     event MinterAdded(address indexed account);
496     event MinterRemoved(address indexed account);
497     function exist(uint256 _tokenId) external view returns (bool);
498     function mint(address _to, uint256 _tokenId) external;
499     function isMinter(address account) external view returns (bool);
500     function addMinter(address account) external;
501     function removeMinter(address account) external;
502 }
503 
504 contract ERC721Mintable is ERC721, IERC721Mintable, Operatable {
505     using Roles for Roles.Role;
506     Roles.Role private minters;
507 
508     constructor() public {
509         addMinter(msg.sender);
510     }
511 
512     modifier onlyMinter() {
513         require(isMinter(msg.sender), "Must be minter");
514         _;
515     }
516 
517     function isMinter(address account) public view returns (bool) {
518         return minters.has(account);
519     }
520 
521     function addMinter(address account) public onlyOperator() {
522         minters.add(account);
523         emit MinterAdded(account);
524     }
525 
526     function removeMinter(address account) public onlyOperator() {
527         minters.remove(account);
528         emit MinterRemoved(account);
529     }
530     
531     function exist(uint256 tokenId) public view returns (bool) {
532         return _exist(tokenId);
533     }
534 
535     function mint(address to, uint256 tokenId) public onlyMinter() {
536         _mint(to, tokenId);
537     }
538 }
539 contract ERC721Metadata is IERC721Metadata, ERC721, Operatable {
540     using Uint256 for uint256;
541     using String for string;
542 
543     event UpdateTokenURIPrefix(
544         string tokenUriPrefix
545     );
546 
547     // Metadata
548     string private __name;
549     string private __symbol;
550     string private __tokenUriPrefix;
551 
552     constructor(string memory _name,
553                 string memory _symbol,
554                 string memory _tokenUriPrefix) public {
555         // ERC721Metadata
556         __name = _name;
557         __symbol = _symbol;
558         setTokenURIPrefix(_tokenUriPrefix);
559     }
560 
561     function setTokenURIPrefix(string memory _tokenUriPrefix) public onlyOperator() {
562         __tokenUriPrefix = _tokenUriPrefix;
563         emit UpdateTokenURIPrefix(_tokenUriPrefix);
564     }
565 
566     function name() public view returns (string memory) {
567         return __name;
568     }
569 
570     function symbol() public view returns (string memory) {
571         return __symbol;
572     }
573 
574     function tokenURI(uint256 _tokenId) public view returns (string memory) {
575         return __tokenUriPrefix.concat(_tokenId.toString());
576     }
577 }
578 
579 contract ERC721TokenPausable is ERC721,Operatable {
580     using Roles for Roles.Role;
581     Roles.Role private tokenPauser;
582 
583     event TokenPauserAdded(address indexed account);
584     event TokenPauserRemoved(address indexed account);
585 
586     event TokenPaused(uint256 indexed tokenId);
587     event TokenUnpaused(uint256 indexed tokenId);
588 
589     mapping (uint256 => bool) private _tokenPaused;
590 
591     constructor() public {
592         tokenPauser.add(msg.sender);
593     }
594 
595     modifier onlyTokenPauser() {
596         require(isTokenPauser(msg.sender), "Only token pauser can call this method");
597         _;
598     }
599 
600     modifier whenNotTokenPaused(uint256 _tokenId) {
601         require(!isTokenPaused(_tokenId), "TokenPausable: paused");
602         _;
603     }
604 
605     modifier whenTokenPaused(uint256 _tokenId) {
606         require(isTokenPaused(_tokenId), "TokenPausable: not paused");
607         _;
608     }
609 
610     function pauseToken(uint256 _tokenId) public onlyTokenPauser() {
611         require(!isTokenPaused(_tokenId), "Token is already paused");
612         _tokenPaused[_tokenId] = true;
613         emit TokenPaused(_tokenId);
614     }
615 
616     function unpauseToken(uint256 _tokenId) public onlyTokenPauser() {
617         require(isTokenPaused(_tokenId), "Token is not paused");
618         _tokenPaused[_tokenId] = false;
619         emit TokenUnpaused(_tokenId);
620     }
621 
622     function isTokenPaused(uint256 _tokenId) public view returns (bool) {
623         return _tokenPaused[_tokenId];
624     }
625 
626     function isTokenPauser(address account) public view returns (bool) {
627         return tokenPauser.has(account);
628     }
629 
630     function addTokenPauser(address account) public onlyOperator() {
631         tokenPauser.add(account);
632         emit TokenPauserAdded(account);
633     }
634 
635     function removeTokenPauser(address account) public onlyOperator() {
636         tokenPauser.remove(account);
637         emit TokenPauserRemoved(account);
638     }
639 
640     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public payable
641                             whenNotPaused() whenNotTokenPaused(_tokenId) {
642         super.safeTransferFrom(_from, _to, _tokenId, _data);
643     }
644 
645     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable
646                             whenNotPaused() whenNotTokenPaused(_tokenId) {
647         super.safeTransferFrom(_from, _to, _tokenId);
648     }
649 
650     function transferFrom(address _from, address _to, uint256 _tokenId) public payable
651                             whenNotPaused() whenNotTokenPaused(_tokenId) {
652         super.transferFrom(_from, _to, _tokenId);
653     }
654 }
655 
656 interface IERC721CappedSupply /* IERC721Mintable, IERC721 */ {
657     event SetUnitCap(uint32 _assetType, uint32 _unitCap);
658     event SetTypeCap(uint256 _typeCap);
659     function totalSupply() external view returns (uint256);
660     function getTypeOffset() external view returns (uint256);
661     function getTypeCap() external view returns (uint256);
662     function setTypeCap(uint32 _newTypeCap) external;
663     function getTypeCount() external view returns (uint256);
664     function existingType(uint32 _assetType) external view returns (bool);
665     function getUnitCap(uint32 _assetType) external view returns (uint32);
666     function setUnitCap(uint32 _assetType, uint32 _newUnitCap) external;
667     function mint(address _to, uint256 _tokenId) external;
668 }
669 
670 /// @title ERC-721 Capped Supply
671 /// @author double jump.tokyo inc.
672 /// @dev see https://medium.com/@makzent/ca1008866871
673 contract ERC721CappedSupply is IERC721CappedSupply, ERC721Mintable {
674     using Uint256 for uint256;
675     using Uint32 for uint32;
676 
677     uint32 private assetTypeOffset;
678     mapping(uint32 => uint32) private unitCap;
679     mapping(uint32 => uint32) private unitCount;
680     mapping(uint32 => bool) private unitCapIsSet;
681     uint256 private assetTypeCap = 2**256-1;
682     uint256 private assetTypeCount = 0;
683     uint256 private totalCount = 0;
684 
685     constructor(uint32 _assetTypeOffset) public {
686         setTypeOffset(_assetTypeOffset);
687     }
688 
689     function isValidOffset(uint32 _offset) private pure returns (bool) {
690         for (uint32 i = _offset; i > 0; i = i.div(10)) {
691             if (i == 10) {
692                 return true;
693             }
694             if (i.mod(10) != 0) {
695                 return false;
696             }
697         }
698         return false;
699     }
700 
701     function totalSupply() public view returns (uint256) {
702         return totalCount;
703     }
704 
705     function setTypeOffset(uint32 _assetTypeOffset) private {
706         require(isValidOffset(_assetTypeOffset),  "Offset is invalid");
707         assetTypeCap = assetTypeCap / _assetTypeOffset;
708         assetTypeOffset = _assetTypeOffset;
709     }
710 
711     function getTypeOffset() public view returns (uint256) {
712         return assetTypeOffset;
713     }
714 
715     function setTypeCap(uint32 _newTypeCap) public onlyMinter() {
716         require(_newTypeCap < assetTypeCap, "New type cap cannot be less than existing type cap");
717         require(_newTypeCap >= assetTypeCount, "New type cap must be more than current type count");
718         assetTypeCap = _newTypeCap;
719         emit SetTypeCap(_newTypeCap);
720     }
721 
722     function getTypeCap() public view returns (uint256) {
723         return assetTypeCap;
724     }
725 
726     function getTypeCount() public view returns (uint256) {
727         return assetTypeCount;
728     }
729 
730     function existingType(uint32 _assetType) public view returns (bool) {
731         return unitCapIsSet[_assetType];
732     }
733 
734     function setUnitCap(uint32 _assetType, uint32 _newUnitCap) public onlyMinter() {
735         require(_assetType != 0, "Asset Type must not be 0");
736         require(_newUnitCap < assetTypeOffset, "New unit cap must be less than asset type offset");
737 
738         if (!existingType(_assetType)) {
739             unitCapIsSet[_assetType] = true;
740             assetTypeCount = assetTypeCount.add(1);
741             require(assetTypeCount <= assetTypeCap, "Asset type cap is exceeded");
742         } else {
743             require(_newUnitCap < getUnitCap(_assetType), "New unit cap must be less than previous unit cap");
744             require(_newUnitCap >= getUnitCount(_assetType), "New unit cap must be more than current unit count");
745         }
746 
747         unitCap[_assetType] = _newUnitCap;
748         emit SetUnitCap(_assetType, _newUnitCap);
749     }
750 
751     function getUnitCap(uint32 _assetType) public view returns (uint32) {
752         require(existingType(_assetType), "Asset type does not exist");
753         return unitCap[_assetType];
754     }
755 
756     function getUnitCount(uint32 _assetType) public view returns (uint32) {
757         return unitCount[_assetType];
758     }
759 
760     function mint(address _to, uint256 _tokenId) public onlyMinter() {
761         require(_tokenId.mod(assetTypeOffset) != 0, "Index must not be 0");
762         uint32 assetType = uint32(_tokenId.div(assetTypeOffset));
763         unitCount[assetType] = unitCount[assetType].add(1);
764         totalCount = totalCount.add(1);
765         require(unitCount[assetType] <= getUnitCap(assetType), "Asset unit cap is exceed");
766         super.mint(_to, _tokenId);
767     }
768 }
769 
770 contract BFHSphere is
771                     ERC721TokenPausable,
772                     ERC721CappedSupply(10000),
773                     ERC721Metadata("BFH:Sphere", "BFHS", "https://bravefrontierheroes.com/metadata/spheres/")
774                     {
775 
776     event UpdateApprovalProxy(address _newProxyContract);
777     IApprovalProxy public approvalProxy;
778     constructor(address _approvalProxy) public {
779         setApprovalProxy(_approvalProxy);
780     }
781 
782     function setApprovalProxy(address _new) public onlyOperator() {
783         approvalProxy = IApprovalProxy(_new);
784         emit UpdateApprovalProxy(_new);
785     }
786 
787     function setApprovalForAll(address _spender, bool _approved) public {
788         if (address(approvalProxy) != address(0x0) && _spender.isContract()) {
789             approvalProxy.setApprovalForAll(msg.sender, _spender, _approved);
790         }
791         super.setApprovalForAll(_spender, _approved);
792     }
793 
794     function isApprovedForAll(address _owner, address _spender) public view returns (bool) {
795         bool original = super.isApprovedForAll(_owner, _spender);
796         if (address(approvalProxy) != address(0x0)) {
797             return approvalProxy.isApprovedForAll(_owner, _spender, original);
798         }
799         return original;
800     }
801 }