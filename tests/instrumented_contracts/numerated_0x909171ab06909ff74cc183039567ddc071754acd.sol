1 // Sources flattened with hardhat v2.10.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
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
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.2
90 
91 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Interface for the optional metadata functions from the ERC20 standard.
97  *
98  * _Available since v4.1._
99  */
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 
118 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 
145 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.2
146 
147 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 
153 /**
154  * @dev Implementation of the {IERC20} interface.
155  *
156  * This implementation is agnostic to the way tokens are created. This means
157  * that a supply mechanism has to be added in a derived contract using {_mint}.
158  * For a generic mechanism see {ERC20PresetMinterPauser}.
159  *
160  * TIP: For a detailed writeup see our guide
161  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
162  * to implement supply mechanisms].
163  *
164  * We have followed general OpenZeppelin Contracts guidelines: functions revert
165  * instead returning `false` on failure. This behavior is nonetheless
166  * conventional and does not conflict with the expectations of ERC20
167  * applications.
168  *
169  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
170  * This allows applications to reconstruct the allowance for all accounts just
171  * by listening to said events. Other implementations of the EIP may not emit
172  * these events, as it isn't required by the specification.
173  *
174  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
175  * functions have been added to mitigate the well-known issues around setting
176  * allowances. See {IERC20-approve}.
177  */
178 contract ERC20 is Context, IERC20, IERC20Metadata {
179     mapping(address => uint256) private _balances;
180 
181     mapping(address => mapping(address => uint256)) private _allowances;
182 
183     uint256 private _totalSupply;
184 
185     string private _name;
186     string private _symbol;
187 
188     /**
189      * @dev Sets the values for {name} and {symbol}.
190      *
191      * The default value of {decimals} is 18. To select a different value for
192      * {decimals} you should overload it.
193      *
194      * All two of these values are immutable: they can only be set once during
195      * construction.
196      */
197     constructor(string memory name_, string memory symbol_) {
198         _name = name_;
199         _symbol = symbol_;
200     }
201 
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() public view virtual override returns (string memory) {
206         return _name;
207     }
208 
209     /**
210      * @dev Returns the symbol of the token, usually a shorter version of the
211      * name.
212      */
213     function symbol() public view virtual override returns (string memory) {
214         return _symbol;
215     }
216 
217     /**
218      * @dev Returns the number of decimals used to get its user representation.
219      * For example, if `decimals` equals `2`, a balance of `505` tokens should
220      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
221      *
222      * Tokens usually opt for a value of 18, imitating the relationship between
223      * Ether and Wei. This is the value {ERC20} uses, unless this function is
224      * overridden;
225      *
226      * NOTE: This information is only used for _display_ purposes: it in
227      * no way affects any of the arithmetic of the contract, including
228      * {IERC20-balanceOf} and {IERC20-transfer}.
229      */
230     function decimals() public view virtual override returns (uint8) {
231         return 18;
232     }
233 
234     /**
235      * @dev See {IERC20-totalSupply}.
236      */
237     function totalSupply() public view virtual override returns (uint256) {
238         return _totalSupply;
239     }
240 
241     /**
242      * @dev See {IERC20-balanceOf}.
243      */
244     function balanceOf(address account) public view virtual override returns (uint256) {
245         return _balances[account];
246     }
247 
248     /**
249      * @dev See {IERC20-transfer}.
250      *
251      * Requirements:
252      *
253      * - `recipient` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-allowance}.
263      */
264     function allowance(address owner, address spender) public view virtual override returns (uint256) {
265         return _allowances[owner][spender];
266     }
267 
268     /**
269      * @dev See {IERC20-approve}.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public virtual override returns (bool) {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-transferFrom}.
282      *
283      * Emits an {Approval} event indicating the updated allowance. This is not
284      * required by the EIP. See the note at the beginning of {ERC20}.
285      *
286      * Requirements:
287      *
288      * - `sender` and `recipient` cannot be the zero address.
289      * - `sender` must have a balance of at least `amount`.
290      * - the caller must have allowance for ``sender``'s tokens of at least
291      * `amount`.
292      */
293     function transferFrom(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) public virtual override returns (bool) {
298         _transfer(sender, recipient, amount);
299 
300         uint256 currentAllowance = _allowances[sender][_msgSender()];
301         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
302         unchecked {
303             _approve(sender, _msgSender(), currentAllowance - amount);
304         }
305 
306         return true;
307     }
308 
309     /**
310      * @dev Atomically increases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
323         return true;
324     }
325 
326     /**
327      * @dev Atomically decreases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      * - `spender` must have allowance for the caller of at least
338      * `subtractedValue`.
339      */
340     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
341         uint256 currentAllowance = _allowances[_msgSender()][spender];
342         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
343         unchecked {
344             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Moves `amount` of tokens from `sender` to `recipient`.
352      *
353      * This internal function is equivalent to {transfer}, and can be used to
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
364     function _transfer(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) internal virtual {
369         require(sender != address(0), "ERC20: transfer from the zero address");
370         require(recipient != address(0), "ERC20: transfer to the zero address");
371 
372         _beforeTokenTransfer(sender, recipient, amount);
373 
374         uint256 senderBalance = _balances[sender];
375         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
376         unchecked {
377             _balances[sender] = senderBalance - amount;
378         }
379         _balances[recipient] += amount;
380 
381         emit Transfer(sender, recipient, amount);
382 
383         _afterTokenTransfer(sender, recipient, amount);
384     }
385 
386     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
387      * the total supply.
388      *
389      * Emits a {Transfer} event with `from` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      */
395     function _mint(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: mint to the zero address");
397 
398         _beforeTokenTransfer(address(0), account, amount);
399 
400         _totalSupply += amount;
401         _balances[account] += amount;
402         emit Transfer(address(0), account, amount);
403 
404         _afterTokenTransfer(address(0), account, amount);
405     }
406 
407     /**
408      * @dev Destroys `amount` tokens from `account`, reducing the
409      * total supply.
410      *
411      * Emits a {Transfer} event with `to` set to the zero address.
412      *
413      * Requirements:
414      *
415      * - `account` cannot be the zero address.
416      * - `account` must have at least `amount` tokens.
417      */
418     function _burn(address account, uint256 amount) internal virtual {
419         require(account != address(0), "ERC20: burn from the zero address");
420 
421         _beforeTokenTransfer(account, address(0), amount);
422 
423         uint256 accountBalance = _balances[account];
424         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
425         unchecked {
426             _balances[account] = accountBalance - amount;
427         }
428         _totalSupply -= amount;
429 
430         emit Transfer(account, address(0), amount);
431 
432         _afterTokenTransfer(account, address(0), amount);
433     }
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
437      *
438      * This internal function is equivalent to `approve`, and can be used to
439      * e.g. set automatic allowances for certain subsystems, etc.
440      *
441      * Emits an {Approval} event.
442      *
443      * Requirements:
444      *
445      * - `owner` cannot be the zero address.
446      * - `spender` cannot be the zero address.
447      */
448     function _approve(
449         address owner,
450         address spender,
451         uint256 amount
452     ) internal virtual {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = amount;
457         emit Approval(owner, spender, amount);
458     }
459 
460     /**
461      * @dev Hook that is called before any transfer of tokens. This includes
462      * minting and burning.
463      *
464      * Calling conditions:
465      *
466      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
467      * will be transferred to `to`.
468      * - when `from` is zero, `amount` tokens will be minted for `to`.
469      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
470      * - `from` and `to` are never both zero.
471      *
472      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
473      */
474     function _beforeTokenTransfer(
475         address from,
476         address to,
477         uint256 amount
478     ) internal virtual {}
479 
480     /**
481      * @dev Hook that is called after any transfer of tokens. This includes
482      * minting and burning.
483      *
484      * Calling conditions:
485      *
486      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
487      * has been transferred to `to`.
488      * - when `from` is zero, `amount` tokens have been minted for `to`.
489      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
490      * - `from` and `to` are never both zero.
491      *
492      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
493      */
494     function _afterTokenTransfer(
495         address from,
496         address to,
497         uint256 amount
498     ) internal virtual {}
499 }
500 
501 
502 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
503 
504 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Contract module which provides a basic access control mechanism, where
510  * there is an account (an owner) that can be granted exclusive access to
511  * specific functions.
512  *
513  * By default, the owner account will be the one that deploys the contract. This
514  * can later be changed with {transferOwnership}.
515  *
516  * This module is used through inheritance. It will make available the modifier
517  * `onlyOwner`, which can be applied to your functions to restrict their use to
518  * the owner.
519  */
520 abstract contract Ownable is Context {
521     address private _owner;
522 
523     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
524 
525     /**
526      * @dev Initializes the contract setting the deployer as the initial owner.
527      */
528     constructor() {
529         _transferOwnership(_msgSender());
530     }
531 
532     /**
533      * @dev Returns the address of the current owner.
534      */
535     function owner() public view virtual returns (address) {
536         return _owner;
537     }
538 
539     /**
540      * @dev Throws if called by any account other than the owner.
541      */
542     modifier onlyOwner() {
543         require(owner() == _msgSender(), "Ownable: caller is not the owner");
544         _;
545     }
546 
547     /**
548      * @dev Leaves the contract without owner. It will not be possible to call
549      * `onlyOwner` functions anymore. Can only be called by the current owner.
550      *
551      * NOTE: Renouncing ownership will leave the contract without an owner,
552      * thereby removing any functionality that is only available to the owner.
553      */
554     function renounceOwnership() public virtual onlyOwner {
555         _transferOwnership(address(0));
556     }
557 
558     /**
559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
560      * Can only be called by the current owner.
561      */
562     function transferOwnership(address newOwner) public virtual onlyOwner {
563         require(newOwner != address(0), "Ownable: new owner is the zero address");
564         _transferOwnership(newOwner);
565     }
566 
567     /**
568      * @dev Transfers ownership of the contract to a new account (`newOwner`).
569      * Internal function without access restriction.
570      */
571     function _transferOwnership(address newOwner) internal virtual {
572         address oldOwner = _owner;
573         _owner = newOwner;
574         emit OwnershipTransferred(oldOwner, newOwner);
575     }
576 }
577 
578 
579 // File contracts/PulseUnityToken.sol
580 
581 pragma solidity >=0.8.0;
582 /**
583  * @notice Implements a basic ERC20 staking token with incentive distribution.
584  */
585 
586 contract PulseUnity is ERC20, Ownable {
587     address marketing_wallet = 0xC6B357ff3e81b75d13aaCc97695f92A0Fda67c48;
588     address dev_wallet = 0x2FC4D047a71f619BF63ab82449491eF44D03a3F7;
589     address junkman_wallet = 0xcb55D80c65E610206A0176488e135B4dcB955980;
590     address deployer_wallet = 0xb7E401C952EB244CC4a079eF0BD20a471dF71d36;
591     /**
592      * @notice The constructor for the Staking Token.
593      */
594     constructor(address[] memory _holders, uint[] memory _holdings)
595         ERC20("Pulse Unity Token", "PLSU")
596     {
597         uint256 sentPU = 0;
598         uint256 maxSupply = 0;
599         //marketing wallet
600         //dev wallet
601         for (uint i = 0; i < _holdings.length; i++) {
602             sentPU += _holdings[i];
603             _mint(_holders[i], _holdings[i] * 1e18);
604         }
605 
606         maxSupply = sentPU * 5 * 1e18;
607 
608         _mint(marketing_wallet, (maxSupply * 5) / 100);
609         _mint(dev_wallet, (maxSupply * 4) / 100);
610         _mint(junkman_wallet, (maxSupply * 1) / 100);
611         _mint(deployer_wallet, (maxSupply * 70) / 100);
612     }
613 
614     function changeMarketWallet(address _newMarketingWallet)
615         external
616         onlyOwner
617     {
618         marketing_wallet = _newMarketingWallet;
619     }
620 
621     function changeJunkmanWallet(address _newJunkmanWallet) external onlyOwner {
622         junkman_wallet = _newJunkmanWallet;
623     }
624 
625     function changeDevWallet(address _newDevWallet) external onlyOwner {
626         dev_wallet = _newDevWallet;
627     }
628 }