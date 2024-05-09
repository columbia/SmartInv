1 pragma solidity ^0.4.19;
2 
3 // File: contracts/IToken.sol
4 
5 /**
6  * @title Token
7  * @dev Token interface necessary for working with tokens within the exchange contract.
8  */
9 contract IToken {
10   /// @return total amount of tokens
11   function totalSupply() public constant returns (uint256 supply) {}
12 
13   /// @param _owner The address from which the balance will be retrieved
14   /// @return The balance
15   function balanceOf(address _owner) public constant returns (uint256 balance) {}
16 
17   /// @notice send `_value` token to `_to` from `msg.sender`
18   /// @param _to The address of the recipient
19   /// @param _value The amount of token to be transferred
20   /// @return Whether the transfer was successful or not
21   function transfer(address _to, uint256 _value) public returns (bool success) {}
22 
23   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24   /// @param _from The address of the sender
25   /// @param _to The address of the recipient
26   /// @param _value The amount of token to be transferred
27   /// @return Whether the transfer was successful or not
28   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
29 
30   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31   /// @param _spender The address of the account able to transfer the tokens
32   /// @param _value The amount of wei to be approved for transfer
33   /// @return Whether the approval was successful or not
34   function approve(address _spender, uint256 _value) public returns (bool success) {}
35 
36   /// @param _owner The address of the account owning tokens
37   /// @param _spender The address of the account able to transfer the tokens
38   /// @return Amount of remaining tokens allowed to spent
39   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
40 
41   event Transfer(address indexed _from, address indexed _to, uint256 _value);
42   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44   uint public decimals;
45   string public name;
46 }
47 
48 // File: contracts/LSafeMath.sol
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that throw on error
53  */
54 library LSafeMath {
55 
56   /**
57   * @dev Multiplies two numbers, throws on overflow.
58   */
59   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60     if (a == 0) {
61       return 0;
62     }
63     uint256 c = a * b;
64     require(c / a == b);
65     return c;
66   }
67 
68   /**
69   * @dev Integer division of two numbers, truncating the quotient.
70   */
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     require(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   /**
79   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
80   */
81   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82     require(b <= a);
83     return a - b;
84   }
85 
86   /**
87   * @dev Adds two numbers, throws on overflow.
88   */
89   function add(uint256 a, uint256 b) internal pure returns (uint256) {
90     uint256 c = a + b;
91     require(c >= a);
92     return c;
93   }
94 }
95 
96 // File: contracts/MarketPlace.sol
97 
98 /**
99  * @title Z
100  * @dev This is the main contract for the MarketPlace exchange.
101  */
102 contract MarketPlace {
103 
104   using LSafeMath for uint;
105 
106   /// Variables
107   address public admin; // the admin address
108   address public feeAccount; // the account that will receive fees
109   uint public feeTake; // percentage times (1 ether)
110   uint public freeUntilDate; // date in UNIX timestamp that trades will be free until
111   bool private depositingTokenFlag; // True when Token.transferFrom is being called from depositToken
112   mapping (address => mapping (address => uint)) public tokens; // mapping of token addresses to mapping of account balances (token=0 means Ether)
113   mapping (address => mapping (bytes32 => bool)) public orders; // mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
114   mapping (address => mapping (bytes32 => uint)) public orderFills; // mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
115   address public predecessor; // Address of the previous version of this contract. If address(0), this is the first version
116   address public successor; // Address of the next version of this contract. If address(0), this is the most up to date version.
117   uint16 public version; // This is the version # of the contract
118 
119   /// Logging Events
120   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
121   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
122   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
123   event Deposit(address token, address user, uint amount, uint balance);
124   event Withdraw(address token, address user, uint amount, uint balance);
125   event FundsMigrated(address user, address newContract);
126 
127   /// This is a modifier for functions to check if the sending user address is the same as the admin user address.
128   modifier isAdmin() {
129       require(msg.sender == admin);
130       _;
131   }
132 
133   /// Constructor function. This is only called on contract creation.
134   function MarketPlace(address admin_, address feeAccount_, uint feeTake_, uint freeUntilDate_, address predecessor_) public {
135     admin = admin_;
136     feeAccount = feeAccount_;
137     feeTake = feeTake_;
138     freeUntilDate = freeUntilDate_;
139     depositingTokenFlag = false;
140     predecessor = predecessor_;
141 
142     if (predecessor != address(0)) {
143       version = MarketPlace(predecessor).version() + 1;
144     } else {
145       version = 1;
146     }
147   }
148 
149   /// The fallback function. Ether transfered into the contract is not accepted.
150   function() public {
151     revert();
152   }
153 
154   /// Changes the official admin user address. Accepts Ethereum address.
155   function changeAdmin(address admin_) public isAdmin {
156     require(admin_ != address(0));
157     admin = admin_;
158   }
159 
160   /// Changes the account address that receives trading fees. Accepts Ethereum address.
161   function changeFeeAccount(address feeAccount_) public isAdmin {
162     feeAccount = feeAccount_;
163   }
164 
165   /// Changes the fee on takes. Can only be changed to a value less than it is currently set at.
166   function changeFeeTake(uint feeTake_) public isAdmin {
167     require(feeTake_ <= feeTake);
168     feeTake = feeTake_;
169   }
170 
171   /// Changes the date that trades are free until. Accepts UNIX timestamp.
172   function changeFreeUntilDate(uint freeUntilDate_) public isAdmin {
173     freeUntilDate = freeUntilDate_;
174   }
175 
176   /// Changes the successor. Used in updating the contract.
177   function setSuccessor(address successor_) public isAdmin {
178     require(successor_ != address(0));
179     successor = successor_;
180   }
181 
182   ////////////////////////////////////////////////////////////////////////////////
183   // Deposits, Withdrawals, Balances
184   ////////////////////////////////////////////////////////////////////////////////
185 
186   /**
187   * This function handles deposits of Ether into the contract.
188   * Emits a Deposit event.
189   * Note: With the payable modifier, this function accepts Ether.
190   */
191   function deposit() public payable {
192     tokens[0][msg.sender] = tokens[0][msg.sender].add(msg.value);
193     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
194   }
195 
196   /**
197   * This function handles withdrawals of Ether from the contract.
198   * Verifies that the user has enough funds to cover the withdrawal.
199   * Emits a Withdraw event.
200   * @param amount uint of the amount of Ether the user wishes to withdraw
201   */
202   function withdraw(uint amount) public {
203     require(tokens[0][msg.sender] >= amount);
204     tokens[0][msg.sender] = tokens[0][msg.sender].sub(amount);
205     msg.sender.transfer(amount);
206     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
207   }
208 
209   /**
210   * This function handles deposits of Ethereum based tokens to the contract.
211   * Does not allow Ether.
212   * If token transfer fails, transaction is reverted and remaining gas is refunded.
213   * Emits a Deposit event.
214   * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
215   * @param token Ethereum contract address of the token or 0 for Ether
216   * @param amount uint of the amount of the token the user wishes to deposit
217   */
218   function depositToken(address token, uint amount) public {
219     require(token != 0);
220     depositingTokenFlag = true;
221     require(IToken(token).transferFrom(msg.sender, this, amount));
222     depositingTokenFlag = false;
223     tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);
224     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
225  }
226 
227   /**
228   * This function provides a fallback solution as outlined in ERC223.
229   * If tokens are deposited through depositToken(), the transaction will continue.
230   * If tokens are sent directly to this contract, the transaction is reverted.
231   * @param sender Ethereum address of the sender of the token
232   * @param amount amount of the incoming tokens
233   * @param data attached data similar to msg.data of Ether transactions
234   */
235   function tokenFallback( address sender, uint amount, bytes data) public returns (bool ok) {
236       if (depositingTokenFlag) {
237         // Transfer was initiated from depositToken(). User token balance will be updated there.
238         return true;
239       } else {
240         // Direct ECR223 Token.transfer into this contract not allowed, to keep it consistent
241         // with direct transfers of ECR20 and ETH.
242         revert();
243       }
244   }
245 
246   /**
247   * This function handles withdrawals of Ethereum based tokens from the contract.
248   * Does not allow Ether.
249   * If token transfer fails, transaction is reverted and remaining gas is refunded.
250   * Emits a Withdraw event.
251   * @param token Ethereum contract address of the token or 0 for Ether
252   * @param amount uint of the amount of the token the user wishes to withdraw
253   */
254   function withdrawToken(address token, uint amount) public {
255     require(token != 0);
256     require(tokens[token][msg.sender] >= amount);
257     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
258     require(IToken(token).transfer(msg.sender, amount));
259     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
260   }
261 
262   /**
263   * Retrieves the balance of a token based on a user address and token address.
264   * @param token Ethereum contract address of the token or 0 for Ether
265   * @param user Ethereum address of the user
266   * @return the amount of tokens on the exchange for a given user address
267   */
268   function balanceOf(address token, address user) public constant returns (uint) {
269     return tokens[token][user];
270   }
271 
272   ////////////////////////////////////////////////////////////////////////////////
273   // Trading
274   ////////////////////////////////////////////////////////////////////////////////
275 
276   /**
277   * Stores the active order inside of the contract.
278   * Emits an Order event.
279   * Note: tokenGet & tokenGive can be the Ethereum contract address.
280   * @param tokenGet Ethereum contract address of the token to receive
281   * @param amountGet uint amount of tokens being received
282   * @param tokenGive Ethereum contract address of the token to give
283   * @param amountGive uint amount of tokens being given
284   * @param expires uint of block number when this order should expire
285   * @param nonce arbitrary random number
286   */
287   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
288     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
289     orders[msg.sender][hash] = true;
290     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
291   }
292 
293   /**
294   * Facilitates a trade from one user to another.
295   * Requires that the transaction is signed properly, the trade isn't past its expiration, and all funds are present to fill the trade.
296   * Calls tradeBalances().
297   * Updates orderFills with the amount traded.
298   * Emits a Trade event.
299   * Note: tokenGet & tokenGive can be the Ethereum contract address.
300   * Note: amount is in amountGet / tokenGet terms.
301   * @param tokenGet Ethereum contract address of the token to receive
302   * @param amountGet uint amount of tokens being received
303   * @param tokenGive Ethereum contract address of the token to give
304   * @param amountGive uint amount of tokens being given
305   * @param expires uint of block number when this order should expire
306   * @param nonce arbitrary random number
307   * @param user Ethereum address of the user who placed the order
308   * @param v part of signature for the order hash as signed by user
309   * @param r part of signature for the order hash as signed by user
310   * @param s part of signature for the order hash as signed by user
311   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
312   */
313   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
314     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
315     require((
316       (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
317       block.number <= expires &&
318       orderFills[user][hash].add(amount) <= amountGet
319     ));
320     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
321     orderFills[user][hash] = orderFills[user][hash].add(amount);
322     Trade(tokenGet, amount, tokenGive, amountGive.mul(amount) / amountGet, user, msg.sender);
323   }
324 
325   /**
326   * This is a private function and is only being called from trade().
327   * Handles the movement of funds when a trade occurs.
328   * Takes fees.
329   * Updates token balances for both buyer and seller.
330   * Note: tokenGet & tokenGive can be the Ethereum contract address.
331   * Note: amount is in amountGet / tokenGet terms.
332   * @param tokenGet Ethereum contract address of the token to receive
333   * @param amountGet uint amount of tokens being received
334   * @param tokenGive Ethereum contract address of the token to give
335   * @param amountGive uint amount of tokens being given
336   * @param user Ethereum address of the user who placed the order
337   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
338   */
339   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
340 
341     uint feeTakeXfer = 0;
342 
343     if (now >= freeUntilDate) {
344       feeTakeXfer = amount.mul(feeTake).div(1 ether);
345     }
346 
347     tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXfer));
348     tokens[tokenGet][user] = tokens[tokenGet][user].add(amount);
349     tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeTakeXfer);
350     tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount).div(amountGet));
351     tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount).div(amountGet));
352   }
353 
354   /**
355   * This function is to test if a trade would go through.
356   * Note: tokenGet & tokenGive can be the Ethereum contract address.
357   * Note: amount is in amountGet / tokenGet terms.
358   * @param tokenGet Ethereum contract address of the token to receive
359   * @param amountGet uint amount of tokens being received
360   * @param tokenGive Ethereum contract address of the token to give
361   * @param amountGive uint amount of tokens being given
362   * @param expires uint of block number when this order should expire
363   * @param nonce arbitrary random number
364   * @param user Ethereum address of the user who placed the order
365   * @param v part of signature for the order hash as signed by user
366   * @param r part of signature for the order hash as signed by user
367   * @param s part of signature for the order hash as signed by user
368   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
369   * @param sender Ethereum address of the user taking the order
370   * @return bool: true if the trade would be successful, false otherwise
371   */
372   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {
373     if (!(
374       tokens[tokenGet][sender] >= amount &&
375       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
376       )) {
377       return false;
378     } else {
379       return true;
380     }
381   }
382 
383   /**
384   * This function checks the available volume for a given order.
385   * Note: tokenGet & tokenGive can be the Ethereum contract address.
386   * @param tokenGet Ethereum contract address of the token to receive
387   * @param amountGet uint amount of tokens being received
388   * @param tokenGive Ethereum contract address of the token to give
389   * @param amountGive uint amount of tokens being given
390   * @param expires uint of block number when this order should expire
391   * @param nonce arbitrary random number
392   * @param user Ethereum address of the user who placed the order
393   * @param v part of signature for the order hash as signed by user
394   * @param r part of signature for the order hash as signed by user
395   * @param s part of signature for the order hash as signed by user
396   * @return uint: amount of volume available for the given order in terms of amountGet / tokenGet
397   */
398   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
399     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
400     if (!(
401       (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
402       block.number <= expires
403       )) {
404       return 0;
405     }
406     uint[2] memory available;
407     available[0] = amountGet.sub(orderFills[user][hash]);
408     available[1] = tokens[tokenGive][user].mul(amountGet) / amountGive;
409     if (available[0] < available[1]) {
410       return available[0];
411     } else {
412       return available[1];
413     }
414   }
415 
416   /**
417   * This function checks the amount of an order that has already been filled.
418   * Note: tokenGet & tokenGive can be the Ethereum contract address.
419   * @param tokenGet Ethereum contract address of the token to receive
420   * @param amountGet uint amount of tokens being received
421   * @param tokenGive Ethereum contract address of the token to give
422   * @param amountGive uint amount of tokens being given
423   * @param expires uint of block number when this order should expire
424   * @param nonce arbitrary random number
425   * @param user Ethereum address of the user who placed the order
426   * @param v part of signature for the order hash as signed by user
427   * @param r part of signature for the order hash as signed by user
428   * @param s part of signature for the order hash as signed by user
429   * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
430   */
431   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
432     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
433     return orderFills[user][hash];
434   }
435 
436   /**
437   * This function cancels a given order by editing its fill data to the full amount.
438   * Requires that the transaction is signed properly.
439   * Updates orderFills to the full amountGet
440   * Emits a Cancel event.
441   * Note: tokenGet & tokenGive can be the Ethereum contract address.
442   * @param tokenGet Ethereum contract address of the token to receive
443   * @param amountGet uint amount of tokens being received
444   * @param tokenGive Ethereum contract address of the token to give
445   * @param amountGive uint amount of tokens being given
446   * @param expires uint of block number when this order should expire
447   * @param nonce arbitrary random number
448   * @param v part of signature for the order hash as signed by user
449   * @param r part of signature for the order hash as signed by user
450   * @param s part of signature for the order hash as signed by user
451   * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
452   */
453   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
454     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
455     require ((orders[msg.sender][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == msg.sender));
456     orderFills[msg.sender][hash] = amountGet;
457     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
458   }
459 
460 
461 
462   ////////////////////////////////////////////////////////////////////////////////
463   // Contract Versioning / Migration
464   ////////////////////////////////////////////////////////////////////////////////
465 
466   /**
467   * User triggered function to migrate funds into a new contract to ease updates.
468   * Emits a FundsMigrated event.
469   * @param newContract Contract address of the new contract we are migrating funds to
470   * @param tokens_ Array of token addresses that we will be migrating to the new contract
471   */
472   function migrateFunds(address newContract, address[] tokens_) public {
473 
474     require(newContract != address(0));
475 
476     MarketPlace newExchange = MarketPlace(newContract);
477 
478     // Move Ether into new exchange.
479     uint etherAmount = tokens[0][msg.sender];
480     if (etherAmount > 0) {
481       tokens[0][msg.sender] = 0;
482       newExchange.depositForUser.value(etherAmount)(msg.sender);
483     }
484 
485     // Move Tokens into new exchange.
486     for (uint16 n = 0; n < tokens_.length; n++) {
487       address token = tokens_[n];
488       require(token != address(0)); // Ether is handled above.
489       uint tokenAmount = tokens[token][msg.sender];
490 
491       if (tokenAmount != 0) {
492       	require(IToken(token).approve(newExchange, tokenAmount));
493       	tokens[token][msg.sender] = 0;
494       	newExchange.depositTokenForUser(token, tokenAmount, msg.sender);
495       }
496     }
497 
498     FundsMigrated(msg.sender, newContract);
499   }
500 
501   /**
502   * This function handles deposits of Ether into the contract, but allows specification of a user.
503   * Note: This is generally used in migration of funds.
504   * Note: With the payable modifier, this function accepts Ether.
505   */
506   function depositForUser(address user) public payable {
507     require(user != address(0));
508     require(msg.value > 0);
509     tokens[0][user] = tokens[0][user].add(msg.value);
510   }
511 
512   /**
513   * This function handles deposits of Ethereum based tokens into the contract, but allows specification of a user.
514   * Does not allow Ether.
515   * If token transfer fails, transaction is reverted and remaining gas is refunded.
516   * Note: This is generally used in migration of funds.
517   * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
518   * @param token Ethereum contract address of the token
519   * @param amount uint of the amount of the token the user wishes to deposit
520   */
521   function depositTokenForUser(address token, uint amount, address user) public {
522     require(token != address(0));
523     require(user != address(0));
524     require(amount > 0);
525     depositingTokenFlag = true;
526     require(IToken(token).transferFrom(msg.sender, this, amount));
527     depositingTokenFlag = false;
528     tokens[token][user] = tokens[token][user].add(amount);
529   }
530 
531 }