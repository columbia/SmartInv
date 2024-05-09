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
245 library SafeERC20 {
246     using SafeMath for uint256;
247     using Address for address;
248 
249     function safeTransfer(IERC20 token, address to, uint256 value) internal {
250         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
251     }
252 
253     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
254         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
255     }
256 
257     /**
258      * @dev Deprecated. This function has issues similar to the ones found in
259      * {IERC20-approve}, and its usage is discouraged.
260      *
261      * Whenever possible, use {safeIncreaseAllowance} and
262      * {safeDecreaseAllowance} instead.
263      */
264     function safeApprove(IERC20 token, address spender, uint256 value) internal {
265         // safeApprove should only be called when setting an initial allowance,
266         // or when resetting it to zero. To increase and decrease it, use
267         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
268         // solhint-disable-next-line max-line-length
269         require((value == 0) || (token.allowance(address(this), spender) == 0),
270             "SafeERC20: approve from non-zero to non-zero allowance"
271         );
272         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
273     }
274 
275     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
276         uint256 newAllowance = token.allowance(address(this), spender).add(value);
277         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
278     }
279 
280     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
281         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
282         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
283     }
284 
285     /**
286      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
287      * on the return value: the return value is optional (but if data is returned, it must not be false).
288      * @param token The token targeted by the call.
289      * @param data The call data (encoded using abi.encode or one of its variants).
290      */
291     function _callOptionalReturn(IERC20 token, bytes memory data) private {
292         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
293         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
294         // the target address contains contract code and also asserts for success in the low-level call.
295 
296         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
297         if (returndata.length > 0) { // Return data is optional
298             // solhint-disable-next-line max-line-length
299             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
300         }
301     }
302 }
303 
304 library Safe112 {
305     function add(uint112 a, uint112 b) internal pure returns (uint256) {
306         uint256 c = a + b;
307         require(c >= a, 'Safe112: addition overflow');
308 
309         return c;
310     }
311 
312     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
313         return sub(a, b, 'Safe112: subtraction overflow');
314     }
315 
316     function sub(
317         uint112 a,
318         uint112 b,
319         string memory errorMessage
320     ) internal pure returns (uint112) {
321         require(b <= a, errorMessage);
322         uint112 c = a - b;
323 
324         return c;
325     }
326 
327     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
328         if (a == 0) {
329             return 0;
330         }
331 
332         uint256 c = a * b;
333         require(c / a == b, 'Safe112: multiplication overflow');
334 
335         return c;
336     }
337 
338     function div(uint112 a, uint112 b) internal pure returns (uint256) {
339         return div(a, b, 'Safe112: division by zero');
340     }
341 
342     function div(
343         uint112 a,
344         uint112 b,
345         string memory errorMessage
346     ) internal pure returns (uint112) {
347         // Solidity only automatically asserts when dividing by 0
348         require(b > 0, errorMessage);
349         uint112 c = a / b;
350 
351         return c;
352     }
353 
354     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
355         return mod(a, b, 'Safe112: modulo by zero');
356     }
357 
358     function mod(
359         uint112 a,
360         uint112 b,
361         string memory errorMessage
362     ) internal pure returns (uint112) {
363         require(b != 0, errorMessage);
364         return a % b;
365     }
366 }
367 
368 contract ShareWrapper {
369     using SafeMath for uint256;
370     using SafeERC20 for IERC20;
371 
372     IERC20 public share;
373 
374     uint256 private _totalSupply;
375     mapping(address => uint256) private _balances;
376 
377     function totalSupply() public view returns (uint256) {
378         return _totalSupply;
379     }
380 
381     function balanceOf(address account) public view returns (uint256) {
382         return _balances[account];
383     }
384 
385     function stake(uint256 amount) public virtual {
386         _totalSupply = _totalSupply.add(amount);
387         _balances[msg.sender] = _balances[msg.sender].add(amount);
388         share.safeTransferFrom(msg.sender, address(this), amount);
389     }
390 
391     function withdraw(uint256 amount) public virtual {
392         uint256 directorShare = _balances[msg.sender];
393         require(
394             directorShare >= amount,
395             'Boardroom: withdraw request greater than staked amount'
396         );
397         _totalSupply = _totalSupply.sub(amount);
398         _balances[msg.sender] = directorShare.sub(amount);
399         share.safeTransfer(msg.sender, amount);
400     }
401 }
402 
403 contract dynamicBoardroom is ShareWrapper, ContractGuard, Operator {
404     using SafeERC20 for IERC20;
405     using Address for address;
406     using SafeMath for uint256;
407     using Safe112 for uint112;
408 
409     /* ========== DATA STRUCTURES ========== */
410 
411     struct Boardseat {
412         uint256 lastSnapshotIndex;
413         uint256 rewardEarned;
414     }
415 
416     struct BoardSnapshot {
417         uint256 time;
418         uint256 rewardReceived;
419         uint256 rewardPerShare;
420     }
421 
422     /* ========== STATE VARIABLES ========== */
423 
424     IERC20 private cash;
425 
426     mapping(address => Boardseat) private directors;
427     BoardSnapshot[] private boardHistory;
428     address payable internal creator;
429 
430     /* ========== CONSTRUCTOR ========== */
431 
432     constructor(IERC20 _cash, IERC20 _share) public {
433         cash = _cash;
434         share = _share;
435 
436         BoardSnapshot memory genesisSnapshot = BoardSnapshot({
437             time: block.number,
438             rewardReceived: 0,
439             rewardPerShare: 0
440         });
441         boardHistory.push(genesisSnapshot);
442 
443         creator = msg.sender;
444     }
445 
446     /* ========== Modifiers =============== */
447     modifier directorExists {
448         require(
449             balanceOf(msg.sender) > 0,
450             'Boardroom: The director does not exist'
451         );
452         _;
453     }
454 
455     modifier updateReward(address director) {
456         if (director != address(0)) {
457             Boardseat memory seat = directors[director];
458             seat.rewardEarned = earned(director);
459             seat.lastSnapshotIndex = latestSnapshotIndex();
460             directors[director] = seat;
461         }
462         _;
463     }
464 
465     /* ========== VIEW FUNCTIONS ========== */
466 
467     // =========== Snapshot getters
468 
469     function latestSnapshotIndex() public view returns (uint256) {
470         return boardHistory.length.sub(1);
471     }
472 
473     function getLatestSnapshot() internal view returns (BoardSnapshot memory) {
474         return boardHistory[latestSnapshotIndex()];
475     }
476 
477     function getLastSnapshotIndexOf(address director)
478         public
479         view
480         returns (uint256)
481     {
482         return directors[director].lastSnapshotIndex;
483     }
484 
485     function getLastSnapshotOf(address director)
486         internal
487         view
488         returns (BoardSnapshot memory)
489     {
490         return boardHistory[getLastSnapshotIndexOf(director)];
491     }
492 
493     // =========== Director getters
494 
495     function rewardPerShare() public view returns (uint256) {
496         return getLatestSnapshot().rewardPerShare;
497     }
498 
499     function earned(address director) public view returns (uint256) {
500         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
501         uint256 storedRPS = getLastSnapshotOf(director).rewardPerShare;
502 
503         return
504             balanceOf(director).mul(latestRPS.sub(storedRPS)).div(1e18).add(
505                 directors[director].rewardEarned
506             );
507     }
508 
509     /* ========== MUTATIVE FUNCTIONS ========== */
510 
511     function stake(uint256 amount)
512         public
513         override
514         onlyOneBlock
515         updateReward(msg.sender)
516     {
517         require(amount > 0, 'Boardroom: Cannot stake 0');
518         super.stake(amount);
519         emit Staked(msg.sender, amount);
520     }
521 
522     function withdraw(uint256 amount)
523         public
524         override
525         onlyOneBlock
526         directorExists
527         updateReward(msg.sender)
528     {
529         require(amount > 0, 'Boardroom: Cannot withdraw 0');
530         super.withdraw(amount);
531         emit Withdrawn(msg.sender, amount);
532     }
533 
534     function exit() external {
535         withdraw(balanceOf(msg.sender));
536         claimReward();
537     }
538 
539     function claimReward() public updateReward(msg.sender) {
540         uint256 reward = directors[msg.sender].rewardEarned;
541         if (reward > 0) {
542             directors[msg.sender].rewardEarned = 0;
543             cash.safeTransfer(msg.sender, reward);
544             emit RewardPaid(msg.sender, reward);
545         }
546     }
547 
548     function allocateSeigniorage(uint256 amount)
549         external
550         onlyOneBlock
551         onlyOperator
552     {
553         require(amount > 0, 'Boardroom: Cannot allocate 0');
554         require(
555             totalSupply() > 0,
556             'Boardroom: Cannot allocate when totalSupply is 0'
557         );
558 
559         // Create & add new snapshot
560         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
561         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(totalSupply()));
562 
563         BoardSnapshot memory newSnapshot = BoardSnapshot({
564             time: block.number,
565             rewardReceived: amount,
566             rewardPerShare: nextRPS
567         });
568         boardHistory.push(newSnapshot);
569 
570         cash.safeTransferFrom(msg.sender, address(this), amount);
571         emit RewardAdded(msg.sender, amount);
572     }
573 
574     /* ========== EVENTS ========== */
575 
576     event Staked(address indexed user, uint256 amount);
577     event Withdrawn(address indexed user, uint256 amount);
578     event RewardPaid(address indexed user, uint256 reward);
579     event RewardAdded(address indexed user, uint256 reward);
580 
581     // Fallback rescue
582 
583     receive() external payable{
584         creator.transfer(msg.value);
585     }
586 }