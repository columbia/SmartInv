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
14 // File: contracts/utils/Ownable.sol
15 
16 contract Ownable {
17     address public owner;
18 
19     event SetOwner(address _owner);
20 
21     modifier onlyOwner() {
22         require(msg.sender == owner, "Sender not owner");
23         _;
24     }
25 
26     constructor() public {
27         owner = msg.sender;
28         emit SetOwner(msg.sender);
29     }
30 
31     /**
32         @dev Transfers the ownership of the contract.
33 
34         @param _to Address of the new owner
35     */
36     function setOwner(address _to) external onlyOwner returns (bool) {
37         require(_to != address(0), "Owner can't be 0x0");
38         owner = _to;
39         emit SetOwner(_to);
40         return true;
41     } 
42 }
43 
44 // File: contracts/interfaces/Oracle.sol
45 
46 /**
47     @dev Defines the interface of a standard RCN oracle.
48 
49     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
50     it's primarily used by the exchange but could be used by any other agent.
51 */
52 contract Oracle is Ownable {
53     uint256 public constant VERSION = 4;
54 
55     event NewSymbol(bytes32 _currency);
56 
57     mapping(bytes32 => bool) public supported;
58     bytes32[] public currencies;
59 
60     /**
61         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
62     */
63     function url() public view returns (string);
64 
65     /**
66         @dev Returns a valid convertion rate from the currency given to RCN
67 
68         @param symbol Symbol of the currency
69         @param data Generic data field, could be used for off-chain signing
70     */
71     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
72 
73     /**
74         @dev Adds a currency to the oracle, once added it cannot be removed
75 
76         @param ticker Symbol of the currency
77 
78         @return if the creation was done successfully
79     */
80     function addCurrency(string ticker) public onlyOwner returns (bool) {
81         bytes32 currency = encodeCurrency(ticker);
82         NewSymbol(currency);
83         supported[currency] = true;
84         currencies.push(currency);
85         return true;
86     }
87 
88     /**
89         @return the currency encoded as a bytes32
90     */
91     function encodeCurrency(string currency) public pure returns (bytes32 o) {
92         require(bytes(currency).length <= 32);
93         assembly {
94             o := mload(add(currency, 32))
95         }
96     }
97     
98     /**
99         @return the currency string from a encoded bytes32
100     */
101     function decodeCurrency(bytes32 b) public pure returns (string o) {
102         uint256 ns = 256;
103         while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }
104         assembly {
105             ns := div(ns, 8)
106             o := mload(0x40)
107             mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))
108             mstore(o, ns)
109             mstore(add(o, 32), b)
110         }
111     }
112     
113 }
114 
115 // File: contracts/interfaces/Engine.sol
116 
117 contract Engine {
118     uint256 public VERSION;
119     string public VERSION_NAME;
120 
121     enum Status { initial, lent, paid, destroyed }
122     struct Approbation {
123         bool approved;
124         bytes data;
125         bytes32 checksum;
126     }
127 
128     function getTotalLoans() public view returns (uint256);
129     function getOracle(uint index) public view returns (Oracle);
130     function getBorrower(uint index) public view returns (address);
131     function getCosigner(uint index) public view returns (address);
132     function ownerOf(uint256) public view returns (address owner);
133     function getCreator(uint index) public view returns (address);
134     function getAmount(uint index) public view returns (uint256);
135     function getPaid(uint index) public view returns (uint256);
136     function getDueTime(uint index) public view returns (uint256);
137     function getApprobation(uint index, address _address) public view returns (bool);
138     function getStatus(uint index) public view returns (Status);
139     function isApproved(uint index) public view returns (bool);
140     function getPendingAmount(uint index) public returns (uint256);
141     function getCurrency(uint index) public view returns (bytes32);
142     function cosign(uint index, uint256 cost) external returns (bool);
143     function approveLoan(uint index) public returns (bool);
144     function transfer(address to, uint256 index) public returns (bool);
145     function takeOwnership(uint256 index) public returns (bool);
146     function withdrawal(uint index, address to, uint256 amount) public returns (bool);
147     function identifierToIndex(bytes32 signature) public view returns (uint256);
148 }
149 
150 // File: contracts/interfaces/Cosigner.sol
151 
152 /**
153     @dev Defines the interface of a standard RCN cosigner.
154 
155     The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
156     of the insurance and the cost of the given are defined by the cosigner. 
157 
158     The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
159     agent should be passed as params when the lender calls the "lend" method on the engine.
160     
161     When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
162     should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
163     call this method, like the transfer of the ownership of the loan.
164 */
165 contract Cosigner {
166     uint256 public constant VERSION = 2;
167     
168     /**
169         @return the url of the endpoint that exposes the insurance offers.
170     */
171     function url() public view returns (string);
172     
173     /**
174         @dev Retrieves the cost of a given insurance, this amount should be exact.
175 
176         @return the cost of the cosign, in RCN wei
177     */
178     function cost(address engine, uint256 index, bytes data, bytes oracleData) public view returns (uint256);
179     
180     /**
181         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
182         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
183         does not return true to this method, the operation fails.
184 
185         @return true if the cosigner accepts the liability
186     */
187     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool);
188     
189     /**
190         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
191         current lender of the loan.
192 
193         @return true if the claim was done correctly.
194     */
195     function claim(address engine, uint256 index, bytes oracleData) external returns (bool);
196 }
197 
198 // File: contracts/interfaces/ERC721.sol
199 
200 contract ERC721 {
201     /*
202    // ERC20 compatible functions
203    function name() public view returns (string _name);
204    function symbol() public view returns (string _symbol);
205    function totalSupply() public view returns (uint256 _totalSupply);
206    function balanceOf(address _owner) public view returns (uint _balance);
207    // Functions that define ownership
208    function ownerOf(uint256) public view returns (address owner);
209    function approve(address, uint256) public returns (bool);
210    function takeOwnership(uint256) public returns (bool);
211    function transfer(address, uint256) public returns (bool);
212    function setApprovalForAll(address _operator, bool _approved) public returns (bool);
213    function getApproved(uint256 _tokenId) public view returns (address);
214    function isApprovedForAll(address _owner, address _operator) public view returns (bool);
215    function transferFrom(address from, address to, uint256 index) public returns (bool);
216    // Token metadata
217    function tokenMetadata(uint256 _tokenId) public view returns (string info);
218    */
219    // Events
220    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
221    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
222    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
223 }
224 
225 // File: contracts/utils/SafeMath.sol
226 
227 library SafeMath {
228     function add(uint256 x, uint256 y) internal pure returns (uint256) {
229         uint256 z = x + y;
230         require((z >= x) && (z >= y), "Add overflow");
231         return z;
232     }
233 
234     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
235         require(x >= y, "Sub underflow");
236         uint256 z = x - y;
237         return z;
238     }
239 
240     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
241         uint256 z = x * y;
242         require((x == 0)||(z/x == y), "Mult overflow");
243         return z;
244     }
245 }
246 
247 // File: contracts/utils/ERC165.sol
248 
249 /**
250  * @title ERC165
251  * @author Matt Condon (@shrugs)
252  * @dev Implements ERC165 using a lookup table.
253  */
254 contract ERC165 {
255     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
256     /**
257     * 0x01ffc9a7 ===
258     *   bytes4(keccak256('supportsInterface(bytes4)'))
259     */
260 
261     /**
262     * @dev a mapping of interface id to whether or not it's supported
263     */
264     mapping(bytes4 => bool) private _supportedInterfaces;
265 
266     /**
267     * @dev A contract implementing SupportsInterfaceWithLookup
268     * implement ERC165 itself
269     */
270     constructor()
271         internal
272     {
273         _registerInterface(_InterfaceId_ERC165);
274     }
275 
276     /**
277     * @dev implement supportsInterface(bytes4) using a lookup table
278     */
279     function supportsInterface(bytes4 interfaceId)
280         external
281         view
282         returns (bool)
283     {
284         return _supportedInterfaces[interfaceId];
285     }
286 
287     /**
288     * @dev internal method for registering an interface
289     */
290     function _registerInterface(bytes4 interfaceId)
291         internal
292     {
293         require(interfaceId != 0xffffffff, "Can't register 0xffffffff");
294         _supportedInterfaces[interfaceId] = true;
295     }
296 }
297 
298 // File: contracts/ERC721Base.sol
299 
300 interface URIProvider {
301     function tokenURI(uint256 _tokenId) external view returns (string);
302 }
303 
304 contract ERC721Base is ERC165 {
305     using SafeMath for uint256;
306 
307     mapping(uint256 => address) private _holderOf;
308     mapping(address => uint256[]) private _assetsOf;
309     mapping(address => mapping(address => bool)) private _operators;
310     mapping(uint256 => address) private _approval;
311     mapping(uint256 => uint256) private _indexOfAsset;
312 
313     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
314     bytes4 private constant ERC721_RECEIVED_LEGACY = 0xf0b9e5ba;
315 
316     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
317     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
318     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
319 
320     bytes4 private constant ERC_721_INTERFACE = 0x80ac58cd;
321     bytes4 private constant ERC_721_METADATA_INTERFACE = 0x5b5e139f;
322     bytes4 private constant ERC_721_ENUMERATION_INTERFACE = 0x780e9d63;
323 
324     constructor(
325         string name,
326         string symbol
327     ) public {
328         _name = name;
329         _symbol = symbol;
330 
331         _registerInterface(ERC_721_INTERFACE);
332         _registerInterface(ERC_721_METADATA_INTERFACE);
333         _registerInterface(ERC_721_ENUMERATION_INTERFACE);
334     }
335 
336     // ///
337     // ERC721 Metadata
338     // ///
339 
340     /// ERC-721 Non-Fungible Token Standard, optional metadata extension
341     /// See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
342     /// Note: the ERC-165 identifier for this interface is 0x5b5e139f.
343 
344     event SetURIProvider(address _uriProvider);
345 
346     string private _name;
347     string private _symbol;
348 
349     URIProvider private _uriProvider;
350 
351     // @notice A descriptive name for a collection of NFTs in this contract
352     function name() external view returns (string) {
353         return _name;
354     }
355 
356     // @notice An abbreviated name for NFTs in this contract
357     function symbol() external view returns (string) {
358         return _symbol;
359     }
360 
361     /**
362     * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
363     * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
364     *  3986. The URI may point to a JSON file that conforms to the "ERC721
365     *  Metadata JSON Schema".
366     */
367     function tokenURI(uint256 _tokenId) external view returns (string) {
368         require(_holderOf[_tokenId] != 0, "Asset does not exist");
369         URIProvider provider = _uriProvider;
370         return provider == address(0) ? "" : provider.tokenURI(_tokenId);
371     }
372 
373     function _setURIProvider(URIProvider _provider) internal returns (bool) {
374         emit SetURIProvider(_provider);
375         _uriProvider = _provider;
376         return true;
377     }
378  
379     // ///
380     // ERC721 Enumeration
381     // ///
382 
383     ///  ERC-721 Non-Fungible Token Standard, optional enumeration extension
384     ///  See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
385     ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
386 
387     uint256[] private _allTokens;
388 
389     function allTokens() external view returns (uint256[]) {
390         return _allTokens;
391     }
392 
393     function assetsOf(address _owner) external view returns (uint256[]) {
394         return _assetsOf[_owner];
395     }
396 
397     /**
398      * @dev Gets the total amount of assets stored by the contract
399      * @return uint256 representing the total amount of assets
400      */
401     function totalSupply() external view returns (uint256) {
402         return _allTokens.length;
403     }
404 
405     /**
406     * @notice Enumerate valid NFTs
407     * @dev Throws if `_index` >= `totalSupply()`.
408     * @param _index A counter less than `totalSupply()`
409     * @return The token identifier for the `_index`th NFT,
410     *  (sort order not specified)
411     */
412     function tokenByIndex(uint256 _index) external view returns (uint256) {
413         require(_index < _allTokens.length, "Index out of bounds");
414         return _allTokens[_index];
415     }
416 
417     /**
418     * @notice Enumerate NFTs assigned to an owner
419     * @dev Throws if `_index` >= `balanceOf(_owner)` or if
420     *  `_owner` is the zero address, representing invalid NFTs.
421     * @param _owner An address where we are interested in NFTs owned by them
422     * @param _index A counter less than `balanceOf(_owner)`
423     * @return The token identifier for the `_index`th NFT assigned to `_owner`,
424     *   (sort order not specified)
425     */
426     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
427         require(_owner != address(0), "0x0 Is not a valid owner");
428         require(_index < _balanceOf(_owner), "Index out of bounds");
429         return _assetsOf[_owner][_index];
430     }
431 
432     //
433     // Asset-centric getter functions
434     //
435 
436     /**
437      * @dev Queries what address owns an asset. This method does not throw.
438      * In order to check if the asset exists, use the `exists` function or check if the
439      * return value of this call is `0`.
440      * @return uint256 the assetId
441      */
442     function ownerOf(uint256 _assetId) external view returns (address) {
443         return _ownerOf(_assetId);
444     }
445     function _ownerOf(uint256 _assetId) internal view returns (address) {
446         return _holderOf[_assetId];
447     }
448 
449     //
450     // Holder-centric getter functions
451     //
452     /**
453      * @dev Gets the balance of the specified address
454      * @param _owner address to query the balance of
455      * @return uint256 representing the amount owned by the passed address
456      */
457     function balanceOf(address _owner) external view returns (uint256) {
458         return _balanceOf(_owner);
459     }
460     function _balanceOf(address _owner) internal view returns (uint256) {
461         return _assetsOf[_owner].length;
462     }
463 
464     //
465     // Authorization getters
466     //
467 
468     /**
469      * @dev Query whether an address has been authorized to move any assets on behalf of someone else
470      * @param _operator the address that might be authorized
471      * @param _assetHolder the address that provided the authorization
472      * @return bool true if the operator has been authorized to move any assets
473      */
474     function isApprovedForAll(
475         address _operator,
476         address _assetHolder
477     ) external view returns (bool) {
478         return _isApprovedForAll(_operator, _assetHolder);
479     }
480     function _isApprovedForAll(
481         address _operator,
482         address _assetHolder
483     ) internal view returns (bool) {
484         return _operators[_assetHolder][_operator];
485     }
486 
487     /**
488      * @dev Query what address has been particularly authorized to move an asset
489      * @param _assetId the asset to be queried for
490      * @return bool true if the asset has been approved by the holder
491      */
492     function getApprovedAddress(uint256 _assetId) external view returns (address) {
493         return _getApprovedAddress(_assetId);
494     }
495     function _getApprovedAddress(uint256 _assetId) internal view returns (address) {
496         return _approval[_assetId];
497     }
498 
499     /**
500      * @dev Query if an operator can move an asset.
501      * @param _operator the address that might be authorized
502      * @param _assetId the asset that has been `approved` for transfer
503      * @return bool true if the asset has been approved by the holder
504      */
505     function isAuthorized(address _operator, uint256 _assetId) external view returns (bool) {
506         return _isAuthorized(_operator, _assetId);
507     }
508     function _isAuthorized(address _operator, uint256 _assetId) internal view returns (bool) {
509         require(_operator != 0, "0x0 is an invalid operator");
510         address owner = _ownerOf(_assetId);
511         if (_operator == owner) {
512             return true;
513         }
514         return _isApprovedForAll(_operator, owner) || _getApprovedAddress(_assetId) == _operator;
515     }
516 
517     //
518     // Authorization
519     //
520 
521     /**
522      * @dev Authorize a third party operator to manage (send) msg.sender's asset
523      * @param _operator address to be approved
524      * @param _authorized bool set to true to authorize, false to withdraw authorization
525      */
526     function setApprovalForAll(address _operator, bool _authorized) external {
527         if (_operators[msg.sender][_operator] != _authorized) {
528             _operators[msg.sender][_operator] = _authorized;
529             emit ApprovalForAll(_operator, msg.sender, _authorized);
530         }
531     }
532 
533     /**
534      * @dev Authorize a third party operator to manage one particular asset
535      * @param _operator address to be approved
536      * @param _assetId asset to approve
537      */
538     function approve(address _operator, uint256 _assetId) external {
539         address holder = _ownerOf(_assetId);
540         require(msg.sender == holder || _isApprovedForAll(msg.sender, holder), "msg.sender can't approve");
541         if (_getApprovedAddress(_assetId) != _operator) {
542             _approval[_assetId] = _operator;
543             emit Approval(holder, _operator, _assetId);
544         }
545     }
546 
547     //
548     // Internal Operations
549     //
550 
551     function _addAssetTo(address _to, uint256 _assetId) internal {
552         // Store asset owner
553         _holderOf[_assetId] = _to;
554 
555         // Store index of the asset
556         uint256 length = _balanceOf(_to);
557         _assetsOf[_to].push(_assetId);
558         _indexOfAsset[_assetId] = length;
559 
560         // Save main enumerable
561         _allTokens.push(_assetId);
562     }
563 
564     function _transferAsset(address _from, address _to, uint256 _assetId) internal {
565         uint256 assetIndex = _indexOfAsset[_assetId];
566         uint256 lastAssetIndex = _balanceOf(_from).sub(1);
567 
568         if (assetIndex != lastAssetIndex) {
569             // Replace current asset with last asset
570             uint256 lastAssetId = _assetsOf[_from][lastAssetIndex];
571             // Insert the last asset into the position previously occupied by the asset to be removed
572             _assetsOf[_from][assetIndex] = lastAssetId;
573         }
574 
575         // Resize the array
576         _assetsOf[_from][lastAssetIndex] = 0;
577         _assetsOf[_from].length--;
578 
579         // Change owner
580         _holderOf[_assetId] = _to;
581 
582         // Update the index of positions of the asset
583         uint256 length = _balanceOf(_to);
584         _assetsOf[_to].push(_assetId);
585         _indexOfAsset[_assetId] = length;
586     }
587 
588     function _clearApproval(address _holder, uint256 _assetId) internal {
589         if (_approval[_assetId] != 0) {
590             _approval[_assetId] = 0;
591             emit Approval(_holder, 0, _assetId);
592         }
593     }
594 
595     //
596     // Supply-altering functions
597     //
598 
599     function _generate(uint256 _assetId, address _beneficiary) internal {
600         require(_holderOf[_assetId] == 0, "Asset already exists");
601 
602         _addAssetTo(_beneficiary, _assetId);
603 
604         emit Transfer(0x0, _beneficiary, _assetId);
605     }
606 
607     //
608     // Transaction related operations
609     //
610 
611     modifier onlyHolder(uint256 _assetId) {
612         require(_ownerOf(_assetId) == msg.sender, "msg.sender Is not holder");
613         _;
614     }
615 
616     modifier onlyAuthorized(uint256 _assetId) {
617         require(_isAuthorized(msg.sender, _assetId), "msg.sender Not authorized");
618         _;
619     }
620 
621     modifier isCurrentOwner(address _from, uint256 _assetId) {
622         require(_ownerOf(_assetId) == _from, "Not current owner");
623         _;
624     }
625 
626     modifier addressDefined(address _target) {
627         require(_target != address(0), "Target can't be 0x0");
628         _;
629     }
630 
631     /**
632      * @dev Alias of `safeTransferFrom(from, to, assetId, '')`
633      *
634      * @param _from address that currently owns an asset
635      * @param _to address to receive the ownership of the asset
636      * @param _assetId uint256 ID of the asset to be transferred
637      */
638     function safeTransferFrom(address _from, address _to, uint256 _assetId) external {
639         return _doTransferFrom(_from, _to, _assetId, "", true);
640     }
641 
642     /**
643      * @dev Securely transfers the ownership of a given asset from one address to
644      * another address, calling the method `onNFTReceived` on the target address if
645      * there's code associated with it
646      *
647      * @param _from address that currently owns an asset
648      * @param _to address to receive the ownership of the asset
649      * @param _assetId uint256 ID of the asset to be transferred
650      * @param _userData bytes arbitrary user information to attach to this transfer
651      */
652     function safeTransferFrom(address _from, address _to, uint256 _assetId, bytes _userData) external {
653         return _doTransferFrom(_from, _to, _assetId, _userData, true);
654     }
655 
656     /**
657      * @dev Transfers the ownership of a given asset from one address to another address
658      * Warning! This function does not attempt to verify that the target address can send
659      * tokens.
660      *
661      * @param _from address sending the asset
662      * @param _to address to receive the ownership of the asset
663      * @param _assetId uint256 ID of the asset to be transferred
664      */
665     function transferFrom(address _from, address _to, uint256 _assetId) external {
666         return _doTransferFrom(_from, _to, _assetId, "", false);
667     }
668 
669     /**
670      * Internal function that moves an asset from one holder to another
671      */
672     function _doTransferFrom(
673         address _from,
674         address _to,
675         uint256 _assetId,
676         bytes _userData,
677         bool _doCheck
678     )
679         internal
680         onlyAuthorized(_assetId)
681         addressDefined(_to)
682         isCurrentOwner(_from, _assetId)
683     {
684         address holder = _holderOf[_assetId];
685         _clearApproval(holder, _assetId);
686         _transferAsset(holder, _to, _assetId);
687 
688         if (_doCheck && _isContract(_to)) {
689             // Call dest contract
690             uint256 success;
691             bytes32 result;
692             // Perform check with the new safe call
693             // onERC721Received(address,address,uint256,bytes)
694             (success, result) = _noThrowCall(
695                 _to,
696                 abi.encodeWithSelector(
697                     ERC721_RECEIVED,
698                     msg.sender,
699                     holder,
700                     _assetId,
701                     _userData
702                 )
703             );
704 
705             if (success != 1 || result != ERC721_RECEIVED) {
706                 // Try legacy safe call
707                 // onERC721Received(address,uint256,bytes)
708                 (success, result) = _noThrowCall(
709                     _to,
710                     abi.encodeWithSelector(
711                         ERC721_RECEIVED_LEGACY,
712                         holder,
713                         _assetId,
714                         _userData
715                     )
716                 );
717 
718                 require(
719                     success == 1 && result == ERC721_RECEIVED_LEGACY,
720                     "Contract rejected the token"
721                 );
722             }
723         }
724 
725         emit Transfer(holder, _to, _assetId);
726     }
727 
728     //
729     // Utilities
730     //
731 
732     function _isContract(address _addr) internal view returns (bool) {
733         uint size;
734         assembly { size := extcodesize(_addr) }
735         return size > 0;
736     }
737 
738     function _noThrowCall(
739         address _contract,
740         bytes _data
741     ) internal returns (uint256 success, bytes32 result) {
742         assembly {
743             let x := mload(0x40)
744 
745             success := call(
746                             gas,                  // Send all gas
747                             _contract,            // To addr
748                             0,                    // Send ETH
749                             add(0x20, _data),     // Input is data past the first 32 bytes
750                             mload(_data),         // Input size is the lenght of data
751                             x,                    // Store the ouput on x
752                             0x20                  // Output is a single bytes32, has 32 bytes
753                         )
754 
755             result := mload(x)
756         }
757     }
758 }
759 
760 // File: contracts/utils/SafeWithdraw.sol
761 
762 contract SafeWithdraw is Ownable {
763     function withdrawTokens(Token token, address to, uint256 amount) external onlyOwner returns (bool) {
764         require(to != address(0), "Can't transfer to address 0x0");
765         return token.transfer(to, amount);
766     }
767     
768     function withdrawErc721(ERC721Base token, address to, uint256 id) external onlyOwner returns (bool) {
769         require(to != address(0), "Can't transfer to address 0x0");
770         token.transferFrom(this, to, id);
771     }
772     
773     function withdrawEth(address to, uint256 amount) external onlyOwner returns (bool) {
774         to.transfer(amount);
775         return true;
776     }
777 }
778 
779 // File: contracts/utils/BytesUtils.sol
780 
781 contract BytesUtils {
782     function readBytes32(bytes data, uint256 index) internal pure returns (bytes32 o) {
783         require(data.length / 32 > index);
784         assembly {
785             o := mload(add(data, add(32, mul(32, index))))
786         }
787     }
788 }
789 
790 // File: contracts/interfaces/TokenConverter.sol
791 
792 contract TokenConverter {
793     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
794     function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);
795     function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);
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