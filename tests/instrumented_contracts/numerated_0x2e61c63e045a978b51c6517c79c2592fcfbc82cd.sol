1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: @openzeppelin/contracts/access/Roles.sol
502 
503 pragma solidity ^0.5.0;
504 
505 /**
506  * @title Roles
507  * @dev Library for managing addresses assigned to a Role.
508  */
509 library Roles {
510     struct Role {
511         mapping (address => bool) bearer;
512     }
513 
514     /**
515      * @dev Give an account access to this role.
516      */
517     function add(Role storage role, address account) internal {
518         require(!has(role, account), "Roles: account already has role");
519         role.bearer[account] = true;
520     }
521 
522     /**
523      * @dev Remove an account's access to this role.
524      */
525     function remove(Role storage role, address account) internal {
526         require(has(role, account), "Roles: account does not have role");
527         role.bearer[account] = false;
528     }
529 
530     /**
531      * @dev Check if an account has this role.
532      * @return bool
533      */
534     function has(Role storage role, address account) internal view returns (bool) {
535         require(account != address(0), "Roles: account is the zero address");
536         return role.bearer[account];
537     }
538 }
539 
540 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
541 
542 pragma solidity ^0.5.0;
543 
544 
545 
546 contract MinterRole is Context {
547     using Roles for Roles.Role;
548 
549     event MinterAdded(address indexed account);
550     event MinterRemoved(address indexed account);
551 
552     Roles.Role private _minters;
553 
554     constructor () internal {
555         _addMinter(_msgSender());
556     }
557 
558     modifier onlyMinter() {
559         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
560         _;
561     }
562 
563     function isMinter(address account) public view returns (bool) {
564         return _minters.has(account);
565     }
566 
567     function addMinter(address account) public onlyMinter {
568         _addMinter(account);
569     }
570 
571     function renounceMinter() public {
572         _removeMinter(_msgSender());
573     }
574 
575     function _addMinter(address account) internal {
576         _minters.add(account);
577         emit MinterAdded(account);
578     }
579 
580     function _removeMinter(address account) internal {
581         _minters.remove(account);
582         emit MinterRemoved(account);
583     }
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
587 
588 pragma solidity ^0.5.0;
589 
590 
591 
592 /**
593  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
594  * which have permission to mint (create) new tokens as they see fit.
595  *
596  * At construction, the deployer of the contract is the only minter.
597  */
598 contract ERC20Mintable is ERC20, MinterRole {
599     /**
600      * @dev See {ERC20-_mint}.
601      *
602      * Requirements:
603      *
604      * - the caller must have the {MinterRole}.
605      */
606     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
607         _mint(account, amount);
608         return true;
609     }
610 }
611 
612 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
613 
614 pragma solidity ^0.5.0;
615 
616 
617 /**
618  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
619  */
620 contract ERC20Capped is ERC20Mintable {
621     uint256 private _cap;
622 
623     /**
624      * @dev Sets the value of the `cap`. This value is immutable, it can only be
625      * set once during construction.
626      */
627     constructor (uint256 cap) public {
628         require(cap > 0, "ERC20Capped: cap is 0");
629         _cap = cap;
630     }
631 
632     /**
633      * @dev Returns the cap on the token's total supply.
634      */
635     function cap() public view returns (uint256) {
636         return _cap;
637     }
638 
639     /**
640      * @dev See {ERC20Mintable-mint}.
641      *
642      * Requirements:
643      *
644      * - `value` must not cause the total supply to go over the cap.
645      */
646     function _mint(address account, uint256 value) internal {
647         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
648         super._mint(account, value);
649     }
650 }
651 
652 // File: @openzeppelin/contracts/introspection/IERC165.sol
653 
654 pragma solidity ^0.5.0;
655 
656 /**
657  * @dev Interface of the ERC165 standard, as defined in the
658  * https://eips.ethereum.org/EIPS/eip-165[EIP].
659  *
660  * Implementers can declare support of contract interfaces, which can then be
661  * queried by others ({ERC165Checker}).
662  *
663  * For an implementation, see {ERC165}.
664  */
665 interface IERC165 {
666     /**
667      * @dev Returns true if this contract implements the interface defined by
668      * `interfaceId`. See the corresponding
669      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
670      * to learn more about how these ids are created.
671      *
672      * This function call must use less than 30 000 gas.
673      */
674     function supportsInterface(bytes4 interfaceId) external view returns (bool);
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
678 
679 pragma solidity ^0.5.0;
680 
681 
682 /**
683  * @dev Required interface of an ERC721 compliant contract.
684  */
685 contract IERC721 is IERC165 {
686     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
687     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
688     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
689 
690     /**
691      * @dev Returns the number of NFTs in `owner`'s account.
692      */
693     function balanceOf(address owner) public view returns (uint256 balance);
694 
695     /**
696      * @dev Returns the owner of the NFT specified by `tokenId`.
697      */
698     function ownerOf(uint256 tokenId) public view returns (address owner);
699 
700     /**
701      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
702      * another (`to`).
703      *
704      *
705      *
706      * Requirements:
707      * - `from`, `to` cannot be zero.
708      * - `tokenId` must be owned by `from`.
709      * - If the caller is not `from`, it must be have been allowed to move this
710      * NFT by either {approve} or {setApprovalForAll}.
711      */
712     function safeTransferFrom(address from, address to, uint256 tokenId) public;
713     /**
714      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
715      * another (`to`).
716      *
717      * Requirements:
718      * - If the caller is not `from`, it must be approved to move this NFT by
719      * either {approve} or {setApprovalForAll}.
720      */
721     function transferFrom(address from, address to, uint256 tokenId) public;
722     function approve(address to, uint256 tokenId) public;
723     function getApproved(uint256 tokenId) public view returns (address operator);
724 
725     function setApprovalForAll(address operator, bool _approved) public;
726     function isApprovedForAll(address owner, address operator) public view returns (bool);
727 
728 
729     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
730 }
731 
732 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
733 
734 pragma solidity ^0.5.0;
735 
736 
737 
738 contract PauserRole is Context {
739     using Roles for Roles.Role;
740 
741     event PauserAdded(address indexed account);
742     event PauserRemoved(address indexed account);
743 
744     Roles.Role private _pausers;
745 
746     constructor () internal {
747         _addPauser(_msgSender());
748     }
749 
750     modifier onlyPauser() {
751         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
752         _;
753     }
754 
755     function isPauser(address account) public view returns (bool) {
756         return _pausers.has(account);
757     }
758 
759     function addPauser(address account) public onlyPauser {
760         _addPauser(account);
761     }
762 
763     function renouncePauser() public {
764         _removePauser(_msgSender());
765     }
766 
767     function _addPauser(address account) internal {
768         _pausers.add(account);
769         emit PauserAdded(account);
770     }
771 
772     function _removePauser(address account) internal {
773         _pausers.remove(account);
774         emit PauserRemoved(account);
775     }
776 }
777 
778 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
779 
780 pragma solidity ^0.5.0;
781 
782 
783 
784 /**
785  * @dev Contract module which allows children to implement an emergency stop
786  * mechanism that can be triggered by an authorized account.
787  *
788  * This module is used through inheritance. It will make available the
789  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
790  * the functions of your contract. Note that they will not be pausable by
791  * simply including this module, only once the modifiers are put in place.
792  */
793 contract Pausable is Context, PauserRole {
794     /**
795      * @dev Emitted when the pause is triggered by a pauser (`account`).
796      */
797     event Paused(address account);
798 
799     /**
800      * @dev Emitted when the pause is lifted by a pauser (`account`).
801      */
802     event Unpaused(address account);
803 
804     bool private _paused;
805 
806     /**
807      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
808      * to the deployer.
809      */
810     constructor () internal {
811         _paused = false;
812     }
813 
814     /**
815      * @dev Returns true if the contract is paused, and false otherwise.
816      */
817     function paused() public view returns (bool) {
818         return _paused;
819     }
820 
821     /**
822      * @dev Modifier to make a function callable only when the contract is not paused.
823      */
824     modifier whenNotPaused() {
825         require(!_paused, "Pausable: paused");
826         _;
827     }
828 
829     /**
830      * @dev Modifier to make a function callable only when the contract is paused.
831      */
832     modifier whenPaused() {
833         require(_paused, "Pausable: not paused");
834         _;
835     }
836 
837     /**
838      * @dev Called by a pauser to pause, triggers stopped state.
839      */
840     function pause() public onlyPauser whenNotPaused {
841         _paused = true;
842         emit Paused(_msgSender());
843     }
844 
845     /**
846      * @dev Called by a pauser to unpause, returns to normal state.
847      */
848     function unpause() public onlyPauser whenPaused {
849         _paused = false;
850         emit Unpaused(_msgSender());
851     }
852 }
853 
854 // File: @openzeppelin/contracts/math/Math.sol
855 
856 pragma solidity ^0.5.0;
857 
858 /**
859  * @dev Standard math utilities missing in the Solidity language.
860  */
861 library Math {
862     /**
863      * @dev Returns the largest of two numbers.
864      */
865     function max(uint256 a, uint256 b) internal pure returns (uint256) {
866         return a >= b ? a : b;
867     }
868 
869     /**
870      * @dev Returns the smallest of two numbers.
871      */
872     function min(uint256 a, uint256 b) internal pure returns (uint256) {
873         return a < b ? a : b;
874     }
875 
876     /**
877      * @dev Returns the average of two numbers. The result is rounded towards
878      * zero.
879      */
880     function average(uint256 a, uint256 b) internal pure returns (uint256) {
881         // (a + b) / 2 can overflow, so we distribute
882         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
883     }
884 }
885 
886 // File: @openzeppelin/contracts/ownership/Ownable.sol
887 
888 pragma solidity ^0.5.0;
889 
890 /**
891  * @dev Contract module which provides a basic access control mechanism, where
892  * there is an account (an owner) that can be granted exclusive access to
893  * specific functions.
894  *
895  * This module is used through inheritance. It will make available the modifier
896  * `onlyOwner`, which can be applied to your functions to restrict their use to
897  * the owner.
898  */
899 contract Ownable is Context {
900     address private _owner;
901 
902     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
903 
904     /**
905      * @dev Initializes the contract setting the deployer as the initial owner.
906      */
907     constructor () internal {
908         address msgSender = _msgSender();
909         _owner = msgSender;
910         emit OwnershipTransferred(address(0), msgSender);
911     }
912 
913     /**
914      * @dev Returns the address of the current owner.
915      */
916     function owner() public view returns (address) {
917         return _owner;
918     }
919 
920     /**
921      * @dev Throws if called by any account other than the owner.
922      */
923     modifier onlyOwner() {
924         require(isOwner(), "Ownable: caller is not the owner");
925         _;
926     }
927 
928     /**
929      * @dev Returns true if the caller is the current owner.
930      */
931     function isOwner() public view returns (bool) {
932         return _msgSender() == _owner;
933     }
934 
935     /**
936      * @dev Leaves the contract without owner. It will not be possible to call
937      * `onlyOwner` functions anymore. Can only be called by the current owner.
938      *
939      * NOTE: Renouncing ownership will leave the contract without an owner,
940      * thereby removing any functionality that is only available to the owner.
941      */
942     function renounceOwnership() public onlyOwner {
943         emit OwnershipTransferred(_owner, address(0));
944         _owner = address(0);
945     }
946 
947     /**
948      * @dev Transfers ownership of the contract to a new account (`newOwner`).
949      * Can only be called by the current owner.
950      */
951     function transferOwnership(address newOwner) public onlyOwner {
952         _transferOwnership(newOwner);
953     }
954 
955     /**
956      * @dev Transfers ownership of the contract to a new account (`newOwner`).
957      */
958     function _transferOwnership(address newOwner) internal {
959         require(newOwner != address(0), "Ownable: new owner is the zero address");
960         emit OwnershipTransferred(_owner, newOwner);
961         _owner = newOwner;
962     }
963 }
964 
965 // File: contracts/purchase/ReferrableSale.sol
966 
967 pragma solidity ^0.5.2;
968 
969 
970 /**
971  * @title ReferrableSale
972  * @dev Implements the base elements for a sales referral system.
973  * It is supposed to be inherited by a sales contract.
974  * The referrals are expressed in percentage * 100, for example 1000 represents 10% and 555 represents 5.55%.
975  */
976 contract ReferrableSale is Ownable {
977 
978     event DefaultReferralSet(
979         uint256 percentage
980     );
981 
982     event CustomReferralSet(
983         address indexed referrer,
984         uint256 percentage
985     );
986 
987     uint256 public _defaultReferralPercentage;
988     mapping (address => uint256) public _customReferralPercentages;
989 
990     function setDefaultReferral(uint256 defaultReferralPercentage) public onlyOwner {
991         require(defaultReferralPercentage < 10000, "Referral must be less than 100 percent");
992         require(defaultReferralPercentage != _defaultReferralPercentage, "New referral must be different from the previous");
993         _defaultReferralPercentage = defaultReferralPercentage;
994         emit DefaultReferralSet(defaultReferralPercentage);
995     }
996 
997     function setCustomReferral(address _referrer, uint256 customReferralPercentage) public onlyOwner {
998         require(customReferralPercentage < 10000, "Referral must be less than 100 percent");
999         require(customReferralPercentage != _customReferralPercentages[_referrer], "New referral must be different from the previous");
1000         _customReferralPercentages[_referrer] = customReferralPercentage;
1001         emit CustomReferralSet(_referrer, customReferralPercentage);
1002     }
1003 }
1004 
1005 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
1006 
1007 pragma solidity ^0.5.0;
1008 
1009 
1010 /**
1011  * @dev Optional functions from the ERC20 standard.
1012  */
1013 contract ERC20Detailed is IERC20 {
1014     string private _name;
1015     string private _symbol;
1016     uint8 private _decimals;
1017 
1018     /**
1019      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1020      * these values are immutable: they can only be set once during
1021      * construction.
1022      */
1023     constructor (string memory name, string memory symbol, uint8 decimals) public {
1024         _name = name;
1025         _symbol = symbol;
1026         _decimals = decimals;
1027     }
1028 
1029     /**
1030      * @dev Returns the name of the token.
1031      */
1032     function name() public view returns (string memory) {
1033         return _name;
1034     }
1035 
1036     /**
1037      * @dev Returns the symbol of the token, usually a shorter version of the
1038      * name.
1039      */
1040     function symbol() public view returns (string memory) {
1041         return _symbol;
1042     }
1043 
1044     /**
1045      * @dev Returns the number of decimals used to get its user representation.
1046      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1047      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1048      *
1049      * Tokens usually opt for a value of 18, imitating the relationship between
1050      * Ether and Wei.
1051      *
1052      * NOTE: This information is only used for _display_ purposes: it in
1053      * no way affects any of the arithmetic of the contract, including
1054      * {IERC20-balanceOf} and {IERC20-transfer}.
1055      */
1056     function decimals() public view returns (uint8) {
1057         return _decimals;
1058     }
1059 }
1060 
1061 // File: @openzeppelin/contracts/GSN/IRelayRecipient.sol
1062 
1063 pragma solidity ^0.5.0;
1064 
1065 /**
1066  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
1067  *
1068  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
1069  */
1070 interface IRelayRecipient {
1071     /**
1072      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
1073      */
1074     function getHubAddr() external view returns (address);
1075 
1076     /**
1077      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
1078      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
1079      *
1080      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
1081      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
1082      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
1083      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
1084      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
1085      * over all or some of the previous values.
1086      *
1087      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
1088      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
1089      *
1090      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
1091      * rejected. A regular revert will also trigger a rejection.
1092      */
1093     function acceptRelayedCall(
1094         address relay,
1095         address from,
1096         bytes calldata encodedFunction,
1097         uint256 transactionFee,
1098         uint256 gasPrice,
1099         uint256 gasLimit,
1100         uint256 nonce,
1101         bytes calldata approvalData,
1102         uint256 maxPossibleCharge
1103     )
1104         external
1105         view
1106         returns (uint256, bytes memory);
1107 
1108     /**
1109      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
1110      * pre-charge the sender of the transaction.
1111      *
1112      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
1113      *
1114      * Returns a value to be passed to {postRelayedCall}.
1115      *
1116      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
1117      * will not be executed, but the recipient will still be charged for the transaction's cost.
1118      */
1119     function preRelayedCall(bytes calldata context) external returns (bytes32);
1120 
1121     /**
1122      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
1123      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
1124      * contract-specific bookkeeping.
1125      *
1126      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
1127      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
1128      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
1129      *
1130      *
1131      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
1132      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
1133      * transaction's cost.
1134      */
1135     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
1136 }
1137 
1138 // File: @openzeppelin/contracts/GSN/IRelayHub.sol
1139 
1140 pragma solidity ^0.5.0;
1141 
1142 /**
1143  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
1144  * directly.
1145  *
1146  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
1147  * how to deploy an instance of `RelayHub` on your local test network.
1148  */
1149 interface IRelayHub {
1150     // Relay management
1151 
1152     /**
1153      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
1154      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
1155      * cannot be its own owner.
1156      *
1157      * All Ether in this function call will be added to the relay's stake.
1158      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
1159      *
1160      * Emits a {Staked} event.
1161      */
1162     function stake(address relayaddr, uint256 unstakeDelay) external payable;
1163 
1164     /**
1165      * @dev Emitted when a relay's stake or unstakeDelay are increased
1166      */
1167     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
1168 
1169     /**
1170      * @dev Registers the caller as a relay.
1171      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
1172      *
1173      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
1174      * `transactionFee` is not enforced by {relayCall}.
1175      *
1176      * Emits a {RelayAdded} event.
1177      */
1178     function registerRelay(uint256 transactionFee, string calldata url) external;
1179 
1180     /**
1181      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
1182      * {RelayRemoved} events) lets a client discover the list of available relays.
1183      */
1184     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
1185 
1186     /**
1187      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
1188      *
1189      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
1190      * callable.
1191      *
1192      * Emits a {RelayRemoved} event.
1193      */
1194     function removeRelayByOwner(address relay) external;
1195 
1196     /**
1197      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
1198      */
1199     event RelayRemoved(address indexed relay, uint256 unstakeTime);
1200 
1201     /** Deletes the relay from the system, and gives back its stake to the owner.
1202      *
1203      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
1204      *
1205      * Emits an {Unstaked} event.
1206      */
1207     function unstake(address relay) external;
1208 
1209     /**
1210      * @dev Emitted when a relay is unstaked for, including the returned stake.
1211      */
1212     event Unstaked(address indexed relay, uint256 stake);
1213 
1214     // States a relay can be in
1215     enum RelayState {
1216         Unknown, // The relay is unknown to the system: it has never been staked for
1217         Staked, // The relay has been staked for, but it is not yet active
1218         Registered, // The relay has registered itself, and is active (can relay calls)
1219         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
1220     }
1221 
1222     /**
1223      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
1224      * to return an empty entry.
1225      */
1226     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
1227 
1228     // Balance management
1229 
1230     /**
1231      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
1232      *
1233      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
1234      *
1235      * Emits a {Deposited} event.
1236      */
1237     function depositFor(address target) external payable;
1238 
1239     /**
1240      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
1241      */
1242     event Deposited(address indexed recipient, address indexed from, uint256 amount);
1243 
1244     /**
1245      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
1246      */
1247     function balanceOf(address target) external view returns (uint256);
1248 
1249     /**
1250      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
1251      * contracts can use it to reduce their funding.
1252      *
1253      * Emits a {Withdrawn} event.
1254      */
1255     function withdraw(uint256 amount, address payable dest) external;
1256 
1257     /**
1258      * @dev Emitted when an account withdraws funds from `RelayHub`.
1259      */
1260     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
1261 
1262     // Relaying
1263 
1264     /**
1265      * @dev Checks if the `RelayHub` will accept a relayed operation.
1266      * Multiple things must be true for this to happen:
1267      *  - all arguments must be signed for by the sender (`from`)
1268      *  - the sender's nonce must be the current one
1269      *  - the recipient must accept this transaction (via {acceptRelayedCall})
1270      *
1271      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
1272      * code if it returns one in {acceptRelayedCall}.
1273      */
1274     function canRelay(
1275         address relay,
1276         address from,
1277         address to,
1278         bytes calldata encodedFunction,
1279         uint256 transactionFee,
1280         uint256 gasPrice,
1281         uint256 gasLimit,
1282         uint256 nonce,
1283         bytes calldata signature,
1284         bytes calldata approvalData
1285     ) external view returns (uint256 status, bytes memory recipientContext);
1286 
1287     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
1288     enum PreconditionCheck {
1289         OK,                         // All checks passed, the call can be relayed
1290         WrongSignature,             // The transaction to relay is not signed by requested sender
1291         WrongNonce,                 // The provided nonce has already been used by the sender
1292         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
1293         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
1294     }
1295 
1296     /**
1297      * @dev Relays a transaction.
1298      *
1299      * For this to succeed, multiple conditions must be met:
1300      *  - {canRelay} must `return PreconditionCheck.OK`
1301      *  - the sender must be a registered relay
1302      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
1303      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
1304      * recipient) use all gas available to them
1305      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
1306      * spent)
1307      *
1308      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
1309      * function and {postRelayedCall} will be called in that order.
1310      *
1311      * Parameters:
1312      *  - `from`: the client originating the request
1313      *  - `to`: the target {IRelayRecipient} contract
1314      *  - `encodedFunction`: the function call to relay, including data
1315      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
1316      *  - `gasPrice`: gas price the client is willing to pay
1317      *  - `gasLimit`: gas to forward when calling the encoded function
1318      *  - `nonce`: client's nonce
1319      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
1320      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
1321      * `RelayHub`, but it still can be used for e.g. a signature.
1322      *
1323      * Emits a {TransactionRelayed} event.
1324      */
1325     function relayCall(
1326         address from,
1327         address to,
1328         bytes calldata encodedFunction,
1329         uint256 transactionFee,
1330         uint256 gasPrice,
1331         uint256 gasLimit,
1332         uint256 nonce,
1333         bytes calldata signature,
1334         bytes calldata approvalData
1335     ) external;
1336 
1337     /**
1338      * @dev Emitted when an attempt to relay a call failed.
1339      *
1340      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
1341      * actual relayed call was not executed, and the recipient not charged.
1342      *
1343      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
1344      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
1345      */
1346     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
1347 
1348     /**
1349      * @dev Emitted when a transaction is relayed. 
1350      * Useful when monitoring a relay's operation and relayed calls to a contract
1351      *
1352      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
1353      *
1354      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
1355      */
1356     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
1357 
1358     // Reason error codes for the TransactionRelayed event
1359     enum RelayCallStatus {
1360         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
1361         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
1362         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
1363         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
1364         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
1365     }
1366 
1367     /**
1368      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
1369      * spend up to `relayedCallStipend` gas.
1370      */
1371     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
1372 
1373     /**
1374      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
1375      */
1376     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
1377 
1378      // Relay penalization. 
1379      // Any account can penalize relays, removing them from the system immediately, and rewarding the
1380     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
1381     // still loses half of its stake.
1382 
1383     /**
1384      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
1385      * different data (gas price, gas limit, etc. may be different).
1386      *
1387      * The (unsigned) transaction data and signature for both transactions must be provided.
1388      */
1389     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
1390 
1391     /**
1392      * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
1393      */
1394     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
1395 
1396     /**
1397      * @dev Emitted when a relay is penalized.
1398      */
1399     event Penalized(address indexed relay, address sender, uint256 amount);
1400 
1401     /**
1402      * @dev Returns an account's nonce in `RelayHub`.
1403      */
1404     function getNonce(address from) external view returns (uint256);
1405 }
1406 
1407 // File: @openzeppelin/contracts/GSN/GSNRecipient.sol
1408 
1409 pragma solidity ^0.5.0;
1410 
1411 
1412 
1413 
1414 /**
1415  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
1416  * and enables GSN support on all contracts in the inheritance tree.
1417  *
1418  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
1419  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
1420  * provided by derived contracts. See the
1421  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
1422  * information on how to use the pre-built {GSNRecipientSignature} and
1423  * {GSNRecipientERC20Fee}, or how to write your own.
1424  */
1425 contract GSNRecipient is IRelayRecipient, Context {
1426     // Default RelayHub address, deployed on mainnet and all testnets at the same address
1427     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
1428 
1429     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
1430     uint256 constant private RELAYED_CALL_REJECTED = 11;
1431 
1432     // How much gas is forwarded to postRelayedCall
1433     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
1434 
1435     /**
1436      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
1437      */
1438     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
1439 
1440     /**
1441      * @dev Returns the address of the {IRelayHub} contract for this recipient.
1442      */
1443     function getHubAddr() public view returns (address) {
1444         return _relayHub;
1445     }
1446 
1447     /**
1448      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
1449      * use the default instance.
1450      *
1451      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
1452      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
1453      */
1454     function _upgradeRelayHub(address newRelayHub) internal {
1455         address currentRelayHub = _relayHub;
1456         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
1457         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
1458 
1459         emit RelayHubChanged(currentRelayHub, newRelayHub);
1460 
1461         _relayHub = newRelayHub;
1462     }
1463 
1464     /**
1465      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
1466      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
1467      */
1468     // This function is view for future-proofing, it may require reading from
1469     // storage in the future.
1470     function relayHubVersion() public view returns (string memory) {
1471         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1472         return "1.0.0";
1473     }
1474 
1475     /**
1476      * @dev Withdraws the recipient's deposits in `RelayHub`.
1477      *
1478      * Derived contracts should expose this in an external interface with proper access control.
1479      */
1480     function _withdrawDeposits(uint256 amount, address payable payee) internal {
1481         IRelayHub(_relayHub).withdraw(amount, payee);
1482     }
1483 
1484     // Overrides for Context's functions: when called from RelayHub, sender and
1485     // data require some pre-processing: the actual sender is stored at the end
1486     // of the call data, which in turns means it needs to be removed from it
1487     // when handling said data.
1488 
1489     /**
1490      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
1491      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
1492      *
1493      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
1494      */
1495     function _msgSender() internal view returns (address payable) {
1496         if (msg.sender != _relayHub) {
1497             return msg.sender;
1498         } else {
1499             return _getRelayedCallSender();
1500         }
1501     }
1502 
1503     /**
1504      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1505      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
1506      *
1507      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1508      */
1509     function _msgData() internal view returns (bytes memory) {
1510         if (msg.sender != _relayHub) {
1511             return msg.data;
1512         } else {
1513             return _getRelayedCallData();
1514         }
1515     }
1516 
1517     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
1518     // internal hook.
1519 
1520     /**
1521      * @dev See `IRelayRecipient.preRelayedCall`.
1522      *
1523      * This function should not be overriden directly, use `_preRelayedCall` instead.
1524      *
1525      * * Requirements:
1526      *
1527      * - the caller must be the `RelayHub` contract.
1528      */
1529     function preRelayedCall(bytes calldata context) external returns (bytes32) {
1530         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1531         return _preRelayedCall(context);
1532     }
1533 
1534     /**
1535      * @dev See `IRelayRecipient.preRelayedCall`.
1536      *
1537      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1538      * must implement this function with any relayed-call preprocessing they may wish to do.
1539      *
1540      */
1541     function _preRelayedCall(bytes memory context) internal returns (bytes32);
1542 
1543     /**
1544      * @dev See `IRelayRecipient.postRelayedCall`.
1545      *
1546      * This function should not be overriden directly, use `_postRelayedCall` instead.
1547      *
1548      * * Requirements:
1549      *
1550      * - the caller must be the `RelayHub` contract.
1551      */
1552     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
1553         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1554         _postRelayedCall(context, success, actualCharge, preRetVal);
1555     }
1556 
1557     /**
1558      * @dev See `IRelayRecipient.postRelayedCall`.
1559      *
1560      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1561      * must implement this function with any relayed-call postprocessing they may wish to do.
1562      *
1563      */
1564     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
1565 
1566     /**
1567      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
1568      * will be charged a fee by RelayHub
1569      */
1570     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
1571         return _approveRelayedCall("");
1572     }
1573 
1574     /**
1575      * @dev See `GSNRecipient._approveRelayedCall`.
1576      *
1577      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
1578      */
1579     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
1580         return (RELAYED_CALL_ACCEPTED, context);
1581     }
1582 
1583     /**
1584      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
1585      */
1586     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
1587         return (RELAYED_CALL_REJECTED + errorCode, "");
1588     }
1589 
1590     /*
1591      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
1592      * `serviceFee`.
1593      */
1594     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
1595         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
1596         // charged for 1.4 times the spent amount.
1597         return (gas * gasPrice * (100 + serviceFee)) / 100;
1598     }
1599 
1600     function _getRelayedCallSender() private pure returns (address payable result) {
1601         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
1602         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
1603         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
1604         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
1605         // bytes. This can always be done due to the 32-byte prefix.
1606 
1607         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
1608         // easiest/most-efficient way to perform this operation.
1609 
1610         // These fields are not accessible from assembly
1611         bytes memory array = msg.data;
1612         uint256 index = msg.data.length;
1613 
1614         // solhint-disable-next-line no-inline-assembly
1615         assembly {
1616             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1617             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1618         }
1619         return result;
1620     }
1621 
1622     function _getRelayedCallData() private pure returns (bytes memory) {
1623         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
1624         // we must strip the last 20 bytes (length of an address type) from it.
1625 
1626         uint256 actualDataLength = msg.data.length - 20;
1627         bytes memory actualData = new bytes(actualDataLength);
1628 
1629         for (uint256 i = 0; i < actualDataLength; ++i) {
1630             actualData[i] = msg.data[i];
1631         }
1632 
1633         return actualData;
1634     }
1635 }
1636 
1637 // File: contracts/purchase/ICrateOpenEmitter.sol
1638 
1639 pragma solidity = 0.5.16;
1640 
1641 
1642 interface ICrateOpenEmitter {
1643     function openCrate(address from, uint256 lotId, uint256 amount) external;
1644 }
1645 
1646 // File: contracts/purchase/F1DeltaCrate.sol
1647 
1648 pragma solidity = 0.5.16;
1649 
1650 
1651 
1652 
1653 
1654 
1655 // crate token. 0 decimals - crates can't be fractional
1656 contract F1DeltaCrate is ERC20Capped, ERC20Detailed, GSNRecipient, Ownable {
1657     enum ErrorCodes {
1658         RESTRICTED_METHOD,
1659         INSUFFICIENT_BALANCE
1660     }
1661 
1662     struct AcceptRelayedCallVars {
1663         bytes4 methodId;
1664         bytes ef;
1665     }
1666 
1667     string _uri;
1668     address _crateOpener;
1669     uint256 _lotId;
1670     uint256 public _cratesIssued;
1671 
1672     constructor(
1673         uint256 lotId, 
1674         uint256 cap,
1675         string memory name, 
1676         string memory symbol,
1677         string memory uri,
1678         address crateOpener
1679     ) ERC20Capped(cap) ERC20Detailed(name, symbol, 0) public {
1680         require(crateOpener != address(0));
1681 
1682         _uri = uri;
1683         _crateOpener = crateOpener;
1684         _lotId = lotId;
1685     }
1686 
1687     function burn(uint256 amount) public {
1688         _burn(_msgSender(), amount);
1689         ICrateOpenEmitter(_crateOpener).openCrate(_msgSender(), _lotId, amount);
1690     }
1691 
1692     function burnFrom(address account, uint256 amount) public {
1693         _burnFrom(account, amount);
1694         ICrateOpenEmitter(_crateOpener).openCrate(account, _lotId, amount);
1695     }
1696 
1697     function _mint(address account, uint256 amount) internal {
1698         _cratesIssued = _cratesIssued + amount; // not enough money in the world to cover 2 ^ 256 - 1 increments
1699         require(_cratesIssued <= cap(), "cratesIssued exceeded cap");
1700         super._mint(account, amount);
1701     }
1702 
1703     function tokenURI() public view returns (string memory) {
1704         return _uri;
1705     }
1706 
1707     function setURI(string memory uri) public onlyOwner {
1708         _uri = uri;
1709     }
1710 
1711     /////////////////////////////////////////// GSNRecipient implementation ///////////////////////////////////
1712     /**
1713      * @dev Ensures that only users with enough gas payment token balance can have transactions relayed through the GSN.
1714      */
1715     function acceptRelayedCall(
1716         address /*relay*/,
1717         address from,
1718         bytes calldata encodedFunction,
1719         uint256 /*transactionFee*/,
1720         uint256 /*gasPrice*/,
1721         uint256 /*gasLimit*/,
1722         uint256 /*nonce*/,
1723         bytes calldata /*approvalData*/,
1724         uint256 /*maxPossibleCharge*/
1725     )
1726         external
1727         view
1728         returns (uint256, bytes memory mem)
1729     {
1730         // restrict to burn function only
1731         // load methodId stored in first 4 bytes https://solidity.readthedocs.io/en/v0.5.16/abi-spec.html#function-selector-and-argument-encoding
1732         // load amount stored in the next 32 bytes https://solidity.readthedocs.io/en/v0.5.16/abi-spec.html#function-selector-and-argument-encoding
1733         // 32 bytes offset is required to skip array length
1734         bytes4 methodId;
1735         uint256 amountParam;
1736         mem = encodedFunction;
1737         assembly {
1738             let dest := add(mem, 32)
1739             methodId := mload(dest)
1740             dest := add(dest, 4)
1741             amountParam := mload(dest)
1742         }
1743 
1744         // bytes4(keccak256("burn(uint256)")) == 0x42966c68
1745         if (methodId != 0x42966c68) {
1746             return _rejectRelayedCall(uint256(ErrorCodes.RESTRICTED_METHOD));
1747         }
1748 
1749         // Check that user has enough crates to burn
1750         if (balanceOf(from) < amountParam) {
1751             return _rejectRelayedCall(uint256(ErrorCodes.INSUFFICIENT_BALANCE));
1752         }
1753 
1754         return _approveRelayedCall();
1755     }
1756 
1757     function _preRelayedCall(bytes memory) internal returns (bytes32) {
1758         // solhint-disable-previous-line no-empty-blocks
1759     }
1760 
1761     function _postRelayedCall(bytes memory, bool, uint256, bytes32) internal {
1762         // solhint-disable-previous-line no-empty-blocks
1763     }
1764 
1765     /**
1766      * @dev Withdraws the recipient's deposits in `RelayHub`.
1767      */
1768     function withdrawDeposits(uint256 amount, address payable payee) external onlyOwner {
1769         _withdrawDeposits(amount, payee);
1770     }
1771 }
1772 
1773 // File: contracts/purchase/IKyber.sol
1774 
1775 pragma solidity = 0.5.16;
1776 
1777 
1778 
1779 // https://github.com/KyberNetwork/smart-contracts/blob/master/contracts/KyberNetworkProxy.sol
1780 interface IKyber {
1781     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view
1782         returns (uint expectedRate, uint slippageRate);
1783 
1784     function trade(
1785         ERC20 src,
1786         uint srcAmount,
1787         ERC20 dest,
1788         address destAddress,
1789         uint maxDestAmount,
1790         uint minConversionRate,
1791         address walletId
1792     )
1793     external
1794     payable
1795         returns(uint);
1796 }
1797 
1798 // File: contracts/purchase/KyberAdapter.sol
1799 
1800 pragma solidity = 0.5.16;
1801 
1802 
1803 
1804 
1805 
1806 contract KyberAdapter {
1807     using SafeMath for uint256;
1808 
1809     IKyber public kyber;
1810     
1811     ERC20 public ETH_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
1812 
1813     constructor(address _kyberProxy) public {
1814         kyber = IKyber(_kyberProxy);
1815     }
1816 
1817     function () external payable {}
1818 
1819     function _getTokenDecimals(ERC20 _token) internal view returns (uint8 _decimals) {
1820         return _token != ETH_ADDRESS ? ERC20Detailed(address(_token)).decimals() : 18;
1821     }
1822 
1823     function _getTokenBalance(ERC20 _token, address _account) internal view returns (uint256 _balance) {
1824         return _token != ETH_ADDRESS ? _token.balanceOf(_account) : _account.balance;
1825     }
1826 
1827     function ceilingDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
1828         return a.div(b).add(a.mod(b) > 0 ? 1 : 0);
1829     }
1830 
1831     function _fixTokenDecimals(
1832         ERC20 _src,
1833         ERC20 _dest,
1834         uint256 _unfixedDestAmount,
1835         bool _ceiling
1836     )
1837     internal
1838     view
1839     returns (uint256 _destTokenAmount)
1840     {
1841         uint256 _unfixedDecimals = _getTokenDecimals(_src) + 18; // Kyber by default returns rates with 18 decimals.
1842         uint256 _decimals = _getTokenDecimals(_dest);
1843 
1844         if (_unfixedDecimals > _decimals) {
1845             // Divide token amount by 10^(_unfixedDecimals - _decimals) to reduce decimals.
1846             if (_ceiling) {
1847                 return ceilingDiv(_unfixedDestAmount, (10 ** (_unfixedDecimals - _decimals)));
1848             } else {
1849                 return _unfixedDestAmount.div(10 ** (_unfixedDecimals - _decimals));
1850             }
1851         } else {
1852             // Multiply token amount with 10^(_decimals - _unfixedDecimals) to increase decimals.
1853             return _unfixedDestAmount.mul(10 ** (_decimals - _unfixedDecimals));
1854         }
1855     }
1856 
1857     function _convertToken(
1858         ERC20 _src,
1859         uint256 _srcAmount,
1860         ERC20 _dest
1861     )
1862     internal
1863     view
1864     returns (
1865         uint256 _expectedAmount,
1866         uint256 _slippageAmount
1867     )
1868     {
1869         (uint256 _expectedRate, uint256 _slippageRate) = kyber.getExpectedRate(_src, _dest, _srcAmount);
1870 
1871         return (
1872             _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false),
1873             _fixTokenDecimals(_src, _dest, _srcAmount.mul(_slippageRate), false)
1874         );
1875     }
1876 
1877     function _swapTokenAndHandleChange(
1878         ERC20 _src,
1879         uint256 _maxSrcAmount,
1880         ERC20 _dest,
1881         uint256 _maxDestAmount,
1882         uint256 _minConversionRate,
1883         address payable _initiator,
1884         address payable _receiver
1885     )
1886     internal
1887     returns (
1888         uint256 _srcAmount,
1889         uint256 _destAmount
1890     )
1891     {
1892         if (_src == _dest) {
1893             // payment is made with DAI
1894             require(_maxSrcAmount >= _maxDestAmount);
1895             _destAmount = _srcAmount = _maxDestAmount;
1896             require(IERC20(_src).transferFrom(_initiator, address(this), _destAmount));
1897         } else {
1898             require(_src == ETH_ADDRESS ? msg.value >= _maxSrcAmount : msg.value == 0);
1899 
1900             // Prepare for handling back the change if there is any.
1901             uint256 _balanceBefore = _getTokenBalance(_src, address(this));
1902 
1903             if (_src != ETH_ADDRESS) {
1904                 require(IERC20(_src).transferFrom(_initiator, address(this), _maxSrcAmount));
1905                 require(IERC20(_src).approve(address(kyber), _maxSrcAmount));
1906             } else {
1907                 // Since we are going to transfer the source amount to Kyber.
1908                 _balanceBefore = _balanceBefore.sub(_maxSrcAmount);
1909             }
1910 
1911             _destAmount = kyber.trade.value(
1912                 _src == ETH_ADDRESS ? _maxSrcAmount : 0
1913             )(
1914                 _src,
1915                 _maxSrcAmount,
1916                 _dest,
1917                 _receiver,
1918                 _maxDestAmount,
1919                 _minConversionRate,
1920                 address(0)
1921             );
1922             
1923             uint256 _balanceAfter = _getTokenBalance(_src, address(this));
1924             _srcAmount = _maxSrcAmount;
1925 
1926             // Handle back the change, if there is any, to the message sender.
1927             if (_balanceAfter > _balanceBefore) {
1928                 uint256 _change = _balanceAfter - _balanceBefore;
1929                 _srcAmount = _srcAmount.sub(_change);
1930 
1931                 if (_src != ETH_ADDRESS) {
1932                     require(IERC20(_src).transfer(_initiator, _change));
1933                 } else {
1934                     _initiator.transfer(_change);
1935                 }
1936             }
1937         }
1938     }
1939 }
1940 
1941 // File: contracts/purchase/FixedSupplyCratesSale.sol
1942 
1943 pragma solidity = 0.5.16;
1944 
1945 
1946 
1947 
1948 
1949 
1950 
1951 
1952 
1953 
1954 
1955 contract FixedSupplyCratesSale is ReferrableSale, Pausable, KyberAdapter, ICrateOpenEmitter {
1956     using SafeMath for uint256;
1957 
1958     struct Lot {
1959         F1DeltaCrate crateToken;
1960         uint256 price; // in stable coin
1961     }
1962 
1963     struct PurchaseForVars {
1964         Lot lot;
1965         uint256 discount;
1966         uint256 price;
1967         uint256 referralReward;
1968         uint256 tokensSent;
1969         uint256 tokensReceived;
1970     }
1971 
1972     event Purchased (
1973         address indexed owner,
1974         address operator,
1975         uint256 indexed lotId,
1976         uint256 indexed quantity,
1977         uint256 pricePaid,
1978         address tokenAddress,
1979         uint256 tokensSent,
1980         uint256 tokensReceived,
1981         uint256 discountApplied,
1982         address referrer,
1983         uint256 referralRewarded
1984     );
1985 
1986     event LotCreated (
1987         uint256 lotId,
1988         uint256 supply,
1989         uint256 price,
1990         string uri,
1991         ERC20 crateToken
1992     );
1993 
1994     event LotPriceUpdated (
1995         uint256 lotId,
1996         uint256 price
1997     );
1998 
1999     event CrateOpened(address indexed from, uint256 lotId, uint256 amount);
2000 
2001     uint256 private constant PERCENT_PRECISION = 10000;
2002     uint256 private constant MULTI_PURCHASE_DISCOUNT_STEP = 5;
2003 
2004     ERC20 public _stableCoinAddress;
2005     address payable public _payoutWallet;
2006 
2007     mapping (uint256 => Lot) public _lots; // lotId => lot
2008     mapping (uint256 => mapping (address => address)) public _referrersByLot; // lotId => (buyer => referrer)
2009     mapping (address => mapping(uint256 => uint256)) public _cratesPurchased; // owner => (lot id => quantity)
2010 
2011     uint256 public _initialDiscountPercentage;
2012     uint256 public _initialDiscountPeriod;
2013     uint256 public _startedAt;
2014     uint256 public _multiPurchaseDiscount;
2015 
2016     modifier whenStarted() {
2017         require(_startedAt != 0);
2018         _;
2019     }
2020 
2021     modifier whenNotStarted() {
2022         require(_startedAt == 0);
2023         _;
2024     }
2025 
2026     constructor(
2027         address payable payoutWallet, 
2028         address kyberProxy, 
2029         ERC20 stableCoinAddress
2030     ) KyberAdapter(kyberProxy) public {
2031         require(payoutWallet != address(0));
2032         require(stableCoinAddress != ERC20(address(0)));
2033         setPayoutWallet(payoutWallet); 
2034 
2035         _stableCoinAddress = stableCoinAddress;
2036         pause();
2037     }
2038 
2039     function setPayoutWallet(address payable payoutWallet) public onlyOwner {
2040         require(payoutWallet != address(uint160(address(this))));
2041         _payoutWallet = payoutWallet;
2042     }
2043 
2044     function start(
2045         uint256 initialDiscountPercentage, 
2046         uint256 initialDiscountPeriod, 
2047         uint256 multiPurchaseDiscount
2048     ) 
2049     public 
2050     onlyOwner 
2051     whenNotStarted
2052     {
2053         require(initialDiscountPercentage < PERCENT_PRECISION);
2054         require(multiPurchaseDiscount < PERCENT_PRECISION);
2055 
2056         _initialDiscountPercentage = initialDiscountPercentage;
2057         _initialDiscountPeriod = initialDiscountPeriod;
2058         _multiPurchaseDiscount = multiPurchaseDiscount;
2059         
2060         // solium-disable-next-line security/no-block-members
2061         _startedAt = now;
2062         unpause();
2063     }
2064 
2065     function initialDiscountActive() public view returns (bool) {
2066         if (_initialDiscountPeriod == 0 || _initialDiscountPercentage == 0 || _startedAt == 0) {
2067             // No discount set or sale not started
2068             return false;
2069         }
2070 
2071         // solium-disable-next-line security/no-block-members
2072         uint256 elapsed = (now - _startedAt);
2073         return elapsed < _initialDiscountPeriod;
2074     }
2075 
2076     // owner can provide crate contract address which is compatible with F1DeltaCrate interface 
2077     // Make sure that crate contract has FixedSupplyCratesSale contract as minter.
2078     // if crate contract isn't provided sales contract will create simple F1DeltaCrate on it's own
2079     function createLot(
2080         uint256 lotId,
2081         uint256 supply,
2082         uint256 price,
2083         string memory name,
2084         string memory symbol,
2085         string memory uri,
2086         F1DeltaCrate crateToken
2087     ) 
2088         public 
2089         onlyOwner 
2090     {
2091         require(price != 0 && supply != 0);
2092         require(_lots[lotId].price == 0);
2093         
2094         Lot memory lot;
2095         lot.price = price;
2096         if (crateToken == F1DeltaCrate(address(0))) {
2097             lot.crateToken = new F1DeltaCrate(lotId, supply, name, symbol, uri, address(this));
2098             lot.crateToken.transferOwnership(owner());
2099             lot.crateToken.addMinter(owner());
2100         } else {
2101             lot.crateToken = crateToken;
2102         }
2103         
2104         _lots[lotId] = lot;
2105 
2106         emit LotCreated(lotId, supply, price, uri, ERC20(address(lot.crateToken)));
2107     }
2108 
2109     function updateLotPrice(uint256 lotId, uint128 price) external onlyOwner whenPaused {
2110         require(price != 0);
2111         require(_lots[lotId].price != 0);
2112         require(_lots[lotId].price != price);
2113 
2114         _lots[lotId].price = price;
2115 
2116         emit LotPriceUpdated(lotId, price);
2117     }
2118 
2119     function _nthPurchaseDiscount(uint lotPrice, uint quantity, uint cratesPurchased) private view returns(uint) {
2120         uint discountsApplied = cratesPurchased / MULTI_PURCHASE_DISCOUNT_STEP;
2121         uint discountsToApply = (cratesPurchased + quantity) / MULTI_PURCHASE_DISCOUNT_STEP - discountsApplied;
2122 
2123         return lotPrice.mul(discountsToApply).mul(_multiPurchaseDiscount).div(PERCENT_PRECISION);
2124     }
2125 
2126     function _getPriceWithDiscounts(Lot memory lot, uint quantity, uint cratesPurchased) private view returns(uint price, uint discount) {
2127         price = lot.price.mul(quantity);
2128         // Discounts are additive
2129 
2130         // apply early bird discount
2131         if (initialDiscountActive()) {
2132             discount = price.mul(_initialDiscountPercentage).div(PERCENT_PRECISION);
2133         }
2134 
2135         // apply multi purchase discount if any
2136         discount += _nthPurchaseDiscount(lot.price, quantity, cratesPurchased);
2137         price = price.sub(discount);
2138     }
2139 
2140     function purchaseFor(
2141         address payable destination,
2142         uint256 lotId,
2143         ERC20Capped tokenAddress,
2144         uint256 quantity,
2145         uint256 maxTokenAmount,
2146         uint256 minConversionRate,
2147         address payable referrer
2148     )
2149         external 
2150         payable
2151         whenNotPaused 
2152         whenStarted
2153     {
2154         require (quantity > 0);
2155         require (referrer != destination && referrer != msg.sender); //Inefficient
2156 
2157         // hack to fit as many variables on stack as required.
2158         PurchaseForVars memory vars;
2159 
2160         vars.lot = _lots[lotId];
2161         require(vars.lot.price != 0);
2162 
2163         (vars.price, vars.discount) = _getPriceWithDiscounts(vars.lot, quantity, _cratesPurchased[destination][lotId]);
2164 
2165         (vars.tokensSent, vars.tokensReceived) = _swapTokenAndHandleChange(
2166             tokenAddress,
2167             maxTokenAmount,
2168             _stableCoinAddress,
2169             vars.price,
2170             minConversionRate,
2171             msg.sender,
2172             address(uint160(address(this)))
2173         );
2174         
2175         // Check if received enough tokens.
2176         require(vars.tokensReceived >= vars.price);
2177         
2178         if (referrer != address(0)) {
2179             bool sendReferral = true;
2180             if (_customReferralPercentages[referrer] == 0) {
2181                 // not a VIP
2182                 if (_referrersByLot[lotId][destination] == referrer) { 
2183                     // buyer already used a referrer for this item before
2184                     sendReferral = false;
2185                 }
2186             }
2187             
2188             if (sendReferral) {
2189                 vars.referralReward = vars.tokensReceived
2190                     .mul(Math.max(_customReferralPercentages[referrer], _defaultReferralPercentage))
2191                     .div(PERCENT_PRECISION);
2192 
2193                 if (vars.referralReward > 0) {
2194                     _referrersByLot[lotId][destination] = referrer;
2195                     // send stable coin as reward
2196                     require(_stableCoinAddress.transfer(referrer, vars.referralReward));
2197                 }
2198             }
2199         }
2200 
2201         vars.tokensReceived = vars.tokensReceived.sub(vars.referralReward);
2202 
2203         require(vars.lot.crateToken.mint(destination, quantity)); 
2204         require(_stableCoinAddress.transfer(_payoutWallet, vars.tokensReceived));
2205         _cratesPurchased[destination][lotId] += quantity;
2206 
2207         emit Purchased(
2208             destination,
2209             msg.sender,
2210             lotId,
2211             quantity,
2212             vars.price,
2213             address(tokenAddress),
2214             vars.tokensSent,
2215             vars.tokensReceived,
2216             vars.discount,
2217             referrer,
2218             vars.referralReward
2219         );
2220     }
2221 
2222     function getPrice(
2223         uint256 lotId,
2224         uint256 quantity,
2225         ERC20 tokenAddress,
2226         address destination
2227     )
2228     external
2229     view
2230     returns (
2231         uint256 minConversionRate,
2232         uint256 lotPrice,
2233         uint256 lotPriceWithoutDiscount
2234     )
2235     {
2236         // convert Stable Coin -> Target Token (ETH is included)
2237         lotPriceWithoutDiscount = _lots[lotId].price.mul(quantity);
2238         (uint totalPrice, ) = _getPriceWithDiscounts(_lots[lotId], quantity, _cratesPurchased[destination][lotId]);
2239 
2240         (, uint tokenAmount) = _convertToken(_stableCoinAddress, totalPrice, tokenAddress);
2241         (, minConversionRate) = kyber.getExpectedRate(tokenAddress, _stableCoinAddress, tokenAmount);
2242         lotPrice = ceilingDiv(totalPrice.mul(10**36), minConversionRate);
2243         lotPrice = _fixTokenDecimals(_stableCoinAddress, tokenAddress, lotPrice, true);
2244 
2245         lotPriceWithoutDiscount = ceilingDiv(lotPriceWithoutDiscount.mul(10**36), minConversionRate);
2246         lotPriceWithoutDiscount = _fixTokenDecimals(_stableCoinAddress, tokenAddress, lotPriceWithoutDiscount, true);
2247     }
2248 
2249     function openCrate(address from, uint256 lotId, uint256 amount) external {
2250         require(address(_lots[lotId].crateToken) == msg.sender);
2251         for (uint256 i = 0; i < amount; i++ ) {
2252             emit CrateOpened(from, lotId, 1);
2253         }
2254     }
2255 
2256     // /**
2257     //  * @dev Withdraws the recipient's deposits in `RelayHub`.
2258     //  */
2259     // function withdrawDepositsForLot(uint256 lotId, uint256 amount, address payable payee) external onlyOwner {
2260     //     lots[lotId].crateToken.withdrawDeposits(amount, payee);
2261     // }
2262 }