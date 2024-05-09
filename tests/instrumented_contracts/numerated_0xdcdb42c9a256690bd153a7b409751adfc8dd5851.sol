1 /*
2 
3   Copyright 2018 Ethfinex Inc
4 
5   This is a derivative work based on software developed by ZeroEx Intl
6   This and the original are licensed under Apache License, Version 2.0
7 
8   Original attribution:
9 
10   Copyright 2017 ZeroEx Intl.
11 
12   Licensed under the Apache License, Version 2.0 (the "License");
13   you may not use this file except in compliance with the License.
14   You may obtain a copy of the License at
15 
16     http://www.apache.org/licenses/LICENSE-2.0
17 
18   Unless required by applicable law or agreed to in writing, software
19   distributed under the License is distributed on an "AS IS" BASIS,
20   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
21   See the License for the specific language governing permissions and
22   limitations under the License.
23 
24 */
25 
26 pragma solidity 0.4.19; // MUST BE COMPILED WITH COMPILER VERSION 0.4.19
27 
28 contract Owned { address public owner; } // GR ADDITION
29 
30 interface Token {
31 
32     /// @notice send `_value` token to `_to` from `msg.sender`
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transfer(address _to, uint _value) public returns (bool);
37 
38     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
39     /// @param _from The address of the sender
40     /// @param _to The address of the recipient
41     /// @param _value The amount of token to be transferred
42     /// @return Whether the transfer was successful or not
43     function transferFrom(address _from, address _to, uint _value) public returns (bool);
44 
45     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
46     /// @param _spender The address of the account able to transfer the tokens
47     /// @param _value The amount of wei to be approved for transfer
48     /// @return Whether the approval was successful or not
49     function approve(address _spender, uint _value) public returns (bool);
50 
51     /// @param _owner The address from which the balance will be retrieved
52     /// @return The balance
53     function balanceOf(address _owner) public view returns (uint);
54 
55     /// @param _owner The address of the account owning tokens
56     /// @param _spender The address of the account able to transfer the tokens
57     /// @return Amount of remaining tokens allowed to spent
58     function allowance(address _owner, address _spender) public view returns (uint);
59 
60     event Transfer(address indexed _from, address indexed _to, uint _value); // solhint-disable-line
61     event Approval(address indexed _owner, address indexed _spender, uint _value);
62 }
63 
64 
65 //solhint-disable-next-line
66 /// @title TokenTransferProxy - Transfers tokens on behalf of exchange
67 /// @author Ahmed Ali <Ahmed@bitfinex.com>
68 contract TokenTransferProxy {
69 
70     modifier onlyExchange {
71         require(msg.sender == exchangeAddress);
72         _;
73     }
74 
75     address public exchangeAddress;
76 
77 
78     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
79 
80     function TokenTransferProxy() public {
81         setExchange(msg.sender);
82     }
83     /*
84      * Public functions
85      */
86 
87     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
88     /// @param token Address of token to transfer.
89     /// @param from Address to transfer token from.
90     /// @param to Address to transfer token to.
91     /// @param value Amount of token to transfer.
92     /// @return Success of transfer.
93     function transferFrom(
94         address token,
95         address from,
96         address to,
97         uint value)
98         public
99         onlyExchange
100         returns (bool)
101     {
102         return Token(token).transferFrom(from, to, value);
103     }
104 
105     /// @dev Used to set exchange address
106     /// @param _exchange the address of the exchange
107     function setExchange(address _exchange) internal {
108         require(exchangeAddress == address(0));
109         exchangeAddress = _exchange;
110     }
111 }
112 
113 contract SafeMath {
114     function safeMul(uint a, uint b)
115         internal
116         pure
117         returns (uint256)
118     {
119         uint c = a * b;
120         assert(a == 0 || c / a == b);
121         return c;
122     }
123 
124     function safeDiv(uint a, uint b)
125         internal
126         pure
127         returns (uint256)
128     {
129         uint c = a / b;
130         return c;
131     }
132 
133     function safeSub(uint a, uint b)
134         internal
135         pure
136         returns (uint256)
137     {
138         assert(b <= a);
139         return a - b;
140     }
141 
142     function safeAdd(uint a, uint b)
143         internal
144         pure
145         returns (uint256)
146     {
147         uint c = a + b;
148         assert(c >= a);
149         return c;
150     }
151 
152     function max64(uint64 a, uint64 b)
153         internal
154         pure
155         returns (uint256)
156     {
157         return a >= b ? a : b;
158     }
159 
160     function min64(uint64 a, uint64 b)
161         internal
162         pure
163         returns (uint256)
164     {
165         return a < b ? a : b;
166     }
167 
168     function max256(uint256 a, uint256 b)
169         internal
170         pure
171         returns (uint256)
172     {
173         return a >= b ? a : b;
174     }
175 
176     function min256(uint256 a, uint256 b)
177         internal
178         pure
179         returns (uint256)
180     {
181         return a < b ? a : b;
182     }
183 }
184 
185 
186 /// @title ExchangeEfx - Facilitates exchange of ERC20 tokens.
187 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
188 // Modified by Ahmed Ali <Ahmed@bitfinex.com>
189 contract ExchangeEfx is SafeMath {
190 
191     // Error Codes
192     enum Errors {
193         ORDER_EXPIRED,                    // Order has already expired
194         ORDER_FULLY_FILLED_OR_CANCELLED,  // Order has already been fully filled or cancelled
195         ROUNDING_ERROR_TOO_LARGE,         // Rounding error too large
196         INSUFFICIENT_BALANCE_OR_ALLOWANCE // Insufficient balance or allowance for token transfer
197     }
198 
199     string constant public VERSION = "ETHFX.0.0";
200     uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 4999;    // Changes to state require at least 5000 gas
201     uint constant public ETHFINEX_FEE = 400; // Amount - (Amount/fee) is what gets send to user
202 
203     // address public TOKEN_TRANSFER_PROXY_CONTRACT;
204     address public TOKEN_TRANSFER_PROXY_CONTRACT;
205 
206     // Mappings of orderHash => amounts of takerTokenAmount filled or cancelled.
207     mapping (bytes32 => uint) public filled;
208     mapping (bytes32 => uint) public cancelled;
209 
210     // GR ADDITION
211     // Mapping of signer => validator => approved
212     mapping (address => mapping (address => bool)) public allowedValidators;
213 
214     event LogFill(
215         address indexed maker,
216         address taker,
217         address indexed feeRecipient,
218         address makerToken,
219         address takerToken,
220         uint filledMakerTokenAmount,
221         uint filledTakerTokenAmount,
222         uint paidMakerFee,
223         uint paidTakerFee,
224         bytes32 indexed tokens, // keccak256(makerToken, takerToken), allows subscribing to a token pair
225         bytes32 orderHash
226     );
227 
228     event LogCancel(
229         address indexed maker,
230         address indexed feeRecipient,
231         address makerToken,
232         address takerToken,
233         uint cancelledMakerTokenAmount,
234         uint cancelledTakerTokenAmount,
235         bytes32 indexed tokens,
236         bytes32 orderHash
237     );
238 
239     event LogError(uint8 indexed errorId, bytes32 indexed orderHash);
240 
241     event SignatureValidatorApproval(
242         address indexed signerAddress,     // Address that approves or disapproves a contract to verify signatures.
243         address indexed validatorAddress,  // Address of signature validator contract.
244         bool approved                      // Approval or disapproval of validator contract.
245     );
246 
247     struct Order {
248         address maker;
249         address taker;
250         address makerToken;
251         address takerToken;
252         address feeRecipient;
253         uint makerTokenAmount;
254         uint takerTokenAmount;
255         uint makerFee;
256         uint takerFee;
257         uint expirationTimestampInSec;
258         bytes32 orderHash;
259     }
260 
261     // MODIFIED CODE, constructor changed
262     function ExchangeEfx() public {
263         // ZRX_TOKEN_CONTRACT = _zrxToken;
264         TOKEN_TRANSFER_PROXY_CONTRACT = address(new TokenTransferProxy());
265     }
266 
267     /*
268     * Core exchange functions
269     */
270 
271     /// @dev Fills the input order.
272     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
273     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
274     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
275     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfer will fail before attempting.
276     /// @param v ECDSA signature parameter v.
277     /// @param r ECDSA signature parameters r.
278     /// @param s ECDSA signature parameters s.
279     /// @return Total amount of takerToken filled in trade.
280     function fillOrder(
281           address[5] orderAddresses,
282           uint[6] orderValues,
283           uint fillTakerTokenAmount,
284           bool shouldThrowOnInsufficientBalanceOrAllowance,
285           uint8 v,
286           bytes32 r,
287           bytes32 s)
288           public
289           returns (uint filledTakerTokenAmount)
290     {
291         Order memory order = Order({
292             maker: orderAddresses[0],
293             taker: orderAddresses[1],
294             makerToken: orderAddresses[2],
295             takerToken: orderAddresses[3],
296             feeRecipient: orderAddresses[4],
297             makerTokenAmount: orderValues[0],
298             takerTokenAmount: orderValues[1],
299             makerFee: orderValues[2],
300             takerFee: orderValues[3],
301             expirationTimestampInSec: orderValues[4],
302             orderHash: getOrderHash(orderAddresses, orderValues)
303         });
304 
305         require(order.taker == address(0) || order.taker == msg.sender);
306         require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && fillTakerTokenAmount > 0);
307 
308         require(isValidSignature(
309             order.maker,
310             order.orderHash,
311             v,
312             r,
313             s
314         ));
315 
316         if (block.timestamp >= order.expirationTimestampInSec) {
317             LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
318             return 0;
319         }
320 
321         uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
322         filledTakerTokenAmount = min256(fillTakerTokenAmount, remainingTakerTokenAmount);
323         if (filledTakerTokenAmount == 0) {
324             LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
325             return 0;
326         }
327 
328         if (isRoundingError(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount)) {
329             LogError(uint8(Errors.ROUNDING_ERROR_TOO_LARGE), order.orderHash);
330             return 0;
331         }
332 
333         if (!shouldThrowOnInsufficientBalanceOrAllowance && !isTransferable(order, filledTakerTokenAmount)) {
334             LogError(uint8(Errors.INSUFFICIENT_BALANCE_OR_ALLOWANCE), order.orderHash);
335             return 0;
336         }
337 
338         /////////////// modified code /////////////////
339         uint filledMakerTokenAmount = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
340         ///////////// modified code ///////////
341 
342         uint paidMakerFee;
343         uint paidTakerFee;
344         filled[order.orderHash] = safeAdd(filled[order.orderHash], filledTakerTokenAmount);
345         require(transferViaTokenTransferProxy(
346             order.makerToken,
347             order.maker,
348             msg.sender,
349             filledMakerTokenAmount
350         ));
351         require(transferViaTokenTransferProxy(
352             order.takerToken,
353             msg.sender,
354             order.maker,
355             filledTakerTokenAmount - safeDiv(filledTakerTokenAmount, ETHFINEX_FEE)
356         ));
357         // if (order.feeRecipient != address(0)) {
358         //     if (order.makerFee > 0) {
359         //         paidMakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerFee);
360         //         require(transferViaTokenTransferProxy(
361         //             ZRX_TOKEN_CONTRACT,
362         //             order.maker,
363         //             order.feeRecipient,
364         //             paidMakerFee
365         //         ));
366         //     }
367         //     if (order.takerFee > 0) {
368         //         paidTakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.takerFee);
369         //         require(transferViaTokenTransferProxy(
370         //             ZRX_TOKEN_CONTRACT,
371         //             msg.sender,
372         //             order.feeRecipient,
373         //             paidTakerFee
374         //         ));
375         //     }
376         // }
377 
378         LogFill(
379             order.maker,
380             msg.sender,
381             order.feeRecipient,
382             order.makerToken,
383             order.takerToken,
384             filledMakerTokenAmount,
385             filledTakerTokenAmount,
386             paidMakerFee,
387             paidTakerFee,
388             keccak256(order.makerToken, order.takerToken),
389             order.orderHash
390         );
391         return filledTakerTokenAmount;
392     }
393 
394     /// @dev Cancels the input order.
395     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
396     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
397     /// @param cancelTakerTokenAmount Desired amount of takerToken to cancel in order.
398     /// @return Amount of takerToken cancelled.
399     // function cancelOrder(
400     //     address[5] orderAddresses,
401     //     uint[6] orderValues,
402     //     uint cancelTakerTokenAmount)
403     //     public
404     //     returns (uint)
405     // {
406     //     Order memory order = Order({
407     //         maker: orderAddresses[0],
408     //         taker: orderAddresses[1],
409     //         makerToken: orderAddresses[2],
410     //         takerToken: orderAddresses[3],
411     //         feeRecipient: orderAddresses[4],
412     //         makerTokenAmount: orderValues[0],
413     //         takerTokenAmount: orderValues[1],
414     //         makerFee: orderValues[2],
415     //         takerFee: orderValues[3],
416     //         expirationTimestampInSec: orderValues[4],
417     //         orderHash: getOrderHash(orderAddresses, orderValues)
418     //     });
419 
420     //     require(order.maker == msg.sender);
421     //     require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && cancelTakerTokenAmount > 0);
422 
423     //     if (block.timestamp >= order.expirationTimestampInSec) {
424     //         LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
425     //         return 0;
426     //     }
427 
428     //     uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
429     //     uint cancelledTakerTokenAmount = min256(cancelTakerTokenAmount, remainingTakerTokenAmount);
430     //     if (cancelledTakerTokenAmount == 0) {
431     //         LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
432     //         return 0;
433     //     }
434 
435     //     cancelled[order.orderHash] = safeAdd(cancelled[order.orderHash], cancelledTakerTokenAmount);
436 
437     //     LogCancel(
438     //         order.maker,
439     //         order.feeRecipient,
440     //         order.makerToken,
441     //         order.takerToken,
442     //         getPartialAmount(cancelledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount),
443     //         cancelledTakerTokenAmount,
444     //         keccak256(order.makerToken, order.takerToken),
445     //         order.orderHash
446     //     );
447     //     return cancelledTakerTokenAmount;
448     // }
449 
450     /*
451     * Wrapper functions
452     */
453 
454     /// @dev Fills an order with specified parameters and ECDSA signature, throws if specified amount not filled entirely.
455     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
456     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
457     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
458     /// @param v ECDSA signature parameter v.
459     /// @param r ECDSA signature parameters r.
460     /// @param s ECDSA signature parameters s.
461     function fillOrKillOrder(
462         address[5] orderAddresses,
463         uint[6] orderValues,
464         uint fillTakerTokenAmount,
465         uint8 v,
466         bytes32 r,
467         bytes32 s)
468         public
469     {
470         require(fillOrder(
471             orderAddresses,
472             orderValues,
473             fillTakerTokenAmount,
474             false,
475             v,
476             r,
477             s
478         ) == fillTakerTokenAmount);
479     }
480 
481     /// @dev Synchronously executes multiple fill orders in a single transaction.
482     /// @param orderAddresses Array of address arrays containing individual order addresses.
483     /// @param orderValues Array of uint arrays containing individual order values.
484     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
485     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
486     /// @param v Array ECDSA signature v parameters.
487     /// @param r Array of ECDSA signature r parameters.
488     /// @param s Array of ECDSA signature s parameters.
489     function batchFillOrders(
490         address[5][] orderAddresses,
491         uint[6][] orderValues,
492         uint[] fillTakerTokenAmounts,
493         bool shouldThrowOnInsufficientBalanceOrAllowance,
494         uint8[] v,
495         bytes32[] r,
496         bytes32[] s)
497         public
498     {
499         for (uint i = 0; i < orderAddresses.length; i++) {
500             fillOrder(
501                 orderAddresses[i],
502                 orderValues[i],
503                 fillTakerTokenAmounts[i],
504                 shouldThrowOnInsufficientBalanceOrAllowance,
505                 v[i],
506                 r[i],
507                 s[i]
508             );
509         }
510     }
511 
512     /// @dev Synchronously executes multiple fillOrKill orders in a single transaction.
513     /// @param orderAddresses Array of address arrays containing individual order addresses.
514     /// @param orderValues Array of uint arrays containing individual order values.
515     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
516     /// @param v Array ECDSA signature v parameters.
517     /// @param r Array of ECDSA signature r parameters.
518     /// @param s Array of ECDSA signature s parameters.
519     function batchFillOrKillOrders(
520         address[5][] orderAddresses,
521         uint[6][] orderValues,
522         uint[] fillTakerTokenAmounts,
523         uint8[] v,
524         bytes32[] r,
525         bytes32[] s)
526         public
527     {
528         for (uint i = 0; i < orderAddresses.length; i++) {
529             fillOrKillOrder(
530                 orderAddresses[i],
531                 orderValues[i],
532                 fillTakerTokenAmounts[i],
533                 v[i],
534                 r[i],
535                 s[i]
536             );
537         }
538     }
539 
540     /// @dev Synchronously executes multiple fill orders in a single transaction until total fillTakerTokenAmount filled.
541     /// @param orderAddresses Array of address arrays containing individual order addresses.
542     /// @param orderValues Array of uint arrays containing individual order values.
543     /// @param fillTakerTokenAmount Desired total amount of takerToken to fill in orders.
544     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
545     /// @param v Array ECDSA signature v parameters.
546     /// @param r Array of ECDSA signature r parameters.
547     /// @param s Array of ECDSA signature s parameters.
548     /// @return Total amount of fillTakerTokenAmount filled in orders.
549     function fillOrdersUpTo(
550         address[5][] orderAddresses,
551         uint[6][] orderValues,
552         uint fillTakerTokenAmount,
553         bool shouldThrowOnInsufficientBalanceOrAllowance,
554         uint8[] v,
555         bytes32[] r,
556         bytes32[] s)
557         public
558         returns (uint)
559     {
560         uint filledTakerTokenAmount = 0;
561         for (uint i = 0; i < orderAddresses.length; i++) {
562             require(orderAddresses[i][3] == orderAddresses[0][3]); // takerToken must be the same for each order
563             filledTakerTokenAmount = safeAdd(filledTakerTokenAmount, fillOrder(
564                 orderAddresses[i],
565                 orderValues[i],
566                 safeSub(fillTakerTokenAmount, filledTakerTokenAmount),
567                 shouldThrowOnInsufficientBalanceOrAllowance,
568                 v[i],
569                 r[i],
570                 s[i]
571             ));
572             if (filledTakerTokenAmount == fillTakerTokenAmount) break;
573         }
574         return filledTakerTokenAmount;
575     }
576 
577     /// @dev Synchronously cancels multiple orders in a single transaction.
578     /// @param orderAddresses Array of address arrays containing individual order addresses.
579     /// @param orderValues Array of uint arrays containing individual order values.
580     /// @param cancelTakerTokenAmounts Array of desired amounts of takerToken to cancel in orders.
581     // function batchCancelOrders(
582     //     address[5][] orderAddresses,
583     //     uint[6][] orderValues,
584     //     uint[] cancelTakerTokenAmounts)
585     //     public
586     // {
587     //     for (uint i = 0; i < orderAddresses.length; i++) {
588     //         cancelOrder(
589     //             orderAddresses[i],
590     //             orderValues[i],
591     //             cancelTakerTokenAmounts[i]
592     //         );
593     //     }
594     // }
595 
596     /*
597     * Constant public functions
598     */
599 
600     /// @dev Calculates Keccak-256 hash of order with specified parameters.
601     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
602     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
603     /// @return Keccak-256 hash of order.
604     function getOrderHash(address[5] orderAddresses, uint[6] orderValues)
605         public
606         constant
607         returns (bytes32)
608     {
609         return keccak256(
610             address(this),
611             orderAddresses[0], // maker
612             orderAddresses[1], // taker
613             orderAddresses[2], // makerToken
614             orderAddresses[3], // takerToken
615             orderAddresses[4], // feeRecipient
616             orderValues[0],    // makerTokenAmount
617             orderValues[1],    // takerTokenAmount
618             orderValues[2],    // makerFee
619             orderValues[3],    // takerFee
620             orderValues[4],    // expirationTimestampInSec
621             orderValues[5]     // salt
622         );
623     }
624 
625 
626     /// @dev Verifies that an order signature is valid.
627     /// @param maker address of maker.
628     /// @param hash Signed Keccak-256 hash.
629     /// @param v ECDSA signature parameter v.
630     /// @param r ECDSA signature parameters r.
631     /// @param s ECDSA signature parameters s.
632     /// @return Validity of order signature.
633     function isValidSignature(
634         address maker,
635         bytes32 hash,
636         uint8 v,
637         bytes32 r,
638         bytes32 s)
639         public
640         //pure
641         view // GR ADDITION
642         returns (bool)
643     {
644         address validator = ecrecover(
645             keccak256("\x19Ethereum Signed Message:\n32", hash),
646             v,
647             r,
648             s
649         );
650 
651         if (allowedValidators[maker][validator]) {
652             return true;
653         } else if (isContract(maker)) {
654             return Owned(maker).owner() == validator;
655         } else {
656             return maker == validator;
657         }
658     }
659 
660     /// @dev Checks if rounding error > 0.1%.
661     /// @param numerator Numerator.
662     /// @param denominator Denominator.
663     /// @param target Value to multiply with numerator/denominator.
664     /// @return Rounding error is present.
665     function isRoundingError(uint numerator, uint denominator, uint target)
666         public
667         pure
668         returns (bool)
669     {
670         uint remainder = mulmod(target, numerator, denominator);
671         if (remainder == 0) return false; // No rounding error.
672 
673         uint errPercentageTimes1000000 = safeDiv(
674             safeMul(remainder, 1000000),
675             safeMul(numerator, target)
676         );
677         return errPercentageTimes1000000 > 1000;
678     }
679 
680     /// @dev Calculates partial value given a numerator and denominator.
681     /// @param numerator Numerator.
682     /// @param denominator Denominator.
683     /// @param target Value to calculate partial of.
684     /// @return Partial value of target.
685     function getPartialAmount(uint numerator, uint denominator, uint target)
686         public
687         pure
688         returns (uint)
689     {
690         return safeDiv(safeMul(numerator, target), denominator);
691     }
692 
693     /// @dev Calculates the sum of values already filled and cancelled for a given order.
694     /// @param orderHash The Keccak-256 hash of the given order.
695     /// @return Sum of values already filled and cancelled.
696     function getUnavailableTakerTokenAmount(bytes32 orderHash)
697         public
698         constant
699         returns (uint)
700     {
701         return safeAdd(filled[orderHash], cancelled[orderHash]);
702     }
703 
704 
705     /*
706     * Internal functions
707     */
708 
709     /// @dev Transfers a token using TokenTransferProxy transferFrom function.
710     /// @param token Address of token to transferFrom.
711     /// @param from Address transfering token.
712     /// @param to Address receiving token.
713     /// @param value Amount of token to transfer.
714     /// @return Success of token transfer.
715     function transferViaTokenTransferProxy(
716         address token,
717         address from,
718         address to,
719         uint value)
720         internal
721         returns (bool)
722     {
723         return TokenTransferProxy(TOKEN_TRANSFER_PROXY_CONTRACT).transferFrom(token, from, to, value);
724     }
725 
726     /// @dev Checks if any order transfers will fail.
727     /// @param order Order struct of params that will be checked.
728     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
729     /// @return Predicted result of transfers.
730     function isTransferable(Order order, uint fillTakerTokenAmount)
731         internal
732         constant  // The called token contracts may attempt to change state, but will not be able to due to gas limits on getBalance and getAllowance.
733         returns (bool)
734     {
735         address taker = msg.sender;
736         uint fillMakerTokenAmount = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
737 
738         // if (order.feeRecipient != address(0)) {
739         //     bool isMakerTokenZRX = order.makerToken == ZRX_TOKEN_CONTRACT;
740         //     bool isTakerTokenZRX = order.takerToken == ZRX_TOKEN_CONTRACT;
741         //     uint paidMakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerFee);
742         //     uint paidTakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.takerFee);
743         //     uint requiredMakerZRX = isMakerTokenZRX ? safeAdd(fillMakerTokenAmount, paidMakerFee) : paidMakerFee;
744         //     uint requiredTakerZRX = isTakerTokenZRX ? safeAdd(fillTakerTokenAmount, paidTakerFee) : paidTakerFee;
745 
746         //     if (   getBalance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
747         //         || getAllowance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
748         //         || getBalance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
749         //         || getAllowance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
750         //     ) return false;
751 
752         //     if (!isMakerTokenZRX && (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount // Don't double check makerToken if ZRX
753         //                              || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount)
754         //     ) return false;
755         //     if (!isTakerTokenZRX && (   getBalance(order.takerToken, taker) < fillTakerTokenAmount // Don't double check takerToken if ZRX
756         //                              || getAllowance(order.takerToken, taker) < fillTakerTokenAmount)
757         //     ) return false;
758         // } else if (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount
759         //            || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount
760         //            || getBalance(order.takerToken, taker) < fillTakerTokenAmount
761         //            || getAllowance(order.takerToken, taker) < fillTakerTokenAmount
762         // ) return false;
763 
764         ///////// added code, copied from above ///////
765 
766         if (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount
767                    || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount
768                    || getBalance(order.takerToken, taker) < fillTakerTokenAmount
769                    || getAllowance(order.takerToken, taker) < fillTakerTokenAmount
770         ) return false;
771 
772         return true;
773     }
774 
775     /// @dev Get token balance of an address.
776     /// @param token Address of token.
777     /// @param owner Address of owner.
778     /// @return Token balance of owner.
779     function getBalance(address token, address owner)
780         internal
781         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
782         returns (uint)
783     {
784         return Token(token).balanceOf.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner); // Limit gas to prevent reentrancy
785     }
786 
787     /// @dev Get allowance of token given to TokenTransferProxy by an address.
788     /// @param token Address of token.
789     /// @param owner Address of owner.
790     /// @return Allowance of token given to TokenTransferProxy by owner.
791     function getAllowance(address token, address owner)
792         internal
793         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
794         returns (uint)
795     {
796         return Token(token).allowance.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner, TOKEN_TRANSFER_PROXY_CONTRACT); // Limit gas to prevent reentrancy
797     }
798 
799     // GR ADDITION
800     /// @dev Determines whether an address is an account or a contract
801     /// @param _target Address to be inspected
802     /// @return Boolean the address is a contract
803     /// @notice if it is a contract, we use this function to lookup for the owner
804     function isContract(address _target)
805         internal view
806         returns (bool)
807     {
808         uint size;
809         assembly {
810             size := extcodesize(_target)
811         }
812         return size > 0;
813     }
814 
815     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
816     /// @param validatorAddress Address of Validator contract.
817     /// @param approval Approval or disapproval of  Validator contract.
818     function setSignatureValidatorApproval(
819         address validatorAddress,
820         bool approval
821     )
822         external
823     {
824         address signerAddress = msg.sender;
825         allowedValidators[signerAddress][validatorAddress] = approval;
826         SignatureValidatorApproval(
827             signerAddress,
828             validatorAddress,
829             approval
830         );
831     }
832 }