1 pragma solidity ^0.4.19;
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
20 contract EtherMium {
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
36     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) returns (bool);
37     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) returns (bool);
38 }
39 
40 // The DMEX Futures Contract
41 contract Exchange {
42     function assert(bool assertion) pure {
43         if (!assertion) throw;
44     }
45 
46     // Safe Multiply Function - prevents integer overflow 
47     function safeMul(uint a, uint b) pure returns (uint) {
48         uint c = a * b;
49         assert(a == 0 || c / a == b);
50         return c;
51     }
52 
53     // Safe Subtraction Function - prevents integer overflow 
54     function safeSub(uint a, uint b) pure returns (uint) {
55         assert(b <= a);
56         return a - b;
57     }
58 
59     // Safe Addition Function - prevents integer overflow 
60     function safeAdd(uint a, uint b) pure returns (uint) {
61         uint c = a + b;
62         assert(c>=a && c>=b);
63         return c;
64     }
65 
66     address public owner; // holds the address of the contract owner
67 
68     // Event fired when the owner of the contract is changed
69     event SetOwner(address indexed previousOwner, address indexed newOwner);
70 
71     // Allows only the owner of the contract to execute the function
72     modifier onlyOwner {
73         assert(msg.sender == owner);
74         _;
75     }
76 
77     // Changes the owner of the contract
78     function setOwner(address newOwner) onlyOwner {
79         emit SetOwner(owner, newOwner);
80         owner = newOwner;
81     }
82 
83     // Owner getter function
84     function getOwner() view returns (address out) {
85         return owner;
86     }
87 
88     mapping (address => bool) public admins;                    // mapping of admin addresses
89     mapping (address => uint256) public lastActiveTransaction;  // mapping of user addresses to last transaction block
90     mapping (bytes32 => uint256) public orderFills;             // mapping of orders to filled qunatity
91     
92     address public feeAccount;          // the account that receives the trading fees
93     address public exchangeContract;    // the address of the main EtherMium contract
94 
95     uint256 public makerFee;            // maker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
96     uint256 public takerFee;            // taker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
97     
98     struct FuturesAsset {
99         string name;                    // the name of the traded asset (ex. ETHUSD)
100         address baseToken;              // the token for collateral
101         string priceUrl;                // the url where the price of the asset will be taken for settlement
102         string pricePath;               // price path in the returned JSON from the priceUrl (ex. path "last" will return tha value last from the json: {"high": "156.49", "last": "154.31", "timestamp": "1556522201", "bid": "154.22", "vwap": "154.65", "volume": "25578.79138868", "low": "152.33", "ask": "154.26", "open": "152.99"})
103         bool multiplied;                // if true, the price from the priceUrl will be multiplied by the multiplierPriceUrl
104         string multiplierPriceUrl;      // needed only if multiplied=true
105         string multiplierPricePath;     // same as pricePath 
106         bool inverseMultiplier;         // if true, the priceUrl will be multiplied by 1/multiplierPriceUrl
107         bool disabled;                  // if true, the asset cannot be used in contract creation (when price url no longer valid)
108     }
109 
110     function createFuturesAsset(string name, address baseToken, string priceUrl, string pricePath, bool multiplied, string multiplierPriceUrl, string multiplierPricePath, bool inverseMultiplier) onlyAdmin returns (bytes32)
111     {    
112         bytes32 futuresAsset = keccak256(this, name, baseToken, priceUrl, pricePath, multiplied, multiplierPriceUrl, multiplierPricePath, inverseMultiplier);
113         if (futuresAssets[futuresAsset].disabled) throw; // asset already exists and is disabled
114 
115         futuresAssets[futuresAsset] = FuturesAsset({
116             name                : name,
117             baseToken           : baseToken,
118             priceUrl            : priceUrl,
119             pricePath           : pricePath,
120             multiplied          : multiplied,
121             multiplierPriceUrl  : multiplierPriceUrl,
122             multiplierPricePath : multiplierPricePath,
123             inverseMultiplier   : inverseMultiplier,
124             disabled            : false
125         });
126 
127         emit FuturesAssetCreated(futuresAsset, name, baseToken, priceUrl, pricePath, multiplied, multiplierPriceUrl, multiplierPricePath, inverseMultiplier);
128         return futuresAsset;
129     }
130     
131     struct FuturesContract {
132         bytes32 asset;                  // the hash of the underlying asset object
133         uint256 expirationBlock;        // futures contract expiration block
134         uint256 closingPrice;           // the closing price for the futures contract
135         bool closed;                    // is the futures contract closed (0 - false, 1 - true)
136         bool broken;                    // if someone has forced release of funds the contract is marked as broken and can no longer close positions (0-false, 1-true)
137         uint256 floorPrice;             // the minimum price that can be traded on the contract, once price is reached the contract expires and enters settlement state 
138         uint256 capPrice;               // the maximum price that can be traded on the contract, once price is reached the contract expires and enters settlement state
139     }
140 
141     function createFuturesContract(bytes32 asset, uint256 expirationBlock, uint256 floorPrice, uint256 capPrice) onlyAdmin returns (bytes32)
142     {    
143         bytes32 futuresContract = keccak256(this, asset, expirationBlock, floorPrice, capPrice);
144         if (futuresContracts[futuresContract].expirationBlock > 0) throw; // contract already exists
145 
146         futuresContracts[futuresContract] = FuturesContract({
147             asset           : asset,
148             expirationBlock : expirationBlock,
149             closingPrice    : 0,
150             closed          : false,
151             broken          : false,
152             floorPrice      : floorPrice,
153             capPrice        : capPrice
154         });
155 
156         emit FuturesContractCreated(futuresContract, asset, expirationBlock, floorPrice, capPrice);
157 
158         return futuresContract;
159     }
160 
161     mapping (bytes32 => FuturesAsset)       public futuresAssets;       // mapping of futuresAsset hash to FuturesAsset structs
162     mapping (bytes32 => FuturesContract)    public futuresContracts;   // mapping of futuresContract hash to FuturesContract structs
163     mapping (bytes32 => uint256)            public positions;          // mapping of user addresses to position hashes to position
164 
165     enum Errors {
166         INVALID_PRICE,                  // Order prices don't match
167         INVALID_SIGNATURE,              // Signature is invalid
168         ORDER_ALREADY_FILLED,           // Order was already filled
169         GAS_TOO_HIGH,                   // Too high gas fee
170         OUT_OF_BALANCE,                 // User doesn't have enough balance for the operation
171         FUTURES_CONTRACT_EXPIRED,       // Futures contract already expired
172         FLOOR_OR_CAP_PRICE_REACHED,     // The floor price or the cap price for the futures contract was reached
173         POSITION_ALREADY_EXISTS,        // User has an open position already 
174         UINT48_VALIDATION               // Size or price bigger than an Uint48
175     }
176 
177     event FuturesTrade(bool side, uint256 size, uint256 price, bytes32 indexed futuresContract, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
178     event FuturesContractClosed(bytes32 indexed futuresContract, uint256 closingPrice);
179     event FuturesForcedRelease(bytes32 indexed futuresContract, bool side, address user);
180     event FuturesAssetCreated(bytes32 indexed futuresAsset, string name, address baseToken, string priceUrl, string pricePath, bool multiplied, string multiplierPriceUrl, string multiplierPricePath, bool inverseMultiplier);
181     event FuturesContractCreated(bytes32 indexed futuresContract, bytes32 asset, uint256 expirationBlock, uint256 floorPrice, uint256 capPrice);
182  
183     // Fee change event
184     event FeeChange(uint256 indexed makerFee, uint256 indexed takerFee);
185 
186     // Log event, logs errors in contract execution (for internal use)
187     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
188     event LogUint(uint8 id, uint256 value);
189     event LogBool(uint8 id, bool value);
190     event LogAddress(uint8 id, address value);
191 
192 
193     // Constructor function, initializes the contract and sets the core variables
194     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, address exchangeContract_) {
195         owner               = msg.sender;
196         feeAccount          = feeAccount_;
197         makerFee            = makerFee_;
198         takerFee            = takerFee_;
199 
200         exchangeContract    = exchangeContract_;
201     }
202 
203     // Changes the fees
204     function setFees(uint256 makerFee_, uint256 takerFee_) onlyOwner {
205         require(makerFee_       < 10 finney && takerFee_ < 10 finney); // The fees cannot be set higher then 1%
206         makerFee                = makerFee_;
207         takerFee                = takerFee_;
208 
209         emit FeeChange(makerFee, takerFee);
210     }
211 
212     // Adds or disables an admin account
213     function setAdmin(address admin, bool isAdmin) onlyOwner {
214         admins[admin] = isAdmin;
215     }
216 
217     // Allows for admins only to call the function
218     modifier onlyAdmin {
219         if (msg.sender != owner && !admins[msg.sender]) throw;
220         _;
221     }
222 
223     function() external {
224         throw;
225     }   
226 
227 
228     function validateUint48(uint256 val) returns (bool)
229     {
230         if (val != uint48(val)) return false;
231         return true;
232     }
233 
234     function validateUint64(uint256 val) returns (bool)
235     {
236         if (val != uint64(val)) return false;
237         return true;
238     }
239 
240     function validateUint128(uint256 val) returns (bool)
241     {
242         if (val != uint128(val)) return false;
243         return true;
244     }
245 
246 
247     // Structure that holds order values, used inside the trade() function
248     struct FuturesOrderPair {
249         uint256 makerNonce;                 // maker order nonce, makes the order unique
250         uint256 takerNonce;                 // taker order nonce
251         uint256 takerGasFee;                // taker gas fee, taker pays the gas
252         uint256 takerIsBuying;              // true/false taker is the buyer
253 
254         address maker;                      // address of the maker
255         address taker;                      // address of the taker
256 
257         bytes32 makerOrderHash;             // hash of the maker order
258         bytes32 takerOrderHash;             // has of the taker order
259 
260         uint256 makerAmount;                // trade amount for maker
261         uint256 takerAmount;                // trade amount for taker
262 
263         uint256 makerPrice;                 // maker order price in wei (18 decimal precision)
264         uint256 takerPrice;                 // taker order price in wei (18 decimal precision)
265 
266         bytes32 futuresContract;            // the futures contract being traded
267 
268         address baseToken;                  // the address of the base token for futures contract
269         uint256 floorPrice;                 // floor price of futures contract
270         uint256 capPrice;                   // cap price of futures contract
271 
272         bytes32 makerPositionHash;          // hash for maker position
273         bytes32 makerInversePositionHash;   // hash for inverse maker position 
274 
275         bytes32 takerPositionHash;          // hash for taker position
276         bytes32 takerInversePositionHash;   // hash for inverse taker position
277     }
278 
279     // Structure that holds trade values, used inside the trade() function
280     struct FuturesTradeValues {
281         uint256 qty;                // amount to be trade
282         uint256 makerProfit;        // holds maker profit value
283         uint256 makerLoss;          // holds maker loss value
284         uint256 takerProfit;        // holds taker profit value
285         uint256 takerLoss;          // holds taker loss value
286         uint256 makerBalance;       // holds maker balance value
287         uint256 takerBalance;       // holds taker balance value
288         uint256 makerReserve;       // holds taker reserved value
289         uint256 takerReserve;       // holds taker reserved value
290     }
291 
292     // Opens/closes futures positions
293     function futuresTrade(
294         uint8[2] v,
295         bytes32[4] rs,
296         uint256[8] tradeValues,
297         address[2] tradeAddresses,
298         bool takerIsBuying,
299         bytes32 futuresContractHash
300     ) onlyAdmin returns (uint filledTakerTokenAmount)
301     {
302 
303         /* tradeValues
304           [0] makerNonce
305           [1] takerNonce
306           [2] takerGasFee
307           [3] takerIsBuying
308           [4] makerAmount
309           [5] takerAmount
310           [6] makerPrice
311           [7] takerPrice
312 
313 
314           tradeAddresses
315           [0] maker
316           [1] taker
317         */
318 
319         FuturesOrderPair memory t  = FuturesOrderPair({
320             makerNonce      : tradeValues[0],
321             takerNonce      : tradeValues[1],
322             takerGasFee     : tradeValues[2],
323             takerIsBuying   : tradeValues[3],
324             makerAmount     : tradeValues[4],      
325             takerAmount     : tradeValues[5],   
326             makerPrice      : tradeValues[6],         
327             takerPrice      : tradeValues[7],
328 
329             maker           : tradeAddresses[0],
330             taker           : tradeAddresses[1],
331 
332             //                                futuresContract      user               amount          price           side             nonce
333             makerOrderHash  : keccak256(this, futuresContractHash, tradeAddresses[0], tradeValues[4], tradeValues[6], !takerIsBuying, tradeValues[0]),
334             takerOrderHash  : keccak256(this, futuresContractHash, tradeAddresses[1], tradeValues[5], tradeValues[7],  takerIsBuying, tradeValues[1]),            
335 
336             futuresContract : futuresContractHash,
337 
338             baseToken       : futuresAssets[futuresContracts[futuresContractHash].asset].baseToken,
339             floorPrice      : futuresContracts[futuresContractHash].floorPrice,
340             capPrice        : futuresContracts[futuresContractHash].capPrice,
341 
342             //                                            user               futuresContractHash   side
343             makerPositionHash           : keccak256(this, tradeAddresses[0], futuresContractHash, !takerIsBuying),
344             makerInversePositionHash    : keccak256(this, tradeAddresses[0], futuresContractHash, takerIsBuying),
345 
346             takerPositionHash           : keccak256(this, tradeAddresses[1], futuresContractHash, takerIsBuying),
347             takerInversePositionHash    : keccak256(this, tradeAddresses[1], futuresContractHash, !takerIsBuying)
348 
349         });
350 
351 //--> 44 000
352     
353         // Valifate size and price values
354         if (!validateUint128(t.makerAmount) || !validateUint128(t.takerAmount) || !validateUint64(t.makerPrice) || !validateUint64(t.takerPrice))
355         {            
356             emit LogError(uint8(Errors.UINT48_VALIDATION), t.makerOrderHash, t.takerOrderHash);
357             return 0; 
358         }
359 
360 
361         // Check if futures contract has expired already
362         if (block.number > futuresContracts[t.futuresContract].expirationBlock || futuresContracts[t.futuresContract].closed == true || futuresContracts[t.futuresContract].broken == true)
363         {
364             emit LogError(uint8(Errors.FUTURES_CONTRACT_EXPIRED), t.makerOrderHash, t.takerOrderHash);
365             return 0; // futures contract is expired
366         }
367 
368         // Checks the signature for the maker order
369         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
370         {
371             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
372             return 0;
373         }
374        
375         // Checks the signature for the taker order
376         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
377         {
378             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
379             return 0;
380         }
381 
382         // Cheks that gas fee is not higher than 10%
383         if (t.takerGasFee > 100 finney)
384         {
385             emit LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
386             return 0;
387         } // takerGasFee too high
388 
389 
390         // check prices
391         if ((!takerIsBuying && t.makerPrice < t.takerPrice) || (takerIsBuying && t.takerPrice < t.makerPrice))
392         {
393             emit LogError(uint8(Errors.INVALID_PRICE), t.makerOrderHash, t.takerOrderHash);
394             return 0; // prices don't match
395         }      
396 
397 //--> 54 000
398 
399          
400         
401 
402         uint256[4] memory balances = EtherMium(exchangeContract).getMakerTakerBalances(t.baseToken, t.maker, t.taker);
403 
404         // Initializing trade values structure 
405         FuturesTradeValues memory tv = FuturesTradeValues({
406             qty                 : 0,
407             makerProfit         : 0,
408             makerLoss           : 0,
409             takerProfit         : 0,
410             takerLoss           : 0,
411             makerBalance        : balances[0], //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
412             takerBalance        : balances[1],  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
413             makerReserve        : balances[2],  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
414             takerReserve        : balances[3]  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
415         });
416 
417 //--> 60 000
418 
419 
420          
421 
422         // check if floor price or cap price was reached
423         if (futuresContracts[t.futuresContract].floorPrice >= t.makerPrice || futuresContracts[t.futuresContract].capPrice <= t.makerPrice)
424         {
425             // attepting price outside range
426             emit LogError(uint8(Errors.FLOOR_OR_CAP_PRICE_REACHED), t.makerOrderHash, t.takerOrderHash);
427             return 0;
428         }
429 
430         // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
431         // and open inverse positions
432         tv.qty = min(safeSub(t.makerAmount, orderFills[t.makerOrderHash]), safeSub(t.takerAmount, orderFills[t.takerOrderHash]));
433         
434         if (positionExists(t.makerInversePositionHash) && positionExists(t.takerInversePositionHash))
435         {
436             tv.qty = min(tv.qty, min(retrievePosition(t.makerInversePositionHash)[0], retrievePosition(t.takerInversePositionHash)[0]));
437         }
438         else if (positionExists(t.makerInversePositionHash))
439         {
440             tv.qty = min(tv.qty, retrievePosition(t.makerInversePositionHash)[0]);
441         }
442         else if (positionExists(t.takerInversePositionHash))
443         {
444             tv.qty = min(tv.qty, retrievePosition(t.takerInversePositionHash)[0]);
445         }
446 
447        
448 
449 
450 
451 //--> 64 000       
452         
453         if (tv.qty == 0)
454         {
455             // no qty left on orders
456             emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
457             return 0;
458         }
459 
460         // check if users have open positions already
461         // if (positionExists(t.makerPositionHash) || positionExists(t.takerPositionHash))
462         // {
463         //     // maker already has the position open, first must close existing position before opening a new one
464         //     emit LogError(uint8(Errors.POSITION_ALREADY_EXISTS), t.makerOrderHash, t.takerOrderHash);
465         //     return 0; 
466         // }
467 
468 //--> 66 000
469         
470 
471         
472 
473         /*------------- Maker long, Taker short -------------*/
474         if (!takerIsBuying)
475         {     
476             
477       
478             // position actions for maker
479             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
480             {
481                 // check if maker has enough balance        
482 
483                 
484                 if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
485                 {
486                     // maker out of balance
487                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
488                     return 0; 
489                 }
490                 
491                 // create new position
492                 recordNewPosition(t.makerPositionHash, tv.qty, t.makerPrice, 1, block.number);
493 
494                 updateBalances(
495                     t.futuresContract, 
496                     [
497                         t.baseToken, // base token
498                         t.maker // make address
499                     ], 
500                     t.makerPositionHash,  // position hash
501                     [
502                         tv.qty, // qty
503                         t.makerPrice,  // price
504                         makerFee, // fee
505                         0, // profit
506                         0, // loss
507                         tv.makerBalance, // balance
508                         0, // gasFee
509                         tv.makerReserve // reserve
510                     ], 
511                     [
512                         true, // newPostion (if true position is new)
513                         true, // side (if true - long)
514                         false // increase position (if true)
515                     ]
516                 );
517 
518             } else {               
519                 
520                 if (positionExists(t.makerPositionHash))
521                 {
522                     // check if maker has enough balance            
523                     // if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, 
524                     //     safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
525                     if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
526                     {
527                         // maker out of balance
528                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
529                         return 0; 
530                     }
531 
532                     // increase position size
533                     updatePositionSize(t.makerPositionHash, safeAdd(retrievePosition(t.makerPositionHash)[0], tv.qty), t.makerPrice);
534                 
535                     updateBalances(
536                         t.futuresContract, 
537                         [
538                             t.baseToken,  // base token
539                             t.maker // make address
540                         ], 
541                         t.makerPositionHash, // position hash
542                         [
543                             tv.qty, // qty
544                             t.makerPrice, // price
545                             makerFee, // fee
546                             0, // profit
547                             0, // loss
548                             tv.makerBalance, // balance
549                             0, // gasFee
550                             tv.makerReserve // reserve
551                         ], 
552                         [
553                             false, // newPostion (if true position is new)
554                             true, // side (if true - long)
555                             true // increase position (if true)
556                         ]
557                     );
558                 }
559                 else
560                 {
561                     // close/partially close existing position
562                     updatePositionSize(t.makerInversePositionHash, safeSub(retrievePosition(t.makerInversePositionHash)[0], tv.qty), 0);
563                     
564                     if (t.makerPrice < retrievePosition(t.makerInversePositionHash)[1])
565                     {
566                         // user has made a profit
567                         //tv.makerProfit                    = safeMul(safeSub(retrievePosition(t.makerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;
568                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);
569                     }
570                     else
571                     {
572                         // user has made a loss
573                         //tv.makerLoss                      = safeMul(safeSub(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1]), tv.qty) / t.makerPrice;    
574                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                        
575                     }
576 
577 
578                     updateBalances(
579                         t.futuresContract, 
580                         [
581                             t.baseToken, // base token
582                             t.maker // make address
583                         ], 
584                         t.makerInversePositionHash, // position hash
585                         [
586                             tv.qty, // qty
587                             t.makerPrice, // price
588                             makerFee, // fee
589                             tv.makerProfit,  // profit
590                             tv.makerLoss,  // loss
591                             tv.makerBalance, // balance
592                             0, // gasFee
593                             tv.makerReserve // reserve
594                         ], 
595                         [
596                             false, // newPostion (if true position is new)
597                             true, // side (if true - long)
598                             false // increase position (if true)
599                         ]
600                     );
601                 }                
602             }
603 
604            
605 
606 
607             // position actions for taker
608             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
609             {
610                 
611                 // check if taker has enough balance
612                 // if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether))  * 1e10, t.takerGasFee) > safeSub(balances[1],tv.takerReserve))
613                 if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
614                 {
615                     // maker out of balance
616                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
617                     return 0; 
618                 }
619                 
620                 // create new position
621                 recordNewPosition(t.takerPositionHash, tv.qty, t.makerPrice, 0, block.number);
622                 
623                 updateBalances(
624                     t.futuresContract, 
625                     [
626                         t.baseToken, // base token
627                         t.taker // make address
628                     ], 
629                     t.takerPositionHash, // position hash
630                     [
631                         tv.qty, // qty
632                         t.makerPrice,  // price
633                         takerFee, // fee
634                         0, // profit
635                         0,  // loss
636                         tv.takerBalance,  // balance
637                         t.takerGasFee, // gasFee
638                         tv.takerReserve // reserve
639                     ], 
640                     [
641                         true, // newPostion (if true position is new)
642                         false, // side (if true - long)
643                         false // increase position (if true)
644                     ]
645                 );
646 
647             } else {
648                 if (positionExists(t.takerPositionHash))
649                 {
650                     // check if taker has enough balance
651                     //if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether))  * 1e10, t.takerGasFee) > safeSub(balances[1],tv.takerReserve))
652                     if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
653                     {
654                         // maker out of balance
655                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
656                         return 0; 
657                     }
658 
659                     // increase position size
660                     updatePositionSize(t.takerPositionHash, safeAdd(retrievePosition(t.takerPositionHash)[0], tv.qty), t.makerPrice);
661                 
662                     updateBalances(
663                         t.futuresContract, 
664                         [
665                             t.baseToken,  // base token
666                             t.taker // make address
667                         ], 
668                         t.takerPositionHash, // position hash
669                         [
670                             tv.qty, // qty
671                             t.makerPrice, // price
672                             takerFee, // fee
673                             0, // profit
674                             0, // loss
675                             tv.takerBalance, // balance
676                             0, // gasFee
677                             tv.takerReserve // reserve
678                         ], 
679                         [
680                             false, // newPostion (if true position is new)
681                             false, // side (if true - long)
682                             true // increase position (if true)
683                         ]
684                     );
685                 }
686                 else
687                 {
688                     // close/partially close existing position
689                     updatePositionSize(t.takerInversePositionHash, safeSub(retrievePosition(t.takerInversePositionHash)[0], tv.qty), 0);
690                 
691                     if (t.makerPrice > retrievePosition(t.takerInversePositionHash)[1])
692                     {
693                         // user has made a profit
694                         //tv.takerProfit                    = safeMul(safeSub(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1]), tv.qty) / t.makerPrice;
695                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false);
696                     }
697                     else
698                     {
699                         // user has made a loss
700                         //tv.takerLoss                      = safeMul(safeSub(retrievePosition(t.takerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;                                  
701                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false); 
702                     }
703 
704                     updateBalances(
705                         t.futuresContract, 
706                         [
707                             t.baseToken, // base token
708                             t.taker // make address
709                         ], 
710                         t.takerInversePositionHash, // position hash
711                         [
712                             tv.qty, // qty
713                             t.makerPrice, // price
714                             takerFee, // fee
715                             tv.takerProfit, // profit
716                             tv.takerLoss, // loss
717                             tv.takerBalance,  // balance
718                             t.takerGasFee,  // gasFee
719                             tv.takerReserve // reserve
720                         ], 
721                         [
722                             false, // newPostion (if true position is new)
723                             false, // side (if true - long)
724                             false // increase position (if true)
725                         ]
726                     );
727                 }
728             }
729         }
730 
731 
732         /*------------- Maker short, Taker long -------------*/
733 
734         else
735         {      
736             //LogUint(1, safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty)); return;
737 
738             // position actions for maker
739             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
740             {
741                 // check if maker has enough balance
742                 //if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
743                 if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
744                 {
745                     // maker out of balance
746                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
747                     return 0; 
748                 }
749 
750                 // create new position
751                 recordNewPosition(t.makerPositionHash, tv.qty, t.makerPrice, 0, block.number);
752                 updateBalances(
753                     t.futuresContract, 
754                     [
755                         t.baseToken,   // base token
756                         t.maker // make address
757                     ], 
758                     t.makerPositionHash, // position hash
759                     [
760                         tv.qty, // qty
761                         t.makerPrice, // price
762                         makerFee, // fee
763                         0, // profit
764                         0, // loss
765                         tv.makerBalance, // balance
766                         0, // gasFee
767                         tv.makerReserve // reserve
768                     ], 
769                     [
770                         true, // newPostion (if true position is new)
771                         false, // side (if true - long)
772                         false // increase position (if true)
773                     ]
774                 );
775 
776             } else {
777                 if (positionExists(t.makerPositionHash))
778                 {
779                     // check if maker has enough balance
780                     //if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
781                     if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
782                     {
783                         // maker out of balance
784                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
785                         return 0; 
786                     }
787 
788                     // increase position size
789                     updatePositionSize(t.makerPositionHash, safeAdd(retrievePosition(t.makerPositionHash)[0], tv.qty), t.makerPrice);
790                 
791                     updateBalances(
792                         t.futuresContract, 
793                         [
794                             t.baseToken,  // base token
795                             t.maker // make address
796                         ], 
797                         t.makerPositionHash, // position hash
798                         [
799                             tv.qty, // qty
800                             t.makerPrice, // price
801                             makerFee, // fee
802                             0, // profit
803                             0, // loss
804                             tv.makerBalance, // balance
805                             0, // gasFee
806                             tv.makerReserve // reserve
807                         ], 
808                         [
809                             false, // newPostion (if true position is new)
810                             false, // side (if true - long)
811                             true // increase position (if true)
812                         ]
813                     );
814                 }
815                 else
816                 {
817                     // close/partially close existing position
818                     updatePositionSize(t.makerInversePositionHash, safeSub(retrievePosition(t.makerInversePositionHash)[0], tv.qty), 0);       
819                     
820                     if (t.makerPrice > retrievePosition(t.makerInversePositionHash)[1])
821                     {
822                         // user has made a profit
823                         //tv.makerProfit                    = safeMul(safeSub(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1]), tv.qty) / t.makerPrice;
824                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);
825                     }
826                     else
827                     {
828                         // user has made a loss
829                         //tv.makerLoss                      = safeMul(safeSub(retrievePosition(t.makerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice; 
830                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);                               
831                     }
832 
833                     updateBalances(
834                         t.futuresContract, 
835                         [
836                             t.baseToken, // base token
837                             t.maker // user address
838                         ], 
839                         t.makerInversePositionHash, // position hash
840                         [
841                             tv.qty, // qty
842                             t.makerPrice, // price
843                             makerFee, // fee
844                             tv.makerProfit,  // profit
845                             tv.makerLoss, // loss
846                             tv.makerBalance, // balance
847                             0, // gasFee
848                             tv.makerReserve // reserve
849                         ], 
850                         [
851                             false, // newPostion (if true position is new)
852                             false, // side (if true - long)
853                             false // increase position (if true)
854                         ]
855                     );
856                 }
857             }
858 
859             // position actions for taker
860             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
861             {
862                 // check if taker has enough balance
863                 // if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether)), t.takerGasFee / 1e10) * 1e10 > safeSub(balances[1],tv.takerReserve))
864                 if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
865                 {
866                     // maker out of balance
867                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
868                     return 0; 
869                 }
870 
871                 // create new position
872                 recordNewPosition(t.takerPositionHash, tv.qty, t.makerPrice, 1, block.number);
873            
874                 updateBalances(
875                     t.futuresContract, 
876                     [
877                         t.baseToken,  // base token
878                         t.taker // user address
879                     ], 
880                     t.takerPositionHash, // position hash
881                     [
882                         tv.qty, // qty
883                         t.makerPrice, // price
884                         takerFee, // fee
885                         0,  // profit
886                         0,  // loss
887                         tv.takerBalance, // balance
888                         t.takerGasFee, // gasFee
889                         tv.takerReserve // reserve
890                     ], 
891                     [
892                         true, // newPostion (if true position is new)
893                         true, // side (if true - long)
894                         false // increase position (if true)
895                     ]
896                 );
897 
898             } else {
899                 if (positionExists(t.takerPositionHash))
900                 {
901                     // check if taker has enough balance
902                     //if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether)), t.takerGasFee / 1e10) * 1e10 > safeSub(balances[1],tv.takerReserve))
903                     if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
904                     {
905                         // maker out of balance
906                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
907                         return 0; 
908                     }
909                     
910                     // increase position size
911                     updatePositionSize(t.takerPositionHash, safeAdd(retrievePosition(t.takerPositionHash)[0], tv.qty), t.makerPrice);
912                 
913                     updateBalances(
914                         t.futuresContract, 
915                         [
916                             t.baseToken,  // base token
917                             t.taker // user address
918                         ], 
919                         t.takerPositionHash, // position hash
920                         [
921                             tv.qty, // qty
922                             t.makerPrice, // price
923                             takerFee, // fee
924                             0, // profit
925                             0, // loss
926                             tv.takerBalance, // balance
927                             0, // gasFee
928                             tv.takerReserve // reserve
929                         ], 
930                         [
931                             false, // newPostion (if true position is new)
932                             true, // side (if true - long)
933                             true // increase position (if true)
934                         ]
935                     );
936                 }
937                 else
938                 {
939                     // close/partially close existing position
940                     updatePositionSize(t.takerInversePositionHash, safeSub(retrievePosition(t.takerInversePositionHash)[0], tv.qty), 0);
941                                      
942                     if (t.makerPrice < retrievePosition(t.takerInversePositionHash)[1])
943                     {
944                         // user has made a profit
945                         //tv.takerProfit                    = safeMul(safeSub(retrievePosition(t.takerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;
946                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);
947                     }
948                     else
949                     {
950                         // user has made a loss
951                         //tv.takerLoss                      = safeMul(safeSub(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1]), tv.qty) / t.makerPrice; 
952                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                  
953                     }
954 
955                     updateBalances(
956                         t.futuresContract, 
957                         [
958                             t.baseToken,   // base toke
959                             t.taker // user address
960                         ], 
961                         t.takerInversePositionHash,  // position hash
962                         [
963                             tv.qty, // qty
964                             t.makerPrice, // price
965                             takerFee, // fee
966                             tv.takerProfit, // profit
967                             tv.takerLoss, // loss
968                             tv.takerBalance, // balance
969                             t.takerGasFee, // gasFee
970                             tv.takerReserve // reserve
971                         ], 
972                         [
973                             false, // newPostion (if true position is new)
974                             true, // side (if true - long) 
975                             false // increase position (if true)
976                         ]
977                     );
978                 }
979             }           
980         }
981 
982 //--> 220 000
983         orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty); // increase the maker order filled amount
984         orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); // increase the taker order filled amount
985 
986 //--> 264 000
987         emit FuturesTrade(takerIsBuying, tv.qty, t.makerPrice, t.futuresContract, t.makerOrderHash, t.takerOrderHash);
988 
989         return tv.qty;
990     }
991 
992     function calculateProfit(uint256 closingPrice, uint256 entryPrice, uint256 qty, bytes32 futuresContractHash, bool side) returns (uint256)
993     {
994         if (side)
995         {
996             return safeMul(safeSub(entryPrice, closingPrice), qty) / closingPrice; 
997         }
998         else
999         {
1000             return safeMul(safeSub(closingPrice, entryPrice), qty) / closingPrice; 
1001         }
1002         
1003     }
1004 
1005     function calculateLoss(uint256 closingPrice, uint256 entryPrice, uint256 qty, bytes32 futuresContractHash, bool side) returns (uint256)
1006     {
1007         if (side)
1008         {
1009             return safeMul(safeSub(closingPrice, entryPrice), qty) / closingPrice;
1010         }
1011         else
1012         {
1013             return safeMul(safeSub(entryPrice, closingPrice), qty) / closingPrice; 
1014         }
1015         
1016     }
1017 
1018     function checkEnoughBalance (uint256 limitPrice, uint256 tradePrice, uint256 qty, bool side, uint256 fee, uint256 gasFee, bytes32 futuresContractHash, uint256 availableBalance) view returns (bool)
1019     {
1020         if (side)
1021         {
1022             // long
1023             if (safeAdd(safeMul(safeSub(tradePrice, limitPrice), qty) / limitPrice, 
1024                 safeMul(qty, fee) / (1 ether)) * 1e10 > availableBalance)
1025             {
1026                 return false; 
1027             }
1028         }
1029         else
1030         {
1031             // short
1032             if (safeAdd(safeAdd(safeMul(safeSub(limitPrice, tradePrice), qty)  / limitPrice, 
1033                 safeMul(qty, fee) / (1 ether)), gasFee / 1e10) * 1e10 > availableBalance)
1034             {
1035                 return false;
1036             }
1037 
1038         }
1039 
1040         return true;
1041        
1042     }
1043 
1044     // Executes multiple trades in one transaction, saves gas fees
1045     function batchFuturesTrade(
1046         uint8[2][] v,
1047         bytes32[4][] rs,
1048         uint256[8][] tradeValues,
1049         address[2][] tradeAddresses,
1050         bool[] takerIsBuying,
1051         bytes32[] futuresContractHash
1052     ) onlyAdmin
1053     {
1054         for (uint i = 0; i < tradeAddresses.length; i++) {
1055             futuresTrade(
1056                 v[i],
1057                 rs[i],
1058                 tradeValues[i],
1059                 tradeAddresses[i],
1060                 takerIsBuying[i],
1061                 futuresContractHash[i]
1062             );
1063         }
1064     }
1065 
1066 
1067     // Update user balance
1068     function updateBalances (bytes32 futuresContract, address[2] addressValues, bytes32 positionHash, uint256[8] uintValues, bool[3] boolValues) private
1069     {
1070         /*
1071             addressValues
1072             [0] baseToken
1073             [1] user
1074 
1075             uintValues
1076             [0] qty
1077             [1] price
1078             [2] fee
1079             [3] profit
1080             [4] loss
1081             [5] balance
1082             [6] gasFee
1083             [7] reserve
1084 
1085             boolValues
1086             [0] newPostion
1087             [1] side
1088             [2] increase position
1089 
1090         */
1091 
1092         //                          qty * price * fee
1093         // uint256 pam[0] = safeMul(safeMul(uintValues[0], uintValues[1]), uintValues[2]) / (1 ether);
1094         // uint256 collateral;  
1095 
1096 
1097         // pam = [fee value, collateral]                        
1098         uint256[2] memory pam = [safeMul(uintValues[0], uintValues[2]) / (1 ether), 0];
1099         
1100         // LogUint(100, uintValues[3]);
1101         // LogUint(9, uintValues[2]);
1102         // LogUint(7, safeMul(uintValues[0], uintValues[2])  / (1 ether));
1103         // return;
1104 
1105         
1106 
1107         // Position is new or position is increased
1108         if (boolValues[0] || boolValues[2])  
1109         {
1110 
1111             if (boolValues[1])
1112             {
1113 
1114                 //addReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(safeSub(uintValues[1], futuresContracts[futuresContract].floorPrice), uintValues[0])); // reserve collateral on user
1115                 pam[1] = safeMul(safeSub(uintValues[1], futuresContracts[futuresContract].floorPrice), uintValues[0]) / futuresContracts[futuresContract].floorPrice;
1116             }
1117             else
1118             {
1119                 //addReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(safeSub(futuresContracts[futuresContract].capPrice, uintValues[1]), uintValues[0])); // reserve collateral on user
1120                 pam[1] = safeMul(safeSub(futuresContracts[futuresContract].capPrice, uintValues[1]), uintValues[0]) / futuresContracts[futuresContract].capPrice;
1121             }
1122 
1123             subBalanceAddReserve(addressValues[0], addressValues[1], safeAdd(uintValues[6], pam[0]), safeAdd(pam[1],1));         
1124 
1125             // if (uintValues[6] > 0)
1126             // {   
1127             //     subBalanceAddReserve(addressValues[0], addressValues[1], safeAdd(uintValues[6], pam[0]), pam[1]);                  
1128                               
1129             // }
1130             // else
1131             // {
1132 
1133             //    subBalanceAddReserve(addressValues[0], addressValues[1], safeAdd(uintValues[6], pam[0]), pam[1]);                 
1134             // }
1135 
1136 
1137             //subBalance(addressValues[0], addressValues[1], uintValues[5], feeVal); // deduct user maker/taker fee 
1138 
1139             
1140         // Position exists
1141         } 
1142         else 
1143         {
1144             if (retrievePosition(positionHash)[2] == 0)
1145             {
1146                 // original position was short
1147                 //subReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(uintValues[0], safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]))); // remove freed collateral from reserver
1148                 pam[1] = safeMul(uintValues[0], safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1])) / futuresContracts[futuresContract].capPrice;
1149                 // LogUint(120, uintValues[0]);
1150                 // LogUint(121, futuresContracts[futuresContract].capPrice);
1151                 // LogUint(122, retrievePosition(positionHash)[1]);
1152                 // LogUint(123, uintValues[3]); // profit
1153                 // LogUint(124, uintValues[4]); // loss
1154                 // LogUint(125, safeAdd(uintValues[4], pam[0]));
1155                 // LogUint(12, pam[1] );
1156                 //return;
1157             }
1158             else
1159             {                
1160                 // original position was long
1161                 //subReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(uintValues[0], safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice)));
1162                 pam[1] = safeMul(uintValues[0], safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice)) / futuresContracts[futuresContract].floorPrice;
1163                 
1164             }
1165 
1166             if (uintValues[3] > 0) 
1167             {
1168                 // profi > 0
1169                 //addBalance(addressValues[0], addressValues[1], uintValues[5], safeSub(uintValues[3], pam[0])); // add profit to user balance
1170                 addBalanceSubReserve(addressValues[0], addressValues[1], safeSub(uintValues[3], pam[0]), pam[1]);
1171             } 
1172             else 
1173             {   
1174                 
1175 
1176                 // loss >= 0
1177                 //subBalance(addressValues[0], addressValues[1], uintValues[5], safeAdd(uintValues[4], pam[0])); // deduct loss from user balance 
1178                 subBalanceSubReserve(addressValues[0], addressValues[1], safeAdd(uintValues[4], pam[0]), pam[1]); // deduct loss from user balance
1179            
1180             } 
1181             //}            
1182         }          
1183         
1184         addBalance(addressValues[0], feeAccount, EtherMium(exchangeContract).balanceOf(addressValues[0], feeAccount), pam[0]); // send fee to feeAccount
1185     }
1186 
1187     function recordNewPosition (bytes32 positionHash, uint256 size, uint256 price, uint256 side, uint256 block) private
1188     {
1189         if (!validateUint128(size) || !validateUint64(price)) 
1190         {
1191             throw;
1192         }
1193 
1194         uint256 character = uint128(size);
1195         character |= price<<128;
1196         character |= side<<192;
1197         character |= block<<208;
1198 
1199         positions[positionHash] = character;
1200     }
1201 
1202     function retrievePosition (bytes32 positionHash) public view returns (uint256[4])
1203     {
1204         uint256 character = positions[positionHash];
1205         uint256 size = uint256(uint128(character));
1206         uint256 price = uint256(uint64(character>>128));
1207         uint256 side = uint256(uint16(character>>192));
1208         uint256 entryBlock = uint256(uint48(character>>208));
1209 
1210         return [size, price, side, entryBlock];
1211     }
1212 
1213     function updatePositionSize(bytes32 positionHash, uint256 size, uint256 price) private
1214     {
1215         uint256[4] memory pos = retrievePosition(positionHash);
1216 
1217         if (size > pos[0])
1218         {
1219             // position is increasing in size
1220             recordNewPosition(positionHash, size, safeAdd(safeMul(pos[0], pos[1]), safeMul(price, safeSub(size, pos[0]))) / size, pos[2], pos[3]);
1221         }
1222         else
1223         {
1224             // position is decreasing in size
1225             recordNewPosition(positionHash, size, pos[1], pos[2], pos[3]);
1226         }        
1227     }
1228 
1229     function positionExists (bytes32 positionHash) internal view returns (bool)
1230     {
1231         //LogUint(3,retrievePosition(positionHash)[0]);
1232         if (retrievePosition(positionHash)[0] == 0)
1233         {
1234             return false;
1235         }
1236         else
1237         {
1238             return true;
1239         }
1240     }
1241 
1242     // This function allows the user to manually release collateral in case the oracle service does not provide the price during the inactivityReleasePeriod
1243     function forceReleaseReserve (bytes32 futuresContract, bool side) public
1244     {   
1245 
1246         if (futuresContracts[futuresContract].expirationBlock == 0) throw;       
1247         if (futuresContracts[futuresContract].expirationBlock > block.number) throw;
1248         if (safeAdd(futuresContracts[futuresContract].expirationBlock, EtherMium(exchangeContract).getInactivityReleasePeriod()) > block.number) throw;  
1249 
1250         bytes32 positionHash = keccak256(this, msg.sender, futuresContract, side);
1251         if (retrievePosition(positionHash)[1] == 0) throw;      
1252 
1253         futuresContracts[futuresContract].broken = true;
1254 
1255         address baseToken = futuresAssets[futuresContracts[futuresContract].asset].baseToken;
1256 
1257         if (side)
1258         {
1259             subReserve(baseToken, msg.sender, EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].floorPrice); 
1260         }
1261         else
1262         {            
1263             subReserve(baseToken, msg.sender, EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].capPrice); 
1264         }
1265 
1266         updatePositionSize(positionHash, 0, 0);
1267 
1268         //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), );
1269         //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], positions[msg.sender][positionHash].collateral);
1270 
1271         emit FuturesForcedRelease(futuresContract, side, msg.sender);
1272 
1273     }
1274 
1275     function addBalance(address token, address user, uint256 balance, uint256 amount) private
1276     {
1277         EtherMium(exchangeContract).setBalance(token, user, safeAdd(balance, amount));
1278     }
1279 
1280     function subBalance(address token, address user, uint256 balance, uint256 amount) private
1281     {
1282         EtherMium(exchangeContract).setBalance(token, user, safeSub(balance, amount));
1283     }
1284 
1285     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) private
1286     {
1287         EtherMium(exchangeContract).subBalanceAddReserve(token, user, subBalance * 1e10, addReserve * 1e10);
1288     }
1289 
1290     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) private
1291     {
1292 
1293         EtherMium(exchangeContract).addBalanceSubReserve(token, user, addBalance * 1e10, subReserve * 1e10);
1294     }
1295 
1296     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) private
1297     {
1298         // LogUint(31, subBalance);
1299         // LogUint(32, subReserve);
1300         // return;
1301 
1302         EtherMium(exchangeContract).subBalanceSubReserve(token, user, subBalance * 1e10, subReserve * 1e10);
1303     }
1304 
1305     function addReserve(address token, address user, uint256 reserve, uint256 amount) private
1306     {
1307         //reserve[token][user] = safeAdd(reserve[token][user], amount);
1308         EtherMium(exchangeContract).setReserve(token, user, safeAdd(reserve, amount * 1e10));
1309     }
1310 
1311     function subReserve(address token, address user, uint256 reserve, uint256 amount) private 
1312     {
1313         //reserve[token][user] = safeSub(reserve[token][user], amount);
1314         EtherMium(exchangeContract).setReserve(token, user, safeSub(reserve, amount * 1e10));
1315     }
1316 
1317 
1318     function getMakerTakerBalances(address maker, address taker, address token) public view returns (uint256[4])
1319     {
1320         return [
1321             EtherMium(exchangeContract).balanceOf(token, maker),
1322             EtherMium(exchangeContract).getReserve(token, maker),
1323             EtherMium(exchangeContract).balanceOf(token, taker),
1324             EtherMium(exchangeContract).getReserve(token, taker)
1325         ];
1326     }
1327 
1328     function getMakerTakerPositions(bytes32 makerPositionHash, bytes32 makerInversePositionHash, bytes32 takerPosition, bytes32 takerInversePosition) public view returns (uint256[4][4])
1329     {
1330         return [
1331             retrievePosition(makerPositionHash),
1332             retrievePosition(makerInversePositionHash),
1333             retrievePosition(takerPosition),
1334             retrievePosition(takerInversePosition)
1335         ];
1336     }
1337 
1338 
1339     struct FuturesClosePositionValues {
1340         uint256 reserve;                // amount to be trade
1341         uint256 balance;        // holds maker profit value
1342         uint256 floorPrice;          // holds maker loss value
1343         uint256 capPrice;        // holds taker profit value
1344         uint256 closingPrice;          // holds taker loss value
1345     }
1346 
1347 
1348     function closeFuturesPosition (bytes32 futuresContract, bool side)
1349     {
1350         bytes32 positionHash = keccak256(this, msg.sender, futuresContract, side);
1351 
1352         if (futuresContracts[futuresContract].closed == false && futuresContracts[futuresContract].expirationBlock != 0) throw; // contract not yet settled
1353         if (retrievePosition(positionHash)[1] == 0) throw; // position not found
1354         if (retrievePosition(positionHash)[0] == 0) throw; // position already closed
1355 
1356         uint256 profit;
1357         uint256 loss;
1358 
1359         FuturesClosePositionValues memory v = FuturesClosePositionValues({
1360             reserve         : EtherMium(exchangeContract).getReserve(baseToken, msg.sender),
1361             balance         : EtherMium(exchangeContract).balanceOf(baseToken, msg.sender),
1362             floorPrice      : futuresContracts[futuresContract].floorPrice,
1363             capPrice        : futuresContracts[futuresContract].capPrice,
1364             closingPrice    : futuresContracts[futuresContract].closingPrice
1365         });
1366 
1367         // uint256 reserve = EtherMium(exchangeContract).getReserve(baseToken, msg.sender);
1368         // uint256 balance = EtherMium(exchangeContract).balanceOf(baseToken, msg.sender);
1369         // uint256 floorPrice = futuresContracts[futuresContract].floorPrice;
1370         // uint256 capPrice = futuresContracts[futuresContract].capPrice;
1371         // uint256 closingPrice =  futuresContracts[futuresContract].closingPrice;
1372 
1373 
1374         address baseToken = futuresAssets[futuresContracts[futuresContract].asset].baseToken;
1375         uint256 fee = safeMul(safeMul(retrievePosition(positionHash)[0], v.closingPrice), takerFee) / (1 ether);
1376 
1377 
1378 
1379         // close long position
1380         if (side == true)
1381         {            
1382 
1383             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1384             // LogUint(12, safeMul(safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].floorPrice);
1385             // return;
1386             // reserve = reserve - (entryPrice - floorPrice) * size;
1387             //subReserve(baseToken, msg.sender, EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[positionHash].size));
1388             subReserve(baseToken, msg.sender, v.reserve, safeMul(safeSub(retrievePosition(positionHash)[1], v.floorPrice), retrievePosition(positionHash)[0]) / v.floorPrice);
1389             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1390             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1391             
1392 
1393 
1394             if (v.closingPrice > retrievePosition(positionHash)[1])
1395             {
1396                 // user made a profit
1397                 //profit = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1398                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);
1399                 
1400 
1401 
1402                 // LogUint(15, profit);
1403                 // LogUint(16, fee);
1404                 // LogUint(17, safeSub(profit * 1e10, fee));
1405                 // return;
1406 
1407                 addBalance(baseToken, msg.sender, v.balance, safeSub(profit * 1e10, fee));
1408                 //EtherMium(exchangeContract).updateBalance(baseToken, msg.sender, safeAdd(EtherMium(exchangeContract).balanceOf(baseToken, msg.sender), profit);
1409                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1410             }
1411             else
1412             {
1413                 // user made a loss
1414                 //loss = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1415                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);  
1416 
1417 
1418                 subBalance(baseToken, msg.sender, v.balance, safeAdd(loss * 1e10, fee));
1419                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1420             }
1421         }   
1422         // close short position 
1423         else
1424         {
1425             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1426             // LogUint(12, safeMul(safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].capPrice);
1427             // return;
1428 
1429             // reserve = reserve - (capPrice - entryPrice) * size;
1430             subReserve(baseToken, msg.sender,  v.reserve, safeMul(safeSub(v.capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.capPrice);
1431             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1432             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1433             
1434             
1435 
1436             if (v.closingPrice < retrievePosition(positionHash)[1])
1437             {
1438                 // user made a profit
1439                 // profit = (entryPrice - closingPrice) * size
1440                 // profit = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1441                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);
1442 
1443                 addBalance(baseToken, msg.sender, v.balance, safeSub(profit * 1e10, fee));
1444 
1445                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1446             }
1447             else
1448             {
1449                 // user made a loss
1450                 // profit = (closingPrice - entryPrice) * size
1451                 //loss = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1452                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);  
1453 
1454                 subBalance(baseToken, msg.sender, v.balance, safeAdd(loss * 1e10, fee));
1455 
1456                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1457             }
1458         }  
1459 
1460         addBalance(baseToken, feeAccount, EtherMium(exchangeContract).balanceOf(baseToken, feeAccount), fee); // send fee to feeAccount
1461         updatePositionSize(positionHash, 0, 0);
1462     }
1463 
1464     /*
1465         string priceUrl;                // the url where the price of the asset will be taken for settlement
1466         string pricePath;               // price path in the returned JSON from the priceUrl (ex. path "last" will return tha value last from the json: {"high": "156.49", "last": "154.31", "timestamp": "1556522201", "bid": "154.22", "vwap": "154.65", "volume": "25578.79138868", "low": "152.33", "ask": "154.26", "open": "152.99"})
1467         bool multiplied;                // if true, the price from the priceUrl will be multiplied by the multiplierPriceUrl
1468         string multiplierPriceUrl;      // needed only if multiplied=true
1469         string multiplierPricePath;     // same as pricePath 
1470         bool inverseMultiplier; 
1471     */
1472 
1473 
1474     function closeFuturesContract (bytes32 futuresContract, uint256 price, uint256 multipliterPrice) onlyAdmin
1475     {
1476         uint256 closingPrice = price;
1477 
1478         if (futuresContracts[futuresContract].expirationBlock == 0) throw; // contract not found
1479         if (futuresContracts[futuresContract].closed == true) throw; // contract already closed
1480         if (futuresContracts[futuresContract].expirationBlock > block.number 
1481             && closingPrice > futuresContracts[futuresContract].floorPrice
1482             && closingPrice < futuresContracts[futuresContract].capPrice) throw; // contract not yet expired
1483         futuresContracts[futuresContract].closingPrice = closingPrice;
1484         futuresContracts[futuresContract].closed = true;
1485 
1486         emit FuturesContractClosed(futuresContract, closingPrice);
1487     }
1488 
1489     
1490 
1491     // Returns the smaller of two values
1492     function min(uint a, uint b) private pure returns (uint) {
1493         return a < b ? a : b;
1494     }
1495 }