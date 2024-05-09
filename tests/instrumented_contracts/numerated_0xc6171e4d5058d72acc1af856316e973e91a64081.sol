1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^ 0.8.7;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations.
85  *
86  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
87  * now has built in overflow checking.
88  */
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, with an overflow flag.
92      *
93      * _Available since v3.4._
94      */
95     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
96         unchecked {
97             uint256 c = a + b;
98             if (c < a) return (false, 0);
99             return (true, c);
100         }
101     }
102 
103     /**
104      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
105      *
106      * _Available since v3.4._
107      */
108     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         unchecked {
110             if (b > a) return (false, 0);
111             return (true, a - b);
112         }
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
117      *
118      * _Available since v3.4._
119      */
120     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
121         unchecked {
122             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
123             // benefit is lost if 'b' is also tested.
124             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
125             if (a == 0) return (true, 0);
126             uint256 c = a * b;
127             if (c / a != b) return (false, 0);
128             return (true, c);
129         }
130     }
131 
132     /**
133      * @dev Returns the division of two unsigned integers, with a division by zero flag.
134      *
135      * _Available since v3.4._
136      */
137     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         unchecked {
139             if (b == 0) return (false, 0);
140             return (true, a / b);
141         }
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
146      *
147      * _Available since v3.4._
148      */
149     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
150         unchecked {
151             if (b == 0) return (false, 0);
152             return (true, a % b);
153         }
154     }
155 
156     /**
157      * @dev Returns the addition of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `+` operator.
161      *
162      * Requirements:
163      *
164      * - Addition cannot overflow.
165      */
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         return a + b;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a - b;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a * b;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers, reverting on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator.
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a / b;
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * reverting when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225         return a % b;
226     }
227 
228     /**
229      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
230      * overflow (when the result is negative).
231      *
232      * CAUTION: This function is deprecated because it requires allocating memory for the error
233      * message unnecessarily. For custom revert reasons use {trySub}.
234      *
235      * Counterpart to Solidity's `-` operator.
236      *
237      * Requirements:
238      *
239      * - Subtraction cannot overflow.
240      */
241     function sub(
242         uint256 a,
243         uint256 b,
244         string memory errorMessage
245     ) internal pure returns (uint256) {
246         unchecked {
247             require(b <= a, errorMessage);
248             return a - b;
249         }
250     }
251 
252     /**
253      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
254      * division by zero. The result is rounded towards zero.
255      *
256      * Counterpart to Solidity's `/` operator. Note: this function uses a
257      * `revert` opcode (which leaves remaining gas untouched) while Solidity
258      * uses an invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function div(
265         uint256 a,
266         uint256 b,
267         string memory errorMessage
268     ) internal pure returns (uint256) {
269         unchecked {
270             require(b > 0, errorMessage);
271             return a / b;
272         }
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * reverting with custom message when dividing by zero.
278      *
279      * CAUTION: This function is deprecated because it requires allocating memory for the error
280      * message unnecessarily. For custom revert reasons use {tryMod}.
281      *
282      * Counterpart to Solidity's `%` operator. This function uses a `revert`
283      * opcode (which leaves remaining gas untouched) while Solidity uses an
284      * invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function mod(
291         uint256 a,
292         uint256 b,
293         string memory errorMessage
294     ) internal pure returns (uint256) {
295         unchecked {
296             require(b > 0, errorMessage);
297             return a % b;
298         }
299     }
300 }
301 /**
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 /**
322  * @dev Contract module which provides a basic access control mechanism, where
323  * there is an account (an owner) that can be granted exclusive access to
324  * specific functions.
325  *
326  * By default, the owner account will be the one that deploys the contract. This
327  * can later be changed with {transferOwnership}.
328  *
329  * This module is used through inheritance. It will make available the modifier
330  * `onlyOwner`, which can be applied to your functions to restrict their use to
331  * the owner.
332  */
333 abstract contract Ownable is Context {
334     address private _owner;
335 
336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
337 
338     /**
339      * @dev Initializes the contract setting the deployer as the initial owner.
340      */
341     constructor() {
342         _transferOwnership(_msgSender());
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
367     function renounceOwnership() external virtual onlyOwner {
368         _transferOwnership(address(0));
369     }
370 
371     /**
372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
373      * Can only be called by the current owner.
374      */
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         _transferOwnership(newOwner);
378     }
379 
380     /**
381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
382      * Internal function without access restriction.
383      */
384     function _transferOwnership(address newOwner) internal virtual {
385         address oldOwner = _owner;
386         _owner = newOwner;
387         emit OwnershipTransferred(oldOwner, newOwner);
388     }
389 }
390 
391 contract MRAIRDROP is Context, Ownable {
392     IERC20 public mrToken;
393 
394     mapping(address => bool) private blockClaim;
395     mapping(address => uint256) private balances;
396     mapping(address => uint256) private claimedAmount;
397 
398     constructor(IERC20 _mrToken) {
399         mrToken = _mrToken;
400     }
401 
402     function balanceOf(address wallet) external view returns(uint256) {
403         return balances[wallet];
404     }
405 
406     function walletClaimedAmount(address wallet) external view returns(uint256) {
407         return claimedAmount[wallet];
408     }
409 
410     function updateMrToken(address _mrToken) external onlyOwner {
411         mrToken = IERC20(_mrToken);
412     }
413 
414     function updateBalanceBulk(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
415         require(accounts.length == amounts.length, "length missmatch");
416         for(uint256 i; i < accounts.length; i++) {
417             balances[accounts[i]] += amounts[i];
418         }
419     }
420 
421     function updateWalletBalance(address account, uint256 amount) external onlyOwner {
422         balances[account] = amount;
423     }
424 
425     event mrTokenClaimed(address indexed by, uint256 amount);
426     function ClaimMrToken() external {
427         require(balances[_msgSender()] > 0, "No balance to claim");
428         require(!blockClaim[_msgSender()],"Blocked from claiming");
429         uint256 balance = balances[_msgSender()];
430         balances[_msgSender()] = 0;
431         claimedAmount[_msgSender()] += balance;
432         mrToken.transfer(_msgSender(), balance);
433         emit mrTokenClaimed(_msgSender(), balance);
434     }
435 
436     function transferToken(address wallet, uint256 amount) external onlyOwner {
437         mrToken.transfer(wallet, amount);
438     }
439 
440     event BlockedClaimed(address indexed account, bool block);
441     function blockClaiming(address account, bool blockClaim_) external onlyOwner {
442         blockClaim[account] = blockClaim_;
443         emit BlockedClaimed(account, blockClaim_);
444     }
445 }