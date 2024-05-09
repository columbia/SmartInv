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
43         
44         if (!assertion) {
45             throw;
46         }
47     }
48 
49     // Safe Multiply Function - prevents integer overflow 
50     function safeMul(uint a, uint b) pure returns (uint) {
51         uint c = a * b;
52         assert(a == 0 || c / a == b);
53         return c;
54     }
55 
56     // Safe Subtraction Function - prevents integer overflow 
57     function safeSub(uint a, uint b) pure returns (uint) {
58         assert(b <= a);
59         return a - b;
60     }
61 
62     // Safe Addition Function - prevents integer overflow 
63     function safeAdd(uint a, uint b) pure returns (uint) {
64         uint c = a + b;
65         assert(c>=a && c>=b);
66         return c;
67     }
68 
69     address public owner; // holds the address of the contract owner
70 
71     // Event fired when the owner of the contract is changed
72     event SetOwner(address indexed previousOwner, address indexed newOwner);
73 
74     // Allows only the owner of the contract to execute the function
75     modifier onlyOwner {
76         assert(msg.sender == owner);
77         _;
78     }
79 
80     // Changes the owner of the contract
81     function setOwner(address newOwner) onlyOwner {
82         emit SetOwner(owner, newOwner);
83         owner = newOwner;
84     }
85 
86     // Owner getter function
87     function getOwner() view returns (address out) {
88         return owner;
89     }
90 
91     mapping (address => bool) public admins;                    // mapping of admin addresses
92     mapping (address => uint256) public lastActiveTransaction;  // mapping of user addresses to last transaction block
93     mapping (bytes32 => uint256) public orderFills;             // mapping of orders to filled qunatity
94     
95     address public feeAccount;          // the account that receives the trading fees
96     address public exchangeContract;    // the address of the main EtherMium contract
97 
98     uint256 public makerFee;            // maker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
99     uint256 public takerFee;            // taker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
100     
101     struct FuturesAsset {
102         string name;                    // the name of the traded asset (ex. ETHUSD)
103         address baseToken;              // the token for collateral
104         string priceUrl;                // the url where the price of the asset will be taken for settlement
105         string pricePath;               // price path in the returned JSON from the priceUrl (ex. path "last" will return tha value last from the json: {"high": "156.49", "last": "154.31", "timestamp": "1556522201", "bid": "154.22", "vwap": "154.65", "volume": "25578.79138868", "low": "152.33", "ask": "154.26", "open": "152.99"})
106         bool inversed;                  // if true, the price from the priceUrl will be inversed (i.e price = 1/priceUrl)
107         bool disabled;                  // if true, the asset cannot be used in contract creation (when price url no longer valid)
108     }
109 
110     function createFuturesAsset(string name, address baseToken, string priceUrl, string pricePath, bool inversed) onlyAdmin returns (bytes32)
111     {    
112         bytes32 futuresAsset = keccak256(this, name, baseToken, priceUrl, pricePath, inversed);
113         if (futuresAssets[futuresAsset].disabled) throw; // asset already exists and is disabled
114 
115         futuresAssets[futuresAsset] = FuturesAsset({
116             name                : name,
117             baseToken           : baseToken,
118             priceUrl            : priceUrl,
119             pricePath           : pricePath,
120             inversed            : inversed,
121             disabled            : false
122         });
123 
124         emit FuturesAssetCreated(futuresAsset, name, baseToken, priceUrl, pricePath, inversed);
125         return futuresAsset;
126     }
127     
128     struct FuturesContract {
129         bytes32 asset;                  // the hash of the underlying asset object
130         uint256 expirationBlock;        // futures contract expiration block
131         uint256 closingPrice;           // the closing price for the futures contract
132         bool closed;                    // is the futures contract closed (0 - false, 1 - true)
133         bool broken;                    // if someone has forced release of funds the contract is marked as broken and can no longer close positions (0-false, 1-true)
134         uint256 floorPrice;             // the minimum price that can be traded on the contract, once price is reached the contract expires and enters settlement state 
135         uint256 capPrice;               // the maximum price that can be traded on the contract, once price is reached the contract expires and enters settlement state
136         uint256 multiplier;             // the multiplier price, used when teh trading pair doesn't have the base token in it (eg. BTCUSD with ETH as base token, multiplier will be the ETHBTC price)
137     }
138 
139     function createFuturesContract(bytes32 asset, uint256 expirationBlock, uint256 floorPrice, uint256 capPrice, uint256 multiplier) onlyAdmin returns (bytes32)
140     {    
141         bytes32 futuresContract = keccak256(this, asset, expirationBlock, floorPrice, capPrice, multiplier);
142         if (futuresContracts[futuresContract].expirationBlock > 0) return futuresContract; // contract already exists
143 
144         futuresContracts[futuresContract] = FuturesContract({
145             asset           : asset,
146             expirationBlock : expirationBlock,
147             closingPrice    : 0,
148             closed          : false,
149             broken          : false,
150             floorPrice      : floorPrice,
151             capPrice        : capPrice,
152             multiplier      : multiplier
153         });
154 
155         emit FuturesContractCreated(futuresContract, asset, expirationBlock, floorPrice, capPrice, multiplier);
156 
157         return futuresContract;
158     }
159 
160     mapping (bytes32 => FuturesAsset)       public futuresAssets;       // mapping of futuresAsset hash to FuturesAsset structs
161     mapping (bytes32 => FuturesContract)    public futuresContracts;   // mapping of futuresContract hash to FuturesContract structs
162     mapping (bytes32 => uint256)            public positions;          // mapping of user addresses to position hashes to position
163 
164     enum Errors {
165         INVALID_PRICE,                  // Order prices don't match
166         INVALID_SIGNATURE,              // Signature is invalid
167         ORDER_ALREADY_FILLED,           // Order was already filled
168         GAS_TOO_HIGH,                   // Too high gas fee
169         OUT_OF_BALANCE,                 // User doesn't have enough balance for the operation
170         FUTURES_CONTRACT_EXPIRED,       // Futures contract already expired
171         FLOOR_OR_CAP_PRICE_REACHED,     // The floor price or the cap price for the futures contract was reached
172         POSITION_ALREADY_EXISTS,        // User has an open position already 
173         UINT48_VALIDATION,              // Size or price bigger than an Uint48
174         FAILED_ASSERTION                // Assertion failed
175     }
176 
177     event FuturesTrade(bool side, uint256 size, uint256 price, bytes32 indexed futuresContract, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
178     event FuturesContractClosed(bytes32 indexed futuresContract, uint256 closingPrice);
179     event FuturesForcedRelease(bytes32 indexed futuresContract, bool side, address user);
180     event FuturesAssetCreated(bytes32 indexed futuresAsset, string name, address baseToken, string priceUrl, string pricePath, bool inversed);
181     event FuturesContractCreated(bytes32 indexed futuresContract, bytes32 asset, uint256 expirationBlock, uint256 floorPrice, uint256 capPrice, uint256 multiplier);
182  
183     // Fee change event
184     event FeeChange(uint256 indexed makerFee, uint256 indexed takerFee);
185 
186     // Log event, logs errors in contract execution (for internal use)
187     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
188     event LogErrorLight(uint8 indexed errorId);
189     event LogUint(uint8 id, uint256 value);
190     event LogBool(uint8 id, bool value);
191     event LogAddress(uint8 id, address value);
192 
193 
194     // Constructor function, initializes the contract and sets the core variables
195     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, address exchangeContract_) {
196         owner               = msg.sender;
197         feeAccount          = feeAccount_;
198         makerFee            = makerFee_;
199         takerFee            = takerFee_;
200 
201         exchangeContract    = exchangeContract_;
202     }
203 
204     // Changes the fees
205     function setFees(uint256 makerFee_, uint256 takerFee_) onlyOwner {
206         require(makerFee_       < 10 finney && takerFee_ < 10 finney); // The fees cannot be set higher then 1%
207         makerFee                = makerFee_;
208         takerFee                = takerFee_;
209 
210         emit FeeChange(makerFee, takerFee);
211     }
212 
213     // Adds or disables an admin account
214     function setAdmin(address admin, bool isAdmin) onlyOwner {
215         admins[admin] = isAdmin;
216     }
217 
218     // Allows for admins only to call the function
219     modifier onlyAdmin {
220         if (msg.sender != owner && !admins[msg.sender]) throw;
221         _;
222     }
223 
224     function() external {
225         throw;
226     }   
227 
228 
229     function validateUint48(uint256 val) returns (bool)
230     {
231         if (val != uint48(val)) return false;
232         return true;
233     }
234 
235     function validateUint64(uint256 val) returns (bool)
236     {
237         if (val != uint64(val)) return false;
238         return true;
239     }
240 
241     function validateUint128(uint256 val) returns (bool)
242     {
243         if (val != uint128(val)) return false;
244         return true;
245     }
246 
247 
248     // Structure that holds order values, used inside the trade() function
249     struct FuturesOrderPair {
250         uint256 makerNonce;                 // maker order nonce, makes the order unique
251         uint256 takerNonce;                 // taker order nonce
252         uint256 takerGasFee;                // taker gas fee, taker pays the gas
253         uint256 takerIsBuying;              // true/false taker is the buyer
254 
255         address maker;                      // address of the maker
256         address taker;                      // address of the taker
257 
258         bytes32 makerOrderHash;             // hash of the maker order
259         bytes32 takerOrderHash;             // has of the taker order
260 
261         uint256 makerAmount;                // trade amount for maker
262         uint256 takerAmount;                // trade amount for taker
263 
264         uint256 makerPrice;                 // maker order price in wei (18 decimal precision)
265         uint256 takerPrice;                 // taker order price in wei (18 decimal precision)
266 
267         bytes32 futuresContract;            // the futures contract being traded
268 
269         address baseToken;                  // the address of the base token for futures contract
270         uint256 floorPrice;                 // floor price of futures contract
271         uint256 capPrice;                   // cap price of futures contract
272 
273         bytes32 makerPositionHash;          // hash for maker position
274         bytes32 makerInversePositionHash;   // hash for inverse maker position 
275 
276         bytes32 takerPositionHash;          // hash for taker position
277         bytes32 takerInversePositionHash;   // hash for inverse taker position
278     }
279 
280     // Structure that holds trade values, used inside the trade() function
281     struct FuturesTradeValues {
282         uint256 qty;                // amount to be trade
283         uint256 makerProfit;        // holds maker profit value
284         uint256 makerLoss;          // holds maker loss value
285         uint256 takerProfit;        // holds taker profit value
286         uint256 takerLoss;          // holds taker loss value
287         uint256 makerBalance;       // holds maker balance value
288         uint256 takerBalance;       // holds taker balance value
289         uint256 makerReserve;       // holds taker reserved value
290         uint256 takerReserve;       // holds taker reserved value
291     }
292 
293     // Opens/closes futures positions
294     function futuresTrade(
295         uint8[2] v,
296         bytes32[4] rs,
297         uint256[8] tradeValues,
298         address[2] tradeAddresses,
299         bool takerIsBuying,
300         bytes32 futuresContractHash
301     ) onlyAdmin returns (uint filledTakerTokenAmount)
302     {
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
313           tradeAddresses
314           [0] maker
315           [1] taker
316         */
317 
318         FuturesOrderPair memory t  = FuturesOrderPair({
319             makerNonce      : tradeValues[0],
320             takerNonce      : tradeValues[1],
321             takerGasFee     : tradeValues[2],
322             takerIsBuying   : tradeValues[3],
323             makerAmount     : tradeValues[4],      
324             takerAmount     : tradeValues[5],   
325             makerPrice      : tradeValues[6],         
326             takerPrice      : tradeValues[7],
327 
328             maker           : tradeAddresses[0],
329             taker           : tradeAddresses[1],
330 
331             //                                futuresContract      user               amount          price           side             nonce
332             makerOrderHash  : keccak256(this, futuresContractHash, tradeAddresses[0], tradeValues[4], tradeValues[6], !takerIsBuying, tradeValues[0]),
333             takerOrderHash  : keccak256(this, futuresContractHash, tradeAddresses[1], tradeValues[5], tradeValues[7],  takerIsBuying, tradeValues[1]),            
334 
335             futuresContract : futuresContractHash,
336 
337             baseToken       : futuresAssets[futuresContracts[futuresContractHash].asset].baseToken,
338             floorPrice      : futuresContracts[futuresContractHash].floorPrice,
339             capPrice        : futuresContracts[futuresContractHash].capPrice,
340 
341             //                                            user               futuresContractHash   side
342             makerPositionHash           : keccak256(this, tradeAddresses[0], futuresContractHash, !takerIsBuying),
343             makerInversePositionHash    : keccak256(this, tradeAddresses[0], futuresContractHash, takerIsBuying),
344 
345             takerPositionHash           : keccak256(this, tradeAddresses[1], futuresContractHash, takerIsBuying),
346             takerInversePositionHash    : keccak256(this, tradeAddresses[1], futuresContractHash, !takerIsBuying)
347 
348         });
349 
350 //--> 44 000
351     
352         // Valifate size and price values
353         if (!validateUint128(t.makerAmount) || !validateUint128(t.takerAmount) || !validateUint64(t.makerPrice) || !validateUint64(t.takerPrice))
354         {            
355             emit LogError(uint8(Errors.UINT48_VALIDATION), t.makerOrderHash, t.takerOrderHash);
356             return 0; 
357         }
358 
359 
360         // Check if futures contract has expired already
361         if (block.number > futuresContracts[t.futuresContract].expirationBlock || futuresContracts[t.futuresContract].closed == true || futuresContracts[t.futuresContract].broken == true)
362         {
363             emit LogError(uint8(Errors.FUTURES_CONTRACT_EXPIRED), t.makerOrderHash, t.takerOrderHash);
364             return 0; // futures contract is expired
365         }
366 
367         // Checks the signature for the maker order
368         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
369         {
370             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
371             return 0;
372         }
373        
374         // Checks the signature for the taker order
375         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
376         {
377             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
378             return 0;
379         }
380 
381 
382 
383         // check prices
384         if ((!takerIsBuying && t.makerPrice < t.takerPrice) || (takerIsBuying && t.takerPrice < t.makerPrice))
385         {
386             emit LogError(uint8(Errors.INVALID_PRICE), t.makerOrderHash, t.takerOrderHash);
387             return 0; // prices don't match
388         }      
389 
390 //--> 54 000
391 
392          
393         
394 
395         uint256[4] memory balances = EtherMium(exchangeContract).getMakerTakerBalances(t.baseToken, t.maker, t.taker);
396 
397         // Initializing trade values structure 
398         FuturesTradeValues memory tv = FuturesTradeValues({
399             qty                 : 0,
400             makerProfit         : 0,
401             makerLoss           : 0,
402             takerProfit         : 0,
403             takerLoss           : 0,
404             makerBalance        : balances[0], //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
405             takerBalance        : balances[1],  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
406             makerReserve        : balances[2],  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
407             takerReserve        : balances[3]  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
408         });
409 
410 //--> 60 000
411 
412 
413          
414 
415         // check if floor price or cap price was reached
416         if (futuresContracts[t.futuresContract].floorPrice >= t.makerPrice || futuresContracts[t.futuresContract].capPrice <= t.makerPrice)
417         {
418             // attepting price outside range
419             emit LogError(uint8(Errors.FLOOR_OR_CAP_PRICE_REACHED), t.makerOrderHash, t.takerOrderHash);
420             return 0;
421         }
422 
423         // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
424         // and open inverse positions
425         tv.qty = min(safeSub(t.makerAmount, orderFills[t.makerOrderHash]), safeSub(t.takerAmount, orderFills[t.takerOrderHash]));
426         
427         if (positionExists(t.makerInversePositionHash) && positionExists(t.takerInversePositionHash))
428         {
429             tv.qty = min(tv.qty, min(retrievePosition(t.makerInversePositionHash)[0], retrievePosition(t.takerInversePositionHash)[0]));
430         }
431         else if (positionExists(t.makerInversePositionHash))
432         {
433             tv.qty = min(tv.qty, retrievePosition(t.makerInversePositionHash)[0]);
434         }
435         else if (positionExists(t.takerInversePositionHash))
436         {
437             tv.qty = min(tv.qty, retrievePosition(t.takerInversePositionHash)[0]);
438         }
439 
440        
441 
442 
443 
444 //--> 64 000       
445         
446         if (tv.qty == 0)
447         {
448             // no qty left on orders
449             emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
450             return 0;
451         }
452 
453         // Cheks that gas fee is not higher than 10%
454         if (safeMul(t.takerGasFee, 20) > calculateTradeValue(tv.qty, t.makerPrice, t.futuresContract))
455         {
456             emit LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
457             return 0;
458         } // takerGasFee too high
459 
460 
461         // check if users have open positions already
462         // if (positionExists(t.makerPositionHash) || positionExists(t.takerPositionHash))
463         // {
464         //     // maker already has the position open, first must close existing position before opening a new one
465         //     emit LogError(uint8(Errors.POSITION_ALREADY_EXISTS), t.makerOrderHash, t.takerOrderHash);
466         //     return 0; 
467         // }
468 
469 //--> 66 000
470         
471 
472        
473 
474         /*------------- Maker long, Taker short -------------*/
475         if (!takerIsBuying)
476         {     
477             
478       
479             // position actions for maker
480             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
481             {
482 
483 
484                 // check if maker has enough balance   
485                 
486                 if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
487                 {
488                     // maker out of balance
489                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
490                     return 0; 
491                 }
492 
493                 
494                 
495                 // create new position
496                 recordNewPosition(t.makerPositionHash, tv.qty, t.makerPrice, 1, block.number);
497 
498 
499 
500                 updateBalances(
501                     t.futuresContract, 
502                     [
503                         t.baseToken, // base token
504                         t.maker // make address
505                     ], 
506                     t.makerPositionHash,  // position hash
507                     [
508                         tv.qty, // qty
509                         t.makerPrice,  // price
510                         makerFee, // fee
511                         0, // profit
512                         0, // loss
513                         tv.makerBalance, // balance
514                         0, // gasFee
515                         tv.makerReserve // reserve
516                     ], 
517                     [
518                         true, // newPostion (if true position is new)
519                         true, // side (if true - long)
520                         false // increase position (if true)
521                     ]
522                 );
523 
524             } else {               
525                 
526                 if (positionExists(t.makerPositionHash))
527                 {
528                     // check if maker has enough balance            
529                     // if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, 
530                     //     safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
531                     if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
532                     {
533                         // maker out of balance
534                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
535                         return 0; 
536                     }
537 
538                     // increase position size
539                     updatePositionSize(t.makerPositionHash, safeAdd(retrievePosition(t.makerPositionHash)[0], tv.qty), t.makerPrice);
540                 
541                     updateBalances(
542                         t.futuresContract, 
543                         [
544                             t.baseToken,  // base token
545                             t.maker // make address
546                         ], 
547                         t.makerPositionHash, // position hash
548                         [
549                             tv.qty, // qty
550                             t.makerPrice, // price
551                             makerFee, // fee
552                             0, // profit
553                             0, // loss
554                             tv.makerBalance, // balance
555                             0, // gasFee
556                             tv.makerReserve // reserve
557                         ], 
558                         [
559                             false, // newPostion (if true position is new)
560                             true, // side (if true - long)
561                             true // increase position (if true)
562                         ]
563                     );
564                 }
565                 else
566                 {
567 
568                     // close/partially close existing position
569                     updatePositionSize(t.makerInversePositionHash, safeSub(retrievePosition(t.makerInversePositionHash)[0], tv.qty), 0);
570                     
571                     
572 
573                     if (t.makerPrice < retrievePosition(t.makerInversePositionHash)[1])
574                     {
575                         // user has made a profit
576                         //tv.makerProfit                    = safeMul(safeSub(retrievePosition(t.makerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;
577                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);
578                     }
579                     else
580                     {
581                         // user has made a loss
582                         //tv.makerLoss                      = safeMul(safeSub(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1]), tv.qty) / t.makerPrice;    
583                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                        
584                     }
585 
586 
587 
588 
589                     updateBalances(
590                         t.futuresContract, 
591                         [
592                             t.baseToken, // base token
593                             t.maker // make address
594                         ], 
595                         t.makerInversePositionHash, // position hash
596                         [
597                             tv.qty, // qty
598                             t.makerPrice, // price
599                             makerFee, // fee
600                             tv.makerProfit,  // profit
601                             tv.makerLoss,  // loss
602                             tv.makerBalance, // balance
603                             0, // gasFee
604                             tv.makerReserve // reserve
605                         ], 
606                         [
607                             false, // newPostion (if true position is new)
608                             true, // side (if true - long)
609                             false // increase position (if true)
610                         ]
611                     );
612                 }                
613             }
614 
615            
616 
617 
618             // position actions for taker
619             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
620             {
621                 
622                 // check if taker has enough balance
623                 // if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether))  * 1e10, t.takerGasFee) > safeSub(balances[1],tv.takerReserve))
624                 if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
625                 {
626                     // maker out of balance
627                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
628                     return 0; 
629                 }
630                 
631                 // create new position
632                 recordNewPosition(t.takerPositionHash, tv.qty, t.makerPrice, 0, block.number);
633                 
634                 updateBalances(
635                     t.futuresContract, 
636                     [
637                         t.baseToken, // base token
638                         t.taker // make address
639                     ], 
640                     t.takerPositionHash, // position hash
641                     [
642                         tv.qty, // qty
643                         t.makerPrice,  // price
644                         takerFee, // fee
645                         0, // profit
646                         0,  // loss
647                         tv.takerBalance,  // balance
648                         t.takerGasFee, // gasFee
649                         tv.takerReserve // reserve
650                     ], 
651                     [
652                         true, // newPostion (if true position is new)
653                         false, // side (if true - long)
654                         false // increase position (if true)
655                     ]
656                 );
657 
658             } else {
659                 if (positionExists(t.takerPositionHash))
660                 {
661                     // check if taker has enough balance
662                     //if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether))  * 1e10, t.takerGasFee) > safeSub(balances[1],tv.takerReserve))
663                     if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
664                     {
665                         // maker out of balance
666                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
667                         return 0; 
668                     }
669 
670                     // increase position size
671                     updatePositionSize(t.takerPositionHash, safeAdd(retrievePosition(t.takerPositionHash)[0], tv.qty), t.makerPrice);
672                 
673                     updateBalances(
674                         t.futuresContract, 
675                         [
676                             t.baseToken,  // base token
677                             t.taker // make address
678                         ], 
679                         t.takerPositionHash, // position hash
680                         [
681                             tv.qty, // qty
682                             t.makerPrice, // price
683                             takerFee, // fee
684                             0, // profit
685                             0, // loss
686                             tv.takerBalance, // balance
687                             t.takerGasFee, // gasFee
688                             tv.takerReserve // reserve
689                         ], 
690                         [
691                             false, // newPostion (if true position is new)
692                             false, // side (if true - long)
693                             true // increase position (if true)
694                         ]
695                     );
696                 }
697                 else
698                 {   
699 
700 
701                      
702                    
703 
704                     // close/partially close existing position
705                     updatePositionSize(t.takerInversePositionHash, safeSub(retrievePosition(t.takerInversePositionHash)[0], tv.qty), 0);
706                     
707 
708 
709                     if (t.makerPrice > retrievePosition(t.takerInversePositionHash)[1])
710                     {
711                         // user has made a profit
712                         //tv.takerProfit                    = safeMul(safeSub(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1]), tv.qty) / t.makerPrice;
713                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false);
714                     }
715                     else
716                     {
717                         // user has made a loss
718                         //tv.takerLoss                      = safeMul(safeSub(retrievePosition(t.takerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;                                  
719                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false); 
720                     }
721 
722                   
723 
724                     updateBalances(
725                         t.futuresContract, 
726                         [
727                             t.baseToken, // base token
728                             t.taker // make address
729                         ], 
730                         t.takerInversePositionHash, // position hash
731                         [
732                             tv.qty, // qty
733                             t.makerPrice, // price
734                             takerFee, // fee
735                             tv.takerProfit, // profit
736                             tv.takerLoss, // loss
737                             tv.takerBalance,  // balance
738                             t.takerGasFee,  // gasFee
739                             tv.takerReserve // reserve
740                         ], 
741                         [
742                             false, // newPostion (if true position is new)
743                             false, // side (if true - long)
744                             false // increase position (if true)
745                         ]
746                     );
747                 }
748             }
749         }
750 
751 
752         /*------------- Maker short, Taker long -------------*/
753 
754         else
755         {      
756             //LogUint(1, safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty)); return;
757 
758             // position actions for maker
759             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
760             {
761                 // check if maker has enough balance
762                 //if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
763                 if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
764                 {
765                     // maker out of balance
766                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
767                     return 0; 
768                 }
769 
770                 // create new position
771                 recordNewPosition(t.makerPositionHash, tv.qty, t.makerPrice, 0, block.number);
772                 updateBalances(
773                     t.futuresContract, 
774                     [
775                         t.baseToken,   // base token
776                         t.maker // make address
777                     ], 
778                     t.makerPositionHash, // position hash
779                     [
780                         tv.qty, // qty
781                         t.makerPrice, // price
782                         makerFee, // fee
783                         0, // profit
784                         0, // loss
785                         tv.makerBalance, // balance
786                         0, // gasFee
787                         tv.makerReserve // reserve
788                     ], 
789                     [
790                         true, // newPostion (if true position is new)
791                         false, // side (if true - long)
792                         false // increase position (if true)
793                     ]
794                 );
795 
796             } else {
797                 if (positionExists(t.makerPositionHash))
798                 {
799                     // check if maker has enough balance
800                     //if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
801                     if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
802                     {
803                         // maker out of balance
804                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
805                         return 0; 
806                     }
807 
808                     // increase position size
809                     updatePositionSize(t.makerPositionHash, safeAdd(retrievePosition(t.makerPositionHash)[0], tv.qty), t.makerPrice);
810                 
811                     updateBalances(
812                         t.futuresContract, 
813                         [
814                             t.baseToken,  // base token
815                             t.maker // make address
816                         ], 
817                         t.makerPositionHash, // position hash
818                         [
819                             tv.qty, // qty
820                             t.makerPrice, // price
821                             makerFee, // fee
822                             0, // profit
823                             0, // loss
824                             tv.makerBalance, // balance
825                             0, // gasFee
826                             tv.makerReserve // reserve
827                         ], 
828                         [
829                             false, // newPostion (if true position is new)
830                             false, // side (if true - long)
831                             true // increase position (if true)
832                         ]
833                     );
834                 }
835                 else
836                 {
837 
838                     // close/partially close existing position
839                     updatePositionSize(t.makerInversePositionHash, safeSub(retrievePosition(t.makerInversePositionHash)[0], tv.qty), 0);       
840                     
841 
842 
843                     if (t.makerPrice > retrievePosition(t.makerInversePositionHash)[1])
844                     {
845                         // user has made a profit
846                         //tv.makerProfit                    = safeMul(safeSub(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1]), tv.qty) / t.makerPrice;
847                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);
848                     }
849                     else
850                     {
851                         // user has made a loss
852                         //tv.makerLoss                      = safeMul(safeSub(retrievePosition(t.makerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice; 
853                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);                               
854                     }
855 
856                    
857 
858                     updateBalances(
859                         t.futuresContract, 
860                         [
861                             t.baseToken, // base token
862                             t.maker // user address
863                         ], 
864                         t.makerInversePositionHash, // position hash
865                         [
866                             tv.qty, // qty
867                             t.makerPrice, // price
868                             makerFee, // fee
869                             tv.makerProfit,  // profit
870                             tv.makerLoss, // loss
871                             tv.makerBalance, // balance
872                             0, // gasFee
873                             tv.makerReserve // reserve
874                         ], 
875                         [
876                             false, // newPostion (if true position is new)
877                             false, // side (if true - long)
878                             false // increase position (if true)
879                         ]
880                     );
881                 }
882             }
883 
884             // position actions for taker
885             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
886             {
887                 // check if taker has enough balance
888                 // if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether)), t.takerGasFee / 1e10) * 1e10 > safeSub(balances[1],tv.takerReserve))
889                 if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
890                 {
891                     // maker out of balance
892                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
893                     return 0; 
894                 }
895 
896                 // create new position
897                 recordNewPosition(t.takerPositionHash, tv.qty, t.makerPrice, 1, block.number);
898            
899                 updateBalances(
900                     t.futuresContract, 
901                     [
902                         t.baseToken,  // base token
903                         t.taker // user address
904                     ], 
905                     t.takerPositionHash, // position hash
906                     [
907                         tv.qty, // qty
908                         t.makerPrice, // price
909                         takerFee, // fee
910                         0,  // profit
911                         0,  // loss
912                         tv.takerBalance, // balance
913                         t.takerGasFee, // gasFee
914                         tv.takerReserve // reserve
915                     ], 
916                     [
917                         true, // newPostion (if true position is new)
918                         true, // side (if true - long)
919                         false // increase position (if true)
920                     ]
921                 );
922 
923             } else {
924                 if (positionExists(t.takerPositionHash))
925                 {
926                     // check if taker has enough balance
927                     //if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether)), t.takerGasFee / 1e10) * 1e10 > safeSub(balances[1],tv.takerReserve))
928                     if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
929                     {
930                         // maker out of balance
931                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
932                         return 0; 
933                     }
934                     
935                     // increase position size
936                     updatePositionSize(t.takerPositionHash, safeAdd(retrievePosition(t.takerPositionHash)[0], tv.qty), t.makerPrice);
937                 
938                     updateBalances(
939                         t.futuresContract, 
940                         [
941                             t.baseToken,  // base token
942                             t.taker // user address
943                         ], 
944                         t.takerPositionHash, // position hash
945                         [
946                             tv.qty, // qty
947                             t.makerPrice, // price
948                             takerFee, // fee
949                             0, // profit
950                             0, // loss
951                             tv.takerBalance, // balance
952                             t.takerGasFee, // gasFee
953                             tv.takerReserve // reserve
954                         ], 
955                         [
956                             false, // newPostion (if true position is new)
957                             true, // side (if true - long)
958                             true // increase position (if true)
959                         ]
960                     );
961                 }
962                 else
963                 {
964 
965                     // close/partially close existing position
966                     updatePositionSize(t.takerInversePositionHash, safeSub(retrievePosition(t.takerInversePositionHash)[0], tv.qty), 0);
967                                      
968                     if (t.makerPrice < retrievePosition(t.takerInversePositionHash)[1])
969                     {
970                         // user has made a profit
971                         //tv.takerProfit                    = safeMul(safeSub(retrievePosition(t.takerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;
972                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);
973                     }
974                     else
975                     {
976                         // user has made a loss
977                         //tv.takerLoss                      = safeMul(safeSub(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1]), tv.qty) / t.makerPrice; 
978                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                  
979                     }
980 
981                     
982 
983                     updateBalances(
984                         t.futuresContract, 
985                         [
986                             t.baseToken,   // base toke
987                             t.taker // user address
988                         ], 
989                         t.takerInversePositionHash,  // position hash
990                         [
991                             tv.qty, // qty
992                             t.makerPrice, // price
993                             takerFee, // fee
994                             tv.takerProfit, // profit
995                             tv.takerLoss, // loss
996                             tv.takerBalance, // balance
997                             t.takerGasFee, // gasFee
998                             tv.takerReserve // reserve
999                         ], 
1000                         [
1001                             false, // newPostion (if true position is new)
1002                             true, // side (if true - long) 
1003                             false // increase position (if true)
1004                         ]
1005                     );
1006                 }
1007             }           
1008         }
1009 
1010 //--> 220 000
1011         orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty); // increase the maker order filled amount
1012         orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); // increase the taker order filled amount
1013 
1014 //--> 264 000
1015         emit FuturesTrade(takerIsBuying, tv.qty, t.makerPrice, t.futuresContract, t.makerOrderHash, t.takerOrderHash);
1016 
1017         return tv.qty;
1018     }
1019 
1020     function calculateProfit(uint256 closingPrice, uint256 entryPrice, uint256 qty, bytes32 futuresContractHash, bool side) returns (uint256)
1021     {
1022         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1023         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1024         if (side)
1025         {
1026             if (inversed)
1027             {
1028                 return safeMul(safeSub(entryPrice, closingPrice), qty) / closingPrice;  
1029             }
1030             else
1031             {
1032                 return safeMul(safeMul(safeSub(entryPrice, closingPrice), qty), multiplier)  / 1e8 / 1e18;
1033             }
1034             
1035         }
1036         else
1037         {
1038             if (inversed)
1039             {
1040                 return safeMul(safeSub(closingPrice, entryPrice), qty) / closingPrice; 
1041             }
1042             else
1043             {
1044                 return safeMul(safeMul(safeSub(closingPrice, entryPrice), qty), multiplier)  / 1e8 / 1e18; 
1045             }
1046         }
1047         
1048     }
1049 
1050     function calculateTradeValue(uint256 qty, uint256 price, bytes32 futuresContractHash) returns (uint256)
1051     {
1052         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1053         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1054         if (inversed)
1055         {
1056             return qty * 1e10;
1057         }
1058         else
1059         {
1060             return safeMul(safeMul(safeMul(qty, price), 1e2), multiplier) / 1e18 ;
1061         }
1062     }
1063 
1064 
1065 
1066     function calculateLoss(uint256 closingPrice, uint256 entryPrice, uint256 qty, bytes32 futuresContractHash, bool side) returns (uint256)
1067     {
1068         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1069         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1070         if (side)
1071         {
1072             if (inversed)
1073             {
1074                 return safeMul(safeSub(closingPrice, entryPrice), qty) / closingPrice;
1075             }
1076             else
1077             {
1078                 return safeMul(safeMul(safeSub(closingPrice, entryPrice), qty), multiplier) / 1e8 / 1e18;
1079             }
1080         }
1081         else
1082         {
1083             if (inversed)
1084             {
1085                 return safeMul(safeSub(entryPrice, closingPrice), qty) / closingPrice;
1086             }
1087             else
1088             {
1089                 return safeMul(safeMul(safeSub(entryPrice, closingPrice), qty), multiplier) / 1e8 / 1e18;
1090             } 
1091         }
1092         
1093     }
1094 
1095     function calculateCollateral (uint256 limitPrice, uint256 tradePrice, uint256 qty, bool side, bytes32 futuresContractHash) view returns (uint256)
1096     {
1097         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1098         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1099         if (side)
1100         {
1101             // long
1102             if (inversed)
1103             {
1104                 return safeMul(safeSub(tradePrice, limitPrice), qty) / limitPrice;
1105             }
1106             else
1107             {
1108                 return safeMul(safeMul(safeSub(tradePrice, limitPrice), qty), multiplier) / 1e8 / 1e18;
1109             }
1110         }
1111         else
1112         {
1113             // short
1114             if (inversed)
1115             {
1116                 return safeMul(safeSub(limitPrice, tradePrice), qty)  / limitPrice;
1117             }
1118             else
1119             {
1120                 return safeMul(safeMul(safeSub(limitPrice, tradePrice), qty), multiplier) / 1e8 / 1e18;
1121             }
1122         }       
1123     }
1124 
1125     function calculateFee (uint256 qty, uint256 tradePrice, uint256 fee,  bytes32 futuresContractHash) returns (uint256)
1126     {
1127         return safeMul(calculateTradeValue(qty, tradePrice, futuresContractHash), fee) / 1e18 / 1e10;
1128     }
1129 
1130 
1131     function checkEnoughBalance (uint256 limitPrice, uint256 tradePrice, uint256 qty, bool side, uint256 fee, uint256 gasFee, bytes32 futuresContractHash, uint256 availableBalance) view returns (bool)
1132     {
1133         if (side)
1134         {
1135             // long
1136             if (safeAdd(
1137                     safeAdd(
1138                         calculateCollateral(limitPrice, tradePrice, qty, side, futuresContractHash), 
1139                         //safeMul(qty, fee) / (1 ether)
1140                         calculateFee(qty, tradePrice, fee, futuresContractHash)
1141                     ) * 1e10,
1142                     gasFee 
1143                 ) > availableBalance)
1144             {
1145                 return false; 
1146             }
1147         }
1148         else
1149         {
1150             // short
1151             if (safeAdd(
1152                     safeAdd(
1153                         calculateCollateral(limitPrice, tradePrice, qty, side, futuresContractHash), 
1154                         //safeMul(qty, fee) / (1 ether)
1155                         calculateFee(qty, tradePrice, fee, futuresContractHash)
1156                     ) * 1e10, 
1157                     gasFee 
1158                 ) > availableBalance)
1159             {
1160                 return false;
1161             }
1162 
1163         }
1164 
1165         return true;
1166        
1167     }    
1168 
1169     // Executes multiple trades in one transaction, saves gas fees
1170     function batchFuturesTrade(
1171         uint8[2][] v,
1172         bytes32[4][] rs,
1173         uint256[8][] tradeValues,
1174         address[2][] tradeAddresses,
1175         bool[] takerIsBuying,
1176         bytes32[] assetHash,
1177         uint256[4][] contractValues
1178     ) onlyAdmin
1179     {
1180 
1181         /** contractValues
1182             [0] expirationBlock
1183             [1] floorPrice
1184             [2] capPrice
1185             [3] multiplier
1186         **/
1187         
1188         for (uint i = 0; i < tradeAddresses.length; i++) {
1189             futuresTrade(
1190                 v[i],
1191                 rs[i],
1192                 tradeValues[i],
1193                 tradeAddresses[i],
1194                 takerIsBuying[i],
1195                 createFuturesContract(assetHash[i], contractValues[i][0], contractValues[i][1], contractValues[i][2], contractValues[i][3])
1196             );
1197         }
1198     }
1199 
1200 
1201     // Update user balance
1202     function updateBalances (bytes32 futuresContract, address[2] addressValues, bytes32 positionHash, uint256[8] uintValues, bool[3] boolValues) private
1203     {
1204         /*
1205             addressValues
1206             [0] baseToken
1207             [1] user
1208 
1209             uintValues
1210             [0] qty
1211             [1] price
1212             [2] fee
1213             [3] profit
1214             [4] loss
1215             [5] balance
1216             [6] gasFee
1217             [7] reserve
1218 
1219             boolValues
1220             [0] newPostion
1221             [1] side
1222             [2] increase position
1223 
1224         */
1225 
1226         //                          qty * price * fee
1227         // uint256 pam[0] = safeMul(safeMul(uintValues[0], uintValues[1]), uintValues[2]) / (1 ether);
1228         // uint256 collateral;  
1229 
1230 
1231         // pam = [fee value, collateral]                        
1232         uint256[2] memory pam = [safeAdd(calculateFee(uintValues[0], uintValues[1], uintValues[2], futuresContract) * 1e10, uintValues[6]), 0];
1233         
1234         // LogUint(100, uintValues[3]);
1235         // LogUint(9, uintValues[2]);
1236         // LogUint(7, safeMul(uintValues[0], uintValues[2])  / (1 ether));
1237         // return;
1238 
1239         
1240 
1241         // Position is new or position is increased
1242         if (boolValues[0] || boolValues[2])  
1243         {
1244 
1245             if (boolValues[1])
1246             {
1247 
1248                 //addReserve(addressValues[0], addressValues[1], uintValues[ 7], safeMul(safeSub(uintValues[1], futuresContracts[futuresContract].floorPrice), uintValues[0])); // reserve collateral on user
1249                 //pam[1] = safeMul(safeSub(uintValues[1], futuresContracts[futuresContract].floorPrice), uintValues[0]) / futuresContracts[futuresContract].floorPrice;
1250                 pam[1] = calculateCollateral(futuresContracts[futuresContract].floorPrice, uintValues[1], uintValues[0], true, futuresContract);
1251 
1252             }
1253             else
1254             {
1255                 //addReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(safeSub(futuresContracts[futuresContract].capPrice, uintValues[1]), uintValues[0])); // reserve collateral on user
1256                 //pam[1] = safeMul(safeSub(futuresContracts[futuresContract].capPrice, uintValues[1]), uintValues[0]) / futuresContracts[futuresContract].capPrice;
1257                 pam[1] = calculateCollateral(futuresContracts[futuresContract].capPrice, uintValues[1], uintValues[0], false, futuresContract);
1258             }
1259 
1260             subBalanceAddReserve(addressValues[0], addressValues[1], pam[0], safeAdd(pam[1],1));         
1261 
1262             // if (uintValues[6] > 0)
1263             // {   
1264             //     subBalanceAddReserve(addressValues[0], addressValues[1], safeAdd(uintValues[6], pam[0]), pam[1]);                  
1265                               
1266             // }
1267             // else
1268             // {
1269 
1270             //    subBalanceAddReserve(addressValues[0], addressValues[1], safeAdd(uintValues[6], pam[0]), pam[1]);                 
1271             // }
1272 
1273 
1274             //subBalance(addressValues[0], addressValues[1], uintValues[5], feeVal); // deduct user maker/taker fee 
1275 
1276             
1277         // Position exists
1278         } 
1279         else 
1280         {
1281             if (retrievePosition(positionHash)[2] == 0)
1282             {
1283                 // original position was short
1284                 //subReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(uintValues[0], safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]))); // remove freed collateral from reserver
1285                 //pam[1] = safeMul(uintValues[0], safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1])) / futuresContracts[futuresContract].capPrice;
1286                 pam[1] = calculateCollateral(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1], uintValues[0], false, futuresContract);
1287 
1288                 // LogUint(120, uintValues[0]);
1289                 // LogUint(121, futuresContracts[futuresContract].capPrice);
1290                 // LogUint(122, retrievePosition(positionHash)[1]);
1291                 // LogUint(123, uintValues[3]); // profit
1292                 // LogUint(124, uintValues[4]); // loss
1293                 // LogUint(125, safeAdd(uintValues[4], pam[0]));
1294                 // LogUint(12, pam[1] );
1295                 //return;
1296             }
1297             else
1298             {       
1299                        
1300                 // original position was long
1301                 //subReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(uintValues[0], safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice)));
1302                 //pam[1] = safeMul(uintValues[0], safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice)) / futuresContracts[futuresContract].floorPrice;
1303                 pam[1] = calculateCollateral(futuresContracts[futuresContract].floorPrice, retrievePosition(positionHash)[1], uintValues[0], true, futuresContract);
1304 
1305             }
1306 
1307 
1308                 // LogUint(41, uintValues[3]);
1309                 // LogUint(42, uintValues[4]);
1310                 // LogUint(43, pam[0]);
1311                 // return;  
1312             if (uintValues[3] > 0) 
1313             {
1314                 // profi > 0
1315 
1316                 if (pam[0] <= uintValues[3]*1e10)
1317                 {
1318                     //addBalance(addressValues[0], addressValues[1], uintValues[5], safeSub(uintValues[3], pam[0])); // add profit to user balance
1319                     addBalanceSubReserve(addressValues[0], addressValues[1], safeSub(uintValues[3]*1e10, pam[0]), pam[1]);
1320                 }
1321                 else
1322                 {
1323                     subBalanceSubReserve(addressValues[0], addressValues[1], safeSub(pam[0], uintValues[3]*1e10), pam[1]);
1324                 }
1325                 
1326             } 
1327             else 
1328             {   
1329                 
1330 
1331                 // loss >= 0
1332                 //subBalance(addressValues[0], addressValues[1], uintValues[5], safeAdd(uintValues[4], pam[0])); // deduct loss from user balance 
1333                 subBalanceSubReserve(addressValues[0], addressValues[1], safeAdd(uintValues[4]*1e10, pam[0]), pam[1]); // deduct loss from user balance
1334            
1335             } 
1336             //}            
1337         }          
1338         
1339         addBalance(addressValues[0], feeAccount, EtherMium(exchangeContract).balanceOf(addressValues[0], feeAccount), pam[0]); // send fee to feeAccount
1340     }
1341 
1342     function recordNewPosition (bytes32 positionHash, uint256 size, uint256 price, uint256 side, uint256 block) private
1343     {
1344         if (!validateUint128(size) || !validateUint64(price)) 
1345         {
1346             throw;
1347         }
1348 
1349         uint256 character = uint128(size);
1350         character |= price<<128;
1351         character |= side<<192;
1352         character |= block<<208;
1353 
1354         positions[positionHash] = character;
1355     }
1356 
1357     function retrievePosition (bytes32 positionHash) public view returns (uint256[4])
1358     {
1359         uint256 character = positions[positionHash];
1360         uint256 size = uint256(uint128(character));
1361         uint256 price = uint256(uint64(character>>128));
1362         uint256 side = uint256(uint16(character>>192));
1363         uint256 entryBlock = uint256(uint48(character>>208));
1364 
1365         return [size, price, side, entryBlock];
1366     }
1367 
1368     function updatePositionSize(bytes32 positionHash, uint256 size, uint256 price) private
1369     {
1370         uint256[4] memory pos = retrievePosition(positionHash);
1371 
1372         if (size > pos[0])
1373         {
1374             // position is increasing in size
1375             recordNewPosition(positionHash, size, safeAdd(safeMul(pos[0], pos[1]), safeMul(price, safeSub(size, pos[0]))) / size, pos[2], pos[3]);
1376         }
1377         else
1378         {
1379             // position is decreasing in size
1380             recordNewPosition(positionHash, size, pos[1], pos[2], pos[3]);
1381         }        
1382     }
1383 
1384     function positionExists (bytes32 positionHash) internal view returns (bool)
1385     {
1386         //LogUint(3,retrievePosition(positionHash)[0]);
1387         if (retrievePosition(positionHash)[0] == 0)
1388         {
1389             return false;
1390         }
1391         else
1392         {
1393             return true;
1394         }
1395     }
1396 
1397     // This function allows the user to manually release collateral in case the oracle service does not provide the price during the inactivityReleasePeriod
1398     function forceReleaseReserve (bytes32 futuresContract, bool side) public
1399     {   
1400         if (futuresContracts[futuresContract].expirationBlock == 0) throw;       
1401         if (futuresContracts[futuresContract].expirationBlock > block.number) throw;
1402         if (safeAdd(futuresContracts[futuresContract].expirationBlock, EtherMium(exchangeContract).getInactivityReleasePeriod()) > block.number) throw;  
1403 
1404         bytes32 positionHash = keccak256(this, msg.sender, futuresContract, side);
1405         if (retrievePosition(positionHash)[1] == 0) throw;    
1406   
1407 
1408         futuresContracts[futuresContract].broken = true;
1409 
1410         address baseToken = futuresAssets[futuresContracts[futuresContract].asset].baseToken;
1411 
1412         if (side)
1413         {
1414             subReserve(
1415                 baseToken, 
1416                 msg.sender, 
1417                 EtherMium(exchangeContract).getReserve(baseToken, msg.sender), 
1418                 //safeMul(safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].floorPrice
1419                 calculateCollateral(futuresContracts[futuresContract].floorPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], true, futuresContract)
1420             ); 
1421         }
1422         else
1423         {            
1424             subReserve(
1425                 baseToken, 
1426                 msg.sender, 
1427                 EtherMium(exchangeContract).getReserve(baseToken, msg.sender), 
1428                 //safeMul(safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].capPrice
1429                 calculateCollateral(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], false, futuresContract)
1430             ); 
1431         }
1432 
1433         updatePositionSize(positionHash, 0, 0);
1434 
1435         //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), );
1436         //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], positions[msg.sender][positionHash].collateral);
1437 
1438         emit FuturesForcedRelease(futuresContract, side, msg.sender);
1439 
1440     }
1441 
1442     function addBalance(address token, address user, uint256 balance, uint256 amount) private
1443     {
1444         EtherMium(exchangeContract).setBalance(token, user, safeAdd(balance, amount));
1445     }
1446 
1447     function subBalance(address token, address user, uint256 balance, uint256 amount) private
1448     {
1449         EtherMium(exchangeContract).setBalance(token, user, safeSub(balance, amount));
1450     }
1451 
1452     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) private
1453     {
1454         EtherMium(exchangeContract).subBalanceAddReserve(token, user, subBalance, addReserve * 1e10);
1455     }
1456 
1457     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) private
1458     {
1459 
1460         EtherMium(exchangeContract).addBalanceSubReserve(token, user, addBalance, subReserve * 1e10);
1461     }
1462 
1463     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) private
1464     {
1465         // LogUint(31, subBalance);
1466         // LogUint(32, subReserve);
1467         // return;
1468 
1469         EtherMium(exchangeContract).subBalanceSubReserve(token, user, subBalance, subReserve * 1e10);
1470     }
1471 
1472     function addReserve(address token, address user, uint256 reserve, uint256 amount) private
1473     {
1474         //reserve[token][user] = safeAdd(reserve[token][user], amount);
1475         EtherMium(exchangeContract).setReserve(token, user, safeAdd(reserve, amount * 1e10));
1476     }
1477 
1478     function subReserve(address token, address user, uint256 reserve, uint256 amount) private 
1479     {
1480         //reserve[token][user] = safeSub(reserve[token][user], amount);
1481         EtherMium(exchangeContract).setReserve(token, user, safeSub(reserve, amount * 1e10));
1482     }
1483 
1484 
1485     function getMakerTakerBalances(address maker, address taker, address token) public view returns (uint256[4])
1486     {
1487         return [
1488             EtherMium(exchangeContract).balanceOf(token, maker),
1489             EtherMium(exchangeContract).getReserve(token, maker),
1490             EtherMium(exchangeContract).balanceOf(token, taker),
1491             EtherMium(exchangeContract).getReserve(token, taker)
1492         ];
1493     }
1494 
1495     function getMakerTakerPositions(bytes32 makerPositionHash, bytes32 makerInversePositionHash, bytes32 takerPosition, bytes32 takerInversePosition) public view returns (uint256[4][4])
1496     {
1497         return [
1498             retrievePosition(makerPositionHash),
1499             retrievePosition(makerInversePositionHash),
1500             retrievePosition(takerPosition),
1501             retrievePosition(takerInversePosition)
1502         ];
1503     }
1504 
1505 
1506     struct FuturesClosePositionValues {
1507         uint256 reserve;                // amount to be trade
1508         uint256 balance;        // holds maker profit value
1509         uint256 floorPrice;          // holds maker loss value
1510         uint256 capPrice;        // holds taker profit value
1511         uint256 closingPrice;          // holds taker loss value
1512         bytes32 futuresContract; // the futures contract hash
1513     }
1514 
1515 
1516     function closeFuturesPosition (bytes32 futuresContract, bool side)
1517     {
1518         bytes32 positionHash = keccak256(this, msg.sender, futuresContract, side);
1519 
1520         if (futuresContracts[futuresContract].closed == false && futuresContracts[futuresContract].expirationBlock != 0) throw; // contract not yet settled
1521         if (retrievePosition(positionHash)[1] == 0) throw; // position not found
1522         if (retrievePosition(positionHash)[0] == 0) throw; // position already closed
1523 
1524         uint256 profit;
1525         uint256 loss;
1526 
1527         address baseToken = futuresAssets[futuresContracts[futuresContract].asset].baseToken;
1528 
1529         FuturesClosePositionValues memory v = FuturesClosePositionValues({
1530             reserve         : EtherMium(exchangeContract).getReserve(baseToken, msg.sender),
1531             balance         : EtherMium(exchangeContract).balanceOf(baseToken, msg.sender),
1532             floorPrice      : futuresContracts[futuresContract].floorPrice,
1533             capPrice        : futuresContracts[futuresContract].capPrice,
1534             closingPrice    : futuresContracts[futuresContract].closingPrice,
1535             futuresContract : futuresContract
1536         });
1537 
1538         // uint256 reserve = EtherMium(exchangeContract).getReserve(baseToken, msg.sender);
1539         // uint256 balance = EtherMium(exchangeContract).balanceOf(baseToken, msg.sender);
1540         // uint256 floorPrice = futuresContracts[futuresContract].floorPrice;
1541         // uint256 capPrice = futuresContracts[futuresContract].capPrice;
1542         // uint256 closingPrice =  futuresContracts[futuresContract].closingPrice;
1543 
1544 
1545         
1546         //uint256 fee = safeMul(safeMul(retrievePosition(positionHash)[0], v.closingPrice), takerFee) / (1 ether);
1547         uint256 fee = calculateFee(retrievePosition(positionHash)[0], v.closingPrice, takerFee, futuresContract);
1548 
1549 
1550 
1551         // close long position
1552         if (side == true)
1553         {            
1554 
1555             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1556             // LogUint(12, safeMul(safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].floorPrice);
1557             // return;
1558             // reserve = reserve - (entryPrice - floorPrice) * size;
1559             //subReserve(baseToken, msg.sender, EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[positionHash].size));
1560             
1561             
1562             subReserve(
1563                 baseToken, 
1564                 msg.sender, 
1565                 v.reserve, 
1566                 //safeMul(safeSub(retrievePosition(positionHash)[1], v.floorPrice), retrievePosition(positionHash)[0]) / v.floorPrice
1567                 calculateCollateral(v.floorPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], true, v.futuresContract)
1568             );
1569             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1570             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1571             
1572             
1573 
1574             if (v.closingPrice > retrievePosition(positionHash)[1])
1575             {
1576                 // user made a profit
1577                 //profit = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1578                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);
1579                 
1580 
1581 
1582                 // LogUint(15, profit);
1583                 // LogUint(16, fee);
1584                 // LogUint(17, safeSub(profit * 1e10, fee));
1585                 // return;
1586 
1587                 addBalance(baseToken, msg.sender, v.balance, safeSub(profit * 1e10, fee * 1e10));
1588                 //EtherMium(exchangeContract).updateBalance(baseToken, msg.sender, safeAdd(EtherMium(exchangeContract).balanceOf(baseToken, msg.sender), profit);
1589                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1590             }
1591             else
1592             {
1593                 // user made a loss
1594                 //loss = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1595                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);  
1596 
1597 
1598                 subBalance(baseToken, msg.sender, v.balance, safeAdd(loss * 1e10, fee * 1e10));
1599                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1600             }
1601         }   
1602         // close short position 
1603         else
1604         {
1605             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1606             // LogUint(12, safeMul(safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].capPrice);
1607             // return;
1608 
1609             // reserve = reserve - (capPrice - entryPrice) * size;
1610             subReserve(
1611                 baseToken, 
1612                 msg.sender,  
1613                 v.reserve, 
1614                 //safeMul(safeSub(v.capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.capPrice
1615                 calculateCollateral(v.capPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], false, v.futuresContract)
1616             );
1617             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1618             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1619             
1620             
1621 
1622             if (v.closingPrice < retrievePosition(positionHash)[1])
1623             {
1624                 // user made a profit
1625                 // profit = (entryPrice - closingPrice) * size
1626                 // profit = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1627                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);
1628 
1629                 addBalance(baseToken, msg.sender, v.balance, safeSub(profit * 1e10, fee * 1e10));
1630 
1631                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1632             }
1633             else
1634             {
1635                 // user made a loss
1636                 // profit = (closingPrice - entryPrice) * size
1637                 //loss = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1638                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);  
1639 
1640                 subBalance(baseToken, msg.sender, v.balance, safeAdd(loss * 1e10, fee * 1e10));
1641 
1642                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1643             }
1644         }  
1645 
1646         addBalance(baseToken, feeAccount, EtherMium(exchangeContract).balanceOf(baseToken, feeAccount), fee * 1e10); // send fee to feeAccount
1647         updatePositionSize(positionHash, 0, 0);
1648     }
1649 
1650     /*
1651         string priceUrl;                // the url where the price of the asset will be taken for settlement
1652         string pricePath;               // price path in the returned JSON from the priceUrl (ex. path "last" will return tha value last from the json: {"high": "156.49", "last": "154.31", "timestamp": "1556522201", "bid": "154.22", "vwap": "154.65", "volume": "25578.79138868", "low": "152.33", "ask": "154.26", "open": "152.99"})
1653         bool multiplied;                // if true, the price from the priceUrl will be multiplied by the multiplierPriceUrl
1654         string multiplierPriceUrl;      // needed only if multiplied=true
1655         string multiplierPricePath;     // same as pricePath 
1656         bool inverseMultiplier; 
1657     */
1658 
1659 
1660     function closeFuturesContract (bytes32 futuresContract, uint256 price, uint256 multipliterPrice) onlyAdmin
1661     {
1662         uint256 closingPrice = price;
1663 
1664         if (futuresContracts[futuresContract].expirationBlock == 0) throw; // contract not found
1665         if (futuresContracts[futuresContract].closed == true) throw; // contract already closed
1666         if (futuresContracts[futuresContract].expirationBlock > block.number 
1667             && closingPrice > futuresContracts[futuresContract].floorPrice
1668             && closingPrice < futuresContracts[futuresContract].capPrice) throw; // contract not yet expired
1669         futuresContracts[futuresContract].closingPrice = closingPrice;
1670         futuresContracts[futuresContract].closed = true;
1671 
1672         emit FuturesContractClosed(futuresContract, closingPrice);
1673     }
1674 
1675     
1676 
1677     // Returns the smaller of two values
1678     function min(uint a, uint b) private pure returns (uint) {
1679         return a < b ? a : b;
1680     }
1681 }