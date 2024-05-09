1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.6;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /*
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with GSN meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address payable) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes memory) {
94         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
95         return msg.data;
96     }
97 }
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations with added overflow
101  * checks.
102  *
103  * Arithmetic operations in Solidity wrap on overflow. This can easily result
104  * in bugs, because programmers usually assume that an overflow raises an
105  * error, which is the standard behavior in high level programming languages.
106  * `SafeMath` restores this intuition by reverting the transaction when an
107  * operation overflows.
108  *
109  * Using this library instead of the unchecked operations eliminates an entire
110  * class of bugs, so it's recommended to use it always.
111  */
112 library SafeMath {
113     /**
114      * @dev Returns the addition of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         uint256 c = a + b;
120         if (c < a) return (false, 0);
121         return (true, c);
122     }
123 
124     /**
125      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
126      *
127      * _Available since v3.4._
128      */
129     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         if (b > a) return (false, 0);
131         return (true, a - b);
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) return (true, 0);
144         uint256 c = a * b;
145         if (c / a != b) return (false, 0);
146         return (true, c);
147     }
148 
149     /**
150      * @dev Returns the division of two unsigned integers, with a division by zero flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         if (b == 0) return (false, 0);
156         return (true, a / b);
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
161      *
162      * _Available since v3.4._
163      */
164     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         if (b == 0) return (false, 0);
166         return (true, a % b);
167     }
168 
169     /**
170      * @dev Returns the addition of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `+` operator.
174      *
175      * Requirements:
176      *
177      * - Addition cannot overflow.
178      */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         uint256 c = a + b;
181         require(c >= a, "SafeMath: addition overflow");
182         return c;
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      *
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         require(b <= a, "SafeMath: subtraction overflow");
197         return a - b;
198     }
199 
200     /**
201      * @dev Returns the multiplication of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `*` operator.
205      *
206      * Requirements:
207      *
208      * - Multiplication cannot overflow.
209      */
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         if (a == 0) return 0;
212         uint256 c = a * b;
213         require(c / a == b, "SafeMath: multiplication overflow");
214         return c;
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers, reverting on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b) internal pure returns (uint256) {
230         require(b > 0, "SafeMath: division by zero");
231         return a / b;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * reverting when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         require(b > 0, "SafeMath: modulo by zero");
248         return a % b;
249     }
250 
251     /**
252      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
253      * overflow (when the result is negative).
254      *
255      * CAUTION: This function is deprecated because it requires allocating memory for the error
256      * message unnecessarily. For custom revert reasons use {trySub}.
257      *
258      * Counterpart to Solidity's `-` operator.
259      *
260      * Requirements:
261      *
262      * - Subtraction cannot overflow.
263      */
264     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b <= a, errorMessage);
266         return a - b;
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
271      * division by zero. The result is rounded towards zero.
272      *
273      * CAUTION: This function is deprecated because it requires allocating memory for the error
274      * message unnecessarily. For custom revert reasons use {tryDiv}.
275      *
276      * Counterpart to Solidity's `/` operator. Note: this function uses a
277      * `revert` opcode (which leaves remaining gas untouched) while Solidity
278      * uses an invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      *
282      * - The divisor cannot be zero.
283      */
284     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
285         require(b > 0, errorMessage);
286         return a / b;
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * reverting with custom message when dividing by zero.
292      *
293      * CAUTION: This function is deprecated because it requires allocating memory for the error
294      * message unnecessarily. For custom revert reasons use {tryMod}.
295      *
296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         require(b > 0, errorMessage);
306         return a % b;
307     }
308 }
309 
310 contract Owned {
311     address public owner;
312 
313     event OwnershipTransferred(address indexed _from, address indexed _to);
314 
315     constructor() public {
316         owner = msg.sender;
317     }
318 
319     modifier onlyOwner {
320         require(msg.sender == owner, "Owned: only owner can do it");
321         _;
322     }
323 
324     function transferOwnership(address _owner) public virtual onlyOwner {
325         require(_owner != address(0), "Owned: set zero address to owner");
326         owner = _owner;
327 
328         emit OwnershipTransferred(owner, _owner);
329     }
330 }
331 
332 contract ERC20 is Context, IERC20, Owned{
333     using SafeMath for uint256;
334 
335     mapping (address => uint256) private _balances;
336 
337     mapping (address => mapping (address => uint256)) private _allowances;
338 
339     uint256 private _totalSupply;
340 
341     string private _name;
342     string private _symbol;
343     uint8 private _decimals;
344 
345     /**
346      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
347      * a default value of 18.
348      *
349      * To select a different value for {decimals}, use {_setupDecimals}.
350      *
351      * All three of these values are immutable: they can only be set once during
352      * construction.
353      */
354     constructor (string memory name_, string memory symbol_) public {
355         _name = name_;
356         _symbol = symbol_;
357         _decimals = 18;
358     }
359 
360     // True if transfers are allowed
361     bool public transferable = true;
362 
363     modifier canTransfer() {
364         require(transferable == true);
365         _;
366     }
367 
368     function setTransferable(bool _transferable) public virtual onlyOwner {
369         transferable = _transferable;
370     }
371     /**
372      * @dev Returns the name of the token.
373      */
374     function name() public view virtual returns (string memory) {
375         return _name;
376     }
377 
378     /**
379      * @dev Returns the symbol of the token, usually a shorter version of the
380      * name.
381      */
382     function symbol() public view virtual returns (string memory) {
383         return _symbol;
384     }
385 
386     /**
387      * @dev Returns the number of decimals used to get its user representation.
388      * For example, if `decimals` equals `2`, a balance of `505` tokens should
389      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
390      *
391      * Tokens usually opt for a value of 18, imitating the relationship between
392      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
393      * called.
394      *
395      * NOTE: This information is only used for _display_ purposes: it in
396      * no way affects any of the arithmetic of the contract, including
397      * {IERC20-balanceOf} and {IERC20-transfer}.
398      */
399     function decimals() public view virtual returns (uint8) {
400         return _decimals;
401     }
402 
403     /**
404      * @dev See {IERC20-totalSupply}.
405      */
406     function totalSupply() public view virtual override returns (uint256) {
407         return _totalSupply;
408     }
409 
410     /**
411      * @dev See {IERC20-balanceOf}.
412      */
413     function balanceOf(address account) public view virtual override returns (uint256) {
414         return _balances[account];
415     }
416 
417     /**
418      * @dev See {IERC20-transfer}.
419      *
420      * Requirements:
421      *
422      * - `recipient` cannot be the zero address.
423      * - the caller must have a balance of at least `amount`.
424      */
425     function transfer(address recipient, uint256 amount) public virtual override canTransfer returns (bool) {
426         _transfer(_msgSender(), recipient, amount);
427         return true;
428     }
429 
430     /**
431      * @dev See {IERC20-allowance}.
432      */
433     function allowance(address owner, address spender) public view virtual override returns (uint256) {
434         return _allowances[owner][spender];
435     }
436 
437     /**
438      * @dev See {IERC20-approve}.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function approve(address spender, uint256 amount) public virtual override returns (bool) {
445         _approve(_msgSender(), spender, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-transferFrom}.
451      *
452      * Emits an {Approval} event indicating the updated allowance. This is not
453      * required by the EIP. See the note at the beginning of {ERC20}.
454      *
455      * Requirements:
456      *
457      * - `sender` and `recipient` cannot be the zero address.
458      * - `sender` must have a balance of at least `amount`.
459      * - the caller must have allowance for ``sender``'s tokens of at least
460      * `amount`.
461      */
462     function transferFrom(address sender, address recipient, uint256 amount) public virtual override canTransfer returns (bool) {
463         _transfer(sender, recipient, amount);
464         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
465         return true;
466     }
467 
468     /**
469      * @dev Atomically increases the allowance granted to `spender` by the caller.
470      *
471      * This is an alternative to {approve} that can be used as a mitigation for
472      * problems described in {IERC20-approve}.
473      *
474      * Emits an {Approval} event indicating the updated allowance.
475      *
476      * Requirements:
477      *
478      * - `spender` cannot be the zero address.
479      */
480     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
481         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
482         return true;
483     }
484 
485     /**
486      * @dev Atomically decreases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      * - `spender` must have allowance for the caller of at least
497      * `subtractedValue`.
498      */
499     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
501         return true;
502     }
503 
504     function mint(address account, uint256 amount) public virtual onlyOwner returns(bool){
505         _mint(account, amount);
506         return true;
507     }
508 
509     function burn(address account, uint256 amount) public virtual onlyOwner returns (bool){
510         _burn(account, amount);
511         return true;
512     }
513 
514     /**
515      * @dev Moves tokens `amount` from `sender` to `recipient`.
516      *
517      * This is internal function is equivalent to {transfer}, and can be used to
518      * e.g. implement automatic token fees, slashing mechanisms, etc.
519      *
520      * Emits a {Transfer} event.
521      *
522      * Requirements:
523      *
524      * - `sender` cannot be the zero address.
525      * - `recipient` cannot be the zero address.
526      * - `sender` must have a balance of at least `amount`.
527      */
528     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
529         require(sender != address(0), "ERC20: transfer from the zero address");
530         require(recipient != address(0), "ERC20: transfer to the zero address");
531 
532         _beforeTokenTransfer(sender, recipient, amount);
533 
534         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
535         _balances[recipient] = _balances[recipient].add(amount);
536         emit Transfer(sender, recipient, amount);
537     }
538 
539     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
540      * the total supply.
541      *
542      * Emits a {Transfer} event with `from` set to the zero address.
543      *
544      * Requirements:
545      *
546      * - `to` cannot be the zero address.
547      */
548     function _mint(address account, uint256 amount) internal virtual {
549         require(account != address(0), "ERC20: mint to the zero address");
550 
551         _beforeTokenTransfer(address(0), account, amount);
552 
553         _totalSupply = _totalSupply.add(amount);
554         _balances[account] = _balances[account].add(amount);
555         emit Transfer(address(0), account, amount);
556     }
557 
558     /**
559      * @dev Destroys `amount` tokens from `account`, reducing the
560      * total supply.
561      *
562      * Emits a {Transfer} event with `to` set to the zero address.
563      *
564      * Requirements:
565      *
566      * - `account` cannot be the zero address.
567      * - `account` must have at least `amount` tokens.
568      */
569     function _burn(address account, uint256 amount) internal virtual {
570         require(account != address(0), "ERC20: burn from the zero address");
571 
572         _beforeTokenTransfer(account, address(0), amount);
573 
574         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
575         _totalSupply = _totalSupply.sub(amount);
576         emit Transfer(account, address(0), amount);
577     }
578 
579     /**
580      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
581      *
582      * This internal function is equivalent to `approve`, and can be used to
583      * e.g. set automatic allowances for certain subsystems, etc.
584      *
585      * Emits an {Approval} event.
586      *
587      * Requirements:
588      *
589      * - `owner` cannot be the zero address.
590      * - `spender` cannot be the zero address.
591      */
592     function _approve(address owner, address spender, uint256 amount) internal virtual {
593         require(owner != address(0), "ERC20: approve from the zero address");
594         require(spender != address(0), "ERC20: approve to the zero address");
595 
596         _allowances[owner][spender] = amount;
597         emit Approval(owner, spender, amount);
598     }
599 
600     /**
601      * @dev Sets {decimals} to a value other than the default one of 18.
602      *
603      * WARNING: This function should only be called from the constructor. Most
604      * applications that interact with token contracts will not expect
605      * {decimals} to ever change, and may work incorrectly if it does.
606      */
607     function _setupDecimals(uint8 decimals_) internal virtual {
608         _decimals = decimals_;
609     }
610 
611     /**
612      * @dev Hook that is called before any transfer of tokens. This includes
613      * minting and burning.
614      *
615      * Calling conditions:
616      *
617      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
618      * will be to transferred to `to`.
619      * - when `from` is zero, `amount` tokens will be minted for `to`.
620      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
621      * - `from` and `to` are never both zero.
622      *
623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
624      */
625     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
626 }
627 
628 contract EvaToken is ERC20 {
629 
630     constructor() ERC20("Evanesco Network", "EVA") public {
631         _mint(msg.sender, 0 * (10 ** uint256(decimals())));
632     }
633 }