1 pragma solidity 0.4.14;
2 
3 /*
4 
5   Copyright 2017 ZeroEx Intl.
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
23     /// @return total amount of tokens
24     function totalSupply() constant returns (uint supply) {}
25 
26     /// @param _owner The address from which the balance will be retrieved
27     /// @return The balance
28     function balanceOf(address _owner) constant returns (uint balance) {}
29 
30     /// @notice send `_value` token to `_to` from `msg.sender`
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transfer(address _to, uint _value) returns (bool success) {}
35 
36     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37     /// @param _from The address of the sender
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
42 
43     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _value The amount of wei to be approved for transfer
46     /// @return Whether the approval was successful or not
47     function approve(address _spender, uint _value) returns (bool success) {}
48 
49     /// @param _owner The address of the account owning tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @return Amount of remaining tokens allowed to spent
52     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
53 
54     event Transfer(address indexed _from, address indexed _to, uint _value);
55     event Approval(address indexed _owner, address indexed _spender, uint _value);
56 }
57 
58 /*
59  * Ownable
60  *
61  * Base contract with an owner.
62  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
63  */
64 
65 contract Ownable {
66     address public owner;
67 
68     function Ownable() {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address newOwner) onlyOwner {
78         if (newOwner != address(0)) {
79             owner = newOwner;
80         }
81     }
82 }
83 
84 contract SafeMath {
85     function safeMul(uint a, uint b) internal constant returns (uint256) {
86         uint c = a * b;
87         assert(a == 0 || c / a == b);
88         return c;
89     }
90 
91     function safeDiv(uint a, uint b) internal constant returns (uint256) {
92         uint c = a / b;
93         return c;
94     }
95 
96     function safeSub(uint a, uint b) internal constant returns (uint256) {
97         assert(b <= a);
98         return a - b;
99     }
100 
101     function safeAdd(uint a, uint b) internal constant returns (uint256) {
102         uint c = a + b;
103         assert(c >= a);
104         return c;
105     }
106 
107     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
108         return a >= b ? a : b;
109     }
110 
111     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
112         return a < b ? a : b;
113     }
114 
115     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
116         return a >= b ? a : b;
117     }
118 
119     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
120         return a < b ? a : b;
121     }
122 }
123 
124 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
125 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
126 contract TokenTransferProxy is Ownable {
127 
128     /// @dev Only authorized addresses can invoke functions with this modifier.
129     modifier onlyAuthorized {
130         require(authorized[msg.sender]);
131         _;
132     }
133 
134     modifier targetAuthorized(address target) {
135         require(authorized[target]);
136         _;
137     }
138 
139     modifier targetNotAuthorized(address target) {
140         require(!authorized[target]);
141         _;
142     }
143 
144     mapping (address => bool) public authorized;
145     address[] public authorities;
146 
147     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
148     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
149 
150     /*
151      * Public functions
152      */
153 
154     /// @dev Authorizes an address.
155     /// @param target Address to authorize.
156     function addAuthorizedAddress(address target)
157         public
158         onlyOwner
159         targetNotAuthorized(target)
160     {
161         authorized[target] = true;
162         authorities.push(target);
163         LogAuthorizedAddressAdded(target, msg.sender);
164     }
165 
166     /// @dev Removes authorizion of an address.
167     /// @param target Address to remove authorization from.
168     function removeAuthorizedAddress(address target)
169         public
170         onlyOwner
171         targetAuthorized(target)
172     {
173         delete authorized[target];
174         for (uint i = 0; i < authorities.length; i++) {
175             if (authorities[i] == target) {
176                 authorities[i] = authorities[authorities.length - 1];
177                 authorities.length -= 1;
178                 break;
179             }
180         }
181         LogAuthorizedAddressRemoved(target, msg.sender);
182     }
183 
184     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
185     /// @param token Address of token to transfer.
186     /// @param from Address to transfer token from.
187     /// @param to Address to transfer token to.
188     /// @param value Amount of token to transfer.
189     /// @return Success of transfer.
190     function transferFrom(
191         address token,
192         address from,
193         address to,
194         uint value)
195         public
196         onlyAuthorized
197         returns (bool)
198     {
199         return Token(token).transferFrom(from, to, value);
200     }
201 
202     /*
203      * Public constant functions
204      */
205 
206     /// @dev Gets all authorized addresses.
207     /// @return Array of authorized addresses.
208     function getAuthorizedAddresses()
209         public
210         constant
211         returns (address[])
212     {
213         return authorities;
214     }
215 }
216 
217 /// @title Exchange - Facilitates exchange of ERC20 tokens.
218 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
219 contract Exchange is SafeMath {
220 
221     // Error Codes
222     enum Errors {
223         ORDER_EXPIRED,                    // Order has already expired
224         ORDER_FULLY_FILLED_OR_CANCELLED,  // Order has already been fully filled or cancelled
225         ROUNDING_ERROR_TOO_LARGE,         // Rounding error too large
226         INSUFFICIENT_BALANCE_OR_ALLOWANCE // Insufficient balance or allowance for token transfer
227     }
228 
229     string constant public VERSION = "1.0.0";
230     uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 4999;    // Changes to state require at least 5000 gas
231 
232     address public ZRX_TOKEN_CONTRACT;
233     address public TOKEN_TRANSFER_PROXY_CONTRACT;
234 
235     // Mappings of orderHash => amounts of takerTokenAmount filled or cancelled.
236     mapping (bytes32 => uint) public filled;
237     mapping (bytes32 => uint) public cancelled;
238 
239     event LogFill(
240         address indexed maker,
241         address taker,
242         address indexed feeRecipient,
243         address makerToken,
244         address takerToken,
245         uint filledMakerTokenAmount,
246         uint filledTakerTokenAmount,
247         uint paidMakerFee,
248         uint paidTakerFee,
249         bytes32 indexed tokens, // keccak256(makerToken, takerToken), allows subscribing to a token pair
250         bytes32 orderHash
251     );
252 
253     event LogCancel(
254         address indexed maker,
255         address indexed feeRecipient,
256         address makerToken,
257         address takerToken,
258         uint cancelledMakerTokenAmount,
259         uint cancelledTakerTokenAmount,
260         bytes32 indexed tokens,
261         bytes32 orderHash
262     );
263 
264     event LogError(uint8 indexed errorId, bytes32 indexed orderHash);
265 
266     struct Order {
267         address maker;
268         address taker;
269         address makerToken;
270         address takerToken;
271         address feeRecipient;
272         uint makerTokenAmount;
273         uint takerTokenAmount;
274         uint makerFee;
275         uint takerFee;
276         uint expirationTimestampInSec;
277         bytes32 orderHash;
278     }
279 
280     function Exchange(address _zrxToken, address _tokenTransferProxy) {
281         ZRX_TOKEN_CONTRACT = _zrxToken;
282         TOKEN_TRANSFER_PROXY_CONTRACT = _tokenTransferProxy;
283     }
284 
285     /*
286     * Core exchange functions
287     */
288 
289     /// @dev Fills the input order.
290     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
291     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
292     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
293     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfer will fail before attempting.
294     /// @param v ECDSA signature parameter v.
295     /// @param r ECDSA signature parameters r.
296     /// @param s ECDSA signature parameters s.
297     /// @return Total amount of takerToken filled in trade.
298     function fillOrder(
299           address[5] orderAddresses,
300           uint[6] orderValues,
301           uint fillTakerTokenAmount,
302           bool shouldThrowOnInsufficientBalanceOrAllowance,
303           uint8 v,
304           bytes32 r,
305           bytes32 s)
306           public
307           returns (uint filledTakerTokenAmount)
308     {
309         Order memory order = Order({
310             maker: orderAddresses[0],
311             taker: orderAddresses[1],
312             makerToken: orderAddresses[2],
313             takerToken: orderAddresses[3],
314             feeRecipient: orderAddresses[4],
315             makerTokenAmount: orderValues[0],
316             takerTokenAmount: orderValues[1],
317             makerFee: orderValues[2],
318             takerFee: orderValues[3],
319             expirationTimestampInSec: orderValues[4],
320             orderHash: getOrderHash(orderAddresses, orderValues)
321         });
322 
323         require(order.taker == address(0) || order.taker == msg.sender);
324         require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && fillTakerTokenAmount > 0);
325         require(isValidSignature(
326             order.maker,
327             order.orderHash,
328             v,
329             r,
330             s
331         ));
332 
333         if (block.timestamp >= order.expirationTimestampInSec) {
334             LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
335             return 0;
336         }
337 
338         uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
339         filledTakerTokenAmount = min256(fillTakerTokenAmount, remainingTakerTokenAmount);
340         if (filledTakerTokenAmount == 0) {
341             LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
342             return 0;
343         }
344 
345         if (isRoundingError(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount)) {
346             LogError(uint8(Errors.ROUNDING_ERROR_TOO_LARGE), order.orderHash);
347             return 0;
348         }
349 
350         if (!shouldThrowOnInsufficientBalanceOrAllowance && !isTransferable(order, filledTakerTokenAmount)) {
351             LogError(uint8(Errors.INSUFFICIENT_BALANCE_OR_ALLOWANCE), order.orderHash);
352             return 0;
353         }
354 
355         uint filledMakerTokenAmount = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
356         uint paidMakerFee;
357         uint paidTakerFee;
358         filled[order.orderHash] = safeAdd(filled[order.orderHash], filledTakerTokenAmount);
359         require(transferViaTokenTransferProxy(
360             order.makerToken,
361             order.maker,
362             msg.sender,
363             filledMakerTokenAmount
364         ));
365         require(transferViaTokenTransferProxy(
366             order.takerToken,
367             msg.sender,
368             order.maker,
369             filledTakerTokenAmount
370         ));
371         if (order.feeRecipient != address(0)) {
372             if (order.makerFee > 0) {
373                 paidMakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerFee);
374                 require(transferViaTokenTransferProxy(
375                     ZRX_TOKEN_CONTRACT,
376                     order.maker,
377                     order.feeRecipient,
378                     paidMakerFee
379                 ));
380             }
381             if (order.takerFee > 0) {
382                 paidTakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.takerFee);
383                 require(transferViaTokenTransferProxy(
384                     ZRX_TOKEN_CONTRACT,
385                     msg.sender,
386                     order.feeRecipient,
387                     paidTakerFee
388                 ));
389             }
390         }
391 
392         LogFill(
393             order.maker,
394             msg.sender,
395             order.feeRecipient,
396             order.makerToken,
397             order.takerToken,
398             filledMakerTokenAmount,
399             filledTakerTokenAmount,
400             paidMakerFee,
401             paidTakerFee,
402             keccak256(order.makerToken, order.takerToken),
403             order.orderHash
404         );
405         return filledTakerTokenAmount;
406     }
407 
408     /// @dev Cancels the input order.
409     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
410     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
411     /// @param cancelTakerTokenAmount Desired amount of takerToken to cancel in order.
412     /// @return Amount of takerToken cancelled.
413     function cancelOrder(
414         address[5] orderAddresses,
415         uint[6] orderValues,
416         uint cancelTakerTokenAmount)
417         public
418         returns (uint)
419     {
420         Order memory order = Order({
421             maker: orderAddresses[0],
422             taker: orderAddresses[1],
423             makerToken: orderAddresses[2],
424             takerToken: orderAddresses[3],
425             feeRecipient: orderAddresses[4],
426             makerTokenAmount: orderValues[0],
427             takerTokenAmount: orderValues[1],
428             makerFee: orderValues[2],
429             takerFee: orderValues[3],
430             expirationTimestampInSec: orderValues[4],
431             orderHash: getOrderHash(orderAddresses, orderValues)
432         });
433 
434         require(order.maker == msg.sender);
435         require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && cancelTakerTokenAmount > 0);
436 
437         if (block.timestamp >= order.expirationTimestampInSec) {
438             LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
439             return 0;
440         }
441 
442         uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
443         uint cancelledTakerTokenAmount = min256(cancelTakerTokenAmount, remainingTakerTokenAmount);
444         if (cancelledTakerTokenAmount == 0) {
445             LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
446             return 0;
447         }
448 
449         cancelled[order.orderHash] = safeAdd(cancelled[order.orderHash], cancelledTakerTokenAmount);
450 
451         LogCancel(
452             order.maker,
453             order.feeRecipient,
454             order.makerToken,
455             order.takerToken,
456             getPartialAmount(cancelledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount),
457             cancelledTakerTokenAmount,
458             keccak256(order.makerToken, order.takerToken),
459             order.orderHash
460         );
461         return cancelledTakerTokenAmount;
462     }
463 
464     /*
465     * Wrapper functions
466     */
467 
468     /// @dev Fills an order with specified parameters and ECDSA signature, throws if specified amount not filled entirely.
469     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
470     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
471     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
472     /// @param v ECDSA signature parameter v.
473     /// @param r ECDSA signature parameters r.
474     /// @param s ECDSA signature parameters s.
475     function fillOrKillOrder(
476         address[5] orderAddresses,
477         uint[6] orderValues,
478         uint fillTakerTokenAmount,
479         uint8 v,
480         bytes32 r,
481         bytes32 s)
482         public
483     {
484         require(fillOrder(
485             orderAddresses,
486             orderValues,
487             fillTakerTokenAmount,
488             false,
489             v,
490             r,
491             s
492         ) == fillTakerTokenAmount);
493     }
494 
495     /// @dev Synchronously executes multiple fill orders in a single transaction.
496     /// @param orderAddresses Array of address arrays containing individual order addresses.
497     /// @param orderValues Array of uint arrays containing individual order values.
498     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
499     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
500     /// @param v Array ECDSA signature v parameters.
501     /// @param r Array of ECDSA signature r parameters.
502     /// @param s Array of ECDSA signature s parameters.
503     function batchFillOrders(
504         address[5][] orderAddresses,
505         uint[6][] orderValues,
506         uint[] fillTakerTokenAmounts,
507         bool shouldThrowOnInsufficientBalanceOrAllowance,
508         uint8[] v,
509         bytes32[] r,
510         bytes32[] s)
511         public
512     {
513         for (uint i = 0; i < orderAddresses.length; i++) {
514             fillOrder(
515                 orderAddresses[i],
516                 orderValues[i],
517                 fillTakerTokenAmounts[i],
518                 shouldThrowOnInsufficientBalanceOrAllowance,
519                 v[i],
520                 r[i],
521                 s[i]
522             );
523         }
524     }
525 
526     /// @dev Synchronously executes multiple fillOrKill orders in a single transaction.
527     /// @param orderAddresses Array of address arrays containing individual order addresses.
528     /// @param orderValues Array of uint arrays containing individual order values.
529     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
530     /// @param v Array ECDSA signature v parameters.
531     /// @param r Array of ECDSA signature r parameters.
532     /// @param s Array of ECDSA signature s parameters.
533     function batchFillOrKillOrders(
534         address[5][] orderAddresses,
535         uint[6][] orderValues,
536         uint[] fillTakerTokenAmounts,
537         uint8[] v,
538         bytes32[] r,
539         bytes32[] s)
540         public
541     {
542         for (uint i = 0; i < orderAddresses.length; i++) {
543             fillOrKillOrder(
544                 orderAddresses[i],
545                 orderValues[i],
546                 fillTakerTokenAmounts[i],
547                 v[i],
548                 r[i],
549                 s[i]
550             );
551         }
552     }
553 
554     /// @dev Synchronously executes multiple fill orders in a single transaction until total fillTakerTokenAmount filled.
555     /// @param orderAddresses Array of address arrays containing individual order addresses.
556     /// @param orderValues Array of uint arrays containing individual order values.
557     /// @param fillTakerTokenAmount Desired total amount of takerToken to fill in orders.
558     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
559     /// @param v Array ECDSA signature v parameters.
560     /// @param r Array of ECDSA signature r parameters.
561     /// @param s Array of ECDSA signature s parameters.
562     /// @return Total amount of fillTakerTokenAmount filled in orders.
563     function fillOrdersUpTo(
564         address[5][] orderAddresses,
565         uint[6][] orderValues,
566         uint fillTakerTokenAmount,
567         bool shouldThrowOnInsufficientBalanceOrAllowance,
568         uint8[] v,
569         bytes32[] r,
570         bytes32[] s)
571         public
572         returns (uint)
573     {
574         uint filledTakerTokenAmount = 0;
575         for (uint i = 0; i < orderAddresses.length; i++) {
576             require(orderAddresses[i][3] == orderAddresses[0][3]); // takerToken must be the same for each order
577             filledTakerTokenAmount = safeAdd(filledTakerTokenAmount, fillOrder(
578                 orderAddresses[i],
579                 orderValues[i],
580                 safeSub(fillTakerTokenAmount, filledTakerTokenAmount),
581                 shouldThrowOnInsufficientBalanceOrAllowance,
582                 v[i],
583                 r[i],
584                 s[i]
585             ));
586             if (filledTakerTokenAmount == fillTakerTokenAmount) break;
587         }
588         return filledTakerTokenAmount;
589     }
590 
591     /// @dev Synchronously cancels multiple orders in a single transaction.
592     /// @param orderAddresses Array of address arrays containing individual order addresses.
593     /// @param orderValues Array of uint arrays containing individual order values.
594     /// @param cancelTakerTokenAmounts Array of desired amounts of takerToken to cancel in orders.
595     function batchCancelOrders(
596         address[5][] orderAddresses,
597         uint[6][] orderValues,
598         uint[] cancelTakerTokenAmounts)
599         public
600     {
601         for (uint i = 0; i < orderAddresses.length; i++) {
602             cancelOrder(
603                 orderAddresses[i],
604                 orderValues[i],
605                 cancelTakerTokenAmounts[i]
606             );
607         }
608     }
609 
610     /*
611     * Constant public functions
612     */
613 
614     /// @dev Calculates Keccak-256 hash of order with specified parameters.
615     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
616     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
617     /// @return Keccak-256 hash of order.
618     function getOrderHash(address[5] orderAddresses, uint[6] orderValues)
619         public
620         constant
621         returns (bytes32)
622     {
623         return keccak256(
624             address(this),
625             orderAddresses[0], // maker
626             orderAddresses[1], // taker
627             orderAddresses[2], // makerToken
628             orderAddresses[3], // takerToken
629             orderAddresses[4], // feeRecipient
630             orderValues[0],    // makerTokenAmount
631             orderValues[1],    // takerTokenAmount
632             orderValues[2],    // makerFee
633             orderValues[3],    // takerFee
634             orderValues[4],    // expirationTimestampInSec
635             orderValues[5]     // salt
636         );
637     }
638 
639     /// @dev Verifies that an order signature is valid.
640     /// @param signer address of signer.
641     /// @param hash Signed Keccak-256 hash.
642     /// @param v ECDSA signature parameter v.
643     /// @param r ECDSA signature parameters r.
644     /// @param s ECDSA signature parameters s.
645     /// @return Validity of order signature.
646     function isValidSignature(
647         address signer,
648         bytes32 hash,
649         uint8 v,
650         bytes32 r,
651         bytes32 s)
652         public
653         constant
654         returns (bool)
655     {
656         return signer == ecrecover(
657             keccak256("\x19Ethereum Signed Message:\n32", hash),
658             v,
659             r,
660             s
661         );
662     }
663 
664     /// @dev Checks if rounding error > 0.1%.
665     /// @param numerator Numerator.
666     /// @param denominator Denominator.
667     /// @param target Value to multiply with numerator/denominator.
668     /// @return Rounding error is present.
669     function isRoundingError(uint numerator, uint denominator, uint target)
670         public
671         constant
672         returns (bool)
673     {
674         uint remainder = mulmod(target, numerator, denominator);
675         if (remainder == 0) return false; // No rounding error.
676 
677         uint errPercentageTimes1000000 = safeDiv(
678             safeMul(remainder, 1000000),
679             safeMul(numerator, target)
680         );
681         return errPercentageTimes1000000 > 1000;
682     }
683 
684     /// @dev Calculates partial value given a numerator and denominator.
685     /// @param numerator Numerator.
686     /// @param denominator Denominator.
687     /// @param target Value to calculate partial of.
688     /// @return Partial value of target.
689     function getPartialAmount(uint numerator, uint denominator, uint target)
690         public
691         constant
692         returns (uint)
693     {
694         return safeDiv(safeMul(numerator, target), denominator);
695     }
696 
697     /// @dev Calculates the sum of values already filled and cancelled for a given order.
698     /// @param orderHash The Keccak-256 hash of the given order.
699     /// @return Sum of values already filled and cancelled.
700     function getUnavailableTakerTokenAmount(bytes32 orderHash)
701         public
702         constant
703         returns (uint)
704     {
705         return safeAdd(filled[orderHash], cancelled[orderHash]);
706     }
707 
708 
709     /*
710     * Internal functions
711     */
712 
713     /// @dev Transfers a token using TokenTransferProxy transferFrom function.
714     /// @param token Address of token to transferFrom.
715     /// @param from Address transfering token.
716     /// @param to Address receiving token.
717     /// @param value Amount of token to transfer.
718     /// @return Success of token transfer.
719     function transferViaTokenTransferProxy(
720         address token,
721         address from,
722         address to,
723         uint value)
724         internal
725         returns (bool)
726     {
727         return TokenTransferProxy(TOKEN_TRANSFER_PROXY_CONTRACT).transferFrom(token, from, to, value);
728     }
729 
730     /// @dev Checks if any order transfers will fail.
731     /// @param order Order struct of params that will be checked.
732     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
733     /// @return Predicted result of transfers.
734     function isTransferable(Order order, uint fillTakerTokenAmount)
735         internal
736         constant  // The called token contracts may attempt to change state, but will not be able to due to gas limits on getBalance and getAllowance.
737         returns (bool)
738     {
739         address taker = msg.sender;
740         uint fillMakerTokenAmount = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
741 
742         if (order.feeRecipient != address(0)) {
743             bool isMakerTokenZRX = order.makerToken == ZRX_TOKEN_CONTRACT;
744             bool isTakerTokenZRX = order.takerToken == ZRX_TOKEN_CONTRACT;
745             uint paidMakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerFee);
746             uint paidTakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.takerFee);
747             uint requiredMakerZRX = isMakerTokenZRX ? safeAdd(fillMakerTokenAmount, paidMakerFee) : paidMakerFee;
748             uint requiredTakerZRX = isTakerTokenZRX ? safeAdd(fillTakerTokenAmount, paidTakerFee) : paidTakerFee;
749 
750             if (   getBalance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
751                 || getAllowance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
752                 || getBalance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
753                 || getAllowance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
754             ) return false;
755 
756             if (!isMakerTokenZRX && (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount // Don't double check makerToken if ZRX
757                                      || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount)
758             ) return false;
759             if (!isTakerTokenZRX && (   getBalance(order.takerToken, taker) < fillTakerTokenAmount // Don't double check takerToken if ZRX
760                                      || getAllowance(order.takerToken, taker) < fillTakerTokenAmount)
761             ) return false;
762         } else if (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount
763                    || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount
764                    || getBalance(order.takerToken, taker) < fillTakerTokenAmount
765                    || getAllowance(order.takerToken, taker) < fillTakerTokenAmount
766         ) return false;
767 
768         return true;
769     }
770 
771     /// @dev Get token balance of an address.
772     /// @param token Address of token.
773     /// @param owner Address of owner.
774     /// @return Token balance of owner.
775     function getBalance(address token, address owner)
776         internal
777         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
778         returns (uint)
779     {
780         return Token(token).balanceOf.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner); // Limit gas to prevent reentrancy
781     }
782 
783     /// @dev Get allowance of token given to TokenTransferProxy by an address.
784     /// @param token Address of token.
785     /// @param owner Address of owner.
786     /// @return Allowance of token given to TokenTransferProxy by owner.
787     function getAllowance(address token, address owner)
788         internal
789         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
790         returns (uint)
791     {
792         return Token(token).allowance.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner, TOKEN_TRANSFER_PROXY_CONTRACT); // Limit gas to prevent reentrancy
793     }
794 }
795 
796 
797 /// @title Standard token contract with overflow protection - Used for tokens with dynamic supply.
798 contract StandardTokenWithOverflowProtection is Token,
799                                                 SafeMath
800 {
801 
802     /*
803      *  Data structures
804      */
805     mapping (address => uint256) balances;
806     mapping (address => mapping (address => uint256)) allowed;
807     uint256 public totalSupply;
808 
809     /*
810      *  Public functions
811      */
812     /// @dev Transfers sender's tokens to a given address. Returns success.
813     /// @param _to Address of token receiver.
814     /// @param _value Number of tokens to transfer.
815     /// @return Returns success of function call.
816     function transfer(address _to, uint256 _value)
817         public
818         returns (bool)
819     {
820         balances[msg.sender] = safeSub(balances[msg.sender], _value);
821         balances[_to] = safeAdd(balances[_to], _value);
822         Transfer(msg.sender, _to, _value);
823         return true;
824     }
825 
826     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
827     /// @param _from Address from where tokens are withdrawn.
828     /// @param _to Address to where tokens are sent.
829     /// @param _value Number of tokens to transfer.
830     /// @return Returns success of function call.
831     function transferFrom(address _from, address _to, uint256 _value)
832         public
833         returns (bool)
834     {
835         balances[_from] = safeSub(balances[_from], _value);
836         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
837         balances[_to] = safeAdd(balances[_to], _value);
838         Transfer(_from, _to, _value);
839         return true;
840     }
841 
842     /// @dev Sets approved amount of tokens for spender. Returns success.
843     /// @param _spender Address of allowed account.
844     /// @param _value Number of approved tokens.
845     /// @return Returns success of function call.
846     function approve(address _spender, uint256 _value)
847         public
848         returns (bool)
849     {
850         allowed[msg.sender][_spender] = _value;
851         Approval(msg.sender, _spender, _value);
852         return true;
853     }
854 
855     /*
856      * Read functions
857      */
858     /// @dev Returns number of allowed tokens for given address.
859     /// @param _owner Address of token owner.
860     /// @param _spender Address of token spender.
861     /// @return Returns remaining allowance for spender.
862     function allowance(address _owner, address _spender)
863         constant
864         public
865         returns (uint256)
866     {
867         return allowed[_owner][_spender];
868     }
869 
870     /// @dev Returns number of tokens owned by given address.
871     /// @param _owner Address of token owner.
872     /// @return Returns balance of owner.
873     function balanceOf(address _owner)
874         constant
875         public
876         returns (uint256)
877     {
878         return balances[_owner];
879     }
880 }
881 
882 /// @title Token contract - Token exchanging Ether 1:1.
883 /// @author Stefan George - <stefan.george@consensys.net>
884 /// @author Modified by Amir Bandeali - <amir@0xproject.com>
885 contract EtherToken is StandardTokenWithOverflowProtection {
886 
887     /*
888      *  Constants
889      */
890     // Token meta data
891     string constant public name = "Ether Token";
892     string constant public symbol = "WETH";
893     uint8 constant public decimals = 18;
894 
895     /*
896      *  Read and write functions
897      */
898 
899     /// @dev Fallback to calling deposit when ether is sent directly to contract.
900     function()
901         public
902         payable
903     {
904         deposit();
905     }
906 
907     /// @dev Buys tokens with Ether, exchanging them 1:1.
908     function deposit()
909         public
910         payable
911     {
912         balances[msg.sender] = safeAdd(balances[msg.sender], msg.value);
913         totalSupply = safeAdd(totalSupply, msg.value);
914     }
915 
916     /// @dev Sells tokens in exchange for Ether, exchanging them 1:1.
917     /// @param amount Number of tokens to sell.
918     function withdraw(uint amount)
919         public
920     {
921         balances[msg.sender] = safeSub(balances[msg.sender], amount);
922         totalSupply = safeSub(totalSupply, amount);
923         require(msg.sender.send(amount));
924     }
925 }
926 
927 contract TokenSale is Ownable, SafeMath {
928 
929     event SaleInitialized(uint startTimeInSec);
930     event SaleFinished(uint endTimeInSec);
931 
932     uint public constant TIME_PERIOD_IN_SEC = 1 days;
933 
934     Exchange exchange;
935     Token protocolToken;
936     EtherToken ethToken;
937 
938     mapping (address => bool) public registered;
939     mapping (address => uint) public contributed;
940 
941     bool public isSaleInitialized;
942     bool public isSaleFinished;
943     uint public baseEthCapPerAddress;
944     uint public startTimeInSec;
945     Order order;
946 
947     struct Order {
948         address maker;
949         address taker;
950         address makerToken;
951         address takerToken;
952         address feeRecipient;
953         uint makerTokenAmount;
954         uint takerTokenAmount;
955         uint makerFee;
956         uint takerFee;
957         uint expirationTimestampInSec;
958         uint salt;
959         uint8 v;
960         bytes32 r;
961         bytes32 s;
962         bytes32 orderHash;
963     }
964 
965     modifier saleNotInitialized() {
966         require(!isSaleInitialized);
967         _;
968     }
969 
970     modifier saleStarted() {
971         require(isSaleInitialized && block.timestamp >= startTimeInSec);
972         _;
973     }
974 
975     modifier saleNotFinished() {
976         require(!isSaleFinished);
977         _;
978     }
979 
980     modifier onlyRegistered() {
981         require(registered[msg.sender]);
982         _;
983     }
984 
985     modifier validStartTime(uint _startTimeInSec) {
986         require(_startTimeInSec >= block.timestamp);
987         _;
988     }
989 
990     modifier validBaseEthCapPerAddress(uint _ethCapPerAddress) {
991         require(_ethCapPerAddress != 0);
992         _;
993     }
994 
995     function TokenSale(
996         address _exchange,
997         address _protocolToken,
998         address _ethToken)
999     {
1000         exchange = Exchange(_exchange);
1001         protocolToken = Token(_protocolToken);
1002         ethToken = EtherToken(_ethToken);
1003     }
1004 
1005     /// @dev Allows users to fill stored order by sending ETH to contract.
1006     function()
1007         payable
1008     {
1009         fillOrderWithEth();
1010     }
1011 
1012     /// @dev Stores order and initializes sale parameters.
1013     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
1014     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
1015     /// @param v ECDSA signature parameter v.
1016     /// @param r ECDSA signature parameters r.
1017     /// @param s ECDSA signature parameters s.
1018     /// @param _startTimeInSec Time that token sale begins in seconds since epoch.
1019     /// @param _baseEthCapPerAddress The ETH cap per address for the first time period.
1020     function initializeSale(
1021         address[5] orderAddresses,
1022         uint[6] orderValues,
1023         uint8 v,
1024         bytes32 r,
1025         bytes32 s,
1026         uint _startTimeInSec,
1027         uint _baseEthCapPerAddress)
1028         public
1029         saleNotInitialized
1030         onlyOwner
1031         validStartTime(_startTimeInSec)
1032         validBaseEthCapPerAddress(_baseEthCapPerAddress)
1033     {
1034         order = Order({
1035             maker: orderAddresses[0],
1036             taker: orderAddresses[1],
1037             makerToken: orderAddresses[2],
1038             takerToken: orderAddresses[3],
1039             feeRecipient: orderAddresses[4],
1040             makerTokenAmount: orderValues[0],
1041             takerTokenAmount: orderValues[1],
1042             makerFee: orderValues[2],
1043             takerFee: orderValues[3],
1044             expirationTimestampInSec: orderValues[4],
1045             salt: orderValues[5],
1046             v: v,
1047             r: r,
1048             s: s,
1049             orderHash: exchange.getOrderHash(orderAddresses, orderValues)
1050         });
1051 
1052         require(order.taker == address(this));
1053         require(order.makerToken == address(protocolToken));
1054         require(order.takerToken == address(ethToken));
1055         require(order.feeRecipient == address(0));
1056 
1057         require(isValidSignature(
1058             order.maker,
1059             order.orderHash,
1060             v,
1061             r,
1062             s
1063         ));
1064 
1065         require(ethToken.approve(exchange.TOKEN_TRANSFER_PROXY_CONTRACT(), order.takerTokenAmount));
1066         isSaleInitialized = true;
1067         startTimeInSec = _startTimeInSec;
1068         baseEthCapPerAddress = _baseEthCapPerAddress;
1069 
1070         SaleInitialized(_startTimeInSec);
1071     }
1072 
1073     /// @dev Fills order using msg.value. Should not be called by contracts unless able to access the protocol token after execution.
1074     function fillOrderWithEth()
1075         public
1076         payable
1077         saleStarted
1078         saleNotFinished
1079         onlyRegistered
1080     {
1081         uint remainingEth = safeSub(order.takerTokenAmount, exchange.getUnavailableTakerTokenAmount(order.orderHash));
1082         uint ethCapPerAddress = getEthCapPerAddress();
1083         uint allowedEth = safeSub(ethCapPerAddress, contributed[msg.sender]);
1084         uint ethToFill = min256(min256(msg.value, remainingEth), allowedEth);
1085         ethToken.deposit.value(ethToFill)();
1086 
1087         contributed[msg.sender] = safeAdd(contributed[msg.sender], ethToFill);
1088 
1089         exchange.fillOrKillOrder(
1090             [order.maker, order.taker, order.makerToken, order.takerToken, order.feeRecipient],
1091             [order.makerTokenAmount, order.takerTokenAmount, order.makerFee, order.takerFee, order.expirationTimestampInSec, order.salt],
1092             ethToFill,
1093             order.v,
1094             order.r,
1095             order.s
1096         );
1097         uint filledProtocolToken = safeDiv(safeMul(order.makerTokenAmount, ethToFill), order.takerTokenAmount);
1098         require(protocolToken.transfer(msg.sender, filledProtocolToken));
1099 
1100         if (ethToFill < msg.value) {
1101             require(msg.sender.send(safeSub(msg.value, ethToFill)));
1102         }
1103         if (remainingEth == ethToFill) {
1104             isSaleFinished = true;
1105             SaleFinished(block.timestamp);
1106             return;
1107         }
1108     }
1109 
1110     /// @dev Changes registration status of an address for participation.
1111     /// @param target Address that will be registered/deregistered.
1112     /// @param isRegistered New registration status of address.
1113     function changeRegistrationStatus(address target, bool isRegistered)
1114         public
1115         onlyOwner
1116         saleNotInitialized
1117     {
1118         registered[target] = isRegistered;
1119     }
1120 
1121     /// @dev Changes registration statuses of addresses for participation.
1122     /// @param targets Addresses that will be registered/deregistered.
1123     /// @param isRegistered New registration status of addresss.
1124     function changeRegistrationStatuses(address[] targets, bool isRegistered)
1125         public
1126         onlyOwner
1127         saleNotInitialized
1128     {
1129         for (uint i = 0; i < targets.length; i++) {
1130             changeRegistrationStatus(targets[i], isRegistered);
1131         }
1132     }
1133 
1134     /// @dev Calculates the ETH cap per address. The cap increases by double the previous increase at each next period. E.g 1, 3, 7, 15
1135     /// @return The current ETH cap per address.
1136     function getEthCapPerAddress()
1137         public
1138         constant
1139         returns (uint)
1140     {
1141         if (block.timestamp < startTimeInSec || startTimeInSec == 0) return 0;
1142 
1143         uint timeSinceStartInSec = safeSub(block.timestamp, startTimeInSec);
1144         uint currentPeriod = safeAdd(                           // currentPeriod begins at 1
1145               safeDiv(timeSinceStartInSec, TIME_PERIOD_IN_SEC), // rounds down
1146               1
1147         );
1148 
1149         uint ethCapPerAddress = safeMul(
1150             baseEthCapPerAddress,
1151             safeSub(
1152                 2 ** currentPeriod,
1153                 1
1154             )
1155         );
1156         return ethCapPerAddress;
1157     }
1158 
1159     /// @dev Verifies that an order signature is valid.
1160     /// @param pubKey Public address of signer.
1161     /// @param hash Signed Keccak-256 hash.
1162     /// @param v ECDSA signature parameter v.
1163     /// @param r ECDSA signature parameters r.
1164     /// @param s ECDSA signature parameters s.
1165     /// @return Validity of order signature.
1166     function isValidSignature(
1167         address pubKey,
1168         bytes32 hash,
1169         uint8 v,
1170         bytes32 r,
1171         bytes32 s)
1172         public
1173         constant
1174         returns (bool)
1175     {
1176         return pubKey == ecrecover(
1177             keccak256("\x19Ethereum Signed Message:\n32", hash),
1178             v,
1179             r,
1180             s
1181         );
1182     }
1183 
1184     /// @dev Getter function for initialized order's orderHash.
1185     /// @return orderHash of initialized order or null.
1186     function getOrderHash()
1187         public
1188         constant
1189         returns (bytes32)
1190     {
1191         return order.orderHash;
1192     }
1193 
1194     /// @dev Getter function for initialized order's makerTokenAmount.
1195     /// @return makerTokenAmount of initialized order or 0.
1196     function getOrderMakerTokenAmount()
1197         public
1198         constant
1199         returns (uint)
1200     {
1201         return order.makerTokenAmount;
1202     }
1203 
1204     /// @dev Getter function for initialized order's takerTokenAmount.
1205     /// @return takerTokenAmount of initialized order or 0.
1206     function getOrderTakerTokenAmount()
1207         public
1208         constant
1209         returns (uint)
1210     {
1211         return order.takerTokenAmount;
1212     }
1213 }