1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/PhononToken.sol
4 // SPDX-License-Identifier: MIT
5 pragma solidity >=0.8.0 <0.9.0;
6 
7 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
8 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
9 
10 /* pragma solidity ^0.8.0; */
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
33 // OpenZeppelin Contracts v4.3.2 (access/Ownable.sol)
34 
35 /* pragma solidity ^0.8.0; */
36 
37 /* import "../utils/Context.sol"; */
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
110 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
111 
112 /* pragma solidity ^0.8.0; */
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through {transferFrom}. This is
140      * zero by default.
141      *
142      * This value changes when {approve} or {transferFrom} are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145 
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * IMPORTANT: Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) external returns (bool);
176 
177     /**
178      * @dev Emitted when `value` tokens are moved from one account (`from`) to
179      * another (`to`).
180      *
181      * Note that `value` may be zero.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 value);
184 
185     /**
186      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
187      * a call to {approve}. `value` is the new allowance.
188      */
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
193 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/IERC20Metadata.sol)
194 
195 /* pragma solidity ^0.8.0; */
196 
197 /* import "../IERC20.sol"; */
198 
199 /**
200  * @dev Interface for the optional metadata functions from the ERC20 standard.
201  *
202  * _Available since v4.1._
203  */
204 interface IERC20Metadata is IERC20 {
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the symbol of the token.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the decimals places of the token.
217      */
218     function decimals() external view returns (uint8);
219 }
220 
221 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
222 // OpenZeppelin Contracts v4.3.2 (token/ERC20/ERC20.sol)
223 
224 /* pragma solidity ^0.8.0; */
225 
226 /* import "./IERC20.sol"; */
227 /* import "./extensions/IERC20Metadata.sol"; */
228 /* import "../../utils/Context.sol"; */
229 
230 /**
231  * @dev Implementation of the {IERC20} interface.
232  *
233  * This implementation is agnostic to the way tokens are created. This means
234  * that a supply mechanism has to be added in a derived contract using {_mint}.
235  * For a generic mechanism see {ERC20PresetMinterPauser}.
236  *
237  * TIP: For a detailed writeup see our guide
238  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
239  * to implement supply mechanisms].
240  *
241  * We have followed general OpenZeppelin Contracts guidelines: functions revert
242  * instead returning `false` on failure. This behavior is nonetheless
243  * conventional and does not conflict with the expectations of ERC20
244  * applications.
245  *
246  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
247  * This allows applications to reconstruct the allowance for all accounts just
248  * by listening to said events. Other implementations of the EIP may not emit
249  * these events, as it isn't required by the specification.
250  *
251  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
252  * functions have been added to mitigate the well-known issues around setting
253  * allowances. See {IERC20-approve}.
254  */
255 contract ERC20 is Context, IERC20, IERC20Metadata {
256     mapping(address => uint256) private _balances;
257 
258     mapping(address => mapping(address => uint256)) private _allowances;
259 
260     uint256 private _totalSupply;
261 
262     string private _name;
263     string private _symbol;
264 
265     /**
266      * @dev Sets the values for {name} and {symbol}.
267      *
268      * The default value of {decimals} is 18. To select a different value for
269      * {decimals} you should overload it.
270      *
271      * All two of these values are immutable: they can only be set once during
272      * construction.
273      */
274     constructor(string memory name_, string memory symbol_) {
275         _name = name_;
276         _symbol = symbol_;
277     }
278 
279     /**
280      * @dev Returns the name of the token.
281      */
282     function name() public view virtual override returns (string memory) {
283         return _name;
284     }
285 
286     /**
287      * @dev Returns the symbol of the token, usually a shorter version of the
288      * name.
289      */
290     function symbol() public view virtual override returns (string memory) {
291         return _symbol;
292     }
293 
294     /**
295      * @dev Returns the number of decimals used to get its user representation.
296      * For example, if `decimals` equals `2`, a balance of `505` tokens should
297      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
298      *
299      * Tokens usually opt for a value of 18, imitating the relationship between
300      * Ether and Wei. This is the value {ERC20} uses, unless this function is
301      * overridden;
302      *
303      * NOTE: This information is only used for _display_ purposes: it in
304      * no way affects any of the arithmetic of the contract, including
305      * {IERC20-balanceOf} and {IERC20-transfer}.
306      */
307     function decimals() public view virtual override returns (uint8) {
308         return 18;
309     }
310 
311     /**
312      * @dev See {IERC20-totalSupply}.
313      */
314     function totalSupply() public view virtual override returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See {IERC20-balanceOf}.
320      */
321     function balanceOf(address account) public view virtual override returns (uint256) {
322         return _balances[account];
323     }
324 
325     /**
326      * @dev See {IERC20-transfer}.
327      *
328      * Requirements:
329      *
330      * - `recipient` cannot be the zero address.
331      * - the caller must have a balance of at least `amount`.
332      */
333     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
334         _transfer(_msgSender(), recipient, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-allowance}.
340      */
341     function allowance(address owner, address spender) public view virtual override returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     /**
346      * @dev See {IERC20-approve}.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function approve(address spender, uint256 amount) public virtual override returns (bool) {
353         _approve(_msgSender(), spender, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-transferFrom}.
359      *
360      * Emits an {Approval} event indicating the updated allowance. This is not
361      * required by the EIP. See the note at the beginning of {ERC20}.
362      *
363      * Requirements:
364      *
365      * - `sender` and `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      * - the caller must have allowance for ``sender``'s tokens of at least
368      * `amount`.
369      */
370     function transferFrom(
371         address sender,
372         address recipient,
373         uint256 amount
374     ) public virtual override returns (bool) {
375         _transfer(sender, recipient, amount);
376 
377         uint256 currentAllowance = _allowances[sender][_msgSender()];
378         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
379         unchecked {
380             _approve(sender, _msgSender(), currentAllowance - amount);
381         }
382 
383         return true;
384     }
385 
386     /**
387      * @dev Atomically increases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to {approve} that can be used as a mitigation for
390      * problems described in {IERC20-approve}.
391      *
392      * Emits an {Approval} event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      */
398     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
399         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
400         return true;
401     }
402 
403     /**
404      * @dev Atomically decreases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      * - `spender` must have allowance for the caller of at least
415      * `subtractedValue`.
416      */
417     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
418         uint256 currentAllowance = _allowances[_msgSender()][spender];
419         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
420         unchecked {
421             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
422         }
423 
424         return true;
425     }
426 
427     /**
428      * @dev Moves `amount` of tokens from `sender` to `recipient`.
429      *
430      * This internal function is equivalent to {transfer}, and can be used to
431      * e.g. implement automatic token fees, slashing mechanisms, etc.
432      *
433      * Emits a {Transfer} event.
434      *
435      * Requirements:
436      *
437      * - `sender` cannot be the zero address.
438      * - `recipient` cannot be the zero address.
439      * - `sender` must have a balance of at least `amount`.
440      */
441     function _transfer(
442         address sender,
443         address recipient,
444         uint256 amount
445     ) internal virtual {
446         require(sender != address(0), "ERC20: transfer from the zero address");
447         require(recipient != address(0), "ERC20: transfer to the zero address");
448 
449         _beforeTokenTransfer(sender, recipient, amount);
450 
451         uint256 senderBalance = _balances[sender];
452         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
453         unchecked {
454             _balances[sender] = senderBalance - amount;
455         }
456         _balances[recipient] += amount;
457 
458         emit Transfer(sender, recipient, amount);
459 
460         _afterTokenTransfer(sender, recipient, amount);
461     }
462 
463     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
464      * the total supply.
465      *
466      * Emits a {Transfer} event with `from` set to the zero address.
467      *
468      * Requirements:
469      *
470      * - `account` cannot be the zero address.
471      */
472     function _mint(address account, uint256 amount) internal virtual {
473         require(account != address(0), "ERC20: mint to the zero address");
474 
475         _beforeTokenTransfer(address(0), account, amount);
476 
477         _totalSupply += amount;
478         _balances[account] += amount;
479         emit Transfer(address(0), account, amount);
480 
481         _afterTokenTransfer(address(0), account, amount);
482     }
483 
484     /**
485      * @dev Destroys `amount` tokens from `account`, reducing the
486      * total supply.
487      *
488      * Emits a {Transfer} event with `to` set to the zero address.
489      *
490      * Requirements:
491      *
492      * - `account` cannot be the zero address.
493      * - `account` must have at least `amount` tokens.
494      */
495     function _burn(address account, uint256 amount) internal virtual {
496         require(account != address(0), "ERC20: burn from the zero address");
497 
498         _beforeTokenTransfer(account, address(0), amount);
499 
500         uint256 accountBalance = _balances[account];
501         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
502         unchecked {
503             _balances[account] = accountBalance - amount;
504         }
505         _totalSupply -= amount;
506 
507         emit Transfer(account, address(0), amount);
508 
509         _afterTokenTransfer(account, address(0), amount);
510     }
511 
512     /**
513      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
514      *
515      * This internal function is equivalent to `approve`, and can be used to
516      * e.g. set automatic allowances for certain subsystems, etc.
517      *
518      * Emits an {Approval} event.
519      *
520      * Requirements:
521      *
522      * - `owner` cannot be the zero address.
523      * - `spender` cannot be the zero address.
524      */
525     function _approve(
526         address owner,
527         address spender,
528         uint256 amount
529     ) internal virtual {
530         require(owner != address(0), "ERC20: approve from the zero address");
531         require(spender != address(0), "ERC20: approve to the zero address");
532 
533         _allowances[owner][spender] = amount;
534         emit Approval(owner, spender, amount);
535     }
536 
537     /**
538      * @dev Hook that is called before any transfer of tokens. This includes
539      * minting and burning.
540      *
541      * Calling conditions:
542      *
543      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
544      * will be transferred to `to`.
545      * - when `from` is zero, `amount` tokens will be minted for `to`.
546      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
547      * - `from` and `to` are never both zero.
548      *
549      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
550      */
551     function _beforeTokenTransfer(
552         address from,
553         address to,
554         uint256 amount
555     ) internal virtual {}
556 
557     /**
558      * @dev Hook that is called after any transfer of tokens. This includes
559      * minting and burning.
560      *
561      * Calling conditions:
562      *
563      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
564      * has been transferred to `to`.
565      * - when `from` is zero, `amount` tokens have been minted for `to`.
566      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
567      * - `from` and `to` are never both zero.
568      *
569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
570      */
571     function _afterTokenTransfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal virtual {}
576 }
577 
578 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
579 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/draft-IERC20Permit.sol)
580 
581 /* pragma solidity ^0.8.0; */
582 
583 /**
584  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
585  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
586  *
587  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
588  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
589  * need to send a transaction, and thus is not required to hold Ether at all.
590  */
591 interface IERC20Permit {
592     /**
593      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
594      * given ``owner``'s signed approval.
595      *
596      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
597      * ordering also apply here.
598      *
599      * Emits an {Approval} event.
600      *
601      * Requirements:
602      *
603      * - `spender` cannot be the zero address.
604      * - `deadline` must be a timestamp in the future.
605      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
606      * over the EIP712-formatted function arguments.
607      * - the signature must use ``owner``'s current nonce (see {nonces}).
608      *
609      * For more information on the signature format, see the
610      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
611      * section].
612      */
613     function permit(
614         address owner,
615         address spender,
616         uint256 value,
617         uint256 deadline,
618         uint8 v,
619         bytes32 r,
620         bytes32 s
621     ) external;
622 
623     /**
624      * @dev Returns the current nonce for `owner`. This value must be
625      * included whenever a signature is generated for {permit}.
626      *
627      * Every successful call to {permit} increases ``owner``'s nonce by one. This
628      * prevents a signature from being used multiple times.
629      */
630     function nonces(address owner) external view returns (uint256);
631 
632     /**
633      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
634      */
635     // solhint-disable-next-line func-name-mixedcase
636     function DOMAIN_SEPARATOR() external view returns (bytes32);
637 }
638 
639 ////// lib/openzeppelin-contracts/contracts/utils/Counters.sol
640 // OpenZeppelin Contracts v4.3.2 (utils/Counters.sol)
641 
642 /* pragma solidity ^0.8.0; */
643 
644 /**
645  * @title Counters
646  * @author Matt Condon (@shrugs)
647  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
648  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
649  *
650  * Include with `using Counters for Counters.Counter;`
651  */
652 library Counters {
653     struct Counter {
654         // This variable should never be directly accessed by users of the library: interactions must be restricted to
655         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
656         // this feature: see https://github.com/ethereum/solidity/issues/4637
657         uint256 _value; // default: 0
658     }
659 
660     function current(Counter storage counter) internal view returns (uint256) {
661         return counter._value;
662     }
663 
664     function increment(Counter storage counter) internal {
665         unchecked {
666             counter._value += 1;
667         }
668     }
669 
670     function decrement(Counter storage counter) internal {
671         uint256 value = counter._value;
672         require(value > 0, "Counter: decrement overflow");
673         unchecked {
674             counter._value = value - 1;
675         }
676     }
677 
678     function reset(Counter storage counter) internal {
679         counter._value = 0;
680     }
681 }
682 
683 ////// lib/openzeppelin-contracts/contracts/utils/Strings.sol
684 // OpenZeppelin Contracts v4.3.2 (utils/Strings.sol)
685 
686 /* pragma solidity ^0.8.0; */
687 
688 /**
689  * @dev String operations.
690  */
691 library Strings {
692     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
693 
694     /**
695      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
696      */
697     function toString(uint256 value) internal pure returns (string memory) {
698         // Inspired by OraclizeAPI's implementation - MIT licence
699         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
700 
701         if (value == 0) {
702             return "0";
703         }
704         uint256 temp = value;
705         uint256 digits;
706         while (temp != 0) {
707             digits++;
708             temp /= 10;
709         }
710         bytes memory buffer = new bytes(digits);
711         while (value != 0) {
712             digits -= 1;
713             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
714             value /= 10;
715         }
716         return string(buffer);
717     }
718 
719     /**
720      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
721      */
722     function toHexString(uint256 value) internal pure returns (string memory) {
723         if (value == 0) {
724             return "0x00";
725         }
726         uint256 temp = value;
727         uint256 length = 0;
728         while (temp != 0) {
729             length++;
730             temp >>= 8;
731         }
732         return toHexString(value, length);
733     }
734 
735     /**
736      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
737      */
738     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
739         bytes memory buffer = new bytes(2 * length + 2);
740         buffer[0] = "0";
741         buffer[1] = "x";
742         for (uint256 i = 2 * length + 1; i > 1; --i) {
743             buffer[i] = _HEX_SYMBOLS[value & 0xf];
744             value >>= 4;
745         }
746         require(value == 0, "Strings: hex length insufficient");
747         return string(buffer);
748     }
749 }
750 
751 ////// lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
752 // OpenZeppelin Contracts v4.3.2 (utils/cryptography/ECDSA.sol)
753 
754 /* pragma solidity ^0.8.0; */
755 
756 /* import "../Strings.sol"; */
757 
758 /**
759  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
760  *
761  * These functions can be used to verify that a message was signed by the holder
762  * of the private keys of a given address.
763  */
764 library ECDSA {
765     enum RecoverError {
766         NoError,
767         InvalidSignature,
768         InvalidSignatureLength,
769         InvalidSignatureS,
770         InvalidSignatureV
771     }
772 
773     function _throwError(RecoverError error) private pure {
774         if (error == RecoverError.NoError) {
775             return; // no error: do nothing
776         } else if (error == RecoverError.InvalidSignature) {
777             revert("ECDSA: invalid signature");
778         } else if (error == RecoverError.InvalidSignatureLength) {
779             revert("ECDSA: invalid signature length");
780         } else if (error == RecoverError.InvalidSignatureS) {
781             revert("ECDSA: invalid signature 's' value");
782         } else if (error == RecoverError.InvalidSignatureV) {
783             revert("ECDSA: invalid signature 'v' value");
784         }
785     }
786 
787     /**
788      * @dev Returns the address that signed a hashed message (`hash`) with
789      * `signature` or error string. This address can then be used for verification purposes.
790      *
791      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
792      * this function rejects them by requiring the `s` value to be in the lower
793      * half order, and the `v` value to be either 27 or 28.
794      *
795      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
796      * verification to be secure: it is possible to craft signatures that
797      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
798      * this is by receiving a hash of the original message (which may otherwise
799      * be too long), and then calling {toEthSignedMessageHash} on it.
800      *
801      * Documentation for signature generation:
802      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
803      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
804      *
805      * _Available since v4.3._
806      */
807     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
808         // Check the signature length
809         // - case 65: r,s,v signature (standard)
810         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
811         if (signature.length == 65) {
812             bytes32 r;
813             bytes32 s;
814             uint8 v;
815             // ecrecover takes the signature parameters, and the only way to get them
816             // currently is to use assembly.
817             assembly {
818                 r := mload(add(signature, 0x20))
819                 s := mload(add(signature, 0x40))
820                 v := byte(0, mload(add(signature, 0x60)))
821             }
822             return tryRecover(hash, v, r, s);
823         } else if (signature.length == 64) {
824             bytes32 r;
825             bytes32 vs;
826             // ecrecover takes the signature parameters, and the only way to get them
827             // currently is to use assembly.
828             assembly {
829                 r := mload(add(signature, 0x20))
830                 vs := mload(add(signature, 0x40))
831             }
832             return tryRecover(hash, r, vs);
833         } else {
834             return (address(0), RecoverError.InvalidSignatureLength);
835         }
836     }
837 
838     /**
839      * @dev Returns the address that signed a hashed message (`hash`) with
840      * `signature`. This address can then be used for verification purposes.
841      *
842      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
843      * this function rejects them by requiring the `s` value to be in the lower
844      * half order, and the `v` value to be either 27 or 28.
845      *
846      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
847      * verification to be secure: it is possible to craft signatures that
848      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
849      * this is by receiving a hash of the original message (which may otherwise
850      * be too long), and then calling {toEthSignedMessageHash} on it.
851      */
852     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
853         (address recovered, RecoverError error) = tryRecover(hash, signature);
854         _throwError(error);
855         return recovered;
856     }
857 
858     /**
859      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
860      *
861      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
862      *
863      * _Available since v4.3._
864      */
865     function tryRecover(
866         bytes32 hash,
867         bytes32 r,
868         bytes32 vs
869     ) internal pure returns (address, RecoverError) {
870         bytes32 s;
871         uint8 v;
872         assembly {
873             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
874             v := add(shr(255, vs), 27)
875         }
876         return tryRecover(hash, v, r, s);
877     }
878 
879     /**
880      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
881      *
882      * _Available since v4.2._
883      */
884     function recover(
885         bytes32 hash,
886         bytes32 r,
887         bytes32 vs
888     ) internal pure returns (address) {
889         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
890         _throwError(error);
891         return recovered;
892     }
893 
894     /**
895      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
896      * `r` and `s` signature fields separately.
897      *
898      * _Available since v4.3._
899      */
900     function tryRecover(
901         bytes32 hash,
902         uint8 v,
903         bytes32 r,
904         bytes32 s
905     ) internal pure returns (address, RecoverError) {
906         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
907         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
908         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
909         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
910         //
911         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
912         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
913         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
914         // these malleable signatures as well.
915         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
916             return (address(0), RecoverError.InvalidSignatureS);
917         }
918         if (v != 27 && v != 28) {
919             return (address(0), RecoverError.InvalidSignatureV);
920         }
921 
922         // If the signature is valid (and not malleable), return the signer address
923         address signer = ecrecover(hash, v, r, s);
924         if (signer == address(0)) {
925             return (address(0), RecoverError.InvalidSignature);
926         }
927 
928         return (signer, RecoverError.NoError);
929     }
930 
931     /**
932      * @dev Overload of {ECDSA-recover} that receives the `v`,
933      * `r` and `s` signature fields separately.
934      */
935     function recover(
936         bytes32 hash,
937         uint8 v,
938         bytes32 r,
939         bytes32 s
940     ) internal pure returns (address) {
941         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
942         _throwError(error);
943         return recovered;
944     }
945 
946     /**
947      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
948      * produces hash corresponding to the one signed with the
949      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
950      * JSON-RPC method as part of EIP-191.
951      *
952      * See {recover}.
953      */
954     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
955         // 32 is the length in bytes of hash,
956         // enforced by the type signature above
957         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
958     }
959 
960     /**
961      * @dev Returns an Ethereum Signed Message, created from `s`. This
962      * produces hash corresponding to the one signed with the
963      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
964      * JSON-RPC method as part of EIP-191.
965      *
966      * See {recover}.
967      */
968     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
969         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
970     }
971 
972     /**
973      * @dev Returns an Ethereum Signed Typed Data, created from a
974      * `domainSeparator` and a `structHash`. This produces hash corresponding
975      * to the one signed with the
976      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
977      * JSON-RPC method as part of EIP-712.
978      *
979      * See {recover}.
980      */
981     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
982         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
983     }
984 }
985 
986 ////// lib/openzeppelin-contracts/contracts/utils/cryptography/draft-EIP712.sol
987 // OpenZeppelin Contracts v4.3.2 (utils/cryptography/draft-EIP712.sol)
988 
989 /* pragma solidity ^0.8.0; */
990 
991 /* import "./ECDSA.sol"; */
992 
993 /**
994  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
995  *
996  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
997  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
998  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
999  *
1000  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1001  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1002  * ({_hashTypedDataV4}).
1003  *
1004  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1005  * the chain id to protect against replay attacks on an eventual fork of the chain.
1006  *
1007  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1008  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1009  *
1010  * _Available since v3.4._
1011  */
1012 abstract contract EIP712 {
1013     /* solhint-disable var-name-mixedcase */
1014     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1015     // invalidate the cached domain separator if the chain id changes.
1016     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1017     uint256 private immutable _CACHED_CHAIN_ID;
1018     address private immutable _CACHED_THIS;
1019 
1020     bytes32 private immutable _HASHED_NAME;
1021     bytes32 private immutable _HASHED_VERSION;
1022     bytes32 private immutable _TYPE_HASH;
1023 
1024     /* solhint-enable var-name-mixedcase */
1025 
1026     /**
1027      * @dev Initializes the domain separator and parameter caches.
1028      *
1029      * The meaning of `name` and `version` is specified in
1030      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1031      *
1032      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1033      * - `version`: the current major version of the signing domain.
1034      *
1035      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1036      * contract upgrade].
1037      */
1038     constructor(string memory name, string memory version) {
1039         bytes32 hashedName = keccak256(bytes(name));
1040         bytes32 hashedVersion = keccak256(bytes(version));
1041         bytes32 typeHash = keccak256(
1042             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1043         );
1044         _HASHED_NAME = hashedName;
1045         _HASHED_VERSION = hashedVersion;
1046         _CACHED_CHAIN_ID = block.chainid;
1047         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1048         _CACHED_THIS = address(this);
1049         _TYPE_HASH = typeHash;
1050     }
1051 
1052     /**
1053      * @dev Returns the domain separator for the current chain.
1054      */
1055     function _domainSeparatorV4() internal view returns (bytes32) {
1056         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1057             return _CACHED_DOMAIN_SEPARATOR;
1058         } else {
1059             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1060         }
1061     }
1062 
1063     function _buildDomainSeparator(
1064         bytes32 typeHash,
1065         bytes32 nameHash,
1066         bytes32 versionHash
1067     ) private view returns (bytes32) {
1068         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1069     }
1070 
1071     /**
1072      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1073      * function returns the hash of the fully encoded EIP712 message for this domain.
1074      *
1075      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1076      *
1077      * ```solidity
1078      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1079      *     keccak256("Mail(address to,string contents)"),
1080      *     mailTo,
1081      *     keccak256(bytes(mailContents))
1082      * )));
1083      * address signer = ECDSA.recover(digest, signature);
1084      * ```
1085      */
1086     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1087         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1088     }
1089 }
1090 
1091 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
1092 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/draft-ERC20Permit.sol)
1093 
1094 /* pragma solidity ^0.8.0; */
1095 
1096 /* import "./draft-IERC20Permit.sol"; */
1097 /* import "../ERC20.sol"; */
1098 /* import "../../../utils/cryptography/draft-EIP712.sol"; */
1099 /* import "../../../utils/cryptography/ECDSA.sol"; */
1100 /* import "../../../utils/Counters.sol"; */
1101 
1102 /**
1103  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1104  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1105  *
1106  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1107  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1108  * need to send a transaction, and thus is not required to hold Ether at all.
1109  *
1110  * _Available since v3.4._
1111  */
1112 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1113     using Counters for Counters.Counter;
1114 
1115     mapping(address => Counters.Counter) private _nonces;
1116 
1117     // solhint-disable-next-line var-name-mixedcase
1118     bytes32 private immutable _PERMIT_TYPEHASH =
1119         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1120 
1121     /**
1122      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1123      *
1124      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1125      */
1126     constructor(string memory name) EIP712(name, "1") {}
1127 
1128     /**
1129      * @dev See {IERC20Permit-permit}.
1130      */
1131     function permit(
1132         address owner,
1133         address spender,
1134         uint256 value,
1135         uint256 deadline,
1136         uint8 v,
1137         bytes32 r,
1138         bytes32 s
1139     ) public virtual override {
1140         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1141 
1142         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1143 
1144         bytes32 hash = _hashTypedDataV4(structHash);
1145 
1146         address signer = ECDSA.recover(hash, v, r, s);
1147         require(signer == owner, "ERC20Permit: invalid signature");
1148 
1149         _approve(owner, spender, value);
1150     }
1151 
1152     /**
1153      * @dev See {IERC20Permit-nonces}.
1154      */
1155     function nonces(address owner) public view virtual override returns (uint256) {
1156         return _nonces[owner].current();
1157     }
1158 
1159     /**
1160      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1161      */
1162     // solhint-disable-next-line func-name-mixedcase
1163     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1164         return _domainSeparatorV4();
1165     }
1166 
1167     /**
1168      * @dev "Consume a nonce": return the current value and increment.
1169      *
1170      * _Available since v4.1._
1171      */
1172     function _useNonce(address owner) internal virtual returns (uint256 current) {
1173         Counters.Counter storage nonce = _nonces[owner];
1174         current = nonce.current();
1175         nonce.increment();
1176     }
1177 }
1178 
1179 ////// lib/openzeppelin-contracts/contracts/utils/math/Math.sol
1180 // OpenZeppelin Contracts v4.3.2 (utils/math/Math.sol)
1181 
1182 /* pragma solidity ^0.8.0; */
1183 
1184 /**
1185  * @dev Standard math utilities missing in the Solidity language.
1186  */
1187 library Math {
1188     /**
1189      * @dev Returns the largest of two numbers.
1190      */
1191     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1192         return a >= b ? a : b;
1193     }
1194 
1195     /**
1196      * @dev Returns the smallest of two numbers.
1197      */
1198     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1199         return a < b ? a : b;
1200     }
1201 
1202     /**
1203      * @dev Returns the average of two numbers. The result is rounded towards
1204      * zero.
1205      */
1206     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1207         // (a + b) / 2 can overflow.
1208         return (a & b) + (a ^ b) / 2;
1209     }
1210 
1211     /**
1212      * @dev Returns the ceiling of the division of two numbers.
1213      *
1214      * This differs from standard division with `/` in that it rounds up instead
1215      * of rounding down.
1216      */
1217     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1218         // (a + b - 1) / b can overflow on addition, so we distribute.
1219         return a / b + (a % b == 0 ? 0 : 1);
1220     }
1221 }
1222 
1223 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol
1224 // OpenZeppelin Contracts v4.3.2 (utils/math/SafeCast.sol)
1225 
1226 /* pragma solidity ^0.8.0; */
1227 
1228 /**
1229  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1230  * checks.
1231  *
1232  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1233  * easily result in undesired exploitation or bugs, since developers usually
1234  * assume that overflows raise errors. `SafeCast` restores this intuition by
1235  * reverting the transaction when such an operation overflows.
1236  *
1237  * Using this library instead of the unchecked operations eliminates an entire
1238  * class of bugs, so it's recommended to use it always.
1239  *
1240  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1241  * all math on `uint256` and `int256` and then downcasting.
1242  */
1243 library SafeCast {
1244     /**
1245      * @dev Returns the downcasted uint224 from uint256, reverting on
1246      * overflow (when the input is greater than largest uint224).
1247      *
1248      * Counterpart to Solidity's `uint224` operator.
1249      *
1250      * Requirements:
1251      *
1252      * - input must fit into 224 bits
1253      */
1254     function toUint224(uint256 value) internal pure returns (uint224) {
1255         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1256         return uint224(value);
1257     }
1258 
1259     /**
1260      * @dev Returns the downcasted uint128 from uint256, reverting on
1261      * overflow (when the input is greater than largest uint128).
1262      *
1263      * Counterpart to Solidity's `uint128` operator.
1264      *
1265      * Requirements:
1266      *
1267      * - input must fit into 128 bits
1268      */
1269     function toUint128(uint256 value) internal pure returns (uint128) {
1270         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1271         return uint128(value);
1272     }
1273 
1274     /**
1275      * @dev Returns the downcasted uint96 from uint256, reverting on
1276      * overflow (when the input is greater than largest uint96).
1277      *
1278      * Counterpart to Solidity's `uint96` operator.
1279      *
1280      * Requirements:
1281      *
1282      * - input must fit into 96 bits
1283      */
1284     function toUint96(uint256 value) internal pure returns (uint96) {
1285         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1286         return uint96(value);
1287     }
1288 
1289     /**
1290      * @dev Returns the downcasted uint64 from uint256, reverting on
1291      * overflow (when the input is greater than largest uint64).
1292      *
1293      * Counterpart to Solidity's `uint64` operator.
1294      *
1295      * Requirements:
1296      *
1297      * - input must fit into 64 bits
1298      */
1299     function toUint64(uint256 value) internal pure returns (uint64) {
1300         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1301         return uint64(value);
1302     }
1303 
1304     /**
1305      * @dev Returns the downcasted uint32 from uint256, reverting on
1306      * overflow (when the input is greater than largest uint32).
1307      *
1308      * Counterpart to Solidity's `uint32` operator.
1309      *
1310      * Requirements:
1311      *
1312      * - input must fit into 32 bits
1313      */
1314     function toUint32(uint256 value) internal pure returns (uint32) {
1315         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1316         return uint32(value);
1317     }
1318 
1319     /**
1320      * @dev Returns the downcasted uint16 from uint256, reverting on
1321      * overflow (when the input is greater than largest uint16).
1322      *
1323      * Counterpart to Solidity's `uint16` operator.
1324      *
1325      * Requirements:
1326      *
1327      * - input must fit into 16 bits
1328      */
1329     function toUint16(uint256 value) internal pure returns (uint16) {
1330         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1331         return uint16(value);
1332     }
1333 
1334     /**
1335      * @dev Returns the downcasted uint8 from uint256, reverting on
1336      * overflow (when the input is greater than largest uint8).
1337      *
1338      * Counterpart to Solidity's `uint8` operator.
1339      *
1340      * Requirements:
1341      *
1342      * - input must fit into 8 bits.
1343      */
1344     function toUint8(uint256 value) internal pure returns (uint8) {
1345         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1346         return uint8(value);
1347     }
1348 
1349     /**
1350      * @dev Converts a signed int256 into an unsigned uint256.
1351      *
1352      * Requirements:
1353      *
1354      * - input must be greater than or equal to 0.
1355      */
1356     function toUint256(int256 value) internal pure returns (uint256) {
1357         require(value >= 0, "SafeCast: value must be positive");
1358         return uint256(value);
1359     }
1360 
1361     /**
1362      * @dev Returns the downcasted int128 from int256, reverting on
1363      * overflow (when the input is less than smallest int128 or
1364      * greater than largest int128).
1365      *
1366      * Counterpart to Solidity's `int128` operator.
1367      *
1368      * Requirements:
1369      *
1370      * - input must fit into 128 bits
1371      *
1372      * _Available since v3.1._
1373      */
1374     function toInt128(int256 value) internal pure returns (int128) {
1375         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1376         return int128(value);
1377     }
1378 
1379     /**
1380      * @dev Returns the downcasted int64 from int256, reverting on
1381      * overflow (when the input is less than smallest int64 or
1382      * greater than largest int64).
1383      *
1384      * Counterpart to Solidity's `int64` operator.
1385      *
1386      * Requirements:
1387      *
1388      * - input must fit into 64 bits
1389      *
1390      * _Available since v3.1._
1391      */
1392     function toInt64(int256 value) internal pure returns (int64) {
1393         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1394         return int64(value);
1395     }
1396 
1397     /**
1398      * @dev Returns the downcasted int32 from int256, reverting on
1399      * overflow (when the input is less than smallest int32 or
1400      * greater than largest int32).
1401      *
1402      * Counterpart to Solidity's `int32` operator.
1403      *
1404      * Requirements:
1405      *
1406      * - input must fit into 32 bits
1407      *
1408      * _Available since v3.1._
1409      */
1410     function toInt32(int256 value) internal pure returns (int32) {
1411         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1412         return int32(value);
1413     }
1414 
1415     /**
1416      * @dev Returns the downcasted int16 from int256, reverting on
1417      * overflow (when the input is less than smallest int16 or
1418      * greater than largest int16).
1419      *
1420      * Counterpart to Solidity's `int16` operator.
1421      *
1422      * Requirements:
1423      *
1424      * - input must fit into 16 bits
1425      *
1426      * _Available since v3.1._
1427      */
1428     function toInt16(int256 value) internal pure returns (int16) {
1429         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1430         return int16(value);
1431     }
1432 
1433     /**
1434      * @dev Returns the downcasted int8 from int256, reverting on
1435      * overflow (when the input is less than smallest int8 or
1436      * greater than largest int8).
1437      *
1438      * Counterpart to Solidity's `int8` operator.
1439      *
1440      * Requirements:
1441      *
1442      * - input must fit into 8 bits.
1443      *
1444      * _Available since v3.1._
1445      */
1446     function toInt8(int256 value) internal pure returns (int8) {
1447         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1448         return int8(value);
1449     }
1450 
1451     /**
1452      * @dev Converts an unsigned uint256 into a signed int256.
1453      *
1454      * Requirements:
1455      *
1456      * - input must be less than or equal to maxInt256.
1457      */
1458     function toInt256(uint256 value) internal pure returns (int256) {
1459         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1460         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1461         return int256(value);
1462     }
1463 }
1464 
1465 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol
1466 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/ERC20Votes.sol)
1467 
1468 /* pragma solidity ^0.8.0; */
1469 
1470 /* import "./draft-ERC20Permit.sol"; */
1471 /* import "../../../utils/math/Math.sol"; */
1472 /* import "../../../utils/math/SafeCast.sol"; */
1473 /* import "../../../utils/cryptography/ECDSA.sol"; */
1474 
1475 /**
1476  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1477  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1478  *
1479  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1480  *
1481  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1482  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1483  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1484  *
1485  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1486  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1487  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
1488  * will significantly increase the base gas cost of transfers.
1489  *
1490  * _Available since v4.2._
1491  */
1492 abstract contract ERC20Votes is ERC20Permit {
1493     struct Checkpoint {
1494         uint32 fromBlock;
1495         uint224 votes;
1496     }
1497 
1498     bytes32 private constant _DELEGATION_TYPEHASH =
1499         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1500 
1501     mapping(address => address) private _delegates;
1502     mapping(address => Checkpoint[]) private _checkpoints;
1503     Checkpoint[] private _totalSupplyCheckpoints;
1504 
1505     /**
1506      * @dev Emitted when an account changes their delegate.
1507      */
1508     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1509 
1510     /**
1511      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
1512      */
1513     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1514 
1515     /**
1516      * @dev Get the `pos`-th checkpoint for `account`.
1517      */
1518     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1519         return _checkpoints[account][pos];
1520     }
1521 
1522     /**
1523      * @dev Get number of checkpoints for `account`.
1524      */
1525     function numCheckpoints(address account) public view virtual returns (uint32) {
1526         return SafeCast.toUint32(_checkpoints[account].length);
1527     }
1528 
1529     /**
1530      * @dev Get the address `account` is currently delegating to.
1531      */
1532     function delegates(address account) public view virtual returns (address) {
1533         return _delegates[account];
1534     }
1535 
1536     /**
1537      * @dev Gets the current votes balance for `account`
1538      */
1539     function getVotes(address account) public view returns (uint256) {
1540         uint256 pos = _checkpoints[account].length;
1541         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1542     }
1543 
1544     /**
1545      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
1546      *
1547      * Requirements:
1548      *
1549      * - `blockNumber` must have been already mined
1550      */
1551     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
1552         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1553         return _checkpointsLookup(_checkpoints[account], blockNumber);
1554     }
1555 
1556     /**
1557      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
1558      * It is but NOT the sum of all the delegated votes!
1559      *
1560      * Requirements:
1561      *
1562      * - `blockNumber` must have been already mined
1563      */
1564     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
1565         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1566         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
1567     }
1568 
1569     /**
1570      * @dev Lookup a value in a list of (sorted) checkpoints.
1571      */
1572     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
1573         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
1574         //
1575         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
1576         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
1577         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
1578         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
1579         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
1580         // out of bounds (in which case we're looking too far in the past and the result is 0).
1581         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
1582         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
1583         // the same.
1584         uint256 high = ckpts.length;
1585         uint256 low = 0;
1586         while (low < high) {
1587             uint256 mid = Math.average(low, high);
1588             if (ckpts[mid].fromBlock > blockNumber) {
1589                 high = mid;
1590             } else {
1591                 low = mid + 1;
1592             }
1593         }
1594 
1595         return high == 0 ? 0 : ckpts[high - 1].votes;
1596     }
1597 
1598     /**
1599      * @dev Delegate votes from the sender to `delegatee`.
1600      */
1601     function delegate(address delegatee) public virtual {
1602         _delegate(_msgSender(), delegatee);
1603     }
1604 
1605     /**
1606      * @dev Delegates votes from signer to `delegatee`
1607      */
1608     function delegateBySig(
1609         address delegatee,
1610         uint256 nonce,
1611         uint256 expiry,
1612         uint8 v,
1613         bytes32 r,
1614         bytes32 s
1615     ) public virtual {
1616         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
1617         address signer = ECDSA.recover(
1618             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
1619             v,
1620             r,
1621             s
1622         );
1623         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
1624         _delegate(signer, delegatee);
1625     }
1626 
1627     /**
1628      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
1629      */
1630     function _maxSupply() internal view virtual returns (uint224) {
1631         return type(uint224).max;
1632     }
1633 
1634     /**
1635      * @dev Snapshots the totalSupply after it has been increased.
1636      */
1637     function _mint(address account, uint256 amount) internal virtual override {
1638         super._mint(account, amount);
1639         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
1640 
1641         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
1642     }
1643 
1644     /**
1645      * @dev Snapshots the totalSupply after it has been decreased.
1646      */
1647     function _burn(address account, uint256 amount) internal virtual override {
1648         super._burn(account, amount);
1649 
1650         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
1651     }
1652 
1653     /**
1654      * @dev Move voting power when tokens are transferred.
1655      *
1656      * Emits a {DelegateVotesChanged} event.
1657      */
1658     function _afterTokenTransfer(
1659         address from,
1660         address to,
1661         uint256 amount
1662     ) internal virtual override {
1663         super._afterTokenTransfer(from, to, amount);
1664 
1665         _moveVotingPower(delegates(from), delegates(to), amount);
1666     }
1667 
1668     /**
1669      * @dev Change delegation for `delegator` to `delegatee`.
1670      *
1671      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
1672      */
1673     function _delegate(address delegator, address delegatee) internal virtual {
1674         address currentDelegate = delegates(delegator);
1675         uint256 delegatorBalance = balanceOf(delegator);
1676         _delegates[delegator] = delegatee;
1677 
1678         emit DelegateChanged(delegator, currentDelegate, delegatee);
1679 
1680         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
1681     }
1682 
1683     function _moveVotingPower(
1684         address src,
1685         address dst,
1686         uint256 amount
1687     ) private {
1688         if (src != dst && amount > 0) {
1689             if (src != address(0)) {
1690                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
1691                 emit DelegateVotesChanged(src, oldWeight, newWeight);
1692             }
1693 
1694             if (dst != address(0)) {
1695                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
1696                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
1697             }
1698         }
1699     }
1700 
1701     function _writeCheckpoint(
1702         Checkpoint[] storage ckpts,
1703         function(uint256, uint256) view returns (uint256) op,
1704         uint256 delta
1705     ) private returns (uint256 oldWeight, uint256 newWeight) {
1706         uint256 pos = ckpts.length;
1707         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
1708         newWeight = op(oldWeight, delta);
1709 
1710         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
1711             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
1712         } else {
1713             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
1714         }
1715     }
1716 
1717     function _add(uint256 a, uint256 b) private pure returns (uint256) {
1718         return a + b;
1719     }
1720 
1721     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
1722         return a - b;
1723     }
1724 }
1725 
1726 ////// src/PhononToken.sol
1727 /* pragma solidity ^0.8.0; */
1728 
1729 /* import "@openzeppelin/contracts/access/Ownable.sol"; */
1730 /* import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; */
1731 /* import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol"; */
1732 /* import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol"; */
1733 
1734 /**
1735  * @dev An ERC20 token for PHONON.
1736  *      Besides the addition of voting capabilities, we make a couple of customisations:
1737  *       - Airdrop claim functionality via `claimTokens`. At creation time the tokens that
1738  *         should be available for the airdrop are transferred to the token contract address;
1739  *         airdrop claims are made from this balance.
1740  *       - Support for the owner (the DAO) to mint new tokens, at up to 2% PA.
1741  */
1742 contract PhononToken is ERC20, ERC20Permit, ERC20Votes, Ownable {
1743     uint256 public constant minimumMintInterval = 365 days;
1744     uint256 public constant mintCap = 200; // 2%
1745 
1746     uint256 public nextMint; // Timestamp
1747 
1748     /**
1749      * @dev Constructor.
1750      * @param freeSupply The number of tokens to issue to the contract deployer.
1751      */
1752     constructor(
1753         uint256 freeSupply
1754     )
1755         ERC20("Phonon DAO", "PHONON")
1756         ERC20Permit("Phonon DAO")
1757     {
1758         _mint(msg.sender, freeSupply);
1759         nextMint = block.timestamp + minimumMintInterval;
1760     }
1761 
1762     /**
1763      * @dev Mints new tokens. Can only be executed every `minimumMintInterval`, by the owner, and cannot
1764      *      exceed `mintCap / 10000` fraction of the current total supply.
1765      * @param dest The address to mint the new tokens to.
1766      * @param amount The quantity of tokens to mint.
1767      */
1768     function mint(address dest, uint256 amount) external onlyOwner {
1769         require(amount <= (totalSupply() * mintCap) / 10000, "PHONON: Mint exceeds maximum amount");
1770         require(block.timestamp >= nextMint, "PHONON: Cannot mint yet");
1771 
1772         nextMint = block.timestamp + minimumMintInterval;
1773         _mint(dest, amount);
1774     }
1775 
1776     // The following functions are overrides required by Solidity.
1777 
1778     function _afterTokenTransfer(address from, address to, uint256 amount)
1779         internal
1780         override(ERC20, ERC20Votes)
1781     {
1782         super._afterTokenTransfer(from, to, amount);
1783     }
1784 
1785     function _mint(address to, uint256 amount)
1786         internal
1787         override(ERC20, ERC20Votes)
1788     {
1789         super._mint(to, amount);
1790     }
1791 
1792     function _burn(address account, uint256 amount)
1793         internal
1794         override(ERC20, ERC20Votes)
1795     {
1796         super._burn(account, amount);
1797     }
1798 }
