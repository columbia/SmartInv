1 pragma solidity ^0.4.18;
2 
3 // File: contracts/AccountLevels.sol
4 
5 contract AccountLevels {
6   //given a user, returns an account level
7   //0 = regular user (pays take fee and make fee)
8   //1 = market maker silver (pays take fee, no make fee, gets rebate)
9   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
10   function accountLevel(address user) public constant returns(uint);
11 }
12 
13 // File: zeppelin-solidity/contracts/math/SafeMath.sol
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
62 
63 /**
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Basic {
69   function totalSupply() public view returns (uint256);
70   function balanceOf(address who) public view returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) public view returns (uint256);
83   function transferFrom(address from, address to, uint256 value) public returns (bool);
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // File: contracts/SwissCryptoExchange.sol
89 
90 /**
91  * @title SwissCryptoExchange
92  */
93 contract SwissCryptoExchange {
94   using SafeMath for uint256;
95 
96   // Storage definition.
97   address public admin; //the admin address
98   address public feeAccount; //the account that will receive fees
99   address public accountLevelsAddr; //the address of the AccountLevels contract
100   uint256 public feeMake; //percentage times (1 ether)
101   uint256 public feeTake; //percentage times (1 ether)
102   uint256 public feeRebate; //percentage times (1 ether)
103   mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
104   mapping (address => bool) public whitelistedTokens; //mapping of whitelisted token addresses (token=0 means Ether)
105   mapping (address => bool) public whitelistedUsers; // mapping of whitelisted users that can perform trading
106   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
107   mapping (address => mapping (bytes32 => uint256)) public orderFills; //mapping of user accounts to mapping of order hashes to uint256s (amount of order that has been filled)
108 
109   // Events definition.
110   event Order(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, uint256 expires, uint256 nonce, address user);
111   event Cancel(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
112   event Trade(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, address get, address give);
113   event Deposit(address token, address user, uint256 amount, uint256 balance);
114   event Withdraw(address token, address user, uint256 amount, uint256 balance);
115 
116   /**
117    * @dev Create a new instance of the SwissCryptoExchange contract.
118    * @param _admin             address Admin address
119    * @param _feeAccount        address Fee Account address
120    * @param _accountLevelsAddr address AccountLevels contract address
121    * @param _feeMake           uint256 FeeMake amount
122    * @param _feeTake           uint256 FeeTake amount
123    * @param _feeRebate         uint256 FeeRebate amount
124    */
125   function SwissCryptoExchange(
126     address _admin,
127     address _feeAccount,
128     address _accountLevelsAddr,
129     uint256 _feeMake,
130     uint256 _feeTake,
131     uint256 _feeRebate
132   )
133     public
134   {
135     // Ensure the admin address is valid.
136     require(_admin != 0x0);
137 
138     // Store the values.
139     admin = _admin;
140     feeAccount = _feeAccount;
141     accountLevelsAddr = _accountLevelsAddr;
142     feeMake = _feeMake;
143     feeTake = _feeTake;
144     feeRebate = _feeRebate;
145 
146     // Validate "ethereum address".
147     whitelistedTokens[0x0] = true;
148   }
149 
150   /**
151    * @dev Ensure the function caller is the contract admin.
152    */
153   modifier onlyAdmin() { 
154     require(msg.sender == admin);
155     _; 
156   }
157 
158   /**
159    * @dev The fallback function is not used for receiving money. If someone sends
160    *      wei directly to the contract address the transaction will fail.
161    */
162   function () public payable {
163     revert();
164   }
165 
166   /**
167    * @dev Change the admin address.
168    * @param _admin address The new admin address
169    */
170   function changeAdmin(address _admin) public onlyAdmin {
171     // The provided address should be valid and different from the current one.
172     require(_admin != 0x0 && admin != _admin);
173 
174     // Store the new value.
175     admin = _admin;
176   }
177 
178   /**
179    * @dev Change the AccountLevels contract address. This address could be set to 0x0
180    *      if the functionality is not needed.
181    * @param _accountLevelsAddr address The new AccountLevels contract address
182    */
183   function changeAccountLevelsAddr(address _accountLevelsAddr) public onlyAdmin {
184     // Store the new value.
185     accountLevelsAddr = _accountLevelsAddr;
186   }
187 
188   /**
189    * @dev Change the feeAccount address.
190    * @param _feeAccount address
191    */
192   function changeFeeAccount(address _feeAccount) public onlyAdmin {
193     // The provided address should be valid.
194     require(_feeAccount != 0x0);
195 
196     // Store the new value.
197     feeAccount = _feeAccount;
198   }
199 
200   /**
201    * @dev Change the feeMake amount.
202    * @param _feeMake uint256 New fee make.
203    */
204   function changeFeeMake(uint256 _feeMake) public onlyAdmin {
205     // Store the new value.
206     feeMake = _feeMake;
207   }
208 
209   /**
210    * @dev Change the feeTake amount.
211    * @param _feeTake uint256 New fee take.
212    */
213   function changeFeeTake(uint256 _feeTake) public onlyAdmin {
214     // The new feeTake should be greater than or equal to the feeRebate.
215     require(_feeTake >= feeRebate);
216 
217     // Store the new value.
218     feeTake = _feeTake;
219   }
220 
221   /**
222    * @dev Change the feeRebate amount.
223    * @param _feeRebate uint256 New fee rebate.
224    */
225   function changeFeeRebate(uint256 _feeRebate) public onlyAdmin {
226     // The new feeRebate should be less than or equal to the feeTake.
227     require(_feeRebate <= feeTake);
228 
229     // Store the new value.
230     feeRebate = _feeRebate;
231   }
232 
233   /**
234    * @dev Add a ERC20 token contract address to the whitelisted ones.
235    * @param token address Address of the contract to be added to the whitelist.
236    */
237   function addWhitelistedTokenAddr(address token) public onlyAdmin {
238     // Token address should not be 0x0 (ether) and it should not be already whitelisted.
239     require(token != 0x0 && !whitelistedTokens[token]);
240 
241     // Change the flag for this contract address to true.
242     whitelistedTokens[token] = true;
243   }
244 
245   /**
246    * @dev Remove a ERC20 token contract address from the whitelisted ones.
247    * @param token address Address of the contract to be removed from the whitelist.
248    */
249   function removeWhitelistedTokenAddr(address token) public onlyAdmin {
250     // Token address should not be 0x0 (ether) and it should be whitelisted.
251     require(token != 0x0 && whitelistedTokens[token]);
252 
253     // Change the flag for this contract address to false.
254     whitelistedTokens[token] = false;
255   }
256 
257   /**
258    * @dev Add an user address to the whitelisted ones.
259    * @param user address Address to be added to the whitelist.
260    */
261   function addWhitelistedUserAddr(address user) public onlyAdmin {
262     // Address provided should be valid and not already whitelisted.
263     require(user != 0x0 && !whitelistedUsers[user]);
264 
265     // Change the flag for this address to false.
266     whitelistedUsers[user] = true;
267   }
268 
269   /**
270    * @dev Remove an user address from the whitelisted ones.
271    * @param user address Address to be removed from the whitelist.
272    */
273   function removeWhitelistedUserAddr(address user) public onlyAdmin {
274     // Address provided should be valid and whitelisted.
275     require(user != 0x0 && whitelistedUsers[user]);
276 
277     // Change the flag for this address to false.
278     whitelistedUsers[user] = false;
279   }
280 
281   /**
282    * @dev Deposit wei into the exchange contract.
283    */
284   function deposit() public payable {
285     // Only whitelisted users can make deposits.
286     require(whitelistedUsers[msg.sender]);
287 
288     // Add the deposited wei amount to the user balance.
289     tokens[0x0][msg.sender] = tokens[0x0][msg.sender].add(msg.value);
290 
291     // Trigger the event.
292     Deposit(0x0, msg.sender, msg.value, tokens[0x0][msg.sender]);
293   }
294 
295   /**
296    * @dev Withdraw wei from the exchange contract back to the user. 
297    * @param amount uint256 Wei amount to be withdrawn.
298    */
299   function withdraw(uint256 amount) public {
300     // Requester should have enough balance.
301     require(tokens[0x0][msg.sender] >= amount);
302   
303     // Substract the withdrawn wei amount from the user balance.
304     tokens[0x0][msg.sender] = tokens[0x0][msg.sender].sub(amount);
305 
306     // Transfer the wei to the requester.
307     msg.sender.transfer(amount);
308 
309     // Trigger the event.
310     Withdraw(0x0, msg.sender, amount, tokens[0x0][msg.sender]);
311   }
312 
313   /**
314    * @dev Perform a new token deposit to the exchange contract.
315    * @dev Remember to call ERC20(address).approve(this, amount) or this contract will not
316    *      be able to do the transfer on your behalf.
317    * @param token  address Address of the deposited token contract
318    * @param amount uint256 Amount to be deposited
319    */
320   function depositToken(address token, uint256 amount)
321     public
322   {
323     // Should not deposit wei using this function and
324     // token contract address should be whitelisted.
325     require(token != 0x0 && whitelistedTokens[token]);
326       
327     // Only whitelisted users can make deposits.
328     require(whitelistedUsers[msg.sender]);
329 
330     // Add the deposited token amount to the user balance.
331     tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);
332     
333     // Transfer tokens from caller to this contract account.
334     require(ERC20(token).transferFrom(msg.sender, address(this), amount));
335   
336     // Trigger the event.    
337     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
338   }
339 
340   /**
341    * @dev Withdraw the given token amount from the requester balance.
342    * @param token  address Address of the withdrawn token contract
343    * @param amount uint256 Amount of tokens to be withdrawn
344    */
345   function withdrawToken(address token, uint256 amount) public {
346     // Should not withdraw wei using this function.
347     require(token != 0x0);
348 
349     // Requester should have enough balance.
350     require(tokens[token][msg.sender] >= amount);
351 
352     // Substract the withdrawn token amount from the user balance.
353     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
354     
355     // Transfer the tokens to the investor.
356     require(ERC20(token).transfer(msg.sender, amount));
357 
358     // Trigger the event.
359     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
360   }
361 
362   /**
363    * @dev Check the balance of the given user in the given token.
364    * @param token address Address of the token contract
365    * @param user  address Address of the user whom balance will be queried
366    */
367   function balanceOf(address token, address user)
368     public
369     constant
370     returns (uint256)
371   {
372     return tokens[token][user];
373   }
374 
375   /**
376    * @dev Place a new order to the this contract. 
377    * @param tokenGet   address
378    * @param amountGet  uint256
379    * @param tokenGive  address
380    * @param amountGive uint256
381    * @param expires    uint256
382    * @param nonce      uint256
383    */
384   function order(
385     address tokenGet,
386     uint256 amountGet,
387     address tokenGive,
388     uint256 amountGive,
389     uint256 expires,
390     uint256 nonce
391   )
392     public
393   {
394     // Order placer address should be whitelisted.
395     require(whitelistedUsers[msg.sender]);
396 
397     // Order tokens addresses should be whitelisted. 
398     require(whitelistedTokens[tokenGet] && whitelistedTokens[tokenGive]);
399 
400     // Calculate the order hash.
401     bytes32 hash = keccak256(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
402     
403     // Store the order.
404     orders[msg.sender][hash] = true;
405 
406     // Trigger the event.
407     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
408   }
409 
410   /**
411    * @dev Cancel an existing order.
412    * @param tokenGet   address
413    * @param amountGet  uint256
414    * @param tokenGive  address
415    * @param amountGive uint256
416    * @param expires    uint256
417    * @param nonce      uint256
418    * @param v          uint8
419    * @param r          bytes32
420    * @param s          bytes32
421    */
422   function cancelOrder(
423     address tokenGet,
424     uint256 amountGet,
425     address tokenGive,
426     uint256 amountGive,
427     uint256 expires,
428     uint256 nonce,
429     uint8 v,
430     bytes32 r,
431     bytes32 s
432   )
433     public
434   {
435     // Calculate the order hash.
436     bytes32 hash = keccak256(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
437     
438     // Ensure the message validity.
439     require(validateOrderHash(hash, msg.sender, v, r, s));
440     
441     // Fill the order to the requested amount.
442     orderFills[msg.sender][hash] = amountGet;
443 
444     // Trigger the event.
445     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
446   }
447 
448   /**
449    * @dev Perform a trade.
450    * @param tokenGet   address
451    * @param amountGet  uint256
452    * @param tokenGive  address
453    * @param amountGive uint256
454    * @param expires    uint256
455    * @param nonce      uint256
456    * @param user       address
457    * @param v          uint8
458    * @param r          bytes32
459    * @param s          bytes32
460    * @param amount     uint256 Traded amount - in amountGet terms
461    */
462   function trade(
463     address tokenGet,
464     uint256 amountGet,
465     address tokenGive,
466     uint256 amountGive,
467     uint256 expires,
468     uint256 nonce,
469     address user,
470     uint8 v,
471     bytes32 r,
472     bytes32 s,
473     uint256 amount 
474   )
475     public
476   {
477     // Only whitelisted users can perform trades.
478     require(whitelistedUsers[msg.sender]);
479 
480     // Only whitelisted tokens can be traded.
481     require(whitelistedTokens[tokenGet] && whitelistedTokens[tokenGive]);
482 
483     // Expire block number should be greater than current block.
484     require(block.number <= expires);
485 
486     // Calculate the trade hash.
487     bytes32 hash = keccak256(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
488     
489     // Validate the hash.
490     require(validateOrderHash(hash, user, v, r, s));
491 
492     // Ensure that after the trade the ordered amount will not be excedeed.
493     require(SafeMath.add(orderFills[user][hash], amount) <= amountGet); 
494     
495     // Add the traded amount to the order fill.
496     orderFills[user][hash] = orderFills[user][hash].add(amount);
497 
498     // Trade balances.
499     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
500     
501     // Trigger the event.
502     Trade(tokenGet, amount, tokenGive, SafeMath.mul(amountGive, amount).div(amountGet), user, msg.sender);
503   }
504 
505   /**
506    * @dev Check if the trade with provided parameters will pass or not.
507    * @param tokenGet   address
508    * @param amountGet  uint256
509    * @param tokenGive  address
510    * @param amountGive uint256
511    * @param expires    uint256
512    * @param nonce      uint256
513    * @param user       address
514    * @param v          uint8
515    * @param r          bytes32
516    * @param s          bytes32
517    * @param amount     uint256
518    * @param sender     address
519    * @return bool
520    */
521   function testTrade(
522     address tokenGet,
523     uint256 amountGet,
524     address tokenGive,
525     uint256 amountGive,
526     uint256 expires,
527     uint256 nonce,
528     address user,
529     uint8 v,
530     bytes32 r,
531     bytes32 s,
532     uint256 amount,
533     address sender
534   )
535     public
536     constant
537     returns(bool)
538   {
539     // Traders should be whitelisted.
540     require(whitelistedUsers[user] && whitelistedUsers[sender]);
541 
542     // Tokens should be whitelisted.
543     require(whitelistedTokens[tokenGet] && whitelistedTokens[tokenGive]);
544 
545     // Sender should have at least the amount he wants to trade and 
546     require(tokens[tokenGet][sender] >= amount);
547 
548     // order should have available volume to fill.
549     return availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount;
550   }
551 
552   /**
553    * @dev Calculate the available volume for a given trade.
554    * @param tokenGet   address
555    * @param amountGet  uint256
556    * @param tokenGive  address
557    * @param amountGive uint256
558    * @param expires    uint256
559    * @param nonce      uint256
560    * @param user       address
561    * @param v          uint8
562    * @param r          bytes32
563    * @param s          bytes32
564    * @return uint256
565    */
566   function availableVolume(
567     address tokenGet,
568     uint256 amountGet,
569     address tokenGive,
570     uint256 amountGive,
571     uint256 expires,
572     uint256 nonce,
573     address user,
574     uint8 v,
575     bytes32 r,
576     bytes32 s
577   )
578     public
579     constant
580     returns (uint256)
581   {
582     // User should be whitelisted.
583     require(whitelistedUsers[user]);
584 
585     // Tokens should be whitelisted.
586     require(whitelistedTokens[tokenGet] && whitelistedTokens[tokenGive]);
587 
588     // Calculate the hash.
589     bytes32 hash = keccak256(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
590 
591     // If the order is not valid or the trade is expired early exit with 0.
592     if (!(validateOrderHash(hash, user, v, r, s) && block.number <= expires)) {
593       return 0;
594     }
595 
596     // Condition is used for ensuring the the value returned is
597     //   - the maximum available balance of the user in tokenGet terms if the user can't fullfil all the order
598     //     - SafeMath.sub(amountGet, orderFills[user][hash])
599     //     - amountGet - amountAvailableForFill
600     //   - the available balance of the the user in tokenGet terms if the user has enough to fullfil all the order 
601     //     - SafeMath.mul(tokens[tokenGive][user], amountGet).div(amountGive) 
602     //     - balanceGiveAvailable * amountGet / amountGive
603     //     - amountGet / amountGive represents the exchange rate 
604     if (SafeMath.sub(amountGet, orderFills[user][hash]) < SafeMath.mul(tokens[tokenGive][user], amountGet).div(amountGive)) {
605       return SafeMath.sub(amountGet, orderFills[user][hash]);
606     }
607 
608     return SafeMath.mul(tokens[tokenGive][user], amountGet).div(amountGive);
609   }
610 
611   /**
612    * @dev Get the amount filled for the given order.
613    * @param tokenGet   address
614    * @param amountGet  uint256
615    * @param tokenGive  address
616    * @param amountGive uint256
617    * @param expires    uint256
618    * @param nonce      uint256
619    * @param user       address
620    * @return uint256
621    */
622   function amountFilled(
623     address tokenGet,
624     uint256 amountGet,
625     address tokenGive,
626     uint256 amountGive,
627     uint256 expires,
628     uint256 nonce,
629     address user
630   )
631     public
632     constant
633     returns (uint256)
634   {
635     // User should be whitelisted.
636     require(whitelistedUsers[user]);
637 
638     // Tokens should be whitelisted.
639     require(whitelistedTokens[tokenGet] && whitelistedTokens[tokenGive]);
640 
641     // Return the amount filled for the given order.
642     return orderFills[user][keccak256(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce)];
643   }
644 
645     /**
646    * @dev Trade balances of given tokens amounts between two users.
647    * @param tokenGet   address
648    * @param amountGet  uint256
649    * @param tokenGive  address
650    * @param amountGive uint256
651    * @param user       address
652    * @param amount     uint256
653    */
654   function tradeBalances(
655     address tokenGet,
656     uint256 amountGet,
657     address tokenGive,
658     uint256 amountGive,
659     address user,
660     uint256 amount
661   )
662     private
663   {
664     // Calculate the constant taxes.
665     uint256 feeMakeXfer = amount.mul(feeMake).div(1 ether);
666     uint256 feeTakeXfer = amount.mul(feeTake).div(1 ether);
667     uint256 feeRebateXfer = 0;
668     
669     // Calculate the tax according to account level.
670     if (accountLevelsAddr != 0x0) {
671       uint256 accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
672       if (accountLevel == 1) {
673         feeRebateXfer = amount.mul(feeRebate).div(1 ether);
674       } else if (accountLevel == 2) {
675         feeRebateXfer = feeTakeXfer;
676       }
677     }
678 
679     // Update the balances for both maker and taker and add the fee to the feeAccount.
680     tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXfer));
681     tokens[tokenGet][user] = tokens[tokenGet][user].add(amount.add(feeRebateXfer).sub(feeMakeXfer));
682     tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeMakeXfer.add(feeTakeXfer).sub(feeRebateXfer));
683     tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount).div(amountGet));
684     tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount).div(amountGet));
685   }
686 
687   /**
688    * @dev Validate an order hash.
689    * @param hash bytes32
690    * @param user address
691    * @param v    uint8
692    * @param r    bytes32
693    * @param s    bytes32
694    * @return bool
695    */
696   function validateOrderHash(
697     bytes32 hash,
698     address user,
699     uint8 v,
700     bytes32 r,
701     bytes32 s
702   )
703     private
704     constant
705     returns (bool)
706   {
707     return (
708       orders[user][hash] ||
709       ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user
710     );
711   }
712 }