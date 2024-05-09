1 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.2 <0.8.0;
6 
7 /**
8  * @dev Library used to query support of an interface declared via {IERC165}.
9  *
10  * Note that these functions return the actual result of the query: they do not
11  * `revert` if an interface is not supported. It is up to the caller to decide
12  * what to do in these cases.
13  */
14 library ERC165Checker {
15     // As per the EIP-165 spec, no interface should ever match 0xffffffff
16     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
17 
18     /*
19      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
20      */
21     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
22 
23     /**
24      * @dev Returns true if `account` supports the {IERC165} interface,
25      */
26     function supportsERC165(address account) internal view returns (bool) {
27         // Any contract that implements ERC165 must explicitly indicate support of
28         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
29         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
30             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
31     }
32 
33     /**
34      * @dev Returns true if `account` supports the interface defined by
35      * `interfaceId`. Support for {IERC165} itself is queried automatically.
36      *
37      * See {IERC165-supportsInterface}.
38      */
39     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
40         // query support of both ERC165 as per the spec and support of _interfaceId
41         return supportsERC165(account) &&
42             _supportsERC165Interface(account, interfaceId);
43     }
44 
45     /**
46      * @dev Returns true if `account` supports all the interfaces defined in
47      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
48      *
49      * Batch-querying can lead to gas savings by skipping repeated checks for
50      * {IERC165} support.
51      *
52      * See {IERC165-supportsInterface}.
53      */
54     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
55         // query support of ERC165 itself
56         if (!supportsERC165(account)) {
57             return false;
58         }
59 
60         // query support of each interface in _interfaceIds
61         for (uint256 i = 0; i < interfaceIds.length; i++) {
62             if (!_supportsERC165Interface(account, interfaceIds[i])) {
63                 return false;
64             }
65         }
66 
67         // all interfaces supported
68         return true;
69     }
70 
71     /**
72      * @notice Query if a contract implements an interface, does not check ERC165 support
73      * @param account The address of the contract to query for support of an interface
74      * @param interfaceId The interface identifier, as specified in ERC-165
75      * @return true if the contract at account indicates support of the interface with
76      * identifier interfaceId, false otherwise
77      * @dev Assumes that account contains a contract that supports ERC165, otherwise
78      * the behavior of this method is undefined. This precondition can be checked
79      * with {supportsERC165}.
80      * Interface identification is specified in ERC-165.
81      */
82     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
83         // success determines whether the staticcall succeeded and result determines
84         // whether the contract at account indicates support of _interfaceId
85         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
86 
87         return (success && result);
88     }
89 
90     /**
91      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
92      * @param account The address of the contract to query for support of an interface
93      * @param interfaceId The interface identifier, as specified in ERC-165
94      * @return success true if the STATICCALL succeeded, false otherwise
95      * @return result true if the STATICCALL succeeded and the contract at account
96      * indicates support of the interface with identifier interfaceId, false otherwise
97      */
98     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
99         private
100         view
101         returns (bool, bool)
102     {
103         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
104         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
105         if (result.length < 32) return (false, false);
106         return (success, abi.decode(result, (bool)));
107     }
108 }
109 
110 // File: @openzeppelin/contracts/GSN/Context.sol
111 
112 
113 
114 pragma solidity >=0.6.0 <0.8.0;
115 
116 /*
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with GSN meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address payable) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes memory) {
132         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
133         return msg.data;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
138 
139 
140 
141 pragma solidity >=0.6.0 <0.8.0;
142 
143 /**
144  * @dev Interface of the ERC20 standard as defined in the EIP.
145  */
146 interface IERC20 {
147     /**
148      * @dev Returns the amount of tokens in existence.
149      */
150     function totalSupply() external view returns (uint256);
151 
152     /**
153      * @dev Returns the amount of tokens owned by `account`.
154      */
155     function balanceOf(address account) external view returns (uint256);
156 
157     /**
158      * @dev Moves `amount` tokens from the caller's account to `recipient`.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transfer(address recipient, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Returns the remaining number of tokens that `spender` will be
168      * allowed to spend on behalf of `owner` through {transferFrom}. This is
169      * zero by default.
170      *
171      * This value changes when {approve} or {transferFrom} are called.
172      */
173     function allowance(address owner, address spender) external view returns (uint256);
174 
175     /**
176      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * IMPORTANT: Beware that changing an allowance with this method brings the risk
181      * that someone may use both the old and the new allowance by unfortunate
182      * transaction ordering. One possible solution to mitigate this race
183      * condition is to first reduce the spender's allowance to 0 and set the
184      * desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      *
187      * Emits an {Approval} event.
188      */
189     function approve(address spender, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Moves `amount` tokens from `sender` to `recipient` using the
193      * allowance mechanism. `amount` is then deducted from the caller's
194      * allowance.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Emitted when `value` tokens are moved from one account (`from`) to
204      * another (`to`).
205      *
206      * Note that `value` may be zero.
207      */
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 
210     /**
211      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
212      * a call to {approve}. `value` is the new allowance.
213      */
214     event Approval(address indexed owner, address indexed spender, uint256 value);
215 }
216 
217 // File: @openzeppelin/contracts/math/SafeMath.sol
218 
219 
220 
221 pragma solidity >=0.6.0 <0.8.0;
222 
223 /**
224  * @dev Wrappers over Solidity's arithmetic operations with added overflow
225  * checks.
226  *
227  * Arithmetic operations in Solidity wrap on overflow. This can easily result
228  * in bugs, because programmers usually assume that an overflow raises an
229  * error, which is the standard behavior in high level programming languages.
230  * `SafeMath` restores this intuition by reverting the transaction when an
231  * operation overflows.
232  *
233  * Using this library instead of the unchecked operations eliminates an entire
234  * class of bugs, so it's recommended to use it always.
235  */
236 library SafeMath {
237     /**
238      * @dev Returns the addition of two unsigned integers, reverting on
239      * overflow.
240      *
241      * Counterpart to Solidity's `+` operator.
242      *
243      * Requirements:
244      *
245      * - Addition cannot overflow.
246      */
247     function add(uint256 a, uint256 b) internal pure returns (uint256) {
248         uint256 c = a + b;
249         require(c >= a, "SafeMath: addition overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the subtraction of two unsigned integers, reverting on
256      * overflow (when the result is negative).
257      *
258      * Counterpart to Solidity's `-` operator.
259      *
260      * Requirements:
261      *
262      * - Subtraction cannot overflow.
263      */
264     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
265         return sub(a, b, "SafeMath: subtraction overflow");
266     }
267 
268     /**
269      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
270      * overflow (when the result is negative).
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      *
276      * - Subtraction cannot overflow.
277      */
278     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b <= a, errorMessage);
280         uint256 c = a - b;
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the multiplication of two unsigned integers, reverting on
287      * overflow.
288      *
289      * Counterpart to Solidity's `*` operator.
290      *
291      * Requirements:
292      *
293      * - Multiplication cannot overflow.
294      */
295     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
296         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
297         // benefit is lost if 'b' is also tested.
298         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
299         if (a == 0) {
300             return 0;
301         }
302 
303         uint256 c = a * b;
304         require(c / a == b, "SafeMath: multiplication overflow");
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the integer division of two unsigned integers. Reverts on
311      * division by zero. The result is rounded towards zero.
312      *
313      * Counterpart to Solidity's `/` operator. Note: this function uses a
314      * `revert` opcode (which leaves remaining gas untouched) while Solidity
315      * uses an invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function div(uint256 a, uint256 b) internal pure returns (uint256) {
322         return div(a, b, "SafeMath: division by zero");
323     }
324 
325     /**
326      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
327      * division by zero. The result is rounded towards zero.
328      *
329      * Counterpart to Solidity's `/` operator. Note: this function uses a
330      * `revert` opcode (which leaves remaining gas untouched) while Solidity
331      * uses an invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         require(b > 0, errorMessage);
339         uint256 c = a / b;
340         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
341 
342         return c;
343     }
344 
345     /**
346      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
347      * Reverts when dividing by zero.
348      *
349      * Counterpart to Solidity's `%` operator. This function uses a `revert`
350      * opcode (which leaves remaining gas untouched) while Solidity uses an
351      * invalid opcode to revert (consuming all remaining gas).
352      *
353      * Requirements:
354      *
355      * - The divisor cannot be zero.
356      */
357     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
358         return mod(a, b, "SafeMath: modulo by zero");
359     }
360 
361     /**
362      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
363      * Reverts with custom message when dividing by zero.
364      *
365      * Counterpart to Solidity's `%` operator. This function uses a `revert`
366      * opcode (which leaves remaining gas untouched) while Solidity uses an
367      * invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
374         require(b != 0, errorMessage);
375         return a % b;
376     }
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
380 
381 
382 
383 pragma solidity >=0.6.0 <0.8.0;
384 
385 
386 
387 
388 /**
389  * @dev Implementation of the {IERC20} interface.
390  *
391  * This implementation is agnostic to the way tokens are created. This means
392  * that a supply mechanism has to be added in a derived contract using {_mint}.
393  * For a generic mechanism see {ERC20PresetMinterPauser}.
394  *
395  * TIP: For a detailed writeup see our guide
396  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
397  * to implement supply mechanisms].
398  *
399  * We have followed general OpenZeppelin guidelines: functions revert instead
400  * of returning `false` on failure. This behavior is nonetheless conventional
401  * and does not conflict with the expectations of ERC20 applications.
402  *
403  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
404  * This allows applications to reconstruct the allowance for all accounts just
405  * by listening to said events. Other implementations of the EIP may not emit
406  * these events, as it isn't required by the specification.
407  *
408  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
409  * functions have been added to mitigate the well-known issues around setting
410  * allowances. See {IERC20-approve}.
411  */
412 contract ERC20 is Context, IERC20 {
413     using SafeMath for uint256;
414 
415     mapping (address => uint256) private _balances;
416 
417     mapping (address => mapping (address => uint256)) private _allowances;
418 
419     uint256 private _totalSupply;
420 
421     string private _name;
422     string private _symbol;
423     uint8 private _decimals;
424 
425     /**
426      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
427      * a default value of 18.
428      *
429      * To select a different value for {decimals}, use {_setupDecimals}.
430      *
431      * All three of these values are immutable: they can only be set once during
432      * construction.
433      */
434     constructor (string memory name_, string memory symbol_) public {
435         _name = name_;
436         _symbol = symbol_;
437         _decimals = 18;
438     }
439 
440     /**
441      * @dev Returns the name of the token.
442      */
443     function name() public view returns (string memory) {
444         return _name;
445     }
446 
447     /**
448      * @dev Returns the symbol of the token, usually a shorter version of the
449      * name.
450      */
451     function symbol() public view returns (string memory) {
452         return _symbol;
453     }
454 
455     /**
456      * @dev Returns the number of decimals used to get its user representation.
457      * For example, if `decimals` equals `2`, a balance of `505` tokens should
458      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
459      *
460      * Tokens usually opt for a value of 18, imitating the relationship between
461      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
462      * called.
463      *
464      * NOTE: This information is only used for _display_ purposes: it in
465      * no way affects any of the arithmetic of the contract, including
466      * {IERC20-balanceOf} and {IERC20-transfer}.
467      */
468     function decimals() public view returns (uint8) {
469         return _decimals;
470     }
471 
472     /**
473      * @dev See {IERC20-totalSupply}.
474      */
475     function totalSupply() public view override returns (uint256) {
476         return _totalSupply;
477     }
478 
479     /**
480      * @dev See {IERC20-balanceOf}.
481      */
482     function balanceOf(address account) public view override returns (uint256) {
483         return _balances[account];
484     }
485 
486     /**
487      * @dev See {IERC20-transfer}.
488      *
489      * Requirements:
490      *
491      * - `recipient` cannot be the zero address.
492      * - the caller must have a balance of at least `amount`.
493      */
494     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
495         _transfer(_msgSender(), recipient, amount);
496         return true;
497     }
498 
499     /**
500      * @dev See {IERC20-allowance}.
501      */
502     function allowance(address owner, address spender) public view virtual override returns (uint256) {
503         return _allowances[owner][spender];
504     }
505 
506     /**
507      * @dev See {IERC20-approve}.
508      *
509      * Requirements:
510      *
511      * - `spender` cannot be the zero address.
512      */
513     function approve(address spender, uint256 amount) public virtual override returns (bool) {
514         _approve(_msgSender(), spender, amount);
515         return true;
516     }
517 
518     /**
519      * @dev See {IERC20-transferFrom}.
520      *
521      * Emits an {Approval} event indicating the updated allowance. This is not
522      * required by the EIP. See the note at the beginning of {ERC20}.
523      *
524      * Requirements:
525      *
526      * - `sender` and `recipient` cannot be the zero address.
527      * - `sender` must have a balance of at least `amount`.
528      * - the caller must have allowance for ``sender``'s tokens of at least
529      * `amount`.
530      */
531     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
532         _transfer(sender, recipient, amount);
533         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
534         return true;
535     }
536 
537     /**
538      * @dev Atomically increases the allowance granted to `spender` by the caller.
539      *
540      * This is an alternative to {approve} that can be used as a mitigation for
541      * problems described in {IERC20-approve}.
542      *
543      * Emits an {Approval} event indicating the updated allowance.
544      *
545      * Requirements:
546      *
547      * - `spender` cannot be the zero address.
548      */
549     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
550         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
551         return true;
552     }
553 
554     /**
555      * @dev Atomically decreases the allowance granted to `spender` by the caller.
556      *
557      * This is an alternative to {approve} that can be used as a mitigation for
558      * problems described in {IERC20-approve}.
559      *
560      * Emits an {Approval} event indicating the updated allowance.
561      *
562      * Requirements:
563      *
564      * - `spender` cannot be the zero address.
565      * - `spender` must have allowance for the caller of at least
566      * `subtractedValue`.
567      */
568     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
569         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
570         return true;
571     }
572 
573     /**
574      * @dev Moves tokens `amount` from `sender` to `recipient`.
575      *
576      * This is internal function is equivalent to {transfer}, and can be used to
577      * e.g. implement automatic token fees, slashing mechanisms, etc.
578      *
579      * Emits a {Transfer} event.
580      *
581      * Requirements:
582      *
583      * - `sender` cannot be the zero address.
584      * - `recipient` cannot be the zero address.
585      * - `sender` must have a balance of at least `amount`.
586      */
587     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
588         require(sender != address(0), "ERC20: transfer from the zero address");
589         require(recipient != address(0), "ERC20: transfer to the zero address");
590 
591         _beforeTokenTransfer(sender, recipient, amount);
592 
593         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
594         _balances[recipient] = _balances[recipient].add(amount);
595         emit Transfer(sender, recipient, amount);
596     }
597 
598     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
599      * the total supply.
600      *
601      * Emits a {Transfer} event with `from` set to the zero address.
602      *
603      * Requirements:
604      *
605      * - `to` cannot be the zero address.
606      */
607     function _mint(address account, uint256 amount) internal virtual {
608         require(account != address(0), "ERC20: mint to the zero address");
609 
610         _beforeTokenTransfer(address(0), account, amount);
611 
612         _totalSupply = _totalSupply.add(amount);
613         _balances[account] = _balances[account].add(amount);
614         emit Transfer(address(0), account, amount);
615     }
616 
617     /**
618      * @dev Destroys `amount` tokens from `account`, reducing the
619      * total supply.
620      *
621      * Emits a {Transfer} event with `to` set to the zero address.
622      *
623      * Requirements:
624      *
625      * - `account` cannot be the zero address.
626      * - `account` must have at least `amount` tokens.
627      */
628     function _burn(address account, uint256 amount) internal virtual {
629         require(account != address(0), "ERC20: burn from the zero address");
630 
631         _beforeTokenTransfer(account, address(0), amount);
632 
633         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
634         _totalSupply = _totalSupply.sub(amount);
635         emit Transfer(account, address(0), amount);
636     }
637 
638     /**
639      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
640      *
641      * This internal function is equivalent to `approve`, and can be used to
642      * e.g. set automatic allowances for certain subsystems, etc.
643      *
644      * Emits an {Approval} event.
645      *
646      * Requirements:
647      *
648      * - `owner` cannot be the zero address.
649      * - `spender` cannot be the zero address.
650      */
651     function _approve(address owner, address spender, uint256 amount) internal virtual {
652         require(owner != address(0), "ERC20: approve from the zero address");
653         require(spender != address(0), "ERC20: approve to the zero address");
654 
655         _allowances[owner][spender] = amount;
656         emit Approval(owner, spender, amount);
657     }
658 
659     /**
660      * @dev Sets {decimals} to a value other than the default one of 18.
661      *
662      * WARNING: This function should only be called from the constructor. Most
663      * applications that interact with token contracts will not expect
664      * {decimals} to ever change, and may work incorrectly if it does.
665      */
666     function _setupDecimals(uint8 decimals_) internal {
667         _decimals = decimals_;
668     }
669 
670     /**
671      * @dev Hook that is called before any transfer of tokens. This includes
672      * minting and burning.
673      *
674      * Calling conditions:
675      *
676      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
677      * will be to transferred to `to`.
678      * - when `from` is zero, `amount` tokens will be minted for `to`.
679      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
680      * - `from` and `to` are never both zero.
681      *
682      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
683      */
684     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
685 }
686 
687 // File: @openzeppelin/contracts/introspection/IERC165.sol
688 
689 
690 
691 pragma solidity >=0.6.0 <0.8.0;
692 
693 /**
694  * @dev Interface of the ERC165 standard, as defined in the
695  * https://eips.ethereum.org/EIPS/eip-165[EIP].
696  *
697  * Implementers can declare support of contract interfaces, which can then be
698  * queried by others ({ERC165Checker}).
699  *
700  * For an implementation, see {ERC165}.
701  */
702 interface IERC165 {
703     /**
704      * @dev Returns true if this contract implements the interface defined by
705      * `interfaceId`. See the corresponding
706      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
707      * to learn more about how these ids are created.
708      *
709      * This function call must use less than 30 000 gas.
710      */
711     function supportsInterface(bytes4 interfaceId) external view returns (bool);
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
715 
716 
717 
718 pragma solidity >=0.6.2 <0.8.0;
719 
720 
721 /**
722  * @dev Required interface of an ERC721 compliant contract.
723  */
724 interface IERC721 is IERC165 {
725     /**
726      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
727      */
728     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
729 
730     /**
731      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
732      */
733     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
734 
735     /**
736      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
737      */
738     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
739 
740     /**
741      * @dev Returns the number of tokens in ``owner``'s account.
742      */
743     function balanceOf(address owner) external view returns (uint256 balance);
744 
745     /**
746      * @dev Returns the owner of the `tokenId` token.
747      *
748      * Requirements:
749      *
750      * - `tokenId` must exist.
751      */
752     function ownerOf(uint256 tokenId) external view returns (address owner);
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
756      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
757      *
758      * Requirements:
759      *
760      * - `from` cannot be the zero address.
761      * - `to` cannot be the zero address.
762      * - `tokenId` token must exist and be owned by `from`.
763      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function safeTransferFrom(address from, address to, uint256 tokenId) external;
769 
770     /**
771      * @dev Transfers `tokenId` token from `from` to `to`.
772      *
773      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
774      *
775      * Requirements:
776      *
777      * - `from` cannot be the zero address.
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must be owned by `from`.
780      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
781      *
782      * Emits a {Transfer} event.
783      */
784     function transferFrom(address from, address to, uint256 tokenId) external;
785 
786     /**
787      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
788      * The approval is cleared when the token is transferred.
789      *
790      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
791      *
792      * Requirements:
793      *
794      * - The caller must own the token or be an approved operator.
795      * - `tokenId` must exist.
796      *
797      * Emits an {Approval} event.
798      */
799     function approve(address to, uint256 tokenId) external;
800 
801     /**
802      * @dev Returns the account approved for `tokenId` token.
803      *
804      * Requirements:
805      *
806      * - `tokenId` must exist.
807      */
808     function getApproved(uint256 tokenId) external view returns (address operator);
809 
810     /**
811      * @dev Approve or remove `operator` as an operator for the caller.
812      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
813      *
814      * Requirements:
815      *
816      * - The `operator` cannot be the caller.
817      *
818      * Emits an {ApprovalForAll} event.
819      */
820     function setApprovalForAll(address operator, bool _approved) external;
821 
822     /**
823      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
824      *
825      * See {setApprovalForAll}
826      */
827     function isApprovedForAll(address owner, address operator) external view returns (bool);
828 
829     /**
830       * @dev Safely transfers `tokenId` token from `from` to `to`.
831       *
832       * Requirements:
833       *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836       * - `tokenId` token must exist and be owned by `from`.
837       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
838       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
839       *
840       * Emits a {Transfer} event.
841       */
842     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
843 }
844 
845 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
846 
847 
848 
849 pragma solidity >=0.6.2 <0.8.0;
850 
851 
852 /**
853  * @dev Required interface of an ERC1155 compliant contract, as defined in the
854  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
855  *
856  * _Available since v3.1._
857  */
858 interface IERC1155 is IERC165 {
859     /**
860      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
861      */
862     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
863 
864     /**
865      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
866      * transfers.
867      */
868     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
869 
870     /**
871      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
872      * `approved`.
873      */
874     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
875 
876     /**
877      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
878      *
879      * If an {URI} event was emitted for `id`, the standard
880      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
881      * returned by {IERC1155MetadataURI-uri}.
882      */
883     event URI(string value, uint256 indexed id);
884 
885     /**
886      * @dev Returns the amount of tokens of token type `id` owned by `account`.
887      *
888      * Requirements:
889      *
890      * - `account` cannot be the zero address.
891      */
892     function balanceOf(address account, uint256 id) external view returns (uint256);
893 
894     /**
895      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
896      *
897      * Requirements:
898      *
899      * - `accounts` and `ids` must have the same length.
900      */
901     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
902 
903     /**
904      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
905      *
906      * Emits an {ApprovalForAll} event.
907      *
908      * Requirements:
909      *
910      * - `operator` cannot be the caller.
911      */
912     function setApprovalForAll(address operator, bool approved) external;
913 
914     /**
915      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
916      *
917      * See {setApprovalForAll}.
918      */
919     function isApprovedForAll(address account, address operator) external view returns (bool);
920 
921     /**
922      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
923      *
924      * Emits a {TransferSingle} event.
925      *
926      * Requirements:
927      *
928      * - `to` cannot be the zero address.
929      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
930      * - `from` must have a balance of tokens of type `id` of at least `amount`.
931      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
932      * acceptance magic value.
933      */
934     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
935 
936     /**
937      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
938      *
939      * Emits a {TransferBatch} event.
940      *
941      * Requirements:
942      *
943      * - `ids` and `amounts` must have the same length.
944      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
945      * acceptance magic value.
946      */
947     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
948 }
949 
950 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
951 
952 
953 
954 pragma solidity >=0.6.0 <0.8.0;
955 
956 
957 /**
958  * _Available since v3.1._
959  */
960 interface IERC1155Receiver is IERC165 {
961 
962     /**
963         @dev Handles the receipt of a single ERC1155 token type. This function is
964         called at the end of a `safeTransferFrom` after the balance has been updated.
965         To accept the transfer, this must return
966         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
967         (i.e. 0xf23a6e61, or its own function selector).
968         @param operator The address which initiated the transfer (i.e. msg.sender)
969         @param from The address which previously owned the token
970         @param id The ID of the token being transferred
971         @param value The amount of tokens being transferred
972         @param data Additional data with no specified format
973         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
974     */
975     function onERC1155Received(
976         address operator,
977         address from,
978         uint256 id,
979         uint256 value,
980         bytes calldata data
981     )
982         external
983         returns(bytes4);
984 
985     /**
986         @dev Handles the receipt of a multiple ERC1155 token types. This function
987         is called at the end of a `safeBatchTransferFrom` after the balances have
988         been updated. To accept the transfer(s), this must return
989         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
990         (i.e. 0xbc197c81, or its own function selector).
991         @param operator The address which initiated the batch transfer (i.e. msg.sender)
992         @param from The address which previously owned the token
993         @param ids An array containing ids of each token being transferred (order and length must match values array)
994         @param values An array containing amounts of each token being transferred (order and length must match ids array)
995         @param data Additional data with no specified format
996         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
997     */
998     function onERC1155BatchReceived(
999         address operator,
1000         address from,
1001         uint256[] calldata ids,
1002         uint256[] calldata values,
1003         bytes calldata data
1004     )
1005         external
1006         returns(bytes4);
1007 }
1008 
1009 // File: @openzeppelin/contracts/introspection/ERC165.sol
1010 
1011 
1012 
1013 pragma solidity >=0.6.0 <0.8.0;
1014 
1015 
1016 /**
1017  * @dev Implementation of the {IERC165} interface.
1018  *
1019  * Contracts may inherit from this and call {_registerInterface} to declare
1020  * their support of an interface.
1021  */
1022 abstract contract ERC165 is IERC165 {
1023     /*
1024      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1025      */
1026     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1027 
1028     /**
1029      * @dev Mapping of interface ids to whether or not it's supported.
1030      */
1031     mapping(bytes4 => bool) private _supportedInterfaces;
1032 
1033     constructor () internal {
1034         // Derived contracts need only register support for their own interfaces,
1035         // we register support for ERC165 itself here
1036         _registerInterface(_INTERFACE_ID_ERC165);
1037     }
1038 
1039     /**
1040      * @dev See {IERC165-supportsInterface}.
1041      *
1042      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1043      */
1044     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1045         return _supportedInterfaces[interfaceId];
1046     }
1047 
1048     /**
1049      * @dev Registers the contract as an implementer of the interface defined by
1050      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1051      * registering its interface id is not required.
1052      *
1053      * See {IERC165-supportsInterface}.
1054      *
1055      * Requirements:
1056      *
1057      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1058      */
1059     function _registerInterface(bytes4 interfaceId) internal virtual {
1060         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1061         _supportedInterfaces[interfaceId] = true;
1062     }
1063 }
1064 
1065 // File: @openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol
1066 
1067 
1068 
1069 pragma solidity >=0.6.0 <0.8.0;
1070 
1071 
1072 
1073 /**
1074  * @dev _Available since v3.1._
1075  */
1076 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
1077     constructor() internal {
1078         _registerInterface(
1079             ERC1155Receiver(0).onERC1155Received.selector ^
1080             ERC1155Receiver(0).onERC1155BatchReceived.selector
1081         );
1082     }
1083 }
1084 
1085 // File: contracts/interfaces/IUnicFactory.sol
1086 
1087 pragma solidity >=0.5.0;
1088 
1089 interface IUnicFactory {
1090     event TokenCreated(address indexed caller, address indexed uToken);
1091 
1092     function feeTo() external view returns (address);
1093     function feeToSetter() external view returns (address);
1094 
1095     function getUToken(address uToken) external view returns (uint);
1096     function uTokens(uint) external view returns (address);
1097     function uTokensLength() external view returns (uint);
1098 
1099     function createUToken(uint256 totalSupply, uint8 decimals, string calldata name, string calldata symbol, uint256 threshold, string calldata description) external returns (address);
1100 
1101     function setFeeTo(address) external;
1102     function setFeeToSetter(address) external;
1103 }
1104 
1105 // File: contracts/Converter.sol
1106 
1107 pragma solidity 0.6.12;
1108 
1109 
1110 
1111 
1112 
1113 
1114 
1115 
1116 contract Converter is ERC20, ERC1155Receiver {
1117     using SafeMath for uint;
1118 
1119     // List of NFTs that have been deposited
1120     struct NFT {
1121         address contractAddr;
1122         uint256 tokenId;
1123         uint256 amount;
1124         bool claimed;
1125     }
1126 
1127     struct Bid {
1128         address bidder;
1129         uint256 amount;
1130         uint time;
1131     }
1132 
1133     mapping(uint256 => NFT) public nfts;
1134     // Current index and length of nfts
1135     uint256 public currentNFTIndex = 0;
1136 
1137     // If active, NFTs can’t be withdrawn
1138     bool public active = false;
1139     uint256 public totalBidAmount = 0;
1140     uint256 public unlockVotes = 0;
1141     uint256 public _threshold;
1142     address public issuer;
1143     string public _description;
1144     uint256 public cap;
1145 
1146     // Amount of uTokens each user has voted to unlock collection
1147     mapping(address => uint256) public unlockApproved;
1148 
1149     IUnicFactory public factory;
1150 
1151     // NFT index to Bid
1152     mapping(uint256 => Bid) public bids;
1153     // NFT index to address to amount
1154     mapping(uint256 => mapping(address => uint256)) public bidRefunds;
1155     uint public constant TOP_BID_LOCK_TIME = 3 days;
1156 
1157     event Deposited(uint256[] tokenIDs, uint256[] amounts, address contractAddr);
1158     event Refunded();
1159     event Issued();
1160     event BidCreated(address sender, uint256 nftIndex, uint256 bidAmount);
1161     event BidRemoved(address sender, uint256 nftIndex);
1162     event ClaimedNFT(address winner, uint256 nftIndex, uint256 tokenId);
1163 
1164     bytes private constant VALIDATOR = bytes('JCMY');
1165 
1166     constructor (uint256 totalSupply, uint8 decimals, string memory name, string memory symbol, uint256 threshold, string memory description, address _issuer, IUnicFactory _factory)
1167         public
1168         ERC20(name, symbol)
1169     {
1170         _setupDecimals(decimals);
1171         issuer = _issuer;
1172         _description = description;
1173         _threshold = threshold;
1174         factory = _factory;
1175         cap = totalSupply;
1176     }
1177 
1178     // deposits an nft using the transferFrom action of the NFT contractAddr
1179     function deposit(uint256[] calldata tokenIDs, uint256[] calldata amounts, address contractAddr) external {
1180         require(msg.sender == issuer, "Converter: Only issuer can deposit");
1181         require(tokenIDs.length <= 50, "Converter: A maximum of 50 tokens can be deposited in one go");
1182         require(tokenIDs.length > 0, "Converter: You must specify at least one token ID");
1183 
1184         if (ERC165Checker.supportsInterface(contractAddr, 0xd9b67a26)){
1185             IERC1155(contractAddr).safeBatchTransferFrom(msg.sender, address(this), tokenIDs, amounts, VALIDATOR);
1186 
1187             for (uint8 i = 0; i < 50; i++){
1188                 if (tokenIDs.length == i){
1189                     break;
1190                 }
1191                 nfts[currentNFTIndex++] = NFT(contractAddr, tokenIDs[i], amounts[i], false);
1192             }
1193         }
1194         else if (ERC165Checker.supportsInterface(contractAddr, 0x80ac58cd)){
1195             for (uint8 i = 0; i < 50; i++){
1196                 if (tokenIDs.length == i){
1197                     break;
1198                 }
1199                 IERC721(contractAddr).transferFrom(msg.sender, address(this), tokenIDs[i]);
1200                 nfts[currentNFTIndex++] = NFT(contractAddr, tokenIDs[i], 1, false);
1201             }
1202         }
1203 
1204         emit Deposited(tokenIDs, amounts, contractAddr);
1205     }
1206 
1207     // Function that locks NFT collateral and issues the uTokens to the issuer
1208     function issue() external {
1209         require(msg.sender == issuer, "Converter: Only issuer can issue the tokens");
1210         require(active == false, "Converter: Token is already active");
1211 
1212         active = true;
1213         address feeTo = factory.feeTo();
1214         uint256 feeAmount = 0;
1215         if (feeTo != address(0)) {
1216             // 0.5% of uToken supply is sent to feeToAddress if fee is on
1217             feeAmount = cap.div(200);
1218             _mint(feeTo, feeAmount);
1219         }
1220 
1221         _mint(issuer, cap - feeAmount);
1222 
1223         emit Issued();
1224     }
1225 
1226     // Function that allows NFTs to be refunded (prior to issue being called)
1227     function refund(address _to) external {
1228         require(!active, "Converter: Contract is already active - cannot refund");
1229         require(msg.sender == issuer, "Converter: Only issuer can refund");
1230 
1231         // Only transfer maximum of 50 at a time to limit gas per call
1232         uint8 _i = 0;
1233         uint256 _index = currentNFTIndex;
1234         bytes memory data;
1235 
1236         while (_index > 0 && _i < 50){
1237             NFT memory nft = nfts[_index - 1];
1238 
1239             if (ERC165Checker.supportsInterface(nft.contractAddr, 0xd9b67a26)){
1240                 IERC1155(nft.contractAddr).safeTransferFrom(address(this), _to, nft.tokenId, nft.amount, data);
1241             }
1242             else if (ERC165Checker.supportsInterface(nft.contractAddr, 0x80ac58cd)){
1243                 IERC721(nft.contractAddr).safeTransferFrom(address(this), _to, nft.tokenId);
1244             }
1245 
1246             delete nfts[_index - 1];
1247 
1248             _index--;
1249             _i++;
1250         }
1251 
1252         currentNFTIndex = _index;
1253 
1254         emit Refunded();
1255     }
1256 
1257     function bid(uint256 nftIndex) external payable {
1258         require(unlockVotes < _threshold, "Converter: Release threshold has been met, no more bids allowed");
1259         Bid memory topBid = bids[nftIndex];
1260         require(topBid.bidder != msg.sender, "Converter: You have an active bid");
1261         require(topBid.amount < msg.value, "Converter: Bid too low");
1262         require(bidRefunds[nftIndex][msg.sender] == 0, "Converter: Collect bid refund");
1263 
1264         bids[nftIndex] = Bid(msg.sender, msg.value, getBlockTimestamp());
1265         bidRefunds[nftIndex][topBid.bidder] = topBid.amount;
1266         totalBidAmount += msg.value - topBid.amount;
1267 
1268         emit BidCreated(msg.sender, nftIndex, msg.value);
1269     }
1270 
1271     function unbid(uint256 nftIndex) external {
1272         Bid memory topBid = bids[nftIndex];
1273         bool isTopBidder = topBid.bidder == msg.sender;
1274         if (unlockVotes >= _threshold) {
1275             require(!isTopBidder, "Converter: Release threshold has been met, winner can't unbid");
1276         }
1277 
1278         if (isTopBidder) {
1279             require(topBid.time + TOP_BID_LOCK_TIME < getBlockTimestamp(), "Converter: Top bid locked");
1280             totalBidAmount -= topBid.amount;
1281             bids[nftIndex] = Bid(address(0), 0, getBlockTimestamp());
1282             (bool sent, bytes memory data) = msg.sender.call{value: topBid.amount}("");
1283             require(sent, "Converter: Failed to send Ether");
1284 
1285             emit BidRemoved(msg.sender, nftIndex);
1286         }
1287         else { 
1288             uint256 refundAmount = bidRefunds[nftIndex][msg.sender];
1289             require(refundAmount > 0, "Converter: no bid found");
1290             bidRefunds[nftIndex][msg.sender] = 0;
1291             (bool sent, bytes memory data) = msg.sender.call{value: refundAmount}("");
1292             require(sent, "Converter: Failed to send Ether");
1293         }
1294     }
1295 
1296     // Claim NFT if address is winning bidder
1297     function claim(uint256 nftIndex) external {
1298         require(unlockVotes >= _threshold, "Converter: Threshold not met");
1299         require(!nfts[nftIndex].claimed, "Converter: Already claimed");
1300         Bid memory topBid = bids[nftIndex];
1301         require(msg.sender == topBid.bidder, "Converter: Only winner can claim");
1302 
1303         nfts[nftIndex].claimed = true;
1304         NFT memory winningNFT = nfts[nftIndex];
1305 
1306         if (ERC165Checker.supportsInterface(winningNFT.contractAddr, 0xd9b67a26)){
1307             bytes memory data;
1308             IERC1155(winningNFT.contractAddr).safeTransferFrom(address(this), topBid.bidder, winningNFT.tokenId, winningNFT.amount, data);
1309         }
1310         else if (ERC165Checker.supportsInterface(winningNFT.contractAddr, 0x80ac58cd)){
1311             IERC721(winningNFT.contractAddr).safeTransferFrom(address(this), topBid.bidder, winningNFT.tokenId);
1312         }
1313 
1314         emit ClaimedNFT(topBid.bidder, nftIndex, winningNFT.tokenId);
1315     }
1316 
1317     // Approve collection unlock
1318     function approveUnlock(uint256 amount) external {
1319         require(unlockVotes < _threshold, "Converter: Threshold reached");
1320         _transfer(msg.sender, address(this), amount);
1321 
1322         unlockApproved[msg.sender] += amount;
1323         unlockVotes += amount;
1324     }
1325 
1326     // Unapprove collection unlock
1327     function unapproveUnlock(uint256 amount) external {
1328         require(unlockVotes < _threshold, "Converter: Threshold reached");
1329         require(unlockApproved[msg.sender] >= amount, "Converter: Not enough uTokens locked by user");
1330         unlockVotes -= amount;
1331         unlockApproved[msg.sender] -= amount;
1332 
1333         _transfer(address(this), msg.sender, amount);
1334     }
1335 
1336     // Claim ETH function
1337     function redeemETH(uint256 amount) external {
1338         require(unlockVotes >= _threshold, "Converter: Threshold not met");
1339         // Deposit uTokens
1340         if (amount > 0) {
1341             _transfer(msg.sender, address(this), amount);
1342         }
1343         // Combine approved balance + newly deposited balance
1344         uint256 finalBalance = amount + unlockApproved[msg.sender];
1345         // Remove locked uTokens tracked for user
1346         unlockApproved[msg.sender] = 0;
1347 
1348         // Redeem ETH corresponding to uToken amount
1349         (bool sent, bytes memory data) = msg.sender.call{value: totalBidAmount.mul(finalBalance).div(this.totalSupply())}("");
1350         require(sent, "Converter: Failed to send Ether");
1351     }
1352 
1353     function getBlockTimestamp() internal view returns (uint) {
1354         // solium-disable-next-line security/no-block-members
1355         return block.timestamp;
1356     }
1357 
1358     /**
1359      * ERC1155 Token ERC1155Receiver
1360      */
1361     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) override external returns(bytes4) {
1362         if(keccak256(_data) == keccak256(VALIDATOR)){
1363             return 0xf23a6e61;
1364         }
1365     }
1366 
1367     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) override external returns(bytes4) {
1368         if(keccak256(_data) == keccak256(VALIDATOR)){
1369             return 0xbc197c81;
1370         }
1371     }
1372 
1373 }