1 // SPDX-License-Identifier: -- 🎲 --
2 
3 pragma solidity ^0.7.5;
4 
5 library SafeMath {
6 
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, 'SafeMath: addition overflow');
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b <= a, 'SafeMath: subtraction overflow');
15         uint256 c = a - b;
16         return c;
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, 'SafeMath: multiplication overflow');
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0, 'SafeMath: division by zero');
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b != 0, 'SafeMath: modulo by zero');
38         return a % b;
39     }
40 }
41 
42 library Math {
43 
44     function max(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a >= b ? a : b;
46     }
47 
48     function min(uint256 a, uint256 b) internal pure returns (uint256) {
49         return a < b ? a : b;
50     }
51 
52     function average(uint256 a, uint256 b) internal pure returns (uint256) {
53         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
54     }
55 }
56 
57 contract Context {
58 
59     constructor() {}
60 
61     function _msgSender() internal view returns (address payable) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view returns (bytes memory) {
66         this;
67         return msg.data;
68     }
69 }
70 
71 contract Ownable is Context {
72 
73     address private _owner;
74 
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79 
80     constructor() {
81         _owner = _msgSender();
82         emit OwnershipTransferred(
83             address(0),
84             _owner
85         );
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(
94             isOwner(),
95             'Ownable: caller is not the owner'
96         );
97         _;
98     }
99 
100     function isOwner() public view returns (bool) {
101         return _msgSender() == _owner;
102     }
103 
104     function renounceOwnership() public onlyOwner {
105         emit OwnershipTransferred(
106             _owner,
107             address(0x0)
108         );
109         _owner = address(0x0);
110     }
111 
112     function transferOwnership(address newOwner) public onlyOwner {
113         _transferOwnership(newOwner);
114     }
115 
116     function _transferOwnership(address newOwner) internal {
117         require(
118             newOwner != address(0x0),
119             'Ownable: new owner is the zero address'
120         );
121         emit OwnershipTransferred(_owner, newOwner);
122         _owner = newOwner;
123     }
124 }
125 
126 interface IERC20 {
127 
128     function totalSupply() external view returns (uint256);
129 
130     function balanceOf(address account) external view returns (uint256);
131 
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     function approve(address spender, uint256 amount) external returns (bool);
137 
138     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
139 
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 
142     event Approval(address indexed owner, address indexed spender, uint256 value);
143 }
144 
145 library Address {
146 
147     function isContract(address account) internal view returns (bool) {
148         bytes32 codehash;
149         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
150         assembly { codehash := extcodehash(account) }
151         return (codehash != 0x0 && codehash != accountHash);
152     }
153 
154     function toPayable(address account) internal pure returns (address payable) {
155         return address(uint160(account));
156     }
157 
158     function sendValue(address payable recipient, uint256 amount) internal {
159         require(
160             address(this).balance >= amount,
161             'Address: insufficient balance'
162         );
163 
164         (bool success, ) = recipient.call{value: amount}('');
165 
166         require(
167             success,
168             'Address: unable to send value'
169         );
170     }
171 }
172 
173 library SafeERC20 {
174 
175     using SafeMath for uint256;
176     using Address for address;
177 
178     function safeTransfer(
179         IERC20 token,
180         address to,
181         uint256 value
182     )
183         internal
184     {
185         callOptionalReturn(
186             token,
187             abi.encodeWithSelector(
188                 token.transfer.selector,
189                 to,
190                 value
191             )
192         );
193     }
194 
195     function safeTransferFrom(
196         IERC20 token,
197         address from,
198         address to,
199         uint256 value
200     )
201         internal
202     {
203         callOptionalReturn(
204             token,
205             abi.encodeWithSelector(
206                 token.transferFrom.selector,
207                 from,
208                 to,
209                 value
210             )
211         );
212     }
213 
214     function safeApprove(
215         IERC20 token,
216         address spender,
217         uint256 value
218     )
219         internal
220     {
221         require(
222             (value == 0) || (token.allowance(address(this), spender) == 0),
223             'SafeERC20: approve from non-zero to non-zero allowance'
224         );
225         callOptionalReturn(
226             token,
227             abi.encodeWithSelector(
228                 token.approve.selector,
229                 spender,
230                 value
231             )
232         );
233     }
234 
235     function safeIncreaseAllowance(
236         IERC20 token,
237         address spender,
238         uint256 value
239     )
240         internal
241     {
242         uint256 newAllowance = token.allowance(
243             address(this),
244             spender
245         ).add(value);
246 
247         callOptionalReturn(
248             token,
249             abi.encodeWithSelector(
250                 token.approve.selector,
251                 spender,
252                 newAllowance
253             )
254         );
255     }
256 
257     function safeDecreaseAllowance(
258         IERC20 token,
259         address spender,
260         uint256 value
261     )
262         internal
263     {
264         uint256 newAllowance = token.allowance(
265             address(this),
266             spender
267         ).sub(value);
268 
269         callOptionalReturn(
270             token,
271             abi.encodeWithSelector(
272                 token.approve.selector,
273                 spender,
274                 newAllowance
275             )
276         );
277     }
278 
279     function callOptionalReturn(
280         IERC20 token,
281         bytes memory data
282     )
283         private
284     {
285         require(
286             address(token).isContract(),
287             'SafeERC20: call to non-contract'
288         );
289 
290         (bool success, bytes memory returndata) = address(token).call(data);
291         require(
292             success,
293             'SafeERC20: low-level call failed'
294         );
295 
296         if (returndata.length > 0) {
297             require(
298                 abi.decode(returndata, (bool)),
299                 'SafeERC20: ERC20 operation did not succeed'
300             );
301         }
302     }
303 }
304 
305 contract LPTokenWrapper {
306 
307     using SafeMath for uint256;
308     using SafeERC20 for IERC20;
309 
310     IERC20 public uni = IERC20(
311         0x44c21F5DCB285D92320AE345C92e8B6204Be8CdF
312     );
313 
314     uint256 private _totalSupply;
315     mapping(address => uint256) private _balances;
316 
317     function totalSupply() public view returns (uint256) {
318         return _totalSupply;
319     }
320 
321     function balanceOf(address account) public view returns (uint256) {
322         return _balances[account];
323     }
324 
325     function _stake(uint256 amount) internal {
326 
327         _totalSupply = _totalSupply.add(amount);
328 
329         _balances[msg.sender] =
330         _balances[msg.sender].add(amount);
331 
332         uni.safeTransferFrom(
333             msg.sender,
334             address(this),
335             amount
336         );
337     }
338 
339     function _withdraw(uint256 amount) internal {
340 
341         _totalSupply = _totalSupply.sub(amount);
342 
343         _balances[msg.sender] =
344         _balances[msg.sender].sub(amount);
345 
346         uni.safeTransfer(
347             msg.sender,
348             amount
349         );
350     }
351 }
352 
353 contract dgStaking3 is LPTokenWrapper, Ownable {
354 
355     using SafeMath for uint256;
356     using SafeERC20 for IERC20;
357 
358     IERC20 public dg = IERC20(
359         0xEE06A81a695750E71a662B51066F2c74CF4478a0
360     );
361 
362     uint256 public constant DURATION = 5 weeks;
363     
364     uint256 public periodFinish;
365     uint256 public rewardRate;
366     uint256 public lastUpdateTime;
367     uint256 public rewardPerTokenStored;
368 
369     mapping(address => uint256) public userRewardPerTokenPaid;
370     mapping(address => uint256) public rewards;
371 
372     event RewardAdded(
373         uint256 reward
374     );
375 
376     event Staked(
377         address indexed user,
378         uint256 amount
379     );
380 
381     event Withdrawn(
382         address indexed user,
383         uint256 amount
384     );
385 
386     event RewardPaid(
387         address indexed user,
388         uint256 reward
389     );
390 
391     modifier updateReward(address account) {
392 
393         rewardPerTokenStored = rewardPerToken();
394         lastUpdateTime = lastTimeRewardApplicable();
395 
396         if (account != address(0)) {
397             rewards[account] = earned(account);
398             userRewardPerTokenPaid[account] = rewardPerTokenStored;
399         }
400         _;
401     }
402 
403     function lastTimeRewardApplicable()
404         public
405         view
406         returns (uint256)
407     {
408         return Math.min(
409             block.timestamp,
410             periodFinish
411         );
412     }
413 
414     function rewardPerToken()
415         public
416         view
417         returns (uint256)
418     {
419         if (totalSupply() == 0) {
420             return rewardPerTokenStored;
421         }
422 
423         return rewardPerTokenStored.add(
424             lastTimeRewardApplicable()
425                 .sub(lastUpdateTime)
426                 .mul(rewardRate)
427                 .mul(1e18)
428                 .div(totalSupply())
429         );
430     }
431 
432     function earned(
433         address account
434     )
435         public
436         view
437         returns (uint256)
438     {
439         return balanceOf(account)
440             .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
441             .div(1E18)
442             .add(rewards[account]);
443     }
444 
445     function stake(
446         uint256 amount
447     )
448         public
449         updateReward(msg.sender)
450     {
451         require(
452             amount > 0,
453             'Cannot stake 0'
454         );
455 
456         _stake(amount);
457 
458         emit Staked(
459             msg.sender,
460             amount
461         );
462     }
463 
464     function withdraw(
465         uint256 amount
466     )
467         public
468         updateReward(msg.sender)
469     {
470         require(
471             amount > 0,
472             'Cannot withdraw 0'
473         );
474 
475         _withdraw(amount);
476 
477         emit Withdrawn(
478             msg.sender,
479             amount
480         );
481     }
482 
483     function exit() external {
484         withdraw(balanceOf(msg.sender));
485         getReward();
486     }
487 
488     function getReward()
489         public
490         updateReward(msg.sender)
491         returns (uint256 reward)
492     {
493         reward = earned(msg.sender);
494         if (reward > 0) {
495             rewards[msg.sender] = 0;
496             dg.safeTransfer(msg.sender, reward);
497             emit RewardPaid(msg.sender, reward);
498         }
499     }
500 
501     function notifyRewardAmount(uint256 reward)
502         external
503         onlyOwner
504         updateReward(address(0x0))
505     {
506         if (block.timestamp >= periodFinish) {
507             rewardRate = reward.div(DURATION);
508         } else {
509             uint256 remaining = periodFinish.sub(block.timestamp);
510             uint256 leftover = remaining.mul(rewardRate);
511             rewardRate = reward.add(leftover).div(DURATION);
512         }
513         lastUpdateTime = block.timestamp;
514         periodFinish = block.timestamp.add(DURATION);
515         emit RewardAdded(reward);
516     }
517 }