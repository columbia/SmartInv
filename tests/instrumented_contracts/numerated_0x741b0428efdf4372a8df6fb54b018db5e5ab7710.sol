1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/GSN/Context.sol
82 
83 // SPDX-License-Identifier: MIT
84 
85 pragma solidity ^0.6.0;
86 
87 /*
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with GSN meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address payable) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes memory) {
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 // SPDX-License-Identifier: MIT
109 
110 pragma solidity ^0.6.0;
111 
112 /**
113  * @dev Contract module which provides a basic access control mechanism, where
114  * there is an account (an owner) that can be granted exclusive access to
115  * specific functions.
116  *
117  * By default, the owner account will be the one that deploys the contract. This
118  * can later be changed with {transferOwnership}.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be applied to your functions to restrict their use to
122  * the owner.
123  */
124 contract Ownable is Context {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor () internal {
133         address msgSender = _msgSender();
134         _owner = msgSender;
135         emit OwnershipTransferred(address(0), msgSender);
136     }
137 
138     /**
139      * @dev Returns the address of the current owner.
140      */
141     function owner() public view returns (address) {
142         return _owner;
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(_owner == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * NOTE: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public virtual onlyOwner {
161         emit OwnershipTransferred(_owner, address(0));
162         _owner = address(0);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(_owner, newOwner);
172         _owner = newOwner;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/math/SafeMath.sol
177 
178 // SPDX-License-Identifier: MIT
179 
180 pragma solidity ^0.6.0;
181 
182 /**
183  * @dev Wrappers over Solidity's arithmetic operations with added overflow
184  * checks.
185  *
186  * Arithmetic operations in Solidity wrap on overflow. This can easily result
187  * in bugs, because programmers usually assume that an overflow raises an
188  * error, which is the standard behavior in high level programming languages.
189  * `SafeMath` restores this intuition by reverting the transaction when an
190  * operation overflows.
191  *
192  * Using this library instead of the unchecked operations eliminates an entire
193  * class of bugs, so it's recommended to use it always.
194  */
195 library SafeMath {
196     /**
197      * @dev Returns the addition of two unsigned integers, reverting on
198      * overflow.
199      *
200      * Counterpart to Solidity's `+` operator.
201      *
202      * Requirements:
203      *
204      * - Addition cannot overflow.
205      */
206     function add(uint256 a, uint256 b) internal pure returns (uint256) {
207         uint256 c = a + b;
208         require(c >= a, "SafeMath: addition overflow");
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      *
221      * - Subtraction cannot overflow.
222      */
223     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224         return sub(a, b, "SafeMath: subtraction overflow");
225     }
226 
227     /**
228      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
229      * overflow (when the result is negative).
230      *
231      * Counterpart to Solidity's `-` operator.
232      *
233      * Requirements:
234      *
235      * - Subtraction cannot overflow.
236      */
237     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b <= a, errorMessage);
239         uint256 c = a - b;
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the multiplication of two unsigned integers, reverting on
246      * overflow.
247      *
248      * Counterpart to Solidity's `*` operator.
249      *
250      * Requirements:
251      *
252      * - Multiplication cannot overflow.
253      */
254     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
255         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
256         // benefit is lost if 'b' is also tested.
257         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
258         if (a == 0) {
259             return 0;
260         }
261 
262         uint256 c = a * b;
263         require(c / a == b, "SafeMath: multiplication overflow");
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the integer division of two unsigned integers. Reverts on
270      * division by zero. The result is rounded towards zero.
271      *
272      * Counterpart to Solidity's `/` operator. Note: this function uses a
273      * `revert` opcode (which leaves remaining gas untouched) while Solidity
274      * uses an invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         return div(a, b, "SafeMath: division by zero");
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * Counterpart to Solidity's `/` operator. Note: this function uses a
289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
290      * uses an invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297         require(b > 0, errorMessage);
298         uint256 c = a / b;
299         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
300 
301         return c;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * Reverts when dividing by zero.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         return mod(a, b, "SafeMath: modulo by zero");
318     }
319 
320     /**
321      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
322      * Reverts with custom message when dividing by zero.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
333         require(b != 0, errorMessage);
334         return a % b;
335     }
336 }
337 
338 // File: contracts/ARTX.sol
339 
340 pragma solidity 0.6.4;
341 
342 interface ILocker {
343     /**
344      * @dev Fails if transaction is not allowed. 
345      * Return values can be ignored for AntiBot launches
346      */
347     function lockOrGetPenalty(address source, address dest)
348     external
349     returns (bool, uint256);
350 }
351 
352 
353 contract ARTXToken is Context, IERC20, Ownable {
354 
355     using SafeMath for uint256;
356 
357     mapping (address => uint256) private _balances;
358 
359     mapping (address => mapping (address => uint256)) private _allowances;
360 
361     uint256 private _totalSupply;
362 
363     string private _name;
364     string private _symbol;
365     uint8 private _decimals;
366 
367     ILocker public locker;
368 
369     constructor () public {
370         _name = "ARTX Token";
371         _symbol = "ARTX";
372         _decimals = 18;
373         uint256 amount = 10000000000000000000000000;
374         _totalSupply = amount;
375         _balances[_msgSender()] = amount;
376         emit Transfer(address(0), _msgSender(), amount);
377     }
378 
379     function name() public view returns (string memory) {
380         return _name;
381     }
382 
383     function symbol() public view returns (string memory) {
384         return _symbol;
385     }
386 
387     function decimals() public view returns (uint8) {
388         return _decimals;
389     }
390 
391     function totalSupply() public view override returns (uint256) {
392         return _totalSupply;
393     }
394 
395     function balanceOf(address account) public view override returns (uint256) {
396         return _balances[account];
397     }
398 
399     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
400         _transfer(_msgSender(), recipient, amount);
401         return true;
402     }
403 
404     function allowance(address owner, address spender) public view virtual override returns (uint256) {
405         return _allowances[owner][spender];
406     }
407 
408     function approve(address spender, uint256 amount) public virtual override returns (bool) {
409         _approve(_msgSender(), spender, amount);
410         return true;
411     }
412 
413     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
414         _transfer(sender, recipient, amount);
415         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ARTX: transfer amount exceeds allowance"));
416         return true;
417     }
418 
419     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
420         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
421         return true;
422     }
423 
424     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
425         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ARTX: decreased allowance below zero"));
426         return true;
427     }
428 
429     function burn(uint256 amount) public virtual {
430         _burn(_msgSender(), amount);
431     }
432 
433     function burnFrom(address account, uint256 amount) public virtual {
434         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ARTX: burn amount exceeds allowance");
435 
436         _approve(account, _msgSender(), decreasedAllowance);
437         _burn(account, amount);
438     }
439 
440     function setLocker(address _locker) external onlyOwner() {
441         locker = ILocker(_locker);
442     }   
443 
444     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
445         require(sender != address(0), "ARTX: transfer from the zero address");
446         require(recipient != address(0), "ARTX: transfer to the zero address");
447         if (address(locker) != address(0)) {
448             locker.lockOrGetPenalty(sender, recipient);
449         }
450         _balances[sender] = _balances[sender].sub(amount, "ARTX: transfer amount exceeds balance");
451         _balances[recipient] = _balances[recipient].add(amount);
452         emit Transfer(sender, recipient, amount);
453     }
454 
455     function _burn(address account, uint256 amount) internal virtual {
456         require(account != address(0), "ARTX: burn from the zero address");
457         _balances[account] = _balances[account].sub(amount, "ARTX: burn amount exceeds balance");
458         _totalSupply = _totalSupply.sub(amount);
459         emit Transfer(account, address(0), amount);
460     }
461 
462     function _approve(address owner, address spender, uint256 amount) internal virtual {
463         require(owner != address(0), "ARTX: approve from the zero address");
464         require(spender != address(0), "ARTX: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470 }