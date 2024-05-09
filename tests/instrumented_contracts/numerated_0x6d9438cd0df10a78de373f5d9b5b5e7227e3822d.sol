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
195 interface IERC20 {
196   function totalSupply() external view returns (uint);
197   function balanceOf(address account) external view returns (uint);
198   function transfer(address recipient, uint amount) external returns (bool);
199   function allowance(address owner, address spender) external view returns (uint);
200   function approve(address spender, uint amount) external returns (bool);
201   function transferFrom(address sender, address recipient, uint amount) external returns (bool);
202   event Transfer(address indexed from, address indexed to, uint value);
203   event Approval(address indexed owner, address indexed spender, uint value);
204 }
205 
206 interface IRewardReceiver {
207 
208   function pushRewards() external;
209 }
210 
211 contract StakingRewards is Ownable {
212 
213   using SafeMath for uint;
214 
215   IERC20 public lpt;
216   IERC20 public rewardToken;
217 
218   uint public totalSupply;
219   uint public DURATION = 7 days;
220   IRewardReceiver public rewardReceiver;
221 
222   uint public starttime;
223   uint public periodFinish = 0;
224   uint public rewardRate = 0;
225   uint public lastUpdateTime;
226   uint public rewardPerTokenStored;
227 
228   mapping(address => uint) public userRewardPerTokenPaid;
229   mapping(address => uint) public rewards;
230   mapping(address => uint) public balanceOf;
231 
232   event RewardAdded(uint reward);
233   event Staked(address indexed user, uint amount);
234   event Withdrawn(address indexed user, uint amount);
235   event RewardPaid(address indexed user, uint reward);
236 
237   constructor(address _rewardToken, address _lptoken, IRewardReceiver _rewardReceiver) public {
238     rewardToken  = IERC20(_rewardToken);
239     lpt = IERC20(_lptoken);
240     rewardReceiver = _rewardReceiver;
241     starttime = block.timestamp;
242   }
243 
244   modifier checkStart() {
245     require(block.timestamp >= starttime, "not start");
246     _;
247   }
248 
249   modifier updateReward(address _account) {
250     rewardPerTokenStored = rewardPerToken();
251     lastUpdateTime = lastTimeRewardApplicable();
252     if (_account != address(0)) {
253       rewards[_account] = earned(_account);
254       userRewardPerTokenPaid[_account] = rewardPerTokenStored;
255     }
256     _;
257   }
258 
259   modifier pullRewards() {
260     rewardReceiver.pushRewards();
261     _;
262   }
263 
264   function lastTimeRewardApplicable() public view returns (uint) {
265     return Math.min(block.timestamp, periodFinish);
266   }
267 
268   function rewardPerToken() public view returns (uint) {
269     if (totalSupply == 0) {
270       return rewardPerTokenStored;
271     }
272     return
273       rewardPerTokenStored.add(
274         lastTimeRewardApplicable()
275           .sub(lastUpdateTime)
276           .mul(rewardRate)
277           .mul(1e18)
278           .div(totalSupply)
279       );
280   }
281 
282   function earned(address _account) public view returns (uint) {
283     return
284       balanceOf[_account]
285         .mul(rewardPerToken().sub(userRewardPerTokenPaid[_account]))
286         .div(1e18)
287         .add(rewards[_account]);
288   }
289 
290   // stake visibility is public as overriding LPTokenWrapper's stake() function
291   function stake(uint _amount) public pullRewards updateReward(msg.sender) checkStart {
292     require(_amount > 0, "Cannot stake 0");
293     totalSupply = totalSupply.add(_amount);
294     balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
295     lpt.transferFrom(msg.sender, address(this), _amount);
296     emit Staked(msg.sender, _amount);
297   }
298 
299   function withdraw(uint _amount) public pullRewards updateReward(msg.sender) checkStart {
300     require(_amount > 0, "Cannot withdraw 0");
301     totalSupply = totalSupply.sub(_amount);
302     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
303     lpt.transfer(msg.sender, _amount);
304     emit Withdrawn(msg.sender, _amount);
305   }
306 
307   function exit() public {
308     withdraw(balanceOf[msg.sender]);
309     getReward();
310   }
311 
312   function getReward() public updateReward(msg.sender) checkStart {
313     uint reward = earned(msg.sender);
314     if (reward > 0) {
315       rewards[msg.sender] = 0;
316       rewardToken.transfer(msg.sender, reward);
317       emit RewardPaid(msg.sender, reward);
318     }
319   }
320 
321   function notifyRewardAmount(uint _reward)
322     public
323     updateReward(address(0))
324   {
325     require(msg.sender == owner || msg.sender == address(rewardReceiver), "invalid reward source");
326 
327     if (block.timestamp > starttime) {
328       if (block.timestamp >= periodFinish) {
329         rewardRate = _reward.div(DURATION);
330       } else {
331         uint remaining = periodFinish.sub(block.timestamp);
332         uint leftover = remaining.mul(rewardRate);
333         rewardRate = _reward.add(leftover).div(DURATION);
334       }
335       lastUpdateTime = block.timestamp;
336       periodFinish = block.timestamp.add(DURATION);
337       emit RewardAdded(_reward);
338     } else {
339       rewardRate = _reward.div(DURATION);
340       lastUpdateTime = starttime;
341       periodFinish = starttime.add(DURATION);
342       emit RewardAdded(_reward);
343     }
344   }
345 }