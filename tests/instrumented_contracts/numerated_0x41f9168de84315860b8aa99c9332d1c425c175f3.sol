1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, with an overflow flag.
8      *
9      * _Available since v3.4._
10      */
11     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
12         uint256 c = a + b;
13         if (c < a) return (false, 0);
14         return (true, c);
15     }
16 
17     /**
18      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
19      *
20      * _Available since v3.4._
21      */
22     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         if (b > a) return (false, 0);
24         return (true, a - b);
25     }
26 
27     /**
28      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
36         if (a == 0) return (true, 0);
37         uint256 c = a * b;
38         if (c / a != b) return (false, 0);
39         return (true, c);
40     }
41 
42     /**
43      * @dev Returns the division of two unsigned integers, with a division by zero flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         if (b == 0) return (false, 0);
49         return (true, a / b);
50     }
51 
52     /**
53      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
54      *
55      * _Available since v3.4._
56      */
57     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         if (b == 0) return (false, 0);
59         return (true, a % b);
60     }
61 
62     /**
63      * @dev Returns the addition of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `+` operator.
67      *
68      * Requirements:
69      *
70      * - Addition cannot overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         return c;
76     }
77 
78     /**
79      * @dev Returns the subtraction of two unsigned integers, reverting on
80      * overflow (when the result is negative).
81      *
82      * Counterpart to Solidity's `-` operator.
83      *
84      * Requirements:
85      *
86      * - Subtraction cannot overflow.
87      */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b <= a, "SafeMath: subtraction overflow");
90         return a - b;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      *
101      * - Multiplication cannot overflow.
102      */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) return 0;
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107         return c;
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers, reverting on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         require(b > 0, "SafeMath: division by zero");
124         return a / b;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * reverting when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b > 0, "SafeMath: modulo by zero");
141         return a % b;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * CAUTION: This function is deprecated because it requires allocating memory for the error
149      * message unnecessarily. For custom revert reasons use {trySub}.
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         return a - b;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
164      * division by zero. The result is rounded towards zero.
165      *
166      * CAUTION: This function is deprecated because it requires allocating memory for the error
167      * message unnecessarily. For custom revert reasons use {tryDiv}.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b > 0, errorMessage);
179         return a / b;
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * reverting with custom message when dividing by zero.
185      *
186      * CAUTION: This function is deprecated because it requires allocating memory for the error
187      * message unnecessarily. For custom revert reasons use {tryMod}.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         return a % b;
200     }
201 }
202 
203 interface IERC20 {
204     /**
205      * @dev Returns the amount of tokens in existence.
206      */
207     function totalSupply() external view returns (uint256);
208 
209     /**
210      * @dev Returns the amount of tokens owned by `account`.
211      */
212     function balanceOf(address account) external view returns (uint256);
213 
214     /**
215      * @dev Moves `amount` tokens from the caller's account to `recipient`.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transfer(address recipient, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Returns the remaining number of tokens that `spender` will be
225      * allowed to spend on behalf of `owner` through {transferFrom}. This is
226      * zero by default.
227      *
228      * This value changes when {approve} or {transferFrom} are called.
229      */
230     function allowance(address owner, address spender) external view returns (uint256);
231 
232     /**
233      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * IMPORTANT: Beware that changing an allowance with this method brings the risk
238      * that someone may use both the old and the new allowance by unfortunate
239      * transaction ordering. One possible solution to mitigate this race
240      * condition is to first reduce the spender's allowance to 0 and set the
241      * desired value afterwards:
242      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243      *
244      * Emits an {Approval} event.
245      */
246     function approve(address spender, uint256 amount) external returns (bool);
247 
248     /**
249      * @dev Moves `amount` tokens from `sender` to `recipient` using the
250      * allowance mechanism. `amount` is then deducted from the caller's
251      * allowance.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Emitted when `value` tokens are moved from one account (`from`) to
261      * another (`to`).
262      *
263      * Note that `value` may be zero.
264      */
265     event Transfer(address indexed from, address indexed to, uint256 value);
266 
267     /**
268      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
269      * a call to {approve}. `value` is the new allowance.
270      */
271     event Approval(address indexed owner, address indexed spender, uint256 value);
272 }
273 
274 abstract contract Context {
275     function _msgSender() internal view virtual returns (address payable) {
276         return msg.sender;
277     }
278 
279     function _msgData() internal view virtual returns (bytes memory) {
280         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
281         return msg.data;
282     }
283 }
284 
285 abstract contract Ownable is Context {
286     address private _owner;
287 
288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290     /**
291      * @dev Initializes the contract setting the deployer as the initial owner.
292      */
293     constructor () internal {
294         address msgSender = _msgSender();
295         _owner = msgSender;
296         emit OwnershipTransferred(address(0), msgSender);
297     }
298 
299     /**
300      * @dev Returns the address of the current owner.
301      */
302     function owner() public view virtual returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if called by any account other than the owner.
308      */
309     modifier onlyOwner() {
310         require(owner() == _msgSender(), "Ownable: caller is not the owner");
311         _;
312     }
313 
314     /**
315      * @dev Leaves the contract without owner. It will not be possible to call
316      * `onlyOwner` functions anymore. Can only be called by the current owner.
317      *
318      * NOTE: Renouncing ownership will leave the contract without an owner,
319      * thereby removing any functionality that is only available to the owner.
320      */
321     function renounceOwnership() public virtual onlyOwner {
322         emit OwnershipTransferred(_owner, address(0));
323         _owner = address(0);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Can only be called by the current owner.
329      */
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         emit OwnershipTransferred(_owner, newOwner);
333         _owner = newOwner;
334     }
335 }
336 
337 contract ERC20 is Context, IERC20 {
338     using SafeMath for uint256;
339 
340     mapping (address => uint256) private _balances;
341 
342     mapping (address => mapping (address => uint256)) private _allowances;
343 
344     uint256 private _totalSupply;
345 
346     string private _name;
347     string private _symbol;
348     uint8 private _decimals;
349 
350     /**
351      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
352      * a default value of 18.
353      *
354      * To select a different value for {decimals}, use {_setupDecimals}.
355      *
356      * All three of these values are immutable: they can only be set once during
357      * construction.
358      */
359     constructor (string memory name_, string memory symbol_) public {
360         _name = name_;
361         _symbol = symbol_;
362         _decimals = 18;
363     }
364 
365     /**
366      * @dev Returns the name of the token.
367      */
368     function name() public view virtual returns (string memory) {
369         return _name;
370     }
371 
372     /**
373      * @dev Returns the symbol of the token, usually a shorter version of the
374      * name.
375      */
376     function symbol() public view virtual returns (string memory) {
377         return _symbol;
378     }
379 
380     /**
381      * @dev Returns the number of decimals used to get its user representation.
382      * For example, if `decimals` equals `2`, a balance of `505` tokens should
383      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
384      *
385      * Tokens usually opt for a value of 18, imitating the relationship between
386      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
387      * called.
388      *
389      * NOTE: This information is only used for _display_ purposes: it in
390      * no way affects any of the arithmetic of the contract, including
391      * {IERC20-balanceOf} and {IERC20-transfer}.
392      */
393     function decimals() public view virtual returns (uint8) {
394         return _decimals;
395     }
396 
397     /**
398      * @dev See {IERC20-totalSupply}.
399      */
400     function totalSupply() public view virtual override returns (uint256) {
401         return _totalSupply;
402     }
403 
404     /**
405      * @dev See {IERC20-balanceOf}.
406      */
407     function balanceOf(address account) public view virtual override returns (uint256) {
408         return _balances[account];
409     }
410 
411     /**
412      * @dev See {IERC20-transfer}.
413      *
414      * Requirements:
415      *
416      * - `recipient` cannot be the zero address.
417      * - the caller must have a balance of at least `amount`.
418      */
419     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
420         _transfer(_msgSender(), recipient, amount);
421         return true;
422     }
423 
424     /**
425      * @dev See {IERC20-allowance}.
426      */
427     function allowance(address owner, address spender) public view virtual override returns (uint256) {
428         return _allowances[owner][spender];
429     }
430 
431     /**
432      * @dev See {IERC20-approve}.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      */
438     function approve(address spender, uint256 amount) public virtual override returns (bool) {
439         _approve(_msgSender(), spender, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-transferFrom}.
445      *
446      * Emits an {Approval} event indicating the updated allowance. This is not
447      * required by the EIP. See the note at the beginning of {ERC20}.
448      *
449      * Requirements:
450      *
451      * - `sender` and `recipient` cannot be the zero address.
452      * - `sender` must have a balance of at least `amount`.
453      * - the caller must have allowance for ``sender``'s tokens of at least
454      * `amount`.
455      */
456     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
457         _transfer(sender, recipient, amount);
458         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
459         return true;
460     }
461 
462     /**
463      * @dev Atomically increases the allowance granted to `spender` by the caller.
464      *
465      * This is an alternative to {approve} that can be used as a mitigation for
466      * problems described in {IERC20-approve}.
467      *
468      * Emits an {Approval} event indicating the updated allowance.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      */
474     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
475         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
476         return true;
477     }
478 
479     /**
480      * @dev Atomically decreases the allowance granted to `spender` by the caller.
481      *
482      * This is an alternative to {approve} that can be used as a mitigation for
483      * problems described in {IERC20-approve}.
484      *
485      * Emits an {Approval} event indicating the updated allowance.
486      *
487      * Requirements:
488      *
489      * - `spender` cannot be the zero address.
490      * - `spender` must have allowance for the caller of at least
491      * `subtractedValue`.
492      */
493     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
494         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
495         return true;
496     }
497 
498     /**
499      * @dev Moves tokens `amount` from `sender` to `recipient`.
500      *
501      * This is internal function is equivalent to {transfer}, and can be used to
502      * e.g. implement automatic token fees, slashing mechanisms, etc.
503      *
504      * Emits a {Transfer} event.
505      *
506      * Requirements:
507      *
508      * - `sender` cannot be the zero address.
509      * - `recipient` cannot be the zero address.
510      * - `sender` must have a balance of at least `amount`.
511      */
512     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
513         require(sender != address(0), "ERC20: transfer from the zero address");
514         require(recipient != address(0), "ERC20: transfer to the zero address");
515 
516         _beforeTokenTransfer(sender, recipient, amount);
517 
518         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
519         _balances[recipient] = _balances[recipient].add(amount);
520         emit Transfer(sender, recipient, amount);
521     }
522 
523     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
524      * the total supply.
525      *
526      * Emits a {Transfer} event with `from` set to the zero address.
527      *
528      * Requirements:
529      *
530      * - `to` cannot be the zero address.
531      */
532     function _mint(address account, uint256 amount) internal virtual {
533         require(account != address(0), "ERC20: mint to the zero address");
534 
535         _beforeTokenTransfer(address(0), account, amount);
536 
537         _totalSupply = _totalSupply.add(amount);
538         _balances[account] = _balances[account].add(amount);
539         emit Transfer(address(0), account, amount);
540     }
541 
542     /**
543      * @dev Destroys `amount` tokens from `account`, reducing the
544      * total supply.
545      *
546      * Emits a {Transfer} event with `to` set to the zero address.
547      *
548      * Requirements:
549      *
550      * - `account` cannot be the zero address.
551      * - `account` must have at least `amount` tokens.
552      */
553     function _burn(address account, uint256 amount) internal virtual {
554         require(account != address(0), "ERC20: burn from the zero address");
555 
556         _beforeTokenTransfer(account, address(0), amount);
557 
558         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
559         _totalSupply = _totalSupply.sub(amount);
560         emit Transfer(account, address(0), amount);
561     }
562 
563     /**
564      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
565      *
566      * This internal function is equivalent to `approve`, and can be used to
567      * e.g. set automatic allowances for certain subsystems, etc.
568      *
569      * Emits an {Approval} event.
570      *
571      * Requirements:
572      *
573      * - `owner` cannot be the zero address.
574      * - `spender` cannot be the zero address.
575      */
576     function _approve(address owner, address spender, uint256 amount) internal virtual {
577         require(owner != address(0), "ERC20: approve from the zero address");
578         require(spender != address(0), "ERC20: approve to the zero address");
579 
580         _allowances[owner][spender] = amount;
581         emit Approval(owner, spender, amount);
582     }
583 
584     /**
585      * @dev Sets {decimals} to a value other than the default one of 18.
586      *
587      * WARNING: This function should only be called from the constructor. Most
588      * applications that interact with token contracts will not expect
589      * {decimals} to ever change, and may work incorrectly if it does.
590      */
591     function _setupDecimals(uint8 decimals_) internal virtual {
592         _decimals = decimals_;
593     }
594 
595     /**
596      * @dev Hook that is called before any transfer of tokens. This includes
597      * minting and burning.
598      *
599      * Calling conditions:
600      *
601      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
602      * will be to transferred to `to`.
603      * - when `from` is zero, `amount` tokens will be minted for `to`.
604      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
605      * - `from` and `to` are never both zero.
606      *
607      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
608      */
609     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
610 }
611 
612 abstract contract ERC20Capped is ERC20 {
613     using SafeMath for uint256;
614 
615     uint256 private _cap;
616 
617     /**
618      * @dev Sets the value of the `cap`. This value is immutable, it can only be
619      * set once during construction.
620      */
621     constructor (uint256 cap_) internal {
622         require(cap_ > 0, "ERC20Capped: cap is 0");
623         _cap = cap_;
624     }
625 
626     /**
627      * @dev Returns the cap on the token's total supply.
628      */
629     function cap() public view virtual returns (uint256) {
630         return _cap;
631     }
632 
633     /**
634      * @dev See {ERC20-_beforeTokenTransfer}.
635      *
636      * Requirements:
637      *
638      * - minted tokens must not cause the total supply to go over the cap.
639      */
640     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
641         super._beforeTokenTransfer(from, to, amount);
642 
643         if (from == address(0)) { // When minting tokens
644             require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
645         }
646     }
647 }
648 
649 abstract contract ERC20Burnable is Context, ERC20 {
650     using SafeMath for uint256;
651 
652     /**
653      * @dev Destroys `amount` tokens from the caller.
654      *
655      * See {ERC20-_burn}.
656      */
657     function burn(uint256 amount) public virtual {
658         _burn(_msgSender(), amount);
659     }
660 
661     /**
662      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
663      * allowance.
664      *
665      * See {ERC20-_burn} and {ERC20-allowance}.
666      *
667      * Requirements:
668      *
669      * - the caller must have allowance for ``accounts``'s tokens of at least
670      * `amount`.
671      */
672     function burnFrom(address account, uint256 amount) public virtual {
673         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
674 
675         _approve(account, _msgSender(), decreasedAllowance);
676         _burn(account, amount);
677     }
678 }
679 
680 
681 
682 abstract contract ERC20Mintable is ERC20 {
683 
684     // indicates if minting is finished
685     bool private _mintingFinished = false;
686 
687     /**
688      * @dev Emitted during finish minting
689      */
690     event MintFinished();
691 
692     /**
693      * @dev Tokens can be minted only before minting finished.
694      */
695     modifier canMint() {
696         require(!_mintingFinished, "ERC20Mintable: minting is finished");
697         _;
698     }
699 
700     /**
701      * @return if minting is finished or not.
702      */
703     function mintingFinished() public view returns (bool) {
704         return _mintingFinished;
705     }
706 
707     /**
708      * @dev Function to mint tokens.
709      *
710      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
711      *
712      * @param account The address that will receive the minted tokens
713      * @param amount The amount of tokens to mint
714      */
715     function mint(address account, uint256 amount) public canMint {
716         _mint(account, amount);
717     }
718 
719     /**
720      * @dev Function to stop minting new tokens.
721      *
722      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
723      */
724     function finishMinting() public canMint {
725         _finishMinting();
726     }
727 
728     /**
729      * @dev Function to stop minting new tokens.
730      */
731     function _finishMinting() internal virtual {
732         _mintingFinished = true;
733 
734         emit MintFinished();
735     }
736 }
737 
738 
739 /**
740  * @title CommonERC20
741  * @dev Implementation of the CommonERC20
742  */
743 contract CommonERC20 is ERC20Capped, ERC20Mintable, ERC20Burnable, Ownable {
744     
745       mapping(uint256 => bool) public  uniqueIdExists;
746       bytes32 public immutable DOMAIN_SEPARATOR;
747 
748       constructor (
749         string memory name,
750         string memory symbol,
751         uint8 decimals,
752         uint256 cap,
753         uint256 initialBalance
754     )
755         public 
756         ERC20(name, symbol)
757         ERC20Capped(cap)
758 
759         payable
760     {
761         _setupDecimals(decimals);
762         _mint(_msgSender(), initialBalance);
763         
764         uint256 chainId;
765         
766         assembly {
767             chainId := chainid()
768         }
769         
770         DOMAIN_SEPARATOR = keccak256(
771             abi.encode(
772                 keccak256(bytes(name)),
773                 keccak256(bytes(version())),
774                 chainId,
775                 address(this)
776             )
777         );
778 
779     }
780     
781     function version() public pure virtual returns(string memory) { return "1"; }
782 
783     /**
784      * @dev Function to mint tokens.
785      *
786      * NOTE: restricting access to owner only. See {ERC20Mintable-mint}.
787      *
788      * @param account The address that will receive the minted tokens
789      * @param amount The amount of tokens to mint
790      */
791     function _mint(address account, uint256 amount) internal override onlyOwner {
792         super._mint(account, amount);
793     }
794 
795     /**
796      * @dev Function to stop minting new tokens.
797      *
798      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
799      */
800     function _finishMinting() internal override onlyOwner {
801         super._finishMinting();
802     }
803 
804     /**
805      * @dev See {ERC20-_beforeTokenTransfer}. See {ERC20Capped-_beforeTokenTransfer}.
806      */
807     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Capped) {
808         super._beforeTokenTransfer(from, to, amount);
809     }
810     
811     function permitMint(address recipient, uint256 uniqueId, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual  {
812         
813         require(deadline >= block.timestamp, "Expired deadline");
814         require(!uniqueIdExists[uniqueId], "Unique id exists");
815         
816         address spender = msg.sender;
817         address owner = super.owner();
818        
819         bytes32 permitTxHash = keccak256(
820             abi.encode(
821                 owner,
822                 spender,
823                 recipient,
824                 amount,
825                 uniqueId,
826                 deadline
827             )
828         );
829         
830         bytes32 digest = keccak256(
831             abi.encode(
832                 DOMAIN_SEPARATOR,
833                 permitTxHash
834             )
835         );
836 
837         address signer = ecrecover(digest, v, r, s);
838         require(
839             signer != address(0) && signer == owner,
840             "Invalid signature"
841         );
842         
843         uniqueIdExists[uniqueId] = true;
844         super._mint(recipient, amount);
845         
846     }
847 }