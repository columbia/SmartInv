1 // File: contracts_ETH/main/libraries/Math.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.4;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     /**
13      * @dev Returns the largest of two numbers.
14      */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two numbers.
21      */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two numbers. The result is rounded towards
28      * zero.
29      */
30     function average(uint256 a, uint256 b) internal pure returns (uint256) {
31         // (a + b) / 2 can overflow.
32         return (a & b) + (a ^ b) / 2;
33     }
34 
35     /**
36      * @dev Returns the ceiling of the division of two numbers.
37      *
38      * This differs from standard division with `/` in that it rounds up instead
39      * of rounding down.
40      */
41     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
42         // (a + b - 1) / b can overflow on addition, so we distribute.
43         return a / b + (a % b == 0 ? 0 : 1);
44     }
45 
46     /**
47      * @dev Returns the absolute unsigned value of a signed value.
48      */
49     function abs(int256 n) internal pure returns (uint256) {
50         unchecked {
51             // must be unchecked in order to support `n = type(int256).min`
52             return uint256(n >= 0 ? n : -n);
53         }
54     }
55 }
56 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
57 
58 
59 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev Interface of the ERC20 standard as defined in the EIP.
65  */
66 interface IERC20 {
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 
81     /**
82      * @dev Returns the amount of tokens in existence.
83      */
84     function totalSupply() external view returns (uint256);
85 
86     /**
87      * @dev Returns the amount of tokens owned by `account`.
88      */
89     function balanceOf(address account) external view returns (uint256);
90 
91     /**
92      * @dev Moves `amount` tokens from the caller's account to `to`.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transfer(address to, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Returns the remaining number of tokens that `spender` will be
102      * allowed to spend on behalf of `owner` through {transferFrom}. This is
103      * zero by default.
104      *
105      * This value changes when {approve} or {transferFrom} are called.
106      */
107     function allowance(address owner, address spender) external view returns (uint256);
108 
109     /**
110      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * IMPORTANT: Beware that changing an allowance with this method brings the risk
115      * that someone may use both the old and the new allowance by unfortunate
116      * transaction ordering. One possible solution to mitigate this race
117      * condition is to first reduce the spender's allowance to 0 and set the
118      * desired value afterwards:
119      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address spender, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Moves `amount` tokens from `from` to `to` using the
127      * allowance mechanism. `amount` is then deducted from the caller's
128      * allowance.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(
135         address from,
136         address to,
137         uint256 amount
138     ) external returns (bool);
139 }
140 
141 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 
149 /**
150  * @dev Interface for the optional metadata functions from the ERC20 standard.
151  *
152  * _Available since v4.1._
153  */
154 interface IERC20Metadata is IERC20 {
155     /**
156      * @dev Returns the name of the token.
157      */
158     function name() external view returns (string memory);
159 
160     /**
161      * @dev Returns the symbol of the token.
162      */
163     function symbol() external view returns (string memory);
164 
165     /**
166      * @dev Returns the decimals places of the token.
167      */
168     function decimals() external view returns (uint8);
169 }
170 
171 // File: contracts_ETH/main/libraries/SafeERC20.sol
172 
173 
174 pragma solidity ^0.8.4;
175 
176 
177 library SafeERC20 {
178     function safeSymbol(IERC20 token) internal view returns (string memory) {
179         (bool success, bytes memory data) = address(token).staticcall(
180             abi.encodeWithSelector(0x95d89b41)
181         );
182         return success && data.length > 0 ? abi.decode(data, (string)) : "???";
183     }
184 
185     function safeName(IERC20 token) internal view returns (string memory) {
186         (bool success, bytes memory data) = address(token).staticcall(
187             abi.encodeWithSelector(0x06fdde03)
188         );
189         return success && data.length > 0 ? abi.decode(data, (string)) : "???";
190     }
191 
192     function safeDecimals(IERC20 token) public view returns (uint8) {
193         (bool success, bytes memory data) = address(token).staticcall(
194             abi.encodeWithSelector(0x313ce567)
195         );
196         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
197     }
198 
199     function safeTransfer(
200         IERC20 token,
201         address to,
202         uint256 amount
203     ) internal {
204         (bool success, bytes memory data) = address(token).call(
205             abi.encodeWithSelector(0xa9059cbb, to, amount)
206         );
207         require(
208             success && (data.length == 0 || abi.decode(data, (bool))),
209             "SafeERC20: Transfer failed"
210         );
211     }
212 
213     function safeTransferFrom(
214         IERC20 token,
215         address from,
216         address to,
217         uint256 amount
218     ) internal {
219         (bool success, bytes memory data) = address(token).call(
220             abi.encodeWithSelector(0x23b872dd, from, to, amount)
221         );
222         require(
223             success && (data.length == 0 || abi.decode(data, (bool))),
224             "SafeERC20: TransferFrom failed"
225         );
226     }
227 }
228 
229 // File: @openzeppelin/contracts/utils/Context.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes calldata) {
252         return msg.data;
253     }
254 }
255 
256 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
257 
258 
259 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 
264 
265 
266 /**
267  * @dev Implementation of the {IERC20} interface.
268  *
269  * This implementation is agnostic to the way tokens are created. This means
270  * that a supply mechanism has to be added in a derived contract using {_mint}.
271  * For a generic mechanism see {ERC20PresetMinterPauser}.
272  *
273  * TIP: For a detailed writeup see our guide
274  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
275  * to implement supply mechanisms].
276  *
277  * We have followed general OpenZeppelin Contracts guidelines: functions revert
278  * instead returning `false` on failure. This behavior is nonetheless
279  * conventional and does not conflict with the expectations of ERC20
280  * applications.
281  *
282  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
283  * This allows applications to reconstruct the allowance for all accounts just
284  * by listening to said events. Other implementations of the EIP may not emit
285  * these events, as it isn't required by the specification.
286  *
287  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
288  * functions have been added to mitigate the well-known issues around setting
289  * allowances. See {IERC20-approve}.
290  */
291 contract ERC20 is Context, IERC20, IERC20Metadata {
292     mapping(address => uint256) private _balances;
293 
294     mapping(address => mapping(address => uint256)) private _allowances;
295 
296     uint256 private _totalSupply;
297 
298     string private _name;
299     string private _symbol;
300 
301     /**
302      * @dev Sets the values for {name} and {symbol}.
303      *
304      * The default value of {decimals} is 18. To select a different value for
305      * {decimals} you should overload it.
306      *
307      * All two of these values are immutable: they can only be set once during
308      * construction.
309      */
310     constructor(string memory name_, string memory symbol_) {
311         _name = name_;
312         _symbol = symbol_;
313     }
314 
315     /**
316      * @dev Returns the name of the token.
317      */
318     function name() public view virtual override returns (string memory) {
319         return _name;
320     }
321 
322     /**
323      * @dev Returns the symbol of the token, usually a shorter version of the
324      * name.
325      */
326     function symbol() public view virtual override returns (string memory) {
327         return _symbol;
328     }
329 
330     /**
331      * @dev Returns the number of decimals used to get its user representation.
332      * For example, if `decimals` equals `2`, a balance of `505` tokens should
333      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
334      *
335      * Tokens usually opt for a value of 18, imitating the relationship between
336      * Ether and Wei. This is the value {ERC20} uses, unless this function is
337      * overridden;
338      *
339      * NOTE: This information is only used for _display_ purposes: it in
340      * no way affects any of the arithmetic of the contract, including
341      * {IERC20-balanceOf} and {IERC20-transfer}.
342      */
343     function decimals() public view virtual override returns (uint8) {
344         return 18;
345     }
346 
347     /**
348      * @dev See {IERC20-totalSupply}.
349      */
350     function totalSupply() public view virtual override returns (uint256) {
351         return _totalSupply;
352     }
353 
354     /**
355      * @dev See {IERC20-balanceOf}.
356      */
357     function balanceOf(address account) public view virtual override returns (uint256) {
358         return _balances[account];
359     }
360 
361     /**
362      * @dev See {IERC20-transfer}.
363      *
364      * Requirements:
365      *
366      * - `to` cannot be the zero address.
367      * - the caller must have a balance of at least `amount`.
368      */
369     function transfer(address to, uint256 amount) public virtual override returns (bool) {
370         address owner = _msgSender();
371         _transfer(owner, to, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-allowance}.
377      */
378     function allowance(address owner, address spender) public view virtual override returns (uint256) {
379         return _allowances[owner][spender];
380     }
381 
382     /**
383      * @dev See {IERC20-approve}.
384      *
385      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
386      * `transferFrom`. This is semantically equivalent to an infinite approval.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function approve(address spender, uint256 amount) public virtual override returns (bool) {
393         address owner = _msgSender();
394         _approve(owner, spender, amount);
395         return true;
396     }
397 
398     /**
399      * @dev See {IERC20-transferFrom}.
400      *
401      * Emits an {Approval} event indicating the updated allowance. This is not
402      * required by the EIP. See the note at the beginning of {ERC20}.
403      *
404      * NOTE: Does not update the allowance if the current allowance
405      * is the maximum `uint256`.
406      *
407      * Requirements:
408      *
409      * - `from` and `to` cannot be the zero address.
410      * - `from` must have a balance of at least `amount`.
411      * - the caller must have allowance for ``from``'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(
415         address from,
416         address to,
417         uint256 amount
418     ) public virtual override returns (bool) {
419         address spender = _msgSender();
420         _spendAllowance(from, spender, amount);
421         _transfer(from, to, amount);
422         return true;
423     }
424 
425     /**
426      * @dev Atomically increases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
438         address owner = _msgSender();
439         _approve(owner, spender, allowance(owner, spender) + addedValue);
440         return true;
441     }
442 
443     /**
444      * @dev Atomically decreases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to {approve} that can be used as a mitigation for
447      * problems described in {IERC20-approve}.
448      *
449      * Emits an {Approval} event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      * - `spender` must have allowance for the caller of at least
455      * `subtractedValue`.
456      */
457     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
458         address owner = _msgSender();
459         uint256 currentAllowance = allowance(owner, spender);
460         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
461         unchecked {
462             _approve(owner, spender, currentAllowance - subtractedValue);
463         }
464 
465         return true;
466     }
467 
468     /**
469      * @dev Moves `amount` of tokens from `from` to `to`.
470      *
471      * This internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `from` must have a balance of at least `amount`.
481      */
482     function _transfer(
483         address from,
484         address to,
485         uint256 amount
486     ) internal virtual {
487         require(from != address(0), "ERC20: transfer from the zero address");
488         require(to != address(0), "ERC20: transfer to the zero address");
489 
490         _beforeTokenTransfer(from, to, amount);
491 
492         uint256 fromBalance = _balances[from];
493         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
494         unchecked {
495             _balances[from] = fromBalance - amount;
496         }
497         _balances[to] += amount;
498 
499         emit Transfer(from, to, amount);
500 
501         _afterTokenTransfer(from, to, amount);
502     }
503 
504     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
505      * the total supply.
506      *
507      * Emits a {Transfer} event with `from` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      */
513     function _mint(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: mint to the zero address");
515 
516         _beforeTokenTransfer(address(0), account, amount);
517 
518         _totalSupply += amount;
519         _balances[account] += amount;
520         emit Transfer(address(0), account, amount);
521 
522         _afterTokenTransfer(address(0), account, amount);
523     }
524 
525     /**
526      * @dev Destroys `amount` tokens from `account`, reducing the
527      * total supply.
528      *
529      * Emits a {Transfer} event with `to` set to the zero address.
530      *
531      * Requirements:
532      *
533      * - `account` cannot be the zero address.
534      * - `account` must have at least `amount` tokens.
535      */
536     function _burn(address account, uint256 amount) internal virtual {
537         require(account != address(0), "ERC20: burn from the zero address");
538 
539         _beforeTokenTransfer(account, address(0), amount);
540 
541         uint256 accountBalance = _balances[account];
542         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
543         unchecked {
544             _balances[account] = accountBalance - amount;
545         }
546         _totalSupply -= amount;
547 
548         emit Transfer(account, address(0), amount);
549 
550         _afterTokenTransfer(account, address(0), amount);
551     }
552 
553     /**
554      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
555      *
556      * This internal function is equivalent to `approve`, and can be used to
557      * e.g. set automatic allowances for certain subsystems, etc.
558      *
559      * Emits an {Approval} event.
560      *
561      * Requirements:
562      *
563      * - `owner` cannot be the zero address.
564      * - `spender` cannot be the zero address.
565      */
566     function _approve(
567         address owner,
568         address spender,
569         uint256 amount
570     ) internal virtual {
571         require(owner != address(0), "ERC20: approve from the zero address");
572         require(spender != address(0), "ERC20: approve to the zero address");
573 
574         _allowances[owner][spender] = amount;
575         emit Approval(owner, spender, amount);
576     }
577 
578     /**
579      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
580      *
581      * Does not update the allowance amount in case of infinite allowance.
582      * Revert if not enough allowance is available.
583      *
584      * Might emit an {Approval} event.
585      */
586     function _spendAllowance(
587         address owner,
588         address spender,
589         uint256 amount
590     ) internal virtual {
591         uint256 currentAllowance = allowance(owner, spender);
592         if (currentAllowance != type(uint256).max) {
593             require(currentAllowance >= amount, "ERC20: insufficient allowance");
594             unchecked {
595                 _approve(owner, spender, currentAllowance - amount);
596             }
597         }
598     }
599 
600     /**
601      * @dev Hook that is called before any transfer of tokens. This includes
602      * minting and burning.
603      *
604      * Calling conditions:
605      *
606      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
607      * will be transferred to `to`.
608      * - when `from` is zero, `amount` tokens will be minted for `to`.
609      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
610      * - `from` and `to` are never both zero.
611      *
612      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
613      */
614     function _beforeTokenTransfer(
615         address from,
616         address to,
617         uint256 amount
618     ) internal virtual {}
619 
620     /**
621      * @dev Hook that is called after any transfer of tokens. This includes
622      * minting and burning.
623      *
624      * Calling conditions:
625      *
626      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
627      * has been transferred to `to`.
628      * - when `from` is zero, `amount` tokens have been minted for `to`.
629      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
630      * - `from` and `to` are never both zero.
631      *
632      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
633      */
634     function _afterTokenTransfer(
635         address from,
636         address to,
637         uint256 amount
638     ) internal virtual {}
639 }
640 
641 // File: @openzeppelin/contracts/access/Ownable.sol
642 
643 
644 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 
649 /**
650  * @dev Contract module which provides a basic access control mechanism, where
651  * there is an account (an owner) that can be granted exclusive access to
652  * specific functions.
653  *
654  * By default, the owner account will be the one that deploys the contract. This
655  * can later be changed with {transferOwnership}.
656  *
657  * This module is used through inheritance. It will make available the modifier
658  * `onlyOwner`, which can be applied to your functions to restrict their use to
659  * the owner.
660  */
661 abstract contract Ownable is Context {
662     address private _owner;
663 
664     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
665 
666     /**
667      * @dev Initializes the contract setting the deployer as the initial owner.
668      */
669     constructor() {
670         _transferOwnership(_msgSender());
671     }
672 
673     /**
674      * @dev Returns the address of the current owner.
675      */
676     function owner() public view virtual returns (address) {
677         return _owner;
678     }
679 
680     /**
681      * @dev Throws if called by any account other than the owner.
682      */
683     modifier onlyOwner() {
684         require(owner() == _msgSender(), "Ownable: caller is not the owner");
685         _;
686     }
687 
688     /**
689      * @dev Leaves the contract without owner. It will not be possible to call
690      * `onlyOwner` functions anymore. Can only be called by the current owner.
691      *
692      * NOTE: Renouncing ownership will leave the contract without an owner,
693      * thereby removing any functionality that is only available to the owner.
694      */
695     function renounceOwnership() public virtual onlyOwner {
696         _transferOwnership(address(0));
697     }
698 
699     /**
700      * @dev Transfers ownership of the contract to a new account (`newOwner`).
701      * Can only be called by the current owner.
702      */
703     function transferOwnership(address newOwner) public virtual onlyOwner {
704         require(newOwner != address(0), "Ownable: new owner is the zero address");
705         _transferOwnership(newOwner);
706     }
707 
708     /**
709      * @dev Transfers ownership of the contract to a new account (`newOwner`).
710      * Internal function without access restriction.
711      */
712     function _transferOwnership(address newOwner) internal virtual {
713         address oldOwner = _owner;
714         _owner = newOwner;
715         emit OwnershipTransferred(oldOwner, newOwner);
716     }
717 }
718 
719 // File: contracts_ETH/main/Token.sol
720 
721 
722 pragma solidity ^0.8.4;
723 
724 
725 
726 
727 /** 
728 * @author Formation.Fi.
729 * @notice  A common Implementation for tokens ALPHA, BETA and GAMMA.
730 */
731 
732 contract Token is ERC20, Ownable {
733     struct Deposit{
734         uint256 amount;
735         uint256 time;
736     }
737     address public proxyInvestement;
738     address private proxyAdmin;
739 
740     mapping(address => Deposit[]) public depositPerAddress;
741     mapping(address => bool) public  whitelist;
742     event SetProxyInvestement(address  _address);
743     constructor(string memory _name, string memory _symbol) 
744     ERC20(_name,  _symbol) {
745     }
746 
747     modifier onlyProxy() {
748         require(
749             (proxyInvestement != address(0)) && (proxyAdmin != address(0)),
750             "Formation.Fi: zero address"
751         );
752 
753         require(
754             (msg.sender == proxyInvestement) || (msg.sender == proxyAdmin),
755              "Formation.Fi: not the proxy"
756         );
757         _;
758     }
759     modifier onlyProxyInvestement() {
760         require(proxyInvestement != address(0),
761             "Formation.Fi: zero address"
762         );
763 
764         require(msg.sender == proxyInvestement,
765              "Formation.Fi: not the proxy"
766         );
767         _;
768     }
769 
770      /**
771      * @dev Update the proxyInvestement.
772      * @param _proxyInvestement.
773      * @notice Emits a {SetProxyInvestement} event with `_proxyInvestement`.
774      */
775     function setProxyInvestement(address _proxyInvestement) external onlyOwner {
776         require(
777             _proxyInvestement!= address(0),
778             "Formation.Fi: zero address"
779         );
780 
781          proxyInvestement = _proxyInvestement;
782 
783         emit SetProxyInvestement( _proxyInvestement);
784 
785     } 
786 
787     /**
788      * @dev Add a contract address to the whitelist
789      * @param _contract The address of the contract.
790      */
791     function addToWhitelist(address _contract) external onlyOwner {
792         require(
793             _contract!= address(0),
794             "Formation.Fi: zero address"
795         );
796 
797         whitelist[_contract] = true;
798     } 
799 
800     /**
801      * @dev Remove a contract address from the whitelist
802      * @param _contract The address of the contract.
803      */
804     function removeFromWhitelist(address _contract) external onlyOwner {
805          require(
806             whitelist[_contract] == true,
807             "Formation.Fi: no whitelist"
808         );
809         require(
810             _contract!= address(0),
811             "Formation.Fi: zero address"
812         );
813 
814         whitelist[_contract] = false;
815     } 
816 
817     /**
818      * @dev Update the proxyAdmin.
819      * @param _proxyAdmin.
820      */
821     function setAdmin(address _proxyAdmin) external onlyOwner {
822         require(
823             _proxyAdmin!= address(0),
824             "Formation.Fi: zero address"
825         );
826         
827          proxyAdmin = _proxyAdmin;
828     } 
829 
830 
831     
832     /**
833      * @dev add user's deposit.
834      * @param _account The user's address.
835      * @param _amount The user's deposit amount.
836      * @param _time The deposit time.
837      */
838     function addDeposit(address _account, uint256 _amount, uint256 _time) 
839         external onlyProxyInvestement {
840         require(
841             _account!= address(0),
842             "Formation.Fi: zero address"
843         );
844 
845         require(
846             _amount!= 0,
847             "Formation.Fi: zero amount"
848         );
849 
850         require(
851             _time!= 0,
852             "Formation.Fi: zero time"
853         );
854         Deposit memory _deposit = Deposit(_amount, _time); 
855         depositPerAddress[_account].push(_deposit);
856     } 
857 
858      /**
859      * @dev mint the token product for the user.
860      * @notice To receive the token product, the user has to deposit 
861      * the required StableCoin in this product. 
862      * @param _account The user's address.
863      * @param _amount The amount to be minted.
864      */
865     function mint(address _account, uint256 _amount) external onlyProxy {
866         require(
867           _account!= address(0),
868            "Formation.Fi: zero address"
869         );
870 
871         require(
872             _amount!= 0,
873             "Formation.Fi: zero amount"
874         );
875 
876        _mint(_account,  _amount);
877    }
878 
879     /**
880      * @dev burn the token product of the user.
881      * @notice When the user withdraws his Stablecoins, his tokens 
882      * product are burned. 
883      * @param _account The user's address.
884      * @param _amount The amount to be burned.
885      */
886     function burn(address _account, uint256 _amount) external onlyProxy {
887         require(
888             _account!= address(0),
889             "Formation.Fi: zero address"
890         );
891 
892          require(
893             _amount!= 0,
894             "Formation.Fi: zero amount"
895         );
896 
897         _burn( _account, _amount);
898     }
899     
900      /**
901      * @dev Verify the lock up condition for a user's withdrawal request.
902      * @param _account The user's address.
903      * @param _amount The amount to be withdrawn.
904      * @param _period The lock up period.
905      * @return _success  is true if the lock up condition is satisfied.
906      */
907     function checklWithdrawalRequest(address _account, uint256 _amount, uint256 _period) 
908         external view returns (bool _success){
909         require(
910             _account!= address(0),
911             "Formation.Fi: zero address"
912         );
913 
914         require(
915            _amount!= 0,
916             "Formation.Fi: zero amount"
917         );
918 
919         Deposit[] memory _deposit = depositPerAddress[_account];
920         uint256 _amountTotal = 0;
921         for (uint256 i = 0; i < _deposit.length; i++) {
922              require ((block.timestamp - _deposit[i].time) >= _period, 
923             "Formation.Fi:  position locked");
924             if (_amount<= (_amountTotal + _deposit[i].amount)){
925                 break; 
926             }
927             _amountTotal = _amountTotal + _deposit[i].amount;
928         }
929         _success= true;
930     }
931 
932 
933      /**
934      * @dev update the user's token data.
935      * @notice this function is called after each desposit request 
936      * validation by the manager.
937      * @param _account The user's address.
938      * @param _amount The deposit amount validated by the manager.
939      */
940     function updateTokenData( address _account,  uint256 _amount) 
941         external onlyProxyInvestement {
942         _updateTokenData(_account,  _amount);
943     }
944 
945     function _updateTokenData( address _account,  uint256 _amount) internal {
946         require(
947             _account!= address(0),
948             "Formation.Fi: zero address"
949         );
950 
951         require(
952             _amount!= 0,
953             "Formation.Fi: zero amount"
954         );
955 
956         Deposit[] memory _deposit = depositPerAddress[_account];
957         uint256 _amountlocal = 0;
958         uint256 _amountTotal = 0;
959         uint256 _newAmount;
960         uint256 k =0;
961         for (uint256 i = 0; i < _deposit.length; i++) {
962             _amountlocal  = Math.min(_deposit[i].amount, _amount -  _amountTotal);
963             _amountTotal = _amountTotal + _amountlocal;
964             _newAmount = _deposit[i].amount - _amountlocal;
965             depositPerAddress[_account][k].amount = _newAmount;
966             if (_newAmount == 0){
967                _deleteTokenData(_account, k);
968             }
969             else {
970                 k = k+1;
971             }
972             if (_amountTotal == _amount){
973                break; 
974             }
975         }
976     }
977     
978      /**
979      * @dev delete the user's token data.
980      * @notice This function is called when the user's withdrawal request is  
981      * validated by the manager.
982      * @param _account The user's address.
983      * @param _index The index of the user in 'amountDepositPerAddress'.
984      */
985     function _deleteTokenData(address _account, uint256 _index) internal {
986         require(
987             _account!= address(0),
988             "Formation.Fi: zero address"
989         );
990         uint256 _size = depositPerAddress[_account].length - 1;
991         
992         require( _index <= _size,
993             "Formation.Fi: index is out"
994         );
995         for (uint256 i = _index; i< _size; i++){
996             depositPerAddress[ _account][i] = depositPerAddress[ _account][i+1];
997         }
998         depositPerAddress[ _account].pop();   
999     }
1000    
1001      /**
1002      * @dev update the token data of both the sender and the receiver 
1003        when the product token is transferred.
1004      * @param from The sender's address.
1005      * @param to The receiver's address.
1006      * @param amount The transferred amount.
1007      */
1008     function _afterTokenTransfer(
1009         address from,
1010         address to,
1011         uint256 amount
1012       ) internal virtual override{
1013       
1014        if ((to != address(0)) && (to != proxyInvestement) 
1015        && (to != proxyAdmin) && (from != address(0)) && (!whitelist[to])){
1016           _updateTokenData(from, amount);
1017           Deposit memory _deposit = Deposit(amount, block.timestamp);
1018           depositPerAddress[to].push(_deposit);
1019          
1020         }
1021     }
1022 
1023 }
1024 
1025 // File: contracts_ETH/main/Admin.sol
1026 
1027 
1028 pragma solidity ^0.8.4;
1029 
1030 
1031 
1032 
1033 
1034 /** 
1035 * @author Formation.Fi.
1036 * @notice Implementation of the contract Admin.
1037 */
1038 
1039 contract Admin is Ownable {
1040     using SafeERC20 for IERC20;
1041     uint256 public constant FACTOR_FEES_DECIMALS = 1e4; 
1042     uint256 public constant FACTOR_PRICE_DECIMALS = 1e6;
1043     uint256 public constant  SECONDES_PER_YEAR = 365 days; 
1044     uint256 public slippageTolerance = 200;
1045     uint256 public  amountScaleDecimals = 1; 
1046     uint256 public depositFeeRate = 50;  
1047     uint256 public depositFeeRateParity= 15; 
1048     uint256 public managementFeeRate = 200;
1049     uint256 public performanceFeeRate = 2000;
1050     uint256 public performanceFees;
1051     uint256 public managementFees;
1052     uint256 public managementFeesTime;
1053     uint256 public tokenPrice = 1e6;
1054     uint256 public tokenPriceMean = 1e6;
1055     uint256 public minAmount= 100 * 1e18;
1056     uint256 public lockupPeriodUser = 604800; 
1057     uint public netDepositInd;
1058     uint256 public netAmountEvent;
1059     address public manager;
1060     address public treasury;
1061     address public investement;
1062     address private safeHouse;
1063     bool public isCancel;
1064     Token public token;
1065     IERC20 public stableToken;
1066 
1067 
1068     constructor( address _manager, address _treasury,  address _stableTokenAddress,
1069      address _tokenAddress) {
1070         require(
1071             _manager != address(0),
1072             "Formation.Fi: zero address"
1073         );
1074 
1075         require(
1076            _treasury != address(0),
1077             "Formation.Fi:  zero address"
1078             );
1079 
1080         require(
1081             _stableTokenAddress != address(0),
1082             "Formation.Fi:  zero address"
1083         );
1084 
1085         require(
1086            _tokenAddress != address(0),
1087             "Formation.Fi:  zero address"
1088         );
1089 
1090         manager = _manager;
1091         treasury = _treasury; 
1092         stableToken = IERC20(_stableTokenAddress);
1093         token = Token(_tokenAddress);
1094         uint8 _stableTokenDecimals = ERC20( _stableTokenAddress).decimals();
1095         if ( _stableTokenDecimals == 6) {
1096             amountScaleDecimals= 1e12;
1097         }
1098     }
1099 
1100     modifier onlyInvestement() {
1101         require(investement != address(0),
1102             "Formation.Fi:  zero address"
1103         );
1104 
1105         require(msg.sender == investement,
1106              "Formation.Fi:  not investement"
1107         );
1108         _;
1109     }
1110 
1111     modifier onlyManager() {
1112         require(msg.sender == manager, 
1113         "Formation.Fi: not manager");
1114         _;
1115     }
1116 
1117      /**
1118      * @dev Setter functions to update the Portfolio Parameters.
1119      */
1120     function setTreasury(address _treasury) external onlyOwner {
1121         require(
1122             _treasury != address(0),
1123             "Formation.Fi: zero address"
1124         );
1125 
1126         treasury = _treasury;
1127     }
1128 
1129     function setManager(address _manager) external onlyOwner {
1130         require(
1131             _manager != address(0),
1132             "Formation.Fi: zero address"
1133         );
1134 
1135         manager = _manager;
1136     }
1137 
1138     function setInvestement(address _investement) external onlyOwner {
1139         require(
1140             _investement!= address(0),
1141             "Formation.Fi: zero address"
1142         );
1143 
1144         investement = _investement;
1145     } 
1146 
1147     function setSafeHouse(address _safeHouse) external onlyOwner {
1148         require(
1149             _safeHouse!= address(0),
1150             "Formation.Fi: zero address"
1151         );
1152 
1153         safeHouse = _safeHouse;
1154     } 
1155 
1156     function setCancel(bool _cancel) external onlyManager {
1157         isCancel= _cancel;
1158     }
1159   
1160     function setLockupPeriodUser(uint256 _lockupPeriodUser) external onlyManager {
1161         lockupPeriodUser = _lockupPeriodUser;
1162     }
1163  
1164     function setDepositFeeRate(uint256 _rate) external onlyManager {
1165         depositFeeRate= _rate;
1166     }
1167 
1168     function setDepositFeeRateParity(uint256 _rate) external onlyManager {
1169         depositFeeRateParity= _rate;
1170     }
1171 
1172     function setManagementFeeRate(uint256 _rate) external onlyManager {
1173         managementFeeRate = _rate;
1174     }
1175 
1176     function setPerformanceFeeRate(uint256 _rate) external onlyManager {
1177         performanceFeeRate  = _rate;
1178     }
1179     function setMinAmount(uint256 _minAmount) external onlyManager {
1180         minAmount= _minAmount;
1181      }
1182 
1183     function updateTokenPrice(uint256 _price) external onlyManager {
1184         require(
1185              _price > 0,
1186             "Formation.Fi: zero price"
1187         );
1188 
1189         tokenPrice = _price;
1190     }
1191 
1192     function updateTokenPriceMean(uint256 _price) external onlyInvestement {
1193         require(
1194              _price > 0,
1195             "Formation.Fi: zero price"
1196         );
1197         tokenPriceMean  = _price;
1198     }
1199 
1200     function updateManagementFeeTime(uint256 _time) external onlyInvestement {
1201         managementFeesTime = _time;
1202     }
1203     
1204 
1205      /**
1206      * @dev Calculate performance Fees.
1207      */
1208     function calculatePerformanceFees() external onlyManager {
1209         require(performanceFees == 0, "Formation.Fi: fees on pending");
1210 
1211         uint256 _deltaPrice = 0;
1212         if (tokenPrice > tokenPriceMean) {
1213             _deltaPrice = tokenPrice - tokenPriceMean;
1214             tokenPriceMean = tokenPrice;
1215             performanceFees = (token.totalSupply() *
1216             _deltaPrice * performanceFeeRate) / (tokenPrice * FACTOR_FEES_DECIMALS); 
1217         }
1218     }
1219 
1220     
1221      /**
1222      * @dev Calculate management Fees.
1223      */
1224     function calculateManagementFees() external onlyManager {
1225         require(managementFees == 0, "Formation.Fi: fees on pending");
1226         if (managementFeesTime!= 0){
1227            uint256 _deltaTime;
1228            _deltaTime = block.timestamp -  managementFeesTime; 
1229            managementFees = (token.totalSupply() * managementFeeRate * _deltaTime ) 
1230            /(FACTOR_FEES_DECIMALS * SECONDES_PER_YEAR);
1231            managementFeesTime = block.timestamp; 
1232         }
1233     }
1234      
1235     /**
1236      * @dev Mint Fees.
1237      */
1238     function mintFees() external onlyManager {
1239         require ((performanceFees + managementFees) > 0, "Formation.Fi: zero fees");
1240 
1241         token.mint(treasury, performanceFees + managementFees);
1242         performanceFees = 0;
1243         managementFees = 0;
1244     }
1245 
1246     /**
1247      * @dev Calculate net deposit indicator
1248      * @param _depositAmountTotal the total requested deposit amount by users.
1249      * @param  _withdrawalAmountTotal the total requested withdrawal amount by users.
1250      * @param _maxDepositAmount the maximum accepted deposit amount by event.
1251      * @param _maxWithdrawalAmount the maximum accepted withdrawal amount by event.
1252      * @return net Deposit indicator: 1 if net deposit case, 0 otherwise (net withdrawal case).
1253      */
1254     function calculateNetDepositInd(uint256 _depositAmountTotal, 
1255         uint256 _withdrawalAmountTotal, uint256 _maxDepositAmount, 
1256         uint256 _maxWithdrawalAmount) external onlyInvestement returns( uint256) {
1257         _depositAmountTotal = Math.min(  _depositAmountTotal,
1258          _maxDepositAmount);
1259         _withdrawalAmountTotal =  (_withdrawalAmountTotal * tokenPrice) / FACTOR_PRICE_DECIMALS;
1260         _withdrawalAmountTotal= Math.min(_withdrawalAmountTotal,
1261         _maxWithdrawalAmount);
1262         uint256  _depositAmountTotalAfterFees = _depositAmountTotal - 
1263         ( _depositAmountTotal * depositFeeRate)/ FACTOR_FEES_DECIMALS;
1264         if  ( _depositAmountTotalAfterFees >= _withdrawalAmountTotal) {
1265             netDepositInd = 1 ;
1266         }
1267         else {
1268             netDepositInd = 0;
1269         }
1270         return netDepositInd;
1271     }
1272 
1273     /**
1274      * @dev Calculate net amount 
1275      * @param _depositAmountTotal the total requested deposit amount by users.
1276      * @param _withdrawalAmountTotal the total requested withdrawal amount by users.
1277      * @param _maxDepositAmount the maximum accepted deposit amount by event.
1278      * @param _maxWithdrawalAmount the maximum accepted withdrawal amount by event.
1279      * @return net amount.
1280      */
1281     function calculateNetAmountEvent(uint256 _depositAmountTotal, 
1282         uint256 _withdrawalAmountTotal, uint256 _maxDepositAmount, 
1283         uint256 _maxWithdrawalAmount) external onlyInvestement returns(uint256) {
1284         _depositAmountTotal = Math.min(  _depositAmountTotal,
1285          _maxDepositAmount);
1286         _withdrawalAmountTotal =  (_withdrawalAmountTotal * tokenPrice) / FACTOR_PRICE_DECIMALS;
1287         _withdrawalAmountTotal= Math.min(_withdrawalAmountTotal,
1288         _maxWithdrawalAmount);
1289          uint256  _depositAmountTotalAfterFees = _depositAmountTotal - 
1290         ( _depositAmountTotal * depositFeeRate)/ FACTOR_FEES_DECIMALS;
1291         
1292         if (netDepositInd == 1) {
1293              netAmountEvent =  _depositAmountTotalAfterFees - _withdrawalAmountTotal;
1294         }
1295         else {
1296              netAmountEvent = _withdrawalAmountTotal - _depositAmountTotalAfterFees;
1297         
1298         }
1299         return netAmountEvent;
1300     }
1301 
1302     /**
1303      * @dev Protect against slippage due to assets sale.
1304      * @param _withdrawalAmount the value of sold assets in Stablecoin.
1305      * _withdrawalAmount has to be sent to the contract.
1306      * treasury has to approve the contract for both Stablecoin and token.
1307      * @return Missed amount to send to the contract due to slippage.
1308      */
1309     function protectAgainstSlippage(uint256 _withdrawalAmount) external onlyManager 
1310         returns (uint256) {
1311         require(_withdrawalAmount != 0, "Formation.Fi: zero amount");
1312 
1313         require(netDepositInd == 0, "Formation.Fi: no slippage");
1314        
1315        uint256 _amount = 0; 
1316        uint256 _deltaAmount =0;
1317        uint256 _slippage = 0;
1318        uint256  _tokenAmount = 0;
1319        uint256 _balanceTokenTreasury = token.balanceOf(treasury);
1320        uint256 _balanceStableTreasury = stableToken.balanceOf(treasury) * amountScaleDecimals;
1321       
1322         if (_withdrawalAmount< netAmountEvent){
1323             _amount = netAmountEvent - _withdrawalAmount;   
1324             _slippage = (_amount * FACTOR_FEES_DECIMALS ) / netAmountEvent;
1325             if (_slippage >= slippageTolerance) {
1326                 return netAmountEvent;
1327             }
1328             else {
1329                  _deltaAmount = Math.min( _amount, _balanceStableTreasury);
1330                 if ( _deltaAmount  > 0){
1331                     stableToken.safeTransferFrom(treasury, investement, _deltaAmount/amountScaleDecimals);
1332                     _tokenAmount = (_deltaAmount * FACTOR_PRICE_DECIMALS)/tokenPrice;
1333                     token.mint(treasury, _tokenAmount);
1334                     return _amount - _deltaAmount;
1335                 }
1336                 else {
1337                      return _amount; 
1338                 }  
1339             }    
1340         
1341         }
1342         else  {
1343            _amount = _withdrawalAmount - netAmountEvent;   
1344           _tokenAmount = (_amount * FACTOR_PRICE_DECIMALS)/tokenPrice;
1345           _tokenAmount = Math.min(_tokenAmount, _balanceTokenTreasury);
1346           if (_tokenAmount >0) {
1347               _deltaAmount = (_tokenAmount * tokenPrice)/FACTOR_PRICE_DECIMALS;
1348               stableToken.safeTransfer(treasury, _deltaAmount/amountScaleDecimals);   
1349               token.burn( treasury, _tokenAmount);
1350             }
1351            if ((_amount - _deltaAmount) > 0) {
1352             
1353               stableToken.safeTransfer(safeHouse, (_amount - _deltaAmount)/amountScaleDecimals); 
1354             }
1355         }
1356         return 0;
1357 
1358     } 
1359 
1360      /**
1361      * @dev Send Stablecoin from the manager to the contract.
1362      * @param _amount  tha amount to send.
1363      */
1364     function sendStableTocontract(uint256 _amount) external 
1365      onlyManager {
1366       require( _amount > 0,  "Formation.Fi: zero amount");
1367 
1368       stableToken.safeTransferFrom(msg.sender, address(this),
1369        _amount/amountScaleDecimals);
1370     }
1371 
1372    
1373      /**
1374      * @dev Send Stablecoin from the contract to the contract Investement.
1375      */
1376     function sendStableFromcontract() external 
1377         onlyManager {
1378         require(investement != address(0),
1379             "Formation.Fi: zero address"
1380         );
1381          stableToken.safeTransfer(investement, stableToken.balanceOf(address(this)));
1382     }
1383   
1384 }
1385 
1386 // File: contracts_ETH/Gamma/AdminGamma.sol
1387 
1388 
1389 pragma solidity ^0.8.4;
1390 
1391 
1392 /** 
1393 * @author Formation.Fi.
1394 * @notice Implementation of the contract AdminGamma.
1395 */
1396 
1397 contract AdminGamma is Admin {
1398     constructor(address _manager, address _treasury, address _stableToken,
1399      address _token) Admin(  _manager,  _treasury,  _stableToken,
1400      _token){
1401    }
1402 }