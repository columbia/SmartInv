1 pragma solidity ^0.5.7;
2 
3 
4 interface IERC20 {
5     function transfer(address _to, uint _value) external returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
7     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
8     function approve(address _spender, uint256 _value) external returns (bool success);
9     function increaseApproval (address _spender, uint _addedValue) external returns (bool success);
10     function balanceOf(address _owner) external view returns (uint256 balance);
11 }
12 
13 // File: contracts/interfaces/IERC165.sol
14 
15 pragma solidity ^0.5.7;
16 
17 
18 interface IERC165 {
19     /// @notice Query if a contract implements an interface
20     /// @param interfaceID The interface identifier, as specified in ERC-165
21     /// @dev Interface identification is specified in ERC-165. This function
22     ///  uses less than 30,000 gas.
23     /// @return `true` if the contract implements `interfaceID` and
24     ///  `interfaceID` is not 0xffffffff, `false` otherwise
25     function supportsInterface(bytes4 interfaceID) external view returns (bool);
26 }
27 
28 // File: contracts/core/diaspore/interfaces/Model.sol
29 
30 pragma solidity ^0.5.7;
31 
32 
33 
34 /**
35     The abstract contract Model defines the whole lifecycle of a debt on the DebtEngine.
36 
37     Models can be used without previous approbation, this is meant
38     to avoid centralization on the development of RCN; this implies that not all models are secure.
39     Models can have back-doors, bugs and they have not guarantee of being autonomous.
40 
41     The DebtEngine is meant to be the User of this model,
42     so all the methods with the ability to perform state changes should only be callable by the DebtEngine.
43 
44     All models should implement the 0xaf498c35 interface.
45 
46     @author Agustin Aguilar
47 */
48 contract Model is IERC165 {
49     // ///
50     // Events
51     // ///
52 
53     /**
54         @dev This emits when create a new debt.
55     */
56     event Created(bytes32 indexed _id);
57 
58     /**
59         @dev This emits when the status of debt change.
60 
61         @param _timestamp Timestamp of the registry
62         @param _status New status of the registry
63     */
64     event ChangedStatus(bytes32 indexed _id, uint256 _timestamp, uint256 _status);
65 
66     /**
67         @dev This emits when the obligation of debt change.
68 
69         @param _timestamp Timestamp of the registry
70         @param _debt New debt of the registry
71     */
72     event ChangedObligation(bytes32 indexed _id, uint256 _timestamp, uint256 _debt);
73 
74     /**
75         @dev This emits when the frequency of debt change.
76 
77         @param _timestamp Timestamp of the registry
78         @param _frequency New frequency of each installment
79     */
80     event ChangedFrequency(bytes32 indexed _id, uint256 _timestamp, uint256 _frequency);
81 
82     /**
83         @param _timestamp Timestamp of the registry
84     */
85     event ChangedDueTime(bytes32 indexed _id, uint256 _timestamp, uint256 _status);
86 
87     /**
88         @param _timestamp Timestamp of the registry
89         @param _dueTime New dueTime of each installment
90     */
91     event ChangedFinalTime(bytes32 indexed _id, uint256 _timestamp, uint64 _dueTime);
92 
93     /**
94         @dev This emits when the call addDebt function.
95 
96         @param _amount New amount of the debt, old amount plus added
97     */
98     event AddedDebt(bytes32 indexed _id, uint256 _amount);
99 
100     /**
101         @dev This emits when the call addPaid function.
102 
103         If the registry is fully paid on the call and the amount parameter exceeds the required
104             payment amount, the event emits the real amount paid on the payment.
105 
106         @param _paid Real amount paid
107     */
108     event AddedPaid(bytes32 indexed _id, uint256 _paid);
109 
110     // Model interface selector
111     bytes4 internal constant MODEL_INTERFACE = 0xaf498c35;
112 
113     uint256 public constant STATUS_ONGOING = 1;
114     uint256 public constant STATUS_PAID = 2;
115     uint256 public constant STATUS_ERROR = 4;
116 
117     // ///
118     // Meta
119     // ///
120 
121     /**
122         @return Identifier of the model
123     */
124     function modelId() external view returns (bytes32);
125 
126     /**
127         Returns the address of the contract used as Descriptor of the model
128 
129         @dev The descriptor contract should follow the ModelDescriptor.sol scheme
130 
131         @return Address of the descriptor
132     */
133     function descriptor() external view returns (address);
134 
135     /**
136         If called for any address with the ability to modify the state of the model registries,
137             this method should return True.
138 
139         @dev Some contracts may check if the DebtEngine is
140             an operator to know if the model is operative or not.
141 
142         @param operator Address of the target request operator
143 
144         @return True if operator is able to modify the state of the model
145     */
146     function isOperator(address operator) external view returns (bool canOperate);
147 
148     /**
149         Validates the data for the creation of a new registry, if returns True the
150             same data should be compatible with the create method.
151 
152         @dev This method can revert the call or return false, and both meant an invalid data.
153 
154         @param data Data to validate
155 
156         @return True if the data can be used to create a new registry
157     */
158     function validate(bytes calldata data) external view returns (bool isValid);
159 
160     // ///
161     // Getters
162     // ///
163 
164     /**
165         Exposes the current status of the registry. The possible values are:
166 
167         1: Ongoing - The debt is still ongoing and waiting to be paid
168         2: Paid - The debt is already paid and
169         4: Error - There was an Error with the registry
170 
171         @dev This method should always be called by the DebtEngine
172 
173         @param id Id of the registry
174 
175         @return The current status value
176     */
177     function getStatus(bytes32 id) external view returns (uint256 status);
178 
179     /**
180         Returns the total paid amount on the registry.
181 
182         @dev it should equal to the sum of all real addPaid
183 
184         @param id Id of the registry
185 
186         @return Total paid amount
187     */
188     function getPaid(bytes32 id) external view returns (uint256 paid);
189 
190     /**
191         If the returned amount does not depend on any interactions and only on the model logic,
192             the defined flag will be True; if the amount is an estimation of the future debt,
193             the flag will be set to False.
194 
195         If timestamp equals the current moment, the defined flag should always be True.
196 
197         @dev This can be a gas-intensive method to call, consider calling the run method before.
198 
199         @param id Id of the registry
200         @param timestamp Timestamp of the obligation query
201 
202         @return amount Amount pending to pay on the given timestamp
203         @return defined True If the amount returned is fixed and can't change
204     */
205     function getObligation(bytes32 id, uint64 timestamp) external view returns (uint256 amount, bool defined);
206 
207     /**
208         The amount required to fully paid a registry.
209 
210         All registries should be payable in a single time, even when it has multiple installments.
211 
212         If the registry discounts interest for early payment, those discounts should be
213             taken into account in the returned amount.
214 
215         @dev This can be a gas-intensive method to call, consider calling the run method before.
216 
217         @param id Id of the registry
218 
219         @return amount Amount required to fully paid the loan on the current timestamp
220     */
221     function getClosingObligation(bytes32 id) external view returns (uint256 amount);
222 
223     /**
224         The timestamp of the next required payment.
225 
226         After this moment, if the payment goal is not met the debt will be considered overdue.
227 
228             The getObligation method can be used to know the required payment on the future timestamp.
229 
230         @param id Id of the registry
231 
232         @return timestamp The timestamp of the next due time
233     */
234     function getDueTime(bytes32 id) external view returns (uint256 timestamp);
235 
236     // ///
237     // Metadata
238     // ///
239 
240     /**
241         If the loan has multiple installments returns the duration of each installment in seconds,
242             if the loan has not installments it should return 1.
243 
244         @param id Id of the registry
245 
246         @return frequency Frequency of each installment
247     */
248     function getFrequency(bytes32 id) external view returns (uint256 frequency);
249 
250     /**
251         If the loan has multiple installments returns the total of installments,
252             if the loan has not installments it should return 1.
253 
254         @param id Id of the registry
255 
256         @return installments Total of installments
257     */
258     function getInstallments(bytes32 id) external view returns (uint256 installments);
259 
260     /**
261         The registry could be paid before or after the date, but the debt will always be
262             considered overdue if paid after this timestamp.
263 
264         This is the estimated final payment date of the debt if it's always paid on each exact dueTime.
265 
266         @param id Id of the registry
267 
268         @return timestamp Timestamp of the final due time
269     */
270     function getFinalTime(bytes32 id) external view returns (uint256 timestamp);
271 
272     /**
273         Similar to getFinalTime returns the expected payment remaining if paid always on the exact dueTime.
274 
275         If the model has no interest discounts for early payments,
276             this method should return the same value as getClosingObligation.
277 
278         @param id Id of the registry
279 
280         @return amount Expected payment amount
281     */
282     function getEstimateObligation(bytes32 id) external view returns (uint256 amount);
283 
284     // ///
285     // State interface
286     // ///
287 
288     /**
289         Creates a new registry using the provided data and id, it should fail if the id already exists
290             or if calling validate(data) returns false or throws.
291 
292         @dev This method should only be callable by an operator
293 
294         @param id Id of the registry to create
295         @param data Data to construct the new registry
296 
297         @return success True if the registry was created
298     */
299     function create(bytes32 id, bytes calldata data) external returns (bool success);
300 
301     /**
302         If the registry is fully paid on the call and the amount parameter exceeds the required
303             payment amount, the method returns the real amount used on the payment.
304 
305         The payment taken should always be the same as the requested unless the registry
306             is fully paid on the process.
307 
308         @dev This method should only be callable by an operator
309 
310         @param id If of the registry
311         @param amount Amount to pay
312 
313         @return real Real amount paid
314     */
315     function addPaid(bytes32 id, uint256 amount) external returns (uint256 real);
316 
317     /**
318         Adds a new amount to be paid on the debt model,
319             each model can handle the addition of more debt freely.
320 
321         @dev This method should only be callable by an operator
322 
323         @param id Id of the registry
324         @param amount Debt amount to add to the registry
325 
326         @return added True if the debt was added
327     */
328     function addDebt(bytes32 id, uint256 amount) external returns (bool added);
329 
330     // ///
331     // Utils
332     // ///
333 
334     /**
335         Runs the internal clock of a registry, this is used to compute the last changes on the state.
336             It can make transactions cheaper by avoiding multiple calculations when calling views.
337 
338         Not all models have internal clocks, a model without an internal clock should always return false.
339 
340         Calls to this method should be possible from any address,
341             multiple calls to run shouldn't affect the internal calculations of the model.
342 
343         @dev If the call had no effect the method would return False,
344             that is no sign of things going wrong, and the call shouldn't be wrapped on a require
345 
346         @param id If of the registry
347 
348         @return effect True if the run performed a change on the state
349     */
350     function run(bytes32 id) external returns (bool effect);
351 }
352 
353 // File: contracts/core/diaspore/interfaces/RateOracle.sol
354 
355 pragma solidity ^0.5.7;
356 
357 
358 
359 /**
360     @dev Defines the interface of a standard Diaspore RCN Oracle,
361 
362     The contract should also implement it's ERC165 interface: 0xa265d8e0
363 
364     @notice Each oracle can only support one currency
365 
366     @author Agustin Aguilar
367 */
368 contract RateOracle is IERC165 {
369     uint256 public constant VERSION = 5;
370     bytes4 internal constant RATE_ORACLE_INTERFACE = 0xa265d8e0;
371 
372     constructor() internal {}
373 
374     /**
375         3 or 4 letters symbol of the currency, Ej: ETH
376     */
377     function symbol() external view returns (string memory);
378 
379     /**
380         Descriptive name of the currency, Ej: Ethereum
381     */
382     function name() external view returns (string memory);
383 
384     /**
385         The number of decimals of the currency represented by this Oracle,
386             it should be the most common number of decimal places
387     */
388     function decimals() external view returns (uint256);
389 
390     /**
391         The base token on which the sample is returned
392             should be the RCN Token address.
393     */
394     function token() external view returns (address);
395 
396     /**
397         The currency symbol encoded on a UTF-8 Hex
398     */
399     function currency() external view returns (bytes32);
400 
401     /**
402         The name of the Individual or Company in charge of this Oracle
403     */
404     function maintainer() external view returns (string memory);
405 
406     /**
407         Returns the url where the oracle exposes a valid "oracleData" if needed
408     */
409     function url() external view returns (string memory);
410 
411     /**
412         Returns a sample on how many token() are equals to how many currency()
413     */
414     function readSample(bytes calldata _data) external returns (uint256 _tokens, uint256 _equivalent);
415 }
416 
417 // File: contracts/utils/IsContract.sol
418 
419 pragma solidity ^0.5.7;
420 
421 
422 library IsContract {
423     function isContract(address _addr) internal view returns (bool) {
424         uint size;
425         assembly { size := extcodesize(_addr) }
426         return size > 0;
427     }
428 }
429 
430 // File: contracts/utils/SafeMath.sol
431 
432 pragma solidity ^0.5.7;
433 
434 
435 library SafeMath {
436     function add(uint256 x, uint256 y) internal pure returns (uint256) {
437         uint256 z = x + y;
438         require(z >= x, "Add overflow");
439         return z;
440     }
441 
442     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
443         require(x >= y, "Sub underflow");
444         return x - y;
445     }
446 
447     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
448         if (x == 0) {
449             return 0;
450         }
451 
452         uint256 z = x * y;
453         require(z/x == y, "Mult overflow");
454         return z;
455     }
456 }
457 
458 // File: contracts/commons/ERC165.sol
459 
460 pragma solidity ^0.5.7;
461 
462 
463 
464 /**
465  * @title ERC165
466  * @author Matt Condon (@shrugs)
467  * @dev Implements ERC165 using a lookup table.
468  */
469 contract ERC165 is IERC165 {
470     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
471     /**
472     * 0x01ffc9a7 ===
473     *   bytes4(keccak256('supportsInterface(bytes4)'))
474     */
475 
476     /**
477     * @dev a mapping of interface id to whether or not it's supported
478     */
479     mapping(bytes4 => bool) private _supportedInterfaces;
480 
481     /**
482     * @dev A contract implementing SupportsInterfaceWithLookup
483     * implement ERC165 itself
484     */
485     constructor()
486         internal
487     {
488         _registerInterface(_InterfaceId_ERC165);
489     }
490 
491     /**
492     * @dev implement supportsInterface(bytes4) using a lookup table
493     */
494     function supportsInterface(bytes4 interfaceId)
495         external
496         view
497         returns (bool)
498     {
499         return _supportedInterfaces[interfaceId];
500     }
501 
502     /**
503     * @dev internal method for registering an interface
504     */
505     function _registerInterface(bytes4 interfaceId)
506         internal
507     {
508         require(interfaceId != 0xffffffff, "Can't register 0xffffffff");
509         _supportedInterfaces[interfaceId] = true;
510     }
511 }
512 
513 // File: contracts/commons/ERC721Base.sol
514 
515 pragma solidity ^0.5.7;
516 
517 
518 
519 
520 
521 interface URIProvider {
522     function tokenURI(uint256 _tokenId) external view returns (string memory);
523 }
524 
525 
526 contract ERC721Base is ERC165 {
527     using SafeMath for uint256;
528     using IsContract for address;
529 
530     mapping(uint256 => address) private _holderOf;
531 
532     // Owner to array of assetId
533     mapping(address => uint256[]) private _assetsOf;
534     // AssetId to index on array in _assetsOf mapping
535     mapping(uint256 => uint256) private _indexOfAsset;
536 
537     mapping(address => mapping(address => bool)) private _operators;
538     mapping(uint256 => address) private _approval;
539 
540     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
541     bytes4 private constant ERC721_RECEIVED_LEGACY = 0xf0b9e5ba;
542 
543     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
544     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
545     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
546 
547     bytes4 private constant ERC_721_INTERFACE = 0x80ac58cd;
548     bytes4 private constant ERC_721_METADATA_INTERFACE = 0x5b5e139f;
549     bytes4 private constant ERC_721_ENUMERATION_INTERFACE = 0x780e9d63;
550 
551     constructor(
552         string memory name,
553         string memory symbol
554     ) public {
555         _name = name;
556         _symbol = symbol;
557 
558         _registerInterface(ERC_721_INTERFACE);
559         _registerInterface(ERC_721_METADATA_INTERFACE);
560         _registerInterface(ERC_721_ENUMERATION_INTERFACE);
561     }
562 
563     // ///
564     // ERC721 Metadata
565     // ///
566 
567     /// ERC-721 Non-Fungible Token Standard, optional metadata extension
568     /// See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
569     /// Note: the ERC-165 identifier for this interface is 0x5b5e139f.
570 
571     event SetURIProvider(address _uriProvider);
572 
573     string private _name;
574     string private _symbol;
575 
576     URIProvider private _uriProvider;
577 
578     // @notice A descriptive name for a collection of NFTs in this contract
579     function name() external view returns (string memory) {
580         return _name;
581     }
582 
583     // @notice An abbreviated name for NFTs in this contract
584     function symbol() external view returns (string memory) {
585         return _symbol;
586     }
587 
588     /**
589     * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
590     * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
591     *  3986. The URI may point to a JSON file that conforms to the "ERC721
592     *  Metadata JSON Schema".
593     */
594     function tokenURI(uint256 _tokenId) external view returns (string memory) {
595         require(_holderOf[_tokenId] != address(0), "Asset does not exist");
596         URIProvider provider = _uriProvider;
597         return address(provider) == address(0) ? "" : provider.tokenURI(_tokenId);
598     }
599 
600     function _setURIProvider(URIProvider _provider) internal returns (bool) {
601         emit SetURIProvider(address(_provider));
602         _uriProvider = _provider;
603         return true;
604     }
605 
606     // ///
607     // ERC721 Enumeration
608     // ///
609 
610     ///  ERC-721 Non-Fungible Token Standard, optional enumeration extension
611     ///  See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
612     ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
613 
614     uint256[] private _allTokens;
615 
616     function allTokens() external view returns (uint256[] memory) {
617         return _allTokens;
618     }
619 
620     function assetsOf(address _owner) external view returns (uint256[] memory) {
621         return _assetsOf[_owner];
622     }
623 
624     /**
625      * @dev Gets the total amount of assets stored by the contract
626      * @return uint256 representing the total amount of assets
627      */
628     function totalSupply() external view returns (uint256) {
629         return _allTokens.length;
630     }
631 
632     /**
633     * @notice Enumerate valid NFTs
634     * @dev Throws if `_index` >= `totalSupply()`.
635     * @param _index A counter less than `totalSupply()`
636     * @return The token identifier for the `_index` of the NFT,
637     *  (sort order not specified)
638     */
639     function tokenByIndex(uint256 _index) external view returns (uint256) {
640         require(_index < _allTokens.length, "Index out of bounds");
641         return _allTokens[_index];
642     }
643 
644     /**
645     * @notice Enumerate NFTs assigned to an owner
646     * @dev Throws if `_index` >= `balanceOf(_owner)` or if
647     *  `_owner` is the zero address, representing invalid NFTs.
648     * @param _owner An address where we are interested in NFTs owned by them
649     * @param _index A counter less than `balanceOf(_owner)`
650     * @return The token identifier for the `_index` of the NFT assigned to `_owner`,
651     *   (sort order not specified)
652     */
653     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
654         require(_owner != address(0), "0x0 Is not a valid owner");
655         require(_index < _balanceOf(_owner), "Index out of bounds");
656         return _assetsOf[_owner][_index];
657     }
658 
659     //
660     // Asset-centric getter functions
661     //
662 
663     /**
664      * @dev Queries what address owns an asset. This method does not throw.
665      * In order to check if the asset exists, use the `exists` function or check if the
666      * return value of this call is `0`.
667      * @return uint256 the assetId
668      */
669     function ownerOf(uint256 _assetId) external view returns (address) {
670         return _ownerOf(_assetId);
671     }
672 
673     function _ownerOf(uint256 _assetId) internal view returns (address) {
674         return _holderOf[_assetId];
675     }
676 
677     //
678     // Holder-centric getter functions
679     //
680     /**
681      * @dev Gets the balance of the specified address
682      * @param _owner address to query the balance of
683      * @return uint256 representing the amount owned by the passed address
684      */
685     function balanceOf(address _owner) external view returns (uint256) {
686         return _balanceOf(_owner);
687     }
688 
689     function _balanceOf(address _owner) internal view returns (uint256) {
690         return _assetsOf[_owner].length;
691     }
692 
693     //
694     // Authorization getters
695     //
696 
697     /**
698      * @dev Query whether an address has been authorized to move any assets on behalf of someone else
699      * @param _operator the address that might be authorized
700      * @param _assetHolder the address that provided the authorization
701      * @return bool true if the operator has been authorized to move any assets
702      */
703     function isApprovedForAll(
704         address _operator,
705         address _assetHolder
706     ) external view returns (bool) {
707         return _isApprovedForAll(_operator, _assetHolder);
708     }
709 
710     function _isApprovedForAll(
711         address _operator,
712         address _assetHolder
713     ) internal view returns (bool) {
714         return _operators[_assetHolder][_operator];
715     }
716 
717     /**
718      * @dev Query what address has been particularly authorized to move an asset
719      * @param _assetId the asset to be queried for
720      * @return bool true if the asset has been approved by the holder
721      */
722     function getApproved(uint256 _assetId) external view returns (address) {
723         return _getApproved(_assetId);
724     }
725 
726     function _getApproved(uint256 _assetId) internal view returns (address) {
727         return _approval[_assetId];
728     }
729 
730     /**
731      * @dev Query if an operator can move an asset.
732      * @param _operator the address that might be authorized
733      * @param _assetId the asset that has been `approved` for transfer
734      * @return bool true if the asset has been approved by the holder
735      */
736     function isAuthorized(address _operator, uint256 _assetId) external view returns (bool) {
737         return _isAuthorized(_operator, _assetId);
738     }
739 
740     function _isAuthorized(address _operator, uint256 _assetId) internal view returns (bool) {
741         require(_operator != address(0), "0x0 is an invalid operator");
742         address owner = _ownerOf(_assetId);
743 
744         return _operator == owner || _isApprovedForAll(_operator, owner) || _getApproved(_assetId) == _operator;
745     }
746 
747     //
748     // Authorization
749     //
750 
751     /**
752      * @dev Authorize a third party operator to manage (send) msg.sender's asset
753      * @param _operator address to be approved
754      * @param _authorized bool set to true to authorize, false to withdraw authorization
755      */
756     function setApprovalForAll(address _operator, bool _authorized) external {
757         if (_operators[msg.sender][_operator] != _authorized) {
758             _operators[msg.sender][_operator] = _authorized;
759             emit ApprovalForAll(msg.sender, _operator, _authorized);
760         }
761     }
762 
763     /**
764      * @dev Authorize a third party operator to manage one particular asset
765      * @param _operator address to be approved
766      * @param _assetId asset to approve
767      */
768     function approve(address _operator, uint256 _assetId) external {
769         address holder = _ownerOf(_assetId);
770         require(msg.sender == holder || _isApprovedForAll(msg.sender, holder), "msg.sender can't approve");
771         if (_getApproved(_assetId) != _operator) {
772             _approval[_assetId] = _operator;
773             emit Approval(holder, _operator, _assetId);
774         }
775     }
776 
777     //
778     // Internal Operations
779     //
780 
781     function _addAssetTo(address _to, uint256 _assetId) internal {
782         // Store asset owner
783         _holderOf[_assetId] = _to;
784 
785         // Store index of the asset
786         uint256 length = _balanceOf(_to);
787         _assetsOf[_to].push(_assetId);
788         _indexOfAsset[_assetId] = length;
789 
790         // Save main enumerable
791         _allTokens.push(_assetId);
792     }
793 
794     function _transferAsset(address _from, address _to, uint256 _assetId) internal {
795         uint256 assetIndex = _indexOfAsset[_assetId];
796         uint256 lastAssetIndex = _balanceOf(_from).sub(1);
797 
798         if (assetIndex != lastAssetIndex) {
799             // Replace current asset with last asset
800             uint256 lastAssetId = _assetsOf[_from][lastAssetIndex];
801             // Insert the last asset into the position previously occupied by the asset to be removed
802             _assetsOf[_from][assetIndex] = lastAssetId;
803             _indexOfAsset[lastAssetId] = assetIndex;
804         }
805 
806         // Resize the array
807         _assetsOf[_from][lastAssetIndex] = 0;
808         _assetsOf[_from].length--;
809 
810         // Change owner
811         _holderOf[_assetId] = _to;
812 
813         // Update the index of positions of the asset
814         uint256 length = _balanceOf(_to);
815         _assetsOf[_to].push(_assetId);
816         _indexOfAsset[_assetId] = length;
817     }
818 
819     function _clearApproval(address _holder, uint256 _assetId) internal {
820         if (_approval[_assetId] != address(0)) {
821             _approval[_assetId] = address(0);
822             emit Approval(_holder, address(0), _assetId);
823         }
824     }
825 
826     //
827     // Supply-altering functions
828     //
829 
830     function _generate(uint256 _assetId, address _beneficiary) internal {
831         require(_holderOf[_assetId] == address(0), "Asset already exists");
832 
833         _addAssetTo(_beneficiary, _assetId);
834 
835         emit Transfer(address(0), _beneficiary, _assetId);
836     }
837 
838     //
839     // Transaction related operations
840     //
841 
842     modifier onlyAuthorized(uint256 _assetId) {
843         require(_isAuthorized(msg.sender, _assetId), "msg.sender Not authorized");
844         _;
845     }
846 
847     modifier isCurrentOwner(address _from, uint256 _assetId) {
848         require(_ownerOf(_assetId) == _from, "Not current owner");
849         _;
850     }
851 
852     modifier addressDefined(address _target) {
853         require(_target != address(0), "Target can't be 0x0");
854         _;
855     }
856 
857     /**
858      * @dev Alias of `safeTransferFrom(from, to, assetId, '')`
859      *
860      * @param _from address that currently owns an asset
861      * @param _to address to receive the ownership of the asset
862      * @param _assetId uint256 ID of the asset to be transferred
863      */
864     function safeTransferFrom(address _from, address _to, uint256 _assetId) external {
865         return _doTransferFrom(
866             _from,
867             _to,
868             _assetId,
869             "",
870             true
871         );
872     }
873 
874     /**
875      * @dev Securely transfers the ownership of a given asset from one address to
876      * another address, calling the method `onNFTReceived` on the target address if
877      * there's code associated with it
878      *
879      * @param _from address that currently owns an asset
880      * @param _to address to receive the ownership of the asset
881      * @param _assetId uint256 ID of the asset to be transferred
882      * @param _userData bytes arbitrary user information to attach to this transfer
883      */
884     function safeTransferFrom(
885         address _from,
886         address _to,
887         uint256 _assetId,
888         bytes calldata _userData
889     ) external {
890         return _doTransferFrom(
891             _from,
892             _to,
893             _assetId,
894             _userData,
895             true
896         );
897     }
898 
899     /**
900      * @dev Transfers the ownership of a given asset from one address to another address
901      * Warning! This function does not attempt to verify that the target address can send
902      * tokens.
903      *
904      * @param _from address sending the asset
905      * @param _to address to receive the ownership of the asset
906      * @param _assetId uint256 ID of the asset to be transferred
907      */
908     function transferFrom(address _from, address _to, uint256 _assetId) external {
909         return _doTransferFrom(
910             _from,
911             _to,
912             _assetId,
913             "",
914             false
915         );
916     }
917 
918     /**
919      * Internal function that moves an asset from one holder to another
920      */
921     function _doTransferFrom(
922         address _from,
923         address _to,
924         uint256 _assetId,
925         bytes memory _userData,
926         bool _doCheck
927     )
928         internal
929         onlyAuthorized(_assetId)
930         addressDefined(_to)
931         isCurrentOwner(_from, _assetId)
932     {
933         address holder = _holderOf[_assetId];
934         _clearApproval(holder, _assetId);
935         _transferAsset(holder, _to, _assetId);
936 
937         if (_doCheck && _to.isContract()) {
938             // Call dest contract
939             uint256 success;
940             bytes32 result;
941             // Perform check with the new safe call
942             // onERC721Received(address,address,uint256,bytes)
943             (success, result) = _noThrowCall(
944                 _to,
945                 abi.encodeWithSelector(
946                     ERC721_RECEIVED,
947                     msg.sender,
948                     holder,
949                     _assetId,
950                     _userData
951                 )
952             );
953 
954             if (success != 1 || result != ERC721_RECEIVED) {
955                 // Try legacy safe call
956                 // onERC721Received(address,uint256,bytes)
957                 (success, result) = _noThrowCall(
958                     _to,
959                     abi.encodeWithSelector(
960                         ERC721_RECEIVED_LEGACY,
961                         holder,
962                         _assetId,
963                         _userData
964                     )
965                 );
966 
967                 require(
968                     success == 1 && result == ERC721_RECEIVED_LEGACY,
969                     "Contract rejected the token"
970                 );
971             }
972         }
973 
974         emit Transfer(holder, _to, _assetId);
975     }
976 
977     //
978     // Utilities
979     //
980 
981     function _noThrowCall(
982         address _contract,
983         bytes memory _data
984     ) internal returns (uint256 success, bytes32 result) {
985         assembly {
986             let x := mload(0x40)
987 
988             success := call(
989                             gas,                  // Send all gas
990                             _contract,            // To addr
991                             0,                    // Send ETH
992                             add(0x20, _data),     // Input is data past the first 32 bytes
993                             mload(_data),         // Input size is the lenght of data
994                             x,                    // Store the ouput on x
995                             0x20                  // Output is a single bytes32, has 32 bytes
996                         )
997 
998             result := mload(x)
999         }
1000     }
1001 }
1002 
1003 // File: contracts/interfaces/IERC173.sol
1004 
1005 pragma solidity ^0.5.7;
1006 
1007 
1008 /// @title ERC-173 Contract Ownership Standard
1009 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md
1010 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
1011 contract IERC173 {
1012     /// @dev This emits when ownership of a contract changes.
1013     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
1014 
1015     /// @notice Get the address of the owner
1016     /// @return The address of the owner.
1017     //// function owner() external view returns (address);
1018 
1019     /// @notice Set the address of the new owner of the contract
1020     /// @param _newOwner The address of the new owner of the contract
1021     function transferOwnership(address _newOwner) external;
1022 }
1023 
1024 // File: contracts/commons/Ownable.sol
1025 
1026 pragma solidity ^0.5.7;
1027 
1028 
1029 
1030 contract Ownable is IERC173 {
1031     address internal _owner;
1032 
1033     modifier onlyOwner() {
1034         require(msg.sender == _owner, "The owner should be the sender");
1035         _;
1036     }
1037 
1038     constructor() public {
1039         _owner = msg.sender;
1040         emit OwnershipTransferred(address(0x0), msg.sender);
1041     }
1042 
1043     function owner() external view returns (address) {
1044         return _owner;
1045     }
1046 
1047     /**
1048         @dev Transfers the ownership of the contract.
1049 
1050         @param _newOwner Address of the new owner
1051     */
1052     function transferOwnership(address _newOwner) external onlyOwner {
1053         require(_newOwner != address(0), "0x0 Is not a valid owner");
1054         emit OwnershipTransferred(_owner, _newOwner);
1055         _owner = _newOwner;
1056     }
1057 }
1058 
1059 // File: contracts/core/diaspore/DebtEngine.sol
1060 
1061 pragma solidity ^0.5.7;
1062 
1063 
1064 
1065 
1066 
1067 
1068 
1069 
1070 contract DebtEngine is ERC721Base, Ownable {
1071     using IsContract for address;
1072 
1073     event Created(
1074         bytes32 indexed _id,
1075         uint256 _nonce,
1076         bytes _data
1077     );
1078 
1079     event Created2(
1080         bytes32 indexed _id,
1081         uint256 _salt,
1082         bytes _data
1083     );
1084 
1085     event Created3(
1086         bytes32 indexed _id,
1087         uint256 _salt,
1088         bytes _data
1089     );
1090 
1091     event Paid(
1092         bytes32 indexed _id,
1093         address _sender,
1094         address _origin,
1095         uint256 _requested,
1096         uint256 _requestedTokens,
1097         uint256 _paid,
1098         uint256 _tokens
1099     );
1100 
1101     event ReadedOracleBatch(
1102         address _oracle,
1103         uint256 _count,
1104         uint256 _tokens,
1105         uint256 _equivalent
1106     );
1107 
1108     event ReadedOracle(
1109         bytes32 indexed _id,
1110         uint256 _tokens,
1111         uint256 _equivalent
1112     );
1113 
1114     event PayBatchError(
1115         bytes32 indexed _id,
1116         address _targetOracle
1117     );
1118 
1119     event Withdrawn(
1120         bytes32 indexed _id,
1121         address _sender,
1122         address _to,
1123         uint256 _amount
1124     );
1125 
1126     event Error(
1127         bytes32 indexed _id,
1128         address _sender,
1129         uint256 _value,
1130         uint256 _gasLeft,
1131         uint256 _gasLimit,
1132         bytes _callData
1133     );
1134 
1135     event ErrorRecover(
1136         bytes32 indexed _id,
1137         address _sender,
1138         uint256 _value,
1139         uint256 _gasLeft,
1140         uint256 _gasLimit,
1141         bytes32 _result,
1142         bytes _callData
1143     );
1144 
1145     IERC20 public token;
1146 
1147     mapping(bytes32 => Debt) public debts;
1148     mapping(address => uint256) public nonces;
1149 
1150     struct Debt {
1151         bool error;
1152         uint128 balance;
1153         Model model;
1154         address creator;
1155         address oracle;
1156     }
1157 
1158     constructor (
1159         IERC20 _token
1160     ) public ERC721Base("RCN Debt Record", "RDR") {
1161         token = _token;
1162 
1163         // Sanity checks
1164         require(address(_token).isContract(), "Token should be a contract");
1165     }
1166 
1167     function setURIProvider(URIProvider _provider) external onlyOwner {
1168         _setURIProvider(_provider);
1169     }
1170 
1171     function create(
1172         Model _model,
1173         address _owner,
1174         address _oracle,
1175         bytes calldata _data
1176     ) external returns (bytes32 id) {
1177         uint256 nonce = nonces[msg.sender]++;
1178         id = keccak256(
1179             abi.encodePacked(
1180                 uint8(1),
1181                 address(this),
1182                 msg.sender,
1183                 nonce
1184             )
1185         );
1186 
1187         debts[id] = Debt({
1188             error: false,
1189             balance: 0,
1190             creator: msg.sender,
1191             model: _model,
1192             oracle: _oracle
1193         });
1194 
1195         _generate(uint256(id), _owner);
1196         require(_model.create(id, _data), "Error creating debt in model");
1197 
1198         emit Created({
1199             _id: id,
1200             _nonce: nonce,
1201             _data: _data
1202         });
1203     }
1204 
1205     function create2(
1206         Model _model,
1207         address _owner,
1208         address _oracle,
1209         uint256 _salt,
1210         bytes calldata _data
1211     ) external returns (bytes32 id) {
1212         id = keccak256(
1213             abi.encodePacked(
1214                 uint8(2),
1215                 address(this),
1216                 msg.sender,
1217                 _model,
1218                 _oracle,
1219                 _salt,
1220                 _data
1221             )
1222         );
1223 
1224         debts[id] = Debt({
1225             error: false,
1226             balance: 0,
1227             creator: msg.sender,
1228             model: _model,
1229             oracle: _oracle
1230         });
1231 
1232         _generate(uint256(id), _owner);
1233         require(_model.create(id, _data), "Error creating debt in model");
1234 
1235         emit Created2({
1236             _id: id,
1237             _salt: _salt,
1238             _data: _data
1239         });
1240     }
1241 
1242     function create3(
1243         Model _model,
1244         address _owner,
1245         address _oracle,
1246         uint256 _salt,
1247         bytes calldata _data
1248     ) external returns (bytes32 id) {
1249         id = keccak256(
1250             abi.encodePacked(
1251                 uint8(3),
1252                 address(this),
1253                 msg.sender,
1254                 _salt
1255             )
1256         );
1257 
1258         debts[id] = Debt({
1259             error: false,
1260             balance: 0,
1261             creator: msg.sender,
1262             model: _model,
1263             oracle: _oracle
1264         });
1265 
1266         _generate(uint256(id), _owner);
1267         require(_model.create(id, _data), "Error creating debt in model");
1268 
1269         emit Created3({
1270             _id: id,
1271             _salt: _salt,
1272             _data: _data
1273         });
1274     }
1275 
1276     function buildId(
1277         address _creator,
1278         uint256 _nonce
1279     ) external view returns (bytes32) {
1280         return keccak256(
1281             abi.encodePacked(
1282                 uint8(1),
1283                 address(this),
1284                 _creator,
1285                 _nonce
1286             )
1287         );
1288     }
1289 
1290     function buildId2(
1291         address _creator,
1292         address _model,
1293         address _oracle,
1294         uint256 _salt,
1295         bytes calldata _data
1296     ) external view returns (bytes32) {
1297         return keccak256(
1298             abi.encodePacked(
1299                 uint8(2),
1300                 address(this),
1301                 _creator,
1302                 _model,
1303                 _oracle,
1304                 _salt,
1305                 _data
1306             )
1307         );
1308     }
1309 
1310     function buildId3(
1311         address _creator,
1312         uint256 _salt
1313     ) external view returns (bytes32) {
1314         return keccak256(
1315             abi.encodePacked(
1316                 uint8(3),
1317                 address(this),
1318                 _creator,
1319                 _salt
1320             )
1321         );
1322     }
1323 
1324     function pay(
1325         bytes32 _id,
1326         uint256 _amount,
1327         address _origin,
1328         bytes calldata _oracleData
1329     ) external returns (uint256 paid, uint256 paidToken) {
1330         Debt storage debt = debts[_id];
1331         // Paid only required amount
1332         paid = _safePay(_id, debt.model, _amount);
1333         require(paid <= _amount, "Paid can't be more than requested");
1334 
1335         RateOracle oracle = RateOracle(debt.oracle);
1336         if (address(oracle) != address(0)) {
1337             // Convert
1338             (uint256 tokens, uint256 equivalent) = oracle.readSample(_oracleData);
1339             emit ReadedOracle(_id, tokens, equivalent);
1340             paidToken = _toToken(paid, tokens, equivalent);
1341         } else {
1342             paidToken = paid;
1343         }
1344 
1345         // Pull tokens from payer
1346         require(token.transferFrom(msg.sender, address(this), paidToken), "Error pulling payment tokens");
1347 
1348         // Add balance to the debt
1349         uint256 newBalance = paidToken.add(debt.balance);
1350         require(newBalance < 340282366920938463463374607431768211456, "uint128 Overflow");
1351         debt.balance = uint128(newBalance);
1352 
1353         // Emit pay event
1354         emit Paid({
1355             _id: _id,
1356             _sender: msg.sender,
1357             _origin: _origin,
1358             _requested: _amount,
1359             _requestedTokens: 0,
1360             _paid: paid,
1361             _tokens: paidToken
1362         });
1363     }
1364 
1365     function payToken(
1366         bytes32 id,
1367         uint256 amount,
1368         address origin,
1369         bytes calldata oracleData
1370     ) external returns (uint256 paid, uint256 paidToken) {
1371         Debt storage debt = debts[id];
1372         // Read storage
1373         RateOracle oracle = RateOracle(debt.oracle);
1374 
1375         uint256 equivalent;
1376         uint256 tokens;
1377         uint256 available;
1378 
1379         // Get available <currency> amount
1380         if (address(oracle) != address(0)) {
1381             (tokens, equivalent) = oracle.readSample(oracleData);
1382             emit ReadedOracle(id, tokens, equivalent);
1383             available = _fromToken(amount, tokens, equivalent);
1384         } else {
1385             available = amount;
1386         }
1387 
1388         // Call addPaid on model
1389         paid = _safePay(id, debt.model, available);
1390         require(paid <= available, "Paid can't exceed available");
1391 
1392         // Convert back to required pull amount
1393         if (address(oracle) != address(0)) {
1394             paidToken = _toToken(paid, tokens, equivalent);
1395             require(paidToken <= amount, "Paid can't exceed requested");
1396         } else {
1397             paidToken = paid;
1398         }
1399 
1400         // Pull tokens from payer
1401         require(token.transferFrom(msg.sender, address(this), paidToken), "Error pulling tokens");
1402 
1403         // Add balance to the debt
1404         // WARNING: Reusing variable **available**
1405         available = paidToken.add(debt.balance);
1406         require(available < 340282366920938463463374607431768211456, "uint128 Overflow");
1407         debt.balance = uint128(available);
1408 
1409         // Emit pay event
1410         emit Paid({
1411             _id: id,
1412             _sender: msg.sender,
1413             _origin: origin,
1414             _requested: 0,
1415             _requestedTokens: amount,
1416             _paid: paid,
1417             _tokens: paidToken
1418         });
1419     }
1420 
1421     function payBatch(
1422         bytes32[] calldata _ids,
1423         uint256[] calldata _amounts,
1424         address _origin,
1425         address _oracle,
1426         bytes calldata _oracleData
1427     ) external returns (uint256[] memory paid, uint256[] memory paidTokens) {
1428         uint256 count = _ids.length;
1429         require(count == _amounts.length, "_ids and _amounts should have the same length");
1430 
1431         uint256 tokens;
1432         uint256 equivalent;
1433         if (_oracle != address(0)) {
1434             (tokens, equivalent) = RateOracle(_oracle).readSample(_oracleData);
1435             emit ReadedOracleBatch(_oracle, count, tokens, equivalent);
1436         }
1437 
1438         paid = new uint256[](count);
1439         paidTokens = new uint256[](count);
1440         for (uint256 i = 0; i < count; i++) {
1441             uint256 amount = _amounts[i];
1442             (paid[i], paidTokens[i]) = _pay(_ids[i], _oracle, amount, tokens, equivalent);
1443 
1444             emit Paid({
1445                 _id: _ids[i],
1446                 _sender: msg.sender,
1447                 _origin: _origin,
1448                 _requested: amount,
1449                 _requestedTokens: 0,
1450                 _paid: paid[i],
1451                 _tokens: paidTokens[i]
1452             });
1453         }
1454     }
1455 
1456     function payTokenBatch(
1457         bytes32[] calldata _ids,
1458         uint256[] calldata _tokenAmounts,
1459         address _origin,
1460         address _oracle,
1461         bytes calldata _oracleData
1462     ) external returns (uint256[] memory paid, uint256[] memory paidTokens) {
1463         uint256 count = _ids.length;
1464         require(count == _tokenAmounts.length, "_ids and _amounts should have the same length");
1465 
1466         uint256 tokens;
1467         uint256 equivalent;
1468         if (_oracle != address(0)) {
1469             (tokens, equivalent) = RateOracle(_oracle).readSample(_oracleData);
1470             emit ReadedOracleBatch(_oracle, count, tokens, equivalent);
1471         }
1472 
1473         paid = new uint256[](count);
1474         paidTokens = new uint256[](count);
1475         for (uint256 i = 0; i < count; i++) {
1476             uint256 tokenAmount = _tokenAmounts[i];
1477             (paid[i], paidTokens[i]) = _pay(
1478                 _ids[i],
1479                 _oracle,
1480                 _oracle != address(0) ? _fromToken(tokenAmount, tokens, equivalent) : tokenAmount,
1481                 tokens,
1482                 equivalent
1483             );
1484             require(paidTokens[i] <= tokenAmount, "Paid can't exceed requested");
1485 
1486             emit Paid({
1487                 _id: _ids[i],
1488                 _sender: msg.sender,
1489                 _origin: _origin,
1490                 _requested: 0,
1491                 _requestedTokens: tokenAmount,
1492                 _paid: paid[i],
1493                 _tokens: paidTokens[i]
1494             });
1495         }
1496     }
1497 
1498     /**
1499         Internal method to pay a loan, during a payment batch context
1500 
1501         @param _id Pay identifier
1502         @param _oracle Address of the Oracle contract, if the loan does not use any oracle, this field should be 0x0.
1503         @param _amount Amount to pay, in currency
1504         @param _tokens How many tokens
1505         @param _equivalent How much currency _tokens equivales
1506 
1507         @return paid and paidTokens, similar to external pay
1508     */
1509     function _pay(
1510         bytes32 _id,
1511         address _oracle,
1512         uint256 _amount,
1513         uint256 _tokens,
1514         uint256 _equivalent
1515     ) internal returns (uint256 paid, uint256 paidToken){
1516         Debt storage debt = debts[_id];
1517 
1518         if (_oracle != debt.oracle) {
1519             emit PayBatchError(
1520                 _id,
1521                 _oracle
1522             );
1523 
1524             return (0,0);
1525         }
1526 
1527         // Paid only required amount
1528         paid = _safePay(_id, debt.model, _amount);
1529         require(paid <= _amount, "Paid can't be more than requested");
1530 
1531         // Get token amount to use as payment
1532         paidToken = _oracle != address(0) ? _toToken(paid, _tokens, _equivalent) : paid;
1533 
1534         // Pull tokens from payer
1535         require(token.transferFrom(msg.sender, address(this), paidToken), "Error pulling payment tokens");
1536 
1537         // Add balance to debt
1538         uint256 newBalance = paidToken.add(debt.balance);
1539         require(newBalance < 340282366920938463463374607431768211456, "uint128 Overflow");
1540         debt.balance = uint128(newBalance);
1541     }
1542 
1543     function _safePay(
1544         bytes32 _id,
1545         Model _model,
1546         uint256 _available
1547     ) internal returns (uint256) {
1548         require(_model != Model(0), "Debt does not exist");
1549 
1550         (uint256 success, bytes32 paid) = _safeGasCall(
1551             address(_model),
1552             abi.encodeWithSelector(
1553                 _model.addPaid.selector,
1554                 _id,
1555                 _available
1556             )
1557         );
1558 
1559         if (success == 1) {
1560             if (debts[_id].error) {
1561                 emit ErrorRecover({
1562                     _id: _id,
1563                     _sender: msg.sender,
1564                     _value: 0,
1565                     _gasLeft: gasleft(),
1566                     _gasLimit: block.gaslimit,
1567                     _result: paid,
1568                     _callData: msg.data
1569                 });
1570 
1571                 delete debts[_id].error;
1572             }
1573 
1574             return uint256(paid);
1575         } else {
1576             emit Error({
1577                 _id: _id,
1578                 _sender: msg.sender,
1579                 _value: msg.value,
1580                 _gasLeft: gasleft(),
1581                 _gasLimit: block.gaslimit,
1582                 _callData: msg.data
1583             });
1584             debts[_id].error = true;
1585         }
1586     }
1587 
1588     /**
1589         Converts an amount in the rate currency to an amount in token
1590 
1591         @param _amount Amount to convert in rate currency
1592         @param _tokens How many tokens
1593         @param _equivalent How much currency _tokens equivales
1594 
1595         @return Amount in tokens
1596     */
1597     function _toToken(
1598         uint256 _amount,
1599         uint256 _tokens,
1600         uint256 _equivalent
1601     ) internal pure returns (uint256 _result) {
1602         require(_tokens != 0, "Oracle provided invalid rate");
1603         uint256 aux = _tokens.mult(_amount);
1604         _result = aux / _equivalent;
1605         if (aux % _equivalent > 0) {
1606             _result = _result.add(1);
1607         }
1608     }
1609 
1610     /**
1611         Converts an amount in token to the rate currency
1612 
1613         @param _amount Amount to convert in token
1614         @param _tokens How many tokens
1615         @param _equivalent How much currency _tokens equivales
1616 
1617         @return Amount in rate currency
1618     */
1619     function _fromToken(
1620         uint256 _amount,
1621         uint256 _tokens,
1622         uint256 _equivalent
1623     ) internal pure returns (uint256) {
1624         require(_equivalent != 0, "Oracle provided invalid rate");
1625         return _amount.mult(_equivalent) / _tokens;
1626     }
1627 
1628     function run(bytes32 _id) external returns (bool) {
1629         Debt storage debt = debts[_id];
1630         require(debt.model != Model(0), "Debt does not exist");
1631 
1632         (uint256 success, bytes32 result) = _safeGasCall(
1633             address(debt.model),
1634             abi.encodeWithSelector(
1635                 debt.model.run.selector,
1636                 _id
1637             )
1638         );
1639 
1640         if (success == 1) {
1641             if (debt.error) {
1642                 emit ErrorRecover({
1643                     _id: _id,
1644                     _sender: msg.sender,
1645                     _value: 0,
1646                     _gasLeft: gasleft(),
1647                     _gasLimit: block.gaslimit,
1648                     _result: result,
1649                     _callData: msg.data
1650                 });
1651 
1652                 delete debt.error;
1653             }
1654 
1655             return result == bytes32(uint256(1));
1656         } else {
1657             emit Error({
1658                 _id: _id,
1659                 _sender: msg.sender,
1660                 _value: 0,
1661                 _gasLeft: gasleft(),
1662                 _gasLimit: block.gaslimit,
1663                 _callData: msg.data
1664             });
1665             debt.error = true;
1666         }
1667     }
1668 
1669     function withdraw(bytes32 _id, address _to) external returns (uint256 amount) {
1670         require(_to != address(0x0), "_to should not be 0x0");
1671         require(_isAuthorized(msg.sender, uint256(_id)), "Sender not authorized");
1672         Debt storage debt = debts[_id];
1673         amount = debt.balance;
1674         debt.balance = 0;
1675         require(token.transfer(_to, amount), "Error sending tokens");
1676         emit Withdrawn({
1677             _id: _id,
1678             _sender: msg.sender,
1679             _to: _to,
1680             _amount: amount
1681         });
1682     }
1683 
1684     function withdrawPartial(bytes32 _id, address _to, uint256 _amount) external returns (bool success) {
1685         require(_to != address(0x0), "_to should not be 0x0");
1686         require(_isAuthorized(msg.sender, uint256(_id)), "Sender not authorized");
1687         Debt storage debt = debts[_id];
1688         require(debt.balance >= _amount, "Debt balance is not enought");
1689         debt.balance = uint128(uint256(debt.balance).sub(_amount));
1690         require(token.transfer(_to, _amount), "Error sending tokens");
1691         emit Withdrawn({
1692             _id: _id,
1693             _sender: msg.sender,
1694             _to: _to,
1695             _amount: _amount
1696         });
1697         success = true;
1698     }
1699 
1700     function withdrawBatch(bytes32[] calldata _ids, address _to) external returns (uint256 total) {
1701         require(_to != address(0x0), "_to should not be 0x0");
1702         bytes32 target;
1703         uint256 balance;
1704         for (uint256 i = 0; i < _ids.length; i++) {
1705             target = _ids[i];
1706             if (_isAuthorized(msg.sender, uint256(target))) {
1707                 balance = debts[target].balance;
1708                 debts[target].balance = 0;
1709                 total += balance;
1710                 emit Withdrawn({
1711                     _id: target,
1712                     _sender: msg.sender,
1713                     _to: _to,
1714                     _amount: balance
1715                 });
1716             }
1717         }
1718         require(token.transfer(_to, total), "Error sending tokens");
1719     }
1720 
1721     function getStatus(bytes32 _id) external view returns (uint256) {
1722         Debt storage debt = debts[_id];
1723         if (debt.error) {
1724             return 4;
1725         } else {
1726             (uint256 success, bytes32 result) = _safeGasStaticCall(
1727                 address(debt.model),
1728                 abi.encodeWithSelector(
1729                     debt.model.getStatus.selector,
1730                     _id
1731                 )
1732             );
1733             return success == 1 ? uint256(result) : 4;
1734         }
1735     }
1736 
1737     function _safeGasStaticCall(
1738         address _contract,
1739         bytes memory _data
1740     ) internal view returns (uint256 success, bytes32 result) {
1741         uint256 _gas = (block.gaslimit * 80) / 100;
1742         _gas = gasleft() < _gas ? gasleft() : _gas;
1743         assembly {
1744             let x := mload(0x40)
1745             success := staticcall(
1746                             _gas,                 // Send almost all gas
1747                             _contract,            // To addr
1748                             add(0x20, _data),     // Input is data past the first 32 bytes
1749                             mload(_data),         // Input size is the lenght of data
1750                             x,                    // Store the ouput on x
1751                             0x20                  // Output is a single bytes32, has 32 bytes
1752                         )
1753 
1754             result := mload(x)
1755         }
1756     }
1757 
1758     function _safeGasCall(
1759         address _contract,
1760         bytes memory _data
1761     ) internal returns (uint256 success, bytes32 result) {
1762         uint256 _gas = (block.gaslimit * 80) / 100;
1763         _gas = gasleft() < _gas ? gasleft() : _gas;
1764         assembly {
1765             let x := mload(0x40)
1766             success := call(
1767                             _gas,                 // Send almost all gas
1768                             _contract,            // To addr
1769                             0,                    // Send ETH
1770                             add(0x20, _data),     // Input is data past the first 32 bytes
1771                             mload(_data),         // Input size is the lenght of data
1772                             x,                    // Store the ouput on x
1773                             0x20                  // Output is a single bytes32, has 32 bytes
1774                         )
1775 
1776             result := mload(x)
1777         }
1778     }
1779 }