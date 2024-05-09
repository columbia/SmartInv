1 pragma solidity ^0.4.13;
2 
3 interface FundInterface {
4 
5     // EVENTS
6 
7     event PortfolioContent(address[] assets, uint[] holdings, uint[] prices);
8     event RequestUpdated(uint id);
9     event Redeemed(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
10     event FeesConverted(uint atTimestamp, uint shareQuantityConverted, uint unclaimed);
11     event CalculationUpdate(uint atTimestamp, uint managementFee, uint performanceFee, uint nav, uint sharePrice, uint totalSupply);
12     event ErrorMessage(string errorMessage);
13 
14     // EXTERNAL METHODS
15     // Compliance by Investor
16     function requestInvestment(uint giveQuantity, uint shareQuantity, address investmentAsset) external;
17     function executeRequest(uint requestId) external;
18     function cancelRequest(uint requestId) external;
19     function redeemAllOwnedAssets(uint shareQuantity) external returns (bool);
20     // Administration by Manager
21     function enableInvestment(address[] ofAssets) external;
22     function disableInvestment(address[] ofAssets) external;
23     function shutDown() external;
24 
25     // PUBLIC METHODS
26     function emergencyRedeem(uint shareQuantity, address[] requestedAssets) public returns (bool success);
27     function calcSharePriceAndAllocateFees() public returns (uint);
28 
29 
30     // PUBLIC VIEW METHODS
31     // Get general information
32     function getModules() view returns (address, address, address);
33     function getLastRequestId() view returns (uint);
34     function getManager() view returns (address);
35 
36     // Get accounting information
37     function performCalculations() view returns (uint, uint, uint, uint, uint, uint, uint);
38     function calcSharePrice() view returns (uint);
39 }
40 
41 interface AssetInterface {
42     /*
43      * Implements ERC 20 standard.
44      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
45      * https://github.com/ethereum/EIPs/issues/20
46      *
47      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
48      *  https://github.com/ethereum/EIPs/issues/223
49      */
50 
51     // Events
52     event Approval(address indexed _owner, address indexed _spender, uint _value);
53 
54     // There is no ERC223 compatible Transfer event, with `_data` included.
55 
56     //ERC 223
57     // PUBLIC METHODS
58     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
59 
60     // ERC 20
61     // PUBLIC METHODS
62     function transfer(address _to, uint _value) public returns (bool success);
63     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
64     function approve(address _spender, uint _value) public returns (bool success);
65     // PUBLIC VIEW METHODS
66     function balanceOf(address _owner) view public returns (uint balance);
67     function allowance(address _owner, address _spender) public view returns (uint remaining);
68 }
69 
70 contract ERC20Interface {
71     function totalSupply() public constant returns (uint);
72     function balanceOf(address tokenOwner) public constant returns (uint balance);
73     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
74     function transfer(address to, uint tokens) public returns (bool success);
75     function approve(address spender, uint tokens) public returns (bool success);
76     function transferFrom(address from, address to, uint tokens) public returns (bool success);
77 
78     event Transfer(address indexed from, address indexed to, uint tokens);
79     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
80 }
81 
82 interface SharesInterface {
83 
84     event Created(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
85     event Annihilated(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
86 
87     // VIEW METHODS
88 
89     function getName() view returns (bytes32);
90     function getSymbol() view returns (bytes8);
91     function getDecimals() view returns (uint);
92     function getCreationTime() view returns (uint);
93     function toSmallestShareUnit(uint quantity) view returns (uint);
94     function toWholeShareUnit(uint quantity) view returns (uint);
95 
96 }
97 
98 interface CompetitionInterface {
99 
100     // EVENTS
101 
102     event Register(uint withId, address fund, address manager);
103     event ClaimReward(address registrant, address fund, uint shares);
104 
105     // PRE, POST, INVARIANT CONDITIONS
106 
107     function termsAndConditionsAreSigned(address byManager, uint8 v, bytes32 r, bytes32 s) view returns (bool);
108     function isWhitelisted(address x) view returns (bool);
109     function isCompetitionActive() view returns (bool);
110 
111     // CONSTANT METHODS
112 
113     function getMelonAsset() view returns (address);
114     function getRegistrantId(address x) view returns (uint);
115     function getRegistrantFund(address x) view returns (address);
116     function getCompetitionStatusOfRegistrants() view returns (address[], address[], bool[]);
117     function getTimeTillEnd() view returns (uint);
118     function getEtherValue(uint amount) view returns (uint);
119     function calculatePayout(uint payin) view returns (uint);
120 
121     // PUBLIC METHODS
122 
123     function registerForCompetition(address fund, uint8 v, bytes32 r, bytes32 s) payable;
124     function batchAddToWhitelist(uint maxBuyinQuantity, address[] whitelistants);
125     function withdrawMln(address to, uint amount);
126     function claimReward();
127 
128 }
129 
130 interface ComplianceInterface {
131 
132     // PUBLIC VIEW METHODS
133 
134     /// @notice Checks whether investment is permitted for a participant
135     /// @param ofParticipant Address requesting to invest in a Melon fund
136     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
137     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
138     /// @return Whether identity is eligible to invest in a Melon fund.
139     function isInvestmentPermitted(
140         address ofParticipant,
141         uint256 giveQuantity,
142         uint256 shareQuantity
143     ) view returns (bool);
144 
145     /// @notice Checks whether redemption is permitted for a participant
146     /// @param ofParticipant Address requesting to redeem from a Melon fund
147     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
148     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
149     /// @return Whether identity is eligible to redeem from a Melon fund.
150     function isRedemptionPermitted(
151         address ofParticipant,
152         uint256 shareQuantity,
153         uint256 receiveQuantity
154     ) view returns (bool);
155 }
156 
157 contract DBC {
158 
159     // MODIFIERS
160 
161     modifier pre_cond(bool condition) {
162         require(condition);
163         _;
164     }
165 
166     modifier post_cond(bool condition) {
167         _;
168         assert(condition);
169     }
170 
171     modifier invariant(bool condition) {
172         require(condition);
173         _;
174         assert(condition);
175     }
176 }
177 
178 contract Owned is DBC {
179 
180     // FIELDS
181 
182     address public owner;
183 
184     // NON-CONSTANT METHODS
185 
186     function Owned() { owner = msg.sender; }
187 
188     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
189 
190     // PRE, POST, INVARIANT CONDITIONS
191 
192     function isOwner() internal returns (bool) { return msg.sender == owner; }
193 
194 }
195 
196 contract CompetitionCompliance is ComplianceInterface, DBC, Owned {
197 
198     address public competitionAddress;
199 
200     // CONSTRUCTOR
201 
202     /// @dev Constructor
203     /// @param ofCompetition Address of the competition contract
204     function CompetitionCompliance(address ofCompetition) public {
205         competitionAddress = ofCompetition;
206     }
207 
208     // PUBLIC VIEW METHODS
209 
210     /// @notice Checks whether investment is permitted for a participant
211     /// @param ofParticipant Address requesting to invest in a Melon fund
212     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
213     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
214     /// @return Whether identity is eligible to invest in a Melon fund.
215     function isInvestmentPermitted(
216         address ofParticipant,
217         uint256 giveQuantity,
218         uint256 shareQuantity
219     )
220         view
221         returns (bool)
222     {
223         return competitionAddress == ofParticipant;
224     }
225 
226     /// @notice Checks whether redemption is permitted for a participant
227     /// @param ofParticipant Address requesting to redeem from a Melon fund
228     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
229     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
230     /// @return isEligible Whether identity is eligible to redeem from a Melon fund.
231     function isRedemptionPermitted(
232         address ofParticipant,
233         uint256 shareQuantity,
234         uint256 receiveQuantity
235     )
236         view
237         returns (bool)
238     {
239         return competitionAddress == ofParticipant;
240     }
241 
242     /// @notice Checks whether an address is whitelisted in the competition contract and competition is active
243     /// @param x Address
244     /// @return Whether the address is whitelisted
245     function isCompetitionAllowed(
246         address x
247     )
248         view
249         returns (bool)
250     {
251         return CompetitionInterface(competitionAddress).isWhitelisted(x) && CompetitionInterface(competitionAddress).isCompetitionActive();
252     }
253 
254 
255     // PUBLIC METHODS
256 
257     /// @notice Changes the competition address
258     /// @param ofCompetition Address of the competition contract
259     function changeCompetitionAddress(
260         address ofCompetition
261     )
262         pre_cond(isOwner())
263     {
264         competitionAddress = ofCompetition;
265     }
266 
267 }
268 
269 contract DSAuthority {
270     function canCall(
271         address src, address dst, bytes4 sig
272     ) public view returns (bool);
273 }
274 
275 contract DSAuthEvents {
276     event LogSetAuthority (address indexed authority);
277     event LogSetOwner     (address indexed owner);
278 }
279 
280 contract DSAuth is DSAuthEvents {
281     DSAuthority  public  authority;
282     address      public  owner;
283 
284     function DSAuth() public {
285         owner = msg.sender;
286         LogSetOwner(msg.sender);
287     }
288 
289     function setOwner(address owner_)
290         public
291         auth
292     {
293         owner = owner_;
294         LogSetOwner(owner);
295     }
296 
297     function setAuthority(DSAuthority authority_)
298         public
299         auth
300     {
301         authority = authority_;
302         LogSetAuthority(authority);
303     }
304 
305     modifier auth {
306         require(isAuthorized(msg.sender, msg.sig));
307         _;
308     }
309 
310     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
311         if (src == address(this)) {
312             return true;
313         } else if (src == owner) {
314             return true;
315         } else if (authority == DSAuthority(0)) {
316             return false;
317         } else {
318             return authority.canCall(src, this, sig);
319         }
320     }
321 }
322 
323 contract DSExec {
324     function tryExec( address target, bytes calldata, uint value)
325              internal
326              returns (bool call_ret)
327     {
328         return target.call.value(value)(calldata);
329     }
330     function exec( address target, bytes calldata, uint value)
331              internal
332     {
333         if(!tryExec(target, calldata, value)) {
334             revert();
335         }
336     }
337 
338     // Convenience aliases
339     function exec( address t, bytes c )
340         internal
341     {
342         exec(t, c, 0);
343     }
344     function exec( address t, uint256 v )
345         internal
346     {
347         bytes memory c; exec(t, c, v);
348     }
349     function tryExec( address t, bytes c )
350         internal
351         returns (bool)
352     {
353         return tryExec(t, c, 0);
354     }
355     function tryExec( address t, uint256 v )
356         internal
357         returns (bool)
358     {
359         bytes memory c; return tryExec(t, c, v);
360     }
361 }
362 
363 contract DSMath {
364     function add(uint x, uint y) internal pure returns (uint z) {
365         require((z = x + y) >= x);
366     }
367     function sub(uint x, uint y) internal pure returns (uint z) {
368         require((z = x - y) <= x);
369     }
370     function mul(uint x, uint y) internal pure returns (uint z) {
371         require(y == 0 || (z = x * y) / y == x);
372     }
373 
374     function min(uint x, uint y) internal pure returns (uint z) {
375         return x <= y ? x : y;
376     }
377     function max(uint x, uint y) internal pure returns (uint z) {
378         return x >= y ? x : y;
379     }
380     function imin(int x, int y) internal pure returns (int z) {
381         return x <= y ? x : y;
382     }
383     function imax(int x, int y) internal pure returns (int z) {
384         return x >= y ? x : y;
385     }
386 
387     uint constant WAD = 10 ** 18;
388     uint constant RAY = 10 ** 27;
389 
390     function wmul(uint x, uint y) internal pure returns (uint z) {
391         z = add(mul(x, y), WAD / 2) / WAD;
392     }
393     function rmul(uint x, uint y) internal pure returns (uint z) {
394         z = add(mul(x, y), RAY / 2) / RAY;
395     }
396     function wdiv(uint x, uint y) internal pure returns (uint z) {
397         z = add(mul(x, WAD), y / 2) / y;
398     }
399     function rdiv(uint x, uint y) internal pure returns (uint z) {
400         z = add(mul(x, RAY), y / 2) / y;
401     }
402 
403     // This famous algorithm is called "exponentiation by squaring"
404     // and calculates x^n with x as fixed-point and n as regular unsigned.
405     //
406     // It's O(log n), instead of O(n) for naive repeated multiplication.
407     //
408     // These facts are why it works:
409     //
410     //  If n is even, then x^n = (x^2)^(n/2).
411     //  If n is odd,  then x^n = x * x^(n-1),
412     //   and applying the equation for even x gives
413     //    x^n = x * (x^2)^((n-1) / 2).
414     //
415     //  Also, EVM division is flooring and
416     //    floor[(n-1) / 2] = floor[n / 2].
417     //
418     function rpow(uint x, uint n) internal pure returns (uint z) {
419         z = n % 2 != 0 ? x : RAY;
420 
421         for (n /= 2; n != 0; n /= 2) {
422             x = rmul(x, x);
423 
424             if (n % 2 != 0) {
425                 z = rmul(z, x);
426             }
427         }
428     }
429 }
430 
431 contract Asset is DSMath, ERC20Interface {
432 
433     // DATA STRUCTURES
434 
435     mapping (address => uint) balances;
436     mapping (address => mapping (address => uint)) allowed;
437     uint public _totalSupply;
438 
439     // PUBLIC METHODS
440 
441     /**
442      * @notice Send `_value` tokens to `_to` from `msg.sender`
443      * @dev Transfers sender's tokens to a given address
444      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
445      * @param _to Address of token receiver
446      * @param _value Number of tokens to transfer
447      * @return Returns success of function call
448      */
449     function transfer(address _to, uint _value)
450         public
451         returns (bool success)
452     {
453         require(balances[msg.sender] >= _value); // sanity checks
454         require(balances[_to] + _value >= balances[_to]);
455 
456         balances[msg.sender] = sub(balances[msg.sender], _value);
457         balances[_to] = add(balances[_to], _value);
458         emit Transfer(msg.sender, _to, _value);
459         return true;
460     }
461     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
462     /// @notice Restriction: An account can only use this function to send to itself
463     /// @dev Allows for an approved third party to transfer tokens from one
464     /// address to another. Returns success.
465     /// @param _from Address from where tokens are withdrawn.
466     /// @param _to Address to where tokens are sent.
467     /// @param _value Number of tokens to transfer.
468     /// @return Returns success of function call.
469     function transferFrom(address _from, address _to, uint _value)
470         public
471         returns (bool)
472     {
473         require(_from != address(0));
474         require(_to != address(0));
475         require(_to != address(this));
476         require(balances[_from] >= _value);
477         require(allowed[_from][msg.sender] >= _value);
478         require(balances[_to] + _value >= balances[_to]);
479         // require(_to == msg.sender); // can only use transferFrom to send to self
480 
481         balances[_to] += _value;
482         balances[_from] -= _value;
483         allowed[_from][msg.sender] -= _value;
484 
485         emit Transfer(_from, _to, _value);
486         return true;
487     }
488 
489     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
490     /// @dev Sets approved amount of tokens for spender. Returns success.
491     /// @param _spender Address of allowed account.
492     /// @param _value Number of approved tokens.
493     /// @return Returns success of function call.
494     function approve(address _spender, uint _value) public returns (bool) {
495         require(_spender != address(0));
496 
497         allowed[msg.sender][_spender] = _value;
498         emit Approval(msg.sender, _spender, _value);
499         return true;
500     }
501 
502     // PUBLIC VIEW METHODS
503 
504     /// @dev Returns number of allowed tokens that a spender can transfer on
505     /// behalf of a token owner.
506     /// @param _owner Address of token owner.
507     /// @param _spender Address of token spender.
508     /// @return Returns remaining allowance for spender.
509     function allowance(address _owner, address _spender)
510         constant
511         public
512         returns (uint)
513     {
514         return allowed[_owner][_spender];
515     }
516 
517     /// @dev Returns number of tokens owned by the given address.
518     /// @param _owner Address of token owner.
519     /// @return Returns balance of owner.
520     function balanceOf(address _owner) constant public returns (uint) {
521         return balances[_owner];
522     }
523 
524     function totalSupply() view public returns (uint) {
525         return _totalSupply;
526     }
527 }
528 
529 contract Shares is SharesInterface, Asset {
530 
531     // FIELDS
532 
533     // Constructor fields
534     bytes32 public name;
535     bytes8 public symbol;
536     uint public decimal;
537     uint public creationTime;
538 
539     // METHODS
540 
541     // CONSTRUCTOR
542 
543     /// @param _name Name these shares
544     /// @param _symbol Symbol of shares
545     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
546     /// @param _creationTime Timestamp of share creation
547     function Shares(bytes32 _name, bytes8 _symbol, uint _decimal, uint _creationTime) {
548         name = _name;
549         symbol = _symbol;
550         decimal = _decimal;
551         creationTime = _creationTime;
552     }
553 
554     // PUBLIC METHODS
555 
556     /**
557      * @notice Send `_value` tokens to `_to` from `msg.sender`
558      * @dev Transfers sender's tokens to a given address
559      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
560      * @param _to Address of token receiver
561      * @param _value Number of tokens to transfer
562      * @return Returns success of function call
563      */
564     function transfer(address _to, uint _value)
565         public
566         returns (bool success)
567     {
568         require(balances[msg.sender] >= _value); // sanity checks
569         require(balances[_to] + _value >= balances[_to]);
570 
571         balances[msg.sender] = sub(balances[msg.sender], _value);
572         balances[_to] = add(balances[_to], _value);
573         emit Transfer(msg.sender, _to, _value);
574         return true;
575     }
576 
577     // PUBLIC VIEW METHODS
578 
579     function getName() view returns (bytes32) { return name; }
580     function getSymbol() view returns (bytes8) { return symbol; }
581     function getDecimals() view returns (uint) { return decimal; }
582     function getCreationTime() view returns (uint) { return creationTime; }
583     function toSmallestShareUnit(uint quantity) view returns (uint) { return mul(quantity, 10 ** getDecimals()); }
584     function toWholeShareUnit(uint quantity) view returns (uint) { return quantity / (10 ** getDecimals()); }
585 
586     // INTERNAL METHODS
587 
588     /// @param recipient Address the new shares should be sent to
589     /// @param shareQuantity Number of shares to be created
590     function createShares(address recipient, uint shareQuantity) internal {
591         _totalSupply = add(_totalSupply, shareQuantity);
592         balances[recipient] = add(balances[recipient], shareQuantity);
593         emit Created(msg.sender, now, shareQuantity);
594         emit Transfer(address(0), recipient, shareQuantity);
595     }
596 
597     /// @param recipient Address the new shares should be taken from when destroyed
598     /// @param shareQuantity Number of shares to be annihilated
599     function annihilateShares(address recipient, uint shareQuantity) internal {
600         _totalSupply = sub(_totalSupply, shareQuantity);
601         balances[recipient] = sub(balances[recipient], shareQuantity);
602         emit Annihilated(msg.sender, now, shareQuantity);
603         emit Transfer(recipient, address(0), shareQuantity);
604     }
605 }
606 
607 contract Fund is DSMath, DBC, Owned, Shares, FundInterface {
608 
609     event OrderUpdated(address exchange, bytes32 orderId, UpdateType updateType);
610 
611     // TYPES
612 
613     struct Modules { // Describes all modular parts, standardised through an interface
614         CanonicalPriceFeed pricefeed; // Provides all external data
615         ComplianceInterface compliance; // Boolean functions regarding invest/redeem
616         RiskMgmtInterface riskmgmt; // Boolean functions regarding make/take orders
617     }
618 
619     struct Calculations { // List of internal calculations
620         uint gav; // Gross asset value
621         uint managementFee; // Time based fee
622         uint performanceFee; // Performance based fee measured against QUOTE_ASSET
623         uint unclaimedFees; // Fees not yet allocated to the fund manager
624         uint nav; // Net asset value
625         uint highWaterMark; // A record of best all-time fund performance
626         uint totalSupply; // Total supply of shares
627         uint timestamp; // Time when calculations are performed in seconds
628     }
629 
630     enum UpdateType { make, take, cancel }
631     enum RequestStatus { active, cancelled, executed }
632     struct Request { // Describes and logs whenever asset enter and leave fund due to Participants
633         address participant; // Participant in Melon fund requesting investment or redemption
634         RequestStatus status; // Enum: active, cancelled, executed; Status of request
635         address requestAsset; // Address of the asset being requested
636         uint shareQuantity; // Quantity of Melon fund shares
637         uint giveQuantity; // Quantity in Melon asset to give to Melon fund to receive shareQuantity
638         uint receiveQuantity; // Quantity in Melon asset to receive from Melon fund for given shareQuantity
639         uint timestamp;     // Time of request creation in seconds
640         uint atUpdateId;    // Pricefeed updateId when this request was created
641     }
642 
643     struct Exchange {
644         address exchange;
645         address exchangeAdapter;
646         bool takesCustody;  // exchange takes custody before making order
647     }
648 
649     struct OpenMakeOrder {
650         uint id; // Order Id from exchange
651         uint expiresAt; // Timestamp when the order expires
652     }
653 
654     struct Order { // Describes an order event (make or take order)
655         address exchangeAddress; // address of the exchange this order is on
656         bytes32 orderId; // Id as returned from exchange
657         UpdateType updateType; // Enum: make, take (cancel should be ignored)
658         address makerAsset; // Order maker's asset
659         address takerAsset; // Order taker's asset
660         uint makerQuantity; // Quantity of makerAsset to be traded
661         uint takerQuantity; // Quantity of takerAsset to be traded
662         uint timestamp; // Time of order creation in seconds
663         uint fillTakerQuantity; // Quantity of takerAsset to be filled
664     }
665 
666     // FIELDS
667 
668     // Constant fields
669     uint public constant MAX_FUND_ASSETS = 20; // Max ownable assets by the fund supported by gas limits
670     uint public constant ORDER_EXPIRATION_TIME = 86400; // Make order expiration time (1 day)
671     // Constructor fields
672     uint public MANAGEMENT_FEE_RATE; // Fee rate in QUOTE_ASSET per managed seconds in WAD
673     uint public PERFORMANCE_FEE_RATE; // Fee rate in QUOTE_ASSET per delta improvement in WAD
674     address public VERSION; // Address of Version contract
675     Asset public QUOTE_ASSET; // QUOTE asset as ERC20 contract
676     // Methods fields
677     Modules public modules; // Struct which holds all the initialised module instances
678     Exchange[] public exchanges; // Array containing exchanges this fund supports
679     Calculations public atLastUnclaimedFeeAllocation; // Calculation results at last allocateUnclaimedFees() call
680     Order[] public orders;  // append-only list of makes/takes from this fund
681     mapping (address => mapping(address => OpenMakeOrder)) public exchangesToOpenMakeOrders; // exchangeIndex to: asset to open make orders
682     bool public isShutDown; // Security feature, if yes than investing, managing, allocateUnclaimedFees gets blocked
683     Request[] public requests; // All the requests this fund received from participants
684     mapping (address => bool) public isInvestAllowed; // If false, fund rejects investments from the key asset
685     address[] public ownedAssets; // List of all assets owned by the fund or for which the fund has open make orders
686     mapping (address => bool) public isInAssetList; // Mapping from asset to whether the asset exists in ownedAssets
687     mapping (address => bool) public isInOpenMakeOrder; // Mapping from asset to whether the asset is in a open make order as buy asset
688 
689     // METHODS
690 
691     // CONSTRUCTOR
692 
693     /// @dev Should only be called via Version.setupFund(..)
694     /// @param withName human-readable descriptive name (not necessarily unique)
695     /// @param ofQuoteAsset Asset against which mgmt and performance fee is measured against and which can be used to invest using this single asset
696     /// @param ofManagementFee A time based fee expressed, given in a number which is divided by 1 WAD
697     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 1 WAD
698     /// @param ofCompliance Address of compliance module
699     /// @param ofRiskMgmt Address of risk management module
700     /// @param ofPriceFeed Address of price feed module
701     /// @param ofExchanges Addresses of exchange on which this fund can trade
702     /// @param ofDefaultAssets Addresses of assets to enable invest for (quote asset is already enabled)
703     /// @return Deployed Fund with manager set as ofManager
704     function Fund(
705         address ofManager,
706         bytes32 withName,
707         address ofQuoteAsset,
708         uint ofManagementFee,
709         uint ofPerformanceFee,
710         address ofCompliance,
711         address ofRiskMgmt,
712         address ofPriceFeed,
713         address[] ofExchanges,
714         address[] ofDefaultAssets
715     )
716         Shares(withName, "MLNF", 18, now)
717     {
718         require(ofManagementFee < 10 ** 18); // Require management fee to be less than 100 percent
719         require(ofPerformanceFee < 10 ** 18); // Require performance fee to be less than 100 percent
720         isInvestAllowed[ofQuoteAsset] = true;
721         owner = ofManager;
722         MANAGEMENT_FEE_RATE = ofManagementFee; // 1 percent is expressed as 0.01 * 10 ** 18
723         PERFORMANCE_FEE_RATE = ofPerformanceFee; // 1 percent is expressed as 0.01 * 10 ** 18
724         VERSION = msg.sender;
725         modules.compliance = ComplianceInterface(ofCompliance);
726         modules.riskmgmt = RiskMgmtInterface(ofRiskMgmt);
727         modules.pricefeed = CanonicalPriceFeed(ofPriceFeed);
728         // Bridged to Melon exchange interface by exchangeAdapter library
729         for (uint i = 0; i < ofExchanges.length; ++i) {
730             require(modules.pricefeed.exchangeIsRegistered(ofExchanges[i]));
731             var (ofExchangeAdapter, takesCustody, ) = modules.pricefeed.getExchangeInformation(ofExchanges[i]);
732             exchanges.push(Exchange({
733                 exchange: ofExchanges[i],
734                 exchangeAdapter: ofExchangeAdapter,
735                 takesCustody: takesCustody
736             }));
737         }
738         QUOTE_ASSET = Asset(ofQuoteAsset);
739         // Quote Asset always in owned assets list
740         ownedAssets.push(ofQuoteAsset);
741         isInAssetList[ofQuoteAsset] = true;
742         require(address(QUOTE_ASSET) == modules.pricefeed.getQuoteAsset()); // Sanity check
743         for (uint j = 0; j < ofDefaultAssets.length; j++) {
744             require(modules.pricefeed.assetIsRegistered(ofDefaultAssets[j]));
745             isInvestAllowed[ofDefaultAssets[j]] = true;
746         }
747         atLastUnclaimedFeeAllocation = Calculations({
748             gav: 0,
749             managementFee: 0,
750             performanceFee: 0,
751             unclaimedFees: 0,
752             nav: 0,
753             highWaterMark: 10 ** getDecimals(),
754             totalSupply: _totalSupply,
755             timestamp: now
756         });
757     }
758 
759     // EXTERNAL METHODS
760 
761     // EXTERNAL : ADMINISTRATION
762 
763     /// @notice Enable investment in specified assets
764     /// @param ofAssets Array of assets to enable investment in
765     function enableInvestment(address[] ofAssets)
766         external
767         pre_cond(isOwner())
768     {
769         for (uint i = 0; i < ofAssets.length; ++i) {
770             require(modules.pricefeed.assetIsRegistered(ofAssets[i]));
771             isInvestAllowed[ofAssets[i]] = true;
772         }
773     }
774 
775     /// @notice Disable investment in specified assets
776     /// @param ofAssets Array of assets to disable investment in
777     function disableInvestment(address[] ofAssets)
778         external
779         pre_cond(isOwner())
780     {
781         for (uint i = 0; i < ofAssets.length; ++i) {
782             isInvestAllowed[ofAssets[i]] = false;
783         }
784     }
785 
786     function shutDown() external pre_cond(msg.sender == VERSION) { isShutDown = true; }
787 
788     // EXTERNAL : PARTICIPATION
789 
790     /// @notice Give melon tokens to receive shares of this fund
791     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
792     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
793     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
794     /// @param investmentAsset Address of asset to invest in
795     function requestInvestment(
796         uint giveQuantity,
797         uint shareQuantity,
798         address investmentAsset
799     )
800         external
801         pre_cond(!isShutDown)
802         pre_cond(isInvestAllowed[investmentAsset]) // investment using investmentAsset has not been deactivated by the Manager
803         pre_cond(modules.compliance.isInvestmentPermitted(msg.sender, giveQuantity, shareQuantity))    // Compliance Module: Investment permitted
804     {
805         requests.push(Request({
806             participant: msg.sender,
807             status: RequestStatus.active,
808             requestAsset: investmentAsset,
809             shareQuantity: shareQuantity,
810             giveQuantity: giveQuantity,
811             receiveQuantity: shareQuantity,
812             timestamp: now,
813             atUpdateId: modules.pricefeed.getLastUpdateId()
814         }));
815 
816         emit RequestUpdated(getLastRequestId());
817     }
818 
819     /// @notice Executes active investment and redemption requests, in a way that minimises information advantages of investor
820     /// @dev Distributes melon and shares according to the request
821     /// @param id Index of request to be executed
822     /// @dev Active investment or redemption request executed
823     function executeRequest(uint id)
824         external
825         pre_cond(!isShutDown)
826         pre_cond(requests[id].status == RequestStatus.active)
827         pre_cond(
828             _totalSupply == 0 ||
829             (
830                 now >= add(requests[id].timestamp, modules.pricefeed.getInterval()) &&
831                 modules.pricefeed.getLastUpdateId() >= add(requests[id].atUpdateId, 2)
832             )
833         )   // PriceFeed Module: Wait at least one interval time and two updates before continuing (unless it is the first investment)
834 
835     {
836         Request request = requests[id];
837         var (isRecent, , ) =
838             modules.pricefeed.getPriceInfo(address(request.requestAsset));
839         require(isRecent);
840 
841         // sharePrice quoted in QUOTE_ASSET and multiplied by 10 ** fundDecimals
842         uint costQuantity = toWholeShareUnit(mul(request.shareQuantity, calcSharePriceAndAllocateFees())); // By definition quoteDecimals == fundDecimals
843         if (request.requestAsset != address(QUOTE_ASSET)) {
844             var (isPriceRecent, invertedRequestAssetPrice, requestAssetDecimal) = modules.pricefeed.getInvertedPriceInfo(request.requestAsset);
845             if (!isPriceRecent) {
846                 revert();
847             }
848             costQuantity = mul(costQuantity, invertedRequestAssetPrice) / 10 ** requestAssetDecimal;
849         }
850 
851         if (
852             isInvestAllowed[request.requestAsset] &&
853             costQuantity <= request.giveQuantity
854         ) {
855             request.status = RequestStatus.executed;
856             require(AssetInterface(request.requestAsset).transferFrom(request.participant, address(this), costQuantity)); // Allocate Value
857             createShares(request.participant, request.shareQuantity); // Accounting
858             if (!isInAssetList[request.requestAsset]) {
859                 ownedAssets.push(request.requestAsset);
860                 isInAssetList[request.requestAsset] = true;
861             }
862         } else {
863             revert(); // Invalid Request or invalid giveQuantity / receiveQuantity
864         }
865     }
866 
867     /// @notice Cancels active investment and redemption requests
868     /// @param id Index of request to be executed
869     function cancelRequest(uint id)
870         external
871         pre_cond(requests[id].status == RequestStatus.active) // Request is active
872         pre_cond(requests[id].participant == msg.sender || isShutDown) // Either request creator or fund is shut down
873     {
874         requests[id].status = RequestStatus.cancelled;
875     }
876 
877     /// @notice Redeems by allocating an ownership percentage of each asset to the participant
878     /// @dev Independent of running price feed!
879     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
880     /// @return Whether all assets sent to shareholder or not
881     function redeemAllOwnedAssets(uint shareQuantity)
882         external
883         returns (bool success)
884     {
885         return emergencyRedeem(shareQuantity, ownedAssets);
886     }
887 
888     // EXTERNAL : MANAGING
889 
890     /// @notice Universal method for calling exchange functions through adapters
891     /// @notice See adapter contracts for parameters needed for each exchange
892     /// @param exchangeIndex Index of the exchange in the "exchanges" array
893     /// @param method Signature of the adapter method to call (as per ABI spec)
894     /// @param orderAddresses [0] Order maker
895     /// @param orderAddresses [1] Order taker
896     /// @param orderAddresses [2] Order maker asset
897     /// @param orderAddresses [3] Order taker asset
898     /// @param orderAddresses [4] Fee recipient
899     /// @param orderValues [0] Maker token quantity
900     /// @param orderValues [1] Taker token quantity
901     /// @param orderValues [2] Maker fee
902     /// @param orderValues [3] Taker fee
903     /// @param orderValues [4] Timestamp (seconds)
904     /// @param orderValues [5] Salt/nonce
905     /// @param orderValues [6] Fill amount: amount of taker token to be traded
906     /// @param orderValues [7] Dexy signature mode
907     /// @param identifier Order identifier
908     /// @param v ECDSA recovery id
909     /// @param r ECDSA signature output r
910     /// @param s ECDSA signature output s
911     function callOnExchange(
912         uint exchangeIndex,
913         bytes4 method,
914         address[5] orderAddresses,
915         uint[8] orderValues,
916         bytes32 identifier,
917         uint8 v,
918         bytes32 r,
919         bytes32 s
920     )
921         external
922     {
923         require(
924             modules.pricefeed.exchangeMethodIsAllowed(
925                 exchanges[exchangeIndex].exchange, method
926             )
927         );
928         require(
929             exchanges[exchangeIndex].exchangeAdapter.delegatecall(
930                 method, exchanges[exchangeIndex].exchange,
931                 orderAddresses, orderValues, identifier, v, r, s
932             )
933         );
934     }
935 
936     function addOpenMakeOrder(
937         address ofExchange,
938         address ofSellAsset,
939         uint orderId
940     )
941         pre_cond(msg.sender == address(this))
942     {
943         isInOpenMakeOrder[ofSellAsset] = true;
944         exchangesToOpenMakeOrders[ofExchange][ofSellAsset].id = orderId;
945         exchangesToOpenMakeOrders[ofExchange][ofSellAsset].expiresAt = add(now, ORDER_EXPIRATION_TIME);
946     }
947 
948     function removeOpenMakeOrder(
949         address ofExchange,
950         address ofSellAsset
951     )
952         pre_cond(msg.sender == address(this))
953     {
954         delete exchangesToOpenMakeOrders[ofExchange][ofSellAsset];
955     }
956 
957     function orderUpdateHook(
958         address ofExchange,
959         bytes32 orderId,
960         UpdateType updateType,
961         address[2] orderAddresses, // makerAsset, takerAsset
962         uint[3] orderValues        // makerQuantity, takerQuantity, fillTakerQuantity (take only)
963     )
964         pre_cond(msg.sender == address(this))
965     {
966         // only save make/take
967         if (updateType == UpdateType.make || updateType == UpdateType.take) {
968             orders.push(Order({
969                 exchangeAddress: ofExchange,
970                 orderId: orderId,
971                 updateType: updateType,
972                 makerAsset: orderAddresses[0],
973                 takerAsset: orderAddresses[1],
974                 makerQuantity: orderValues[0],
975                 takerQuantity: orderValues[1],
976                 timestamp: block.timestamp,
977                 fillTakerQuantity: orderValues[2]
978             }));
979         }
980         emit OrderUpdated(ofExchange, orderId, updateType);
981     }
982 
983     // PUBLIC METHODS
984 
985     // PUBLIC METHODS : ACCOUNTING
986 
987     /// @notice Calculates gross asset value of the fund
988     /// @dev Decimals in assets must be equal to decimals in PriceFeed for all entries in AssetRegistrar
989     /// @dev Assumes that module.pricefeed.getPriceInfo(..) returns recent prices
990     /// @return gav Gross asset value quoted in QUOTE_ASSET and multiplied by 10 ** shareDecimals
991     function calcGav() returns (uint gav) {
992         // prices quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
993         uint[] memory allAssetHoldings = new uint[](ownedAssets.length);
994         uint[] memory allAssetPrices = new uint[](ownedAssets.length);
995         address[] memory tempOwnedAssets;
996         tempOwnedAssets = ownedAssets;
997         delete ownedAssets;
998         for (uint i = 0; i < tempOwnedAssets.length; ++i) {
999             address ofAsset = tempOwnedAssets[i];
1000             // assetHoldings formatting: mul(exchangeHoldings, 10 ** assetDecimal)
1001             uint assetHoldings = add(
1002                 uint(AssetInterface(ofAsset).balanceOf(address(this))), // asset base units held by fund
1003                 quantityHeldInCustodyOfExchange(ofAsset)
1004             );
1005             // assetPrice formatting: mul(exchangePrice, 10 ** assetDecimal)
1006             var (isRecent, assetPrice, assetDecimals) = modules.pricefeed.getPriceInfo(ofAsset);
1007             if (!isRecent) {
1008                 revert();
1009             }
1010             allAssetHoldings[i] = assetHoldings;
1011             allAssetPrices[i] = assetPrice;
1012             // gav as sum of mul(assetHoldings, assetPrice) with formatting: mul(mul(exchangeHoldings, exchangePrice), 10 ** shareDecimals)
1013             gav = add(gav, mul(assetHoldings, assetPrice) / (10 ** uint256(assetDecimals)));   // Sum up product of asset holdings of this vault and asset prices
1014             if (assetHoldings != 0 || ofAsset == address(QUOTE_ASSET) || isInOpenMakeOrder[ofAsset]) { // Check if asset holdings is not zero or is address(QUOTE_ASSET) or in open make order
1015                 ownedAssets.push(ofAsset);
1016             } else {
1017                 isInAssetList[ofAsset] = false; // Remove from ownedAssets if asset holdings are zero
1018             }
1019         }
1020         emit PortfolioContent(tempOwnedAssets, allAssetHoldings, allAssetPrices);
1021     }
1022 
1023     /// @notice Add an asset to the list that this fund owns
1024     function addAssetToOwnedAssets (address ofAsset)
1025         public
1026         pre_cond(isOwner() || msg.sender == address(this))
1027     {
1028         isInOpenMakeOrder[ofAsset] = true;
1029         if (!isInAssetList[ofAsset]) {
1030             ownedAssets.push(ofAsset);
1031             isInAssetList[ofAsset] = true;
1032         }
1033     }
1034 
1035     /**
1036     @notice Calculates unclaimed fees of the fund manager
1037     @param gav Gross asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1038     @return {
1039       "managementFees": "A time (seconds) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1040       "performanceFees": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1041       "unclaimedfees": "The sum of both managementfee and performancefee in QUOTE_ASSET and multiplied by 10 ** shareDecimals"
1042     }
1043     */
1044     function calcUnclaimedFees(uint gav)
1045         view
1046         returns (
1047             uint managementFee,
1048             uint performanceFee,
1049             uint unclaimedFees)
1050     {
1051         // Management fee calculation
1052         uint timePassed = sub(now, atLastUnclaimedFeeAllocation.timestamp);
1053         uint gavPercentage = mul(timePassed, gav) / (1 years);
1054         managementFee = wmul(gavPercentage, MANAGEMENT_FEE_RATE);
1055 
1056         // Performance fee calculation
1057         // Handle potential division through zero by defining a default value
1058         uint valuePerShareExclMgmtFees = _totalSupply > 0 ? calcValuePerShare(sub(gav, managementFee), _totalSupply) : toSmallestShareUnit(1);
1059         if (valuePerShareExclMgmtFees > atLastUnclaimedFeeAllocation.highWaterMark) {
1060             uint gainInSharePrice = sub(valuePerShareExclMgmtFees, atLastUnclaimedFeeAllocation.highWaterMark);
1061             uint investmentProfits = wmul(gainInSharePrice, _totalSupply);
1062             performanceFee = wmul(investmentProfits, PERFORMANCE_FEE_RATE);
1063         }
1064 
1065         // Sum of all FEES
1066         unclaimedFees = add(managementFee, performanceFee);
1067     }
1068 
1069     /// @notice Calculates the Net asset value of this fund
1070     /// @param gav Gross asset value of this fund in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1071     /// @param unclaimedFees The sum of both managementFee and performanceFee in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1072     /// @return nav Net asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1073     function calcNav(uint gav, uint unclaimedFees)
1074         view
1075         returns (uint nav)
1076     {
1077         nav = sub(gav, unclaimedFees);
1078     }
1079 
1080     /// @notice Calculates the share price of the fund
1081     /// @dev Convention for valuePerShare (== sharePrice) formatting: mul(totalValue / numShares, 10 ** decimal), to avoid floating numbers
1082     /// @dev Non-zero share supply; value denominated in [base unit of melonAsset]
1083     /// @param totalValue the total value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1084     /// @param numShares the number of shares multiplied by 10 ** shareDecimals
1085     /// @return valuePerShare Share price denominated in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1086     function calcValuePerShare(uint totalValue, uint numShares)
1087         view
1088         pre_cond(numShares > 0)
1089         returns (uint valuePerShare)
1090     {
1091         valuePerShare = toSmallestShareUnit(totalValue) / numShares;
1092     }
1093 
1094     /**
1095     @notice Calculates essential fund metrics
1096     @return {
1097       "gav": "Gross asset value of this fund denominated in [base unit of melonAsset]",
1098       "managementFee": "A time (seconds) based fee",
1099       "performanceFee": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee",
1100       "unclaimedFees": "The sum of both managementFee and performanceFee denominated in [base unit of melonAsset]",
1101       "feesShareQuantity": "The number of shares to be given as fees to the manager",
1102       "nav": "Net asset value denominated in [base unit of melonAsset]",
1103       "sharePrice": "Share price denominated in [base unit of melonAsset]"
1104     }
1105     */
1106     function performCalculations()
1107         view
1108         returns (
1109             uint gav,
1110             uint managementFee,
1111             uint performanceFee,
1112             uint unclaimedFees,
1113             uint feesShareQuantity,
1114             uint nav,
1115             uint sharePrice
1116         )
1117     {
1118         gav = calcGav(); // Reflects value independent of fees
1119         (managementFee, performanceFee, unclaimedFees) = calcUnclaimedFees(gav);
1120         nav = calcNav(gav, unclaimedFees);
1121 
1122         // The value of unclaimedFees measured in shares of this fund at current value
1123         feesShareQuantity = (gav == 0) ? 0 : mul(_totalSupply, unclaimedFees) / gav;
1124         // The total share supply including the value of unclaimedFees, measured in shares of this fund
1125         uint totalSupplyAccountingForFees = add(_totalSupply, feesShareQuantity);
1126         sharePrice = _totalSupply > 0 ? calcValuePerShare(gav, totalSupplyAccountingForFees) : toSmallestShareUnit(1); // Handle potential division through zero by defining a default value
1127     }
1128 
1129     /// @notice Converts unclaimed fees of the manager into fund shares
1130     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1131     function calcSharePriceAndAllocateFees() public returns (uint)
1132     {
1133         var (
1134             gav,
1135             managementFee,
1136             performanceFee,
1137             unclaimedFees,
1138             feesShareQuantity,
1139             nav,
1140             sharePrice
1141         ) = performCalculations();
1142 
1143         createShares(owner, feesShareQuantity); // Updates _totalSupply by creating shares allocated to manager
1144 
1145         // Update Calculations
1146         uint highWaterMark = atLastUnclaimedFeeAllocation.highWaterMark >= sharePrice ? atLastUnclaimedFeeAllocation.highWaterMark : sharePrice;
1147         atLastUnclaimedFeeAllocation = Calculations({
1148             gav: gav,
1149             managementFee: managementFee,
1150             performanceFee: performanceFee,
1151             unclaimedFees: unclaimedFees,
1152             nav: nav,
1153             highWaterMark: highWaterMark,
1154             totalSupply: _totalSupply,
1155             timestamp: now
1156         });
1157 
1158         emit FeesConverted(now, feesShareQuantity, unclaimedFees);
1159         emit CalculationUpdate(now, managementFee, performanceFee, nav, sharePrice, _totalSupply);
1160 
1161         return sharePrice;
1162     }
1163 
1164     // PUBLIC : REDEEMING
1165 
1166     /// @notice Redeems by allocating an ownership percentage only of requestedAssets to the participant
1167     /// @dev This works, but with loops, so only up to a certain number of assets (right now the max is 4)
1168     /// @dev Independent of running price feed! Note: if requestedAssets != ownedAssets then participant misses out on some owned value
1169     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for a slice of assets
1170     /// @param requestedAssets List of addresses that consitute a subset of ownedAssets.
1171     /// @return Whether all assets sent to shareholder or not
1172     function emergencyRedeem(uint shareQuantity, address[] requestedAssets)
1173         public
1174         pre_cond(balances[msg.sender] >= shareQuantity)  // sender owns enough shares
1175         returns (bool)
1176     {
1177         address ofAsset;
1178         uint[] memory ownershipQuantities = new uint[](requestedAssets.length);
1179         address[] memory redeemedAssets = new address[](requestedAssets.length);
1180 
1181         // Check whether enough assets held by fund
1182         for (uint i = 0; i < requestedAssets.length; ++i) {
1183             ofAsset = requestedAssets[i];
1184             require(isInAssetList[ofAsset]);
1185             for (uint j = 0; j < redeemedAssets.length; j++) {
1186                 if (ofAsset == redeemedAssets[j]) {
1187                     revert();
1188                 }
1189             }
1190             redeemedAssets[i] = ofAsset;
1191             uint assetHoldings = add(
1192                 uint(AssetInterface(ofAsset).balanceOf(address(this))),
1193                 quantityHeldInCustodyOfExchange(ofAsset)
1194             );
1195 
1196             if (assetHoldings == 0) continue;
1197 
1198             // participant's ownership percentage of asset holdings
1199             ownershipQuantities[i] = mul(assetHoldings, shareQuantity) / _totalSupply;
1200 
1201             // CRITICAL ERR: Not enough fund asset balance for owed ownershipQuantitiy, eg in case of unreturned asset quantity at address(exchanges[i].exchange) address
1202             if (uint(AssetInterface(ofAsset).balanceOf(address(this))) < ownershipQuantities[i]) {
1203                 isShutDown = true;
1204                 emit ErrorMessage("CRITICAL ERR: Not enough assetHoldings for owed ownershipQuantitiy");
1205                 return false;
1206             }
1207         }
1208 
1209         // Annihilate shares before external calls to prevent reentrancy
1210         annihilateShares(msg.sender, shareQuantity);
1211 
1212         // Transfer ownershipQuantity of Assets
1213         for (uint k = 0; k < requestedAssets.length; ++k) {
1214             // Failed to send owed ownershipQuantity from fund to participant
1215             ofAsset = requestedAssets[k];
1216             if (ownershipQuantities[k] == 0) {
1217                 continue;
1218             } else if (!AssetInterface(ofAsset).transfer(msg.sender, ownershipQuantities[k])) {
1219                 revert();
1220             }
1221         }
1222         emit Redeemed(msg.sender, now, shareQuantity);
1223         return true;
1224     }
1225 
1226     // PUBLIC : FEES
1227 
1228     /// @dev Quantity of asset held in exchange according to associated order id
1229     /// @param ofAsset Address of asset
1230     /// @return Quantity of input asset held in exchange
1231     function quantityHeldInCustodyOfExchange(address ofAsset) returns (uint) {
1232         uint totalSellQuantity;     // quantity in custody across exchanges
1233         uint totalSellQuantityInApprove; // quantity of asset in approve (allowance) but not custody of exchange
1234         for (uint i; i < exchanges.length; i++) {
1235             if (exchangesToOpenMakeOrders[exchanges[i].exchange][ofAsset].id == 0) {
1236                 continue;
1237             }
1238             var (sellAsset, , sellQuantity, ) = GenericExchangeInterface(exchanges[i].exchangeAdapter).getOrder(exchanges[i].exchange, exchangesToOpenMakeOrders[exchanges[i].exchange][ofAsset].id);
1239             if (sellQuantity == 0) {    // remove id if remaining sell quantity zero (closed)
1240                 delete exchangesToOpenMakeOrders[exchanges[i].exchange][ofAsset];
1241             }
1242             totalSellQuantity = add(totalSellQuantity, sellQuantity);
1243             if (!exchanges[i].takesCustody) {
1244                 totalSellQuantityInApprove += sellQuantity;
1245             }
1246         }
1247         if (totalSellQuantity == 0) {
1248             isInOpenMakeOrder[sellAsset] = false;
1249         }
1250         return sub(totalSellQuantity, totalSellQuantityInApprove); // Since quantity in approve is not actually in custody
1251     }
1252 
1253     // PUBLIC VIEW METHODS
1254 
1255     /// @notice Calculates sharePrice denominated in [base unit of melonAsset]
1256     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1257     function calcSharePrice() view returns (uint sharePrice) {
1258         (, , , , , sharePrice) = performCalculations();
1259         return sharePrice;
1260     }
1261 
1262     function getModules() view returns (address, address, address) {
1263         return (
1264             address(modules.pricefeed),
1265             address(modules.compliance),
1266             address(modules.riskmgmt)
1267         );
1268     }
1269 
1270     function getLastRequestId() view returns (uint) { return requests.length - 1; }
1271     function getLastOrderIndex() view returns (uint) { return orders.length - 1; }
1272     function getManager() view returns (address) { return owner; }
1273     function getOwnedAssetsLength() view returns (uint) { return ownedAssets.length; }
1274     function getExchangeInfo() view returns (address[], address[], bool[]) {
1275         address[] memory ofExchanges = new address[](exchanges.length);
1276         address[] memory ofAdapters = new address[](exchanges.length);
1277         bool[] memory takesCustody = new bool[](exchanges.length);
1278         for (uint i = 0; i < exchanges.length; i++) {
1279             ofExchanges[i] = exchanges[i].exchange;
1280             ofAdapters[i] = exchanges[i].exchangeAdapter;
1281             takesCustody[i] = exchanges[i].takesCustody;
1282         }
1283         return (ofExchanges, ofAdapters, takesCustody);
1284     }
1285     function orderExpired(address ofExchange, address ofAsset) view returns (bool) {
1286         uint expiryTime = exchangesToOpenMakeOrders[ofExchange][ofAsset].expiresAt;
1287         require(expiryTime > 0);
1288         return block.timestamp >= expiryTime;
1289     }
1290     function getOpenOrderInfo(address ofExchange, address ofAsset) view returns (uint, uint) {
1291         OpenMakeOrder order = exchangesToOpenMakeOrders[ofExchange][ofAsset];
1292         return (order.id, order.expiresAt);
1293     }
1294 }
1295 
1296 contract Competition is CompetitionInterface, DSMath, DBC, Owned {
1297 
1298     // TYPES
1299 
1300     struct Registrant {
1301         address fund; // Address of the Melon fund
1302         address registrant; // Manager and registrant of the fund
1303         bool hasSigned; // Whether initial requirements passed and Registrant signed Terms and Conditions;
1304         uint buyinQuantity; // Quantity of buyinAsset spent
1305         uint payoutQuantity; // Quantity of payoutAsset received as prize
1306         bool isRewarded; // Is the Registrant rewarded yet
1307     }
1308 
1309     struct RegistrantId {
1310         uint id; // Actual Registrant Id
1311         bool exists; // Used to check if the mapping exists
1312     }
1313 
1314     // FIELDS
1315 
1316     // Constant fields
1317     // Competition terms and conditions as displayed on https://ipfs.io/ipfs/QmXuUfPi6xeYfuMwpVAughm7GjGUjkbEojhNR8DJqVBBxc
1318     // IPFS hash encoded using http://lenschulwitz.com/base58
1319     bytes public constant TERMS_AND_CONDITIONS = hex"12208E21FD34B8B2409972D30326D840C9D747438A118580D6BA8C0735ED53810491";
1320     uint public MELON_BASE_UNIT = 10 ** 18;
1321     // Constructor fields
1322     address public custodian; // Address of the custodian which holds the funds sent
1323     uint public startTime; // Competition start time in seconds (Temporarily Set)
1324     uint public endTime; // Competition end time in seconds
1325     uint public payoutRate; // Fixed MLN - Ether conversion rate
1326     uint public bonusRate; // Bonus multiplier
1327     uint public totalMaxBuyin; // Limit amount of deposit to participate in competition (Valued in Ether)
1328     uint public currentTotalBuyin; // Total buyin till now
1329     uint public maxRegistrants; // Limit number of participate in competition
1330     uint public prizeMoneyAsset; // Equivalent to payoutAsset
1331     uint public prizeMoneyQuantity; // Total prize money pool
1332     address public MELON_ASSET; // Adresss of Melon asset contract
1333     ERC20Interface public MELON_CONTRACT; // Melon as ERC20 contract
1334     address public COMPETITION_VERSION; // Version contract address
1335 
1336     // Methods fields
1337     Registrant[] public registrants; // List of all registrants, can be externally accessed
1338     mapping (address => address) public registeredFundToRegistrants; // For fund address indexed accessing of registrant addresses
1339     mapping(address => RegistrantId) public registrantToRegistrantIds; // For registrant address indexed accessing of registrant ids
1340     mapping(address => uint) public whitelistantToMaxBuyin; // For registrant address to respective max buyIn cap (Valued in Ether)
1341 
1342     //EVENTS
1343 
1344     event Register(uint withId, address fund, address manager);
1345 
1346     // METHODS
1347 
1348     // CONSTRUCTOR
1349 
1350     function Competition(
1351         address ofMelonAsset,
1352         address ofCompetitionVersion,
1353         address ofCustodian,
1354         uint ofStartTime,
1355         uint ofEndTime,
1356         uint ofPayoutRate,
1357         uint ofTotalMaxBuyin,
1358         uint ofMaxRegistrants
1359     ) {
1360         MELON_ASSET = ofMelonAsset;
1361         MELON_CONTRACT = ERC20Interface(MELON_ASSET);
1362         COMPETITION_VERSION = ofCompetitionVersion;
1363         custodian = ofCustodian;
1364         startTime = ofStartTime;
1365         endTime = ofEndTime;
1366         payoutRate = ofPayoutRate;
1367         totalMaxBuyin = ofTotalMaxBuyin;
1368         maxRegistrants = ofMaxRegistrants;
1369     }
1370 
1371     // PRE, POST, INVARIANT CONDITIONS
1372 
1373     /// @dev Proofs that terms and conditions have been read and understood
1374     /// @param byManager Address of the fund manager, as used in the ipfs-frontend
1375     /// @param v ellipitc curve parameter v
1376     /// @param r ellipitc curve parameter r
1377     /// @param s ellipitc curve parameter s
1378     /// @return Whether or not terms and conditions have been read and understood
1379     function termsAndConditionsAreSigned(address byManager, uint8 v, bytes32 r, bytes32 s) view returns (bool) {
1380         return ecrecover(
1381             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
1382             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
1383             //  it will return rsv (same as geth; where v is [27, 28]).
1384             // Note that if you are using ecrecover, v will be either "00" or "01".
1385             //  As a result, in order to use this value, you will have to parse it to an
1386             //  integer and then add 27. This will result in either a 27 or a 28.
1387             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
1388             keccak256("\x19Ethereum Signed Message:\n34", TERMS_AND_CONDITIONS),
1389             v,
1390             r,
1391             s
1392         ) == byManager; // Has sender signed TERMS_AND_CONDITIONS
1393     }
1394 
1395     /// @dev Whether message sender is KYC verified through CERTIFIER
1396     /// @param x Address to be checked for KYC verification
1397     function isWhitelisted(address x) view returns (bool) { return whitelistantToMaxBuyin[x] > 0; }
1398 
1399     /// @dev Whether the competition is on-going
1400     function isCompetitionActive() view returns (bool) { return now >= startTime && now < endTime; }
1401 
1402     // CONSTANT METHODS
1403 
1404     function getMelonAsset() view returns (address) { return MELON_ASSET; }
1405 
1406     /// @return Get RegistrantId from registrant address
1407     function getRegistrantId(address x) view returns (uint) { return registrantToRegistrantIds[x].id; }
1408 
1409     /// @return Address of the fund registered by the registrant address
1410     function getRegistrantFund(address x) view returns (address) { return registrants[getRegistrantId(x)].fund; }
1411 
1412     /// @return Get time to end of the competition
1413     function getTimeTillEnd() view returns (uint) {
1414         if (now > endTime) {
1415             return 0;
1416         }
1417         return sub(endTime, now);
1418     }
1419 
1420     /// @return Get value of MLN amount in Ether
1421     function getEtherValue(uint amount) view returns (uint) {
1422         address feedAddress = Version(COMPETITION_VERSION).CANONICAL_PRICEFEED();
1423         var (isRecent, price, ) = CanonicalPriceFeed(feedAddress).getPriceInfo(MELON_ASSET);
1424         if (!isRecent) {
1425             revert();
1426         }
1427         return mul(price, amount) / 10 ** 18;
1428     }
1429 
1430     /// @return Calculated payout in MLN with bonus for payin in Ether
1431     function calculatePayout(uint payin) view returns (uint payoutQuantity) {
1432         payoutQuantity = mul(payin, payoutRate) / 10 ** 18;
1433     }
1434 
1435     /**
1436     @notice Returns an array of fund addresses and an associated array of whether competing and whether disqualified
1437     @return {
1438       "fundAddrs": "Array of addresses of Melon Funds",
1439       "fundRegistrants": "Array of addresses of Melon fund managers, as used in the ipfs-frontend",
1440     }
1441     */
1442     function getCompetitionStatusOfRegistrants()
1443         view
1444         returns(
1445             address[],
1446             address[],
1447             bool[]
1448         )
1449     {
1450         address[] memory fundAddrs = new address[](registrants.length);
1451         address[] memory fundRegistrants = new address[](registrants.length);
1452         bool[] memory isRewarded = new bool[](registrants.length);
1453 
1454         for (uint i = 0; i < registrants.length; i++) {
1455             fundAddrs[i] = registrants[i].fund;
1456             fundRegistrants[i] = registrants[i].registrant;
1457             isRewarded[i] = registrants[i].isRewarded;
1458         }
1459         return (fundAddrs, fundRegistrants, isRewarded);
1460     }
1461 
1462     // NON-CONSTANT METHODS
1463 
1464     /// @notice Register to take part in the competition
1465     /// @dev Check if the fund address is actually from the Competition Version
1466     /// @param fund Address of the Melon fund
1467     /// @param v ellipitc curve parameter v
1468     /// @param r ellipitc curve parameter r
1469     /// @param s ellipitc curve parameter s
1470     function registerForCompetition(
1471         address fund,
1472         uint8 v,
1473         bytes32 r,
1474         bytes32 s
1475     )
1476         payable
1477         pre_cond(isCompetitionActive() && !Version(COMPETITION_VERSION).isShutDown())
1478         pre_cond(termsAndConditionsAreSigned(msg.sender, v, r, s) && isWhitelisted(msg.sender))
1479     {
1480         require(registeredFundToRegistrants[fund] == address(0) && registrantToRegistrantIds[msg.sender].exists == false);
1481         require(add(currentTotalBuyin, msg.value) <= totalMaxBuyin && registrants.length < maxRegistrants);
1482         require(msg.value <= whitelistantToMaxBuyin[msg.sender]);
1483         require(Version(COMPETITION_VERSION).getFundByManager(msg.sender) == fund);
1484 
1485         // Calculate Payout Quantity, invest the quantity in registrant's fund
1486         uint payoutQuantity = calculatePayout(msg.value);
1487         registeredFundToRegistrants[fund] = msg.sender;
1488         registrantToRegistrantIds[msg.sender] = RegistrantId({id: registrants.length, exists: true});
1489         currentTotalBuyin = add(currentTotalBuyin, msg.value);
1490         FundInterface fundContract = FundInterface(fund);
1491         MELON_CONTRACT.approve(fund, payoutQuantity);
1492 
1493         // Give payoutRequest MLN in return for msg.value
1494         fundContract.requestInvestment(payoutQuantity, getEtherValue(payoutQuantity), MELON_ASSET);
1495         fundContract.executeRequest(fundContract.getLastRequestId());
1496         custodian.transfer(msg.value);
1497 
1498         // Emit Register event
1499         emit Register(registrants.length, fund, msg.sender);
1500 
1501         registrants.push(Registrant({
1502             fund: fund,
1503             registrant: msg.sender,
1504             hasSigned: true,
1505             buyinQuantity: msg.value,
1506             payoutQuantity: payoutQuantity,
1507             isRewarded: false
1508         }));
1509     }
1510 
1511     /// @notice Add batch addresses to whitelist with set maxBuyinQuantity
1512     /// @dev Only the owner can call this function
1513     /// @param maxBuyinQuantity Quantity of payoutAsset received as prize
1514     /// @param whitelistants Performance of Melon fund at competition endTime; Can be changed for any other comparison metric
1515     function batchAddToWhitelist(
1516         uint maxBuyinQuantity,
1517         address[] whitelistants
1518     )
1519         pre_cond(isOwner())
1520         pre_cond(now < endTime)
1521     {
1522         for (uint i = 0; i < whitelistants.length; ++i) {
1523             whitelistantToMaxBuyin[whitelistants[i]] = maxBuyinQuantity;
1524         }
1525     }
1526 
1527     /// @notice Withdraw MLN
1528     /// @dev Only the owner can call this function
1529     function withdrawMln(address to, uint amount)
1530         pre_cond(isOwner())
1531     {
1532         MELON_CONTRACT.transfer(to, amount);
1533     }
1534 
1535     /// @notice Claim Reward
1536     function claimReward()
1537         pre_cond(getRegistrantFund(msg.sender) != address(0))
1538     {
1539         require(block.timestamp >= endTime || Version(COMPETITION_VERSION).isShutDown());
1540         Registrant registrant  = registrants[getRegistrantId(msg.sender)];
1541         require(registrant.isRewarded == false);
1542         registrant.isRewarded = true;
1543         // Is this safe to assume this or should we transfer all the balance instead?
1544         uint balance = AssetInterface(registrant.fund).balanceOf(address(this));
1545         require(AssetInterface(registrant.fund).transfer(registrant.registrant, balance));
1546 
1547         // Emit ClaimedReward event
1548         emit ClaimReward(msg.sender, registrant.fund, balance);
1549     }
1550 }
1551 
1552 contract DSNote {
1553     event LogNote(
1554         bytes4   indexed  sig,
1555         address  indexed  guy,
1556         bytes32  indexed  foo,
1557         bytes32  indexed  bar,
1558         uint              wad,
1559         bytes             fax
1560     ) anonymous;
1561 
1562     modifier note {
1563         bytes32 foo;
1564         bytes32 bar;
1565 
1566         assembly {
1567             foo := calldataload(4)
1568             bar := calldataload(36)
1569         }
1570 
1571         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
1572 
1573         _;
1574     }
1575 }
1576 
1577 contract DSGroup is DSExec, DSNote {
1578     address[]  public  members;
1579     uint       public  quorum;
1580     uint       public  window;
1581     uint       public  actionCount;
1582 
1583     mapping (uint => Action)                     public  actions;
1584     mapping (uint => mapping (address => bool))  public  confirmedBy;
1585     mapping (address => bool)                    public  isMember;
1586 
1587     // Legacy events
1588     event Proposed   (uint id, bytes calldata);
1589     event Confirmed  (uint id, address member);
1590     event Triggered  (uint id);
1591 
1592     struct Action {
1593         address  target;
1594         bytes    calldata;
1595         uint     value;
1596 
1597         uint     confirmations;
1598         uint     deadline;
1599         bool     triggered;
1600     }
1601 
1602     function DSGroup(
1603         address[]  members_,
1604         uint       quorum_,
1605         uint       window_
1606     ) {
1607         members  = members_;
1608         quorum   = quorum_;
1609         window   = window_;
1610 
1611         for (uint i = 0; i < members.length; i++) {
1612             isMember[members[i]] = true;
1613         }
1614     }
1615 
1616     function memberCount() constant returns (uint) {
1617         return members.length;
1618     }
1619 
1620     function target(uint id) constant returns (address) {
1621         return actions[id].target;
1622     }
1623     function calldata(uint id) constant returns (bytes) {
1624         return actions[id].calldata;
1625     }
1626     function value(uint id) constant returns (uint) {
1627         return actions[id].value;
1628     }
1629 
1630     function confirmations(uint id) constant returns (uint) {
1631         return actions[id].confirmations;
1632     }
1633     function deadline(uint id) constant returns (uint) {
1634         return actions[id].deadline;
1635     }
1636     function triggered(uint id) constant returns (bool) {
1637         return actions[id].triggered;
1638     }
1639 
1640     function confirmed(uint id) constant returns (bool) {
1641         return confirmations(id) >= quorum;
1642     }
1643     function expired(uint id) constant returns (bool) {
1644         return now > deadline(id);
1645     }
1646 
1647     function deposit() note payable {
1648     }
1649 
1650     function propose(
1651         address  target,
1652         bytes    calldata,
1653         uint     value
1654     ) onlyMembers note returns (uint id) {
1655         id = ++actionCount;
1656 
1657         actions[id].target    = target;
1658         actions[id].calldata  = calldata;
1659         actions[id].value     = value;
1660         actions[id].deadline  = now + window;
1661 
1662         Proposed(id, calldata);
1663     }
1664 
1665     function confirm(uint id) onlyMembers onlyActive(id) note {
1666         assert(!confirmedBy[id][msg.sender]);
1667 
1668         confirmedBy[id][msg.sender] = true;
1669         actions[id].confirmations++;
1670 
1671         Confirmed(id, msg.sender);
1672     }
1673 
1674     function trigger(uint id) onlyMembers onlyActive(id) note {
1675         assert(confirmed(id));
1676 
1677         actions[id].triggered = true;
1678         exec(actions[id].target, actions[id].calldata, actions[id].value);
1679 
1680         Triggered(id);
1681     }
1682 
1683     modifier onlyMembers {
1684         assert(isMember[msg.sender]);
1685         _;
1686     }
1687 
1688     modifier onlyActive(uint id) {
1689         assert(!expired(id));
1690         assert(!triggered(id));
1691         _;
1692     }
1693 
1694     //------------------------------------------------------------------
1695     // Legacy functions
1696     //------------------------------------------------------------------
1697 
1698     function getInfo() constant returns (
1699         uint  quorum_,
1700         uint  memberCount,
1701         uint  window_,
1702         uint  actionCount_
1703     ) {
1704         return (quorum, members.length, window, actionCount);
1705     }
1706 
1707     function getActionStatus(uint id) constant returns (
1708         uint     confirmations,
1709         uint     deadline,
1710         bool     triggered,
1711         address  target,
1712         uint     value
1713     ) {
1714         return (
1715             actions[id].confirmations,
1716             actions[id].deadline,
1717             actions[id].triggered,
1718             actions[id].target,
1719             actions[id].value
1720         );
1721     }
1722 }
1723 
1724 contract DSGroupFactory is DSNote {
1725     mapping (address => bool)  public  isGroup;
1726 
1727     function newGroup(
1728         address[]  members,
1729         uint       quorum,
1730         uint       window
1731     ) note returns (DSGroup group) {
1732         group = new DSGroup(members, quorum, window);
1733         isGroup[group] = true;
1734     }
1735 }
1736 
1737 contract DSThing is DSAuth, DSNote, DSMath {
1738 
1739     function S(string s) internal pure returns (bytes4) {
1740         return bytes4(keccak256(s));
1741     }
1742 
1743 }
1744 
1745 interface GenericExchangeInterface {
1746 
1747     // EVENTS
1748 
1749     event OrderUpdated(uint id);
1750 
1751     // METHODS
1752     // EXTERNAL METHODS
1753 
1754     function makeOrder(
1755         address onExchange,
1756         address sellAsset,
1757         address buyAsset,
1758         uint sellQuantity,
1759         uint buyQuantity
1760     ) external returns (uint);
1761     function takeOrder(address onExchange, uint id, uint quantity) external returns (bool);
1762     function cancelOrder(address onExchange, uint id) external returns (bool);
1763 
1764 
1765     // PUBLIC METHODS
1766     // PUBLIC VIEW METHODS
1767 
1768     function isApproveOnly() view returns (bool);
1769     function getLastOrderId(address onExchange) view returns (uint);
1770     function isActive(address onExchange, uint id) view returns (bool);
1771     function getOwner(address onExchange, uint id) view returns (address);
1772     function getOrder(address onExchange, uint id) view returns (address, address, uint, uint);
1773     function getTimestamp(address onExchange, uint id) view returns (uint);
1774 
1775 }
1776 
1777 contract CanonicalRegistrar is DSThing, DBC {
1778 
1779     // TYPES
1780 
1781     struct Asset {
1782         bool exists; // True if asset is registered here
1783         bytes32 name; // Human-readable name of the Asset as in ERC223 token standard
1784         bytes8 symbol; // Human-readable symbol of the Asset as in ERC223 token standard
1785         uint decimals; // Decimal, order of magnitude of precision, of the Asset as in ERC223 token standard
1786         string url; // URL for additional information of Asset
1787         string ipfsHash; // Same as url but for ipfs
1788         address breakIn; // Break in contract on destination chain
1789         address breakOut; // Break out contract on this chain; A way to leave
1790         uint[] standards; // compliance with standards like ERC20, ERC223, ERC777, etc. (the uint is the standard number)
1791         bytes4[] functionSignatures; // Whitelisted function signatures that can be called using `useExternalFunction` in Fund contract. Note: Adhere to a naming convention for `Fund<->Asset` as much as possible. I.e. name same concepts with the same functionSignature.
1792         uint price; // Price of asset quoted against `QUOTE_ASSET` * 10 ** decimals
1793         uint timestamp; // Timestamp of last price update of this asset
1794     }
1795 
1796     struct Exchange {
1797         bool exists;
1798         address adapter; // adapter contract for this exchange
1799         // One-time note: takesCustody is inverse case of isApproveOnly
1800         bool takesCustody; // True in case of exchange implementation which requires  are approved when an order is made instead of transfer
1801         bytes4[] functionSignatures; // Whitelisted function signatures that can be called using `useExternalFunction` in Fund contract. Note: Adhere to a naming convention for `Fund<->ExchangeAdapter` as much as possible. I.e. name same concepts with the same functionSignature.
1802     }
1803     // TODO: populate each field here
1804     // TODO: add whitelistFunction function
1805 
1806     // FIELDS
1807 
1808     // Methods fields
1809     mapping (address => Asset) public assetInformation;
1810     address[] public registeredAssets;
1811 
1812     mapping (address => Exchange) public exchangeInformation;
1813     address[] public registeredExchanges;
1814 
1815     // METHODS
1816 
1817     // PUBLIC METHODS
1818 
1819     /// @notice Registers an Asset information entry
1820     /// @dev Pre: Only registrar owner should be able to register
1821     /// @dev Post: Address ofAsset is registered
1822     /// @param ofAsset Address of asset to be registered
1823     /// @param inputName Human-readable name of the Asset as in ERC223 token standard
1824     /// @param inputSymbol Human-readable symbol of the Asset as in ERC223 token standard
1825     /// @param inputDecimals Human-readable symbol of the Asset as in ERC223 token standard
1826     /// @param inputUrl Url for extended information of the asset
1827     /// @param inputIpfsHash Same as url but for ipfs
1828     /// @param breakInBreakOut Address of break in and break out contracts on destination chain
1829     /// @param inputStandards Integers of EIP standards this asset adheres to
1830     /// @param inputFunctionSignatures Function signatures for whitelisted asset functions
1831     function registerAsset(
1832         address ofAsset,
1833         bytes32 inputName,
1834         bytes8 inputSymbol,
1835         uint inputDecimals,
1836         string inputUrl,
1837         string inputIpfsHash,
1838         address[2] breakInBreakOut,
1839         uint[] inputStandards,
1840         bytes4[] inputFunctionSignatures
1841     )
1842         auth
1843         pre_cond(!assetInformation[ofAsset].exists)
1844     {
1845         assetInformation[ofAsset].exists = true;
1846         registeredAssets.push(ofAsset);
1847         updateAsset(
1848             ofAsset,
1849             inputName,
1850             inputSymbol,
1851             inputDecimals,
1852             inputUrl,
1853             inputIpfsHash,
1854             breakInBreakOut,
1855             inputStandards,
1856             inputFunctionSignatures
1857         );
1858         assert(assetInformation[ofAsset].exists);
1859     }
1860 
1861     /// @notice Register an exchange information entry
1862     /// @dev Pre: Only registrar owner should be able to register
1863     /// @dev Post: Address ofExchange is registered
1864     /// @param ofExchange Address of the exchange
1865     /// @param ofExchangeAdapter Address of exchange adapter for this exchange
1866     /// @param inputTakesCustody Whether this exchange takes custody of tokens before trading
1867     /// @param inputFunctionSignatures Function signatures for whitelisted exchange functions
1868     function registerExchange(
1869         address ofExchange,
1870         address ofExchangeAdapter,
1871         bool inputTakesCustody,
1872         bytes4[] inputFunctionSignatures
1873     )
1874         auth
1875         pre_cond(!exchangeInformation[ofExchange].exists)
1876     {
1877         exchangeInformation[ofExchange].exists = true;
1878         registeredExchanges.push(ofExchange);
1879         updateExchange(
1880             ofExchange,
1881             ofExchangeAdapter,
1882             inputTakesCustody,
1883             inputFunctionSignatures
1884         );
1885         assert(exchangeInformation[ofExchange].exists);
1886     }
1887 
1888     /// @notice Updates description information of a registered Asset
1889     /// @dev Pre: Owner can change an existing entry
1890     /// @dev Post: Changed Name, Symbol, URL and/or IPFSHash
1891     /// @param ofAsset Address of the asset to be updated
1892     /// @param inputName Human-readable name of the Asset as in ERC223 token standard
1893     /// @param inputSymbol Human-readable symbol of the Asset as in ERC223 token standard
1894     /// @param inputUrl Url for extended information of the asset
1895     /// @param inputIpfsHash Same as url but for ipfs
1896     function updateAsset(
1897         address ofAsset,
1898         bytes32 inputName,
1899         bytes8 inputSymbol,
1900         uint inputDecimals,
1901         string inputUrl,
1902         string inputIpfsHash,
1903         address[2] ofBreakInBreakOut,
1904         uint[] inputStandards,
1905         bytes4[] inputFunctionSignatures
1906     )
1907         auth
1908         pre_cond(assetInformation[ofAsset].exists)
1909     {
1910         Asset asset = assetInformation[ofAsset];
1911         asset.name = inputName;
1912         asset.symbol = inputSymbol;
1913         asset.decimals = inputDecimals;
1914         asset.url = inputUrl;
1915         asset.ipfsHash = inputIpfsHash;
1916         asset.breakIn = ofBreakInBreakOut[0];
1917         asset.breakOut = ofBreakInBreakOut[1];
1918         asset.standards = inputStandards;
1919         asset.functionSignatures = inputFunctionSignatures;
1920     }
1921 
1922     function updateExchange(
1923         address ofExchange,
1924         address ofExchangeAdapter,
1925         bool inputTakesCustody,
1926         bytes4[] inputFunctionSignatures
1927     )
1928         auth
1929         pre_cond(exchangeInformation[ofExchange].exists)
1930     {
1931         Exchange exchange = exchangeInformation[ofExchange];
1932         exchange.adapter = ofExchangeAdapter;
1933         exchange.takesCustody = inputTakesCustody;
1934         exchange.functionSignatures = inputFunctionSignatures;
1935     }
1936 
1937     // TODO: check max size of array before remaking this becomes untenable
1938     /// @notice Deletes an existing entry
1939     /// @dev Owner can delete an existing entry
1940     /// @param ofAsset address for which specific information is requested
1941     function removeAsset(
1942         address ofAsset,
1943         uint assetIndex
1944     )
1945         auth
1946         pre_cond(assetInformation[ofAsset].exists)
1947     {
1948         require(registeredAssets[assetIndex] == ofAsset);
1949         delete assetInformation[ofAsset]; // Sets exists boolean to false
1950         delete registeredAssets[assetIndex];
1951         for (uint i = assetIndex; i < registeredAssets.length-1; i++) {
1952             registeredAssets[i] = registeredAssets[i+1];
1953         }
1954         registeredAssets.length--;
1955         assert(!assetInformation[ofAsset].exists);
1956     }
1957 
1958     /// @notice Deletes an existing entry
1959     /// @dev Owner can delete an existing entry
1960     /// @param ofExchange address for which specific information is requested
1961     /// @param exchangeIndex index of the exchange in array
1962     function removeExchange(
1963         address ofExchange,
1964         uint exchangeIndex
1965     )
1966         auth
1967         pre_cond(exchangeInformation[ofExchange].exists)
1968     {
1969         require(registeredExchanges[exchangeIndex] == ofExchange);
1970         delete exchangeInformation[ofExchange];
1971         delete registeredExchanges[exchangeIndex];
1972         for (uint i = exchangeIndex; i < registeredExchanges.length-1; i++) {
1973             registeredExchanges[i] = registeredExchanges[i+1];
1974         }
1975         registeredExchanges.length--;
1976         assert(!exchangeInformation[ofExchange].exists);
1977     }
1978 
1979     // PUBLIC VIEW METHODS
1980 
1981     // get asset specific information
1982     function getName(address ofAsset) view returns (bytes32) { return assetInformation[ofAsset].name; }
1983     function getSymbol(address ofAsset) view returns (bytes8) { return assetInformation[ofAsset].symbol; }
1984     function getDecimals(address ofAsset) view returns (uint) { return assetInformation[ofAsset].decimals; }
1985     function assetIsRegistered(address ofAsset) view returns (bool) { return assetInformation[ofAsset].exists; }
1986     function getRegisteredAssets() view returns (address[]) { return registeredAssets; }
1987     function assetMethodIsAllowed(
1988         address ofAsset, bytes4 querySignature
1989     )
1990         returns (bool)
1991     {
1992         bytes4[] memory signatures = assetInformation[ofAsset].functionSignatures;
1993         for (uint i = 0; i < signatures.length; i++) {
1994             if (signatures[i] == querySignature) {
1995                 return true;
1996             }
1997         }
1998         return false;
1999     }
2000 
2001     // get exchange-specific information
2002     function exchangeIsRegistered(address ofExchange) view returns (bool) { return exchangeInformation[ofExchange].exists; }
2003     function getRegisteredExchanges() view returns (address[]) { return registeredExchanges; }
2004     function getExchangeInformation(address ofExchange)
2005         view
2006         returns (address, bool)
2007     {
2008         Exchange exchange = exchangeInformation[ofExchange];
2009         return (
2010             exchange.adapter,
2011             exchange.takesCustody
2012         );
2013     }
2014     function getExchangeFunctionSignatures(address ofExchange)
2015         view
2016         returns (bytes4[])
2017     {
2018         return exchangeInformation[ofExchange].functionSignatures;
2019     }
2020     function exchangeMethodIsAllowed(
2021         address ofExchange, bytes4 querySignature
2022     )
2023         returns (bool)
2024     {
2025         bytes4[] memory signatures = exchangeInformation[ofExchange].functionSignatures;
2026         for (uint i = 0; i < signatures.length; i++) {
2027             if (signatures[i] == querySignature) {
2028                 return true;
2029             }
2030         }
2031         return false;
2032     }
2033 }
2034 
2035 interface SimplePriceFeedInterface {
2036 
2037     // EVENTS
2038 
2039     event PriceUpdated(bytes32 hash);
2040 
2041     // PUBLIC METHODS
2042 
2043     function update(address[] ofAssets, uint[] newPrices) external;
2044 
2045     // PUBLIC VIEW METHODS
2046 
2047     // Get price feed operation specific information
2048     function getQuoteAsset() view returns (address);
2049     function getLastUpdateId() view returns (uint);
2050     // Get asset specific information as updated in price feed
2051     function getPrice(address ofAsset) view returns (uint price, uint timestamp);
2052     function getPrices(address[] ofAssets) view returns (uint[] prices, uint[] timestamps);
2053 }
2054 
2055 contract SimplePriceFeed is SimplePriceFeedInterface, DSThing, DBC {
2056 
2057     // TYPES
2058     struct Data {
2059         uint price;
2060         uint timestamp;
2061     }
2062 
2063     // FIELDS
2064     mapping(address => Data) public assetsToPrices;
2065 
2066     // Constructor fields
2067     address public QUOTE_ASSET; // Asset of a portfolio against which all other assets are priced
2068 
2069     // Contract-level variables
2070     uint public updateId;        // Update counter for this pricefeed; used as a check during investment
2071     CanonicalRegistrar public registrar;
2072     CanonicalPriceFeed public superFeed;
2073 
2074     // METHODS
2075 
2076     // CONSTRUCTOR
2077 
2078     /// @param ofQuoteAsset Address of quote asset
2079     /// @param ofRegistrar Address of canonical registrar
2080     /// @param ofSuperFeed Address of superfeed
2081     function SimplePriceFeed(
2082         address ofRegistrar,
2083         address ofQuoteAsset,
2084         address ofSuperFeed
2085     ) {
2086         registrar = CanonicalRegistrar(ofRegistrar);
2087         QUOTE_ASSET = ofQuoteAsset;
2088         superFeed = CanonicalPriceFeed(ofSuperFeed);
2089     }
2090 
2091     // EXTERNAL METHODS
2092 
2093     /// @dev Only Owner; Same sized input arrays
2094     /// @dev Updates price of asset relative to QUOTE_ASSET
2095     /** Ex:
2096      *  Let QUOTE_ASSET == MLN (base units), let asset == EUR-T,
2097      *  let Value of 1 EUR-T := 1 EUR == 0.080456789 MLN, hence price 0.080456789 MLN / EUR-T
2098      *  and let EUR-T decimals == 8.
2099      *  Input would be: information[EUR-T].price = 8045678 [MLN/ (EUR-T * 10**8)]
2100      */
2101     /// @param ofAssets list of asset addresses
2102     /// @param newPrices list of prices for each of the assets
2103     function update(address[] ofAssets, uint[] newPrices)
2104         external
2105         auth
2106     {
2107         _updatePrices(ofAssets, newPrices);
2108     }
2109 
2110     // PUBLIC VIEW METHODS
2111 
2112     // Get pricefeed specific information
2113     function getQuoteAsset() view returns (address) { return QUOTE_ASSET; }
2114     function getLastUpdateId() view returns (uint) { return updateId; }
2115 
2116     /**
2117     @notice Gets price of an asset multiplied by ten to the power of assetDecimals
2118     @dev Asset has been registered
2119     @param ofAsset Asset for which price should be returned
2120     @return {
2121       "price": "Price formatting: mul(exchangePrice, 10 ** decimal), to avoid floating numbers",
2122       "timestamp": "When the asset's price was updated"
2123     }
2124     */
2125     function getPrice(address ofAsset)
2126         view
2127         returns (uint price, uint timestamp)
2128     {
2129         Data data = assetsToPrices[ofAsset];
2130         return (data.price, data.timestamp);
2131     }
2132 
2133     /**
2134     @notice Price of a registered asset in format (bool areRecent, uint[] prices, uint[] decimals)
2135     @dev Convention for price formatting: mul(price, 10 ** decimal), to avoid floating numbers
2136     @param ofAssets Assets for which prices should be returned
2137     @return {
2138         "prices":       "Array of prices",
2139         "timestamps":   "Array of timestamps",
2140     }
2141     */
2142     function getPrices(address[] ofAssets)
2143         view
2144         returns (uint[], uint[])
2145     {
2146         uint[] memory prices = new uint[](ofAssets.length);
2147         uint[] memory timestamps = new uint[](ofAssets.length);
2148         for (uint i; i < ofAssets.length; i++) {
2149             var (price, timestamp) = getPrice(ofAssets[i]);
2150             prices[i] = price;
2151             timestamps[i] = timestamp;
2152         }
2153         return (prices, timestamps);
2154     }
2155 
2156     // INTERNAL METHODS
2157 
2158     /// @dev Internal so that feeds inheriting this one are not obligated to have an exposed update(...) method, but can still perform updates
2159     function _updatePrices(address[] ofAssets, uint[] newPrices)
2160         internal
2161         pre_cond(ofAssets.length == newPrices.length)
2162     {
2163         updateId++;
2164         for (uint i = 0; i < ofAssets.length; ++i) {
2165             require(registrar.assetIsRegistered(ofAssets[i]));
2166             require(assetsToPrices[ofAssets[i]].timestamp != now); // prevent two updates in one block
2167             assetsToPrices[ofAssets[i]].timestamp = now;
2168             assetsToPrices[ofAssets[i]].price = newPrices[i];
2169         }
2170         emit PriceUpdated(keccak256(ofAssets, newPrices));
2171     }
2172 }
2173 
2174 contract StakingPriceFeed is SimplePriceFeed {
2175 
2176     OperatorStaking public stakingContract;
2177     AssetInterface public stakingToken;
2178 
2179     // CONSTRUCTOR
2180 
2181     /// @param ofQuoteAsset Address of quote asset
2182     /// @param ofRegistrar Address of canonical registrar
2183     /// @param ofSuperFeed Address of superfeed
2184     function StakingPriceFeed(
2185         address ofRegistrar,
2186         address ofQuoteAsset,
2187         address ofSuperFeed
2188     )
2189         SimplePriceFeed(ofRegistrar, ofQuoteAsset, ofSuperFeed)
2190     {
2191         stakingContract = OperatorStaking(ofSuperFeed); // canonical feed *is* staking contract
2192         stakingToken = AssetInterface(stakingContract.stakingToken());
2193     }
2194 
2195     // EXTERNAL METHODS
2196 
2197     /// @param amount Number of tokens to stake for this feed
2198     /// @param data Data may be needed for some future applications (can be empty for now)
2199     function depositStake(uint amount, bytes data)
2200         external
2201         auth
2202     {
2203         require(stakingToken.transferFrom(msg.sender, address(this), amount));
2204         require(stakingToken.approve(stakingContract, amount));
2205         stakingContract.stake(amount, data);
2206     }
2207 
2208     /// @param amount Number of tokens to unstake for this feed
2209     /// @param data Data may be needed for some future applications (can be empty for now)
2210     function unstake(uint amount, bytes data)
2211         external
2212         auth
2213     {
2214         stakingContract.unstake(amount, data);
2215     }
2216 
2217     function withdrawStake()
2218         external
2219         auth
2220     {
2221         uint amountToWithdraw = stakingContract.stakeToWithdraw(address(this));
2222         stakingContract.withdrawStake();
2223         require(stakingToken.transfer(msg.sender, amountToWithdraw));
2224     }
2225 }
2226 
2227 interface RiskMgmtInterface {
2228 
2229     // METHODS
2230     // PUBLIC VIEW METHODS
2231 
2232     /// @notice Checks if the makeOrder price is reasonable and not manipulative
2233     /// @param orderPrice Price of Order
2234     /// @param referencePrice Reference price obtained through PriceFeed contract
2235     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
2236     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
2237     /// @param sellQuantity Quantity of sellAsset to be sold
2238     /// @param buyQuantity Quantity of buyAsset to be bought
2239     /// @return If makeOrder is permitted
2240     function isMakePermitted(
2241         uint orderPrice,
2242         uint referencePrice,
2243         address sellAsset,
2244         address buyAsset,
2245         uint sellQuantity,
2246         uint buyQuantity
2247     ) view returns (bool);
2248 
2249     /// @notice Checks if the takeOrder price is reasonable and not manipulative
2250     /// @param orderPrice Price of Order
2251     /// @param referencePrice Reference price obtained through PriceFeed contract
2252     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
2253     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
2254     /// @param sellQuantity Quantity of sellAsset to be sold
2255     /// @param buyQuantity Quantity of buyAsset to be bought
2256     /// @return If takeOrder is permitted
2257     function isTakePermitted(
2258         uint orderPrice,
2259         uint referencePrice,
2260         address sellAsset,
2261         address buyAsset,
2262         uint sellQuantity,
2263         uint buyQuantity
2264     ) view returns (bool);
2265 }
2266 
2267 contract OperatorStaking is DBC {
2268 
2269     // EVENTS
2270 
2271     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
2272     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
2273     event StakeBurned(address indexed user, uint256 amount, bytes data);
2274 
2275     // TYPES
2276 
2277     struct StakeData {
2278         uint amount;
2279         address staker;
2280     }
2281 
2282     // Circular linked list
2283     struct Node {
2284         StakeData data;
2285         uint prev;
2286         uint next;
2287     }
2288 
2289     // FIELDS
2290 
2291     // INTERNAL FIELDS
2292     Node[] internal stakeNodes; // Sorted circular linked list nodes containing stake data (Built on top https://programtheblockchain.com/posts/2018/03/30/storage-patterns-doubly-linked-list/)
2293 
2294     // PUBLIC FIELDS
2295     uint public minimumStake;
2296     uint public numOperators;
2297     uint public withdrawalDelay;
2298     mapping (address => bool) public isRanked;
2299     mapping (address => uint) public latestUnstakeTime;
2300     mapping (address => uint) public stakeToWithdraw;
2301     mapping (address => uint) public stakedAmounts;
2302     uint public numStakers; // Current number of stakers (Needed because of array holes)
2303     AssetInterface public stakingToken;
2304 
2305     // TODO: consider renaming "operator" depending on how this is implemented
2306     //  (i.e. is pricefeed staking itself?)
2307     function OperatorStaking(
2308         AssetInterface _stakingToken,
2309         uint _minimumStake,
2310         uint _numOperators,
2311         uint _withdrawalDelay
2312     )
2313         public
2314     {
2315         require(address(_stakingToken) != address(0));
2316         stakingToken = _stakingToken;
2317         minimumStake = _minimumStake;
2318         numOperators = _numOperators;
2319         withdrawalDelay = _withdrawalDelay;
2320         StakeData memory temp = StakeData({ amount: 0, staker: address(0) });
2321         stakeNodes.push(Node(temp, 0, 0));
2322     }
2323 
2324     // METHODS : STAKING
2325 
2326     function stake(
2327         uint amount,
2328         bytes data
2329     )
2330         public
2331         pre_cond(amount >= minimumStake)
2332     {
2333         stakedAmounts[msg.sender] += amount;
2334         updateStakerRanking(msg.sender);
2335         require(stakingToken.transferFrom(msg.sender, address(this), amount));
2336     }
2337 
2338     function unstake(
2339         uint amount,
2340         bytes data
2341     )
2342         public
2343     {
2344         uint preStake = stakedAmounts[msg.sender];
2345         uint postStake = preStake - amount;
2346         require(postStake >= minimumStake || postStake == 0);
2347         require(stakedAmounts[msg.sender] >= amount);
2348         latestUnstakeTime[msg.sender] = block.timestamp;
2349         stakedAmounts[msg.sender] -= amount;
2350         stakeToWithdraw[msg.sender] += amount;
2351         updateStakerRanking(msg.sender);
2352         emit Unstaked(msg.sender, amount, stakedAmounts[msg.sender], data);
2353     }
2354 
2355     function withdrawStake()
2356         public
2357         pre_cond(stakeToWithdraw[msg.sender] > 0)
2358         pre_cond(block.timestamp >= latestUnstakeTime[msg.sender] + withdrawalDelay)
2359     {
2360         uint amount = stakeToWithdraw[msg.sender];
2361         stakeToWithdraw[msg.sender] = 0;
2362         require(stakingToken.transfer(msg.sender, amount));
2363     }
2364 
2365     // VIEW FUNCTIONS
2366 
2367     function isValidNode(uint id) view returns (bool) {
2368         // 0 is a sentinel and therefore invalid.
2369         // A valid node is the head or has a previous node.
2370         return id != 0 && (id == stakeNodes[0].next || stakeNodes[id].prev != 0);
2371     }
2372 
2373     function searchNode(address staker) view returns (uint) {
2374         uint current = stakeNodes[0].next;
2375         while (isValidNode(current)) {
2376             if (staker == stakeNodes[current].data.staker) {
2377                 return current;
2378             }
2379             current = stakeNodes[current].next;
2380         }
2381         return 0;
2382     }
2383 
2384     function isOperator(address user) view returns (bool) {
2385         address[] memory operators = getOperators();
2386         for (uint i; i < operators.length; i++) {
2387             if (operators[i] == user) {
2388                 return true;
2389             }
2390         }
2391         return false;
2392     }
2393 
2394     function getOperators()
2395         view
2396         returns (address[])
2397     {
2398         uint arrLength = (numOperators > numStakers) ?
2399             numStakers :
2400             numOperators;
2401         address[] memory operators = new address[](arrLength);
2402         uint current = stakeNodes[0].next;
2403         for (uint i; i < arrLength; i++) {
2404             operators[i] = stakeNodes[current].data.staker;
2405             current = stakeNodes[current].next;
2406         }
2407         return operators;
2408     }
2409 
2410     function getStakersAndAmounts()
2411         view
2412         returns (address[], uint[])
2413     {
2414         address[] memory stakers = new address[](numStakers);
2415         uint[] memory amounts = new uint[](numStakers);
2416         uint current = stakeNodes[0].next;
2417         for (uint i; i < numStakers; i++) {
2418             stakers[i] = stakeNodes[current].data.staker;
2419             amounts[i] = stakeNodes[current].data.amount;
2420             current = stakeNodes[current].next;
2421         }
2422         return (stakers, amounts);
2423     }
2424 
2425     function totalStakedFor(address user)
2426         view
2427         returns (uint)
2428     {
2429         return stakedAmounts[user];
2430     }
2431 
2432     // INTERNAL METHODS
2433 
2434     // DOUBLY-LINKED LIST
2435 
2436     function insertNodeSorted(uint amount, address staker) internal returns (uint) {
2437         uint current = stakeNodes[0].next;
2438         if (current == 0) return insertNodeAfter(0, amount, staker);
2439         while (isValidNode(current)) {
2440             if (amount > stakeNodes[current].data.amount) {
2441                 break;
2442             }
2443             current = stakeNodes[current].next;
2444         }
2445         return insertNodeBefore(current, amount, staker);
2446     }
2447 
2448     function insertNodeAfter(uint id, uint amount, address staker) internal returns (uint newID) {
2449 
2450         // 0 is allowed here to insert at the beginning.
2451         require(id == 0 || isValidNode(id));
2452 
2453         Node storage node = stakeNodes[id];
2454 
2455         stakeNodes.push(Node({
2456             data: StakeData(amount, staker),
2457             prev: id,
2458             next: node.next
2459         }));
2460 
2461         newID = stakeNodes.length - 1;
2462 
2463         stakeNodes[node.next].prev = newID;
2464         node.next = newID;
2465         numStakers++;
2466     }
2467 
2468     function insertNodeBefore(uint id, uint amount, address staker) internal returns (uint) {
2469         return insertNodeAfter(stakeNodes[id].prev, amount, staker);
2470     }
2471 
2472     function removeNode(uint id) internal {
2473         require(isValidNode(id));
2474 
2475         Node storage node = stakeNodes[id];
2476 
2477         stakeNodes[node.next].prev = node.prev;
2478         stakeNodes[node.prev].next = node.next;
2479 
2480         delete stakeNodes[id];
2481         numStakers--;
2482     }
2483 
2484     // UPDATING OPERATORS
2485 
2486     function updateStakerRanking(address _staker) internal {
2487         uint newStakedAmount = stakedAmounts[_staker];
2488         if (newStakedAmount == 0) {
2489             isRanked[_staker] = false;
2490             removeStakerFromArray(_staker);
2491         } else if (isRanked[_staker]) {
2492             removeStakerFromArray(_staker);
2493             insertNodeSorted(newStakedAmount, _staker);
2494         } else {
2495             isRanked[_staker] = true;
2496             insertNodeSorted(newStakedAmount, _staker);
2497         }
2498     }
2499 
2500     function removeStakerFromArray(address _staker) internal {
2501         uint id = searchNode(_staker);
2502         require(id > 0);
2503         removeNode(id);
2504     }
2505 
2506 }
2507 
2508 contract CanonicalPriceFeed is OperatorStaking, SimplePriceFeed, CanonicalRegistrar {
2509 
2510     // EVENTS
2511     event SetupPriceFeed(address ofPriceFeed);
2512 
2513     struct HistoricalPrices {
2514         address[] assets;
2515         uint[] prices;
2516         uint timestamp;
2517     }
2518 
2519     // FIELDS
2520     bool public updatesAreAllowed = true;
2521     uint public minimumPriceCount = 1;
2522     uint public VALIDITY;
2523     uint public INTERVAL;
2524     mapping (address => bool) public isStakingFeed; // If the Staking Feed has been created through this contract
2525     HistoricalPrices[] public priceHistory;
2526 
2527     // METHODS
2528 
2529     // CONSTRUCTOR
2530 
2531     /// @dev Define and register a quote asset against which all prices are measured/based against
2532     /// @param ofStakingAsset Address of staking asset (may or may not be quoteAsset)
2533     /// @param ofQuoteAsset Address of quote asset
2534     /// @param quoteAssetName Name of quote asset
2535     /// @param quoteAssetSymbol Symbol for quote asset
2536     /// @param quoteAssetDecimals Decimal places for quote asset
2537     /// @param quoteAssetUrl URL related to quote asset
2538     /// @param quoteAssetIpfsHash IPFS hash associated with quote asset
2539     /// @param quoteAssetBreakInBreakOut Break-in/break-out for quote asset on destination chain
2540     /// @param quoteAssetStandards EIP standards quote asset adheres to
2541     /// @param quoteAssetFunctionSignatures Whitelisted functions of quote asset contract
2542     // /// @param interval Number of seconds between pricefeed updates (this interval is not enforced on-chain, but should be followed by the datafeed maintainer)
2543     // /// @param validity Number of seconds that datafeed update information is valid for
2544     /// @param ofGovernance Address of contract governing the Canonical PriceFeed
2545     function CanonicalPriceFeed(
2546         address ofStakingAsset,
2547         address ofQuoteAsset, // Inital entry in asset registrar contract is Melon (QUOTE_ASSET)
2548         bytes32 quoteAssetName,
2549         bytes8 quoteAssetSymbol,
2550         uint quoteAssetDecimals,
2551         string quoteAssetUrl,
2552         string quoteAssetIpfsHash,
2553         address[2] quoteAssetBreakInBreakOut,
2554         uint[] quoteAssetStandards,
2555         bytes4[] quoteAssetFunctionSignatures,
2556         uint[2] updateInfo, // interval, validity
2557         uint[3] stakingInfo, // minStake, numOperators, unstakeDelay
2558         address ofGovernance
2559     )
2560         OperatorStaking(
2561             AssetInterface(ofStakingAsset), stakingInfo[0], stakingInfo[1], stakingInfo[2]
2562         )
2563         SimplePriceFeed(address(this), ofQuoteAsset, address(0))
2564     {
2565         registerAsset(
2566             ofQuoteAsset,
2567             quoteAssetName,
2568             quoteAssetSymbol,
2569             quoteAssetDecimals,
2570             quoteAssetUrl,
2571             quoteAssetIpfsHash,
2572             quoteAssetBreakInBreakOut,
2573             quoteAssetStandards,
2574             quoteAssetFunctionSignatures
2575         );
2576         INTERVAL = updateInfo[0];
2577         VALIDITY = updateInfo[1];
2578         setOwner(ofGovernance);
2579     }
2580 
2581     // EXTERNAL METHODS
2582 
2583     /// @notice Create a new StakingPriceFeed
2584     function setupStakingPriceFeed() external {
2585         address ofStakingPriceFeed = new StakingPriceFeed(
2586             address(this),
2587             stakingToken,
2588             address(this)
2589         );
2590         isStakingFeed[ofStakingPriceFeed] = true;
2591         StakingPriceFeed(ofStakingPriceFeed).setOwner(msg.sender);
2592         emit SetupPriceFeed(ofStakingPriceFeed);
2593     }
2594 
2595     /// @dev override inherited update function to prevent manual update from authority
2596     function update(address[] ofAssets, uint[] newPrices) external { revert(); }
2597 
2598     /// @dev Burn state for a pricefeed operator
2599     /// @param user Address of pricefeed operator to burn the stake from
2600     function burnStake(address user)
2601         external
2602         auth
2603     {
2604         uint totalToBurn = add(stakedAmounts[user], stakeToWithdraw[user]);
2605         stakedAmounts[user] = 0;
2606         stakeToWithdraw[user] = 0;
2607         updateStakerRanking(user);
2608         emit StakeBurned(user, totalToBurn, "");
2609     }
2610 
2611     // PUBLIC METHODS
2612 
2613     // STAKING
2614 
2615     function stake(
2616         uint amount,
2617         bytes data
2618     )
2619         public
2620         pre_cond(isStakingFeed[msg.sender])
2621     {
2622         OperatorStaking.stake(amount, data);
2623     }
2624 
2625     // function stakeFor(
2626     //     address user,
2627     //     uint amount,
2628     //     bytes data
2629     // )
2630     //     public
2631     //     pre_cond(isStakingFeed[user])
2632     // {
2633 
2634     //     OperatorStaking.stakeFor(user, amount, data);
2635     // }
2636 
2637     // AGGREGATION
2638 
2639     /// @dev Only Owner; Same sized input arrays
2640     /// @dev Updates price of asset relative to QUOTE_ASSET
2641     /** Ex:
2642      *  Let QUOTE_ASSET == MLN (base units), let asset == EUR-T,
2643      *  let Value of 1 EUR-T := 1 EUR == 0.080456789 MLN, hence price 0.080456789 MLN / EUR-T
2644      *  and let EUR-T decimals == 8.
2645      *  Input would be: information[EUR-T].price = 8045678 [MLN/ (EUR-T * 10**8)]
2646      */
2647     /// @param ofAssets list of asset addresses
2648     function collectAndUpdate(address[] ofAssets)
2649         public
2650         auth
2651         pre_cond(updatesAreAllowed)
2652     {
2653         uint[] memory newPrices = pricesToCommit(ofAssets);
2654         priceHistory.push(
2655             HistoricalPrices({assets: ofAssets, prices: newPrices, timestamp: block.timestamp})
2656         );
2657         _updatePrices(ofAssets, newPrices);
2658     }
2659 
2660     function pricesToCommit(address[] ofAssets)
2661         view
2662         returns (uint[])
2663     {
2664         address[] memory operators = getOperators();
2665         uint[] memory newPrices = new uint[](ofAssets.length);
2666         for (uint i = 0; i < ofAssets.length; i++) {
2667             uint[] memory assetPrices = new uint[](operators.length);
2668             for (uint j = 0; j < operators.length; j++) {
2669                 SimplePriceFeed feed = SimplePriceFeed(operators[j]);
2670                 var (price, timestamp) = feed.assetsToPrices(ofAssets[i]);
2671                 if (now > add(timestamp, VALIDITY)) {
2672                     continue; // leaves a zero in the array (dealt with later)
2673                 }
2674                 assetPrices[j] = price;
2675             }
2676             newPrices[i] = medianize(assetPrices);
2677         }
2678         return newPrices;
2679     }
2680 
2681     /// @dev from MakerDao medianizer contract
2682     function medianize(uint[] unsorted)
2683         view
2684         returns (uint)
2685     {
2686         uint numValidEntries;
2687         for (uint i = 0; i < unsorted.length; i++) {
2688             if (unsorted[i] != 0) {
2689                 numValidEntries++;
2690             }
2691         }
2692         if (numValidEntries < minimumPriceCount) {
2693             revert();
2694         }
2695         uint counter;
2696         uint[] memory out = new uint[](numValidEntries);
2697         for (uint j = 0; j < unsorted.length; j++) {
2698             uint item = unsorted[j];
2699             if (item != 0) {    // skip zero (invalid) entries
2700                 if (counter == 0 || item >= out[counter - 1]) {
2701                     out[counter] = item;  // item is larger than last in array (we are home)
2702                 } else {
2703                     uint k = 0;
2704                     while (item >= out[k]) {
2705                         k++;  // get to where element belongs (between smaller and larger items)
2706                     }
2707                     for (uint m = counter; m > k; m--) {
2708                         out[m] = out[m - 1];    // bump larger elements rightward to leave slot
2709                     }
2710                     out[k] = item;
2711                 }
2712                 counter++;
2713             }
2714         }
2715 
2716         uint value;
2717         if (counter % 2 == 0) {
2718             uint value1 = uint(out[(counter / 2) - 1]);
2719             uint value2 = uint(out[(counter / 2)]);
2720             value = add(value1, value2) / 2;
2721         } else {
2722             value = out[(counter - 1) / 2];
2723         }
2724         return value;
2725     }
2726 
2727     function setMinimumPriceCount(uint newCount) auth { minimumPriceCount = newCount; }
2728     function enableUpdates() auth { updatesAreAllowed = true; }
2729     function disableUpdates() auth { updatesAreAllowed = false; }
2730 
2731     // PUBLIC VIEW METHODS
2732 
2733     // FEED INFORMATION
2734 
2735     function getQuoteAsset() view returns (address) { return QUOTE_ASSET; }
2736     function getInterval() view returns (uint) { return INTERVAL; }
2737     function getValidity() view returns (uint) { return VALIDITY; }
2738     function getLastUpdateId() view returns (uint) { return updateId; }
2739 
2740     // PRICES
2741 
2742     /// @notice Whether price of asset has been updated less than VALIDITY seconds ago
2743     /// @param ofAsset Asset in registrar
2744     /// @return isRecent Price information ofAsset is recent
2745     function hasRecentPrice(address ofAsset)
2746         view
2747         pre_cond(assetIsRegistered(ofAsset))
2748         returns (bool isRecent)
2749     {
2750         var ( , timestamp) = getPrice(ofAsset);
2751         return (sub(now, timestamp) <= VALIDITY);
2752     }
2753 
2754     /// @notice Whether prices of assets have been updated less than VALIDITY seconds ago
2755     /// @param ofAssets All assets in registrar
2756     /// @return isRecent Price information ofAssets array is recent
2757     function hasRecentPrices(address[] ofAssets)
2758         view
2759         returns (bool areRecent)
2760     {
2761         for (uint i; i < ofAssets.length; i++) {
2762             if (!hasRecentPrice(ofAssets[i])) {
2763                 return false;
2764             }
2765         }
2766         return true;
2767     }
2768 
2769     function getPriceInfo(address ofAsset)
2770         view
2771         returns (bool isRecent, uint price, uint assetDecimals)
2772     {
2773         isRecent = hasRecentPrice(ofAsset);
2774         (price, ) = getPrice(ofAsset);
2775         assetDecimals = getDecimals(ofAsset);
2776     }
2777 
2778     /**
2779     @notice Gets inverted price of an asset
2780     @dev Asset has been initialised and its price is non-zero
2781     @dev Existing price ofAssets quoted in QUOTE_ASSET (convention)
2782     @param ofAsset Asset for which inverted price should be return
2783     @return {
2784         "isRecent": "Whether the price is fresh, given VALIDITY interval",
2785         "invertedPrice": "Price based (instead of quoted) against QUOTE_ASSET",
2786         "assetDecimals": "Decimal places for this asset"
2787     }
2788     */
2789     function getInvertedPriceInfo(address ofAsset)
2790         view
2791         returns (bool isRecent, uint invertedPrice, uint assetDecimals)
2792     {
2793         uint inputPrice;
2794         // inputPrice quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
2795         (isRecent, inputPrice, assetDecimals) = getPriceInfo(ofAsset);
2796 
2797         // outputPrice based in QUOTE_ASSET and multiplied by 10 ** quoteDecimal
2798         uint quoteDecimals = getDecimals(QUOTE_ASSET);
2799 
2800         return (
2801             isRecent,
2802             mul(10 ** uint(quoteDecimals), 10 ** uint(assetDecimals)) / inputPrice,
2803             quoteDecimals   // TODO: check on this; shouldn't it be assetDecimals?
2804         );
2805     }
2806 
2807     /**
2808     @notice Gets reference price of an asset pair
2809     @dev One of the address is equal to quote asset
2810     @dev either ofBase == QUOTE_ASSET or ofQuote == QUOTE_ASSET
2811     @param ofBase Address of base asset
2812     @param ofQuote Address of quote asset
2813     @return {
2814         "isRecent": "Whether the price is fresh, given VALIDITY interval",
2815         "referencePrice": "Reference price",
2816         "decimal": "Decimal places for this asset"
2817     }
2818     */
2819     function getReferencePriceInfo(address ofBase, address ofQuote)
2820         view
2821         returns (bool isRecent, uint referencePrice, uint decimal)
2822     {
2823         if (getQuoteAsset() == ofQuote) {
2824             (isRecent, referencePrice, decimal) = getPriceInfo(ofBase);
2825         } else if (getQuoteAsset() == ofBase) {
2826             (isRecent, referencePrice, decimal) = getInvertedPriceInfo(ofQuote);
2827         } else {
2828             revert(); // no suitable reference price available
2829         }
2830     }
2831 
2832     /// @notice Gets price of Order
2833     /// @param sellAsset Address of the asset to be sold
2834     /// @param buyAsset Address of the asset to be bought
2835     /// @param sellQuantity Quantity in base units being sold of sellAsset
2836     /// @param buyQuantity Quantity in base units being bought of buyAsset
2837     /// @return orderPrice Price as determined by an order
2838     function getOrderPriceInfo(
2839         address sellAsset,
2840         address buyAsset,
2841         uint sellQuantity,
2842         uint buyQuantity
2843     )
2844         view
2845         returns (uint orderPrice)
2846     {
2847         return mul(buyQuantity, 10 ** uint(getDecimals(sellAsset))) / sellQuantity;
2848     }
2849 
2850     /// @notice Checks whether data exists for a given asset pair
2851     /// @dev Prices are only upated against QUOTE_ASSET
2852     /// @param sellAsset Asset for which check to be done if data exists
2853     /// @param buyAsset Asset for which check to be done if data exists
2854     /// @return Whether assets exist for given asset pair
2855     function existsPriceOnAssetPair(address sellAsset, address buyAsset)
2856         view
2857         returns (bool isExistent)
2858     {
2859         return
2860             hasRecentPrice(sellAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
2861             hasRecentPrice(buyAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
2862             (buyAsset == QUOTE_ASSET || sellAsset == QUOTE_ASSET) && // One asset must be QUOTE_ASSET
2863             (buyAsset != QUOTE_ASSET || sellAsset != QUOTE_ASSET); // Pair must consists of diffrent assets
2864     }
2865 
2866     /// @return Sparse array of addresses of owned pricefeeds
2867     function getPriceFeedsByOwner(address _owner)
2868         view
2869         returns(address[])
2870     {
2871         address[] memory ofPriceFeeds = new address[](numStakers);
2872         if (numStakers == 0) return ofPriceFeeds;
2873         uint current = stakeNodes[0].next;
2874         for (uint i; i < numStakers; i++) {
2875             StakingPriceFeed stakingFeed = StakingPriceFeed(stakeNodes[current].data.staker);
2876             if (stakingFeed.owner() == _owner) {
2877                 ofPriceFeeds[i] = address(stakingFeed);
2878             }
2879             current = stakeNodes[current].next;
2880         }
2881         return ofPriceFeeds;
2882     }
2883 
2884     function getHistoryLength() returns (uint) { return priceHistory.length; }
2885 
2886     function getHistoryAt(uint id) returns (address[], uint[], uint) {
2887         address[] memory assets = priceHistory[id].assets;
2888         uint[] memory prices = priceHistory[id].prices;
2889         uint timestamp = priceHistory[id].timestamp;
2890         return (assets, prices, timestamp);
2891     }
2892 }
2893 
2894 interface VersionInterface {
2895 
2896     // EVENTS
2897 
2898     event FundUpdated(uint id);
2899 
2900     // PUBLIC METHODS
2901 
2902     function shutDown() external;
2903 
2904     function setupFund(
2905         bytes32 ofFundName,
2906         address ofQuoteAsset,
2907         uint ofManagementFee,
2908         uint ofPerformanceFee,
2909         address ofCompliance,
2910         address ofRiskMgmt,
2911         address[] ofExchanges,
2912         address[] ofDefaultAssets,
2913         uint8 v,
2914         bytes32 r,
2915         bytes32 s
2916     );
2917     function shutDownFund(address ofFund);
2918 
2919     // PUBLIC VIEW METHODS
2920 
2921     function getNativeAsset() view returns (address);
2922     function getFundById(uint withId) view returns (address);
2923     function getLastFundId() view returns (uint);
2924     function getFundByManager(address ofManager) view returns (address);
2925     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed);
2926 
2927 }
2928 
2929 contract Version is DBC, Owned, VersionInterface {
2930     // FIELDS
2931 
2932     bytes32 public constant TERMS_AND_CONDITIONS = 0xAA9C907B0D6B4890E7225C09CBC16A01CB97288840201AA7CDCB27F4ED7BF159; // Hashed terms and conditions as displayed on IPFS, decoded from base 58
2933 
2934     // Constructor fields
2935     string public VERSION_NUMBER; // SemVer of Melon protocol version
2936     address public MELON_ASSET; // Address of Melon asset contract
2937     address public NATIVE_ASSET; // Address of Fixed quote asset
2938     address public GOVERNANCE; // Address of Melon protocol governance contract
2939     address public CANONICAL_PRICEFEED; // Address of the canonical pricefeed
2940 
2941     // Methods fields
2942     bool public isShutDown; // Governance feature, if yes than setupFund gets blocked and shutDownFund gets opened
2943     address public COMPLIANCE; // restrict to Competition compliance module for this version
2944     address[] public listOfFunds; // A complete list of fund addresses created using this version
2945     mapping (address => address) public managerToFunds; // Links manager address to fund address created using this version
2946 
2947     // EVENTS
2948 
2949     event FundUpdated(address ofFund);
2950 
2951     // METHODS
2952 
2953     // CONSTRUCTOR
2954 
2955     /// @param versionNumber SemVer of Melon protocol version
2956     /// @param ofGovernance Address of Melon governance contract
2957     /// @param ofMelonAsset Address of Melon asset contract
2958     function Version(
2959         string versionNumber,
2960         address ofGovernance,
2961         address ofMelonAsset,
2962         address ofNativeAsset,
2963         address ofCanonicalPriceFeed,
2964         address ofCompetitionCompliance
2965     ) {
2966         VERSION_NUMBER = versionNumber;
2967         GOVERNANCE = ofGovernance;
2968         MELON_ASSET = ofMelonAsset;
2969         NATIVE_ASSET = ofNativeAsset;
2970         CANONICAL_PRICEFEED = ofCanonicalPriceFeed;
2971         COMPLIANCE = ofCompetitionCompliance;
2972     }
2973 
2974     // EXTERNAL METHODS
2975 
2976     function shutDown() external pre_cond(msg.sender == GOVERNANCE) { isShutDown = true; }
2977 
2978     // PUBLIC METHODS
2979 
2980     /// @param ofFundName human-readable descriptive name (not necessarily unique)
2981     /// @param ofQuoteAsset Asset against which performance fee is measured against
2982     /// @param ofManagementFee A time based fee, given in a number which is divided by 10 ** 15
2983     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 10 ** 15
2984     /// @param ofCompliance Address of participation module
2985     /// @param ofRiskMgmt Address of risk management module
2986     /// @param ofExchanges Addresses of exchange on which this fund can trade
2987     /// @param ofDefaultAssets Enable invest/redeem with these assets (quote asset already enabled)
2988     /// @param v ellipitc curve parameter v
2989     /// @param r ellipitc curve parameter r
2990     /// @param s ellipitc curve parameter s
2991     function setupFund(
2992         bytes32 ofFundName,
2993         address ofQuoteAsset,
2994         uint ofManagementFee,
2995         uint ofPerformanceFee,
2996         address ofCompliance,
2997         address ofRiskMgmt,
2998         address[] ofExchanges,
2999         address[] ofDefaultAssets,
3000         uint8 v,
3001         bytes32 r,
3002         bytes32 s
3003     ) {
3004         require(!isShutDown);
3005         require(termsAndConditionsAreSigned(v, r, s));
3006         require(CompetitionCompliance(COMPLIANCE).isCompetitionAllowed(msg.sender));
3007         require(managerToFunds[msg.sender] == address(0)); // Add limitation for simpler migration process of shutting down and setting up fund
3008         address[] memory melonAsDefaultAsset = new address[](1);
3009         melonAsDefaultAsset[0] = MELON_ASSET; // Melon asset should be in default assets
3010         address ofFund = new Fund(
3011             msg.sender,
3012             ofFundName,
3013             NATIVE_ASSET,
3014             0,
3015             0,
3016             COMPLIANCE,
3017             ofRiskMgmt,
3018             CANONICAL_PRICEFEED,
3019             ofExchanges,
3020             melonAsDefaultAsset
3021         );
3022         listOfFunds.push(ofFund);
3023         managerToFunds[msg.sender] = ofFund;
3024         emit FundUpdated(ofFund);
3025     }
3026 
3027     /// @dev Dereference Fund and shut it down
3028     /// @param ofFund Address of the fund to be shut down
3029     function shutDownFund(address ofFund)
3030         pre_cond(isShutDown || managerToFunds[msg.sender] == ofFund)
3031     {
3032         Fund fund = Fund(ofFund);
3033         delete managerToFunds[msg.sender];
3034         fund.shutDown();
3035         emit FundUpdated(ofFund);
3036     }
3037 
3038     // PUBLIC VIEW METHODS
3039 
3040     /// @dev Proof that terms and conditions have been read and understood
3041     /// @param v ellipitc curve parameter v
3042     /// @param r ellipitc curve parameter r
3043     /// @param s ellipitc curve parameter s
3044     /// @return signed Whether or not terms and conditions have been read and understood
3045     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed) {
3046         return ecrecover(
3047             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
3048             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
3049             //  it will return rsv (same as geth; where v is [27, 28]).
3050             // Note that if you are using ecrecover, v will be either "00" or "01".
3051             //  As a result, in order to use this value, you will have to parse it to an
3052             //  integer and then add 27. This will result in either a 27 or a 28.
3053             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
3054             keccak256("\x19Ethereum Signed Message:\n32", TERMS_AND_CONDITIONS),
3055             v,
3056             r,
3057             s
3058         ) == msg.sender; // Has sender signed TERMS_AND_CONDITIONS
3059     }
3060 
3061     function getNativeAsset() view returns (address) { return NATIVE_ASSET; }
3062     function getFundById(uint withId) view returns (address) { return listOfFunds[withId]; }
3063     function getLastFundId() view returns (uint) { return listOfFunds.length - 1; }
3064     function getFundByManager(address ofManager) view returns (address) { return managerToFunds[ofManager]; }
3065 }