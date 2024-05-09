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
142         if (futuresContracts[futuresContract].expirationBlock > 0) throw; // contract already exists
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
303 
304         /* tradeValues
305           [0] makerNonce
306           [1] takerNonce
307           [2] takerGasFee
308           [3] takerIsBuying
309           [4] makerAmount
310           [5] takerAmount
311           [6] makerPrice
312           [7] takerPrice
313 
314 
315           tradeAddresses
316           [0] maker
317           [1] taker
318         */
319 
320         FuturesOrderPair memory t  = FuturesOrderPair({
321             makerNonce      : tradeValues[0],
322             takerNonce      : tradeValues[1],
323             takerGasFee     : tradeValues[2],
324             takerIsBuying   : tradeValues[3],
325             makerAmount     : tradeValues[4],      
326             takerAmount     : tradeValues[5],   
327             makerPrice      : tradeValues[6],         
328             takerPrice      : tradeValues[7],
329 
330             maker           : tradeAddresses[0],
331             taker           : tradeAddresses[1],
332 
333             //                                futuresContract      user               amount          price           side             nonce
334             makerOrderHash  : keccak256(this, futuresContractHash, tradeAddresses[0], tradeValues[4], tradeValues[6], !takerIsBuying, tradeValues[0]),
335             takerOrderHash  : keccak256(this, futuresContractHash, tradeAddresses[1], tradeValues[5], tradeValues[7],  takerIsBuying, tradeValues[1]),            
336 
337             futuresContract : futuresContractHash,
338 
339             baseToken       : futuresAssets[futuresContracts[futuresContractHash].asset].baseToken,
340             floorPrice      : futuresContracts[futuresContractHash].floorPrice,
341             capPrice        : futuresContracts[futuresContractHash].capPrice,
342 
343             //                                            user               futuresContractHash   side
344             makerPositionHash           : keccak256(this, tradeAddresses[0], futuresContractHash, !takerIsBuying),
345             makerInversePositionHash    : keccak256(this, tradeAddresses[0], futuresContractHash, takerIsBuying),
346 
347             takerPositionHash           : keccak256(this, tradeAddresses[1], futuresContractHash, takerIsBuying),
348             takerInversePositionHash    : keccak256(this, tradeAddresses[1], futuresContractHash, !takerIsBuying)
349 
350         });
351 
352 //--> 44 000
353     
354         // Valifate size and price values
355         if (!validateUint128(t.makerAmount) || !validateUint128(t.takerAmount) || !validateUint64(t.makerPrice) || !validateUint64(t.takerPrice))
356         {            
357             emit LogError(uint8(Errors.UINT48_VALIDATION), t.makerOrderHash, t.takerOrderHash);
358             return 0; 
359         }
360 
361 
362         // Check if futures contract has expired already
363         if (block.number > futuresContracts[t.futuresContract].expirationBlock || futuresContracts[t.futuresContract].closed == true || futuresContracts[t.futuresContract].broken == true)
364         {
365             emit LogError(uint8(Errors.FUTURES_CONTRACT_EXPIRED), t.makerOrderHash, t.takerOrderHash);
366             return 0; // futures contract is expired
367         }
368 
369         // Checks the signature for the maker order
370         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
371         {
372             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
373             return 0;
374         }
375        
376         // Checks the signature for the taker order
377         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
378         {
379             emit LogError(uint8(Errors.INVALID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
380             return 0;
381         }
382 
383 
384 
385         // check prices
386         if ((!takerIsBuying && t.makerPrice < t.takerPrice) || (takerIsBuying && t.takerPrice < t.makerPrice))
387         {
388             emit LogError(uint8(Errors.INVALID_PRICE), t.makerOrderHash, t.takerOrderHash);
389             return 0; // prices don't match
390         }      
391 
392 //--> 54 000
393 
394          
395         
396 
397         uint256[4] memory balances = EtherMium(exchangeContract).getMakerTakerBalances(t.baseToken, t.maker, t.taker);
398 
399         // Initializing trade values structure 
400         FuturesTradeValues memory tv = FuturesTradeValues({
401             qty                 : 0,
402             makerProfit         : 0,
403             makerLoss           : 0,
404             takerProfit         : 0,
405             takerLoss           : 0,
406             makerBalance        : balances[0], //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
407             takerBalance        : balances[1],  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
408             makerReserve        : balances[2],  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
409             takerReserve        : balances[3]  //EtherMium(exchangeContract).balanceOf(t.baseToken, t.maker),
410         });
411 
412 //--> 60 000
413 
414 
415          
416 
417         // check if floor price or cap price was reached
418         if (futuresContracts[t.futuresContract].floorPrice >= t.makerPrice || futuresContracts[t.futuresContract].capPrice <= t.makerPrice)
419         {
420             // attepting price outside range
421             emit LogError(uint8(Errors.FLOOR_OR_CAP_PRICE_REACHED), t.makerOrderHash, t.takerOrderHash);
422             return 0;
423         }
424 
425         // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
426         // and open inverse positions
427         tv.qty = min(safeSub(t.makerAmount, orderFills[t.makerOrderHash]), safeSub(t.takerAmount, orderFills[t.takerOrderHash]));
428         
429         if (positionExists(t.makerInversePositionHash) && positionExists(t.takerInversePositionHash))
430         {
431             tv.qty = min(tv.qty, min(retrievePosition(t.makerInversePositionHash)[0], retrievePosition(t.takerInversePositionHash)[0]));
432         }
433         else if (positionExists(t.makerInversePositionHash))
434         {
435             tv.qty = min(tv.qty, retrievePosition(t.makerInversePositionHash)[0]);
436         }
437         else if (positionExists(t.takerInversePositionHash))
438         {
439             tv.qty = min(tv.qty, retrievePosition(t.takerInversePositionHash)[0]);
440         }
441 
442        
443 
444 
445 
446 //--> 64 000       
447         
448         if (tv.qty == 0)
449         {
450             // no qty left on orders
451             emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
452             return 0;
453         }
454 
455         // Cheks that gas fee is not higher than 10%
456         if (safeMul(t.takerGasFee, 20) > calculateTradeValue(tv.qty, t.makerPrice, t.futuresContract))
457         {
458             emit LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
459             return 0;
460         } // takerGasFee too high
461 
462 
463         // check if users have open positions already
464         // if (positionExists(t.makerPositionHash) || positionExists(t.takerPositionHash))
465         // {
466         //     // maker already has the position open, first must close existing position before opening a new one
467         //     emit LogError(uint8(Errors.POSITION_ALREADY_EXISTS), t.makerOrderHash, t.takerOrderHash);
468         //     return 0; 
469         // }
470 
471 //--> 66 000
472         
473 
474        
475 
476         /*------------- Maker long, Taker short -------------*/
477         if (!takerIsBuying)
478         {     
479             
480       
481             // position actions for maker
482             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
483             {
484 
485 
486                 // check if maker has enough balance   
487                 
488                 if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
489                 {
490                     // maker out of balance
491                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
492                     return 0; 
493                 }
494 
495                 
496                 
497                 // create new position
498                 recordNewPosition(t.makerPositionHash, tv.qty, t.makerPrice, 1, block.number);
499 
500 
501 
502                 updateBalances(
503                     t.futuresContract, 
504                     [
505                         t.baseToken, // base token
506                         t.maker // make address
507                     ], 
508                     t.makerPositionHash,  // position hash
509                     [
510                         tv.qty, // qty
511                         t.makerPrice,  // price
512                         makerFee, // fee
513                         0, // profit
514                         0, // loss
515                         tv.makerBalance, // balance
516                         0, // gasFee
517                         tv.makerReserve // reserve
518                     ], 
519                     [
520                         true, // newPostion (if true position is new)
521                         true, // side (if true - long)
522                         false // increase position (if true)
523                     ]
524                 );
525 
526             } else {               
527                 
528                 if (positionExists(t.makerPositionHash))
529                 {
530                     // check if maker has enough balance            
531                     // if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, 
532                     //     safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
533                     if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
534                     {
535                         // maker out of balance
536                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
537                         return 0; 
538                     }
539 
540                     // increase position size
541                     updatePositionSize(t.makerPositionHash, safeAdd(retrievePosition(t.makerPositionHash)[0], tv.qty), t.makerPrice);
542                 
543                     updateBalances(
544                         t.futuresContract, 
545                         [
546                             t.baseToken,  // base token
547                             t.maker // make address
548                         ], 
549                         t.makerPositionHash, // position hash
550                         [
551                             tv.qty, // qty
552                             t.makerPrice, // price
553                             makerFee, // fee
554                             0, // profit
555                             0, // loss
556                             tv.makerBalance, // balance
557                             0, // gasFee
558                             tv.makerReserve // reserve
559                         ], 
560                         [
561                             false, // newPostion (if true position is new)
562                             true, // side (if true - long)
563                             true // increase position (if true)
564                         ]
565                     );
566                 }
567                 else
568                 {
569 
570                     // close/partially close existing position
571                     updatePositionSize(t.makerInversePositionHash, safeSub(retrievePosition(t.makerInversePositionHash)[0], tv.qty), 0);
572                     
573                     
574 
575                     if (t.makerPrice < retrievePosition(t.makerInversePositionHash)[1])
576                     {
577                         // user has made a profit
578                         //tv.makerProfit                    = safeMul(safeSub(retrievePosition(t.makerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;
579                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);
580                     }
581                     else
582                     {
583                         // user has made a loss
584                         //tv.makerLoss                      = safeMul(safeSub(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1]), tv.qty) / t.makerPrice;    
585                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                        
586                     }
587 
588 
589 
590 
591                     updateBalances(
592                         t.futuresContract, 
593                         [
594                             t.baseToken, // base token
595                             t.maker // make address
596                         ], 
597                         t.makerInversePositionHash, // position hash
598                         [
599                             tv.qty, // qty
600                             t.makerPrice, // price
601                             makerFee, // fee
602                             tv.makerProfit,  // profit
603                             tv.makerLoss,  // loss
604                             tv.makerBalance, // balance
605                             0, // gasFee
606                             tv.makerReserve // reserve
607                         ], 
608                         [
609                             false, // newPostion (if true position is new)
610                             true, // side (if true - long)
611                             false // increase position (if true)
612                         ]
613                     );
614                 }                
615             }
616 
617            
618 
619 
620             // position actions for taker
621             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
622             {
623                 
624                 // check if taker has enough balance
625                 // if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether))  * 1e10, t.takerGasFee) > safeSub(balances[1],tv.takerReserve))
626                 if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
627                 {
628                     // maker out of balance
629                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
630                     return 0; 
631                 }
632                 
633                 // create new position
634                 recordNewPosition(t.takerPositionHash, tv.qty, t.makerPrice, 0, block.number);
635                 
636                 updateBalances(
637                     t.futuresContract, 
638                     [
639                         t.baseToken, // base token
640                         t.taker // make address
641                     ], 
642                     t.takerPositionHash, // position hash
643                     [
644                         tv.qty, // qty
645                         t.makerPrice,  // price
646                         takerFee, // fee
647                         0, // profit
648                         0,  // loss
649                         tv.takerBalance,  // balance
650                         t.takerGasFee, // gasFee
651                         tv.takerReserve // reserve
652                     ], 
653                     [
654                         true, // newPostion (if true position is new)
655                         false, // side (if true - long)
656                         false // increase position (if true)
657                     ]
658                 );
659 
660             } else {
661                 if (positionExists(t.takerPositionHash))
662                 {
663                     // check if taker has enough balance
664                     //if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether))  * 1e10, t.takerGasFee) > safeSub(balances[1],tv.takerReserve))
665                     if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
666                     {
667                         // maker out of balance
668                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
669                         return 0; 
670                     }
671 
672                     // increase position size
673                     updatePositionSize(t.takerPositionHash, safeAdd(retrievePosition(t.takerPositionHash)[0], tv.qty), t.makerPrice);
674                 
675                     updateBalances(
676                         t.futuresContract, 
677                         [
678                             t.baseToken,  // base token
679                             t.taker // make address
680                         ], 
681                         t.takerPositionHash, // position hash
682                         [
683                             tv.qty, // qty
684                             t.makerPrice, // price
685                             takerFee, // fee
686                             0, // profit
687                             0, // loss
688                             tv.takerBalance, // balance
689                             t.takerGasFee, // gasFee
690                             tv.takerReserve // reserve
691                         ], 
692                         [
693                             false, // newPostion (if true position is new)
694                             false, // side (if true - long)
695                             true // increase position (if true)
696                         ]
697                     );
698                 }
699                 else
700                 {   
701 
702 
703                      
704                    
705 
706                     // close/partially close existing position
707                     updatePositionSize(t.takerInversePositionHash, safeSub(retrievePosition(t.takerInversePositionHash)[0], tv.qty), 0);
708                     
709 
710 
711                     if (t.makerPrice > retrievePosition(t.takerInversePositionHash)[1])
712                     {
713                         // user has made a profit
714                         //tv.takerProfit                    = safeMul(safeSub(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1]), tv.qty) / t.makerPrice;
715                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false);
716                     }
717                     else
718                     {
719                         // user has made a loss
720                         //tv.takerLoss                      = safeMul(safeSub(retrievePosition(t.takerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;                                  
721                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, false); 
722                     }
723 
724                   
725 
726                     updateBalances(
727                         t.futuresContract, 
728                         [
729                             t.baseToken, // base token
730                             t.taker // make address
731                         ], 
732                         t.takerInversePositionHash, // position hash
733                         [
734                             tv.qty, // qty
735                             t.makerPrice, // price
736                             takerFee, // fee
737                             tv.takerProfit, // profit
738                             tv.takerLoss, // loss
739                             tv.takerBalance,  // balance
740                             t.takerGasFee,  // gasFee
741                             tv.takerReserve // reserve
742                         ], 
743                         [
744                             false, // newPostion (if true position is new)
745                             false, // side (if true - long)
746                             false // increase position (if true)
747                         ]
748                     );
749                 }
750             }
751         }
752 
753 
754         /*------------- Maker short, Taker long -------------*/
755 
756         else
757         {      
758             //LogUint(1, safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty)); return;
759 
760             // position actions for maker
761             if (!positionExists(t.makerInversePositionHash) && !positionExists(t.makerPositionHash))
762             {
763                 // check if maker has enough balance
764                 //if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
765                 if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
766                 {
767                     // maker out of balance
768                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
769                     return 0; 
770                 }
771 
772                 // create new position
773                 recordNewPosition(t.makerPositionHash, tv.qty, t.makerPrice, 0, block.number);
774                 updateBalances(
775                     t.futuresContract, 
776                     [
777                         t.baseToken,   // base token
778                         t.maker // make address
779                     ], 
780                     t.makerPositionHash, // position hash
781                     [
782                         tv.qty, // qty
783                         t.makerPrice, // price
784                         makerFee, // fee
785                         0, // profit
786                         0, // loss
787                         tv.makerBalance, // balance
788                         0, // gasFee
789                         tv.makerReserve // reserve
790                     ], 
791                     [
792                         true, // newPostion (if true position is new)
793                         false, // side (if true - long)
794                         false // increase position (if true)
795                     ]
796                 );
797 
798             } else {
799                 if (positionExists(t.makerPositionHash))
800                 {
801                     // check if maker has enough balance
802                     //if (safeAdd(safeMul(safeSub(t.makerPrice, t.floorPrice), tv.qty) / t.floorPrice, safeMul(tv.qty, makerFee) / (1 ether)) * 1e10 > safeSub(balances[0],tv.makerReserve))
803                     if (!checkEnoughBalance(t.capPrice, t.makerPrice, tv.qty, false, makerFee, 0, futuresContractHash, safeSub(balances[0],tv.makerReserve)))
804                     {
805                         // maker out of balance
806                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
807                         return 0; 
808                     }
809 
810                     // increase position size
811                     updatePositionSize(t.makerPositionHash, safeAdd(retrievePosition(t.makerPositionHash)[0], tv.qty), t.makerPrice);
812                 
813                     updateBalances(
814                         t.futuresContract, 
815                         [
816                             t.baseToken,  // base token
817                             t.maker // make address
818                         ], 
819                         t.makerPositionHash, // position hash
820                         [
821                             tv.qty, // qty
822                             t.makerPrice, // price
823                             makerFee, // fee
824                             0, // profit
825                             0, // loss
826                             tv.makerBalance, // balance
827                             0, // gasFee
828                             tv.makerReserve // reserve
829                         ], 
830                         [
831                             false, // newPostion (if true position is new)
832                             false, // side (if true - long)
833                             true // increase position (if true)
834                         ]
835                     );
836                 }
837                 else
838                 {
839 
840                     // close/partially close existing position
841                     updatePositionSize(t.makerInversePositionHash, safeSub(retrievePosition(t.makerInversePositionHash)[0], tv.qty), 0);       
842                     
843 
844 
845                     if (t.makerPrice > retrievePosition(t.makerInversePositionHash)[1])
846                     {
847                         // user has made a profit
848                         //tv.makerProfit                    = safeMul(safeSub(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1]), tv.qty) / t.makerPrice;
849                         tv.makerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);
850                     }
851                     else
852                     {
853                         // user has made a loss
854                         //tv.makerLoss                      = safeMul(safeSub(retrievePosition(t.makerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice; 
855                         tv.makerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.makerInversePositionHash)[1], tv.qty, futuresContractHash, false);                               
856                     }
857 
858                    
859 
860                     updateBalances(
861                         t.futuresContract, 
862                         [
863                             t.baseToken, // base token
864                             t.maker // user address
865                         ], 
866                         t.makerInversePositionHash, // position hash
867                         [
868                             tv.qty, // qty
869                             t.makerPrice, // price
870                             makerFee, // fee
871                             tv.makerProfit,  // profit
872                             tv.makerLoss, // loss
873                             tv.makerBalance, // balance
874                             0, // gasFee
875                             tv.makerReserve // reserve
876                         ], 
877                         [
878                             false, // newPostion (if true position is new)
879                             false, // side (if true - long)
880                             false // increase position (if true)
881                         ]
882                     );
883                 }
884             }
885 
886             // position actions for taker
887             if (!positionExists(t.takerInversePositionHash) && !positionExists(t.takerPositionHash))
888             {
889                 // check if taker has enough balance
890                 // if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether)), t.takerGasFee / 1e10) * 1e10 > safeSub(balances[1],tv.takerReserve))
891                 if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
892                 {
893                     // maker out of balance
894                     emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
895                     return 0; 
896                 }
897 
898                 // create new position
899                 recordNewPosition(t.takerPositionHash, tv.qty, t.makerPrice, 1, block.number);
900            
901                 updateBalances(
902                     t.futuresContract, 
903                     [
904                         t.baseToken,  // base token
905                         t.taker // user address
906                     ], 
907                     t.takerPositionHash, // position hash
908                     [
909                         tv.qty, // qty
910                         t.makerPrice, // price
911                         takerFee, // fee
912                         0,  // profit
913                         0,  // loss
914                         tv.takerBalance, // balance
915                         t.takerGasFee, // gasFee
916                         tv.takerReserve // reserve
917                     ], 
918                     [
919                         true, // newPostion (if true position is new)
920                         true, // side (if true - long)
921                         false // increase position (if true)
922                     ]
923                 );
924 
925             } else {
926                 if (positionExists(t.takerPositionHash))
927                 {
928                     // check if taker has enough balance
929                     //if (safeAdd(safeAdd(safeMul(safeSub(t.capPrice, t.makerPrice), tv.qty)  / t.capPrice, safeMul(tv.qty, takerFee) / (1 ether)), t.takerGasFee / 1e10) * 1e10 > safeSub(balances[1],tv.takerReserve))
930                     if (!checkEnoughBalance(t.floorPrice, t.makerPrice, tv.qty, true, takerFee, t.takerGasFee, futuresContractHash, safeSub(balances[1],tv.takerReserve)))
931                     {
932                         // maker out of balance
933                         emit LogError(uint8(Errors.OUT_OF_BALANCE), t.makerOrderHash, t.takerOrderHash);
934                         return 0; 
935                     }
936                     
937                     // increase position size
938                     updatePositionSize(t.takerPositionHash, safeAdd(retrievePosition(t.takerPositionHash)[0], tv.qty), t.makerPrice);
939                 
940                     updateBalances(
941                         t.futuresContract, 
942                         [
943                             t.baseToken,  // base token
944                             t.taker // user address
945                         ], 
946                         t.takerPositionHash, // position hash
947                         [
948                             tv.qty, // qty
949                             t.makerPrice, // price
950                             takerFee, // fee
951                             0, // profit
952                             0, // loss
953                             tv.takerBalance, // balance
954                             t.takerGasFee, // gasFee
955                             tv.takerReserve // reserve
956                         ], 
957                         [
958                             false, // newPostion (if true position is new)
959                             true, // side (if true - long)
960                             true // increase position (if true)
961                         ]
962                     );
963                 }
964                 else
965                 {
966 
967                     // close/partially close existing position
968                     updatePositionSize(t.takerInversePositionHash, safeSub(retrievePosition(t.takerInversePositionHash)[0], tv.qty), 0);
969                                      
970                     if (t.makerPrice < retrievePosition(t.takerInversePositionHash)[1])
971                     {
972                         // user has made a profit
973                         //tv.takerProfit                    = safeMul(safeSub(retrievePosition(t.takerInversePositionHash)[1], t.makerPrice), tv.qty) / t.makerPrice;
974                         tv.takerProfit                      = calculateProfit(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);
975                     }
976                     else
977                     {
978                         // user has made a loss
979                         //tv.takerLoss                      = safeMul(safeSub(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1]), tv.qty) / t.makerPrice; 
980                         tv.takerLoss                        = calculateLoss(t.makerPrice, retrievePosition(t.takerInversePositionHash)[1], tv.qty, futuresContractHash, true);                                  
981                     }
982 
983                     
984 
985                     updateBalances(
986                         t.futuresContract, 
987                         [
988                             t.baseToken,   // base toke
989                             t.taker // user address
990                         ], 
991                         t.takerInversePositionHash,  // position hash
992                         [
993                             tv.qty, // qty
994                             t.makerPrice, // price
995                             takerFee, // fee
996                             tv.takerProfit, // profit
997                             tv.takerLoss, // loss
998                             tv.takerBalance, // balance
999                             t.takerGasFee, // gasFee
1000                             tv.takerReserve // reserve
1001                         ], 
1002                         [
1003                             false, // newPostion (if true position is new)
1004                             true, // side (if true - long) 
1005                             false // increase position (if true)
1006                         ]
1007                     );
1008                 }
1009             }           
1010         }
1011 
1012 //--> 220 000
1013         orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty); // increase the maker order filled amount
1014         orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); // increase the taker order filled amount
1015 
1016 //--> 264 000
1017         emit FuturesTrade(takerIsBuying, tv.qty, t.makerPrice, t.futuresContract, t.makerOrderHash, t.takerOrderHash);
1018 
1019         return tv.qty;
1020     }
1021 
1022     function calculateProfit(uint256 closingPrice, uint256 entryPrice, uint256 qty, bytes32 futuresContractHash, bool side) returns (uint256)
1023     {
1024         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1025         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1026         if (side)
1027         {
1028             if (inversed)
1029             {
1030                 return safeMul(safeSub(entryPrice, closingPrice), qty) / closingPrice;  
1031             }
1032             else
1033             {
1034                 return safeMul(safeMul(safeSub(entryPrice, closingPrice), qty), multiplier)  / 1e8 / 1e18;
1035             }
1036             
1037         }
1038         else
1039         {
1040             if (inversed)
1041             {
1042                 return safeMul(safeSub(closingPrice, entryPrice), qty) / closingPrice; 
1043             }
1044             else
1045             {
1046                 return safeMul(safeMul(safeSub(closingPrice, entryPrice), qty), multiplier)  / 1e8 / 1e18; 
1047             }
1048         }
1049         
1050     }
1051 
1052     function calculateTradeValue(uint256 qty, uint256 price, bytes32 futuresContractHash) returns (uint256)
1053     {
1054         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1055         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1056         if (inversed)
1057         {
1058             return qty * 1e10;
1059         }
1060         else
1061         {
1062             return safeMul(safeMul(safeMul(qty, price), 1e2), multiplier) / 1e18 ;
1063         }
1064     }
1065 
1066 
1067 
1068     function calculateLoss(uint256 closingPrice, uint256 entryPrice, uint256 qty, bytes32 futuresContractHash, bool side) returns (uint256)
1069     {
1070         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1071         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1072         if (side)
1073         {
1074             if (inversed)
1075             {
1076                 return safeMul(safeSub(closingPrice, entryPrice), qty) / closingPrice;
1077             }
1078             else
1079             {
1080                 return safeMul(safeMul(safeSub(closingPrice, entryPrice), qty), multiplier) / 1e8 / 1e18;
1081             }
1082         }
1083         else
1084         {
1085             if (inversed)
1086             {
1087                 return safeMul(safeSub(entryPrice, closingPrice), qty) / closingPrice;
1088             }
1089             else
1090             {
1091                 return safeMul(safeMul(safeSub(entryPrice, closingPrice), qty), multiplier) / 1e8 / 1e18;
1092             } 
1093         }
1094         
1095     }
1096 
1097     function calculateCollateral (uint256 limitPrice, uint256 tradePrice, uint256 qty, bool side, bytes32 futuresContractHash) view returns (uint256)
1098     {
1099         bool inversed = futuresAssets[futuresContracts[futuresContractHash].asset].inversed;
1100         uint256 multiplier = futuresContracts[futuresContractHash].multiplier;
1101         if (side)
1102         {
1103             // long
1104             if (inversed)
1105             {
1106                 return safeMul(safeSub(tradePrice, limitPrice), qty) / limitPrice;
1107             }
1108             else
1109             {
1110                 return safeMul(safeMul(safeSub(tradePrice, limitPrice), qty), multiplier) / 1e8 / 1e18;
1111             }
1112         }
1113         else
1114         {
1115             // short
1116             if (inversed)
1117             {
1118                 return safeMul(safeSub(limitPrice, tradePrice), qty)  / limitPrice;
1119             }
1120             else
1121             {
1122                 return safeMul(safeMul(safeSub(limitPrice, tradePrice), qty), multiplier) / 1e8 / 1e18;
1123             }
1124         }       
1125     }
1126 
1127     function calculateFee (uint256 qty, uint256 tradePrice, uint256 fee,  bytes32 futuresContractHash) returns (uint256)
1128     {
1129         return safeMul(calculateTradeValue(qty, tradePrice, futuresContractHash), fee) / 1e18 / 1e10;
1130     }
1131 
1132 
1133     function checkEnoughBalance (uint256 limitPrice, uint256 tradePrice, uint256 qty, bool side, uint256 fee, uint256 gasFee, bytes32 futuresContractHash, uint256 availableBalance) view returns (bool)
1134     {
1135         if (side)
1136         {
1137             // long
1138             if (safeAdd(
1139                     safeAdd(
1140                         calculateCollateral(limitPrice, tradePrice, qty, side, futuresContractHash), 
1141                         //safeMul(qty, fee) / (1 ether)
1142                         calculateFee(qty, tradePrice, fee, futuresContractHash)
1143                     ) * 1e10,
1144                     gasFee 
1145                 ) > availableBalance)
1146             {
1147                 return false; 
1148             }
1149         }
1150         else
1151         {
1152             // short
1153             if (safeAdd(
1154                     safeAdd(
1155                         calculateCollateral(limitPrice, tradePrice, qty, side, futuresContractHash), 
1156                         //safeMul(qty, fee) / (1 ether)
1157                         calculateFee(qty, tradePrice, fee, futuresContractHash)
1158                     ) * 1e10, 
1159                     gasFee 
1160                 ) > availableBalance)
1161             {
1162                 return false;
1163             }
1164 
1165         }
1166 
1167         return true;
1168        
1169     }    
1170 
1171     // Executes multiple trades in one transaction, saves gas fees
1172     function batchFuturesTrade(
1173         uint8[2][] v,
1174         bytes32[4][] rs,
1175         uint256[8][] tradeValues,
1176         address[2][] tradeAddresses,
1177         bool[] takerIsBuying,
1178         bytes32[] futuresContractHash
1179     ) onlyAdmin
1180     {
1181         for (uint i = 0; i < tradeAddresses.length; i++) {
1182             futuresTrade(
1183                 v[i],
1184                 rs[i],
1185                 tradeValues[i],
1186                 tradeAddresses[i],
1187                 takerIsBuying[i],
1188                 futuresContractHash[i]
1189             );
1190         }
1191     }
1192 
1193 
1194     // Update user balance
1195     function updateBalances (bytes32 futuresContract, address[2] addressValues, bytes32 positionHash, uint256[8] uintValues, bool[3] boolValues) private
1196     {
1197         /*
1198             addressValues
1199             [0] baseToken
1200             [1] user
1201 
1202             uintValues
1203             [0] qty
1204             [1] price
1205             [2] fee
1206             [3] profit
1207             [4] loss
1208             [5] balance
1209             [6] gasFee
1210             [7] reserve
1211 
1212             boolValues
1213             [0] newPostion
1214             [1] side
1215             [2] increase position
1216 
1217         */
1218 
1219         //                          qty * price * fee
1220         // uint256 pam[0] = safeMul(safeMul(uintValues[0], uintValues[1]), uintValues[2]) / (1 ether);
1221         // uint256 collateral;  
1222 
1223 
1224         // pam = [fee value, collateral]                        
1225         uint256[2] memory pam = [safeAdd(calculateFee(uintValues[0], uintValues[1], uintValues[2], futuresContract) * 1e10, uintValues[6]), 0];
1226         
1227         // LogUint(100, uintValues[3]);
1228         // LogUint(9, uintValues[2]);
1229         // LogUint(7, safeMul(uintValues[0], uintValues[2])  / (1 ether));
1230         // return;
1231 
1232         
1233 
1234         // Position is new or position is increased
1235         if (boolValues[0] || boolValues[2])  
1236         {
1237 
1238             if (boolValues[1])
1239             {
1240 
1241                 //addReserve(addressValues[0], addressValues[1], uintValues[ 7], safeMul(safeSub(uintValues[1], futuresContracts[futuresContract].floorPrice), uintValues[0])); // reserve collateral on user
1242                 //pam[1] = safeMul(safeSub(uintValues[1], futuresContracts[futuresContract].floorPrice), uintValues[0]) / futuresContracts[futuresContract].floorPrice;
1243                 pam[1] = calculateCollateral(futuresContracts[futuresContract].floorPrice, uintValues[1], uintValues[0], true, futuresContract);
1244 
1245             }
1246             else
1247             {
1248                 //addReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(safeSub(futuresContracts[futuresContract].capPrice, uintValues[1]), uintValues[0])); // reserve collateral on user
1249                 //pam[1] = safeMul(safeSub(futuresContracts[futuresContract].capPrice, uintValues[1]), uintValues[0]) / futuresContracts[futuresContract].capPrice;
1250                 pam[1] = calculateCollateral(futuresContracts[futuresContract].capPrice, uintValues[1], uintValues[0], false, futuresContract);
1251             }
1252 
1253             subBalanceAddReserve(addressValues[0], addressValues[1], pam[0], safeAdd(pam[1],1));         
1254 
1255             // if (uintValues[6] > 0)
1256             // {   
1257             //     subBalanceAddReserve(addressValues[0], addressValues[1], safeAdd(uintValues[6], pam[0]), pam[1]);                  
1258                               
1259             // }
1260             // else
1261             // {
1262 
1263             //    subBalanceAddReserve(addressValues[0], addressValues[1], safeAdd(uintValues[6], pam[0]), pam[1]);                 
1264             // }
1265 
1266 
1267             //subBalance(addressValues[0], addressValues[1], uintValues[5], feeVal); // deduct user maker/taker fee 
1268 
1269             
1270         // Position exists
1271         } 
1272         else 
1273         {
1274             if (retrievePosition(positionHash)[2] == 0)
1275             {
1276                 // original position was short
1277                 //subReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(uintValues[0], safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]))); // remove freed collateral from reserver
1278                 //pam[1] = safeMul(uintValues[0], safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1])) / futuresContracts[futuresContract].capPrice;
1279                 pam[1] = calculateCollateral(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1], uintValues[0], false, futuresContract);
1280 
1281                 // LogUint(120, uintValues[0]);
1282                 // LogUint(121, futuresContracts[futuresContract].capPrice);
1283                 // LogUint(122, retrievePosition(positionHash)[1]);
1284                 // LogUint(123, uintValues[3]); // profit
1285                 // LogUint(124, uintValues[4]); // loss
1286                 // LogUint(125, safeAdd(uintValues[4], pam[0]));
1287                 // LogUint(12, pam[1] );
1288                 //return;
1289             }
1290             else
1291             {       
1292                        
1293                 // original position was long
1294                 //subReserve(addressValues[0], addressValues[1], uintValues[7], safeMul(uintValues[0], safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice)));
1295                 //pam[1] = safeMul(uintValues[0], safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice)) / futuresContracts[futuresContract].floorPrice;
1296                 pam[1] = calculateCollateral(futuresContracts[futuresContract].floorPrice, retrievePosition(positionHash)[1], uintValues[0], true, futuresContract);
1297 
1298             }
1299 
1300 
1301                 // LogUint(41, uintValues[3]);
1302                 // LogUint(42, uintValues[4]);
1303                 // LogUint(43, pam[0]);
1304                 // return;  
1305             if (uintValues[3] > 0) 
1306             {
1307                 // profi > 0
1308 
1309                 if (pam[0] <= uintValues[3]*1e10)
1310                 {
1311                     //addBalance(addressValues[0], addressValues[1], uintValues[5], safeSub(uintValues[3], pam[0])); // add profit to user balance
1312                     addBalanceSubReserve(addressValues[0], addressValues[1], safeSub(uintValues[3]*1e10, pam[0]), pam[1]);
1313                 }
1314                 else
1315                 {
1316                     subBalanceSubReserve(addressValues[0], addressValues[1], safeSub(pam[0], uintValues[3]*1e10), pam[1]);
1317                 }
1318                 
1319             } 
1320             else 
1321             {   
1322                 
1323 
1324                 // loss >= 0
1325                 //subBalance(addressValues[0], addressValues[1], uintValues[5], safeAdd(uintValues[4], pam[0])); // deduct loss from user balance 
1326                 subBalanceSubReserve(addressValues[0], addressValues[1], safeAdd(uintValues[4]*1e10, pam[0]), pam[1]); // deduct loss from user balance
1327            
1328             } 
1329             //}            
1330         }          
1331         
1332         addBalance(addressValues[0], feeAccount, EtherMium(exchangeContract).balanceOf(addressValues[0], feeAccount), pam[0]); // send fee to feeAccount
1333     }
1334 
1335     function recordNewPosition (bytes32 positionHash, uint256 size, uint256 price, uint256 side, uint256 block) private
1336     {
1337         if (!validateUint128(size) || !validateUint64(price)) 
1338         {
1339             throw;
1340         }
1341 
1342         uint256 character = uint128(size);
1343         character |= price<<128;
1344         character |= side<<192;
1345         character |= block<<208;
1346 
1347         positions[positionHash] = character;
1348     }
1349 
1350     function retrievePosition (bytes32 positionHash) public view returns (uint256[4])
1351     {
1352         uint256 character = positions[positionHash];
1353         uint256 size = uint256(uint128(character));
1354         uint256 price = uint256(uint64(character>>128));
1355         uint256 side = uint256(uint16(character>>192));
1356         uint256 entryBlock = uint256(uint48(character>>208));
1357 
1358         return [size, price, side, entryBlock];
1359     }
1360 
1361     function updatePositionSize(bytes32 positionHash, uint256 size, uint256 price) private
1362     {
1363         uint256[4] memory pos = retrievePosition(positionHash);
1364 
1365         if (size > pos[0])
1366         {
1367             // position is increasing in size
1368             recordNewPosition(positionHash, size, safeAdd(safeMul(pos[0], pos[1]), safeMul(price, safeSub(size, pos[0]))) / size, pos[2], pos[3]);
1369         }
1370         else
1371         {
1372             // position is decreasing in size
1373             recordNewPosition(positionHash, size, pos[1], pos[2], pos[3]);
1374         }        
1375     }
1376 
1377     function positionExists (bytes32 positionHash) internal view returns (bool)
1378     {
1379         //LogUint(3,retrievePosition(positionHash)[0]);
1380         if (retrievePosition(positionHash)[0] == 0)
1381         {
1382             return false;
1383         }
1384         else
1385         {
1386             return true;
1387         }
1388     }
1389 
1390     // This function allows the user to manually release collateral in case the oracle service does not provide the price during the inactivityReleasePeriod
1391     function forceReleaseReserve (bytes32 futuresContract, bool side) public
1392     {   
1393         if (futuresContracts[futuresContract].expirationBlock == 0) throw;       
1394         if (futuresContracts[futuresContract].expirationBlock > block.number) throw;
1395         if (safeAdd(futuresContracts[futuresContract].expirationBlock, EtherMium(exchangeContract).getInactivityReleasePeriod()) > block.number) throw;  
1396 
1397         bytes32 positionHash = keccak256(this, msg.sender, futuresContract, side);
1398         if (retrievePosition(positionHash)[1] == 0) throw;    
1399   
1400 
1401         futuresContracts[futuresContract].broken = true;
1402 
1403         address baseToken = futuresAssets[futuresContracts[futuresContract].asset].baseToken;
1404 
1405         if (side)
1406         {
1407             subReserve(
1408                 baseToken, 
1409                 msg.sender, 
1410                 EtherMium(exchangeContract).getReserve(baseToken, msg.sender), 
1411                 //safeMul(safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].floorPrice
1412                 calculateCollateral(futuresContracts[futuresContract].floorPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], true, futuresContract)
1413             ); 
1414         }
1415         else
1416         {            
1417             subReserve(
1418                 baseToken, 
1419                 msg.sender, 
1420                 EtherMium(exchangeContract).getReserve(baseToken, msg.sender), 
1421                 //safeMul(safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].capPrice
1422                 calculateCollateral(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], false, futuresContract)
1423             ); 
1424         }
1425 
1426         updatePositionSize(positionHash, 0, 0);
1427 
1428         //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), );
1429         //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], positions[msg.sender][positionHash].collateral);
1430 
1431         emit FuturesForcedRelease(futuresContract, side, msg.sender);
1432 
1433     }
1434 
1435     function addBalance(address token, address user, uint256 balance, uint256 amount) private
1436     {
1437         EtherMium(exchangeContract).setBalance(token, user, safeAdd(balance, amount));
1438     }
1439 
1440     function subBalance(address token, address user, uint256 balance, uint256 amount) private
1441     {
1442         EtherMium(exchangeContract).setBalance(token, user, safeSub(balance, amount));
1443     }
1444 
1445     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) private
1446     {
1447         EtherMium(exchangeContract).subBalanceAddReserve(token, user, subBalance, addReserve * 1e10);
1448     }
1449 
1450     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) private
1451     {
1452 
1453         EtherMium(exchangeContract).addBalanceSubReserve(token, user, addBalance, subReserve * 1e10);
1454     }
1455 
1456     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) private
1457     {
1458         // LogUint(31, subBalance);
1459         // LogUint(32, subReserve);
1460         // return;
1461 
1462         EtherMium(exchangeContract).subBalanceSubReserve(token, user, subBalance, subReserve * 1e10);
1463     }
1464 
1465     function addReserve(address token, address user, uint256 reserve, uint256 amount) private
1466     {
1467         //reserve[token][user] = safeAdd(reserve[token][user], amount);
1468         EtherMium(exchangeContract).setReserve(token, user, safeAdd(reserve, amount * 1e10));
1469     }
1470 
1471     function subReserve(address token, address user, uint256 reserve, uint256 amount) private 
1472     {
1473         //reserve[token][user] = safeSub(reserve[token][user], amount);
1474         EtherMium(exchangeContract).setReserve(token, user, safeSub(reserve, amount * 1e10));
1475     }
1476 
1477 
1478     function getMakerTakerBalances(address maker, address taker, address token) public view returns (uint256[4])
1479     {
1480         return [
1481             EtherMium(exchangeContract).balanceOf(token, maker),
1482             EtherMium(exchangeContract).getReserve(token, maker),
1483             EtherMium(exchangeContract).balanceOf(token, taker),
1484             EtherMium(exchangeContract).getReserve(token, taker)
1485         ];
1486     }
1487 
1488     function getMakerTakerPositions(bytes32 makerPositionHash, bytes32 makerInversePositionHash, bytes32 takerPosition, bytes32 takerInversePosition) public view returns (uint256[4][4])
1489     {
1490         return [
1491             retrievePosition(makerPositionHash),
1492             retrievePosition(makerInversePositionHash),
1493             retrievePosition(takerPosition),
1494             retrievePosition(takerInversePosition)
1495         ];
1496     }
1497 
1498 
1499     struct FuturesClosePositionValues {
1500         uint256 reserve;                // amount to be trade
1501         uint256 balance;        // holds maker profit value
1502         uint256 floorPrice;          // holds maker loss value
1503         uint256 capPrice;        // holds taker profit value
1504         uint256 closingPrice;          // holds taker loss value
1505         bytes32 futuresContract; // the futures contract hash
1506     }
1507 
1508 
1509     function closeFuturesPosition (bytes32 futuresContract, bool side)
1510     {
1511         bytes32 positionHash = keccak256(this, msg.sender, futuresContract, side);
1512 
1513         if (futuresContracts[futuresContract].closed == false && futuresContracts[futuresContract].expirationBlock != 0) throw; // contract not yet settled
1514         if (retrievePosition(positionHash)[1] == 0) throw; // position not found
1515         if (retrievePosition(positionHash)[0] == 0) throw; // position already closed
1516 
1517         uint256 profit;
1518         uint256 loss;
1519 
1520         address baseToken = futuresAssets[futuresContracts[futuresContract].asset].baseToken;
1521 
1522         FuturesClosePositionValues memory v = FuturesClosePositionValues({
1523             reserve         : EtherMium(exchangeContract).getReserve(baseToken, msg.sender),
1524             balance         : EtherMium(exchangeContract).balanceOf(baseToken, msg.sender),
1525             floorPrice      : futuresContracts[futuresContract].floorPrice,
1526             capPrice        : futuresContracts[futuresContract].capPrice,
1527             closingPrice    : futuresContracts[futuresContract].closingPrice,
1528             futuresContract : futuresContract
1529         });
1530 
1531         // uint256 reserve = EtherMium(exchangeContract).getReserve(baseToken, msg.sender);
1532         // uint256 balance = EtherMium(exchangeContract).balanceOf(baseToken, msg.sender);
1533         // uint256 floorPrice = futuresContracts[futuresContract].floorPrice;
1534         // uint256 capPrice = futuresContracts[futuresContract].capPrice;
1535         // uint256 closingPrice =  futuresContracts[futuresContract].closingPrice;
1536 
1537 
1538         
1539         //uint256 fee = safeMul(safeMul(retrievePosition(positionHash)[0], v.closingPrice), takerFee) / (1 ether);
1540         uint256 fee = calculateFee(retrievePosition(positionHash)[0], v.closingPrice, takerFee, futuresContract);
1541 
1542 
1543 
1544         // close long position
1545         if (side == true)
1546         {            
1547 
1548             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1549             // LogUint(12, safeMul(safeSub(retrievePosition(positionHash)[1], futuresContracts[futuresContract].floorPrice), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].floorPrice);
1550             // return;
1551             // reserve = reserve - (entryPrice - floorPrice) * size;
1552             //subReserve(baseToken, msg.sender, EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[positionHash].size));
1553             
1554             
1555             subReserve(
1556                 baseToken, 
1557                 msg.sender, 
1558                 v.reserve, 
1559                 //safeMul(safeSub(retrievePosition(positionHash)[1], v.floorPrice), retrievePosition(positionHash)[0]) / v.floorPrice
1560                 calculateCollateral(v.floorPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], true, v.futuresContract)
1561             );
1562             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1563             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(positions[msg.sender][positionHash].entryPrice, futuresContracts[futuresContract].floorPrice), positions[msg.sender][positionHash].size));
1564             
1565             
1566 
1567             if (v.closingPrice > retrievePosition(positionHash)[1])
1568             {
1569                 // user made a profit
1570                 //profit = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1571                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);
1572                 
1573 
1574 
1575                 // LogUint(15, profit);
1576                 // LogUint(16, fee);
1577                 // LogUint(17, safeSub(profit * 1e10, fee));
1578                 // return;
1579 
1580                 addBalance(baseToken, msg.sender, v.balance, safeSub(profit * 1e10, fee * 1e10));
1581                 //EtherMium(exchangeContract).updateBalance(baseToken, msg.sender, safeAdd(EtherMium(exchangeContract).balanceOf(baseToken, msg.sender), profit);
1582                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1583             }
1584             else
1585             {
1586                 // user made a loss
1587                 //loss = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1588                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, false);  
1589 
1590 
1591                 subBalance(baseToken, msg.sender, v.balance, safeAdd(loss * 1e10, fee * 1e10));
1592                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1593             }
1594         }   
1595         // close short position 
1596         else
1597         {
1598             // LogUint(11, EtherMium(exchangeContract).getReserve(baseToken, msg.sender));
1599             // LogUint(12, safeMul(safeSub(futuresContracts[futuresContract].capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / futuresContracts[futuresContract].capPrice);
1600             // return;
1601 
1602             // reserve = reserve - (capPrice - entryPrice) * size;
1603             subReserve(
1604                 baseToken, 
1605                 msg.sender,  
1606                 v.reserve, 
1607                 //safeMul(safeSub(v.capPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.capPrice
1608                 calculateCollateral(v.capPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], false, v.futuresContract)
1609             );
1610             //EtherMium(exchangeContract).setReserve(baseToken, msg.sender, safeSub(EtherMium(exchangeContract).getReserve(baseToken, msg.sender), safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1611             //reserve[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(reserve[futuresContracts[futuresContract].baseToken][msg.sender], safeMul(safeSub(futuresContracts[futuresContract].capPrice, positions[msg.sender][positionHash].entryPrice), positions[msg.sender][positionHash].size));
1612             
1613             
1614 
1615             if (v.closingPrice < retrievePosition(positionHash)[1])
1616             {
1617                 // user made a profit
1618                 // profit = (entryPrice - closingPrice) * size
1619                 // profit = safeMul(safeSub(retrievePosition(positionHash)[1], v.closingPrice), retrievePosition(positionHash)[0]) / v.closingPrice;
1620                 profit = calculateProfit(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);
1621 
1622                 addBalance(baseToken, msg.sender, v.balance, safeSub(profit * 1e10, fee * 1e10));
1623 
1624                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeAdd(tokens[futuresContracts[futuresContract].baseToken][msg.sender], profit);
1625             }
1626             else
1627             {
1628                 // user made a loss
1629                 // profit = (closingPrice - entryPrice) * size
1630                 //loss = safeMul(safeSub(v.closingPrice, retrievePosition(positionHash)[1]), retrievePosition(positionHash)[0]) / v.closingPrice;
1631                 loss = calculateLoss(v.closingPrice, retrievePosition(positionHash)[1], retrievePosition(positionHash)[0], futuresContract, true);  
1632 
1633                 subBalance(baseToken, msg.sender, v.balance, safeAdd(loss * 1e10, fee * 1e10));
1634 
1635                 //tokens[futuresContracts[futuresContract].baseToken][msg.sender] = safeSub(tokens[futuresContracts[futuresContract].baseToken][msg.sender], loss);
1636             }
1637         }  
1638 
1639         addBalance(baseToken, feeAccount, EtherMium(exchangeContract).balanceOf(baseToken, feeAccount), fee * 1e10); // send fee to feeAccount
1640         updatePositionSize(positionHash, 0, 0);
1641     }
1642 
1643     /*
1644         string priceUrl;                // the url where the price of the asset will be taken for settlement
1645         string pricePath;               // price path in the returned JSON from the priceUrl (ex. path "last" will return tha value last from the json: {"high": "156.49", "last": "154.31", "timestamp": "1556522201", "bid": "154.22", "vwap": "154.65", "volume": "25578.79138868", "low": "152.33", "ask": "154.26", "open": "152.99"})
1646         bool multiplied;                // if true, the price from the priceUrl will be multiplied by the multiplierPriceUrl
1647         string multiplierPriceUrl;      // needed only if multiplied=true
1648         string multiplierPricePath;     // same as pricePath 
1649         bool inverseMultiplier; 
1650     */
1651 
1652 
1653     function closeFuturesContract (bytes32 futuresContract, uint256 price, uint256 multipliterPrice) onlyAdmin
1654     {
1655         uint256 closingPrice = price;
1656 
1657         if (futuresContracts[futuresContract].expirationBlock == 0) throw; // contract not found
1658         if (futuresContracts[futuresContract].closed == true) throw; // contract already closed
1659         if (futuresContracts[futuresContract].expirationBlock > block.number 
1660             && closingPrice > futuresContracts[futuresContract].floorPrice
1661             && closingPrice < futuresContracts[futuresContract].capPrice) throw; // contract not yet expired
1662         futuresContracts[futuresContract].closingPrice = closingPrice;
1663         futuresContracts[futuresContract].closed = true;
1664 
1665         emit FuturesContractClosed(futuresContract, closingPrice);
1666     }
1667 
1668     
1669 
1670     // Returns the smaller of two values
1671     function min(uint a, uint b) private pure returns (uint) {
1672         return a < b ? a : b;
1673     }
1674 }