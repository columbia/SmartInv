1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
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
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // File: @openzeppelin/contracts/math/SafeMath.sol
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         uint256 c = a + b;
127         if (c < a) return (false, 0);
128         return (true, c);
129     }
130 
131     /**
132      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         if (b > a) return (false, 0);
138         return (true, a - b);
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
143      *
144      * _Available since v3.4._
145      */
146     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) return (true, 0);
151         uint256 c = a * b;
152         if (c / a != b) return (false, 0);
153         return (true, c);
154     }
155 
156     /**
157      * @dev Returns the division of two unsigned integers, with a division by zero flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         if (b == 0) return (false, 0);
163         return (true, a / b);
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         if (b == 0) return (false, 0);
173         return (true, a % b);
174     }
175 
176     /**
177      * @dev Returns the addition of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `+` operator.
181      *
182      * Requirements:
183      *
184      * - Addition cannot overflow.
185      */
186     function add(uint256 a, uint256 b) internal pure returns (uint256) {
187         uint256 c = a + b;
188         require(c >= a, "SafeMath: addition overflow");
189         return c;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting on
194      * overflow (when the result is negative).
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      *
200      * - Subtraction cannot overflow.
201      */
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b <= a, "SafeMath: subtraction overflow");
204         return a - b;
205     }
206 
207     /**
208      * @dev Returns the multiplication of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `*` operator.
212      *
213      * Requirements:
214      *
215      * - Multiplication cannot overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         if (a == 0) return 0;
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221         return c;
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers, reverting on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         require(b > 0, "SafeMath: division by zero");
238         return a / b;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * reverting when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         require(b > 0, "SafeMath: modulo by zero");
255         return a % b;
256     }
257 
258     /**
259      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
260      * overflow (when the result is negative).
261      *
262      * CAUTION: This function is deprecated because it requires allocating memory for the error
263      * message unnecessarily. For custom revert reasons use {trySub}.
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      *
269      * - Subtraction cannot overflow.
270      */
271     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b <= a, errorMessage);
273         return a - b;
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
278      * division by zero. The result is rounded towards zero.
279      *
280      * CAUTION: This function is deprecated because it requires allocating memory for the error
281      * message unnecessarily. For custom revert reasons use {tryDiv}.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         return a / b;
294     }
295 
296     /**
297      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
298      * reverting with custom message when dividing by zero.
299      *
300      * CAUTION: This function is deprecated because it requires allocating memory for the error
301      * message unnecessarily. For custom revert reasons use {tryMod}.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
312         require(b > 0, errorMessage);
313         return a % b;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/access/Ownable.sol
318 
319 /**
320  * @dev Contract module which provides a basic access control mechanism, where
321  * there is an account (an owner) that can be granted exclusive access to
322  * specific functions.
323  *
324  * By default, the owner account will be the one that deploys the contract. This
325  * can later be changed with {transferOwnership}.
326  *
327  * This module is used through inheritance. It will make available the modifier
328  * `onlyOwner`, which can be applied to your functions to restrict their use to
329  * the owner.
330  */
331 abstract contract Ownable is Context {
332     address private _owner;
333 
334     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
335 
336     /**
337      * @dev Initializes the contract setting the deployer as the initial owner.
338      */
339     constructor () internal {
340         address msgSender = _msgSender();
341         _owner = msgSender;
342         emit OwnershipTransferred(address(0), msgSender);
343     }
344 
345     /**
346      * @dev Returns the address of the current owner.
347      */
348     function owner() public view virtual returns (address) {
349         return _owner;
350     }
351 
352     /**
353      * @dev Throws if called by any account other than the owner.
354      */
355     modifier onlyOwner() {
356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
357         _;
358     }
359 
360     /**
361      * @dev Leaves the contract without owner. It will not be possible to call
362      * `onlyOwner` functions anymore. Can only be called by the current owner.
363      *
364      * NOTE: Renouncing ownership will leave the contract without an owner,
365      * thereby removing any functionality that is only available to the owner.
366      */
367     function renounceOwnership() public virtual onlyOwner {
368         emit OwnershipTransferred(_owner, address(0));
369         _owner = address(0);
370     }
371 
372     /**
373      * @dev Transfers ownership of the contract to a new account (`newOwner`).
374      * Can only be called by the current owner.
375      */
376     function transferOwnership(address newOwner) public virtual onlyOwner {
377         require(newOwner != address(0), "Ownable: new owner is the zero address");
378         emit OwnershipTransferred(_owner, newOwner);
379         _owner = newOwner;
380     }
381 }
382 
383 // File: contracts/TokenClaimer.sol
384 contract TokenClaimer is Ownable {
385 
386     using SafeMath for uint256;
387     
388     address public blesToken;
389 
390     uint256 public fromBlock;
391     uint256 public toBlock;
392     uint256 public rewardPerBlock;
393 
394     uint256 public totalShares;
395     mapping(address => uint256) public userShares;
396     mapping(address => uint256) public userClaimed;
397 
398     constructor() public {}
399 
400     function setUp(address blesToken_, uint256 fromBlock_, uint256 toBlock_, uint256 rewardPerBlock_) external onlyOwner {
401         blesToken = blesToken_;
402         fromBlock = fromBlock_;
403         toBlock = toBlock_;
404         rewardPerBlock = rewardPerBlock_;
405     }
406 
407     function setUserShares(address who_, uint256 amount_) external onlyOwner {
408         if (amount_ >= userShares[who_]) {
409             totalShares = totalShares.add(amount_.sub(userShares[who_]));
410         } else {
411             totalShares = totalShares.sub(userShares[who_].sub(amount_));
412         }
413 
414         userShares[who_] = amount_;
415     }
416 
417     function setUserSharesBatch(address[] calldata whoArray_, uint256[] calldata amountArray_) external onlyOwner {
418         require(whoArray_.length == amountArray_.length);
419 
420         uint256 totalTemp = totalShares;
421         for (uint256 i = 0; i < whoArray_.length; ++i) {
422             address who = whoArray_[i];
423             uint256 amount = amountArray_[i];
424 
425             if (amount >= userShares[who]) {
426                 totalTemp = totalTemp.add(amount.sub(userShares[who]));
427             } else {
428                 totalTemp = totalTemp.sub(userShares[who].sub(amount));
429             }
430 
431             userShares[who] = amount;
432         }
433 
434         totalShares = totalTemp;
435     }
436 
437     function getTotalAmount(address who_) public view returns(uint256) {
438         if (block.number <= fromBlock) {
439             return 0;
440         }
441 
442         uint256 count = block.number > toBlock ? toBlock.sub(fromBlock) : block.number.sub(fromBlock);
443         return rewardPerBlock.mul(count).mul(userShares[who_]).div(totalShares);
444     }
445 
446     function getRemainingAmount(address who_) public view returns(uint256) {
447         return getTotalAmount(who_).sub(userClaimed[who_]);
448     }
449 
450     function claim() external {
451         uint256 amount = getRemainingAmount(msg.sender);
452         IERC20(blesToken).transfer(msg.sender, amount);
453         userClaimed[msg.sender] = userClaimed[msg.sender].add(amount);
454     }
455 }