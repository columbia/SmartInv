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
19 /* Interface for pTokens contract */
20 contract pToken {
21     function redeem(uint256 _value, string memory _btcAddress) public returns (bool _success);
22 }
23 
24 // The DMEX base Contract
25 contract DMEX_Base {
26     function assert(bool assertion) {
27         if (!assertion) throw;
28     }
29 
30     // Safe Multiply Function - prevents integer overflow 
31     function safeMul(uint a, uint b) returns (uint) {
32         uint c = a * b;
33         assert(a == 0 || c / a == b);
34         return c;
35     }
36 
37     // Safe Subtraction Function - prevents integer overflow 
38     function safeSub(uint a, uint b) returns (uint) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     // Safe Addition Function - prevents integer overflow 
44     function safeAdd(uint a, uint b) returns (uint) {
45         uint c = a + b;
46         assert(c>=a && c>=b);
47         return c;
48     }
49 
50     address public owner; // holds the address of the contract owner
51     mapping (address => bool) public admins; // mapping of admin addresses
52     mapping (address => bool) public futuresContracts; // mapping of connected futures contracts
53     event SetFuturesContract(address futuresContract, bool isFuturesContract);
54 
55     // Event fired when the owner of the contract is changed
56     event SetOwner(address indexed previousOwner, address indexed newOwner);
57 
58     // Allows only the owner of the contract to execute the function
59     modifier onlyOwner {
60         assert(msg.sender == owner);
61         _;
62     }
63 
64     // Changes the owner of the contract
65     function setOwner(address newOwner) onlyOwner {
66         SetOwner(owner, newOwner);
67         owner = newOwner;
68     }
69 
70     // Owner getter function
71     function getOwner() returns (address out) {
72         return owner;
73     }
74 
75     // Adds or disables an admin account
76     function setAdmin(address admin, bool isAdmin) onlyOwner {
77         admins[admin] = isAdmin;
78     }
79 
80 
81     // Adds or disables a futuresContract address
82     function setFuturesContract(address futuresContract, bool isFuturesContract) onlyOwner {
83         if (fistFuturesContract == address(0))
84         {
85             fistFuturesContract = futuresContract;            
86         }
87         else
88         {
89             revert();
90         }
91 
92         futuresContracts[futuresContract] = isFuturesContract;
93 
94         emit SetFuturesContract(futuresContract, isFuturesContract);
95     }
96 
97     // Allows for admins only to call the function
98     modifier onlyAdmin {
99         if (msg.sender != owner && !admins[msg.sender]) throw;
100         _;
101     }
102 
103     // Allows for futures contracts only to call the function
104     modifier onlyFuturesContract {
105         if (!futuresContracts[msg.sender]) throw;
106         _;
107     }
108 
109     function() external {
110         throw;
111     }
112 
113     mapping (address => mapping (address => uint256)) public balances; // mapping of token addresses to mapping of balances and reserve (bitwise compressed) // balances[token][user]
114 
115     mapping (address => uint256) public userFirstDeposits; // mapping of user addresses and block number of first deposit
116 
117     address public gasFeeAccount; // the account that receives the trading fees
118     address public fistFuturesContract; // 0x if there are no futures contracts set yet
119 
120     uint256 public inactivityReleasePeriod; // period in blocks before a user can use the withdraw() function
121     mapping (bytes32 => bool) public withdrawn; // mapping of withdraw requests, makes sure the same withdrawal is not executed twice
122 
123     bool public destroyed = false; // contract is destoryed
124     uint256 public destroyDelay = 1000000; // number of blocks after destroy contract still active (aprox 6 monthds)
125     uint256 public destroyBlock;
126 
127     // Deposit event fired when a deposit takes place
128     event Deposit(address indexed token, address indexed user, uint256 amount, uint256 balance);
129 
130     // Withdraw event fired when a withdrawal id executed
131     event Withdraw(address indexed token, address indexed user, uint256 amount, uint256 balance, uint256 withdrawFee);
132     
133     // pTokenRedeemEvent event fired when a pToken withdrawal is executed
134     event pTokenRedeemEvent(address indexed token, address indexed user, uint256 amount, string destinationAddress);
135 
136     // Allow futuresContract 
137     event AllowFuturesContract(address futuresContract, address user);
138 
139     // Change inactivity release period event
140     event InactivityReleasePeriodChange(uint256 value);
141 
142     // Sets the inactivity period before a user can withdraw funds manually
143     function setInactivityReleasePeriod(uint256 expiry) onlyOwner returns (bool success) {
144         if (expiry > 1000000) throw;
145         inactivityReleasePeriod = expiry;
146 
147         emit InactivityReleasePeriodChange(expiry);
148         return true;
149     }
150 
151     // Constructor function, initializes the contract and sets the core variables
152     function DMEX_Base(address feeAccount_, uint256 inactivityReleasePeriod_) {
153         owner = msg.sender;
154         gasFeeAccount = feeAccount_;
155         inactivityReleasePeriod = inactivityReleasePeriod_;
156     }
157 
158     // Sets the inactivity period before a user can withdraw funds manually
159     function destroyContract() onlyOwner returns (bool success) {
160         if (destroyed) throw;
161         destroyBlock = block.number;
162 
163         return true;
164     }
165 
166     function updateBalanceAndReserve (address token, address user, uint256 balance, uint256 reserve) private
167     {
168         uint256 character = uint256(balance);
169         character |= reserve<<128;
170 
171         balances[token][user] = character;
172     }
173 
174     function updateBalance (address token, address user, uint256 balance) private returns (bool)
175     {
176         uint256 character = uint256(balance);
177         character |= getReserve(token, user)<<128;
178 
179         balances[token][user] = character;
180         return true;
181     }
182 
183     function updateReserve (address token, address user, uint256 reserve) private
184     {
185         uint256 character = uint256(balanceOf(token, user));
186         character |= reserve<<128;
187 
188         balances[token][user] = character;
189     }
190 
191     function decodeBalanceAndReserve (address token, address user) returns (uint256[2])
192     {
193         uint256 character = balances[token][user];
194         uint256 balance = uint256(uint128(character));
195         uint256 reserve = uint256(uint128(character>>128));
196 
197         return [balance, reserve];
198     }
199 
200 
201     // Returns the balance of a specific token for a specific user
202     function balanceOf(address token, address user) view returns (uint256) {
203         //return tokens[token][user];
204         return decodeBalanceAndReserve(token, user)[0];
205     }
206 
207     // Returns the reserved amound of token for user
208     function getReserve(address token, address user) public view returns (uint256) { 
209         //return reserve[token][user];  
210         return decodeBalanceAndReserve(token, user)[1];
211     }
212 
213     // Sets reserved amount for specific token and user (can only be called by futures contract)
214     function setReserve(address token, address user, uint256 amount) onlyFuturesContract returns (bool success) { 
215         updateReserve(token, user, amount);
216         return true; 
217     }
218 
219     function setBalance(address token, address user, uint256 amount) onlyFuturesContract returns (bool success)     {
220         updateBalance(token, user, amount);
221         return true;
222         
223     }
224 
225     function subBalanceAddReserve(address token, address user, uint256 subBalance, uint256 addReserve) onlyFuturesContract returns (bool)
226     {
227         if (balanceOf(token, user) < subBalance) return false;
228         updateBalanceAndReserve(token, user, safeSub(balanceOf(token, user), subBalance), safeAdd(getReserve(token, user), addReserve));
229         return true;
230     }
231 
232     function addBalanceSubReserve(address token, address user, uint256 addBalance, uint256 subReserve) onlyFuturesContract returns (bool)
233     {
234         if (getReserve(token, user) < subReserve) return false;
235         updateBalanceAndReserve(token, user, safeAdd(balanceOf(token, user), addBalance), safeSub(getReserve(token, user), subReserve));
236         return true;
237     }
238 
239     function addBalanceAddReserve(address token, address user, uint256 addBalance, uint256 addReserve) onlyFuturesContract returns (bool)
240     {
241         updateBalanceAndReserve(token, user, safeAdd(balanceOf(token, user), addBalance), safeAdd(getReserve(token, user), addReserve));
242     }
243 
244     function subBalanceSubReserve(address token, address user, uint256 subBalance, uint256 subReserve) onlyFuturesContract returns (bool)
245     {
246         if (balanceOf(token, user) < subBalance || getReserve(token, user) < subReserve) return false;
247         updateBalanceAndReserve(token, user, safeSub(balanceOf(token, user), subBalance), safeSub(getReserve(token, user), subReserve));
248         return true;
249     }
250 
251     // Returns the available balance of a specific token for a specific user
252     function availableBalanceOf(address token, address user) view returns (uint256) {
253         return safeSub(balanceOf(token, user), getReserve(token, user));
254     }
255 
256     // Increases the user balance
257     function addBalance(address token, address user, uint256 amount) private
258     {
259         updateBalance(token, user, safeAdd(balanceOf(token, user), amount));
260     }
261 
262     // Decreases user balance
263     function subBalance(address token, address user, uint256 amount) private
264     {
265         if (availableBalanceOf(token, user) < amount) throw; 
266         updateBalance(token, user, safeSub(balanceOf(token, user), amount));
267     }
268 
269 
270 
271     // Returns the inactivity release perios
272     function getInactivityReleasePeriod() view returns (uint256)
273     {
274         return inactivityReleasePeriod;
275     }
276 
277 
278     // Deposit ETH to contract
279     function deposit() payable {
280         if (destroyed) revert();
281         
282         addBalance(address(0), msg.sender, msg.value); // adds the deposited amount to user balance
283         if (userFirstDeposits[msg.sender] == 0) userFirstDeposits[msg.sender] = block.number;
284         emit Deposit(address(0), msg.sender, msg.value, balanceOf(address(0), msg.sender)); // fires the deposit event
285     }
286 
287     // Deposit ETH to contract for a user
288     function depositForUser(address user) payable {
289         if (destroyed) revert();
290         addBalance(address(0), user, msg.value); // adds the deposited amount to user balance
291         emit Deposit(address(0), user, msg.value, balanceOf(address(0), user)); // fires the deposit event
292     }
293 
294     // Deposit token to contract
295     function depositToken(address token, uint128 amount) {
296         if (destroyed) revert();
297         
298         addBalance(token, msg.sender, amount); // adds the deposited amount to user balance
299 
300         if (!Token(token).transferFrom(msg.sender, this, amount)) throw; // attempts to transfer the token to this contract, if fails throws an error
301         emit Deposit(token, msg.sender, amount, balanceOf(token, msg.sender)); // fires the deposit event
302     }
303 
304     // Deposit token to contract for a user
305     function depositTokenForUser(address token, uint128 amount, address user) {        
306         addBalance(token, user, amount); // adds the deposited amount to user balance
307 
308         if (!Token(token).transferFrom(msg.sender, this, amount)) throw; // attempts to transfer the token to this contract, if fails throws an error
309         emit Deposit(token, user, amount, balanceOf(token, user)); // fires the deposit event
310     }
311 
312     // Deposit token to contract for a user anc charge a deposit fee
313     function depositTokenForUserWithFee(address token, uint128 amount, address user, uint256 depositFee) {        
314         if (safeMul(depositFee, 1e18) / amount > 1e17) revert(); // deposit fee is more than 10% of the deposit amount
315         addBalance(token, user, safeSub(amount, depositFee)); // adds the deposited amount to user balance
316         
317         addBalance(token, gasFeeAccount, depositFee); // adds the deposit fee to the gasFeeAccount
318         
319         if (!Token(token).transferFrom(msg.sender, this, amount)) revert(); // attempts to transfer the token to this contract, if fails throws an error
320         
321         emit Deposit(token, user, safeSub(amount, depositFee), balanceOf(token, user)); // fires the deposit event
322     }
323 
324     function withdraw(address token, uint256 amount) returns (bool success) {
325         
326         if (availableBalanceOf(token, msg.sender) < amount) throw;
327 
328         subBalance(token, msg.sender, amount); // subtracts the withdrawed amount from user balance
329 
330         if (token == address(0)) { // checks if withdrawal is a token or ETH, ETH has address 0x00000... 
331             if (!msg.sender.send(amount)) throw; // send ETH
332         } else {
333             if (!Token(token).transfer(msg.sender, amount)) throw; // Send token
334         }
335         emit Withdraw(token, msg.sender, amount, balanceOf(token, msg.sender), 0); // fires the Withdraw event
336     }
337 
338     function pTokenRedeem(address token, uint256 amount, string destinationAddress) returns (bool success) {
339         
340         if (availableBalanceOf(token, msg.sender) < amount) revert();
341 
342         subBalance(token, msg.sender, amount); // subtracts the withdrawal amount from user balance
343 
344         if (!pToken(token).redeem(amount, destinationAddress)) revert();
345         emit pTokenRedeemEvent(token, msg.sender, amount, destinationAddress);
346     }
347 
348     function releaseFundsAfterDestroy(address token, uint256 amount) onlyOwner returns (bool success) {
349         if (!destroyed) throw;
350         if (safeAdd(destroyBlock, destroyDelay) > block.number) throw; // destroy delay not yet passed
351 
352         if (token == address(0)) { // checks if withdrawal is a token or ETH, ETH has address 0x00000... 
353             if (!msg.sender.send(amount)) throw; // send ETH
354         } else {
355             if (!Token(token).transfer(msg.sender, amount)) throw; // Send token
356         }
357     }
358  
359 
360     // Withdrawal function used by the server to execute withdrawals
361     function withdrawForUser(
362         address token, // the address of the token to be withdrawn
363         uint256 amount, // the amount to be withdrawn
364         address user, // address of the user
365         uint256 nonce, // nonce to make the request unique
366         uint8 v, // part of user signature
367         bytes32 r, // part of user signature
368         bytes32 s, // part of user signature
369         uint256 feeWithdrawal // the transaction gas fee that will be deducted from the user balance
370     ) onlyAdmin returns (bool success) {
371         bytes32 hash = keccak256(this, token, amount, user, nonce, feeWithdrawal); // creates the hash for the withdrawal request
372         if (withdrawn[hash]) throw; // checks if the withdrawal was already executed, if true, throws an error
373         withdrawn[hash] = true; // sets the withdrawal as executed
374         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw; // checks that the provided signature is valid
375         
376         if (availableBalanceOf(token, user) < amount) throw; // checks that user has enough balance
377 
378         subBalance(token, user, amount); // subtracts the withdrawal amount from the user balance
379 
380         addBalance(token, gasFeeAccount, feeWithdrawal); // moves the gas fee to the feeAccount
381 
382         if (token == address(0)) { // checks if the withdrawal is in ETH or Tokens
383             if (!user.send(safeSub(amount, feeWithdrawal))) throw; // sends ETH
384         } else {
385             if (!Token(token).transfer(user, safeSub(amount, feeWithdrawal))) throw; // sends tokens
386         }
387         emit Withdraw(token, user, amount, balanceOf(token, user), feeWithdrawal); // fires the withdraw event
388     }
389 
390     function batchWithdrawForUser(
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
402             withdrawForUser(
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
415     // Withdrawal function used by the server to execute withdrawals
416     function pTokenRedeemForUser(
417         address token, // the address of the token to be withdrawn
418         uint256 amount, // the amount to be withdrawn
419         address user, // address of the user
420         string destinationAddress, // the destination address of the user (BTC address for pBTC)
421         uint256 nonce, // nonce to make the request unique
422         uint8 v, // part of user signature
423         bytes32 r, // part of user signature
424         bytes32 s, // part of user signature
425         uint256 feeWithdrawal // the transaction gas fee that will be deducted from the user balance
426     ) onlyAdmin returns (bool success) {
427         bytes32 hash = keccak256(this, token, amount, user, nonce, destinationAddress, feeWithdrawal); // creates the hash for the withdrawal request
428         if (withdrawn[hash]) throw; // checks if the withdrawal was already executed, if true, throws an error
429         withdrawn[hash] = true; // sets the withdrawal as executed
430         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw; // checks that the provided signature is valid
431         
432         if (availableBalanceOf(token, user) < amount) throw; // checks that user has enough balance
433 
434         subBalance(token, user, amount); // subtracts the withdrawal amount from the user balance
435 
436         addBalance(token, gasFeeAccount, feeWithdrawal); // moves the gas fee to the feeAccount
437 
438         if (!pToken(token).redeem(amount, destinationAddress)) revert();
439 
440         emit pTokenRedeemEvent(token, user, amount, destinationAddress);
441     }
442     
443 
444     function getMakerTakerBalances(address token, address maker, address taker) view returns (uint256[4])
445     {
446         return [
447             balanceOf(token, maker),
448             balanceOf(token, taker),
449             getReserve(token, maker),
450             getReserve(token, taker)
451         ];
452     }
453 
454     function getUserBalances(address token, address user) view returns (uint256[2])
455     {
456         return [
457             balanceOf(token, user),
458             getReserve(token, user)
459         ];
460     }
461 }