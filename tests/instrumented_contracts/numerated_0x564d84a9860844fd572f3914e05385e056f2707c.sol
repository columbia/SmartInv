1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.7.0;
3 
4 library Address {
5   function isContract(address account) internal view returns (bool) {
6     uint256 size;
7     assembly { size := extcodesize(account) }
8     return size > 0;
9   }
10 
11   function sendValue(address payable recipient, uint256 amount) internal {
12     require(address(this).balance >= amount, "Address: insufficient balance");
13     (bool success, ) = recipient.call{ value: amount }("");
14     require(success, "Address: unable to send value, recipient may have reverted");
15   }
16 
17   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
18     return functionCall(target, data, "Address: low-level call failed");
19   }
20 
21   function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
22     return _functionCallWithValue(target, data, 0, errorMessage);
23   }
24 
25   function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
26     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
27   }
28 
29   function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
30     require(address(this).balance >= value, "Address: insufficient balance for call");
31     return _functionCallWithValue(target, data, value, errorMessage);
32   }
33 
34   function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
35     require(isContract(target), "Address: call to non-contract");
36     (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
37     if (success) {
38       return returndata;
39     } else {
40       if (returndata.length > 0) {
41         assembly {
42           let returndata_size := mload(returndata)
43           revert(add(32, returndata), returndata_size)
44         }
45       } else {
46         revert(errorMessage);
47       }
48     }
49   }
50 }
51 
52 library SafeMath {
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     require(c >= a, "SafeMath: addition overflow");
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     return sub(a, b, "SafeMath: subtraction overflow");
61   }
62 
63   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64     require(b <= a, errorMessage);
65     uint256 c = a - b;
66     return c;
67   }
68 
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     if (a == 0) {
71       return 0;
72     }
73     uint256 c = a * b;
74     require(c / a == b, "SafeMath: multiplication overflow");
75     return c;
76   }
77 
78   function div(uint256 a, uint256 b) internal pure returns (uint256) {
79     return div(a, b, "SafeMath: division by zero");
80   }
81 
82   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83     require(b > 0, errorMessage);
84     uint256 c = a / b;
85     return c;
86   }
87 
88   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89     return mod(a, b, "SafeMath: modulo by zero");
90   }
91 
92   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
93     require(b != 0, errorMessage);
94     return a % b;
95   }
96 }
97 
98 library SafeERC20 {
99   using SafeMath for uint256;
100   using Address for address;
101 
102   function safeTransfer(IERC20 token, address to, uint256 value) internal {
103     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
104   }
105 
106   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
107     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
108   }
109 
110   function safeApprove(IERC20 token, address spender, uint256 value) internal {
111     require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");
112     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
113   }
114 
115   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
116     uint256 newAllowance = token.allowance(address(this), spender).add(value);
117     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
118   }
119 
120   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
121     uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
122     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
123   }
124 
125   function _callOptionalReturn(IERC20 token, bytes memory data) private {
126     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
127     if (returndata.length > 0) {
128       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
129     }
130   }
131 }
132 
133 library TransferHelper {
134   function safeApprove(address token, address to, uint value) internal {
135     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
136     require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
137   }
138 
139   function safeTransfer(address token, address to, uint value) internal {
140     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
141     require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
142   }
143 
144   function safeTransferFrom(address token, address from, address to, uint value) internal {
145     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
146     require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
147   }
148 }
149 
150 interface IERC20 {
151   function totalSupply() external view returns (uint256);
152   function balanceOf(address account) external view returns (uint256);
153   function transfer(address recipient, uint256 amount) external returns (bool);
154   function allowance(address owner, address spender) external view returns (uint256);
155   function approve(address spender, uint256 amount) external returns (bool);
156   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
157   event Transfer(address indexed from, address indexed to, uint256 value);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 interface IFarmFactory {
162   function userEnteredFarm(address _user) external;
163   function userLeftFarm(address _user) external;
164   function registerFarm(address _farmAddress) external;
165 }
166 
167 
168 contract FarmUniswap {
169   using SafeMath for uint256;
170   using SafeERC20 for IERC20;
171 
172   /// @notice information stuct on each user than stakes LP tokens.
173   struct UserInfo {
174     uint256 amount;     // How many LP tokens the user has provided.
175     uint256 rewardDebt; // Reward debt.
176   }
177 
178   /// @notice all the settings for this farm in one struct
179   struct FarmInfo {
180     IERC20 lpToken;
181     IERC20 rewardToken;
182     uint256 startBlock;
183     uint256 blockReward;
184     uint256 bonusEndBlock;
185     uint256 bonus;
186     uint256 endBlock;
187     uint256 lastRewardBlock;   // Last block number that reward distribution occurs.
188     uint256 accRewardPerShare; // Accumulated Rewards per share, times 1e12
189     uint256 farmableSupply;    // set in init, total amount of tokens farmable
190     uint256 numFarmers;
191   }
192 
193   /// @notice farm type id. Useful for back-end systems to know how to read the contract (ABI) as we plan to launch multiple farm types
194   uint256 public farmType = 1;
195 
196   IFarmFactory public factory;
197   address public farmGenerator;
198 
199   FarmInfo public farmInfo;
200 
201   /// @notice information on each user than stakes LP tokens
202   mapping (address => UserInfo) public userInfo;
203 
204   event Deposit(address indexed user, uint256 amount);
205   event Withdraw(address indexed user, uint256 amount);
206   event EmergencyWithdraw(address indexed user, uint256 amount);
207 
208   constructor(address _factory, address _farmGenerator) public {
209     factory = IFarmFactory(_factory);
210     farmGenerator = _farmGenerator;
211   }
212 
213   /**
214    * @notice initialize the farming contract. This is called only once upon farm creation and the FarmGenerator ensures the farm has the correct paramaters
215    */
216   function init(IERC20 _rewardToken, uint256 _amount, IERC20 _lpToken, uint256 _blockReward, uint256 _startBlock, uint256 _endBlock, uint256 _bonusEndBlock, uint256 _bonus) public {
217     address msgSender = _msgSender();
218     require(msgSender == address(farmGenerator), 'FORBIDDEN');
219 
220     TransferHelper.safeTransferFrom(address(_rewardToken), msgSender, address(this), _amount);
221     farmInfo.rewardToken = _rewardToken;
222 
223     farmInfo.startBlock = _startBlock;
224     farmInfo.blockReward = _blockReward;
225     farmInfo.bonusEndBlock = _bonusEndBlock;
226     farmInfo.bonus = _bonus;
227 
228     uint256 lastRewardBlock = block.number > _startBlock ? block.number : _startBlock;
229     farmInfo.lpToken = _lpToken;
230     farmInfo.lastRewardBlock = lastRewardBlock;
231     farmInfo.accRewardPerShare = 0;
232 
233     farmInfo.endBlock = _endBlock;
234     farmInfo.farmableSupply = _amount;
235   }
236 
237   /**
238    * @notice Gets the reward multiplier over the given _from_block until _to block
239    * @param _from_block the start of the period to measure rewards for
240    * @param _to the end of the period to measure rewards for
241    * @return The weighted multiplier for the given period
242    */
243   function getMultiplier(uint256 _from_block, uint256 _to) public view returns (uint256) {
244     uint256 _from = _from_block >= farmInfo.startBlock ? _from_block : farmInfo.startBlock;
245     uint256 to = farmInfo.endBlock > _to ? _to : farmInfo.endBlock;
246     if (to <= farmInfo.bonusEndBlock) {
247       return to.sub(_from).mul(farmInfo.bonus);
248     } else if (_from >= farmInfo.bonusEndBlock) {
249       return to.sub(_from);
250     } else {
251       return farmInfo.bonusEndBlock.sub(_from).mul(farmInfo.bonus).add(
252         to.sub(farmInfo.bonusEndBlock)
253       );
254     }
255   }
256 
257   /**
258    * @notice function to see accumulated balance of reward token for specified user
259    * @param _user the user for whom unclaimed tokens will be shown
260    * @return total amount of withdrawable reward tokens
261    */
262   function pendingReward(address _user) external view returns (uint256) {
263     UserInfo storage user = userInfo[_user];
264     uint256 accRewardPerShare = farmInfo.accRewardPerShare;
265     uint256 lpSupply = farmInfo.lpToken.balanceOf(address(this));
266     if (block.number > farmInfo.lastRewardBlock && lpSupply != 0) {
267       uint256 multiplier = getMultiplier(farmInfo.lastRewardBlock, block.number);
268       uint256 tokenReward = multiplier.mul(farmInfo.blockReward);
269       accRewardPerShare = accRewardPerShare.add(tokenReward.mul(1e12).div(lpSupply));
270     }
271     return user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
272   }
273 
274   /**
275    * @notice updates pool information to be up to date to the current block
276    */
277   function updatePool() public {
278     if (block.number <= farmInfo.lastRewardBlock) {
279       return;
280     }
281     uint256 lpSupply = farmInfo.lpToken.balanceOf(address(this));
282     if (lpSupply == 0) {
283       farmInfo.lastRewardBlock = block.number < farmInfo.endBlock ? block.number : farmInfo.endBlock;
284       return;
285     }
286     uint256 multiplier = getMultiplier(farmInfo.lastRewardBlock, block.number);
287     uint256 tokenReward = multiplier.mul(farmInfo.blockReward);
288     farmInfo.accRewardPerShare = farmInfo.accRewardPerShare.add(tokenReward.mul(1e12).div(lpSupply));
289     farmInfo.lastRewardBlock = block.number < farmInfo.endBlock ? block.number : farmInfo.endBlock;
290   }
291 
292   /**
293    * @notice deposit LP token function for msgSender
294    * @param _amount the total deposit amount
295    */
296   function deposit(uint256 _amount) public {
297     address msgSender = _msgSender();
298     UserInfo storage user = userInfo[msgSender];
299     updatePool();
300     if (user.amount > 0) {
301       uint256 pending = user.amount.mul(farmInfo.accRewardPerShare).div(1e12).sub(user.rewardDebt);
302       safeRewardTransfer(msgSender, pending);
303     }
304     if (user.amount == 0 && _amount > 0) {
305       factory.userEnteredFarm(msgSender);
306       farmInfo.numFarmers = farmInfo.numFarmers.add(1);
307     }
308     farmInfo.lpToken.safeTransferFrom(address(msgSender), address(this), _amount);
309     user.amount = user.amount.add(_amount);
310     user.rewardDebt = user.amount.mul(farmInfo.accRewardPerShare).div(1e12);
311     emit Deposit(msgSender, _amount);
312   }
313 
314   /**
315    * @notice withdraw LP token function for msgSender
316    * @param _amount the total withdrawable amount
317    */
318   function withdraw(uint256 _amount) public {
319     address msgSender = _msgSender();
320     UserInfo storage user = userInfo[msgSender];
321     require(user.amount >= _amount, "INSUFFICIENT");
322     updatePool();
323     if (user.amount == _amount && _amount > 0) {
324       factory.userLeftFarm(msgSender);
325       farmInfo.numFarmers = farmInfo.numFarmers.sub(1);
326     }
327     uint256 pending = user.amount.mul(farmInfo.accRewardPerShare).div(1e12).sub(user.rewardDebt);
328     safeRewardTransfer(msgSender, pending);
329     user.amount = user.amount.sub(_amount);
330     user.rewardDebt = user.amount.mul(farmInfo.accRewardPerShare).div(1e12);
331     farmInfo.lpToken.safeTransfer(address(msgSender), _amount);
332     emit Withdraw(msgSender, _amount);
333   }
334 
335   /**
336    * @notice emergency functoin to withdraw LP tokens and forego harvest rewards. Important to protect users LP tokens
337    */
338   function emergencyWithdraw() public {
339     address msgSender = _msgSender();
340     UserInfo storage user = userInfo[msgSender];
341     farmInfo.lpToken.safeTransfer(address(msgSender), user.amount);
342     emit EmergencyWithdraw(msgSender, user.amount);
343     if (user.amount > 0) {
344       factory.userLeftFarm(msgSender);
345       farmInfo.numFarmers = farmInfo.numFarmers.sub(1);
346     }
347     user.amount = 0;
348     user.rewardDebt = 0;
349   }
350 
351   /**
352    * @notice Safe reward transfer function, just in case a rounding error causes pool to not have enough reward tokens
353    * @param _to the user address to transfer tokens to
354    * @param _amount the total amount of tokens to transfer
355    */
356   function safeRewardTransfer(address _to, uint256 _amount) internal {
357     uint256 rewardBal = farmInfo.rewardToken.balanceOf(address(this));
358     if (_amount > rewardBal) {
359       farmInfo.rewardToken.transfer(_to, rewardBal);
360     } else {
361       farmInfo.rewardToken.transfer(_to, _amount);
362     }
363   }
364 
365   function _msgSender() internal view virtual returns (address payable) {
366     return msg.sender;
367   }
368 }