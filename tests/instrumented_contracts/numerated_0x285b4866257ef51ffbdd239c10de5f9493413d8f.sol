1 // File: poolz-helper-v2/contracts/interfaces/IWhiteList.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 //For whitelist, 
8 interface IWhiteList {
9     function Check(address _Subject, uint256 _Id) external view returns(uint);
10     function Register(address _Subject,uint256 _Id,uint256 _Amount) external;
11     function LastRoundRegister(address _Subject,uint256 _Id) external;
12     function CreateManualWhiteList(uint256 _ChangeUntil, address _Contract) external payable returns(uint256 Id);
13     function ChangeCreator(uint256 _Id, address _NewCreator) external;
14 }
15 
16 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
17 
18 
19 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP.
25  */
26 interface IERC20 {
27     /**
28      * @dev Emitted when `value` tokens are moved from one account (`from`) to
29      * another (`to`).
30      *
31      * Note that `value` may be zero.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     /**
36      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
37      * a call to {approve}. `value` is the new allowance.
38      */
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `to`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address to, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `from` to `to` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 amount
98     ) external returns (bool);
99 }
100 
101 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface for the optional metadata functions from the ERC20 standard.
110  *
111  * _Available since v4.1._
112  */
113 interface IERC20Metadata is IERC20 {
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() external view returns (string memory);
118 
119     /**
120      * @dev Returns the symbol of the token.
121      */
122     function symbol() external view returns (string memory);
123 
124     /**
125      * @dev Returns the decimals places of the token.
126      */
127     function decimals() external view returns (uint8);
128 }
129 
130 // File: @openzeppelin/contracts/utils/Context.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Provides information about the current execution context, including the
139  * sender of the transaction and its data. While these are generally available
140  * via msg.sender and msg.data, they should not be accessed in such a direct
141  * manner, since when dealing with meta-transactions the account sending and
142  * paying for execution may not be the actual sender (as far as an application
143  * is concerned).
144  *
145  * This contract is only required for intermediate, library-like contracts.
146  */
147 abstract contract Context {
148     function _msgSender() internal view virtual returns (address) {
149         return msg.sender;
150     }
151 
152     function _msgData() internal view virtual returns (bytes calldata) {
153         return msg.data;
154     }
155 }
156 
157 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
158 
159 
160 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 
165 
166 /**
167  * @dev Implementation of the {IERC20} interface.
168  *
169  * This implementation is agnostic to the way tokens are created. This means
170  * that a supply mechanism has to be added in a derived contract using {_mint}.
171  * For a generic mechanism see {ERC20PresetMinterPauser}.
172  *
173  * TIP: For a detailed writeup see our guide
174  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
175  * to implement supply mechanisms].
176  *
177  * We have followed general OpenZeppelin Contracts guidelines: functions revert
178  * instead returning `false` on failure. This behavior is nonetheless
179  * conventional and does not conflict with the expectations of ERC20
180  * applications.
181  *
182  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
183  * This allows applications to reconstruct the allowance for all accounts just
184  * by listening to said events. Other implementations of the EIP may not emit
185  * these events, as it isn't required by the specification.
186  *
187  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
188  * functions have been added to mitigate the well-known issues around setting
189  * allowances. See {IERC20-approve}.
190  */
191 contract ERC20 is Context, IERC20, IERC20Metadata {
192     mapping(address => uint256) private _balances;
193 
194     mapping(address => mapping(address => uint256)) private _allowances;
195 
196     uint256 private _totalSupply;
197 
198     string private _name;
199     string private _symbol;
200 
201     /**
202      * @dev Sets the values for {name} and {symbol}.
203      *
204      * The default value of {decimals} is 18. To select a different value for
205      * {decimals} you should overload it.
206      *
207      * All two of these values are immutable: they can only be set once during
208      * construction.
209      */
210     constructor(string memory name_, string memory symbol_) {
211         _name = name_;
212         _symbol = symbol_;
213     }
214 
215     /**
216      * @dev Returns the name of the token.
217      */
218     function name() public view virtual override returns (string memory) {
219         return _name;
220     }
221 
222     /**
223      * @dev Returns the symbol of the token, usually a shorter version of the
224      * name.
225      */
226     function symbol() public view virtual override returns (string memory) {
227         return _symbol;
228     }
229 
230     /**
231      * @dev Returns the number of decimals used to get its user representation.
232      * For example, if `decimals` equals `2`, a balance of `505` tokens should
233      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
234      *
235      * Tokens usually opt for a value of 18, imitating the relationship between
236      * Ether and Wei. This is the value {ERC20} uses, unless this function is
237      * overridden;
238      *
239      * NOTE: This information is only used for _display_ purposes: it in
240      * no way affects any of the arithmetic of the contract, including
241      * {IERC20-balanceOf} and {IERC20-transfer}.
242      */
243     function decimals() public view virtual override returns (uint8) {
244         return 18;
245     }
246 
247     /**
248      * @dev See {IERC20-totalSupply}.
249      */
250     function totalSupply() public view virtual override returns (uint256) {
251         return _totalSupply;
252     }
253 
254     /**
255      * @dev See {IERC20-balanceOf}.
256      */
257     function balanceOf(address account) public view virtual override returns (uint256) {
258         return _balances[account];
259     }
260 
261     /**
262      * @dev See {IERC20-transfer}.
263      *
264      * Requirements:
265      *
266      * - `to` cannot be the zero address.
267      * - the caller must have a balance of at least `amount`.
268      */
269     function transfer(address to, uint256 amount) public virtual override returns (bool) {
270         address owner = _msgSender();
271         _transfer(owner, to, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-allowance}.
277      */
278     function allowance(address owner, address spender) public view virtual override returns (uint256) {
279         return _allowances[owner][spender];
280     }
281 
282     /**
283      * @dev See {IERC20-approve}.
284      *
285      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
286      * `transferFrom`. This is semantically equivalent to an infinite approval.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function approve(address spender, uint256 amount) public virtual override returns (bool) {
293         address owner = _msgSender();
294         _approve(owner, spender, amount);
295         return true;
296     }
297 
298     /**
299      * @dev See {IERC20-transferFrom}.
300      *
301      * Emits an {Approval} event indicating the updated allowance. This is not
302      * required by the EIP. See the note at the beginning of {ERC20}.
303      *
304      * NOTE: Does not update the allowance if the current allowance
305      * is the maximum `uint256`.
306      *
307      * Requirements:
308      *
309      * - `from` and `to` cannot be the zero address.
310      * - `from` must have a balance of at least `amount`.
311      * - the caller must have allowance for ``from``'s tokens of at least
312      * `amount`.
313      */
314     function transferFrom(
315         address from,
316         address to,
317         uint256 amount
318     ) public virtual override returns (bool) {
319         address spender = _msgSender();
320         _spendAllowance(from, spender, amount);
321         _transfer(from, to, amount);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically increases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
338         address owner = _msgSender();
339         _approve(owner, spender, allowance(owner, spender) + addedValue);
340         return true;
341     }
342 
343     /**
344      * @dev Atomically decreases the allowance granted to `spender` by the caller.
345      *
346      * This is an alternative to {approve} that can be used as a mitigation for
347      * problems described in {IERC20-approve}.
348      *
349      * Emits an {Approval} event indicating the updated allowance.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      * - `spender` must have allowance for the caller of at least
355      * `subtractedValue`.
356      */
357     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
358         address owner = _msgSender();
359         uint256 currentAllowance = allowance(owner, spender);
360         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
361         unchecked {
362             _approve(owner, spender, currentAllowance - subtractedValue);
363         }
364 
365         return true;
366     }
367 
368     /**
369      * @dev Moves `amount` of tokens from `from` to `to`.
370      *
371      * This internal function is equivalent to {transfer}, and can be used to
372      * e.g. implement automatic token fees, slashing mechanisms, etc.
373      *
374      * Emits a {Transfer} event.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `from` must have a balance of at least `amount`.
381      */
382     function _transfer(
383         address from,
384         address to,
385         uint256 amount
386     ) internal virtual {
387         require(from != address(0), "ERC20: transfer from the zero address");
388         require(to != address(0), "ERC20: transfer to the zero address");
389 
390         _beforeTokenTransfer(from, to, amount);
391 
392         uint256 fromBalance = _balances[from];
393         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
394         unchecked {
395             _balances[from] = fromBalance - amount;
396         }
397         _balances[to] += amount;
398 
399         emit Transfer(from, to, amount);
400 
401         _afterTokenTransfer(from, to, amount);
402     }
403 
404     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
405      * the total supply.
406      *
407      * Emits a {Transfer} event with `from` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      */
413     function _mint(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: mint to the zero address");
415 
416         _beforeTokenTransfer(address(0), account, amount);
417 
418         _totalSupply += amount;
419         _balances[account] += amount;
420         emit Transfer(address(0), account, amount);
421 
422         _afterTokenTransfer(address(0), account, amount);
423     }
424 
425     /**
426      * @dev Destroys `amount` tokens from `account`, reducing the
427      * total supply.
428      *
429      * Emits a {Transfer} event with `to` set to the zero address.
430      *
431      * Requirements:
432      *
433      * - `account` cannot be the zero address.
434      * - `account` must have at least `amount` tokens.
435      */
436     function _burn(address account, uint256 amount) internal virtual {
437         require(account != address(0), "ERC20: burn from the zero address");
438 
439         _beforeTokenTransfer(account, address(0), amount);
440 
441         uint256 accountBalance = _balances[account];
442         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
443         unchecked {
444             _balances[account] = accountBalance - amount;
445         }
446         _totalSupply -= amount;
447 
448         emit Transfer(account, address(0), amount);
449 
450         _afterTokenTransfer(account, address(0), amount);
451     }
452 
453     /**
454      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
455      *
456      * This internal function is equivalent to `approve`, and can be used to
457      * e.g. set automatic allowances for certain subsystems, etc.
458      *
459      * Emits an {Approval} event.
460      *
461      * Requirements:
462      *
463      * - `owner` cannot be the zero address.
464      * - `spender` cannot be the zero address.
465      */
466     function _approve(
467         address owner,
468         address spender,
469         uint256 amount
470     ) internal virtual {
471         require(owner != address(0), "ERC20: approve from the zero address");
472         require(spender != address(0), "ERC20: approve to the zero address");
473 
474         _allowances[owner][spender] = amount;
475         emit Approval(owner, spender, amount);
476     }
477 
478     /**
479      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
480      *
481      * Does not update the allowance amount in case of infinite allowance.
482      * Revert if not enough allowance is available.
483      *
484      * Might emit an {Approval} event.
485      */
486     function _spendAllowance(
487         address owner,
488         address spender,
489         uint256 amount
490     ) internal virtual {
491         uint256 currentAllowance = allowance(owner, spender);
492         if (currentAllowance != type(uint256).max) {
493             require(currentAllowance >= amount, "ERC20: insufficient allowance");
494             unchecked {
495                 _approve(owner, spender, currentAllowance - amount);
496             }
497         }
498     }
499 
500     /**
501      * @dev Hook that is called before any transfer of tokens. This includes
502      * minting and burning.
503      *
504      * Calling conditions:
505      *
506      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
507      * will be transferred to `to`.
508      * - when `from` is zero, `amount` tokens will be minted for `to`.
509      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
510      * - `from` and `to` are never both zero.
511      *
512      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
513      */
514     function _beforeTokenTransfer(
515         address from,
516         address to,
517         uint256 amount
518     ) internal virtual {}
519 
520     /**
521      * @dev Hook that is called after any transfer of tokens. This includes
522      * minting and burning.
523      *
524      * Calling conditions:
525      *
526      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
527      * has been transferred to `to`.
528      * - when `from` is zero, `amount` tokens have been minted for `to`.
529      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
530      * - `from` and `to` are never both zero.
531      *
532      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
533      */
534     function _afterTokenTransfer(
535         address from,
536         address to,
537         uint256 amount
538     ) internal virtual {}
539 }
540 
541 // File: poolz-helper-v2/contracts/ERC20Helper.sol
542 
543 
544 
545 pragma solidity ^0.8.0;
546 contract ERC20Helper {
547     event TransferOut(uint256 Amount, address To, address Token);
548     event TransferIn(uint256 Amount, address From, address Token);
549     modifier TestAllownce(
550         address _token,
551         address _owner,
552         uint256 _amount
553     ) {
554         require(
555             ERC20(_token).allowance(_owner, address(this)) >= _amount,
556             "no allowance"
557         );
558         _;
559     }
560 
561     function TransferToken(
562         address _Token,
563         address _Reciver,
564         uint256 _Amount
565     ) internal {
566         uint256 OldBalance = CheckBalance(_Token, address(this));
567         emit TransferOut(_Amount, _Reciver, _Token);
568         ERC20(_Token).transfer(_Reciver, _Amount);
569         require(
570             (CheckBalance(_Token, address(this)) + _Amount) == OldBalance,
571             "recive wrong amount of tokens"
572         );
573     }
574 
575     function CheckBalance(address _Token, address _Subject)
576         internal
577         view
578         returns (uint256)
579     {
580         return ERC20(_Token).balanceOf(_Subject);
581     }
582 
583     function TransferInToken(
584         address _Token,
585         address _Subject,
586         uint256 _Amount
587     ) internal TestAllownce(_Token, _Subject, _Amount) {
588         require(_Amount > 0);
589         uint256 OldBalance = CheckBalance(_Token, address(this));
590         ERC20(_Token).transferFrom(_Subject, address(this), _Amount);
591         emit TransferIn(_Amount, _Subject, _Token);
592         require(
593             (OldBalance + _Amount) == CheckBalance(_Token, address(this)),
594             "recive wrong amount of tokens"
595         );
596     }
597 
598     function ApproveAllowanceERC20(
599         address _Token,
600         address _Subject,
601         uint256 _Amount
602     ) internal {
603         require(_Amount > 0);
604         ERC20(_Token).approve(_Subject, _Amount);
605     }
606 }
607 
608 // File: @openzeppelin/contracts/access/Ownable.sol
609 
610 
611 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @dev Contract module which provides a basic access control mechanism, where
617  * there is an account (an owner) that can be granted exclusive access to
618  * specific functions.
619  *
620  * By default, the owner account will be the one that deploys the contract. This
621  * can later be changed with {transferOwnership}.
622  *
623  * This module is used through inheritance. It will make available the modifier
624  * `onlyOwner`, which can be applied to your functions to restrict their use to
625  * the owner.
626  */
627 abstract contract Ownable is Context {
628     address private _owner;
629 
630     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
631 
632     /**
633      * @dev Initializes the contract setting the deployer as the initial owner.
634      */
635     constructor() {
636         _transferOwnership(_msgSender());
637     }
638 
639     /**
640      * @dev Throws if called by any account other than the owner.
641      */
642     modifier onlyOwner() {
643         _checkOwner();
644         _;
645     }
646 
647     /**
648      * @dev Returns the address of the current owner.
649      */
650     function owner() public view virtual returns (address) {
651         return _owner;
652     }
653 
654     /**
655      * @dev Throws if the sender is not the owner.
656      */
657     function _checkOwner() internal view virtual {
658         require(owner() == _msgSender(), "Ownable: caller is not the owner");
659     }
660 
661     /**
662      * @dev Leaves the contract without owner. It will not be possible to call
663      * `onlyOwner` functions anymore. Can only be called by the current owner.
664      *
665      * NOTE: Renouncing ownership will leave the contract without an owner,
666      * thereby removing any functionality that is only available to the owner.
667      */
668     function renounceOwnership() public virtual onlyOwner {
669         _transferOwnership(address(0));
670     }
671 
672     /**
673      * @dev Transfers ownership of the contract to a new account (`newOwner`).
674      * Can only be called by the current owner.
675      */
676     function transferOwnership(address newOwner) public virtual onlyOwner {
677         require(newOwner != address(0), "Ownable: new owner is the zero address");
678         _transferOwnership(newOwner);
679     }
680 
681     /**
682      * @dev Transfers ownership of the contract to a new account (`newOwner`).
683      * Internal function without access restriction.
684      */
685     function _transferOwnership(address newOwner) internal virtual {
686         address oldOwner = _owner;
687         _owner = newOwner;
688         emit OwnershipTransferred(oldOwner, newOwner);
689     }
690 }
691 
692 // File: poolz-helper-v2/contracts/GovManager.sol
693 
694 
695 
696 pragma solidity ^0.8.0;
697 contract GovManager is Ownable {
698     address public GovernerContract;
699 
700     modifier onlyOwnerOrGov() {
701         require(
702             msg.sender == owner() || msg.sender == GovernerContract,
703             "Authorization Error"
704         );
705         _;
706     }
707 
708     function setGovernerContract(address _address) external onlyOwnerOrGov {
709         GovernerContract = _address;
710     }
711 
712     constructor() {
713         GovernerContract = address(0);
714     }
715 }
716 
717 // File: poolz-helper-v2/contracts/FeeBaseHelper.sol
718 
719 
720 pragma solidity ^0.8.0;
721 contract FeeBaseHelper is ERC20Helper, GovManager {
722     event TransferInETH(uint256 Amount, address From);
723     event NewFeeAmount(uint256 NewFeeAmount, uint256 OldFeeAmount);
724     event NewFeeToken(address NewFeeToken, address OldFeeToken);
725 
726     uint256 public Fee;
727     address public FeeToken;
728     mapping(address => uint256) public Reserve;
729 
730     function PayFee(uint256 _fee) public payable {
731         if (_fee == 0) return;
732         if (FeeToken == address(0)) {
733             require(msg.value >= _fee, "Not Enough Fee Provided");
734             emit TransferInETH(msg.value, msg.sender);
735         } else {
736             TransferInToken(FeeToken, msg.sender, _fee);
737         }
738         Reserve[FeeToken] += _fee;
739     }
740 
741     function SetFeeAmount(uint256 _amount) public onlyOwnerOrGov {
742         require(Fee != _amount, "Can't swap to same fee value");
743         emit NewFeeAmount(_amount, Fee);
744         Fee = _amount;
745     }
746 
747     function SetFeeToken(address _token) public onlyOwnerOrGov {
748         require(FeeToken != _token, "Can't swap to same token");
749         emit NewFeeToken(_token, FeeToken);
750         FeeToken = _token; // set address(0) to use ETH/BNB as main coin
751     }
752 
753     function WithdrawFee(address _token, address _to) public onlyOwnerOrGov {
754         require(Reserve[_token] > 0, "Fee amount is zero");
755         if (_token == address(0)) {
756             payable(_to).transfer(Reserve[_token]);
757         } else {
758             TransferToken(_token, _to, Reserve[_token]);
759         }
760         Reserve[_token] = 0;
761     }
762 }
763 
764 // File: contracts/LockedDealEvents.sol
765 
766 
767 pragma solidity ^0.8.0;
768 
769 contract LockedDealEvents {
770     event TokenWithdrawn(
771         uint256 PoolId,
772         address indexed Recipient,
773         uint256 Amount,
774         uint256 LeftAmount
775     );
776     event MassPoolsCreated(uint256 FirstPoolId, uint256 LastPoolId);
777     event NewPoolCreated(
778         uint256 PoolId,
779         address indexed Token,
780         uint256 StartTime,
781         uint256 CliffTime,
782         uint256 FinishTime,
783         uint256 StartAmount,
784         uint256 DebitedAmount,
785         address indexed Owner
786     );
787     event PoolApproval(uint256 PoolId, address indexed Spender, uint256 Amount);
788     event PoolSplit(
789         uint256 OldPoolId,
790         uint256 NewPoolId,
791         uint256 OriginalLeftAmount,
792         uint256 NewAmount,
793         address indexed OldOwner,
794         address indexed NewOwner
795     );
796 }
797 
798 // File: contracts/LockedDealModifiers.sol
799 
800 
801 pragma solidity ^0.8.0;
802 
803 /// @title contains modifiers and stores variables.
804 contract LockedDealModifiers {
805     mapping(uint256 => mapping(address => uint256)) public Allowance;
806     mapping(uint256 => Pool) public AllPoolz;
807     mapping(address => uint256[]) public MyPoolz;
808     uint256 public Index;
809 
810     address public WhiteList_Address;
811     bool public isTokenFilterOn; // use to enable/disable token filter
812     uint256 public TokenFeeWhiteListId;
813     uint256 public TokenFilterWhiteListId;
814     uint256 public UserWhiteListId;
815     uint256 public maxTransactionLimit;
816 
817     struct Pool {
818         uint256 StartTime;
819         uint256 CliffTime;
820         uint256 FinishTime;
821         uint256 StartAmount;
822         uint256 DebitedAmount; // withdrawn amount
823         address Owner;
824         address Token;
825     }
826 
827     modifier notZeroAddress(address _address) {
828         require(_address != address(0x0), "Zero Address is not allowed");
829         _;
830     }
831 
832     modifier isPoolValid(uint256 _PoolId) {
833         require(_PoolId < Index, "Pool does not exist");
834         _;
835     }
836 
837     modifier notZeroValue(uint256 _Amount) {
838         require(_Amount > 0, "Amount must be greater than zero");
839         _;
840     }
841 
842     modifier isPoolOwner(uint256 _PoolId) {
843         require(
844             AllPoolz[_PoolId].Owner == msg.sender,
845             "You are not Pool Owner"
846         );
847         _;
848     }
849 
850     modifier isAllowed(uint256 _PoolId, uint256 _amount) {
851         require(
852             _amount <= Allowance[_PoolId][msg.sender],
853             "Not enough Allowance"
854         );
855         _;
856     }
857 
858     modifier isBelowLimit(uint256 _num) {
859         require(
860             _num > 0 && _num <= maxTransactionLimit,
861             "Invalid array length limit"
862         );
863         _;
864     }
865 }
866 
867 // File: contracts/LockedManageable.sol
868 
869 
870 pragma solidity ^0.8.0;
871 
872 
873 
874 
875 contract LockedManageable is
876     FeeBaseHelper,
877     LockedDealEvents,
878     LockedDealModifiers
879 {
880     constructor() {
881         maxTransactionLimit = 400;
882         isTokenFilterOn = false; // disable token filter whitelist
883     }
884 
885     function setWhiteListAddress(address _address) external onlyOwner {
886         WhiteList_Address = _address;
887     }
888 
889     function setTokenFeeWhiteListId(uint256 _id) external onlyOwner {
890         TokenFeeWhiteListId = _id;
891     }
892 
893     function setTokenFilterWhiteListId(uint256 _id) external onlyOwner {
894         TokenFilterWhiteListId = _id;
895     }
896 
897     function setUserWhiteListId(uint256 _id) external onlyOwner {
898         UserWhiteListId = _id;
899     }
900 
901     function swapTokenFilter() external onlyOwner {
902         isTokenFilterOn = !isTokenFilterOn;
903     }
904 
905     function isTokenWithFee(address _tokenAddress) public view returns (bool) {
906         return
907             WhiteList_Address == address(0) ||
908             !(IWhiteList(WhiteList_Address).Check(
909                 _tokenAddress,
910                 TokenFeeWhiteListId
911             ) > 0);
912     }
913 
914     function isTokenWhiteListed(address _tokenAddress)
915         public
916         view
917         returns (bool)
918     {
919         return
920             WhiteList_Address == address(0) ||
921             !isTokenFilterOn ||
922             IWhiteList(WhiteList_Address).Check(
923                 _tokenAddress,
924                 TokenFilterWhiteListId
925             ) >
926             0;
927     }
928 
929     function isUserPaysFee(address _UserAddress) public view returns (bool) {
930         return
931             WhiteList_Address == address(0) ||
932             !(IWhiteList(WhiteList_Address).Check(
933                 _UserAddress,
934                 UserWhiteListId
935             ) > 0);
936     }
937 
938     function setMaxTransactionLimit(uint256 _newLimit) external onlyOwner {
939         maxTransactionLimit = _newLimit;
940     }
941 }
942 
943 // File: contracts/LockedPoolz.sol
944 
945 
946 pragma solidity ^0.8.0;
947 
948 contract LockedPoolz is LockedManageable {
949     modifier isTokenValid(address _Token) {
950         require(isTokenWhiteListed(_Token), "Need Valid ERC20 Token"); //check if _Token is ERC20
951         _;
952     }
953 
954     function SplitPool(
955         uint256 _PoolId,
956         uint256 _NewAmount,
957         address _NewOwner
958     ) internal returns (uint256 newPoolId) {
959         uint256 leftAmount = remainingAmount(_PoolId);
960         require(leftAmount > 0, "Pool is Empty");
961         require(leftAmount >= _NewAmount, "Not Enough Amount Balance");
962         assert(_NewAmount * 10**18 > _NewAmount);
963         Pool storage pool = AllPoolz[_PoolId];
964         uint256 _Ratio = (_NewAmount * 10**18) / leftAmount;
965         uint256 newPoolDebitedAmount = (pool.DebitedAmount * _Ratio) / 10**18;
966         uint256 newPoolStartAmount = (pool.StartAmount * _Ratio) / 10**18;
967         pool.StartAmount -= newPoolStartAmount;
968         pool.DebitedAmount -= newPoolDebitedAmount;
969         newPoolId = CreatePool(
970             pool.Token,
971             pool.StartTime,
972             pool.CliffTime,
973             pool.FinishTime,
974             newPoolStartAmount,
975             newPoolDebitedAmount,
976             _NewOwner
977         );
978         emit PoolSplit(
979             _PoolId,
980             newPoolId,
981             remainingAmount(_PoolId),
982             _NewAmount,
983             msg.sender,
984             _NewOwner
985         );
986     }
987 
988     //create a new pool
989     function CreatePool(
990         address _Token, // token to lock address
991         uint256 _StartTime, // Until what time the pool will Start
992         uint256 _CliffTime, // Before CliffTime can't withdraw tokens
993         uint256 _FinishTime, // Until what time the pool will end
994         uint256 _StartAmount, // Total amount of the tokens to sell in the pool
995         uint256 _DebitedAmount, // Withdrawn amount
996         address _Owner // Who the tokens belong to
997     ) internal isTokenValid(_Token) returns (uint256 poolId) {
998         require(
999             _StartTime <= _FinishTime,
1000             "StartTime is greater than FinishTime"
1001         );
1002         //register the pool
1003         AllPoolz[Index] = Pool(
1004             _StartTime,
1005             _CliffTime,
1006             _FinishTime,
1007             _StartAmount,
1008             _DebitedAmount,
1009             _Owner,
1010             _Token
1011         );
1012         MyPoolz[_Owner].push(Index);
1013         emit NewPoolCreated(
1014             Index,
1015             _Token,
1016             _StartTime,
1017             _CliffTime,
1018             _FinishTime,
1019             _StartAmount,
1020             _DebitedAmount,
1021             _Owner
1022         );
1023         poolId = Index;
1024         Index++;
1025     }
1026 
1027     function remainingAmount(uint256 _PoolId)
1028         internal
1029         view
1030         returns (uint256 amount)
1031     {
1032         amount =
1033             AllPoolz[_PoolId].StartAmount -
1034             AllPoolz[_PoolId].DebitedAmount;
1035     }
1036 }
1037 
1038 // File: poolz-helper-v2/contracts/Array.sol
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 /// @title contains array utility functions
1043 library Array {
1044     /// @dev returns a new slice of the array
1045     function KeepNElementsInArray(uint256[] memory _arr, uint256 _n)
1046         internal
1047         pure
1048         returns (uint256[] memory newArray)
1049     {
1050         if (_arr.length == _n) return _arr;
1051         require(_arr.length > _n, "can't cut more then got");
1052         newArray = new uint256[](_n);
1053         for (uint256 i = 0; i < _n; i++) {
1054             newArray[i] = _arr[i];
1055         }
1056         return newArray;
1057     }
1058 
1059     function KeepNElementsInArray(address[] memory _arr, uint256 _n)
1060         internal
1061         pure
1062         returns (address[] memory newArray)
1063     {
1064         if (_arr.length == _n) return _arr;
1065         require(_arr.length > _n, "can't cut more then got");
1066         newArray = new address[](_n);
1067         for (uint256 i = 0; i < _n; i++) {
1068             newArray[i] = _arr[i];
1069         }
1070         return newArray;
1071     }
1072 
1073     /// @return true if the array is ordered
1074     function isArrayOrdered(uint256[] memory _arr)
1075         internal
1076         pure
1077         returns (bool)
1078     {
1079         require(_arr.length > 0, "array should be greater than zero");
1080         uint256 temp = _arr[0];
1081         for (uint256 i = 1; i < _arr.length; i++) {
1082             if (temp > _arr[i]) {
1083                 return false;
1084             }
1085             temp = _arr[i];
1086         }
1087         return true;
1088     }
1089 
1090     /// @return sum of the array elements
1091     function getArraySum(uint256[] memory _array)
1092         internal
1093         pure
1094         returns (uint256)
1095     {
1096         uint256 sum = 0;
1097         for (uint256 i = 0; i < _array.length; i++) {
1098             sum = sum + _array[i];
1099         }
1100         return sum;
1101     }
1102 
1103     /// @return true if the element exists in the array
1104     function isInArray(address[] memory _arr, address _elem)
1105         internal
1106         pure
1107         returns (bool)
1108     {
1109         for (uint256 i = 0; i < _arr.length; i++) {
1110             if (_arr[i] == _elem) return true;
1111         }
1112         return false;
1113     }
1114 
1115     function addIfNotExsist(address[] storage _arr, address _elem) internal {
1116         if (!Array.isInArray(_arr, _elem)) {
1117             _arr.push(_elem);
1118         }
1119     }
1120 }
1121 // File: contracts/LockedCreation.sol
1122 
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 
1127 contract LockedCreation is LockedPoolz {
1128     function CreateNewPool(
1129         address _Token, //token to lock address
1130         uint256 _StartTime, //Until what time the pool will start
1131         uint256 _CliffTime, //Before CliffTime can't withdraw tokens
1132         uint256 _FinishTime, //Until what time the pool will end
1133         uint256 _StartAmount, //Total amount of the tokens to sell in the pool
1134         address _Owner // Who the tokens belong to
1135     ) external payable notZeroAddress(_Owner) notZeroValue(_StartAmount) {
1136         TransferInToken(_Token, msg.sender, _StartAmount);
1137         payFee(_Token, Fee);
1138         CreatePool(
1139             _Token,
1140             _StartTime,
1141             _CliffTime,
1142             _FinishTime,
1143             _StartAmount,
1144             0,
1145             _Owner
1146         );
1147     }
1148 
1149     function CreateMassPools(
1150         address _Token,
1151         uint256[] calldata _StartTime,
1152         uint256[] calldata _CliffTime,
1153         uint256[] calldata _FinishTime,
1154         uint256[] calldata _StartAmount,
1155         address[] calldata _Owner
1156     ) external payable isBelowLimit(_Owner.length) {
1157         require(_Owner.length == _FinishTime.length, "Date Array Invalid");
1158         require(_StartTime.length == _FinishTime.length, "Date Array Invalid");
1159         require(_Owner.length == _StartAmount.length, "Amount Array Invalid");
1160         require(_CliffTime.length == _FinishTime.length,"CliffTime Array Invalid");
1161         TransferInToken(_Token, msg.sender, Array.getArraySum(_StartAmount));
1162         payFee(_Token, Fee * _Owner.length);
1163         uint256 firstPoolId = Index;
1164         for (uint256 i = 0; i < _Owner.length; i++) {
1165             CreatePool(
1166                 _Token,
1167                 _StartTime[i],
1168                 _CliffTime[i],
1169                 _FinishTime[i],
1170                 _StartAmount[i],
1171                 0,
1172                 _Owner[i]
1173             );
1174         }
1175         uint256 lastPoolId = Index - 1;
1176         emit MassPoolsCreated(firstPoolId, lastPoolId);
1177     }
1178 
1179     // create pools with respect to finish time
1180     function CreatePoolsWrtTime(
1181         address _Token,
1182         uint256[] calldata _StartTime,
1183         uint256[] calldata _CliffTime,
1184         uint256[] calldata _FinishTime,
1185         uint256[] calldata _StartAmount,
1186         address[] calldata _Owner
1187     ) external payable isBelowLimit(_Owner.length * _FinishTime.length) {
1188         require(_Owner.length == _StartAmount.length, "Amount Array Invalid");
1189         require(_FinishTime.length == _StartTime.length, "Date Array Invalid");
1190         require(_CliffTime.length == _FinishTime.length, "CliffTime Array Invalid");
1191         TransferInToken(
1192             _Token,
1193             msg.sender,
1194             Array.getArraySum(_StartAmount) * _FinishTime.length
1195         );
1196         uint256 firstPoolId = Index;
1197         payFee(_Token, Fee * _Owner.length * _FinishTime.length);
1198         for (uint256 i = 0; i < _FinishTime.length; i++) {
1199             for (uint256 j = 0; j < _Owner.length; j++) {
1200                 CreatePool(
1201                     _Token,
1202                     _StartTime[i],
1203                     _CliffTime[i],
1204                     _FinishTime[i],
1205                     _StartAmount[j],
1206                     0,
1207                     _Owner[j]
1208                 );
1209             }
1210         }
1211         uint256 lastPoolId = Index - 1;
1212         emit MassPoolsCreated(firstPoolId, lastPoolId);
1213     }
1214 
1215     function payFee(address _token, uint256 _amount) internal {
1216         if (isTokenWithFee(_token) && isUserPaysFee(msg.sender)) {
1217             PayFee(_amount);
1218         }
1219     }
1220 }
1221 
1222 // File: contracts/LockedControl.sol
1223 
1224 
1225 pragma solidity ^0.8.0;
1226 
1227 contract LockedControl is LockedCreation {
1228     function TransferPoolOwnership(uint256 _PoolId, address _NewOwner)
1229         external
1230         isPoolValid(_PoolId)
1231         isPoolOwner(_PoolId)
1232         notZeroAddress(_NewOwner)
1233         returns (uint256 newPoolId)
1234     {
1235         Pool storage pool = AllPoolz[_PoolId];
1236         require(_NewOwner != pool.Owner, "Can't be the same owner");
1237         uint256 _remainingAmount = remainingAmount(_PoolId);
1238         newPoolId = SplitPool(_PoolId, _remainingAmount, _NewOwner);
1239     }
1240 
1241     function SplitPoolAmount(
1242         uint256 _PoolId,
1243         uint256 _NewAmount,
1244         address _NewOwner
1245     )
1246         external
1247         isPoolValid(_PoolId)
1248         isPoolOwner(_PoolId)
1249         notZeroValue(_NewAmount)
1250         notZeroAddress(_NewOwner)
1251         returns (uint256)
1252     {
1253         return SplitPool(_PoolId, _NewAmount, _NewOwner);
1254     }
1255 
1256     function ApproveAllowance(
1257         uint256 _PoolId,
1258         uint256 _Amount,
1259         address _Spender
1260     )
1261         external
1262         isPoolValid(_PoolId)
1263         isPoolOwner(_PoolId)
1264         notZeroAddress(_Spender)
1265     {
1266         Allowance[_PoolId][_Spender] = _Amount;
1267         emit PoolApproval(_PoolId, _Spender, _Amount);
1268     }
1269 
1270     function SplitPoolAmountFrom(
1271         uint256 _PoolId,
1272         uint256 _Amount,
1273         address _Address
1274     )
1275         external
1276         isPoolValid(_PoolId)
1277         isAllowed(_PoolId, _Amount)
1278         notZeroValue(_Amount)
1279         notZeroAddress(_Address)
1280         returns (uint256 poolId)
1281     {
1282         poolId = SplitPool(_PoolId, _Amount, _Address);
1283         uint256 _NewAmount = Allowance[_PoolId][msg.sender] - _Amount;
1284         Allowance[_PoolId][msg.sender] = _NewAmount;
1285     }
1286 }
1287 
1288 // File: contracts/LockedPoolzData.sol
1289 
1290 
1291 pragma solidity ^0.8.0;
1292 
1293 contract LockedPoolzData is LockedControl {
1294     function GetAllMyPoolsId(address _UserAddress)
1295         public
1296         view
1297         returns (uint256[] memory)
1298     {
1299         return MyPoolz[_UserAddress];
1300     }
1301 
1302     // function GetMyPoolzwithBalance
1303     function GetMyPoolsId(address _UserAddress)
1304         public
1305         view
1306         returns (uint256[] memory)
1307     {
1308         uint256[] storage allIds = MyPoolz[_UserAddress];
1309         uint256[] memory ids = new uint256[](allIds.length);
1310         uint256 index;
1311         for (uint256 i = 0; i < allIds.length; i++) {
1312             if (
1313                 AllPoolz[allIds[i]].StartAmount >
1314                 AllPoolz[allIds[i]].DebitedAmount
1315             ) {
1316                 ids[index++] = allIds[i];
1317             }
1318         }
1319         return Array.KeepNElementsInArray(ids, index);
1320     }
1321 
1322     function GetPoolsData(uint256[] memory _ids)
1323         public
1324         view
1325         returns (Pool[] memory data)
1326     {
1327         data = new Pool[](_ids.length);
1328         for (uint256 i = 0; i < _ids.length; i++) {
1329             require(_ids[i] < Index, "Pool does not exist");
1330             data[i] = Pool(
1331                 AllPoolz[_ids[i]].StartTime,
1332                 AllPoolz[_ids[i]].CliffTime,
1333                 AllPoolz[_ids[i]].FinishTime,
1334                 AllPoolz[_ids[i]].StartAmount,
1335                 AllPoolz[_ids[i]].DebitedAmount,
1336                 AllPoolz[_ids[i]].Owner,
1337                 AllPoolz[_ids[i]].Token
1338             );
1339         }
1340     }
1341 
1342     function GetMyPoolsIdByToken(address _UserAddress, address[] memory _Tokens)
1343         public
1344         view
1345         returns (uint256[] memory)
1346     {
1347         uint256[] storage allIds = MyPoolz[_UserAddress];
1348         uint256[] memory ids = new uint256[](allIds.length);
1349         uint256 index;
1350         for (uint256 i = 0; i < allIds.length; i++) {
1351             if (Array.isInArray(_Tokens, AllPoolz[allIds[i]].Token)) {
1352                 ids[index++] = allIds[i];
1353             }
1354         }
1355         return Array.KeepNElementsInArray(ids, index);
1356     }
1357 
1358     function GetMyPoolDataByToken(
1359         address _UserAddress,
1360         address[] memory _Tokens
1361     ) external view returns (Pool[] memory pools, uint256[] memory poolIds) {
1362         poolIds = GetMyPoolsIdByToken(_UserAddress, _Tokens);
1363         pools = GetPoolsData(poolIds);
1364     }
1365 
1366     function GetMyPoolsData(address _UserAddress)
1367         external
1368         view
1369         returns (Pool[] memory data)
1370     {
1371         data = GetPoolsData(GetMyPoolsId(_UserAddress));
1372     }
1373 
1374     function GetAllMyPoolsData(address _UserAddress)
1375         external
1376         view
1377         returns (Pool[] memory data)
1378     {
1379         data = GetPoolsData(GetAllMyPoolsId(_UserAddress));
1380     }
1381 }
1382 
1383 // File: contracts/LockedDealV2.sol
1384 
1385 
1386 pragma solidity ^0.8.0;
1387 
1388 contract LockedDealV2 is LockedPoolzData {
1389     function getWithdrawableAmount(uint256 _PoolId)
1390         public
1391         view
1392         isPoolValid(_PoolId)
1393         returns (uint256)
1394     {
1395         Pool memory pool = AllPoolz[_PoolId];
1396         if (block.timestamp < pool.StartTime) return 0;
1397         if (pool.FinishTime < block.timestamp) return remainingAmount(_PoolId);
1398         uint256 totalPoolDuration = pool.FinishTime - pool.StartTime;
1399         uint256 timePassed = block.timestamp - pool.StartTime;
1400         uint256 debitableAmount = (pool.StartAmount * timePassed) / totalPoolDuration;
1401         return debitableAmount - pool.DebitedAmount;
1402     }
1403 
1404     //@dev no use of revert to make sure the loop will work
1405     function WithdrawToken(uint256 _PoolId)
1406         external
1407         returns (uint256 withdrawnAmount)
1408     {
1409         //pool is finished + got left overs + did not took them
1410         Pool storage pool = AllPoolz[_PoolId];
1411         if (
1412             _PoolId < Index &&
1413             pool.CliffTime <= block.timestamp &&
1414             remainingAmount(_PoolId) > 0
1415         ) {
1416             withdrawnAmount = getWithdrawableAmount(_PoolId);
1417             uint256 tempDebitAmount = withdrawnAmount + pool.DebitedAmount;
1418             pool.DebitedAmount = tempDebitAmount;
1419             TransferToken(pool.Token, pool.Owner, withdrawnAmount);
1420             emit TokenWithdrawn(
1421                 _PoolId,
1422                 pool.Owner,
1423                 withdrawnAmount,
1424                 remainingAmount(_PoolId)
1425             );
1426         }
1427     }
1428 }