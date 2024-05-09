1 pragma solidity 0.6.12;
2 
3 // YAMv2: a temporary token in the evolution of the YAM protocol that allows the holder to vote for the future of the protocol in v3
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts with custom message when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b != 0, errorMessage);
150         return a % b;
151     }
152 }
153 
154 /**
155  * @dev Interface of the ERC20 standard as defined in the EIP.
156  */
157 interface IERC20 {
158     /**
159      * @dev Returns the amount of tokens in existence.
160      */
161     function totalSupply() external view returns (uint256);
162 
163     /**
164      * @dev Returns the amount of tokens owned by `account`.
165      */
166     function balanceOf(address account) external view returns (uint256);
167 
168     /**
169      * @dev Moves `amount` tokens from the caller's account to `recipient`.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transfer(address recipient, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Returns the remaining number of tokens that `spender` will be
179      * allowed to spend on behalf of `owner` through {transferFrom}. This is
180      * zero by default.
181      *
182      * This value changes when {approve} or {transferFrom} are called.
183      */
184     function allowance(address owner, address spender) external view returns (uint256);
185 
186     /**
187      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * IMPORTANT: Beware that changing an allowance with this method brings the risk
192      * that someone may use both the old and the new allowance by unfortunate
193      * transaction ordering. One possible solution to mitigate this race
194      * condition is to first reduce the spender's allowance to 0 and set the
195      * desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address spender, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Moves `amount` tokens from `sender` to `recipient` using the
204      * allowance mechanism. `amount` is then deducted from the caller's
205      * allowance.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Emitted when `value` tokens are moved from one account (`from`) to
215      * another (`to`).
216      *
217      * Note that `value` may be zero.
218      */
219     event Transfer(address indexed from, address indexed to, uint256 value);
220 
221     /**
222      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
223      * a call to {approve}. `value` is the new allowance.
224      */
225     event Approval(address indexed owner, address indexed spender, uint256 value);
226 }
227 
228 
229 /*
230  * @dev Provides information about the current execution context, including the
231  * sender of the transaction and its data. While these are generally available
232  * via msg.sender and msg.data, they should not be accessed in such a direct
233  * manner, since when dealing with GSN meta-transactions the account sending and
234  * paying for execution may not be the actual sender (as far as an application
235  * is concerned).
236  *
237  * This contract is only required for intermediate, library-like contracts.
238  */
239 contract Context {
240     // Empty internal constructor, to prevent people from mistakenly deploying
241     // an instance of this contract, which should be used via inheritance.
242     constructor () internal { }
243 
244     function _msgSender() internal view virtual returns (address payable) {
245         return msg.sender;
246     }
247 
248     function _msgData() internal view virtual returns (bytes memory) {
249         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
250         return msg.data;
251     }
252 }
253 
254 
255 
256 /**
257   * @title YAMv2 Token
258   * @dev YAMv2 Mintable Token with migration from legacy contract. Used to signal
259   *      for protocol changes in v3.
260   */
261 contract YAMv2 is Context, IERC20 {
262     using SafeMath for uint256;
263 
264     address public minter;
265 
266     mapping (address => uint256) private _balances;
267 
268     mapping (address => mapping (address => uint256)) private _allowances;
269 
270     uint256 private _totalSupply;
271 
272     string private _name;
273     string private _symbol;
274     uint8 private _decimals;
275 
276     modifier onlyMinter() {
277         require(_msgSender() == minter, "!minter");
278         _;
279     }
280 
281     /**
282      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
283      * a value of 24.
284      *
285      * All three of these values are immutable: they can only be set once during
286      * construction.
287      */
288     constructor (string memory name, string memory symbol, address minter_) public {
289         _name = name;
290         _symbol = symbol;
291         _setupDecimals(24); // match internalDecimals of YAMv1
292 
293         minter = minter_;
294     }
295 
296     /**
297      * @dev Returns the name of the token.
298      */
299     function name() public view returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @dev Returns the symbol of the token, usually a shorter version of the
305      * name.
306      */
307     function symbol() public view returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @dev Returns the number of decimals used to get its user representation.
313      * For example, if `decimals` equals `2`, a balance of `505` tokens should
314      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
315      *
316      * Tokens usually opt for a value of 18, imitating the relationship between
317      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
318      * called.
319      *
320      * NOTE: This information is only used for _display_ purposes: it in
321      * no way affects any of the arithmetic of the contract, including
322      * {IERC20-balanceOf} and {IERC20-transfer}.
323      */
324     function decimals() public view returns (uint8) {
325         return _decimals;
326     }
327 
328     /**
329      * @dev See {IERC20-totalSupply}.
330      */
331     function totalSupply() public view override returns (uint256) {
332         return _totalSupply;
333     }
334 
335     /**
336      * @dev See {IERC20-balanceOf}.
337      */
338     function balanceOf(address account) public view override returns (uint256) {
339         return _balances[account];
340     }
341 
342     /**
343      * @dev See {IERC20-transfer}.
344      *
345      * Requirements:
346      *
347      * - `recipient` cannot be the zero address.
348      * - the caller must have a balance of at least `amount`.
349      */
350     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
351         _transfer(_msgSender(), recipient, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-allowance}.
357      */
358     function allowance(address owner, address spender) public view virtual override returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     /**
363      * @dev See {IERC20-approve}.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function approve(address spender, uint256 amount) public virtual override returns (bool) {
370         _approve(_msgSender(), spender, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-transferFrom}.
376      *
377      * Emits an {Approval} event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of {ERC20};
379      *
380      * Requirements:
381      * - `sender` and `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `amount`.
383      * - the caller must have allowance for ``sender``'s tokens of at least
384      * `amount`.
385      */
386     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
387         _transfer(sender, recipient, amount);
388         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
389         return true;
390     }
391 
392     /**
393      * @dev Atomically increases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
406         return true;
407     }
408 
409     /**
410      * @dev Atomically decreases the allowance granted to `spender` by the caller.
411      *
412      * This is an alternative to {approve} that can be used as a mitigation for
413      * problems described in {IERC20-approve}.
414      *
415      * Emits an {Approval} event indicating the updated allowance.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      * - `spender` must have allowance for the caller of at least
421      * `subtractedValue`.
422      */
423     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
424         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
425         return true;
426     }
427 
428     /**
429      * @dev Moves tokens `amount` from `sender` to `recipient`.
430      *
431      * This is internal function is equivalent to {transfer}, and can be used to
432      * e.g. implement automatic token fees, slashing mechanisms, etc.
433      *
434      * Emits a {Transfer} event.
435      *
436      * Requirements:
437      *
438      * - `sender` cannot be the zero address.
439      * - `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `amount`.
441      */
442     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
443         require(sender != address(0), "ERC20: transfer from the zero address");
444         require(recipient != address(0), "ERC20: transfer to the zero address");
445 
446         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
447         _balances[recipient] = _balances[recipient].add(amount);
448         emit Transfer(sender, recipient, amount);
449     }
450 
451 
452     /** @dev Used by the migration contract
453      *
454      */
455     function mint(address account, uint256 amount) public virtual onlyMinter {
456         _mint(account, amount);
457     }
458 
459     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
460      * the total supply.
461      *
462      * Emits a {Transfer} event with `from` set to the zero address.
463      *
464      * Requirements
465      *
466      * - `to` cannot be the zero address.
467      */
468     function _mint(address account, uint256 amount) internal virtual {
469         require(account != address(0), "ERC20: mint to the zero address");
470 
471         _totalSupply = _totalSupply.add(amount);
472         _balances[account] = _balances[account].add(amount);
473         emit Transfer(address(0), account, amount);
474     }
475 
476     /**
477      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
478      *
479      * This is internal function is equivalent to `approve`, and can be used to
480      * e.g. set automatic allowances for certain subsystems, etc.
481      *
482      * Emits an {Approval} event.
483      *
484      * Requirements:
485      *
486      * - `owner` cannot be the zero address.
487      * - `spender` cannot be the zero address.
488      */
489     function _approve(address owner, address spender, uint256 amount) internal virtual {
490         require(owner != address(0), "ERC20: approve from the zero address");
491         require(spender != address(0), "ERC20: approve to the zero address");
492 
493         _allowances[owner][spender] = amount;
494         emit Approval(owner, spender, amount);
495     }
496 
497     /**
498      * @dev Sets {decimals} to a value other than the default one of 18.
499      *
500      * WARNING: This function should only be called from the constructor. Most
501      * applications that interact with token contracts will not expect
502      * {decimals} to ever change, and may work incorrectly if it does.
503      */
504     function _setupDecimals(uint8 decimals_) internal {
505         _decimals = decimals_;
506     }
507 }