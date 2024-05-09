1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
99 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP.
103  */
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * IMPORTANT: Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Moves `amount` tokens from `sender` to `recipient` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transferFrom(
159         address sender,
160         address recipient,
161         uint256 amount
162     ) external returns (bool);
163 
164     /**
165      * @dev Emitted when `value` tokens are moved from one account (`from`) to
166      * another (`to`).
167      *
168      * Note that `value` may be zero.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 value);
171 
172     /**
173      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
174      * a call to {approve}. `value` is the new allowance.
175      */
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
180 
181 /**
182  * @dev Interface for the optional metadata functions from the ERC20 standard.
183  *
184  * _Available since v4.1._
185  */
186 interface IERC20Metadata is IERC20 {
187     /**
188      * @dev Returns the name of the token.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the symbol of the token.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the decimals places of the token.
199      */
200     function decimals() external view returns (uint8);
201 }
202 
203 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
204 
205 /**
206  * @dev Implementation of the {IERC20} interface.
207  *
208  * This implementation is agnostic to the way tokens are created. This means
209  * that a supply mechanism has to be added in a derived contract using {_mint}.
210  * For a generic mechanism see {ERC20PresetMinterPauser}.
211  *
212  * TIP: For a detailed writeup see our guide
213  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
214  * to implement supply mechanisms].
215  *
216  * We have followed general OpenZeppelin Contracts guidelines: functions revert
217  * instead returning `false` on failure. This behavior is nonetheless
218  * conventional and does not conflict with the expectations of ERC20
219  * applications.
220  *
221  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
222  * This allows applications to reconstruct the allowance for all accounts just
223  * by listening to said events. Other implementations of the EIP may not emit
224  * these events, as it isn't required by the specification.
225  *
226  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
227  * functions have been added to mitigate the well-known issues around setting
228  * allowances. See {IERC20-approve}.
229  */
230 contract ERC20 is Context, IERC20, IERC20Metadata {
231     mapping(address => uint256) private _balances;
232 
233     mapping(address => mapping(address => uint256)) private _allowances;
234 
235     uint256 private _totalSupply;
236 
237     string private _name;
238     string private _symbol;
239 
240     /**
241      * @dev Sets the values for {name} and {symbol}.
242      *
243      * The default value of {decimals} is 18. To select a different value for
244      * {decimals} you should overload it.
245      *
246      * All two of these values are immutable: they can only be set once during
247      * construction.
248      */
249     constructor(string memory name_, string memory symbol_) {
250         _name = name_;
251         _symbol = symbol_;
252     }
253 
254     /**
255      * @dev Returns the name of the token.
256      */
257     function name() public view virtual override returns (string memory) {
258         return _name;
259     }
260 
261     /**
262      * @dev Returns the symbol of the token, usually a shorter version of the
263      * name.
264      */
265     function symbol() public view virtual override returns (string memory) {
266         return _symbol;
267     }
268 
269     /**
270      * @dev Returns the number of decimals used to get its user representation.
271      * For example, if `decimals` equals `2`, a balance of `505` tokens should
272      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
273      *
274      * Tokens usually opt for a value of 18, imitating the relationship between
275      * Ether and Wei. This is the value {ERC20} uses, unless this function is
276      * overridden;
277      *
278      * NOTE: This information is only used for _display_ purposes: it in
279      * no way affects any of the arithmetic of the contract, including
280      * {IERC20-balanceOf} and {IERC20-transfer}.
281      */
282     function decimals() public view virtual override returns (uint8) {
283         return 18;
284     }
285 
286     /**
287      * @dev See {IERC20-totalSupply}.
288      */
289     function totalSupply() public view virtual override returns (uint256) {
290         return _totalSupply;
291     }
292 
293     /**
294      * @dev See {IERC20-balanceOf}.
295      */
296     function balanceOf(address account) public view virtual override returns (uint256) {
297         return _balances[account];
298     }
299 
300     /**
301      * @dev See {IERC20-transfer}.
302      *
303      * Requirements:
304      *
305      * - `recipient` cannot be the zero address.
306      * - the caller must have a balance of at least `amount`.
307      */
308     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
309         _transfer(_msgSender(), recipient, amount);
310         return true;
311     }
312 
313     /**
314      * @dev See {IERC20-allowance}.
315      */
316     function allowance(address owner, address spender) public view virtual override returns (uint256) {
317         return _allowances[owner][spender];
318     }
319 
320     /**
321      * @dev See {IERC20-approve}.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function approve(address spender, uint256 amount) public virtual override returns (bool) {
328         _approve(_msgSender(), spender, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See {IERC20-transferFrom}.
334      *
335      * Emits an {Approval} event indicating the updated allowance. This is not
336      * required by the EIP. See the note at the beginning of {ERC20}.
337      *
338      * Requirements:
339      *
340      * - `sender` and `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      * - the caller must have allowance for ``sender``'s tokens of at least
343      * `amount`.
344      */
345     function transferFrom(
346         address sender,
347         address recipient,
348         uint256 amount
349     ) public virtual override returns (bool) {
350         _transfer(sender, recipient, amount);
351 
352         uint256 currentAllowance = _allowances[sender][_msgSender()];
353         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
354     unchecked {
355         _approve(sender, _msgSender(), currentAllowance - amount);
356     }
357 
358         return true;
359     }
360 
361     /**
362      * @dev Atomically increases the allowance granted to `spender` by the caller.
363      *
364      * This is an alternative to {approve} that can be used as a mitigation for
365      * problems described in {IERC20-approve}.
366      *
367      * Emits an {Approval} event indicating the updated allowance.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
374         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
375         return true;
376     }
377 
378     /**
379      * @dev Atomically decreases the allowance granted to `spender` by the caller.
380      *
381      * This is an alternative to {approve} that can be used as a mitigation for
382      * problems described in {IERC20-approve}.
383      *
384      * Emits an {Approval} event indicating the updated allowance.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      * - `spender` must have allowance for the caller of at least
390      * `subtractedValue`.
391      */
392     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
393         uint256 currentAllowance = _allowances[_msgSender()][spender];
394         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
395     unchecked {
396         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
397     }
398 
399         return true;
400     }
401 
402     /**
403      * @dev Moves `amount` of tokens from `sender` to `recipient`.
404      *
405      * This internal function is equivalent to {transfer}, and can be used to
406      * e.g. implement automatic token fees, slashing mechanisms, etc.
407      *
408      * Emits a {Transfer} event.
409      *
410      * Requirements:
411      *
412      * - `sender` cannot be the zero address.
413      * - `recipient` cannot be the zero address.
414      * - `sender` must have a balance of at least `amount`.
415      */
416     function _transfer(
417         address sender,
418         address recipient,
419         uint256 amount
420     ) internal virtual {
421         require(sender != address(0), "ERC20: transfer from the zero address");
422         require(recipient != address(0), "ERC20: transfer to the zero address");
423 
424         _beforeTokenTransfer(sender, recipient, amount);
425 
426         uint256 senderBalance = _balances[sender];
427         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
428     unchecked {
429         _balances[sender] = senderBalance - amount;
430     }
431         _balances[recipient] += amount;
432 
433         emit Transfer(sender, recipient, amount);
434 
435         _afterTokenTransfer(sender, recipient, amount);
436     }
437 
438     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
439      * the total supply.
440      *
441      * Emits a {Transfer} event with `from` set to the zero address.
442      *
443      * Requirements:
444      *
445      * - `account` cannot be the zero address.
446      */
447     function _mint(address account, uint256 amount) internal virtual {
448         require(account != address(0), "ERC20: mint to the zero address");
449 
450         _beforeTokenTransfer(address(0), account, amount);
451 
452         _totalSupply += amount;
453         _balances[account] += amount;
454         emit Transfer(address(0), account, amount);
455 
456         _afterTokenTransfer(address(0), account, amount);
457     }
458 
459     /**
460      * @dev Destroys `amount` tokens from `account`, reducing the
461      * total supply.
462      *
463      * Emits a {Transfer} event with `to` set to the zero address.
464      *
465      * Requirements:
466      *
467      * - `account` cannot be the zero address.
468      * - `account` must have at least `amount` tokens.
469      */
470     function _burn(address account, uint256 amount) internal virtual {
471         require(account != address(0), "ERC20: burn from the zero address");
472 
473         _beforeTokenTransfer(account, address(0), amount);
474 
475         uint256 accountBalance = _balances[account];
476         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
477     unchecked {
478         _balances[account] = accountBalance - amount;
479     }
480         _totalSupply -= amount;
481 
482         emit Transfer(account, address(0), amount);
483 
484         _afterTokenTransfer(account, address(0), amount);
485     }
486 
487     /**
488      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
489      *
490      * This internal function is equivalent to `approve`, and can be used to
491      * e.g. set automatic allowances for certain subsystems, etc.
492      *
493      * Emits an {Approval} event.
494      *
495      * Requirements:
496      *
497      * - `owner` cannot be the zero address.
498      * - `spender` cannot be the zero address.
499      */
500     function _approve(
501         address owner,
502         address spender,
503         uint256 amount
504     ) internal virtual {
505         require(owner != address(0), "ERC20: approve from the zero address");
506         require(spender != address(0), "ERC20: approve to the zero address");
507 
508         _allowances[owner][spender] = amount;
509         emit Approval(owner, spender, amount);
510     }
511 
512     /**
513      * @dev Hook that is called before any transfer of tokens. This includes
514      * minting and burning.
515      *
516      * Calling conditions:
517      *
518      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
519      * will be transferred to `to`.
520      * - when `from` is zero, `amount` tokens will be minted for `to`.
521      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
522      * - `from` and `to` are never both zero.
523      *
524      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
525      */
526     function _beforeTokenTransfer(
527         address from,
528         address to,
529         uint256 amount
530     ) internal virtual {}
531 
532     /**
533      * @dev Hook that is called after any transfer of tokens. This includes
534      * minting and burning.
535      *
536      * Calling conditions:
537      *
538      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
539      * has been transferred to `to`.
540      * - when `from` is zero, `amount` tokens have been minted for `to`.
541      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
542      * - `from` and `to` are never both zero.
543      *
544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
545      */
546     function _afterTokenTransfer(
547         address from,
548         address to,
549         uint256 amount
550     ) internal virtual {}
551 }
552 
553 contract CTToken is Ownable, ERC20 {
554     bool public limited;
555     uint256 public maxHoldingAmount;
556     uint256 public minHoldingAmount;
557     address public uniswapV2Pair;
558     mapping(address => bool) public blacklists;
559 
560     constructor(uint256 _totalSupply) ERC20("CryptoTwitter", "CT") {
561         _mint(msg.sender, _totalSupply);
562     }
563 
564     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
565         blacklists[_address] = _isBlacklisting;
566     }
567 
568     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
569         limited = _limited;
570         uniswapV2Pair = _uniswapV2Pair;
571         maxHoldingAmount = _maxHoldingAmount;
572         minHoldingAmount = _minHoldingAmount;
573     }
574 
575     function _beforeTokenTransfer(
576         address from,
577         address to,
578         uint256 amount
579     ) override internal virtual {
580         require(!blacklists[to] && !blacklists[from], "Blacklisted");
581 
582         if (uniswapV2Pair == address(0)) {
583             require(from == owner() || to == owner(), "trading is not started");
584             return;
585         }
586 
587         if (limited && from == uniswapV2Pair) {
588             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
589         }
590     }
591 
592     function burn(uint256 value) external {
593         _burn(msg.sender, value);
594     }
595 }