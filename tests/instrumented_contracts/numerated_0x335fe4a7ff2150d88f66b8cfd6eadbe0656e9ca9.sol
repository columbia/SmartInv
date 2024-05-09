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
151     // Allow futuresContract 
152     event AllowFuturesContract(address futuresContract, address user);
153 
154 
155     // Log event, logs errors in contract execution (used for debugging)
156     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
157     event LogUint(uint8 id, uint256 value);
158     event LogBool(uint8 id, bool value);
159     event LogAddress(uint8 id, address value);
160 
161     // Change inactivity release period event
162     event InactivityReleasePeriodChange(uint256 value);
163 
164     // Order cancelation event
165     event CancelOrder(
166         bytes32 indexed cancelHash,
167         bytes32 indexed orderHash,
168         address indexed user,
169         address tokenSell,
170         uint256 amountSell,
171         uint256 cancelFee
172     );
173 
174     // Sets the inactivity period before a user can withdraw funds manually
175     function setInactivityReleasePeriod(uint256 expiry) onlyOwner returns (bool success) {
176         if (expiry > 1000000) throw;
177         inactivityReleasePeriod = expiry;
178 
179         emit InactivityReleasePeriodChange(expiry);
180         return true;
181     }
182 
183     // Constructor function, initializes the contract and sets the core variables
184     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, uint256 inactivityReleasePeriod_) {
185         owner = msg.sender;
186         feeAccount = feeAccount_;
187         inactivityReleasePeriod = inactivityReleasePeriod_;
188         makerFee = makerFee_;
189         takerFee = takerFee_;
190     }
191 
192     // Changes the fees
193     function setFees(uint256 makerFee_, uint256 takerFee_) onlyOwner {
194         require(makerFee_ < 10 finney && takerFee_ < 10 finney); // The fees cannot be set higher then 1%
195         makerFee = makerFee_;
196         takerFee = takerFee_;
197 
198         emit FeeChange(makerFee, takerFee);
199     }
200 
201     
202 
203 
204 
205     function updateBalanceAndReserve (address token, address user, uint256 balance, uint256 reserve) private
206     {
207         uint256 character = uint256(balance);
208         character |= reserve<<128;
209 
210         balances[token][user] = character;
211     }
212 
213     function updateBalance (address token, address user, uint256 balance) private returns (bool)
214     {
215         uint256 character = uint256(balance);
216         character |= getReserve(token, user)<<128;
217 
218         balances[token][user] = character;
219         return true;
220     }
221 
222     function updateReserve (address token, address user, uint256 reserve) private
223     {
224         uint256 character = uint256(balanceOf(token, user));
225         character |= reserve<<128;
226 
227         balances[token][user] = character;
228     }
229 
230     function decodeBalanceAndReserve (address token, address user) returns (uint256[2])
231     {
232         uint256 character = balances[token][user];
233         uint256 balance = uint256(uint128(character));
234         uint256 reserve = uint256(uint128(character>>128));
235 
236         return [balance, reserve];
237     }
238 
239     function futuresContractAllowed (address futuresContract, address user) returns (bool)
240     {
241         if (fistFuturesContract == futuresContract) return true;
242         if (userAllowedFuturesContracts[user][futuresContract] == true) return true;
243         if (futuresContractsAddedBlock[futuresContract] < userFirstDeposits[user]) return true;
244 
245         return false;
246     }
247 
248     // Returns the balance of a specific token for a specific user
249     function balanceOf(address token, address user) view returns (uint256) {
250         //return tokens[token][user];
251         return decodeBalanceAndReserve(token, user)[0];
252     }
253 
254     // Returns the reserved amound of token for user
255     function getReserve(address token, address user) public view returns (uint256) { 
256         //return reserve[token][user];  
257         return decodeBalanceAndReserve(token, user)[1];
258     }
259 
260     // Sets reserved amount for specific token and user (can only be called by futures contract)
261     function setReserve(address token, address user, uint256 amount) onlyFuturesContract returns (bool success) { 
262         if (!futuresContractAllowed(msg.sender, user)) throw;
263         if (availableBalanceOf(token, user) < amount) throw; 
264         updateReserve(token, user, amount);
265         return true; 
266     }
267 
268     // Updates user balance (only can be used by futures contract)
269     function setBalance(address token, address user, uint256 amount) onlyFuturesContract returns (bool success)     {
270         if (!futuresContractAllowed(msg.sender, user)) throw;
271         updateBalance(token, user, amount);
272         return true;
273         
274     }
275 
276     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) onlyFuturesContract returns (bool)
277     {
278         if (!futuresContractAllowed(msg.sender, user)) throw;
279         updateBalanceAndReserve(token, user, safeSub(balanceOf(token, user), subBalance), safeAdd(getReserve(token, user), addReserve));
280     }
281 
282     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) onlyFuturesContract returns (bool)
283     {
284         if (!futuresContractAllowed(msg.sender, user)) throw;
285         updateBalanceAndReserve(token, user, safeAdd(balanceOf(token, user), addBalance), safeSub(getReserve(token, user), subReserve));
286     }
287 
288     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) onlyFuturesContract returns (bool)
289     {
290         if (!futuresContractAllowed(msg.sender, user)) throw;
291         updateBalanceAndReserve(token, user, safeSub(balanceOf(token, user), subBalance), safeSub(getReserve(token, user), subReserve));
292     }
293 
294     // Returns the available balance of a specific token for a specific user
295     function availableBalanceOf(address token, address user) view returns (uint256) {
296         return safeSub(balanceOf(token, user), getReserve(token, user));
297     }
298 
299     // Returns the inactivity release perios
300     function getInactivityReleasePeriod() view returns (uint256)
301     {
302         return inactivityReleasePeriod;
303     }
304 
305     // Increases the user balance
306     function addBalance(address token, address user, uint256 amount) private
307     {
308         updateBalance(token, user, safeAdd(balanceOf(token, user), amount));
309     }
310 
311     // Decreases user balance
312     function subBalance(address token, address user, uint256 amount) private
313     {
314         if (availableBalanceOf(token, user) < amount) throw; 
315         updateBalance(token, user, safeSub(balanceOf(token, user), amount));
316     }
317 
318 
319     // Deposit ETH to contract
320     function deposit() payable {
321         //tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value); // adds the deposited amount to user balance
322         addBalance(address(0), msg.sender, msg.value); // adds the deposited amount to user balance
323         if (userFirstDeposits[msg.sender] == 0) userFirstDeposits[msg.sender] = block.number;
324         lastActiveTransaction[msg.sender] = block.number; // sets the last activity block for the user
325         emit Deposit(address(0), msg.sender, msg.value, balanceOf(address(0), msg.sender)); // fires the deposit event
326     }
327 
328     // Deposit token to contract
329     function depositToken(address token, uint128 amount) {
330         //tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount); // adds the deposited amount to user balance
331         //if (amount != uint128(amount) || safeAdd(amount, balanceOf(token, msg.sender)) != uint128(amount)) throw;
332         addBalance(token, msg.sender, amount); // adds the deposited amount to user balance
333 
334         if (userFirstDeposits[msg.sender] == 0) userFirstDeposits[msg.sender] = block.number;
335         lastActiveTransaction[msg.sender] = block.number; // sets the last activity block for the user
336         if (!Token(token).transferFrom(msg.sender, this, amount)) throw; // attempts to transfer the token to this contract, if fails throws an error
337         emit Deposit(token, msg.sender, amount, balanceOf(token, msg.sender)); // fires the deposit event
338     }
339 
340     function withdraw(address token, uint256 amount) returns (bool success) {
341         //if (safeSub(block.number, lastActiveTransaction[msg.sender]) < inactivityReleasePeriod) throw; // checks if the inactivity period has passed
342         //if (tokens[token][msg.sender] < amount) throw; // checks that user has enough balance
343         if (availableBalanceOf(token, msg.sender) < amount) throw;
344 
345         //tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount); 
346         subBalance(token, msg.sender, amount); // subtracts the withdrawed amount from user balance
347 
348         if (token == address(0)) { // checks if withdrawal is a token or ETH, ETH has address 0x00000... 
349             if (!msg.sender.send(amount)) throw; // send ETH
350         } else {
351             if (!Token(token).transfer(msg.sender, amount)) throw; // Send token
352         }
353         emit Withdraw(token, msg.sender, amount, balanceOf(token, msg.sender), 0); // fires the Withdraw event
354     }
355 
356     function userAllowFuturesContract(address futuresContract)
357     {
358         if (!futuresContracts[futuresContract]) throw;
359         userAllowedFuturesContracts[msg.sender][futuresContract] = true;
360 
361         emit AllowFuturesContract(futuresContract, msg.sender);
362     }
363 
364     function allowFuturesContractForUser(address futuresContract, address user, uint8 v, bytes32 r, bytes32 s) onlyAdmin
365     {
366         if (!futuresContracts[futuresContract]) throw;
367         bytes32 hash = keccak256(this, futuresContract); 
368         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw; // checks that the provided signature is valid
369         userAllowedFuturesContracts[user][futuresContract] = true;
370 
371         emit AllowFuturesContract(futuresContract, user);
372     }
373 
374     function allowFuturesContractForUserByFuturesContract(address user, uint8 v, bytes32 r, bytes32 s) onlyFuturesContract returns (bool)
375     {
376         if (!futuresContracts[msg.sender]) return false;
377         bytes32 hash = keccak256(this, msg.sender); 
378         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) return false; // checks that the provided signature is valid
379         userAllowedFuturesContracts[user][msg.sender] = true;
380 
381         emit AllowFuturesContract(msg.sender, user);
382 
383         return true;
384     }
385 
386     
387 
388     // Withdrawal function used by the server to execute withdrawals
389     function adminWithdraw(
390         address token, // the address of the token to be withdrawn
391         uint256 amount, // the amount to be withdrawn
392         address user, // address of the user
393         uint256 nonce, // nonce to make the request unique
394         uint8 v, // part of user signature
395         bytes32 r, // part of user signature
396         bytes32 s, // part of user signature
397         uint256 feeWithdrawal // the transaction gas fee that will be deducted from the user balance
398     ) onlyAdmin returns (bool success) {
399         bytes32 hash = keccak256(this, token, amount, user, nonce); // creates the hash for the withdrawal request
400         if (withdrawn[hash]) throw; // checks if the withdrawal was already executed, if true, throws an error
401         withdrawn[hash] = true; // sets the withdrawal as executed
402         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw; // checks that the provided signature is valid
403         if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney; // checks that the gas fee is not higher than 0.05 ETH
404 
405 
406         //if (tokens[token][user] < amount) throw; // checks that user has enough balance
407         if (availableBalanceOf(token, user) < amount) throw; // checks that user has enough balance
408 
409         //tokens[token][user] = safeSub(tokens[token][user], amount); // subtracts the withdrawal amount from the user balance
410         subBalance(token, user, amount); // subtracts the withdrawal amount from the user balance
411 
412         //tokens[address(0)][user] = safeSub(tokens[address(0x0)][user], feeWithdrawal); // subtracts the gas fee from the user ETH balance
413         subBalance(address(0), user, feeWithdrawal); // subtracts the gas fee from the user ETH balance
414 
415         //tokens[address(0)][feeAccount] = safeAdd(tokens[address(0)][feeAccount], feeWithdrawal); // moves the gas fee to the feeAccount
416         addBalance(address(0), feeAccount, feeWithdrawal); // moves the gas fee to the feeAccount
417 
418         if (token == address(0)) { // checks if the withdrawal is in ETH or Tokens
419             if (!user.send(amount)) throw; // sends ETH
420         } else {
421             if (!Token(token).transfer(user, amount)) throw; // sends tokens
422         }
423         lastActiveTransaction[user] = block.number; // sets last user activity block
424         emit Withdraw(token, user, amount, balanceOf(token, user), feeWithdrawal); // fires the withdraw event
425     }
426 
427     function batchAdminWithdraw(
428         address[] token, // the address of the token to be withdrawn
429         uint256[] amount, // the amount to be withdrawn
430         address[] user, // address of the user
431         uint256[] nonce, // nonce to make the request unique
432         uint8[] v, // part of user signature
433         bytes32[] r, // part of user signature
434         bytes32[] s, // part of user signature
435         uint256[] feeWithdrawal // the transaction gas fee that will be deducted from the user balance
436     ) onlyAdmin 
437     {
438         for (uint i = 0; i < amount.length; i++) {
439             adminWithdraw(
440                 token[i],
441                 amount[i],
442                 user[i],
443                 nonce[i],
444                 v[i],
445                 r[i],
446                 s[i],
447                 feeWithdrawal[i]
448             );
449         }
450     }
451 
452  
453 
454     function getMakerTakerBalances(address token, address maker, address taker) view returns (uint256[4])
455     {
456         return [
457             balanceOf(token, maker),
458             balanceOf(token, taker),
459             getReserve(token, maker),
460             getReserve(token, taker)
461         ];
462     }
463 
464     
465 
466     // Structure that holds order values, used inside the trade() function
467     struct OrderPair {
468         uint256 makerAmountBuy;     // amount being bought by the maker
469         uint256 makerAmountSell;    // amount being sold by the maker
470         uint256 makerNonce;         // maker order nonce, makes the order unique
471         uint256 takerAmountBuy;     // amount being bought by the taker
472         uint256 takerAmountSell;    // amount being sold by the taker
473         uint256 takerNonce;         // taker order nonce
474         uint256 takerGasFee;        // taker gas fee, taker pays the gas
475         uint256 takerIsBuying;      // true/false taker is the buyer
476 
477         address makerTokenBuy;      // token bought by the maker
478         address makerTokenSell;     // token sold by the maker
479         address maker;              // address of the maker
480         address takerTokenBuy;      // token bought by the taker
481         address takerTokenSell;     // token sold by the taker
482         address taker;              // address of the taker
483 
484         bytes32 makerOrderHash;     // hash of the maker order
485         bytes32 takerOrderHash;     // has of the taker order
486     }
487 
488     // Structure that holds trade values, used inside the trade() function
489     struct TradeValues {
490         uint256 qty;                // amount to be trade
491         uint256 invQty;             // amount to be traded in the opposite token
492         uint256 makerAmountTaken;   // final amount taken by the maker
493         uint256 takerAmountTaken;   // final amount taken by the taker
494     }
495 
496     // Trades balances between user accounts
497     function trade(
498         uint8[2] v,
499         bytes32[4] rs,
500         uint256[8] tradeValues,
501         address[6] tradeAddresses
502     ) onlyAdmin returns (uint filledTakerTokenAmount)
503     {
504 
505         /* tradeValues
506           [0] makerAmountBuy
507           [1] makerAmountSell
508           [2] makerNonce
509           [3] takerAmountBuy
510           [4] takerAmountSell
511           [5] takerNonce
512           [6] takerGasFee
513           [7] takerIsBuying
514 
515           tradeAddresses
516           [0] makerTokenBuy
517           [1] makerTokenSell
518           [2] maker
519           [3] takerTokenBuy
520           [4] takerTokenSell
521           [5] taker
522         */
523 
524         OrderPair memory t  = OrderPair({
525             makerAmountBuy  : tradeValues[0],
526             makerAmountSell : tradeValues[1],
527             makerNonce      : tradeValues[2],
528             takerAmountBuy  : tradeValues[3],
529             takerAmountSell : tradeValues[4],
530             takerNonce      : tradeValues[5],
531             takerGasFee     : tradeValues[6],
532             takerIsBuying   : tradeValues[7],
533 
534             makerTokenBuy   : tradeAddresses[0],
535             makerTokenSell  : tradeAddresses[1],
536             maker           : tradeAddresses[2],
537             takerTokenBuy   : tradeAddresses[3],
538             takerTokenSell  : tradeAddresses[4],
539             taker           : tradeAddresses[5],
540 
541             //                                tokenBuy           amountBuy       tokenSell          amountSell      nonce           user
542             makerOrderHash  : keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]),
543             takerOrderHash  : keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5])
544         });
545 
546         // Checks the signature for the maker order
547         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
548         {
549             emit LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
550             return 0;
551         }
552        
553        // Checks the signature for the taker order
554         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
555         {
556             emit LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
557             return 0;
558         }
559 
560 
561         // Checks that orders trade the right tokens
562         if (t.makerTokenBuy != t.takerTokenSell || t.makerTokenSell != t.takerTokenBuy)
563         {
564             emit LogError(uint8(Errors.TOKENS_DONT_MATCH), t.makerOrderHash, t.takerOrderHash);
565             return 0;
566         } // tokens don't match
567 
568 
569         // Cheks that gas fee is not higher than 10%
570         if (t.takerGasFee > 100 finney)
571         {
572             emit LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
573             return 0;
574         } // takerGasFee too high
575 
576 
577         // Checks that the prices match.
578         // Taker always pays the maker price. This part checks that the taker price is as good or better than the maker price
579         if (!(
580         (t.takerIsBuying == 0 && safeMul(t.makerAmountSell, 1 ether) / t.makerAmountBuy >= safeMul(t.takerAmountBuy, 1 ether) / t.takerAmountSell)
581         ||
582         (t.takerIsBuying > 0 && safeMul(t.makerAmountBuy, 1 ether) / t.makerAmountSell <= safeMul(t.takerAmountSell, 1 ether) / t.takerAmountBuy)
583         ))
584         {
585             emit LogError(uint8(Errors.INVLID_PRICE), t.makerOrderHash, t.takerOrderHash);
586             return 0; // prices don't match
587         }
588 
589         // Initializing trade values structure
590         TradeValues memory tv = TradeValues({
591             qty                 : 0,
592             invQty              : 0,
593             makerAmountTaken    : 0,
594             takerAmountTaken    : 0
595         });
596         
597         // maker buy, taker sell
598         if (t.takerIsBuying == 0)
599         {
600             // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
601             tv.qty = min(safeSub(t.makerAmountBuy, orderFills[t.makerOrderHash]), safeSub(t.takerAmountSell, safeMul(orderFills[t.takerOrderHash], t.takerAmountSell) / t.takerAmountBuy));
602             if (tv.qty == 0)
603             {
604                 // order was already filled
605                 emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
606                 return 0;
607             }
608 
609             // the traded quantity in opposite token terms
610             tv.invQty = safeMul(tv.qty, t.makerAmountSell) / t.makerAmountBuy;
611 
612            
613             // take fee from Token balance
614             tv.makerAmountTaken                         = safeSub(tv.qty, safeMul(tv.qty, makerFee) / (1 ether));                                       // net amount received by maker, excludes maker fee
615             //tokens[t.makerTokenBuy][feeAccount]         = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.qty, makerFee) / (1 ether));     // add maker fee to feeAccount
616             addBalance(t.makerTokenBuy, feeAccount, safeMul(tv.qty, makerFee) / (1 ether)); // add maker fee to feeAccount
617         
618 
619         
620             // take fee from Token balance
621             tv.takerAmountTaken                         = safeSub(safeSub(tv.invQty, safeMul(tv.invQty, takerFee) / (1 ether)), safeMul(tv.invQty, t.takerGasFee) / (1 ether));                             // amount taken from taker minus taker fee
622             //tokens[t.takerTokenBuy][feeAccount]         = safeAdd(tokens[t.takerTokenBuy][feeAccount], safeAdd(safeMul(tv.invQty, takerFee) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether)));   // add taker fee to feeAccount
623             addBalance(t.takerTokenBuy, feeAccount, safeAdd(safeMul(tv.invQty, takerFee) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether))); // add taker fee to feeAccount
624 
625 
626             //tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.invQty);                              // subtract sold token amount from maker balance
627             subBalance(t.makerTokenSell, t.maker, tv.invQty); // subtract sold token amount from maker balance
628 
629             //tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);                    // add bought token amount to maker
630             addBalance(t.makerTokenBuy, t.maker, tv.makerAmountTaken); // add bought token amount to maker
631 
632             //tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.qty,    makerAffiliateFee) / (1 ether)); // add affiliate commission to maker affiliate balance
633 
634 
635             //tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.qty);                                 // subtract the sold token amount from taker
636             subBalance(t.takerTokenSell, t.taker, tv.qty); // subtract the sold token amount from taker
637 
638             //tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);                    // amount received by taker, excludes taker fee
639             //tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.invQty, takerAffiliateFee) / (1 ether)); // add affiliate commission to taker affiliate balance
640             addBalance(t.takerTokenBuy, t.taker, tv.takerAmountTaken); // amount received by taker, excludes taker fee
641         
642             orderFills[t.makerOrderHash]                = safeAdd(orderFills[t.makerOrderHash], tv.qty);                                                // increase the maker order filled amount
643             orderFills[t.takerOrderHash]                = safeAdd(orderFills[t.takerOrderHash], safeMul(tv.qty, t.takerAmountBuy) / t.takerAmountSell); // increase the taker order filled amount
644             lastActiveTransaction[t.maker]              = block.number; // set last activity block number for maker
645             lastActiveTransaction[t.taker]              = block.number; // set last activity block number for taker
646 
647             // fire Trade event
648             emit Trade(
649                 t.takerTokenBuy, tv.qty,
650                 t.takerTokenSell, tv.invQty,
651                 t.maker, t.taker,
652                 makerFee, takerFee,
653                 tv.makerAmountTaken , tv.takerAmountTaken,
654                 t.makerOrderHash, t.takerOrderHash
655             );
656             return tv.qty;
657         }
658         // maker sell, taker buy
659         else
660         {
661             // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
662             tv.qty = min(safeSub(t.makerAmountSell,  safeMul(orderFills[t.makerOrderHash], t.makerAmountSell) / t.makerAmountBuy), safeSub(t.takerAmountBuy, orderFills[t.takerOrderHash]));
663             if (tv.qty == 0)
664             {
665                 // order was already filled
666                 emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
667                 return 0;
668             }            
669 
670             // the traded quantity in opposite token terms
671             tv.invQty = safeMul(tv.qty, t.makerAmountBuy) / t.makerAmountSell;
672             
673            
674             // take fee from ETH balance
675             tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));                                 // net amount received by maker, excludes maker fee
676             //tokens[t.makerTokenBuy][feeAccount]         = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, makerFee) / (1 ether));  // add maker fee to feeAccount
677             addBalance(t.makerTokenBuy, feeAccount, safeMul(tv.invQty, makerFee) / (1 ether)); // add maker fee to feeAccount
678      
679 
680             // process fees for taker
681             
682             // take fee from ETH balance
683             tv.takerAmountTaken                         = safeSub(safeSub(tv.qty, safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether));                                  // amount taken from taker minus taker fee
684             //tokens[t.takerTokenBuy][feeAccount]         = safeAdd(tokens[t.takerTokenBuy][feeAccount], safeAdd(safeMul(tv.qty, takerFee) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether)));     // add taker fee to feeAccount
685             addBalance(t.takerTokenBuy, feeAccount, safeAdd(safeMul(tv.qty, takerFee) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether))); // add taker fee to feeAccount
686 
687 
688 
689             //tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.qty); // subtract sold token amount from maker balance
690             subBalance(t.makerTokenSell, t.maker, tv.qty); // subtract sold token amount from maker balance
691 
692             //tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));   // net amount received by maker, excludes maker fee
693             //tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken); // add bought token amount to maker
694             addBalance(t.makerTokenBuy, t.maker, tv.makerAmountTaken); // add bought token amount to maker
695 
696             //tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.invQty, makerAffiliateFee) / (1 ether)); // add affiliate commission to maker affiliate balance
697 
698             //tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.invQty); // subtract the sold token amount from taker
699             subBalance(t.takerTokenSell, t.taker, tv.invQty);
700 
701             //tv.takerAmountTaken                         = safeSub(safeSub(tv.qty,    safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether)); // amount taken from taker minus taker fee
702             //tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken); // amount received by taker, excludes taker fee
703             addBalance(t.takerTokenBuy, t.taker, tv.takerAmountTaken); // amount received by taker, excludes taker fee
704 
705             //tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.qty,    takerAffiliateFee) / (1 ether)); // add affiliate commission to taker affiliate balance
706 
707             //tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, safeSub(makerFee, makerAffiliateFee)) / (1 ether)); // add maker fee excluding affiliate commission to feeAccount
708             //tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.qty,    safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether))); // add taker fee excluding affiliate commission to feeAccount
709 
710             orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.invQty); // increase the maker order filled amount
711             orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty);  // increase the taker order filled amount
712             lastActiveTransaction[t.maker]          = block.number; // set last activity block number for maker
713             lastActiveTransaction[t.taker]          = block.number; // set last activity block number for taker
714 
715             // fire Trade event
716             emit Trade(
717                 t.takerTokenBuy, tv.qty,
718                 t.takerTokenSell, tv.invQty,
719                 t.maker, t.taker,
720                 makerFee, takerFee,
721                 tv.makerAmountTaken , tv.takerAmountTaken,
722                 t.makerOrderHash, t.takerOrderHash
723             );
724             return tv.qty;
725         }
726     }
727 
728 
729     // Executes multiple trades in one transaction, saves gas fees
730     function batchOrderTrade(
731         uint8[2][] v,
732         bytes32[4][] rs,
733         uint256[8][] tradeValues,
734         address[6][] tradeAddresses
735     ) onlyAdmin
736     {
737         for (uint i = 0; i < tradeAddresses.length; i++) {
738             trade(
739                 v[i],
740                 rs[i],
741                 tradeValues[i],
742                 tradeAddresses[i]
743             );
744         }
745     }
746 
747     // Cancels order by setting amount filled to toal order amount
748     function cancelOrder(
749 		/*
750 		[0] orderV
751 		[1] cancelV
752 		*/
753 	    uint8[2] v,
754 
755 		/*
756 		[0] orderR
757 		[1] orderS
758 		[2] cancelR
759 		[3] cancelS
760 		*/
761 	    bytes32[4] rs,
762 
763 		/*
764 		[0] orderAmountBuy
765 		[1] orderAmountSell
766 		[2] orderNonce
767 		[3] cancelNonce
768 		[4] cancelFee
769 		*/
770 		uint256[5] cancelValues,
771 
772 		/*
773 		[0] orderTokenBuy
774 		[1] orderTokenSell
775 		[2] orderUser
776 		[3] cancelUser
777 		*/
778 		address[4] cancelAddresses
779     ) onlyAdmin {
780         // Order values should be valid and signed by order owner
781         bytes32 orderHash = keccak256(
782 	        this, cancelAddresses[0], cancelValues[0], cancelAddresses[1],
783 	        cancelValues[1], cancelValues[2], cancelAddresses[2]
784         );
785         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == cancelAddresses[2]);
786 
787         // Cancel action should be signed by order owner
788         bytes32 cancelHash = keccak256(this, orderHash, cancelAddresses[3], cancelValues[3]);
789         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", cancelHash), v[1], rs[2], rs[3]) == cancelAddresses[3]);
790 
791         // Order owner should be the same as cancel's initiator
792         require(cancelAddresses[2] == cancelAddresses[3]);
793 
794         // Do not allow to cancel already canceled or filled orders
795         require(orderFills[orderHash] != cancelValues[0]);
796 
797         // Cancel gas fee cannot exceed 0.05 ETh
798         if (cancelValues[4] > 50 finney) {
799             cancelValues[4] = 50 finney;
800         }
801 
802         // Take cancel fee
803         // This operation throws an error if fee amount is greater than the user balance
804         //tokens[address(0)][cancelAddresses[3]] = safeSub(tokens[address(0)][cancelAddresses[3]], cancelValues[4]);
805         subBalance(address(0), cancelAddresses[3], cancelValues[4]);
806 
807         // Cancel order by setting amount filled to total order value, i.e. making the order filled
808         orderFills[orderHash] = cancelValues[0];
809 
810         // Fire cancel order event
811         emit CancelOrder(cancelHash, orderHash, cancelAddresses[3], cancelAddresses[1], cancelValues[1], cancelValues[4]);
812     }
813 
814     // Returns the smaller of two values
815     function min(uint a, uint b) private pure returns (uint) {
816         return a < b ? a : b;
817     }
818 }