1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
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
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
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
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, with an overflow flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         uint256 c = a + b;
104         if (c < a) return (false, 0);
105         return (true, c);
106     }
107 
108     /**
109      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         if (b > a) return (false, 0);
115         return (true, a - b);
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125         // benefit is lost if 'b' is also tested.
126         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
127         if (a == 0) return (true, 0);
128         uint256 c = a * b;
129         if (c / a != b) return (false, 0);
130         return (true, c);
131     }
132 
133     /**
134      * @dev Returns the division of two unsigned integers, with a division by zero flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         if (b == 0) return (false, 0);
140         return (true, a / b);
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         if (b == 0) return (false, 0);
150         return (true, a % b);
151     }
152 
153     /**
154      * @dev Returns the addition of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `+` operator.
158      *
159      * Requirements:
160      *
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166         return c;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b <= a, "SafeMath: subtraction overflow");
181         return a - b;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         if (a == 0) return 0;
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers, reverting on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         require(b > 0, "SafeMath: division by zero");
215         return a / b;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b > 0, "SafeMath: modulo by zero");
232         return a % b;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {trySub}.
241      *
242      * Counterpart to Solidity's `-` operator.
243      *
244      * Requirements:
245      *
246      * - Subtraction cannot overflow.
247      */
248     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b <= a, errorMessage);
250         return a - b;
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
255      * division by zero. The result is rounded towards zero.
256      *
257      * CAUTION: This function is deprecated because it requires allocating memory for the error
258      * message unnecessarily. For custom revert reasons use {tryDiv}.
259      *
260      * Counterpart to Solidity's `/` operator. Note: this function uses a
261      * `revert` opcode (which leaves remaining gas untouched) while Solidity
262      * uses an invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b > 0, errorMessage);
270         return a / b;
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * reverting with custom message when dividing by zero.
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {tryMod}.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         require(b > 0, errorMessage);
290         return a % b;
291     }
292 }
293 
294 contract ERC20 is Context, IERC20 {
295     using SafeMath for uint256;
296 
297     mapping (address => uint256) private _balances;
298 
299     mapping (address => mapping (address => uint256)) private _allowances;
300 
301     uint256 private _totalSupply;
302 
303     string private _name;
304     string private _symbol;
305     uint8 private _decimals;
306 
307     /**
308      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
309      * a default value of 18.
310      *
311      * To select a different value for {decimals}, use {_setupDecimals}.
312      *
313      * All three of these values are immutable: they can only be set once during
314      * construction.
315      */
316     constructor (string memory name_, string memory symbol_) {
317         _name = name_;
318         _symbol = symbol_;
319         _decimals = 18;
320     }
321 
322     /**
323      * @dev Returns the name of the token.
324      */
325     function name() public view virtual returns (string memory) {
326         return _name;
327     }
328 
329     /**
330      * @dev Returns the symbol of the token, usually a shorter version of the
331      * name.
332      */
333     function symbol() public view virtual returns (string memory) {
334         return _symbol;
335     }
336 
337     /**
338      * @dev Returns the number of decimals used to get its user representation.
339      * For example, if `decimals` equals `2`, a balance of `505` tokens should
340      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
341      *
342      * Tokens usually opt for a value of 18, imitating the relationship between
343      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
344      * called.
345      *
346      * NOTE: This information is only used for _display_ purposes: it in
347      * no way affects any of the arithmetic of the contract, including
348      * {IERC20-balanceOf} and {IERC20-transfer}.
349      */
350     function decimals() public view virtual returns (uint8) {
351         return _decimals;
352     }
353 
354     /**
355      * @dev See {IERC20-totalSupply}.
356      */
357     function totalSupply() public view virtual override returns (uint256) {
358         return _totalSupply;
359     }
360 
361     /**
362      * @dev See {IERC20-balanceOf}.
363      */
364     function balanceOf(address account) public view virtual override returns (uint256) {
365         return _balances[account];
366     }
367 
368     /**
369      * @dev See {IERC20-transfer}.
370      *
371      * Requirements:
372      *
373      * - `recipient` cannot be the zero address.
374      * - the caller must have a balance of at least `amount`.
375      */
376     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
377         _transfer(_msgSender(), recipient, amount);
378         return true;
379     }
380 
381     /**
382      * @dev See {IERC20-allowance}.
383      */
384     function allowance(address owner, address spender) public view virtual override returns (uint256) {
385         return _allowances[owner][spender];
386     }
387 
388     /**
389      * @dev See {IERC20-approve}.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function approve(address spender, uint256 amount) public virtual override returns (bool) {
396         _approve(_msgSender(), spender, amount);
397         return true;
398     }
399 
400     /**
401      * @dev See {IERC20-transferFrom}.
402      *
403      * Emits an {Approval} event indicating the updated allowance. This is not
404      * required by the EIP. See the note at the beginning of {ERC20}.
405      *
406      * Requirements:
407      *
408      * - `sender` and `recipient` cannot be the zero address.
409      * - `sender` must have a balance of at least `amount`.
410      * - the caller must have allowance for ``sender``'s tokens of at least
411      * `amount`.
412      */
413     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
414         _transfer(sender, recipient, amount);
415         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
416         return true;
417     }
418 
419     /**
420      * @dev Atomically increases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
432         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
433         return true;
434     }
435 
436     /**
437      * @dev Atomically decreases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to {approve} that can be used as a mitigation for
440      * problems described in {IERC20-approve}.
441      *
442      * Emits an {Approval} event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      * - `spender` must have allowance for the caller of at least
448      * `subtractedValue`.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
451         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
452         return true;
453     }
454 
455     /**
456      * @dev Moves tokens `amount` from `sender` to `recipient`.
457      *
458      * This is internal function is equivalent to {transfer}, and can be used to
459      * e.g. implement automatic token fees, slashing mechanisms, etc.
460      *
461      * Emits a {Transfer} event.
462      *
463      * Requirements:
464      *
465      * - `sender` cannot be the zero address.
466      * - `recipient` cannot be the zero address.
467      * - `sender` must have a balance of at least `amount`.
468      */
469     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
470         require(sender != address(0), "ERC20: transfer from the zero address");
471         require(recipient != address(0), "ERC20: transfer to the zero address");
472 
473         _beforeTokenTransfer(sender, recipient, amount);
474 
475         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
476         _balances[recipient] = _balances[recipient].add(amount);
477         emit Transfer(sender, recipient, amount);
478     }
479 
480     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
481      * the total supply.
482      *
483      * Emits a {Transfer} event with `from` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `to` cannot be the zero address.
488      */
489     function _mint(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: mint to the zero address");
491 
492         _beforeTokenTransfer(address(0), account, amount);
493 
494         _totalSupply = _totalSupply.add(amount);
495         _balances[account] = _balances[account].add(amount);
496         emit Transfer(address(0), account, amount);
497     }
498 
499     /**
500      * @dev Destroys `amount` tokens from `account`, reducing the
501      * total supply.
502      *
503      * Emits a {Transfer} event with `to` set to the zero address.
504      *
505      * Requirements:
506      *
507      * - `account` cannot be the zero address.
508      * - `account` must have at least `amount` tokens.
509      */
510     function _burn(address account, uint256 amount) internal virtual {
511         require(account != address(0), "ERC20: burn from the zero address");
512 
513         _beforeTokenTransfer(account, address(0), amount);
514 
515         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
516         _totalSupply = _totalSupply.sub(amount);
517         emit Transfer(account, address(0), amount);
518     }
519 
520     /**
521      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
522      *
523      * This internal function is equivalent to `approve`, and can be used to
524      * e.g. set automatic allowances for certain subsystems, etc.
525      *
526      * Emits an {Approval} event.
527      *
528      * Requirements:
529      *
530      * - `owner` cannot be the zero address.
531      * - `spender` cannot be the zero address.
532      */
533     function _approve(address owner, address spender, uint256 amount) internal virtual {
534         require(owner != address(0), "ERC20: approve from the zero address");
535         require(spender != address(0), "ERC20: approve to the zero address");
536 
537         _allowances[owner][spender] = amount;
538         emit Approval(owner, spender, amount);
539     }
540 
541     /**
542      * @dev Sets {decimals} to a value other than the default one of 18.
543      *
544      * WARNING: This function should only be called from the constructor. Most
545      * applications that interact with token contracts will not expect
546      * {decimals} to ever change, and may work incorrectly if it does.
547      */
548     function _setupDecimals(uint8 decimals_) internal virtual {
549         _decimals = decimals_;
550     }
551 
552     /**
553      * @dev Hook that is called before any transfer of tokens. This includes
554      * minting and burning.
555      *
556      * Calling conditions:
557      *
558      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
559      * will be to transferred to `to`.
560      * - when `from` is zero, `amount` tokens will be minted for `to`.
561      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
562      * - `from` and `to` are never both zero.
563      *
564      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
565      */
566     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
567 }
568 
569 contract Token is ERC20 {
570 
571     constructor () ERC20("maxmaximize", "Mmax") {
572         _mint(msg.sender, 2000000000000000 * (10 ** uint256(decimals())));
573     }
574 }