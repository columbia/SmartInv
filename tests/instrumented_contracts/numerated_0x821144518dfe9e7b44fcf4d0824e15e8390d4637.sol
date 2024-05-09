1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-21
3 */
4 
5 pragma solidity ^0.6.0;
6 
7 library SafeMath {
8     /**
9      * @dev Returns the addition of two unsigned integers, reverting on
10      * overflow.
11      *
12      * Counterpart to Solidity's `+` operator.
13      *
14      * Requirements:
15      *
16      * - Addition cannot overflow.
17      */
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Returns the subtraction of two unsigned integers, reverting on
27      * overflow (when the result is negative).
28      *
29      * Counterpart to Solidity's `-` operator.
30      *
31      * Requirements:
32      *
33      * - Subtraction cannot overflow.
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the multiplication of two unsigned integers, reverting on
58      * overflow.
59      *
60      * Counterpart to Solidity's `*` operator.
61      *
62      * Requirements:
63      *
64      * - Multiplication cannot overflow.
65      */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the integer division of two unsigned integers. Reverts on
82      * division by zero. The result is rounded towards zero.
83      *
84      * Counterpart to Solidity's `/` operator. Note: this function uses a
85      * `revert` opcode (which leaves remaining gas untouched) while Solidity
86      * uses an invalid opcode to revert (consuming all remaining gas).
87      *
88      * Requirements:
89      *
90      * - The divisor cannot be zero.
91      */
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         return div(a, b, "SafeMath: division by zero");
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      *
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         require(b > 0, errorMessage);
110         uint256 c = a / b;
111         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
118      * Reverts when dividing by zero.
119      *
120      * Counterpart to Solidity's `%` operator. This function uses a `revert`
121      * opcode (which leaves remaining gas untouched) while Solidity uses an
122      * invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      *
126      * - The divisor cannot be zero.
127      */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         return mod(a, b, "SafeMath: modulo by zero");
130     }
131 
132     /**
133      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
134      * Reverts with custom message when dividing by zero.
135      *
136      * Counterpart to Solidity's `%` operator. This function uses a `revert`
137      * opcode (which leaves remaining gas untouched) while Solidity uses an
138      * invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         require(b != 0, errorMessage);
146         return a % b;
147     }
148 }
149 
150 pragma solidity ^0.6.0;
151 
152 /**
153  * @dev Interface of the ERC20 standard as defined in the EIP.
154  */
155 interface IERC20 {
156     /**
157      * @dev Returns the amount of tokens in existence.
158      */
159     function totalSupply() external view returns (uint256);
160 
161     /**
162      * @dev Returns the amount of tokens owned by `account`.
163      */
164     function balanceOf(address account) external view returns (uint256);
165 
166     /**
167      * @dev Moves `amount` tokens from the caller's account to `recipient`.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transfer(address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Returns the remaining number of tokens that `spender` will be
177      * allowed to spend on behalf of `owner` through {transferFrom}. This is
178      * zero by default.
179      *
180      * This value changes when {approve} or {transferFrom} are called.
181      */
182     function allowance(address owner, address spender) external view returns (uint256);
183 
184     /**
185      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * IMPORTANT: Beware that changing an allowance with this method brings the risk
190      * that someone may use both the old and the new allowance by unfortunate
191      * transaction ordering. One possible solution to mitigate this race
192      * condition is to first reduce the spender's allowance to 0 and set the
193      * desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      *
196      * Emits an {Approval} event.
197      */
198     function approve(address spender, uint256 amount) external returns (bool);
199 
200     /**
201      * @dev Moves `amount` tokens from `sender` to `recipient` using the
202      * allowance mechanism. `amount` is then deducted from the caller's
203      * allowance.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Emitted when `value` tokens are moved from one account (`from`) to
213      * another (`to`).
214      *
215      * Note that `value` may be zero.
216      */
217     event Transfer(address indexed from, address indexed to, uint256 value);
218 
219     /**
220      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
221      * a call to {approve}. `value` is the new allowance.
222      */
223     event Approval(address indexed owner, address indexed spender, uint256 value);
224 }
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
248     constructor (string memory name, string memory symbol) public {
249         _name = name;
250         _symbol = symbol;
251         _decimals = 18;
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
465 
466     /**
467      * @dev Sets {decimals} to a value other than the default one of 18.
468      *
469      * WARNING: This function should only be called from the constructor. Most
470      * applications that interact with token contracts will not expect
471      * {decimals} to ever change, and may work incorrectly if it does.
472      */
473     function _setupDecimals(uint8 decimals_) internal {
474         _decimals = decimals_;
475     }
476 
477 }
478 
479 contract ATIS is ERC20 {
480 
481     constructor () public ERC20("ATIS Token", "ATIS") {
482         _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
483     }
484 
485     function transfer(address to, uint256 amount) public override returns (bool) {
486         return super.transfer(to, _partialBurn(amount));
487     }
488 
489     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
490         return super.transferFrom(from, to, _partialBurnTransferFrom(from, amount));
491     }
492 
493     function _partialBurn(uint256 amount) internal returns (uint256) {
494         uint256 burnAmount = amount.div(100);
495 
496         if (burnAmount > 0) {
497             _burn(msg.sender, burnAmount);
498         }
499 
500         return amount.sub(burnAmount);
501     }
502     
503     function _partialBurnTransferFrom(address _originalSender, uint256 amount) internal returns (uint256) {
504         uint256 burnAmount = amount.div(100);
505 
506         if (burnAmount > 0) {
507             _burn(_originalSender, burnAmount);
508         }
509 
510         return amount.sub(burnAmount);
511     }
512 
513 }