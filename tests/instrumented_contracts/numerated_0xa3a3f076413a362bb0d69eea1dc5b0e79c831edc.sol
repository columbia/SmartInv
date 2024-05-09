1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-03
3 */
4 
5 /* solhint-disable no-mix-tabs-and-spaces */
6 /* solhint-disable indent */
7 
8 pragma solidity 0.5.15;
9 
10 
11 
12 /**
13  * @dev Interface of the ERC165 standard, as defined in the
14  * https://eips.ethereum.org/EIPS/eip-165[EIP].
15  *
16  * Implementers can declare support of contract interfaces, which can then be
17  * queried by others ({ERC165Checker}).
18  *
19  * For an implementation, see {ERC165}.
20  */
21 interface IERC165 {
22     /**
23      * @dev Returns true if this contract implements the interface defined by
24      * `interfaceId`. See the corresponding
25      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
26      * to learn more about how these ids are created.
27      *
28      * This function call must use less than 30 000 gas.
29      */
30     function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 contract IERC721 is IERC165 {
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
40 
41     /**
42      * @dev Returns the number of NFTs in `owner`'s account.
43      */
44     function balanceOf(address owner) public view returns (uint256 balance);
45 
46     /**
47      * @dev Returns the owner of the NFT specified by `tokenId`.
48      */
49     function ownerOf(uint256 tokenId) public view returns (address owner);
50 
51     /**
52      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
53      * another (`to`).
54      *
55      *
56      *
57      * Requirements:
58      * - `from`, `to` cannot be zero.
59      * - `tokenId` must be owned by `from`.
60      * - If the caller is not `from`, it must be have been allowed to move this
61      * NFT by either {approve} or {setApprovalForAll}.
62      */
63     function safeTransferFrom(address from, address to, uint256 tokenId) public;
64     /**
65      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
66      * another (`to`).
67      *
68      * Requirements:
69      * - If the caller is not `from`, it must be approved to move this NFT by
70      * either {approve} or {setApprovalForAll}.
71      */
72     function transferFrom(address from, address to, uint256 tokenId) public;
73     function approve(address to, uint256 tokenId) public;
74     function getApproved(uint256 tokenId) public view returns (address operator);
75 
76     function setApprovalForAll(address operator, bool _approved) public;
77     function isApprovedForAll(address owner, address operator) public view returns (bool);
78 
79 
80     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
81 }
82 
83 /**
84  * @title ERC721 token receiver interface
85  * @dev Interface for any contract that wants to support safeTransfers
86  * from ERC721 asset contracts.
87  */
88 contract IERC721Receiver {
89     /**
90      * @notice Handle the receipt of an NFT
91      * @dev The ERC721 smart contract calls this function on the recipient
92      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
93      * otherwise the caller will revert the transaction. The selector to be
94      * returned can be obtained as `this.onERC721Received.selector`. This
95      * function MAY throw to revert and reject the transfer.
96      * Note: the ERC721 contract address is always the message sender.
97      * @param operator The address which called `safeTransferFrom` function
98      * @param from The address which previously owned the token
99      * @param tokenId The NFT identifier which is being transferred
100      * @param data Additional data with no specified format
101      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
102      */
103     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
104     public returns (bytes4);
105 }
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      * - Subtraction cannot overflow.
158      *
159      * _Available since v2.4.0._
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      * - The divisor cannot be zero.
216      *
217      * _Available since v2.4.0._
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         // Solidity only automatically asserts when dividing by 0
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      * - The divisor cannot be zero.
253      *
254      * _Available since v2.4.0._
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 /* solhint-disable no-mix-tabs-and-spaces */
262 /* solhint-disable indent */
263 
264 
265 
266 
267 /**
268  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
269  * the optional functions; to access them see {ERC20Detailed}.
270  */
271 interface IERC20 {
272     /**
273      * @dev Returns the amount of tokens in existence.
274      */
275     function totalSupply() external view returns (uint256);
276 
277     /**
278      * @dev Returns the amount of tokens owned by `account`.
279      */
280     function balanceOf(address account) external view returns (uint256);
281 
282     /**
283      * @dev Moves `amount` tokens from the caller's account to `recipient`.
284      *
285      * Returns a boolean value indicating whether the operation succeeded.
286      *
287      * Emits a {Transfer} event.
288      */
289     function transfer(address recipient, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Returns the remaining number of tokens that `spender` will be
293      * allowed to spend on behalf of `owner` through {transferFrom}. This is
294      * zero by default.
295      *
296      * This value changes when {approve} or {transferFrom} are called.
297      */
298     function allowance(address owner, address spender) external view returns (uint256);
299 
300     /**
301      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * IMPORTANT: Beware that changing an allowance with this method brings the risk
306      * that someone may use both the old and the new allowance by unfortunate
307      * transaction ordering. One possible solution to mitigate this race
308      * condition is to first reduce the spender's allowance to 0 and set the
309      * desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      *
312      * Emits an {Approval} event.
313      */
314     function approve(address spender, uint256 amount) external returns (bool);
315 
316     /**
317      * @dev Moves `amount` tokens from `sender` to `recipient` using the
318      * allowance mechanism. `amount` is then deducted from the caller's
319      * allowance.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Emitted when `value` tokens are moved from one account (`from`) to
329      * another (`to`).
330      *
331      * Note that `value` may be zero.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 value);
334 
335     /**
336      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
337      * a call to {approve}. `value` is the new allowance.
338      */
339     event Approval(address indexed owner, address indexed spender, uint256 value);
340 }
341 
342 /**
343  * @dev Optional functions from the ERC20 standard.
344  */
345 contract ERC20Detailed is IERC20 {
346     string private _name;
347     string private _symbol;
348     uint8 private _decimals;
349 
350     /**
351      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
352      * these values are immutable: they can only be set once during
353      * construction.
354      */
355     constructor (string memory name, string memory symbol, uint8 decimals) public {
356         _name = name;
357         _symbol = symbol;
358         _decimals = decimals;
359     }
360 
361     /**
362      * @dev Returns the name of the token.
363      */
364     function name() public view returns (string memory) {
365         return _name;
366     }
367 
368     /**
369      * @dev Returns the symbol of the token, usually a shorter version of the
370      * name.
371      */
372     function symbol() public view returns (string memory) {
373         return _symbol;
374     }
375 
376     /**
377      * @dev Returns the number of decimals used to get its user representation.
378      * For example, if `decimals` equals `2`, a balance of `505` tokens should
379      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
380      *
381      * Tokens usually opt for a value of 18, imitating the relationship between
382      * Ether and Wei.
383      *
384      * NOTE: This information is only used for _display_ purposes: it in
385      * no way affects any of the arithmetic of the contract, including
386      * {IERC20-balanceOf} and {IERC20-transfer}.
387      */
388     function decimals() public view returns (uint8) {
389         return _decimals;
390     }
391 }
392 
393 
394 
395 
396 /*
397  * @dev Provides information about the current execution context, including the
398  * sender of the transaction and its data. While these are generally available
399  * via msg.sender and msg.data, they should not be accessed in such a direct
400  * manner, since when dealing with GSN meta-transactions the account sending and
401  * paying for execution may not be the actual sender (as far as an application
402  * is concerned).
403  *
404  * This contract is only required for intermediate, library-like contracts.
405  */
406 contract Context {
407     // Empty internal constructor, to prevent people from mistakenly deploying
408     // an instance of this contract, which should be used via inheritance.
409     constructor () internal { }
410     // solhint-disable-previous-line no-empty-blocks
411 
412     function _msgSender() internal view returns (address payable) {
413         return msg.sender;
414     }
415 
416     function _msgData() internal view returns (bytes memory) {
417         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
418         return msg.data;
419     }
420 }
421 
422 /**
423  * @dev Implementation of the {IERC20} interface.
424  *
425  * This implementation is agnostic to the way tokens are created. This means
426  * that a supply mechanism has to be added in a derived contract using {_mint}.
427  * For a generic mechanism see {ERC20Mintable}.
428  *
429  * TIP: For a detailed writeup see our guide
430  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
431  * to implement supply mechanisms].
432  *
433  * We have followed general OpenZeppelin guidelines: functions revert instead
434  * of returning `false` on failure. This behavior is nonetheless conventional
435  * and does not conflict with the expectations of ERC20 applications.
436  *
437  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
438  * This allows applications to reconstruct the allowance for all accounts just
439  * by listening to said events. Other implementations of the EIP may not emit
440  * these events, as it isn't required by the specification.
441  *
442  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
443  * functions have been added to mitigate the well-known issues around setting
444  * allowances. See {IERC20-approve}.
445  */
446 contract ERC20 is Context, IERC20 {
447     using SafeMath for uint256;
448 
449     mapping (address => uint256) private _balances;
450 
451     mapping (address => mapping (address => uint256)) private _allowances;
452 
453     uint256 private _totalSupply;
454 
455     /**
456      * @dev See {IERC20-totalSupply}.
457      */
458     function totalSupply() public view returns (uint256) {
459         return _totalSupply;
460     }
461 
462     /**
463      * @dev See {IERC20-balanceOf}.
464      */
465     function balanceOf(address account) public view returns (uint256) {
466         return _balances[account];
467     }
468 
469     /**
470      * @dev See {IERC20-transfer}.
471      *
472      * Requirements:
473      *
474      * - `recipient` cannot be the zero address.
475      * - the caller must have a balance of at least `amount`.
476      */
477     function transfer(address recipient, uint256 amount) public returns (bool) {
478         _transfer(_msgSender(), recipient, amount);
479         return true;
480     }
481 
482     /**
483      * @dev See {IERC20-allowance}.
484      */
485     function allowance(address owner, address spender) public view returns (uint256) {
486         return _allowances[owner][spender];
487     }
488 
489     /**
490      * @dev See {IERC20-approve}.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      */
496     function approve(address spender, uint256 amount) public returns (bool) {
497         _approve(_msgSender(), spender, amount);
498         return true;
499     }
500 
501     /**
502      * @dev See {IERC20-transferFrom}.
503      *
504      * Emits an {Approval} event indicating the updated allowance. This is not
505      * required by the EIP. See the note at the beginning of {ERC20};
506      *
507      * Requirements:
508      * - `sender` and `recipient` cannot be the zero address.
509      * - `sender` must have a balance of at least `amount`.
510      * - the caller must have allowance for `sender`'s tokens of at least
511      * `amount`.
512      */
513     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
514         _transfer(sender, recipient, amount);
515         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
516         return true;
517     }
518 
519     /**
520      * @dev Atomically increases the allowance granted to `spender` by the caller.
521      *
522      * This is an alternative to {approve} that can be used as a mitigation for
523      * problems described in {IERC20-approve}.
524      *
525      * Emits an {Approval} event indicating the updated allowance.
526      *
527      * Requirements:
528      *
529      * - `spender` cannot be the zero address.
530      */
531     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
532         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
533         return true;
534     }
535 
536     /**
537      * @dev Atomically decreases the allowance granted to `spender` by the caller.
538      *
539      * This is an alternative to {approve} that can be used as a mitigation for
540      * problems described in {IERC20-approve}.
541      *
542      * Emits an {Approval} event indicating the updated allowance.
543      *
544      * Requirements:
545      *
546      * - `spender` cannot be the zero address.
547      * - `spender` must have allowance for the caller of at least
548      * `subtractedValue`.
549      */
550     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
551         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
552         return true;
553     }
554 
555     /**
556      * @dev Moves tokens `amount` from `sender` to `recipient`.
557      *
558      * This is internal function is equivalent to {transfer}, and can be used to
559      * e.g. implement automatic token fees, slashing mechanisms, etc.
560      *
561      * Emits a {Transfer} event.
562      *
563      * Requirements:
564      *
565      * - `sender` cannot be the zero address.
566      * - `recipient` cannot be the zero address.
567      * - `sender` must have a balance of at least `amount`.
568      */
569     function _transfer(address sender, address recipient, uint256 amount) internal {
570         require(sender != address(0), "ERC20: transfer from the zero address");
571         require(recipient != address(0), "ERC20: transfer to the zero address");
572 
573         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
574         _balances[recipient] = _balances[recipient].add(amount);
575         emit Transfer(sender, recipient, amount);
576     }
577 
578     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
579      * the total supply.
580      *
581      * Emits a {Transfer} event with `from` set to the zero address.
582      *
583      * Requirements
584      *
585      * - `to` cannot be the zero address.
586      */
587     function _mint(address account, uint256 amount) internal {
588         require(account != address(0), "ERC20: mint to the zero address");
589 
590         _totalSupply = _totalSupply.add(amount);
591         _balances[account] = _balances[account].add(amount);
592         emit Transfer(address(0), account, amount);
593     }
594 
595     /**
596      * @dev Destroys `amount` tokens from `account`, reducing the
597      * total supply.
598      *
599      * Emits a {Transfer} event with `to` set to the zero address.
600      *
601      * Requirements
602      *
603      * - `account` cannot be the zero address.
604      * - `account` must have at least `amount` tokens.
605      */
606     function _burn(address account, uint256 amount) internal {
607         require(account != address(0), "ERC20: burn from the zero address");
608 
609         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
610         _totalSupply = _totalSupply.sub(amount);
611         emit Transfer(account, address(0), amount);
612     }
613 
614     /**
615      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
616      *
617      * This is internal function is equivalent to `approve`, and can be used to
618      * e.g. set automatic allowances for certain subsystems, etc.
619      *
620      * Emits an {Approval} event.
621      *
622      * Requirements:
623      *
624      * - `owner` cannot be the zero address.
625      * - `spender` cannot be the zero address.
626      */
627     function _approve(address owner, address spender, uint256 amount) internal {
628         require(owner != address(0), "ERC20: approve from the zero address");
629         require(spender != address(0), "ERC20: approve to the zero address");
630 
631         _allowances[owner][spender] = amount;
632         emit Approval(owner, spender, amount);
633     }
634 
635     /**
636      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
637      * from the caller's allowance.
638      *
639      * See {_burn} and {_approve}.
640      */
641     function _burnFrom(address account, uint256 amount) internal {
642         _burn(account, amount);
643         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
644     }
645 }
646 
647 
648 /**
649  * @title Roles
650  * @dev Library for managing addresses assigned to a Role.
651  */
652 library Roles {
653     struct Role {
654         mapping (address => bool) bearer;
655     }
656 
657     /**
658      * @dev Give an account access to this role.
659      */
660     function add(Role storage role, address account) internal {
661         require(!has(role, account), "Roles: account already has role");
662         role.bearer[account] = true;
663     }
664 
665     /**
666      * @dev Remove an account's access to this role.
667      */
668     function remove(Role storage role, address account) internal {
669         require(has(role, account), "Roles: account does not have role");
670         role.bearer[account] = false;
671     }
672 
673     /**
674      * @dev Check if an account has this role.
675      * @return bool
676      */
677     function has(Role storage role, address account) internal view returns (bool) {
678         require(account != address(0), "Roles: account is the zero address");
679         return role.bearer[account];
680     }
681 }
682 
683 contract MinterRole is Context {
684     using Roles for Roles.Role;
685 
686     event MinterAdded(address indexed account);
687     event MinterRemoved(address indexed account);
688 
689     Roles.Role private _minters;
690 
691     constructor () internal {
692         _addMinter(_msgSender());
693     }
694 
695     modifier onlyMinter() {
696         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
697         _;
698     }
699 
700     function isMinter(address account) public view returns (bool) {
701         return _minters.has(account);
702     }
703 
704     function addMinter(address account) public onlyMinter {
705         _addMinter(account);
706     }
707 
708     function renounceMinter() public {
709         _removeMinter(_msgSender());
710     }
711 
712     function _addMinter(address account) internal {
713         _minters.add(account);
714         emit MinterAdded(account);
715     }
716 
717     function _removeMinter(address account) internal {
718         _minters.remove(account);
719         emit MinterRemoved(account);
720     }
721 }
722 
723 /**
724  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
725  * which have permission to mint (create) new tokens as they see fit.
726  *
727  * At construction, the deployer of the contract is the only minter.
728  */
729 contract ERC20Mintable is ERC20, MinterRole {
730     /**
731      * @dev See {ERC20-_mint}.
732      *
733      * Requirements:
734      *
735      * - the caller must have the {MinterRole}.
736      */
737     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
738         _mint(account, amount);
739         return true;
740     }
741 }
742 
743 /**
744  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
745  */
746 contract ERC20Capped is ERC20Mintable {
747     uint256 private _cap;
748 
749     /**
750      * @dev Sets the value of the `cap`. This value is immutable, it can only be
751      * set once during construction.
752      */
753     constructor (uint256 cap) public {
754         require(cap > 0, "ERC20Capped: cap is 0");
755         _cap = cap;
756     }
757 
758     /**
759      * @dev Returns the cap on the token's total supply.
760      */
761     function cap() public view returns (uint256) {
762         return _cap;
763     }
764 
765     /**
766      * @dev See {ERC20Mintable-mint}.
767      *
768      * Requirements:
769      *
770      * - `value` must not cause the total supply to go over the cap.
771      */
772     function _mint(address account, uint256 value) internal {
773         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
774         super._mint(account, value);
775     }
776 }
777 
778 
779 /**
780  * @dev Extension of {ERC20} that allows token holders to destroy both their own
781  * tokens and those that they have an allowance for, in a way that can be
782  * recognized off-chain (via event analysis).
783  */
784 contract ERC20Burnable is Context, ERC20 {
785     /**
786      * @dev Destroys `amount` tokens from the caller.
787      *
788      * See {ERC20-_burn}.
789      */
790     function burn(uint256 amount) public {
791         _burn(_msgSender(), amount);
792     }
793 
794     /**
795      * @dev See {ERC20-_burnFrom}.
796      */
797     function burnFrom(address account, uint256 amount) public {
798         _burnFrom(account, amount);
799     }
800 }
801 
802 
803 
804 
805 contract PauserRole is Context {
806     using Roles for Roles.Role;
807 
808     event PauserAdded(address indexed account);
809     event PauserRemoved(address indexed account);
810 
811     Roles.Role private _pausers;
812 
813     constructor () internal {
814         _addPauser(_msgSender());
815     }
816 
817     modifier onlyPauser() {
818         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
819         _;
820     }
821 
822     function isPauser(address account) public view returns (bool) {
823         return _pausers.has(account);
824     }
825 
826     function addPauser(address account) public onlyPauser {
827         _addPauser(account);
828     }
829 
830     function renouncePauser() public {
831         _removePauser(_msgSender());
832     }
833 
834     function _addPauser(address account) internal {
835         _pausers.add(account);
836         emit PauserAdded(account);
837     }
838 
839     function _removePauser(address account) internal {
840         _pausers.remove(account);
841         emit PauserRemoved(account);
842     }
843 }
844 
845 /**
846  * @dev Contract module which allows children to implement an emergency stop
847  * mechanism that can be triggered by an authorized account.
848  *
849  * This module is used through inheritance. It will make available the
850  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
851  * the functions of your contract. Note that they will not be pausable by
852  * simply including this module, only once the modifiers are put in place.
853  */
854 contract Pausable is Context, PauserRole {
855     /**
856      * @dev Emitted when the pause is triggered by a pauser (`account`).
857      */
858     event Paused(address account);
859 
860     /**
861      * @dev Emitted when the pause is lifted by a pauser (`account`).
862      */
863     event Unpaused(address account);
864 
865     bool private _paused;
866 
867     /**
868      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
869      * to the deployer.
870      */
871     constructor () internal {
872         _paused = false;
873     }
874 
875     /**
876      * @dev Returns true if the contract is paused, and false otherwise.
877      */
878     function paused() public view returns (bool) {
879         return _paused;
880     }
881 
882     /**
883      * @dev Modifier to make a function callable only when the contract is not paused.
884      */
885     modifier whenNotPaused() {
886         require(!_paused, "Pausable: paused");
887         _;
888     }
889 
890     /**
891      * @dev Modifier to make a function callable only when the contract is paused.
892      */
893     modifier whenPaused() {
894         require(_paused, "Pausable: not paused");
895         _;
896     }
897 
898     /**
899      * @dev Called by a pauser to pause, triggers stopped state.
900      */
901     function pause() public onlyPauser whenNotPaused {
902         _paused = true;
903         emit Paused(_msgSender());
904     }
905 
906     /**
907      * @dev Called by a pauser to unpause, returns to normal state.
908      */
909     function unpause() public onlyPauser whenPaused {
910         _paused = false;
911         emit Unpaused(_msgSender());
912     }
913 }
914 
915 /**
916  * @title Pausable token
917  * @dev ERC20 with pausable transfers and allowances.
918  *
919  * Useful if you want to stop trades until the end of a crowdsale, or have
920  * an emergency switch for freezing all token transfers in the event of a large
921  * bug.
922  */
923 contract ERC20Pausable is ERC20, Pausable {
924     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
925         return super.transfer(to, value);
926     }
927 
928     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
929         return super.transferFrom(from, to, value);
930     }
931 
932     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
933         return super.approve(spender, value);
934     }
935 
936     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
937         return super.increaseAllowance(spender, addedValue);
938     }
939 
940     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
941         return super.decreaseAllowance(spender, subtractedValue);
942     }
943 }
944 /* solhint-disable no-mix-tabs-and-spaces */
945 /* solhint-disable indent */
946 
947 
948 
949 /**
950 	* @title Contract managing Shotgun Clause lifecycle
951 	* @author Joel Hubert (Metalith.io)
952 	* @dev OpenZeppelin contracts are not ready for 0.6.0 yet, using 0.5.16.
953 	* @dev This contract is deployed once a Shotgun is initiated by calling the Registry.
954 	*/
955 
956 contract ShotgunClause {
957 
958 	using SafeMath for uint256;
959 
960 	ShardGovernor private _shardGovernor;
961 	ShardRegistry private _shardRegistry;
962 
963 	enum ClaimWinner { None, Claimant, Counterclaimant }
964 	ClaimWinner private _claimWinner = ClaimWinner.None;
965 
966 	uint private _deadlineTimestamp;
967 	uint private _initialOfferInWei;
968 	uint private _pricePerShardInWei;
969 	address payable private _initialClaimantAddress;
970 	uint private _initialClaimantBalance;
971 	bool private _shotgunEnacted = false;
972 	uint private _counterWeiContributed;
973 	address[] private _counterclaimants;
974 	mapping(address => uint) private _counterclaimContribs;
975 
976 	event Countercommit(address indexed committer, uint indexed weiAmount);
977 	event EtherCollected(address indexed collector, uint indexed weiAmount);
978 
979 	constructor(
980 		address payable initialClaimantAddress,
981 		uint initialClaimantBalance,
982 		address shardRegistryAddress
983 	) public payable {
984 		_shardGovernor = ShardGovernor(msg.sender);
985 		_shardRegistry = ShardRegistry(shardRegistryAddress);
986 		_deadlineTimestamp = now.add(1 * 14 days);
987 		_initialClaimantAddress = initialClaimantAddress;
988 		_initialClaimantBalance = initialClaimantBalance;
989 		_initialOfferInWei = msg.value;
990 		_pricePerShardInWei = (_initialOfferInWei.mul(10**18)).div(_shardRegistry.cap().sub(_initialClaimantBalance));
991 		_claimWinner = ClaimWinner.Claimant;
992 	}
993 
994 	/**
995 		* @notice Contribute Ether to the counterclaim for this Shotgun.
996 		* @dev Automatically enacts Shotgun once enough Ether is raised and
997 		returns initial claimant's Ether offer.
998 		*/
999 	function counterCommitEther() external payable {
1000 		require(
1001 			_shardRegistry.balanceOf(msg.sender) > 0,
1002 			"[counterCommitEther] Account does not own Shards"
1003 		);
1004 		require(
1005 			msg.value > 0,
1006 			"[counterCommitEther] Ether is required"
1007 		);
1008 		require(
1009 			_initialClaimantAddress != address(0),
1010 			"[counterCommitEther] Initial claimant does not exist"
1011 		);
1012 		require(
1013 			msg.sender != _initialClaimantAddress,
1014 			"[counterCommitEther] Initial claimant cannot countercommit"
1015 		);
1016 		require(
1017 			!_shotgunEnacted,
1018 			"[counterCommitEther] Shotgun already enacted"
1019 		);
1020 		require(
1021 			now < _deadlineTimestamp,
1022 			"[counterCommitEther] Deadline has expired"
1023 		);
1024 		require(
1025 			msg.value + _counterWeiContributed <= getRequiredWeiForCounterclaim(),
1026 			"[counterCommitEther] Ether exceeds goal"
1027 		);
1028 		if (_counterclaimContribs[msg.sender] == 0) {
1029 			_counterclaimants.push(msg.sender);
1030 		}
1031 		_counterclaimContribs[msg.sender] = _counterclaimContribs[msg.sender].add(msg.value);
1032 		_counterWeiContributed = _counterWeiContributed.add(msg.value);
1033 		emit Countercommit(msg.sender, msg.value);
1034 		if (_counterWeiContributed == getRequiredWeiForCounterclaim()) {
1035 			_claimWinner = ClaimWinner.Counterclaimant;
1036 			enactShotgun();
1037 		}
1038 	}
1039 
1040 	/**
1041 		* @notice Collect ether from completed Shotgun.
1042 		* @dev Called by Shard Registry after burning caller's Shards.
1043 		* @dev For counterclaimants, returns both the proportional worth of their
1044 		Shards in Ether AND any counterclaim contributions they have made.
1045 		* @dev alternative: OpenZeppelin PaymentSplitter
1046 		*/
1047 	function collectEtherProceeds(uint balance, address payable caller) external {
1048 		require(
1049 			msg.sender == address(_shardRegistry),
1050 			"[collectEtherProceeds] Caller not authorized"
1051 		);
1052 		if (_claimWinner == ClaimWinner.Claimant && caller != _initialClaimantAddress) {
1053 			uint weiProceeds = (_pricePerShardInWei.mul(balance)).div(10**18);
1054 			weiProceeds = weiProceeds.add(_counterclaimContribs[caller]);
1055 			_counterclaimContribs[caller] = 0;
1056 			(bool success, ) = address(caller).call.value(weiProceeds)("");
1057 			require(success, "[collectEtherProceeds] Transfer failed.");
1058 			emit EtherCollected(caller, weiProceeds);
1059 		} else if (_claimWinner == ClaimWinner.Counterclaimant && caller == _initialClaimantAddress) {
1060 			uint amount = (_pricePerShardInWei.mul(_initialClaimantBalance)).div(10**18);
1061 			amount = amount.add(_initialOfferInWei);
1062 			_initialClaimantBalance = 0;
1063 			(bool success, ) = address(caller).call.value(amount)("");
1064 			require(success, "[collectEtherProceeds] Transfer failed.");
1065 			emit EtherCollected(caller, amount);
1066 		}
1067 	}
1068 
1069 	/**
1070 		* @notice Use by successful counterclaimants to collect Shards from initial claimant.
1071 		*/
1072 	function collectShardProceeds() external {
1073 		require(
1074 			_shotgunEnacted && _claimWinner == ClaimWinner.Counterclaimant,
1075 			"[collectShardProceeds] Shotgun has not been enacted or invalid winner"
1076 		);
1077 		require(
1078 			_counterclaimContribs[msg.sender] != 0,
1079 			"[collectShardProceeds] Account has not participated in counterclaim"
1080 		);
1081 		uint proportionContributed = (_counterclaimContribs[msg.sender].mul(10**18)).div(_counterWeiContributed);
1082 		_counterclaimContribs[msg.sender] = 0;
1083 		uint shardsToReceive = (proportionContributed.mul(_initialClaimantBalance)).div(10**18);
1084 		_shardGovernor.transferShards(msg.sender, shardsToReceive);
1085 	}
1086 
1087 	function deadlineTimestamp() external view returns (uint256) {
1088 		return _deadlineTimestamp;
1089 	}
1090 
1091 	function shotgunEnacted() external view returns (bool) {
1092 		return _shotgunEnacted;
1093 	}
1094 
1095 	function initialClaimantAddress() external view returns (address) {
1096 		return _initialClaimantAddress;
1097 	}
1098 
1099 	function initialClaimantBalance() external view returns (uint) {
1100 		return _initialClaimantBalance;
1101 	}
1102 
1103 	function initialOfferInWei() external view returns (uint256) {
1104 		return _initialOfferInWei;
1105 	}
1106 
1107 	function pricePerShardInWei() external view returns (uint256) {
1108 		return _pricePerShardInWei;
1109 	}
1110 
1111 	function claimWinner() external view returns (ClaimWinner) {
1112 		return _claimWinner;
1113 	}
1114 
1115 	function counterclaimants() external view returns (address[] memory) {
1116 		return _counterclaimants;
1117 	}
1118 
1119 	function getCounterclaimantContribution(address counterclaimant) external view returns (uint) {
1120 		return _counterclaimContribs[counterclaimant];
1121 	}
1122 
1123 	function counterWeiContributed() external view returns (uint) {
1124 		return _counterWeiContributed;
1125 	}
1126 
1127 	function getContractBalance() external view returns (uint) {
1128 		return address(this).balance;
1129 	}
1130 
1131 	function shardGovernor() external view returns (address) {
1132 		return address(_shardGovernor);
1133 	}
1134 
1135 	function getRequiredWeiForCounterclaim() public view returns (uint) {
1136 		return (_pricePerShardInWei.mul(_initialClaimantBalance)).div(10**18);
1137 	}
1138 
1139 	/**
1140 		* @notice Initiate Shotgun enactment.
1141 		* @dev Automatically called if enough Ether is raised by counterclaimants,
1142 		or manually called if deadline expires without successful counterclaim.
1143 		*/
1144 	function enactShotgun() public {
1145 		require(
1146 			!_shotgunEnacted,
1147 			"[enactShotgun] Shotgun already enacted"
1148 		);
1149 		require(
1150 			_claimWinner == ClaimWinner.Counterclaimant ||
1151 			(_claimWinner == ClaimWinner.Claimant && now > _deadlineTimestamp),
1152 			"[enactShotgun] Conditions not met to enact Shotgun Clause"
1153 		);
1154 		_shotgunEnacted = true;
1155 		_shardGovernor.enactShotgun();
1156 	}
1157 }
1158 
1159 /**
1160 	* @title ERC20 base for Shards with additional methods related to governance
1161 	* @author Joel Hubert (Metalith.io)
1162 	* @dev OpenZeppelin contracts are not ready for 0.6.0 yet, using 0.5.16.
1163 	*/
1164 
1165 contract ShardRegistry is ERC20Detailed, ERC20Capped, ERC20Burnable, ERC20Pausable {
1166 
1167 	ShardGovernor private _shardGovernor;
1168 	enum ClaimWinner { None, Claimant, Counterclaimant }
1169 	bool private _shotgunDisabled;
1170 
1171 	constructor (
1172 		uint256 cap,
1173 		string memory name,
1174 		string memory symbol,
1175 		bool shotgunDisabled
1176 	) ERC20Detailed(name, symbol, 18) ERC20Capped(cap) public {
1177 		_shardGovernor = ShardGovernor(msg.sender);
1178 		_shotgunDisabled = shotgunDisabled;
1179 	}
1180 
1181 	/**
1182 		* @notice Called to initiate Shotgun claim. Requires Ether.
1183 		* @dev Transfers claimant's Shards into Governor contract's custody until
1184 		claim is resolved.
1185 		* @dev Forwards Ether to Shotgun contract through Governor contract.
1186 		*/
1187 	function lockShardsAndClaim() external payable {
1188 		require(
1189 				!_shotgunDisabled,
1190 				"[lockShardsAndClaim] Shotgun disabled"
1191 		);
1192 		require(
1193 			_shardGovernor.checkLock(),
1194 			"[lockShardsAndClaim] NFT not locked, Shotgun cannot be triggered"
1195 		);
1196 		require(
1197 			_shardGovernor.checkShotgunState(),
1198 			"[lockShardsAndClaim] Shotgun already in progress"
1199 		);
1200 		require(
1201 			msg.value > 0,
1202 			"[lockShardsAndClaim] Transaction must send ether to activate Shotgun Clause"
1203 		);
1204 		uint initialClaimantBalance = balanceOf(msg.sender);
1205 		require(
1206 			initialClaimantBalance > 0,
1207 			"[lockShardsAndClaim] Account does not own Shards"
1208 		);
1209 		require(
1210 			initialClaimantBalance < cap(),
1211 			"[lockShardsAndClaim] Account owns all Shards"
1212 		);
1213 		transfer(address(_shardGovernor), balanceOf(msg.sender));
1214 		(bool success) = _shardGovernor.claimInitialShotgun.value(msg.value)(
1215 			msg.sender, initialClaimantBalance
1216 		);
1217 		require(
1218 			success,
1219 			"[lockShards] Ether forwarding unsuccessful"
1220 		);
1221 	}
1222 
1223 	/**
1224 		* @notice Called to collect Ether from Shotgun proceeds. Burns Shard holdings.
1225 		* @dev can be called in both Shotgun outcome scenarios by:
1226 		- Initial claimant, if they lose the claim to counterclaimants and their
1227 		Shards are bought out
1228 		- Counterclaimants, bought out if initial claimant is successful.
1229 		* @dev initial claimant does not own Shards at this point because they have
1230 		been custodied in Governor contract at start of Shotgun.
1231 		* @param shotgunClause address of the relevant Shotgun contract.
1232 		*/
1233 	function burnAndCollectEther(address shotgunClause) external {
1234 		ShotgunClause _shotgunClause = ShotgunClause(shotgunClause);
1235 		bool enacted = _shotgunClause.shotgunEnacted();
1236 		if (!enacted) {
1237 			_shotgunClause.enactShotgun();
1238 		}
1239 		require(
1240 			enacted || _shotgunClause.shotgunEnacted(),
1241 			"[burnAndCollectEther] Shotgun Clause not enacted"
1242 		);
1243 		uint balance = balanceOf(msg.sender);
1244 		require(
1245 			balance > 0 || msg.sender == _shotgunClause.initialClaimantAddress(),
1246 			"[burnAndCollectEther] Account does not own Shards"
1247 		);
1248 		require(
1249 			uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Claimant) &&
1250 			msg.sender != _shotgunClause.initialClaimantAddress() ||
1251 			uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Counterclaimant) &&
1252 			msg.sender == _shotgunClause.initialClaimantAddress(),
1253 			"[burnAndCollectEther] Account does not have right to collect ether"
1254 		);
1255 		burn(balance);
1256 		_shotgunClause.collectEtherProceeds(balance, msg.sender);
1257 	}
1258 
1259 	function shotgunDisabled() external view returns (bool) {
1260 		return _shotgunDisabled;
1261 	}
1262 }
1263 /* solhint-disable no-mix-tabs-and-spaces */
1264 /* solhint-disable indent */
1265 
1266 
1267 
1268 /**
1269 	* @title Contract managing Shard Offering lifecycle, similar to a crowdsale.
1270 	* @author Joel Hubert (Metalith.io)
1271 	* @dev OpenZeppelin contracts are not ready for 0.6.0 yet, using 0.5.16.
1272 	* @dev Acts as a wallet containing subscriber Ether.
1273 	*/
1274 
1275 contract ShardOffering {
1276 
1277 	using SafeMath for uint256;
1278 
1279 	ShardGovernor private _shardGovernor;
1280 	uint private _offeringDeadline;
1281 	uint private _pricePerShardInWei;
1282 	uint private _contributionTargetInWei;
1283 	uint private _liqProviderCutInShards;
1284 	uint private _artistCutInShards;
1285 	uint private _offererShardAmount;
1286 
1287 	address[] private _contributors;
1288 	mapping(address => uint) private _contributionsinWei;
1289 	mapping(address => uint) private _contributionsInShards;
1290 	mapping(address => bool) private _hasClaimedShards;
1291 	uint private _totalWeiContributed;
1292 	uint private _totalShardsClaimed;
1293 	bool private _offeringCompleted;
1294 
1295 	event Contribution(address indexed contributor, uint indexed weiAmount);
1296 	event OfferingWrappedUp();
1297 
1298 	constructor(
1299 		uint pricePerShardInWei,
1300 		uint shardAmountOffered,
1301 		uint liqProviderCutInShards,
1302 		uint artistCutInShards,
1303 		uint offeringDeadline,
1304 		uint cap
1305 	) public {
1306 		_pricePerShardInWei = pricePerShardInWei;
1307 		_liqProviderCutInShards = liqProviderCutInShards;
1308 		_artistCutInShards = artistCutInShards;
1309 		_offeringDeadline = offeringDeadline;
1310 		_shardGovernor = ShardGovernor(msg.sender);
1311 		_contributionTargetInWei = (pricePerShardInWei.mul(shardAmountOffered)).div(10**18);
1312 		_offererShardAmount = cap.sub(shardAmountOffered).sub(liqProviderCutInShards).sub(artistCutInShards);
1313 	}
1314 
1315 	/**
1316 		* @notice Contribute Ether to offering.
1317 		* @dev Blocks Offerer from contributing. May be exaggerated.
1318 		* @dev if target Ether amount is raised, automatically transfers Ether to Offerer.
1319 		*/
1320 	function contribute() external payable {
1321 		require(
1322 			!_offeringCompleted,
1323 			"[contribute] Offering is complete"
1324 		);
1325 		require(
1326 			msg.value > 0,
1327 			"[contribute] Contribution requires ether"
1328 		);
1329 		require(
1330 			msg.value <= _contributionTargetInWei - _totalWeiContributed,
1331 			"[contribute] Ether value exceeds remaining quota"
1332 		);
1333 		require(
1334 			msg.sender != _shardGovernor.offererAddress(),
1335 			"[contribute] Offerer cannot contribute"
1336 		);
1337 		require(
1338 			now < _offeringDeadline,
1339 			"[contribute] Deadline for offering expired"
1340 		);
1341 		require(
1342 			_shardGovernor.checkLock(),
1343 			"[contribute] NFT not locked yet"
1344 		);
1345 		if (_contributionsinWei[msg.sender] == 0) {
1346 			_contributors.push(msg.sender);
1347 		}
1348 		_contributionsinWei[msg.sender] = _contributionsinWei[msg.sender].add(msg.value);
1349 		uint shardAmount = (msg.value.mul(10**18)).div(_pricePerShardInWei);
1350 		_contributionsInShards[msg.sender] = _contributionsInShards[msg.sender].add(shardAmount);
1351 		_totalWeiContributed = _totalWeiContributed.add(msg.value);
1352 		_totalShardsClaimed = _totalShardsClaimed.add(shardAmount);
1353 		if (_totalWeiContributed == _contributionTargetInWei) {
1354 			_offeringCompleted = true;
1355 			(bool success, ) = _shardGovernor.offererAddress().call.value(address(this).balance)("");
1356 			require(success, "[contribute] Transfer failed.");
1357 		}
1358 		emit Contribution(msg.sender, msg.value);
1359 	}
1360 
1361 	/**
1362 		* @notice Prematurely end Offering.
1363 		* @dev Called by Governor contract when Offering deadline expires and has not
1364 		* raised the target amount of Ether.
1365 		* @dev reentrancy is guarded in _shardGovernor.checkOfferingAndIssue() by
1366 		`hasClaimedShards`.
1367 		*/
1368 	function wrapUpOffering() external {
1369 		require(
1370 			msg.sender == address(_shardGovernor),
1371 			"[wrapUpOffering] Unauthorized caller"
1372 		);
1373 		_offeringCompleted = true;
1374 		(bool success, ) = _shardGovernor.offererAddress().call.value(address(this).balance)("");
1375 		require(success, "[wrapUpOffering] Transfer failed.");
1376 		emit OfferingWrappedUp();
1377 	}
1378 
1379 	/**
1380 		* @notice Records Shard claim for subcriber.
1381 		* @dev Can only be called by Governor contract on Offering close.
1382 		* @param claimant wallet address of the person claiming the Shards they
1383 		subscribed to.
1384 		*/
1385 	function claimShards(address claimant) external {
1386 		require(
1387 			msg.sender == address(_shardGovernor),
1388 			"[claimShards] Unauthorized caller"
1389 		);
1390 		_hasClaimedShards[claimant] = true;
1391 	}
1392 
1393 	function offeringDeadline() external view returns (uint) {
1394 		return _offeringDeadline;
1395 	}
1396 
1397 	function getSubEther(address sub) external view returns (uint) {
1398 		return _contributionsinWei[sub];
1399 	}
1400 
1401 	function getSubShards(address sub) external view returns (uint) {
1402 		return _contributionsInShards[sub];
1403 	}
1404 
1405 	function hasClaimedShards(address claimant) external view returns (bool) {
1406 		return _hasClaimedShards[claimant];
1407 	}
1408 
1409 	function pricePerShardInWei() external view returns (uint) {
1410 		return _pricePerShardInWei;
1411 	}
1412 
1413 	function offererShardAmount() external view returns (uint) {
1414 		return _offererShardAmount;
1415 	}
1416 
1417 	function liqProviderCutInShards() external view returns (uint) {
1418 		return _liqProviderCutInShards;
1419 	}
1420 
1421 	function artistCutInShards() external view returns (uint) {
1422 		return _artistCutInShards;
1423 	}
1424 
1425 	function offeringCompleted() external view returns (bool) {
1426 		return _offeringCompleted;
1427 	}
1428 
1429 	function totalShardsClaimed() external view returns (uint) {
1430 		return _totalShardsClaimed;
1431 	}
1432 
1433 	function totalWeiContributed() external view returns (uint) {
1434 		return _totalWeiContributed;
1435 	}
1436 
1437 	function contributionTargetInWei() external view returns (uint) {
1438 		return _contributionTargetInWei;
1439 	}
1440 
1441 	function getContractBalance() external view returns (uint) {
1442 		return address(this).balance;
1443 	}
1444 
1445 	function contributors() external view returns (address[] memory) {
1446 		return _contributors;
1447 	}
1448 }
1449 /* solhint-disable no-mix-tabs-and-spaces */
1450 /* solhint-disable indent */
1451 
1452 
1453 interface IUniswapExchange {
1454 	function removeLiquidity(
1455 		uint256 uniTokenAmount,
1456 		uint256 minEth,
1457 		uint256 minTokens,
1458 		uint256 deadline
1459 	) external returns(
1460 		uint256, uint256
1461 	);
1462 
1463 	function transferFrom(
1464 		address from,
1465 		address to,
1466 		uint256 value
1467 	) external returns (bool);
1468 }
1469 
1470 /**
1471 	* @title Contract managing Shard lifecycle (NFT custody + Shard issuance and redemption)
1472 	* @author Joel Hubert (Metalith.io)
1473 	* @dev OpenZeppelin contracts are not ready for 0.6.0 yet, using 0.5.15.
1474 	* @dev This contract owns the Registry, Offering and any Shotgun contracts,
1475 	* making it the gateway for core state changes.
1476 	*/
1477 
1478 contract ShardGovernor is IERC721Receiver {
1479 
1480   using SafeMath for uint256;
1481 
1482 	// Equals `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1483 	bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1484 
1485 	ShardRegistry private _shardRegistry;
1486 	ShardOffering private _shardOffering;
1487 	ShotgunClause private _currentShotgunClause;
1488 	address payable private _offererAddress;
1489 	address private _nftRegistryAddress;
1490 	address payable private _niftexWalletAddress;
1491 	address payable private _artistWalletAddress;
1492 	uint256 private _tokenId;
1493 
1494 	enum ClaimWinner { None, Claimant, Counterclaimant }
1495 	address[] private _shotgunAddressArray;
1496 	mapping(address => uint) private _shotgunMapping;
1497 	uint private _shotgunCounter;
1498 
1499 	event NewShotgun(address indexed shotgun);
1500 	event ShardsClaimed(address indexed claimant, uint indexed shardAmount);
1501 	event NftRedeemed(address indexed redeemer);
1502 	event ShotgunEnacted(address indexed enactor);
1503 	event ShardsCollected(address indexed collector, uint indexed shardAmount, address indexed shotgun);
1504 
1505 	/**
1506 		* @dev Checks whether offerer indeed owns the relevant NFT.
1507 		* @dev Offering deadline starts ticking on deployment, but offerer needs to transfer
1508 		* NFT to this contract before anyone can contribute.
1509 		*/
1510   constructor(
1511 		address nftRegistryAddress,
1512 		address payable offererAddress,
1513 		uint256 tokenId,
1514 		address payable niftexWalletAddress,
1515 		address payable artistWalletAddress,
1516 		uint liqProviderCutInShards,
1517 		uint artistCutInShards,
1518 		uint pricePerShardInWei,
1519 		uint shardAmountOffered,
1520 		uint offeringDeadline,
1521 		uint256 cap,
1522 		string memory name,
1523 		string memory symbol,
1524 		bool shotgunDisabled
1525 	) public {
1526 		require(
1527 			IERC721(nftRegistryAddress).ownerOf(tokenId) == offererAddress,
1528 			"Offerer is not owner of tokenId"
1529 		);
1530 		_nftRegistryAddress = nftRegistryAddress;
1531 		_niftexWalletAddress = niftexWalletAddress;
1532 		_artistWalletAddress = artistWalletAddress;
1533 		_tokenId = tokenId;
1534 		_offererAddress = offererAddress;
1535 		_shardRegistry = new ShardRegistry(cap, name, symbol, shotgunDisabled);
1536 		_shardOffering = new ShardOffering(
1537 			pricePerShardInWei,
1538 			shardAmountOffered,
1539 			liqProviderCutInShards,
1540 			artistCutInShards,
1541 			offeringDeadline,
1542 			cap
1543 		);
1544   }
1545 
1546 	/**
1547 		* @dev Used to receive ether from the pullLiquidity function.
1548 		*/
1549 	function() external payable { }
1550 
1551 	/**
1552 		* @notice Issues Shards upon completion of Offering.
1553 		* @dev Cap should equal totalSupply when all Shards have been claimed.
1554 		* @dev The Offerer may close an undersubscribed Offering once the deadline has
1555 		* passed and claim the remaining Shards.
1556 		*/
1557 	function checkOfferingAndIssue() external {
1558 		require(
1559 			_shardRegistry.totalSupply() != _shardRegistry.cap(),
1560 			"[checkOfferingAndIssue] Shards have already been issued"
1561 		);
1562 		require(
1563 			!_shardOffering.hasClaimedShards(msg.sender),
1564 			"[checkOfferingAndIssue] You have already claimed your Shards"
1565 		);
1566 		require(
1567 			_shardOffering.offeringCompleted() ||
1568 			(now > _shardOffering.offeringDeadline() && !_shardOffering.offeringCompleted()),
1569 			"Offering not completed or deadline not expired"
1570 		);
1571 		if (_shardOffering.offeringCompleted()) {
1572 			if (_shardOffering.getSubEther(msg.sender) != 0) {
1573 				_shardOffering.claimShards(msg.sender);
1574 				uint subShards = _shardOffering.getSubShards(msg.sender);
1575 				bool success = _shardRegistry.mint(msg.sender, subShards);
1576 				require(success, "[checkOfferingAndIssue] Mint failed");
1577 				emit ShardsClaimed(msg.sender, subShards);
1578 			} else if (msg.sender == _offererAddress) {
1579 				_shardOffering.claimShards(msg.sender);
1580 				uint offShards = _shardOffering.offererShardAmount();
1581 				bool success = _shardRegistry.mint(msg.sender, offShards);
1582 				require(success, "[checkOfferingAndIssue] Mint failed");
1583 				emit ShardsClaimed(msg.sender, offShards);
1584 			}
1585 		} else {
1586 			_shardOffering.wrapUpOffering();
1587 			uint remainingShards = _shardRegistry.cap().sub(_shardOffering.totalShardsClaimed());
1588 			remainingShards = remainingShards
1589 				.sub(_shardOffering.liqProviderCutInShards())
1590 				.sub(_shardOffering.artistCutInShards());
1591 			bool success = _shardRegistry.mint(_offererAddress, remainingShards);
1592 			require(success, "[checkOfferingAndIssue] Mint failed");
1593 			emit ShardsClaimed(msg.sender, remainingShards);
1594 		}
1595 	}
1596 
1597 	/**
1598 		* @notice Used by NIFTEX to claim predetermined amount of shards in offering in order
1599 		* to bootstrap liquidity on Uniswap-type exchange.
1600 		*/
1601 	/* function claimLiqProviderShards() external {
1602 		require(
1603 			msg.sender == _niftexWalletAddress,
1604 			"[claimLiqProviderShards] Unauthorized caller"
1605 		);
1606 		require(
1607 			!_shardOffering.hasClaimedShards(msg.sender),
1608 			"[claimLiqProviderShards] You have already claimed your Shards"
1609 		);
1610 		require(
1611 			_shardOffering.offeringCompleted(),
1612 			"[claimLiqProviderShards] Offering not completed"
1613 		);
1614 		_shardOffering.claimShards(_niftexWalletAddress);
1615 		uint cut = _shardOffering.liqProviderCutInShards();
1616 		bool success = _shardRegistry.mint(_niftexWalletAddress, cut);
1617 		require(success, "[claimLiqProviderShards] Mint failed");
1618 		emit ShardsClaimed(msg.sender, cut);
1619 	} */
1620 
1621 	function mintReservedShards(address _beneficiary) external {
1622 		bool niftex;
1623 		if (_beneficiary == _niftexWalletAddress) niftex = true;
1624 		require(
1625 			niftex ||
1626 			_beneficiary == _artistWalletAddress,
1627 			"[mintReservedShards] Unauthorized beneficiary"
1628 		);
1629 		require(
1630 			!_shardOffering.hasClaimedShards(_beneficiary),
1631 			"[mintReservedShards] Shards already claimed"
1632 		);
1633 		_shardOffering.claimShards(_beneficiary);
1634 		uint cut;
1635 		if (niftex) {
1636 			cut = _shardOffering.liqProviderCutInShards();
1637 		} else {
1638 			cut = _shardOffering.artistCutInShards();
1639 		}
1640 		bool success = _shardRegistry.mint(_beneficiary, cut);
1641 		require(success, "[mintReservedShards] Mint failed");
1642 		emit ShardsClaimed(_beneficiary, cut);
1643 	}
1644 
1645 	/**
1646 		* @notice In the unlikely case that one account accumulates all Shards,
1647 		* they can be redeemed directly for the underlying NFT.
1648 		*/
1649 	function redeem() external {
1650 		require(
1651 			_shardRegistry.balanceOf(msg.sender) == _shardRegistry.cap(),
1652 			"[redeem] Account does not own total amount of Shards outstanding"
1653 		);
1654 		IERC721(_nftRegistryAddress).safeTransferFrom(address(this), msg.sender, _tokenId);
1655 		emit NftRedeemed(msg.sender);
1656 	}
1657 
1658 	/**
1659 		* @notice Creates a new Shotgun claim.
1660 		* @dev This Function is called from the Shard Registry because the claimant's
1661 		* Shards must be frozen until the Shotgun is resolved: if they lose the claim,
1662 		* their Shards are automatically distributed to the counterclaimants.
1663 		* @dev The Registry is paused while an active Shotgun claim exists to
1664 		* let the process work in an orderly manner.
1665 		* @param initialClaimantAddress wallet address of the person who initiated Shotgun.
1666 		* @param initialClaimantBalance Shard balance of the person who initiated Shotgun.
1667 		*/
1668 	function claimInitialShotgun(
1669 		address payable initialClaimantAddress,
1670 		uint initialClaimantBalance
1671 	) external payable returns (bool) {
1672 		require(
1673 			msg.sender == address(_shardRegistry),
1674 			"[claimInitialShotgun] Caller not authorized"
1675 		);
1676 		_currentShotgunClause = (new ShotgunClause).value(msg.value)(
1677 			initialClaimantAddress,
1678 			initialClaimantBalance,
1679 			address(_shardRegistry)
1680 		);
1681 		emit NewShotgun(address(_currentShotgunClause));
1682 		_shardRegistry.pause();
1683 		_shotgunAddressArray.push(address(_currentShotgunClause));
1684 		_shotgunCounter++;
1685 		_shotgunMapping[address(_currentShotgunClause)] = _shotgunCounter;
1686 		return true;
1687 	}
1688 
1689 	/**
1690 		* @notice Effects the results of a (un)successful Shotgun claim.
1691 		* @dev This Function can only be called by a Shotgun contract in two scenarios:
1692 		* - Counterclaimants raise enough ether to buy claimant out
1693 		* - Shotgun deadline passes without successful counter-raise, claimant wins
1694 		*/
1695 	function enactShotgun() external {
1696 		require(
1697 			_shotgunMapping[msg.sender] != 0,
1698 			"[enactShotgun] Invalid Shotgun Clause"
1699 		);
1700 		ShotgunClause _shotgunClause = ShotgunClause(msg.sender);
1701 		address initialClaimantAddress = _shotgunClause.initialClaimantAddress();
1702 		if (uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Claimant)) {
1703 			_shardRegistry.burn(_shardRegistry.balanceOf(initialClaimantAddress));
1704 			IERC721(_nftRegistryAddress).safeTransferFrom(address(this), initialClaimantAddress, _tokenId);
1705 			_shardRegistry.unpause();
1706 			emit ShotgunEnacted(address(_shotgunClause));
1707 		} else if (uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Counterclaimant)) {
1708 			_shardRegistry.unpause();
1709 			emit ShotgunEnacted(address(_shotgunClause));
1710 		}
1711 	}
1712 
1713 	/**
1714 		* @notice Transfer Shards to counterclaimants after unsuccessful Shotgun claim.
1715 		* @dev This contract custodies the claimant's Shards when they claim Shotgun -
1716 		* if they lose the claim these Shards must be transferred to counterclaimants.
1717 		* This process is initiated by the relevant Shotgun contract.
1718 		* @param recipient wallet address of the person receiving the Shards.
1719 		* @param amount the amount of Shards to receive.
1720 		*/
1721 	function transferShards(address recipient, uint amount) external {
1722 		require(
1723 			_shotgunMapping[msg.sender] != 0,
1724 			"[transferShards] Unauthorized caller"
1725 		);
1726 		bool success = _shardRegistry.transfer(recipient, amount);
1727 		require(success, "[transferShards] Transfer failed");
1728 		emit ShardsCollected(recipient, amount, msg.sender);
1729 	}
1730 
1731 	/**
1732 		* @notice Allows liquidity providers to pull funds during shotgun.
1733 		* @dev Requires Unitokens to be sent to the contract so the contract can
1734 		* remove liquidity.
1735 		* @param exchangeAddress address of the Uniswap pool.
1736 		* @param liqProvAddress address of the liquidity provider.
1737 		* @param uniTokenAmount liquidity tokens to redeem.
1738 		* @param minEth minimum ether to withdraw.
1739 		* @param minTokens minimum tokens to withdraw.
1740 		* @param deadline deadline for the withdrawal.
1741 		*/
1742 	function pullLiquidity(
1743 		address exchangeAddress,
1744 		address liqProvAddress,
1745 		uint256 uniTokenAmount,
1746 		uint256 minEth,
1747 		uint256 minTokens,
1748 		uint256 deadline
1749 	) public {
1750 		require(msg.sender == _niftexWalletAddress, "[pullLiquidity] Unauthorized call");
1751 		IUniswapExchange uniExchange = IUniswapExchange(exchangeAddress);
1752 		uniExchange.transferFrom(liqProvAddress, address(this), uniTokenAmount);
1753 		_shardRegistry.unpause();
1754 		(uint ethAmount, uint tokenAmount) = uniExchange.removeLiquidity(uniTokenAmount, minEth, minTokens, deadline);
1755 		(bool ethSuccess, ) = liqProvAddress.call.value(ethAmount)("");
1756 		require(ethSuccess, "[pullLiquidity] ETH transfer failed.");
1757 		bool tokenSuccess = _shardRegistry.transfer(liqProvAddress, tokenAmount);
1758 		require(tokenSuccess, "[pullLiquidity] Token transfer failed");
1759 		_shardRegistry.pause();
1760 	}
1761 
1762 	/**
1763 		* @dev Utility function to check if a Shotgun is in progress.
1764 		*/
1765 	function checkShotgunState() external view returns (bool) {
1766 		if (_shotgunCounter == 0) {
1767 			return true;
1768 		} else {
1769 			ShotgunClause _shotgunClause = ShotgunClause(_shotgunAddressArray[_shotgunCounter - 1]);
1770 			if (_shotgunClause.shotgunEnacted()) {
1771 				return true;
1772 			} else {
1773 				return false;
1774 			}
1775 		}
1776 	}
1777 
1778 	function currentShotgunClause() external view returns (address) {
1779 		return address(_currentShotgunClause);
1780 	}
1781 
1782 	function shardRegistryAddress() external view returns (address) {
1783 		return address(_shardRegistry);
1784 	}
1785 
1786 	function shardOfferingAddress() external view returns (address) {
1787 		return address(_shardOffering);
1788 	}
1789 
1790 	function getContractBalance() external view returns (uint) {
1791 		return address(this).balance;
1792 	}
1793 
1794 	function offererAddress() external view returns (address payable) {
1795 		return _offererAddress;
1796 	}
1797 
1798 	function shotgunCounter() external view returns (uint) {
1799 		return _shotgunCounter;
1800 	}
1801 
1802 	function shotgunAddressArray() external view returns (address[] memory) {
1803 		return _shotgunAddressArray;
1804 	}
1805 
1806 	/**
1807 		* @dev Utility function to check whether this contract owns the Sharded NFT.
1808 		*/
1809 	function checkLock() external view returns (bool) {
1810 		address owner = IERC721(_nftRegistryAddress).ownerOf(_tokenId);
1811 		return owner == address(this);
1812 	}
1813 
1814 	/**
1815 		* @notice Handle the receipt of an NFT.
1816 		* @dev The ERC721 smart contract calls this function on the recipient
1817 		* after a `safetransfer`. This function MAY throw to revert and reject the
1818 		* transfer. Return of other than the magic value MUST result in the
1819 		* transaction being reverted.
1820 		* Note: the contract address is always the message sender.
1821 		* @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1822 		*/
1823 	function onERC721Received(address, address, uint256, bytes memory) public returns(bytes4) {
1824 		return _ERC721_RECEIVED;
1825 	}
1826 }