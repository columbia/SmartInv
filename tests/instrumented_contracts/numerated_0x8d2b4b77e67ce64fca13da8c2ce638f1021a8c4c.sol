1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address from,
82         address to,
83         uint256 amount
84     ) external returns (bool);
85 }
86 
87 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 
95 /**
96  * @dev Interface for the optional metadata functions from the ERC20 standard.
97  *
98  * _Available since v4.1._
99  */
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 // File: @openzeppelin/contracts/utils/Counters.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @title Counters
126  * @author Matt Condon (@shrugs)
127  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
128  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
129  *
130  * Include with `using Counters for Counters.Counter;`
131  */
132 library Counters {
133     struct Counter {
134         // This variable should never be directly accessed by users of the library: interactions must be restricted to
135         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
136         // this feature: see https://github.com/ethereum/solidity/issues/4637
137         uint256 _value; // default: 0
138     }
139 
140     function current(Counter storage counter) internal view returns (uint256) {
141         return counter._value;
142     }
143 
144     function increment(Counter storage counter) internal {
145         unchecked {
146             counter._value += 1;
147         }
148     }
149 
150     function decrement(Counter storage counter) internal {
151         uint256 value = counter._value;
152         require(value > 0, "Counter: decrement overflow");
153         unchecked {
154             counter._value = value - 1;
155         }
156     }
157 
158     function reset(Counter storage counter) internal {
159         counter._value = 0;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/utils/Strings.sol
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 /**
171  * @dev String operations.
172  */
173 library Strings {
174     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
178      */
179     function toString(uint256 value) internal pure returns (string memory) {
180         // Inspired by OraclizeAPI's implementation - MIT licence
181         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
182 
183         if (value == 0) {
184             return "0";
185         }
186         uint256 temp = value;
187         uint256 digits;
188         while (temp != 0) {
189             digits++;
190             temp /= 10;
191         }
192         bytes memory buffer = new bytes(digits);
193         while (value != 0) {
194             digits -= 1;
195             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
196             value /= 10;
197         }
198         return string(buffer);
199     }
200 
201     /**
202      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
203      */
204     function toHexString(uint256 value) internal pure returns (string memory) {
205         if (value == 0) {
206             return "0x00";
207         }
208         uint256 temp = value;
209         uint256 length = 0;
210         while (temp != 0) {
211             length++;
212             temp >>= 8;
213         }
214         return toHexString(value, length);
215     }
216 
217     /**
218      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
219      */
220     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
221         bytes memory buffer = new bytes(2 * length + 2);
222         buffer[0] = "0";
223         buffer[1] = "x";
224         for (uint256 i = 2 * length + 1; i > 1; --i) {
225             buffer[i] = _HEX_SYMBOLS[value & 0xf];
226             value >>= 4;
227         }
228         require(value == 0, "Strings: hex length insufficient");
229         return string(buffer);
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/Context.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Provides information about the current execution context, including the
242  * sender of the transaction and its data. While these are generally available
243  * via msg.sender and msg.data, they should not be accessed in such a direct
244  * manner, since when dealing with meta-transactions the account sending and
245  * paying for execution may not be the actual sender (as far as an application
246  * is concerned).
247  *
248  * This contract is only required for intermediate, library-like contracts.
249  */
250 abstract contract Context {
251     function _msgSender() internal view virtual returns (address) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view virtual returns (bytes calldata) {
256         return msg.data;
257     }
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
261 
262 
263 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 
268 
269 
270 /**
271  * @dev Implementation of the {IERC20} interface.
272  *
273  * This implementation is agnostic to the way tokens are created. This means
274  * that a supply mechanism has to be added in a derived contract using {_mint}.
275  * For a generic mechanism see {ERC20PresetMinterPauser}.
276  *
277  * TIP: For a detailed writeup see our guide
278  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
279  * to implement supply mechanisms].
280  *
281  * We have followed general OpenZeppelin Contracts guidelines: functions revert
282  * instead returning `false` on failure. This behavior is nonetheless
283  * conventional and does not conflict with the expectations of ERC20
284  * applications.
285  *
286  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
287  * This allows applications to reconstruct the allowance for all accounts just
288  * by listening to said events. Other implementations of the EIP may not emit
289  * these events, as it isn't required by the specification.
290  *
291  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
292  * functions have been added to mitigate the well-known issues around setting
293  * allowances. See {IERC20-approve}.
294  */
295 contract ERC20 is Context, IERC20, IERC20Metadata {
296     mapping(address => uint256) private _balances;
297 
298     mapping(address => mapping(address => uint256)) private _allowances;
299 
300     uint256 private _totalSupply;
301 
302     string private _name;
303     string private _symbol;
304 
305     /**
306      * @dev Sets the values for {name} and {symbol}.
307      *
308      * The default value of {decimals} is 18. To select a different value for
309      * {decimals} you should overload it.
310      *
311      * All two of these values are immutable: they can only be set once during
312      * construction.
313      */
314     constructor(string memory name_, string memory symbol_) {
315         _name = name_;
316         _symbol = symbol_;
317     }
318 
319     /**
320      * @dev Returns the name of the token.
321      */
322     function name() public view virtual override returns (string memory) {
323         return _name;
324     }
325 
326     /**
327      * @dev Returns the symbol of the token, usually a shorter version of the
328      * name.
329      */
330     function symbol() public view virtual override returns (string memory) {
331         return _symbol;
332     }
333 
334     /**
335      * @dev Returns the number of decimals used to get its user representation.
336      * For example, if `decimals` equals `2`, a balance of `505` tokens should
337      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
338      *
339      * Tokens usually opt for a value of 18, imitating the relationship between
340      * Ether and Wei. This is the value {ERC20} uses, unless this function is
341      * overridden;
342      *
343      * NOTE: This information is only used for _display_ purposes: it in
344      * no way affects any of the arithmetic of the contract, including
345      * {IERC20-balanceOf} and {IERC20-transfer}.
346      */
347     function decimals() public view virtual override returns (uint8) {
348         return 18;
349     }
350 
351     /**
352      * @dev See {IERC20-totalSupply}.
353      */
354     function totalSupply() public view virtual override returns (uint256) {
355         return _totalSupply;
356     }
357 
358     /**
359      * @dev See {IERC20-balanceOf}.
360      */
361     function balanceOf(address account) public view virtual override returns (uint256) {
362         return _balances[account];
363     }
364 
365     /**
366      * @dev See {IERC20-transfer}.
367      *
368      * Requirements:
369      *
370      * - `to` cannot be the zero address.
371      * - the caller must have a balance of at least `amount`.
372      */
373     function transfer(address to, uint256 amount) public virtual override returns (bool) {
374         address owner = _msgSender();
375         _transfer(owner, to, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-allowance}.
381      */
382     function allowance(address owner, address spender) public view virtual override returns (uint256) {
383         return _allowances[owner][spender];
384     }
385 
386     /**
387      * @dev See {IERC20-approve}.
388      *
389      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
390      * `transferFrom`. This is semantically equivalent to an infinite approval.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function approve(address spender, uint256 amount) public virtual override returns (bool) {
397         address owner = _msgSender();
398         _approve(owner, spender, amount);
399         return true;
400     }
401 
402     /**
403      * @dev See {IERC20-transferFrom}.
404      *
405      * Emits an {Approval} event indicating the updated allowance. This is not
406      * required by the EIP. See the note at the beginning of {ERC20}.
407      *
408      * NOTE: Does not update the allowance if the current allowance
409      * is the maximum `uint256`.
410      *
411      * Requirements:
412      *
413      * - `from` and `to` cannot be the zero address.
414      * - `from` must have a balance of at least `amount`.
415      * - the caller must have allowance for ``from``'s tokens of at least
416      * `amount`.
417      */
418     function transferFrom(
419         address from,
420         address to,
421         uint256 amount
422     ) public virtual override returns (bool) {
423         address spender = _msgSender();
424         _spendAllowance(from, spender, amount);
425         _transfer(from, to, amount);
426         return true;
427     }
428 
429     /**
430      * @dev Atomically increases the allowance granted to `spender` by the caller.
431      *
432      * This is an alternative to {approve} that can be used as a mitigation for
433      * problems described in {IERC20-approve}.
434      *
435      * Emits an {Approval} event indicating the updated allowance.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      */
441     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
442         address owner = _msgSender();
443         _approve(owner, spender, allowance(owner, spender) + addedValue);
444         return true;
445     }
446 
447     /**
448      * @dev Atomically decreases the allowance granted to `spender` by the caller.
449      *
450      * This is an alternative to {approve} that can be used as a mitigation for
451      * problems described in {IERC20-approve}.
452      *
453      * Emits an {Approval} event indicating the updated allowance.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      * - `spender` must have allowance for the caller of at least
459      * `subtractedValue`.
460      */
461     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
462         address owner = _msgSender();
463         uint256 currentAllowance = allowance(owner, spender);
464         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
465         unchecked {
466             _approve(owner, spender, currentAllowance - subtractedValue);
467         }
468 
469         return true;
470     }
471 
472     /**
473      * @dev Moves `amount` of tokens from `sender` to `recipient`.
474      *
475      * This internal function is equivalent to {transfer}, and can be used to
476      * e.g. implement automatic token fees, slashing mechanisms, etc.
477      *
478      * Emits a {Transfer} event.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `from` must have a balance of at least `amount`.
485      */
486     function _transfer(
487         address from,
488         address to,
489         uint256 amount
490     ) internal virtual {
491         require(from != address(0), "ERC20: transfer from the zero address");
492         require(to != address(0), "ERC20: transfer to the zero address");
493 
494         _beforeTokenTransfer(from, to, amount);
495 
496         uint256 fromBalance = _balances[from];
497         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
498         unchecked {
499             _balances[from] = fromBalance - amount;
500         }
501         _balances[to] += amount;
502 
503         emit Transfer(from, to, amount);
504 
505         _afterTokenTransfer(from, to, amount);
506     }
507 
508     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
509      * the total supply.
510      *
511      * Emits a {Transfer} event with `from` set to the zero address.
512      *
513      * Requirements:
514      *
515      * - `account` cannot be the zero address.
516      */
517     function _mint(address account, uint256 amount) internal virtual {
518         require(account != address(0), "ERC20: mint to the zero address");
519 
520         _beforeTokenTransfer(address(0), account, amount);
521 
522         _totalSupply += amount;
523         _balances[account] += amount;
524         emit Transfer(address(0), account, amount);
525 
526         _afterTokenTransfer(address(0), account, amount);
527     }
528 
529     /**
530      * @dev Destroys `amount` tokens from `account`, reducing the
531      * total supply.
532      *
533      * Emits a {Transfer} event with `to` set to the zero address.
534      *
535      * Requirements:
536      *
537      * - `account` cannot be the zero address.
538      * - `account` must have at least `amount` tokens.
539      */
540     function _burn(address account, uint256 amount) internal virtual {
541         require(account != address(0), "ERC20: burn from the zero address");
542 
543         _beforeTokenTransfer(account, address(0), amount);
544 
545         uint256 accountBalance = _balances[account];
546         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
547         unchecked {
548             _balances[account] = accountBalance - amount;
549         }
550         _totalSupply -= amount;
551 
552         emit Transfer(account, address(0), amount);
553 
554         _afterTokenTransfer(account, address(0), amount);
555     }
556 
557     /**
558      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
559      *
560      * This internal function is equivalent to `approve`, and can be used to
561      * e.g. set automatic allowances for certain subsystems, etc.
562      *
563      * Emits an {Approval} event.
564      *
565      * Requirements:
566      *
567      * - `owner` cannot be the zero address.
568      * - `spender` cannot be the zero address.
569      */
570     function _approve(
571         address owner,
572         address spender,
573         uint256 amount
574     ) internal virtual {
575         require(owner != address(0), "ERC20: approve from the zero address");
576         require(spender != address(0), "ERC20: approve to the zero address");
577 
578         _allowances[owner][spender] = amount;
579         emit Approval(owner, spender, amount);
580     }
581 
582     /**
583      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
584      *
585      * Does not update the allowance amount in case of infinite allowance.
586      * Revert if not enough allowance is available.
587      *
588      * Might emit an {Approval} event.
589      */
590     function _spendAllowance(
591         address owner,
592         address spender,
593         uint256 amount
594     ) internal virtual {
595         uint256 currentAllowance = allowance(owner, spender);
596         if (currentAllowance != type(uint256).max) {
597             require(currentAllowance >= amount, "ERC20: insufficient allowance");
598             unchecked {
599                 _approve(owner, spender, currentAllowance - amount);
600             }
601         }
602     }
603 
604     /**
605      * @dev Hook that is called before any transfer of tokens. This includes
606      * minting and burning.
607      *
608      * Calling conditions:
609      *
610      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
611      * will be transferred to `to`.
612      * - when `from` is zero, `amount` tokens will be minted for `to`.
613      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
614      * - `from` and `to` are never both zero.
615      *
616      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
617      */
618     function _beforeTokenTransfer(
619         address from,
620         address to,
621         uint256 amount
622     ) internal virtual {}
623 
624     /**
625      * @dev Hook that is called after any transfer of tokens. This includes
626      * minting and burning.
627      *
628      * Calling conditions:
629      *
630      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
631      * has been transferred to `to`.
632      * - when `from` is zero, `amount` tokens have been minted for `to`.
633      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
634      * - `from` and `to` are never both zero.
635      *
636      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
637      */
638     function _afterTokenTransfer(
639         address from,
640         address to,
641         uint256 amount
642     ) internal virtual {}
643 }
644 
645 // File: @openzeppelin/contracts/access/Ownable.sol
646 
647 
648 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 
653 /**
654  * @dev Contract module which provides a basic access control mechanism, where
655  * there is an account (an owner) that can be granted exclusive access to
656  * specific functions.
657  *
658  * By default, the owner account will be the one that deploys the contract. This
659  * can later be changed with {transferOwnership}.
660  *
661  * This module is used through inheritance. It will make available the modifier
662  * `onlyOwner`, which can be applied to your functions to restrict their use to
663  * the owner.
664  */
665 abstract contract Ownable is Context {
666     address private _owner;
667 
668     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
669 
670     /**
671      * @dev Initializes the contract setting the deployer as the initial owner.
672      */
673     constructor() {
674         _transferOwnership(_msgSender());
675     }
676 
677     /**
678      * @dev Returns the address of the current owner.
679      */
680     function owner() public view virtual returns (address) {
681         return _owner;
682     }
683 
684     /**
685      * @dev Throws if called by any account other than the owner.
686      */
687     modifier onlyOwner() {
688         require(owner() == _msgSender(), "Ownable: caller is not the owner");
689         _;
690     }
691 
692     /**
693      * @dev Leaves the contract without owner. It will not be possible to call
694      * `onlyOwner` functions anymore. Can only be called by the current owner.
695      *
696      * NOTE: Renouncing ownership will leave the contract without an owner,
697      * thereby removing any functionality that is only available to the owner.
698      */
699     function renounceOwnership() public virtual onlyOwner {
700         _transferOwnership(address(0));
701     }
702 
703     /**
704      * @dev Transfers ownership of the contract to a new account (`newOwner`).
705      * Can only be called by the current owner.
706      */
707     function transferOwnership(address newOwner) public virtual onlyOwner {
708         require(newOwner != address(0), "Ownable: new owner is the zero address");
709         _transferOwnership(newOwner);
710     }
711 
712     /**
713      * @dev Transfers ownership of the contract to a new account (`newOwner`).
714      * Internal function without access restriction.
715      */
716     function _transferOwnership(address newOwner) internal virtual {
717         address oldOwner = _owner;
718         _owner = newOwner;
719         emit OwnershipTransferred(oldOwner, newOwner);
720     }
721 }
722 
723 // File: @openzeppelin/contracts/utils/Address.sol
724 
725 
726 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
727 
728 pragma solidity ^0.8.1;
729 
730 /**
731  * @dev Collection of functions related to the address type
732  */
733 library Address {
734     /**
735      * @dev Returns true if `account` is a contract.
736      *
737      * [IMPORTANT]
738      * ====
739      * It is unsafe to assume that an address for which this function returns
740      * false is an externally-owned account (EOA) and not a contract.
741      *
742      * Among others, `isContract` will return false for the following
743      * types of addresses:
744      *
745      *  - an externally-owned account
746      *  - a contract in construction
747      *  - an address where a contract will be created
748      *  - an address where a contract lived, but was destroyed
749      * ====
750      *
751      * [IMPORTANT]
752      * ====
753      * You shouldn't rely on `isContract` to protect against flash loan attacks!
754      *
755      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
756      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
757      * constructor.
758      * ====
759      */
760     function isContract(address account) internal view returns (bool) {
761         // This method relies on extcodesize/address.code.length, which returns 0
762         // for contracts in construction, since the code is only stored at the end
763         // of the constructor execution.
764 
765         return account.code.length > 0;
766     }
767 
768     /**
769      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
770      * `recipient`, forwarding all available gas and reverting on errors.
771      *
772      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
773      * of certain opcodes, possibly making contracts go over the 2300 gas limit
774      * imposed by `transfer`, making them unable to receive funds via
775      * `transfer`. {sendValue} removes this limitation.
776      *
777      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
778      *
779      * IMPORTANT: because control is transferred to `recipient`, care must be
780      * taken to not create reentrancy vulnerabilities. Consider using
781      * {ReentrancyGuard} or the
782      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
783      */
784     function sendValue(address payable recipient, uint256 amount) internal {
785         require(address(this).balance >= amount, "Address: insufficient balance");
786 
787         (bool success, ) = recipient.call{value: amount}("");
788         require(success, "Address: unable to send value, recipient may have reverted");
789     }
790 
791     /**
792      * @dev Performs a Solidity function call using a low level `call`. A
793      * plain `call` is an unsafe replacement for a function call: use this
794      * function instead.
795      *
796      * If `target` reverts with a revert reason, it is bubbled up by this
797      * function (like regular Solidity function calls).
798      *
799      * Returns the raw returned data. To convert to the expected return value,
800      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
801      *
802      * Requirements:
803      *
804      * - `target` must be a contract.
805      * - calling `target` with `data` must not revert.
806      *
807      * _Available since v3.1._
808      */
809     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
810         return functionCall(target, data, "Address: low-level call failed");
811     }
812 
813     /**
814      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
815      * `errorMessage` as a fallback revert reason when `target` reverts.
816      *
817      * _Available since v3.1._
818      */
819     function functionCall(
820         address target,
821         bytes memory data,
822         string memory errorMessage
823     ) internal returns (bytes memory) {
824         return functionCallWithValue(target, data, 0, errorMessage);
825     }
826 
827     /**
828      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
829      * but also transferring `value` wei to `target`.
830      *
831      * Requirements:
832      *
833      * - the calling contract must have an ETH balance of at least `value`.
834      * - the called Solidity function must be `payable`.
835      *
836      * _Available since v3.1._
837      */
838     function functionCallWithValue(
839         address target,
840         bytes memory data,
841         uint256 value
842     ) internal returns (bytes memory) {
843         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
844     }
845 
846     /**
847      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
848      * with `errorMessage` as a fallback revert reason when `target` reverts.
849      *
850      * _Available since v3.1._
851      */
852     function functionCallWithValue(
853         address target,
854         bytes memory data,
855         uint256 value,
856         string memory errorMessage
857     ) internal returns (bytes memory) {
858         require(address(this).balance >= value, "Address: insufficient balance for call");
859         require(isContract(target), "Address: call to non-contract");
860 
861         (bool success, bytes memory returndata) = target.call{value: value}(data);
862         return verifyCallResult(success, returndata, errorMessage);
863     }
864 
865     /**
866      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
867      * but performing a static call.
868      *
869      * _Available since v3.3._
870      */
871     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
872         return functionStaticCall(target, data, "Address: low-level static call failed");
873     }
874 
875     /**
876      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
877      * but performing a static call.
878      *
879      * _Available since v3.3._
880      */
881     function functionStaticCall(
882         address target,
883         bytes memory data,
884         string memory errorMessage
885     ) internal view returns (bytes memory) {
886         require(isContract(target), "Address: static call to non-contract");
887 
888         (bool success, bytes memory returndata) = target.staticcall(data);
889         return verifyCallResult(success, returndata, errorMessage);
890     }
891 
892     /**
893      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
894      * but performing a delegate call.
895      *
896      * _Available since v3.4._
897      */
898     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
899         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
900     }
901 
902     /**
903      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
904      * but performing a delegate call.
905      *
906      * _Available since v3.4._
907      */
908     function functionDelegateCall(
909         address target,
910         bytes memory data,
911         string memory errorMessage
912     ) internal returns (bytes memory) {
913         require(isContract(target), "Address: delegate call to non-contract");
914 
915         (bool success, bytes memory returndata) = target.delegatecall(data);
916         return verifyCallResult(success, returndata, errorMessage);
917     }
918 
919     /**
920      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
921      * revert reason using the provided one.
922      *
923      * _Available since v4.3._
924      */
925     function verifyCallResult(
926         bool success,
927         bytes memory returndata,
928         string memory errorMessage
929     ) internal pure returns (bytes memory) {
930         if (success) {
931             return returndata;
932         } else {
933             // Look for revert reason and bubble it up if present
934             if (returndata.length > 0) {
935                 // The easiest way to bubble the revert reason is using memory via assembly
936 
937                 assembly {
938                     let returndata_size := mload(returndata)
939                     revert(add(32, returndata), returndata_size)
940                 }
941             } else {
942                 revert(errorMessage);
943             }
944         }
945     }
946 }
947 
948 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
949 
950 
951 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
952 
953 pragma solidity ^0.8.0;
954 
955 /**
956  * @title ERC721 token receiver interface
957  * @dev Interface for any contract that wants to support safeTransfers
958  * from ERC721 asset contracts.
959  */
960 interface IERC721Receiver {
961     /**
962      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
963      * by `operator` from `from`, this function is called.
964      *
965      * It must return its Solidity selector to confirm the token transfer.
966      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
967      *
968      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
969      */
970     function onERC721Received(
971         address operator,
972         address from,
973         uint256 tokenId,
974         bytes calldata data
975     ) external returns (bytes4);
976 }
977 
978 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
979 
980 
981 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
982 
983 pragma solidity ^0.8.0;
984 
985 /**
986  * @dev Interface of the ERC165 standard, as defined in the
987  * https://eips.ethereum.org/EIPS/eip-165[EIP].
988  *
989  * Implementers can declare support of contract interfaces, which can then be
990  * queried by others ({ERC165Checker}).
991  *
992  * For an implementation, see {ERC165}.
993  */
994 interface IERC165 {
995     /**
996      * @dev Returns true if this contract implements the interface defined by
997      * `interfaceId`. See the corresponding
998      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
999      * to learn more about how these ids are created.
1000      *
1001      * This function call must use less than 30 000 gas.
1002      */
1003     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1004 }
1005 
1006 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1007 
1008 
1009 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 /**
1015  * @dev Implementation of the {IERC165} interface.
1016  *
1017  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1018  * for the additional interface id that will be supported. For example:
1019  *
1020  * ```solidity
1021  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1022  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1023  * }
1024  * ```
1025  *
1026  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1027  */
1028 abstract contract ERC165 is IERC165 {
1029     /**
1030      * @dev See {IERC165-supportsInterface}.
1031      */
1032     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1033         return interfaceId == type(IERC165).interfaceId;
1034     }
1035 }
1036 
1037 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1038 
1039 
1040 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 
1045 /**
1046  * @dev Required interface of an ERC721 compliant contract.
1047  */
1048 interface IERC721 is IERC165 {
1049     /**
1050      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1051      */
1052     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1053 
1054     /**
1055      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1056      */
1057     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1058 
1059     /**
1060      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1061      */
1062     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1063 
1064     /**
1065      * @dev Returns the number of tokens in ``owner``'s account.
1066      */
1067     function balanceOf(address owner) external view returns (uint256 balance);
1068 
1069     /**
1070      * @dev Returns the owner of the `tokenId` token.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      */
1076     function ownerOf(uint256 tokenId) external view returns (address owner);
1077 
1078     /**
1079      * @dev Safely transfers `tokenId` token from `from` to `to`.
1080      *
1081      * Requirements:
1082      *
1083      * - `from` cannot be the zero address.
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must exist and be owned by `from`.
1086      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1087      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes calldata data
1096     ) external;
1097 
1098     /**
1099      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1101      *
1102      * Requirements:
1103      *
1104      * - `from` cannot be the zero address.
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must exist and be owned by `from`.
1107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function safeTransferFrom(
1113         address from,
1114         address to,
1115         uint256 tokenId
1116     ) external;
1117 
1118     /**
1119      * @dev Transfers `tokenId` token from `from` to `to`.
1120      *
1121      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1122      *
1123      * Requirements:
1124      *
1125      * - `from` cannot be the zero address.
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must be owned by `from`.
1128      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function transferFrom(
1133         address from,
1134         address to,
1135         uint256 tokenId
1136     ) external;
1137 
1138     /**
1139      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1140      * The approval is cleared when the token is transferred.
1141      *
1142      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1143      *
1144      * Requirements:
1145      *
1146      * - The caller must own the token or be an approved operator.
1147      * - `tokenId` must exist.
1148      *
1149      * Emits an {Approval} event.
1150      */
1151     function approve(address to, uint256 tokenId) external;
1152 
1153     /**
1154      * @dev Approve or remove `operator` as an operator for the caller.
1155      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1156      *
1157      * Requirements:
1158      *
1159      * - The `operator` cannot be the caller.
1160      *
1161      * Emits an {ApprovalForAll} event.
1162      */
1163     function setApprovalForAll(address operator, bool _approved) external;
1164 
1165     /**
1166      * @dev Returns the account approved for `tokenId` token.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      */
1172     function getApproved(uint256 tokenId) external view returns (address operator);
1173 
1174     /**
1175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1176      *
1177      * See {setApprovalForAll}
1178      */
1179     function isApprovedForAll(address owner, address operator) external view returns (bool);
1180 }
1181 
1182 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1183 
1184 
1185 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 /**
1191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1192  * @dev See https://eips.ethereum.org/EIPS/eip-721
1193  */
1194 interface IERC721Metadata is IERC721 {
1195     /**
1196      * @dev Returns the token collection name.
1197      */
1198     function name() external view returns (string memory);
1199 
1200     /**
1201      * @dev Returns the token collection symbol.
1202      */
1203     function symbol() external view returns (string memory);
1204 
1205     /**
1206      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1207      */
1208     function tokenURI(uint256 tokenId) external view returns (string memory);
1209 }
1210 
1211 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1212 
1213 
1214 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 
1219 
1220 
1221 
1222 
1223 
1224 
1225 /**
1226  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1227  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1228  * {ERC721Enumerable}.
1229  */
1230 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1231     using Address for address;
1232     using Strings for uint256;
1233 
1234     // Token name
1235     string private _name;
1236 
1237     // Token symbol
1238     string private _symbol;
1239 
1240     // Mapping from token ID to owner address
1241     mapping(uint256 => address) private _owners;
1242 
1243     // Mapping owner address to token count
1244     mapping(address => uint256) private _balances;
1245 
1246     // Mapping from token ID to approved address
1247     mapping(uint256 => address) private _tokenApprovals;
1248 
1249     // Mapping from owner to operator approvals
1250     mapping(address => mapping(address => bool)) private _operatorApprovals;
1251 
1252     /**
1253      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1254      */
1255     constructor(string memory name_, string memory symbol_) {
1256         _name = name_;
1257         _symbol = symbol_;
1258     }
1259 
1260     /**
1261      * @dev See {IERC165-supportsInterface}.
1262      */
1263     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1264         return
1265             interfaceId == type(IERC721).interfaceId ||
1266             interfaceId == type(IERC721Metadata).interfaceId ||
1267             super.supportsInterface(interfaceId);
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-balanceOf}.
1272      */
1273     function balanceOf(address owner) public view virtual override returns (uint256) {
1274         require(owner != address(0), "ERC721: balance query for the zero address");
1275         return _balances[owner];
1276     }
1277 
1278     /**
1279      * @dev See {IERC721-ownerOf}.
1280      */
1281     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1282         address owner = _owners[tokenId];
1283         require(owner != address(0), "ERC721: owner query for nonexistent token");
1284         return owner;
1285     }
1286 
1287     /**
1288      * @dev See {IERC721Metadata-name}.
1289      */
1290     function name() public view virtual override returns (string memory) {
1291         return _name;
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Metadata-symbol}.
1296      */
1297     function symbol() public view virtual override returns (string memory) {
1298         return _symbol;
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Metadata-tokenURI}.
1303      */
1304     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1305         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1306 
1307         string memory baseURI = _baseURI();
1308         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1309     }
1310 
1311     /**
1312      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1313      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1314      * by default, can be overridden in child contracts.
1315      */
1316     function _baseURI() internal view virtual returns (string memory) {
1317         return "";
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-approve}.
1322      */
1323     function approve(address to, uint256 tokenId) public virtual override {
1324         address owner = ERC721.ownerOf(tokenId);
1325         require(to != owner, "ERC721: approval to current owner");
1326 
1327         require(
1328             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1329             "ERC721: approve caller is not owner nor approved for all"
1330         );
1331 
1332         _approve(to, tokenId);
1333     }
1334 
1335     /**
1336      * @dev See {IERC721-getApproved}.
1337      */
1338     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1339         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1340 
1341         return _tokenApprovals[tokenId];
1342     }
1343 
1344     /**
1345      * @dev See {IERC721-setApprovalForAll}.
1346      */
1347     function setApprovalForAll(address operator, bool approved) public virtual override {
1348         _setApprovalForAll(_msgSender(), operator, approved);
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-isApprovedForAll}.
1353      */
1354     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1355         return _operatorApprovals[owner][operator];
1356     }
1357 
1358     /**
1359      * @dev See {IERC721-transferFrom}.
1360      */
1361     function transferFrom(
1362         address from,
1363         address to,
1364         uint256 tokenId
1365     ) public virtual override {
1366         //solhint-disable-next-line max-line-length
1367         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1368 
1369         _transfer(from, to, tokenId);
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-safeTransferFrom}.
1374      */
1375     function safeTransferFrom(
1376         address from,
1377         address to,
1378         uint256 tokenId
1379     ) public virtual override {
1380         safeTransferFrom(from, to, tokenId, "");
1381     }
1382 
1383     /**
1384      * @dev See {IERC721-safeTransferFrom}.
1385      */
1386     function safeTransferFrom(
1387         address from,
1388         address to,
1389         uint256 tokenId,
1390         bytes memory _data
1391     ) public virtual override {
1392         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1393         _safeTransfer(from, to, tokenId, _data);
1394     }
1395 
1396     /**
1397      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1398      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1399      *
1400      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1401      *
1402      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1403      * implement alternative mechanisms to perform token transfer, such as signature-based.
1404      *
1405      * Requirements:
1406      *
1407      * - `from` cannot be the zero address.
1408      * - `to` cannot be the zero address.
1409      * - `tokenId` token must exist and be owned by `from`.
1410      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function _safeTransfer(
1415         address from,
1416         address to,
1417         uint256 tokenId,
1418         bytes memory _data
1419     ) internal virtual {
1420         _transfer(from, to, tokenId);
1421         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1422     }
1423 
1424     /**
1425      * @dev Returns whether `tokenId` exists.
1426      *
1427      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1428      *
1429      * Tokens start existing when they are minted (`_mint`),
1430      * and stop existing when they are burned (`_burn`).
1431      */
1432     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1433         return _owners[tokenId] != address(0);
1434     }
1435 
1436     /**
1437      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1438      *
1439      * Requirements:
1440      *
1441      * - `tokenId` must exist.
1442      */
1443     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1444         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1445         address owner = ERC721.ownerOf(tokenId);
1446         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1447     }
1448 
1449     /**
1450      * @dev Safely mints `tokenId` and transfers it to `to`.
1451      *
1452      * Requirements:
1453      *
1454      * - `tokenId` must not exist.
1455      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1456      *
1457      * Emits a {Transfer} event.
1458      */
1459     function _safeMint(address to, uint256 tokenId) internal virtual {
1460         _safeMint(to, tokenId, "");
1461     }
1462 
1463     /**
1464      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1465      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1466      */
1467     function _safeMint(
1468         address to,
1469         uint256 tokenId,
1470         bytes memory _data
1471     ) internal virtual {
1472         _mint(to, tokenId);
1473         require(
1474             _checkOnERC721Received(address(0), to, tokenId, _data),
1475             "ERC721: transfer to non ERC721Receiver implementer"
1476         );
1477     }
1478 
1479     /**
1480      * @dev Mints `tokenId` and transfers it to `to`.
1481      *
1482      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1483      *
1484      * Requirements:
1485      *
1486      * - `tokenId` must not exist.
1487      * - `to` cannot be the zero address.
1488      *
1489      * Emits a {Transfer} event.
1490      */
1491     function _mint(address to, uint256 tokenId) internal virtual {
1492         require(to != address(0), "ERC721: mint to the zero address");
1493         require(!_exists(tokenId), "ERC721: token already minted");
1494 
1495         _beforeTokenTransfer(address(0), to, tokenId);
1496 
1497         _balances[to] += 1;
1498         _owners[tokenId] = to;
1499 
1500         emit Transfer(address(0), to, tokenId);
1501 
1502         _afterTokenTransfer(address(0), to, tokenId);
1503     }
1504 
1505     /**
1506      * @dev Destroys `tokenId`.
1507      * The approval is cleared when the token is burned.
1508      *
1509      * Requirements:
1510      *
1511      * - `tokenId` must exist.
1512      *
1513      * Emits a {Transfer} event.
1514      */
1515     function _burn(uint256 tokenId) internal virtual {
1516         address owner = ERC721.ownerOf(tokenId);
1517 
1518         _beforeTokenTransfer(owner, address(0), tokenId);
1519 
1520         // Clear approvals
1521         _approve(address(0), tokenId);
1522 
1523         _balances[owner] -= 1;
1524         delete _owners[tokenId];
1525 
1526         emit Transfer(owner, address(0), tokenId);
1527 
1528         _afterTokenTransfer(owner, address(0), tokenId);
1529     }
1530 
1531     /**
1532      * @dev Transfers `tokenId` from `from` to `to`.
1533      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1534      *
1535      * Requirements:
1536      *
1537      * - `to` cannot be the zero address.
1538      * - `tokenId` token must be owned by `from`.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _transfer(
1543         address from,
1544         address to,
1545         uint256 tokenId
1546     ) internal virtual {
1547         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1548         require(to != address(0), "ERC721: transfer to the zero address");
1549 
1550         _beforeTokenTransfer(from, to, tokenId);
1551 
1552         // Clear approvals from the previous owner
1553         _approve(address(0), tokenId);
1554 
1555         _balances[from] -= 1;
1556         _balances[to] += 1;
1557         _owners[tokenId] = to;
1558 
1559         emit Transfer(from, to, tokenId);
1560 
1561         _afterTokenTransfer(from, to, tokenId);
1562     }
1563 
1564     /**
1565      * @dev Approve `to` to operate on `tokenId`
1566      *
1567      * Emits a {Approval} event.
1568      */
1569     function _approve(address to, uint256 tokenId) internal virtual {
1570         _tokenApprovals[tokenId] = to;
1571         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1572     }
1573 
1574     /**
1575      * @dev Approve `operator` to operate on all of `owner` tokens
1576      *
1577      * Emits a {ApprovalForAll} event.
1578      */
1579     function _setApprovalForAll(
1580         address owner,
1581         address operator,
1582         bool approved
1583     ) internal virtual {
1584         require(owner != operator, "ERC721: approve to caller");
1585         _operatorApprovals[owner][operator] = approved;
1586         emit ApprovalForAll(owner, operator, approved);
1587     }
1588 
1589     /**
1590      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1591      * The call is not executed if the target address is not a contract.
1592      *
1593      * @param from address representing the previous owner of the given token ID
1594      * @param to target address that will receive the tokens
1595      * @param tokenId uint256 ID of the token to be transferred
1596      * @param _data bytes optional data to send along with the call
1597      * @return bool whether the call correctly returned the expected magic value
1598      */
1599     function _checkOnERC721Received(
1600         address from,
1601         address to,
1602         uint256 tokenId,
1603         bytes memory _data
1604     ) private returns (bool) {
1605         if (to.isContract()) {
1606             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1607                 return retval == IERC721Receiver.onERC721Received.selector;
1608             } catch (bytes memory reason) {
1609                 if (reason.length == 0) {
1610                     revert("ERC721: transfer to non ERC721Receiver implementer");
1611                 } else {
1612                     assembly {
1613                         revert(add(32, reason), mload(reason))
1614                     }
1615                 }
1616             }
1617         } else {
1618             return true;
1619         }
1620     }
1621 
1622     /**
1623      * @dev Hook that is called before any token transfer. This includes minting
1624      * and burning.
1625      *
1626      * Calling conditions:
1627      *
1628      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1629      * transferred to `to`.
1630      * - When `from` is zero, `tokenId` will be minted for `to`.
1631      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1632      * - `from` and `to` are never both zero.
1633      *
1634      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1635      */
1636     function _beforeTokenTransfer(
1637         address from,
1638         address to,
1639         uint256 tokenId
1640     ) internal virtual {}
1641 
1642     /**
1643      * @dev Hook that is called after any transfer of tokens. This includes
1644      * minting and burning.
1645      *
1646      * Calling conditions:
1647      *
1648      * - when `from` and `to` are both non-zero.
1649      * - `from` and `to` are never both zero.
1650      *
1651      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1652      */
1653     function _afterTokenTransfer(
1654         address from,
1655         address to,
1656         uint256 tokenId
1657     ) internal virtual {}
1658 }
1659 
1660 // File: contracts/MetaGochiCreatures.sol
1661 
1662 
1663 pragma solidity ^0.8.7;
1664 
1665 
1666 
1667 
1668 
1669 contract MetaGochiCreatures is ERC721, Ownable {
1670   using Strings for uint256;
1671   using Counters for Counters.Counter;
1672 
1673   Counters.Counter private supply;
1674 
1675   string public uriPrefix = "";
1676     
1677   uint256 public maxMintAmountPerTx = 20;
1678 
1679   bool public paused = true;
1680 
1681   address public devWallet = 0x7CBd384B73D3fF4b278023B3e8a354c436Bdc60f;
1682   address public singleEggToken = 0x90749BcAE7bDeE78fD7b8829aeAc855c32A56376;
1683   address public twinEggToken = 0x7F1cf2796D7C33B8f5AcBB02c7FFfab51F7A3D36;
1684 
1685   constructor() ERC721("MetaGochiCreatures", "MGNFTC") {
1686   }
1687 
1688   modifier mintCompliance(uint256 _mintAmount) {
1689     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "MetaGochiNft: Invalid mint amount!");
1690     _;
1691   }
1692 
1693   function totalSupply() public view returns (uint256) {
1694     return supply.current();
1695   }
1696 
1697   function mint(uint256 _singleEggAmount, uint256 _twinEggAmount) public payable mintCompliance(_singleEggAmount + _twinEggAmount * 2) {
1698     require(!paused, "The contract is paused!");
1699 	
1700     if(_singleEggAmount > 0) {
1701       uint256 singleTokenBal = IERC20(singleEggToken).balanceOf(msg.sender);
1702       require(singleTokenBal >= _singleEggAmount, "MetaGochiNft: Not enough single egg token balance");
1703 
1704       // transfer tokens back to dev wallet
1705       IERC20(singleEggToken).transferFrom(msg.sender, devWallet, _singleEggAmount);
1706       _mintLoop(msg.sender, _singleEggAmount);
1707     }
1708 
1709     if(_twinEggAmount > 0) {
1710     	uint256 twinTokenBal = IERC20(twinEggToken).balanceOf(msg.sender);
1711       require(twinTokenBal >= _twinEggAmount, "MetaGochiNft: Not enough twin egg token balance");
1712 
1713       // transfer tokens back to dev wallet
1714     	IERC20(twinEggToken).transferFrom(msg.sender, devWallet, _twinEggAmount);
1715     	_mintLoop(msg.sender, _twinEggAmount * 2);
1716     }
1717   }
1718 
1719   function walletOfOwner(address _owner)
1720     public
1721     view
1722     returns (uint256[] memory)
1723   {
1724     uint256 ownerTokenCount = balanceOf(_owner);
1725     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1726     uint256 currentTokenId = 1;
1727     uint256 ownedTokenIndex = 0;
1728 
1729     while (ownedTokenIndex < ownerTokenCount) {
1730       address currentTokenOwner = ownerOf(currentTokenId);
1731 
1732       if (currentTokenOwner == _owner) {
1733         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1734 
1735         ownedTokenIndex++;
1736       }
1737 
1738       currentTokenId++;
1739     }
1740 
1741     return ownedTokenIds;
1742   }
1743 
1744   function tokenURI(uint256 _tokenId)
1745     public
1746     view
1747     virtual
1748     override
1749     returns (string memory)
1750   {
1751     require(
1752       _exists(_tokenId),
1753       "ERC721Metadata: URI query for nonexistent token"
1754     );
1755 
1756     string memory currentBaseURI = _baseURI();
1757     return bytes(currentBaseURI).length > 0
1758         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString()))
1759         : "";
1760   }
1761 
1762   // only owner functions
1763   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1764     _mintLoop(_receiver, _mintAmount);
1765   }
1766 
1767   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1768     maxMintAmountPerTx = _maxMintAmountPerTx;
1769   }
1770 
1771   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1772     uriPrefix = _uriPrefix;
1773   }
1774 
1775   function setPaused(bool _state) public onlyOwner {
1776     paused = _state;
1777   }
1778 
1779   function setDevWallet(address _devWallet) public onlyOwner {
1780     devWallet = _devWallet;
1781   }
1782 
1783   function setSingleEggToken(address _singleEggToken) public onlyOwner {
1784     singleEggToken = _singleEggToken;
1785   }
1786 
1787   function setTwinEggToken(address _twinEggToken) public onlyOwner {
1788     twinEggToken = _twinEggToken;
1789   }
1790 
1791   // internal functions
1792   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1793     for (uint256 i = 0; i < _mintAmount; i++) {
1794       supply.increment();
1795       _safeMint(_receiver, supply.current());
1796     }
1797   }
1798 
1799   function _baseURI() internal view virtual override returns (string memory) {
1800     return uriPrefix;
1801   }
1802 }