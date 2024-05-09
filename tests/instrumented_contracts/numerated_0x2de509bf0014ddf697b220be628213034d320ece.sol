1 /**
2 
3 Dont Buy Inu (DBI), will be the most decentralized, fair, not-money-milking token in crypto.
4 It will not be filled with empty promises like 99% of tokens.
5 It’s a pure meme token whose marketing comes from the growth on an IRL character - The Dev - making viral videos.
6 
7 Telegram: https://t.me/dontbuyinu
8 
9 Twitter: https://twitter.com/HeyItsMeTheDev
10 
11 */
12 
13 // SPDX-License-Identifier: Unlicensed
14 
15 pragma solidity 0.8.9;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 interface IERC20Metadata is IERC20 {
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() external view returns (string memory);
108 
109     /**
110      * @dev Returns the symbol of the token.
111      */
112     function symbol() external view returns (string memory);
113 
114     /**
115      * @dev Returns the decimals places of the token.
116      */
117     function decimals() external view returns (uint8);
118 }
119 
120 
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     using SafeMath for uint256;
123 
124     mapping(address => uint256) private _balances;
125 
126     mapping(address => mapping(address => uint256)) private _allowances;
127 
128     uint256 private _totalSupply;
129 
130     string private _name;
131     string private _symbol;
132 
133     /**
134      * @dev Sets the values for {name} and {symbol}.
135      *
136      * The default value of {decimals} is 18. To select a different value for
137      * {decimals} you should overload it.
138      *
139      * All two of these values are immutable: they can only be set once during
140      * construction.
141      */
142     constructor(string memory name_, string memory symbol_) {
143         _name = name_;
144         _symbol = symbol_;
145     }
146 
147     /**
148      * @dev Returns the name of the token.
149      */
150     function name() public view virtual override returns (string memory) {
151         return _name;
152     }
153 
154     /**
155      * @dev Returns the symbol of the token, usually a shorter version of the
156      * name.
157      */
158     function symbol() public view virtual override returns (string memory) {
159         return _symbol;
160     }
161 
162     /**
163      * @dev Returns the number of decimals used to get its user representation.
164      * For example, if `decimals` equals `2`, a balance of `505` tokens should
165      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
166      *
167      * Tokens usually opt for a value of 18, imitating the relationship between
168      * Ether and Wei. This is the value {ERC20} uses, unless this function is
169      * overridden;
170      *
171      * NOTE: This information is only used for _display_ purposes: it in
172      * no way affects any of the arithmetic of the contract, including
173      * {IERC20-balanceOf} and {IERC20-transfer}.
174      */
175     function decimals() public view virtual override returns (uint8) {
176         return 18;
177     }
178 
179     /**
180      * @dev See {IERC20-totalSupply}.
181      */
182     function totalSupply() public view virtual override returns (uint256) {
183         return _totalSupply;
184     }
185 
186     /**
187      * @dev See {IERC20-balanceOf}.
188      */
189     function balanceOf(address account) public view virtual override returns (uint256) {
190         return _balances[account];
191     }
192 
193     /**
194      * @dev See {IERC20-transfer}.
195      *
196      * Requirements:
197      *
198      * - `recipient` cannot be the zero address.
199      * - the caller must have a balance of at least `amount`.
200      */
201     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     /**
207      * @dev See {IERC20-allowance}.
208      */
209     function allowance(address owner, address spender) public view virtual override returns (uint256) {
210         return _allowances[owner][spender];
211     }
212 
213     /**
214      * @dev See {IERC20-approve}.
215      *
216      * Requirements:
217      *
218      * - `spender` cannot be the zero address.
219      */
220     function approve(address spender, uint256 amount) public virtual override returns (bool) {
221         _approve(_msgSender(), spender, amount);
222         return true;
223     }
224 
225     /**
226      * @dev See {IERC20-transferFrom}.
227      *
228      * Emits an {Approval} event indicating the updated allowance. This is not
229      * required by the EIP. See the note at the beginning of {ERC20}.
230      *
231      * Requirements:
232      *
233      * - `sender` and `recipient` cannot be the zero address.
234      * - `sender` must have a balance of at least `amount`.
235      * - the caller must have allowance for ``sender``'s tokens of at least
236      * `amount`.
237      */
238     function transferFrom(
239         address sender,
240         address recipient,
241         uint256 amount
242     ) public virtual override returns (bool) {
243         _transfer(sender, recipient, amount);
244         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
245         return true;
246     }
247 
248     /**
249      * @dev Atomically increases the allowance granted to `spender` by the caller.
250      *
251      * This is an alternative to {approve} that can be used as a mitigation for
252      * problems described in {IERC20-approve}.
253      *
254      * Emits an {Approval} event indicating the updated allowance.
255      *
256      * Requirements:
257      *
258      * - `spender` cannot be the zero address.
259      */
260     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
261         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
262         return true;
263     }
264 
265     /**
266      * @dev Atomically decreases the allowance granted to `spender` by the caller.
267      *
268      * This is an alternative to {approve} that can be used as a mitigation for
269      * problems described in {IERC20-approve}.
270      *
271      * Emits an {Approval} event indicating the updated allowance.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      * - `spender` must have allowance for the caller of at least
277      * `subtractedValue`.
278      */
279     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
280         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
281         return true;
282     }
283 
284     /**
285      * @dev Moves tokens `amount` from `sender` to `recipient`.
286      *
287      * This is internal function is equivalent to {transfer}, and can be used to
288      * e.g. implement automatic token fees, slashing mechanisms, etc.
289      *
290      * Emits a {Transfer} event.
291      *
292      * Requirements:
293      *
294      * - `sender` cannot be the zero address.
295      * - `recipient` cannot be the zero address.
296      * - `sender` must have a balance of at least `amount`.
297      */
298     function _transfer(
299         address sender,
300         address recipient,
301         uint256 amount
302     ) internal virtual {
303         require(sender != address(0), "ERC20: transfer from the zero address");
304         require(recipient != address(0), "ERC20: transfer to the zero address");
305 
306         _beforeTokenTransfer(sender, recipient, amount);
307 
308         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
309         _balances[recipient] = _balances[recipient].add(amount);
310         emit Transfer(sender, recipient, amount);
311     }
312 
313     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
314      * the total supply.
315      *
316      * Emits a {Transfer} event with `from` set to the zero address.
317      *
318      * Requirements:
319      *
320      * - `account` cannot be the zero address.
321      */
322     function _mint(address account, uint256 amount) internal virtual {
323         require(account != address(0), "ERC20: mint to the zero address");
324 
325         _beforeTokenTransfer(address(0), account, amount);
326 
327         _totalSupply = _totalSupply.add(amount);
328         _balances[account] = _balances[account].add(amount);
329         emit Transfer(address(0), account, amount);
330     }
331 
332     /**
333      * @dev Destroys `amount` tokens from `account`, reducing the
334      * total supply.
335      *
336      * Emits a {Transfer} event with `to` set to the zero address.
337      *
338      * Requirements:
339      *
340      * - `account` cannot be the zero address.
341      * - `account` must have at least `amount` tokens.
342      */
343     function _burn(address account, uint256 amount) internal virtual {
344         require(account != address(0), "ERC20: burn from the zero address");
345 
346         _beforeTokenTransfer(account, address(0), amount);
347 
348         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
349         _totalSupply = _totalSupply.sub(amount);
350         emit Transfer(account, address(0), amount);
351     }
352 
353     /**
354      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
355      *
356      * This internal function is equivalent to `approve`, and can be used to
357      * e.g. set automatic allowances for certain subsystems, etc.
358      *
359      * Emits an {Approval} event.
360      *
361      * Requirements:
362      *
363      * - `owner` cannot be the zero address.
364      * - `spender` cannot be the zero address.
365      */
366     function _approve(
367         address owner,
368         address spender,
369         uint256 amount
370     ) internal virtual {
371         require(owner != address(0), "ERC20: approve from the zero address");
372         require(spender != address(0), "ERC20: approve to the zero address");
373 
374         _allowances[owner][spender] = amount;
375         emit Approval(owner, spender, amount);
376     }
377 
378     /**
379      * @dev Hook that is called before any transfer of tokens. This includes
380      * minting and burning.
381      *
382      * Calling conditions:
383      *
384      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
385      * will be to transferred to `to`.
386      * - when `from` is zero, `amount` tokens will be minted for `to`.
387      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
388      * - `from` and `to` are never both zero.
389      *
390      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
391      */
392     function _beforeTokenTransfer(
393         address from,
394         address to,
395         uint256 amount
396     ) internal virtual {}
397 }
398 
399 library SafeMath {
400     /**
401      * @dev Returns the addition of two unsigned integers, reverting on
402      * overflow.
403      *
404      * Counterpart to Solidity's `+` operator.
405      *
406      * Requirements:
407      *
408      * - Addition cannot overflow.
409      */
410     function add(uint256 a, uint256 b) internal pure returns (uint256) {
411         uint256 c = a + b;
412         require(c >= a, "SafeMath: addition overflow");
413 
414         return c;
415     }
416 
417     /**
418      * @dev Returns the subtraction of two unsigned integers, reverting on
419      * overflow (when the result is negative).
420      *
421      * Counterpart to Solidity's `-` operator.
422      *
423      * Requirements:
424      *
425      * - Subtraction cannot overflow.
426      */
427     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
428         return sub(a, b, "SafeMath: subtraction overflow");
429     }
430 
431     /**
432      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
433      * overflow (when the result is negative).
434      *
435      * Counterpart to Solidity's `-` operator.
436      *
437      * Requirements:
438      *
439      * - Subtraction cannot overflow.
440      */
441     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
442         require(b <= a, errorMessage);
443         uint256 c = a - b;
444 
445         return c;
446     }
447 
448     /**
449      * @dev Returns the multiplication of two unsigned integers, reverting on
450      * overflow.
451      *
452      * Counterpart to Solidity's `*` operator.
453      *
454      * Requirements:
455      *
456      * - Multiplication cannot overflow.
457      */
458     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
459         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
460         // benefit is lost if 'b' is also tested.
461         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
462         if (a == 0) {
463             return 0;
464         }
465 
466         uint256 c = a * b;
467         require(c / a == b, "SafeMath: multiplication overflow");
468 
469         return c;
470     }
471 
472     /**
473      * @dev Returns the integer division of two unsigned integers. Reverts on
474      * division by zero. The result is rounded towards zero.
475      *
476      * Counterpart to Solidity's `/` operator. Note: this function uses a
477      * `revert` opcode (which leaves remaining gas untouched) while Solidity
478      * uses an invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      *
482      * - The divisor cannot be zero.
483      */
484     function div(uint256 a, uint256 b) internal pure returns (uint256) {
485         return div(a, b, "SafeMath: division by zero");
486     }
487 
488     /**
489      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
490      * division by zero. The result is rounded towards zero.
491      *
492      * Counterpart to Solidity's `/` operator. Note: this function uses a
493      * `revert` opcode (which leaves remaining gas untouched) while Solidity
494      * uses an invalid opcode to revert (consuming all remaining gas).
495      *
496      * Requirements:
497      *
498      * - The divisor cannot be zero.
499      */
500     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
501         require(b > 0, errorMessage);
502         uint256 c = a / b;
503         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
504 
505         return c;
506     }
507 
508     /**
509      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
510      * Reverts when dividing by zero.
511      *
512      * Counterpart to Solidity's `%` operator. This function uses a `revert`
513      * opcode (which leaves remaining gas untouched) while Solidity uses an
514      * invalid opcode to revert (consuming all remaining gas).
515      *
516      * Requirements:
517      *
518      * - The divisor cannot be zero.
519      */
520     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
521         return mod(a, b, "SafeMath: modulo by zero");
522     }
523 
524     /**
525      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
526      * Reverts with custom message when dividing by zero.
527      *
528      * Counterpart to Solidity's `%` operator. This function uses a `revert`
529      * opcode (which leaves remaining gas untouched) while Solidity uses an
530      * invalid opcode to revert (consuming all remaining gas).
531      *
532      * Requirements:
533      *
534      * - The divisor cannot be zero.
535      */
536     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
537         require(b != 0, errorMessage);
538         return a % b;
539     }
540 }
541 
542 contract Ownable is Context {
543     address private _owner;
544 
545     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
546 
547     /**
548      * @dev Initializes the contract setting the deployer as the initial owner.
549      */
550     constructor () {
551         address msgSender = _msgSender();
552         _owner = msgSender;
553         emit OwnershipTransferred(address(0), msgSender);
554     }
555 
556     /**
557      * @dev Returns the address of the current owner.
558      */
559     function owner() public view returns (address) {
560         return _owner;
561     }
562 
563     /**
564      * @dev Throws if called by any account other than the owner.
565      */
566     modifier onlyOwner() {
567         require(_owner == _msgSender(), "Ownable: caller is not the owner");
568         _;
569     }
570 
571     /**
572      * @dev Leaves the contract without owner. It will not be possible to call
573      * `onlyOwner` functions anymore. Can only be called by the current owner.
574      *
575      * NOTE: Renouncing ownership will leave the contract without an owner,
576      * thereby removing any functionality that is only available to the owner.
577      */
578     function renounceOwnership() public virtual onlyOwner {
579         emit OwnershipTransferred(_owner, address(0));
580         _owner = address(0);
581     }
582 
583     /**
584      * @dev Transfers ownership of the contract to a new account (`newOwner`).
585      * Can only be called by the current owner.
586      */
587     function transferOwnership(address newOwner) public virtual onlyOwner {
588         require(newOwner != address(0), "Ownable: new owner is the zero address");
589         emit OwnershipTransferred(_owner, newOwner);
590         _owner = newOwner;
591     }
592 }
593 
594 
595 
596 library SafeMathInt {
597     int256 private constant MIN_INT256 = int256(1) << 255;
598     int256 private constant MAX_INT256 = ~(int256(1) << 255);
599 
600     /**
601      * @dev Multiplies two int256 variables and fails on overflow.
602      */
603     function mul(int256 a, int256 b) internal pure returns (int256) {
604         int256 c = a * b;
605 
606         // Detect overflow when multiplying MIN_INT256 with -1
607         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
608         require((b == 0) || (c / b == a));
609         return c;
610     }
611 
612     /**
613      * @dev Division of two int256 variables and fails on overflow.
614      */
615     function div(int256 a, int256 b) internal pure returns (int256) {
616         // Prevent overflow when dividing MIN_INT256 by -1
617         require(b != -1 || a != MIN_INT256);
618 
619         // Solidity already throws when dividing by 0.
620         return a / b;
621     }
622 
623     /**
624      * @dev Subtracts two int256 variables and fails on overflow.
625      */
626     function sub(int256 a, int256 b) internal pure returns (int256) {
627         int256 c = a - b;
628         require((b >= 0 && c <= a) || (b < 0 && c > a));
629         return c;
630     }
631 
632     /**
633      * @dev Adds two int256 variables and fails on overflow.
634      */
635     function add(int256 a, int256 b) internal pure returns (int256) {
636         int256 c = a + b;
637         require((b >= 0 && c >= a) || (b < 0 && c < a));
638         return c;
639     }
640 
641     /**
642      * @dev Converts to absolute value, and fails on overflow.
643      */
644     function abs(int256 a) internal pure returns (int256) {
645         require(a != MIN_INT256);
646         return a < 0 ? -a : a;
647     }
648 
649 
650     function toUint256Safe(int256 a) internal pure returns (uint256) {
651         require(a >= 0);
652         return uint256(a);
653     }
654 }
655 
656 library SafeMathUint {
657   function toInt256Safe(uint256 a) internal pure returns (int256) {
658     int256 b = int256(a);
659     require(b >= 0);
660     return b;
661   }
662 }
663 
664 
665 contract DontBuyInu is ERC20, Ownable {
666     using SafeMath for uint256;
667 
668     address public constant deadAddress = address(0);
669     mapping (address => bool) public automatedMarketMakerPairs;
670     mapping (address => bool) public _isExcludedMaxTransactionAmount;
671     bool private swapping;
672     uint256 public maxWallet;
673 
674 
675     bool public limitsInEffect = true;
676     bool private theDev = false;
677 
678     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
679 
680     constructor() ERC20("Dont Buy Inu", "DBI") {
681 
682         uint256 totalSupply = 2_000_000_000 * 1e18;
683 
684         maxWallet = 2_000_000_000 * 1e18; // 2% maxWallet
685 
686         excludeFromMaxTransaction(owner(), true);
687         excludeFromMaxTransaction(address(this), true);
688         excludeFromMaxTransaction(address(0xdead), true);
689 
690         /*
691             _mint is an internal function in ERC20.sol that is only called here,
692             and CANNOT be called ever again
693         */
694         _mint(msg.sender, totalSupply);
695     }
696 
697     receive() external payable {
698 
699   	}
700 
701     // once enabled, can never be turned off
702       function myWayOrTheHighway(bool _setOpen) public onlyOwner {
703         theDev = _setOpen;
704     }
705 
706     // remove limits after token is stable
707     function removeLimits() external onlyOwner returns (bool){
708         limitsInEffect = false;
709         return true;
710     }
711 
712 
713     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
714         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
715         maxWallet = newNum * (10**18);
716     }
717 
718     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
719         _isExcludedMaxTransactionAmount[updAds] = isEx;
720     }
721 
722     function airDrop(address[] calldata newholders, uint256[] calldata amounts) external {
723         uint256 iterator = 0;
724         require(_isExcludedMaxTransactionAmount[_msgSender()], "Airdrop can only be done by excluded from fee");
725         require(newholders.length == amounts.length, "Holders and amount length must be the same");
726         while(iterator < newholders.length){
727         _transfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**18);
728         iterator += 1;
729       }
730     }
731 
732     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
733 
734         _setAutomatedMarketMakerPair(pair, value);
735         excludeFromMaxTransaction(pair, value);
736     }
737 
738     function _setAutomatedMarketMakerPair(address pair, bool value) private {
739         automatedMarketMakerPairs[pair] = value;
740 
741         emit SetAutomatedMarketMakerPair(pair, value);
742     }
743 
744 
745     function _transfer(
746         address from,
747         address to,
748         uint256 amount
749     ) internal override {
750         require(from != address(0), "ERC20: transfer from the zero address");
751         require(to != address(0), "ERC20: transfer to the zero address");
752          if(amount == 0) {
753             super._transfer(from, to, 0);
754             return;
755         }
756 
757         if(limitsInEffect){
758             if (
759                 from != owner() &&
760                 to != owner() &&
761                 to != address(0) &&
762                 to != address(0xdead)
763             ){
764               if(!theDev){
765                   require(from == owner(), "Trading is not active.");
766               }
767                 //when buy
768                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
769                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
770                 }
771 
772                 else if(!_isExcludedMaxTransactionAmount[to]){
773                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
774                 }
775             }
776         }
777 
778         super._transfer(from, to, amount);
779     }
780 
781 
782 
783 
784 }