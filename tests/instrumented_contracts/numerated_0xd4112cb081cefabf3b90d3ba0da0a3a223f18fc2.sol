1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
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
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor() {
44         _setOwner(_msgSender());
45     }
46 
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         _setOwner(address(0));
58     }
59 
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _setOwner(newOwner);
63     }
64 
65     function _setOwner(address newOwner) internal {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 /**
73  * @dev Interface of the ERC20 standard as defined in the EIP.
74  */
75 interface IERC20 {
76     /**
77      * @dev Returns the amount of tokens in existence.
78      */
79     function totalSupply() external view returns (uint256);
80 
81     /**
82      * @dev Returns the amount of tokens owned by `account`.
83      */
84     function balanceOf(address account) external view returns (uint256);
85 
86     /**
87      * @dev Moves `amount` tokens from the caller's account to `recipient`.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transfer(address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Returns the remaining number of tokens that `spender` will be
97      * allowed to spend on behalf of `owner` through {transferFrom}. This is
98      * zero by default.
99      *
100      * This value changes when {approve} or {transferFrom} are called.
101      */
102     function allowance(address owner, address spender) external view returns (uint256);
103 
104     /**
105      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * IMPORTANT: Beware that changing an allowance with this method brings the risk
110      * that someone may use both the old and the new allowance by unfortunate
111      * transaction ordering. One possible solution to mitigate this race
112      * condition is to first reduce the spender's allowance to 0 and set the
113      * desired value afterwards:
114      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address spender, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Moves `amount` tokens from `sender` to `recipient` using the
122      * allowance mechanism. `amount` is then deducted from the caller's
123      * allowance.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transferFrom(
130         address sender,
131         address recipient,
132         uint256 amount
133     ) external returns (bool);
134 
135     /**
136      * @dev Emitted when `value` tokens are moved from one account (`from`) to
137      * another (`to`).
138      *
139      * Note that `value` may be zero.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 value);
142 
143     /**
144      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
145      * a call to {approve}. `value` is the new allowance.
146      */
147     event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 /**
151  * @dev Interface for the optional metadata functions from the ERC20 standard.
152  *
153  * _Available since v4.1._
154  */
155 interface IERC20Metadata is IERC20 {
156     /**
157      * @dev Returns the name of the token.
158      */
159     function name() external view returns (string memory);
160 
161     /**
162      * @dev Returns the symbol of the token.
163      */
164     function symbol() external view returns (string memory);
165 
166     /**
167      * @dev Returns the decimals places of the token.
168      */
169     function decimals() external view returns (uint8);
170 }
171 
172 
173 /**
174  * @dev Implementation of the {IERC20} interface.
175  *
176  * This implementation is agnostic to the way tokens are created. This means
177  * that a supply mechanism has to be added in a derived contract using {_mint}.
178  * For a generic mechanism see {ERC20PresetMinterPauser}.
179  *
180  * TIP: For a detailed writeup see our guide
181  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
182  * to implement supply mechanisms].
183  *
184  * We have followed general OpenZeppelin Contracts guidelines: functions revert
185  * instead returning `false` on failure. This behavior is nonetheless
186  * conventional and does not conflict with the expectations of ERC20
187  * applications.
188  *
189  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
190  * This allows applications to reconstruct the allowance for all accounts just
191  * by listening to said events. Other implementations of the EIP may not emit
192  * these events, as it isn't required by the specification.
193  *
194  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
195  * functions have been added to mitigate the well-known issues around setting
196  * allowances. See {IERC20-approve}.
197  */
198 contract ERC20 is Context, IERC20, IERC20Metadata {
199     mapping(address => uint256) private _balances;
200 
201     mapping(address => mapping(address => uint256)) private _allowances;
202 
203     uint256 private _totalSupply;
204 
205     string private _name;
206     string private _symbol;
207 
208     /**
209      * @dev Sets the values for {name} and {symbol}.
210      *
211      * The default value of {decimals} is 18. To select a different value for
212      * {decimals} you should overload it.
213      *
214      * All two of these values are immutable: they can only be set once during
215      * construction.
216      */
217     constructor(string memory name_, string memory symbol_) {
218         _name = name_;
219         _symbol = symbol_;
220     }
221 
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() public view virtual override returns (string memory) {
226         return _name;
227     }
228 
229     /**
230      * @dev Returns the symbol of the token, usually a shorter version of the
231      * name.
232      */
233     function symbol() public view virtual override returns (string memory) {
234         return _symbol;
235     }
236 
237     /**
238      * @dev Returns the number of decimals used to get its user representation.
239      * For example, if `decimals` equals `2`, a balance of `505` tokens should
240      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
241      *
242      * Tokens usually opt for a value of 18, imitating the relationship between
243      * Ether and Wei. This is the value {ERC20} uses, unless this function is
244      * overridden;
245      *
246      * NOTE: This information is only used for _display_ purposes: it in
247      * no way affects any of the arithmetic of the contract, including
248      * {IERC20-balanceOf} and {IERC20-transfer}.
249      */
250     function decimals() public view virtual override returns (uint8) {
251         return 18;
252     }
253 
254     /**
255      * @dev See {IERC20-totalSupply}.
256      */
257     function totalSupply() public view virtual override returns (uint256) {
258         return _totalSupply;
259     }
260 
261     /**
262      * @dev See {IERC20-balanceOf}.
263      */
264     function balanceOf(address account) public view virtual override returns (uint256) {
265         return _balances[account];
266     }
267 
268     /**
269      * @dev See {IERC20-transfer}.
270      *
271      * Requirements:
272      *
273      * - `recipient` cannot be the zero address.
274      * - the caller must have a balance of at least `amount`.
275      */
276     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
277         _transfer(_msgSender(), recipient, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-allowance}.
283      */
284     function allowance(address owner, address spender) public view virtual override returns (uint256) {
285         return _allowances[owner][spender];
286     }
287 
288     /**
289      * @dev See {IERC20-approve}.
290      *
291      * Requirements:
292      *
293      * - `spender` cannot be the zero address.
294      */
295     function approve(address spender, uint256 amount) public virtual override returns (bool) {
296         _approve(_msgSender(), spender, amount);
297         return true;
298     }
299 
300     /**
301      * @dev See {IERC20-transferFrom}.
302      *
303      * Emits an {Approval} event indicating the updated allowance. This is not
304      * required by the EIP. See the note at the beginning of {ERC20}.
305      *
306      * Requirements:
307      *
308      * - `sender` and `recipient` cannot be the zero address.
309      * - `sender` must have a balance of at least `amount`.
310      * - the caller must have allowance for ``sender``'s tokens of at least
311      * `amount`.
312      */
313     function transferFrom(
314         address sender,
315         address recipient,
316         uint256 amount
317     ) public virtual override returns (bool) {
318         _transfer(sender, recipient, amount);
319 
320         uint256 currentAllowance = _allowances[sender][_msgSender()];
321         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
322         unchecked {
323             _approve(sender, _msgSender(), currentAllowance - amount);
324         }
325 
326         return true;
327     }
328 
329     /**
330      * @dev Atomically increases the allowance granted to `spender` by the caller.
331      *
332      * This is an alternative to {approve} that can be used as a mitigation for
333      * problems described in {IERC20-approve}.
334      *
335      * Emits an {Approval} event indicating the updated allowance.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
342         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
343         return true;
344     }
345 
346     /**
347      * @dev Atomically decreases the allowance granted to `spender` by the caller.
348      *
349      * This is an alternative to {approve} that can be used as a mitigation for
350      * problems described in {IERC20-approve}.
351      *
352      * Emits an {Approval} event indicating the updated allowance.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      * - `spender` must have allowance for the caller of at least
358      * `subtractedValue`.
359      */
360     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
361         uint256 currentAllowance = _allowances[_msgSender()][spender];
362         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
363         unchecked {
364             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
365         }
366 
367         return true;
368     }
369 
370     /**
371      * @dev Moves `amount` of tokens from `sender` to `recipient`.
372      *
373      * This internal function is equivalent to {transfer}, and can be used to
374      * e.g. implement automatic token fees, slashing mechanisms, etc.
375      *
376      * Emits a {Transfer} event.
377      *
378      * Requirements:
379      *
380      * - `sender` cannot be the zero address.
381      * - `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `amount`.
383      */
384     function _transfer(
385         address sender,
386         address recipient,
387         uint256 amount
388     ) internal virtual {
389         require(sender != address(0), "ERC20: transfer from the zero address");
390         require(recipient != address(0), "ERC20: transfer to the zero address");
391 
392         _beforeTokenTransfer(sender, recipient, amount);
393 
394         uint256 senderBalance = _balances[sender];
395         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
396         unchecked {
397             _balances[sender] = senderBalance - amount;
398         }
399         _balances[recipient] += amount;
400 
401         emit Transfer(sender, recipient, amount);
402 
403         _afterTokenTransfer(sender, recipient, amount);
404     }
405 
406     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
407      * the total supply.
408      *
409      * Emits a {Transfer} event with `from` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      */
415     function _mint(address account, uint256 amount) internal virtual {
416         require(account != address(0), "ERC20: mint to the zero address");
417 
418         _beforeTokenTransfer(address(0), account, amount);
419 
420         _totalSupply += amount;
421         _balances[account] += amount;
422         emit Transfer(address(0), account, amount);
423 
424         _afterTokenTransfer(address(0), account, amount);
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
445         unchecked {
446             _balances[account] = accountBalance - amount;
447         }
448         _totalSupply -= amount;
449 
450         emit Transfer(account, address(0), amount);
451 
452         _afterTokenTransfer(account, address(0), amount);
453     }
454 
455     /**
456      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
457      *
458      * This internal function is equivalent to `approve`, and can be used to
459      * e.g. set automatic allowances for certain subsystems, etc.
460      *
461      * Emits an {Approval} event.
462      *
463      * Requirements:
464      *
465      * - `owner` cannot be the zero address.
466      * - `spender` cannot be the zero address.
467      */
468     function _approve(
469         address owner,
470         address spender,
471         uint256 amount
472     ) internal virtual {
473         require(owner != address(0), "ERC20: approve from the zero address");
474         require(spender != address(0), "ERC20: approve to the zero address");
475 
476         _allowances[owner][spender] = amount;
477         emit Approval(owner, spender, amount);
478     }
479 
480     /**
481      * @dev Hook that is called before any transfer of tokens. This includes
482      * minting and burning.
483      *
484      * Calling conditions:
485      *
486      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
487      * will be transferred to `to`.
488      * - when `from` is zero, `amount` tokens will be minted for `to`.
489      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
490      * - `from` and `to` are never both zero.
491      *
492      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
493      */
494     function _beforeTokenTransfer(
495         address from,
496         address to,
497         uint256 amount
498     ) internal virtual {}
499 
500     /**
501      * @dev Hook that is called after any transfer of tokens. This includes
502      * minting and burning.
503      *
504      * Calling conditions:
505      *
506      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
507      * has been transferred to `to`.
508      * - when `from` is zero, `amount` tokens have been minted for `to`.
509      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
510      * - `from` and `to` are never both zero.
511      *
512      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
513      */
514     function _afterTokenTransfer(
515         address from,
516         address to,
517         uint256 amount
518     ) internal virtual {}
519 }
520 
521 contract StandardToken is Ownable, ERC20 {
522     bool public limited;
523     uint256 public maxHoldingAmount;
524     bool public cooldownEnabled;
525     uint256 public cooldownDuration;
526 
527     uint256 public _decimals = 18 ;
528 
529     mapping(address => uint256) public lastTransaction;
530 
531     constructor(uint256 _totalSupply, string memory _name, string memory _symbol) ERC20(_name, _symbol) {
532         _mint(owner(), _totalSupply * 10**_decimals);
533     }
534 
535     function setCooldownEnabled(uint256 _duration) public onlyOwner {
536         cooldownDuration = _duration;
537     }
538 
539     function setRule(bool _limited, uint256 _cooldownDuration, uint256 _maxHoldingAmount) public onlyOwner {
540         limited = _limited;
541         setCooldownEnabled(_cooldownDuration);
542         maxHoldingAmount = _maxHoldingAmount;
543     }
544 
545     function _beforeTokenTransfer(
546         address from,
547         address to,
548         uint256 amount
549     ) override internal virtual {
550         if (limited && (from != owner() || to != owner())) {
551             require(super.balanceOf(to) + amount <= maxHoldingAmount, "Forbid");
552             require(block.timestamp >= lastTransaction[from] + cooldownDuration, "Cooldown not met");
553             lastTransaction[from] = block.timestamp;
554             lastTransaction[to] = block.timestamp;
555         }
556     }
557 
558     function burn(uint256 value) external {
559         _burn(msg.sender, value);
560     }
561 }