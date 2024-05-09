1 // SPDX-License-Identifier: -- 🐱 --
2 
3 pragma solidity ^0.8.0;
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
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes calldata) {
63         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
64         return msg.data;
65     }
66 }
67 
68 contract Ownable is Context {
69 
70     address private _owner;
71 
72     event OwnershipTransferred(
73         address indexed previousOwner,
74         address indexed newOwner
75     );
76 
77     constructor() {
78         _owner = _msgSender();
79         emit OwnershipTransferred(address(0), _owner);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(isOwner(), 'Ownable: caller is not the owner');
88         _;
89     }
90 
91     function isOwner() public view returns (bool) {
92         return _msgSender() == _owner;
93     }
94 
95     function renounceOwnership() public onlyOwner {
96         emit OwnershipTransferred(
97             _owner,
98             address(0x0)
99         );
100         _owner = address(0x0);
101     }
102 
103     function transferOwnership(address newOwner) public onlyOwner {
104         _transferOwnership(newOwner);
105     }
106 
107     function _transferOwnership(address newOwner) internal {
108         require(
109             newOwner != address(0x0),
110             'Ownable: new owner is the zero address'
111         );
112         emit OwnershipTransferred(_owner, newOwner);
113         _owner = newOwner;
114     }
115 }
116 
117 interface IERC20 {
118 
119     function totalSupply() external view returns (uint256);
120 
121     function balanceOf(address account) external view returns (uint256);
122 
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     function allowance(address owner, address spender) external view returns (uint256);
126 
127     function approve(address spender, uint256 amount) external returns (bool);
128 
129     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
130 
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 
136 library Address {
137     function isContract(address account) internal view returns (bool) {
138         // This method relies on extcodesize, which returns 0 for contracts in
139         // construction, since the code is only stored at the end of the
140         // constructor execution.
141 
142         uint256 size;
143         assembly {
144             size := extcodesize(account)
145         }
146         return size > 0;
147     }
148 }
149 
150 library SafeERC20 {
151 
152     using SafeMath for uint256;
153     using Address for address;
154 
155     function safeTransfer(IERC20 token, address to, uint256 value) internal {
156         callOptionalReturn(
157             token,
158             abi.encodeWithSelector(
159                 token.transfer.selector,
160                 to,
161                 value
162             )
163         );
164     }
165 
166     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
167         callOptionalReturn(
168             token,
169             abi.encodeWithSelector(
170                 token.transferFrom.selector,
171                 from,
172                 to,
173                 value
174             )
175         );
176     }
177 
178     function safeApprove(IERC20 token, address spender, uint256 value) internal {
179         require(
180             (value == 0) || (token.allowance(address(this), spender) == 0),
181             'SafeERC20: approve from non-zero to non-zero allowance'
182         );
183         callOptionalReturn(
184             token,
185             abi.encodeWithSelector(
186                 token.approve.selector,
187                 spender,
188                 value
189             )
190         );
191     }
192 
193     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
194 
195         uint256 newAllowance = token.allowance(address(this), spender).add(value);
196 
197         callOptionalReturn(
198             token,
199             abi.encodeWithSelector(
200                 token.approve.selector,
201                 spender,
202                 newAllowance
203             )
204         );
205     }
206 
207     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
208 
209         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
210 
211         callOptionalReturn(
212             token,
213             abi.encodeWithSelector(
214                 token.approve.selector,
215                 spender,
216                 newAllowance
217             )
218         );
219     }
220 
221     function callOptionalReturn(IERC20 token, bytes memory data) private {
222         require(address(token).isContract(), 'SafeERC20: call to non-contract');
223 
224         (bool success, bytes memory returndata) = address(token).call(data);
225         require(success, 'SafeERC20: low-level call failed');
226 
227         if (returndata.length > 0) {
228             require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
229         }
230     }
231 }
232 
233 contract LPTokenWrapper {
234 
235     using SafeMath for uint256;
236     using SafeERC20 for IERC20;
237 
238     IERC20 public lp = IERC20(0x14Da7b27b2E0FedEfe0a664118b0c9bc68e2E9AF);
239 
240     uint256 private _totalSupply;
241     mapping(address => uint256) private _balances;
242 
243     function totalSupply() public view returns (uint256) {
244         return _totalSupply;
245     }
246 
247     function balanceOf(address account) public view returns (uint256) {
248         return _balances[account];
249     }
250 
251     function _stake(uint256 amount) internal {
252 
253         _totalSupply = _totalSupply.add(amount);
254 
255         _balances[msg.sender] =
256         _balances[msg.sender].add(amount);
257 
258         lp.safeTransferFrom(msg.sender, address(this), amount);
259     }
260 
261     function _withdraw(uint256 amount) internal {
262 
263         _totalSupply = _totalSupply.sub(amount);
264 
265         _balances[msg.sender] =
266         _balances[msg.sender].sub(amount);
267 
268         lp.safeTransfer(msg.sender, amount);
269     }
270 }
271 
272 contract BCUGStake is LPTokenWrapper, Ownable {
273 
274     using SafeMath for uint256;
275     using SafeERC20 for IERC20;
276 
277     IERC20 public bcug = IERC20(0x14Da7b27b2E0FedEfe0a664118b0c9bc68e2E9AF);
278 
279     uint256 public constant DURATION = 4 weeks;
280 
281     uint256 public periodFinish;
282     uint256 public rewardRate;
283     uint256 public lastUpdateTime;
284     uint256 public rewardPerTokenStored;
285 
286     mapping(address => uint256) public userRewardPerTokenPaid;
287     mapping(address => uint256) public rewards;
288 
289     event RewardAdded(uint256 reward);
290     event Staked(address indexed user, uint256 amount);
291     event Withdrawn(address indexed user, uint256 amount);
292     event RewardPaid(address indexed user, uint256 reward);
293 
294     modifier updateReward(address account) {
295 
296         rewardPerTokenStored = rewardPerToken();
297         lastUpdateTime = lastTimeRewardApplicable();
298 
299         if (account != address(0)) {
300             rewards[account] = earned(account);
301             userRewardPerTokenPaid[account] = rewardPerTokenStored;
302         }
303         _;
304     }
305 
306     function lastTimeRewardApplicable() public view returns (uint256) {
307         return Math.min(block.timestamp, periodFinish);
308     }
309 
310     function rewardPerToken() public view returns (uint256) {
311         if (totalSupply() == 0) {
312             return rewardPerTokenStored;
313         }
314 
315         return rewardPerTokenStored.add(
316             lastTimeRewardApplicable()
317             .sub(lastUpdateTime)
318             .mul(rewardRate)
319             .mul(1e18)
320             .div(totalSupply())
321         );
322     }
323 
324     function earned(address account) public view returns (uint256) {
325         return balanceOf(account)
326             .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
327             .div(1E18)
328             .add(rewards[account]);
329     }
330 
331     function stake(uint256 amount) public updateReward(msg.sender) {
332         require(amount > 0, 'Cannot stake 0');
333 
334         _stake(amount);
335 
336         emit Staked(msg.sender, amount);
337     }
338 
339     function withdraw(uint256 amount) public updateReward(msg.sender) {
340         require(amount > 0, 'Cannot withdraw 0');
341 
342         _withdraw(amount);
343 
344         emit Withdrawn(msg.sender, amount);
345     }
346 
347     function exit() external {
348         withdraw(balanceOf(msg.sender));
349         getReward();
350     }
351 
352     function getReward() public updateReward(msg.sender) returns (uint256 reward) {
353         reward = earned(msg.sender);
354         if (reward > 0) {
355             rewards[msg.sender] = 0;
356             bcug.safeTransfer(msg.sender, reward);
357             emit RewardPaid(msg.sender, reward);
358         }
359     }
360 
361     function notifyRewardAmount(uint256 reward) external onlyOwner updateReward(address(0x0)) {
362         if (block.timestamp >= periodFinish) {
363             rewardRate = reward.div(DURATION);
364         } else {
365             uint256 remaining = periodFinish.sub(block.timestamp);
366             uint256 leftover = remaining.mul(rewardRate);
367             rewardRate = reward.add(leftover).div(DURATION);
368         }
369         lastUpdateTime = block.timestamp;
370         periodFinish = block.timestamp.add(DURATION);
371         emit RewardAdded(reward);
372     }
373 }