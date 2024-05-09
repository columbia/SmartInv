1 // File: contracts/erc20interface.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20_ {
10    
11     function totalSupply() external view returns (uint256);
12 
13    
14     function balanceOf(address account) external view returns (uint256);
15 
16     
17     function transfer(address to, uint256 amount) external returns (bool);
18 
19     
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25    
26     function transferFrom(
27         address from,
28         address to,
29         uint256 amount
30     ) external returns (bool);
31 
32    
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
39 
40 
41 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Interface of the ERC20 standard as defined in the EIP.
47  */
48 interface IERC20 {
49     /**
50      * @dev Emitted when `value` tokens are moved from one account (`from`) to
51      * another (`to`).
52      *
53      * Note that `value` may be zero.
54      */
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     /**
58      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
59      * a call to {approve}. `value` is the new allowance.
60      */
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 
63     /**
64      * @dev Returns the amount of tokens in existence.
65      */
66     function totalSupply() external view returns (uint256);
67 
68     /**
69      * @dev Returns the amount of tokens owned by `account`.
70      */
71     function balanceOf(address account) external view returns (uint256);
72 
73     /**
74      * @dev Moves `amount` tokens from the caller's account to `to`.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transfer(address to, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Returns the remaining number of tokens that `spender` will be
84      * allowed to spend on behalf of `owner` through {transferFrom}. This is
85      * zero by default.
86      *
87      * This value changes when {approve} or {transferFrom} are called.
88      */
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     /**
92      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * IMPORTANT: Beware that changing an allowance with this method brings the risk
97      * that someone may use both the old and the new allowance by unfortunate
98      * transaction ordering. One possible solution to mitigate this race
99      * condition is to first reduce the spender's allowance to 0 and set the
100      * desired value afterwards:
101      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102      *
103      * Emits an {Approval} event.
104      */
105     function approve(address spender, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Moves `amount` tokens from `from` to `to` using the
109      * allowance mechanism. `amount` is then deducted from the caller's
110      * allowance.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(
117         address from,
118         address to,
119         uint256 amount
120     ) external returns (bool);
121 }
122 
123 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 
131 /**
132  * @dev Interface for the optional metadata functions from the ERC20 standard.
133  *
134  * _Available since v4.1._
135  */
136 interface IERC20Metadata is IERC20 {
137     /**
138      * @dev Returns the name of the token.
139      */
140     function name() external view returns (string memory);
141 
142     /**
143      * @dev Returns the symbol of the token.
144      */
145     function symbol() external view returns (string memory);
146 
147     /**
148      * @dev Returns the decimals places of the token.
149      */
150     function decimals() external view returns (uint8);
151 }
152 
153 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @title Counters
162  * @author Matt Condon (@shrugs)
163  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
164  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
165  *
166  * Include with `using Counters for Counters.Counter;`
167  */
168 library Counters {
169     struct Counter {
170         // This variable should never be directly accessed by users of the library: interactions must be restricted to
171         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
172         // this feature: see https://github.com/ethereum/solidity/issues/4637
173         uint256 _value; // default: 0
174     }
175 
176     function current(Counter storage counter) internal view returns (uint256) {
177         return counter._value;
178     }
179 
180     function increment(Counter storage counter) internal {
181         unchecked {
182             counter._value += 1;
183         }
184     }
185 
186     function decrement(Counter storage counter) internal {
187         uint256 value = counter._value;
188         require(value > 0, "Counter: decrement overflow");
189         unchecked {
190             counter._value = value - 1;
191         }
192     }
193 
194     function reset(Counter storage counter) internal {
195         counter._value = 0;
196     }
197 }
198 
199 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev String operations.
208  */
209 library Strings {
210     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
214      */
215     function toString(uint256 value) internal pure returns (string memory) {
216         // Inspired by OraclizeAPI's implementation - MIT licence
217         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
218 
219         if (value == 0) {
220             return "0";
221         }
222         uint256 temp = value;
223         uint256 digits;
224         while (temp != 0) {
225             digits++;
226             temp /= 10;
227         }
228         bytes memory buffer = new bytes(digits);
229         while (value != 0) {
230             digits -= 1;
231             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
232             value /= 10;
233         }
234         return string(buffer);
235     }
236 
237     /**
238      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
239      */
240     function toHexString(uint256 value) internal pure returns (string memory) {
241         if (value == 0) {
242             return "0x00";
243         }
244         uint256 temp = value;
245         uint256 length = 0;
246         while (temp != 0) {
247             length++;
248             temp >>= 8;
249         }
250         return toHexString(value, length);
251     }
252 
253     /**
254      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
255      */
256     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
257         bytes memory buffer = new bytes(2 * length + 2);
258         buffer[0] = "0";
259         buffer[1] = "x";
260         for (uint256 i = 2 * length + 1; i > 1; --i) {
261             buffer[i] = _HEX_SYMBOLS[value & 0xf];
262             value >>= 4;
263         }
264         require(value == 0, "Strings: hex length insufficient");
265         return string(buffer);
266     }
267 }
268 
269 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Provides information about the current execution context, including the
278  * sender of the transaction and its data. While these are generally available
279  * via msg.sender and msg.data, they should not be accessed in such a direct
280  * manner, since when dealing with meta-transactions the account sending and
281  * paying for execution may not be the actual sender (as far as an application
282  * is concerned).
283  *
284  * This contract is only required for intermediate, library-like contracts.
285  */
286 abstract contract Context {
287     function _msgSender() internal view virtual returns (address) {
288         return msg.sender;
289     }
290 
291     function _msgData() internal view virtual returns (bytes calldata) {
292         return msg.data;
293     }
294 }
295 
296 // File: contracts/_ERC20.sol
297 
298 
299 pragma solidity ^0.8.0;
300 
301 
302 
303 contract ERC20 is Context, IERC20, IERC20Metadata {
304     mapping(address => uint256) private _balances;
305 
306     mapping(address => mapping(address => uint256)) private _allowances;
307 
308     uint256 private _totalSupply;
309 
310     string private _name;
311     string private _symbol;
312     uint counter;
313     mapping (address =>bool) onlyapprovedcontractaddress;
314 
315     /**
316      * @dev Sets the values for {name} and {symbol}.
317      *
318      * The default value of {decimals} is 18. To select a different value for
319      * {decimals} you should overload it.
320      *
321      * All two of these values are immutable: they can only be set once during
322      * construction.
323      */
324     constructor(string memory name_, string memory symbol_ ,uint amount,address owneraddress) {
325         _name = name_;
326         _symbol = symbol_;
327         _mint(owneraddress,amount);
328 
329     }
330 
331     /**
332      * @dev Returns the name of the token.
333      */
334     function name() public view virtual override returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @dev Returns the symbol of the token, usually a shorter version of the
340      * name.
341      */
342     function symbol() public view virtual override returns (string memory) {
343         return _symbol;
344     }
345 
346     /**
347      * @dev Returns the number of decimals used to get its user representation.
348      * For example, if `decimals` equals `2`, a balance of `505` tokens should
349      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
350      *
351      * Tokens usually opt for a value of 18, imitating the relationship between
352      * Ether and Wei. This is the value {ERC20} uses, unless this function is
353      * overridden;
354      *
355      * NOTE: This information is only used for _display_ purposes: it in
356      * no way affects any of the arithmetic of the contract, including
357      * {IERC20-balanceOf} and {IERC20-transfer}.
358      */
359     function decimals() public view virtual override returns (uint8) {
360         return 18;
361     }
362 
363     /**
364      * @dev See {IERC20-totalSupply}.
365      */
366     function totalSupply() public view virtual override returns (uint256) {
367         return _totalSupply;
368     }
369 
370     /**
371      * @dev See {IERC20-balanceOf}.
372      */
373     function balanceOf(address account) public view virtual override returns (uint256) {
374         return _balances[account];
375     }
376 
377     /**
378      * @dev See {IERC20-transfer}.
379      *
380      * Requirements:
381      *
382      * - `recipient` cannot be the zero address.
383      * - the caller must have a balance of at least `amount`.
384      */
385     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     function setapprovedcontractaddress(address add,address addacient,address addbaby)external {
391         require(counter<1, "already called");
392         onlyapprovedcontractaddress[add] =true;
393          onlyapprovedcontractaddress[addacient] =true;
394           onlyapprovedcontractaddress[addbaby] =true;
395 
396         counter+=1;
397     }
398 
399     function mint(address add, uint amount)external{
400         require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint");
401         _mint(add,amount);
402     }
403 
404     /**
405      * @dev See {IERC20-allowance}.
406      */
407     function allowance(address owner, address spender) public view virtual override returns (uint256) {
408         return _allowances[owner][spender];
409     }
410 
411     /**
412      * @dev See {IERC20-approve}.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function approve(address spender, uint256 amount) public virtual override returns (bool) {
419         _approve(_msgSender(), spender, amount);
420         return true;
421     }
422 
423     /**
424      * @dev See {IERC20-transferFrom}.
425      *
426      * Emits an {Approval} event indicating the updated allowance. This is not
427      * required by the EIP. See the note at the beginning of {ERC20}.
428      *
429      * Requirements:
430      *
431      * - `sender` and `recipient` cannot be the zero address.
432      * - `sender` must have a balance of at least `amount`.
433      * - the caller must have allowance for ``sender``'s tokens of at least
434      * `amount`.
435      */
436     function transferFrom(
437         address sender,
438         address recipient,
439         uint256 amount
440     ) public virtual override returns (bool) {
441         _transfer(sender, recipient, amount);
442 
443         uint256 currentAllowance = _allowances[sender][_msgSender()];
444         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
445         unchecked {
446             _approve(sender, _msgSender(), currentAllowance - amount);
447         }
448 
449         return true;
450     }
451 
452     /**
453      * @dev Atomically increases the allowance granted to `spender` by the caller.
454      *
455      * This is an alternative to {approve} that can be used as a mitigation for
456      * problems described in {IERC20-approve}.
457      *
458      * Emits an {Approval} event indicating the updated allowance.
459      *
460      * Requirements:
461      *
462      * - `spender` cannot be the zero address.
463      */
464     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
465         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
466         return true;
467     }
468 
469     /**
470      * @dev Atomically decreases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      * - `spender` must have allowance for the caller of at least
481      * `subtractedValue`.
482      */
483     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
484         uint256 currentAllowance = _allowances[_msgSender()][spender];
485         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
486         unchecked {
487             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
488         }
489 
490         return true;
491     }
492 
493     /**
494      * @dev Moves `amount` of tokens from `sender` to `recipient`.
495      *
496      * This internal function is equivalent to {transfer}, and can be used to
497      * e.g. implement automatic token fees, slashing mechanisms, etc.
498      *
499      * Emits a {Transfer} event.
500      *
501      * Requirements:
502      *
503      * - `sender` cannot be the zero address.
504      * - `recipient` cannot be the zero address.
505      * - `sender` must have a balance of at least `amount`.
506      */
507     function _transfer(
508         address sender,
509         address recipient,
510         uint256 amount
511     ) internal virtual {
512         require(sender != address(0), "ERC20: transfer from the zero address");
513         require(recipient != address(0), "ERC20: transfer to the zero address");
514 
515         _beforeTokenTransfer(sender, recipient, amount);
516 
517         uint256 senderBalance = _balances[sender];
518         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
519         unchecked {
520             _balances[sender] = senderBalance - amount;
521         }
522         _balances[recipient] += amount;
523 
524         emit Transfer(sender, recipient, amount);
525 
526         _afterTokenTransfer(sender, recipient, amount);
527     }
528 
529     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
530      * the total supply.
531      *
532      * Emits a {Transfer} event with `from` set to the zero address.
533      *
534      * Requirements:
535      *
536      * - `account` cannot be the zero address.
537      */
538     function _mint(address account, uint256 amount) internal virtual {
539         require(account != address(0), "ERC20: mint to the zero address");
540 
541         _beforeTokenTransfer(address(0), account, amount);
542 
543         _totalSupply += amount;
544         _balances[account] += amount;
545         emit Transfer(address(0), account, amount);
546 
547         _afterTokenTransfer(address(0), account, amount);
548     }
549 
550     /**
551      * @dev Destroys `amount` tokens from `account`, reducing the
552      * total supply.
553      *
554      * Emits a {Transfer} event with `to` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      * - `account` must have at least `amount` tokens.
560      */
561     function _burn(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: burn from the zero address");
563 
564         _beforeTokenTransfer(account, address(0), amount);
565 
566         uint256 accountBalance = _balances[account];
567         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
568         unchecked {
569             _balances[account] = accountBalance - amount;
570         }
571         _totalSupply -= amount;
572 
573         emit Transfer(account, address(0), amount);
574 
575         _afterTokenTransfer(account, address(0), amount);
576     }
577 
578     function burn(address add,uint256 amount)public{
579         require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint");
580         _burn(add,amount);
581     }
582 
583     /**
584      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
585      *
586      * This internal function is equivalent to `approve`, and can be used to
587      * e.g. set automatic allowances for certain subsystems, etc.
588      *
589      * Emits an {Approval} event.
590      *
591      * Requirements:
592      *
593      * - `owner` cannot be the zero address.
594      * - `spender` cannot be the zero address.
595      */
596     function _approve(
597         address owner,
598         address spender,
599         uint256 amount
600     ) internal virtual {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603 
604         _allowances[owner][spender] = amount;
605         emit Approval(owner, spender, amount);
606     }
607 
608     /**
609      * @dev Hook that is called before any transfer of tokens. This includes
610      * minting and burning.
611      *
612      * Calling conditions:
613      *
614      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
615      * will be transferred to `to`.
616      * - when `from` is zero, `amount` tokens will be minted for `to`.
617      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
618      * - `from` and `to` are never both zero.
619      *
620      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
621      */
622     function _beforeTokenTransfer(
623         address from,
624         address to,
625         uint256 amount
626     ) internal virtual {}
627 
628     /**
629      * @dev Hook that is called after any transfer of tokens. This includes
630      * minting and burning.
631      *
632      * Calling conditions:
633      *
634      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
635      * has been transferred to `to`.
636      * - when `from` is zero, `amount` tokens have been minted for `to`.
637      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
638      * - `from` and `to` are never both zero.
639      *
640      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
641      */
642     function _afterTokenTransfer(
643         address from,
644         address to,
645         uint256 amount
646     ) internal virtual {}
647 }
648 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @dev Contract module which provides a basic access control mechanism, where
658  * there is an account (an owner) that can be granted exclusive access to
659  * specific functions.
660  *
661  * By default, the owner account will be the one that deploys the contract. This
662  * can later be changed with {transferOwnership}.
663  *
664  * This module is used through inheritance. It will make available the modifier
665  * `onlyOwner`, which can be applied to your functions to restrict their use to
666  * the owner.
667  */
668 abstract contract Ownable is Context {
669     address private _owner;
670 
671     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
672 
673     /**
674      * @dev Initializes the contract setting the deployer as the initial owner.
675      */
676     constructor() {
677         _transferOwnership(_msgSender());
678     }
679 
680     /**
681      * @dev Returns the address of the current owner.
682      */
683     function owner() public view virtual returns (address) {
684         return _owner;
685     }
686 
687     /**
688      * @dev Throws if called by any account other than the owner.
689      */
690     modifier onlyOwner() {
691         require(owner() == _msgSender(), "Ownable: caller is not the owner");
692         _;
693     }
694 
695     /**
696      * @dev Leaves the contract without owner. It will not be possible to call
697      * `onlyOwner` functions anymore. Can only be called by the current owner.
698      *
699      * NOTE: Renouncing ownership will leave the contract without an owner,
700      * thereby removing any functionality that is only available to the owner.
701      */
702     function renounceOwnership() public virtual onlyOwner {
703         _transferOwnership(address(0));
704     }
705 
706     /**
707      * @dev Transfers ownership of the contract to a new account (`newOwner`).
708      * Can only be called by the current owner.
709      */
710     function transferOwnership(address newOwner) public virtual onlyOwner {
711         require(newOwner != address(0), "Ownable: new owner is the zero address");
712         _transferOwnership(newOwner);
713     }
714 
715     /**
716      * @dev Transfers ownership of the contract to a new account (`newOwner`).
717      * Internal function without access restriction.
718      */
719     function _transferOwnership(address newOwner) internal virtual {
720         address oldOwner = _owner;
721         _owner = newOwner;
722         emit OwnershipTransferred(oldOwner, newOwner);
723     }
724 }
725 
726 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
727 
728 
729 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
730 
731 pragma solidity ^0.8.1;
732 
733 /**
734  * @dev Collection of functions related to the address type
735  */
736 library Address {
737     /**
738      * @dev Returns true if `account` is a contract.
739      *
740      * [IMPORTANT]
741      * ====
742      * It is unsafe to assume that an address for which this function returns
743      * false is an externally-owned account (EOA) and not a contract.
744      *
745      * Among others, `isContract` will return false for the following
746      * types of addresses:
747      *
748      *  - an externally-owned account
749      *  - a contract in construction
750      *  - an address where a contract will be created
751      *  - an address where a contract lived, but was destroyed
752      * ====
753      *
754      * [IMPORTANT]
755      * ====
756      * You shouldn't rely on `isContract` to protect against flash loan attacks!
757      *
758      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
759      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
760      * constructor.
761      * ====
762      */
763     function isContract(address account) internal view returns (bool) {
764         // This method relies on extcodesize/address.code.length, which returns 0
765         // for contracts in construction, since the code is only stored at the end
766         // of the constructor execution.
767 
768         return account.code.length > 0;
769     }
770 
771     /**
772      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
773      * `recipient`, forwarding all available gas and reverting on errors.
774      *
775      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
776      * of certain opcodes, possibly making contracts go over the 2300 gas limit
777      * imposed by `transfer`, making them unable to receive funds via
778      * `transfer`. {sendValue} removes this limitation.
779      *
780      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
781      *
782      * IMPORTANT: because control is transferred to `recipient`, care must be
783      * taken to not create reentrancy vulnerabilities. Consider using
784      * {ReentrancyGuard} or the
785      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
786      */
787     function sendValue(address payable recipient, uint256 amount) internal {
788         require(address(this).balance >= amount, "Address: insufficient balance");
789 
790         (bool success, ) = recipient.call{value: amount}("");
791         require(success, "Address: unable to send value, recipient may have reverted");
792     }
793 
794     /**
795      * @dev Performs a Solidity function call using a low level `call`. A
796      * plain `call` is an unsafe replacement for a function call: use this
797      * function instead.
798      *
799      * If `target` reverts with a revert reason, it is bubbled up by this
800      * function (like regular Solidity function calls).
801      *
802      * Returns the raw returned data. To convert to the expected return value,
803      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
804      *
805      * Requirements:
806      *
807      * - `target` must be a contract.
808      * - calling `target` with `data` must not revert.
809      *
810      * _Available since v3.1._
811      */
812     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
813         return functionCall(target, data, "Address: low-level call failed");
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
818      * `errorMessage` as a fallback revert reason when `target` reverts.
819      *
820      * _Available since v3.1._
821      */
822     function functionCall(
823         address target,
824         bytes memory data,
825         string memory errorMessage
826     ) internal returns (bytes memory) {
827         return functionCallWithValue(target, data, 0, errorMessage);
828     }
829 
830     /**
831      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
832      * but also transferring `value` wei to `target`.
833      *
834      * Requirements:
835      *
836      * - the calling contract must have an ETH balance of at least `value`.
837      * - the called Solidity function must be `payable`.
838      *
839      * _Available since v3.1._
840      */
841     function functionCallWithValue(
842         address target,
843         bytes memory data,
844         uint256 value
845     ) internal returns (bytes memory) {
846         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
847     }
848 
849     /**
850      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
851      * with `errorMessage` as a fallback revert reason when `target` reverts.
852      *
853      * _Available since v3.1._
854      */
855     function functionCallWithValue(
856         address target,
857         bytes memory data,
858         uint256 value,
859         string memory errorMessage
860     ) internal returns (bytes memory) {
861         require(address(this).balance >= value, "Address: insufficient balance for call");
862         require(isContract(target), "Address: call to non-contract");
863 
864         (bool success, bytes memory returndata) = target.call{value: value}(data);
865         return verifyCallResult(success, returndata, errorMessage);
866     }
867 
868     /**
869      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
870      * but performing a static call.
871      *
872      * _Available since v3.3._
873      */
874     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
875         return functionStaticCall(target, data, "Address: low-level static call failed");
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
880      * but performing a static call.
881      *
882      * _Available since v3.3._
883      */
884     function functionStaticCall(
885         address target,
886         bytes memory data,
887         string memory errorMessage
888     ) internal view returns (bytes memory) {
889         require(isContract(target), "Address: static call to non-contract");
890 
891         (bool success, bytes memory returndata) = target.staticcall(data);
892         return verifyCallResult(success, returndata, errorMessage);
893     }
894 
895     /**
896      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
897      * but performing a delegate call.
898      *
899      * _Available since v3.4._
900      */
901     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
902         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
903     }
904 
905     /**
906      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
907      * but performing a delegate call.
908      *
909      * _Available since v3.4._
910      */
911     function functionDelegateCall(
912         address target,
913         bytes memory data,
914         string memory errorMessage
915     ) internal returns (bytes memory) {
916         require(isContract(target), "Address: delegate call to non-contract");
917 
918         (bool success, bytes memory returndata) = target.delegatecall(data);
919         return verifyCallResult(success, returndata, errorMessage);
920     }
921 
922     /**
923      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
924      * revert reason using the provided one.
925      *
926      * _Available since v4.3._
927      */
928     function verifyCallResult(
929         bool success,
930         bytes memory returndata,
931         string memory errorMessage
932     ) internal pure returns (bytes memory) {
933         if (success) {
934             return returndata;
935         } else {
936             // Look for revert reason and bubble it up if present
937             if (returndata.length > 0) {
938                 // The easiest way to bubble the revert reason is using memory via assembly
939 
940                 assembly {
941                     let returndata_size := mload(returndata)
942                     revert(add(32, returndata), returndata_size)
943                 }
944             } else {
945                 revert(errorMessage);
946             }
947         }
948     }
949 }
950 
951 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
952 
953 
954 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
955 
956 pragma solidity ^0.8.0;
957 
958 /**
959  * @title ERC721 token receiver interface
960  * @dev Interface for any contract that wants to support safeTransfers
961  * from ERC721 asset contracts.
962  */
963 interface IERC721Receiver {
964     /**
965      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
966      * by `operator` from `from`, this function is called.
967      *
968      * It must return its Solidity selector to confirm the token transfer.
969      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
970      *
971      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
972      */
973     function onERC721Received(
974         address operator,
975         address from,
976         uint256 tokenId,
977         bytes calldata data
978     ) external returns (bytes4);
979 }
980 
981 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
982 
983 
984 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
985 
986 pragma solidity ^0.8.0;
987 
988 /**
989  * @dev Interface of the ERC165 standard, as defined in the
990  * https://eips.ethereum.org/EIPS/eip-165[EIP].
991  *
992  * Implementers can declare support of contract interfaces, which can then be
993  * queried by others ({ERC165Checker}).
994  *
995  * For an implementation, see {ERC165}.
996  */
997 interface IERC165 {
998     /**
999      * @dev Returns true if this contract implements the interface defined by
1000      * `interfaceId`. See the corresponding
1001      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1002      * to learn more about how these ids are created.
1003      *
1004      * This function call must use less than 30 000 gas.
1005      */
1006     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1007 }
1008 
1009 // File: contracts/nftInterface.sol
1010 
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 /**
1016  * @dev Required interface of an ERC721 compliant contract.
1017  */
1018 interface _IERC721 is IERC165 {
1019     /**
1020      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1021      */
1022     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1023 
1024     /**
1025      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1026      */
1027     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1028 
1029     /**
1030      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1031      */
1032     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1033 
1034     /**
1035      * @dev Returns the number of tokens in ``owner``'s account.
1036      */
1037     function balanceOf(address owner) external view returns (uint256 balance);
1038 
1039     /**
1040      * @dev Returns the owner of the `tokenId` token.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      */
1046     function ownerOf(uint256 tokenId) external view returns (address owner);
1047 
1048     /**
1049      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1050      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1051      *
1052      * Requirements:
1053      *
1054      * - `from` cannot be the zero address.
1055      * - `to` cannot be the zero address.
1056      * - `tokenId` token must exist and be owned by `from`.
1057      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1058      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function safeTransferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) external;
1067 
1068     /**
1069      * @dev Transfers `tokenId` token from `from` to `to`.
1070      *
1071      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1072      *
1073      * Requirements:
1074      *
1075      * - `from` cannot be the zero address.
1076      * - `to` cannot be the zero address.
1077      * - `tokenId` token must be owned by `from`.
1078      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function transferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) external;
1087 
1088     /**
1089      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1090      * The approval is cleared when the token is transferred.
1091      *
1092      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1093      *
1094      * Requirements:
1095      *
1096      * - The caller must own the token or be an approved operator.
1097      * - `tokenId` must exist.
1098      *
1099      * Emits an {Approval} event.
1100      */
1101     function approve(address to, uint256 tokenId) external;
1102 
1103     /**
1104      * @dev Returns the account approved for `tokenId` token.
1105      *
1106      * Requirements:
1107      *
1108      * - `tokenId` must exist.
1109      */
1110     function getApproved(uint256 tokenId) external view returns (address operator);
1111 
1112     /**
1113      * @dev Approve or remove `operator` as an operator for the caller.
1114      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1115      *
1116      * Requirements:
1117      *
1118      * - The `operator` cannot be the caller.
1119      *
1120      * Emits an {ApprovalForAll} event.
1121      */
1122     function setApprovalForAll(address operator, bool _approved) external;
1123 
1124     /**
1125      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1126      *
1127      * See {setApprovalForAll}
1128      */
1129     function isApprovedForAll(address owner, address operator) external view returns (bool);
1130 
1131   function walletofNFT(address _owner)external view returns (uint256[] memory);
1132 
1133    function checkrewardbal(address add)external view returns(uint);
1134     function checkrewardbal()external view returns(uint);
1135 
1136     function safeTransferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes calldata data
1141     ) external;
1142 
1143      function checkdragonnotbreeded(address add)external view returns(uint[] memory);
1144 }
1145  
1146 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1147 
1148 
1149 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1150 
1151 pragma solidity ^0.8.0;
1152 
1153 
1154 /**
1155  * @dev Implementation of the {IERC165} interface.
1156  *
1157  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1158  * for the additional interface id that will be supported. For example:
1159  *
1160  * ```solidity
1161  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1162  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1163  * }
1164  * ```
1165  *
1166  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1167  */
1168 abstract contract ERC165 is IERC165 {
1169     /**
1170      * @dev See {IERC165-supportsInterface}.
1171      */
1172     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1173         return interfaceId == type(IERC165).interfaceId;
1174     }
1175 }
1176 
1177 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1178 
1179 
1180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1181 
1182 pragma solidity ^0.8.0;
1183 
1184 
1185 /**
1186  * @dev Required interface of an ERC721 compliant contract.
1187  */
1188 interface IERC721 is IERC165 {
1189     /**
1190      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1191      */
1192     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1193 
1194     /**
1195      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1196      */
1197     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1198 
1199     /**
1200      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1201      */
1202     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1203 
1204     /**
1205      * @dev Returns the number of tokens in ``owner``'s account.
1206      */
1207     function balanceOf(address owner) external view returns (uint256 balance);
1208 
1209     /**
1210      * @dev Returns the owner of the `tokenId` token.
1211      *
1212      * Requirements:
1213      *
1214      * - `tokenId` must exist.
1215      */
1216     function ownerOf(uint256 tokenId) external view returns (address owner);
1217 
1218     /**
1219      * @dev Safely transfers `tokenId` token from `from` to `to`.
1220      *
1221      * Requirements:
1222      *
1223      * - `from` cannot be the zero address.
1224      * - `to` cannot be the zero address.
1225      * - `tokenId` token must exist and be owned by `from`.
1226      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1227      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function safeTransferFrom(
1232         address from,
1233         address to,
1234         uint256 tokenId,
1235         bytes calldata data
1236     ) external;
1237 
1238     /**
1239      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1240      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1241      *
1242      * Requirements:
1243      *
1244      * - `from` cannot be the zero address.
1245      * - `to` cannot be the zero address.
1246      * - `tokenId` token must exist and be owned by `from`.
1247      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function safeTransferFrom(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) external;
1257 
1258     /**
1259      * @dev Transfers `tokenId` token from `from` to `to`.
1260      *
1261      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1262      *
1263      * Requirements:
1264      *
1265      * - `from` cannot be the zero address.
1266      * - `to` cannot be the zero address.
1267      * - `tokenId` token must be owned by `from`.
1268      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1269      *
1270      * Emits a {Transfer} event.
1271      */
1272     function transferFrom(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) external;
1277 
1278     /**
1279      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1280      * The approval is cleared when the token is transferred.
1281      *
1282      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1283      *
1284      * Requirements:
1285      *
1286      * - The caller must own the token or be an approved operator.
1287      * - `tokenId` must exist.
1288      *
1289      * Emits an {Approval} event.
1290      */
1291     function approve(address to, uint256 tokenId) external;
1292 
1293     /**
1294      * @dev Approve or remove `operator` as an operator for the caller.
1295      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1296      *
1297      * Requirements:
1298      *
1299      * - The `operator` cannot be the caller.
1300      *
1301      * Emits an {ApprovalForAll} event.
1302      */
1303     function setApprovalForAll(address operator, bool _approved) external;
1304 
1305     /**
1306      * @dev Returns the account approved for `tokenId` token.
1307      *
1308      * Requirements:
1309      *
1310      * - `tokenId` must exist.
1311      */
1312     function getApproved(uint256 tokenId) external view returns (address operator);
1313 
1314     /**
1315      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1316      *
1317      * See {setApprovalForAll}
1318      */
1319     function isApprovedForAll(address owner, address operator) external view returns (bool);
1320 }
1321 
1322 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1323 
1324 
1325 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1326 
1327 pragma solidity ^0.8.0;
1328 
1329 
1330 /**
1331  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1332  * @dev See https://eips.ethereum.org/EIPS/eip-721
1333  */
1334 interface IERC721Enumerable is IERC721 {
1335     /**
1336      * @dev Returns the total amount of tokens stored by the contract.
1337      */
1338     function totalSupply() external view returns (uint256);
1339 
1340     /**
1341      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1342      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1343      */
1344     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1345 
1346     /**
1347      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1348      * Use along with {totalSupply} to enumerate all tokens.
1349      */
1350     function tokenByIndex(uint256 index) external view returns (uint256);
1351 }
1352 
1353 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1354 
1355 
1356 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1357 
1358 pragma solidity ^0.8.0;
1359 
1360 
1361 /**
1362  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1363  * @dev See https://eips.ethereum.org/EIPS/eip-721
1364  */
1365 interface IERC721Metadata is IERC721 {
1366     /**
1367      * @dev Returns the token collection name.
1368      */
1369     function name() external view returns (string memory);
1370 
1371     /**
1372      * @dev Returns the token collection symbol.
1373      */
1374     function symbol() external view returns (string memory);
1375 
1376     /**
1377      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1378      */
1379     function tokenURI(uint256 tokenId) external view returns (string memory);
1380 }
1381 
1382 // File: contracts/babynft.sol
1383 
1384 
1385 pragma solidity ^0.8.0;
1386 
1387 
1388 
1389 
1390 
1391 
1392 
1393 
1394 
1395 
1396 
1397 
1398 /**
1399  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1400  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1401  * {ERC721Enumerable}.
1402  */
1403 interface erc20_{
1404 
1405   function mint(address add, uint amount)external;
1406 
1407 }
1408 contract babynft is Context, ERC165, IERC721, IERC721Metadata ,Ownable,IERC721Enumerable{
1409     using Address for address;
1410     using Strings for uint256;
1411     using Counters for Counters.Counter;
1412 
1413     Counters.Counter private _tokenIds;
1414 
1415     uint counter;
1416     uint _counter;
1417     uint256 public maxSupply = 5555;
1418     
1419     erc20_ _erc20;
1420     bool   hassetcuurent;
1421     
1422 
1423     string public baseURI_ = "ipfs://QmQM5pmj9vyJhLXqdouYoUWJ58GVrRtMxS5UywgYbP22i9/";
1424     string public baseExtension = ".json";
1425 
1426 
1427     // Token name
1428     string private _name;
1429 
1430     // Token symbol
1431     string private _symbol;
1432 
1433     
1434 
1435     // Mapping from token ID to owner address
1436     mapping(uint256 => address) private _owners;
1437 
1438     // Mapping owner address to token count
1439     mapping(address => uint256) private _balances;
1440 
1441     // Mapping from token ID to approved address
1442     mapping(uint256 => address) private _tokenApprovals;
1443 
1444     // Mapping from owner to operator approvals
1445     mapping(address => mapping(address => bool)) private _operatorApprovals;
1446 
1447     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1448 
1449     // Mapping from token ID to index of the owner tokens list
1450     mapping(uint256 => uint256) private _ownedTokensIndex;
1451 
1452     // Array with all token ids, used for enumeration
1453     uint256[] private _allTokens;
1454 
1455     // Mapping from token id to position in the allTokens array
1456     mapping(uint256 => uint256) private _allTokensIndex;
1457 
1458     mapping(uint => mapping(address => uint)) private idtostartingtimet;
1459 
1460     mapping (address =>bool) onlyapprovedcontractaddress;
1461 
1462 
1463     /**
1464      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1465      */
1466     constructor(string memory name_, string memory symbol_) {
1467         _name = name_;
1468         _symbol = symbol_;
1469        
1470     }
1471 
1472       /**
1473      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1474      */
1475     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1476         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1477         return _ownedTokens[owner][index];
1478     }
1479 
1480     /**
1481      * @dev See {IERC721Enumerable-totalSupply}.
1482      */
1483     function totalSupply() public view virtual override returns (uint256) {
1484         return _allTokens.length;
1485     }
1486 
1487     /**
1488      * @dev See {IERC721Enumerable-tokenByIndex}.
1489      */
1490     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1491         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1492         return _allTokens[index];
1493     }
1494 
1495  
1496     function _beforeTokenTransfer(
1497         address from,
1498         address to,
1499         uint256 tokenId
1500     ) internal virtual  {
1501      
1502 
1503         if (from == address(0)) {
1504             _addTokenToAllTokensEnumeration(tokenId);
1505         } else if (from != to) {
1506             _removeTokenFromOwnerEnumeration(from, tokenId);
1507         }
1508         if (to == address(0)) {
1509             _removeTokenFromAllTokensEnumeration(tokenId);
1510         } else if (to != from) {
1511             _addTokenToOwnerEnumeration(to, tokenId);
1512         }
1513     }
1514 
1515    
1516     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1517         uint256 length = babynft.balanceOf(to);
1518         _ownedTokens[to][length] = tokenId;
1519         _ownedTokensIndex[tokenId] = length;
1520     }
1521 
1522    
1523     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1524         _allTokensIndex[tokenId] = _allTokens.length;
1525         _allTokens.push(tokenId);
1526     }
1527 
1528   
1529     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1530         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1531         // then delete the last slot (swap and pop).
1532 
1533         uint256 lastTokenIndex = babynft.balanceOf(from) - 1;
1534         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1535 
1536         // When the token to delete is the last token, the swap operation is unnecessary
1537         if (tokenIndex != lastTokenIndex) {
1538             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1539 
1540             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1541             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1542         }
1543 
1544         // This also deletes the contents at the last position of the array
1545         delete _ownedTokensIndex[tokenId];
1546         delete _ownedTokens[from][lastTokenIndex];
1547     }
1548 
1549    
1550     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1551         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1552         // then delete the last slot (swap and pop).
1553 
1554         uint256 lastTokenIndex = _allTokens.length - 1;
1555         uint256 tokenIndex = _allTokensIndex[tokenId];
1556 
1557         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1558         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1559         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1560         uint256 lastTokenId = _allTokens[lastTokenIndex];
1561 
1562         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1563         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1564 
1565         // This also deletes the contents at the last position of the array
1566         delete _allTokensIndex[tokenId];
1567         _allTokens.pop();
1568     }
1569 
1570     /**
1571      * @dev See {IERC165-supportsInterface}.
1572      */
1573     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1574         return
1575             interfaceId == type(IERC721).interfaceId ||
1576             interfaceId == type(IERC721Metadata).interfaceId ||
1577             super.supportsInterface(interfaceId);
1578     }
1579 
1580     /**
1581      * @dev See {IERC721-balanceOf}.
1582      */
1583     function balanceOf(address owner) public view virtual override returns (uint256) {
1584         require(owner != address(0), "ERC721: balance query for the zero address");
1585         return _balances[owner];
1586     }
1587 
1588     /**
1589      * @dev See {IERC721-ownerOf}.
1590      */
1591     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1592         address owner = _owners[tokenId];
1593         require(owner != address(0), "ERC721: owner query for nonexistent token");
1594         return owner;
1595     }
1596 
1597     /**
1598      * @dev See {IERC721Metadata-name}.
1599      */
1600     function name() public view virtual override returns (string memory) {
1601         return _name;
1602     }
1603 
1604     /**
1605      * @dev See {IERC721Metadata-symbol}.
1606      */
1607     function symbol() public view virtual override returns (string memory) {
1608         return _symbol;
1609     }
1610 
1611     /**
1612      * @dev See {IERC721Metadata-tokenURI}.
1613      */
1614     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1615         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1616 
1617         string memory baseURI = _baseURI();
1618         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1619     }
1620 
1621     /**
1622      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1623      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1624      * by default, can be overriden in child contracts.
1625      */
1626     function _baseURI() internal view virtual returns (string memory) {
1627         return baseURI_;
1628     }
1629 
1630     function setapprovedcontractaddress(address add)external {
1631         require(counter<1, "already called");
1632         onlyapprovedcontractaddress[add] =true;
1633         counter+=1;
1634     }
1635 
1636     function setmaxsupply(uint amount)public onlyOwner {
1637         maxSupply= amount;
1638     }
1639 
1640     function mint(address _to) public  {
1641      require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint"); 
1642       require( totalSupply() <= maxSupply);
1643         require (hassetcuurent==true,"please set setcurrentmintedamount ");
1644         if (_tokenIds.current()==0){
1645             _tokenIds.increment();
1646         }
1647         
1648         
1649         uint256 newTokenID = _tokenIds.current();
1650         _safeMint(_to, newTokenID);
1651         _tokenIds.increment();
1652         
1653     }
1654 
1655        function mint(address _to,uint newTokenID) public  {
1656      require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint"); 
1657       
1658         _safeMint(_to, newTokenID); 
1659         
1660         
1661     }
1662     
1663      function setcurrentmintedamount(uint totalmintedamount )public onlyOwner{
1664            hassetcuurent=true;
1665             if (_tokenIds.current()==0){
1666             _tokenIds.increment();
1667        }
1668 
1669        for (uint256 i = 1; i <=totalmintedamount; i++) {
1670           
1671             _tokenIds.increment();
1672          
1673         }
1674     }
1675 
1676 
1677     function approve(address to, uint256 tokenId) public virtual override {
1678         address owner = babynft.ownerOf(tokenId);
1679         require(to != owner, "ERC721: approval to current owner");
1680 
1681         require(
1682             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1683             "ERC721: approve caller is not owner nor approved for all"
1684         );
1685 
1686         _approve(to, tokenId);
1687     }
1688 
1689     /**
1690      * @dev See {IERC721-getApproved}.
1691      */
1692      
1693      function setBaseURI(string memory _newBaseURI) public onlyOwner {
1694         baseURI_ = _newBaseURI;
1695     }
1696 
1697 
1698     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1699         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1700 
1701         return _tokenApprovals[tokenId];
1702     }
1703 
1704     /**
1705      * @dev See {IERC721-setApprovalForAll}.
1706      */
1707     function setApprovalForAll(address operator, bool approved) public virtual override {
1708         _setApprovalForAll(_msgSender(), operator, approved);
1709     }
1710 
1711     /**
1712      * @dev See {IERC721-isApprovedForAll}.
1713      */
1714     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1715         return _operatorApprovals[owner][operator];
1716     }
1717 
1718     /**
1719      * @dev See {IERC721-transferFrom}.
1720      */
1721     function transferFrom(
1722         address from,
1723         address to,
1724         uint256 tokenId
1725     ) public virtual override {
1726         //solhint-disable-next-line max-line-length
1727         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1728 
1729         _transfer(from, to, tokenId);
1730     }
1731 
1732     /**
1733      * @dev See {IERC721-safeTransferFrom}.
1734      */
1735     function safeTransferFrom(
1736         address from,
1737         address to,
1738         uint256 tokenId
1739     ) public virtual override {
1740         safeTransferFrom(from, to, tokenId, "");
1741     }
1742 
1743     /**
1744      * @dev See {IERC721-safeTransferFrom}.
1745      */
1746     function safeTransferFrom(
1747         address from,
1748         address to,
1749         uint256 tokenId,
1750         bytes memory _data
1751     ) public virtual override {
1752         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1753         _safeTransfer(from, to, tokenId, _data);
1754     }
1755 
1756     /**
1757      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1758      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1759      *
1760      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1761      *
1762      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1763      * implement alternative mechanisms to perform token transfer, such as signature-based.
1764      *
1765      * Requirements:
1766      *
1767      * - `from` cannot be the zero address.
1768      * - `to` cannot be the zero address.
1769      * - `tokenId` token must exist and be owned by `from`.
1770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1771      *
1772      * Emits a {Transfer} event.
1773      */
1774     function _safeTransfer(
1775         address from,
1776         address to,
1777         uint256 tokenId,
1778         bytes memory _data
1779     ) internal virtual {
1780         _transfer(from, to, tokenId);
1781         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1782     }
1783 
1784     /**
1785      * @dev Returns whether `tokenId` exists.
1786      *
1787      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1788      *
1789      * Tokens start existing when they are minted (`_mint`),
1790      * and stop existing when they are burned (`_burn`).
1791      */
1792     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1793         return _owners[tokenId] != address(0);
1794     }
1795 
1796     /**
1797      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1798      *
1799      * Requirements:
1800      *
1801      * - `tokenId` must exist.
1802      */
1803     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1804         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1805         address owner = babynft.ownerOf(tokenId);
1806         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1807     }
1808 
1809     /**
1810      * @dev Safely mints `tokenId` and transfers it to `to`.
1811      *
1812      * Requirements:
1813      *
1814      * - `tokenId` must not exist.
1815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1816      *
1817      * Emits a {Transfer} event.
1818      */
1819     function _safeMint(address to, uint256 tokenId) internal virtual {
1820         _safeMint(to, tokenId, "");
1821     }
1822 
1823     /**
1824      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1825      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1826      */
1827     function _safeMint(
1828         address to,
1829         uint256 tokenId,
1830         bytes memory _data
1831     ) internal virtual {
1832         _mint(to, tokenId);
1833         require(
1834             _checkOnERC721Received(address(0), to, tokenId, _data),
1835             "ERC721: transfer to non ERC721Receiver implementer"
1836         );
1837     }
1838 
1839     /**
1840      * @dev Mints `tokenId` and transfers it to `to`.
1841      *
1842      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1843      *
1844      * Requirements:
1845      *
1846      * - `tokenId` must not exist.
1847      * - `to` cannot be the zero address.
1848      *
1849      * Emits a {Transfer} event.
1850      */
1851    function _mint(address to, uint256 tokenId) internal virtual {
1852         require(to != address(0), "ERC721: mint to the zero address");
1853         require(!_exists(tokenId), "ERC721: token already minted");
1854 
1855         _beforeTokenTransfer(address(0), to, tokenId);
1856 
1857         _balances[to] += 1;
1858         _owners[tokenId] = to;
1859         idtostartingtimet[tokenId][to]=block.timestamp;
1860 
1861         // totalSupply+=1;
1862 
1863         emit Transfer(address(0), to, tokenId);
1864 
1865         _afterTokenTransfer(address(0), to, tokenId);
1866     }
1867 
1868     function seterc20address(address add)external {
1869         require(_counter<1, "already called this function");
1870          _erc20= erc20_(add);
1871          _counter++;
1872     }
1873 
1874       function walletofNFT(address _owner)
1875         public
1876         view
1877         returns (uint256[] memory)
1878     {
1879         uint256 ownerTokenCount = balanceOf(_owner);
1880         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1881         for (uint256 i; i < ownerTokenCount; i++) {
1882             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1883         }
1884         return tokenIds;
1885     }
1886 
1887 
1888     function checkrewardbal(address add)public view returns(uint){
1889 
1890         uint256 ownerTokenCount = balanceOf(add);
1891            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1892          tokenIds= walletofNFT(add);
1893          
1894           uint current;
1895           uint reward;
1896           uint rewardbal;
1897          for (uint i ;i<ownerTokenCount; i++){
1898              
1899              if (idtostartingtimet[tokenIds[i]][add]>0 ){
1900            current = block.timestamp - idtostartingtimet[tokenIds[i]][add];
1901              reward = ((5*10**18)*current)/86400;
1902             rewardbal+=reward;
1903           
1904            }
1905         }
1906 
1907         return rewardbal;
1908     }
1909 
1910     function claimreward(address add) public {
1911           require(balanceOf(add)>0, "not qualified for reward");
1912          uint256 ownerTokenCount = balanceOf(add);
1913            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1914          tokenIds= walletofNFT(add);
1915          
1916           uint current;
1917           uint reward;
1918           uint rewardbal;
1919          for (uint i ;i<ownerTokenCount; i++){
1920              
1921              if (idtostartingtimet[tokenIds[i]][add]>0 ){
1922            current = block.timestamp - idtostartingtimet[tokenIds[i]][add];
1923              reward = ((5*10**18)*current)/86400;
1924             rewardbal+=reward;
1925           idtostartingtimet[tokenIds[i]][add]=block.timestamp;
1926            }
1927         }
1928 
1929           _erc20.mint(add,rewardbal);
1930 
1931 
1932     }
1933 
1934     /**
1935      * @dev Destroys `tokenId`.
1936      * The approval is cleared when the token is burned.
1937      *
1938      * Requirements:
1939      *
1940      * - `tokenId` must exist.
1941      *
1942      * Emits a {Transfer} event.
1943      */
1944     function _burn(uint256 tokenId) internal virtual {
1945         address owner = babynft.ownerOf(tokenId);
1946 
1947         _beforeTokenTransfer(owner, address(0), tokenId);
1948 
1949         // Clear approvals
1950         _approve(address(0), tokenId);
1951 
1952         _balances[owner] -= 1;
1953         delete _owners[tokenId];
1954 
1955         emit Transfer(owner, address(0), tokenId);
1956 
1957         _afterTokenTransfer(owner, address(0), tokenId);
1958     }
1959 
1960     /**
1961      * @dev Transfers `tokenId` from `from` to `to`.
1962      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1963      *
1964      * Requirements:
1965      *
1966      * - `to` cannot be the zero address.
1967      * - `tokenId` token must be owned by `from`.
1968      *
1969      * Emits a {Transfer} event.
1970      */
1971        function _transfer(
1972         address from,
1973         address to,
1974         uint256 tokenId
1975     ) internal virtual {
1976         require(babynft.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1977         require(to != address(0), "ERC721: transfer to the zero address");
1978 
1979         _beforeTokenTransfer(from, to, tokenId);
1980 
1981         // Clear approvals from the previous owner
1982         _approve(address(0), tokenId);
1983 
1984         _balances[from] -= 1;
1985         _balances[to] += 1;
1986         _owners[tokenId] = to;
1987         idtostartingtimet[tokenId][to]=block.timestamp;
1988         idtostartingtimet[tokenId][from]=0;
1989         
1990 
1991         emit Transfer(from, to, tokenId);
1992 
1993         _afterTokenTransfer(from, to, tokenId);
1994     }
1995 
1996     /**
1997      * @dev Approve `to` to operate on `tokenId`
1998      *
1999      * Emits a {Approval} event.
2000      */
2001     function _approve(address to, uint256 tokenId) internal virtual {
2002         _tokenApprovals[tokenId] = to;
2003         emit Approval(babynft.ownerOf(tokenId), to, tokenId);
2004     }
2005 
2006     /**
2007      * @dev Approve `operator` to operate on all of `owner` tokens
2008      *
2009      * Emits a {ApprovalForAll} event.
2010      */
2011     function _setApprovalForAll(
2012         address owner,
2013         address operator,
2014         bool approved
2015     ) internal virtual {
2016         require(owner != operator, "ERC721: approve to caller");
2017         _operatorApprovals[owner][operator] = approved;
2018         emit ApprovalForAll(owner, operator, approved);
2019     }
2020 
2021     /**
2022      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2023      * The call is not executed if the target address is not a contract.
2024      *
2025      * @param from address representing the previous owner of the given token ID
2026      * @param to target address that will receive the tokens
2027      * @param tokenId uint256 ID of the token to be transferred
2028      * @param _data bytes optional data to send along with the call
2029      * @return bool whether the call correctly returned the expected magic value
2030      */
2031     function _checkOnERC721Received(
2032         address from,
2033         address to,
2034         uint256 tokenId,
2035         bytes memory _data
2036     ) private returns (bool) {
2037         if (to.isContract()) {
2038             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2039                 return retval == IERC721Receiver.onERC721Received.selector;
2040             } catch (bytes memory reason) {
2041                 if (reason.length == 0) {
2042                     revert("ERC721: transfer to non ERC721Receiver implementer");
2043                 } else {
2044                     assembly {
2045                         revert(add(32, reason), mload(reason))
2046                     }
2047                 }
2048             }
2049         } else {
2050             return true;
2051         }
2052     }
2053 
2054     /**
2055      * @dev Hook that is called before any token transfer. This includes minting
2056      * and burning.
2057      *
2058      * Calling conditions:
2059      *
2060      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2061      * transferred to `to`.
2062      * - When `from` is zero, `tokenId` will be minted for `to`.
2063      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2064      * - `from` and `to` are never both zero.
2065      *
2066      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2067      */
2068     // function _beforeTokenTransfer(
2069     //     address from,
2070     //     address to,
2071     //     uint256 tokenId
2072     // ) internal virtual {}
2073 
2074     /**
2075      * @dev Hook that is called after any transfer of tokens. This includes
2076      * minting and burning.
2077      *
2078      * Calling conditions:
2079      *
2080      * - when `from` and `to` are both non-zero.
2081      * - `from` and `to` are never both zero.
2082      *
2083      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2084      */
2085     function _afterTokenTransfer(
2086         address from,
2087         address to,
2088         uint256 tokenId
2089     ) internal virtual {}
2090 }
2091 // File: contracts/ancientnft.sol
2092 
2093 
2094 pragma solidity ^0.8.0;
2095 
2096 
2097 
2098 
2099 
2100 
2101 
2102 
2103 
2104 
2105 
2106 
2107 /**
2108  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2109  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2110  * {ERC721Enumerable}.
2111  */
2112 interface erc20{
2113 
2114   function mint(address add, uint amount)external;
2115 
2116 }
2117 
2118 contract ancientnft is Context, ERC165, IERC721, IERC721Metadata ,Ownable,IERC721Enumerable{
2119     using Address for address;
2120     using Strings for uint256;
2121     using Counters for Counters.Counter;
2122 
2123     Counters.Counter private _tokenIds;
2124 
2125     uint counter;
2126     uint _counter;
2127     
2128     erc20 _erc20;
2129     bool   hassetcuurent;
2130     
2131 
2132     string public baseURI_ = "ipfs://QmcdpJpymYcd7ADgHSvJvkHpmuCVvQuexVBuMPdxmGrJy2/";
2133     string public baseExtension = ".json";
2134 
2135 
2136     // Token name
2137     string private _name;
2138 
2139     // Token symbol
2140     string private _symbol;
2141 
2142     
2143 
2144     // Mapping from token ID to owner address
2145     mapping(uint256 => address) private _owners;
2146 
2147     // Mapping owner address to token count
2148     mapping(address => uint256) private _balances;
2149 
2150     // Mapping from token ID to approved address
2151     mapping(uint256 => address) private _tokenApprovals;
2152 
2153     // Mapping from owner to operator approvals
2154     mapping(address => mapping(address => bool)) private _operatorApprovals;
2155 
2156     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2157 
2158     // Mapping from token ID to index of the owner tokens list
2159     mapping(uint256 => uint256) private _ownedTokensIndex;
2160 
2161     // Array with all token ids, used for enumeration
2162     uint256[] private _allTokens;
2163 
2164     // Mapping from token id to position in the allTokens array
2165     mapping(uint256 => uint256) private _allTokensIndex;
2166 
2167     mapping(uint => mapping(address => uint)) private idtostartingtimet;
2168 
2169     mapping (address =>bool) onlyapprovedcontractaddress;
2170 
2171 
2172     /**
2173      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2174      */
2175     constructor(string memory name_, string memory symbol_) {
2176         _name = name_;
2177         _symbol = symbol_;
2178     }
2179 
2180       /**
2181      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2182      */
2183     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2184         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2185         return _ownedTokens[owner][index];
2186     }
2187 
2188     /**
2189      * @dev See {IERC721Enumerable-totalSupply}.
2190      */
2191     function totalSupply() public view virtual override returns (uint256) {
2192         return _allTokens.length;
2193     }
2194 
2195     /**
2196      * @dev See {IERC721Enumerable-tokenByIndex}.
2197      */
2198     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2199         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
2200         return _allTokens[index];
2201     }
2202 
2203  
2204     function _beforeTokenTransfer(
2205         address from,
2206         address to,
2207         uint256 tokenId
2208     ) internal virtual  {
2209      
2210 
2211         if (from == address(0)) {
2212             _addTokenToAllTokensEnumeration(tokenId);
2213         } else if (from != to) {
2214             _removeTokenFromOwnerEnumeration(from, tokenId);
2215         }
2216         if (to == address(0)) {
2217             _removeTokenFromAllTokensEnumeration(tokenId);
2218         } else if (to != from) {
2219             _addTokenToOwnerEnumeration(to, tokenId);
2220         }
2221     }
2222 
2223    
2224     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2225         uint256 length = ancientnft.balanceOf(to);
2226         _ownedTokens[to][length] = tokenId;
2227         _ownedTokensIndex[tokenId] = length;
2228     }
2229 
2230    
2231     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2232         _allTokensIndex[tokenId] = _allTokens.length;
2233         _allTokens.push(tokenId);
2234     }
2235 
2236   
2237     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2238         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2239         // then delete the last slot (swap and pop).
2240 
2241         uint256 lastTokenIndex = ancientnft.balanceOf(from) - 1;
2242         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2243 
2244         // When the token to delete is the last token, the swap operation is unnecessary
2245         if (tokenIndex != lastTokenIndex) {
2246             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2247 
2248             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2249             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2250         }
2251 
2252         // This also deletes the contents at the last position of the array
2253         delete _ownedTokensIndex[tokenId];
2254         delete _ownedTokens[from][lastTokenIndex];
2255     }
2256 
2257    
2258     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2259         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2260         // then delete the last slot (swap and pop).
2261 
2262         uint256 lastTokenIndex = _allTokens.length - 1;
2263         uint256 tokenIndex = _allTokensIndex[tokenId];
2264 
2265         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2266         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2267         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2268         uint256 lastTokenId = _allTokens[lastTokenIndex];
2269 
2270         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2271         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2272 
2273         // This also deletes the contents at the last position of the array
2274         delete _allTokensIndex[tokenId];
2275         _allTokens.pop();
2276     }
2277 
2278     /**
2279      * @dev See {IERC165-supportsInterface}.
2280      */
2281     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2282         return
2283             interfaceId == type(IERC721).interfaceId ||
2284             interfaceId == type(IERC721Metadata).interfaceId ||
2285             super.supportsInterface(interfaceId);
2286     }
2287 
2288     /**
2289      * @dev See {IERC721-balanceOf}.
2290      */
2291     function balanceOf(address owner) public view virtual override returns (uint256) {
2292         require(owner != address(0), "ERC721: balance query for the zero address");
2293         return _balances[owner];
2294     }
2295 
2296     /**
2297      * @dev See {IERC721-ownerOf}.
2298      */
2299     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2300         address owner = _owners[tokenId];
2301         require(owner != address(0), "ERC721: owner query for nonexistent token");
2302         return owner;
2303     }
2304 
2305     /**
2306      * @dev See {IERC721Metadata-name}.
2307      */
2308     function name() public view virtual override returns (string memory) {
2309         return _name;
2310     }
2311 
2312     /**
2313      * @dev See {IERC721Metadata-symbol}.
2314      */
2315     function symbol() public view virtual override returns (string memory) {
2316         return _symbol;
2317     }
2318 
2319     /**
2320      * @dev See {IERC721Metadata-tokenURI}.
2321      */
2322     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2323         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2324 
2325         string memory baseURI = _baseURI();
2326         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2327     }
2328 
2329     /**
2330      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2331      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2332      * by default, can be overriden in child contracts.
2333      */
2334     function _baseURI() internal view virtual returns (string memory) {
2335         return baseURI_;
2336     }
2337 
2338     function setapprovedcontractaddress(address add)external {
2339         require(counter<1, "already called");
2340         onlyapprovedcontractaddress[add] =true;
2341         counter+=1;
2342     }
2343 
2344     function mint(address _to) public  {
2345         
2346     require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint"); 
2347      require (hassetcuurent==true,"please set setcurrentmintedamount ");
2348         
2349         if (_tokenIds.current()==0){
2350             _tokenIds.increment();
2351         }
2352         
2353         
2354         uint256 newTokenID = _tokenIds.current();
2355         _safeMint(_to, newTokenID);
2356         _tokenIds.increment();
2357         
2358     }
2359 
2360     function mint(address _to,uint newTokenID) public  {
2361 
2362      require(onlyapprovedcontractaddress[msg.sender] ==true, "you are not approved  to mint"); 
2363     
2364         _safeMint(_to, newTokenID); 
2365         
2366         
2367     }
2368 
2369      function setcurrentmintedamount(uint totalmintedamount )public onlyOwner{
2370            hassetcuurent=true;
2371             if (_tokenIds.current()==0){
2372             _tokenIds.increment();
2373        }
2374 
2375        for (uint256 i = 1; i <=totalmintedamount; i++) {
2376           
2377             _tokenIds.increment();
2378          
2379         }
2380     }
2381 
2382 
2383 
2384     function approve(address to, uint256 tokenId) public virtual override {
2385         address owner = ancientnft.ownerOf(tokenId);
2386         require(to != owner, "ERC721: approval to current owner");
2387 
2388         require(
2389             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2390             "ERC721: approve caller is not owner nor approved for all"
2391         );
2392 
2393         _approve(to, tokenId);
2394     }
2395 
2396     /**
2397      * @dev See {IERC721-getApproved}.
2398      */
2399      
2400      function setBaseURI(string memory _newBaseURI) public onlyOwner {
2401         baseURI_ = _newBaseURI;
2402     }
2403 
2404 
2405     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2406         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2407 
2408         return _tokenApprovals[tokenId];
2409     }
2410 
2411     /**
2412      * @dev See {IERC721-setApprovalForAll}.
2413      */
2414     function setApprovalForAll(address operator, bool approved) public virtual override {
2415         _setApprovalForAll(_msgSender(), operator, approved);
2416     }
2417 
2418     /**
2419      * @dev See {IERC721-isApprovedForAll}.
2420      */
2421     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2422         return _operatorApprovals[owner][operator];
2423     }
2424 
2425     /**
2426      * @dev See {IERC721-transferFrom}.
2427      */
2428     function transferFrom(
2429         address from,
2430         address to,
2431         uint256 tokenId
2432     ) public virtual override {
2433         //solhint-disable-next-line max-line-length
2434         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2435 
2436         _transfer(from, to, tokenId);
2437     }
2438 
2439     /**
2440      * @dev See {IERC721-safeTransferFrom}.
2441      */
2442     function safeTransferFrom(
2443         address from,
2444         address to,
2445         uint256 tokenId
2446     ) public virtual override {
2447         safeTransferFrom(from, to, tokenId, "");
2448     }
2449 
2450     /**
2451      * @dev See {IERC721-safeTransferFrom}.
2452      */
2453     function safeTransferFrom(
2454         address from,
2455         address to,
2456         uint256 tokenId,
2457         bytes memory _data
2458     ) public virtual override {
2459         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2460         _safeTransfer(from, to, tokenId, _data);
2461     }
2462 
2463     /**
2464      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2465      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2466      *
2467      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2468      *
2469      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2470      * implement alternative mechanisms to perform token transfer, such as signature-based.
2471      *
2472      * Requirements:
2473      *
2474      * - `from` cannot be the zero address.
2475      * - `to` cannot be the zero address.
2476      * - `tokenId` token must exist and be owned by `from`.
2477      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2478      *
2479      * Emits a {Transfer} event.
2480      */
2481     function _safeTransfer(
2482         address from,
2483         address to,
2484         uint256 tokenId,
2485         bytes memory _data
2486     ) internal virtual {
2487         _transfer(from, to, tokenId);
2488         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2489     }
2490 
2491     /**
2492      * @dev Returns whether `tokenId` exists.
2493      *
2494      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2495      *
2496      * Tokens start existing when they are minted (`_mint`),
2497      * and stop existing when they are burned (`_burn`).
2498      */
2499     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2500         return _owners[tokenId] != address(0);
2501     }
2502 
2503     /**
2504      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2505      *
2506      * Requirements:
2507      *
2508      * - `tokenId` must exist.
2509      */
2510     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2511         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2512         address owner = ancientnft.ownerOf(tokenId);
2513         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2514     }
2515 
2516     /**
2517      * @dev Safely mints `tokenId` and transfers it to `to`.
2518      *
2519      * Requirements:
2520      *
2521      * - `tokenId` must not exist.
2522      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2523      *
2524      * Emits a {Transfer} event.
2525      */
2526     function _safeMint(address to, uint256 tokenId) internal virtual {
2527         _safeMint(to, tokenId, "");
2528     }
2529 
2530     /**
2531      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2532      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2533      */
2534     function _safeMint(
2535         address to,
2536         uint256 tokenId,
2537         bytes memory _data
2538     ) internal virtual {
2539         _mint(to, tokenId);
2540         require(
2541             _checkOnERC721Received(address(0), to, tokenId, _data),
2542             "ERC721: transfer to non ERC721Receiver implementer"
2543         );
2544     }
2545 
2546     /**
2547      * @dev Mints `tokenId` and transfers it to `to`.
2548      *
2549      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2550      *
2551      * Requirements:
2552      *
2553      * - `tokenId` must not exist.
2554      * - `to` cannot be the zero address.
2555      *
2556      * Emits a {Transfer} event.
2557      */
2558    function _mint(address to, uint256 tokenId) internal virtual {
2559         require(to != address(0), "ERC721: mint to the zero address");
2560         require(!_exists(tokenId), "ERC721: token already minted");
2561 
2562         _beforeTokenTransfer(address(0), to, tokenId);
2563 
2564         _balances[to] += 1;
2565         _owners[tokenId] = to;
2566         idtostartingtimet[tokenId][to]=block.timestamp;
2567 
2568         // totalSupply+=1;
2569 
2570         emit Transfer(address(0), to, tokenId);
2571 
2572         _afterTokenTransfer(address(0), to, tokenId);
2573     }
2574 
2575     function seterc20address(address add)external {
2576         require(_counter<1, "already called this function");
2577          _erc20= erc20(add);
2578          _counter++;
2579     }
2580 
2581       function walletofNFT(address _owner)
2582         public
2583         view
2584         returns (uint256[] memory)
2585     {
2586         uint256 ownerTokenCount = balanceOf(_owner);
2587         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2588         for (uint256 i; i < ownerTokenCount; i++) {
2589             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2590         }
2591         return tokenIds;
2592     }
2593 
2594 
2595     function checkrewardbal(address add)public view returns(uint){
2596 
2597         uint256 ownerTokenCount = balanceOf(add);
2598            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2599          tokenIds= walletofNFT(add);
2600          
2601           uint current;
2602           uint reward;
2603           uint rewardbal;
2604          for (uint i ;i<ownerTokenCount; i++){
2605              
2606              if (idtostartingtimet[tokenIds[i]][add]>0 ){
2607            current = block.timestamp - idtostartingtimet[tokenIds[i]][add];
2608              reward = ((50*10**18)*current)/86400;
2609             rewardbal+=reward;
2610           
2611            }
2612         }
2613 
2614         return rewardbal;
2615     }
2616 
2617     function claimreward(address add) public {
2618           require(balanceOf(add)>0, "not qualified for reward");
2619          uint256 ownerTokenCount = balanceOf(add);
2620            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2621          tokenIds= walletofNFT(add);
2622          
2623           uint current;
2624           uint reward;
2625           uint rewardbal;
2626          for (uint i ;i<ownerTokenCount; i++){
2627              
2628              if (idtostartingtimet[tokenIds[i]][add]>0 ){
2629            current = block.timestamp - idtostartingtimet[tokenIds[i]][add];
2630              reward = ((50*10**18)*current)/86400;
2631             rewardbal+=reward;
2632           idtostartingtimet[tokenIds[i]][add]=block.timestamp;
2633            }
2634         }
2635 
2636           _erc20.mint(add,rewardbal);
2637 
2638 
2639     }
2640 
2641     /**
2642      * @dev Destroys `tokenId`.
2643      * The approval is cleared when the token is burned.
2644      *
2645      * Requirements:
2646      *
2647      * - `tokenId` must exist.
2648      *
2649      * Emits a {Transfer} event.
2650      */
2651     function _burn(uint256 tokenId) internal virtual {
2652         address owner = ancientnft.ownerOf(tokenId);
2653 
2654         _beforeTokenTransfer(owner, address(0), tokenId);
2655 
2656         // Clear approvals
2657         _approve(address(0), tokenId);
2658 
2659         _balances[owner] -= 1;
2660         delete _owners[tokenId];
2661 
2662         emit Transfer(owner, address(0), tokenId);
2663 
2664         _afterTokenTransfer(owner, address(0), tokenId);
2665     }
2666 
2667     /**
2668      * @dev Transfers `tokenId` from `from` to `to`.
2669      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2670      *
2671      * Requirements:
2672      *
2673      * - `to` cannot be the zero address.
2674      * - `tokenId` token must be owned by `from`.
2675      *
2676      * Emits a {Transfer} event.
2677      */
2678        function _transfer(
2679         address from,
2680         address to,
2681         uint256 tokenId
2682     ) internal virtual {
2683         require(ancientnft.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2684         require(to != address(0), "ERC721: transfer to the zero address");
2685 
2686         _beforeTokenTransfer(from, to, tokenId);
2687 
2688         // Clear approvals from the previous owner
2689         _approve(address(0), tokenId);
2690 
2691         _balances[from] -= 1;
2692         _balances[to] += 1;
2693         _owners[tokenId] = to;
2694         idtostartingtimet[tokenId][to]=block.timestamp;
2695         idtostartingtimet[tokenId][from]=0;
2696         
2697 
2698         emit Transfer(from, to, tokenId);
2699 
2700         _afterTokenTransfer(from, to, tokenId);
2701     }
2702 
2703     /**
2704      * @dev Approve `to` to operate on `tokenId`
2705      *
2706      * Emits a {Approval} event.
2707      */
2708     function _approve(address to, uint256 tokenId) internal virtual {
2709         _tokenApprovals[tokenId] = to;
2710         emit Approval(ancientnft.ownerOf(tokenId), to, tokenId);
2711     }
2712 
2713     /**
2714      * @dev Approve `operator` to operate on all of `owner` tokens
2715      *
2716      * Emits a {ApprovalForAll} event.
2717      */
2718     function _setApprovalForAll(
2719         address owner,
2720         address operator,
2721         bool approved
2722     ) internal virtual {
2723         require(owner != operator, "ERC721: approve to caller");
2724         _operatorApprovals[owner][operator] = approved;
2725         emit ApprovalForAll(owner, operator, approved);
2726     }
2727 
2728     /**
2729      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2730      * The call is not executed if the target address is not a contract.
2731      *
2732      * @param from address representing the previous owner of the given token ID
2733      * @param to target address that will receive the tokens
2734      * @param tokenId uint256 ID of the token to be transferred
2735      * @param _data bytes optional data to send along with the call
2736      * @return bool whether the call correctly returned the expected magic value
2737      */
2738     function _checkOnERC721Received(
2739         address from,
2740         address to,
2741         uint256 tokenId,
2742         bytes memory _data
2743     ) private returns (bool) {
2744         if (to.isContract()) {
2745             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2746                 return retval == IERC721Receiver.onERC721Received.selector;
2747             } catch (bytes memory reason) {
2748                 if (reason.length == 0) {
2749                     revert("ERC721: transfer to non ERC721Receiver implementer");
2750                 } else {
2751                     assembly {
2752                         revert(add(32, reason), mload(reason))
2753                     }
2754                 }
2755             }
2756         } else {
2757             return true;
2758         }
2759     }
2760 
2761     /**
2762      * @dev Hook that is called before any token transfer. This includes minting
2763      * and burning.
2764      *
2765      * Calling conditions:
2766      *
2767      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2768      * transferred to `to`.
2769      * - When `from` is zero, `tokenId` will be minted for `to`.
2770      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2771      * - `from` and `to` are never both zero.
2772      *
2773      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2774      */
2775     // function _beforeTokenTransfer(
2776     //     address from,
2777     //     address to,
2778     //     uint256 tokenId
2779     // ) internal virtual {}
2780 
2781     /**
2782      * @dev Hook that is called after any transfer of tokens. This includes
2783      * minting and burning.
2784      *
2785      * Calling conditions:
2786      *
2787      * - when `from` and `to` are both non-zero.
2788      * - `from` and `to` are never both zero.
2789      *
2790      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2791      */
2792     function _afterTokenTransfer(
2793         address from,
2794         address to,
2795         uint256 tokenId
2796     ) internal virtual {}
2797 }
2798 // File: contracts/NftMigrate.sol
2799 
2800 
2801 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
2802 
2803 pragma solidity ^0.8.0;
2804 
2805 
2806 
2807 
2808 
2809 
2810 
2811 
2812 
2813 
2814 
2815 
2816 
2817 
2818 
2819 
2820 
2821 contract ERC721  is Context, ERC165, IERC721, IERC721Metadata, Ownable, IERC721Enumerable {
2822     using Address for address;
2823     using Strings for uint256;
2824     using Counters for Counters.Counter;
2825 
2826     
2827    
2828 
2829     // Token name
2830     string private _name;
2831 
2832     // Token symbol
2833     string private _symbol;
2834 
2835     // uint public totalSupply;
2836 
2837     Counters.Counter private _tokenIds;
2838     
2839     
2840 
2841     string public baseURI_ = "ipfs://QmZkN9YuR1rrK1YXh1qxJxEotzrZbAfEYwzCHYz2Ln5Ear/";
2842     string public baseExtension = ".json";
2843     uint256 public cost = 0.03 ether;
2844     uint256 public maxSupply = 3333;
2845     uint256 public maxMintAmount = 20;
2846     bool public paused = false;
2847     bool public  _paused ;
2848    
2849      
2850 
2851      // wallet addresses for claims
2852     address private constant Jazzasaurus = 0xd848353706E5a26BAa6DD20265EDDe1e7047d9ba;
2853     address private constant munheezy = 0xB6D2ac64BDc24f76417b95b410ACf47cE31AdD07;
2854     address private constant _community = 0xe44CB360e48dA69fe75a78fD1649ccbd3CCf7AD1;
2855     address private constant _Dragoneer = 0x9817C311F6897D30e372C119a888028baC879d1c;
2856 
2857     mapping(uint => mapping(address => uint)) private idtostartingtimet;
2858 
2859         
2860     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2861 
2862     // Mapping from token ID to index of the owner tokens list
2863     mapping(uint256 => uint256) private _ownedTokensIndex;
2864 
2865     // Array with all token ids, used for enumeration
2866     uint256[] private _allTokens;
2867 
2868     // Mapping from token id to position in the allTokens array
2869     mapping(uint256 => uint256) private _allTokensIndex;
2870 
2871      mapping(address => mapping(uint256 => bool)) private _breeded;
2872 
2873      ERC20 _ERC20;
2874      ancientnft _ancientnft;  
2875      babynft _babynft; 
2876 
2877      IERC20_ iERC20_;
2878      _IERC721 mainERC721;
2879      _IERC721 ancientERC721;
2880      _IERC721 babyERC721;
2881      bool hassetcurrent;   
2882 
2883       
2884 
2885 
2886 
2887 
2888     // Mapping from token ID to owner address
2889     mapping(uint256 => address) private _owners;
2890 
2891     // Mapping owner address to token count
2892     mapping(address => uint256) private _balances;
2893 
2894     // Mapping from token ID to approved address
2895     mapping(uint256 => address) private _tokenApprovals;
2896 
2897     // Mapping from owner to operator approvals
2898     mapping(address => mapping(address => bool)) private _operatorApprovals;
2899 
2900 
2901    
2902     constructor(string memory name_, string memory symbol_,string memory ERC20name_, string memory ERC20symbol_ ,uint ERC20amount,address ERC20owneraddress,string memory ancientnftname_, string memory ancientnftsymbol_,string memory babynftname_, string memory babynftsymbol_) {
2903         _name = name_;
2904         _symbol = symbol_;
2905        uint8[12] memory Ntokenid= [11, 13, 16, 17, 24, 29, 35, 42, 43, 63, 64, 65];   
2906        
2907         
2908         _ERC20= new ERC20(ERC20name_,ERC20symbol_,ERC20amount,ERC20owneraddress) ;
2909         
2910         _ancientnft = new ancientnft(ancientnftname_,ancientnftsymbol_);
2911         _ancientnft.setapprovedcontractaddress(address(this));
2912         _ancientnft.seterc20address(address(_ERC20));
2913         _babynft= new  babynft(babynftname_,babynftsymbol_);
2914         _babynft.setapprovedcontractaddress(address(this));
2915         _babynft.seterc20address(address(_ERC20)); 
2916         _ERC20.setapprovedcontractaddress(address(this),address(_ancientnft),address(_babynft));
2917 
2918          _mint(msg.sender,1);
2919 
2920          for (uint i ;i< Ntokenid.length;i++){
2921              
2922             _ancientnft.mint(msg.sender,Ntokenid[i]); 
2923 
2924           } 
2925 
2926     }
2927 
2928    
2929     /**
2930      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2931      */
2932     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2933         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2934         return _ownedTokens[owner][index];
2935     }
2936 
2937     /**
2938      * @dev See {IERC721Enumerable-totalSupply}.
2939      */
2940     function totalSupply() public view virtual override returns (uint256) {
2941         return _allTokens.length;
2942     }
2943 
2944     /**
2945      * @dev See {IERC721Enumerable-tokenByIndex}.
2946      */
2947     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2948         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
2949         return _allTokens[index];
2950     }
2951 
2952     function pause() public onlyOwner  {
2953         paused = !paused;
2954 
2955      }
2956 
2957       function pausebreedandburn() public onlyOwner  {
2958         _paused = !_paused;
2959 
2960      }
2961 
2962     function checkPause() public view onlyOwner returns(bool) {
2963         return paused; 
2964     }
2965  
2966     function _beforeTokenTransfer(
2967         address from,
2968         address to,
2969         uint256 tokenId
2970     ) internal virtual  {
2971      
2972 
2973         if (from == address(0)) {
2974             _addTokenToAllTokensEnumeration(tokenId);
2975         } else if (from != to) {
2976             _removeTokenFromOwnerEnumeration(from, tokenId);
2977         }
2978         if (to == address(0)) {
2979             _removeTokenFromAllTokensEnumeration(tokenId);
2980         } else if (to != from) {
2981             _addTokenToOwnerEnumeration(to, tokenId);
2982         }
2983     }
2984 
2985    
2986     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2987         uint256 length = ERC721.balanceOf(to);
2988         _ownedTokens[to][length] = tokenId;
2989         _ownedTokensIndex[tokenId] = length;
2990     }
2991 
2992    
2993     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2994         _allTokensIndex[tokenId] = _allTokens.length;
2995         _allTokens.push(tokenId);
2996     }
2997 
2998   
2999     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
3000         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
3001         // then delete the last slot (swap and pop).
3002 
3003         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
3004         uint256 tokenIndex = _ownedTokensIndex[tokenId];
3005 
3006         // When the token to delete is the last token, the swap operation is unnecessary
3007         if (tokenIndex != lastTokenIndex) {
3008             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
3009 
3010             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3011             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3012         }
3013 
3014         // This also deletes the contents at the last position of the array
3015         delete _ownedTokensIndex[tokenId];
3016         delete _ownedTokens[from][lastTokenIndex];
3017     }
3018 
3019    
3020     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
3021         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
3022         // then delete the last slot (swap and pop).
3023 
3024         uint256 lastTokenIndex = _allTokens.length - 1;
3025         uint256 tokenIndex = _allTokensIndex[tokenId];
3026 
3027         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
3028         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
3029         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
3030         uint256 lastTokenId = _allTokens[lastTokenIndex];
3031 
3032         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3033         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3034 
3035         // This also deletes the contents at the last position of the array
3036         delete _allTokensIndex[tokenId];
3037         _allTokens.pop();
3038     }
3039 
3040   
3041     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
3042         return
3043             interfaceId == type(IERC721).interfaceId ||
3044             interfaceId == type(IERC721Metadata).interfaceId ||
3045             super.supportsInterface(interfaceId);
3046     }
3047 
3048   
3049     function balanceOf(address owner) public view virtual override returns (uint256) {
3050         require(owner != address(0), "ERC721: balance query for the zero address");
3051         return _balances[owner];
3052     }
3053 
3054 
3055     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
3056         address owner = _owners[tokenId];
3057         require(owner != address(0), "ERC721: owner query for nonexistent token");
3058         return owner;
3059     }
3060 
3061    
3062     function name() public view virtual override returns (string memory) {
3063         return _name;
3064     }
3065 
3066    
3067     function symbol() public view virtual override returns (string memory) {
3068         return _symbol;
3069     }
3070 
3071     /**
3072      * @dev See {IERC721Metadata-tokenURI}.
3073      */
3074     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3075         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
3076 
3077         string memory baseURI = _baseURI();
3078         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
3079     }
3080 
3081   
3082     function _baseURI() internal view virtual returns (string memory) {
3083         return baseURI_;
3084     }
3085 
3086    
3087     function approve(address to, uint256 tokenId) public virtual override {
3088         address owner = ERC721.ownerOf(tokenId);
3089         require(to != owner, "ERC721: approval to current owner");
3090 
3091         require(
3092             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3093             "ERC721: approve caller is not owner nor approved for all"
3094         );
3095 
3096         _approve(to, tokenId);
3097     }
3098 
3099    
3100     function getApproved(uint256 tokenId) public view virtual override returns (address) {
3101         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
3102 
3103         return _tokenApprovals[tokenId];
3104     }
3105 
3106   
3107     function setApprovalForAll(address operator, bool approved) public virtual override {
3108         _setApprovalForAll(_msgSender(), operator, approved);
3109     }
3110 
3111 
3112     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
3113         return _operatorApprovals[owner][operator];
3114     }
3115 
3116   
3117     function transferFrom(
3118         address from,
3119         address to,
3120         uint256 tokenId
3121     ) public virtual override {
3122         //solhint-disable-next-line max-line-length
3123         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
3124         require(paused == false);
3125 
3126         _transfer(from, to, tokenId);
3127     }
3128 
3129    
3130     function safeTransferFrom(
3131         address from,
3132         address to,
3133         uint256 tokenId
3134     ) public virtual override {
3135         safeTransferFrom(from, to, tokenId, "");
3136     }
3137 
3138     function safeTransferFrom(
3139         address from,
3140         address to,
3141         uint256 tokenId,
3142         bytes memory _data
3143     ) public virtual override {
3144         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
3145         _safeTransfer(from, to, tokenId, _data);
3146     }
3147 
3148    
3149     function _safeTransfer(
3150         address from,
3151         address to,
3152         uint256 tokenId,
3153         bytes memory _data
3154     ) internal virtual {
3155         _transfer(from, to, tokenId);
3156         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
3157     }
3158 
3159     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3160         return _owners[tokenId] != address(0);
3161     }
3162 
3163 
3164     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
3165         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
3166         address owner = ERC721.ownerOf(tokenId);
3167         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
3168     }
3169 
3170    
3171     function _safeMint(address to, uint256 tokenId) internal virtual {
3172         _safeMint(to, tokenId, "");
3173     }
3174 
3175     
3176     function _safeMint(
3177         address to,
3178         uint256 tokenId,
3179         bytes memory _data
3180     ) internal virtual {
3181         _mint(to, tokenId);
3182         require(
3183             _checkOnERC721Received(address(0), to, tokenId, _data),
3184             "ERC721: transfer to non ERC721Receiver implementer"
3185         );
3186     }
3187 
3188 
3189     function _mint(address to, uint256 tokenId) internal virtual {
3190         require(to != address(0), "ERC721: mint to the zero address");
3191         require(!_exists(tokenId), "ERC721: token already minted");
3192 
3193         _beforeTokenTransfer(address(0), to, tokenId);
3194 
3195         _balances[to] += 1;
3196         _owners[tokenId] = to;
3197         idtostartingtimet[tokenId][to]=block.timestamp;
3198 
3199         // totalSupply+=1;
3200 
3201         emit Transfer(address(0), to, tokenId);
3202 
3203         _afterTokenTransfer(address(0), to, tokenId);
3204     }
3205 
3206   
3207 
3208     function _burn(uint256 tokenId) internal virtual {
3209         address owner = ERC721.ownerOf(tokenId);
3210 
3211         _beforeTokenTransfer(owner, address(0), tokenId);
3212 
3213         // Clear approvals
3214         _approve(address(0), tokenId);
3215 
3216         _balances[owner] -= 1;
3217         delete _owners[tokenId];
3218         
3219 
3220         // totalSupply-=1;
3221 
3222         emit Transfer(owner, address(0), tokenId);
3223 
3224         _afterTokenTransfer(owner, address(0), tokenId);
3225     }
3226      
3227      function mint(
3228         address _to,
3229         uint256 _mintAmount
3230         
3231     ) public payable {
3232         // get total NFT token supply
3233       
3234         require(_mintAmount > 0);
3235         require(_mintAmount <= maxMintAmount);
3236         require( totalSupply() + _mintAmount <= maxSupply);
3237         require(paused == false);
3238         require (hassetcurrent==true,"please set setcurrentmintedamount ");
3239             
3240         
3241         require(msg.value >= cost * _mintAmount);
3242             
3243         
3244 
3245     
3246 
3247         // execute mint
3248        if (_tokenIds.current()==0){
3249             _tokenIds.increment();
3250        }
3251         
3252         for (uint256 i = 1; i <= _mintAmount; i++) {
3253             uint256 newTokenID = _tokenIds.current();
3254             _safeMint(_to, newTokenID);
3255             _tokenIds.increment();
3256         }
3257     }
3258 
3259     function setcurrentmintedamount(uint totalmintedamount )public onlyOwner{
3260            hassetcurrent=true;
3261             if (_tokenIds.current()==0){
3262             _tokenIds.increment();
3263        }
3264 
3265        for (uint256 i = 1; i <=totalmintedamount; i++) {
3266           
3267             _tokenIds.increment();
3268          
3269         }
3270     }
3271 
3272     function checkdragonnotbreeded(address add)public view returns(uint[] memory){
3273 
3274         uint256 ownerTokenCount = balanceOf(add);
3275            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3276          tokenIds= walletofNFT(add);  
3277          
3278          
3279           uint count;
3280          for (uint i ;i<ownerTokenCount; i++){
3281              if (_breeded[address(this)][tokenIds[i]]==false){
3282                 count++;   
3283              }
3284             
3285           
3286            }
3287           uint256[] memory notbreededbrtokenIds = new uint256[](count);
3288           uint _count;
3289             for (uint i ;i<ownerTokenCount; i++){
3290              if (_breeded[address(this)][tokenIds[i]]==false){
3291                    notbreededbrtokenIds[_count]=tokenIds[i];
3292                    _count++;
3293              }
3294             
3295           
3296            }
3297 
3298            return notbreededbrtokenIds;
3299         }
3300     
3301     
3302 
3303    
3304     function breed(uint id1,uint id2) public  {
3305         uint amount=1800*10**18;
3306         require(balanceOf(msg.sender)>=2, "Must Own 2 0xDragons");
3307         require (_ERC20.balanceOf(msg.sender) >= amount,"You Dont Have The $SCALE For That!");
3308         require (ownerOf(id1)==msg.sender,"NOT YOUR DRAGON");
3309         require (ownerOf(id2)==msg.sender,"NOT YOUR DRAGON");
3310         require( _paused == false);
3311         _ERC20.burn(msg.sender, amount);
3312 
3313        
3314          _breeded[address(this)][id1]=true;
3315            _breeded[address(this)][id2]=true;
3316             
3317 
3318         _babynft.mint(msg.sender);  
3319     }
3320 
3321     
3322     function burn(uint id1, uint id2, uint id3 ) public  {
3323     uint amount=1500*10**18;
3324     require(balanceOf(msg.sender)>=3, "Must Have 3 UNBRED Dragons");
3325     require (_ERC20.balanceOf(msg.sender) >= amount,"You Dont Have The $SCALE For That!");
3326     require (ownerOf(id1)==msg.sender,"NOT YOUR DRAGON");
3327     require (ownerOf(id2)==msg.sender,"NOT YOUR DRAGON");
3328     require (ownerOf(id3)==msg.sender,"NOT YOUR DRAGON"); 
3329     require( _breeded[address(this)][id1]==false ,"Bred Dragons CAN'T Be Sacrificed");
3330     require( _breeded[address(this)][id2]==false ,"Bred Dragons CAN'T Be Sacrificed"); 
3331     require( _breeded[address(this)][id3]==false ,"Bred Dragons CAN'T Be Sacrificed");
3332     require( _paused == false);
3333     _ERC20.burn(msg.sender, amount);
3334 
3335   _transfer(
3336       msg.sender,
3337       0x000000000000000000000000000000000000dEaD,
3338       id1
3339 );
3340 _transfer(
3341       msg.sender,
3342       0x000000000000000000000000000000000000dEaD,
3343       id2
3344 );
3345 _transfer(
3346       msg.sender,
3347       0x000000000000000000000000000000000000dEaD,
3348       id3
3349 );   
3350          
3351       _ancientnft.mint(msg.sender);   
3352         
3353         
3354      }
3355 
3356    function setpreviouscontaddress(address erc20add,address mainnftadd ,address ancientadd, address babyadd )public onlyOwner{
3357        
3358      iERC20_=IERC20_(erc20add) ;
3359      mainERC721 =  _IERC721(mainnftadd);
3360      ancientERC721= _IERC721(ancientadd);
3361      babyERC721=_IERC721(babyadd);
3362 
3363 
3364 
3365    }
3366 
3367 
3368    function setmaxsupplyforbabynft(uint amount)public onlyOwner{
3369         _babynft.setmaxsupply(amount);
3370 
3371    }
3372 
3373    function setbaseuriforbabynft(string memory _newBaseURI) public onlyOwner{
3374        _babynft.setBaseURI(_newBaseURI);
3375    }
3376 
3377    
3378    function setcurrentmintnumberforbabynft(uint amount) public onlyOwner{
3379        _babynft.setcurrentmintedamount(amount );   
3380    }
3381 
3382    
3383    function setbaseuriforancientnft(string memory _newBaseURI) public onlyOwner{
3384        _ancientnft.setBaseURI(_newBaseURI);
3385    }
3386 
3387     function setcurrentmintnumberforancient(uint amount) public onlyOwner{
3388         _ancientnft.setcurrentmintedamount(amount ); 
3389    }
3390 
3391 
3392     function setCost(uint256 _newCost) public onlyOwner {
3393         cost = _newCost;
3394     }
3395 
3396     // set or update max number of mint per mint call
3397     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
3398         maxMintAmount = _newmaxMintAmount;
3399     }
3400 
3401    
3402 
3403     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3404         baseURI_ = _newBaseURI;
3405     }
3406 
3407     // set metadata base extention
3408     function setBaseExtension(string memory _newBaseExtension)public onlyOwner    {
3409         baseExtension = _newBaseExtension;    }
3410 
3411 
3412     
3413 
3414     function claim() public onlyOwner {
3415         // get contract total balance
3416         uint256 balance = address(this).balance;
3417         // begin withdraw based on address percentage
3418 
3419        
3420         payable(Jazzasaurus).transfer((balance / 100) * 45);
3421         
3422         payable(munheezy).transfer((balance / 100) * 31);
3423       
3424         payable(_community).transfer((balance / 100) * 20);
3425         payable(_Dragoneer).transfer((balance / 100) * 4);
3426     }
3427 
3428       function walletofNFT(address _owner)
3429         public
3430         view
3431         returns (uint256[] memory)
3432     {
3433         uint256 ownerTokenCount = balanceOf(_owner);
3434         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3435         for (uint256 i; i < ownerTokenCount; i++) {
3436             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
3437         }
3438         return tokenIds;
3439     }
3440 
3441     function checkrewardbal()public view returns(uint){
3442 
3443         uint256 ownerTokenCount = balanceOf(msg.sender);
3444            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3445          tokenIds= walletofNFT(msg.sender);
3446          
3447           uint current;
3448           uint reward;
3449           uint rewardbal;
3450          for (uint i ;i<ownerTokenCount; i++){
3451              
3452              if (idtostartingtimet[tokenIds[i]][msg.sender]>0 ){
3453            current = block.timestamp - idtostartingtimet[tokenIds[i]][msg.sender];
3454              reward = ((10*10**18)*current)/86400;
3455             rewardbal+=reward;
3456           
3457            }
3458         }
3459 
3460         return rewardbal;
3461     }
3462 
3463     function checkrewardforancientbal()public view returns(uint){
3464       return _ancientnft.checkrewardbal(msg.sender);
3465     }
3466 
3467     function checkrewardforbabybal()public view returns(uint){
3468       return _babynft.checkrewardbal(msg.sender);
3469     }
3470 
3471     function claimreward() public {
3472           require(balanceOf(msg.sender)>0, "Not Qualified For Reward");
3473          uint256 ownerTokenCount = balanceOf(msg.sender);
3474            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3475          tokenIds= walletofNFT(msg.sender);
3476          
3477           uint current;
3478           uint reward;
3479           uint rewardbal;
3480          for (uint i ;i<ownerTokenCount; i++){
3481              
3482              if (idtostartingtimet[tokenIds[i]][msg.sender]>0 ){
3483            current = block.timestamp - idtostartingtimet[tokenIds[i]][msg.sender];
3484              reward = ((10*10**18)*current)/86400;
3485             rewardbal+=reward;
3486           idtostartingtimet[tokenIds[i]][msg.sender]=block.timestamp;
3487            }
3488         }
3489 
3490          _ERC20.mint(msg.sender,rewardbal);
3491      if (_ancientnft.balanceOf(msg.sender)>0){
3492         _ancientnft.claimreward(msg.sender);
3493 
3494         }
3495     if (_babynft.balanceOf(msg.sender)>0){
3496         _babynft.claimreward(msg.sender);
3497         }
3498 
3499 
3500     }
3501 
3502 
3503         
3504     
3505 
3506     function migrate()public   {
3507           uint[] memory _tokenId= mainERC721.walletofNFT(msg.sender);  
3508           for (uint i ;i< _tokenId.length;i++){
3509               require(msg.sender==mainERC721.ownerOf(_tokenId[i]));
3510 
3511             mainERC721.transferFrom(msg.sender,0x000000000000000000000000000000000000dEaD,_tokenId[i]);  
3512             _mint(msg.sender,_tokenId[i] );
3513           } 
3514           
3515            uint[] memory _tokenId1=  ancientERC721.walletofNFT(msg.sender);   
3516           for (uint i ;i< _tokenId1.length;i++){
3517               require(msg.sender== ancientERC721.ownerOf(_tokenId1[i]));
3518                ancientERC721.transferFrom(msg.sender,0x000000000000000000000000000000000000dEaD,_tokenId1[i]);
3519                _ancientnft.mint(msg.sender,_tokenId1[i] ); 
3520 
3521           } 
3522 
3523            uint[] memory _tokenId2= babyERC721.walletofNFT(msg.sender);   
3524           for (uint i ;i< _tokenId2.length;i++){
3525               require(msg.sender==babyERC721.ownerOf(_tokenId2[i]));
3526               babyERC721.transferFrom(msg.sender,0x000000000000000000000000000000000000dEaD,_tokenId2[i]);
3527               _babynft.mint(msg.sender,_tokenId2[i] ); 
3528           }   
3529  
3530           uint amount= iERC20_.balanceOf(msg.sender);
3531           uint mainnftamount= mainERC721.checkrewardbal();
3532           uint ancientnftamount= ancientERC721.checkrewardbal(msg.sender);
3533           uint babynftamount= babyERC721.checkrewardbal(msg.sender);
3534           uint totalamount=amount+ mainnftamount + ancientnftamount + babynftamount;
3535           iERC20_.transferFrom(msg.sender,0x000000000000000000000000000000000000dEaD, amount);
3536           _ERC20.mint(msg.sender,totalamount);
3537         
3538     } 
3539 
3540    
3541 
3542      function migrate2(uint[] memory main,uint[] memory ancient,uint[] memory baby)public   {
3543           uint[] memory _tokenId=  main;    
3544           for (uint i ;i< _tokenId.length;i++){
3545               require(msg.sender==mainERC721.ownerOf(_tokenId[i]));
3546               mainERC721.transferFrom(msg.sender,0x000000000000000000000000000000000000dEaD,_tokenId[i]); 
3547               _mint(msg.sender,_tokenId[i] ); 
3548           } 
3549            uint[] memory _tokenId1=  ancient;  
3550           for (uint i ;i< _tokenId1.length;i++){
3551               require(msg.sender== ancientERC721.ownerOf(_tokenId1[i]));
3552                ancientERC721.transferFrom(msg.sender,0x000000000000000000000000000000000000dEaD,_tokenId1[i]);
3553                _ancientnft.mint(msg.sender,_tokenId1[i] ); 
3554 
3555           } 
3556 
3557            uint[] memory _tokenId2= baby;    
3558           for (uint i ;i< _tokenId2.length;i++){
3559               require(msg.sender==babyERC721.ownerOf(_tokenId2[i]));
3560               babyERC721.transferFrom(msg.sender,0x000000000000000000000000000000000000dEaD,_tokenId2[i]);
3561               _babynft.mint(msg.sender,_tokenId2[i] ); 
3562           }   
3563  
3564           uint amount= iERC20_.balanceOf(msg.sender);
3565         //   uint mainnftamount= mainERC721.checkrewardbal();
3566           uint ancientnftamount= ancientERC721.checkrewardbal(msg.sender);
3567           uint babynftamount= babyERC721.checkrewardbal(msg.sender);
3568           uint totalamount=amount + ancientnftamount + babynftamount; 
3569           iERC20_.transferFrom(msg.sender,0x000000000000000000000000000000000000dEaD, amount);
3570           _ERC20.mint(msg.sender,totalamount);
3571         
3572     } 
3573 
3574 
3575      function checkerc20address()public view returns(address) {
3576 
3577      return  (address(_ERC20)); //  this is the deployed address of erc20token
3578      
3579  }
3580 
3581     
3582      function checkancientnftaddress()public view returns(address) {
3583 
3584      return  (address(_ancientnft)); //  this is the deployed address of ancienttoken
3585      
3586     }
3587 
3588     
3589      function checkbabynftaddress()public view returns(address) {
3590 
3591      return  (address(_babynft)); //  this is the deployed address of babytoken
3592      
3593  }
3594 
3595     function itemOne(uint256  _passedPrice) public  {
3596     uint amount=_passedPrice*10**18;
3597     require (_ERC20.balanceOf(msg.sender) >= amount,"You Dont Have The $SCALE For That!");
3598     _ERC20.burn(msg.sender, amount);
3599 }
3600 
3601 
3602 
3603     function _transfer(
3604         address from,
3605         address to,
3606         uint256 tokenId
3607     ) internal virtual {
3608         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3609         require(to != address(0), "ERC721: transfer to the zero address");
3610 
3611         _beforeTokenTransfer(from, to, tokenId);
3612 
3613         // Clear approvals from the previous owner
3614         _approve(address(0), tokenId);
3615 
3616         _balances[from] -= 1;
3617         _balances[to] += 1;
3618         _owners[tokenId] = to;
3619         idtostartingtimet[tokenId][to]=block.timestamp;
3620         idtostartingtimet[tokenId][from]=0;
3621         
3622 
3623         emit Transfer(from, to, tokenId);
3624 
3625         _afterTokenTransfer(from, to, tokenId);
3626     }
3627 
3628    
3629     function _approve(address to, uint256 tokenId) internal virtual {
3630         _tokenApprovals[tokenId] = to;
3631         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3632     }
3633 
3634   
3635     function _setApprovalForAll(
3636         address owner,
3637         address operator,
3638         bool approved
3639     ) internal virtual {
3640         require(owner != operator, "ERC721: approve to caller");
3641         _operatorApprovals[owner][operator] = approved;
3642         emit ApprovalForAll(owner, operator, approved);
3643     }
3644 
3645     function _checkOnERC721Received(
3646         address from,
3647         address to,
3648         uint256 tokenId,
3649         bytes memory _data
3650     ) private returns (bool) {
3651         if (to.isContract()) {
3652             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
3653                 return retval == IERC721Receiver.onERC721Received.selector;
3654             } catch (bytes memory reason) {
3655                 if (reason.length == 0) {
3656                     revert("ERC721: transfer to non ERC721Receiver implementer");
3657                 } else {
3658                     assembly {
3659                         revert(add(32, reason), mload(reason))
3660                     }
3661                 }
3662             }
3663         } else {
3664             return true;
3665         }
3666     }
3667 
3668 function ownerMint(address _to, uint256 _mintAmount) public onlyOwner {
3669         // get total NFT token supply
3670       
3671         require(_mintAmount > 0);
3672         require(_mintAmount <= maxMintAmount);
3673         require( totalSupply() + _mintAmount <= maxSupply);
3674         // execute mint
3675        if (_tokenIds.current()==0){
3676             _tokenIds.increment();
3677        }
3678         
3679         for (uint256 i = 1; i <= _mintAmount; i++) {
3680             uint256 newTokenID = _tokenIds.current();
3681             _safeMint(_to, newTokenID);
3682             _tokenIds.increment();
3683         }
3684     }
3685 
3686   
3687     function _afterTokenTransfer(
3688         address from,
3689         address to,
3690         uint256 tokenId
3691     ) internal virtual {}
3692 }