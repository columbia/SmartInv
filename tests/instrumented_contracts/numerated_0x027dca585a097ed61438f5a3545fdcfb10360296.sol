1 /**
2 Website: https://www.Moose.Finance
3 Telegram: https://t.me/MooseFinance
4 Twitter: https://twitter.com/MooseFinanceERC
5 
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠂⢰⡇⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⣤⣀⣄⡀⠀⠀⣿⠀⣾⣡⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⢠⡆⣿⣄⣰⣿⣿⡿⠟⢰⣇⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠸⣷⣿⣿⣿⡉⢁⣀⣀⣼⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⣈⣉⣹⣿⣿⣿⣿⣿⣄⣀⣠⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀
12 ⠘⠻⠟⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀
13 ⠀⠀⠀⠀⠈⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⡟⢿⣿⣿⢿⣿⠿⠛⣿⣿⠀⠙⢿⣿⡄⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠈⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠈⢻⣿⡆
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠃⠀⢸⣧⠀⠀⠀⠀⢹⣿⠃⠀⠀⠀⢻⣧
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⠀⠀⠘⣿⠀⠀⠀⠀⣸⡏⠀⠀⠀⠀⠀⣿
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠸⡆⠀⠀⠀⡿⠀⠀⠀⠀⠀⠀⣿
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡇⠀⠀⠀⠀⣿⠀⠀⣼⠃⠀⠀⠀⠀⠀⠀⣿
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠟⠀⠀⠀⠀⠰⠏⠀⠾⠁⠀⠀⠀⠀⠀⠀⠘⠛
23 
24 
25 */
26 
27 
28 
29 // SPDX-License-Identifier: MIT                                                                               
30                                                     
31 pragma solidity = 0.8.19;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 interface IUniswapV2Pair {
45     event Sync(uint112 reserve0, uint112 reserve1);
46     function sync() external;
47 }
48 
49 interface IUniswapV2Factory {
50     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
51 
52     function createPair(address tokenA, address tokenB) external returns (address pair);
53 }
54 
55 interface IERC20 {
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `recipient`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `sender` to `recipient` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address sender,
111         address recipient,
112         uint256 amount
113     ) external returns (bool);
114 
115     /**
116      * @dev Emitted when `value` tokens are moved from one account (`from`) to
117      * another (`to`).
118      *
119      * Note that `value` may be zero.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123     /**
124      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
125      * a call to {approve}. `value` is the new allowance.
126      */
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 interface IERC20Metadata is IERC20 {
131     /**
132      * @dev Returns the name of the token.
133      */
134     function name() external view returns (string memory);
135 
136     /**
137      * @dev Returns the symbol of the token.
138      */
139     function symbol() external view returns (string memory);
140 
141     /**
142      * @dev Returns the decimals places of the token.
143      */
144     function decimals() external view returns (uint8);
145 }
146 
147 
148 contract ERC20 is Context, IERC20, IERC20Metadata {
149     using SafeMath for uint256;
150 
151     mapping(address => uint256) private _balances;
152 
153     mapping(address => mapping(address => uint256)) private _allowances;
154 
155     uint256 private _totalSupply;
156 
157     string private _name;
158     string private _symbol;
159 
160     /**
161      * @dev Sets the values for {name} and {symbol}.
162      *
163      * The default value of {decimals} is 18. To select a different value for
164      * {decimals} you should overload it.
165      *
166      * All two of these values are immutable: they can only be set once during
167      * construction.
168      */
169     constructor(string memory name_, string memory symbol_) {
170         _name = name_;
171         _symbol = symbol_;
172     }
173 
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() public view virtual override returns (string memory) {
178         return _name;
179     }
180 
181     /**
182      * @dev Returns the symbol of the token, usually a shorter version of the
183      * name.
184      */
185     function symbol() public view virtual override returns (string memory) {
186         return _symbol;
187     }
188 
189     /**
190      * @dev Returns the number of decimals used to get its user representation.
191      * For example, if `decimals` equals `2`, a balance of `505` tokens should
192      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
193      *
194      * Tokens usually opt for a value of 18, imitating the relationship between
195      * Ether and Wei. This is the value {ERC20} uses, unless this function is
196      * overridden;
197      *
198      * NOTE: This information is only used for _display_ purposes: it in
199      * no way affects any of the arithmetic of the contract, including
200      * {IERC20-balanceOf} and {IERC20-transfer}.
201      */
202     function decimals() public view virtual override returns (uint8) {
203         return 18;
204     }
205 
206     /**
207      * @dev See {IERC20-totalSupply}.
208      */
209     function totalSupply() public view virtual override returns (uint256) {
210         return _totalSupply;
211     }
212 
213     /**
214      * @dev See {IERC20-balanceOf}.
215      */
216     function balanceOf(address account) public view virtual override returns (uint256) {
217         return _balances[account];
218     }
219 
220     /**
221      * @dev See {IERC20-transfer}.
222      *
223      * Requirements:
224      *
225      * - `recipient` cannot be the zero address.
226      * - the caller must have a balance of at least `amount`.
227      */
228     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     /**
234      * @dev See {IERC20-allowance}.
235      */
236     function allowance(address owner, address spender) public view virtual override returns (uint256) {
237         return _allowances[owner][spender];
238     }
239 
240     /**
241      * @dev See {IERC20-approve}.
242      *
243      * Requirements:
244      *
245      * - `spender` cannot be the zero address.
246      */
247     function approve(address spender, uint256 amount) public virtual override returns (bool) {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251 
252     /**
253      * @dev See {IERC20-transferFrom}.
254      *
255      * Emits an {Approval} event indicating the updated allowance. This is not
256      * required by the EIP. See the note at the beginning of {ERC20}.
257      *
258      * Requirements:
259      *
260      * - `sender` and `recipient` cannot be the zero address.
261      * - `sender` must have a balance of at least `amount`.
262      * - the caller must have allowance for ``sender``'s tokens of at least
263      * `amount`.
264      */
265     function transferFrom(
266         address sender,
267         address recipient,
268         uint256 amount
269     ) public virtual override returns (bool) {
270         _transfer(sender, recipient, amount);
271         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
272         return true;
273     }
274 
275     /**
276      * @dev Atomically increases the allowance granted to `spender` by the caller.
277      *
278      * This is an alternative to {approve} that can be used as a mitigation for
279      * problems described in {IERC20-approve}.
280      *
281      * Emits an {Approval} event indicating the updated allowance.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
288         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
289         return true;
290     }
291 
292     /**
293      * @dev Atomically decreases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to {approve} that can be used as a mitigation for
296      * problems described in {IERC20-approve}.
297      *
298      * Emits an {Approval} event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      * - `spender` must have allowance for the caller of at least
304      * `subtractedValue`.
305      */
306     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
307         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
308         return true;
309     }
310 
311     /**
312      * @dev Moves tokens `amount` from `sender` to `recipient`.
313      *
314      * This is internal function is equivalent to {transfer}, and can be used to
315      * e.g. implement automatic token fees, slashing mechanisms, etc.
316      *
317      * Emits a {Transfer} event.
318      *
319      * Requirements:
320      *
321      * - `sender` cannot be the zero address.
322      * - `recipient` cannot be the zero address.
323      * - `sender` must have a balance of at least `amount`.
324      */
325     function _transfer(
326         address sender,
327         address recipient,
328         uint256 amount
329     ) internal virtual {
330         require(sender != address(0), "ERC20: transfer from the zero address");
331         require(recipient != address(0), "ERC20: transfer to the zero address");
332 
333         _beforeTokenTransfer(sender, recipient, amount);
334 
335         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
336         _balances[recipient] = _balances[recipient].add(amount);
337         emit Transfer(sender, recipient, amount);
338     }
339 
340     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
341      * the total supply.
342      *
343      * Emits a {Transfer} event with `from` set to the zero address.
344      *
345      * Requirements:
346      *
347      * - `account` cannot be the zero address.
348      */
349     function _mint(address account, uint256 amount) internal virtual {
350         require(account != address(0), "ERC20: mint to the zero address");
351 
352         _beforeTokenTransfer(address(0), account, amount);
353 
354         _totalSupply = _totalSupply.add(amount);
355         _balances[account] = _balances[account].add(amount);
356         emit Transfer(address(0), account, amount);
357     }
358 
359     /**
360      * @dev Destroys `amount` tokens from `account`, reducing the
361      * total supply.
362      *
363      * Emits a {Transfer} event with `to` set to the zero address.
364      *
365      * Requirements:
366      *
367      * - `account` cannot be the zero address.
368      * - `account` must have at least `amount` tokens.
369      */
370     function _burn(address account, uint256 amount) internal virtual {
371         require(account != address(0), "ERC20: burn from the zero address");
372 
373         _beforeTokenTransfer(account, address(0), amount);
374 
375         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
376         _totalSupply = _totalSupply.sub(amount);
377         emit Transfer(account, address(0), amount);
378     }
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
382      *
383      * This internal function is equivalent to `approve`, and can be used to
384      * e.g. set automatic allowances for certain subsystems, etc.
385      *
386      * Emits an {Approval} event.
387      *
388      * Requirements:
389      *
390      * - `owner` cannot be the zero address.
391      * - `spender` cannot be the zero address.
392      */
393     function _approve(
394         address owner,
395         address spender,
396         uint256 amount
397     ) internal virtual {
398         require(owner != address(0), "ERC20: approve from the zero address");
399         require(spender != address(0), "ERC20: approve to the zero address");
400 
401         _allowances[owner][spender] = amount;
402         emit Approval(owner, spender, amount);
403     }
404 
405     /**
406      * @dev Hook that is called before any transfer of tokens. This includes
407      * minting and burning.
408      *
409      * Calling conditions:
410      *
411      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
412      * will be to transferred to `to`.
413      * - when `from` is zero, `amount` tokens will be minted for `to`.
414      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
415      * - `from` and `to` are never both zero.
416      *
417      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
418      */
419     function _beforeTokenTransfer(
420         address from,
421         address to,
422         uint256 amount
423     ) internal virtual {}
424 }
425 
426 library SafeMath {
427     /**
428      * @dev Returns the addition of two unsigned integers, reverting on
429      * overflow.
430      *
431      * Counterpart to Solidity's `+` operator.
432      *
433      * Requirements:
434      *
435      * - Addition cannot overflow.
436      */
437     function add(uint256 a, uint256 b) internal pure returns (uint256) {
438         uint256 c = a + b;
439         require(c >= a, "SafeMath: addition overflow");
440 
441         return c;
442     }
443 
444     /**
445      * @dev Returns the subtraction of two unsigned integers, reverting on
446      * overflow (when the result is negative).
447      *
448      * Counterpart to Solidity's `-` operator.
449      *
450      * Requirements:
451      *
452      * - Subtraction cannot overflow.
453      */
454     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
455         return sub(a, b, "SafeMath: subtraction overflow");
456     }
457 
458     /**
459      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
460      * overflow (when the result is negative).
461      *
462      * Counterpart to Solidity's `-` operator.
463      *
464      * Requirements:
465      *
466      * - Subtraction cannot overflow.
467      */
468     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
469         require(b <= a, errorMessage);
470         uint256 c = a - b;
471 
472         return c;
473     }
474 
475     /**
476      * @dev Returns the multiplication of two unsigned integers, reverting on
477      * overflow.
478      *
479      * Counterpart to Solidity's `*` operator.
480      *
481      * Requirements:
482      *
483      * - Multiplication cannot overflow.
484      */
485     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
486         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
487         // benefit is lost if 'b' is also tested.
488         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
489         if (a == 0) {
490             return 0;
491         }
492 
493         uint256 c = a * b;
494         require(c / a == b, "SafeMath: multiplication overflow");
495 
496         return c;
497     }
498 
499     /**
500      * @dev Returns the integer division of two unsigned integers. Reverts on
501      * division by zero. The result is rounded towards zero.
502      *
503      * Counterpart to Solidity's `/` operator. Note: this function uses a
504      * `revert` opcode (which leaves remaining gas untouched) while Solidity
505      * uses an invalid opcode to revert (consuming all remaining gas).
506      *
507      * Requirements:
508      *
509      * - The divisor cannot be zero.
510      */
511     function div(uint256 a, uint256 b) internal pure returns (uint256) {
512         return div(a, b, "SafeMath: division by zero");
513     }
514 
515     /**
516      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
517      * division by zero. The result is rounded towards zero.
518      *
519      * Counterpart to Solidity's `/` operator. Note: this function uses a
520      * `revert` opcode (which leaves remaining gas untouched) while Solidity
521      * uses an invalid opcode to revert (consuming all remaining gas).
522      *
523      * Requirements:
524      *
525      * - The divisor cannot be zero.
526      */
527     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
528         require(b > 0, errorMessage);
529         uint256 c = a / b;
530         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
531 
532         return c;
533     }
534 
535     /**
536      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
537      * Reverts when dividing by zero.
538      *
539      * Counterpart to Solidity's `%` operator. This function uses a `revert`
540      * opcode (which leaves remaining gas untouched) while Solidity uses an
541      * invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
548         return mod(a, b, "SafeMath: modulo by zero");
549     }
550 
551     /**
552      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
553      * Reverts with custom message when dividing by zero.
554      *
555      * Counterpart to Solidity's `%` operator. This function uses a `revert`
556      * opcode (which leaves remaining gas untouched) while Solidity uses an
557      * invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
564         require(b != 0, errorMessage);
565         return a % b;
566     }
567 }
568 
569 contract Ownable is Context {
570     address private _owner;
571 
572     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
573     
574     /**
575      * @dev Initializes the contract setting the deployer as the initial owner.
576      */
577     constructor () {
578         address msgSender = _msgSender();
579         _owner = msgSender;
580         emit OwnershipTransferred(address(0), msgSender);
581     }
582 
583     /**
584      * @dev Returns the address of the current owner.
585      */
586     function owner() public view returns (address) {
587         return _owner;
588     }
589 
590     /**
591      * @dev Throws if called by any account other than the owner.
592      */
593     modifier onlyOwner() {
594         require(_owner == _msgSender(), "Ownable: caller is not the owner");
595         _;
596     }
597 
598     /**
599      * @dev Leaves the contract without owner. It will not be possible to call
600      * `onlyOwner` functions anymore. Can only be called by the current owner.
601      *
602      * NOTE: Renouncing ownership will leave the contract without an owner,
603      * thereby removing any functionality that is only available to the owner.
604      */
605     function renounceOwnership() public virtual onlyOwner {
606         emit OwnershipTransferred(_owner, address(0));
607         _owner = address(0);
608     }
609 
610     /**
611      * @dev Transfers ownership of the contract to a new account (`newOwner`).
612      * Can only be called by the current owner.
613      */
614     function transferOwnership(address newOwner) public virtual onlyOwner {
615         require(newOwner != address(0), "Ownable: new owner is the zero address");
616         emit OwnershipTransferred(_owner, newOwner);
617         _owner = newOwner;
618     }
619 }
620 
621 
622 
623 library SafeMathInt {
624     int256 private constant MIN_INT256 = int256(1) << 255;
625     int256 private constant MAX_INT256 = ~(int256(1) << 255);
626 
627     /**
628      * @dev Multiplies two int256 variables and fails on overflow.
629      */
630     function mul(int256 a, int256 b) internal pure returns (int256) {
631         int256 c = a * b;
632 
633         // Detect overflow when multiplying MIN_INT256 with -1
634         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
635         require((b == 0) || (c / b == a));
636         return c;
637     }
638 
639     /**
640      * @dev Division of two int256 variables and fails on overflow.
641      */
642     function div(int256 a, int256 b) internal pure returns (int256) {
643         // Prevent overflow when dividing MIN_INT256 by -1
644         require(b != -1 || a != MIN_INT256);
645 
646         // Solidity already throws when dividing by 0.
647         return a / b;
648     }
649 
650     /**
651      * @dev Subtracts two int256 variables and fails on overflow.
652      */
653     function sub(int256 a, int256 b) internal pure returns (int256) {
654         int256 c = a - b;
655         require((b >= 0 && c <= a) || (b < 0 && c > a));
656         return c;
657     }
658 
659     /**
660      * @dev Adds two int256 variables and fails on overflow.
661      */
662     function add(int256 a, int256 b) internal pure returns (int256) {
663         int256 c = a + b;
664         require((b >= 0 && c >= a) || (b < 0 && c < a));
665         return c;
666     }
667 
668     /**
669      * @dev Converts to absolute value, and fails on overflow.
670      */
671     function abs(int256 a) internal pure returns (int256) {
672         require(a != MIN_INT256);
673         return a < 0 ? -a : a;
674     }
675 
676 
677     function toUint256Safe(int256 a) internal pure returns (uint256) {
678         require(a >= 0);
679         return uint256(a);
680     }
681 }
682 
683 library SafeMathUint {
684   function toInt256Safe(uint256 a) internal pure returns (int256) {
685     int256 b = int256(a);
686     require(b >= 0);
687     return b;
688   }
689 }
690 
691 
692 interface IUniswapV2Router01 {
693     function factory() external pure returns (address);
694     function WETH() external pure returns (address);
695 
696     function addLiquidityETH(
697         address token,
698         uint amountTokenDesired,
699         uint amountTokenMin,
700         uint amountETHMin,
701         address to,
702         uint deadline
703     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
704 }
705 
706 interface IUniswapV2Router02 is IUniswapV2Router01 {
707     function swapExactTokensForETHSupportingFeeOnTransferTokens(
708         uint amountIn,
709         uint amountOutMin,
710         address[] calldata path,
711         address to,
712         uint deadline
713     ) external;
714 }
715 
716 contract MOOSE is ERC20, Ownable {
717 
718     IUniswapV2Router02 public immutable uniswapV2Router;
719     address public immutable uniswapV2Pair;
720     address public constant deadAddress = address(0xdead);
721 
722     bool private swapping;
723 
724     address public marketingWallet;
725     address public devWallet;
726     
727     uint256 public maxTransactionAmount;
728     uint256 public swapTokensAtAmount;
729     uint256 public maxWallet;
730     
731     uint256 public percentForLPBurn = 25; // 25 = .25%
732     bool public lpBurnEnabled = false;
733     uint256 public lpBurnFrequency = 3600 seconds;
734     uint256 public lastLpBurnTime;
735     
736     uint256 public manualBurnFrequency = 30 minutes;
737     uint256 public lastManualLpBurnTime;
738 
739     bool public limitsInEffect = true;
740     bool public tradingActive = false;
741     bool public swapEnabled = false;
742     
743      // Anti-bot and anti-whale mappings and variables
744     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
745     mapping (address => bool) public isBlacklisted;
746     bool public transferDelayEnabled = true;
747 
748     uint256 public buyTotalFees;
749     uint256 public buyMarketingFee;
750     uint256 public buyLiquidityFee;
751     uint256 public buyDevFee;
752     
753     uint256 public sellTotalFees;
754     uint256 public sellMarketingFee;
755     uint256 public sellLiquidityFee;
756     uint256 public sellDevFee;
757     
758     uint256 public tokensForMarketing;
759     uint256 public tokensForLiquidity;
760     uint256 public tokensForDev;
761 
762     // exlcude from fees and max transaction amount
763     mapping (address => bool) private _isExcludedFromFees;
764     mapping (address => bool) public _isExcludedMaxTransactionAmount;
765 
766     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
767     // could be subject to a maximum transfer amount
768     mapping (address => bool) public automatedMarketMakerPairs;
769 
770     constructor() ERC20("Moose Finance", "MOOSE") {
771         
772         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
773         
774         excludeFromMaxTransaction(address(_uniswapV2Router), true);
775         uniswapV2Router = _uniswapV2Router;
776         
777         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
778         excludeFromMaxTransaction(address(uniswapV2Pair), true);
779         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
780         
781         uint256 _buyMarketingFee = 50;
782         uint256 _buyLiquidityFee = 0;
783         uint256 _buyDevFee = 0;
784 
785         uint256 _sellMarketingFee = 60;
786         uint256 _sellLiquidityFee = 0;
787         uint256 _sellDevFee = 0;
788         
789         uint256 totalSupply = 1000000000000 * 1e18; 
790         
791         maxTransactionAmount = totalSupply * 3 / 100; // 3% maxTransactionAmountTxn
792         maxWallet = totalSupply * 3 / 100; // 3% maxWallet
793         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap wallet
794 
795         buyMarketingFee = _buyMarketingFee;
796         buyLiquidityFee = _buyLiquidityFee;
797         buyDevFee = _buyDevFee;
798         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
799         
800         sellMarketingFee = _sellMarketingFee;
801         sellLiquidityFee = _sellLiquidityFee;
802         sellDevFee = _sellDevFee;
803         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
804         
805         marketingWallet = address(owner()); // set as marketing wallet
806         devWallet = address(owner()); // set as dev wallet
807 
808         // exclude from paying fees or having max transaction amount
809         excludeFromFees(owner(), true);
810         excludeFromFees(address(this), true);
811         excludeFromFees(address(0xdead), true);
812         
813         excludeFromMaxTransaction(owner(), true);
814         excludeFromMaxTransaction(address(this), true);
815         excludeFromMaxTransaction(address(0xdead), true);
816         
817         _mint(msg.sender, totalSupply);
818     }
819 
820     receive() external payable {
821 
822   	}
823 
824     // once enabled, can never be turned off
825     function openTrading() external onlyOwner {
826         tradingActive = true;
827         swapEnabled = true;
828         lastLpBurnTime = block.timestamp;
829     }
830     
831     // remove limits after token is stable
832     function removelimits() external onlyOwner returns (bool){
833         limitsInEffect = false;
834         transferDelayEnabled = false;
835         return true;
836     }
837     
838     // change the minimum amount of tokens to sell from fees
839     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
840   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
841   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
842   	    return true;
843   	}
844     
845     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
846         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
847         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
848         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
849         maxWallet = (totalSupply() * walNum / 100)/1e18;
850     }
851 
852     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
853         _isExcludedMaxTransactionAmount[updAds] = isEx;
854     }
855     
856     // only use to disable contract sales if absolutely necessary (emergency use only)
857     function updateSwapEnabled(bool enabled) external onlyOwner(){
858         swapEnabled = enabled;
859     }
860     
861     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
862         buyMarketingFee = _marketingFee;
863         buyLiquidityFee = _liquidityFee;
864         buyDevFee = _devFee;
865         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
866         require(buyTotalFees <= 60, "Must keep fees at 20% or less");
867     }
868     
869     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
870         sellMarketingFee = _marketingFee;
871         sellLiquidityFee = _liquidityFee;
872         sellDevFee = _devFee;
873         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
874         require(sellTotalFees <= 75, "Must keep fees at 25% or less");
875     }
876 
877     function excludeFromFees(address account, bool excluded) public onlyOwner {
878         _isExcludedFromFees[account] = excluded;
879     }
880 
881     function _setAutomatedMarketMakerPair(address pair, bool value) private {
882         automatedMarketMakerPairs[pair] = value;
883     }
884 
885     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
886         marketingWallet = newMarketingWallet;
887     }
888     
889     function updateDevWallet(address newWallet) external onlyOwner {
890         devWallet = newWallet;
891     }
892 
893     function isExcludedFromFees(address account) public view returns(bool) {
894         return _isExcludedFromFees[account];
895     }
896 
897     function managemoose_bots(address _address, bool status) external onlyOwner {
898         require(_address != address(0),"Address should not be 0");
899         isBlacklisted[_address] = status;
900     }
901 
902     function _transfer(
903         address from,
904         address to,
905         uint256 amount
906     ) internal override {
907         require(from != address(0), "ERC20: transfer from the zero address");
908         require(to != address(0), "ERC20: transfer to the zero address");
909         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
910         
911          if(amount == 0) {
912             super._transfer(from, to, 0);
913             return;
914         }
915         
916         if(limitsInEffect){
917             if (
918                 from != owner() &&
919                 to != owner() &&
920                 to != address(0) &&
921                 to != address(0xdead) &&
922                 !swapping
923             ){
924                 if(!tradingActive){
925                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
926                 }
927 
928                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
929                 if (transferDelayEnabled){
930                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
931                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
932                         _holderLastTransferTimestamp[tx.origin] = block.number;
933                     }
934                 }
935                  
936                 //when buy
937                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
938                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
939                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
940                 }
941                 
942                 //when sell
943                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
944                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
945                 }
946                 else if(!_isExcludedMaxTransactionAmount[to]){
947                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
948                 }
949             }
950         }
951         
952 		uint256 contractTokenBalance = balanceOf(address(this));
953         
954         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
955 
956         if( 
957             canSwap &&
958             swapEnabled &&
959             !swapping &&
960             !automatedMarketMakerPairs[from] &&
961             !_isExcludedFromFees[from] &&
962             !_isExcludedFromFees[to]
963         ) {
964             swapping = true;
965             
966             swapBack();
967 
968             swapping = false;
969         }
970 
971         bool takeFee = !swapping;
972 
973         // if any account belongs to _isExcludedFromFee account then remove the fee
974         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
975             takeFee = false;
976         }
977         
978         uint256 fees = 0;
979         // only take fees on buys/sells, do not take on wallet transfers
980         if(takeFee){
981             // on sell
982             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
983                 fees = amount * sellTotalFees/100;
984                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
985                 tokensForDev += fees * sellDevFee / sellTotalFees;
986                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
987             }
988             // on buy
989             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
990         	    fees = amount * buyTotalFees/100;
991         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
992                 tokensForDev += fees * buyDevFee / buyTotalFees;
993                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
994             }
995             
996             if(fees > 0){    
997                 super._transfer(from, address(this), fees);
998             }
999         	
1000         	amount -= fees;
1001         }
1002 
1003         super._transfer(from, to, amount);
1004     }
1005 
1006     function swapTokensForEth(uint256 tokenAmount) private {
1007 
1008         // generate the uniswap pair path of token -> weth
1009         address[] memory path = new address[](2);
1010         path[0] = address(this);
1011         path[1] = uniswapV2Router.WETH();
1012 
1013         _approve(address(this), address(uniswapV2Router), tokenAmount);
1014 
1015         // make the swap
1016         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1017             tokenAmount,
1018             0, // accept any amount of ETH
1019             path,
1020             address(this),
1021             block.timestamp
1022         );
1023         
1024     }
1025     
1026     
1027     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1028         // approve token transfer to cover all possible scenarios
1029         _approve(address(this), address(uniswapV2Router), tokenAmount);
1030 
1031         // add the liquidity
1032         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1033             address(this),
1034             tokenAmount,
1035             0, // slippage is unavoidable
1036             0, // slippage is unavoidable
1037             deadAddress,
1038             block.timestamp
1039         );
1040     }
1041 
1042     function swapBack() private {
1043         uint256 contractBalance = balanceOf(address(this));
1044         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1045         bool success;
1046         
1047         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1048 
1049         if(contractBalance > swapTokensAtAmount * 20){
1050           contractBalance = swapTokensAtAmount * 20;
1051         }
1052         
1053         // Halve the amount of liquidity tokens
1054         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1055         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1056         
1057         uint256 initialETHBalance = address(this).balance;
1058 
1059         swapTokensForEth(amountToSwapForETH); 
1060         
1061         uint256 ethBalance = address(this).balance - initialETHBalance;
1062         
1063         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1064         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1065         
1066         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1067         
1068         tokensForLiquidity = 0;
1069         tokensForMarketing = 0;
1070         tokensForDev = 0;
1071         
1072         (success,) = address(devWallet).call{value: ethForDev}("");
1073         
1074         if(liquidityTokens > 0 && ethForLiquidity > 0){
1075             addLiquidity(liquidityTokens, ethForLiquidity);
1076         }
1077         
1078         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1079     }
1080 
1081     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1082         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1083         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1084         lastManualLpBurnTime = block.timestamp;
1085         
1086         // get balance of liquidity pair
1087         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1088         
1089         // calculate amount to burn
1090         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1091         
1092         // pull tokens from pancakePair liquidity and move to dead address permanently
1093         if (amountToBurn > 0){
1094             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1095         }
1096         
1097         //sync price since this is not in a swap transaction!
1098         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1099         pair.sync();
1100         return true;
1101     }
1102 }