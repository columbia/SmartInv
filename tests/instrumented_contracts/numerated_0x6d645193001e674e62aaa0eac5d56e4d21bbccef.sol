1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 ////////////////////////////////
6 ///////////// ERC //////////////
7 ////////////////////////////////
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return payable(msg.sender);
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor () {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 }
93 
94 interface IERC20 {
95     /**
96      * @dev Returns the amount of tokens in existence.
97      */
98     function totalSupply() external view returns (uint256);
99 
100     /**
101      * @dev Returns the amount of tokens owned by `account`.
102      */
103     function balanceOf(address account) external view returns (uint256);
104 
105     /**
106      * @dev Moves `amount` tokens from the caller's account to `recipient`.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transfer(address recipient, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Returns the remaining number of tokens that `spender` will be
116      * allowed to spend on behalf of `owner` through {transferFrom}. This is
117      * zero by default.
118      *
119      * This value changes when {approve} or {transferFrom} are called.
120      */
121     function allowance(address owner, address spender) external view returns (uint256);
122 
123     /**
124      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * IMPORTANT: Beware that changing an allowance with this method brings the risk
129      * that someone may use both the old and the new allowance by unfortunate
130      * transaction ordering. One possible solution to mitigate this race
131      * condition is to first reduce the spender's allowance to 0 and set the
132      * desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address spender, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Moves `amount` tokens from `sender` to `recipient` using the
141      * allowance mechanism. `amount` is then deducted from the caller's
142      * allowance.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Emitted when `value` tokens are moved from one account (`from`) to
152      * another (`to`).
153      *
154      * Note that `value` may be zero.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 value);
157 
158     /**
159      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
160      * a call to {approve}. `value` is the new allowance.
161      */
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 /**
166  * @dev Implementation of the {IERC20} interface.
167  *
168  * This implementation is agnostic to the way tokens are created. This means
169  * that a supply mechanism has to be added in a derived contract using {_mint}.
170  * For a generic mechanism see {ERC20PresetMinterPauser}.
171  *
172  * TIP: For a detailed writeup see our guide
173  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
174  * to implement supply mechanisms].
175  *
176  * We have followed general OpenZeppelin guidelines: functions revert instead
177  * of returning `false` on failure. This behavior is nonetheless conventional
178  * and does not conflict with the expectations of ERC20 applications.
179  *
180  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
181  * This allows applications to reconstruct the allowance for all accounts just
182  * by listening to said events. Other implementations of the EIP may not emit
183  * these events, as it isn't required by the specification.
184  *
185  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
186  * functions have been added to mitigate the well-known issues around setting
187  * allowances. See {IERC20-approve}.
188  */
189 contract ERC20 is Context, IERC20 {
190     using SafeMath for uint256;
191 
192     mapping (address => uint256) private _balances;
193 
194     mapping (address => mapping (address => uint256)) private _allowances;
195 
196     uint256 private _totalSupply;
197 
198     string private _name;
199     string private _symbol;
200     uint8 private _decimals;
201 
202     /**
203      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
204      * a default value of 18.
205      *
206      * To select a different value for {decimals}, use {_setupDecimals}.
207      *
208      * All three of these values are immutable: they can only be set once during
209      * construction.
210      */
211     constructor (string memory name_, string memory symbol_) {
212         _name = name_;
213         _symbol = symbol_;
214         _decimals = 18;
215     }
216 
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() public view virtual returns (string memory) {
221         return _name;
222     }
223 
224     /**
225      * @dev Returns the symbol of the token, usually a shorter version of the
226      * name.
227      */
228     function symbol() public view virtual returns (string memory) {
229         return _symbol;
230     }
231 
232     /**
233      * @dev Returns the number of decimals used to get its user representation.
234      * For example, if `decimals` equals `2`, a balance of `505` tokens should
235      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
236      *
237      * Tokens usually opt for a value of 18, imitating the relationship between
238      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
239      * called.
240      *
241      * NOTE: This information is only used for _display_ purposes: it in
242      * no way affects any of the arithmetic of the contract, including
243      * {IERC20-balanceOf} and {IERC20-transfer}.
244      */
245     function decimals() public view virtual returns (uint8) {
246         return _decimals;
247     }
248 
249     /**
250      * @dev See {IERC20-totalSupply}.
251      */
252     function totalSupply() public view virtual override returns (uint256) {
253         return _totalSupply;
254     }
255 
256     /**
257      * @dev See {IERC20-balanceOf}.
258      */
259     function balanceOf(address account) public view virtual override returns (uint256) {
260         return _balances[account];
261     }
262 
263     /**
264      * @dev See {IERC20-transfer}.
265      *
266      * Requirements:
267      *
268      * - `recipient` cannot be the zero address.
269      * - the caller must have a balance of at least `amount`.
270      */
271     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
272         _transfer(_msgSender(), recipient, amount);
273         return true;
274     }
275 
276     /**
277      * @dev See {IERC20-allowance}.
278      */
279     function allowance(address owner, address spender) public view virtual override returns (uint256) {
280         return _allowances[owner][spender];
281     }
282 
283     /**
284      * @dev See {IERC20-approve}.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function approve(address spender, uint256 amount) public virtual override returns (bool) {
291         _approve(_msgSender(), spender, amount);
292         return true;
293     }
294 
295     /**
296      * @dev See {IERC20-transferFrom}.
297      *
298      * Emits an {Approval} event indicating the updated allowance. This is not
299      * required by the EIP. See the note at the beginning of {ERC20}.
300      *
301      * Requirements:
302      *
303      * - `sender` and `recipient` cannot be the zero address.
304      * - `sender` must have a balance of at least `amount`.
305      * - the caller must have allowance for ``sender``'s tokens of at least
306      * `amount`.
307      */
308     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
309         _transfer(sender, recipient, amount);
310         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
311         return true;
312     }
313 
314     /**
315      * @dev Atomically increases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
327         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
328         return true;
329     }
330 
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
347         return true;
348     }
349 
350     /**
351      * @dev Moves tokens `amount` from `sender` to `recipient`.
352      *
353      * This is internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `sender` cannot be the zero address.
361      * - `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      */
364     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
365         require(sender != address(0), "ERC20: transfer from the zero address");
366         require(recipient != address(0), "ERC20: transfer to the zero address");
367 
368         _beforeTokenTransfer(sender, recipient, amount);
369 
370         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
371         _balances[recipient] = _balances[recipient].add(amount);
372         emit Transfer(sender, recipient, amount);
373     }
374 
375     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
376      * the total supply.
377      *
378      * Emits a {Transfer} event with `from` set to the zero address.
379      *
380      * Requirements:
381      *
382      * - `to` cannot be the zero address.
383      */
384     function _mint(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: mint to the zero address");
386 
387         _beforeTokenTransfer(address(0), account, amount);
388 
389         _totalSupply = _totalSupply.add(amount);
390         _balances[account] = _balances[account].add(amount);
391         emit Transfer(address(0), account, amount);
392     }
393 
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: burn from the zero address");
407 
408         _beforeTokenTransfer(account, address(0), amount);
409 
410         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
411         _totalSupply = _totalSupply.sub(amount);
412         emit Transfer(account, address(0), amount);
413     }
414 
415     /**
416      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
417      *
418      * This internal function is equivalent to `approve`, and can be used to
419      * e.g. set automatic allowances for certain subsystems, etc.
420      *
421      * Emits an {Approval} event.
422      *
423      * Requirements:
424      *
425      * - `owner` cannot be the zero address.
426      * - `spender` cannot be the zero address.
427      */
428     function _approve(address owner, address spender, uint256 amount) internal virtual {
429         require(owner != address(0), "ERC20: approve from the zero address");
430         require(spender != address(0), "ERC20: approve to the zero address");
431 
432         _allowances[owner][spender] = amount;
433         emit Approval(owner, spender, amount);
434     }
435 
436     /**
437      * @dev Sets {decimals} to a value other than the default one of 18.
438      *
439      * WARNING: This function should only be called from the constructor. Most
440      * applications that interact with token contracts will not expect
441      * {decimals} to ever change, and may work incorrectly if it does.
442      */
443     function _setupDecimals(uint8 decimals_) internal virtual {
444         _decimals = decimals_;
445     }
446 
447     /**
448      * @dev Hook that is called before any transfer of tokens. This includes
449      * minting and burning.
450      *
451      * Calling conditions:
452      *
453      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
454      * will be to transferred to `to`.
455      * - when `from` is zero, `amount` tokens will be minted for `to`.
456      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
457      * - `from` and `to` are never both zero.
458      *
459      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
460      */
461     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
462 }
463 
464 ////////////////////////////////
465 ////////// Dividend ////////////
466 ////////////////////////////////
467 
468 /*
469 @title Dividend-Paying Token Interface
470 @author Roger Wu (https://github.com/roger-wu)
471 @dev An interface for a dividend-paying token contract.
472 */
473 interface IDividendPayingToken {
474   /// @notice View the amount of dividend in wei that an address can withdraw.
475   /// @param _owner The address of a token holder.
476   /// @return The amount of dividend in wei that `_owner` can withdraw.
477   function dividendOf(address _owner) external view returns(uint256);
478 
479   /// @notice Distributes ether to token holders as dividends.
480   /// @dev SHOULD distribute the paid ether to token holders as dividends.
481   ///  SHOULD NOT directly transfer ether to token holders in this function.
482   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
483   function distributeDividends() external payable;
484 
485   /// @notice Withdraws the ether distributed to the sender.
486   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
487   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
488   function withdrawDividend() external;
489 
490   /// @dev This event MUST emit when ether is distributed to token holders.
491   /// @param from The address which sends ether to this contract.
492   /// @param weiAmount The amount of distributed ether in wei.
493   event DividendsDistributed(
494     address indexed from,
495     uint256 weiAmount
496   );
497 
498   /// @dev This event MUST emit when an address withdraws their dividend.
499   /// @param to The address which withdraws ether from this contract.
500   /// @param weiAmount The amount of withdrawn ether in wei.
501   event DividendWithdrawn(
502     address indexed to,
503     uint256 weiAmount
504   );
505 }
506 
507 /*
508 @title Dividend-Paying Token Optional Interface
509 @author Roger Wu (https://github.com/roger-wu)
510 @dev OPTIONAL functions for a dividend-paying token contract.
511 */
512 interface IDividendPayingTokenOptional {
513   /// @notice View the amount of dividend in wei that an address can withdraw.
514   /// @param _owner The address of a token holder.
515   /// @return The amount of dividend in wei that `_owner` can withdraw.
516   function withdrawableDividendOf(address _owner) external view returns(uint256);
517 
518   /// @notice View the amount of dividend in wei that an address has withdrawn.
519   /// @param _owner The address of a token holder.
520   /// @return The amount of dividend in wei that `_owner` has withdrawn.
521   function withdrawnDividendOf(address _owner) external view returns(uint256);
522 
523   /// @notice View the amount of dividend in wei that an address has earned in total.
524   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
525   /// @param _owner The address of a token holder.
526   /// @return The amount of dividend in wei that `_owner` has earned in total.
527   function accumulativeDividendOf(address _owner) external view returns(uint256);
528 }
529 
530 /*
531 @title Dividend-Paying Token
532 @author Roger Wu (https://github.com/roger-wu)
533 @dev A mintable ERC20 token that allows anyone to pay and distribute ether
534 to token holders as dividends and allows token holders to withdraw their dividends.
535 Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
536 */
537 contract DividendPayingToken is ERC20, IDividendPayingToken, IDividendPayingTokenOptional {
538   using SafeMath for uint256;
539   using SafeMathUint for uint256;
540   using SafeMathInt for int256;
541 
542   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
543   // For more discussion about choosing the value of `magnitude`,
544   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
545   uint256 constant internal magnitude = 2**128;
546 
547   uint256 internal magnifiedDividendPerShare;
548   uint256 internal lastAmount;
549   
550   address public dividendToken = 0x3301Ee63Fb29F863f2333Bd4466acb46CD8323E6;
551 
552   // About dividendCorrection:
553   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
554   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
555   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
556   //   `dividendOf(_user)` should not be changed,
557   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
558   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
559   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
560   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
561   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
562   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
563   mapping(address => int256) internal magnifiedDividendCorrections;
564   mapping(address => uint256) internal withdrawnDividends;
565 
566   uint256 public totalDividendsDistributed;
567   uint256 public gasForTransfer;
568 
569   constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
570         gasForTransfer = 3000;
571   }
572   
573 
574   receive() external payable {
575   }
576 
577   /// @notice Distributes ether to token holders as dividends.
578   /// @dev It reverts if the total supply of tokens is 0.
579   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
580   /// About undistributed ether:
581   ///   In each distribution, there is a small amount of ether not distributed,
582   ///     the magnified amount of which is
583   ///     `(msg.value * magnitude) % totalSupply()`.
584   ///   With a well-chosen `magnitude`, the amount of undistributed ether
585   ///     (de-magnified) in a distribution can be less than 1 wei.
586   ///   We can actually keep track of the undistributed ether in a distribution
587   ///     and try to distribute it in the next distribution,
588   ///     but keeping track of such data on-chain costs much more than
589   ///     the saved ether, so we don't do that.
590   function distributeDividends() public override payable {
591     require(totalSupply() > 0);
592 
593     if (msg.value > 0) {
594       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
595         (msg.value).mul(magnitude) / totalSupply()
596       );
597       emit DividendsDistributed(msg.sender, msg.value);
598 
599       totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
600     }
601   }
602   
603 
604   function distributeDividends(uint256 amount) public {
605     require(totalSupply() > 0);
606 
607     if (amount > 0) {
608       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
609         (amount).mul(magnitude) / totalSupply()
610       );
611       emit DividendsDistributed(msg.sender, amount);
612 
613       totalDividendsDistributed = totalDividendsDistributed.add(amount);
614     }
615   }
616 
617   /// @notice Withdraws the ether distributed to the sender.
618   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
619   function withdrawDividend() public virtual override {
620     _withdrawDividendOfUser(payable(msg.sender));
621   }
622   
623   function setDividendTokenAddress(address newToken) public {
624       dividendToken = newToken;
625   }
626 
627   /// @notice Withdraws the ether distributed to the sender.
628   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
629   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
630     uint256 _withdrawableDividend = withdrawableDividendOf(user);
631     if (_withdrawableDividend > 0) {
632       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
633       emit DividendWithdrawn(user, _withdrawableDividend);
634       bool success = IERC20(dividendToken).transfer(user, _withdrawableDividend);
635 
636       if(!success) {
637         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
638         return 0;
639       }
640 
641       return _withdrawableDividend;
642     }
643 
644     return 0;
645   }
646 
647 
648   /// @notice View the amount of dividend in wei that an address can withdraw.
649   /// @param _owner The address of a token holder.
650   /// @return The amount of dividend in wei that `_owner` can withdraw.
651   function dividendOf(address _owner) public view override returns(uint256) {
652     return withdrawableDividendOf(_owner);
653   }
654 
655   /// @notice View the amount of dividend in wei that an address can withdraw.
656   /// @param _owner The address of a token holder.
657   /// @return The amount of dividend in wei that `_owner` can withdraw.
658   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
659     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
660   }
661 
662   /// @notice View the amount of dividend in wei that an address has withdrawn.
663   /// @param _owner The address of a token holder.
664   /// @return The amount of dividend in wei that `_owner` has withdrawn.
665   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
666     return withdrawnDividends[_owner];
667   }
668 
669 
670   /// @notice View the amount of dividend in wei that an address has earned in total.
671   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
672   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
673   /// @param _owner The address of a token holder.
674   /// @return The amount of dividend in wei that `_owner` has earned in total.
675   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
676     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
677       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
678   }
679 
680   /// @dev Internal function that transfer tokens from one address to another.
681   /// Update magnifiedDividendCorrections to keep dividends unchanged.
682   /// @param from The address to transfer from.
683   /// @param to The address to transfer to.
684   /// @param value The amount to be transferred.
685   function _transfer(address from, address to, uint256 value) internal virtual override {
686     require(false);
687 
688     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
689     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
690     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
691   }
692 
693   /// @dev Internal function that mints tokens to an account.
694   /// Update magnifiedDividendCorrections to keep dividends unchanged.
695   /// @param account The account that will receive the created tokens.
696   /// @param value The amount that will be created.
697   function _mint(address account, uint256 value) internal override {
698     super._mint(account, value);
699 
700     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
701       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
702   }
703 
704   /// @dev Internal function that burns an amount of the token of a given account.
705   /// Update magnifiedDividendCorrections to keep dividends unchanged.
706   /// @param account The account whose tokens will be burnt.
707   /// @param value The amount that will be burnt.
708   function _burn(address account, uint256 value) internal override {
709     super._burn(account, value);
710 
711     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
712       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
713   }
714 
715   function _setBalance(address account, uint256 newBalance) internal {
716     uint256 currentBalance = balanceOf(account);
717 
718     if(newBalance > currentBalance) {
719       uint256 mintAmount = newBalance.sub(currentBalance);
720       _mint(account, mintAmount);
721     } else if(newBalance < currentBalance) {
722       uint256 burnAmount = currentBalance.sub(newBalance);
723       _burn(account, burnAmount);
724     }
725   }
726 }
727 
728 ////////////////////////////////
729 ///////// Interfaces ///////////
730 ////////////////////////////////
731 
732 interface IUniswapV2Factory {
733     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
734 
735     function feeTo() external view returns (address);
736     function feeToSetter() external view returns (address);
737 
738     function getPair(address tokenA, address tokenB) external view returns (address pair);
739     function allPairs(uint) external view returns (address pair);
740     function allPairsLength() external view returns (uint);
741 
742     function createPair(address tokenA, address tokenB) external returns (address pair);
743 
744     function setFeeTo(address) external;
745     function setFeeToSetter(address) external;
746 }
747 
748 interface IUniswapV2Pair {
749     event Approval(address indexed owner, address indexed spender, uint value);
750     event Transfer(address indexed from, address indexed to, uint value);
751 
752     function name() external pure returns (string memory);
753     function symbol() external pure returns (string memory);
754     function decimals() external pure returns (uint8);
755     function totalSupply() external view returns (uint);
756     function balanceOf(address owner) external view returns (uint);
757     function allowance(address owner, address spender) external view returns (uint);
758 
759     function approve(address spender, uint value) external returns (bool);
760     function transfer(address to, uint value) external returns (bool);
761     function transferFrom(address from, address to, uint value) external returns (bool);
762 
763     function DOMAIN_SEPARATOR() external view returns (bytes32);
764     function PERMIT_TYPEHASH() external pure returns (bytes32);
765     function nonces(address owner) external view returns (uint);
766 
767     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
768 
769     event Mint(address indexed sender, uint amount0, uint amount1);
770     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
771     event Swap(
772         address indexed sender,
773         uint amount0In,
774         uint amount1In,
775         uint amount0Out,
776         uint amount1Out,
777         address indexed to
778     );
779     event Sync(uint112 reserve0, uint112 reserve1);
780 
781     function MINIMUM_LIQUIDITY() external pure returns (uint);
782     function factory() external view returns (address);
783     function token0() external view returns (address);
784     function token1() external view returns (address);
785     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
786     function price0CumulativeLast() external view returns (uint);
787     function price1CumulativeLast() external view returns (uint);
788     function kLast() external view returns (uint);
789 
790     function mint(address to) external returns (uint liquidity);
791     function burn(address to) external returns (uint amount0, uint amount1);
792     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
793     function skim(address to) external;
794     function sync() external;
795 
796     function initialize(address, address) external;
797 }
798 
799 interface IUniswapV2Router01 {
800     function factory() external pure returns (address);
801     function WETH() external pure returns (address);
802 
803     function addLiquidity(
804         address tokenA,
805         address tokenB,
806         uint amountADesired,
807         uint amountBDesired,
808         uint amountAMin,
809         uint amountBMin,
810         address to,
811         uint deadline
812     ) external returns (uint amountA, uint amountB, uint liquidity);
813     function addLiquidityETH(
814         address token,
815         uint amountTokenDesired,
816         uint amountTokenMin,
817         uint amountETHMin,
818         address to,
819         uint deadline
820     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
821     function removeLiquidity(
822         address tokenA,
823         address tokenB,
824         uint liquidity,
825         uint amountAMin,
826         uint amountBMin,
827         address to,
828         uint deadline
829     ) external returns (uint amountA, uint amountB);
830     function removeLiquidityETH(
831         address token,
832         uint liquidity,
833         uint amountTokenMin,
834         uint amountETHMin,
835         address to,
836         uint deadline
837     ) external returns (uint amountToken, uint amountETH);
838     function removeLiquidityWithPermit(
839         address tokenA,
840         address tokenB,
841         uint liquidity,
842         uint amountAMin,
843         uint amountBMin,
844         address to,
845         uint deadline,
846         bool approveMax, uint8 v, bytes32 r, bytes32 s
847     ) external returns (uint amountA, uint amountB);
848     function removeLiquidityETHWithPermit(
849         address token,
850         uint liquidity,
851         uint amountTokenMin,
852         uint amountETHMin,
853         address to,
854         uint deadline,
855         bool approveMax, uint8 v, bytes32 r, bytes32 s
856     ) external returns (uint amountToken, uint amountETH);
857     function swapExactTokensForTokens(
858         uint amountIn,
859         uint amountOutMin,
860         address[] calldata path,
861         address to,
862         uint deadline
863     ) external returns (uint[] memory amounts);
864     function swapTokensForExactTokens(
865         uint amountOut,
866         uint amountInMax,
867         address[] calldata path,
868         address to,
869         uint deadline
870     ) external returns (uint[] memory amounts);
871     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
872         external
873         payable
874         returns (uint[] memory amounts);
875     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
876         external
877         returns (uint[] memory amounts);
878     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
879         external
880         returns (uint[] memory amounts);
881     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
882         external
883         payable
884         returns (uint[] memory amounts);
885 
886     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
887     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
888     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
889     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
890     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
891 }
892 
893 interface IUniswapV2Router02 is IUniswapV2Router01 {
894     function removeLiquidityETHSupportingFeeOnTransferTokens(
895         address token,
896         uint liquidity,
897         uint amountTokenMin,
898         uint amountETHMin,
899         address to,
900         uint deadline
901     ) external returns (uint amountETH);
902     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
903         address token,
904         uint liquidity,
905         uint amountTokenMin,
906         uint amountETHMin,
907         address to,
908         uint deadline,
909         bool approveMax, uint8 v, bytes32 r, bytes32 s
910     ) external returns (uint amountETH);
911 
912     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
913         uint amountIn,
914         uint amountOutMin,
915         address[] calldata path,
916         address to,
917         uint deadline
918     ) external;
919     function swapExactETHForTokensSupportingFeeOnTransferTokens(
920         uint amountOutMin,
921         address[] calldata path,
922         address to,
923         uint deadline
924     ) external payable;
925     function swapExactTokensForETHSupportingFeeOnTransferTokens(
926         uint amountIn,
927         uint amountOutMin,
928         address[] calldata path,
929         address to,
930         uint deadline
931     ) external;
932 }
933 
934 ////////////////////////////////
935 ////////// Libraries ///////////
936 ////////////////////////////////
937 
938 library IterableMapping {
939     // Iterable mapping from address to uint;
940     struct Map {
941         address[] keys;
942         mapping(address => uint) values;
943         mapping(address => uint) indexOf;
944         mapping(address => bool) inserted;
945     }
946 
947     function get(Map storage map, address key) public view returns (uint) {
948         return map.values[key];
949     }
950 
951     function getIndexOfKey(Map storage map, address key) public view returns (int) {
952         if(!map.inserted[key]) {
953             return -1;
954         }
955         return int(map.indexOf[key]);
956     }
957 
958     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
959         return map.keys[index];
960     }
961 
962 
963 
964     function size(Map storage map) public view returns (uint) {
965         return map.keys.length;
966     }
967 
968     function set(Map storage map, address key, uint val) public {
969         if (map.inserted[key]) {
970             map.values[key] = val;
971         } else {
972             map.inserted[key] = true;
973             map.values[key] = val;
974             map.indexOf[key] = map.keys.length;
975             map.keys.push(key);
976         }
977     }
978 
979     function remove(Map storage map, address key) public {
980         if (!map.inserted[key]) {
981             return;
982         }
983 
984         delete map.inserted[key];
985         delete map.values[key];
986 
987         uint index = map.indexOf[key];
988         uint lastIndex = map.keys.length - 1;
989         address lastKey = map.keys[lastIndex];
990 
991         map.indexOf[lastKey] = index;
992         delete map.indexOf[key];
993 
994         map.keys[index] = lastKey;
995         map.keys.pop();
996     }
997 }
998 
999 /**
1000  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1001  * checks.
1002  *
1003  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1004  * in bugs, because programmers usually assume that an overflow raises an
1005  * error, which is the standard behavior in high level programming languages.
1006  * `SafeMath` restores this intuition by reverting the transaction when an
1007  * operation overflows.
1008  *
1009  * Using this library instead of the unchecked operations eliminates an entire
1010  * class of bugs, so it's recommended to use it always.
1011  */
1012 library SafeMath {
1013     /**
1014      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1015      *
1016      * _Available since v3.4._
1017      */
1018     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1019         uint256 c = a + b;
1020         if (c < a) return (false, 0);
1021         return (true, c);
1022     }
1023 
1024     /**
1025      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1026      *
1027      * _Available since v3.4._
1028      */
1029     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1030         if (b > a) return (false, 0);
1031         return (true, a - b);
1032     }
1033 
1034     /**
1035      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1036      *
1037      * _Available since v3.4._
1038      */
1039     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1040         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1041         // benefit is lost if 'b' is also tested.
1042         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1043         if (a == 0) return (true, 0);
1044         uint256 c = a * b;
1045         if (c / a != b) return (false, 0);
1046         return (true, c);
1047     }
1048 
1049     /**
1050      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1051      *
1052      * _Available since v3.4._
1053      */
1054     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1055         if (b == 0) return (false, 0);
1056         return (true, a / b);
1057     }
1058 
1059     /**
1060      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1061      *
1062      * _Available since v3.4._
1063      */
1064     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1065         if (b == 0) return (false, 0);
1066         return (true, a % b);
1067     }
1068 
1069     /**
1070      * @dev Returns the addition of two unsigned integers, reverting on
1071      * overflow.
1072      *
1073      * Counterpart to Solidity's `+` operator.
1074      *
1075      * Requirements:
1076      *
1077      * - Addition cannot overflow.
1078      */
1079     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1080         uint256 c = a + b;
1081         require(c >= a, "SafeMath: addition overflow");
1082         return c;
1083     }
1084 
1085     /**
1086      * @dev Returns the subtraction of two unsigned integers, reverting on
1087      * overflow (when the result is negative).
1088      *
1089      * Counterpart to Solidity's `-` operator.
1090      *
1091      * Requirements:
1092      *
1093      * - Subtraction cannot overflow.
1094      */
1095     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1096         require(b <= a, "SafeMath: subtraction overflow");
1097         return a - b;
1098     }
1099 
1100     /**
1101      * @dev Returns the multiplication of two unsigned integers, reverting on
1102      * overflow.
1103      *
1104      * Counterpart to Solidity's `*` operator.
1105      *
1106      * Requirements:
1107      *
1108      * - Multiplication cannot overflow.
1109      */
1110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1111         if (a == 0) return 0;
1112         uint256 c = a * b;
1113         require(c / a == b, "SafeMath: multiplication overflow");
1114         return c;
1115     }
1116 
1117     /**
1118      * @dev Returns the integer division of two unsigned integers, reverting on
1119      * division by zero. The result is rounded towards zero.
1120      *
1121      * Counterpart to Solidity's `/` operator. Note: this function uses a
1122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1123      * uses an invalid opcode to revert (consuming all remaining gas).
1124      *
1125      * Requirements:
1126      *
1127      * - The divisor cannot be zero.
1128      */
1129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1130         require(b > 0, "SafeMath: division by zero");
1131         return a / b;
1132     }
1133 
1134     /**
1135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1136      * reverting when dividing by zero.
1137      *
1138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1139      * opcode (which leaves remaining gas untouched) while Solidity uses an
1140      * invalid opcode to revert (consuming all remaining gas).
1141      *
1142      * Requirements:
1143      *
1144      * - The divisor cannot be zero.
1145      */
1146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1147         require(b > 0, "SafeMath: modulo by zero");
1148         return a % b;
1149     }
1150 
1151     /**
1152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1153      * overflow (when the result is negative).
1154      *
1155      * CAUTION: This function is deprecated because it requires allocating memory for the error
1156      * message unnecessarily. For custom revert reasons use {trySub}.
1157      *
1158      * Counterpart to Solidity's `-` operator.
1159      *
1160      * Requirements:
1161      *
1162      * - Subtraction cannot overflow.
1163      */
1164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1165         require(b <= a, errorMessage);
1166         return a - b;
1167     }
1168 
1169     /**
1170      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1171      * division by zero. The result is rounded towards zero.
1172      *
1173      * CAUTION: This function is deprecated because it requires allocating memory for the error
1174      * message unnecessarily. For custom revert reasons use {tryDiv}.
1175      *
1176      * Counterpart to Solidity's `/` operator. Note: this function uses a
1177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1178      * uses an invalid opcode to revert (consuming all remaining gas).
1179      *
1180      * Requirements:
1181      *
1182      * - The divisor cannot be zero.
1183      */
1184     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1185         require(b > 0, errorMessage);
1186         return a / b;
1187     }
1188 
1189     /**
1190      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1191      * reverting with custom message when dividing by zero.
1192      *
1193      * CAUTION: This function is deprecated because it requires allocating memory for the error
1194      * message unnecessarily. For custom revert reasons use {tryMod}.
1195      *
1196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1197      * opcode (which leaves remaining gas untouched) while Solidity uses an
1198      * invalid opcode to revert (consuming all remaining gas).
1199      *
1200      * Requirements:
1201      *
1202      * - The divisor cannot be zero.
1203      */
1204     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1205         require(b > 0, errorMessage);
1206         return a % b;
1207     }
1208 }
1209 
1210 /**
1211  * @title SafeMathInt
1212  * @dev Math operations with safety checks that revert on error
1213  * @dev SafeMath adapted for int256
1214  * Based on code of  https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMathInt.sol
1215  */
1216 library SafeMathInt {
1217   function mul(int256 a, int256 b) internal pure returns (int256) {
1218     // Prevent overflow when multiplying INT256_MIN with -1
1219     // https://github.com/RequestNetwork/requestNetwork/issues/43
1220     require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
1221 
1222     int256 c = a * b;
1223     require((b == 0) || (c / b == a));
1224     return c;
1225   }
1226 
1227   function div(int256 a, int256 b) internal pure returns (int256) {
1228     // Prevent overflow when dividing INT256_MIN by -1
1229     // https://github.com/RequestNetwork/requestNetwork/issues/43
1230     require(!(a == - 2**255 && b == -1) && (b > 0));
1231 
1232     return a / b;
1233   }
1234 
1235   function sub(int256 a, int256 b) internal pure returns (int256) {
1236     require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
1237 
1238     return a - b;
1239   }
1240 
1241   function add(int256 a, int256 b) internal pure returns (int256) {
1242     int256 c = a + b;
1243     require((b >= 0 && c >= a) || (b < 0 && c < a));
1244     return c;
1245   }
1246 
1247   function toUint256Safe(int256 a) internal pure returns (uint256) {
1248     require(a >= 0);
1249     return uint256(a);
1250   }
1251 }
1252 
1253 /**
1254  * @title SafeMathUint
1255  * @dev Math operations with safety checks that revert on error
1256  */
1257 library SafeMathUint {
1258   function toInt256Safe(uint256 a) internal pure returns (int256) {
1259     int256 b = int256(a);
1260     require(b >= 0);
1261     return b;
1262   }
1263 }
1264 
1265 ////////////////////////////////
1266 /////////// Tokens /////////////
1267 ////////////////////////////////
1268 
1269 contract KitsuneInu is ERC20, Ownable {
1270     using SafeMath for uint256;
1271 
1272     IUniswapV2Router02 public uniswapV2Router;
1273     address public immutable uniswapV2Pair;
1274 
1275     bool private liquidating;
1276 
1277     KitsuneInuDividendTracker public dividendTracker;
1278 
1279     address public liquidityWallet;
1280 
1281     uint256 public constant MAX_SELL_TRANSACTION_AMOUNT = 2500000000 * (10**18);
1282 
1283     uint256 public constant ETH_REWARDS_FEE = 11;
1284     uint256 public constant LIQUIDITY_FEE = 3;
1285     uint256 public constant TOTAL_FEES = ETH_REWARDS_FEE + LIQUIDITY_FEE;
1286     bool _swapEnabled = false;
1287     bool openForPresale = false;
1288     
1289     mapping (address => bool) private _isBlackListedBot;
1290     address[] private _blackListedBots;
1291     
1292     address private _dividendToken = 0x3301Ee63Fb29F863f2333Bd4466acb46CD8323E6;
1293     address public marketingAddress = 0x61B3e99AfA0925EaF18bDeb8810b01b4ed1C895B;
1294     bool _maxBuyEnabled = true;
1295 
1296     // use by default 150,000 gas to process auto-claiming dividends
1297     uint256 public gasForProcessing = 150000;
1298 
1299     // liquidate tokens for ETH when the contract reaches 25000k tokens by default
1300     uint256 public liquidateTokensAtAmount = 25000000 * (10**18);
1301 
1302     // whether the token can already be traded
1303     bool public tradingEnabled;
1304 
1305     function activate() public onlyOwner {
1306         require(!tradingEnabled, "KitsuneInu: Trading is already enabled");
1307         _swapEnabled = true;
1308         tradingEnabled = true;
1309     }
1310 
1311     // exclude from fees and max transaction amount
1312     mapping (address => bool) private _isExcludedFromFees;
1313 
1314     // addresses that can make transfers before presale is over
1315     mapping (address => bool) public canTransferBeforeTradingIsEnabled;
1316 
1317     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1318     // could be subject to a maximum transfer amount
1319     mapping (address => bool) public automatedMarketMakerPairs;
1320 
1321     event UpdatedDividendTracker(address indexed newAddress, address indexed oldAddress);
1322 
1323     event UpdatedUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1324 
1325     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1326 
1327     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1328 
1329     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1330 
1331     event LiquidationThresholdUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1332 
1333     event Liquified(
1334         uint256 tokensSwapped,
1335         uint256 ethReceived,
1336         uint256 tokensIntoLiqudity
1337     );
1338     event SwapAndSendToDev(
1339         uint256 tokensSwapped,
1340         uint256 ethReceived
1341     );
1342     event SentDividends(
1343         uint256 tokensSwapped,
1344         uint256 amount
1345     );
1346 
1347     event ProcessedDividendTracker(
1348         uint256 iterations,
1349         uint256 claims,
1350         uint256 lastProcessedIndex,
1351         bool indexed automatic,
1352         uint256 gas,
1353         address indexed processor
1354     );
1355 
1356     constructor() ERC20("Kitsune Inu", "KITSU") {
1357         dividendTracker = new KitsuneInuDividendTracker();
1358         liquidityWallet = owner();
1359         
1360         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1361         // Create a uniswap pair for this new token
1362         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1363 
1364         uniswapV2Router = _uniswapV2Router;
1365         uniswapV2Pair = _uniswapV2Pair;
1366 
1367         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1368 
1369         // exclude from receiving dividends
1370         dividendTracker.excludeFromDividends(address(dividendTracker));
1371         dividendTracker.excludeFromDividends(address(this));
1372         dividendTracker.excludeFromDividends(owner());
1373         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1374         dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
1375 
1376         // exclude from paying fees or having max transaction amount
1377         excludeFromFees(liquidityWallet);
1378         excludeFromFees(address(this));
1379 
1380         // enable owner wallet to send tokens before presales are over.
1381         canTransferBeforeTradingIsEnabled[owner()] = true;
1382 
1383         /*
1384             _mint is an internal function in ERC20.sol that is only called here,
1385             and CANNOT be called ever again
1386         */
1387         _mint(owner(), 250000000000 * (10**18));
1388     }
1389 
1390     receive() external payable {
1391 
1392     }
1393 
1394     
1395     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1396         require(pair != uniswapV2Pair, "KitsuneInu: The Uniswap pair cannot be removed from automatedMarketMakerPairs");
1397 
1398         _setAutomatedMarketMakerPair(pair, value);
1399     }
1400 
1401     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1402         require(automatedMarketMakerPairs[pair] != value, "KitsuneInu: Automated market maker pair is already set to that value");
1403         automatedMarketMakerPairs[pair] = value;
1404 
1405         if(value) {
1406             dividendTracker.excludeFromDividends(pair);
1407         }
1408 
1409         emit SetAutomatedMarketMakerPair(pair, value);
1410     }
1411 
1412 
1413     function excludeFromFees(address account) public onlyOwner {
1414         require(!_isExcludedFromFees[account], "KitsuneInu: Account is already excluded from fees");
1415         _isExcludedFromFees[account] = true;
1416     }
1417 
1418     function updateGasForTransfer(uint256 gasForTransfer) external onlyOwner {
1419         dividendTracker.updateGasForTransfer(gasForTransfer);
1420     }
1421     
1422     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1423         // Need to make gas fee customizable to future-proof against Ethereum network upgrades.
1424         require(newValue != gasForProcessing, "KitsuneInu: Cannot update gasForProcessing to same value");
1425         emit GasForProcessingUpdated(newValue, gasForProcessing);
1426         gasForProcessing = newValue;
1427     }
1428 
1429     function updateClaimWait(uint256 claimWait) external onlyOwner {
1430         dividendTracker.updateClaimWait(claimWait);
1431     }
1432 
1433     function getGasForTransfer() external view returns(uint256) {
1434         return dividendTracker.gasForTransfer();
1435     }
1436      
1437      function enableDisableDevFee(bool _devFeeEnabled ) public returns (bool){
1438         require(msg.sender == liquidityWallet, "Only Dev Address can disable dev fee");
1439         _swapEnabled = _devFeeEnabled;
1440         return(_swapEnabled);
1441     }
1442     
1443     function setOpenForPresale(bool open )external onlyOwner {
1444         openForPresale = open;
1445     }
1446     
1447     function setMaxBuyEnabled(bool enabled ) external onlyOwner {
1448         _maxBuyEnabled = enabled;
1449     }
1450 
1451     function getClaimWait() external view returns(uint256) {
1452         return dividendTracker.claimWait();
1453     }
1454 
1455     function getTotalDividendsDistributed() external view returns (uint256) {
1456         return dividendTracker.totalDividendsDistributed();
1457     }
1458 
1459     function isExcludedFromFees(address account) public view returns(bool) {
1460         return _isExcludedFromFees[account];
1461     }
1462 
1463     function withdrawableDividendOf(address account) public view returns(uint256) {
1464         return dividendTracker.withdrawableDividendOf(account);
1465     }
1466 
1467     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1468         return dividendTracker.balanceOf(account);
1469     }
1470 
1471 
1472     function addBotToBlackList(address account) external onlyOwner() {
1473         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
1474         require(!_isBlackListedBot[account], "Account is already blacklisted");
1475         _isBlackListedBot[account] = true;
1476         _blackListedBots.push(account);
1477     }
1478 
1479     function removeBotFromBlackList(address account) external onlyOwner() {
1480         require(_isBlackListedBot[account], "Account is not blacklisted");
1481         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1482             if (_blackListedBots[i] == account) {
1483                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
1484                 _isBlackListedBot[account] = false;
1485                 _blackListedBots.pop();
1486                 break;
1487             }
1488         }
1489     }
1490     function getAccountDividendsInfo(address account)
1491     external view returns (
1492         address,
1493         int256,
1494         int256,
1495         uint256,
1496         uint256,
1497         uint256,
1498         uint256,
1499         uint256) {
1500         return dividendTracker.getAccount(account);
1501     }
1502 
1503     function getAccountDividendsInfoAtIndex(uint256 index)
1504     external view returns (
1505         address,
1506         int256,
1507         int256,
1508         uint256,
1509         uint256,
1510         uint256,
1511         uint256,
1512         uint256) {
1513         return dividendTracker.getAccountAtIndex(index);
1514     }
1515 
1516     function processDividendTracker(uint256 gas) external {
1517         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1518         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1519     }
1520 
1521     function claim() external {
1522         dividendTracker.processAccount(payable(msg.sender), false);
1523     }
1524 
1525     function getLastProcessedIndex() external view returns(uint256) {
1526         return dividendTracker.getLastProcessedIndex();
1527     }
1528 
1529     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1530         return dividendTracker.getNumberOfTokenHolders();
1531     }
1532 
1533 
1534     function _transfer(
1535         address from,
1536         address to,
1537         uint256 amount
1538     ) internal override {
1539         require(from != address(0), "ERC20: transfer from the zero address");
1540         require(to != address(0), "ERC20: transfer to the zero address");
1541         
1542          require(!_isBlackListedBot[to], "You have no power here!");
1543          require(!_isBlackListedBot[msg.sender], "You have no power here!");
1544          require(!_isBlackListedBot[from], "You have no power here!");
1545         
1546         //to prevent bots both buys and sells will have a max on launch after only sells will
1547         if(from != owner() && to != owner() && _maxBuyEnabled)
1548             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Transfer amount exceeds the maxTxAmount.");
1549 
1550         bool tradingIsEnabled = tradingEnabled;
1551 
1552         // only whitelisted addresses can make transfers before the public presale is over.
1553         if (!tradingIsEnabled) {
1554             //turn transfer on to allow for whitelist form/mutlisend presale
1555             if(!openForPresale){
1556                 require(canTransferBeforeTradingIsEnabled[from], "KitsuneInu: This account cannot send tokens until trading is enabled");
1557             }
1558         }
1559 
1560             if ((from == uniswapV2Pair || to == uniswapV2Pair) && tradingIsEnabled) {
1561                 //require(!antiBot.scanAddress(from, uniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
1562                // require(!antiBot.scanAddress(to, uniswair, tx.origin), "Beep Beep Boop, You're a piece of poop");
1563             }
1564         
1565 
1566         if (amount == 0) {
1567             super._transfer(from, to, 0);
1568             return;
1569         }
1570 
1571         if (!liquidating &&
1572             tradingIsEnabled &&
1573             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1574             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1575             !_isExcludedFromFees[to] //no max for those excluded from fees
1576         ) {
1577             require(amount <= MAX_SELL_TRANSACTION_AMOUNT, "Sell transfer amount exceeds the MAX_SELL_TRANSACTION_AMOUNT.");
1578         }
1579 
1580         uint256 contractTokenBalance = balanceOf(address(this));
1581 
1582         bool canSwap = contractTokenBalance >= liquidateTokensAtAmount;
1583 
1584         if (tradingIsEnabled &&
1585             canSwap &&
1586             _swapEnabled &&
1587             !liquidating &&
1588             !automatedMarketMakerPairs[from] &&
1589             from != liquidityWallet &&
1590             to != liquidityWallet
1591         ) {
1592             liquidating = true;
1593 
1594             uint256 swapTokens = contractTokenBalance.mul(LIQUIDITY_FEE).div(TOTAL_FEES);
1595             swapAndSendToDev(swapTokens);
1596 
1597             uint256 sellTokens = balanceOf(address(this));
1598             swapAndSendDividends(sellTokens);
1599 
1600             liquidating = false;
1601         }
1602 
1603         bool takeFee = tradingIsEnabled && !liquidating;
1604 
1605         // if any account belongs to _isExcludedFromFee account then remove the fee
1606         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1607             takeFee = false;
1608         }
1609 
1610         if (takeFee) {
1611             uint256 fees = amount.mul(TOTAL_FEES).div(100);
1612             amount = amount.sub(fees);
1613 
1614             super._transfer(from, address(this), fees);
1615         }
1616 
1617         super._transfer(from, to, amount);
1618 
1619         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1620         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {
1621             
1622         }
1623 
1624         if (!liquidating) {
1625             uint256 gas = gasForProcessing;
1626 
1627             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1628                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1629             } catch {
1630 
1631             }
1632         }
1633     }
1634 
1635     function swapAndSendToDev(uint256 tokens) private {
1636         uint256 tokenBalance = tokens;
1637 
1638         // capture the contract's current ETH balance.
1639         // this is so that we can capture exactly the amount of ETH that the
1640         // swap creates, and not make the liquidity event include any ETH that
1641         // has been manually sent to the contract
1642         uint256 initialBalance = address(this).balance;
1643 
1644         // swap tokens for ETH
1645         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1646 
1647         // how much ETH did we just swap into?
1648         uint256 newBalance = address(this).balance.sub(initialBalance);
1649         address payable _devAndMarketingAddress = payable(marketingAddress);
1650         _devAndMarketingAddress.transfer(newBalance);
1651         
1652         emit SwapAndSendToDev(tokens, newBalance);
1653     }
1654 
1655     function swapTokensForDividendToken(uint256 tokenAmount, address recipient) private {
1656         // generate the uniswap pair path of weth -> busd
1657         address[] memory path = new address[](3);
1658         path[0] = address(this);
1659         path[1] = uniswapV2Router.WETH();
1660         path[2] = _dividendToken;
1661 
1662         _approve(address(this), address(uniswapV2Router), tokenAmount);
1663 
1664         // make the swap
1665         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1666             tokenAmount,
1667             0, // accept any amount of dividend token
1668             path,
1669             recipient,
1670             block.timestamp
1671         );
1672         
1673     }
1674     
1675      function swapAndSendDividends(uint256 tokens) private {
1676         swapTokensForDividendToken(tokens, address(this));
1677         uint256 dividends = IERC20(_dividendToken).balanceOf(address(this));
1678         bool success = IERC20(_dividendToken).transfer(address(dividendTracker), dividends);
1679         
1680         if (success) {
1681             dividendTracker.distributeDividends(dividends);
1682             emit SentDividends(tokens, dividends);
1683         }
1684     }
1685 
1686     function swapTokensForEth(uint256 tokenAmount) private {
1687         // generate the uniswap pair path of token -> weth
1688         address[] memory path = new address[](2);
1689         path[0] = address(this);
1690         path[1] = uniswapV2Router.WETH();
1691 
1692         _approve(address(this), address(uniswapV2Router), tokenAmount);
1693 
1694         // make the swap
1695         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1696             tokenAmount,
1697             0, // accept any amount of ETH
1698             path,
1699             address(this),
1700             block.timestamp
1701         );
1702     }
1703 
1704 }
1705 
1706 contract KitsuneInuDividendTracker is DividendPayingToken, Ownable {
1707     using SafeMath for uint256;
1708     using SafeMathInt for int256;
1709     using IterableMapping for IterableMapping.Map;
1710 
1711     IterableMapping.Map private tokenHoldersMap;
1712     uint256 public lastProcessedIndex;
1713 
1714     mapping (address => bool) public excludedFromDividends;
1715 
1716     mapping (address => uint256) public lastClaimTimes;
1717 
1718     uint256 public claimWait;
1719     uint256 public immutable minimumTokenBalanceForDividends;
1720 
1721     event ExcludeFromDividends(address indexed account);
1722     event GasForTransferUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1723     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1724 
1725     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1726 
1727     constructor() DividendPayingToken("KitsuneInu_Dividend_Tracker", "KitsuneInu_Dividend_Tracker") {
1728     	claimWait = 3600;
1729         minimumTokenBalanceForDividends = 2500000 * (10**18); //must hold 2500000+ tokens
1730     }
1731 
1732     function _transfer(address, address, uint256) pure internal override {
1733         require(false, "KitsuneInu_Dividend_Tracker: No transfers allowed");
1734     }
1735 
1736     function withdrawDividend() pure public override {
1737         require(false, "KitsuneInu_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main KitsuneInu contract.");
1738     }
1739 
1740     function excludeFromDividends(address account) external onlyOwner {
1741     	require(!excludedFromDividends[account]);
1742     	excludedFromDividends[account] = true;
1743 
1744     	_setBalance(account, 0);
1745     	tokenHoldersMap.remove(account);
1746 
1747     	emit ExcludeFromDividends(account);
1748     }
1749     
1750     
1751       function updateGasForTransfer(uint256 newGasForTransfer) external onlyOwner {
1752         require(newGasForTransfer != gasForTransfer, "KitsuneInu_Dividend_Tracker: Cannot update gasForTransfer to same value");
1753         emit GasForTransferUpdated(newGasForTransfer, gasForTransfer);
1754         gasForTransfer = newGasForTransfer;
1755     }
1756 
1757     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1758         require(newClaimWait >= 1800 && newClaimWait <= 86400, "KitsuneInu_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1759         require(newClaimWait != claimWait, "KitsuneInu_Dividend_Tracker: Cannot update claimWait to same value");
1760         emit ClaimWaitUpdated(newClaimWait, claimWait);
1761         claimWait = newClaimWait;
1762     }
1763 
1764     function getLastProcessedIndex() external view returns(uint256) {
1765     	return lastProcessedIndex;
1766     }
1767 
1768     function getNumberOfTokenHolders() external view returns(uint256) {
1769         return tokenHoldersMap.keys.length;
1770     }
1771 
1772 
1773     function getAccount(address _account)
1774         public view returns (
1775             address account,
1776             int256 index,
1777             int256 iterationsUntilProcessed,
1778             uint256 withdrawableDividends,
1779             uint256 totalDividends,
1780             uint256 lastClaimTime,
1781             uint256 nextClaimTime,
1782             uint256 secondsUntilAutoClaimAvailable) {
1783         account = _account;
1784 
1785         index = tokenHoldersMap.getIndexOfKey(account);
1786 
1787         iterationsUntilProcessed = -1;
1788 
1789         if(index >= 0) {
1790             if(uint256(index) > lastProcessedIndex) {
1791                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1792             }
1793             else {
1794                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1795                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1796                                                         0;
1797 
1798 
1799                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1800             }
1801         }
1802 
1803 
1804         withdrawableDividends = withdrawableDividendOf(account);
1805         totalDividends = accumulativeDividendOf(account);
1806 
1807         lastClaimTime = lastClaimTimes[account];
1808 
1809         nextClaimTime = lastClaimTime > 0 ?
1810                                     lastClaimTime.add(claimWait) :
1811                                     0;
1812 
1813         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1814                                                     nextClaimTime.sub(block.timestamp) :
1815                                                     0;
1816     }
1817 
1818     function getAccountAtIndex(uint256 index)
1819         public view returns (
1820             address,
1821             int256,
1822             int256,
1823             uint256,
1824             uint256,
1825             uint256,
1826             uint256,
1827             uint256) {
1828     	if(index >= tokenHoldersMap.size()) {
1829             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1830         }
1831 
1832         address account = tokenHoldersMap.getKeyAtIndex(index);
1833 
1834         return getAccount(account);
1835     }
1836 
1837     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1838     	if(lastClaimTime > block.timestamp)  {
1839     		return false;
1840     	}
1841 
1842     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1843     }
1844 
1845     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1846     	if(excludedFromDividends[account]) {
1847     		return;
1848     	}
1849 
1850     	if(newBalance >= minimumTokenBalanceForDividends) {
1851             _setBalance(account, newBalance);
1852     		tokenHoldersMap.set(account, newBalance);
1853     	}
1854     	else {
1855             _setBalance(account, 0);
1856     		tokenHoldersMap.remove(account);
1857     	}
1858 
1859     	processAccount(account, true);
1860     }
1861 
1862     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1863     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1864 
1865     	if(numberOfTokenHolders == 0) {
1866     		return (0, 0, lastProcessedIndex);
1867     	}
1868 
1869     	uint256 _lastProcessedIndex = lastProcessedIndex;
1870 
1871     	uint256 gasUsed = 0;
1872 
1873     	uint256 gasLeft = gasleft();
1874 
1875     	uint256 iterations = 0;
1876     	uint256 claims = 0;
1877 
1878     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1879     		_lastProcessedIndex++;
1880 
1881     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1882     			_lastProcessedIndex = 0;
1883     		}
1884 
1885     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1886 
1887     		if(canAutoClaim(lastClaimTimes[account])) {
1888     			if(processAccount(payable(account), true)) {
1889     				claims++;
1890     			}
1891     		}
1892 
1893     		iterations++;
1894 
1895     		uint256 newGasLeft = gasleft();
1896 
1897     		if(gasLeft > newGasLeft) {
1898     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1899     		}
1900 
1901     		gasLeft = newGasLeft;
1902     	}
1903 
1904     	lastProcessedIndex = _lastProcessedIndex;
1905 
1906     	return (iterations, claims, lastProcessedIndex);
1907     }
1908 
1909     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1910         uint256 amount = _withdrawDividendOfUser(account);
1911 
1912     	if(amount > 0) {
1913     		lastClaimTimes[account] = block.timestamp;
1914             emit Claim(account, amount, automatic);
1915     		return true;
1916     	}
1917 
1918     	return false;
1919     }
1920 }