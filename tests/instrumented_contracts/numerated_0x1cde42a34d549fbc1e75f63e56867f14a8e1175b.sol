1 pragma solidity 0.6.2;
2 
3 
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      *
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      *
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts with custom message when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b != 0, errorMessage);
144         return a % b;
145     }
146 }
147 
148 library Math {
149     /**
150      * @dev Returns the largest of two numbers.
151      */
152     function max(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a >= b ? a : b;
154     }
155 
156     /**
157      * @dev Returns the smallest of two numbers.
158      */
159     function min(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a < b ? a : b;
161     }
162 
163     /**
164      * @dev Returns the average of two numbers. The result is rounded towards
165      * zero.
166      */
167     function average(uint256 a, uint256 b) internal pure returns (uint256) {
168         // (a + b) / 2 can overflow, so we distribute
169         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
170     }
171 }
172 
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address payable) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes memory) {
179         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
180         return msg.data;
181     }
182 }
183 
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor () internal {
193         address msgSender = _msgSender();
194         _owner = msgSender;
195         emit OwnershipTransferred(address(0), msgSender);
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(_owner == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         emit OwnershipTransferred(_owner, address(0));
222         _owner = address(0);
223     }
224 
225     /**
226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
227      * Can only be called by the current owner.
228      */
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         emit OwnershipTransferred(_owner, newOwner);
232         _owner = newOwner;
233     }
234 }
235 
236 contract Operator is Context, Ownable {
237     address private _operator;
238 
239     event OperatorTransferred(
240         address indexed previousOperator,
241         address indexed newOperator
242     );
243 
244     constructor() internal {
245         _operator = _msgSender();
246         emit OperatorTransferred(address(0), _operator);
247     }
248 
249     function operator() public view returns (address) {
250         return _operator;
251     }
252 
253     modifier onlyOperator() {
254         require(
255             _operator == msg.sender,
256             'operator: caller is not the operator'
257         );
258         _;
259     }
260 
261     function isOperator() public view returns (bool) {
262         return _msgSender() == _operator;
263     }
264 
265     function transferOperator(address newOperator_) public onlyOwner {
266         _transferOperator(newOperator_);
267     }
268 
269     function _transferOperator(address newOperator_) internal {
270         require(
271             newOperator_ != address(0),
272             'operator: zero address given for new operator'
273         );
274         emit OperatorTransferred(address(0), newOperator_);
275         _operator = newOperator_;
276     }
277 }
278 
279 interface IERC20 {
280     /**
281      * @dev Returns the amount of tokens in existence.
282      */
283     function totalSupply() external view returns (uint256);
284 
285     /**
286      * @dev Returns the amount of tokens owned by `account`.
287      */
288     function balanceOf(address account) external view returns (uint256);
289 
290     /**
291      * @dev Moves `amount` tokens from the caller's account to `recipient`.
292      *
293      * Returns a boolean value indicating whether the operation succeeded.
294      *
295      * Emits a {Transfer} event.
296      */
297     function transfer(address recipient, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Returns the remaining number of tokens that `spender` will be
301      * allowed to spend on behalf of `owner` through {transferFrom}. This is
302      * zero by default.
303      *
304      * This value changes when {approve} or {transferFrom} are called.
305      */
306     function allowance(address owner, address spender) external view returns (uint256);
307 
308     /**
309      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * IMPORTANT: Beware that changing an allowance with this method brings the risk
314      * that someone may use both the old and the new allowance by unfortunate
315      * transaction ordering. One possible solution to mitigate this race
316      * condition is to first reduce the spender's allowance to 0 and set the
317      * desired value afterwards:
318      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
319      *
320      * Emits an {Approval} event.
321      */
322     function approve(address spender, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Moves `amount` tokens from `sender` to `recipient` using the
326      * allowance mechanism. `amount` is then deducted from the caller's
327      * allowance.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
334 
335     /**
336      * @dev Emitted when `value` tokens are moved from one account (`from`) to
337      * another (`to`).
338      *
339      * Note that `value` may be zero.
340      */
341     event Transfer(address indexed from, address indexed to, uint256 value);
342 
343     /**
344      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
345      * a call to {approve}. `value` is the new allowance.
346      */
347     event Approval(address indexed owner, address indexed spender, uint256 value);
348 }
349 
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
372     constructor (string memory name_, string memory symbol_) public {
373         _name = name_;
374         _symbol = symbol_;
375         _decimals = 18;
376     }
377 
378     /**
379      * @dev Returns the name of the token.
380      */
381     function name() public view returns (string memory) {
382         return _name;
383     }
384 
385     /**
386      * @dev Returns the symbol of the token, usually a shorter version of the
387      * name.
388      */
389     function symbol() public view returns (string memory) {
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
406     function decimals() public view returns (uint8) {
407         return _decimals;
408     }
409 
410     /**
411      * @dev See {IERC20-totalSupply}.
412      */
413     function totalSupply() public view override returns (uint256) {
414         return _totalSupply;
415     }
416 
417     /**
418      * @dev See {IERC20-balanceOf}.
419      */
420     function balanceOf(address account) public view override returns (uint256) {
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
604     function _setupDecimals(uint8 decimals_) internal {
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
625 abstract contract ERC20Burnable is Context, ERC20 {
626     using SafeMath for uint256;
627 
628     /**
629      * @dev Destroys `amount` tokens from the caller.
630      *
631      * See {ERC20-_burn}.
632      */
633     function burn(uint256 amount) public virtual {
634         _burn(_msgSender(), amount);
635     }
636 
637     /**
638      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
639      * allowance.
640      *
641      * See {ERC20-_burn} and {ERC20-allowance}.
642      *
643      * Requirements:
644      *
645      * - the caller must have allowance for ``accounts``'s tokens of at least
646      * `amount`.
647      */
648     function burnFrom(address account, uint256 amount) public virtual {
649         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
650 
651         _approve(account, _msgSender(), decreasedAllowance);
652         _burn(account, amount);
653     }
654 }
655 
656 contract Cash is ERC20Burnable, Operator {
657     /**
658      * @notice Constructs the UBC ERC-20 contract.
659      */
660     constructor() public ERC20('UBC', 'UBC') {
661         // Mints 1 UBC to contract creator for initial Uniswap oracle deployment.
662         // Will be burned after oracle deployment
663         _mint(msg.sender, 1 * 10**18);
664     }
665 
666 
667     /**
668      * @notice Operator mints UBC to a recipient
669      * @param recipient_ The address of recipient
670      * @param amount_ The amount of UBC to mint to
671      * @return whether the process has been done
672      */
673     function mint(address recipient_, uint256 amount_)
674         public
675         onlyOperator
676         returns (bool)
677     {
678         uint256 balanceBefore = balanceOf(recipient_);
679         _mint(recipient_, amount_);
680         uint256 balanceAfter = balanceOf(recipient_);
681 
682         return balanceAfter > balanceBefore;
683     }
684 
685     function burn(uint256 amount) public override onlyOperator {
686         super.burn(amount);
687     }
688 
689     function burnFrom(address account, uint256 amount)
690         public
691         override
692         onlyOperator
693     {
694         super.burnFrom(account, amount);
695     }
696 }