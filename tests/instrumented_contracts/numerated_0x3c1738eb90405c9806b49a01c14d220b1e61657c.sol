1 pragma solidity ^0.5.0;
2 
3 contract ReentrancyGuard {
4     // Booleans are more expensive than uint256 or any type that takes up a full
5     // word because each write operation emits an extra SLOAD to first read the
6     // slot's contents, replace the bits taken up by the boolean, and then write
7     // back. This is the compiler's defense against contract upgrades and
8     // pointer aliasing, and it cannot be disabled.
9 
10     // The values being non-zero value makes deployment a bit more expensive,
11     // but in exchange the refund on every call to nonReentrant will be lower in
12     // amount. Since refunds are capped to a percentage of the total
13     // transaction's gas, it is best to keep them low in cases like this one, to
14     // increase the likelihood of the full refund coming into effect.
15     uint256 private constant _NOT_ENTERED = 1;
16     uint256 private constant _ENTERED = 2;
17 
18     uint256 private _status;
19 
20     constructor () internal {
21         _status = _NOT_ENTERED;
22     }
23 
24     /**
25      * @dev Prevents a contract from calling itself, directly or indirectly.
26      * Calling a `nonReentrant` function from another `nonReentrant`
27      * function is not supported. It is possible to prevent this from happening
28      * by making the `nonReentrant` function external, and make it call a
29      * `private` function that does the actual work.
30      */
31     modifier nonReentrant() {
32         // On the first call to nonReentrant, _notEntered will be true
33         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
34 
35         // Any calls to nonReentrant after this point will fail
36         _status = _ENTERED;
37 
38         _;
39 
40         // By storing the original value once again, a refund is triggered (see
41         // https://eips.ethereum.org/EIPS/eip-2200)
42         _status = _NOT_ENTERED;
43     }
44 }
45 
46 library Math {
47     function max(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a >= b ? a : b;
49     }
50 
51     function min(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a < b ? a : b;
53     }
54 
55     function average(uint256 a, uint256 b) internal pure returns (uint256) {
56         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
57     }
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64 
65         return c;
66     }
67 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     function sub(
73         uint256 a,
74         uint256 b,
75         string memory errorMessage
76     ) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     function div(
99         uint256 a,
100         uint256 b,
101         string memory errorMessage
102     ) internal pure returns (uint256) {
103         require(b > 0, errorMessage);
104         uint256 c = a / b;
105 
106         return c;
107     }
108 
109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110         return mod(a, b, "SafeMath: modulo by zero");
111     }
112 
113     function mod(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b != 0, errorMessage);
119         return a % b;
120     }
121 }
122 
123 contract Context {
124     constructor() internal {}
125 
126     function _msgSender() internal view returns (address payable) {
127         return msg.sender;
128     }
129 
130     function _msgData() internal view returns (bytes memory) {
131         this;
132         return msg.data;
133     }
134 }
135 
136 contract Ownable is Context {
137     address private _owner;
138 
139     event OwnershipTransferred(
140         address indexed previousOwner,
141         address indexed newOwner
142     );
143 
144     constructor() internal {
145         _owner = _msgSender();
146         emit OwnershipTransferred(address(0), _owner);
147     }
148 
149     function owner() public view returns (address) {
150         return _owner;
151     }
152 
153     modifier onlyOwner() {
154         require(isOwner(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158     function isOwner() public view returns (bool) {
159         return _msgSender() == _owner;
160     }
161 
162     function renounceOwnership() public onlyOwner {
163         emit OwnershipTransferred(_owner, address(0));
164         _owner = address(0);
165     }
166 
167     function transferOwnership(address newOwner) public onlyOwner {
168         _transferOwnership(newOwner);
169     }
170 
171     function _transferOwnership(address newOwner) internal {
172         require(
173             newOwner != address(0),
174             "Ownable: new owner is the zero address"
175         );
176         emit OwnershipTransferred(_owner, newOwner);
177         _owner = newOwner;
178     }
179 }
180 
181 interface IERC20 {
182     function totalSupply() external view returns (uint256);
183 
184     function balanceOf(address account) external view returns (uint256);
185 
186     function transfer(address recipient, uint256 amount)
187         external
188         returns (bool);
189 
190     function allowance(address owner, address spender)
191         external
192         view
193         returns (uint256);
194 
195     function approve(address spender, uint256 amount) external returns (bool);
196 
197     function transferFrom(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) external returns (bool);
202 
203     event Transfer(address indexed from, address indexed to, uint256 value);
204     event Approval(
205         address indexed owner,
206         address indexed spender,
207         uint256 value
208     );
209 }
210 
211 library Address {
212     function isContract(address account) internal view returns (bool) {
213         bytes32 codehash;
214         bytes32 accountHash =
215             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
216 
217         assembly {
218             codehash := extcodehash(account)
219         }
220         return (codehash != 0x0 && codehash != accountHash);
221     }
222 
223     function toPayable(address account)
224         internal
225         pure
226         returns (address payable)
227     {
228         return address(uint160(account));
229     }
230 
231     function sendValue(address payable recipient, uint256 amount) internal {
232         require(
233             address(this).balance >= amount,
234             "Address: insufficient balance"
235         );
236 
237         (bool success, ) = recipient.call.value(amount)("");
238         require(
239             success,
240             "Address: unable to send value, recipient may have reverted"
241         );
242     }
243 }
244 
245 library SafeERC20 {
246     using SafeMath for uint256;
247     using Address for address;
248 
249     function safeTransfer(
250         IERC20 token,
251         address to,
252         uint256 value
253     ) internal {
254         callOptionalReturn(
255             token,
256             abi.encodeWithSelector(token.transfer.selector, to, value)
257         );
258     }
259 
260     function safeTransferFrom(
261         IERC20 token,
262         address from,
263         address to,
264         uint256 value
265     ) internal {
266         callOptionalReturn(
267             token,
268             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
269         );
270     }
271 
272     function safeApprove(
273         IERC20 token,
274         address spender,
275         uint256 value
276     ) internal {
277         require(
278             (value == 0) || (token.allowance(address(this), spender) == 0),
279             "SafeERC20: approve from non-zero to non-zero allowance"
280         );
281         callOptionalReturn(
282             token,
283             abi.encodeWithSelector(token.approve.selector, spender, value)
284         );
285     }
286 
287     function safeIncreaseAllowance(
288         IERC20 token,
289         address spender,
290         uint256 value
291     ) internal {
292         uint256 newAllowance =
293             token.allowance(address(this), spender).add(value);
294         callOptionalReturn(
295             token,
296             abi.encodeWithSelector(
297                 token.approve.selector,
298                 spender,
299                 newAllowance
300             )
301         );
302     }
303 
304     function safeDecreaseAllowance(
305         IERC20 token,
306         address spender,
307         uint256 value
308     ) internal {
309         uint256 newAllowance =
310             token.allowance(address(this), spender).sub(
311                 value,
312                 "SafeERC20: decreased allowance below zero"
313             );
314         callOptionalReturn(
315             token,
316             abi.encodeWithSelector(
317                 token.approve.selector,
318                 spender,
319                 newAllowance
320             )
321         );
322     }
323 
324     function callOptionalReturn(IERC20 token, bytes memory data) private {
325         require(address(token).isContract(), "SafeERC20: call to non-contract");
326 
327         (bool success, bytes memory returndata) = address(token).call(data);
328         require(success, "SafeERC20: low-level call failed");
329 
330         if (returndata.length > 0) {
331             
332             // Return data is optional
333             require(
334                 abi.decode(returndata, (bool)),
335                 "SafeERC20: ERC20 operation did not succeed"
336             );
337         }
338     }
339 }
340 
341 contract LPTokenWrapper is Ownable, ReentrancyGuard {
342     using SafeMath for uint256;
343     using SafeERC20 for IERC20;
344 
345     IERC20 public BSKTASREWARD = IERC20(0xC03841B5135600312707d39Eb2aF0D2aD5d51A91);  // Approve and Transfer for Stake and Withdraw
346 
347     uint256 private _totalSupply;
348     mapping(address => uint256) private _balances;
349 
350     function totalSupply() public view returns (uint256) {
351         return _totalSupply;
352     }
353 
354     function balanceOf(address account) public view returns (uint256) {
355         return _balances[account];
356     }
357 
358     function stake(uint256 amount) nonReentrant public {
359         
360         uint256 actualAmount = amount.sub(amount.mul(20).div(1000));  // manage 2% token difference 
361         
362         _totalSupply = _totalSupply.add(actualAmount);
363         
364         _balances[_msgSender()] = _balances[_msgSender()].add(actualAmount);
365         
366         BSKTASREWARD.safeTransferFrom(_msgSender(), address(this), amount);
367     }
368 
369     function withdraw(uint256 amount) nonReentrant public {
370         _totalSupply = _totalSupply.sub(amount);
371         _balances[_msgSender()] = _balances[_msgSender()].sub(amount);
372         BSKTASREWARD.safeTransfer(_msgSender(), amount);
373     }
374 }
375 
376 contract BsktLPPool is LPTokenWrapper {
377     IERC20 public STAKEBSKT = IERC20(0xC03841B5135600312707d39Eb2aF0D2aD5d51A91); // BSKT TOKEN ADDRESS
378     
379     uint256 public duration = 30 days;              //-----| Pool Duration |-----       
380     uint256 public starttime = 0;                   //-----| Pool will start once notify the reward |-----                           
381     uint256 public periodFinish = 0;
382     uint256 public rewardRate = 0;
383     uint256 public lastUpdateTime;
384     uint256 public rewardPerTokenStored;
385 
386     mapping(address => uint256) public userRewardPerTokenPaid;
387     mapping(address => uint256) public rewards;
388     mapping(address => bool) public minimumBsktStakingEntry;
389 
390     event Staked(address indexed user, uint256 amount);
391     event Withdrawn(address indexed user, uint256 amount);
392     event Rewarded(address indexed from, address indexed to, uint256 value);
393 
394     modifier checkStart() {
395         require(
396             block.timestamp >= starttime,
397             "Error:Pool not started yet."
398         );
399         _;
400     }
401 
402     modifier updateReward(address account) {
403         rewardPerTokenStored = rewardPerToken();
404         lastUpdateTime = lastTimeRewardApplicable();
405         if (account != address(0)) {
406             rewards[account] = earned(account);
407             userRewardPerTokenPaid[account] = rewardPerTokenStored;
408         }
409         _;
410     }
411     
412     function lastTimeRewardApplicable() public view returns (uint256) {
413         return Math.min(block.timestamp, periodFinish);
414     }
415 
416     function rewardPerToken() public view returns (uint256) {
417         if (totalSupply() == 0) {
418             return rewardPerTokenStored;
419         }
420         return
421             rewardPerTokenStored.add(
422                 lastTimeRewardApplicable()
423                     .sub(lastUpdateTime)
424                     .mul(rewardRate)
425                     .mul(1e18)
426                     .div(totalSupply())
427             );
428     }
429 
430     function earned(address account) public view returns (uint256) {
431         return balanceOf(account)
432                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
433                 .div(1e18)
434                 .add(rewards[account]);
435                 
436     }
437 
438     function stake(uint256 amount) public updateReward(_msgSender()) checkStart {
439         require(amount > 0, "Cannot stake 0");
440         
441         if(!minimumBsktStakingEntry[_msgSender()]) 
442             require(amount >= 5000 * 10 ** 18, "Error:For Initial entry 5000 token must be required.");
443         
444         super.stake(amount);
445         
446         minimumBsktStakingEntry[_msgSender()] = true;
447         
448         emit Staked(_msgSender(), amount);
449     }
450 
451     function withdraw(uint256 amount)
452         public
453         updateReward(_msgSender())
454     {
455         require(amount > 0, "Cannot withdraw 0");
456         super.withdraw(amount);
457         
458         emit Withdrawn(_msgSender(), amount);
459     }
460 
461     // withdraw stake and get rewards at once
462     function exit() external {
463         withdraw(balanceOf(_msgSender()));
464         getReward();
465     }
466 
467     function getReward() public nonReentrant updateReward(_msgSender()){
468         uint256 reward = earned(_msgSender());
469 
470         if (reward > 0) {
471             rewards[_msgSender()] = 0;
472         
473             STAKEBSKT.safeTransfer(_msgSender(), reward);
474             
475             emit Rewarded(address(this), _msgSender(), reward);
476         }
477         
478     }
479 
480     // notify reward set for duration
481     function notifyRewardRate(uint256 _reward) public updateReward(address(0)) onlyOwner{
482        
483         rewardRate = _reward.div(duration);
484        
485         lastUpdateTime = block.timestamp;
486         starttime = block.timestamp; 
487         periodFinish = block.timestamp.add(duration);
488 
489     }
490     
491     // update duration
492     function setDuration(uint256 _duration) public onlyOwner {
493         duration = _duration;   
494     }
495     
496 }