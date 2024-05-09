1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address payable) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
19 
20 
21 pragma solidity >=0.6.0 <0.8.0;
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP.
25  */
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
98 
99 
100 pragma solidity >=0.6.0 <0.8.0;
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
259 
260 
261 pragma solidity >=0.6.0 <0.8.0;
262 
263 
264 
265 
266 /**
267  * @dev Implementation of the {IERC20} interface.
268  *
269  * This implementation is agnostic to the way tokens are created. This means
270  * that a supply mechanism has to be added in a derived contract using {_mint}.
271  * For a generic mechanism see {ERC20PresetMinterPauser}.
272  *
273  * TIP: For a detailed writeup see our guide
274  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
275  * to implement supply mechanisms].
276  *
277  * We have followed general OpenZeppelin guidelines: functions revert instead
278  * of returning `false` on failure. This behavior is nonetheless conventional
279  * and does not conflict with the expectations of ERC20 applications.
280  *
281  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
282  * This allows applications to reconstruct the allowance for all accounts just
283  * by listening to said events. Other implementations of the EIP may not emit
284  * these events, as it isn't required by the specification.
285  *
286  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
287  * functions have been added to mitigate the well-known issues around setting
288  * allowances. See {IERC20-approve}.
289  */
290 contract ERC20 is Context, IERC20 {
291     using SafeMath for uint256;
292 
293     mapping (address => uint256) private _balances;
294 
295     mapping (address => mapping (address => uint256)) private _allowances;
296 
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
307      * To select a different value for {decimals}, use {_setupDecimals}.
308      *
309      * All three of these values are immutable: they can only be set once during
310      * construction.
311      */
312     constructor (string memory name_, string memory symbol_) public {
313         _name = name_;
314         _symbol = symbol_;
315         _decimals = 18;
316     }
317 
318     /**
319      * @dev Returns the name of the token.
320      */
321     function name() public view returns (string memory) {
322         return _name;
323     }
324 
325     /**
326      * @dev Returns the symbol of the token, usually a shorter version of the
327      * name.
328      */
329     function symbol() public view returns (string memory) {
330         return _symbol;
331     }
332 
333     /**
334      * @dev Returns the number of decimals used to get its user representation.
335      * For example, if `decimals` equals `2`, a balance of `505` tokens should
336      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
337      *
338      * Tokens usually opt for a value of 18, imitating the relationship between
339      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
340      * called.
341      *
342      * NOTE: This information is only used for _display_ purposes: it in
343      * no way affects any of the arithmetic of the contract, including
344      * {IERC20-balanceOf} and {IERC20-transfer}.
345      */
346     function decimals() public view returns (uint8) {
347         return _decimals;
348     }
349 
350     /**
351      * @dev See {IERC20-totalSupply}.
352      */
353     function totalSupply() public view override returns (uint256) {
354         return _totalSupply;
355     }
356 
357     /**
358      * @dev See {IERC20-balanceOf}.
359      */
360     function balanceOf(address account) public view override returns (uint256) {
361         return _balances[account];
362     }
363 
364     /**
365      * @dev See {IERC20-transfer}.
366      *
367      * Requirements:
368      *
369      * - `recipient` cannot be the zero address.
370      * - the caller must have a balance of at least `amount`.
371      */
372     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
373         _transfer(_msgSender(), recipient, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-allowance}.
379      */
380     function allowance(address owner, address spender) public view virtual override returns (uint256) {
381         return _allowances[owner][spender];
382     }
383 
384     /**
385      * @dev See {IERC20-approve}.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function approve(address spender, uint256 amount) public virtual override returns (bool) {
392         _approve(_msgSender(), spender, amount);
393         return true;
394     }
395 
396     /**
397      * @dev See {IERC20-transferFrom}.
398      *
399      * Emits an {Approval} event indicating the updated allowance. This is not
400      * required by the EIP. See the note at the beginning of {ERC20}.
401      *
402      * Requirements:
403      *
404      * - `sender` and `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      * - the caller must have allowance for ``sender``'s tokens of at least
407      * `amount`.
408      */
409     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
410         _transfer(sender, recipient, amount);
411         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
412         return true;
413     }
414 
415     /**
416      * @dev Atomically increases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      */
427     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
428         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
429         return true;
430     }
431 
432     /**
433      * @dev Atomically decreases the allowance granted to `spender` by the caller.
434      *
435      * This is an alternative to {approve} that can be used as a mitigation for
436      * problems described in {IERC20-approve}.
437      *
438      * Emits an {Approval} event indicating the updated allowance.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      * - `spender` must have allowance for the caller of at least
444      * `subtractedValue`.
445      */
446     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
447         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
448         return true;
449     }
450 
451     /**
452      * @dev Moves tokens `amount` from `sender` to `recipient`.
453      *
454      * This is internal function is equivalent to {transfer}, and can be used to
455      * e.g. implement automatic token fees, slashing mechanisms, etc.
456      *
457      * Emits a {Transfer} event.
458      *
459      * Requirements:
460      *
461      * - `sender` cannot be the zero address.
462      * - `recipient` cannot be the zero address.
463      * - `sender` must have a balance of at least `amount`.
464      */
465     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
466         require(sender != address(0), "ERC20: transfer from the zero address");
467         require(recipient != address(0), "ERC20: transfer to the zero address");
468 
469         _beforeTokenTransfer(sender, recipient, amount);
470 
471         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
472         _balances[recipient] = _balances[recipient].add(amount);
473         emit Transfer(sender, recipient, amount);
474     }
475 
476     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
477      * the total supply.
478      *
479      * Emits a {Transfer} event with `from` set to the zero address.
480      *
481      * Requirements:
482      *
483      * - `to` cannot be the zero address.
484      */
485     function _mint(address account, uint256 amount) internal virtual {
486         require(account != address(0), "ERC20: mint to the zero address");
487 
488         _beforeTokenTransfer(address(0), account, amount);
489 
490         _totalSupply = _totalSupply.add(amount);
491         _balances[account] = _balances[account].add(amount);
492         emit Transfer(address(0), account, amount);
493     }
494 
495     /**
496      * @dev Destroys `amount` tokens from `account`, reducing the
497      * total supply.
498      *
499      * Emits a {Transfer} event with `to` set to the zero address.
500      *
501      * Requirements:
502      *
503      * - `account` cannot be the zero address.
504      * - `account` must have at least `amount` tokens.
505      */
506     function _burn(address account, uint256 amount) internal virtual {
507         require(account != address(0), "ERC20: burn from the zero address");
508 
509         _beforeTokenTransfer(account, address(0), amount);
510 
511         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
512         _totalSupply = _totalSupply.sub(amount);
513         emit Transfer(account, address(0), amount);
514     }
515 
516     /**
517      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
518      *
519      * This internal function is equivalent to `approve`, and can be used to
520      * e.g. set automatic allowances for certain subsystems, etc.
521      *
522      * Emits an {Approval} event.
523      *
524      * Requirements:
525      *
526      * - `owner` cannot be the zero address.
527      * - `spender` cannot be the zero address.
528      */
529     function _approve(address owner, address spender, uint256 amount) internal virtual {
530         require(owner != address(0), "ERC20: approve from the zero address");
531         require(spender != address(0), "ERC20: approve to the zero address");
532 
533         _allowances[owner][spender] = amount;
534         emit Approval(owner, spender, amount);
535     }
536 
537     /**
538      * @dev Sets {decimals} to a value other than the default one of 18.
539      *
540      * WARNING: This function should only be called from the constructor. Most
541      * applications that interact with token contracts will not expect
542      * {decimals} to ever change, and may work incorrectly if it does.
543      */
544     function _setupDecimals(uint8 decimals_) internal {
545         _decimals = decimals_;
546     }
547 
548     /**
549      * @dev Hook that is called before any transfer of tokens. This includes
550      * minting and burning.
551      *
552      * Calling conditions:
553      *
554      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
555      * will be to transferred to `to`.
556      * - when `from` is zero, `amount` tokens will be minted for `to`.
557      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
558      * - `from` and `to` are never both zero.
559      *
560      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
561      */
562     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
563 }
564 
565 // File: contracts/ColaToken.sol
566 
567 pragma solidity 0.7.0;
568 
569 
570 
571 contract ColaToken is ERC20 {
572 	constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) public {
573 		_mint(msg.sender, 300000000 * (10 **18));
574 	}
575 }