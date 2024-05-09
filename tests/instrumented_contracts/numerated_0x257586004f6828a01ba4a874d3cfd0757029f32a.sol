1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 contract dexBlue{
5     
6     // Events
7 
8     /** @notice The event, emitted when a trade is settled
9       * @param  index Implying the index of the settled trade in the trade array passed to matchTrades() 
10       */
11     event TradeSettled(uint8 index);
12 
13     /** @notice The event, emitted when a trade settlement failed
14       * @param  index Implying the index of the failed trade in the trade array passed to matchTrades() 
15       */
16     event TradeFailed(uint8 index);
17 
18     /** @notice The event, emitted after a successful deposit of ETH or token
19       * @param  account  The address, which initiated the deposit
20       * @param  token    The address of the deposited token (ETH is address(0))
21       * @param  amount   The amount deposited in this transaction 
22       */
23     event Deposit(address account, address token, uint256 amount);
24 
25     /** @notice The event, emitted after a successful (multi-sig) withdrawal of deposited ETH or token
26       * @param  account  The address, which initiated the withdrawal
27       * @param  token    The address of the token which is withdrawn (ETH is address(0))
28       * @param  amount   The amount withdrawn in this transaction 
29       */
30     event Withdrawal(address account, address token, uint256 amount);
31 
32     /** @notice The event, emitted after a user successfully blocked tokens or ETH for a single signature withdrawal
33       * @param  account  The address controlling the tokens
34       * @param  token    The address of the token which is blocked (ETH is address(0))
35       * @param  amount   The amount blocked in this transaction 
36       */
37     event BlockedForSingleSigWithdrawal(address account, address token, uint256 amount);
38 
39     /** @notice The event, emitted after a successful single-sig withdrawal of deposited ETH or token
40       * @param  account  The address, which initiated the withdrawal
41       * @param  token    The address of the token which is withdrawn (ETH is address(0))
42       * @param  amount   The amount withdrawn in this transaction 
43       */
44     event SingleSigWithdrawal(address account, address token, uint256 amount);
45 
46     /** @notice The event, emitted once the feeCollector address initiated a withdrawal of collected tokens or ETH via feeWithdrawal()
47       * @param  token    The address of the token which is withdrawn (ETH is address(0))
48       * @param  amount   The amount withdrawn in this transaction 
49       */
50     event FeeWithdrawal(address token, uint256 amount);
51 
52     /** @notice The event, emitted once an on-chain cancellation of an order was performed
53       * @param  hash    The invalidated orders hash 
54       */
55     event OrderCanceled(bytes32 hash);
56    
57     /** @notice The event, emitted once a address delegation or dedelegation was performed
58       * @param  delegator The delegating address,
59       * @param  delegate  The delegated address,
60       * @param  status    Whether the transaction delegated an address (true) or inactivated an active delegation (false) 
61       */
62     event DelegateStatus(address delegator, address delegate, bool status);
63 
64 
65     // Mappings 
66 
67     mapping(address => mapping(address => uint256)) balances;                           // Users balances (token address > user address > balance amount) (ETH is address(0))
68     mapping(address => mapping(address => uint256)) blocked_for_single_sig_withdrawal;  // Users balances they blocked to withdraw without arbiters multi-sig (token address > user address > balance amount) (ETH is address(0))
69     mapping(address => uint256) last_blocked_timestamp;                                 // The last timestamp a user blocked tokens to withdraw without arbiters multi-sig
70     mapping(bytes32 => bool) processed_withdrawals;                                     // Processed withdrawal hashes
71     mapping(bytes32 => uint256) matched;                                                // Orders matched sell_amounts to prevent multiple-/over- matches of the same orders
72     mapping(address => address) delegates;                                              // Delegated order signing addresses
73 
74 
75     // EIP712 (signTypedData)
76 
77     // EIP712 Domain
78     struct EIP712_Domain {
79         string  name;
80         string  version;
81         uint256 chainId;
82         address verifyingContract;
83     }
84     bytes32 constant EIP712_DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
85     bytes32          EIP712_DOMAIN_SEPARATOR;
86     // Order typehash
87     bytes32 constant EIP712_ORDER_TYPEHASH = keccak256("Order(address buyTokenAddress,address sellTokenAddress,uint256 buyTokenAmount,uint256 sellTokenAmount,uint64 nonce)");
88     // Withdrawal typehash
89     bytes32 constant EIP712_WITHDRAWAL_TYPEHASH = keccak256("Withdrawal(address token,uint256 amount,uint64 nonce)");
90         
91 
92     // Utility functions:
93 
94     /** @notice Get the balance of a user for a specific token
95       * @param  token  The token address (ETH is token address(0))
96       * @param  holder The address holding the token
97       * @return The amount of the specified token held by the user 
98       */
99     function getBalance(address token, address holder) constant public returns(uint256){
100         return balances[token][holder];
101     }
102     
103     /** @notice Get the balance a user blocked for a single-signature withdrawal (ETH is token address(0))
104       * @param  token  The token address (ETH is token address(0))
105       * @param  holder The address holding the token
106       * @return The amount of the specified token blocked by the user 
107       */
108     function getBlocked(address token, address holder) constant public returns(uint256){
109         return blocked_for_single_sig_withdrawal[token][holder];
110     }
111     
112     /** @notice Returns the timestamp of the last blocked balance
113       * @param  user  Address of the user which blocked funds
114       * @return The last unix timestamp the user blocked funds at, which starts the waiting period for single-sig withdrawals 
115       */
116     function getLastBlockedTimestamp(address user) constant public returns(uint256){
117         return last_blocked_timestamp[user];
118     }
119 
120 
121     // Deposit functions:
122 
123     /** @notice Deposit Ether into the smart contract 
124       */
125     function depositEther() public payable{
126         balances[address(0)][msg.sender] += msg.value;      // Add the received ETH to the users balance
127         emit Deposit(msg.sender, address(0), msg.value);    // Emit a deposit event
128     }
129     
130     /** @notice Fallback function to credit ETH sent to the contract without data 
131       */
132     function() public payable{
133         depositEther();                                     // Call the deposit function to credit ETH sent in this transaction
134     }
135     
136     /** @notice Deposit ERC20 tokens into the smart contract (remember to set allowance in the token contract first)
137       * @param  token   The address of the token to deposit
138       * @param  amount  The amount of tokens to deposit 
139       */
140     function depositToken(address token, uint256 amount) public {
141         Token(token).transferFrom(msg.sender, address(this), amount);    // Deposit ERC20
142         require(
143             checkERC20TransferSuccess(),                                 // Check whether the ERC20 token transfer was successful
144             "ERC20 token transfer failed."
145         );
146         balances[token][msg.sender] += amount;                           // Credit the deposited token to users balance
147         emit Deposit(msg.sender, token, amount);                         // Emit a deposit event
148     }
149         
150     // Multi-sig withdrawal functions:
151 
152     /** @notice User-submitted withdrawal with arbiters signature, which withdraws to the users address
153       * @param  token   The token to withdraw (ETH is address(address(0)))
154       * @param  amount  The amount of tokens to withdraw
155       * @param  nonce   The nonce (to salt the hash)
156       * @param  v       Multi-signature v
157       * @param  r       Multi-signature r
158       * @param  s       Multi-signature s 
159       */
160     function multiSigWithdrawal(address token, uint256 amount, uint64 nonce, uint8 v, bytes32 r, bytes32 s) public {
161         bytes32 hash = keccak256(abi.encodePacked(                      // Calculate the withdrawal hash from the parameters
162             "\x19Ethereum Signed Message:\n32", 
163             keccak256(abi.encodePacked(
164                 msg.sender,
165                 token,
166                 amount,
167                 nonce,
168                 address(this)
169             ))
170         ));
171         if(
172             !processed_withdrawals[hash]                                // Check if the withdrawal was initiated before
173             && arbiters[ecrecover(hash, v,r,s)]                         // Check if the multi-sig is valid
174             && balances[token][msg.sender] >= amount                    // Check if the user holds the required balance
175         ){
176             processed_withdrawals[hash]  = true;                        // Mark this withdrawal as processed
177             balances[token][msg.sender] -= amount;                      // Substract withdrawn token from users balance
178             if(token == address(0)){                                    // Withdraw ETH
179                 require(
180                     msg.sender.send(amount),
181                     "Sending of ETH failed."
182                 );
183             }else{                                                      // Withdraw an ERC20 token
184                 Token(token).transfer(msg.sender, amount);              // Transfer the ERC20 token
185                 require(
186                     checkERC20TransferSuccess(),                        // Check whether the ERC20 token transfer was successful
187                     "ERC20 token transfer failed."
188                 );
189             }
190 
191             blocked_for_single_sig_withdrawal[token][msg.sender] = 0;   // Set possible previous manual blocking of these funds to 0
192         
193             emit Withdrawal(msg.sender,token,amount);                   // Emit a Withdrawal event
194         }else{
195             revert();                                                   // Revert the transaction if checks fail
196         }
197     }    
198 
199     /** @notice User-submitted withdrawal with arbiters signature, which sends tokens to specified address
200       * @param  token              The token to withdraw (ETH is address(address(0)))
201       * @param  amount             The amount of tokens to withdraw
202       * @param  nonce              The nonce (to salt the hash)
203       * @param  v                  Multi-signature v
204       * @param  r                  Multi-signature r
205       * @param  s                  Multi-signature s
206       * @param  receiving_address  The address to send the withdrawn token/ETH to
207       */
208     function multiSigSend(address token, uint256 amount, uint64 nonce, uint8 v, bytes32 r, bytes32 s, address receiving_address) public {
209         bytes32 hash = keccak256(abi.encodePacked(                      // Calculate the withdrawal hash from the parameters 
210             "\x19Ethereum Signed Message:\n32", 
211             keccak256(abi.encodePacked(
212                 msg.sender,
213                 token,
214                 amount,
215                 nonce,
216                 address(this)
217             ))
218         ));
219         if(
220             !processed_withdrawals[hash]                                // Check if the withdrawal was initiated before
221             && arbiters[ecrecover(hash, v,r,s)]                         // Check if the multi-sig is valid
222             && balances[token][msg.sender] >= amount                    // Check if the user holds the required balance
223         ){
224             processed_withdrawals[hash]  = true;                        // Mark this withdrawal as processed
225             balances[token][msg.sender] -= amount;                      // Substract the withdrawn balance from the users balance
226             if(token == address(0)){                                    // Process an ETH withdrawal
227                 require(
228                     receiving_address.send(amount),
229                     "Sending of ETH failed."
230                 );
231             }else{                                                      // Withdraw an ERC20 token
232                 Token(token).transfer(receiving_address, amount);       // Transfer the ERC20 token
233                 require(
234                     checkERC20TransferSuccess(),                        // Check whether the ERC20 token transfer was successful
235                     "ERC20 token transfer failed."
236                 );
237             }
238 
239             blocked_for_single_sig_withdrawal[token][msg.sender] = 0;   // Set possible previous manual blocking of these funds to 0
240             
241             emit Withdrawal(msg.sender,token,amount);                   // Emit a Withdrawal event
242         }else{
243             revert();                                                   // Revert the transaction if checks fail
244         }
245     }
246 
247     /** @notice User-submitted transfer with arbiters signature, which sends tokens to another addresses account in the smart contract
248       * @param  token              The token to transfer (ETH is address(address(0)))
249       * @param  amount             The amount of tokens to transfer
250       * @param  nonce              The nonce (to salt the hash)
251       * @param  v                  Multi-signature v
252       * @param  r                  Multi-signature r
253       * @param  s                  Multi-signature s
254       * @param  receiving_address  The address to transfer the token/ETH to
255       */
256     function multiSigTransfer(address token, uint256 amount, uint64 nonce, uint8 v, bytes32 r, bytes32 s, address receiving_address) public {
257         bytes32 hash = keccak256(abi.encodePacked(                      // Calculate the withdrawal/transfer hash from the parameters 
258             "\x19Ethereum Signed Message:\n32", 
259             keccak256(abi.encodePacked(
260                 msg.sender,
261                 token,
262                 amount,
263                 nonce,
264                 address(this)
265             ))
266         ));
267         if(
268             !processed_withdrawals[hash]                                // Check if the withdrawal was initiated before
269             && arbiters[ecrecover(hash, v,r,s)]                         // Check if the multi-sig is valid
270             && balances[token][msg.sender] >= amount                    // Check if the user holds the required balance
271         ){
272             processed_withdrawals[hash]         = true;                 // Mark this withdrawal as processed
273             balances[token][msg.sender]        -= amount;               // Substract the balance from the withdrawing account
274             balances[token][receiving_address] += amount;               // Add the balance to the receiving account
275             
276             blocked_for_single_sig_withdrawal[token][msg.sender] = 0;   // Set possible previous manual blocking of these funds to 0
277             
278             emit Withdrawal(msg.sender,token,amount);                   // Emit a Withdrawal event
279             emit Deposit(receiving_address,token,amount);               // Emit a Deposit event
280         }else{
281             revert();                                                   // Revert the transaction if checks fail
282         }
283     }
284 
285     /** @notice Arbiter submitted withdrawal with users multi-sig to users address
286       * @param  token   The token to withdraw (ETH is address(address(0)))
287       * @param  amount  The amount of tokens to withdraw
288       * @param  fee     The fee, covering the gas cost of the arbiter
289       * @param  nonce   The nonce (to salt the hash)
290       * @param  v       Multi-signature v (either 27 or 28. To identify the different signing schemes an offset of 10 is applied for EIP712)
291       * @param  r       Multi-signature r
292       * @param  s       Multi-signature s
293       */
294     function userSigWithdrawal(address token, uint256 amount, uint256 fee, uint64 nonce, uint8 v, bytes32 r, bytes32 s) public {            
295         bytes32 hash;
296         if(v < 30){                                                     // Standard signing scheme (personal.sign())
297             hash = keccak256(abi.encodePacked(                          // Restore multi-sig hash
298                 "\x19Ethereum Signed Message:\n32",
299                 keccak256(abi.encodePacked(
300                     token,
301                     amount,
302                     nonce,
303                     address(this)
304                 ))
305             ));
306         }else{                                                          // EIP712 signing scheme
307             v -= 10;                                                    // Remove offset
308             hash = keccak256(abi.encodePacked(                          // Restore multi-sig hash
309                 "\x19\x01",
310                 EIP712_DOMAIN_SEPARATOR,
311                 keccak256(abi.encode(
312                     EIP712_WITHDRAWAL_TYPEHASH,
313                     token,
314                     amount,
315                     nonce
316                 ))
317             ));
318         }
319         address account = ecrecover(hash, v, r, s);                     // Restore signing address
320         if(
321             !processed_withdrawals[hash]                                // Check if the withdrawal was initiated before
322             && arbiters[msg.sender]                                     // Check if transaction comes from arbiter
323             && fee <= amount / 50                                       // Check if fee is not too big
324             && balances[token][account] >= amount                       // Check if the user holds the required tokens
325         ){
326             processed_withdrawals[hash]    = true;
327             balances[token][account]      -= amount;
328             balances[token][feeCollector] += fee;                       // Fee to cover gas costs for the withdrawal
329             if(token == address(0)){                                    // Send ETH
330                 require(
331                     account.send(amount - fee),
332                     "Sending of ETH failed."
333                 );
334             }else{
335                 Token(token).transfer(account, amount - fee);           // Withdraw ERC20
336                 require(
337                     checkERC20TransferSuccess(),                        // Check if the transfer was successful
338                     "ERC20 token transfer failed."
339                 );
340             }
341         
342             blocked_for_single_sig_withdrawal[token][account] = 0;      // Set possible previous manual blocking of these funds to 0
343             
344             emit Withdrawal(account,token,amount);                      // Emit a Withdrawal event
345         }else{
346             revert();                                                   // Revert the transaction is checks fail
347         }
348     }
349     
350     // Single-sig withdrawal functions:
351 
352     /** @notice Allows user to block funds for single-sig withdrawal after 24h waiting period 
353       *         (This period is necessary to ensure all trades backed by these funds will be settled.)
354       * @param  token   The address of the token to block (ETH is address(address(0)))
355       * @param  amount  The amount of the token to block
356       */
357     function blockFundsForSingleSigWithdrawal(address token, uint256 amount) public {
358         if (balances[token][msg.sender] - blocked_for_single_sig_withdrawal[token][msg.sender] >= amount){  // Check if the user holds the required funds
359             blocked_for_single_sig_withdrawal[token][msg.sender] += amount;         // Block funds for manual withdrawal
360             last_blocked_timestamp[msg.sender] = block.timestamp;                   // Start 24h waiting period
361             emit BlockedForSingleSigWithdrawal(msg.sender,token,amount);            // Emit BlockedForSingleSigWithdrawal event
362         }else{
363             revert();                                                               // Revert the transaction if the user does not hold the required balance
364         }
365     }
366     
367     /** @notice Allows user to withdraw funds previously blocked after 24h
368       */
369     function initiateSingleSigWithdrawal(address token, uint256 amount) public {
370         if (
371             balances[token][msg.sender] >= amount                                   // Check if the user holds the funds
372             && blocked_for_single_sig_withdrawal[token][msg.sender] >= amount       // Check if these funds are blocked
373             && last_blocked_timestamp[msg.sender] + 86400 <= block.timestamp        // Check if the one day waiting period has passed
374         ){
375             balances[token][msg.sender] -= amount;                                  // Substract the tokens from users balance
376             blocked_for_single_sig_withdrawal[token][msg.sender] -= amount;         // Substract the tokens from users blocked balance
377             if(token == address(0)){                                                // Withdraw ETH
378                 require(
379                     msg.sender.send(amount),
380                     "Sending of ETH failed."
381                 );
382             }else{                                                                  // Withdraw ERC20 tokens
383                 Token(token).transfer(msg.sender, amount);                          // Transfer the ERC20 tokens
384                 require(
385                     checkERC20TransferSuccess(),                                    // Check if the transfer was successful
386                     "ERC20 token transfer failed."
387                 );
388             }
389             emit SingleSigWithdrawal(msg.sender,token,amount);                      // Emit a SingleSigWithdrawal event
390         }else{
391             revert();                                                               // Revert the transaction if the required checks fail
392         }
393     } 
394 
395 
396     //Trade settlement structs and function
397     
398     struct OrderInput{
399         uint8       buy_token;      // The token, the order signee wants to buy
400         uint8       sell_token;     // The token, the order signee wants to sell
401         uint256     buy_amount;     // The total amount the signee wants to buy
402         uint256     sell_amount;    // The total amount the signee wants to give for the amount he wants to buy (the orders "rate" is implied by the ratio between the two amounts)
403         uint64      nonce;          // Random number to give each order an individual hash and signature
404         int8        v;              // Signature v (either 27 or 28)
405                                     // To identify the different signing schemes an offset of 10 is applied for EIP712.
406                                     // To identify whether the order was signed by a delegated signing address, the number is either positive or negative.
407         bytes32     r;              // Signature r
408         bytes32     s;              // Signature s
409     }
410     
411     struct TradeInput{
412         uint8       maker_order;    // The index of the maker order
413         uint8       taker_order;    // The index of the taker order
414         uint256     maker_amount;   // The amount the maker gives in return for the taker's tokens
415         uint256     taker_amount;   // The amount the taker gives in return for the maker's tokens
416         uint256     maker_fee;      // The trading fee of the maker + a share in the settlement (gas) cost
417         uint256     taker_fee;      // The trading fee of the taker + a share in the settlement (gas) cost
418         uint256     maker_rebate;   // A optional rebate for the maker (portion of takers fee) as an incentive
419     }
420 
421     /** @notice Allows an arbiter to settle trades between two user-signed orders
422       * @param  addresses  Array of all addresses involved in the transactions
423       * @param  orders     Array of all orders involved in the transactions
424       * @param  trades     Array of the trades to be settled
425       */   
426     function matchTrades(address[] addresses, OrderInput[] orders, TradeInput[] trades) public {
427         require(arbiters[msg.sender] && marketActive);      // Check if msg.sender is an arbiter and the market is active
428         
429         //Restore signing addresses
430         uint len = orders.length;                           // Length of orders array to loop through
431         bytes32[]  memory hashes = new bytes32[](len);      // Array of the restored order hashes
432         address[]  memory signee = new address[](len);      // Array of the restored order signees
433         OrderInput memory order;                            // Memory slot to cache orders while looping (otherwise the Stack would be too deep)
434         address    addressCache1;                           // Memory slot 1 to cache addresses while looping (otherwise the Stack would be too deep)
435         address    addressCache2;                           // Memory slot 2 to cache addresses while looping (otherwise the Stack would be too deep)
436         bool       delegated;
437         
438         for(uint8 i = 0; i < len; i++){                     // Loop through the orders array to restore all signees
439             order         = orders[i];                      // Cache order
440             addressCache1 = addresses[order.buy_token];     // Cache orders buy token
441             addressCache2 = addresses[order.sell_token];    // Cache orders sell token
442             
443             if(order.v < 0){                                // Check if the order is signed by a delegate
444                 delegated = true;                           
445                 order.v  *= -1;                             // Restore the negated v
446             }else{
447                 delegated = false;
448             }
449             
450             if(order.v < 30){                               // Order is hashed after signature scheme personal.sign()
451                 hashes[i] = keccak256(abi.encodePacked(     // Restore the hash of this order
452                     "\x19Ethereum Signed Message:\n32",
453                     keccak256(abi.encodePacked(
454                         addressCache1,
455                         addressCache2,
456                         order.buy_amount,
457                         order.sell_amount,
458                         order.nonce,        
459                         address(this)                       // This contract's address
460                     ))
461                 ));
462             }else{                                          // Order is hashed after EIP712
463                 order.v -= 10;                              // Remove signature format identifying offset
464                 hashes[i] = keccak256(abi.encodePacked(
465                     "\x19\x01",
466                     EIP712_DOMAIN_SEPARATOR,
467                     keccak256(abi.encode(
468                         EIP712_ORDER_TYPEHASH,
469                         addressCache1,
470                         addressCache2,
471                         order.buy_amount,
472                         order.sell_amount,
473                         order.nonce
474                     ))
475                 ));
476             }
477             signee[i] = ecrecover(                          // Restore the signee of this order
478                 hashes[i],                                  // Order hash
479                 uint8(order.v),                             // Signature v
480                 order.r,                                    // Signature r
481                 order.s                                     // Signature s
482             );
483             // When the signature was delegated restore delegating address
484             if(delegated){
485                 signee[i] = delegates[signee[i]];
486             }
487         }
488         
489         // Settle Trades after check
490         len = trades.length;                                            // Length of the trades array to loop through
491         TradeInput memory trade;                                        // Memory slot to cache trades while looping
492         uint maker_index;                                               // Memory slot to cache the trade's maker order index
493         uint taker_index;                                               // Memory slot to cache the trade's taker order index
494         
495         for(i = 0; i < len; i++){                                       // Loop through trades to settle after checks
496             trade = trades[i];                                          // Cache trade
497             maker_index = trade.maker_order;                            // Cache maker order index
498             taker_index = trade.taker_order;                            // Cache taker order index
499             addressCache1 = addresses[orders[maker_index].buy_token];   // Cache first of the two swapped token addresses
500             addressCache2 = addresses[orders[taker_index].buy_token];   // Cache second of the two swapped token addresses
501             
502             if( // Check if the arbiter has matched following the conditions of the two order signees
503                 // Do maker and taker want to trade the same tokens with each other
504                     orders[maker_index].buy_token == orders[taker_index].sell_token
505                 && orders[taker_index].buy_token == orders[maker_index].sell_token
506                 
507                 // Do maker and taker hold the required balances
508                 && balances[addressCache2][signee[maker_index]] >= trade.maker_amount - trade.maker_rebate
509                 && balances[addressCache1][signee[taker_index]] >= trade.taker_amount
510                 
511                 // Are they both matched at a rate better or equal to the one they signed
512                 && trade.maker_amount - trade.maker_rebate <= orders[maker_index].sell_amount * trade.taker_amount / orders[maker_index].buy_amount + 1  // Check maker doesn't overpay (+ 1 to deal with rouding errors for very smal amounts)
513                 && trade.taker_amount <= orders[taker_index].sell_amount * trade.maker_amount / orders[taker_index].buy_amount + 1                       // Check taker doesn't overpay (+ 1 to deal with rouding errors for very smal amounts)
514                 
515                 // Check if the matched amount + previously matched trades doesn't exceed the amount specified by the order signee
516                 && trade.taker_amount + matched[hashes[taker_index]] <= orders[taker_index].sell_amount
517                 && trade.maker_amount - trade.maker_rebate + matched[hashes[maker_index]] <= orders[maker_index].sell_amount
518                     
519                 // Check if the charged fee is not too high
520                 && trade.maker_fee <= trade.taker_amount / 100
521                 && trade.taker_fee <= trade.maker_amount / 50
522                 
523                 // Check if maker_rebate is smaller than or equal to the taker's fee which compensates it
524                 && trade.maker_rebate <= trade.taker_fee
525             ){
526                 // Settle the trade:
527                 
528                 // Substract sold amounts
529                 balances[addressCache2][signee[maker_index]] -= trade.maker_amount - trade.maker_rebate;    // Substract maker's sold amount minus the makers rebate
530                 balances[addressCache1][signee[taker_index]] -= trade.taker_amount;                         // Substract taker's sold amount
531                 
532                 // Add bought amounts
533                 balances[addressCache1][signee[maker_index]] += trade.taker_amount - trade.maker_fee;       // Give the maker his bought amount minus the fee
534                 balances[addressCache2][signee[taker_index]] += trade.maker_amount - trade.taker_fee;       // Give the taker his bought amount minus the fee
535                 
536                 // Save bought amounts to prevent double matching
537                 matched[hashes[maker_index]] += trade.maker_amount;                                         // Prevent maker order from being reused
538                 matched[hashes[taker_index]] += trade.taker_amount;                                         // Prevent taker order from being reused
539                 
540                 // Give fee to feeCollector
541                 balances[addressCache2][feeCollector] += trade.taker_fee - trade.maker_rebate;              // Give the feeColletor the taker fee minus the maker rebate 
542                 balances[addressCache1][feeCollector] += trade.maker_fee;                                   // Give the feeColletor the maker fee
543                 
544                 // Set possible previous manual blocking of these funds to 0
545                 blocked_for_single_sig_withdrawal[addressCache2][signee[maker_index]] = 0;                  // If the maker tried to block funds which he/she used in this order we have to unblock them
546                 blocked_for_single_sig_withdrawal[addressCache1][signee[taker_index]] = 0;                  // If the taker tried to block funds which he/she used in this order we have to unblock them
547                 
548                 emit TradeSettled(i);                                                                       // Emit tradeSettled Event to confirm the trade was settled
549             }else{
550                 emit TradeFailed(i);                                                                        // Emit tradeFailed Event because the trade checks failed
551             }
552         }
553     }
554 
555 
556     // Order cancellation functions
557 
558     /** @notice Give the user the option to perform multiple on-chain cancellations of orders at once with arbiters multi-sig
559       * @param  orderHashes Array of orderHashes of the orders to be canceled
560       * @param  v           Multi-sig v
561       * @param  r           Multi-sig r
562       * @param  s           Multi-sig s
563       */
564     function multiSigOrderBatchCancel(bytes32[] orderHashes, uint8 v, bytes32 r, bytes32 s) public {
565         if(
566             arbiters[                                               // Check if the signee is an arbiter
567                 ecrecover(                                          // Restore the signing address
568                     keccak256(abi.encodePacked(                     // Restore the signed hash (hash of all orderHashes)
569                         "\x19Ethereum Signed Message:\n32", 
570                         keccak256(abi.encodePacked(orderHashes))
571                     )),
572                     v, r, s
573                 )
574             ]
575         ){
576             uint len = orderHashes.length;
577             for(uint8 i = 0; i < len; i++){
578                 matched[orderHashes[i]] = 2**256 - 1;               // Set the matched amount of all orders to the maximum
579                 emit OrderCanceled(orderHashes[i]);                 // emit OrderCanceled event
580             }
581         }else{
582             revert();
583         }
584     }
585         
586     /** @notice Give arbiters the option to perform on-chain multiple cancellations of orders at once  
587       * @param orderHashes Array of hashes of the orders to be canceled
588       */
589     function orderBatchCancel(bytes32[] orderHashes) public {
590         if(
591             arbiters[msg.sender]                        // Check if the sender is an arbiter
592         ){
593             uint len = orderHashes.length;
594             for(uint8 i = 0; i < len; i++){
595                 matched[orderHashes[i]] = 2**256 - 1;   // Set the matched amount of all orders to the maximum
596                 emit OrderCanceled(orderHashes[i]);     // emit OrderCanceled event
597             }
598         }else{
599             revert();
600         }
601     }
602         
603         
604     // Signature delegation
605 
606     /** @notice delegate an address to allow it to sign orders on your behalf
607       * @param delegate  The address to delegate
608       */
609     function delegateAddress(address delegate) public {
610         // set as delegate
611         require(delegates[delegate] == address(0), "Address is already a delegate");
612         delegates[delegate] = msg.sender;
613         
614         emit DelegateStatus(msg.sender, delegate, true);
615     }
616     
617     /** @notice revoke the delegation of an address
618       * @param  delegate  The delegated address
619       * @param  v         Multi-sig v
620       * @param  r         Multi-sig r
621       * @param  s         Multi-sig s
622       */
623     function revokeDelegation(address delegate, uint8 v, bytes32 r, bytes32 s) public {
624         bytes32 hash = keccak256(abi.encodePacked(              // Restore the signed hash
625             "\x19Ethereum Signed Message:\n32", 
626             keccak256(abi.encodePacked(
627                 delegate,
628                 msg.sender,
629                 address(this)
630             ))
631         ));
632 
633         require(arbiters[ecrecover(hash, v, r, s)], "MultiSig is not from known arbiter");  // Check if signee is an arbiter
634         
635         delegates[delegate] = address(1);       // set to 1 not 0 to prevent double delegation, which would make old signed order valid for the new delegator
636         
637         emit DelegateStatus(msg.sender, delegate, false);
638     }
639     
640 
641     // Management functions:
642 
643     address owner;                      // Contract owner address (has the right to nominate arbiters and the feeCollectors addresses)   
644     address feeCollector;               // feeCollector address
645     bool marketActive = true;           // Make it possible to pause the market
646     bool feeCollectorLocked = false;    // Make it possible to lock the feeCollector address (to allow to change the feeCollector to a fee distribution contract)
647     mapping(address => bool) arbiters;  // Mapping of arbiters
648     
649     /** @notice Constructor function
650       */
651     constructor() public {
652         owner = msg.sender;             // Nominate sender to be the contract owner
653         feeCollector = msg.sender;      // Nominate sender to be the standart feeCollector
654         arbiters[msg.sender] = true;    // Nominate sender to be an arbiter
655         
656         // create EIP712 domain seperator
657         EIP712_Domain memory eip712Domain = EIP712_Domain({
658             name              : "dex.blue",
659             version           : "1",
660             chainId           : 1,
661             verifyingContract : this
662         });
663         EIP712_DOMAIN_SEPARATOR = keccak256(abi.encode(
664             EIP712_DOMAIN_TYPEHASH,
665             keccak256(bytes(eip712Domain.name)),
666             keccak256(bytes(eip712Domain.version)),
667             eip712Domain.chainId,
668             eip712Domain.verifyingContract
669         ));
670     }
671     
672     /** @notice Allows the owner to nominate or denominate trade arbitting addresses
673       * @param  arbiter The arbiter whose status to change
674       * @param  status  Whether the address should be an arbiter (true) or not (false)
675       */
676     function nominateArbiter(address arbiter, bool status) public {
677         require(msg.sender == owner);                           // Check if sender is owner
678         arbiters[arbiter] = status;                             // Update address status
679     }
680 
681     /** @notice Allows the owner to pause / unpause the market
682       * @param  state  Whether the the market should be active (true) or paused (false)
683       */
684     function setMarketActiveState(bool state) public {
685         require(msg.sender == owner);                           // Check if sender is owner
686         marketActive = state;                                   // pause / unpause market
687     }
688     
689     /** @notice Allows the owner to nominate the feeCollector address
690       * @param  collector The address to nominate as feeCollector
691       */
692     function nominateFeeCollector(address collector) public {
693         require(msg.sender == owner && !feeCollectorLocked);    // Check if sender is owner and feeCollector address is not locked
694         feeCollector = collector;                               // Update feeCollector address
695     }
696     
697     /** @notice Allows the owner to lock the feeCollector address
698   */
699     function lockFeeCollector() public {
700         require(msg.sender == owner);                           // Check if sender is owner
701         feeCollectorLocked = true;                              // Lock feeCollector address
702     }
703     
704     /** @notice Get the feeCollectors address
705       * @return The feeCollectors address
706       */
707     function getFeeCollector() public constant returns (address){
708         return feeCollector;
709     }
710 
711     /** @notice Allows the feeCollector to directly withdraw his funds (would allow a fee distribution contract to withdraw collected fees)
712       * @param  token   The token to withdraw
713       * @param  amount  The amount of tokens to withdraw
714   */
715     function feeWithdrawal(address token, uint256 amount) public {
716         if (
717             msg.sender == feeCollector                              // Check if the sender is the feeCollector
718             && balances[token][feeCollector] >= amount              // Check if feeCollector has the sufficient balance
719         ){
720             balances[token][feeCollector] -= amount;                // Substract the feeCollectors balance
721             if(token == address(0)){                                // Is the withdrawal token ETH
722                 require(
723                     feeCollector.send(amount),                      // Withdraw ETH
724                     "Sending of ETH failed."
725                 );
726             }else{
727                 Token(token).transfer(feeCollector, amount);        // Withdraw ERC20
728                 require(                                            // Revert if the withdrawal failed
729                     checkERC20TransferSuccess(),
730                     "ERC20 token transfer failed."
731                 );
732             }
733             emit FeeWithdrawal(token,amount);                       // Emit FeeWithdrawal event
734         }else{
735             revert();                                               // Revert the transaction if the checks fail
736         }
737     }
738     
739     // We have to check returndatasize after ERC20 tokens transfers, as some tokens are implemented badly (dont return a boolean)
740     function checkERC20TransferSuccess() pure private returns(bool){
741         uint256 success = 0;
742 
743         assembly {
744             switch returndatasize               // Check the number of bytes the token contract returned
745                 case 0 {                        // Nothing returned, but contract did not throw > assume our transfer succeeded
746                     success := 1
747                 }
748                 case 32 {                       // 32 bytes returned, result is the returned bool
749                     returndatacopy(0, 0, 32)
750                     success := mload(0)
751                 }
752         }
753 
754         return success != 0;
755     }
756 }
757 
758 
759 
760 
761 // Standart ERC20 token interface to interact with ERC20 token contracts
762 // To support badly implemented tokens (which dont return a boolean on the transfer functions)
763 // we have to expect a badly implemented token and then check with checkERC20TransferSuccess() whether the transfer succeeded
764 
765 contract Token {
766     /** @return total amount of tokens
767       */
768     function totalSupply() constant public returns (uint256 supply) {}
769 
770     /** @param _owner The address from which the balance will be retrieved
771       * @return The balance
772       */
773     function balanceOf(address _owner) constant public returns (uint256 balance) {}
774 
775     /** @notice send `_value` token to `_to` from `msg.sender`
776       * @param  _to     The address of the recipient
777       * @param  _value  The amount of tokens to be transferred
778       * @return Whether the transfer was successful or not
779       */
780     function transfer(address _to, uint256 _value) public {}
781 
782     /** @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
783       * @param  _from   The address of the sender
784       * @param  _to     The address of the recipient
785       * @param  _value  The amount of tokens to be transferred
786       * @return Whether the transfer was successful or not
787       */
788     function transferFrom(address _from, address _to, uint256 _value)  public {}
789 
790     /** @notice `msg.sender` approves `_addr` to spend `_value` tokens
791       * @param  _spender The address of the account able to transfer the tokens
792       * @param  _value   The amount of wei to be approved for transfer
793       * @return Whether the approval was successful or not
794       */
795     function approve(address _spender, uint256 _value) public returns (bool success) {}
796 
797     /** @param  _owner   The address of the account owning tokens
798       * @param  _spender The address of the account able to transfer the tokens
799       * @return Amount of remaining tokens allowed to spend
800       */
801     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {}
802 
803     event Transfer(address indexed _from, address indexed _to, uint256 _value);
804     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
805 
806     uint public decimals;
807     string public name;
808 }