1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     
6     function totalSupply() external view returns (uint256);
7 
8     
9     function balanceOf(address account) external view returns (uint256);
10 
11     
12     function transfer(address recipient, uint256 amount) external returns (bool);
13 
14     
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22 
23     
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         
55         
56         
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63 
64         return c;
65     }
66 
67     
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         
78 
79         return c;
80     }
81 
82     
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86 
87     
88     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b != 0, errorMessage);
90         return a % b;
91     }
92 }
93 
94 library Address {
95     
96     function isContract(address account) internal view returns (bool) {
97         
98         
99         
100 
101         
102         
103         
104         bytes32 codehash;
105         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
106         
107         assembly { codehash := extcodehash(account) }
108         return (codehash != 0x0 && codehash != accountHash);
109     }
110 
111     
112     function toPayable(address account) internal pure returns (address payable) {
113         return address(uint160(account));
114     }
115 }
116 
117 library SafeERC20 {
118     using SafeMath for uint256;
119     using Address for address;
120 
121     function safeTransfer(IERC20 token, address to, uint256 value) internal {
122         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
123     }
124 
125     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
126         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
127     }
128 
129     function safeApprove(IERC20 token, address spender, uint256 value) internal {
130         
131         
132         
133         
134         require((value == 0) || (token.allowance(address(this), spender) == 0),
135             "SafeERC20: approve from non-zero to non-zero allowance"
136         );
137         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
138     }
139 
140     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
141         uint256 newAllowance = token.allowance(address(this), spender).add(value);
142         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
143     }
144 
145     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
146         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
147         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
148     }
149 
150     
151     function callOptionalReturn(IERC20 token, bytes memory data) private {
152         
153         
154 
155         
156         
157         
158         
159         
160         require(address(token).isContract(), "SafeERC20: call to non-contract");
161 
162         
163         (bool success, bytes memory returndata) = address(token).call(data);
164         require(success, "SafeERC20: low-level call failed");
165 
166         if (returndata.length > 0) { 
167             
168             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
169         }
170     }
171 }
172 
173 library Math {
174     
175     function max(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a >= b ? a : b;
177     }
178 
179     
180     function min(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a < b ? a : b;
182     }
183 
184     
185     function average(uint256 a, uint256 b) internal pure returns (uint256) {
186         
187         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
188     }
189 }
190 
191 contract EpochTokenLocker {
192     using SafeMath for uint256;
193 
194     
195     uint32 public constant BATCH_TIME = 300;
196 
197     
198     mapping(address => mapping(address => BalanceState)) private balanceStates;
199 
200     
201     mapping(address => mapping(address => uint32)) public lastCreditBatchId;
202 
203     struct BalanceState {
204         uint256 balance;
205         PendingFlux pendingDeposits; 
206         PendingFlux pendingWithdraws; 
207     }
208 
209     struct PendingFlux {
210         uint256 amount;
211         uint32 batchId;
212     }
213 
214     event Deposit(address indexed user, address indexed token, uint256 amount, uint32 batchId);
215 
216     event WithdrawRequest(address indexed user, address indexed token, uint256 amount, uint32 batchId);
217 
218     event Withdraw(address indexed user, address indexed token, uint256 amount);
219 
220     
221     function deposit(address token, uint256 amount) public {
222         updateDepositsBalance(msg.sender, token);
223         SafeERC20.safeTransferFrom(IERC20(token), msg.sender, address(this), amount);
224         
225         balanceStates[msg.sender][token].pendingDeposits.amount = balanceStates[msg.sender][token].pendingDeposits.amount.add(
226             amount
227         );
228         balanceStates[msg.sender][token].pendingDeposits.batchId = getCurrentBatchId();
229         emit Deposit(msg.sender, token, amount, getCurrentBatchId());
230     }
231 
232     
233     function requestWithdraw(address token, uint256 amount) public {
234         requestFutureWithdraw(token, amount, getCurrentBatchId());
235     }
236 
237     
238     function requestFutureWithdraw(address token, uint256 amount, uint32 batchId) public {
239         
240         if (hasValidWithdrawRequest(msg.sender, token)) {
241             withdraw(msg.sender, token);
242         }
243         require(batchId >= getCurrentBatchId(), "Request cannot be made in the past");
244         balanceStates[msg.sender][token].pendingWithdraws = PendingFlux({amount: amount, batchId: batchId});
245         emit WithdrawRequest(msg.sender, token, amount, batchId);
246     }
247 
248     
249     function withdraw(address user, address token) public {
250         updateDepositsBalance(user, token); 
251         require(
252             balanceStates[user][token].pendingWithdraws.batchId < getCurrentBatchId(),
253             "withdraw was not registered previously"
254         );
255         require(
256             lastCreditBatchId[user][token] < getCurrentBatchId(),
257             "Withdraw not possible for token that is traded in the current auction"
258         );
259         uint256 amount = Math.min(balanceStates[user][token].balance, balanceStates[user][token].pendingWithdraws.amount);
260 
261         balanceStates[user][token].balance = balanceStates[user][token].balance.sub(amount);
262         delete balanceStates[user][token].pendingWithdraws;
263 
264         SafeERC20.safeTransfer(IERC20(token), user, amount);
265         emit Withdraw(user, token, amount);
266     }
267     
268 
269     
270     function getPendingDeposit(address user, address token) public view returns (uint256, uint32) {
271         PendingFlux memory pendingDeposit = balanceStates[user][token].pendingDeposits;
272         return (pendingDeposit.amount, pendingDeposit.batchId);
273     }
274 
275     
276     function getPendingWithdraw(address user, address token) public view returns (uint256, uint32) {
277         PendingFlux memory pendingWithdraw = balanceStates[user][token].pendingWithdraws;
278         return (pendingWithdraw.amount, pendingWithdraw.batchId);
279     }
280 
281     
282     function getCurrentBatchId() public view returns (uint32) {
283         
284         return uint32(now / BATCH_TIME);
285     }
286 
287     
288     function getSecondsRemainingInBatch() public view returns (uint256) {
289         
290         return BATCH_TIME - (now % BATCH_TIME);
291     }
292 
293     
294     function getBalance(address user, address token) public view returns (uint256) {
295         uint256 balance = balanceStates[user][token].balance;
296         if (balanceStates[user][token].pendingDeposits.batchId < getCurrentBatchId()) {
297             balance = balance.add(balanceStates[user][token].pendingDeposits.amount);
298         }
299         if (balanceStates[user][token].pendingWithdraws.batchId < getCurrentBatchId()) {
300             balance = balance.sub(Math.min(balanceStates[user][token].pendingWithdraws.amount, balance));
301         }
302         return balance;
303     }
304 
305     
306     function hasValidWithdrawRequest(address user, address token) public view returns (bool) {
307         return
308             balanceStates[user][token].pendingWithdraws.batchId < getCurrentBatchId() &&
309             balanceStates[user][token].pendingWithdraws.batchId > 0;
310     }
311 
312     
313     
314     function addBalanceAndBlockWithdrawForThisBatch(address user, address token, uint256 amount) internal {
315         if (hasValidWithdrawRequest(user, token)) {
316             lastCreditBatchId[user][token] = getCurrentBatchId();
317         }
318         addBalance(user, token, amount);
319     }
320 
321     function addBalance(address user, address token, uint256 amount) internal {
322         updateDepositsBalance(user, token);
323         balanceStates[user][token].balance = balanceStates[user][token].balance.add(amount);
324     }
325 
326     function subtractBalance(address user, address token, uint256 amount) internal {
327         updateDepositsBalance(user, token);
328         balanceStates[user][token].balance = balanceStates[user][token].balance.sub(amount);
329     }
330 
331     function updateDepositsBalance(address user, address token) private {
332         if (balanceStates[user][token].pendingDeposits.batchId < getCurrentBatchId()) {
333             balanceStates[user][token].balance = balanceStates[user][token].balance.add(
334                 balanceStates[user][token].pendingDeposits.amount
335             );
336             delete balanceStates[user][token].pendingDeposits;
337         }
338     }
339 }
340 
341 library IdToAddressBiMap {
342     struct Data {
343         mapping(uint16 => address) idToAddress;
344         mapping(address => uint16) addressToId;
345     }
346 
347     function hasId(Data storage self, uint16 id) public view returns (bool) {
348         return self.idToAddress[id + 1] != address(0);
349     }
350 
351     function hasAddress(Data storage self, address addr) public view returns (bool) {
352         return self.addressToId[addr] != 0;
353     }
354 
355     function getAddressAt(Data storage self, uint16 id) public view returns (address) {
356         require(hasId(self, id), "Must have ID to get Address");
357         return self.idToAddress[id + 1];
358     }
359 
360     function getId(Data storage self, address addr) public view returns (uint16) {
361         require(hasAddress(self, addr), "Must have Address to get ID");
362         return self.addressToId[addr] - 1;
363     }
364 
365     function insert(Data storage self, uint16 id, address addr) public returns (bool) {
366         
367         if (self.addressToId[addr] != 0 || self.idToAddress[id + 1] != address(0)) {
368             return false;
369         }
370         self.idToAddress[id + 1] = addr;
371         self.addressToId[addr] = id + 1;
372         return true;
373     }
374 
375 }
376 
377 library IterableAppendOnlySet {
378     struct Data {
379         mapping(address => address) nextMap;
380         address last;
381     }
382 
383     function insert(Data storage self, address value) public returns (bool) {
384         if (contains(self, value)) {
385             return false;
386         }
387         self.nextMap[self.last] = value;
388         self.last = value;
389         return true;
390     }
391 
392     function contains(Data storage self, address value) public view returns (bool) {
393         require(value != address(0), "Inserting address(0) is not supported");
394         return self.nextMap[value] != address(0) || (self.last == value);
395     }
396 
397     function first(Data storage self) public view returns (address) {
398         require(self.last != address(0), "Trying to get first from empty set");
399         return self.nextMap[address(0)];
400     }
401 
402     function next(Data storage self, address value) public view returns (address) {
403         require(contains(self, value), "Trying to get next of non-existent element");
404         require(value != self.last, "Trying to get next of last element");
405         return self.nextMap[value];
406     }
407 
408     function size(Data storage self) public view returns (uint256) {
409         if (self.last == address(0)) {
410             return 0;
411         }
412         uint256 count = 1;
413         address current = first(self);
414         while (current != self.last) {
415             current = next(self, current);
416             count++;
417         }
418         return count;
419     }
420 }
421 
422 library GnosisMath {
423     
424     
425     uint public constant ONE = 0x10000000000000000;
426     uint public constant LN2 = 0xb17217f7d1cf79ac;
427     uint public constant LOG2_E = 0x171547652b82fe177;
428 
429     
430     
431     
432     
433     function exp(int x) public pure returns (uint) {
434         
435         
436         require(x <= 2454971259878909886679);
437         
438         
439         if (x < -818323753292969962227) return 0;
440         
441         x = x * int(ONE) / int(LN2);
442         
443         
444         
445         int shift;
446         uint z;
447         if (x >= 0) {
448             shift = x / int(ONE);
449             z = uint(x % int(ONE));
450         } else {
451             shift = x / int(ONE) - 1;
452             z = ONE - uint(-x % int(ONE));
453         }
454         
455         
456         
457         
458         
459         
460         
461         
462         
463         
464         
465         
466         
467         uint zpow = z;
468         uint result = ONE;
469         result += 0xb17217f7d1cf79ab * zpow / ONE;
470         zpow = zpow * z / ONE;
471         result += 0x3d7f7bff058b1d50 * zpow / ONE;
472         zpow = zpow * z / ONE;
473         result += 0xe35846b82505fc5 * zpow / ONE;
474         zpow = zpow * z / ONE;
475         result += 0x276556df749cee5 * zpow / ONE;
476         zpow = zpow * z / ONE;
477         result += 0x5761ff9e299cc4 * zpow / ONE;
478         zpow = zpow * z / ONE;
479         result += 0xa184897c363c3 * zpow / ONE;
480         zpow = zpow * z / ONE;
481         result += 0xffe5fe2c4586 * zpow / ONE;
482         zpow = zpow * z / ONE;
483         result += 0x162c0223a5c8 * zpow / ONE;
484         zpow = zpow * z / ONE;
485         result += 0x1b5253d395e * zpow / ONE;
486         zpow = zpow * z / ONE;
487         result += 0x1e4cf5158b * zpow / ONE;
488         zpow = zpow * z / ONE;
489         result += 0x1e8cac735 * zpow / ONE;
490         zpow = zpow * z / ONE;
491         result += 0x1c3bd650 * zpow / ONE;
492         zpow = zpow * z / ONE;
493         result += 0x1816193 * zpow / ONE;
494         zpow = zpow * z / ONE;
495         result += 0x131496 * zpow / ONE;
496         zpow = zpow * z / ONE;
497         result += 0xe1b7 * zpow / ONE;
498         zpow = zpow * z / ONE;
499         result += 0x9c7 * zpow / ONE;
500         if (shift >= 0) {
501             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
502             return result << shift;
503         } else return result >> (-shift);
504     }
505 
506     
507     
508     
509     function ln(uint x) public pure returns (int) {
510         require(x > 0);
511         
512         int ilog2 = floorLog2(x);
513         int z;
514         if (ilog2 < 0) z = int(x << uint(-ilog2));
515         else z = int(x >> uint(ilog2));
516         
517         
518         
519         
520         
521         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
522         int halflnz = term;
523         int termpow = term * term / int(ONE) * term / int(ONE);
524         halflnz += termpow / 3;
525         termpow = termpow * term / int(ONE) * term / int(ONE);
526         halflnz += termpow / 5;
527         termpow = termpow * term / int(ONE) * term / int(ONE);
528         halflnz += termpow / 7;
529         termpow = termpow * term / int(ONE) * term / int(ONE);
530         halflnz += termpow / 9;
531         termpow = termpow * term / int(ONE) * term / int(ONE);
532         halflnz += termpow / 11;
533         termpow = termpow * term / int(ONE) * term / int(ONE);
534         halflnz += termpow / 13;
535         termpow = termpow * term / int(ONE) * term / int(ONE);
536         halflnz += termpow / 15;
537         termpow = termpow * term / int(ONE) * term / int(ONE);
538         halflnz += termpow / 17;
539         termpow = termpow * term / int(ONE) * term / int(ONE);
540         halflnz += termpow / 19;
541         termpow = termpow * term / int(ONE) * term / int(ONE);
542         halflnz += termpow / 21;
543         termpow = termpow * term / int(ONE) * term / int(ONE);
544         halflnz += termpow / 23;
545         termpow = termpow * term / int(ONE) * term / int(ONE);
546         halflnz += termpow / 25;
547         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
548     }
549 
550     
551     
552     
553     function floorLog2(uint x) public pure returns (int lo) {
554         lo = -64;
555         int hi = 193;
556         
557         int mid = (hi + lo) >> 1;
558         while ((lo + 1) < hi) {
559             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
560             else lo = mid;
561             mid = (hi + lo) >> 1;
562         }
563     }
564 
565     
566     
567     
568     function max(int[] memory nums) public pure returns (int maxNum) {
569         require(nums.length > 0);
570         maxNum = -2 ** 255;
571         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
572     }
573 
574     
575     
576     
577     
578     function safeToAdd(uint a, uint b) internal pure returns (bool) {
579         return a + b >= a;
580     }
581 
582     
583     
584     
585     
586     function safeToSub(uint a, uint b) internal pure returns (bool) {
587         return a >= b;
588     }
589 
590     
591     
592     
593     
594     function safeToMul(uint a, uint b) internal pure returns (bool) {
595         return b == 0 || a * b / b == a;
596     }
597 
598     
599     
600     
601     
602     function add(uint a, uint b) internal pure returns (uint) {
603         require(safeToAdd(a, b));
604         return a + b;
605     }
606 
607     
608     
609     
610     
611     function sub(uint a, uint b) internal pure returns (uint) {
612         require(safeToSub(a, b));
613         return a - b;
614     }
615 
616     
617     
618     
619     
620     function mul(uint a, uint b) internal pure returns (uint) {
621         require(safeToMul(a, b));
622         return a * b;
623     }
624 
625     
626     
627     
628     
629     function safeToAdd(int a, int b) internal pure returns (bool) {
630         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
631     }
632 
633     
634     
635     
636     
637     function safeToSub(int a, int b) internal pure returns (bool) {
638         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
639     }
640 
641     
642     
643     
644     
645     function safeToMul(int a, int b) internal pure returns (bool) {
646         return (b == 0) || (a * b / b == a);
647     }
648 
649     
650     
651     
652     
653     function add(int a, int b) internal pure returns (int) {
654         require(safeToAdd(a, b));
655         return a + b;
656     }
657 
658     
659     
660     
661     
662     function sub(int a, int b) internal pure returns (int) {
663         require(safeToSub(a, b));
664         return a - b;
665     }
666 
667     
668     
669     
670     
671     function mul(int a, int b) internal pure returns (int) {
672         require(safeToMul(a, b));
673         return a * b;
674     }
675 }
676 
677 contract Token {
678     
679     event Transfer(address indexed from, address indexed to, uint value);
680     event Approval(address indexed owner, address indexed spender, uint value);
681 
682     
683     function transfer(address to, uint value) public returns (bool);
684     function transferFrom(address from, address to, uint value) public returns (bool);
685     function approve(address spender, uint value) public returns (bool);
686     function balanceOf(address owner) public view returns (uint);
687     function allowance(address owner, address spender) public view returns (uint);
688     function totalSupply() public view returns (uint);
689 }
690 
691 contract Proxied {
692     address public masterCopy;
693 }
694 
695 contract Proxy is Proxied {
696     
697     
698     constructor(address _masterCopy) public {
699         require(_masterCopy != address(0), "The master copy is required");
700         masterCopy = _masterCopy;
701     }
702 
703     
704     function() external payable {
705         address _masterCopy = masterCopy;
706         assembly {
707             calldatacopy(0, 0, calldatasize)
708             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
709             returndatacopy(0, 0, returndatasize)
710             switch success
711                 case 0 {
712                     revert(0, returndatasize)
713                 }
714                 default {
715                     return(0, returndatasize)
716                 }
717         }
718     }
719 }
720 
721 contract StandardTokenData {
722     
723     mapping(address => uint) balances;
724     mapping(address => mapping(address => uint)) allowances;
725     uint totalTokens;
726 }
727 
728 contract GnosisStandardToken is Token, StandardTokenData {
729     using GnosisMath for *;
730 
731     
732     
733     
734     
735     
736     function transfer(address to, uint value) public returns (bool) {
737         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
738             return false;
739         }
740 
741         balances[msg.sender] -= value;
742         balances[to] += value;
743         emit Transfer(msg.sender, to, value);
744         return true;
745     }
746 
747     
748     
749     
750     
751     
752     function transferFrom(address from, address to, uint value) public returns (bool) {
753         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
754             value
755         ) || !balances[to].safeToAdd(value)) {
756             return false;
757         }
758         balances[from] -= value;
759         allowances[from][msg.sender] -= value;
760         balances[to] += value;
761         emit Transfer(from, to, value);
762         return true;
763     }
764 
765     
766     
767     
768     
769     function approve(address spender, uint value) public returns (bool) {
770         allowances[msg.sender][spender] = value;
771         emit Approval(msg.sender, spender, value);
772         return true;
773     }
774 
775     
776     
777     
778     
779     function allowance(address owner, address spender) public view returns (uint) {
780         return allowances[owner][spender];
781     }
782 
783     
784     
785     
786     function balanceOf(address owner) public view returns (uint) {
787         return balances[owner];
788     }
789 
790     
791     
792     function totalSupply() public view returns (uint) {
793         return totalTokens;
794     }
795 }
796 
797 contract TokenOWL is Proxied, GnosisStandardToken {
798     using GnosisMath for *;
799 
800     string public constant name = "OWL Token";
801     string public constant symbol = "OWL";
802     uint8 public constant decimals = 18;
803 
804     struct masterCopyCountdownType {
805         address masterCopy;
806         uint timeWhenAvailable;
807     }
808 
809     masterCopyCountdownType masterCopyCountdown;
810 
811     address public creator;
812     address public minter;
813 
814     event Minted(address indexed to, uint256 amount);
815     event Burnt(address indexed from, address indexed user, uint256 amount);
816 
817     modifier onlyCreator() {
818         
819         require(msg.sender == creator, "Only the creator can perform the transaction");
820         _;
821     }
822     
823     
824     function startMasterCopyCountdown(address _masterCopy) public onlyCreator {
825         require(address(_masterCopy) != address(0), "The master copy must be a valid address");
826 
827         
828         masterCopyCountdown.masterCopy = _masterCopy;
829         masterCopyCountdown.timeWhenAvailable = now + 30 days;
830     }
831 
832     
833     function updateMasterCopy() public onlyCreator {
834         require(address(masterCopyCountdown.masterCopy) != address(0), "The master copy must be a valid address");
835         require(
836             block.timestamp >= masterCopyCountdown.timeWhenAvailable,
837             "It's not possible to update the master copy during the waiting period"
838         );
839 
840         
841         masterCopy = masterCopyCountdown.masterCopy;
842     }
843 
844     function getMasterCopy() public view returns (address) {
845         return masterCopy;
846     }
847 
848     
849     
850     function setMinter(address newMinter) public onlyCreator {
851         minter = newMinter;
852     }
853 
854     
855     
856     function setNewOwner(address newOwner) public onlyCreator {
857         creator = newOwner;
858     }
859 
860     
861     
862     
863     function mintOWL(address to, uint amount) public {
864         require(minter != address(0), "The minter must be initialized");
865         require(msg.sender == minter, "Only the minter can mint OWL");
866         balances[to] = balances[to].add(amount);
867         totalTokens = totalTokens.add(amount);
868         emit Minted(to, amount);
869         emit Transfer(address(0), to, amount);
870     }
871 
872     
873     
874     
875     function burnOWL(address user, uint amount) public {
876         allowances[user][msg.sender] = allowances[user][msg.sender].sub(amount);
877         balances[user] = balances[user].sub(amount);
878         totalTokens = totalTokens.sub(amount);
879         emit Burnt(msg.sender, user, amount);
880         emit Transfer(user, address(0), amount);
881     }
882 
883     function getMasterCopyCountdown() public view returns (address, uint) {
884         return (masterCopyCountdown.masterCopy, masterCopyCountdown.timeWhenAvailable);
885     }
886 }
887 
888 library SafeCast {
889 
890     
891     function toUint128(uint256 value) internal pure returns (uint128) {
892         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
893         return uint128(value);
894     }
895 
896     
897     function toUint64(uint256 value) internal pure returns (uint64) {
898         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
899         return uint64(value);
900     }
901 
902     
903     function toUint32(uint256 value) internal pure returns (uint32) {
904         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
905         return uint32(value);
906     }
907 
908     
909     function toUint16(uint256 value) internal pure returns (uint16) {
910         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
911         return uint16(value);
912     }
913 
914     
915     function toUint8(uint256 value) internal pure returns (uint8) {
916         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
917         return uint8(value);
918     }
919 }
920 
921 library BytesLib {
922     function concat(
923         bytes memory _preBytes,
924         bytes memory _postBytes
925     )
926         internal
927         pure
928         returns (bytes memory)
929     {
930         bytes memory tempBytes;
931 
932         assembly {
933             
934             
935             tempBytes := mload(0x40)
936 
937             
938             
939             let length := mload(_preBytes)
940             mstore(tempBytes, length)
941 
942             
943             
944             
945             let mc := add(tempBytes, 0x20)
946             
947             
948             let end := add(mc, length)
949 
950             for {
951                 
952                 
953                 let cc := add(_preBytes, 0x20)
954             } lt(mc, end) {
955                 
956                 mc := add(mc, 0x20)
957                 cc := add(cc, 0x20)
958             } {
959                 
960                 
961                 mstore(mc, mload(cc))
962             }
963 
964             
965             
966             
967             length := mload(_postBytes)
968             mstore(tempBytes, add(length, mload(tempBytes)))
969 
970             
971             
972             mc := end
973             
974             
975             end := add(mc, length)
976 
977             for {
978                 let cc := add(_postBytes, 0x20)
979             } lt(mc, end) {
980                 mc := add(mc, 0x20)
981                 cc := add(cc, 0x20)
982             } {
983                 mstore(mc, mload(cc))
984             }
985 
986             
987             
988             
989             
990             
991             mstore(0x40, and(
992               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
993               not(31) 
994             ))
995         }
996 
997         return tempBytes;
998     }
999 
1000     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
1001         assembly {
1002             
1003             
1004             
1005             let fslot := sload(_preBytes_slot)
1006             
1007             
1008             
1009             
1010             
1011             
1012             
1013             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
1014             let mlength := mload(_postBytes)
1015             let newlength := add(slength, mlength)
1016             
1017             
1018             
1019             switch add(lt(slength, 32), lt(newlength, 32))
1020             case 2 {
1021                 
1022                 
1023                 
1024                 sstore(
1025                     _preBytes_slot,
1026                     
1027                     
1028                     add(
1029                         
1030                         
1031                         fslot,
1032                         add(
1033                             mul(
1034                                 div(
1035                                     
1036                                     mload(add(_postBytes, 0x20)),
1037                                     
1038                                     exp(0x100, sub(32, mlength))
1039                                 ),
1040                                 
1041                                 
1042                                 exp(0x100, sub(32, newlength))
1043                             ),
1044                             
1045                             
1046                             mul(mlength, 2)
1047                         )
1048                     )
1049                 )
1050             }
1051             case 1 {
1052                 
1053                 
1054                 
1055                 mstore(0x0, _preBytes_slot)
1056                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
1057 
1058                 
1059                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
1060 
1061                 
1062                 
1063                 
1064                 
1065                 
1066                 
1067                 
1068                 
1069 
1070                 let submod := sub(32, slength)
1071                 let mc := add(_postBytes, submod)
1072                 let end := add(_postBytes, mlength)
1073                 let mask := sub(exp(0x100, submod), 1)
1074 
1075                 sstore(
1076                     sc,
1077                     add(
1078                         and(
1079                             fslot,
1080                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
1081                         ),
1082                         and(mload(mc), mask)
1083                     )
1084                 )
1085 
1086                 for {
1087                     mc := add(mc, 0x20)
1088                     sc := add(sc, 1)
1089                 } lt(mc, end) {
1090                     sc := add(sc, 1)
1091                     mc := add(mc, 0x20)
1092                 } {
1093                     sstore(sc, mload(mc))
1094                 }
1095 
1096                 mask := exp(0x100, sub(mc, end))
1097 
1098                 sstore(sc, mul(div(mload(mc), mask), mask))
1099             }
1100             default {
1101                 
1102                 mstore(0x0, _preBytes_slot)
1103                 
1104                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
1105 
1106                 
1107                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
1108 
1109                 
1110                 
1111                 let slengthmod := mod(slength, 32)
1112                 let mlengthmod := mod(mlength, 32)
1113                 let submod := sub(32, slengthmod)
1114                 let mc := add(_postBytes, submod)
1115                 let end := add(_postBytes, mlength)
1116                 let mask := sub(exp(0x100, submod), 1)
1117 
1118                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
1119                 
1120                 for { 
1121                     sc := add(sc, 1)
1122                     mc := add(mc, 0x20)
1123                 } lt(mc, end) {
1124                     sc := add(sc, 1)
1125                     mc := add(mc, 0x20)
1126                 } {
1127                     sstore(sc, mload(mc))
1128                 }
1129 
1130                 mask := exp(0x100, sub(mc, end))
1131 
1132                 sstore(sc, mul(div(mload(mc), mask), mask))
1133             }
1134         }
1135     }
1136 
1137     function slice(
1138         bytes memory _bytes,
1139         uint _start,
1140         uint _length
1141     )
1142         internal
1143         pure
1144         returns (bytes memory)
1145     {
1146         require(_bytes.length >= (_start + _length));
1147 
1148         bytes memory tempBytes;
1149 
1150         assembly {
1151             switch iszero(_length)
1152             case 0 {
1153                 
1154                 
1155                 tempBytes := mload(0x40)
1156 
1157                 
1158                 
1159                 
1160                 
1161                 
1162                 
1163                 
1164                 
1165                 let lengthmod := and(_length, 31)
1166 
1167                 
1168                 
1169                 
1170                 
1171                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
1172                 let end := add(mc, _length)
1173 
1174                 for {
1175                     
1176                     
1177                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
1178                 } lt(mc, end) {
1179                     mc := add(mc, 0x20)
1180                     cc := add(cc, 0x20)
1181                 } {
1182                     mstore(mc, mload(cc))
1183                 }
1184 
1185                 mstore(tempBytes, _length)
1186 
1187                 
1188                 
1189                 mstore(0x40, and(add(mc, 31), not(31)))
1190             }
1191             
1192             default {
1193                 tempBytes := mload(0x40)
1194 
1195                 mstore(0x40, add(tempBytes, 0x20))
1196             }
1197         }
1198 
1199         return tempBytes;
1200     }
1201 
1202     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
1203         require(_bytes.length >= (_start + 20));
1204         address tempAddress;
1205 
1206         assembly {
1207             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
1208         }
1209 
1210         return tempAddress;
1211     }
1212 
1213     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
1214         require(_bytes.length >= (_start + 1));
1215         uint8 tempUint;
1216 
1217         assembly {
1218             tempUint := mload(add(add(_bytes, 0x1), _start))
1219         }
1220 
1221         return tempUint;
1222     }
1223 
1224     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
1225         require(_bytes.length >= (_start + 2));
1226         uint16 tempUint;
1227 
1228         assembly {
1229             tempUint := mload(add(add(_bytes, 0x2), _start))
1230         }
1231 
1232         return tempUint;
1233     }
1234 
1235     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
1236         require(_bytes.length >= (_start + 4));
1237         uint32 tempUint;
1238 
1239         assembly {
1240             tempUint := mload(add(add(_bytes, 0x4), _start))
1241         }
1242 
1243         return tempUint;
1244     }
1245 
1246     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
1247         require(_bytes.length >= (_start + 8));
1248         uint64 tempUint;
1249 
1250         assembly {
1251             tempUint := mload(add(add(_bytes, 0x8), _start))
1252         }
1253 
1254         return tempUint;
1255     }
1256 
1257     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
1258         require(_bytes.length >= (_start + 12));
1259         uint96 tempUint;
1260 
1261         assembly {
1262             tempUint := mload(add(add(_bytes, 0xc), _start))
1263         }
1264 
1265         return tempUint;
1266     }
1267 
1268     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
1269         require(_bytes.length >= (_start + 16));
1270         uint128 tempUint;
1271 
1272         assembly {
1273             tempUint := mload(add(add(_bytes, 0x10), _start))
1274         }
1275 
1276         return tempUint;
1277     }
1278 
1279     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
1280         require(_bytes.length >= (_start + 32));
1281         uint256 tempUint;
1282 
1283         assembly {
1284             tempUint := mload(add(add(_bytes, 0x20), _start))
1285         }
1286 
1287         return tempUint;
1288     }
1289 
1290     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
1291         require(_bytes.length >= (_start + 32));
1292         bytes32 tempBytes32;
1293 
1294         assembly {
1295             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
1296         }
1297 
1298         return tempBytes32;
1299     }
1300 
1301     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
1302         bool success = true;
1303 
1304         assembly {
1305             let length := mload(_preBytes)
1306 
1307             
1308             switch eq(length, mload(_postBytes))
1309             case 1 {
1310                 
1311                 
1312                 
1313                 
1314                 let cb := 1
1315 
1316                 let mc := add(_preBytes, 0x20)
1317                 let end := add(mc, length)
1318 
1319                 for {
1320                     let cc := add(_postBytes, 0x20)
1321                 
1322                 
1323                 } eq(add(lt(mc, end), cb), 2) {
1324                     mc := add(mc, 0x20)
1325                     cc := add(cc, 0x20)
1326                 } {
1327                     
1328                     if iszero(eq(mload(mc), mload(cc))) {
1329                         
1330                         success := 0
1331                         cb := 0
1332                     }
1333                 }
1334             }
1335             default {
1336                 
1337                 success := 0
1338             }
1339         }
1340 
1341         return success;
1342     }
1343 
1344     function equalStorage(
1345         bytes storage _preBytes,
1346         bytes memory _postBytes
1347     )
1348         internal
1349         view
1350         returns (bool)
1351     {
1352         bool success = true;
1353 
1354         assembly {
1355             
1356             let fslot := sload(_preBytes_slot)
1357             
1358             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
1359             let mlength := mload(_postBytes)
1360 
1361             
1362             switch eq(slength, mlength)
1363             case 1 {
1364                 
1365                 
1366                 
1367                 if iszero(iszero(slength)) {
1368                     switch lt(slength, 32)
1369                     case 1 {
1370                         
1371                         fslot := mul(div(fslot, 0x100), 0x100)
1372 
1373                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
1374                             
1375                             success := 0
1376                         }
1377                     }
1378                     default {
1379                         
1380                         
1381                         
1382                         
1383                         let cb := 1
1384 
1385                         
1386                         mstore(0x0, _preBytes_slot)
1387                         let sc := keccak256(0x0, 0x20)
1388 
1389                         let mc := add(_postBytes, 0x20)
1390                         let end := add(mc, mlength)
1391 
1392                         
1393                         
1394                         for {} eq(add(lt(mc, end), cb), 2) {
1395                             sc := add(sc, 1)
1396                             mc := add(mc, 0x20)
1397                         } {
1398                             if iszero(eq(sload(sc), mload(mc))) {
1399                                 
1400                                 success := 0
1401                                 cb := 0
1402                             }
1403                         }
1404                     }
1405                 }
1406             }
1407             default {
1408                 
1409                 success := 0
1410             }
1411         }
1412 
1413         return success;
1414     }
1415 }
1416 
1417 library SignedSafeMath {
1418     int256 constant private INT256_MIN = -2**255;
1419 
1420     
1421     function mul(int256 a, int256 b) internal pure returns (int256) {
1422         
1423         
1424         
1425         if (a == 0) {
1426             return 0;
1427         }
1428 
1429         require(!(a == -1 && b == INT256_MIN), "SignedSafeMath: multiplication overflow");
1430 
1431         int256 c = a * b;
1432         require(c / a == b, "SignedSafeMath: multiplication overflow");
1433 
1434         return c;
1435     }
1436 
1437     
1438     function div(int256 a, int256 b) internal pure returns (int256) {
1439         require(b != 0, "SignedSafeMath: division by zero");
1440         require(!(b == -1 && a == INT256_MIN), "SignedSafeMath: division overflow");
1441 
1442         int256 c = a / b;
1443 
1444         return c;
1445     }
1446 
1447     
1448     function sub(int256 a, int256 b) internal pure returns (int256) {
1449         int256 c = a - b;
1450         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
1451 
1452         return c;
1453     }
1454 
1455     
1456     function add(int256 a, int256 b) internal pure returns (int256) {
1457         int256 c = a + b;
1458         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
1459 
1460         return c;
1461     }
1462 }
1463 
1464 library TokenConservation {
1465     using SignedSafeMath for int256;
1466 
1467     
1468     function init(uint16[] memory tokenIdsForPrice) internal pure returns (int256[] memory) {
1469         return new int256[](tokenIdsForPrice.length + 1);
1470     }
1471 
1472     
1473     function feeTokenImbalance(int256[] memory self) internal pure returns (int256) {
1474         return self[0];
1475     }
1476 
1477     
1478     function updateTokenConservation(
1479         int256[] memory self,
1480         uint16 buyToken,
1481         uint16 sellToken,
1482         uint16[] memory tokenIdsForPrice,
1483         uint128 buyAmount,
1484         uint128 sellAmount
1485     ) internal pure {
1486         uint256 buyTokenIndex = findPriceIndex(buyToken, tokenIdsForPrice);
1487         uint256 sellTokenIndex = findPriceIndex(sellToken, tokenIdsForPrice);
1488         self[buyTokenIndex] = self[buyTokenIndex].sub(int256(buyAmount));
1489         self[sellTokenIndex] = self[sellTokenIndex].add(int256(sellAmount));
1490     }
1491 
1492     
1493     function checkTokenConservation(int256[] memory self) internal pure {
1494         require(self[0] > 0, "Token conservation at 0 must be positive.");
1495         for (uint256 i = 1; i < self.length; i++) {
1496             require(self[i] == 0, "Token conservation does not hold");
1497         }
1498     }
1499 
1500     
1501     function checkPriceOrdering(uint16[] memory tokenIdsForPrice) internal pure returns (bool) {
1502         for (uint256 i = 1; i < tokenIdsForPrice.length; i++) {
1503             if (tokenIdsForPrice[i] <= tokenIdsForPrice[i - 1]) {
1504                 return false;
1505             }
1506         }
1507         return true;
1508     }
1509 
1510     
1511     function findPriceIndex(uint16 tokenId, uint16[] memory tokenIdsForPrice) private pure returns (uint256) {
1512         
1513         if (tokenId == 0) {
1514             return 0;
1515         }
1516         
1517         uint256 leftValue = 0;
1518         uint256 rightValue = tokenIdsForPrice.length - 1;
1519         while (rightValue >= leftValue) {
1520             uint256 middleValue = (leftValue + rightValue) / 2;
1521             if (tokenIdsForPrice[middleValue] == tokenId) {
1522                 
1523                 return middleValue + 1;
1524             } else if (tokenIdsForPrice[middleValue] < tokenId) {
1525                 leftValue = middleValue + 1;
1526             } else {
1527                 rightValue = middleValue - 1;
1528             }
1529         }
1530         revert("Price not provided for token");
1531     }
1532 }
1533 
1534 contract BatchExchange is EpochTokenLocker {
1535     using SafeCast for uint256;
1536     using SafeMath for uint128;
1537     using BytesLib for bytes32;
1538     using BytesLib for bytes;
1539     using TokenConservation for int256[];
1540     using TokenConservation for uint16[];
1541     using IterableAppendOnlySet for IterableAppendOnlySet.Data;
1542 
1543     
1544     uint256 public constant MAX_TOUCHED_ORDERS = 25;
1545 
1546     
1547     uint256 public constant FEE_FOR_LISTING_TOKEN_IN_OWL = 10 ether;
1548 
1549     
1550     uint256 public constant AMOUNT_MINIMUM = 10**4;
1551 
1552     
1553     uint256 public constant IMPROVEMENT_DENOMINATOR = 100; 
1554 
1555     
1556     uint128 public constant FEE_DENOMINATOR = 1000;
1557 
1558     
1559     
1560     uint256 public MAX_TOKENS;
1561 
1562     
1563     uint16 public numTokens;
1564 
1565     
1566     TokenOWL public feeToken;
1567 
1568     
1569     mapping(address => Order[]) public orders;
1570 
1571     
1572     mapping(uint16 => uint128) public currentPrices;
1573 
1574     
1575     SolutionData public latestSolution;
1576 
1577     
1578     IterableAppendOnlySet.Data private allUsers;
1579     IdToAddressBiMap.Data private registeredTokens;
1580 
1581     struct Order {
1582         uint16 buyToken;
1583         uint16 sellToken;
1584         uint32 validFrom; 
1585         uint32 validUntil; 
1586         uint128 priceNumerator;
1587         uint128 priceDenominator;
1588         uint128 usedAmount; 
1589     }
1590 
1591     struct TradeData {
1592         address owner;
1593         uint128 volume;
1594         uint16 orderId;
1595     }
1596 
1597     struct SolutionData {
1598         uint32 batchId;
1599         TradeData[] trades;
1600         uint16[] tokenIdsForPrice;
1601         address solutionSubmitter;
1602         uint256 feeReward;
1603         uint256 objectiveValue;
1604     }
1605 
1606     event OrderPlacement(
1607         address indexed owner,
1608         uint16 index,
1609         uint16 indexed buyToken,
1610         uint16 indexed sellToken,
1611         uint32 validFrom,
1612         uint32 validUntil,
1613         uint128 priceNumerator,
1614         uint128 priceDenominator
1615     );
1616 
1617     
1618     event OrderCancelation(address indexed owner, uint256 id);
1619 
1620     
1621     event OrderDeletion(address indexed owner, uint256 id);
1622 
1623     
1624     event Trade(address indexed owner, uint16 indexed orderId, uint256 executedSellAmount, uint256 executedBuyAmount);
1625 
1626     
1627     event TradeReversion(address indexed owner, uint16 indexed orderId, uint256 executedSellAmount, uint256 executedBuyAmount);
1628 
1629     
1630     constructor(uint256 maxTokens, address _feeToken) public {
1631         
1632         
1633         currentPrices[0] = 1 ether;
1634         MAX_TOKENS = maxTokens;
1635         feeToken = TokenOWL(_feeToken);
1636         
1637         
1638         feeToken.approve(address(this), uint256(-1));
1639         addToken(_feeToken); 
1640     }
1641 
1642     
1643     function addToken(address token) public {
1644         require(numTokens < MAX_TOKENS, "Max tokens reached");
1645         if (numTokens > 0) {
1646             
1647             feeToken.burnOWL(msg.sender, FEE_FOR_LISTING_TOKEN_IN_OWL);
1648         }
1649         require(IdToAddressBiMap.insert(registeredTokens, numTokens, token), "Token already registered");
1650         numTokens++;
1651     }
1652 
1653     
1654     function placeOrder(uint16 buyToken, uint16 sellToken, uint32 validUntil, uint128 buyAmount, uint128 sellAmount)
1655         public
1656         returns (uint256)
1657     {
1658         return placeOrderInternal(buyToken, sellToken, getCurrentBatchId(), validUntil, buyAmount, sellAmount);
1659     }
1660 
1661     
1662     function placeValidFromOrders(
1663         uint16[] memory buyTokens,
1664         uint16[] memory sellTokens,
1665         uint32[] memory validFroms,
1666         uint32[] memory validUntils,
1667         uint128[] memory buyAmounts,
1668         uint128[] memory sellAmounts
1669     ) public returns (uint16[] memory orderIds) {
1670         orderIds = new uint16[](buyTokens.length);
1671         for (uint256 i = 0; i < buyTokens.length; i++) {
1672             orderIds[i] = placeOrderInternal(
1673                 buyTokens[i],
1674                 sellTokens[i],
1675                 validFroms[i],
1676                 validUntils[i],
1677                 buyAmounts[i],
1678                 sellAmounts[i]
1679             );
1680         }
1681     }
1682 
1683     
1684     function cancelOrders(uint16[] memory orderIds) public {
1685         uint32 batchIdBeingSolved = getCurrentBatchId() - 1;
1686         for (uint16 i = 0; i < orderIds.length; i++) {
1687             if (!checkOrderValidity(orders[msg.sender][orderIds[i]], batchIdBeingSolved)) {
1688                 delete orders[msg.sender][orderIds[i]];
1689                 emit OrderDeletion(msg.sender, orderIds[i]);
1690             } else {
1691                 orders[msg.sender][orderIds[i]].validUntil = batchIdBeingSolved;
1692                 emit OrderCancelation(msg.sender, orderIds[i]);
1693             }
1694         }
1695     }
1696 
1697     
1698     function replaceOrders(
1699         uint16[] memory cancellations,
1700         uint16[] memory buyTokens,
1701         uint16[] memory sellTokens,
1702         uint32[] memory validFroms,
1703         uint32[] memory validUntils,
1704         uint128[] memory buyAmounts,
1705         uint128[] memory sellAmounts
1706     ) public returns (uint16[] memory) {
1707         cancelOrders(cancellations);
1708         return placeValidFromOrders(buyTokens, sellTokens, validFroms, validUntils, buyAmounts, sellAmounts);
1709     }
1710 
1711     
1712     function submitSolution(
1713         uint32 batchId,
1714         uint256 claimedObjectiveValue,
1715         address[] memory owners,
1716         uint16[] memory orderIds,
1717         uint128[] memory buyVolumes,
1718         uint128[] memory prices,
1719         uint16[] memory tokenIdsForPrice
1720     ) public returns (uint256) {
1721         require(acceptingSolutions(batchId), "Solutions are no longer accepted for this batch");
1722         require(
1723             isObjectiveValueSufficientlyImproved(claimedObjectiveValue),
1724             "Claimed objective doesn't sufficiently improve current solution"
1725         );
1726         require(verifyAmountThreshold(prices), "At least one price lower than AMOUNT_MINIMUM");
1727         require(tokenIdsForPrice[0] != 0, "Fee token has fixed price!");
1728         require(tokenIdsForPrice.checkPriceOrdering(), "prices are not ordered by tokenId");
1729         require(owners.length <= MAX_TOUCHED_ORDERS, "Solution exceeds MAX_TOUCHED_ORDERS");
1730         
1731         
1732         
1733         
1734         burnPreviousAuctionFees();
1735         undoCurrentSolution();
1736         updateCurrentPrices(prices, tokenIdsForPrice);
1737         delete latestSolution.trades;
1738         int256[] memory tokenConservation = TokenConservation.init(tokenIdsForPrice);
1739         uint256 utility = 0;
1740         for (uint256 i = 0; i < owners.length; i++) {
1741             Order memory order = orders[owners[i]][orderIds[i]];
1742             require(checkOrderValidity(order, batchId), "Order is invalid");
1743             (uint128 executedBuyAmount, uint128 executedSellAmount) = getTradedAmounts(buyVolumes[i], order);
1744             require(executedBuyAmount >= AMOUNT_MINIMUM, "buy amount less than AMOUNT_MINIMUM");
1745             require(executedSellAmount >= AMOUNT_MINIMUM, "sell amount less than AMOUNT_MINIMUM");
1746             tokenConservation.updateTokenConservation(
1747                 order.buyToken,
1748                 order.sellToken,
1749                 tokenIdsForPrice,
1750                 executedBuyAmount,
1751                 executedSellAmount
1752             );
1753             require(getRemainingAmount(order) >= executedSellAmount, "executedSellAmount bigger than specified in order");
1754             
1755             
1756             require(
1757                 executedSellAmount.mul(order.priceNumerator) <= executedBuyAmount.mul(order.priceDenominator),
1758                 "limit price not satisfied"
1759             );
1760             
1761             utility = utility.add(evaluateUtility(executedBuyAmount, order));
1762             updateRemainingOrder(owners[i], orderIds[i], executedSellAmount);
1763             addBalanceAndBlockWithdrawForThisBatch(owners[i], tokenIdToAddressMap(order.buyToken), executedBuyAmount);
1764             emit Trade(owners[i], orderIds[i], executedSellAmount, executedBuyAmount);
1765         }
1766         
1767         for (uint256 i = 0; i < owners.length; i++) {
1768             Order memory order = orders[owners[i]][orderIds[i]];
1769             (, uint128 executedSellAmount) = getTradedAmounts(buyVolumes[i], order);
1770             subtractBalance(owners[i], tokenIdToAddressMap(order.sellToken), executedSellAmount);
1771         }
1772         uint256 disregardedUtility = 0;
1773         for (uint256 i = 0; i < owners.length; i++) {
1774             disregardedUtility = disregardedUtility.add(evaluateDisregardedUtility(orders[owners[i]][orderIds[i]], owners[i]));
1775         }
1776         uint256 burntFees = uint256(tokenConservation.feeTokenImbalance()) / 2;
1777         
1778         uint256 objectiveValue = utility.add(burntFees).sub(disregardedUtility);
1779         checkAndOverrideObjectiveValue(objectiveValue);
1780         grantRewardToSolutionSubmitter(burntFees);
1781         tokenConservation.checkTokenConservation();
1782         documentTrades(batchId, owners, orderIds, buyVolumes, tokenIdsForPrice);
1783         return (objectiveValue);
1784     }
1785     
1786 
1787     
1788     function tokenAddressToIdMap(address addr) public view returns (uint16) {
1789         return IdToAddressBiMap.getId(registeredTokens, addr);
1790     }
1791 
1792     
1793     function tokenIdToAddressMap(uint16 id) public view returns (address) {
1794         return IdToAddressBiMap.getAddressAt(registeredTokens, id);
1795     }
1796 
1797     
1798     function hasToken(address addr) public view returns (bool) {
1799         return IdToAddressBiMap.hasAddress(registeredTokens, addr);
1800     }
1801 
1802     
1803     function getEncodedUserOrdersPaginated(address user, uint16 offset, uint16 pageSize)
1804         public
1805         view
1806         returns (bytes memory elements)
1807     {
1808         for (uint16 i = offset; i < Math.min(orders[user].length, offset + pageSize); i++) {
1809             elements = elements.concat(
1810                 encodeAuctionElement(user, getBalance(user, tokenIdToAddressMap(orders[user][i].sellToken)), orders[user][i])
1811             );
1812         }
1813         return elements;
1814     }
1815 
1816     
1817     function getEncodedUserOrders(address user) public view returns (bytes memory elements) {
1818         return getEncodedUserOrdersPaginated(user, 0, uint16(-1));
1819     }
1820 
1821     
1822     function getEncodedOrders() public view returns (bytes memory elements) {
1823         if (allUsers.size() > 0) {
1824             address user = allUsers.first();
1825             bool stop = false;
1826             while (!stop) {
1827                 elements = elements.concat(getEncodedUserOrders(user));
1828                 if (user == allUsers.last) {
1829                     stop = true;
1830                 } else {
1831                     user = allUsers.next(user);
1832                 }
1833             }
1834         }
1835         return elements;
1836     }
1837 
1838     function acceptingSolutions(uint32 batchId) public view returns (bool) {
1839         return batchId == getCurrentBatchId() - 1 && getSecondsRemainingInBatch() >= 1 minutes;
1840     }
1841 
1842     
1843     function getCurrentObjectiveValue() public view returns (uint256) {
1844         if (latestSolution.batchId == getCurrentBatchId() - 1) {
1845             return latestSolution.objectiveValue;
1846         } else {
1847             return 0;
1848         }
1849     }
1850     
1851 
1852     function placeOrderInternal(
1853         uint16 buyToken,
1854         uint16 sellToken,
1855         uint32 validFrom,
1856         uint32 validUntil,
1857         uint128 buyAmount,
1858         uint128 sellAmount
1859     ) private returns (uint16) {
1860         require(buyToken != sellToken, "Exchange tokens not distinct");
1861         require(validFrom >= getCurrentBatchId(), "Orders can't be placed in the past");
1862         orders[msg.sender].push(
1863             Order({
1864                 buyToken: buyToken,
1865                 sellToken: sellToken,
1866                 validFrom: validFrom,
1867                 validUntil: validUntil,
1868                 priceNumerator: buyAmount,
1869                 priceDenominator: sellAmount,
1870                 usedAmount: 0
1871             })
1872         );
1873         uint16 orderId = (orders[msg.sender].length - 1).toUint16();
1874         emit OrderPlacement(msg.sender, orderId, buyToken, sellToken, validFrom, validUntil, buyAmount, sellAmount);
1875         allUsers.insert(msg.sender);
1876         return orderId;
1877     }
1878 
1879     
1880     function grantRewardToSolutionSubmitter(uint256 feeReward) private {
1881         latestSolution.feeReward = feeReward;
1882         addBalanceAndBlockWithdrawForThisBatch(msg.sender, tokenIdToAddressMap(0), feeReward);
1883     }
1884 
1885     
1886     function burnPreviousAuctionFees() private {
1887         if (!currentBatchHasSolution()) {
1888             feeToken.burnOWL(address(this), latestSolution.feeReward);
1889         }
1890     }
1891 
1892     
1893     function updateCurrentPrices(uint128[] memory prices, uint16[] memory tokenIdsForPrice) private {
1894         for (uint256 i = 0; i < latestSolution.tokenIdsForPrice.length; i++) {
1895             currentPrices[latestSolution.tokenIdsForPrice[i]] = 0;
1896         }
1897         for (uint256 i = 0; i < tokenIdsForPrice.length; i++) {
1898             currentPrices[tokenIdsForPrice[i]] = prices[i];
1899         }
1900     }
1901 
1902     
1903     function updateRemainingOrder(address owner, uint16 orderId, uint128 executedAmount) private {
1904         orders[owner][orderId].usedAmount = orders[owner][orderId].usedAmount.add(executedAmount).toUint128();
1905     }
1906 
1907     
1908     function revertRemainingOrder(address owner, uint16 orderId, uint128 executedAmount) private {
1909         orders[owner][orderId].usedAmount = orders[owner][orderId].usedAmount.sub(executedAmount).toUint128();
1910     }
1911 
1912     
1913     function documentTrades(
1914         uint32 batchId,
1915         address[] memory owners,
1916         uint16[] memory orderIds,
1917         uint128[] memory volumes,
1918         uint16[] memory tokenIdsForPrice
1919     ) private {
1920         latestSolution.batchId = batchId;
1921         for (uint256 i = 0; i < owners.length; i++) {
1922             latestSolution.trades.push(TradeData({owner: owners[i], orderId: orderIds[i], volume: volumes[i]}));
1923         }
1924         latestSolution.tokenIdsForPrice = tokenIdsForPrice;
1925         latestSolution.solutionSubmitter = msg.sender;
1926     }
1927 
1928     
1929     function undoCurrentSolution() private {
1930         if (currentBatchHasSolution()) {
1931             for (uint256 i = 0; i < latestSolution.trades.length; i++) {
1932                 address owner = latestSolution.trades[i].owner;
1933                 uint16 orderId = latestSolution.trades[i].orderId;
1934                 Order memory order = orders[owner][orderId];
1935                 (, uint128 sellAmount) = getTradedAmounts(latestSolution.trades[i].volume, order);
1936                 addBalance(owner, tokenIdToAddressMap(order.sellToken), sellAmount);
1937             }
1938             for (uint256 i = 0; i < latestSolution.trades.length; i++) {
1939                 address owner = latestSolution.trades[i].owner;
1940                 uint16 orderId = latestSolution.trades[i].orderId;
1941                 Order memory order = orders[owner][orderId];
1942                 (uint128 buyAmount, uint128 sellAmount) = getTradedAmounts(latestSolution.trades[i].volume, order);
1943                 revertRemainingOrder(owner, orderId, sellAmount);
1944                 subtractBalance(owner, tokenIdToAddressMap(order.buyToken), buyAmount);
1945                 emit TradeReversion(owner, orderId, sellAmount, buyAmount);
1946             }
1947             
1948             subtractBalance(latestSolution.solutionSubmitter, tokenIdToAddressMap(0), latestSolution.feeReward);
1949         }
1950     }
1951 
1952     
1953     function checkAndOverrideObjectiveValue(uint256 newObjectiveValue) private {
1954         require(
1955             isObjectiveValueSufficientlyImproved(newObjectiveValue),
1956             "New objective doesn't sufficiently improve current solution"
1957         );
1958         latestSolution.objectiveValue = newObjectiveValue;
1959     }
1960 
1961     
1962     
1963     function evaluateUtility(uint128 execBuy, Order memory order) private view returns (uint256) {
1964         
1965         uint256 execSellTimesBuy = getExecutedSellAmount(execBuy, currentPrices[order.buyToken], currentPrices[order.sellToken])
1966             .mul(order.priceNumerator);
1967 
1968         uint256 roundedUtility = execBuy.sub(execSellTimesBuy.div(order.priceDenominator)).mul(currentPrices[order.buyToken]);
1969         uint256 utilityError = execSellTimesBuy.mod(order.priceDenominator).mul(currentPrices[order.buyToken]).div(
1970             order.priceDenominator
1971         );
1972         return roundedUtility.sub(utilityError).toUint128();
1973     }
1974 
1975     
1976     function evaluateDisregardedUtility(Order memory order, address user) private view returns (uint256) {
1977         uint256 leftoverSellAmount = Math.min(getRemainingAmount(order), getBalance(user, tokenIdToAddressMap(order.sellToken)));
1978         uint256 limitTermLeft = currentPrices[order.sellToken].mul(order.priceDenominator);
1979         uint256 limitTermRight = order.priceNumerator.mul(currentPrices[order.buyToken]).mul(FEE_DENOMINATOR).div(
1980             FEE_DENOMINATOR - 1
1981         );
1982         uint256 limitTerm = 0;
1983         if (limitTermLeft > limitTermRight) {
1984             limitTerm = limitTermLeft.sub(limitTermRight);
1985         }
1986         return leftoverSellAmount.mul(limitTerm).div(order.priceDenominator).toUint128();
1987     }
1988 
1989     
1990     function getExecutedSellAmount(uint128 executedBuyAmount, uint128 buyTokenPrice, uint128 sellTokenPrice)
1991         private
1992         pure
1993         returns (uint128)
1994     {
1995         
1996         return
1997             uint256(executedBuyAmount)
1998                 .mul(buyTokenPrice)
1999                 .div(FEE_DENOMINATOR - 1)
2000                 .mul(FEE_DENOMINATOR)
2001                 .div(sellTokenPrice)
2002                 .toUint128();
2003         
2004     }
2005 
2006     
2007     function currentBatchHasSolution() private view returns (bool) {
2008         return latestSolution.batchId == getCurrentBatchId() - 1;
2009     }
2010 
2011     
2012     
2013     function getTradedAmounts(uint128 executedBuyAmount, Order memory order) private view returns (uint128, uint128) {
2014         uint128 executedSellAmount = getExecutedSellAmount(
2015             executedBuyAmount,
2016             currentPrices[order.buyToken],
2017             currentPrices[order.sellToken]
2018         );
2019         return (executedBuyAmount, executedSellAmount);
2020     }
2021 
2022     
2023     function isObjectiveValueSufficientlyImproved(uint256 objectiveValue) private view returns (bool) {
2024         return (objectiveValue.mul(IMPROVEMENT_DENOMINATOR) > getCurrentObjectiveValue().mul(IMPROVEMENT_DENOMINATOR + 1));
2025     }
2026 
2027     
2028     
2029     function checkOrderValidity(Order memory order, uint32 batchId) private pure returns (bool) {
2030         return order.validFrom <= batchId && order.validUntil >= batchId;
2031     }
2032 
2033     
2034     function getRemainingAmount(Order memory order) private pure returns (uint128) {
2035         return order.priceDenominator - order.usedAmount;
2036     }
2037 
2038     
2039     function encodeAuctionElement(address user, uint256 sellTokenBalance, Order memory order)
2040         private
2041         pure
2042         returns (bytes memory element)
2043     {
2044         element = abi.encodePacked(user);
2045         element = element.concat(abi.encodePacked(sellTokenBalance));
2046         element = element.concat(abi.encodePacked(order.buyToken));
2047         element = element.concat(abi.encodePacked(order.sellToken));
2048         element = element.concat(abi.encodePacked(order.validFrom));
2049         element = element.concat(abi.encodePacked(order.validUntil));
2050         element = element.concat(abi.encodePacked(order.priceNumerator));
2051         element = element.concat(abi.encodePacked(order.priceDenominator));
2052         element = element.concat(abi.encodePacked(getRemainingAmount(order)));
2053         return element;
2054     }
2055 
2056     
2057     function verifyAmountThreshold(uint128[] memory amounts) private pure returns (bool) {
2058         for (uint256 i = 0; i < amounts.length; i++) {
2059             if (amounts[i] < AMOUNT_MINIMUM) {
2060                 return false;
2061             }
2062         }
2063         return true;
2064     }
2065 }