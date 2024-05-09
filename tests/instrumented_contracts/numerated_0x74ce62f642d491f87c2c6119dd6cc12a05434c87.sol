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
209     function withdrawTokens(Token token, address to, uint256 amountOrId) external onlyOwner returns (bool) {
210         require(to != address(0));
211         return token.transfer(to, amountOrId);
212     }
213     
214     function withdrawErc721(ERC721Base token, address to, uint256 amountOrId) external onlyOwner returns (bool) {
215         require(to != address(0));
216         token.transferFrom(this, to, amountOrId);
217     }
218     
219     function withdrawEth(address to, uint256 amount) external onlyOwner returns (bool) {
220         return to.send(amount);
221     }
222 }
223 
224 contract BytesUtils {
225     function readBytes32(bytes data, uint256 index) internal pure returns (bytes32 o) {
226         require(data.length / 32 > index);
227         assembly {
228             o := mload(add(data, add(32, mul(32, index))))
229         }
230     }
231 }
232 
233 contract TokenConverter {
234     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
235     function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);
236     function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);
237 }
238 
239 contract ERC721Base {
240     using SafeMath for uint256;
241 
242     uint256 private _count;
243 
244     mapping(uint256 => address) private _holderOf;
245     mapping(address => uint256[]) private _assetsOf;
246     mapping(address => mapping(address => bool)) private _operators;
247     mapping(uint256 => address) private _approval;
248     mapping(uint256 => uint256) private _indexOfAsset;
249 
250     bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
251     bytes4 internal constant ERC721_RECEIVED_LEGACY = 0xf0b9e5ba;
252 
253     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
254     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
255     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
256 
257     //
258     // Global Getters
259     //
260 
261     /**
262      * @dev Gets the total amount of assets stored by the contract
263      * @return uint256 representing the total amount of assets
264      */
265     function totalSupply() external view returns (uint256) {
266         return _totalSupply();
267     }
268     function _totalSupply() internal view returns (uint256) {
269         return _count;
270     }
271 
272     //
273     // Asset-centric getter functions
274     //
275 
276     /**
277      * @dev Queries what address owns an asset. This method does not throw.
278      * In order to check if the asset exists, use the `exists` function or check if the
279      * return value of this call is `0`.
280      * @return uint256 the assetId
281      */
282     function ownerOf(uint256 assetId) external view returns (address) {
283         return _ownerOf(assetId);
284     }
285     function _ownerOf(uint256 assetId) internal view returns (address) {
286         return _holderOf[assetId];
287     }
288 
289     //
290     // Holder-centric getter functions
291     //
292     /**
293      * @dev Gets the balance of the specified address
294      * @param owner address to query the balance of
295      * @return uint256 representing the amount owned by the passed address
296      */
297     function balanceOf(address owner) external view returns (uint256) {
298         return _balanceOf(owner);
299     }
300     function _balanceOf(address owner) internal view returns (uint256) {
301         return _assetsOf[owner].length;
302     }
303 
304     //
305     // Authorization getters
306     //
307 
308     /**
309      * @dev Query whether an address has been authorized to move any assets on behalf of someone else
310      * @param operator the address that might be authorized
311      * @param assetHolder the address that provided the authorization
312      * @return bool true if the operator has been authorized to move any assets
313      */
314     function isApprovedForAll(address operator, address assetHolder)
315         external view returns (bool)
316     {
317         return _isApprovedForAll(operator, assetHolder);
318     }
319     function _isApprovedForAll(address operator, address assetHolder)
320         internal view returns (bool)
321     {
322         return _operators[assetHolder][operator];
323     }
324 
325     /**
326      * @dev Query what address has been particularly authorized to move an asset
327      * @param assetId the asset to be queried for
328      * @return bool true if the asset has been approved by the holder
329      */
330     function getApprovedAddress(uint256 assetId) external view returns (address) {
331         return _getApprovedAddress(assetId);
332     }
333     function _getApprovedAddress(uint256 assetId) internal view returns (address) {
334         return _approval[assetId];
335     }
336 
337     /**
338      * @dev Query if an operator can move an asset.
339      * @param operator the address that might be authorized
340      * @param assetId the asset that has been `approved` for transfer
341      * @return bool true if the asset has been approved by the holder
342      */
343     function isAuthorized(address operator, uint256 assetId) external view returns (bool) {
344         return _isAuthorized(operator, assetId);
345     }
346     function _isAuthorized(address operator, uint256 assetId) internal view returns (bool)
347     {
348         require(operator != 0, "Operator can't be 0x0");
349         address owner = _ownerOf(assetId);
350         if (operator == owner) {
351             return true;
352         }
353         return _isApprovedForAll(operator, owner) || _getApprovedAddress(assetId) == operator;
354     }
355 
356     //
357     // Authorization
358     //
359 
360     /**
361      * @dev Authorize a third party operator to manage (send) msg.sender's asset
362      * @param operator address to be approved
363      * @param authorized bool set to true to authorize, false to withdraw authorization
364      */
365     function setApprovalForAll(address operator, bool authorized) external {
366         return _setApprovalForAll(operator, authorized);
367     }
368     function _setApprovalForAll(address operator, bool authorized) internal {
369         if (authorized) {
370             _addAuthorization(operator, msg.sender);
371         } else {
372             _clearAuthorization(operator, msg.sender);
373         }
374         emit ApprovalForAll(operator, msg.sender, authorized);
375     }
376 
377     /**
378      * @dev Authorize a third party operator to manage one particular asset
379      * @param operator address to be approved
380      * @param assetId asset to approve
381      */
382     function approve(address operator, uint256 assetId) external {
383         address holder = _ownerOf(assetId);
384         require(msg.sender == holder || _isApprovedForAll(msg.sender, holder), "msg.sender Is not approved");
385         require(operator != holder, "The operator can't be the holder");
386         if (_getApprovedAddress(assetId) != operator) {
387             _approval[assetId] = operator;
388             emit Approval(holder, operator, assetId);
389         }
390     }
391 
392     function _addAuthorization(address operator, address holder) private {
393         _operators[holder][operator] = true;
394     }
395 
396     function _clearAuthorization(address operator, address holder) private {
397         _operators[holder][operator] = false;
398     }
399 
400     //
401     // Internal Operations
402     //
403 
404     function _addAssetTo(address to, uint256 assetId) internal {
405         _holderOf[assetId] = to;
406 
407         uint256 length = _balanceOf(to);
408 
409         _assetsOf[to].push(assetId);
410 
411         _indexOfAsset[assetId] = length;
412 
413         _count = _count.add(1);
414     }
415 
416     function _removeAssetFrom(address from, uint256 assetId) internal {
417         uint256 assetIndex = _indexOfAsset[assetId];
418         uint256 lastAssetIndex = _balanceOf(from).sub(1);
419         uint256 lastAssetId = _assetsOf[from][lastAssetIndex];
420 
421         _holderOf[assetId] = 0;
422 
423         // Insert the last asset into the position previously occupied by the asset to be removed
424         _assetsOf[from][assetIndex] = lastAssetId;
425 
426         // Resize the array
427         _assetsOf[from][lastAssetIndex] = 0;
428         _assetsOf[from].length--;
429 
430         // Remove the array if no more assets are owned to prevent pollution
431         if (_assetsOf[from].length == 0) {
432             delete _assetsOf[from];
433         }
434 
435         // Update the index of positions for the asset
436         _indexOfAsset[assetId] = 0;
437         _indexOfAsset[lastAssetId] = assetIndex;
438 
439         _count = _count.sub(1);
440     }
441 
442     function _clearApproval(address holder, uint256 assetId) internal {
443         if (_ownerOf(assetId) == holder && _approval[assetId] != 0) {
444             _approval[assetId] = 0;
445             emit Approval(holder, 0, assetId);
446         }
447     }
448 
449     //
450     // Supply-altering functions
451     //
452 
453     function _generate(uint256 assetId, address beneficiary) internal {
454         require(_holderOf[assetId] == 0);
455 
456         _addAssetTo(beneficiary, assetId);
457 
458         emit Transfer(0x0, beneficiary, assetId);
459     }
460 
461     function _destroy(uint256 assetId) internal {
462         address holder = _holderOf[assetId];
463         require(holder != 0);
464 
465         _removeAssetFrom(holder, assetId);
466 
467         emit Transfer(holder, 0x0, assetId);
468     }
469 
470     //
471     // Transaction related operations
472     //
473 
474     modifier onlyHolder(uint256 assetId) {
475         require(_ownerOf(assetId) == msg.sender, "msg.sender is not the holder");
476         _;
477     }
478 
479     modifier onlyAuthorized(uint256 assetId) {
480         require(_isAuthorized(msg.sender, assetId), "msg.sender Not authorized");
481         _;
482     }
483 
484     modifier isCurrentOwner(address from, uint256 assetId) {
485         require(_ownerOf(assetId) == from, "from Is not the current owner");
486         _;
487     }
488 
489     /**
490      * @dev Alias of `safeTransferFrom(from, to, assetId, '')`
491      *
492      * @param from address that currently owns an asset
493      * @param to address to receive the ownership of the asset
494      * @param assetId uint256 ID of the asset to be transferred
495      */
496     function safeTransferFrom(address from, address to, uint256 assetId) external {
497         return _doTransferFrom(from, to, assetId, "", true);
498     }
499 
500     /**
501      * @dev Securely transfers the ownership of a given asset from one address to
502      * another address, calling the method `onNFTReceived` on the target address if
503      * there's code associated with it
504      *
505      * @param from address that currently owns an asset
506      * @param to address to receive the ownership of the asset
507      * @param assetId uint256 ID of the asset to be transferred
508      * @param userData bytes arbitrary user information to attach to this transfer
509      */
510     function safeTransferFrom(address from, address to, uint256 assetId, bytes userData) external {
511         return _doTransferFrom(from, to, assetId, userData, true);
512     }
513 
514     /**
515      * @dev Transfers the ownership of a given asset from one address to another address
516      * Warning! This function does not attempt to verify that the target address can send
517      * tokens.
518      *
519      * @param from address sending the asset
520      * @param to address to receive the ownership of the asset
521      * @param assetId uint256 ID of the asset to be transferred
522      */
523     function transferFrom(address from, address to, uint256 assetId) external {
524         return _doTransferFrom(from, to, assetId, "", false);
525     }
526 
527     function _doTransferFrom(
528         address from,
529         address to,
530         uint256 assetId,
531         bytes userData,
532         bool doCheck
533     )
534         onlyAuthorized(assetId)
535         internal
536     {
537         _moveToken(from, to, assetId, userData, doCheck);
538     }
539 
540     function _moveToken(
541         address from,
542         address to,
543         uint256 assetId,
544         bytes userData,
545         bool doCheck
546     )
547         internal
548         isCurrentOwner(from, assetId)
549     {
550         address holder = _holderOf[assetId];
551         _removeAssetFrom(holder, assetId);
552         _clearApproval(holder, assetId);
553         _addAssetTo(to, assetId);
554 
555         if (doCheck && _isContract(to)) {
556             // Call dest contract
557             uint256 success;
558             bytes32 result;
559             // Perform check with the new safe call
560             // onERC721Received(address,address,uint256,bytes)
561             (success, result) = _noThrowCall(
562                 to,
563                 abi.encodeWithSelector(
564                     ERC721_RECEIVED,
565                     msg.sender,
566                     holder,
567                     assetId,
568                     userData
569                 )
570             );
571 
572             if (success != 1 || result != ERC721_RECEIVED) {
573                 // Try legacy safe call
574                 // onERC721Received(address,uint256,bytes)
575                 (success, result) = _noThrowCall(
576                     to,
577                     abi.encodeWithSelector(
578                         ERC721_RECEIVED_LEGACY,
579                         holder,
580                         assetId,
581                         userData
582                     )
583                 );
584 
585                 require(success == 1 && result == ERC721_RECEIVED_LEGACY, "Token rejected by contract");
586             }
587         }
588 
589         emit Transfer(holder, to, assetId);
590     }
591 
592     /**
593      * Internal function that moves an asset from one holder to another
594      */
595 
596     /**
597      * @dev Returns `true` if the contract implements `interfaceID` and `interfaceID` is not 0xffffffff, `false` otherwise
598      * @param    _interfaceID The interface identifier, as specified in ERC-165
599      */
600     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
601         if (_interfaceID == 0xffffffff) {
602             return false;
603         }
604         return _interfaceID == 0x01ffc9a7 || _interfaceID == 0x80ac58cd;
605     }
606 
607     //
608     // Utilities
609     //
610 
611     function _isContract(address addr) internal view returns (bool) {
612         uint size;
613         assembly { size := extcodesize(addr) }
614         return size > 0;
615     }
616 
617     function _noThrowCall(
618         address _contract,
619         bytes _data
620     ) internal returns (uint256 success, bytes32 result) {
621         assembly {
622             let x := mload(0x40)
623 
624             success := call(
625                             gas,                  // Send all gas
626                             _contract,            // To addr
627                             0,                    // Send ETH
628                             add(0x20, _data),     // Input is data past the first 32 bytes
629                             mload(_data),         // Input size is the lenght of data
630                             x,                    // Store the ouput on x
631                             0x20                  // Output is a single bytes32, has 32 bytes
632                         )
633 
634             result := mload(x)
635         }
636     }
637 }
638 
639 
640 contract LandMarket {
641     struct Auction {
642         // Auction ID
643         bytes32 id;
644         // Owner of the NFT
645         address seller;
646         // Price (in wei) for the published item
647         uint256 price;
648         // Time when this sale ends
649         uint256 expiresAt;
650     }
651 
652     mapping (uint256 => Auction) public auctionByAssetId;
653     function executeOrder(uint256 assetId, uint256 price) public;
654 }
655 
656 contract Land {
657     function updateLandData(int x, int y, string data) public;
658     function decodeTokenId(uint value) view public returns (int, int);
659     function safeTransferFrom(address from, address to, uint256 assetId) public;
660     function ownerOf(uint256 landID) public view returns (address);
661 }
662 
663 /**
664     @notice The contract is used to handle all the lifetime of a mortgage, uses RCN for the Loan and Decentraland for the parcels. 
665 
666     Implements the Cosigner interface of RCN, and when is tied to a loan it creates a new ERC721 to handle the ownership of the mortgage.
667 
668     When the loan is resolved (paid, pardoned or defaulted), the mortgaged parcel can be recovered. 
669 
670     Uses a token converter to buy the Decentraland parcel with MANA using the RCN tokens received.
671 */
672 contract MortgageManager is Cosigner, ERC721Base, SafeWithdraw, BytesUtils {
673     using SafeMath for uint256;
674 
675     uint256 constant internal PRECISION = (10**18);
676     uint256 constant internal RCN_DECIMALS = 18;
677 
678     bytes32 public constant MANA_CURRENCY = 0x4d414e4100000000000000000000000000000000000000000000000000000000;
679     uint256 public constant REQUIRED_ALLOWANCE = 1000000000 * 10**18;
680 
681     function name() public pure returns (string _name) {
682         _name = "Decentraland RCN Mortgage";
683     }
684 
685     function symbol() public pure returns (string _symbol) {
686         _symbol = "LAND-RCN-Mortgage";
687     }
688 
689     event RequestedMortgage(uint256 _id, address _borrower, address _engine, uint256 _loanId, uint256 _landId, uint256 _deposit, address _tokenConverter);
690     event StartedMortgage(uint256 _id);
691     event CanceledMortgage(address _from, uint256 _id);
692     event PaidMortgage(address _from, uint256 _id);
693     event DefaultedMortgage(uint256 _id);
694     event UpdatedLandData(address _updater, uint256 _parcel, string _data);
695     event SetCreator(address _creator, bool _status);
696 
697     Token public rcn;
698     Token public mana;
699     Land public land;
700     LandMarket public landMarket;
701     
702     constructor(Token _rcn, Token _mana, Land _land, LandMarket _landMarket) public {
703         rcn = _rcn;
704         mana = _mana;
705         land = _land;
706         landMarket = _landMarket;
707         mortgages.length++;
708     }
709 
710     enum Status { Pending, Ongoing, Canceled, Paid, Defaulted }
711 
712     struct Mortgage {
713         address owner;
714         Engine engine;
715         uint256 loanId;
716         uint256 deposit;
717         uint256 landId;
718         uint256 landCost;
719         Status status;
720         // ERC-721
721         TokenConverter tokenConverter;
722     }
723 
724     uint256 internal flagReceiveLand;
725 
726     Mortgage[] public mortgages;
727 
728     mapping(address => bool) public creators;
729 
730     mapping(uint256 => uint256) public mortgageByLandId;
731     mapping(address => mapping(uint256 => uint256)) public loanToLiability;
732 
733     function url() external view returns (string) {
734         return "";
735     }
736 
737     /**
738         @notice Sets a new third party creator
739         
740         The third party creator can request loans for other borrowers. The creator should be a trusted contract, it could potentially take funds.
741     
742         @param creator Address of the creator
743         @param authorized Enables or disables the permission
744 
745         @return true If the operation was executed
746     */
747     function setCreator(address creator, bool authorized) external onlyOwner returns (bool) {
748         emit SetCreator(creator, authorized);
749         creators[creator] = authorized;
750         return true;
751     }
752 
753     /**
754         @notice Returns the cost of the cosigner
755 
756         This cosigner does not have any risk or maintenance cost, so its free.
757 
758         @return 0, because it's free
759     */
760     function cost(address, uint256, bytes, bytes) external view returns (uint256) {
761         return 0;
762     }
763 
764     /**
765         @notice Requests a mortgage with a loan identifier
766 
767         @dev The loan should exist in the designated engine
768 
769         @param engine RCN Engine
770         @param loanIdentifier Identifier of the loan asociated with the mortgage
771         @param deposit MANA to cover part of the cost of the parcel
772         @param landId ID of the parcel to buy with the mortgage
773         @param tokenConverter Token converter used to exchange RCN - MANA
774 
775         @return id The id of the mortgage
776     */
777     function requestMortgage(
778         Engine engine,
779         bytes32 loanIdentifier,
780         uint256 deposit,
781         uint256 landId,
782         TokenConverter tokenConverter
783     ) external returns (uint256 id) {
784         return requestMortgageId(engine, engine.identifierToIndex(loanIdentifier), deposit, landId, tokenConverter);
785     }
786 
787     /**
788         @notice Request a mortgage with a loan id
789 
790         @dev The loan should exist in the designated engine
791 
792         @param engine RCN Engine
793         @param loanId Id of the loan asociated with the mortgage
794         @param deposit MANA to cover part of the cost of the parcel
795         @param landId ID of the parcel to buy with the mortgage
796         @param tokenConverter Token converter used to exchange RCN - MANA
797 
798         @return id The id of the mortgage
799     */
800     function requestMortgageId(
801         Engine engine,
802         uint256 loanId,
803         uint256 deposit,
804         uint256 landId,
805         TokenConverter tokenConverter
806     ) public returns (uint256 id) {
807         // Validate the associated loan
808         require(engine.getCurrency(loanId) == MANA_CURRENCY, "Loan currency is not MANA");
809         address borrower = engine.getBorrower(loanId);
810         require(engine.getStatus(loanId) == Engine.Status.initial, "Loan status is not inital");
811         require(msg.sender == engine.getBorrower(loanId) ||
812                (msg.sender == engine.getCreator(loanId) && creators[msg.sender]),
813             "Creator should be borrower or authorized");
814         require(engine.isApproved(loanId), "Loan is not approved");
815         require(rcn.allowance(borrower, this) >= REQUIRED_ALLOWANCE, "Manager cannot handle borrower's funds");
816         require(tokenConverter != address(0), "Token converter not defined");
817         require(loanToLiability[engine][loanId] == 0, "Liability for loan already exists");
818 
819         // Get the current parcel cost
820         uint256 landCost;
821         (, , landCost, ) = landMarket.auctionByAssetId(landId);
822         uint256 loanAmount = engine.getAmount(loanId);
823 
824         // We expect a 10% extra for convertion losses
825         // the remaining will be sent to the borrower
826         require((loanAmount + deposit) >= ((landCost / 10) * 11), "Not enought total amount");
827 
828         // Pull the deposit and lock the tokens
829         _tokenTransferFrom(mana, msg.sender, this, deposit);
830 
831         // Create the liability
832         id = mortgages.push(Mortgage({
833             owner: borrower,
834             engine: engine,
835             loanId: loanId,
836             deposit: deposit,
837             landId: landId,
838             landCost: landCost,
839             status: Status.Pending,
840             tokenConverter: tokenConverter
841         })) - 1;
842 
843         loanToLiability[engine][loanId] = id;
844 
845         emit RequestedMortgage({
846             _id: id,
847             _borrower: borrower,
848             _engine: engine,
849             _loanId: loanId,
850             _landId: landId,
851             _deposit: deposit,
852             _tokenConverter: tokenConverter
853         });
854     }
855 
856     /**
857         @notice Cancels an existing mortgage
858         @dev The mortgage status should be pending
859         @param id Id of the mortgage
860         @return true If the operation was executed
861 
862     */
863     function cancelMortgage(uint256 id) external returns (bool) {
864         Mortgage storage mortgage = mortgages[id];
865         
866         // Only the owner of the mortgage and if the mortgage is pending
867         require(msg.sender == mortgage.owner, "Only the owner can cancel the mortgage");
868         require(mortgage.status == Status.Pending, "The mortgage is not pending");
869         
870         mortgage.status = Status.Canceled;
871 
872         // Transfer the deposit back to the borrower
873         require(mana.transfer(msg.sender, mortgage.deposit), "Error returning MANA");
874 
875         emit CanceledMortgage(msg.sender, id);
876         return true;
877     }
878 
879     /**
880         @notice Request the cosign of a loan
881 
882         Buys the parcel and locks its ownership until the loan status is resolved.
883         Emits an ERC721 to manage the ownership of the mortgaged property.
884     
885         @param engine Engine of the loan
886         @param index Index of the loan
887         @param data Data with the mortgage id
888         @param oracleData Oracle data to calculate the loan amount
889 
890         @return true If the cosign was performed
891     */
892     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool) {
893         // The first word of the data MUST contain the index of the target mortgage
894         Mortgage storage mortgage = mortgages[uint256(readBytes32(data, 0))];
895         
896         // Validate that the loan matches with the mortgage
897         // and the mortgage is still pending
898         require(mortgage.engine == engine, "Engine does not match");
899         require(mortgage.loanId == index, "Loan id does not match");
900         require(mortgage.status == Status.Pending, "Mortgage is not pending");
901 
902         // Update the status of the mortgage to avoid reentrancy
903         mortgage.status = Status.Ongoing;
904 
905         // Mint mortgage ERC721 Token
906         _generate(uint256(readBytes32(data, 0)), mortgage.owner);
907 
908         // Transfer the amount of the loan in RCN to this contract
909         uint256 loanAmount = convertRate(engine.getOracle(index), engine.getCurrency(index), oracleData, engine.getAmount(index));
910         require(rcn.transferFrom(mortgage.owner, this, loanAmount), "Error pulling RCN from borrower");
911         
912         // Convert the RCN into MANA using the designated
913         // and save the received MANA
914         uint256 boughtMana = convertSafe(mortgage.tokenConverter, rcn, mana, loanAmount);
915         delete mortgage.tokenConverter;
916 
917         // Load the new cost of the parcel, it may be changed
918         uint256 currentLandCost;
919         (, , currentLandCost, ) = landMarket.auctionByAssetId(mortgage.landId);
920         require(currentLandCost <= mortgage.landCost, "Parcel is more expensive than expected");
921         
922         // Buy the land and lock it into the mortgage contract
923         require(mana.approve(landMarket, currentLandCost));
924         flagReceiveLand = mortgage.landId;
925         landMarket.executeOrder(mortgage.landId, currentLandCost);
926         require(mana.approve(landMarket, 0));
927         require(flagReceiveLand == 0, "ERC721 callback not called");
928         require(land.ownerOf(mortgage.landId) == address(this), "Error buying parcel");
929 
930         // Calculate the remaining amount to send to the borrower and 
931         // check that we didn't expend any contract funds.
932         uint256 totalMana = boughtMana.add(mortgage.deposit);        
933 
934         // Return rest of MANA to the owner
935         require(mana.transfer(mortgage.owner, totalMana.sub(currentLandCost)), "Error returning MANA");
936         
937         // Cosign contract, 0 is the RCN required
938         require(mortgage.engine.cosign(index, 0), "Error performing cosign");
939         
940         // Save mortgage id registry
941         mortgageByLandId[mortgage.landId] = uint256(readBytes32(data, 0));
942 
943         // Emit mortgage event
944         emit StartedMortgage(uint256(readBytes32(data, 0)));
945 
946         return true;
947     }
948 
949     /**
950         @notice Converts tokens using a token converter
951         @dev Does not trust the token converter, validates the return amount
952         @param converter Token converter used
953         @param from Tokens to sell
954         @param to Tokens to buy
955         @param amount Amount to sell
956         @return bought Bought amount
957     */
958     function convertSafe(
959         TokenConverter converter,
960         Token from,
961         Token to,
962         uint256 amount
963     ) internal returns (uint256 bought) {
964         require(from.approve(converter, amount));
965         uint256 prevBalance = to.balanceOf(this);
966         bought = converter.convert(from, to, amount, 1);
967         require(to.balanceOf(this).sub(prevBalance) >= bought, "Bought amount incorrect");
968         require(from.approve(converter, 0));
969     }
970 
971     /**
972         @notice Claims the mortgage when the loan status is resolved and transfers the ownership of the parcel to which corresponds.
973 
974         @dev Deletes the mortgage ERC721
975 
976         @param engine RCN Engine
977         @param loanId Loan ID
978         
979         @return true If the claim succeded
980     */
981     function claim(address engine, uint256 loanId, bytes) external returns (bool) {
982         uint256 mortgageId = loanToLiability[engine][loanId];
983         Mortgage storage mortgage = mortgages[mortgageId];
984 
985         // Validate that the mortgage wasn't claimed
986         require(mortgage.status == Status.Ongoing, "Mortgage not ongoing");
987         require(mortgage.loanId == loanId, "Mortgage don't match loan id");
988 
989         if (mortgage.engine.getStatus(loanId) == Engine.Status.paid || mortgage.engine.getStatus(loanId) == Engine.Status.destroyed) {
990             // The mortgage is paid
991             require(_isAuthorized(msg.sender, mortgageId), "Sender not authorized");
992 
993             mortgage.status = Status.Paid;
994             // Transfer the parcel to the borrower
995             land.safeTransferFrom(this, msg.sender, mortgage.landId);
996             emit PaidMortgage(msg.sender, mortgageId);
997         } else if (isDefaulted(mortgage.engine, loanId)) {
998             // The mortgage is defaulted
999             require(msg.sender == mortgage.engine.ownerOf(loanId), "Sender not lender");
1000             
1001             mortgage.status = Status.Defaulted;
1002             // Transfer the parcel to the lender
1003             land.safeTransferFrom(this, msg.sender, mortgage.landId);
1004             emit DefaultedMortgage(mortgageId);
1005         } else {
1006             revert("Mortgage not defaulted/paid");
1007         }
1008 
1009         // ERC721 Delete asset
1010         _destroy(mortgageId);
1011 
1012         // Delete mortgage id registry
1013         delete mortgageByLandId[mortgage.landId];
1014 
1015         return true;
1016     }
1017 
1018     function _tokenTransferFrom(Token token, address from, address to, uint256 amount) internal {
1019         require(token.balanceOf(from) >= amount, "From balance is not enough");
1020         require(token.allowance(from, address(this)) >= amount, "Allowance is not enough");
1021         require(token.transferFrom(from, to, amount), "Transfer failed");
1022     }
1023 
1024 
1025     /**
1026         @notice Defines a custom logic that determines if a loan is defaulted or not.
1027 
1028         @param engine RCN Engines
1029         @param index Index of the loan
1030 
1031         @return true if the loan is considered defaulted
1032     */
1033     function isDefaulted(Engine engine, uint256 index) public view returns (bool) {
1034         return engine.getStatus(index) == Engine.Status.lent &&
1035             engine.getDueTime(index).add(7 days) <= block.timestamp;
1036     }
1037 
1038     /**
1039         @notice Callback used to accept the ERC721 parcel tokens
1040 
1041         @dev Only accepts tokens if flag is set to tokenId, resets the flag when called
1042     */
1043     function onERC721Received(address, address, uint256 _tokenId, bytes) external returns (bytes4) {
1044         if (msg.sender == address(land) && flagReceiveLand == _tokenId) {
1045             flagReceiveLand = 0;
1046             return ERC721_RECEIVED;
1047         }
1048     }
1049 
1050     /**
1051         @dev Reads data from a bytes array
1052     */
1053     function getData(uint256 id) public pure returns (bytes o) {
1054         assembly {
1055             o := mload(0x40)
1056             mstore(0x40, add(o, and(add(add(32, 0x20), 0x1f), not(0x1f))))
1057             mstore(o, 32)
1058             mstore(add(o, 32), id)
1059         }
1060     }
1061     
1062     /**
1063         @notice Enables the owner of a parcel to update the data field
1064 
1065         @param id Id of the mortgage
1066         @param data New data
1067 
1068         @return true If data was updated
1069     */
1070     function updateLandData(uint256 id, string data) external returns (bool) {
1071         Mortgage memory mortgage = mortgages[id];
1072         require(_isAuthorized(msg.sender, id), "Sender not authorized");
1073         int256 x;
1074         int256 y;
1075         (x, y) = land.decodeTokenId(mortgage.landId);
1076         land.updateLandData(x, y, data);
1077         emit UpdatedLandData(msg.sender, id, data);
1078         return true;
1079     }
1080 
1081     /**
1082         @dev Replica of the convertRate function of the RCN Engine, used to apply the oracle rate
1083     */
1084     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) internal returns (uint256) {
1085         if (oracle == address(0)) {
1086             return amount;
1087         } else {
1088             uint256 rate;
1089             uint256 decimals;
1090             
1091             (rate, decimals) = oracle.getRate(currency, data);
1092 
1093             require(decimals <= RCN_DECIMALS, "Decimals exceeds max decimals");
1094             return (amount.mult(rate).mult((10**(RCN_DECIMALS-decimals)))) / PRECISION;
1095         }
1096     }
1097 }