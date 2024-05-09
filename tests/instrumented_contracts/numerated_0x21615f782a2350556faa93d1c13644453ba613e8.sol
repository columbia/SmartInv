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
19 // The DMEX base Contract
20 contract Exchange {
21     function assert(bool assertion) {
22         if (!assertion) throw;
23     }
24 
25     // Safe Multiply Function - prevents integer overflow 
26     function safeMul(uint a, uint b) returns (uint) {
27         uint c = a * b;
28         assert(a == 0 || c / a == b);
29         return c;
30     }
31 
32     // Safe Subtraction Function - prevents integer overflow 
33     function safeSub(uint a, uint b) returns (uint) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     // Safe Addition Function - prevents integer overflow 
39     function safeAdd(uint a, uint b) returns (uint) {
40         uint c = a + b;
41         assert(c>=a && c>=b);
42         return c;
43     }
44 
45     address public owner; // holds the address of the contract owner
46     mapping (address => bool) public admins; // mapping of admin addresses
47     mapping (address => bool) public futuresContracts; // mapping of connected futures contracts
48     mapping (address => uint256) public futuresContractsAddedBlock; // mapping of connected futures contracts and connection block numbers
49     event SetFuturesContract(address futuresContract, bool isFuturesContract);
50 
51     // Event fired when the owner of the contract is changed
52     event SetOwner(address indexed previousOwner, address indexed newOwner);
53 
54     // Allows only the owner of the contract to execute the function
55     modifier onlyOwner {
56         assert(msg.sender == owner);
57         _;
58     }
59 
60     // Changes the owner of the contract
61     function setOwner(address newOwner) onlyOwner {
62         SetOwner(owner, newOwner);
63         owner = newOwner;
64     }
65 
66     // Owner getter function
67     function getOwner() returns (address out) {
68         return owner;
69     }
70 
71     // Adds or disables an admin account
72     function setAdmin(address admin, bool isAdmin) onlyOwner {
73         admins[admin] = isAdmin;
74     }
75 
76 
77     // Adds or disables a futuresContract address
78     function setFuturesContract(address futuresContract, bool isFuturesContract) onlyOwner {
79         futuresContracts[futuresContract] = isFuturesContract;
80         if (fistFuturesContract == address(0))
81         {
82             fistFuturesContract = futuresContract;
83         }
84         futuresContractsAddedBlock[futuresContract] = block.number;
85         emit SetFuturesContract(futuresContract, isFuturesContract);
86     }
87 
88     // Allows for admins only to call the function
89     modifier onlyAdmin {
90         if (msg.sender != owner && !admins[msg.sender]) throw;
91         _;
92     }
93 
94     // Allows for futures contracts only to call the function
95     modifier onlyFuturesContract {
96         if (!futuresContracts[msg.sender]) throw;
97         _;
98     }
99 
100     function() external {
101         throw;
102     }
103 
104     //mapping (address => mapping (address => uint256)) public tokens; // mapping of token addresses to mapping of balances  // tokens[token][user]
105     //mapping (address => mapping (address => uint256)) public reserve; // mapping of token addresses to mapping of reserved balances  // reserve[token][user]
106     mapping (address => mapping (address => uint256)) public balances; // mapping of token addresses to mapping of balances and reserve (bitwise compressed) // balances[token][user]
107 
108     mapping (address => uint256) public lastActiveTransaction; // mapping of user addresses to last transaction block
109     mapping (bytes32 => uint256) public orderFills; // mapping of orders to filled qunatity
110     
111     mapping (address => mapping (address => bool)) public userAllowedFuturesContracts; // mapping of allowed futures smart contracts per user
112     mapping (address => uint256) public userFirstDeposits; // mapping of user addresses and block number of first deposit
113 
114     address public feeAccount; // the account that receives the trading fees
115     address public EtmTokenAddress; // the address of the EtherMium token
116     address public fistFuturesContract; // 0x if there are no futures contracts set yet
117 
118     uint256 public inactivityReleasePeriod; // period in blocks before a user can use the withdraw() function
119     mapping (bytes32 => bool) public withdrawn; // mapping of withdraw requests, makes sure the same withdrawal is not executed twice
120     uint256 public makerFee; // maker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
121     uint256 public takerFee; // taker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
122 
123     enum Errors {
124         INVLID_PRICE,           // Order prices don't match
125         INVLID_SIGNATURE,       // Signature is invalid
126         TOKENS_DONT_MATCH,      // Maker/taker tokens don't match
127         ORDER_ALREADY_FILLED,   // Order was already filled
128         GAS_TOO_HIGH            // Too high gas fee
129     }
130 
131     // Trade event fired when a trade is executed
132     event Trade(
133         address takerTokenBuy, uint256 takerAmountBuy,
134         address takerTokenSell, uint256 takerAmountSell,
135         address maker, address indexed taker,
136         uint256 makerFee, uint256 takerFee,
137         uint256 makerAmountTaken, uint256 takerAmountTaken,
138         bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash
139     );
140 
141     // Deposit event fired when a deposit took place
142     event Deposit(address indexed token, address indexed user, uint256 amount, uint256 balance);
143 
144     // Withdraw event fired when a withdrawal was executed
145     event Withdraw(address indexed token, address indexed user, uint256 amount, uint256 balance, uint256 withdrawFee);
146     event WithdrawTo(address indexed token, address indexed to, address indexed from, uint256 amount, uint256 balance, uint256 withdrawFee);
147 
148     // Fee change event
149     event FeeChange(uint256 indexed makerFee, uint256 indexed takerFee);
150 
151     // Log event, logs errors in contract execution (used for debugging)
152     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
153     event LogUint(uint8 id, uint256 value);
154     event LogBool(uint8 id, bool value);
155     event LogAddress(uint8 id, address value);
156 
157     // Change inactivity release period event
158     event InactivityReleasePeriodChange(uint256 value);
159 
160     // Order cancelation event
161     event CancelOrder(
162         bytes32 indexed cancelHash,
163         bytes32 indexed orderHash,
164         address indexed user,
165         address tokenSell,
166         uint256 amountSell,
167         uint256 cancelFee
168     );
169 
170     // Sets the inactivity period before a user can withdraw funds manually
171     function setInactivityReleasePeriod(uint256 expiry) onlyOwner returns (bool success) {
172         if (expiry > 1000000) throw;
173         inactivityReleasePeriod = expiry;
174 
175         emit InactivityReleasePeriodChange(expiry);
176         return true;
177     }
178 
179     // Constructor function, initializes the contract and sets the core variables
180     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, uint256 inactivityReleasePeriod_) {
181         owner = msg.sender;
182         feeAccount = feeAccount_;
183         inactivityReleasePeriod = inactivityReleasePeriod_;
184         makerFee = makerFee_;
185         takerFee = takerFee_;
186     }
187 
188     // Changes the fees
189     function setFees(uint256 makerFee_, uint256 takerFee_) onlyOwner {
190         require(makerFee_ < 10 finney && takerFee_ < 10 finney); // The fees cannot be set higher then 1%
191         makerFee = makerFee_;
192         takerFee = takerFee_;
193 
194         emit FeeChange(makerFee, takerFee);
195     }
196 
197     
198 
199 
200 
201     function updateBalanceAndReserve (address token, address user, uint256 balance, uint256 reserve) private
202     {
203         uint256 character = uint256(balance);
204         character |= reserve<<128;
205 
206         balances[token][user] = character;
207     }
208 
209     function updateBalance (address token, address user, uint256 balance) private returns (bool)
210     {
211         uint256 character = uint256(balance);
212         character |= getReserve(token, user)<<128;
213 
214         balances[token][user] = character;
215         return true;
216     }
217 
218     function updateReserve (address token, address user, uint256 reserve) private
219     {
220         uint256 character = uint256(balanceOf(token, user));
221         character |= reserve<<128;
222 
223         balances[token][user] = character;
224     }
225 
226     function decodeBalanceAndReserve (address token, address user) returns (uint256[2])
227     {
228         uint256 character = balances[token][user];
229         uint256 balance = uint256(uint128(character));
230         uint256 reserve = uint256(uint128(character>>128));
231 
232         return [balance, reserve];
233     }
234 
235     function futuresContractAllowed (address futuresContract, address user) returns (bool)
236     {
237         if (fistFuturesContract == futuresContract) return true;
238         if (userAllowedFuturesContracts[user][futuresContract] == true) return true;
239         if (futuresContractsAddedBlock[futuresContract] < userFirstDeposits[user]) return true;
240 
241         return false;
242     }
243 
244     // Returns the balance of a specific token for a specific user
245     function balanceOf(address token, address user) view returns (uint256) {
246         //return tokens[token][user];
247         return decodeBalanceAndReserve(token, user)[0];
248     }
249 
250     // Returns the reserved amound of token for user
251     function getReserve(address token, address user) public view returns (uint256) { 
252         //return reserve[token][user];  
253         return decodeBalanceAndReserve(token, user)[1];
254     }
255 
256     // Sets reserved amount for specific token and user (can only be called by futures contract)
257     function setReserve(address token, address user, uint256 amount) onlyFuturesContract returns (bool success) { 
258         if (!futuresContractAllowed(msg.sender, user)) throw;
259         if (availableBalanceOf(token, user) < amount) throw; 
260         updateReserve(token, user, amount);
261         return true; 
262     }
263 
264     // Updates user balance (only can be used by futures contract)
265     function setBalance(address token, address user, uint256 amount) onlyFuturesContract returns (bool success)     {
266         if (!futuresContractAllowed(msg.sender, user)) throw;
267         updateBalance(token, user, amount);
268         return true;
269         
270     }
271 
272     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) onlyFuturesContract returns (bool)
273     {
274         if (!futuresContractAllowed(msg.sender, user)) throw;
275         updateBalanceAndReserve(token, user, safeSub(balanceOf(token, user), subBalance), safeAdd(getReserve(token, user), addReserve));
276     }
277 
278     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) onlyFuturesContract returns (bool)
279     {
280         if (!futuresContractAllowed(msg.sender, user)) throw;
281         updateBalanceAndReserve(token, user, safeAdd(balanceOf(token, user), addBalance), safeSub(getReserve(token, user), subReserve));
282     }
283 
284     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) onlyFuturesContract returns (bool)
285     {
286         if (!futuresContractAllowed(msg.sender, user)) throw;
287         updateBalanceAndReserve(token, user, safeSub(balanceOf(token, user), subBalance), safeSub(getReserve(token, user), subReserve));
288     }
289 
290     // Returns the available balance of a specific token for a specific user
291     function availableBalanceOf(address token, address user) view returns (uint256) {
292         return safeSub(balanceOf(token, user), getReserve(token, user));
293     }
294 
295     // Returns the inactivity release perios
296     function getInactivityReleasePeriod() view returns (uint256)
297     {
298         return inactivityReleasePeriod;
299     }
300 
301     // Increases the user balance
302     function addBalance(address token, address user, uint256 amount)
303     {
304         updateBalance(token, user, safeAdd(balanceOf(token, user), amount));
305     }
306 
307     // Decreases user balance
308     function subBalance(address token, address user, uint256 amount)
309     {
310         if (availableBalanceOf(token, user) < amount) throw; 
311         updateBalance(token, user, safeSub(balanceOf(token, user), amount));
312     }
313 
314 
315     // Deposit ETH to contract
316     function deposit() payable {
317         //tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value); // adds the deposited amount to user balance
318         addBalance(address(0), msg.sender, msg.value); // adds the deposited amount to user balance
319         if (userFirstDeposits[msg.sender] == 0) userFirstDeposits[msg.sender] = block.number;
320         lastActiveTransaction[msg.sender] = block.number; // sets the last activity block for the user
321         emit Deposit(address(0), msg.sender, msg.value, balanceOf(address(0), msg.sender)); // fires the deposit event
322     }
323 
324     // Deposit token to contract
325     function depositToken(address token, uint128 amount) {
326         //tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount); // adds the deposited amount to user balance
327         //if (amount != uint128(amount) || safeAdd(amount, balanceOf(token, msg.sender)) != uint128(amount)) throw;
328         addBalance(token, msg.sender, amount); // adds the deposited amount to user balance
329 
330         if (userFirstDeposits[msg.sender] == 0) userFirstDeposits[msg.sender] = block.number;
331         lastActiveTransaction[msg.sender] = block.number; // sets the last activity block for the user
332         if (!Token(token).transferFrom(msg.sender, this, amount)) throw; // attempts to transfer the token to this contract, if fails throws an error
333         emit Deposit(token, msg.sender, amount, balanceOf(token, msg.sender)); // fires the deposit event
334     }
335 
336     function withdraw(address token, uint256 amount) returns (bool success) {
337         //if (safeSub(block.number, lastActiveTransaction[msg.sender]) < inactivityReleasePeriod) throw; // checks if the inactivity period has passed
338         //if (tokens[token][msg.sender] < amount) throw; // checks that user has enough balance
339         if (availableBalanceOf(token, msg.sender) < amount) throw;
340 
341         //tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount); 
342         subBalance(token, msg.sender, amount); // subtracts the withdrawed amount from user balance
343 
344         if (token == address(0)) { // checks if withdrawal is a token or ETH, ETH has address 0x00000... 
345             if (!msg.sender.send(amount)) throw; // send ETH
346         } else {
347             if (!Token(token).transfer(msg.sender, amount)) throw; // Send token
348         }
349         emit Withdraw(token, msg.sender, amount, balanceOf(token, msg.sender), 0); // fires the Withdraw event
350     }
351 
352     function userAllowFuturesContract(address futuresContract)
353     {
354         if (!futuresContracts[futuresContract]) throw;
355         userAllowedFuturesContracts[msg.sender][futuresContract] = true;
356     }
357 
358     // Withdrawal function used by the server to execute withdrawals
359     function adminWithdraw(
360         address token, // the address of the token to be withdrawn
361         uint256 amount, // the amount to be withdrawn
362         address user, // address of the user
363         uint256 nonce, // nonce to make the request unique
364         uint8 v, // part of user signature
365         bytes32 r, // part of user signature
366         bytes32 s, // part of user signature
367         uint256 feeWithdrawal // the transaction gas fee that will be deducted from the user balance
368     ) onlyAdmin returns (bool success) {
369         bytes32 hash = keccak256(this, token, amount, user, nonce); // creates the hash for the withdrawal request
370         if (withdrawn[hash]) throw; // checks if the withdrawal was already executed, if true, throws an error
371         withdrawn[hash] = true; // sets the withdrawal as executed
372         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw; // checks that the provided signature is valid
373         if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney; // checks that the gas fee is not higher than 0.05 ETH
374 
375 
376         //if (tokens[token][user] < amount) throw; // checks that user has enough balance
377         if (availableBalanceOf(token, user) < amount) throw; // checks that user has enough balance
378 
379         //tokens[token][user] = safeSub(tokens[token][user], amount); // subtracts the withdrawal amount from the user balance
380         subBalance(token, user, amount); // subtracts the withdrawal amount from the user balance
381 
382         //tokens[address(0)][user] = safeSub(tokens[address(0x0)][user], feeWithdrawal); // subtracts the gas fee from the user ETH balance
383         subBalance(address(0), user, feeWithdrawal); // subtracts the gas fee from the user ETH balance
384 
385         //tokens[address(0)][feeAccount] = safeAdd(tokens[address(0)][feeAccount], feeWithdrawal); // moves the gas fee to the feeAccount
386         addBalance(address(0), feeAccount, feeWithdrawal); // moves the gas fee to the feeAccount
387 
388         if (token == address(0)) { // checks if the withdrawal is in ETH or Tokens
389             if (!user.send(amount)) throw; // sends ETH
390         } else {
391             if (!Token(token).transfer(user, amount)) throw; // sends tokens
392         }
393         lastActiveTransaction[user] = block.number; // sets last user activity block
394         emit Withdraw(token, user, amount, balanceOf(token, user), feeWithdrawal); // fires the withdraw event
395     }
396 
397     function batchAdminWithdraw(
398         address[] token, // the address of the token to be withdrawn
399         uint256[] amount, // the amount to be withdrawn
400         address[] user, // address of the user
401         uint256[] nonce, // nonce to make the request unique
402         uint8[] v, // part of user signature
403         bytes32[] r, // part of user signature
404         bytes32[] s, // part of user signature
405         uint256[] feeWithdrawal // the transaction gas fee that will be deducted from the user balance
406     ) onlyAdmin 
407     {
408         for (uint i = 0; i < amount.length; i++) {
409             adminWithdraw(
410                 token[i],
411                 amount[i],
412                 user[i],
413                 nonce[i],
414                 v[i],
415                 r[i],
416                 s[i],
417                 feeWithdrawal[i]
418             );
419         }
420     }
421 
422  
423 
424     function getMakerTakerBalances(address token, address maker, address taker) view returns (uint256[4])
425     {
426         return [
427             balanceOf(token, maker),
428             balanceOf(token, taker),
429             getReserve(token, maker),
430             getReserve(token, taker)
431         ];
432     }
433 
434     
435 
436     // Structure that holds order values, used inside the trade() function
437     struct OrderPair {
438         uint256 makerAmountBuy;     // amount being bought by the maker
439         uint256 makerAmountSell;    // amount being sold by the maker
440         uint256 makerNonce;         // maker order nonce, makes the order unique
441         uint256 takerAmountBuy;     // amount being bought by the taker
442         uint256 takerAmountSell;    // amount being sold by the taker
443         uint256 takerNonce;         // taker order nonce
444         uint256 takerGasFee;        // taker gas fee, taker pays the gas
445         uint256 takerIsBuying;      // true/false taker is the buyer
446 
447         address makerTokenBuy;      // token bought by the maker
448         address makerTokenSell;     // token sold by the maker
449         address maker;              // address of the maker
450         address takerTokenBuy;      // token bought by the taker
451         address takerTokenSell;     // token sold by the taker
452         address taker;              // address of the taker
453 
454         bytes32 makerOrderHash;     // hash of the maker order
455         bytes32 takerOrderHash;     // has of the taker order
456     }
457 
458     // Structure that holds trade values, used inside the trade() function
459     struct TradeValues {
460         uint256 qty;                // amount to be trade
461         uint256 invQty;             // amount to be traded in the opposite token
462         uint256 makerAmountTaken;   // final amount taken by the maker
463         uint256 takerAmountTaken;   // final amount taken by the taker
464     }
465 
466     // Trades balances between user accounts
467     function trade(
468         uint8[2] v,
469         bytes32[4] rs,
470         uint256[8] tradeValues,
471         address[6] tradeAddresses
472     ) returns (uint filledTakerTokenAmount)
473     {
474 
475         /* tradeValues
476           [0] makerAmountBuy
477           [1] makerAmountSell
478           [2] makerNonce
479           [3] takerAmountBuy
480           [4] takerAmountSell
481           [5] takerNonce
482           [6] takerGasFee
483           [7] takerIsBuying
484 
485           tradeAddresses
486           [0] makerTokenBuy
487           [1] makerTokenSell
488           [2] maker
489           [3] takerTokenBuy
490           [4] takerTokenSell
491           [5] taker
492         */
493 
494         OrderPair memory t  = OrderPair({
495             makerAmountBuy  : tradeValues[0],
496             makerAmountSell : tradeValues[1],
497             makerNonce      : tradeValues[2],
498             takerAmountBuy  : tradeValues[3],
499             takerAmountSell : tradeValues[4],
500             takerNonce      : tradeValues[5],
501             takerGasFee     : tradeValues[6],
502             takerIsBuying   : tradeValues[7],
503 
504             makerTokenBuy   : tradeAddresses[0],
505             makerTokenSell  : tradeAddresses[1],
506             maker           : tradeAddresses[2],
507             takerTokenBuy   : tradeAddresses[3],
508             takerTokenSell  : tradeAddresses[4],
509             taker           : tradeAddresses[5],
510 
511             //                                tokenBuy           amountBuy       tokenSell          amountSell      nonce           user
512             makerOrderHash  : keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]),
513             takerOrderHash  : keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5])
514         });
515 
516         // Checks the signature for the maker order
517         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
518         {
519             emit LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
520             return 0;
521         }
522        
523        // Checks the signature for the taker order
524         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
525         {
526             emit LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
527             return 0;
528         }
529 
530 
531         // Checks that orders trade the right tokens
532         if (t.makerTokenBuy != t.takerTokenSell || t.makerTokenSell != t.takerTokenBuy)
533         {
534             emit LogError(uint8(Errors.TOKENS_DONT_MATCH), t.makerOrderHash, t.takerOrderHash);
535             return 0;
536         } // tokens don't match
537 
538 
539         // Cheks that gas fee is not higher than 10%
540         if (t.takerGasFee > 100 finney)
541         {
542             emit LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
543             return 0;
544         } // takerGasFee too high
545 
546 
547         // Checks that the prices match.
548         // Taker always pays the maker price. This part checks that the taker price is as good or better than the maker price
549         if (!(
550         (t.takerIsBuying == 0 && safeMul(t.makerAmountSell, 1 ether) / t.makerAmountBuy >= safeMul(t.takerAmountBuy, 1 ether) / t.takerAmountSell)
551         ||
552         (t.takerIsBuying > 0 && safeMul(t.makerAmountBuy, 1 ether) / t.makerAmountSell <= safeMul(t.takerAmountSell, 1 ether) / t.takerAmountBuy)
553         ))
554         {
555             emit LogError(uint8(Errors.INVLID_PRICE), t.makerOrderHash, t.takerOrderHash);
556             return 0; // prices don't match
557         }
558 
559         // Initializing trade values structure
560         TradeValues memory tv = TradeValues({
561             qty                 : 0,
562             invQty              : 0,
563             makerAmountTaken    : 0,
564             takerAmountTaken    : 0
565         });
566         
567         // maker buy, taker sell
568         if (t.takerIsBuying == 0)
569         {
570             // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
571             tv.qty = min(safeSub(t.makerAmountBuy, orderFills[t.makerOrderHash]), safeSub(t.takerAmountSell, safeMul(orderFills[t.takerOrderHash], t.takerAmountSell) / t.takerAmountBuy));
572             if (tv.qty == 0)
573             {
574                 // order was already filled
575                 emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
576                 return 0;
577             }
578 
579             // the traded quantity in opposite token terms
580             tv.invQty = safeMul(tv.qty, t.makerAmountSell) / t.makerAmountBuy;
581 
582            
583             // take fee from Token balance
584             tv.makerAmountTaken                         = safeSub(tv.qty, safeMul(tv.qty, makerFee) / (1 ether));                                       // net amount received by maker, excludes maker fee
585             //tokens[t.makerTokenBuy][feeAccount]         = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.qty, makerFee) / (1 ether));     // add maker fee to feeAccount
586             addBalance(t.makerTokenBuy, feeAccount, safeMul(tv.qty, makerFee) / (1 ether)); // add maker fee to feeAccount
587         
588 
589         
590             // take fee from Token balance
591             tv.takerAmountTaken                         = safeSub(safeSub(tv.invQty, safeMul(tv.invQty, takerFee) / (1 ether)), safeMul(tv.invQty, t.takerGasFee) / (1 ether));                             // amount taken from taker minus taker fee
592             //tokens[t.takerTokenBuy][feeAccount]         = safeAdd(tokens[t.takerTokenBuy][feeAccount], safeAdd(safeMul(tv.invQty, takerFee) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether)));   // add taker fee to feeAccount
593             addBalance(t.takerTokenBuy, feeAccount, safeAdd(safeMul(tv.invQty, takerFee) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether))); // add taker fee to feeAccount
594 
595 
596             //tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.invQty);                              // subtract sold token amount from maker balance
597             subBalance(t.makerTokenSell, t.maker, tv.invQty); // subtract sold token amount from maker balance
598 
599             //tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);                    // add bought token amount to maker
600             addBalance(t.makerTokenBuy, t.maker, tv.makerAmountTaken); // add bought token amount to maker
601 
602             //tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.qty,    makerAffiliateFee) / (1 ether)); // add affiliate commission to maker affiliate balance
603 
604 
605             //tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.qty);                                 // subtract the sold token amount from taker
606             subBalance(t.takerTokenSell, t.taker, tv.qty); // subtract the sold token amount from taker
607 
608             //tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);                    // amount received by taker, excludes taker fee
609             //tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.invQty, takerAffiliateFee) / (1 ether)); // add affiliate commission to taker affiliate balance
610             addBalance(t.takerTokenBuy, t.taker, tv.takerAmountTaken); // amount received by taker, excludes taker fee
611         
612             orderFills[t.makerOrderHash]                = safeAdd(orderFills[t.makerOrderHash], tv.qty);                                                // increase the maker order filled amount
613             orderFills[t.takerOrderHash]                = safeAdd(orderFills[t.takerOrderHash], safeMul(tv.qty, t.takerAmountBuy) / t.takerAmountSell); // increase the taker order filled amount
614             lastActiveTransaction[t.maker]              = block.number; // set last activity block number for maker
615             lastActiveTransaction[t.taker]              = block.number; // set last activity block number for taker
616 
617             // fire Trade event
618             emit Trade(
619                 t.takerTokenBuy, tv.qty,
620                 t.takerTokenSell, tv.invQty,
621                 t.maker, t.taker,
622                 makerFee, takerFee,
623                 tv.makerAmountTaken , tv.takerAmountTaken,
624                 t.makerOrderHash, t.takerOrderHash
625             );
626             return tv.qty;
627         }
628         // maker sell, taker buy
629         else
630         {
631             // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
632             tv.qty = min(safeSub(t.makerAmountSell,  safeMul(orderFills[t.makerOrderHash], t.makerAmountSell) / t.makerAmountBuy), safeSub(t.takerAmountBuy, orderFills[t.takerOrderHash]));
633             if (tv.qty == 0)
634             {
635                 // order was already filled
636                 emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
637                 return 0;
638             }            
639 
640             // the traded quantity in opposite token terms
641             tv.invQty = safeMul(tv.qty, t.makerAmountBuy) / t.makerAmountSell;
642             
643            
644             // take fee from ETH balance
645             tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));                                 // net amount received by maker, excludes maker fee
646             //tokens[t.makerTokenBuy][feeAccount]         = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, makerFee) / (1 ether));  // add maker fee to feeAccount
647             addBalance(t.makerTokenBuy, feeAccount, safeMul(tv.invQty, makerFee) / (1 ether)); // add maker fee to feeAccount
648      
649 
650             // process fees for taker
651             
652             // take fee from ETH balance
653             tv.takerAmountTaken                         = safeSub(safeSub(tv.qty, safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether));                                  // amount taken from taker minus taker fee
654             //tokens[t.takerTokenBuy][feeAccount]         = safeAdd(tokens[t.takerTokenBuy][feeAccount], safeAdd(safeMul(tv.qty, takerFee) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether)));     // add taker fee to feeAccount
655             addBalance(t.takerTokenBuy, feeAccount, safeAdd(safeMul(tv.qty, takerFee) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether))); // add taker fee to feeAccount
656 
657 
658 
659             //tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.qty); // subtract sold token amount from maker balance
660             subBalance(t.makerTokenSell, t.maker, tv.qty); // subtract sold token amount from maker balance
661 
662             //tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));   // net amount received by maker, excludes maker fee
663             //tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken); // add bought token amount to maker
664             addBalance(t.makerTokenBuy, t.maker, tv.makerAmountTaken); // add bought token amount to maker
665 
666             //tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.invQty, makerAffiliateFee) / (1 ether)); // add affiliate commission to maker affiliate balance
667 
668             //tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.invQty); // subtract the sold token amount from taker
669             subBalance(t.takerTokenSell, t.taker, tv.invQty);
670 
671             //tv.takerAmountTaken                         = safeSub(safeSub(tv.qty,    safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether)); // amount taken from taker minus taker fee
672             //tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken); // amount received by taker, excludes taker fee
673             addBalance(t.takerTokenBuy, t.taker, tv.takerAmountTaken); // amount received by taker, excludes taker fee
674 
675             //tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.qty,    takerAffiliateFee) / (1 ether)); // add affiliate commission to taker affiliate balance
676 
677             //tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, safeSub(makerFee, makerAffiliateFee)) / (1 ether)); // add maker fee excluding affiliate commission to feeAccount
678             //tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.qty,    safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether))); // add taker fee excluding affiliate commission to feeAccount
679 
680             orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.invQty); // increase the maker order filled amount
681             orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty);  // increase the taker order filled amount
682             lastActiveTransaction[t.maker]          = block.number; // set last activity block number for maker
683             lastActiveTransaction[t.taker]          = block.number; // set last activity block number for taker
684 
685             // fire Trade event
686             emit Trade(
687                 t.takerTokenBuy, tv.qty,
688                 t.takerTokenSell, tv.invQty,
689                 t.maker, t.taker,
690                 makerFee, takerFee,
691                 tv.makerAmountTaken , tv.takerAmountTaken,
692                 t.makerOrderHash, t.takerOrderHash
693             );
694             return tv.qty;
695         }
696     }
697 
698 
699     // Executes multiple trades in one transaction, saves gas fees
700     function batchOrderTrade(
701         uint8[2][] v,
702         bytes32[4][] rs,
703         uint256[8][] tradeValues,
704         address[6][] tradeAddresses
705     ) 
706     {
707         for (uint i = 0; i < tradeAddresses.length; i++) {
708             trade(
709                 v[i],
710                 rs[i],
711                 tradeValues[i],
712                 tradeAddresses[i]
713             );
714         }
715     }
716 
717     // Cancels order by setting amount filled to toal order amount
718     function cancelOrder(
719 		/*
720 		[0] orderV
721 		[1] cancelV
722 		*/
723 	    uint8[2] v,
724 
725 		/*
726 		[0] orderR
727 		[1] orderS
728 		[2] cancelR
729 		[3] cancelS
730 		*/
731 	    bytes32[4] rs,
732 
733 		/*
734 		[0] orderAmountBuy
735 		[1] orderAmountSell
736 		[2] orderNonce
737 		[3] cancelNonce
738 		[4] cancelFee
739 		*/
740 		uint256[5] cancelValues,
741 
742 		/*
743 		[0] orderTokenBuy
744 		[1] orderTokenSell
745 		[2] orderUser
746 		[3] cancelUser
747 		*/
748 		address[4] cancelAddresses
749     ) public {
750         // Order values should be valid and signed by order owner
751         bytes32 orderHash = keccak256(
752 	        this, cancelAddresses[0], cancelValues[0], cancelAddresses[1],
753 	        cancelValues[1], cancelValues[2], cancelAddresses[2]
754         );
755         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == cancelAddresses[2]);
756 
757         // Cancel action should be signed by order owner
758         bytes32 cancelHash = keccak256(this, orderHash, cancelAddresses[3], cancelValues[3]);
759         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", cancelHash), v[1], rs[2], rs[3]) == cancelAddresses[3]);
760 
761         // Order owner should be the same as cancel's initiator
762         require(cancelAddresses[2] == cancelAddresses[3]);
763 
764         // Do not allow to cancel already canceled or filled orders
765         require(orderFills[orderHash] != cancelValues[0]);
766 
767         // Cancel gas fee cannot exceed 0.05 ETh
768         if (cancelValues[4] > 50 finney) {
769             cancelValues[4] = 50 finney;
770         }
771 
772         // Take cancel fee
773         // This operation throws an error if fee amount is greater than the user balance
774         //tokens[address(0)][cancelAddresses[3]] = safeSub(tokens[address(0)][cancelAddresses[3]], cancelValues[4]);
775         subBalance(address(0), cancelAddresses[3], cancelValues[4]);
776 
777         // Cancel order by setting amount filled to total order value, i.e. making the order filled
778         orderFills[orderHash] = cancelValues[0];
779 
780         // Fire cancel order event
781         emit CancelOrder(cancelHash, orderHash, cancelAddresses[3], cancelAddresses[1], cancelValues[1], cancelValues[4]);
782     }
783 
784     // Returns the smaller of two values
785     function min(uint a, uint b) private pure returns (uint) {
786         return a < b ? a : b;
787     }
788 }