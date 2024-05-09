1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 
4 library SafeMath {
5 
6   /**
7    * @dev Multiplies two unsigned integers, reverts on overflow.
8    */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     uint256 c = a * b;
18     require(c / a == b, "SafeMath#mul: OVERFLOW");
19 
20     return c;
21   }
22 
23   /**
24    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
25    */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // Solidity only automatically asserts when dividing by 0
28     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31 
32     return c;
33   }
34 
35   /**
36    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37    */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     require(b <= a, "SafeMath#sub: UNDERFLOW");
40     uint256 c = a - b;
41 
42     return c;
43   }
44 
45   /**
46    * @dev Adds two unsigned integers, reverts on overflow.
47    */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     require(c >= a, "SafeMath#add: OVERFLOW");
51 
52     return c; 
53   }
54 
55   /**
56    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57    * reverts when dividing by zero.
58    */
59   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
61     return a % b;
62   }
63 
64 }
65 
66 abstract contract Context {
67     function _msgSender() internal view virtual returns (address) {
68         return msg.sender;
69     }
70 
71     function _msgData() internal view virtual returns (bytes calldata) {
72         return msg.data;
73     }
74 }
75 
76 /**
77  * @dev Contract module which provides a basic access control mechanism, where
78  * there is an account (an owner) that can be granted exclusive access to
79  * specific functions.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _setOwner(_msgSender());
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions anymore. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOwner {
120         _setOwner(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _setOwner(newOwner);
130     }
131 
132     function _setOwner(address newOwner) private {
133         address oldOwner = _owner;
134         _owner = newOwner;
135         emit OwnershipTransferred(oldOwner, newOwner);
136     }
137 }
138 
139 
140 /**
141  * @dev Interface of the ERC20 standard as defined in the EIP.
142  */
143 interface IERC20 {
144     /**
145      * @dev Returns the amount of tokens in existence.
146      */
147     function totalSupply() external view returns (uint256);
148 
149     /**
150      * @dev Returns the amount of tokens owned by `account`.
151      */
152     function balanceOf(address account) external view returns (uint256);
153 
154     /**
155      * @dev Moves `amount` tokens from the caller's account to `recipient`.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transfer(address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through {transferFrom}. This is
166      * zero by default.
167      *
168      * This value changes when {approve} or {transferFrom} are called.
169      */
170     function allowance(address owner, address spender) external view returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * IMPORTANT: Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an {Approval} event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `sender` to `recipient` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) external returns (bool);
202 
203     /**
204      * @dev Emitted when `value` tokens are moved from one account (`from`) to
205      * another (`to`).
206      *
207      * Note that `value` may be zero.
208      */
209     event Transfer(address indexed from, address indexed to, uint256 value);
210 
211     /**
212      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
213      * a call to {approve}. `value` is the new allowance.
214      */
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 contract Gen1DNXFarm is Ownable {
219     
220     using SafeMath for uint256;
221     
222     struct StakerInfo {
223         uint256 amount;
224         uint256 startStakeTime;
225         uint256 count;
226         uint256[] amounts;
227         uint256[] times;
228     }
229       uint256 public stakingStart;
230       uint256 public stakingEnd;
231       uint256 public stakingClosed;
232     
233     uint256 public maximumStakers;       // points generated per LP token per second staked
234     uint256 public currentStakers;
235     uint256 public minimumStake;
236     uint256 public stakingFee;
237     IERC20 dnxcToken;                    // token being staked
238     
239     address private _rewardDistributor;
240     mapping(address => StakerInfo) public stakerInfo;
241     uint256 internal fee;
242     bool paused;
243     bool emergencyUnstake;
244     
245     constructor(uint256 _minimumStake, uint256 _maximumStakers, uint256 _stakingFee, uint256 _stakingStart, uint256 _stakingClosed, uint256 _stakingEnd, IERC20 _dnxcToken) 
246      {
247         
248         minimumStake = _minimumStake;
249         maximumStakers = _maximumStakers;
250         stakingFee = _stakingFee;
251         stakingStart = _stakingStart;
252         stakingClosed = _stakingClosed;
253         stakingEnd = _stakingEnd;
254         paused = true;
255         
256         dnxcToken = _dnxcToken;
257         _rewardDistributor = address(owner());
258     }
259     
260     function changePause(bool _pause) onlyOwner public {
261         paused = _pause;
262     }
263     
264     function changeEmergency(bool _emergencyUnstake) onlyOwner public {
265         emergencyUnstake = _emergencyUnstake;
266     }
267     
268     function changeDistributor(address _address) onlyOwner public {
269         _rewardDistributor = _address;
270     }
271     
272     function changeStakingFees(uint256 _stakingFee) onlyOwner public {
273         stakingFee = _stakingFee;
274     }
275     
276     function changeEndTime(uint256 endTime) public onlyOwner {
277       stakingEnd = endTime;
278     }
279     function changeCloseTime(uint256 closeTime) public onlyOwner {
280       stakingClosed = closeTime;
281     }
282     function changeStartTime(uint256 startTime) public onlyOwner {
283       stakingStart = startTime;
284     }
285       
286     function stake(uint256 _amount) public payable {
287         require (paused == false, "E09");
288         require (block.timestamp >= stakingStart, "E07");
289         require (block.timestamp <= stakingClosed, "E08");
290         require (currentStakers < maximumStakers, "E09");
291         require (_amount % minimumStake == 0, 'E10');
292         
293         StakerInfo storage user = stakerInfo[msg.sender];
294         require (user.amount.add(_amount) >= minimumStake, "E01");
295         require (dnxcToken.transferFrom(msg.sender, address(this), _amount), "E02");
296         
297         uint256 count = _amount.div(minimumStake);
298         require (msg.value >= stakingFee.mul(count), "E04");
299         currentStakers = currentStakers.add(count);
300         
301         if (user.amount == 0) {
302             user.startStakeTime = block.timestamp;
303         }
304         
305         user.amount = user.amount.add(_amount);
306         user.count = user.count.add(count);
307         user.amounts.push(user.amount);
308         user.times.push(block.timestamp);
309     }
310     
311     function unstake() public {
312         
313         require (emergencyUnstake || block.timestamp >= stakingEnd || block.timestamp <= stakingClosed, "E08");
314         StakerInfo storage user = stakerInfo[msg.sender];
315         
316         dnxcToken.transfer(
317             msg.sender,
318             user.amount
319         );
320         
321         currentStakers = currentStakers.sub(user.count);
322         user.amount = 0;
323         user.count = 0;
324     }
325     
326     function getUsersAmounts(address _user) public view returns (uint256[] memory) {
327         StakerInfo storage user = stakerInfo[_user];
328         return user.amounts;
329     }
330     
331     
332     function getUsersTimes(address _user) public view returns (uint256[] memory) {
333         StakerInfo storage user = stakerInfo[_user];
334         return user.times;
335     }
336     
337     function getTimestampOfStartedStaking(address _user) public view returns (uint256) {
338         StakerInfo storage user = stakerInfo[_user];
339         return user.startStakeTime;
340     }
341     
342     function withdrawFees() onlyOwner external {
343         require(payable(msg.sender).send(address(this).balance));
344     }
345     
346 
347 }