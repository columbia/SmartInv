1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
27         require(b <= a, errorMessage);
28         uint256 c = a - b;
29 
30         return c;
31     }
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49 
50         return c;
51     }
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         return mod(a, b, "SafeMath: modulo by zero");
54     }
55     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b != 0, errorMessage);
57         return a % b;
58     }
59 }
60 
61 library Address {
62     function isContract(address account) internal view returns (bool) {
63         bytes32 codehash;
64         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
65         // solhint-disable-next-line no-inline-assembly
66         assembly { codehash := extcodehash(account) }
67         return (codehash != 0x0 && codehash != accountHash);
68     }
69     function toPayable(address account) internal pure returns (address payable) {
70         return address(uint160(account));
71     }
72     function sendValue(address payable recipient, uint256 amount) internal {
73         require(address(this).balance >= amount, "Address: insufficient balance");
74 
75         // solhint-disable-next-line avoid-call-value
76         (bool success, ) = recipient.call{ value : amount }("");
77         require(success, "Address: unable to send value, recipient may have reverted");
78     }
79 }
80 
81 library SafeERC20 {
82     using SafeMath for uint256;
83     using Address for address;
84 
85     function safeTransfer(IERC20 token, address to, uint256 value) internal {
86         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
87     }
88 
89     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
90         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
91     }
92 
93     function safeApprove(IERC20 token, address spender, uint256 value) internal {
94         require((value == 0) || (token.allowance(address(this), spender) == 0),
95             "SafeERC20: approve from non-zero to non-zero allowance"
96         );
97         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
98     }
99 
100     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
101         uint256 newAllowance = token.allowance(address(this), spender).add(value);
102         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
103     }
104 
105     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
106         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
107         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
108     }
109     function callOptionalReturn(IERC20 token, bytes memory data) private {
110         require(address(token).isContract(), "SafeERC20: call to non-contract");
111 
112         // solhint-disable-next-line avoid-low-level-calls
113         (bool success, bytes memory returndata) = address(token).call(data);
114         require(success, "SafeERC20: low-level call failed");
115 
116         if (returndata.length > 0) { // Return data is optional
117             // solhint-disable-next-line max-line-length
118             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
119         }
120     }
121 }
122 
123 
124 contract pVaultV2 {
125     using SafeERC20 for IERC20;
126     using Address for address;
127     using SafeMath for uint256;
128     
129     struct Reward {
130         uint256 amount;
131         uint256 timestamp;
132         uint256 totalDeposit;
133     }
134 
135     mapping(address => uint256) public _lastCheckTime;
136     mapping(address => uint256) public _rewardBalance;
137     mapping(address => uint256) public _depositBalances;
138 
139     uint256 public _totalDeposit;
140 
141     Reward[] public _rewards;
142 
143     string public _vaultName;
144     IERC20 public token0;
145     IERC20 public token1;
146     address public feeAddress;
147     address public vaultAddress;
148     uint32 public feePermill = 5;
149     uint256 public delayDuration = 7 days;
150     bool public withdrawable;
151     
152     address public gov;
153 
154     uint256 public _rewardCount;
155 
156     event SentReward(uint256 amount);
157     event Deposited(address indexed user, uint256 amount);
158     event ClaimedReward(address indexed user, uint256 amount);
159     event Withdrawn(address indexed user, uint256 amount);
160 
161     constructor (address _token0, address _token1, address _feeAddress, address _vaultAddress, string memory name) {
162         token0 = IERC20(_token0);
163         token1 = IERC20(_token1);
164         feeAddress = _feeAddress;
165         vaultAddress = _vaultAddress;
166         _vaultName = name;
167         gov = msg.sender;
168     }
169 
170     modifier onlyGov() {
171         require(msg.sender == gov, "!governance");
172         _;
173     }
174 
175     function setGovernance(address _gov)
176         external
177         onlyGov
178     {
179         gov = _gov;
180     }
181 
182     function setToken0(address _token)
183         external
184         onlyGov
185     {
186         token0 = IERC20(_token);
187     }
188 
189     function setToken1(address _token)
190         external
191         onlyGov
192     {
193         token1 = IERC20(_token);
194     }
195 
196     function setFeeAddress(address _feeAddress)
197         external
198         onlyGov
199     {
200         feeAddress = _feeAddress;
201     }
202 
203     function setVaultAddress(address _vaultAddress)
204         external
205         onlyGov
206     {
207         vaultAddress = _vaultAddress;
208     }
209 
210     function setFeePermill(uint32 _feePermill)
211         external
212         onlyGov
213     {
214         feePermill = _feePermill;
215     }
216 
217     function setDelayDuration(uint32 _delayDuration)
218         external
219         onlyGov
220     {
221         delayDuration = _delayDuration;
222     }
223 
224     function setWithdrawable(bool _withdrawable)
225         external
226         onlyGov
227     {
228         withdrawable = _withdrawable;
229     }
230 
231     function setVaultName(string memory name)
232         external
233         onlyGov
234     {
235         _vaultName = name;
236     }
237 
238     function balance0()
239         external
240         view
241         returns (uint256)
242     {
243         return token0.balanceOf(address(this));
244     }
245 
246     function balance1()
247         external
248         view
249         returns (uint256)
250     {
251         return token1.balanceOf(address(this));
252     }
253 
254     function getReward(address userAddress)
255         internal
256     {
257         uint256 lastCheckTime = _lastCheckTime[userAddress];
258         uint256 rewardBalance = _rewardBalance[userAddress];
259         if (lastCheckTime > 0 && _rewards.length > 0) {
260             for (uint i = _rewards.length - 1; lastCheckTime < _rewards[i].timestamp; i--) {
261                 rewardBalance = rewardBalance.add(_rewards[i].amount.mul(_depositBalances[userAddress]).div(_rewards[i].totalDeposit));
262                 if (i == 0) break;
263             }
264         }
265         _rewardBalance[userAddress] = rewardBalance;
266         _lastCheckTime[msg.sender] = block.timestamp;
267     }
268 
269     function deposit(uint256 amount) external {
270         getReward(msg.sender);
271 
272         uint256 feeAmount = amount.mul(feePermill).div(1000);
273         uint256 realAmount = amount.sub(feeAmount);
274         
275         if (feeAmount > 0) {
276             token0.safeTransferFrom(msg.sender, feeAddress, feeAmount);
277         }
278         if (realAmount > 0) {
279             token0.safeTransferFrom(msg.sender, vaultAddress, realAmount);
280             _depositBalances[msg.sender] = _depositBalances[msg.sender].add(realAmount);
281             _totalDeposit = _totalDeposit.add(realAmount);
282             emit Deposited(msg.sender, realAmount);
283         }
284     }
285 
286     function withdraw(uint256 amount) external {
287         require(token0.balanceOf(address(this)) > 0, "no withdraw amount");
288         require(withdrawable, "not withdrawable");
289         getReward(msg.sender);
290 
291         if (amount > _depositBalances[msg.sender]) {
292             amount = _depositBalances[msg.sender];
293         }
294 
295         require(amount > 0, "can't withdraw 0");
296 
297         token0.safeTransfer(msg.sender, amount);
298 
299         _depositBalances[msg.sender] = _depositBalances[msg.sender].sub(amount);
300         _totalDeposit = _totalDeposit.sub(amount);
301 
302         emit Withdrawn(msg.sender, amount);
303     }
304 
305     function sendReward(uint256 amount) external {
306         require(amount > 0, "can't reward 0");
307         require(_totalDeposit > 0, "totalDeposit must bigger than 0");
308         token1.safeTransferFrom(msg.sender, address(this), amount);
309 
310         Reward memory reward;
311         reward = Reward(amount, block.timestamp, _totalDeposit);
312         _rewards.push(reward);
313         emit SentReward(amount);
314     }
315 
316     function claimReward(uint256 amount) external {
317         getReward(msg.sender);
318 
319         uint256 rewardLimit = getRewardAmount(msg.sender);
320 
321         if (amount > rewardLimit) {
322             amount = rewardLimit;
323         }
324         _rewardBalance[msg.sender] = _rewardBalance[msg.sender].sub(amount);
325         token1.safeTransfer(msg.sender, amount);
326     }
327 
328     function claimRewardAll() external {
329         getReward(msg.sender);
330         
331         uint256 rewardLimit = getRewardAmount(msg.sender);
332         
333         _rewardBalance[msg.sender] = _rewardBalance[msg.sender].sub(rewardLimit);
334         token1.safeTransfer(msg.sender, rewardLimit);
335     }
336     
337     function getRewardAmount(address userAddress) public view returns (uint256) {
338         uint256 lastCheckTime = _lastCheckTime[userAddress];
339         uint256 rewardBalance = _rewardBalance[userAddress];
340         if (_rewards.length > 0) {
341             if (lastCheckTime > 0) {
342                 for (uint i = _rewards.length - 1; lastCheckTime < _rewards[i].timestamp; i--) {
343                     rewardBalance = rewardBalance.add(_rewards[i].amount.mul(_depositBalances[userAddress]).div(_rewards[i].totalDeposit));
344                     if (i == 0) break;
345                 }
346             }
347             
348             for (uint j = _rewards.length - 1; block.timestamp < _rewards[j].timestamp.add(delayDuration); j--) {
349                 uint256 timedAmount = _rewards[j].amount.mul(_depositBalances[userAddress]).div(_rewards[j].totalDeposit);
350                 timedAmount = timedAmount.mul(_rewards[j].timestamp.add(delayDuration).sub(block.timestamp)).div(delayDuration);
351                 rewardBalance = rewardBalance.sub(timedAmount);
352                 if (j == 0) break;
353             }
354         }
355         return rewardBalance;
356     }
357 }