1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.7; //^0.7.5;
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint) {
6         uint c = a + b;
7         require(c >= a, "add: +");
8 
9         return c;
10     }
11     function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
12         uint c = a + b;
13         require(c >= a, errorMessage);
14 
15         return c;
16     }
17     function sub(uint a, uint b) internal pure returns (uint) {
18         return sub(a, b, "sub: -");
19     }
20     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
21         require(b <= a, errorMessage);
22         uint c = a - b;
23 
24         return c;
25     }
26     function mul(uint a, uint b) internal pure returns (uint) {
27         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint c = a * b;
35         require(c / a == b, "mul: *");
36 
37         return c;
38     }
39     function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint c = a * b;
45         require(c / a == b, errorMessage);
46 
47         return c;
48     }
49     function div(uint a, uint b) internal pure returns (uint) {
50         return div(a, b, "div: /");
51     }
52     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
53         require(b > 0, errorMessage);
54         uint c = a / b;
55 
56         return c;
57     }
58 }
59 
60 library Address {
61     function isContract(address account) internal view returns (bool) {
62         bytes32 codehash;
63         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
64         // solhint-disable-next-line no-inline-assembly
65         assembly { codehash := extcodehash(account) }
66         return (codehash != 0x0 && codehash != accountHash);
67     }
68     function toPayable(address account) internal pure returns (address payable) {
69         return address(uint160(account));
70     }
71     function sendValue(address payable recipient, uint256 amount) internal {
72         require(address(this).balance >= amount, "Address: insufficient balance");
73 
74         // solhint-disable-next-line avoid-call-value
75         (bool success, ) = recipient.call{value:amount}("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78 }
79 
80 interface IERC20 {
81     function totalSupply() external view returns (uint256);
82     function balanceOf(address account) external view returns (uint256);
83     function transfer(address recipient, uint256 amount) external returns (bool);
84     function allowance(address owner, address spender) external view returns (uint256);
85     function approve(address spender, uint256 amount) external returns (bool);
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 }
88 
89 library SafeERC20 {
90     using SafeMath for uint256;
91     using Address for address;
92 
93     function safeTransfer(IERC20 token, address to, uint256 value) internal {
94         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
95     }
96 
97     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
98         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
99     }
100 
101     function safeApprove(IERC20 token, address spender, uint256 value) internal {
102         require((value == 0) || (token.allowance(address(this), spender) == 0),
103             "SafeERC20: approve from non-zero to non-zero allowance"
104         );
105         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
106     }
107 
108     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
109         uint256 newAllowance = token.allowance(address(this), spender).add(value);
110         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
111     }
112 
113     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
114         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
115         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
116     }
117     function callOptionalReturn(IERC20 token, bytes memory data) private {
118         require(address(token).isContract(), "SafeERC20: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = address(token).call(data);
122         require(success, "SafeERC20: low-level call failed");
123 
124         if (returndata.length > 0) { // Return data is optional
125             // solhint-disable-next-line max-line-length
126             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
127         }
128     }
129 }
130 
131 library Math {
132     /**
133      * @dev Returns the largest of two numbers.
134      */
135     function max(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a >= b ? a : b;
137     }
138 
139     /**
140      * @dev Returns the smallest of two numbers.
141      */
142     function min(uint256 a, uint256 b) internal pure returns (uint256) {
143         return a < b ? a : b;
144     }
145 
146     /**
147      * @dev Returns the average of two numbers. The result is rounded towards
148      * zero.
149      */
150     function average(uint256 a, uint256 b) internal pure returns (uint256) {
151         // (a + b) / 2 can overflow, so we distribute
152         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
153     }
154 }
155 
156 /**
157  * @dev Contract module that helps prevent reentrant calls to a function.
158  *
159  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
160  * available, which can be applied to functions to make sure there are no nested
161  * (reentrant) calls to them.
162  *
163  * Note that because there is a single `nonReentrant` guard, functions marked as
164  * `nonReentrant` may not call one another. This can be worked around by making
165  * those functions `private`, and then adding `external` `nonReentrant` entry
166  * points to them.
167  *
168  * TIP: If you would like to learn more about reentrancy and alternative ways
169  * to protect against it, check out our blog post
170  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
171  */
172 abstract contract ReentrancyGuard {
173     // Booleans are more expensive than uint256 or any type that takes up a full
174     // word because each write operation emits an extra SLOAD to first read the
175     // slot's contents, replace the bits taken up by the boolean, and then write
176     // back. This is the compiler's defense against contract upgrades and
177     // pointer aliasing, and it cannot be disabled.
178 
179     // The values being non-zero value makes deployment a bit more expensive,
180     // but in exchange the refund on every call to nonReentrant will be lower in
181     // amount. Since refunds are capped to a percentage of the total
182     // transaction's gas, it is best to keep them low in cases like this one, to
183     // increase the likelihood of the full refund coming into effect.
184     uint256 private constant _NOT_ENTERED = 1;
185     uint256 private constant _ENTERED = 2;
186 
187     uint256 private _status;
188 
189     constructor () public {
190         _status = _NOT_ENTERED;
191     }
192 
193     /**
194      * @dev Prevents a contract from calling itself, directly or indirectly.
195      * Calling a `nonReentrant` function from another `nonReentrant`
196      * function is not supported. It is possible to prevent this from happening
197      * by making the `nonReentrant` function external, and make it call a
198      * `private` function that does the actual work.
199      */
200     modifier nonReentrant() {
201         // On the first call to nonReentrant, _notEntered will be true
202         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
203 
204         // Any calls to nonReentrant after this point will fail
205         _status = _ENTERED;
206 
207         _;
208 
209         // By storing the original value once again, a refund is triggered (see
210         // https://eips.ethereum.org/EIPS/eip-2200)
211         _status = _NOT_ENTERED;
212     }
213 }
214 
215 contract Gauge is ReentrancyGuard {
216     using SafeMath for uint256;
217     using SafeERC20 for IERC20;
218     
219     IERC20 public constant PICKLE = IERC20(0x429881672B9AE42b8EbA0E26cD9C73711b891Ca5);
220     IERC20 public constant DILL = IERC20(0xbBCf169eE191A1Ba7371F30A1C344bFC498b29Cf);
221     address public constant TREASURY = address(0x066419EaEf5DE53cc5da0d8702b990c5bc7D1AB3);
222     
223     IERC20 public immutable TOKEN;
224     address public immutable DISTRIBUTION;
225     uint256 public constant DURATION = 7 days;
226     
227     uint256 public periodFinish = 0;
228     uint256 public rewardRate = 0;
229     uint256 public lastUpdateTime;
230     uint256 public rewardPerTokenStored;
231     
232     modifier onlyDistribution() {
233         require(msg.sender == DISTRIBUTION, "Caller is not RewardsDistribution contract");
234         _;
235     }
236     
237     mapping(address => uint256) public userRewardPerTokenPaid;
238     mapping(address => uint256) public rewards;
239 
240     uint256 private _totalSupply;
241     uint public derivedSupply;
242     mapping(address => uint256) private _balances;
243     mapping(address => uint256) public derivedBalances;
244     mapping(address => uint) private _base;
245     
246     constructor(address _token) public {
247         TOKEN = IERC20(_token);
248         DISTRIBUTION = msg.sender;
249     }
250     
251     function totalSupply() external view returns (uint256) {
252         return _totalSupply;
253     }
254 
255     function balanceOf(address account) external view returns (uint256) {
256         return _balances[account];
257     }
258 
259     function lastTimeRewardApplicable() public view returns (uint256) {
260         return Math.min(block.timestamp, periodFinish);
261     }
262 
263     function rewardPerToken() public view returns (uint256) {
264         if (_totalSupply == 0) {
265             return rewardPerTokenStored;
266         }
267         return
268             rewardPerTokenStored.add(
269                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(derivedSupply)
270             );
271     }
272     
273     function derivedBalance(address account) public view returns (uint) {
274         uint _balance = _balances[account];
275         uint _derived = _balance.mul(40).div(100);
276         uint _adjusted = (_totalSupply.mul(DILL.balanceOf(account)).div(DILL.totalSupply())).mul(60).div(100);
277         return Math.min(_derived.add(_adjusted), _balance);
278     }
279     
280     function kick(address account) public {
281         uint _derivedBalance = derivedBalances[account];
282         derivedSupply = derivedSupply.sub(_derivedBalance);
283         _derivedBalance = derivedBalance(account);
284         derivedBalances[account] = _derivedBalance;
285         derivedSupply = derivedSupply.add(_derivedBalance);
286     }
287 
288     function earned(address account) public view returns (uint256) {
289         return derivedBalances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
290     }
291 
292     function getRewardForDuration() external view returns (uint256) {
293         return rewardRate.mul(DURATION);
294     }
295     
296     function depositAll() external {
297         _deposit(TOKEN.balanceOf(msg.sender), msg.sender);
298     }
299     
300     function deposit(uint256 amount) external {
301         _deposit(amount, msg.sender);
302     }
303     
304     function depositFor(uint256 amount, address account) external {
305         _deposit(amount, account);
306     }
307     
308     function _deposit(uint amount, address account) internal nonReentrant updateReward(account) {
309         require(amount > 0, "Cannot stake 0");
310         _totalSupply = _totalSupply.add(amount);
311         _balances[account] = _balances[account].add(amount);
312         emit Staked(account, amount);
313         TOKEN.safeTransferFrom(account, address(this), amount);
314     }
315     
316     function withdrawAll() external {
317         _withdraw(_balances[msg.sender]);
318     }
319 
320     function withdraw(uint256 amount) external {
321         _withdraw(amount);
322     }
323     
324     function _withdraw(uint amount) internal nonReentrant updateReward(msg.sender) {
325         require(amount > 0, "Cannot withdraw 0");
326         _totalSupply = _totalSupply.sub(amount);
327         _balances[msg.sender] = _balances[msg.sender].sub(amount);
328         TOKEN.safeTransfer(msg.sender, amount);
329         emit Withdrawn(msg.sender, amount);
330     }
331 
332     function getReward() public nonReentrant updateReward(msg.sender) {
333         uint256 reward = rewards[msg.sender];
334         if (reward > 0) {
335             rewards[msg.sender] = 0;
336             PICKLE.safeTransfer(msg.sender, reward);
337             emit RewardPaid(msg.sender, reward);
338         }
339     }
340 
341     function exit() external {
342        _withdraw(_balances[msg.sender]);
343         getReward();
344     }
345     
346     function notifyRewardAmount(uint256 reward) external onlyDistribution updateReward(address(0)) {
347         PICKLE.safeTransferFrom(DISTRIBUTION, address(this), reward);
348         if (block.timestamp >= periodFinish) {
349             rewardRate = reward.div(DURATION);
350         } else {
351             uint256 remaining = periodFinish.sub(block.timestamp);
352             uint256 leftover = remaining.mul(rewardRate);
353             rewardRate = reward.add(leftover).div(DURATION);
354         }
355 
356         // Ensure the provided reward amount is not more than the balance in the contract.
357         // This keeps the reward rate in the right range, preventing overflows due to
358         // very high values of rewardRate in the earned and rewardsPerToken functions;
359         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
360         uint balance = PICKLE.balanceOf(address(this));
361         require(rewardRate <= balance.div(DURATION), "Provided reward too high");
362 
363         lastUpdateTime = block.timestamp;
364         periodFinish = block.timestamp.add(DURATION);
365         emit RewardAdded(reward);
366     }
367 
368     modifier updateReward(address account) {
369         rewardPerTokenStored = rewardPerToken();
370         lastUpdateTime = lastTimeRewardApplicable();
371         if (account != address(0)) {
372             rewards[account] = earned(account);
373             userRewardPerTokenPaid[account] = rewardPerTokenStored;
374         }
375         _;
376         if (account != address(0)) {
377             kick(account);
378         }
379     }
380 
381     event RewardAdded(uint256 reward);
382     event Staked(address indexed user, uint256 amount);
383     event Withdrawn(address indexed user, uint256 amount);
384     event RewardPaid(address indexed user, uint256 reward);
385 }
386 
387 interface MasterChef {
388     function deposit(uint, uint) external;
389     function withdraw(uint, uint) external;
390     function userInfo(uint, address) external view returns (uint, uint);
391 }
392 
393 contract ProtocolGovernance {
394     /// @notice governance address for the governance contract
395     address public governance;
396     address public pendingGovernance;
397     
398     /**
399      * @notice Allows governance to change governance (for future upgradability)
400      * @param _governance new governance address to set
401      */
402     function setGovernance(address _governance) external {
403         require(msg.sender == governance, "setGovernance: !gov");
404         pendingGovernance = _governance;
405     }
406 
407     /**
408      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
409      */
410     function acceptGovernance() external {
411         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
412         governance = pendingGovernance;
413     }
414 }
415 
416 contract MasterDill {
417     using SafeMath for uint;
418 
419     /// @notice EIP-20 token name for this token
420     string public constant name = "Master DILL";
421 
422     /// @notice EIP-20 token symbol for this token
423     string public constant symbol = "mDILL";
424 
425     /// @notice EIP-20 token decimals for this token
426     uint8 public constant decimals = 18;
427 
428     /// @notice Total number of tokens in circulation
429     uint public totalSupply = 1e18;
430 
431     mapping (address => mapping (address => uint)) internal allowances;
432     mapping (address => uint) internal balances;
433 
434     /// @notice The standard EIP-20 transfer event
435     event Transfer(address indexed from, address indexed to, uint amount);
436 
437     /// @notice The standard EIP-20 approval event
438     event Approval(address indexed owner, address indexed spender, uint amount);
439     
440     constructor() public {
441         balances[msg.sender] = 1e18;
442         emit Transfer(address(0x0), msg.sender, 1e18);
443     }
444 
445     /**
446      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
447      * @param account The address of the account holding the funds
448      * @param spender The address of the account spending the funds
449      * @return The number of tokens approved
450      */
451     function allowance(address account, address spender) external view returns (uint) {
452         return allowances[account][spender];
453     }
454 
455     /**
456      * @notice Approve `spender` to transfer up to `amount` from `src`
457      * @dev This will overwrite the approval amount for `spender`
458      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
459      * @param spender The address of the account which may transfer tokens
460      * @param amount The number of tokens that are approved (2^256-1 means infinite)
461      * @return Whether or not the approval succeeded
462      */
463     function approve(address spender, uint amount) external returns (bool) {
464         allowances[msg.sender][spender] = amount;
465 
466         emit Approval(msg.sender, spender, amount);
467         return true;
468     }
469 
470     /**
471      * @notice Get the number of tokens held by the `account`
472      * @param account The address of the account to get the balance of
473      * @return The number of tokens held
474      */
475     function balanceOf(address account) external view returns (uint) {
476         return balances[account];
477     }
478 
479     /**
480      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
481      * @param dst The address of the destination account
482      * @param amount The number of tokens to transfer
483      * @return Whether or not the transfer succeeded
484      */
485     function transfer(address dst, uint amount) external returns (bool) {
486         _transferTokens(msg.sender, dst, amount);
487         return true;
488     }
489 
490     /**
491      * @notice Transfer `amount` tokens from `src` to `dst`
492      * @param src The address of the source account
493      * @param dst The address of the destination account
494      * @param amount The number of tokens to transfer
495      * @return Whether or not the transfer succeeded
496      */
497     function transferFrom(address src, address dst, uint amount) external returns (bool) {
498         address spender = msg.sender;
499         uint spenderAllowance = allowances[src][spender];
500 
501         if (spender != src && spenderAllowance != uint(-1)) {
502             uint newAllowance = spenderAllowance.sub(amount, "transferFrom: exceeds spender allowance");
503             allowances[src][spender] = newAllowance;
504 
505             emit Approval(src, spender, newAllowance);
506         }
507 
508         _transferTokens(src, dst, amount);
509         return true;
510     }
511 
512     function _transferTokens(address src, address dst, uint amount) internal {
513         require(src != address(0), "_transferTokens: zero address");
514         require(dst != address(0), "_transferTokens: zero address");
515 
516         balances[src] = balances[src].sub(amount, "_transferTokens: exceeds balance");
517         balances[dst] = balances[dst].add(amount, "_transferTokens: overflows");
518         emit Transfer(src, dst, amount);
519     }
520 }
521 
522 contract GaugeProxy is ProtocolGovernance {
523     using SafeMath for uint256;
524     using SafeERC20 for IERC20;
525     
526     MasterChef public constant MASTER = MasterChef(0xbD17B1ce622d73bD438b9E658acA5996dc394b0d);
527     IERC20 public constant DILL = IERC20(0xbBCf169eE191A1Ba7371F30A1C344bFC498b29Cf);
528     IERC20 public constant PICKLE = IERC20(0x429881672B9AE42b8EbA0E26cD9C73711b891Ca5);
529     
530     IERC20 public immutable TOKEN;
531     
532     uint public pid;
533     uint public totalWeight;
534     
535     address[] internal _tokens;
536     mapping(address => address) public gauges; // token => gauge
537     mapping(address => uint) public weights; // token => weight
538     mapping(address => mapping(address => uint)) public votes; // msg.sender => votes
539     mapping(address => address[]) public tokenVote;// msg.sender => token
540     mapping(address => uint) public usedWeights;  // msg.sender => total voting weight of user
541     
542     function tokens() external view returns (address[] memory) {
543         return _tokens;
544     }
545     
546     function getGauge(address _token) external view returns (address) {
547         return gauges[_token];
548     }
549     
550     constructor() public {
551         TOKEN = IERC20(address(new MasterDill()));
552         governance = msg.sender;
553     }
554     
555     // Reset votes to 0
556     function reset() external {
557         _reset(msg.sender);
558     }
559     
560     // Reset votes to 0
561     function _reset(address _owner) internal {
562         address[] storage _tokenVote = tokenVote[_owner];
563         uint256 _tokenVoteCnt = _tokenVote.length;
564 
565         for (uint i = 0; i < _tokenVoteCnt; i ++) {
566             address _token = _tokenVote[i];
567             uint _votes = votes[_owner][_token];
568             
569             if (_votes > 0) {
570                 totalWeight = totalWeight.sub(_votes);
571                 weights[_token] = weights[_token].sub(_votes);
572                 
573                 votes[_owner][_token] = 0;
574             }
575         }
576 
577         delete tokenVote[_owner];
578     }
579     
580     // Adjusts _owner's votes according to latest _owner's DILL balance
581     function poke(address _owner) public {
582         address[] memory _tokenVote = tokenVote[_owner];
583         uint256 _tokenCnt = _tokenVote.length;
584         uint256[] memory _weights = new uint[](_tokenCnt);
585         
586         uint256 _prevUsedWeight = usedWeights[_owner];
587         uint256 _weight = DILL.balanceOf(_owner);        
588 
589         for (uint256 i = 0; i < _tokenCnt; i ++) {
590             uint256 _prevWeight = votes[_owner][_tokenVote[i]];
591             _weights[i] = _prevWeight.mul(_weight).div(_prevUsedWeight);
592         }
593 
594         _vote(_owner, _tokenVote, _weights);
595     }
596     
597     function _vote(address _owner, address[] memory _tokenVote, uint256[] memory _weights) internal {
598         // _weights[i] = percentage * 100
599         _reset(_owner);
600         uint256 _tokenCnt = _tokenVote.length;
601         uint256 _weight = DILL.balanceOf(_owner);
602         uint256 _totalVoteWeight = 0;
603         uint256 _usedWeight = 0;
604 
605         for (uint256 i = 0; i < _tokenCnt; i ++) {
606             _totalVoteWeight = _totalVoteWeight.add(_weights[i]);
607         }
608 
609         for (uint256 i = 0; i < _tokenCnt; i ++) {
610             address _token = _tokenVote[i];
611             address _gauge = gauges[_token];
612             uint256 _tokenWeight = _weights[i].mul(_weight).div(_totalVoteWeight);
613 
614             if (_gauge != address(0x0)) {
615                 _usedWeight = _usedWeight.add(_tokenWeight);
616                 totalWeight = totalWeight.add(_tokenWeight);
617                 weights[_token] = weights[_token].add(_tokenWeight);
618                 tokenVote[_owner].push(_token);
619                 votes[_owner][_token] = _tokenWeight;
620             }
621         }
622 
623         usedWeights[_owner] = _usedWeight;
624     }
625     
626     
627     // Vote with DILL on a gauge
628     function vote(address[] calldata _tokenVote, uint256[] calldata _weights) external {
629         require(_tokenVote.length == _weights.length);
630         _vote(msg.sender, _tokenVote, _weights);
631     }
632     
633     // Add new token gauge
634     function addGauge(address _token) external {
635         require(msg.sender == governance, "!gov");
636         require(gauges[_token] == address(0x0), "exists");
637         gauges[_token] = address(new Gauge(_token));
638         _tokens.push(_token);
639     }
640     
641     
642     // Sets MasterChef PID
643     function setPID(uint _pid) external {
644         require(msg.sender == governance, "!gov");
645         require(pid == 0, "pid has already been set");
646         require(_pid > 0, "invalid pid");
647         pid = _pid;
648     }
649     
650     
651     // Deposits mDILL into MasterChef
652     function deposit() public {
653         require(pid > 0, "pid not initialized");
654         IERC20 _token = TOKEN;
655         uint _balance = _token.balanceOf(address(this));
656         _token.safeApprove(address(MASTER), 0);
657         _token.safeApprove(address(MASTER), _balance);
658         MASTER.deposit(pid, _balance);
659     }
660     
661     
662     // Fetches Pickle
663     function collect() public {
664         (uint _locked,) = MASTER.userInfo(pid, address(this));
665         MASTER.withdraw(pid, _locked);
666         deposit();
667     }
668     
669     function length() external view returns (uint) {
670         return _tokens.length;
671     }
672     
673     function distribute() external {
674         collect();
675         uint _balance = PICKLE.balanceOf(address(this));
676         if (_balance > 0 && totalWeight > 0) {
677             for (uint i = 0; i < _tokens.length; i++) {
678                 address _token = _tokens[i];
679                 address _gauge = gauges[_token];
680                 uint _reward = _balance.mul(weights[_token]).div(totalWeight);
681                 if (_reward > 0) {
682                     PICKLE.safeApprove(_gauge, 0);
683                     PICKLE.safeApprove(_gauge, _reward);
684                     Gauge(_gauge).notifyRewardAmount(_reward);
685                 }
686             }
687         }
688     }
689 }