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
47     mapping (address => bool) public futuresContracts; // mapping of connectef futures contracts
48     event SetFuturesContract(address futuresContract, bool isFuturesContract);
49 
50     // Event fired when the owner of the contract is changed
51     event SetOwner(address indexed previousOwner, address indexed newOwner);
52 
53     // Allows only the owner of the contract to execute the function
54     modifier onlyOwner {
55         assert(msg.sender == owner);
56         _;
57     }
58 
59     // Changes the owner of the contract
60     function setOwner(address newOwner) onlyOwner {
61         SetOwner(owner, newOwner);
62         owner = newOwner;
63     }
64 
65     // Owner getter function
66     function getOwner() returns (address out) {
67         return owner;
68     }
69 
70     // Adds or disables an admin account
71     function setAdmin(address admin, bool isAdmin) onlyOwner {
72         admins[admin] = isAdmin;
73     }
74 
75 
76     // Adds or disables a futuresContract address
77     function setFuturesContract(address futuresContract, bool isFuturesContract) onlyOwner {
78         futuresContracts[futuresContract] = isFuturesContract;
79         emit SetFuturesContract(futuresContract, isFuturesContract);
80     }
81 
82     // Allows for admins only to call the function
83     modifier onlyAdmin {
84         if (msg.sender != owner && !admins[msg.sender]) throw;
85         _;
86     }
87 
88     // Allows for futures contracts only to call the function
89     modifier onlyFuturesContract {
90         if (!futuresContracts[msg.sender]) throw;
91         _;
92     }
93 
94     function() external {
95         throw;
96     }
97 
98     //mapping (address => mapping (address => uint256)) public tokens; // mapping of token addresses to mapping of balances  // tokens[token][user]
99     //mapping (address => mapping (address => uint256)) public reserve; // mapping of token addresses to mapping of reserved balances  // reserve[token][user]
100     mapping (address => mapping (address => uint256)) public balances; // mapping of token addresses to mapping of balances and reserve (bitwise compressed) // balances[token][user]
101 
102     mapping (address => uint256) public lastActiveTransaction; // mapping of user addresses to last transaction block
103     mapping (bytes32 => uint256) public orderFills; // mapping of orders to filled qunatity
104     
105     address public feeAccount; // the account that receives the trading fees
106     address public EtmTokenAddress; // the address of the EtherMium token
107 
108     uint256 public inactivityReleasePeriod; // period in blocks before a user can use the withdraw() function
109     mapping (bytes32 => bool) public withdrawn; // mapping of withdraw requests, makes sure the same withdrawal is not executed twice
110     uint256 public makerFee; // maker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
111     uint256 public takerFee; // taker fee in percent expressed as a fraction of 1 ether (0.1 ETH = 10%)
112 
113     enum Errors {
114         INVLID_PRICE,           // Order prices don't match
115         INVLID_SIGNATURE,       // Signature is invalid
116         TOKENS_DONT_MATCH,      // Maker/taker tokens don't match
117         ORDER_ALREADY_FILLED,   // Order was already filled
118         GAS_TOO_HIGH            // Too high gas fee
119     }
120 
121     // Trade event fired when a trade is executed
122     event Trade(
123         address takerTokenBuy, uint256 takerAmountBuy,
124         address takerTokenSell, uint256 takerAmountSell,
125         address maker, address indexed taker,
126         uint256 makerFee, uint256 takerFee,
127         uint256 makerAmountTaken, uint256 takerAmountTaken,
128         bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash
129     );
130 
131     // Deposit event fired when a deposit took place
132     event Deposit(address indexed token, address indexed user, uint256 amount, uint256 balance);
133 
134     // Withdraw event fired when a withdrawal was executed
135     event Withdraw(address indexed token, address indexed user, uint256 amount, uint256 balance, uint256 withdrawFee);
136     event WithdrawTo(address indexed token, address indexed to, address indexed from, uint256 amount, uint256 balance, uint256 withdrawFee);
137 
138     // Fee change event
139     event FeeChange(uint256 indexed makerFee, uint256 indexed takerFee);
140 
141     // Log event, logs errors in contract execution (used for debugging)
142     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
143     event LogUint(uint8 id, uint256 value);
144     event LogBool(uint8 id, bool value);
145     event LogAddress(uint8 id, address value);
146 
147     // Change inactivity release period event
148     event InactivityReleasePeriodChange(uint256 value);
149 
150     // Order cancelation event
151     event CancelOrder(
152         bytes32 indexed cancelHash,
153         bytes32 indexed orderHash,
154         address indexed user,
155         address tokenSell,
156         uint256 amountSell,
157         uint256 cancelFee
158     );
159 
160     // Sets the inactivity period before a user can withdraw funds manually
161     function setInactivityReleasePeriod(uint256 expiry) onlyOwner returns (bool success) {
162         if (expiry > 1000000) throw;
163         inactivityReleasePeriod = expiry;
164 
165         emit InactivityReleasePeriodChange(expiry);
166         return true;
167     }
168 
169     // Constructor function, initializes the contract and sets the core variables
170     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_) {
171         owner = msg.sender;
172         feeAccount = feeAccount_;
173         inactivityReleasePeriod = 100000;
174         makerFee = makerFee_;
175         takerFee = takerFee_;
176     }
177 
178     // Changes the fees
179     function setFees(uint256 makerFee_, uint256 takerFee_) onlyOwner {
180         require(makerFee_ < 10 finney && takerFee_ < 10 finney); // The fees cannot be set higher then 1%
181         makerFee = makerFee_;
182         takerFee = takerFee_;
183 
184         emit FeeChange(makerFee, takerFee);
185     }
186 
187     
188 
189     // Deposit token to contract
190     function depositToken(address token, uint128 amount) {
191         //tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount); // adds the deposited amount to user balance
192         //if (amount != uint128(amount) || safeAdd(amount, balanceOf(token, msg.sender)) != uint128(amount)) throw;
193         addBalance(token, msg.sender, amount); // adds the deposited amount to user balance
194 
195         lastActiveTransaction[msg.sender] = block.number; // sets the last activity block for the user
196         if (!Token(token).transferFrom(msg.sender, this, amount)) throw; // attempts to transfer the token to this contract, if fails throws an error
197         emit Deposit(token, msg.sender, amount, balanceOf(token, msg.sender)); // fires the deposit event
198     }
199 
200     function updateBalanceAndReserve (address token, address user, uint256 balance, uint256 reserve) private
201     {
202         uint256 character = uint256(balance);
203         character |= reserve<<128;
204 
205         balances[token][user] = character;
206     }
207 
208     function updateBalance (address token, address user, uint256 balance) private returns (bool)
209     {
210         uint256 character = uint256(balance);
211         character |= getReserve(token, user)<<128;
212 
213         balances[token][user] = character;
214         return true;
215     }
216 
217     function updateReserve (address token, address user, uint256 reserve) private
218     {
219         uint256 character = uint256(balanceOf(token, user));
220         character |= reserve<<128;
221 
222         balances[token][user] = character;
223     }
224 
225     function decodeBalanceAndReserve (address token, address user) returns (uint256[2])
226     {
227         uint256 character = balances[token][user];
228         uint256 balance = uint256(uint128(character));
229         uint256 reserve = uint256(uint128(character>>128));
230 
231         return [balance, reserve];
232     }
233 
234     // Returns the balance of a specific token for a specific user
235     function balanceOf(address token, address user) view returns (uint256) {
236         //return tokens[token][user];
237         return decodeBalanceAndReserve(token, user)[0];
238     }
239 
240     // Returns the reserved amound of token for user
241     function getReserve(address token, address user) public view returns (uint256) { 
242         //return reserve[token][user];  
243         return decodeBalanceAndReserve(token, user)[1];
244     }
245 
246     // Sets reserved amount for specific token and user (can only be called by futures contract)
247     function setReserve(address token, address user, uint256 amount) onlyFuturesContract returns (bool success) { 
248         //reserve[token][user] = amount; 
249         if (availableBalanceOf(token, user) < amount) throw; 
250         updateReserve(token, user, amount);
251         return true; 
252     }
253 
254     // Updates user balance (only can be used by futures contract)
255     function setBalance(address token, address user, uint256 amount) onlyFuturesContract returns (bool success)     {
256         //tokens[token][user] = amount; 
257         updateBalance(token, user, amount);
258         return true;
259         
260     }
261 
262     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) onlyFuturesContract returns (bool)
263     {
264         updateBalanceAndReserve(token, user, safeSub(balanceOf(token, user), subBalance), safeAdd(getReserve(token, user), addReserve));
265     }
266 
267     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) onlyFuturesContract returns (bool)
268     {
269         updateBalanceAndReserve(token, user, safeAdd(balanceOf(token, user), addBalance), safeSub(getReserve(token, user), subReserve));
270     }
271 
272     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) onlyFuturesContract returns (bool)
273     {
274         // LogUint(21, getReserve(token, user));
275         // LogUint(22, subReserve);
276         // return true;
277         updateBalanceAndReserve(token, user, safeSub(balanceOf(token, user), subBalance), safeSub(getReserve(token, user), subReserve));
278     }
279 
280     // Returns the available balance of a specific token for a specific user
281     function availableBalanceOf(address token, address user) view returns (uint256) {
282         return safeSub(balanceOf(token, user), getReserve(token, user));
283     }
284 
285     // Returns the inactivity release perios
286     function getInactivityReleasePeriod() view returns (uint256)
287     {
288         return inactivityReleasePeriod;
289     }
290 
291     // Increases the user balance
292     function addBalance(address token, address user, uint256 amount)
293     {
294         updateBalance(token, user, safeAdd(balanceOf(token, user), amount));
295     }
296 
297     // Decreases user balance
298     function subBalance(address token, address user, uint256 amount)
299     {
300         if (availableBalanceOf(token, user) < amount) throw; 
301         updateBalance(token, user, safeSub(balanceOf(token, user), amount));
302     }
303 
304 
305     // Deposit ETH to contract
306     function deposit() payable {
307         //tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value); // adds the deposited amount to user balance
308         addBalance(address(0), msg.sender, msg.value); // adds the deposited amount to user balance
309 
310         lastActiveTransaction[msg.sender] = block.number; // sets the last activity block for the user
311         emit Deposit(address(0), msg.sender, msg.value, balanceOf(address(0), msg.sender)); // fires the deposit event
312     }
313 
314     // Deposit token to a destination user balance
315     function depositTokenFor(address token, uint128 amount, address destinationUser)  returns (bool success) {
316         //tokens[token][destinationUser] = safeAdd(tokens[token][destinationUser], amount); // adds the deposited amount to user balance
317         addBalance(token, destinationUser, amount); // adds the deposited amount to user balance
318 
319         lastActiveTransaction[destinationUser] = block.number; // sets the last activity block for the user
320         if (!Token(token).transferFrom(msg.sender, this, amount)) throw; // attempts to transfer the token to this contract, if fails throws an error
321         emit Deposit(token, destinationUser, amount, balanceOf(token, destinationUser)); // fires the deposit event
322         return true;
323     }
324 
325     // Deposit ETH to a destination user balance
326     function depositFor(address destinationUser) payable  returns (bool success) {
327         //okens[address(0)][destinationUser] = safeAdd(tokens[address(0)][destinationUser], msg.value); // adds the deposited amount to user balance
328         addBalance(address(0), destinationUser, msg.value); // adds the deposited amount to user balance
329 
330         lastActiveTransaction[destinationUser] = block.number; // sets the last activity block for the user
331         emit Deposit(address(0), destinationUser, msg.value, balanceOf(address(0), destinationUser)); // fires the deposit event
332         return true;
333     }
334 
335     function withdraw(address token, uint256 amount) returns (bool success) {
336         //if (safeSub(block.number, lastActiveTransaction[msg.sender]) < inactivityReleasePeriod) throw; // checks if the inactivity period has passed
337         //if (tokens[token][msg.sender] < amount) throw; // checks that user has enough balance
338         if (availableBalanceOf(token, msg.sender) < amount) throw;
339 
340         //tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount); 
341         subBalance(token, msg.sender, amount); // subtracts the withdrawed amount from user balance
342 
343         if (token == address(0)) { // checks if withdrawal is a token or ETH, ETH has address 0x00000... 
344             if (!msg.sender.send(amount)) throw; // send ETH
345         } else {
346             if (!Token(token).transfer(msg.sender, amount)) throw; // Send token
347         }
348         emit Withdraw(token, msg.sender, amount, balanceOf(token, msg.sender), 0); // fires the Withdraw event
349     }
350 
351     // Withdrawal function used by the server to execute withdrawals
352     function adminWithdraw(
353         address token, // the address of the token to be withdrawn
354         uint256 amount, // the amount to be withdrawn
355         address user, // address of the user
356         uint256 nonce, // nonce to make the request unique
357         uint8 v, // part of user signature
358         bytes32 r, // part of user signature
359         bytes32 s, // part of user signature
360         uint256 feeWithdrawal // the transaction gas fee that will be deducted from the user balance
361     ) onlyAdmin returns (bool success) {
362         bytes32 hash = keccak256(this, token, amount, user, nonce); // creates the hash for the withdrawal request
363         if (withdrawn[hash]) throw; // checks if the withdrawal was already executed, if true, throws an error
364         withdrawn[hash] = true; // sets the withdrawal as executed
365         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw; // checks that the provided signature is valid
366         if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney; // checks that the gas fee is not higher than 0.05 ETH
367 
368 
369         //if (tokens[token][user] < amount) throw; // checks that user has enough balance
370         if (availableBalanceOf(token, user) < amount) throw; // checks that user has enough balance
371 
372         //tokens[token][user] = safeSub(tokens[token][user], amount); // subtracts the withdrawal amount from the user balance
373         subBalance(token, user, amount); // subtracts the withdrawal amount from the user balance
374 
375         //tokens[address(0)][user] = safeSub(tokens[address(0x0)][user], feeWithdrawal); // subtracts the gas fee from the user ETH balance
376         subBalance(address(0), user, feeWithdrawal); // subtracts the gas fee from the user ETH balance
377 
378         //tokens[address(0)][feeAccount] = safeAdd(tokens[address(0)][feeAccount], feeWithdrawal); // moves the gas fee to the feeAccount
379         addBalance(address(0), feeAccount, feeWithdrawal); // moves the gas fee to the feeAccount
380 
381         if (token == address(0)) { // checks if the withdrawal is in ETH or Tokens
382             if (!user.send(amount)) throw; // sends ETH
383         } else {
384             if (!Token(token).transfer(user, amount)) throw; // sends tokens
385         }
386         lastActiveTransaction[user] = block.number; // sets last user activity block
387         emit Withdraw(token, user, amount, balanceOf(token, user), feeWithdrawal); // fires the withdraw event
388     }
389 
390     function batchAdminWithdraw(
391         address[] token, // the address of the token to be withdrawn
392         uint256[] amount, // the amount to be withdrawn
393         address[] user, // address of the user
394         uint256[] nonce, // nonce to make the request unique
395         uint8[] v, // part of user signature
396         bytes32[] r, // part of user signature
397         bytes32[] s, // part of user signature
398         uint256[] feeWithdrawal // the transaction gas fee that will be deducted from the user balance
399     ) onlyAdmin 
400     {
401         for (uint i = 0; i < amount.length; i++) {
402             adminWithdraw(
403                 token[i],
404                 amount[i],
405                 user[i],
406                 nonce[i],
407                 v[i],
408                 r[i],
409                 s[i],
410                 feeWithdrawal[i]
411             );
412         }
413     }
414 
415  
416 
417     function getMakerTakerBalances(address token, address maker, address taker) view returns (uint256[4])
418     {
419         return [
420             balanceOf(token, maker),
421             balanceOf(token, taker),
422             getReserve(token, maker),
423             getReserve(token, taker)
424         ];
425     }
426 
427     
428 
429     // Structure that holds order values, used inside the trade() function
430     struct OrderPair {
431         uint256 makerAmountBuy;     // amount being bought by the maker
432         uint256 makerAmountSell;    // amount being sold by the maker
433         uint256 makerNonce;         // maker order nonce, makes the order unique
434         uint256 takerAmountBuy;     // amount being bought by the taker
435         uint256 takerAmountSell;    // amount being sold by the taker
436         uint256 takerNonce;         // taker order nonce
437         uint256 takerGasFee;        // taker gas fee, taker pays the gas
438         uint256 takerIsBuying;      // true/false taker is the buyer
439 
440         address makerTokenBuy;      // token bought by the maker
441         address makerTokenSell;     // token sold by the maker
442         address maker;              // address of the maker
443         address takerTokenBuy;      // token bought by the taker
444         address takerTokenSell;     // token sold by the taker
445         address taker;              // address of the taker
446 
447         bytes32 makerOrderHash;     // hash of the maker order
448         bytes32 takerOrderHash;     // has of the taker order
449     }
450 
451     // Structure that holds trade values, used inside the trade() function
452     struct TradeValues {
453         uint256 qty;                // amount to be trade
454         uint256 invQty;             // amount to be traded in the opposite token
455         uint256 makerAmountTaken;   // final amount taken by the maker
456         uint256 takerAmountTaken;   // final amount taken by the taker
457     }
458 
459     // Trades balances between user accounts
460     function trade(
461         uint8[2] v,
462         bytes32[4] rs,
463         uint256[8] tradeValues,
464         address[6] tradeAddresses
465     ) returns (uint filledTakerTokenAmount)
466     {
467 
468         /* tradeValues
469           [0] makerAmountBuy
470           [1] makerAmountSell
471           [2] makerNonce
472           [3] takerAmountBuy
473           [4] takerAmountSell
474           [5] takerNonce
475           [6] takerGasFee
476           [7] takerIsBuying
477 
478           tradeAddresses
479           [0] makerTokenBuy
480           [1] makerTokenSell
481           [2] maker
482           [3] takerTokenBuy
483           [4] takerTokenSell
484           [5] taker
485         */
486 
487         OrderPair memory t  = OrderPair({
488             makerAmountBuy  : tradeValues[0],
489             makerAmountSell : tradeValues[1],
490             makerNonce      : tradeValues[2],
491             takerAmountBuy  : tradeValues[3],
492             takerAmountSell : tradeValues[4],
493             takerNonce      : tradeValues[5],
494             takerGasFee     : tradeValues[6],
495             takerIsBuying   : tradeValues[7],
496 
497             makerTokenBuy   : tradeAddresses[0],
498             makerTokenSell  : tradeAddresses[1],
499             maker           : tradeAddresses[2],
500             takerTokenBuy   : tradeAddresses[3],
501             takerTokenSell  : tradeAddresses[4],
502             taker           : tradeAddresses[5],
503 
504             //                                tokenBuy           amountBuy       tokenSell          amountSell      nonce           user
505             makerOrderHash  : keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]),
506             takerOrderHash  : keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5])
507         });
508 
509         // Checks the signature for the maker order
510         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
511         {
512             emit LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
513             return 0;
514         }
515        
516        // Checks the signature for the taker order
517         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
518         {
519             emit LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
520             return 0;
521         }
522 
523 
524         // Checks that orders trade the right tokens
525         if (t.makerTokenBuy != t.takerTokenSell || t.makerTokenSell != t.takerTokenBuy)
526         {
527             emit LogError(uint8(Errors.TOKENS_DONT_MATCH), t.makerOrderHash, t.takerOrderHash);
528             return 0;
529         } // tokens don't match
530 
531 
532         // Cheks that gas fee is not higher than 10%
533         if (t.takerGasFee > 100 finney)
534         {
535             emit LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
536             return 0;
537         } // takerGasFee too high
538 
539 
540         // Checks that the prices match.
541         // Taker always pays the maker price. This part checks that the taker price is as good or better than the maker price
542         if (!(
543         (t.takerIsBuying == 0 && safeMul(t.makerAmountSell, 1 ether) / t.makerAmountBuy >= safeMul(t.takerAmountBuy, 1 ether) / t.takerAmountSell)
544         ||
545         (t.takerIsBuying > 0 && safeMul(t.makerAmountBuy, 1 ether) / t.makerAmountSell <= safeMul(t.takerAmountSell, 1 ether) / t.takerAmountBuy)
546         ))
547         {
548             emit LogError(uint8(Errors.INVLID_PRICE), t.makerOrderHash, t.takerOrderHash);
549             return 0; // prices don't match
550         }
551 
552         // Initializing trade values structure
553         TradeValues memory tv = TradeValues({
554             qty                 : 0,
555             invQty              : 0,
556             makerAmountTaken    : 0,
557             takerAmountTaken    : 0
558         });
559         
560         // maker buy, taker sell
561         if (t.takerIsBuying == 0)
562         {
563             // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
564             tv.qty = min(safeSub(t.makerAmountBuy, orderFills[t.makerOrderHash]), safeSub(t.takerAmountSell, safeMul(orderFills[t.takerOrderHash], t.takerAmountSell) / t.takerAmountBuy));
565             if (tv.qty == 0)
566             {
567                 // order was already filled
568                 emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
569                 return 0;
570             }
571 
572             // the traded quantity in opposite token terms
573             tv.invQty = safeMul(tv.qty, t.makerAmountSell) / t.makerAmountBuy;
574 
575            
576             // take fee from Token balance
577             tv.makerAmountTaken                         = safeSub(tv.qty, safeMul(tv.qty, makerFee) / (1 ether));                                       // net amount received by maker, excludes maker fee
578             //tokens[t.makerTokenBuy][feeAccount]         = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.qty, makerFee) / (1 ether));     // add maker fee to feeAccount
579             addBalance(t.makerTokenBuy, feeAccount, safeMul(tv.qty, makerFee) / (1 ether)); // add maker fee to feeAccount
580         
581 
582         
583             // take fee from Token balance
584             tv.takerAmountTaken                         = safeSub(safeSub(tv.invQty, safeMul(tv.invQty, takerFee) / (1 ether)), safeMul(tv.invQty, t.takerGasFee) / (1 ether));                             // amount taken from taker minus taker fee
585             //tokens[t.takerTokenBuy][feeAccount]         = safeAdd(tokens[t.takerTokenBuy][feeAccount], safeAdd(safeMul(tv.invQty, takerFee) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether)));   // add taker fee to feeAccount
586             addBalance(t.takerTokenBuy, feeAccount, safeAdd(safeMul(tv.invQty, takerFee) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether))); // add taker fee to feeAccount
587 
588 
589             //tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.invQty);                              // subtract sold token amount from maker balance
590             subBalance(t.makerTokenSell, t.maker, tv.invQty); // subtract sold token amount from maker balance
591 
592             //tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);                    // add bought token amount to maker
593             addBalance(t.makerTokenBuy, t.maker, tv.makerAmountTaken); // add bought token amount to maker
594 
595             //tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.qty,    makerAffiliateFee) / (1 ether)); // add affiliate commission to maker affiliate balance
596 
597 
598             //tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.qty);                                 // subtract the sold token amount from taker
599             subBalance(t.takerTokenSell, t.taker, tv.qty); // subtract the sold token amount from taker
600 
601             //tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);                    // amount received by taker, excludes taker fee
602             //tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.invQty, takerAffiliateFee) / (1 ether)); // add affiliate commission to taker affiliate balance
603             addBalance(t.takerTokenBuy, t.taker, tv.takerAmountTaken); // amount received by taker, excludes taker fee
604         
605             orderFills[t.makerOrderHash]                = safeAdd(orderFills[t.makerOrderHash], tv.qty);                                                // increase the maker order filled amount
606             orderFills[t.takerOrderHash]                = safeAdd(orderFills[t.takerOrderHash], safeMul(tv.qty, t.takerAmountBuy) / t.takerAmountSell); // increase the taker order filled amount
607             lastActiveTransaction[t.maker]              = block.number; // set last activity block number for maker
608             lastActiveTransaction[t.taker]              = block.number; // set last activity block number for taker
609 
610             // fire Trade event
611             emit Trade(
612                 t.takerTokenBuy, tv.qty,
613                 t.takerTokenSell, tv.invQty,
614                 t.maker, t.taker,
615                 makerFee, takerFee,
616                 tv.makerAmountTaken , tv.takerAmountTaken,
617                 t.makerOrderHash, t.takerOrderHash
618             );
619             return tv.qty;
620         }
621         // maker sell, taker buy
622         else
623         {
624             // traded quantity is the smallest quantity between the maker and the taker, takes into account amounts already filled on the orders
625             tv.qty = min(safeSub(t.makerAmountSell,  safeMul(orderFills[t.makerOrderHash], t.makerAmountSell) / t.makerAmountBuy), safeSub(t.takerAmountBuy, orderFills[t.takerOrderHash]));
626             if (tv.qty == 0)
627             {
628                 // order was already filled
629                 emit LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
630                 return 0;
631             }            
632 
633             // the traded quantity in opposite token terms
634             tv.invQty = safeMul(tv.qty, t.makerAmountBuy) / t.makerAmountSell;
635             
636            
637             // take fee from ETH balance
638             tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));                                 // net amount received by maker, excludes maker fee
639             //tokens[t.makerTokenBuy][feeAccount]         = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, makerFee) / (1 ether));  // add maker fee to feeAccount
640             addBalance(t.makerTokenBuy, feeAccount, safeMul(tv.invQty, makerFee) / (1 ether)); // add maker fee to feeAccount
641      
642 
643             // process fees for taker
644             
645             // take fee from ETH balance
646             tv.takerAmountTaken                         = safeSub(safeSub(tv.qty, safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether));                                  // amount taken from taker minus taker fee
647             //tokens[t.takerTokenBuy][feeAccount]         = safeAdd(tokens[t.takerTokenBuy][feeAccount], safeAdd(safeMul(tv.qty, takerFee) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether)));     // add taker fee to feeAccount
648             addBalance(t.takerTokenBuy, feeAccount, safeAdd(safeMul(tv.qty, takerFee) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether))); // add taker fee to feeAccount
649 
650 
651 
652             //tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.qty); // subtract sold token amount from maker balance
653             subBalance(t.makerTokenSell, t.maker, tv.qty); // subtract sold token amount from maker balance
654 
655             //tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));   // net amount received by maker, excludes maker fee
656             //tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken); // add bought token amount to maker
657             addBalance(t.makerTokenBuy, t.maker, tv.makerAmountTaken); // add bought token amount to maker
658 
659             //tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.invQty, makerAffiliateFee) / (1 ether)); // add affiliate commission to maker affiliate balance
660 
661             //tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.invQty); // subtract the sold token amount from taker
662             subBalance(t.takerTokenSell, t.taker, tv.invQty);
663 
664             //tv.takerAmountTaken                         = safeSub(safeSub(tv.qty,    safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether)); // amount taken from taker minus taker fee
665             //tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken); // amount received by taker, excludes taker fee
666             addBalance(t.takerTokenBuy, t.taker, tv.takerAmountTaken); // amount received by taker, excludes taker fee
667 
668             //tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.qty,    takerAffiliateFee) / (1 ether)); // add affiliate commission to taker affiliate balance
669 
670             //tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, safeSub(makerFee, makerAffiliateFee)) / (1 ether)); // add maker fee excluding affiliate commission to feeAccount
671             //tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.qty,    safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether))); // add taker fee excluding affiliate commission to feeAccount
672 
673             orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.invQty); // increase the maker order filled amount
674             orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty);  // increase the taker order filled amount
675             lastActiveTransaction[t.maker]          = block.number; // set last activity block number for maker
676             lastActiveTransaction[t.taker]          = block.number; // set last activity block number for taker
677 
678             // fire Trade event
679             emit Trade(
680                 t.takerTokenBuy, tv.qty,
681                 t.takerTokenSell, tv.invQty,
682                 t.maker, t.taker,
683                 makerFee, takerFee,
684                 tv.makerAmountTaken , tv.takerAmountTaken,
685                 t.makerOrderHash, t.takerOrderHash
686             );
687             return tv.qty;
688         }
689     }
690 
691 
692     // Executes multiple trades in one transaction, saves gas fees
693     function batchOrderTrade(
694         uint8[2][] v,
695         bytes32[4][] rs,
696         uint256[8][] tradeValues,
697         address[6][] tradeAddresses
698     ) 
699     {
700         for (uint i = 0; i < tradeAddresses.length; i++) {
701             trade(
702                 v[i],
703                 rs[i],
704                 tradeValues[i],
705                 tradeAddresses[i]
706             );
707         }
708     }
709 
710     // Cancels order by setting amount filled to toal order amount
711     function cancelOrder(
712 		/*
713 		[0] orderV
714 		[1] cancelV
715 		*/
716 	    uint8[2] v,
717 
718 		/*
719 		[0] orderR
720 		[1] orderS
721 		[2] cancelR
722 		[3] cancelS
723 		*/
724 	    bytes32[4] rs,
725 
726 		/*
727 		[0] orderAmountBuy
728 		[1] orderAmountSell
729 		[2] orderNonce
730 		[3] cancelNonce
731 		[4] cancelFee
732 		*/
733 		uint256[5] cancelValues,
734 
735 		/*
736 		[0] orderTokenBuy
737 		[1] orderTokenSell
738 		[2] orderUser
739 		[3] cancelUser
740 		*/
741 		address[4] cancelAddresses
742     ) public {
743         // Order values should be valid and signed by order owner
744         bytes32 orderHash = keccak256(
745 	        this, cancelAddresses[0], cancelValues[0], cancelAddresses[1],
746 	        cancelValues[1], cancelValues[2], cancelAddresses[2]
747         );
748         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == cancelAddresses[2]);
749 
750         // Cancel action should be signed by order owner
751         bytes32 cancelHash = keccak256(this, orderHash, cancelAddresses[3], cancelValues[3]);
752         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", cancelHash), v[1], rs[2], rs[3]) == cancelAddresses[3]);
753 
754         // Order owner should be the same as cancel's initiator
755         require(cancelAddresses[2] == cancelAddresses[3]);
756 
757         // Do not allow to cancel already canceled or filled orders
758         require(orderFills[orderHash] != cancelValues[0]);
759 
760         // Cancel gas fee cannot exceed 0.05 ETh
761         if (cancelValues[4] > 50 finney) {
762             cancelValues[4] = 50 finney;
763         }
764 
765         // Take cancel fee
766         // This operation throws an error if fee amount is greater than the user balance
767         //tokens[address(0)][cancelAddresses[3]] = safeSub(tokens[address(0)][cancelAddresses[3]], cancelValues[4]);
768         subBalance(address(0), cancelAddresses[3], cancelValues[4]);
769 
770         // Cancel order by setting amount filled to total order value, i.e. making the order filled
771         orderFills[orderHash] = cancelValues[0];
772 
773         // Fire cancel order event
774         emit CancelOrder(cancelHash, orderHash, cancelAddresses[3], cancelAddresses[1], cancelValues[1], cancelValues[4]);
775     }
776 
777     // Returns the smaller of two values
778     function min(uint a, uint b) private pure returns (uint) {
779         return a < b ? a : b;
780     }
781 }