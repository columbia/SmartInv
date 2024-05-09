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
102 * @dev Library to perform safe calls to standard method for ERC20 tokens.
103 *
104 * Why Transfers: transfer methods could have a return value (bool), throw or revert for insufficient funds or
105 * unathorized value.
106 *
107 * Why Approve: approve method could has a return value (bool) or does not accept 0 as a valid value (BNB token).
108 * The common strategy used to clean approvals.
109 *
110 * We use the Solidity call instead of interface methods because in the case of transfer, it will fail
111 * for tokens with an implementation without returning a value.
112 * Since versions of Solidity 0.4.22 the EVM has a new opcode, called RETURNDATASIZE.
113 * This opcode stores the size of the returned data of an external call. The code checks the size of the return value
114 * after an external call and reverts the transaction in case the return data is shorter than expected
115 */
116 library SafeERC20 {
117 
118     using SafeMath for uint256;
119 
120     /**
121     * @dev Transfer token for a specified address
122     * @param _token erc20 The address of the ERC20 contract
123     * @param _to address The address which you want to transfer to
124     * @param _value uint256 the _value of tokens to be transferred
125     * @return bool whether the transfer was successful or not
126     */
127     function safeTransfer(IERC20 _token, address _to, uint256 _value) internal returns (bool) {
128         uint256 prevBalance = _token.balanceOf(address(this));
129 
130         if (prevBalance < _value) {
131             // Insufficient funds
132             return false;
133         }
134 
135         address(_token).call(
136             abi.encodeWithSignature("transfer(address,uint256)", _to, _value)
137         );
138 
139         if (prevBalance.sub(_value) != _token.balanceOf(address(this))) {
140             // Transfer failed
141             return false;
142         }
143 
144         return true;
145     }
146 
147     /**
148     * @dev Transfer tokens from one address to another
149     * @param _token erc20 The address of the ERC20 contract
150     * @param _from address The address which you want to send tokens from
151     * @param _to address The address which you want to transfer to
152     * @param _value uint256 the _value of tokens to be transferred
153     * @return bool whether the transfer was successful or not
154     */
155     function safeTransferFrom(
156         IERC20 _token,
157         address _from,
158         address _to,
159         uint256 _value
160     ) internal returns (bool)
161     {
162         uint256 prevBalance = _token.balanceOf(_from);
163 
164         if (prevBalance < _value) {
165             // Insufficient funds
166             return false;
167         }
168 
169         if (_token.allowance(_from, address(this)) < _value) {
170             // Insufficient allowance
171             return false;
172         }
173 
174         address(_token).call(
175             abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value)
176         );
177 
178         if (prevBalance.sub(_value) != _token.balanceOf(_from)) {
179             // Transfer failed
180             return false;
181         }
182 
183         return true;
184     }
185 
186     /**
187     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188     *
189     * Beware that changing an allowance with this method brings the risk that someone may use both the old
190     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193     *
194     * @param _token erc20 The address of the ERC20 contract
195     * @param _spender The address which will spend the funds.
196     * @param _value The amount of tokens to be spent.
197     * @return bool whether the approve was successful or not
198     */
199     function safeApprove(IERC20 _token, address _spender, uint256 _value) internal returns (bool) {
200         address(_token).call(
201             abi.encodeWithSignature("approve(address,uint256)", _spender, _value)
202         );
203 
204         if (_token.allowance(address(this), _spender) != _value) {
205             // Approve failed
206             return false;
207         }
208 
209         return true;
210     }
211 
212 }
213 
214 /**
215  * @title SEEDDEX
216  * @dev This is the main contract for the SEEDDEX exchange.
217  */
218 contract SEEDDEX {
219 
220     using SafeERC20 for IERC20;
221 
222     /// Variables
223     address public admin; // the admin address
224     address constant public FicAddress = 0x0DD83B5013b2ad7094b1A7783d96ae0168f82621;  // FloraFIC token address
225     address public manager; // the manager address
226     address public feeAccount; // the account that will receive fees
227     uint public feeTakeMaker; // For Maker fee x% *10^18
228     uint public feeTakeSender; // For Sender fee x% *10^18
229     uint public feeTakeMakerFic;
230     uint public feeTakeSenderFic;
231     bool private depositingTokenFlag; // True when Token.safeTransferFrom is being called from depositToken
232     mapping(address => mapping(address => uint)) public tokens; // mapping of token addresses to mapping of account balances (token=0 means Ether)
233     mapping(address => mapping(bytes32 => bool)) public orders; // mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
234     mapping(address => mapping(bytes32 => uint)) public orderFills; // mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
235     address public predecessor; // Address of the previous version of this contract. If address(0), this is the first version
236     address public successor; // Address of the next version of this contract. If address(0), this is the most up to date version.
237     uint16 public version; // This is the version # of the contract
238 
239     /// Logging Events
240     event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address indexed user, bytes32 hash, uint amount);
241     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address indexed user, uint8 v, bytes32 r, bytes32 s);
242     event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give, uint256 timestamp);
243     event Deposit(address token, address indexed user, uint amount, uint balance);
244     event Withdraw(address token, address indexed user, uint amount, uint balance);
245     event FundsMigrated(address indexed user, address newContract);
246 
247     /// This is a modifier for functions to check if the sending user address is the same as the admin user address.
248     modifier isAdmin() {
249         require(msg.sender == admin);
250         _;
251     }
252 
253     /// this is manager can only change feeTakeMaker feeTakeMaker and change manager address (accept only Ethereum address)
254     modifier isManager() {
255         require(msg.sender == manager || msg.sender == admin);
256         _;
257     }
258 
259     /// Constructor function. This is only called on contract creation.
260     function SEEDDEX(address admin_, address manager_, address feeAccount_, uint feeTakeMaker_, uint feeTakeSender_, uint feeTakeMakerFic_, uint feeTakeSenderFic_, address predecessor_) public {
261         admin = admin_;
262         manager = manager_;
263         feeAccount = feeAccount_;
264         feeTakeMaker = feeTakeMaker_;
265         feeTakeSender = feeTakeSender_;
266         feeTakeMakerFic = feeTakeMakerFic_;
267         feeTakeSenderFic = feeTakeSenderFic_;
268         depositingTokenFlag = false;
269         predecessor = predecessor_;
270 
271         if (predecessor != address(0)) {
272             version = SEEDDEX(predecessor).version() + 1;
273         } else {
274             version = 1;
275         }
276     }
277 
278     /// The fallback function. Ether transfered into the contract is not accepted.
279     function() public {
280         revert();
281     }
282 
283     /// Changes the official admin user address. Accepts Ethereum address.
284     function changeAdmin(address admin_) public isAdmin {
285         require(admin_ != address(0));
286         admin = admin_;
287     }
288 
289     /// Changes the manager user address. Accepts Ethereum address.
290     function changeManager(address manager_) public isManager {
291         require(manager_ != address(0));
292         manager = manager_;
293     }
294 
295     /// Changes the account address that receives trading fees. Accepts Ethereum address.
296     function changeFeeAccount(address feeAccount_) public isAdmin {
297         feeAccount = feeAccount_;
298     }
299 
300     /// Changes the fee on takes. Can only be changed to a value less than it is currently set at.
301     function changeFeeTakeMaker(uint feeTakeMaker_) public isManager {
302         feeTakeMaker = feeTakeMaker_;
303     }
304 
305     function changeFeeTakeSender(uint feeTakeSender_) public isManager {
306         feeTakeSender = feeTakeSender_;
307     }
308 
309     function changeFeeTakeMakerFic(uint feeTakeMakerFic_) public isManager {
310         feeTakeMakerFic = feeTakeMakerFic_;
311     }
312 
313     function changeFeeTakeSenderFic(uint feeTakeSenderFic_) public isManager {
314         feeTakeSenderFic = feeTakeSenderFic_;
315     }
316 
317     /// Changes the successor. Used in updating the contract.
318     function setSuccessor(address successor_) public isAdmin {
319         require(successor_ != address(0));
320         successor = successor_;
321     }
322 
323     ////////////////////////////////////////////////////////////////////////////////
324     // Deposits, Withdrawals, Balances
325     ////////////////////////////////////////////////////////////////////////////////
326 
327     /**
328     * This function handles deposits of Ether into the contract.
329     * Emits a Deposit event.
330     * Note: With the payable modifier, this function accepts Ether.
331     */
332     function deposit() public payable {
333         tokens[0][msg.sender] = SafeMath.add(tokens[0][msg.sender], msg.value);
334         Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
335     }
336 
337     /**
338     * This function handles withdrawals of Ether from the contract.
339     * Verifies that the user has enough funds to cover the withdrawal.
340     * Emits a Withdraw event.
341     * @param amount uint of the amount of Ether the user wishes to withdraw
342     */
343     function withdraw(uint amount) {
344         if (tokens[0][msg.sender] < amount) throw;
345         tokens[0][msg.sender] = SafeMath.sub(tokens[0][msg.sender], amount);
346         if (!msg.sender.call.value(amount)()) throw;
347         Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
348     }
349 
350     /**
351     * This function handles deposits of Ethereum based tokens to the contract.
352     * Does not allow Ether.
353     * If token transfer fails, transaction is reverted and remaining gas is refunded.
354     * Emits a Deposit event.
355     * Note: Remember to call IERC20(address).safeApprove(this, amount) or this contract will not be able to do the transfer on your behalf.
356     * @param token Ethereum contract address of the token or 0 for Ether
357     * @param amount uint of the amount of the token the user wishes to deposit
358     */
359     function depositToken(address token, uint amount) {
360         //remember to call IERC20(address).safeApprove(this, amount) or this contract will not be able to do the transfer on your behalf.
361         if (token == 0) throw;
362         if (!IERC20(token).safeTransferFrom(msg.sender, this, amount)) throw;
363         tokens[token][msg.sender] = SafeMath.add(tokens[token][msg.sender], amount);
364         Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
365     }
366 
367     /**
368     * This function provides a fallback solution as outlined in ERC223.
369     * If tokens are deposited through depositToken(), the transaction will continue.
370     * If tokens are sent directly to this contract, the transaction is reverted.
371     * @param sender Ethereum address of the sender of the token
372     * @param amount amount of the incoming tokens
373     * @param data attached data similar to msg.data of Ether transactions
374     */
375     function tokenFallback(address sender, uint amount, bytes data) public returns (bool ok) {
376         if (depositingTokenFlag) {
377             // Transfer was initiated from depositToken(). User token balance will be updated there.
378             return true;
379         } else {
380             // Direct ECR223 Token.safeTransfer into this contract not allowed, to keep it consistent
381             // with direct transfers of ECR20 and ETH.
382             revert();
383         }
384     }
385 
386     /**
387     * This function handles withdrawals of Ethereum based tokens from the contract.
388     * Does not allow Ether.
389     * If token transfer fails, transaction is reverted and remaining gas is refunded.
390     * Emits a Withdraw event.
391     * @param token Ethereum contract address of the token or 0 for Ether
392     * @param amount uint of the amount of the token the user wishes to withdraw
393     */
394     function withdrawToken(address token, uint amount) {
395         if (token == 0) throw;
396         if (tokens[token][msg.sender] < amount) throw;
397         tokens[token][msg.sender] = SafeMath.sub(tokens[token][msg.sender], amount);
398         if (!IERC20(token).safeTransfer(msg.sender, amount)) throw;
399         Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
400     }
401 
402     /**
403     * Retrieves the balance of a token based on a user address and token address.
404     * @param token Ethereum contract address of the token or 0 for Ether
405     * @param user Ethereum address of the user
406     * @return the amount of tokens on the exchange for a given user address
407     */
408     function balanceOf(address token, address user) public constant returns (uint) {
409         return tokens[token][user];
410     }
411 
412     ////////////////////////////////////////////////////////////////////////////////
413     // Trading
414     ////////////////////////////////////////////////////////////////////////////////
415 
416     /**
417     * Stores the active order inside of the contract.
418     * Emits an Order event.
419     *
420     *
421     * Note: tokenGet & tokenGive can be the Ethereum contract address.
422     * @param tokenGet Ethereum contract address of the token to receive
423     * @param amountGet uint amount of tokens being received
424     * @param tokenGive Ethereum contract address of the token to give
425     * @param amountGive uint amount of tokens being given
426     * @param expires uint of block number when this order should expire
427     * @param nonce arbitrary random number
428     */
429     function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
430         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
431         uint amount;
432         orders[msg.sender][hash] = true;
433         Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, hash, amount);
434     }
435 
436     /**
437     * Facilitates a trade from one user to another.
438     * Requires that the transaction is signed properly, the trade isn't past its expiration, and all funds are present to fill the trade.
439     * Calls tradeBalances().
440     * Updates orderFills with the amount traded.
441     * Emits a Trade event.
442     * Note: tokenGet & tokenGive can be the Ethereum contract address.
443     * Note: amount is in amountGet / tokenGet terms.
444     * @param tokenGet Ethereum contract address of the token to receive
445     * @param amountGet uint amount of tokens being received
446     * @param tokenGive Ethereum contract address of the token to give
447     * @param amountGive uint amount of tokens being given
448     * @param expires uint of block number when this order should expire
449     * @param nonce arbitrary random number
450     * @param user Ethereum address of the user who placed the order
451     * @param v part of signature for the order hash as signed by user
452     * @param r part of signature for the order hash as signed by user
453     * @param s part of signature for the order hash as signed by user
454     * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
455     */
456     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
457         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
458         require((
459             (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
460             block.number <= expires &&
461             SafeMath.add(orderFills[user][hash], amount) <= amountGet
462             ));
463         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
464         orderFills[user][hash] = SafeMath.add(orderFills[user][hash], amount);
465         Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender, now);
466     }
467 
468     /**
469     * This is a private function and is only being called from trade().
470     * Handles the movement of funds when a trade occurs.
471     * Takes fees.
472     * Updates token balances for both buyer and seller.
473     * Note: tokenGet & tokenGive can be the Ethereum contract address.
474     * Note: amount is in amountGet / tokenGet terms.
475     * @param tokenGet Ethereum contract address of the token to receive
476     * @param amountGet uint amount of tokens being received
477     * @param tokenGive Ethereum contract address of the token to give
478     * @param amountGive uint amount of tokens being given
479     * @param user Ethereum address of the user who placed the order
480     * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
481     */
482     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
483         if (tokenGet == FicAddress || tokenGive == FicAddress) {
484             tokens[tokenGet][msg.sender] = SafeMath.sub(tokens[tokenGet][msg.sender], amount);
485             tokens[tokenGet][user] = SafeMath.add(tokens[tokenGet][user], SafeMath.mul(amount, ((1 ether) - feeTakeMakerFic)) / (1 ether));
486             tokens[tokenGet][feeAccount] = SafeMath.add(tokens[tokenGet][feeAccount], SafeMath.mul(amount, feeTakeMakerFic) / (1 ether));
487             tokens[tokenGive][user] = SafeMath.sub(tokens[tokenGive][user], SafeMath.mul(amountGive, amount) / amountGet);
488             tokens[tokenGive][msg.sender] = SafeMath.add(tokens[tokenGive][msg.sender], SafeMath.mul(SafeMath.mul(((1 ether) - feeTakeSenderFic), amountGive), amount) / amountGet / (1 ether));
489             tokens[tokenGive][feeAccount] = SafeMath.add(tokens[tokenGive][feeAccount], SafeMath.mul(SafeMath.mul(feeTakeSenderFic, amountGive), amount) / amountGet / (1 ether));
490         }
491         else {
492             tokens[tokenGet][msg.sender] = SafeMath.sub(tokens[tokenGet][msg.sender], amount);
493             tokens[tokenGet][user] = SafeMath.add(tokens[tokenGet][user], SafeMath.mul(amount, ((1 ether) - feeTakeMaker)) / (1 ether));
494             tokens[tokenGet][feeAccount] = SafeMath.add(tokens[tokenGet][feeAccount], SafeMath.mul(amount, feeTakeMaker) / (1 ether));
495             tokens[tokenGive][user] = SafeMath.sub(tokens[tokenGive][user], SafeMath.mul(amountGive, amount) / amountGet);
496             tokens[tokenGive][msg.sender] = SafeMath.add(tokens[tokenGive][msg.sender], SafeMath.mul(SafeMath.mul(((1 ether) - feeTakeSender), amountGive), amount) / amountGet / (1 ether));
497             tokens[tokenGive][feeAccount] = SafeMath.add(tokens[tokenGive][feeAccount], SafeMath.mul(SafeMath.mul(feeTakeSender, amountGive), amount) / amountGet / (1 ether));
498         }
499     }
500 
501     /**
502     * This function is to test if a trade would go through.
503     * Note: tokenGet & tokenGive can be the Ethereum contract address.
504     * Note: amount is in amountGet / tokenGet terms.
505     * @param tokenGet Ethereum contract address of the token to receive
506     * @param amountGet uint amount of tokens being received
507     * @param tokenGive Ethereum contract address of the token to give
508     * @param amountGive uint amount of tokens being given
509     * @param expires uint of block number when this order should expire
510     * @param nonce arbitrary random number
511     * @param user Ethereum address of the user who placed the order
512     * @param v part of signature for the order hash as signed by user
513     * @param r part of signature for the order hash as signed by user
514     * @param s part of signature for the order hash as signed by user
515     * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
516     * @param sender Ethereum address of the user taking the order
517     * @return bool: true if the trade would be successful, false otherwise
518     */
519     function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns (bool) {
520         if (!(
521         tokens[tokenGet][sender] >= amount &&
522         availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
523         )) {
524             return false;
525         } else {
526             return true;
527         }
528     }
529 
530     /**
531     * This function checks the available volume for a given order.
532     * Note: tokenGet & tokenGive can be the Ethereum contract address.
533     * @param tokenGet Ethereum contract address of the token to receive
534     * @param amountGet uint amount of tokens being received
535     * @param tokenGive Ethereum contract address of the token to give
536     * @param amountGive uint amount of tokens being given
537     * @param expires uint of block number when this order should expire
538     * @param nonce arbitrary random number
539     * @param user Ethereum address of the user who placed the order
540     * @param v part of signature for the order hash as signed by user
541     * @param r part of signature for the order hash as signed by user
542     * @param s part of signature for the order hash as signed by user
543     * @return uint: amount of volume available for the given order in terms of amountGet / tokenGet
544     */
545     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns (uint) {
546         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
547         if (!(
548         (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
549         block.number <= expires
550         )) {
551             return 0;
552         }
553         uint[2] memory available;
554         available[0] = SafeMath.sub(amountGet, orderFills[user][hash]);
555         available[1] = SafeMath.mul(tokens[tokenGive][user], amountGet) / amountGive;
556         if (available[0] < available[1]) {
557             return available[0];
558         } else {
559             return available[1];
560         }
561     }
562 
563     /**
564     * This function checks the amount of an order that has already been filled.
565     * Note: tokenGet & tokenGive can be the Ethereum contract address.
566     * @param tokenGet Ethereum contract address of the token to receive
567     * @param amountGet uint amount of tokens being received
568     * @param tokenGive Ethereum contract address of the token to give
569     * @param amountGive uint amount of tokens being given
570     * @param expires uint of block number when this order should expire
571     * @param nonce arbitrary random number
572     * @param user Ethereum address of the user who placed the order
573     * @param v part of signature for the order hash as signed by user
574     * @param r part of signature for the order hash as signed by user
575     * @param s part of signature for the order hash as signed by user
576     * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
577     */
578     function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns (uint) {
579         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
580         return orderFills[user][hash];
581     }
582 
583     /**
584     * This function cancels a given order by editing its fill data to the full amount.
585     * Requires that the transaction is signed properly.
586     * Updates orderFills to the full amountGet
587     * Emits a Cancel event.
588     * Note: tokenGet & tokenGive can be the Ethereum contract address.
589     * @param tokenGet Ethereum contract address of the token to receive
590     * @param amountGet uint amount of tokens being received
591     * @param tokenGive Ethereum contract address of the token to give
592     * @param amountGive uint amount of tokens being given
593     * @param expires uint of block number when this order should expire
594     * @param nonce arbitrary random number
595     * @param v part of signature for the order hash as signed by user
596     * @param r part of signature for the order hash as signed by user
597     * @param s part of signature for the order hash as signed by user
598     * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
599     */
600     function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
601         bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
602         require((orders[msg.sender][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == msg.sender));
603         orderFills[msg.sender][hash] = amountGet;
604         Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
605     }
606 
607 
608 
609     ////////////////////////////////////////////////////////////////////////////////
610     // Contract Versioning / Migration
611     ////////////////////////////////////////////////////////////////////////////////
612 
613     /**
614     * User triggered function to migrate funds into a new contract to ease updates.
615     * Emits a FundsMigrated event.
616     * @param newContract Contract address of the new contract we are migrating funds to
617     * @param tokens_ Array of token addresses that we will be migrating to the new contract
618     */
619     function migrateFunds(address newContract, address[] tokens_) public {
620 
621         require(newContract != address(0));
622 
623         SEEDDEX newExchange = SEEDDEX(newContract);
624 
625         // Move Ether into new exchange.
626         uint etherAmount = tokens[0][msg.sender];
627         if (etherAmount > 0) {
628             tokens[0][msg.sender] = 0;
629             newExchange.depositForUser.value(etherAmount)(msg.sender);
630         }
631 
632         // Move Tokens into new exchange.
633         for (uint16 n = 0; n < tokens_.length; n++) {
634             address token = tokens_[n];
635             require(token != address(0));
636             // Ether is handled above.
637             uint tokenAmount = tokens[token][msg.sender];
638 
639             if (tokenAmount != 0) {
640                 if (!IERC20(token).safeApprove(newExchange, tokenAmount)) throw;
641                 tokens[token][msg.sender] = 0;
642                 newExchange.depositTokenForUser(token, tokenAmount, msg.sender);
643             }
644         }
645 
646         FundsMigrated(msg.sender, newContract);
647     }
648 
649 
650     /**
651     * This function handles deposits of Ether into the contract, but allows specification of a user.
652     * Note: This is generally used in migration of funds.
653     * Note: With the payable modifier, this function accepts Ether.
654     */
655     function depositForUser(address user) public payable {
656         require(user != address(0));
657         require(msg.value > 0);
658         tokens[0][user] = SafeMath.add(tokens[0][user], (msg.value));
659     }
660 
661     /**
662     * This function handles deposits of Ethereum based tokens into the contract, but allows specification of a user.
663     * Does not allow Ether.
664     * If token transfer fails, transaction is reverted and remaining gas is refunded.
665     * Note: This is generally used in migration of funds.
666     * Note: Remember to call Token(address).safeApprove(this, amount) or this contract will not be able to do the transfer on your behalf.
667     * @param token Ethereum contract address of the token
668     * @param amount uint of the amount of the token the user wishes to deposit
669     */
670     function depositTokenForUser(address token, uint amount, address user) public {
671         require(token != address(0));
672         require(user != address(0));
673         require(amount > 0);
674         depositingTokenFlag = true;
675         if (!IERC20(token).safeTransferFrom(msg.sender, this, amount)) throw;
676         depositingTokenFlag = false;
677         tokens[token][user] = SafeMath.add(tokens[token][user], (amount));
678     }
679 }