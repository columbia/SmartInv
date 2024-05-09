1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin\contracts\access\Ownable.sol
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
98 
99 
100 pragma solidity ^0.6.0;
101 
102 /**
103  * @dev Interface of the ERC20 standard as defined in the EIP.
104  */
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: @openzeppelin\contracts\math\SafeMath.sol
177 
178 
179 pragma solidity ^0.6.0;
180 
181 /**
182  * @dev Wrappers over Solidity's arithmetic operations with added overflow
183  * checks.
184  *
185  * Arithmetic operations in Solidity wrap on overflow. This can easily result
186  * in bugs, because programmers usually assume that an overflow raises an
187  * error, which is the standard behavior in high level programming languages.
188  * `SafeMath` restores this intuition by reverting the transaction when an
189  * operation overflows.
190  *
191  * Using this library instead of the unchecked operations eliminates an entire
192  * class of bugs, so it's recommended to use it always.
193  */
194 library SafeMath {
195     /**
196      * @dev Returns the addition of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `+` operator.
200      *
201      * Requirements:
202      *
203      * - Addition cannot overflow.
204      */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         require(c >= a, "SafeMath: addition overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return sub(a, b, "SafeMath: subtraction overflow");
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      *
234      * - Subtraction cannot overflow.
235      */
236     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b <= a, errorMessage);
238         uint256 c = a - b;
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the multiplication of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `*` operator.
248      *
249      * Requirements:
250      *
251      * - Multiplication cannot overflow.
252      */
253     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
254         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
255         // benefit is lost if 'b' is also tested.
256         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
257         if (a == 0) {
258             return 0;
259         }
260 
261         uint256 c = a * b;
262         require(c / a == b, "SafeMath: multiplication overflow");
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers. Reverts on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function div(uint256 a, uint256 b) internal pure returns (uint256) {
280         return div(a, b, "SafeMath: division by zero");
281     }
282 
283     /**
284      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
285      * division by zero. The result is rounded towards zero.
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         uint256 c = a / b;
298         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * Reverts when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
316         return mod(a, b, "SafeMath: modulo by zero");
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321      * Reverts with custom message when dividing by zero.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b != 0, errorMessage);
333         return a % b;
334     }
335 }
336 
337 // File: @openzeppelin\contracts\math\Math.sol
338 
339 
340 pragma solidity ^0.6.0;
341 
342 /**
343  * @dev Standard math utilities missing in the Solidity language.
344  */
345 library Math {
346     /**
347      * @dev Returns the largest of two numbers.
348      */
349     function max(uint256 a, uint256 b) internal pure returns (uint256) {
350         return a >= b ? a : b;
351     }
352 
353     /**
354      * @dev Returns the smallest of two numbers.
355      */
356     function min(uint256 a, uint256 b) internal pure returns (uint256) {
357         return a < b ? a : b;
358     }
359 
360     /**
361      * @dev Returns the average of two numbers. The result is rounded towards
362      * zero.
363      */
364     function average(uint256 a, uint256 b) internal pure returns (uint256) {
365         // (a + b) / 2 can overflow, so we distribute
366         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
367     }
368 }
369 
370 // File: contracts\distribution\TimeDistribution.sol
371 
372 pragma solidity ^0.6.12;
373 
374 
375 /**
376 @notice Linear release of BOR
377  */
378 contract TimeDistribution is Ownable {
379     using SafeMath for uint256;
380     using Math for uint256;
381 
382     IERC20 public token;
383     address public distributor;
384 
385     struct DistributionInfo {
386         uint256 amount;
387         uint256 claimedAmount;
388         uint256 beginTs;
389         uint256 endTs;
390         uint256 duration;
391     }
392 
393     mapping(address => DistributionInfo) public infos;
394 
395     constructor(IERC20 _token, address _distributor) public {
396         token = _token;
397         distributor = _distributor;
398     }
399 
400     function userTotalToken() public view returns (uint256) {
401         return infos[msg.sender].amount;
402     }
403 
404     function claimed() public view returns (uint256) {
405         return infos[msg.sender].claimedAmount;
406     }
407 
408     function setDistributor(address _distributor) public onlyOwner {
409         distributor = _distributor;
410     }
411 
412     function addInfo(
413         address account,
414         uint256 amount,
415         uint256 beginTs,
416         uint256 endTs
417     ) public onlyOwner {
418         require(infos[account].amount == 0, "Timedistribution::account is not a new user");
419         require(amount != 0, "TimeDistribution::addInfo: amount should not 0");
420         require(
421             beginTs >= block.timestamp,
422             "TimeDistribution::addInfo: begin too early"
423         );
424         require(
425             endTs >= block.timestamp,
426             "TimeDistribution::addInfo: end too early"
427         );
428         infos[account] = DistributionInfo(
429             amount,
430             0,
431             beginTs,
432             endTs,
433             endTs.sub(beginTs)
434         );
435         emit AddInfo(account, amount, beginTs, endTs);
436     }
437 
438     // careful gas
439     function addMultiInfo(address[] memory accounts, uint256[] memory amounts, uint256[] memory beginTsArray, uint256[] memory endTsArray) public onlyOwner {
440         require(accounts.length == amounts.length, "TimeDistribution::addMultiInfo:function params length not equal");
441         require(accounts.length == beginTsArray.length, "TimeDistribution::addMultiInfo:function params length not equal");
442         require(accounts.length == endTsArray.length, "TimeDistribution::addMultiInfo:function params length not equal");
443         for(uint256 i=0; i < accounts.length; i++) {
444             addInfo(accounts[i], amounts[i], beginTsArray[i], endTsArray[i]);
445         }
446     }
447 
448     function pendingClaim() public view returns (uint256) {
449         if(infos[msg.sender].amount == 0) {
450             return 0;
451         }
452         DistributionInfo storage info = infos[msg.sender];
453         uint256 nowtime = Math.min(block.timestamp, info.endTs);
454         return
455             (nowtime.sub(info.beginTs)).mul(info.amount).div(info.duration).sub(
456                 info.claimedAmount
457             );
458     }
459 
460     function claim() public {
461         uint256 claimAmount = pendingClaim();
462         DistributionInfo storage info = infos[msg.sender];
463         info.claimedAmount = info.claimedAmount.add(claimAmount);
464         token.transferFrom(distributor, msg.sender, claimAmount);
465         emit ClaimToken(msg.sender, claimAmount);
466     }
467 
468     // function changeUser(address newUser) public {
469     //     require(infos[newUser].amount == 0, "Timedistribution::newUser is not a new user");
470     //     infos[newUser] = infos[msg.sender];
471     //     delete infos[msg.sender];
472     //     emit UserChanged(msg.sender, newUser);
473     // }
474 
475     function changeUserAdmin(address oldUser, address newUser) public onlyOwner {
476         require(infos[newUser].amount == 0, "Timedistribution::newUser is not a new user");
477         infos[newUser] = infos[oldUser];
478         delete infos[oldUser];
479         emit UserChanged(oldUser, newUser);
480     }
481 
482     event AddInfo(
483         address account,
484         uint256 amount,
485         uint256 beginTs,
486         uint256 endTs
487     );
488     event ClaimToken(address account, uint256 amount);
489     event UserChanged(address oldUser, address newUser);
490 }