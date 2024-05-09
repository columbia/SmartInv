1 /*
2 Website: cattoken.vip
3 
4 Twitter: https://twitter.com/cattokenerc
5 
6 Telegram: t.me/cattokenerc
7 */
8 
9 // SPDX-License-Identifier: MIT                                                                               
10                                                     
11 pragma solidity 0.8.9;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     using SafeMath for uint256;
119 
120     mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 private _totalSupply;
125 
126     string private _name;
127     string private _symbol;
128 
129     /**
130      * @dev Sets the values for {name} and {symbol}.
131      *
132      * The default value of {decimals} is 18. To select a different value for
133      * {decimals} you should overload it.
134      *
135      * All two of these values are immutable: they can only be set once during
136      * construction.
137      */
138     constructor(string memory name_, string memory symbol_) {
139         _name = name_;
140         _symbol = symbol_;
141     }
142 
143     /**
144      * @dev Returns the name of the token.
145      */
146     function name() public view virtual override returns (string memory) {
147         return _name;
148     }
149 
150     /**
151      * @dev Returns the symbol of the token, usually a shorter version of the
152      * name.
153      */
154     function symbol() public view virtual override returns (string memory) {
155         return _symbol;
156     }
157 
158     /**
159      * @dev Returns the number of decimals used to get its user representation.
160      * For example, if `decimals` equals `2`, a balance of `505` tokens should
161      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
162      *
163      * Tokens usually opt for a value of 18, imitating the relationship between
164      * Ether and Wei. This is the value {ERC20} uses, unless this function is
165      * overridden;
166      *
167      * NOTE: This information is only used for _display_ purposes: it in
168      * no way affects any of the arithmetic of the contract, including
169      * {IERC20-balanceOf} and {IERC20-transfer}.
170      */
171     function decimals() public view virtual override returns (uint8) {
172         return 18;
173     }
174 
175     /**
176      * @dev See {IERC20-totalSupply}.
177      */
178     function totalSupply() public view virtual override returns (uint256) {
179         return _totalSupply;
180     }
181 
182     /**
183      * @dev See {IERC20-balanceOf}.
184      */
185     function balanceOf(address account) public view virtual override returns (uint256) {
186         return _balances[account];
187     }
188 
189     /**
190      * @dev See {IERC20-transfer}.
191      *
192      * Requirements:
193      *
194      * - `recipient` cannot be the zero address.
195      * - the caller must have a balance of at least `amount`.
196      */
197     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     /**
203      * @dev See {IERC20-allowance}.
204      */
205     function allowance(address owner, address spender) public view virtual override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     /**
210      * @dev See {IERC20-approve}.
211      *
212      * Requirements:
213      *
214      * - `spender` cannot be the zero address.
215      */
216     function approve(address spender, uint256 amount) public virtual override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     /**
222      * @dev See {IERC20-transferFrom}.
223      *
224      * Emits an {Approval} event indicating the updated allowance. This is not
225      * required by the EIP. See the note at the beginning of {ERC20}.
226      *
227      * Requirements:
228      *
229      * - `sender` and `recipient` cannot be the zero address.
230      * - `sender` must have a balance of at least `amount`.
231      * - the caller must have allowance for ``sender``'s tokens of at least
232      * `amount`.
233      */
234     function transferFrom(
235         address sender,
236         address recipient,
237         uint256 amount
238     ) public virtual override returns (bool) {
239         _transfer(sender, recipient, amount);
240         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
241         return true;
242     }
243 
244     /**
245      * @dev Atomically increases the allowance granted to `spender` by the caller.
246      *
247      * This is an alternative to {approve} that can be used as a mitigation for
248      * problems described in {IERC20-approve}.
249      *
250      * Emits an {Approval} event indicating the updated allowance.
251      *
252      * Requirements:
253      *
254      * - `spender` cannot be the zero address.
255      */
256     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
257         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
258         return true;
259     }
260 
261     /**
262      * @dev Atomically decreases the allowance granted to `spender` by the caller.
263      *
264      * This is an alternative to {approve} that can be used as a mitigation for
265      * problems described in {IERC20-approve}.
266      *
267      * Emits an {Approval} event indicating the updated allowance.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      * - `spender` must have allowance for the caller of at least
273      * `subtractedValue`.
274      */
275     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
276         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
277         return true;
278     }
279 
280     /**
281      * @dev Moves tokens `amount` from `sender` to `recipient`.
282      *
283      * This is internal function is equivalent to {transfer}, and can be used to
284      * e.g. implement automatic token fees, slashing mechanisms, etc.
285      *
286      * Emits a {Transfer} event.
287      *
288      * Requirements:
289      *
290      * - `sender` cannot be the zero address.
291      * - `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `amount`.
293      */
294     function _transfer(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) internal virtual {
299         require(sender != address(0), "ERC20: transfer from the zero address");
300         require(recipient != address(0), "ERC20: transfer to the zero address");
301 
302         _beforeTokenTransfer(sender, recipient, amount);
303 
304         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
305         _balances[recipient] = _balances[recipient].add(amount);
306         emit Transfer(sender, recipient, amount);
307     }
308 
309     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
310      * the total supply.
311      *
312      * Emits a {Transfer} event with `from` set to the zero address.
313      *
314      * Requirements:
315      *
316      * - `account` cannot be the zero address.
317      */
318     function _mint(address account, uint256 amount) internal virtual {
319         require(account != address(0), "ERC20: mint to the zero address");
320 
321         _beforeTokenTransfer(address(0), account, amount);
322 
323         _totalSupply = _totalSupply.add(amount);
324         _balances[account] = _balances[account].add(amount);
325         emit Transfer(address(0), account, amount);
326     }
327 
328     /**
329      * @dev Destroys `amount` tokens from `account`, reducing the
330      * total supply.
331      *
332      * Emits a {Transfer} event with `to` set to the zero address.
333      *
334      * Requirements:
335      *
336      * - `account` cannot be the zero address.
337      * - `account` must have at least `amount` tokens.
338      */
339     function _burn(address account, uint256 amount) internal virtual {
340         require(account != address(0), "ERC20: burn from the zero address");
341 
342         _beforeTokenTransfer(account, address(0), amount);
343 
344         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
345         _totalSupply = _totalSupply.sub(amount);
346         emit Transfer(account, address(0), amount);
347     }
348 
349     /**
350      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
351      *
352      * This internal function is equivalent to `approve`, and can be used to
353      * e.g. set automatic allowances for certain subsystems, etc.
354      *
355      * Emits an {Approval} event.
356      *
357      * Requirements:
358      *
359      * - `owner` cannot be the zero address.
360      * - `spender` cannot be the zero address.
361      */
362     function _approve(
363         address owner,
364         address spender,
365         uint256 amount
366     ) internal virtual {
367         require(owner != address(0), "ERC20: approve from the zero address");
368         require(spender != address(0), "ERC20: approve to the zero address");
369 
370         _allowances[owner][spender] = amount;
371         emit Approval(owner, spender, amount);
372     }
373 
374     /**
375      * @dev Hook that is called before any transfer of tokens. This includes
376      * minting and burning.
377      *
378      * Calling conditions:
379      *
380      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
381      * will be to transferred to `to`.
382      * - when `from` is zero, `amount` tokens will be minted for `to`.
383      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
384      * - `from` and `to` are never both zero.
385      *
386      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
387      */
388     function _beforeTokenTransfer(
389         address from,
390         address to,
391         uint256 amount
392     ) internal virtual {}
393 }
394 
395 library SafeMath {
396     /**
397      * @dev Returns the addition of two unsigned integers, reverting on
398      * overflow.
399      *
400      * Counterpart to Solidity's `+` operator.
401      *
402      * Requirements:
403      *
404      * - Addition cannot overflow.
405      */
406     function add(uint256 a, uint256 b) internal pure returns (uint256) {
407         uint256 c = a + b;
408         require(c >= a, "SafeMath: addition overflow");
409 
410         return c;
411     }
412 
413     /**
414      * @dev Returns the subtraction of two unsigned integers, reverting on
415      * overflow (when the result is negative).
416      *
417      * Counterpart to Solidity's `-` operator.
418      *
419      * Requirements:
420      *
421      * - Subtraction cannot overflow.
422      */
423     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
424         return sub(a, b, "SafeMath: subtraction overflow");
425     }
426 
427     /**
428      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
429      * overflow (when the result is negative).
430      *
431      * Counterpart to Solidity's `-` operator.
432      *
433      * Requirements:
434      *
435      * - Subtraction cannot overflow.
436      */
437     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
438         require(b <= a, errorMessage);
439         uint256 c = a - b;
440 
441         return c;
442     }
443 
444     /**
445      * @dev Returns the multiplication of two unsigned integers, reverting on
446      * overflow.
447      *
448      * Counterpart to Solidity's `*` operator.
449      *
450      * Requirements:
451      *
452      * - Multiplication cannot overflow.
453      */
454     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
455         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
456         // benefit is lost if 'b' is also tested.
457         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
458         if (a == 0) {
459             return 0;
460         }
461 
462         uint256 c = a * b;
463         require(c / a == b, "SafeMath: multiplication overflow");
464 
465         return c;
466     }
467 
468     /**
469      * @dev Returns the integer division of two unsigned integers. Reverts on
470      * division by zero. The result is rounded towards zero.
471      *
472      * Counterpart to Solidity's `/` operator. Note: this function uses a
473      * `revert` opcode (which leaves remaining gas untouched) while Solidity
474      * uses an invalid opcode to revert (consuming all remaining gas).
475      *
476      * Requirements:
477      *
478      * - The divisor cannot be zero.
479      */
480     function div(uint256 a, uint256 b) internal pure returns (uint256) {
481         return div(a, b, "SafeMath: division by zero");
482     }
483 
484     /**
485      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
486      * division by zero. The result is rounded towards zero.
487      *
488      * Counterpart to Solidity's `/` operator. Note: this function uses a
489      * `revert` opcode (which leaves remaining gas untouched) while Solidity
490      * uses an invalid opcode to revert (consuming all remaining gas).
491      *
492      * Requirements:
493      *
494      * - The divisor cannot be zero.
495      */
496     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
497         require(b > 0, errorMessage);
498         uint256 c = a / b;
499         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
500 
501         return c;
502     }
503 
504     /**
505      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
506      * Reverts when dividing by zero.
507      *
508      * Counterpart to Solidity's `%` operator. This function uses a `revert`
509      * opcode (which leaves remaining gas untouched) while Solidity uses an
510      * invalid opcode to revert (consuming all remaining gas).
511      *
512      * Requirements:
513      *
514      * - The divisor cannot be zero.
515      */
516     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
517         return mod(a, b, "SafeMath: modulo by zero");
518     }
519 
520     /**
521      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
522      * Reverts with custom message when dividing by zero.
523      *
524      * Counterpart to Solidity's `%` operator. This function uses a `revert`
525      * opcode (which leaves remaining gas untouched) while Solidity uses an
526      * invalid opcode to revert (consuming all remaining gas).
527      *
528      * Requirements:
529      *
530      * - The divisor cannot be zero.
531      */
532     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
533         require(b != 0, errorMessage);
534         return a % b;
535     }
536 }
537 
538 contract Ownable is Context {
539     address private _owner;
540 
541     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
542     
543     /**
544      * @dev Initializes the contract setting the deployer as the initial owner.
545      */
546     constructor () {
547         address msgSender = _msgSender();
548         _owner = msgSender;
549         emit OwnershipTransferred(address(0), msgSender);
550     }
551 
552     /**
553      * @dev Returns the address of the current owner.
554      */
555     function owner() public view returns (address) {
556         return _owner;
557     }
558 
559     /**
560      * @dev Throws if called by any account other than the owner.
561      */
562     modifier onlyOwner() {
563         require(_owner == _msgSender(), "Ownable: caller is not the owner");
564         _;
565     }
566 
567     /**
568      * @dev Leaves the contract without owner. It will not be possible to call
569      * `onlyOwner` functions anymore. Can only be called by the current owner.
570      *
571      * NOTE: Renouncing ownership will leave the contract without an owner,
572      * thereby removing any functionality that is only available to the owner.
573      */
574     function renounceOwnership() public virtual onlyOwner {
575         emit OwnershipTransferred(_owner, address(0));
576         _owner = address(0);
577     }
578 
579     /**
580      * @dev Transfers ownership of the contract to a new account (`newOwner`).
581      * Can only be called by the current owner.
582      */
583     function transferOwnership(address newOwner) public virtual onlyOwner {
584         require(newOwner != address(0), "Ownable: new owner is the zero address");
585         emit OwnershipTransferred(_owner, newOwner);
586         _owner = newOwner;
587     }
588 }
589 
590 contract Cat is ERC20, Ownable {
591 
592     bool tradingActive = false;
593     // exlcude from fees and max transaction amount
594     mapping (address => bool) private _isExcludedFromFees;
595 
596 
597     constructor() ERC20("Cat", "CAT") {
598         
599         address _owner = msg.sender;
600         uint256 totalSupply = 420000000 * 1e18;
601         
602         /*
603             _mint is an internal function in ERC20.sol that is only called here,
604             and CANNOT be called ever again
605         */
606         _mint(_owner, totalSupply);
607         transferOwnership(_owner);
608         excludeFromFees(_owner, true);
609     }
610 
611     function _transfer(
612         address from,
613         address to,
614         uint256 amount
615     ) internal override {
616         require(from != address(0), "ERC20: transfer from the zero address");
617         require(to != address(0), "ERC20: transfer to the zero address");
618         if(!tradingActive){
619             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
620         }
621 
622         super._transfer(from, to, amount);
623     }
624 
625     function excludeFromFees(address account, bool excluded) public onlyOwner {
626         _isExcludedFromFees[account] = excluded;
627     }
628 
629     function isExcludedFromFees(address account) external view returns(bool) {
630         return _isExcludedFromFees[account];
631     }
632 
633     // once enabled, can never be turned off
634     function enableTrading() external onlyOwner {
635         tradingActive = true;
636     }
637 
638 }