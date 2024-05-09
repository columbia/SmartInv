1 pragma solidity 0.4.19;
2 
3 /*
4 
5   Copyright 2018 EasyTrade.
6 
7   Licensed under the Apache License, Version 2.0 (the "License");
8   you may not use this file except in compliance with the License.
9   You may obtain a copy of the License at
10 
11     http://www.apache.org/licenses/LICENSE-2.0
12 
13   Unless required by applicable law or agreed to in writing, software
14   distributed under the License is distributed on an "AS IS" BASIS,
15   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
16   See the License for the specific language governing permissions and
17   limitations under the License.
18 
19 */
20 
21 contract Token {
22     
23     /// @param _owner The address from which the balance will be retrieved
24     /// @return The balance
25     function balanceOf(address _owner) constant returns (uint balance) {}
26     
27     /// @notice send `_value` token to `_to` from `msg.sender`
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transfer(address _to, uint _value) public returns (bool success) {}
32 
33     /// @param _from The address of the sender
34     /// @param _to The address of the recipient
35     /// @param _value The amount of token to be transferred
36     /// @return Whether the transfer was successful or not
37     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {}
38 
39     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @param _value The amount of wei to be approved for transfer
42     /// @return Whether the approval was successful or not
43     function approve(address _spender, uint _value) public returns (bool success) {}
44     
45     /// @param _owner The address of the account owning tokens
46     /// @param _spender The address of the account able to transfer the tokens
47     /// @return Amount of remaining tokens allowed to spent
48     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
49 }
50 
51 library SafeMath {
52     
53     function safeMul(uint a, uint b) internal constant returns (uint256) {
54         uint c = a * b;
55         assert(a == 0 || c / a == b);
56         return c;
57     }
58 
59     function safeDiv(uint a, uint b) internal constant returns (uint256) {
60         uint c = a / b;
61         return c;
62     }
63 
64     function safeSub(uint a, uint b) internal constant returns (uint256) {
65         assert(b <= a);
66         return a - b;
67     }
68 
69     function safeAdd(uint a, uint b) internal constant returns (uint256) {
70         uint c = a + b;
71         assert(c >= a);
72         return c;
73     }
74 
75     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
76         return a < b ? a : b;
77     }
78 }
79 
80 contract EtherToken is Token {
81 
82     /// @dev Buys tokens with Ether, exchanging them 1:1.
83     function deposit()
84         public
85         payable
86     {}
87 
88     /// @dev Sells tokens in exchange for Ether, exchanging them 1:1.
89     /// @param amount Number of tokens to sell.
90     function withdraw(uint amount)
91         public
92     {}
93 }
94 
95 contract Exchange {
96 
97     /// @dev Fills the input order.
98     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
99     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
100     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
101     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfer will fail before attempting.
102     /// @param v ECDSA signature parameter v.
103     /// @param r ECDSA signature parameters r.
104     /// @param s ECDSA signature parameters s.
105     /// @return Total amount of takerToken filled in trade.
106     function fillOrder(
107           address[5] orderAddresses,
108           uint[6] orderValues,
109           uint fillTakerTokenAmount,
110           bool shouldThrowOnInsufficientBalanceOrAllowance,
111           uint8 v,
112           bytes32 r,
113           bytes32 s)
114           public
115           returns (uint filledTakerTokenAmount)
116     {}
117 
118     /*
119     * Constant public functions
120     */
121     
122     /// @dev Calculates Keccak-256 hash of order with specified parameters.
123     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
124     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
125     /// @return Keccak-256 hash of order.
126     function getOrderHash(address[5] orderAddresses, uint[6] orderValues)
127         public
128         constant
129         returns (bytes32)
130     {}
131     
132      
133     /// @dev Calculates the sum of values already filled and cancelled for a given order.
134     /// @param orderHash The Keccak-256 hash of the given order.
135     /// @return Sum of values already filled and cancelled.
136     function getUnavailableTakerTokenAmount(bytes32 orderHash)
137         public
138         constant
139         returns (uint)
140     {}
141 }
142 
143 contract EtherDelta {
144   address public feeAccount; //the account that will receive fees
145   uint public feeTake; //percentage times (1 ether)
146   
147   function deposit() public payable {}
148 
149   function withdraw(uint amount) public {}
150 
151   function depositToken(address token, uint amount) public {}
152 
153   function withdrawToken(address token, uint amount) public {}
154 
155   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {}
156 
157   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
158 }
159 
160 library EtherDeltaTrader {
161 
162   address constant public ETHERDELTA_ADDR = 0x8d12a197cb00d4747a1fe03395095ce2a5cc6819; // EtherDelta contract address
163   
164   /// @dev Gets the address of EtherDelta contract
165   /// @return Address of EtherDelta Contract.
166   function getEtherDeltaAddresss() internal returns(address) {
167       return ETHERDELTA_ADDR;
168   }
169    
170   /// @dev Fills a sell order in EtherDelta.
171   /// @param orderAddresses Array of order's maker, makerToken, takerToken.
172   /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, expires and nonce.
173   /// @param exchangeFee Fee percentage of the exchange.
174   /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
175   /// @param v ECDSA signature parameter v.
176   /// @param r ECDSA signature parameters r.
177   /// @param s ECDSA signature parameters s.
178   /// @return Total amount of takerToken filled in trade
179   function fillSellOrder(
180     address[5] orderAddresses,
181     uint[6] orderValues,
182     uint exchangeFee,
183     uint fillTakerTokenAmount,
184     uint8 v,
185     bytes32 r,
186     bytes32 s
187   ) internal returns(uint) {
188     
189     //Deposit ethers in EtherDelta
190     deposit(fillTakerTokenAmount);
191     
192     uint amountToTrade;
193     uint fee;
194       
195     //Substract EtherDelta fee
196     (amountToTrade, fee) = substractFee(exchangeFee, fillTakerTokenAmount);
197     
198     //Fill EtherDelta Order
199     trade(
200       orderAddresses,
201       orderValues, 
202       amountToTrade,
203       v, 
204       r, 
205       s
206     );
207     
208     //Withdraw token from EtherDelta
209     withdrawToken(orderAddresses[1], getPartialAmount(orderValues[0], orderValues[1], amountToTrade));
210     
211     //Returns the amount of token obtained
212     return getPartialAmount(orderValues[0], orderValues[1], amountToTrade);
213  
214   }
215   
216   /// @dev Fills a buy order in EtherDelta.
217   /// @param orderAddresses Array of order's maker, makerToken, takerToken.
218   /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, expires and nonce.
219   /// @param exchangeFee Fee percentage of the exchange.
220   /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
221   /// @param v ECDSA signature parameter v.
222   /// @param r ECDSA signature parameters r.
223   /// @param s ECDSA signature parameters s.
224   /// @return Total amount of ethers filled in trade
225   function fillBuyOrder(
226     address[5] orderAddresses,
227     uint[6] orderValues,
228     uint exchangeFee,
229     uint fillTakerTokenAmount,
230     uint8 v,
231     bytes32 r,
232     bytes32 s
233   ) internal returns(uint) {
234     
235     //Deposit tokens in EtherDelta
236     depositToken(orderAddresses[2], fillTakerTokenAmount);
237     
238     uint amountToTrade;
239     uint fee;
240       
241     //Substract EtherDelta fee
242     (amountToTrade, fee) = substractFee(exchangeFee, fillTakerTokenAmount);
243 
244     //Fill EtherDelta Order
245     trade(
246       orderAddresses,
247       orderValues, 
248       amountToTrade,
249       v, 
250       r, 
251       s
252     );
253     
254     //Withdraw ethers obtained from EtherDelta
255     withdraw(getPartialAmount(orderValues[0], orderValues[1], amountToTrade));
256     
257     //Returns the amount of ethers obtained
258     return getPartialAmount(orderValues[0], orderValues[1], amountToTrade);
259   }
260   
261   /// @dev Trade an EtherDelta order.
262   /// @param orderAddresses Array of order's maker, makerToken, takerToken.
263   /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, expires and nonce.
264   /// @param amountToTrade Desired amount of takerToken to fill.
265   /// @param v ECDSA signature parameter v.
266   /// @param r ECDSA signature parameters r.
267   /// @param s ECDSA signature parameters s.
268   function trade(
269     address[5] orderAddresses,
270     uint[6] orderValues,
271     uint amountToTrade,
272     uint8 v,
273     bytes32 r,
274     bytes32 s
275   ) internal {
276       
277      //Fill EtherDelta Order
278      EtherDelta(ETHERDELTA_ADDR).trade(
279       orderAddresses[2], 
280       orderValues[1], 
281       orderAddresses[1], 
282       orderValues[0], 
283       orderValues[2], 
284       orderValues[3], 
285       orderAddresses[0], 
286       v, 
287       r, 
288       s, 
289       amountToTrade
290     );
291   }
292   
293   /// @dev Get the available amount of an EtherDelta order.
294   /// @param orderAddresses Array of address arrays containing individual order addresses.
295   /// @param orderValues Array of uint arrays containing individual order values.
296   /// @param exchangeFee Fee percentage of the exchange.
297   /// @param v Array ECDSA signature v parameters.
298   /// @param r Array of ECDSA signature r parameters.
299   /// @param s Array of ECDSA signature s parameters.
300   /// @return Available amount of the order.
301   function getAvailableAmount(
302     address[5] orderAddresses,
303     uint[6] orderValues,
304     uint exchangeFee,
305     uint8 v,
306     bytes32 r,
307     bytes32 s
308   ) internal returns(uint) {
309       
310     //If expired return 0 
311     if(block.number > orderValues[2])
312       return 0;
313       
314     //Fill EtherDelta Order
315     uint availableVolume = EtherDelta(ETHERDELTA_ADDR).availableVolume(
316       orderAddresses[2], 
317       orderValues[1], 
318       orderAddresses[1], 
319       orderValues[0], 
320       orderValues[2], 
321       orderValues[3], 
322       orderAddresses[0], 
323       v, 
324       r, 
325       s
326     );
327     
328     //AvailableVolume adds the fee percentage (X - X * fee)
329     return getPartialAmount(availableVolume, SafeMath.safeSub(1 ether, exchangeFee), 1 ether);
330   }
331   
332   /// @dev Substracts the take fee from EtherDelta.
333   /// @param amount Amount to substract EtherDelta fee
334   /// @return Amount minus the EtherDelta fee.
335   function substractFee(uint feePercentage, uint amount) constant internal returns(uint, uint) {
336     uint fee = getPartialAmount(amount, 1 ether, feePercentage);
337     return (SafeMath.safeSub(amount, fee), fee);
338   }
339   
340   /// @dev Deposit ethers to EtherDelta.
341   /// @param amount Amount of ethers to deposit in EtherDelta
342   function deposit(uint amount) internal {
343     EtherDelta(ETHERDELTA_ADDR).deposit.value(amount)();
344   }
345   
346   /// @dev Deposit tokens to EtherDelta.
347   /// @param token Address of token to deposit in EtherDelta
348   /// @param amount Amount of tokens to deposit in EtherDelta
349   function depositToken(address token, uint amount) internal {
350     Token(token).approve(ETHERDELTA_ADDR, amount);
351     EtherDelta(ETHERDELTA_ADDR).depositToken(token, amount);
352   }
353   
354   /// @dev Withdraw ethers from EtherDelta
355   /// @param amount Amount of ethers to withdraw from EtherDelta
356   function withdraw(uint amount) internal { 
357     EtherDelta(ETHERDELTA_ADDR).withdraw(amount);
358   }
359    
360   /// @dev Withdraw tokens from EtherDelta.
361   /// @param token Address of token to withdraw from EtherDelta
362   /// @param amount Amount of tokens to withdraw from EtherDelta
363   function withdrawToken(address token, uint amount) internal { 
364     EtherDelta(ETHERDELTA_ADDR).withdrawToken(token, amount);
365   }
366   
367   
368   /// @dev Calculates partial value given a numerator and denominator.
369   /// @param numerator Numerator.
370   /// @param denominator Denominator.
371   /// @param target Value to calculate partial of.
372   /// @return Partial value of target.
373   function getPartialAmount(uint numerator, uint denominator, uint target)
374     public
375     constant
376     returns (uint)
377   {
378     return SafeMath.safeDiv(SafeMath.safeMul(numerator, target), denominator);
379   }
380 
381 }
382 
383 library ZrxTrader {
384     
385   uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 4999;    // Changes to state require at least 5000 gas
386 
387   address constant public ZRX_EXCHANGE_ADDR = 0x12459c951127e0c374ff9105dda097662a027093; // 0x Exchange contract address
388   address constant public TOKEN_TRANSFER_PROXY_ADDR = 0x8da0d80f5007ef1e431dd2127178d224e32c2ef4; // TokenTransferProxy contract address
389   address constant public WETH_ADDR = 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2; // Wrapped ether address (WETH)
390   address constant public ZRX_TOKEN_ADDR = 0xe41d2489571d322189246dafa5ebde1f4699f498;
391   
392   /// @dev Gets the address of the Wrapped Ether contract
393   /// @return Address of Weth Contract.
394   function getWethAddress() internal returns(address) {
395       return WETH_ADDR;
396   }
397   
398   /// @dev Fills a sell order in 0x.
399   /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
400   /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
401   /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
402   /// @param v ECDSA signature parameter v.
403   /// @param r ECDSA signature parameters r.
404   /// @param s ECDSA signature parameters s.
405   /// @return Total amount of takerToken filled in trade.
406   function fillSellOrder(
407     address[5] orderAddresses,
408     uint[6] orderValues,
409     uint fillTakerTokenAmount,
410     uint8 v,
411     bytes32 r,
412     bytes32 s
413   ) internal returns(uint) 
414   {
415      
416     // Wrap ETH to WETH
417     depositWeth(fillTakerTokenAmount);
418     
419     // Allow 0x Transfer Token Proxy to transfer WETH
420     aproveToken(WETH_ADDR, fillTakerTokenAmount);
421     
422     //Allow ZRX Transfer Token Proxy to transfer the token for fees
423     aproveToken(ZRX_TOKEN_ADDR, getPartialAmount(fillTakerTokenAmount, orderValues[1], orderValues[3]));
424     
425     uint ethersSpent = Exchange(ZRX_EXCHANGE_ADDR).fillOrder(
426       orderAddresses,
427       orderValues,
428       fillTakerTokenAmount,
429       true,
430       v,
431       r,
432       s
433     );
434     
435     // Fill 0x order
436     return getPartialAmount(orderValues[0], orderValues[1], ethersSpent);
437     
438   }
439   
440   /// @dev Fills a buy order in 0x.
441   /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
442   /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
443   /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
444   /// @param v ECDSA signature parameter v.
445   /// @param r ECDSA signature parameters r.
446   /// @param s ECDSA signature parameters s.
447   /// @return Total amount of takerToken filled in trade.
448   function fillBuyOrder(
449     address[5] orderAddresses,
450     uint[6] orderValues,
451     uint fillTakerTokenAmount,
452     uint8 v,
453     bytes32 r,
454     bytes32 s
455   ) internal returns(uint) 
456   {
457     
458     //Allow 0x Transfer Token Proxy to transfer the token
459     aproveToken(orderAddresses[3], fillTakerTokenAmount);
460     
461     //Allow ZRX Transfer Token Proxy to transfer the token for fees
462     aproveToken(ZRX_TOKEN_ADDR, getPartialAmount(fillTakerTokenAmount, orderValues[1], orderValues[3]));
463     
464     // Fill 0x order
465     uint tokensSold = Exchange(ZRX_EXCHANGE_ADDR).fillOrder(
466       orderAddresses,
467       orderValues,
468       fillTakerTokenAmount,
469       true,
470       v,
471       r,
472       s
473     );
474     
475     uint ethersObtained = getPartialAmount(orderValues[0], orderValues[1], tokensSold);
476     
477     // Unwrap WETH to ETH
478     withdrawWeth(ethersObtained);
479     
480     return ethersObtained;
481   }
482   
483   /// @dev Get the available amount of a 0x order.
484   /// @param orderAddresses Array of address arrays containing individual order addresses.
485   /// @param orderValues Array of uint arrays containing individual order values.
486   /// @param v Array ECDSA signature v parameters.
487   /// @param r Array of ECDSA signature r parameters.
488   /// @param s Array of ECDSA signature s parameters.
489   /// @return Available amount of a 0x order.
490   function getAvailableAmount(
491     address[5] orderAddresses,
492     uint[6] orderValues,
493     uint8 v,
494     bytes32 r,
495     bytes32 s
496   ) internal returns(uint) {
497       
498       //If expired return 0 
499       if(block.timestamp >= orderValues[4])
500         return 0;
501           
502       bytes32 orderHash = Exchange(ZRX_EXCHANGE_ADDR).getOrderHash(orderAddresses, orderValues);
503       
504       uint unAvailable = Exchange(ZRX_EXCHANGE_ADDR).getUnavailableTakerTokenAmount(orderHash);
505   
506       //Gets the available amount acoording to 0x contract substracting takerTokenAmount with unavailable takerTokenAmount
507       uint availableByContract = SafeMath.safeSub(orderValues[1], unAvailable);
508       
509       //Gets the available amount according of the maker token balance
510       uint availableByBalance =  getPartialAmount(getBalance(orderAddresses[2], orderAddresses[0]), orderValues[0], orderValues[1]);
511       
512       //Gets the available amount according how much allowance of the token the maker has
513       uint availableByAllowance = getPartialAmount(getAllowance(orderAddresses[2], orderAddresses[0]), orderValues[0], orderValues[1]);
514     
515       //Get the available amount according to how much ZRX fee the maker can pay 
516       uint zrxAmount = getAllowance(ZRX_TOKEN_ADDR, orderAddresses[0]);
517       uint availableByZRX = getPartialAmount(zrxAmount, orderValues[2], orderValues[1]);
518       
519       //Returns the min value of all available results
520       return SafeMath.min256(SafeMath.min256(SafeMath.min256(availableByContract, availableByBalance), availableByAllowance), availableByZRX);
521   }
522     
523   /// @dev Deposit WETH
524   /// @param amount Amount of ether to wrap.
525   function depositWeth(uint amount) internal {
526     EtherToken(WETH_ADDR).deposit.value(amount)();
527   }
528   
529   /// @dev Approve tokens to be transfered by 0x Token Transfer Proxy
530   /// @param token Address of token to approve.
531   /// @param amount Amount of tokens to approve.
532   function aproveToken(address token, uint amount) internal {
533     Token(token).approve(TOKEN_TRANSFER_PROXY_ADDR, amount);
534   }
535   
536   /// @dev Withdraw WETH
537   /// @param amount Amount of ether to unwrap.
538   function withdrawWeth(uint amount) internal { 
539     EtherToken(WETH_ADDR).withdraw(amount);
540   }
541   
542   /// @dev Calculates partial value given a numerator and denominator.
543   /// @param numerator Numerator.
544   /// @param denominator Denominator.
545   /// @param target Value to calculate partial of.
546   /// @return Partial value of target.
547   function getPartialAmount(uint numerator, uint denominator, uint target) internal constant returns (uint)
548   {
549     return SafeMath.safeDiv(SafeMath.safeMul(numerator, target), denominator);
550   }
551 
552   /// @dev Get token balance of an address.
553   /// @param token Address of token.
554   /// @param owner Address of owner.
555   /// @return Token balance of owner.
556   function getBalance(address token, address owner) internal constant returns (uint)
557   {
558     return Token(token).balanceOf.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner); // Limit gas to prevent reentrancy
559   }
560 
561   /// @dev Get allowance of token given to TokenTransferProxy by an address.
562   /// @param token Address of token.
563   /// @param owner Address of owner.
564   /// @return Allowance of token given to TokenTransferProxy by owner.
565   function getAllowance(address token, address owner) internal constant returns (uint)
566   {
567     return Token(token).allowance.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner, TOKEN_TRANSFER_PROXY_ADDR); // Limit gas to prevent reentrancy
568   }
569   
570  
571 }
572 
573 contract EasyTrade {
574     
575   string constant public VERSION = "1.0.0";
576   address constant public ZRX_TOKEN_ADDR = 0xe41d2489571d322189246dafa5ebde1f4699f498;
577   
578   address public admin; // Admin address
579   address public feeAccount; // Account that will receive the fee
580   uint public serviceFee; // Percentage times (1 ether)
581   uint public collectedFee = 0; // Total of fees accumulated
582  
583   event FillSellOrder(address account, address token, uint tokens, uint ethers, uint tokensSold, uint ethersObtained, uint tokensRefunded);
584   event FillBuyOrder(address account, address token, uint tokens, uint ethers, uint tokensObtained, uint ethersSpent, uint ethersRefunded);
585   
586   modifier onlyAdmin() {
587     require(msg.sender == admin);
588     _;
589   }
590   
591   modifier onlyFeeAccount() {
592     require(msg.sender == feeAccount);
593     _;
594   }
595  
596   function EasyTrade(
597     address admin_,
598     address feeAccount_,
599     uint serviceFee_) 
600   {
601     admin = admin_;
602     feeAccount = feeAccount_;
603     serviceFee = serviceFee_;
604   } 
605     
606   /// @dev For exchange contracts that send ethers back.
607   function() public payable { 
608       //Only accepts payments from 0x Wrapped Ether or EtherDelta
609       require(msg.sender == ZrxTrader.getWethAddress() || msg.sender == EtherDeltaTrader.getEtherDeltaAddresss());
610   }
611 
612   /// @dev Set the new admin. Only admin can set the new admin.
613   /// @param admin_ Address of the new admin.
614   function changeAdmin(address admin_) public onlyAdmin {
615     admin = admin_;
616   }
617   
618   /// @dev Set the new fee account. Only admin can set the new fee account.
619   /// @param feeAccount_ Address of the new fee account.
620   function changeFeeAccount(address feeAccount_) public onlyAdmin {
621     feeAccount = feeAccount_;
622   }
623 
624   /// @dev Set the service fee. Only admin can set the new fee. Service fee can only be reduced, never increased
625   /// @param serviceFee_ Percentage times (1 ether).
626   function changeFeePercentage(uint serviceFee_) public onlyAdmin {
627     require(serviceFee_ < serviceFee);
628     serviceFee = serviceFee_;
629   }
630   
631   /// @dev Creates an order to sell a token. 
632   /// @notice Needs first to call Token(tokend_address).approve(this, tokens_) so the contract can trade the tokens.
633   /// @param token Address of the token to sell.
634   /// @param tokensTotal Amount of the token to sell.
635   /// @param ethersTotal Amount of ethers to get.
636   /// @param exchanges Exchanges of each order (0: EtherDelta 1: 0x).
637   /// @param ethersTotal Amount of ethers to get.
638   /// @param orderAddresses Array of address arrays containing individual order addresses.
639   /// @param orderValues Array of uint arrays containing individual order values.
640   /// @param exchangeFees Array of exchange fees to fill in orders.
641   /// @param v Array ECDSA signature v parameters.
642   /// @param r Array of ECDSA signature r parameters.
643   /// @param s Array of ECDSA signature s parameters.
644   function createSellOrder(
645     address token, 
646     uint tokensTotal, 
647     uint ethersTotal,
648     uint8[] exchanges,
649     address[5][] orderAddresses,
650     uint[6][] orderValues,
651     uint[] exchangeFees,
652     uint8[] v,
653     bytes32[] r,
654     bytes32[] s
655   ) public
656   {
657     
658     //Transfer tokens to contract so it can sell them.
659     require(Token(token).transferFrom(msg.sender, this, tokensTotal));
660     
661     uint ethersObtained;
662     uint tokensSold;
663     uint tokensRefunded = tokensTotal;
664     
665     (ethersObtained, tokensSold) = fillOrdersForSellRequest(
666       tokensTotal,
667       exchanges,
668       orderAddresses,
669       orderValues,
670       exchangeFees,
671       v,
672       r,
673       s
674     );
675     
676     //We make sure that at least one order had some amount filled
677     require(ethersObtained > 0 && tokensSold >0);
678     
679     //Check that the price of what was sold is not smaller than the min agreed
680     require(SafeMath.safeDiv(ethersTotal, tokensTotal) <= SafeMath.safeDiv(ethersObtained, tokensSold));
681     
682     //Substracts the tokens sold
683     tokensRefunded = SafeMath.safeSub(tokensTotal, tokensSold);
684     
685     //Return tokens not sold 
686     if(tokensRefunded > 0) 
687      require(Token(token).transfer(msg.sender, tokensRefunded));
688     
689     //Send the ethersObtained
690     transfer(msg.sender, ethersObtained);
691     
692     FillSellOrder(msg.sender, token, tokensTotal, ethersTotal, tokensSold, ethersObtained, tokensRefunded);
693   }
694   
695   /// @dev Fills a sell order by synchronously executing exchange buy orders.
696   /// @param tokensTotal Total amount of tokens to sell.
697   /// @param exchanges Exchanges of each order (0: EtherDelta 1: 0x).
698   /// @param orderAddresses Array of address arrays containing individual order addresses.
699   /// @param orderValues Array of uint arrays containing individual order values.
700   /// @param exchangeFees Array of exchange fees to fill in orders.
701   /// @param v Array ECDSA signature v parameters.
702   /// @param r Array of ECDSA signature r parameters.
703   /// @param s Array of ECDSA signature s parameters.
704   /// @return Total amount of ethers obtained and total amount of tokens sold.
705   function fillOrdersForSellRequest(
706     uint tokensTotal,
707     uint8[] exchanges,
708     address[5][] orderAddresses,
709     uint[6][] orderValues,
710     uint[] exchangeFees,
711     uint8[] v,
712     bytes32[] r,
713     bytes32[] s
714   ) internal returns(uint, uint)
715   {
716     uint totalEthersObtained = 0;
717     uint tokensRemaining = tokensTotal;
718     
719     for (uint i = 0; i < orderAddresses.length; i++) {
720    
721       (totalEthersObtained, tokensRemaining) = fillOrderForSellRequest(
722          totalEthersObtained,
723          tokensRemaining,
724          exchanges[i],
725          orderAddresses[i],
726          orderValues[i],
727          exchangeFees[i],
728          v[i],
729          r[i],
730          s[i]
731       );
732 
733     }
734     
735     //Substracts service fee
736     if(totalEthersObtained > 0) {
737       uint fee =  SafeMath.safeMul(totalEthersObtained, serviceFee) / (1 ether);
738       totalEthersObtained = collectServiceFee(SafeMath.min256(fee, totalEthersObtained), totalEthersObtained);
739     }
740     
741     //Returns ethers obtained
742     return (totalEthersObtained, SafeMath.safeSub(tokensTotal, tokensRemaining));
743   }
744   
745   /// @dev Fills a sell order with a buy order.
746   /// @param totalEthersObtained Total amount of ethers obtained so far.
747   /// @param initialTokensRemaining Total amount of tokens remaining to sell.
748   /// @param exchange 0: EtherDelta 1: 0x.
749   /// @param orderAddresses Array of address arrays containing individual order addresses.
750   /// @param orderValues Array of uint arrays containing individual order values.
751   /// @param exchangeFee Exchange fees to fill the order.
752   /// @param v Array ECDSA signature v parameters.
753   /// @param r Array of ECDSA signature r parameters.
754   /// @param s Array of ECDSA signature s parameters.
755   /// @return Total amount of ethers obtained and total amount of tokens remainint to sell.
756   function fillOrderForSellRequest(
757     uint totalEthersObtained,
758     uint initialTokensRemaining,
759     uint8 exchange,
760     address[5] orderAddresses,
761     uint[6] orderValues,
762     uint exchangeFee,
763     uint8 v,
764     bytes32 r,
765     bytes32 s
766     ) internal returns(uint, uint)
767   {
768     uint ethersObtained = 0;
769     uint tokensRemaining = initialTokensRemaining;
770     
771     //Exchange fees should not be higher than 1% (in Wei)
772     require(exchangeFee < 10000000000000000);
773     
774     //Checks that there is enoughh amount to execute the trade
775     uint fillAmount = getFillAmount(
776       tokensRemaining,
777       exchange,
778       orderAddresses,
779       orderValues,
780       exchangeFee,
781       v,
782       r,
783       s
784     );
785     
786     if(fillAmount > 0) {
787           
788       //Substracts the amount to execute
789       tokensRemaining = SafeMath.safeSub(tokensRemaining, fillAmount);
790     
791       if(exchange == 0) {
792         //Executes EtherDelta buy order and returns the amount of ethers obtained, fullfill all or returns zero
793         ethersObtained = EtherDeltaTrader.fillBuyOrder(
794           orderAddresses,
795           orderValues,
796           exchangeFee,
797           fillAmount,
798           v,
799           r,
800           s
801         );    
802       } 
803       else {
804         //Executes 0x buy order and returns the amount of ethers obtained, fullfill all or returns zero
805         ethersObtained = ZrxTrader.fillBuyOrder(
806           orderAddresses,
807           orderValues,
808           fillAmount,
809           v,
810           r,
811           s
812         );
813         
814         //If 0x, exchangeFee is collected by the contract to buy externally ZrxTrader
815         uint fee = SafeMath.safeMul(ethersObtained, exchangeFee) / (1 ether);
816         ethersObtained = collectServiceFee(fee, ethersObtained);
817     
818       }
819     }
820          
821     //Adds the amount of ethers obtained and tokens remaining
822     return (SafeMath.safeAdd(totalEthersObtained, ethersObtained), ethersObtained==0? initialTokensRemaining: tokensRemaining);
823    
824   }
825   
826   /// @dev Creates an order to buy a token. 
827   /// @param token Address of the token to sell.
828   /// @param tokensTotal Amount of the token to sell.
829   /// @param exchanges Exchanges of each order (0: EtherDelta 1: 0x).
830   /// @param orderAddresses Array of address arrays containing individual order addresses.
831   /// @param orderValues Array of uint arrays containing individual order values.
832   /// @param exchangeFees Array of exchange fees to fill in orders.
833   /// @param v Array ECDSA signature v parameters.
834   /// @param r Array of ECDSA signature r parameters.
835   /// @param s Array of ECDSA signature s parameters.
836   function createBuyOrder(
837     address token, 
838     uint tokensTotal,
839     uint8[] exchanges,
840     address[5][] orderAddresses,
841     uint[6][] orderValues,
842     uint[] exchangeFees,
843     uint8[] v,
844     bytes32[] r,
845     bytes32[] s
846   ) public payable 
847   {
848     
849     
850     uint ethersTotal = msg.value;
851     uint tokensObtained;
852     uint ethersSpent;
853     uint ethersRefunded = ethersTotal;
854      
855     require(tokensTotal > 0 && msg.value > 0);
856     
857     (tokensObtained, ethersSpent) = fillOrdersForBuyRequest(
858       ethersTotal,
859       exchanges,
860       orderAddresses,
861       orderValues,
862       exchangeFees,
863       v,
864       r,
865       s
866     );
867     
868     //We make sure that at least one order had some amount filled
869     require(ethersSpent > 0 && tokensObtained >0);
870     
871     //Check that the price of what was bought is not greater than the max agreed
872     require(SafeMath.safeDiv(ethersTotal, tokensTotal) >= SafeMath.safeDiv(ethersSpent, tokensObtained));
873 
874     //Substracts the ethers spent
875     ethersRefunded = SafeMath.safeSub(ethersTotal, ethersSpent);
876     
877     //Return ethers not spent 
878     if(ethersRefunded > 0)
879      require(msg.sender.call.value(ethersRefunded)());
880    
881     //Send the tokens
882     transferToken(token, msg.sender, tokensObtained);
883     
884     FillBuyOrder(msg.sender, token, tokensTotal, ethersTotal, tokensObtained, ethersSpent, ethersRefunded);
885   }
886   
887   /// @dev Fills a buy order by synchronously executing exchange sell orders.
888   /// @param ethersTotal Total amount of ethers to spend.
889   /// @param exchanges Exchanges of each order (0: EtherDelta 1: 0x).
890   /// @param orderAddresses Array of address arrays containing individual order addresses.
891   /// @param orderValues Array of uint arrays containing individual order values.
892   /// @param exchangeFees Array of exchange fees to fill in orders.
893   /// @param v Array ECDSA signature v parameters.
894   /// @param r Array of ECDSA signature r parameters.
895   /// @param s Array of ECDSA signature s parameters.
896   /// @return Total of tokens obtained.
897   /// @return Total amount of tokens obtained and total amount of ethers spent.
898   function fillOrdersForBuyRequest(
899     uint ethersTotal,
900     uint8[] exchanges,
901     address[5][] orderAddresses,
902     uint[6][] orderValues,
903     uint[] exchangeFees,
904     uint8[] v,
905     bytes32[] r,
906     bytes32[] s
907   ) internal returns(uint, uint)
908   {
909     uint totalTokensObtained = 0;
910     uint ethersRemaining = ethersTotal;
911     
912     for (uint i = 0; i < orderAddresses.length; i++) {
913     
914       if(ethersRemaining > 0) {
915         (totalTokensObtained, ethersRemaining) = fillOrderForBuyRequest(
916           totalTokensObtained,
917           ethersRemaining,
918           exchanges[i],
919           orderAddresses[i],
920           orderValues[i],
921           exchangeFees[i],
922           v[i],
923           r[i],
924           s[i]
925         );
926       }
927     
928     }
929     
930     //Returns total of tokens obtained
931     return (totalTokensObtained, SafeMath.safeSub(ethersTotal, ethersRemaining));
932   }
933   
934   /// @dev Fills a buy order wtih a sell order.
935   /// @param totalTokensObtained Total amount of tokens obtained so far.
936   /// @param initialEthersRemaining Total amount of ethers remainint to spend.
937   /// @param exchange 0: EtherDelta 1: 0x.
938   /// @param orderAddresses Array of address arrays containing individual order addresses.
939   /// @param orderValues Array of uint arrays containing individual order values.
940   /// @param exchangeFee Exchange fees to fill the order.
941   /// @param v Array ECDSA signature v parameters.
942   /// @param r Array of ECDSA signature r parameters.
943   /// @param s Array of ECDSA signature s parameters.
944   /// @return Total of tokens obtained.
945   /// @return Total amount of tokens obtained and total amount of ethers remainint to spend.
946   function fillOrderForBuyRequest(
947     uint totalTokensObtained,
948     uint initialEthersRemaining,
949     uint8 exchange,
950     address[5] orderAddresses,
951     uint[6] orderValues,
952     uint exchangeFee,
953     uint8 v,
954     bytes32 r,
955     bytes32 s
956   ) internal returns(uint, uint)
957   {
958     uint tokensObtained = 0;
959     uint ethersRemaining = initialEthersRemaining;
960        
961     //Exchange fees should not be higher than 1% (in Wei)
962     require(exchangeFee < 10000000000000000);
963      
964     //Checks that there is enoughh amount to execute the trade
965     uint fillAmount = getFillAmount(
966       ethersRemaining,
967       exchange,
968       orderAddresses,
969       orderValues,
970       exchangeFee,
971       v,
972       r,
973       s
974     );
975    
976     if(fillAmount > 0) {
977      
978       //Substracts the amount to execute
979       ethersRemaining = SafeMath.safeSub(ethersRemaining, fillAmount);
980       
981       //Substract service fee
982       (fillAmount, ethersRemaining) = substractFee(serviceFee, fillAmount, ethersRemaining);
983          
984       if(exchange == 0) {
985         //Executes EtherDelta order, fee is paid directly to EtherDelta, fullfill all or returns zero
986         tokensObtained = EtherDeltaTrader.fillSellOrder(
987           orderAddresses,
988           orderValues,
989           exchangeFee,
990           fillAmount,
991           v,
992           r,
993           s
994         );
995       
996       } 
997       else {
998           
999         //If 0x, exchangeFee is collected by the contract to buy externally ZrxTrader, fullfill all or returns zero
1000         (fillAmount, ethersRemaining) = substractFee(exchangeFee, fillAmount, ethersRemaining);
1001         
1002         //Executes 0x order
1003         tokensObtained = ZrxTrader.fillSellOrder(
1004           orderAddresses,
1005           orderValues,
1006           fillAmount,
1007           v,
1008           r,
1009           s
1010         );
1011       }
1012     }
1013         
1014     //Returns total of tokens obtained and ethers remaining
1015     return (SafeMath.safeAdd(totalTokensObtained, tokensObtained), tokensObtained==0? initialEthersRemaining: ethersRemaining);
1016   }
1017   
1018   
1019   /// @dev Get the amount to fill in the order.
1020   /// @param amount Remaining amount of the order.
1021   /// @param exchange 0: EtherDelta 1: 0x.
1022   /// @param orderAddresses Array of address arrays containing individual order addresses.
1023   /// @param orderValues Array of uint arrays containing individual order values.
1024   /// @param v Array ECDSA signature v parameters.
1025   /// @param r Array of ECDSA signature r parameters.
1026   /// @param s Array of ECDSA signature s parameters.
1027   /// @return Min amount between the remaining and the order available.
1028   function getFillAmount(
1029     uint amount,
1030     uint8 exchange,
1031     address[5] orderAddresses,
1032     uint[6] orderValues,
1033     uint exchangeFee,
1034     uint8 v,
1035     bytes32 r,
1036     bytes32 s
1037   ) internal returns(uint) 
1038   {
1039     uint availableAmount;
1040     if(exchange == 0) {
1041       availableAmount = EtherDeltaTrader.getAvailableAmount(
1042         orderAddresses,
1043         orderValues,
1044         exchangeFee,
1045         v,
1046         r,
1047         s
1048       );    
1049     } 
1050     else {
1051       availableAmount = ZrxTrader.getAvailableAmount(
1052         orderAddresses,
1053         orderValues,
1054         v,
1055         r,
1056         s
1057       );
1058     }
1059      
1060     return SafeMath.min256(amount, availableAmount);
1061   }
1062   
1063   /// @dev Substracts the service from the remaining amount if enough, if not from the amount to fill the order.
1064   /// @param feePercentage Fee Percentage
1065   /// @param fillAmount Amount to fill the order
1066   /// @param ethersRemaining Remaining amount of ethers for other orders
1067   /// @return Amount to fill the order and remaining amount
1068   function substractFee(
1069     uint feePercentage,
1070     uint fillAmount,
1071     uint ethersRemaining
1072   ) internal returns(uint, uint) 
1073   {       
1074       uint fee = SafeMath.safeMul(fillAmount, feePercentage) / (1 ether);
1075       //If there is enough remaining to pay fee, it substracts the fee from the remaining
1076       if(ethersRemaining >= fee)
1077          ethersRemaining = collectServiceFee(fee, ethersRemaining);
1078       else {
1079          fillAmount = collectServiceFee(fee, SafeMath.safeAdd(fillAmount, ethersRemaining));
1080          ethersRemaining = 0;
1081       }
1082       return (fillAmount, ethersRemaining);
1083   }
1084   
1085   /// @dev Substracts the service fee in ethers.
1086   /// @param fee Service fee in ethers
1087   /// @param amount Amount to substract service fee
1088   /// @return Amount minus service fee.
1089   function collectServiceFee(uint fee, uint amount) internal returns(uint) {
1090     collectedFee = SafeMath.safeAdd(collectedFee, fee);
1091     return SafeMath.safeSub(amount, fee);
1092   }
1093   
1094   /// @dev Transfer ethers to user account.
1095   /// @param account User address where to send ethers.
1096   /// @param amount Amount of ethers to send.
1097   function transfer(address account, uint amount) internal {
1098     require(account.send(amount));
1099   }
1100     
1101   /// @dev Transfer token to user account.
1102   /// @param token Address of token to transfer.
1103   /// @param account User address where to transfer tokens.
1104   /// @param amount Amount of tokens to transfer.
1105   function transferToken(address token, address account, uint amount) internal {
1106     require(Token(token).transfer(account, amount));
1107   }
1108    
1109   /// @dev Withdraw collected service fees. Only by fee account.
1110   /// @param amount Amount to withdraw
1111   function withdrawFees(uint amount) public onlyFeeAccount {
1112     require(collectedFee >= amount);
1113     collectedFee = SafeMath.safeSub(collectedFee, amount);
1114     require(feeAccount.send(amount));
1115   }
1116   
1117    
1118   /// @dev Withdraw contract ZRX in case new version is deployed. Only by admin.
1119   /// @param amount Amount to withdraw
1120   function withdrawZRX(uint amount) public onlyAdmin {
1121     require(Token(ZRX_TOKEN_ADDR).transfer(admin, amount));
1122   }
1123 }