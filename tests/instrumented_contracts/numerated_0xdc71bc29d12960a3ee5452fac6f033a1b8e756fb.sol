1 // File: contracts/math/SafeMath.sol
2 
3 pragma solidity <0.6 >=0.4.21;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15 
16   /*@CTK SafeMath_mul
17     @tag spec
18     @post __reverted == __has_assertion_failure
19     @post __has_assertion_failure == __has_overflow
20     @post __reverted == false -> c == a * b
21     @post msg == msg__post
22    */
23   /* CertiK Smart Labelling, for more details visit: https://certik.org */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     if (a == 0) {
26       return 0;
27     }
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   /*@CTK SafeMath_div
37     @tag spec
38     @pre b != 0
39     @post __reverted == __has_assertion_failure
40     @post __has_overflow == true -> __has_assertion_failure == true
41     @post __reverted == false -> __return == a / b
42     @post msg == msg__post
43    */
44   /* CertiK Smart Labelling, for more details visit: https://certik.org */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return a / b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   /*@CTK SafeMath_sub
56     @tag spec
57     @post __reverted == __has_assertion_failure
58     @post __has_overflow == true -> __has_assertion_failure == true
59     @post __reverted == false -> __return == a - b
60     @post msg == msg__post
61    */
62   /* CertiK Smart Labelling, for more details visit: https://certik.org */
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   /**
69   * @dev Adds two numbers, throws on overflow.
70   */
71   /*@CTK SafeMath_add
72     @tag spec
73     @post __reverted == __has_assertion_failure
74     @post __has_assertion_failure == __has_overflow
75     @post __reverted == false -> c == a + b
76     @post msg == msg__post
77    */
78   /* CertiK Smart Labelling, for more details visit: https://certik.org */
79   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
80     c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 // File: contracts/ownership/Ownable.sol
87 
88 pragma solidity <6.0 >=0.4.0;
89 
90 
91 /**
92  * @title Ownable
93  * @dev The Ownable contract has an owner address, and provides basic authorization control
94  * functions, this simplifies the implementation of "user permissions".
95  */
96 contract Ownable {
97   address public owner;
98 
99 
100   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102 
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   constructor() public {
108     owner = msg.sender;
109   }
110 
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) public onlyOwner {
124     require(newOwner != address(0));
125     emit OwnershipTransferred(owner, newOwner);
126     owner = newOwner;
127   }
128 
129 }
130 
131 // File: contracts/token/IERC20Basic.sol
132 
133 pragma solidity <0.6 >=0.4.21;
134 
135 
136 /**
137  * @title ERC20Basic
138  * @dev Simpler version of ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/179
140  */
141 contract IERC20Basic {
142   function totalSupply() public view returns (uint256);
143   function balanceOf(address who) public view returns (uint256);
144   function transfer(address to, uint256 value) public returns (bool);
145   event Transfer(address indexed from, address indexed to, uint256 value);
146 }
147 
148 // File: contracts/token/IERC20.sol
149 
150 pragma solidity <0.6 >=0.4.21;
151 
152 
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract IERC20 is IERC20Basic {
159   function name() external view returns (string memory);
160   function symbol() external view returns (string memory);
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: contracts/token/IMintableToken.sol
168 
169 pragma solidity <0.6 >=0.4.24;
170 
171 
172 contract IMintableToken is IERC20 {
173     function mint(address, uint) external returns (bool);
174     function burn(uint) external returns (bool);
175 
176     event Minted(address indexed to, uint256 amount);
177     event Burned(address indexed from, uint256 amount);
178     event MinterAdded(address indexed minter);
179     event MinterRemoved(address indexed minter);
180 }
181 
182 // File: contracts/utils/Address.sol
183 
184 pragma solidity ^0.5.0;
185 
186 /**
187  * @dev Collection of functions related to the address type,
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * This test is non-exhaustive, and there may be false-negatives: during the
194      * execution of a contract's constructor, its address will be reported as
195      * not containing a contract.
196      *
197      * > It is unsafe to assume that an address for which this function returns
198      * false is an externally-owned account (EOA) and not a contract.
199      */
200     function isContract(address account) internal view returns (bool) {
201         // This method relies in extcodesize, which returns 0 for contracts in
202         // construction, since the code is only stored at the end of the
203         // constructor execution.
204 
205         uint256 size;
206         // solhint-disable-next-line no-inline-assembly
207         assembly { size := extcodesize(account) }
208         return size > 0;
209     }
210 }
211 
212 // File: contracts/token/SafeERC20.sol
213 
214 pragma solidity ^0.5.0;
215 
216 
217 
218 
219 /**
220  * @title SafeERC20
221  * @dev Wrappers around ERC20 operations that throw on failure (when the token
222  * contract returns false). Tokens that return no value (and instead revert or
223  * throw on failure) are also supported, non-reverting calls are assumed to be
224  * successful.
225  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
226  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
227  */
228 library SafeERC20 {
229     using SafeMath for uint256;
230     using Address for address;
231 
232     function safeTransfer(IERC20 token, address to, uint256 value) internal {
233         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
234     }
235 
236     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
237         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
238     }
239 
240     function safeApprove(IERC20 token, address spender, uint256 value) internal {
241         // safeApprove should only be called when setting an initial allowance,
242         // or when resetting it to zero. To increase and decrease it, use
243         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
244         // solhint-disable-next-line max-line-length
245         require((value == 0) || (token.allowance(address(this), spender) == 0),
246             "SafeERC20: approve from non-zero to non-zero allowance"
247         );
248         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
249     }
250 
251     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
252         uint256 newAllowance = token.allowance(address(this), spender).add(value);
253         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
254     }
255 
256     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
257         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
258         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
259     }
260 
261     /**
262      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
263      * on the return value: the return value is optional (but if data is returned, it must not be false).
264      * @param token The token targeted by the call.
265      * @param data The call data (encoded using abi.encode or one of its variants).
266      */
267     function callOptionalReturn(IERC20 token, bytes memory data) private {
268         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
269         // we're implementing it ourselves.
270 
271         // A Solidity high level call has three parts:
272         //  1. The target address is checked to verify it contains contract code
273         //  2. The call itself is made, and success asserted
274         //  3. The return value is decoded, which in turn checks the size of the returned data.
275         // solhint-disable-next-line max-line-length
276         require(address(token).isContract(), "SafeERC20: call to non-contract");
277 
278         // solhint-disable-next-line avoid-low-level-calls
279         (bool success, bytes memory returndata) = address(token).call(data);
280         require(success, "SafeERC20: low-level call failed");
281 
282         if (returndata.length > 0) { // Return data is optional
283             // solhint-disable-next-line max-line-length
284             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
285         }
286     }
287 }
288 
289 // File: contracts/uniswapv2/IRouter.sol
290 
291 pragma solidity >=0.5.0 <0.8.0;
292 
293 interface IRouter {
294     function removeLiquidity(
295         address tokenA,
296         address tokenB,
297         uint liquidity,
298         uint amountAMin,
299         uint amountBMin,
300         address to,
301         uint deadline
302     ) external returns (uint amountA, uint amountB);
303     function swapETHForExactTokens(
304         uint amountOut,
305         address[] calldata path,
306         address to,
307         uint deadline
308     ) external payable returns (uint[] memory amounts);
309     function swapExactTokensForTokens(
310         uint amountIn,
311         uint amountOutMin,
312         address[] calldata path,
313         address to,
314         uint deadline
315     ) external returns (uint[] memory amounts);
316     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
317 }
318 
319 // File: contracts/AeolusV2dot1.sol
320 
321 pragma solidity <0.6 >=0.4.24;
322 
323 
324 
325 
326 
327 
328 
329 // Aeolus is the master of Cyclone tokens. He can distribute CYC and he is a fair guy.
330 //
331 // Note that it's ownable and the owner wields tremendous power. The ownership
332 // will be transferred to a governance smart contract once CYC is sufficiently
333 // distributed and the community can show to govern itself.
334 //
335 // Have fun reading it. Hopefully it's bug-free. God bless.
336 contract AeolusV2dot1 is Ownable {
337     using SafeMath for uint256;
338     using SafeERC20 for IERC20;
339 
340     // Info of each user.
341     struct UserInfo {
342         uint256 amount;     // How many LP tokens the user has provided.
343         uint256 rewardDebt; // Reward debt. See explanation below.
344         //
345         // We do some fancy math here. Basically, any point in time, the amount of CYCs
346         // entitled to a user but is pending to be distributed is:
347         //
348         //   pending reward = (user.amount * accCYCPerShare) - user.rewardDebt
349         //
350         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
351         //   1. Update accCYCPerShare and lastRewardBlock
352         //   2. User receives the pending reward sent to his/her address.
353         //   3. User's `amount` gets updated.
354         //   4. User's `rewardDebt` gets updated.
355     }
356 
357 
358     // Address of LP token contract.
359     IERC20 public lpToken;
360     // Accumulated CYCs per share, times 1e12. See below.
361     uint256 public accCYCPerShare;
362     // Last block reward block height
363     uint256 public lastRewardBlock;
364     // Reward per block
365     uint256 public rewardPerBlock;
366     // Reward to distribute
367     uint256 public rewardToDistribute;
368     // Entrance Fee Rate
369     uint256 public entranceFeeRate;
370 
371     IERC20 public wrappedCoin;
372     IRouter public router;
373     // The Cyclone TOKEN
374     IMintableToken public cycToken;
375 
376     // Info of each user that stakes LP tokens.
377     mapping (address => UserInfo) public userInfo;
378 
379     event RewardAdded(uint256 amount, bool isBlockReward);
380     event Deposit(address indexed user, uint256 amount, uint256 fee);
381     event Withdraw(address indexed user, uint256 amount);
382     event EmergencyWithdraw(address indexed user, uint256 amount);
383 
384     constructor(IMintableToken _cycToken, IERC20 _lpToken, address _router, IERC20 _wrappedCoin) public {
385         cycToken = _cycToken;
386         lastRewardBlock = block.number;
387         lpToken = _lpToken;
388         router = IRouter(_router);
389         wrappedCoin = _wrappedCoin;
390         require(_lpToken.approve(_router, uint256(-1)), "failed to approve router");
391         require(_wrappedCoin.approve(_router, uint256(-1)), "failed to approve router");
392     }
393 
394     function setEntranceFeeRate(uint256 _entranceFeeRate) public onlyOwner {
395         require(_entranceFeeRate < 10000, "invalid entrance fee rate");
396         entranceFeeRate = _entranceFeeRate;
397     }
398 
399     function setRewardPerBlock(uint256 _rewardPerBlock) public onlyOwner {
400         updateBlockReward();
401         rewardPerBlock = _rewardPerBlock;
402     }
403 
404     function rewardPending() internal view returns (uint256) {
405         uint256 reward = block.number.sub(lastRewardBlock).mul(rewardPerBlock);
406         uint256 cycBalance = cycToken.balanceOf(address(this)).sub(rewardToDistribute);
407         if (cycBalance < reward) {
408             return cycBalance;
409         }
410         return reward;
411     }
412 
413     // View function to see pending reward on frontend.
414     function pendingReward(address _user) external view returns (uint256) {
415         UserInfo storage user = userInfo[_user];
416         uint256 acps = accCYCPerShare;
417         if (rewardPerBlock > 0) {
418             uint256 lpSupply = lpToken.balanceOf(address(this));
419             if (block.number > lastRewardBlock && lpSupply > 0) {
420                 acps = acps.add(rewardPending().mul(1e12).div(lpSupply));
421             }
422         }
423 
424         return user.amount.mul(acps).div(1e12).sub(user.rewardDebt);
425     }
426 
427     // Update reward variables to be up-to-date.
428     function updateBlockReward() public {
429         if (block.number <= lastRewardBlock || rewardPerBlock == 0) {
430             return;
431         }
432         uint256 lpSupply = lpToken.balanceOf(address(this));
433         uint256 reward = rewardPending();
434         if (lpSupply == 0 || reward == 0) {
435             lastRewardBlock = block.number;
436             return;
437         }
438         rewardToDistribute = rewardToDistribute.add(reward);
439         emit RewardAdded(reward, true);
440         lastRewardBlock = block.number;
441         accCYCPerShare = accCYCPerShare.add(reward.mul(1e12).div(lpSupply));
442     }
443 
444     // Deposit LP tokens to Aeolus for CYC allocation.
445     function deposit(uint256 _amount) public {
446         updateBlockReward();
447         UserInfo storage user = userInfo[msg.sender];
448         uint256 originAmount = user.amount;
449         uint256 acps = accCYCPerShare;
450         if (originAmount > 0) {
451             uint256 pending = originAmount.mul(acps).div(1e12).sub(user.rewardDebt);
452             if (pending > 0) {
453                 safeCYCTransfer(msg.sender, pending);
454             }
455         }
456         uint256 feeInCYC = 0;
457         if (_amount > 0) {
458             lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
459             uint256 entranceFee = _amount.mul(entranceFeeRate).div(10000);
460             if (entranceFee > 0) {
461                 IERC20 wct = wrappedCoin;
462                 (uint256 wcAmount, uint256 cycAmount) = router.removeLiquidity(address(wct), address(cycToken), entranceFee, 0, 0, address(this), block.timestamp.mul(2));
463                 if (wcAmount > 0) {
464                     address[] memory path = new address[](2);
465                     path[0] = address(wct);
466                     path[1] = address(cycToken);
467                     uint256[] memory amounts = router.swapExactTokensForTokens(wcAmount, 0, path, address(this), block.timestamp.mul(2));
468                     feeInCYC = cycAmount.add(amounts[1]);
469                 } else {
470                     feeInCYC = cycAmount;
471                 }
472                 if (feeInCYC > 0) {
473                     require(cycToken.burn(feeInCYC), "failed to burn cyc token");
474                 }
475                 _amount = _amount.sub(entranceFee);
476             }
477             user.amount = originAmount.add(_amount);
478         }
479         user.rewardDebt = user.amount.mul(acps).div(1e12);
480         emit Deposit(msg.sender, _amount, feeInCYC);
481     }
482 
483     // Withdraw LP tokens from Aeolus.
484     function withdraw(uint256 _amount) public {
485         UserInfo storage user = userInfo[msg.sender];
486         uint256 originAmount = user.amount;
487         require(originAmount >= _amount, "withdraw: not good");
488         updateBlockReward();
489         uint256 acps = accCYCPerShare;
490         uint256 pending = originAmount.mul(acps).div(1e12).sub(user.rewardDebt);
491         if (pending > 0) {
492             safeCYCTransfer(msg.sender, pending);
493         }
494         if (_amount > 0) {
495             user.amount = originAmount.sub(_amount);
496             lpToken.safeTransfer(address(msg.sender), _amount);
497         }
498         user.rewardDebt = user.amount.mul(acps).div(1e12);
499         emit Withdraw(msg.sender, _amount);
500     }
501 
502     // Withdraw without caring about rewards. EMERGENCY ONLY.
503     function emergencyWithdraw() public {
504         UserInfo storage user = userInfo[msg.sender];
505         uint256 amount = user.amount;
506         user.amount = 0;
507         user.rewardDebt = 0;
508         lpToken.safeTransfer(address(msg.sender), amount);
509         emit EmergencyWithdraw(msg.sender, amount);
510     }
511 
512     // Safe CYC transfer function, just in case if rounding error causes pool to not have enough CYCs.
513     function safeCYCTransfer(address _to, uint256 _amount) internal {
514         IMintableToken token = cycToken;
515         uint256 cycBalance = token.balanceOf(address(this));
516         if (_amount > cycBalance) {
517             _amount = cycBalance;
518         }
519         rewardToDistribute = rewardToDistribute.sub(_amount);
520         require(token.transfer(_to, _amount), "failed to transfer cyc token");
521     }
522 }