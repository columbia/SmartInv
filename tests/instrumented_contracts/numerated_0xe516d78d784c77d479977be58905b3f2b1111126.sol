1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-24
3 */
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
85 
86 
87 pragma solidity ^0.8.0;
88 
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 // File: @openzeppelin/contracts/utils/Context.sol
113 
114 
115 pragma solidity ^0.8.0;
116 
117 /*
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
134         return msg.data;
135     }
136 }
137 
138 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
139 
140 
141 pragma solidity ^0.8.0;
142 
143 
144 
145 
146 /**
147  * @dev Implementation of the {IERC20} interface.
148  *
149  * This implementation is agnostic to the way tokens are created. This means
150  * that a supply mechanism has to be added in a derived contract using {_mint}.
151  * For a generic mechanism see {ERC20PresetMinterPauser}.
152  *
153  * TIP: For a detailed writeup see our guide
154  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
155  * to implement supply mechanisms].
156  *
157  * We have followed general OpenZeppelin guidelines: functions revert instead
158  * of returning `false` on failure. This behavior is nonetheless conventional
159  * and does not conflict with the expectations of ERC20 applications.
160  *
161  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
162  * This allows applications to reconstruct the allowance for all accounts just
163  * by listening to said events. Other implementations of the EIP may not emit
164  * these events, as it isn't required by the specification.
165  *
166  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
167  * functions have been added to mitigate the well-known issues around setting
168  * allowances. See {IERC20-approve}.
169  */
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping (address => uint256) private _balances;
172 
173     mapping (address => mapping (address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     /**
181      * @dev Sets the values for {name} and {symbol}.
182      *
183      * The defaut value of {decimals} is 18. To select a different value for
184      * {decimals} you should overload it.
185      *
186      * All two of these values are immutable: they can only be set once during
187      * construction.
188      */
189     constructor (string memory name_, string memory symbol_) {
190         _name = name_;
191         _symbol = symbol_;
192     }
193 
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() public view virtual override returns (string memory) {
198         return _name;
199     }
200 
201     /**
202      * @dev Returns the symbol of the token, usually a shorter version of the
203      * name.
204      */
205     function symbol() public view virtual override returns (string memory) {
206         return _symbol;
207     }
208 
209     /**
210      * @dev Returns the number of decimals used to get its user representation.
211      * For example, if `decimals` equals `2`, a balance of `505` tokens should
212      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
213      *
214      * Tokens usually opt for a value of 18, imitating the relationship between
215      * Ether and Wei. This is the value {ERC20} uses, unless this function is
216      * overridden;
217      *
218      * NOTE: This information is only used for _display_ purposes: it in
219      * no way affects any of the arithmetic of the contract, including
220      * {IERC20-balanceOf} and {IERC20-transfer}.
221      */
222     function decimals() public view virtual override returns (uint8) {
223         return 18;
224     }
225 
226     /**
227      * @dev See {IERC20-totalSupply}.
228      */
229     function totalSupply() public view virtual override returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See {IERC20-balanceOf}.
235      */
236     function balanceOf(address account) public view virtual override returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See {IERC20-transfer}.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 amount) public virtual override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-transferFrom}.
274      *
275      * Emits an {Approval} event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of {ERC20}.
277      *
278      * Requirements:
279      *
280      * - `sender` and `recipient` cannot be the zero address.
281      * - `sender` must have a balance of at least `amount`.
282      * - the caller must have allowance for ``sender``'s tokens of at least
283      * `amount`.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
286         _transfer(sender, recipient, amount);
287 
288         uint256 currentAllowance = _allowances[sender][_msgSender()];
289         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
290         _approve(sender, _msgSender(), currentAllowance - amount);
291 
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
308         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
327         uint256 currentAllowance = _allowances[_msgSender()][spender];
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
330 
331         return true;
332     }
333 
334     /**
335      * @dev Moves tokens `amount` from `sender` to `recipient`.
336      *
337      * This is internal function is equivalent to {transfer}, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a {Transfer} event.
341      *
342      * Requirements:
343      *
344      * - `sender` cannot be the zero address.
345      * - `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      */
348     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
349         require(sender != address(0), "ERC20: transfer from the zero address");
350         require(recipient != address(0), "ERC20: transfer to the zero address");
351 
352         _beforeTokenTransfer(sender, recipient, amount);
353 
354         uint256 senderBalance = _balances[sender];
355         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
356         _balances[sender] = senderBalance - amount;
357         _balances[recipient] += amount;
358 
359         emit Transfer(sender, recipient, amount);
360     }
361 
362     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
363      * the total supply.
364      *
365      * Emits a {Transfer} event with `from` set to the zero address.
366      *
367      * Requirements:
368      *
369      * - `to` cannot be the zero address.
370      */
371     function _mint(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: mint to the zero address");
373 
374         _beforeTokenTransfer(address(0), account, amount);
375 
376         _totalSupply += amount;
377         _balances[account] += amount;
378         emit Transfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _beforeTokenTransfer(account, address(0), amount);
396 
397         uint256 accountBalance = _balances[account];
398         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
399         _balances[account] = accountBalance - amount;
400         _totalSupply -= amount;
401 
402         emit Transfer(account, address(0), amount);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(address owner, address spender, uint256 amount) internal virtual {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = amount;
423         emit Approval(owner, spender, amount);
424     }
425 
426     /**
427      * @dev Hook that is called before any transfer of tokens. This includes
428      * minting and burning.
429      *
430      * Calling conditions:
431      *
432      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
433      * will be to transferred to `to`.
434      * - when `from` is zero, `amount` tokens will be minted for `to`.
435      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
436      * - `from` and `to` are never both zero.
437      *
438      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
439      */
440     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
441 }
442 
443 // File: @openzeppelin/contracts/access/Ownable.sol
444 
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Contract module which provides a basic access control mechanism, where
450  * there is an account (an owner) that can be granted exclusive access to
451  * specific functions.
452  *
453  * By default, the owner account will be the one that deploys the contract. This
454  * can later be changed with {transferOwnership}.
455  *
456  * This module is used through inheritance. It will make available the modifier
457  * `onlyOwner`, which can be applied to your functions to restrict their use to
458  * the owner.
459  */
460 abstract contract Ownable is Context {
461     address private _owner;
462 
463     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
464 
465     /**
466      * @dev Initializes the contract setting the deployer as the initial owner.
467      */
468     constructor () {
469         address msgSender = _msgSender();
470         _owner = msgSender;
471         emit OwnershipTransferred(address(0), msgSender);
472     }
473 
474     /**
475      * @dev Returns the address of the current owner.
476      */
477     function owner() public view virtual returns (address) {
478         return _owner;
479     }
480 
481     /**
482      * @dev Throws if called by any account other than the owner.
483      */
484     modifier onlyOwner() {
485         require(owner() == _msgSender(), "Ownable: caller is not the owner");
486         _;
487     }
488 
489     /**
490      * @dev Leaves the contract without owner. It will not be possible to call
491      * `onlyOwner` functions anymore. Can only be called by the current owner.
492      *
493      * NOTE: Renouncing ownership will leave the contract without an owner,
494      * thereby removing any functionality that is only available to the owner.
495      */
496     function renounceOwnership() public virtual onlyOwner {
497         emit OwnershipTransferred(_owner, address(0));
498         _owner = address(0);
499     }
500 
501     /**
502      * @dev Transfers ownership of the contract to a new account (`newOwner`).
503      * Can only be called by the current owner.
504      */
505     function transferOwnership(address newOwner) public virtual onlyOwner {
506         require(newOwner != address(0), "Ownable: new owner is the zero address");
507         emit OwnershipTransferred(_owner, newOwner);
508         _owner = newOwner;
509     }
510 }
511 
512 // File: @openzeppelin/contracts/security/Pausable.sol
513 
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @dev Contract module which allows children to implement an emergency stop
520  * mechanism that can be triggered by an authorized account.
521  *
522  * This module is used through inheritance. It will make available the
523  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
524  * the functions of your contract. Note that they will not be pausable by
525  * simply including this module, only once the modifiers are put in place.
526  */
527 abstract contract Pausable is Context {
528     /**
529      * @dev Emitted when the pause is triggered by `account`.
530      */
531     event Paused(address account);
532 
533     /**
534      * @dev Emitted when the pause is lifted by `account`.
535      */
536     event Unpaused(address account);
537 
538     bool private _paused;
539 
540     /**
541      * @dev Initializes the contract in unpaused state.
542      */
543     constructor () {
544         _paused = false;
545     }
546 
547     /**
548      * @dev Returns true if the contract is paused, and false otherwise.
549      */
550     function paused() public view virtual returns (bool) {
551         return _paused;
552     }
553 
554     /**
555      * @dev Modifier to make a function callable only when the contract is not paused.
556      *
557      * Requirements:
558      *
559      * - The contract must not be paused.
560      */
561     modifier whenNotPaused() {
562         require(!paused(), "Pausable: paused");
563         _;
564     }
565 
566     /**
567      * @dev Modifier to make a function callable only when the contract is paused.
568      *
569      * Requirements:
570      *
571      * - The contract must be paused.
572      */
573     modifier whenPaused() {
574         require(paused(), "Pausable: not paused");
575         _;
576     }
577 
578     /**
579      * @dev Triggers stopped state.
580      *
581      * Requirements:
582      *
583      * - The contract must not be paused.
584      */
585     function _pause() internal virtual whenNotPaused {
586         _paused = true;
587         emit Paused(_msgSender());
588     }
589 
590     /**
591      * @dev Returns to normal state.
592      *
593      * Requirements:
594      *
595      * - The contract must be paused.
596      */
597     function _unpause() internal virtual whenPaused {
598         _paused = false;
599         emit Unpaused(_msgSender());
600     }
601 }
602 
603 // File: @openzeppelin/contracts/utils/Strings.sol
604 
605 
606 pragma solidity ^0.8.0;
607 
608 /**
609  * @dev String operations.
610  */
611 library Strings {
612     bytes16 private constant alphabet = "0123456789abcdef";
613 
614     /**
615      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
616      */
617     function toString(uint256 value) internal pure returns (string memory) {
618         // Inspired by OraclizeAPI's implementation - MIT licence
619         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
620 
621         if (value == 0) {
622             return "0";
623         }
624         uint256 temp = value;
625         uint256 digits;
626         while (temp != 0) {
627             digits++;
628             temp /= 10;
629         }
630         bytes memory buffer = new bytes(digits);
631         while (value != 0) {
632             digits -= 1;
633             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
634             value /= 10;
635         }
636         return string(buffer);
637     }
638 
639     /**
640      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
641      */
642     function toHexString(uint256 value) internal pure returns (string memory) {
643         if (value == 0) {
644             return "0x00";
645         }
646         uint256 temp = value;
647         uint256 length = 0;
648         while (temp != 0) {
649             length++;
650             temp >>= 8;
651         }
652         return toHexString(value, length);
653     }
654 
655     /**
656      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
657      */
658     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
659         bytes memory buffer = new bytes(2 * length + 2);
660         buffer[0] = "0";
661         buffer[1] = "x";
662         for (uint256 i = 2 * length + 1; i > 1; --i) {
663             buffer[i] = alphabet[value & 0xf];
664             value >>= 4;
665         }
666         require(value == 0, "Strings: hex length insufficient");
667         return string(buffer);
668     }
669 
670 }
671 
672 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
673 
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @dev Interface of the ERC165 standard, as defined in the
679  * https://eips.ethereum.org/EIPS/eip-165[EIP].
680  *
681  * Implementers can declare support of contract interfaces, which can then be
682  * queried by others ({ERC165Checker}).
683  *
684  * For an implementation, see {ERC165}.
685  */
686 interface IERC165 {
687     /**
688      * @dev Returns true if this contract implements the interface defined by
689      * `interfaceId`. See the corresponding
690      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
691      * to learn more about how these ids are created.
692      *
693      * This function call must use less than 30 000 gas.
694      */
695     function supportsInterface(bytes4 interfaceId) external view returns (bool);
696 }
697 
698 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
699 
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @dev Implementation of the {IERC165} interface.
706  *
707  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
708  * for the additional interface id that will be supported. For example:
709  *
710  * ```solidity
711  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
712  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
713  * }
714  * ```
715  *
716  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
717  */
718 abstract contract ERC165 is IERC165 {
719     /**
720      * @dev See {IERC165-supportsInterface}.
721      */
722     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
723         return interfaceId == type(IERC165).interfaceId;
724     }
725 }
726 
727 // File: @openzeppelin/contracts/access/AccessControl.sol
728 
729 
730 pragma solidity ^0.8.0;
731 
732 
733 
734 
735 /**
736  * @dev External interface of AccessControl declared to support ERC165 detection.
737  */
738 interface IAccessControl {
739     function hasRole(bytes32 role, address account) external view returns (bool);
740     function getRoleAdmin(bytes32 role) external view returns (bytes32);
741     function grantRole(bytes32 role, address account) external;
742     function revokeRole(bytes32 role, address account) external;
743     function renounceRole(bytes32 role, address account) external;
744 }
745 
746 /**
747  * @dev Contract module that allows children to implement role-based access
748  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
749  * members except through off-chain means by accessing the contract event logs. Some
750  * applications may benefit from on-chain enumerability, for those cases see
751  * {AccessControlEnumerable}.
752  *
753  * Roles are referred to by their `bytes32` identifier. These should be exposed
754  * in the external API and be unique. The best way to achieve this is by
755  * using `public constant` hash digests:
756  *
757  * ```
758  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
759  * ```
760  *
761  * Roles can be used to represent a set of permissions. To restrict access to a
762  * function call, use {hasRole}:
763  *
764  * ```
765  * function foo() public {
766  *     require(hasRole(MY_ROLE, msg.sender));
767  *     ...
768  * }
769  * ```
770  *
771  * Roles can be granted and revoked dynamically via the {grantRole} and
772  * {revokeRole} functions. Each role has an associated admin role, and only
773  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
774  *
775  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
776  * that only accounts with this role will be able to grant or revoke other
777  * roles. More complex role relationships can be created by using
778  * {_setRoleAdmin}.
779  *
780  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
781  * grant and revoke this role. Extra precautions should be taken to secure
782  * accounts that have been granted it.
783  */
784 abstract contract AccessControl is Context, IAccessControl, ERC165 {
785     struct RoleData {
786         mapping (address => bool) members;
787         bytes32 adminRole;
788     }
789 
790     mapping (bytes32 => RoleData) private _roles;
791 
792     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
793 
794     /**
795      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
796      *
797      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
798      * {RoleAdminChanged} not being emitted signaling this.
799      *
800      * _Available since v3.1._
801      */
802     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
803 
804     /**
805      * @dev Emitted when `account` is granted `role`.
806      *
807      * `sender` is the account that originated the contract call, an admin role
808      * bearer except when using {_setupRole}.
809      */
810     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
811 
812     /**
813      * @dev Emitted when `account` is revoked `role`.
814      *
815      * `sender` is the account that originated the contract call:
816      *   - if using `revokeRole`, it is the admin role bearer
817      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
818      */
819     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
820 
821     /**
822      * @dev Modifier that checks that an account has a specific role. Reverts
823      * with a standardized message including the required role.
824      *
825      * The format of the revert reason is given by the following regular expression:
826      *
827      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
828      *
829      * _Available since v4.1._
830      */
831     modifier onlyRole(bytes32 role) {
832         _checkRole(role, _msgSender());
833         _;
834     }
835 
836     /**
837      * @dev See {IERC165-supportsInterface}.
838      */
839     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
840         return interfaceId == type(IAccessControl).interfaceId
841         || super.supportsInterface(interfaceId);
842     }
843 
844     /**
845      * @dev Returns `true` if `account` has been granted `role`.
846      */
847     function hasRole(bytes32 role, address account) public view override returns (bool) {
848         return _roles[role].members[account];
849     }
850 
851     /**
852      * @dev Revert with a standard message if `account` is missing `role`.
853      *
854      * The format of the revert reason is given by the following regular expression:
855      *
856      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
857      */
858     function _checkRole(bytes32 role, address account) internal view {
859         if(!hasRole(role, account)) {
860             revert(string(abi.encodePacked(
861                     "AccessControl: account ",
862                     Strings.toHexString(uint160(account), 20),
863                     " is missing role ",
864                     Strings.toHexString(uint256(role), 32)
865                 )));
866         }
867     }
868 
869     /**
870      * @dev Returns the admin role that controls `role`. See {grantRole} and
871      * {revokeRole}.
872      *
873      * To change a role's admin, use {_setRoleAdmin}.
874      */
875     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
876         return _roles[role].adminRole;
877     }
878 
879     /**
880      * @dev Grants `role` to `account`.
881      *
882      * If `account` had not been already granted `role`, emits a {RoleGranted}
883      * event.
884      *
885      * Requirements:
886      *
887      * - the caller must have ``role``'s admin role.
888      */
889     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
890         _grantRole(role, account);
891     }
892 
893     /**
894      * @dev Revokes `role` from `account`.
895      *
896      * If `account` had been granted `role`, emits a {RoleRevoked} event.
897      *
898      * Requirements:
899      *
900      * - the caller must have ``role``'s admin role.
901      */
902     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
903         _revokeRole(role, account);
904     }
905 
906     /**
907      * @dev Revokes `role` from the calling account.
908      *
909      * Roles are often managed via {grantRole} and {revokeRole}: this function's
910      * purpose is to provide a mechanism for accounts to lose their privileges
911      * if they are compromised (such as when a trusted device is misplaced).
912      *
913      * If the calling account had been granted `role`, emits a {RoleRevoked}
914      * event.
915      *
916      * Requirements:
917      *
918      * - the caller must be `account`.
919      */
920     function renounceRole(bytes32 role, address account) public virtual override {
921         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
922 
923         _revokeRole(role, account);
924     }
925 
926     /**
927      * @dev Grants `role` to `account`.
928      *
929      * If `account` had not been already granted `role`, emits a {RoleGranted}
930      * event. Note that unlike {grantRole}, this function doesn't perform any
931      * checks on the calling account.
932      *
933      * [WARNING]
934      * ====
935      * This function should only be called from the constructor when setting
936      * up the initial roles for the system.
937      *
938      * Using this function in any other way is effectively circumventing the admin
939      * system imposed by {AccessControl}.
940      * ====
941      */
942     function _setupRole(bytes32 role, address account) internal virtual {
943         _grantRole(role, account);
944     }
945 
946     /**
947      * @dev Sets `adminRole` as ``role``'s admin role.
948      *
949      * Emits a {RoleAdminChanged} event.
950      */
951     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
952         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
953         _roles[role].adminRole = adminRole;
954     }
955 
956     function _grantRole(bytes32 role, address account) private {
957         if (!hasRole(role, account)) {
958             _roles[role].members[account] = true;
959             emit RoleGranted(role, account, _msgSender());
960         }
961     }
962 
963     function _revokeRole(bytes32 role, address account) private {
964         if (hasRole(role, account)) {
965             _roles[role].members[account] = false;
966             emit RoleRevoked(role, account, _msgSender());
967         }
968     }
969 }
970 
971 // File: contracts/SPWN.sol
972 contract BlackList is Ownable {
973     mapping(address => bool) public isBlackListed;
974 
975     event AddedBlackList(address _user);
976     event RemovedBlackList(address _user);
977 
978     function addBlackList(address _evilUser) public onlyOwner {
979         require(owner() != _evilUser, "Can not add owner to blackList");
980 
981         isBlackListed[_evilUser] = true;
982 
983         emit AddedBlackList(_evilUser);
984     }
985 
986     function removeBlackList(address _clearedUser) public onlyOwner {
987         isBlackListed[_clearedUser] = false;
988 
989         RemovedBlackList(_clearedUser);
990     }
991 
992     function getBlackListStatus(address _maker) public view returns (bool) {
993         return isBlackListed[_maker];
994     }
995 }
996 
997 pragma solidity 0.8.3;
998 
999 contract DSAuth is AccessControl, BlackList {
1000     bytes32 public constant MINT_BURN_ROLE = keccak256("MINT_BURN_ROLE");
1001 
1002     address private _pendingOwner;
1003     address private _owner;
1004 
1005     event TransferOwnerShip(address indexed _newOwner);
1006     event AcceptOwnerShip(address indexed _oldOwner, address indexed _newOwner);
1007 
1008     constructor () {
1009         _owner = msg.sender;
1010         _pendingOwner = address(0);
1011 
1012         emit TransferOwnerShip(msg.sender);
1013     }
1014 
1015     // transferOwnership add a pending owner
1016     function transferOwnership(address newOwner) public override onlyOwner {
1017         require(!isBlackListed[newOwner], "Pending owner can not be in blackList");
1018         require(newOwner != owner(), "Pending owner and current owner need to be different");
1019         require(newOwner != address(0), "Pending owner can not be zero address");
1020 
1021         _pendingOwner = newOwner;
1022 
1023         emit TransferOwnerShip(newOwner);
1024     }
1025 
1026     function getPendingOwner() public view onlyOwner returns (address) {
1027         return _pendingOwner;
1028     }
1029 
1030     function owner() public override view returns (address) {
1031         return _owner;
1032     }
1033 
1034     // acceptOwnership allows the pending owner to accept the ownership of the SPWN token contract
1035     // along with grant new owner MINT_BURN_ROLE role and remove MINT_BURN_ROLE from old owner
1036     function acceptOwnership() public {
1037         require(_pendingOwner != address(0), "Please set pending owner first");
1038         require(_pendingOwner == msg.sender, "Only pending owner is able to accept the ownership");
1039         require(!isBlackListed[msg.sender], "Pending owner can not be in blackList");
1040 
1041         address oldOwner = owner();
1042 
1043         _owner = _pendingOwner;
1044 
1045         _setupRole(DEFAULT_ADMIN_ROLE, _pendingOwner);
1046         _grantAccess(MINT_BURN_ROLE, _pendingOwner);
1047 
1048         _revokeAccess(MINT_BURN_ROLE, oldOwner);
1049         _revokeAccess(DEFAULT_ADMIN_ROLE, oldOwner);
1050 
1051         emit AcceptOwnerShip(oldOwner, _pendingOwner);
1052 
1053         _pendingOwner = address(0);
1054     }
1055 
1056     // setAuthority performs the same action as grantMintBurnRole
1057     // we need setAuthority() only because the backward compatibility with previous version contract
1058     function setAuthority(address authorityAddress) public onlyOwner {
1059         require(!isBlackListed[authorityAddress], "AuthorityAddress is in blackList");
1060 
1061         grantMintBurnRole(authorityAddress);
1062     }
1063 
1064     // grantMintBurnRole grants the MINT_BURN_ROLE role to an address
1065     function grantMintBurnRole(address account) public onlyOwner {
1066         require(!isBlackListed[account], "account is in blackList");
1067 
1068         _grantAccess(MINT_BURN_ROLE, account);
1069     }
1070 
1071     // revokeMintBurnRole revokes the MINT_BURN_ROLE role from an address
1072     function revokeMintBurnRole(address account) public onlyOwner {
1073         _revokeAccess(MINT_BURN_ROLE, account);
1074     }
1075 
1076     // internal function _grantAccess grants account with given role
1077     function _grantAccess(bytes32 role, address account) internal {
1078         grantRole(role, account);
1079 
1080         emit RoleGranted(role, account, owner());
1081     }
1082 
1083     // internal function _revokeAccess revokes account with given role
1084     function _revokeAccess(bytes32 role, address account) internal {
1085         if (DEFAULT_ADMIN_ROLE == role) {
1086             require(account != owner(), "owner can not revoke himself from admin role");
1087         }
1088 
1089         revokeRole(role, account);
1090 
1091         emit RoleRevoked(role, account, owner());
1092     }
1093 }
1094 
1095 contract DSStop is Pausable, DSAuth {
1096     // we need stopped() only because the backward compatibility with previous version contract
1097     // stopped = paused
1098     function stopped() public view returns (bool) {
1099         return paused();
1100     }
1101 
1102     function stop() public onlyOwner {
1103         _pause();
1104 
1105         emit Paused(owner());
1106     }
1107 
1108     function start() public onlyOwner {
1109         _unpause();
1110 
1111         emit Unpaused(owner());
1112     }
1113 }
1114 
1115 abstract contract ERC20Burnable is Context, ERC20 {
1116     /**
1117      * @dev Destroys `amount` tokens from the caller.
1118      *
1119      * See {ERC20-_burn}.
1120      */
1121     function burn(uint256 amount) public virtual {
1122         _burn(_msgSender(), amount);
1123     }
1124 
1125     /**
1126      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1127      * allowance.
1128      *
1129      * See {ERC20-_burn} and {ERC20-allowance}.
1130      *
1131      * Requirements:
1132      *
1133      * - the caller must have allowance for ``accounts``'s tokens of at least
1134      * `amount`.
1135      */
1136     function burnFrom(address account, uint256 amount) public virtual {
1137         uint256 currentAllowance = allowance(account, _msgSender());
1138         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1139         _approve(account, _msgSender(), currentAllowance - amount);
1140         _burn(account, amount);
1141     }
1142 }
1143 
1144 contract Bitspawn is ERC20("BitSpawn Token", "SPWN"), ERC20Burnable, DSAuth, DSStop {
1145 
1146     event Mint(address indexed guy, uint wad);
1147     event Burn(address indexed guy, uint wad);
1148     event BurnFrom(address indexed allowanceOwner, address spender, uint wad);
1149     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
1150 
1151     uint256 MAX_SUPPLY = 2 * 10 ** 9 * 10 ** 18; // 2,000,000,000 SPWN Token Max Supply
1152 
1153     // deployer address is the default admin(owner)
1154     // deployer address is the first address with MINT_BURN_ROLE role
1155     constructor () {
1156         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1157         _grantAccess(MINT_BURN_ROLE, msg.sender);
1158     }
1159 
1160     function approve(address guy, uint wad) public override whenNotPaused returns (bool) {
1161         require(!isBlackListed[msg.sender], "Caller is in blackList");
1162         require(!isBlackListed[guy], "Spender is in blackList");
1163 
1164         return super.approve(guy, wad);
1165     }
1166 
1167     function transferFrom(address src, address dst, uint wad) public override whenNotPaused returns (bool) {
1168         require(!isBlackListed[msg.sender], "Caller is in blackList");
1169         require(!isBlackListed[src], "From address is in blackList");
1170 
1171         return super.transferFrom(src, dst, wad);
1172     }
1173 
1174     function transfer(address dst, uint wad) public override whenNotPaused returns (bool) {
1175         require(!isBlackListed[msg.sender], "Caller is in blackList");
1176         require(!isBlackListed[dst], "To address is in blackList");
1177 
1178         return super.transfer(dst, wad);
1179     }
1180 
1181     function mint(address guy, uint wad) public whenNotPaused {
1182         require(!isBlackListed[msg.sender], "Caller is in blackList");
1183         require(!isBlackListed[guy], "To address is in blackList");
1184         require(hasRole(MINT_BURN_ROLE, msg.sender), "Caller is not allowed to mint");
1185         require(totalSupply() + wad <= MAX_SUPPLY, "Exceeds SPWN token max totalSupply");
1186 
1187         _mint(guy, wad);
1188 
1189         emit Mint(guy, wad);
1190     }
1191 
1192     function burn(uint wad) public override whenNotPaused {
1193         require(!isBlackListed[msg.sender], "Caller is in blackList");
1194         require(hasRole(MINT_BURN_ROLE, msg.sender), "Caller is not allowed to burn");
1195 
1196         super.burn(wad);
1197 
1198         emit Burn(msg.sender, wad);
1199     }
1200 
1201     function burnFrom(address allowanceOwner, uint wad) public override whenNotPaused {
1202         require(!isBlackListed[msg.sender], "Caller is in blackList");
1203         require(hasRole(MINT_BURN_ROLE, msg.sender), "Caller is not allowed to burn");
1204 
1205         super.burnFrom(allowanceOwner, wad);
1206 
1207         emit BurnFrom(allowanceOwner, msg.sender, wad);
1208     }
1209 
1210     function destroyBlackFunds(address _blackListedUser) public onlyOwner {
1211         require(isBlackListed[_blackListedUser], "Address is not in the blackList");
1212 
1213         uint dirtyFunds = balanceOf(_blackListedUser);
1214         _burn(_blackListedUser, dirtyFunds);
1215 
1216         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
1217     }
1218 
1219     function redeem(uint amount) public onlyOwner {
1220         require(balanceOf(address(this)) >= amount, "redeem can not exceed the balance");
1221 
1222         _transfer(address(this), owner(), amount);
1223     }
1224 }