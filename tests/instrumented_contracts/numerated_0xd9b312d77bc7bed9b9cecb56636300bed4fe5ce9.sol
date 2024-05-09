1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-28
3 */
4 
5 pragma solidity ^0.6.0;
6 
7 interface IERC20 {
8 
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
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 pragma solidity ^0.6.0;
80 
81 library SafeMath {
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a, "SafeMath: addition overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return sub(a, b, "SafeMath: subtraction overflow");
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b <= a, errorMessage);
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      *
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
144         if (a == 0) {
145             return 0;
146         }
147 
148         uint256 c = a * b;
149         require(c / a == b, "SafeMath: multiplication overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the integer division of two unsigned integers. Reverts on
156      * division by zero. The result is rounded towards zero.
157      *
158      * Counterpart to Solidity's `/` operator. Note: this function uses a
159      * `revert` opcode (which leaves remaining gas untouched) while Solidity
160      * uses an invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         return div(a, b, "SafeMath: division by zero");
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b > 0, errorMessage);
184         uint256 c = a / b;
185         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * Reverts when dividing by zero.
193      *
194      * Counterpart to Solidity's `%` operator. This function uses a `revert`
195      * opcode (which leaves remaining gas untouched) while Solidity uses an
196      * invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
203         return mod(a, b, "SafeMath: modulo by zero");
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts with custom message when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b != 0, errorMessage);
220         return a % b;
221     }
222 }
223 
224 pragma solidity ^0.6.0;
225 
226 contract ERC20 is IERC20 {
227     using SafeMath for uint256;
228 
229     mapping (address => uint256) private _balances;
230 
231     mapping (address => mapping (address => uint256)) private _allowances;
232 
233     uint256 private _totalSupply;
234 
235     string private _name;
236     string private _symbol;
237     uint8 private _decimals;
238 
239     /**
240      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
241      * a default value of 18.
242      *
243      * To select a different value for {decimals}, use {_setupDecimals}.
244      *
245      * All three of these values are immutable: they can only be set once during
246      * construction.
247      */
248     constructor (string memory name, string memory symbol, uint8 decimals) public {
249         _name = name;
250         _symbol = symbol;
251         _decimals = decimals;
252     }
253 
254     /**
255      * @dev Returns the name of the token.
256      */
257     function name() public view returns (string memory) {
258         return _name;
259     }
260 
261     /**
262      * @dev Returns the symbol of the token, usually a shorter version of the
263      * name.
264      */
265     function symbol() public view returns (string memory) {
266         return _symbol;
267     }
268 
269     /**
270      * @dev Returns the number of decimals used to get its user representation.
271      * For example, if `decimals` equals `2`, a balance of `505` tokens should
272      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
273      *
274      * Tokens usually opt for a value of 18, imitating the relationship between
275      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
276      * called.
277      *
278      * NOTE: This information is only used for _display_ purposes: it in
279      * no way affects any of the arithmetic of the contract, including
280      * {IERC20-balanceOf} and {IERC20-transfer}.
281      */
282     function decimals() public view returns (uint8) {
283         return _decimals;
284     }
285 
286     /**
287      * @dev See {IERC20-totalSupply}.
288      */
289     function totalSupply() public view override returns (uint256) {
290         return _totalSupply;
291     }
292 
293     /**
294      * @dev See {IERC20-balanceOf}.
295      */
296     function balanceOf(address account) public view override returns (uint256) {
297         return _balances[account];
298     }
299 
300     /**
301      * @dev See {IERC20-transfer}.
302      *
303      * Requirements:
304      *
305      * - `recipient` cannot be the zero address.
306      * - the caller must have a balance of at least `amount`.
307      */
308     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
309         _transfer(msg.sender, recipient, amount);
310         return true;
311     }
312 
313     /**
314      * @dev See {IERC20-allowance}.
315      */
316     function allowance(address owner, address spender) public view virtual override returns (uint256) {
317         return _allowances[owner][spender];
318     }
319 
320     /**
321      * @dev See {IERC20-approve}.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function approve(address spender, uint256 amount) public virtual override returns (bool) {
328         _approve(msg.sender, spender, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See {IERC20-transferFrom}.
334      *
335      * Emits an {Approval} event indicating the updated allowance. This is not
336      * required by the EIP. See the note at the beginning of {ERC20};
337      *
338      * Requirements:
339      * - `sender` and `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      * - the caller must have allowance for ``sender``'s tokens of at least
342      * `amount`.
343      */
344     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
345         _transfer(sender, recipient, amount);
346         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
347         return true;
348     }
349 
350     /**
351      * @dev Atomically increases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to {approve} that can be used as a mitigation for
354      * problems described in {IERC20-approve}.
355      *
356      * Emits an {Approval} event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      */
362     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
363         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
364         return true;
365     }
366 
367     /**
368      * @dev Atomically decreases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      * - `spender` must have allowance for the caller of at least
379      * `subtractedValue`.
380      */
381     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
382         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
383         return true;
384     }
385 
386     /**
387      * @dev Moves tokens `amount` from `sender` to `recipient`.
388      *
389      * This is internal function is equivalent to {transfer}, and can be used to
390      * e.g. implement automatic token fees, slashing mechanisms, etc.
391      *
392      * Emits a {Transfer} event.
393      *
394      * Requirements:
395      *
396      * - `sender` cannot be the zero address.
397      * - `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      */
400     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
401         require(sender != address(0), "ERC20: transfer from the zero address");
402         require(recipient != address(0), "ERC20: transfer to the zero address");
403 
404         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
405         _balances[recipient] = _balances[recipient].add(amount);
406         emit Transfer(sender, recipient, amount);
407     }
408 
409     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
410      * the total supply.
411      *
412      * Emits a {Transfer} event with `from` set to the zero address.
413      *
414      * Requirements
415      *
416      * - `to` cannot be the zero address.
417      */
418     function _mint(address account, uint256 amount) internal virtual {
419         require(account != address(0), "ERC20: mint to the zero address");
420 
421         _totalSupply = _totalSupply.add(amount);
422         _balances[account] = _balances[account].add(amount);
423         emit Transfer(address(0), account, amount);
424     }
425 
426     /**
427      * @dev Destroys `amount` tokens from `account`, reducing the
428      * total supply.
429      *
430      * Emits a {Transfer} event with `to` set to the zero address.
431      *
432      * Requirements
433      *
434      * - `account` cannot be the zero address.
435      * - `account` must have at least `amount` tokens.
436      */
437     function _burn(address account, uint256 amount) internal virtual {
438         require(account != address(0), "ERC20: burn from the zero address");
439 
440         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
441         _totalSupply = _totalSupply.sub(amount);
442         emit Transfer(account, address(0), amount);
443     }
444 
445     /**
446      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
447      *
448      * This is internal function is equivalent to `approve`, and can be used to
449      * e.g. set automatic allowances for certain subsystems, etc.
450      *
451      * Emits an {Approval} event.
452      *
453      * Requirements:
454      *
455      * - `owner` cannot be the zero address.
456      * - `spender` cannot be the zero address.
457      */
458     function _approve(address owner, address spender, uint256 amount) internal virtual {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461 
462         _allowances[owner][spender] = amount;
463         emit Approval(owner, spender, amount);
464     }
465 }
466 
467 
468 pragma solidity ^0.6.0;
469 /**
470  * @dev Extension of {ERC20} that allows token holders to destroy both their own
471  * tokens and those that they have an allowance for, in a way that can be
472  * recognized off-chain (via event analysis).
473  */
474 abstract contract ERC20Burnable is ERC20 {
475     /**
476      * @dev Destroys `amount` tokens from the caller.
477      *
478      * See {ERC20-_burn}.
479      */
480     function burn(uint256 amount) public virtual {
481         _burn(msg.sender, amount);
482     }
483 
484     /**
485      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
486      * allowance.
487      *
488      * See {ERC20-_burn} and {ERC20-allowance}.
489      *
490      * Requirements:
491      *
492      * - the caller must have allowance for ``accounts``'s tokens of at least
493      * `amount`.
494      */
495     function burnFrom(address account, uint256 amount) public virtual {
496         uint256 decreasedAllowance = allowance(account, msg.sender).sub(amount, "ERC20: burn amount exceeds allowance");
497 
498         _approve(account, msg.sender, decreasedAllowance);
499         _burn(account, amount);
500     }
501 }
502 
503 pragma solidity ^0.6.0;
504 
505 contract GainsToken is ERC20Burnable {
506     uint256 public constant INITIAL_SUPPLY = 10**8 * 10**18;
507 
508     constructor() ERC20("Gains", "GAINS", 18) public {
509         _mint(msg.sender, INITIAL_SUPPLY);
510     }
511 }