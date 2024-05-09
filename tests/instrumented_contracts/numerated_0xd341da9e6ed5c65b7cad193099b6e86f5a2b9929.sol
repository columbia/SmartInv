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
101     mapping (address => uint256) public lastActiveTransaction;  // mapping of user addresses to last transaction block
102     mapping (bytes32 => uint256) public orderFills;             // mapping of orders to filled qunatity
103     
104     address public feeAccount;          // the account that receives the trading fees
105     address public exchangeContract;    // the address of the main EtherMium contract
106     address public DmexOracleContract;    // the address of the DMEX math contract used for some calculations
107 
108     uint256 public makerFee;            // maker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
109     uint256 public takerFee;            // taker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
110     
111     struct FuturesAsset {
112         string name;                    // the name of the traded asset (ex. ETHUSD)
113         address baseToken;              // the token for collateral
114         string priceUrl;                // the url where the price of the asset will be taken for settlement
115         string pricePath;               // price path in the returned JSON from the priceUrl (ex. path "last" will return tha value last from the json: {"high": "156.49", "last": "154.31", "timestamp": "1556522201", "bid": "154.22", "vwap": "154.65", "volume": "25578.79138868", "low": "152.33", "ask": "154.26", "open": "152.99"})
116         bool inversed;                  // if true, the price from the priceUrl will be inversed (i.e price = 1/priceUrl)
117         bool disabled;                  // if true, the asset cannot be used in contract creation (when price url no longer valid)
118     }
119 
120     function createFuturesAsset(string name, address baseToken, string priceUrl, string pricePath, bool inversed) onlyAdmin returns (bytes32)
121     {    
122         bytes32 futuresAsset = keccak256(this, name, baseToken, priceUrl, pricePath, inversed);
123         if (futuresAssets[futuresAsset].disabled) throw; // asset already exists and is disabled
124 
125         futuresAssets[futuresAsset] = FuturesAsset({
126             name                : name,
127             baseToken           : baseToken,
128             priceUrl            : priceUrl,
129             pricePath           : pricePath,
130             inversed            : inversed,
131             disabled            : false
132         });
133 
134         emit FuturesAssetCreated(futuresAsset, name, baseToken, priceUrl, pricePath, inversed);
135         return futuresAsset;
136     }
137     
138     struct FuturesContract {
139         bytes32 asset;                  // the hash of the underlying asset object
140         uint256 expirationBlock;        // futures contract expiration block
141         uint256 closingPrice;           // the closing price for the futures contract
142         bool closed;                    // is the futures contract closed (0 - false, 1 - true)
143         bool broken;                    // if someone has forced release of funds the contract is marked as broken and can no longer close positions (0-false, 1-true)
144         uint256 floorPrice;             // the minimum price that can be traded on the contract, once price is reached the contract expires and enters settlement state 
145         uint256 capPrice;               // the maximum price that can be traded on the contract, once price is reached the contract expires and enters settlement state
146         uint256 multiplier;             // the multiplier price, used when teh trading pair doesn't have the base token in it (eg. BTCUSD with ETH as base token, multiplier will be the ETHBTC price)
147     }
148 
149     function createFuturesContract(bytes32 asset, uint256 expirationBlock, uint256 floorPrice, uint256 capPrice, uint256 multiplier) onlyAdmin returns (bytes32)
150     {    
151         bytes32 futuresContract = keccak256(this, asset, expirationBlock, floorPrice, capPrice, multiplier);
152         if (futuresContracts[futuresContract].expirationBlock > 0) return futuresContract; // contract already exists
153 
154         futuresContracts[futuresContract] = FuturesContract({
155             asset           : asset,
156             expirationBlock : expirationBlock,
157             closingPrice    : 0,
158             closed          : false,
159             broken          : false,
160             floorPrice      : floorPrice,
161             capPrice        : capPrice,
162             multiplier      : multiplier
163         });
164 
165         emit FuturesContractCreated(futuresContract, asset, expirationBlock, floorPrice, capPrice, multiplier);
166 
167         return futuresContract;
168     }
169 
170     function getContractExpiration (bytes32 futuresContractHash) view returns (uint256)
171     {
172         return futuresContracts[futuresContractHash].expirationBlock;
173     }
174 
175     function getContractClosed (bytes32 futuresContractHash) returns (bool)
176     {
177         return futuresContracts[futuresContractHash].closed;
178     }
179 
180     function getContractPriceUrl (bytes32 futuresContractHash) returns (string)
181     {
182         return futuresAssets[futuresContracts[futuresContractHash].asset].priceUrl;
183     }
184 
185     function getContractPricePath (bytes32 futuresContractHash) returns (string)
186     {
187         return futuresAssets[futuresContracts[futuresContractHash].asset].pricePath;
188     }
189 
190     mapping (bytes32 => FuturesAsset)       public futuresAssets;      // mapping of futuresAsset hash to FuturesAsset structs
191     mapping (bytes32 => FuturesContract)    public futuresContracts;   // mapping of futuresContract hash to FuturesContract structs
192     mapping (bytes32 => uint256)            public positions;          // mapping of user addresses to position hashes to position
193 
194 
195     enum Errors {
196         INVALID_PRICE,                  // Order prices don't match
197         INVALID_SIGNATURE,              // Signature is invalid
198         ORDER_ALREADY_FILLED,           // Order was already filled
199         GAS_TOO_HIGH,                   // Too high gas fee
200         OUT_OF_BALANCE,                 // User doesn't have enough balance for the operation
201         FUTURES_CONTRACT_EXPIRED,       // Futures contract already expired
202         FLOOR_OR_CAP_PRICE_REACHED,     // The floor price or the cap price for the futures contract was reached
203         POSITION_ALREADY_EXISTS,        // User has an open position already 
204         UINT48_VALIDATION,              // Size or price bigger than an Uint48
205         FAILED_ASSERTION                // Assertion failed
206     }
207 
208     event FuturesTrade(bool side, uint256 size, uint256 price, bytes32 indexed futuresContract, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
209     event FuturesPositionClosed(bytes32 positionHash);
210     event FuturesContractClosed(bytes32 indexed futuresContract, uint256 closingPrice);
211     event FuturesForcedRelease(bytes32 indexed futuresContract, bool side, address user);
212     event FuturesAssetCreated(bytes32 indexed futuresAsset, string name, address baseToken, string priceUrl, string pricePath, bool inversed);
213     event FuturesContractCreated(bytes32 indexed futuresContract, bytes32 asset, uint256 expirationBlock, uint256 floorPrice, uint256 capPrice, uint256 multiplier);
214  
215     // Fee change event
216     event FeeChange(uint256 indexed makerFee, uint256 indexed takerFee);
217 
218     // Log event, logs errors in contract execution (for internal use)
219     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
220     event LogErrorLight(uint8 indexed errorId);
221     event LogUint(uint8 id, uint256 value);
222     event LogBool(uint8 id, bool value);
223     event LogAddress(uint8 id, address value);
224 
225 
226     // Constructor function, initializes the contract and sets the core variables
227     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, address exchangeContract_, address DmexOracleContract_) {
228         owner               = msg.sender;
229         feeAccount          = feeAccount_;
230         makerFee            = makerFee_;
231         takerFee            = takerFee_;
232 
233         exchangeContract    = exchangeContract_;
234         DmexOracleContract    = DmexOracleContract_;
235     }
236 
237     // Changes the fees
238     function setFees(uint256 makerFee_, uint256 takerFee_) onlyOwner {
239         require(makerFee_       < 10 finney && takerFee_ < 10 finney); // The fees cannot be set higher then 1%
240         makerFee                = makerFee_;
241         takerFee                = takerFee_;
242 
243         emit FeeChange(makerFee, takerFee);
244     }
245 
246     // Adds or disables an admin account
247     function setAdmin(address admin, bool isAdmin) onlyOwner {
248         admins[admin] = isAdmin;
249     }
250 
251     // Allows for admins only to call the function
252     modifier onlyAdmin {
253         if (msg.sender != owner && !admins[msg.sender]) throw;
254         _;
255     }
256 
257     function() external {
258         throw;
259     }   
260 
261 
262     function validateUint48(uint256 val) returns (bool)
263     {
264         if (val != uint48(val)) return false;
265         return true;
266     }
267 
268     function validateUint64(uint256 val) returns (bool)
269     {
270         if (val != uint64(val)) return false;
271         return true;
272     }
273 
274     function validateUint128(uint256 val) returns (bool)
275     {
276         if (val != uint128(val)) return false;
277         return true;
278     }
279 
280 
281     // Structure that holds order values, used inside the trade() function
282     struct FuturesOrderPair {
283         uint256 makerNonce;                 // maker order nonce, makes the order unique
284         uint256 takerNonce;                 // taker order nonce
285         uint256 takerGasFee;                // taker gas fee, taker pays the gas
286         uint256 takerIsBuying;              // true/false taker is the buyer
287 
288         address maker;                      // address of the maker
289         address taker;                      // address of the taker
290 
291         bytes32 makerOrderHash;             // hash of the maker order
292         bytes32 takerOrderHash;             // has of the taker order
293 
294         uint256 makerAmount;                // trade amount for maker
295         uint256 takerAmount;                // trade amount for taker
296 
297         uint256 makerPrice;                 // maker order price in wei (18 decimal precision)
298         uint256 takerPrice;                 // taker order price in wei (18 decimal precision)
299 
300         bytes32 futuresContract;            // the futures contract being traded
301 
302         address baseToken;                  // the address of the base token for futures contract
303         uint256 floorPrice;                 // floor price of futures contract
304         uint256 capPrice;                   // cap price of futures contract
305 
306         bytes32 makerPositionHash;          // hash for maker position
307         bytes32 makerInversePositionHash;   // hash for inverse maker position 
308 
309         bytes32 takerPositionHash;          // hash for taker position
310         bytes32 takerInversePositionHash;   // hash for inverse taker position
311     }
312 
313     // Structure that holds trade values, used inside the trade() function
314     struct FuturesTradeValues {
315         uint256 qty;                // amount to be trade
316         uint256 makerProfit;        // holds maker profit value
317         uint256 makerLoss;          // holds maker loss value
318         uint256 takerProfit;        // holds taker profit value
319         uint256 takerLoss;          // holds taker loss value
320         uint256 makerBalance;       // holds maker balance value
321         uint256 takerBalance;       // holds taker balance value
322         uint256 makerReserve;       // holds taker reserved value
323         uint256 takerReserve;       // holds taker reserved value
324     }
325 
326     // Opens/closes futures positions
327     function futuresTrade(
328         uint8[2] v,
329         bytes32[4] rs,
330         uint256[8] tradeValues,
331         address[2] tradeAddresses,
332         bool takerIsBuying,
333         bytes32 futuresContractHash
334     ) onlyAdmin returns (uint filledTakerTokenAmount)
335     {
336         /* tradeValues
337           [0] makerNonce
338           [1] takerNonce
339           [2] takerGasFee
340           [3] takerIsBuying
341           [4] makerAmount
342           [5] takerAmount
343           [6] makerPrice
344           [7] takerPrice
345 
346           tradeAddresses
347           [0] maker
348           [1] taker
349         */
350 
351         FuturesOrderPair memory t  = FuturesOrderPair({
352             makerNonce      : tradeValues[0],
353             takerNonce      : tradeValues[1],
354             takerGasFee     : tradeValues[2],
355             takerIsBuying   : tradeValues[3],
356             makerAmount     : tradeValues[4],      
357             takerAmount     : tradeValues[5],   
358             makerPrice      : tradeValues[6],         
359             takerPrice      : tradeValues[7],
360 
361             maker           : tradeAddresses[0],
362             taker           : tradeAddresses[1],
363 
364             //                                futuresContract      user               amount          price           side             nonce
365             makerOrderHash  : keccak256(this, futuresContractHash, tradeAddresses[0], tradeValues[4], tradeValues[6], !takerIsBuying, tradeValues[0]),
366             takerOrderHash  : keccak256(this, futuresContractHash, tradeAddresses[1], tradeValues[5], tradeValues[7],  takerIsBuying, tradeValues[1]),            
367 
368             futuresContract : futuresContractHash,
369 
370             baseToken       : futuresAssets[futuresContracts[futuresContractHash].asset].baseToken,
371             floorPrice      : futuresContracts[futuresContractHash].floorPrice,
372             capPrice        : futuresContracts[futuresContractHash].capPrice,
373 
374             //                                            user               futuresContractHash   side
375             makerPositionHash           : keccak256(this, tradeAddresses[0], futuresContractHash, !takerIsBuying),
376             makerInversePositionHash    : keccak256(this, tradeAddresses[0], futuresContractHash, takerIsBuying),
377 
378             takerPositionHash           : keccak256(this, tradeAddresses[1], futuresContractHash, takerIsBuying),
379             takerInversePositionHash    : keccak256(this, tradeAddresses[1], futuresContractHash, !takerIsBuying)
380 
381         });
382 
383 //--> 44 000
384     
385         // Valifate size and price values
386         if (!validateUint128(t.makerAmount) || !validateUint128(t.takerAmount) || !validateUint64(t.makerPrice) || !validateUint64(t.takerPrice))
387         {            
388             emit LogError(uint8(Errors.UINT48_VALIDATION), t.makerOrderHash, t.takerOrderHash);
389             return 0; 
390         }
391 
392 
393         // Check if futures contract has expired already
394         if (block.number > futuresContracts[t.futuresContract].expirationBlock || futuresContracts[t.futuresContract].closed == true || futuresContracts[t.futuresContract].broken == true)
395         {
396             emit LogError(uint8(Errors.FUTURES_CONTRACT_EXPIRED), t.makerOrderHash, t.takerOrderHash);
397             return 0; // futures contract is expired
398         }
399 
400         // Checks the signature for the maker order
401         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
402         {
403             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
404             return 0;
405         }
406        
407         // Checks the signature for the taker order
408         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
409         {
410             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
411             return 0;
412         }
413 
414 
415 
416         // check prices
417         if ((!takerIsBuying && t.makerPrice < t.takerPrice) || (takerIsBuying && t.takerPrice < t.makerPrice))
418         {
419             emit LogError(uint8(Errors.INVALID_PRICE), t.makerOrderHash, t.takerOrderHash);
420             return 0; // prices don't match
421         }      
422 
423 //--> 54 000
424 
425          
426         
427 
428         uint256[4] memory balances = EtherMium(exchangeContract).getMakerTakerBalances(t.baseToken, t.maker, t.taker);
429 
430         // Initializing trade values structure 
431         FuturesTradeValues memory tv = FuturesTradeValues({
432             qty                 : 0,
433             makerProfit         : 0,
434             makerLoss           : 0,
435             takerProfit         : 0,
436             takerLoss           : 0,
437             makerBalance        : balances[0], //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
438             takerBalance        : balances[1],  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
439             makerReserve        : balances[2],  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
440             takerReserve        : balances[3]  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
441         });
442 
443 //--> 60 000
444 
445 
446          
447 
448         // check if floor price or cap price was reached
449         if (futuresContracts[t.futuresContract].floorPrice >= t.makerPrice || futuresContracts[t.futuresContract].capPrice <= t.makerPrice)
450         {
451             // attepting price outside range
452             emit LogError(uint8(Errors.FLOOR_OR_CAP_PRICE_REACHED), t.makerOrderHash, t.takerOrderHash);
453             return 0;
454         }
455 
456         // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
457         // and open inverse positions
458         tv.qty = min(safeSub(t.makerAmount, orderFills[t.makerOrderHash]), safeSub(t.takerAmount, orderFills[t.takerOrderHash]));
459         
460         if (positionExists(t.makerInversePositionHash) && positionExists(t.takerInversePositionHash))
461         {
462             tv.qty = min(tv.qty, min(retrievePosition(t.makerInversePositionHash)[0], retrievePosition(t.takerInversePositionHash)[0]));
463         }
464         else if (positionExists(t.makerInversePositionHash))
465         {
466             tv.qty = min(tv.qty, retrievePosition(t.makerInversePositionHash)[0]);
467         }
468         else if (positionExists(t.takerInversePositionHash))
469         {
470             tv.qty = min(tv.qty, retrievePosition(t.takerInversePositionHash)[0]);
471         }
472 
473        
474 
475 
476 
477 //--> 64 000       
478         
479         if (tv.qty == 0)
480         {
481             // no qty left on orders
482             emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
483             return 0;
484         }
485 
486         // Cheks that gas fee is not higher than 10%
487         if (safeMul(t.takerGasFee, 20) > calculateTradeValue(tv.qty, t.makerPrice, t.futuresContract))
488         {
489             emit LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
490             return 0;
491         } // takerGasFee too high
492 
493 
494         // check if users have open positions already
495         // if (positionExists(t.makerPositionHash) || positionExists(t.takerPositionHash))
496         // {
497         //     // maker already has the position open, first must close existing position before opening a new one
498         //     emit LogError(uint8(Errors.POSITION_ALREADY_EXISTS), t.makerOrderHash, t.takerOrderHash);
499         //     return 0; 
500         // }
501 
502 //--> 66 000
503         
504 
505        
506 
507         /*------------- Maker long, Taker short -------------*/
508         if (!takerIsBuying)
509         {     
510             
511       
512             // position actions for maker
513             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
514             {
515 
516 
517                 // check if maker has enough balance   
518                 
519                 if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
520                 {
521                     // maker out of balance
522                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
523                     return 0; 
524                 }
525 
526                 
527                 
528                 // create new position
529                 recordNewPosition(t.makerPositionHash, tv.qty, t.makerPrice, 1, block.number);
530 
531 
532 
533                 updateBalances(
534                     t.futuresContract, 
535                     [
536                         t.baseToken, // base token
537                         t.maker // make address
538                     ], 
539                     t.makerPositionHash,  // position hash
540                     [
541                         tv.qty, // qty
542                         t.makerPrice,  // price
543                         makerFee, // fee
544                         0, // profit
545                         0, // loss
546                         tv.makerBalance, // balance
547                         0, // gasFee
548                         tv.makerReserve // reserve
549                     ], 
550                     [
551                         true, // newPostion (if true position is new)
552                         true, // side (if true - long)
553                         false // increase position (if true)
554                     ]
555                 );
556 
557             } else {               
558                 
559                 if (positionExists(t.makerPositionHash))
560                 {
561                     // check if maker has enough balance            
562                     // if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, 
563                     //     safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
564                     if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
565                     {
566                         // maker out of balance
567                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
568                         return 0; 
569                     }
570 
571                     // increase position size
572                     updatePositionSize(t.makerPositionHash, safeAdd(retrievePosition(t.makerPositionHash)[0], tv.qty), t.makerPrice);
573                 
574                     updateBalances(
575                         t.futuresContract, 
576                         [
577                             t.baseToken,  // base token
578                             t.maker // make address
579                         ], 
580                         t.makerPositionHash, // position hash
581                         [
582                             tv.qty, // qty
583                             t.makerPrice, // price
584                             makerFee, // fee
585                             0, // profit
586                             0, // loss
587                             tv.makerBalance, // balance
588                             0, // gasFee
589                             tv.makerReserve // reserve
590                         ], 
591                         [
592                             false, // newPostion (if true position is new)
593                             true, // side (if true - long)
594                             true // increase position (if true)
595                         ]
596                     );
597                 }
598                 else
599                 {
600 
601                     // close/partially close existing position
602                     updatePositionSize(t.makerInversePositionHash, safeSub(retrievePosition(t.makerInversePositionHash)[0], tv.qty), 0);
603                     
604                     
605 
606                     if (t.makerPrice < retrievePosition(t.makerInversePositionHash)[1])
607                     {
608                         // user has made a profit
609                         //tv.makerProfit                    = safeMul(safeSub(retrievePosition(t.makerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;
610                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);
611                     }
612                     else
613                     {
614                         // user has made a loss
615                         //tv.makerLoss                      = safeMul(safeSub(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1]), tv.qty) / t.makerPrice;    
616                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                        
617                     }
618 
619 
620 
621 
622                     updateBalances(
623                         t.futuresContract, 
624                         [
625                             t.baseToken, // base token
626                             t.maker // make address
627                         ], 
628                         t.makerInversePositionHash, // position hash
629                         [
630                             tv.qty, // qty
631                             t.makerPrice, // price
632                             makerFee, // fee
633                             tv.makerProfit,  // profit
634                             tv.makerLoss,  // loss
635                             tv.makerBalance, // balance
636                             0, // gasFee
637                             tv.makerReserve // reserve
638                         ], 
639                         [
640                             false, // newPostion (if true position is new)
641                             true, // side (if true - long)
642                             false // increase position (if true)
643                         ]
644                     );
645                 }                
646             }
647 
648            
649 
650 
651             // position actions for taker
652             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
653             {
654                 
655                 // check if taker has enough balance
656                 // if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether))  * 1e10, t.takerGasFee) > safeSub(balances[1],tv.takerReserve))
657                 if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
658                 {
659                     // maker out of balance
660                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
661                     return 0; 
662                 }
663                 
664                 // create new position
665                 recordNewPosition(t.takerPositionHash, tv.qty, t.makerPrice, 0, block.number);
666                 
667                 updateBalances(
668                     t.futuresContract, 
669                     [
670                         t.baseToken, // base token
671                         t.taker // make address
672                     ], 
673                     t.takerPositionHash, // position hash
674                     [
675                         tv.qty, // qty
676                         t.makerPrice,  // price
677                         takerFee, // fee
678                         0, // profit
679                         0,  // loss
680                         tv.takerBalance,  // balance
681                         t.takerGasFee, // gasFee
682                         tv.takerReserve // reserve
683                     ], 
684                     [
685                         true, // newPostion (if true position is new)
686                         false, // side (if true - long)
687                         false // increase position (if true)
688                     ]
689                 );
690 
691             } else {
692                 if (positionExists(t.takerPositionHash))
693                 {
694                     // check if taker has enough balance
695                     //if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether))  * 1e10, t.takerGasFee) > safeSub(balances[1],tv.takerReserve))
696                     if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
697                     {
698                         // maker out of balance
699                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
700                         return 0; 
701                     }
702 
703                     // increase position size
704                     updatePositionSize(t.takerPositionHash, safeAdd(retrievePosition(t.takerPositionHash)[0], tv.qty), t.makerPrice);
705                 
706                     updateBalances(
707                         t.futuresContract, 
708                         [
709                             t.baseToken,  // base token
710                             t.taker // make address
711                         ], 
712                         t.takerPositionHash, // position hash
713                         [
714                             tv.qty, // qty
715                             t.makerPrice, // price
716                             takerFee, // fee
717                             0, // profit
718                             0, // loss
719                             tv.takerBalance, // balance
720                             t.takerGasFee, // gasFee
721                             tv.takerReserve // reserve
722                         ], 
723                         [
724                             false, // newPostion (if true position is new)
725                             false, // side (if true - long)
726                             true // increase position (if true)
727                         ]
728                     );
729                 }
730                 else
731                 {   
732 
733 
734                      
735                    
736 
737                     // close/partially close existing position
738                     updatePositionSize(t.takerInversePositionHash, safeSub(retrievePosition(t.takerInversePositionHash)[0], tv.qty), 0);
739                     
740 
741 
742                     if (t.makerPrice > retrievePosition(t.takerInversePositionHash)[1])
743                     {
744                         // user has made a profit
745                         //tv.takerProfit                    = safeMul(safeSub(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1]), tv.qty) / t.makerPrice;
746                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false);
747                     }
748                     else
749                     {
750                         // user has made a loss
751                         //tv.takerLoss                      = safeMul(safeSub(retrievePosition(t.takerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;                                  
752                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false); 
753                     }
754 
755                   
756 
757                     updateBalances(
758                         t.futuresContract, 
759                         [
760                             t.baseToken, // base token
761                             t.taker // make address
762                         ], 
763                         t.takerInversePositionHash, // position hash
764                         [
765                             tv.qty, // qty
766                             t.makerPrice, // price
767                             takerFee, // fee
768                             tv.takerProfit, // profit
769                             tv.takerLoss, // loss
770                             tv.takerBalance,  // balance
771                             t.takerGasFee,  // gasFee
772                             tv.takerReserve // reserve
773                         ], 
774                         [
775                             false, // newPostion (if true position is new)
776                             false, // side (if true - long)
777                             false // increase position (if true)
778                         ]
779                     );
780                 }
781             }
782         }
783 
784 
785         /*------------- Maker short, Taker long -------------*/
786 
787         else
788         {      
789             //LogUint(1, safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty)); return;
790 
791             // position actions for maker
792             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
793             {
794                 // check if maker has enough balance
795                 //if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
796                 if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
797                 {
798                     // maker out of balance
799                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
800                     return 0; 
801                 }
802 
803                 // create new position
804                 recordNewPosition(t.makerPositionHash, tv.qty, t.makerPrice, 0, block.number);
805                 updateBalances(
806                     t.futuresContract, 
807                     [
808                         t.baseToken,   // base token
809                         t.maker // make address
810                     ], 
811                     t.makerPositionHash, // position hash
812                     [
813                         tv.qty, // qty
814                         t.makerPrice, // price
815                         makerFee, // fee
816                         0, // profit
817                         0, // loss
818                         tv.makerBalance, // balance
819                         0, // gasFee
820                         tv.makerReserve // reserve
821                     ], 
822                     [
823                         true, // newPostion (if true position is new)
824                         false, // side (if true - long)
825                         false // increase position (if true)
826                     ]
827                 );
828 
829             } else {
830                 if (positionExists(t.makerPositionHash))
831                 {
832                     // check if maker has enough balance
833                     //if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
834                     if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
835                     {
836                         // maker out of balance
837                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
838                         return 0; 
839                     }
840 
841                     // increase position size
842                     updatePositionSize(t.makerPositionHash, safeAdd(retrievePosition(t.makerPositionHash)[0], tv.qty), t.makerPrice);
843                 
844                     updateBalances(
845                         t.futuresContract, 
846                         [
847                             t.baseToken,  // base token
848                             t.maker // make address
849                         ], 
850                         t.makerPositionHash, // position hash
851                         [
852                             tv.qty, // qty
853                             t.makerPrice, // price
854                             makerFee, // fee
855                             0, // profit
856                             0, // loss
857                             tv.makerBalance, // balance
858                             0, // gasFee
859                             tv.makerReserve // reserve
860                         ], 
861                         [
862                             false, // newPostion (if true position is new)
863                             false, // side (if true - long)
864                             true // increase position (if true)
865                         ]
866                     );
867                 }
868                 else
869                 {
870 
871                     // close/partially close existing position
872                     updatePositionSize(t.makerInversePositionHash, safeSub(retrievePosition(t.makerInversePositionHash)[0], tv.qty), 0);       
873                     
874 
875 
876                     if (t.makerPrice > retrievePosition(t.makerInversePositionHash)[1])
877                     {
878                         // user has made a profit
879                         //tv.makerProfit                    = safeMul(safeSub(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1]), tv.qty) / t.makerPrice;
880                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);
881                     }
882                     else
883                     {
884                         // user has made a loss
885                         //tv.makerLoss                      = safeMul(safeSub(retrievePosition(t.makerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice; 
886                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);                               
887                     }
888 
889                    
890 
891                     updateBalances(
892                         t.futuresContract, 
893                         [
894                             t.baseToken, // base token
895                             t.maker // user address
896                         ], 
897                         t.makerInversePositionHash, // position hash
898                         [
899                             tv.qty, // qty
900                             t.makerPrice, // price
901                             makerFee, // fee
902                             tv.makerProfit,  // profit
903                             tv.makerLoss, // loss
904                             tv.makerBalance, // balance
905                             0, // gasFee
906                             tv.makerReserve // reserve
907                         ], 
908                         [
909                             false, // newPostion (if true position is new)
910                             false, // side (if true - long)
911                             false // increase position (if true)
912                         ]
913                     );
914                 }
915             }
916 
917             // position actions for taker
918             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
919             {
920                 // check if taker has enough balance
921                 // if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether)), t.takerGasFee / 1e10) * 1e10 > safeSub(balances[1],tv.takerReserve))
922                 if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
923                 {
924                     // maker out of balance
925                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
926                     return 0; 
927                 }
928 
929                 // create new position
930                 recordNewPosition(t.takerPositionHash, tv.qty, t.makerPrice, 1, block.number);
931            
932                 updateBalances(
933                     t.futuresContract, 
934                     [
935                         t.baseToken,  // base token
936                         t.taker // user address
937                     ], 
938                     t.takerPositionHash, // position hash
939                     [
940                         tv.qty, // qty
941                         t.makerPrice, // price
942                         takerFee, // fee
943                         0,  // profit
944                         0,  // loss
945                         tv.takerBalance, // balance
946                         t.takerGasFee, // gasFee
947                         tv.takerReserve // reserve
948                     ], 
949                     [
950                         true, // newPostion (if true position is new)
951                         true, // side (if true - long)
952                         false // increase position (if true)
953                     ]
954                 );
955 
956             } else {
957                 if (positionExists(t.takerPositionHash))
958                 {
959                     // check if taker has enough balance
960                     //if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether)), t.takerGasFee / 1e10) * 1e10 > safeSub(balances[1],tv.takerReserve))
961                     if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
962                     {
963                         // maker out of balance
964                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
965                         return 0; 
966                     }
967                     
968                     // increase position size
969                     updatePositionSize(t.takerPositionHash, safeAdd(retrievePosition(t.takerPositionHash)[0], tv.qty), t.makerPrice);
970                 
971                     updateBalances(
972                         t.futuresContract, 
973                         [
974                             t.baseToken,  // base token
975                             t.taker // user address
976                         ], 
977                         t.takerPositionHash, // position hash
978                         [
979                             tv.qty, // qty
980                             t.makerPrice, // price
981                             takerFee, // fee
982                             0, // profit
983                             0, // loss
984                             tv.takerBalance, // balance
985                             t.takerGasFee, // gasFee
986                             tv.takerReserve // reserve
987                         ], 
988                         [
989                             false, // newPostion (if true position is new)
990                             true, // side (if true - long)
991                             true // increase position (if true)
992                         ]
993                     );
994                 }
995                 else
996                 {
997 
998                     // close/partially close existing position
999                     updatePositionSize(t.takerInversePositionHash, safeSub(retrievePosition(t.takerInversePositionHash)[0], tv.qty), 0);
1000                                      
1001                     if (t.makerPrice < retrievePosition(t.takerInversePositionHash)[1])
1002                     {
1003                         // user has made a profit
1004                         //tv.takerProfit                    = safeMul(safeSub(retrievePosition(t.takerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;
1005                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);
1006                     }
1007                     else
1008                     {
1009                         // user has made a loss
1010                         //tv.takerLoss                      = safeMul(safeSub(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1]), tv.qty) / t.makerPrice; 
1011                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                  
1012                     }
1013 
1014                     
1015 
1016                     updateBalances(
1017                         t.futuresContract, 
1018                         [
1019                             t.baseToken,   // base toke
1020                             t.taker // user address
1021                         ], 
1022                         t.takerInversePositionHash,  // position hash
1023                         [
1024                             tv.qty, // qty
1025                             t.makerPrice, // price
1026                             takerFee, // fee
1027                             tv.takerProfit, // profit
1028                             tv.takerLoss, // loss
1029                             tv.takerBalance, // balance
1030                             t.takerGasFee, // gasFee
1031                             tv.takerReserve // reserve
1032                         ], 
1033                         [
1034                             false, // newPostion (if true position is new)
1035                             true, // side (if true - long) 
1036                             false // increase position (if true)
1037                         ]
1038                     );
1039                 }
1040             }           
1041         }
1042 
1043 //--> 220 000
1044         orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty); // increase the maker order filled amount
1045         orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); // increase the taker order filled amount
1046 
1047 //--> 264 000
1048         emit FuturesTrade(takerIsBuying, tv.qty, t.makerPrice, t.futuresContract, t.makerOrderHash, t.takerOrderHash);
1049 
1050         return tv.qty;
1051     }
1052 
1053 
1054     function calculateProfit(uint256 closingPrice, uint256 entryPrice, uint256 qty, bytes32 futuresContractHash, bool side) returns (uint256)
1055     {
1056         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1057         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1058 
1059         if (side)
1060         {
1061             if (inversed)
1062             {
1063                 return safeMul(safeSub(entryPrice, closingPrice), qty) / closingPrice;  
1064             }
1065             else
1066             {
1067                 return safeMul(safeMul(safeSub(entryPrice, closingPrice), qty), multiplier)  / 1e8 / 1e18;
1068             }
1069             
1070         }
1071         else
1072         {
1073             if (inversed)
1074             {
1075                 return safeMul(safeSub(closingPrice, entryPrice), qty) / closingPrice; 
1076             }
1077             else
1078             {
1079                 return safeMul(safeMul(safeSub(closingPrice, entryPrice), qty), multiplier)  / 1e8 / 1e18; 
1080             }
1081         }       
1082     }
1083 
1084     function calculateTradeValue(uint256 qty, uint256 price, bytes32 futuresContractHash) returns (uint256)
1085     {
1086         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1087         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1088         if (inversed)
1089         {
1090             return qty * 1e10;
1091         }
1092         else
1093         {
1094             return safeMul(safeMul(safeMul(qty, price), 1e2), multiplier) / 1e18 ;
1095         }
1096     }
1097 
1098 
1099 
1100     function calculateLoss(uint256 closingPrice, uint256 entryPrice, uint256 qty,  bytes32 futuresContractHash, bool side) returns (uint256)
1101     {
1102         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1103         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1104 
1105         if (side)
1106         {
1107             if (inversed)
1108             {
1109                 return safeMul(safeSub(closingPrice, entryPrice), qty) / closingPrice;
1110             }
1111             else
1112             {
1113                 return safeMul(safeMul(safeSub(closingPrice, entryPrice), qty), multiplier) / 1e8 / 1e18;
1114             }
1115         }
1116         else
1117         {
1118             if (inversed)
1119             {
1120                 return safeMul(safeSub(entryPrice, closingPrice), qty) / closingPrice;
1121             }
1122             else
1123             {
1124                 return safeMul(safeMul(safeSub(entryPrice, closingPrice), qty), multiplier) / 1e8 / 1e18;
1125             } 
1126         }
1127         
1128     }
1129 
1130     function calculateCollateral (uint256 limitPrice, uint256 tradePrice, uint256 qty, bool side, bytes32 futuresContractHash) view returns (uint256)
1131     {
1132         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1133         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1134 
1135         if (side)
1136         {
1137             // long
1138             if (inversed)
1139             {
1140                 return safeMul(safeSub(tradePrice, limitPrice), qty) / limitPrice;
1141             }
1142             else
1143             {
1144                 return safeMul(safeMul(safeSub(tradePrice, limitPrice), qty), multiplier) / 1e8 / 1e18;
1145             }
1146         }
1147         else
1148         {
1149             // short
1150             if (inversed)
1151             {
1152                 return safeMul(safeSub(limitPrice, tradePrice), qty)  / limitPrice;
1153             }
1154             else
1155             {
1156                 return safeMul(safeMul(safeSub(limitPrice, tradePrice), qty), multiplier) / 1e8 / 1e18;
1157             }
1158         }         
1159     }
1160 
1161     function calculateFee (uint256 qty, uint256 tradePrice, uint256 fee, bytes32 futuresContractHash) returns (uint256)
1162     {
1163         return safeMul(calculateTradeValue(qty, tradePrice, futuresContractHash), fee) / 1e18 / 1e10;
1164     }
1165 
1166 
1167     function checkEnoughBalance (uint256 limitPrice, uint256 tradePrice, uint256 qty, bool side, uint256 fee, uint256 gasFee, bytes32 futuresContractHash, uint256 availableBalance) view returns (bool)
1168     {
1169         
1170         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1171         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1172 
1173         if (side)
1174         {
1175             // long
1176             if (safeAdd(
1177                     safeAdd(
1178                         calculateCollateral(limitPrice, tradePrice, qty, side, futuresContractHash), 
1179                         //safeMul(qty, fee) / (1 ether)
1180                         calculateFee(qty, tradePrice, fee, futuresContractHash)
1181                     ) * 1e10,
1182                     gasFee 
1183                 ) > availableBalance)
1184             {
1185                 return false; 
1186             }
1187         }
1188         else
1189         {
1190             // short
1191             if (safeAdd(
1192                     safeAdd(
1193                         calculateCollateral(limitPrice, tradePrice, qty, side, futuresContractHash), 
1194                         //safeMul(qty, fee) / (1 ether)
1195                         calculateFee(qty, tradePrice, fee, futuresContractHash)
1196                     ) * 1e10, 
1197                     gasFee 
1198                 ) > availableBalance)
1199             {
1200                 return false;
1201             }
1202 
1203         }
1204 
1205         return true;
1206        
1207     }  
1208 
1209       
1210 
1211     // Executes multiple trades in one transaction, saves gas fees
1212     function batchFuturesTrade(
1213         uint8[2][] v,
1214         bytes32[4][] rs,
1215         uint256[8][] tradeValues,
1216         address[2][] tradeAddresses,
1217         bool[] takerIsBuying,
1218         bytes32[] assetHash,
1219         uint256[4][] contractValues
1220     ) onlyAdmin
1221     {
1222         // perform trades
1223         for (uint i = 0; i < tradeAddresses.length; i++) {
1224             futuresTrade(
1225                 v[i],
1226                 rs[i],
1227                 tradeValues[i],
1228                 tradeAddresses[i],
1229                 takerIsBuying[i],
1230                 createFuturesContract(assetHash[i], contractValues[i][0], contractValues[i][1], contractValues[i][2], contractValues[i][3])
1231             );
1232         }
1233     }
1234 
1235     
1236 
1237 
1238     // Update user balance
1239     function updateBalances (bytes32 futuresContract, address[2] addressValues, bytes32 positionHash, uint256[8] uintValues, bool[3] boolValues) private
1240     {
1241         /*
1242             addressValues
1243             [0] baseToken
1244             [1] user
1245 
1246             uintValues
1247             [0] qty
1248             [1] price
1249             [2] fee
1250             [3] profit
1251             [4] loss
1252             [5] balance
1253             [6] gasFee
1254             [7] reserve
1255 
1256             boolValues
1257             [0] newPostion
1258             [1] side
1259             [2] increase position
1260 
1261         */
1262 
1263         //                          qty * price * fee
1264         // uint256 pam[0] = safeMul(safeMul(uintValues[0], uintValues[1]), uintValues[2]) / (1 ether);
1265         // uint256 collateral;  
1266 
1267 
1268         // pam = [fee value, collateral]                        
1269         uint256[2] memory pam = [safeAdd(calculateFee(uintValues[0], uintValues[1], uintValues[2], futuresContract) * 1e10, uintValues[6]), 0];
1270         
1271         // LogUint(100, uintValues[3]);
1272         // LogUint(9, uintValues[2]);
1273         // LogUint(7, safeMul(uintValues[0], uintValues[2])  / (1 ether));
1274         // return;
1275 
1276         
1277 
1278         // Position is new or position is increased
1279         if (boolValues[0] || boolValues[2])  
1280         {
1281 
1282             if (boolValues[1])
1283             {
1284 
1285                 //addReserve(addressValues[0], addressValues[1], uintValues[ 7], safeMul(safeSub(uintValues[1], futuresContracts[futuresContract].floorPrice), uintValues[0])); // reserve collateral on user
1286                 //pam[1] = safeMul(safeSub(uintValues[1], futuresContracts[futuresContract].floorPrice), uintValues[0]) / futuresContracts[futuresContract].floorPrice;
1287                 pam[1] = calculateCollateral(futuresContracts[futuresContract].floorPrice, uintValues[1], uintValues[0], true, futuresContract);
1288 
1289             }
1290             else
1291             {
1292                 //addReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(safeSub(futuresContracts[futuresContract].capPrice, uintValues[1]), uintValues[0])); // reserve collateral on user
1293                 //pam[1] = safeMul(safeSub(futuresContracts[futuresContract].capPrice, uintValues[1]), uintValues[0]) / futuresContracts[futuresContract].capPrice;
1294                 pam[1] = calculateCollateral(futuresContracts[futuresContract].capPrice, uintValues[1], uintValues[0], false, futuresContract);
1295             }
1296 
1297             subBalanceAddReserve(addressValues[0], addressValues[1], pam[0], safeAdd(pam[1],1));         
1298 
1299             // if (uintValues[6] > 0)
1300             // {   
1301             //     subBalanceAddReserve(addressValues[0], addressValues[1], safeAdd(uintValues[6], pam[0]), pam[1]);                  
1302                               
1303             // }
1304             // else
1305             // {
1306 
1307             //    subBalanceAddReserve(addressValues[0], addressValues[1], safeAdd(uintValues[6], pam[0]), pam[1]);                 
1308             // }
1309 
1310 
1311             //subBalance(addressValues[0], addressValues[1], uintValues[5], feeVal); // deduct user maker/taker fee 
1312 
1313             
1314         // Position exists
1315         } 
1316         else 
1317         {
1318             if (retrievePosition(positionHash)[2] == 0)
1319             {
1320                 // original position was short
1321                 //subReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(uintValues[0], safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]))); // remove freed collateral from reserver
1322                 //pam[1] = safeMul(uintValues[0], safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1])) / futuresContracts[futuresContract].capPrice;
1323                 pam[1] = calculateCollateral(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1], uintValues[0], false, futuresContract);
1324 
1325                 // LogUint(120, uintValues[0]);
1326                 // LogUint(121, futuresContracts[futuresContract].capPrice);
1327                 // LogUint(122, retrievePosition(positionHash)[1]);
1328                 // LogUint(123, uintValues[3]); // profit
1329                 // LogUint(124, uintValues[4]); // loss
1330                 // LogUint(125, safeAdd(uintValues[4], pam[0]));
1331                 // LogUint(12, pam[1] );
1332                 //return;
1333             }
1334             else
1335             {       
1336                        
1337                 // original position was long
1338                 //subReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(uintValues[0], safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice)));
1339                 //pam[1] = safeMul(uintValues[0], safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice)) / futuresContracts[futuresContract].floorPrice;
1340                 pam[1] = calculateCollateral(futuresContracts[futuresContract].floorPrice, retrievePosition(positionHash)[1], uintValues[0], true, futuresContract);
1341 
1342             }
1343 
1344 
1345                 // LogUint(41, uintValues[3]);
1346                 // LogUint(42, uintValues[4]);
1347                 // LogUint(43, pam[0]);
1348                 // return;  
1349             if (uintValues[3] > 0) 
1350             {
1351                 // profi > 0
1352 
1353                 if (pam[0] <= uintValues[3]*1e10)
1354                 {
1355                     //addBalance(addressValues[0], addressValues[1], uintValues[5], safeSub(uintValues[3], pam[0])); // add profit to user balance
1356                     addBalanceSubReserve(addressValues[0], addressValues[1], safeSub(uintValues[3]*1e10, pam[0]), pam[1]);
1357                 }
1358                 else
1359                 {
1360                     subBalanceSubReserve(addressValues[0], addressValues[1], safeSub(pam[0], uintValues[3]*1e10), pam[1]);
1361                 }
1362                 
1363             } 
1364             else 
1365             {   
1366                 
1367 
1368                 // loss >= 0
1369                 //subBalance(addressValues[0], addressValues[1], uintValues[5], safeAdd(uintValues[4], pam[0])); // deduct loss from user balance 
1370                 subBalanceSubReserve(addressValues[0], addressValues[1], safeAdd(uintValues[4]*1e10, pam[0]), pam[1]); // deduct loss from user balance
1371            
1372             } 
1373             //}            
1374         }          
1375         
1376         addBalance(addressValues[0], feeAccount, EtherMium(exchangeContract).balanceOf(addressValues[0], feeAccount), pam[0]); // send fee to feeAccount
1377     }
1378 
1379     function recordNewPosition (bytes32 positionHash, uint256 size, uint256 price, uint256 side, uint256 block) private
1380     {
1381         if (!validateUint128(size) || !validateUint64(price)) 
1382         {
1383             throw;
1384         }
1385 
1386         uint256 character = uint128(size);
1387         character |= price<<128;
1388         character |= side<<192;
1389         character |= block<<208;
1390 
1391         positions[positionHash] = character;
1392     }
1393 
1394     function retrievePosition (bytes32 positionHash) public view returns (uint256[4])
1395     {
1396         uint256 character = positions[positionHash];
1397         uint256 size = uint256(uint128(character));
1398         uint256 price = uint256(uint64(character>>128));
1399         uint256 side = uint256(uint16(character>>192));
1400         uint256 entryBlock = uint256(uint48(character>>208));
1401 
1402         return [size, price, side, entryBlock];
1403     }
1404 
1405     function updatePositionSize(bytes32 positionHash, uint256 size, uint256 price) private
1406     {
1407         uint256[4] memory pos = retrievePosition(positionHash);
1408 
1409         if (size > pos[0])
1410         {
1411             // position is increasing in size
1412             recordNewPosition(positionHash, size, safeAdd(safeMul(pos[0], pos[1]), safeMul(price, safeSub(size, pos[0]))) / size, pos[2], pos[3]);
1413         }
1414         else
1415         {
1416             // position is decreasing in size
1417             recordNewPosition(positionHash, size, pos[1], pos[2], pos[3]);
1418         }        
1419     }
1420 
1421     function positionExists (bytes32 positionHash) internal view returns (bool)
1422     {
1423         //LogUint(3,retrievePosition(positionHash)[0]);
1424         if (retrievePosition(positionHash)[0] == 0)
1425         {
1426             return false;
1427         }
1428         else
1429         {
1430             return true;
1431         }
1432     }
1433 
1434     // This function allows the user to manually release collateral in case the oracle service does not provide the price during the inactivityReleasePeriod
1435     function forceReleaseReserve (bytes32 futuresContract, bool side) public
1436     {   
1437         if (futuresContracts[futuresContract].expirationBlock == 0) throw;       
1438         if (futuresContracts[futuresContract].expirationBlock > block.number) throw;
1439         if (safeAdd(futuresContracts[futuresContract].expirationBlock, EtherMium(exchangeContract).getInactivityReleasePeriod()) > block.number) throw;  
1440 
1441         bytes32 positionHash = keccak256(this, msg.sender, futuresContract, side);
1442         if (retrievePosition(positionHash)[1] == 0) throw;    
1443   
1444 
1445         futuresContracts[futuresContract].broken = true;
1446 
1447         address baseToken = futuresAssets[futuresContracts[futuresContract].asset].baseToken;
1448 
1449         if (side)
1450         {
1451             subReserve(
1452                 baseToken, 
1453                 msg.sender, 
1454                 EtherMium(exchangeContract).getReserve(baseToken, msg.sender), 
1455                 //safeMul(safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].floorPrice
1456                 calculateCollateral(futuresContracts[futuresContract].floorPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], true, futuresContract)
1457             ); 
1458         }
1459         else
1460         {            
1461             subReserve(
1462                 baseToken, 
1463                 msg.sender, 
1464                 EtherMium(exchangeContract).getReserve(baseToken, msg.sender), 
1465                 //safeMul(safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].capPrice
1466                 calculateCollateral(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], false, futuresContract)
1467             ); 
1468         }
1469 
1470         updatePositionSize(positionHash, 0, 0);
1471 
1472         //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), );
1473         //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], positions[msg.sender][positionHash].collateral);
1474 
1475         emit FuturesForcedRelease(futuresContract, side, msg.sender);
1476 
1477     }
1478 
1479     function addBalance(address token, address user, uint256 balance, uint256 amount) private
1480     {
1481         EtherMium(exchangeContract).setBalance(token, user, safeAdd(balance, amount));
1482     }
1483 
1484     function subBalance(address token, address user, uint256 balance, uint256 amount) private
1485     {
1486         EtherMium(exchangeContract).setBalance(token, user, safeSub(balance, amount));
1487     }
1488 
1489     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) private
1490     {
1491         EtherMium(exchangeContract).subBalanceAddReserve(token, user, subBalance, addReserve * 1e10);
1492     }
1493 
1494     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) private
1495     {
1496 
1497         EtherMium(exchangeContract).addBalanceSubReserve(token, user, addBalance, subReserve * 1e10);
1498     }
1499 
1500     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) private
1501     {
1502         // LogUint(31, subBalance);
1503         // LogUint(32, subReserve);
1504         // return;
1505 
1506         EtherMium(exchangeContract).subBalanceSubReserve(token, user, subBalance, subReserve * 1e10);
1507     }
1508 
1509     function addReserve(address token, address user, uint256 reserve, uint256 amount) private
1510     {
1511         //reserve[token][user] = safeAdd(reserve[token][user], amount);
1512         EtherMium(exchangeContract).setReserve(token, user, safeAdd(reserve, amount * 1e10));
1513     }
1514 
1515     function subReserve(address token, address user, uint256 reserve, uint256 amount) private 
1516     {
1517         //reserve[token][user] = safeSub(reserve[token][user], amount);
1518         EtherMium(exchangeContract).setReserve(token, user, safeSub(reserve, amount * 1e10));
1519     }
1520 
1521 
1522     function getMakerTakerBalances(address maker, address taker, address token) public view returns (uint256[4])
1523     {
1524         return [
1525             EtherMium(exchangeContract).balanceOf(token, maker),
1526             EtherMium(exchangeContract).getReserve(token, maker),
1527             EtherMium(exchangeContract).balanceOf(token, taker),
1528             EtherMium(exchangeContract).getReserve(token, taker)
1529         ];
1530     }
1531 
1532     function getMakerTakerPositions(bytes32 makerPositionHash, bytes32 makerInversePositionHash, bytes32 takerPosition, bytes32 takerInversePosition) public view returns (uint256[4][4])
1533     {
1534         return [
1535             retrievePosition(makerPositionHash),
1536             retrievePosition(makerInversePositionHash),
1537             retrievePosition(takerPosition),
1538             retrievePosition(takerInversePosition)
1539         ];
1540     }
1541 
1542 
1543     struct FuturesClosePositionValues {
1544         uint256 reserve;                // amount to be trade
1545         uint256 balance;        // holds maker profit value
1546         uint256 floorPrice;          // holds maker loss value
1547         uint256 capPrice;        // holds taker profit value
1548         uint256 closingPrice;          // holds taker loss value
1549         bytes32 futuresContract; // the futures contract hash
1550     }
1551 
1552 
1553     function closeFuturesPosition (bytes32 futuresContract, bool side)
1554     {
1555         bytes32 positionHash = keccak256(this, msg.sender, futuresContract, side);
1556 
1557         if (futuresContracts[futuresContract].closed == false && futuresContracts[futuresContract].expirationBlock != 0) throw; // contract not yet settled
1558         if (retrievePosition(positionHash)[1] == 0) throw; // position not found
1559         if (retrievePosition(positionHash)[0] == 0) throw; // position already closed
1560 
1561         uint256 profit;
1562         uint256 loss;
1563 
1564         address baseToken = futuresAssets[futuresContracts[futuresContract].asset].baseToken;
1565 
1566         FuturesClosePositionValues memory v = FuturesClosePositionValues({
1567             reserve         : EtherMium(exchangeContract).getReserve(baseToken, msg.sender),
1568             balance         : EtherMium(exchangeContract).balanceOf(baseToken, msg.sender),
1569             floorPrice      : futuresContracts[futuresContract].floorPrice,
1570             capPrice        : futuresContracts[futuresContract].capPrice,
1571             closingPrice    : futuresContracts[futuresContract].closingPrice,
1572             futuresContract : futuresContract
1573         });
1574 
1575         // uint256 reserve = EtherMium(exchangeContract).getReserve(baseToken, msg.sender);
1576         // uint256 balance = EtherMium(exchangeContract).balanceOf(baseToken, msg.sender);
1577         // uint256 floorPrice = futuresContracts[futuresContract].floorPrice;
1578         // uint256 capPrice = futuresContracts[futuresContract].capPrice;
1579         // uint256 closingPrice =  futuresContracts[futuresContract].closingPrice;
1580 
1581 
1582         
1583         //uint256 fee = safeMul(safeMul(retrievePosition(positionHash)[0], v.closingPrice), takerFee) / (1 ether);
1584         uint256 fee = calculateFee(retrievePosition(positionHash)[0], v.closingPrice, takerFee, futuresContract);
1585 
1586 
1587 
1588         // close long position
1589         if (side == true)
1590         {            
1591 
1592             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1593             // LogUint(12, safeMul(safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].floorPrice);
1594             // return;
1595             // reserve = reserve - (entryPrice - floorPrice) * size;
1596             //subReserve(baseToken, msg.sender, EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[positionHash].size));
1597             
1598             
1599             subReserve(
1600                 baseToken, 
1601                 msg.sender, 
1602                 v.reserve, 
1603                 //safeMul(safeSub(retrievePosition(positionHash)[1], v.floorPrice), retrievePosition(positionHash)[0]) / v.floorPrice
1604                 calculateCollateral(v.floorPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], true, v.futuresContract)
1605             );
1606             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1607             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1608             
1609             
1610 
1611             if (v.closingPrice > retrievePosition(positionHash)[1])
1612             {
1613                 // user made a profit
1614                 //profit = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1615                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);
1616                 
1617 
1618 
1619                 // LogUint(15, profit);
1620                 // LogUint(16, fee);
1621                 // LogUint(17, safeSub(profit * 1e10, fee));
1622                 // return;
1623                 if (profit > fee)
1624                 {
1625                     addBalance(baseToken, msg.sender, v.balance, safeSub(profit * 1e10, fee * 1e10)); 
1626                 }
1627                 else
1628                 {
1629                     subBalance(baseToken, msg.sender, v.balance, safeSub(fee * 1e10, profit * 1e10)); 
1630                 }
1631                 //EtherMium(exchangeContract).updateBalance(baseToken, msg.sender, safeAdd(EtherMium(exchangeContract).balanceOf(baseToken, msg.sender), profit);
1632                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1633             }
1634             else
1635             {
1636                 // user made a loss
1637                 //loss = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1638                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);  
1639 
1640 
1641                 subBalance(baseToken, msg.sender, v.balance, safeAdd(loss * 1e10, fee * 1e10));
1642                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1643             }
1644         }   
1645         // close short position 
1646         else
1647         {
1648             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1649             // LogUint(12, safeMul(safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].capPrice);
1650             // return;
1651 
1652             // reserve = reserve - (capPrice - entryPrice) * size;
1653             subReserve(
1654                 baseToken, 
1655                 msg.sender,  
1656                 v.reserve, 
1657                 //safeMul(safeSub(v.capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.capPrice
1658                 calculateCollateral(v.capPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], false, v.futuresContract)
1659             );
1660             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1661             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1662             
1663             
1664 
1665             if (v.closingPrice < retrievePosition(positionHash)[1])
1666             {
1667                 // user made a profit
1668                 // profit = (entryPrice - closingPrice) * size
1669                 // profit = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1670                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);
1671 
1672                 if (profit > fee)
1673                 {
1674                     addBalance(baseToken, msg.sender, v.balance, safeSub(profit * 1e10, fee * 1e10)); 
1675                 }
1676                 else
1677                 {
1678                     subBalance(baseToken, msg.sender, v.balance, safeSub(fee * 1e10, profit * 1e10)); 
1679                 }
1680 
1681                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1682             }
1683             else
1684             {
1685                 // user made a loss
1686                 // profit = (closingPrice - entryPrice) * size
1687                 //loss = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1688                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);  
1689 
1690                 subBalance(baseToken, msg.sender, v.balance, safeAdd(loss * 1e10, fee * 1e10));
1691 
1692                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1693             }
1694         }  
1695 
1696         addBalance(baseToken, feeAccount, EtherMium(exchangeContract).balanceOf(baseToken, feeAccount), fee * 1e10); // send fee to feeAccount
1697         updatePositionSize(positionHash, 0, 0);
1698 
1699         emit FuturesPositionClosed(positionHash);
1700     }
1701 
1702     function closeFuturesContract (bytes32 futuresContract, uint256 price) onlyOracle
1703     {
1704         if (futuresContracts[futuresContract].expirationBlock == 0)  revert(); // contract not found
1705         if (futuresContracts[futuresContract].closed == true)  revert(); // contract already closed
1706 
1707         if (futuresContracts[futuresContract].expirationBlock > block.number
1708             && price > futuresContracts[futuresContract].floorPrice
1709             && price < futuresContracts[futuresContract].capPrice) revert(); // contract not yet expired and the price did not leave the range
1710                 
1711         futuresContracts[futuresContract].closingPrice = price;
1712         futuresContracts[futuresContract].closed = true;
1713 
1714         emit FuturesContractClosed(futuresContract, price);
1715     }  
1716 
1717     // closes position for user
1718     function closeFuturesPositionForUser (bytes32 futuresContract, bool side, address user, uint256 gasFee) onlyAdmin
1719     {
1720         bytes32 positionHash = keccak256(this, user, futuresContract, side);
1721 
1722         if (futuresContracts[futuresContract].closed == false && futuresContracts[futuresContract].expirationBlock != 0) throw; // contract not yet settled
1723         if (retrievePosition(positionHash)[1] == 0) throw; // position not found
1724         if (retrievePosition(positionHash)[0] == 0) throw; // position already closed
1725 
1726         // failsafe, gas fee cannot be greater than 5% of position value
1727         if (safeMul(gasFee * 1e10, 20) > calculateTradeValue(retrievePosition(positionHash)[0], retrievePosition(positionHash)[1], futuresContract))
1728         {
1729             emit LogError(uint8(Errors.GAS_TOO_HIGH), futuresContract, positionHash);
1730             return;
1731         }
1732 
1733 
1734         uint256 profit;
1735         uint256 loss;
1736 
1737         address baseToken = futuresAssets[futuresContracts[futuresContract].asset].baseToken;
1738 
1739         FuturesClosePositionValues memory v = FuturesClosePositionValues({
1740             reserve         : EtherMium(exchangeContract).getReserve(baseToken, user),
1741             balance         : EtherMium(exchangeContract).balanceOf(baseToken, user),
1742             floorPrice      : futuresContracts[futuresContract].floorPrice,
1743             capPrice        : futuresContracts[futuresContract].capPrice,
1744             closingPrice    : futuresContracts[futuresContract].closingPrice,
1745             futuresContract : futuresContract
1746         });
1747 
1748         // uint256 reserve = EtherMium(exchangeContract).getReserve(baseToken, msg.sender);
1749         // uint256 balance = EtherMium(exchangeContract).balanceOf(baseToken, msg.sender);
1750         // uint256 floorPrice = futuresContracts[futuresContract].floorPrice;
1751         // uint256 capPrice = futuresContracts[futuresContract].capPrice;
1752         // uint256 closingPrice =  futuresContracts[futuresContract].closingPrice;
1753 
1754 
1755         
1756         //uint256 fee = safeMul(safeMul(retrievePosition(positionHash)[0], v.closingPrice), takerFee) / (1 ether);
1757         uint256 fee = safeAdd(calculateFee(retrievePosition(positionHash)[0], v.closingPrice, takerFee, futuresContract), gasFee);
1758 
1759         // close long position
1760         if (side == true)
1761         {            
1762 
1763             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1764             // LogUint(12, safeMul(safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].floorPrice);
1765             // return;
1766             // reserve = reserve - (entryPrice - floorPrice) * size;
1767             //subReserve(baseToken, msg.sender, EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[positionHash].size));
1768             
1769             
1770             subReserve(
1771                 baseToken, 
1772                 user, 
1773                 v.reserve, 
1774                 //safeMul(safeSub(retrievePosition(positionHash)[1], v.floorPrice), retrievePosition(positionHash)[0]) / v.floorPrice
1775                 calculateCollateral(v.floorPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], true, v.futuresContract)
1776             );
1777             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1778             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1779             
1780             
1781 
1782             if (v.closingPrice > retrievePosition(positionHash)[1])
1783             {
1784                 // user made a profit
1785                 //profit = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1786                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);
1787                 
1788 
1789 
1790                 // LogUint(15, profit);
1791                 // LogUint(16, fee);
1792                 // LogUint(17, safeSub(profit * 1e10, fee));
1793                 // return;
1794                 if (profit > fee)
1795                 {
1796                     addBalance(baseToken, user, v.balance, safeSub(profit * 1e10, fee * 1e10)); 
1797                 }
1798                 else
1799                 {
1800                     subBalance(baseToken, user, v.balance, safeSub(fee * 1e10, profit * 1e10)); 
1801                 }
1802                 //EtherMium(exchangeContract).updateBalance(baseToken, msg.sender, safeAdd(EtherMium(exchangeContract).balanceOf(baseToken, msg.sender), profit);
1803                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1804             }
1805             else
1806             {
1807                 // user made a loss
1808                 //loss = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1809                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);  
1810 
1811 
1812                 subBalance(baseToken, user, v.balance, safeAdd(loss * 1e10, fee * 1e10));
1813                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1814             }
1815         }   
1816         // close short position 
1817         else
1818         {
1819             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1820             // LogUint(12, safeMul(safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].capPrice);
1821             // return;
1822 
1823             // reserve = reserve - (capPrice - entryPrice) * size;
1824             subReserve(
1825                 baseToken, 
1826                 user,  
1827                 v.reserve, 
1828                 //safeMul(safeSub(v.capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.capPrice
1829                 calculateCollateral(v.capPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], false, v.futuresContract)
1830             );
1831             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1832             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1833             
1834             
1835 
1836             if (v.closingPrice < retrievePosition(positionHash)[1])
1837             {
1838                 // user made a profit
1839                 // profit = (entryPrice - closingPrice) * size
1840                 // profit = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1841                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);
1842 
1843                 if (profit > fee)
1844                 {
1845                     addBalance(baseToken, user, v.balance, safeSub(profit * 1e10, fee * 1e10)); 
1846                 }
1847                 else
1848                 {
1849                     subBalance(baseToken, user, v.balance, safeSub(fee * 1e10, profit * 1e10)); 
1850                 }
1851                 
1852 
1853                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1854             }
1855             else
1856             {
1857                 // user made a loss
1858                 // profit = (closingPrice - entryPrice) * size
1859                 //loss = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1860                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);  
1861 
1862                 subBalance(baseToken, user, v.balance, safeAdd(loss * 1e10, fee * 1e10));
1863 
1864                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1865             }
1866         }  
1867 
1868         addBalance(baseToken, feeAccount, EtherMium(exchangeContract).balanceOf(baseToken, feeAccount), fee * 1e10); // send fee to feeAccount
1869         updatePositionSize(positionHash, 0, 0);
1870 
1871         emit FuturesPositionClosed(positionHash);
1872     }
1873 
1874     // Settle positions for closed contracts
1875     function batchSettlePositions (
1876         bytes32[] futuresContracts,
1877         bool[] sides,
1878         address[] users,
1879         uint256 gasFeePerClose // baseToken with 8 decimals
1880     ) onlyAdmin {
1881         
1882         for (uint i = 0; i < futuresContracts.length; i++) 
1883         {
1884             closeFuturesPositionForUser(futuresContracts[i], sides[i], users[i], gasFeePerClose);
1885         }
1886     }
1887 
1888 
1889 
1890     
1891     
1892 
1893     // Returns the smaller of two values
1894     function min(uint a, uint b) private pure returns (uint) {
1895         return a < b ? a : b;
1896     }
1897 }