1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a `Transfer` event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through `transferFrom`. This is
26      * zero by default.
27      *
28      * This value changes when `approve` or `transferFrom` are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * > Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an `Approval` event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a `Transfer` event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to `approve`. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
75 
76 pragma solidity ^0.5.0;
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a, "SafeMath: subtraction overflow");
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Solidity only automatically asserts when dividing by 0
160         require(b > 0, "SafeMath: division by zero");
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b != 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 }
183 
184 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
185 
186 pragma solidity ^0.5.0;
187 
188 
189 
190 /**
191  * @dev Implementation of the `IERC20` interface.
192  *
193  * This implementation is agnostic to the way tokens are created. This means
194  * that a supply mechanism has to be added in a derived contract using `_mint`.
195  * For a generic mechanism see `ERC20Mintable`.
196  *
197  * *For a detailed writeup see our guide [How to implement supply
198  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
199  *
200  * We have followed general OpenZeppelin guidelines: functions revert instead
201  * of returning `false` on failure. This behavior is nonetheless conventional
202  * and does not conflict with the expectations of ERC20 applications.
203  *
204  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
205  * This allows applications to reconstruct the allowance for all accounts just
206  * by listening to said events. Other implementations of the EIP may not emit
207  * these events, as it isn't required by the specification.
208  *
209  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
210  * functions have been added to mitigate the well-known issues around setting
211  * allowances. See `IERC20.approve`.
212  */
213 contract ERC20 is IERC20 {
214     using SafeMath for uint256;
215 
216     mapping (address => uint256) private _balances;
217 
218     mapping (address => mapping (address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply;
221 
222     /**
223      * @dev See `IERC20.totalSupply`.
224      */
225     function totalSupply() public view returns (uint256) {
226         return _totalSupply;
227     }
228 
229     /**
230      * @dev See `IERC20.balanceOf`.
231      */
232     function balanceOf(address account) public view returns (uint256) {
233         return _balances[account];
234     }
235 
236     /**
237      * @dev See `IERC20.transfer`.
238      *
239      * Requirements:
240      *
241      * - `recipient` cannot be the zero address.
242      * - the caller must have a balance of at least `amount`.
243      */
244     function transfer(address recipient, uint256 amount) public returns (bool) {
245         _transfer(msg.sender, recipient, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See `IERC20.allowance`.
251      */
252     function allowance(address owner, address spender) public view returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     /**
257      * @dev See `IERC20.approve`.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      */
263     function approve(address spender, uint256 value) public returns (bool) {
264         _approve(msg.sender, spender, value);
265         return true;
266     }
267 
268     /**
269      * @dev See `IERC20.transferFrom`.
270      *
271      * Emits an `Approval` event indicating the updated allowance. This is not
272      * required by the EIP. See the note at the beginning of `ERC20`;
273      *
274      * Requirements:
275      * - `sender` and `recipient` cannot be the zero address.
276      * - `sender` must have a balance of at least `value`.
277      * - the caller must have allowance for `sender`'s tokens of at least
278      * `amount`.
279      */
280     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
281         _transfer(sender, recipient, amount);
282         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
283         return true;
284     }
285 
286     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
287         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
288         return true;
289     }
290 
291     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
292         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
293         return true;
294     }
295 
296     function _transfer(address sender, address recipient, uint256 amount) internal {
297         require(sender != address(0), "ERC20: transfer from the zero address");
298         require(recipient != address(0), "ERC20: transfer to the zero address");
299 
300         _balances[sender] = _balances[sender].sub(amount);
301         _balances[recipient] = _balances[recipient].add(amount);
302         emit Transfer(sender, recipient, amount);
303     }
304 
305     function _mint(address account, uint256 amount) internal {
306         require(account != address(0), "ERC20: mint to the zero address");
307 
308         _totalSupply = _totalSupply.add(amount);
309         _balances[account] = _balances[account].add(amount);
310         emit Transfer(address(0), account, amount);
311     }
312 
313     function _burn(address account, uint256 value) internal {
314         require(account != address(0), "ERC20: burn from the zero address");
315 
316         _totalSupply = _totalSupply.sub(value);
317         _balances[account] = _balances[account].sub(value);
318         emit Transfer(account, address(0), value);
319     }
320 
321     function _approve(address owner, address spender, uint256 value) internal {
322         require(owner != address(0), "ERC20: approve from the zero address");
323         require(spender != address(0), "ERC20: approve to the zero address");
324 
325         _allowances[owner][spender] = value;
326         emit Approval(owner, spender, value);
327     }
328 
329     function _burnFrom(address account, uint256 amount) internal {
330         _burn(account, amount);
331         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
332     }
333 }
334 
335 
336 pragma solidity ^0.5.0;
337 
338 contract CHI is ERC20 {
339 
340     string private _name;
341     string private _symbol;
342     uint8 private _decimals;
343 
344     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
345       _name = name;
346       _symbol = symbol;
347       _decimals = decimals;
348 
349       _mint(tokenOwnerAddress, totalSupply);
350 
351       feeReceiver.transfer(msg.value);
352     }
353 
354     function burn(uint256 value) public {
355       _burn(msg.sender, value);
356     }
357 
358     function name() public view returns (string memory) {
359       return _name;
360     }
361 
362     function symbol() public view returns (string memory) {
363       return _symbol;
364     }
365 
366     function decimals() public view returns (uint8) {
367       return _decimals;
368     }
369 }