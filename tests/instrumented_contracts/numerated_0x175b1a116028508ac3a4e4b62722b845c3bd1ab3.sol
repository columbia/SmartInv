1 // SPDX-License-Identifier: CC-BY-NC-SA-2.5
2 //@code0x2
3 
4 pragma solidity ^0.6.12;
5 
6 contract ContractGuard {
7     mapping(uint256 => mapping(address => bool)) private _status;
8 
9     function checkSameOriginReentranted() internal view returns (bool) {
10         return _status[block.number][tx.origin];
11     }
12 
13     function checkSameSenderReentranted() internal view returns (bool) {
14         return _status[block.number][msg.sender];
15     }
16 
17     modifier onlyOneBlock() {
18         require(
19             !checkSameOriginReentranted(),
20             'ContractGuard: one block, one function'
21         );
22         require(
23             !checkSameSenderReentranted(),
24             'ContractGuard: one block, one function'
25         );
26 
27         _;
28 
29         _status[block.number][tx.origin] = true;
30         _status[block.number][msg.sender] = true;
31     }
32 }
33 
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address payable) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes memory) {
40         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
41         return msg.data;
42     }
43 }
44 
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 contract Operator is Context, Ownable {
87     address private _operator;
88 
89     event OperatorTransferred(
90         address indexed previousOperator,
91         address indexed newOperator
92     );
93 
94     constructor() internal {
95         _operator = _msgSender();
96         emit OperatorTransferred(address(0), _operator);
97     }
98 
99     function operator() public view returns (address) {
100         return _operator;
101     }
102 
103     modifier onlyOperator() {
104         require(
105             _operator == msg.sender,
106             'operator: caller is not the operator'
107         );
108         _;
109     }
110 
111     function isOperator() public view returns (bool) {
112         return _msgSender() == _operator;
113     }
114 
115     function transferOperator(address newOperator_) public onlyOwner {
116         _transferOperator(newOperator_);
117     }
118 
119     function _transferOperator(address newOperator_) internal {
120         require(
121             newOperator_ != address(0),
122             'operator: zero address given for new operator'
123         );
124         emit OperatorTransferred(address(0), newOperator_);
125         _operator = newOperator_;
126     }
127 }
128 
129 library SafeMath {
130 
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return sub(a, b, "SafeMath: subtraction overflow");
139     }
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         return div(a, b, "SafeMath: division by zero");
161     }
162     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b > 0, errorMessage);
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167         return c;
168     }
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b != 0, errorMessage);
174         return a % b;
175     }
176 }
177 
178 library Address {
179     function isContract(address account) internal view returns (bool) {
180         // This method relies in extcodesize, which returns 0 for contracts in
181         // construction, since the code is only stored at the end of the
182         // constructor execution.
183 
184         uint256 size;
185         // solhint-disable-next-line no-inline-assembly
186         assembly { size := extcodesize(account) }
187         return size > 0;
188     }
189     function sendValue(address payable recipient, uint256 amount) internal {
190         require(address(this).balance >= amount, "Address: insufficient balance");
191 
192         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
193         (bool success, ) = recipient.call{ value: amount }("");
194         require(success, "Address: unable to send value, recipient may have reverted");
195     }
196     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
197       return functionCall(target, data, "Address: low-level call failed");
198     }
199     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
200         return _functionCallWithValue(target, data, 0, errorMessage);
201     }
202     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
204     }
205     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         return _functionCallWithValue(target, data, value, errorMessage);
208     }
209 
210     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
211         require(isContract(target), "Address: call to non-contract");
212 
213         // solhint-disable-next-line avoid-low-level-calls
214         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
215         if (success) {
216             return returndata;
217         } else {
218             // Look for revert reason and bubble it up if present
219             if (returndata.length > 0) {
220                 // The easiest way to bubble the revert reason is using memory via assembly
221 
222                 // solhint-disable-next-line no-inline-assembly
223                 assembly {
224                     let returndata_size := mload(returndata)
225                     revert(add(32, returndata), returndata_size)
226                 }
227             } else {
228                 revert(errorMessage);
229             }
230         }
231     }
232 }
233 
234 interface IERC20 {
235     function totalSupply() external view returns (uint256);
236     function balanceOf(address account) external view returns (uint256);
237     function transfer(address recipient, uint256 amount) external returns (bool);
238     function allowance(address owner, address spender) external view returns (uint256);
239     function approve(address spender, uint256 amount) external returns (bool);
240     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
241     event Transfer(address indexed from, address indexed to, uint256 value);
242     event Approval(address indexed owner, address indexed spender, uint256 value);
243 }
244 
245 interface ITreasury {
246     function getCurrentEpoch() external view returns (uint256);
247 }
248 
249 library SafeERC20 {
250     using SafeMath for uint256;
251     using Address for address;
252 
253     function safeTransfer(IERC20 token, address to, uint256 value) internal {
254         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
255     }
256 
257     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
258         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
259     }
260 
261     /**
262      * @dev Deprecated. This function has issues similar to the ones found in
263      * {IERC20-approve}, and its usage is discouraged.
264      *
265      * Whenever possible, use {safeIncreaseAllowance} and
266      * {safeDecreaseAllowance} instead.
267      */
268     function safeApprove(IERC20 token, address spender, uint256 value) internal {
269         // safeApprove should only be called when setting an initial allowance,
270         // or when resetting it to zero. To increase and decrease it, use
271         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
272         // solhint-disable-next-line max-line-length
273         require((value == 0) || (token.allowance(address(this), spender) == 0),
274             "SafeERC20: approve from non-zero to non-zero allowance"
275         );
276         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
277     }
278 
279     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
280         uint256 newAllowance = token.allowance(address(this), spender).add(value);
281         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
282     }
283 
284     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
285         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
286         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
287     }
288 
289     /**
290      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
291      * on the return value: the return value is optional (but if data is returned, it must not be false).
292      * @param token The token targeted by the call.
293      * @param data The call data (encoded using abi.encode or one of its variants).
294      */
295     function _callOptionalReturn(IERC20 token, bytes memory data) private {
296         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
297         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
298         // the target address contains contract code and also asserts for success in the low-level call.
299 
300         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
301         if (returndata.length > 0) { // Return data is optional
302             // solhint-disable-next-line max-line-length
303             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
304         }
305     }
306 }
307 
308 library Safe112 {
309     function add(uint112 a, uint112 b) internal pure returns (uint256) {
310         uint256 c = a + b;
311         require(c >= a, 'Safe112: addition overflow');
312 
313         return c;
314     }
315 
316     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
317         return sub(a, b, 'Safe112: subtraction overflow');
318     }
319 
320     function sub(
321         uint112 a,
322         uint112 b,
323         string memory errorMessage
324     ) internal pure returns (uint112) {
325         require(b <= a, errorMessage);
326         uint112 c = a - b;
327 
328         return c;
329     }
330 
331     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
332         if (a == 0) {
333             return 0;
334         }
335 
336         uint256 c = a * b;
337         require(c / a == b, 'Safe112: multiplication overflow');
338 
339         return c;
340     }
341 
342     function div(uint112 a, uint112 b) internal pure returns (uint256) {
343         return div(a, b, 'Safe112: division by zero');
344     }
345 
346     function div(
347         uint112 a,
348         uint112 b,
349         string memory errorMessage
350     ) internal pure returns (uint112) {
351         // Solidity only automatically asserts when dividing by 0
352         require(b > 0, errorMessage);
353         uint112 c = a / b;
354 
355         return c;
356     }
357 
358     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
359         return mod(a, b, 'Safe112: modulo by zero');
360     }
361 
362     function mod(
363         uint112 a,
364         uint112 b,
365         string memory errorMessage
366     ) internal pure returns (uint112) {
367         require(b != 0, errorMessage);
368         return a % b;
369     }
370 }
371 
372 contract ShareWrapper {
373     using SafeMath for uint256;
374     using SafeERC20 for IERC20;
375 
376     IERC20 public share;
377 
378     uint256 private _totalSupply;
379     mapping(address => uint256) private _balances;
380 
381     function totalSupply() public view returns (uint256) {
382         return _totalSupply;
383     }
384 
385     function balanceOf(address account) public view returns (uint256) {
386         return _balances[account];
387     }
388 
389     function stake(uint256 amount) public virtual {
390         _totalSupply = _totalSupply.add(amount);
391         _balances[msg.sender] = _balances[msg.sender].add(amount);
392         share.safeTransferFrom(msg.sender, address(this), amount);
393     }
394 
395     function withdraw(uint256 amount) public virtual {
396         uint256 directorShare = _balances[msg.sender];
397         require(
398             directorShare >= amount,
399             'Boardroom: withdraw request greater than staked amount'
400         );
401         _totalSupply = _totalSupply.sub(amount);
402         _balances[msg.sender] = directorShare.sub(amount);
403         share.safeTransfer(msg.sender, amount);
404     }
405 }
406 
407 contract dynamicBoardroom is ShareWrapper, ContractGuard, Operator {
408     using SafeERC20 for IERC20;
409     using Address for address;
410     using SafeMath for uint256;
411     using Safe112 for uint112;
412 
413     /* ========== DATA STRUCTURES ========== */
414 
415     struct Boardseat {
416         uint256 lastSnapshotIndex;
417         uint256 rewardEarned;
418     }
419 
420     struct BoardSnapshot {
421         uint256 time;
422         uint256 rewardReceived;
423         uint256 rewardPerShare;
424     }
425 
426     /* ========== STATE VARIABLES ========== */
427 
428     IERC20 public cash;
429 
430     mapping(address => Boardseat) private directors;
431     BoardSnapshot[] private boardHistory;
432     address payable internal creator;
433     uint256 public lockupEpochs;
434     mapping(address => uint256) public withdrawalEpoch;
435     address public treasury;
436 
437     /* ========== CONSTRUCTOR ========== */
438 
439     constructor(IERC20 _cash, IERC20 _share, uint256 _lockupEpochs) public {
440         cash = _cash;
441         share = _share;
442         lockupEpochs = _lockupEpochs;
443 
444         BoardSnapshot memory genesisSnapshot = BoardSnapshot({
445             time: block.number,
446             rewardReceived: 0,
447             rewardPerShare: 0
448         });
449         boardHistory.push(genesisSnapshot);
450 
451         creator = msg.sender;
452     }
453 
454     /* ========== Modifiers =============== */
455     modifier directorExists {
456         require(
457             balanceOf(msg.sender) > 0,
458             'Boardroom: The director does not exist'
459         );
460         _;
461     }
462 
463     modifier updateReward(address director) {
464         if (director != address(0)) {
465             Boardseat memory seat = directors[director];
466             seat.rewardEarned = earned(director);
467             seat.lastSnapshotIndex = latestSnapshotIndex();
468             directors[director] = seat;
469         }
470         _;
471     }
472 
473     modifier canWithdraw() {
474         require(withdrawalEpoch[msg.sender] <= ITreasury(treasury).getCurrentEpoch(), "Boardroom: Cannot withdraw yet");
475         _;
476     }
477 
478     /* ========== VIEW FUNCTIONS ========== */
479 
480     // =========== Snapshot getters
481 
482     function latestSnapshotIndex() public view returns (uint256) {
483         return boardHistory.length.sub(1);
484     }
485 
486     function getLatestSnapshot() internal view returns (BoardSnapshot memory) {
487         return boardHistory[latestSnapshotIndex()];
488     }
489 
490     function getLastSnapshotIndexOf(address director)
491         public
492         view
493         returns (uint256)
494     {
495         return directors[director].lastSnapshotIndex;
496     }
497 
498     function getLastSnapshotOf(address director)
499         internal
500         view
501         returns (BoardSnapshot memory)
502     {
503         return boardHistory[getLastSnapshotIndexOf(director)];
504     }
505 
506     // =========== Director getters
507 
508     function rewardPerShare() public view returns (uint256) {
509         return getLatestSnapshot().rewardPerShare;
510     }
511 
512     function earned(address director) public view returns (uint256) {
513         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
514         uint256 storedRPS = getLastSnapshotOf(director).rewardPerShare;
515 
516         return
517             balanceOf(director).mul(latestRPS.sub(storedRPS)).div(1e18).add(
518                 directors[director].rewardEarned
519             );
520     }
521 
522     /* ========== MUTATIVE FUNCTIONS ========== */
523 
524     function setNewTreasury(address _treasury) public onlyOperator {
525         treasury = _treasury;
526     }
527 
528     function setLockupEpochs(uint256 _epochs) public onlyOperator {
529         require(_epochs <= 8, "Boardroom: Epoch lock exceeds hardcap.");
530         lockupEpochs = _epochs;
531     }
532 
533     function stake(uint256 amount)
534         public
535         override
536         onlyOneBlock
537         updateReward(msg.sender)
538     {
539         require(amount > 0, 'Boardroom: Cannot stake 0');
540         super.stake(amount);
541         withdrawalEpoch[msg.sender] = lockupEpochs.add(ITreasury(treasury).getCurrentEpoch());
542         emit Staked(msg.sender, amount);
543     }
544 
545     function withdraw(uint256 amount)
546         public
547         override
548         onlyOneBlock
549         directorExists
550         updateReward(msg.sender)
551         canWithdraw
552     {
553         require(amount > 0, 'Boardroom: Cannot withdraw 0');
554         super.withdraw(amount);
555         emit Withdrawn(msg.sender, amount);
556     }
557 
558     function exit() external {
559         withdraw(balanceOf(msg.sender));
560         claimReward();
561     }
562 
563     function claimReward() public updateReward(msg.sender) canWithdraw {
564         uint256 reward = directors[msg.sender].rewardEarned;
565         if (reward > 0) {
566             directors[msg.sender].rewardEarned = 0;
567             cash.safeTransfer(msg.sender, reward);
568             emit RewardPaid(msg.sender, reward);
569         }
570     }
571 
572     function allocateSeigniorage(uint256 amount)
573         external
574         onlyOneBlock
575         onlyOperator
576     {
577         require(amount > 0, 'Boardroom: Cannot allocate 0');
578         require(
579             totalSupply() > 0,
580             'Boardroom: Cannot allocate when totalSupply is 0'
581         );
582 
583         // Create & add new snapshot
584         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
585         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(totalSupply()));
586 
587         BoardSnapshot memory newSnapshot = BoardSnapshot({
588             time: block.number,
589             rewardReceived: amount,
590             rewardPerShare: nextRPS
591         });
592         boardHistory.push(newSnapshot);
593 
594         cash.safeTransferFrom(msg.sender, address(this), amount);
595         emit RewardAdded(msg.sender, amount);
596     }
597 
598     /* ========== EVENTS ========== */
599 
600     event Staked(address indexed user, uint256 amount);
601     event Withdrawn(address indexed user, uint256 amount);
602     event RewardPaid(address indexed user, uint256 reward);
603     event RewardAdded(address indexed user, uint256 reward);
604 
605     // Fallback rescue
606 
607     receive() external payable{
608         creator.transfer(msg.value);
609     }
610 }