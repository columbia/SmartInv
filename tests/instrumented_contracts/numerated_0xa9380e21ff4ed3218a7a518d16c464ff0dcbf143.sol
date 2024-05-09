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
305 // staking token (the one you need to stake aka send to contract)
306 contract LPTokenWrapper {
307 
308     using SafeMath for uint256;
309     using SafeERC20 for IERC20;
310 
311     IERC20 public bpt = IERC20(
312         0xca54C398195FCE98856888b0FD97a9470a140F71
313     );
314 
315     uint256 private _totalSupply;
316     mapping(address => uint256) private _balances;
317 
318     function totalSupply() public view returns (uint256) {
319         return _totalSupply;
320     }
321 
322     function balanceOf(address account) public view returns (uint256) {
323         return _balances[account];
324     }
325 
326     function _stake(uint256 amount) internal {
327 
328         _totalSupply = _totalSupply.add(amount);
329 
330         _balances[msg.sender] =
331         _balances[msg.sender].add(amount);
332 
333         bpt.safeTransferFrom(
334             msg.sender,
335             address(this),
336             amount
337         );
338     }
339 
340     function _withdraw(uint256 amount) internal {
341 
342         _totalSupply = _totalSupply.sub(amount);
343 
344         _balances[msg.sender] =
345         _balances[msg.sender].sub(amount);
346 
347         bpt.safeTransfer(
348             msg.sender,
349             amount
350         );
351     }
352 }
353 
354 // reward token (the one that you get paid in back)
355 contract dgStaking is LPTokenWrapper, Ownable {
356 
357     using SafeMath for uint256;
358     using SafeERC20 for IERC20;
359 
360     IERC20 public dg = IERC20(
361         0xEE06A81a695750E71a662B51066F2c74CF4478a0
362     );
363 
364     // staking distribution duration (365 days)
365     uint256 public constant DURATION = 5 weeks;
366     
367     uint256 public periodFinish;
368     uint256 public rewardRate;
369     uint256 public lastUpdateTime;
370     uint256 public rewardPerTokenStored;
371 
372     mapping(address => uint256) public userRewardPerTokenPaid;
373     mapping(address => uint256) public rewards;
374 
375     event RewardAdded(
376         uint256 reward
377     );
378 
379     event Staked(
380         address indexed user,
381         uint256 amount
382     );
383 
384     event Withdrawn(
385         address indexed user,
386         uint256 amount
387     );
388 
389     event RewardPaid(
390         address indexed user,
391         uint256 reward
392     );
393 
394     modifier updateReward(address account) {
395 
396         rewardPerTokenStored = rewardPerToken();
397         lastUpdateTime = lastTimeRewardApplicable();
398 
399         if (account != address(0)) {
400             rewards[account] = earned(account);
401             userRewardPerTokenPaid[account] = rewardPerTokenStored;
402         }
403         _;
404     }
405 
406     function lastTimeRewardApplicable()
407         public
408         view
409         returns (uint256)
410     {
411         return Math.min(
412             block.timestamp,
413             periodFinish
414         );
415     }
416 
417     function rewardPerToken()
418         public
419         view
420         returns (uint256)
421     {
422         if (totalSupply() == 0) {
423             return rewardPerTokenStored;
424         }
425 
426         return rewardPerTokenStored.add(
427             lastTimeRewardApplicable()
428                 .sub(lastUpdateTime)
429                 .mul(rewardRate)
430                 .mul(1e18)
431                 .div(totalSupply())
432         );
433     }
434 
435     function earned(
436         address account
437     )
438         public
439         view
440         returns (uint256)
441     {
442         return balanceOf(account)
443             .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
444             .div(1E18)
445             .add(rewards[account]);
446     }
447 
448     function stake(
449         uint256 amount
450     )
451         public
452         updateReward(msg.sender)
453     {
454         require(
455             amount > 0,
456             'Cannot stake 0'
457         );
458 
459         _stake(amount);
460 
461         emit Staked(
462             msg.sender,
463             amount
464         );
465     }
466 
467     function withdraw(
468         uint256 amount
469     )
470         public
471         updateReward(msg.sender)
472     {
473         require(
474             amount > 0,
475             'Cannot withdraw 0'
476         );
477 
478         _withdraw(amount);
479 
480         emit Withdrawn(
481             msg.sender,
482             amount
483         );
484     }
485 
486     function exit() external {
487         withdraw(balanceOf(msg.sender));
488         getReward();
489     }
490 
491     function getReward()
492         public
493         updateReward(msg.sender)
494         returns (uint256 reward)
495     {
496         reward = earned(msg.sender);
497         if (reward > 0) {
498             rewards[msg.sender] = 0;
499             dg.safeTransfer(msg.sender, reward);
500             emit RewardPaid(msg.sender, reward);
501         }
502     }
503 
504     function notifyRewardAmount(uint256 reward)
505         external
506         onlyOwner
507         updateReward(address(0x0))
508     {
509         if (block.timestamp >= periodFinish) {
510             rewardRate = reward.div(DURATION);
511         } else {
512             uint256 remaining = periodFinish.sub(block.timestamp);
513             uint256 leftover = remaining.mul(rewardRate);
514             rewardRate = reward.add(leftover).div(DURATION);
515         }
516         lastUpdateTime = block.timestamp;
517         periodFinish = block.timestamp.add(DURATION);
518         emit RewardAdded(reward);
519     }
520 }