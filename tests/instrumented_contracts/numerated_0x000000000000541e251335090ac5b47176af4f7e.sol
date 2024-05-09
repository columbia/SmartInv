1 pragma solidity 0.5.11;
2 pragma experimental ABIEncoderV2;
3 
4 contract dexBlueEvents{
5     // Events
6 
7     /** @notice Emitted when a trade is settled
8       * @param  makerAsset  The address of the token the maker gave
9       * @param  makerAmount The amount of makerAsset the maker gave
10       * @param  takerAsset  The address of the token the taker gave
11       * @param  takerAmount The amount of takerAsset the taker gave
12       */
13     event LogTrade(address makerAsset, uint256 makerAmount, address takerAsset, uint256 takerAmount);
14     
15     /** @notice Emitted when a simple token swap against a reserve is settled
16       * @param  soldAsset    The address of the token the maker gave
17       * @param  soldAmount   The amount of makerAsset the maker gave
18       * @param  boughtAsset  The address of the token the taker gave
19       * @param  boughtAmount The amount of takerAsset the taker gave
20       */
21     event LogSwap(address soldAsset, uint256 soldAmount, address boughtAsset, uint256 boughtAmount);
22 
23     /** @notice Emitted when a trade settlement failed
24       */
25     event LogTradeFailed();
26 
27     /** @notice Emitted after a successful deposit of ETH or token
28       * @param  account  The address, which deposited the asset
29       * @param  token    The address of the deposited token (ETH is address(0))
30       * @param  amount   The amount deposited in this transaction 
31       */
32     event LogDeposit(address account, address token, uint256 amount);
33 
34     /** @notice Emitted after a successful multi-sig withdrawal of deposited ETH or token
35       * @param  account  The address, which initiated the withdrawal
36       * @param  token    The address of the token which is withdrawn (ETH is address(0))
37       * @param  amount   The amount withdrawn in this transaction 
38       */
39     event LogWithdrawal(address account, address token, uint256 amount);
40 
41     /** @notice Emitted after a successful direct withdrawal of deposited ETH or token
42       * @param  account  The address, which initiated the withdrawal
43       * @param  token    The address of the token which is withdrawn (ETH is address(0))
44       * @param  amount   The amount withdrawn in this transaction 
45       */
46     event LogDirectWithdrawal(address account, address token, uint256 amount);
47 
48     /** @notice Emitted after a user successfully blocked tokens or ETH for a single signature withdrawal
49       * @param  account  The address controlling the tokens
50       * @param  token    The address of the token which is blocked (ETH is address(0))
51       * @param  amount   The amount blocked in this transaction 
52       */
53     event LogBlockedForSingleSigWithdrawal(address account, address token, uint256 amount);
54 
55     /** @notice Emitted after a successful single-sig withdrawal of deposited ETH or token
56       * @param  account  The address, which initiated the withdrawal
57       * @param  token    The address of the token which is withdrawn (ETH is address(0))
58       * @param  amount   The amount withdrawn in this transaction 
59       */
60     event LogSingleSigWithdrawal(address account, address token, uint256 amount);
61 
62     /** @notice Emitted once an on-chain cancellation of an order was performed
63       * @param  hash    The invalidated orders hash 
64       */
65     event LogOrderCanceled(bytes32 hash);
66    
67     /** @notice Emitted once a address delegation or dedelegation was performed
68       * @param  delegator The delegating address,
69       * @param  delegate  The delegated address,
70       * @param  status    whether the transaction delegated an address (true) or inactivated an active delegation (false) 
71       */
72     event LogDelegateStatus(address delegator, address delegate, bool status);
73 }
74 
75 contract dexBlueStorage{
76     // Storage Variables
77 
78     mapping(address => mapping(address => uint256)) balances;                           // Users balances (token address > user address > balance amount) (ETH is address(0))
79     mapping(address => mapping(address => uint256)) blocked_for_single_sig_withdrawal;  // Users balances, blocked to withdraw without arbiters multi-sig (token address > user address > blocked amount) (ETH is address(0))
80     mapping(address => uint256) last_blocked_timestamp;                                 // The last timestamp a user blocked tokens at, to withdraw with single-sig
81     
82     mapping(bytes32 => bool) processed_withdrawals;                                     // Processed withdrawal hashes
83     mapping(bytes32 => uint256) matched;                                                // Orders matched sell amounts to prevent multiple-/over- matches of the same orders
84     
85     mapping(address => address) delegates;                                              // Registered Delegated Signing Key addresses
86     
87     mapping(uint256 => address) tokens;                                                 // Cached token index > address mapping
88     mapping(address => uint256) token_indices;                                          // Cached token addresses > index mapping
89     address[] token_arr;                                                                // Array of cached token addresses
90     
91     mapping(uint256 => address payable) reserves;                                       // Reserve index > reserve address mapping
92     mapping(address => uint256) reserve_indices;                                        // Reserve address > reserve index mapping
93     mapping(address => bool) public_reserves;                                           // Reserves publicly accessible through swap() & swapWithReserve()
94     address[] public_reserve_arr;                                                       // Array of the publicly accessible reserves
95 
96     address payable owner;                      // Contract owner address (has the right to nominate arbiters and feeCollector addresses)   
97     mapping(address => bool) arbiters;          // Mapping of arbiters
98     bool marketActive = true;                   // Make it possible to pause the market
99     address payable feeCollector;               // feeCollector address
100     bool feeCollectorLocked = false;            // Make it possible to lock the feeCollector address (to allow to change the feeCollector to a fee distribution contract)
101     uint256 single_sig_waiting_period = 86400;  // waiting period for single sig withdrawas, default (and max) is one day
102 }
103 
104 contract dexBlueUtils is dexBlueStorage{
105     /** @notice Get the balance of a user for a specific token
106       * @param  token  The token address (ETH is address(0))
107       * @param  holder The address holding the token
108       * @return The amount of the specified token held by the user 
109       */
110     function getBalance(address token, address holder) view public returns(uint256){
111         return balances[token][holder];
112     }
113     
114     /** @notice Get index of a cached token address
115       * @param  token  The token address (ETH is address(0))
116       * @return The index of the token
117       */
118     function getTokenIndex(address token) view public returns(uint256){
119         return token_indices[token];
120     }
121     
122     /** @notice Get a cached token address from an index
123       * @param  index  The index of the token
124       * @return The address of the token
125       */
126     function getTokenFromIndex(uint256 index) view public returns(address){
127         return tokens[index];
128     }
129     
130     /** @notice Get the array containing all indexed token addresses
131       * @return The array of all indexed token addresses
132       */
133     function getTokens() view public returns(address[] memory){
134         return token_arr;
135     }
136     
137     /** @notice Get index of a cached reserve address
138       * @param  reserve  The reserve address
139       * @return The index of the reserve
140       */
141     function getReserveIndex(address reserve) view public returns(uint256){
142         return reserve_indices[reserve];
143     }
144     
145     /** @notice Get a cached reserve address from an index
146       * @param  index  The index of the reserve
147       * @return The address of the reserve
148       */
149     function getReserveFromIndex(uint256 index) view public returns(address){
150         return reserves[index];
151     }
152     
153     /** @notice Get the array containing all publicly available reserve addresses
154       * @return The array of addresses of all publicly available reserves
155       */
156     function getReserves() view public returns(address[] memory){
157         return public_reserve_arr;
158     }
159     
160     /** @notice Get the balance a user blocked for a single-signature withdrawal (ETH is address(0))
161       * @param  token  The token address (ETH is address(0))
162       * @param  holder The address holding the token
163       * @return The amount of the specified token blocked by the user 
164       */
165     function getBlocked(address token, address holder) view public returns(uint256){
166         return blocked_for_single_sig_withdrawal[token][holder];
167     }
168     
169     /** @notice Returns the timestamp of the last blocked balance
170       * @param  user  Address of the user which blocked funds
171       * @return The last unix timestamp the user blocked funds at, which starts the waiting period for single-sig withdrawals 
172       */
173     function getLastBlockedTimestamp(address user) view public returns(uint256){
174         return last_blocked_timestamp[user];
175     }
176     
177     /** @notice We have to check returndatasize after ERC20 tokens transfers, as some tokens are implemented badly (dont return a boolean)
178       * @return Whether the last ERC20 transfer failed or succeeded
179       */
180     function checkERC20TransferSuccess() pure internal returns(bool){
181         uint256 success = 0;
182 
183         assembly {
184             switch returndatasize               // Check the number of bytes the token contract returned
185                 case 0 {                        // Nothing returned, but contract did not throw > assume our transfer succeeded
186                     success := 1
187                 }
188                 case 32 {                       // 32 bytes returned, result is the returned bool
189                     returndatacopy(0, 0, 32)
190                     success := mload(0)
191                 }
192         }
193 
194         return success != 0;
195     }
196 }
197 
198 contract dexBlueStructs is dexBlueStorage{
199 
200     // EIP712 Domain
201     struct EIP712_Domain {
202         string  name;
203         string  version;
204         uint256 chainId;
205         address verifyingContract;
206     }
207     bytes32 constant EIP712_DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
208     bytes32          EIP712_DOMAIN_SEPARATOR;
209     // Order typehash
210     bytes32 constant EIP712_ORDER_TYPEHASH = keccak256("Order(address sellTokenAddress,uint128 sellTokenAmount,address buyTokenAddress,uint128 buyTokenAmount,uint32 expiry,uint64 nonce)");
211     // Withdrawal typehash
212     bytes32 constant EIP712_WITHDRAWAL_TYPEHASH = keccak256("Withdrawal(address token,uint256 amount,uint64 nonce)");
213 
214     
215     struct Order{
216         address     sellToken;     // The token, the order signee wants to sell
217         uint256     sellAmount;    // The total amount the signee wants to give for the amount he wants to buy (the orders "rate" is implied by the ratio between the two amounts)
218         address     buyToken;      // The token, the order signee wants to buy
219         uint256     buyAmount;     // The total amount the signee wants to buy
220         uint256     expiry;        // The expiry time of the order (after which it is not longer valid)
221         bytes32     hash;          // The orders hash
222         address     signee;        // The orders signee
223     }
224 
225     struct OrderInputPacked{
226         /*
227             BITMASK                                                            | BYTE RANGE | DESCRIPTION
228             -------------------------------------------------------------------|------------|----------------------------------
229             0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 |  0 - 15    | sell amount
230             0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff | 16 - 31    | buy amount
231         */  
232         bytes32     packedInput1;
233         /*
234             BITMASK                                                            | BYTE RANGE | DESCRIPTION
235             -------------------------------------------------------------------|------------|----------------------------------
236             0xffff000000000000000000000000000000000000000000000000000000000000 |  0 -  1    | sell token identifier
237             0x0000ffff00000000000000000000000000000000000000000000000000000000 |  2 -  3    | buy token identifier
238             0x00000000ffffffff000000000000000000000000000000000000000000000000 |  4 -  7    | expiry
239             0x0000000000000000ffffffffffffffff00000000000000000000000000000000 |  8 - 15    | nonce
240             0x00000000000000000000000000000000ff000000000000000000000000000000 | 16 - 16    | v
241             0x0000000000000000000000000000000000ff0000000000000000000000000000 | 17 - 17    | signing scheme 0x00 = personal.sign, 0x01 = EIP712
242             0x000000000000000000000000000000000000ff00000000000000000000000000 | 18 - 18    | signed by delegate
243         */
244         bytes32     packedInput2;
245         
246         bytes32     r;                          // Signature r
247         bytes32     s;                          // Signature s
248     }
249     
250     /** @notice Helper function parse an Order struct from an OrderInputPacked struct
251       * @param   orderInput  The OrderInputPacked struct to parse
252       * @return The parsed Order struct
253       */
254     function orderFromInput(OrderInputPacked memory orderInput) view public returns(Order memory){
255         // Parse packed input
256         Order memory order = Order({
257             sellToken  : tokens[uint256(orderInput.packedInput2 >> 240)],
258             sellAmount : uint256(orderInput.packedInput1 >> 128),
259             buyToken   : tokens[uint256((orderInput.packedInput2 & 0x0000ffff00000000000000000000000000000000000000000000000000000000) >> 224)],
260             buyAmount  : uint256(orderInput.packedInput1 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
261             expiry     : uint256((orderInput.packedInput2 & 0x00000000ffffffff000000000000000000000000000000000000000000000000) >> 192), 
262             hash       : 0x0,
263             signee     : address(0x0)
264         });
265         
266         // Restore order hash
267         if(
268             orderInput.packedInput2[17] == byte(0x00)   // Signing scheme
269         ){                                              // Order is hashed after signature scheme personal.sign()
270             order.hash = keccak256(abi.encodePacked(    // Restore the hash of this order
271                 "\x19Ethereum Signed Message:\n32",
272                 keccak256(abi.encodePacked(
273                     order.sellToken,
274                     uint128(order.sellAmount),
275                     order.buyToken,
276                     uint128(order.buyAmount),
277                     uint32(order.expiry), 
278                     uint64(uint256((orderInput.packedInput2 & 0x0000000000000000ffffffffffffffff00000000000000000000000000000000) >> 128)), // nonce     
279                     address(this)                       // This contract's address
280                 ))
281             ));
282         }else{                                          // Order is hashed after EIP712
283             order.hash = keccak256(abi.encodePacked(
284                 "\x19\x01",
285                 EIP712_DOMAIN_SEPARATOR,
286                 keccak256(abi.encode(
287                     EIP712_ORDER_TYPEHASH,
288                     order.sellToken,
289                     order.sellAmount,
290                     order.buyToken,
291                     order.buyAmount,
292                     order.expiry, 
293                     uint256((orderInput.packedInput2 & 0x0000000000000000ffffffffffffffff00000000000000000000000000000000) >> 128) // nonce   
294                 ))
295             ));
296         }
297         
298         // Restore the signee of this order
299         order.signee = ecrecover(
300             order.hash,                             // Order hash
301             uint8(orderInput.packedInput2[16]),     // Signature v
302             orderInput.r,                           // Signature r
303             orderInput.s                            // Signature s
304         );
305         
306         // When the signature was delegated restore delegating address
307         if(
308             orderInput.packedInput2[18] == byte(0x01)  // Is delegated
309         ){
310             order.signee = delegates[order.signee];
311         }
312         
313         return order;
314     }
315     
316     struct Trade{
317         uint256 makerAmount;
318         uint256 takerAmount; 
319         uint256 makerFee; 
320         uint256 takerFee;
321         uint256 makerRebate;
322     }
323     
324     struct ReserveReserveTrade{
325         address makerToken;
326         address takerToken; 
327         uint256 makerAmount;
328         uint256 takerAmount; 
329         uint256 makerFee; 
330         uint256 takerFee;
331         uint256 gasLimit;
332     }
333     
334     struct ReserveTrade{
335         uint256 orderAmount;
336         uint256 reserveAmount; 
337         uint256 orderFee; 
338         uint256 reserveFee;
339         uint256 orderRebate;
340         uint256 reserveRebate;
341         bool    orderIsMaker;
342         uint256 gasLimit;
343     }
344     
345     struct TradeInputPacked{
346         /* 
347             BITMASK                                                            | BYTE RANGE | DESCRIPTION
348             -------------------------------------------------------------------|------------|----------------------------------
349             0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 |  0 - 15    | maker amount
350             0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff | 16 - 31    | taker amount
351         */
352         bytes32     packedInput1;  
353         /*
354             BITMASK                                                            | BYTE RANGE | DESCRIPTION
355             -------------------------------------------------------------------|------------|----------------------------------
356             0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 |  0-15      | maker fee
357             0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff | 16-31      | taker fee
358         */
359         bytes32     packedInput2; 
360         /*
361             BITMASK                                                            | BYTE RANGE | DESCRIPTION
362             -------------------------------------------------------------------|------------|----------------------------------
363             0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 |  0 - 15    | maker rebate           (optional)
364             0x00000000000000000000000000000000ff000000000000000000000000000000 | 16 - 16    | counterparty types:
365                                                                                |            |   0x11 : maker=order,   taker=order, 
366                                                                                |            |   0x10 : maker=order,   taker=reserve, 
367                                                                                |            |   0x01 : maker=reserve, taker=order
368                                                                                |            |   0x00 : maker=reserve, taker=reserve
369             0x0000000000000000000000000000000000ffff00000000000000000000000000 | 17 - 18    | maker_identifier
370             0x00000000000000000000000000000000000000ffff0000000000000000000000 | 19 - 20    | taker_identifier
371             0x000000000000000000000000000000000000000000ffff000000000000000000 | 21 - 22    | maker_token_identifier (optional)
372             0x0000000000000000000000000000000000000000000000ffff00000000000000 | 23 - 24    | taker_token_identifier (optional)
373             0x00000000000000000000000000000000000000000000000000ffffff00000000 | 25 - 27    | gas_limit              (optional)
374             0x00000000000000000000000000000000000000000000000000000000ff000000 | 28 - 28    | burn_gas_tokens        (optional)
375         */
376         bytes32     packedInput3; 
377     }
378 
379     /** @notice Helper function parse an Trade struct from an TradeInputPacked struct
380       * @param  packed      The TradeInputPacked struct to parse
381       * @return The parsed Trade struct
382       */
383     function tradeFromInput(TradeInputPacked memory packed) public pure returns (Trade memory){
384         return Trade({
385             makerAmount : uint256(packed.packedInput1 >> 128),
386             takerAmount : uint256(packed.packedInput1 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
387             makerFee    : uint256(packed.packedInput2 >> 128),
388             takerFee    : uint256(packed.packedInput2 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
389             makerRebate : uint256(packed.packedInput3 >> 128)
390         });
391     }
392     
393     /** @notice Helper function parse an ReserveTrade struct from an TradeInputPacked struct
394       * @param  packed      The TradeInputPacked struct to parse
395       * @return The parsed ReserveTrade struct
396       */
397     function reserveTradeFromInput(TradeInputPacked memory packed) public pure returns (ReserveTrade memory){
398         if(packed.packedInput3[16] == byte(0x10)){
399             // maker is order, taker is reserve
400             return ReserveTrade({
401                 orderAmount   : uint256( packed.packedInput1 >> 128),
402                 reserveAmount : uint256( packed.packedInput1 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
403                 orderFee      : uint256( packed.packedInput2 >> 128),
404                 reserveFee    : uint256( packed.packedInput2 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
405                 orderRebate   : uint256((packed.packedInput3 & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128),
406                 reserveRebate : 0,
407                 orderIsMaker  : true,
408                 gasLimit      : uint256((packed.packedInput3 & 0x00000000000000000000000000000000000000000000000000ffffff00000000) >> 32)
409             });
410         }else{
411             // taker is order, maker is reserve
412             return ReserveTrade({
413                 orderAmount   : uint256( packed.packedInput1 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
414                 reserveAmount : uint256( packed.packedInput1 >> 128),
415                 orderFee      : uint256( packed.packedInput2 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
416                 reserveFee    : uint256( packed.packedInput2 >> 128),
417                 orderRebate   : 0,
418                 reserveRebate : uint256((packed.packedInput3 & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128),
419                 orderIsMaker  : false,
420                 gasLimit      : uint256((packed.packedInput3 & 0x00000000000000000000000000000000000000000000000000ffffff00000000) >> 32)
421             });
422         }
423     }
424 
425     /** @notice Helper function parse an ReserveReserveTrade struct from an TradeInputPacked struct
426       * @param  packed      The TradeInputPacked struct to parse
427       * @return The parsed ReserveReserveTrade struct
428       */
429     function reserveReserveTradeFromInput(TradeInputPacked memory packed) public view returns (ReserveReserveTrade memory){
430         return ReserveReserveTrade({
431             makerToken    : tokens[uint256((packed.packedInput3 & 0x000000000000000000000000000000000000000000ffff000000000000000000) >> 72)],
432             takerToken    : tokens[uint256((packed.packedInput3 & 0x0000000000000000000000000000000000000000000000ffff00000000000000) >> 56)],
433             makerAmount   : uint256( packed.packedInput1 >> 128),
434             takerAmount   : uint256( packed.packedInput1 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
435             makerFee      : uint256( packed.packedInput2 >> 128),
436             takerFee      : uint256( packed.packedInput2 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
437             gasLimit      : uint256((packed.packedInput3 & 0x00000000000000000000000000000000000000000000000000ffffff00000000) >> 32)
438         });
439     }
440     
441     struct RingTrade {
442         bool    isReserve;      // 1 if this trade is from a reserve, 0 when from an order
443         uint256 identifier;     // identifier of the reserve or order
444         address giveToken;      // the token this trade gives, the receive token is the givetoken of the previous ring element
445         uint256 giveAmount;     // the amount of giveToken, this ring element is giving for the amount it reeives from the previous element
446         uint256 fee;            // the fee this ring element has to pay on the giveToken giveAmount of the previous ring element
447         uint256 rebate;         // the rebate on giveAmount this element receives
448         uint256 gasLimit;       // the gas limit for the reserve call (if the element is a reserve)
449     }
450 
451     struct RingTradeInputPacked{
452         /* 
453             BITMASK                                                            | BYTE RANGE | DESCRIPTION
454             -------------------------------------------------------------------|------------|----------------------------------
455             0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 |  0 - 15    | give amount
456             0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff | 16 - 31    | fee
457         */
458         bytes32     packedInput1;    
459         /* 
460             BITMASK                                                            | BYTE RANGE | DESCRIPTION
461             -------------------------------------------------------------------|------------|----------------------------------
462             0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 |  0 - 15    | rebate
463             0x00000000000000000000000000000000ff000000000000000000000000000000 | 16 - 16    | is reserve
464             0x0000000000000000000000000000000000ffff00000000000000000000000000 | 17 - 18    | identifier
465             0x00000000000000000000000000000000000000ffff0000000000000000000000 | 19 - 20    | giveToken identifier
466             0x000000000000000000000000000000000000000000ffffff0000000000000000 | 21 - 23    | gas_limit
467             0x000000000000000000000000000000000000000000000000ff00000000000000 | 24 - 24    | burn_gas_tokens
468         */
469         bytes32     packedInput2;   
470     }
471     
472     /** @notice Helper function parse an RingTrade struct from an RingTradeInputPacked struct
473       * @param  packed  The RingTradeInputPacked struct to parse
474       * @return The parsed RingTrade struct
475       */
476     function ringTradeFromInput(RingTradeInputPacked memory packed) view public returns(RingTrade memory){
477         return RingTrade({
478             isReserve     : (packed.packedInput2[16] == bytes1(0x01)),
479             identifier    : uint256((       packed.packedInput2 & 0x0000000000000000000000000000000000ffff00000000000000000000000000) >> 104),
480             giveToken     : tokens[uint256((packed.packedInput2 & 0x00000000000000000000000000000000000000ffff0000000000000000000000) >> 88)],
481             giveAmount    : uint256(        packed.packedInput1                                                                       >> 128),
482             fee           : uint256(        packed.packedInput1 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff),
483             rebate        : uint256(        packed.packedInput2                                                                       >> 128),
484             gasLimit      : uint256((       packed.packedInput2 & 0x000000000000000000000000000000000000000000ffffff0000000000000000) >> 64)
485         });
486     }
487 }
488 
489 contract dexBlueSettlementModule is dexBlueStorage, dexBlueEvents, dexBlueUtils, dexBlueStructs{
490     
491     /** @notice Internal helper function to settle a trade between two orders
492       * @param  makerOrder  The maker order
493       * @param  takerOrder  The taker order
494       * @param  trade       The trade to settle between the two
495       * @return Whether the trade succeeded or failed
496       */
497     function matchOrders(
498         Order memory makerOrder,
499         Order memory takerOrder,
500         Trade memory trade
501     ) internal returns (bool){
502         // Load the orders previously matched amounts into memory
503         uint makerOrderMatched = matched[makerOrder.hash];
504         uint takerOrderMatched = matched[takerOrder.hash];
505 
506         if( // Check if the arbiter has matched following the conditions of the two order signees
507             // Do maker and taker want to trade the same tokens with each other
508                makerOrder.buyToken == takerOrder.sellToken
509             && takerOrder.buyToken == makerOrder.sellToken
510             
511             // Are both of the orders still valid
512             && makerOrder.expiry > block.timestamp
513             && takerOrder.expiry > block.timestamp 
514             
515             // Do maker and taker hold the required balances
516             && balances[makerOrder.sellToken][makerOrder.signee] >= trade.makerAmount - trade.makerRebate
517             && balances[takerOrder.sellToken][takerOrder.signee] >= trade.takerAmount
518             
519             // Are they both matched at a rate better or equal to the one they signed
520             && trade.makerAmount - trade.makerRebate <= makerOrder.sellAmount * trade.takerAmount / makerOrder.buyAmount + 1  // Check maker doesn't overpay (+ 1 to deal with rouding errors for very smal amounts)
521             && trade.takerAmount                     <= takerOrder.sellAmount * trade.makerAmount / takerOrder.buyAmount + 1  // Check taker doesn't overpay (+ 1 to deal with rouding errors for very smal amounts)
522             
523             // Check if the order was cancelled
524             && makerOrder.sellAmount > makerOrderMatched
525             && takerOrder.sellAmount > takerOrderMatched
526 
527             // Check if the matched amount + previously matched trades doesn't exceed the amount specified by the order signee
528             && trade.makerAmount - trade.makerRebate + makerOrderMatched <= makerOrder.sellAmount
529             && trade.takerAmount                     + takerOrderMatched <= takerOrder.sellAmount
530                 
531             // Check if the charged fee is not too high
532             && trade.makerFee <= trade.takerAmount / 20
533             && trade.takerFee <= trade.makerAmount / 20
534             
535             // Check if maker_rebate is smaller than or equal to the taker's fee which compensates it
536             && trade.makerRebate <= trade.takerFee
537         ){
538             // Settle the trade:
539             
540             // Substract sold amounts
541             balances[makerOrder.sellToken][makerOrder.signee] -= trade.makerAmount - trade.makerRebate;     // Substract maker's sold amount minus the makers rebate
542             balances[takerOrder.sellToken][takerOrder.signee] -= trade.takerAmount;                         // Substract taker's sold amount
543             
544             // Add bought amounts
545             balances[makerOrder.buyToken][makerOrder.signee] += trade.takerAmount - trade.makerFee;         // Give the maker his bought amount minus the fee
546             balances[takerOrder.buyToken][takerOrder.signee] += trade.makerAmount - trade.takerFee;         // Give the taker his bought amount minus the fee
547             
548             // Save sold amounts to prevent double matching
549             matched[makerOrder.hash] += trade.makerAmount - trade.makerRebate;                              // Prevent maker order from being reused
550             matched[takerOrder.hash] += trade.takerAmount;                                                  // Prevent taker order from being reused
551             
552             // Give fee to feeCollector
553             balances[takerOrder.buyToken][feeCollector] += trade.takerFee - trade.makerRebate;              // Give the feeColletor the taker fee minus the maker rebate 
554             balances[makerOrder.buyToken][feeCollector] += trade.makerFee;                                  // Give the feeColletor the maker fee
555             
556             // Set potential previous blocking of these funds to 0
557             blocked_for_single_sig_withdrawal[makerOrder.sellToken][makerOrder.signee] = 0;                 // If the maker tried to block funds which he/she used in this order we have to unblock them
558             blocked_for_single_sig_withdrawal[takerOrder.sellToken][takerOrder.signee] = 0;                 // If the taker tried to block funds which he/she used in this order we have to unblock them
559             
560             emit LogTrade(makerOrder.sellToken, trade.makerAmount, takerOrder.sellToken, trade.takerAmount);
561 
562             return true;                                                                         
563         }else{
564             return false;                                                                                   
565         }
566     }
567 
568     /** @notice Internal helper function to settle a trade between an order and a reserve
569       * @param  order    The order
570       * @param  reserve  The reserve
571       * @param  trade    The trade to settle between the two
572       * @return Whether the trade succeeded or failed
573       */
574     function matchOrderWithReserve(
575         Order memory order,
576         address      reserve,
577         ReserveTrade memory trade
578     ) internal returns(bool){
579         // Load the orders previously matched amount into memory
580         uint orderMatched = matched[order.hash];
581 
582         if( // Check if the arbiter matched the conditions of the order signee
583             // Does the order signee has the required balances deposited
584             balances[order.sellToken][order.signee] >= trade.orderAmount - trade.orderRebate
585             
586             // Is the order still valid
587             && order.expiry > block.timestamp 
588             
589             // Is the order matched at a rate better or equal to the one specified by the signee
590             && trade.orderAmount - trade.orderRebate <= order.sellAmount * trade.reserveAmount / order.buyAmount + 1  // + 1 to deal with rouding errors
591             
592             // Check if the order was cancelled
593             && order.sellAmount > orderMatched
594 
595             // Check if the matched amount + previously matched trades doesn't exceed the amount specified by the order signee
596             && trade.orderAmount - trade.orderRebate + orderMatched <= order.sellAmount
597                 
598             // Check if the charged fee is not too high
599             && trade.orderFee   <= trade.reserveAmount / 20
600             && trade.reserveFee <= trade.orderAmount   / 20
601             
602             // Check if the rebates can be compensated by the fees
603             && trade.orderRebate   <= trade.reserveFee
604             && trade.reserveRebate <= trade.orderFee
605         ){
606             balances[order.sellToken][order.signee] -= trade.orderAmount - trade.orderRebate;  // Substract users's sold amount minus the makers rebate
607             
608             (bool txSuccess, bytes memory returnData) = address(this).call.gas(
609                     trade.gasLimit                                              // The gas limit for the call
610                 )(
611                     abi.encodePacked(                                           // This encodes the function to call and the parameters we are passing to the settlement function
612                         dexBlue(address(0)).executeReserveTrade.selector,       // This function executes the call to the reserve
613                         abi.encode(                            
614                             order.sellToken,                                    // The token the order signee wants to exchange with the reserve
615                             trade.orderAmount   - trade.reserveFee,             // The reserve receives the sold amount minus the fee
616                             order.buyToken,                                     // The token the order signee wants to receive from the reserve
617                             trade.reserveAmount - trade.reserveRebate,          // The reserve has to return the amount the order want to receive minus
618                             reserve                                             // The reserve the trade is settled with
619                         )
620                     )
621                 );
622             
623             if(
624                txSuccess                                    // The call to the reserve did not fail
625                && abi.decode(returnData, (bool))            // The call returned true (we are sure its a contract we called)
626                // executeReserveTrade checks whether the reserve deposited the funds
627             ){
628                 // Substract the deposited amount from reserves balance
629                 balances[order.buyToken][reserve]      -= trade.reserveAmount - trade.reserveRebate;    // Substract reserves's sold amount
630                 
631                 // The amount to the order signees balance
632                 balances[order.buyToken][order.signee] += trade.reserveAmount - trade.orderFee;         // Give the users his bought amount minus the fee
633                 
634                 // Save sold amounts to prevent double matching
635                 matched[order.hash] += trade.orderAmount - trade.orderRebate;                           // Prevent maker order from being reused
636                 
637                 // Give fee to feeCollector
638                 balances[order.buyToken][feeCollector]  += trade.orderFee   - trade.reserveRebate;      // Give the feeColletor the fee minus the maker rebate
639                 balances[order.sellToken][feeCollector] += trade.reserveFee - trade.orderRebate;        // Give the feeColletor the fee minus the maker rebate
640                 
641                 // Set potential previous blocking of these funds to 0
642                 blocked_for_single_sig_withdrawal[order.sellToken][order.signee] = 0;                   // If the user blocked funds which he/she used in this order we have to unblock them
643 
644                 if(trade.orderIsMaker){
645                     emit LogTrade(order.sellToken, trade.orderAmount, order.buyToken, trade.reserveAmount);
646                 }else{
647                     emit LogTrade(order.buyToken, trade.reserveAmount, order.sellToken, trade.orderAmount);
648                 }
649                 emit LogDirectWithdrawal(reserve, order.sellToken, trade.orderAmount - trade.reserveFee);
650                 
651                 return true;
652             }else{
653                 balances[order.sellToken][order.signee] += trade.orderAmount - trade.orderRebate;  // Refund substracted amount
654                 
655                 return false;
656             }
657         }else{
658             return false;
659         }
660     }
661     
662     /** @notice Internal helper function to settle a trade between an order and a reserve, passing some additional data to the reserve
663       * @param  order    The order
664       * @param  reserve  The reserve
665       * @param  trade    The trade to settle between the two
666       * @param  data     The data to pass along to the reserve
667       * @return Whether the trade succeeded or failed
668       */
669     function matchOrderWithReserveWithData(
670         Order        memory order,
671         address      reserve,
672         ReserveTrade memory trade,
673         bytes32[]    memory data
674     ) internal returns(bool){
675         // Load the orders previously matched amount into memory
676         uint orderMatched = matched[order.hash];
677 
678         if( // Check if the arbiter matched the conditions of the order signee
679             // Does the order signee has the required balances deposited
680             balances[order.sellToken][order.signee] >= trade.orderAmount - trade.orderRebate
681             
682             // Is the order still valid
683             && order.expiry > block.timestamp 
684             
685             // Is the order matched at a rate better or equal to the one specified by the signee
686             && trade.orderAmount - trade.orderRebate <= order.sellAmount * trade.reserveAmount / order.buyAmount + 1  // + 1 to deal with rouding errors
687             
688             // Check if the order was cancelled
689             && order.sellAmount > orderMatched
690 
691             // Check if the matched amount + previously matched trades doesn't exceed the amount specified by the order signee
692             && trade.orderAmount - trade.orderRebate + orderMatched <= order.sellAmount
693                 
694             // Check if the charged fee is not too high
695             && trade.orderFee   <= trade.reserveAmount / 20
696             && trade.reserveFee <= trade.orderAmount   / 20
697             
698             // Check if the rebates can be compensated by the fees
699             && trade.orderRebate   <= trade.reserveFee
700             && trade.reserveRebate <= trade.orderFee
701         ){
702             balances[order.sellToken][order.signee] -= trade.orderAmount - trade.orderRebate;  // Substract users's sold amount minus the makers rebate
703             
704             (bool txSuccess, bytes memory returnData) = address(this).call.gas(
705                     trade.gasLimit                                                  // The gas limit for the call
706                 )(
707                     abi.encodePacked(                                               // This encodes the function to call and the parameters we are passing to the settlement function
708                         dexBlue(address(0)).executeReserveTradeWithData.selector,   // This function executes the call to the reserve
709                         abi.encode(                            
710                             order.sellToken,                                        // The token the order signee wants to exchange with the reserve
711                             trade.orderAmount   - trade.reserveFee,                 // The reserve receives the sold amount minus the fee
712                             order.buyToken,                                         // The token the order signee wants to receive from the reserve
713                             trade.reserveAmount - trade.reserveRebate,              // The reserve has to return the amount the order want to receive minus
714                             reserve,                                                // The reserve the trade is settled with
715                             data                                                    // The data passed on to the reserve
716                         )
717                     )
718                 );
719             
720             if(
721                txSuccess                                    // The call to the reserve did not fail
722                && abi.decode(returnData, (bool))            // The call returned true (we are sure its a contract we called)
723                // executeReserveTrade checks whether the reserve deposited the funds
724             ){
725                 // substract the deposited amount from reserves balance
726                 balances[order.buyToken][reserve]      -= trade.reserveAmount - trade.reserveRebate;    // Substract reserves's sold amount
727                 
728                 // the amount to the order signees balance
729                 balances[order.buyToken][order.signee] += trade.reserveAmount - trade.orderFee;         // Give the users his bought amount minus the fee
730                 
731                 // Save sold amounts to prevent double matching
732                 matched[order.hash] += trade.orderAmount - trade.orderRebate;                           // Prevent maker order from being reused
733                 
734                 // Give fee to feeCollector
735                 balances[order.buyToken][feeCollector]  += trade.orderFee   - trade.reserveRebate;      // Give the feeColletor the fee minus the maker rebate
736                 balances[order.sellToken][feeCollector] += trade.reserveFee - trade.orderRebate;        // Give the feeColletor the fee minus the maker rebate
737                 
738                 // Set potential previous blocking of these funds to 0
739                 blocked_for_single_sig_withdrawal[order.sellToken][order.signee] = 0;                   // If the user blocked funds which he/she used in this order we have to unblock them
740 
741                 if(trade.orderIsMaker){
742                     emit LogTrade(order.sellToken, trade.orderAmount, order.buyToken, trade.reserveAmount);
743                 }else{
744                     emit LogTrade(order.buyToken, trade.reserveAmount, order.sellToken, trade.orderAmount);
745                 }
746                 emit LogDirectWithdrawal(reserve, order.sellToken, trade.orderAmount - trade.reserveFee);
747                 
748                 return true;
749             }else{
750                 balances[order.sellToken][order.signee] += trade.orderAmount - trade.orderRebate;  // Refund substracted amount
751                 
752                 return false;
753             }
754         }else{
755             return false;
756         }
757     }
758     
759     /** @notice internal helper function to settle a trade between two reserves
760       * @param  makerReserve  The maker reserve
761       * @param  takerReserve  The taker reserve
762       * @param  trade         The trade to settle between the two
763       * @return Whether the trade succeeded or failed
764       */
765     function matchReserveWithReserve(
766         address             makerReserve,
767         address             takerReserve,
768         ReserveReserveTrade memory trade
769     ) internal returns(bool){
770 
771         (bool txSuccess, bytes memory returnData) = address(this).call.gas(
772             trade.gasLimit                                                      // The gas limit for the call
773         )(
774             abi.encodePacked(                                                   // This encodes the function to call and the parameters we are passing to the settlement function
775                 dexBlue(address(0)).executeReserveReserveTrade.selector,     // This function executes the call to the reserves
776                 abi.encode(                            
777                     makerReserve,
778                     takerReserve,
779                     trade
780                 )
781             )
782         );
783 
784         return (
785             txSuccess                                    // The call to the reserve did not fail
786             && abi.decode(returnData, (bool))            // The call returned true (we are sure its a contract we called)
787         );
788     }
789 
790     
791     /** @notice internal helper function to settle a trade between two reserves
792       * @param  makerReserve  The maker reserve
793       * @param  takerReserve  The taker reserve
794       * @param  trade         The trade to settle between the two
795       * @param  makerData     The data to pass on to the maker reserve
796       * @param  takerData     The data to pass on to the taker reserve
797       * @return Whether the trade succeeded or failed
798       */
799     function matchReserveWithReserveWithData(
800         address             makerReserve,
801         address             takerReserve,
802         ReserveReserveTrade memory trade,
803         bytes32[] memory    makerData,
804         bytes32[] memory    takerData
805     ) internal returns(bool){
806 
807         (bool txSuccess, bytes memory returnData) = address(this).call.gas(
808             trade.gasLimit                                                       // The gas limit for the call
809         )(
810             abi.encodePacked(                                                    // This encodes the function to call and the parameters we are passing to the settlement function
811                 dexBlue(address(0)).executeReserveReserveTradeWithData.selector, // This function executes the call to the reserves
812                 abi.encode(                            
813                     makerReserve,
814                     takerReserve,
815                     trade,
816                     makerData,
817                     takerData
818                 )
819             )
820         );
821 
822         return (
823             txSuccess                                    // The call to the reserve did not fail
824             && abi.decode(returnData, (bool))            // The call returned true (we are sure its a contract we called)
825         );
826     }
827     
828     /** @notice Allows an arbiter to settle multiple trades between multiple orders and reserves
829       * @param  orderInput     Array of all orders involved in the transactions
830       * @param  tradeInput     Array of the trades to be settled
831       */   
832     function batchSettleTrades(OrderInputPacked[] calldata orderInput, TradeInputPacked[] calldata tradeInput) external {
833         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
834         
835         Order[] memory orders = new Order[](orderInput.length);
836         uint256 i = orderInput.length;
837 
838         while(i-- != 0){                                // Loop through the orderInput array, to parse the infos and restore all signees
839             orders[i] = orderFromInput(orderInput[i]);  // Parse this orders infos
840         }
841         
842         uint256 makerIdentifier;
843         uint256 takerIdentifier;
844         
845         for(i = 0; i < tradeInput.length; i++){
846             makerIdentifier = uint256((tradeInput[i].packedInput3 & 0x0000000000000000000000000000000000ffff00000000000000000000000000) >> 104);
847             takerIdentifier = uint256((tradeInput[i].packedInput3 & 0x00000000000000000000000000000000000000ffff0000000000000000000000) >> 88);
848             
849             if(tradeInput[i].packedInput3[16] == byte(0x11)){       // Both are orders
850                 if(!matchOrders(
851                     orders[makerIdentifier],
852                     orders[takerIdentifier],
853                     tradeFromInput(tradeInput[i])
854                 )){
855                     emit LogTradeFailed();      
856                 }
857             }else if(tradeInput[i].packedInput3[16] == byte(0x10)){ // Maker is order, taker is reserve
858                 if(!matchOrderWithReserve(
859                     orders[makerIdentifier],
860                     reserves[takerIdentifier],
861                     reserveTradeFromInput(tradeInput[i])
862                 )){
863                     emit LogTradeFailed();      
864                 }
865             }else if(tradeInput[i].packedInput3[16] == byte(0x01)){ // Taker is order, maker is reserve
866                 if(!matchOrderWithReserve(
867                     orders[takerIdentifier],
868                     reserves[makerIdentifier],
869                     reserveTradeFromInput(tradeInput[i])
870                 )){
871                     emit LogTradeFailed();      
872                 }
873             }else{                                                  // Both are reserves
874                 if(!matchReserveWithReserve(
875                     reserves[makerIdentifier],
876                     reserves[takerIdentifier],
877                     reserveReserveTradeFromInput(tradeInput[i])
878                 )){
879                     emit LogTradeFailed();      
880                 }
881             }
882         }
883     }
884 
885     /** @notice Allows an arbiter to settle a trade between two orders
886       * @param  makerOrderInput  The packed maker order input
887       * @param  takerOrderInput  The packed taker order input
888       * @param  tradeInput       The packed trade to settle between the two
889       */ 
890     function settleTrade(OrderInputPacked calldata makerOrderInput, OrderInputPacked calldata takerOrderInput, TradeInputPacked calldata tradeInput) external {
891         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
892         
893         if(!matchOrders(
894             orderFromInput(makerOrderInput),
895             orderFromInput(takerOrderInput),
896             tradeFromInput(tradeInput)
897         )){
898             emit LogTradeFailed();      
899         }
900     }
901         
902     /** @notice Allows an arbiter to settle a trade between an order and a reserve
903       * @param  orderInput  The packed maker order input
904       * @param  tradeInput  The packed trade to settle between the two
905       */ 
906     function settleReserveTrade(OrderInputPacked calldata orderInput, TradeInputPacked calldata tradeInput) external {
907         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
908         
909         if(!matchOrderWithReserve(
910             orderFromInput(orderInput),
911             reserves[
912                 tradeInput.packedInput3[16] == byte(0x01) ? // is maker reserve
913                     // maker is reserve
914                     uint256((tradeInput.packedInput3 & 0x0000000000000000000000000000000000ffff00000000000000000000000000) >> 104) :
915                     // taker is reserve
916                     uint256((tradeInput.packedInput3 & 0x00000000000000000000000000000000000000ffff0000000000000000000000) >> 88)
917             ],
918             reserveTradeFromInput(tradeInput)
919         )){
920             emit LogTradeFailed();      
921         }
922     }
923 
924     /** @notice Allows an arbiter to settle a trade between an order and a reserve
925       * @param  orderInput  The packed maker order input
926       * @param  tradeInput  The packed trade to settle between the two
927       * @param  data        The data to pass on to the reserve
928       */ 
929     function settleReserveTradeWithData(
930         OrderInputPacked calldata orderInput, 
931         TradeInputPacked calldata tradeInput,
932         bytes32[] calldata        data
933     ) external {
934         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
935         
936         if(!matchOrderWithReserveWithData(
937             orderFromInput(orderInput),
938             reserves[
939                 tradeInput.packedInput3[16] == byte(0x01) ? // Is maker reserve
940                     // maker is reserve
941                     uint256((tradeInput.packedInput3 & 0x0000000000000000000000000000000000ffff00000000000000000000000000) >> 104) :
942                     // taker is reserve
943                     uint256((tradeInput.packedInput3 & 0x00000000000000000000000000000000000000ffff0000000000000000000000) >> 88)
944             ],
945             reserveTradeFromInput(tradeInput),
946             data
947         )){
948             emit LogTradeFailed();      
949         }
950     }
951     
952     /** @notice Allows an arbiter to settle a trade between two reserves
953       * @param  tradeInput  The packed trade to settle between the two
954       */ 
955     function settleReserveReserveTrade(
956         TradeInputPacked calldata tradeInput
957     ) external {
958         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
959         
960         if(!matchReserveWithReserve(
961             reserves[uint256((tradeInput.packedInput3 & 0x0000000000000000000000000000000000ffff00000000000000000000000000) >> 104)],
962             reserves[uint256((tradeInput.packedInput3 & 0x00000000000000000000000000000000000000ffff0000000000000000000000) >> 88)],
963             reserveReserveTradeFromInput(tradeInput)
964         )){
965             emit LogTradeFailed();      
966         }
967     }
968     
969     /** @notice Allows an arbiter to settle a trade between two reserves
970       * @param  tradeInput  The packed trade to settle between the two
971       * @param  makerData   The data to pass on to the maker reserve
972       * @param  takerData   The data to pass on to the taker reserve
973       */ 
974     function settleReserveReserveTradeWithData(
975         TradeInputPacked calldata tradeInput,
976         bytes32[] calldata        makerData,
977         bytes32[] calldata        takerData
978     ) external {
979         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
980         
981         if(!matchReserveWithReserveWithData(
982             reserves[uint256((tradeInput.packedInput3 & 0x0000000000000000000000000000000000ffff00000000000000000000000000) >> 104)],
983             reserves[uint256((tradeInput.packedInput3 & 0x00000000000000000000000000000000000000ffff0000000000000000000000) >> 88)],
984             reserveReserveTradeFromInput(tradeInput),
985             makerData,
986             takerData
987         )){
988             emit LogTradeFailed();      
989         }
990     }
991     
992     /** @notice Allow arbiters to settle a ring of order and reserve trades
993       * @param  orderInput Array of OrderInputPacked structs
994       * @param  tradeInput Array of RingTradeInputPacked structs
995       */
996     function settleRingTrade(OrderInputPacked[] calldata orderInput, RingTradeInputPacked[] calldata tradeInput) external {
997         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
998         
999         // Parse Orders from packed input
1000         uint256 i = orderInput.length;
1001         Order[] memory orders = new Order[](i);
1002         while(i-- != 0){
1003             orders[i] = orderFromInput(orderInput[i]);
1004         }
1005         
1006         // Parse RingTrades from packed input
1007         i = tradeInput.length;
1008         RingTrade[] memory trades = new RingTrade[](i);
1009         while(i-- != 0){
1010             trades[i] = ringTradeFromInput(tradeInput[i]);
1011         }
1012         
1013         uint256 prev = trades.length - 1;
1014         uint256 next = 1;
1015          // Loop through the RingTrades array and settle each participants trade
1016         for(i = 0; i < trades.length; i++){
1017             
1018             require(
1019                 // Check if the charged fee is not too high
1020                 trades[i].fee       <= trades[prev].giveAmount / 20
1021                 
1022                 // Check if maker_rebate is smaller than or equal to the taker's fee which compensates it
1023                 && trades[i].rebate <= trades[next].fee
1024             );
1025             
1026             if(trades[i].isReserve){ // Ring element is a reserve
1027                 address reserve = reserves[trades[i].identifier];
1028 
1029                 if(i == 0){
1030                     require(
1031                         dexBlueReserve(reserve).offer(
1032                             trades[i].giveToken,                                   // The token the reserve would sell
1033                             trades[i].giveAmount - trades[i].rebate,               // The amount the reserve would sell
1034                             trades[prev].giveToken,                                // The token the reserve would receive
1035                             trades[prev].giveAmount - trades[i].fee                // The amount the reserve would receive
1036                         )
1037                         && balances[trades[i].giveToken][reserve] >= trades[i].giveAmount
1038                     );
1039                 }else{
1040                     uint256 receiveAmount = trades[prev].giveAmount - trades[i].fee;
1041 
1042                     if(trades[prev].giveToken != address(0)){
1043                         Token(trades[prev].giveToken).transfer(reserve, receiveAmount);  // Send collateral to reserve
1044                         require(                                                         // Revert if the send failed
1045                             checkERC20TransferSuccess(),
1046                             "ERC20 token transfer failed."
1047                         );
1048                     }
1049 
1050                     require(
1051                         dexBlueReserve(reserve).trade.value(
1052                             trades[prev].giveToken == address(0) ? receiveAmount : 0
1053                         )(             
1054                             trades[prev].giveToken,
1055                             receiveAmount,                                      // Reserve gets the reserve_buy_amount minus the fee
1056                             trades[i].giveToken,    
1057                             trades[i].giveAmount - trades[i].rebate             // Reserve has to give reserve_sell_amount minus the rebate
1058                         )
1059                     );
1060                 }
1061 
1062                 // Substract deposited amount from reserves balance
1063                 balances[trades[i].giveToken][reserve] -= trades[i].giveAmount - trades[i].rebate;
1064 
1065                 emit LogDirectWithdrawal(reserve, trades[prev].giveToken, trades[prev].giveAmount - trades[i].fee);
1066             }else{ // Ring element is an order
1067                 
1068                 Order memory order = orders[trades[i].identifier];  // Cache order
1069 
1070                 uint256 orderMatched = matched[order.hash];
1071                 
1072                 require(
1073                     // Does the order signee want to trade the last elements giveToken and this elements giveToken
1074                        order.buyToken  == trades[prev].giveToken
1075                     && order.sellToken == trades[i].giveToken
1076                     
1077                     // Is the order still valid
1078                     && order.expiry > block.timestamp
1079                     
1080                     // Does the order signee hold the required balances
1081                     && balances[order.sellToken][order.signee] >= trades[i].giveAmount - trades[i].rebate
1082                     
1083                     // Is the order matched at a rate better or equal to the one the order signee signed
1084                     && trades[i].giveAmount - trades[i].rebate <= order.sellAmount * trades[prev].giveAmount / order.buyAmount + 1  // Check order doesn't overpay (+ 1 to deal with rouding errors for very smal amounts)
1085                     
1086                     // Check if the order was cancelled
1087                     && order.sellAmount > orderMatched
1088                     
1089                     // Do the matched amount + previously matched trades not exceed the amount specified by the order signee
1090                     && trades[i].giveAmount - trades[i].rebate + orderMatched <= order.sellAmount
1091                 );
1092                 
1093                 // Substract the sold amounts
1094                 balances[order.sellToken       ][order.signee] -= trades[i].giveAmount - trades[i].rebate;      // Substract sold amount minus the makers rebate from order signees balance
1095                 
1096                 // Add bought amounts
1097                 balances[trades[prev].giveToken][order.signee] += trades[prev].giveAmount - trades[i].fee;      // Give the order signee his bought amount minus the fee
1098                 
1099                 // Save sold amounts to prevent double matching
1100                 matched[order.hash] += trades[i].giveAmount - trades[i].rebate;                                 // Prevent order from being reused
1101                 
1102                 // Set potential previous blocking of these funds to 0
1103                 blocked_for_single_sig_withdrawal[order.sellToken][order.signee] = 0;                           // If the order signee tried to block funds which he/she used in this order we have to unblock them
1104             }
1105 
1106             emit LogTrade(trades[prev].giveToken, trades[prev].giveAmount, trades[i].giveToken, trades[i].giveAmount);
1107             
1108             // Give fee to feeCollector
1109             balances[trades[prev].giveToken][feeCollector] += trades[i].fee - trades[prev].rebate;              // Give the feeColletor the fee minus the maker rebate 
1110             
1111             prev = i;
1112             if(i == trades.length - 2){
1113                 next = 0;
1114             }else{
1115                 next = i + 2;
1116             }
1117         }
1118 
1119         if(trades[0].isReserve){
1120             address payable reserve = reserves[trades[0].identifier];
1121             prev = trades.length - 1;
1122             
1123             if(trades[prev].giveToken == address(0)){                                                       // Is the withdrawal token ETH
1124                 require(
1125                     reserve.send(trades[prev].giveAmount - trades[0].fee),                                  // Withdraw ETH
1126                     "Sending of ETH failed."
1127                 );
1128             }else{
1129                 Token(trades[prev].giveToken).transfer(reserve, trades[prev].giveAmount - trades[0].fee);   // Withdraw ERC20
1130                 require(                                                                                    // Revert if the withdrawal failed
1131                     checkERC20TransferSuccess(),
1132                     "ERC20 token transfer failed."
1133                 );
1134             }
1135 
1136             // Notify the reserve, that the offer got executed
1137             dexBlueReserve(reserve).offerExecuted(
1138                 trades[0].giveToken,                                   // The token the reserve sold
1139                 trades[0].giveAmount - trades[0].rebate,               // The amount the reserve sold
1140                 trades[prev].giveToken,                                // The token the reserve received
1141                 trades[prev].giveAmount - trades[0].fee                // The amount the reserve received
1142             );
1143         }
1144     }
1145     
1146     
1147     /** @notice Allow arbiters to settle a ring of order and reserve trades, passing on some data to the reserves
1148       * @param  orderInput Array of OrderInputPacked structs
1149       * @param  tradeInput Array of RingTradeInputPacked structs
1150       * @param  data       Array of data to pass along to the reserves
1151       */
1152     function settleRingTradeWithData(
1153         OrderInputPacked[]     calldata orderInput,
1154         RingTradeInputPacked[] calldata tradeInput,
1155         bytes32[][]            calldata data
1156     ) external {
1157         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
1158         
1159         // Parse Orders from packed input
1160         uint256 i = orderInput.length;
1161         Order[] memory orders = new Order[](i);
1162         while(i-- != 0){
1163             orders[i] = orderFromInput(orderInput[i]);
1164         }
1165         
1166         // Parse RingTrades from packed input
1167         i = tradeInput.length;
1168         RingTrade[] memory trades = new RingTrade[](i);
1169         while(i-- != 0){
1170             trades[i] = ringTradeFromInput(tradeInput[i]);
1171         }
1172         
1173         uint256 prev = trades.length - 1;
1174         uint256 next = 1;
1175          // Loop through the RingTrades array and settle each participants trade
1176         for(i = 0; i < trades.length; i++){
1177             
1178             require(
1179                 // Check if the charged fee is not too high
1180                 trades[i].fee       <= trades[prev].giveAmount / 20
1181                 
1182                 // Check if maker_rebate is smaller than or equal to the taker's fee which compensates it
1183                 && trades[i].rebate <= trades[next].fee
1184             );
1185             
1186             if(trades[i].isReserve){ // ring element is a reserve
1187                 address reserve = reserves[trades[i].identifier];
1188 
1189                 if(i == 0){
1190                     require(
1191                         dexBlueReserve(reserve).offerWithData(
1192                             trades[i].giveToken,                                   // The token the reserve would sell
1193                             trades[i].giveAmount - trades[i].rebate,               // The amount the reserve would sell
1194                             trades[prev].giveToken,                                // The token the reserve would receive
1195                             trades[prev].giveAmount - trades[i].fee,               // The amount the reserve would receive
1196                             data[i]                                                // The data to pass along to the reserve
1197                         )
1198                         && balances[trades[i].giveToken][reserve] >= trades[i].giveAmount
1199                     );
1200                 }else{
1201                     uint256 receiveAmount = trades[prev].giveAmount - trades[i].fee;
1202 
1203                     if(trades[prev].giveToken != address(0)){
1204                         Token(trades[prev].giveToken).transfer(reserve, receiveAmount);  // Send collateral to reserve
1205                         require(                                                         // Revert if the send failed
1206                             checkERC20TransferSuccess(),
1207                             "ERC20 token transfer failed."
1208                         );
1209                     }
1210 
1211                     require(
1212                         dexBlueReserve(reserve).tradeWithData.value(
1213                             trades[prev].giveToken == address(0) ? receiveAmount : 0
1214                         )(             
1215                             trades[prev].giveToken,
1216                             receiveAmount,                                      // Reserve gets the reserve_buy_amount minus the fee
1217                             trades[i].giveToken,    
1218                             trades[i].giveAmount - trades[i].rebate,            // Reserve has to give reserve_sell_amount minus the reserve rebate
1219                             data[i]                                             // The data to pass along to the reserve
1220                         )
1221                     );
1222                 }
1223 
1224                 // Substract deposited amount from reserves balance
1225                 balances[trades[i].giveToken][reserve] -= trades[i].giveAmount - trades[i].rebate;
1226 
1227                 emit LogDirectWithdrawal(reserve, trades[prev].giveToken, trades[prev].giveAmount - trades[i].fee);
1228             }else{ // Ring element is an order
1229                 
1230                 Order memory order = orders[trades[i].identifier];  // Cache order
1231 
1232                 uint256 orderMatched = matched[order.hash];
1233                 
1234                 require(
1235                     // Does the order signee want to trade the last elements giveToken and this elements giveToken
1236                        order.buyToken  == trades[prev].giveToken
1237                     && order.sellToken == trades[i].giveToken
1238                     
1239                     // Is the order still valid
1240                     && order.expiry > block.timestamp
1241                     
1242                     // Does the order signee hold the required balances
1243                     && balances[order.sellToken][order.signee] >= trades[i].giveAmount - trades[i].rebate
1244                     
1245                     // Is the order matched at a rate better or equal to the one the order signee signed
1246                     && trades[i].giveAmount - trades[i].rebate <= order.sellAmount * trades[prev].giveAmount / order.buyAmount + 1  // Check order doesn't overpay (+ 1 to deal with rouding errors for very smal amounts)
1247                     
1248                     // Check if the order was cancelled
1249                     && order.sellAmount > orderMatched
1250                     
1251                     // Do the matched amount + previously matched trades not exceed the amount specified by the order signee
1252                     && trades[i].giveAmount - trades[i].rebate + orderMatched <= order.sellAmount
1253                 );
1254                 
1255                 // Substract the sold amounts
1256                 balances[order.sellToken       ][order.signee] -= trades[i].giveAmount - trades[i].rebate;      // Substract sold amount minus the makers rebate from order signees balance
1257                 
1258                 // Add bought amounts
1259                 balances[trades[prev].giveToken][order.signee] += trades[prev].giveAmount - trades[i].fee;      // Give the order signee his bought amount minus the fee
1260                 
1261                 // Save sold amounts to prevent double matching
1262                 matched[order.hash] += trades[i].giveAmount - trades[i].rebate;                                 // Prevent order from being reused
1263                 
1264                 // Set potential previous blocking of these funds to 0
1265                 blocked_for_single_sig_withdrawal[order.sellToken][order.signee] = 0;                           // If the order signee tried to block funds which he/she used in this order we have to unblock them
1266             }
1267 
1268             emit LogTrade(trades[prev].giveToken, trades[prev].giveAmount, trades[i].giveToken, trades[i].giveAmount);
1269             
1270             // Give fee to feeCollector
1271             balances[trades[prev].giveToken][feeCollector] += trades[i].fee - trades[prev].rebate;              // Give the feeColletor the fee minus the maker rebate 
1272             
1273             prev = i;
1274             if(i == trades.length - 2){
1275                 next = 0;
1276             }else{
1277                 next = i + 2;
1278             }
1279         }
1280 
1281         if(trades[0].isReserve){
1282             address payable reserve = reserves[trades[0].identifier];
1283             prev = trades.length - 1;
1284             
1285             if(trades[prev].giveToken == address(0)){                                                       // Is the withdrawal token ETH
1286                 require(
1287                     reserve.send(trades[prev].giveAmount - trades[0].fee),                                  // Withdraw ETH
1288                     "Sending of ETH failed."
1289                 );
1290             }else{
1291                 Token(trades[prev].giveToken).transfer(reserve, trades[prev].giveAmount - trades[0].fee);   // Withdraw ERC20
1292                 require(                                                                                    // Revert if the withdrawal failed
1293                     checkERC20TransferSuccess(),
1294                     "ERC20 token transfer failed."
1295                 );
1296             }
1297 
1298             // Notify the reserve, that the offer got executed
1299             dexBlueReserve(reserve).offerExecuted(
1300                 trades[0].giveToken,                                   // The token the reserve sold
1301                 trades[0].giveAmount - trades[0].rebate,               // The amount the reserve sold
1302                 trades[prev].giveToken,                                // The token the reserve received
1303                 trades[prev].giveAmount - trades[0].fee                // The amount the reserve received
1304             );
1305         }
1306     }
1307     
1308     
1309     // Swapping functions
1310     
1311     /** @notice Queries best output for a trade currently available from the reserves
1312       * @param  sell_token   The token the user wants to sell (ETH is address(0))
1313       * @param  sell_amount  The amount of sell_token to sell
1314       * @param  buy_token    The token the user wants to acquire (ETH is address(0))
1315       * @return The output amount the reserve with the best price offers
1316     */
1317     function getSwapOutput(address sell_token, uint256 sell_amount, address buy_token) public view returns (uint256){
1318         (, uint256 output) = getBestReserve(sell_token, sell_amount, buy_token);
1319         return output;
1320     }
1321     
1322     /** @notice Queries the reserve address and output of trade, of the reserve which offers the best deal on a trade
1323       * @param  sell_token   The token the user wants to sell (ETH is address(0))
1324       * @param  sell_amount  The amount of sell_token to sell
1325       * @param  buy_token    The token the user wants to acquire (ETH is address(0))
1326       * @return The address of the reserve offering the best deal and the expected output of the trade
1327     */
1328     function getBestReserve(address sell_token, uint256 sell_amount, address buy_token) public view returns (address, uint256){
1329         address bestReserve;
1330         uint256 bestOutput = 0;
1331         uint256 output;
1332         
1333         for(uint256 i = 0; i < public_reserve_arr.length; i++){
1334             output = dexBlueReserve(public_reserve_arr[i]).getSwapOutput(sell_token, sell_amount, buy_token);
1335             if(output > bestOutput){
1336                 bestOutput  = output;
1337                 bestReserve = public_reserve_arr[i];
1338             }
1339         }
1340         
1341         return (bestReserve, bestOutput);
1342     }
1343     
1344     /** @notice Allows users to swap a token or ETH with the reserve offering the best price for his trade
1345       * @param  sell_token   The token the user wants to sell (ETH is address(0))
1346       * @param  sell_amount  The amount of sell_token to sell
1347       * @param  buy_token    The token the user wants to acquire (ETH is address(0))
1348       * @param  min_output   The minimum amount of buy_token, the trade should result in 
1349       * @param  deadline     The timestamp after which the transaction should not be executed
1350       * @return The amount of buy_token the user receives
1351     */
1352     function swap(address sell_token, uint256 sell_amount, address buy_token,  uint256 min_output, uint256 deadline) external payable returns(uint256){        
1353         require(
1354             (
1355                 deadline == 0                               // No deadline is set         
1356                 || deadline > block.timestamp               // Deadline is met
1357             ),                                              // Check whether the deadline is met
1358             "Call deadline exceeded."
1359         );
1360         
1361         (address reserve, uint256 amount) = getBestReserve(sell_token, sell_amount, buy_token);     // Check which reserve offers the best deal on the trade
1362         
1363         require(
1364             amount >= min_output,                                                                   // Check whether the best reserves deal is good enough
1365             "Too much slippage"
1366         );
1367         
1368         return swapWithReserve(sell_token, sell_amount, buy_token,  min_output, reserve, deadline); // Execute the swap with the best reserve
1369     }
1370     
1371     /** @notice Allows users to swap a token or ETH with a specified reserve
1372       * @param  sell_token   The token the user wants to sell (ETH is address(0))
1373       * @param  sell_amount  The amount of sell_token to sell
1374       * @param  buy_token    The token the user wants to acquire (ETH is address(0))
1375       * @param  min_output   The minimum amount of buy_token, the trade should result in 
1376       * @param  reserve      The address of the reserve to trade with
1377       * @param  deadline     The timestamp after which the transaction should not be executed
1378     */
1379     function swapWithReserve(address sell_token, uint256 sell_amount, address buy_token,  uint256 min_output, address reserve, uint256 deadline) public payable returns (uint256){
1380         require(
1381             (
1382                 deadline == 0                               // No deadline is set         
1383                 || deadline > block.timestamp               // Deadline is met
1384             ),
1385             "Call deadline exceeded."
1386         );
1387         
1388         require(
1389             public_reserves[reserve],                       // Check whether the reserve is registered
1390             "Unknown reserve."
1391         );
1392         
1393         if(sell_token == address(0)){                       // Caller wants to swap ETH
1394             require(
1395                 msg.value == sell_amount,                   // Check whether the caller sent the required ETH
1396                 "ETH amount not sent with the call."
1397             );
1398         }else{                                              // Caller wants to swap a token
1399             require(
1400                 msg.value == 0,                             // Check the caller hasn't sent any ETH with the call
1401                 "Don't send ETH when swapping a token."
1402             );
1403             
1404             Token(sell_token).transferFrom(msg.sender, reserve, sell_amount);   // Deposit ERC20 into the reserve
1405             
1406             require(
1407                 checkERC20TransferSuccess(),                // Check whether the ERC20 token transfer was successful
1408                 "ERC20 token transfer failed."
1409             );
1410         }
1411         
1412         // Execute the swap with the reserve
1413         uint256 output = dexBlueReserve(reserve).swap.value(msg.value)(
1414             sell_token,
1415             sell_amount,
1416             buy_token,
1417             min_output
1418         );
1419         
1420         if(
1421             output >= min_output                                // Check whether the output amount is sufficient 
1422             && balances[buy_token][reserve] >= output           // Check whether the reserve deposited the output amount
1423         ){
1424             balances[buy_token][reserve] -= output;             // Substract the amount from the reserves balance
1425             
1426             if(buy_token == address(0)){                        // Is the bought asset ETH
1427                 require(
1428                     msg.sender.send(output),                    // Send the output ETH of the swap to msg.sender
1429                     "Sending of ETH failed."
1430                 );
1431             }else{
1432                 Token(buy_token).transfer(msg.sender, output);  // Transfer the output token of the swap msg.sender
1433                 require(                                        // Revert if the transfer failed
1434                     checkERC20TransferSuccess(),
1435                     "ERC20 token transfer failed."
1436                 );
1437             }
1438 
1439             emit LogSwap(sell_token, sell_amount, buy_token, output);
1440             
1441             return output;
1442         }else{
1443             revert("Too much slippage.");
1444         }
1445     }
1446 }
1447 
1448 contract dexBlue is dexBlueStorage, dexBlueEvents, dexBlueUtils, dexBlueStructs{
1449     // Hardcode settlement module contract:
1450     address constant settlementModuleAddress = 0x9e3d5C6ffACA00cAf136609680b536DC0Eb20c66;
1451 
1452     // Deposit functions:
1453 
1454     /** @notice Deposit Ether into the smart contract 
1455       */
1456     function depositEther() public payable{
1457         balances[address(0)][msg.sender] += msg.value;          // Add the received ETH to the users balance
1458         emit LogDeposit(msg.sender, address(0), msg.value);     // emit LogDeposit event
1459     }
1460     
1461     /** @notice Fallback function to credit ETH sent to the contract without data 
1462       */
1463     function() external payable{
1464         if(msg.sender != wrappedEtherContract){     // ETH sends from WETH contract are handled in the depositWrappedEther() function
1465             depositEther();                 // Call the deposit function to credit ETH sent in this transaction
1466         }
1467     }
1468     
1469     /** @notice Deposit Wrapped Ether (remember to set allowance in the token contract first)
1470       * @param  amount  The amount of WETH to deposit 
1471       */
1472     address constant wrappedEtherContract = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // We hardcode the address, to prevent misbehaviour through custom contracts (reentrancy etc)
1473     function depositWrappedEther(uint256 amount) external {
1474         
1475         Token(wrappedEtherContract).transferFrom(msg.sender, address(this), amount);    // Transfer WETH to this contract
1476         
1477         require(
1478             checkERC20TransferSuccess(),                                        // Check whether the ERC20 token transfer was successful
1479             "WETH deposit failed."
1480         );
1481         
1482         uint balanceBefore = address(this).balance;                             // Remember ETH balance before the call
1483         
1484         WETH(wrappedEtherContract).withdraw(amount);                            // Unwrap the WETH
1485         
1486         require(balanceBefore + amount == address(this).balance);               // Check whether the ETH was deposited
1487         
1488         balances[address(0)][msg.sender] += amount;                             // Credit the deposited eth to users balance
1489         
1490         emit LogDeposit(msg.sender, address(0), amount);                        // emit LogDeposit event
1491     }
1492     
1493     /** @notice Deposit ERC20 tokens into the smart contract (remember to set allowance in the token contract first)
1494       * @param  token   The address of the token to deposit
1495       * @param  amount  The amount of tokens to deposit 
1496       */
1497     function depositToken(address token, uint256 amount) external {
1498         Token(token).transferFrom(msg.sender, address(this), amount);    // Deposit ERC20
1499         require(
1500             checkERC20TransferSuccess(),                                 // Check whether the ERC20 token transfer was successful
1501             "ERC20 token transfer failed."
1502         );
1503         balances[token][msg.sender] += amount;                           // Credit the deposited token to users balance
1504         emit LogDeposit(msg.sender, token, amount);                      // emit LogDeposit event
1505     }
1506         
1507     // Multi-sig withdrawal functions:
1508 
1509     /** @notice User-submitted withdrawal with arbiters signature, which withdraws to the users address
1510       * @param  token   The token to withdraw (ETH is address(address(0)))
1511       * @param  amount  The amount of tokens to withdraw
1512       * @param  nonce   The nonce (to salt the hash)
1513       * @param  v       Multi-signature v
1514       * @param  r       Multi-signature r
1515       * @param  s       Multi-signature s 
1516       */
1517     function multiSigWithdrawal(address token, uint256 amount, uint64 nonce, uint8 v, bytes32 r, bytes32 s) external {
1518         multiSigSend(token, amount, nonce, v, r, s, msg.sender); // Call multiSigSend to send funds to msg.sender
1519     }    
1520 
1521     /** @notice User-submitted withdrawal with arbiters signature, which sends tokens to specified address
1522       * @param  token              The token to withdraw (ETH is address(address(0)))
1523       * @param  amount             The amount of tokens to withdraw
1524       * @param  nonce              The nonce (to salt the hash)
1525       * @param  v                  Multi-signature v
1526       * @param  r                  Multi-signature r
1527       * @param  s                  Multi-signature s
1528       * @param  receiving_address  The address to send the withdrawn token/ETH to
1529       */
1530     function multiSigSend(address token, uint256 amount, uint64 nonce, uint8 v, bytes32 r, bytes32 s, address payable receiving_address) public {
1531         bytes32 hash = keccak256(abi.encodePacked(                      // Calculate the withdrawal hash from the parameters 
1532             "\x19Ethereum Signed Message:\n32", 
1533             keccak256(abi.encodePacked(
1534                 msg.sender,
1535                 token,
1536                 amount,
1537                 nonce,
1538                 address(this)
1539             ))
1540         ));
1541         if(
1542             !processed_withdrawals[hash]                                // Check if the withdrawal was initiated before
1543             && arbiters[ecrecover(hash, v,r,s)]                         // Check if the multi-sig is valid
1544             && balances[token][msg.sender] >= amount                    // Check if the user holds the required balance
1545         ){
1546             processed_withdrawals[hash]  = true;                        // Mark this withdrawal as processed
1547             balances[token][msg.sender] -= amount;                      // Substract the withdrawn balance from the users balance
1548             
1549             if(token == address(0)){                                    // Process an ETH withdrawal
1550                 require(
1551                     receiving_address.send(amount),
1552                     "Sending of ETH failed."
1553                 );
1554             }else{                                                      // Withdraw an ERC20 token
1555                 Token(token).transfer(receiving_address, amount);       // Transfer the ERC20 token
1556                 require(
1557                     checkERC20TransferSuccess(),                        // Check whether the ERC20 token transfer was successful
1558                     "ERC20 token transfer failed."
1559                 );
1560             }
1561 
1562             blocked_for_single_sig_withdrawal[token][msg.sender] = 0;   // Set potential previous blocking of these funds to 0
1563             
1564             emit LogWithdrawal(msg.sender,token,amount);                // emit LogWithdrawal event
1565         }else{
1566             revert();                                                   // Revert the transaction if checks fail
1567         }
1568     }
1569 
1570     /** @notice User-submitted transfer with arbiters signature, which sends tokens to another addresses account in the smart contract
1571       * @param  token              The token to transfer (ETH is address(address(0)))
1572       * @param  amount             The amount of tokens to transfer
1573       * @param  nonce              The nonce (to salt the hash)
1574       * @param  v                  Multi-signature v
1575       * @param  r                  Multi-signature r
1576       * @param  s                  Multi-signature s
1577       * @param  receiving_address  The address to transfer the token/ETH to
1578       */
1579     function multiSigTransfer(address token, uint256 amount, uint64 nonce, uint8 v, bytes32 r, bytes32 s, address receiving_address) external {
1580         bytes32 hash = keccak256(abi.encodePacked(                      // Calculate the withdrawal/transfer hash from the parameters 
1581             "\x19Ethereum Signed Message:\n32", 
1582             keccak256(abi.encodePacked(
1583                 msg.sender,
1584                 token,
1585                 amount,
1586                 nonce,
1587                 address(this)
1588             ))
1589         ));
1590         if(
1591             !processed_withdrawals[hash]                                // Check if the withdrawal was initiated before
1592             && arbiters[ecrecover(hash, v,r,s)]                         // Check if the multi-sig is valid
1593             && balances[token][msg.sender] >= amount                    // Check if the user holds the required balance
1594         ){
1595             processed_withdrawals[hash]         = true;                 // Mark this withdrawal as processed
1596             balances[token][msg.sender]        -= amount;               // Substract the balance from the withdrawing account
1597             balances[token][receiving_address] += amount;               // Add the balance to the receiving account
1598             
1599             blocked_for_single_sig_withdrawal[token][msg.sender] = 0;   // Set potential previous blocking of these funds to 0
1600             
1601             emit LogWithdrawal(msg.sender,token,amount);                // emit LogWithdrawal event
1602             emit LogDeposit(receiving_address,token,amount);            // emit LogDeposit event
1603         }else{
1604             revert();                                                   // Revert the transaction if checks fail
1605         }
1606     }
1607     
1608     /** @notice Arbiter submitted withdrawal with users multi-sig to users address
1609       * @param  packedInput1 tightly packed input arguments:
1610       *             amount  The amount of tokens to withdraw
1611       *             fee     The fee, covering the gas cost of the arbiter
1612       * @param  packedInput2 tightly packed input arguments:
1613       *             token           The token to withdraw (ETH is address(address(0)))
1614       *             nonce           The nonce (to salt the hash)
1615       *             v               Multi-signature v (either 27 or 28. To identify the different signing schemes an offset of 10 is applied for EIP712)
1616       *             signing_scheme  The signing scheme of the users signature
1617       *             burn_gas_tokens The amount of gas tokens to burn
1618       * @param  r       Multi-signature r
1619       * @param  s       Multi-signature s
1620       */
1621     function userSigWithdrawal(bytes32 packedInput1, bytes32 packedInput2, bytes32 r, bytes32 s) external {
1622         /* 
1623             BITMASK packedInput1                                               | BYTE RANGE | DESCRIPTION
1624             -------------------------------------------------------------------|------------|----------------------------------
1625             0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 |  0-15      | amount
1626             0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff | 16-31      | gas fee
1627             
1628             BITMASK packedInput2                                               | BYTE RANGE | DESCRIPTION
1629             -------------------------------------------------------------------|------------|----------------------------------
1630             0xffff000000000000000000000000000000000000000000000000000000000000 |  0- 1      | token identifier
1631             0x0000ffffffffffffffff00000000000000000000000000000000000000000000 |  2- 9      | nonce
1632             0x00000000000000000000ff000000000000000000000000000000000000000000 | 10-10      | v
1633             0x0000000000000000000000ff0000000000000000000000000000000000000000 | 11-11      | signing scheme 0x00 = personal.sign, 0x01 = EIP712
1634             0x000000000000000000000000ff00000000000000000000000000000000000000 | 12-12      | burn_gas_tokens
1635         */
1636         // parse the packed input parameters
1637         uint256 amount = uint256(packedInput1 >> 128);
1638         uint256 fee    = uint256(packedInput1 & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff);
1639         address token  = tokens[uint256(packedInput2 >> 240)];
1640         uint64  nonce  = uint64(uint256((packedInput2 & 0x0000ffffffffffffffff00000000000000000000000000000000000000000000) >> 176));
1641         uint8   v      = uint8(packedInput2[10]);
1642 
1643         bytes32 hash;
1644         if(packedInput2[11] == byte(0x00)){                             // Standard signing scheme (personal.sign())
1645             hash = keccak256(abi.encodePacked(                          // Restore multi-sig hash
1646                 "\x19Ethereum Signed Message:\n32",
1647                 keccak256(abi.encodePacked(
1648                     token,
1649                     amount,
1650                     nonce,
1651                     address(this)
1652                 ))
1653             ));
1654         }else{                                                          // EIP712 signing scheme
1655             hash = keccak256(abi.encodePacked(                          // Restore multi-sig hash
1656                 "\x19\x01",
1657                 EIP712_DOMAIN_SEPARATOR,
1658                 keccak256(abi.encode(
1659                     EIP712_WITHDRAWAL_TYPEHASH,
1660                     token,
1661                     amount,
1662                     nonce
1663                 ))
1664             ));
1665         }
1666 
1667         address payable account = address(uint160(ecrecover(hash, v, r, s)));   // Restore signing address
1668         
1669         if(
1670             !processed_withdrawals[hash]                                // Check if the withdrawal was initiated before
1671             && arbiters[msg.sender]                                     // Check if transaction comes from arbiter
1672             && fee <= amount / 20                                       // Check if fee is not too big
1673             && balances[token][account] >= amount                       // Check if the user holds the required tokens
1674         ){
1675             processed_withdrawals[hash]    = true;                      // Mark the withdrawal as processed
1676             balances[token][account]      -= amount;                    // Deduct the withdrawn tokens from the users balance
1677             balances[token][feeCollector] += fee;                       // Fee to cover gas costs for the withdrawal
1678             
1679             if(token == address(0)){                                    // Send ETH
1680                 require(
1681                     account.send(amount - fee),
1682                     "Sending of ETH failed."
1683                 );
1684             }else{
1685                 Token(token).transfer(account, amount - fee);           // Withdraw ERC20
1686                 require(
1687                     checkERC20TransferSuccess(),                        // Check if the transfer was successful
1688                     "ERC20 token transfer failed."
1689                 );
1690             }
1691         
1692             blocked_for_single_sig_withdrawal[token][account] = 0;      // Set potential previous blocking of these funds to 0
1693             
1694             emit LogWithdrawal(account,token,amount);                   // emit LogWithdrawal event
1695             
1696             // burn gas tokens
1697             if(packedInput2[12] != byte(0x00)){
1698                 spendGasTokens(uint8(packedInput2[12]));
1699             }
1700         }else{
1701             revert();                                                   // Revert the transaction is checks fail
1702         }
1703     }
1704     
1705     // Single-sig withdrawal functions:
1706 
1707     /** @notice Allows user to block funds for single-sig withdrawal after 24h waiting period 
1708       *         (This period is necessary to ensure all trades backed by these funds will be settled.)
1709       * @param  token   The address of the token to block (ETH is address(address(0)))
1710       * @param  amount  The amount of the token to block
1711       */
1712     function blockFundsForSingleSigWithdrawal(address token, uint256 amount) external {
1713         if (balances[token][msg.sender] - blocked_for_single_sig_withdrawal[token][msg.sender] >= amount){  // Check if the user holds the required funds
1714             blocked_for_single_sig_withdrawal[token][msg.sender] += amount;                                 // Block funds for manual withdrawal
1715             last_blocked_timestamp[msg.sender] = block.timestamp;                                           // Start waiting period
1716             emit LogBlockedForSingleSigWithdrawal(msg.sender, token, amount);                               // emit LogBlockedForSingleSigWithdrawal event
1717         }else{
1718             revert();                                                                                       // Revert the transaction if the user does not hold the required balance
1719         }
1720     }
1721     
1722     /** @notice Allows user to withdraw blocked funds without multi-sig after the waiting period
1723       * @param  token   The address of the token to withdraw (ETH is address(address(0)))
1724       * @param  amount  The amount of the token to withdraw
1725       */
1726     function initiateSingleSigWithdrawal(address token, uint256 amount) external {
1727         if (
1728             balances[token][msg.sender] >= amount                                   // Check if the user holds the funds
1729             && (
1730                 (
1731                     blocked_for_single_sig_withdrawal[token][msg.sender] >= amount                          // Check if these funds are blocked
1732                     && last_blocked_timestamp[msg.sender] + single_sig_waiting_period <= block.timestamp    // Check if the waiting period has passed
1733                 )
1734                 || single_sig_waiting_period == 0                                                           // or the waiting period is disabled
1735             )
1736         ){
1737             balances[token][msg.sender] -= amount;                                  // Substract the tokens from users balance
1738 
1739             if(blocked_for_single_sig_withdrawal[token][msg.sender] >= amount){
1740                 blocked_for_single_sig_withdrawal[token][msg.sender] = 0;     // Substract the tokens from users blocked balance
1741             }
1742             
1743             if(token == address(0)){                                                // Withdraw ETH
1744                 require(
1745                     msg.sender.send(amount),
1746                     "Sending of ETH failed."
1747                 );
1748             }else{                                                                  // Withdraw ERC20 tokens
1749                 Token(token).transfer(msg.sender, amount);                          // Transfer the ERC20 tokens
1750                 require(
1751                     checkERC20TransferSuccess(),                                    // Check if the transfer was successful
1752                     "ERC20 token transfer failed."
1753                 );
1754             }
1755             
1756             emit LogSingleSigWithdrawal(msg.sender, token, amount);                 // emit LogSingleSigWithdrawal event
1757         }else{
1758             revert();                                                               // Revert the transaction if the required checks fail
1759         }
1760     } 
1761 
1762     //Trade settlement structs and function
1763 
1764     /** @notice Allows an arbiter to settle a trade between two orders
1765       * @param  makerOrderInput  The packed maker order input
1766       * @param  takerOrderInput  The packed taker order input
1767       * @param  tradeInput       The packed trade to settle between the two
1768       */ 
1769     function settleTrade(OrderInputPacked calldata makerOrderInput, OrderInputPacked calldata takerOrderInput, TradeInputPacked calldata tradeInput) external {
1770         require(arbiters[msg.sender] && marketActive);   // Check if msg.sender is an arbiter and the market is active
1771 
1772         settlementModuleAddress.delegatecall(msg.data);  // delegate the call to the settlement module
1773         
1774         // burn gas tokens
1775         if(tradeInput.packedInput3[28] != byte(0x00)){
1776             spendGasTokens(uint8(tradeInput.packedInput3[28]));
1777         }
1778     }
1779 
1780     /** @notice Allows an arbiter to settle a trade between an order and a reserve
1781       * @param  orderInput  The packed maker order input
1782       * @param  tradeInput  The packed trade to settle between the two
1783       */ 
1784     function settleReserveTrade(OrderInputPacked calldata orderInput, TradeInputPacked calldata tradeInput) external {
1785         require(arbiters[msg.sender] && marketActive);   // Check if msg.sender is an arbiter and the market is active
1786 
1787         settlementModuleAddress.delegatecall(msg.data);  // delegate the call to the settlement module
1788         
1789         // burn gas tokens
1790         if(tradeInput.packedInput3[28] != byte(0x00)){
1791             spendGasTokens(uint8(tradeInput.packedInput3[28]));
1792         }
1793     }
1794 
1795     /** @notice Allows an arbiter to settle a trade between an order and a reserve, passing some additional data to the reserve
1796       * @param  orderInput  The packed maker order input
1797       * @param  tradeInput  The packed trade to settle between the two
1798       * @param  data        The data to pass on to the reserve
1799       */ 
1800     function settleReserveTradeWithData(OrderInputPacked calldata orderInput, TradeInputPacked calldata tradeInput, bytes32[] calldata data) external {
1801         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
1802         
1803         settlementModuleAddress.delegatecall(msg.data);  // delegate the call to the settlement module
1804         
1805         // burn gas tokens
1806         if(tradeInput.packedInput3[28] != byte(0x00)){
1807             spendGasTokens(uint8(tradeInput.packedInput3[28]));
1808         }
1809     }
1810     
1811     /** @notice Allows an arbiter to settle a trade between two reserves
1812       * @param  tradeInput  The packed trade to settle between the two
1813       */ 
1814     function settleReserveReserveTrade(TradeInputPacked calldata tradeInput) external {
1815         require(arbiters[msg.sender] && marketActive);          // Check if msg.sender is an arbiter and the market is active
1816 
1817         settlementModuleAddress.delegatecall(msg.data);  // delegate the call to the settlement module
1818         
1819         // burn gas tokens
1820         if(tradeInput.packedInput3[28] != byte(0x00)){
1821             spendGasTokens(uint8(tradeInput.packedInput3[28]));
1822         }
1823     }
1824     
1825     /** @notice Allows an arbiter to settle a trade between two reserves
1826       * @param  tradeInput  The packed trade to settle between the two
1827       * @param  makerData   The data to pass on to the maker reserve
1828       * @param  takerData   The data to pass on to the taker reserve
1829       */ 
1830     function settleReserveReserveTradeWithData(TradeInputPacked calldata tradeInput, bytes32[] calldata makerData, bytes32[] calldata takerData) external {
1831         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
1832         
1833         settlementModuleAddress.delegatecall(msg.data);     // delegate the call to the settlement module
1834         
1835         // burn gas tokens
1836         if(tradeInput.packedInput3[28] != byte(0x00)){
1837             spendGasTokens(uint8(tradeInput.packedInput3[28]));
1838         }
1839     }
1840     
1841 
1842     /** @notice Allows an arbiter to settle multiple trades between multiple orders and reserves
1843       * @param  orderInput     Array of all orders involved in the transactions
1844       * @param  tradeInput     Array of the trades to be settled
1845       */   
1846     function batchSettleTrades(OrderInputPacked[] calldata orderInput, TradeInputPacked[] calldata tradeInput) external {
1847         require(arbiters[msg.sender] && marketActive);          // Check if msg.sender is an arbiter and the market is active
1848         
1849         settlementModuleAddress.delegatecall(msg.data);  // delegate the call to the settlement module
1850         
1851         // Loop through the trades and calc the gasToken sum
1852         uint256 i = tradeInput.length;        
1853         uint256 gasTokenSum;
1854         while(i-- != 0){
1855             gasTokenSum += uint8(tradeInput[i].packedInput3[28]);
1856         }
1857         
1858         // burn gas tokens
1859         if(gasTokenSum > 0){
1860             spendGasTokens(gasTokenSum);
1861         }
1862     }
1863 
1864     /** @notice Allow arbiters to settle a ring of order and reserve trades
1865       * @param  orderInput Array of OrderInputPacked structs
1866       * @param  tradeInput Array of RingTradeInputPacked structs
1867       */
1868     function settleRingTrade(OrderInputPacked[] calldata orderInput, RingTradeInputPacked[] calldata tradeInput) external {
1869         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
1870 
1871         settlementModuleAddress.delegatecall(msg.data);
1872         
1873         // Loop through the trades and calc the gasToken sum
1874         uint256 i = tradeInput.length;        
1875         uint256 gasTokenSum;
1876         while(i-- != 0){
1877             gasTokenSum += uint8(tradeInput[i].packedInput2[24]);
1878         }
1879         
1880         // burn gas tokens
1881         if(gasTokenSum > 0){
1882             spendGasTokens(gasTokenSum);
1883         }
1884     }
1885 
1886     /** @notice Allow arbiters to settle a ring of order and reserve trades, passing on some data to the reserves
1887       * @param  orderInput Array of OrderInputPacked structs
1888       * @param  tradeInput Array of RingTradeInputPacked structs
1889       * @param  data       Array of data to pass along to the reserves
1890       */
1891     function settleRingTradeWithData(OrderInputPacked[] calldata orderInput, RingTradeInputPacked[] calldata tradeInput, bytes32[][] calldata data) external {
1892         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
1893 
1894         settlementModuleAddress.delegatecall(msg.data);
1895         
1896         // Loop through the trades and calc the gasToken sum
1897         uint256 i = tradeInput.length;        
1898         uint256 gasTokenSum;
1899         while(i-- != 0){
1900             gasTokenSum += uint8(tradeInput[i].packedInput2[24]);
1901         }
1902         
1903         // burn gas tokens
1904         if(gasTokenSum > 0){
1905             spendGasTokens(gasTokenSum);
1906         }
1907     }
1908 
1909 
1910     /** @notice Helper function, callable only by the contract itself, to execute a trade between two reserves
1911       * @param  makerReserve  The maker reserve
1912       * @param  takerReserve  The taker reserve
1913       * @param  trade         The trade to settle between the two
1914       * @return Whether the trade succeeded or failed
1915       */
1916     function executeReserveReserveTrade(
1917         address             makerReserve,
1918         address payable     takerReserve,
1919         ReserveReserveTrade calldata trade
1920     ) external returns(bool){
1921         // this method is only callable from the contract itself
1922         // a call is used vs a jump, to be able to revert the sending of funds to the reserve without throwing the entire transaction
1923         require(msg.sender == address(this));                       // Check that the caller is the contract itself
1924         
1925         // Check whether the taker reserve accepts the trade
1926         require(
1927             dexBlueReserve(takerReserve).offer(                     
1928                 trade.takerToken,                                   // The token we offer the reserve to sell
1929                 trade.takerAmount,                                  // The amount the reserve could sell
1930                 trade.makerToken,                                   // The token the reserve would receive
1931                 trade.makerAmount - trade.takerFee                  // The amount the reserve would receive
1932             )
1933             && balances[trade.takerToken][takerReserve] >= trade.takerAmount    // Check whether the taker reserve deposited the collateral
1934         );
1935         
1936         balances[trade.takerToken][takerReserve] -= trade.takerAmount;          // Substract the deposited amount from the taker reserve
1937         
1938         if(trade.takerToken != address(0)){
1939             Token(trade.takerToken).transfer(makerReserve, trade.takerAmount - trade.makerFee);     // Send the taker reserves collateral to the maker reserve
1940             require(                                                                                // Revert if the send failed
1941                 checkERC20TransferSuccess(),
1942                 "ERC20 token transfer failed."
1943             );
1944         }
1945         
1946         // Check whether the maker reserve accepts the trade
1947         require(
1948             dexBlueReserve(makerReserve).trade.value(               // Execute the trade in the maker reserve
1949                 trade.takerToken == address(0) ? 
1950                     trade.takerAmount - trade.makerFee              // Send the taker reserves collateral to the maker reserve
1951                     : 0
1952             )(
1953                 trade.takerToken,                                   // The token the taker reserve is selling
1954                 trade.takerAmount - trade.makerFee,                 // The amount of sellToken the taker reserve wants to sell
1955                 trade.makerToken,                                   // The token the taker reserve wants in return
1956                 trade.makerAmount                                   // The amount of token the taker reserve wants in return
1957             )
1958             && balances[trade.makerToken][makerReserve] >= trade.makerAmount  // Check whether the maker reserve deposited the collateral
1959         );
1960 
1961         balances[trade.makerToken][makerReserve] -= trade.makerAmount;                              // Substract the maker reserves's sold amount
1962         
1963         // Send the acquired amount to the taker reserve
1964         if(trade.makerToken == address(0)){                                                         // Is the acquired token ETH
1965             require(
1966                 takerReserve.send(trade.makerAmount - trade.takerFee),                              // Send ETH
1967                 "Sending of ETH failed."
1968             );
1969         }else{
1970             Token(trade.makerToken).transfer(takerReserve, trade.makerAmount - trade.takerFee);     // Transfer ERC20
1971             require(                                                                                // Revert if the transfer failed
1972                 checkERC20TransferSuccess(),
1973                 "ERC20 token transfer failed."
1974             );
1975         }
1976 
1977         // Notify the reserve, that the offer got executed
1978         dexBlueReserve(takerReserve).offerExecuted(                     
1979             trade.takerToken,                                   // The token the reserve sold
1980             trade.takerAmount,                                  // The amount the reserve sold
1981             trade.makerToken,                                   // The token the reserve received
1982             trade.makerAmount - trade.takerFee                  // The amount the reserve received
1983         );
1984         
1985         // Give fee to feeCollector
1986         balances[trade.makerToken][feeCollector] += trade.takerFee;  // Give feeColletor the taker fee
1987         balances[trade.takerToken][feeCollector] += trade.makerFee;  // Give feeColletor the maker fee
1988         
1989         emit LogTrade(trade.makerToken, trade.makerAmount, trade.takerToken, trade.takerAmount);
1990         
1991         emit LogDirectWithdrawal(makerReserve, trade.takerToken, trade.takerAmount - trade.makerFee);
1992         emit LogDirectWithdrawal(takerReserve, trade.makerToken, trade.makerAmount - trade.takerFee);
1993         
1994         return true;
1995     }
1996 
1997     /** @notice Helper function, callable only by the contract itself, to execute a trade between two reserves
1998       * @param  makerReserve  The maker reserve
1999       * @param  takerReserve  The taker reserve
2000       * @param  trade         The trade to settle between the two
2001       * @param  makerData     The data to pass on to the maker reserve
2002       * @param  takerData     The data to pass on to the taker reserve
2003       * @return Whether the trade succeeded or failed
2004       */
2005     function executeReserveReserveTradeWithData(
2006         address             makerReserve,
2007         address payable     takerReserve,
2008         ReserveReserveTrade calldata trade,
2009         bytes32[] calldata  makerData,
2010         bytes32[] calldata  takerData
2011     ) external returns(bool){
2012         // this method is only callable from the contract itself
2013         // a call is used vs a jump, to be able to revert the sending of funds to the reserve without throwing the entire transaction
2014         require(msg.sender == address(this));                       // Check that the caller is the contract itself
2015         
2016         // Check whether the taker reserve accepts the trade
2017         require(
2018             dexBlueReserve(takerReserve).offerWithData(                     
2019                 trade.takerToken,                                   // The token we offer the reserve to sell
2020                 trade.takerAmount,                                  // The amount the reserve could sell
2021                 trade.makerToken,                                   // The token the reserve would receive
2022                 trade.makerAmount - trade.takerFee,                 // The amount the reserve would receive
2023                 takerData
2024             )
2025             && balances[trade.takerToken][takerReserve] >= trade.takerAmount    // Check whether the taker reserve deposited the collateral
2026         );
2027         
2028         balances[trade.takerToken][takerReserve] -= trade.takerAmount;          // Substract the deposited amount from the taker reserve
2029         
2030         if(trade.takerToken != address(0)){
2031             Token(trade.takerToken).transfer(makerReserve, trade.takerAmount - trade.makerFee);     // Send the taker reserves collateral to the maker reserve
2032             require(                                                                                // Revert if the send failed
2033                 checkERC20TransferSuccess(),
2034                 "ERC20 token transfer failed."
2035             );
2036         }
2037         
2038         // Check whether the maker reserve accepts the trade
2039         require(
2040             dexBlueReserve(makerReserve).tradeWithData.value(       // Execute the trade in the maker reserve
2041                 trade.takerToken == address(0) ? 
2042                     trade.takerAmount - trade.makerFee              // Send the taker reserves collateral to the maker reserve
2043                     : 0
2044             )(
2045                 trade.takerToken,                                   // The token the taker reserve is selling
2046                 trade.takerAmount - trade.makerFee,                 // The amount of sellToken the taker reserve wants to sell
2047                 trade.makerToken,                                   // The token the taker reserve wants in return
2048                 trade.makerAmount,                                  // The amount of token the taker reserve wants in return
2049                 makerData
2050             )
2051             && balances[trade.makerToken][makerReserve] >= trade.makerAmount  // Check whether the maker reserve deposited the collateral
2052         );
2053 
2054         balances[trade.makerToken][makerReserve] -= trade.makerAmount;                              // Substract the maker reserves's sold amount
2055         
2056         // Send the acquired amount to the taker reserve
2057         if(trade.makerToken == address(0)){                                                         // Is the acquired token ETH
2058             require(
2059                 takerReserve.send(trade.makerAmount - trade.takerFee),                              // Send ETH
2060                 "Sending of ETH failed."
2061             );
2062         }else{
2063             Token(trade.makerToken).transfer(takerReserve, trade.makerAmount - trade.takerFee);     // Transfer ERC20
2064             require(                                                                                // Revert if the transfer failed
2065                 checkERC20TransferSuccess(),
2066                 "ERC20 token transfer failed."
2067             );
2068         }
2069 
2070         // Notify the reserve, that the offer got executed
2071         dexBlueReserve(takerReserve).offerExecuted(                     
2072             trade.takerToken,                                   // The token the reserve sold
2073             trade.takerAmount,                                  // The amount the reserve sold
2074             trade.makerToken,                                   // The token the reserve received
2075             trade.makerAmount - trade.takerFee                  // The amount the reserve received
2076         );
2077         
2078         // Give fee to feeCollector
2079         balances[trade.makerToken][feeCollector] += trade.takerFee;  // Give feeColletor the taker fee
2080         balances[trade.takerToken][feeCollector] += trade.makerFee;  // Give feeColletor the maker fee
2081         
2082         emit LogTrade(trade.makerToken, trade.makerAmount, trade.takerToken, trade.takerAmount);
2083         
2084         emit LogDirectWithdrawal(makerReserve, trade.takerToken, trade.takerAmount - trade.makerFee);
2085         emit LogDirectWithdrawal(takerReserve, trade.makerToken, trade.makerAmount - trade.takerFee);
2086         
2087         return true;
2088     }
2089 
2090     /** @notice Helper function, callable only by the contract itself, to execute a trade with a reserve contract
2091       * @param  sellToken   The address of the token we want to sell (ETH is address(address(0)))
2092       * @param  sellAmount  The amount of sellToken we want to sell
2093       * @param  buyToken    The address of the token we want to buy (ETH is address(address(0)))
2094       * @param  buyAmount   The amount of buyToken we want in exchange for sellAmount
2095       * @param  reserve     The address of the reserve, we want to trade with
2096       */
2097     function executeReserveTrade(
2098         address    sellToken,
2099         uint256    sellAmount,
2100         address    buyToken,
2101         uint256    buyAmount,
2102         address    reserve
2103     ) external returns(bool){
2104         // this method is only callable from the contract itself
2105         // a call is used vs a jump, to be able to revert the sending of funds to the reserve without throwing the entire transaction
2106         require(msg.sender == address(this));                   // check that the caller is the contract itself
2107         
2108         if(sellToken == address(0)){
2109             require(dexBlueReserve(reserve).trade.value(        // execute the trade in the reserve
2110                                                                 // if the reserve accepts the trade, it will deposit the buyAmount and return true
2111                 sellAmount                                      // send collateral to reserve
2112             )(
2113                 sellToken,                                      // the token we want to sell
2114                 sellAmount,                                     // the amount of sellToken we want to exchange
2115                 buyToken,                                       // the token we want to receive
2116                 buyAmount                                       // the quantity of buyToken we demand in return
2117             ));
2118         }else{
2119             Token(sellToken).transfer(reserve, sellAmount);     // send collateral to reserve
2120             require(                                            // revert if the send failed
2121                 checkERC20TransferSuccess(),
2122                 "ERC20 token transfer failed."
2123             );
2124             
2125             require(dexBlueReserve(reserve).trade(              // execute the trade in the reserve
2126                 sellToken,                                      // the token we want to sell
2127                 sellAmount,                                     // the amount of sellToken we want to exchange
2128                 buyToken,                                       // the token we want to receive
2129                 buyAmount                                       // the quantity of buyToken we demand in return
2130             ));
2131         }
2132         
2133         require(balances[buyToken][reserve] >= buyAmount);      // check if the reserve delivered on the request, else revert
2134         
2135         return true;                                            // return true if all checks are passed and the trade was executed successfully
2136     }
2137     
2138     /** @notice private function to execute a trade with a reserve contract
2139       * @param  sellToken   The address of the token we want to sell (ETH is address(address(0)))
2140       * @param  sellAmount  The amount of sellToken we want to sell
2141       * @param  buyToken    The address of the token we want to buy (ETH is address(address(0)))
2142       * @param  buyAmount   The amount of buyToken we want in exchange for sellAmount
2143       * @param  reserve     The address of the reserve, we want to trade with
2144       * @param  data        The data passed on to the reserve
2145       */
2146     function executeReserveTradeWithData(
2147         address    sellToken,
2148         uint256    sellAmount,
2149         address    buyToken,
2150         uint256    buyAmount,
2151         address    reserve,
2152         bytes32[]  calldata data
2153     ) external returns(bool){
2154         // this method is only callable from the contract itself
2155         // a call is used vs a jump, to be able to revert the sending of funds to the reserve without throwing the entire transaction
2156         require(msg.sender == address(this));                   // check that the caller is the contract itself
2157         
2158         if(sellToken == address(0)){
2159             require(dexBlueReserve(reserve).tradeWithData.value(// execute the trade in the reserve
2160                                                                 // if the reserve accepts the trade, it will deposit the buyAmount and return true
2161                 sellAmount                                      // send collateral to reserve
2162             )(
2163                 sellToken,                                      // the token we want to sell
2164                 sellAmount,                                     // the amount of sellToken we want to exchange
2165                 buyToken,                                       // the token we want to receive
2166                 buyAmount,                                      // the quantity of buyToken we demand in return
2167                 data                                            // the data passed on to the reserve
2168             ));
2169         }else{
2170             Token(sellToken).transfer(reserve, sellAmount);     // send collateral to reserve
2171             require(                                            // revert if the send failed
2172                 checkERC20TransferSuccess(),
2173                 "ERC20 token transfer failed."
2174             );
2175             require(dexBlueReserve(reserve).tradeWithData(      // execute the trade in the reserve
2176                 sellToken,                                      // the token we want to sell
2177                 sellAmount,                                     // the amount of sellToken we want to exchange
2178                 buyToken,                                       // the token we want to receive
2179                 buyAmount,                                      // the quantity of buyToken we demand in return
2180                 data                                            // the data passed on to the reserve
2181             ));
2182         }
2183         
2184         require(balances[buyToken][reserve] >= buyAmount);      // check if the reserve delivered on the request, else revert
2185         
2186         return true;                                            // return true if all checks are passed and the trade was executed successfully
2187     }
2188 
2189 
2190     // Token swapping functionality
2191 
2192     /** @notice Queries best output for a trade currently available from the reserves
2193       * @param  sell_token   The token the user wants to sell (ETH is address(0))
2194       * @param  sell_amount  The amount of sell_token to sell
2195       * @param  buy_token    The token the user wants to acquire (ETH is address(0))
2196       * @return The output amount the reserve with the best price offers
2197     */
2198     function getSwapOutput(address sell_token, uint256 sell_amount, address buy_token) public view returns (uint256){
2199         (, uint256 output) = getBestReserve(sell_token, sell_amount, buy_token);
2200         return output;
2201     }
2202 
2203     /** @notice Queries the reserve address and output of trade, of the reserve which offers the best deal on a trade
2204       * @param  sell_token   The token the user wants to sell (ETH is address(0))
2205       * @param  sell_amount  The amount of sell_token to sell
2206       * @param  buy_token    The token the user wants to acquire (ETH is address(0))
2207       * @return The address of the reserve offering the best deal and the expected output of the trade
2208     */
2209     function getBestReserve(address sell_token, uint256 sell_amount, address buy_token) public view returns (address, uint256){
2210         address bestReserve;
2211         uint256 bestOutput = 0;
2212         uint256 output;
2213         
2214         for(uint256 i = 0; i < public_reserve_arr.length; i++){
2215             output = dexBlueReserve(public_reserve_arr[i]).getSwapOutput(sell_token, sell_amount, buy_token);
2216             if(output > bestOutput){
2217                 bestOutput  = output;
2218                 bestReserve = public_reserve_arr[i];
2219             }
2220         }
2221         
2222         return (bestReserve, bestOutput);
2223     }
2224 
2225     /** @notice Allows users to swap a token or ETH with the reserve offering the best price for his trade
2226       * @param  sell_token   The token the user wants to sell (ETH is address(0))
2227       * @param  sell_amount  The amount of sell_token to sell
2228       * @param  buy_token    The token the user wants to acquire (ETH is address(0))
2229       * @param  min_output   The minimum amount of buy_token, the trade should result in 
2230       * @param  deadline     The timestamp after which the transaction should not be executed
2231       * @return The amount of buy_token the user receives
2232     */
2233     function swap(address sell_token, uint256 sell_amount, address buy_token,  uint256 min_output, uint256 deadline) external payable returns(uint256){
2234 
2235         (bool success, bytes memory returnData) = settlementModuleAddress.delegatecall(msg.data);  // delegate the call to the settlement module
2236 
2237         require(success);
2238 
2239         return abi.decode(returnData, (uint256));
2240     }
2241 
2242     /** @notice Allows users to swap a token or ETH with a specified reserve
2243       * @param  sell_token   The token the user wants to sell (ETH is address(0))
2244       * @param  sell_amount  The amount of sell_token to sell
2245       * @param  buy_token    The token the user wants to acquire (ETH is address(0))
2246       * @param  min_output   The minimum amount of buy_token, the trade should result in 
2247       * @param  reserve      The address of the reserve to trade with
2248       * @param  deadline     The timestamp after which the transaction should not be executed
2249     */
2250     function swapWithReserve(address sell_token, uint256 sell_amount, address buy_token,  uint256 min_output, address reserve, uint256 deadline) public payable returns (uint256){
2251         
2252         (bool success, bytes memory returnData) = settlementModuleAddress.delegatecall(msg.data);  // delegate the call to the settlement module
2253 
2254         require(success);
2255 
2256         return abi.decode(returnData, (uint256));
2257     }
2258 
2259     
2260     // Order cancellation functions
2261 
2262     /** @notice Give the user the option to perform multiple on-chain cancellations of orders at once with arbiters multi-sig
2263       * @param  orderHashes Array of orderHashes of the orders to be canceled
2264       * @param  v           Multi-sig v
2265       * @param  r           Multi-sig r
2266       * @param  s           Multi-sig s
2267       */
2268     function multiSigOrderBatchCancel(bytes32[] calldata orderHashes, uint8 v, bytes32 r, bytes32 s) external {
2269         if(
2270             arbiters[                                               // Check if the signee is an arbiter
2271                 ecrecover(                                          // Restore the signing address
2272                     keccak256(abi.encodePacked(                     // Restore the signed hash (hash of all orderHashes)
2273                         "\x19Ethereum Signed Message:\n32", 
2274                         keccak256(abi.encodePacked(orderHashes))
2275                     )),
2276                     v, r, s
2277                 )
2278             ]
2279         ){
2280             uint256 len = orderHashes.length;
2281             for(uint256 i = 0; i < len; i++){
2282                 matched[orderHashes[i]] = 2**256 - 1;               // Set the matched amount of all orders to the maximum
2283                 emit LogOrderCanceled(orderHashes[i]);              // emit LogOrderCanceled event
2284             }
2285         }else{
2286             revert();
2287         }
2288     }
2289     
2290     
2291     // Gastoken functionality
2292     
2293     // This is heavily inspired and based on the work of the gastoken.io team @ initc3.org, kudos!
2294     // Why not use their implementation?
2295     // We can safe even more gas through: having a even shorter contract address (1 byte less), saving the call to their contract, their token logic, and other minor optimisations
2296     
2297     uint256 gas_token_nonce_head;
2298     uint256 gas_token_nonce_tail;
2299     
2300     /** @notice Get the available amount of gasTokens
2301       * @return The array of all indexed token addresses
2302       */
2303     function getAvailableGasTokens() view public returns (uint256 amount){
2304         return gas_token_nonce_head - gas_token_nonce_tail;
2305     }
2306     
2307     /** @notice Mint new gasTokens
2308       * @param  amount  The amount of gasTokens to mint
2309       */
2310     function mintGasTokens(uint amount) public {
2311         gas_token_nonce_head += amount;
2312         while(amount-- > 0){
2313             createChildContract();   
2314         }
2315     }
2316     
2317     /** @notice internal function to burn gasTokens
2318       * @param  amount  The amount of gasTokens to burn
2319       */
2320     function spendGasTokens(uint256 amount) internal {
2321         uint256 tail = gas_token_nonce_tail;
2322         
2323         if(amount <= gas_token_nonce_head - tail){
2324             
2325             // tail points to slot behind the last contract in the queue
2326             for (uint256 i = tail + 1; i <= tail + amount; i++) {
2327                 restoreChildContractAddress(i).call("");
2328             }
2329     
2330             gas_token_nonce_tail = tail + amount;
2331         }
2332     }
2333     
2334     /** @notice internal helper function to create a child contract
2335       * @return The address of the created contract
2336       */
2337     function createChildContract() internal returns (address addr) {
2338         assembly {
2339             let solidity_free_mem_ptr := mload(0x40)
2340             mstore(solidity_free_mem_ptr, 0x746d541e251335090ac5b47176af4f7e3318585733ff6000526015600bf3) // Load contract bytecode into memory
2341             addr := create(0, add(solidity_free_mem_ptr, 2), 30)                                          // Create child contract
2342         }
2343     }
2344     
2345     /** @notice internal helper function to restore the address of a child contract for a given nonce
2346       * @param  nonce   The nonce of the child contract
2347       * @return The address of the child contract
2348       */
2349     function restoreChildContractAddress(uint256 nonce) view internal returns (address) {
2350         require(nonce <= 256**9 - 1);
2351 
2352         uint256 encoded;
2353         uint256 tot_bytes;
2354 
2355         if (nonce < 128) {
2356             // RLP(nonce) = nonce
2357             // add the encoded nonce to the encoded word
2358             encoded = nonce * 256**9;
2359             
2360             // [address_length(1) address(20) nonce_length(0) nonce(1)]
2361             tot_bytes = 22;
2362         } else {
2363             // RLP(nonce) = [num_bytes_in_nonce nonce]
2364             uint nonce_bytes = 1;
2365             // count nonce bytes
2366             uint mask = 256;
2367             while (nonce >= mask) {
2368                 nonce_bytes += 1;
2369                 mask        *= 256;
2370             }
2371             
2372             // add the encoded nonce to the word
2373             encoded = ((128 + nonce_bytes) * 256**9) +  // nonce length
2374                       (nonce * 256**(9 - nonce_bytes)); // nonce
2375                    
2376             // [address_length(1) address(20) nonce_length(1) nonce(1-9)]
2377             tot_bytes = 22 + nonce_bytes;
2378         }
2379 
2380         // add the prefix and encoded address to the encoded word
2381         encoded += ((192 + tot_bytes) * 256**31) +     // total length
2382                    ((128 + 20) * 256**30) +            // address length
2383                    (uint256(address(this)) * 256**10); // address(this)
2384 
2385         uint256 hash;
2386 
2387         assembly {
2388             let mem_start := mload(0x40)        // get a pointer to free memory
2389             mstore(0x40, add(mem_start, 0x20))  // update the pointer
2390 
2391             mstore(mem_start, encoded)          // store the rlp encoding
2392             hash := keccak256(mem_start,
2393                          add(tot_bytes, 1))     // hash the rlp encoding
2394         }
2395 
2396         // interpret hash as address (20 least significant bytes)
2397         return address(hash);
2398     }
2399     
2400         
2401     // Signature delegation
2402 
2403     /** @notice delegate an address to allow it to sign orders on your behalf
2404       * @param delegate  The address to delegate
2405       */
2406     function delegateAddress(address delegate) external {
2407         // set as delegate
2408         require(delegates[delegate] == address(0), "Address is already a delegate");
2409         delegates[delegate] = msg.sender;
2410         
2411         emit LogDelegateStatus(msg.sender, delegate, true);
2412     }
2413     
2414     /** @notice revoke the delegation of an address
2415       * @param  delegate  The delegated address
2416       * @param  v         Multi-sig v
2417       * @param  r         Multi-sig r
2418       * @param  s         Multi-sig s
2419       */
2420     function revokeDelegation(address delegate, uint8 v, bytes32 r, bytes32 s) external {
2421         bytes32 hash = keccak256(abi.encodePacked(              // Restore the signed hash
2422             "\x19Ethereum Signed Message:\n32", 
2423             keccak256(abi.encodePacked(
2424                 delegate,
2425                 msg.sender,
2426                 address(this)
2427             ))
2428         ));
2429 
2430         require(
2431             arbiters[ecrecover(hash, v, r, s)],     // Check if signee is an arbiter
2432             "MultiSig is not from known arbiter"
2433         );
2434         
2435         delegates[delegate] = address(1);           // Set to 1 not 0 to prevent double delegation, which would make old signed orders valid for the new delegator
2436         
2437         emit LogDelegateStatus(msg.sender, delegate, false);
2438     }
2439     
2440 
2441     // Management functions:
2442 
2443     /** @notice Constructor function. Sets initial roles and creates EIP712 Domain.
2444       */
2445     constructor() public {
2446         owner = msg.sender;             // Nominate sender to be the contract owner
2447         
2448         // create EIP712 domain seperator
2449         EIP712_Domain memory eip712Domain = EIP712_Domain({
2450             name              : "dex.blue",
2451             version           : "1",
2452             chainId           : 1,
2453             verifyingContract : address(this)
2454         });
2455         EIP712_DOMAIN_SEPARATOR = keccak256(abi.encode(
2456             EIP712_DOMAIN_TYPEHASH,
2457             keccak256(bytes(eip712Domain.name)),
2458             keccak256(bytes(eip712Domain.version)),
2459             eip712Domain.chainId,
2460             eip712Domain.verifyingContract
2461         ));
2462     }
2463     
2464     /** @notice Allows the owner to change / disable the waiting period for a single sig withdrawal
2465       * @param  waiting_period The new waiting period
2466       */
2467     function changeSingleSigWaitingPeriod(uint256 waiting_period) external {
2468         require(
2469             msg.sender == owner             // only owner can set waiting period
2470             && waiting_period <= 86400      // max period owner can set is one day
2471         );
2472         
2473         single_sig_waiting_period = waiting_period;
2474     }
2475     
2476     /** @notice Allows the owner to handle over the ownership to another address
2477       * @param  new_owner The new owner address
2478       */
2479     function changeOwner(address payable new_owner) external {
2480         require(msg.sender == owner);
2481         owner = new_owner;
2482     }
2483     
2484     /** @notice Allows the owner to register & cache a new reserve address in the smart conract
2485       * @param  reserve   The address of the reserve to add
2486       * @param  index     The index under which the reserve should be indexed
2487       * @param  is_public Whether the reserve should publicly available through swap() & swapWithReserve()
2488       */
2489     function cacheReserveAddress(address payable reserve, uint256 index, bool is_public) external {
2490         require(arbiters[msg.sender]);
2491         
2492         reserves[index] = reserve;
2493         reserve_indices[reserve] = index;
2494         
2495         if(is_public){
2496             public_reserves[reserve] = true;
2497             public_reserve_arr.push(reserve);  // append the reserve to the reserve array
2498         }
2499     }
2500     
2501     /** @notice Allows the owner to remove a reserve from the array swap() and getSwapOutput() need to loop through
2502       * @param  reserve The address of the reserve to remove
2503       */
2504     function removePublicReserveAddress(address reserve) external {
2505         require(arbiters[msg.sender]);
2506         
2507         public_reserves[reserve] = false;
2508 
2509         for(uint256 i = 0; i < public_reserve_arr.length; i++){
2510             if(public_reserve_arr[i] == reserve){
2511                 public_reserve_arr[i] = public_reserve_arr[public_reserve_arr.length - 1]; // array order does not matter, so we just move the last element in the slot of the element we are removing
2512                 
2513                 delete public_reserve_arr[public_reserve_arr.length-1];                    // delete the last element of the array
2514                 public_reserve_arr.length--;                             
2515                 
2516                 return;
2517             }
2518         }
2519     }
2520         
2521     /** @notice Allows an arbiterto cache a new token address
2522       * @param  token   The address of the token to add
2523       * @param  index   The index under which the token should be indexed
2524       */
2525     function cacheTokenAddress(address token, uint256 index) external {
2526         require(arbiters[msg.sender]);
2527         
2528         tokens[index]        = token;
2529         token_indices[token] = index;
2530         
2531         token_arr.push(token);  // append the token to the array
2532     }
2533 
2534     /** @notice Allows arbiters to remove a token from the token array
2535       * @param  token The address of the token to remove
2536       */
2537     function removeTokenAddressFromArr(address token) external {
2538         require(arbiters[msg.sender]);
2539         
2540         for(uint256 i = 0; i < token_arr.length; i++){
2541             if(token_arr[i] == token){
2542                 token_arr[i] = token_arr[token_arr.length - 1]; // array order does not matter, so we just move the last element in the slot of the element we are removing
2543                 
2544                 delete token_arr[token_arr.length-1];           // delete the last element of the array
2545                 token_arr.length--;                             
2546                 
2547                 return;
2548             }
2549         }
2550     }
2551     
2552     /** @notice Allows the owner to nominate or denominate trade arbiting addresses
2553       * @param  arbiter The arbiter whose status to change
2554       * @param  status  whether the address should be an arbiter (true) or not (false)
2555       */
2556     function nominateArbiter(address arbiter, bool status) external {
2557         require(msg.sender == owner);                           // Check if sender is owner
2558         arbiters[arbiter] = status;                             // Update address status
2559     }
2560     
2561     /** @notice Allows the owner to pause / unpause the market
2562       * @param  state  whether the the market should be active (true) or paused (false)
2563       */
2564     function setMarketActiveState(bool state) external {
2565         require(msg.sender == owner);                           // Check if sender is owner
2566         marketActive = state;                                   // pause / unpause market
2567     }
2568     
2569     /** @notice Allows the owner to nominate the feeCollector address
2570       * @param  collector The address to nominate as feeCollector
2571       */
2572     function nominateFeeCollector(address payable collector) external {
2573         require(msg.sender == owner && !feeCollectorLocked);    // Check if sender is owner and feeCollector address is not locked
2574         feeCollector = collector;                               // Update feeCollector address
2575     }
2576     
2577     /** @notice Allows the owner to lock the feeCollector address
2578     */
2579     function lockFeeCollector() external {
2580         require(msg.sender == owner);                           // Check if sender is owner
2581         feeCollectorLocked = true;                              // Lock feeCollector address
2582     }
2583     
2584     /** @notice Get the feeCollectors address
2585       * @return The feeCollectors address
2586       */
2587     function getFeeCollector() public view returns (address){
2588         return feeCollector;
2589     }
2590 
2591     /** @notice Allows an arbiter or feeCollector to directly withdraw his own funds (would allow e.g. a fee distribution contract the withdrawal of collected fees)
2592       * @param  token   The token to withdraw
2593       * @param  amount  The amount of tokens to withdraw
2594     */
2595     function directWithdrawal(address token, uint256 amount) external returns(bool){
2596         if (
2597             (
2598                 msg.sender == feeCollector                        // Check if the sender is the feeCollector
2599                 || arbiters[msg.sender]                           // Check if the sender is an arbiter
2600             )
2601             && balances[token][msg.sender] >= amount              // Check if feeCollector has the sufficient balance
2602         ){
2603             balances[token][msg.sender] -= amount;                // Substract the feeCollectors balance
2604             
2605             if(token == address(0)){                              // Is the withdrawal token ETH
2606                 require(
2607                     msg.sender.send(amount),                      // Withdraw ETH
2608                     "Sending of ETH failed."
2609                 );
2610             }else{
2611                 Token(token).transfer(msg.sender, amount);        // Withdraw ERC20
2612                 require(                                          // Revert if the withdrawal failed
2613                     checkERC20TransferSuccess(),
2614                     "ERC20 token transfer failed."
2615                 );
2616             }
2617             
2618             emit LogDirectWithdrawal(msg.sender, token, amount);     // emit LogDirectWithdrawal event
2619             return true;
2620         }else{
2621             return false;
2622         }
2623     }
2624 }
2625 
2626 // dexBlueReserve
2627 contract dexBlueReserve{
2628     // insured trade function with fixed outcome
2629     function trade(address sell_token, uint256 sell_amount, address buy_token,  uint256 buy_amount) public payable returns(bool success){}
2630     
2631     // insured trade function with fixed outcome, passes additional data to the reserve
2632     function tradeWithData(address sell_token, uint256 sell_amount, address buy_token,  uint256 buy_amount, bytes32[] memory data) public payable returns(bool success){}
2633     
2634     // offer the reserve to enter a trade a a taker
2635     function offer(address sell_token, uint256 sell_amount, address buy_token,  uint256 buy_amount) public returns(bool accept){}
2636     
2637     // offer the reserve to enter a trade a a taker, passes additional data to the reserve
2638     function offerWithData(address sell_token, uint256 sell_amount, address buy_token,  uint256 buy_amount, bytes32[] memory data) public returns(bool accept){}
2639     
2640     // callback function, to inform the reserve that an offer has been accepted by the maker reserve
2641     function offerExecuted(address sell_token, uint256 sell_amount, address buy_token,  uint256 buy_amount) public{}
2642 
2643     // uninsured swap
2644     function swap(address sell_token, uint256 sell_amount, address buy_token,  uint256 min_output) public payable returns(uint256 output){}
2645     
2646     // get output amount of swap
2647     function getSwapOutput(address sell_token, uint256 sell_amount, address buy_token) public view returns(uint256 output){}
2648 }
2649 
2650 // Standart ERC20 token interface to interact with ERC20 token contracts
2651 // To support badly implemented tokens (which dont return a boolean on the transfer functions)
2652 // we have to expect a badly implemented token and then check with checkERC20TransferSuccess() whether the transfer succeeded
2653 
2654 contract Token {
2655     /** @return total amount of tokens
2656       */
2657     function totalSupply() view public returns (uint256 supply) {}
2658 
2659     /** @param _owner The address from which the balance will be retrieved
2660       * @return The balance
2661       */
2662     function balanceOf(address _owner) view public returns (uint256 balance) {}
2663 
2664     /** @notice send `_value` token to `_to` from `msg.sender`
2665       * @param  _to     The address of the recipient
2666       * @param  _value  The amount of tokens to be transferred
2667       * @return whether the transfer was successful or not
2668       */
2669     function transfer(address _to, uint256 _value) public {}
2670 
2671     /** @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
2672       * @param  _from   The address of the sender
2673       * @param  _to     The address of the recipient
2674       * @param  _value  The amount of tokens to be transferred
2675       * @return whether the transfer was successful or not
2676       */
2677     function transferFrom(address _from, address _to, uint256 _value)  public {}
2678 
2679     /** @notice `msg.sender` approves `_addr` to spend `_value` tokens
2680       * @param  _spender The address of the account able to transfer the tokens
2681       * @param  _value   The amount of wei to be approved for transfer
2682       * @return whether the approval was successful or not
2683       */
2684     function approve(address _spender, uint256 _value) public returns (bool success) {}
2685 
2686     /** @param  _owner   The address of the account owning tokens
2687       * @param  _spender The address of the account able to transfer the tokens
2688       * @return Amount of remaining tokens allowed to spend
2689       */
2690     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {}
2691 
2692     event Transfer(address indexed _from, address indexed _to, uint256 _value);
2693     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
2694 
2695     uint256 public decimals;
2696     string public name;
2697 }
2698 
2699 // Wrapped Ether interface
2700 contract WETH is Token{
2701     function deposit() public payable {}
2702     function withdraw(uint256 amount) public {}
2703 }