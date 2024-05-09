1 // SPDX-License-Identifier: GPL-3.0
2 
3 // Telegram: https://t.me/dont_ape
4 // Twitter: https://twitter.com/dont_ape
5 
6 
7  
8 pragma solidity ^0.8.0;
9  
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 abstract contract Ownable is Context {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor() {
39         _transferOwnership(_msgSender());
40     }
41 
42     /**
43      * @dev Throws if called by any account other than the owner.
44      */
45     modifier onlyOwner() {
46         _checkOwner();
47         _;
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if the sender is not the owner.
59      */
60     function _checkOwner() internal view virtual {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _transferOwnership(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Internal function without access restriction.
87      */
88     function _transferOwnership(address newOwner) internal virtual {
89         address oldOwner = _owner;
90         _owner = newOwner;
91         emit OwnershipTransferred(oldOwner, newOwner);
92     }
93 }
94 
95 /**
96  * @dev Interface of the ERC20 standard as defined in the EIP.
97  */
98 interface IERC20 {
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106  
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112  
113     /**
114      * @dev Returns the amount of tokens in existence.
115      */
116     function totalSupply() external view returns (uint256);
117  
118     /**
119      * @dev Returns the amount of tokens owned by `account`.
120      */
121     function balanceOf(address account) external view returns (uint256);
122  
123     /**
124      * @dev Moves `amount` tokens from the caller's account to `to`.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transfer(address to, uint256 amount) external returns (bool);
131  
132     /**
133      * @dev Returns the remaining number of tokens that `spender` will be
134      * allowed to spend on behalf of `owner` through {transferFrom}. This is
135      * zero by default.
136      *
137      * This value changes when {approve} or {transferFrom} are called.
138      */
139     function allowance(address owner, address spender) external view returns (uint256);
140  
141     /**
142      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * IMPORTANT: Beware that changing an allowance with this method brings the risk
147      * that someone may use both the old and the new allowance by unfortunate
148      * transaction ordering. One possible solution to mitigate this race
149      * condition is to first reduce the spender's allowance to 0 and set the
150      * desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address spender, uint256 amount) external returns (bool);
156  
157     /**
158      * @dev Moves `amount` tokens from `from` to `to` using the
159      * allowance mechanism. `amount` is then deducted from the caller's
160      * allowance.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transferFrom(
167         address from,
168         address to,
169         uint256 amount
170     ) external returns (bool);
171 }
172  
173 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
174  
175 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
176  
177  
178 /**
179  * @dev Interface for the optional metadata functions from the ERC20 standard.
180  *
181  * _Available since v4.1._
182  */
183 interface IERC20Metadata is IERC20 {
184     /**
185      * @dev Returns the name of the token.
186      */
187     function name() external view returns (string memory);
188  
189     /**
190      * @dev Returns the symbol of the token.
191      */
192     function symbol() external view returns (string memory);
193  
194     /**
195      * @dev Returns the decimals places of the token.
196      */
197     function decimals() external view returns (uint8);
198 }
199  
200 // File: @openzeppelin/contracts/utils/Context.sol
201  
202 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
203  
204 
205  
206 /**
207  * @dev Provides information about the current execution context, including the
208  * sender of the transaction and its data. While these are generally available
209  * via msg.sender and msg.data, they should not be accessed in such a direct
210  * manner, since when dealing with meta-transactions the account sending and
211  * paying for execution may not be the actual sender (as far as an application
212  * is concerned).
213  *
214  * This contract is only required for intermediate, library-like contracts.
215  */
216 
217  
218 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
219  
220 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
221  
222 pragma solidity ^0.8.0;
223  
224  
225  
226 /**
227  * @dev Implementation of the {IERC20} interface.
228  *
229  * This implementation is agnostic to the way tokens are created. This means
230  * that a supply mechanism has to be added in a derived contract using {_mint}.
231  * For a generic mechanism see {ERC20PresetMinterPauser}.
232  *
233  * TIP: For a detailed writeup see our guide
234  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
235  * to implement supply mechanisms].
236  *
237  * We have followed general OpenZeppelin Contracts guidelines: functions revert
238  * instead returning `false` on failure. This behavior is nonetheless
239  * conventional and does not conflict with the expectations of ERC20
240  * applications.
241  *
242  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
243  * This allows applications to reconstruct the allowance for all accounts just
244  * by listening to said events. Other implementations of the EIP may not emit
245  * these events, as it isn't required by the specification.
246  *
247  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
248  * functions have been added to mitigate the well-known issues around setting
249  * allowances. See {IERC20-approve}.
250  */
251 contract ERC20 is Context, IERC20, IERC20Metadata {
252     mapping(address => uint256) public _balances;
253  
254     mapping(address => mapping(address => uint256)) private _allowances;
255  
256     uint256 private _totalSupply;
257  
258     string private _name;
259     string private _symbol;
260  
261     /**
262      * @dev Sets the values for {name} and {symbol}.
263      *
264      * The default value of {decimals} is 18. To select a different value for
265      * {decimals} you should overload it.
266      *
267      * All two of these values are immutable: they can only be set once during
268      * construction.
269      */
270     constructor(string memory name_, string memory symbol_) {
271         _name = name_;
272         _symbol = symbol_;
273     }
274  
275     /**
276      * @dev Returns the name of the token.
277      */
278     function name() public view virtual override returns (string memory) {
279         return _name;
280     }
281  
282     /**
283      * @dev Returns the symbol of the token, usually a shorter version of the
284      * name.
285      */
286     function symbol() public view virtual override returns (string memory) {
287         return _symbol;
288     }
289  
290     /**
291      * @dev Returns the number of decimals used to get its user representation.
292      * For example, if `decimals` equals `2`, a balance of `505` tokens should
293      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
294      *
295      * Tokens usually opt for a value of 18, imitating the relationship between
296      * Ether and Wei. This is the value {ERC20} uses, unless this function is
297      * overridden;
298      *
299      * NOTE: This information is only used for _display_ purposes: it in
300      * no way affects any of the arithmetic of the contract, including
301      * {IERC20-balanceOf} and {IERC20-transfer}.
302      */
303     function decimals() public view virtual override returns (uint8) {
304         return 18;
305     }
306  
307     /**
308      * @dev See {IERC20-totalSupply}.
309      */
310     function totalSupply() public view virtual override returns (uint256) {
311         return _totalSupply;
312     }
313  
314     /**
315      * @dev See {IERC20-balanceOf}.
316      */
317     function balanceOf(address account) public view virtual override returns (uint256) {
318         return _balances[account];
319     }
320  
321     /**
322      * @dev See {IERC20-transfer}.
323      *
324      * Requirements:
325      *
326      * - `to` cannot be the zero address.
327      * - the caller must have a balance of at least `amount`.
328      */
329     function transfer(address to, uint256 amount) public virtual override returns (bool) {
330         address owner = _msgSender();
331         _transfer(owner, to, amount);
332         return true;
333     }
334  
335     /**
336      * @dev See {IERC20-allowance}.
337      */
338     function allowance(address owner, address spender) public view virtual override returns (uint256) {
339         return _allowances[owner][spender];
340     }
341  
342     /**
343      * @dev See {IERC20-approve}.
344      *
345      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
346      * `transferFrom`. This is semantically equivalent to an infinite approval.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function approve(address spender, uint256 amount) public virtual override returns (bool) {
353         address owner = _msgSender();
354         _approve(owner, spender, amount);
355         return true;
356     }
357  
358     /**
359      * @dev See {IERC20-transferFrom}.
360      *
361      * Emits an {Approval} event indicating the updated allowance. This is not
362      * required by the EIP. See the note at the beginning of {ERC20}.
363      *
364      * NOTE: Does not update the allowance if the current allowance
365      * is the maximum `uint256`.
366      *
367      * Requirements:
368      *
369      * - `from` and `to` cannot be the zero address.
370      * - `from` must have a balance of at least `amount`.
371      * - the caller must have allowance for ``from``'s tokens of at least
372      * `amount`.
373      */
374     function transferFrom(
375         address from,
376         address to,
377         uint256 amount
378     ) public virtual override returns (bool) {
379         address spender = _msgSender();
380         _spendAllowance(from, spender, amount);
381         _transfer(from, to, amount);
382         return true;
383     }
384  
385     /**
386      * @dev Atomically increases the allowance granted to `spender` by the caller.
387      *
388      * This is an alternative to {approve} that can be used as a mitigation for
389      * problems described in {IERC20-approve}.
390      *
391      * Emits an {Approval} event indicating the updated allowance.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
398         address owner = _msgSender();
399         _approve(owner, spender, allowance(owner, spender) + addedValue);
400         return true;
401     }
402  
403     /**
404      * @dev Atomically decreases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      * - `spender` must have allowance for the caller of at least
415      * `subtractedValue`.
416      */
417     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
418         address owner = _msgSender();
419         uint256 currentAllowance = allowance(owner, spender);
420         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
421         unchecked {
422             _approve(owner, spender, currentAllowance - subtractedValue);
423         }
424  
425         return true;
426     }
427  
428     /**
429      * @dev Moves `amount` of tokens from `from` to `to`.
430      *
431      * This internal function is equivalent to {transfer}, and can be used to
432      * e.g. implement automatic token fees, slashing mechanisms, etc.
433      *
434      * Emits a {Transfer} event.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `from` must have a balance of at least `amount`.
441      */
442     function _transfer(
443         address from,
444         address to,
445         uint256 amount
446     ) internal virtual {
447         require(from != address(0), "ERC20: transfer from the zero address");
448         require(to != address(0), "ERC20: transfer to the zero address");
449  
450         _beforeTokenTransfer(from, to, amount);
451  
452         uint256 fromBalance = _balances[from];
453         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
454         unchecked {
455             _balances[from] = fromBalance - amount;
456         }
457         _balances[to] += amount;
458  
459         emit Transfer(from, to, amount);
460  
461         _afterTokenTransfer(from, to, amount);
462     }
463  
464     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
465      * the total supply.
466      *
467      * Emits a {Transfer} event with `from` set to the zero address.
468      *
469      * Requirements:
470      *
471      * - `account` cannot be the zero address.
472      */
473     function _mint(address account, uint256 amount) internal virtual {
474         require(account != address(0), "ERC20: mint to the zero address");
475  
476         _beforeTokenTransfer(address(0), account, amount);
477  
478         _totalSupply += amount;
479         _balances[account] += amount;
480         emit Transfer(address(0), account, amount);
481  
482         _afterTokenTransfer(address(0), account, amount);
483     }
484  
485     /**
486      * @dev Destroys `amount` tokens from `account`, reducing the
487      * total supply.
488      *
489      * Emits a {Transfer} event with `to` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `account` cannot be the zero address.
494      * - `account` must have at least `amount` tokens.
495      */
496     function _burn(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: burn from the zero address");
498  
499         _beforeTokenTransfer(account, address(0), amount);
500  
501         uint256 accountBalance = _balances[account];
502         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
503         unchecked {
504             _balances[account] = accountBalance - amount;
505         }
506         _totalSupply -= amount;
507  
508         emit Transfer(account, address(0), amount);
509  
510         _afterTokenTransfer(account, address(0), amount);
511     }
512  
513     /**
514      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
515      *
516      * This internal function is equivalent to `approve`, and can be used to
517      * e.g. set automatic allowances for certain subsystems, etc.
518      *
519      * Emits an {Approval} event.
520      *
521      * Requirements:
522      *
523      * - `owner` cannot be the zero address.
524      * - `spender` cannot be the zero address.
525      */
526     function _approve(
527         address owner,
528         address spender,
529         uint256 amount
530     ) internal virtual {
531         require(owner != address(0), "ERC20: approve from the zero address");
532         require(spender != address(0), "ERC20: approve to the zero address");
533  
534         _allowances[owner][spender] = amount;
535         emit Approval(owner, spender, amount);
536     }
537  
538     /**
539      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
540      *
541      * Does not update the allowance amount in case of infinite allowance.
542      * Revert if not enough allowance is available.
543      *
544      * Might emit an {Approval} event.
545      */
546     function _spendAllowance(
547         address owner,
548         address spender,
549         uint256 amount
550     ) internal virtual {
551         uint256 currentAllowance = allowance(owner, spender);
552         if (currentAllowance != type(uint256).max) {
553             require(currentAllowance >= amount, "ERC20: insufficient allowance");
554             unchecked {
555                 _approve(owner, spender, currentAllowance - amount);
556             }
557         }
558     }
559  
560     /**
561      * @dev Hook that is called before any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * will be transferred to `to`.
568      * - when `from` is zero, `amount` tokens will be minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _beforeTokenTransfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal virtual {}
579  
580     /**
581      * @dev Hook that is called after any transfer of tokens. This includes
582      * minting and burning.
583      *
584      * Calling conditions:
585      *
586      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
587      * has been transferred to `to`.
588      * - when `from` is zero, `amount` tokens have been minted for `to`.
589      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
590      * - `from` and `to` are never both zero.
591      *
592      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
593      */
594     function _afterTokenTransfer(
595         address from,
596         address to,
597         uint256 amount
598     ) internal virtual {}
599 }
600  
601 contract DONTAPE is ERC20, Ownable {
602     constructor() ERC20("DONT APE", "DONT"){
603         _mint(msg.sender, 1000000000*10**18);
604     }
605  
606     mapping(address => string) public DONT;
607 
608     uint256 public maxWalletSize = 30000000*10**18;
609     bool public isLaunched = false;
610  
611 
612     function _transfer(
613         address from,
614         address to,
615         uint256 amount
616     ) internal override {
617         require(from != address(0), "ERC20: transfer from the zero address");
618         require(to != address(0), "ERC20: transfer to the zero address");
619         require(_balances[to] + amount <=  maxWalletSize, "Max Wallet limit");
620 
621         if(from != owner()) {
622             require(isLaunched == true, "Token not launched");
623         }
624  
625         _beforeTokenTransfer(from, to, amount);
626  
627         uint256 fromBalance = _balances[from];
628         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
629         unchecked {
630             _balances[from] = fromBalance - amount;
631         }
632         _balances[to] += amount;
633  
634         emit Transfer(from, to, amount);
635  
636         _afterTokenTransfer(from, to, amount);
637     }
638 
639     function changeMaxWallet(uint256 newMax) public onlyOwner {
640         maxWalletSize = newMax;
641     }
642 
643     function launch() public onlyOwner {
644         isLaunched = true;
645     }
646 }