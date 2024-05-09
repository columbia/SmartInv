1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         _transferOwnership(address(0));
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         _transferOwnership(newOwner);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Internal function without access restriction.
91      */
92     function _transferOwnership(address newOwner) internal virtual {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 
100 pragma solidity ^0.8.0;
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
180 
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev Interface for the optional metadata functions from the ERC20 standard.
186  *
187  * _Available since v4.1._
188  */
189 interface IERC20Metadata is IERC20 {
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() external view returns (string memory);
194 
195     /**
196      * @dev Returns the symbol of the token.
197      */
198     function symbol() external view returns (string memory);
199 
200     /**
201      * @dev Returns the decimals places of the token.
202      */
203     function decimals() external view returns (uint8);
204 }
205 
206 
207 
208 pragma solidity ^0.8.0;
209 
210 
211 
212 /**
213  * @dev Implementation of the {IERC20} interface.
214  *
215  * This implementation is agnostic to the way tokens are created. This means
216  * that a supply mechanism has to be added in a derived contract using {_mint}.
217  * For a generic mechanism see {ERC20PresetMinterPauser}.
218  *
219  * TIP: For a detailed writeup see our guide
220  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
221  * to implement supply mechanisms].
222  *
223  * We have followed general OpenZeppelin Contracts guidelines: functions revert
224  * instead returning `false` on failure. This behavior is nonetheless
225  * conventional and does not conflict with the expectations of ERC20
226  * applications.
227  *
228  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
229  * This allows applications to reconstruct the allowance for all accounts just
230  * by listening to said events. Other implementations of the EIP may not emit
231  * these events, as it isn't required by the specification.
232  *
233  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
234  * functions have been added to mitigate the well-known issues around setting
235  * allowances. See {IERC20-approve}.
236  */
237 contract ERC20 is Context, IERC20, IERC20Metadata {
238     mapping(address => uint256) private _balances;
239 
240     mapping(address => mapping(address => uint256)) private _allowances;
241 
242     uint256 private _totalSupply;
243 
244     string private _name;
245     string private _symbol;
246 
247     /**
248      * @dev Sets the values for {name} and {symbol}.
249      *
250      * The default value of {decimals} is 18. To select a different value for
251      * {decimals} you should overload it.
252      *
253      * All two of these values are immutable: they can only be set once during
254      * construction.
255      */
256     constructor(string memory name_, string memory symbol_) {
257         _name = name_;
258         _symbol = symbol_;
259     }
260 
261     /**
262      * @dev Returns the name of the token.
263      */
264     function name() public view virtual override returns (string memory) {
265         return _name;
266     }
267 
268     /**
269      * @dev Returns the symbol of the token, usually a shorter version of the
270      * name.
271      */
272     function symbol() public view virtual override returns (string memory) {
273         return _symbol;
274     }
275 
276     /**
277      * @dev Returns the number of decimals used to get its user representation.
278      * For example, if `decimals` equals `2`, a balance of `505` tokens should
279      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
280      *
281      * Tokens usually opt for a value of 18, imitating the relationship between
282      * Ether and Wei. This is the value {ERC20} uses, unless this function is
283      * overridden;
284      *
285      * NOTE: This information is only used for _display_ purposes: it in
286      * no way affects any of the arithmetic of the contract, including
287      * {IERC20-balanceOf} and {IERC20-transfer}.
288      */
289     function decimals() public view virtual override returns (uint8) {
290         return 18;
291     }
292 
293     /**
294      * @dev See {IERC20-totalSupply}.
295      */
296     function totalSupply() public view virtual override returns (uint256) {
297         return _totalSupply;
298     }
299 
300     /**
301      * @dev See {IERC20-balanceOf}.
302      */
303     function balanceOf(address account) public view virtual override returns (uint256) {
304         return _balances[account];
305     }
306 
307     /**
308      * @dev See {IERC20-transfer}.
309      *
310      * Requirements:
311      *
312      * - `recipient` cannot be the zero address.
313      * - the caller must have a balance of at least `amount`.
314      */
315     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
316         _transfer(_msgSender(), recipient, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-allowance}.
322      */
323     function allowance(address owner, address spender) public view virtual override returns (uint256) {
324         return _allowances[owner][spender];
325     }
326 
327     /**
328      * @dev See {IERC20-approve}.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function approve(address spender, uint256 amount) public virtual override returns (bool) {
335         _approve(_msgSender(), spender, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-transferFrom}.
341      *
342      * Emits an {Approval} event indicating the updated allowance. This is not
343      * required by the EIP. See the note at the beginning of {ERC20}.
344      *
345      * Requirements:
346      *
347      * - `sender` and `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      * - the caller must have allowance for ``sender``'s tokens of at least
350      * `amount`.
351      */
352     function transferFrom(
353         address sender,
354         address recipient,
355         uint256 amount
356     ) public virtual override returns (bool) {
357         _transfer(sender, recipient, amount);
358 
359         uint256 currentAllowance = _allowances[sender][_msgSender()];
360         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
361         unchecked {
362             _approve(sender, _msgSender(), currentAllowance - amount);
363         }
364 
365         return true;
366     }
367 
368     /**
369      * @dev Atomically increases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {IERC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      */
380     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
381         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
382         return true;
383     }
384 
385     /**
386      * @dev Atomically decreases the allowance granted to `spender` by the caller.
387      *
388      * This is an alternative to {approve} that can be used as a mitigation for
389      * problems described in {IERC20-approve}.
390      *
391      * Emits an {Approval} event indicating the updated allowance.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      * - `spender` must have allowance for the caller of at least
397      * `subtractedValue`.
398      */
399     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
400         uint256 currentAllowance = _allowances[_msgSender()][spender];
401         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
402         unchecked {
403             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
404         }
405 
406         return true;
407     }
408 
409     /**
410      * @dev Moves `amount` of tokens from `sender` to `recipient`.
411      *
412      * This internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(
424         address sender,
425         address recipient,
426         uint256 amount
427     ) internal virtual {
428         require(sender != address(0), "ERC20: transfer from the zero address");
429         require(recipient != address(0), "ERC20: transfer to the zero address");
430 
431         _beforeTokenTransfer(sender, recipient,amount);
432 
433         uint256 senderBalance = _balances[sender];
434         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
435         unchecked {
436             _balances[sender] = senderBalance - amount;
437         }
438         _balances[recipient] += amount;
439 
440         emit Transfer(sender, recipient, amount);
441 
442         _afterTokenTransfer(sender, recipient, amount);
443     }
444 
445     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
446      * the total supply.
447      *
448      * Emits a {Transfer} event with `from` set to the zero address.
449      *
450      * Requirements:
451      *
452      * - `account` cannot be the zero address.
453      */
454     function _mint(address account, uint256 amount) internal virtual {
455         require(account != address(0), "ERC20: mint to the zero address");
456 
457         _beforeTokenTransfer(address(0), account,amount);
458 
459         _totalSupply += amount;
460         _balances[account] += amount;
461         emit Transfer(address(0), account, amount);
462 
463         _afterTokenTransfer(address(0), account, amount);
464     }
465 
466     /**
467      * @dev Destroys `amount` tokens from `account`, reducing the
468      * total supply.
469      *
470      * Emits a {Transfer} event with `to` set to the zero address.
471      *
472      * Requirements:
473      *
474      * - `account` cannot be the zero address.
475      * - `account` must have at least `amount` tokens.
476      */
477     function _burn(address account, uint256 amount) internal virtual {
478         require(account != address(0), "ERC20: burn from the zero address");
479 
480         _beforeTokenTransfer(account, address(0),amount);
481 
482         uint256 accountBalance = _balances[account];
483         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
484         unchecked {
485             _balances[account] = accountBalance - amount;
486         }
487         _totalSupply -= amount;
488 
489         emit Transfer(account, address(0), amount);
490 
491         _afterTokenTransfer(account, address(0), amount);
492     }
493 
494     /**
495      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
496      *
497      * This internal function is equivalent to `approve`, and can be used to
498      * e.g. set automatic allowances for certain subsystems, etc.
499      *
500      * Emits an {Approval} event.
501      *
502      * Requirements:
503      *
504      * - `owner` cannot be the zero address.
505      * - `spender` cannot be the zero address.
506      */
507     function _approve(
508         address owner,
509         address spender,
510         uint256 amount
511     ) internal virtual {
512         require(owner != address(0), "ERC20: approve from the zero address");
513         require(spender != address(0), "ERC20: approve to the zero address");
514 
515         _allowances[owner][spender] = amount;
516         emit Approval(owner, spender, amount);
517     }
518 
519     /**
520      * @dev Hook that is called before any transfer of tokens. This includes
521      * minting and burning.
522      *
523      * Calling conditions:
524      *
525      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
526      * will be transferred to `to`.
527      * - when `from` is zero, `amount` tokens will be minted for `to`.
528      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
529      * - `from` and `to` are never both zero.
530      *
531      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
532      */
533     function _beforeTokenTransfer(
534         address from,
535         address to,
536         uint256 amount
537     ) internal virtual {}
538 
539     /**
540      * @dev Hook that is called after any transfer of tokens. This includes
541      * minting and burning.
542      *
543      * Calling conditions:
544      *
545      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
546      * has been transferred to `to`.
547      * - when `from` is zero, `amount` tokens have been minted for `to`.
548      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
549      * - `from` and `to` are never both zero.
550      *
551      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
552      */
553     function _afterTokenTransfer(
554         address from,
555         address to,
556         uint256 amount
557     ) internal virtual {}
558 }
559 
560 pragma solidity ^0.8.0;
561 
562 contract colorToken is Ownable, ERC20 {
563     bool public limited;
564     address public uniswapV2Pair;
565     uint256  public maxWalletAmount;
566     constructor() ERC20("MEME BOY", "$COLOR") {
567         uint256 _totalSupply = 1000000000 * 10 ** 18;
568         maxWalletAmount=_totalSupply *3 /100;
569         _mint(msg.sender, _totalSupply);
570     }
571 
572     function setRule( address _uniswapV2Pair,bool _limited) external onlyOwner {
573         uniswapV2Pair = _uniswapV2Pair;
574         limited=_limited;
575     }
576 
577     function _beforeTokenTransfer(
578         address from,
579         address to,
580         uint256 amount
581     ) override internal virtual {
582 
583         if (uniswapV2Pair == address(0)) {
584             require(from == owner() || to == owner(), "trading is not started");
585             return;
586         }
587         if(limited){
588             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
589 
590                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
591                 
592             }
593         }
594         
595     }
596     function removeLimit() public onlyOwner{
597         limited=false;
598     }
599     function burn(uint256 value) external {
600         _burn(msg.sender, value);
601     }
602 }