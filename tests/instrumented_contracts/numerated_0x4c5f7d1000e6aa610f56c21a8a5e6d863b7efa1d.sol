1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 ///
5   ///
6     /// coo coo
7   ///
8 ///
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
50     constructor() {
51         _transferOwnership(_msgSender());
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(owner() == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * NOTE: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public virtual onlyOwner {
77         _transferOwnership(address(0));
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         _transferOwnership(newOwner);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Internal function without access restriction.
92      */
93     function _transferOwnership(address newOwner) internal virtual {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP.
102  */
103 interface IERC20 {
104     /**
105      * @dev Returns the amount of tokens in existence.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address recipient, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Returns the remaining number of tokens that `spender` will be
125      * allowed to spend on behalf of `owner` through {transferFrom}. This is
126      * zero by default.
127      *
128      * This value changes when {approve} or {transferFrom} are called.
129      */
130     function allowance(address owner, address spender) external view returns (uint256);
131 
132     /**
133      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * IMPORTANT: Beware that changing an allowance with this method brings the risk
138      * that someone may use both the old and the new allowance by unfortunate
139      * transaction ordering. One possible solution to mitigate this race
140      * condition is to first reduce the spender's allowance to 0 and set the
141      * desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      *
144      * Emits an {Approval} event.
145      */
146     function approve(address spender, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Moves `amount` tokens from `sender` to `recipient` using the
150      * allowance mechanism. `amount` is then deducted from the caller's
151      * allowance.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
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
200 /**
201  * @dev Implementation of the {IERC20} interface.
202  *
203  * This implementation is agnostic to the way tokens are created. This means
204  * that a supply mechanism has to be added in a derived contract using {_mint}.
205  * For a generic mechanism see {ERC20PresetMinterPauser}.
206  *
207  * TIP: For a detailed writeup see our guide
208  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
209  * to implement supply mechanisms].
210  *
211  * We have followed general OpenZeppelin Contracts guidelines: functions revert
212  * instead returning `false` on failure. This behavior is nonetheless
213  * conventional and does not conflict with the expectations of ERC20
214  * applications.
215  *
216  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
217  * This allows applications to reconstruct the allowance for all accounts just
218  * by listening to said events. Other implementations of the EIP may not emit
219  * these events, as it isn't required by the specification.
220  *
221  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
222  * functions have been added to mitigate the well-known issues around setting
223  * allowances. See {IERC20-approve}.
224  */
225 contract ERC20 is Context, IERC20, IERC20Metadata {
226     mapping(address => uint256) private _balances;
227 
228     mapping(address => mapping(address => uint256)) private _allowances;
229 
230     uint256 private _totalSupply;
231 
232     string private _name;
233     string private _symbol;
234 
235     /**
236      * @dev Sets the values for {name} and {symbol}.
237      *
238      * The default value of {decimals} is 18. To select a different value for
239      * {decimals} you should overload it.
240      *
241      * All two of these values are immutable: they can only be set once during
242      * construction.
243      */
244     constructor(string memory name_, string memory symbol_) {
245         _name = name_;
246         _symbol = symbol_;
247     }
248 
249     /**
250      * @dev Returns the name of the token.
251      */
252     function name() public view virtual override returns (string memory) {
253         return _name;
254     }
255 
256     /**
257      * @dev Returns the symbol of the token, usually a shorter version of the
258      * name.
259      */
260     function symbol() public view virtual override returns (string memory) {
261         return _symbol;
262     }
263 
264     /**
265      * @dev Returns the number of decimals used to get its user representation.
266      * For example, if `decimals` equals `2`, a balance of `505` tokens should
267      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
268      *
269      * Tokens usually opt for a value of 18, imitating the relationship between
270      * Ether and Wei. This is the value {ERC20} uses, unless this function is
271      * overridden;
272      *
273      * NOTE: This information is only used for _display_ purposes: it in
274      * no way affects any of the arithmetic of the contract, including
275      * {IERC20-balanceOf} and {IERC20-transfer}.
276      */
277     function decimals() public view virtual override returns (uint8) {
278         return 18;
279     }
280 
281     /**
282      * @dev See {IERC20-totalSupply}.
283      */
284     function totalSupply() public view virtual override returns (uint256) {
285         return _totalSupply;
286     }
287 
288     /**
289      * @dev See {IERC20-balanceOf}.
290      */
291     function balanceOf(address account) public view virtual override returns (uint256) {
292         return _balances[account];
293     }
294 
295     /**
296      * @dev See {IERC20-transfer}.
297      *
298      * Requirements:
299      *
300      * - `recipient` cannot be the zero address.
301      * - the caller must have a balance of at least `amount`.
302      */
303     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
304         _transfer(_msgSender(), recipient, amount);
305         return true;
306     }
307 
308     /**
309      * @dev See {IERC20-allowance}.
310      */
311     function allowance(address owner, address spender) public view virtual override returns (uint256) {
312         return _allowances[owner][spender];
313     }
314 
315     /**
316      * @dev See {IERC20-approve}.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function approve(address spender, uint256 amount) public virtual override returns (bool) {
323         _approve(_msgSender(), spender, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-transferFrom}.
329      *
330      * Emits an {Approval} event indicating the updated allowance. This is not
331      * required by the EIP. See the note at the beginning of {ERC20}.
332      *
333      * Requirements:
334      *
335      * - `sender` and `recipient` cannot be the zero address.
336      * - `sender` must have a balance of at least `amount`.
337      * - the caller must have allowance for ``sender``'s tokens of at least
338      * `amount`.
339      */
340     function transferFrom(
341         address sender,
342         address recipient,
343         uint256 amount
344     ) public virtual override returns (bool) {
345         _transfer(sender, recipient, amount);
346 
347         uint256 currentAllowance = _allowances[sender][_msgSender()];
348         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
349         unchecked {
350             _approve(sender, _msgSender(), currentAllowance - amount);
351         }
352 
353         return true;
354     }
355 
356     /**
357      * @dev Atomically increases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
370         return true;
371     }
372 
373     /**
374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      * - `spender` must have allowance for the caller of at least
385      * `subtractedValue`.
386      */
387     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
388         uint256 currentAllowance = _allowances[_msgSender()][spender];
389         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
390         unchecked {
391             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
392         }
393 
394         return true;
395     }
396 
397     /**
398      * @dev Moves `amount` of tokens from `sender` to `recipient`.
399      *
400      * This internal function is equivalent to {transfer}, and can be used to
401      * e.g. implement automatic token fees, slashing mechanisms, etc.
402      *
403      * Emits a {Transfer} event.
404      *
405      * Requirements:
406      *
407      * - `sender` cannot be the zero address.
408      * - `recipient` cannot be the zero address.
409      * - `sender` must have a balance of at least `amount`.
410      */
411     function _transfer(
412         address sender,
413         address recipient,
414         uint256 amount
415     ) internal virtual {
416         require(sender != address(0), "ERC20: transfer from the zero address");
417         require(recipient != address(0), "ERC20: transfer to the zero address");
418 
419         _beforeTokenTransfer(sender, recipient, amount);
420 
421         uint256 senderBalance = _balances[sender];
422         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
423         unchecked {
424             _balances[sender] = senderBalance - amount;
425         }
426         _balances[recipient] += amount;
427 
428         emit Transfer(sender, recipient, amount);
429 
430         _afterTokenTransfer(sender, recipient, amount);
431     }
432 
433     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
434      * the total supply.
435      *
436      * Emits a {Transfer} event with `from` set to the zero address.
437      *
438      * Requirements:
439      *
440      * - `account` cannot be the zero address.
441      */
442     function _mint(address account, uint256 amount) internal virtual {
443         require(account != address(0), "ERC20: mint to the zero address");
444 
445         _beforeTokenTransfer(address(0), account, amount);
446 
447         _totalSupply += amount;
448         _balances[account] += amount;
449         emit Transfer(address(0), account, amount);
450 
451         _afterTokenTransfer(address(0), account, amount);
452     }
453 
454     /**
455      * @dev Destroys `amount` tokens from `account`, reducing the
456      * total supply.
457      *
458      * Emits a {Transfer} event with `to` set to the zero address.
459      *
460      * Requirements:
461      *
462      * - `account` cannot be the zero address.
463      * - `account` must have at least `amount` tokens.
464      */
465     function _burn(address account, uint256 amount) internal virtual {
466         require(account != address(0), "ERC20: burn from the zero address");
467 
468         _beforeTokenTransfer(account, address(0), amount);
469 
470         uint256 accountBalance = _balances[account];
471         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
472         unchecked {
473             _balances[account] = accountBalance - amount;
474         }
475         _totalSupply -= amount;
476 
477         emit Transfer(account, address(0), amount);
478 
479         _afterTokenTransfer(account, address(0), amount);
480     }
481 
482     /**
483      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
484      *
485      * This internal function is equivalent to `approve`, and can be used to
486      * e.g. set automatic allowances for certain subsystems, etc.
487      *
488      * Emits an {Approval} event.
489      *
490      * Requirements:
491      *
492      * - `owner` cannot be the zero address.
493      * - `spender` cannot be the zero address.
494      */
495     function _approve(
496         address owner,
497         address spender,
498         uint256 amount
499     ) internal virtual {
500         require(owner != address(0), "ERC20: approve from the zero address");
501         require(spender != address(0), "ERC20: approve to the zero address");
502 
503         _allowances[owner][spender] = amount;
504         emit Approval(owner, spender, amount);
505     }
506 
507     /**
508      * @dev Hook that is called before any transfer of tokens. This includes
509      * minting and burning.
510      *
511      * Calling conditions:
512      *
513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
514      * will be transferred to `to`.
515      * - when `from` is zero, `amount` tokens will be minted for `to`.
516      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
517      * - `from` and `to` are never both zero.
518      *
519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
520      */
521     function _beforeTokenTransfer(
522         address from,
523         address to,
524         uint256 amount
525     ) internal virtual {}
526 
527     /**
528      * @dev Hook that is called after any transfer of tokens. This includes
529      * minting and burning.
530      *
531      * Calling conditions:
532      *
533      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
534      * has been transferred to `to`.
535      * - when `from` is zero, `amount` tokens have been minted for `to`.
536      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
537      * - `from` and `to` are never both zero.
538      *
539      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
540      */
541     function _afterTokenTransfer(
542         address from,
543         address to,
544         uint256 amount
545     ) internal virtual {}
546 }
547 
548 contract PIGEON is Ownable, ERC20 {
549     bool public limited;
550     uint256 public maxWallet;
551     address public uniswapV2Pair;
552     mapping(address => bool) public blacklists;
553 
554     constructor(uint256 _totalSupply) ERC20("Pigeon", "PIGEON") {
555         _mint(msg.sender, _totalSupply);
556     }
557 
558     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
559         blacklists[_address] = _isBlacklisting;
560     }
561 
562     function setPigeonRule(bool _limited, address _uniswapV2Pair, uint256 _maxWallet) external onlyOwner {
563         limited = _limited;
564         uniswapV2Pair = _uniswapV2Pair;
565         maxWallet = _maxWallet;
566     }
567 
568     function _beforeTokenTransfer(
569         address from,
570         address to,
571         uint256 amount
572     ) override internal virtual {
573         require(!blacklists[to] && !blacklists[from], "Blacklisted");
574 
575         if (uniswapV2Pair == address(0)) {
576             require(from == owner() || to == owner(), "trading not open");
577             return;
578         }
579 
580         if (limited && from == uniswapV2Pair) {
581             require(balanceOf(to) + amount <= maxWallet, "max wallet breached");
582         }
583     }
584 
585 }