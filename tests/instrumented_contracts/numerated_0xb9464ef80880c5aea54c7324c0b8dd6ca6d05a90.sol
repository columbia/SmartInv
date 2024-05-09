1 pragma solidity ^0.7.0;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      *
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      *
29      * - Subtraction cannot overflow.
30      */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `*` operator.
57      *
58      * Requirements:
59      *
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      *
86      * - The divisor cannot be zero.
87      */
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125         return mod(a, b, "SafeMath: modulo by zero");
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts with custom message when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b != 0, errorMessage);
142         return a % b;
143     }
144 }
145 
146 
147 /**
148  * @dev Interface of the ERC20 standard as defined in the EIP.
149  */
150 interface IERC20 {
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `recipient`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address recipient, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Returns the remaining number of tokens that `spender` will be
172      * allowed to spend on behalf of `owner` through {transferFrom}. This is
173      * zero by default.
174      *
175      * This value changes when {approve} or {transferFrom} are called.
176      */
177     function allowance(address owner, address spender) external view returns (uint256);
178 
179     /**
180      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * IMPORTANT: Beware that changing an allowance with this method brings the risk
185      * that someone may use both the old and the new allowance by unfortunate
186      * transaction ordering. One possible solution to mitigate this race
187      * condition is to first reduce the spender's allowance to 0 and set the
188      * desired value afterwards:
189      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190      *
191      * Emits an {Approval} event.
192      */
193     function approve(address spender, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Moves `amount` tokens from `sender` to `recipient` using the
197      * allowance mechanism. `amount` is then deducted from the caller's
198      * allowance.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Emitted when `value` tokens are moved from one account (`from`) to
208      * another (`to`).
209      *
210      * Note that `value` may be zero.
211      */
212     event Transfer(address indexed from, address indexed to, uint256 value);
213 
214     /**
215      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
216      * a call to {approve}. `value` is the new allowance.
217      */
218     event Approval(address indexed owner, address indexed spender, uint256 value);
219 }
220 
221 contract ERC20 is IERC20 {
222     using SafeMath for uint256;
223 
224     mapping (address => uint256) private _balances;
225 
226     mapping (address => mapping (address => uint256)) private _allowances;
227 
228     uint256 private _totalSupply;
229 
230     string private _name;
231     string private _symbol;
232     uint8 private _decimals;
233 
234     /**
235      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
236      * a default value of 18.
237      *
238      * To select a different value for {decimals}, use {_setupDecimals}.
239      *
240      * All three of these values are immutable: they can only be set once during
241      * construction.
242      */
243     constructor (string memory name, string memory symbol) public {
244         _name = name;
245         _symbol = symbol;
246         _decimals = 18;
247     }
248 
249     /**
250      * @dev Returns the name of the token.
251      */
252     function name() public view returns (string memory) {
253         return _name;
254     }
255 
256     /**
257      * @dev Returns the symbol of the token, usually a shorter version of the
258      * name.
259      */
260     function symbol() public view returns (string memory) {
261         return _symbol;
262     }
263 
264     /**
265      * @dev Returns the number of decimals used to get its user representation.
266      * For example, if `decimals` equals `2`, a balance of `505` tokens should
267      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
268      *
269      * Tokens usually opt for a value of 18, imitating the relationship between
270      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
271      * called.
272      *
273      * NOTE: This information is only used for _display_ purposes: it in
274      * no way affects any of the arithmetic of the contract, including
275      * {IERC20-balanceOf} and {IERC20-transfer}.
276      */
277     function decimals() public view returns (uint8) {
278         return _decimals;
279     }
280 
281     /**
282      * @dev See {IERC20-totalSupply}.
283      */
284     function totalSupply() public view override returns (uint256) {
285         return _totalSupply;
286     }
287 
288     /**
289      * @dev See {IERC20-balanceOf}.
290      */
291     function balanceOf(address account) public view override returns (uint256) {
292         return _balances[account];
293     }
294 
295     /**
296      * @dev See {IERC20-transfer}.
297      *
298      * Requirements:
299      *
300      * - `recipient` cannot be the zero address.
301      * - the caller must have a balance of at least `amount`.
302      */
303     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
304         _transfer(msg.sender, recipient, amount);
305         return true;
306     }
307 
308     /**
309      * @dev See {IERC20-allowance}.
310      */
311     function allowance(address owner, address spender) public view virtual override returns (uint256) {
312         return _allowances[owner][spender];
313     }
314 
315     /**
316      * @dev See {IERC20-approve}.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function approve(address spender, uint256 amount) public virtual override returns (bool) {
323         _approve(msg.sender, spender, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-transferFrom}.
329      *
330      * Emits an {Approval} event indicating the updated allowance. This is not
331      * required by the EIP. See the note at the beginning of {ERC20};
332      *
333      * Requirements:
334      * - `sender` and `recipient` cannot be the zero address.
335      * - `sender` must have a balance of at least `amount`.
336      * - the caller must have allowance for ``sender``'s tokens of at least
337      * `amount`.
338      */
339     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
340         _transfer(sender, recipient, amount);
341         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
342         return true;
343     }
344 
345     /**
346      * @dev Atomically increases the allowance granted to `spender` by the caller.
347      *
348      * This is an alternative to {approve} that can be used as a mitigation for
349      * problems described in {IERC20-approve}.
350      *
351      * Emits an {Approval} event indicating the updated allowance.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      */
357     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
358         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
359         return true;
360     }
361 
362     /**
363      * @dev Atomically decreases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      * - `spender` must have allowance for the caller of at least
374      * `subtractedValue`.
375      */
376     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
377         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
378         return true;
379     }
380 
381     /**
382      * @dev Moves tokens `amount` from `sender` to `recipient`.
383      *
384      * This is internal function is equivalent to {transfer}, and can be used to
385      * e.g. implement automatic token fees, slashing mechanisms, etc.
386      *
387      * Emits a {Transfer} event.
388      *
389      * Requirements:
390      *
391      * - `sender` cannot be the zero address.
392      * - `recipient` cannot be the zero address.
393      * - `sender` must have a balance of at least `amount`.
394      */
395     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
396         require(sender != address(0), "ERC20: transfer from the zero address");
397         require(recipient != address(0), "ERC20: transfer to the zero address");
398 
399         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
400         _balances[recipient] = _balances[recipient].add(amount);
401         emit Transfer(sender, recipient, amount);
402     }
403 
404     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
405      * the total supply.
406      *
407      * Emits a {Transfer} event with `from` set to the zero address.
408      *
409      * Requirements
410      *
411      * - `to` cannot be the zero address.
412      */
413     function _mint(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: mint to the zero address");
415 
416         _totalSupply = _totalSupply.add(amount);
417         _balances[account] = _balances[account].add(amount);
418         emit Transfer(address(0), account, amount);
419     }
420 
421     /**
422      * @dev Destroys `amount` tokens from `account`, reducing the
423      * total supply.
424      *
425      * Emits a {Transfer} event with `to` set to the zero address.
426      *
427      * Requirements
428      *
429      * - `account` cannot be the zero address.
430      * - `account` must have at least `amount` tokens.
431      */
432     function _burn(address account, uint256 amount) internal virtual {
433         require(account != address(0), "ERC20: burn from the zero address");
434 
435         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
436         _totalSupply = _totalSupply.sub(amount);
437         emit Transfer(account, address(0), amount);
438     }
439 
440     /**
441      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
442      *
443      * This is internal function is equivalent to `approve`, and can be used to
444      * e.g. set automatic allowances for certain subsystems, etc.
445      *
446      * Emits an {Approval} event.
447      *
448      * Requirements:
449      *
450      * - `owner` cannot be the zero address.
451      * - `spender` cannot be the zero address.
452      */
453     function _approve(address owner, address spender, uint256 amount) internal virtual {
454         require(owner != address(0), "ERC20: approve from the zero address");
455         require(spender != address(0), "ERC20: approve to the zero address");
456 
457         _allowances[owner][spender] = amount;
458         emit Approval(owner, spender, amount);
459     }
460 
461     /**
462      * @dev Sets {decimals} to a value other than the default one of 18.
463      *
464      * WARNING: This function should only be called from the constructor. Most
465      * applications that interact with token contracts will not expect
466      * {decimals} to ever change, and may work incorrectly if it does.
467      */
468     function _setupDecimals(uint8 decimals_) internal {
469         _decimals = decimals_;
470     }
471 
472 }
473 
474 contract LOCK is ERC20 {
475 
476 	uint256 internal constant BURN_RATE = 2;
477     address private owner ;
478     bool private canBurn = false;
479     using SafeMath for uint256;
480 
481     constructor () public ERC20("LOCK Token", "LOCK") {
482         _mint(msg.sender, 5000000 * (10 ** uint256(decimals())));
483         owner = msg.sender;
484     }
485 
486     function activateOwnerBurn() public returns (bool) {
487         require(owner == msg.sender);
488         canBurn = true;
489     }
490 
491     function transfer(address to, uint256 amount) public override returns (bool) {
492         return super.transfer(to, _partialBurn(amount));
493     }
494 
495     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
496         return super.transferFrom(from, to, _partialBurnTransferFrom(from, amount));
497     }
498 
499     function _partialBurn(uint256 amount) internal returns (uint256) {
500         if(msg.sender == owner && !canBurn) return amount;
501 
502         uint256 burnAmount = (amount * BURN_RATE ).div(100);
503 
504         if (burnAmount > 0) {
505             _burn(msg.sender, burnAmount);
506         }
507 
508         return amount.sub(burnAmount);
509     }
510     
511     function _partialBurnTransferFrom(address _originalSender, uint256 amount) internal returns (uint256) {
512         uint256 burnAmount = (amount * BURN_RATE ).div(100);
513 
514         if (burnAmount > 0) {
515             _burn(_originalSender, burnAmount);
516         }
517 
518         return amount.sub(burnAmount);
519     }
520 
521 }