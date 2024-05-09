1 /*
2 * GENESIS L1
3 * IS A SIMPLE ERC-20 TOKEN. IT IS ALL GIFTED TO THE COMMUNITY OF DIGITAL ARTISTS, BLOCKCHAIN DEVELOPERS AND USERS. 
4 * 
5 * DISCLAIMER 
6 * IT COMES "AS IS", WITH NO WARRANTY. GENESIS L1 TOKEN IS AN EXPERIMENTAL UTILITY TOKEN WITH NO DEFAULT VALUE OF ANY KIND. 
7 * EXPERIMENT ESSENCE IS AN ESTABLISHMENT OF DECENTRALIZED TRUSTLESS LAYER 1 BLOCKCHAIN BASED ON OPEN SOURCE PROGRAM CODES.
8 * EXPERIMENTAL UTILITY FUNCTION OF THE GENESIS L1 TOKEN IS A TRANSITION TO A NEW LAYER 1 BLOCKCHAIN VIA CROSSBLOCKCHAIN 
9 * BRIDGE OR TOKEN GENERATION TO CORRESPONDING PRIVATE/PUBLIC KEY PAIR IN THE NEW LAYER 1 BLOCKCHAIN.
10 * GENESIS TOKEN IS RANDOMLY ALLOCATED IN A FORM OF A GIFT WITHOUT INTRISTIC VALUE TO SOME ADDRESSES IN ETHEREUM BLOCKCHAIN, 
11 * RELATED TO TWO COMMUNITY TYPES: AVERAGE BLOCKCHAIN USERS AND AVERAGE BLOCKCHAIN DEVELOPERS.
12 * THE SPEED OF LIGHT = 299792458 m/s
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.7.0;
18 
19 /*
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with GSN meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         uint256 c = a + b;
136         if (c < a) return (false, 0);
137         return (true, c);
138     }
139 
140     /**
141      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
142      *
143      * _Available since v3.4._
144      */
145     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         if (b > a) return (false, 0);
147         return (true, a - b);
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) return (true, 0);
160         uint256 c = a * b;
161         if (c / a != b) return (false, 0);
162         return (true, c);
163     }
164 
165     /**
166      * @dev Returns the division of two unsigned integers, with a division by zero flag.
167      *
168      * _Available since v3.4._
169      */
170     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
171         if (b == 0) return (false, 0);
172         return (true, a / b);
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
177      *
178      * _Available since v3.4._
179      */
180     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
181         if (b == 0) return (false, 0);
182         return (true, a % b);
183     }
184 
185     /**
186      * @dev Returns the addition of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `+` operator.
190      *
191      * Requirements:
192      *
193      * - Addition cannot overflow.
194      */
195     function add(uint256 a, uint256 b) internal pure returns (uint256) {
196         uint256 c = a + b;
197         require(c >= a, "SafeMath: addition overflow");
198         return c;
199     }
200 
201     /**
202      * @dev Returns the subtraction of two unsigned integers, reverting on
203      * overflow (when the result is negative).
204      *
205      * Counterpart to Solidity's `-` operator.
206      *
207      * Requirements:
208      *
209      * - Subtraction cannot overflow.
210      */
211     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
212         require(b <= a, "SafeMath: subtraction overflow");
213         return a - b;
214     }
215 
216     /**
217      * @dev Returns the multiplication of two unsigned integers, reverting on
218      * overflow.
219      *
220      * Counterpart to Solidity's `*` operator.
221      *
222      * Requirements:
223      *
224      * - Multiplication cannot overflow.
225      */
226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227         if (a == 0) return 0;
228         uint256 c = a * b;
229         require(c / a == b, "SafeMath: multiplication overflow");
230         return c;
231     }
232 
233     /**
234      * @dev Returns the integer division of two unsigned integers, reverting on
235      * division by zero. The result is rounded towards zero.
236      *
237      * Counterpart to Solidity's `/` operator. Note: this function uses a
238      * `revert` opcode (which leaves remaining gas untouched) while Solidity
239      * uses an invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(uint256 a, uint256 b) internal pure returns (uint256) {
246         require(b > 0, "SafeMath: division by zero");
247         return a / b;
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * reverting when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         require(b > 0, "SafeMath: modulo by zero");
264         return a % b;
265     }
266 
267     /**
268      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
269      * overflow (when the result is negative).
270      *
271      * CAUTION: This function is deprecated because it requires allocating memory for the error
272      * message unnecessarily. For custom revert reasons use {trySub}.
273      *
274      * Counterpart to Solidity's `-` operator.
275      *
276      * Requirements:
277      *
278      * - Subtraction cannot overflow.
279      */
280     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b <= a, errorMessage);
282         return a - b;
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
287      * division by zero. The result is rounded towards zero.
288      *
289      * CAUTION: This function is deprecated because it requires allocating memory for the error
290      * message unnecessarily. For custom revert reasons use {tryDiv}.
291      *
292      * Counterpart to Solidity's `/` operator. Note: this function uses a
293      * `revert` opcode (which leaves remaining gas untouched) while Solidity
294      * uses an invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b > 0, errorMessage);
302         return a / b;
303     }
304 
305     /**
306      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
307      * reverting with custom message when dividing by zero.
308      *
309      * CAUTION: This function is deprecated because it requires allocating memory for the error
310      * message unnecessarily. For custom revert reasons use {tryMod}.
311      *
312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
313      * opcode (which leaves remaining gas untouched) while Solidity uses an
314      * invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
321         require(b > 0, errorMessage);
322         return a % b;
323     }
324 }
325 
326 /**
327  * @dev Implementation of the {IERC20} interface.
328  *
329  * This implementation is agnostic to the way tokens are created. This means
330  * that a supply mechanism has to be added in a derived contract using {_mint}.
331  * For a generic mechanism see {ERC20PresetMinterPauser}.
332  *
333  * TIP: For a detailed writeup see our guide
334  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
335  * to implement supply mechanisms].
336  *
337  * We have followed general OpenZeppelin guidelines: functions revert instead
338  * of returning `false` on failure. This behavior is nonetheless conventional
339  * and does not conflict with the expectations of ERC20 applications.
340  *
341  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
342  * This allows applications to reconstruct the allowance for all accounts just
343  * by listening to said events. Other implementations of the EIP may not emit
344  * these events, as it isn't required by the specification.
345  *
346  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
347  * functions have been added to mitigate the well-known issues around setting
348  * allowances. See {IERC20-approve}.
349  */
350 contract ERC20 is Context, IERC20 {
351     using SafeMath for uint256;
352 
353     mapping (address => uint256) private _balances;
354 
355     mapping (address => mapping (address => uint256)) private _allowances;
356 
357     uint256 private _totalSupply;
358 
359     string private _name;
360     string private _symbol;
361     uint8 private _decimals;
362 
363     /**
364      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
365      * a default value of 18.
366      *
367      * To select a different value for {decimals}, use {_setupDecimals}.
368      *
369      * All three of these values are immutable: they can only be set once during
370      * construction.
371      */
372     constructor (string memory name_, string memory symbol_) {
373         _name = name_;
374         _symbol = symbol_;
375         _decimals = 18;
376     }
377 
378     /**
379      * @dev Returns the name of the token.
380      */
381     function name() public view virtual returns (string memory) {
382         return _name;
383     }
384 
385     /**
386      * @dev Returns the symbol of the token, usually a shorter version of the
387      * name.
388      */
389     function symbol() public view virtual returns (string memory) {
390         return _symbol;
391     }
392 
393     /**
394      * @dev Returns the number of decimals used to get its user representation.
395      * For example, if `decimals` equals `2`, a balance of `505` tokens should
396      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
397      *
398      * Tokens usually opt for a value of 18, imitating the relationship between
399      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
400      * called.
401      *
402      * NOTE: This information is only used for _display_ purposes: it in
403      * no way affects any of the arithmetic of the contract, including
404      * {IERC20-balanceOf} and {IERC20-transfer}.
405      */
406     function decimals() public view virtual returns (uint8) {
407         return _decimals;
408     }
409 
410     /**
411      * @dev See {IERC20-totalSupply}.
412      */
413     function totalSupply() public view virtual override returns (uint256) {
414         return _totalSupply;
415     }
416 
417     /**
418      * @dev See {IERC20-balanceOf}.
419      */
420     function balanceOf(address account) public view virtual override returns (uint256) {
421         return _balances[account];
422     }
423 
424     /**
425      * @dev See {IERC20-transfer}.
426      *
427      * Requirements:
428      *
429      * - `recipient` cannot be the zero address.
430      * - the caller must have a balance of at least `amount`.
431      */
432     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
433         _transfer(_msgSender(), recipient, amount);
434         return true;
435     }
436 
437     /**
438      * @dev See {IERC20-allowance}.
439      */
440     function allowance(address owner, address spender) public view virtual override returns (uint256) {
441         return _allowances[owner][spender];
442     }
443 
444     /**
445      * @dev See {IERC20-approve}.
446      *
447      * Requirements:
448      *
449      * - `spender` cannot be the zero address.
450      */
451     function approve(address spender, uint256 amount) public virtual override returns (bool) {
452         _approve(_msgSender(), spender, amount);
453         return true;
454     }
455 
456     /**
457      * @dev See {IERC20-transferFrom}.
458      *
459      * Emits an {Approval} event indicating the updated allowance. This is not
460      * required by the EIP. See the note at the beginning of {ERC20}.
461      *
462      * Requirements:
463      *
464      * - `sender` and `recipient` cannot be the zero address.
465      * - `sender` must have a balance of at least `amount`.
466      * - the caller must have allowance for ``sender``'s tokens of at least
467      * `amount`.
468      */
469     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
470         _transfer(sender, recipient, amount);
471         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
472         return true;
473     }
474 
475     /**
476      * @dev Atomically increases the allowance granted to `spender` by the caller.
477      *
478      * This is an alternative to {approve} that can be used as a mitigation for
479      * problems described in {IERC20-approve}.
480      *
481      * Emits an {Approval} event indicating the updated allowance.
482      *
483      * Requirements:
484      *
485      * - `spender` cannot be the zero address.
486      */
487     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
488         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
489         return true;
490     }
491 
492     /**
493      * @dev Atomically decreases the allowance granted to `spender` by the caller.
494      *
495      * This is an alternative to {approve} that can be used as a mitigation for
496      * problems described in {IERC20-approve}.
497      *
498      * Emits an {Approval} event indicating the updated allowance.
499      *
500      * Requirements:
501      *
502      * - `spender` cannot be the zero address.
503      * - `spender` must have allowance for the caller of at least
504      * `subtractedValue`.
505      */
506     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
508         return true;
509     }
510 
511     /**
512      * @dev Moves tokens `amount` from `sender` to `recipient`.
513      *
514      * This is internal function is equivalent to {transfer}, and can be used to
515      * e.g. implement automatic token fees, slashing mechanisms, etc.
516      *
517      * Emits a {Transfer} event.
518      *
519      * Requirements:
520      *
521      * - `sender` cannot be the zero address.
522      * - `recipient` cannot be the zero address.
523      * - `sender` must have a balance of at least `amount`.
524      */
525     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
526         require(sender != address(0), "ERC20: transfer from the zero address");
527         require(recipient != address(0), "ERC20: transfer to the zero address");
528 
529         _beforeTokenTransfer(sender, recipient, amount);
530 
531         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
532         _balances[recipient] = _balances[recipient].add(amount);
533         emit Transfer(sender, recipient, amount);
534     }
535 
536     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
537      * the total supply.
538      *
539      * Emits a {Transfer} event with `from` set to the zero address.
540      *
541      * Requirements:
542      *
543      * - `to` cannot be the zero address.
544      */
545     function _mint(address account, uint256 amount) internal virtual {
546         require(account != address(0), "ERC20: mint to the zero address");
547 
548         _beforeTokenTransfer(address(0), account, amount);
549 
550         _totalSupply = _totalSupply.add(amount);
551         _balances[account] = _balances[account].add(amount);
552         emit Transfer(address(0), account, amount);
553     }
554 
555     /**
556      * @dev Destroys `amount` tokens from `account`, reducing the
557      * total supply.
558      *
559      * Emits a {Transfer} event with `to` set to the zero address.
560      *
561      * Requirements:
562      *
563      * - `account` cannot be the zero address.
564      * - `account` must have at least `amount` tokens.
565      */
566     function _burn(address account, uint256 amount) internal virtual {
567         require(account != address(0), "ERC20: burn from the zero address");
568 
569         _beforeTokenTransfer(account, address(0), amount);
570 
571         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
572         _totalSupply = _totalSupply.sub(amount);
573         emit Transfer(account, address(0), amount);
574     }
575 
576     /**
577      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
578      *
579      * This internal function is equivalent to `approve`, and can be used to
580      * e.g. set automatic allowances for certain subsystems, etc.
581      *
582      * Emits an {Approval} event.
583      *
584      * Requirements:
585      *
586      * - `owner` cannot be the zero address.
587      * - `spender` cannot be the zero address.
588      */
589     function _approve(address owner, address spender, uint256 amount) internal virtual {
590         require(owner != address(0), "ERC20: approve from the zero address");
591         require(spender != address(0), "ERC20: approve to the zero address");
592 
593         _allowances[owner][spender] = amount;
594         emit Approval(owner, spender, amount);
595     }
596 
597     /**
598      * @dev Sets {decimals} to a value other than the default one of 18.
599      *
600      * WARNING: This function should only be called from the constructor. Most
601      * applications that interact with token contracts will not expect
602      * {decimals} to ever change, and may work incorrectly if it does.
603      */
604     function _setupDecimals(uint8 decimals_) internal virtual {
605         _decimals = decimals_;
606     }
607 
608     /**
609      * @dev Hook that is called before any transfer of tokens. This includes
610      * minting and burning.
611      *
612      * Calling conditions:
613      *
614      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
615      * will be to transferred to `to`.
616      * - when `from` is zero, `amount` tokens will be minted for `to`.
617      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
618      * - `from` and `to` are never both zero.
619      *
620      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
621      */
622     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
623 }
624 
625 contract GENESISToken is ERC20 {
626 
627     constructor () ERC20("GENESIS", "L1") {
628         _mint(msg.sender, 21000000 * (10 ** uint256(decimals())));
629     }
630 }