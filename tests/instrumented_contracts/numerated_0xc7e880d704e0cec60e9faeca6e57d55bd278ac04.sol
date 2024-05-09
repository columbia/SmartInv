1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-05
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-05
7 */
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Interface of the ERC20 standard as defined in the EIP.
120  */
121 interface IERC20 {
122     /**
123      * @dev Emitted when `value` tokens are moved from one account (`from`) to
124      * another (`to`).
125      *
126      * Note that `value` may be zero.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     /**
131      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
132      * a call to {approve}. `value` is the new allowance.
133      */
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 
136     /**
137      * @dev Returns the amount of tokens in existence.
138      */
139     function totalSupply() external view returns (uint256);
140 
141     /**
142      * @dev Returns the amount of tokens owned by `account`.
143      */
144     function balanceOf(address account) external view returns (uint256);
145 
146     /**
147      * @dev Moves `amount` tokens from the caller's account to `to`.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transfer(address to, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Returns the remaining number of tokens that `spender` will be
157      * allowed to spend on behalf of `owner` through {transferFrom}. This is
158      * zero by default.
159      *
160      * This value changes when {approve} or {transferFrom} are called.
161      */
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     /**
165      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * IMPORTANT: Beware that changing an allowance with this method brings the risk
170      * that someone may use both the old and the new allowance by unfortunate
171      * transaction ordering. One possible solution to mitigate this race
172      * condition is to first reduce the spender's allowance to 0 and set the
173      * desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address spender, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Moves `amount` tokens from `from` to `to` using the
182      * allowance mechanism. `amount` is then deducted from the caller's
183      * allowance.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transferFrom(
190         address from,
191         address to,
192         uint256 amount
193     ) external returns (bool);
194 }
195 
196 pragma solidity ^0.8.15;
197 
198 interface IParrotRewards {
199     function claimReward() external;
200     function depositRewards() external payable;
201     function getLockedShares(address wallet) external view returns (uint256);
202     function lock(uint256 amount) external;
203     function unlock(uint256 amount) external;
204 }
205 
206 contract ParrotRewards is IParrotRewards, Ownable {
207     address public shareholderToken;
208 
209     uint256 private constant ONE_DAY = 60 * 60 * 24;
210     uint256 public timeLock = 30 days;
211     uint256 public totalLockedUsers;
212     uint256 public totalSharesDeposited;
213     uint256 public totalRewards;
214     uint256 public totalDistributed;
215     uint256 public rewardsPerShare;
216     uint256 private constant ACC_FACTOR = 10**36;
217 
218     int256 private constant OFFSET19700101 = 2440588;
219 
220     uint8 public minDayOfMonthCanLock = 1;
221     uint8 public maxDayOfMonthCanLock = 5;
222 
223     struct Reward {
224         uint256 totalExcluded;
225         uint256 totalRealised;
226         uint256 lastClaim;
227     }
228 
229     struct Share {
230         uint256 amount;
231         uint256 lockedTime;
232     }
233 
234     // amount of shares a user has
235     mapping(address => Share) public shares;
236     // reward information per user
237     mapping(address => Reward) public rewards;
238 
239     event ClaimReward(address wallet);
240     event DistributeReward(address indexed wallet, address payable receiver);
241     event DepositRewards(address indexed wallet, uint256 amountETH);
242 
243     constructor(address _shareholderToken) {
244         shareholderToken = _shareholderToken;
245     }
246 
247     function lock(uint256 _amount) external {
248         uint256 _currentDayOfMonth = _dayOfMonth(block.timestamp);
249         require(
250             _currentDayOfMonth >= minDayOfMonthCanLock &&
251             _currentDayOfMonth <= maxDayOfMonthCanLock,
252             "outside of allowed lock window"
253         );
254         address shareholder = msg.sender;
255         IERC20 tokenContract = IERC20(shareholderToken);
256         _amount = _amount == 0 ? tokenContract.balanceOf(shareholder) : _amount;
257         tokenContract.transferFrom(shareholder, address(this), _amount);
258         _addShares(shareholder, _amount);
259     }
260 
261     function unlock(uint256 _amount) external {
262         address shareholder = msg.sender;
263         require(
264             block.timestamp >= shares[shareholder].lockedTime + timeLock,
265             "must wait the time lock before unstaking"
266         );
267         _amount = _amount == 0 ? shares[shareholder].amount : _amount;
268         require(_amount > 0, "need tokens to unlock");
269         require(
270             _amount <= shares[shareholder].amount,
271             "cannot unlock more than you have locked"
272         );
273         IERC20(shareholderToken).transfer(shareholder, _amount);
274         _removeShares(shareholder, _amount);
275     }
276 
277     function _addShares(address shareholder, uint256 amount) internal {
278         _distributeReward(shareholder);
279 
280         uint256 sharesBefore = shares[shareholder].amount;
281         totalSharesDeposited += amount;
282         shares[shareholder].amount += amount;
283         shares[shareholder].lockedTime = block.timestamp;
284         if (sharesBefore == 0 && shares[shareholder].amount > 0) {
285             totalLockedUsers++;
286         }
287         rewards[shareholder].totalExcluded = getCumulativeRewards(
288             shares[shareholder].amount
289         );
290     }
291 
292     function _removeShares(address shareholder, uint256 amount) internal {
293         amount = amount == 0 ? shares[shareholder].amount : amount;
294         require(
295             shares[shareholder].amount > 0 && amount <= shares[shareholder].amount,
296             "you can only unlock if you have some lockd"
297         );
298         _distributeReward(shareholder);
299 
300         totalSharesDeposited -= amount;
301         shares[shareholder].amount -= amount;
302         if (shares[shareholder].amount == 0) {
303             totalLockedUsers--;
304         }
305         rewards[shareholder].totalExcluded = getCumulativeRewards(
306             shares[shareholder].amount
307         );
308   }
309 
310     function depositRewards() public payable override {
311         _depositRewards(msg.value);
312     }
313 
314     function _depositRewards(uint256 _amount) internal {
315         require(_amount > 0, "must provide ETH to deposit");
316         require(totalSharesDeposited > 0, "must be shares deposited");
317 
318         totalRewards += _amount;
319         rewardsPerShare += (ACC_FACTOR * _amount) / totalSharesDeposited;
320         emit DepositRewards(msg.sender, _amount);
321     }
322 
323     function _distributeReward(address shareholder) internal {
324         if (shares[shareholder].amount == 0) {
325             return;
326         }
327 
328         uint256 amount = getUnpaid(shareholder);
329 
330         rewards[shareholder].totalRealised += amount;
331         rewards[shareholder].totalExcluded = getCumulativeRewards(
332             shares[shareholder].amount
333         );
334         rewards[shareholder].lastClaim = block.timestamp;
335 
336         if (amount > 0) {
337             bool success;
338             address payable receiver = payable(shareholder);
339             totalDistributed += amount;
340             uint256 balanceBefore = address(this).balance;
341             (success,) = receiver.call{ value: amount }('');
342             require(address(this).balance >= balanceBefore - amount);
343             emit DistributeReward(shareholder, receiver);
344         }
345     }
346 
347     function _dayOfMonth(uint256 _timestamp) internal pure returns (uint256) {
348         (, , uint256 day) = _daysToDate(_timestamp / ONE_DAY);
349         return day;
350     }
351 
352     // date conversion algorithm from http://aa.usno.navy.mil/faq/docs/JD_Formula.php
353     function _daysToDate(uint256 _days) internal pure returns (uint256, uint256, uint256) {
354         int256 __days = int256(_days);
355 
356         int256 L = __days + 68569 + OFFSET19700101;
357         int256 N = (4 * L) / 146097;
358         L = L - (146097 * N + 3) / 4;
359         int256 _year = (4000 * (L + 1)) / 1461001;
360         L = L - (1461 * _year) / 4 + 31;
361         int256 _month = (80 * L) / 2447;
362         int256 _day = L - (2447 * _month) / 80;
363         L = _month / 11;
364         _month = _month + 2 - 12 * L;
365         _year = 100 * (N - 49) + _year + L;
366 
367         return (uint256(_year), uint256(_month), uint256(_day));
368     }
369 
370     function claimReward() external override {
371         _distributeReward(msg.sender);
372         emit ClaimReward(msg.sender);
373     }
374 
375     // returns the unpaid rewards
376     function getUnpaid(address shareholder) public view returns (uint256) {
377         if (shares[shareholder].amount == 0) {
378             return 0;
379         }
380 
381         uint256 earnedRewards = getCumulativeRewards(shares[shareholder].amount);
382         uint256 rewardsExcluded = rewards[shareholder].totalExcluded;
383         if (earnedRewards <= rewardsExcluded) {
384             return 0;
385         }
386 
387         return earnedRewards - rewardsExcluded;
388     }
389 
390     function getCumulativeRewards(uint256 share) internal view returns (uint256) {
391         return (share * rewardsPerShare) / ACC_FACTOR;
392     }
393 
394     function getLockedShares(address user) external view override returns (uint256) {
395         return shares[user].amount;
396     }
397 
398     function setMinDayOfMonthCanLock(uint8 _day) external onlyOwner {
399         require(_day <= maxDayOfMonthCanLock, "can set min day above max day");
400         minDayOfMonthCanLock = _day;
401     }
402 
403     function setMaxDayOfMonthCanLock(uint8 _day) external onlyOwner {
404         require(_day >= minDayOfMonthCanLock, "can set max day below min day");
405         maxDayOfMonthCanLock = _day;
406     }
407 
408     function setTimeLock(uint256 numSec) external onlyOwner {
409         require(numSec <= 365 days, "must be less than a year");
410         timeLock = numSec;
411     }
412 
413     function withdrawStuckETH() external onlyOwner {
414         bool success;
415         (success,) = address(msg.sender).call{value: address(this).balance}("");
416     }
417 
418     receive() external payable {
419         _depositRewards(msg.value);
420     }
421 }