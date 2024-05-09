1 library Math {
2   function max(uint a, uint b) internal pure returns (uint) {
3     return a >= b ? a : b;
4   }
5 
6   function min(uint a, uint b) internal pure returns (uint) {
7     return a < b ? a : b;
8   }
9 
10   function average(uint a, uint b) internal pure returns (uint) {
11     // (a + b) / 2 can overflow, so we distribute
12     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
13   }
14 }
15 
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      *
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      *
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      *
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      *
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      *
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      *
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 contract Ownable {
160 
161   address public owner;
162 
163   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
164 
165   constructor() internal {
166     owner = msg.sender;
167     emit OwnershipTransferred(address(0), owner);
168   }
169 
170   modifier onlyOwner() {
171     require(isOwner(), "Ownable: caller is not the owner");
172     _;
173   }
174 
175   function isOwner() public view returns (bool) {
176     return msg.sender == owner;
177   }
178 
179   function renounceOwnership() public onlyOwner {
180     emit OwnershipTransferred(owner, address(0));
181     owner = address(0);
182   }
183 
184   function transferOwnership(address newOwner) public onlyOwner {
185     _transferOwnership(newOwner);
186   }
187 
188   function _transferOwnership(address newOwner) internal {
189     require(newOwner != address(0), "Ownable: new owner is the zero address");
190     emit OwnershipTransferred(owner, newOwner);
191     owner = newOwner;
192   }
193 }
194 
195 library Address {
196     /**
197      * @dev Returns true if `account` is a contract.
198      *
199      * This test is non-exhaustive, and there may be false-negatives: during the
200      * execution of a contract's constructor, its address will be reported as
201      * not containing a contract.
202      *
203      * IMPORTANT: It is unsafe to assume that an address for which this
204      * function returns false is an externally-owned account (EOA) and not a
205      * contract.
206      */
207     function isContract(address account) internal view returns (bool) {
208         // This method relies in extcodesize, which returns 0 for contracts in
209         // construction, since the code is only stored at the end of the
210         // constructor execution.
211 
212         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
213         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
214         // for accounts without code, i.e. `keccak256('')`
215         bytes32 codehash;
216         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
217         // solhint-disable-next-line no-inline-assembly
218         assembly { codehash := extcodehash(account) }
219         return (codehash != 0x0 && codehash != accountHash);
220     }
221 
222     /**
223      * @dev Converts an `address` into `address payable`. Note that this is
224      * simply a type cast: the actual underlying value is not changed.
225      *
226      * _Available since v2.4.0._
227      */
228     function toPayable(address account) internal pure returns (address payable) {
229         return address(uint160(account));
230     }
231 
232     /**
233      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
234      * `recipient`, forwarding all available gas and reverting on errors.
235      *
236      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
237      * of certain opcodes, possibly making contracts go over the 2300 gas limit
238      * imposed by `transfer`, making them unable to receive funds via
239      * `transfer`. {sendValue} removes this limitation.
240      *
241      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
242      *
243      * IMPORTANT: because control is transferred to `recipient`, care must be
244      * taken to not create reentrancy vulnerabilities. Consider using
245      * {ReentrancyGuard} or the
246      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
247      *
248      * _Available since v2.4.0._
249      */
250     function sendValue(address payable recipient, uint amount) internal {
251         require(address(this).balance >= amount, "Address: insufficient balance");
252 
253         // solhint-disable-next-line avoid-call-value
254         (bool success, ) = recipient.call { value: amount }("");
255         require(success, "Address: unable to send value, recipient may have reverted");
256     }
257 }
258 
259 interface IERC20 {
260   function totalSupply() external view returns (uint);
261   function balanceOf(address account) external view returns (uint);
262   function transfer(address recipient, uint amount) external returns (bool);
263   function allowance(address owner, address spender) external view returns (uint);
264   function approve(address spender, uint amount) external returns (bool);
265   function transferFrom(address sender, address recipient, uint amount) external returns (bool);
266   event Transfer(address indexed from, address indexed to, uint value);
267   event Approval(address indexed owner, address indexed spender, uint value);
268 }
269 
270 interface IRewardReceiver {
271 
272   function pushRewards() external;
273 }
274 
275 contract StakingRewards is Ownable {
276 
277   using SafeMath for uint;
278 
279   IERC20 public lpt;
280   IERC20 public rewardToken;
281 
282   uint public totalSupply;
283   uint public DURATION = 7 days;
284   IRewardReceiver public rewardReceiver;
285 
286   uint public starttime;
287   uint public periodFinish = 0;
288   uint public rewardRate = 0;
289   uint public lastUpdateTime;
290   uint public rewardPerTokenStored;
291 
292   mapping(address => uint) public userRewardPerTokenPaid;
293   mapping(address => uint) public rewards;
294   mapping(address => uint) public balanceOf;
295 
296   event RewardAdded(uint reward);
297   event Staked(address indexed user, uint amount);
298   event Withdrawn(address indexed user, uint amount);
299   event RewardPaid(address indexed user, uint reward);
300 
301   constructor(address _rewardToken, address _lptoken, IRewardReceiver _rewardReceiver) public {
302     rewardToken  = IERC20(_rewardToken);
303     lpt = IERC20(_lptoken);
304     rewardReceiver = _rewardReceiver;
305     starttime = block.timestamp;
306   }
307 
308   modifier checkStart() {
309     require(block.timestamp >= starttime, "not start");
310     _;
311   }
312 
313   modifier updateReward(address _account) {
314     rewardPerTokenStored = rewardPerToken();
315     lastUpdateTime = lastTimeRewardApplicable();
316     if (_account != address(0)) {
317       rewards[_account] = earned(_account);
318       userRewardPerTokenPaid[_account] = rewardPerTokenStored;
319     }
320     _;
321   }
322 
323   modifier pullRewards() {
324     rewardReceiver.pushRewards();
325     _;
326   }
327 
328   function lastTimeRewardApplicable() public view returns (uint) {
329     return Math.min(block.timestamp, periodFinish);
330   }
331 
332   function rewardPerToken() public view returns (uint) {
333     if (totalSupply == 0) {
334       return rewardPerTokenStored;
335     }
336     return
337       rewardPerTokenStored.add(
338         lastTimeRewardApplicable()
339           .sub(lastUpdateTime)
340           .mul(rewardRate)
341           .mul(1e18)
342           .div(totalSupply)
343       );
344   }
345 
346   function earned(address _account) public view returns (uint) {
347     return
348       balanceOf[_account]
349         .mul(rewardPerToken().sub(userRewardPerTokenPaid[_account]))
350         .div(1e18)
351         .add(rewards[_account]);
352   }
353 
354   // stake visibility is public as overriding LPTokenWrapper's stake() function
355   function stake(uint _amount) public pullRewards updateReward(msg.sender) checkStart {
356     require(_amount > 0, "Cannot stake 0");
357     totalSupply = totalSupply.add(_amount);
358     balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
359     lpt.transferFrom(msg.sender, address(this), _amount);
360     emit Staked(msg.sender, _amount);
361   }
362 
363   function withdraw(uint _amount) public pullRewards updateReward(msg.sender) checkStart {
364     require(_amount > 0, "Cannot withdraw 0");
365     totalSupply = totalSupply.sub(_amount);
366     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
367     lpt.transfer(msg.sender, _amount);
368     emit Withdrawn(msg.sender, _amount);
369   }
370 
371   function exit() public {
372     withdraw(balanceOf[msg.sender]);
373     getReward();
374   }
375 
376   function getReward() public updateReward(msg.sender) checkStart {
377     uint reward = earned(msg.sender);
378     if (reward > 0) {
379       rewards[msg.sender] = 0;
380       rewardToken.transfer(msg.sender, reward);
381       emit RewardPaid(msg.sender, reward);
382     }
383   }
384 
385   function notifyRewardAmount(uint _reward)
386     public
387     updateReward(address(0))
388   {
389     require(msg.sender == owner || msg.sender == address(rewardReceiver), "invalid reward source");
390 
391     if (block.timestamp > starttime) {
392       if (block.timestamp >= periodFinish) {
393         rewardRate = _reward.div(DURATION);
394       } else {
395         uint remaining = periodFinish.sub(block.timestamp);
396         uint leftover = remaining.mul(rewardRate);
397         rewardRate = _reward.add(leftover).div(DURATION);
398       }
399       lastUpdateTime = block.timestamp;
400       periodFinish = block.timestamp.add(DURATION);
401       emit RewardAdded(_reward);
402     } else {
403       rewardRate = _reward.div(DURATION);
404       lastUpdateTime = starttime;
405       periodFinish = starttime.add(DURATION);
406       emit RewardAdded(_reward);
407     }
408   }
409 }