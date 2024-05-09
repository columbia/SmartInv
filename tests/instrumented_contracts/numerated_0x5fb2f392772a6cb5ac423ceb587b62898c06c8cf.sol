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
19 
20 /*
21 
22   Copyright 2017 ZeroEx Intl.
23 
24   Licensed under the Apache License, Version 2.0 (the "License");
25   you may not use this file except in compliance with the License.
26   You may obtain a copy of the License at
27 
28     http://www.apache.org/licenses/LICENSE-2.0
29 
30   Unless required by applicable law or agreed to in writing, software
31   distributed under the License is distributed on an "AS IS" BASIS,
32   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
33   See the License for the specific language governing permissions and
34   limitations under the License.
35 
36 */
37 
38 
39 
40 contract Token {
41 
42     /// @return total amount of tokens
43     function totalSupply() constant returns (uint supply) {}
44 
45     /// @param _owner The address from which the balance will be retrieved
46     /// @return The balance
47     function balanceOf(address _owner) constant returns (uint balance) {}
48 
49     /// @notice send `_value` token to `_to` from `msg.sender`
50     /// @param _to The address of the recipient
51     /// @param _value The amount of token to be transferred
52     /// @return Whether the transfer was successful or not
53     function transfer(address _to, uint _value) returns (bool success) {}
54 
55     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
56     /// @param _from The address of the sender
57     /// @param _to The address of the recipient
58     /// @param _value The amount of token to be transferred
59     /// @return Whether the transfer was successful or not
60     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
61 
62     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
63     /// @param _spender The address of the account able to transfer the tokens
64     /// @param _value The amount of wei to be approved for transfer
65     /// @return Whether the approval was successful or not
66     function approve(address _spender, uint _value) returns (bool success) {}
67 
68     /// @param _owner The address of the account owning tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @return Amount of remaining tokens allowed to spent
71     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
72 
73     event Transfer(address indexed _from, address indexed _to, uint _value);
74     event Approval(address indexed _owner, address indexed _spender, uint _value);
75 }
76 
77 
78 /*
79  * Ownable
80  *
81  * Base contract with an owner.
82  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
83  */
84 
85 contract Ownable {
86     address public owner;
87 
88     function Ownable() {
89         owner = msg.sender;
90     }
91 
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96 
97     function transferOwnership(address newOwner) onlyOwner {
98         if (newOwner != address(0)) {
99             owner = newOwner;
100         }
101     }
102 }
103 
104 
105 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
106 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
107 contract TokenTransferProxy is Ownable {
108 
109     /// @dev Only authorized addresses can invoke functions with this modifier.
110     modifier onlyAuthorized {
111         require(authorized[msg.sender]);
112         _;
113     }
114 
115     modifier targetAuthorized(address target) {
116         require(authorized[target]);
117         _;
118     }
119 
120     modifier targetNotAuthorized(address target) {
121         require(!authorized[target]);
122         _;
123     }
124 
125     mapping (address => bool) public authorized;
126     address[] public authorities;
127 
128     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
129     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
130 
131     function TokenTransferProxy() Ownable() {
132       // This is here for our verification code only
133     }
134 
135     /*
136      * Public functions
137      */
138 
139     /// @dev Authorizes an address.
140     /// @param target Address to authorize.
141     function addAuthorizedAddress(address target)
142         public
143         onlyOwner
144         targetNotAuthorized(target)
145     {
146         authorized[target] = true;
147         authorities.push(target);
148         LogAuthorizedAddressAdded(target, msg.sender);
149     }
150 
151     /// @dev Removes authorizion of an address.
152     /// @param target Address to remove authorization from.
153     function removeAuthorizedAddress(address target)
154         public
155         onlyOwner
156         targetAuthorized(target)
157     {
158         delete authorized[target];
159         for (uint i = 0; i < authorities.length; i++) {
160             if (authorities[i] == target) {
161                 authorities[i] = authorities[authorities.length - 1];
162                 authorities.length -= 1;
163                 break;
164             }
165         }
166         LogAuthorizedAddressRemoved(target, msg.sender);
167     }
168 
169     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
170     /// @param token Address of token to transfer.
171     /// @param from Address to transfer token from.
172     /// @param to Address to transfer token to.
173     /// @param value Amount of token to transfer.
174     /// @return Success of transfer.
175     function transferFrom(
176         address token,
177         address from,
178         address to,
179         uint value)
180         public
181         onlyAuthorized
182         returns (bool)
183     {
184         return Token(token).transferFrom(from, to, value);
185     }
186 
187     /*
188      * Public constant functions
189      */
190 
191     /// @dev Gets all authorized addresses.
192     /// @return Array of authorized addresses.
193     function getAuthorizedAddresses()
194         public
195         constant
196         returns (address[])
197     {
198         return authorities;
199     }
200 }
201 
202 
203 
204 contract SafeMath {
205     function safeMul(uint a, uint b) internal constant returns (uint256) {
206         uint c = a * b;
207         assert(a == 0 || c / a == b);
208         return c;
209     }
210 
211     function safeDiv(uint a, uint b) internal constant returns (uint256) {
212         uint c = a / b;
213         return c;
214     }
215 
216     function safeSub(uint a, uint b) internal constant returns (uint256) {
217         assert(b <= a);
218         return a - b;
219     }
220 
221     function safeAdd(uint a, uint b) internal constant returns (uint256) {
222         uint c = a + b;
223         assert(c >= a);
224         return c;
225     }
226 
227     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
228         return a >= b ? a : b;
229     }
230 
231     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
232         return a < b ? a : b;
233     }
234 
235     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
236         return a >= b ? a : b;
237     }
238 
239     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
240         return a < b ? a : b;
241     }
242 }
243 
244 
245 
246 
247 
248 contract Whitelist is Ownable {
249     mapping (address => uint128) whitelist;
250 
251     event Whitelisted(address who, uint128 nonce);
252 
253     function Whitelist() Ownable() {
254       // This is here for our verification code only
255     }
256 
257     function setWhitelisting(address who, uint128 nonce) internal {
258         whitelist[who] = nonce;
259 
260         Whitelisted(who, nonce);
261     }
262 
263     function whitelistUser(address who, uint128 nonce) external onlyOwner {
264         setWhitelisting(who, nonce);
265     }
266 
267     function whitelistMe(uint128 nonce, uint8 v, bytes32 r, bytes32 s) external {
268         bytes32 hash = keccak256(msg.sender, nonce);
269         require(ecrecover(hash, v, r, s) == owner);
270         require(whitelist[msg.sender] == 0);
271 
272         setWhitelisting(msg.sender, nonce);
273     }
274 
275     function isWhitelisted(address who) external view returns(bool) {
276         return whitelist[who] > 0;
277     }
278 }
279 
280 /// @title Exchange - Facilitates exchange of ERC20 tokens.
281 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
282 contract Exchange is SafeMath, Ownable {
283 
284     // Error Codes
285     enum Errors {
286         ORDER_EXPIRED,                    // Order has already expired
287         ORDER_FULLY_FILLED_OR_CANCELLED,  // Order has already been fully filled or cancelled
288         ROUNDING_ERROR_TOO_LARGE,         // Rounding error too large
289         INSUFFICIENT_BALANCE_OR_ALLOWANCE // Insufficient balance or allowance for token transfer
290     }
291 
292     string constant public VERSION = "1.0.0";
293     uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 4999;    // Changes to state require at least 5000 gas
294 
295     address public ZRX_TOKEN_CONTRACT;
296     address public TOKEN_TRANSFER_PROXY_CONTRACT;
297 
298     Whitelist public whitelist; // Maybe we need to make this mutable?
299 
300     // Mappings of orderHash => amounts of takerTokenAmount filled or cancelled.
301     mapping (bytes32 => uint) public filled;
302     mapping (bytes32 => uint) public cancelled;
303 
304     event LogFill(
305         address indexed maker,
306         address taker,
307         address indexed feeRecipient,
308         address makerToken,
309         address takerToken,
310         uint filledMakerTokenAmount,
311         uint filledTakerTokenAmount,
312         uint paidMakerFee,
313         uint paidTakerFee,
314         bytes32 indexed tokens, // keccak256(makerToken, takerToken), allows subscribing to a token pair
315         bytes32 orderHash
316     );
317 
318     event LogCancel(
319         address indexed maker,
320         address indexed feeRecipient,
321         address makerToken,
322         address takerToken,
323         uint cancelledMakerTokenAmount,
324         uint cancelledTakerTokenAmount,
325         bytes32 indexed tokens,
326         bytes32 orderHash
327     );
328 
329     event LogError(uint8 indexed errorId, bytes32 indexed orderHash);
330 
331     struct Order {
332         address maker;
333         address taker;
334         address makerToken;
335         address takerToken;
336         address feeRecipient;
337         uint makerTokenAmount;
338         uint takerTokenAmount;
339         uint makerFee;
340         uint takerFee;
341         uint expirationTimestampInSec;
342         bytes32 orderHash;
343     }
344 
345     modifier onlyWhitelisted() {
346       require(whitelist.isWhitelisted(msg.sender));
347 
348       _;
349     }
350 
351     function Exchange(address _zrxToken, address _tokenTransferProxy, Whitelist _whitelist) {
352         ZRX_TOKEN_CONTRACT = _zrxToken;
353         TOKEN_TRANSFER_PROXY_CONTRACT = _tokenTransferProxy;
354         whitelist = _whitelist;
355     }
356 
357     /*
358     * Core exchange functions
359     */
360 
361     /// @dev Fills the input order.
362     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
363     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
364     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
365     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfer will fail before attempting.
366     /// @param v ECDSA signature parameter v.
367     /// @param r ECDSA signature parameters r.
368     /// @param s ECDSA signature parameters s.
369     /// @return Total amount of takerToken filled in trade.
370     function fillOrder(
371           address[5] orderAddresses,
372           uint[6] orderValues,
373           uint fillTakerTokenAmount,
374           bool shouldThrowOnInsufficientBalanceOrAllowance,
375           uint8 v,
376           bytes32 r,
377           bytes32 s)
378           public
379           onlyWhitelisted
380           returns (uint filledTakerTokenAmount)
381     {
382         Order memory order = Order({
383             maker: orderAddresses[0],
384             taker: orderAddresses[1],
385             makerToken: orderAddresses[2],
386             takerToken: orderAddresses[3],
387             feeRecipient: orderAddresses[4],
388             makerTokenAmount: orderValues[0],
389             takerTokenAmount: orderValues[1],
390             makerFee: orderValues[2],
391             takerFee: orderValues[3],
392             expirationTimestampInSec: orderValues[4],
393             orderHash: getOrderHash(orderAddresses, orderValues)
394         });
395 
396         require(order.taker == address(0) || order.taker == msg.sender);
397 
398         require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && fillTakerTokenAmount > 0);
399 
400         require(isValidSignature(
401             order.maker,
402             order.orderHash,
403             v,
404             r,
405             s
406         ));
407 
408         if (block.timestamp >= order.expirationTimestampInSec) {
409             LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
410             return 0;
411         }
412 
413         uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
414         filledTakerTokenAmount = min256(fillTakerTokenAmount, remainingTakerTokenAmount);
415         if (filledTakerTokenAmount == 0) {
416             LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
417             return 0;
418         }
419 
420         if (isRoundingError(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount)) {
421             LogError(uint8(Errors.ROUNDING_ERROR_TOO_LARGE), order.orderHash);
422             return 0;
423         }
424 
425         if (!shouldThrowOnInsufficientBalanceOrAllowance && !isTransferable(order, filledTakerTokenAmount)) {
426             LogError(uint8(Errors.INSUFFICIENT_BALANCE_OR_ALLOWANCE), order.orderHash);
427             return 0;
428         }
429 
430         uint filledMakerTokenAmount = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
431         uint paidMakerFee;
432         uint paidTakerFee;
433         filled[order.orderHash] = safeAdd(filled[order.orderHash], filledTakerTokenAmount);
434 
435         require(transferViaTokenTransferProxy(
436             order.makerToken,
437             order.maker,
438             msg.sender,
439             filledMakerTokenAmount
440         ));
441 
442         require(transferViaTokenTransferProxy(
443             order.takerToken,
444             msg.sender,
445             order.maker,
446             filledTakerTokenAmount
447         ));
448 
449         if (order.feeRecipient != address(0)) {
450             if (order.makerFee > 0) {
451                 paidMakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.makerFee);
452                 require(transferViaTokenTransferProxy(
453                     ZRX_TOKEN_CONTRACT,
454                     order.maker,
455                     order.feeRecipient,
456                     paidMakerFee
457                 ));
458             }
459             if (order.takerFee > 0) {
460                 paidTakerFee = getPartialAmount(filledTakerTokenAmount, order.takerTokenAmount, order.takerFee);
461                 require(transferViaTokenTransferProxy(
462                     ZRX_TOKEN_CONTRACT,
463                     msg.sender,
464                     order.feeRecipient,
465                     paidTakerFee
466                 ));
467             }
468         }
469 
470         LogFill(
471             order.maker,
472             msg.sender,
473             order.feeRecipient,
474             order.makerToken,
475             order.takerToken,
476             filledMakerTokenAmount,
477             filledTakerTokenAmount,
478             paidMakerFee,
479             paidTakerFee,
480             keccak256(order.makerToken, order.takerToken),
481             order.orderHash
482         );
483         return filledTakerTokenAmount;
484     }
485 
486     /// @dev Cancels the input order.
487     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
488     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
489     /// @param cancelTakerTokenAmount Desired amount of takerToken to cancel in order.
490     /// @return Amount of takerToken cancelled.
491     function cancelOrder(
492         address[5] orderAddresses,
493         uint[6] orderValues,
494         uint cancelTakerTokenAmount)
495         public
496         onlyWhitelisted
497         returns (uint)
498     {
499         Order memory order = Order({
500             maker: orderAddresses[0],
501             taker: orderAddresses[1],
502             makerToken: orderAddresses[2],
503             takerToken: orderAddresses[3],
504             feeRecipient: orderAddresses[4],
505             makerTokenAmount: orderValues[0],
506             takerTokenAmount: orderValues[1],
507             makerFee: orderValues[2],
508             takerFee: orderValues[3],
509             expirationTimestampInSec: orderValues[4],
510             orderHash: getOrderHash(orderAddresses, orderValues)
511         });
512 
513         require(order.maker == msg.sender);
514         require(order.makerTokenAmount > 0 && order.takerTokenAmount > 0 && cancelTakerTokenAmount > 0);
515 
516         if (block.timestamp >= order.expirationTimestampInSec) {
517             LogError(uint8(Errors.ORDER_EXPIRED), order.orderHash);
518             return 0;
519         }
520 
521         uint remainingTakerTokenAmount = safeSub(order.takerTokenAmount, getUnavailableTakerTokenAmount(order.orderHash));
522         uint cancelledTakerTokenAmount = min256(cancelTakerTokenAmount, remainingTakerTokenAmount);
523         if (cancelledTakerTokenAmount == 0) {
524             LogError(uint8(Errors.ORDER_FULLY_FILLED_OR_CANCELLED), order.orderHash);
525             return 0;
526         }
527 
528         cancelled[order.orderHash] = safeAdd(cancelled[order.orderHash], cancelledTakerTokenAmount);
529 
530         LogCancel(
531             order.maker,
532             order.feeRecipient,
533             order.makerToken,
534             order.takerToken,
535             getPartialAmount(cancelledTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount),
536             cancelledTakerTokenAmount,
537             keccak256(order.makerToken, order.takerToken),
538             order.orderHash
539         );
540         return cancelledTakerTokenAmount;
541     }
542 
543     /*
544     * Wrapper functions
545     */
546 
547     /// @dev Fills an order with specified parameters and ECDSA signature, throws if specified amount not filled entirely.
548     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
549     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
550     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
551     /// @param v ECDSA signature parameter v.
552     /// @param r ECDSA signature parameters r.
553     /// @param s ECDSA signature parameters s.
554     function fillOrKillOrder(
555         address[5] orderAddresses,
556         uint[6] orderValues,
557         uint fillTakerTokenAmount,
558         uint8 v,
559         bytes32 r,
560         bytes32 s)
561         public
562     {
563         require(fillOrder(
564             orderAddresses,
565             orderValues,
566             fillTakerTokenAmount,
567             false,
568             v,
569             r,
570             s
571         ) == fillTakerTokenAmount);
572     }
573 
574     /// @dev Synchronously executes multiple fill orders in a single transaction.
575     /// @param orderAddresses Array of address arrays containing individual order addresses.
576     /// @param orderValues Array of uint arrays containing individual order values.
577     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
578     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
579     /// @param v Array ECDSA signature v parameters.
580     /// @param r Array of ECDSA signature r parameters.
581     /// @param s Array of ECDSA signature s parameters.
582     function batchFillOrders(
583         address[5][] orderAddresses,
584         uint[6][] orderValues,
585         uint[] fillTakerTokenAmounts,
586         bool shouldThrowOnInsufficientBalanceOrAllowance,
587         uint8[] v,
588         bytes32[] r,
589         bytes32[] s)
590         public
591     {
592         for (uint i = 0; i < orderAddresses.length; i++) {
593             fillOrder(
594                 orderAddresses[i],
595                 orderValues[i],
596                 fillTakerTokenAmounts[i],
597                 shouldThrowOnInsufficientBalanceOrAllowance,
598                 v[i],
599                 r[i],
600                 s[i]
601             );
602         }
603     }
604 
605     /// @dev Synchronously executes multiple fillOrKill orders in a single transaction.
606     /// @param orderAddresses Array of address arrays containing individual order addresses.
607     /// @param orderValues Array of uint arrays containing individual order values.
608     /// @param fillTakerTokenAmounts Array of desired amounts of takerToken to fill in orders.
609     /// @param v Array ECDSA signature v parameters.
610     /// @param r Array of ECDSA signature r parameters.
611     /// @param s Array of ECDSA signature s parameters.
612     function batchFillOrKillOrders(
613         address[5][] orderAddresses,
614         uint[6][] orderValues,
615         uint[] fillTakerTokenAmounts,
616         uint8[] v,
617         bytes32[] r,
618         bytes32[] s)
619         public
620     {
621         for (uint i = 0; i < orderAddresses.length; i++) {
622             fillOrKillOrder(
623                 orderAddresses[i],
624                 orderValues[i],
625                 fillTakerTokenAmounts[i],
626                 v[i],
627                 r[i],
628                 s[i]
629             );
630         }
631     }
632 
633     /// @dev Synchronously executes multiple fill orders in a single transaction until total fillTakerTokenAmount filled.
634     /// @param orderAddresses Array of address arrays containing individual order addresses.
635     /// @param orderValues Array of uint arrays containing individual order values.
636     /// @param fillTakerTokenAmount Desired total amount of takerToken to fill in orders.
637     /// @param shouldThrowOnInsufficientBalanceOrAllowance Test if transfers will fail before attempting.
638     /// @param v Array ECDSA signature v parameters.
639     /// @param r Array of ECDSA signature r parameters.
640     /// @param s Array of ECDSA signature s parameters.
641     /// @return Total amount of fillTakerTokenAmount filled in orders.
642     function fillOrdersUpTo(
643         address[5][] orderAddresses,
644         uint[6][] orderValues,
645         uint fillTakerTokenAmount,
646         bool shouldThrowOnInsufficientBalanceOrAllowance,
647         uint8[] v,
648         bytes32[] r,
649         bytes32[] s)
650         public
651         returns (uint)
652     {
653         uint filledTakerTokenAmount = 0;
654         for (uint i = 0; i < orderAddresses.length; i++) {
655             require(orderAddresses[i][3] == orderAddresses[0][3]); // takerToken must be the same for each order
656             filledTakerTokenAmount = safeAdd(filledTakerTokenAmount, fillOrder(
657                 orderAddresses[i],
658                 orderValues[i],
659                 safeSub(fillTakerTokenAmount, filledTakerTokenAmount),
660                 shouldThrowOnInsufficientBalanceOrAllowance,
661                 v[i],
662                 r[i],
663                 s[i]
664             ));
665             if (filledTakerTokenAmount == fillTakerTokenAmount) break;
666         }
667         return filledTakerTokenAmount;
668     }
669 
670     /// @dev Synchronously cancels multiple orders in a single transaction.
671     /// @param orderAddresses Array of address arrays containing individual order addresses.
672     /// @param orderValues Array of uint arrays containing individual order values.
673     /// @param cancelTakerTokenAmounts Array of desired amounts of takerToken to cancel in orders.
674     function batchCancelOrders(
675         address[5][] orderAddresses,
676         uint[6][] orderValues,
677         uint[] cancelTakerTokenAmounts)
678         public
679     {
680         for (uint i = 0; i < orderAddresses.length; i++) {
681             cancelOrder(
682                 orderAddresses[i],
683                 orderValues[i],
684                 cancelTakerTokenAmounts[i]
685             );
686         }
687     }
688 
689     /*
690     * Constant public functions
691     */
692 
693     /// @dev Calculates Keccak-256 hash of order with specified parameters.
694     /// @param orderAddresses Array of order's maker, taker, makerToken, takerToken, and feeRecipient.
695     /// @param orderValues Array of order's makerTokenAmount, takerTokenAmount, makerFee, takerFee, expirationTimestampInSec, and salt.
696     /// @return Keccak-256 hash of order.
697     function getOrderHash(address[5] orderAddresses, uint[6] orderValues)
698         public
699         constant
700         returns (bytes32)
701     {
702         return keccak256(
703             address(this),
704             orderAddresses[0], // maker
705             orderAddresses[1], // taker
706             orderAddresses[2], // makerToken
707             orderAddresses[3], // takerToken
708             orderAddresses[4], // feeRecipient
709             orderValues[0],    // makerTokenAmount
710             orderValues[1],    // takerTokenAmount
711             orderValues[2],    // makerFee
712             orderValues[3],    // takerFee
713             orderValues[4],    // expirationTimestampInSec
714             orderValues[5]     // salt
715         );
716     }
717 
718     function getKeccak(bytes32 hash) public constant returns(bytes32) {
719         return keccak256("\x19Ethereum Signed Message:\n32", hash);
720     }
721 
722     function getSigner(
723         bytes32 hash,
724         uint8 v,
725         bytes32 r,
726         bytes32 s)
727         public
728         constant
729         returns (address)
730     {
731         return ecrecover(
732             keccak256("\x19Ethereum Signed Message:\n32", hash),
733             v,
734             r,
735             s
736         );
737     }
738 
739     function testRecovery(bytes32 h, uint8 v, bytes32 r, bytes32 s) returns (address) {
740         /* prefix might be needed for geth only
741          * https://github.com/ethereum/go-ethereum/issues/3731
742          */
743         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
744         h = sha3(prefix, h);
745 
746         address addr = ecrecover(h, v, r, s);
747 
748         return addr;
749     }
750 
751      function checkSigned(
752         bytes32 hash,
753         uint8 v,
754         bytes32 r,
755         bytes32 s)
756         public
757         constant
758         returns (address)
759     {
760         return ecrecover(
761             hash,
762             v,
763             r,
764             s
765         );
766     }
767 
768     /// @dev Verifies that an order signature is valid.
769     /// @param signer address of signer.
770     /// @param hash Signed Keccak-256 hash.
771     /// @param v ECDSA signature parameter v.
772     /// @param r ECDSA signature parameters r.
773     /// @param s ECDSA signature parameters s.
774     /// @return Validity of order signature.
775     function isValidSignature(
776         address signer,
777         bytes32 hash,
778         uint8 v,
779         bytes32 r,
780         bytes32 s)
781         public
782         constant
783         returns (bool)
784     {
785         return signer == ecrecover(
786             keccak256("\x19Ethereum Signed Message:\n32", hash),
787             v,
788             r,
789             s
790         );
791     }
792 
793     /// @dev Checks if rounding error > 0.1%.
794     /// @param numerator Numerator.
795     /// @param denominator Denominator.
796     /// @param target Value to multiply with numerator/denominator.
797     /// @return Rounding error is present.
798     function isRoundingError(uint numerator, uint denominator, uint target)
799         public
800         constant
801         returns (bool)
802     {
803         uint remainder = mulmod(target, numerator, denominator);
804         if (remainder == 0) return false; // No rounding error.
805 
806         uint errPercentageTimes1000000 = safeDiv(
807             safeMul(remainder, 1000000),
808             safeMul(numerator, target)
809         );
810         return errPercentageTimes1000000 > 1000;
811     }
812 
813     /// @dev Calculates partial value given a numerator and denominator.
814     /// @param numerator Numerator.
815     /// @param denominator Denominator.
816     /// @param target Value to calculate partial of.
817     /// @return Partial value of target.
818     function getPartialAmount(uint numerator, uint denominator, uint target)
819         public
820         constant
821         returns (uint)
822     {
823         return safeDiv(safeMul(numerator, target), denominator);
824     }
825 
826     /// @dev Calculates the sum of values already filled and cancelled for a given order.
827     /// @param orderHash The Keccak-256 hash of the given order.
828     /// @return Sum of values already filled and cancelled.
829     function getUnavailableTakerTokenAmount(bytes32 orderHash)
830         public
831         constant
832         returns (uint)
833     {
834         return safeAdd(filled[orderHash], cancelled[orderHash]);
835     }
836 
837 
838     /*
839     * Internal functions
840     */
841 
842     /// @dev Transfers a token using TokenTransferProxy transferFrom function.
843     /// @param token Address of token to transferFrom.
844     /// @param from Address transfering token.
845     /// @param to Address receiving token.
846     /// @param value Amount of token to transfer.
847     /// @return Success of token transfer.
848     function transferViaTokenTransferProxy(
849         address token,
850         address from,
851         address to,
852         uint value)
853         internal
854         returns (bool)
855     {
856         return TokenTransferProxy(TOKEN_TRANSFER_PROXY_CONTRACT).transferFrom(token, from, to, value);
857     }
858 
859     /// @dev Checks if any order transfers will fail.
860     /// @param order Order struct of params that will be checked.
861     /// @param fillTakerTokenAmount Desired amount of takerToken to fill.
862     /// @return Predicted result of transfers.
863     function isTransferable(Order order, uint fillTakerTokenAmount)
864         internal
865         constant  // The called token contracts may attempt to change state, but will not be able to due to gas limits on getBalance and getAllowance.
866         returns (bool)
867     {
868         address taker = msg.sender;
869         uint fillMakerTokenAmount = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerTokenAmount);
870 
871         if (order.feeRecipient != address(0)) {
872             bool isMakerTokenZRX = order.makerToken == ZRX_TOKEN_CONTRACT;
873             bool isTakerTokenZRX = order.takerToken == ZRX_TOKEN_CONTRACT;
874             uint paidMakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.makerFee);
875             uint paidTakerFee = getPartialAmount(fillTakerTokenAmount, order.takerTokenAmount, order.takerFee);
876             uint requiredMakerZRX = isMakerTokenZRX ? safeAdd(fillMakerTokenAmount, paidMakerFee) : paidMakerFee;
877             uint requiredTakerZRX = isTakerTokenZRX ? safeAdd(fillTakerTokenAmount, paidTakerFee) : paidTakerFee;
878 
879             if (   getBalance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
880                 || getAllowance(ZRX_TOKEN_CONTRACT, order.maker) < requiredMakerZRX
881                 || getBalance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
882                 || getAllowance(ZRX_TOKEN_CONTRACT, taker) < requiredTakerZRX
883             ) return false;
884 
885             if (!isMakerTokenZRX && (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount // Don't double check makerToken if ZRX
886                                      || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount)
887             ) return false;
888             if (!isTakerTokenZRX && (   getBalance(order.takerToken, taker) < fillTakerTokenAmount // Don't double check takerToken if ZRX
889                                      || getAllowance(order.takerToken, taker) < fillTakerTokenAmount)
890             ) return false;
891         } else if (   getBalance(order.makerToken, order.maker) < fillMakerTokenAmount
892                    || getAllowance(order.makerToken, order.maker) < fillMakerTokenAmount
893                    || getBalance(order.takerToken, taker) < fillTakerTokenAmount
894                    || getAllowance(order.takerToken, taker) < fillTakerTokenAmount
895         ) return false;
896 
897         return true;
898     }
899 
900     /// @dev Get token balance of an address.
901     /// @param token Address of token.
902     /// @param owner Address of owner.
903     /// @return Token balance of owner.
904     function getBalance(address token, address owner)
905         internal
906         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
907         returns (uint)
908     {
909         return Token(token).balanceOf.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner); // Limit gas to prevent reentrancy
910     }
911 
912     /// @dev Get allowance of token given to TokenTransferProxy by an address.
913     /// @param token Address of token.
914     /// @param owner Address of owner.
915     /// @return Allowance of token given to TokenTransferProxy by owner.
916     function getAllowance(address token, address owner)
917         internal
918         constant  // The called token contract may attempt to change state, but will not be able to due to an added gas limit.
919         returns (uint)
920     {
921         return Token(token).allowance.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner, TOKEN_TRANSFER_PROXY_CONTRACT); // Limit gas to prevent reentrancy
922     }
923 
924     /// @dev This function permits setting the Whitelist address
925     /// @param _whitelist Whitelist address
926     function setWhitelist(Whitelist _whitelist) public onlyOwner
927     {
928         whitelist = _whitelist;
929     }
930 }