1 // SPDX-License-Identifier: MIT
2 
3 /*
4     Earn by supporting your favorite projects
5     * web: xccelerate.net
6     * tg: @xccelerateportal
7     * twitter: @TeamXccelerate
8 */
9 
10 pragma solidity 0.8.21;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
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
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 /**
103  * @dev Interface of the ERC20 standard as defined in the EIP.
104  */
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
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
180 /**
181  * @dev Interface for the optional metadata functions from the ERC20 standard.
182  *
183  * _Available since v4.1._
184  */
185 interface IERC20Metadata is IERC20 {
186     /**
187      * @dev Returns the name of the token.
188      */
189     function name() external view returns (string memory);
190 
191     /**
192      * @dev Returns the symbol of the token.
193      */
194     function symbol() external view returns (string memory);
195 
196     /**
197      * @dev Returns the decimals places of the token.
198      */
199     function decimals() external view returns (uint8);
200 }
201 
202 /**
203  * @dev Implementation of the {IERC20} interface.
204  *
205  * This implementation is agnostic to the way tokens are created. This means
206  * that a supply mechanism has to be added in a derived contract using {_mint}.
207  * For a generic mechanism see {ERC20PresetMinterPauser}.
208  *
209  * TIP: For a detailed writeup see our guide
210  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
211  * to implement supply mechanisms].
212  *
213  * We have followed general OpenZeppelin Contracts guidelines: functions revert
214  * instead returning `false` on failure. This behavior is nonetheless
215  * conventional and does not conflict with the expectations of ERC20
216  * applications.
217  *
218  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
219  * This allows applications to reconstruct the allowance for all accounts just
220  * by listening to said events. Other implementations of the EIP may not emit
221  * these events, as it isn't required by the specification.
222  *
223  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
224  * functions have been added to mitigate the well-known issues around setting
225  * allowances. See {IERC20-approve}.
226  */
227 contract ERC20 is Context, IERC20, IERC20Metadata {
228     mapping(address => uint256) private _balances;
229 
230     mapping(address => mapping(address => uint256)) private _allowances;
231 
232     uint256 private _totalSupply;
233 
234     string private _name;
235     string private _symbol;
236 
237     /**
238      * @dev Sets the values for {name} and {symbol}.
239      *
240      * The default value of {decimals} is 18. To select a different value for
241      * {decimals} you should overload it.
242      *
243      * All two of these values are immutable: they can only be set once during
244      * construction.
245      */
246     constructor(string memory name_, string memory symbol_) {
247         _name = name_;
248         _symbol = symbol_;
249     }
250 
251     /**
252      * @dev Returns the name of the token.
253      */
254     function name() public view virtual override returns (string memory) {
255         return _name;
256     }
257 
258     /**
259      * @dev Returns the symbol of the token, usually a shorter version of the
260      * name.
261      */
262     function symbol() public view virtual override returns (string memory) {
263         return _symbol;
264     }
265 
266     /**
267      * @dev Returns the number of decimals used to get its user representation.
268      * For example, if `decimals` equals `2`, a balance of `505` tokens should
269      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
270      *
271      * Tokens usually opt for a value of 18, imitating the relationship between
272      * Ether and Wei. This is the value {ERC20} uses, unless this function is
273      * overridden;
274      *
275      * NOTE: This information is only used for _display_ purposes: it in
276      * no way affects any of the arithmetic of the contract, including
277      * {IERC20-balanceOf} and {IERC20-transfer}.
278      */
279     function decimals() public view virtual override returns (uint8) {
280         return 18;
281     }
282 
283     /**
284      * @dev See {IERC20-totalSupply}.
285      */
286     function totalSupply() public view virtual override returns (uint256) {
287         return _totalSupply;
288     }
289 
290     /**
291      * @dev See {IERC20-balanceOf}.
292      */
293     function balanceOf(address account) public view virtual override returns (uint256) {
294         return _balances[account];
295     }
296 
297     /**
298      * @dev See {IERC20-transfer}.
299      *
300      * Requirements:
301      *
302      * - `recipient` cannot be the zero address.
303      * - the caller must have a balance of at least `amount`.
304      */
305     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
306         _transfer(_msgSender(), recipient, amount);
307         return true;
308     }
309 
310     /**
311      * @dev See {IERC20-allowance}.
312      */
313     function allowance(address owner, address spender) public view virtual override returns (uint256) {
314         return _allowances[owner][spender];
315     }
316 
317     /**
318      * @dev See {IERC20-approve}.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function approve(address spender, uint256 amount) public virtual override returns (bool) {
325         _approve(_msgSender(), spender, amount);
326         return true;
327     }
328 
329     /**
330      * @dev See {IERC20-transferFrom}.
331      *
332      * Emits an {Approval} event indicating the updated allowance. This is not
333      * required by the EIP. See the note at the beginning of {ERC20}.
334      *
335      * Requirements:
336      *
337      * - `sender` and `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `amount`.
339      * - the caller must have allowance for ``sender``'s tokens of at least
340      * `amount`.
341      */
342     function transferFrom(
343         address sender,
344         address recipient,
345         uint256 amount
346     ) public virtual override returns (bool) {
347         _transfer(sender, recipient, amount);
348 
349         uint256 currentAllowance = _allowances[sender][_msgSender()];
350         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
351         unchecked {
352             _approve(sender, _msgSender(), currentAllowance - amount);
353         }
354 
355         return true;
356     }
357 
358     /**
359      * @dev Atomically increases the allowance granted to `spender` by the caller.
360      *
361      * This is an alternative to {approve} that can be used as a mitigation for
362      * problems described in {IERC20-approve}.
363      *
364      * Emits an {Approval} event indicating the updated allowance.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
371         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
372         return true;
373     }
374 
375     /**
376      * @dev Atomically decreases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      * - `spender` must have allowance for the caller of at least
387      * `subtractedValue`.
388      */
389     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
390         uint256 currentAllowance = _allowances[_msgSender()][spender];
391         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
392         unchecked {
393             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
394         }
395 
396         return true;
397     }
398 
399     /**
400      * @dev Moves `amount` of tokens from `sender` to `recipient`.
401      *
402      * This internal function is equivalent to {transfer}, and can be used to
403      * e.g. implement automatic token fees, slashing mechanisms, etc.
404      *
405      * Emits a {Transfer} event.
406      *
407      * Requirements:
408      *
409      * - `sender` cannot be the zero address.
410      * - `recipient` cannot be the zero address.
411      * - `sender` must have a balance of at least `amount`.
412      */
413     function _transfer(
414         address sender,
415         address recipient,
416         uint256 amount
417     ) internal virtual {
418         require(sender != address(0), "ERC20: transfer from the zero address");
419         require(recipient != address(0), "ERC20: transfer to the zero address");
420 
421         _beforeTokenTransfer(sender, recipient, amount);
422 
423         uint256 senderBalance = _balances[sender];
424         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
425         unchecked {
426             _balances[sender] = senderBalance - amount;
427         }
428         _balances[recipient] += amount;
429 
430         emit Transfer(sender, recipient, amount);
431 
432         _afterTokenTransfer(sender, recipient, amount);
433     }
434 
435     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
436      * the total supply.
437      *
438      * Emits a {Transfer} event with `from` set to the zero address.
439      *
440      * Requirements:
441      *
442      * - `account` cannot be the zero address.
443      */
444     function _mint(address account, uint256 amount) internal virtual {
445         require(account != address(0), "ERC20: mint to the zero address");
446 
447         _beforeTokenTransfer(address(0), account, amount);
448 
449         _totalSupply += amount;
450         _balances[account] += amount;
451         emit Transfer(address(0), account, amount);
452 
453         _afterTokenTransfer(address(0), account, amount);
454     }
455 
456     /**
457      * @dev Destroys `amount` tokens from `account`, reducing the
458      * total supply.
459      *
460      * Emits a {Transfer} event with `to` set to the zero address.
461      *
462      * Requirements:
463      *
464      * - `account` cannot be the zero address.
465      * - `account` must have at least `amount` tokens.
466      */
467     function _burn(address account, uint256 amount) internal virtual {
468         require(account != address(0), "ERC20: burn from the zero address");
469 
470         _beforeTokenTransfer(account, address(0), amount);
471 
472         uint256 accountBalance = _balances[account];
473         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
474         unchecked {
475             _balances[account] = accountBalance - amount;
476         }
477         _totalSupply -= amount;
478 
479         emit Transfer(account, address(0), amount);
480 
481         _afterTokenTransfer(account, address(0), amount);
482     }
483 
484     /**
485      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
486      *
487      * This internal function is equivalent to `approve`, and can be used to
488      * e.g. set automatic allowances for certain subsystems, etc.
489      *
490      * Emits an {Approval} event.
491      *
492      * Requirements:
493      *
494      * - `owner` cannot be the zero address.
495      * - `spender` cannot be the zero address.
496      */
497     function _approve(
498         address owner,
499         address spender,
500         uint256 amount
501     ) internal virtual {
502         require(owner != address(0), "ERC20: approve from the zero address");
503         require(spender != address(0), "ERC20: approve to the zero address");
504 
505         _allowances[owner][spender] = amount;
506         emit Approval(owner, spender, amount);
507     }
508 
509     /**
510      * @dev Hook that is called before any transfer of tokens. This includes
511      * minting and burning.
512      *
513      * Calling conditions:
514      *
515      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
516      * will be transferred to `to`.
517      * - when `from` is zero, `amount` tokens will be minted for `to`.
518      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
519      * - `from` and `to` are never both zero.
520      *
521      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
522      */
523     function _beforeTokenTransfer(
524         address from,
525         address to,
526         uint256 amount
527     ) internal virtual {}
528 
529     /**
530      * @dev Hook that is called after any transfer of tokens. This includes
531      * minting and burning.
532      *
533      * Calling conditions:
534      *
535      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
536      * has been transferred to `to`.
537      * - when `from` is zero, `amount` tokens have been minted for `to`.
538      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
539      * - `from` and `to` are never both zero.
540      *
541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
542      */
543     function _afterTokenTransfer(
544         address from,
545         address to,
546         uint256 amount
547     ) internal virtual {}
548 }
549 
550 contract Xccelerate is Ownable, ERC20 {
551     uint256 private _totalSupply = 100000000 * 1e18;
552     uint256 private _maxWallet = _totalSupply * 2 / 100;
553 
554     address private _uniV3Pair;
555 
556     bool private _limitsEnabled = true; // to secure a somewhat safe steady distribution
557     bool private _tokenTradeable;
558 
559     constructor() ERC20("Xccelerate", "XLRT") {
560         // internal function cannot mint after deployment
561         _mint(msg.sender, _totalSupply);
562     }
563 
564     /**
565         * @dev Once function is called launch is complete
566     */
567     function enableTrading(address pair) external onlyOwner {
568         _tokenTradeable = true;
569         _uniV3Pair = pair;
570     }
571 
572     /**
573         * @dev Once function is called limits can never be enabled again
574     */
575     function disableLimits() external onlyOwner {
576         _limitsEnabled = false;
577     }
578 
579     function _beforeTokenTransfer(
580         address from,
581         address to,
582         uint256 amount
583     ) override internal virtual {
584         if (!_tokenTradeable) {
585             require(from == owner() || to == owner(), "transfer:: Trading is not enabled");
586             return;
587         }
588 
589         if (_limitsEnabled && from != owner() && to != owner() && to != _uniV3Pair)
590             require(balanceOf(to) + amount <= _maxWallet, "transfer:: Balance exceeds max wallet size of 2%");
591     }
592 }