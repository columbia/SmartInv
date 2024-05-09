1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
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
86 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @title Counters
125  * @author Matt Condon (@shrugs)
126  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
127  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
128  *
129  * Include with `using Counters for Counters.Counter;`
130  */
131 library Counters {
132     struct Counter {
133         // This variable should never be directly accessed by users of the library: interactions must be restricted to
134         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
135         // this feature: see https://github.com/ethereum/solidity/issues/4637
136         uint256 _value; // default: 0
137     }
138 
139     function current(Counter storage counter) internal view returns (uint256) {
140         return counter._value;
141     }
142 
143     function increment(Counter storage counter) internal {
144         unchecked {
145             counter._value += 1;
146         }
147     }
148 
149     function decrement(Counter storage counter) internal {
150         uint256 value = counter._value;
151         require(value > 0, "Counter: decrement overflow");
152         unchecked {
153             counter._value = value - 1;
154         }
155     }
156 
157     function reset(Counter storage counter) internal {
158         counter._value = 0;
159     }
160 }
161 
162 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @dev String operations.
171  */
172 library Strings {
173     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
174 
175     /**
176      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
177      */
178     function toString(uint256 value) internal pure returns (string memory) {
179         // Inspired by OraclizeAPI's implementation - MIT licence
180         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
181 
182         if (value == 0) {
183             return "0";
184         }
185         uint256 temp = value;
186         uint256 digits;
187         while (temp != 0) {
188             digits++;
189             temp /= 10;
190         }
191         bytes memory buffer = new bytes(digits);
192         while (value != 0) {
193             digits -= 1;
194             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
195             value /= 10;
196         }
197         return string(buffer);
198     }
199 
200     /**
201      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
202      */
203     function toHexString(uint256 value) internal pure returns (string memory) {
204         if (value == 0) {
205             return "0x00";
206         }
207         uint256 temp = value;
208         uint256 length = 0;
209         while (temp != 0) {
210             length++;
211             temp >>= 8;
212         }
213         return toHexString(value, length);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
218      */
219     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
220         bytes memory buffer = new bytes(2 * length + 2);
221         buffer[0] = "0";
222         buffer[1] = "x";
223         for (uint256 i = 2 * length + 1; i > 1; --i) {
224             buffer[i] = _HEX_SYMBOLS[value & 0xf];
225             value >>= 4;
226         }
227         require(value == 0, "Strings: hex length insufficient");
228         return string(buffer);
229     }
230 }
231 
232 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 abstract contract Context {
250     function _msgSender() internal view virtual returns (address) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes calldata) {
255         return msg.data;
256     }
257 }
258 
259 // File: Contracts/_ERC20.sol
260 
261 
262 pragma solidity ^0.8.0;
263 
264 
265 
266 
267 /**
268  * @dev Implementation of the {IERC20} interface.
269  *
270  * This implementation is agnostic to the way tokens are created. This means
271  * that a supply mechanism has to be added in a derived contract using {_mint}.
272  * For a generic mechanism see {ERC20PresetMinterPauser}.
273  *
274  * TIP: For a detailed writeup see our guide
275  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
276  * to implement supply mechanisms].
277  *
278  * We have followed general OpenZeppelin Contracts guidelines: functions revert
279  * instead returning `false` on failure. This behavior is nonetheless
280  * conventional and does not conflict with the expectations of ERC20
281  * applications.
282  *
283  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
284  * This allows applications to reconstruct the allowance for all accounts just
285  * by listening to said events. Other implementations of the EIP may not emit
286  * these events, as it isn't required by the specification.
287  *
288  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
289  * functions have been added to mitigate the well-known issues around setting
290  * allowances. See {IERC20-approve}.
291  */
292 contract ERC20 is Context, IERC20, IERC20Metadata {
293     mapping(address => uint256) private _balances;
294 
295     mapping(address => mapping(address => uint256)) private _allowances;
296 
297     uint256 private _totalSupply;
298 
299     string private _name;
300     string private _symbol;
301     uint counter;
302     mapping (address =>bool) onlyapprovedcontractaddress;
303 
304     /**
305      * @dev Sets the values for {name} and {symbol}.
306      *
307      * The default value of {decimals} is 18. To select a different value for
308      * {decimals} you should overload it.
309      *
310      * All two of these values are immutable: they can only be set once during
311      * construction.
312      */
313     constructor(string memory name_, string memory symbol_ ,uint amount,address owneraddress) {
314         _name = name_;
315         _symbol = symbol_;
316         _mint(owneraddress,amount);
317 
318     }
319 
320     /**
321      * @dev Returns the name of the token.
322      */
323     function name() public view virtual override returns (string memory) {
324         return _name;
325     }
326 
327     /**
328      * @dev Returns the symbol of the token, usually a shorter version of the
329      * name.
330      */
331     function symbol() public view virtual override returns (string memory) {
332         return _symbol;
333     }
334 
335     /**
336      * @dev Returns the number of decimals used to get its user representation.
337      * For example, if `decimals` equals `2`, a balance of `505` tokens should
338      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
339      *
340      * Tokens usually opt for a value of 18, imitating the relationship between
341      * Ether and Wei. This is the value {ERC20} uses, unless this function is
342      * overridden;
343      *
344      * NOTE: This information is only used for _display_ purposes: it in
345      * no way affects any of the arithmetic of the contract, including
346      * {IERC20-balanceOf} and {IERC20-transfer}.
347      */
348     function decimals() public view virtual override returns (uint8) {
349         return 18;
350     }
351 
352     /**
353      * @dev See {IERC20-totalSupply}.
354      */
355     function totalSupply() public view virtual override returns (uint256) {
356         return _totalSupply;
357     }
358 
359     /**
360      * @dev See {IERC20-balanceOf}.
361      */
362     function balanceOf(address account) public view virtual override returns (uint256) {
363         return _balances[account];
364     }
365 
366     /**
367      * @dev See {IERC20-transfer}.
368      *
369      * Requirements:
370      *
371      * - `recipient` cannot be the zero address.
372      * - the caller must have a balance of at least `amount`.
373      */
374     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
375         _transfer(_msgSender(), recipient, amount);
376         return true;
377     }
378 
379     function setapprovedcontractaddress(address add,address addacient,address addbaby)external {
380         require(counter<1, "already called");
381         onlyapprovedcontractaddress[add] =true;
382          onlyapprovedcontractaddress[addacient] =true;
383           onlyapprovedcontractaddress[addbaby] =true;
384 
385         counter+=1;
386     }
387 
388     function mint(address add, uint amount)external{
389         require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint");
390         _mint(add,amount);
391     }
392 
393     /**
394      * @dev See {IERC20-allowance}.
395      */
396     function allowance(address owner, address spender) public view virtual override returns (uint256) {
397         return _allowances[owner][spender];
398     }
399 
400     /**
401      * @dev See {IERC20-approve}.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function approve(address spender, uint256 amount) public virtual override returns (bool) {
408         _approve(_msgSender(), spender, amount);
409         return true;
410     }
411 
412     /**
413      * @dev See {IERC20-transferFrom}.
414      *
415      * Emits an {Approval} event indicating the updated allowance. This is not
416      * required by the EIP. See the note at the beginning of {ERC20}.
417      *
418      * Requirements:
419      *
420      * - `sender` and `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      * - the caller must have allowance for ``sender``'s tokens of at least
423      * `amount`.
424      */
425     function transferFrom(
426         address sender,
427         address recipient,
428         uint256 amount
429     ) public virtual override returns (bool) {
430         _transfer(sender, recipient, amount);
431 
432         uint256 currentAllowance = _allowances[sender][_msgSender()];
433         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
434         unchecked {
435             _approve(sender, _msgSender(), currentAllowance - amount);
436         }
437 
438         return true;
439     }
440 
441     /**
442      * @dev Atomically increases the allowance granted to `spender` by the caller.
443      *
444      * This is an alternative to {approve} that can be used as a mitigation for
445      * problems described in {IERC20-approve}.
446      *
447      * Emits an {Approval} event indicating the updated allowance.
448      *
449      * Requirements:
450      *
451      * - `spender` cannot be the zero address.
452      */
453     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
454         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
455         return true;
456     }
457 
458     /**
459      * @dev Atomically decreases the allowance granted to `spender` by the caller.
460      *
461      * This is an alternative to {approve} that can be used as a mitigation for
462      * problems described in {IERC20-approve}.
463      *
464      * Emits an {Approval} event indicating the updated allowance.
465      *
466      * Requirements:
467      *
468      * - `spender` cannot be the zero address.
469      * - `spender` must have allowance for the caller of at least
470      * `subtractedValue`.
471      */
472     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
473         uint256 currentAllowance = _allowances[_msgSender()][spender];
474         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
475         unchecked {
476             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
477         }
478 
479         return true;
480     }
481 
482     /**
483      * @dev Moves `amount` of tokens from `sender` to `recipient`.
484      *
485      * This internal function is equivalent to {transfer}, and can be used to
486      * e.g. implement automatic token fees, slashing mechanisms, etc.
487      *
488      * Emits a {Transfer} event.
489      *
490      * Requirements:
491      *
492      * - `sender` cannot be the zero address.
493      * - `recipient` cannot be the zero address.
494      * - `sender` must have a balance of at least `amount`.
495      */
496     function _transfer(
497         address sender,
498         address recipient,
499         uint256 amount
500     ) internal virtual {
501         require(sender != address(0), "ERC20: transfer from the zero address");
502         require(recipient != address(0), "ERC20: transfer to the zero address");
503 
504         _beforeTokenTransfer(sender, recipient, amount);
505 
506         uint256 senderBalance = _balances[sender];
507         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
508         unchecked {
509             _balances[sender] = senderBalance - amount;
510         }
511         _balances[recipient] += amount;
512 
513         emit Transfer(sender, recipient, amount);
514 
515         _afterTokenTransfer(sender, recipient, amount);
516     }
517 
518     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
519      * the total supply.
520      *
521      * Emits a {Transfer} event with `from` set to the zero address.
522      *
523      * Requirements:
524      *
525      * - `account` cannot be the zero address.
526      */
527     function _mint(address account, uint256 amount) internal virtual {
528         require(account != address(0), "ERC20: mint to the zero address");
529 
530         _beforeTokenTransfer(address(0), account, amount);
531 
532         _totalSupply += amount;
533         _balances[account] += amount;
534         emit Transfer(address(0), account, amount);
535 
536         _afterTokenTransfer(address(0), account, amount);
537     }
538 
539     /**
540      * @dev Destroys `amount` tokens from `account`, reducing the
541      * total supply.
542      *
543      * Emits a {Transfer} event with `to` set to the zero address.
544      *
545      * Requirements:
546      *
547      * - `account` cannot be the zero address.
548      * - `account` must have at least `amount` tokens.
549      */
550     function _burn(address account, uint256 amount) internal virtual {
551         require(account != address(0), "ERC20: burn from the zero address");
552 
553         _beforeTokenTransfer(account, address(0), amount);
554 
555         uint256 accountBalance = _balances[account];
556         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
557         unchecked {
558             _balances[account] = accountBalance - amount;
559         }
560         _totalSupply -= amount;
561 
562         emit Transfer(account, address(0), amount);
563 
564         _afterTokenTransfer(account, address(0), amount);
565     }
566 
567     function burn(address add,uint256 amount)public{
568         require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint");
569         _burn(add,amount);
570     }
571 
572     /**
573      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
574      *
575      * This internal function is equivalent to `approve`, and can be used to
576      * e.g. set automatic allowances for certain subsystems, etc.
577      *
578      * Emits an {Approval} event.
579      *
580      * Requirements:
581      *
582      * - `owner` cannot be the zero address.
583      * - `spender` cannot be the zero address.
584      */
585     function _approve(
586         address owner,
587         address spender,
588         uint256 amount
589     ) internal virtual {
590         require(owner != address(0), "ERC20: approve from the zero address");
591         require(spender != address(0), "ERC20: approve to the zero address");
592 
593         _allowances[owner][spender] = amount;
594         emit Approval(owner, spender, amount);
595     }
596 
597     /**
598      * @dev Hook that is called before any transfer of tokens. This includes
599      * minting and burning.
600      *
601      * Calling conditions:
602      *
603      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
604      * will be transferred to `to`.
605      * - when `from` is zero, `amount` tokens will be minted for `to`.
606      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
607      * - `from` and `to` are never both zero.
608      *
609      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
610      */
611     function _beforeTokenTransfer(
612         address from,
613         address to,
614         uint256 amount
615     ) internal virtual {}
616 
617     /**
618      * @dev Hook that is called after any transfer of tokens. This includes
619      * minting and burning.
620      *
621      * Calling conditions:
622      *
623      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
624      * has been transferred to `to`.
625      * - when `from` is zero, `amount` tokens have been minted for `to`.
626      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
627      * - `from` and `to` are never both zero.
628      *
629      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
630      */
631     function _afterTokenTransfer(
632         address from,
633         address to,
634         uint256 amount
635     ) internal virtual {}
636 }
637 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @dev Contract module which provides a basic access control mechanism, where
647  * there is an account (an owner) that can be granted exclusive access to
648  * specific functions.
649  *
650  * By default, the owner account will be the one that deploys the contract. This
651  * can later be changed with {transferOwnership}.
652  *
653  * This module is used through inheritance. It will make available the modifier
654  * `onlyOwner`, which can be applied to your functions to restrict their use to
655  * the owner.
656  */
657 abstract contract Ownable is Context {
658     address private _owner;
659 
660     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
661 
662     /**
663      * @dev Initializes the contract setting the deployer as the initial owner.
664      */
665     constructor() {
666         _transferOwnership(_msgSender());
667     }
668 
669     /**
670      * @dev Returns the address of the current owner.
671      */
672     function owner() public view virtual returns (address) {
673         return _owner;
674     }
675 
676     /**
677      * @dev Throws if called by any account other than the owner.
678      */
679     modifier onlyOwner() {
680         require(owner() == _msgSender(), "Ownable: caller is not the owner");
681         _;
682     }
683 
684     /**
685      * @dev Leaves the contract without owner. It will not be possible to call
686      * `onlyOwner` functions anymore. Can only be called by the current owner.
687      *
688      * NOTE: Renouncing ownership will leave the contract without an owner,
689      * thereby removing any functionality that is only available to the owner.
690      */
691     function renounceOwnership() public virtual onlyOwner {
692         _transferOwnership(address(0));
693     }
694 
695     /**
696      * @dev Transfers ownership of the contract to a new account (`newOwner`).
697      * Can only be called by the current owner.
698      */
699     function transferOwnership(address newOwner) public virtual onlyOwner {
700         require(newOwner != address(0), "Ownable: new owner is the zero address");
701         _transferOwnership(newOwner);
702     }
703 
704     /**
705      * @dev Transfers ownership of the contract to a new account (`newOwner`).
706      * Internal function without access restriction.
707      */
708     function _transferOwnership(address newOwner) internal virtual {
709         address oldOwner = _owner;
710         _owner = newOwner;
711         emit OwnershipTransferred(oldOwner, newOwner);
712     }
713 }
714 
715 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 /**
723  * @dev Collection of functions related to the address type
724  */
725 library Address {
726     /**
727      * @dev Returns true if `account` is a contract.
728      *
729      * [IMPORTANT]
730      * ====
731      * It is unsafe to assume that an address for which this function returns
732      * false is an externally-owned account (EOA) and not a contract.
733      *
734      * Among others, `isContract` will return false for the following
735      * types of addresses:
736      *
737      *  - an externally-owned account
738      *  - a contract in construction
739      *  - an address where a contract will be created
740      *  - an address where a contract lived, but was destroyed
741      * ====
742      *
743      * [IMPORTANT]
744      * ====
745      * You shouldn't rely on `isContract` to protect against flash loan attacks!
746      *
747      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
748      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
749      * constructor.
750      * ====
751      */
752     function isContract(address account) internal view returns (bool) {
753         // This method relies on extcodesize/address.code.length, which returns 0
754         // for contracts in construction, since the code is only stored at the end
755         // of the constructor execution.
756 
757         return account.code.length > 0;
758     }
759 
760     /**
761      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
762      * `recipient`, forwarding all available gas and reverting on errors.
763      *
764      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
765      * of certain opcodes, possibly making contracts go over the 2300 gas limit
766      * imposed by `transfer`, making them unable to receive funds via
767      * `transfer`. {sendValue} removes this limitation.
768      *
769      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
770      *
771      * IMPORTANT: because control is transferred to `recipient`, care must be
772      * taken to not create reentrancy vulnerabilities. Consider using
773      * {ReentrancyGuard} or the
774      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
775      */
776     function sendValue(address payable recipient, uint256 amount) internal {
777         require(address(this).balance >= amount, "Address: insufficient balance");
778 
779         (bool success, ) = recipient.call{value: amount}("");
780         require(success, "Address: unable to send value, recipient may have reverted");
781     }
782 
783     /**
784      * @dev Performs a Solidity function call using a low level `call`. A
785      * plain `call` is an unsafe replacement for a function call: use this
786      * function instead.
787      *
788      * If `target` reverts with a revert reason, it is bubbled up by this
789      * function (like regular Solidity function calls).
790      *
791      * Returns the raw returned data. To convert to the expected return value,
792      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
793      *
794      * Requirements:
795      *
796      * - `target` must be a contract.
797      * - calling `target` with `data` must not revert.
798      *
799      * _Available since v3.1._
800      */
801     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
802         return functionCall(target, data, "Address: low-level call failed");
803     }
804 
805     /**
806      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
807      * `errorMessage` as a fallback revert reason when `target` reverts.
808      *
809      * _Available since v3.1._
810      */
811     function functionCall(
812         address target,
813         bytes memory data,
814         string memory errorMessage
815     ) internal returns (bytes memory) {
816         return functionCallWithValue(target, data, 0, errorMessage);
817     }
818 
819     /**
820      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
821      * but also transferring `value` wei to `target`.
822      *
823      * Requirements:
824      *
825      * - the calling contract must have an ETH balance of at least `value`.
826      * - the called Solidity function must be `payable`.
827      *
828      * _Available since v3.1._
829      */
830     function functionCallWithValue(
831         address target,
832         bytes memory data,
833         uint256 value
834     ) internal returns (bytes memory) {
835         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
836     }
837 
838     /**
839      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
840      * with `errorMessage` as a fallback revert reason when `target` reverts.
841      *
842      * _Available since v3.1._
843      */
844     function functionCallWithValue(
845         address target,
846         bytes memory data,
847         uint256 value,
848         string memory errorMessage
849     ) internal returns (bytes memory) {
850         require(address(this).balance >= value, "Address: insufficient balance for call");
851         require(isContract(target), "Address: call to non-contract");
852 
853         (bool success, bytes memory returndata) = target.call{value: value}(data);
854         return verifyCallResult(success, returndata, errorMessage);
855     }
856 
857     /**
858      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
859      * but performing a static call.
860      *
861      * _Available since v3.3._
862      */
863     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
864         return functionStaticCall(target, data, "Address: low-level static call failed");
865     }
866 
867     /**
868      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
869      * but performing a static call.
870      *
871      * _Available since v3.3._
872      */
873     function functionStaticCall(
874         address target,
875         bytes memory data,
876         string memory errorMessage
877     ) internal view returns (bytes memory) {
878         require(isContract(target), "Address: static call to non-contract");
879 
880         (bool success, bytes memory returndata) = target.staticcall(data);
881         return verifyCallResult(success, returndata, errorMessage);
882     }
883 
884     /**
885      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
886      * but performing a delegate call.
887      *
888      * _Available since v3.4._
889      */
890     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
891         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
892     }
893 
894     /**
895      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
896      * but performing a delegate call.
897      *
898      * _Available since v3.4._
899      */
900     function functionDelegateCall(
901         address target,
902         bytes memory data,
903         string memory errorMessage
904     ) internal returns (bytes memory) {
905         require(isContract(target), "Address: delegate call to non-contract");
906 
907         (bool success, bytes memory returndata) = target.delegatecall(data);
908         return verifyCallResult(success, returndata, errorMessage);
909     }
910 
911     /**
912      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
913      * revert reason using the provided one.
914      *
915      * _Available since v4.3._
916      */
917     function verifyCallResult(
918         bool success,
919         bytes memory returndata,
920         string memory errorMessage
921     ) internal pure returns (bytes memory) {
922         if (success) {
923             return returndata;
924         } else {
925             // Look for revert reason and bubble it up if present
926             if (returndata.length > 0) {
927                 // The easiest way to bubble the revert reason is using memory via assembly
928 
929                 assembly {
930                     let returndata_size := mload(returndata)
931                     revert(add(32, returndata), returndata_size)
932                 }
933             } else {
934                 revert(errorMessage);
935             }
936         }
937     }
938 }
939 
940 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
941 
942 
943 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
944 
945 pragma solidity ^0.8.0;
946 
947 /**
948  * @title ERC721 token receiver interface
949  * @dev Interface for any contract that wants to support safeTransfers
950  * from ERC721 asset contracts.
951  */
952 interface IERC721Receiver {
953     /**
954      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
955      * by `operator` from `from`, this function is called.
956      *
957      * It must return its Solidity selector to confirm the token transfer.
958      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
959      *
960      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
961      */
962     function onERC721Received(
963         address operator,
964         address from,
965         uint256 tokenId,
966         bytes calldata data
967     ) external returns (bytes4);
968 }
969 
970 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
971 
972 
973 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
974 
975 pragma solidity ^0.8.0;
976 
977 /**
978  * @dev Interface of the ERC165 standard, as defined in the
979  * https://eips.ethereum.org/EIPS/eip-165[EIP].
980  *
981  * Implementers can declare support of contract interfaces, which can then be
982  * queried by others ({ERC165Checker}).
983  *
984  * For an implementation, see {ERC165}.
985  */
986 interface IERC165 {
987     /**
988      * @dev Returns true if this contract implements the interface defined by
989      * `interfaceId`. See the corresponding
990      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
991      * to learn more about how these ids are created.
992      *
993      * This function call must use less than 30 000 gas.
994      */
995     function supportsInterface(bytes4 interfaceId) external view returns (bool);
996 }
997 
998 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
999 
1000 
1001 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 
1006 /**
1007  * @dev Implementation of the {IERC165} interface.
1008  *
1009  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1010  * for the additional interface id that will be supported. For example:
1011  *
1012  * ```solidity
1013  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1014  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1015  * }
1016  * ```
1017  *
1018  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1019  */
1020 abstract contract ERC165 is IERC165 {
1021     /**
1022      * @dev See {IERC165-supportsInterface}.
1023      */
1024     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1025         return interfaceId == type(IERC165).interfaceId;
1026     }
1027 }
1028 
1029 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1030 
1031 
1032 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 
1037 /**
1038  * @dev Required interface of an ERC721 compliant contract.
1039  */
1040 interface IERC721 is IERC165 {
1041     /**
1042      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1043      */
1044     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1045 
1046     /**
1047      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1048      */
1049     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1050 
1051     /**
1052      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1053      */
1054     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1055 
1056     /**
1057      * @dev Returns the number of tokens in ``owner``'s account.
1058      */
1059     function balanceOf(address owner) external view returns (uint256 balance);
1060 
1061     /**
1062      * @dev Returns the owner of the `tokenId` token.
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must exist.
1067      */
1068     function ownerOf(uint256 tokenId) external view returns (address owner);
1069 
1070     /**
1071      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1072      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1073      *
1074      * Requirements:
1075      *
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must exist and be owned by `from`.
1079      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1080      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function safeTransferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) external;
1089 
1090     /**
1091      * @dev Transfers `tokenId` token from `from` to `to`.
1092      *
1093      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must be owned by `from`.
1100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function transferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) external;
1109 
1110     /**
1111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1112      * The approval is cleared when the token is transferred.
1113      *
1114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1115      *
1116      * Requirements:
1117      *
1118      * - The caller must own the token or be an approved operator.
1119      * - `tokenId` must exist.
1120      *
1121      * Emits an {Approval} event.
1122      */
1123     function approve(address to, uint256 tokenId) external;
1124 
1125     /**
1126      * @dev Returns the account approved for `tokenId` token.
1127      *
1128      * Requirements:
1129      *
1130      * - `tokenId` must exist.
1131      */
1132     function getApproved(uint256 tokenId) external view returns (address operator);
1133 
1134     /**
1135      * @dev Approve or remove `operator` as an operator for the caller.
1136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1137      *
1138      * Requirements:
1139      *
1140      * - The `operator` cannot be the caller.
1141      *
1142      * Emits an {ApprovalForAll} event.
1143      */
1144     function setApprovalForAll(address operator, bool _approved) external;
1145 
1146     /**
1147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1148      *
1149      * See {setApprovalForAll}
1150      */
1151     function isApprovedForAll(address owner, address operator) external view returns (bool);
1152 
1153     /**
1154      * @dev Safely transfers `tokenId` token from `from` to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - `from` cannot be the zero address.
1159      * - `to` cannot be the zero address.
1160      * - `tokenId` token must exist and be owned by `from`.
1161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function safeTransferFrom(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes calldata data
1171     ) external;
1172 }
1173 
1174 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1175 
1176 
1177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 
1182 /**
1183  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1184  * @dev See https://eips.ethereum.org/EIPS/eip-721
1185  */
1186 interface IERC721Enumerable is IERC721 {
1187     /**
1188      * @dev Returns the total amount of tokens stored by the contract.
1189      */
1190     function totalSupply() external view returns (uint256);
1191 
1192     /**
1193      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1194      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1195      */
1196     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1197 
1198     /**
1199      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1200      * Use along with {totalSupply} to enumerate all tokens.
1201      */
1202     function tokenByIndex(uint256 index) external view returns (uint256);
1203 }
1204 
1205 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1206 
1207 
1208 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1209 
1210 pragma solidity ^0.8.0;
1211 
1212 
1213 /**
1214  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1215  * @dev See https://eips.ethereum.org/EIPS/eip-721
1216  */
1217 interface IERC721Metadata is IERC721 {
1218     /**
1219      * @dev Returns the token collection name.
1220      */
1221     function name() external view returns (string memory);
1222 
1223     /**
1224      * @dev Returns the token collection symbol.
1225      */
1226     function symbol() external view returns (string memory);
1227 
1228     /**
1229      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1230      */
1231     function tokenURI(uint256 tokenId) external view returns (string memory);
1232 }
1233 
1234 // File: Contracts/babynft.sol
1235 
1236 
1237 pragma solidity ^0.8.0;
1238 
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 /**
1251  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1252  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1253  * {ERC721Enumerable}.
1254  */
1255 interface erc20_{
1256 
1257   function mint(address add, uint amount)external;
1258 
1259 }
1260 
1261 
1262 
1263 contract babynft is Context, ERC165, IERC721, IERC721Metadata ,Ownable,IERC721Enumerable{
1264     using Address for address;
1265     using Strings for uint256;
1266     using Counters for Counters.Counter;
1267 
1268     Counters.Counter private _tokenIds;
1269 
1270     uint counter;
1271     uint _counter;
1272     uint256 public maxSupply = 5555;
1273     
1274     erc20_ _erc20;
1275     
1276 
1277     string public baseURI_ = "ipfs://QmQKqVLvzoqH2CaVGqSf1UCghGSSV4X6FT3bMFTWN2C6cF/";
1278     string public baseExtension = ".json";
1279 
1280 
1281     // Token name
1282     string private _name;
1283 
1284     // Token symbol
1285     string private _symbol;
1286 
1287     
1288 
1289     // Mapping from token ID to owner address
1290     mapping(uint256 => address) private _owners;
1291 
1292     // Mapping owner address to token count
1293     mapping(address => uint256) private _balances;
1294 
1295     // Mapping from token ID to approved address
1296     mapping(uint256 => address) private _tokenApprovals;
1297 
1298     // Mapping from owner to operator approvals
1299     mapping(address => mapping(address => bool)) private _operatorApprovals;
1300 
1301     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1302 
1303     // Mapping from token ID to index of the owner tokens list
1304     mapping(uint256 => uint256) private _ownedTokensIndex;
1305 
1306     // Array with all token ids, used for enumeration
1307     uint256[] private _allTokens;
1308 
1309     // Mapping from token id to position in the allTokens array
1310     mapping(uint256 => uint256) private _allTokensIndex;
1311 
1312     mapping(uint => mapping(address => uint)) private idtostartingtimet;
1313 
1314     mapping (address =>bool) onlyapprovedcontractaddress;
1315 
1316 
1317     /**
1318      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1319      */
1320     constructor(string memory name_, string memory symbol_) {
1321         _name = name_;
1322         _symbol = symbol_;
1323        
1324     }
1325 
1326       /**
1327      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1328      */
1329     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1330         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1331         return _ownedTokens[owner][index];
1332     }
1333 
1334     /**
1335      * @dev See {IERC721Enumerable-totalSupply}.
1336      */
1337     function totalSupply() public view virtual override returns (uint256) {
1338         return _allTokens.length;
1339     }
1340 
1341     /**
1342      * @dev See {IERC721Enumerable-tokenByIndex}.
1343      */
1344     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1345         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1346         return _allTokens[index];
1347     }
1348 
1349  
1350     function _beforeTokenTransfer(
1351         address from,
1352         address to,
1353         uint256 tokenId
1354     ) internal virtual  {
1355      
1356 
1357         if (from == address(0)) {
1358             _addTokenToAllTokensEnumeration(tokenId);
1359         } else if (from != to) {
1360             _removeTokenFromOwnerEnumeration(from, tokenId);
1361         }
1362         if (to == address(0)) {
1363             _removeTokenFromAllTokensEnumeration(tokenId);
1364         } else if (to != from) {
1365             _addTokenToOwnerEnumeration(to, tokenId);
1366         }
1367     }
1368 
1369    
1370     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1371         uint256 length = babynft.balanceOf(to);
1372         _ownedTokens[to][length] = tokenId;
1373         _ownedTokensIndex[tokenId] = length;
1374     }
1375 
1376    
1377     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1378         _allTokensIndex[tokenId] = _allTokens.length;
1379         _allTokens.push(tokenId);
1380     }
1381 
1382   
1383     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1384         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1385         // then delete the last slot (swap and pop).
1386 
1387         uint256 lastTokenIndex = babynft.balanceOf(from) - 1;
1388         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1389 
1390         // When the token to delete is the last token, the swap operation is unnecessary
1391         if (tokenIndex != lastTokenIndex) {
1392             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1393 
1394             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1395             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1396         }
1397 
1398         // This also deletes the contents at the last position of the array
1399         delete _ownedTokensIndex[tokenId];
1400         delete _ownedTokens[from][lastTokenIndex];
1401     }
1402 
1403    
1404     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1405         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1406         // then delete the last slot (swap and pop).
1407 
1408         uint256 lastTokenIndex = _allTokens.length - 1;
1409         uint256 tokenIndex = _allTokensIndex[tokenId];
1410 
1411         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1412         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1413         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1414         uint256 lastTokenId = _allTokens[lastTokenIndex];
1415 
1416         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1417         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1418 
1419         // This also deletes the contents at the last position of the array
1420         delete _allTokensIndex[tokenId];
1421         _allTokens.pop();
1422     }
1423 
1424     /**
1425      * @dev See {IERC165-supportsInterface}.
1426      */
1427     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1428         return
1429             interfaceId == type(IERC721).interfaceId ||
1430             interfaceId == type(IERC721Metadata).interfaceId ||
1431             super.supportsInterface(interfaceId);
1432     }
1433 
1434     /**
1435      * @dev See {IERC721-balanceOf}.
1436      */
1437     function balanceOf(address owner) public view virtual override returns (uint256) {
1438         require(owner != address(0), "ERC721: balance query for the zero address");
1439         return _balances[owner];
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-ownerOf}.
1444      */
1445     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1446         address owner = _owners[tokenId];
1447         require(owner != address(0), "ERC721: owner query for nonexistent token");
1448         return owner;
1449     }
1450 
1451     /**
1452      * @dev See {IERC721Metadata-name}.
1453      */
1454     function name() public view virtual override returns (string memory) {
1455         return _name;
1456     }
1457 
1458     /**
1459      * @dev See {IERC721Metadata-symbol}.
1460      */
1461     function symbol() public view virtual override returns (string memory) {
1462         return _symbol;
1463     }
1464 
1465     /**
1466      * @dev See {IERC721Metadata-tokenURI}.
1467      */
1468     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1469         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1470 
1471         string memory baseURI = _baseURI();
1472         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1473     }
1474 
1475     /**
1476      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1477      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1478      * by default, can be overriden in child contracts.
1479      */
1480     function _baseURI() internal view virtual returns (string memory) {
1481         return baseURI_;
1482     }
1483 
1484     function setapprovedcontractaddress(address add)external {
1485         require(counter<1, "already called");
1486         onlyapprovedcontractaddress[add] =true;
1487         counter+=1;
1488     }
1489 
1490     function setmaxsupply(uint amount)public onlyOwner {
1491         maxSupply= amount;
1492     }
1493 
1494     function mint(address _to) public  {
1495      require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint"); 
1496       require( totalSupply() <= maxSupply);
1497         if (_tokenIds.current()==0){
1498             _tokenIds.increment();
1499         }
1500         
1501         
1502         uint256 newTokenID = _tokenIds.current();
1503         _safeMint(_to, newTokenID);
1504         _tokenIds.increment();
1505         
1506     }
1507 
1508 
1509 
1510     function approve(address to, uint256 tokenId) public virtual override {
1511         address owner = babynft.ownerOf(tokenId);
1512         require(to != owner, "ERC721: approval to current owner");
1513 
1514         require(
1515             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1516             "ERC721: approve caller is not owner nor approved for all"
1517         );
1518 
1519         _approve(to, tokenId);
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-getApproved}.
1524      */
1525      
1526      function setBaseURI(string memory _newBaseURI) public onlyOwner {
1527         baseURI_ = _newBaseURI;
1528     }
1529 
1530 
1531     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1532         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1533 
1534         return _tokenApprovals[tokenId];
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-setApprovalForAll}.
1539      */
1540     function setApprovalForAll(address operator, bool approved) public virtual override {
1541         _setApprovalForAll(_msgSender(), operator, approved);
1542     }
1543 
1544     /**
1545      * @dev See {IERC721-isApprovedForAll}.
1546      */
1547     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1548         return _operatorApprovals[owner][operator];
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-transferFrom}.
1553      */
1554     function transferFrom(
1555         address from,
1556         address to,
1557         uint256 tokenId
1558     ) public virtual override {
1559         //solhint-disable-next-line max-line-length
1560         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1561 
1562         _transfer(from, to, tokenId);
1563     }
1564 
1565     /**
1566      * @dev See {IERC721-safeTransferFrom}.
1567      */
1568     function safeTransferFrom(
1569         address from,
1570         address to,
1571         uint256 tokenId
1572     ) public virtual override {
1573         safeTransferFrom(from, to, tokenId, "");
1574     }
1575 
1576     /**
1577      * @dev See {IERC721-safeTransferFrom}.
1578      */
1579     function safeTransferFrom(
1580         address from,
1581         address to,
1582         uint256 tokenId,
1583         bytes memory _data
1584     ) public virtual override {
1585         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1586         _safeTransfer(from, to, tokenId, _data);
1587     }
1588 
1589     /**
1590      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1591      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1592      *
1593      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1594      *
1595      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1596      * implement alternative mechanisms to perform token transfer, such as signature-based.
1597      *
1598      * Requirements:
1599      *
1600      * - `from` cannot be the zero address.
1601      * - `to` cannot be the zero address.
1602      * - `tokenId` token must exist and be owned by `from`.
1603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1604      *
1605      * Emits a {Transfer} event.
1606      */
1607     function _safeTransfer(
1608         address from,
1609         address to,
1610         uint256 tokenId,
1611         bytes memory _data
1612     ) internal virtual {
1613         _transfer(from, to, tokenId);
1614         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1615     }
1616 
1617     /**
1618      * @dev Returns whether `tokenId` exists.
1619      *
1620      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1621      *
1622      * Tokens start existing when they are minted (`_mint`),
1623      * and stop existing when they are burned (`_burn`).
1624      */
1625     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1626         return _owners[tokenId] != address(0);
1627     }
1628 
1629     /**
1630      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1631      *
1632      * Requirements:
1633      *
1634      * - `tokenId` must exist.
1635      */
1636     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1637         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1638         address owner = babynft.ownerOf(tokenId);
1639         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1640     }
1641 
1642     /**
1643      * @dev Safely mints `tokenId` and transfers it to `to`.
1644      *
1645      * Requirements:
1646      *
1647      * - `tokenId` must not exist.
1648      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1649      *
1650      * Emits a {Transfer} event.
1651      */
1652     function _safeMint(address to, uint256 tokenId) internal virtual {
1653         _safeMint(to, tokenId, "");
1654     }
1655 
1656     /**
1657      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1658      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1659      */
1660     function _safeMint(
1661         address to,
1662         uint256 tokenId,
1663         bytes memory _data
1664     ) internal virtual {
1665         _mint(to, tokenId);
1666         require(
1667             _checkOnERC721Received(address(0), to, tokenId, _data),
1668             "ERC721: transfer to non ERC721Receiver implementer"
1669         );
1670     }
1671 
1672     /**
1673      * @dev Mints `tokenId` and transfers it to `to`.
1674      *
1675      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1676      *
1677      * Requirements:
1678      *
1679      * - `tokenId` must not exist.
1680      * - `to` cannot be the zero address.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684    function _mint(address to, uint256 tokenId) internal virtual {
1685         require(to != address(0), "ERC721: mint to the zero address");
1686         require(!_exists(tokenId), "ERC721: token already minted");
1687 
1688         _beforeTokenTransfer(address(0), to, tokenId);
1689 
1690         _balances[to] += 1;
1691         _owners[tokenId] = to;
1692         idtostartingtimet[tokenId][to]=block.timestamp;
1693 
1694         // totalSupply+=1;
1695 
1696         emit Transfer(address(0), to, tokenId);
1697 
1698         _afterTokenTransfer(address(0), to, tokenId);
1699     }
1700 
1701     function seterc20address(address add)external {
1702         require(_counter<1, "already called this function");
1703          _erc20= erc20_(add);
1704          _counter++;
1705     }
1706 
1707       function walletofNFT(address _owner)
1708         public
1709         view
1710         returns (uint256[] memory)
1711     {
1712         uint256 ownerTokenCount = balanceOf(_owner);
1713         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1714         for (uint256 i; i < ownerTokenCount; i++) {
1715             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1716         }
1717         return tokenIds;
1718     }
1719 
1720 
1721     function checkrewardbal(address add)public view returns(uint){
1722 
1723         uint256 ownerTokenCount = balanceOf(add);
1724            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1725          tokenIds= walletofNFT(add);
1726          
1727           uint current;
1728           uint reward;
1729           uint rewardbal;
1730          for (uint i ;i<ownerTokenCount; i++){
1731              
1732              if (idtostartingtimet[tokenIds[i]][add]>0 ){
1733            current = block.timestamp - idtostartingtimet[tokenIds[i]][add];
1734              reward = ((5*10**18)*current)/86400;
1735             rewardbal+=reward;
1736           
1737            }
1738         }
1739 
1740         return rewardbal;
1741     }
1742 
1743     function claimreward(address add) public {
1744           require(balanceOf(add)>0, "not qualified for reward");
1745          uint256 ownerTokenCount = balanceOf(add);
1746            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1747          tokenIds= walletofNFT(add);
1748          
1749           uint current;
1750           uint reward;
1751           uint rewardbal;
1752          for (uint i ;i<ownerTokenCount; i++){
1753              
1754              if (idtostartingtimet[tokenIds[i]][add]>0 ){
1755            current = block.timestamp - idtostartingtimet[tokenIds[i]][add];
1756              reward = ((5*10**18)*current)/86400;
1757             rewardbal+=reward;
1758           idtostartingtimet[tokenIds[i]][add]=block.timestamp;
1759            }
1760         }
1761 
1762           _erc20.mint(add,rewardbal);
1763 
1764 
1765     }
1766 
1767     /**
1768      * @dev Destroys `tokenId`.
1769      * The approval is cleared when the token is burned.
1770      *
1771      * Requirements:
1772      *
1773      * - `tokenId` must exist.
1774      *
1775      * Emits a {Transfer} event.
1776      */
1777     function _burn(uint256 tokenId) internal virtual {
1778         address owner = babynft.ownerOf(tokenId);
1779 
1780         _beforeTokenTransfer(owner, address(0), tokenId);
1781 
1782         // Clear approvals
1783         _approve(address(0), tokenId);
1784 
1785         _balances[owner] -= 1;
1786         delete _owners[tokenId];
1787 
1788         emit Transfer(owner, address(0), tokenId);
1789 
1790         _afterTokenTransfer(owner, address(0), tokenId);
1791     }
1792 
1793     /**
1794      * @dev Transfers `tokenId` from `from` to `to`.
1795      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1796      *
1797      * Requirements:
1798      *
1799      * - `to` cannot be the zero address.
1800      * - `tokenId` token must be owned by `from`.
1801      *
1802      * Emits a {Transfer} event.
1803      */
1804        function _transfer(
1805         address from,
1806         address to,
1807         uint256 tokenId
1808     ) internal virtual {
1809         require(babynft.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1810         require(to != address(0), "ERC721: transfer to the zero address");
1811 
1812         _beforeTokenTransfer(from, to, tokenId);
1813 
1814         // Clear approvals from the previous owner
1815         _approve(address(0), tokenId);
1816 
1817         _balances[from] -= 1;
1818         _balances[to] += 1;
1819         _owners[tokenId] = to;
1820         idtostartingtimet[tokenId][to]=block.timestamp;
1821         idtostartingtimet[tokenId][from]=0;
1822         
1823 
1824         emit Transfer(from, to, tokenId);
1825 
1826         _afterTokenTransfer(from, to, tokenId);
1827     }
1828 
1829     /**
1830      * @dev Approve `to` to operate on `tokenId`
1831      *
1832      * Emits a {Approval} event.
1833      */
1834     function _approve(address to, uint256 tokenId) internal virtual {
1835         _tokenApprovals[tokenId] = to;
1836         emit Approval(babynft.ownerOf(tokenId), to, tokenId);
1837     }
1838 
1839     /**
1840      * @dev Approve `operator` to operate on all of `owner` tokens
1841      *
1842      * Emits a {ApprovalForAll} event.
1843      */
1844     function _setApprovalForAll(
1845         address owner,
1846         address operator,
1847         bool approved
1848     ) internal virtual {
1849         require(owner != operator, "ERC721: approve to caller");
1850         _operatorApprovals[owner][operator] = approved;
1851         emit ApprovalForAll(owner, operator, approved);
1852     }
1853 
1854     /**
1855      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1856      * The call is not executed if the target address is not a contract.
1857      *
1858      * @param from address representing the previous owner of the given token ID
1859      * @param to target address that will receive the tokens
1860      * @param tokenId uint256 ID of the token to be transferred
1861      * @param _data bytes optional data to send along with the call
1862      * @return bool whether the call correctly returned the expected magic value
1863      */
1864     function _checkOnERC721Received(
1865         address from,
1866         address to,
1867         uint256 tokenId,
1868         bytes memory _data
1869     ) private returns (bool) {
1870         if (to.isContract()) {
1871             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1872                 return retval == IERC721Receiver.onERC721Received.selector;
1873             } catch (bytes memory reason) {
1874                 if (reason.length == 0) {
1875                     revert("ERC721: transfer to non ERC721Receiver implementer");
1876                 } else {
1877                     assembly {
1878                         revert(add(32, reason), mload(reason))
1879                     }
1880                 }
1881             }
1882         } else {
1883             return true;
1884         }
1885     }
1886 
1887     /**
1888      * @dev Hook that is called before any token transfer. This includes minting
1889      * and burning.
1890      *
1891      * Calling conditions:
1892      *
1893      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1894      * transferred to `to`.
1895      * - When `from` is zero, `tokenId` will be minted for `to`.
1896      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1897      * - `from` and `to` are never both zero.
1898      *
1899      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1900      */
1901     // function _beforeTokenTransfer(
1902     //     address from,
1903     //     address to,
1904     //     uint256 tokenId
1905     // ) internal virtual {}
1906 
1907     /**
1908      * @dev Hook that is called after any transfer of tokens. This includes
1909      * minting and burning.
1910      *
1911      * Calling conditions:
1912      *
1913      * - when `from` and `to` are both non-zero.
1914      * - `from` and `to` are never both zero.
1915      *
1916      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1917      */
1918     function _afterTokenTransfer(
1919         address from,
1920         address to,
1921         uint256 tokenId
1922     ) internal virtual {}
1923 }
1924 // File: Contracts/ancientnft.sol
1925 
1926 
1927 pragma solidity ^0.8.0;
1928 
1929 
1930 
1931 
1932 
1933 
1934 
1935 
1936 
1937 
1938 
1939 
1940 /**
1941  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1942  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1943  * {ERC721Enumerable}.
1944  */
1945 interface erc20{
1946 
1947   function mint(address add, uint amount)external;
1948 
1949 }
1950 
1951 
1952 
1953 contract ancientnft is Context, ERC165, IERC721, IERC721Metadata ,Ownable,IERC721Enumerable{
1954     using Address for address;
1955     using Strings for uint256;
1956     using Counters for Counters.Counter;
1957 
1958     Counters.Counter private _tokenIds;
1959 
1960     uint counter;
1961     uint _counter;
1962     
1963     erc20 _erc20;
1964     
1965 
1966     string public baseURI_ = "ipfs://QmYDwia8r68Mp3EWhmNtfVJA6FxYn52UMDNvkSaSUwtufU/";
1967     string public baseExtension = ".json";
1968 
1969 
1970     // Token name
1971     string private _name;
1972 
1973     // Token symbol
1974     string private _symbol;
1975 
1976     
1977 
1978     // Mapping from token ID to owner address
1979     mapping(uint256 => address) private _owners;
1980 
1981     // Mapping owner address to token count
1982     mapping(address => uint256) private _balances;
1983 
1984     // Mapping from token ID to approved address
1985     mapping(uint256 => address) private _tokenApprovals;
1986 
1987     // Mapping from owner to operator approvals
1988     mapping(address => mapping(address => bool)) private _operatorApprovals;
1989 
1990     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1991 
1992     // Mapping from token ID to index of the owner tokens list
1993     mapping(uint256 => uint256) private _ownedTokensIndex;
1994 
1995     // Array with all token ids, used for enumeration
1996     uint256[] private _allTokens;
1997 
1998     // Mapping from token id to position in the allTokens array
1999     mapping(uint256 => uint256) private _allTokensIndex;
2000 
2001     mapping(uint => mapping(address => uint)) private idtostartingtimet;
2002 
2003     mapping (address =>bool) onlyapprovedcontractaddress;
2004 
2005 
2006     /**
2007      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2008      */
2009     constructor(string memory name_, string memory symbol_) {
2010         _name = name_;
2011         _symbol = symbol_;
2012     }
2013 
2014       /**
2015      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2016      */
2017     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2018         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2019         return _ownedTokens[owner][index];
2020     }
2021 
2022     /**
2023      * @dev See {IERC721Enumerable-totalSupply}.
2024      */
2025     function totalSupply() public view virtual override returns (uint256) {
2026         return _allTokens.length;
2027     }
2028 
2029     /**
2030      * @dev See {IERC721Enumerable-tokenByIndex}.
2031      */
2032     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2033         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
2034         return _allTokens[index];
2035     }
2036 
2037  
2038     function _beforeTokenTransfer(
2039         address from,
2040         address to,
2041         uint256 tokenId
2042     ) internal virtual  {
2043      
2044 
2045         if (from == address(0)) {
2046             _addTokenToAllTokensEnumeration(tokenId);
2047         } else if (from != to) {
2048             _removeTokenFromOwnerEnumeration(from, tokenId);
2049         }
2050         if (to == address(0)) {
2051             _removeTokenFromAllTokensEnumeration(tokenId);
2052         } else if (to != from) {
2053             _addTokenToOwnerEnumeration(to, tokenId);
2054         }
2055     }
2056 
2057    
2058     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2059         uint256 length = ancientnft.balanceOf(to);
2060         _ownedTokens[to][length] = tokenId;
2061         _ownedTokensIndex[tokenId] = length;
2062     }
2063 
2064    
2065     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2066         _allTokensIndex[tokenId] = _allTokens.length;
2067         _allTokens.push(tokenId);
2068     }
2069 
2070   
2071     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2072         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2073         // then delete the last slot (swap and pop).
2074 
2075         uint256 lastTokenIndex = ancientnft.balanceOf(from) - 1;
2076         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2077 
2078         // When the token to delete is the last token, the swap operation is unnecessary
2079         if (tokenIndex != lastTokenIndex) {
2080             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2081 
2082             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2083             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2084         }
2085 
2086         // This also deletes the contents at the last position of the array
2087         delete _ownedTokensIndex[tokenId];
2088         delete _ownedTokens[from][lastTokenIndex];
2089     }
2090 
2091    
2092     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2093         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2094         // then delete the last slot (swap and pop).
2095 
2096         uint256 lastTokenIndex = _allTokens.length - 1;
2097         uint256 tokenIndex = _allTokensIndex[tokenId];
2098 
2099         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2100         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2101         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2102         uint256 lastTokenId = _allTokens[lastTokenIndex];
2103 
2104         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2105         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2106 
2107         // This also deletes the contents at the last position of the array
2108         delete _allTokensIndex[tokenId];
2109         _allTokens.pop();
2110     }
2111 
2112     /**
2113      * @dev See {IERC165-supportsInterface}.
2114      */
2115     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2116         return
2117             interfaceId == type(IERC721).interfaceId ||
2118             interfaceId == type(IERC721Metadata).interfaceId ||
2119             super.supportsInterface(interfaceId);
2120     }
2121 
2122     /**
2123      * @dev See {IERC721-balanceOf}.
2124      */
2125     function balanceOf(address owner) public view virtual override returns (uint256) {
2126         require(owner != address(0), "ERC721: balance query for the zero address");
2127         return _balances[owner];
2128     }
2129 
2130     /**
2131      * @dev See {IERC721-ownerOf}.
2132      */
2133     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2134         address owner = _owners[tokenId];
2135         require(owner != address(0), "ERC721: owner query for nonexistent token");
2136         return owner;
2137     }
2138 
2139     /**
2140      * @dev See {IERC721Metadata-name}.
2141      */
2142     function name() public view virtual override returns (string memory) {
2143         return _name;
2144     }
2145 
2146     /**
2147      * @dev See {IERC721Metadata-symbol}.
2148      */
2149     function symbol() public view virtual override returns (string memory) {
2150         return _symbol;
2151     }
2152 
2153     /**
2154      * @dev See {IERC721Metadata-tokenURI}.
2155      */
2156     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2157         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2158 
2159         string memory baseURI = _baseURI();
2160         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2161     }
2162 
2163     /**
2164      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2165      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2166      * by default, can be overriden in child contracts.
2167      */
2168     function _baseURI() internal view virtual returns (string memory) {
2169         return baseURI_;
2170     }
2171 
2172     function setapprovedcontractaddress(address add)external {
2173         require(counter<1, "already called");
2174         onlyapprovedcontractaddress[add] =true;
2175         counter+=1;
2176     }
2177 
2178     function mint(address _to) public  {
2179     require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint"); 
2180         if (_tokenIds.current()==0){
2181             _tokenIds.increment();
2182         }
2183         
2184         
2185         uint256 newTokenID = _tokenIds.current();
2186         _safeMint(_to, newTokenID);
2187         _tokenIds.increment();
2188         
2189     }
2190 
2191 
2192 
2193     function approve(address to, uint256 tokenId) public virtual override {
2194         address owner = ancientnft.ownerOf(tokenId);
2195         require(to != owner, "ERC721: approval to current owner");
2196 
2197         require(
2198             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2199             "ERC721: approve caller is not owner nor approved for all"
2200         );
2201 
2202         _approve(to, tokenId);
2203     }
2204 
2205     /**
2206      * @dev See {IERC721-getApproved}.
2207      */
2208      
2209      function setBaseURI(string memory _newBaseURI) public onlyOwner {
2210         baseURI_ = _newBaseURI;
2211     }
2212 
2213 
2214     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2215         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2216 
2217         return _tokenApprovals[tokenId];
2218     }
2219 
2220     /**
2221      * @dev See {IERC721-setApprovalForAll}.
2222      */
2223     function setApprovalForAll(address operator, bool approved) public virtual override {
2224         _setApprovalForAll(_msgSender(), operator, approved);
2225     }
2226 
2227     /**
2228      * @dev See {IERC721-isApprovedForAll}.
2229      */
2230     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2231         return _operatorApprovals[owner][operator];
2232     }
2233 
2234     /**
2235      * @dev See {IERC721-transferFrom}.
2236      */
2237     function transferFrom(
2238         address from,
2239         address to,
2240         uint256 tokenId
2241     ) public virtual override {
2242         //solhint-disable-next-line max-line-length
2243         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2244 
2245         _transfer(from, to, tokenId);
2246     }
2247 
2248     /**
2249      * @dev See {IERC721-safeTransferFrom}.
2250      */
2251     function safeTransferFrom(
2252         address from,
2253         address to,
2254         uint256 tokenId
2255     ) public virtual override {
2256         safeTransferFrom(from, to, tokenId, "");
2257     }
2258 
2259     /**
2260      * @dev See {IERC721-safeTransferFrom}.
2261      */
2262     function safeTransferFrom(
2263         address from,
2264         address to,
2265         uint256 tokenId,
2266         bytes memory _data
2267     ) public virtual override {
2268         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2269         _safeTransfer(from, to, tokenId, _data);
2270     }
2271 
2272     /**
2273      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2274      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2275      *
2276      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2277      *
2278      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2279      * implement alternative mechanisms to perform token transfer, such as signature-based.
2280      *
2281      * Requirements:
2282      *
2283      * - `from` cannot be the zero address.
2284      * - `to` cannot be the zero address.
2285      * - `tokenId` token must exist and be owned by `from`.
2286      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2287      *
2288      * Emits a {Transfer} event.
2289      */
2290     function _safeTransfer(
2291         address from,
2292         address to,
2293         uint256 tokenId,
2294         bytes memory _data
2295     ) internal virtual {
2296         _transfer(from, to, tokenId);
2297         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2298     }
2299 
2300     /**
2301      * @dev Returns whether `tokenId` exists.
2302      *
2303      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2304      *
2305      * Tokens start existing when they are minted (`_mint`),
2306      * and stop existing when they are burned (`_burn`).
2307      */
2308     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2309         return _owners[tokenId] != address(0);
2310     }
2311 
2312     /**
2313      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2314      *
2315      * Requirements:
2316      *
2317      * - `tokenId` must exist.
2318      */
2319     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2320         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2321         address owner = ancientnft.ownerOf(tokenId);
2322         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2323     }
2324 
2325     /**
2326      * @dev Safely mints `tokenId` and transfers it to `to`.
2327      *
2328      * Requirements:
2329      *
2330      * - `tokenId` must not exist.
2331      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2332      *
2333      * Emits a {Transfer} event.
2334      */
2335     function _safeMint(address to, uint256 tokenId) internal virtual {
2336         _safeMint(to, tokenId, "");
2337     }
2338 
2339     /**
2340      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2341      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2342      */
2343     function _safeMint(
2344         address to,
2345         uint256 tokenId,
2346         bytes memory _data
2347     ) internal virtual {
2348         _mint(to, tokenId);
2349         require(
2350             _checkOnERC721Received(address(0), to, tokenId, _data),
2351             "ERC721: transfer to non ERC721Receiver implementer"
2352         );
2353     }
2354 
2355     /**
2356      * @dev Mints `tokenId` and transfers it to `to`.
2357      *
2358      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2359      *
2360      * Requirements:
2361      *
2362      * - `tokenId` must not exist.
2363      * - `to` cannot be the zero address.
2364      *
2365      * Emits a {Transfer} event.
2366      */
2367    function _mint(address to, uint256 tokenId) internal virtual {
2368         require(to != address(0), "ERC721: mint to the zero address");
2369         require(!_exists(tokenId), "ERC721: token already minted");
2370 
2371         _beforeTokenTransfer(address(0), to, tokenId);
2372 
2373         _balances[to] += 1;
2374         _owners[tokenId] = to;
2375         idtostartingtimet[tokenId][to]=block.timestamp;
2376 
2377         // totalSupply+=1;
2378 
2379         emit Transfer(address(0), to, tokenId);
2380 
2381         _afterTokenTransfer(address(0), to, tokenId);
2382     }
2383 
2384     function seterc20address(address add)external {
2385         require(_counter<1, "already called this function");
2386          _erc20= erc20(add);
2387          _counter++;
2388     }
2389 
2390       function walletofNFT(address _owner)
2391         public
2392         view
2393         returns (uint256[] memory)
2394     {
2395         uint256 ownerTokenCount = balanceOf(_owner);
2396         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2397         for (uint256 i; i < ownerTokenCount; i++) {
2398             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2399         }
2400         return tokenIds;
2401     }
2402 
2403 
2404     function checkrewardbal(address add)public view returns(uint){
2405 
2406         uint256 ownerTokenCount = balanceOf(add);
2407            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2408          tokenIds= walletofNFT(add);
2409          
2410           uint current;
2411           uint reward;
2412           uint rewardbal;
2413          for (uint i ;i<ownerTokenCount; i++){
2414              
2415              if (idtostartingtimet[tokenIds[i]][add]>0 ){
2416            current = block.timestamp - idtostartingtimet[tokenIds[i]][add];
2417              reward = ((50*10**18)*current)/86400;
2418             rewardbal+=reward;
2419           
2420            }
2421         }
2422 
2423         return rewardbal;
2424     }
2425 
2426     function claimreward(address add) public {
2427           require(balanceOf(add)>0, "not qualified for reward");
2428          uint256 ownerTokenCount = balanceOf(add);
2429            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2430          tokenIds= walletofNFT(add);
2431          
2432           uint current;
2433           uint reward;
2434           uint rewardbal;
2435          for (uint i ;i<ownerTokenCount; i++){
2436              
2437              if (idtostartingtimet[tokenIds[i]][add]>0 ){
2438            current = block.timestamp - idtostartingtimet[tokenIds[i]][add];
2439              reward = ((50*10**18)*current)/86400;
2440             rewardbal+=reward;
2441           idtostartingtimet[tokenIds[i]][add]=block.timestamp;
2442            }
2443         }
2444 
2445           _erc20.mint(add,rewardbal);
2446 
2447 
2448     }
2449 
2450     /**
2451      * @dev Destroys `tokenId`.
2452      * The approval is cleared when the token is burned.
2453      *
2454      * Requirements:
2455      *
2456      * - `tokenId` must exist.
2457      *
2458      * Emits a {Transfer} event.
2459      */
2460     function _burn(uint256 tokenId) internal virtual {
2461         address owner = ancientnft.ownerOf(tokenId);
2462 
2463         _beforeTokenTransfer(owner, address(0), tokenId);
2464 
2465         // Clear approvals
2466         _approve(address(0), tokenId);
2467 
2468         _balances[owner] -= 1;
2469         delete _owners[tokenId];
2470 
2471         emit Transfer(owner, address(0), tokenId);
2472 
2473         _afterTokenTransfer(owner, address(0), tokenId);
2474     }
2475 
2476     /**
2477      * @dev Transfers `tokenId` from `from` to `to`.
2478      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2479      *
2480      * Requirements:
2481      *
2482      * - `to` cannot be the zero address.
2483      * - `tokenId` token must be owned by `from`.
2484      *
2485      * Emits a {Transfer} event.
2486      */
2487        function _transfer(
2488         address from,
2489         address to,
2490         uint256 tokenId
2491     ) internal virtual {
2492         require(ancientnft.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2493         require(to != address(0), "ERC721: transfer to the zero address");
2494 
2495         _beforeTokenTransfer(from, to, tokenId);
2496 
2497         // Clear approvals from the previous owner
2498         _approve(address(0), tokenId);
2499 
2500         _balances[from] -= 1;
2501         _balances[to] += 1;
2502         _owners[tokenId] = to;
2503         idtostartingtimet[tokenId][to]=block.timestamp;
2504         idtostartingtimet[tokenId][from]=0;
2505         
2506 
2507         emit Transfer(from, to, tokenId);
2508 
2509         _afterTokenTransfer(from, to, tokenId);
2510     }
2511 
2512     /**
2513      * @dev Approve `to` to operate on `tokenId`
2514      *
2515      * Emits a {Approval} event.
2516      */
2517     function _approve(address to, uint256 tokenId) internal virtual {
2518         _tokenApprovals[tokenId] = to;
2519         emit Approval(ancientnft.ownerOf(tokenId), to, tokenId);
2520     }
2521 
2522     /**
2523      * @dev Approve `operator` to operate on all of `owner` tokens
2524      *
2525      * Emits a {ApprovalForAll} event.
2526      */
2527     function _setApprovalForAll(
2528         address owner,
2529         address operator,
2530         bool approved
2531     ) internal virtual {
2532         require(owner != operator, "ERC721: approve to caller");
2533         _operatorApprovals[owner][operator] = approved;
2534         emit ApprovalForAll(owner, operator, approved);
2535     }
2536 
2537     /**
2538      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2539      * The call is not executed if the target address is not a contract.
2540      *
2541      * @param from address representing the previous owner of the given token ID
2542      * @param to target address that will receive the tokens
2543      * @param tokenId uint256 ID of the token to be transferred
2544      * @param _data bytes optional data to send along with the call
2545      * @return bool whether the call correctly returned the expected magic value
2546      */
2547     function _checkOnERC721Received(
2548         address from,
2549         address to,
2550         uint256 tokenId,
2551         bytes memory _data
2552     ) private returns (bool) {
2553         if (to.isContract()) {
2554             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2555                 return retval == IERC721Receiver.onERC721Received.selector;
2556             } catch (bytes memory reason) {
2557                 if (reason.length == 0) {
2558                     revert("ERC721: transfer to non ERC721Receiver implementer");
2559                 } else {
2560                     assembly {
2561                         revert(add(32, reason), mload(reason))
2562                     }
2563                 }
2564             }
2565         } else {
2566             return true;
2567         }
2568     }
2569 
2570     /**
2571      * @dev Hook that is called before any token transfer. This includes minting
2572      * and burning.
2573      *
2574      * Calling conditions:
2575      *
2576      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2577      * transferred to `to`.
2578      * - When `from` is zero, `tokenId` will be minted for `to`.
2579      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2580      * - `from` and `to` are never both zero.
2581      *
2582      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2583      */
2584     // function _beforeTokenTransfer(
2585     //     address from,
2586     //     address to,
2587     //     uint256 tokenId
2588     // ) internal virtual {}
2589 
2590     /**
2591      * @dev Hook that is called after any transfer of tokens. This includes
2592      * minting and burning.
2593      *
2594      * Calling conditions:
2595      *
2596      * - when `from` and `to` are both non-zero.
2597      * - `from` and `to` are never both zero.
2598      *
2599      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2600      */
2601     function _afterTokenTransfer(
2602         address from,
2603         address to,
2604         uint256 tokenId
2605     ) internal virtual {}
2606 }
2607 // File: Contracts/nft.sol
2608 
2609 
2610 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
2611 
2612 pragma solidity ^0.8.0;
2613 
2614 
2615 
2616 
2617 
2618 
2619 
2620 
2621 
2622 
2623 
2624 
2625 
2626 
2627 
2628 
2629 
2630 
2631 contract ERC721  is Context, ERC165, IERC721, IERC721Metadata, Ownable, IERC721Enumerable {
2632     using Address for address;
2633     using Strings for uint256;
2634     using Counters for Counters.Counter;
2635 
2636     
2637    
2638 
2639     // Token name
2640     string private _name;
2641 
2642     // Token symbol
2643     string private _symbol;
2644 
2645     // uint public totalSupply;
2646 
2647     Counters.Counter private _tokenIds;
2648     
2649     
2650 
2651     string public baseURI_ = "ipfs://QmeWdrqHA32zQRjU9oKmsi6NDGdv1dpnyxRi3pcm27Dkqb/";
2652     string public baseExtension = ".json";
2653     uint256 public cost = 0.03 ether;
2654     uint256 public maxSupply = 3333;
2655     uint256 public maxMintAmount = 10;
2656     bool public paused = false;
2657    
2658      
2659 
2660      // wallet addresses for claims
2661     address private constant possumchsr69 = 0x31FbcD30AA07FBbeA5DB938cD534D1dA79E34985;
2662     address private constant Jazzasaurus =
2663         0xd848353706E5a26BAa6DD20265EDDe1e7047d9ba;
2664     address private constant munheezy = 0xB6D2ac64BDc24f76417b95b410ACf47cE31AdD07;
2665     address private constant _community =
2666         0xe44CB360e48dA69fe75a78fD1649ccbd3CCf7AD1;
2667     
2668     mapping(uint => mapping(address => uint)) private idtostartingtimet;
2669 
2670         
2671     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2672 
2673     // Mapping from token ID to index of the owner tokens list
2674     mapping(uint256 => uint256) private _ownedTokensIndex;
2675 
2676     // Array with all token ids, used for enumeration
2677     uint256[] private _allTokens;
2678 
2679     // Mapping from token id to position in the allTokens array
2680     mapping(uint256 => uint256) private _allTokensIndex;
2681 
2682      mapping(address => mapping(uint256 => bool)) private _breeded;
2683 
2684      ERC20 _ERC20;
2685      ancientnft _ancientnft;  
2686      babynft _babynft; 
2687 
2688    
2689 
2690 
2691 
2692 
2693     // Mapping from token ID to owner address
2694     mapping(uint256 => address) private _owners;
2695 
2696     // Mapping owner address to token count
2697     mapping(address => uint256) private _balances;
2698 
2699     // Mapping from token ID to approved address
2700     mapping(uint256 => address) private _tokenApprovals;
2701 
2702     // Mapping from owner to operator approvals
2703     mapping(address => mapping(address => bool)) private _operatorApprovals;
2704 
2705 
2706    
2707     constructor(string memory name_, string memory symbol_,string memory ERC20name_, string memory ERC20symbol_ ,uint ERC20amount,address ERC20owneraddress,string memory ancientnftname_, string memory ancientnftsymbol_,string memory babynftname_, string memory babynftsymbol_) {
2708         _name = name_;
2709         _symbol = symbol_;
2710         mint(msg.sender, 10);
2711         _ERC20= new ERC20(ERC20name_,ERC20symbol_,ERC20amount,ERC20owneraddress) ;
2712         
2713         _ancientnft = new ancientnft(ancientnftname_,ancientnftsymbol_);
2714         _ancientnft.setapprovedcontractaddress(address(this));
2715         _ancientnft.seterc20address(address(_ERC20));
2716         _babynft= new  babynft(babynftname_,babynftsymbol_);
2717         _babynft.setapprovedcontractaddress(address(this));
2718         _babynft.seterc20address(address(_ERC20)); 
2719         _ERC20.setapprovedcontractaddress(address(this),address(_ancientnft),address(_babynft));
2720 
2721     }
2722 
2723    
2724     /**
2725      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2726      */
2727     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2728         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2729         return _ownedTokens[owner][index];
2730     }
2731 
2732     /**
2733      * @dev See {IERC721Enumerable-totalSupply}.
2734      */
2735     function totalSupply() public view virtual override returns (uint256) {
2736         return _allTokens.length;
2737     }
2738 
2739     /**
2740      * @dev See {IERC721Enumerable-tokenByIndex}.
2741      */
2742     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2743         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
2744         return _allTokens[index];
2745     }
2746 
2747     function pause() public onlyOwner  {
2748         paused = !paused;
2749 
2750      }
2751 
2752     function checkPause() public view onlyOwner returns(bool) {
2753         return paused; 
2754     }
2755  
2756     function _beforeTokenTransfer(
2757         address from,
2758         address to,
2759         uint256 tokenId
2760     ) internal virtual  {
2761      
2762 
2763         if (from == address(0)) {
2764             _addTokenToAllTokensEnumeration(tokenId);
2765         } else if (from != to) {
2766             _removeTokenFromOwnerEnumeration(from, tokenId);
2767         }
2768         if (to == address(0)) {
2769             _removeTokenFromAllTokensEnumeration(tokenId);
2770         } else if (to != from) {
2771             _addTokenToOwnerEnumeration(to, tokenId);
2772         }
2773     }
2774 
2775    
2776     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2777         uint256 length = ERC721.balanceOf(to);
2778         _ownedTokens[to][length] = tokenId;
2779         _ownedTokensIndex[tokenId] = length;
2780     }
2781 
2782    
2783     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2784         _allTokensIndex[tokenId] = _allTokens.length;
2785         _allTokens.push(tokenId);
2786     }
2787 
2788   
2789     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2790         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2791         // then delete the last slot (swap and pop).
2792 
2793         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2794         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2795 
2796         // When the token to delete is the last token, the swap operation is unnecessary
2797         if (tokenIndex != lastTokenIndex) {
2798             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2799 
2800             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2801             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2802         }
2803 
2804         // This also deletes the contents at the last position of the array
2805         delete _ownedTokensIndex[tokenId];
2806         delete _ownedTokens[from][lastTokenIndex];
2807     }
2808 
2809    
2810     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2811         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2812         // then delete the last slot (swap and pop).
2813 
2814         uint256 lastTokenIndex = _allTokens.length - 1;
2815         uint256 tokenIndex = _allTokensIndex[tokenId];
2816 
2817         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2818         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2819         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2820         uint256 lastTokenId = _allTokens[lastTokenIndex];
2821 
2822         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2823         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2824 
2825         // This also deletes the contents at the last position of the array
2826         delete _allTokensIndex[tokenId];
2827         _allTokens.pop();
2828     }
2829 
2830   
2831     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2832         return
2833             interfaceId == type(IERC721).interfaceId ||
2834             interfaceId == type(IERC721Metadata).interfaceId ||
2835             super.supportsInterface(interfaceId);
2836     }
2837 
2838   
2839     function balanceOf(address owner) public view virtual override returns (uint256) {
2840         require(owner != address(0), "ERC721: balance query for the zero address");
2841         return _balances[owner];
2842     }
2843 
2844 
2845     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2846         address owner = _owners[tokenId];
2847         require(owner != address(0), "ERC721: owner query for nonexistent token");
2848         return owner;
2849     }
2850 
2851    
2852     function name() public view virtual override returns (string memory) {
2853         return _name;
2854     }
2855 
2856    
2857     function symbol() public view virtual override returns (string memory) {
2858         return _symbol;
2859     }
2860 
2861     /**
2862      * @dev See {IERC721Metadata-tokenURI}.
2863      */
2864     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2865         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2866 
2867         string memory baseURI = _baseURI();
2868         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2869     }
2870 
2871   
2872     function _baseURI() internal view virtual returns (string memory) {
2873         return baseURI_;
2874     }
2875 
2876    
2877     function approve(address to, uint256 tokenId) public virtual override {
2878         address owner = ERC721.ownerOf(tokenId);
2879         require(to != owner, "ERC721: approval to current owner");
2880 
2881         require(
2882             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2883             "ERC721: approve caller is not owner nor approved for all"
2884         );
2885 
2886         _approve(to, tokenId);
2887     }
2888 
2889    
2890     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2891         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2892 
2893         return _tokenApprovals[tokenId];
2894     }
2895 
2896   
2897     function setApprovalForAll(address operator, bool approved) public virtual override {
2898         _setApprovalForAll(_msgSender(), operator, approved);
2899     }
2900 
2901 
2902     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2903         return _operatorApprovals[owner][operator];
2904     }
2905 
2906   
2907     function transferFrom(
2908         address from,
2909         address to,
2910         uint256 tokenId
2911     ) public virtual override {
2912         //solhint-disable-next-line max-line-length
2913         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2914 
2915         _transfer(from, to, tokenId);
2916     }
2917 
2918    
2919     function safeTransferFrom(
2920         address from,
2921         address to,
2922         uint256 tokenId
2923     ) public virtual override {
2924         safeTransferFrom(from, to, tokenId, "");
2925     }
2926 
2927     function safeTransferFrom(
2928         address from,
2929         address to,
2930         uint256 tokenId,
2931         bytes memory _data
2932     ) public virtual override {
2933         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2934         _safeTransfer(from, to, tokenId, _data);
2935     }
2936 
2937    
2938     function _safeTransfer(
2939         address from,
2940         address to,
2941         uint256 tokenId,
2942         bytes memory _data
2943     ) internal virtual {
2944         _transfer(from, to, tokenId);
2945         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2946     }
2947 
2948     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2949         return _owners[tokenId] != address(0);
2950     }
2951 
2952 
2953     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2954         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2955         address owner = ERC721.ownerOf(tokenId);
2956         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2957     }
2958 
2959    
2960     function _safeMint(address to, uint256 tokenId) internal virtual {
2961         _safeMint(to, tokenId, "");
2962     }
2963 
2964     
2965     function _safeMint(
2966         address to,
2967         uint256 tokenId,
2968         bytes memory _data
2969     ) internal virtual {
2970         _mint(to, tokenId);
2971         require(
2972             _checkOnERC721Received(address(0), to, tokenId, _data),
2973             "ERC721: transfer to non ERC721Receiver implementer"
2974         );
2975     }
2976 
2977 
2978     function _mint(address to, uint256 tokenId) internal virtual {
2979         require(to != address(0), "ERC721: mint to the zero address");
2980         require(!_exists(tokenId), "ERC721: token already minted");
2981 
2982         _beforeTokenTransfer(address(0), to, tokenId);
2983 
2984         _balances[to] += 1;
2985         _owners[tokenId] = to;
2986         idtostartingtimet[tokenId][to]=block.timestamp;
2987 
2988         // totalSupply+=1;
2989 
2990         emit Transfer(address(0), to, tokenId);
2991 
2992         _afterTokenTransfer(address(0), to, tokenId);
2993     }
2994 
2995   
2996 
2997     function _burn(uint256 tokenId) internal virtual {
2998         address owner = ERC721.ownerOf(tokenId);
2999 
3000         _beforeTokenTransfer(owner, address(0), tokenId);
3001 
3002         // Clear approvals
3003         _approve(address(0), tokenId);
3004 
3005         _balances[owner] -= 1;
3006         delete _owners[tokenId];
3007         
3008 
3009         // totalSupply-=1;
3010 
3011         emit Transfer(owner, address(0), tokenId);
3012 
3013         _afterTokenTransfer(owner, address(0), tokenId);
3014     }
3015      
3016      function mint(
3017         address _to,
3018         uint256 _mintAmount
3019         
3020     ) public payable {
3021         // get total NFT token supply
3022       
3023         require(_mintAmount > 0);
3024         require(_mintAmount <= maxMintAmount);
3025         require( totalSupply() + _mintAmount <= maxSupply);
3026         require(paused == false);
3027         
3028             // minting is free for first 200 request after which payment is required
3029         if ( totalSupply() >= 200) {
3030                 require(msg.value >= cost * _mintAmount);
3031             }
3032         
3033 
3034     
3035 
3036         // execute mint
3037        if (_tokenIds.current()==0){
3038             _tokenIds.increment();
3039        }
3040         
3041         for (uint256 i = 1; i <= _mintAmount; i++) {
3042             uint256 newTokenID = _tokenIds.current();
3043             _safeMint(_to, newTokenID);
3044             _tokenIds.increment();
3045         }
3046     }
3047 
3048     function checkdragonnotbreeded(address add)public view returns(uint[] memory){
3049 
3050         uint256 ownerTokenCount = balanceOf(add);
3051            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3052          tokenIds= walletofNFT(add);  
3053          
3054          
3055           uint count;
3056          for (uint i ;i<ownerTokenCount; i++){
3057              if (_breeded[address(this)][tokenIds[i]]==false){
3058                 count++;   
3059              }
3060             
3061           
3062            }
3063           uint256[] memory notbreededbrtokenIds = new uint256[](count);
3064           uint _count;
3065             for (uint i ;i<ownerTokenCount; i++){
3066              if (_breeded[address(this)][tokenIds[i]]==false){
3067                    notbreededbrtokenIds[_count]=tokenIds[i];
3068                    _count++;
3069              }
3070             
3071           
3072            }
3073 
3074            return notbreededbrtokenIds;
3075         }
3076     
3077     
3078 
3079    
3080     function breed(uint id1,uint id2) public  {
3081         uint amount=1800*10**18;
3082         require(balanceOf(msg.sender)>=2, "Must Own 2 0xDragons");
3083         require (_ERC20.balanceOf(msg.sender) >= amount,"You Dont Have The $SCALE For That!");
3084         require (ownerOf(id1)==msg.sender,"NOT YOUR DRAGON");
3085         require (ownerOf(id2)==msg.sender,"NOT YOUR DRAGON");
3086         _ERC20.burn(msg.sender, amount);
3087 
3088        
3089          _breeded[address(this)][id1]=true;
3090            _breeded[address(this)][id2]=true;
3091             
3092 
3093         _babynft.mint(msg.sender);  
3094     }
3095 
3096     
3097     function burn(uint id1, uint id2, uint id3 ) public  {
3098     uint amount=1500*10**18;
3099     require(balanceOf(msg.sender)>=3, "Must Have 3 UNBRED Dragons");
3100     require (_ERC20.balanceOf(msg.sender) >= amount,"You Dont Have The $SCALE For That!");
3101     require (ownerOf(id1)==msg.sender,"NOT YOUR DRAGON");
3102     require (ownerOf(id2)==msg.sender,"NOT YOUR DRAGON");
3103     require (ownerOf(id3)==msg.sender,"NOT YOUR DRAGON"); 
3104     require( _breeded[address(this)][id1]==false ,"Bred Dragons CAN'T Be Sacrificed");
3105     require( _breeded[address(this)][id2]==false ,"Bred Dragons CAN'T Be Sacrificed"); 
3106     require( _breeded[address(this)][id3]==false ,"Bred Dragons CAN'T Be Sacrificed");
3107     _ERC20.burn(msg.sender, amount);
3108 
3109   _transfer(
3110       msg.sender,
3111       0x000000000000000000000000000000000000dEaD,
3112       id1
3113 );
3114 _transfer(
3115       msg.sender,
3116       0x000000000000000000000000000000000000dEaD,
3117       id2
3118 );
3119 _transfer(
3120       msg.sender,
3121       0x000000000000000000000000000000000000dEaD,
3122       id3
3123 );   
3124          
3125       _ancientnft.mint(msg.sender);   
3126         
3127         
3128      }
3129 
3130 
3131 
3132 
3133    function setmaxsupplyforbabynft(uint amount)public onlyOwner{
3134         _babynft.setmaxsupply(amount);
3135 
3136    }
3137 
3138    function setbaseuriforbabynft(string memory _newBaseURI) public onlyOwner{
3139        _babynft.setBaseURI(_newBaseURI);
3140    }
3141 
3142    
3143    function setbaseuriforancientnft(string memory _newBaseURI) public onlyOwner{
3144        _ancientnft.setBaseURI(_newBaseURI);
3145    }
3146 
3147 
3148     function setCost(uint256 _newCost) public onlyOwner {
3149         cost = _newCost;
3150     }
3151 
3152     // set or update max number of mint per mint call
3153     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
3154         maxMintAmount = _newmaxMintAmount;
3155     }
3156 
3157    
3158 
3159     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3160         baseURI_ = _newBaseURI;
3161     }
3162 
3163     // set metadata base extention
3164     function setBaseExtension(string memory _newBaseExtension)public onlyOwner    {
3165         baseExtension = _newBaseExtension;    }
3166 
3167 
3168     
3169 
3170     function claim() public onlyOwner {
3171         // get contract total balance
3172         uint256 balance = address(this).balance;
3173         // begin withdraw based on address percentage
3174 
3175         // 40%
3176         payable(Jazzasaurus).transfer((balance / 100) * 40);
3177         // 20%
3178         payable(possumchsr69).transfer((balance / 100) * 20);
3179         // 25%
3180         payable(munheezy).transfer((balance / 100) * 25);
3181         // 15%
3182         payable(_community).transfer((balance / 100) * 15);
3183     }
3184 
3185       function walletofNFT(address _owner)
3186         public
3187         view
3188         returns (uint256[] memory)
3189     {
3190         uint256 ownerTokenCount = balanceOf(_owner);
3191         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3192         for (uint256 i; i < ownerTokenCount; i++) {
3193             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
3194         }
3195         return tokenIds;
3196     }
3197 
3198     function checkrewardbal()public view returns(uint){
3199 
3200         uint256 ownerTokenCount = balanceOf(msg.sender);
3201            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3202          tokenIds= walletofNFT(msg.sender);
3203          
3204           uint current;
3205           uint reward;
3206           uint rewardbal;
3207          for (uint i ;i<ownerTokenCount; i++){
3208              
3209              if (idtostartingtimet[tokenIds[i]][msg.sender]>0 ){
3210            current = block.timestamp - idtostartingtimet[tokenIds[i]][msg.sender];
3211              reward = ((10*10**18)*current)/86400;
3212             rewardbal+=reward;
3213           
3214            }
3215         }
3216 
3217         return rewardbal;
3218     }
3219 
3220     function checkrewardforancientbal()public view returns(uint){
3221       return _ancientnft.checkrewardbal(msg.sender);
3222     }
3223 
3224     function checkrewardforbabybal()public view returns(uint){
3225       return _babynft.checkrewardbal(msg.sender);
3226     }
3227 
3228     function claimreward() public {
3229           require(balanceOf(msg.sender)>0, "Not Qualified For Reward");
3230          uint256 ownerTokenCount = balanceOf(msg.sender);
3231            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3232          tokenIds= walletofNFT(msg.sender);
3233          
3234           uint current;
3235           uint reward;
3236           uint rewardbal;
3237          for (uint i ;i<ownerTokenCount; i++){
3238              
3239              if (idtostartingtimet[tokenIds[i]][msg.sender]>0 ){
3240            current = block.timestamp - idtostartingtimet[tokenIds[i]][msg.sender];
3241              reward = ((10*10**18)*current)/86400;
3242             rewardbal+=reward;
3243           idtostartingtimet[tokenIds[i]][msg.sender]=block.timestamp;
3244            }
3245         }
3246 
3247          _ERC20.mint(msg.sender,rewardbal);
3248      if (_ancientnft.balanceOf(msg.sender)>0){
3249         _ancientnft.claimreward(msg.sender);
3250 
3251         }
3252     if (_babynft.balanceOf(msg.sender)>0){
3253         _babynft.claimreward(msg.sender);
3254         }
3255 
3256 
3257     }
3258 
3259 
3260      function checkerc20address()public view returns(address) {
3261 
3262      return  (address(_ERC20)); //  this is the deployed address of erc20token
3263      
3264  }
3265 
3266     
3267      function checkancientnftaddress()public view returns(address) {
3268 
3269      return  (address(_ancientnft)); //  this is the deployed address of ancienttoken
3270      
3271     }
3272 
3273     
3274      function checkbabynftaddress()public view returns(address) {
3275 
3276      return  (address(_babynft)); //  this is the deployed address of babytoken
3277      
3278  }
3279 
3280 
3281 
3282 
3283 
3284     function _transfer(
3285         address from,
3286         address to,
3287         uint256 tokenId
3288     ) internal virtual {
3289         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3290         require(to != address(0), "ERC721: transfer to the zero address");
3291 
3292         _beforeTokenTransfer(from, to, tokenId);
3293 
3294         // Clear approvals from the previous owner
3295         _approve(address(0), tokenId);
3296 
3297         _balances[from] -= 1;
3298         _balances[to] += 1;
3299         _owners[tokenId] = to;
3300         idtostartingtimet[tokenId][to]=block.timestamp;
3301         idtostartingtimet[tokenId][from]=0;
3302         
3303 
3304         emit Transfer(from, to, tokenId);
3305 
3306         _afterTokenTransfer(from, to, tokenId);
3307     }
3308 
3309    
3310     function _approve(address to, uint256 tokenId) internal virtual {
3311         _tokenApprovals[tokenId] = to;
3312         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3313     }
3314 
3315   
3316     function _setApprovalForAll(
3317         address owner,
3318         address operator,
3319         bool approved
3320     ) internal virtual {
3321         require(owner != operator, "ERC721: approve to caller");
3322         _operatorApprovals[owner][operator] = approved;
3323         emit ApprovalForAll(owner, operator, approved);
3324     }
3325 
3326     function _checkOnERC721Received(
3327         address from,
3328         address to,
3329         uint256 tokenId,
3330         bytes memory _data
3331     ) private returns (bool) {
3332         if (to.isContract()) {
3333             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
3334                 return retval == IERC721Receiver.onERC721Received.selector;
3335             } catch (bytes memory reason) {
3336                 if (reason.length == 0) {
3337                     revert("ERC721: transfer to non ERC721Receiver implementer");
3338                 } else {
3339                     assembly {
3340                         revert(add(32, reason), mload(reason))
3341                     }
3342                 }
3343             }
3344         } else {
3345             return true;
3346         }
3347     }
3348 
3349 
3350   
3351     function _afterTokenTransfer(
3352         address from,
3353         address to,
3354         uint256 tokenId
3355     ) internal virtual {}
3356 }