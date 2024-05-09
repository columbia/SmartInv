1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-21
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.8.4;
8 
9 ////////////////////////////////
10 ///////////// ERC //////////////
11 ////////////////////////////////
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return payable(msg.sender);
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 interface IERC20 {
99     /**
100      * @dev Returns the amount of tokens in existence.
101      */
102     function totalSupply() external view returns (uint256);
103 
104     /**
105      * @dev Returns the amount of tokens owned by `account`.
106      */
107     function balanceOf(address account) external view returns (uint256);
108 
109     /**
110      * @dev Moves `amount` tokens from the caller's account to `recipient`.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transfer(address recipient, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Returns the remaining number of tokens that `spender` will be
120      * allowed to spend on behalf of `owner` through {transferFrom}. This is
121      * zero by default.
122      *
123      * This value changes when {approve} or {transferFrom} are called.
124      */
125     function allowance(address owner, address spender) external view returns (uint256);
126 
127     /**
128      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * IMPORTANT: Beware that changing an allowance with this method brings the risk
133      * that someone may use both the old and the new allowance by unfortunate
134      * transaction ordering. One possible solution to mitigate this race
135      * condition is to first reduce the spender's allowance to 0 and set the
136      * desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address spender, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Moves `amount` tokens from `sender` to `recipient` using the
145      * allowance mechanism. `amount` is then deducted from the caller's
146      * allowance.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Emitted when `value` tokens are moved from one account (`from`) to
156      * another (`to`).
157      *
158      * Note that `value` may be zero.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 value);
161 
162     /**
163      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
164      * a call to {approve}. `value` is the new allowance.
165      */
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 /**
170  * @dev Implementation of the {IERC20} interface.
171  *
172  * This implementation is agnostic to the way tokens are created. This means
173  * that a supply mechanism has to be added in a derived contract using {_mint}.
174  * For a generic mechanism see {ERC20PresetMinterPauser}.
175  *
176  * TIP: For a detailed writeup see our guide
177  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
178  * to implement supply mechanisms].
179  *
180  * We have followed general OpenZeppelin guidelines: functions revert instead
181  * of returning `false` on failure. This behavior is nonetheless conventional
182  * and does not conflict with the expectations of ERC20 applications.
183  *
184  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
185  * This allows applications to reconstruct the allowance for all accounts just
186  * by listening to said events. Other implementations of the EIP may not emit
187  * these events, as it isn't required by the specification.
188  *
189  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
190  * functions have been added to mitigate the well-known issues around setting
191  * allowances. See {IERC20-approve}.
192  */
193 contract ERC20 is Context, IERC20 {
194     using SafeMath for uint256;
195 
196     mapping (address => uint256) private _balances;
197 
198     mapping (address => mapping (address => uint256)) private _allowances;
199 
200     uint256 private _totalSupply;
201 
202     string private _name;
203     string private _symbol;
204     uint8 private _decimals;
205 
206     /**
207      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
208      * a default value of 18.
209      *
210      * To select a different value for {decimals}, use {_setupDecimals}.
211      *
212      * All three of these values are immutable: they can only be set once during
213      * construction.
214      */
215     constructor (string memory name_, string memory symbol_) {
216         _name = name_;
217         _symbol = symbol_;
218         _decimals = 18;
219     }
220 
221     /**
222      * @dev Returns the name of the token.
223      */
224     function name() public view virtual returns (string memory) {
225         return _name;
226     }
227 
228     /**
229      * @dev Returns the symbol of the token, usually a shorter version of the
230      * name.
231      */
232     function symbol() public view virtual returns (string memory) {
233         return _symbol;
234     }
235 
236     /**
237      * @dev Returns the number of decimals used to get its user representation.
238      * For example, if `decimals` equals `2`, a balance of `505` tokens should
239      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
240      *
241      * Tokens usually opt for a value of 18, imitating the relationship between
242      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
243      * called.
244      *
245      * NOTE: This information is only used for _display_ purposes: it in
246      * no way affects any of the arithmetic of the contract, including
247      * {IERC20-balanceOf} and {IERC20-transfer}.
248      */
249     function decimals() public view virtual returns (uint8) {
250         return _decimals;
251     }
252 
253     /**
254      * @dev See {IERC20-totalSupply}.
255      */
256     function totalSupply() public view virtual override returns (uint256) {
257         return _totalSupply;
258     }
259 
260     /**
261      * @dev See {IERC20-balanceOf}.
262      */
263     function balanceOf(address account) public view virtual override returns (uint256) {
264         return _balances[account];
265     }
266 
267     /**
268      * @dev See {IERC20-transfer}.
269      *
270      * Requirements:
271      *
272      * - `recipient` cannot be the zero address.
273      * - the caller must have a balance of at least `amount`.
274      */
275     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
276         _transfer(_msgSender(), recipient, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-allowance}.
282      */
283     function allowance(address owner, address spender) public view virtual override returns (uint256) {
284         return _allowances[owner][spender];
285     }
286 
287     /**
288      * @dev See {IERC20-approve}.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      */
294     function approve(address spender, uint256 amount) public virtual override returns (bool) {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-transferFrom}.
301      *
302      * Emits an {Approval} event indicating the updated allowance. This is not
303      * required by the EIP. See the note at the beginning of {ERC20}.
304      *
305      * Requirements:
306      *
307      * - `sender` and `recipient` cannot be the zero address.
308      * - `sender` must have a balance of at least `amount`.
309      * - the caller must have allowance for ``sender``'s tokens of at least
310      * `amount`.
311      */
312     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
313         _transfer(sender, recipient, amount);
314         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
315         return true;
316     }
317 
318     /**
319      * @dev Atomically increases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
331         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
332         return true;
333     }
334 
335     /**
336      * @dev Atomically decreases the allowance granted to `spender` by the caller.
337      *
338      * This is an alternative to {approve} that can be used as a mitigation for
339      * problems described in {IERC20-approve}.
340      *
341      * Emits an {Approval} event indicating the updated allowance.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      * - `spender` must have allowance for the caller of at least
347      * `subtractedValue`.
348      */
349     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
350         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
351         return true;
352     }
353 
354     /**
355      * @dev Moves tokens `amount` from `sender` to `recipient`.
356      *
357      * This is internal function is equivalent to {transfer}, and can be used to
358      * e.g. implement automatic token fees, slashing mechanisms, etc.
359      *
360      * Emits a {Transfer} event.
361      *
362      * Requirements:
363      *
364      * - `sender` cannot be the zero address.
365      * - `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      */
368     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
369         require(sender != address(0), "ERC20: transfer from the zero address");
370         require(recipient != address(0), "ERC20: transfer to the zero address");
371 
372         _beforeTokenTransfer(sender, recipient, amount);
373 
374         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
375         _balances[recipient] = _balances[recipient].add(amount);
376         emit Transfer(sender, recipient, amount);
377     }
378 
379     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
380      * the total supply.
381      *
382      * Emits a {Transfer} event with `from` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `to` cannot be the zero address.
387      */
388     function _mint(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: mint to the zero address");
390 
391         _beforeTokenTransfer(address(0), account, amount);
392 
393         _totalSupply = _totalSupply.add(amount);
394         _balances[account] = _balances[account].add(amount);
395         emit Transfer(address(0), account, amount);
396     }
397 
398     /**
399      * @dev Destroys `amount` tokens from `account`, reducing the
400      * total supply.
401      *
402      * Emits a {Transfer} event with `to` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `account` cannot be the zero address.
407      * - `account` must have at least `amount` tokens.
408      */
409     function _burn(address account, uint256 amount) internal virtual {
410         require(account != address(0), "ERC20: burn from the zero address");
411 
412         _beforeTokenTransfer(account, address(0), amount);
413 
414         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
415         _totalSupply = _totalSupply.sub(amount);
416         emit Transfer(account, address(0), amount);
417     }
418 
419     /**
420      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
421      *
422      * This internal function is equivalent to `approve`, and can be used to
423      * e.g. set automatic allowances for certain subsystems, etc.
424      *
425      * Emits an {Approval} event.
426      *
427      * Requirements:
428      *
429      * - `owner` cannot be the zero address.
430      * - `spender` cannot be the zero address.
431      */
432     function _approve(address owner, address spender, uint256 amount) internal virtual {
433         require(owner != address(0), "ERC20: approve from the zero address");
434         require(spender != address(0), "ERC20: approve to the zero address");
435 
436         _allowances[owner][spender] = amount;
437         emit Approval(owner, spender, amount);
438     }
439 
440     /**
441      * @dev Sets {decimals} to a value other than the default one of 18.
442      *
443      * WARNING: This function should only be called from the constructor. Most
444      * applications that interact with token contracts will not expect
445      * {decimals} to ever change, and may work incorrectly if it does.
446      */
447     function _setupDecimals(uint8 decimals_) internal virtual {
448         _decimals = decimals_;
449     }
450 
451     /**
452      * @dev Hook that is called before any transfer of tokens. This includes
453      * minting and burning.
454      *
455      * Calling conditions:
456      *
457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
458      * will be to transferred to `to`.
459      * - when `from` is zero, `amount` tokens will be minted for `to`.
460      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
461      * - `from` and `to` are never both zero.
462      *
463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
464      */
465     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
466 }
467 
468 ////////////////////////////////
469 ////////// Dividend ////////////
470 ////////////////////////////////
471 
472 /*
473 @title Dividend-Paying Token Interface
474 @author Roger Wu (https://github.com/roger-wu)
475 @dev An interface for a dividend-paying token contract.
476 */
477 interface IDividendPayingToken {
478   /// @notice View the amount of dividend in wei that an address can withdraw.
479   /// @param _owner The address of a token holder.
480   /// @return The amount of dividend in wei that `_owner` can withdraw.
481   function dividendOf(address _owner) external view returns(uint256);
482 
483   /// @notice Distributes ether to token holders as dividends.
484   /// @dev SHOULD distribute the paid ether to token holders as dividends.
485   ///  SHOULD NOT directly transfer ether to token holders in this function.
486   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
487   function distributeDividends() external payable;
488 
489   /// @notice Withdraws the ether distributed to the sender.
490   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
491   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
492   function withdrawDividend() external;
493 
494   /// @dev This event MUST emit when ether is distributed to token holders.
495   /// @param from The address which sends ether to this contract.
496   /// @param weiAmount The amount of distributed ether in wei.
497   event DividendsDistributed(
498     address indexed from,
499     uint256 weiAmount
500   );
501 
502   /// @dev This event MUST emit when an address withdraws their dividend.
503   /// @param to The address which withdraws ether from this contract.
504   /// @param weiAmount The amount of withdrawn ether in wei.
505   event DividendWithdrawn(
506     address indexed to,
507     uint256 weiAmount
508   );
509 }
510 
511 /*
512 @title Dividend-Paying Token Optional Interface
513 @author Roger Wu (https://github.com/roger-wu)
514 @dev OPTIONAL functions for a dividend-paying token contract.
515 */
516 interface IDividendPayingTokenOptional {
517   /// @notice View the amount of dividend in wei that an address can withdraw.
518   /// @param _owner The address of a token holder.
519   /// @return The amount of dividend in wei that `_owner` can withdraw.
520   function withdrawableDividendOf(address _owner) external view returns(uint256);
521 
522   /// @notice View the amount of dividend in wei that an address has withdrawn.
523   /// @param _owner The address of a token holder.
524   /// @return The amount of dividend in wei that `_owner` has withdrawn.
525   function withdrawnDividendOf(address _owner) external view returns(uint256);
526 
527   /// @notice View the amount of dividend in wei that an address has earned in total.
528   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
529   /// @param _owner The address of a token holder.
530   /// @return The amount of dividend in wei that `_owner` has earned in total.
531   function accumulativeDividendOf(address _owner) external view returns(uint256);
532 }
533 
534 /*
535 @title Dividend-Paying Token
536 @author Roger Wu (https://github.com/roger-wu)
537 @dev A mintable ERC20 token that allows anyone to pay and distribute ether
538 to token holders as dividends and allows token holders to withdraw their dividends.
539 Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
540 */
541 contract DividendPayingToken is ERC20, IDividendPayingToken, IDividendPayingTokenOptional {
542   using SafeMath for uint256;
543   using SafeMathUint for uint256;
544   using SafeMathInt for int256;
545 
546   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
547   // For more discussion about choosing the value of `magnitude`,
548   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
549   uint256 constant internal magnitude = 2**128;
550 
551   uint256 internal magnifiedDividendPerShare;
552   uint256 internal lastAmount;
553   
554   address public dividendToken = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
555 
556   // About dividendCorrection:
557   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
558   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
559   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
560   //   `dividendOf(_user)` should not be changed,
561   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
562   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
563   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
564   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
565   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
566   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
567   mapping(address => int256) internal magnifiedDividendCorrections;
568   mapping(address => uint256) internal withdrawnDividends;
569 
570   uint256 public totalDividendsDistributed;
571   uint256 public gasForTransfer;
572 
573   constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
574         gasForTransfer = 3000;
575   }
576   
577 
578   receive() external payable {
579   }
580 
581   /// @notice Distributes ether to token holders as dividends.
582   /// @dev It reverts if the total supply of tokens is 0.
583   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
584   /// About undistributed ether:
585   ///   In each distribution, there is a small amount of ether not distributed,
586   ///     the magnified amount of which is
587   ///     `(msg.value * magnitude) % totalSupply()`.
588   ///   With a well-chosen `magnitude`, the amount of undistributed ether
589   ///     (de-magnified) in a distribution can be less than 1 wei.
590   ///   We can actually keep track of the undistributed ether in a distribution
591   ///     and try to distribute it in the next distribution,
592   ///     but keeping track of such data on-chain costs much more than
593   ///     the saved ether, so we don't do that.
594   function distributeDividends() public override payable {
595     require(totalSupply() > 0);
596 
597     if (msg.value > 0) {
598       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
599         (msg.value).mul(magnitude) / totalSupply()
600       );
601       emit DividendsDistributed(msg.sender, msg.value);
602 
603       totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
604     }
605   }
606   
607 
608   function distributeDividends(uint256 amount) public {
609     require(totalSupply() > 0);
610 
611     if (amount > 0) {
612       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
613         (amount).mul(magnitude) / totalSupply()
614       );
615       emit DividendsDistributed(msg.sender, amount);
616 
617       totalDividendsDistributed = totalDividendsDistributed.add(amount);
618     }
619   }
620 
621   /// @notice Withdraws the ether distributed to the sender.
622   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
623   function withdrawDividend() public virtual override {
624     _withdrawDividendOfUser(payable(msg.sender));
625   }
626   
627   function setDividendTokenAddress(address newToken) public {
628       dividendToken = newToken;
629   }
630 
631   /// @notice Withdraws the ether distributed to the sender.
632   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
633   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
634     uint256 _withdrawableDividend = withdrawableDividendOf(user);
635     if (_withdrawableDividend > 0) {
636       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
637       emit DividendWithdrawn(user, _withdrawableDividend);
638       bool success = IERC20(dividendToken).transfer(user, _withdrawableDividend);
639 
640       if(!success) {
641         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
642         return 0;
643       }
644 
645       return _withdrawableDividend;
646     }
647 
648     return 0;
649   }
650 
651 
652   /// @notice View the amount of dividend in wei that an address can withdraw.
653   /// @param _owner The address of a token holder.
654   /// @return The amount of dividend in wei that `_owner` can withdraw.
655   function dividendOf(address _owner) public view override returns(uint256) {
656     return withdrawableDividendOf(_owner);
657   }
658 
659   /// @notice View the amount of dividend in wei that an address can withdraw.
660   /// @param _owner The address of a token holder.
661   /// @return The amount of dividend in wei that `_owner` can withdraw.
662   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
663     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
664   }
665 
666   /// @notice View the amount of dividend in wei that an address has withdrawn.
667   /// @param _owner The address of a token holder.
668   /// @return The amount of dividend in wei that `_owner` has withdrawn.
669   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
670     return withdrawnDividends[_owner];
671   }
672 
673 
674   /// @notice View the amount of dividend in wei that an address has earned in total.
675   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
676   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
677   /// @param _owner The address of a token holder.
678   /// @return The amount of dividend in wei that `_owner` has earned in total.
679   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
680     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
681       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
682   }
683 
684   /// @dev Internal function that transfer tokens from one address to another.
685   /// Update magnifiedDividendCorrections to keep dividends unchanged.
686   /// @param from The address to transfer from.
687   /// @param to The address to transfer to.
688   /// @param value The amount to be transferred.
689   function _transfer(address from, address to, uint256 value) internal virtual override {
690     require(false);
691 
692     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
693     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
694     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
695   }
696 
697   /// @dev Internal function that mints tokens to an account.
698   /// Update magnifiedDividendCorrections to keep dividends unchanged.
699   /// @param account The account that will receive the created tokens.
700   /// @param value The amount that will be created.
701   function _mint(address account, uint256 value) internal override {
702     super._mint(account, value);
703 
704     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
705       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
706   }
707 
708   /// @dev Internal function that burns an amount of the token of a given account.
709   /// Update magnifiedDividendCorrections to keep dividends unchanged.
710   /// @param account The account whose tokens will be burnt.
711   /// @param value The amount that will be burnt.
712   function _burn(address account, uint256 value) internal override {
713     super._burn(account, value);
714 
715     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
716       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
717   }
718 
719   function _setBalance(address account, uint256 newBalance) internal {
720     uint256 currentBalance = balanceOf(account);
721 
722     if(newBalance > currentBalance) {
723       uint256 mintAmount = newBalance.sub(currentBalance);
724       _mint(account, mintAmount);
725     } else if(newBalance < currentBalance) {
726       uint256 burnAmount = currentBalance.sub(newBalance);
727       _burn(account, burnAmount);
728     }
729   }
730 }
731 
732 ////////////////////////////////
733 ///////// Interfaces ///////////
734 ////////////////////////////////
735 
736 interface IUniswapV2Factory {
737     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
738 
739     function feeTo() external view returns (address);
740     function feeToSetter() external view returns (address);
741 
742     function getPair(address tokenA, address tokenB) external view returns (address pair);
743     function allPairs(uint) external view returns (address pair);
744     function allPairsLength() external view returns (uint);
745 
746     function createPair(address tokenA, address tokenB) external returns (address pair);
747 
748     function setFeeTo(address) external;
749     function setFeeToSetter(address) external;
750 }
751 
752 interface IUniswapV2Pair {
753     event Approval(address indexed owner, address indexed spender, uint value);
754     event Transfer(address indexed from, address indexed to, uint value);
755 
756     function name() external pure returns (string memory);
757     function symbol() external pure returns (string memory);
758     function decimals() external pure returns (uint8);
759     function totalSupply() external view returns (uint);
760     function balanceOf(address owner) external view returns (uint);
761     function allowance(address owner, address spender) external view returns (uint);
762 
763     function approve(address spender, uint value) external returns (bool);
764     function transfer(address to, uint value) external returns (bool);
765     function transferFrom(address from, address to, uint value) external returns (bool);
766 
767     function DOMAIN_SEPARATOR() external view returns (bytes32);
768     function PERMIT_TYPEHASH() external pure returns (bytes32);
769     function nonces(address owner) external view returns (uint);
770 
771     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
772 
773     event Mint(address indexed sender, uint amount0, uint amount1);
774     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
775     event Swap(
776         address indexed sender,
777         uint amount0In,
778         uint amount1In,
779         uint amount0Out,
780         uint amount1Out,
781         address indexed to
782     );
783     event Sync(uint112 reserve0, uint112 reserve1);
784 
785     function MINIMUM_LIQUIDITY() external pure returns (uint);
786     function factory() external view returns (address);
787     function token0() external view returns (address);
788     function token1() external view returns (address);
789     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
790     function price0CumulativeLast() external view returns (uint);
791     function price1CumulativeLast() external view returns (uint);
792     function kLast() external view returns (uint);
793 
794     function mint(address to) external returns (uint liquidity);
795     function burn(address to) external returns (uint amount0, uint amount1);
796     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
797     function skim(address to) external;
798     function sync() external;
799 
800     function initialize(address, address) external;
801 }
802 
803 interface IUniswapV2Router01 {
804     function factory() external pure returns (address);
805     function WETH() external pure returns (address);
806 
807     function addLiquidity(
808         address tokenA,
809         address tokenB,
810         uint amountADesired,
811         uint amountBDesired,
812         uint amountAMin,
813         uint amountBMin,
814         address to,
815         uint deadline
816     ) external returns (uint amountA, uint amountB, uint liquidity);
817     function addLiquidityETH(
818         address token,
819         uint amountTokenDesired,
820         uint amountTokenMin,
821         uint amountETHMin,
822         address to,
823         uint deadline
824     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
825     function removeLiquidity(
826         address tokenA,
827         address tokenB,
828         uint liquidity,
829         uint amountAMin,
830         uint amountBMin,
831         address to,
832         uint deadline
833     ) external returns (uint amountA, uint amountB);
834     function removeLiquidityETH(
835         address token,
836         uint liquidity,
837         uint amountTokenMin,
838         uint amountETHMin,
839         address to,
840         uint deadline
841     ) external returns (uint amountToken, uint amountETH);
842     function removeLiquidityWithPermit(
843         address tokenA,
844         address tokenB,
845         uint liquidity,
846         uint amountAMin,
847         uint amountBMin,
848         address to,
849         uint deadline,
850         bool approveMax, uint8 v, bytes32 r, bytes32 s
851     ) external returns (uint amountA, uint amountB);
852     function removeLiquidityETHWithPermit(
853         address token,
854         uint liquidity,
855         uint amountTokenMin,
856         uint amountETHMin,
857         address to,
858         uint deadline,
859         bool approveMax, uint8 v, bytes32 r, bytes32 s
860     ) external returns (uint amountToken, uint amountETH);
861     function swapExactTokensForTokens(
862         uint amountIn,
863         uint amountOutMin,
864         address[] calldata path,
865         address to,
866         uint deadline
867     ) external returns (uint[] memory amounts);
868     function swapTokensForExactTokens(
869         uint amountOut,
870         uint amountInMax,
871         address[] calldata path,
872         address to,
873         uint deadline
874     ) external returns (uint[] memory amounts);
875     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
876         external
877         payable
878         returns (uint[] memory amounts);
879     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
880         external
881         returns (uint[] memory amounts);
882     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
883         external
884         returns (uint[] memory amounts);
885     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
886         external
887         payable
888         returns (uint[] memory amounts);
889 
890     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
891     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
892     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
893     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
894     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
895 }
896 
897 interface IUniswapV2Router02 is IUniswapV2Router01 {
898     function removeLiquidityETHSupportingFeeOnTransferTokens(
899         address token,
900         uint liquidity,
901         uint amountTokenMin,
902         uint amountETHMin,
903         address to,
904         uint deadline
905     ) external returns (uint amountETH);
906     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
907         address token,
908         uint liquidity,
909         uint amountTokenMin,
910         uint amountETHMin,
911         address to,
912         uint deadline,
913         bool approveMax, uint8 v, bytes32 r, bytes32 s
914     ) external returns (uint amountETH);
915 
916     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
917         uint amountIn,
918         uint amountOutMin,
919         address[] calldata path,
920         address to,
921         uint deadline
922     ) external;
923     function swapExactETHForTokensSupportingFeeOnTransferTokens(
924         uint amountOutMin,
925         address[] calldata path,
926         address to,
927         uint deadline
928     ) external payable;
929     function swapExactTokensForETHSupportingFeeOnTransferTokens(
930         uint amountIn,
931         uint amountOutMin,
932         address[] calldata path,
933         address to,
934         uint deadline
935     ) external;
936 }
937 
938 ////////////////////////////////
939 ////////// Libraries ///////////
940 ////////////////////////////////
941 
942 library IterableMapping {
943     // Iterable mapping from address to uint;
944     struct Map {
945         address[] keys;
946         mapping(address => uint) values;
947         mapping(address => uint) indexOf;
948         mapping(address => bool) inserted;
949     }
950 
951     function get(Map storage map, address key) public view returns (uint) {
952         return map.values[key];
953     }
954 
955     function getIndexOfKey(Map storage map, address key) public view returns (int) {
956         if(!map.inserted[key]) {
957             return -1;
958         }
959         return int(map.indexOf[key]);
960     }
961 
962     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
963         return map.keys[index];
964     }
965 
966 
967 
968     function size(Map storage map) public view returns (uint) {
969         return map.keys.length;
970     }
971 
972     function set(Map storage map, address key, uint val) public {
973         if (map.inserted[key]) {
974             map.values[key] = val;
975         } else {
976             map.inserted[key] = true;
977             map.values[key] = val;
978             map.indexOf[key] = map.keys.length;
979             map.keys.push(key);
980         }
981     }
982 
983     function remove(Map storage map, address key) public {
984         if (!map.inserted[key]) {
985             return;
986         }
987 
988         delete map.inserted[key];
989         delete map.values[key];
990 
991         uint index = map.indexOf[key];
992         uint lastIndex = map.keys.length - 1;
993         address lastKey = map.keys[lastIndex];
994 
995         map.indexOf[lastKey] = index;
996         delete map.indexOf[key];
997 
998         map.keys[index] = lastKey;
999         map.keys.pop();
1000     }
1001 }
1002 
1003 /**
1004  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1005  * checks.
1006  *
1007  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1008  * in bugs, because programmers usually assume that an overflow raises an
1009  * error, which is the standard behavior in high level programming languages.
1010  * `SafeMath` restores this intuition by reverting the transaction when an
1011  * operation overflows.
1012  *
1013  * Using this library instead of the unchecked operations eliminates an entire
1014  * class of bugs, so it's recommended to use it always.
1015  */
1016 library SafeMath {
1017     /**
1018      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1019      *
1020      * _Available since v3.4._
1021      */
1022     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1023         uint256 c = a + b;
1024         if (c < a) return (false, 0);
1025         return (true, c);
1026     }
1027 
1028     /**
1029      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1030      *
1031      * _Available since v3.4._
1032      */
1033     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1034         if (b > a) return (false, 0);
1035         return (true, a - b);
1036     }
1037 
1038     /**
1039      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1040      *
1041      * _Available since v3.4._
1042      */
1043     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1044         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1045         // benefit is lost if 'b' is also tested.
1046         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1047         if (a == 0) return (true, 0);
1048         uint256 c = a * b;
1049         if (c / a != b) return (false, 0);
1050         return (true, c);
1051     }
1052 
1053     /**
1054      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1055      *
1056      * _Available since v3.4._
1057      */
1058     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1059         if (b == 0) return (false, 0);
1060         return (true, a / b);
1061     }
1062 
1063     /**
1064      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1065      *
1066      * _Available since v3.4._
1067      */
1068     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1069         if (b == 0) return (false, 0);
1070         return (true, a % b);
1071     }
1072 
1073     /**
1074      * @dev Returns the addition of two unsigned integers, reverting on
1075      * overflow.
1076      *
1077      * Counterpart to Solidity's `+` operator.
1078      *
1079      * Requirements:
1080      *
1081      * - Addition cannot overflow.
1082      */
1083     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1084         uint256 c = a + b;
1085         require(c >= a, "SafeMath: addition overflow");
1086         return c;
1087     }
1088 
1089     /**
1090      * @dev Returns the subtraction of two unsigned integers, reverting on
1091      * overflow (when the result is negative).
1092      *
1093      * Counterpart to Solidity's `-` operator.
1094      *
1095      * Requirements:
1096      *
1097      * - Subtraction cannot overflow.
1098      */
1099     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1100         require(b <= a, "SafeMath: subtraction overflow");
1101         return a - b;
1102     }
1103 
1104     /**
1105      * @dev Returns the multiplication of two unsigned integers, reverting on
1106      * overflow.
1107      *
1108      * Counterpart to Solidity's `*` operator.
1109      *
1110      * Requirements:
1111      *
1112      * - Multiplication cannot overflow.
1113      */
1114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1115         if (a == 0) return 0;
1116         uint256 c = a * b;
1117         require(c / a == b, "SafeMath: multiplication overflow");
1118         return c;
1119     }
1120 
1121     /**
1122      * @dev Returns the integer division of two unsigned integers, reverting on
1123      * division by zero. The result is rounded towards zero.
1124      *
1125      * Counterpart to Solidity's `/` operator. Note: this function uses a
1126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1127      * uses an invalid opcode to revert (consuming all remaining gas).
1128      *
1129      * Requirements:
1130      *
1131      * - The divisor cannot be zero.
1132      */
1133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1134         require(b > 0, "SafeMath: division by zero");
1135         return a / b;
1136     }
1137 
1138     /**
1139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1140      * reverting when dividing by zero.
1141      *
1142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1143      * opcode (which leaves remaining gas untouched) while Solidity uses an
1144      * invalid opcode to revert (consuming all remaining gas).
1145      *
1146      * Requirements:
1147      *
1148      * - The divisor cannot be zero.
1149      */
1150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1151         require(b > 0, "SafeMath: modulo by zero");
1152         return a % b;
1153     }
1154 
1155     /**
1156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1157      * overflow (when the result is negative).
1158      *
1159      * CAUTION: This function is deprecated because it requires allocating memory for the error
1160      * message unnecessarily. For custom revert reasons use {trySub}.
1161      *
1162      * Counterpart to Solidity's `-` operator.
1163      *
1164      * Requirements:
1165      *
1166      * - Subtraction cannot overflow.
1167      */
1168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1169         require(b <= a, errorMessage);
1170         return a - b;
1171     }
1172 
1173     /**
1174      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1175      * division by zero. The result is rounded towards zero.
1176      *
1177      * CAUTION: This function is deprecated because it requires allocating memory for the error
1178      * message unnecessarily. For custom revert reasons use {tryDiv}.
1179      *
1180      * Counterpart to Solidity's `/` operator. Note: this function uses a
1181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1182      * uses an invalid opcode to revert (consuming all remaining gas).
1183      *
1184      * Requirements:
1185      *
1186      * - The divisor cannot be zero.
1187      */
1188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1189         require(b > 0, errorMessage);
1190         return a / b;
1191     }
1192 
1193     /**
1194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1195      * reverting with custom message when dividing by zero.
1196      *
1197      * CAUTION: This function is deprecated because it requires allocating memory for the error
1198      * message unnecessarily. For custom revert reasons use {tryMod}.
1199      *
1200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1201      * opcode (which leaves remaining gas untouched) while Solidity uses an
1202      * invalid opcode to revert (consuming all remaining gas).
1203      *
1204      * Requirements:
1205      *
1206      * - The divisor cannot be zero.
1207      */
1208     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1209         require(b > 0, errorMessage);
1210         return a % b;
1211     }
1212 }
1213 
1214 /**
1215  * @title SafeMathInt
1216  * @dev Math operations with safety checks that revert on error
1217  * @dev SafeMath adapted for int256
1218  * Based on code of  https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMathInt.sol
1219  */
1220 library SafeMathInt {
1221   function mul(int256 a, int256 b) internal pure returns (int256) {
1222     // Prevent overflow when multiplying INT256_MIN with -1
1223     // https://github.com/RequestNetwork/requestNetwork/issues/43
1224     require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
1225 
1226     int256 c = a * b;
1227     require((b == 0) || (c / b == a));
1228     return c;
1229   }
1230 
1231   function div(int256 a, int256 b) internal pure returns (int256) {
1232     // Prevent overflow when dividing INT256_MIN by -1
1233     // https://github.com/RequestNetwork/requestNetwork/issues/43
1234     require(!(a == - 2**255 && b == -1) && (b > 0));
1235 
1236     return a / b;
1237   }
1238 
1239   function sub(int256 a, int256 b) internal pure returns (int256) {
1240     require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
1241 
1242     return a - b;
1243   }
1244 
1245   function add(int256 a, int256 b) internal pure returns (int256) {
1246     int256 c = a + b;
1247     require((b >= 0 && c >= a) || (b < 0 && c < a));
1248     return c;
1249   }
1250 
1251   function toUint256Safe(int256 a) internal pure returns (uint256) {
1252     require(a >= 0);
1253     return uint256(a);
1254   }
1255 }
1256 
1257 /**
1258  * @title SafeMathUint
1259  * @dev Math operations with safety checks that revert on error
1260  */
1261 library SafeMathUint {
1262   function toInt256Safe(uint256 a) internal pure returns (int256) {
1263     int256 b = int256(a);
1264     require(b >= 0);
1265     return b;
1266   }
1267 }
1268 
1269 ////////////////////////////////
1270 /////////// Tokens /////////////
1271 ////////////////////////////////
1272 
1273 contract bSATOSHI is ERC20, Ownable {
1274     using SafeMath for uint256;
1275 
1276     IUniswapV2Router02 public uniswapV2Router;
1277     address public immutable uniswapV2Pair;
1278 
1279     bool private liquidating;
1280 
1281    bSATOSHIDividendTracker public dividendTracker;
1282 
1283     address public liquidityWallet;
1284 
1285     uint256 public constant MAX_SELL_TRANSACTION_AMOUNT = 10000000 * (10**18);
1286 
1287     uint256 public constant ETH_REWARDS_FEE = 8;
1288     uint256 public constant LIQUIDITY_FEE = 6;
1289     uint256 public constant TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
1290     bool _swapEnabled = false;
1291     bool openForPresale = false;
1292     
1293     mapping (address => bool) private _isBlackListedBot;
1294     address[] private _blackListedBots;
1295     
1296     address private _dividendToken = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
1297     bool _maxBuyEnabled = true;
1298 
1299     // use by default 150,000 gas to process auto-claiming dividends
1300     uint256 public gasForProcessing = 150000;
1301 
1302     // liquidate tokens for ETH when the contract reaches 100k tokens by default
1303     uint256 public liquidateTokensAtAmount = 100000 * (10**18);
1304 
1305     // whether the token can already be traded
1306     bool public tradingEnabled;
1307 
1308     function activate() public onlyOwner {
1309         require(!tradingEnabled, "bSATOSHI: Trading is already enabled");
1310         _swapEnabled = true;
1311         tradingEnabled = true;
1312     }
1313 
1314     // exclude from fees and max transaction amount
1315     mapping (address => bool) private _isExcludedFromFees;
1316 
1317     // addresses that can make transfers before presale is over
1318     mapping (address => bool) public canTransferBeforeTradingIsEnabled;
1319 
1320     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1321     // could be subject to a maximum transfer amount
1322     mapping (address => bool) public automatedMarketMakerPairs;
1323 
1324     event UpdatedDividendTracker(address indexed newAddress, address indexed oldAddress);
1325 
1326     event UpdatedUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1327 
1328     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1329 
1330     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1331 
1332     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1333 
1334     event LiquidationThresholdUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1335 
1336     event Liquified(
1337         uint256 tokensSwapped,
1338         uint256 ethReceived,
1339         uint256 tokensIntoLiqudity
1340     );
1341     event SwapAndSendToDev(
1342         uint256 tokensSwapped,
1343         uint256 ethReceived
1344     );
1345     event SentDividends(
1346         uint256 tokensSwapped,
1347         uint256 amount
1348     );
1349 
1350     event ProcessedDividendTracker(
1351         uint256 iterations,
1352         uint256 claims,
1353         uint256 lastProcessedIndex,
1354         bool indexed automatic,
1355         uint256 gas,
1356         address indexed processor
1357     );
1358 
1359     constructor() ERC20("Baby Satoshi", "bSATOSHI") {
1360         dividendTracker = new bSATOSHIDividendTracker();
1361         liquidityWallet = owner();
1362         
1363         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1364         // Create a uniswap pair for this new token
1365         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1366 
1367         uniswapV2Router = _uniswapV2Router;
1368         uniswapV2Pair = _uniswapV2Pair;
1369 
1370         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1371 
1372         // exclude from receiving dividends
1373         dividendTracker.excludeFromDividends(address(dividendTracker));
1374         dividendTracker.excludeFromDividends(address(this));
1375         dividendTracker.excludeFromDividends(owner());
1376         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1377         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1378 
1379         // exclude from paying fees or having max transaction amount
1380         excludeFromFees(liquidityWallet);
1381         excludeFromFees(address(this));
1382 
1383         // enable owner wallet to send tokens before presales are over.
1384         canTransferBeforeTradingIsEnabled[owner()] = true;
1385 
1386         /*
1387             _mint is an internal function in ERC20.sol that is only called here,
1388             and CANNOT be called ever again
1389         */
1390         _mint(owner(), 1000000000 * (10**18));
1391     }
1392 
1393     receive() external payable {
1394 
1395     }
1396 
1397     
1398       function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1399         require(pair != uniswapV2Pair, "bSATOSHI: The Uniswap pair cannot be removed from automatedMarketMakerPairs");
1400 
1401         _setAutomatedMarketMakerPair(pair, value);
1402     }
1403 
1404     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1405         require(automatedMarketMakerPairs[pair] != value, "bSATOSHI: Automated market maker pair is already set to that value");
1406         automatedMarketMakerPairs[pair] = value;
1407 
1408         if(value) {
1409             dividendTracker.excludeFromDividends(pair);
1410         }
1411 
1412         emit SetAutomatedMarketMakerPair(pair, value);
1413     }
1414 
1415 
1416     function excludeFromFees(address account) public onlyOwner {
1417         require(!_isExcludedFromFees[account], "bSATOSHI: Account is already excluded from fees");
1418         _isExcludedFromFees[account] = true;
1419     }
1420 
1421     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
1422         dividendTracker.updateGasForTransfer(gasForTransfer);
1423     }
1424     
1425     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1426         // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1427         require(newValue != gasForProcessing, "bSATOSHI: Cannot update gasForProcessing to same value");
1428         emit GasForProcessingUpdated(newValue, gasForProcessing);
1429         gasForProcessing = newValue;
1430     }
1431 
1432     function updateClaimWait(uint256 claimWait) external onlyOwner {
1433         dividendTracker.updateClaimWait(claimWait);
1434     }
1435 
1436     function getGasForTransfer() external view returns(uint256) {
1437         return dividendTracker.gasForTransfer();
1438     }
1439      
1440      function enableDisableDevFee(bool _devFeeEnabled ) public returns (bool){
1441         require(msg.sender == liquidityWallet, "Only Dev Address can disable dev fee");
1442         _swapEnabled = _devFeeEnabled;
1443         return(_swapEnabled);
1444     }
1445     
1446     function setOpenForPresale(bool open )external onlyOwner {
1447         openForPresale = open;
1448     }
1449     
1450     function setMaxBuyEnabled(bool enabled ) external onlyOwner {
1451         _maxBuyEnabled = enabled;
1452     }
1453 
1454     function getClaimWait() external view returns(uint256) {
1455         return dividendTracker.claimWait();
1456     }
1457 
1458     function getTotalDividendsDistributed() external view returns (uint256) {
1459         return dividendTracker.totalDividendsDistributed();
1460     }
1461 
1462     function isExcludedFromFees(address account) public view returns(bool) {
1463         return _isExcludedFromFees[account];
1464     }
1465 
1466     function withdrawableDividendOf(address account) public view returns(uint256) {
1467         return dividendTracker.withdrawableDividendOf(account);
1468     }
1469 
1470     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1471         return dividendTracker.balanceOf(account);
1472     }
1473 
1474 
1475     function addBotToBlackList(address account) external onlyOwner() {
1476         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
1477         require(!_isBlackListedBot[account], "Account is already blacklisted");
1478         _isBlackListedBot[account] = true;
1479         _blackListedBots.push(account);
1480     }
1481 
1482     function removeBotFromBlackList(address account) external onlyOwner() {
1483         require(_isBlackListedBot[account], "Account is not blacklisted");
1484         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1485             if (_blackListedBots[i] == account) {
1486                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
1487                 _isBlackListedBot[account] = false;
1488                 _blackListedBots.pop();
1489                 break;
1490             }
1491         }
1492     }
1493     function getAccountDividendsInfo(address account)
1494     external view returns (
1495         address,
1496         int256,
1497         int256,
1498         uint256,
1499         uint256,
1500         uint256,
1501         uint256,
1502         uint256) {
1503         return dividendTracker.getAccount(account);
1504     }
1505 
1506     function getAccountDividendsInfoAtIndex(uint256 index)
1507     external view returns (
1508         address,
1509         int256,
1510         int256,
1511         uint256,
1512         uint256,
1513         uint256,
1514         uint256,
1515         uint256) {
1516         return dividendTracker.getAccountAtIndex(index);
1517     }
1518 
1519     function processDividendTracker(uint256 gas) external {
1520         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1521         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1522     }
1523 
1524     function claim() external {
1525         dividendTracker.processAccount(payable(msg.sender), false);
1526     }
1527 
1528     function getLastProcessedIndex() external view returns(uint256) {
1529         return dividendTracker.getLastProcessedIndex();
1530     }
1531 
1532     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1533         return dividendTracker.getNumberOfTokenHolders();
1534     }
1535 
1536 
1537     function _transfer(
1538         address from,
1539         address to,
1540         uint256 amount
1541     ) internal override {
1542         require(from != address(0), "ERC20: transfer from the zero address");
1543         require(to != address(0), "ERC20: transfer to the zero address");
1544         
1545          require(!_isBlackListedBot[to], "You have no power here!");
1546          require(!_isBlackListedBot[msg.sender], "You have no power here!");
1547          require(!_isBlackListedBot[from], "You have no power here!");
1548         
1549         //to prevent bots both buys and sells will have a max on launch after only sells will
1550         if(from != owner() && to != owner() && _maxBuyEnabled)
1551             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Transfer amount exceeds the maxTxAmount.");
1552 
1553         bool tradingIsEnabled = tradingEnabled;
1554 
1555         // only whitelisted addresses can make transfers before the public presale is over.
1556         if (!tradingIsEnabled) {
1557             //turn transfer on to allow for whitelist form/mutlisend presale
1558             if(!openForPresale){
1559                 require(canTransferBeforeTradingIsEnabled[from], "bSATOSHI: This account cannot send tokens until trading is enabled");
1560             }
1561         }
1562 
1563             if ((from == uniswapV2Pair || to == uniswapV2Pair) && tradingIsEnabled) {
1564                 //require(!antiBot.scanAddress(from, uniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
1565                // require(!antiBot.scanAddress(to, uniswair, tx.origin), "Beep Beep Boop, You're a piece of poop");
1566             }
1567         
1568 
1569         if (amount == 0) {
1570             super._transfer(from, to, 0);
1571             return;
1572         }
1573 
1574         if (!liquidating &&
1575             tradingIsEnabled &&
1576             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1577             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1578             !_isExcludedFromFees[to] //no max for those excluded from fees
1579         ) {
1580             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Sell transfer amount exceeds the MAX_SELL_TRANSACTION_AMOUNT.");
1581         }
1582 
1583         uint256 contractTokenBalance = balanceOf(address(this));
1584 
1585         bool canSwap = contractTokenBalance >= liquidateTokensAtAmount;
1586 
1587         if (tradingIsEnabled &&
1588             canSwap &&
1589             _swapEnabled &&
1590             !liquidating &&
1591             !automatedMarketMakerPairs[from] &&
1592             from != liquidityWallet &&
1593             to != liquidityWallet
1594         ) {
1595             liquidating = true;
1596 
1597             uint256 swapTokens = contractTokenBalance.mul(LIQUIDITY_FEE).div(TOTAL_FEES);
1598             swapAndSendToDev(swapTokens);
1599 
1600             uint256 sellTokens = balanceOf(address(this));
1601             swapAndSendDividends(sellTokens);
1602 
1603             liquidating = false;
1604         }
1605 
1606         bool takeFee = tradingIsEnabled && !liquidating;
1607 
1608         // if any account belongs to _isExcludedFromFee account then remove the fee
1609         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1610             takeFee = false;
1611         }
1612 
1613         if (takeFee) {
1614             uint256 fees = amount.mul(TOTAL_FEES).div(100);
1615             amount = amount.sub(fees);
1616 
1617             super._transfer(from, address(this), fees);
1618         }
1619 
1620         super._transfer(from, to, amount);
1621 
1622         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1623         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {
1624             
1625         }
1626 
1627         if (!liquidating) {
1628             uint256 gas = gasForProcessing;
1629 
1630             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1631                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1632             } catch {
1633 
1634             }
1635         }
1636     }
1637 
1638     function swapAndSendToDev(uint256 tokens) private {
1639         uint256 tokenBalance = tokens;
1640 
1641         // capture the contract's current ETH balance.
1642         // this is so that we can capture exactly the amount of ETH that the
1643         // swap creates, and not make the liquidity event include any ETH that
1644         // has been manually sent to the contract
1645         uint256 initialBalance = address(this).balance;
1646 
1647         // swap tokens for ETH
1648         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1649 
1650         // how much ETH did we just swap into?
1651         uint256 newBalance = address(this).balance.sub(initialBalance);
1652         address payable _devAndMarketingAddress = payable(0x15Ff93485d308E7Dc321452CFf8E5aF2aAc4a12c);
1653         _devAndMarketingAddress.transfer(newBalance);
1654         
1655         emit SwapAndSendToDev(tokens, newBalance);
1656     }
1657 
1658     function swapTokensForDividendToken(uint256 tokenAmount, address recipient) private {
1659         // generate the uniswap pair path of weth -> busd
1660         address[] memory path = new address[](3);
1661         path[0] = address(this);
1662         path[1] = uniswapV2Router.WETH();
1663         path[2] = _dividendToken;
1664 
1665         _approve(address(this), address(uniswapV2Router), tokenAmount);
1666 
1667         // make the swap
1668         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1669             tokenAmount,
1670             0, // accept any amount of dividend token
1671             path,
1672             recipient,
1673             block.timestamp
1674         );
1675         
1676     }
1677     
1678      function swapAndSendDividends(uint256 tokens) private {
1679         swapTokensForDividendToken(tokens, address(this));
1680         uint256 dividends = IERC20(_dividendToken).balanceOf(address(this));
1681         bool success = IERC20(_dividendToken).transfer(address(dividendTracker), dividends);
1682         
1683         if (success) {
1684             dividendTracker.distributeDividends(dividends);
1685             emit SentDividends(tokens, dividends);
1686         }
1687     }
1688 
1689     function swapTokensForEth(uint256 tokenAmount) private {
1690         // generate the uniswap pair path of token -> weth
1691         address[] memory path = new address[](2);
1692         path[0] = address(this);
1693         path[1] = uniswapV2Router.WETH();
1694 
1695         _approve(address(this), address(uniswapV2Router), tokenAmount);
1696 
1697         // make the swap
1698         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1699             tokenAmount,
1700             0, // accept any amount of ETH
1701             path,
1702             address(this),
1703             block.timestamp
1704         );
1705     }
1706 
1707 }
1708 
1709 contract bSATOSHIDividendTracker is DividendPayingToken, Ownable {
1710     using SafeMath for uint256;
1711     using SafeMathInt for int256;
1712     using IterableMapping for IterableMapping.Map;
1713 
1714     IterableMapping.Map private tokenHoldersMap;
1715     uint256 public lastProcessedIndex;
1716 
1717     mapping (address => bool) public excludedFromDividends;
1718 
1719     mapping (address => uint256) public lastClaimTimes;
1720 
1721     uint256 public claimWait;
1722     uint256 public immutable minimumTokenBalanceForDividends;
1723 
1724     event ExcludeFromDividends(address indexed account);
1725     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1726     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1727 
1728     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1729 
1730     constructor() DividendPayingToken("bSATOSHI_Dividend_Tracker", "bSATOSHI_Dividend_Tracker") {
1731     	claimWait = 3600;
1732         minimumTokenBalanceForDividends = 10000 * (10**18); //must hold 10000+ tokens
1733     }
1734 
1735     function _transfer(address, address, uint256) pure internal override {
1736         require(false, "bSATOSHI_Dividend_Tracker: No transfers allowed");
1737     }
1738 
1739     function withdrawDividend() pure public override {
1740         require(false, "bSATOSHI_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main bSATOSHI contract.");
1741     }
1742 
1743     function excludeFromDividends(address account) external onlyOwner {
1744     	require(!excludedFromDividends[account]);
1745     	excludedFromDividends[account] = true;
1746 
1747     	_setBalance(account, 0);
1748     	tokenHoldersMap.remove(account);
1749 
1750     	emit ExcludeFromDividends(account);
1751     }
1752     
1753     
1754       function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
1755         require(newGasForTransfer != gasForTransfer, "bSATOSHI_Dividend_Tracker: Cannot update gasForTransfer to same value");
1756         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
1757         gasForTransfer = newGasForTransfer;
1758     }
1759 
1760     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1761         require(newClaimWait >= 1800 && newClaimWait <= 86400, "bSATOSHI_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1762         require(newClaimWait != claimWait, "bSATOSHI_Dividend_Tracker: Cannot update claimWait to same value");
1763         emit ClaimWaitUpdated(newClaimWait, claimWait);
1764         claimWait = newClaimWait;
1765     }
1766 
1767     function getLastProcessedIndex() external view returns(uint256) {
1768     	return lastProcessedIndex;
1769     }
1770 
1771     function getNumberOfTokenHolders() external view returns(uint256) {
1772         return tokenHoldersMap.keys.length;
1773     }
1774 
1775 
1776     function getAccount(address _account)
1777         public view returns (
1778             address account,
1779             int256 index,
1780             int256 iterationsUntilProcessed,
1781             uint256 withdrawableDividends,
1782             uint256 totalDividends,
1783             uint256 lastClaimTime,
1784             uint256 nextClaimTime,
1785             uint256 secondsUntilAutoClaimAvailable) {
1786         account = _account;
1787 
1788         index = tokenHoldersMap.getIndexOfKey(account);
1789 
1790         iterationsUntilProcessed = -1;
1791 
1792         if(index >= 0) {
1793             if(uint256(index) > lastProcessedIndex) {
1794                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1795             }
1796             else {
1797                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1798                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1799                                                         0;
1800 
1801 
1802                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1803             }
1804         }
1805 
1806 
1807         withdrawableDividends = withdrawableDividendOf(account);
1808         totalDividends = accumulativeDividendOf(account);
1809 
1810         lastClaimTime = lastClaimTimes[account];
1811 
1812         nextClaimTime = lastClaimTime > 0 ?
1813                                     lastClaimTime.add(claimWait) :
1814                                     0;
1815 
1816         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1817                                                     nextClaimTime.sub(block.timestamp) :
1818                                                     0;
1819     }
1820 
1821     function getAccountAtIndex(uint256 index)
1822         public view returns (
1823             address,
1824             int256,
1825             int256,
1826             uint256,
1827             uint256,
1828             uint256,
1829             uint256,
1830             uint256) {
1831     	if(index >= tokenHoldersMap.size()) {
1832             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1833         }
1834 
1835         address account = tokenHoldersMap.getKeyAtIndex(index);
1836 
1837         return getAccount(account);
1838     }
1839 
1840     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1841     	if(lastClaimTime > block.timestamp)  {
1842     		return false;
1843     	}
1844 
1845     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1846     }
1847 
1848     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1849     	if(excludedFromDividends[account]) {
1850     		return;
1851     	}
1852 
1853     	if(newBalance >= minimumTokenBalanceForDividends) {
1854             _setBalance(account, newBalance);
1855     		tokenHoldersMap.set(account, newBalance);
1856     	}
1857     	else {
1858             _setBalance(account, 0);
1859     		tokenHoldersMap.remove(account);
1860     	}
1861 
1862     	processAccount(account, true);
1863     }
1864 
1865     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1866     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1867 
1868     	if(numberOfTokenHolders == 0) {
1869     		return (0, 0, lastProcessedIndex);
1870     	}
1871 
1872     	uint256 _lastProcessedIndex = lastProcessedIndex;
1873 
1874     	uint256 gasUsed = 0;
1875 
1876     	uint256 gasLeft = gasleft();
1877 
1878     	uint256 iterations = 0;
1879     	uint256 claims = 0;
1880 
1881     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1882     		_lastProcessedIndex++;
1883 
1884     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1885     			_lastProcessedIndex = 0;
1886     		}
1887 
1888     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1889 
1890     		if(canAutoClaim(lastClaimTimes[account])) {
1891     			if(processAccount(payable(account), true)) {
1892     				claims++;
1893     			}
1894     		}
1895 
1896     		iterations++;
1897 
1898     		uint256 newGasLeft = gasleft();
1899 
1900     		if(gasLeft > newGasLeft) {
1901     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1902     		}
1903 
1904     		gasLeft = newGasLeft;
1905     	}
1906 
1907     	lastProcessedIndex = _lastProcessedIndex;
1908 
1909     	return (iterations, claims, lastProcessedIndex);
1910     }
1911 
1912     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1913         uint256 amount = _withdrawDividendOfUser(account);
1914 
1915     	if(amount > 0) {
1916     		lastClaimTimes[account] = block.timestamp;
1917             emit Claim(account, amount, automatic);
1918     		return true;
1919     	}
1920 
1921     	return false;
1922     }
1923 }