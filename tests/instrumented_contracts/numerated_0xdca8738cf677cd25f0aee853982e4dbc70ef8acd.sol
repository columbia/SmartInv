1 pragma solidity 0.6.1;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 }
18 
19 
20 /**
21  * @dev Wrappers over Solidity's arithmetic operations with added overflow
22  * checks.
23  *
24  * Arithmetic operations in Solidity wrap on overflow. This can easily result
25  * in bugs, because programmers usually assume that an overflow raises an
26  * error, which is the standard behavior in high level programming languages.
27  * `SafeMath` restores this intuition by reverting the transaction when an
28  * operation overflows.
29  *
30  * Using this library instead of the unchecked operations eliminates an entire
31  * class of bugs, so it's recommended to use it always.
32  */
33 library SafeMath {
34     /**
35      * @dev Returns the addition of two unsigned integers, reverting on
36      * overflow.
37      *
38      * Counterpart to Solidity's `+` operator.
39      *
40      * Requirements:
41      * - Addition cannot overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return sub(a, b, "SafeMath: subtraction overflow");
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
65      * overflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `*` operator.
84      *
85      * Requirements:
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      */
128     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * Reverts when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         return mod(a, b, "SafeMath: modulo by zero");
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts with custom message when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b != 0, errorMessage);
164         return a % b;
165     }
166 }
167 
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP.
171  */
172 interface IERC20 {
173     /**
174      * @dev Returns the amount of tokens in existence.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns the amount of tokens owned by `account`.
180      */
181     function balanceOf(address account) external view returns (uint256);
182 
183     /**
184      * @dev Moves `amount` tokens from the caller's account to `recipient`.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transfer(address recipient, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Returns the remaining number of tokens that `spender` will be
194      * allowed to spend on behalf of `owner` through {transferFrom}. This is
195      * zero by default.
196      *
197      * This value changes when {approve} or {transferFrom} are called.
198      */
199     function allowance(address owner, address spender) external view returns (uint256);
200 
201     /**
202      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * IMPORTANT: Beware that changing an allowance with this method brings the risk
207      * that someone may use both the old and the new allowance by unfortunate
208      * transaction ordering. One possible solution to mitigate this race
209      * condition is to first reduce the spender's allowance to 0 and set the
210      * desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address spender, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Moves `amount` tokens from `sender` to `recipient` using the
219      * allowance mechanism. `amount` is then deducted from the caller's
220      * allowance.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
230      * another (`to`).
231      *
232      * Note that `value` may be zero.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     /**
237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
238      * a call to {approve}. `value` is the new allowance.
239      */
240     event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 
244 /**
245  * @dev Implementation of the {IERC20} interface.
246  *
247  * This implementation is agnostic to the way tokens are created. This means
248  * that a supply mechanism has to be added in a derived contract using {_mint}.
249  * For a generic mechanism see {ERC20MinterPauser}.
250  *
251  * TIP: For a detailed writeup see our guide
252  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
253  * to implement supply mechanisms].
254  *
255  * We have followed general OpenZeppelin guidelines: functions revert instead
256  * of returning `false` on failure. This behavior is nonetheless conventional
257  * and does not conflict with the expectations of ERC20 applications.
258  *
259  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See {IERC20-approve}.
267  */
268 contract ERC20 is Context, IERC20 {
269     using SafeMath for uint256;
270 
271     mapping (address => uint256) private _balances;
272 
273     mapping (address => mapping (address => uint256)) private _allowances;
274 
275     uint256 private _totalSupply;
276 
277     string private _name;
278     string private _symbol;
279     uint8 private _decimals;
280 
281     /**
282      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
283      * a default value of 18.
284      *
285      * All three of these values are immutable: they can only be set once during
286      * construction.
287      */
288     constructor (string memory name, string memory symbol, uint256 totalSupply, address owner) public {
289         _name = name;
290         _symbol = symbol;
291         _decimals = 18;
292         _totalSupply = totalSupply;
293         _balances[owner] = totalSupply;
294         emit Transfer(address(0), owner, _totalSupply);
295     }
296 
297     /**
298      * @dev Returns the name of the token.
299      */
300     function name() public view returns (string memory) {
301         return _name;
302     }
303 
304     /**
305      * @dev Returns the symbol of the token, usually a shorter version of the
306      * name.
307      */
308     function symbol() public view returns (string memory) {
309         return _symbol;
310     }
311 
312     /**
313      * @dev Returns the number of decimals used to get its user representation.
314      * For example, if `decimals` equals `2`, a balance of `505` tokens should
315      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
316      *
317      * Tokens usually opt for a value of 18, imitating the relationship between
318      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
319      * called.
320      *
321      * NOTE: This information is only used for _display_ purposes: it in
322      * no way affects any of the arithmetic of the contract, including
323      * {IERC20-balanceOf} and {IERC20-transfer}.
324      */
325     function decimals() public view returns (uint8) {
326         return _decimals;
327     }
328 
329     /**
330      * @dev See {IERC20-totalSupply}.
331      */
332     function totalSupply() public view override returns (uint256) {
333         return _totalSupply;
334     }
335 
336     /**
337      * @dev See {IERC20-balanceOf}.
338      */
339     function balanceOf(address account) public view override returns (uint256) {
340         return _balances[account];
341     }
342 
343     /**
344      * @dev See {IERC20-transfer}.
345      *
346      * Requirements:
347      *
348      * - `recipient` cannot be the zero address.
349      * - the caller must have a balance of at least `amount`.
350      */
351     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
352         _transfer(_msgSender(), recipient, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-allowance}.
358      */
359     function allowance(address owner, address spender) public view virtual override returns (uint256) {
360         return _allowances[owner][spender];
361     }
362 
363     /**
364      * @dev See {IERC20-approve}.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function approve(address spender, uint256 amount) public virtual override returns (bool) {
371         _approve(_msgSender(), spender, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-transferFrom}.
377      *
378      * Emits an {Approval} event indicating the updated allowance. This is not
379      * required by the EIP. See the note at the beginning of {ERC20};
380      *
381      * Requirements:
382      * - `sender` and `recipient` cannot be the zero address.
383      * - `sender` must have a balance of at least `amount`.
384      * - the caller must have allowance for ``sender``'s tokens of at least
385      * `amount`.
386      */
387     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
388         _transfer(sender, recipient, amount);
389         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
390         return true;
391     }
392 
393     /**
394      * @dev Atomically increases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
407         return true;
408     }
409 
410     /**
411      * @dev Atomically decreases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      * - `spender` must have allowance for the caller of at least
422      * `subtractedValue`.
423      */
424     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
425         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
426         return true;
427     }
428 
429     /**
430      * @dev Moves tokens `amount` from `sender` to `recipient`.
431      *
432      * This is internal function is equivalent to {transfer}, and can be used to
433      * e.g. implement automatic token fees, slashing mechanisms, etc.
434      *
435      * Emits a {Transfer} event.
436      *
437      * Requirements:
438      *
439      * - `sender` cannot be the zero address.
440      * - `recipient` cannot be the zero address.
441      * - `sender` must have a balance of at least `amount`.
442      */
443     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
444         require(sender != address(0), "ERC20: transfer from the zero address");
445         require(recipient != address(0), "ERC20: transfer to the zero address");
446         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
447         _balances[recipient] = _balances[recipient].add(amount);
448         emit Transfer(sender, recipient, amount);
449     }
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
453      *
454      * This is internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(address owner, address spender, uint256 amount) internal virtual {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = amount;
469         emit Approval(owner, spender, amount);
470     }
471 }
472 
473 
474 contract CZToken is ERC20 {
475 
476     string internal constant _name = "CJZVIPE";
477     string internal constant _symbol = "CZ";
478     address public constant tokenWallet = 0x94a5FBD613dA03a91f9E2Fb444F63F6f6bb60f35;
479     uint256 public constant INIT_TOTALSUPPLY = 30000000*10**18;
480 
481     constructor () public ERC20(_name, _symbol, INIT_TOTALSUPPLY, tokenWallet) {
482 
483     }
484    
485 }