1 // File: contracts/DeliverFunds.sol
2 
3 pragma solidity 0.5.16;
4 
5 contract DeliverFunds {
6     constructor(address payable target) public payable {
7         selfdestruct(target);
8     }
9 }
10 
11 // File: contracts/Ownable.sol
12 
13 pragma solidity 0.5.16;
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
39 pragma solidity 0.5.16;
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
59     address public lotoAddress;
60     address payable public newVersionAddress;
61     EthexJackpot public previousContract;
62     
63     struct Segment {
64         uint256 start;
65         uint256 end;
66         bool processed;
67     }
68     
69     event Jackpot (
70         uint256 number,
71         uint256 count,
72         uint256 amount,
73         byte jackpotType
74     );
75     
76     event Ticket (
77         uint256 number
78     );
79     
80     event Superprize (
81         uint256 amount,
82         address winner
83     );
84     
85     uint256 internal constant PRECISION = 1 ether;
86     
87     modifier onlyLoto {
88         require(msg.sender == lotoAddress, "Loto only");
89         _;
90     }
91     
92     function() external payable { }
93     
94     function migrate() external {
95         require(msg.sender == owner || msg.sender == newVersionAddress);
96         require(newVersionAddress != address(0), "NewVersionAddress required");
97         newVersionAddress.transfer(address(this).balance);
98     }
99 
100     function registerTicket(address payable gamer) external payable onlyLoto {
101         distribute();
102         uint8 i;
103         if (gamer == address(0x0)) {
104             for (; i < 4; i++)
105                 if (block.number >= ends[i])
106                     setJackpot(i);
107         }
108         else {
109             uint256 number = numberEnd + 1;
110             for (; i < 4; i++) {
111                 if (block.number >= ends[i]) {
112                     setJackpot(i);
113                     numberStarts[i] = number;
114                 }
115                 else
116                     if (numberStarts[i] == prevJackpots[starts[i]][i].start)
117                         numberStarts[i] = number;
118             }
119             numberEnd = number;
120             tickets[number] = gamer;
121             emit Ticket(number);
122         }
123     }
124     
125     function setLoto(address loto) external onlyOwner {
126         lotoAddress = loto;
127     }
128     
129     function setNewVersion(address payable newVersion) external onlyOwner {
130         newVersionAddress = newVersion;
131     }
132     
133     function payIn() external payable { distribute(); }
134     
135     function settleJackpot() external {
136         for (uint8 i = 0; i < 4; i++)
137             if (block.number >= ends[i])
138                 setJackpot(i);
139 
140         uint256[4] memory payAmounts;
141         uint256[4] memory wins;
142         uint8[4] memory PARTS = [84, 12, 3, 1];
143         for (uint8 i = 0; i < 4; i++) {
144             uint256 start = starts[i];
145             if (block.number == start || (start < block.number - 256))
146                 continue;
147             if (prevJackpots[start][i].processed == false && prevJackpots[start][i].start != 0) {
148                 payAmounts[i] = amounts[i] * PRECISION / PARTS[i] / PRECISION;
149                 amounts[i] -= payAmounts[i];
150                 prevJackpots[start][i].processed = true;
151                 uint48 modulo = uint48(bytes6(blockhash(start) << 29));
152                 wins[i] = getNumber(prevJackpots[start][i].start, prevJackpots[start][i].end, modulo);
153                 emit Jackpot(wins[i], prevJackpots[start][i].end - prevJackpots[start][i].start + 1, payAmounts[i], byte(uint8(1) << i));
154             }
155         }
156         
157         for (uint8 i = 0; i < 4; i++)
158             if (payAmounts[i] > 0 && !getAddress(wins[i]).send(payAmounts[i]))
159                 (new DeliverFunds).value(payAmounts[i])(getAddress(wins[i]));
160     }
161 
162     function settleMissedJackpot(bytes32 hash, uint256 blockHeight) external onlyOwner {
163         for (uint8 i = 0; i < 4; i++)
164             if (block.number >= ends[i])
165                 setJackpot(i);
166         
167         if (blockHeight < block.number - 256) {
168             uint48 modulo = uint48(bytes6(hash << 29));
169         
170             uint256[4] memory payAmounts;
171             uint256[4] memory wins;
172             uint8[4] memory PARTS = [84, 12, 3, 1];
173             for (uint8 i = 0; i < 4; i++) {
174                 if (prevJackpots[blockHeight][i].processed == false && prevJackpots[blockHeight][i].start != 0) {
175                     payAmounts[i] = amounts[i] * PRECISION / PARTS[i] / PRECISION;
176                     amounts[i] -= payAmounts[i];
177                     prevJackpots[blockHeight][i].processed = true;
178                     wins[i] = getNumber(prevJackpots[blockHeight][i].start, prevJackpots[blockHeight][i].end, modulo);
179                     emit Jackpot(wins[i], prevJackpots[blockHeight][i].end - prevJackpots[blockHeight][i].start + 1, payAmounts[i], byte(uint8(1) << i));
180                 }
181             }
182         
183             for (uint8 i = 0; i < 4; i++)
184                 if (payAmounts[i] > 0 && !getAddress(wins[i]).send(payAmounts[i]))
185                     (new DeliverFunds).value(payAmounts[i])(getAddress(wins[i]));
186         }
187     }
188     
189     function paySuperprize(address payable winner) external onlyLoto {
190         uint256 superprizeAmount = amounts[0] + amounts[1] + amounts[2] + amounts[3];
191         amounts[0] = 0;
192         amounts[1] = 0;
193         amounts[2] = 0;
194         amounts[3] = 0;
195         emit Superprize(superprizeAmount, winner);
196         if (superprizeAmount > 0 && !winner.send(superprizeAmount))
197             (new DeliverFunds).value(superprizeAmount)(winner);
198     }
199     
200     function setOldVersion(address payable oldAddress) external onlyOwner {
201         previousContract = EthexJackpot(oldAddress);
202         for (uint8 i = 0; i < 4; i++) {
203             starts[i] = previousContract.starts(i);
204             ends[i] = previousContract.ends(i);
205             numberStarts[i] = previousContract.numberStarts(i);
206             uint256 start;
207             uint256 end;
208             bool processed;
209             (start, end, processed) = previousContract.prevJackpots(starts[i], i);
210             prevJackpots[starts[i]][i] = Segment(start, end, processed);
211             amounts[i] = previousContract.amounts(i);
212         }
213         numberEnd = previousContract.numberEnd();
214         firstNumber = numberEnd;
215         previousContract.migrate();
216     }
217     
218     function getAddress(uint256 number) public returns (address payable) {
219         if (number <= firstNumber)
220             return previousContract.getAddress(number);
221         return tickets[number];
222     }
223     
224     function setJackpot(uint8 jackpotType) private {
225         uint24[4] memory LENGTH = [5000, 35000, 150000, 450000];
226         prevJackpots[ends[jackpotType]][jackpotType].processed = prevJackpots[starts[jackpotType]][jackpotType].end == numberEnd;
227         starts[jackpotType] = ends[jackpotType];
228         ends[jackpotType] = starts[jackpotType] + LENGTH[jackpotType];
229         prevJackpots[starts[jackpotType]][jackpotType].start = numberStarts[jackpotType];
230         prevJackpots[starts[jackpotType]][jackpotType].end = numberEnd;
231     }
232     
233     function distribute() private {
234         uint256 distributedAmount = amounts[0] + amounts[1] + amounts[2] + amounts[3];
235         if (distributedAmount < address(this).balance) {
236             uint256 amount = (address(this).balance - distributedAmount) / 4;
237             amounts[0] += amount;
238             amounts[1] += amount;
239             amounts[2] += amount;
240             amounts[3] += amount;
241         }
242     }
243     
244     function getNumber(uint256 startNumber, uint256 endNumber, uint48 modulo) private pure returns (uint256) {
245         return startNumber + modulo % (endNumber - startNumber + 1);
246     }
247 }
248 
249 // File: contracts/EthexHouse.sol
250 
251 pragma solidity 0.5.16;
252 
253 /**
254  * (E)t)h)e)x) House Contract 
255  *  This smart-contract is the part of Ethex Lottery fair game.
256  *  See latest version at https://github.com/ethex-bet/ethex-contracts 
257  *  http://ethex.bet
258  */
259 
260  
261  contract EthexHouse is Ownable {
262     function payIn() external payable { }
263     
264     function withdraw() external onlyOwner {
265         owner.transfer(address(this).balance);
266     }
267  }
268 
269 // File: contracts/EthexSuperprize.sol
270 
271 pragma solidity 0.5.16;
272 
273 /**
274  * (E)t)h)e)x) Superprize Contract 
275  *  This smart-contract is the part of Ethex Lottery fair game.
276  *  See latest version at https://github.com/ethex-bet/ethex-lottery 
277  *  http://ethex.bet
278  */
279 
280 
281  
282  contract EthexSuperprize is Ownable {
283     struct Payout {
284         uint256 index;
285         uint256 amount;
286         uint256 block;
287         address payable winnerAddress;
288         uint256 betId;
289     }
290      
291     Payout[] public payouts;
292     
293     address public lotoAddress;
294     address payable public newVersionAddress;
295     EthexSuperprize public previousContract;
296     uint256 public hold;
297     
298     event Superprize (
299         uint256 index,
300         uint256 amount,
301         address winner,
302         uint256 betId,
303         byte state
304     );
305     
306     uint8 internal constant PARTS = 6;
307     uint256 internal constant PRECISION = 1 ether;
308     uint256 internal constant MONTHLY = 150000;
309 
310     function() external payable { }
311     
312     function initSuperprize(address payable winner, uint256 betId) external {
313         require(msg.sender == lotoAddress, "Loto only");
314         uint256 amount = address(this).balance - hold;
315         hold = address(this).balance;
316         uint256 sum;
317         uint256 temp;
318         for (uint256 i = 1; i < PARTS; i++) {
319             temp = amount * PRECISION * (i - 1 + 10) / 75 / PRECISION;
320             sum += temp;
321             payouts.push(Payout(i, temp, block.number + i * MONTHLY, winner, betId));
322         }
323         payouts.push(Payout(PARTS, amount - sum, block.number + PARTS * MONTHLY, winner, betId));
324         emit Superprize(0, amount, winner, betId, 0);
325     }
326     
327     function paySuperprize() external onlyOwner {
328         if (payouts.length == 0)
329             return;
330         Payout[] memory payoutArray = new Payout[](payouts.length);
331         uint i = payouts.length;
332         while (i > 0) {
333             i--;
334             if (payouts[i].block <= block.number) {
335                 emit Superprize(payouts[i].index, payouts[i].amount, payouts[i].winnerAddress, payouts[i].betId, 0x01);
336                 hold -= payouts[i].amount;
337             }
338             payoutArray[i] = payouts[i];
339             payouts.pop();
340         }
341         for (i = 0; i < payoutArray.length; i++)
342             if (payoutArray[i].block > block.number)
343                 payouts.push(payoutArray[i]);
344         for (i = 0; i < payoutArray.length; i++)
345             if (payoutArray[i].block <= block.number && !payoutArray[i].winnerAddress.send(payoutArray[i].amount))
346                 (new DeliverFunds).value(payoutArray[i].amount)(payoutArray[i].winnerAddress);
347     }
348      
349     function setOldVersion(address payable oldAddress) external onlyOwner {
350         previousContract = EthexSuperprize(oldAddress);
351         lotoAddress = previousContract.lotoAddress();
352         hold = previousContract.hold();
353         uint256 index;
354         uint256 amount;
355         uint256 betBlock;
356         address payable winner;
357         uint256 betId;
358         uint256 payoutsCount = previousContract.getPayoutsCount();
359         for (uint i = 0; i < payoutsCount; i++) {
360             (index, amount, betBlock, winner, betId) = previousContract.payouts(i);
361             payouts.push(Payout(index, amount, betBlock, winner, betId));
362         }
363         previousContract.migrate();
364     }
365     
366     function setNewVersion(address payable newVersion) external onlyOwner {
367         newVersionAddress = newVersion;
368     }
369     
370     function setLoto(address loto) external onlyOwner {
371         lotoAddress = loto;
372     }
373     
374     function migrate() external {
375         require(msg.sender == owner || msg.sender == newVersionAddress);
376         require(newVersionAddress != address(0));
377         newVersionAddress.transfer(address(this).balance);
378     }   
379 
380     function getPayoutsCount() public view returns (uint256) { return payouts.length; }
381 }
382 
383 // File: contracts/openzeppelin/GSN/Context.sol
384 
385 pragma solidity ^0.5.0;
386 
387 /*
388  * @dev Provides information about the current execution context, including the
389  * sender of the transaction and its data. While these are generally available
390  * via msg.sender and msg.data, they should not be accessed in such a direct
391  * manner, since when dealing with GSN meta-transactions the account sending and
392  * paying for execution may not be the actual sender (as far as an application
393  * is concerned).
394  *
395  * This contract is only required for intermediate, library-like contracts.
396  */
397 contract Context {
398     // Empty internal constructor, to prevent people from mistakenly deploying
399     // an instance of this contract, which should be used via inheritance.
400     constructor () internal { }
401     // solhint-disable-previous-line no-empty-blocks
402 
403     function _msgSender() internal view returns (address payable) {
404         return msg.sender;
405     }
406 
407     function _msgData() internal view returns (bytes memory) {
408         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
409         return msg.data;
410     }
411 }
412 
413 // File: contracts/openzeppelin/token/ERC20/IERC20.sol
414 
415 pragma solidity ^0.5.0;
416 
417 /**
418  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
419  * the optional functions; to access them see {ERC20Detailed}.
420  */
421 interface IERC20 {
422     /**
423      * @dev Returns the amount of tokens in existence.
424      */
425     function totalSupply() external view returns (uint256);
426 
427     /**
428      * @dev Returns the amount of tokens owned by `account`.
429      */
430     function balanceOf(address account) external view returns (uint256);
431 
432     /**
433      * @dev Moves `amount` tokens from the caller's account to `recipient`.
434      *
435      * Returns a boolean value indicating whether the operation succeeded.
436      *
437      * Emits a {Transfer} event.
438      */
439     function transfer(address recipient, uint256 amount) external returns (bool);
440 
441     /**
442      * @dev Returns the remaining number of tokens that `spender` will be
443      * allowed to spend on behalf of `owner` through {transferFrom}. This is
444      * zero by default.
445      *
446      * This value changes when {approve} or {transferFrom} are called.
447      */
448     function allowance(address owner, address spender) external view returns (uint256);
449 
450     /**
451      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
452      *
453      * Returns a boolean value indicating whether the operation succeeded.
454      *
455      * IMPORTANT: Beware that changing an allowance with this method brings the risk
456      * that someone may use both the old and the new allowance by unfortunate
457      * transaction ordering. One possible solution to mitigate this race
458      * condition is to first reduce the spender's allowance to 0 and set the
459      * desired value afterwards:
460      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
461      *
462      * Emits an {Approval} event.
463      */
464     function approve(address spender, uint256 amount) external returns (bool);
465 
466     /**
467      * @dev Moves `amount` tokens from `sender` to `recipient` using the
468      * allowance mechanism. `amount` is then deducted from the caller's
469      * allowance.
470      *
471      * Returns a boolean value indicating whether the operation succeeded.
472      *
473      * Emits a {Transfer} event.
474      */
475     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
476 
477     /**
478      * @dev Emitted when `value` tokens are moved from one account (`from`) to
479      * another (`to`).
480      *
481      * Note that `value` may be zero.
482      */
483     event Transfer(address indexed from, address indexed to, uint256 value);
484 
485     /**
486      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
487      * a call to {approve}. `value` is the new allowance.
488      */
489     event Approval(address indexed owner, address indexed spender, uint256 value);
490 }
491 
492 // File: contracts/openzeppelin/math/SafeMath.sol
493 
494 pragma solidity ^0.5.0;
495 
496 /**
497  * @dev Wrappers over Solidity's arithmetic operations with added overflow
498  * checks.
499  *
500  * Arithmetic operations in Solidity wrap on overflow. This can easily result
501  * in bugs, because programmers usually assume that an overflow raises an
502  * error, which is the standard behavior in high level programming languages.
503  * `SafeMath` restores this intuition by reverting the transaction when an
504  * operation overflows.
505  *
506  * Using this library instead of the unchecked operations eliminates an entire
507  * class of bugs, so it's recommended to use it always.
508  */
509 library SafeMath {
510     /**
511      * @dev Returns the addition of two unsigned integers, reverting on
512      * overflow.
513      *
514      * Counterpart to Solidity's `+` operator.
515      *
516      * Requirements:
517      * - Addition cannot overflow.
518      */
519     function add(uint256 a, uint256 b) internal pure returns (uint256) {
520         uint256 c = a + b;
521         require(c >= a, "SafeMath: addition overflow");
522 
523         return c;
524     }
525 
526     /**
527      * @dev Returns the subtraction of two unsigned integers, reverting on
528      * overflow (when the result is negative).
529      *
530      * Counterpart to Solidity's `-` operator.
531      *
532      * Requirements:
533      * - Subtraction cannot overflow.
534      */
535     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
536         return sub(a, b, "SafeMath: subtraction overflow");
537     }
538 
539     /**
540      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
541      * overflow (when the result is negative).
542      *
543      * Counterpart to Solidity's `-` operator.
544      *
545      * Requirements:
546      * - Subtraction cannot overflow.
547      *
548      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
549      * @dev Get it via `npm install @openzeppelin/contracts@next`.
550      */
551     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
552         require(b <= a, errorMessage);
553         uint256 c = a - b;
554 
555         return c;
556     }
557 
558     /**
559      * @dev Returns the multiplication of two unsigned integers, reverting on
560      * overflow.
561      *
562      * Counterpart to Solidity's `*` operator.
563      *
564      * Requirements:
565      * - Multiplication cannot overflow.
566      */
567     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
568         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
569         // benefit is lost if 'b' is also tested.
570         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
571         if (a == 0) {
572             return 0;
573         }
574 
575         uint256 c = a * b;
576         require(c / a == b, "SafeMath: multiplication overflow");
577 
578         return c;
579     }
580 
581     /**
582      * @dev Returns the integer division of two unsigned integers. Reverts on
583      * division by zero. The result is rounded towards zero.
584      *
585      * Counterpart to Solidity's `/` operator. Note: this function uses a
586      * `revert` opcode (which leaves remaining gas untouched) while Solidity
587      * uses an invalid opcode to revert (consuming all remaining gas).
588      *
589      * Requirements:
590      * - The divisor cannot be zero.
591      */
592     function div(uint256 a, uint256 b) internal pure returns (uint256) {
593         return div(a, b, "SafeMath: division by zero");
594     }
595 
596     /**
597      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
598      * division by zero. The result is rounded towards zero.
599      *
600      * Counterpart to Solidity's `/` operator. Note: this function uses a
601      * `revert` opcode (which leaves remaining gas untouched) while Solidity
602      * uses an invalid opcode to revert (consuming all remaining gas).
603      *
604      * Requirements:
605      * - The divisor cannot be zero.
606 
607      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
608      * @dev Get it via `npm install @openzeppelin/contracts@next`.
609      */
610     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
611         // Solidity only automatically asserts when dividing by 0
612         require(b > 0, errorMessage);
613         uint256 c = a / b;
614         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
615 
616         return c;
617     }
618 
619     /**
620      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
621      * Reverts when dividing by zero.
622      *
623      * Counterpart to Solidity's `%` operator. This function uses a `revert`
624      * opcode (which leaves remaining gas untouched) while Solidity uses an
625      * invalid opcode to revert (consuming all remaining gas).
626      *
627      * Requirements:
628      * - The divisor cannot be zero.
629      */
630     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
631         return mod(a, b, "SafeMath: modulo by zero");
632     }
633 
634     /**
635      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
636      * Reverts with custom message when dividing by zero.
637      *
638      * Counterpart to Solidity's `%` operator. This function uses a `revert`
639      * opcode (which leaves remaining gas untouched) while Solidity uses an
640      * invalid opcode to revert (consuming all remaining gas).
641      *
642      * Requirements:
643      * - The divisor cannot be zero.
644      *
645      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
646      * @dev Get it via `npm install @openzeppelin/contracts@next`.
647      */
648     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
649         require(b != 0, errorMessage);
650         return a % b;
651     }
652 }
653 
654 // File: contracts/openzeppelin/access/Roles.sol
655 
656 pragma solidity ^0.5.0;
657 
658 /**
659  * @title Roles
660  * @dev Library for managing addresses assigned to a Role.
661  */
662 library Roles {
663     struct Role {
664         mapping (address => bool) bearer;
665     }
666 
667     /**
668      * @dev Give an account access to this role.
669      */
670     function add(Role storage role, address account) internal {
671         require(!has(role, account), "Roles: account already has role");
672         role.bearer[account] = true;
673     }
674 
675     /**
676      * @dev Remove an account's access to this role.
677      */
678     function remove(Role storage role, address account) internal {
679         require(has(role, account), "Roles: account does not have role");
680         role.bearer[account] = false;
681     }
682 
683     /**
684      * @dev Check if an account has this role.
685      * @return bool
686      */
687     function has(Role storage role, address account) internal view returns (bool) {
688         require(account != address(0), "Roles: account is the zero address");
689         return role.bearer[account];
690     }
691 }
692 
693 // File: contracts/openzeppelin/access/roles/DistributorRole.sol
694 
695 pragma solidity ^0.5.0;
696 
697 
698 
699 contract DistributorRole is Context {
700     using Roles for Roles.Role;
701 
702     event DistributorAdded(address indexed account);
703     event DistributorRemoved(address indexed account);
704 
705     Roles.Role private _distributors;
706 
707     constructor () internal {
708         _addDistributor(_msgSender());
709     }
710 
711     modifier onlyDistributor() {
712         require(isDistributor(_msgSender()), "DistributorRole: caller does not have the Distributor role");
713         _;
714     }
715 
716     function isDistributor(address account) public view returns (bool) {
717         return _distributors.has(account);
718     }
719 
720     function addDistributor(address account) public onlyDistributor {
721         _addDistributor(account);
722     }
723 
724     function renounceDistributor() public {
725         _removeDistributor(_msgSender());
726     }
727 
728     function _addDistributor(address account) internal {
729         _distributors.add(account);
730         emit DistributorAdded(account);
731     }
732 
733     function _removeDistributor(address account) internal {
734         _distributors.remove(account);
735         emit DistributorRemoved(account);
736     }
737 }
738 
739 // File: contracts/openzeppelin/token/ERC20/ERC20Distributable.sol
740 
741 pragma solidity ^0.5.0;
742 
743 
744 
745 
746 
747 /**
748  * @dev Implementation of the {IERC20} interface.
749  *
750  * This implementation is agnostic to the way tokens are created. This means
751  * that a supply mechanism has to be added in a derived contract using {_mint}.
752  * For a generic mechanism see {ERC20Mintable}.
753  *
754  * TIP: For a detailed writeup see our guide
755  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
756  * to implement supply mechanisms].
757  *
758  * We have followed general OpenZeppelin guidelines: functions revert instead
759  * of returning `false` on failure. This behavior is nonetheless conventional
760  * and does not conflict with the expectations of ERC20 applications.
761  *
762  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
763  * This allows applications to reconstruct the allowance for all accounts just
764  * by listening to said events. Other implementations of the EIP may not emit
765  * these events, as it isn't required by the specification.
766  *
767  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
768  * functions have been added to mitigate the well-known issues around setting
769  * allowances. See {IERC20-approve}.
770  */
771 contract ERC20Distributable is Context, IERC20, DistributorRole {
772     using SafeMath for uint256;
773 
774     mapping (address => uint256) private _balances;
775 
776     mapping (address => mapping (address => uint256)) private _allowances;
777 
778     uint256 private _totalSupply;
779 
780     /**
781      * @dev See {IERC20-totalSupply}.
782      */
783     function totalSupply() public view returns (uint256) {
784         return _totalSupply;
785     }
786 
787     /**
788      * @dev See {IERC20-balanceOf}.
789      */
790     function balanceOf(address account) public view returns (uint256) {
791         return _balances[account];
792     }
793 
794     /**
795      * @dev See {IERC20-transfer}.
796      *
797      * Requirements:
798      *
799      * - `recipient` cannot be the zero address.
800      * - the caller must have a balance of at least `amount`.
801      */
802     function transfer(address recipient, uint256 amount) public onlyDistributor returns (bool) {
803         _transfer(_msgSender(), recipient, amount);
804         return true;
805     }
806 
807     /**
808      * @dev See {IERC20-allowance}.
809      */
810     function allowance(address owner, address spender) public view returns (uint256) {
811         return _allowances[owner][spender];
812     }
813 
814     /**
815      * @dev See {IERC20-approve}.
816      *
817      * Requirements:
818      *
819      * - `spender` cannot be the zero address.
820      */
821     function approve(address spender, uint256 amount) public onlyDistributor returns (bool) {
822         _approve(_msgSender(), spender, amount);
823         return true;
824     }
825 
826     /**
827      * @dev See {IERC20-transferFrom}.
828      *
829      * Emits an {Approval} event indicating the updated allowance. This is not
830      * required by the EIP. See the note at the beginning of {ERC20};
831      *
832      * Requirements:
833      * - `sender` and `recipient` cannot be the zero address.
834      * - `sender` must have a balance of at least `amount`.
835      * - the caller must have allowance for `sender`'s tokens of at least
836      * `amount`.
837      */
838     function transferFrom(address sender, address recipient, uint256 amount) public onlyDistributor returns (bool) {
839         _transfer(sender, recipient, amount);
840         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
841         return true;
842     }
843 
844     /**
845      * @dev Atomically increases the allowance granted to `spender` by the caller.
846      *
847      * This is an alternative to {approve} that can be used as a mitigation for
848      * problems described in {IERC20-approve}.
849      *
850      * Emits an {Approval} event indicating the updated allowance.
851      *
852      * Requirements:
853      *
854      * - `spender` cannot be the zero address.
855      */
856     function increaseAllowance(address spender, uint256 addedValue) public onlyDistributor returns (bool) {
857         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
858         return true;
859     }
860 
861     /**
862      * @dev Atomically decreases the allowance granted to `spender` by the caller.
863      *
864      * This is an alternative to {approve} that can be used as a mitigation for
865      * problems described in {IERC20-approve}.
866      *
867      * Emits an {Approval} event indicating the updated allowance.
868      *
869      * Requirements:
870      *
871      * - `spender` cannot be the zero address.
872      * - `spender` must have allowance for the caller of at least
873      * `subtractedValue`.
874      */
875     function decreaseAllowance(address spender, uint256 subtractedValue) public onlyDistributor returns (bool) {
876         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
877         return true;
878     }
879 
880     /**
881      * @dev Moves tokens `amount` from `sender` to `recipient`.
882      *
883      * This is internal function is equivalent to {transfer}, and can be used to
884      * e.g. implement automatic token fees, slashing mechanisms, etc.
885      *
886      * Emits a {Transfer} event.
887      *
888      * Requirements:
889      *
890      * - `sender` cannot be the zero address.
891      * - `recipient` cannot be the zero address.
892      * - `sender` must have a balance of at least `amount`.
893      */
894     function _transfer(address sender, address recipient, uint256 amount) internal {
895         require(sender != address(0), "ERC20: transfer from the zero address");
896         require(recipient != address(0), "ERC20: transfer to the zero address");
897 
898         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
899         _balances[recipient] = _balances[recipient].add(amount);
900         emit Transfer(sender, recipient, amount);
901     }
902 
903     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
904      * the total supply.
905      *
906      * Emits a {Transfer} event with `from` set to the zero address.
907      *
908      * Requirements
909      *
910      * - `to` cannot be the zero address.
911      */
912     function _mint(address account, uint256 amount) internal {
913         require(account != address(0), "ERC20: mint to the zero address");
914 
915         _totalSupply = _totalSupply.add(amount);
916         _balances[account] = _balances[account].add(amount);
917         emit Transfer(address(0), account, amount);
918     }
919 
920     /**
921      * @dev Destroys `amount` tokens from `account`, reducing the
922      * total supply.
923      *
924      * Emits a {Transfer} event with `to` set to the zero address.
925      *
926      * Requirements
927      *
928      * - `account` cannot be the zero address.
929      * - `account` must have at least `amount` tokens.
930      */
931     function _burn(address account, uint256 amount) internal {
932         require(account != address(0), "ERC20: burn from the zero address");
933 
934         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
935         _totalSupply = _totalSupply.sub(amount);
936         emit Transfer(account, address(0), amount);
937     }
938 
939     /**
940      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
941      *
942      * This is internal function is equivalent to `approve`, and can be used to
943      * e.g. set automatic allowances for certain subsystems, etc.
944      *
945      * Emits an {Approval} event.
946      *
947      * Requirements:
948      *
949      * - `owner` cannot be the zero address.
950      * - `spender` cannot be the zero address.
951      */
952     function _approve(address owner, address spender, uint256 amount) internal {
953         require(owner != address(0), "ERC20: approve from the zero address");
954         require(spender != address(0), "ERC20: approve to the zero address");
955 
956         _allowances[owner][spender] = amount;
957         emit Approval(owner, spender, amount);
958     }
959 
960     /**
961      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
962      * from the caller's allowance.
963      *
964      * See {_burn} and {_approve}.
965      */
966     function _burnFrom(address account, uint256 amount) internal {
967         _burn(account, amount);
968         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
969     }
970 }
971 
972 // File: contracts/openzeppelin/token/ERC20/ERC20Detailed.sol
973 
974 pragma solidity ^0.5.0;
975 
976 
977 /**
978  * @dev Optional functions from the ERC20 standard.
979  */
980 contract ERC20Detailed is IERC20 {
981     string private _name;
982     string private _symbol;
983     uint8 private _decimals;
984 
985     /**
986      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
987      * these values are immutable: they can only be set once during
988      * construction.
989      */
990     constructor (string memory name, string memory symbol, uint8 decimals) public {
991         _name = name;
992         _symbol = symbol;
993         _decimals = decimals;
994     }
995 
996     /**
997      * @dev Returns the name of the token.
998      */
999     function name() public view returns (string memory) {
1000         return _name;
1001     }
1002 
1003     /**
1004      * @dev Returns the symbol of the token, usually a shorter version of the
1005      * name.
1006      */
1007     function symbol() public view returns (string memory) {
1008         return _symbol;
1009     }
1010 
1011     /**
1012      * @dev Returns the number of decimals used to get its user representation.
1013      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1014      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1015      *
1016      * Tokens usually opt for a value of 18, imitating the relationship between
1017      * Ether and Wei.
1018      *
1019      * NOTE: This information is only used for _display_ purposes: it in
1020      * no way affects any of the arithmetic of the contract, including
1021      * {IERC20-balanceOf} and {IERC20-transfer}.
1022      */
1023     function decimals() public view returns (uint8) {
1024         return _decimals;
1025     }
1026 }
1027 
1028 // File: contracts/EthexFreeSpins.sol
1029 
1030 pragma solidity 0.5.16;
1031 
1032 
1033 
1034 
1035 
1036 contract EthexFreeSpins is Ownable, Context, ERC20Distributable, ERC20Detailed {
1037     mapping (address => bool) private _migrated;
1038 	
1039     address payable public lotoAddress;
1040     address payable public oldVersionAddress;
1041     address payable public newVersionAddress;
1042 
1043     uint256 public Rate;
1044 
1045     constructor (uint256 rate) public ERC20Detailed("EthexFreeSpins", "EFS", 18) { 
1046 		require(rate > 0, "Rate must be non zero");
1047         Rate = rate;
1048     }
1049 
1050     function use(address account, uint256 amount) public {
1051 		require(amount >= Rate, "Amount must be greater then rate");
1052         require(msg.sender == lotoAddress, "Loto only");
1053         if (oldVersionAddress != address(0) && _migrated[account] == false) {
1054             uint256 totalAmount = EthexFreeSpins(oldVersionAddress).totalBalanceOf(account);
1055             _mint(account, totalAmount);
1056             _migrated[account] = true;
1057         }
1058         _burn(account, amount);
1059         lotoAddress.transfer(amount / Rate);
1060     }
1061 
1062     function removeDistributor(address account) external onlyOwner {
1063         _removeDistributor(account);
1064     }
1065 
1066     function setLoto(address payable loto) external onlyOwner {
1067         lotoAddress = loto;
1068     }
1069 
1070     function mint(address account) public payable {
1071         _mint(account, msg.value * Rate);
1072     }
1073     
1074     function setOldVersion(address payable oldVersion) external onlyOwner {
1075         oldVersionAddress = oldVersion;
1076     }
1077     
1078     function setNewVersion(address payable newVersion) external onlyOwner {
1079         newVersionAddress = newVersion;
1080     }
1081     
1082     function migrate() external {
1083         require(msg.sender == owner || msg.sender == newVersionAddress);
1084         require(newVersionAddress != address(0), "NewVersionAddress required");
1085         EthexFreeSpins(newVersionAddress).payIn.value(address(this).balance)();
1086     }
1087     
1088     function payIn() external payable { }
1089     
1090     function totalBalanceOf(address account) public view returns (uint256) {
1091         uint256 balance = balanceOf(account);
1092         if (oldVersionAddress != address(0) && _migrated[account] == false)
1093             return balance + EthexFreeSpins(oldVersionAddress).totalBalanceOf(account);
1094         return balance;
1095     }
1096 }
1097 
1098 // File: contracts/uniswap/IUniswapFactory.sol
1099 
1100 pragma solidity ^0.5.0;
1101 
1102 contract IUniswapFactory {
1103     // Public Variables
1104     address public exchangeTemplate;
1105     uint256 public tokenCount;
1106     // Create Exchange
1107     function createExchange(address token) external returns (address exchange);
1108     // Get Exchange and Token Info
1109     function getExchange(address token) external view returns (address exchange);
1110     function getToken(address exchange) external view returns (address token);
1111     function getTokenWithId(uint256 tokenId) external view returns (address token);
1112     // Never use
1113     function initializeFactory(address template) external;
1114 }
1115 
1116 // File: contracts/uniswap/IUniswapExchange.sol
1117 
1118 pragma solidity ^0.5.0;
1119 
1120 contract IUniswapExchange {
1121     // Address of ERC20 token sold on this exchange
1122     function tokenAddress() external view returns (address token);
1123     // Address of Uniswap Factory
1124     function factoryAddress() external view returns (address factory);
1125     // Provide Liquidity
1126     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
1127     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
1128     // Get Prices
1129     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
1130     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
1131     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
1132     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
1133     // Trade ETH to ERC20
1134     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
1135     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
1136     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
1137     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
1138     // Trade ERC20 to ETH
1139     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
1140     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
1141     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
1142     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
1143     // Trade ERC20 to ERC20
1144     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
1145     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
1146     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
1147     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
1148     // Trade ERC20 to Custom Pool
1149     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
1150     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
1151     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
1152     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
1153     // ERC20 comaptibility for liquidity tokens
1154     bytes32 public name;
1155     bytes32 public symbol;
1156     uint256 public decimals;
1157     function transfer(address _to, uint256 _value) external returns (bool);
1158     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
1159     function approve(address _spender, uint256 _value) external returns (bool);
1160     function allowance(address _owner, address _spender) external view returns (uint256);
1161     function balanceOf(address _owner) external view returns (uint256);
1162     function totalSupply() external view returns (uint256);
1163     // Never use
1164     function setup(address token_addr) external;
1165 }
1166 
1167 // File: contracts/EthexLoto.sol
1168 
1169 pragma solidity 0.5.16;
1170 
1171 /**
1172  * (E)t)h)e)x) Loto Contract 
1173  *  This smart-contract is the part of Ethex Lottery fair game.
1174  *  See latest version at https://github.com/ethex-bet/ethex-contacts 
1175  *  http://ethex.bet
1176  */
1177 
1178 
1179 
1180 
1181 
1182 
1183 
1184 
1185 
1186 
1187 contract EthexLoto is Ownable {
1188     struct Bet {
1189         uint256 blockNumber;
1190         uint256 amount;
1191         uint256 id;
1192         bytes6 bet;
1193         address payable gamer;
1194     }
1195 
1196     struct Transaction {
1197         uint256 amount;
1198         address payable gamer;
1199     }
1200 
1201     struct Superprize {
1202         uint256 amount;
1203         uint256 id;
1204     }
1205     
1206     mapping(uint256 => Bet) public betQueue;
1207     uint256 public counters = 0x20000000000000001;
1208     uint256 public holdBalance;
1209     uint256 public betCount;
1210 
1211     address payable public newVersionAddress;
1212     address payable public jackpotAddress;
1213     address payable public houseAddress;
1214     address payable public superprizeAddress;
1215     address payable public freeSpinsAddress;
1216     address payable public uniswapAddress;
1217 
1218     event TokenBetAdded (
1219         uint256 tokenAmount,
1220         uint256 ethAmount
1221     );
1222     
1223     event PlaceBet (
1224         uint256 id
1225     );
1226 
1227     event PayoutBet (
1228         uint256 amount,
1229         uint256 id,
1230         address gamer
1231     );
1232 
1233     event RefundBet (
1234         uint256 amount,
1235         uint256 id,
1236         address gamer
1237     );
1238 
1239     uint256 internal constant MIN_BET = 0.01 ether;
1240     uint256 internal constant PRECISION = 1 ether;
1241     uint256 internal constant JACKPOT_PERCENT = 10;
1242     uint256 internal constant HOUSE_EDGE = 10;
1243 
1244     constructor(address payable jackpot, address payable house, address payable superprize, address payable freeSpins, address payable uniswap) public {
1245         jackpotAddress = jackpot;
1246         houseAddress = house;
1247         superprizeAddress = superprize;
1248         freeSpinsAddress = freeSpins;
1249         uniswapAddress = uniswap;
1250         
1251         for(uint i = 1; i <= 10; i++)
1252             betQueue[i] = Bet(1, MIN_BET, 1, 0xffffffffffff, address(0x0));
1253     }
1254 
1255     function() external payable { }
1256 
1257     function placeTokenBet(address tokenAddress, uint256 betMaxTokenAmount, uint256 betTargetEthAmount, uint256 swapDeadline, bytes6 bet) external {
1258         require(betTargetEthAmount >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
1259         require(tokenAddress != address(0), "Token address is required");
1260 
1261         if (tokenAddress == freeSpinsAddress)
1262         {
1263             placeFreeSpinBet(betTargetEthAmount, bet);
1264             return;
1265         }
1266 
1267         IERC20 token = IERC20(tokenAddress);
1268         IUniswapFactory uniswapFactory = IUniswapFactory(uniswapAddress);
1269 
1270         address exchangeAddress = uniswapFactory.getExchange(tokenAddress);
1271         require(exchangeAddress != address(0), "Token is not supported");
1272 
1273         IUniswapExchange uniswap = IUniswapExchange(exchangeAddress);
1274 
1275         uint256 tokensSold = uniswap.getTokenToEthOutputPrice(betTargetEthAmount);
1276         require(betMaxTokenAmount >= tokensSold, "Swap requires more token then was allowed");
1277 
1278         uint256 balance = token.balanceOf(msg.sender);
1279         require(balance >= tokensSold, "Not enough tokens");
1280 
1281         token.transferFrom(msg.sender, address(this), tokensSold);
1282         token.approve(exchangeAddress, tokensSold);
1283 
1284         uint256 converted = uniswap.tokenToEthSwapOutput(betTargetEthAmount, tokensSold, swapDeadline);
1285         require(converted >= betTargetEthAmount, "Exchange result is smaller then requested");
1286 
1287         placeBet(msg.sender, betTargetEthAmount, bet);
1288 
1289         emit TokenBetAdded(tokensSold, betTargetEthAmount);
1290     }
1291 
1292     function placeFreeSpinBet(uint256 betAmount, bytes6 bet) public {
1293         require(betAmount >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
1294 
1295         EthexFreeSpins freeSpinsToken = EthexFreeSpins(freeSpinsAddress);
1296 
1297         uint256 freeSpinAmount = betAmount * freeSpinsToken.Rate();
1298         uint256 freeSpinBalance = freeSpinsToken.balanceOf(msg.sender);
1299 
1300         require(freeSpinBalance >= freeSpinAmount, "Not enough tokens");
1301 
1302         freeSpinsToken.use(msg.sender, freeSpinAmount);
1303         placeBet(msg.sender, betAmount, bet);
1304 
1305         emit TokenBetAdded(freeSpinAmount, betAmount);
1306     }
1307 
1308     function placeBet(bytes6 bet) external payable {
1309         require(tx.origin == msg.sender);
1310 
1311         placeBet(msg.sender, msg.value, bet);
1312     }
1313 
1314     function placeBet(address payable player, uint256 amount, bytes6 bet) private {
1315         require(amount >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
1316 
1317         uint256 coefficient;
1318         uint8 markedCount;
1319         uint256 holdAmount;
1320         uint256 jackpotFee = amount * JACKPOT_PERCENT * PRECISION / 100 / PRECISION;
1321         uint256 houseEdgeFee = amount * HOUSE_EDGE * PRECISION / 100 / PRECISION;
1322         uint256 betAmount = amount - jackpotFee - houseEdgeFee;
1323 
1324         (coefficient, markedCount, holdAmount) = getHold(betAmount, bet);
1325 
1326         require(amount * (100 - JACKPOT_PERCENT - HOUSE_EDGE) * (coefficient * 8 - 15 * markedCount) <= 9000 ether * markedCount);
1327 
1328         require(
1329             amount * (800 * coefficient - (JACKPOT_PERCENT + HOUSE_EDGE) * (coefficient * 8 + 15 * markedCount)) <= 1500 * markedCount * (address(this).balance - holdBalance));
1330 
1331         holdBalance += holdAmount;
1332         
1333         emit PlaceBet(enqueue(betAmount, bet, player));
1334         
1335         EthexJackpot(jackpotAddress).registerTicket.value(jackpotFee)(markedCount > 1 ? player : address(0x0));
1336         EthexHouse(houseAddress).payIn.value(houseEdgeFee)();
1337     }
1338 
1339     function settleBets() external {
1340         uint256 betCount;
1341         uint256 first;
1342         uint256 last;
1343         (betCount, first, last) = getCounters();
1344         if (first > last)
1345             return;
1346         uint256 i = 0;
1347         uint256 length = getLength();
1348         length = length > 10 ? 10 : length;
1349         Transaction[] memory transactions = new Transaction[](length);
1350         Superprize[] memory superprizes = new Superprize[](length);
1351         uint256 hold = holdBalance;
1352         uint256 balance = address(this).balance - hold;
1353 
1354         for(; i < length; i++) {
1355             if (betQueue[first].blockNumber >= block.number) {
1356                 length = i;
1357                 break;
1358             }
1359             else {
1360                 Bet memory bet = dequeue();
1361                 uint256 coefficient = 0;
1362                 uint8 markedCount = 0;
1363                 uint256 holdAmount = 0;
1364                 (coefficient, markedCount, holdAmount) = getHold(bet.amount, bet.bet);
1365                 hold -= holdAmount;
1366                 balance += holdAmount;
1367                 if (bet.blockNumber < block.number - 256) {
1368                     transactions[i] = Transaction(bet.amount, bet.gamer);
1369                     emit RefundBet(bet.amount, bet.id, bet.gamer);
1370                     balance -= bet.amount;
1371                 }
1372                 else {
1373                     bytes32 blockHash = blockhash(bet.blockNumber);
1374                     coefficient = 0;
1375                     uint8 matchesCount;
1376                     bool isSuperPrize = true;
1377                     for (uint8 j = 0; j < bet.bet.length; j++) {
1378                         if (bet.bet[j] > 0x13) {
1379                             isSuperPrize = false;
1380                             continue;
1381                         }
1382                         byte field;
1383                         if (j % 2 == 0)
1384                             field = blockHash[29 + j / 2] >> 4;
1385                         else
1386                             field = blockHash[29 + j / 2] & 0x0F;
1387                         if (bet.bet[j] < 0x10) {
1388                             if (field == bet.bet[j]) {
1389                                 matchesCount++;
1390                                 coefficient += 30;
1391                             }
1392                             else
1393                                 isSuperPrize = false;
1394                             continue;
1395                         }
1396                         else
1397                             isSuperPrize = false;
1398                         if (bet.bet[j] == 0x10) {
1399                             if (field > 0x09 && field < 0x10) {
1400                                 matchesCount++;
1401                                 coefficient += 5;
1402                             }
1403                             continue;
1404                         }
1405                         if (bet.bet[j] == 0x11) {
1406                             if (field < 0x0A) {
1407                                 matchesCount++;
1408                                 coefficient += 3;
1409                             }
1410                             continue;
1411                         }
1412                         if (bet.bet[j] == 0x12) {
1413                             if (field < 0x0A && field & 0x01 == 0x01) {
1414                                 matchesCount++;
1415                                 coefficient += 6;
1416                             }
1417                             continue;
1418                         }
1419                         if (bet.bet[j] == 0x13) {
1420                             if (field < 0x0A && field & 0x01 == 0x0) {
1421                                 matchesCount++;
1422                                 coefficient += 6;
1423                             }
1424                             continue;
1425                         }
1426                     }
1427 
1428                     coefficient *= PRECISION * 8;
1429                         
1430                     uint256 payoutAmount = bet.amount * coefficient / (PRECISION * 15 * markedCount);
1431                     transactions[i] = Transaction(payoutAmount, bet.gamer);
1432                     emit PayoutBet(payoutAmount, bet.id, bet.gamer);
1433                     balance -= payoutAmount;
1434 
1435                     if (isSuperPrize == true) {
1436                         superprizes[i].amount = balance;
1437                         superprizes[i].id = bet.id;
1438                         balance = 0;
1439                     }
1440                 }
1441                 holdBalance = hold;
1442             }
1443         }
1444 
1445         for (i = 0; i < length; i++) {
1446             if (transactions[i].amount > 0 && !transactions[i].gamer.send(transactions[i].amount))
1447                 (new DeliverFunds).value(transactions[i].amount)(transactions[i].gamer);
1448             if (superprizes[i].id != 0) {
1449                 EthexSuperprize(superprizeAddress).initSuperprize(transactions[i].gamer, superprizes[i].id);
1450                 EthexJackpot(jackpotAddress).paySuperprize(transactions[i].gamer);
1451                 if (superprizes[i].amount > 0 && !transactions[i].gamer.send(superprizes[i].amount))
1452                     (new DeliverFunds).value(superprizes[i].amount)(transactions[i].gamer);
1453             }
1454         }
1455     }
1456 
1457     function migrate() external {
1458         require(msg.sender == owner || msg.sender == newVersionAddress);
1459         require(getLength() == 0, "There are pending bets");
1460         require(newVersionAddress != address(0), "NewVersionAddress required");
1461         newVersionAddress.transfer(address(this).balance);
1462     }
1463 
1464     function setJackpot(address payable jackpot) external onlyOwner {
1465         jackpotAddress = jackpot;
1466     }
1467 
1468     function setSuperprize(address payable superprize) external onlyOwner {
1469         superprizeAddress = superprize;
1470     }
1471     
1472     function setFreeSpins(address payable freeSpins) external onlyOwner {
1473         freeSpinsAddress = freeSpins;
1474     }
1475 
1476     function setNewVersion(address payable newVersion) external onlyOwner {
1477         newVersionAddress = newVersion;
1478     }
1479 
1480     function setOldVersion(address payable oldAddress) external onlyOwner {
1481         counters = EthexLoto(oldAddress).betCount() << 128 | counters & 0xffffffffffffffffffffffffffffffff;
1482         EthexLoto(oldAddress).migrate();
1483     }
1484 
1485     function withdrawToken(IERC20 token, uint amount, address sendTo) external onlyOwner {
1486         require(token.transfer(sendTo, amount));
1487     }
1488 
1489     function length() external view returns (uint256) { return getLength(); }
1490 
1491     function enqueue(uint256 amount, bytes6 bet, address payable gamer) internal returns (uint256 betCount) {
1492         uint256 first;
1493         uint256 last;
1494         (betCount, first, last) = getCounters();
1495         last++;
1496         betCount++;
1497         betQueue[last] = Bet(block.number, amount, betCount, bet, gamer);
1498         counters = betCount << 128 | (first << 64 | last);
1499     }
1500 
1501     function dequeue() internal returns (Bet memory bet) {
1502         uint256 betCount;
1503         uint256 first;
1504         uint256 last;
1505         (betCount, first, last) = getCounters();
1506         require(last >= first);
1507 
1508         bet = betQueue[first];
1509 
1510         if (first == last)
1511             counters = betCount << 128 | 0x20000000000000001;
1512         else
1513             counters = betCount << 128 | (first + 1 << 64 | last);
1514     }
1515     
1516     function getLength() internal view returns (uint256) {
1517         uint256 betCount;
1518         uint256 first;
1519         uint256 last;
1520         (betCount, first, last) = getCounters();
1521         return 1 + last - first;
1522     }
1523     
1524     function getCounters() internal view returns (uint256 betCount, uint256 first, uint256 last) {
1525         betCount = counters >> 128;
1526         first = (counters & 0xffffffffffffffffffffffffffffffff) >> 64;
1527         last = counters & 0xffffffffffffffff;
1528     }
1529     
1530     function getHold(uint256 amount, bytes6 bet) internal pure returns (uint256 coefficient, uint8 markedCount, uint256 holdAmount) {
1531         for (uint8 i = 0; i < bet.length; i++) {
1532             if (bet[i] > 0x13)
1533                 continue;
1534             markedCount++;
1535             if (bet[i] < 0x10) {
1536                 coefficient += 30;
1537                 continue;
1538             }
1539             if (bet[i] == 0x10) {
1540                 coefficient += 5;
1541                 continue;
1542             }
1543             if (bet[i] == 0x11) {
1544                 coefficient += 3;
1545                 continue;
1546             }
1547             if (bet[i] == 0x12) {
1548                 coefficient += 6;
1549                 continue;
1550             }
1551             if (bet[i] == 0x13) {
1552                 coefficient += 6;
1553                 continue;
1554             }
1555         }
1556         holdAmount = amount * coefficient * 8 / 15 / markedCount;
1557     }
1558 }