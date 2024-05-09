1 pragma solidity ^0.4.25;
2 
3 /* Interface for the DMEX base contract */
4 contract DMEX_Base {
5     function getReserve(address token, address user) returns (uint256);
6     function setReserve(address token, address user, uint256 amount) returns (bool);
7 
8     function availableBalanceOf(address token, address user) returns (uint256);
9     function balanceOf(address token, address user) returns (uint256);
10 
11     function setBalance(address token, address user, uint256 amount) returns (bool);
12     function getInactivityReleasePeriod() returns (uint256);
13     function getMakerTakerBalances(address token, address maker, address taker) returns (uint256[4]);
14 
15     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) returns (bool);
16     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) returns (bool);
17     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) returns (bool);
18     
19 }
20 
21 // The DMEX Trading Contract
22 contract DMEX_Trading {
23     function assert(bool assertion) pure {
24         
25         if (!assertion) {
26             throw;
27         }
28     }
29 
30     // Safe Multiply Function - prevents integer overflow 
31     function safeMul(uint a, uint b) pure returns (uint) {
32         uint c = a * b;
33         assert(a == 0 || c / a == b);
34         return c;
35     }
36 
37     // Safe Subtraction Function - prevents integer overflow 
38     function safeSub(uint a, uint b) pure returns (uint) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     // Safe Addition Function - prevents integer overflow 
44     function safeAdd(uint a, uint b) pure returns (uint) {
45         uint c = a + b;
46         assert(c>=a && c>=b);
47         return c;
48     }
49 
50     address public owner; // holds the address of the contract owner
51 
52     // Event fired when the owner of the contract is changed
53     event SetOwner(address indexed previousOwner, address indexed newOwner);
54 
55     // Allows only the owner of the contract to execute the function
56     modifier onlyOwner {
57         assert(msg.sender == owner);
58         _;
59     }
60 
61     // Allows only the owner of the contract to execute the function
62     modifier onlyOracle {
63         assert(msg.sender == DmexOracleContract);
64         _;
65     }
66 
67     // Changes the owner of the contract
68     function setOwner(address newOwner) onlyOwner {
69         emit SetOwner(owner, newOwner);
70         owner = newOwner;
71     }
72 
73     mapping (address => bool) public admins;                    // mapping of admin addresses
74     mapping (address => bool) public pools;                     // mapping of liquidity pool addresses
75     mapping (bytes32 => uint256) public orderFills;             // mapping of orders to filled qunatity
76     mapping (bytes32 => mapping(uint256 => uint256)) public assetPrices; // mapping of assetHashes to block numbers to prices
77 
78 
79     address public feeAccount;          // the account that receives the trading fees
80     address public exchangeContract;    // the address of the DMEX_Base contract
81     address public DmexOracleContract;  // the address of the DMEX oracle contract
82 
83     uint256 public makerFee;            // maker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
84     uint256 public takerFee;            // taker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
85     
86     uint256 public fundingInterval = 2057;     // the interval in blocks when funding fee is charged
87 
88     bool public feeAccountChangeDisabled = false; // if true, fee account can't be changed
89 
90     struct FuturesAsset {
91         address baseToken;              // the token for collateral
92         string priceUrl;                // the url where the price of the asset will be taken for settlement
93         string pricePath;               // price path in the returned JSON from the priceUrl (ex. path "last" will return tha value last from the json: {"high": "156.49", "last": "154.31", "timestamp": "1556522201", "bid": "154.22", "vwap": "154.65", "volume": "25578.79138868", "low": "152.33", "ask": "154.26", "open": "152.99"})
94         bool disabled;                  // if true, the asset cannot be used in contract creation (when price url no longer valid)
95         uint256 decimals;               // number of decimals in the price            
96     }
97 
98     function createFuturesAsset(address baseToken, string priceUrl, string pricePath, uint256 decimals) onlyAdmin returns (bytes32)
99     {    
100         bytes32 futuresAsset = keccak256(this, baseToken, priceUrl, pricePath, decimals);
101         if (futuresAssets[futuresAsset].disabled) throw; // asset already exists and is disabled
102         
103         futuresAssets[futuresAsset] = FuturesAsset({
104             baseToken           : baseToken,
105             priceUrl            : priceUrl,
106             pricePath           : pricePath,
107             disabled            : false,
108             decimals            : decimals            
109         });
110 
111         //emit FuturesAssetCreated(futuresAsset, baseToken, priceUrl, pricePath, decimals);
112         return futuresAsset;
113     }
114     
115     struct FuturesContract {
116         bytes32 asset;                  // the hash of the underlying asset object
117         uint256 expirationBlock;        // futures contract expiration block
118         uint256 closingPrice;           // the closing price for the futures contract
119         bool closed;                    // is the futures contract closed (0 - false, 1 - true)
120         bool broken;                    // if someone has forced release of funds the contract is marked as broken and can no longer close positions (0-false, 1-true)
121         uint256 multiplier;             // the multiplier price, normally the ETHUSD price * 1e8
122         uint256 fundingRate;            // funding rate expressed as proportion per block * 1e18
123         uint256 closingBlock;           // the block in which the contract was closed
124         bool perpetual;                 // true if contract is perpetual
125         uint256 maintenanceMargin;      // the maintenance margin coef 1e8
126     }
127 
128     function createFuturesContract(bytes32 asset, uint256 expirationBlock, uint256 multiplier, uint256 fundingRate, bool perpetual, uint256 maintenanceMargin) onlyAdmin returns (bytes32)
129     {    
130         bytes32 futuresContract = keccak256(this, asset, expirationBlock, multiplier, fundingRate, perpetual, maintenanceMargin);
131         
132         futuresContracts[futuresContract] = FuturesContract({
133             asset               : asset,
134             expirationBlock     : expirationBlock,
135             closingPrice        : 0,
136             closed              : false,
137             broken              : false,
138             multiplier          : multiplier,
139             fundingRate         : fundingRate,
140             closingBlock        : 0,
141             perpetual           : perpetual,
142             maintenanceMargin   : maintenanceMargin
143         });
144 
145         //emit FuturesContractCreated(futuresContract, asset, expirationBlock, multiplier, fundingRate, perpetual);
146         return futuresContract;
147     }
148 
149     function getContractExpiration (bytes32 futuresContractHash) public view returns (uint256)
150     {
151         return futuresContracts[futuresContractHash].expirationBlock;
152     }
153 
154     function getContractClosed (bytes32 futuresContractHash) public view returns (bool)
155     {
156         return futuresContracts[futuresContractHash].closed;
157     }
158 
159     function getAssetDecimals (bytes32 futuresContractHash) public view returns (uint256)
160     {
161         return futuresAssets[futuresContracts[futuresContractHash].asset].decimals;
162     }
163 
164     function getContractBaseToken (bytes32 futuresContractHash) public view returns (address)
165     {
166         return futuresAssets[futuresContracts[futuresContractHash].asset].baseToken;
167     }
168 
169     function assetPricePath (bytes32 assetHash) public view returns (string)
170     {
171         return futuresAssets[assetHash].pricePath;
172     }
173 
174     function getContractPriceUrl (bytes32 futuresContractHash) returns (string)
175     {
176         return futuresAssets[futuresContracts[futuresContractHash].asset].priceUrl;
177     }
178 
179     function getContractPricePath (bytes32 futuresContractHash) returns (string)
180     {
181         return futuresAssets[futuresContracts[futuresContractHash].asset].pricePath;
182     }
183 
184     function getMaintenanceMargin (bytes32 futuresContractHash) returns (uint256)
185     {
186         return futuresContracts[futuresContractHash].maintenanceMargin;
187     }
188 
189     function setClosingPrice (bytes32 futuresContractHash, uint256 price) onlyOracle returns (bool) {
190         if (futuresContracts[futuresContractHash].closingPrice != 0) revert();
191         futuresContracts[futuresContractHash].closingPrice = price;
192         futuresContracts[futuresContractHash].closed = true;
193         futuresContracts[futuresContractHash].closingBlock = min(block.number,futuresContracts[futuresContractHash].expirationBlock);
194 
195         return true;
196     }
197 
198     function recordLatestAssetPrice (bytes32 futuresContractHash, uint256 price) onlyOracle returns (bool) {
199         assetPrices[futuresContracts[futuresContractHash].asset][block.number] = price;
200     }
201 
202     mapping (bytes32 => FuturesAsset)       public futuresAssets;      // mapping of futuresAsset hash to FuturesAsset structs
203     mapping (bytes32 => FuturesContract)    public futuresContracts;   // mapping of futuresContract hash to FuturesContract structs
204     mapping (bytes32 => uint256)            public positions;          // mapping of user addresses to position hashes to position
205 
206 
207     enum Errors {
208         /*  0 */INVALID_PRICE,                 
209         /*  1 */INVALID_SIGNATURE,                
210         /*  2 */FUTURES_CONTRACT_EXPIRED,       
211         /*  3 */UINT48_VALIDATION,
212         /*  4 */LIQUIDATION_PRICE_NOT_TOUCHED,
213         /*  5 */POOL_MISUSE
214     }
215 
216     event FuturesTrade(bool side, uint256 size, uint256 price, bytes32 indexed futuresContract, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
217     event FuturesPositionClosed(bytes32 indexed positionHash, uint256 closingPrice);
218     //event FuturesForcedRelease(bytes32 indexed futuresContract, bool side, address user);
219     event FuturesAssetCreated(bytes32 indexed futuresAsset, address baseToken, string priceUrl, string pricePath, uint256 maintenanceMargin);
220     event FuturesContractCreated(bytes32 indexed futuresContract, bytes32 asset, uint256 expirationBlock, uint256 multiplier, uint256 fundingRate, bool perpetual);
221     event PositionLiquidated(bytes32 indexed positionHash, uint256 price);
222     event FuturesMarginUpdated(address indexed user, bytes32 indexed futuresContract, bool side, uint64 marginToAdd);
223  
224     // Fee change event
225     event FeeChange(uint256 indexed makerFee, uint256 indexed takerFee);
226 
227     // Fee account changed event
228     event FeeAccountChanged(address indexed newFeeAccount);
229 
230     // Log event, logs errors in contract execution (for internal use)
231     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
232     //event LogErrorLight(uint8 errorId);
233     // event LogUint(uint8 id, uint256 value);
234     // event LogBytes(uint8 id, bytes32 value);
235 
236     // Constructor function, initializes the contract and sets the core variables
237     function DMEX_Trading(address feeAccount_, uint256 makerFee_, uint256 takerFee_, address exchangeContract_, address DmexOracleContract_, address poolAddress) {
238         owner               = msg.sender;
239         feeAccount          = feeAccount_;
240         makerFee            = makerFee_;
241         takerFee            = takerFee_;
242 
243         exchangeContract    = exchangeContract_;
244         DmexOracleContract    = DmexOracleContract_;
245 
246         pools[poolAddress] = true;
247     }
248 
249     // Changes the fees
250     function setFees(uint256 makerFee_, uint256 takerFee_) onlyOwner {
251         require(makerFee_       < 10 finney && takerFee_ < 10 finney); // The fees cannot be set higher then 1%
252         makerFee                = makerFee_;
253         takerFee                = takerFee_;
254 
255         emit FeeChange(makerFee, takerFee);
256     }
257 
258     // Change fee account
259     function changeFeeAccount (address feeAccount_) onlyOwner {
260         if (feeAccountChangeDisabled) revert();
261         feeAccount = feeAccount_;
262         emit FeeAccountChanged(feeAccount_);
263     }
264 
265     // Change thew funding interval
266     function changeFundingInterval(uint256 _newInterval) onlyOwner returns (bool _success)
267     {
268         fundingInterval = _newInterval;
269     }
270 
271     // Disable future fee account change
272     function disableFeeAccountChange() onlyOwner {
273         feeAccountChangeDisabled = true;
274     }
275 
276     // Adds or disables an admin account
277     function setAdmin(address admin, bool isAdmin) onlyOwner {
278         admins[admin] = isAdmin;
279     }
280 
281     // Adds or disables a liquidity pool address
282     function setPool(address user, bool enabled) onlyOwner public {
283         pools[user] = enabled;
284     }
285 
286     // Allows for admins only to call the function
287     modifier onlyAdmin {
288         if (msg.sender != owner && !admins[msg.sender]) throw;
289         _;
290     }
291 
292     function() external {
293         throw;
294     }   
295 
296 
297     function validateUint48(uint256 val) returns (bool)
298     {
299         if (val != uint48(val)) return false;
300         return true;
301     }
302 
303     function validateUint64(uint256 val) returns (bool)
304     {
305         if (val != uint64(val)) return false;
306         return true;
307     }
308 
309     function validateUint128(uint256 val) returns (bool)
310     {
311         if (val != uint128(val)) return false;
312         return true;
313     }
314 
315 
316     // Structure that holds order values, used inside the trade() function
317     struct FuturesOrderPair {
318         uint256 makerNonce;                 // maker order nonce, makes the order unique
319         uint256 takerNonce;                 // taker order nonce
320 
321         uint256 takerIsBuying;              // true/false taker is the buyer
322 
323         address maker;                      // address of the maker
324         address taker;                      // address of the taker
325 
326         bytes32 makerOrderHash;             // hash of the maker order
327         bytes32 takerOrderHash;             // has of the taker order
328 
329         uint256 makerAmount;                // trade amount for maker
330         uint256 takerAmount;                // trade amount for taker
331 
332         uint256 makerPrice;                 // maker order price in wei (18 decimal precision)
333         uint256 takerPrice;                 // taker order price in wei (18 decimal precision)
334 
335         uint256 makerLeverage;              // maker leverage
336         uint256 takerLeverage;              // taker leverage
337 
338         bytes32 futuresContract;            // the futures contract being traded
339 
340         address baseToken;                  // the address of the base token for futures contract
341 
342         bytes32 makerPositionHash;          // hash for maker position
343         bytes32 makerInversePositionHash;   // hash for inverse maker position 
344 
345         bytes32 takerPositionHash;          // hash for taker position
346         bytes32 takerInversePositionHash;   // hash for inverse taker position
347     }
348 
349     // Structure that holds trade values, used inside the trade() function
350     struct FuturesTradeValues {
351         uint256 qty;                    // amount to be trade
352         uint256 makerProfit;            // holds profit value
353         uint256 makerLoss;              // holds loss value
354         uint256 takerProfit;            // holds loss value
355         uint256 takerLoss;              // holds loss value
356         uint256 makerBalance;           // holds maker balance value
357         uint256 takerBalance;           // holds taker balance value
358         uint256 makerReserve;           // holds taker reserved value
359         uint256 takerReserve;           // holds taker reserved value
360         uint256 makerTradeCollateral;   // holds maker collateral value for trade
361         uint256 takerTradeCollateral;   // holds taker collateral value for trade
362         uint256 makerFee;
363         uint256 takerFee;
364         address pool;
365         bool[3] makerBoolValues;
366         bool[3] takerBoolValues;
367     }
368 
369 
370     function generateOrderHash (bool maker, bool takerIsBuying, address user, bytes32 futuresContractHash, uint256[11] tradeValues) public view returns (bytes32)
371     {
372         if (maker)
373         {
374             //                     futuresContract      user  amount          price           side            nonce           leverage
375             return keccak256(this, futuresContractHash, user, tradeValues[4], tradeValues[6], !takerIsBuying, tradeValues[0], tradeValues[2]);
376         }
377         else
378         {
379             //                     futuresContract      user  amount          price           side            nonce           leverage
380             return keccak256(this, futuresContractHash, user, tradeValues[5], tradeValues[7],  takerIsBuying, tradeValues[1], tradeValues[8]);  
381         }
382     }
383 
384     // Executes multiple trades in one transaction, saves gas fees
385     function batchFuturesTrade(
386         uint8[2][] v,
387         bytes32[4][] rs,
388         uint256[11][] tradeValues,
389         address[3][] tradeAddresses,
390         bool[2][] boolValues,
391         uint256[5][] contractValues,
392         string priceUrl,
393         string pricePath
394     ) onlyAdmin
395     {
396         // function createFuturesAsset(address baseToken, string priceUrl, string pricePath, uint256 maintenanceMargin, uint256 decimals) onlyAdmin returns (bytes32)
397 
398         /*
399             contractValues
400             [0] expirationBlock
401             [1] multiplier
402             [2] fundingRate
403             [3] maintenanceMargin
404             [4] asset decimals
405 
406             assetStrings
407             [0] asset name
408             [1] asset priceUrl
409             [2] asset pricePath
410 
411             tradeAddresses
412             [0] maker
413             [1] taker
414             [2] asset baseToken
415 
416         */
417 
418         // perform trades
419         for (uint i = 0; i < tradeAddresses.length; i++) {
420             futuresTrade(
421                 v[i],
422                 rs[i],
423                 tradeValues[i],
424                 [tradeAddresses[i][0], tradeAddresses[i][1]],
425                 boolValues[i][0],
426                 createFuturesContract(
427                     createFuturesAsset(tradeAddresses[i][2], priceUrl, pricePath, contractValues[i][4]),
428                     contractValues[i][0], 
429                     contractValues[i][1], 
430                     contractValues[i][2], 
431                     boolValues[i][1],
432                     contractValues[i][3]
433                 )
434             );
435         }
436     }
437 
438     // Opens/closes futures positions
439     function futuresTrade(
440         uint8[2] v,
441         bytes32[4] rs,
442         uint256[11] tradeValues,
443         address[2] tradeAddresses,
444         bool takerIsBuying,
445         bytes32 futuresContractHash
446     ) onlyAdmin returns (uint filledTakerTokenAmount)
447     {
448         /* tradeValues
449           [0] makerNonce
450           [1] takerNonce
451           [2] makerLeverage
452           [3] takerIsBuying
453           [4] makerAmount
454           [5] takerAmount
455           [6] makerPrice
456           [7] takerPrice
457           [8] takerLeverage
458           [9] makerFee
459           [10] takerFee
460 
461           tradeAddresses
462           [0] maker
463           [1] taker
464         */
465 
466         FuturesOrderPair memory t  = FuturesOrderPair({
467             makerNonce      : tradeValues[0],
468             takerNonce      : tradeValues[1],
469             //takerGasFee     : tradeValues[2],
470             takerIsBuying   : tradeValues[3],
471             makerAmount     : tradeValues[4],      
472             takerAmount     : tradeValues[5],   
473             makerPrice      : tradeValues[6],         
474             takerPrice      : tradeValues[7],
475             makerLeverage   : tradeValues[2],
476             takerLeverage   : tradeValues[8],
477 
478             maker           : tradeAddresses[0],
479             taker           : tradeAddresses[1],
480 
481             makerOrderHash  : generateOrderHash(true,  takerIsBuying, tradeAddresses[0], futuresContractHash, tradeValues), // keccak256(this, futuresContractHash, tradeAddresses[0], tradeValues[4], tradeValues[6], !takerIsBuying, tradeValues[0], tradeValues[2]),
482             takerOrderHash  : generateOrderHash(false, takerIsBuying, tradeAddresses[1], futuresContractHash, tradeValues), // keccak256(this, futuresContractHash, tradeAddresses[1], tradeValues[5], tradeValues[7],  takerIsBuying, tradeValues[1], tradeValues[8]),            
483 
484             futuresContract : futuresContractHash,
485 
486             baseToken       : getContractBaseToken(futuresContractHash),
487 
488             //                                            user               futuresContractHash   side           
489             makerPositionHash           : keccak256(this, tradeAddresses[0], futuresContractHash, !takerIsBuying),
490             makerInversePositionHash    : keccak256(this, tradeAddresses[0], futuresContractHash,  takerIsBuying),
491 
492             takerPositionHash           : keccak256(this, tradeAddresses[1], futuresContractHash,  takerIsBuying),
493             takerInversePositionHash    : keccak256(this, tradeAddresses[1], futuresContractHash, !takerIsBuying)
494 
495         });
496     
497         // Valifate size and price values
498         if (!validateUint128(t.makerAmount) || !validateUint128(t.takerAmount) || !validateUint64(t.makerPrice) || !validateUint64(t.takerPrice))
499         {            
500             emit LogError(uint8(Errors.UINT48_VALIDATION), t.makerOrderHash, t.takerOrderHash);
501             return 0; 
502         }
503 
504         // Check if futures contract has expired already
505         if ((!futuresContracts[t.futuresContract].perpetual && block.number > futuresContracts[t.futuresContract].expirationBlock) || futuresContracts[t.futuresContract].closed == true || futuresContracts[t.futuresContract].broken == true)
506         {
507             emit LogError(uint8(Errors.FUTURES_CONTRACT_EXPIRED), t.makerOrderHash, t.takerOrderHash);
508             return 0; // futures contract is expired
509         }
510 
511         // Checks the signature for the maker order
512         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
513         {
514             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
515             return 0;
516         }
517 
518         // Checks the signature for the taker order
519         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
520         {
521             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
522             return 0;
523         }
524 
525         // check prices
526         if ((!takerIsBuying && t.makerPrice < t.takerPrice) || (takerIsBuying && t.takerPrice < t.makerPrice))
527         {
528             emit LogError(uint8(Errors.INVALID_PRICE), t.makerOrderHash, t.takerOrderHash);
529             return 0; // prices don't match
530         }
531 
532         // trades between pools and trades without a pool are not allowed
533         if ((pools[t.maker] && pools[t.taker]) || (!pools[t.maker] && !pools[t.taker]))
534         {
535             emit LogError(uint8(Errors.POOL_MISUSE), t.makerOrderHash, t.takerOrderHash);
536             return 0; // trade between pools
537         }           
538         
539 
540         uint256[4] memory balances = DMEX_Base(exchangeContract).getMakerTakerBalances(t.baseToken, t.maker, t.taker);
541 
542         // Initializing trade values structure 
543         FuturesTradeValues memory tv = FuturesTradeValues({
544             qty                 : 0,
545             makerBalance        : balances[0], 
546             takerBalance        : balances[1],  
547             makerReserve        : balances[2],  
548             takerReserve        : balances[3],
549             makerTradeCollateral: 0,
550             takerTradeCollateral: 0,
551             makerFee            : min(makerFee, tradeValues[9]),
552             takerFee            : min(takerFee, tradeValues[10]),
553             makerProfit         : 0,
554             makerLoss           : 0,
555             takerProfit         : 0,
556             takerLoss           : 0,
557             pool                : pools[t.maker] ? t.maker : t.taker,
558             makerBoolValues     : [false, false, false],
559             takerBoolValues     : [false, false, false]
560         });
561 
562         // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
563         // and open inverse positions
564         tv.qty = min(safeSub(t.makerAmount, orderFills[t.makerOrderHash]), safeSub(t.takerAmount, orderFills[t.takerOrderHash]));
565         
566         if (positionExists(t.makerInversePositionHash) && positionExists(t.takerInversePositionHash))
567         {
568             tv.qty = min(tv.qty, min(retrievePosition(t.makerInversePositionHash)[0], retrievePosition(t.takerInversePositionHash)[0]));
569         }
570         else if (positionExists(t.makerInversePositionHash))
571         {
572             tv.qty = min(tv.qty, retrievePosition(t.makerInversePositionHash)[0]);
573         }
574         else if (positionExists(t.takerInversePositionHash))
575         {
576             tv.qty = min(tv.qty, retrievePosition(t.takerInversePositionHash)[0]);
577         }
578 
579         tv.makerTradeCollateral = calculateCollateral(tv.qty, t.makerPrice, t.makerLeverage, t.futuresContract, tv.makerFee);
580         tv.takerTradeCollateral = calculateCollateral(tv.qty, t.makerPrice, t.takerLeverage, t.futuresContract, tv.takerFee);
581 
582         if (((!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash)) || positionExists(t.makerPositionHash)) && !pools[t.maker])
583         {
584             // check if maker has enough balance   
585             if (safeSub(tv.makerBalance,tv.makerReserve) < safeMul(tv.makerTradeCollateral, 1e10))
586             {
587                 tv.qty =    safeMul(
588                                 tv.qty,                                
589                                 safeSub(
590                                     tv.makerBalance,
591                                     tv.makerReserve
592                                 )
593                             ) 
594                             / 
595                             safeMul(tv.makerTradeCollateral, 1e10);
596             }
597         }
598 
599         if (((!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash)) || positionExists(t.takerPositionHash)) && !pools[t.taker])
600         {            
601             // check if taker has enough balance
602             if (safeSub(tv.takerBalance,tv.takerReserve) < safeMul(tv.takerTradeCollateral, 1e10))
603             {                
604                 tv.qty =    safeMul(
605                                 tv.qty,
606                                 safeSub(
607                                     tv.takerBalance,
608                                     tv.takerReserve
609                                 )  
610                             ) 
611                             / 
612                             safeMul(tv.takerTradeCollateral, 1e10);
613             }
614         }
615         
616        
617         if (!takerIsBuying) /*------------- Maker long, Taker short -------------*/
618         {       
619             // position actions for maker
620             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
621             {
622                 tv.makerBoolValues = [true, true, false]; // [newPosition, side, increasePositon]
623             } else {               
624                 
625                 if (positionExists(t.makerPositionHash))
626                 {
627                     // increase position size
628                     tv.makerBoolValues = [false, true, true]; // [newPosition, side, increasePositon]
629                 }
630                 else
631                 {
632                     // close/partially close existing position
633                     if (t.makerPrice < retrievePosition(t.makerInversePositionHash)[1])
634                     {
635                         // user has made a profit
636                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);
637                     }
638                     else
639                     {
640                         // user has made a loss
641                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                        
642                     }
643 
644                     tv.makerBoolValues = [false, true, false]; // [newPosition, side, increasePositon]
645                 }                
646             }            
647 
648             // position actions for taker
649             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
650             {        
651                 // create new position
652                 tv.takerBoolValues = [true, false, false]; // [newPosition, side, increasePositon]
653             } else {
654                 if (positionExists(t.takerPositionHash))
655                 {
656                     // increase position size
657                     tv.takerBoolValues = [false, false, true]; // [newPosition, side, increasePositon]
658                 }
659                 else
660                 {    
661                     // close/partially close existing position
662                     if (t.makerPrice > retrievePosition(t.takerInversePositionHash)[1])
663                     {
664                         // user has made a profit
665                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false);
666                     }
667                     else
668                     {
669                         // user has made a loss
670                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false); 
671                     }
672 
673                     tv.takerBoolValues = [false, false, false]; // [newPosition, side, increasePositon]
674                 }
675             }
676         }        
677         else /*------------- Maker short, Taker long -------------*/
678         {      
679             
680             // position actions for maker
681             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
682             {
683                 // create new position
684                 tv.makerBoolValues = [true, false, false]; // [newPosition, side, increasePositon]
685                 
686 
687             } else {
688                 if (positionExists(t.makerPositionHash))
689                 {
690                     // increase position size
691                     tv.makerBoolValues = [false, false, true]; // [newPosition, side, increasePositon]
692                 }
693                 else
694                 {
695                     // close/partially close existing position
696                     if (t.makerPrice > retrievePosition(t.makerInversePositionHash)[1])
697                     {
698                         // user has made a profit
699                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);
700                     }
701                     else
702                     {
703                         // user has made a loss
704                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);                               
705                     }
706 
707                     tv.makerBoolValues = [false, false, false]; // [newPosition, side, increasePositon]
708                 }
709             }    
710 
711             // position actions for taker
712             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
713             {
714                 tv.takerBoolValues = [true, true, false]; // [newPosition, side, increasePositon]
715             } else {
716                 if (positionExists(t.takerPositionHash))
717                 {
718                     // increase position size
719                     tv.takerBoolValues = [false, true, true]; // [newPosition, side, increasePositon]
720                 }
721                 else
722                 {
723 
724                     // close/partially close existing position
725                     if (t.makerPrice < retrievePosition(t.takerInversePositionHash)[1])
726                     {
727                         // user has made a profit
728                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);
729                     }
730                     else
731                     {
732                         // user has made a loss
733                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                  
734                     }   
735 
736                     tv.takerBoolValues = [false, true, false]; // [newPosition, side, increasePositon]                
737                 }
738             }                      
739         }
740 
741 
742         if (tv.makerLoss > 0)
743         {
744             if (!updateBalances(
745                     t.futuresContract, 
746                     [
747                         t.baseToken, // base token
748                         t.maker,  // user address
749                         tv.pool
750                     ], 
751                     !tv.makerBoolValues[0] && !tv.makerBoolValues[2] ? t.makerInversePositionHash : t.makerPositionHash, // position hash
752                     [
753                         tv.qty, // qty
754                         t.makerPrice, // price
755                         tv.makerFee, // fee
756                         tv.makerProfit,  // profit
757                         tv.makerLoss, // loss
758                         tv.makerBalance, // balance
759                         0, // gasFee
760                         tv.makerReserve, // reserve
761                         t.makerLeverage // leverage
762                     ], 
763                     tv.makerBoolValues
764                 )
765             )
766             {
767                 futuresContracts[t.futuresContract].broken = true;
768                 forceReleaseReserveOperation(t.futuresContract, tv.pool == t.maker ? !tv.takerBoolValues[1] : !tv.makerBoolValues[1], tv.pool == t.maker ? t.taker : t.maker);
769                 return;
770             }
771 
772             updateBalances(
773                 t.futuresContract, 
774                 [
775                     t.baseToken,   // base toke
776                     t.taker, // user address
777                     tv.pool
778                 ], 
779                 !tv.takerBoolValues[0] && !tv.takerBoolValues[2] ? t.takerInversePositionHash : t.takerPositionHash,  // position hash
780                 [
781                     tv.qty, // qty
782                     t.makerPrice, // price
783                     tv.takerFee, // fee
784                     tv.takerProfit, // profit
785                     tv.takerLoss, // loss
786                     tv.takerBalance, // balance
787                     0, // gasFee
788                     tv.takerReserve, // reserve
789                     t.takerLeverage // leverage
790                 ], 
791                 tv.takerBoolValues
792             ); 
793         }
794         else
795         {
796             if (!updateBalances(
797                     t.futuresContract, 
798                     [
799                         t.baseToken,   // base toke
800                         t.taker, // user address
801                         tv.pool
802                     ], 
803                     !tv.takerBoolValues[0] && !tv.takerBoolValues[2] ? t.takerInversePositionHash : t.takerPositionHash,  // position hash
804                     [
805                         tv.qty, // qty
806                         t.makerPrice, // price
807                         tv.takerFee, // fee
808                         tv.takerProfit, // profit
809                         tv.takerLoss, // loss
810                         tv.takerBalance, // balance
811                         0, // gasFee
812                         tv.takerReserve, // reserve
813                         t.takerLeverage // leverage
814                     ], 
815                     tv.takerBoolValues
816                 )
817             )
818             {
819                 futuresContracts[t.futuresContract].broken = true;               
820                 forceReleaseReserveOperation(t.futuresContract, tv.pool == t.maker ? !tv.takerBoolValues[1] : !tv.makerBoolValues[1], tv.pool == t.maker ? t.taker : t.maker);       
821                 return;
822             }
823 
824             updateBalances(
825                 t.futuresContract, 
826                 [
827                     t.baseToken, // base token
828                     t.maker,  // user address
829                     tv.pool
830                 ], 
831                 !tv.makerBoolValues[0] && !tv.makerBoolValues[2] ? t.makerInversePositionHash : t.makerPositionHash, // position hash
832                 [
833                     tv.qty, // qty
834                     t.makerPrice, // price
835                     tv.makerFee, // fee
836                     tv.makerProfit,  // profit
837                     tv.makerLoss, // loss
838                     tv.makerBalance, // balance
839                     0, // gasFee
840                     tv.makerReserve, // reserve
841                     t.makerLeverage // leverage
842                 ], 
843                 tv.makerBoolValues
844             ); 
845         }
846 
847         
848 
849 //--> 220 000
850         orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty); // increase the maker order filled amount
851         orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); // increase the taker order filled amount
852 
853 //--> 264 000
854         emit FuturesTrade(takerIsBuying, tv.qty, t.makerPrice, t.futuresContract, t.makerOrderHash, t.takerOrderHash);
855 
856         return tv.qty;
857     }
858 
859 
860     function calculateProfit(uint256 closingPrice, uint256 entryPrice, uint256 qty, bytes32 futuresContractHash, bool side) public view returns (uint256)
861     {
862         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
863         return safeMul(safeMul(safeSub(side ? entryPrice : closingPrice, side ? closingPrice : entryPrice), qty), multiplier )  / 1e16;            
864     }
865 
866     function calculateTradeValue(uint256 qty, uint256 price, bytes32 futuresContractHash)  public view returns (uint256)
867     {
868         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
869         return safeMul(safeMul(safeMul(qty, price), 1e2), multiplier) / 1e8 ;
870     }
871 
872     function calculateLoss(uint256 closingPrice, uint256 entryPrice, uint256 qty,  bytes32 futuresContractHash, bool side) public view returns (uint256)
873     {
874         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
875 
876         return safeMul(safeMul(safeSub(side ? closingPrice : entryPrice, side ? entryPrice : closingPrice), qty), multiplier) / 1e16 ;        
877     }
878 
879     function calculateCollateral (uint256 qty, uint256 price, uint256 leverage, bytes32 futuresContractHash, uint256 fee) view returns (uint256) // 1e8
880     {
881         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
882         uint256 collateral;
883             
884         collateral = safeMul(safeMul(price, qty), multiplier) / 1e8 / leverage;
885 
886         return safeAdd(collateral, calculateFee(qty, price, fee, futuresContractHash));               
887     }
888 
889     function calculateProportionalMargin(uint256 currQty, uint256 newQty, uint256 margin) view returns (uint256) // 1e8
890     {
891         uint256 proportionalMargin = safeMul(margin, newQty)/currQty;
892         return proportionalMargin;          
893     }
894 
895     function calculateFundingCost (uint256 price, uint256 qty, uint256 fundingBlocks, bytes32 futuresContractHash)  public view returns (uint256) // 1e8
896     {
897         uint256 fundingRate = futuresContracts[futuresContractHash].fundingRate;
898         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
899 
900         uint256 fundingCost = safeMul(safeMul(safeMul(safeMul(fundingBlocks/fundingInterval, fundingInterval), fundingRate), safeMul(qty, price)/1e8)/1e18, multiplier)/1e8;
901 
902         return fundingCost;  
903     }
904 
905     function calculateFee (uint256 qty, uint256 tradePrice, uint256 fee, bytes32 futuresContractHash)  public view returns (uint256)
906     {
907         return safeMul(calculateTradeValue(qty, tradePrice, futuresContractHash), fee / 1e10) / 1e18;
908     }  
909 
910 
911     // Update user balance
912     function updateBalances (bytes32 futuresContract, address[3] addressValues, bytes32 positionHash, uint256[9] uintValues, bool[3] boolValues) private returns (bool)
913     {
914         /*
915             addressValues
916             [0] baseToken
917             [1] user
918             [2] pool address
919 
920             uintValues
921             [0] qty
922             [1] price
923             [2] fee
924             [3] profit
925             [4] loss
926             [5] balance
927             [6] gasFee
928             [7] reserve
929             [8] leverage
930 
931             boolValues
932             [0] newPostion
933             [1] side
934             [2] increase position
935 
936         */
937 
938 
939         // pam = [fee value, collateral, fundignCost, payableFundingCost]               
940         uint256[3] memory pam = [
941             safeMul(calculateFee(uintValues[0], uintValues[1], uintValues[2], futuresContract), 1e10), 
942             calculateCollateral(uintValues[0], uintValues[1], uintValues[8], futuresContract, 0),
943             0
944         ];
945 
946 
947                
948         if (boolValues[0] || boolValues[2])  
949         {
950             // Position is new or position is increased
951             if (boolValues[0])
952             {
953                 // new position
954                 recordNewPosition(positionHash, uintValues[0], uintValues[1], boolValues[1] ? 1 : 0, block.number, pam[1]);
955             }
956             else
957             {
958                 // increase position
959                 updatePositionSize(positionHash, safeAdd(retrievePosition(positionHash)[0], uintValues[0]), uintValues[1], safeAdd(retrievePosition(positionHash)[4], pam[1]));
960             }
961 
962             
963             if (!pools[addressValues[1]])
964             {
965                 subBalanceAddReserve(addressValues[0], addressValues[1], pam[0], pam[1]);                    
966             }
967             else
968             {
969                 pam[0] = 0;
970             }
971         } 
972         else 
973         {
974             // Position exists, decreasing
975             pam[1] = calculateProportionalMargin(retrievePosition(positionHash)[0], uintValues[0], retrievePosition(positionHash)[4]);
976             
977             updatePositionSize(positionHash, safeSub(retrievePosition(positionHash)[0], uintValues[0]),  uintValues[1], safeSub(retrievePosition(positionHash)[4], pam[1]));
978 
979             pam[2] = calculateFundingCost(retrievePosition(positionHash)[1], uintValues[0], safeSub(block.number, retrievePosition(positionHash)[3]), futuresContract);   
980             
981 
982             if (pools[addressValues[1]]) {
983                 pam[0] = 0;
984                 pam[1] = 0;
985                 pam[2] = 0;
986             }
987 
988             if (uintValues[3] > 0) 
989             {
990                 // profit > 0
991                 if (safeAdd(pam[0], safeMul(pam[2], 1e10)) <= safeMul(uintValues[3],1e10))
992                 {
993                     addBalanceSubReserve(addressValues[0], addressValues[1], safeSub(safeMul(uintValues[3],1e10), safeAdd(pam[0], safeMul(pam[2], 1e10))), pam[1]);
994                 }
995                 else
996                 {
997 
998                     if (!subBalanceSubReserve(addressValues[0], addressValues[1], safeSub(safeAdd(pam[0], safeMul(pam[2], 1e10)), safeMul(uintValues[3],1e10)), pam[1]))
999                     {
1000                         return false;
1001                     }
1002                 }                
1003             } 
1004             else 
1005             {   
1006                 // loss >= 0
1007                 // deduct loss from user balance
1008                 if (!subBalanceSubReserve(addressValues[0], addressValues[1], safeAdd(safeMul(uintValues[4],1e10), safeAdd(pam[0], safeMul(pam[2], 1e10))), pam[1])) 
1009                 {
1010                     return false;
1011                 }
1012             }     
1013 
1014         }          
1015         
1016         //if (safeAdd(pam[0], safeMul(pam[2], 1e10)) > 0)
1017         if (pam[0] > 0)
1018         {
1019             addBalance(addressValues[0], feeAccount, DMEX_Base(exchangeContract).balanceOf(addressValues[0], feeAccount), pam[0]); // send fee to feeAccount
1020         }
1021 
1022         if (pam[2] > 0)
1023         {
1024             addBalance(addressValues[0], addressValues[2], DMEX_Base(exchangeContract).balanceOf(addressValues[0], addressValues[2]), safeMul(pam[2], 1e10));
1025         }
1026 
1027         return true;
1028         
1029     }
1030 
1031     function recordNewPosition (bytes32 positionHash, uint256 size, uint256 price, uint256 side, uint256 block, uint256 collateral) private
1032     {
1033         if (!validateUint64(size) || !validateUint64(price) || !validateUint64(collateral)) 
1034         {
1035             throw;
1036         }
1037 
1038         uint256 character = uint64(size);
1039         character |= price<<64;
1040         character |= collateral<<128;
1041         character |= side<<192;
1042         character |= block<<208;
1043 
1044         positions[positionHash] = character;
1045     }
1046 
1047     function retrievePosition (bytes32 positionHash) public view returns (uint256[5])
1048     {
1049         uint256 character = positions[positionHash];
1050         uint256 size = uint256(uint64(character));
1051         uint256 price = uint256(uint64(character>>64));
1052         uint256 collateral = uint256(uint64(character>>128));
1053         uint256 side = uint256(uint16(character>>192));
1054         uint256 entryBlock = uint256(uint48(character>>208));
1055 
1056         return [size, price, side, entryBlock, collateral];
1057     }
1058 
1059     function updatePositionSize(bytes32 positionHash, uint256 size, uint256 price, uint256 collateral) private
1060     {
1061         uint256[5] memory pos = retrievePosition(positionHash);
1062 
1063         if (size > pos[0])
1064         {
1065             uint256 totalValue = safeAdd(safeMul(pos[0], pos[1]), safeMul(price, safeSub(size, pos[0])));
1066             uint256 newSize = safeSub(size, pos[0]);
1067             // position is increasing in size
1068             recordNewPosition(
1069                 positionHash, 
1070                 size, 
1071                 totalValue / size, 
1072                 pos[2], 
1073                 safeAdd(safeMul(safeMul(pos[0], pos[1]), pos[3]), safeMul(safeMul(price, newSize), block.number)) / totalValue, // pos[3]
1074                 collateral
1075             );
1076         }
1077         else
1078         {
1079             // position is decreasing in size
1080             recordNewPosition(
1081                 positionHash, 
1082                 size, 
1083                 pos[1], 
1084                 pos[2], 
1085                 pos[3],
1086                 collateral
1087             );
1088         }        
1089     }
1090 
1091     function positionExists (bytes32 positionHash) internal view returns (bool)
1092     {
1093         return retrievePosition(positionHash)[0] != 0;
1094     }
1095 
1096 
1097     // This function allows the user to manually release collateral in case the oracle service does not provide the price during the inactivityReleasePeriod
1098     function forceReleaseReserve (bytes32 futuresContract, bool side, address user) public
1099     {   
1100         if (futuresContracts[futuresContract].expirationBlock == 0) revert();       
1101         if (futuresContracts[futuresContract].expirationBlock > block.number) revert();
1102         if (safeAdd(futuresContracts[futuresContract].expirationBlock, DMEX_Base(exchangeContract).getInactivityReleasePeriod()) > block.number) revert();    
1103 
1104         futuresContracts[futuresContract].broken = true;
1105         forceReleaseReserveOperation(futuresContract, side, user);
1106     }
1107 
1108     function forceReleaseReserveOperation(bytes32 futuresContract, bool side, address user) private
1109     {
1110         if (!futuresContracts[futuresContract].broken) revert();
1111         bytes32 positionHash = keccak256(this, user, futuresContract, side);
1112         uint256[5] memory pos = retrievePosition(positionHash);
1113         if (pos[0] == 0) revert();
1114         
1115         FuturesContract cont = futuresContracts[futuresContract];
1116         address baseToken = futuresAssets[cont.asset].baseToken;
1117 
1118         subReserve(
1119             baseToken, 
1120             user, 
1121             DMEX_Base(exchangeContract).getReserve(baseToken, user), 
1122             pos[4]
1123         );        
1124 
1125         updatePositionSize(positionHash, 0, 0, 0);
1126 
1127         //emit FuturesForcedRelease(futuresContract, side, user);
1128     }
1129 
1130     function addBalance(address token, address user, uint256 balance, uint256 amount) private
1131     {
1132         DMEX_Base(exchangeContract).setBalance(token, user, safeAdd(balance, amount));
1133     }
1134 
1135     function subBalance(address token, address user, uint256 balance, uint256 amount) private returns (bool)
1136     {
1137         if (balance < amount) return false;
1138         DMEX_Base(exchangeContract).setBalance(token, user, safeSub(balance, amount));
1139         return true;
1140     }
1141 
1142     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) private returns (bool)
1143     {
1144         if (!DMEX_Base(exchangeContract).subBalanceAddReserve(token, user, subBalance, safeMul(addReserve, 1e10)))
1145         {
1146             return false;
1147         }
1148 
1149         return true;
1150     }
1151 
1152     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) private returns (bool)
1153     {
1154         if (!DMEX_Base(exchangeContract).addBalanceSubReserve(token, user, addBalance, safeMul(subReserve, 1e10)))
1155         {
1156             return false;
1157         }
1158 
1159         return true;
1160     }
1161 
1162     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) private returns (bool)
1163     {
1164         if (!DMEX_Base(exchangeContract).subBalanceSubReserve(token, user, subBalance, safeMul(subReserve, 1e10)))
1165         {
1166             return false;
1167         }
1168 
1169         return true;
1170     }
1171 
1172     function subReserve(address token, address user, uint256 reserve, uint256 amount) private 
1173     {
1174         DMEX_Base(exchangeContract).setReserve(token, user, safeSub(reserve, safeMul(amount, 1e10)));
1175     }
1176 
1177     function getMakerTakerPositions(bytes32 makerPositionHash, bytes32 makerInversePositionHash, bytes32 takerPosition, bytes32 takerInversePosition) public view returns (uint256[5][4])
1178     {
1179         return [
1180             retrievePosition(makerPositionHash),
1181             retrievePosition(makerInversePositionHash),
1182             retrievePosition(takerPosition),
1183             retrievePosition(takerInversePosition)
1184         ];
1185     }
1186 
1187 
1188     struct FuturesClosePositionValues {
1189         address baseToken;
1190         uint256 reserve;                
1191         uint256 balance;                
1192         uint256 closingPrice;           
1193         bytes32 futuresContract;        
1194         uint256 expirationBlock;        
1195         uint256 entryBlock;             
1196         uint256 collateral;            
1197         uint256 totalPayable;
1198         uint256 closingBlock;
1199         uint256 liquidationPrice;
1200         uint256 closingFee;
1201         bool perpetual;
1202         uint256 profit;
1203         uint256 loss;
1204         uint256 fundingCost;
1205     }
1206 
1207 
1208     function closeFuturesPosition(bytes32 futuresContract, bool side, address poolAddress)
1209     {
1210         closeFuturesPositionInternal(futuresContract, side, msg.sender, poolAddress, takerFee);
1211     }
1212 
1213     function closeFuturesPositionInternal (bytes32 futuresContract, bool side, address user, address poolAddress, uint256 expirationFee) private returns (bool)
1214     {
1215         bytes32 positionHash = keccak256(this, user, futuresContract, side);        
1216         uint256[5] memory pos = retrievePosition(positionHash);        
1217 
1218         if (futuresContracts[futuresContract].broken) revert(); // contract broken
1219         if (futuresContracts[futuresContract].closed == false && futuresContracts[futuresContract].expirationBlock != 0) revert(); // contract not yet settled
1220         if (pos[1] == 0) revert(); // position not found
1221         if (pos[0] == 0) revert(); // position already closed
1222         if (pools[user]) return;
1223         if (!pools[poolAddress]) return;
1224 
1225         uint256 fundingBlocks = safeSub(futuresContracts[futuresContract].closingBlock, pos[3]+1);
1226         
1227         FuturesClosePositionValues memory v = FuturesClosePositionValues({
1228             baseToken       : getContractBaseToken(futuresContract),
1229             reserve         : 0,
1230             balance         : 0,
1231             closingPrice    : futuresContracts[futuresContract].closingPrice,
1232             futuresContract : futuresContract,
1233             expirationBlock : futuresContracts[futuresContract].expirationBlock,
1234             entryBlock      : pos[3],
1235             collateral      : 0,
1236             totalPayable    : 0,
1237             closingBlock    : futuresContracts[futuresContract].closingBlock,
1238             liquidationPrice: calculateLiquidationPriceFromPositionHash(futuresContract, side, user),
1239             closingFee      : calculateFee(pos[0], pos[1], min(expirationFee, takerFee), futuresContract),
1240             perpetual       : futuresContracts[futuresContract].perpetual,
1241             profit          : 0,
1242             loss            : 0,
1243             fundingCost     : calculateFundingCost(pos[1], pos[0], fundingBlocks, futuresContract)
1244         });
1245 
1246         v.reserve = DMEX_Base(exchangeContract).getReserve(v.baseToken, user);
1247         v.balance = DMEX_Base(exchangeContract).balanceOf(v.baseToken, user);
1248     
1249 
1250 
1251         if (( side && v.closingPrice <= v.liquidationPrice) ||
1252             (!side && v.closingPrice >= v.liquidationPrice) )
1253         {
1254             liquidatePositionWithClosingPrice(futuresContract, user, side, poolAddress);
1255             return;
1256         }
1257 
1258         v.collateral = pos[4];         
1259         v.totalPayable = safeAdd(v.closingFee, v.fundingCost);
1260 
1261         if (( side && v.closingPrice > pos[1]) ||
1262             (!side && v.closingPrice < pos[1]))
1263         {   
1264             // user made a profit
1265             v.profit = calculateProfit(v.closingPrice, pos[1], pos[0], futuresContract, !side);
1266       
1267             if (v.profit > safeAdd(v.fundingCost, v.closingFee/2))
1268             {
1269                 if (!subBalance(v.baseToken, poolAddress, DMEX_Base(exchangeContract).balanceOf(v.baseToken, poolAddress), safeMul(safeSub(v.profit, safeAdd(v.fundingCost, v.closingFee/2)), 1e10)))
1270                 {
1271                     // brake contract
1272                     futuresContracts[futuresContract].broken = true;
1273                     forceReleaseReserveOperation(futuresContract, side, user);
1274                     return false;
1275                 }
1276             }
1277             else
1278             {
1279                 addBalance(v.baseToken, poolAddress, DMEX_Base(exchangeContract).balanceOf(v.baseToken, poolAddress), safeMul(safeSub(safeAdd(v.fundingCost, v.closingFee/2), v.profit), 1e10)); 
1280             }
1281 
1282 
1283             if (v.profit > v.totalPayable)
1284             {
1285                 addBalance(v.baseToken, user, v.balance, safeSub(safeMul(v.profit, 1e10), safeMul(v.totalPayable, 1e10))); 
1286             }
1287             else
1288             {
1289                 subBalance(v.baseToken, user, v.balance, safeMul(min(v.collateral, safeSub(v.totalPayable, v.profit)), 1e10)); 
1290             }            
1291         }
1292         else
1293         {
1294             // user made a loss
1295             v.loss = calculateLoss(v.closingPrice, pos[1], pos[0], futuresContract, !side);  
1296    
1297             subBalance(v.baseToken, user, v.balance, safeMul(min(v.collateral, safeAdd(v.loss, v.totalPayable)), 1e10)); 
1298             addBalance(v.baseToken, poolAddress, DMEX_Base(exchangeContract).balanceOf(v.baseToken, poolAddress), safeMul(safeSub(min(v.collateral, safeAdd(v.loss, v.totalPayable)), v.closingFee/2), 1e10)); 
1299         } 
1300 
1301 
1302         subReserve(
1303             v.baseToken, 
1304             user, 
1305             v.reserve, 
1306             v.collateral
1307         ); 
1308 
1309         addBalance(v.baseToken, feeAccount, DMEX_Base(exchangeContract).balanceOf(v.baseToken, feeAccount), safeMul(v.closingFee/2, 1e10)); // send fee to feeAccount
1310 
1311         updatePositionSize(positionHash, 0, 0, 0); 
1312 
1313         // update pool position
1314         updatePositionSize(keccak256(this, poolAddress, futuresContract, !side), 0, 0, 0); 
1315 
1316         emit FuturesPositionClosed(positionHash, v.closingPrice);
1317 
1318         return true;
1319     }
1320 
1321     function generatePositionHash (address user, bytes32 futuresContractHash, bool side) public view returns (bytes32)
1322     {
1323         return keccak256(this, user, futuresContractHash, side);
1324     }
1325 
1326     // closes position for user
1327     function closeFuturesPositionForUser (bytes32 futuresContract, bool side, address user, address poolAddress, uint256 expirationFee) onlyAdmin
1328     {
1329         closeFuturesPositionInternal(futuresContract, side, user, poolAddress, expirationFee);
1330     }
1331 
1332     struct UpdateMarginValues {
1333         bytes32 newMarginHash;
1334         address baseToken;
1335     }
1336 
1337     function updateMargin(bytes32 futuresContractHash, address user, bool side, uint8 vs, bytes32 r, bytes32 s, uint64 newMargin /* 1e8 */, uint256 operationFee /* 1e18 */)
1338     {
1339         if (pools[user]) revert();
1340         bytes32 positionHash = generatePositionHash(user, futuresContractHash, side);        
1341         uint256[5] memory pos = retrievePosition(positionHash);
1342         if (pos[0] == 0) revert();
1343         if (newMargin == pos[4]) revert();
1344 
1345         uint256 fee = calculateFee(pos[0], pos[1], min(operationFee, takerFee), futuresContractHash); // min(operationFee, takerFee)
1346 
1347         UpdateMarginValues memory v = UpdateMarginValues({
1348             newMarginHash: keccak256(this, user, futuresContractHash, side, newMargin),
1349             baseToken: getContractBaseToken(futuresContractHash)
1350         });
1351 
1352         // check the signature is correct
1353         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", v.newMarginHash), vs, r, s) != user) revert();
1354 
1355         // check user has enough available balance
1356         if (newMargin > pos[4])
1357         {
1358             if (DMEX_Base(exchangeContract).availableBalanceOf(v.baseToken, user) < safeMul(safeAdd(safeSub(newMargin, pos[4]), fee), 1e10)) revert();
1359         }        
1360 
1361         if (newMargin > pos[4])
1362         {
1363             // reserve additional margin and subtract fee from user
1364             subBalanceAddReserve(v.baseToken, user, safeMul(fee, 1e10), safeSub(newMargin, pos[4]));            
1365         }
1366         else
1367         {
1368             // release margin form positon
1369             subBalanceSubReserve(v.baseToken, user, safeMul(fee, 1e10), safeSub(pos[4], newMargin));   
1370         }
1371         
1372         // update margin position position
1373         updatePositionSize(positionHash, pos[0], pos[1], newMargin);  
1374         
1375         // add fee to feeAccount
1376         addBalance(v.baseToken, feeAccount, DMEX_Base(exchangeContract).balanceOf(v.baseToken, feeAccount), safeMul(fee, 1e10));
1377     
1378         emit FuturesMarginUpdated(user, futuresContractHash, side, newMargin);
1379     }
1380 
1381     // Settle positions for closed contracts
1382     function batchSettlePositions (
1383         bytes32[] futuresContracts,
1384         bool[] sides,
1385         address[] users,
1386         address[] pools,
1387         uint256[] expirationFee
1388     ) onlyAdmin {
1389         
1390         for (uint i = 0; i < futuresContracts.length; i++) 
1391         {
1392             closeFuturesPositionForUser(futuresContracts[i], sides[i], users[i], pools[i], expirationFee[i]);
1393         }
1394     }
1395 
1396     function liquidatePositionWithClosingPrice(bytes32 futuresContractHash, address user, bool side, address poolAddress) private
1397     {
1398         bytes32 positionHash = generatePositionHash(user, futuresContractHash, side);
1399         liquidatePosition(positionHash, futuresContractHash, user, side, futuresContracts[futuresContractHash].closingPrice, poolAddress, futuresContracts[futuresContractHash].closingBlock);
1400     }
1401 
1402     function liquidatePositionWithAssetPrice(bytes32 futuresContractHash, address user, bool side, uint256 priceBlockNumber, address poolAddress) onlyAdmin
1403     {
1404         bytes32 assetHash = futuresContracts[futuresContractHash].asset;
1405         if (assetPrices[assetHash][priceBlockNumber] == 0) return;
1406 
1407         bytes32 positionHash = generatePositionHash(user, futuresContractHash, side);
1408 
1409         // check that the price is older than postion
1410         if (priceBlockNumber < retrievePosition(positionHash)[3]) return;  
1411 
1412         liquidatePosition(positionHash, futuresContractHash, user, side, assetPrices[assetHash][priceBlockNumber], poolAddress, priceBlockNumber);
1413     }
1414 
1415     struct LiquidatePositionValues {
1416         uint256 maintenanceMargin;
1417         uint256 fundingRate;
1418         uint256 multiplier;
1419     }
1420 
1421     function liquidatePosition (bytes32 positionHash, bytes32 futuresContractHash, address user, bool side, uint256 price, address poolAddress, uint256 block) private
1422     {
1423         uint256[5] memory pos = retrievePosition(positionHash);
1424         if (pos[0] == 0) return;
1425         if (!pools[poolAddress]) return;  
1426         if (futuresContracts[futuresContractHash].broken) revert(); // contract broken    
1427 
1428         bytes32 assetHash = futuresContracts[futuresContractHash].asset;  
1429 
1430 
1431         uint256 collateral = pos[4];
1432         uint256 fundingBlocks = safeSub(block, pos[3]);
1433 
1434         LiquidatePositionValues memory v = LiquidatePositionValues({
1435             maintenanceMargin: getMaintenanceMargin(futuresContractHash),
1436             fundingRate: futuresContracts[futuresContractHash].fundingRate,
1437             multiplier: futuresContracts[futuresContractHash].multiplier
1438         });
1439         
1440         uint256 liquidationPrice = calculateLiquidationPrice(pos, [fundingBlocks, v.fundingRate, v.maintenanceMargin, v.multiplier]);
1441 
1442         // get block price
1443         if (( side && price >= liquidationPrice)
1444         ||  (!side && price <= liquidationPrice))
1445         {
1446             emit LogError(uint8(Errors.LIQUIDATION_PRICE_NOT_TOUCHED), futuresContractHash, positionHash);
1447             return; 
1448         }
1449 
1450         // deduct collateral from user account
1451         subBalanceSubReserve(futuresAssets[assetHash].baseToken, user, safeMul(collateral, 1e10), collateral);
1452 
1453         // send collateral to pool address
1454         addBalance(futuresAssets[assetHash].baseToken, poolAddress, DMEX_Base(exchangeContract).balanceOf(futuresAssets[assetHash].baseToken, poolAddress), safeMul(collateral, 1e10));
1455     
1456         updatePositionSize(positionHash, 0, 0, 0); 
1457         updatePositionSize(generatePositionHash(poolAddress, futuresContractHash, !side), 0, 0, 0); 
1458 
1459         emit PositionLiquidated(positionHash, price);
1460     }
1461 
1462     struct LiquidationPriceValues {
1463         uint256 size;
1464         uint256 price;
1465         uint256 baseCollateral;
1466     }
1467 
1468     function calculateLiquidationPriceFromPositionHash (bytes32 futuresContractHash, bool side, address user) returns (uint256)
1469     {
1470         bytes32 positionHash = keccak256(this, user, futuresContractHash, side);      
1471         uint256[5] memory pos = retrievePosition(positionHash);
1472 
1473         if (pos[0] == 0) return;
1474 
1475         uint256 fundingRate = futuresContracts[futuresContractHash].fundingRate;
1476         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1477         uint256 maintenanceMargin = getMaintenanceMargin(futuresContractHash);
1478 
1479         return calculateLiquidationPrice (pos, [safeSub(block.number, pos[3]), fundingRate, maintenanceMargin, multiplier]);
1480     }
1481 
1482     function calculateLiquidationPrice(uint256[5] pos, uint256[4] values) public view returns (uint256)
1483     {
1484     
1485         /*
1486             values
1487             [0] fundingBlocks 
1488             [1] fundingRate
1489             [2] maintenanceMargin 
1490             [3] multiplier
1491         */
1492         LiquidationPriceValues memory v = LiquidationPriceValues({
1493             size: pos[0],
1494             price: pos[1],
1495             baseCollateral: pos[4]
1496         });
1497 
1498         // adjust funding blocks to funding interval
1499         values[0] = safeMul(values[0]/fundingInterval, fundingInterval);
1500         
1501         uint256 collateral = safeMul(v.baseCollateral, 1e8) / values[3];
1502         
1503         
1504         uint256 leverage = safeMul(v.price,v.size)/collateral/1e6;
1505         uint256 coef = safeMul(safeMul(values[2], 1e10)/leverage, 1e2);
1506         
1507         uint256 fundingCost = safeMul(safeMul(safeMul(v.size, v.price)/1e8, values[0]), values[1])/1e18;
1508         
1509         uint256 netLiqPrice;
1510         uint256 liquidationPrice;
1511         
1512         uint256 movement = safeMul(safeSub(collateral, min(collateral, fundingCost)), 1e8)/v.size;
1513         
1514         
1515         if (pos[2] == 0)
1516         {
1517         
1518             netLiqPrice = safeAdd(v.price, movement);
1519             liquidationPrice = safeSub(netLiqPrice, min(netLiqPrice, safeMul(v.price, coef)/1e18)); 
1520         }
1521         else
1522         {
1523             netLiqPrice = safeSub(v.price, movement);
1524             liquidationPrice = safeAdd(netLiqPrice, safeMul(v.price, coef)/1e18); 
1525         }        
1526         
1527         return liquidationPrice;
1528     }
1529 
1530 
1531     // Returns the smaller of two values
1532     function min(uint a, uint b) private pure returns (uint) {
1533         return a < b ? a : b;
1534     }
1535 
1536     // Returns the largest of the two values
1537     function max(uint a, uint b) private pure returns (uint) {
1538         return a > b ? a : b;
1539     }
1540 }