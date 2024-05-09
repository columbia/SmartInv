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
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 // SPDX-License-Identifier: MIT
111 
112 pragma solidity ^0.6.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 // File: contracts/WOOFT.sol
271 
272 pragma solidity 0.6.4;
273 
274 
275 
276 
277 contract WOOFT is Context, IERC20 {
278 
279     using SafeMath for uint256;
280 
281     mapping (address => uint256) private _balances;
282 
283     mapping (address => mapping (address => uint256)) private _allowances;
284 
285     uint256 private _totalSupply;
286 
287     string private _name;
288     string private _symbol;
289     uint8 private _decimals;
290 
291     constructor () public {
292         _name = "Wooftalik Dogerin";
293         _symbol = "WOOFT";
294         _decimals = 18;
295         uint256 amount = 1000000000000000000000000000;
296         _totalSupply = amount;
297         _balances[_msgSender()] = amount;
298         emit Transfer(address(0), _msgSender(), amount);
299     }
300 
301     function name() public view returns (string memory) {
302         return _name;
303     }
304 
305     function symbol() public view returns (string memory) {
306         return _symbol;
307     }
308 
309     function decimals() public view returns (uint8) {
310         return _decimals;
311     }
312 
313     function totalSupply() public view override returns (uint256) {
314         return _totalSupply;
315     }
316 
317     function balanceOf(address account) public view override returns (uint256) {
318         return _balances[account];
319     }
320 
321     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
322         _transfer(_msgSender(), recipient, amount);
323         return true;
324     }
325 
326     function allowance(address owner, address spender) public view virtual override returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330     function approve(address spender, uint256 amount) public virtual override returns (bool) {
331         _approve(_msgSender(), spender, amount);
332         return true;
333     }
334 
335     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
336         _transfer(sender, recipient, amount);
337         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "WOOFT: transfer amount exceeds allowance"));
338         return true;
339     }
340 
341     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
342         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
343         return true;
344     }
345 
346     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
347         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "WOOFT: decreased allowance below zero"));
348         return true;
349     }
350 
351     function burn(uint256 amount) public virtual {
352         _burn(_msgSender(), amount);
353     }
354 
355     function burnFrom(address account, uint256 amount) public virtual {
356         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "WOOFT: burn amount exceeds allowance");
357 
358         _approve(account, _msgSender(), decreasedAllowance);
359         _burn(account, amount);
360     }
361 
362     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
363         require(sender != address(0), "WOOFT: transfer from the zero address");
364         require(recipient != address(0), "WOOFT: transfer to the zero address");
365         _balances[sender] = _balances[sender].sub(amount, "WOOFT: transfer amount exceeds balance");
366         _balances[recipient] = _balances[recipient].add(amount);
367         emit Transfer(sender, recipient, amount);
368     }
369 
370     function _burn(address account, uint256 amount) internal virtual {
371         require(account != address(0), "WOOFT: burn from the zero address");
372         _balances[account] = _balances[account].sub(amount, "WOOFT: burn amount exceeds balance");
373         _totalSupply = _totalSupply.sub(amount);
374         emit Transfer(account, address(0), amount);
375     }
376 
377     function _approve(address owner, address spender, uint256 amount) internal virtual {
378         require(owner != address(0), "WOOFT: approve from the zero address");
379         require(spender != address(0), "WOOFT: approve to the zero address");
380 
381         _allowances[owner][spender] = amount;
382         emit Approval(owner, spender, amount);
383     }
384 
385 }