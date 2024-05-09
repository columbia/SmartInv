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
448         uint256 z = x * y;
449         require((x == 0)||(z/x == y), "Mult overflow");
450         return z;
451     }
452 }
453 
454 // File: contracts/commons/ERC165.sol
455 
456 pragma solidity ^0.5.7;
457 
458 
459 
460 /**
461  * @title ERC165
462  * @author Matt Condon (@shrugs)
463  * @dev Implements ERC165 using a lookup table.
464  */
465 contract ERC165 is IERC165 {
466     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
467     /**
468     * 0x01ffc9a7 ===
469     *   bytes4(keccak256('supportsInterface(bytes4)'))
470     */
471 
472     /**
473     * @dev a mapping of interface id to whether or not it's supported
474     */
475     mapping(bytes4 => bool) private _supportedInterfaces;
476 
477     /**
478     * @dev A contract implementing SupportsInterfaceWithLookup
479     * implement ERC165 itself
480     */
481     constructor()
482         internal
483     {
484         _registerInterface(_InterfaceId_ERC165);
485     }
486 
487     /**
488     * @dev implement supportsInterface(bytes4) using a lookup table
489     */
490     function supportsInterface(bytes4 interfaceId)
491         external
492         view
493         returns (bool)
494     {
495         return _supportedInterfaces[interfaceId];
496     }
497 
498     /**
499     * @dev internal method for registering an interface
500     */
501     function _registerInterface(bytes4 interfaceId)
502         internal
503     {
504         require(interfaceId != 0xffffffff, "Can't register 0xffffffff");
505         _supportedInterfaces[interfaceId] = true;
506     }
507 }
508 
509 // File: contracts/commons/ERC721Base.sol
510 
511 pragma solidity ^0.5.7;
512 
513 
514 
515 
516 
517 interface URIProvider {
518     function tokenURI(uint256 _tokenId) external view returns (string memory);
519 }
520 
521 
522 contract ERC721Base is ERC165 {
523     using SafeMath for uint256;
524     using IsContract for address;
525 
526     mapping(uint256 => address) private _holderOf;
527 
528     // Owner to array of assetId
529     mapping(address => uint256[]) private _assetsOf;
530     // AssetId to index on array in _assetsOf mapping
531     mapping(uint256 => uint256) private _indexOfAsset;
532 
533     mapping(address => mapping(address => bool)) private _operators;
534     mapping(uint256 => address) private _approval;
535 
536     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
537     bytes4 private constant ERC721_RECEIVED_LEGACY = 0xf0b9e5ba;
538 
539     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
540     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
541     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
542 
543     bytes4 private constant ERC_721_INTERFACE = 0x80ac58cd;
544     bytes4 private constant ERC_721_METADATA_INTERFACE = 0x5b5e139f;
545     bytes4 private constant ERC_721_ENUMERATION_INTERFACE = 0x780e9d63;
546 
547     constructor(
548         string memory name,
549         string memory symbol
550     ) public {
551         _name = name;
552         _symbol = symbol;
553 
554         _registerInterface(ERC_721_INTERFACE);
555         _registerInterface(ERC_721_METADATA_INTERFACE);
556         _registerInterface(ERC_721_ENUMERATION_INTERFACE);
557     }
558 
559     // ///
560     // ERC721 Metadata
561     // ///
562 
563     /// ERC-721 Non-Fungible Token Standard, optional metadata extension
564     /// See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
565     /// Note: the ERC-165 identifier for this interface is 0x5b5e139f.
566 
567     event SetURIProvider(address _uriProvider);
568 
569     string private _name;
570     string private _symbol;
571 
572     URIProvider private _uriProvider;
573 
574     // @notice A descriptive name for a collection of NFTs in this contract
575     function name() external view returns (string memory) {
576         return _name;
577     }
578 
579     // @notice An abbreviated name for NFTs in this contract
580     function symbol() external view returns (string memory) {
581         return _symbol;
582     }
583 
584     /**
585     * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
586     * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
587     *  3986. The URI may point to a JSON file that conforms to the "ERC721
588     *  Metadata JSON Schema".
589     */
590     function tokenURI(uint256 _tokenId) external view returns (string memory) {
591         require(_holderOf[_tokenId] != address(0), "Asset does not exist");
592         URIProvider provider = _uriProvider;
593         return address(provider) == address(0) ? "" : provider.tokenURI(_tokenId);
594     }
595 
596     function _setURIProvider(URIProvider _provider) internal returns (bool) {
597         emit SetURIProvider(address(_provider));
598         _uriProvider = _provider;
599         return true;
600     }
601 
602     // ///
603     // ERC721 Enumeration
604     // ///
605 
606     ///  ERC-721 Non-Fungible Token Standard, optional enumeration extension
607     ///  See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
608     ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
609 
610     uint256[] private _allTokens;
611 
612     function allTokens() external view returns (uint256[] memory) {
613         return _allTokens;
614     }
615 
616     function assetsOf(address _owner) external view returns (uint256[] memory) {
617         return _assetsOf[_owner];
618     }
619 
620     /**
621      * @dev Gets the total amount of assets stored by the contract
622      * @return uint256 representing the total amount of assets
623      */
624     function totalSupply() external view returns (uint256) {
625         return _allTokens.length;
626     }
627 
628     /**
629     * @notice Enumerate valid NFTs
630     * @dev Throws if `_index` >= `totalSupply()`.
631     * @param _index A counter less than `totalSupply()`
632     * @return The token identifier for the `_index` of the NFT,
633     *  (sort order not specified)
634     */
635     function tokenByIndex(uint256 _index) external view returns (uint256) {
636         require(_index < _allTokens.length, "Index out of bounds");
637         return _allTokens[_index];
638     }
639 
640     /**
641     * @notice Enumerate NFTs assigned to an owner
642     * @dev Throws if `_index` >= `balanceOf(_owner)` or if
643     *  `_owner` is the zero address, representing invalid NFTs.
644     * @param _owner An address where we are interested in NFTs owned by them
645     * @param _index A counter less than `balanceOf(_owner)`
646     * @return The token identifier for the `_index` of the NFT assigned to `_owner`,
647     *   (sort order not specified)
648     */
649     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
650         require(_owner != address(0), "0x0 Is not a valid owner");
651         require(_index < _balanceOf(_owner), "Index out of bounds");
652         return _assetsOf[_owner][_index];
653     }
654 
655     //
656     // Asset-centric getter functions
657     //
658 
659     /**
660      * @dev Queries what address owns an asset. This method does not throw.
661      * In order to check if the asset exists, use the `exists` function or check if the
662      * return value of this call is `0`.
663      * @return uint256 the assetId
664      */
665     function ownerOf(uint256 _assetId) external view returns (address) {
666         return _ownerOf(_assetId);
667     }
668 
669     function _ownerOf(uint256 _assetId) internal view returns (address) {
670         return _holderOf[_assetId];
671     }
672 
673     //
674     // Holder-centric getter functions
675     //
676     /**
677      * @dev Gets the balance of the specified address
678      * @param _owner address to query the balance of
679      * @return uint256 representing the amount owned by the passed address
680      */
681     function balanceOf(address _owner) external view returns (uint256) {
682         return _balanceOf(_owner);
683     }
684 
685     function _balanceOf(address _owner) internal view returns (uint256) {
686         return _assetsOf[_owner].length;
687     }
688 
689     //
690     // Authorization getters
691     //
692 
693     /**
694      * @dev Query whether an address has been authorized to move any assets on behalf of someone else
695      * @param _operator the address that might be authorized
696      * @param _assetHolder the address that provided the authorization
697      * @return bool true if the operator has been authorized to move any assets
698      */
699     function isApprovedForAll(
700         address _operator,
701         address _assetHolder
702     ) external view returns (bool) {
703         return _isApprovedForAll(_operator, _assetHolder);
704     }
705 
706     function _isApprovedForAll(
707         address _operator,
708         address _assetHolder
709     ) internal view returns (bool) {
710         return _operators[_assetHolder][_operator];
711     }
712 
713     /**
714      * @dev Query what address has been particularly authorized to move an asset
715      * @param _assetId the asset to be queried for
716      * @return bool true if the asset has been approved by the holder
717      */
718     function getApproved(uint256 _assetId) external view returns (address) {
719         return _getApproved(_assetId);
720     }
721 
722     function _getApproved(uint256 _assetId) internal view returns (address) {
723         return _approval[_assetId];
724     }
725 
726     /**
727      * @dev Query if an operator can move an asset.
728      * @param _operator the address that might be authorized
729      * @param _assetId the asset that has been `approved` for transfer
730      * @return bool true if the asset has been approved by the holder
731      */
732     function isAuthorized(address _operator, uint256 _assetId) external view returns (bool) {
733         return _isAuthorized(_operator, _assetId);
734     }
735 
736     function _isAuthorized(address _operator, uint256 _assetId) internal view returns (bool) {
737         require(_operator != address(0), "0x0 is an invalid operator");
738         address owner = _ownerOf(_assetId);
739 
740         return _operator == owner || _isApprovedForAll(_operator, owner) || _getApproved(_assetId) == _operator;
741     }
742 
743     //
744     // Authorization
745     //
746 
747     /**
748      * @dev Authorize a third party operator to manage (send) msg.sender's asset
749      * @param _operator address to be approved
750      * @param _authorized bool set to true to authorize, false to withdraw authorization
751      */
752     function setApprovalForAll(address _operator, bool _authorized) external {
753         if (_operators[msg.sender][_operator] != _authorized) {
754             _operators[msg.sender][_operator] = _authorized;
755             emit ApprovalForAll(msg.sender, _operator, _authorized);
756         }
757     }
758 
759     /**
760      * @dev Authorize a third party operator to manage one particular asset
761      * @param _operator address to be approved
762      * @param _assetId asset to approve
763      */
764     function approve(address _operator, uint256 _assetId) external {
765         address holder = _ownerOf(_assetId);
766         require(msg.sender == holder || _isApprovedForAll(msg.sender, holder), "msg.sender can't approve");
767         if (_getApproved(_assetId) != _operator) {
768             _approval[_assetId] = _operator;
769             emit Approval(holder, _operator, _assetId);
770         }
771     }
772 
773     //
774     // Internal Operations
775     //
776 
777     function _addAssetTo(address _to, uint256 _assetId) internal {
778         // Store asset owner
779         _holderOf[_assetId] = _to;
780 
781         // Store index of the asset
782         uint256 length = _balanceOf(_to);
783         _assetsOf[_to].push(_assetId);
784         _indexOfAsset[_assetId] = length;
785 
786         // Save main enumerable
787         _allTokens.push(_assetId);
788     }
789 
790     function _transferAsset(address _from, address _to, uint256 _assetId) internal {
791         uint256 assetIndex = _indexOfAsset[_assetId];
792         uint256 lastAssetIndex = _balanceOf(_from).sub(1);
793 
794         if (assetIndex != lastAssetIndex) {
795             // Replace current asset with last asset
796             uint256 lastAssetId = _assetsOf[_from][lastAssetIndex];
797             // Insert the last asset into the position previously occupied by the asset to be removed
798             _assetsOf[_from][assetIndex] = lastAssetId;
799             _indexOfAsset[lastAssetId] = assetIndex;
800         }
801 
802         // Resize the array
803         _assetsOf[_from][lastAssetIndex] = 0;
804         _assetsOf[_from].length--;
805 
806         // Change owner
807         _holderOf[_assetId] = _to;
808 
809         // Update the index of positions of the asset
810         uint256 length = _balanceOf(_to);
811         _assetsOf[_to].push(_assetId);
812         _indexOfAsset[_assetId] = length;
813     }
814 
815     function _clearApproval(address _holder, uint256 _assetId) internal {
816         if (_approval[_assetId] != address(0)) {
817             _approval[_assetId] = address(0);
818             emit Approval(_holder, address(0), _assetId);
819         }
820     }
821 
822     //
823     // Supply-altering functions
824     //
825 
826     function _generate(uint256 _assetId, address _beneficiary) internal {
827         require(_holderOf[_assetId] == address(0), "Asset already exists");
828 
829         _addAssetTo(_beneficiary, _assetId);
830 
831         emit Transfer(address(0), _beneficiary, _assetId);
832     }
833 
834     //
835     // Transaction related operations
836     //
837 
838     modifier onlyAuthorized(uint256 _assetId) {
839         require(_isAuthorized(msg.sender, _assetId), "msg.sender Not authorized");
840         _;
841     }
842 
843     modifier isCurrentOwner(address _from, uint256 _assetId) {
844         require(_ownerOf(_assetId) == _from, "Not current owner");
845         _;
846     }
847 
848     modifier addressDefined(address _target) {
849         require(_target != address(0), "Target can't be 0x0");
850         _;
851     }
852 
853     /**
854      * @dev Alias of `safeTransferFrom(from, to, assetId, '')`
855      *
856      * @param _from address that currently owns an asset
857      * @param _to address to receive the ownership of the asset
858      * @param _assetId uint256 ID of the asset to be transferred
859      */
860     function safeTransferFrom(address _from, address _to, uint256 _assetId) external {
861         return _doTransferFrom(
862             _from,
863             _to,
864             _assetId,
865             "",
866             true
867         );
868     }
869 
870     /**
871      * @dev Securely transfers the ownership of a given asset from one address to
872      * another address, calling the method `onNFTReceived` on the target address if
873      * there's code associated with it
874      *
875      * @param _from address that currently owns an asset
876      * @param _to address to receive the ownership of the asset
877      * @param _assetId uint256 ID of the asset to be transferred
878      * @param _userData bytes arbitrary user information to attach to this transfer
879      */
880     function safeTransferFrom(
881         address _from,
882         address _to,
883         uint256 _assetId,
884         bytes calldata _userData
885     ) external {
886         return _doTransferFrom(
887             _from,
888             _to,
889             _assetId,
890             _userData,
891             true
892         );
893     }
894 
895     /**
896      * @dev Transfers the ownership of a given asset from one address to another address
897      * Warning! This function does not attempt to verify that the target address can send
898      * tokens.
899      *
900      * @param _from address sending the asset
901      * @param _to address to receive the ownership of the asset
902      * @param _assetId uint256 ID of the asset to be transferred
903      */
904     function transferFrom(address _from, address _to, uint256 _assetId) external {
905         return _doTransferFrom(
906             _from,
907             _to,
908             _assetId,
909             "",
910             false
911         );
912     }
913 
914     /**
915      * Internal function that moves an asset from one holder to another
916      */
917     function _doTransferFrom(
918         address _from,
919         address _to,
920         uint256 _assetId,
921         bytes memory _userData,
922         bool _doCheck
923     )
924         internal
925         onlyAuthorized(_assetId)
926         addressDefined(_to)
927         isCurrentOwner(_from, _assetId)
928     {
929         address holder = _holderOf[_assetId];
930         _clearApproval(holder, _assetId);
931         _transferAsset(holder, _to, _assetId);
932 
933         if (_doCheck && _to.isContract()) {
934             // Call dest contract
935             uint256 success;
936             bytes32 result;
937             // Perform check with the new safe call
938             // onERC721Received(address,address,uint256,bytes)
939             (success, result) = _noThrowCall(
940                 _to,
941                 abi.encodeWithSelector(
942                     ERC721_RECEIVED,
943                     msg.sender,
944                     holder,
945                     _assetId,
946                     _userData
947                 )
948             );
949 
950             if (success != 1 || result != ERC721_RECEIVED) {
951                 // Try legacy safe call
952                 // onERC721Received(address,uint256,bytes)
953                 (success, result) = _noThrowCall(
954                     _to,
955                     abi.encodeWithSelector(
956                         ERC721_RECEIVED_LEGACY,
957                         holder,
958                         _assetId,
959                         _userData
960                     )
961                 );
962 
963                 require(
964                     success == 1 && result == ERC721_RECEIVED_LEGACY,
965                     "Contract rejected the token"
966                 );
967             }
968         }
969 
970         emit Transfer(holder, _to, _assetId);
971     }
972 
973     //
974     // Utilities
975     //
976 
977     function _noThrowCall(
978         address _contract,
979         bytes memory _data
980     ) internal returns (uint256 success, bytes32 result) {
981         assembly {
982             let x := mload(0x40)
983 
984             success := call(
985                             gas,                  // Send all gas
986                             _contract,            // To addr
987                             0,                    // Send ETH
988                             add(0x20, _data),     // Input is data past the first 32 bytes
989                             mload(_data),         // Input size is the lenght of data
990                             x,                    // Store the ouput on x
991                             0x20                  // Output is a single bytes32, has 32 bytes
992                         )
993 
994             result := mload(x)
995         }
996     }
997 }
998 
999 // File: contracts/interfaces/IERC173.sol
1000 
1001 pragma solidity ^0.5.7;
1002 
1003 
1004 /// @title ERC-173 Contract Ownership Standard
1005 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md
1006 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
1007 contract IERC173 {
1008     /// @dev This emits when ownership of a contract changes.
1009     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
1010 
1011     /// @notice Get the address of the owner
1012     /// @return The address of the owner.
1013     //// function owner() external view returns (address);
1014 
1015     /// @notice Set the address of the new owner of the contract
1016     /// @param _newOwner The address of the new owner of the contract
1017     function transferOwnership(address _newOwner) external;
1018 }
1019 
1020 // File: contracts/commons/Ownable.sol
1021 
1022 pragma solidity ^0.5.7;
1023 
1024 
1025 
1026 contract Ownable is IERC173 {
1027     address internal _owner;
1028 
1029     modifier onlyOwner() {
1030         require(msg.sender == _owner, "The owner should be the sender");
1031         _;
1032     }
1033 
1034     constructor() public {
1035         _owner = msg.sender;
1036         emit OwnershipTransferred(address(0x0), msg.sender);
1037     }
1038 
1039     function owner() external view returns (address) {
1040         return _owner;
1041     }
1042 
1043     /**
1044         @dev Transfers the ownership of the contract.
1045 
1046         @param _newOwner Address of the new owner
1047     */
1048     function transferOwnership(address _newOwner) external onlyOwner {
1049         require(_newOwner != address(0), "0x0 Is not a valid owner");
1050         emit OwnershipTransferred(_owner, _newOwner);
1051         _owner = _newOwner;
1052     }
1053 }
1054 
1055 // File: contracts/core/diaspore/DebtEngine.sol
1056 
1057 pragma solidity ^0.5.7;
1058 
1059 
1060 
1061 
1062 
1063 
1064 
1065 
1066 contract DebtEngine is ERC721Base, Ownable {
1067     using IsContract for address;
1068 
1069     event Created(
1070         bytes32 indexed _id,
1071         uint256 _nonce,
1072         bytes _data
1073     );
1074 
1075     event Created2(
1076         bytes32 indexed _id,
1077         uint256 _salt,
1078         bytes _data
1079     );
1080 
1081     event Created3(
1082         bytes32 indexed _id,
1083         uint256 _salt,
1084         bytes _data
1085     );
1086 
1087     event Paid(
1088         bytes32 indexed _id,
1089         address _sender,
1090         address _origin,
1091         uint256 _requested,
1092         uint256 _requestedTokens,
1093         uint256 _paid,
1094         uint256 _tokens
1095     );
1096 
1097     event ReadedOracleBatch(
1098         address _oracle,
1099         uint256 _count,
1100         uint256 _tokens,
1101         uint256 _equivalent
1102     );
1103 
1104     event ReadedOracle(
1105         bytes32 indexed _id,
1106         uint256 _tokens,
1107         uint256 _equivalent
1108     );
1109 
1110     event PayBatchError(
1111         bytes32 indexed _id,
1112         address _targetOracle
1113     );
1114 
1115     event Withdrawn(
1116         bytes32 indexed _id,
1117         address _sender,
1118         address _to,
1119         uint256 _amount
1120     );
1121 
1122     event Error(
1123         bytes32 indexed _id,
1124         address _sender,
1125         uint256 _value,
1126         uint256 _gasLeft,
1127         uint256 _gasLimit,
1128         bytes _callData
1129     );
1130 
1131     event ErrorRecover(
1132         bytes32 indexed _id,
1133         address _sender,
1134         uint256 _value,
1135         uint256 _gasLeft,
1136         uint256 _gasLimit,
1137         bytes32 _result,
1138         bytes _callData
1139     );
1140 
1141     IERC20 public token;
1142 
1143     mapping(bytes32 => Debt) public debts;
1144     mapping(address => uint256) public nonces;
1145 
1146     struct Debt {
1147         bool error;
1148         uint128 balance;
1149         Model model;
1150         address creator;
1151         address oracle;
1152     }
1153 
1154     constructor (
1155         IERC20 _token
1156     ) public ERC721Base("RCN Debt Record", "RDR") {
1157         token = _token;
1158 
1159         // Sanity checks
1160         require(address(_token).isContract(), "Token should be a contract");
1161     }
1162 
1163     function setURIProvider(URIProvider _provider) external onlyOwner {
1164         _setURIProvider(_provider);
1165     }
1166 
1167     function create(
1168         Model _model,
1169         address _owner,
1170         address _oracle,
1171         bytes calldata _data
1172     ) external returns (bytes32 id) {
1173         uint256 nonce = nonces[msg.sender]++;
1174         id = keccak256(
1175             abi.encodePacked(
1176                 uint8(1),
1177                 address(this),
1178                 msg.sender,
1179                 nonce
1180             )
1181         );
1182 
1183         debts[id] = Debt({
1184             error: false,
1185             balance: 0,
1186             creator: msg.sender,
1187             model: _model,
1188             oracle: _oracle
1189         });
1190 
1191         _generate(uint256(id), _owner);
1192         require(_model.create(id, _data), "Error creating debt in model");
1193 
1194         emit Created({
1195             _id: id,
1196             _nonce: nonce,
1197             _data: _data
1198         });
1199     }
1200 
1201     function create2(
1202         Model _model,
1203         address _owner,
1204         address _oracle,
1205         uint256 _salt,
1206         bytes calldata _data
1207     ) external returns (bytes32 id) {
1208         id = keccak256(
1209             abi.encodePacked(
1210                 uint8(2),
1211                 address(this),
1212                 msg.sender,
1213                 _model,
1214                 _oracle,
1215                 _salt,
1216                 _data
1217             )
1218         );
1219 
1220         debts[id] = Debt({
1221             error: false,
1222             balance: 0,
1223             creator: msg.sender,
1224             model: _model,
1225             oracle: _oracle
1226         });
1227 
1228         _generate(uint256(id), _owner);
1229         require(_model.create(id, _data), "Error creating debt in model");
1230 
1231         emit Created2({
1232             _id: id,
1233             _salt: _salt,
1234             _data: _data
1235         });
1236     }
1237 
1238     function create3(
1239         Model _model,
1240         address _owner,
1241         address _oracle,
1242         uint256 _salt,
1243         bytes calldata _data
1244     ) external returns (bytes32 id) {
1245         id = keccak256(
1246             abi.encodePacked(
1247                 uint8(3),
1248                 address(this),
1249                 msg.sender,
1250                 _salt
1251             )
1252         );
1253 
1254         debts[id] = Debt({
1255             error: false,
1256             balance: 0,
1257             creator: msg.sender,
1258             model: _model,
1259             oracle: _oracle
1260         });
1261 
1262         _generate(uint256(id), _owner);
1263         require(_model.create(id, _data), "Error creating debt in model");
1264 
1265         emit Created3({
1266             _id: id,
1267             _salt: _salt,
1268             _data: _data
1269         });
1270     }
1271 
1272     function buildId(
1273         address _creator,
1274         uint256 _nonce
1275     ) external view returns (bytes32) {
1276         return keccak256(
1277             abi.encodePacked(
1278                 uint8(1),
1279                 address(this),
1280                 _creator,
1281                 _nonce
1282             )
1283         );
1284     }
1285 
1286     function buildId2(
1287         address _creator,
1288         address _model,
1289         address _oracle,
1290         uint256 _salt,
1291         bytes calldata _data
1292     ) external view returns (bytes32) {
1293         return keccak256(
1294             abi.encodePacked(
1295                 uint8(2),
1296                 address(this),
1297                 _creator,
1298                 _model,
1299                 _oracle,
1300                 _salt,
1301                 _data
1302             )
1303         );
1304     }
1305 
1306     function buildId3(
1307         address _creator,
1308         uint256 _salt
1309     ) external view returns (bytes32) {
1310         return keccak256(
1311             abi.encodePacked(
1312                 uint8(3),
1313                 address(this),
1314                 _creator,
1315                 _salt
1316             )
1317         );
1318     }
1319 
1320     function pay(
1321         bytes32 _id,
1322         uint256 _amount,
1323         address _origin,
1324         bytes calldata _oracleData
1325     ) external returns (uint256 paid, uint256 paidToken) {
1326         Debt storage debt = debts[_id];
1327         // Paid only required amount
1328         paid = _safePay(_id, debt.model, _amount);
1329         require(paid <= _amount, "Paid can't be more than requested");
1330 
1331         RateOracle oracle = RateOracle(debt.oracle);
1332         if (address(oracle) != address(0)) {
1333             // Convert
1334             (uint256 tokens, uint256 equivalent) = oracle.readSample(_oracleData);
1335             emit ReadedOracle(_id, tokens, equivalent);
1336             paidToken = _toToken(paid, tokens, equivalent);
1337         } else {
1338             paidToken = paid;
1339         }
1340 
1341         // Pull tokens from payer
1342         require(token.transferFrom(msg.sender, address(this), paidToken), "Error pulling payment tokens");
1343 
1344         // Add balance to the debt
1345         uint256 newBalance = paidToken.add(debt.balance);
1346         require(newBalance < 340282366920938463463374607431768211456, "uint128 Overflow");
1347         debt.balance = uint128(newBalance);
1348 
1349         // Emit pay event
1350         emit Paid({
1351             _id: _id,
1352             _sender: msg.sender,
1353             _origin: _origin,
1354             _requested: _amount,
1355             _requestedTokens: 0,
1356             _paid: paid,
1357             _tokens: paidToken
1358         });
1359     }
1360 
1361     function payToken(
1362         bytes32 id,
1363         uint256 amount,
1364         address origin,
1365         bytes calldata oracleData
1366     ) external returns (uint256 paid, uint256 paidToken) {
1367         Debt storage debt = debts[id];
1368         // Read storage
1369         RateOracle oracle = RateOracle(debt.oracle);
1370 
1371         uint256 equivalent;
1372         uint256 tokens;
1373         uint256 available;
1374 
1375         // Get available <currency> amount
1376         if (address(oracle) != address(0)) {
1377             (tokens, equivalent) = oracle.readSample(oracleData);
1378             emit ReadedOracle(id, tokens, equivalent);
1379             available = _fromToken(amount, tokens, equivalent);
1380         } else {
1381             available = amount;
1382         }
1383 
1384         // Call addPaid on model
1385         paid = _safePay(id, debt.model, available);
1386         require(paid <= available, "Paid can't exceed available");
1387 
1388         // Convert back to required pull amount
1389         if (address(oracle) != address(0)) {
1390             paidToken = _toToken(paid, tokens, equivalent);
1391             require(paidToken <= amount, "Paid can't exceed requested");
1392         } else {
1393             paidToken = paid;
1394         }
1395 
1396         // Pull tokens from payer
1397         require(token.transferFrom(msg.sender, address(this), paidToken), "Error pulling tokens");
1398 
1399         // Add balance to the debt
1400         // WARNING: Reusing variable **available**
1401         available = paidToken.add(debt.balance);
1402         require(available < 340282366920938463463374607431768211456, "uint128 Overflow");
1403         debt.balance = uint128(available);
1404 
1405         // Emit pay event
1406         emit Paid({
1407             _id: id,
1408             _sender: msg.sender,
1409             _origin: origin,
1410             _requested: 0,
1411             _requestedTokens: amount,
1412             _paid: paid,
1413             _tokens: paidToken
1414         });
1415     }
1416 
1417     function payBatch(
1418         bytes32[] calldata _ids,
1419         uint256[] calldata _amounts,
1420         address _origin,
1421         address _oracle,
1422         bytes calldata _oracleData
1423     ) external returns (uint256[] memory paid, uint256[] memory paidTokens) {
1424         uint256 count = _ids.length;
1425         require(count == _amounts.length, "_ids and _amounts should have the same length");
1426 
1427         uint256 tokens;
1428         uint256 equivalent;
1429         if (_oracle != address(0)) {
1430             (tokens, equivalent) = RateOracle(_oracle).readSample(_oracleData);
1431             emit ReadedOracleBatch(_oracle, count, tokens, equivalent);
1432         }
1433 
1434         paid = new uint256[](count);
1435         paidTokens = new uint256[](count);
1436         for (uint256 i = 0; i < count; i++) {
1437             uint256 amount = _amounts[i];
1438             (paid[i], paidTokens[i]) = _pay(_ids[i], _oracle, amount, tokens, equivalent);
1439 
1440             emit Paid({
1441                 _id: _ids[i],
1442                 _sender: msg.sender,
1443                 _origin: _origin,
1444                 _requested: amount,
1445                 _requestedTokens: 0,
1446                 _paid: paid[i],
1447                 _tokens: paidTokens[i]
1448             });
1449         }
1450     }
1451 
1452     function payTokenBatch(
1453         bytes32[] calldata _ids,
1454         uint256[] calldata _tokenAmounts,
1455         address _origin,
1456         address _oracle,
1457         bytes calldata _oracleData
1458     ) external returns (uint256[] memory paid, uint256[] memory paidTokens) {
1459         uint256 count = _ids.length;
1460         require(count == _tokenAmounts.length, "_ids and _amounts should have the same length");
1461 
1462         uint256 tokens;
1463         uint256 equivalent;
1464         if (_oracle != address(0)) {
1465             (tokens, equivalent) = RateOracle(_oracle).readSample(_oracleData);
1466             emit ReadedOracleBatch(_oracle, count, tokens, equivalent);
1467         }
1468 
1469         paid = new uint256[](count);
1470         paidTokens = new uint256[](count);
1471         for (uint256 i = 0; i < count; i++) {
1472             uint256 tokenAmount = _tokenAmounts[i];
1473             (paid[i], paidTokens[i]) = _pay(
1474                 _ids[i],
1475                 _oracle,
1476                 _oracle != address(0) ? _fromToken(tokenAmount, tokens, equivalent) : tokenAmount,
1477                 tokens,
1478                 equivalent
1479             );
1480             require(paidTokens[i] <= tokenAmount, "Paid can't exceed requested");
1481 
1482             emit Paid({
1483                 _id: _ids[i],
1484                 _sender: msg.sender,
1485                 _origin: _origin,
1486                 _requested: 0,
1487                 _requestedTokens: tokenAmount,
1488                 _paid: paid[i],
1489                 _tokens: paidTokens[i]
1490             });
1491         }
1492     }
1493 
1494     /**
1495         Internal method to pay a loan, during a payment batch context
1496 
1497         @param _id Pay identifier
1498         @param _oracle Address of the Oracle contract, if the loan does not use any oracle, this field should be 0x0.
1499         @param _amount Amount to pay, in currency
1500         @param _tokens How many tokens
1501         @param _equivalent How much currency _tokens equivales
1502 
1503         @return paid and paidTokens, similar to external pay
1504     */
1505     function _pay(
1506         bytes32 _id,
1507         address _oracle,
1508         uint256 _amount,
1509         uint256 _tokens,
1510         uint256 _equivalent
1511     ) internal returns (uint256 paid, uint256 paidToken){
1512         Debt storage debt = debts[_id];
1513 
1514         if (_oracle != debt.oracle) {
1515             emit PayBatchError(
1516                 _id,
1517                 _oracle
1518             );
1519 
1520             return (0,0);
1521         }
1522 
1523         // Paid only required amount
1524         paid = _safePay(_id, debt.model, _amount);
1525         require(paid <= _amount, "Paid can't be more than requested");
1526 
1527         // Get token amount to use as payment
1528         paidToken = _oracle != address(0) ? _toToken(paid, _tokens, _equivalent) : paid;
1529 
1530         // Pull tokens from payer
1531         require(token.transferFrom(msg.sender, address(this), paidToken), "Error pulling payment tokens");
1532 
1533         // Add balance to debt
1534         uint256 newBalance = paidToken.add(debt.balance);
1535         require(newBalance < 340282366920938463463374607431768211456, "uint128 Overflow");
1536         debt.balance = uint128(newBalance);
1537     }
1538 
1539     function _safePay(
1540         bytes32 _id,
1541         Model _model,
1542         uint256 _available
1543     ) internal returns (uint256) {
1544         require(_model != Model(0), "Debt does not exist");
1545 
1546         (uint256 success, bytes32 paid) = _safeGasCall(
1547             address(_model),
1548             abi.encodeWithSelector(
1549                 _model.addPaid.selector,
1550                 _id,
1551                 _available
1552             )
1553         );
1554 
1555         if (success == 1) {
1556             if (debts[_id].error) {
1557                 emit ErrorRecover({
1558                     _id: _id,
1559                     _sender: msg.sender,
1560                     _value: 0,
1561                     _gasLeft: gasleft(),
1562                     _gasLimit: block.gaslimit,
1563                     _result: paid,
1564                     _callData: msg.data
1565                 });
1566 
1567                 delete debts[_id].error;
1568             }
1569 
1570             return uint256(paid);
1571         } else {
1572             emit Error({
1573                 _id: _id,
1574                 _sender: msg.sender,
1575                 _value: msg.value,
1576                 _gasLeft: gasleft(),
1577                 _gasLimit: block.gaslimit,
1578                 _callData: msg.data
1579             });
1580             debts[_id].error = true;
1581         }
1582     }
1583 
1584     /**
1585         Converts an amount in the rate currency to an amount in token
1586 
1587         @param _amount Amount to convert in rate currency
1588         @param _tokens How many tokens
1589         @param _equivalent How much currency _tokens equivales
1590 
1591         @return Amount in tokens
1592     */
1593     function _toToken(
1594         uint256 _amount,
1595         uint256 _tokens,
1596         uint256 _equivalent
1597     ) internal pure returns (uint256 _result) {
1598         require(_tokens != 0, "Oracle provided invalid rate");
1599         uint256 aux = _tokens.mult(_amount);
1600         _result = aux / _equivalent;
1601         if (aux % _equivalent > 0) {
1602             _result = _result.add(1);
1603         }
1604     }
1605 
1606     /**
1607         Converts an amount in token to the rate currency
1608 
1609         @param _amount Amount to convert in token
1610         @param _tokens How many tokens
1611         @param _equivalent How much currency _tokens equivales
1612 
1613         @return Amount in rate currency
1614     */
1615     function _fromToken(
1616         uint256 _amount,
1617         uint256 _tokens,
1618         uint256 _equivalent
1619     ) internal pure returns (uint256) {
1620         require(_equivalent != 0, "Oracle provided invalid rate");
1621         return _amount.mult(_equivalent) / _tokens;
1622     }
1623 
1624     function run(bytes32 _id) external returns (bool) {
1625         Debt storage debt = debts[_id];
1626         require(debt.model != Model(0), "Debt does not exist");
1627 
1628         (uint256 success, bytes32 result) = _safeGasCall(
1629             address(debt.model),
1630             abi.encodeWithSelector(
1631                 debt.model.run.selector,
1632                 _id
1633             )
1634         );
1635 
1636         if (success == 1) {
1637             if (debt.error) {
1638                 emit ErrorRecover({
1639                     _id: _id,
1640                     _sender: msg.sender,
1641                     _value: 0,
1642                     _gasLeft: gasleft(),
1643                     _gasLimit: block.gaslimit,
1644                     _result: result,
1645                     _callData: msg.data
1646                 });
1647 
1648                 delete debt.error;
1649             }
1650 
1651             return result == bytes32(uint256(1));
1652         } else {
1653             emit Error({
1654                 _id: _id,
1655                 _sender: msg.sender,
1656                 _value: 0,
1657                 _gasLeft: gasleft(),
1658                 _gasLimit: block.gaslimit,
1659                 _callData: msg.data
1660             });
1661             debt.error = true;
1662         }
1663     }
1664 
1665     function withdraw(bytes32 _id, address _to) external returns (uint256 amount) {
1666         require(_to != address(0x0), "_to should not be 0x0");
1667         require(_isAuthorized(msg.sender, uint256(_id)), "Sender not authorized");
1668         Debt storage debt = debts[_id];
1669         amount = debt.balance;
1670         debt.balance = 0;
1671         require(token.transfer(_to, amount), "Error sending tokens");
1672         emit Withdrawn({
1673             _id: _id,
1674             _sender: msg.sender,
1675             _to: _to,
1676             _amount: amount
1677         });
1678     }
1679 
1680     function withdrawPartial(bytes32 _id, address _to, uint256 _amount) external returns (bool success) {
1681         require(_to != address(0x0), "_to should not be 0x0");
1682         require(_isAuthorized(msg.sender, uint256(_id)), "Sender not authorized");
1683         Debt storage debt = debts[_id];
1684         require(debt.balance >= _amount, "Debt balance is not enought");
1685         debt.balance = uint128(uint256(debt.balance).sub(_amount));
1686         require(token.transfer(_to, _amount), "Error sending tokens");
1687         emit Withdrawn({
1688             _id: _id,
1689             _sender: msg.sender,
1690             _to: _to,
1691             _amount: _amount
1692         });
1693         success = true;
1694     }
1695 
1696     function withdrawBatch(bytes32[] calldata _ids, address _to) external returns (uint256 total) {
1697         require(_to != address(0x0), "_to should not be 0x0");
1698         bytes32 target;
1699         uint256 balance;
1700         for (uint256 i = 0; i < _ids.length; i++) {
1701             target = _ids[i];
1702             if (_isAuthorized(msg.sender, uint256(target))) {
1703                 balance = debts[target].balance;
1704                 debts[target].balance = 0;
1705                 total += balance;
1706                 emit Withdrawn({
1707                     _id: target,
1708                     _sender: msg.sender,
1709                     _to: _to,
1710                     _amount: balance
1711                 });
1712             }
1713         }
1714         require(token.transfer(_to, total), "Error sending tokens");
1715     }
1716 
1717     function getStatus(bytes32 _id) external view returns (uint256) {
1718         Debt storage debt = debts[_id];
1719         if (debt.error) {
1720             return 4;
1721         } else {
1722             (uint256 success, bytes32 result) = _safeGasStaticCall(
1723                 address(debt.model),
1724                 abi.encodeWithSelector(
1725                     debt.model.getStatus.selector,
1726                     _id
1727                 )
1728             );
1729             return success == 1 ? uint256(result) : 4;
1730         }
1731     }
1732 
1733     function _safeGasStaticCall(
1734         address _contract,
1735         bytes memory _data
1736     ) internal view returns (uint256 success, bytes32 result) {
1737         uint256 _gas = (block.gaslimit * 80) / 100;
1738         _gas = gasleft() < _gas ? gasleft() : _gas;
1739         assembly {
1740             let x := mload(0x40)
1741             success := staticcall(
1742                             _gas,                 // Send almost all gas
1743                             _contract,            // To addr
1744                             add(0x20, _data),     // Input is data past the first 32 bytes
1745                             mload(_data),         // Input size is the lenght of data
1746                             x,                    // Store the ouput on x
1747                             0x20                  // Output is a single bytes32, has 32 bytes
1748                         )
1749 
1750             result := mload(x)
1751         }
1752     }
1753 
1754     function _safeGasCall(
1755         address _contract,
1756         bytes memory _data
1757     ) internal returns (uint256 success, bytes32 result) {
1758         uint256 _gas = (block.gaslimit * 80) / 100;
1759         _gas = gasleft() < _gas ? gasleft() : _gas;
1760         assembly {
1761             let x := mload(0x40)
1762             success := call(
1763                             _gas,                 // Send almost all gas
1764                             _contract,            // To addr
1765                             0,                    // Send ETH
1766                             add(0x20, _data),     // Input is data past the first 32 bytes
1767                             mload(_data),         // Input size is the lenght of data
1768                             x,                    // Store the ouput on x
1769                             0x20                  // Output is a single bytes32, has 32 bytes
1770                         )
1771 
1772             result := mload(x)
1773         }
1774     }
1775 }
1776 
1777 // File: contracts/core/diaspore/interfaces/LoanApprover.sol
1778 
1779 pragma solidity ^0.5.7;
1780 
1781 
1782 
1783 /**
1784     A contract implementing LoanApprover is able to approve loan requests using callbacks,
1785     to approve a loan the contract should respond the callbacks the result of
1786     one designated value XOR keccak256("approve-loan-request")
1787 
1788     keccak256("approve-loan-request"): 0xdfcb15a077f54a681c23131eacdfd6e12b5e099685b492d382c3fd8bfc1e9a2a
1789 
1790     To receive calls on the callbacks, the contract should also implement the following ERC165 interfaces:
1791 
1792     approveRequest: 0x76ba6009
1793     settleApproveRequest: 0xcd40239e
1794     LoanApprover: 0xbbfa4397
1795 */
1796 contract LoanApprover is IERC165 {
1797     /**
1798         Request the approve of a loan created using requestLoan, if the borrower is this contract,
1799         to approve the request the contract should return:
1800 
1801         _futureDebt XOR 0xdfcb15a077f54a681c23131eacdfd6e12b5e099685b492d382c3fd8bfc1e9a2a
1802 
1803         @param _futureDebt ID of the loan to approve
1804 
1805         @return _futureDebt XOR keccak256("approve-loan-request"), if the approve is accepted
1806     */
1807     function approveRequest(bytes32 _futureDebt) external returns (bytes32);
1808 
1809     /**
1810         Request the approve of a loan being settled, the contract can be called as borrower or creator.
1811         To approve the request the contract should return:
1812 
1813         _id XOR 0xdfcb15a077f54a681c23131eacdfd6e12b5e099685b492d382c3fd8bfc1e9a2a
1814 
1815         @param _requestData All the parameters of the loan request
1816         @param _loanData Data to feed to the Model
1817         @param _isBorrower True if this contract is the borrower, False if the contract is the creator
1818         @param _id loanManager.requestSignature(_requestDatam _loanData)
1819 
1820         @return _id XOR keccak256("approve-loan-request"), if the approve is accepted
1821     */
1822     function settleApproveRequest(
1823         bytes calldata _requestData,
1824         bytes calldata _loanData,
1825         bool _isBorrower,
1826         uint256 _id
1827     )
1828         external returns (bytes32);
1829 }
1830 
1831 // File: contracts/interfaces/Cosigner.sol
1832 
1833 pragma solidity ^0.5.7;
1834 
1835 
1836 /**
1837     @dev Defines the interface of a standard RCN cosigner.
1838 
1839     The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
1840     of the insurance and the cost of the given are defined by the cosigner.
1841 
1842     The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
1843     agent should be passed as params when the lender calls the "lend" method on the engine.
1844 
1845     When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
1846     should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
1847     call this method, like the transfer of the ownership of the loan.
1848 */
1849 contract Cosigner {
1850     uint256 public constant VERSION = 2;
1851 
1852     /**
1853         @return the url of the endpoint that exposes the insurance offers.
1854     */
1855     function url() public view returns (string memory);
1856 
1857     /**
1858         @dev Retrieves the cost of a given insurance, this amount should be exact.
1859 
1860         @return the cost of the cosign, in RCN wei
1861     */
1862     function cost(
1863         address engine,
1864         uint256 index,
1865         bytes memory data,
1866         bytes memory oracleData
1867     )
1868         public view returns (uint256);
1869 
1870     /**
1871         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
1872         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
1873         does not return true to this method, the operation fails.
1874 
1875         @return true if the cosigner accepts the liability
1876     */
1877     function requestCosign(
1878         address engine,
1879         uint256 index,
1880         bytes memory data,
1881         bytes memory oracleData
1882     )
1883         public returns (bool);
1884 
1885     /**
1886         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
1887         current lender of the loan.
1888 
1889         @return true if the claim was done correctly.
1890     */
1891     function claim(address engine, uint256 index, bytes memory oracleData) public returns (bool);
1892 }
1893 
1894 // File: contracts/utils/ImplementsInterface.sol
1895 
1896 pragma solidity ^0.5.7;
1897 
1898 
1899 library ImplementsInterface {
1900     bytes4 constant InvalidID = 0xffffffff;
1901     bytes4 constant ERC165ID = 0x01ffc9a7;
1902 
1903     function implementsMethod(address _contract, bytes4 _interfaceId) internal view returns (bool) {
1904         (uint256 success, uint256 result) = _noThrowImplements(_contract, ERC165ID);
1905         if ((success==0)||(result==0)) {
1906             return false;
1907         }
1908 
1909         (success, result) = _noThrowImplements(_contract, InvalidID);
1910         if ((success==0)||(result!=0)) {
1911             return false;
1912         }
1913 
1914         (success, result) = _noThrowImplements(_contract, _interfaceId);
1915         if ((success==1)&&(result==1)) {
1916             return true;
1917         }
1918 
1919         return false;
1920     }
1921 
1922     function _noThrowImplements(
1923         address _contract,
1924         bytes4 _interfaceId
1925     ) private view returns (uint256 success, uint256 result) {
1926         bytes4 erc165ID = ERC165ID;
1927         assembly {
1928             let x := mload(0x40)               // Find empty storage location using "free memory pointer"
1929             mstore(x, erc165ID)                // Place signature at begining of empty storage
1930             mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature
1931 
1932             success := staticcall(
1933                                 30000,         // 30k gas
1934                                 _contract,     // To addr
1935                                 x,             // Inputs are stored at location x
1936                                 0x24,          // Inputs are 32 bytes long
1937                                 x,             // Store output over input (saves space)
1938                                 0x20)          // Outputs are 32 bytes long
1939 
1940             result := mload(x)                 // Load the result
1941         }
1942     }
1943 }
1944 
1945 // File: contracts/utils/BytesUtils.sol
1946 
1947 pragma solidity ^0.5.7;
1948 
1949 
1950 contract BytesUtils {
1951     function readBytes32(bytes memory data, uint256 index) internal pure returns (bytes32 o) {
1952         require(data.length / 32 > index, "Reading bytes out of bounds");
1953         assembly {
1954             o := mload(add(data, add(32, mul(32, index))))
1955         }
1956     }
1957 
1958     function read(bytes memory data, uint256 offset, uint256 length) internal pure returns (bytes32 o) {
1959         require(data.length >= offset + length, "Reading bytes out of bounds");
1960         assembly {
1961             o := mload(add(data, add(32, offset)))
1962             let lb := sub(32, length)
1963             if lb { o := div(o, exp(2, mul(lb, 8))) }
1964         }
1965     }
1966 
1967     function decode(
1968         bytes memory _data,
1969         uint256 _la
1970     ) internal pure returns (bytes32 _a) {
1971         require(_data.length >= _la, "Reading bytes out of bounds");
1972         assembly {
1973             _a := mload(add(_data, 32))
1974             let l := sub(32, _la)
1975             if l { _a := div(_a, exp(2, mul(l, 8))) }
1976         }
1977     }
1978 
1979     function decode(
1980         bytes memory _data,
1981         uint256 _la,
1982         uint256 _lb
1983     ) internal pure returns (bytes32 _a, bytes32 _b) {
1984         uint256 o;
1985         assembly {
1986             let s := add(_data, 32)
1987             _a := mload(s)
1988             let l := sub(32, _la)
1989             if l { _a := div(_a, exp(2, mul(l, 8))) }
1990             o := add(s, _la)
1991             _b := mload(o)
1992             l := sub(32, _lb)
1993             if l { _b := div(_b, exp(2, mul(l, 8))) }
1994             o := sub(o, s)
1995         }
1996         require(_data.length >= o, "Reading bytes out of bounds");
1997     }
1998 
1999     function decode(
2000         bytes memory _data,
2001         uint256 _la,
2002         uint256 _lb,
2003         uint256 _lc
2004     ) internal pure returns (bytes32 _a, bytes32 _b, bytes32 _c) {
2005         uint256 o;
2006         assembly {
2007             let s := add(_data, 32)
2008             _a := mload(s)
2009             let l := sub(32, _la)
2010             if l { _a := div(_a, exp(2, mul(l, 8))) }
2011             o := add(s, _la)
2012             _b := mload(o)
2013             l := sub(32, _lb)
2014             if l { _b := div(_b, exp(2, mul(l, 8))) }
2015             o := add(o, _lb)
2016             _c := mload(o)
2017             l := sub(32, _lc)
2018             if l { _c := div(_c, exp(2, mul(l, 8))) }
2019             o := sub(o, s)
2020         }
2021         require(_data.length >= o, "Reading bytes out of bounds");
2022     }
2023 
2024     function decode(
2025         bytes memory _data,
2026         uint256 _la,
2027         uint256 _lb,
2028         uint256 _lc,
2029         uint256 _ld
2030     ) internal pure returns (bytes32 _a, bytes32 _b, bytes32 _c, bytes32 _d) {
2031         uint256 o;
2032         assembly {
2033             let s := add(_data, 32)
2034             _a := mload(s)
2035             let l := sub(32, _la)
2036             if l { _a := div(_a, exp(2, mul(l, 8))) }
2037             o := add(s, _la)
2038             _b := mload(o)
2039             l := sub(32, _lb)
2040             if l { _b := div(_b, exp(2, mul(l, 8))) }
2041             o := add(o, _lb)
2042             _c := mload(o)
2043             l := sub(32, _lc)
2044             if l { _c := div(_c, exp(2, mul(l, 8))) }
2045             o := add(o, _lc)
2046             _d := mload(o)
2047             l := sub(32, _ld)
2048             if l { _d := div(_d, exp(2, mul(l, 8))) }
2049             o := sub(o, s)
2050         }
2051         require(_data.length >= o, "Reading bytes out of bounds");
2052     }
2053 
2054     function decode(
2055         bytes memory _data,
2056         uint256 _la,
2057         uint256 _lb,
2058         uint256 _lc,
2059         uint256 _ld,
2060         uint256 _le
2061     ) internal pure returns (bytes32 _a, bytes32 _b, bytes32 _c, bytes32 _d, bytes32 _e) {
2062         uint256 o;
2063         assembly {
2064             let s := add(_data, 32)
2065             _a := mload(s)
2066             let l := sub(32, _la)
2067             if l { _a := div(_a, exp(2, mul(l, 8))) }
2068             o := add(s, _la)
2069             _b := mload(o)
2070             l := sub(32, _lb)
2071             if l { _b := div(_b, exp(2, mul(l, 8))) }
2072             o := add(o, _lb)
2073             _c := mload(o)
2074             l := sub(32, _lc)
2075             if l { _c := div(_c, exp(2, mul(l, 8))) }
2076             o := add(o, _lc)
2077             _d := mload(o)
2078             l := sub(32, _ld)
2079             if l { _d := div(_d, exp(2, mul(l, 8))) }
2080             o := add(o, _ld)
2081             _e := mload(o)
2082             l := sub(32, _le)
2083             if l { _e := div(_e, exp(2, mul(l, 8))) }
2084             o := sub(o, s)
2085         }
2086         require(_data.length >= o, "Reading bytes out of bounds");
2087     }
2088 
2089     function decode(
2090         bytes memory _data,
2091         uint256 _la,
2092         uint256 _lb,
2093         uint256 _lc,
2094         uint256 _ld,
2095         uint256 _le,
2096         uint256 _lf
2097     ) internal pure returns (
2098         bytes32 _a,
2099         bytes32 _b,
2100         bytes32 _c,
2101         bytes32 _d,
2102         bytes32 _e,
2103         bytes32 _f
2104     ) {
2105         uint256 o;
2106         assembly {
2107             let s := add(_data, 32)
2108             _a := mload(s)
2109             let l := sub(32, _la)
2110             if l { _a := div(_a, exp(2, mul(l, 8))) }
2111             o := add(s, _la)
2112             _b := mload(o)
2113             l := sub(32, _lb)
2114             if l { _b := div(_b, exp(2, mul(l, 8))) }
2115             o := add(o, _lb)
2116             _c := mload(o)
2117             l := sub(32, _lc)
2118             if l { _c := div(_c, exp(2, mul(l, 8))) }
2119             o := add(o, _lc)
2120             _d := mload(o)
2121             l := sub(32, _ld)
2122             if l { _d := div(_d, exp(2, mul(l, 8))) }
2123             o := add(o, _ld)
2124             _e := mload(o)
2125             l := sub(32, _le)
2126             if l { _e := div(_e, exp(2, mul(l, 8))) }
2127             o := add(o, _le)
2128             _f := mload(o)
2129             l := sub(32, _lf)
2130             if l { _f := div(_f, exp(2, mul(l, 8))) }
2131             o := sub(o, s)
2132         }
2133         require(_data.length >= o, "Reading bytes out of bounds");
2134     }
2135 
2136 }
2137 
2138 // File: contracts/core/diaspore/LoanManager.sol
2139 
2140 pragma solidity ^0.5.7;
2141 
2142 
2143 
2144 
2145 
2146 
2147 
2148 
2149 
2150 
2151 contract LoanManager is BytesUtils {
2152     using ImplementsInterface for address;
2153     using IsContract for address;
2154     using SafeMath for uint256;
2155 
2156     DebtEngine public debtEngine;
2157     IERC20 public token;
2158 
2159     bytes32[] public directory;
2160     mapping(bytes32 => Request) public requests;
2161     mapping(bytes32 => bool) public canceledSettles;
2162 
2163     event Requested(
2164         bytes32 indexed _id,
2165         uint128 _amount,
2166         address _model,
2167         address _creator,
2168         address _oracle,
2169         address _borrower,
2170         uint256 _salt,
2171         bytes _loanData,
2172         uint256 _expiration
2173     );
2174     event Approved(bytes32 indexed _id);
2175     event Lent(bytes32 indexed _id, address _lender, uint256 _tokens);
2176     event Cosigned(bytes32 indexed _id, address _cosigner, uint256 _cost);
2177     event Canceled(bytes32 indexed _id, address _canceler);
2178     event ReadedOracle(address _oracle, uint256 _tokens, uint256 _equivalent);
2179 
2180     event ApprovedRejected(bytes32 indexed _id, bytes32 _response);
2181     event ApprovedError(bytes32 indexed _id, bytes32 _response);
2182 
2183     event ApprovedByCallback(bytes32 indexed _id);
2184     event ApprovedBySignature(bytes32 indexed _id);
2185 
2186     event CreatorByCallback(bytes32 indexed _id);
2187     event BorrowerByCallback(bytes32 indexed _id);
2188     event CreatorBySignature(bytes32 indexed _id);
2189     event BorrowerBySignature(bytes32 indexed _id);
2190 
2191     event SettledLend(bytes32 indexed _id, address _lender, uint256 _tokens);
2192     event SettledCancel(bytes32 indexed _id, address _canceler);
2193 
2194     constructor(DebtEngine _debtEngine) public {
2195         debtEngine = _debtEngine;
2196         token = debtEngine.token();
2197         require(address(token) != address(0), "Error loading token");
2198         directory.length++;
2199     }
2200 
2201     function getDirectory() external view returns (bytes32[] memory) { return directory; }
2202 
2203     function getDirectoryLength() external view returns (uint256) { return directory.length; }
2204 
2205     // uint256 getters(legacy)
2206     function getBorrower(uint256 _id) external view returns (address) { return requests[bytes32(_id)].borrower; }
2207     function getCreator(uint256 _id) external view returns (address) { return requests[bytes32(_id)].creator; }
2208     function getOracle(uint256 _id) external view returns (address) { return requests[bytes32(_id)].oracle; }
2209     function getCosigner(uint256 _id) external view returns (address) { return requests[bytes32(_id)].cosigner; }
2210     function getCurrency(uint256 _id) external view returns (bytes32) {
2211         address oracle = requests[bytes32(_id)].oracle;
2212         return oracle == address(0) ? bytes32(0x0) : RateOracle(oracle).currency();
2213     }
2214     function getAmount(uint256 _id) external view returns (uint256) { return requests[bytes32(_id)].amount; }
2215     function getExpirationRequest(uint256 _id) external view returns (uint256) { return requests[bytes32(_id)].expiration; }
2216     function getApproved(uint256 _id) external view returns (bool) { return requests[bytes32(_id)].approved; }
2217     function getDueTime(uint256 _id) external view returns (uint256) { return Model(requests[bytes32(_id)].model).getDueTime(bytes32(_id)); }
2218     function getClosingObligation(uint256 _id) external view returns (uint256) { return Model(requests[bytes32(_id)].model).getClosingObligation(bytes32(_id)); }
2219     function getLoanData(uint256 _id) external view returns (bytes memory) { return requests[bytes32(_id)].loanData; }
2220     function getStatus(uint256 _id) external view returns (uint256) {
2221         Request storage request = requests[bytes32(_id)];
2222         return request.open ? 0 : debtEngine.getStatus(bytes32(_id));
2223     }
2224     function ownerOf(uint256 _id) external view returns (address) {
2225         return debtEngine.ownerOf(_id);
2226     }
2227 
2228     // bytes32 getters
2229     function getBorrower(bytes32 _id) external view returns (address) { return requests[_id].borrower; }
2230     function getCreator(bytes32 _id) external view returns (address) { return requests[_id].creator; }
2231     function getOracle(bytes32 _id) external view returns (address) { return requests[_id].oracle; }
2232     function getCosigner(bytes32 _id) external view returns (address) { return requests[_id].cosigner; }
2233     function getCurrency(bytes32 _id) external view returns (bytes32) {
2234         address oracle = requests[_id].oracle;
2235         return oracle == address(0) ? bytes32(0x0) : RateOracle(oracle).currency();
2236     }
2237     function getAmount(bytes32 _id) external view returns (uint256) { return requests[_id].amount; }
2238     function getExpirationRequest(bytes32 _id) external view returns (uint256) { return requests[_id].expiration; }
2239     function getApproved(bytes32 _id) external view returns (bool) { return requests[_id].approved; }
2240     function getDueTime(bytes32 _id) external view returns (uint256) { return Model(requests[_id].model).getDueTime(bytes32(_id)); }
2241     function getClosingObligation(bytes32 _id) external view returns (uint256) { return Model(requests[_id].model).getClosingObligation(bytes32(_id)); }
2242     function getLoanData(bytes32 _id) external view returns (bytes memory) { return requests[_id].loanData; }
2243     function getStatus(bytes32 _id) external view returns (uint256) {
2244         Request storage request = requests[_id];
2245         return request.open ? 0 : debtEngine.getStatus(bytes32(_id));
2246     }
2247     function ownerOf(bytes32 _id) external view returns (address) {
2248         return debtEngine.ownerOf(uint256(_id));
2249     }
2250 
2251     struct Request {
2252         bool open;
2253         bool approved;
2254         uint64 position;
2255         uint64 expiration;
2256         uint128 amount;
2257         address cosigner;
2258         address model;
2259         address creator;
2260         address oracle;
2261         address borrower;
2262         uint256 salt;
2263         bytes loanData;
2264     }
2265 
2266     function calcId(
2267         uint128 _amount,
2268         address _borrower,
2269         address _creator,
2270         address _model,
2271         address _oracle,
2272         uint256 _salt,
2273         uint64 _expiration,
2274         bytes calldata _data
2275     ) external view returns (bytes32) {
2276         return debtEngine.buildId2(
2277             address(this),
2278             _model,
2279             _oracle,
2280             _buildInternalSalt(
2281                 _amount,
2282                 _borrower,
2283                 _creator,
2284                 _salt,
2285                 _expiration
2286             ),
2287             _data
2288         );
2289     }
2290 
2291     function buildInternalSalt(
2292         uint128 _amount,
2293         address _borrower,
2294         address _creator,
2295         uint256 _salt,
2296         uint64 _expiration
2297     ) external pure returns (uint256) {
2298         return _buildInternalSalt(
2299             _amount,
2300             _borrower,
2301             _creator,
2302             _salt,
2303             _expiration
2304         );
2305     }
2306 
2307     function internalSalt(bytes32 _id) external view returns (uint256) {
2308         Request storage request = requests[_id];
2309         require(request.borrower != address(0), "Request does not exist");
2310         return _internalSalt(request);
2311     }
2312 
2313     function _internalSalt(Request memory _request) internal view returns (uint256) {
2314         return _buildInternalSalt(
2315             _request.amount,
2316             _request.borrower,
2317             _request.creator,
2318             _request.salt,
2319             _request.expiration
2320         );
2321     }
2322 
2323     function requestLoan(
2324         uint128 _amount,
2325         address _model,
2326         address _oracle,
2327         address _borrower,
2328         uint256 _salt,
2329         uint64 _expiration,
2330         bytes calldata _loanData
2331     ) external returns (bytes32 id) {
2332         require(_borrower != address(0), "The request should have a borrower");
2333         require(Model(_model).validate(_loanData), "The loan data is not valid");
2334 
2335         uint256 innerSalt = _buildInternalSalt(_amount, _borrower, msg.sender, _salt, _expiration);
2336         id = keccak256(
2337             abi.encodePacked(
2338                 uint8(2),
2339                 debtEngine,
2340                 address(this),
2341                 _model,
2342                 _oracle,
2343                 innerSalt,
2344                 _loanData
2345             )
2346         );
2347 
2348         require(requests[id].borrower == address(0), "Request already exist");
2349 
2350         bool approved = msg.sender == _borrower;
2351 
2352         requests[id] = Request({
2353             open: true,
2354             approved: approved,
2355             position: 0,
2356             cosigner: address(0),
2357             amount: _amount,
2358             model: _model,
2359             creator: msg.sender,
2360             oracle: _oracle,
2361             borrower: _borrower,
2362             salt: _salt,
2363             loanData: _loanData,
2364             expiration: _expiration
2365         });
2366 
2367         emit Requested(id, _amount, _model, msg.sender, _oracle, _borrower, _salt, _loanData, _expiration);
2368 
2369         if (!approved) {
2370             // implements: 0x76ba6009 = approveRequest(bytes32)
2371             if (_borrower.isContract() && _borrower.implementsMethod(0x76ba6009)) {
2372                 approved = _requestContractApprove(id, _borrower);
2373                 requests[id].approved = approved;
2374             }
2375         }
2376 
2377         if (approved) {
2378             requests[id].position = uint64(directory.push(id) - 1);
2379             emit Approved(id);
2380         }
2381     }
2382 
2383     function _requestContractApprove(
2384         bytes32 _id,
2385         address _borrower
2386     ) internal returns (bool approved) {
2387         // bytes32 expected = _id XOR keccak256("approve-loan-request");
2388         bytes32 expected = _id ^ 0xdfcb15a077f54a681c23131eacdfd6e12b5e099685b492d382c3fd8bfc1e9a2a;
2389         (uint256 success, bytes32 result) = _safeCall(
2390             _borrower,
2391             abi.encodeWithSelector(
2392                 0x76ba6009,
2393                 _id
2394             )
2395         );
2396 
2397         approved = success == 1 && result == expected;
2398 
2399         // Emit events if approve was rejected or failed
2400         if (approved) {
2401             emit ApprovedByCallback(_id);
2402         } else {
2403             if (success == 0) {
2404                 emit ApprovedError(_id, result);
2405             } else {
2406                 emit ApprovedRejected(_id, result);
2407             }
2408         }
2409     }
2410 
2411     function approveRequest(
2412         bytes32 _id
2413     ) external returns (bool) {
2414         Request storage request = requests[_id];
2415         require(msg.sender == request.borrower, "Only borrower can approve");
2416         if (!request.approved) {
2417             request.position = uint64(directory.push(_id) - 1);
2418             request.approved = true;
2419             emit Approved(_id);
2420         }
2421         return true;
2422     }
2423 
2424     function registerApproveRequest(
2425         bytes32 _id,
2426         bytes calldata _signature
2427     ) external returns (bool approved) {
2428         Request storage request = requests[_id];
2429         address borrower = request.borrower;
2430 
2431         if (!request.approved) {
2432             if (borrower.isContract() && borrower.implementsMethod(0x76ba6009)) {
2433                 approved = _requestContractApprove(_id, borrower);
2434             } else {
2435                 if (borrower == ecrecovery(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _id)), _signature)) {
2436                     emit ApprovedBySignature(_id);
2437                     approved = true;
2438                 }
2439             }
2440         }
2441 
2442         // Check request.approved again, protect against reentrancy
2443         if (approved && !request.approved) {
2444             request.position = uint64(directory.push(_id) - 1);
2445             request.approved = true;
2446             emit Approved(_id);
2447         }
2448     }
2449 
2450     function lend(
2451         bytes32 _id,
2452         bytes memory _oracleData,
2453         address _cosigner,
2454         uint256 _cosignerLimit,
2455         bytes memory _cosignerData
2456     ) public returns (bool) {
2457         Request storage request = requests[_id];
2458         require(request.open, "Request is no longer open");
2459         require(request.approved, "The request is not approved by the borrower");
2460         require(request.expiration > now, "The request is expired");
2461 
2462         request.open = false;
2463 
2464         uint256 tokens = _currencyToToken(request.oracle, request.amount, _oracleData);
2465         require(
2466             token.transferFrom(
2467                 msg.sender,
2468                 request.borrower,
2469                 tokens
2470             ),
2471             "Error sending tokens to borrower"
2472         );
2473 
2474         emit Lent(_id, msg.sender, tokens);
2475 
2476         // Generate the debt
2477         require(
2478             debtEngine.create2(
2479                 Model(request.model),
2480                 msg.sender,
2481                 request.oracle,
2482                 _internalSalt(request),
2483                 request.loanData
2484             ) == _id,
2485             "Error creating the debt"
2486         );
2487 
2488         // Remove directory entry
2489         bytes32 last = directory[directory.length - 1];
2490         requests[last].position = request.position;
2491         directory[request.position] = last;
2492         request.position = 0;
2493         directory.length--;
2494 
2495         // Call the cosigner
2496         if (_cosigner != address(0)) {
2497             uint256 auxSalt = request.salt;
2498             request.cosigner = address(uint256(_cosigner) + 2);
2499             request.salt = _cosignerLimit; // Risky ?
2500             require(
2501                 Cosigner(_cosigner).requestCosign(
2502                     address(this),
2503                     uint256(_id),
2504                     _cosignerData,
2505                     _oracleData
2506                 ),
2507                 "Cosign method returned false"
2508             );
2509             require(request.cosigner == _cosigner, "Cosigner didn't callback");
2510             request.salt = auxSalt;
2511         }
2512 
2513         return true;
2514     }
2515 
2516     function cancel(bytes32 _id) external returns (bool) {
2517         Request storage request = requests[_id];
2518 
2519         require(request.open, "Request is no longer open or not requested");
2520         require(
2521             request.creator == msg.sender || request.borrower == msg.sender,
2522             "Only borrower or creator can cancel a request"
2523         );
2524 
2525         if (request.approved){
2526             // Remove directory entry
2527             bytes32 last = directory[directory.length - 1];
2528             requests[last].position = request.position;
2529             directory[request.position] = last;
2530             directory.length--;
2531         }
2532 
2533         delete request.loanData;
2534         delete requests[_id];
2535 
2536         emit Canceled(_id, msg.sender);
2537 
2538         return true;
2539     }
2540 
2541     function cosign(uint256 _id, uint256 _cost) external returns (bool) {
2542         Request storage request = requests[bytes32(_id)];
2543         require(request.position == 0, "Request cosigned is invalid");
2544         require(request.cosigner != address(0), "Cosigner 0x0 is not valid");
2545         require(request.expiration > now, "Request is expired");
2546         require(request.cosigner == address(uint256(msg.sender) + 2), "Cosigner not valid");
2547         request.cosigner = msg.sender;
2548         if (_cost != 0){
2549             require(request.salt >= _cost, "Cosigner cost exceeded");
2550             require(token.transferFrom(debtEngine.ownerOf(_id), msg.sender, _cost), "Error paying cosigner");
2551         }
2552         emit Cosigned(bytes32(_id), msg.sender, _cost);
2553         return true;
2554     }
2555 
2556     // ///
2557     // Offline requests
2558     // ///
2559 
2560     uint256 private constant L_AMOUNT = 16;
2561     uint256 private constant O_AMOUNT = 0;
2562     uint256 private constant O_MODEL = L_AMOUNT;
2563     uint256 private constant L_MODEL = 20;
2564     uint256 private constant O_ORACLE = O_MODEL + L_MODEL;
2565     uint256 private constant L_ORACLE = 20;
2566     uint256 private constant O_BORROWER = O_ORACLE + L_ORACLE;
2567     uint256 private constant L_BORROWER = 20;
2568     uint256 private constant O_SALT = O_BORROWER + L_BORROWER;
2569     uint256 private constant L_SALT = 32;
2570     uint256 private constant O_EXPIRATION = O_SALT + L_SALT;
2571     uint256 private constant L_EXPIRATION = 8;
2572     uint256 private constant O_CREATOR = O_EXPIRATION + L_EXPIRATION;
2573     uint256 private constant L_CREATOR = 20;
2574 
2575     uint256 private constant L_TOTAL = O_CREATOR + L_CREATOR;
2576 
2577     function encodeRequest(
2578         uint128 _amount,
2579         address _model,
2580         address _oracle,
2581         address _borrower,
2582         uint256 _salt,
2583         uint64 _expiration,
2584         address _creator,
2585         bytes calldata _loanData
2586     ) external view returns (bytes memory requestData, bytes32 id) {
2587         requestData = abi.encodePacked(
2588             _amount,
2589             _model,
2590             _oracle,
2591             _borrower,
2592             _salt,
2593             _expiration,
2594             _creator
2595         );
2596 
2597         uint256 innerSalt = _buildInternalSalt(
2598             _amount,
2599             _borrower,
2600             _creator,
2601             _salt,
2602             _expiration
2603         );
2604 
2605         id = debtEngine.buildId2(
2606             address(this),
2607             _model,
2608             _oracle,
2609             innerSalt,
2610             _loanData
2611         );
2612     }
2613 
2614     function settleLend(
2615         bytes memory _requestData,
2616         bytes memory _loanData,
2617         address _cosigner,
2618         uint256 _maxCosignerCost,
2619         bytes memory _cosignerData,
2620         bytes memory _oracleData,
2621         bytes memory _creatorSig,
2622         bytes memory _borrowerSig
2623     ) public returns (bytes32 id) {
2624         // Validate request
2625         require(uint256(read(_requestData, O_EXPIRATION, L_EXPIRATION)) > now, "Loan request is expired");
2626 
2627         // Get id
2628         uint256 innerSalt;
2629         (id, innerSalt) = _buildSettleId(_requestData, _loanData);
2630 
2631         // Validate signatures
2632         require(requests[id].borrower == address(0), "Request already exist");
2633         _validateSettleSignatures(id, _requestData, _loanData, _creatorSig, _borrowerSig);
2634 
2635         // Transfer tokens to borrower
2636         uint256 tokens = _currencyToToken(_requestData, _oracleData);
2637         require(
2638             token.transferFrom(
2639                 msg.sender,
2640                 address(uint256(read(_requestData, O_BORROWER, L_BORROWER))),
2641                 tokens
2642             ),
2643             "Error sending tokens to borrower"
2644         );
2645 
2646         // Generate the debt
2647         require(
2648             _createDebt(
2649                 _requestData,
2650                 _loanData,
2651                 innerSalt
2652             ) == id,
2653             "Error creating debt registry"
2654         );
2655 
2656         emit SettledLend(id, msg.sender, tokens);
2657 
2658         // Save the request info
2659         requests[id] = Request({
2660             open: false,
2661             approved: true,
2662             cosigner: _cosigner,
2663             amount: uint128(uint256(read(_requestData, O_AMOUNT, L_AMOUNT))),
2664             model: address(uint256(read(_requestData, O_MODEL, L_MODEL))),
2665             creator: address(uint256(read(_requestData, O_CREATOR, L_CREATOR))),
2666             oracle: address(uint256(read(_requestData, O_ORACLE, L_ORACLE))),
2667             borrower: address(uint256(read(_requestData, O_BORROWER, L_BORROWER))),
2668             salt: _cosigner != address(0) ? _maxCosignerCost : uint256(read(_requestData, O_SALT, L_SALT)),
2669             loanData: _loanData,
2670             position: 0,
2671             expiration: uint64(uint256(read(_requestData, O_EXPIRATION, L_EXPIRATION)))
2672         });
2673 
2674         Request storage request = requests[id];
2675 
2676         // Call the cosigner
2677         if (_cosigner != address(0)) {
2678             request.cosigner = address(uint256(_cosigner) + 2);
2679             require(Cosigner(_cosigner).requestCosign(address(this), uint256(id), _cosignerData, _oracleData), "Cosign method returned false");
2680             require(request.cosigner == _cosigner, "Cosigner didn't callback");
2681             request.salt = uint256(read(_requestData, O_SALT, L_SALT));
2682         }
2683     }
2684 
2685     function settleCancel(
2686         bytes calldata _requestData,
2687         bytes calldata _loanData
2688     ) external returns (bool) {
2689         (bytes32 id, ) = _buildSettleId(_requestData, _loanData);
2690         require(
2691             msg.sender == address(uint256(read(_requestData, O_BORROWER, L_BORROWER))) ||
2692             msg.sender == address(uint256(read(_requestData, O_CREATOR, L_CREATOR))),
2693             "Only borrower or creator can cancel a settle"
2694         );
2695         canceledSettles[id] = true;
2696         emit SettledCancel(id, msg.sender);
2697 
2698         return true;
2699     }
2700 
2701     function _validateSettleSignatures(
2702         bytes32 _id,
2703         bytes memory _requestData,
2704         bytes memory _loanData,
2705         bytes memory _creatorSig,
2706         bytes memory _borrowerSig
2707     ) internal {
2708         require(!canceledSettles[_id], "Settle was canceled");
2709 
2710         // bytes32 expected = uint256(_id) XOR keccak256("approve-loan-request");
2711         bytes32 expected = _id ^ 0xdfcb15a077f54a681c23131eacdfd6e12b5e099685b492d382c3fd8bfc1e9a2a;
2712         address borrower = address(uint256(read(_requestData, O_BORROWER, L_BORROWER)));
2713         address creator = address(uint256(read(_requestData, O_CREATOR, L_CREATOR)));
2714 
2715         if (borrower.isContract()) {
2716             require(
2717                 LoanApprover(borrower).settleApproveRequest(_requestData, _loanData, true, uint256(_id)) == expected,
2718                 "Borrower contract rejected the loan"
2719             );
2720 
2721             emit BorrowerByCallback(_id);
2722         } else {
2723             require(
2724                 borrower == ecrecovery(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _id)), _borrowerSig),
2725                 "Invalid borrower signature"
2726             );
2727 
2728             emit BorrowerBySignature(_id);
2729         }
2730 
2731         if (borrower != creator) {
2732             if (creator.isContract()) {
2733                 require(
2734                     LoanApprover(creator).settleApproveRequest(_requestData, _loanData, false, uint256(_id)) == expected,
2735                     "Creator contract rejected the loan"
2736                 );
2737 
2738                 emit CreatorByCallback(_id);
2739             } else {
2740                 require(
2741                     creator == ecrecovery(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _id)), _creatorSig),
2742                     "Invalid creator signature"
2743                 );
2744 
2745                 emit CreatorBySignature(_id);
2746             }
2747         }
2748     }
2749 
2750     function _currencyToToken(
2751         bytes memory _requestData,
2752         bytes memory _oracleData
2753     ) internal returns (uint256) {
2754         return _currencyToToken(
2755             address(uint256(read(_requestData, O_ORACLE, L_ORACLE))),
2756             uint256(read(_requestData, O_AMOUNT, L_AMOUNT)),
2757             _oracleData
2758         );
2759     }
2760 
2761     function _createDebt(
2762         bytes memory _requestData,
2763         bytes memory _loanData,
2764         uint256 _innerSalt
2765     ) internal returns (bytes32) {
2766         return debtEngine.create2(
2767             Model(address(uint256(read(_requestData, O_MODEL, L_MODEL)))),
2768             msg.sender,
2769             address(uint256(read(_requestData, O_ORACLE, L_ORACLE))),
2770             _innerSalt,
2771             _loanData
2772         );
2773     }
2774 
2775     function _buildSettleId(
2776         bytes memory _requestData,
2777         bytes memory _loanData
2778     ) internal view returns (bytes32 id, uint256 innerSalt) {
2779         (
2780             uint128 amount,
2781             address model,
2782             address oracle,
2783             address borrower,
2784             uint256 salt,
2785             uint64 expiration,
2786             address creator
2787         ) = _decodeSettle(_requestData);
2788 
2789         innerSalt = _buildInternalSalt(
2790             amount,
2791             borrower,
2792             creator,
2793             salt,
2794             expiration
2795         );
2796 
2797         id = debtEngine.buildId2(
2798             address(this),
2799             model,
2800             oracle,
2801             innerSalt,
2802             _loanData
2803         );
2804     }
2805 
2806     function _buildInternalSalt(
2807         uint128 _amount,
2808         address _borrower,
2809         address _creator,
2810         uint256 _salt,
2811         uint64 _expiration
2812     ) internal pure returns (uint256) {
2813         return uint256(
2814             keccak256(
2815                 abi.encodePacked(
2816                     _amount,
2817                     _borrower,
2818                     _creator,
2819                     _salt,
2820                     _expiration
2821                 )
2822             )
2823         );
2824     }
2825 
2826     function _decodeSettle(
2827         bytes memory _data
2828     ) internal pure returns (
2829         uint128 amount,
2830         address model,
2831         address oracle,
2832         address borrower,
2833         uint256 salt,
2834         uint64 expiration,
2835         address creator
2836     ) {
2837         (
2838             bytes32 _amount,
2839             bytes32 _model,
2840             bytes32 _oracle,
2841             bytes32 _borrower,
2842             bytes32 _salt,
2843             bytes32 _expiration
2844         ) = decode(_data, L_AMOUNT, L_MODEL, L_ORACLE, L_BORROWER, L_SALT, L_EXPIRATION);
2845 
2846         amount = uint128(uint256(_amount));
2847         model = address(uint256(_model));
2848         oracle = address(uint256(_oracle));
2849         borrower = address(uint256(_borrower));
2850         salt = uint256(_salt);
2851         expiration = uint64(uint256(_expiration));
2852         creator = address(uint256(read(_data, O_CREATOR, L_CREATOR)));
2853     }
2854 
2855     function ecrecovery(bytes32 _hash, bytes memory _sig) internal pure returns (address) {
2856         bytes32 r;
2857         bytes32 s;
2858         uint8 v;
2859 
2860         assembly {
2861             r := mload(add(_sig, 32))
2862             s := mload(add(_sig, 64))
2863             v := and(mload(add(_sig, 65)), 255)
2864         }
2865 
2866         if (v < 27) {
2867             v += 27;
2868         }
2869 
2870         return ecrecover(_hash, v, r, s);
2871     }
2872 
2873     function _currencyToToken(
2874         address _oracle,
2875         uint256 _amount,
2876         bytes memory _oracleData
2877     ) internal returns (uint256) {
2878         if (_oracle == address(0)) return _amount;
2879         (uint256 tokens, uint256 equivalent) = RateOracle(_oracle).readSample(_oracleData);
2880 
2881         emit ReadedOracle(_oracle, tokens, equivalent);
2882 
2883         return tokens.mult(_amount) / equivalent;
2884     }
2885 
2886     function _safeCall(
2887         address _contract,
2888         bytes memory _data
2889     ) internal returns (uint256 success, bytes32 result) {
2890         assembly {
2891             let x := mload(0x40)
2892             success := call(
2893                             gas,                 // Send almost all gas
2894                             _contract,            // To addr
2895                             0,                    // Send ETH
2896                             add(0x20, _data),     // Input is data past the first 32 bytes
2897                             mload(_data),         // Input size is the lenght of data
2898                             x,                    // Store the ouput on x
2899                             0x20                  // Output is a single bytes32, has 32 bytes
2900                         )
2901 
2902             result := mload(x)
2903         }
2904     }
2905 }