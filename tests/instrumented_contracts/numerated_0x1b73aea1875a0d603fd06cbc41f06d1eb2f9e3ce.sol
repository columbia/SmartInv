1 pragma solidity ^0.4.25;
2 
3 /* Interface for ERC20 Tokens */
4 contract Token {
5     bytes32 public standard;
6     bytes32 public name;
7     bytes32 public symbol;
8     uint256 public totalSupply;
9     uint8 public decimals;
10     bool public allowTransactions;
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13     function transfer(address _to, uint256 _value) returns (bool success);
14     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
15     function approve(address _spender, uint256 _value) returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
17 }
18 
19 /* Interface for the DMEX base contract */
20 contract DMEX_Base {
21     function getReserve(address token, address user) returns (uint256);
22     function setReserve(address token, address user, uint256 amount) returns (bool);
23 
24     function availableBalanceOf(address token, address user) returns (uint256);
25     function balanceOf(address token, address user) returns (uint256);
26 
27 
28     function setBalance(address token, address user, uint256 amount) returns (bool);
29     function getAffiliate(address user) returns (address);
30     function getInactivityReleasePeriod() returns (uint256);
31     function getMakerTakerBalances(address token, address maker, address taker) returns (uint256[4]);
32 
33     function getEtmTokenAddress() returns (address);
34 
35     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) returns (bool);
36     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) returns (bool);
37     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) returns (bool);
38     
39 }
40 
41 
42 
43 // The DMEX Futures Contract
44 contract Exchange {
45     function assert(bool assertion) pure {
46         
47         if (!assertion) {
48             throw;
49         }
50     }
51 
52     // Safe Multiply Function - prevents integer overflow 
53     function safeMul(uint a, uint b) pure returns (uint) {
54         uint c = a * b;
55         assert(a == 0 || c / a == b);
56         return c;
57     }
58 
59     // Safe Subtraction Function - prevents integer overflow 
60     function safeSub(uint a, uint b) pure returns (uint) {
61         assert(b <= a);
62         return a - b;
63     }
64 
65     // Safe Addition Function - prevents integer overflow 
66     function safeAdd(uint a, uint b) pure returns (uint) {
67         uint c = a + b;
68         assert(c>=a && c>=b);
69         return c;
70     }
71 
72     address public owner; // holds the address of the contract owner
73 
74     // Event fired when the owner of the contract is changed
75     event SetOwner(address indexed previousOwner, address indexed newOwner);
76 
77     // Allows only the owner of the contract to execute the function
78     modifier onlyOwner {
79         assert(msg.sender == owner);
80         _;
81     }
82 
83     // Allows only the owner of the contract to execute the function
84     modifier onlyOracle {
85         assert(msg.sender == DmexOracleContract);
86         _;
87     }
88 
89     // Changes the owner of the contract
90     function setOwner(address newOwner) onlyOwner {
91         emit SetOwner(owner, newOwner);
92         owner = newOwner;
93     }
94 
95     // Owner getter function
96     function getOwner() view returns (address out) {
97         return owner;
98     }
99 
100     mapping (address => bool) public admins;                    // mapping of admin addresses
101     mapping (address => bool) public pools;                     // mapping of liquidity pool addresses
102     mapping (address => uint256) public lastActiveTransaction;  // mapping of user addresses to last transaction block
103     mapping (bytes32 => uint256) public orderFills;             // mapping of orders to filled qunatity
104     mapping (bytes32 => mapping(uint256 => uint256)) public assetPrices; // mapping of assetHashes to block numbers to prices
105 
106 
107     address public feeAccount;          // the account that receives the trading fees
108     address public exchangeContract;    // the address of the main DMEX_Base contract
109     address public DmexOracleContract;    // the address of the DMEX math contract used for some calculations
110 
111     uint256 public makerFee;            // maker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
112     uint256 public takerFee;            // taker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
113     
114     struct FuturesAsset {
115         address baseToken;              // the token for collateral
116         string priceUrl;                // the url where the price of the asset will be taken for settlement
117         string pricePath;               // price path in the returned JSON from the priceUrl (ex. path "last" will return tha value last from the json: {"high": "156.49", "last": "154.31", "timestamp": "1556522201", "bid": "154.22", "vwap": "154.65", "volume": "25578.79138868", "low": "152.33", "ask": "154.26", "open": "152.99"})
118         bool disabled;                  // if true, the asset cannot be used in contract creation (when price url no longer valid)
119         uint256 decimals;               // number of decimals in the price            
120     }
121 
122     function createFuturesAsset(address baseToken, string priceUrl, string pricePath, uint256 decimals) onlyAdmin returns (bytes32)
123     {    
124         bytes32 futuresAsset = keccak256(this, baseToken, priceUrl, pricePath, decimals);
125         if (futuresAssets[futuresAsset].disabled) throw; // asset already exists and is disabled
126         if (bytes(futuresAssets[futuresAsset].pricePath).length != 0) return futuresAsset;
127 
128         futuresAssets[futuresAsset] = FuturesAsset({
129             baseToken           : baseToken,
130             priceUrl            : priceUrl,
131             pricePath           : pricePath,
132             disabled            : false,
133             decimals            : decimals            
134         });
135 
136         //emit FuturesAssetCreated(futuresAsset, baseToken, priceUrl, pricePath, maintenanceMargin);
137         return futuresAsset;
138     }
139     
140     struct FuturesContract {
141         bytes32 asset;                  // the hash of the underlying asset object
142         uint256 expirationBlock;        // futures contract expiration block
143         uint256 closingPrice;           // the closing price for the futures contract
144         bool closed;                    // is the futures contract closed (0 - false, 1 - true)c
145         bool broken;                    // if someone has forced release of funds the contract is marked as broken and can no longer close positions (0-false, 1-true)
146         uint256 multiplier;             // the multiplier price, normally the ETHUSD price * 1e8
147         uint256 fundingRate;            // funding rate expressed as proportion per block * 1e18
148         uint256 closingBlock;           // the block in which the contract was closed
149         bool perpetual;                 // true if contract is perpetual
150         uint256 maintenanceMargin;      // the maintenance margin coef 1e8
151     }
152 
153     function createFuturesContract(bytes32 asset, uint256 expirationBlock, uint256 multiplier, uint256 fundingRate, bool perpetual, uint256 maintenanceMargin) onlyAdmin returns (bytes32)
154     {    
155         bytes32 futuresContract = keccak256(this, asset, expirationBlock, multiplier, fundingRate, perpetual, maintenanceMargin);
156         if (futuresContracts[futuresContract].expirationBlock > 0) return futuresContract; // contract already exists
157 
158         futuresContracts[futuresContract] = FuturesContract({
159             asset               : asset,
160             expirationBlock     : expirationBlock,
161             closingPrice        : 0,
162             closed              : false,
163             broken              : false,
164             multiplier          : multiplier,
165             fundingRate         : fundingRate,
166             closingBlock        : 0,
167             perpetual           : perpetual,
168             maintenanceMargin   : maintenanceMargin
169         });
170 
171         //emit FuturesContractCreated(futuresContract, asset, expirationBlock, multiplier, fundingRate, perpetual);
172         return futuresContract;
173     }
174 
175     function getContractExpiration (bytes32 futuresContractHash) public view returns (uint256)
176     {
177         return futuresContracts[futuresContractHash].expirationBlock;
178     }
179 
180     function getContractClosed (bytes32 futuresContractHash) public view returns (bool)
181     {
182         return futuresContracts[futuresContractHash].closed;
183     }
184 
185     function getAssetDecimals (bytes32 futuresContractHash) public view returns (uint256)
186     {
187         return futuresAssets[futuresContracts[futuresContractHash].asset].decimals;
188     }
189 
190     function getContractBaseToken (bytes32 futuresContractHash) public view returns (address)
191     {
192         return futuresAssets[futuresContracts[futuresContractHash].asset].baseToken;
193     }
194 
195     function assetPriceUrl (bytes32 assetHash) public view returns (string)
196     {
197         return futuresAssets[assetHash].priceUrl;
198     }
199 
200     function assetPricePath (bytes32 assetHash) public view returns (string)
201     {
202         return futuresAssets[assetHash].pricePath;
203     }
204 
205     function assetDecimals (bytes32 assetHash) public view returns (uint256)
206     {
207         return futuresAssets[assetHash].decimals;
208     }
209 
210     function getContractPriceUrl (bytes32 futuresContractHash) returns (string)
211     {
212         return futuresAssets[futuresContracts[futuresContractHash].asset].priceUrl;
213     }
214 
215     function getContractPricePath (bytes32 futuresContractHash) returns (string)
216     {
217         return futuresAssets[futuresContracts[futuresContractHash].asset].pricePath;
218     }
219 
220     function getMaintenanceMargin (bytes32 futuresContractHash) returns (uint256)
221     {
222         return futuresContracts[futuresContractHash].maintenanceMargin;
223     }
224 
225     function setClosingPrice (bytes32 futuresContractHash, uint256 price) onlyOracle returns (bool) {
226         if (futuresContracts[futuresContractHash].closingPrice != 0) revert();
227         futuresContracts[futuresContractHash].closingPrice = price;
228         futuresContracts[futuresContractHash].closed = true;
229         futuresContracts[futuresContractHash].closingBlock = min(block.number,futuresContracts[futuresContractHash].expirationBlock);
230 
231         return true;
232     }
233 
234     function recordLatestAssetPrice (bytes32 futuresContractHash, uint256 price) onlyOracle returns (bool) {
235         assetPrices[futuresContracts[futuresContractHash].asset][block.number] = price;
236     }
237 
238     mapping (bytes32 => FuturesAsset)       public futuresAssets;      // mapping of futuresAsset hash to FuturesAsset structs
239     mapping (bytes32 => FuturesContract)    public futuresContracts;   // mapping of futuresContract hash to FuturesContract structs
240     mapping (bytes32 => uint256)            public positions;          // mapping of user addresses to position hashes to position
241 
242 
243     enum Errors {
244         /*  0 */INVALID_PRICE,                 
245         /*  1 */INVALID_SIGNATURE,              
246         /*  2 */ORDER_ALREADY_FILLED,           
247         /*  3 */GAS_TOO_HIGH,                  
248         /*  4 */OUT_OF_BALANCE,                 
249         /*  5 */FUTURES_CONTRACT_EXPIRED,       
250         /*  6 */FLOOR_OR_CAP_PRICE_REACHED,     
251         /*  7 */POSITION_ALREADY_EXISTS,        
252         /*  8 */UINT48_VALIDATION,              
253         /*  9 */FAILED_ASSERTION,               
254         /* 10 */NOT_A_POOL,
255         /* 11 */POSITION_EMPTY,
256         /* 12 */OLD_CONTRACT_OPEN,
257         /* 13 */OLD_CONTRACT_IN_RANGE,
258         /* 14 */NEW_CONTRACT_NOT_FOUND,
259         /* 15 */DIFF_EXPIRATIONS,
260         /* 16 */DIFF_ASSETS,
261         /* 17 */WRONG_RANGE,
262         /* 18 */IDENTICAL_CONTRACTS,
263         /* 19 */USER_NOT_IN_PROFIT,
264         /* 20 */WRONG_MULTIPLIER,
265         /* 21 */USER_POSITION_GREATER,
266         /* 22 */WRONG_FUNDING_RATE,
267         /* 23 */MUST_BE_LIQUIDATED,
268         /* 24 */LIQUIDATION_PRICE_NOT_TOUCHED
269     }
270 
271     event FuturesTrade(bool side, uint256 size, uint256 price, bytes32 indexed futuresContract, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
272     event FuturesPositionClosed(bytes32 indexed positionHash, uint256 closingPrice);
273     event FuturesForcedRelease(bytes32 indexed futuresContract, bool side, address user);
274     event FuturesAssetCreated(bytes32 indexed futuresAsset, address baseToken, string priceUrl, string pricePath, uint256 maintenanceMargin);
275     event FuturesContractCreated(bytes32 indexed futuresContract, bytes32 asset, uint256 expirationBlock, uint256 multiplier, uint256 fundingRate, bool perpetual);
276     event PositionLiquidated(bytes32 indexed positionHash, uint256 price);
277     event FuturesMarginAdded(address indexed user, bytes32 indexed futuresContract, bool side, uint64 marginToAdd);
278  
279     // Fee change event
280     event FeeChange(uint256 indexed makerFee, uint256 indexed takerFee);
281 
282     // Log event, logs errors in contract execution (for internal use)
283     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
284     //event LogErrorLight(uint8 errorId);
285     event LogUint(uint8 id, uint256 value);
286     event LogBytes(uint8 id, bytes32 value);
287     //event LogBool(uint8 id, bool value);
288     //event LogAddress(uint8 id, address value);
289 
290 
291     // Constructor function, initializes the contract and sets the core variables
292     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, address exchangeContract_, address DmexOracleContract_, address poolAddress) {
293         owner               = msg.sender;
294         feeAccount          = feeAccount_;
295         makerFee            = makerFee_;
296         takerFee            = takerFee_;
297 
298         exchangeContract    = exchangeContract_;
299         DmexOracleContract    = DmexOracleContract_;
300 
301         pools[poolAddress] = true;
302     }
303 
304     // Changes the fees
305     function setFees(uint256 makerFee_, uint256 takerFee_) onlyOwner {
306         require(makerFee_       < 10 finney && takerFee_ < 10 finney); // The fees cannot be set higher then 1%
307         makerFee                = makerFee_;
308         takerFee                = takerFee_;
309 
310         emit FeeChange(makerFee, takerFee);
311     }
312 
313     // Adds or disables an admin account
314     function setAdmin(address admin, bool isAdmin) onlyOwner {
315         admins[admin] = isAdmin;
316     }
317 
318     // Adds or disables a liquidity pool address
319     function setPool(address user, bool enabled) onlyOwner public {
320         pools[user] = enabled;
321     }
322 
323     // Allows for admins only to call the function
324     modifier onlyAdmin {
325         if (msg.sender != owner && !admins[msg.sender]) throw;
326         _;
327     }
328 
329     function() external {
330         throw;
331     }   
332 
333 
334     function validateUint48(uint256 val) returns (bool)
335     {
336         if (val != uint48(val)) return false;
337         return true;
338     }
339 
340     function validateUint64(uint256 val) returns (bool)
341     {
342         if (val != uint64(val)) return false;
343         return true;
344     }
345 
346     function validateUint128(uint256 val) returns (bool)
347     {
348         if (val != uint128(val)) return false;
349         return true;
350     }
351 
352 
353     // Structure that holds order values, used inside the trade() function
354     struct FuturesOrderPair {
355         uint256 makerNonce;                 // maker order nonce, makes the order unique
356         uint256 takerNonce;                 // taker order nonce
357         //uint256 takerGasFee;                // taker gas fee, taker pays the gas
358         uint256 takerIsBuying;              // true/false taker is the buyer
359 
360         address maker;                      // address of the maker
361         address taker;                      // address of the taker
362 
363         bytes32 makerOrderHash;             // hash of the maker order
364         bytes32 takerOrderHash;             // has of the taker order
365 
366         uint256 makerAmount;                // trade amount for maker
367         uint256 takerAmount;                // trade amount for taker
368 
369         uint256 makerPrice;                 // maker order price in wei (18 decimal precision)
370         uint256 takerPrice;                 // taker order price in wei (18 decimal precision)
371 
372         uint256 makerLeverage;              // the amount of collateral provided by maker (8 decimals)
373         uint256 takerLeverage;              // the amount of collateral provided by taker (8 decimals)
374 
375         bytes32 futuresContract;            // the futures contract being traded
376 
377         address baseToken;                  // the address of the base token for futures contract
378         // uint256 floorPrice;                 // floor price of futures contract
379         // uint256 capPrice;                   // cap price of futures contract
380 
381         bytes32 makerPositionHash;          // hash for maker position
382         bytes32 makerInversePositionHash;   // hash for inverse maker position 
383 
384         bytes32 takerPositionHash;          // hash for taker position
385         bytes32 takerInversePositionHash;   // hash for inverse taker position
386     }
387 
388     // Structure that holds trade values, used inside the trade() function
389     struct FuturesTradeValues {
390         uint256 qty;                    // amount to be trade
391         uint256 makerProfit;            // holds maker profit value
392         uint256 makerLoss;              // holds maker loss value
393         uint256 takerProfit;            // holds taker profit value
394         uint256 takerLoss;              // holds taker loss value
395         uint256 makerBalance;           // holds maker balance value
396         uint256 takerBalance;           // holds taker balance value
397         uint256 makerReserve;           // holds taker reserved value
398         uint256 takerReserve;           // holds taker reserved value
399         uint256 makerTradeCollateral;   // holds maker collateral value for trade
400         uint256 takerTradeCollateral;   // holds taker collateral value for trade
401         uint256 makerFee;
402         uint256 takerFee;
403     }
404 
405 
406     function generateOrderHash (bool maker, bool takerIsBuying, address user, bytes32 futuresContractHash, uint256[11] tradeValues) public view returns (bytes32)
407     {
408         if (maker)
409         {
410             //                     futuresContract      user  amount          price           side            nonce           leverage
411             return keccak256(this, futuresContractHash, user, tradeValues[4], tradeValues[6], !takerIsBuying, tradeValues[0], tradeValues[2]);
412         }
413         else
414         {
415             //                     futuresContract      user  amount          price           side            nonce           leverage
416             return keccak256(this, futuresContractHash, user, tradeValues[5], tradeValues[7],  takerIsBuying, tradeValues[1], tradeValues[8]);  
417         }
418     }
419 
420     // Executes multiple trades in one transaction, saves gas fees
421     function batchFuturesTrade(
422         uint8[2][] v,
423         bytes32[4][] rs,
424         uint256[11][] tradeValues,
425         address[3][] tradeAddresses,
426         bool[2][] boolValues,
427         uint256[5][] contractValues,
428         string priceUrl,
429         string pricePath
430     ) onlyAdmin
431     {
432         // function createFuturesAsset(address baseToken, string priceUrl, string pricePath, uint256 maintenanceMargin, uint256 decimals) onlyAdmin returns (bytes32)
433 
434         /*
435             contractValues
436             [0] expirationBlock
437             [1] multiplier
438             [2] fundingRate
439             [3] maintenanceMargin
440             [4] asset decimals
441 
442             assetStrings
443             [0] asset name
444             [1] asset priceUrl
445             [2] asset pricePath
446 
447             tradeAddresses
448             [0] maker
449             [1] taker
450             [2] asset baseToken
451 
452         */
453 
454         // perform trades
455         for (uint i = 0; i < tradeAddresses.length; i++) {
456             futuresTrade(
457                 v[i],
458                 rs[i],
459                 tradeValues[i],
460                 [tradeAddresses[i][0], tradeAddresses[i][1]],
461                 boolValues[i][0],
462                 createFuturesContract(
463                     createFuturesAsset(tradeAddresses[i][2], priceUrl, pricePath, contractValues[i][4]),
464                     contractValues[i][0], 
465                     contractValues[i][1], 
466                     contractValues[i][2], 
467                     boolValues[i][1],
468                     contractValues[i][3]
469                 )
470             );
471         }
472     }
473 
474     // Opens/closes futures positions
475     function futuresTrade(
476         uint8[2] v,
477         bytes32[4] rs,
478         uint256[11] tradeValues,
479         address[2] tradeAddresses,
480         bool takerIsBuying,
481         bytes32 futuresContractHash
482     ) onlyAdmin returns (uint filledTakerTokenAmount)
483     {
484         /* tradeValues
485           [0] makerNonce
486           [1] takerNonce
487           [2] makerLeverage
488           [3] takerIsBuying
489           [4] makerAmount
490           [5] takerAmount
491           [6] makerPrice
492           [7] takerPrice
493           [8] takerLeverage
494           [9] makerFee
495           [10] takerFee
496 
497           tradeAddresses
498           [0] maker
499           [1] taker
500         */
501 
502         FuturesOrderPair memory t  = FuturesOrderPair({
503             makerNonce      : tradeValues[0],
504             takerNonce      : tradeValues[1],
505             //takerGasFee     : tradeValues[2],
506             takerIsBuying   : tradeValues[3],
507             makerAmount     : tradeValues[4],      
508             takerAmount     : tradeValues[5],   
509             makerPrice      : tradeValues[6],         
510             takerPrice      : tradeValues[7],
511             makerLeverage   : tradeValues[2],
512             takerLeverage   : tradeValues[8],
513 
514             maker           : tradeAddresses[0],
515             taker           : tradeAddresses[1],
516 
517             makerOrderHash  : generateOrderHash(true,  takerIsBuying, tradeAddresses[0], futuresContractHash, tradeValues), // keccak256(this, futuresContractHash, tradeAddresses[0], tradeValues[4], tradeValues[6], !takerIsBuying, tradeValues[0], tradeValues[2]),
518             takerOrderHash  : generateOrderHash(false, takerIsBuying, tradeAddresses[1], futuresContractHash, tradeValues), // keccak256(this, futuresContractHash, tradeAddresses[1], tradeValues[5], tradeValues[7],  takerIsBuying, tradeValues[1], tradeValues[8]),            
519 
520             futuresContract : futuresContractHash,
521 
522             baseToken       : getContractBaseToken(futuresContractHash),
523 
524             //                                            user               futuresContractHash   side           
525             makerPositionHash           : keccak256(this, tradeAddresses[0], futuresContractHash, !takerIsBuying),
526             makerInversePositionHash    : keccak256(this, tradeAddresses[0], futuresContractHash,  takerIsBuying),
527 
528             takerPositionHash           : keccak256(this, tradeAddresses[1], futuresContractHash,  takerIsBuying),
529             takerInversePositionHash    : keccak256(this, tradeAddresses[1], futuresContractHash, !takerIsBuying)
530 
531         });
532 
533 
534        
535 
536 //--> 44 000
537     
538         // Valifate size and price values
539         if (!validateUint128(t.makerAmount) || !validateUint128(t.takerAmount) || !validateUint64(t.makerPrice) || !validateUint64(t.takerPrice))
540         {            
541             emit LogError(uint8(Errors.UINT48_VALIDATION), t.makerOrderHash, t.takerOrderHash);
542             return 0; 
543         }
544 
545 
546         // Check if futures contract has expired already
547         if ((!futuresContracts[t.futuresContract].perpetual && block.number > futuresContracts[t.futuresContract].expirationBlock) || futuresContracts[t.futuresContract].closed == true || futuresContracts[t.futuresContract].broken == true)
548         {
549             emit LogError(uint8(Errors.FUTURES_CONTRACT_EXPIRED), t.makerOrderHash, t.takerOrderHash);
550             return 0; // futures contract is expired
551         }
552 
553 
554 
555         // Checks the signature for the maker order
556         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
557         {
558             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
559             return 0;
560         }
561 
562         // Checks the signature for the taker order
563         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
564         {
565             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
566             return 0;
567         }
568 
569         // check prices
570         if ((!takerIsBuying && t.makerPrice < t.takerPrice) || (takerIsBuying && t.takerPrice < t.makerPrice))
571         {
572             emit LogError(uint8(Errors.INVALID_PRICE), t.makerOrderHash, t.takerOrderHash);
573             return 0; // prices don't match
574         }      
575 
576 //--> 54 000         
577         
578 
579         uint256[4] memory balances = DMEX_Base(exchangeContract).getMakerTakerBalances(t.baseToken, t.maker, t.taker);
580 
581         // Initializing trade values structure 
582         FuturesTradeValues memory tv = FuturesTradeValues({
583             qty                 : 0,
584             makerProfit         : 0,
585             makerLoss           : 0,
586             takerProfit         : 0,
587             takerLoss           : 0,
588             makerBalance        : balances[0], 
589             takerBalance        : balances[1],  
590             makerReserve        : balances[2],  
591             takerReserve        : balances[3],
592             makerTradeCollateral: 0,
593             takerTradeCollateral: 0,
594             makerFee            : min(makerFee, tradeValues[9]),
595             takerFee            : min(takerFee, tradeValues[10])
596         });
597 
598 //--> 60 000
599 
600 
601 
602 
603 
604         // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
605         // and open inverse positions
606         tv.qty = min(safeSub(t.makerAmount, orderFills[t.makerOrderHash]), safeSub(t.takerAmount, orderFills[t.takerOrderHash]));
607         
608         if (positionExists(t.makerInversePositionHash) && positionExists(t.takerInversePositionHash))
609         {
610             tv.qty = min(tv.qty, min(retrievePosition(t.makerInversePositionHash)[0], retrievePosition(t.takerInversePositionHash)[0]));
611         }
612         else if (positionExists(t.makerInversePositionHash))
613         {
614             tv.qty = min(tv.qty, retrievePosition(t.makerInversePositionHash)[0]);
615         }
616         else if (positionExists(t.takerInversePositionHash))
617         {
618             tv.qty = min(tv.qty, retrievePosition(t.takerInversePositionHash)[0]);
619         }
620 
621         tv.makerTradeCollateral = calculateCollateral(tv.qty, t.makerPrice, t.makerLeverage, t.futuresContract);
622         tv.takerTradeCollateral = calculateCollateral(tv.qty, t.makerPrice, t.takerLeverage, t.futuresContract);
623 
624 
625 //--> 64 000       
626         
627         if (tv.qty == 0)
628         {
629             // no qty left on orders
630             emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
631             return 0;
632         }
633 
634         // Cheks that gas fee is not higher than 10%
635         // if (safeMul(t.takerGasFee, 20) > calculateTradeValue(tv.qty, t.makerPrice, t.futuresContract))
636         // {
637         //     emit LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
638         //     return 0;
639         // } // takerGasFee too high
640 
641 
642 //--> 66 000
643         
644 
645        
646 
647         /*------------- Maker long, Taker short -------------*/
648         if (!takerIsBuying)
649         {     
650             
651       
652             // position actions for maker
653             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
654             {
655 
656 
657                 // check if maker has enough balance   
658                 if (safeSub(tv.makerBalance,tv.makerReserve) < safeMul(tv.makerTradeCollateral, 1e10))
659                 {
660                     // maker out of balance
661                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
662                     return 0; 
663                 }
664 
665                 updateBalances(
666                     t.futuresContract, 
667                     [
668                         t.baseToken, // base token
669                         t.maker // make address
670                     ], 
671                     t.makerPositionHash,  // position hash
672                     [
673                         tv.qty, // qty
674                         t.makerPrice,  // price
675                         tv.makerFee, // fee
676                         0, // profit
677                         0, // loss
678                         tv.makerBalance, // balance
679                         0, // gasFee
680                         tv.makerReserve, // reserve
681                         t.makerLeverage // leverage
682                     ], 
683                     [
684                         true, // newPostion (if true position is new)
685                         true, // side (if true - long)
686                         false // increase position (if true)
687                     ]
688                 );
689 
690             } else {               
691                 
692                 if (positionExists(t.makerPositionHash))
693                 {
694                     // check if maker has enough balance            
695                     if (safeSub(tv.makerBalance,tv.makerReserve) < safeMul(tv.makerTradeCollateral, 1e10))
696                     {
697                         // maker out of balance
698                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
699                         return 0; 
700                     }
701 
702                     // increase position size
703                     // updatePositionSize(t.makerPositionHash, safeAdd(retrievePosition(t.makerPositionHash)[0], tv.qty), t.makerPrice);
704                 
705                     updateBalances(
706                         t.futuresContract, 
707                         [
708                             t.baseToken,  // base token
709                             t.maker // make address
710                         ], 
711                         t.makerPositionHash, // position hash
712                         [
713                             tv.qty, // qty
714                             t.makerPrice, // price
715                             tv.makerFee, // fee
716                             0, // profit
717                             0, // loss
718                             tv.makerBalance, // balance
719                             0, // gasFee
720                             tv.makerReserve, // reserve
721                             t.makerLeverage // leverage
722                         ], 
723                         [
724                             false, // newPostion (if true position is new)
725                             true, // side (if true - long)
726                             true // increase position (if true)
727                         ]
728                     );
729                 }
730                 else
731                 {
732 
733                     // close/partially close existing position
734                     // updatePositionSize(t.makerInversePositionHash, safeSub(retrievePosition(t.makerInversePositionHash)[0], tv.qty), 0);
735                     if (t.makerPrice < retrievePosition(t.makerInversePositionHash)[1])
736                     {
737                         // user has made a profit
738                         //tv.makerProfit                    = safeMul(safeSub(retrievePosition(t.makerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;
739                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);
740                     }
741                     else
742                     {
743                         // user has made a loss
744                         //tv.makerLoss                      = safeMul(safeSub(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1]), tv.qty) / t.makerPrice;    
745                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                        
746                     }
747 
748                     updateBalances(
749                         t.futuresContract, 
750                         [
751                             t.baseToken, // base token
752                             t.maker // make address
753                         ], 
754                         t.makerInversePositionHash, // position hash
755                         [
756                             tv.qty, // qty
757                             t.makerPrice, // price
758                             tv.makerFee, // fee
759                             tv.makerProfit,  // profit
760                             tv.makerLoss,  // loss
761                             tv.makerBalance, // balance
762                             0, // gasFee
763                             tv.makerReserve, // reserve
764                             t.makerLeverage // leverage
765                         ], 
766                         [
767                             false, // newPostion (if true position is new)
768                             true, // side (if true - long)
769                             false // increase position (if true)
770                         ]
771                     );
772                 }                
773             }
774 
775            
776 
777 
778             // position actions for taker
779             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
780             {
781                 
782                 // check if taker has enough balance
783                 if (safeSub(tv.takerBalance,tv.takerReserve) < safeMul(tv.takerTradeCollateral, 1e10))
784                 {
785                     // maker out of balance
786                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
787                     return 0; 
788                 }
789                 
790                 // create new position
791                 //recordNewPosition(t.takerPositionHash, tv.qty, t.makerPrice, 0, block.number);
792                 
793                 updateBalances(
794                     t.futuresContract, 
795                     [
796                         t.baseToken, // base token
797                         t.taker // make address
798                     ], 
799                     t.takerPositionHash, // position hash
800                     [
801                         tv.qty, // qty
802                         t.makerPrice,  // price
803                         tv.takerFee, // fee
804                         0, // profit
805                         0,  // loss
806                         tv.takerBalance,  // balance
807                         0, // gasFee
808                         tv.takerReserve, // reserve
809                         t.takerLeverage // leverage
810                     ], 
811                     [
812                         true, // newPostion (if true position is new)
813                         false, // side (if true - long)
814                         false // increase position (if true)
815                     ]
816                 );
817 
818             } else {
819                 if (positionExists(t.takerPositionHash))
820                 {
821                     // check if taker has enough balance
822                     //if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether))  * 1e10, t.takerGasFee) > safeSub(balances[1],tv.takerReserve))
823                     if (safeSub(tv.takerBalance,tv.takerReserve) < safeMul(tv.takerTradeCollateral, 1e10))
824                     {
825                         // maker out of balance
826                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
827                         return 0; 
828                     }
829 
830                     // increase position size
831                     //updatePositionSize(t.takerPositionHash, safeAdd(retrievePosition(t.takerPositionHash)[0], tv.qty), t.makerPrice);
832                 
833                     updateBalances(
834                         t.futuresContract, 
835                         [
836                             t.baseToken,  // base token
837                             t.taker // make address
838                         ], 
839                         t.takerPositionHash, // position hash
840                         [
841                             tv.qty, // qty
842                             t.makerPrice, // price
843                             tv.takerFee, // fee
844                             0, // profit
845                             0, // loss
846                             tv.takerBalance, // balance
847                             0, // gasFee
848                             tv.takerReserve, // reserve
849                             t.takerLeverage // leverage
850                         ], 
851                         [
852                             false, // newPostion (if true position is new)
853                             false, // side (if true - long)
854                             true // increase position (if true)
855                         ]
856                     );
857                 }
858                 else
859                 {    
860                     // close/partially close existing position
861                     //updatePositionSize(t.takerInversePositionHash, safeSub(retrievePosition(t.takerInversePositionHash)[0], tv.qty), 0);
862                     
863                     if (t.makerPrice > retrievePosition(t.takerInversePositionHash)[1])
864                     {
865                         // user has made a profit
866                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false);
867                     }
868                     else
869                     {
870                         // user has made a loss
871                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false); 
872                     }
873 
874                   
875 
876                     updateBalances(
877                         t.futuresContract, 
878                         [
879                             t.baseToken, // base token
880                             t.taker // make address
881                         ], 
882                         t.takerInversePositionHash, // position hash
883                         [
884                             tv.qty, // qty
885                             t.makerPrice, // price
886                             tv.takerFee, // fee
887                             tv.takerProfit, // profit
888                             tv.takerLoss, // loss
889                             tv.takerBalance,  // balance
890                             0,  // gasFee
891                             tv.takerReserve, // reserve
892                             t.takerLeverage // leverage
893                         ], 
894                         [
895                             false, // newPostion (if true position is new)
896                             false, // side (if true - long)
897                             false // increase position (if true)
898                         ]
899                     );
900                 }
901             }
902         }
903 
904 
905         /*------------- Maker short, Taker long -------------*/
906 
907         else
908         {      
909             // position actions for maker
910             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
911             {
912                 // check if maker has enough balance
913                 if (safeSub(tv.makerBalance,tv.makerReserve) < safeMul(tv.makerTradeCollateral, 1e10))
914                 {
915                     // maker out of balance
916                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
917                     return 0; 
918                 }
919 
920                 // create new position
921                 //recordNewPosition(t.makerPositionHash, tv.qty, t.makerPrice, 0, block.number);
922                 updateBalances(
923                     t.futuresContract, 
924                     [
925                         t.baseToken,   // base token
926                         t.maker // make address
927                     ], 
928                     t.makerPositionHash, // position hash
929                     [
930                         tv.qty, // qty
931                         t.makerPrice, // price
932                         tv.makerFee, // fee
933                         0, // profit
934                         0, // loss
935                         tv.makerBalance, // balance
936                         0, // gasFee
937                         tv.makerReserve, // reserve
938                         t.makerLeverage // leverage
939                     ], 
940                     [
941                         true, // newPostion (if true position is new)
942                         false, // side (if true - long)
943                         false // increase position (if true)
944                     ]
945                 );
946 
947             } else {
948                 if (positionExists(t.makerPositionHash))
949                 {
950                     // check if maker has enough balance
951                     if (safeSub(tv.makerBalance,tv.makerReserve) < safeMul(tv.makerTradeCollateral, 1e10))
952                     {
953                         // maker out of balance
954                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
955                         return 0; 
956                     }
957 
958                     // increase position size
959                     updateBalances(
960                         t.futuresContract, 
961                         [
962                             t.baseToken,  // base token
963                             t.maker // make address
964                         ], 
965                         t.makerPositionHash, // position hash
966                         [
967                             tv.qty, // qty
968                             t.makerPrice, // price
969                             tv.makerFee, // fee
970                             0, // profit
971                             0, // loss
972                             tv.makerBalance, // balance
973                             0, // gasFee
974                             tv.makerReserve, // reserve
975                             t.makerLeverage // leverage
976                         ], 
977                         [
978                             false, // newPostion (if true position is new)
979                             false, // side (if true - long)
980                             true // increase position (if true)
981                         ]
982                     );
983                 }
984                 else
985                 {
986 
987 
988                     // close/partially close existing position
989                     if (t.makerPrice > retrievePosition(t.makerInversePositionHash)[1])
990                     {
991                         // user has made a profit
992                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);
993                     }
994                     else
995                     {
996                         // user has made a loss
997                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);                               
998                     }
999 
1000                     updateBalances(
1001                         t.futuresContract, 
1002                         [
1003                             t.baseToken, // base token
1004                             t.maker // user address
1005                         ], 
1006                         t.makerInversePositionHash, // position hash
1007                         [
1008                             tv.qty, // qty
1009                             t.makerPrice, // price
1010                             tv.makerFee, // fee
1011                             tv.makerProfit,  // profit
1012                             tv.makerLoss, // loss
1013                             tv.makerBalance, // balance
1014                             0, // gasFee
1015                             tv.makerReserve, // reserve
1016                             t.makerLeverage // leverage
1017                         ], 
1018                         [
1019                             false, // newPostion (if true position is new)
1020                             false, // side (if true - long)
1021                             false // increase position (if true)
1022                         ]
1023                     );
1024                 }
1025             }
1026 
1027             // position actions for taker
1028             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
1029             {
1030                 // check if taker has enough balance
1031                 if (safeSub(tv.takerBalance,tv.takerReserve) < safeMul(tv.takerTradeCollateral, 1e10))
1032                 {
1033                     // maker out of balance
1034                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
1035                     return 0; 
1036                 }
1037 
1038                 updateBalances(
1039                     t.futuresContract, 
1040                     [
1041                         t.baseToken,  // base token
1042                         t.taker // user address
1043                     ], 
1044                     t.takerPositionHash, // position hash
1045                     [
1046                         tv.qty, // qty
1047                         t.makerPrice, // price
1048                         tv.takerFee, // fee
1049                         0,  // profit
1050                         0,  // loss
1051                         tv.takerBalance, // balance
1052                         0, // gasFee
1053                         tv.takerReserve, // reserve
1054                         t.takerLeverage // leverage
1055                     ], 
1056                     [
1057                         true, // newPostion (if true position is new)
1058                         true, // side (if true - long)
1059                         false // increase position (if true)
1060                     ]
1061                 );
1062 
1063             } else {
1064                 if (positionExists(t.takerPositionHash))
1065                 {
1066                     // check if taker has enough balance
1067                     if (safeSub(tv.takerBalance,tv.takerReserve) < safeMul(tv.takerTradeCollateral, 1e10))
1068                     {
1069                         // maker out of balance
1070                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
1071                         return 0; 
1072                     }
1073                     
1074                     // increase position size
1075                     updateBalances(
1076                         t.futuresContract, 
1077                         [
1078                             t.baseToken,  // base token
1079                             t.taker // user address
1080                         ], 
1081                         t.takerPositionHash, // position hash
1082                         [
1083                             tv.qty, // qty
1084                             t.makerPrice, // price
1085                             tv.takerFee, // fee
1086                             0, // profit
1087                             0, // loss
1088                             tv.takerBalance, // balance
1089                             0, // gasFee
1090                             tv.takerReserve, // reserve
1091                             t.takerLeverage // leverage
1092                         ], 
1093                         [
1094                             false, // newPostion (if true position is new)
1095                             true, // side (if true - long)
1096                             true // increase position (if true)
1097                         ]
1098                     );
1099                 }
1100                 else
1101                 {
1102 
1103                     // close/partially close existing position
1104                     if (t.makerPrice < retrievePosition(t.takerInversePositionHash)[1])
1105                     {
1106                         // user has made a profit
1107                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);
1108                     }
1109                     else
1110                     {
1111                         // user has made a loss
1112                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                  
1113                     }                   
1114 
1115                     updateBalances(
1116                         t.futuresContract, 
1117                         [
1118                             t.baseToken,   // base toke
1119                             t.taker // user address
1120                         ], 
1121                         t.takerInversePositionHash,  // position hash
1122                         [
1123                             tv.qty, // qty
1124                             t.makerPrice, // price
1125                             tv.takerFee, // fee
1126                             tv.takerProfit, // profit
1127                             tv.takerLoss, // loss
1128                             tv.takerBalance, // balance
1129                             0, // gasFee
1130                             tv.takerReserve, // reserve
1131                             t.takerLeverage // leverage
1132                         ], 
1133                         [
1134                             false, // newPostion (if true position is new)
1135                             true, // side (if true - long) 
1136                             false // increase position (if true)
1137                         ]
1138                     );
1139                 }
1140             }           
1141         }
1142 
1143 //--> 220 000
1144         orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty); // increase the maker order filled amount
1145         orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); // increase the taker order filled amount
1146 
1147 //--> 264 000
1148         emit FuturesTrade(takerIsBuying, tv.qty, t.makerPrice, t.futuresContract, t.makerOrderHash, t.takerOrderHash);
1149 
1150         return tv.qty;
1151     }
1152 
1153 
1154     function calculateProfit(uint256 closingPrice, uint256 entryPrice, uint256 qty, bytes32 futuresContractHash, bool side) public view returns (uint256)
1155     {
1156         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1157 
1158         if (side)
1159         {           
1160             return safeMul(safeMul(safeSub(entryPrice, closingPrice), qty), multiplier )  / 1e16;            
1161         }
1162         else
1163         {
1164             return safeMul(safeMul(safeSub(closingPrice, entryPrice), qty), multiplier )  / 1e16; 
1165         }       
1166     }
1167 
1168     function calculateTradeValue(uint256 qty, uint256 price, bytes32 futuresContractHash)  public view returns (uint256)
1169     {
1170         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1171         return safeMul(safeMul(safeMul(qty, price), 1e2), multiplier) / 1e8 ;
1172     }
1173 
1174 
1175 
1176     function calculateLoss(uint256 closingPrice, uint256 entryPrice, uint256 qty,  bytes32 futuresContractHash, bool side) public view returns (uint256)
1177     {
1178         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1179 
1180         if (side)
1181         {
1182             return safeMul(safeMul(safeSub(closingPrice, entryPrice), qty), multiplier) / 1e16 ;
1183         }
1184         else
1185         {
1186             return safeMul(safeMul(safeSub(entryPrice, closingPrice), qty), multiplier) / 1e16 ; 
1187         }
1188         
1189     }
1190 
1191     function calculateCollateral (uint256 qty, uint256 price, uint256 leverage, bytes32 futuresContractHash) view returns (uint256) // 1e8
1192     {
1193         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1194         uint256 collateral;
1195             
1196         collateral = safeMul(safeMul(price, qty), multiplier) / 1e16 / leverage;
1197 
1198         return collateral;               
1199     }
1200 
1201     function calculateProportionalMargin(uint256 currQty, uint256 newQty, uint256 margin) view returns (uint256) // 1e8
1202     {
1203         uint256 proportionalMargin = safeMul(margin, newQty)/currQty;
1204         return proportionalMargin;          
1205     }
1206 
1207     function calculateFundingCost (uint256 price, uint256 qty, uint256 fundingBlocks, bytes32 futuresContractHash)  public view returns (uint256) // 1e8
1208     {
1209         uint256 fundingRate = futuresContracts[futuresContractHash].fundingRate;
1210         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1211 
1212         uint256 fundingCost = safeMul(safeMul(safeMul(fundingBlocks, fundingRate), safeMul(qty, price)/1e8)/1e18, multiplier)/1e8;
1213 
1214         return fundingCost;  
1215     }
1216 
1217     function calculateFee (uint256 qty, uint256 tradePrice, uint256 fee, bytes32 futuresContractHash)  public view returns (uint256)
1218     {
1219         return safeMul(calculateTradeValue(qty, tradePrice, futuresContractHash), fee / 1e10) / 1e18;
1220     }
1221      
1222 
1223     
1224 
1225     
1226 
1227 
1228     // Update user balance
1229     function updateBalances (bytes32 futuresContract, address[2] addressValues, bytes32 positionHash, uint256[9] uintValues, bool[3] boolValues) private
1230     {
1231         /*
1232             addressValues
1233             [0] baseToken
1234             [1] user
1235 
1236             uintValues
1237             [0] qty
1238             [1] price
1239             [2] fee
1240             [3] profit
1241             [4] loss
1242             [5] balance
1243             [6] gasFee
1244             [7] reserve
1245             [8] leverage
1246 
1247             boolValues
1248             [0] newPostion
1249             [1] side
1250             [2] increase position
1251 
1252         */
1253 
1254         // pam = [fee value, collateral, fundignCost, payableFundingCost]               
1255         uint256[3] memory pam = [
1256             safeAdd(safeMul(calculateFee(uintValues[0], uintValues[1], uintValues[2], futuresContract), 1e10), uintValues[6]), 
1257             calculateCollateral(uintValues[0], uintValues[1], uintValues[8], futuresContract),
1258             0
1259         ];
1260                
1261         if (boolValues[0] || boolValues[2])  
1262         {
1263             // Position is new or position is increased
1264             if (boolValues[0])
1265             {
1266                 // new position
1267                 recordNewPosition(positionHash, uintValues[0], uintValues[1], boolValues[1] ? 1 : 0, block.number, pam[1]);
1268             }
1269             else
1270             {
1271                 // increase position
1272                 updatePositionSize(positionHash, safeAdd(retrievePosition(positionHash)[0], uintValues[0]), uintValues[1], safeAdd(retrievePosition(positionHash)[4], pam[1]));
1273             }
1274 
1275             
1276             if (!pools[addressValues[1]])
1277             {
1278                 subBalanceAddReserve(addressValues[0], addressValues[1], pam[0], pam[1]);                    
1279             }
1280             else
1281             {
1282                 pam[0] = 0;
1283             }
1284             pam[2] = 0;
1285         } 
1286         else 
1287         {
1288             // Position exists, decreasing
1289             //pam[1] = calculateCollateral(uintValues[0], retrievePosition(positionHash)[1], uintValues[8], futuresContract)-1;                          
1290             pam[1] = calculateProportionalMargin(retrievePosition(positionHash)[0], uintValues[0], retrievePosition(positionHash)[4]);
1291             
1292             updatePositionSize(positionHash, safeSub(retrievePosition(positionHash)[0], uintValues[0]),  uintValues[1], safeSub(retrievePosition(positionHash)[4], pam[1]));
1293 
1294             pam[2] = calculateFundingCost(retrievePosition(positionHash)[1], uintValues[0], safeSub(block.number, retrievePosition(positionHash)[3]), futuresContract);   
1295             
1296 
1297             if (pools[addressValues[1]]) {
1298                 pam[0] = 0;
1299                 pam[1] = 0;
1300                 pam[2] = 0;
1301             }
1302 
1303             if (uintValues[3] > 0) 
1304             {
1305                 // profit > 0
1306                 if (safeAdd(pam[0], safeMul(pam[2], 1e10)) <= safeMul(uintValues[3],1e10))
1307                 {
1308                     addBalanceSubReserve(addressValues[0], addressValues[1], safeSub(safeMul(uintValues[3],1e10), safeAdd(pam[0], safeMul(pam[2], 1e10))), pam[1]);
1309                 }
1310                 else
1311                 {
1312                     // LogUint(13, safeSub(safeAdd(pam[0], pam[2]*1e10), safeMul(uintValues[3],1e10)));
1313                     // return;
1314                     subBalanceSubReserve(addressValues[0], addressValues[1], safeSub(safeAdd(pam[0], safeMul(pam[2], 1e10)), safeMul(uintValues[3],1e10)), pam[1]);
1315                 }                
1316             } 
1317             else 
1318             {   
1319                 // loss >= 0
1320                 subBalanceSubReserve(addressValues[0], addressValues[1], safeAdd(safeMul(uintValues[4],1e10), safeAdd(pam[0], safeMul(pam[2], 1e10))), pam[1]); // deduct loss from user balance
1321             }     
1322 
1323         }          
1324         
1325         if (safeAdd(pam[0], safeMul(pam[2], 1e10)) > 0)
1326         {
1327             addBalance(addressValues[0], feeAccount, DMEX_Base(exchangeContract).balanceOf(addressValues[0], feeAccount), safeAdd(pam[0], safeMul(pam[2], 1e10))); // send fee to feeAccount
1328         }
1329         
1330     }
1331 
1332     function recordNewPosition (bytes32 positionHash, uint256 size, uint256 price, uint256 side, uint256 block, uint256 collateral) private
1333     {
1334         if (!validateUint64(size) || !validateUint64(price) || !validateUint64(collateral)) 
1335         {
1336             throw;
1337         }
1338 
1339         uint256 character = uint64(size);
1340         character |= price<<64;
1341         character |= collateral<<128;
1342         character |= side<<192;
1343         character |= block<<208;
1344 
1345         positions[positionHash] = character;
1346     }
1347 
1348     function retrievePosition (bytes32 positionHash) public view returns (uint256[5])
1349     {
1350         uint256 character = positions[positionHash];
1351         uint256 size = uint256(uint64(character));
1352         uint256 price = uint256(uint64(character>>64));
1353         uint256 collateral = uint256(uint64(character>>128));
1354         uint256 side = uint256(uint16(character>>192));
1355         uint256 entryBlock = uint256(uint48(character>>208));
1356 
1357         return [size, price, side, entryBlock, collateral];
1358     }
1359 
1360     function updatePositionSize(bytes32 positionHash, uint256 size, uint256 price, uint256 collateral) private
1361     {
1362         uint256[5] memory pos = retrievePosition(positionHash);
1363 
1364         if (size > pos[0])
1365         {
1366             uint256 totalValue = safeAdd(safeMul(pos[0], pos[1]), safeMul(price, safeSub(size, pos[0])));
1367             uint256 newSize = safeSub(size, pos[0]);
1368             // position is increasing in size
1369             recordNewPosition(
1370                 positionHash, 
1371                 size, 
1372                 totalValue / size, 
1373                 pos[2], 
1374                 safeAdd(safeMul(safeMul(pos[0], pos[1]), pos[3]), safeMul(safeMul(price, newSize), block.number)) / totalValue, // pos[3]
1375                 collateral
1376             );
1377         }
1378         else
1379         {
1380             // position is decreasing in size
1381             recordNewPosition(
1382                 positionHash, 
1383                 size, 
1384                 pos[1], 
1385                 pos[2], 
1386                 pos[3],
1387                 collateral
1388             );
1389         }        
1390     }
1391 
1392     function positionExists (bytes32 positionHash) internal view returns (bool)
1393     {
1394         if (retrievePosition(positionHash)[0] == 0)
1395         {
1396             return false;
1397         }
1398         else
1399         {
1400             return true;
1401         }
1402     }
1403 
1404 
1405     // This function allows the user to manually release collateral in case the oracle service does not provide the price during the inactivityReleasePeriod
1406     function forceReleaseReserve (bytes32 futuresContract, bool side, address user) public
1407     {   
1408         if (futuresContracts[futuresContract].expirationBlock == 0) throw;       
1409         if (futuresContracts[futuresContract].expirationBlock > block.number) throw;
1410         if (safeAdd(futuresContracts[futuresContract].expirationBlock, DMEX_Base(exchangeContract).getInactivityReleasePeriod()) > block.number) throw;  
1411         
1412 
1413         bytes32 positionHash = keccak256(this, user, futuresContract, side);
1414         if (retrievePosition(positionHash)[1] == 0) throw;    
1415   
1416 
1417         futuresContracts[futuresContract].broken = true;
1418 
1419         uint256[5] memory pos = retrievePosition(positionHash);
1420         FuturesContract cont = futuresContracts[futuresContract];
1421         address baseToken = futuresAssets[cont.asset].baseToken;
1422 
1423         subReserve(
1424             baseToken, 
1425             user, 
1426             DMEX_Base(exchangeContract).getReserve(baseToken, user), 
1427             pos[4]
1428         );        
1429 
1430         updatePositionSize(positionHash, 0, 0, 0);
1431 
1432         emit FuturesForcedRelease(futuresContract, side, user);
1433 
1434     }
1435 
1436     function addBalance(address token, address user, uint256 balance, uint256 amount) private
1437     {
1438         DMEX_Base(exchangeContract).setBalance(token, user, safeAdd(balance, amount));
1439     }
1440 
1441     function subBalance(address token, address user, uint256 balance, uint256 amount) private
1442     {
1443         DMEX_Base(exchangeContract).setBalance(token, user, safeSub(balance, amount));
1444     }
1445 
1446     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) private
1447     {
1448         DMEX_Base(exchangeContract).subBalanceAddReserve(token, user, subBalance, safeMul(addReserve, 1e10));
1449     }
1450 
1451     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) private
1452     {
1453         DMEX_Base(exchangeContract).addBalanceSubReserve(token, user, addBalance, safeMul(subReserve, 1e10));
1454     }
1455 
1456     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) private
1457     {
1458         DMEX_Base(exchangeContract).subBalanceSubReserve(token, user, subBalance, safeMul(subReserve, 1e10));
1459     }
1460 
1461     function subReserve(address token, address user, uint256 reserve, uint256 amount) private 
1462     {
1463         DMEX_Base(exchangeContract).setReserve(token, user, safeSub(reserve, safeMul(amount, 1e10)));
1464     }
1465 
1466     function getMakerTakerPositions(bytes32 makerPositionHash, bytes32 makerInversePositionHash, bytes32 takerPosition, bytes32 takerInversePosition) public view returns (uint256[5][4])
1467     {
1468         return [
1469             retrievePosition(makerPositionHash),
1470             retrievePosition(makerInversePositionHash),
1471             retrievePosition(takerPosition),
1472             retrievePosition(takerInversePosition)
1473         ];
1474     }
1475 
1476 
1477     struct FuturesClosePositionValues {
1478         address baseToken;
1479         uint256 reserve;                
1480         uint256 balance;                
1481         uint256 closingPrice;           
1482         bytes32 futuresContract;        
1483         uint256 expirationBlock;        
1484         uint256 entryBlock;             
1485         uint256 collateral;            
1486         uint256 totalPayable;
1487         uint256 closingBlock;
1488         uint256 liquidationPrice;
1489         uint256 closingFee;
1490         bool perpetual;
1491         uint256 profit;
1492         uint256 loss;
1493     }
1494 
1495 
1496     function closeFuturesPosition(bytes32 futuresContract, bool side, address poolAddress)
1497     {
1498         closeFuturesPositionInternal(futuresContract, side, msg.sender, poolAddress, takerFee);
1499     }
1500 
1501     function closeFuturesPositionInternal (bytes32 futuresContract, bool side, address user, address poolAddress, uint256 expirationFee) private returns (bool)
1502     {
1503         bytes32 positionHash = keccak256(this, user, futuresContract, side);        
1504         bytes32 poolPositionHash = keccak256(this, poolAddress, futuresContract, !side);        
1505 
1506         if (futuresContracts[futuresContract].closed == false && futuresContracts[futuresContract].expirationBlock != 0) throw; // contract not yet settled
1507         if (retrievePosition(positionHash)[1] == 0) throw; // position not found
1508         if (retrievePosition(positionHash)[0] == 0) throw; // position already closed
1509         if (pools[user]) return;
1510         if (!pools[poolAddress]) return;
1511 // 30 000 gas
1512         
1513         uint256 fee = min(expirationFee, takerFee);
1514 
1515         FuturesClosePositionValues memory v = FuturesClosePositionValues({
1516             baseToken       : getContractBaseToken(futuresContract),
1517             reserve         : 0,
1518             balance         : 0,
1519             closingPrice    : futuresContracts[futuresContract].closingPrice,
1520             futuresContract : futuresContract,
1521             expirationBlock : futuresContracts[futuresContract].expirationBlock,
1522             entryBlock      : retrievePosition(positionHash)[3],
1523             collateral      : 0,
1524             totalPayable    : 0,
1525             closingBlock    : futuresContracts[futuresContract].closingBlock,
1526             liquidationPrice: calculateLiquidationPriceFromPositionHash(futuresContract, side, user),
1527             closingFee      : calculateFee(retrievePosition(positionHash)[0], retrievePosition(positionHash)[1], fee, futuresContract),
1528             perpetual       : futuresContracts[futuresContract].perpetual,
1529             profit          : 0,
1530             loss            : 0
1531         });
1532 
1533         v.reserve = DMEX_Base(exchangeContract).getReserve(v.baseToken, user);
1534         v.balance = DMEX_Base(exchangeContract).balanceOf(v.baseToken, user);
1535 // 49 000        
1536 
1537         if (( side && v.closingPrice <= v.liquidationPrice) ||
1538             (!side && v.closingPrice >= v.liquidationPrice) )
1539         {
1540             liquidatePositionWithClosingPrice(futuresContract, user, side, poolAddress);
1541             return;
1542         }
1543 
1544 
1545 // 48962
1546 
1547         v.collateral = retrievePosition(positionHash)[4];         
1548         v.totalPayable = safeAdd(v.closingFee, calculateFundingCost(retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], safeSub(v.closingBlock, v.entryBlock+1), futuresContract));
1549 
1550 
1551 // 52476
1552         subReserve(
1553             v.baseToken, 
1554             user, 
1555             v.reserve, 
1556             v.collateral
1557         );             
1558 // 63991
1559 
1560         if (( side && v.closingPrice > retrievePosition(positionHash)[1]) ||
1561             (!side && v.closingPrice < retrievePosition(positionHash)[1]))
1562         {   
1563             // user made a profit
1564             v.profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, !side);
1565       
1566             if (v.profit > v.totalPayable)
1567             {
1568                 addBalance(v.baseToken, user, v.balance, safeSub(safeMul(v.profit, 1e10), safeMul(v.totalPayable, 1e10))); 
1569             }
1570             else
1571             {
1572                 subBalance(v.baseToken, user, v.balance, safeMul(min(v.collateral, safeSub(v.totalPayable, v.profit)), 1e10)); 
1573             }
1574 
1575             subBalance(v.baseToken, poolAddress, DMEX_Base(exchangeContract).balanceOf(v.baseToken, poolAddress), safeMul(v.profit, 1e10)); 
1576         }
1577         else
1578         {
1579             // user made a loss
1580             v.loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, !side);  
1581 // 66904      
1582             subBalance(v.baseToken, user, v.balance, safeMul(min(v.collateral, safeAdd(v.loss, v.totalPayable)), 1e10)); 
1583             addBalance(v.baseToken, poolAddress, DMEX_Base(exchangeContract).balanceOf(v.baseToken, poolAddress), safeMul(v.loss, 1e10)); 
1584         } 
1585 
1586         addBalance(v.baseToken, feeAccount, DMEX_Base(exchangeContract).balanceOf(v.baseToken, feeAccount), safeMul(v.totalPayable, 1e10)); // send fee to feeAccount
1587         
1588 
1589         updatePositionSize(positionHash, 0, 0, 0); 
1590         updatePositionSize(poolPositionHash, 0, 0, 0); 
1591 
1592         emit FuturesPositionClosed(positionHash, v.closingPrice);
1593 
1594         return true;
1595     }
1596 
1597     function generatePositionHash (address user, bytes32 futuresContractHash, bool side) public view returns (bytes32)
1598     {
1599         return keccak256(this, user, futuresContractHash, side);
1600     }
1601 
1602     // closes position for user
1603     function closeFuturesPositionForUser (bytes32 futuresContract, bool side, address user, address poolAddress, uint256 expirationFee) onlyAdmin
1604     {
1605         closeFuturesPositionInternal(futuresContract, side, user, poolAddress, expirationFee);
1606     }
1607 
1608     struct AddMarginValues {
1609         bytes32 addMarginHash;
1610         address baseToken;
1611     }
1612 
1613     function addMargin (bytes32 futuresContractHash, address user, bool side, uint8 vs, bytes32 r, bytes32 s, uint64 marginToAdd, uint256 operationFee)
1614     {
1615         bytes32 positionHash = generatePositionHash(user, futuresContractHash, side);        
1616         uint256[5] memory pos = retrievePosition(positionHash);
1617         if (pos[0] == 0) revert();
1618 
1619         uint256 fee = calculateFee(pos[0], pos[1], min(operationFee, takerFee), futuresContractHash); // min(operationFee, takerFee)
1620 
1621         AddMarginValues memory v = AddMarginValues({
1622             addMarginHash: keccak256(this, user, futuresContractHash, side, marginToAdd),
1623             baseToken: getContractBaseToken(futuresContractHash)
1624         });
1625 
1626         // check the signature is correct
1627         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", v.addMarginHash), vs, r, s) != user) revert();
1628 
1629         // check user has enough available balance
1630         if (DMEX_Base(exchangeContract).availableBalanceOf(v.baseToken, user) < safeMul(safeAdd(marginToAdd, fee), 1e10)) revert();
1631 
1632         // reserve additional margin and subtract fee from user
1633         subBalanceAddReserve(v.baseToken, user, safeMul(fee, 1e10), marginToAdd);
1634 
1635         // add margin to position
1636         updatePositionSize(positionHash, pos[0], pos[1], safeAdd(pos[4], marginToAdd));
1637 
1638         // add fee to feeAccount
1639         addBalance(v.baseToken, feeAccount, DMEX_Base(exchangeContract).balanceOf(v.baseToken, feeAccount), safeMul(fee, 1e10));
1640     
1641         emit FuturesMarginAdded(user, futuresContractHash, side, marginToAdd);
1642     }
1643 
1644     // Settle positions for closed contracts
1645     function batchSettlePositions (
1646         bytes32[] futuresContracts,
1647         bool[] sides,
1648         address[] users,
1649         address[] pools,
1650         uint256[] expirationFee
1651     ) onlyAdmin {
1652         
1653         for (uint i = 0; i < futuresContracts.length; i++) 
1654         {
1655             closeFuturesPositionForUser(futuresContracts[i], sides[i], users[i], pools[i], expirationFee[i]);
1656         }
1657     }
1658 
1659     // // Liquidate positions
1660     // function batchLiquidatePositions (
1661     //     bytes32[] futuresContracts,
1662     //     address[] users,
1663     //     bool[] side,
1664     //     uint256[] priceBlockNumber,
1665     //     address[] poolAddress
1666     // ) onlyAdmin {        
1667     //     for (uint i = 0; i < futuresContracts.length; i++) 
1668     //     {
1669     //         liquidatePositionWithAssetPrice(futuresContracts[i], users[i], side[i], priceBlockNumber[i], poolAddress[i]);
1670     //     }
1671     // }
1672 
1673     function liquidatePositionWithClosingPrice(bytes32 futuresContractHash, address user, bool side, address poolAddress) private
1674     {
1675         bytes32 positionHash = generatePositionHash(user, futuresContractHash, side);
1676         liquidatePosition(positionHash, futuresContractHash, user, side, futuresContracts[futuresContractHash].closingPrice, poolAddress, futuresContracts[futuresContractHash].closingBlock);
1677     }
1678 
1679     function liquidatePositionWithAssetPrice(bytes32 futuresContractHash, address user, bool side, uint256 priceBlockNumber, address poolAddress) onlyAdmin
1680     {
1681         bytes32 assetHash = futuresContracts[futuresContractHash].asset;
1682         if (assetPrices[assetHash][priceBlockNumber] == 0) return;
1683 
1684         bytes32 positionHash = generatePositionHash(user, futuresContractHash, side);
1685 
1686         // check that the price is older than postion
1687         if (priceBlockNumber < retrievePosition(positionHash)[3]) return;  
1688 
1689         liquidatePosition(positionHash, futuresContractHash, user, side, assetPrices[assetHash][priceBlockNumber], poolAddress, priceBlockNumber);
1690     }
1691 
1692     struct LiquidatePositionValues {
1693         uint256 maintenanceMargin;
1694         uint256 fundingRate;
1695         uint256 multiplier;
1696     }
1697 
1698     function liquidatePosition (bytes32 positionHash, bytes32 futuresContractHash, address user, bool side, uint256 price, address poolAddress, uint256 block) private
1699     {
1700         uint256[5] memory pos = retrievePosition(positionHash);
1701         if (pos[0] == 0) return;
1702         if (!pools[poolAddress]) return;      
1703 
1704         bytes32 assetHash = futuresContracts[futuresContractHash].asset;  
1705 
1706 
1707         uint256 collateral = pos[4];
1708         uint256 fundingBlocks = safeSub(block, pos[3]);
1709 
1710         LiquidatePositionValues memory v = LiquidatePositionValues({
1711             maintenanceMargin: getMaintenanceMargin(futuresContractHash),
1712             fundingRate: futuresContracts[futuresContractHash].fundingRate,
1713             multiplier: futuresContracts[futuresContractHash].multiplier
1714         });
1715         
1716         // uint256 maintenanceMargin = futuresAssets[assetHash].maintenanceMargin;
1717         // uint256 fundingRate = futuresContracts[futuresContractHash].fundingRate;
1718         // uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1719 
1720         uint256 liquidationPrice = calculateLiquidationPrice(pos, [fundingBlocks, v.fundingRate, v.maintenanceMargin, v.multiplier]);
1721 
1722         //LogUint(5, liquidationPrice);
1723 
1724         // get block price
1725         if (( side && price >= liquidationPrice)
1726         ||  (!side && price <= liquidationPrice))
1727         {
1728             emit LogError(uint8(Errors.LIQUIDATION_PRICE_NOT_TOUCHED), futuresContractHash, positionHash);
1729             return; 
1730         }
1731 
1732         // deduct collateral from user account
1733         subBalanceSubReserve(futuresAssets[assetHash].baseToken, user, safeMul(collateral, 1e10), collateral);
1734 
1735         // send collateral to pool address
1736         addBalance(futuresAssets[assetHash].baseToken, poolAddress, DMEX_Base(exchangeContract).balanceOf(futuresAssets[assetHash].baseToken, poolAddress), safeMul(collateral, 1e10));
1737     
1738         updatePositionSize(positionHash, 0, 0, 0); 
1739         updatePositionSize(generatePositionHash(poolAddress, futuresContractHash, !side), 0, 0, 0); 
1740 
1741         emit PositionLiquidated(positionHash, price);
1742     }
1743 
1744     struct LiquidationPriceValues {
1745         uint256 size;
1746         uint256 price;
1747         uint256 baseCollateral;
1748     }
1749 
1750     function calculateLiquidationPriceFromPositionHash (bytes32 futuresContractHash, bool side, address user) returns (uint256)
1751     {
1752         bytes32 positionHash = keccak256(this, user, futuresContractHash, side);      
1753         uint256[5] memory pos = retrievePosition(positionHash);
1754 
1755         if (pos[0] == 0) return;
1756 
1757         uint256 fundingRate = futuresContracts[futuresContractHash].fundingRate;
1758         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1759         uint256 maintenanceMargin = getMaintenanceMargin(futuresContractHash);
1760 
1761         return calculateLiquidationPrice (pos, [safeSub(block.number, pos[3]), fundingRate, maintenanceMargin, multiplier]);
1762     }
1763 
1764     function calculateLiquidationPrice(uint256[5] pos, uint256[4] values) public view returns (uint256)
1765     {
1766     
1767         /*
1768             values
1769             [0] fundingBlocks 
1770             [1] fundingRate
1771             [2] maintenanceMargin 
1772             [3] multiplier
1773         */
1774         LiquidationPriceValues memory v = LiquidationPriceValues({
1775             size: pos[0],
1776             price: pos[1],
1777             baseCollateral: pos[4]
1778         });
1779         
1780         uint256 collateral = safeMul(v.baseCollateral, 1e8) / values[3];
1781         
1782         
1783         uint256 leverage = safeMul(v.price,v.size)/collateral/1e8;
1784         uint256 coef = safeMul(values[2], 1e10)/leverage;
1785         
1786         uint256 fundingCost = safeMul(safeMul(safeMul(v.size, v.price)/1e8, values[0]), values[1])/1e18;
1787         
1788         uint256 netLiqPrice;
1789         uint256 liquidationPrice;
1790         
1791         uint256 movement = safeMul(safeSub(collateral, fundingCost), 1e8)/v.size;
1792         
1793         
1794         if (pos[2] == 0)
1795         {
1796         
1797             netLiqPrice = safeAdd(v.price, movement);
1798             liquidationPrice = safeSub(netLiqPrice, safeMul(v.price, coef)/1e18); 
1799         }
1800         else
1801         {
1802             netLiqPrice = safeSub(v.price, movement);
1803             liquidationPrice = safeAdd(netLiqPrice, safeMul(v.price, coef)/1e18); 
1804         }        
1805         
1806         return liquidationPrice;
1807     }
1808 
1809 
1810     // Returns the smaller of two values
1811     function min(uint a, uint b) private pure returns (uint) {
1812         return a < b ? a : b;
1813     }
1814 
1815     // Returns the largest of the two values
1816     function max(uint a, uint b) private pure returns (uint) {
1817         return a > b ? a : b;
1818     }
1819 }