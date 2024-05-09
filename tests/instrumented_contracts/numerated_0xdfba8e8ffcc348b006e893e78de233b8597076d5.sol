1 pragma solidity ^0.6.4;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 // File: @openzeppelin/contracts/GSN/Context.sol
78 
79 // SPDX-License-Identifier: MIT
80 
81 pragma solidity ^0.6.0;
82 
83 /*
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with GSN meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address payable) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes memory) {
99         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
100         return msg.data;
101     }
102 }
103 
104 // File: @openzeppelin/contracts/math/SafeMath.sol
105 
106 // SPDX-License-Identifier: MIT
107 
108 pragma solidity ^0.6.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: contracts/Dextools.sol
267 
268 pragma solidity 0.6.4;
269 
270 
271 
272 
273 contract SFOX is Context, IERC20 {
274 
275     using SafeMath for uint256;
276 
277     mapping (address => uint256) private _balances;
278 
279     mapping (address => mapping (address => uint256)) private _allowances;
280 
281     uint256 private _totalSupply;
282 
283     string private _name;
284     string private _symbol;
285     uint8 private _decimals;
286 
287     constructor () public {
288         _name = "StonedFox";
289         _symbol = "SFOX";
290         _decimals = 18;
291         uint256 amount = 420690000000000000000000000000000; 
292         _totalSupply = amount;
293         _balances[_msgSender()] = amount;
294         emit Transfer(address(0), _msgSender(), amount);
295     }
296 
297     function name() public view returns (string memory) {
298         return _name;
299     }
300 
301     function symbol() public view returns (string memory) {
302         return _symbol;
303     }
304 
305     function decimals() public view returns (uint8) {
306         return _decimals;
307     }
308 
309     function totalSupply() public view override returns (uint256) {
310         return _totalSupply;
311     }
312 
313     function balanceOf(address account) public view override returns (uint256) {
314         return _balances[account];
315     }
316 
317     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
318         _transfer(_msgSender(), recipient, amount);
319         return true;
320     }
321 
322     function allowance(address owner, address spender) public view virtual override returns (uint256) {
323         return _allowances[owner][spender];
324     }
325 
326     function approve(address spender, uint256 amount) public virtual override returns (bool) {
327         _approve(_msgSender(), spender, amount);
328         return true;
329     }
330 
331     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
332         _transfer(sender, recipient, amount);
333         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
334         return true;
335     }
336 
337     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
338         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
339         return true;
340     }
341 
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
344         return true;
345     }
346 
347     function burn(uint256 amount) public virtual {
348         _burn(_msgSender(), amount);
349     }
350 
351     function burnFrom(address account, uint256 amount) public virtual {
352         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
353 
354         _approve(account, _msgSender(), decreasedAllowance);
355         _burn(account, amount);
356     }
357 
358     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
359         require(sender != address(0), "ERC20: transfer from the zero address");
360         require(recipient != address(0), "ERC20: transfer to the zero address");
361         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
362         _balances[recipient] = _balances[recipient].add(amount);
363         emit Transfer(sender, recipient, amount);
364     }
365 
366     function _burn(address account, uint256 amount) internal virtual {
367         require(account != address(0), "ERC20: burn from the zero address");
368         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
369         _totalSupply = _totalSupply.sub(amount);
370         emit Transfer(account, address(0), amount);
371     }
372 
373     function _approve(address owner, address spender, uint256 amount) internal virtual {
374         require(owner != address(0), "ERC20: approve from the zero address");
375         require(spender != address(0), "ERC20: approve to the zero address");
376 
377         _allowances[owner][spender] = amount;
378         emit Approval(owner, spender, amount);
379     }
380 
381 }