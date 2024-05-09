1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15     function transfer(address to, uint256 value) external returns (bool);
16 
17     function approve(address spender, uint256 value)
18     external returns (bool);
19 
20     function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23     event Transfer(
24         address indexed from,
25         address indexed to,
26         uint256 value
27     );
28 
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42     /**
43     * @dev Multiplies two numbers, reverts on overflow.
44     */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61     */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b > 0);
64         // Solidity only automatically asserts when dividing by 0
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     /**
72     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73     */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82     * @dev Adds two numbers, reverts on overflow.
83     */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a);
87 
88         return c;
89     }
90 
91     /**
92     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
93     * reverts when dividing by zero.
94     */
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0);
97         return a % b;
98     }
99 }
100 
101 /**
102  * @title SEEDDEX
103  * @dev This is the main contract for the SEEDDEX exchange.
104  */
105 contract SEEDDEX {
106 
107     /// Variables
108     address public admin; // the admin address
109     address constant public FicAddress = 0x0DD83B5013b2ad7094b1A7783d96ae0168f82621;  // FloraFIC token address
110     address public manager; // the manager address
111     address public feeAccount; // the account that will receive fees
112     uint public feeTakeMaker; // For Maker fee x% *10^18
113     uint public feeTakeSender; // For Sender fee x% *10^18
114     uint public feeTakeMakerFic;
115     uint public feeTakeSenderFic;
116     bool private depositingTokenFlag; // True when Token.transferFrom is being called from depositToken
117     mapping(address => mapping(address => uint)) public tokens; // mapping of token addresses to mapping of account balances (token=0 means Ether)
118     mapping(address => mapping(bytes32 => bool)) public orders; // mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
119     mapping(address => mapping(bytes32 => uint)) public orderFills; // mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
120     address public predecessor; // Address of the previous version of this contract. If address(0), this is the first version
121     address public successor; // Address of the next version of this contract. If address(0), this is the most up to date version.
122     uint16 public version; // This is the version # of the contract
123 
124     /// Logging Events
125     event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address indexed user, bytes32 hash, uint amount);
126     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address indexed user, uint8 v, bytes32 r, bytes32 s);
127     event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give, uint256 timestamp);
128     event Deposit(address token, address indexed user, uint amount, uint balance);
129     event Withdraw(address token, address indexed user, uint amount, uint balance);
130     event FundsMigrated(address indexed user, address newContract);
131 
132     /// This is a modifier for functions to check if the sending user address is the same as the admin user address.
133     modifier isAdmin() {
134         require(msg.sender == admin);
135         _;
136     }
137 
138     /// this is manager can only change feeTakeMaker feeTakeMaker and change manager address (accept only Ethereum address)
139     modifier isManager() {
140         require(msg.sender == manager || msg.sender == admin);
141         _;
142     }
143 
144     /// Constructor function. This is only called on contract creation.
145     function SEEDDEX(address admin_, address manager_, address feeAccount_, uint feeTakeMaker_, uint feeTakeSender_, uint feeTakeMakerFic_, uint feeTakeSenderFic_, address predecessor_) public {
146         admin = admin_;
147         manager = manager_;
148         feeAccount = feeAccount_;
149         feeTakeMaker = feeTakeMaker_;
150         feeTakeSender = feeTakeSender_;
151         feeTakeMakerFic = feeTakeMakerFic_;
152         feeTakeSenderFic = feeTakeSenderFic_;
153         depositingTokenFlag = false;
154         predecessor = predecessor_;
155 
156         if (predecessor != address(0)) {
157             version = SEEDDEX(predecessor).version() + 1;
158         } else {
159             version = 1;
160         }
161     }
162 
163     /// The fallback function. Ether transfered into the contract is not accepted.
164     function() public {
165         revert();
166     }
167 
168     /// Changes the official admin user address. Accepts Ethereum address.
169     function changeAdmin(address admin_) public isAdmin {
170         require(admin_ != address(0));
171         admin = admin_;
172     }
173 
174     /// Changes the manager user address. Accepts Ethereum address.
175     function changeManager(address manager_) public isManager {
176         require(manager_ != address(0));
177         manager = manager_;
178     }
179 
180     /// Changes the account address that receives trading fees. Accepts Ethereum address.
181     function changeFeeAccount(address feeAccount_) public isAdmin {
182         feeAccount = feeAccount_;
183     }
184 
185     /// Changes the fee on takes. Can only be changed to a value less than it is currently set at.
186     function changeFeeTakeMaker(uint feeTakeMaker_) public isManager {
187         feeTakeMaker = feeTakeMaker_;
188     }
189 
190     function changeFeeTakeSender(uint feeTakeSender_) public isManager {
191         feeTakeSender = feeTakeSender_;
192     }
193 
194     function changeFeeTakeMakerFic(uint feeTakeMakerFic_) public isManager {
195         feeTakeMakerFic = feeTakeMakerFic_;
196     }
197 
198     function changeFeeTakeSenderFic(uint feeTakeSenderFic_) public isManager {
199         feeTakeSenderFic = feeTakeSenderFic_;
200     }
201 
202     /// Changes the successor. Used in updating the contract.
203     function setSuccessor(address successor_) public isAdmin {
204         require(successor_ != address(0));
205         successor = successor_;
206     }
207 
208     ////////////////////////////////////////////////////////////////////////////////
209     // Deposits, Withdrawals, Balances
210     ////////////////////////////////////////////////////////////////////////////////
211 
212     /**
213     * This function handles deposits of Ether into the contract.
214     * Emits a Deposit event.
215     * Note: With the payable modifier, this function accepts Ether.
216     */
217     function deposit() public payable {
218         tokens[0][msg.sender] = SafeMath.add(tokens[0][msg.sender], msg.value);
219         Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
220     }
221 
222     /**
223     * This function handles withdrawals of Ether from the contract.
224     * Verifies that the user has enough funds to cover the withdrawal.
225     * Emits a Withdraw event.
226     * @param amount uint of the amount of Ether the user wishes to withdraw
227     */
228     function withdraw(uint amount) {
229         if (tokens[0][msg.sender] < amount) throw;
230         tokens[0][msg.sender] = SafeMath.sub(tokens[0][msg.sender], amount);
231         if (!msg.sender.call.value(amount)()) throw;
232         Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
233     }
234 
235     /**
236     * This function handles deposits of Ethereum based tokens to the contract.
237     * Does not allow Ether.
238     * If token transfer fails, transaction is reverted and remaining gas is refunded.
239     * Emits a Deposit event.
240     * Note: Remember to call IERC20(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
241     * @param token Ethereum contract address of the token or 0 for Ether
242     * @param amount uint of the amount of the token the user wishes to deposit
243     */
244     function depositToken(address token, uint amount) {
245         //remember to call IERC20(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
246         if (token == 0) throw;
247         if (!IERC20(token).transferFrom(msg.sender, this, amount)) throw;
248         tokens[token][msg.sender] = SafeMath.add(tokens[token][msg.sender], amount);
249         Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
250     }
251 
252     /**
253     * This function provides a fallback solution as outlined in ERC223.
254     * If tokens are deposited through depositToken(), the transaction will continue.
255     * If tokens are sent directly to this contract, the transaction is reverted.
256     * @param sender Ethereum address of the sender of the token
257     * @param amount amount of the incoming tokens
258     * @param data attached data similar to msg.data of Ether transactions
259     */
260     function tokenFallback(address sender, uint amount, bytes data) public returns (bool ok) {
261         if (depositingTokenFlag) {
262             // Transfer was initiated from depositToken(). User token balance will be updated there.
263             return true;
264         } else {
265             // Direct ECR223 Token.transfer into this contract not allowed, to keep it consistent
266             // with direct transfers of ECR20 and ETH.
267             revert();
268         }
269     }
270 
271     /**
272     * This function handles withdrawals of Ethereum based tokens from the contract.
273     * Does not allow Ether.
274     * If token transfer fails, transaction is reverted and remaining gas is refunded.
275     * Emits a Withdraw event.
276     * @param token Ethereum contract address of the token or 0 for Ether
277     * @param amount uint of the amount of the token the user wishes to withdraw
278     */
279     function withdrawToken(address token, uint amount) {
280         if (token == 0) throw;
281         if (tokens[token][msg.sender] < amount) throw;
282         tokens[token][msg.sender] = SafeMath.sub(tokens[token][msg.sender], amount);
283         if (!IERC20(token).transfer(msg.sender, amount)) throw;
284         Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
285     }
286 
287     /**
288     * Retrieves the balance of a token based on a user address and token address.
289     * @param token Ethereum contract address of the token or 0 for Ether
290     * @param user Ethereum address of the user
291     * @return the amount of tokens on the exchange for a given user address
292     */
293     function balanceOf(address token, address user) public constant returns (uint) {
294         return tokens[token][user];
295     }
296 
297     ////////////////////////////////////////////////////////////////////////////////
298     // Trading
299     ////////////////////////////////////////////////////////////////////////////////
300 
301     /**
302     * Stores the active order inside of the contract.
303     * Emits an Order event.
304     *
305     *
306     * Note: tokenGet & tokenGive can be the Ethereum contract address.
307     * @param tokenGet Ethereum contract address of the token to receive
308     * @param amountGet uint amount of tokens being received
309     * @param tokenGive Ethereum contract address of the token to give
310     * @param amountGive uint amount of tokens being given
311     * @param expires uint of block number when this order should expire
312     * @param nonce arbitrary random number
313     */
314     function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
315         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
316         uint amount;
317         orders[msg.sender][hash] = true;
318         Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, hash, amount);
319     }
320 
321     /**
322     * Facilitates a trade from one user to another.
323     * Requires that the transaction is signed properly, the trade isn't past its expiration, and all funds are present to fill the trade.
324     * Calls tradeBalances().
325     * Updates orderFills with the amount traded.
326     * Emits a Trade event.
327     * Note: tokenGet & tokenGive can be the Ethereum contract address.
328     * Note: amount is in amountGet / tokenGet terms.
329     * @param tokenGet Ethereum contract address of the token to receive
330     * @param amountGet uint amount of tokens being received
331     * @param tokenGive Ethereum contract address of the token to give
332     * @param amountGive uint amount of tokens being given
333     * @param expires uint of block number when this order should expire
334     * @param nonce arbitrary random number
335     * @param user Ethereum address of the user who placed the order
336     * @param v part of signature for the order hash as signed by user
337     * @param r part of signature for the order hash as signed by user
338     * @param s part of signature for the order hash as signed by user
339     * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
340     */
341     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
342         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
343         require((
344             (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
345             block.number <= expires &&
346             SafeMath.add(orderFills[user][hash], amount) <= amountGet
347             ));
348         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
349         orderFills[user][hash] = SafeMath.add(orderFills[user][hash], amount);
350         Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender, now);
351     }
352 
353     /**
354     * This is a private function and is only being called from trade().
355     * Handles the movement of funds when a trade occurs.
356     * Takes fees.
357     * Updates token balances for both buyer and seller.
358     * Note: tokenGet & tokenGive can be the Ethereum contract address.
359     * Note: amount is in amountGet / tokenGet terms.
360     * @param tokenGet Ethereum contract address of the token to receive
361     * @param amountGet uint amount of tokens being received
362     * @param tokenGive Ethereum contract address of the token to give
363     * @param amountGive uint amount of tokens being given
364     * @param user Ethereum address of the user who placed the order
365     * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
366     */
367     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
368         if (tokenGet == FicAddress || tokenGive == FicAddress) {
369             tokens[tokenGet][msg.sender] = SafeMath.sub(tokens[tokenGet][msg.sender], amount);
370             tokens[tokenGet][user] = SafeMath.add(tokens[tokenGet][user], SafeMath.mul(amount, ((1 ether) - feeTakeMakerFic)) / (1 ether));
371             tokens[tokenGet][feeAccount] = SafeMath.add(tokens[tokenGet][feeAccount], SafeMath.mul(amount, feeTakeMakerFic) / (1 ether));
372             tokens[tokenGive][user] = SafeMath.sub(tokens[tokenGive][user], SafeMath.mul(amountGive, amount) / amountGet);
373             tokens[tokenGive][msg.sender] = SafeMath.add(tokens[tokenGive][msg.sender], SafeMath.mul(SafeMath.mul(((1 ether) - feeTakeSenderFic), amountGive), amount) / amountGet / (1 ether));
374             tokens[tokenGive][feeAccount] = SafeMath.add(tokens[tokenGive][feeAccount], SafeMath.mul(SafeMath.mul(feeTakeSenderFic, amountGive), amount) / amountGet / (1 ether));
375         }
376         else {
377             tokens[tokenGet][msg.sender] = SafeMath.sub(tokens[tokenGet][msg.sender], amount);
378             tokens[tokenGet][user] = SafeMath.add(tokens[tokenGet][user], SafeMath.mul(amount, ((1 ether) - feeTakeMaker)) / (1 ether));
379             tokens[tokenGet][feeAccount] = SafeMath.add(tokens[tokenGet][feeAccount], SafeMath.mul(amount, feeTakeMaker) / (1 ether));
380             tokens[tokenGive][user] = SafeMath.sub(tokens[tokenGive][user], SafeMath.mul(amountGive, amount) / amountGet);
381             tokens[tokenGive][msg.sender] = SafeMath.add(tokens[tokenGive][msg.sender], SafeMath.mul(SafeMath.mul(((1 ether) - feeTakeSender), amountGive), amount) / amountGet / (1 ether));
382             tokens[tokenGive][feeAccount] = SafeMath.add(tokens[tokenGive][feeAccount], SafeMath.mul(SafeMath.mul(feeTakeSender, amountGive), amount) / amountGet / (1 ether));
383         }
384     }
385 
386     /**
387     * This function is to test if a trade would go through.
388     * Note: tokenGet & tokenGive can be the Ethereum contract address.
389     * Note: amount is in amountGet / tokenGet terms.
390     * @param tokenGet Ethereum contract address of the token to receive
391     * @param amountGet uint amount of tokens being received
392     * @param tokenGive Ethereum contract address of the token to give
393     * @param amountGive uint amount of tokens being given
394     * @param expires uint of block number when this order should expire
395     * @param nonce arbitrary random number
396     * @param user Ethereum address of the user who placed the order
397     * @param v part of signature for the order hash as signed by user
398     * @param r part of signature for the order hash as signed by user
399     * @param s part of signature for the order hash as signed by user
400     * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
401     * @param sender Ethereum address of the user taking the order
402     * @return bool: true if the trade would be successful, false otherwise
403     */
404     function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns (bool) {
405         if (!(
406         tokens[tokenGet][sender] >= amount &&
407         availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
408         )) {
409             return false;
410         } else {
411             return true;
412         }
413     }
414 
415     /**
416     * This function checks the available volume for a given order.
417     * Note: tokenGet & tokenGive can be the Ethereum contract address.
418     * @param tokenGet Ethereum contract address of the token to receive
419     * @param amountGet uint amount of tokens being received
420     * @param tokenGive Ethereum contract address of the token to give
421     * @param amountGive uint amount of tokens being given
422     * @param expires uint of block number when this order should expire
423     * @param nonce arbitrary random number
424     * @param user Ethereum address of the user who placed the order
425     * @param v part of signature for the order hash as signed by user
426     * @param r part of signature for the order hash as signed by user
427     * @param s part of signature for the order hash as signed by user
428     * @return uint: amount of volume available for the given order in terms of amountGet / tokenGet
429     */
430     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns (uint) {
431         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
432         if (!(
433         (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
434         block.number <= expires
435         )) {
436             return 0;
437         }
438         uint[2] memory available;
439         available[0] = SafeMath.sub(amountGet, orderFills[user][hash]);
440         available[1] = SafeMath.mul(tokens[tokenGive][user], amountGet) / amountGive;
441         if (available[0] < available[1]) {
442             return available[0];
443         } else {
444             return available[1];
445         }
446     }
447 
448     /**
449     * This function checks the amount of an order that has already been filled.
450     * Note: tokenGet & tokenGive can be the Ethereum contract address.
451     * @param tokenGet Ethereum contract address of the token to receive
452     * @param amountGet uint amount of tokens being received
453     * @param tokenGive Ethereum contract address of the token to give
454     * @param amountGive uint amount of tokens being given
455     * @param expires uint of block number when this order should expire
456     * @param nonce arbitrary random number
457     * @param user Ethereum address of the user who placed the order
458     * @param v part of signature for the order hash as signed by user
459     * @param r part of signature for the order hash as signed by user
460     * @param s part of signature for the order hash as signed by user
461     * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
462     */
463     function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns (uint) {
464         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
465         return orderFills[user][hash];
466     }
467 
468     /**
469     * This function cancels a given order by editing its fill data to the full amount.
470     * Requires that the transaction is signed properly.
471     * Updates orderFills to the full amountGet
472     * Emits a Cancel event.
473     * Note: tokenGet & tokenGive can be the Ethereum contract address.
474     * @param tokenGet Ethereum contract address of the token to receive
475     * @param amountGet uint amount of tokens being received
476     * @param tokenGive Ethereum contract address of the token to give
477     * @param amountGive uint amount of tokens being given
478     * @param expires uint of block number when this order should expire
479     * @param nonce arbitrary random number
480     * @param v part of signature for the order hash as signed by user
481     * @param r part of signature for the order hash as signed by user
482     * @param s part of signature for the order hash as signed by user
483     * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
484     */
485     function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
486         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
487         require((orders[msg.sender][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == msg.sender));
488         orderFills[msg.sender][hash] = amountGet;
489         Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
490     }
491 
492 
493 
494     ////////////////////////////////////////////////////////////////////////////////
495     // Contract Versioning / Migration
496     ////////////////////////////////////////////////////////////////////////////////
497 
498     /**
499     * User triggered function to migrate funds into a new contract to ease updates.
500     * Emits a FundsMigrated event.
501     * @param newContract Contract address of the new contract we are migrating funds to
502     * @param tokens_ Array of token addresses that we will be migrating to the new contract
503     */
504     function migrateFunds(address newContract, address[] tokens_) public {
505 
506         require(newContract != address(0));
507 
508         SEEDDEX newExchange = SEEDDEX(newContract);
509 
510         // Move Ether into new exchange.
511         uint etherAmount = tokens[0][msg.sender];
512         if (etherAmount > 0) {
513             tokens[0][msg.sender] = 0;
514             newExchange.depositForUser.value(etherAmount)(msg.sender);
515         }
516 
517         // Move Tokens into new exchange.
518         for (uint16 n = 0; n < tokens_.length; n++) {
519             address token = tokens_[n];
520             require(token != address(0));
521             // Ether is handled above.
522             uint tokenAmount = tokens[token][msg.sender];
523 
524             if (tokenAmount != 0) {
525                 if (!IERC20(token).approve(newExchange, tokenAmount)) throw;
526                 tokens[token][msg.sender] = 0;
527                 newExchange.depositTokenForUser(token, tokenAmount, msg.sender);
528             }
529         }
530 
531         FundsMigrated(msg.sender, newContract);
532     }
533 
534 
535     /**
536     * This function handles deposits of Ether into the contract, but allows specification of a user.
537     * Note: This is generally used in migration of funds.
538     * Note: With the payable modifier, this function accepts Ether.
539     */
540     function depositForUser(address user) public payable {
541         require(user != address(0));
542         require(msg.value > 0);
543         tokens[0][user] = SafeMath.add(tokens[0][user], (msg.value));
544     }
545 
546     /**
547     * This function handles deposits of Ethereum based tokens into the contract, but allows specification of a user.
548     * Does not allow Ether.
549     * If token transfer fails, transaction is reverted and remaining gas is refunded.
550     * Note: This is generally used in migration of funds.
551     * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
552     * @param token Ethereum contract address of the token
553     * @param amount uint of the amount of the token the user wishes to deposit
554     */
555     function depositTokenForUser(address token, uint amount, address user) public {
556         require(token != address(0));
557         require(user != address(0));
558         require(amount > 0);
559         depositingTokenFlag = true;
560         if (!IERC20(token).transferFrom(msg.sender, this, amount)) throw;
561         depositingTokenFlag = false;
562         tokens[token][user] = SafeMath.add(tokens[token][user], (amount));
563     }
564 }