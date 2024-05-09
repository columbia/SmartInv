1 // File: contracts/GSN/Context.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19 
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: contracts/math/SafeMath.sol
31 
32 pragma solidity ^0.6.6;
33 
34 /**
35  * @dev Wrappers over Solidity's arithmetic operations with added overflow
36  * checks.
37  *
38  * Arithmetic operations in Solidity wrap on overflow. This can easily result
39  * in bugs, because programmers usually assume that an overflow raises an
40  * error, which is the standard behavior in high level programming languages.
41  * `SafeMath` restores this intuition by reverting the transaction when an
42  * operation overflows.
43  *
44  * Using this library instead of the unchecked operations eliminates an entire
45  * class of bugs, so it's recommended to use it always.
46  */
47 library SafeMath {
48     /**
49      * @dev Returns the addition of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `+` operator.
53      *
54      * Requirements:
55      * - Addition cannot overflow.
56      */
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      * - Subtraction cannot overflow.
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      */
142     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         // Solidity only automatically asserts when dividing by 0
144         require(b > 0, errorMessage);
145         uint256 c = a / b;
146         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return mod(a, b, "SafeMath: modulo by zero");
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts with custom message when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b != 0, errorMessage);
179         return a % b;
180     }
181 }
182 
183 // File: contracts/token/IERC20.sol
184 
185 pragma solidity ^0.6.6;
186 
187 /**
188  * @dev Interface of the ERC20 standard as defined in the EIP.
189  */
190 interface IERC20 {
191     /**
192      * @dev Returns the amount of tokens in existence.
193      */
194     function totalSupply() external view returns (uint256);
195 
196     /**
197      * @dev Returns the amount of tokens owned by `account`.
198      */
199     function balanceOf(address account) external view returns (uint256);
200 
201     /**
202      * @dev Moves `amount` tokens from the caller's account to `recipient`.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transfer(address recipient, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Returns the remaining number of tokens that `spender` will be
212      * allowed to spend on behalf of `owner` through {transferFrom}. This is
213      * zero by default.
214      *
215      * This value changes when {approve} or {transferFrom} are called.
216      */
217     function allowance(address owner, address spender) external view returns (uint256);
218 
219     /**
220      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * IMPORTANT: Beware that changing an allowance with this method brings the risk
225      * that someone may use both the old and the new allowance by unfortunate
226      * transaction ordering. One possible solution to mitigate this race
227      * condition is to first reduce the spender's allowance to 0 and set the
228      * desired value afterwards:
229      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230      *
231      * Emits an {Approval} event.
232      */
233     function approve(address spender, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Moves `amount` tokens from `sender` to `recipient` using the
237      * allowance mechanism. `amount` is then deducted from the caller's
238      * allowance.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Emitted when `value` tokens are moved from one account (`from`) to
248      * another (`to`).
249      *
250      * Note that `value` may be zero.
251      */
252     event Transfer(address indexed from, address indexed to, uint256 value);
253 
254     /**
255      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
256      * a call to {approve}. `value` is the new allowance.
257      */
258     event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260 
261 // File: contracts/token/ERC20.sol
262 
263 pragma solidity ^0.6.6;
264 
265 
266 
267 
268 /**
269  * @dev Implementation of the {IERC20} interface.
270  *
271  * This implementation is agnostic to the way tokens are created. This means
272  * that a supply mechanism has to be added in a derived contract using {_mint}.
273  * For a generic mechanism see {ERC20MinterPauser}.
274  *
275  * TIP: For a detailed writeup see our guide
276  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
277  * to implement supply mechanisms].
278  *
279  * We have followed general OpenZeppelin guidelines: functions revert instead
280  * of returning `false` on failure. This behavior is nonetheless conventional
281  * and does not conflict with the expectations of ERC20 applications.
282  *
283  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
284  * This allows applications to reconstruct the allowance for all accounts just
285  * by listening to said events. Other implementations of the EIP may not emit
286  * these events, as it isn't required by the specification.
287  *
288  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
289  * functions have been added to mitigate the well-known issues around setting
290  * allowances. See {IERC20-approve}.
291  */
292 contract ERC20 is Context, IERC20 {
293     using SafeMath for uint256;
294 
295     mapping (address => uint256) private _balances;
296     mapping (address => mapping (address => uint256)) private _allowances;
297     uint256 private _totalSupply;
298 
299     string private _name;
300     string private _symbol;
301     uint8 private _decimals;
302 
303     /**
304      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
305      * a default value of 18.
306      *
307      * All three of these values are immutable: they can only be set once during
308      * construction.
309      */
310     constructor (string memory name, string memory symbol, uint8 decimals) public {
311         _name = name;
312         _symbol = symbol;
313         _decimals = decimals;
314     }
315 
316     /**
317      * @dev Returns the name of the token.
318      */
319     function name() public view returns (string memory) {
320         return _name;
321     }
322 
323     /**
324      * @dev Returns the symbol of the token, usually a shorter version of the
325      * name.
326      */
327     function symbol() public view returns (string memory) {
328         return _symbol;
329     }
330 
331     /**
332      * @dev Returns the number of decimals used to get its user representation.
333      * For example, if `decimals` equals `2`, a balance of `505` tokens should
334      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
335      *
336      * NOTE: This information is only used for _display_ purposes: it in
337      * no way affects any of the arithmetic of the contract, including
338      * {IERC20-balanceOf} and {IERC20-transfer}.
339      */
340     function decimals() public view returns (uint8) {
341         return _decimals;
342     }
343 
344     /**
345      * @dev See {IERC20-totalSupply}.
346      */
347     function totalSupply() public view override returns (uint256) {
348         return _totalSupply;
349     }
350 
351     /**
352      * @dev See {IERC20-balanceOf}.
353      */
354     function balanceOf(address account) public view override returns (uint256) {
355         return _balances[account];
356     }
357 
358     /**
359      * @dev See {IERC20-transfer}.
360      *
361      * Requirements:
362      *
363      * - `recipient` cannot be the zero address.
364      * - the caller must have a balance of at least `amount`.
365      */
366     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
367         _transfer(_msgSender(), recipient, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-allowance}.
373      */
374     function allowance(address owner, address spender) public view virtual override returns (uint256) {
375         return _allowances[owner][spender];
376     }
377 
378     /**
379      * @dev See {IERC20-approve}.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function approve(address spender, uint256 amount) public virtual override returns (bool) {
386         _approve(_msgSender(), spender, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-transferFrom}.
392      *
393      * Emits an {Approval} event indicating the updated allowance. This is not
394      * required by the EIP. See the note at the beginning of {ERC20};
395      *
396      * Requirements:
397      * - `sender` and `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      * - the caller must have allowance for ``sender``'s tokens of at least
400      * `amount`.
401      */
402     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
403         _transfer(sender, recipient, amount);
404         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
405         return true;
406     }
407 
408     /**
409      * @dev Atomically increases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      */
420     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
421         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
422         return true;
423     }
424 
425     /**
426      * @dev Atomically decreases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      * - `spender` must have allowance for the caller of at least
437      * `subtractedValue`.
438      */
439     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
440         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
441         return true;
442     }
443 
444     /**
445      * @dev Moves tokens `amount` from `sender` to `recipient`.
446      *
447      * This is internal function is equivalent to {transfer}, and can be used to
448      * e.g. implement automatic token fees, slashing mechanisms, etc.
449      *
450      * Emits a {Transfer} event.
451      *
452      * Requirements:
453      *
454      * - `sender` cannot be the zero address.
455      * - `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      */
458     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
463         _balances[recipient] = _balances[recipient].add(amount);
464         emit Transfer(sender, recipient, amount);
465     }
466 
467     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
468      * the total supply.
469      *
470      * Emits a {Transfer} event with `from` set to the zero address.
471      *
472      * Requirements
473      *
474      * - `to` cannot be the zero address.
475      */
476     function _mint(address account, uint256 amount) internal virtual {
477         require(account != address(0), "ERC20: mint to the zero address");
478 
479         _totalSupply = _totalSupply.add(amount);
480         _balances[account] = _balances[account].add(amount);
481         emit Transfer(address(0), account, amount);
482     }
483 
484     /**
485      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
486      *
487      * This is internal function is equivalent to `approve`, and can be used to
488      * e.g. set automatic allowances for certain subsystems, etc.
489      *
490      * Emits an {Approval} event.
491      *
492      * Requirements:
493      *
494      * - `owner` cannot be the zero address.
495      * - `spender` cannot be the zero address.
496      */
497     function _approve(address owner, address spender, uint256 amount) internal virtual {
498         require(owner != address(0), "ERC20: approve from the zero address");
499         require(spender != address(0), "ERC20: approve to the zero address");
500 
501         _allowances[owner][spender] = amount;
502         emit Approval(owner, spender, amount);
503     }
504 }
505 
506 // File: contracts/token/NBOT.sol
507 
508 pragma solidity ^0.6.6;
509 
510 
511 /**
512  * NBOT is an ERC20 implemention of the Naka Bodhi Token.
513  * It is created with a static supply of 100,000,000 NBOT to the owner address.
514  * No future NBOT tokens will be created.
515  */
516 contract NBOT is ERC20 {
517     uint8 constant DECIMALS = 18;
518 
519     constructor() ERC20("Bodhi Token", "NBOT", DECIMALS) public {
520         // Mint total supply to msg.sender
521         uint256 supply = 100000000 * (10 ** uint256(DECIMALS));
522         _mint(_msgSender(), supply);
523     }
524 }