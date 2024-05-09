1 pragma solidity ^0.6.0;
2 
3 interface IERC20 {
4 
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 pragma solidity ^0.6.0;
76 
77 library SafeMath {
78     /**
79      * @dev Returns the addition of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `+` operator.
83      *
84      * Requirements:
85      *
86      * - Addition cannot overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "SafeMath: addition overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b <= a, errorMessage);
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      *
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return div(a, b, "SafeMath: division by zero");
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b > 0, errorMessage);
180         uint256 c = a / b;
181         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
188      * Reverts when dividing by zero.
189      *
190      * Counterpart to Solidity's `%` operator. This function uses a `revert`
191      * opcode (which leaves remaining gas untouched) while Solidity uses an
192      * invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
199         return mod(a, b, "SafeMath: modulo by zero");
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts with custom message when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b != 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 pragma solidity ^0.6.0;
221 
222 contract ERC20 is IERC20 {
223     using SafeMath for uint256;
224 
225     mapping (address => uint256) private _balances;
226 
227     mapping (address => mapping (address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     string private _name;
232     string private _symbol;
233     uint8 private _decimals;
234 
235     /**
236      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
237      * a default value of 18.
238      *
239      * To select a different value for {decimals}, use {_setupDecimals}.
240      *
241      * All three of these values are immutable: they can only be set once during
242      * construction.
243      */
244     constructor (string memory name, string memory symbol, uint8 decimals) public {
245         _name = name;
246         _symbol = symbol;
247         _decimals = decimals;
248     }
249 
250     /**
251      * @dev Returns the name of the token.
252      */
253     function name() public view returns (string memory) {
254         return _name;
255     }
256 
257     /**
258      * @dev Returns the symbol of the token, usually a shorter version of the
259      * name.
260      */
261     function symbol() public view returns (string memory) {
262         return _symbol;
263     }
264 
265     /**
266      * @dev Returns the number of decimals used to get its user representation.
267      * For example, if `decimals` equals `2`, a balance of `505` tokens should
268      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
269      *
270      * Tokens usually opt for a value of 18, imitating the relationship between
271      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
272      * called.
273      *
274      * NOTE: This information is only used for _display_ purposes: it in
275      * no way affects any of the arithmetic of the contract, including
276      * {IERC20-balanceOf} and {IERC20-transfer}.
277      */
278     function decimals() public view returns (uint8) {
279         return _decimals;
280     }
281 
282     /**
283      * @dev See {IERC20-totalSupply}.
284      */
285     function totalSupply() public view override returns (uint256) {
286         return _totalSupply;
287     }
288 
289     /**
290      * @dev See {IERC20-balanceOf}.
291      */
292     function balanceOf(address account) public view override returns (uint256) {
293         return _balances[account];
294     }
295 
296     /**
297      * @dev See {IERC20-transfer}.
298      *
299      * Requirements:
300      *
301      * - `recipient` cannot be the zero address.
302      * - the caller must have a balance of at least `amount`.
303      */
304     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
305         _transfer(msg.sender, recipient, amount);
306         return true;
307     }
308 
309     /**
310      * @dev See {IERC20-allowance}.
311      */
312     function allowance(address owner, address spender) public view virtual override returns (uint256) {
313         return _allowances[owner][spender];
314     }
315 
316     /**
317      * @dev See {IERC20-approve}.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function approve(address spender, uint256 amount) public virtual override returns (bool) {
324         _approve(msg.sender, spender, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-transferFrom}.
330      *
331      * Emits an {Approval} event indicating the updated allowance. This is not
332      * required by the EIP. See the note at the beginning of {ERC20};
333      *
334      * Requirements:
335      * - `sender` and `recipient` cannot be the zero address.
336      * - `sender` must have a balance of at least `amount`.
337      * - the caller must have allowance for ``sender``'s tokens of at least
338      * `amount`.
339      */
340     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
341         _transfer(sender, recipient, amount);
342         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
343         return true;
344     }
345 
346     /**
347      * @dev Atomically increases the allowance granted to `spender` by the caller.
348      *
349      * This is an alternative to {approve} that can be used as a mitigation for
350      * problems described in {IERC20-approve}.
351      *
352      * Emits an {Approval} event indicating the updated allowance.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
359         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
360         return true;
361     }
362 
363     /**
364      * @dev Atomically decreases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      * - `spender` must have allowance for the caller of at least
375      * `subtractedValue`.
376      */
377     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
378         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
379         return true;
380     }
381 
382     /**
383      * @dev Moves tokens `amount` from `sender` to `recipient`.
384      *
385      * This is internal function is equivalent to {transfer}, and can be used to
386      * e.g. implement automatic token fees, slashing mechanisms, etc.
387      *
388      * Emits a {Transfer} event.
389      *
390      * Requirements:
391      *
392      * - `sender` cannot be the zero address.
393      * - `recipient` cannot be the zero address.
394      * - `sender` must have a balance of at least `amount`.
395      */
396     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
397         require(sender != address(0), "ERC20: transfer from the zero address");
398         require(recipient != address(0), "ERC20: transfer to the zero address");
399 
400         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
401         _balances[recipient] = _balances[recipient].add(amount);
402         emit Transfer(sender, recipient, amount);
403     }
404 
405     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
406      * the total supply.
407      *
408      * Emits a {Transfer} event with `from` set to the zero address.
409      *
410      * Requirements
411      *
412      * - `to` cannot be the zero address.
413      */
414     function _mint(address account, uint256 amount) internal virtual {
415         require(account != address(0), "ERC20: mint to the zero address");
416 
417         _totalSupply = _totalSupply.add(amount);
418         _balances[account] = _balances[account].add(amount);
419         emit Transfer(address(0), account, amount);
420     }
421 
422     /**
423      * @dev Destroys `amount` tokens from `account`, reducing the
424      * total supply.
425      *
426      * Emits a {Transfer} event with `to` set to the zero address.
427      *
428      * Requirements
429      *
430      * - `account` cannot be the zero address.
431      * - `account` must have at least `amount` tokens.
432      */
433     function _burn(address account, uint256 amount) internal virtual {
434         require(account != address(0), "ERC20: burn from the zero address");
435 
436         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
437         _totalSupply = _totalSupply.sub(amount);
438         emit Transfer(account, address(0), amount);
439     }
440 
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
443      *
444      * This is internal function is equivalent to `approve`, and can be used to
445      * e.g. set automatic allowances for certain subsystems, etc.
446      *
447      * Emits an {Approval} event.
448      *
449      * Requirements:
450      *
451      * - `owner` cannot be the zero address.
452      * - `spender` cannot be the zero address.
453      */
454     function _approve(address owner, address spender, uint256 amount) internal virtual {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[owner][spender] = amount;
459         emit Approval(owner, spender, amount);
460     }
461 }
462 
463 
464 pragma solidity ^0.6.0;
465 /**
466  * @dev Extension of {ERC20} that allows token holders to destroy both their own
467  * tokens and those that they have an allowance for, in a way that can be
468  * recognized off-chain (via event analysis).
469  */
470 abstract contract ERC20Burnable is ERC20 {
471     /**
472      * @dev Destroys `amount` tokens from the caller.
473      *
474      * See {ERC20-_burn}.
475      */
476     function burn(uint256 amount) public virtual {
477         _burn(msg.sender, amount);
478     }
479 
480     /**
481      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
482      * allowance.
483      *
484      * See {ERC20-_burn} and {ERC20-allowance}.
485      *
486      * Requirements:
487      *
488      * - the caller must have allowance for ``accounts``'s tokens of at least
489      * `amount`.
490      */
491     function burnFrom(address account, uint256 amount) public virtual {
492         uint256 decreasedAllowance = allowance(account, msg.sender).sub(amount, "ERC20: burn amount exceeds allowance");
493 
494         _approve(account, msg.sender, decreasedAllowance);
495         _burn(account, amount);
496     }
497 }
498 
499 pragma solidity ^0.6.0;
500 
501 contract BaguetteToken is ERC20Burnable {
502     uint256 public constant INITIAL_SUPPLY = 66524 * 10**3 * 10**18;
503 
504     constructor() ERC20("Baguette Token", "BGTT", 18) public {
505         _mint(msg.sender, INITIAL_SUPPLY);
506     }
507 }