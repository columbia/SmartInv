1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interfaces/Token.sol
4 
5 contract Token {
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
11     function balanceOf(address _owner) public view returns (uint256 balance);
12 }
13 
14 // File: contracts/interfaces/TokenConverter.sol
15 
16 contract TokenConverter {
17     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
18     function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);
19     function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);
20 }
21 
22 // File: contracts/utils/Ownable.sol
23 
24 contract Ownable {
25     address public owner;
26 
27     event SetOwner(address _owner);
28 
29     modifier onlyOwner() {
30         require(msg.sender == owner, "Sender not owner");
31         _;
32     }
33 
34     constructor() public {
35         owner = msg.sender;
36         emit SetOwner(msg.sender);
37     }
38 
39     /**
40         @dev Transfers the ownership of the contract.
41 
42         @param _to Address of the new owner
43     */
44     function setOwner(address _to) external onlyOwner returns (bool) {
45         require(_to != address(0), "Owner can't be 0x0");
46         owner = _to;
47         emit SetOwner(_to);
48         return true;
49     } 
50 }
51 
52 // File: contracts/interfaces/Oracle.sol
53 
54 /**
55     @dev Defines the interface of a standard RCN oracle.
56 
57     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
58     it's primarily used by the exchange but could be used by any other agent.
59 */
60 contract Oracle is Ownable {
61     uint256 public constant VERSION = 4;
62 
63     event NewSymbol(bytes32 _currency);
64 
65     mapping(bytes32 => bool) public supported;
66     bytes32[] public currencies;
67 
68     /**
69         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
70     */
71     function url() public view returns (string);
72 
73     /**
74         @dev Returns a valid convertion rate from the currency given to RCN
75 
76         @param symbol Symbol of the currency
77         @param data Generic data field, could be used for off-chain signing
78     */
79     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
80 
81     /**
82         @dev Adds a currency to the oracle, once added it cannot be removed
83 
84         @param ticker Symbol of the currency
85 
86         @return if the creation was done successfully
87     */
88     function addCurrency(string ticker) public onlyOwner returns (bool) {
89         bytes32 currency = encodeCurrency(ticker);
90         NewSymbol(currency);
91         supported[currency] = true;
92         currencies.push(currency);
93         return true;
94     }
95 
96     /**
97         @return the currency encoded as a bytes32
98     */
99     function encodeCurrency(string currency) public pure returns (bytes32 o) {
100         require(bytes(currency).length <= 32);
101         assembly {
102             o := mload(add(currency, 32))
103         }
104     }
105     
106     /**
107         @return the currency string from a encoded bytes32
108     */
109     function decodeCurrency(bytes32 b) public pure returns (string o) {
110         uint256 ns = 256;
111         while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }
112         assembly {
113             ns := div(ns, 8)
114             o := mload(0x40)
115             mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))
116             mstore(o, ns)
117             mstore(add(o, 32), b)
118         }
119     }
120     
121 }
122 
123 // File: contracts/interfaces/Engine.sol
124 
125 contract Engine {
126     uint256 public VERSION;
127     string public VERSION_NAME;
128 
129     enum Status { initial, lent, paid, destroyed }
130     struct Approbation {
131         bool approved;
132         bytes data;
133         bytes32 checksum;
134     }
135 
136     function getTotalLoans() public view returns (uint256);
137     function getOracle(uint index) public view returns (Oracle);
138     function getBorrower(uint index) public view returns (address);
139     function getCosigner(uint index) public view returns (address);
140     function ownerOf(uint256) public view returns (address owner);
141     function getCreator(uint index) public view returns (address);
142     function getAmount(uint index) public view returns (uint256);
143     function getPaid(uint index) public view returns (uint256);
144     function getDueTime(uint index) public view returns (uint256);
145     function getApprobation(uint index, address _address) public view returns (bool);
146     function getStatus(uint index) public view returns (Status);
147     function isApproved(uint index) public view returns (bool);
148     function getPendingAmount(uint index) public returns (uint256);
149     function getCurrency(uint index) public view returns (bytes32);
150     function cosign(uint index, uint256 cost) external returns (bool);
151     function approveLoan(uint index) public returns (bool);
152     function transfer(address to, uint256 index) public returns (bool);
153     function takeOwnership(uint256 index) public returns (bool);
154     function withdrawal(uint index, address to, uint256 amount) public returns (bool);
155     function identifierToIndex(bytes32 signature) public view returns (uint256);
156 }
157 
158 // File: contracts/interfaces/Cosigner.sol
159 
160 /**
161     @dev Defines the interface of a standard RCN cosigner.
162 
163     The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
164     of the insurance and the cost of the given are defined by the cosigner. 
165 
166     The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
167     agent should be passed as params when the lender calls the "lend" method on the engine.
168     
169     When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
170     should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
171     call this method, like the transfer of the ownership of the loan.
172 */
173 contract Cosigner {
174     uint256 public constant VERSION = 2;
175     
176     /**
177         @return the url of the endpoint that exposes the insurance offers.
178     */
179     function url() public view returns (string);
180     
181     /**
182         @dev Retrieves the cost of a given insurance, this amount should be exact.
183 
184         @return the cost of the cosign, in RCN wei
185     */
186     function cost(address engine, uint256 index, bytes data, bytes oracleData) public view returns (uint256);
187     
188     /**
189         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
190         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
191         does not return true to this method, the operation fails.
192 
193         @return true if the cosigner accepts the liability
194     */
195     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool);
196     
197     /**
198         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
199         current lender of the loan.
200 
201         @return true if the claim was done correctly.
202     */
203     function claim(address engine, uint256 index, bytes oracleData) external returns (bool);
204 }
205 
206 // File: contracts/interfaces/ERC721.sol
207 
208 contract ERC721 {
209     /*
210    // ERC20 compatible functions
211    function name() public view returns (string _name);
212    function symbol() public view returns (string _symbol);
213    function totalSupply() public view returns (uint256 _totalSupply);
214    function balanceOf(address _owner) public view returns (uint _balance);
215    // Functions that define ownership
216    function ownerOf(uint256) public view returns (address owner);
217    function approve(address, uint256) public returns (bool);
218    function takeOwnership(uint256) public returns (bool);
219    function transfer(address, uint256) public returns (bool);
220    function setApprovalForAll(address _operator, bool _approved) public returns (bool);
221    function getApproved(uint256 _tokenId) public view returns (address);
222    function isApprovedForAll(address _owner, address _operator) public view returns (bool);
223    function transferFrom(address from, address to, uint256 index) public returns (bool);
224    // Token metadata
225    function tokenMetadata(uint256 _tokenId) public view returns (string info);
226    */
227    // Events
228    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
229    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
230    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
231 }
232 
233 // File: contracts/utils/SafeMath.sol
234 
235 library SafeMath {
236     function add(uint256 x, uint256 y) internal pure returns (uint256) {
237         uint256 z = x + y;
238         require((z >= x) && (z >= y), "Add overflow");
239         return z;
240     }
241 
242     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
243         require(x >= y, "Sub underflow");
244         uint256 z = x - y;
245         return z;
246     }
247 
248     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
249         uint256 z = x * y;
250         require((x == 0)||(z/x == y), "Mult overflow");
251         return z;
252     }
253 }
254 
255 // File: contracts/utils/ERC165.sol
256 
257 /**
258  * @title ERC165
259  * @author Matt Condon (@shrugs)
260  * @dev Implements ERC165 using a lookup table.
261  */
262 contract ERC165 {
263     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
264     /**
265     * 0x01ffc9a7 ===
266     *   bytes4(keccak256('supportsInterface(bytes4)'))
267     */
268 
269     /**
270     * @dev a mapping of interface id to whether or not it's supported
271     */
272     mapping(bytes4 => bool) private _supportedInterfaces;
273 
274     /**
275     * @dev A contract implementing SupportsInterfaceWithLookup
276     * implement ERC165 itself
277     */
278     constructor()
279         internal
280     {
281         _registerInterface(_InterfaceId_ERC165);
282     }
283 
284     /**
285     * @dev implement supportsInterface(bytes4) using a lookup table
286     */
287     function supportsInterface(bytes4 interfaceId)
288         external
289         view
290         returns (bool)
291     {
292         return _supportedInterfaces[interfaceId];
293     }
294 
295     /**
296     * @dev internal method for registering an interface
297     */
298     function _registerInterface(bytes4 interfaceId)
299         internal
300     {
301         require(interfaceId != 0xffffffff, "Can't register 0xffffffff");
302         _supportedInterfaces[interfaceId] = true;
303     }
304 }
305 
306 // File: contracts/ERC721Base.sol
307 
308 interface URIProvider {
309     function tokenURI(uint256 _tokenId) external view returns (string);
310 }
311 
312 contract ERC721Base is ERC165 {
313     using SafeMath for uint256;
314 
315     mapping(uint256 => address) private _holderOf;
316     mapping(address => uint256[]) private _assetsOf;
317     mapping(address => mapping(address => bool)) private _operators;
318     mapping(uint256 => address) private _approval;
319     mapping(uint256 => uint256) private _indexOfAsset;
320 
321     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
322     bytes4 private constant ERC721_RECEIVED_LEGACY = 0xf0b9e5ba;
323 
324     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
325     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
326     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
327 
328     bytes4 private constant ERC_721_INTERFACE = 0x80ac58cd;
329     bytes4 private constant ERC_721_METADATA_INTERFACE = 0x5b5e139f;
330     bytes4 private constant ERC_721_ENUMERATION_INTERFACE = 0x780e9d63;
331 
332     constructor(
333         string name,
334         string symbol
335     ) public {
336         _name = name;
337         _symbol = symbol;
338 
339         _registerInterface(ERC_721_INTERFACE);
340         _registerInterface(ERC_721_METADATA_INTERFACE);
341         _registerInterface(ERC_721_ENUMERATION_INTERFACE);
342     }
343 
344     // ///
345     // ERC721 Metadata
346     // ///
347 
348     /// ERC-721 Non-Fungible Token Standard, optional metadata extension
349     /// See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
350     /// Note: the ERC-165 identifier for this interface is 0x5b5e139f.
351 
352     event SetURIProvider(address _uriProvider);
353 
354     string private _name;
355     string private _symbol;
356 
357     URIProvider private _uriProvider;
358 
359     // @notice A descriptive name for a collection of NFTs in this contract
360     function name() external view returns (string) {
361         return _name;
362     }
363 
364     // @notice An abbreviated name for NFTs in this contract
365     function symbol() external view returns (string) {
366         return _symbol;
367     }
368 
369     /**
370     * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
371     * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
372     *  3986. The URI may point to a JSON file that conforms to the "ERC721
373     *  Metadata JSON Schema".
374     */
375     function tokenURI(uint256 _tokenId) external view returns (string) {
376         require(_holderOf[_tokenId] != 0, "Asset does not exist");
377         URIProvider provider = _uriProvider;
378         return provider == address(0) ? "" : provider.tokenURI(_tokenId);
379     }
380 
381     function _setURIProvider(URIProvider _provider) internal returns (bool) {
382         emit SetURIProvider(_provider);
383         _uriProvider = _provider;
384         return true;
385     }
386  
387     // ///
388     // ERC721 Enumeration
389     // ///
390 
391     ///  ERC-721 Non-Fungible Token Standard, optional enumeration extension
392     ///  See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
393     ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
394 
395     uint256[] private _allTokens;
396 
397     function allTokens() external view returns (uint256[]) {
398         return _allTokens;
399     }
400 
401     function assetsOf(address _owner) external view returns (uint256[]) {
402         return _assetsOf[_owner];
403     }
404 
405     /**
406      * @dev Gets the total amount of assets stored by the contract
407      * @return uint256 representing the total amount of assets
408      */
409     function totalSupply() external view returns (uint256) {
410         return _allTokens.length;
411     }
412 
413     /**
414     * @notice Enumerate valid NFTs
415     * @dev Throws if `_index` >= `totalSupply()`.
416     * @param _index A counter less than `totalSupply()`
417     * @return The token identifier for the `_index`th NFT,
418     *  (sort order not specified)
419     */
420     function tokenByIndex(uint256 _index) external view returns (uint256) {
421         require(_index < _allTokens.length, "Index out of bounds");
422         return _allTokens[_index];
423     }
424 
425     /**
426     * @notice Enumerate NFTs assigned to an owner
427     * @dev Throws if `_index` >= `balanceOf(_owner)` or if
428     *  `_owner` is the zero address, representing invalid NFTs.
429     * @param _owner An address where we are interested in NFTs owned by them
430     * @param _index A counter less than `balanceOf(_owner)`
431     * @return The token identifier for the `_index`th NFT assigned to `_owner`,
432     *   (sort order not specified)
433     */
434     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
435         require(_owner != address(0), "0x0 Is not a valid owner");
436         require(_index < _balanceOf(_owner), "Index out of bounds");
437         return _assetsOf[_owner][_index];
438     }
439 
440     //
441     // Asset-centric getter functions
442     //
443 
444     /**
445      * @dev Queries what address owns an asset. This method does not throw.
446      * In order to check if the asset exists, use the `exists` function or check if the
447      * return value of this call is `0`.
448      * @return uint256 the assetId
449      */
450     function ownerOf(uint256 _assetId) external view returns (address) {
451         return _ownerOf(_assetId);
452     }
453     function _ownerOf(uint256 _assetId) internal view returns (address) {
454         return _holderOf[_assetId];
455     }
456 
457     //
458     // Holder-centric getter functions
459     //
460     /**
461      * @dev Gets the balance of the specified address
462      * @param _owner address to query the balance of
463      * @return uint256 representing the amount owned by the passed address
464      */
465     function balanceOf(address _owner) external view returns (uint256) {
466         return _balanceOf(_owner);
467     }
468     function _balanceOf(address _owner) internal view returns (uint256) {
469         return _assetsOf[_owner].length;
470     }
471 
472     //
473     // Authorization getters
474     //
475 
476     /**
477      * @dev Query whether an address has been authorized to move any assets on behalf of someone else
478      * @param _operator the address that might be authorized
479      * @param _assetHolder the address that provided the authorization
480      * @return bool true if the operator has been authorized to move any assets
481      */
482     function isApprovedForAll(
483         address _operator,
484         address _assetHolder
485     ) external view returns (bool) {
486         return _isApprovedForAll(_operator, _assetHolder);
487     }
488     function _isApprovedForAll(
489         address _operator,
490         address _assetHolder
491     ) internal view returns (bool) {
492         return _operators[_assetHolder][_operator];
493     }
494 
495     /**
496      * @dev Query what address has been particularly authorized to move an asset
497      * @param _assetId the asset to be queried for
498      * @return bool true if the asset has been approved by the holder
499      */
500     function getApprovedAddress(uint256 _assetId) external view returns (address) {
501         return _getApprovedAddress(_assetId);
502     }
503     function _getApprovedAddress(uint256 _assetId) internal view returns (address) {
504         return _approval[_assetId];
505     }
506 
507     /**
508      * @dev Query if an operator can move an asset.
509      * @param _operator the address that might be authorized
510      * @param _assetId the asset that has been `approved` for transfer
511      * @return bool true if the asset has been approved by the holder
512      */
513     function isAuthorized(address _operator, uint256 _assetId) external view returns (bool) {
514         return _isAuthorized(_operator, _assetId);
515     }
516     function _isAuthorized(address _operator, uint256 _assetId) internal view returns (bool) {
517         require(_operator != 0, "0x0 is an invalid operator");
518         address owner = _ownerOf(_assetId);
519         if (_operator == owner) {
520             return true;
521         }
522         return _isApprovedForAll(_operator, owner) || _getApprovedAddress(_assetId) == _operator;
523     }
524 
525     //
526     // Authorization
527     //
528 
529     /**
530      * @dev Authorize a third party operator to manage (send) msg.sender's asset
531      * @param _operator address to be approved
532      * @param _authorized bool set to true to authorize, false to withdraw authorization
533      */
534     function setApprovalForAll(address _operator, bool _authorized) external {
535         if (_operators[msg.sender][_operator] != _authorized) {
536             _operators[msg.sender][_operator] = _authorized;
537             emit ApprovalForAll(_operator, msg.sender, _authorized);
538         }
539     }
540 
541     /**
542      * @dev Authorize a third party operator to manage one particular asset
543      * @param _operator address to be approved
544      * @param _assetId asset to approve
545      */
546     function approve(address _operator, uint256 _assetId) external {
547         address holder = _ownerOf(_assetId);
548         require(msg.sender == holder || _isApprovedForAll(msg.sender, holder), "msg.sender can't approve");
549         if (_getApprovedAddress(_assetId) != _operator) {
550             _approval[_assetId] = _operator;
551             emit Approval(holder, _operator, _assetId);
552         }
553     }
554 
555     //
556     // Internal Operations
557     //
558 
559     function _addAssetTo(address _to, uint256 _assetId) internal {
560         // Store asset owner
561         _holderOf[_assetId] = _to;
562 
563         // Store index of the asset
564         uint256 length = _balanceOf(_to);
565         _assetsOf[_to].push(_assetId);
566         _indexOfAsset[_assetId] = length;
567 
568         // Save main enumerable
569         _allTokens.push(_assetId);
570     }
571 
572     function _transferAsset(address _from, address _to, uint256 _assetId) internal {
573         uint256 assetIndex = _indexOfAsset[_assetId];
574         uint256 lastAssetIndex = _balanceOf(_from).sub(1);
575 
576         if (assetIndex != lastAssetIndex) {
577             // Replace current asset with last asset
578             uint256 lastAssetId = _assetsOf[_from][lastAssetIndex];
579             // Insert the last asset into the position previously occupied by the asset to be removed
580             _assetsOf[_from][assetIndex] = lastAssetId;
581         }
582 
583         // Resize the array
584         _assetsOf[_from][lastAssetIndex] = 0;
585         _assetsOf[_from].length--;
586 
587         // Change owner
588         _holderOf[_assetId] = _to;
589 
590         // Update the index of positions of the asset
591         uint256 length = _balanceOf(_to);
592         _assetsOf[_to].push(_assetId);
593         _indexOfAsset[_assetId] = length;
594     }
595 
596     function _clearApproval(address _holder, uint256 _assetId) internal {
597         if (_approval[_assetId] != 0) {
598             _approval[_assetId] = 0;
599             emit Approval(_holder, 0, _assetId);
600         }
601     }
602 
603     //
604     // Supply-altering functions
605     //
606 
607     function _generate(uint256 _assetId, address _beneficiary) internal {
608         require(_holderOf[_assetId] == 0, "Asset already exists");
609 
610         _addAssetTo(_beneficiary, _assetId);
611 
612         emit Transfer(0x0, _beneficiary, _assetId);
613     }
614 
615     //
616     // Transaction related operations
617     //
618 
619     modifier onlyHolder(uint256 _assetId) {
620         require(_ownerOf(_assetId) == msg.sender, "msg.sender Is not holder");
621         _;
622     }
623 
624     modifier onlyAuthorized(uint256 _assetId) {
625         require(_isAuthorized(msg.sender, _assetId), "msg.sender Not authorized");
626         _;
627     }
628 
629     modifier isCurrentOwner(address _from, uint256 _assetId) {
630         require(_ownerOf(_assetId) == _from, "Not current owner");
631         _;
632     }
633 
634     modifier addressDefined(address _target) {
635         require(_target != address(0), "Target can't be 0x0");
636         _;
637     }
638 
639     /**
640      * @dev Alias of `safeTransferFrom(from, to, assetId, '')`
641      *
642      * @param _from address that currently owns an asset
643      * @param _to address to receive the ownership of the asset
644      * @param _assetId uint256 ID of the asset to be transferred
645      */
646     function safeTransferFrom(address _from, address _to, uint256 _assetId) external {
647         return _doTransferFrom(_from, _to, _assetId, "", true);
648     }
649 
650     /**
651      * @dev Securely transfers the ownership of a given asset from one address to
652      * another address, calling the method `onNFTReceived` on the target address if
653      * there's code associated with it
654      *
655      * @param _from address that currently owns an asset
656      * @param _to address to receive the ownership of the asset
657      * @param _assetId uint256 ID of the asset to be transferred
658      * @param _userData bytes arbitrary user information to attach to this transfer
659      */
660     function safeTransferFrom(address _from, address _to, uint256 _assetId, bytes _userData) external {
661         return _doTransferFrom(_from, _to, _assetId, _userData, true);
662     }
663 
664     /**
665      * @dev Transfers the ownership of a given asset from one address to another address
666      * Warning! This function does not attempt to verify that the target address can send
667      * tokens.
668      *
669      * @param _from address sending the asset
670      * @param _to address to receive the ownership of the asset
671      * @param _assetId uint256 ID of the asset to be transferred
672      */
673     function transferFrom(address _from, address _to, uint256 _assetId) external {
674         return _doTransferFrom(_from, _to, _assetId, "", false);
675     }
676 
677     /**
678      * Internal function that moves an asset from one holder to another
679      */
680     function _doTransferFrom(
681         address _from,
682         address _to,
683         uint256 _assetId,
684         bytes _userData,
685         bool _doCheck
686     )
687         internal
688         onlyAuthorized(_assetId)
689         addressDefined(_to)
690         isCurrentOwner(_from, _assetId)
691     {
692         address holder = _holderOf[_assetId];
693         _clearApproval(holder, _assetId);
694         _transferAsset(holder, _to, _assetId);
695 
696         if (_doCheck && _isContract(_to)) {
697             // Call dest contract
698             uint256 success;
699             bytes32 result;
700             // Perform check with the new safe call
701             // onERC721Received(address,address,uint256,bytes)
702             (success, result) = _noThrowCall(
703                 _to,
704                 abi.encodeWithSelector(
705                     ERC721_RECEIVED,
706                     msg.sender,
707                     holder,
708                     _assetId,
709                     _userData
710                 )
711             );
712 
713             if (success != 1 || result != ERC721_RECEIVED) {
714                 // Try legacy safe call
715                 // onERC721Received(address,uint256,bytes)
716                 (success, result) = _noThrowCall(
717                     _to,
718                     abi.encodeWithSelector(
719                         ERC721_RECEIVED_LEGACY,
720                         holder,
721                         _assetId,
722                         _userData
723                     )
724                 );
725 
726                 require(
727                     success == 1 && result == ERC721_RECEIVED_LEGACY,
728                     "Contract rejected the token"
729                 );
730             }
731         }
732 
733         emit Transfer(holder, _to, _assetId);
734     }
735 
736     //
737     // Utilities
738     //
739 
740     function _isContract(address _addr) internal view returns (bool) {
741         uint size;
742         assembly { size := extcodesize(_addr) }
743         return size > 0;
744     }
745 
746     function _noThrowCall(
747         address _contract,
748         bytes _data
749     ) internal returns (uint256 success, bytes32 result) {
750         assembly {
751             let x := mload(0x40)
752 
753             success := call(
754                             gas,                  // Send all gas
755                             _contract,            // To addr
756                             0,                    // Send ETH
757                             add(0x20, _data),     // Input is data past the first 32 bytes
758                             mload(_data),         // Input size is the lenght of data
759                             x,                    // Store the ouput on x
760                             0x20                  // Output is a single bytes32, has 32 bytes
761                         )
762 
763             result := mload(x)
764         }
765     }
766 }
767 
768 // File: contracts/utils/SafeWithdraw.sol
769 
770 contract SafeWithdraw is Ownable {
771     function withdrawTokens(Token token, address to, uint256 amount) external onlyOwner returns (bool) {
772         require(to != address(0), "Can't transfer to address 0x0");
773         return token.transfer(to, amount);
774     }
775     
776     function withdrawErc721(ERC721Base token, address to, uint256 id) external onlyOwner returns (bool) {
777         require(to != address(0), "Can't transfer to address 0x0");
778         token.transferFrom(this, to, id);
779     }
780     
781     function withdrawEth(address to, uint256 amount) external onlyOwner returns (bool) {
782         to.transfer(amount);
783         return true;
784     }
785 }
786 
787 // File: contracts/utils/BytesUtils.sol
788 
789 contract BytesUtils {
790     function readBytes32(bytes data, uint256 index) internal pure returns (bytes32 o) {
791         require(data.length / 32 > index);
792         assembly {
793             o := mload(add(data, add(32, mul(32, index))))
794         }
795     }
796 }
797 
798 // File: contracts/MortgageManager.sol
799 
800 contract LandMarket {
801     struct Auction {
802         // Auction ID
803         bytes32 id;
804         // Owner of the NFT
805         address seller;
806         // Price (in wei) for the published item
807         uint256 price;
808         // Time when this sale ends
809         uint256 expiresAt;
810     }
811 
812     mapping (uint256 => Auction) public auctionByAssetId;
813     function executeOrder(uint256 assetId, uint256 price) public;
814 }
815 
816 contract Land is ERC721 {
817     function updateLandData(int x, int y, string data) public;
818     function decodeTokenId(uint value) view public returns (int, int);
819     function safeTransferFrom(address from, address to, uint256 assetId) public;
820     function ownerOf(uint256 landID) public view returns (address);
821     function setUpdateOperator(uint256 assetId, address operator) external;
822 }
823 
824 /**
825     @notice The contract is used to handle all the lifetime of a mortgage, uses RCN for the Loan and Decentraland for the parcels. 
826 
827     Implements the Cosigner interface of RCN, and when is tied to a loan it creates a new ERC721 to handle the ownership of the mortgage.
828 
829     When the loan is resolved (paid, pardoned or defaulted), the mortgaged parcel can be recovered. 
830 
831     Uses a token converter to buy the Decentraland parcel with MANA using the RCN tokens received.
832 */
833 contract MortgageManager is Cosigner, ERC721Base, SafeWithdraw, BytesUtils {
834     uint256 constant internal PRECISION = (10**18);
835     uint256 constant internal RCN_DECIMALS = 18;
836 
837     bytes32 public constant MANA_CURRENCY = 0x4d414e4100000000000000000000000000000000000000000000000000000000;
838     uint256 public constant REQUIRED_ALLOWANCE = 1000000000 * 10**18;
839 
840     event RequestedMortgage(
841         uint256 _id,
842         address _borrower,
843         address _engine,
844         uint256 _loanId,
845         address _landMarket,
846         uint256 _landId,
847         uint256 _deposit,
848         address _tokenConverter
849     );
850 
851     event ReadedOracle(
852         address _oracle,
853         bytes32 _currency,
854         uint256 _decimals,
855         uint256 _rate
856     );
857 
858     event StartedMortgage(uint256 _id);
859     event CanceledMortgage(address _from, uint256 _id);
860     event PaidMortgage(address _from, uint256 _id);
861     event DefaultedMortgage(uint256 _id);
862     event UpdatedLandData(address _updater, uint256 _parcel, string _data);
863     event SetCreator(address _creator, bool _status);
864     event SetEngine(address _engine, bool _status);
865 
866     Token public rcn;
867     Token public mana;
868     Land public land;
869     
870     constructor(
871         Token _rcn,
872         Token _mana,
873         Land _land
874     ) public ERC721Base("Decentraland RCN Mortgage", "LAND-RCN-M") {
875         rcn = _rcn;
876         mana = _mana;
877         land = _land;
878         mortgages.length++;
879     }
880 
881     enum Status { Pending, Ongoing, Canceled, Paid, Defaulted }
882 
883     struct Mortgage {
884         LandMarket landMarket;
885         address owner;
886         Engine engine;
887         uint256 loanId;
888         uint256 deposit;
889         uint256 landId;
890         uint256 landCost;
891         Status status;
892         TokenConverter tokenConverter;
893     }
894 
895     uint256 internal flagReceiveLand;
896 
897     Mortgage[] public mortgages;
898 
899     mapping(address => bool) public creators;
900     mapping(address => bool) public engines;
901 
902     mapping(uint256 => uint256) public mortgageByLandId;
903     mapping(address => mapping(uint256 => uint256)) public loanToLiability;
904 
905     function url() public view returns (string) {
906         return "";
907     }
908 
909     function setEngine(address engine, bool authorized) external onlyOwner returns (bool) {
910         emit SetEngine(engine, authorized);
911         engines[engine] = authorized;
912         return true;
913     }
914 
915     function setURIProvider(URIProvider _provider) external onlyOwner returns (bool) {
916         return _setURIProvider(_provider);
917     }
918 
919     /**
920         @notice Sets a new third party creator
921         
922         The third party creator can request loans for other borrowers. The creator should be a trusted contract, it could potentially take funds.
923     
924         @param creator Address of the creator
925         @param authorized Enables or disables the permission
926 
927         @return true If the operation was executed
928     */
929     function setCreator(address creator, bool authorized) external onlyOwner returns (bool) {
930         emit SetCreator(creator, authorized);
931         creators[creator] = authorized;
932         return true;
933     }
934 
935     /**
936         @notice Returns the cost of the cosigner
937 
938         This cosigner does not have any risk or maintenance cost, so its free.
939 
940         @return 0, because it's free
941     */
942     function cost(address, uint256, bytes, bytes) public view returns (uint256) {
943         return 0;
944     }
945 
946     /**
947         @notice Requests a mortgage with a loan identifier
948 
949         @dev The loan should exist in the designated engine
950 
951         @param engine RCN Engine
952         @param loanIdentifier Identifier of the loan asociated with the mortgage
953         @param deposit MANA to cover part of the cost of the parcel
954         @param landId ID of the parcel to buy with the mortgage
955         @param tokenConverter Token converter used to exchange RCN - MANA
956 
957         @return id The id of the mortgage
958     */
959     function requestMortgage(
960         Engine engine,
961         bytes32 loanIdentifier,
962         uint256 deposit,
963         LandMarket landMarket,
964         uint256 landId,
965         TokenConverter tokenConverter
966     ) external returns (uint256 id) {
967         return requestMortgageId(engine, landMarket, engine.identifierToIndex(loanIdentifier), deposit, landId, tokenConverter);
968     }
969 
970     /**
971         @notice Request a mortgage with a loan id
972 
973         @dev The loan should exist in the designated engine
974 
975         @param engine RCN Engine
976         @param loanId Id of the loan asociated with the mortgage
977         @param deposit MANA to cover part of the cost of the parcel
978         @param landId ID of the parcel to buy with the mortgage
979         @param tokenConverter Token converter used to exchange RCN - MANA
980 
981         @return id The id of the mortgage
982     */
983     function requestMortgageId(
984         Engine engine,
985         LandMarket landMarket,
986         uint256 loanId,
987         uint256 deposit,
988         uint256 landId,
989         TokenConverter tokenConverter
990     ) public returns (uint256 id) {
991         // Validate the associated loan
992         require(engine.getCurrency(loanId) == MANA_CURRENCY, "Loan currency is not MANA");
993         address borrower = engine.getBorrower(loanId);
994 
995         require(engines[engine], "Engine not authorized");
996         require(engine.getStatus(loanId) == Engine.Status.initial, "Loan status is not inital");
997         require(
998             msg.sender == borrower || (msg.sender == engine.getCreator(loanId) && creators[msg.sender]),
999             "Creator should be borrower or authorized"
1000         );
1001         require(engine.isApproved(loanId), "Loan is not approved");
1002         require(rcn.allowance(borrower, this) >= REQUIRED_ALLOWANCE, "Manager cannot handle borrower's funds");
1003         require(tokenConverter != address(0), "Token converter not defined");
1004         require(loanToLiability[engine][loanId] == 0, "Liability for loan already exists");
1005 
1006         // Get the current parcel cost
1007         uint256 landCost;
1008         (, , landCost, ) = landMarket.auctionByAssetId(landId);
1009         uint256 loanAmount = engine.getAmount(loanId);
1010 
1011         // the remaining will be sent to the borrower
1012         require(loanAmount + deposit >= landCost, "Not enought total amount");
1013 
1014         // Pull the deposit and lock the tokens
1015         require(mana.transferFrom(msg.sender, this, deposit), "Error pulling mana");
1016         
1017         // Create the liability
1018         id = mortgages.push(Mortgage({
1019             owner: borrower,
1020             engine: engine,
1021             loanId: loanId,
1022             deposit: deposit,
1023             landMarket: landMarket,
1024             landId: landId,
1025             landCost: landCost,
1026             status: Status.Pending,
1027             tokenConverter: tokenConverter
1028         })) - 1;
1029 
1030         loanToLiability[engine][loanId] = id;
1031 
1032         emit RequestedMortgage({
1033             _id: id,
1034             _borrower: borrower,
1035             _engine: engine,
1036             _loanId: loanId,
1037             _landMarket: landMarket,
1038             _landId: landId,
1039             _deposit: deposit,
1040             _tokenConverter: tokenConverter
1041         });
1042     }
1043 
1044     /**
1045         @notice Cancels an existing mortgage
1046         @dev The mortgage status should be pending
1047         @param id Id of the mortgage
1048         @return true If the operation was executed
1049 
1050     */
1051     function cancelMortgage(uint256 id) external returns (bool) {
1052         Mortgage storage mortgage = mortgages[id];
1053         
1054         // Only the owner of the mortgage and if the mortgage is pending
1055         require(msg.sender == mortgage.owner, "Only the owner can cancel the mortgage");
1056         require(mortgage.status == Status.Pending, "The mortgage is not pending");
1057         
1058         mortgage.status = Status.Canceled;
1059 
1060         // Transfer the deposit back to the borrower
1061         require(mana.transfer(msg.sender, mortgage.deposit), "Error returning MANA");
1062 
1063         emit CanceledMortgage(msg.sender, id);
1064         return true;
1065     }
1066 
1067     /**
1068         @notice Request the cosign of a loan
1069 
1070         Buys the parcel and locks its ownership until the loan status is resolved.
1071         Emits an ERC721 to manage the ownership of the mortgaged property.
1072     
1073         @param engine Engine of the loan
1074         @param index Index of the loan
1075         @param data Data with the mortgage id
1076         @param oracleData Oracle data to calculate the loan amount
1077 
1078         @return true If the cosign was performed
1079     */
1080     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool) {
1081         // The first word of the data MUST contain the index of the target mortgage
1082         Mortgage storage mortgage = mortgages[uint256(readBytes32(data, 0))];
1083         
1084         // Validate that the loan matches with the mortgage
1085         // and the mortgage is still pending
1086         require(mortgage.engine == engine, "Engine does not match");
1087         require(mortgage.loanId == index, "Loan id does not match");
1088         require(mortgage.status == Status.Pending, "Mortgage is not pending");
1089         require(engines[engine], "Engine not authorized");
1090 
1091         // Update the status of the mortgage to avoid reentrancy
1092         mortgage.status = Status.Ongoing;
1093 
1094         // Mint mortgage ERC721 Token
1095         _generate(uint256(readBytes32(data, 0)), mortgage.owner);
1096 
1097         // Transfer the amount of the loan in RCN to this contract
1098         uint256 loanAmount = convertRate(engine.getOracle(index), engine.getCurrency(index), oracleData, engine.getAmount(index));
1099         require(rcn.transferFrom(mortgage.owner, this, loanAmount), "Error pulling RCN from borrower");
1100         
1101         // Convert the RCN into MANA using the designated
1102         // and save the received MANA
1103         uint256 boughtMana = convertSafe(mortgage.tokenConverter, rcn, mana, loanAmount);
1104         delete mortgage.tokenConverter;
1105 
1106         // Load the new cost of the parcel, it may be changed
1107         uint256 currentLandCost;
1108         (, , currentLandCost, ) = mortgage.landMarket.auctionByAssetId(mortgage.landId);
1109         require(currentLandCost <= mortgage.landCost, "Parcel is more expensive than expected");
1110         
1111         // Buy the land and lock it into the mortgage contract
1112         require(mana.approve(mortgage.landMarket, currentLandCost), "Error approving mana transfer");
1113         flagReceiveLand = mortgage.landId;
1114         mortgage.landMarket.executeOrder(mortgage.landId, currentLandCost);
1115         require(mana.approve(mortgage.landMarket, 0), "Error removing approve mana transfer");
1116         require(flagReceiveLand == 0, "ERC721 callback not called");
1117         require(land.ownerOf(mortgage.landId) == address(this), "Error buying parcel");
1118 
1119         // Set borrower as update operator
1120         land.setUpdateOperator(mortgage.landId, mortgage.owner);
1121 
1122         // Calculate the remaining amount to send to the borrower and 
1123         // check that we didn't expend any contract funds.
1124         uint256 totalMana = boughtMana.add(mortgage.deposit);        
1125         uint256 rest = totalMana.sub(currentLandCost);
1126 
1127         // Return rest of MANA to the owner
1128         require(mana.transfer(mortgage.owner, rest), "Error returning MANA");
1129         
1130         // Cosign contract, 0 is the RCN required
1131         require(mortgage.engine.cosign(index, 0), "Error performing cosign");
1132         
1133         // Save mortgage id registry
1134         mortgageByLandId[mortgage.landId] = uint256(readBytes32(data, 0));
1135 
1136         // Emit mortgage event
1137         emit StartedMortgage(uint256(readBytes32(data, 0)));
1138 
1139         return true;
1140     }
1141 
1142     /**
1143         @notice Converts tokens using a token converter
1144         @dev Does not trust the token converter, validates the return amount
1145         @param converter Token converter used
1146         @param from Tokens to sell
1147         @param to Tokens to buy
1148         @param amount Amount to sell
1149         @return bought Bought amount
1150     */
1151     function convertSafe(
1152         TokenConverter converter,
1153         Token from,
1154         Token to,
1155         uint256 amount
1156     ) internal returns (uint256 bought) {
1157         require(from.approve(converter, amount), "Error approve convert safe");
1158         uint256 prevBalance = to.balanceOf(this);
1159         bought = converter.convert(from, to, amount, 1);
1160         require(to.balanceOf(this).sub(prevBalance) >= bought, "Bought amount incorrect");
1161         require(from.approve(converter, 0), "Error remove approve convert safe");
1162     }
1163 
1164     /**
1165         @notice Claims the mortgage when the loan status is resolved and transfers the ownership of the parcel to which corresponds.
1166 
1167         @dev Deletes the mortgage ERC721
1168 
1169         @param engine RCN Engine
1170         @param loanId Loan ID
1171         
1172         @return true If the claim succeded
1173     */
1174     function claim(address engine, uint256 loanId, bytes) external returns (bool) {
1175         uint256 mortgageId = loanToLiability[engine][loanId];
1176         Mortgage storage mortgage = mortgages[mortgageId];
1177 
1178         // Validate that the mortgage wasn't claimed
1179         require(mortgage.status == Status.Ongoing, "Mortgage not ongoing");
1180         require(mortgage.loanId == loanId, "Mortgage don't match loan id");
1181 
1182         if (mortgage.engine.getStatus(loanId) == Engine.Status.paid || mortgage.engine.getStatus(loanId) == Engine.Status.destroyed) {
1183             // The mortgage is paid
1184             require(_isAuthorized(msg.sender, mortgageId), "Sender not authorized");
1185 
1186             mortgage.status = Status.Paid;
1187             // Transfer the parcel to the borrower
1188             land.safeTransferFrom(this, msg.sender, mortgage.landId);
1189             emit PaidMortgage(msg.sender, mortgageId);
1190         } else if (isDefaulted(mortgage.engine, loanId)) {
1191             // The mortgage is defaulted
1192             require(msg.sender == mortgage.engine.ownerOf(loanId), "Sender not lender");
1193             
1194             mortgage.status = Status.Defaulted;
1195             // Transfer the parcel to the lender
1196             land.safeTransferFrom(this, msg.sender, mortgage.landId);
1197             emit DefaultedMortgage(mortgageId);
1198         } else {
1199             revert("Mortgage not defaulted/paid");
1200         }
1201 
1202         // Delete mortgage id registry
1203         delete mortgageByLandId[mortgage.landId];
1204 
1205         return true;
1206     }
1207 
1208     /**
1209         @notice Defines a custom logic that determines if a loan is defaulted or not.
1210 
1211         @param engine RCN Engines
1212         @param index Index of the loan
1213 
1214         @return true if the loan is considered defaulted
1215     */
1216     function isDefaulted(Engine engine, uint256 index) public view returns (bool) {
1217         return engine.getStatus(index) == Engine.Status.lent &&
1218             engine.getDueTime(index).add(7 days) <= block.timestamp;
1219     }
1220 
1221     /**
1222         @dev An alternative version of the ERC721 callback, required by a bug in the parcels contract
1223     */
1224     function onERC721Received(uint256 _tokenId, address, bytes) external returns (bytes4) {
1225         if (msg.sender == address(land) && flagReceiveLand == _tokenId) {
1226             flagReceiveLand = 0;
1227             return bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
1228         }
1229     }
1230 
1231     /**
1232         @notice Callback used to accept the ERC721 parcel tokens
1233 
1234         @dev Only accepts tokens if flag is set to tokenId, resets the flag when called
1235     */
1236     function onERC721Received(address, uint256 _tokenId, bytes) external returns (bytes4) {
1237         if (msg.sender == address(land) && flagReceiveLand == _tokenId) {
1238             flagReceiveLand = 0;
1239             return bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
1240         }
1241     }
1242 
1243     /**
1244         @notice Last callback used to accept the ERC721 parcel tokens
1245 
1246         @dev Only accepts tokens if flag is set to tokenId, resets the flag when called
1247     */
1248     function onERC721Received(address, address, uint256 _tokenId, bytes) external returns (bytes4) {
1249         if (msg.sender == address(land) && flagReceiveLand == _tokenId) {
1250             flagReceiveLand = 0;
1251             return bytes4(0x150b7a02);
1252         }
1253     }
1254 
1255     /**
1256         @dev Reads data from a bytes array
1257     */
1258     function getData(uint256 id) public pure returns (bytes o) {
1259         assembly {
1260             o := mload(0x40)
1261             mstore(0x40, add(o, and(add(add(32, 0x20), 0x1f), not(0x1f))))
1262             mstore(o, 32)
1263             mstore(add(o, 32), id)
1264         }
1265     }
1266     
1267     /**
1268         @notice Enables the owner of a parcel to update the data field
1269 
1270         @param id Id of the mortgage
1271         @param data New data
1272 
1273         @return true If data was updated
1274     */
1275     function updateLandData(uint256 id, string data) external returns (bool) {
1276         require(_isAuthorized(msg.sender, id), "Sender not authorized");
1277         (int256 x, int256 y) = land.decodeTokenId(mortgages[id].landId);
1278         land.updateLandData(x, y, data);
1279         emit UpdatedLandData(msg.sender, id, data);
1280         return true;
1281     }
1282 
1283     /**
1284         @dev Replica of the convertRate function of the RCN Engine, used to apply the oracle rate
1285     */
1286     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) internal returns (uint256) {
1287         if (oracle == address(0)) {
1288             return amount;
1289         } else {
1290             (uint256 rate, uint256 decimals) = oracle.getRate(currency, data);
1291             emit ReadedOracle(oracle, currency, decimals, rate);
1292             require(decimals <= RCN_DECIMALS, "Decimals exceeds max decimals");
1293             return amount.mult(rate.mult(10**(RCN_DECIMALS-decimals))) / PRECISION;
1294         }
1295     }
1296 
1297     //////
1298     // Override transfer
1299     //////
1300     function _doTransferFrom(
1301         address _from,
1302         address _to,
1303         uint256 _assetId,
1304         bytes _userData,
1305         bool _doCheck
1306     )
1307         internal
1308     {
1309         ERC721Base._doTransferFrom(_from, _to, _assetId, _userData, _doCheck);
1310         land.setUpdateOperator(mortgages[_assetId].landId, _to);
1311     }
1312 }
1313 
1314 // File: contracts/interfaces/NanoLoanEngine.sol
1315 
1316 interface NanoLoanEngine {
1317     function createLoan(address _oracleContract, address _borrower, bytes32 _currency, uint256 _amount, uint256 _interestRate,
1318         uint256 _interestRatePunitory, uint256 _duesIn, uint256 _cancelableAt, uint256 _expirationRequest, string _metadata) public returns (uint256);
1319     function getIdentifier(uint256 index) public view returns (bytes32);
1320     function registerApprove(bytes32 identifier, uint8 v, bytes32 r, bytes32 s) public returns (bool);
1321     function pay(uint index, uint256 _amount, address _from, bytes oracleData) public returns (bool);
1322     function rcn() public view returns (Token);
1323     function getOracle(uint256 index) public view returns (Oracle);
1324     function getAmount(uint256 index) public view returns (uint256);
1325     function getCurrency(uint256 index) public view returns (bytes32);
1326     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) public view returns (uint256);
1327     function lend(uint index, bytes oracleData, Cosigner cosigner, bytes cosignerData) public returns (bool);
1328     function transfer(address to, uint256 index) public returns (bool);
1329 }
1330 
1331 // File: contracts/utils/LrpSafeMath.sol
1332 
1333 library LrpSafeMath {
1334     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
1335         uint256 z = x + y;
1336         require((z >= x) && (z >= y));
1337         return z;
1338     }
1339 
1340     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
1341         require(x >= y);
1342         uint256 z = x - y;
1343         return z;
1344     }
1345 
1346     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
1347         uint256 z = x * y;
1348         require((x == 0)||(z/x == y));
1349         return z;
1350     }
1351 
1352     function min(uint256 a, uint256 b) internal pure returns(uint256) {
1353         if (a < b) { 
1354             return a;
1355         } else { 
1356             return b; 
1357         }
1358     }
1359     
1360     function max(uint256 a, uint256 b) internal pure returns(uint256) {
1361         if (a > b) { 
1362             return a;
1363         } else { 
1364             return b; 
1365         }
1366     }
1367 }
1368 
1369 // File: contracts/ConverterRamp.sol
1370 
1371 contract ConverterRamp is Ownable {
1372     using LrpSafeMath for uint256;
1373 
1374     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
1375     uint256 public constant AUTO_MARGIN = 1000001;
1376 
1377     uint256 public constant I_MARGIN_SPEND = 0;
1378     uint256 public constant I_MAX_SPEND = 1;
1379     uint256 public constant I_REBUY_THRESHOLD = 2;
1380 
1381     uint256 public constant I_ENGINE = 0;
1382     uint256 public constant I_INDEX = 1;
1383 
1384     uint256 public constant I_PAY_AMOUNT = 2;
1385     uint256 public constant I_PAY_FROM = 3;
1386 
1387     uint256 public constant I_LEND_COSIGNER = 2;
1388 
1389     event RequiredRebuy(address token, uint256 amount);
1390     event Return(address token, address to, uint256 amount);
1391     event OptimalSell(address token, uint256 amount);
1392     event RequiredRcn(uint256 required);
1393     event RunAutoMargin(uint256 loops, uint256 increment);
1394 
1395     function pay(
1396         TokenConverter converter,
1397         Token fromToken,
1398         bytes32[4] loanParams,
1399         bytes oracleData,
1400         uint256[3] convertRules
1401     ) external payable returns (bool) {
1402         Token rcn = NanoLoanEngine(address(loanParams[I_ENGINE])).rcn();
1403 
1404         uint256 initialBalance = rcn.balanceOf(this);
1405         uint256 requiredRcn = getRequiredRcnPay(loanParams, oracleData);
1406         emit RequiredRcn(requiredRcn);
1407 
1408         uint256 optimalSell = getOptimalSell(converter, fromToken, rcn, requiredRcn, convertRules[I_MARGIN_SPEND]);
1409         emit OptimalSell(fromToken, optimalSell);
1410 
1411         pullAmount(fromToken, optimalSell);
1412         uint256 bought = convertSafe(converter, fromToken, rcn, optimalSell);
1413 
1414         // Pay loan
1415         require(
1416             executeOptimalPay({
1417                 params: loanParams,
1418                 oracleData: oracleData,
1419                 rcnToPay: bought
1420             }),
1421             "Error paying the loan"
1422         );
1423 
1424         require(
1425             rebuyAndReturn({
1426                 converter: converter,
1427                 fromToken: rcn,
1428                 toToken: fromToken,
1429                 amount: rcn.balanceOf(this) - initialBalance,
1430                 spentAmount: optimalSell,
1431                 convertRules: convertRules
1432             }),
1433             "Error rebuying the tokens"
1434         );
1435 
1436         require(rcn.balanceOf(this) == initialBalance, "Converter balance has incremented");
1437         return true;
1438     }
1439 
1440     function requiredLendSell(
1441         TokenConverter converter,
1442         Token fromToken,
1443         bytes32[3] loanParams,
1444         bytes oracleData,
1445         bytes cosignerData,
1446         uint256[3] convertRules
1447     ) external view returns (uint256) {
1448         Token rcn = NanoLoanEngine(address(loanParams[0])).rcn();
1449         return getOptimalSell(
1450             converter,
1451             fromToken,
1452             rcn,
1453             getRequiredRcnLend(loanParams, oracleData, cosignerData),
1454             convertRules[I_MARGIN_SPEND]
1455         );
1456     }
1457 
1458     function requiredPaySell(
1459         TokenConverter converter,
1460         Token fromToken,
1461         bytes32[4] loanParams,
1462         bytes oracleData,
1463         uint256[3] convertRules
1464     ) external view returns (uint256) {
1465         Token rcn = NanoLoanEngine(address(loanParams[0])).rcn();
1466         return getOptimalSell(
1467             converter,
1468             fromToken,
1469             rcn,
1470             getRequiredRcnPay(loanParams, oracleData),
1471             convertRules[I_MARGIN_SPEND]
1472         );
1473     }
1474 
1475     function lend(
1476         TokenConverter converter,
1477         Token fromToken,
1478         bytes32[3] loanParams,
1479         bytes oracleData,
1480         bytes cosignerData,
1481         uint256[3] convertRules
1482     ) external payable returns (bool) {
1483         Token rcn = NanoLoanEngine(address(loanParams[0])).rcn();
1484         uint256 initialBalance = rcn.balanceOf(this);
1485         uint256 requiredRcn = getRequiredRcnLend(loanParams, oracleData, cosignerData);
1486         emit RequiredRcn(requiredRcn);
1487 
1488         uint256 optimalSell = getOptimalSell(converter, fromToken, rcn, requiredRcn, convertRules[I_MARGIN_SPEND]);
1489         emit OptimalSell(fromToken, optimalSell);
1490 
1491         pullAmount(fromToken, optimalSell);      
1492         uint256 bought = convertSafe(converter, fromToken, rcn, optimalSell);
1493 
1494         // Lend loan
1495         require(rcn.approve(address(loanParams[0]), bought));
1496         require(executeLend(loanParams, oracleData, cosignerData), "Error lending the loan");
1497         require(rcn.approve(address(loanParams[0]), 0));
1498         require(executeTransfer(loanParams, msg.sender), "Error transfering the loan");
1499 
1500         require(
1501             rebuyAndReturn({
1502                 converter: converter,
1503                 fromToken: rcn,
1504                 toToken: fromToken,
1505                 amount: rcn.balanceOf(this) - initialBalance,
1506                 spentAmount: optimalSell,
1507                 convertRules: convertRules
1508             }),
1509             "Error rebuying the tokens"
1510         );
1511 
1512         require(rcn.balanceOf(this) == initialBalance);
1513         return true;
1514     }
1515 
1516     function pullAmount(
1517         Token token,
1518         uint256 amount
1519     ) private {
1520         if (token == ETH_ADDRESS) {
1521             require(msg.value >= amount, "Error pulling ETH amount");
1522             if (msg.value > amount) {
1523                 msg.sender.transfer(msg.value - amount);
1524             }
1525         } else {
1526             require(token.transferFrom(msg.sender, this, amount), "Error pulling Token amount");
1527         }
1528     }
1529 
1530     function transfer(
1531         Token token,
1532         address to,
1533         uint256 amount
1534     ) private {
1535         if (token == ETH_ADDRESS) {
1536             to.transfer(amount);
1537         } else {
1538             require(token.transfer(to, amount), "Error sending tokens");
1539         }
1540     }
1541 
1542     function rebuyAndReturn(
1543         TokenConverter converter,
1544         Token fromToken,
1545         Token toToken,
1546         uint256 amount,
1547         uint256 spentAmount,
1548         uint256[3] memory convertRules
1549     ) internal returns (bool) {
1550         uint256 threshold = convertRules[I_REBUY_THRESHOLD];
1551         uint256 bought = 0;
1552 
1553         if (amount != 0) {
1554             if (amount > threshold) {
1555                 bought = convertSafe(converter, fromToken, toToken, amount);
1556                 emit RequiredRebuy(toToken, amount);
1557                 emit Return(toToken, msg.sender, bought);
1558                 transfer(toToken, msg.sender, bought);
1559             } else {
1560                 emit Return(fromToken, msg.sender, amount);
1561                 transfer(fromToken, msg.sender, amount);
1562             }
1563         }
1564 
1565         uint256 maxSpend = convertRules[I_MAX_SPEND];
1566         require(spentAmount.safeSubtract(bought) <= maxSpend || maxSpend == 0, "Max spend exceeded");
1567         
1568         return true;
1569     } 
1570 
1571     function getOptimalSell(
1572         TokenConverter converter,
1573         Token fromToken,
1574         Token toToken,
1575         uint256 requiredTo,
1576         uint256 extraSell
1577     ) internal returns (uint256 sellAmount) {
1578         uint256 sellRate = (10 ** 18 * converter.getReturn(toToken, fromToken, requiredTo)) / requiredTo;
1579         if (extraSell == AUTO_MARGIN) {
1580             uint256 expectedReturn = 0;
1581             uint256 optimalSell = applyRate(requiredTo, sellRate);
1582             uint256 increment = applyRate(requiredTo / 100000, sellRate);
1583             uint256 returnRebuy;
1584             uint256 cl;
1585 
1586             while (expectedReturn < requiredTo && cl < 10) {
1587                 optimalSell += increment;
1588                 returnRebuy = converter.getReturn(fromToken, toToken, optimalSell);
1589                 optimalSell = (optimalSell * requiredTo) / returnRebuy;
1590                 expectedReturn = returnRebuy;
1591                 cl++;
1592             }
1593             emit RunAutoMargin(cl, increment);
1594 
1595             return optimalSell;
1596         } else {
1597             return applyRate(requiredTo, sellRate).safeMult(uint256(100000).safeAdd(extraSell)) / 100000;
1598         }
1599     }
1600 
1601     function convertSafe(
1602         TokenConverter converter,
1603         Token fromToken,
1604         Token toToken,
1605         uint256 amount
1606     ) internal returns (uint256 bought) {
1607         if (fromToken != ETH_ADDRESS) require(fromToken.approve(converter, amount));
1608         uint256 prevBalance = toToken != ETH_ADDRESS ? toToken.balanceOf(this) : address(this).balance;
1609         uint256 sendEth = fromToken == ETH_ADDRESS ? amount : 0;
1610         uint256 boughtAmount = converter.convert.value(sendEth)(fromToken, toToken, amount, 1);
1611         require(
1612             boughtAmount == (toToken != ETH_ADDRESS ? toToken.balanceOf(this) : address(this).balance) - prevBalance,
1613             "Bought amound does does not match"
1614         );
1615         if (fromToken != ETH_ADDRESS) require(fromToken.approve(converter, 0));
1616         return boughtAmount;
1617     }
1618 
1619     function executeOptimalPay(
1620         bytes32[4] memory params,
1621         bytes oracleData,
1622         uint256 rcnToPay
1623     ) internal returns (bool) {
1624         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
1625         uint256 index = uint256(params[I_INDEX]);
1626         Oracle oracle = engine.getOracle(index);
1627 
1628         uint256 toPay;
1629 
1630         if (oracle == address(0)) {
1631             toPay = rcnToPay;
1632         } else {
1633             uint256 rate;
1634             uint256 decimals;
1635             bytes32 currency = engine.getCurrency(index);
1636 
1637             (rate, decimals) = oracle.getRate(currency, oracleData);
1638             toPay = (rcnToPay * (10 ** (18 - decimals + (18 * 2)) / rate)) / 10 ** 18;
1639         }
1640 
1641         Token rcn = engine.rcn();
1642         require(rcn.approve(engine, rcnToPay));
1643         require(engine.pay(index, toPay, address(params[I_PAY_FROM]), oracleData), "Error paying the loan");
1644         require(rcn.approve(engine, 0));
1645         
1646         return true;
1647     }
1648 
1649     function executeLend(
1650         bytes32[3] memory params,
1651         bytes oracleData,
1652         bytes cosignerData
1653     ) internal returns (bool) {
1654         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
1655         uint256 index = uint256(params[I_INDEX]);
1656         return engine.lend(index, oracleData, Cosigner(address(params[I_LEND_COSIGNER])), cosignerData);
1657     }
1658 
1659     function executeTransfer(
1660         bytes32[3] memory params,
1661         address to
1662     ) internal returns (bool) {
1663         return NanoLoanEngine(address(params[0])).transfer(to, uint256(params[1]));
1664     }
1665 
1666     function applyRate(
1667         uint256 amount,
1668         uint256 rate
1669     ) pure internal returns (uint256) {
1670         return amount.safeMult(rate) / 10 ** 18;
1671     }
1672 
1673     function getRequiredRcnLend(
1674         bytes32[3] memory params,
1675         bytes oracleData,
1676         bytes cosignerData
1677     ) internal returns (uint256 required) {
1678         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
1679         uint256 index = uint256(params[I_INDEX]);
1680         Cosigner cosigner = Cosigner(address(params[I_LEND_COSIGNER]));
1681 
1682         if (cosigner != address(0)) {
1683             required += cosigner.cost(engine, index, cosignerData, oracleData);
1684         }
1685         required += engine.convertRate(engine.getOracle(index), engine.getCurrency(index), oracleData, engine.getAmount(index));
1686     }
1687     
1688     function getRequiredRcnPay(
1689         bytes32[4] memory params,
1690         bytes oracleData
1691     ) internal returns (uint256) {
1692         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
1693         uint256 index = uint256(params[I_INDEX]);
1694         uint256 amount = uint256(params[I_PAY_AMOUNT]);
1695         return engine.convertRate(engine.getOracle(index), engine.getCurrency(index), oracleData, amount);
1696     }
1697 
1698     function sendTransaction(
1699         address to,
1700         uint256 value,
1701         bytes data
1702     ) external onlyOwner returns (bool) {
1703         return to.call.value(value)(data);
1704     }
1705 
1706     function() external {}
1707 }
1708 
1709 // File: contracts/MortgageHelper.sol
1710 
1711 /**
1712     @notice Set of functions to operate the mortgage manager in less transactions
1713 */
1714 contract MortgageHelper is Ownable {
1715     using LrpSafeMath for uint256;
1716 
1717     MortgageManager public mortgageManager;
1718     NanoLoanEngine public nanoLoanEngine;
1719     Token public rcn;
1720     Token public mana;
1721     LandMarket public landMarket;
1722     TokenConverter public tokenConverter;
1723     ConverterRamp public converterRamp;
1724 
1725     address public manaOracle;
1726     uint256 public requiredTotal = 105;
1727 
1728     uint256 public rebuyThreshold = 0.001 ether;
1729     uint256 public marginSpend = 500;
1730     uint256 public maxSpend = 300;
1731 
1732     bytes32 public constant MANA_CURRENCY = 0x4d414e4100000000000000000000000000000000000000000000000000000000;
1733 
1734     event NewMortgage(address borrower, uint256 loanId, uint256 landId, uint256 mortgageId);
1735     event PaidLoan(address engine, uint256 loanId, uint256 amount);
1736 
1737     event SetRebuyThreshold(uint256 _prev, uint256 _new);
1738     event SetMarginSpend(uint256 _prev, uint256 _new);
1739     event SetMaxSpend(uint256 _prev, uint256 _new);
1740     event SetRequiredTotal(uint256 _prev, uint256 _new);
1741 
1742     event SetTokenConverter(address _prev, address _new);
1743     event SetConverterRamp(address _prev, address _new);
1744     event SetManaOracle(address _manaOracle);
1745     event SetEngine(address _engine);
1746     event SetLandMarket(address _landMarket);
1747     event SetMortgageManager(address _mortgageManager);
1748 
1749     constructor(
1750         MortgageManager _mortgageManager,
1751         NanoLoanEngine _nanoLoanEngine,
1752         LandMarket _landMarket,
1753         address _manaOracle,
1754         TokenConverter _tokenConverter,
1755         ConverterRamp _converterRamp
1756     ) public {
1757         mortgageManager = _mortgageManager;
1758         nanoLoanEngine = _nanoLoanEngine;
1759         rcn = _mortgageManager.rcn();
1760         mana = _mortgageManager.mana();
1761         landMarket = _landMarket;
1762         manaOracle = _manaOracle;
1763         tokenConverter = _tokenConverter;
1764         converterRamp = _converterRamp;
1765 
1766         // Sanity checks
1767         require(_nanoLoanEngine.rcn() == rcn, "RCN Mismatch");
1768         require(_mortgageManager.engines(_nanoLoanEngine), "Engine is not approved");
1769         require(_isContract(mana), "MANA should be a contract");
1770         require(_isContract(rcn), "RCN should be a contract");
1771         require(_isContract(_tokenConverter), "Token converter should be a contract");
1772         require(_isContract(_landMarket), "Land market should be a contract");
1773         require(_isContract(_converterRamp), "Converter ramp should be a contract");
1774         require(_isContract(_manaOracle), "MANA Oracle should be a contract");
1775         require(_isContract(_mortgageManager), "Mortgage manager should be a contract");
1776 
1777         emit SetConverterRamp(converterRamp, _converterRamp);
1778         emit SetTokenConverter(tokenConverter, _tokenConverter);
1779 
1780         emit SetEngine(_nanoLoanEngine);
1781         emit SetLandMarket(_landMarket);
1782         emit SetMortgageManager(_mortgageManager);
1783         emit SetManaOracle(_manaOracle);
1784 
1785         emit SetMaxSpend(0, maxSpend);
1786         emit SetMarginSpend(0, marginSpend);
1787         emit SetRebuyThreshold(0, rebuyThreshold);
1788         emit SetRequiredTotal(0, requiredTotal);
1789     }
1790 
1791     /**
1792         @dev Creates a loan using an array of parameters
1793 
1794         @param params 0 - Ammount
1795                       1 - Interest rate
1796                       2 - Interest rate punitory
1797                       3 - Dues in
1798                       4 - Cancelable at
1799                       5 - Expiration of request
1800 
1801         @param metadata Loan metadata
1802 
1803         @return Id of the loan
1804 
1805     */
1806     function createLoan(uint256[6] memory params, string metadata) internal returns (uint256) {
1807         return nanoLoanEngine.createLoan(
1808             manaOracle,
1809             msg.sender,
1810             MANA_CURRENCY,
1811             params[0],
1812             params[1],
1813             params[2],
1814             params[3],
1815             params[4],
1816             params[5],
1817             metadata
1818         );
1819     }
1820 
1821     /**
1822         @notice Sets a max amount to expend when performing the payment
1823         @dev Only owner
1824         @param _maxSpend New maxSPend value
1825         @return true If the change was made
1826     */
1827     function setMaxSpend(uint256 _maxSpend) external onlyOwner returns (bool) {
1828         emit SetMaxSpend(maxSpend, _maxSpend);
1829         maxSpend = _maxSpend;
1830         return true;
1831     }
1832 
1833     /**
1834         @notice Sets required total of the mortgage
1835         @dev Only owner
1836         @param _requiredTotal New requiredTotal value
1837         @return true If the change was made
1838     */
1839     function setRequiredTotal(uint256 _requiredTotal) external onlyOwner returns (bool) {
1840         emit SetRequiredTotal(requiredTotal, _requiredTotal);
1841         requiredTotal = _requiredTotal;
1842         return true;
1843     }
1844 
1845 
1846     /**
1847         @notice Sets a new converter ramp to delegate the pay of the loan
1848         @dev Only owner
1849         @param _converterRamp Address of the converter ramp contract
1850         @return true If the change was made
1851     */
1852     function setConverterRamp(ConverterRamp _converterRamp) external onlyOwner returns (bool) {
1853         require(_isContract(_converterRamp), "Should be a contract");
1854         emit SetConverterRamp(converterRamp, _converterRamp);
1855         converterRamp = _converterRamp;
1856         return true;
1857     }
1858 
1859     /**
1860         @notice Sets a new min of tokens to rebuy when paying a loan
1861         @dev Only owner
1862         @param _rebuyThreshold New rebuyThreshold value
1863         @return true If the change was made
1864     */
1865     function setRebuyThreshold(uint256 _rebuyThreshold) external onlyOwner returns (bool) {
1866         emit SetRebuyThreshold(rebuyThreshold, _rebuyThreshold);
1867         rebuyThreshold = _rebuyThreshold;
1868         return true;
1869     }
1870 
1871     /**
1872         @notice Sets how much the converter ramp is going to oversell to cover fees and gaps
1873         @dev Only owner
1874         @param _marginSpend New marginSpend value
1875         @return true If the change was made
1876     */
1877     function setMarginSpend(uint256 _marginSpend) external onlyOwner returns (bool) {
1878         emit SetMarginSpend(marginSpend, _marginSpend);
1879         marginSpend = _marginSpend;
1880         return true;
1881     }
1882 
1883     /**
1884         @notice Sets the token converter used to convert the MANA into RCN when performing the payment
1885         @dev Only owner
1886         @param _tokenConverter Address of the tokenConverter contract
1887         @return true If the change was made
1888     */
1889     function setTokenConverter(TokenConverter _tokenConverter) external onlyOwner returns (bool) {
1890         require(_isContract(_tokenConverter), "Should be a contract");
1891         emit SetTokenConverter(tokenConverter, _tokenConverter);
1892         tokenConverter = _tokenConverter;
1893         return true;
1894     }
1895 
1896     function setManaOracle(address _manaOracle) external onlyOwner returns (bool) {
1897         require(_isContract(_manaOracle), "Should be a contract");
1898         emit SetManaOracle(_manaOracle);
1899         manaOracle = _manaOracle;
1900         return true;
1901     }
1902 
1903     function setEngine(NanoLoanEngine _engine) external onlyOwner returns (bool) {
1904         require(_isContract(_engine), "Should be a contract");
1905         emit SetEngine(_engine);
1906         nanoLoanEngine = _engine;
1907         return true;
1908     }
1909 
1910     function setLandMarket(LandMarket _landMarket) external onlyOwner returns (bool) {
1911         require(_isContract(_landMarket), "Should be a contract");
1912         emit SetLandMarket(_landMarket);
1913         landMarket = _landMarket;
1914         return true;
1915     }
1916 
1917     function setMortgageManager(MortgageManager _mortgageManager) external onlyOwner returns (bool) {
1918         require(_isContract(_mortgageManager), "Should be a contract");
1919         emit SetMortgageManager(_mortgageManager);
1920         mortgageManager = _mortgageManager;
1921         return true;
1922     }
1923 
1924     /**
1925         @notice Request a loan and attachs a mortgage request
1926 
1927         @dev Requires the loan signed by the borrower
1928 
1929         @param loanParams   0 - Ammount
1930                             1 - Interest rate
1931                             2 - Interest rate punitory
1932                             3 - Dues in
1933                             4 - Cancelable at
1934                             5 - Expiration of request
1935         @param metadata Loan metadata
1936         @param landId Land to buy with the mortgage
1937         @param v Loan signature by the borrower
1938         @param r Loan signature by the borrower
1939         @param s Loan signature by the borrower
1940 
1941         @return The id of the mortgage
1942     */
1943     function requestMortgage(
1944         uint256[6] loanParams,
1945         string metadata,
1946         uint256 landId,
1947         uint8 v,
1948         bytes32 r,
1949         bytes32 s
1950     ) external returns (uint256) {
1951         // Create a loan with the loanParams and metadata
1952         uint256 loanId = createLoan(loanParams, metadata);
1953 
1954         // Load NanoLoanEngine address
1955         NanoLoanEngine _nanoLoanEngine = nanoLoanEngine;
1956 
1957         // Approve the created loan with the provided signature
1958         require(_nanoLoanEngine.registerApprove(_nanoLoanEngine.getIdentifier(loanId), v, r, s), "Signature not valid");
1959 
1960         // Calculate the requested amount for the mortgage deposit
1961         uint256 requiredDeposit = ((readLandCost(landId) * requiredTotal) / 100) - _nanoLoanEngine.getAmount(loanId);
1962         
1963         // Pull the required deposit amount
1964         Token _mana = mana;
1965         _tokenTransferFrom(_mana, msg.sender, this, requiredDeposit);
1966         require(_mana.approve(mortgageManager, requiredDeposit), "Error approve MANA transfer");
1967 
1968         // Create the mortgage request
1969         uint256 mortgageId = mortgageManager.requestMortgageId(
1970             Engine(_nanoLoanEngine),
1971             landMarket,
1972             loanId,
1973             requiredDeposit, 
1974             landId,
1975             tokenConverter
1976         );
1977 
1978         require(_mana.approve(mortgageManager, 0), "Error remove approve MANA transfer");
1979 
1980         emit NewMortgage(msg.sender, loanId, landId, mortgageId);
1981         
1982         return mortgageId;
1983     }
1984 
1985     function readLandCost(uint256 _landId) internal view returns (uint256 landCost) {
1986         (, , landCost, ) = landMarket.auctionByAssetId(_landId);
1987     }
1988 
1989     /**
1990         @notice Pays a loan using mana
1991 
1992         @dev The amount to pay must be set on mana
1993 
1994         @param engine RCN Engine
1995         @param loan Loan id to pay
1996         @param amount Amount in MANA to pay
1997 
1998         @return True if the payment was performed
1999     */
2000     function pay(address engine, uint256 loan, uint256 amount) external returns (bool) {
2001         emit PaidLoan(engine, loan, amount);
2002 
2003         bytes32[4] memory loanParams = [
2004             bytes32(engine),
2005             bytes32(loan),
2006             bytes32(amount),
2007             bytes32(msg.sender)
2008         ];
2009 
2010         uint256[3] memory converterParams = [
2011             marginSpend,
2012             amount.safeMult(uint256(100000).safeAdd(maxSpend)) / 100000,
2013             rebuyThreshold
2014         ];
2015 
2016         require(address(converterRamp).delegatecall(
2017             bytes4(0x86ee863d),
2018             address(tokenConverter),
2019             address(mana),
2020             loanParams,
2021             0x140,
2022             converterParams,
2023             0x0
2024         ), "Error delegate pay call");
2025     }
2026 
2027     function _tokenTransferFrom(Token token, address from, address to, uint256 amount) internal {
2028         require(token.balanceOf(from) >= amount, "From balance is not enough");
2029         require(token.allowance(from, address(this)) >= amount, "Allowance is not enough");
2030         require(token.transferFrom(from, to, amount), "Transfer failed");
2031     }
2032 
2033     function _isContract(address addr) internal view returns (bool) {
2034         uint size;
2035         assembly { size := extcodesize(addr) }
2036         return size > 0;
2037     }
2038 }