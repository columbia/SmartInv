1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: contracts\SeedDex.sol
105 
106 /**
107  * @title SeedDex
108  * @dev This is the main contract for the SeedDex exchange.
109  */
110 contract SeedDex {
111   
112   using SafeMath for uint;
113 
114   /// Variables
115 
116   address public admin; // the admin address
117   address constant public FicAddress = 0x0DD83B5013b2ad7094b1A7783d96ae0168f82621;  // Florafic token address
118   address public manager; // the manager address
119   address public feeAccount; // the account that will receive fees
120   uint public feeTakeMaker; // For Maker fee x% *10^18
121   uint public feeTakeSender; // For Sender fee x% *10^18
122   uint public feeTakeMakerFic;
123   uint public feeTakeSenderFic;
124   bool private depositingTokenFlag; // True when Token.transferFrom is being called from depositToken
125   mapping (address => mapping (address => uint)) public tokens; // mapping of token addresses to mapping of account balances (token=0 means Ether)
126   mapping (address => mapping (bytes32 => bool)) public orders; // mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
127   mapping (address => mapping (bytes32 => uint)) public orderFills; // mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
128   address public predecessor; // Address of the previous version of this contract. If address(0), this is the first version
129   address public successor; // Address of the next version of this contract. If address(0), this is the most up to date version.
130   uint16 public version; // This is the version # of the contract
131 
132   /// Logging Events
133   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address indexed user,bytes32 hash,uint amount);
134   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address indexed user, uint8 v, bytes32 r, bytes32 s);
135   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give, uint256 timestamp);
136   event Deposit(address token, address indexed user, uint amount, uint balance);
137   event Withdraw(address token, address indexed user, uint amount, uint balance);
138   event FundsMigrated(address indexed user, address newContract);
139   event LogEvent(string msg,bytes32 data);
140 
141   /// This is a modifier for functions to check if the sending user address is the same as the admin user address.
142   modifier isAdmin() {
143       require(msg.sender == admin);
144       _;
145   }
146 
147   /// this is manager can only change feeTakeMaker feeTakeMaker and change manager address (accept only Ethereum address)
148   modifier isManager() {
149      require(msg.sender == manager || msg.sender == admin );
150       _;
151   }
152     
153   /// Constructor function. This is only called on contract creation.
154   function SeedDex(address admin_, address manager_, address feeAccount_, uint feeTakeMaker_, uint feeTakeSender_,  uint feeTakeMakerFic_, uint feeTakeSenderFic_,  address predecessor_) public {
155     admin = admin_;
156     manager = manager_;
157     feeAccount = feeAccount_;
158     feeTakeMaker = feeTakeMaker_;
159     feeTakeSender = feeTakeSender_;
160     feeTakeMakerFic = feeTakeMakerFic_;
161     feeTakeSenderFic = feeTakeSenderFic_;
162     depositingTokenFlag = false;
163     predecessor = predecessor_;
164     
165     if (predecessor != address(0)) {
166       version = SeedDex(predecessor).version() + 1;
167     } else {
168       version = 1;
169     }
170   }
171 
172   /// The fallback function. Ether transfered into the contract is not accepted.
173   function() public {
174     revert();
175   }
176 
177   /// Changes the official admin user address. Accepts Ethereum address.
178   function changeAdmin(address admin_) public isAdmin {
179     require(admin_ != address(0));
180     admin = admin_;
181   }
182 
183  /// Changes the manager user address. Accepts Ethereum address.
184   function changeManager(address manager_) public isManager {
185     require(manager_ != address(0));
186     manager = manager_;
187   }
188 
189   /// Changes the account address that receives trading fees. Accepts Ethereum address.
190   function changeFeeAccount(address feeAccount_) public isAdmin {
191     feeAccount = feeAccount_;
192   }
193 
194 /// Changes the fee on takes. Can only be changed to a value less than it is currently set at.
195   function changeFeeTakeMaker(uint feeTakeMaker_) public isManager {
196     feeTakeMaker = feeTakeMaker_;
197   }
198   
199   function changeFeeTakeSender(uint feeTakeSender_) public isManager {
200     feeTakeSender = feeTakeSender_;
201   }
202 
203   function changeFeeTakeMakerFic(uint feeTakeMakerFic_) public isManager {
204     feeTakeMakerFic = feeTakeMakerFic_;
205   }
206   
207   function changeFeeTakeSenderFic(uint feeTakeSenderFic_) public isManager {
208     feeTakeSenderFic = feeTakeSenderFic_;
209   }
210   
211   /// Changes the successor. Used in updating the contract.
212   function setSuccessor(address successor_) public isAdmin {
213     require(successor_ != address(0));
214     successor = successor_;
215   }
216   
217   ////////////////////////////////////////////////////////////////////////////////
218   // Deposits, Withdrawals, Balances
219   ////////////////////////////////////////////////////////////////////////////////
220 
221   /**
222   * This function handles deposits of Ether into the contract.
223   * Emits a Deposit event.
224   * Note: With the payable modifier, this function accepts Ether.
225   */
226   function deposit() public payable {
227     tokens[0][msg.sender] = tokens[0][msg.sender].add(msg.value);
228     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
229   }
230 
231   /**
232   * This function handles withdrawals of Ether from the contract.
233   * Verifies that the user has enough funds to cover the withdrawal.
234   * Emits a Withdraw event.
235   * @param amount uint of the amount of Ether the user wishes to withdraw
236   */
237   function withdraw(uint amount) public {
238     require(tokens[0][msg.sender] >= amount);
239     tokens[0][msg.sender] = tokens[0][msg.sender].sub(amount);
240     msg.sender.transfer(amount);
241     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
242   }
243 
244   /**
245   * This function handles deposits of Ethereum based tokens to the contract.
246   * Does not allow Ether.
247   * If token transfer fails, transaction is reverted and remaining gas is refunded.
248   * Emits a Deposit event.
249   * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
250   * @param token Ethereum contract address of the token or 0 for Ether
251   * @param amount uint of the amount of the token the user wishes to deposit
252   */
253   function depositToken(address token, uint amount) public {
254     require(token != 0);
255     depositingTokenFlag = true;
256     require(IERC20(token).transferFrom(msg.sender, this, amount));
257     depositingTokenFlag = false;
258     tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);
259     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
260  }
261 
262   /**
263   * This function provides a fallback solution as outlined in ERC223.
264   * If tokens are deposited through depositToken(), the transaction will continue.
265   * If tokens are sent directly to this contract, the transaction is reverted.
266   * @param sender Ethereum address of the sender of the token
267   * @param amount amount of the incoming tokens
268   * @param data attached data similar to msg.data of Ether transactions
269   */
270   function tokenFallback( address sender, uint amount, bytes data) public returns (bool ok) {
271       if (depositingTokenFlag) {
272         // Transfer was initiated from depositToken(). User token balance will be updated there.
273         return true;
274       } else {
275         // Direct ECR223 Token.transfer into this contract not allowed, to keep it consistent
276         // with direct transfers of ECR20 and ETH.
277         revert();
278       }
279   }
280   
281   /**
282   * This function handles withdrawals of Ethereum based tokens from the contract.
283   * Does not allow Ether.
284   * If token transfer fails, transaction is reverted and remaining gas is refunded.
285   * Emits a Withdraw event.
286   * @param token Ethereum contract address of the token or 0 for Ether
287   * @param amount uint of the amount of the token the user wishes to withdraw
288   */
289   function withdrawToken(address token, uint amount) public {
290     require(token != 0);
291     require(tokens[token][msg.sender] >= amount);
292     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
293     require(IERC20(token).transfer(msg.sender, amount));
294     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
295   }
296 
297   /**
298   * Retrieves the balance of a token based on a user address and token address.
299   * @param token Ethereum contract address of the token or 0 for Ether
300   * @param user Ethereum address of the user
301   * @return the amount of tokens on the exchange for a given user address
302   */
303   function balanceOf(address token, address user) public constant returns (uint) {
304     return tokens[token][user];
305   }
306 
307   ////////////////////////////////////////////////////////////////////////////////
308   // Trading
309   ////////////////////////////////////////////////////////////////////////////////
310 
311   /**
312   * Stores the active order inside of the contract.
313   * Emits an Order event.
314   * 
315   * 
316   * Note: tokenGet & tokenGive can be the Ethereum contract address.
317   * @param tokenGet Ethereum contract address of the token to receive
318   * @param amountGet uint amount of tokens being received
319   * @param tokenGive Ethereum contract address of the token to give
320   * @param amountGive uint amount of tokens being given
321   * @param expires uint of block number when this order should expire
322   * @param nonce arbitrary random number
323   */
324   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
325     bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
326     uint amount;
327     orders[msg.sender][hash] = true;
328     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, hash, amount);
329   }
330 
331   /**
332   * Facilitates a trade from one user to another.
333   * Requires that the transaction is signed properly, the trade isn't past its expiration, and all funds are present to fill the trade.
334   * Calls tradeBalances().
335   * Updates orderFills with the amount traded.
336   * Emits a Trade event.
337   * Note: tokenGet & tokenGive can be the Ethereum contract address.
338   * Note: amount is in amountGet / tokenGet terms.
339   * @param tokenGet Ethereum contract address of the token to receive
340   * @param amountGet uint amount of tokens being received
341   * @param tokenGive Ethereum contract address of the token to give
342   * @param amountGive uint amount of tokens being given
343   * @param expires uint of block number when this order should expire
344   * @param nonce arbitrary random number
345   * @param user Ethereum address of the user who placed the order
346   * @param v part of signature for the order hash as signed by user
347   * @param r part of signature for the order hash as signed by user
348   * @param s part of signature for the order hash as signed by user
349   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
350   */
351   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
352     bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
353     require((
354       (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
355       block.number <= expires &&
356       orderFills[user][hash].add(amount) <= amountGet
357     ));
358     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
359     orderFills[user][hash] = orderFills[user][hash].add(amount);
360     Trade(tokenGet, amount, tokenGive, amountGive.mul(amount) / amountGet, user, msg.sender,now);
361   }
362   
363   /**
364   * This is a private function and is only being called from trade().
365   * Handles the movement of funds when a trade occurs.
366   * Takes fees.
367   * Updates token balances for both buyer and seller.
368   * Note: tokenGet & tokenGive can be the Ethereum contract address.
369   * Note: amount is in amountGet / tokenGet terms.
370   * @param tokenGet Ethereum contract address of the token to receive
371   * @param amountGet uint amount of tokens being received
372   * @param tokenGive Ethereum contract address of the token to give
373   * @param amountGive uint amount of tokens being given
374   * @param user Ethereum address of the user who placed the order
375   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
376   */
377   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
378     
379     uint feeTakeXferM = 0;
380     uint feeTakeXferS = 0;
381     uint feeTakeXferFicM = 0;
382     uint feeTakeXferFicS = 0;
383     
384     feeTakeXferM = amount.mul(feeTakeMaker).div(1 ether);
385     feeTakeXferS = amount.mul(feeTakeSender).div(1 ether);
386     feeTakeXferFicM = amount.mul(feeTakeMakerFic).div(1 ether);
387     feeTakeXferFicS = amount.mul(feeTakeSenderFic).div(1 ether);
388     
389     
390     
391     if (tokenGet == FicAddress || tokenGive == FicAddress) {
392     tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXferFicS));
393     tokens[tokenGet][user] = tokens[tokenGet][user].add(amount.sub(feeTakeXferFicM));
394     tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeTakeXferFicM);
395     tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeTakeXferFicS);
396     }
397   
398     else {
399     tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXferS));
400     tokens[tokenGet][user] = tokens[tokenGet][user].add(amount.sub(feeTakeXferM));
401     tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeTakeXferM);
402     tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeTakeXferS);
403     }
404     
405     tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount).div(amountGet));
406     tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount).div(amountGet));
407   
408   }
409 
410   /**
411   * This function is to test if a trade would go through.
412   * Note: tokenGet & tokenGive can be the Ethereum contract address.
413   * Note: amount is in amountGet / tokenGet terms.
414   * @param tokenGet Ethereum contract address of the token to receive
415   * @param amountGet uint amount of tokens being received
416   * @param tokenGive Ethereum contract address of the token to give
417   * @param amountGive uint amount of tokens being given
418   * @param expires uint of block number when this order should expire
419   * @param nonce arbitrary random number
420   * @param user Ethereum address of the user who placed the order
421   * @param v part of signature for the order hash as signed by user
422   * @param r part of signature for the order hash as signed by user
423   * @param s part of signature for the order hash as signed by user
424   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
425   * @param sender Ethereum address of the user taking the order
426   * @return bool: true if the trade would be successful, false otherwise
427   */
428   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {
429     if (!(
430       tokens[tokenGet][sender] >= amount &&
431       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
432       )) { 
433       return false;
434     } else {
435       return true;
436     }
437   }
438 
439   /**
440   * This function checks the available volume for a given order.
441   * Note: tokenGet & tokenGive can be the Ethereum contract address.
442   * @param tokenGet Ethereum contract address of the token to receive
443   * @param amountGet uint amount of tokens being received
444   * @param tokenGive Ethereum contract address of the token to give
445   * @param amountGive uint amount of tokens being given
446   * @param expires uint of block number when this order should expire
447   * @param nonce arbitrary random number
448   * @param user Ethereum address of the user who placed the order
449   * @param v part of signature for the order hash as signed by user
450   * @param r part of signature for the order hash as signed by user
451   * @param s part of signature for the order hash as signed by user
452   * @return uint: amount of volume available for the given order in terms of amountGet / tokenGet
453   */
454   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
455     bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
456     if (!(
457       (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
458       block.number <= expires
459       )) {
460       return 0;
461     }
462     uint[2] memory available;
463     available[0] = amountGet.sub(orderFills[user][hash]);
464     available[1] = tokens[tokenGive][user].mul(amountGet) / amountGive;
465     if (available[0] < available[1]) {
466       return available[0];
467     } else {
468       return available[1];
469     }
470   }
471 
472   /**
473   * This function checks the amount of an order that has already been filled.
474   * Note: tokenGet & tokenGive can be the Ethereum contract address.
475   * @param tokenGet Ethereum contract address of the token to receive
476   * @param amountGet uint amount of tokens being received
477   * @param tokenGive Ethereum contract address of the token to give
478   * @param amountGive uint amount of tokens being given
479   * @param expires uint of block number when this order should expire
480   * @param nonce arbitrary random number
481   * @param user Ethereum address of the user who placed the order
482   * @param v part of signature for the order hash as signed by user
483   * @param r part of signature for the order hash as signed by user
484   * @param s part of signature for the order hash as signed by user
485   * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
486   */
487   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
488     bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
489     return orderFills[user][hash];
490   }
491 
492   /**
493   * This function cancels a given order by editing its fill data to the full amount.
494   * Requires that the transaction is signed properly.
495   * Updates orderFills to the full amountGet
496   * Emits a Cancel event.
497   * Note: tokenGet & tokenGive can be the Ethereum contract address.
498   * @param tokenGet Ethereum contract address of the token to receive
499   * @param amountGet uint amount of tokens being received
500   * @param tokenGive Ethereum contract address of the token to give
501   * @param amountGive uint amount of tokens being given
502   * @param expires uint of block number when this order should expire
503   * @param nonce arbitrary random number
504   * @param v part of signature for the order hash as signed by user
505   * @param r part of signature for the order hash as signed by user
506   * @param s part of signature for the order hash as signed by user
507   * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
508   */
509   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
510     bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
511     require ((orders[msg.sender][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == msg.sender));
512     orderFills[msg.sender][hash] = amountGet;
513     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
514   }
515 
516 
517   
518   ////////////////////////////////////////////////////////////////////////////////
519   // Contract Versioning / Migration
520   ////////////////////////////////////////////////////////////////////////////////
521   
522   /**
523   * User triggered function to migrate funds into a new contract to ease updates.
524   * Emits a FundsMigrated event.
525   * @param newContract Contract address of the new contract we are migrating funds to
526   * @param tokens_ Array of token addresses that we will be migrating to the new contract
527   */
528   function migrateFunds(address newContract, address[] tokens_) public {
529   
530     require(newContract != address(0));
531     
532     SeedDex newExchange = SeedDex(newContract);
533 
534     // Move Ether into new exchange.
535     uint etherAmount = tokens[0][msg.sender];
536     if (etherAmount > 0) {
537       tokens[0][msg.sender] = 0;
538       newExchange.depositForUser.value(etherAmount)(msg.sender);
539     }
540 
541     // Move Tokens into new exchange.
542     for (uint16 n = 0; n < tokens_.length; n++) {
543       address token = tokens_[n];
544       require(token != address(0)); // Ether is handled above.
545       uint tokenAmount = tokens[token][msg.sender];
546       
547       if (tokenAmount != 0) {      
548         require(IERC20(token).approve(newExchange, tokenAmount));
549         tokens[token][msg.sender] = 0;
550         newExchange.depositTokenForUser(token, tokenAmount, msg.sender);
551       }
552     }
553 
554     FundsMigrated(msg.sender, newContract);
555   }
556   
557   /**
558   * This function handles deposits of Ether into the contract, but allows specification of a user.
559   * Note: This is generally used in migration of funds.
560   * Note: With the payable modifier, this function accepts Ether.
561   */
562   function depositForUser(address user) public payable {
563     require(user != address(0));
564     require(msg.value > 0);
565     tokens[0][user] = tokens[0][user].add(msg.value);
566   }
567   
568   /**
569   * This function handles deposits of Ethereum based tokens into the contract, but allows specification of a user.
570   * Does not allow Ether.
571   * If token transfer fails, transaction is reverted and remaining gas is refunded.
572   * Note: This is generally used in migration of funds.
573   * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
574   * @param token Ethereum contract address of the token
575   * @param amount uint of the amount of the token the user wishes to deposit
576   */
577   function depositTokenForUser(address token, uint amount, address user) public {
578     require(token != address(0));
579     require(user != address(0));
580     require(amount > 0);
581     depositingTokenFlag = true;
582     require(IERC20(token).transferFrom(msg.sender, this, amount));
583     depositingTokenFlag = false;
584     tokens[token][user] = tokens[token][user].add(amount);
585   }
586   function checkshash (address tokenGet) public{
587       bytes32 hash = keccak256(tokenGet);
588       LogEvent('hash',hash);
589   }
590 }