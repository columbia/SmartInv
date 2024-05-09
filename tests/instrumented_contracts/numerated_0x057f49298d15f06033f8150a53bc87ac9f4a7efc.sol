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
167 contract RewardHolder {
168   using SafeMath for uint256;
169   using SafeERC20 for IERC20;
170 
171   address public farmGenerator;
172   address public farm;
173   address public rewardToken;
174   uint256 public farmableSupply;
175 
176   constructor(address _farmGenerator, address _farm) public {
177     farmGenerator = _farmGenerator;
178     farm = _farm;
179   }
180 
181   function init(address _rewardToken, uint256 _amount) public {
182     address msgSender = msg.sender;
183     TransferHelper.safeTransferFrom(_rewardToken, msgSender, address(this), _amount);
184     TransferHelper.safeApprove(_rewardToken, farm, _amount);
185     rewardToken = _rewardToken;
186     farmableSupply = _amount;
187   }
188 }
189 
190 
191 contract FarmStaking {
192   using SafeMath for uint256;
193   using SafeERC20 for IERC20;
194 
195   /// @notice information stuct on each user than stakes tokens.
196   struct UserInfo {
197     uint256 amount;     // How many tokens the user has provided.
198     uint256 rewardDebt; // Reward debt.
199   }
200 
201   /// @notice all the settings for this farm in one struct
202   struct FarmInfo {
203     IERC20 token;
204     IERC20 rewardToken;
205     address rewardHolder;
206     uint256 startBlock;
207     uint256 blockReward;
208     uint256 bonusEndBlock;
209     uint256 bonus;
210     uint256 endBlock;
211     uint256 lastRewardBlock;   // Last block number that reward distribution occurs.
212     uint256 accRewardPerShare; // Accumulated Rewards per share, times 1e12
213     uint256 farmableSupply;    // set in init, total amount of tokens farmable
214     uint256 numFarmers;
215   }
216 
217   /// @notice farm type id. Useful for back-end systems to know how to read the contract (ABI) as we plan to launch multiple farm types
218   uint256 public farmType = 2;
219 
220   IFarmFactory public factory;
221   address public farmGenerator;
222 
223   FarmInfo public farmInfo;
224 
225   /// @notice information on each user than stakes tokens
226   mapping (address => UserInfo) public userInfo;
227 
228   event Deposit(address indexed user, uint256 amount);
229   event Withdraw(address indexed user, uint256 amount);
230   event EmergencyWithdraw(address indexed user, uint256 amount);
231 
232   constructor(address _factory, address _farmGenerator) public {
233     factory = IFarmFactory(_factory);
234     farmGenerator = _farmGenerator;
235   }
236 
237   /**
238    * @notice initialize the farming contract. This is called only once upon farm creation and the FarmGenerator ensures the farm has the correct paramaters
239    */
240   function init(address _rewardHolder, IERC20 _rewardToken, uint256 _amount, IERC20 _token, uint256 _blockReward, uint256 _startBlock, uint256 _endBlock, uint256 _bonusEndBlock, uint256 _bonus) public {
241     address msgSender = _msgSender();
242     require(msgSender == address(farmGenerator), 'FORBIDDEN');
243 
244     farmInfo.rewardToken = _rewardToken;
245     farmInfo.rewardHolder = _rewardHolder;
246 
247     farmInfo.startBlock = _startBlock;
248     farmInfo.blockReward = _blockReward;
249     farmInfo.bonusEndBlock = _bonusEndBlock;
250     farmInfo.bonus = _bonus;
251 
252     uint256 lastRewardBlock = block.number > _startBlock ? block.number : _startBlock;
253     farmInfo.token = _token;
254     farmInfo.lastRewardBlock = lastRewardBlock;
255     farmInfo.accRewardPerShare = 0;
256 
257     farmInfo.endBlock = _endBlock;
258     farmInfo.farmableSupply = _amount;
259   }
260 
261   /**
262    * @notice Gets the reward multiplier over the given _from_block until _to block
263    * @param _from_block the start of the period to measure rewards for
264    * @param _to the end of the period to measure rewards for
265    * @return The weighted multiplier for the given period
266    */
267   function getMultiplier(uint256 _from_block, uint256 _to) public view returns (uint256) {
268     uint256 _from = _from_block >= farmInfo.startBlock ? _from_block : farmInfo.startBlock;
269     uint256 to = farmInfo.endBlock > _to ? _to : farmInfo.endBlock;
270     if (to <= farmInfo.bonusEndBlock) {
271       return to.sub(_from).mul(farmInfo.bonus);
272     } else if (_from >= farmInfo.bonusEndBlock) {
273       return to.sub(_from);
274     } else {
275       return farmInfo.bonusEndBlock.sub(_from).mul(farmInfo.bonus).add(
276         to.sub(farmInfo.bonusEndBlock)
277       );
278     }
279   }
280 
281   /**
282    * @notice function to see accumulated balance of reward token for specified user
283    * @param _user the user for whom unclaimed tokens will be shown
284    * @return total amount of withdrawable reward tokens
285    */
286   function pendingReward(address _user) external view returns (uint256) {
287     UserInfo storage user = userInfo[_user];
288     uint256 accRewardPerShare = farmInfo.accRewardPerShare;
289     uint256 tokenSupply = farmInfo.token.balanceOf(address(this));
290     if (block.number > farmInfo.lastRewardBlock && tokenSupply != 0) {
291       uint256 multiplier = getMultiplier(farmInfo.lastRewardBlock, block.number);
292       uint256 tokenReward = multiplier.mul(farmInfo.blockReward);
293       accRewardPerShare = accRewardPerShare.add(tokenReward.mul(1e12).div(tokenSupply));
294     }
295     return user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
296   }
297 
298   /**
299    * @notice updates pool information to be up to date to the current block
300    */
301   function updatePool() public {
302     if (block.number <= farmInfo.lastRewardBlock) {
303       return;
304     }
305     uint256 tokenSupply = farmInfo.token.balanceOf(address(this));
306     if (tokenSupply == 0) {
307       farmInfo.lastRewardBlock = block.number < farmInfo.endBlock ? block.number : farmInfo.endBlock;
308       return;
309     }
310     uint256 multiplier = getMultiplier(farmInfo.lastRewardBlock, block.number);
311     uint256 tokenReward = multiplier.mul(farmInfo.blockReward);
312     farmInfo.accRewardPerShare = farmInfo.accRewardPerShare.add(tokenReward.mul(1e12).div(tokenSupply));
313     farmInfo.lastRewardBlock = block.number < farmInfo.endBlock ? block.number : farmInfo.endBlock;
314   }
315 
316   /**
317    * @notice deposit token function for msgSender
318    * @param _amount the total deposit amount
319    */
320   function deposit(uint256 _amount) public {
321     address msgSender = _msgSender();
322     UserInfo storage user = userInfo[msgSender];
323     updatePool();
324     if (user.amount > 0) {
325       uint256 pending = user.amount.mul(farmInfo.accRewardPerShare).div(1e12).sub(user.rewardDebt);
326       safeRewardTransfer(msgSender, pending);
327     }
328     if (user.amount == 0 && _amount > 0) {
329       factory.userEnteredFarm(msgSender);
330       farmInfo.numFarmers = farmInfo.numFarmers.add(1);
331     }
332     farmInfo.token.safeTransferFrom(address(msgSender), address(this), _amount);
333     user.amount = user.amount.add(_amount);
334     user.rewardDebt = user.amount.mul(farmInfo.accRewardPerShare).div(1e12);
335     emit Deposit(msgSender, _amount);
336   }
337 
338   /**
339    * @notice withdraw token function for msgSender
340    * @param _amount the total withdrawable amount
341    */
342   function withdraw(uint256 _amount) public {
343     address msgSender = _msgSender();
344     UserInfo storage user = userInfo[msgSender];
345     require(user.amount >= _amount, "INSUFFICIENT");
346     updatePool();
347     if (user.amount == _amount && _amount > 0) {
348       factory.userLeftFarm(msgSender);
349       farmInfo.numFarmers = farmInfo.numFarmers.sub(1);
350     }
351     uint256 pending = user.amount.mul(farmInfo.accRewardPerShare).div(1e12).sub(user.rewardDebt);
352     safeRewardTransfer(msgSender, pending);
353     user.amount = user.amount.sub(_amount);
354     user.rewardDebt = user.amount.mul(farmInfo.accRewardPerShare).div(1e12);
355     farmInfo.token.safeTransfer(address(msgSender), _amount);
356     emit Withdraw(msgSender, _amount);
357   }
358 
359   /**
360    * @notice emergency functoin to withdraw tokens and forego harvest rewards. Important to protect users tokens
361    */
362   function emergencyWithdraw() public {
363     address msgSender = _msgSender();
364     UserInfo storage user = userInfo[msgSender];
365     farmInfo.token.safeTransfer(address(msgSender), user.amount);
366     emit EmergencyWithdraw(msgSender, user.amount);
367     if (user.amount > 0) {
368       factory.userLeftFarm(msgSender);
369       farmInfo.numFarmers = farmInfo.numFarmers.sub(1);
370     }
371     user.amount = 0;
372     user.rewardDebt = 0;
373   }
374 
375   /**
376    * @notice Safe reward transfer function, just in case a rounding error causes pool to not have enough reward tokens
377    * @param _to the user address to transfer tokens to
378    * @param _amount the total amount of tokens to transfer
379    */
380   function safeRewardTransfer(address _to, uint256 _amount) internal {
381     uint256 rewardBal = farmInfo.rewardToken.balanceOf(farmInfo.rewardHolder);
382     if (_amount > rewardBal) {
383       farmInfo.rewardToken.transferFrom(farmInfo.rewardHolder, _to, rewardBal);
384     } else {
385       farmInfo.rewardToken.transferFrom(farmInfo.rewardHolder, _to, _amount);
386     }
387   }
388 
389   function _msgSender() internal view virtual returns (address payable) {
390     return msg.sender;
391   }
392 }