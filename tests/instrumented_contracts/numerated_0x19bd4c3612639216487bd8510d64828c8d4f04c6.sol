1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.5;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor() internal {
25         address msgSender = _msgSender();
26         _owner = msgSender;
27         emit OwnershipTransferred(address(0), msgSender);
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         emit OwnershipTransferred(_owner, newOwner);
64         _owner = newOwner;
65     }
66 }
67 
68 library SafeMath {
69 
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73         return c;
74     }
75 
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b <= a, "SafeMath: subtraction overflow");
78         return a - b;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) return 0;
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b > 0, "SafeMath: division by zero");
90         return a / b;
91     }
92 
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         require(b > 0, "SafeMath: modulo by zero");
95         return a % b;
96     }
97 
98     function sub(
99         uint256 a,
100         uint256 b,
101         string memory errorMessage
102     ) internal pure returns (uint256) {
103         require(b <= a, errorMessage);
104         return a - b;
105     }
106 
107     function div(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         return a / b;
114     }
115 
116     function mod(
117         uint256 a,
118         uint256 b,
119         string memory errorMessage
120     ) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         return a % b;
123     }
124 }
125 
126 abstract contract ReentrancyGuard {
127 
128     uint256 private constant _NOT_ENTERED = 1;
129     uint256 private constant _ENTERED = 2;
130 
131     uint256 private _status;
132 
133     constructor() internal {
134         _status = _NOT_ENTERED;
135     }
136 
137     modifier nonReentrant() {
138         // On the first call to nonReentrant, _notEntered will be true
139         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
140 
141         // Any calls to nonReentrant after this point will fail
142         _status = _ENTERED;
143 
144         _;
145 
146         // By storing the original value once again, a refund is triggered (see
147         // https://eips.ethereum.org/EIPS/eip-2200)
148         _status = _NOT_ENTERED;
149     }
150 }
151 
152 interface IERC20 {
153     function transfer(address recipient, uint256 amount) external returns (bool);
154 
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160 
161 }
162 
163 library Address {
164     /**
165      * @dev Returns true if `account` is a contract.
166      *
167      * [IMPORTANT]
168      * ====
169      * It is unsafe to assume that an address for which this function returns
170      * false is an externally-owned account (EOA) and not a contract.
171      *
172      * Among others, `isContract` will return false for the following
173      * types of addresses:
174      *
175      *  - an externally-owned account
176      *  - a contract in construction
177      *  - an address where a contract will be created
178      *  - an address where a contract lived, but was destroyed
179      * ====
180      */
181     function isContract(address account) internal view returns (bool) {
182         // This method relies on extcodesize, which returns 0 for contracts in
183         // construction, since the code is only stored at the end of the
184         // constructor execution.
185 
186         uint256 size;
187         // solhint-disable-next-line no-inline-assembly
188         assembly {
189             size := extcodesize(account)
190         }
191         return size > 0;
192     }
193 
194     /**
195      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
196      * `recipient`, forwarding all available gas and reverting on errors.
197      *
198      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
199      * of certain opcodes, possibly making contracts go over the 2300 gas limit
200      * imposed by `transfer`, making them unable to receive funds via
201      * `transfer`. {sendValue} removes this limitation.
202      *
203      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
204      *
205      * IMPORTANT: because control is transferred to `recipient`, care must be
206      * taken to not create reentrancy vulnerabilities. Consider using
207      * {ReentrancyGuard} or the
208      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
209      */
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
214         (bool success, ) = recipient.call{value: amount}("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain`call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237         return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, 0, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but also transferring `value` wei to `target`.
257      *
258      * Requirements:
259      *
260      * - the calling contract must have an ETH balance of at least `value`.
261      * - the called Solidity function must be `payable`.
262      *
263      * _Available since v3.1._
264      */
265     function functionCallWithValue(
266         address target,
267         bytes memory data,
268         uint256 value
269     ) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
275      * with `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(
280         address target,
281         bytes memory data,
282         uint256 value,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         require(address(this).balance >= value, "Address: insufficient balance for call");
286         require(isContract(target), "Address: call to non-contract");
287 
288         // solhint-disable-next-line avoid-low-level-calls
289         (bool success, bytes memory returndata) = target.call{value: value}(data);
290         return _verifyCallResult(success, returndata, errorMessage);
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but performing a static call.
296      *
297      * _Available since v3.3._
298      */
299     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
300         return functionStaticCall(target, data, "Address: low-level static call failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
305      * but performing a static call.
306      *
307      * _Available since v3.3._
308      */
309     function functionStaticCall(
310         address target,
311         bytes memory data,
312         string memory errorMessage
313     ) internal view returns (bytes memory) {
314         require(isContract(target), "Address: static call to non-contract");
315 
316         // solhint-disable-next-line avoid-low-level-calls
317         (bool success, bytes memory returndata) = target.staticcall(data);
318         return _verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a delegate call.
324      *
325      * _Available since v3.4._
326      */
327     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a delegate call.
334      *
335      * _Available since v3.4._
336      */
337     function functionDelegateCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         require(isContract(target), "Address: delegate call to non-contract");
343 
344         // solhint-disable-next-line avoid-low-level-calls
345         (bool success, bytes memory returndata) = target.delegatecall(data);
346         return _verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     function _verifyCallResult(
350         bool success,
351         bytes memory returndata,
352         string memory errorMessage
353     ) private pure returns (bytes memory) {
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 library SafeERC20 {
374     using SafeMath for uint256;
375     using Address for address;
376 
377     function safeTransfer(
378         IERC20 token,
379         address to,
380         uint256 value
381     ) internal {
382         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
383     }
384 
385     function safeTransferFrom(
386         IERC20 token,
387         address from,
388         address to,
389         uint256 value
390     ) internal {
391         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
392     }
393 
394     function _callOptionalReturn(IERC20 token, bytes memory data) private {
395         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
396         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
397         // the target address contains contract code and also asserts for success in the low-level call.
398 
399         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
400         if (returndata.length > 0) {
401             // Return data is optional
402             // solhint-disable-next-line max-line-length
403             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
404         }
405     }
406 }
407 
408 contract PhantomStaking is Ownable, ReentrancyGuard {
409     using SafeMath for uint256;
410     using SafeERC20 for IERC20;
411 
412     uint256 public rewardsEndTimestamp;
413     uint256 public rewardsStartTimestamp;
414 
415     mapping(uint256 => StakingProgram) public programs;
416     uint256 public _currentProgramID;
417 
418     uint256 public earlyWithdrawalTax = 250; // 1000 is 100%
419 
420     mapping(uint256 => uint256) public stakedAmounts; // how much is staked per each program
421 
422     IERC20 public principleToken; //used for both staking and rewards
423 
424     mapping(address => mapping (uint256 => UserInfo)) public userInfo;
425 
426     struct UserInfo {
427         uint256 amount; // amount staked
428         uint256 annualPayout; // amount to be paid out annually
429         uint256 lastClaimed; // timestamp when last claimed or deposit creation time
430         uint256 lockExpiration; // when deposited tokens can be paid back without penalty
431     }
432 
433     struct StakingProgram {
434       uint256 programID; // unique program ID
435       uint256 annualRate; // 100000 is 100%
436       uint256 lockDuration; // lock duration in seconds. Withdrawals before lock expiration face early withdrawal tax
437       bool enabled; // whether new deposits can be made into this program
438     }
439 
440     event Deposit(address indexed user, uint256 amount);
441     event Withdraw(address indexed user, uint256 amount);
442 
443     constructor(address _token, uint256 _rewardsStartTimestamp, uint256 _rewardsEndTimestamp) public {
444         require(_rewardsEndTimestamp > _rewardsStartTimestamp);
445         principleToken = IERC20(_token);
446         rewardsStartTimestamp = _rewardsStartTimestamp;
447         rewardsEndTimestamp = _rewardsEndTimestamp;
448     }
449 
450     function setupStakingTime(uint256 _startTimestamp, uint256 _endTimestamp) public onlyOwner {
451         if (_startTimestamp != rewardsStartTimestamp) {
452           require(block.timestamp < rewardsStartTimestamp, "Pool has started");
453           require(block.timestamp < _startTimestamp, "New start timestamp must be higher than current timestamp");
454         }
455 
456         require(_startTimestamp < _endTimestamp, "New start timestamp must be lower than new end timestamp");
457         require(_endTimestamp > block.timestamp, "New end timestamp must be higher than current timestamp");
458 
459         rewardsStartTimestamp = _startTimestamp;
460         rewardsEndTimestamp = _endTimestamp;
461     }
462 
463     function setupEarlyWithdrawalTax(uint256 _earlyTax) public onlyOwner {
464         require(_earlyTax < 1000, "Cannot exceed 100%");
465         earlyWithdrawalTax = _earlyTax;
466     }
467 
468     function addStakingPrograms(uint256[] memory _rates, uint256[] memory _durations) public onlyOwner {
469         require(_rates.length == _durations.length, "Incorrect input");
470         require(_rates.length > 0, "No programs to add");
471 
472         for (uint i = 0; i < _rates.length; i++) {
473           require(_durations[i] > 0, "Duration must be greater than 0");
474           programs[_currentProgramID] = StakingProgram({
475             programID: _currentProgramID,
476             annualRate: _rates[i],
477             lockDuration: _durations[i],
478             enabled: true
479           });
480           _currentProgramID++;
481         }
482     }
483 
484     function toggleStakingPrograms(uint256[] memory _programIDs, bool _enabled) public onlyOwner {
485         require(_programIDs.length > 0, "No programs to toggle");
486         for (uint i = 0; i < _programIDs.length; i++) {
487           require(_programIDs[i] < _currentProgramID, "No such program ID");
488           programs[_programIDs[i]].enabled = _enabled;
489         }
490     }
491 
492     function deposit(uint256 _amount, uint256 _programID) external nonReentrant {
493         require(_programID < _currentProgramID, "Program ID does not exist");
494         require(_amount > 0, "Deposit must be higher than 0");
495         require(programs[_programID].enabled, "Program does not accept any more deposits");
496 
497         UserInfo storage user = userInfo[msg.sender][_programID];
498         principleToken.safeTransferFrom(msg.sender, address(this), _amount);
499         stakedAmounts[_programID] = stakedAmounts[_programID].add(_amount);
500 
501         if (user.lastClaimed > 0) _harvestRewards(msg.sender, _programID, true);
502 
503         user.amount = user.amount.add(_amount);
504         user.annualPayout = user.amount.mul(programs[_programID].annualRate).div(100000);
505         user.lastClaimed = block.timestamp;
506 
507         if (user.lockExpiration == 0 || user.lockExpiration < block.timestamp) {
508           user.lockExpiration = block.timestamp + programs[_programID].lockDuration;
509         }
510 
511         emit Deposit(msg.sender, _amount);
512     }
513 
514     function harvestRewards(uint256 _programID, bool reinvest) external nonReentrant {
515 
516         uint256 pending = pendingRewardPerProgram(msg.sender, _programID);
517         require(pending > 0, "No reward to harvest");
518         if (!reinvest) principleToken.safeTransfer(msg.sender, pending);
519 
520         _harvestRewards(msg.sender, _programID, reinvest);
521     }
522 
523     function _harvestRewards(address _address, uint256 _programID, bool reinvest) internal {
524         UserInfo storage user = userInfo[_address][_programID];
525         if (reinvest) {
526           uint256 _pendingRewardProgram = pendingRewardPerProgram(_address, _programID);
527           user.amount = user.amount.add(_pendingRewardProgram);
528           user.annualPayout = user.amount.mul(programs[_programID].annualRate).div(100000);
529           stakedAmounts[_programID] = stakedAmounts[_programID].add(_pendingRewardProgram);
530         }
531         user.lastClaimed = block.timestamp;
532     }
533 
534     function withdraw(uint256 _amount, uint256 _programID, bool _withReward) external nonReentrant {
535         UserInfo storage user = userInfo[msg.sender][_programID];
536         require(_programID < _currentProgramID, "Program ID does not exist");
537         require(user.amount >= _amount, "Amount to withdraw too high");
538 
539         uint256 pending = pendingRewardPerProgram(msg.sender, _programID);
540 
541         user.amount = user.amount.sub(_amount);
542         uint256 withdrawnAmount = _amount;
543         if (user.lockExpiration > block.timestamp) {
544           withdrawnAmount = withdrawnAmount.mul(1000 - earlyWithdrawalTax).div(1000);
545         }
546         principleToken.safeTransfer(msg.sender, withdrawnAmount);
547         stakedAmounts[_programID] = stakedAmounts[_programID].sub(_amount);
548 
549         if (pending > 0 && _withReward) {
550             principleToken.safeTransfer(msg.sender, pending);
551         }
552 
553         user.lastClaimed = block.timestamp;
554         user.annualPayout = user.amount.mul(programs[_programID].annualRate).div(100000);
555         emit Withdraw(msg.sender, _amount);
556     }
557 
558     function withdrawToken(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
559         IERC20(_tokenAddress).safeTransfer(msg.sender, _tokenAmount);
560     }
561 
562     function pendingReward(address _user) public view returns (uint256 userRewardTotal_) {
563         for (uint i = 0; i < _currentProgramID; i++) {
564           userRewardTotal_ = userRewardTotal_.add(pendingRewardPerProgram(_user, i));
565         }
566     }
567 
568     function pendingRewardPerProgram(address _user, uint256 _programID) public view returns (uint256 userProgramReward_) {
569         UserInfo memory user = userInfo[_user][_programID];
570         uint256 timePassed = timeRewardable(user.lastClaimed, block.timestamp);
571         userProgramReward_ = user.annualPayout.mul(timePassed).div(365 days);
572     }
573 
574     function timeRewardable(uint256 _startTimestamp, uint256 _endTimestamp) internal view returns (uint256) {
575         if (_endTimestamp <= rewardsEndTimestamp) {
576             return _endTimestamp.sub(_startTimestamp);
577         } else if (_startTimestamp >= rewardsEndTimestamp) {
578             return 0;
579         } else {
580             return rewardsEndTimestamp.sub(_startTimestamp);
581         }
582     }
583 }