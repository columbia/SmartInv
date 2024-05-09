1 /*
2 
3   Copyright 2017 ZeroEx Intl.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.19;
20 
21 interface Token {
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint _value) public returns (bool);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint _value) public returns (bool);
35 
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint _value) public returns (bool);
41 
42     /// @param _owner The address from which the balance will be retrieved
43     /// @return The balance
44     function balanceOf(address _owner) public view returns (uint);
45 
46     /// @param _owner The address of the account owning tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @return Amount of remaining tokens allowed to spent
49     function allowance(address _owner, address _spender) public view returns (uint);
50 
51     event Transfer(address indexed _from, address indexed _to, uint _value); // solhint-disable-line
52     event Approval(address indexed _owner, address indexed _spender, uint _value);
53 }
54 
55 
56 //solhint-disable-next-line
57 /// @title TokenTransferProxy - Transfers tokens on behalf of exchange
58 /// @author Ahmed Ali <Ahmed@bitfinex.com>
59 contract TokenTransferProxy {
60 
61     modifier onlyExchange {
62         require(msg.sender == exchangeAddress);
63         _;
64     }
65 
66     address public exchangeAddress;
67 
68 
69     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
70 
71     function TokenTransferProxy() public {
72         setExchange(msg.sender);
73     }
74     /*
75      * Public functions
76      */
77 
78     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
79     /// @param token Address of token to transfer.
80     /// @param from Address to transfer token from.
81     /// @param to Address to transfer token to.
82     /// @param value Amount of token to transfer.
83     /// @return Success of transfer.
84     function transferFrom(
85         address token,
86         address from,
87         address to,
88         uint value)
89         public
90         onlyExchange
91         returns (bool)
92     {
93         return Token(token).transferFrom(from, to, value);
94     }
95 
96     /// @dev Used to set exchange address
97     /// @param _exchange the address of the exchange
98     function setExchange(address _exchange) internal {
99         require(exchangeAddress == address(0));
100         exchangeAddress = _exchange;
101     }
102 }
103 
104 contract SafeMath {
105     function safeMul(uint a, uint b)
106         internal
107         pure
108         returns (uint256)
109     {
110         uint c = a * b;
111         assert(a == 0 || c / a == b);
112         return c;
113     }
114 
115     function safeDiv(uint a, uint b)
116         internal
117         pure
118         returns (uint256)
119     {
120         uint c = a / b;
121         return c;
122     }
123 
124     function safeSub(uint a, uint b)
125         internal
126         pure
127         returns (uint256)
128     {
129         assert(b <= a);
130         return a - b;
131     }
132 
133     function safeAdd(uint a, uint b)
134         internal
135         pure
136         returns (uint256)
137     {
138         uint c = a + b;
139         assert(c >= a);
140         return c;
141     }
142 
143     function max64(uint64 a, uint64 b)
144         internal
145         pure
146         returns (uint256)
147     {
148         return a >= b ? a : b;
149     }
150 
151     function min64(uint64 a, uint64 b)
152         internal
153         pure
154         returns (uint256)
155     {
156         return a < b ? a : b;
157     }
158 
159     function max256(uint256 a, uint256 b)
160         internal
161         pure
162         returns (uint256)
163     {
164         return a >= b ? a : b;
165     }
166 
167     function min256(uint256 a, uint256 b)
168         internal
169         pure
170         returns (uint256)
171     {
172         return a < b ? a : b;
173     }
174 }
175 
176 
177 /// @title Exchange - Facilitates exchange of ERC20 tokens.
178 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
179 // Modified by Ahmed Ali <Ahmed@bitfinex.com>
180 contract Exchange is SafeMath {
181 
182     // Error Codes
183     enum Errors {
184         ORDER_EXPIRED,                    // Order has already expired
185         ORDER_FULLY_FILLED_OR_CANCELLED,  // Order has already been fully filled or cancelled
186         ROUNDING_ERROR_TOO_LARGE,         // Rounding error too large
187         INSUFFICIENT_BALANCE_OR_ALLOWANCE // Insufficient balance or allowance for token transfer
188     }
189 
190     string constant public VERSION = "1.0.0";
191     uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 4999;    // Changes to state require at least 5000 gas
192     uint constant public ETHFINEX_FEE = 200; // Amount - (Amount/fee) is what gets send to user
193 
194     // address public ZRX_TOKEN_CONTRACT;
195     address public TOKEN_TRANSFER_PROXY_CONTRACT;
196 
197     // Mappings of orderHash => amounts of takerTokenAmount filled or cancelled.
198     mapping (bytes32 => uint) public filled;
199     mapping (bytes32 => uint) public cancelled;
200 
201     event LogFill(
202         address indexed maker,
203         address taker,
204         address indexed feeRecipient,
205         address makerToken,
206         address takerToken,
207         uint filledMakerTokenAmount,
208         uint filledTakerTokenAmount,
209         uint paidMakerFee,
210         uint paidTakerFee,
211         bytes32 indexed tokens, // keccak256(makerToken, takerToken), allows subscribing to a token pair
212         bytes32 orderHash
213     );
214 
215     event LogCancel(
216         address indexed maker,
217         address indexed feeRecipient,
218         address makerToken,
219         address takerToken,
220         uint cancelledMakerTokenAmount,
221         uint cancelledTakerTokenAmount,
222         bytes32 indexed tokens,
223         bytes32 orderHash
224     );
225 
226     event LogError(uint8 indexed errorId, bytes32 indexed orderHash);
227 
228     struct Order {
229         address maker;
230         address taker;
231         address makerToken;
232         address takerToken;
233         address feeRecipient;
234         uint makerTokenAmount;
235         uint takerTokenAmount;
236         uint makerFee;
237         uint takerFee;
238         uint expirationTimestampInSec;
239         bytes32 orderHash;
240     }
241 
242     // MODIFIED CODE, constructor changed
243     function Exchange() public {
244         // ZRX_TOKEN_CONTRACT = _zrxToken;
245         TOKEN_TRANSFER_PROXY_CONTRACT = address(new TokenTransferProxy());
246     }
247 
248     /*
249     * Core exchange functions
250     */
251 
252     /// @dev Fills the input order.
253     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
254     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
255     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
256     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfer will fail before attempting.
257     /// @param v ECDSA signature parameter v.
258     /// @param r ECDSA signature parameters r.
259     /// @param s ECDSA signature parameters s.
260     /// @return Total amount of takerToken filled in trade.
261     function fillOrder(
262           address[5] orderAddresses,
263           uint[6] orderValues,
264           uint fillTakerTokenAmount,
265           bool shouldThrowOnInsufficientBalanceOrAllowance,
266           uint8 v,
267           bytes32 r,
268           bytes32 s)
269           public
270           returns (uint filledTakerTokenAmount)
271     {
272         Order memory order = Order({
273             maker: orderAddresses[0],
274             taker: orderAddresses[1],
275             makerToken: orderAddresses[2],
276             takerToken: orderAddresses[3],
277             feeRecipient: orderAddresses[4],
278             makerTokenAmount: orderValues[0],
279             takerTokenAmount: orderValues[1],
280             makerFee: orderValues[2],
281             takerFee: orderValues[3],
282             expirationTimestampInSec: orderValues[4],
283             orderHash: getOrderHash(orderAddresses, orderValues)
284         });
285 
286         require(order.taker == address(0) || order.taker == msg.sender);
287         require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && fillTakerTokenAmount > 0);
288         require(isValidSignature(
289             order.maker,
290             order.orderHash,
291             v,
292             r,
293             s
294         ));
295 
296         if (block.timestamp >= order.expirationTimestampInSec) {
297             LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
298             return 0;
299         }
300 
301         uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
302         filledTakerTokenAmount = min256(fillTakerTokenAmount, remainingTakerTokenAmount);
303         if (filledTakerTokenAmount == 0) {
304             LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
305             return 0;
306         }
307 
308         if (isRoundingError(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount)) {
309             LogError(uint8(Errors.ROUNDING_ERROR_TOO_LARGE), order.orderHash);
310             return 0;
311         }
312 
313         if (!shouldThrowOnInsufficientBalanceOrAllowance && !isTransferable(order, filledTakerTokenAmount)) {
314             LogError(uint8(Errors.INSUFFICIENT_BALANCE_OR_ALLOWANCE), order.orderHash);
315             return 0;
316         }
317 
318         /////////////// modified code /////////////////
319         // uint filledMakerTokenAmount = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
320         uint filledMakerTokenAmount = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
321         filledMakerTokenAmount = filledMakerTokenAmount - safeDiv(filledMakerTokenAmount, ETHFINEX_FEE);
322         ///////////// modified code ///////////
323 
324         uint paidMakerFee;
325         uint paidTakerFee;
326         filled[order.orderHash] = safeAdd(filled[order.orderHash], filledTakerTokenAmount);
327         require(transferViaTokenTransferProxy(
328             order.makerToken,
329             order.maker,
330             msg.sender,
331             filledMakerTokenAmount
332         ));
333         require(transferViaTokenTransferProxy(
334             order.takerToken,
335             msg.sender,
336             order.maker,
337             filledTakerTokenAmount
338         ));
339         // if (order.feeRecipient != address(0)) {
340         //     if (order.makerFee > 0) {
341         //         paidMakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerFee);
342         //         require(transferViaTokenTransferProxy(
343         //             ZRX_TOKEN_CONTRACT,
344         //             order.maker,
345         //             order.feeRecipient,
346         //             paidMakerFee
347         //         ));
348         //     }
349         //     if (order.takerFee > 0) {
350         //         paidTakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.takerFee);
351         //         require(transferViaTokenTransferProxy(
352         //             ZRX_TOKEN_CONTRACT,
353         //             msg.sender,
354         //             order.feeRecipient,
355         //             paidTakerFee
356         //         ));
357         //     }
358         // }
359 
360         LogFill(
361             order.maker,
362             msg.sender,
363             order.feeRecipient,
364             order.makerToken,
365             order.takerToken,
366             filledMakerTokenAmount,
367             filledTakerTokenAmount,
368             paidMakerFee,
369             paidTakerFee,
370             keccak256(order.makerToken, order.takerToken),
371             order.orderHash
372         );
373         return filledTakerTokenAmount;
374     }
375 
376     /// @dev Cancels the input order.
377     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
378     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
379     /// @param cancelTakerTokenAmount Desired amount of takerToken to cancel in order.
380     /// @return Amount of takerToken cancelled.
381     // function cancelOrder(
382     //     address[5] orderAddresses,
383     //     uint[6] orderValues,
384     //     uint cancelTakerTokenAmount)
385     //     public
386     //     returns (uint)
387     // {
388     //     Order memory order = Order({
389     //         maker: orderAddresses[0],
390     //         taker: orderAddresses[1],
391     //         makerToken: orderAddresses[2],
392     //         takerToken: orderAddresses[3],
393     //         feeRecipient: orderAddresses[4],
394     //         makerTokenAmount: orderValues[0],
395     //         takerTokenAmount: orderValues[1],
396     //         makerFee: orderValues[2],
397     //         takerFee: orderValues[3],
398     //         expirationTimestampInSec: orderValues[4],
399     //         orderHash: getOrderHash(orderAddresses, orderValues)
400     //     });
401 
402     //     require(order.maker == msg.sender);
403     //     require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && cancelTakerTokenAmount > 0);
404 
405     //     if (block.timestamp >= order.expirationTimestampInSec) {
406     //         LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
407     //         return 0;
408     //     }
409 
410     //     uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
411     //     uint cancelledTakerTokenAmount = min256(cancelTakerTokenAmount, remainingTakerTokenAmount);
412     //     if (cancelledTakerTokenAmount == 0) {
413     //         LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
414     //         return 0;
415     //     }
416 
417     //     cancelled[order.orderHash] = safeAdd(cancelled[order.orderHash], cancelledTakerTokenAmount);
418 
419     //     LogCancel(
420     //         order.maker,
421     //         order.feeRecipient,
422     //         order.makerToken,
423     //         order.takerToken,
424     //         getPartialAmount(cancelledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount),
425     //         cancelledTakerTokenAmount,
426     //         keccak256(order.makerToken, order.takerToken),
427     //         order.orderHash
428     //     );
429     //     return cancelledTakerTokenAmount;
430     // }
431 
432     /*
433     * Wrapper functions
434     */
435 
436     /// @dev Fills an order with specified parameters and ECDSA signature, throws if specified amount not filled entirely.
437     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
438     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
439     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
440     /// @param v ECDSA signature parameter v.
441     /// @param r ECDSA signature parameters r.
442     /// @param s ECDSA signature parameters s.
443     function fillOrKillOrder(
444         address[5] orderAddresses,
445         uint[6] orderValues,
446         uint fillTakerTokenAmount,
447         uint8 v,
448         bytes32 r,
449         bytes32 s)
450         public
451     {
452         require(fillOrder(
453             orderAddresses,
454             orderValues,
455             fillTakerTokenAmount,
456             false,
457             v,
458             r,
459             s
460         ) == fillTakerTokenAmount);
461     }
462 
463     /// @dev Synchronously executes multiple fill orders in a single transaction.
464     /// @param orderAddresses Array of address arrays containing individual order addresses.
465     /// @param orderValues Array of uint arrays containing individual order values.
466     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
467     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
468     /// @param v Array ECDSA signature v parameters.
469     /// @param r Array of ECDSA signature r parameters.
470     /// @param s Array of ECDSA signature s parameters.
471     function batchFillOrders(
472         address[5][] orderAddresses,
473         uint[6][] orderValues,
474         uint[] fillTakerTokenAmounts,
475         bool shouldThrowOnInsufficientBalanceOrAllowance,
476         uint8[] v,
477         bytes32[] r,
478         bytes32[] s)
479         public
480     {
481         for (uint i = 0; i < orderAddresses.length; i++) {
482             fillOrder(
483                 orderAddresses[i],
484                 orderValues[i],
485                 fillTakerTokenAmounts[i],
486                 shouldThrowOnInsufficientBalanceOrAllowance,
487                 v[i],
488                 r[i],
489                 s[i]
490             );
491         }
492     }
493 
494     /// @dev Synchronously executes multiple fillOrKill orders in a single transaction.
495     /// @param orderAddresses Array of address arrays containing individual order addresses.
496     /// @param orderValues Array of uint arrays containing individual order values.
497     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
498     /// @param v Array ECDSA signature v parameters.
499     /// @param r Array of ECDSA signature r parameters.
500     /// @param s Array of ECDSA signature s parameters.
501     function batchFillOrKillOrders(
502         address[5][] orderAddresses,
503         uint[6][] orderValues,
504         uint[] fillTakerTokenAmounts,
505         uint8[] v,
506         bytes32[] r,
507         bytes32[] s)
508         public
509     {
510         for (uint i = 0; i < orderAddresses.length; i++) {
511             fillOrKillOrder(
512                 orderAddresses[i],
513                 orderValues[i],
514                 fillTakerTokenAmounts[i],
515                 v[i],
516                 r[i],
517                 s[i]
518             );
519         }
520     }
521 
522     /// @dev Synchronously executes multiple fill orders in a single transaction until total fillTakerTokenAmount filled.
523     /// @param orderAddresses Array of address arrays containing individual order addresses.
524     /// @param orderValues Array of uint arrays containing individual order values.
525     /// @param fillTakerTokenAmount Desired total amount of takerToken to fill in orders.
526     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
527     /// @param v Array ECDSA signature v parameters.
528     /// @param r Array of ECDSA signature r parameters.
529     /// @param s Array of ECDSA signature s parameters.
530     /// @return Total amount of fillTakerTokenAmount filled in orders.
531     function fillOrdersUpTo(
532         address[5][] orderAddresses,
533         uint[6][] orderValues,
534         uint fillTakerTokenAmount,
535         bool shouldThrowOnInsufficientBalanceOrAllowance,
536         uint8[] v,
537         bytes32[] r,
538         bytes32[] s)
539         public
540         returns (uint)
541     {
542         uint filledTakerTokenAmount = 0;
543         for (uint i = 0; i < orderAddresses.length; i++) {
544             require(orderAddresses[i][3] == orderAddresses[0][3]); // takerToken must be the same for each order
545             filledTakerTokenAmount = safeAdd(filledTakerTokenAmount, fillOrder(
546                 orderAddresses[i],
547                 orderValues[i],
548                 safeSub(fillTakerTokenAmount, filledTakerTokenAmount),
549                 shouldThrowOnInsufficientBalanceOrAllowance,
550                 v[i],
551                 r[i],
552                 s[i]
553             ));
554             if (filledTakerTokenAmount == fillTakerTokenAmount) break;
555         }
556         return filledTakerTokenAmount;
557     }
558 
559     /// @dev Synchronously cancels multiple orders in a single transaction.
560     /// @param orderAddresses Array of address arrays containing individual order addresses.
561     /// @param orderValues Array of uint arrays containing individual order values.
562     /// @param cancelTakerTokenAmounts Array of desired amounts of takerToken to cancel in orders.
563     // function batchCancelOrders(
564     //     address[5][] orderAddresses,
565     //     uint[6][] orderValues,
566     //     uint[] cancelTakerTokenAmounts)
567     //     public
568     // {
569     //     for (uint i = 0; i < orderAddresses.length; i++) {
570     //         cancelOrder(
571     //             orderAddresses[i],
572     //             orderValues[i],
573     //             cancelTakerTokenAmounts[i]
574     //         );
575     //     }
576     // }
577 
578     /*
579     * Constant public functions
580     */
581 
582     /// @dev Calculates Keccak-256 hash of order with specified parameters.
583     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
584     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
585     /// @return Keccak-256 hash of order.
586     function getOrderHash(address[5] orderAddresses, uint[6] orderValues)
587         public
588         constant
589         returns (bytes32)
590     {
591         return keccak256(
592             address(this),
593             orderAddresses[0], // maker
594             orderAddresses[1], // taker
595             orderAddresses[2], // makerToken
596             orderAddresses[3], // takerToken
597             orderAddresses[4], // feeRecipient
598             orderValues[0],    // makerTokenAmount
599             orderValues[1],    // takerTokenAmount
600             orderValues[2],    // makerFee
601             orderValues[3],    // takerFee
602             orderValues[4],    // expirationTimestampInSec
603             orderValues[5]     // salt
604         );
605     }
606 
607     /// @dev Verifies that an order signature is valid.
608     /// @param signer address of signer.
609     /// @param hash Signed Keccak-256 hash.
610     /// @param v ECDSA signature parameter v.
611     /// @param r ECDSA signature parameters r.
612     /// @param s ECDSA signature parameters s.
613     /// @return Validity of order signature.
614     function isValidSignature(
615         address signer,
616         bytes32 hash,
617         uint8 v,
618         bytes32 r,
619         bytes32 s)
620         public
621         pure
622         returns (bool)
623     {
624         return signer == ecrecover(
625             keccak256("\x19Ethereum Signed Message:\n32", hash),
626             v,
627             r,
628             s
629         );
630     }
631 
632     /// @dev Checks if rounding error > 0.1%.
633     /// @param numerator Numerator.
634     /// @param denominator Denominator.
635     /// @param target Value to multiply with numerator/denominator.
636     /// @return Rounding error is present.
637     function isRoundingError(uint numerator, uint denominator, uint target)
638         public
639         pure
640         returns (bool)
641     {
642         uint remainder = mulmod(target, numerator, denominator);
643         if (remainder == 0) return false; // No rounding error.
644 
645         uint errPercentageTimes1000000 = safeDiv(
646             safeMul(remainder, 1000000),
647             safeMul(numerator, target)
648         );
649         return errPercentageTimes1000000 > 1000;
650     }
651 
652     /// @dev Calculates partial value given a numerator and denominator.
653     /// @param numerator Numerator.
654     /// @param denominator Denominator.
655     /// @param target Value to calculate partial of.
656     /// @return Partial value of target.
657     function getPartialAmount(uint numerator, uint denominator, uint target)
658         public
659         pure
660         returns (uint)
661     {
662         return safeDiv(safeMul(numerator, target), denominator);
663     }
664 
665     /// @dev Calculates the sum of values already filled and cancelled for a given order.
666     /// @param orderHash The Keccak-256 hash of the given order.
667     /// @return Sum of values already filled and cancelled.
668     function getUnavailableTakerTokenAmount(bytes32 orderHash)
669         public
670         constant
671         returns (uint)
672     {
673         return safeAdd(filled[orderHash], cancelled[orderHash]);
674     }
675 
676 
677     /*
678     * Internal functions
679     */
680 
681     /// @dev Transfers a token using TokenTransferProxy transferFrom function.
682     /// @param token Address of token to transferFrom.
683     /// @param from Address transfering token.
684     /// @param to Address receiving token.
685     /// @param value Amount of token to transfer.
686     /// @return Success of token transfer.
687     function transferViaTokenTransferProxy(
688         address token,
689         address from,
690         address to,
691         uint value)
692         internal
693         returns (bool)
694     {
695         return TokenTransferProxy(TOKEN_TRANSFER_PROXY_CONTRACT).transferFrom(token, from, to, value);
696     }
697 
698     /// @dev Checks if any order transfers will fail.
699     /// @param order Order struct of params that will be checked.
700     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
701     /// @return Predicted result of transfers.
702     function isTransferable(Order order, uint fillTakerTokenAmount)
703         internal
704         constant  // The called token contracts may attempt to change state, but will not be able to due to gas limits on getBalance and getAllowance.
705         returns (bool)
706     {
707         address taker = msg.sender;
708         uint fillMakerTokenAmount = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
709 
710         // if (order.feeRecipient != address(0)) {
711         //     bool isMakerTokenZRX = order.makerToken == ZRX_TOKEN_CONTRACT;
712         //     bool isTakerTokenZRX = order.takerToken == ZRX_TOKEN_CONTRACT;
713         //     uint paidMakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerFee);
714         //     uint paidTakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.takerFee);
715         //     uint requiredMakerZRX = isMakerTokenZRX ? safeAdd(fillMakerTokenAmount, paidMakerFee) : paidMakerFee;
716         //     uint requiredTakerZRX = isTakerTokenZRX ? safeAdd(fillTakerTokenAmount, paidTakerFee) : paidTakerFee;
717 
718         //     if (   getBalance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
719         //         || getAllowance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
720         //         || getBalance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
721         //         || getAllowance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
722         //     ) return false;
723 
724         //     if (!isMakerTokenZRX && (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount // Don't double check makerToken if ZRX
725         //                              || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount)
726         //     ) return false;
727         //     if (!isTakerTokenZRX && (   getBalance(order.takerToken, taker) < fillTakerTokenAmount // Don't double check takerToken if ZRX
728         //                              || getAllowance(order.takerToken, taker) < fillTakerTokenAmount)
729         //     ) return false;
730         // } else if (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount
731         //            || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount
732         //            || getBalance(order.takerToken, taker) < fillTakerTokenAmount
733         //            || getAllowance(order.takerToken, taker) < fillTakerTokenAmount
734         // ) return false;
735 
736         ///////// added code, copied from above ///////
737 
738         if (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount
739                    || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount
740                    || getBalance(order.takerToken, taker) < fillTakerTokenAmount
741                    || getAllowance(order.takerToken, taker) < fillTakerTokenAmount
742         ) return false;
743 
744         return true;
745     }
746 
747     /// @dev Get token balance of an address.
748     /// @param token Address of token.
749     /// @param owner Address of owner.
750     /// @return Token balance of owner.
751     function getBalance(address token, address owner)
752         internal
753         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
754         returns (uint)
755     {
756         return Token(token).balanceOf.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner); // Limit gas to prevent reentrancy
757     }
758 
759     /// @dev Get allowance of token given to TokenTransferProxy by an address.
760     /// @param token Address of token.
761     /// @param owner Address of owner.
762     /// @return Allowance of token given to TokenTransferProxy by owner.
763     function getAllowance(address token, address owner)
764         internal
765         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
766         returns (uint)
767     {
768         return Token(token).allowance.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner, TOKEN_TRANSFER_PROXY_CONTRACT); // Limit gas to prevent reentrancy
769     }
770 }