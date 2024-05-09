1 // File: contracts/DeliverFunds.sol
2 
3 pragma solidity 0.5.12;
4 
5 contract DeliverFunds {
6     constructor(address payable target) public payable {
7         selfdestruct(target);
8     }
9 }
10 
11 // File: contracts/Ownable.sol
12 
13 pragma solidity 0.5.12;
14 
15 contract Ownable {
16     address payable public owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19     
20     constructor () internal {
21         owner = msg.sender;
22         emit OwnershipTransferred(address(0), owner);
23     }
24     
25     modifier onlyOwner() {
26         require(msg.sender == owner, "Ownable: caller is not the owner");
27         _;
28     }
29     
30     function transferOwnership(address payable newOwner) public onlyOwner {
31         require(newOwner != address(0), "Ownable: new owner is the zero address");
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 }
36 
37 // File: contracts/EthexJackpot.sol
38 
39 pragma solidity 0.5.12;
40 
41 /**
42  * (E)t)h)e)x) Jackpot Contract 
43  *  This smart-contract is the part of Ethex Lottery fair game.
44  *  See latest version at https://github.com/ethex-bet/ethex-contracts 
45  *  http://ethex.bet
46  */
47 
48 
49 
50 contract EthexJackpot is Ownable {
51     mapping(uint256 => address payable) public tickets;
52     mapping(uint256 => Segment[4]) public prevJackpots;
53     uint256[4] public amounts;
54     uint256[4] public starts;
55     uint256[4] public ends;
56     uint256[4] public numberStarts;
57     uint256 public numberEnd;
58     uint256 public firstNumber;
59     uint256 public dailyAmount;
60     uint256 public weeklyAmount;
61     uint256 public monthlyAmount;
62     uint256 public seasonalAmount;
63     bool public dailyProcessed;
64     bool public weeklyProcessed;
65     bool public monthlyProcessed;
66     bool public seasonalProcessed;
67     address public lotoAddress;
68     address payable public newVersionAddress;
69     EthexJackpot public previousContract;
70     uint256 public dailyNumberStartPrev;
71     uint256 public weeklyNumberStartPrev;
72     uint256 public monthlyNumberStartPrev;
73     uint256 public seasonalNumberStartPrev;
74     uint256 public dailyStart;
75     uint256 public weeklyStart;
76     uint256 public monthlyStart;
77     uint256 public seasonalStart;
78     uint256 public dailyEnd;
79     uint256 public weeklyEnd;
80     uint256 public monthlyEnd;
81     uint256 public seasonalEnd;
82     uint256 public dailyNumberStart;
83     uint256 public weeklyNumberStart;
84     uint256 public monthlyNumberStart;
85     uint256 public seasonalNumberStart;
86     uint256 public dailyNumberEndPrev;
87     uint256 public weeklyNumberEndPrev;
88     uint256 public monthlyNumberEndPrev;
89     uint256 public seasonalNumberEndPrev;
90     
91     struct Segment {
92         uint256 start;
93         uint256 end;
94         bool processed;
95     }
96     
97     event Jackpot (
98         uint256 number,
99         uint256 count,
100         uint256 amount,
101         byte jackpotType
102     );
103     
104     event Ticket (
105         uint256 number
106     );
107     
108     event Superprize (
109         uint256 amount,
110         address winner
111     );
112     
113     uint256[4] internal LENGTH = [5000, 35000, 150000, 450000];
114     uint256[4] internal PARTS = [84, 12, 3, 1];
115     uint256 internal constant PRECISION = 1 ether;
116     
117     modifier onlyLoto {
118         require(msg.sender == lotoAddress, "Loto only");
119         _;
120     }
121     
122     function() external payable { }
123     
124     function migrate() external {
125         require(msg.sender == owner || msg.sender == newVersionAddress);
126         newVersionAddress.transfer(address(this).balance);
127     }
128 
129     function registerTicket(address payable gamer) external onlyLoto {
130         uint256 number = numberEnd + 1;
131         for (uint8 i = 0; i < 4; i++) {
132             if (block.number >= ends[i]) {
133                 setJackpot(i);
134                 numberStarts[i] = number;
135             }
136             else
137                 if (numberStarts[i] == prevJackpots[starts[i]][i].start)
138                     numberStarts[i] = number;
139         }
140         numberEnd = number;
141         tickets[number] = gamer;
142         emit Ticket(number);
143     }
144     
145     function setLoto(address loto) external onlyOwner {
146         lotoAddress = loto;
147     }
148     
149     function setNewVersion(address payable newVersion) external onlyOwner {
150         newVersionAddress = newVersion;
151     }
152     
153     function payIn() external payable {
154         uint256 distributedAmount = amounts[0] + amounts[1] + amounts[2] + amounts[3];
155         if (distributedAmount < address(this).balance) {
156             uint256 amount = (address(this).balance - distributedAmount) / 4;
157             amounts[0] += amount;
158             amounts[1] += amount;
159             amounts[2] += amount;
160             amounts[3] += amount;
161         }
162     }
163 
164     function processJackpots(bytes32 hash, uint256[4] memory blockHeights) private {
165         uint48 modulo = uint48(bytes6(hash << 29));
166         
167         uint256[4] memory payAmounts;
168         uint256[4] memory wins;
169         for (uint8 i = 0; i < 4; i++) {
170             if (prevJackpots[blockHeights[i]][i].processed == false && prevJackpots[blockHeights[i]][i].start != 0) {
171                 payAmounts[i] = amounts[i] * PRECISION / PARTS[i] / PRECISION;
172                 amounts[i] -= payAmounts[i];
173                 prevJackpots[blockHeights[i]][i].processed = true;
174                 wins[i] = getNumber(prevJackpots[blockHeights[i]][i].start, prevJackpots[blockHeights[i]][i].end, modulo);
175                 emit Jackpot(wins[i], prevJackpots[blockHeights[i]][i].end - prevJackpots[blockHeights[i]][i].start + 1, payAmounts[i], byte(uint8(1) << i));
176             }
177         }
178         
179         for (uint8 i = 0; i < 4; i++)
180             if (payAmounts[i] > 0 && !getAddress(wins[i]).send(payAmounts[i]))
181                 (new DeliverFunds).value(payAmounts[i])(getAddress(wins[i]));
182     }
183     
184     function settleJackpot() external {
185         for (uint8 i = 0; i < 4; i++)
186             if (block.number >= ends[i])
187                 setJackpot(i);
188         
189         if (block.number == starts[0] || (starts[0] < block.number - 256))
190             return;
191         
192         processJackpots(blockhash(starts[0]), starts);
193     }
194 
195     function settleMissedJackpot(bytes32 hash, uint256 blockHeight) external onlyOwner {
196         for (uint8 i = 0; i < 4; i++)
197             if (block.number >= ends[i])
198                 setJackpot(i);
199         
200         if (blockHeight < block.number - 256)
201             processJackpots(hash, [blockHeight, blockHeight, blockHeight, blockHeight]);
202     }
203     
204     function paySuperprize(address payable winner) external onlyLoto {
205         uint256 superprizeAmount = amounts[0] + amounts[1] + amounts[2] + amounts[3];
206         amounts[0] = 0;
207         amounts[1] = 0;
208         amounts[2] = 0;
209         amounts[3] = 0;
210         emit Superprize(superprizeAmount, winner);
211         if (superprizeAmount > 0 && !winner.send(superprizeAmount))
212             (new DeliverFunds).value(superprizeAmount)(winner);
213     }
214     
215     function setOldVersion(address payable oldAddress) external onlyOwner {
216         previousContract = EthexJackpot(oldAddress);
217         starts[0] = previousContract.dailyStart();
218         ends[0] = previousContract.dailyEnd();
219         prevJackpots[starts[0]][0].processed = previousContract.dailyProcessed();
220         starts[1] = previousContract.weeklyStart();
221         ends[1] = previousContract.weeklyEnd();
222         prevJackpots[starts[1]][1].processed = previousContract.weeklyProcessed();
223         starts[2] = previousContract.monthlyStart();
224         ends[2] = previousContract.monthlyEnd();
225         prevJackpots[starts[2]][2].processed = previousContract.monthlyProcessed();
226         starts[3] = previousContract.seasonalStart();
227         ends[3] = previousContract.seasonalEnd();
228         prevJackpots[starts[3]][3].processed = previousContract.seasonalProcessed();
229         prevJackpots[starts[0]][0].start = previousContract.dailyNumberStartPrev();
230         prevJackpots[starts[1]][1].start = previousContract.weeklyNumberStartPrev();
231         prevJackpots[starts[2]][2].start = previousContract.monthlyNumberStartPrev();
232         prevJackpots[starts[3]][3].start = previousContract.seasonalNumberStartPrev();
233         numberStarts[0] = previousContract.dailyNumberStart();
234         numberStarts[1] = previousContract.weeklyNumberStart();
235         numberStarts[2] = previousContract.monthlyNumberStart();
236         numberStarts[3] = previousContract.seasonalNumberStart();
237         prevJackpots[starts[0]][0].end = previousContract.dailyNumberEndPrev();
238         prevJackpots[starts[1]][1].end = previousContract.weeklyNumberEndPrev();
239         prevJackpots[starts[2]][2].end = previousContract.monthlyNumberEndPrev();
240         prevJackpots[starts[3]][3].end = previousContract.seasonalNumberEndPrev();
241         numberEnd = previousContract.numberEnd();        
242         amounts[0] = previousContract.dailyAmount();
243         amounts[1] = previousContract.weeklyAmount();
244         amounts[2] = previousContract.monthlyAmount();
245         amounts[3] = previousContract.seasonalAmount();
246         firstNumber = numberEnd;
247         previousContract.migrate();
248     }
249     
250     function getAddress(uint256 number) public returns (address payable) {
251         if (number <= firstNumber)
252             return previousContract.getAddress(number);
253         return tickets[number];
254     }
255     
256     function setJackpot(uint8 jackpotType) private {
257         prevJackpots[ends[jackpotType]][jackpotType].processed = prevJackpots[starts[jackpotType]][jackpotType].end == numberEnd;
258         starts[jackpotType] = ends[jackpotType];
259         ends[jackpotType] = starts[jackpotType] + LENGTH[jackpotType];
260         prevJackpots[starts[jackpotType]][jackpotType].start = numberStarts[jackpotType];
261         prevJackpots[starts[jackpotType]][jackpotType].end = numberEnd;
262     }
263     
264     function getNumber(uint256 startNumber, uint256 endNumber, uint48 modulo) private pure returns (uint256) {
265         return startNumber + modulo % (endNumber - startNumber + 1);
266     }
267 }
268 
269 // File: contracts/EthexHouse.sol
270 
271 pragma solidity 0.5.12;
272 
273 /**
274  * (E)t)h)e)x) House Contract 
275  *  This smart-contract is the part of Ethex Lottery fair game.
276  *  See latest version at https://github.com/ethex-bet/ethex-contracts 
277  *  http://ethex.bet
278  */
279 
280  
281  contract EthexHouse is Ownable {
282     function payIn() external payable { }
283     
284     function withdraw() external onlyOwner {
285         owner.transfer(address(this).balance);
286     }
287  }
288 
289 // File: contracts/EthexSuperprize.sol
290 
291 pragma solidity 0.5.12;
292 
293 /**
294  * (E)t)h)e)x) Superprize Contract 
295  *  This smart-contract is the part of Ethex Lottery fair game.
296  *  See latest version at https://github.com/ethex-bet/ethex-lottery 
297  *  http://ethex.bet
298  */
299 
300 
301  
302  contract EthexSuperprize is Ownable {
303     struct Payout {
304         uint256 index;
305         uint256 amount;
306         uint256 block;
307         address payable winnerAddress;
308         uint256 betId;
309     }
310      
311     Payout[] public payouts;
312     
313     address public lotoAddress;
314     address payable public newVersionAddress;
315     EthexSuperprize public previousContract;
316     uint256 public hold;
317     
318     event Superprize (
319         uint256 index,
320         uint256 amount,
321         address winner,
322         uint256 betId,
323         byte state
324     );
325     
326     uint8 internal constant PARTS = 6;
327     uint256 internal constant PRECISION = 1 ether;
328     uint256 internal constant MONTHLY = 150000;
329 
330     function() external payable { }
331     
332     function initSuperprize(address payable winner, uint256 betId) external {
333         require(msg.sender == lotoAddress, "Loto only");
334         uint256 amount = address(this).balance - hold;
335         hold = address(this).balance;
336         uint256 sum;
337         uint256 temp;
338         for (uint256 i = 1; i < PARTS; i++) {
339             temp = amount * PRECISION * (i - 1 + 10) / 75 / PRECISION;
340             sum += temp;
341             payouts.push(Payout(i, temp, block.number + i * MONTHLY, winner, betId));
342         }
343         payouts.push(Payout(PARTS, amount - sum, block.number + PARTS * MONTHLY, winner, betId));
344         emit Superprize(0, amount, winner, betId, 0);
345     }
346     
347     function paySuperprize() external onlyOwner {
348         if (payouts.length == 0)
349             return;
350         Payout[] memory payoutArray = new Payout[](payouts.length);
351         uint i = payouts.length;
352         while (i > 0) {
353             i--;
354             if (payouts[i].block <= block.number) {
355                 emit Superprize(payouts[i].index, payouts[i].amount, payouts[i].winnerAddress, payouts[i].betId, 0x01);
356                 hold -= payouts[i].amount;
357             }
358             payoutArray[i] = payouts[i];
359             payouts.pop();
360         }
361         for (i = 0; i < payoutArray.length; i++)
362             if (payoutArray[i].block > block.number)
363                 payouts.push(payoutArray[i]);
364         for (i = 0; i < payoutArray.length; i++)
365             if (payoutArray[i].block <= block.number && !payoutArray[i].winnerAddress.send(payoutArray[i].amount))
366                 (new DeliverFunds).value(payoutArray[i].amount)(payoutArray[i].winnerAddress);
367     }
368      
369     function setOldVersion(address payable oldAddress) external onlyOwner {
370         previousContract = EthexSuperprize(oldAddress);
371         lotoAddress = previousContract.lotoAddress();
372         hold = previousContract.hold();
373         uint256 index;
374         uint256 amount;
375         uint256 betBlock;
376         address payable winner;
377         uint256 betId;
378         uint256 payoutsCount = previousContract.getPayoutsCount();
379         for (uint i = 0; i < payoutsCount; i++) {
380             (index, amount, betBlock, winner, betId) = previousContract.payouts(i);
381             payouts.push(Payout(index, amount, betBlock, winner, betId));
382         }
383         previousContract.migrate();
384     }
385     
386     function setNewVersion(address payable newVersion) external onlyOwner {
387         newVersionAddress = newVersion;
388     }
389     
390     function setLoto(address loto) external onlyOwner {
391         lotoAddress = loto;
392     }
393     
394     function migrate() external {
395         require(msg.sender == owner || msg.sender == newVersionAddress);
396         require(newVersionAddress != address(0));
397         newVersionAddress.transfer(address(this).balance);
398     }   
399 
400     function getPayoutsCount() public view returns (uint256) { return payouts.length; }
401 }
402 
403 // File: contracts/openzeppelin/GSN/Context.sol
404 
405 pragma solidity ^0.5.0;
406 
407 /*
408  * @dev Provides information about the current execution context, including the
409  * sender of the transaction and its data. While these are generally available
410  * via msg.sender and msg.data, they should not be accessed in such a direct
411  * manner, since when dealing with GSN meta-transactions the account sending and
412  * paying for execution may not be the actual sender (as far as an application
413  * is concerned).
414  *
415  * This contract is only required for intermediate, library-like contracts.
416  */
417 contract Context {
418     // Empty internal constructor, to prevent people from mistakenly deploying
419     // an instance of this contract, which should be used via inheritance.
420     constructor () internal { }
421     // solhint-disable-previous-line no-empty-blocks
422 
423     function _msgSender() internal view returns (address payable) {
424         return msg.sender;
425     }
426 
427     function _msgData() internal view returns (bytes memory) {
428         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
429         return msg.data;
430     }
431 }
432 
433 // File: contracts/openzeppelin/token/ERC20/IERC20.sol
434 
435 pragma solidity ^0.5.0;
436 
437 /**
438  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
439  * the optional functions; to access them see {ERC20Detailed}.
440  */
441 interface IERC20 {
442     /**
443      * @dev Returns the amount of tokens in existence.
444      */
445     function totalSupply() external view returns (uint256);
446 
447     /**
448      * @dev Returns the amount of tokens owned by `account`.
449      */
450     function balanceOf(address account) external view returns (uint256);
451 
452     /**
453      * @dev Moves `amount` tokens from the caller's account to `recipient`.
454      *
455      * Returns a boolean value indicating whether the operation succeeded.
456      *
457      * Emits a {Transfer} event.
458      */
459     function transfer(address recipient, uint256 amount) external returns (bool);
460 
461     /**
462      * @dev Returns the remaining number of tokens that `spender` will be
463      * allowed to spend on behalf of `owner` through {transferFrom}. This is
464      * zero by default.
465      *
466      * This value changes when {approve} or {transferFrom} are called.
467      */
468     function allowance(address owner, address spender) external view returns (uint256);
469 
470     /**
471      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
472      *
473      * Returns a boolean value indicating whether the operation succeeded.
474      *
475      * IMPORTANT: Beware that changing an allowance with this method brings the risk
476      * that someone may use both the old and the new allowance by unfortunate
477      * transaction ordering. One possible solution to mitigate this race
478      * condition is to first reduce the spender's allowance to 0 and set the
479      * desired value afterwards:
480      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
481      *
482      * Emits an {Approval} event.
483      */
484     function approve(address spender, uint256 amount) external returns (bool);
485 
486     /**
487      * @dev Moves `amount` tokens from `sender` to `recipient` using the
488      * allowance mechanism. `amount` is then deducted from the caller's
489      * allowance.
490      *
491      * Returns a boolean value indicating whether the operation succeeded.
492      *
493      * Emits a {Transfer} event.
494      */
495     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
496 
497     /**
498      * @dev Emitted when `value` tokens are moved from one account (`from`) to
499      * another (`to`).
500      *
501      * Note that `value` may be zero.
502      */
503     event Transfer(address indexed from, address indexed to, uint256 value);
504 
505     /**
506      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
507      * a call to {approve}. `value` is the new allowance.
508      */
509     event Approval(address indexed owner, address indexed spender, uint256 value);
510 }
511 
512 // File: contracts/openzeppelin/math/SafeMath.sol
513 
514 pragma solidity ^0.5.0;
515 
516 /**
517  * @dev Wrappers over Solidity's arithmetic operations with added overflow
518  * checks.
519  *
520  * Arithmetic operations in Solidity wrap on overflow. This can easily result
521  * in bugs, because programmers usually assume that an overflow raises an
522  * error, which is the standard behavior in high level programming languages.
523  * `SafeMath` restores this intuition by reverting the transaction when an
524  * operation overflows.
525  *
526  * Using this library instead of the unchecked operations eliminates an entire
527  * class of bugs, so it's recommended to use it always.
528  */
529 library SafeMath {
530     /**
531      * @dev Returns the addition of two unsigned integers, reverting on
532      * overflow.
533      *
534      * Counterpart to Solidity's `+` operator.
535      *
536      * Requirements:
537      * - Addition cannot overflow.
538      */
539     function add(uint256 a, uint256 b) internal pure returns (uint256) {
540         uint256 c = a + b;
541         require(c >= a, "SafeMath: addition overflow");
542 
543         return c;
544     }
545 
546     /**
547      * @dev Returns the subtraction of two unsigned integers, reverting on
548      * overflow (when the result is negative).
549      *
550      * Counterpart to Solidity's `-` operator.
551      *
552      * Requirements:
553      * - Subtraction cannot overflow.
554      */
555     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
556         return sub(a, b, "SafeMath: subtraction overflow");
557     }
558 
559     /**
560      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
561      * overflow (when the result is negative).
562      *
563      * Counterpart to Solidity's `-` operator.
564      *
565      * Requirements:
566      * - Subtraction cannot overflow.
567      *
568      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
569      * @dev Get it via `npm install @openzeppelin/contracts@next`.
570      */
571     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
572         require(b <= a, errorMessage);
573         uint256 c = a - b;
574 
575         return c;
576     }
577 
578     /**
579      * @dev Returns the multiplication of two unsigned integers, reverting on
580      * overflow.
581      *
582      * Counterpart to Solidity's `*` operator.
583      *
584      * Requirements:
585      * - Multiplication cannot overflow.
586      */
587     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
588         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
589         // benefit is lost if 'b' is also tested.
590         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
591         if (a == 0) {
592             return 0;
593         }
594 
595         uint256 c = a * b;
596         require(c / a == b, "SafeMath: multiplication overflow");
597 
598         return c;
599     }
600 
601     /**
602      * @dev Returns the integer division of two unsigned integers. Reverts on
603      * division by zero. The result is rounded towards zero.
604      *
605      * Counterpart to Solidity's `/` operator. Note: this function uses a
606      * `revert` opcode (which leaves remaining gas untouched) while Solidity
607      * uses an invalid opcode to revert (consuming all remaining gas).
608      *
609      * Requirements:
610      * - The divisor cannot be zero.
611      */
612     function div(uint256 a, uint256 b) internal pure returns (uint256) {
613         return div(a, b, "SafeMath: division by zero");
614     }
615 
616     /**
617      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
618      * division by zero. The result is rounded towards zero.
619      *
620      * Counterpart to Solidity's `/` operator. Note: this function uses a
621      * `revert` opcode (which leaves remaining gas untouched) while Solidity
622      * uses an invalid opcode to revert (consuming all remaining gas).
623      *
624      * Requirements:
625      * - The divisor cannot be zero.
626 
627      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
628      * @dev Get it via `npm install @openzeppelin/contracts@next`.
629      */
630     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
631         // Solidity only automatically asserts when dividing by 0
632         require(b > 0, errorMessage);
633         uint256 c = a / b;
634         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
635 
636         return c;
637     }
638 
639     /**
640      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
641      * Reverts when dividing by zero.
642      *
643      * Counterpart to Solidity's `%` operator. This function uses a `revert`
644      * opcode (which leaves remaining gas untouched) while Solidity uses an
645      * invalid opcode to revert (consuming all remaining gas).
646      *
647      * Requirements:
648      * - The divisor cannot be zero.
649      */
650     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
651         return mod(a, b, "SafeMath: modulo by zero");
652     }
653 
654     /**
655      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
656      * Reverts with custom message when dividing by zero.
657      *
658      * Counterpart to Solidity's `%` operator. This function uses a `revert`
659      * opcode (which leaves remaining gas untouched) while Solidity uses an
660      * invalid opcode to revert (consuming all remaining gas).
661      *
662      * Requirements:
663      * - The divisor cannot be zero.
664      *
665      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
666      * @dev Get it via `npm install @openzeppelin/contracts@next`.
667      */
668     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
669         require(b != 0, errorMessage);
670         return a % b;
671     }
672 }
673 
674 // File: contracts/openzeppelin/token/ERC20/ERC20.sol
675 
676 pragma solidity ^0.5.0;
677 
678 
679 
680 
681 /**
682  * @dev Implementation of the {IERC20} interface.
683  *
684  * This implementation is agnostic to the way tokens are created. This means
685  * that a supply mechanism has to be added in a derived contract using {_mint}.
686  * For a generic mechanism see {ERC20Mintable}.
687  *
688  * TIP: For a detailed writeup see our guide
689  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
690  * to implement supply mechanisms].
691  *
692  * We have followed general OpenZeppelin guidelines: functions revert instead
693  * of returning `false` on failure. This behavior is nonetheless conventional
694  * and does not conflict with the expectations of ERC20 applications.
695  *
696  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
697  * This allows applications to reconstruct the allowance for all accounts just
698  * by listening to said events. Other implementations of the EIP may not emit
699  * these events, as it isn't required by the specification.
700  *
701  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
702  * functions have been added to mitigate the well-known issues around setting
703  * allowances. See {IERC20-approve}.
704  */
705 contract ERC20 is Context, IERC20 {
706     using SafeMath for uint256;
707 
708     mapping (address => uint256) private _balances;
709 
710     mapping (address => mapping (address => uint256)) private _allowances;
711 
712     uint256 private _totalSupply;
713 
714     /**
715      * @dev See {IERC20-totalSupply}.
716      */
717     function totalSupply() public view returns (uint256) {
718         return _totalSupply;
719     }
720 
721     /**
722      * @dev See {IERC20-balanceOf}.
723      */
724     function balanceOf(address account) public view returns (uint256) {
725         return _balances[account];
726     }
727 
728     /**
729      * @dev See {IERC20-transfer}.
730      *
731      * Requirements:
732      *
733      * - `recipient` cannot be the zero address.
734      * - the caller must have a balance of at least `amount`.
735      */
736     function transfer(address recipient, uint256 amount) public returns (bool) {
737         _transfer(_msgSender(), recipient, amount);
738         return true;
739     }
740 
741     /**
742      * @dev See {IERC20-allowance}.
743      */
744     function allowance(address owner, address spender) public view returns (uint256) {
745         return _allowances[owner][spender];
746     }
747 
748     /**
749      * @dev See {IERC20-approve}.
750      *
751      * Requirements:
752      *
753      * - `spender` cannot be the zero address.
754      */
755     function approve(address spender, uint256 amount) public returns (bool) {
756         _approve(_msgSender(), spender, amount);
757         return true;
758     }
759 
760     /**
761      * @dev See {IERC20-transferFrom}.
762      *
763      * Emits an {Approval} event indicating the updated allowance. This is not
764      * required by the EIP. See the note at the beginning of {ERC20};
765      *
766      * Requirements:
767      * - `sender` and `recipient` cannot be the zero address.
768      * - `sender` must have a balance of at least `amount`.
769      * - the caller must have allowance for `sender`'s tokens of at least
770      * `amount`.
771      */
772     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
773         _transfer(sender, recipient, amount);
774         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
775         return true;
776     }
777 
778     /**
779      * @dev Atomically increases the allowance granted to `spender` by the caller.
780      *
781      * This is an alternative to {approve} that can be used as a mitigation for
782      * problems described in {IERC20-approve}.
783      *
784      * Emits an {Approval} event indicating the updated allowance.
785      *
786      * Requirements:
787      *
788      * - `spender` cannot be the zero address.
789      */
790     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
791         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
792         return true;
793     }
794 
795     /**
796      * @dev Atomically decreases the allowance granted to `spender` by the caller.
797      *
798      * This is an alternative to {approve} that can be used as a mitigation for
799      * problems described in {IERC20-approve}.
800      *
801      * Emits an {Approval} event indicating the updated allowance.
802      *
803      * Requirements:
804      *
805      * - `spender` cannot be the zero address.
806      * - `spender` must have allowance for the caller of at least
807      * `subtractedValue`.
808      */
809     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
810         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
811         return true;
812     }
813 
814     /**
815      * @dev Moves tokens `amount` from `sender` to `recipient`.
816      *
817      * This is internal function is equivalent to {transfer}, and can be used to
818      * e.g. implement automatic token fees, slashing mechanisms, etc.
819      *
820      * Emits a {Transfer} event.
821      *
822      * Requirements:
823      *
824      * - `sender` cannot be the zero address.
825      * - `recipient` cannot be the zero address.
826      * - `sender` must have a balance of at least `amount`.
827      */
828     function _transfer(address sender, address recipient, uint256 amount) internal {
829         require(sender != address(0), "ERC20: transfer from the zero address");
830         require(recipient != address(0), "ERC20: transfer to the zero address");
831 
832         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
833         _balances[recipient] = _balances[recipient].add(amount);
834         emit Transfer(sender, recipient, amount);
835     }
836 
837     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
838      * the total supply.
839      *
840      * Emits a {Transfer} event with `from` set to the zero address.
841      *
842      * Requirements
843      *
844      * - `to` cannot be the zero address.
845      */
846     function _mint(address account, uint256 amount) internal {
847         require(account != address(0), "ERC20: mint to the zero address");
848 
849         _totalSupply = _totalSupply.add(amount);
850         _balances[account] = _balances[account].add(amount);
851         emit Transfer(address(0), account, amount);
852     }
853 
854     /**
855      * @dev Destroys `amount` tokens from `account`, reducing the
856      * total supply.
857      *
858      * Emits a {Transfer} event with `to` set to the zero address.
859      *
860      * Requirements
861      *
862      * - `account` cannot be the zero address.
863      * - `account` must have at least `amount` tokens.
864      */
865     function _burn(address account, uint256 amount) internal {
866         require(account != address(0), "ERC20: burn from the zero address");
867 
868         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
869         _totalSupply = _totalSupply.sub(amount);
870         emit Transfer(account, address(0), amount);
871     }
872 
873     /**
874      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
875      *
876      * This is internal function is equivalent to `approve`, and can be used to
877      * e.g. set automatic allowances for certain subsystems, etc.
878      *
879      * Emits an {Approval} event.
880      *
881      * Requirements:
882      *
883      * - `owner` cannot be the zero address.
884      * - `spender` cannot be the zero address.
885      */
886     function _approve(address owner, address spender, uint256 amount) internal {
887         require(owner != address(0), "ERC20: approve from the zero address");
888         require(spender != address(0), "ERC20: approve to the zero address");
889 
890         _allowances[owner][spender] = amount;
891         emit Approval(owner, spender, amount);
892     }
893 
894     /**
895      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
896      * from the caller's allowance.
897      *
898      * See {_burn} and {_approve}.
899      */
900     function _burnFrom(address account, uint256 amount) internal {
901         _burn(account, amount);
902         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
903     }
904 }
905 
906 // File: contracts/openzeppelin/token/ERC20/ERC20Detailed.sol
907 
908 pragma solidity ^0.5.0;
909 
910 
911 /**
912  * @dev Optional functions from the ERC20 standard.
913  */
914 contract ERC20Detailed is IERC20 {
915     string private _name;
916     string private _symbol;
917     uint8 private _decimals;
918 
919     /**
920      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
921      * these values are immutable: they can only be set once during
922      * construction.
923      */
924     constructor (string memory name, string memory symbol, uint8 decimals) public {
925         _name = name;
926         _symbol = symbol;
927         _decimals = decimals;
928     }
929 
930     /**
931      * @dev Returns the name of the token.
932      */
933     function name() public view returns (string memory) {
934         return _name;
935     }
936 
937     /**
938      * @dev Returns the symbol of the token, usually a shorter version of the
939      * name.
940      */
941     function symbol() public view returns (string memory) {
942         return _symbol;
943     }
944 
945     /**
946      * @dev Returns the number of decimals used to get its user representation.
947      * For example, if `decimals` equals `2`, a balance of `505` tokens should
948      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
949      *
950      * Tokens usually opt for a value of 18, imitating the relationship between
951      * Ether and Wei.
952      *
953      * NOTE: This information is only used for _display_ purposes: it in
954      * no way affects any of the arithmetic of the contract, including
955      * {IERC20-balanceOf} and {IERC20-transfer}.
956      */
957     function decimals() public view returns (uint8) {
958         return _decimals;
959     }
960 }
961 
962 // File: contracts/openzeppelin/access/Roles.sol
963 
964 pragma solidity ^0.5.0;
965 
966 /**
967  * @title Roles
968  * @dev Library for managing addresses assigned to a Role.
969  */
970 library Roles {
971     struct Role {
972         mapping (address => bool) bearer;
973     }
974 
975     /**
976      * @dev Give an account access to this role.
977      */
978     function add(Role storage role, address account) internal {
979         require(!has(role, account), "Roles: account already has role");
980         role.bearer[account] = true;
981     }
982 
983     /**
984      * @dev Remove an account's access to this role.
985      */
986     function remove(Role storage role, address account) internal {
987         require(has(role, account), "Roles: account does not have role");
988         role.bearer[account] = false;
989     }
990 
991     /**
992      * @dev Check if an account has this role.
993      * @return bool
994      */
995     function has(Role storage role, address account) internal view returns (bool) {
996         require(account != address(0), "Roles: account is the zero address");
997         return role.bearer[account];
998     }
999 }
1000 
1001 // File: contracts/openzeppelin/access/roles/MinterRole.sol
1002 
1003 pragma solidity ^0.5.0;
1004 
1005 
1006 
1007 contract MinterRole is Context {
1008     using Roles for Roles.Role;
1009 
1010     event MinterAdded(address indexed account);
1011     event MinterRemoved(address indexed account);
1012 
1013     Roles.Role private _minters;
1014 
1015     constructor () internal {
1016         _addMinter(_msgSender());
1017     }
1018 
1019     modifier onlyMinter() {
1020         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1021         _;
1022     }
1023 
1024     function isMinter(address account) public view returns (bool) {
1025         return _minters.has(account);
1026     }
1027 
1028     function addMinter(address account) public onlyMinter {
1029         _addMinter(account);
1030     }
1031 
1032     function renounceMinter() public {
1033         _removeMinter(_msgSender());
1034     }
1035 
1036     function _addMinter(address account) internal {
1037         _minters.add(account);
1038         emit MinterAdded(account);
1039     }
1040 
1041     function _removeMinter(address account) internal {
1042         _minters.remove(account);
1043         emit MinterRemoved(account);
1044     }
1045 }
1046 
1047 // File: contracts/EthexFreespins.sol
1048 
1049 pragma solidity 0.5.12;
1050 
1051 
1052 
1053 
1054 
1055 
1056 contract EthexFreespins is Ownable, Context, ERC20, ERC20Detailed, MinterRole {
1057 
1058     address payable public lotoAddress;
1059 
1060     constructor () public ERC20Detailed("EthexFreespins", "EFS", 18) { }
1061 
1062     function use(address account, uint256 amount) public {
1063         require(msg.sender == lotoAddress, "Loto only");
1064         _burn(account, amount);
1065         lotoAddress.transfer(amount);
1066     }
1067 
1068     function setLoto(address payable loto) external onlyOwner {
1069         lotoAddress = loto;
1070     }
1071 
1072     function mint(address account, uint256 amount) public payable onlyMinter {
1073         require(amount == msg.value, 'Mint amount and transfer value must be equal');
1074         _mint(account, amount);
1075     }
1076 }
1077 
1078 // File: contracts/uniswap/IUniswapFactory.sol
1079 
1080 pragma solidity ^0.5.0;
1081 
1082 contract IUniswapFactory {
1083     // Public Variables
1084     address public exchangeTemplate;
1085     uint256 public tokenCount;
1086     // Create Exchange
1087     function createExchange(address token) external returns (address exchange);
1088     // Get Exchange and Token Info
1089     function getExchange(address token) external view returns (address exchange);
1090     function getToken(address exchange) external view returns (address token);
1091     function getTokenWithId(uint256 tokenId) external view returns (address token);
1092     // Never use
1093     function initializeFactory(address template) external;
1094 }
1095 
1096 // File: contracts/uniswap/IUniswapExchange.sol
1097 
1098 pragma solidity ^0.5.0;
1099 
1100 contract IUniswapExchange {
1101     // Address of ERC20 token sold on this exchange
1102     function tokenAddress() external view returns (address token);
1103     // Address of Uniswap Factory
1104     function factoryAddress() external view returns (address factory);
1105     // Provide Liquidity
1106     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
1107     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
1108     // Get Prices
1109     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
1110     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
1111     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
1112     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
1113     // Trade ETH to ERC20
1114     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
1115     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
1116     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
1117     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
1118     // Trade ERC20 to ETH
1119     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
1120     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
1121     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
1122     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
1123     // Trade ERC20 to ERC20
1124     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
1125     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
1126     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
1127     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
1128     // Trade ERC20 to Custom Pool
1129     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
1130     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
1131     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
1132     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
1133     // ERC20 comaptibility for liquidity tokens
1134     bytes32 public name;
1135     bytes32 public symbol;
1136     uint256 public decimals;
1137     function transfer(address _to, uint256 _value) external returns (bool);
1138     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
1139     function approve(address _spender, uint256 _value) external returns (bool);
1140     function allowance(address _owner, address _spender) external view returns (uint256);
1141     function balanceOf(address _owner) external view returns (uint256);
1142     function totalSupply() external view returns (uint256);
1143     // Never use
1144     function setup(address token_addr) external;
1145 }
1146 
1147 // File: contracts/EthexLoto.sol
1148 
1149 pragma solidity 0.5.12;
1150 
1151 /**
1152  * (E)t)h)e)x) Loto Contract 
1153  *  This smart-contract is the part of Ethex Lottery fair game.
1154  *  See latest version at https://github.com/ethex-bet/ethex-contacts 
1155  *  http://ethex.bet
1156  */
1157 
1158 
1159 
1160 
1161 
1162 
1163 
1164 
1165 
1166 
1167 contract EthexLoto is Ownable {
1168     struct Bet {
1169         uint256 blockNumber;
1170         uint256 amount;
1171         uint256 id;
1172         bytes6 bet;
1173         address payable gamer;
1174     }
1175 
1176     struct Transaction {
1177         uint256 amount;
1178         address payable gamer;
1179     }
1180 
1181     struct Superprize {
1182         uint256 amount;
1183         uint256 id;
1184     }
1185 
1186     mapping(uint256 => uint256) public blockNumberQueue;
1187     mapping(uint256 => uint256) public amountQueue;
1188     mapping(uint256 => uint256) public idQueue;
1189     mapping(uint256 => bytes6) public betQueue;
1190     mapping(uint256 => address payable) public gamerQueue;
1191     uint256 public first = 2;
1192     uint256 public last = 1;
1193     uint256 public holdBalance;
1194     uint256 public betCount;
1195 
1196     address payable public newVersionAddress;
1197     address payable public jackpotAddress;
1198     address payable public houseAddress;
1199     address payable public superprizeAddress;
1200     address payable public freespinsAddress;
1201     address payable public uniswapAddress;
1202 
1203     event TokenBetAdded (
1204         uint256 tokenAmount,
1205         uint256 ethAmount
1206     );
1207     
1208     event PlaceBet (
1209         uint256 id
1210     );
1211 
1212     event PayoutBet (
1213         uint256 amount,
1214         uint256 id,
1215         address gamer
1216     );
1217 
1218     event RefundBet (
1219         uint256 amount,
1220         uint256 id,
1221         address gamer
1222     );
1223 
1224     uint256 internal constant MIN_BET = 0.01 ether;
1225     uint256 internal constant PRECISION = 1 ether;
1226     uint256 internal constant JACKPOT_PERCENT = 10;
1227     uint256 internal constant HOUSE_EDGE = 10;
1228 
1229     constructor(address payable jackpot, address payable house, address payable superprize, address payable freespins, address payable uniswap) public {
1230         jackpotAddress = jackpot;
1231         houseAddress = house;
1232         superprizeAddress = superprize;
1233         freespinsAddress = freespins;
1234         uniswapAddress = uniswap;
1235     }
1236 
1237     function() external payable { }
1238 
1239     function placeTokenBet(address tokenAddress, uint256 betMaxTokenAmount, uint256 betTargetEthAmount, uint256 swapDeadline, bytes6 bet) external {
1240         require(betTargetEthAmount >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
1241         require(tokenAddress != address(0), "Token address is required");
1242 
1243         if (tokenAddress == freespinsAddress)
1244         {
1245             placeFreespinBet(betTargetEthAmount, bet);
1246             return;
1247         }
1248 
1249         IERC20 token = IERC20(tokenAddress);
1250         IUniswapFactory uniswapFactory = IUniswapFactory(uniswapAddress);
1251 
1252         address exchangeAddress = uniswapFactory.getExchange(tokenAddress);
1253         require(exchangeAddress != address(0), "Token is not supported");
1254 
1255         IUniswapExchange uniswap = IUniswapExchange(exchangeAddress);
1256 
1257         uint256 tokensSold = uniswap.getTokenToEthOutputPrice(betTargetEthAmount);
1258         require(betMaxTokenAmount >= tokensSold, "Swap requires more token then was allowed");
1259 
1260         uint256 balance = token.balanceOf(msg.sender);
1261         require(balance >= tokensSold, "Not enough tokens");
1262 
1263         token.transferFrom(msg.sender, address(this), tokensSold);
1264         token.approve(exchangeAddress, tokensSold);
1265 
1266         uint256 converted = uniswap.tokenToEthSwapOutput(betTargetEthAmount, tokensSold, swapDeadline);
1267         require(converted >= betTargetEthAmount, "Exchange result is smaller then requested");
1268 
1269         placeBet(msg.sender, betTargetEthAmount, bet);
1270 
1271         emit TokenBetAdded(tokensSold, betTargetEthAmount);
1272     }
1273 
1274     function placeFreespinBet(uint256 betAmount, bytes6 bet) public {
1275         require(betAmount >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
1276 
1277         EthexFreespins token = EthexFreespins(freespinsAddress);
1278         uint256 balance = token.balanceOf(msg.sender);
1279 
1280         require(balance >= betAmount, "Not enough tokens");
1281 
1282         token.use(msg.sender, betAmount);
1283 
1284         placeBet(msg.sender, betAmount, bet);
1285 
1286         emit TokenBetAdded(betAmount, betAmount);
1287     }
1288 
1289     function placeBet(bytes6 bet) external payable {
1290         require(tx.origin == msg.sender);
1291 
1292         placeBet(msg.sender, msg.value, bet);
1293     }
1294 
1295     function placeBet(address payable player, uint256 amount, bytes6 bet) private {
1296         require(amount >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
1297 
1298         uint256 coefficient;
1299         uint8 markedCount;
1300         uint256 holdAmount;
1301         uint256 jackpotFee = amount * JACKPOT_PERCENT * PRECISION / 100 / PRECISION;
1302         uint256 houseEdgeFee = amount * HOUSE_EDGE * PRECISION / 100 / PRECISION;
1303         uint256 betAmount = amount - jackpotFee - houseEdgeFee;
1304 
1305         (coefficient, markedCount, holdAmount) = getHold(betAmount, bet);
1306 
1307         require(amount * (100 - JACKPOT_PERCENT - HOUSE_EDGE) * (coefficient * 8 - 15 * markedCount) <= 9000 ether * markedCount);
1308 
1309         require(
1310             amount * (800 * coefficient - (JACKPOT_PERCENT + HOUSE_EDGE) * (coefficient * 8 + 15 * markedCount)) <= 1500 * markedCount * (address(this).balance - holdBalance));
1311 
1312         betCount++;
1313 
1314         holdBalance += holdAmount;
1315 
1316         enqueue(block.number, betAmount, betCount, bet, player);
1317         
1318         emit PlaceBet(betCount);
1319 
1320         if (markedCount > 1)
1321             EthexJackpot(jackpotAddress).registerTicket(player);
1322 
1323         EthexHouse(houseAddress).payIn.value(houseEdgeFee)();
1324         EthexJackpot(jackpotAddress).payIn.value(jackpotFee)();
1325     }
1326 
1327     function settleBets() external {
1328         if (first > last)
1329             return;
1330         uint256 i = 0;
1331         uint256 length = getLength();
1332         length = length > 10 ? 10 : length;
1333         Transaction[] memory transactions = new Transaction[](length);
1334         Superprize[] memory superprizes = new Superprize[](length);
1335         uint256 balance = address(this).balance - holdBalance;
1336 
1337         for(; i < length; i++) {
1338             if (blockNumberQueue[first] >= block.number) {
1339                 length = i;
1340                 break;
1341             }
1342             else {
1343                 Bet memory bet = dequeue();
1344                 uint256 coefficient = 0;
1345                 uint8 markedCount = 0;
1346                 uint256 holdAmount = 0;
1347                 (coefficient, markedCount, holdAmount) = getHold(bet.amount, bet.bet);
1348                 holdBalance -= holdAmount;
1349                 balance += holdAmount;
1350                 if (bet.blockNumber < block.number - 256) {
1351                     transactions[i] = Transaction(bet.amount, bet.gamer);
1352                     emit RefundBet(bet.amount, bet.id, bet.gamer);
1353                     balance -= bet.amount;
1354                 }
1355                 else {
1356                     bytes32 blockHash = blockhash(bet.blockNumber);
1357                     coefficient = 0;
1358                     uint8 matchesCount;
1359                     bool isSuperPrize = true;
1360                     for (uint8 j = 0; j < bet.bet.length; j++) {
1361                         if (bet.bet[j] > 0x13) {
1362                             isSuperPrize = false;
1363                             continue;
1364                         }
1365                         byte field;
1366                         if (j % 2 == 0)
1367                             field = blockHash[29 + j / 2] >> 4;
1368                         else
1369                             field = blockHash[29 + j / 2] & 0x0F;
1370                         if (bet.bet[j] < 0x10) {
1371                             if (field == bet.bet[j]) {
1372                                 matchesCount++;
1373                                 coefficient += 30;
1374                             }
1375                             else
1376                                 isSuperPrize = false;
1377                             continue;
1378                         }
1379                         else
1380                             isSuperPrize = false;
1381                         if (bet.bet[j] == 0x10) {
1382                             if (field > 0x09 && field < 0x10) {
1383                                 matchesCount++;
1384                                 coefficient += 5;
1385                             }
1386                             continue;
1387                         }
1388                         if (bet.bet[j] == 0x11) {
1389                             if (field < 0x0A) {
1390                                 matchesCount++;
1391                                 coefficient += 3;
1392                             }
1393                             continue;
1394                         }
1395                         if (bet.bet[j] == 0x12) {
1396                             if (field < 0x0A && field & 0x01 == 0x01) {
1397                                 matchesCount++;
1398                                 coefficient += 6;
1399                             }
1400                             continue;
1401                         }
1402                         if (bet.bet[j] == 0x13) {
1403                             if (field < 0x0A && field & 0x01 == 0x0) {
1404                                 matchesCount++;
1405                                 coefficient += 6;
1406                             }
1407                             continue;
1408                         }
1409                     }
1410 
1411                     coefficient *= PRECISION * 8;
1412                         
1413                     uint256 payoutAmount = bet.amount * coefficient / (PRECISION * 15 * markedCount);
1414                     transactions[i] = Transaction(payoutAmount, bet.gamer);
1415                     emit PayoutBet(payoutAmount, bet.id, bet.gamer);
1416                     balance -= payoutAmount;
1417 
1418                     if (isSuperPrize == true) {
1419                         superprizes[i].amount = balance;
1420                         superprizes[i].id = bet.id;
1421                         balance = 0;
1422                     }
1423                 }
1424             }
1425         }
1426 
1427         for (i = 0; i < length; i++) {
1428             if (transactions[i].amount > 0 && !transactions[i].gamer.send(transactions[i].amount))
1429                 (new DeliverFunds).value(transactions[i].amount)(transactions[i].gamer);
1430             if (superprizes[i].id != 0) {
1431                 EthexSuperprize(superprizeAddress).initSuperprize(transactions[i].gamer, superprizes[i].id);
1432                 EthexJackpot(jackpotAddress).paySuperprize(transactions[i].gamer);
1433                 if (superprizes[i].amount > 0 && !transactions[i].gamer.send(superprizes[i].amount))
1434                     (new DeliverFunds).value(superprizes[i].amount)(transactions[i].gamer);
1435             }
1436         }
1437     }
1438 
1439     function migrate() external {
1440         require(msg.sender == owner || msg.sender == newVersionAddress);
1441         require(getLength() == 0, "There are pending bets");
1442         require(newVersionAddress != address(0), "NewVersionAddress required");
1443         newVersionAddress.transfer(address(this).balance);
1444     }
1445 
1446     function setJackpot(address payable jackpot) external onlyOwner {
1447         jackpotAddress = jackpot;
1448     }
1449 
1450     function setSuperprize(address payable superprize) external onlyOwner {
1451         superprizeAddress = superprize;
1452     }
1453 
1454     function setNewVersion(address payable newVersion) external onlyOwner {
1455         newVersionAddress = newVersion;
1456     }
1457 
1458     function setOldVersion(address payable oldAddress) external onlyOwner {
1459         EthexLoto(oldAddress).migrate();
1460     }
1461 
1462     function withdrawToken(IERC20 token, uint amount, address sendTo) external onlyOwner {
1463         require(token.transfer(sendTo, amount));
1464     }
1465 
1466     function setBetCount(uint256 startBetCount) external onlyOwner { betCount = startBetCount; }
1467 
1468     function length() external view returns (uint256) { return getLength(); }
1469 
1470     function enqueue(uint256 blockNumber, uint256 amount, uint256 id, bytes6 bet, address payable gamer) internal {
1471         last += 1;
1472         blockNumberQueue[last] = blockNumber;
1473         amountQueue[last] = amount;
1474         idQueue[last] = id;
1475         betQueue[last] = bet;
1476         gamerQueue[last] = gamer;
1477     }
1478 
1479     function dequeue() internal returns (Bet memory bet) {
1480         require(last >= first);
1481 
1482         bet = Bet(blockNumberQueue[first], amountQueue[first], idQueue[first], betQueue[first], gamerQueue[first]);
1483 
1484         delete blockNumberQueue[first];
1485         delete amountQueue[first];
1486         delete idQueue[first];
1487         delete betQueue[first];
1488         delete gamerQueue[first];
1489 
1490         if (first == last) {
1491             first = 2;
1492             last = 1;
1493         }
1494         else
1495             first += 1;
1496     }
1497     
1498     function getLength() internal view returns (uint256) {
1499         return 1 + last - first;
1500     }
1501     
1502     function getHold(uint256 amount, bytes6 bet) internal pure returns (uint256 coefficient, uint8 markedCount, uint256 holdAmount) {
1503         for (uint8 i = 0; i < bet.length; i++) {
1504             if (bet[i] > 0x13)
1505                 continue;
1506             markedCount++;
1507             if (bet[i] < 0x10) {
1508                 coefficient += 30;
1509                 continue;
1510             }
1511             if (bet[i] == 0x10) {
1512                 coefficient += 5;
1513                 continue;
1514             }
1515             if (bet[i] == 0x11) {
1516                 coefficient += 3;
1517                 continue;
1518             }
1519             if (bet[i] == 0x12) {
1520                 coefficient += 6;
1521                 continue;
1522             }
1523             if (bet[i] == 0x13) {
1524                 coefficient += 6;
1525                 continue;
1526             }
1527         }
1528         holdAmount = amount * coefficient * 8 / 15 / markedCount;
1529     }
1530 }