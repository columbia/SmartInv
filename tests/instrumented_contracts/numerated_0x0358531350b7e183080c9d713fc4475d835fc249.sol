1 // "SPDX-License-Identifier: MIT"
2 pragma solidity >=0.4.22 <0.8.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         uint256 c = a + b;
23         if (c < a) return (false, 0);
24         return (true, c);
25     }
26 
27     /**
28      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
29      */
30     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         if (b > a) return (false, 0);
32         return (true, a - b);
33     }
34 
35     /**
36      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
37      */
38     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40         // benefit is lost if 'b' is also tested.
41         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
42         if (a == 0) return (true, 0);
43         uint256 c = a * b;
44         if (c / a != b) return (false, 0);
45         return (true, c);
46     }
47 
48     /**
49      * @dev Returns the division of two unsigned integers, with a division by zero flag.
50      */
51     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         if (b == 0) return (false, 0);
53         return (true, a / b);
54     }
55 
56     /**
57      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
58      */
59     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         if (b == 0) return (false, 0);
61         return (true, a % b);
62     }
63 
64     /**
65      * @dev Returns the addition of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `+` operator.
69      *
70      * Requirements:
71      *
72      * - Addition cannot overflow.
73      */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77         return c;
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      *
88      * - Subtraction cannot overflow.
89      */
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b <= a, "SafeMath: subtraction overflow");
92         return a - b;
93     }
94 
95     /**
96      * @dev Returns the multiplication of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `*` operator.
100      *
101      * Requirements:
102      *
103      * - Multiplication cannot overflow.
104      */
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) return 0;
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109         return c;
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers, reverting on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         require(b > 0, "SafeMath: division by zero");
126         return a / b;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * reverting when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b > 0, "SafeMath: modulo by zero");
143         return a % b;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * CAUTION: This function is deprecated because it requires allocating memory for the error
151      * message unnecessarily. For custom revert reasons use {trySub}.
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         return a - b;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
166      * division by zero. The result is rounded towards zero.
167      *
168      * CAUTION: This function is deprecated because it requires allocating memory for the error
169      * message unnecessarily. For custom revert reasons use {tryDiv}.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b > 0, errorMessage);
181         return a / b;
182     }
183 
184     /**
185      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
186      * reverting with custom message when dividing by zero.
187      *
188      * CAUTION: This function is deprecated because it requires allocating memory for the error
189      * message unnecessarily. For custom revert reasons use {tryMod}.
190      *
191      * Counterpart to Solidity's `%` operator. This function uses a `revert`
192      * opcode (which leaves remaining gas untouched) while Solidity uses an
193      * invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         return a % b;
202     }
203 }
204 
205 /**
206  * @dev Interface of the ERC20 standard as defined in the EIP.
207  */
208 interface IERC20 {
209     /**
210      * @dev Returns the amount of tokens in existence.
211      */
212     function totalSupply() external view returns (uint256);
213 
214     /**
215      * @dev Returns the amount of tokens owned by `account`.
216      */
217     function balanceOf(address account) external view returns (uint256);
218 
219     /**
220      * @dev Moves `amount` tokens from the caller's account to `recipient`.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transfer(address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Returns the remaining number of tokens that `spender` will be
230      * allowed to spend on behalf of `owner` through {transferFrom}. This is
231      * zero by default.
232      *
233      * This value changes when {approve} or {transferFrom} are called.
234      */
235     function allowance(address owner, address spender) external view returns (uint256);
236 
237     /**
238      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * IMPORTANT: Beware that changing an allowance with this method brings the risk
243      * that someone may use both the old and the new allowance by unfortunate
244      * transaction ordering. One possible solution to mitigate this race
245      * condition is to first reduce the spender's allowance to 0 and set the
246      * desired value afterwards:
247      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248      *
249      * Emits an {Approval} event.
250      */
251     function approve(address spender, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Moves `amount` tokens from `sender` to `recipient` using the
255      * allowance mechanism. `amount` is then deducted from the caller's
256      * allowance.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Emitted when `value` tokens are moved from one account (`from`) to
266      * another (`to`).
267      *
268      * Note that `value` may be zero.
269      */
270     event Transfer(address indexed from, address indexed to, uint256 value);
271 
272     /**
273      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
274      * a call to {approve}. `value` is the new allowance.
275      */
276     event Approval(address indexed owner, address indexed spender, uint256 value);
277 }
278 
279 /*
280  * @dev Provides information about the current execution context, including the
281  * sender of the transaction and its data. While these are generally available
282  * via msg.sender and msg.data, they should not be accessed in such a direct
283  * manner, since when dealing with GSN meta-transactions the account sending and
284  * paying for execution may not be the actual sender (as far as an application
285  * is concerned).
286  *
287  * This contract is only required for intermediate, library-like contracts.
288  */
289 abstract contract Context {
290     function _msgSender() internal view virtual returns (address payable) {
291         return msg.sender;
292     }
293 
294     function _msgData() internal view virtual returns (bytes memory) {
295         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
296         return msg.data;
297     }
298 }
299 
300 /**
301  * @dev Contract module which provides a basic access control mechanism, where
302  * there is an account (an owner) that can be granted exclusive access to
303  * specific functions.
304  *
305  * By default, the owner account will be the one that deploys the contract. This
306  * can later be changed with {transferOwnership}.
307  *
308  * This module is used through inheritance. It will make available the modifier
309  * `onlyOwner`, which can be applied to your functions to restrict their use to
310  * the owner.
311  */
312 abstract contract Ownable is Context {
313     address private _owner;
314 
315     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
316 
317     /**
318      * @dev Initializes the contract setting the deployer as the initial owner.
319      */
320     constructor () {
321         address msgSender = _msgSender();
322         _owner = msgSender;
323         emit OwnershipTransferred(address(0), msgSender);
324     }
325 
326     /**
327      * @dev Returns the address of the current owner.
328      */
329     function owner() public view virtual returns (address) {
330         return _owner;
331     }
332 
333     /**
334      * @dev Throws if called by any account other than the owner.
335      */
336     modifier onlyOwner() {
337         require(owner() == _msgSender(), "Ownable: caller is not the owner");
338         _;
339     }
340 
341     /**
342      * @dev Leaves the contract without owner. It will not be possible to call
343      * `onlyOwner` functions anymore. Can only be called by the current owner.
344      *
345      * NOTE: Renouncing ownership will leave the contract without an owner,
346      * thereby removing any functionality that is only available to the owner.
347      */
348     function renounceOwnership() public virtual onlyOwner {
349         emit OwnershipTransferred(_owner, address(0));
350         _owner = address(0);
351     }
352 
353     /**
354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
355      * Can only be called by the current owner.
356      */
357     function transferOwnership(address newOwner) public virtual onlyOwner {
358         require(newOwner != address(0), "Ownable: new owner is the zero address");
359         emit OwnershipTransferred(_owner, newOwner);
360         _owner = newOwner;
361     }
362 }
363 
364 
365 contract GasGainsDistribution is Ownable {
366     using SafeMath for uint;
367     IERC20 public GasgainsTokenAddress;
368     address public admin;
369     uint public rewardPool;
370     uint public totalSharedRewards;
371 
372     mapping(address => uint) private rewardsEarned;
373 
374     event _RewardShared(
375         uint indexed timestamp,
376         uint indexed rewards
377     );
378     
379     event RewardsClaimed(address indexed user, uint timestamp, uint amount);
380 
381     constructor(IERC20 _GasgainsTokenAddress) {
382         GasgainsTokenAddress = _GasgainsTokenAddress;
383         admin = _msgSender();
384     }
385 
386     function shareReward(address[] memory _accounts, uint[] memory _rewards) public {
387         require(_msgSender() == admin, "GasGainsDistribution: Caller is not the admin");
388         uint _totalRewards = 0;
389 
390         for(uint i = 0; i < _accounts.length; i++) {
391             address _user = _accounts[i];
392             require(_user != address(0), "GasGainsDistribution: Zero address found in distribution list");
393             
394             uint _reward = _rewards[i];
395             _totalRewards = _totalRewards.add(_reward);
396             rewardsEarned[_user] = rewardsEarned[_user].add(_reward);
397         }
398         
399         GasgainsTokenAddress.transferFrom(_msgSender(), address(this), _totalRewards);
400         rewardPool = rewardPool.add(_totalRewards);
401         totalSharedRewards = totalSharedRewards.add(_totalRewards);
402         
403         emit _RewardShared(block.timestamp, _totalRewards);
404     }
405     
406     function checkRewards(address _user) public view returns(uint) {
407         return rewardsEarned[_user];
408     }
409     
410     function claimRewards() public {
411         require(rewardsEarned[_msgSender()] > 0, "You have zero rewards to claim");
412         
413         uint _reward = rewardsEarned[_msgSender()];
414         rewardsEarned[_msgSender()] = 0;
415         
416         rewardPool = rewardPool.sub(_reward);
417         GasgainsTokenAddress.transfer(_msgSender(), _reward);
418         RewardsClaimed(_msgSender(), block.timestamp, _reward);
419     }
420     
421     
422     receive() external payable {
423         revert("You can not send ether directly to the contract");
424     }
425 }