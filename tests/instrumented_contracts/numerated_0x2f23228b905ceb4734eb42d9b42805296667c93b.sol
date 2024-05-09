1 pragma solidity ^0.4.23;
2 pragma solidity ^0.4.17;
3 
4 
5 /**
6  * @title Token
7  * @dev Token interface necessary for working with tokens within the exchange contract.
8  */
9 contract IToken {
10     /// @return total amount of tokens
11     function totalSupply() public constant returns (uint256 supply);
12 
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance
15     function balanceOf(address _owner) public constant returns (uint256 balance);
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) public returns (bool success);
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29 
30     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of wei to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) public returns (bool success);
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44     uint public decimals;
45     string public name;
46 }
47 
48 pragma solidity ^0.4.17;
49 
50 
51 /**
52  * @title SafeMath
53  * @dev Math operations with safety checks that throw on error
54  */
55 library LSafeMath {
56 
57     uint256 constant WAD = 1 ether;
58     
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63         uint256 c = a * b;
64         if (c / a == b)
65             return c;
66         revert();
67     }
68     
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (b > 0) { 
71             uint256 c = a / b;
72             return c;
73         }
74         revert();
75     }
76     
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (b <= a)
79             return a - b;
80         revert();
81     }
82     
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         if (c >= a) 
86             return c;
87         revert();
88     }
89 
90     function wmul(uint a, uint b) internal pure returns (uint256) {
91         return add(mul(a, b), WAD / 2) / WAD;
92     }
93 
94     function wdiv(uint a, uint b) internal pure returns (uint256) {
95         return add(mul(a, WAD), b / 2) / b;
96     }
97 }
98 
99 /**
100  * @title Coinchangex
101  * @dev This is the main contract for the Coinchangex exchange.
102  */
103 contract Coinchangex {
104   
105   using LSafeMath for uint;
106   
107   struct SpecialTokenBalanceFeeTake {
108       bool exist;
109       address token;
110       uint256 balance;
111       uint256 feeTake;
112   }
113   
114   uint constant private MAX_SPECIALS = 10;
115 
116   /// Variables
117   address public admin; // the admin address
118   address public feeAccount; // the account that will receive fees
119   uint public feeTake; // percentage times (1 ether)
120   bool private depositingTokenFlag; // True when Token.transferFrom is being called from depositToken
121   mapping (address => mapping (address => uint)) public tokens; // mapping of token addresses to mapping of account balances (token=0 means Ether)
122   mapping (address => mapping (bytes32 => uint)) public orderFills; // mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
123   SpecialTokenBalanceFeeTake[] public specialFees;
124   
125 
126   /// Logging Events
127   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
128   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
129   event Deposit(address token, address user, uint amount, uint balance);
130   event Withdraw(address token, address user, uint amount, uint balance);
131 
132   /// This is a modifier for functions to check if the sending user address is the same as the admin user address.
133   modifier isAdmin() {
134       require(msg.sender == admin);
135       _;
136   }
137 
138   /// Constructor function. This is only called on contract creation.
139   function Coinchangex(address admin_, address feeAccount_, uint feeTake_) public {
140     admin = admin_;
141     feeAccount = feeAccount_;
142     feeTake = feeTake_;
143     depositingTokenFlag = false;
144   }
145 
146   /// The fallback function. Ether transfered into the contract is not accepted.
147   function() public {
148     revert();
149   }
150 
151   /// Changes the official admin user address. Accepts Ethereum address.
152   function changeAdmin(address admin_) public isAdmin {
153     require(admin_ != address(0));
154     admin = admin_;
155   }
156 
157   /// Changes the account address that receives trading fees. Accepts Ethereum address.
158   function changeFeeAccount(address feeAccount_) public isAdmin {
159     feeAccount = feeAccount_;
160   }
161 
162   /// Changes the fee on takes. Can only be changed to a value less than it is currently set at.
163   function changeFeeTake(uint feeTake_) public isAdmin {
164     // require(feeTake_ <= feeTake);
165     feeTake = feeTake_;
166   }
167   
168   // add special promotion fee
169   function addSpecialFeeTake(address token, uint256 balance, uint256 feeTake) public isAdmin {
170       uint id = specialFees.push(SpecialTokenBalanceFeeTake(
171           true,
172           token,
173           balance,
174           feeTake
175       ));
176   }
177   
178   // chnage special promotion fee
179   function chnageSpecialFeeTake(uint id, address token, uint256 balance, uint256 feeTake) public isAdmin {
180       require(id < specialFees.length);
181       specialFees[id] = SpecialTokenBalanceFeeTake(
182           true,
183           token,
184           balance,
185           feeTake
186       );
187   }
188   
189     // remove special promotion fee
190    function removeSpecialFeeTake(uint id) public isAdmin {
191        if (id >= specialFees.length) revert();
192 
193         uint last = specialFees.length-1;
194         for (uint i = id; i<last; i++){
195             specialFees[i] = specialFees[i+1];
196         }
197         
198         delete specialFees[last];
199         specialFees.length--;
200   } 
201   
202   //return total count promotion fees
203   function TotalSpecialFeeTakes() public constant returns(uint)  {
204       return specialFees.length;
205   }
206   
207   
208   ////////////////////////////////////////////////////////////////////////////////
209   // Deposits, Withdrawals, Balances
210   ////////////////////////////////////////////////////////////////////////////////
211 
212   /**
213   * This function handles deposits of Ether into the contract.
214   * Emits a Deposit event.
215   * Note: With the payable modifier, this function accepts Ether.
216   */
217   function deposit() public payable {
218     tokens[0][msg.sender] = tokens[0][msg.sender].add(msg.value);
219     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
220   }
221 
222   /**
223   * This function handles withdrawals of Ether from the contract.
224   * Verifies that the user has enough funds to cover the withdrawal.
225   * Emits a Withdraw event.
226   * @param amount uint of the amount of Ether the user wishes to withdraw
227   */
228   function withdraw(uint amount) public {
229     require(tokens[0][msg.sender] >= amount);
230     tokens[0][msg.sender] = tokens[0][msg.sender].sub(amount);
231     msg.sender.transfer(amount);
232     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
233   }
234 
235   /**
236   * This function handles deposits of Ethereum based tokens to the contract.
237   * Does not allow Ether.
238   * If token transfer fails, transaction is reverted and remaining gas is refunded.
239   * Emits a Deposit event.
240   * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
241   * @param token Ethereum contract address of the token or 0 for Ether
242   * @param amount uint of the amount of the token the user wishes to deposit
243   */
244   function depositToken(address token, uint amount) public {
245     require(token != 0);
246     depositingTokenFlag = true;
247     require(IToken(token).transferFrom(msg.sender, this, amount));
248     depositingTokenFlag = false;
249     tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);
250     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
251  }
252 
253   /**
254   * This function provides a fallback solution as outlined in ERC223.
255   * If tokens are deposited through depositToken(), the transaction will continue.
256   * If tokens are sent directly to this contract, the transaction is reverted.
257   * @param sender Ethereum address of the sender of the token
258   * @param amount amount of the incoming tokens
259   * @param data attached data similar to msg.data of Ether transactions
260   */
261   function tokenFallback( address sender, uint amount, bytes data) public returns (bool ok) {
262       if (depositingTokenFlag) {
263         // Transfer was initiated from depositToken(). User token balance will be updated there.
264         return true;
265       } else {
266         // Direct ECR223 Token.transfer into this contract not allowed, to keep it consistent
267         // with direct transfers of ECR20 and ETH.
268         revert();
269       }
270   }
271   
272   /**
273   * This function handles withdrawals of Ethereum based tokens from the contract.
274   * Does not allow Ether.
275   * If token transfer fails, transaction is reverted and remaining gas is refunded.
276   * Emits a Withdraw event.
277   * @param token Ethereum contract address of the token or 0 for Ether
278   * @param amount uint of the amount of the token the user wishes to withdraw
279   */
280   function withdrawToken(address token, uint amount) public {
281     require(token != 0);
282     require(tokens[token][msg.sender] >= amount);
283     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
284     require(IToken(token).transfer(msg.sender, amount));
285     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
286   }
287 
288   /**
289   * Retrieves the balance of a token based on a user address and token address.
290   * @param token Ethereum contract address of the token or 0 for Ether
291   * @param user Ethereum address of the user
292   * @return the amount of tokens on the exchange for a given user address
293   */
294   function balanceOf(address token, address user) public constant returns (uint) {
295     return tokens[token][user];
296   }
297 
298   ////////////////////////////////////////////////////////////////////////////////
299   // Trading
300   ////////////////////////////////////////////////////////////////////////////////
301 
302   /**
303   * Facilitates a trade from one user to another.
304   * Requires that the transaction is signed properly, the trade isn't past its expiration, and all funds are present to fill the trade.
305   * Calls tradeBalances().
306   * Updates orderFills with the amount traded.
307   * Emits a Trade event.
308   * Note: tokenGet & tokenGive can be the Ethereum contract address.
309   * Note: amount is in amountGet / tokenGet terms.
310   * @param tokenGet Ethereum contract address of the token to receive
311   * @param amountGet uint amount of tokens being received
312   * @param tokenGive Ethereum contract address of the token to give
313   * @param amountGive uint amount of tokens being given
314   * @param expires uint of block number when this order should expire
315   * @param nonce arbitrary random number
316   * @param user Ethereum address of the user who placed the order
317   * @param v part of signature for the order hash as signed by user
318   * @param r part of signature for the order hash as signed by user
319   * @param s part of signature for the order hash as signed by user
320   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
321   */
322   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
323     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
324     require((
325       (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
326       block.number <= expires &&
327       orderFills[user][hash].add(amount) <= amountGet
328     ));
329     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
330     orderFills[user][hash] = orderFills[user][hash].add(amount);
331     Trade(tokenGet, amount, tokenGive, amountGive.mul(amount) / amountGet, user, msg.sender);
332   }
333 
334   /**
335   * This is a private function and is only being called from trade().
336   * Handles the movement of funds when a trade occurs.
337   * Takes fees.
338   * Updates token balances for both buyer and seller.
339   * Note: tokenGet & tokenGive can be the Ethereum contract address.
340   * Note: amount is in amountGet / tokenGet terms.
341   * @param tokenGet Ethereum contract address of the token to receive
342   * @param amountGet uint amount of tokens being received
343   * @param tokenGive Ethereum contract address of the token to give
344   * @param amountGive uint amount of tokens being given
345   * @param user Ethereum address of the user who placed the order
346   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
347   */
348   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
349     
350     uint256 feeTakeXfer = calculateFee(amount);
351     
352     tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXfer));
353     tokens[tokenGet][user] = tokens[tokenGet][user].add(amount);
354     tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeTakeXfer);
355     tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount).div(amountGet));
356     tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount).div(amountGet));
357   }
358   
359   //calculate fee including special promotions
360   function calculateFee(uint amount) private constant returns(uint256)  {
361     uint256 feeTakeXfer = 0;
362     
363     uint length = specialFees.length;
364     bool applied = false;
365     for(uint i = 0; length > 0 && i < length; i++) {
366         SpecialTokenBalanceFeeTake memory special = specialFees[i];
367         if(special.exist && special.balance <= tokens[special.token][msg.sender]) {
368             applied = true;
369             feeTakeXfer = amount.mul(special.feeTake).div(1 ether);
370             break;
371         }
372         if(i >= MAX_SPECIALS)
373             break;
374     }
375     
376     if(!applied)
377         feeTakeXfer = amount.mul(feeTake).div(1 ether);
378     
379     
380     return feeTakeXfer;
381   }
382 
383   /**
384   * This function is to test if a trade would go through.
385   * Note: tokenGet & tokenGive can be the Ethereum contract address.
386   * Note: amount is in amountGet / tokenGet terms.
387   * @param tokenGet Ethereum contract address of the token to receive
388   * @param amountGet uint amount of tokens being received
389   * @param tokenGive Ethereum contract address of the token to give
390   * @param amountGive uint amount of tokens being given
391   * @param expires uint of block number when this order should expire
392   * @param nonce arbitrary random number
393   * @param user Ethereum address of the user who placed the order
394   * @param v part of signature for the order hash as signed by user
395   * @param r part of signature for the order hash as signed by user
396   * @param s part of signature for the order hash as signed by user
397   * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
398   * @param sender Ethereum address of the user taking the order
399   * @return bool: true if the trade would be successful, false otherwise
400   */
401   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {
402     if (!(
403       tokens[tokenGet][sender] >= amount &&
404       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
405       )) { 
406       return false;
407     } else {
408       return true;
409     }
410   }
411 
412   /**
413   * This function checks the available volume for a given order.
414   * Note: tokenGet & tokenGive can be the Ethereum contract address.
415   * @param tokenGet Ethereum contract address of the token to receive
416   * @param amountGet uint amount of tokens being received
417   * @param tokenGive Ethereum contract address of the token to give
418   * @param amountGive uint amount of tokens being given
419   * @param expires uint of block number when this order should expire
420   * @param nonce arbitrary random number
421   * @param user Ethereum address of the user who placed the order
422   * @param v part of signature for the order hash as signed by user
423   * @param r part of signature for the order hash as signed by user
424   * @param s part of signature for the order hash as signed by user
425   * @return uint: amount of volume available for the given order in terms of amountGet / tokenGet
426   */
427   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
428     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
429     if (!(
430       (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user) &&
431       block.number <= expires
432       )) {
433       return 0;
434     }
435     uint[2] memory available;
436     available[0] = amountGet.sub(orderFills[user][hash]);
437     available[1] = tokens[tokenGive][user].mul(amountGet) / amountGive;
438     if (available[0] < available[1]) {
439       return available[0];
440     } else {
441       return available[1];
442     }
443   }
444 
445   /**
446   * This function checks the amount of an order that has already been filled.
447   * Note: tokenGet & tokenGive can be the Ethereum contract address.
448   * @param tokenGet Ethereum contract address of the token to receive
449   * @param amountGet uint amount of tokens being received
450   * @param tokenGive Ethereum contract address of the token to give
451   * @param amountGive uint amount of tokens being given
452   * @param expires uint of block number when this order should expire
453   * @param nonce arbitrary random number
454   * @param user Ethereum address of the user who placed the order
455   * @param v part of signature for the order hash as signed by user
456   * @param r part of signature for the order hash as signed by user
457   * @param s part of signature for the order hash as signed by user
458   * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
459   */
460   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
461     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
462     return orderFills[user][hash];
463   }
464 
465   /**
466   * This function cancels a given order by editing its fill data to the full amount.
467   * Requires that the transaction is signed properly.
468   * Updates orderFills to the full amountGet
469   * Emits a Cancel event.
470   * Note: tokenGet & tokenGive can be the Ethereum contract address.
471   * @param tokenGet Ethereum contract address of the token to receive
472   * @param amountGet uint amount of tokens being received
473   * @param tokenGive Ethereum contract address of the token to give
474   * @param amountGive uint amount of tokens being given
475   * @param expires uint of block number when this order should expire
476   * @param nonce arbitrary random number
477   * @param v part of signature for the order hash as signed by user
478   * @param r part of signature for the order hash as signed by user
479   * @param s part of signature for the order hash as signed by user
480   * @return uint: amount of the given order that has already been filled in terms of amountGet / tokenGet
481   */
482   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
483     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
484     require ((ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == msg.sender));
485     orderFills[msg.sender][hash] = amountGet;
486     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
487   }
488 
489   
490   /**
491   * This function handles deposits of Ether into the contract, but allows specification of a user.
492   * Note: This is generally used in migration of funds.
493   * Note: With the payable modifier, this function accepts Ether.
494   */
495   function depositForUser(address user) public payable {
496     require(user != address(0));
497     require(msg.value > 0);
498     tokens[0][user] = tokens[0][user].add(msg.value);
499   }
500   
501   /**
502   * This function handles deposits of Ethereum based tokens into the contract, but allows specification of a user.
503   * Does not allow Ether.
504   * If token transfer fails, transaction is reverted and remaining gas is refunded.
505   * Note: This is generally used in migration of funds.
506   * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
507   * @param token Ethereum contract address of the token
508   * @param amount uint of the amount of the token the user wishes to deposit
509   */
510   function depositTokenForUser(address token, uint amount, address user) public {
511     require(token != address(0));
512     require(user != address(0));
513     require(amount > 0);
514     depositingTokenFlag = true;
515     require(IToken(token).transferFrom(msg.sender, this, amount));
516     depositingTokenFlag = false;
517     tokens[token][user] = tokens[token][user].add(amount);
518   }
519   
520 }