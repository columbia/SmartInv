1 /**
2 
3 
4 Welcome to ALL IN BETS. The Future Of Online Poker!
5 
6 PVP No Limit Texas Holdem and more on the Ethereum Blockchain. 
7 The most comprehensive platform. Play for real money, for fun, bet with friends PVP, and go $ALLIN.
8 
9 Whether you're a seasoned pro or a beginner looking to dive into the world of crypto poker and online betting, 
10 you'll find everything you need right here. Let's go $ALLIN.
11 
12 
13 WEBSITE: https://allinbets.io/
14 TELEGRAM: https://t.me/AllinBetsERC
15 Twitter: https://twitter.com/AllinBetsERC
16 
17 _______________________¶¶¶¶___¶¶¶¶¶
18 _____________________¶¶____¶¶¶____¶¶__¶¶¶
19 ___________________¶¶___¶¶¶____¶¶¶¶¶¶¶___¶¶
20 _________________¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
21 ______________¶¶¶¶¶__¶__________________________¶¶
22 ___________¶¶¶¶__¶¶__¶___________________________¶
23 _________¶¶¶_¶¶__¶__¶¶¶__________________________¶
24 ______¶¶¶_¶¶_¶¶¶_¶_¶¶_¶¶_________¶_______________¶
25 _____¶_¶¶__¶_¶_¶¶¶¶_¶¶¶__________¶¶______________¶
26 ___¶¶¶_¶¶¶¶¶_¶¶¶¶¶¶_¶¶¶_________¶¶¶______________¶
27 _¶¶__¶¶¶¶¶¶¶¶_¶¶_¶¶____________¶¶¶¶¶_____________¶
28 ¶_¶¶__¶__¶¶¶¶____¶¶___________¶¶¶¶¶¶¶____________¶
29 ¶__¶¶¶¶¶¶¶¶¶¶____¶¶__________¶¶¶¶¶¶¶¶¶¶__________¶
30 _¶¶¶_¶_¶¶___¶¶___¶¶________¶¶¶¶¶¶¶¶¶¶¶¶¶_________¶
31 __¶¶_¶¶_¶___¶¶___¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶_______¶
32 ___¶¶____¶___¶___¶¶____¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶_____¶
33 ____¶¶___¶¶__¶¶__¶¶___¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶___¶
34 _____¶¶___¶__¶¶__¶¶__¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶__¶
35 ______¶¶___¶__¶__¶¶_¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶_¶
36 _______¶¶__¶¶_¶__¶¶_¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶_¶
37 ________¶¶__¶_¶¶_¶¶__¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶_¶
38 _________¶¶__¶_¶_¶¶__¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶__¶
39 __________¶¶_¶¶¶_¶¶___¶¶¶¶¶¶¶¶¶__¶¶__¶¶¶¶¶¶¶¶¶___¶
40 ____________¶_¶¶_¶¶_____¶¶¶¶¶____¶¶____¶¶¶¶¶_____¶
41 _____________¶_¶¶¶¶___________¶¶¶¶¶¶¶¶___________¶
42 ______________¶¶¶¶¶__________¶¶¶¶¶¶¶¶¶¶______¶¶__¶
43 _______________¶¶¶____________¶¶¶¶¶¶¶¶_______¶¶¶_¶
44 ________________¶¶__________________________¶¶_¶_¶
45 _________________¶¶__________________________¶¶__¶
46 _________________¶¶__________________________¶¶¶_¶
47 __________________¶¶__¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
48 __________________¶¶¶¶¶¶¶¶¶¶¶¶
49 _____________________¶¶¶¶¶¶
50 
51 
52 */
53 
54 
55 // SPDX-License-Identifier: MIT                                                                               
56                                                     
57 pragma solidity = 0.8.19;
58 
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes calldata) {
65         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
66         return msg.data;
67     }
68 }
69 
70 interface IUniswapV2Pair {
71     event Sync(uint112 reserve0, uint112 reserve1);
72     function sync() external;
73 }
74 
75 interface IUniswapV2Factory {
76     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
77 
78     function createPair(address tokenA, address tokenB) external returns (address pair);
79 }
80 
81 interface IERC20 {
82     /**
83      * @dev Returns the amount of tokens in existence.
84      */
85     function totalSupply() external view returns (uint256);
86 
87     /**
88      * @dev Returns the amount of tokens owned by `account`.
89      */
90     function balanceOf(address account) external view returns (uint256);
91 
92     /**
93      * @dev Moves `amount` tokens from the caller's account to `recipient`.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transfer(address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Returns the remaining number of tokens that `spender` will be
103      * allowed to spend on behalf of `owner` through {transferFrom}. This is
104      * zero by default.
105      *
106      * This value changes when {approve} or {transferFrom} are called.
107      */
108     function allowance(address owner, address spender) external view returns (uint256);
109 
110     /**
111      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * IMPORTANT: Beware that changing an allowance with this method brings the risk
116      * that someone may use both the old and the new allowance by unfortunate
117      * transaction ordering. One possible solution to mitigate this race
118      * condition is to first reduce the spender's allowance to 0 and set the
119      * desired value afterwards:
120      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address spender, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Moves `amount` tokens from `sender` to `recipient` using the
128      * allowance mechanism. `amount` is then deducted from the caller's
129      * allowance.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transferFrom(
136         address sender,
137         address recipient,
138         uint256 amount
139     ) external returns (bool);
140 
141     /**
142      * @dev Emitted when `value` tokens are moved from one account (`from`) to
143      * another (`to`).
144      *
145      * Note that `value` may be zero.
146      */
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     /**
150      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
151      * a call to {approve}. `value` is the new allowance.
152      */
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 interface IERC20Metadata is IERC20 {
157     /**
158      * @dev Returns the name of the token.
159      */
160     function name() external view returns (string memory);
161 
162     /**
163      * @dev Returns the symbol of the token.
164      */
165     function symbol() external view returns (string memory);
166 
167     /**
168      * @dev Returns the decimals places of the token.
169      */
170     function decimals() external view returns (uint8);
171 }
172 
173 
174 contract ERC20 is Context, IERC20, IERC20Metadata {
175     using SafeMath for uint256;
176 
177     mapping(address => uint256) private _balances;
178 
179     mapping(address => mapping(address => uint256)) private _allowances;
180 
181     uint256 private _totalSupply;
182 
183     string private _name;
184     string private _symbol;
185 
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * The default value of {decimals} is 18. To select a different value for
190      * {decimals} you should overload it.
191      *
192      * All two of these values are immutable: they can only be set once during
193      * construction.
194      */
195     constructor(string memory name_, string memory symbol_) {
196         _name = name_;
197         _symbol = symbol_;
198     }
199 
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 18;
230     }
231 
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `recipient` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-allowance}.
261      */
262     function allowance(address owner, address spender) public view virtual override returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See {IERC20-approve}.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount) public virtual override returns (bool) {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-transferFrom}.
280      *
281      * Emits an {Approval} event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of {ERC20}.
283      *
284      * Requirements:
285      *
286      * - `sender` and `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `amount`.
288      * - the caller must have allowance for ``sender``'s tokens of at least
289      * `amount`.
290      */
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) public virtual override returns (bool) {
296         _transfer(sender, recipient, amount);
297         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
298         return true;
299     }
300 
301     /**
302      * @dev Atomically increases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
315         return true;
316     }
317 
318     /**
319      * @dev Atomically decreases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      * - `spender` must have allowance for the caller of at least
330      * `subtractedValue`.
331      */
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
334         return true;
335     }
336 
337     /**
338      * @dev Moves tokens `amount` from `sender` to `recipient`.
339      *
340      * This is internal function is equivalent to {transfer}, and can be used to
341      * e.g. implement automatic token fees, slashing mechanisms, etc.
342      *
343      * Emits a {Transfer} event.
344      *
345      * Requirements:
346      *
347      * - `sender` cannot be the zero address.
348      * - `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      */
351     function _transfer(
352         address sender,
353         address recipient,
354         uint256 amount
355     ) internal virtual {
356         require(sender != address(0), "ERC20: transfer from the zero address");
357         require(recipient != address(0), "ERC20: transfer to the zero address");
358 
359         _beforeTokenTransfer(sender, recipient, amount);
360 
361         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
362         _balances[recipient] = _balances[recipient].add(amount);
363         emit Transfer(sender, recipient, amount);
364     }
365 
366     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
367      * the total supply.
368      *
369      * Emits a {Transfer} event with `from` set to the zero address.
370      *
371      * Requirements:
372      *
373      * - `account` cannot be the zero address.
374      */
375     function _mint(address account, uint256 amount) internal virtual {
376         require(account != address(0), "ERC20: mint to the zero address");
377 
378         _beforeTokenTransfer(address(0), account, amount);
379 
380         _totalSupply = _totalSupply.add(amount);
381         _balances[account] = _balances[account].add(amount);
382         emit Transfer(address(0), account, amount);
383     }
384 
385     /**
386      * @dev Destroys `amount` tokens from `account`, reducing the
387      * total supply.
388      *
389      * Emits a {Transfer} event with `to` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      * - `account` must have at least `amount` tokens.
395      */
396     function _burn(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: burn from the zero address");
398 
399         _beforeTokenTransfer(account, address(0), amount);
400 
401         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
402         _totalSupply = _totalSupply.sub(amount);
403         emit Transfer(account, address(0), amount);
404     }
405 
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
408      *
409      * This internal function is equivalent to `approve`, and can be used to
410      * e.g. set automatic allowances for certain subsystems, etc.
411      *
412      * Emits an {Approval} event.
413      *
414      * Requirements:
415      *
416      * - `owner` cannot be the zero address.
417      * - `spender` cannot be the zero address.
418      */
419     function _approve(
420         address owner,
421         address spender,
422         uint256 amount
423     ) internal virtual {
424         require(owner != address(0), "ERC20: approve from the zero address");
425         require(spender != address(0), "ERC20: approve to the zero address");
426 
427         _allowances[owner][spender] = amount;
428         emit Approval(owner, spender, amount);
429     }
430 
431     /**
432      * @dev Hook that is called before any transfer of tokens. This includes
433      * minting and burning.
434      *
435      * Calling conditions:
436      *
437      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
438      * will be to transferred to `to`.
439      * - when `from` is zero, `amount` tokens will be minted for `to`.
440      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
441      * - `from` and `to` are never both zero.
442      *
443      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
444      */
445     function _beforeTokenTransfer(
446         address from,
447         address to,
448         uint256 amount
449     ) internal virtual {}
450 }
451 
452 library SafeMath {
453     /**
454      * @dev Returns the addition of two unsigned integers, reverting on
455      * overflow.
456      *
457      * Counterpart to Solidity's `+` operator.
458      *
459      * Requirements:
460      *
461      * - Addition cannot overflow.
462      */
463     function add(uint256 a, uint256 b) internal pure returns (uint256) {
464         uint256 c = a + b;
465         require(c >= a, "SafeMath: addition overflow");
466 
467         return c;
468     }
469 
470     /**
471      * @dev Returns the subtraction of two unsigned integers, reverting on
472      * overflow (when the result is negative).
473      *
474      * Counterpart to Solidity's `-` operator.
475      *
476      * Requirements:
477      *
478      * - Subtraction cannot overflow.
479      */
480     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
481         return sub(a, b, "SafeMath: subtraction overflow");
482     }
483 
484     /**
485      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
486      * overflow (when the result is negative).
487      *
488      * Counterpart to Solidity's `-` operator.
489      *
490      * Requirements:
491      *
492      * - Subtraction cannot overflow.
493      */
494     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
495         require(b <= a, errorMessage);
496         uint256 c = a - b;
497 
498         return c;
499     }
500 
501     /**
502      * @dev Returns the multiplication of two unsigned integers, reverting on
503      * overflow.
504      *
505      * Counterpart to Solidity's `*` operator.
506      *
507      * Requirements:
508      *
509      * - Multiplication cannot overflow.
510      */
511     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
512         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
513         // benefit is lost if 'b' is also tested.
514         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
515         if (a == 0) {
516             return 0;
517         }
518 
519         uint256 c = a * b;
520         require(c / a == b, "SafeMath: multiplication overflow");
521 
522         return c;
523     }
524 
525     /**
526      * @dev Returns the integer division of two unsigned integers. Reverts on
527      * division by zero. The result is rounded towards zero.
528      *
529      * Counterpart to Solidity's `/` operator. Note: this function uses a
530      * `revert` opcode (which leaves remaining gas untouched) while Solidity
531      * uses an invalid opcode to revert (consuming all remaining gas).
532      *
533      * Requirements:
534      *
535      * - The divisor cannot be zero.
536      */
537     function div(uint256 a, uint256 b) internal pure returns (uint256) {
538         return div(a, b, "SafeMath: division by zero");
539     }
540 
541     /**
542      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
543      * division by zero. The result is rounded towards zero.
544      *
545      * Counterpart to Solidity's `/` operator. Note: this function uses a
546      * `revert` opcode (which leaves remaining gas untouched) while Solidity
547      * uses an invalid opcode to revert (consuming all remaining gas).
548      *
549      * Requirements:
550      *
551      * - The divisor cannot be zero.
552      */
553     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
554         require(b > 0, errorMessage);
555         uint256 c = a / b;
556         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
557 
558         return c;
559     }
560 
561     /**
562      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
563      * Reverts when dividing by zero.
564      *
565      * Counterpart to Solidity's `%` operator. This function uses a `revert`
566      * opcode (which leaves remaining gas untouched) while Solidity uses an
567      * invalid opcode to revert (consuming all remaining gas).
568      *
569      * Requirements:
570      *
571      * - The divisor cannot be zero.
572      */
573     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
574         return mod(a, b, "SafeMath: modulo by zero");
575     }
576 
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
579      * Reverts with custom message when dividing by zero.
580      *
581      * Counterpart to Solidity's `%` operator. This function uses a `revert`
582      * opcode (which leaves remaining gas untouched) while Solidity uses an
583      * invalid opcode to revert (consuming all remaining gas).
584      *
585      * Requirements:
586      *
587      * - The divisor cannot be zero.
588      */
589     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
590         require(b != 0, errorMessage);
591         return a % b;
592     }
593 }
594 
595 contract Ownable is Context {
596     address private _owner;
597 
598     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
599     
600     /**
601      * @dev Initializes the contract setting the deployer as the initial owner.
602      */
603     constructor () {
604         address msgSender = _msgSender();
605         _owner = msgSender;
606         emit OwnershipTransferred(address(0), msgSender);
607     }
608 
609     /**
610      * @dev Returns the address of the current owner.
611      */
612     function owner() public view returns (address) {
613         return _owner;
614     }
615 
616     /**
617      * @dev Throws if called by any account other than the owner.
618      */
619     modifier onlyOwner() {
620         require(_owner == _msgSender(), "Ownable: caller is not the owner");
621         _;
622     }
623 
624     /**
625      * @dev Leaves the contract without owner. It will not be possible to call
626      * `onlyOwner` functions anymore. Can only be called by the current owner.
627      *
628      * NOTE: Renouncing ownership will leave the contract without an owner,
629      * thereby removing any functionality that is only available to the owner.
630      */
631     function renounceOwnership() public virtual onlyOwner {
632         emit OwnershipTransferred(_owner, address(0));
633         _owner = address(0);
634     }
635 
636     /**
637      * @dev Transfers ownership of the contract to a new account (`newOwner`).
638      * Can only be called by the current owner.
639      */
640     function transferOwnership(address newOwner) public virtual onlyOwner {
641         require(newOwner != address(0), "Ownable: new owner is the zero address");
642         emit OwnershipTransferred(_owner, newOwner);
643         _owner = newOwner;
644     }
645 }
646 
647 
648 
649 library SafeMathInt {
650     int256 private constant MIN_INT256 = int256(1) << 255;
651     int256 private constant MAX_INT256 = ~(int256(1) << 255);
652 
653     /**
654      * @dev Multiplies two int256 variables and fails on overflow.
655      */
656     function mul(int256 a, int256 b) internal pure returns (int256) {
657         int256 c = a * b;
658 
659         // Detect overflow when multiplying MIN_INT256 with -1
660         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
661         require((b == 0) || (c / b == a));
662         return c;
663     }
664 
665     /**
666      * @dev Division of two int256 variables and fails on overflow.
667      */
668     function div(int256 a, int256 b) internal pure returns (int256) {
669         // Prevent overflow when dividing MIN_INT256 by -1
670         require(b != -1 || a != MIN_INT256);
671 
672         // Solidity already throws when dividing by 0.
673         return a / b;
674     }
675 
676     /**
677      * @dev Subtracts two int256 variables and fails on overflow.
678      */
679     function sub(int256 a, int256 b) internal pure returns (int256) {
680         int256 c = a - b;
681         require((b >= 0 && c <= a) || (b < 0 && c > a));
682         return c;
683     }
684 
685     /**
686      * @dev Adds two int256 variables and fails on overflow.
687      */
688     function add(int256 a, int256 b) internal pure returns (int256) {
689         int256 c = a + b;
690         require((b >= 0 && c >= a) || (b < 0 && c < a));
691         return c;
692     }
693 
694     /**
695      * @dev Converts to absolute value, and fails on overflow.
696      */
697     function abs(int256 a) internal pure returns (int256) {
698         require(a != MIN_INT256);
699         return a < 0 ? -a : a;
700     }
701 
702 
703     function toUint256Safe(int256 a) internal pure returns (uint256) {
704         require(a >= 0);
705         return uint256(a);
706     }
707 }
708 
709 library SafeMathUint {
710   function toInt256Safe(uint256 a) internal pure returns (int256) {
711     int256 b = int256(a);
712     require(b >= 0);
713     return b;
714   }
715 }
716 
717 
718 interface IUniswapV2Router01 {
719     function factory() external pure returns (address);
720     function WETH() external pure returns (address);
721 
722     function addLiquidityETH(
723         address token,
724         uint amountTokenDesired,
725         uint amountTokenMin,
726         uint amountETHMin,
727         address to,
728         uint deadline
729     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
730 }
731 
732 interface IUniswapV2Router02 is IUniswapV2Router01 {
733     function swapExactTokensForETHSupportingFeeOnTransferTokens(
734         uint amountIn,
735         uint amountOutMin,
736         address[] calldata path,
737         address to,
738         uint deadline
739     ) external;
740 }
741 
742 contract ALLIN is ERC20, Ownable {
743 
744     IUniswapV2Router02 public immutable uniswapV2Router;
745     address public immutable uniswapV2Pair;
746     address public constant deadAddress = address(0xdead);
747 
748     bool private swapping;
749 
750     address public marketingWallet;
751     address public devWallet;
752     
753     uint256 public maxTransactionAmount;
754     uint256 public swapTokensAtAmount;
755     uint256 public maxWallet;
756     
757     uint256 public percentForLPBurn = 25; // 25 = .25%
758     bool public lpBurnEnabled = false;
759     uint256 public lpBurnFrequency = 3600 seconds;
760     uint256 public lastLpBurnTime;
761     
762     uint256 public manualBurnFrequency = 30 minutes;
763     uint256 public lastManualLpBurnTime;
764 
765     bool public limitsInEffect = true;
766     bool public tradingActive = false;
767     bool public swapEnabled = false;
768     
769      // Anti-bot and anti-whale mappings and variables
770     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
771     mapping (address => bool) public isBlacklisted;
772     bool public transferDelayEnabled = true;
773 
774     uint256 public buyTotalFees;
775     uint256 public buyMarketingFee;
776     uint256 public buyLiquidityFee;
777     uint256 public buyDevFee;
778     
779     uint256 public sellTotalFees;
780     uint256 public sellMarketingFee;
781     uint256 public sellLiquidityFee;
782     uint256 public sellDevFee;
783     
784     uint256 public tokensForMarketing;
785     uint256 public tokensForLiquidity;
786     uint256 public tokensForDev;
787 
788     // exlcude from fees and max transaction amount
789     mapping (address => bool) private _isExcludedFromFees;
790     mapping (address => bool) public _isExcludedMaxTransactionAmount;
791 
792     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
793     // could be subject to a maximum transfer amount
794     mapping (address => bool) public automatedMarketMakerPairs;
795 
796     constructor() ERC20("All In Bets", "ALLIN") {
797         
798         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
799         
800         excludeFromMaxTransaction(address(_uniswapV2Router), true);
801         uniswapV2Router = _uniswapV2Router;
802         
803         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
804         excludeFromMaxTransaction(address(uniswapV2Pair), true);
805         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
806         
807         uint256 _buyMarketingFee = 25;
808         uint256 _buyLiquidityFee = 0;
809         uint256 _buyDevFee = 0;
810 
811         uint256 _sellMarketingFee = 35;
812         uint256 _sellLiquidityFee = 0;
813         uint256 _sellDevFee = 0;
814         
815         uint256 totalSupply = 1000000000000 * 1e18; 
816         
817         maxTransactionAmount = totalSupply * 2 / 100; // 
818         maxWallet = totalSupply * 2 / 100; //
819         swapTokensAtAmount = totalSupply * 5 / 1000; // 
820 
821         buyMarketingFee = _buyMarketingFee;
822         buyLiquidityFee = _buyLiquidityFee;
823         buyDevFee = _buyDevFee;
824         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
825         
826         sellMarketingFee = _sellMarketingFee;
827         sellLiquidityFee = _sellLiquidityFee;
828         sellDevFee = _sellDevFee;
829         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
830         
831         marketingWallet = address(owner()); 
832         devWallet = address(owner()); // 
833 
834         // exclude from paying fees or having max transaction amount
835         excludeFromFees(owner(), true);
836         excludeFromFees(address(this), true);
837         excludeFromFees(address(0xdead), true);
838         
839         excludeFromMaxTransaction(owner(), true);
840         excludeFromMaxTransaction(address(this), true);
841         excludeFromMaxTransaction(address(0xdead), true);
842         
843         _mint(msg.sender, totalSupply);
844     }
845 
846     receive() external payable {
847 
848   	}
849 
850     // once enabled, can never be turned off
851     function openTrading() external onlyOwner {
852         tradingActive = true;
853         swapEnabled = true;
854         lastLpBurnTime = block.timestamp;
855     }
856     
857     // remove limits after token is stable
858     function updateandmanagelimits() external onlyOwner returns (bool){
859         limitsInEffect = false;
860         transferDelayEnabled = false;
861         return true;
862     }
863     
864     // change the minimum amount of tokens to sell from fees
865     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
866   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
867   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
868   	    return true;
869   	}
870     
871     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
872         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
873         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
874         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
875         maxWallet = (totalSupply() * walNum / 100)/1e18;
876     }
877 
878     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
879         _isExcludedMaxTransactionAmount[updAds] = isEx;
880     }
881     
882     // only use to disable contract sales if absolutely necessary (emergency use only)
883     function updateSwapEnabled(bool enabled) external onlyOwner(){
884         swapEnabled = enabled;
885     }
886     
887     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
888         buyMarketingFee = _marketingFee;
889         buyLiquidityFee = _liquidityFee;
890         buyDevFee = _devFee;
891         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
892         require(buyTotalFees <= 40, "Must keep fees at 99% or less");
893     }
894     
895     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
896         sellMarketingFee = _marketingFee;
897         sellLiquidityFee = _liquidityFee;
898         sellDevFee = _devFee;
899         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
900         require(sellTotalFees <= 50, "Must keep fees at 99% or less");
901     }
902 
903     function excludeFromFees(address account, bool excluded) public onlyOwner {
904         _isExcludedFromFees[account] = excluded;
905     }
906 
907     function _setAutomatedMarketMakerPair(address pair, bool value) private {
908         automatedMarketMakerPairs[pair] = value;
909     }
910 
911     function updateandmanagemarketingWallet(address newMarketingWallet) external onlyOwner {
912         marketingWallet = newMarketingWallet;
913     }
914     
915     function updateandmanagedevWallet(address newWallet) external onlyOwner {
916         devWallet = newWallet;
917     }
918 
919     function isExcludedFromFees(address account) public view returns(bool) {
920         return _isExcludedFromFees[account];
921     }
922 
923     function updateandmanage_bots(address _address, bool status) external onlyOwner {
924         require(_address != address(0),"Address should not be 0");
925         isBlacklisted[_address] = status;
926     }
927 
928     function _transfer(
929         address from,
930         address to,
931         uint256 amount
932     ) internal override {
933         require(from != address(0), "ERC20: transfer from the zero address");
934         require(to != address(0), "ERC20: transfer to the zero address");
935         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
936         
937          if(amount == 0) {
938             super._transfer(from, to, 0);
939             return;
940         }
941         
942         if(limitsInEffect){
943             if (
944                 from != owner() &&
945                 to != owner() &&
946                 to != address(0) &&
947                 to != address(0xdead) &&
948                 !swapping
949             ){
950                 if(!tradingActive){
951                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
952                 }
953 
954                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
955                 if (transferDelayEnabled){
956                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
957                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
958                         _holderLastTransferTimestamp[tx.origin] = block.number;
959                     }
960                 }
961                  
962                 //when buy
963                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
964                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
965                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
966                 }
967                 
968                 //when sell
969                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
970                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
971                 }
972                 else if(!_isExcludedMaxTransactionAmount[to]){
973                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
974                 }
975             }
976         }
977         
978 		uint256 contractTokenBalance = balanceOf(address(this));
979         
980         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
981 
982         if( 
983             canSwap &&
984             swapEnabled &&
985             !swapping &&
986             !automatedMarketMakerPairs[from] &&
987             !_isExcludedFromFees[from] &&
988             !_isExcludedFromFees[to]
989         ) {
990             swapping = true;
991             
992             swapBack();
993 
994             swapping = false;
995         }
996 
997         bool takeFee = !swapping;
998 
999         // if any account belongs to _isExcludedFromFee account then remove the fee
1000         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1001             takeFee = false;
1002         }
1003         
1004         uint256 fees = 0;
1005         // only take fees on buys/sells, do not take on wallet transfers
1006         if(takeFee){
1007             // on sell
1008             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1009                 fees = amount * sellTotalFees/100;
1010                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1011                 tokensForDev += fees * sellDevFee / sellTotalFees;
1012                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1013             }
1014             // on buy
1015             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1016         	    fees = amount * buyTotalFees/100;
1017         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1018                 tokensForDev += fees * buyDevFee / buyTotalFees;
1019                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1020             }
1021             
1022             if(fees > 0){    
1023                 super._transfer(from, address(this), fees);
1024             }
1025         	
1026         	amount -= fees;
1027         }
1028 
1029         super._transfer(from, to, amount);
1030     }
1031 
1032     function swapTokensForEth(uint256 tokenAmount) private {
1033 
1034         // generate the uniswap pair path of token -> weth
1035         address[] memory path = new address[](2);
1036         path[0] = address(this);
1037         path[1] = uniswapV2Router.WETH();
1038 
1039         _approve(address(this), address(uniswapV2Router), tokenAmount);
1040 
1041         // make the swap
1042         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1043             tokenAmount,
1044             0, // accept any amount of ETH
1045             path,
1046             address(this),
1047             block.timestamp
1048         );
1049         
1050     }
1051     
1052     
1053     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1054         // approve token transfer to cover all possible scenarios
1055         _approve(address(this), address(uniswapV2Router), tokenAmount);
1056 
1057         // add the liquidity
1058         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1059             address(this),
1060             tokenAmount,
1061             0, // slippage is unavoidable
1062             0, // slippage is unavoidable
1063             deadAddress,
1064             block.timestamp
1065         );
1066     }
1067 
1068     function swapBack() private {
1069         uint256 contractBalance = balanceOf(address(this));
1070         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1071         bool success;
1072         
1073         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1074 
1075         if(contractBalance > swapTokensAtAmount * 20){
1076           contractBalance = swapTokensAtAmount * 20;
1077         }
1078         
1079         // Halve the amount of liquidity tokens
1080         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1081         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1082         
1083         uint256 initialETHBalance = address(this).balance;
1084 
1085         swapTokensForEth(amountToSwapForETH); 
1086         
1087         uint256 ethBalance = address(this).balance - initialETHBalance;
1088         
1089         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1090         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1091         
1092         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1093         
1094         tokensForLiquidity = 0;
1095         tokensForMarketing = 0;
1096         tokensForDev = 0;
1097         
1098         (success,) = address(devWallet).call{value: ethForDev}("");
1099         
1100         if(liquidityTokens > 0 && ethForLiquidity > 0){
1101             addLiquidity(liquidityTokens, ethForLiquidity);
1102         }
1103         
1104         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1105     }
1106 
1107     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1108         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1109         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1110         lastManualLpBurnTime = block.timestamp;
1111         
1112         // get balance of liquidity pair
1113         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1114         
1115         // calculate amount to burn
1116         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1117         
1118         
1119         if (amountToBurn > 0){
1120             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1121         }
1122         
1123         //sync price since this is not in a swap transaction!
1124         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1125         pair.sync();
1126         return true;
1127     }
1128 }