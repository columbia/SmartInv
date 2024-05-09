1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: @openzeppelin/contracts/math/SafeMath.sol
107 
108 pragma solidity >=0.6.0 <0.8.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
267 
268 pragma solidity >=0.6.0 <0.8.0;
269 
270 
271 
272 
273 /**
274  * @dev Implementation of the {IERC20} interface.
275  *
276  * This implementation is agnostic to the way tokens are created. This means
277  * that a supply mechanism has to be added in a derived contract using {_mint}.
278  * For a generic mechanism see {ERC20PresetMinterPauser}.
279  *
280  * TIP: For a detailed writeup see our guide
281  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
282  * to implement supply mechanisms].
283  *
284  * We have followed general OpenZeppelin guidelines: functions revert instead
285  * of returning `false` on failure. This behavior is nonetheless conventional
286  * and does not conflict with the expectations of ERC20 applications.
287  *
288  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
289  * This allows applications to reconstruct the allowance for all accounts just
290  * by listening to said events. Other implementations of the EIP may not emit
291  * these events, as it isn't required by the specification.
292  *
293  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
294  * functions have been added to mitigate the well-known issues around setting
295  * allowances. See {IERC20-approve}.
296  */
297 contract ERC20 is Context, IERC20 {
298     using SafeMath for uint256;
299 
300     mapping (address => uint256) private _balances;
301 
302     mapping (address => mapping (address => uint256)) private _allowances;
303 
304     uint256 private _totalSupply;
305 
306     string private _name;
307     string private _symbol;
308     uint8 private _decimals;
309 
310     /**
311      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
312      * a default value of 18.
313      *
314      * To select a different value for {decimals}, use {_setupDecimals}.
315      *
316      * All three of these values are immutable: they can only be set once during
317      * construction.
318      */
319     constructor (string memory name_, string memory symbol_) public {
320         _name = name_;
321         _symbol = symbol_;
322         _decimals = 18;
323     }
324 
325     /**
326      * @dev Returns the name of the token.
327      */
328     function name() public view returns (string memory) {
329         return _name;
330     }
331 
332     /**
333      * @dev Returns the symbol of the token, usually a shorter version of the
334      * name.
335      */
336     function symbol() public view returns (string memory) {
337         return _symbol;
338     }
339 
340     /**
341      * @dev Returns the number of decimals used to get its user representation.
342      * For example, if `decimals` equals `2`, a balance of `505` tokens should
343      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
344      *
345      * Tokens usually opt for a value of 18, imitating the relationship between
346      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
347      * called.
348      *
349      * NOTE: This information is only used for _display_ purposes: it in
350      * no way affects any of the arithmetic of the contract, including
351      * {IERC20-balanceOf} and {IERC20-transfer}.
352      */
353     function decimals() public view returns (uint8) {
354         return _decimals;
355     }
356 
357     /**
358      * @dev See {IERC20-totalSupply}.
359      */
360     function totalSupply() public view override returns (uint256) {
361         return _totalSupply;
362     }
363 
364     /**
365      * @dev See {IERC20-balanceOf}.
366      */
367     function balanceOf(address account) public view override returns (uint256) {
368         return _balances[account];
369     }
370 
371     /**
372      * @dev See {IERC20-transfer}.
373      *
374      * Requirements:
375      *
376      * - `recipient` cannot be the zero address.
377      * - the caller must have a balance of at least `amount`.
378      */
379     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
380         _transfer(_msgSender(), recipient, amount);
381         return true;
382     }
383 
384     /**
385      * @dev See {IERC20-allowance}.
386      */
387     function allowance(address owner, address spender) public view virtual override returns (uint256) {
388         return _allowances[owner][spender];
389     }
390 
391     /**
392      * @dev See {IERC20-approve}.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      */
398     function approve(address spender, uint256 amount) public virtual override returns (bool) {
399         _approve(_msgSender(), spender, amount);
400         return true;
401     }
402 
403     /**
404      * @dev See {IERC20-transferFrom}.
405      *
406      * Emits an {Approval} event indicating the updated allowance. This is not
407      * required by the EIP. See the note at the beginning of {ERC20}.
408      *
409      * Requirements:
410      *
411      * - `sender` and `recipient` cannot be the zero address.
412      * - `sender` must have a balance of at least `amount`.
413      * - the caller must have allowance for ``sender``'s tokens of at least
414      * `amount`.
415      */
416     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
417         _transfer(sender, recipient, amount);
418         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
419         return true;
420     }
421 
422     /**
423      * @dev Atomically increases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      */
434     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
435         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
436         return true;
437     }
438 
439     /**
440      * @dev Atomically decreases the allowance granted to `spender` by the caller.
441      *
442      * This is an alternative to {approve} that can be used as a mitigation for
443      * problems described in {IERC20-approve}.
444      *
445      * Emits an {Approval} event indicating the updated allowance.
446      *
447      * Requirements:
448      *
449      * - `spender` cannot be the zero address.
450      * - `spender` must have allowance for the caller of at least
451      * `subtractedValue`.
452      */
453     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
454         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
455         return true;
456     }
457 
458     /**
459      * @dev Moves tokens `amount` from `sender` to `recipient`.
460      *
461      * This is internal function is equivalent to {transfer}, and can be used to
462      * e.g. implement automatic token fees, slashing mechanisms, etc.
463      *
464      * Emits a {Transfer} event.
465      *
466      * Requirements:
467      *
468      * - `sender` cannot be the zero address.
469      * - `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      */
472     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
473         require(sender != address(0), "ERC20: transfer from the zero address");
474         require(recipient != address(0), "ERC20: transfer to the zero address");
475 
476         _beforeTokenTransfer(sender, recipient, amount);
477 
478         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
479         _balances[recipient] = _balances[recipient].add(amount);
480         emit Transfer(sender, recipient, amount);
481     }
482 
483     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
484      * the total supply.
485      *
486      * Emits a {Transfer} event with `from` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `to` cannot be the zero address.
491      */
492     function _mint(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: mint to the zero address");
494 
495         _beforeTokenTransfer(address(0), account, amount);
496 
497         _totalSupply = _totalSupply.add(amount);
498         _balances[account] = _balances[account].add(amount);
499         emit Transfer(address(0), account, amount);
500     }
501 
502     /**
503      * @dev Destroys `amount` tokens from `account`, reducing the
504      * total supply.
505      *
506      * Emits a {Transfer} event with `to` set to the zero address.
507      *
508      * Requirements:
509      *
510      * - `account` cannot be the zero address.
511      * - `account` must have at least `amount` tokens.
512      */
513     function _burn(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: burn from the zero address");
515 
516         _beforeTokenTransfer(account, address(0), amount);
517 
518         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
519         _totalSupply = _totalSupply.sub(amount);
520         emit Transfer(account, address(0), amount);
521     }
522 
523     /**
524      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
525      *
526      * This internal function is equivalent to `approve`, and can be used to
527      * e.g. set automatic allowances for certain subsystems, etc.
528      *
529      * Emits an {Approval} event.
530      *
531      * Requirements:
532      *
533      * - `owner` cannot be the zero address.
534      * - `spender` cannot be the zero address.
535      */
536     function _approve(address owner, address spender, uint256 amount) internal virtual {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     /**
545      * @dev Sets {decimals} to a value other than the default one of 18.
546      *
547      * WARNING: This function should only be called from the constructor. Most
548      * applications that interact with token contracts will not expect
549      * {decimals} to ever change, and may work incorrectly if it does.
550      */
551     function _setupDecimals(uint8 decimals_) internal {
552         _decimals = decimals_;
553     }
554 
555     /**
556      * @dev Hook that is called before any transfer of tokens. This includes
557      * minting and burning.
558      *
559      * Calling conditions:
560      *
561      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
562      * will be to transferred to `to`.
563      * - when `from` is zero, `amount` tokens will be minted for `to`.
564      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
565      * - `from` and `to` are never both zero.
566      *
567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
568      */
569     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
570 }
571 
572 // File: contracts/erc20permit/IERC20Permit.sol
573 
574 pragma solidity =0.7.4;
575 
576 /**
577  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
578  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
579  *
580  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
581  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
582  * need to send a transaction, and thus is not required to hold Ether at all.
583  */
584 interface IERC20Permit {
585   /**
586    * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
587    * given `owner`'s signed approval.
588    *
589    * IMPORTANT: The same issues {IERC20-approve} has related to transaction
590    * ordering also apply here.
591    *
592    * Emits an {Approval} event.
593    *
594    * Requirements:
595    *
596    * - `spender` cannot be the zero address.
597    * - `deadline` must be a timestamp in the future.
598    * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
599    * over the EIP712-formatted function arguments.
600    * - the signature must use ``owner``'s current nonce (see {nonces}).
601    *
602    * For more information on the signature format, see the
603    * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
604    * section].
605    */
606   function permit(
607     address owner,
608     address spender,
609     uint256 value,
610     uint256 deadline,
611     uint8 v,
612     bytes32 r,
613     bytes32 s
614   ) external;
615 
616   /**
617    * @dev Returns the current nonce for `owner`. This value must be
618    * included whenever a signature is generated for {permit}.
619    *
620    * Every successful call to {permit} increases ``owner``'s nonce by one. This
621    * prevents a signature from being used multiple times.
622    */
623   function nonces(address owner) external view returns (uint256);
624 
625   /**
626    * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
627    */
628   // solhint-disable-next-line func-name-mixedcase
629   function DOMAIN_SEPARATOR() external view returns (bytes32);
630 }
631 
632 // File: @openzeppelin/contracts/utils/Counters.sol
633 
634 pragma solidity >=0.6.0 <0.8.0;
635 
636 
637 /**
638  * @title Counters
639  * @author Matt Condon (@shrugs)
640  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
641  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
642  *
643  * Include with `using Counters for Counters.Counter;`
644  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
645  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
646  * directly accessed.
647  */
648 library Counters {
649     using SafeMath for uint256;
650 
651     struct Counter {
652         // This variable should never be directly accessed by users of the library: interactions must be restricted to
653         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
654         // this feature: see https://github.com/ethereum/solidity/issues/4637
655         uint256 _value; // default: 0
656     }
657 
658     function current(Counter storage counter) internal view returns (uint256) {
659         return counter._value;
660     }
661 
662     function increment(Counter storage counter) internal {
663         // The {SafeMath} overflow check can be skipped here, see the comment at the top
664         counter._value += 1;
665     }
666 
667     function decrement(Counter storage counter) internal {
668         counter._value = counter._value.sub(1);
669     }
670 }
671 
672 // File: contracts/erc20permit/EIP712.sol
673 
674 pragma solidity =0.7.4;
675 
676 /**
677  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
678  *
679  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
680  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
681  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
682  *
683  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
684  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
685  * ({_hashTypedDataV4}).
686  *
687  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
688  * the chain id to protect against replay attacks on an eventual fork of the chain.
689  *
690  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
691  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
692  */
693 abstract contract EIP712 {
694   /* solhint-disable var-name-mixedcase */
695   // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
696   // invalidate the cached domain separator if the chain id changes.
697   bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
698   uint256 private immutable _CACHED_CHAIN_ID;
699 
700   bytes32 private immutable _HASHED_NAME;
701   bytes32 private immutable _HASHED_VERSION;
702   bytes32 private immutable _TYPE_HASH;
703 
704   /* solhint-enable var-name-mixedcase */
705 
706   /**
707    * @dev Initializes the domain separator and parameter caches.
708    *
709    * The meaning of `name` and `version` is specified in
710    * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
711    *
712    * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
713    * - `version`: the current major version of the signing domain.
714    *
715    * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
716    * contract upgrade].
717    */
718   constructor(string memory name, string memory version) internal {
719     bytes32 hashedName = keccak256(bytes(name));
720     bytes32 hashedVersion = keccak256(bytes(version));
721     bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
722     _HASHED_NAME = hashedName;
723     _HASHED_VERSION = hashedVersion;
724     _CACHED_CHAIN_ID = _getChainId();
725     _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
726     _TYPE_HASH = typeHash;
727   }
728 
729   /**
730    * @dev Returns the domain separator for the current chain.
731    */
732   function _domainSeparatorV4() internal view returns (bytes32) {
733     if (_getChainId() == _CACHED_CHAIN_ID) {
734       return _CACHED_DOMAIN_SEPARATOR;
735     } else {
736       return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
737     }
738   }
739 
740   function _buildDomainSeparator(
741     bytes32 typeHash,
742     bytes32 name,
743     bytes32 version
744   ) private view returns (bytes32) {
745     return keccak256(abi.encode(typeHash, name, version, _getChainId(), address(this)));
746   }
747 
748   /**
749    * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
750    * function returns the hash of the fully encoded EIP712 message for this domain.
751    *
752    * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
753    *
754    * ```solidity
755    * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
756    *     keccak256("Mail(address to,string contents)"),
757    *     mailTo,
758    *     keccak256(bytes(mailContents))
759    * )));
760    * address signer = ECDSA.recover(digest, signature);
761    * ```
762    */
763   function _hashTypedDataV4(bytes32 structHash) internal view returns (bytes32) {
764     return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
765   }
766 
767   function _getChainId() private view returns (uint256 chainId) {
768     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
769     // solhint-disable-next-line no-inline-assembly
770     assembly {
771       chainId := chainid()
772     }
773   }
774 }
775 
776 // File: contracts/erc20permit/ERC20Permit.sol
777 
778 pragma solidity =0.7.4;
779 
780 
781 
782 
783 
784 /**
785  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
786  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
787  *
788  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
789  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
790  * need to send a transaction, and thus is not required to hold Ether at all.
791  */
792 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
793   using Counters for Counters.Counter;
794 
795   mapping(address => Counters.Counter) private _nonces;
796 
797   // solhint-disable-next-line var-name-mixedcase
798   bytes32 private immutable _PERMIT_TYPEHASH =
799     keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
800 
801   /**
802    * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
803    *
804    * It's a good idea to use the same `name` that is defined as the ERC20 token name.
805    */
806   constructor(string memory name) internal EIP712(name, "1") {}
807 
808   /**
809    * @dev See {IERC20Permit-permit}.
810    */
811   function permit(
812     address owner,
813     address spender,
814     uint256 value,
815     uint256 deadline,
816     uint8 v,
817     bytes32 r,
818     bytes32 s
819   ) public virtual override {
820     // solhint-disable-next-line not-rely-on-time
821     require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
822 
823     bytes32 structHash =
824       keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _nonces[owner].current(), deadline));
825 
826     bytes32 hash = _hashTypedDataV4(structHash);
827 
828     address signer = recover(hash, v, r, s);
829     require(signer == owner, "ERC20Permit: invalid signature");
830 
831     _nonces[owner].increment();
832     _approve(owner, spender, value);
833   }
834 
835   /**
836    * @dev See {IERC20Permit-nonces}.
837    */
838   function nonces(address owner) public view override returns (uint256) {
839     return _nonces[owner].current();
840   }
841 
842   /**
843    * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
844    */
845   // solhint-disable-next-line func-name-mixedcase
846   function DOMAIN_SEPARATOR() external view override returns (bytes32) {
847     return _domainSeparatorV4();
848   }
849 
850   /**
851    * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
852    * `r` and `s` signature fields separately.
853    */
854   function recover(
855     bytes32 hash,
856     uint8 v,
857     bytes32 r,
858     bytes32 s
859   ) internal pure returns (address) {
860     // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
861     // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
862     // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
863     // signatures from current libraries generate a unique signature with an s-value in the lower half order.
864     //
865     // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
866     // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
867     // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
868     // these malleable signatures as well.
869     require(
870       uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
871       "ECDSA: invalid signature 's' value"
872     );
873     require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
874 
875     // If the signature is valid (and not malleable), return the signer address
876     address signer = ecrecover(hash, v, r, s);
877     require(signer != address(0), "ECDSA: invalid signature");
878 
879     return signer;
880   }
881 }
882 
883 // File: contracts/BMIToken.sol
884 
885 pragma solidity =0.7.4;
886 
887 
888 contract BMIToken is ERC20Permit {
889   uint256 constant TOTAL_SUPPLY = 160 * (10**6) * (10**18);
890 
891   constructor(address tokenReceiver) ERC20Permit("Bridge Mutual") ERC20("Bridge Mutual", "BMI") {
892     _mint(tokenReceiver, TOTAL_SUPPLY);
893   }
894 }