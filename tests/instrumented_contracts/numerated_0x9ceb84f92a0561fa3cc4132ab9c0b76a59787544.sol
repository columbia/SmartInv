1 pragma solidity ^0.7.0;
2 
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 library SafeMath {
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      *
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 contract ERC20 is Context, IERC20 {
231     using SafeMath for uint256;
232 
233     mapping (address => uint256) private _balances;
234 
235     mapping (address => mapping (address => uint256)) private _allowances;
236 
237     uint256 private _totalSupply;
238 
239     string private _name;
240     string private _symbol;
241     uint8 private _decimals;
242 
243     /**
244      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
245      * a default value of 18.
246      *
247      * To select a different value for {decimals}, use {_setupDecimals}.
248      *
249      * All three of these values are immutable: they can only be set once during
250      * construction.
251      */
252     constructor (string memory name, string memory symbol) public {
253         _name = name;
254         _symbol = symbol;
255         _decimals = 18;
256     }
257 
258     /**
259      * @dev Returns the name of the token.
260      */
261     function name() public view returns (string memory) {
262         return _name;
263     }
264 
265     /**
266      * @dev Returns the symbol of the token, usually a shorter version of the
267      * name.
268      */
269     function symbol() public view returns (string memory) {
270         return _symbol;
271     }
272 
273     /**
274      * @dev Returns the number of decimals used to get its user representation.
275      * For example, if `decimals` equals `2`, a balance of `505` tokens should
276      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
277      *
278      * Tokens usually opt for a value of 18, imitating the relationship between
279      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
280      * called.
281      *
282      * NOTE: This information is only used for _display_ purposes: it in
283      * no way affects any of the arithmetic of the contract, including
284      * {IERC20-balanceOf} and {IERC20-transfer}.
285      */
286     function decimals() public view returns (uint8) {
287         return _decimals;
288     }
289 
290     /**
291      * @dev See {IERC20-totalSupply}.
292      */
293     function totalSupply() public view override returns (uint256) {
294         return _totalSupply;
295     }
296 
297     /**
298      * @dev See {IERC20-balanceOf}.
299      */
300     function balanceOf(address account) public view override returns (uint256) {
301         return _balances[account];
302     }
303 
304     /**
305      * @dev See {IERC20-transfer}.
306      *
307      * Requirements:
308      *
309      * - `recipient` cannot be the zero address.
310      * - the caller must have a balance of at least `amount`.
311      */
312     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
313         _transfer(_msgSender(), recipient, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-allowance}.
319      */
320     function allowance(address owner, address spender) public view virtual override returns (uint256) {
321         return _allowances[owner][spender];
322     }
323 
324     /**
325      * @dev See {IERC20-approve}.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function approve(address spender, uint256 amount) public virtual override returns (bool) {
332         _approve(_msgSender(), spender, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-transferFrom}.
338      *
339      * Emits an {Approval} event indicating the updated allowance. This is not
340      * required by the EIP. See the note at the beginning of {ERC20}.
341      *
342      * Requirements:
343      *
344      * - `sender` and `recipient` cannot be the zero address.
345      * - `sender` must have a balance of at least `amount`.
346      * - the caller must have allowance for ``sender``'s tokens of at least
347      * `amount`.
348      */
349     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
350         _transfer(sender, recipient, amount);
351         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
352         return true;
353     }
354 
355     /**
356      * @dev Atomically increases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to {approve} that can be used as a mitigation for
359      * problems described in {IERC20-approve}.
360      *
361      * Emits an {Approval} event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
368         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
369         return true;
370     }
371 
372     /**
373      * @dev Atomically decreases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to {approve} that can be used as a mitigation for
376      * problems described in {IERC20-approve}.
377      *
378      * Emits an {Approval} event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      * - `spender` must have allowance for the caller of at least
384      * `subtractedValue`.
385      */
386     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
387         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
388         return true;
389     }
390 
391     /**
392      * @dev Moves tokens `amount` from `sender` to `recipient`.
393      *
394      * This is internal function is equivalent to {transfer}, and can be used to
395      * e.g. implement automatic token fees, slashing mechanisms, etc.
396      *
397      * Emits a {Transfer} event.
398      *
399      * Requirements:
400      *
401      * - `sender` cannot be the zero address.
402      * - `recipient` cannot be the zero address.
403      * - `sender` must have a balance of at least `amount`.
404      */
405     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
406         require(sender != address(0), "ERC20: transfer from the zero address");
407         require(recipient != address(0), "ERC20: transfer to the zero address");
408 
409         _beforeTokenTransfer(sender, recipient, amount);
410 
411         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
412         _balances[recipient] = _balances[recipient].add(amount);
413         emit Transfer(sender, recipient, amount);
414     }
415 
416     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
417      * the total supply.
418      *
419      * Emits a {Transfer} event with `from` set to the zero address.
420      *
421      * Requirements:
422      *
423      * - `to` cannot be the zero address.
424      */
425     function _mint(address account, uint256 amount) internal virtual {
426         require(account != address(0), "ERC20: mint to the zero address");
427 
428         _beforeTokenTransfer(address(0), account, amount);
429 
430         _totalSupply = _totalSupply.add(amount);
431         _balances[account] = _balances[account].add(amount);
432         emit Transfer(address(0), account, amount);
433     }
434 
435     /**
436      * @dev Destroys `amount` tokens from `account`, reducing the
437      * total supply.
438      *
439      * Emits a {Transfer} event with `to` set to the zero address.
440      *
441      * Requirements:
442      *
443      * - `account` cannot be the zero address.
444      * - `account` must have at least `amount` tokens.
445      */
446     function _burn(address account, uint256 amount) internal virtual {
447         require(account != address(0), "ERC20: burn from the zero address");
448 
449         _beforeTokenTransfer(account, address(0), amount);
450 
451         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
452         _totalSupply = _totalSupply.sub(amount);
453         emit Transfer(account, address(0), amount);
454     }
455 
456     /**
457      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
458      *
459      * This internal function is equivalent to `approve`, and can be used to
460      * e.g. set automatic allowances for certain subsystems, etc.
461      *
462      * Emits an {Approval} event.
463      *
464      * Requirements:
465      *
466      * - `owner` cannot be the zero address.
467      * - `spender` cannot be the zero address.
468      */
469     function _approve(address owner, address spender, uint256 amount) internal virtual {
470         require(owner != address(0), "ERC20: approve from the zero address");
471         require(spender != address(0), "ERC20: approve to the zero address");
472 
473         _allowances[owner][spender] = amount;
474         emit Approval(owner, spender, amount);
475     }
476 
477     /**
478      * @dev Sets {decimals} to a value other than the default one of 18.
479      *
480      * WARNING: This function should only be called from the constructor. Most
481      * applications that interact with token contracts will not expect
482      * {decimals} to ever change, and may work incorrectly if it does.
483      */
484     function _setupDecimals(uint8 decimals_) internal {
485         _decimals = decimals_;
486     }
487 
488     /**
489      * @dev Hook that is called before any transfer of tokens. This includes
490      * minting and burning.
491      *
492      * Calling conditions:
493      *
494      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
495      * will be to transferred to `to`.
496      * - when `from` is zero, `amount` tokens will be minted for `to`.
497      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
498      * - `from` and `to` are never both zero.
499      *
500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
501      */
502     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
503 }
504 
505 
506 contract Ownable is Context {
507     address private _owner;
508 
509     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
510 
511     /**
512      * @dev Initializes the contract setting the deployer as the initial owner.
513      */
514     constructor () {
515         address msgSender = _msgSender();
516         _owner = msgSender;
517         emit OwnershipTransferred(address(0), msgSender);
518     }
519 
520     /**
521      * @dev Returns the address of the current owner.
522      */
523     function owner() public view returns (address) {
524         return _owner;
525     }
526 
527     /**
528      * @dev Throws if called by any account other than the owner.
529      */
530     modifier onlyOwner() {
531         require(_owner == _msgSender(), "Ownable: caller is not the owner");
532         _;
533     }
534 
535     /**
536      * @dev Leaves the contract without owner. It will not be possible to call
537      * `onlyOwner` functions anymore. Can only be called by the current owner.
538      *
539      * NOTE: Renouncing ownership will leave the contract without an owner,
540      * thereby removing any functionality that is only available to the owner.
541      */
542     function renounceOwnership() public virtual onlyOwner {
543         emit OwnershipTransferred(_owner, address(0));
544         _owner = address(0);
545     }
546 
547     /**
548      * @dev Transfers ownership of the contract to a new account (`newOwner`).
549      * Can only be called by the current owner.
550      */
551     function transferOwnership(address newOwner) public virtual onlyOwner {
552         require(newOwner != address(0), "Ownable: new owner is the zero address");
553         emit OwnershipTransferred(_owner, newOwner);
554         _owner = newOwner;
555     }
556 }
557 
558 contract DokiCoinCore is ERC20("DokiDokiFinance", "DOKI"), Ownable {
559     using SafeMath for uint256;
560 
561     address internal _taxer;
562     address internal _taxDestination;
563     uint internal _taxRate = 0;
564     bool internal _lock = true;
565     mapping (address => bool) internal _taxWhitelist;
566 
567     function transfer(address recipient, uint256 amount) public override returns (bool) {
568         require(msg.sender == owner() || !_lock, "Transfer is locking");
569 
570         uint256 taxAmount = amount.mul(_taxRate).div(100);
571         if (_taxWhitelist[msg.sender] == true) {
572             taxAmount = 0;
573         }
574         uint256 transferAmount = amount.sub(taxAmount);
575         require(balanceOf(msg.sender) >= amount, "insufficient balance.");
576         super.transfer(recipient, transferAmount);
577 
578         if (taxAmount != 0) {
579             super.transfer(_taxDestination, taxAmount);
580         }
581         return true;
582     }
583 
584     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
585         require(sender == owner() || !_lock, "TransferFrom is locking");
586 
587         uint256 taxAmount = amount.mul(_taxRate).div(100);
588         if (_taxWhitelist[sender] == true) {
589             taxAmount = 0;
590         }
591         uint256 transferAmount = amount.sub(taxAmount);
592         require(balanceOf(sender) >= amount, "insufficient balance.");
593         super.transferFrom(sender, recipient, transferAmount);
594         if (taxAmount != 0) {
595             super.transferFrom(sender, _taxDestination, taxAmount);
596         }
597         return true;
598     }
599 }
600 
601 
602 contract DokiCoin is DokiCoinCore {
603     mapping (address => bool) public minters;
604 
605     constructor() {
606         _taxer = owner();
607         _taxDestination = owner();
608     }
609 
610     function mint(address to, uint amount) public onlyMinter {
611         _mint(to, amount);
612     }
613 
614     function burn(uint amount) public {
615         require(amount > 0);
616         require(balanceOf(msg.sender) >= amount);
617         _burn(msg.sender, amount);
618     }
619 
620     function addMinter(address account) public onlyOwner {
621         minters[account] = true;
622     }
623 
624     function removeMinter(address account) public onlyOwner {
625         minters[account] = false;
626     }
627 
628     modifier onlyMinter() {
629         require(minters[msg.sender], "Restricted to minters.");
630         _;
631     }
632 
633     modifier onlyTaxer() {
634         require(msg.sender == _taxer, "Only for taxer.");
635         _;
636     }
637 
638     function setTaxer(address account) public onlyTaxer {
639         _taxer = account;
640     }
641 
642     function setTaxRate(uint256 rate) public onlyTaxer {
643         _taxRate = rate;
644     }
645 
646     function setTaxDestination(address account) public onlyTaxer {
647         _taxDestination = account;
648     }
649 
650     function addToWhitelist(address account) public onlyTaxer {
651         _taxWhitelist[account] = true;
652     }
653 
654     function removeFromWhitelist(address account) public onlyTaxer {
655         _taxWhitelist[account] = false;
656     }
657 
658     function taxer() public view returns(address) {
659         return _taxer;
660     }
661 
662     function taxDestination() public view returns(address) {
663         return _taxDestination;
664     }
665 
666     function taxRate() public view returns(uint256) {
667         return _taxRate;
668     }
669 
670     function isInWhitelist(address account) public view returns(bool) {
671         return _taxWhitelist[account];
672     }
673 
674     function unlock() public onlyOwner {
675         _lock = false;
676     }
677 
678     function getLockStatus() view public returns(bool) {
679         return _lock;
680     }
681 }