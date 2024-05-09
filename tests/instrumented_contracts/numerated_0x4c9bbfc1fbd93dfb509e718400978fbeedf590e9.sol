1 // /$$$$$$$  /$$$$$$ /$$   /$$  /$$$$$$        /$$$$$$$$  /$$$$$$   /$$$$$$   /$$$$$$  /$$     /$$ /$$$$$$  /$$$$$$$$ /$$$$$$$$ /$$      /$$
2 //| $$__  $$|_  $$_/| $$  /$$/ /$$__  $$      | $$_____/ /$$__  $$ /$$__  $$ /$$__  $$|  $$   /$$//$$__  $$|__  $$__/| $$_____/| $$$    /$$$
3 //| $$  \ $$  | $$  | $$ /$$/ | $$  \ $$      | $$      | $$  \__/| $$  \ $$| $$  \__/ \  $$ /$$/| $$  \__/   | $$   | $$      | $$$$  /$$$$
4 //| $$$$$$$/  | $$  | $$$$$/  | $$$$$$$$      | $$$$$   | $$      | $$  | $$|  $$$$$$   \  $$$$/ |  $$$$$$    | $$   | $$$$$   | $$ $$/$$ $$
5 //| $$____/   | $$  | $$  $$  | $$__  $$      | $$__/   | $$      | $$  | $$ \____  $$   \  $$/   \____  $$   | $$   | $$__/   | $$  $$$| $$
6 //| $$        | $$  | $$\  $$ | $$  | $$      | $$      | $$    $$| $$  | $$ /$$  \ $$    | $$    /$$  \ $$   | $$   | $$      | $$\  $ | $$
7 //| $$       /$$$$$$| $$ \  $$| $$  | $$      | $$$$$$$$|  $$$$$$/|  $$$$$$/|  $$$$$$/    | $$   |  $$$$$$/   | $$   | $$$$$$$$| $$ \/  | $$
8 //|__/      |______/|__/  \__/|__/  |__/      |________/ \______/  \______/  \______/     |__/    \______/    |__/   |________/|__/     |__/
9                                                                                                                                           
10 // website: https://pikacrypto.com
11 
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity 0.8.4;
15 
16 interface IThunder {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     function burn(uint256 value) external;
30 }
31 
32 pragma solidity 0.8.4;
33 
34 contract Owned {
35     address public owner;
36     address public proposedOwner;
37 
38     event OwnershipTransferred(
39         address indexed previousOwner,
40         address indexed newOwner
41     );
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         owner = msg.sender;
48         emit OwnershipTransferred(address(0), msg.sender);
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() virtual {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     /**
60      * @dev propeses a new owner
61      * Can only be called by the current owner.
62      */
63     function proposeOwner(address payable _newOwner) external onlyOwner {
64         proposedOwner = _newOwner;
65     }
66 
67     /**
68      * @dev claims ownership of the contract
69      * Can only be called by the new proposed owner.
70      */
71     function claimOwnership() external {
72         require(msg.sender == proposedOwner);
73         emit OwnershipTransferred(owner, proposedOwner);
74         owner = proposedOwner;
75     }
76 }
77 
78 
79 pragma solidity ^0.8.0;
80 
81 /*
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
98         return msg.data;
99     }
100 }
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 
181 
182 pragma solidity ^0.8.0;
183 
184 
185 /**
186  * @dev Interface for the optional metadata functions from the ERC20 standard.
187  *
188  * _Available since v4.1._
189  */
190 interface IERC20Metadata is IERC20 {
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the symbol of the token.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the decimals places of the token.
203      */
204     function decimals() external view returns (uint8);
205 }
206 
207 
208 
209 
210 pragma solidity ^0.8.0;
211 
212 
213 
214 
215 /**
216  * @dev Implementation of the {IERC20} interface.
217  *
218  * This implementation is agnostic to the way tokens are created. This means
219  * that a supply mechanism has to be added in a derived contract using {_mint}.
220  * For a generic mechanism see {ERC20PresetMinterPauser}.
221  *
222  * TIP: For a detailed writeup see our guide
223  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
224  * to implement supply mechanisms].
225  *
226  * We have followed general OpenZeppelin guidelines: functions revert instead
227  * of returning `false` on failure. This behavior is nonetheless conventional
228  * and does not conflict with the expectations of ERC20 applications.
229  *
230  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
231  * This allows applications to reconstruct the allowance for all accounts just
232  * by listening to said events. Other implementations of the EIP may not emit
233  * these events, as it isn't required by the specification.
234  *
235  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
236  * functions have been added to mitigate the well-known issues around setting
237  * allowances. See {IERC20-approve}.
238  */
239 contract ERC20 is Context, IERC20, IERC20Metadata {
240     mapping (address => uint256) private _balances;
241 
242     mapping (address => mapping (address => uint256)) private _allowances;
243 
244     uint256 private _totalSupply;
245 
246     string private _name;
247     string private _symbol;
248 
249     /**
250      * @dev Sets the values for {name} and {symbol}.
251      *
252      * The defaut value of {decimals} is 18. To select a different value for
253      * {decimals} you should overload it.
254      *
255      * All two of these values are immutable: they can only be set once during
256      * construction.
257      */
258     constructor (string memory name_, string memory symbol_) {
259         _name = name_;
260         _symbol = symbol_;
261     }
262 
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() public view virtual override returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @dev Returns the symbol of the token, usually a shorter version of the
272      * name.
273      */
274     function symbol() public view virtual override returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @dev Returns the number of decimals used to get its user representation.
280      * For example, if `decimals` equals `2`, a balance of `505` tokens should
281      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
282      *
283      * Tokens usually opt for a value of 18, imitating the relationship between
284      * Ether and Wei. This is the value {ERC20} uses, unless this function is
285      * overridden;
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view virtual override returns (uint8) {
292         return 18;
293     }
294 
295     /**
296      * @dev See {IERC20-totalSupply}.
297      */
298     function totalSupply() public view virtual override returns (uint256) {
299         return _totalSupply;
300     }
301 
302     /**
303      * @dev See {IERC20-balanceOf}.
304      */
305     function balanceOf(address account) public view virtual override returns (uint256) {
306         return _balances[account];
307     }
308 
309     /**
310      * @dev See {IERC20-transfer}.
311      *
312      * Requirements:
313      *
314      * - `recipient` cannot be the zero address.
315      * - the caller must have a balance of at least `amount`.
316      */
317     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
318         _transfer(_msgSender(), recipient, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-allowance}.
324      */
325     function allowance(address owner, address spender) public view virtual override returns (uint256) {
326         return _allowances[owner][spender];
327     }
328 
329     /**
330      * @dev See {IERC20-approve}.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      */
336     function approve(address spender, uint256 amount) public virtual override returns (bool) {
337         _approve(_msgSender(), spender, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-transferFrom}.
343      *
344      * Emits an {Approval} event indicating the updated allowance. This is not
345      * required by the EIP. See the note at the beginning of {ERC20}.
346      *
347      * Requirements:
348      *
349      * - `sender` and `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      * - the caller must have allowance for ``sender``'s tokens of at least
352      * `amount`.
353      */
354     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
355         _transfer(sender, recipient, amount);
356 
357         uint256 currentAllowance = _allowances[sender][_msgSender()];
358         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
359         _approve(sender, _msgSender(), currentAllowance - amount);
360 
361         return true;
362     }
363 
364     /**
365      * @dev Atomically increases the allowance granted to `spender` by the caller.
366      *
367      * This is an alternative to {approve} that can be used as a mitigation for
368      * problems described in {IERC20-approve}.
369      *
370      * Emits an {Approval} event indicating the updated allowance.
371      *
372      * Requirements:
373      *
374      * - `spender` cannot be the zero address.
375      */
376     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
377         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
378         return true;
379     }
380 
381     /**
382      * @dev Atomically decreases the allowance granted to `spender` by the caller.
383      *
384      * This is an alternative to {approve} that can be used as a mitigation for
385      * problems described in {IERC20-approve}.
386      *
387      * Emits an {Approval} event indicating the updated allowance.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      * - `spender` must have allowance for the caller of at least
393      * `subtractedValue`.
394      */
395     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
396         uint256 currentAllowance = _allowances[_msgSender()][spender];
397         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
398         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
399 
400         return true;
401     }
402 
403     /**
404      * @dev Moves tokens `amount` from `sender` to `recipient`.
405      *
406      * This is internal function is equivalent to {transfer}, and can be used to
407      * e.g. implement automatic token fees, slashing mechanisms, etc.
408      *
409      * Emits a {Transfer} event.
410      *
411      * Requirements:
412      *
413      * - `sender` cannot be the zero address.
414      * - `recipient` cannot be the zero address.
415      * - `sender` must have a balance of at least `amount`.
416      */
417     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
418         require(sender != address(0), "ERC20: transfer from the zero address");
419         require(recipient != address(0), "ERC20: transfer to the zero address");
420 
421         _beforeTokenTransfer(sender, recipient, amount);
422 
423         uint256 senderBalance = _balances[sender];
424         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
425         _balances[sender] = senderBalance - amount;
426         _balances[recipient] += amount;
427 
428         emit Transfer(sender, recipient, amount);
429     }
430 
431     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
432      * the total supply.
433      *
434      * Emits a {Transfer} event with `from` set to the zero address.
435      *
436      * Requirements:
437      *
438      * - `to` cannot be the zero address.
439      */
440     function _mint(address account, uint256 amount) internal virtual {
441         require(account != address(0), "ERC20: mint to the zero address");
442 
443         _beforeTokenTransfer(address(0), account, amount);
444 
445         _totalSupply += amount;
446         _balances[account] += amount;
447         emit Transfer(address(0), account, amount);
448     }
449 
450     /**
451      * @dev Destroys `amount` tokens from `account`, reducing the
452      * total supply.
453      *
454      * Emits a {Transfer} event with `to` set to the zero address.
455      *
456      * Requirements:
457      *
458      * - `account` cannot be the zero address.
459      * - `account` must have at least `amount` tokens.
460      */
461     function _burn(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: burn from the zero address");
463 
464         _beforeTokenTransfer(account, address(0), amount);
465 
466         uint256 accountBalance = _balances[account];
467         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
468         _balances[account] = accountBalance - amount;
469         _totalSupply -= amount;
470 
471         emit Transfer(account, address(0), amount);
472     }
473 
474     /**
475      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
476      *
477      * This internal function is equivalent to `approve`, and can be used to
478      * e.g. set automatic allowances for certain subsystems, etc.
479      *
480      * Emits an {Approval} event.
481      *
482      * Requirements:
483      *
484      * - `owner` cannot be the zero address.
485      * - `spender` cannot be the zero address.
486      */
487     function _approve(address owner, address spender, uint256 amount) internal virtual {
488         require(owner != address(0), "ERC20: approve from the zero address");
489         require(spender != address(0), "ERC20: approve to the zero address");
490 
491         _allowances[owner][spender] = amount;
492         emit Approval(owner, spender, amount);
493     }
494 
495     /**
496      * @dev Hook that is called before any transfer of tokens. This includes
497      * minting and burning.
498      *
499      * Calling conditions:
500      *
501      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
502      * will be to transferred to `to`.
503      * - when `from` is zero, `amount` tokens will be minted for `to`.
504      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
505      * - `from` and `to` are never both zero.
506      *
507      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
508      */
509     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
510 }
511 
512 
513 pragma solidity 0.8.4;
514 
515 
516 
517 
518 struct Wallets {
519     address team;
520     address charity;
521     address staking;
522     address liquidity;
523 }
524 
525 contract Rai is ERC20, Owned {
526     IThunder thunder;
527     Wallets public thunderWallets;
528     address public beneficiary;
529     bool public feesEnabled;
530     mapping(address => bool) public isExcludedFromFee;
531 
532     event BeneficiaryUpdated(address oldBeneficiary, address newBeneficiary);
533     event FeesEnabledUpdated(bool enabled);
534     event ExcludedFromFeeUpdated(address account, bool excluded);
535     event ThunderWalletsUpdated();
536     event Evolved(uint256 amountThunder, uint256 amountRai);
537 
538     constructor(address _thunder, Wallets memory _thunderWallets) ERC20("RAI", "RAI") {
539         thunder = IThunder(_thunder);
540         thunderWallets = _thunderWallets;
541         // premine for uniswap liquidity
542         uint256 totalSupply = 41000 ether;
543         feesEnabled = false;
544         _mint(_msgSender(), totalSupply);
545         isExcludedFromFee[msg.sender] = true;
546         isExcludedFromFee[0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = true;
547         beneficiary = msg.sender;
548     }
549 
550     function evolve(uint256 _amountThunder) external {
551         thunder.transferFrom(msg.sender, address(this), _amountThunder);
552         uint256 amountRai = _amountThunder / 1000;
553 
554         uint256 burnedThunder = calculateFee(_amountThunder, 2000);
555         thunder.burn(burnedThunder);
556 
557         uint256 lpRewards = calculateFee(_amountThunder, 100);
558         uint256 charityTeamAmount = lpRewards / 2;
559         thunder.transfer(thunderWallets.liquidity, lpRewards);
560         thunder.transfer(thunderWallets.charity, charityTeamAmount);
561         thunder.transfer(thunderWallets.team, charityTeamAmount);
562         thunder.transfer(thunderWallets.staking, _amountThunder - burnedThunder - lpRewards - charityTeamAmount * 2);
563 
564         _mint(msg.sender, amountRai);
565         emit Evolved(_amountThunder, amountRai);
566     }
567 
568     /**
569      * @dev if fees are enabled, subtract 2.25% fee and send it to beneficiary
570      * @dev after a certain threshold, try to swap collected fees automatically
571      * @dev if automatic swap fails (or beneficiary does not implement swapTokens function) transfer should still succeed
572      */
573     function _transfer(
574         address sender,
575         address recipient,
576         uint256 amount
577     ) internal override {
578         require(recipient != address(this), "Cannot send tokens to token contract");
579         if (!feesEnabled || isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
580             ERC20._transfer(sender, recipient, amount);
581             return;
582         }
583         uint256 burnedFee = calculateFee(amount, 25);
584         _burn(sender, burnedFee);
585 
586         uint256 transferFee = calculateFee(amount, 200);
587         ERC20._transfer(sender, beneficiary, transferFee);
588         ERC20._transfer(sender, recipient, amount - transferFee - burnedFee);
589     }
590 
591     function calculateFee(uint256 _amount, uint256 _fee) public pure returns (uint256) {
592         return (_amount * _fee) / 10000;
593     }
594 
595     /**
596      * @notice allows to burn tokens from own balance
597      * @dev only allows burning tokens until minimum supply is reached
598      * @param value amount of tokens to burn
599      */
600     function burn(uint256 value) public {
601         _burn(_msgSender(), value);
602     }
603 
604     /**
605      * @notice sets recipient of transfer fee
606      * @dev only callable by owner
607      * @param _newBeneficiary new beneficiary
608      */
609     function setBeneficiary(address _newBeneficiary) public onlyOwner {
610         setExcludeFromFee(_newBeneficiary, true);
611         emit BeneficiaryUpdated(beneficiary, _newBeneficiary);
612         beneficiary = _newBeneficiary;
613     }
614 
615     /**
616      * @notice sets the wallets for the thunder tokens
617      * @dev only callable by owner
618      * @param _newWallets updated wallets
619      */
620     function setThunderWallets(Wallets memory _newWallets) public onlyOwner {
621         emit ThunderWalletsUpdated();
622         thunderWallets = _newWallets;
623     }
624 
625     /**
626      * @notice sets whether account collects fees on token transfer
627      * @dev only callable by owner
628      * @param _enabled bool whether fees are enabled
629      */
630     function setFeesEnabled(bool _enabled) public onlyOwner {
631         emit FeesEnabledUpdated(_enabled);
632         feesEnabled = _enabled;
633     }
634 
635     /**
636      * @notice adds or removes an account that is exempt from fee collection
637      * @dev only callable by owner
638      * @param _account account to modify
639      * @param _excluded new value
640      */
641     function setExcludeFromFee(address _account, bool _excluded) public onlyOwner {
642         isExcludedFromFee[_account] = _excluded;
643         emit ExcludedFromFeeUpdated(_account, _excluded);
644     }
645 }