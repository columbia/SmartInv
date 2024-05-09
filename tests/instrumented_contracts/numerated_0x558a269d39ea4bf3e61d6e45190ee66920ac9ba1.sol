1 /**
2 
3 BETGPT -  $BET
4 
5 Telegram:  https://t.me/BetGPT_ERC
6 Twitter:   https://twitter.com/BetGPT
7 
8 Sports gambling can be an emotional endeavor. What if there was a tool to take all emotion out of the equation? 
9 Introducing BETGPT, an artificial intelligence way of placing your bets. 
10 BETGPT uses artificial intelligence to determine the most probable outcome of a matchup. 
11 BETGPT will consider a multitude of factors when determining the probable outcome, from the trend of a teams performance 
12 to the anticipated atmosphere at the time of the game. 
13 Many factors are overlooked when handicapping a game by a sports book and through artificial intelligence 
14 that is constantly learning and improving overtime, you the player are put in the drivers seat. 
15 The house had its time, now the time has come for the player to take control. 
16 
17 
18 
19 */
20 
21 
22 // SPDX-License-Identifier: MIT
23 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
24 pragma experimental ABIEncoderV2;
25 
26 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
27 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
28 
29 /* pragma solidity ^0.8.0; */
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42  function _msgSender() internal view virtual returns (address) {
43  return msg.sender;
44  }
45 
46  function _msgData() internal view virtual returns (bytes calldata) {
47  return msg.data;
48  }
49 }
50 
51 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
52 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
53 
54 /* pragma solidity ^0.8.0; */
55 
56 /* import "../utils/Context.sol"; */
57 
58 /**
59  * @dev Contract module which provides a basic access control mechanism, where
60  * there is an account (an owner) that can be granted exclusive access to
61  * specific functions.
62  *
63  * By default, the owner account will be the one that deploys the contract. This
64  * can later be changed with {transferOwnership}.
65  *
66  * This module is used through inheritance. It will make available the modifier
67  * `onlyOwner`, which can be applied to your functions to restrict their use to
68  * the owner.
69  */
70 abstract contract Ownable is Context {
71  address private _owner;
72 
73  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75  /**
76  * @dev Initializes the contract setting the deployer as the initial owner.
77  */
78  constructor() {
79  _transferOwnership(_msgSender());
80  }
81 
82  /**
83  * @dev Returns the address of the current owner.
84  */
85  function owner() public view virtual returns (address) {
86  return _owner;
87  }
88 
89  /**
90  * @dev Throws if called by any account other than the owner.
91  */
92  modifier onlyOwner() {
93  require(owner() == _msgSender(), "Ownable: caller is not the owner");
94  _;
95  }
96 
97  /**
98  * @dev Leaves the contract without owner. It will not be possible to call
99  * `onlyOwner` functions anymore. Can only be called by the current owner.
100  *
101  * NOTE: Renouncing ownership will leave the contract without an owner,
102  * thereby removing any functionality that is only available to the owner.
103  */
104  function renounceOwnership() public virtual onlyOwner {
105  _transferOwnership(address(0));
106  }
107 
108  /**
109  * @dev Transfers ownership of the contract to a new account (`newOwner`).
110  * Can only be called by the current owner.
111  */
112  function transferOwnership(address newOwner) public virtual onlyOwner {
113  require(newOwner != address(0), "Ownable: new owner is the zero address");
114  _transferOwnership(newOwner);
115  }
116 
117  /**
118  * @dev Transfers ownership of the contract to a new account (`newOwner`).
119  * Internal function without access restriction.
120  */
121  function _transferOwnership(address newOwner) internal virtual {
122  address oldOwner = _owner;
123  _owner = newOwner;
124  emit OwnershipTransferred(oldOwner, newOwner);
125  }
126 }
127 
128 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
129 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
130 
131 /* pragma solidity ^0.8.0; */
132 
133 /**
134  * @dev Interface of the ERC20 standard as defined in the EIP.
135  */
136 interface IERC20 {
137  /**
138  * @dev Returns the amount of tokens in existence.
139  */
140  function totalSupply() external view returns (uint256);
141 
142  /**
143  * @dev Returns the amount of tokens owned by `account`.
144  */
145  function balanceOf(address account) external view returns (uint256);
146 
147  /**
148  * @dev Moves `amount` tokens from the caller's account to `recipient`.
149  *
150  * Returns a boolean value indicating whether the operation succeeded.
151  *
152  * Emits a {Transfer} event.
153  */
154  function transfer(address recipient, uint256 amount) external returns (bool);
155 
156  /**
157  * @dev Returns the remaining number of tokens that `spender` will be
158  * allowed to spend on behalf of `owner` through {transferFrom}. This is
159  * zero by default.
160  *
161  * This value changes when {approve} or {transferFrom} are called.
162  */
163  function allowance(address owner, address spender) external view returns (uint256);
164 
165  /**
166  * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167  *
168  * Returns a boolean value indicating whether the operation succeeded.
169  *
170  * IMPORTANT: Beware that changing an allowance with this method brings the risk
171  * that someone may use both the old and the new allowance by unfortunate
172  * transaction ordering. One possible solution to mitigate this race
173  * condition is to first reduce the spender's allowance to 0 and set the
174  * desired value afterwards:
175  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176  *
177  * Emits an {Approval} event.
178  */
179  function approve(address spender, uint256 amount) external returns (bool);
180 
181  /**
182  * @dev Moves `amount` tokens from `sender` to `recipient` using the
183  * allowance mechanism. `amount` is then deducted from the caller's
184  * allowance.
185  *
186  * Returns a boolean value indicating whether the operation succeeded.
187  *
188  * Emits a {Transfer} event.
189  */
190  function transferFrom(
191  address sender,
192  address recipient,
193  uint256 amount
194  ) external returns (bool);
195 
196  /**
197  * @dev Emitted when `value` tokens are moved from one account (`from`) to
198  * another (`to`).
199  *
200  * Note that `value` may be zero.
201  */
202  event Transfer(address indexed from, address indexed to, uint256 value);
203 
204  /**
205  * @dev Emitted when the allowance of a `spender` for an `owner` is set by
206  * a call to {approve}. `value` is the new allowance.
207  */
208  event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 
211 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
212 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
213 
214 /* pragma solidity ^0.8.0; */
215 
216 /* import "../IERC20.sol"; */
217 
218 /**
219  * @dev Interface for the optional metadata functions from the ERC20 standard.
220  *
221  * _Available since v4.1._
222  */
223 interface IERC20Metadata is IERC20 {
224  /**
225  * @dev Returns the name of the token.
226  */
227  function name() external view returns (string memory);
228 
229  /**
230  * @dev Returns the symbol of the token.
231  */
232  function symbol() external view returns (string memory);
233 
234  /**
235  * @dev Returns the decimals places of the token.
236  */
237  function decimals() external view returns (uint8);
238 }
239 
240 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
241 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
242 
243 /* pragma solidity ^0.8.0; */
244 
245 /* import "./IERC20.sol"; */
246 /* import "./extensions/IERC20Metadata.sol"; */
247 /* import "../../utils/Context.sol"; */
248 
249 /**
250  * @dev Implementation of the {IERC20} interface.
251  *
252  * This implementation is agnostic to the way tokens are created. This means
253  * that a supply mechanism has to be added in a derived contract using {_mint}.
254  * For a generic mechanism see {ERC20PresetMinterPauser}.
255  *
256  * TIP: For a detailed writeup see our guide
257  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
258  * to implement supply mechanisms].
259  *
260  * We have followed general OpenZeppelin Contracts guidelines: functions revert
261  * instead returning `false` on failure. This behavior is nonetheless
262  * conventional and does not conflict with the expectations of ERC20
263  * applications.
264  *
265  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
266  * This allows applications to reconstruct the allowance for all accounts just
267  * by listening to said events. Other implementations of the EIP may not emit
268  * these events, as it isn't required by the specification.
269  *
270  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
271  * functions have been added to mitigate the well-known issues around setting
272  * allowances. See {IERC20-approve}.
273  */
274 contract ERC20 is Context, IERC20, IERC20Metadata {
275  mapping(address => uint256) private _balances;
276 
277  mapping(address => mapping(address => uint256)) private _allowances;
278 
279  uint256 private _totalSupply;
280 
281  string private _name;
282  string private _symbol;
283 
284  /**
285  * @dev Sets the values for {name} and {symbol}.
286  *
287  * The default value of {decimals} is 18. To select a different value for
288  * {decimals} you should overload it.
289  *
290  * All two of these values are immutable: they can only be set once during
291  * construction.
292  */
293  constructor(string memory name_, string memory symbol_) {
294  _name = name_;
295  _symbol = symbol_;
296  }
297 
298  /**
299  * @dev Returns the name of the token.
300  */
301  function name() public view virtual override returns (string memory) {
302  return _name;
303  }
304 
305  /**
306  * @dev Returns the symbol of the token, usually a shorter version of the
307  * name.
308  */
309  function symbol() public view virtual override returns (string memory) {
310  return _symbol;
311  }
312 
313  /**
314  * @dev Returns the number of decimals used to get its user representation.
315  * For example, if `decimals` equals `2`, a balance of `505` tokens should
316  * be displayed to a user as `5.05` (`505 / 10 ** 2`).
317  *
318  * Tokens usually opt for a value of 18, imitating the relationship between
319  * Ether and Wei. This is the value {ERC20} uses, unless this function is
320  * overridden;
321  *
322  * NOTE: This information is only used for _display_ purposes: it in
323  * no way affects any of the arithmetic of the contract, including
324  * {IERC20-balanceOf} and {IERC20-transfer}.
325  */
326  function decimals() public view virtual override returns (uint8) {
327  return 18;
328  }
329 
330  /**
331  * @dev See {IERC20-totalSupply}.
332  */
333  function totalSupply() public view virtual override returns (uint256) {
334  return _totalSupply;
335  }
336 
337  /**
338  * @dev See {IERC20-balanceOf}.
339  */
340  function balanceOf(address account) public view virtual override returns (uint256) {
341  return _balances[account];
342  }
343 
344  /**
345  * @dev See {IERC20-transfer}.
346  *
347  * Requirements:
348  *
349  * - `recipient` cannot be the zero address.
350  * - the caller must have a balance of at least `amount`.
351  */
352  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
353  _transfer(_msgSender(), recipient, amount);
354  return true;
355  }
356 
357  /**
358  * @dev See {IERC20-allowance}.
359  */
360  function allowance(address owner, address spender) public view virtual override returns (uint256) {
361  return _allowances[owner][spender];
362  }
363 
364  /**
365  * @dev See {IERC20-approve}.
366  *
367  * Requirements:
368  *
369  * - `spender` cannot be the zero address.
370  */
371  function approve(address spender, uint256 amount) public virtual override returns (bool) {
372  _approve(_msgSender(), spender, amount);
373  return true;
374  }
375 
376  /**
377  * @dev See {IERC20-transferFrom}.
378  *
379  * Emits an {Approval} event indicating the updated allowance. This is not
380  * required by the EIP. See the note at the beginning of {ERC20}.
381  *
382  * Requirements:
383  *
384  * - `sender` and `recipient` cannot be the zero address.
385  * - `sender` must have a balance of at least `amount`.
386  * - the caller must have allowance for ``sender``'s tokens of at least
387  * `amount`.
388  */
389  function transferFrom(
390  address sender,
391  address recipient,
392  uint256 amount
393  ) public virtual override returns (bool) {
394  _transfer(sender, recipient, amount);
395 
396  uint256 currentAllowance = _allowances[sender][_msgSender()];
397  require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
398  unchecked {
399  _approve(sender, _msgSender(), currentAllowance - amount);
400  }
401 
402  return true;
403  }
404 
405  /**
406  * @dev Atomically increases the allowance granted to `spender` by the caller.
407  *
408  * This is an alternative to {approve} that can be used as a mitigation for
409  * problems described in {IERC20-approve}.
410  *
411  * Emits an {Approval} event indicating the updated allowance.
412  *
413  * Requirements:
414  *
415  * - `spender` cannot be the zero address.
416  */
417  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
418  _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
419  return true;
420  }
421 
422  /**
423  * @dev Atomically decreases the allowance granted to `spender` by the caller.
424  *
425  * This is an alternative to {approve} that can be used as a mitigation for
426  * problems described in {IERC20-approve}.
427  *
428  * Emits an {Approval} event indicating the updated allowance.
429  *
430  * Requirements:
431  *
432  * - `spender` cannot be the zero address.
433  * - `spender` must have allowance for the caller of at least
434  * `subtractedValue`.
435  */
436  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
437  uint256 currentAllowance = _allowances[_msgSender()][spender];
438  require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
439  unchecked {
440  _approve(_msgSender(), spender, currentAllowance - subtractedValue);
441  }
442 
443  return true;
444  }
445 
446  /**
447  * @dev Moves `amount` of tokens from `sender` to `recipient`.
448  *
449  * This internal function is equivalent to {transfer}, and can be used to
450  * e.g. implement automatic token fees, slashing mechanisms, etc.
451  *
452  * Emits a {Transfer} event.
453  *
454  * Requirements:
455  *
456  * - `sender` cannot be the zero address.
457  * - `recipient` cannot be the zero address.
458  * - `sender` must have a balance of at least `amount`.
459  */
460  function _transfer(
461  address sender,
462  address recipient,
463  uint256 amount
464  ) internal virtual {
465  require(sender != address(0), "ERC20: transfer from the zero address");
466  require(recipient != address(0), "ERC20: transfer to the zero address");
467 
468  _beforeTokenTransfer(sender, recipient, amount);
469 
470  uint256 senderBalance = _balances[sender];
471  require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
472  unchecked {
473  _balances[sender] = senderBalance - amount;
474  }
475  _balances[recipient] += amount;
476 
477  emit Transfer(sender, recipient, amount);
478 
479  _afterTokenTransfer(sender, recipient, amount);
480  }
481 
482  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
483  * the total supply.
484  *
485  * Emits a {Transfer} event with `from` set to the zero address.
486  *
487  * Requirements:
488  *
489  * - `account` cannot be the zero address.
490  */
491  function _mint(address account, uint256 amount) internal virtual {
492  require(account != address(0), "ERC20: mint to the zero address");
493 
494  _beforeTokenTransfer(address(0), account, amount);
495 
496  _totalSupply += amount;
497  _balances[account] += amount;
498  emit Transfer(address(0), account, amount);
499 
500  _afterTokenTransfer(address(0), account, amount);
501  }
502 
503  /**
504  * @dev Destroys `amount` tokens from `account`, reducing the
505  * total supply.
506  *
507  * Emits a {Transfer} event with `to` set to the zero address.
508  *
509  * Requirements:
510  *
511  * - `account` cannot be the zero address.
512  * - `account` must have at least `amount` tokens.
513  */
514  function _burn(address account, uint256 amount) internal virtual {
515  require(account != address(0), "ERC20: burn from the zero address");
516 
517  _beforeTokenTransfer(account, address(0), amount);
518 
519  uint256 accountBalance = _balances[account];
520  require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
521  unchecked {
522  _balances[account] = accountBalance - amount;
523  }
524  _totalSupply -= amount;
525 
526  emit Transfer(account, address(0), amount);
527 
528  _afterTokenTransfer(account, address(0), amount);
529  }
530 
531  /**
532  * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
533  *
534  * This internal function is equivalent to `approve`, and can be used to
535  * e.g. set automatic allowances for certain subsystems, etc.
536  *
537  * Emits an {Approval} event.
538  *
539  * Requirements:
540  *
541  * - `owner` cannot be the zero address.
542  * - `spender` cannot be the zero address.
543  */
544  function _approve(
545  address owner,
546  address spender,
547  uint256 amount
548  ) internal virtual {
549  require(owner != address(0), "ERC20: approve from the zero address");
550  require(spender != address(0), "ERC20: approve to the zero address");
551 
552  _allowances[owner][spender] = amount;
553  emit Approval(owner, spender, amount);
554  }
555 
556  /**
557  * @dev Hook that is called before any transfer of tokens. This includes
558  * minting and burning.
559  *
560  * Calling conditions:
561  *
562  * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563  * will be transferred to `to`.
564  * - when `from` is zero, `amount` tokens will be minted for `to`.
565  * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
566  * - `from` and `to` are never both zero.
567  *
568  * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569  */
570  function _beforeTokenTransfer(
571  address from,
572  address to,
573  uint256 amount
574  ) internal virtual {}
575 
576  /**
577  * @dev Hook that is called after any transfer of tokens. This includes
578  * minting and burning.
579  *
580  * Calling conditions:
581  *
582  * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
583  * has been transferred to `to`.
584  * - when `from` is zero, `amount` tokens have been minted for `to`.
585  * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
586  * - `from` and `to` are never both zero.
587  *
588  * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
589  */
590  function _afterTokenTransfer(
591  address from,
592  address to,
593  uint256 amount
594  ) internal virtual {}
595 }
596 
597 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
598 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
599 
600 /* pragma solidity ^0.8.0; */
601 
602 // CAUTION
603 // This version of SafeMath should only be used with Solidity 0.8 or later,
604 // because it relies on the compiler's built in overflow checks.
605 
606 /**
607  * @dev Wrappers over Solidity's arithmetic operations.
608  *
609  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
610  * now has built in overflow checking.
611  */
612 library SafeMath {
613  /**
614  * @dev Returns the addition of two unsigned integers, with an overflow flag.
615  *
616  * _Available since v3.4._
617  */
618  function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
619  unchecked {
620  uint256 c = a + b;
621  if (c < a) return (false, 0);
622  return (true, c);
623  }
624  }
625 
626  /**
627  * @dev Returns the substraction of two unsigned integers, with an overflow flag.
628  *
629  * _Available since v3.4._
630  */
631  function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
632  unchecked {
633  if (b > a) return (false, 0);
634  return (true, a - b);
635  }
636  }
637 
638  /**
639  * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
640  *
641  * _Available since v3.4._
642  */
643  function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
644  unchecked {
645  // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
646  // benefit is lost if 'b' is also tested.
647  // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
648  if (a == 0) return (true, 0);
649  uint256 c = a * b;
650  if (c / a != b) return (false, 0);
651  return (true, c);
652  }
653  }
654 
655  /**
656  * @dev Returns the division of two unsigned integers, with a division by zero flag.
657  *
658  * _Available since v3.4._
659  */
660  function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
661  unchecked {
662  if (b == 0) return (false, 0);
663  return (true, a / b);
664  }
665  }
666 
667  /**
668  * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
669  *
670  * _Available since v3.4._
671  */
672  function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
673  unchecked {
674  if (b == 0) return (false, 0);
675  return (true, a % b);
676  }
677  }
678 
679  /**
680  * @dev Returns the addition of two unsigned integers, reverting on
681  * overflow.
682  *
683  * Counterpart to Solidity's `+` operator.
684  *
685  * Requirements:
686  *
687  * - Addition cannot overflow.
688  */
689  function add(uint256 a, uint256 b) internal pure returns (uint256) {
690  return a + b;
691  }
692 
693  /**
694  * @dev Returns the subtraction of two unsigned integers, reverting on
695  * overflow (when the result is negative).
696  *
697  * Counterpart to Solidity's `-` operator.
698  *
699  * Requirements:
700  *
701  * - Subtraction cannot overflow.
702  */
703  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
704  return a - b;
705  }
706 
707  /**
708  * @dev Returns the multiplication of two unsigned integers, reverting on
709  * overflow.
710  *
711  * Counterpart to Solidity's `*` operator.
712  *
713  * Requirements:
714  *
715  * - Multiplication cannot overflow.
716  */
717  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
718  return a * b;
719  }
720 
721  /**
722  * @dev Returns the integer division of two unsigned integers, reverting on
723  * division by zero. The result is rounded towards zero.
724  *
725  * Counterpart to Solidity's `/` operator.
726  *
727  * Requirements:
728  *
729  * - The divisor cannot be zero.
730  */
731  function div(uint256 a, uint256 b) internal pure returns (uint256) {
732  return a / b;
733  }
734 
735  /**
736  * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
737  * reverting when dividing by zero.
738  *
739  * Counterpart to Solidity's `%` operator. This function uses a `revert`
740  * opcode (which leaves remaining gas untouched) while Solidity uses an
741  * invalid opcode to revert (consuming all remaining gas).
742  *
743  * Requirements:
744  *
745  * - The divisor cannot be zero.
746  */
747  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
748  return a % b;
749  }
750 
751  /**
752  * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
753  * overflow (when the result is negative).
754  *
755  * CAUTION: This function is deprecated because it requires allocating memory for the error
756  * message unnecessarily. For custom revert reasons use {trySub}.
757  *
758  * Counterpart to Solidity's `-` operator.
759  *
760  * Requirements:
761  *
762  * - Subtraction cannot overflow.
763  */
764  function sub(
765  uint256 a,
766  uint256 b,
767  string memory errorMessage
768  ) internal pure returns (uint256) {
769  unchecked {
770  require(b <= a, errorMessage);
771  return a - b;
772  }
773  }
774 
775  /**
776  * @dev Returns the integer division of two unsigned integers, reverting with custom message on
777  * division by zero. The result is rounded towards zero.
778  *
779  * Counterpart to Solidity's `/` operator. Note: this function uses a
780  * `revert` opcode (which leaves remaining gas untouched) while Solidity
781  * uses an invalid opcode to revert (consuming all remaining gas).
782  *
783  * Requirements:
784  *
785  * - The divisor cannot be zero.
786  */
787  function div(
788  uint256 a,
789  uint256 b,
790  string memory errorMessage
791  ) internal pure returns (uint256) {
792  unchecked {
793  require(b > 0, errorMessage);
794  return a / b;
795  }
796  }
797 
798  /**
799  * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
800  * reverting with custom message when dividing by zero.
801  *
802  * CAUTION: This function is deprecated because it requires allocating memory for the error
803  * message unnecessarily. For custom revert reasons use {tryMod}.
804  *
805  * Counterpart to Solidity's `%` operator. This function uses a `revert`
806  * opcode (which leaves remaining gas untouched) while Solidity uses an
807  * invalid opcode to revert (consuming all remaining gas).
808  *
809  * Requirements:
810  *
811  * - The divisor cannot be zero.
812  */
813  function mod(
814  uint256 a,
815  uint256 b,
816  string memory errorMessage
817  ) internal pure returns (uint256) {
818  unchecked {
819  require(b > 0, errorMessage);
820  return a % b;
821  }
822  }
823 }
824 
825 ////// src/IUniswapV2Factory.sol
826 /* pragma solidity 0.8.10; */
827 /* pragma experimental ABIEncoderV2; */
828 
829 interface IUniswapV2Factory {
830  event PairCreated(
831  address indexed token0,
832  address indexed token1,
833  address pair,
834  uint256
835  );
836 
837  function feeTo() external view returns (address);
838 
839  function feeToSetter() external view returns (address);
840 
841  function getPair(address tokenA, address tokenB)
842  external
843  view
844  returns (address pair);
845 
846  function allPairs(uint256) external view returns (address pair);
847 
848  function allPairsLength() external view returns (uint256);
849 
850  function createPair(address tokenA, address tokenB)
851  external
852  returns (address pair);
853 
854  function setFeeTo(address) external;
855 
856  function setFeeToSetter(address) external;
857 }
858 
859 ////// src/IUniswapV2Pair.sol
860 /* pragma solidity 0.8.10; */
861 /* pragma experimental ABIEncoderV2; */
862 
863 interface IUniswapV2Pair {
864  event Approval(
865  address indexed owner,
866  address indexed spender,
867  uint256 value
868  );
869  event Transfer(address indexed from, address indexed to, uint256 value);
870 
871  function name() external pure returns (string memory);
872 
873  function symbol() external pure returns (string memory);
874 
875  function decimals() external pure returns (uint8);
876 
877  function totalSupply() external view returns (uint256);
878 
879  function balanceOf(address owner) external view returns (uint256);
880 
881  function allowance(address owner, address spender)
882  external
883  view
884  returns (uint256);
885 
886  function approve(address spender, uint256 value) external returns (bool);
887 
888  function transfer(address to, uint256 value) external returns (bool);
889 
890  function transferFrom(
891  address from,
892  address to,
893  uint256 value
894  ) external returns (bool);
895 
896  function DOMAIN_SEPARATOR() external view returns (bytes32);
897 
898  function PERMIT_TYPEHASH() external pure returns (bytes32);
899 
900  function nonces(address owner) external view returns (uint256);
901 
902  function permit(
903  address owner,
904  address spender,
905  uint256 value,
906  uint256 deadline,
907  uint8 v,
908  bytes32 r,
909  bytes32 s
910  ) external;
911 
912  event Mint(address indexed sender, uint256 amount0, uint256 amount1);
913  event Burn(
914  address indexed sender,
915  uint256 amount0,
916  uint256 amount1,
917  address indexed to
918  );
919  event Swap(
920  address indexed sender,
921  uint256 amount0In,
922  uint256 amount1In,
923  uint256 amount0Out,
924  uint256 amount1Out,
925  address indexed to
926  );
927  event Sync(uint112 reserve0, uint112 reserve1);
928 
929  function MINIMUM_LIQUIDITY() external pure returns (uint256);
930 
931  function factory() external view returns (address);
932 
933  function token0() external view returns (address);
934 
935  function token1() external view returns (address);
936 
937  function getReserves()
938  external
939  view
940  returns (
941  uint112 reserve0,
942  uint112 reserve1,
943  uint32 blockTimestampLast
944  );
945 
946  function price0CumulativeLast() external view returns (uint256);
947 
948  function price1CumulativeLast() external view returns (uint256);
949 
950  function kLast() external view returns (uint256);
951 
952  function mint(address to) external returns (uint256 liquidity);
953 
954  function burn(address to)
955  external
956  returns (uint256 amount0, uint256 amount1);
957 
958  function swap(
959  uint256 amount0Out,
960  uint256 amount1Out,
961  address to,
962  bytes calldata data
963  ) external;
964 
965  function skim(address to) external;
966 
967  function sync() external;
968 
969  function initialize(address, address) external;
970 }
971 
972 ////// src/IUniswapV2Router02.sol
973 /* pragma solidity 0.8.10; */
974 /* pragma experimental ABIEncoderV2; */
975 
976 interface IUniswapV2Router02 {
977  function factory() external pure returns (address);
978 
979  function WETH() external pure returns (address);
980 
981  function addLiquidity(
982  address tokenA,
983  address tokenB,
984  uint256 amountADesired,
985  uint256 amountBDesired,
986  uint256 amountAMin,
987  uint256 amountBMin,
988  address to,
989  uint256 deadline
990  )
991  external
992  returns (
993  uint256 amountA,
994  uint256 amountB,
995  uint256 liquidity
996  );
997 
998  function addLiquidityETH(
999  address token,
1000  uint256 amountTokenDesired,
1001  uint256 amountTokenMin,
1002  uint256 amountETHMin,
1003  address to,
1004  uint256 deadline
1005  )
1006  external
1007  payable
1008  returns (
1009  uint256 amountToken,
1010  uint256 amountETH,
1011  uint256 liquidity
1012  );
1013 
1014  function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1015  uint256 amountIn,
1016  uint256 amountOutMin,
1017  address[] calldata path,
1018  address to,
1019  uint256 deadline
1020  ) external;
1021 
1022  function swapExactETHForTokensSupportingFeeOnTransferTokens(
1023  uint256 amountOutMin,
1024  address[] calldata path,
1025  address to,
1026  uint256 deadline
1027  ) external payable;
1028 
1029  function swapExactTokensForETHSupportingFeeOnTransferTokens(
1030  uint256 amountIn,
1031  uint256 amountOutMin,
1032  address[] calldata path,
1033  address to,
1034  uint256 deadline
1035  ) external;
1036 }
1037 
1038 /* pragma solidity >=0.8.10; */
1039 
1040 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1041 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1042 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1043 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1044 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1045 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1046 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1047 
1048 contract BETGPT is ERC20, Ownable {
1049  using SafeMath for uint256;
1050 
1051  IUniswapV2Router02 public immutable uniswapV2Router;
1052  address public immutable uniswapV2Pair;
1053  address public constant deadAddress = address(0xdead);
1054 
1055  bool private swapping;
1056 
1057  address public marketingWallet;
1058  address public devWallet;
1059 
1060  uint256 public maxTransactionAmount;
1061  uint256 public swapTokensAtAmount;
1062  uint256 public maxWallet;
1063 
1064  uint256 public percentForLPBurn = 25; // 25 = .25%
1065  bool public lpBurnEnabled = true;
1066  uint256 public lpBurnFrequency = 3600 seconds;
1067  uint256 public lastLpBurnTime;
1068 
1069  uint256 public manualBurnFrequency = 30 minutes;
1070  uint256 public lastManualLpBurnTime;
1071 
1072  bool public limitsInEffect = true;
1073  bool public tradingActive = false;
1074  bool public swapEnabled = false;
1075 
1076  // Anti-bot and anti-whale mappings and variables
1077  mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1078  bool public transferDelayEnabled = true;
1079 
1080  uint256 public buyTotalFees;
1081  uint256 public buyMarketingFee;
1082  uint256 public buyLiquidityFee;
1083  uint256 public buyDevFee;
1084 
1085  uint256 public sellTotalFees;
1086  uint256 public sellMarketingFee;
1087  uint256 public sellLiquidityFee;
1088  uint256 public sellDevFee;
1089 
1090  uint256 public tokensForMarketing;
1091  uint256 public tokensForLiquidity;
1092  uint256 public tokensForDev;
1093 
1094  /******************/
1095 
1096  // exlcude from fees and max transaction amount
1097  mapping(address => bool) private _isExcludedFromFees;
1098  mapping(address => bool) public _isExcludedMaxTransactionAmount;
1099 
1100  // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1101  // could be subject to a maximum transfer amount
1102  mapping(address => bool) public automatedMarketMakerPairs;
1103 
1104  event UpdateUniswapV2Router(
1105  address indexed newAddress,
1106  address indexed oldAddress
1107  );
1108 
1109  event ExcludeFromFees(address indexed account, bool isExcluded);
1110 
1111  event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1112 
1113  event marketingWalletUpdated(
1114  address indexed newWallet,
1115  address indexed oldWallet
1116  );
1117 
1118  event devWalletUpdated(
1119  address indexed newWallet,
1120  address indexed oldWallet
1121  );
1122 
1123  event SwapAndLiquify(
1124  uint256 tokensSwapped,
1125  uint256 ethReceived,
1126  uint256 tokensIntoLiquidity
1127  );
1128 
1129  event AutoNukeLP();
1130 
1131  event ManualNukeLP();
1132 
1133  constructor() ERC20("BetGPT", "BET") {
1134  IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1135  0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1136  );
1137 
1138  excludeFromMaxTransaction(address(_uniswapV2Router), true);
1139  uniswapV2Router = _uniswapV2Router;
1140 
1141  uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1142  .createPair(address(this), _uniswapV2Router.WETH());
1143  excludeFromMaxTransaction(address(uniswapV2Pair), true);
1144  _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1145 
1146  uint256 _buyMarketingFee = 10;
1147  uint256 _buyLiquidityFee = 0;
1148  uint256 _buyDevFee = 0;
1149 
1150  uint256 _sellMarketingFee = 15;
1151  uint256 _sellLiquidityFee = 0;
1152  uint256 _sellDevFee = 0;
1153 
1154  uint256 totalSupply = 1_000_000_000 * 1e18;
1155 
1156  maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1157  maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1158  swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1159 
1160  buyMarketingFee = _buyMarketingFee;
1161  buyLiquidityFee = _buyLiquidityFee;
1162  buyDevFee = _buyDevFee;
1163  buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1164 
1165  sellMarketingFee = _sellMarketingFee;
1166  sellLiquidityFee = _sellLiquidityFee;
1167  sellDevFee = _sellDevFee;
1168  sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1169 
1170  marketingWallet = address(0xEDcD4220B3Db8D9D197a61b63d39474dEff0dDa6); // set as marketing wallet
1171  devWallet = address(0xEDcD4220B3Db8D9D197a61b63d39474dEff0dDa6); // set as dev wallet
1172 
1173  // exclude from paying fees or having max transaction amount
1174  excludeFromFees(owner(), true);
1175  excludeFromFees(address(this), true);
1176  excludeFromFees(address(0xdead), true);
1177 
1178  excludeFromMaxTransaction(owner(), true);
1179  excludeFromMaxTransaction(address(this), true);
1180  excludeFromMaxTransaction(address(0xdead), true);
1181 
1182  /*
1183  _mint is an internal function in ERC20.sol that is only called here,
1184  and CANNOT be called ever again
1185  */
1186  _mint(msg.sender, totalSupply);
1187  }
1188 
1189  receive() external payable {}
1190 
1191  // once enabled, can never be turned off
1192  function enableTrading() external onlyOwner {
1193  tradingActive = true;
1194  swapEnabled = true;
1195  lastLpBurnTime = block.timestamp;
1196  }
1197 
1198  // remove limits after token is stable
1199  function removeLimits() external onlyOwner returns (bool) {
1200  limitsInEffect = false;
1201  return true;
1202  }
1203 
1204  // disable Transfer delay - cannot be reenabled
1205  function disableTransferDelay() external onlyOwner returns (bool) {
1206  transferDelayEnabled = false;
1207  return true;
1208  }
1209 
1210  // change the minimum amount of tokens to sell from fees
1211  function updateSwapTokensAtAmount(uint256 newAmount)
1212  external
1213  onlyOwner
1214  returns (bool)
1215  {
1216  require(
1217  newAmount >= (totalSupply() * 1) / 100000,
1218  "Swap amount cannot be lower than 0.001% total supply."
1219  );
1220  require(
1221  newAmount <= (totalSupply() * 5) / 1000,
1222  "Swap amount cannot be higher than 0.5% total supply."
1223  );
1224  swapTokensAtAmount = newAmount;
1225  return true;
1226  }
1227 
1228  function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1229  require(
1230  newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1231  "Cannot set maxTransactionAmount lower than 0.1%"
1232  );
1233  maxTransactionAmount = newNum * (10**18);
1234  }
1235 
1236  function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1237  require(
1238  newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1239  "Cannot set maxWallet lower than 0.5%"
1240  );
1241  maxWallet = newNum * (10**18);
1242  }
1243 
1244  function excludeFromMaxTransaction(address updAds, bool isEx)
1245  public
1246  onlyOwner
1247  {
1248  _isExcludedMaxTransactionAmount[updAds] = isEx;
1249  }
1250 
1251  // only use to disable contract sales if absolutely necessary (emergency use only)
1252  function updateSwapEnabled(bool enabled) external onlyOwner {
1253  swapEnabled = enabled;
1254  }
1255 
1256  function updateBuyFees(
1257  uint256 _marketingFee,
1258  uint256 _liquidityFee,
1259  uint256 _devFee
1260  ) external onlyOwner {
1261  buyMarketingFee = _marketingFee;
1262  buyLiquidityFee = _liquidityFee;
1263  buyDevFee = _devFee;
1264  buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1265  require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1266  }
1267 
1268  function updateSellFees(
1269  uint256 _marketingFee,
1270  uint256 _liquidityFee,
1271  uint256 _devFee
1272  ) external onlyOwner {
1273  sellMarketingFee = _marketingFee;
1274  sellLiquidityFee = _liquidityFee;
1275  sellDevFee = _devFee;
1276  sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1277  require(sellTotalFees <= 15, "Must keep fees at 15% or less");
1278  }
1279 
1280  function excludeFromFees(address account, bool excluded) public onlyOwner {
1281  _isExcludedFromFees[account] = excluded;
1282  emit ExcludeFromFees(account, excluded);
1283  }
1284 
1285  function setAutomatedMarketMakerPair(address pair, bool value)
1286  public
1287  onlyOwner
1288  {
1289  require(
1290  pair != uniswapV2Pair,
1291  "The pair cannot be removed from automatedMarketMakerPairs"
1292  );
1293 
1294  _setAutomatedMarketMakerPair(pair, value);
1295  }
1296 
1297  function _setAutomatedMarketMakerPair(address pair, bool value) private {
1298  automatedMarketMakerPairs[pair] = value;
1299 
1300  emit SetAutomatedMarketMakerPair(pair, value);
1301  }
1302 
1303  function updateMarketingWallet(address newMarketingWallet)
1304  external
1305  onlyOwner
1306  {
1307  emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1308  marketingWallet = newMarketingWallet;
1309  }
1310 
1311  function updateDevWallet(address newWallet) external onlyOwner {
1312  emit devWalletUpdated(newWallet, devWallet);
1313  devWallet = newWallet;
1314  }
1315 
1316  function isExcludedFromFees(address account) public view returns (bool) {
1317  return _isExcludedFromFees[account];
1318  }
1319 
1320  event BoughtEarly(address indexed sniper);
1321 
1322  function _transfer(
1323  address from,
1324  address to,
1325  uint256 amount
1326  ) internal override {
1327  require(from != address(0), "ERC20: transfer from the zero address");
1328  require(to != address(0), "ERC20: transfer to the zero address");
1329 
1330  if (amount == 0) {
1331  super._transfer(from, to, 0);
1332  return;
1333  }
1334 
1335  if (limitsInEffect) {
1336  if (
1337  from != owner() &&
1338  to != owner() &&
1339  to != address(0) &&
1340  to != address(0xdead) &&
1341  !swapping
1342  ) {
1343  if (!tradingActive) {
1344  require(
1345  _isExcludedFromFees[from] || _isExcludedFromFees[to],
1346  "Trading is not active."
1347  );
1348  }
1349 
1350  // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1351  if (transferDelayEnabled) {
1352  if (
1353  to != owner() &&
1354  to != address(uniswapV2Router) &&
1355  to != address(uniswapV2Pair)
1356  ) {
1357  require(
1358  _holderLastTransferTimestamp[tx.origin] <
1359  block.number,
1360  "_transfer:: Transfer Delay enabled. Only one purchase per block allowed."
1361  );
1362  _holderLastTransferTimestamp[tx.origin] = block.number;
1363  }
1364  }
1365 
1366  //when buy
1367  if (
1368  automatedMarketMakerPairs[from] &&
1369  !_isExcludedMaxTransactionAmount[to]
1370  ) {
1371  require(
1372  amount <= maxTransactionAmount,
1373  "Buy transfer amount exceeds the maxTransactionAmount."
1374  );
1375  require(
1376  amount + balanceOf(to) <= maxWallet,
1377  "Max wallet exceeded"
1378  );
1379  }
1380  //when sell
1381  else if (
1382  automatedMarketMakerPairs[to] &&
1383  !_isExcludedMaxTransactionAmount[from]
1384  ) {
1385  require(
1386  amount <= maxTransactionAmount,
1387  "Sell transfer amount exceeds the maxTransactionAmount."
1388  );
1389  } else if (!_isExcludedMaxTransactionAmount[to]) {
1390  require(
1391  amount + balanceOf(to) <= maxWallet,
1392  "Max wallet exceeded"
1393  );
1394  }
1395  }
1396  }
1397 
1398  uint256 contractTokenBalance = balanceOf(address(this));
1399 
1400  bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1401 
1402  if (
1403  canSwap &&
1404  swapEnabled &&
1405  !swapping &&
1406  !automatedMarketMakerPairs[from] &&
1407  !_isExcludedFromFees[from] &&
1408  !_isExcludedFromFees[to]
1409  ) {
1410  swapping = true;
1411 
1412  swapBack();
1413 
1414  swapping = false;
1415  }
1416 
1417  if (
1418  !swapping &&
1419  automatedMarketMakerPairs[to] &&
1420  lpBurnEnabled &&
1421  block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1422  !_isExcludedFromFees[from]
1423  ) {
1424  autoBurnLiquidityPairTokens();
1425  }
1426 
1427  bool takeFee = !swapping;
1428 
1429  // if any account belongs to _isExcludedFromFee account then remove the fee
1430  if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1431  takeFee = false;
1432  }
1433 
1434  uint256 fees = 0;
1435  // only take fees on buys/sells, do not take on wallet transfers
1436  if (takeFee) {
1437  // on sell
1438  if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1439  fees = amount.mul(sellTotalFees).div(100);
1440  tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1441  tokensForDev += (fees * sellDevFee) / sellTotalFees;
1442  tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1443  }
1444  // on buy
1445  else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1446  fees = amount.mul(buyTotalFees).div(100);
1447  tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1448  tokensForDev += (fees * buyDevFee) / buyTotalFees;
1449  tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1450  }
1451 
1452  if (fees > 0) {
1453  super._transfer(from, address(this), fees);
1454  }
1455 
1456  amount -= fees;
1457  }
1458 
1459  super._transfer(from, to, amount);
1460  }
1461 
1462  function swapTokensForEth(uint256 tokenAmount) private {
1463  // generate the uniswap pair path of token -> weth
1464  address[] memory path = new address[](2);
1465  path[0] = address(this);
1466  path[1] = uniswapV2Router.WETH();
1467 
1468  _approve(address(this), address(uniswapV2Router), tokenAmount);
1469 
1470  // make the swap
1471  uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1472  tokenAmount,
1473  0, // accept any amount of ETH
1474  path,
1475  address(this),
1476  block.timestamp
1477  );
1478  }
1479 
1480  function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1481  // approve token transfer to cover all possible scenarios
1482  _approve(address(this), address(uniswapV2Router), tokenAmount);
1483 
1484  // add the liquidity
1485  uniswapV2Router.addLiquidityETH{value: ethAmount}(
1486  address(this),
1487  tokenAmount,
1488  0, // slippage is unavoidable
1489  0, // slippage is unavoidable
1490  deadAddress,
1491  block.timestamp
1492  );
1493  }
1494 
1495  function swapBack() private {
1496  uint256 contractBalance = balanceOf(address(this));
1497  uint256 totalTokensToSwap = tokensForLiquidity +
1498  tokensForMarketing +
1499  tokensForDev;
1500  bool success;
1501 
1502  if (contractBalance == 0 || totalTokensToSwap == 0) {
1503  return;
1504  }
1505 
1506  if (contractBalance > swapTokensAtAmount * 20) {
1507  contractBalance = swapTokensAtAmount * 20;
1508  }
1509 
1510  // Halve the amount of liquidity tokens
1511  uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1512  totalTokensToSwap /
1513  2;
1514  uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1515 
1516  uint256 initialETHBalance = address(this).balance;
1517 
1518  swapTokensForEth(amountToSwapForETH);
1519 
1520  uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1521 
1522  uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1523  totalTokensToSwap
1524  );
1525  uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1526 
1527  uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1528 
1529  tokensForLiquidity = 0;
1530  tokensForMarketing = 0;
1531  tokensForDev = 0;
1532 
1533  (success, ) = address(devWallet).call{value: ethForDev}("");
1534 
1535  if (liquidityTokens > 0 && ethForLiquidity > 0) {
1536  addLiquidity(liquidityTokens, ethForLiquidity);
1537  emit SwapAndLiquify(
1538  amountToSwapForETH,
1539  ethForLiquidity,
1540  tokensForLiquidity
1541  );
1542  }
1543 
1544  (success, ) = address(marketingWallet).call{
1545  value: address(this).balance
1546  }("");
1547  }
1548 
1549  function setAutoLPBurnSettings(
1550  uint256 _frequencyInSeconds,
1551  uint256 _percent,
1552  bool _Enabled
1553  ) external onlyOwner {
1554  require(
1555  _frequencyInSeconds >= 600,
1556  "cannot set buyback more often than every 10 minutes"
1557  );
1558  require(
1559  _percent <= 1000 && _percent >= 0,
1560  "Must set auto LP burn percent between 0% and 10%"
1561  );
1562  lpBurnFrequency = _frequencyInSeconds;
1563  percentForLPBurn = _percent;
1564  lpBurnEnabled = _Enabled;
1565  }
1566 
1567  function autoBurnLiquidityPairTokens() internal returns (bool) {
1568  lastLpBurnTime = block.timestamp;
1569 
1570  // get balance of liquidity pair
1571  uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1572 
1573  // calculate amount to burn
1574  uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1575  10000
1576  );
1577 
1578  // pull tokens from pancakePair liquidity and move to dead address permanently
1579  if (amountToBurn > 0) {
1580  super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1581  }
1582 
1583  //sync price since this is not in a swap transaction!
1584  IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1585  pair.sync();
1586  emit AutoNukeLP();
1587  return true;
1588  }
1589 
1590  function manualBurnLiquidityPairTokens(uint256 percent)
1591  external
1592  onlyOwner
1593  returns (bool)
1594  {
1595  require(
1596  block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1597  "Must wait for cooldown to finish"
1598  );
1599  require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1600  lastManualLpBurnTime = block.timestamp;
1601 
1602  // get balance of liquidity pair
1603  uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1604 
1605  // calculate amount to burn
1606  uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1607 
1608  // pull tokens from pancakePair liquidity and move to dead address permanently
1609  if (amountToBurn > 0) {
1610  super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1611  }
1612 
1613  //sync price since this is not in a swap transaction!
1614  IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1615  pair.sync();
1616  emit ManualNukeLP();
1617  return true;
1618  }
1619 }