1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /**
165  * @dev Contract module that helps prevent reentrant calls to a function.
166  *
167  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
168  * available, which can be applied to functions to make sure there are no nested
169  * (reentrant) calls to them.
170  *
171  * Note that because there is a single `nonReentrant` guard, functions marked as
172  * `nonReentrant` may not call one another. This can be worked around by making
173  * those functions `private`, and then adding `external` `nonReentrant` entry
174  * points to them.
175  *
176  * TIP: If you would like to learn more about reentrancy and alternative ways
177  * to protect against it, check out our blog post
178  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
179  *
180  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
181  * metering changes introduced in the Istanbul hardfork.
182  */
183 contract ReentrancyGuard {
184     bool private _notEntered;
185 
186     constructor () internal {
187         // Storing an initial non-zero value makes deployment a bit more
188         // expensive, but in exchange the refund on every call to nonReentrant
189         // will be lower in amount. Since refunds are capped to a percetange of
190         // the total transaction's gas, it is best to keep them low in cases
191         // like this one, to increase the likelihood of the full refund coming
192         // into effect.
193         _notEntered = true;
194     }
195 
196     /**
197      * @dev Prevents a contract from calling itself, directly or indirectly.
198      * Calling a `nonReentrant` function from another `nonReentrant`
199      * function is not supported. It is possible to prevent this from happening
200      * by making the `nonReentrant` function external, and make it call a
201      * `private` function that does the actual work.
202      */
203     modifier nonReentrant() {
204         // On the first call to nonReentrant, _notEntered will be true
205         require(_notEntered, "ReentrancyGuard: reentrant call");
206 
207         // Any calls to nonReentrant after this point will fail
208         _notEntered = false;
209 
210         _;
211 
212         // By storing the original value once again, a refund is triggered (see
213         // https://eips.ethereum.org/EIPS/eip-2200)
214         _notEntered = true;
215     }
216 }
217 
218 // File: contracts/lib/AddressHelper.sol
219 
220 pragma solidity 0.5.17;
221 
222 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
223 library AddressHelper {
224     function safeTransfer(
225         address token,
226         address to,
227         uint256 value
228     ) internal {
229         // bytes4(keccak256(bytes('transfer(address,uint256)')));
230         (bool success, bytes memory data) = token.call(
231             abi.encodeWithSelector(0xa9059cbb, to, value)
232         );
233         require(
234             success && (data.length == 0 || abi.decode(data, (bool))),
235             "TRANSFER_FAILED"
236         );
237     }
238 
239     function safeTransferFrom(
240         address token,
241         address from,
242         address to,
243         uint256 value
244     ) internal {
245         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
246         (bool success, bytes memory data) = token.call(
247             abi.encodeWithSelector(0x23b872dd, from, to, value)
248         );
249         require(
250             success && (data.length == 0 || abi.decode(data, (bool))),
251             "TRANSFER_FROM_FAILED"
252         );
253     }
254 
255     function safeTransferEther(address to, uint256 value) internal {
256         (bool success, ) = to.call.value(value)(new bytes(0));
257         require(success, "ETH_TRANSFER_FAILED");
258     }
259 
260     function isContract(address token) internal view returns (bool) {
261         if (token == address(0x0)) {
262             return false;
263         }
264         uint256 size;
265         assembly {
266             size := extcodesize(token)
267         }
268         return size > 0;
269     }
270 
271     /**
272      * @dev returns the address used within the protocol to identify ETH
273      * @return the address assigned to ETH
274      */
275     function ethAddress() internal pure returns (address) {
276         return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
277     }
278 }
279 
280 // File: contracts/lib/XNum.sol
281 
282 pragma solidity 0.5.17;
283 
284 library XNum {
285     uint256 public constant BONE = 10**18;
286     uint256 public constant MIN_BPOW_BASE = 1 wei;
287     uint256 public constant MAX_BPOW_BASE = (2 * BONE) - 1 wei;
288     uint256 public constant BPOW_PRECISION = BONE / 10**10;
289 
290     function btoi(uint256 a) internal pure returns (uint256) {
291         return a / BONE;
292     }
293 
294     function bfloor(uint256 a) internal pure returns (uint256) {
295         return btoi(a) * BONE;
296     }
297 
298     function badd(uint256 a, uint256 b) internal pure returns (uint256) {
299         uint256 c = a + b;
300         require(c >= a, "ERR_ADD_OVERFLOW");
301         return c;
302     }
303 
304     function bsub(uint256 a, uint256 b) internal pure returns (uint256) {
305         (uint256 c, bool flag) = bsubSign(a, b);
306         require(!flag, "ERR_SUB_UNDERFLOW");
307         return c;
308     }
309 
310     function bsubSign(uint256 a, uint256 b)
311         internal
312         pure
313         returns (uint256, bool)
314     {
315         if (a >= b) {
316             return (a - b, false);
317         } else {
318             return (b - a, true);
319         }
320     }
321 
322     function bmul(uint256 a, uint256 b) internal pure returns (uint256) {
323         uint256 c0 = a * b;
324         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
325         uint256 c1 = c0 + (BONE / 2);
326         require(c1 >= c0, "ERR_MUL_OVERFLOW");
327         uint256 c2 = c1 / BONE;
328         return c2;
329     }
330 
331     function bdiv(uint256 a, uint256 b) internal pure returns (uint256) {
332         require(b != 0, "ERR_DIV_ZERO");
333         uint256 c0 = a * BONE;
334         require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow
335         uint256 c1 = c0 + (b / 2);
336         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
337         uint256 c2 = c1 / b;
338         return c2;
339     }
340 
341     // DSMath.wpow
342     function bpowi(uint256 a, uint256 n) internal pure returns (uint256) {
343         uint256 z = n % 2 != 0 ? a : BONE;
344 
345         for (n /= 2; n != 0; n /= 2) {
346             a = bmul(a, a);
347 
348             if (n % 2 != 0) {
349                 z = bmul(z, a);
350             }
351         }
352         return z;
353     }
354 
355     // Compute b^(e.w) by splitting it into (b^e)*(b^0.w).
356     // Use `bpowi` for `b^e` and `bpowK` for k iterations
357     // of approximation of b^0.w
358     function bpow(uint256 base, uint256 exp) internal pure returns (uint256) {
359         require(base >= MIN_BPOW_BASE, "ERR_BPOW_BASE_TOO_LOW");
360         require(base <= MAX_BPOW_BASE, "ERR_BPOW_BASE_TOO_HIGH");
361 
362         uint256 whole = bfloor(exp);
363         uint256 remain = bsub(exp, whole);
364 
365         uint256 wholePow = bpowi(base, btoi(whole));
366 
367         if (remain == 0) {
368             return wholePow;
369         }
370 
371         uint256 partialResult = bpowApprox(base, remain, BPOW_PRECISION);
372         return bmul(wholePow, partialResult);
373     }
374 
375     function bpowApprox(
376         uint256 base,
377         uint256 exp,
378         uint256 precision
379     ) internal pure returns (uint256) {
380         // term 0:
381         uint256 a = exp;
382         (uint256 x, bool xneg) = bsubSign(base, BONE);
383         uint256 term = BONE;
384         uint256 sum = term;
385         bool negative = false;
386 
387         // term(k) = numer / denom
388         //         = (product(a - i + 1, i=1-->k) * x^k) / (k!)
389         // each iteration, multiply previous term by (a-(k-1)) * x / k
390         // continue until term is less than precision
391         for (uint256 i = 1; term >= precision; i++) {
392             uint256 bigK = i * BONE;
393             (uint256 c, bool cneg) = bsubSign(a, bsub(bigK, BONE));
394             term = bmul(term, bmul(c, x));
395             term = bdiv(term, bigK);
396             if (term == 0) break;
397 
398             if (xneg) negative = !negative;
399             if (cneg) negative = !negative;
400             if (negative) {
401                 sum = bsub(sum, term);
402             } else {
403                 sum = badd(sum, term);
404             }
405         }
406 
407         return sum;
408     }
409 }
410 
411 // File: contracts/interfaces/IERC20.sol
412 
413 pragma solidity 0.5.17;
414 
415 interface IERC20 {
416     function name() external view returns (string memory);
417 
418     function symbol() external view returns (string memory);
419 
420     function decimals() external view returns (uint8);
421 
422     function totalSupply() external view returns (uint256);
423 
424     function balanceOf(address _owner) external view returns (uint256 balance);
425 
426     function transfer(address _to, uint256 _value)
427         external
428         returns (bool success);
429 
430     function transferFrom(
431         address _from,
432         address _to,
433         uint256 _value
434     ) external returns (bool success);
435 
436     function approve(address _spender, uint256 _value)
437         external
438         returns (bool success);
439 
440     function allowance(address _owner, address _spender)
441         external
442         view
443         returns (uint256 remaining);
444 }
445 
446 // File: contracts/XHalfLife.sol
447 
448 pragma solidity 0.5.17;
449 
450 
451 
452 
453 
454 
455 contract XHalfLife is ReentrancyGuard {
456     using SafeMath for uint256;
457     using AddressHelper for address;
458 
459     uint256 private constant ONE = 10**18;
460 
461     /**
462      * @notice Counter for new stream ids.
463      */
464     uint256 public nextStreamId = 1;
465 
466     /**
467      * @notice key: stream id, value: minimum effective value(0.0001 TOKEN)
468      */
469     mapping(uint256 => uint256) public effectiveValues;
470 
471     // halflife stream
472     struct Stream {
473         uint256 depositAmount; // total deposited amount, must >= 0.0001 TOKEN
474         uint256 remaining; // un-withdrawable balance
475         uint256 withdrawable; // withdrawable balance
476         uint256 startBlock; // when should start
477         uint256 kBlock; // interval K blocks
478         uint256 unlockRatio; // must be between [1-999], which means 0.1% to 99.9%
479         uint256 denom; // one readable coin represent
480         uint256 lastRewardBlock; // update by create(), fund() and withdraw()
481         address token; // ERC20 token address or 0xEe for Ether
482         address recipient;
483         address sender;
484         bool cancelable; // can be cancelled or not
485         bool isEntity;
486     }
487 
488     /**
489      * @notice The stream objects identifiable by their unsigned integer ids.
490      */
491     mapping(uint256 => Stream) public streams;
492 
493     /**
494      * @dev Throws if the provided id does not point to a valid stream.
495      */
496     modifier streamExists(uint256 streamId) {
497         require(streams[streamId].isEntity, "stream does not exist");
498         _;
499     }
500 
501     /**
502      * @dev Throws if the caller is not the sender of the recipient of the stream.
503      *  Throws if the recipient is the zero address, the contract itself or the caller.
504      *  Throws if the depositAmount is 0.
505      *  Throws if the start block is before `block.number`.
506      */
507     modifier createStreamPreflight(
508         address recipient,
509         uint256 depositAmount,
510         uint256 startBlock,
511         uint256 kBlock
512     ) {
513         require(recipient != address(0), "stream to the zero address");
514         require(recipient != address(this), "stream to the contract itself");
515         require(recipient != msg.sender, "stream to the caller");
516         require(depositAmount > 0, "deposit amount is zero");
517         require(startBlock >= block.number, "start block before block.number");
518         require(kBlock > 0, "k block is zero");
519         _;
520     }
521 
522     event StreamCreated(
523         uint256 indexed streamId,
524         address indexed sender,
525         address indexed recipient,
526         address token,
527         uint256 depositAmount,
528         uint256 startBlock,
529         uint256 kBlock,
530         uint256 unlockRatio,
531         bool cancelable
532     );
533 
534     event WithdrawFromStream(
535         uint256 indexed streamId,
536         address indexed recipient,
537         uint256 amount
538     );
539 
540     event StreamCanceled(
541         uint256 indexed streamId,
542         address indexed sender,
543         address indexed recipient,
544         uint256 senderBalance,
545         uint256 recipientBalance
546     );
547 
548     event StreamFunded(uint256 indexed streamId, uint256 amount);
549 
550     /**
551      * @notice Creates a new stream funded by `msg.sender` and paid towards `recipient`.
552      * @dev Throws if paused.
553      *  Throws if the token is not a contract address
554      *  Throws if the recipient is the zero address, the contract itself or the caller.
555      *  Throws if the depositAmount is 0.
556      *  Throws if the start block is before `block.number`.
557      *  Throws if the rate calculation has a math error.
558      *  Throws if the next stream id calculation has a math error.
559      *  Throws if the contract is not allowed to transfer enough tokens.
560      * @param token The ERC20 token address
561      * @param recipient The address towards which the money is streamed.
562      * @param depositAmount The amount of money to be streamed.
563      * @param startBlock stream start block
564      * @param kBlock unlock every k blocks
565      * @param unlockRatio unlock ratio from remaining balance,
566      *                    value must be between [1-1000], which means 0.1% to 1%
567      * @param cancelable can be cancelled or not
568      * @return The uint256 id of the newly created stream.
569      */
570     function createStream(
571         address token,
572         address recipient,
573         uint256 depositAmount,
574         uint256 startBlock,
575         uint256 kBlock,
576         uint256 unlockRatio,
577         bool cancelable
578     )
579         external
580         createStreamPreflight(recipient, depositAmount, startBlock, kBlock)
581         returns (uint256 streamId)
582     {
583         require(unlockRatio < 1000, "unlockRatio must < 1000");
584         require(unlockRatio > 0, "unlockRatio must > 0");
585 
586         require(token.isContract(), "not contract");
587         token.safeTransferFrom(msg.sender, address(this), depositAmount);
588 
589         streamId = nextStreamId;
590         {
591             uint256 denom = 10**uint256(IERC20(token).decimals());
592             require(denom >= 10**6, "token decimal too small");
593 
594             // 0.0001 TOKEN
595             effectiveValues[streamId] = denom.div(10**4);
596             require(
597                 depositAmount >= effectiveValues[streamId],
598                 "deposit too small"
599             );
600 
601             streams[streamId] = Stream({
602                 token: token,
603                 remaining: depositAmount,
604                 withdrawable: 0,
605                 depositAmount: depositAmount,
606                 startBlock: startBlock,
607                 kBlock: kBlock,
608                 unlockRatio: unlockRatio,
609                 denom: denom,
610                 lastRewardBlock: startBlock,
611                 recipient: recipient,
612                 sender: msg.sender,
613                 isEntity: true,
614                 cancelable: cancelable
615             });
616         }
617 
618         nextStreamId = nextStreamId.add(1);
619         emit StreamCreated(
620             streamId,
621             msg.sender,
622             recipient,
623             token,
624             depositAmount,
625             startBlock,
626             kBlock,
627             unlockRatio,
628             cancelable
629         );
630     }
631 
632     /**
633      * @notice Creates a new ether stream funded by `msg.sender` and paid towards `recipient`.
634      * @dev Throws if paused.
635      *  Throws if the recipient is the zero address, the contract itself or the caller.
636      *  Throws if the depositAmount is 0.
637      *  Throws if the start block is before `block.number`.
638      *  Throws if the rate calculation has a math error.
639      *  Throws if the next stream id calculation has a math error.
640      *  Throws if the contract is not allowed to transfer enough tokens.
641      * @param recipient The address towards which the money is streamed.
642      * @param startBlock stream start block
643      * @param kBlock unlock every k blocks
644      * @param unlockRatio unlock ratio from remaining balance
645      * @param cancelable can be cancelled or not
646      * @return The uint256 id of the newly created stream.
647      */
648     function createEtherStream(
649         address recipient,
650         uint256 startBlock,
651         uint256 kBlock,
652         uint256 unlockRatio,
653         bool cancelable
654     )
655         external
656         payable
657         createStreamPreflight(recipient, msg.value, startBlock, kBlock)
658         returns (uint256 streamId)
659     {
660         require(unlockRatio < 1000, "unlockRatio must < 1000");
661         require(unlockRatio > 0, "unlockRatio must > 0");
662         require(msg.value >= 10**14, "deposit too small");
663 
664         /* Create and store the stream object. */
665         streamId = nextStreamId;
666         streams[streamId] = Stream({
667             token: AddressHelper.ethAddress(),
668             remaining: msg.value,
669             withdrawable: 0,
670             depositAmount: msg.value,
671             startBlock: startBlock,
672             kBlock: kBlock,
673             unlockRatio: unlockRatio,
674             denom: 10**18,
675             lastRewardBlock: startBlock,
676             recipient: recipient,
677             sender: msg.sender,
678             isEntity: true,
679             cancelable: cancelable
680         });
681 
682         nextStreamId = nextStreamId.add(1);
683         emit StreamCreated(
684             streamId,
685             msg.sender,
686             recipient,
687             AddressHelper.ethAddress(),
688             msg.value,
689             startBlock,
690             kBlock,
691             unlockRatio,
692             cancelable
693         );
694     }
695 
696     /**
697      * @notice Check if given stream exists.
698      * @param streamId The id of the stream to query.
699      * @return bool true=exists, otherwise false.
700      */
701     function hasStream(uint256 streamId) external view returns (bool) {
702         return streams[streamId].isEntity;
703     }
704 
705     /**
706      * @notice Returns the stream with all its properties.
707      * @dev Throws if the id does not point to a valid stream.
708      * @param streamId The id of the stream to query.
709      * @return sender
710      * @return recipient
711      * @return token
712      * @return depositAmount
713      * @return startBlock
714      * @return kBlock
715      * @return remaining
716      * @return withdrawable
717      * @return unlockRatio
718      * @return lastRewardBlock
719      * @return cancelable
720      */
721     function getStream(uint256 streamId)
722         external
723         view
724         streamExists(streamId)
725         returns (
726             address sender,
727             address recipient,
728             address token,
729             uint256 depositAmount,
730             uint256 startBlock,
731             uint256 kBlock,
732             uint256 remaining,
733             uint256 withdrawable,
734             uint256 unlockRatio,
735             uint256 lastRewardBlock,
736             bool cancelable
737         )
738     {
739         Stream memory stream = streams[streamId];
740         sender = stream.sender;
741         recipient = stream.recipient;
742         token = stream.token;
743         depositAmount = stream.depositAmount;
744         startBlock = stream.startBlock;
745         kBlock = stream.kBlock;
746         remaining = stream.remaining;
747         withdrawable = stream.withdrawable;
748         unlockRatio = stream.unlockRatio;
749         lastRewardBlock = stream.lastRewardBlock;
750         cancelable = stream.cancelable;
751     }
752 
753     /**
754      * @notice funds to an existing stream(for general purpose), 
755      the amount of fund should be simply added to un-withdrawable.
756      * @dev Throws if the caller is not the stream.sender
757      * @param streamId The id of the stream to query.
758      * @param amount deposit amount by stream sender
759      */
760     function singleFundStream(uint256 streamId, uint256 amount)
761         external
762         payable
763         nonReentrant
764         streamExists(streamId)
765         returns (bool)
766     {
767         Stream storage stream = streams[streamId];
768         require(
769             msg.sender == stream.sender,
770             "caller must be the sender of the stream"
771         );
772         require(amount > effectiveValues[streamId], "amount not effective");
773         if (stream.token == AddressHelper.ethAddress()) {
774             require(amount == msg.value, "bad ether fund");
775         } else {
776             stream.token.safeTransferFrom(msg.sender, address(this), amount);
777         }
778 
779         (uint256 withdrawable, uint256 remaining) = balanceOf(streamId);
780 
781         // update remaining and withdrawable balance
782         stream.lastRewardBlock = block.number;
783         stream.remaining = remaining.add(amount); // = remaining + amount
784         stream.withdrawable = withdrawable; // = withdrawable
785 
786         //add funds to total deposit amount
787         stream.depositAmount = stream.depositAmount.add(amount);
788         emit StreamFunded(streamId, amount);
789         return true;
790     }
791 
792     /**
793      * @notice Implemented for XDEX farming and vesting,
794      * the amount of fund should be splited to withdrawable and un-withdrawable according to lastRewardBlock.
795      * @dev Throws if the caller is not the stream.sender
796      * @param streamId The id of the stream to query.
797      * @param amount deposit amount by stream sender
798      * @param blockHeightDiff diff of block.number and farmPool's lastRewardBlock
799      */
800     function lazyFundStream(
801         uint256 streamId,
802         uint256 amount,
803         uint256 blockHeightDiff
804     ) external payable nonReentrant streamExists(streamId) returns (bool) {
805         Stream storage stream = streams[streamId];
806         require(
807             msg.sender == stream.sender,
808             "caller must be the sender of the stream"
809         );
810         require(amount > effectiveValues[streamId], "amount not effective");
811         if (stream.token == AddressHelper.ethAddress()) {
812             require(amount == msg.value, "bad ether fund");
813         } else {
814             stream.token.safeTransferFrom(msg.sender, address(this), amount);
815         }
816 
817         (uint256 withdrawable, uint256 remaining) = balanceOf(streamId);
818 
819         //uint256 blockHeightDiff = block.number.sub(stream.lastRewardBlock);
820         // If underflow m might be 0, peg true kBlock to 1, if bHD 0 then error.
821         // Minimum amount is 100
822         uint256 m = amount.mul(ONE).div(blockHeightDiff);
823         // peg true kBlock to 1 so n over k always greater or equal 1
824         uint256 noverk = blockHeightDiff.mul(ONE);
825         // peg true mu to mu/kBlock
826         uint256 mu = stream.unlockRatio.mul(ONE).div(1000).div(stream.kBlock);
827         // Enlarged due to mu divided by kBlock
828         uint256 onesubmu = ONE.sub(mu);
829         // uint256 s = m.mul(ONE.sub(XNum.bpow(onesubmu,noverk))).div(ONE).div(mu).mul(ONE);
830         uint256 s =
831             m.mul(ONE.sub(XNum.bpow(onesubmu, noverk))).div(mu).div(ONE);
832 
833         // update remaining and withdrawable balance
834         stream.lastRewardBlock = block.number;
835         stream.remaining = remaining.add(s); // = remaining + s
836         stream.withdrawable = withdrawable.add(amount).sub(s); // = withdrawable + (amount - s)
837 
838         // add funds to total deposit amount
839         stream.depositAmount = stream.depositAmount.add(amount);
840         emit StreamFunded(streamId, amount);
841         return true;
842     }
843 
844     /**
845      * @notice Returns the available funds for the given stream id and address.
846      * @dev Throws if the id does not point to a valid stream.
847      * @param streamId The id of the stream for which to query the balance.
848      * @return withdrawable The total funds allocated to `recipient` and `sender` as uint256.
849      * @return remaining The total funds allocated to `recipient` and `sender` as uint256.
850      */
851     function balanceOf(uint256 streamId)
852         public
853         view
854         streamExists(streamId)
855         returns (uint256 withdrawable, uint256 remaining)
856     {
857         Stream memory stream = streams[streamId];
858 
859         if (block.number < stream.startBlock) {
860             return (0, stream.depositAmount);
861         }
862 
863         uint256 lastBalance = stream.withdrawable;
864 
865         uint256 n =
866             block.number.sub(stream.lastRewardBlock).mul(ONE).div(
867                 stream.kBlock
868             );
869         uint256 k = stream.unlockRatio.mul(ONE).div(1000);
870         uint256 mu = ONE.sub(k);
871         uint256 r = stream.remaining.mul(XNum.bpow(mu, n)).div(ONE);
872         uint256 w = stream.remaining.sub(r); // withdrawable, if n is float this process will be smooth and slightly
873 
874         if (lastBalance > 0) {
875             w = w.add(lastBalance);
876         }
877 
878         //If `remaining` + `withdrawable` < `depositAmount`, it means there have withdraws.
879         require(
880             r.add(w) <= stream.depositAmount,
881             "balanceOf: remaining or withdrawable amount is bad"
882         );
883 
884         if (w >= effectiveValues[streamId]) {
885             withdrawable = w;
886         } else {
887             withdrawable = 0;
888         }
889 
890         if (r >= effectiveValues[streamId]) {
891             remaining = r;
892         } else {
893             remaining = 0;
894         }
895     }
896 
897     /**
898      * @notice Withdraws from the contract to the recipient's account.
899      * @dev Throws if the id does not point to a valid stream.
900      *  Throws if the amount exceeds the withdrawable balance.
901      *  Throws if the amount < the effective withdraw value.
902      *  Throws if the caller is not the recipient.
903      * @param streamId The id of the stream to withdraw tokens from.
904      * @param amount The amount of tokens to withdraw.
905      * @return bool true=success, otherwise false.
906      */
907     function withdrawFromStream(uint256 streamId, uint256 amount)
908         external
909         nonReentrant
910         streamExists(streamId)
911         returns (bool)
912     {
913         Stream storage stream = streams[streamId];
914 
915         require(
916             msg.sender == stream.recipient,
917             "caller must be the recipient of the stream"
918         );
919 
920         require(
921             amount >= effectiveValues[streamId],
922             "amount is zero or not effective"
923         );
924 
925         (uint256 withdrawable, uint256 remaining) = balanceOf(streamId);
926 
927         require(
928             withdrawable >= amount,
929             "withdraw amount exceeds the available balance"
930         );
931 
932         if (stream.token == AddressHelper.ethAddress()) {
933             stream.recipient.safeTransferEther(amount);
934         } else {
935             stream.token.safeTransfer(stream.recipient, amount);
936         }
937 
938         stream.lastRewardBlock = block.number;
939         stream.remaining = remaining;
940         stream.withdrawable = withdrawable.sub(amount);
941 
942         emit WithdrawFromStream(streamId, stream.recipient, amount);
943         return true;
944     }
945 
946     /**
947      * @notice Cancels the stream and transfers the tokens back
948      * @dev Throws if the id does not point to a valid stream.
949      *  Throws if the caller is not the sender or the recipient of the stream.
950      *  Throws if there is a token transfer failure.
951      * @param streamId The id of the stream to cancel.
952      * @return bool true=success, otherwise false.
953      */
954     function cancelStream(uint256 streamId)
955         external
956         nonReentrant
957         streamExists(streamId)
958         returns (bool)
959     {
960         Stream memory stream = streams[streamId];
961 
962         require(stream.cancelable, "non cancelable stream");
963         require(
964             msg.sender == streams[streamId].sender ||
965                 msg.sender == streams[streamId].recipient,
966             "caller must be the sender or the recipient"
967         );
968 
969         (uint256 withdrawable, uint256 remaining) = balanceOf(streamId);
970 
971         //save gas
972         delete streams[streamId];
973         delete effectiveValues[streamId];
974 
975         if (withdrawable > 0) {
976             if (stream.token == AddressHelper.ethAddress()) {
977                 stream.recipient.safeTransferEther(withdrawable);
978             } else {
979                 stream.token.safeTransfer(stream.recipient, withdrawable);
980             }
981         }
982 
983         if (remaining > 0) {
984             if (stream.token == AddressHelper.ethAddress()) {
985                 stream.sender.safeTransferEther(remaining);
986             } else {
987                 stream.token.safeTransfer(stream.sender, remaining);
988             }
989         }
990 
991         emit StreamCanceled(
992             streamId,
993             stream.sender,
994             stream.recipient,
995             remaining,
996             withdrawable
997         );
998         return true;
999     }
1000 
1001     function getVersion() external pure returns (bytes32) {
1002         return bytes32("APOLLO");
1003     }
1004 }