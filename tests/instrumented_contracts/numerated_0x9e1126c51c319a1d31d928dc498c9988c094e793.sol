1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-30
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.6.7; //^0.7.5;
7 
8 library SafeMath {
9     function add(uint a, uint b) internal pure returns (uint) {
10         uint c = a + b;
11         require(c >= a, "add: +");
12 
13         return c;
14     }
15     function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
16         uint c = a + b;
17         require(c >= a, errorMessage);
18 
19         return c;
20     }
21     function sub(uint a, uint b) internal pure returns (uint) {
22         return sub(a, b, "sub: -");
23     }
24     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
25         require(b <= a, errorMessage);
26         uint c = a - b;
27 
28         return c;
29     }
30     function mul(uint a, uint b) internal pure returns (uint) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint c = a * b;
39         require(c / a == b, "mul: *");
40 
41         return c;
42     }
43     function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint c = a * b;
49         require(c / a == b, errorMessage);
50 
51         return c;
52     }
53     function div(uint a, uint b) internal pure returns (uint) {
54         return div(a, b, "div: /");
55     }
56     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
57         require(b > 0, errorMessage);
58         uint c = a / b;
59 
60         return c;
61     }
62 }
63 
64 library Address {
65     function isContract(address account) internal view returns (bool) {
66         bytes32 codehash;
67         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
68         // solhint-disable-next-line no-inline-assembly
69         assembly { codehash := extcodehash(account) }
70         return (codehash != 0x0 && codehash != accountHash);
71     }
72     function toPayable(address account) internal pure returns (address payable) {
73         return address(uint160(account));
74     }
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(address(this).balance >= amount, "Address: insufficient balance");
77 
78         // solhint-disable-next-line avoid-call-value
79         (bool success, ) = recipient.call{value:amount}("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 }
83 
84 interface IERC20 {
85     function totalSupply() external view returns (uint256);
86     function balanceOf(address account) external view returns (uint256);
87     function transfer(address recipient, uint256 amount) external returns (bool);
88     function allowance(address owner, address spender) external view returns (uint256);
89     function approve(address spender, uint256 amount) external returns (bool);
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 }
92 
93 library SafeERC20 {
94     using SafeMath for uint256;
95     using Address for address;
96 
97     function safeTransfer(IERC20 token, address to, uint256 value) internal {
98         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
99     }
100 
101     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
102         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
103     }
104 
105     function safeApprove(IERC20 token, address spender, uint256 value) internal {
106         require((value == 0) || (token.allowance(address(this), spender) == 0),
107             "SafeERC20: approve from non-zero to non-zero allowance"
108         );
109         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
110     }
111 
112     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
113         uint256 newAllowance = token.allowance(address(this), spender).add(value);
114         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
115     }
116 
117     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
118         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
119         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
120     }
121     function callOptionalReturn(IERC20 token, bytes memory data) private {
122         require(address(token).isContract(), "SafeERC20: call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = address(token).call(data);
126         require(success, "SafeERC20: low-level call failed");
127 
128         if (returndata.length > 0) { // Return data is optional
129             // solhint-disable-next-line max-line-length
130             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
131         }
132     }
133 }
134 
135 library Math {
136     /**
137      * @dev Returns the largest of two numbers.
138      */
139     function max(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a >= b ? a : b;
141     }
142 
143     /**
144      * @dev Returns the smallest of two numbers.
145      */
146     function min(uint256 a, uint256 b) internal pure returns (uint256) {
147         return a < b ? a : b;
148     }
149 
150     /**
151      * @dev Returns the average of two numbers. The result is rounded towards
152      * zero.
153      */
154     function average(uint256 a, uint256 b) internal pure returns (uint256) {
155         // (a + b) / 2 can overflow, so we distribute
156         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
157     }
158 }
159 
160 /**
161  * @dev Contract module that helps prevent reentrant calls to a function.
162  *
163  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
164  * available, which can be applied to functions to make sure there are no nested
165  * (reentrant) calls to them.
166  *
167  * Note that because there is a single `nonReentrant` guard, functions marked as
168  * `nonReentrant` may not call one another. This can be worked around by making
169  * those functions `private`, and then adding `external` `nonReentrant` entry
170  * points to them.
171  *
172  * TIP: If you would like to learn more about reentrancy and alternative ways
173  * to protect against it, check out our blog post
174  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
175  */
176 abstract contract ReentrancyGuard {
177     // Booleans are more expensive than uint256 or any type that takes up a full
178     // word because each write operation emits an extra SLOAD to first read the
179     // slot's contents, replace the bits taken up by the boolean, and then write
180     // back. This is the compiler's defense against contract upgrades and
181     // pointer aliasing, and it cannot be disabled.
182 
183     // The values being non-zero value makes deployment a bit more expensive,
184     // but in exchange the refund on every call to nonReentrant will be lower in
185     // amount. Since refunds are capped to a percentage of the total
186     // transaction's gas, it is best to keep them low in cases like this one, to
187     // increase the likelihood of the full refund coming into effect.
188     uint256 private constant _NOT_ENTERED = 1;
189     uint256 private constant _ENTERED = 2;
190 
191     uint256 private _status;
192 
193     constructor () public {
194         _status = _NOT_ENTERED;
195     }
196 
197     /**
198      * @dev Prevents a contract from calling itself, directly or indirectly.
199      * Calling a `nonReentrant` function from another `nonReentrant`
200      * function is not supported. It is possible to prevent this from happening
201      * by making the `nonReentrant` function external, and make it call a
202      * `private` function that does the actual work.
203      */
204     modifier nonReentrant() {
205         // On the first call to nonReentrant, _notEntered will be true
206         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
207 
208         // Any calls to nonReentrant after this point will fail
209         _status = _ENTERED;
210 
211         _;
212 
213         // By storing the original value once again, a refund is triggered (see
214         // https://eips.ethereum.org/EIPS/eip-2200)
215         _status = _NOT_ENTERED;
216     }
217 }
218 
219 contract Gauge is ReentrancyGuard {
220     using SafeMath for uint256;
221     using SafeERC20 for IERC20;
222     
223     IERC20 public constant PICKLE = IERC20(0x429881672B9AE42b8EbA0E26cD9C73711b891Ca5);
224     IERC20 public constant DILL = IERC20(0xbBCf169eE191A1Ba7371F30A1C344bFC498b29Cf);
225     address public constant TREASURY = address(0x066419EaEf5DE53cc5da0d8702b990c5bc7D1AB3);
226     
227     IERC20 public immutable TOKEN;
228     address public immutable DISTRIBUTION;
229     uint256 public constant DURATION = 7 days;
230     
231     uint256 public periodFinish = 0;
232     uint256 public rewardRate = 0;
233     uint256 public lastUpdateTime;
234     uint256 public rewardPerTokenStored;
235     
236     modifier onlyDistribution() {
237         require(msg.sender == DISTRIBUTION, "Caller is not RewardsDistribution contract");
238         _;
239     }
240     
241     mapping(address => uint256) public userRewardPerTokenPaid;
242     mapping(address => uint256) public rewards;
243 
244     uint256 private _totalSupply;
245     uint public derivedSupply;
246     mapping(address => uint256) private _balances;
247     mapping(address => uint256) public derivedBalances;
248     mapping(address => uint) private _base;
249     
250     constructor(address _token) public {
251         TOKEN = IERC20(_token);
252         DISTRIBUTION = msg.sender;
253     }
254     
255     function totalSupply() external view returns (uint256) {
256         return _totalSupply;
257     }
258 
259     function balanceOf(address account) external view returns (uint256) {
260         return _balances[account];
261     }
262 
263     function lastTimeRewardApplicable() public view returns (uint256) {
264         return Math.min(block.timestamp, periodFinish);
265     }
266 
267     function rewardPerToken() public view returns (uint256) {
268         if (_totalSupply == 0) {
269             return rewardPerTokenStored;
270         }
271         return
272             rewardPerTokenStored.add(
273                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(derivedSupply)
274             );
275     }
276     
277     function derivedBalance(address account) public view returns (uint) {
278         uint _balance = _balances[account];
279         uint _derived = _balance.mul(40).div(100);
280         uint _adjusted = (_totalSupply.mul(DILL.balanceOf(account)).div(DILL.totalSupply())).mul(60).div(100);
281         return Math.min(_derived.add(_adjusted), _balance);
282     }
283     
284     function kick(address account) public {
285         uint _derivedBalance = derivedBalances[account];
286         derivedSupply = derivedSupply.sub(_derivedBalance);
287         _derivedBalance = derivedBalance(account);
288         derivedBalances[account] = _derivedBalance;
289         derivedSupply = derivedSupply.add(_derivedBalance);
290     }
291 
292     function earned(address account) public view returns (uint256) {
293         return derivedBalances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
294     }
295 
296     function getRewardForDuration() external view returns (uint256) {
297         return rewardRate.mul(DURATION);
298     }
299     
300     function depositAll() external {
301         _deposit(TOKEN.balanceOf(msg.sender), msg.sender);
302     }
303     
304     function deposit(uint256 amount) external {
305         _deposit(amount, msg.sender);
306     }
307     
308     function depositFor(uint256 amount, address account) external {
309         _deposit(amount, account);
310     }
311     
312     function _deposit(uint amount, address account) internal nonReentrant updateReward(account) {
313         require(amount > 0, "Cannot stake 0");
314         _totalSupply = _totalSupply.add(amount);
315         _balances[account] = _balances[account].add(amount);
316         emit Staked(account, amount);
317         TOKEN.safeTransferFrom(account, address(this), amount);
318     }
319     
320     function withdrawAll() external {
321         _withdraw(_balances[msg.sender]);
322     }
323 
324     function withdraw(uint256 amount) external {
325         _withdraw(amount);
326     }
327     
328     function _withdraw(uint amount) internal nonReentrant updateReward(msg.sender) {
329         require(amount > 0, "Cannot withdraw 0");
330         _totalSupply = _totalSupply.sub(amount);
331         _balances[msg.sender] = _balances[msg.sender].sub(amount);
332         TOKEN.safeTransfer(msg.sender, amount);
333         emit Withdrawn(msg.sender, amount);
334     }
335 
336     function getReward() public nonReentrant updateReward(msg.sender) {
337         uint256 reward = rewards[msg.sender];
338         if (reward > 0) {
339             rewards[msg.sender] = 0;
340             PICKLE.safeTransfer(msg.sender, reward);
341             emit RewardPaid(msg.sender, reward);
342         }
343     }
344 
345     function exit() external {
346        _withdraw(_balances[msg.sender]);
347         getReward();
348     }
349     
350     function notifyRewardAmount(uint256 reward) external onlyDistribution updateReward(address(0)) {
351         PICKLE.safeTransferFrom(DISTRIBUTION, address(this), reward);
352         if (block.timestamp >= periodFinish) {
353             rewardRate = reward.div(DURATION);
354         } else {
355             uint256 remaining = periodFinish.sub(block.timestamp);
356             uint256 leftover = remaining.mul(rewardRate);
357             rewardRate = reward.add(leftover).div(DURATION);
358         }
359 
360         // Ensure the provided reward amount is not more than the balance in the contract.
361         // This keeps the reward rate in the right range, preventing overflows due to
362         // very high values of rewardRate in the earned and rewardsPerToken functions;
363         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
364         uint balance = PICKLE.balanceOf(address(this));
365         require(rewardRate <= balance.div(DURATION), "Provided reward too high");
366 
367         lastUpdateTime = block.timestamp;
368         periodFinish = block.timestamp.add(DURATION);
369         emit RewardAdded(reward);
370     }
371 
372     modifier updateReward(address account) {
373         rewardPerTokenStored = rewardPerToken();
374         lastUpdateTime = lastTimeRewardApplicable();
375         if (account != address(0)) {
376             rewards[account] = earned(account);
377             userRewardPerTokenPaid[account] = rewardPerTokenStored;
378         }
379         _;
380         if (account != address(0)) {
381             kick(account);
382         }
383     }
384 
385     event RewardAdded(uint256 reward);
386     event Staked(address indexed user, uint256 amount);
387     event Withdrawn(address indexed user, uint256 amount);
388     event RewardPaid(address indexed user, uint256 reward);
389 }
390 
391 interface MasterChef {
392     function deposit(uint, uint) external;
393     function withdraw(uint, uint) external;
394     function userInfo(uint, address) external view returns (uint, uint);
395 }
396 
397 contract ProtocolGovernance {
398     /// @notice governance address for the governance contract
399     address public governance;
400     address public pendingGovernance;
401     
402     /**
403      * @notice Allows governance to change governance (for future upgradability)
404      * @param _governance new governance address to set
405      */
406     function setGovernance(address _governance) external {
407         require(msg.sender == governance, "setGovernance: !gov");
408         pendingGovernance = _governance;
409     }
410 
411     /**
412      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
413      */
414     function acceptGovernance() external {
415         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
416         governance = pendingGovernance;
417     }
418 }
419 
420 contract MasterDill {
421     using SafeMath for uint;
422 
423     /// @notice EIP-20 token name for this token
424     string public constant name = "Master DILL";
425 
426     /// @notice EIP-20 token symbol for this token
427     string public constant symbol = "mDILL";
428 
429     /// @notice EIP-20 token decimals for this token
430     uint8 public constant decimals = 18;
431 
432     /// @notice Total number of tokens in circulation
433     uint public totalSupply = 1e18;
434 
435     mapping (address => mapping (address => uint)) internal allowances;
436     mapping (address => uint) internal balances;
437 
438     /// @notice The standard EIP-20 transfer event
439     event Transfer(address indexed from, address indexed to, uint amount);
440 
441     /// @notice The standard EIP-20 approval event
442     event Approval(address indexed owner, address indexed spender, uint amount);
443     
444     constructor() public {
445         balances[msg.sender] = 1e18;
446         emit Transfer(address(0x0), msg.sender, 1e18);
447     }
448 
449     /**
450      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
451      * @param account The address of the account holding the funds
452      * @param spender The address of the account spending the funds
453      * @return The number of tokens approved
454      */
455     function allowance(address account, address spender) external view returns (uint) {
456         return allowances[account][spender];
457     }
458 
459     /**
460      * @notice Approve `spender` to transfer up to `amount` from `src`
461      * @dev This will overwrite the approval amount for `spender`
462      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
463      * @param spender The address of the account which may transfer tokens
464      * @param amount The number of tokens that are approved (2^256-1 means infinite)
465      * @return Whether or not the approval succeeded
466      */
467     function approve(address spender, uint amount) external returns (bool) {
468         allowances[msg.sender][spender] = amount;
469 
470         emit Approval(msg.sender, spender, amount);
471         return true;
472     }
473 
474     /**
475      * @notice Get the number of tokens held by the `account`
476      * @param account The address of the account to get the balance of
477      * @return The number of tokens held
478      */
479     function balanceOf(address account) external view returns (uint) {
480         return balances[account];
481     }
482 
483     /**
484      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
485      * @param dst The address of the destination account
486      * @param amount The number of tokens to transfer
487      * @return Whether or not the transfer succeeded
488      */
489     function transfer(address dst, uint amount) external returns (bool) {
490         _transferTokens(msg.sender, dst, amount);
491         return true;
492     }
493 
494     /**
495      * @notice Transfer `amount` tokens from `src` to `dst`
496      * @param src The address of the source account
497      * @param dst The address of the destination account
498      * @param amount The number of tokens to transfer
499      * @return Whether or not the transfer succeeded
500      */
501     function transferFrom(address src, address dst, uint amount) external returns (bool) {
502         address spender = msg.sender;
503         uint spenderAllowance = allowances[src][spender];
504 
505         if (spender != src && spenderAllowance != uint(-1)) {
506             uint newAllowance = spenderAllowance.sub(amount, "transferFrom: exceeds spender allowance");
507             allowances[src][spender] = newAllowance;
508 
509             emit Approval(src, spender, newAllowance);
510         }
511 
512         _transferTokens(src, dst, amount);
513         return true;
514     }
515 
516     function _transferTokens(address src, address dst, uint amount) internal {
517         require(src != address(0), "_transferTokens: zero address");
518         require(dst != address(0), "_transferTokens: zero address");
519 
520         balances[src] = balances[src].sub(amount, "_transferTokens: exceeds balance");
521         balances[dst] = balances[dst].add(amount, "_transferTokens: overflows");
522         emit Transfer(src, dst, amount);
523     }
524 }
525 
526 contract GaugeProxy is ProtocolGovernance {
527     using SafeMath for uint256;
528     using SafeERC20 for IERC20;
529     
530     MasterChef public constant MASTER = MasterChef(0xbD17B1ce622d73bD438b9E658acA5996dc394b0d);
531     IERC20 public constant DILL = IERC20(0xbBCf169eE191A1Ba7371F30A1C344bFC498b29Cf);
532     IERC20 public constant PICKLE = IERC20(0x429881672B9AE42b8EbA0E26cD9C73711b891Ca5);
533     
534     IERC20 public immutable TOKEN;
535     
536     uint public pid;
537     uint public totalWeight;
538     
539     address[] internal _tokens;
540     mapping(address => address) public gauges; // token => gauge
541     mapping(address => uint) public weights; // token => weight
542     mapping(address => mapping(address => uint)) public votes; // msg.sender => votes
543     mapping(address => address[]) public tokenVote;// msg.sender => token
544     mapping(address => uint) public usedWeights;  // msg.sender => total voting weight of user
545     
546     function tokens() external view returns (address[] memory) {
547         return _tokens;
548     }
549     
550     function getGauge(address _token) external view returns (address) {
551         return gauges[_token];
552     }
553     
554     constructor() public {
555         TOKEN = IERC20(address(new MasterDill()));
556         governance = msg.sender;
557     }
558     
559     // Reset votes to 0
560     function reset() external {
561         _reset(msg.sender);
562     }
563     
564     // Reset votes to 0
565     function _reset(address _owner) internal {
566         address[] storage _tokenVote = tokenVote[_owner];
567         uint256 _tokenVoteCnt = _tokenVote.length;
568 
569         for (uint i = 0; i < _tokenVoteCnt; i ++) {
570             address _token = _tokenVote[i];
571             uint _votes = votes[_owner][_token];
572             
573             if (_votes > 0) {
574                 totalWeight = totalWeight.sub(_votes);
575                 weights[_token] = weights[_token].sub(_votes);
576                 
577                 votes[_owner][_token] = 0;
578             }
579         }
580 
581         delete tokenVote[_owner];
582     }
583     
584     // Adjusts _owner's votes according to latest _owner's DILL balance
585     function poke(address _owner) public {
586         address[] memory _tokenVote = tokenVote[_owner];
587         uint256 _tokenCnt = _tokenVote.length;
588         uint256[] memory _weights = new uint[](_tokenCnt);
589         
590         uint256 _prevUsedWeight = usedWeights[_owner];
591         uint256 _weight = DILL.balanceOf(_owner);        
592 
593         for (uint256 i = 0; i < _tokenCnt; i ++) {
594             uint256 _prevWeight = votes[_owner][_tokenVote[i]];
595             _weights[i] = _prevWeight.mul(_weight).div(_prevUsedWeight);
596         }
597 
598         _vote(_owner, _tokenVote, _weights);
599     }
600     
601     function _vote(address _owner, address[] memory _tokenVote, uint256[] memory _weights) internal {
602         // _weights[i] = percentage * 100
603         _reset(_owner);
604         uint256 _tokenCnt = _tokenVote.length;
605         uint256 _weight = DILL.balanceOf(_owner);
606         uint256 _totalVoteWeight = 0;
607         uint256 _usedWeight = 0;
608 
609         for (uint256 i = 0; i < _tokenCnt; i ++) {
610             _totalVoteWeight = _totalVoteWeight.add(_weights[i]);
611         }
612 
613         for (uint256 i = 0; i < _tokenCnt; i ++) {
614             address _token = _tokenVote[i];
615             address _gauge = gauges[_token];
616             uint256 _tokenWeight = _weights[i].mul(_weight).div(_totalVoteWeight);
617 
618             if (_gauge != address(0x0)) {
619                 _usedWeight = _usedWeight.add(_tokenWeight);
620                 totalWeight = totalWeight.add(_tokenWeight);
621                 weights[_token] = weights[_token].add(_tokenWeight);
622                 tokenVote[_owner].push(_token);
623                 votes[_owner][_token] = _tokenWeight;
624             }
625         }
626 
627         usedWeights[_owner] = _usedWeight;
628     }
629     
630     
631     // Vote with DILL on a gauge
632     function vote(address[] calldata _tokenVote, uint256[] calldata _weights) external {
633         require(_tokenVote.length == _weights.length);
634         _vote(msg.sender, _tokenVote, _weights);
635     }
636     
637     // Add new token gauge
638     function addGauge(address _token) external {
639         require(msg.sender == governance, "!gov");
640         require(gauges[_token] == address(0x0), "exists");
641         gauges[_token] = address(new Gauge(_token));
642         _tokens.push(_token);
643     }
644     
645     
646     // Sets MasterChef PID
647     function setPID(uint _pid) external {
648         require(msg.sender == governance, "!gov");
649         require(pid == 0, "pid has already been set");
650         require(_pid > 0, "invalid pid");
651         pid = _pid;
652     }
653     
654     
655     // Deposits mDILL into MasterChef
656     function deposit() public {
657         require(pid > 0, "pid not initialized");
658         IERC20 _token = TOKEN;
659         uint _balance = _token.balanceOf(address(this));
660         _token.safeApprove(address(MASTER), 0);
661         _token.safeApprove(address(MASTER), _balance);
662         MASTER.deposit(pid, _balance);
663     }
664     
665     
666     // Fetches Pickle
667     function collect() public {
668         (uint _locked,) = MASTER.userInfo(pid, address(this));
669         MASTER.withdraw(pid, _locked);
670         deposit();
671     }
672     
673     function length() external view returns (uint) {
674         return _tokens.length;
675     }
676     
677     function distribute() external {
678         collect();
679         uint _balance = PICKLE.balanceOf(address(this));
680         if (_balance > 0 && totalWeight > 0) {
681             for (uint i = 0; i < _tokens.length; i++) {
682                 address _token = _tokens[i];
683                 address _gauge = gauges[_token];
684                 uint _reward = _balance.mul(weights[_token]).div(totalWeight);
685                 if (_reward > 0) {
686                     PICKLE.safeApprove(_gauge, 0);
687                     PICKLE.safeApprove(_gauge, _reward);
688                     Gauge(_gauge).notifyRewardAmount(_reward);
689                 }
690             }
691         }
692     }
693 }