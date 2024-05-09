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
19 pragma solidity 0.4.14;
20 
21 /*
22  * Ownable
23  *
24  * Base contract with an owner.
25  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
26  */
27 contract Ownable {
28     address public owner;
29 
30     function Ownable() {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) onlyOwner {
40         if (newOwner != address(0)) {
41             owner = newOwner;
42         }
43     }
44 }
45 
46 contract Token {
47 
48     /// @return total amount of tokens
49     function totalSupply() constant returns (uint supply) {}
50 
51     /// @param _owner The address from which the balance will be retrieved
52     /// @return The balance
53     function balanceOf(address _owner) constant returns (uint balance) {}
54 
55     /// @notice send `_value` token to `_to` from `msg.sender`
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transfer(address _to, uint _value) returns (bool success) {}
60 
61     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
62     /// @param _from The address of the sender
63     /// @param _to The address of the recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
67 
68     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @param _value The amount of wei to be approved for transfer
71     /// @return Whether the approval was successful or not
72     function approve(address _spender, uint _value) returns (bool success) {}
73 
74     /// @param _owner The address of the account owning tokens
75     /// @param _spender The address of the account able to transfer the tokens
76     /// @return Amount of remaining tokens allowed to spent
77     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
78 
79     event Transfer(address indexed _from, address indexed _to, uint _value);
80     event Approval(address indexed _owner, address indexed _spender, uint _value);
81 }
82 
83 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
84 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
85 contract TokenTransferProxy is Ownable {
86 
87     /// @dev Only authorized addresses can invoke functions with this modifier.
88     modifier onlyAuthorized {
89         require(authorized[msg.sender]);
90         _;
91     }
92 
93     modifier targetAuthorized(address target) {
94         require(authorized[target]);
95         _;
96     }
97 
98     modifier targetNotAuthorized(address target) {
99         require(!authorized[target]);
100         _;
101     }
102 
103     mapping (address => bool) public authorized;
104     address[] public authorities;
105 
106     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
107     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
108 
109     /*
110      * Public functions
111      */
112 
113     /// @dev Authorizes an address.
114     /// @param target Address to authorize.
115     function addAuthorizedAddress(address target)
116         public
117         onlyOwner
118         targetNotAuthorized(target)
119     {
120         authorized[target] = true;
121         authorities.push(target);
122         LogAuthorizedAddressAdded(target, msg.sender);
123     }
124 
125     /// @dev Removes authorizion of an address.
126     /// @param target Address to remove authorization from.
127     function removeAuthorizedAddress(address target)
128         public
129         onlyOwner
130         targetAuthorized(target)
131     {
132         delete authorized[target];
133         for (uint i = 0; i < authorities.length; i++) {
134             if (authorities[i] == target) {
135                 authorities[i] = authorities[authorities.length - 1];
136                 authorities.length -= 1;
137                 break;
138             }
139         }
140         LogAuthorizedAddressRemoved(target, msg.sender);
141     }
142 
143     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
144     /// @param token Address of token to transfer.
145     /// @param from Address to transfer token from.
146     /// @param to Address to transfer token to.
147     /// @param value Amount of token to transfer.
148     /// @return Success of transfer.
149     function transferFrom(
150         address token,
151         address from,
152         address to,
153         uint value)
154         public
155         onlyAuthorized
156         returns (bool)
157     {
158         return Token(token).transferFrom(from, to, value);
159     }
160 
161     /*
162      * Public constant functions
163      */
164 
165     /// @dev Gets all authorized addresses.
166     /// @return Array of authorized addresses.
167     function getAuthorizedAddresses()
168         public
169         constant
170         returns (address[])
171     {
172         return authorities;
173     }
174 }
175 
176 contract SafeMath {
177     function safeMul(uint a, uint b) internal constant returns (uint256) {
178         uint c = a * b;
179         assert(a == 0 || c / a == b);
180         return c;
181     }
182 
183     function safeDiv(uint a, uint b) internal constant returns (uint256) {
184         uint c = a / b;
185         return c;
186     }
187 
188     function safeSub(uint a, uint b) internal constant returns (uint256) {
189         assert(b <= a);
190         return a - b;
191     }
192 
193     function safeAdd(uint a, uint b) internal constant returns (uint256) {
194         uint c = a + b;
195         assert(c >= a);
196         return c;
197     }
198 
199     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
200         return a >= b ? a : b;
201     }
202 
203     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
204         return a < b ? a : b;
205     }
206 
207     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
208         return a >= b ? a : b;
209     }
210 
211     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
212         return a < b ? a : b;
213     }
214 }
215 
216 /// @title Exchange - Facilitates exchange of ERC20 tokens.
217 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
218 contract Exchange is SafeMath {
219 
220     // Error Codes
221     enum Errors {
222         ORDER_EXPIRED,                    // Order has already expired
223         ORDER_FULLY_FILLED_OR_CANCELLED,  // Order has already been fully filled or cancelled
224         ROUNDING_ERROR_TOO_LARGE,         // Rounding error too large
225         INSUFFICIENT_BALANCE_OR_ALLOWANCE // Insufficient balance or allowance for token transfer
226     }
227 
228     string constant public VERSION = "1.0.0";
229     uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 4999;    // Changes to state require at least 5000 gas
230 
231     address public ZRX_TOKEN_CONTRACT;
232     address public TOKEN_TRANSFER_PROXY_CONTRACT;
233 
234     // Mappings of orderHash => amounts of takerTokenAmount filled or cancelled.
235     mapping (bytes32 => uint) public filled;
236     mapping (bytes32 => uint) public cancelled;
237 
238     event LogFill(
239         address indexed maker,
240         address taker,
241         address indexed feeRecipient,
242         address makerToken,
243         address takerToken,
244         uint filledMakerTokenAmount,
245         uint filledTakerTokenAmount,
246         uint paidMakerFee,
247         uint paidTakerFee,
248         bytes32 indexed tokens, // keccak256(makerToken, takerToken), allows subscribing to a token pair
249         bytes32 orderHash
250     );
251 
252     event LogCancel(
253         address indexed maker,
254         address indexed feeRecipient,
255         address makerToken,
256         address takerToken,
257         uint cancelledMakerTokenAmount,
258         uint cancelledTakerTokenAmount,
259         bytes32 indexed tokens,
260         bytes32 orderHash
261     );
262 
263     event LogError(uint8 indexed errorId, bytes32 indexed orderHash);
264 
265     struct Order {
266         address maker;
267         address taker;
268         address makerToken;
269         address takerToken;
270         address feeRecipient;
271         uint makerTokenAmount;
272         uint takerTokenAmount;
273         uint makerFee;
274         uint takerFee;
275         uint expirationTimestampInSec;
276         bytes32 orderHash;
277     }
278 
279     function Exchange(address _zrxToken, address _tokenTransferProxy) {
280         ZRX_TOKEN_CONTRACT = _zrxToken;
281         TOKEN_TRANSFER_PROXY_CONTRACT = _tokenTransferProxy;
282     }
283 
284     /*
285     * Core exchange functions
286     */
287 
288     /// @dev Fills the input order.
289     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
290     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
291     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
292     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfer will fail before attempting.
293     /// @param v ECDSA signature parameter v.
294     /// @param r ECDSA signature parameters r.
295     /// @param s ECDSA signature parameters s.
296     /// @return Total amount of takerToken filled in trade.
297     function fillOrder(
298           address[5] orderAddresses,
299           uint[6] orderValues,
300           uint fillTakerTokenAmount,
301           bool shouldThrowOnInsufficientBalanceOrAllowance,
302           uint8 v,
303           bytes32 r,
304           bytes32 s)
305           public
306           returns (uint filledTakerTokenAmount)
307     {
308         Order memory order = Order({
309             maker: orderAddresses[0],
310             taker: orderAddresses[1],
311             makerToken: orderAddresses[2],
312             takerToken: orderAddresses[3],
313             feeRecipient: orderAddresses[4],
314             makerTokenAmount: orderValues[0],
315             takerTokenAmount: orderValues[1],
316             makerFee: orderValues[2],
317             takerFee: orderValues[3],
318             expirationTimestampInSec: orderValues[4],
319             orderHash: getOrderHash(orderAddresses, orderValues)
320         });
321 
322         require(order.taker == address(0) || order.taker == msg.sender);
323         require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && fillTakerTokenAmount > 0);
324         require(isValidSignature(
325             order.maker,
326             order.orderHash,
327             v,
328             r,
329             s
330         ));
331 
332         if (block.timestamp >= order.expirationTimestampInSec) {
333             LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
334             return 0;
335         }
336 
337         uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
338         filledTakerTokenAmount = min256(fillTakerTokenAmount, remainingTakerTokenAmount);
339         if (filledTakerTokenAmount == 0) {
340             LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
341             return 0;
342         }
343 
344         if (isRoundingError(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount)) {
345             LogError(uint8(Errors.ROUNDING_ERROR_TOO_LARGE), order.orderHash);
346             return 0;
347         }
348 
349         if (!shouldThrowOnInsufficientBalanceOrAllowance && !isTransferable(order, filledTakerTokenAmount)) {
350             LogError(uint8(Errors.INSUFFICIENT_BALANCE_OR_ALLOWANCE), order.orderHash);
351             return 0;
352         }
353 
354         uint filledMakerTokenAmount = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
355         uint paidMakerFee;
356         uint paidTakerFee;
357         filled[order.orderHash] = safeAdd(filled[order.orderHash], filledTakerTokenAmount);
358         require(transferViaTokenTransferProxy(
359             order.makerToken,
360             order.maker,
361             msg.sender,
362             filledMakerTokenAmount
363         ));
364         require(transferViaTokenTransferProxy(
365             order.takerToken,
366             msg.sender,
367             order.maker,
368             filledTakerTokenAmount
369         ));
370         if (order.feeRecipient != address(0)) {
371             if (order.makerFee > 0) {
372                 paidMakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerFee);
373                 require(transferViaTokenTransferProxy(
374                     ZRX_TOKEN_CONTRACT,
375                     order.maker,
376                     order.feeRecipient,
377                     paidMakerFee
378                 ));
379             }
380             if (order.takerFee > 0) {
381                 paidTakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.takerFee);
382                 require(transferViaTokenTransferProxy(
383                     ZRX_TOKEN_CONTRACT,
384                     msg.sender,
385                     order.feeRecipient,
386                     paidTakerFee
387                 ));
388             }
389         }
390 
391         LogFill(
392             order.maker,
393             msg.sender,
394             order.feeRecipient,
395             order.makerToken,
396             order.takerToken,
397             filledMakerTokenAmount,
398             filledTakerTokenAmount,
399             paidMakerFee,
400             paidTakerFee,
401             keccak256(order.makerToken, order.takerToken),
402             order.orderHash
403         );
404         return filledTakerTokenAmount;
405     }
406 
407     /// @dev Cancels the input order.
408     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
409     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
410     /// @param cancelTakerTokenAmount Desired amount of takerToken to cancel in order.
411     /// @return Amount of takerToken cancelled.
412     function cancelOrder(
413         address[5] orderAddresses,
414         uint[6] orderValues,
415         uint cancelTakerTokenAmount)
416         public
417         returns (uint)
418     {
419         Order memory order = Order({
420             maker: orderAddresses[0],
421             taker: orderAddresses[1],
422             makerToken: orderAddresses[2],
423             takerToken: orderAddresses[3],
424             feeRecipient: orderAddresses[4],
425             makerTokenAmount: orderValues[0],
426             takerTokenAmount: orderValues[1],
427             makerFee: orderValues[2],
428             takerFee: orderValues[3],
429             expirationTimestampInSec: orderValues[4],
430             orderHash: getOrderHash(orderAddresses, orderValues)
431         });
432 
433         require(order.maker == msg.sender);
434         require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && cancelTakerTokenAmount > 0);
435 
436         if (block.timestamp >= order.expirationTimestampInSec) {
437             LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
438             return 0;
439         }
440 
441         uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
442         uint cancelledTakerTokenAmount = min256(cancelTakerTokenAmount, remainingTakerTokenAmount);
443         if (cancelledTakerTokenAmount == 0) {
444             LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
445             return 0;
446         }
447 
448         cancelled[order.orderHash] = safeAdd(cancelled[order.orderHash], cancelledTakerTokenAmount);
449 
450         LogCancel(
451             order.maker,
452             order.feeRecipient,
453             order.makerToken,
454             order.takerToken,
455             getPartialAmount(cancelledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount),
456             cancelledTakerTokenAmount,
457             keccak256(order.makerToken, order.takerToken),
458             order.orderHash
459         );
460         return cancelledTakerTokenAmount;
461     }
462 
463     /*
464     * Wrapper functions
465     */
466 
467     /// @dev Fills an order with specified parameters and ECDSA signature, throws if specified amount not filled entirely.
468     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
469     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
470     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
471     /// @param v ECDSA signature parameter v.
472     /// @param r ECDSA signature parameters r.
473     /// @param s ECDSA signature parameters s.
474     function fillOrKillOrder(
475         address[5] orderAddresses,
476         uint[6] orderValues,
477         uint fillTakerTokenAmount,
478         uint8 v,
479         bytes32 r,
480         bytes32 s)
481         public
482     {
483         require(fillOrder(
484             orderAddresses,
485             orderValues,
486             fillTakerTokenAmount,
487             false,
488             v,
489             r,
490             s
491         ) == fillTakerTokenAmount);
492     }
493 
494     /// @dev Synchronously executes multiple fill orders in a single transaction.
495     /// @param orderAddresses Array of address arrays containing individual order addresses.
496     /// @param orderValues Array of uint arrays containing individual order values.
497     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
498     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
499     /// @param v Array ECDSA signature v parameters.
500     /// @param r Array of ECDSA signature r parameters.
501     /// @param s Array of ECDSA signature s parameters.
502     function batchFillOrders(
503         address[5][] orderAddresses,
504         uint[6][] orderValues,
505         uint[] fillTakerTokenAmounts,
506         bool shouldThrowOnInsufficientBalanceOrAllowance,
507         uint8[] v,
508         bytes32[] r,
509         bytes32[] s)
510         public
511     {
512         for (uint i = 0; i < orderAddresses.length; i++) {
513             fillOrder(
514                 orderAddresses[i],
515                 orderValues[i],
516                 fillTakerTokenAmounts[i],
517                 shouldThrowOnInsufficientBalanceOrAllowance,
518                 v[i],
519                 r[i],
520                 s[i]
521             );
522         }
523     }
524 
525     /// @dev Synchronously executes multiple fillOrKill orders in a single transaction.
526     /// @param orderAddresses Array of address arrays containing individual order addresses.
527     /// @param orderValues Array of uint arrays containing individual order values.
528     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
529     /// @param v Array ECDSA signature v parameters.
530     /// @param r Array of ECDSA signature r parameters.
531     /// @param s Array of ECDSA signature s parameters.
532     function batchFillOrKillOrders(
533         address[5][] orderAddresses,
534         uint[6][] orderValues,
535         uint[] fillTakerTokenAmounts,
536         uint8[] v,
537         bytes32[] r,
538         bytes32[] s)
539         public
540     {
541         for (uint i = 0; i < orderAddresses.length; i++) {
542             fillOrKillOrder(
543                 orderAddresses[i],
544                 orderValues[i],
545                 fillTakerTokenAmounts[i],
546                 v[i],
547                 r[i],
548                 s[i]
549             );
550         }
551     }
552 
553     /// @dev Synchronously executes multiple fill orders in a single transaction until total fillTakerTokenAmount filled.
554     /// @param orderAddresses Array of address arrays containing individual order addresses.
555     /// @param orderValues Array of uint arrays containing individual order values.
556     /// @param fillTakerTokenAmount Desired total amount of takerToken to fill in orders.
557     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
558     /// @param v Array ECDSA signature v parameters.
559     /// @param r Array of ECDSA signature r parameters.
560     /// @param s Array of ECDSA signature s parameters.
561     /// @return Total amount of fillTakerTokenAmount filled in orders.
562     function fillOrdersUpTo(
563         address[5][] orderAddresses,
564         uint[6][] orderValues,
565         uint fillTakerTokenAmount,
566         bool shouldThrowOnInsufficientBalanceOrAllowance,
567         uint8[] v,
568         bytes32[] r,
569         bytes32[] s)
570         public
571         returns (uint)
572     {
573         uint filledTakerTokenAmount = 0;
574         for (uint i = 0; i < orderAddresses.length; i++) {
575             require(orderAddresses[i][3] == orderAddresses[0][3]); // takerToken must be the same for each order
576             filledTakerTokenAmount = safeAdd(filledTakerTokenAmount, fillOrder(
577                 orderAddresses[i],
578                 orderValues[i],
579                 safeSub(fillTakerTokenAmount, filledTakerTokenAmount),
580                 shouldThrowOnInsufficientBalanceOrAllowance,
581                 v[i],
582                 r[i],
583                 s[i]
584             ));
585             if (filledTakerTokenAmount == fillTakerTokenAmount) break;
586         }
587         return filledTakerTokenAmount;
588     }
589 
590     /// @dev Synchronously cancels multiple orders in a single transaction.
591     /// @param orderAddresses Array of address arrays containing individual order addresses.
592     /// @param orderValues Array of uint arrays containing individual order values.
593     /// @param cancelTakerTokenAmounts Array of desired amounts of takerToken to cancel in orders.
594     function batchCancelOrders(
595         address[5][] orderAddresses,
596         uint[6][] orderValues,
597         uint[] cancelTakerTokenAmounts)
598         public
599     {
600         for (uint i = 0; i < orderAddresses.length; i++) {
601             cancelOrder(
602                 orderAddresses[i],
603                 orderValues[i],
604                 cancelTakerTokenAmounts[i]
605             );
606         }
607     }
608 
609     /*
610     * Constant public functions
611     */
612 
613     /// @dev Calculates Keccak-256 hash of order with specified parameters.
614     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
615     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
616     /// @return Keccak-256 hash of order.
617     function getOrderHash(address[5] orderAddresses, uint[6] orderValues)
618         public
619         constant
620         returns (bytes32)
621     {
622         return keccak256(
623             address(this),
624             orderAddresses[0], // maker
625             orderAddresses[1], // taker
626             orderAddresses[2], // makerToken
627             orderAddresses[3], // takerToken
628             orderAddresses[4], // feeRecipient
629             orderValues[0],    // makerTokenAmount
630             orderValues[1],    // takerTokenAmount
631             orderValues[2],    // makerFee
632             orderValues[3],    // takerFee
633             orderValues[4],    // expirationTimestampInSec
634             orderValues[5]     // salt
635         );
636     }
637 
638     /// @dev Verifies that an order signature is valid.
639     /// @param signer address of signer.
640     /// @param hash Signed Keccak-256 hash.
641     /// @param v ECDSA signature parameter v.
642     /// @param r ECDSA signature parameters r.
643     /// @param s ECDSA signature parameters s.
644     /// @return Validity of order signature.
645     function isValidSignature(
646         address signer,
647         bytes32 hash,
648         uint8 v,
649         bytes32 r,
650         bytes32 s)
651         public
652         constant
653         returns (bool)
654     {
655         return signer == ecrecover(
656             keccak256("\x19Ethereum Signed Message:\n32", hash),
657             v,
658             r,
659             s
660         );
661     }
662 
663     /// @dev Checks if rounding error > 0.1%.
664     /// @param numerator Numerator.
665     /// @param denominator Denominator.
666     /// @param target Value to multiply with numerator/denominator.
667     /// @return Rounding error is present.
668     function isRoundingError(uint numerator, uint denominator, uint target)
669         public
670         constant
671         returns (bool)
672     {
673         uint remainder = mulmod(target, numerator, denominator);
674         if (remainder == 0) return false; // No rounding error.
675 
676         uint errPercentageTimes1000000 = safeDiv(
677             safeMul(remainder, 1000000),
678             safeMul(numerator, target)
679         );
680         return errPercentageTimes1000000 > 1000;
681     }
682 
683     /// @dev Calculates partial value given a numerator and denominator.
684     /// @param numerator Numerator.
685     /// @param denominator Denominator.
686     /// @param target Value to calculate partial of.
687     /// @return Partial value of target.
688     function getPartialAmount(uint numerator, uint denominator, uint target)
689         public
690         constant
691         returns (uint)
692     {
693         return safeDiv(safeMul(numerator, target), denominator);
694     }
695 
696     /// @dev Calculates the sum of values already filled and cancelled for a given order.
697     /// @param orderHash The Keccak-256 hash of the given order.
698     /// @return Sum of values already filled and cancelled.
699     function getUnavailableTakerTokenAmount(bytes32 orderHash)
700         public
701         constant
702         returns (uint)
703     {
704         return safeAdd(filled[orderHash], cancelled[orderHash]);
705     }
706 
707 
708     /*
709     * Internal functions
710     */
711 
712     /// @dev Transfers a token using TokenTransferProxy transferFrom function.
713     /// @param token Address of token to transferFrom.
714     /// @param from Address transfering token.
715     /// @param to Address receiving token.
716     /// @param value Amount of token to transfer.
717     /// @return Success of token transfer.
718     function transferViaTokenTransferProxy(
719         address token,
720         address from,
721         address to,
722         uint value)
723         internal
724         returns (bool)
725     {
726         return TokenTransferProxy(TOKEN_TRANSFER_PROXY_CONTRACT).transferFrom(token, from, to, value);
727     }
728 
729     /// @dev Checks if any order transfers will fail.
730     /// @param order Order struct of params that will be checked.
731     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
732     /// @return Predicted result of transfers.
733     function isTransferable(Order order, uint fillTakerTokenAmount)
734         internal
735         constant  // The called token contracts may attempt to change state, but will not be able to due to gas limits on getBalance and getAllowance.
736         returns (bool)
737     {
738         address taker = msg.sender;
739         uint fillMakerTokenAmount = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
740 
741         if (order.feeRecipient != address(0)) {
742             bool isMakerTokenZRX = order.makerToken == ZRX_TOKEN_CONTRACT;
743             bool isTakerTokenZRX = order.takerToken == ZRX_TOKEN_CONTRACT;
744             uint paidMakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerFee);
745             uint paidTakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.takerFee);
746             uint requiredMakerZRX = isMakerTokenZRX ? safeAdd(fillMakerTokenAmount, paidMakerFee) : paidMakerFee;
747             uint requiredTakerZRX = isTakerTokenZRX ? safeAdd(fillTakerTokenAmount, paidTakerFee) : paidTakerFee;
748 
749             if (   getBalance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
750                 || getAllowance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
751                 || getBalance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
752                 || getAllowance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
753             ) return false;
754 
755             if (!isMakerTokenZRX && (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount // Don't double check makerToken if ZRX
756                                      || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount)
757             ) return false;
758             if (!isTakerTokenZRX && (   getBalance(order.takerToken, taker) < fillTakerTokenAmount // Don't double check takerToken if ZRX
759                                      || getAllowance(order.takerToken, taker) < fillTakerTokenAmount)
760             ) return false;
761         } else if (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount
762                    || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount
763                    || getBalance(order.takerToken, taker) < fillTakerTokenAmount
764                    || getAllowance(order.takerToken, taker) < fillTakerTokenAmount
765         ) return false;
766 
767         return true;
768     }
769 
770     /// @dev Get token balance of an address.
771     /// @param token Address of token.
772     /// @param owner Address of owner.
773     /// @return Token balance of owner.
774     function getBalance(address token, address owner)
775         internal
776         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
777         returns (uint)
778     {
779         return Token(token).balanceOf.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner); // Limit gas to prevent reentrancy
780     }
781 
782     /// @dev Get allowance of token given to TokenTransferProxy by an address.
783     /// @param token Address of token.
784     /// @param owner Address of owner.
785     /// @return Allowance of token given to TokenTransferProxy by owner.
786     function getAllowance(address token, address owner)
787         internal
788         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
789         returns (uint)
790     {
791         return Token(token).allowance.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner, TOKEN_TRANSFER_PROXY_CONTRACT); // Limit gas to prevent reentrancy
792     }
793 }