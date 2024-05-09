1 /**
2  *Submitted for verification at BscScan.com on 2021-10-23
3 */
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @dev Interface for the optional metadata functions from the ERC20 standard.
107  *
108  * _Available since v4.1._
109  */
110 interface IERC20Metadata is IERC20 {
111     /**
112      * @dev Returns the name of the token.
113      */
114     function name() external view returns (string memory);
115 
116     /**
117      * @dev Returns the symbol of the token.
118      */
119     function symbol() external view returns (string memory);
120 
121     /**
122      * @dev Returns the decimals places of the token.
123      */
124     function decimals() external view returns (uint8);
125 }
126 
127 contract ERC20 is Context, IERC20, IERC20Metadata {
128     mapping(address => uint256) private _balances;
129 
130     mapping(address => mapping(address => uint256)) private _allowances;
131 
132     uint256 private _totalSupply;
133 
134     string private _name;
135     string private _symbol;
136 
137     /**
138      * @dev Sets the values for {name} and {symbol}.
139      *
140      * The default value of {decimals} is 18. To select a different value for
141      * {decimals} you should overload it.
142      *
143      * All two of these values are immutable: they can only be set once during
144      * construction.
145      */
146     constructor(string memory name_, string memory symbol_) {
147         _name = name_;
148         _symbol = symbol_;
149     }
150 
151     /**
152      * @dev Returns the name of the token.
153      */
154     function name() public view virtual override returns (string memory) {
155         return _name;
156     }
157 
158     /**
159      * @dev Returns the symbol of the token, usually a shorter version of the
160      * name.
161      */
162     function symbol() public view virtual override returns (string memory) {
163         return _symbol;
164     }
165 
166     /**
167      * @dev Returns the number of decimals used to get its user representation.
168      * For example, if `decimals` equals `2`, a balance of `505` tokens should
169      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
170      *
171      * Tokens usually opt for a value of 18, imitating the relationship between
172      * Ether and Wei. This is the value {ERC20} uses, unless this function is
173      * overridden;
174      *
175      * NOTE: This information is only used for _display_ purposes: it in
176      * no way affects any of the arithmetic of the contract, including
177      * {IERC20-balanceOf} and {IERC20-transfer}.
178      */
179     function decimals() public view virtual override returns (uint8) {
180         return 18;
181     }
182 
183     /**
184      * @dev See {IERC20-totalSupply}.
185      */
186     function totalSupply() public view virtual override returns (uint256) {
187         return _totalSupply;
188     }
189 
190     /**
191      * @dev See {IERC20-balanceOf}.
192      */
193     function balanceOf(address account) public view virtual override returns (uint256) {
194         return _balances[account];
195     }
196 
197     /**
198      * @dev See {IERC20-transfer}.
199      *
200      * Requirements:
201      *
202      * - `recipient` cannot be the zero address.
203      * - the caller must have a balance of at least `amount`.
204      */
205     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     /**
211      * @dev See {IERC20-allowance}.
212      */
213     function allowance(address owner, address spender) public view virtual override returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     /**
218      * @dev See {IERC20-approve}.
219      *
220      * Requirements:
221      *
222      * - `spender` cannot be the zero address.
223      */
224     function approve(address spender, uint256 amount) public virtual override returns (bool) {
225         _approve(_msgSender(), spender, amount);
226         return true;
227     }
228 
229     /**
230      * @dev See {IERC20-transferFrom}.
231      *
232      * Emits an {Approval} event indicating the updated allowance. This is not
233      * required by the EIP. See the note at the beginning of {ERC20}.
234      *
235      * Requirements:
236      *
237      * - `sender` and `recipient` cannot be the zero address.
238      * - `sender` must have a balance of at least `amount`.
239      * - the caller must have allowance for ``sender``'s tokens of at least
240      * `amount`.
241      */
242     function transferFrom(
243         address sender,
244         address recipient,
245         uint256 amount
246     ) public virtual override returns (bool) {
247         _transfer(sender, recipient, amount);
248 
249         uint256 currentAllowance = _allowances[sender][_msgSender()];
250         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
251         unchecked {
252             _approve(sender, _msgSender(), currentAllowance - amount);
253         }
254 
255         return true;
256     }
257 
258     /**
259      * @dev Atomically increases the allowance granted to `spender` by the caller.
260      *
261      * This is an alternative to {approve} that can be used as a mitigation for
262      * problems described in {IERC20-approve}.
263      *
264      * Emits an {Approval} event indicating the updated allowance.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
271         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
272         return true;
273     }
274 
275     /**
276      * @dev Atomically decreases the allowance granted to `spender` by the caller.
277      *
278      * This is an alternative to {approve} that can be used as a mitigation for
279      * problems described in {IERC20-approve}.
280      *
281      * Emits an {Approval} event indicating the updated allowance.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      * - `spender` must have allowance for the caller of at least
287      * `subtractedValue`.
288      */
289     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
290         uint256 currentAllowance = _allowances[_msgSender()][spender];
291         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
292         unchecked {
293             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
294         }
295 
296         return true;
297     }
298 
299     /**
300      * @dev Moves `amount` of tokens from `sender` to `recipient`.
301      *
302      * This internal function is equivalent to {transfer}, and can be used to
303      * e.g. implement automatic token fees, slashing mechanisms, etc.
304      *
305      * Emits a {Transfer} event.
306      *
307      * Requirements:
308      *
309      * - `sender` cannot be the zero address.
310      * - `recipient` cannot be the zero address.
311      * - `sender` must have a balance of at least `amount`.
312      */
313     function _transfer(
314         address sender,
315         address recipient,
316         uint256 amount
317     ) internal virtual {
318         require(sender != address(0), "ERC20: transfer from the zero address");
319         require(recipient != address(0), "ERC20: transfer to the zero address");
320 
321         _beforeTokenTransfer(sender, recipient, amount);
322 
323         uint256 senderBalance = _balances[sender];
324         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
325         unchecked {
326             _balances[sender] = senderBalance - amount;
327         }
328         _balances[recipient] += amount;
329 
330         emit Transfer(sender, recipient, amount);
331 
332         _afterTokenTransfer(sender, recipient, amount);
333     }
334 
335     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
336      * the total supply.
337      *
338      * Emits a {Transfer} event with `from` set to the zero address.
339      *
340      * Requirements:
341      *
342      * - `account` cannot be the zero address.
343      */
344     function _mint(address account, uint256 amount) internal virtual {
345         require(account != address(0), "ERC20: mint to the zero address");
346 
347         _beforeTokenTransfer(address(0), account, amount);
348 
349         _totalSupply += amount;
350         _balances[account] += amount;
351         emit Transfer(address(0), account, amount);
352 
353         _afterTokenTransfer(address(0), account, amount);
354     }
355 
356     /**
357      * @dev Destroys `amount` tokens from `account`, reducing the
358      * total supply.
359      *
360      * Emits a {Transfer} event with `to` set to the zero address.
361      *
362      * Requirements:
363      *
364      * - `account` cannot be the zero address.
365      * - `account` must have at least `amount` tokens.
366      */
367     function _burn(address account, uint256 amount) internal virtual {
368         require(account != address(0), "ERC20: burn from the zero address");
369 
370         _beforeTokenTransfer(account, address(0), amount);
371 
372         uint256 accountBalance = _balances[account];
373         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
374         unchecked {
375             _balances[account] = accountBalance - amount;
376         }
377         _totalSupply -= amount;
378 
379         emit Transfer(account, address(0), amount);
380 
381         _afterTokenTransfer(account, address(0), amount);
382     }
383 
384     /**
385      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
386      *
387      * This internal function is equivalent to `approve`, and can be used to
388      * e.g. set automatic allowances for certain subsystems, etc.
389      *
390      * Emits an {Approval} event.
391      *
392      * Requirements:
393      *
394      * - `owner` cannot be the zero address.
395      * - `spender` cannot be the zero address.
396      */
397     function _approve(
398         address owner,
399         address spender,
400         uint256 amount
401     ) internal virtual {
402         require(owner != address(0), "ERC20: approve from the zero address");
403         require(spender != address(0), "ERC20: approve to the zero address");
404 
405         _allowances[owner][spender] = amount;
406         emit Approval(owner, spender, amount);
407     }
408 
409     /**
410      * @dev Hook that is called before any transfer of tokens. This includes
411      * minting and burning.
412      *
413      * Calling conditions:
414      *
415      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
416      * will be transferred to `to`.
417      * - when `from` is zero, `amount` tokens will be minted for `to`.
418      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
419      * - `from` and `to` are never both zero.
420      *
421      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
422      */
423     function _beforeTokenTransfer(
424         address from,
425         address to,
426         uint256 amount
427     ) internal virtual {}
428 
429     /**
430      * @dev Hook that is called after any transfer of tokens. This includes
431      * minting and burning.
432      *
433      * Calling conditions:
434      *
435      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
436      * has been transferred to `to`.
437      * - when `from` is zero, `amount` tokens have been minted for `to`.
438      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
439      * - `from` and `to` are never both zero.
440      *
441      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
442      */
443     function _afterTokenTransfer(
444         address from,
445         address to,
446         uint256 amount
447     ) internal virtual {}
448 }
449 
450 library SafeMath {
451     /**
452      * @dev Returns the addition of two unsigned integers, with an overflow flag.
453      *
454      * _Available since v3.4._
455      */
456     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
457         unchecked {
458             uint256 c = a + b;
459             if (c < a) return (false, 0);
460             return (true, c);
461         }
462     }
463 
464     /**
465      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
466      *
467      * _Available since v3.4._
468      */
469     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
470         unchecked {
471             if (b > a) return (false, 0);
472             return (true, a - b);
473         }
474     }
475 
476     /**
477      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
478      *
479      * _Available since v3.4._
480      */
481     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
482         unchecked {
483             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
484             // benefit is lost if 'b' is also tested.
485             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
486             if (a == 0) return (true, 0);
487             uint256 c = a * b;
488             if (c / a != b) return (false, 0);
489             return (true, c);
490         }
491     }
492 
493     /**
494      * @dev Returns the division of two unsigned integers, with a division by zero flag.
495      *
496      * _Available since v3.4._
497      */
498     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
499         unchecked {
500             if (b == 0) return (false, 0);
501             return (true, a / b);
502         }
503     }
504 
505     /**
506      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
507      *
508      * _Available since v3.4._
509      */
510     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
511         unchecked {
512             if (b == 0) return (false, 0);
513             return (true, a % b);
514         }
515     }
516 
517     /**
518      * @dev Returns the addition of two unsigned integers, reverting on
519      * overflow.
520      *
521      * Counterpart to Solidity's `+` operator.
522      *
523      * Requirements:
524      *
525      * - Addition cannot overflow.
526      */
527     function add(uint256 a, uint256 b) internal pure returns (uint256) {
528         return a + b;
529     }
530 
531     /**
532      * @dev Returns the subtraction of two unsigned integers, reverting on
533      * overflow (when the result is negative).
534      *
535      * Counterpart to Solidity's `-` operator.
536      *
537      * Requirements:
538      *
539      * - Subtraction cannot overflow.
540      */
541     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
542         return a - b;
543     }
544 
545     /**
546      * @dev Returns the multiplication of two unsigned integers, reverting on
547      * overflow.
548      *
549      * Counterpart to Solidity's `*` operator.
550      *
551      * Requirements:
552      *
553      * - Multiplication cannot overflow.
554      */
555     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
556         return a * b;
557     }
558 
559     /**
560      * @dev Returns the integer division of two unsigned integers, reverting on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator.
564      *
565      * Requirements:
566      *
567      * - The divisor cannot be zero.
568      */
569     function div(uint256 a, uint256 b) internal pure returns (uint256) {
570         return a / b;
571     }
572 
573     /**
574      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
575      * reverting when dividing by zero.
576      *
577      * Counterpart to Solidity's `%` operator. This function uses a `revert`
578      * opcode (which leaves remaining gas untouched) while Solidity uses an
579      * invalid opcode to revert (consuming all remaining gas).
580      *
581      * Requirements:
582      *
583      * - The divisor cannot be zero.
584      */
585     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
586         return a % b;
587     }
588 
589     /**
590      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
591      * overflow (when the result is negative).
592      *
593      * CAUTION: This function is deprecated because it requires allocating memory for the error
594      * message unnecessarily. For custom revert reasons use {trySub}.
595      *
596      * Counterpart to Solidity's `-` operator.
597      *
598      * Requirements:
599      *
600      * - Subtraction cannot overflow.
601      */
602     function sub(
603         uint256 a,
604         uint256 b,
605         string memory errorMessage
606     ) internal pure returns (uint256) {
607         unchecked {
608             require(b <= a, errorMessage);
609             return a - b;
610         }
611     }
612 
613     /**
614      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
615      * division by zero. The result is rounded towards zero.
616      *
617      * Counterpart to Solidity's `/` operator. Note: this function uses a
618      * `revert` opcode (which leaves remaining gas untouched) while Solidity
619      * uses an invalid opcode to revert (consuming all remaining gas).
620      *
621      * Requirements:
622      *
623      * - The divisor cannot be zero.
624      */
625     function div(
626         uint256 a,
627         uint256 b,
628         string memory errorMessage
629     ) internal pure returns (uint256) {
630         unchecked {
631             require(b > 0, errorMessage);
632             return a / b;
633         }
634     }
635 
636     /**
637      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
638      * reverting with custom message when dividing by zero.
639      *
640      * CAUTION: This function is deprecated because it requires allocating memory for the error
641      * message unnecessarily. For custom revert reasons use {tryMod}.
642      *
643      * Counterpart to Solidity's `%` operator. This function uses a `revert`
644      * opcode (which leaves remaining gas untouched) while Solidity uses an
645      * invalid opcode to revert (consuming all remaining gas).
646      *
647      * Requirements:
648      *
649      * - The divisor cannot be zero.
650      */
651     function mod(
652         uint256 a,
653         uint256 b,
654         string memory errorMessage
655     ) internal pure returns (uint256) {
656         unchecked {
657             require(b > 0, errorMessage);
658             return a % b;
659         }
660     }
661 }
662 
663 
664 contract EnvoyToken is ERC20 {
665 
666   using SafeMath for uint256;
667 
668   //
669   // ******************* VARIABLES *******************
670   //
671 
672   // Deploy time
673   uint256 private _deployTime = 1635429600; 
674   uint256 private _startTime = 1635933600; 
675 
676   // Contract owner
677   address public _ownerWallet;
678 
679   // Public sale - 1M
680   address public _publicSaleWallet;
681   // Team - 20M
682   address public _teamWallet;
683   // Ecosystem - 25M
684   address public _ecosystemWallet;
685   // Reserves - 20M
686   address public _reservesWallet;
687   // DEX - 2M
688   address public _dexWallet;
689   // Liquidity incentives - 7M
690   address public _liqWallet;
691 
692   // Amount of tokens per buyer in private sale - 25M
693   mapping(address => uint256) public _buyerTokens;
694 
695   // Amount of tokens assigned to buyers
696   uint256 public _totalBuyerTokens;
697 
698   // Amount of tokens a wallet has withdrawn already, per type
699   mapping(string => mapping(address => uint256)) public _walletTokensWithdrawn;
700 
701 
702   //
703   // ******************* SETUP *******************
704   //
705 
706   constructor (string memory name, string memory symbol) public ERC20(name, symbol) {
707 
708     // Set owner wallet
709     _ownerWallet = _msgSender();
710 
711     // Mint 100M tokens for contract
712     _mint(address(this), 100000000000000000000000000);
713   }
714 
715   //
716   // ******************* WALLETS SETUP *******************
717   //
718 
719   // Owner can update owner
720   function updateOwner(address owner) external {
721     require(_msgSender() == _ownerWallet, "Only owner can update wallets");
722 
723     _ownerWallet = owner; 
724   }
725 
726   // Update wallets
727   function updateWallets(address publicSale, address team, address ecosystem, address reserves, address dex, address liq) external {
728     require(_msgSender() == _ownerWallet, "Only owner can update wallets");
729 
730     require(publicSale != address(0), "Should not set zero address");
731     require(team != address(0), "Should not set zero address");
732     require(ecosystem != address(0), "Should not set zero address");
733     require(reserves != address(0), "Should not set zero address");
734     require(dex != address(0), "Should not set zero address");
735     require(liq != address(0), "Should not set zero address");
736 
737     _walletTokensWithdrawn["publicsale"][publicSale] = _walletTokensWithdrawn["publicsale"][_publicSaleWallet];
738     _walletTokensWithdrawn["team"][team] = _walletTokensWithdrawn["team"][_teamWallet];
739     _walletTokensWithdrawn["ecosystem"][ecosystem] = _walletTokensWithdrawn["ecosystem"][_ecosystemWallet];
740     _walletTokensWithdrawn["reserve"][reserves] = _walletTokensWithdrawn["reserve"][_reservesWallet];
741     _walletTokensWithdrawn["dex"][dex] = _walletTokensWithdrawn["dex"][_dexWallet];
742     _walletTokensWithdrawn["liq"][liq] = _walletTokensWithdrawn["liq"][_liqWallet];
743 
744     _publicSaleWallet = publicSale; 
745     _teamWallet = team;
746     _ecosystemWallet = ecosystem;
747     _reservesWallet = reserves;
748     _dexWallet = dex;
749     _liqWallet = liq;
750   }
751 
752   // Update buyer tokens
753   function setBuyerTokens(address buyer, uint256 tokenAmount) external {
754     require(_msgSender() == _ownerWallet, "Only owner can set buyer tokens");
755 
756     // Update total
757     _totalBuyerTokens -= _buyerTokens[buyer];
758     _totalBuyerTokens += tokenAmount;
759 
760     // Check if enough tokens left, can max assign 25M
761     require(_totalBuyerTokens <= 25000000000000000000000000, "Max amount reached");
762 
763     // Update map
764     _buyerTokens[buyer] = tokenAmount;
765   }
766 
767   //
768   // ******************* OWNER *******************
769   //
770 
771   function publicSaleWithdraw(uint256 tokenAmount) external {
772     require(_msgSender() == _publicSaleWallet, "Unauthorized public sale wallet");
773 
774     uint256 hasWithdrawn = _walletTokensWithdrawn["publicsale"][_msgSender()];
775 
776     // Total = 1M instant
777     uint256 canWithdraw = 1000000000000000000000000 - hasWithdrawn;
778 
779     require(tokenAmount <= canWithdraw, "Withdraw amount too high");
780 
781     _walletTokensWithdrawn["publicsale"][_msgSender()] += tokenAmount;
782 
783     _transfer(address(this), _msgSender(), tokenAmount);    
784   }
785 
786   function liqWithdraw(uint256 tokenAmount) external {
787     require(_msgSender() == _liqWallet, "Unauthorized liquidity incentives wallet");
788 
789     // TGE = 40%
790     // Cliff = 1 months = 43800 minutes
791     // Vesting = 6 months 262800 minutes
792     // Total = 20M
793     uint256 canWithdraw = walletCanWithdraw(_msgSender(), "liq", 40, 43800, 262800, 7000000000000000000000000, _deployTime);
794     
795     require(tokenAmount <= canWithdraw, "Withdraw amount too high");
796 
797     _walletTokensWithdrawn["liq"][_msgSender()] += tokenAmount;
798 
799     _transfer(address(this), _msgSender(), tokenAmount);  
800   
801   }
802 
803   function teamWithdraw(uint256 tokenAmount) external {
804     require(_msgSender() == _teamWallet, "Unauthorized team wallet");
805 
806     // Cliff = 6 months = 262800 minutes
807     // Vesting = 20 months 876001 minutes
808     // Total = 20M
809     uint256 canWithdraw = walletCanWithdraw(_msgSender(), "team", 0, 262800, 876001, 20000000000000000000000000, _deployTime);
810     
811     require(tokenAmount <= canWithdraw, "Withdraw amount too high");
812 
813     _walletTokensWithdrawn["team"][_msgSender()] += tokenAmount;
814 
815     _transfer(address(this), _msgSender(), tokenAmount);  
816   }
817 
818   function ecosystemWithdraw(uint256 tokenAmount) external {
819     require(_msgSender() == _ecosystemWallet, "Unauthorized ecosystem wallet");
820 
821     // TGE = 5%
822     // Cliff = 1 months = 43800 minutes
823     // Vesting = 19 months = 832201 minutes
824     // Total = 25M
825     uint256 canWithdraw = walletCanWithdraw(_msgSender(), "ecosystem", 5, 43800, 832201, 25000000000000000000000000, _deployTime);
826     
827     require(tokenAmount <= canWithdraw, "Withdraw amount too high");
828 
829     _walletTokensWithdrawn["ecosystem"][_msgSender()] += tokenAmount;
830 
831     _transfer(address(this), _msgSender(), tokenAmount);  
832   }
833 
834   function reservesWithdraw(uint256 tokenAmount) external {
835     require(_msgSender() == _reservesWallet, "Unauthorized reserves wallet");
836 
837     // Cliff = 6 months = 262800 minutes
838     // Vesting = 20 months = 876001 minutes
839     // Total = 20M
840     uint256 canWithdraw = walletCanWithdraw(_msgSender(), "reserve", 0, 262800, 876001, 20000000000000000000000000, _deployTime);
841     
842     require(tokenAmount <= canWithdraw, "Withdraw amount too high");
843 
844     _walletTokensWithdrawn["reserve"][_msgSender()] += tokenAmount;
845 
846     _transfer(address(this), _msgSender(), tokenAmount);  
847   }
848 
849   function dexWithdraw(uint256 tokenAmount) external {
850     require(_msgSender() == _dexWallet, "Unauthorized dex wallet");
851 
852     uint256 hasWithdrawn = _walletTokensWithdrawn["dex"][_msgSender()];
853 
854     // Total = 2M instant
855     uint256 canWithdraw = 2000000000000000000000000 - hasWithdrawn;
856 
857     require(tokenAmount <= canWithdraw, "Withdraw amount too high");
858 
859     _walletTokensWithdrawn["dex"][_msgSender()] += tokenAmount;
860 
861     _transfer(address(this), _msgSender(), tokenAmount);    
862   }
863 
864   function buyerWithdraw(uint256 tokenAmount) external {
865     
866     // TGE = 10%
867     // Cliff = 4 months = 175200 minutes
868     // Vesting = 18 months = 788401 minutes
869     uint256 canWithdraw = walletCanWithdraw(_msgSender(), "privatesale", 10, 175200, 788401, _buyerTokens[_msgSender()], _startTime);
870     
871     require(tokenAmount <= canWithdraw, "Withdraw amount too high");
872 
873     _walletTokensWithdrawn["privatesale"][_msgSender()] += tokenAmount;
874 
875     _transfer(address(this), _msgSender(), tokenAmount);    
876   }
877 
878   //
879   // ******************* UNLOCK CALCULATION *******************
880   //
881 
882   function walletCanWithdraw(address wallet, string memory walletType, uint256 initialPercentage, uint256 cliffMinutes, uint256 vestingMinutes, uint256 totalTokens, uint256 startTime) public view returns(uint256) {
883     
884     uint256 minutesDiff = (block.timestamp - startTime).div(60);
885 
886     // Tokens already withdrawn
887     uint256 withdrawnTokens = _walletTokensWithdrawn[walletType][wallet];
888 
889     // Initial tokens
890     uint256 initialTokens = 0;
891     if (initialPercentage != 0) {
892       initialTokens = totalTokens.mul(initialPercentage).div(100);
893     }
894 
895     // Cliff not ended
896     if (minutesDiff < uint256(cliffMinutes)) {
897       return initialTokens - withdrawnTokens;
898     }
899 
900     // Tokens per minute over vesting period
901     uint256 buyerTokensPerMinute = totalTokens.sub(initialTokens).div(vestingMinutes); 
902 
903     // Advanced minutes minus cliff
904     uint256 unlockedMinutes = minutesDiff - uint256(cliffMinutes); 
905 
906     // Unlocked minutes * tokens per minutes + initial tokens
907     uint256 unlockedTokens = unlockedMinutes.mul(buyerTokensPerMinute).add(initialTokens); 
908     
909     // No extra tokens unlocked
910     if (unlockedTokens <= withdrawnTokens) {
911       return 0;
912     }
913 
914     // Check if buyer reached max
915     if (unlockedTokens > totalTokens) {
916       return totalTokens - withdrawnTokens;
917     }
918 
919     // Result
920     return unlockedTokens - withdrawnTokens;
921   }
922 
923 }