1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, with an overflow flag.
7      *
8      * _Available since v3.4._
9      */
10     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
11         unchecked {
12             uint256 c = a + b;
13             if (c < a) return (false, 0);
14             return (true, c);
15         }
16     }
17 
18     /**
19      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             if (b > a) return (false, 0);
26             return (true, a - b);
27         }
28     }
29 
30     /**
31      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38             // benefit is lost if 'b' is also tested.
39             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40             if (a == 0) return (true, 0);
41             uint256 c = a * b;
42             if (c / a != b) return (false, 0);
43             return (true, c);
44         }
45     }
46 
47     /**
48      * @dev Returns the division of two unsigned integers, with a division by zero flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             if (b == 0) return (false, 0);
55             return (true, a / b);
56         }
57     }
58 
59     /**
60      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             if (b == 0) return (false, 0);
67             return (true, a % b);
68         }
69     }
70 
71     /**
72      * @dev Returns the addition of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `+` operator.
76      *
77      * Requirements:
78      *
79      * - Addition cannot overflow.
80      */
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a + b;
83     }
84 
85     /**
86      * @dev Returns the subtraction of two unsigned integers, reverting on
87      * overflow (when the result is negative).
88      *
89      * Counterpart to Solidity's `-` operator.
90      *
91      * Requirements:
92      *
93      * - Subtraction cannot overflow.
94      */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a - b;
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      *
107      * - Multiplication cannot overflow.
108      */
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a * b;
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers, reverting on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator.
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
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
140         return a % b;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * CAUTION: This function is deprecated because it requires allocating memory for the error
148      * message unnecessarily. For custom revert reasons use {trySub}.
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(
157         uint256 a,
158         uint256 b,
159         string memory errorMessage
160     ) internal pure returns (uint256) {
161         unchecked {
162             require(b <= a, errorMessage);
163             return a - b;
164         }
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(
180         uint256 a,
181         uint256 b,
182         string memory errorMessage
183     ) internal pure returns (uint256) {
184         unchecked {
185             require(b > 0, errorMessage);
186             return a / b;
187         }
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * reverting with custom message when dividing by zero.
193      *
194      * CAUTION: This function is deprecated because it requires allocating memory for the error
195      * message unnecessarily. For custom revert reasons use {tryMod}.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(
206         uint256 a,
207         uint256 b,
208         string memory errorMessage
209     ) internal pure returns (uint256) {
210         unchecked {
211             require(b > 0, errorMessage);
212             return a % b;
213         }
214     }
215 }
216 
217 abstract contract Context {
218     function _msgSender() internal view virtual returns (address) {
219         return msg.sender;
220     }
221 
222     function _msgData() internal view virtual returns (bytes calldata) {
223         return msg.data;
224     }
225 }
226 
227 interface IERC20 {
228     /**
229      * @dev Returns the amount of tokens in existence.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns the amount of tokens owned by `account`.
235      */
236     function balanceOf(address account) external view returns (uint256);
237 
238     /**
239      * @dev Moves `amount` tokens from the caller's account to `recipient`.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transfer(address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Returns the remaining number of tokens that `spender` will be
249      * allowed to spend on behalf of `owner` through {transferFrom}. This is
250      * zero by default.
251      *
252      * This value changes when {approve} or {transferFrom} are called.
253      */
254     function allowance(address owner, address spender) external view returns (uint256);
255 
256     /**
257      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * IMPORTANT: Beware that changing an allowance with this method brings the risk
262      * that someone may use both the old and the new allowance by unfortunate
263      * transaction ordering. One possible solution to mitigate this race
264      * condition is to first reduce the spender's allowance to 0 and set the
265      * desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      *
268      * Emits an {Approval} event.
269      */
270     function approve(address spender, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Moves `amount` tokens from `sender` to `recipient` using the
274      * allowance mechanism. `amount` is then deducted from the caller's
275      * allowance.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(
282         address sender,
283         address recipient,
284         uint256 amount
285     ) external returns (bool);
286 
287     /**
288      * @dev Emitted when `value` tokens are moved from one account (`from`) to
289      * another (`to`).
290      *
291      * Note that `value` may be zero.
292      */
293     event Transfer(address indexed from, address indexed to, uint256 value);
294 
295     /**
296      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
297      * a call to {approve}. `value` is the new allowance.
298      */
299     event Approval(address indexed owner, address indexed spender, uint256 value);
300 }
301 
302 interface IERC20Metadata is IERC20 {
303     /**
304      * @dev Returns the name of the token.
305      */
306     function name() external view returns (string memory);
307 
308     /**
309      * @dev Returns the symbol of the token.
310      */
311     function symbol() external view returns (string memory);
312 
313     /**
314      * @dev Returns the decimals places of the token.
315      */
316     function decimals() external view returns (uint8);
317 }
318 
319 abstract contract Ownable is Context {
320     address private _owner;
321 
322     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
323 
324     /**
325      * @dev Initializes the contract setting the deployer as the initial owner.
326      */
327     constructor() {
328         _transferOwnership(_msgSender());
329     }
330 
331     /**
332      * @dev Returns the address of the current owner.
333      */
334     function owner() public view virtual returns (address) {
335         return _owner;
336     }
337 
338     /**
339      * @dev Throws if called by any account other than the owner.
340      */
341     modifier onlyOwner() {
342         require(owner() == _msgSender(), "Ownable: caller is not the owner");
343         _;
344     }
345 
346     /**
347      * @dev Leaves the contract without owner. It will not be possible to call
348      * `onlyOwner` functions anymore. Can only be called by the current owner.
349      *
350      * NOTE: Renouncing ownership will leave the contract without an owner,
351      * thereby removing any functionality that is only available to the owner.
352      */
353     function renounceOwnership() public virtual onlyOwner {
354         _transferOwnership(address(0));
355     }
356 
357     /**
358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
359      * Can only be called by the current owner.
360      */
361     function transferOwnership(address newOwner) public virtual onlyOwner {
362         require(newOwner != address(0), "Ownable: new owner is the zero address");
363         _transferOwnership(newOwner);
364     }
365 
366     /**
367      * @dev Transfers ownership of the contract to a new account (`newOwner`).
368      * Internal function without access restriction.
369      */
370     function _transferOwnership(address newOwner) internal virtual {
371         address oldOwner = _owner;
372         _owner = newOwner;
373         emit OwnershipTransferred(oldOwner, newOwner);
374     }
375 }
376 
377 contract ERC20 is Context, IERC20, IERC20Metadata {
378     mapping(address => uint256) private _balances;
379 
380     mapping(address => mapping(address => uint256)) private _allowances;
381 
382     uint256 private _totalSupply;
383 
384     string private _name;
385     string private _symbol;
386 
387     /**
388      * @dev Sets the values for {name} and {symbol}.
389      *
390      * The default value of {decimals} is 18. To select a different value for
391      * {decimals} you should overload it.
392      *
393      * All two of these values are immutable: they can only be set once during
394      * construction.
395      */
396     constructor(string memory name_, string memory symbol_) {
397         _name = name_;
398         _symbol = symbol_;
399     }
400 
401     /**
402      * @dev Returns the name of the token.
403      */
404     function name() public view virtual override returns (string memory) {
405         return _name;
406     }
407 
408     /**
409      * @dev Returns the symbol of the token, usually a shorter version of the
410      * name.
411      */
412     function symbol() public view virtual override returns (string memory) {
413         return _symbol;
414     }
415 
416     /**
417      * @dev Returns the number of decimals used to get its user representation.
418      * For example, if `decimals` equals `2`, a balance of `505` tokens should
419      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
420      *
421      * Tokens usually opt for a value of 18, imitating the relationship between
422      * Ether and Wei. This is the value {ERC20} uses, unless this function is
423      * overridden;
424      *
425      * NOTE: This information is only used for _display_ purposes: it in
426      * no way affects any of the arithmetic of the contract, including
427      * {IERC20-balanceOf} and {IERC20-transfer}.
428      */
429     function decimals() public view virtual override returns (uint8) {
430         return 18;
431     }
432 
433     /**
434      * @dev See {IERC20-totalSupply}.
435      */
436     function totalSupply() public view virtual override returns (uint256) {
437         return _totalSupply;
438     }
439 
440     /**
441      * @dev See {IERC20-balanceOf}.
442      */
443     function balanceOf(address account) public view virtual override returns (uint256) {
444         return _balances[account];
445     }
446 
447     /**
448      * @dev See {IERC20-transfer}.
449      *
450      * Requirements:
451      *
452      * - `recipient` cannot be the zero address.
453      * - the caller must have a balance of at least `amount`.
454      */
455     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
456         _transfer(_msgSender(), recipient, amount);
457         return true;
458     }
459 
460     /**
461      * @dev See {IERC20-allowance}.
462      */
463     function allowance(address owner, address spender) public view virtual override returns (uint256) {
464         return _allowances[owner][spender];
465     }
466 
467     /**
468      * @dev See {IERC20-approve}.
469      *
470      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
471      * `transferFrom`. This is semantically equivalent to an infinite approval.
472      *
473      * Requirements:
474      *
475      * - `spender` cannot be the zero address.
476      */
477     function approve(address spender, uint256 amount) public virtual override returns (bool) {
478         _approve(_msgSender(), spender, amount);
479         return true;
480     }
481 
482     /**
483      * @dev See {IERC20-transferFrom}.
484      *
485      * Emits an {Approval} event indicating the updated allowance. This is not
486      * required by the EIP. See the note at the beginning of {ERC20}.
487      *
488      * NOTE: Does not update the allowance if the current allowance
489      * is the maximum `uint256`.
490      *
491      * Requirements:
492      *
493      * - `sender` and `recipient` cannot be the zero address.
494      * - `sender` must have a balance of at least `amount`.
495      * - the caller must have allowance for ``sender``'s tokens of at least
496      * `amount`.
497      */
498     function transferFrom(
499         address sender,
500         address recipient,
501         uint256 amount
502     ) public virtual override returns (bool) {
503         uint256 currentAllowance = _allowances[sender][_msgSender()];
504         if (currentAllowance != type(uint256).max) {
505             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
506             unchecked {
507                 _approve(sender, _msgSender(), currentAllowance - amount);
508             }
509         }
510 
511         _transfer(sender, recipient, amount);
512 
513         return true;
514     }
515 
516     /**
517      * @dev Atomically increases the allowance granted to `spender` by the caller.
518      *
519      * This is an alternative to {approve} that can be used as a mitigation for
520      * problems described in {IERC20-approve}.
521      *
522      * Emits an {Approval} event indicating the updated allowance.
523      *
524      * Requirements:
525      *
526      * - `spender` cannot be the zero address.
527      */
528     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
529         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
530         return true;
531     }
532 
533     /**
534      * @dev Atomically decreases the allowance granted to `spender` by the caller.
535      *
536      * This is an alternative to {approve} that can be used as a mitigation for
537      * problems described in {IERC20-approve}.
538      *
539      * Emits an {Approval} event indicating the updated allowance.
540      *
541      * Requirements:
542      *
543      * - `spender` cannot be the zero address.
544      * - `spender` must have allowance for the caller of at least
545      * `subtractedValue`.
546      */
547     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
548         uint256 currentAllowance = _allowances[_msgSender()][spender];
549         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
550         unchecked {
551             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
552         }
553 
554         return true;
555     }
556 
557     /**
558      * @dev Moves `amount` of tokens from `sender` to `recipient`.
559      *
560      * This internal function is equivalent to {transfer}, and can be used to
561      * e.g. implement automatic token fees, slashing mechanisms, etc.
562      *
563      * Emits a {Transfer} event.
564      *
565      * Requirements:
566      *
567      * - `sender` cannot be the zero address.
568      * - `recipient` cannot be the zero address.
569      * - `sender` must have a balance of at least `amount`.
570      */
571     function _transfer(
572         address sender,
573         address recipient,
574         uint256 amount
575     ) internal virtual {
576         require(sender != address(0), "ERC20: transfer from the zero address");
577         require(recipient != address(0), "ERC20: transfer to the zero address");
578 
579         _beforeTokenTransfer(sender, recipient, amount);
580 
581         uint256 senderBalance = _balances[sender];
582         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
583         unchecked {
584             _balances[sender] = senderBalance - amount;
585         }
586         _balances[recipient] += amount;
587 
588         emit Transfer(sender, recipient, amount);
589 
590         _afterTokenTransfer(sender, recipient, amount);
591     }
592 
593     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
594      * the total supply.
595      *
596      * Emits a {Transfer} event with `from` set to the zero address.
597      *
598      * Requirements:
599      *
600      * - `account` cannot be the zero address.
601      */
602     function _mint(address account, uint256 amount) internal virtual {
603         require(account != address(0), "ERC20: mint to the zero address");
604 
605         _beforeTokenTransfer(address(0), account, amount);
606 
607         _totalSupply += amount;
608         _balances[account] += amount;
609         emit Transfer(address(0), account, amount);
610 
611         _afterTokenTransfer(address(0), account, amount);
612     }
613 
614     /**
615      * @dev Destroys `amount` tokens from `account`, reducing the
616      * total supply.
617      *
618      * Emits a {Transfer} event with `to` set to the zero address.
619      *
620      * Requirements:
621      *
622      * - `account` cannot be the zero address.
623      * - `account` must have at least `amount` tokens.
624      */
625     function _burn(address account, uint256 amount) internal virtual {
626         require(account != address(0), "ERC20: burn from the zero address");
627 
628         _beforeTokenTransfer(account, address(0), amount);
629 
630         uint256 accountBalance = _balances[account];
631         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
632         unchecked {
633             _balances[account] = accountBalance - amount;
634         }
635         _totalSupply -= amount;
636 
637         emit Transfer(account, address(0), amount);
638 
639         _afterTokenTransfer(account, address(0), amount);
640     }
641 
642     /**
643      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
644      *
645      * This internal function is equivalent to `approve`, and can be used to
646      * e.g. set automatic allowances for certain subsystems, etc.
647      *
648      * Emits an {Approval} event.
649      *
650      * Requirements:
651      *
652      * - `owner` cannot be the zero address.
653      * - `spender` cannot be the zero address.
654      */
655     function _approve(
656         address owner,
657         address spender,
658         uint256 amount
659     ) internal virtual {
660         require(owner != address(0), "ERC20: approve from the zero address");
661         require(spender != address(0), "ERC20: approve to the zero address");
662 
663         _allowances[owner][spender] = amount;
664         emit Approval(owner, spender, amount);
665     }
666 
667     /**
668      * @dev Hook that is called before any transfer of tokens. This includes
669      * minting and burning.
670      *
671      * Calling conditions:
672      *
673      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
674      * will be transferred to `to`.
675      * - when `from` is zero, `amount` tokens will be minted for `to`.
676      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
677      * - `from` and `to` are never both zero.
678      *
679      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
680      */
681     function _beforeTokenTransfer(
682         address from,
683         address to,
684         uint256 amount
685     ) internal virtual {}
686 
687     /**
688      * @dev Hook that is called after any transfer of tokens. This includes
689      * minting and burning.
690      *
691      * Calling conditions:
692      *
693      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
694      * has been transferred to `to`.
695      * - when `from` is zero, `amount` tokens have been minted for `to`.
696      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
697      * - `from` and `to` are never both zero.
698      *
699      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
700      */
701     function _afterTokenTransfer(
702         address from,
703         address to,
704         uint256 amount
705     ) internal virtual {}
706 }
707 
708 interface IBearMarketBuds {
709     function balanceOf(address owner) external view returns(uint256);
710 }
711 
712 interface IFreeShit {
713     function balanceOf(address owner) external view returns(uint256);
714 }
715 
716 contract BearMarketBudsToken is ERC20, Ownable {
717     using SafeMath for uint256;
718 
719     IBearMarketBuds public BearMarketBuds;
720     IFreeShit public FreeShit;
721 
722     uint256 private _totalSupply;
723     uint256 constant MAXIMUNSUPPLY = 3000000000*10**18;
724     
725     bool pauseRewards = true;
726 
727     mapping(address => uint256) public addressBearMints;
728     mapping(address => uint256) public addressShitMints;
729     mapping(address => bool) public allowedAddresses;
730 
731 
732     constructor() ERC20("BearMarketBucks", "BMBucks") {
733         BearMarketBuds = IBearMarketBuds(0x48A0501D67eb0DcccC725e33FA43e08De045816F);
734         FreeShit = IFreeShit(0x026B30564A6BeD7995Ec02bC61dBf58A92d94537);
735     }
736 
737     function burn(address user, uint256 amount) external {
738         require(allowedAddresses[msg.sender] || msg.sender == address(BearMarketBuds), "Address does not have permission to burn");
739         _burn(user, amount);
740     }
741 
742     function claimBearReward() external {
743         uint256 amount = 696969*10**18;
744         require(!pauseRewards, "Claiming reward has been paused");
745         require(BearMarketBuds.balanceOf(msg.sender) >= addressBearMints[msg.sender] + 3, "Not enough Bear Market Buds owned");
746         require((_totalSupply + amount) <= MAXIMUNSUPPLY, "Maximun supply exceeded");
747         _totalSupply = _totalSupply.add(amount);
748         addressBearMints[msg.sender] += 3;
749         _mint(msg.sender, amount);
750     }
751 
752     function claimFreeShitReward() external {
753         uint256 amount = 69696*10**18;
754         require(!pauseRewards, "Claiming reward has been paused");
755         require(FreeShit.balanceOf(msg.sender) >= addressShitMints[msg.sender] + 1, "Not enough Free Shits owned");
756         require((_totalSupply + amount) <= MAXIMUNSUPPLY, "Maximun supply exceeded");
757         _totalSupply = _totalSupply.add(amount);
758         addressShitMints[msg.sender] += 1;
759         _mint(msg.sender, amount);
760     }
761 
762     function setAllowedAddresses(address _address, bool _access) public onlyOwner {
763         allowedAddresses[_address] = _access;
764     }
765 
766     function pauseReward() public onlyOwner{
767         pauseRewards = !pauseRewards;
768     }
769 
770     function giftTokens(address reciever, uint256 giftAmount) public onlyOwner{
771         _mint(reciever, giftAmount);
772     }
773 
774     function tokenGiftList(address[] calldata giftAddresses, uint256[] calldata giftAmount) external onlyOwner {
775         for(uint256 i; i < giftAddresses.length; i++){
776             giftTokens(giftAddresses[i], giftAmount[i]);
777         }
778     }
779 }