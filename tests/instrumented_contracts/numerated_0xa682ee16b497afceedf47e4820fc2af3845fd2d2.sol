1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 
4 contract Owned {
5     address public owner;
6     address public proposedOwner;
7 
8     event OwnershipTransferred(
9         address indexed previousOwner,
10         address indexed newOwner
11     );
12 
13     /**
14      * @dev Initializes the contract setting the deployer as the initial owner.
15      */
16     constructor() {
17         owner = msg.sender;
18         emit OwnershipTransferred(address(0), msg.sender);
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() virtual {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev propeses a new owner
31      * Can only be called by the current owner.
32      */
33     function proposeOwner(address payable _newOwner) external onlyOwner {
34         proposedOwner = _newOwner;
35     }
36 
37     /**
38      * @dev claims ownership of the contract
39      * Can only be called by the new proposed owner.
40      */
41     function claimOwnership() external {
42         require(msg.sender == proposedOwner);
43         emit OwnershipTransferred(owner, proposedOwner);
44         owner = proposedOwner;
45     }
46 }
47 // File: @openzeppelin/contracts/utils/Context.sol
48 
49 
50 
51 pragma solidity ^0.8.0;
52 
53 /*
54  * @dev Provides information about the current execution context, including the
55  * sender of the transaction and its data. While these are generally available
56  * via msg.sender and msg.data, they should not be accessed in such a direct
57  * manner, since when dealing with meta-transactions the account sending and
58  * paying for execution may not be the actual sender (as far as an application
59  * is concerned).
60  *
61  * This contract is only required for intermediate, library-like contracts.
62  */
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 
68     function _msgData() internal view virtual returns (bytes calldata) {
69         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
70         return msg.data;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
75 
76 
77 
78 
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Interface of the ERC20 standard as defined in the EIP.
84  */
85 interface IERC20 {
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95 
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `recipient`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Returns the remaining number of tokens that `spender` will be
107      * allowed to spend on behalf of `owner` through {transferFrom}. This is
108      * zero by default.
109      *
110      * This value changes when {approve} or {transferFrom} are called.
111      */
112     function allowance(address owner, address spender) external view returns (uint256);
113 
114     /**
115      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * IMPORTANT: Beware that changing an allowance with this method brings the risk
120      * that someone may use both the old and the new allowance by unfortunate
121      * transaction ordering. One possible solution to mitigate this race
122      * condition is to first reduce the spender's allowance to 0 and set the
123      * desired value afterwards:
124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address spender, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Moves `amount` tokens from `sender` to `recipient` using the
132      * allowance mechanism. `amount` is then deducted from the caller's
133      * allowance.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Emitted when `value` tokens are moved from one account (`from`) to
143      * another (`to`).
144      *
145      * Note that `value` may be zero.
146      */
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     /**
150      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
151      * a call to {approve}. `value` is the new allowance.
152      */
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
157 
158 pragma solidity ^0.8.0;
159 
160 
161 /**
162  * @dev Interface for the optional metadata functions from the ERC20 standard.
163  *
164  * _Available since v4.1._
165  */
166 interface IERC20Metadata is IERC20 {
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() external view returns (string memory);
171 
172     /**
173      * @dev Returns the symbol of the token.
174      */
175     function symbol() external view returns (string memory);
176 
177     /**
178      * @dev Returns the decimals places of the token.
179      */
180     function decimals() external view returns (uint8);
181 }
182 
183 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
184 
185 
186 
187 pragma solidity ^0.8.0;
188 
189 
190 
191 
192 /**
193  * @dev Implementation of the {IERC20} interface.
194  *
195  * This implementation is agnostic to the way tokens are created. This means
196  * that a supply mechanism has to be added in a derived contract using {_mint}.
197  * For a generic mechanism see {ERC20PresetMinterPauser}.
198  *
199  * TIP: For a detailed writeup see our guide
200  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
201  * to implement supply mechanisms].
202  *
203  * We have followed general OpenZeppelin guidelines: functions revert instead
204  * of returning `false` on failure. This behavior is nonetheless conventional
205  * and does not conflict with the expectations of ERC20 applications.
206  *
207  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
208  * This allows applications to reconstruct the allowance for all accounts just
209  * by listening to said events. Other implementations of the EIP may not emit
210  * these events, as it isn't required by the specification.
211  *
212  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
213  * functions have been added to mitigate the well-known issues around setting
214  * allowances. See {IERC20-approve}.
215  */
216 contract ERC20 is Context, IERC20, IERC20Metadata {
217     mapping (address => uint256) private _balances;
218 
219     mapping (address => mapping (address => uint256)) private _allowances;
220 
221     uint256 private _totalSupply;
222 
223     string private _name;
224     string private _symbol;
225 
226     /**
227      * @dev Sets the values for {name} and {symbol}.
228      *
229      * The defaut value of {decimals} is 18. To select a different value for
230      * {decimals} you should overload it.
231      *
232      * All two of these values are immutable: they can only be set once during
233      * construction.
234      */
235     constructor (string memory name_, string memory symbol_) {
236         _name = name_;
237         _symbol = symbol_;
238     }
239 
240     /**
241      * @dev Returns the name of the token.
242      */
243     function name() public view virtual override returns (string memory) {
244         return _name;
245     }
246 
247     /**
248      * @dev Returns the symbol of the token, usually a shorter version of the
249      * name.
250      */
251     function symbol() public view virtual override returns (string memory) {
252         return _symbol;
253     }
254 
255     /**
256      * @dev Returns the number of decimals used to get its user representation.
257      * For example, if `decimals` equals `2`, a balance of `505` tokens should
258      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
259      *
260      * Tokens usually opt for a value of 18, imitating the relationship between
261      * Ether and Wei. This is the value {ERC20} uses, unless this function is
262      * overridden;
263      *
264      * NOTE: This information is only used for _display_ purposes: it in
265      * no way affects any of the arithmetic of the contract, including
266      * {IERC20-balanceOf} and {IERC20-transfer}.
267      */
268     function decimals() public view virtual override returns (uint8) {
269         return 18;
270     }
271 
272     /**
273      * @dev See {IERC20-totalSupply}.
274      */
275     function totalSupply() public view virtual override returns (uint256) {
276         return _totalSupply;
277     }
278 
279     /**
280      * @dev See {IERC20-balanceOf}.
281      */
282     function balanceOf(address account) public view virtual override returns (uint256) {
283         return _balances[account];
284     }
285 
286     /**
287      * @dev See {IERC20-transfer}.
288      *
289      * Requirements:
290      *
291      * - `recipient` cannot be the zero address.
292      * - the caller must have a balance of at least `amount`.
293      */
294     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
295         _transfer(_msgSender(), recipient, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-allowance}.
301      */
302     function allowance(address owner, address spender) public view virtual override returns (uint256) {
303         return _allowances[owner][spender];
304     }
305 
306     /**
307      * @dev See {IERC20-approve}.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function approve(address spender, uint256 amount) public virtual override returns (bool) {
314         _approve(_msgSender(), spender, amount);
315         return true;
316     }
317 
318     /**
319      * @dev See {IERC20-transferFrom}.
320      *
321      * Emits an {Approval} event indicating the updated allowance. This is not
322      * required by the EIP. See the note at the beginning of {ERC20}.
323      *
324      * Requirements:
325      *
326      * - `sender` and `recipient` cannot be the zero address.
327      * - `sender` must have a balance of at least `amount`.
328      * - the caller must have allowance for ``sender``'s tokens of at least
329      * `amount`.
330      */
331     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
332         _transfer(sender, recipient, amount);
333 
334         uint256 currentAllowance = _allowances[sender][_msgSender()];
335         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
336         _approve(sender, _msgSender(), currentAllowance - amount);
337 
338         return true;
339     }
340 
341     /**
342      * @dev Atomically increases the allowance granted to `spender` by the caller.
343      *
344      * This is an alternative to {approve} that can be used as a mitigation for
345      * problems described in {IERC20-approve}.
346      *
347      * Emits an {Approval} event indicating the updated allowance.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      */
353     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
354         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
355         return true;
356     }
357 
358     /**
359      * @dev Atomically decreases the allowance granted to `spender` by the caller.
360      *
361      * This is an alternative to {approve} that can be used as a mitigation for
362      * problems described in {IERC20-approve}.
363      *
364      * Emits an {Approval} event indicating the updated allowance.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      * - `spender` must have allowance for the caller of at least
370      * `subtractedValue`.
371      */
372     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
373         uint256 currentAllowance = _allowances[_msgSender()][spender];
374         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
375         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
376 
377         return true;
378     }
379 
380     /**
381      * @dev Moves tokens `amount` from `sender` to `recipient`.
382      *
383      * This is internal function is equivalent to {transfer}, and can be used to
384      * e.g. implement automatic token fees, slashing mechanisms, etc.
385      *
386      * Emits a {Transfer} event.
387      *
388      * Requirements:
389      *
390      * - `sender` cannot be the zero address.
391      * - `recipient` cannot be the zero address.
392      * - `sender` must have a balance of at least `amount`.
393      */
394     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
395         require(sender != address(0), "ERC20: transfer from the zero address");
396         require(recipient != address(0), "ERC20: transfer to the zero address");
397 
398         _beforeTokenTransfer(sender, recipient, amount);
399 
400         uint256 senderBalance = _balances[sender];
401         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
402         _balances[sender] = senderBalance - amount;
403         _balances[recipient] += amount;
404 
405         emit Transfer(sender, recipient, amount);
406     }
407 
408     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
409      * the total supply.
410      *
411      * Emits a {Transfer} event with `from` set to the zero address.
412      *
413      * Requirements:
414      *
415      * - `to` cannot be the zero address.
416      */
417     function _mint(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: mint to the zero address");
419 
420         _beforeTokenTransfer(address(0), account, amount);
421 
422         _totalSupply += amount;
423         _balances[account] += amount;
424         emit Transfer(address(0), account, amount);
425     }
426 
427     /**
428      * @dev Destroys `amount` tokens from `account`, reducing the
429      * total supply.
430      *
431      * Emits a {Transfer} event with `to` set to the zero address.
432      *
433      * Requirements:
434      *
435      * - `account` cannot be the zero address.
436      * - `account` must have at least `amount` tokens.
437      */
438     function _burn(address account, uint256 amount) internal virtual {
439         require(account != address(0), "ERC20: burn from the zero address");
440 
441         _beforeTokenTransfer(account, address(0), amount);
442 
443         uint256 accountBalance = _balances[account];
444         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
445         _balances[account] = accountBalance - amount;
446         _totalSupply -= amount;
447 
448         emit Transfer(account, address(0), amount);
449     }
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
453      *
454      * This internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(address owner, address spender, uint256 amount) internal virtual {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = amount;
469         emit Approval(owner, spender, amount);
470     }
471 
472     /**
473      * @dev Hook that is called before any transfer of tokens. This includes
474      * minting and burning.
475      *
476      * Calling conditions:
477      *
478      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
479      * will be to transferred to `to`.
480      * - when `from` is zero, `amount` tokens will be minted for `to`.
481      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
482      * - `from` and `to` are never both zero.
483      *
484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
485      */
486     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
487 }
488 
489 
490 
491 
492 pragma solidity 0.8.4;
493 
494 
495 
496 contract Pika is ERC20, Owned {
497     uint256 public minSupply;
498     address public beneficiary;
499     bool public feesEnabled;
500     mapping(address => bool) public isExcludedFromFee;
501 
502     event MinSupplyUpdated(uint256 oldAmount, uint256 newAmount);
503     event BeneficiaryUpdated(address oldBeneficiary, address newBeneficiary);
504     event FeesEnabledUpdated(bool enabled);
505     event ExcludedFromFeeUpdated(address account, bool excluded);
506 
507     constructor() ERC20("PIKA", "PIKA") {
508         minSupply = 100000000 ether;
509         uint256 totalSupply = 50000000000000 ether;
510         feesEnabled = false;
511         _mint(_msgSender(), totalSupply);
512         isExcludedFromFee[msg.sender] = true;
513         isExcludedFromFee[0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = true;
514         beneficiary = msg.sender;
515     }
516 
517     /**
518      * @dev if fees are enabled, subtract 2.25% fee and send it to beneficiary
519      * @dev after a certain threshold, try to swap collected fees automatically
520      * @dev if automatic swap fails (or beneficiary does not implement swapTokens function) transfer should still succeed
521      */
522     function _transfer(
523         address sender,
524         address recipient,
525         uint256 amount
526     ) internal override {
527         require(
528             recipient != address(this),
529             "Cannot send tokens to token contract"
530         );
531         if (
532             !feesEnabled ||
533             isExcludedFromFee[sender] ||
534             isExcludedFromFee[recipient]
535         ) {
536             ERC20._transfer(sender, recipient, amount);
537             return;
538         }
539         // burn tokens if min supply not reached yet
540         uint256 burnedFee = calculateFee(amount, 25);
541         if (totalSupply() - burnedFee >= minSupply) {
542             _burn(sender, burnedFee);
543         } else {
544             burnedFee = 0;
545         }
546         uint256 transferFee = calculateFee(amount, 200);
547         ERC20._transfer(sender, beneficiary, transferFee);
548         ERC20._transfer(sender, recipient, amount - transferFee - burnedFee);
549     }
550 
551     function calculateFee(uint256 _amount, uint256 _fee)
552         public
553         pure
554         returns (uint256)
555     {
556         return (_amount * _fee) / 10000;
557     }
558 
559     /**
560      * @notice allows to burn tokens from own balance
561      * @dev only allows burning tokens until minimum supply is reached
562      * @param value amount of tokens to burn
563      */
564     function burn(uint256 value) public {
565         _burn(_msgSender(), value);
566         require(totalSupply() >= minSupply, "total supply exceeds min supply");
567     }
568 
569     /**
570      * @notice sets minimum supply of the token
571      * @dev only callable by owner
572      * @param _newMinSupply new minimum supply
573      */
574     function setMinSupply(uint256 _newMinSupply) public onlyOwner {
575         emit MinSupplyUpdated(minSupply, _newMinSupply);
576         minSupply = _newMinSupply;
577     }
578 
579    
580     /**
581      * @notice sets recipient of transfer fee
582      * @dev only callable by owner
583      * @param _newBeneficiary new beneficiary
584      */
585     function setBeneficiary(address _newBeneficiary) public onlyOwner {
586         setExcludeFromFee(_newBeneficiary, true);
587         emit BeneficiaryUpdated(beneficiary, _newBeneficiary);
588         beneficiary = _newBeneficiary;
589     }
590 
591     /**
592      * @notice sets whether account collects fees on token transfer
593      * @dev only callable by owner
594      * @param _enabled bool whether fees are enabled
595      */
596     function setFeesEnabled(bool _enabled) public onlyOwner {
597         emit FeesEnabledUpdated(_enabled);
598         feesEnabled = _enabled;
599     }
600 
601     /**
602      * @notice adds or removes an account that is exempt from fee collection
603      * @dev only callable by owner
604      * @param _account account to modify
605      * @param _excluded new value
606      */
607     function setExcludeFromFee(address _account, bool _excluded)
608         public
609         onlyOwner
610     {
611         isExcludedFromFee[_account] = _excluded;
612         emit ExcludedFromFeeUpdated(_account, _excluded);
613     }
614 }