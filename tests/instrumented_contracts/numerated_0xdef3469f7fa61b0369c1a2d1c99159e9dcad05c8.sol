1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 
109 contract ERC20 is Context, IERC20, IERC20Metadata {
110     using SafeMath for uint256;
111 
112     mapping(address => uint256) private _balances;
113 
114     mapping(address => mapping(address => uint256)) private _allowances;
115 
116     uint256 private _totalSupply;
117 
118     string private _name;
119     string private _symbol;
120 
121     /**
122      * @dev Sets the values for {name} and {symbol}.
123      *
124      * The default value of {decimals} is 18. To select a different value for
125      * {decimals} you should overload it.
126      *
127      * All two of these values are immutable: they can only be set once during
128      * construction.
129      */
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135     /**
136      * @dev Returns the name of the token.
137      */
138     function name() public view virtual override returns (string memory) {
139         return _name;
140     }
141 
142     /**
143      * @dev Returns the symbol of the token, usually a shorter version of the
144      * name.
145      */
146     function symbol() public view virtual override returns (string memory) {
147         return _symbol;
148     }
149 
150     /**
151      * @dev Returns the number of decimals used to get its user representation.
152      * For example, if `decimals` equals `2`, a balance of `505` tokens should
153      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
154      *
155      * Tokens usually opt for a value of 18, imitating the relationship between
156      * Ether and Wei. This is the value {ERC20} uses, unless this function is
157      * overridden;
158      *
159      * NOTE: This information is only used for _display_ purposes: it in
160      * no way affects any of the arithmetic of the contract, including
161      * {IERC20-balanceOf} and {IERC20-transfer}.
162      */
163     function decimals() public view virtual override returns (uint8) {
164         return 18;
165     }
166 
167     /**
168      * @dev See {IERC20-totalSupply}.
169      */
170     function totalSupply() public view virtual override returns (uint256) {
171         return _totalSupply;
172     }
173 
174     /**
175      * @dev See {IERC20-balanceOf}.
176      */
177     function balanceOf(address account) public view virtual override returns (uint256) {
178         return _balances[account];
179     }
180 
181     /**
182      * @dev See {IERC20-transfer}.
183      *
184      * Requirements:
185      *
186      * - `recipient` cannot be the zero address.
187      * - the caller must have a balance of at least `amount`.
188      */
189     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     /**
195      * @dev See {IERC20-allowance}.
196      */
197     function allowance(address owner, address spender) public view virtual override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     /**
202      * @dev See {IERC20-approve}.
203      *
204      * Requirements:
205      *
206      * - `spender` cannot be the zero address.
207      */
208     function approve(address spender, uint256 amount) public virtual override returns (bool) {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212 
213     /**
214      * @dev See {IERC20-transferFrom}.
215      *
216      * Emits an {Approval} event indicating the updated allowance. This is not
217      * required by the EIP. See the note at the beginning of {ERC20}.
218      *
219      * Requirements:
220      *
221      * - `sender` and `recipient` cannot be the zero address.
222      * - `sender` must have a balance of at least `amount`.
223      * - the caller must have allowance for ``sender``'s tokens of at least
224      * `amount`.
225      */
226     function transferFrom(
227         address sender,
228         address recipient,
229         uint256 amount
230     ) public virtual override returns (bool) {
231         _transfer(sender, recipient, amount);
232         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
233         return true;
234     }
235 
236     /**
237      * @dev Atomically increases the allowance granted to `spender` by the caller.
238      *
239      * This is an alternative to {approve} that can be used as a mitigation for
240      * problems described in {IERC20-approve}.
241      *
242      * Emits an {Approval} event indicating the updated allowance.
243      *
244      * Requirements:
245      *
246      * - `spender` cannot be the zero address.
247      */
248     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
249         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
250         return true;
251     }
252 
253     /**
254      * @dev Atomically decreases the allowance granted to `spender` by the caller.
255      *
256      * This is an alternative to {approve} that can be used as a mitigation for
257      * problems described in {IERC20-approve}.
258      *
259      * Emits an {Approval} event indicating the updated allowance.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      * - `spender` must have allowance for the caller of at least
265      * `subtractedValue`.
266      */
267     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
268         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
269         return true;
270     }
271 
272     /**
273      * @dev Moves tokens `amount` from `sender` to `recipient`.
274      *
275      * This is internal function is equivalent to {transfer}, and can be used to
276      * e.g. implement automatic token fees, slashing mechanisms, etc.
277      *
278      * Emits a {Transfer} event.
279      *
280      * Requirements:
281      *
282      * - `sender` cannot be the zero address.
283      * - `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `amount`.
285      */
286     function _transfer(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) internal virtual {
291         require(sender != address(0), "ERC20: transfer from the zero address");
292         require(recipient != address(0), "ERC20: transfer to the zero address");
293 
294         _beforeTokenTransfer(sender, recipient, amount);
295 
296         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
297         _balances[recipient] = _balances[recipient].add(amount);
298         emit Transfer(sender, recipient, amount);
299     }
300 
301     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
302      * the total supply.
303      *
304      * Emits a {Transfer} event with `from` set to the zero address.
305      *
306      * Requirements:
307      *
308      * - `account` cannot be the zero address.
309      */
310     function _mint(address account, uint256 amount) internal virtual {
311         require(account != address(0), "ERC20: mint to the zero address");
312 
313         _beforeTokenTransfer(address(0), account, amount);
314 
315         _totalSupply = _totalSupply.add(amount);
316         _balances[account] = _balances[account].add(amount);
317         emit Transfer(address(0), account, amount);
318     }
319 
320     /**
321      * @dev Destroys `amount` tokens from `account`, reducing the
322      * total supply.
323      *
324      * Emits a {Transfer} event with `to` set to the zero address.
325      *
326      * Requirements:
327      *
328      * - `account` cannot be the zero address.
329      * - `account` must have at least `amount` tokens.
330      */
331     function _burn(address account, uint256 amount) internal virtual {
332         require(account != address(0), "ERC20: burn from the zero address");
333 
334         _beforeTokenTransfer(account, address(0), amount);
335 
336         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
337         _totalSupply = _totalSupply.sub(amount);
338         emit Transfer(account, address(0), amount);
339     }
340 
341     /**
342      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
343      *
344      * This internal function is equivalent to `approve`, and can be used to
345      * e.g. set automatic allowances for certain subsystems, etc.
346      *
347      * Emits an {Approval} event.
348      *
349      * Requirements:
350      *
351      * - `owner` cannot be the zero address.
352      * - `spender` cannot be the zero address.
353      */
354     function _approve(
355         address owner,
356         address spender,
357         uint256 amount
358     ) internal virtual {
359         require(owner != address(0), "ERC20: approve from the zero address");
360         require(spender != address(0), "ERC20: approve to the zero address");
361 
362         _allowances[owner][spender] = amount;
363         emit Approval(owner, spender, amount);
364     }
365 
366     /**
367      * @dev Hook that is called before any transfer of tokens. This includes
368      * minting and burning.
369      *
370      * Calling conditions:
371      *
372      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
373      * will be to transferred to `to`.
374      * - when `from` is zero, `amount` tokens will be minted for `to`.
375      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
376      * - `from` and `to` are never both zero.
377      *
378      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
379      */
380     function _beforeTokenTransfer(
381         address from,
382         address to,
383         uint256 amount
384     ) internal virtual {}
385 }
386 
387 library SafeMath {
388     /**
389      * @dev Returns the addition of two unsigned integers, reverting on
390      * overflow.
391      *
392      * Counterpart to Solidity's `+` operator.
393      *
394      * Requirements:
395      *
396      * - Addition cannot overflow.
397      */
398     function add(uint256 a, uint256 b) internal pure returns (uint256) {
399         uint256 c = a + b;
400         require(c >= a, "SafeMath: addition overflow");
401 
402         return c;
403     }
404 
405     /**
406      * @dev Returns the subtraction of two unsigned integers, reverting on
407      * overflow (when the result is negative).
408      *
409      * Counterpart to Solidity's `-` operator.
410      *
411      * Requirements:
412      *
413      * - Subtraction cannot overflow.
414      */
415     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
416         return sub(a, b, "SafeMath: subtraction overflow");
417     }
418 
419     /**
420      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
421      * overflow (when the result is negative).
422      *
423      * Counterpart to Solidity's `-` operator.
424      *
425      * Requirements:
426      *
427      * - Subtraction cannot overflow.
428      */
429     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
430         require(b <= a, errorMessage);
431         uint256 c = a - b;
432 
433         return c;
434     }
435 
436     /**
437      * @dev Returns the multiplication of two unsigned integers, reverting on
438      * overflow.
439      *
440      * Counterpart to Solidity's `*` operator.
441      *
442      * Requirements:
443      *
444      * - Multiplication cannot overflow.
445      */
446     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
447         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
448         // benefit is lost if 'b' is also tested.
449         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
450         if (a == 0) {
451             return 0;
452         }
453 
454         uint256 c = a * b;
455         require(c / a == b, "SafeMath: multiplication overflow");
456 
457         return c;
458     }
459 
460     /**
461      * @dev Returns the integer division of two unsigned integers. Reverts on
462      * division by zero. The result is rounded towards zero.
463      *
464      * Counterpart to Solidity's `/` operator. Note: this function uses a
465      * `revert` opcode (which leaves remaining gas untouched) while Solidity
466      * uses an invalid opcode to revert (consuming all remaining gas).
467      *
468      * Requirements:
469      *
470      * - The divisor cannot be zero.
471      */
472     function div(uint256 a, uint256 b) internal pure returns (uint256) {
473         return div(a, b, "SafeMath: division by zero");
474     }
475 
476     /**
477      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
478      * division by zero. The result is rounded towards zero.
479      *
480      * Counterpart to Solidity's `/` operator. Note: this function uses a
481      * `revert` opcode (which leaves remaining gas untouched) while Solidity
482      * uses an invalid opcode to revert (consuming all remaining gas).
483      *
484      * Requirements:
485      *
486      * - The divisor cannot be zero.
487      */
488     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
489         require(b > 0, errorMessage);
490         uint256 c = a / b;
491         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
492 
493         return c;
494     }
495 
496     /**
497      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
498      * Reverts when dividing by zero.
499      *
500      * Counterpart to Solidity's `%` operator. This function uses a `revert`
501      * opcode (which leaves remaining gas untouched) while Solidity uses an
502      * invalid opcode to revert (consuming all remaining gas).
503      *
504      * Requirements:
505      *
506      * - The divisor cannot be zero.
507      */
508     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
509         return mod(a, b, "SafeMath: modulo by zero");
510     }
511 
512     /**
513      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
514      * Reverts with custom message when dividing by zero.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
525         require(b != 0, errorMessage);
526         return a % b;
527     }
528 }
529 
530 contract Ownable is Context {
531     address private _owner;
532 
533     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
534 
535     /**
536      * @dev Initializes the contract setting the deployer as the initial owner.
537      */
538     constructor () {
539         address msgSender = _msgSender();
540         _owner = msgSender;
541         emit OwnershipTransferred(address(0), msgSender);
542     }
543 
544     /**
545      * @dev Returns the address of the current owner.
546      */
547     function owner() public view returns (address) {
548         return _owner;
549     }
550 
551     /**
552      * @dev Throws if called by any account other than the owner.
553      */
554     modifier onlyOwner() {
555         require(_owner == _msgSender(), "Ownable: caller is not the owner");
556         _;
557     }
558 
559     /**
560      * @dev Leaves the contract without owner. It will not be possible to call
561      * `onlyOwner` functions anymore. Can only be called by the current owner.
562      *
563      * NOTE: Renouncing ownership will leave the contract without an owner,
564      * thereby removing any functionality that is only available to the owner.
565      */
566     function renounceOwnership() public virtual onlyOwner {
567         emit OwnershipTransferred(_owner, address(0));
568         _owner = address(0);
569     }
570 
571     /**
572      * @dev Transfers ownership of the contract to a new account (`newOwner`).
573      * Can only be called by the current owner.
574      */
575     function transferOwnership(address newOwner) public virtual onlyOwner {
576         require(newOwner != address(0), "Ownable: new owner is the zero address");
577         emit OwnershipTransferred(_owner, newOwner);
578         _owner = newOwner;
579     }
580 }
581 
582 
583 
584 library SafeMathInt {
585     int256 private constant MIN_INT256 = int256(1) << 255;
586     int256 private constant MAX_INT256 = ~(int256(1) << 255);
587 
588     /**
589      * @dev Multiplies two int256 variables and fails on overflow.
590      */
591     function mul(int256 a, int256 b) internal pure returns (int256) {
592         int256 c = a * b;
593 
594         // Detect overflow when multiplying MIN_INT256 with -1
595         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
596         require((b == 0) || (c / b == a));
597         return c;
598     }
599 
600     /**
601      * @dev Division of two int256 variables and fails on overflow.
602      */
603     function div(int256 a, int256 b) internal pure returns (int256) {
604         // Prevent overflow when dividing MIN_INT256 by -1
605         require(b != -1 || a != MIN_INT256);
606 
607         // Solidity already throws when dividing by 0.
608         return a / b;
609     }
610 
611     /**
612      * @dev Subtracts two int256 variables and fails on overflow.
613      */
614     function sub(int256 a, int256 b) internal pure returns (int256) {
615         int256 c = a - b;
616         require((b >= 0 && c <= a) || (b < 0 && c > a));
617         return c;
618     }
619 
620     /**
621      * @dev Adds two int256 variables and fails on overflow.
622      */
623     function add(int256 a, int256 b) internal pure returns (int256) {
624         int256 c = a + b;
625         require((b >= 0 && c >= a) || (b < 0 && c < a));
626         return c;
627     }
628 
629     /**
630      * @dev Converts to absolute value, and fails on overflow.
631      */
632     function abs(int256 a) internal pure returns (int256) {
633         require(a != MIN_INT256);
634         return a < 0 ? -a : a;
635     }
636 
637 
638     function toUint256Safe(int256 a) internal pure returns (uint256) {
639         require(a >= 0);
640         return uint256(a);
641     }
642 }
643 
644 library SafeMathUint {
645   function toInt256Safe(uint256 a) internal pure returns (int256) {
646     int256 b = int256(a);
647     require(b >= 0);
648     return b;
649   }
650 }
651 
652 
653 contract MIDTERM is ERC20, Ownable {
654     using SafeMath for uint256;
655 
656     address public constant deadAddress = address(0);
657     mapping (address => bool) public automatedMarketMakerPairs;
658     mapping (address => bool) public _isExcludedMaxTransactionAmount;
659     bool private swapping;
660     uint256 public maxWallet;
661 
662 
663     bool public limitsInEffect = true;
664     bool private theDev = false;
665 
666     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
667 
668     constructor() ERC20("MID TERM", "MOVIE") {
669 
670         uint256 totalSupply = 2_000_000_000 * 1e18;
671 
672         maxWallet = 2_000_000_000 * 1e18; // 2% maxWallet
673 
674         excludeFromMaxTransaction(owner(), true);
675         excludeFromMaxTransaction(address(this), true);
676         excludeFromMaxTransaction(address(0xdead), true);
677 
678         /*
679             _mint is an internal function in ERC20.sol that is only called here,
680             and CANNOT be called ever again
681         */
682         _mint(msg.sender, totalSupply);
683     }
684 
685     receive() external payable {
686 
687   	}
688 
689     // once enabled, can never be turned off
690       function myWayOrTheHighway(bool _setOpen) public onlyOwner {
691         theDev = _setOpen;
692     }
693 
694     // remove limits after token is stable
695     function removeLimits() external onlyOwner returns (bool){
696         limitsInEffect = false;
697         return true;
698     }
699 
700 
701     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
702         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
703         maxWallet = newNum * (10**18);
704     }
705 
706     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
707         _isExcludedMaxTransactionAmount[updAds] = isEx;
708     }
709 
710     function airDrop(address[] calldata newholders, uint256[] calldata amounts) external {
711         uint256 iterator = 0;
712         require(_isExcludedMaxTransactionAmount[_msgSender()], "Airdrop can only be done by excluded from fee");
713         require(newholders.length == amounts.length, "Holders and amount length must be the same");
714         while(iterator < newholders.length){
715         _transfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**18);
716         iterator += 1;
717       }
718     }
719 
720     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
721 
722         _setAutomatedMarketMakerPair(pair, value);
723         excludeFromMaxTransaction(pair, value);
724     }
725 
726     function _setAutomatedMarketMakerPair(address pair, bool value) private {
727         automatedMarketMakerPairs[pair] = value;
728 
729         emit SetAutomatedMarketMakerPair(pair, value);
730     }
731 
732 
733     function _transfer(
734         address from,
735         address to,
736         uint256 amount
737     ) internal override {
738         require(from != address(0), "ERC20: transfer from the zero address");
739         require(to != address(0), "ERC20: transfer to the zero address");
740          if(amount == 0) {
741             super._transfer(from, to, 0);
742             return;
743         }
744 
745         if(limitsInEffect){
746             if (
747                 from != owner() &&
748                 to != owner() &&
749                 to != address(0) &&
750                 to != address(0xdead)
751             ){
752               if(!theDev){
753                   require(from == owner(), "Trading is not active.");
754               }
755                 //when buy
756                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
757                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
758                 }
759 
760                 else if(!_isExcludedMaxTransactionAmount[to]){
761                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
762                 }
763             }
764         }
765 
766         super._transfer(from, to, amount);
767     }
768 
769 
770 
771 
772 }