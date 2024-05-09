1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _transferOwnership(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _transferOwnership(newOwner);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Internal function without access restriction.
86      */
87     function _transferOwnership(address newOwner) internal virtual {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 /**
95  * @dev Interface of the ERC20 standard as defined in the EIP.
96  */
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107 
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125 
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) external returns (bool);
156 
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 /**
173  * @dev Interface for the optional metadata functions from the ERC20 standard.
174  *
175  * _Available since v4.1._
176  */
177 interface IERC20Metadata is IERC20 {
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() external view returns (string memory);
182 
183     /**
184      * @dev Returns the symbol of the token.
185      */
186     function symbol() external view returns (string memory);
187 
188     /**
189      * @dev Returns the decimals places of the token.
190      */
191     function decimals() external view returns (uint8);
192 }
193 
194 /**
195  * @dev Implementation of the {IERC20} interface.
196  *
197  * This implementation is agnostic to the way tokens are created. This means
198  * that a supply mechanism has to be added in a derived contract using {_mint}.
199  * For a generic mechanism see {ERC20PresetMinterPauser}.
200  *
201  * TIP: For a detailed writeup see our guide
202  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
203  * to implement supply mechanisms].
204  *
205  * We have followed general OpenZeppelin Contracts guidelines: functions revert
206  * instead returning `false` on failure. This behavior is nonetheless
207  * conventional and does not conflict with the expectations of ERC20
208  * applications.
209  *
210  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
216  * functions have been added to mitigate the well-known issues around setting
217  * allowances. See {IERC20-approve}.
218  */
219 contract ERC20 is Context, IERC20, IERC20Metadata {
220     mapping(address => uint256) private _balances;
221 
222     mapping(address => mapping(address => uint256)) private _allowances;
223 
224     uint256 private _totalSupply;
225 
226     string private _name;
227     string private _symbol;
228 
229     /**
230      * @dev Sets the values for {name} and {symbol}.
231      *
232      * The default value of {decimals} is 18. To select a different value for
233      * {decimals} you should overload it.
234      *
235      * All two of these values are immutable: they can only be set once during
236      * construction.
237      */
238     constructor(string memory name_, string memory symbol_) {
239         _name = name_;
240         _symbol = symbol_;
241     }
242 
243     /**
244      * @dev Returns the name of the token.
245      */
246     function name() public view virtual override returns (string memory) {
247         return _name;
248     }
249 
250     /**
251      * @dev Returns the symbol of the token, usually a shorter version of the
252      * name.
253      */
254     function symbol() public view virtual override returns (string memory) {
255         return _symbol;
256     }
257 
258     /**
259      * @dev Returns the number of decimals used to get its user representation.
260      * For example, if `decimals` equals `2`, a balance of `505` tokens should
261      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
262      *
263      * Tokens usually opt for a value of 18, imitating the relationship between
264      * Ether and Wei. This is the value {ERC20} uses, unless this function is
265      * overridden;
266      *
267      * NOTE: This information is only used for _display_ purposes: it in
268      * no way affects any of the arithmetic of the contract, including
269      * {IERC20-balanceOf} and {IERC20-transfer}.
270      */
271     function decimals() public view virtual override returns (uint8) {
272         return 18;
273     }
274 
275     /**
276      * @dev See {IERC20-totalSupply}.
277      */
278     function totalSupply() public view virtual override returns (uint256) {
279         return _totalSupply;
280     }
281 
282     /**
283      * @dev See {IERC20-balanceOf}.
284      */
285     function balanceOf(address account) public view virtual override returns (uint256) {
286         return _balances[account];
287     }
288 
289     /**
290      * @dev See {IERC20-transfer}.
291      *
292      * Requirements:
293      *
294      * - `recipient` cannot be the zero address.
295      * - the caller must have a balance of at least `amount`.
296      */
297     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
298         _transfer(_msgSender(), recipient, amount);
299         return true;
300     }
301 
302     /**
303      * @dev See {IERC20-allowance}.
304      */
305     function allowance(address owner, address spender) public view virtual override returns (uint256) {
306         return _allowances[owner][spender];
307     }
308 
309     /**
310      * @dev See {IERC20-approve}.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function approve(address spender, uint256 amount) public virtual override returns (bool) {
317         _approve(_msgSender(), spender, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-transferFrom}.
323      *
324      * Emits an {Approval} event indicating the updated allowance. This is not
325      * required by the EIP. See the note at the beginning of {ERC20}.
326      *
327      * Requirements:
328      *
329      * - `sender` and `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `amount`.
331      * - the caller must have allowance for ``sender``'s tokens of at least
332      * `amount`.
333      */
334     function transferFrom(
335         address sender,
336         address recipient,
337         uint256 amount
338     ) public virtual override returns (bool) {
339         _transfer(sender, recipient, amount);
340 
341         uint256 currentAllowance = _allowances[sender][_msgSender()];
342         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
343         unchecked {
344             _approve(sender, _msgSender(), currentAllowance - amount);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Atomically increases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to {approve} that can be used as a mitigation for
354      * problems described in {IERC20-approve}.
355      *
356      * Emits an {Approval} event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      */
362     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
363         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
364         return true;
365     }
366 
367     /**
368      * @dev Atomically decreases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      * - `spender` must have allowance for the caller of at least
379      * `subtractedValue`.
380      */
381     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
382         uint256 currentAllowance = _allowances[_msgSender()][spender];
383         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
384         unchecked {
385             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
386         }
387 
388         return true;
389     }
390 
391     /**
392      * @dev Moves `amount` of tokens from `sender` to `recipient`.
393      *
394      * This internal function is equivalent to {transfer}, and can be used to
395      * e.g. implement automatic token fees, slashing mechanisms, etc.
396      *
397      * Emits a {Transfer} event.
398      *
399      * Requirements:
400      *
401      * - `sender` cannot be the zero address.
402      * - `recipient` cannot be the zero address.
403      * - `sender` must have a balance of at least `amount`.
404      */
405     function _transfer(
406         address sender,
407         address recipient,
408         uint256 amount
409     ) internal virtual {
410         require(sender != address(0), "ERC20: transfer from the zero address");
411         require(recipient != address(0), "ERC20: transfer to the zero address");
412 
413         _beforeTokenTransfer(sender, recipient, amount);
414 
415         uint256 senderBalance = _balances[sender];
416         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
417         unchecked {
418             _balances[sender] = senderBalance - amount;
419         }
420         _balances[recipient] += amount;
421 
422         emit Transfer(sender, recipient, amount);
423 
424         _afterTokenTransfer(sender, recipient, amount);
425     }
426 
427     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
428      * the total supply.
429      *
430      * Emits a {Transfer} event with `from` set to the zero address.
431      *
432      * Requirements:
433      *
434      * - `account` cannot be the zero address.
435      */
436     function _mint(address account, uint256 amount) internal virtual {
437         require(account != address(0), "ERC20: mint to the zero address");
438 
439         _beforeTokenTransfer(address(0), account, amount);
440 
441         _totalSupply += amount;
442         _balances[account] += amount;
443         emit Transfer(address(0), account, amount);
444 
445         _afterTokenTransfer(address(0), account, amount);
446     }
447 
448     /**
449      * @dev Destroys `amount` tokens from `account`, reducing the
450      * total supply.
451      *
452      * Emits a {Transfer} event with `to` set to the zero address.
453      *
454      * Requirements:
455      *
456      * - `account` cannot be the zero address.
457      * - `account` must have at least `amount` tokens.
458      */
459     function _burn(address account, uint256 amount) internal virtual {
460         require(account != address(0), "ERC20: burn from the zero address");
461 
462         _beforeTokenTransfer(account, address(0), amount);
463 
464         uint256 accountBalance = _balances[account];
465         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
466         unchecked {
467             _balances[account] = accountBalance - amount;
468         }
469         _totalSupply -= amount;
470 
471         emit Transfer(account, address(0), amount);
472 
473         _afterTokenTransfer(account, address(0), amount);
474     }
475 
476     /**
477      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
478      *
479      * This internal function is equivalent to `approve`, and can be used to
480      * e.g. set automatic allowances for certain subsystems, etc.
481      *
482      * Emits an {Approval} event.
483      *
484      * Requirements:
485      *
486      * - `owner` cannot be the zero address.
487      * - `spender` cannot be the zero address.
488      */
489     function _approve(
490         address owner,
491         address spender,
492         uint256 amount
493     ) internal virtual {
494         require(owner != address(0), "ERC20: approve from the zero address");
495         require(spender != address(0), "ERC20: approve to the zero address");
496 
497         _allowances[owner][spender] = amount;
498         emit Approval(owner, spender, amount);
499     }
500 
501     /**
502      * @dev Hook that is called before any transfer of tokens. This includes
503      * minting and burning.
504      *
505      * Calling conditions:
506      *
507      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
508      * will be transferred to `to`.
509      * - when `from` is zero, `amount` tokens will be minted for `to`.
510      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
511      * - `from` and `to` are never both zero.
512      *
513      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
514      */
515     function _beforeTokenTransfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal virtual {}
520 
521     /**
522      * @dev Hook that is called after any transfer of tokens. This includes
523      * minting and burning.
524      *
525      * Calling conditions:
526      *
527      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
528      * has been transferred to `to`.
529      * - when `from` is zero, `amount` tokens have been minted for `to`.
530      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
531      * - `from` and `to` are never both zero.
532      *
533      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
534      */
535     function _afterTokenTransfer(
536         address from,
537         address to,
538         uint256 amount
539     ) internal virtual {}
540 }
541 
542 contract PLEBToken is Ownable, ERC20 {
543     bool public limited;
544     uint256 public maxWallet;
545     address public uniswapV2Pair;
546 
547     constructor(uint256 _totalSupply) ERC20("PLEBToken", "PLEB") {
548         _mint(msg.sender, _totalSupply);
549     }
550 
551     function setWalletRule(bool _limited, address _uniswapV2Pair, uint256 _maxWallet) external onlyOwner {
552         limited = _limited;
553         uniswapV2Pair = _uniswapV2Pair;
554         maxWallet = _maxWallet;
555     }
556 
557     function _beforeTokenTransfer(
558         address from,
559         address to,
560         uint256 amount
561     ) override internal virtual {
562 
563         if (uniswapV2Pair == address(0)) {
564             require(from == owner() || to == owner(), "trading not open yet");
565             return;
566         }
567 
568         if (limited && from == uniswapV2Pair) {
569             require(balanceOf(to) + amount <= maxWallet, "max wallet breached");
570         }
571     }
572 
573 }