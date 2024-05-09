1 pragma solidity ^0.4.24;
2 
3 contract Token {
4     function transfer(address _to, uint _value) public returns (bool success);
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10 }
11 
12 
13 contract Ownable {
14     address public owner;
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner, "Sender is not the owner");
18         _;
19     }
20 
21     constructor() public {
22         owner = msg.sender; 
23     }
24 
25     /**
26         @dev Transfers the ownership of the contract.
27 
28         @param _to Address of the new owner
29     */
30     function transferTo(address _to) public onlyOwner returns (bool) {
31         require(_to != address(0), "Can't transfer to 0x0");
32         owner = _to;
33         return true;
34     }
35 }
36 
37 
38 /**
39     @dev Defines the interface of a standard RCN oracle.
40 
41     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
42     it's primarily used by the exchange but could be used by any other agent.
43 */
44 contract Oracle is Ownable {
45     uint256 public constant VERSION = 4;
46 
47     event NewSymbol(bytes32 _currency);
48 
49     mapping(bytes32 => bool) public supported;
50     bytes32[] public currencies;
51 
52     /**
53         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
54     */
55     function url() public view returns (string);
56 
57     /**
58         @dev Returns a valid convertion rate from the currency given to RCN
59 
60         @param symbol Symbol of the currency
61         @param data Generic data field, could be used for off-chain signing
62     */
63     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
64 
65     /**
66         @dev Adds a currency to the oracle, once added it cannot be removed
67 
68         @param ticker Symbol of the currency
69 
70         @return if the creation was done successfully
71     */
72     function addCurrency(string ticker) public onlyOwner returns (bool) {
73         bytes32 currency = encodeCurrency(ticker);
74         NewSymbol(currency);
75         supported[currency] = true;
76         currencies.push(currency);
77         return true;
78     }
79 
80     /**
81         @return the currency encoded as a bytes32
82     */
83     function encodeCurrency(string currency) public pure returns (bytes32 o) {
84         require(bytes(currency).length <= 32);
85         assembly {
86             o := mload(add(currency, 32))
87         }
88     }
89     
90     /**
91         @return the currency string from a encoded bytes32
92     */
93     function decodeCurrency(bytes32 b) public pure returns (string o) {
94         uint256 ns = 256;
95         while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }
96         assembly {
97             ns := div(ns, 8)
98             o := mload(0x40)
99             mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))
100             mstore(o, ns)
101             mstore(add(o, 32), b)
102         }
103     }
104     
105 }
106 
107 contract Engine {
108     uint256 public VERSION;
109     string public VERSION_NAME;
110 
111     enum Status { initial, lent, paid, destroyed }
112     struct Approbation {
113         bool approved;
114         bytes data;
115         bytes32 checksum;
116     }
117 
118     function getTotalLoans() public view returns (uint256);
119     function getOracle(uint index) public view returns (Oracle);
120     function getBorrower(uint index) public view returns (address);
121     function getCosigner(uint index) public view returns (address);
122     function ownerOf(uint256) public view returns (address owner);
123     function getCreator(uint index) public view returns (address);
124     function getAmount(uint index) public view returns (uint256);
125     function getPaid(uint index) public view returns (uint256);
126     function getDueTime(uint index) public view returns (uint256);
127     function getApprobation(uint index, address _address) public view returns (bool);
128     function getStatus(uint index) public view returns (Status);
129     function isApproved(uint index) public view returns (bool);
130     function getPendingAmount(uint index) public returns (uint256);
131     function getCurrency(uint index) public view returns (bytes32);
132     function cosign(uint index, uint256 cost) external returns (bool);
133     function approveLoan(uint index) public returns (bool);
134     function transfer(address to, uint256 index) public returns (bool);
135     function takeOwnership(uint256 index) public returns (bool);
136     function withdrawal(uint index, address to, uint256 amount) public returns (bool);
137     function identifierToIndex(bytes32 signature) public view returns (uint256);
138 }
139 
140 
141 /**
142     @dev Defines the interface of a standard RCN cosigner.
143 
144     The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
145     of the insurance and the cost of the given are defined by the cosigner. 
146 
147     The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
148     agent should be passed as params when the lender calls the "lend" method on the engine.
149     
150     When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
151     should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
152     call this method, like the transfer of the ownership of the loan.
153 */
154 contract Cosigner {
155     uint256 public constant VERSION = 2;
156     
157     /**
158         @return the url of the endpoint that exposes the insurance offers.
159     */
160     function url() external view returns (string);
161     
162     /**
163         @dev Retrieves the cost of a given insurance, this amount should be exact.
164 
165         @return the cost of the cosign, in RCN wei
166     */
167     function cost(address engine, uint256 index, bytes data, bytes oracleData) external view returns (uint256);
168     
169     /**
170         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
171         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
172         does not return true to this method, the operation fails.
173 
174         @return true if the cosigner accepts the liability
175     */
176     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool);
177     
178     /**
179         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
180         current lender of the loan.
181 
182         @return true if the claim was done correctly.
183     */
184     function claim(address engine, uint256 index, bytes oracleData) external returns (bool);
185 }
186 
187 library SafeMath {
188     function add(uint256 x, uint256 y) internal pure returns(uint256) {
189         uint256 z = x + y;
190         require((z >= x) && (z >= y));
191         return z;
192     }
193 
194     function sub(uint256 x, uint256 y) internal pure returns(uint256) {
195         require(x >= y);
196         uint256 z = x - y;
197         return z;
198     }
199 
200     function mult(uint256 x, uint256 y) internal pure returns(uint256) {
201         uint256 z = x * y;
202         require((x == 0)||(z/x == y));
203         return z;
204     }
205 }
206 
207 
208 contract SafeWithdraw is Ownable {
209     /**
210         @dev Withdraws tokens from the contract.
211 
212         @param token Token to withdraw
213         @param to Destination of the tokens
214         @param amountOrId Amount/ID to withdraw 
215     */
216     function withdrawTokens(Token token, address to, uint256 amountOrId) external onlyOwner returns (bool) {
217         require(to != address(0));
218         return token.transfer(to, amountOrId);
219     }
220 }
221 
222 contract BytesUtils {
223     function readBytes32(bytes data, uint256 index) internal pure returns (bytes32 o) {
224         require(data.length / 32 > index);
225         assembly {
226             o := mload(add(data, add(32, mul(32, index))))
227         }
228     }
229 }
230 
231 contract TokenConverter {
232     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
233     function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);
234     function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);
235 }
236 
237 
238 
239 interface IERC721Receiver {
240     function onERC721Received(
241         address _oldOwner,
242         uint256 _tokenId,
243         bytes   _userData
244     ) external returns (bytes4);
245 }
246 
247 contract ERC721Base {
248     using SafeMath for uint256;
249 
250     uint256 private _count;
251 
252     mapping(uint256 => address) private _holderOf;
253     mapping(address => uint256[]) private _assetsOf;
254     mapping(address => mapping(address => bool)) private _operators;
255     mapping(uint256 => address) private _approval;
256     mapping(uint256 => uint256) private _indexOfAsset;
257 
258     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
259     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
260     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
261 
262     //
263     // Global Getters
264     //
265 
266     /**
267      * @dev Gets the total amount of assets stored by the contract
268      * @return uint256 representing the total amount of assets
269      */
270     function totalSupply() external view returns (uint256) {
271         return _totalSupply();
272     }
273     function _totalSupply() internal view returns (uint256) {
274         return _count;
275     }
276 
277     //
278     // Asset-centric getter functions
279     //
280 
281     /**
282      * @dev Queries what address owns an asset. This method does not throw.
283      * In order to check if the asset exists, use the `exists` function or check if the
284      * return value of this call is `0`.
285      * @return uint256 the assetId
286      */
287     function ownerOf(uint256 assetId) external view returns (address) {
288         return _ownerOf(assetId);
289     }
290     function _ownerOf(uint256 assetId) internal view returns (address) {
291         return _holderOf[assetId];
292     }
293 
294     //
295     // Holder-centric getter functions
296     //
297     /**
298      * @dev Gets the balance of the specified address
299      * @param owner address to query the balance of
300      * @return uint256 representing the amount owned by the passed address
301      */
302     function balanceOf(address owner) external view returns (uint256) {
303         return _balanceOf(owner);
304     }
305     function _balanceOf(address owner) internal view returns (uint256) {
306         return _assetsOf[owner].length;
307     }
308 
309     //
310     // Authorization getters
311     //
312 
313     /**
314      * @dev Query whether an address has been authorized to move any assets on behalf of someone else
315      * @param operator the address that might be authorized
316      * @param assetHolder the address that provided the authorization
317      * @return bool true if the operator has been authorized to move any assets
318      */
319     function isApprovedForAll(address operator, address assetHolder)
320         external view returns (bool)
321     {
322         return _isApprovedForAll(operator, assetHolder);
323     }
324     function _isApprovedForAll(address operator, address assetHolder)
325         internal view returns (bool)
326     {
327         return _operators[assetHolder][operator];
328     }
329 
330     /**
331      * @dev Query what address has been particularly authorized to move an asset
332      * @param assetId the asset to be queried for
333      * @return bool true if the asset has been approved by the holder
334      */
335     function getApprovedAddress(uint256 assetId) external view returns (address) {
336         return _getApprovedAddress(assetId);
337     }
338     function _getApprovedAddress(uint256 assetId) internal view returns (address) {
339         return _approval[assetId];
340     }
341 
342     /**
343      * @dev Query if an operator can move an asset.
344      * @param operator the address that might be authorized
345      * @param assetId the asset that has been `approved` for transfer
346      * @return bool true if the asset has been approved by the holder
347      */
348     function isAuthorized(address operator, uint256 assetId) external view returns (bool) {
349         return _isAuthorized(operator, assetId);
350     }
351     function _isAuthorized(address operator, uint256 assetId) internal view returns (bool)
352     {
353         require(operator != 0, "Operator can't be 0");
354         address owner = _ownerOf(assetId);
355         if (operator == owner) {
356             return true;
357         }
358         return _isApprovedForAll(operator, owner) || _getApprovedAddress(assetId) == operator;
359     }
360 
361     //
362     // Authorization
363     //
364 
365     /**
366      * @dev Authorize a third party operator to manage (send) msg.sender's asset
367      * @param operator address to be approved
368      * @param authorized bool set to true to authorize, false to withdraw authorization
369      */
370     function setApprovalForAll(address operator, bool authorized) external {
371         return _setApprovalForAll(operator, authorized);
372     }
373     function _setApprovalForAll(address operator, bool authorized) internal {
374         if (authorized) {
375             _addAuthorization(operator, msg.sender);
376         } else {
377             _clearAuthorization(operator, msg.sender);
378         }
379         emit ApprovalForAll(operator, msg.sender, authorized);
380     }
381 
382     /**
383      * @dev Authorize a third party operator to manage one particular asset
384      * @param operator address to be approved
385      * @param assetId asset to approve
386      */
387     function approve(address operator, uint256 assetId) external {
388         address holder = _ownerOf(assetId);
389         require(msg.sender == holder || _isApprovedForAll(msg.sender, holder));
390         require(operator != holder);
391         if (_getApprovedAddress(assetId) != operator) {
392             _approval[assetId] = operator;
393             emit Approval(holder, operator, assetId);
394         }
395     }
396 
397     function _addAuthorization(address operator, address holder) private {
398         _operators[holder][operator] = true;
399     }
400 
401     function _clearAuthorization(address operator, address holder) private {
402         _operators[holder][operator] = false;
403     }
404 
405     //
406     // Internal Operations
407     //
408 
409     function _addAssetTo(address to, uint256 assetId) internal {
410         _holderOf[assetId] = to;
411 
412         uint256 length = _balanceOf(to);
413 
414         _assetsOf[to].push(assetId);
415 
416         _indexOfAsset[assetId] = length;
417 
418         _count = _count.add(1);
419     }
420 
421     function _removeAssetFrom(address from, uint256 assetId) internal {
422         uint256 assetIndex = _indexOfAsset[assetId];
423         uint256 lastAssetIndex = _balanceOf(from).sub(1);
424         uint256 lastAssetId = _assetsOf[from][lastAssetIndex];
425 
426         _holderOf[assetId] = 0;
427 
428         // Insert the last asset into the position previously occupied by the asset to be removed
429         _assetsOf[from][assetIndex] = lastAssetId;
430 
431         // Resize the array
432         _assetsOf[from][lastAssetIndex] = 0;
433         _assetsOf[from].length--;
434 
435         // Remove the array if no more assets are owned to prevent pollution
436         if (_assetsOf[from].length == 0) {
437             delete _assetsOf[from];
438         }
439 
440         // Update the index of positions for the asset
441         _indexOfAsset[assetId] = 0;
442         _indexOfAsset[lastAssetId] = assetIndex;
443 
444         _count = _count.sub(1);
445     }
446 
447     function _clearApproval(address holder, uint256 assetId) internal {
448         if (_ownerOf(assetId) == holder && _approval[assetId] != 0) {
449             _approval[assetId] = 0;
450             emit Approval(holder, 0, assetId);
451         }
452     }
453 
454     //
455     // Supply-altering functions
456     //
457 
458     function _generate(uint256 assetId, address beneficiary) internal {
459         require(_holderOf[assetId] == 0);
460 
461         _addAssetTo(beneficiary, assetId);
462 
463         emit Transfer(0x0, beneficiary, assetId);
464     }
465 
466     function _destroy(uint256 assetId) internal {
467         address holder = _holderOf[assetId];
468         require(holder != 0);
469 
470         _removeAssetFrom(holder, assetId);
471 
472         emit Transfer(holder, 0x0, assetId);
473     }
474 
475     //
476     // Transaction related operations
477     //
478 
479     modifier onlyHolder(uint256 assetId) {
480         require(_ownerOf(assetId) == msg.sender, "Not holder");
481         _;
482     }
483 
484     modifier onlyAuthorized(uint256 assetId) {
485         require(_isAuthorized(msg.sender, assetId), "Not authorized");
486         _;
487     }
488 
489     modifier isCurrentOwner(address from, uint256 assetId) {
490         require(_ownerOf(assetId) == from, "Not current owner");
491         _;
492     }
493 
494     /**
495      * @dev Alias of `safeTransferFrom(from, to, assetId, '')`
496      *
497      * @param from address that currently owns an asset
498      * @param to address to receive the ownership of the asset
499      * @param assetId uint256 ID of the asset to be transferred
500      */
501     function safeTransferFrom(address from, address to, uint256 assetId) external {
502         return _doTransferFrom(from, to, assetId, "", true);
503     }
504 
505     /**
506      * @dev Securely transfers the ownership of a given asset from one address to
507      * another address, calling the method `onNFTReceived` on the target address if
508      * there's code associated with it
509      *
510      * @param from address that currently owns an asset
511      * @param to address to receive the ownership of the asset
512      * @param assetId uint256 ID of the asset to be transferred
513      * @param userData bytes arbitrary user information to attach to this transfer
514      */
515     function safeTransferFrom(address from, address to, uint256 assetId, bytes userData) external {
516         return _doTransferFrom(from, to, assetId, userData, true);
517     }
518 
519     /**
520      * @dev Transfers the ownership of a given asset from one address to another address
521      * Warning! This function does not attempt to verify that the target address can send
522      * tokens.
523      *
524      * @param from address sending the asset
525      * @param to address to receive the ownership of the asset
526      * @param assetId uint256 ID of the asset to be transferred
527      */
528     function transferFrom(address from, address to, uint256 assetId) external {
529         return _doTransferFrom(from, to, assetId, "", false);
530     }
531 
532     function _doTransferFrom(
533         address from,
534         address to,
535         uint256 assetId,
536         bytes userData,
537         bool doCheck
538     )
539         onlyAuthorized(assetId)
540         internal
541     {
542         _moveToken(from, to, assetId, userData, doCheck);
543     }
544 
545     function _moveToken(
546         address from,
547         address to,
548         uint256 assetId,
549         bytes userData,
550         bool doCheck
551     )
552         isCurrentOwner(from, assetId)
553         internal
554     {
555         address holder = _holderOf[assetId];
556         _removeAssetFrom(holder, assetId);
557         _clearApproval(holder, assetId);
558         _addAssetTo(to, assetId);
559 
560         if (doCheck && _isContract(to)) {
561             // Equals to bytes4(keccak256("onERC721Received(address,uint256,bytes)"))
562             bytes4 ERC721_RECEIVED = bytes4(0xf0b9e5ba);
563             require(
564                 IERC721Receiver(to).onERC721Received(
565                     holder, assetId, userData
566                 ) == ERC721_RECEIVED
567             , "Contract onERC721Received failed");
568         }
569 
570         emit Transfer(holder, to, assetId);
571     }
572 
573     /**
574      * Internal function that moves an asset from one holder to another
575      */
576 
577     /**
578      * @dev Returns `true` if the contract implements `interfaceID` and `interfaceID` is not 0xffffffff, `false` otherwise
579      * @param    _interfaceID The interface identifier, as specified in ERC-165
580      */
581     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
582 
583         if (_interfaceID == 0xffffffff) {
584             return false;
585         }
586         return _interfaceID == 0x01ffc9a7 || _interfaceID == 0x80ac58cd;
587     }
588 
589     //
590     // Utilities
591     //
592 
593     function _isContract(address addr) internal view returns (bool) {
594         uint size;
595         assembly { size := extcodesize(addr) }
596         return size > 0;
597     }
598 }
599 
600 
601 contract LandMarket {
602     struct Auction {
603         // Auction ID
604         bytes32 id;
605         // Owner of the NFT
606         address seller;
607         // Price (in wei) for the published item
608         uint256 price;
609         // Time when this sale ends
610         uint256 expiresAt;
611     }
612 
613     mapping (uint256 => Auction) public auctionByAssetId;
614     function executeOrder(uint256 assetId, uint256 price) public;
615 }
616 
617 contract Land {
618     function updateLandData(int x, int y, string data) public;
619     function decodeTokenId(uint value) view public returns (int, int);
620     function safeTransferFrom(address from, address to, uint256 assetId) public;
621     function ownerOf(uint256 landID) public view returns (address);
622 }
623 
624 /**
625     @notice The contract is used to handle all the lifetime of a mortgage, uses RCN for the Loan and Decentraland for the parcels. 
626 
627     Implements the Cosigner interface of RCN, and when is tied to a loan it creates a new ERC721 to handle the ownership of the mortgage.
628 
629     When the loan is resolved (paid, pardoned or defaulted), the mortgaged parcel can be recovered. 
630 
631     Uses a token converter to buy the Decentraland parcel with MANA using the RCN tokens received.
632 */
633 contract MortgageManager is Cosigner, ERC721Base, SafeWithdraw, BytesUtils {
634     using SafeMath for uint256;
635 
636     uint256 constant internal PRECISION = (10**18);
637     uint256 constant internal RCN_DECIMALS = 18;
638 
639     bytes32 public constant MANA_CURRENCY = 0x4d414e4100000000000000000000000000000000000000000000000000000000;
640     uint256 public constant REQUIRED_ALLOWANCE = 1000000000 * 10**18;
641 
642     function name() public pure returns (string _name) {
643         _name = "Decentraland RCN Mortgage";
644     }
645 
646     function symbol() public pure returns (string _symbol) {
647         _symbol = "LAND-RCN-Mortgage";
648     }
649 
650     event RequestedMortgage(uint256 _id, address _borrower, address _engine, uint256 _loanId, uint256 _landId, uint256 _deposit, address _tokenConverter);
651     event StartedMortgage(uint256 _id);
652     event CanceledMortgage(address _from, uint256 _id);
653     event PaidMortgage(address _from, uint256 _id);
654     event DefaultedMortgage(uint256 _id);
655     event UpdatedLandData(address _updater, uint256 _parcel, string _data);
656     event SetCreator(address _creator, bool _status);
657 
658     Token public rcn;
659     Token public mana;
660     Land public land;
661     LandMarket public landMarket;
662     
663     constructor(Token _rcn, Token _mana, Land _land, LandMarket _landMarket) public {
664         rcn = _rcn;
665         mana = _mana;
666         land = _land;
667         landMarket = _landMarket;
668         mortgages.length++;
669     }
670 
671     enum Status { Pending, Ongoing, Canceled, Paid, Defaulted }
672 
673     struct Mortgage {
674         address owner;
675         Engine engine;
676         uint256 loanId;
677         uint256 deposit;
678         uint256 landId;
679         uint256 landCost;
680         Status status;
681         // ERC-721
682         TokenConverter tokenConverter;
683     }
684 
685     uint256 internal flagReceiveLand;
686 
687     Mortgage[] public mortgages;
688 
689     mapping(address => bool) public creators;
690 
691     mapping(uint256 => uint256) public mortgageByLandId;
692     mapping(address => mapping(uint256 => uint256)) public loanToLiability;
693 
694     function url() external view returns (string) {
695         return "";
696     }
697 
698     /**
699         @notice Sets a new third party creator
700         
701         The third party creator can request loans for other borrowers. The creator should be a trusted contract, it could potentially take funds.
702     
703         @param creator Address of the creator
704         @param authorized Enables or disables the permission
705 
706         @return true If the operation was executed
707     */
708     function setCreator(address creator, bool authorized) external onlyOwner returns (bool) {
709         emit SetCreator(creator, authorized);
710         creators[creator] = authorized;
711         return true;
712     }
713 
714     /**
715         @notice Returns the cost of the cosigner
716 
717         This cosigner does not have any risk or maintenance cost, so its free.
718 
719         @return 0, because it's free
720     */
721     function cost(address, uint256, bytes, bytes) external view returns (uint256) {
722         return 0;
723     }
724 
725     /**
726         @notice Requests a mortgage with a loan identifier
727 
728         @dev The loan should exist in the designated engine
729 
730         @param engine RCN Engine
731         @param loanIdentifier Identifier of the loan asociated with the mortgage
732         @param deposit MANA to cover part of the cost of the parcel
733         @param landId ID of the parcel to buy with the mortgage
734         @param tokenConverter Token converter used to exchange RCN - MANA
735 
736         @return id The id of the mortgage
737     */
738     function requestMortgage(
739         Engine engine,
740         bytes32 loanIdentifier,
741         uint256 deposit,
742         uint256 landId,
743         TokenConverter tokenConverter
744     ) external returns (uint256 id) {
745         return requestMortgageId(engine, engine.identifierToIndex(loanIdentifier), deposit, landId, tokenConverter);
746     }
747 
748     /**
749         @notice Request a mortgage with a loan id
750 
751         @dev The loan should exist in the designated engine
752 
753         @param engine RCN Engine
754         @param loanId Id of the loan asociated with the mortgage
755         @param deposit MANA to cover part of the cost of the parcel
756         @param landId ID of the parcel to buy with the mortgage
757         @param tokenConverter Token converter used to exchange RCN - MANA
758 
759         @return id The id of the mortgage
760     */
761     function requestMortgageId(
762         Engine engine,
763         uint256 loanId,
764         uint256 deposit,
765         uint256 landId,
766         TokenConverter tokenConverter
767     ) public returns (uint256 id) {
768         // Validate the associated loan
769         require(engine.getCurrency(loanId) == MANA_CURRENCY, "Loan currency is not MANA");
770         address borrower = engine.getBorrower(loanId);
771         require(engine.getStatus(loanId) == Engine.Status.initial, "Loan status is not inital");
772         require(msg.sender == engine.getBorrower(loanId) ||
773                (msg.sender == engine.getCreator(loanId) && creators[msg.sender]),
774             "Creator should be borrower or authorized");
775         require(engine.isApproved(loanId), "Loan is not approved");
776         require(rcn.allowance(borrower, this) >= REQUIRED_ALLOWANCE, "Manager cannot handle borrower's funds");
777         require(tokenConverter != address(0), "Token converter not defined");
778         require(loanToLiability[engine][loanId] == 0, "Liability for loan already exists");
779 
780         // Get the current parcel cost
781         uint256 landCost;
782         (, , landCost, ) = landMarket.auctionByAssetId(landId);
783         uint256 loanAmount = engine.getAmount(loanId);
784 
785         // We expect a 10% extra for convertion losses
786         // the remaining will be sent to the borrower
787         require((loanAmount + deposit) >= ((landCost / 10) * 11), "Not enought total amount");
788 
789         // Pull the deposit and lock the tokens
790         require(mana.transferFrom(msg.sender, this, deposit), "Error pulling mana");
791 
792         // Create the liability
793         id = mortgages.push(Mortgage({
794             owner: borrower,
795             engine: engine,
796             loanId: loanId,
797             deposit: deposit,
798             landId: landId,
799             landCost: landCost,
800             status: Status.Pending,
801             tokenConverter: tokenConverter
802         })) - 1;
803 
804         loanToLiability[engine][loanId] = id;
805 
806         emit RequestedMortgage({
807             _id: id,
808             _borrower: borrower,
809             _engine: engine,
810             _loanId: loanId,
811             _landId: landId,
812             _deposit: deposit,
813             _tokenConverter: tokenConverter
814         });
815     }
816 
817     /**
818         @notice Cancels an existing mortgage
819         @dev The mortgage status should be pending
820         @param id Id of the mortgage
821         @return true If the operation was executed
822 
823     */
824     function cancelMortgage(uint256 id) external returns (bool) {
825         Mortgage storage mortgage = mortgages[id];
826         
827         // Only the owner of the mortgage and if the mortgage is pending
828         require(msg.sender == mortgage.owner, "Only the owner can cancel the mortgage");
829         require(mortgage.status == Status.Pending, "The mortgage is not pending");
830         
831         mortgage.status = Status.Canceled;
832 
833         // Transfer the deposit back to the borrower
834         require(mana.transfer(msg.sender, mortgage.deposit), "Error returning MANA");
835 
836         emit CanceledMortgage(msg.sender, id);
837         return true;
838     }
839 
840     /**
841         @notice Request the cosign of a loan
842 
843         Buys the parcel and locks its ownership until the loan status is resolved.
844         Emits an ERC721 to manage the ownership of the mortgaged property.
845     
846         @param engine Engine of the loan
847         @param index Index of the loan
848         @param data Data with the mortgage id
849         @param oracleData Oracle data to calculate the loan amount
850 
851         @return true If the cosign was performed
852     */
853     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool) {
854         // The first word of the data MUST contain the index of the target mortgage
855         Mortgage storage mortgage = mortgages[uint256(readBytes32(data, 0))];
856         
857         // Validate that the loan matches with the mortgage
858         // and the mortgage is still pending
859         require(mortgage.engine == engine, "Engine does not match");
860         require(mortgage.loanId == index, "Loan id does not match");
861         require(mortgage.status == Status.Pending, "Mortgage is not pending");
862 
863         // Update the status of the mortgage to avoid reentrancy
864         mortgage.status = Status.Ongoing;
865 
866         // Mint mortgage ERC721 Token
867         _generate(uint256(readBytes32(data, 0)), mortgage.owner);
868 
869         // Transfer the amount of the loan in RCN to this contract
870         uint256 loanAmount = convertRate(engine.getOracle(index), engine.getCurrency(index), oracleData, engine.getAmount(index));
871         require(rcn.transferFrom(mortgage.owner, this, loanAmount), "Error pulling RCN from borrower");
872         
873         // Convert the RCN into MANA using the designated
874         // and save the received MANA
875         uint256 boughtMana = convertSafe(mortgage.tokenConverter, rcn, mana, loanAmount);
876         delete mortgage.tokenConverter;
877 
878         // Load the new cost of the parcel, it may be changed
879         uint256 currentLandCost;
880         (, , currentLandCost, ) = landMarket.auctionByAssetId(mortgage.landId);
881         require(currentLandCost <= mortgage.landCost, "Parcel is more expensive than expected");
882         
883         // Buy the land and lock it into the mortgage contract
884         require(mana.approve(landMarket, currentLandCost));
885         flagReceiveLand = mortgage.landId;
886         landMarket.executeOrder(mortgage.landId, currentLandCost);
887         require(mana.approve(landMarket, 0));
888         require(flagReceiveLand == 0, "ERC721 callback not called");
889         require(land.ownerOf(mortgage.landId) == address(this), "Error buying parcel");
890 
891         // Calculate the remaining amount to send to the borrower and 
892         // check that we didn't expend any contract funds.
893         uint256 totalMana = boughtMana.add(mortgage.deposit);        
894 
895         // Return rest of MANA to the owner
896         require(mana.transfer(mortgage.owner, totalMana.sub(currentLandCost)), "Error returning MANA");
897         
898         // Cosign contract, 0 is the RCN required
899         require(mortgage.engine.cosign(index, 0), "Error performing cosign");
900         
901         // Save mortgage id registry
902         mortgageByLandId[mortgage.landId] = uint256(readBytes32(data, 0));
903 
904         // Emit mortgage event
905         emit StartedMortgage(uint256(readBytes32(data, 0)));
906 
907         return true;
908     }
909 
910     /**
911         @notice Converts tokens using a token converter
912         @dev Does not trust the token converter, validates the return amount
913         @param converter Token converter used
914         @param from Tokens to sell
915         @param to Tokens to buy
916         @param amount Amount to sell
917         @return bought Bought amount
918     */
919     function convertSafe(
920         TokenConverter converter,
921         Token from,
922         Token to,
923         uint256 amount
924     ) internal returns (uint256 bought) {
925         require(from.approve(converter, amount));
926         uint256 prevBalance = to.balanceOf(this);
927         bought = converter.convert(from, to, amount, 1);
928         require(to.balanceOf(this).sub(prevBalance) >= bought, "Bought amount incorrect");
929         require(from.approve(converter, 0));
930     }
931 
932     /**
933         @notice Claims the mortgage when the loan status is resolved and transfers the ownership of the parcel to which corresponds.
934 
935         @dev Deletes the mortgage ERC721
936 
937         @param engine RCN Engine
938         @param loanId Loan ID
939         
940         @return true If the claim succeded
941     */
942     function claim(address engine, uint256 loanId, bytes) external returns (bool) {
943         uint256 mortgageId = loanToLiability[engine][loanId];
944         Mortgage storage mortgage = mortgages[mortgageId];
945 
946         // Validate that the mortgage wasn't claimed
947         require(mortgage.status == Status.Ongoing, "Mortgage not ongoing");
948         require(mortgage.loanId == loanId, "Mortgage don't match loan id");
949 
950         if (mortgage.engine.getStatus(loanId) == Engine.Status.paid || mortgage.engine.getStatus(loanId) == Engine.Status.destroyed) {
951             // The mortgage is paid
952             require(_isAuthorized(msg.sender, mortgageId), "Sender not authorized");
953 
954             mortgage.status = Status.Paid;
955             // Transfer the parcel to the borrower
956             land.safeTransferFrom(this, msg.sender, mortgage.landId);
957             emit PaidMortgage(msg.sender, mortgageId);
958         } else if (isDefaulted(mortgage.engine, loanId)) {
959             // The mortgage is defaulted
960             require(msg.sender == mortgage.engine.ownerOf(loanId), "Sender not lender");
961             
962             mortgage.status = Status.Defaulted;
963             // Transfer the parcel to the lender
964             land.safeTransferFrom(this, msg.sender, mortgage.landId);
965             emit DefaultedMortgage(mortgageId);
966         } else {
967             revert("Mortgage not defaulted/paid");
968         }
969 
970         // ERC721 Delete asset
971         _destroy(mortgageId);
972 
973         // Delete mortgage id registry
974         delete mortgageByLandId[mortgage.landId];
975 
976         return true;
977     }
978 
979     /**
980         @notice Defines a custom logic that determines if a loan is defaulted or not.
981 
982         @param engine RCN Engines
983         @param index Index of the loan
984 
985         @return true if the loan is considered defaulted
986     */
987     function isDefaulted(Engine engine, uint256 index) public view returns (bool) {
988         return engine.getStatus(index) == Engine.Status.lent &&
989             engine.getDueTime(index).add(7 days) <= block.timestamp;
990     }
991 
992     /**
993         @dev An alternative version of the ERC721 callback, required by a bug in the parcels contract
994     */
995     function onERC721Received(uint256 _tokenId, address, bytes) external returns (bytes4) {
996         if (msg.sender == address(land) && flagReceiveLand == _tokenId) {
997             flagReceiveLand = 0;
998             return bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
999         }
1000     }
1001 
1002     /**
1003         @notice Callback used to accept the ERC721 parcel tokens
1004 
1005         @dev Only accepts tokens if flag is set to tokenId, resets the flag when called
1006     */
1007     function onERC721Received(address, uint256 _tokenId, bytes) external returns (bytes4) {
1008         if (msg.sender == address(land) && flagReceiveLand == _tokenId) {
1009             flagReceiveLand = 0;
1010             return bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
1011         }
1012     }
1013 
1014     /**
1015         @dev Reads data from a bytes array
1016     */
1017     function getData(uint256 id) public pure returns (bytes o) {
1018         assembly {
1019             o := mload(0x40)
1020             mstore(0x40, add(o, and(add(add(32, 0x20), 0x1f), not(0x1f))))
1021             mstore(o, 32)
1022             mstore(add(o, 32), id)
1023         }
1024     }
1025     
1026     /**
1027         @notice Enables the owner of a parcel to update the data field
1028 
1029         @param id Id of the mortgage
1030         @param data New data
1031 
1032         @return true If data was updated
1033     */
1034     function updateLandData(uint256 id, string data) external returns (bool) {
1035         Mortgage memory mortgage = mortgages[id];
1036         require(_isAuthorized(msg.sender, id), "Sender not authorized");
1037         int256 x;
1038         int256 y;
1039         (x, y) = land.decodeTokenId(mortgage.landId);
1040         land.updateLandData(x, y, data);
1041         emit UpdatedLandData(msg.sender, id, data);
1042         return true;
1043     }
1044 
1045     /**
1046         @dev Replica of the convertRate function of the RCN Engine, used to apply the oracle rate
1047     */
1048     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) internal returns (uint256) {
1049         if (oracle == address(0)) {
1050             return amount;
1051         } else {
1052             uint256 rate;
1053             uint256 decimals;
1054             
1055             (rate, decimals) = oracle.getRate(currency, data);
1056 
1057             require(decimals <= RCN_DECIMALS, "Decimals exceeds max decimals");
1058             return (amount.mult(rate).mult((10**(RCN_DECIMALS-decimals)))) / PRECISION;
1059         }
1060     }
1061 }
1062 
1063 interface NanoLoanEngine {
1064     function createLoan(address _oracleContract, address _borrower, bytes32 _currency, uint256 _amount, uint256 _interestRate,
1065         uint256 _interestRatePunitory, uint256 _duesIn, uint256 _cancelableAt, uint256 _expirationRequest, string _metadata) public returns (uint256);
1066     function getIdentifier(uint256 index) public view returns (bytes32);
1067     function registerApprove(bytes32 identifier, uint8 v, bytes32 r, bytes32 s) public returns (bool);
1068     function pay(uint index, uint256 _amount, address _from, bytes oracleData) public returns (bool);
1069     function rcn() public view returns (Token);
1070     function getOracle(uint256 index) public view returns (Oracle);
1071     function getAmount(uint256 index) public view returns (uint256);
1072     function getCurrency(uint256 index) public view returns (bytes32);
1073     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) public view returns (uint256);
1074     function lend(uint index, bytes oracleData, Cosigner cosigner, bytes cosignerData) public returns (bool);
1075     function transfer(address to, uint256 index) public returns (bool);
1076 }
1077 
1078 /**
1079     @notice Set of functions to operate the mortgage manager in less transactions
1080 */
1081 contract MortgageHelper is Ownable {
1082     using SafeMath for uint256;
1083 
1084     MortgageManager public mortgageManager;
1085     NanoLoanEngine public nanoLoanEngine;
1086     Token public rcn;
1087     Token public mana;
1088     LandMarket public landMarket;
1089     TokenConverter public tokenConverter;
1090     address public converterRamp;
1091 
1092     address public manaOracle;
1093     uint256 public requiredTotal = 110;
1094 
1095     uint256 public rebuyThreshold = 0.001 ether;
1096     uint256 public marginSpend = 100;
1097     uint256 public maxSpend = 100;
1098 
1099     bytes32 public constant MANA_CURRENCY = 0x4d414e4100000000000000000000000000000000000000000000000000000000;
1100 
1101     event NewMortgage(address borrower, uint256 loanId, uint256 landId, uint256 mortgageId);
1102     event PaidLoan(address engine, uint256 loanId, uint256 amount);
1103     event SetConverterRamp(address _prev, address _new);
1104     event SetTokenConverter(address _prev, address _new);
1105     event SetRebuyThreshold(uint256 _prev, uint256 _new);
1106     event SetMarginSpend(uint256 _prev, uint256 _new);
1107     event SetMaxSpend(uint256 _prev, uint256 _new);
1108     event SetRequiredTotal(uint256 _prev, uint256 _new);
1109 
1110     constructor(
1111         MortgageManager _mortgageManager,
1112         NanoLoanEngine _nanoLoanEngine,
1113         Token _rcn,
1114         Token _mana,
1115         LandMarket _landMarket,
1116         address _manaOracle,
1117         TokenConverter _tokenConverter,
1118         address _converterRamp
1119     ) public {
1120         mortgageManager = _mortgageManager;
1121         nanoLoanEngine = _nanoLoanEngine;
1122         rcn = _rcn;
1123         mana = _mana;
1124         landMarket = _landMarket;
1125         manaOracle = _manaOracle;
1126         tokenConverter = _tokenConverter;
1127         converterRamp = _converterRamp;
1128 
1129         emit SetConverterRamp(converterRamp, _converterRamp);
1130         emit SetTokenConverter(tokenConverter, _tokenConverter);
1131     }
1132 
1133     /**
1134         @dev Creates a loan using an array of parameters
1135 
1136         @param params 0 - Ammount
1137                       1 - Interest rate
1138                       2 - Interest rate punitory
1139                       3 - Dues in
1140                       4 - Cancelable at
1141                       5 - Expiration of request
1142 
1143         @param metadata Loan metadata
1144 
1145         @return Id of the loan
1146 
1147     */
1148     function createLoan(uint256[6] memory params, string metadata) internal returns (uint256) {
1149         return nanoLoanEngine.createLoan(
1150             manaOracle,
1151             msg.sender,
1152             MANA_CURRENCY,
1153             params[0],
1154             params[1],
1155             params[2],
1156             params[3],
1157             params[4],
1158             params[5],
1159             metadata
1160         );
1161     }
1162 
1163     /**
1164         @notice Sets a max amount to expend when performing the payment
1165         @dev Only owner
1166         @param _maxSpend New maxSPend value
1167         @return true If the change was made
1168     */
1169     function setMaxSpend(uint256 _maxSpend) external onlyOwner returns (bool) {
1170         emit SetMaxSpend(maxSpend, _maxSpend);
1171         maxSpend = _maxSpend;
1172         return true;
1173     }
1174 
1175     /**
1176         @notice Sets required total of the mortgage
1177         @dev Only owner
1178         @param _requiredTotal New requiredTotal value
1179         @return true If the change was made
1180     */
1181     function setRequiredTotal(uint256 _requiredTotal) external onlyOwner returns (bool) {
1182         emit SetRequiredTotal(requiredTotal, _requiredTotal);
1183         requiredTotal = _requiredTotal;
1184         return true;
1185     }
1186 
1187 
1188     /**
1189         @notice Sets a new converter ramp to delegate the pay of the loan
1190         @dev Only owner
1191         @param _converterRamp Address of the converter ramp contract
1192         @return true If the change was made
1193     */
1194     function setConverterRamp(address _converterRamp) external onlyOwner returns (bool) {
1195         emit SetConverterRamp(converterRamp, _converterRamp);
1196         converterRamp = _converterRamp;
1197         return true;
1198     }
1199 
1200     /**
1201         @notice Sets a new min of tokens to rebuy when paying a loan
1202         @dev Only owner
1203         @param _rebuyThreshold New rebuyThreshold value
1204         @return true If the change was made
1205     */
1206     function setRebuyThreshold(uint256 _rebuyThreshold) external onlyOwner returns (bool) {
1207         emit SetRebuyThreshold(rebuyThreshold, _rebuyThreshold);
1208         rebuyThreshold = _rebuyThreshold;
1209         return true;
1210     }
1211 
1212     /**
1213         @notice Sets how much the converter ramp is going to oversell to cover fees and gaps
1214         @dev Only owner
1215         @param _marginSpend New marginSpend value
1216         @return true If the change was made
1217     */
1218     function setMarginSpend(uint256 _marginSpend) external onlyOwner returns (bool) {
1219         emit SetMarginSpend(marginSpend, _marginSpend);
1220         marginSpend = _marginSpend;
1221         return true;
1222     }
1223 
1224     /**
1225         @notice Sets the token converter used to convert the MANA into RCN when performing the payment
1226         @dev Only owner
1227         @param _tokenConverter Address of the tokenConverter contract
1228         @return true If the change was made
1229     */
1230     function setTokenConverter(TokenConverter _tokenConverter) external onlyOwner returns (bool) {
1231         emit SetTokenConverter(tokenConverter, _tokenConverter);
1232         tokenConverter = _tokenConverter;
1233         return true;
1234     }
1235 
1236     /**
1237         @notice Request a loan and attachs a mortgage request
1238 
1239         @dev Requires the loan signed by the borrower
1240 
1241         @param loanParams   0 - Ammount
1242                             1 - Interest rate
1243                             2 - Interest rate punitory
1244                             3 - Dues in
1245                             4 - Cancelable at
1246                             5 - Expiration of request
1247         @param metadata Loan metadata
1248         @param landId Land to buy with the mortgage
1249         @param v Loan signature by the borrower
1250         @param r Loan signature by the borrower
1251         @param s Loan signature by the borrower
1252 
1253         @return The id of the mortgage
1254     */
1255     function requestMortgage(
1256         uint256[6] loanParams,
1257         string metadata,
1258         uint256 landId,
1259         uint8 v,
1260         bytes32 r,
1261         bytes32 s
1262     ) external returns (uint256) {
1263         // Create a loan with the loanParams and metadata
1264         uint256 loanId = createLoan(loanParams, metadata);
1265 
1266         // Approve the created loan with the provided signature
1267         require(nanoLoanEngine.registerApprove(nanoLoanEngine.getIdentifier(loanId), v, r, s), "Signature not valid");
1268 
1269         // Calculate the requested amount for the mortgage deposit
1270         uint256 landCost;
1271         (, , landCost, ) = landMarket.auctionByAssetId(landId);
1272         uint256 requiredDeposit = ((landCost * requiredTotal) / 100) - nanoLoanEngine.getAmount(loanId);
1273         
1274         // Pull the required deposit amount
1275         require(mana.transferFrom(msg.sender, this, requiredDeposit), "Error pulling MANA");
1276         require(mana.approve(mortgageManager, requiredDeposit));
1277 
1278         // Create the mortgage request
1279         uint256 mortgageId = mortgageManager.requestMortgageId(Engine(nanoLoanEngine), loanId, requiredDeposit, landId, tokenConverter);
1280         emit NewMortgage(msg.sender, loanId, landId, mortgageId);
1281         
1282         return mortgageId;
1283     }
1284 
1285     /**
1286         @notice Pays a loan using mana
1287 
1288         @dev The amount to pay must be set on mana
1289 
1290         @param engine RCN Engine
1291         @param loan Loan id to pay
1292         @param amount Amount in MANA to pay
1293 
1294         @return True if the payment was performed
1295     */
1296     function pay(address engine, uint256 loan, uint256 amount) external returns (bool) {
1297         emit PaidLoan(engine, loan, amount);
1298 
1299         bytes32[4] memory loanParams = [
1300             bytes32(engine),
1301             bytes32(loan),
1302             bytes32(amount),
1303             bytes32(msg.sender)
1304         ];
1305 
1306         uint256[3] memory converterParams = [
1307             marginSpend,
1308             amount.mult(uint256(100000).add(maxSpend)) / 100000,
1309             rebuyThreshold
1310         ];
1311 
1312         require(address(converterRamp).delegatecall(
1313             bytes4(0x86ee863d),
1314             address(tokenConverter),
1315             address(mana),
1316             loanParams,
1317             0x140,
1318             converterParams,
1319             0x0
1320         ), "Error delegate pay call");
1321     }
1322 }