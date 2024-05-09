1 pragma solidity ^0.4.13;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSExec {
58     function tryExec( address target, bytes calldata, uint value)
59              internal
60              returns (bool call_ret)
61     {
62         return target.call.value(value)(calldata);
63     }
64     function exec( address target, bytes calldata, uint value)
65              internal
66     {
67         if(!tryExec(target, calldata, value)) {
68             revert();
69         }
70     }
71 
72     // Convenience aliases
73     function exec( address t, bytes c )
74         internal
75     {
76         exec(t, c, 0);
77     }
78     function exec( address t, uint256 v )
79         internal
80     {
81         bytes memory c; exec(t, c, v);
82     }
83     function tryExec( address t, bytes c )
84         internal
85         returns (bool)
86     {
87         return tryExec(t, c, 0);
88     }
89     function tryExec( address t, uint256 v )
90         internal
91         returns (bool)
92     {
93         bytes memory c; return tryExec(t, c, v);
94     }
95 }
96 
97 contract DSNote {
98     event LogNote(
99         bytes4   indexed  sig,
100         address  indexed  guy,
101         bytes32  indexed  foo,
102         bytes32  indexed  bar,
103         uint              wad,
104         bytes             fax
105     ) anonymous;
106 
107     modifier note {
108         bytes32 foo;
109         bytes32 bar;
110 
111         assembly {
112             foo := calldataload(4)
113             bar := calldataload(36)
114         }
115 
116         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
117 
118         _;
119     }
120 }
121 
122 contract DSGroup is DSExec, DSNote {
123     address[]  public  members;
124     uint       public  quorum;
125     uint       public  window;
126     uint       public  actionCount;
127 
128     mapping (uint => Action)                     public  actions;
129     mapping (uint => mapping (address => bool))  public  confirmedBy;
130     mapping (address => bool)                    public  isMember;
131 
132     // Legacy events
133     event Proposed   (uint id, bytes calldata);
134     event Confirmed  (uint id, address member);
135     event Triggered  (uint id);
136 
137     struct Action {
138         address  target;
139         bytes    calldata;
140         uint     value;
141 
142         uint     confirmations;
143         uint     deadline;
144         bool     triggered;
145     }
146 
147     function DSGroup(
148         address[]  members_,
149         uint       quorum_,
150         uint       window_
151     ) {
152         members  = members_;
153         quorum   = quorum_;
154         window   = window_;
155 
156         for (uint i = 0; i < members.length; i++) {
157             isMember[members[i]] = true;
158         }
159     }
160 
161     function memberCount() constant returns (uint) {
162         return members.length;
163     }
164 
165     function target(uint id) constant returns (address) {
166         return actions[id].target;
167     }
168     function calldata(uint id) constant returns (bytes) {
169         return actions[id].calldata;
170     }
171     function value(uint id) constant returns (uint) {
172         return actions[id].value;
173     }
174 
175     function confirmations(uint id) constant returns (uint) {
176         return actions[id].confirmations;
177     }
178     function deadline(uint id) constant returns (uint) {
179         return actions[id].deadline;
180     }
181     function triggered(uint id) constant returns (bool) {
182         return actions[id].triggered;
183     }
184 
185     function confirmed(uint id) constant returns (bool) {
186         return confirmations(id) >= quorum;
187     }
188     function expired(uint id) constant returns (bool) {
189         return now > deadline(id);
190     }
191 
192     function deposit() note payable {
193     }
194 
195     function propose(
196         address  target,
197         bytes    calldata,
198         uint     value
199     ) onlyMembers note returns (uint id) {
200         id = ++actionCount;
201 
202         actions[id].target    = target;
203         actions[id].calldata  = calldata;
204         actions[id].value     = value;
205         actions[id].deadline  = now + window;
206 
207         Proposed(id, calldata);
208     }
209 
210     function confirm(uint id) onlyMembers onlyActive(id) note {
211         assert(!confirmedBy[id][msg.sender]);
212 
213         confirmedBy[id][msg.sender] = true;
214         actions[id].confirmations++;
215 
216         Confirmed(id, msg.sender);
217     }
218 
219     function trigger(uint id) onlyMembers onlyActive(id) note {
220         assert(confirmed(id));
221 
222         actions[id].triggered = true;
223         exec(actions[id].target, actions[id].calldata, actions[id].value);
224 
225         Triggered(id);
226     }
227 
228     modifier onlyMembers {
229         assert(isMember[msg.sender]);
230         _;
231     }
232 
233     modifier onlyActive(uint id) {
234         assert(!expired(id));
235         assert(!triggered(id));
236         _;
237     }
238 
239     //------------------------------------------------------------------
240     // Legacy functions
241     //------------------------------------------------------------------
242 
243     function getInfo() constant returns (
244         uint  quorum_,
245         uint  memberCount,
246         uint  window_,
247         uint  actionCount_
248     ) {
249         return (quorum, members.length, window, actionCount);
250     }
251 
252     function getActionStatus(uint id) constant returns (
253         uint     confirmations,
254         uint     deadline,
255         bool     triggered,
256         address  target,
257         uint     value
258     ) {
259         return (
260             actions[id].confirmations,
261             actions[id].deadline,
262             actions[id].triggered,
263             actions[id].target,
264             actions[id].value
265         );
266     }
267 }
268 
269 contract DSGroupFactory is DSNote {
270     mapping (address => bool)  public  isGroup;
271 
272     function newGroup(
273         address[]  members,
274         uint       quorum,
275         uint       window
276     ) note returns (DSGroup group) {
277         group = new DSGroup(members, quorum, window);
278         isGroup[group] = true;
279     }
280 }
281 
282 contract DSMath {
283     function add(uint x, uint y) internal pure returns (uint z) {
284         require((z = x + y) >= x);
285     }
286     function sub(uint x, uint y) internal pure returns (uint z) {
287         require((z = x - y) <= x);
288     }
289     function mul(uint x, uint y) internal pure returns (uint z) {
290         require(y == 0 || (z = x * y) / y == x);
291     }
292 
293     function min(uint x, uint y) internal pure returns (uint z) {
294         return x <= y ? x : y;
295     }
296     function max(uint x, uint y) internal pure returns (uint z) {
297         return x >= y ? x : y;
298     }
299     function imin(int x, int y) internal pure returns (int z) {
300         return x <= y ? x : y;
301     }
302     function imax(int x, int y) internal pure returns (int z) {
303         return x >= y ? x : y;
304     }
305 
306     uint constant WAD = 10 ** 18;
307     uint constant RAY = 10 ** 27;
308 
309     function wmul(uint x, uint y) internal pure returns (uint z) {
310         z = add(mul(x, y), WAD / 2) / WAD;
311     }
312     function rmul(uint x, uint y) internal pure returns (uint z) {
313         z = add(mul(x, y), RAY / 2) / RAY;
314     }
315     function wdiv(uint x, uint y) internal pure returns (uint z) {
316         z = add(mul(x, WAD), y / 2) / y;
317     }
318     function rdiv(uint x, uint y) internal pure returns (uint z) {
319         z = add(mul(x, RAY), y / 2) / y;
320     }
321 
322     // This famous algorithm is called "exponentiation by squaring"
323     // and calculates x^n with x as fixed-point and n as regular unsigned.
324     //
325     // It's O(log n), instead of O(n) for naive repeated multiplication.
326     //
327     // These facts are why it works:
328     //
329     //  If n is even, then x^n = (x^2)^(n/2).
330     //  If n is odd,  then x^n = x * x^(n-1),
331     //   and applying the equation for even x gives
332     //    x^n = x * (x^2)^((n-1) / 2).
333     //
334     //  Also, EVM division is flooring and
335     //    floor[(n-1) / 2] = floor[n / 2].
336     //
337     function rpow(uint x, uint n) internal pure returns (uint z) {
338         z = n % 2 != 0 ? x : RAY;
339 
340         for (n /= 2; n != 0; n /= 2) {
341             x = rmul(x, x);
342 
343             if (n % 2 != 0) {
344                 z = rmul(z, x);
345             }
346         }
347     }
348 }
349 
350 contract DSThing is DSAuth, DSNote, DSMath {
351 
352     function S(string s) internal pure returns (bytes4) {
353         return bytes4(keccak256(s));
354     }
355 
356 }
357 
358 interface AssetInterface {
359     /*
360      * Implements ERC 20 standard.
361      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
362      * https://github.com/ethereum/EIPs/issues/20
363      *
364      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
365      *  https://github.com/ethereum/EIPs/issues/223
366      */
367 
368     // Events
369     event Approval(address indexed _owner, address indexed _spender, uint _value);
370 
371     // There is no ERC223 compatible Transfer event, with `_data` included.
372 
373     //ERC 223
374     // PUBLIC METHODS
375     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
376 
377     // ERC 20
378     // PUBLIC METHODS
379     function transfer(address _to, uint _value) public returns (bool success);
380     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
381     function approve(address _spender, uint _value) public returns (bool success);
382     // PUBLIC VIEW METHODS
383     function balanceOf(address _owner) view public returns (uint balance);
384     function allowance(address _owner, address _spender) public view returns (uint remaining);
385 }
386 
387 contract DBC {
388 
389     // MODIFIERS
390 
391     modifier pre_cond(bool condition) {
392         require(condition);
393         _;
394     }
395 
396     modifier post_cond(bool condition) {
397         _;
398         assert(condition);
399     }
400 
401     modifier invariant(bool condition) {
402         require(condition);
403         _;
404         assert(condition);
405     }
406 }
407 
408 contract Owned is DBC {
409 
410     // FIELDS
411 
412     address public owner;
413 
414     // NON-CONSTANT METHODS
415 
416     function Owned() { owner = msg.sender; }
417 
418     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
419 
420     // PRE, POST, INVARIANT CONDITIONS
421 
422     function isOwner() internal returns (bool) { return msg.sender == owner; }
423 
424 }
425 
426 contract CanonicalRegistrar is DSThing, DBC {
427 
428     // TYPES
429 
430     struct Asset {
431         bool exists; // True if asset is registered here
432         bytes32 name; // Human-readable name of the Asset as in ERC223 token standard
433         bytes8 symbol; // Human-readable symbol of the Asset as in ERC223 token standard
434         uint decimals; // Decimal, order of magnitude of precision, of the Asset as in ERC223 token standard
435         string url; // URL for additional information of Asset
436         string ipfsHash; // Same as url but for ipfs
437         address breakIn; // Break in contract on destination chain
438         address breakOut; // Break out contract on this chain; A way to leave
439         uint[] standards; // compliance with standards like ERC20, ERC223, ERC777, etc. (the uint is the standard number)
440         bytes4[] functionSignatures; // Whitelisted function signatures that can be called using `useExternalFunction` in Fund contract. Note: Adhere to a naming convention for `Fund<->Asset` as much as possible. I.e. name same concepts with the same functionSignature.
441         uint price; // Price of asset quoted against `QUOTE_ASSET` * 10 ** decimals
442         uint timestamp; // Timestamp of last price update of this asset
443     }
444 
445     struct Exchange {
446         bool exists;
447         address adapter; // adapter contract for this exchange
448         // One-time note: takesCustody is inverse case of isApproveOnly
449         bool takesCustody; // True in case of exchange implementation which requires  are approved when an order is made instead of transfer
450         bytes4[] functionSignatures; // Whitelisted function signatures that can be called using `useExternalFunction` in Fund contract. Note: Adhere to a naming convention for `Fund<->ExchangeAdapter` as much as possible. I.e. name same concepts with the same functionSignature.
451     }
452     // TODO: populate each field here
453     // TODO: add whitelistFunction function
454 
455     // FIELDS
456 
457     // Methods fields
458     mapping (address => Asset) public assetInformation;
459     address[] public registeredAssets;
460 
461     mapping (address => Exchange) public exchangeInformation;
462     address[] public registeredExchanges;
463 
464     // METHODS
465 
466     // PUBLIC METHODS
467 
468     /// @notice Registers an Asset information entry
469     /// @dev Pre: Only registrar owner should be able to register
470     /// @dev Post: Address ofAsset is registered
471     /// @param ofAsset Address of asset to be registered
472     /// @param inputName Human-readable name of the Asset as in ERC223 token standard
473     /// @param inputSymbol Human-readable symbol of the Asset as in ERC223 token standard
474     /// @param inputDecimals Human-readable symbol of the Asset as in ERC223 token standard
475     /// @param inputUrl Url for extended information of the asset
476     /// @param inputIpfsHash Same as url but for ipfs
477     /// @param breakInBreakOut Address of break in and break out contracts on destination chain
478     /// @param inputStandards Integers of EIP standards this asset adheres to
479     /// @param inputFunctionSignatures Function signatures for whitelisted asset functions
480     function registerAsset(
481         address ofAsset,
482         bytes32 inputName,
483         bytes8 inputSymbol,
484         uint inputDecimals,
485         string inputUrl,
486         string inputIpfsHash,
487         address[2] breakInBreakOut,
488         uint[] inputStandards,
489         bytes4[] inputFunctionSignatures
490     )
491         auth
492         pre_cond(!assetInformation[ofAsset].exists)
493     {
494         assetInformation[ofAsset].exists = true;
495         registeredAssets.push(ofAsset);
496         updateAsset(
497             ofAsset,
498             inputName,
499             inputSymbol,
500             inputDecimals,
501             inputUrl,
502             inputIpfsHash,
503             breakInBreakOut,
504             inputStandards,
505             inputFunctionSignatures
506         );
507         assert(assetInformation[ofAsset].exists);
508     }
509 
510     /// @notice Register an exchange information entry
511     /// @dev Pre: Only registrar owner should be able to register
512     /// @dev Post: Address ofExchange is registered
513     /// @param ofExchange Address of the exchange
514     /// @param ofExchangeAdapter Address of exchange adapter for this exchange
515     /// @param inputTakesCustody Whether this exchange takes custody of tokens before trading
516     /// @param inputFunctionSignatures Function signatures for whitelisted exchange functions
517     function registerExchange(
518         address ofExchange,
519         address ofExchangeAdapter,
520         bool inputTakesCustody,
521         bytes4[] inputFunctionSignatures
522     )
523         auth
524         pre_cond(!exchangeInformation[ofExchange].exists)
525     {
526         exchangeInformation[ofExchange].exists = true;
527         registeredExchanges.push(ofExchange);
528         updateExchange(
529             ofExchange,
530             ofExchangeAdapter,
531             inputTakesCustody,
532             inputFunctionSignatures
533         );
534         assert(exchangeInformation[ofExchange].exists);
535     }
536 
537     /// @notice Updates description information of a registered Asset
538     /// @dev Pre: Owner can change an existing entry
539     /// @dev Post: Changed Name, Symbol, URL and/or IPFSHash
540     /// @param ofAsset Address of the asset to be updated
541     /// @param inputName Human-readable name of the Asset as in ERC223 token standard
542     /// @param inputSymbol Human-readable symbol of the Asset as in ERC223 token standard
543     /// @param inputUrl Url for extended information of the asset
544     /// @param inputIpfsHash Same as url but for ipfs
545     function updateAsset(
546         address ofAsset,
547         bytes32 inputName,
548         bytes8 inputSymbol,
549         uint inputDecimals,
550         string inputUrl,
551         string inputIpfsHash,
552         address[2] ofBreakInBreakOut,
553         uint[] inputStandards,
554         bytes4[] inputFunctionSignatures
555     )
556         auth
557         pre_cond(assetInformation[ofAsset].exists)
558     {
559         Asset asset = assetInformation[ofAsset];
560         asset.name = inputName;
561         asset.symbol = inputSymbol;
562         asset.decimals = inputDecimals;
563         asset.url = inputUrl;
564         asset.ipfsHash = inputIpfsHash;
565         asset.breakIn = ofBreakInBreakOut[0];
566         asset.breakOut = ofBreakInBreakOut[1];
567         asset.standards = inputStandards;
568         asset.functionSignatures = inputFunctionSignatures;
569     }
570 
571     function updateExchange(
572         address ofExchange,
573         address ofExchangeAdapter,
574         bool inputTakesCustody,
575         bytes4[] inputFunctionSignatures
576     )
577         auth
578         pre_cond(exchangeInformation[ofExchange].exists)
579     {
580         Exchange exchange = exchangeInformation[ofExchange];
581         exchange.adapter = ofExchangeAdapter;
582         exchange.takesCustody = inputTakesCustody;
583         exchange.functionSignatures = inputFunctionSignatures;
584     }
585 
586     // TODO: check max size of array before remaking this becomes untenable
587     /// @notice Deletes an existing entry
588     /// @dev Owner can delete an existing entry
589     /// @param ofAsset address for which specific information is requested
590     function removeAsset(
591         address ofAsset,
592         uint assetIndex
593     )
594         auth
595         pre_cond(assetInformation[ofAsset].exists)
596     {
597         require(registeredAssets[assetIndex] == ofAsset);
598         delete assetInformation[ofAsset]; // Sets exists boolean to false
599         delete registeredAssets[assetIndex];
600         for (uint i = assetIndex; i < registeredAssets.length-1; i++) {
601             registeredAssets[i] = registeredAssets[i+1];
602         }
603         registeredAssets.length--;
604         assert(!assetInformation[ofAsset].exists);
605     }
606 
607     /// @notice Deletes an existing entry
608     /// @dev Owner can delete an existing entry
609     /// @param ofExchange address for which specific information is requested
610     /// @param exchangeIndex index of the exchange in array
611     function removeExchange(
612         address ofExchange,
613         uint exchangeIndex
614     )
615         auth
616         pre_cond(exchangeInformation[ofExchange].exists)
617     {
618         require(registeredExchanges[exchangeIndex] == ofExchange);
619         delete exchangeInformation[ofExchange];
620         delete registeredExchanges[exchangeIndex];
621         for (uint i = exchangeIndex; i < registeredExchanges.length-1; i++) {
622             registeredExchanges[i] = registeredExchanges[i+1];
623         }
624         registeredExchanges.length--;
625         assert(!exchangeInformation[ofExchange].exists);
626     }
627 
628     // PUBLIC VIEW METHODS
629 
630     // get asset specific information
631     function getName(address ofAsset) view returns (bytes32) { return assetInformation[ofAsset].name; }
632     function getSymbol(address ofAsset) view returns (bytes8) { return assetInformation[ofAsset].symbol; }
633     function getDecimals(address ofAsset) view returns (uint) { return assetInformation[ofAsset].decimals; }
634     function assetIsRegistered(address ofAsset) view returns (bool) { return assetInformation[ofAsset].exists; }
635     function getRegisteredAssets() view returns (address[]) { return registeredAssets; }
636     function assetMethodIsAllowed(
637         address ofAsset, bytes4 querySignature
638     )
639         returns (bool)
640     {
641         bytes4[] memory signatures = assetInformation[ofAsset].functionSignatures;
642         for (uint i = 0; i < signatures.length; i++) {
643             if (signatures[i] == querySignature) {
644                 return true;
645             }
646         }
647         return false;
648     }
649 
650     // get exchange-specific information
651     function exchangeIsRegistered(address ofExchange) view returns (bool) { return exchangeInformation[ofExchange].exists; }
652     function getRegisteredExchanges() view returns (address[]) { return registeredExchanges; }
653     function getExchangeInformation(address ofExchange)
654         view
655         returns (address, bool)
656     {
657         Exchange exchange = exchangeInformation[ofExchange];
658         return (
659             exchange.adapter,
660             exchange.takesCustody
661         );
662     }
663     function getExchangeFunctionSignatures(address ofExchange)
664         view
665         returns (bytes4[])
666     {
667         return exchangeInformation[ofExchange].functionSignatures;
668     }
669     function exchangeMethodIsAllowed(
670         address ofExchange, bytes4 querySignature
671     )
672         returns (bool)
673     {
674         bytes4[] memory signatures = exchangeInformation[ofExchange].functionSignatures;
675         for (uint i = 0; i < signatures.length; i++) {
676             if (signatures[i] == querySignature) {
677                 return true;
678             }
679         }
680         return false;
681     }
682 }
683 
684 interface SimplePriceFeedInterface {
685 
686     // EVENTS
687 
688     event PriceUpdated(bytes32 hash);
689 
690     // PUBLIC METHODS
691 
692     function update(address[] ofAssets, uint[] newPrices) external;
693 
694     // PUBLIC VIEW METHODS
695 
696     // Get price feed operation specific information
697     function getQuoteAsset() view returns (address);
698     function getLastUpdateId() view returns (uint);
699     // Get asset specific information as updated in price feed
700     function getPrice(address ofAsset) view returns (uint price, uint timestamp);
701     function getPrices(address[] ofAssets) view returns (uint[] prices, uint[] timestamps);
702 }
703 
704 contract SimplePriceFeed is SimplePriceFeedInterface, DSThing, DBC {
705 
706     // TYPES
707     struct Data {
708         uint price;
709         uint timestamp;
710     }
711 
712     // FIELDS
713     mapping(address => Data) public assetsToPrices;
714 
715     // Constructor fields
716     address public QUOTE_ASSET; // Asset of a portfolio against which all other assets are priced
717 
718     // Contract-level variables
719     uint public updateId;        // Update counter for this pricefeed; used as a check during investment
720     CanonicalRegistrar public registrar;
721     CanonicalPriceFeed public superFeed;
722 
723     // METHODS
724 
725     // CONSTRUCTOR
726 
727     /// @param ofQuoteAsset Address of quote asset
728     /// @param ofRegistrar Address of canonical registrar
729     /// @param ofSuperFeed Address of superfeed
730     function SimplePriceFeed(
731         address ofRegistrar,
732         address ofQuoteAsset,
733         address ofSuperFeed
734     ) {
735         registrar = CanonicalRegistrar(ofRegistrar);
736         QUOTE_ASSET = ofQuoteAsset;
737         superFeed = CanonicalPriceFeed(ofSuperFeed);
738     }
739 
740     // EXTERNAL METHODS
741 
742     /// @dev Only Owner; Same sized input arrays
743     /// @dev Updates price of asset relative to QUOTE_ASSET
744     /** Ex:
745      *  Let QUOTE_ASSET == MLN (base units), let asset == EUR-T,
746      *  let Value of 1 EUR-T := 1 EUR == 0.080456789 MLN, hence price 0.080456789 MLN / EUR-T
747      *  and let EUR-T decimals == 8.
748      *  Input would be: information[EUR-T].price = 8045678 [MLN/ (EUR-T * 10**8)]
749      */
750     /// @param ofAssets list of asset addresses
751     /// @param newPrices list of prices for each of the assets
752     function update(address[] ofAssets, uint[] newPrices)
753         external
754         auth
755     {
756         _updatePrices(ofAssets, newPrices);
757     }
758 
759     // PUBLIC VIEW METHODS
760 
761     // Get pricefeed specific information
762     function getQuoteAsset() view returns (address) { return QUOTE_ASSET; }
763     function getLastUpdateId() view returns (uint) { return updateId; }
764 
765     /**
766     @notice Gets price of an asset multiplied by ten to the power of assetDecimals
767     @dev Asset has been registered
768     @param ofAsset Asset for which price should be returned
769     @return {
770       "price": "Price formatting: mul(exchangePrice, 10 ** decimal), to avoid floating numbers",
771       "timestamp": "When the asset's price was updated"
772     }
773     */
774     function getPrice(address ofAsset)
775         view
776         returns (uint price, uint timestamp)
777     {
778         Data data = assetsToPrices[ofAsset];
779         return (data.price, data.timestamp);
780     }
781 
782     /**
783     @notice Price of a registered asset in format (bool areRecent, uint[] prices, uint[] decimals)
784     @dev Convention for price formatting: mul(price, 10 ** decimal), to avoid floating numbers
785     @param ofAssets Assets for which prices should be returned
786     @return {
787         "prices":       "Array of prices",
788         "timestamps":   "Array of timestamps",
789     }
790     */
791     function getPrices(address[] ofAssets)
792         view
793         returns (uint[], uint[])
794     {
795         uint[] memory prices = new uint[](ofAssets.length);
796         uint[] memory timestamps = new uint[](ofAssets.length);
797         for (uint i; i < ofAssets.length; i++) {
798             var (price, timestamp) = getPrice(ofAssets[i]);
799             prices[i] = price;
800             timestamps[i] = timestamp;
801         }
802         return (prices, timestamps);
803     }
804 
805     // INTERNAL METHODS
806 
807     /// @dev Internal so that feeds inheriting this one are not obligated to have an exposed update(...) method, but can still perform updates
808     function _updatePrices(address[] ofAssets, uint[] newPrices)
809         internal
810         pre_cond(ofAssets.length == newPrices.length)
811     {
812         updateId++;
813         for (uint i = 0; i < ofAssets.length; ++i) {
814             require(registrar.assetIsRegistered(ofAssets[i]));
815             require(assetsToPrices[ofAssets[i]].timestamp != now); // prevent two updates in one block
816             assetsToPrices[ofAssets[i]].timestamp = now;
817             assetsToPrices[ofAssets[i]].price = newPrices[i];
818         }
819         emit PriceUpdated(keccak256(ofAssets, newPrices));
820     }
821 }
822 
823 contract StakingPriceFeed is SimplePriceFeed {
824 
825     OperatorStaking public stakingContract;
826     AssetInterface public stakingToken;
827 
828     // CONSTRUCTOR
829 
830     /// @param ofQuoteAsset Address of quote asset
831     /// @param ofRegistrar Address of canonical registrar
832     /// @param ofSuperFeed Address of superfeed
833     function StakingPriceFeed(
834         address ofRegistrar,
835         address ofQuoteAsset,
836         address ofSuperFeed
837     )
838         SimplePriceFeed(ofRegistrar, ofQuoteAsset, ofSuperFeed)
839     {
840         stakingContract = OperatorStaking(ofSuperFeed); // canonical feed *is* staking contract
841         stakingToken = AssetInterface(stakingContract.stakingToken());
842     }
843 
844     // EXTERNAL METHODS
845 
846     /// @param amount Number of tokens to stake for this feed
847     /// @param data Data may be needed for some future applications (can be empty for now)
848     function depositStake(uint amount, bytes data)
849         external
850         auth
851     {
852         require(stakingToken.transferFrom(msg.sender, address(this), amount));
853         require(stakingToken.approve(stakingContract, amount));
854         stakingContract.stake(amount, data);
855     }
856 
857     /// @param amount Number of tokens to unstake for this feed
858     /// @param data Data may be needed for some future applications (can be empty for now)
859     function unstake(uint amount, bytes data) {
860         stakingContract.unstake(amount, data);
861     }
862 
863     function withdrawStake()
864         external
865         auth
866     {
867         uint amountToWithdraw = stakingContract.stakeToWithdraw(address(this));
868         stakingContract.withdrawStake();
869         require(stakingToken.transfer(msg.sender, amountToWithdraw));
870     }
871 }
872 
873 contract OperatorStaking is DBC {
874 
875     // EVENTS
876 
877     event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
878     event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
879     event StakeBurned(address indexed user, uint256 amount, bytes data);
880 
881     // TYPES
882 
883     struct StakeData {
884         uint amount;
885         address staker;
886     }
887 
888     // Circular linked list
889     struct Node {
890         StakeData data;
891         uint prev;
892         uint next;
893     }
894 
895     // FIELDS
896 
897     // INTERNAL FIELDS
898     Node[] internal stakeNodes; // Sorted circular linked list nodes containing stake data (Built on top https://programtheblockchain.com/posts/2018/03/30/storage-patterns-doubly-linked-list/)
899 
900     // PUBLIC FIELDS
901     uint public minimumStake;
902     uint public numOperators;
903     uint public withdrawalDelay;
904     mapping (address => bool) public isRanked;
905     mapping (address => uint) public latestUnstakeTime;
906     mapping (address => uint) public stakeToWithdraw;
907     mapping (address => uint) public stakedAmounts;
908     uint public numStakers; // Current number of stakers (Needed because of array holes)
909     AssetInterface public stakingToken;
910 
911     // TODO: consider renaming "operator" depending on how this is implemented
912     //  (i.e. is pricefeed staking itself?)
913     function OperatorStaking(
914         AssetInterface _stakingToken,
915         uint _minimumStake,
916         uint _numOperators,
917         uint _withdrawalDelay
918     )
919         public
920     {
921         require(address(_stakingToken) != address(0));
922         stakingToken = _stakingToken;
923         minimumStake = _minimumStake;
924         numOperators = _numOperators;
925         withdrawalDelay = _withdrawalDelay;
926         StakeData memory temp = StakeData({ amount: 0, staker: address(0) });
927         stakeNodes.push(Node(temp, 0, 0));
928     }
929 
930     // METHODS : STAKING
931 
932     function stake(
933         uint amount,
934         bytes data
935     )
936         public
937         pre_cond(amount >= minimumStake)
938     {
939         uint tailNodeId = stakeNodes[0].prev;
940         stakedAmounts[msg.sender] += amount;
941         updateStakerRanking(msg.sender);
942         require(stakingToken.transferFrom(msg.sender, address(this), amount));
943     }
944 
945     function unstake(
946         uint amount,
947         bytes data
948     )
949         public
950     {
951         uint preStake = stakedAmounts[msg.sender];
952         uint postStake = preStake - amount;
953         require(postStake >= minimumStake || postStake == 0);
954         require(stakedAmounts[msg.sender] >= amount);
955         latestUnstakeTime[msg.sender] = block.timestamp;
956         stakedAmounts[msg.sender] -= amount;
957         stakeToWithdraw[msg.sender] += amount;
958         updateStakerRanking(msg.sender);
959         emit Unstaked(msg.sender, amount, stakedAmounts[msg.sender], data);
960     }
961 
962     function withdrawStake()
963         public
964         pre_cond(stakeToWithdraw[msg.sender] > 0)
965         pre_cond(block.timestamp >= latestUnstakeTime[msg.sender] + withdrawalDelay)
966     {
967         uint amount = stakeToWithdraw[msg.sender];
968         stakeToWithdraw[msg.sender] = 0;
969         require(stakingToken.transfer(msg.sender, amount));
970     }
971 
972     // VIEW FUNCTIONS
973 
974     function isValidNode(uint id) view returns (bool) {
975         // 0 is a sentinel and therefore invalid.
976         // A valid node is the head or has a previous node.
977         return id != 0 && (id == stakeNodes[0].next || stakeNodes[id].prev != 0);
978     }
979 
980     function searchNode(address staker) view returns (uint) {
981         uint current = stakeNodes[0].next;
982         while (isValidNode(current)) {
983             if (staker == stakeNodes[current].data.staker) {
984                 return current;
985             }
986             current = stakeNodes[current].next;
987         }
988         return 0;
989     }
990 
991     function isOperator(address user) view returns (bool) {
992         address[] memory operators = getOperators();
993         for (uint i; i < operators.length; i++) {
994             if (operators[i] == user) {
995                 return true;
996             }
997         }
998         return false;
999     }
1000 
1001     function getOperators()
1002         view
1003         returns (address[])
1004     {
1005         uint arrLength = (numOperators > numStakers) ?
1006             numStakers :
1007             numOperators;
1008         address[] memory operators = new address[](arrLength);
1009         uint current = stakeNodes[0].next;
1010         for (uint i; i < arrLength; i++) {
1011             operators[i] = stakeNodes[current].data.staker;
1012             current = stakeNodes[current].next;
1013         }
1014         return operators;
1015     }
1016 
1017     function getStakersAndAmounts()
1018         view
1019         returns (address[], uint[])
1020     {
1021         address[] memory stakers = new address[](numStakers);
1022         uint[] memory amounts = new uint[](numStakers);
1023         uint current = stakeNodes[0].next;
1024         for (uint i; i < numStakers; i++) {
1025             stakers[i] = stakeNodes[current].data.staker;
1026             amounts[i] = stakeNodes[current].data.amount;
1027             current = stakeNodes[current].next;
1028         }
1029         return (stakers, amounts);
1030     }
1031 
1032     function totalStakedFor(address user)
1033         view
1034         returns (uint)
1035     {
1036         return stakedAmounts[user];
1037     }
1038 
1039     // INTERNAL METHODS
1040 
1041     // DOUBLY-LINKED LIST
1042 
1043     function insertNodeSorted(uint amount, address staker) internal returns (uint) {
1044         uint current = stakeNodes[0].next;
1045         if (current == 0) return insertNodeAfter(0, amount, staker);
1046         while (isValidNode(current)) {
1047             if (amount > stakeNodes[current].data.amount) {
1048                 break;
1049             }
1050             current = stakeNodes[current].next;
1051         }
1052         return insertNodeBefore(current, amount, staker);
1053     }
1054 
1055     function insertNodeAfter(uint id, uint amount, address staker) internal returns (uint newID) {
1056 
1057         // 0 is allowed here to insert at the beginning.
1058         require(id == 0 || isValidNode(id));
1059 
1060         Node storage node = stakeNodes[id];
1061 
1062         stakeNodes.push(Node({
1063             data: StakeData(amount, staker),
1064             prev: id,
1065             next: node.next
1066         }));
1067 
1068         newID = stakeNodes.length - 1;
1069 
1070         stakeNodes[node.next].prev = newID;
1071         node.next = newID;
1072         numStakers++;
1073     }
1074 
1075     function insertNodeBefore(uint id, uint amount, address staker) internal returns (uint) {
1076         return insertNodeAfter(stakeNodes[id].prev, amount, staker);
1077     }
1078 
1079     function removeNode(uint id) internal {
1080         require(isValidNode(id));
1081 
1082         Node storage node = stakeNodes[id];
1083 
1084         stakeNodes[node.next].prev = node.prev;
1085         stakeNodes[node.prev].next = node.next;
1086 
1087         delete stakeNodes[id];
1088         numStakers--;
1089     }
1090 
1091     // UPDATING OPERATORS
1092 
1093     function updateStakerRanking(address _staker) internal {
1094         uint newStakedAmount = stakedAmounts[_staker];
1095         if (newStakedAmount == 0) {
1096             isRanked[_staker] = false;
1097             removeStakerFromArray(_staker);
1098         } else if (isRanked[_staker]) {
1099             removeStakerFromArray(_staker);
1100             insertNodeSorted(newStakedAmount, _staker);
1101         } else {
1102             isRanked[_staker] = true;
1103             insertNodeSorted(newStakedAmount, _staker);
1104         }
1105     }
1106 
1107     function removeStakerFromArray(address _staker) internal {
1108         uint id = searchNode(_staker);
1109         require(id > 0);
1110         removeNode(id);
1111     }
1112 
1113 }
1114 
1115 contract CanonicalPriceFeed is OperatorStaking, SimplePriceFeed, CanonicalRegistrar {
1116 
1117     // EVENTS
1118     event SetupPriceFeed(address ofPriceFeed);
1119 
1120     struct HistoricalPrices {
1121         address[] assets;
1122         uint[] prices;
1123         uint timestamp;
1124     }
1125 
1126     // FIELDS
1127     bool public updatesAreAllowed = true;
1128     uint public minimumPriceCount = 1;
1129     uint public VALIDITY;
1130     uint public INTERVAL;
1131     mapping (address => bool) public isStakingFeed; // If the Staking Feed has been created through this contract
1132     HistoricalPrices[] public priceHistory;
1133 
1134     // METHODS
1135 
1136     // CONSTRUCTOR
1137 
1138     /// @dev Define and register a quote asset against which all prices are measured/based against
1139     /// @param ofStakingAsset Address of staking asset (may or may not be quoteAsset)
1140     /// @param ofQuoteAsset Address of quote asset
1141     /// @param quoteAssetName Name of quote asset
1142     /// @param quoteAssetSymbol Symbol for quote asset
1143     /// @param quoteAssetDecimals Decimal places for quote asset
1144     /// @param quoteAssetUrl URL related to quote asset
1145     /// @param quoteAssetIpfsHash IPFS hash associated with quote asset
1146     /// @param quoteAssetBreakInBreakOut Break-in/break-out for quote asset on destination chain
1147     /// @param quoteAssetStandards EIP standards quote asset adheres to
1148     /// @param quoteAssetFunctionSignatures Whitelisted functions of quote asset contract
1149     // /// @param interval Number of seconds between pricefeed updates (this interval is not enforced on-chain, but should be followed by the datafeed maintainer)
1150     // /// @param validity Number of seconds that datafeed update information is valid for
1151     /// @param ofGovernance Address of contract governing the Canonical PriceFeed
1152     function CanonicalPriceFeed(
1153         address ofStakingAsset,
1154         address ofQuoteAsset, // Inital entry in asset registrar contract is Melon (QUOTE_ASSET)
1155         bytes32 quoteAssetName,
1156         bytes8 quoteAssetSymbol,
1157         uint quoteAssetDecimals,
1158         string quoteAssetUrl,
1159         string quoteAssetIpfsHash,
1160         address[2] quoteAssetBreakInBreakOut,
1161         uint[] quoteAssetStandards,
1162         bytes4[] quoteAssetFunctionSignatures,
1163         uint[2] updateInfo, // interval, validity
1164         uint[3] stakingInfo, // minStake, numOperators, unstakeDelay
1165         address ofGovernance
1166     )
1167         OperatorStaking(
1168             AssetInterface(ofStakingAsset), stakingInfo[0], stakingInfo[1], stakingInfo[2]
1169         )
1170         SimplePriceFeed(address(this), ofQuoteAsset, address(0))
1171     {
1172         registerAsset(
1173             ofQuoteAsset,
1174             quoteAssetName,
1175             quoteAssetSymbol,
1176             quoteAssetDecimals,
1177             quoteAssetUrl,
1178             quoteAssetIpfsHash,
1179             quoteAssetBreakInBreakOut,
1180             quoteAssetStandards,
1181             quoteAssetFunctionSignatures
1182         );
1183         INTERVAL = updateInfo[0];
1184         VALIDITY = updateInfo[1];
1185         setOwner(ofGovernance);
1186     }
1187 
1188     // EXTERNAL METHODS
1189 
1190     /// @notice Create a new StakingPriceFeed
1191     function setupStakingPriceFeed() external {
1192         address ofStakingPriceFeed = new StakingPriceFeed(
1193             address(this),
1194             stakingToken,
1195             address(this)
1196         );
1197         isStakingFeed[ofStakingPriceFeed] = true;
1198         StakingPriceFeed(ofStakingPriceFeed).setOwner(msg.sender);
1199         emit SetupPriceFeed(ofStakingPriceFeed);
1200     }
1201 
1202     /// @dev override inherited update function to prevent manual update from authority
1203     function update() external { revert(); }
1204 
1205     /// @dev Burn state for a pricefeed operator
1206     /// @param user Address of pricefeed operator to burn the stake from
1207     function burnStake(address user)
1208         external
1209         auth
1210     {
1211         uint totalToBurn = add(stakedAmounts[user], stakeToWithdraw[user]);
1212         stakedAmounts[user] = 0;
1213         stakeToWithdraw[user] = 0;
1214         updateStakerRanking(user);
1215         emit StakeBurned(user, totalToBurn, "");
1216     }
1217 
1218     // PUBLIC METHODS
1219 
1220     // STAKING
1221 
1222     function stake(
1223         uint amount,
1224         bytes data
1225     )
1226         public
1227         pre_cond(isStakingFeed[msg.sender])
1228     {
1229         OperatorStaking.stake(amount, data);
1230     }
1231 
1232     // function stakeFor(
1233     //     address user,
1234     //     uint amount,
1235     //     bytes data
1236     // )
1237     //     public
1238     //     pre_cond(isStakingFeed[user])
1239     // {
1240 
1241     //     OperatorStaking.stakeFor(user, amount, data);
1242     // }
1243 
1244     // AGGREGATION
1245 
1246     /// @dev Only Owner; Same sized input arrays
1247     /// @dev Updates price of asset relative to QUOTE_ASSET
1248     /** Ex:
1249      *  Let QUOTE_ASSET == MLN (base units), let asset == EUR-T,
1250      *  let Value of 1 EUR-T := 1 EUR == 0.080456789 MLN, hence price 0.080456789 MLN / EUR-T
1251      *  and let EUR-T decimals == 8.
1252      *  Input would be: information[EUR-T].price = 8045678 [MLN/ (EUR-T * 10**8)]
1253      */
1254     /// @param ofAssets list of asset addresses
1255     function collectAndUpdate(address[] ofAssets)
1256         public
1257         auth
1258         pre_cond(updatesAreAllowed)
1259     {
1260         uint[] memory newPrices = pricesToCommit(ofAssets);
1261         priceHistory.push(
1262             HistoricalPrices({assets: ofAssets, prices: newPrices, timestamp: block.timestamp})
1263         );
1264         _updatePrices(ofAssets, newPrices);
1265     }
1266 
1267     function pricesToCommit(address[] ofAssets)
1268         view
1269         returns (uint[])
1270     {
1271         address[] memory operators = getOperators();
1272         uint[] memory newPrices = new uint[](ofAssets.length);
1273         for (uint i = 0; i < ofAssets.length; i++) {
1274             uint[] memory assetPrices = new uint[](operators.length);
1275             for (uint j = 0; j < operators.length; j++) {
1276                 SimplePriceFeed feed = SimplePriceFeed(operators[j]);
1277                 var (price, timestamp) = feed.assetsToPrices(ofAssets[i]);
1278                 if (now > add(timestamp, VALIDITY)) {
1279                     continue; // leaves a zero in the array (dealt with later)
1280                 }
1281                 assetPrices[j] = price;
1282             }
1283             newPrices[i] = medianize(assetPrices);
1284         }
1285         return newPrices;
1286     }
1287 
1288     /// @dev from MakerDao medianizer contract
1289     function medianize(uint[] unsorted)
1290         view
1291         returns (uint)
1292     {
1293         uint numValidEntries;
1294         for (uint i = 0; i < unsorted.length; i++) {
1295             if (unsorted[i] != 0) {
1296                 numValidEntries++;
1297             }
1298         }
1299         if (numValidEntries < minimumPriceCount) {
1300             revert();
1301         }
1302         uint counter;
1303         uint[] memory out = new uint[](numValidEntries);
1304         for (uint j = 0; j < unsorted.length; j++) {
1305             uint item = unsorted[j];
1306             if (item != 0) {    // skip zero (invalid) entries
1307                 if (counter == 0 || item >= out[counter - 1]) {
1308                     out[counter] = item;  // item is larger than last in array (we are home)
1309                 } else {
1310                     uint k = 0;
1311                     while (item >= out[k]) {
1312                         k++;  // get to where element belongs (between smaller and larger items)
1313                     }
1314                     for (uint l = counter; l > k; l--) {
1315                         out[l] = out[l - 1];    // bump larger elements rightward to leave slot
1316                     }
1317                     out[k] = item;
1318                 }
1319                 counter++;
1320             }
1321         }
1322 
1323         uint value;
1324         if (counter % 2 == 0) {
1325             uint value1 = uint(out[(counter / 2) - 1]);
1326             uint value2 = uint(out[(counter / 2)]);
1327             value = add(value1, value2) / 2;
1328         } else {
1329             value = out[(counter - 1) / 2];
1330         }
1331         return value;
1332     }
1333 
1334     function setMinimumPriceCount(uint newCount) auth { minimumPriceCount = newCount; }
1335     function enableUpdates() auth { updatesAreAllowed = true; }
1336     function disableUpdates() auth { updatesAreAllowed = false; }
1337 
1338     // PUBLIC VIEW METHODS
1339 
1340     // FEED INFORMATION
1341 
1342     function getQuoteAsset() view returns (address) { return QUOTE_ASSET; }
1343     function getInterval() view returns (uint) { return INTERVAL; }
1344     function getValidity() view returns (uint) { return VALIDITY; }
1345     function getLastUpdateId() view returns (uint) { return updateId; }
1346 
1347     // PRICES
1348 
1349     /// @notice Whether price of asset has been updated less than VALIDITY seconds ago
1350     /// @param ofAsset Asset in registrar
1351     /// @return isRecent Price information ofAsset is recent
1352     function hasRecentPrice(address ofAsset)
1353         view
1354         pre_cond(assetIsRegistered(ofAsset))
1355         returns (bool isRecent)
1356     {
1357         var ( , timestamp) = getPrice(ofAsset);
1358         return (sub(now, timestamp) <= VALIDITY);
1359     }
1360 
1361     /// @notice Whether prices of assets have been updated less than VALIDITY seconds ago
1362     /// @param ofAssets All assets in registrar
1363     /// @return isRecent Price information ofAssets array is recent
1364     function hasRecentPrices(address[] ofAssets)
1365         view
1366         returns (bool areRecent)
1367     {
1368         for (uint i; i < ofAssets.length; i++) {
1369             if (!hasRecentPrice(ofAssets[i])) {
1370                 return false;
1371             }
1372         }
1373         return true;
1374     }
1375 
1376     function getPriceInfo(address ofAsset)
1377         view
1378         returns (bool isRecent, uint price, uint assetDecimals)
1379     {
1380         isRecent = hasRecentPrice(ofAsset);
1381         (price, ) = getPrice(ofAsset);
1382         assetDecimals = getDecimals(ofAsset);
1383     }
1384 
1385     /**
1386     @notice Gets inverted price of an asset
1387     @dev Asset has been initialised and its price is non-zero
1388     @dev Existing price ofAssets quoted in QUOTE_ASSET (convention)
1389     @param ofAsset Asset for which inverted price should be return
1390     @return {
1391         "isRecent": "Whether the price is fresh, given VALIDITY interval",
1392         "invertedPrice": "Price based (instead of quoted) against QUOTE_ASSET",
1393         "assetDecimals": "Decimal places for this asset"
1394     }
1395     */
1396     function getInvertedPriceInfo(address ofAsset)
1397         view
1398         returns (bool isRecent, uint invertedPrice, uint assetDecimals)
1399     {
1400         uint inputPrice;
1401         // inputPrice quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
1402         (isRecent, inputPrice, assetDecimals) = getPriceInfo(ofAsset);
1403 
1404         // outputPrice based in QUOTE_ASSET and multiplied by 10 ** quoteDecimal
1405         uint quoteDecimals = getDecimals(QUOTE_ASSET);
1406 
1407         return (
1408             isRecent,
1409             mul(10 ** uint(quoteDecimals), 10 ** uint(assetDecimals)) / inputPrice,
1410             quoteDecimals   // TODO: check on this; shouldn't it be assetDecimals?
1411         );
1412     }
1413 
1414     /**
1415     @notice Gets reference price of an asset pair
1416     @dev One of the address is equal to quote asset
1417     @dev either ofBase == QUOTE_ASSET or ofQuote == QUOTE_ASSET
1418     @param ofBase Address of base asset
1419     @param ofQuote Address of quote asset
1420     @return {
1421         "isRecent": "Whether the price is fresh, given VALIDITY interval",
1422         "referencePrice": "Reference price",
1423         "decimal": "Decimal places for this asset"
1424     }
1425     */
1426     function getReferencePriceInfo(address ofBase, address ofQuote)
1427         view
1428         returns (bool isRecent, uint referencePrice, uint decimal)
1429     {
1430         if (getQuoteAsset() == ofQuote) {
1431             (isRecent, referencePrice, decimal) = getPriceInfo(ofBase);
1432         } else if (getQuoteAsset() == ofBase) {
1433             (isRecent, referencePrice, decimal) = getInvertedPriceInfo(ofQuote);
1434         } else {
1435             revert(); // no suitable reference price available
1436         }
1437     }
1438 
1439     /// @notice Gets price of Order
1440     /// @param sellAsset Address of the asset to be sold
1441     /// @param buyAsset Address of the asset to be bought
1442     /// @param sellQuantity Quantity in base units being sold of sellAsset
1443     /// @param buyQuantity Quantity in base units being bought of buyAsset
1444     /// @return orderPrice Price as determined by an order
1445     function getOrderPriceInfo(
1446         address sellAsset,
1447         address buyAsset,
1448         uint sellQuantity,
1449         uint buyQuantity
1450     )
1451         view
1452         returns (uint orderPrice)
1453     {
1454         return mul(buyQuantity, 10 ** uint(getDecimals(sellAsset))) / sellQuantity;
1455     }
1456 
1457     /// @notice Checks whether data exists for a given asset pair
1458     /// @dev Prices are only upated against QUOTE_ASSET
1459     /// @param sellAsset Asset for which check to be done if data exists
1460     /// @param buyAsset Asset for which check to be done if data exists
1461     /// @return Whether assets exist for given asset pair
1462     function existsPriceOnAssetPair(address sellAsset, address buyAsset)
1463         view
1464         returns (bool isExistent)
1465     {
1466         return
1467             hasRecentPrice(sellAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
1468             hasRecentPrice(buyAsset) && // Is tradable asset (TODO cleaner) and datafeed delivering data
1469             (buyAsset == QUOTE_ASSET || sellAsset == QUOTE_ASSET) && // One asset must be QUOTE_ASSET
1470             (buyAsset != QUOTE_ASSET || sellAsset != QUOTE_ASSET); // Pair must consists of diffrent assets
1471     }
1472 
1473     /// @return Sparse array of addresses of owned pricefeeds
1474     function getPriceFeedsByOwner(address _owner)
1475         view
1476         returns(address[])
1477     {
1478         address[] memory ofPriceFeeds = new address[](numStakers);
1479         if (numStakers == 0) return ofPriceFeeds;
1480         uint current = stakeNodes[0].next;
1481         for (uint i; i < numStakers; i++) {
1482             StakingPriceFeed stakingFeed = StakingPriceFeed(stakeNodes[current].data.staker);
1483             if (stakingFeed.owner() == _owner) {
1484                 ofPriceFeeds[i] = address(stakingFeed);
1485             }
1486             current = stakeNodes[current].next;
1487         }
1488         return ofPriceFeeds;
1489     }
1490 
1491     function getHistoryLength() returns (uint) { return priceHistory.length; }
1492 
1493     function getHistoryAt(uint id) returns (address[], uint[], uint) {
1494         address[] memory assets = priceHistory[id].assets;
1495         uint[] memory prices = priceHistory[id].prices;
1496         uint timestamp = priceHistory[id].timestamp;
1497         return (assets, prices, timestamp);
1498     }
1499 }
1500 
1501 interface VersionInterface {
1502 
1503     // EVENTS
1504 
1505     event FundUpdated(uint id);
1506 
1507     // PUBLIC METHODS
1508 
1509     function shutDown() external;
1510 
1511     function setupFund(
1512         bytes32 ofFundName,
1513         address ofQuoteAsset,
1514         uint ofManagementFee,
1515         uint ofPerformanceFee,
1516         address ofCompliance,
1517         address ofRiskMgmt,
1518         address[] ofExchanges,
1519         address[] ofDefaultAssets,
1520         uint8 v,
1521         bytes32 r,
1522         bytes32 s
1523     );
1524     function shutDownFund(address ofFund);
1525 
1526     // PUBLIC VIEW METHODS
1527 
1528     function getNativeAsset() view returns (address);
1529     function getFundById(uint withId) view returns (address);
1530     function getLastFundId() view returns (uint);
1531     function getFundByManager(address ofManager) view returns (address);
1532     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed);
1533 
1534 }