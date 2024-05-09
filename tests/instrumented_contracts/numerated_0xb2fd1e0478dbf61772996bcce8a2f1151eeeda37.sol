1 // SPDX-License-Identifier: MIT
2 
3 /*
4     a part of history $WPEPE #WRAPPEDPEPE
5         - wrappedpepe.vip
6     
7     * tg: @wpepeportal
8     * twitter: @wrappedpepe
9 */
10 
11 pragma solidity ^0.8.7;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _transferOwnership(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _transferOwnership(newOwner);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Internal function without access restriction.
95      */
96     function _transferOwnership(address newOwner) internal virtual {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 /**
104  * @dev Interface of the ERC20 standard as defined in the EIP.
105  */
106 interface IERC20 {
107     /**
108      * @dev Returns the amount of tokens in existence.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     /**
113      * @dev Returns the amount of tokens owned by `account`.
114      */
115     function balanceOf(address account) external view returns (uint256);
116 
117     /**
118      * @dev Moves `amount` tokens from the caller's account to `recipient`.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transfer(address recipient, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Returns the remaining number of tokens that `spender` will be
128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
129      * zero by default.
130      *
131      * This value changes when {approve} or {transferFrom} are called.
132      */
133     function allowance(address owner, address spender) external view returns (uint256);
134 
135     /**
136      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * IMPORTANT: Beware that changing an allowance with this method brings the risk
141      * that someone may use both the old and the new allowance by unfortunate
142      * transaction ordering. One possible solution to mitigate this race
143      * condition is to first reduce the spender's allowance to 0 and set the
144      * desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address spender, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Moves `amount` tokens from `sender` to `recipient` using the
153      * allowance mechanism. `amount` is then deducted from the caller's
154      * allowance.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transferFrom(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
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
203 /**
204  * @dev Implementation of the {IERC20} interface.
205  *
206  * This implementation is agnostic to the way tokens are created. This means
207  * that a supply mechanism has to be added in a derived contract using {_mint}.
208  * For a generic mechanism see {ERC20PresetMinterPauser}.
209  *
210  * TIP: For a detailed writeup see our guide
211  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
212  * to implement supply mechanisms].
213  *
214  * We have followed general OpenZeppelin Contracts guidelines: functions revert
215  * instead returning `false` on failure. This behavior is nonetheless
216  * conventional and does not conflict with the expectations of ERC20
217  * applications.
218  *
219  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
220  * This allows applications to reconstruct the allowance for all accounts just
221  * by listening to said events. Other implementations of the EIP may not emit
222  * these events, as it isn't required by the specification.
223  *
224  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
225  * functions have been added to mitigate the well-known issues around setting
226  * allowances. See {IERC20-approve}.
227  */
228 contract ERC20 is Context, IERC20, IERC20Metadata {
229     mapping(address => uint256) private _balances;
230 
231     mapping(address => mapping(address => uint256)) private _allowances;
232 
233     uint256 private _totalSupply;
234 
235     string private _name;
236     string private _symbol;
237 
238     /**
239      * @dev Sets the values for {name} and {symbol}.
240      *
241      * The default value of {decimals} is 18. To select a different value for
242      * {decimals} you should overload it.
243      *
244      * All two of these values are immutable: they can only be set once during
245      * construction.
246      */
247     constructor(string memory name_, string memory symbol_) {
248         _name = name_;
249         _symbol = symbol_;
250     }
251 
252     /**
253      * @dev Returns the name of the token.
254      */
255     function name() public view virtual override returns (string memory) {
256         return _name;
257     }
258 
259     /**
260      * @dev Returns the symbol of the token, usually a shorter version of the
261      * name.
262      */
263     function symbol() public view virtual override returns (string memory) {
264         return _symbol;
265     }
266 
267     /**
268      * @dev Returns the number of decimals used to get its user representation.
269      * For example, if `decimals` equals `2`, a balance of `505` tokens should
270      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
271      *
272      * Tokens usually opt for a value of 18, imitating the relationship between
273      * Ether and Wei. This is the value {ERC20} uses, unless this function is
274      * overridden;
275      *
276      * NOTE: This information is only used for _display_ purposes: it in
277      * no way affects any of the arithmetic of the contract, including
278      * {IERC20-balanceOf} and {IERC20-transfer}.
279      */
280     function decimals() public view virtual override returns (uint8) {
281         return 18;
282     }
283 
284     /**
285      * @dev See {IERC20-totalSupply}.
286      */
287     function totalSupply() public view virtual override returns (uint256) {
288         return _totalSupply;
289     }
290 
291     /**
292      * @dev See {IERC20-balanceOf}.
293      */
294     function balanceOf(address account) public view virtual override returns (uint256) {
295         return _balances[account];
296     }
297 
298     /**
299      * @dev See {IERC20-transfer}.
300      *
301      * Requirements:
302      *
303      * - `recipient` cannot be the zero address.
304      * - the caller must have a balance of at least `amount`.
305      */
306     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
307         _transfer(_msgSender(), recipient, amount);
308         return true;
309     }
310 
311     /**
312      * @dev See {IERC20-allowance}.
313      */
314     function allowance(address owner, address spender) public view virtual override returns (uint256) {
315         return _allowances[owner][spender];
316     }
317 
318     /**
319      * @dev See {IERC20-approve}.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function approve(address spender, uint256 amount) public virtual override returns (bool) {
326         _approve(_msgSender(), spender, amount);
327         return true;
328     }
329 
330     /**
331      * @dev See {IERC20-transferFrom}.
332      *
333      * Emits an {Approval} event indicating the updated allowance. This is not
334      * required by the EIP. See the note at the beginning of {ERC20}.
335      *
336      * Requirements:
337      *
338      * - `sender` and `recipient` cannot be the zero address.
339      * - `sender` must have a balance of at least `amount`.
340      * - the caller must have allowance for ``sender``'s tokens of at least
341      * `amount`.
342      */
343     function transferFrom(
344         address sender,
345         address recipient,
346         uint256 amount
347     ) public virtual override returns (bool) {
348         _transfer(sender, recipient, amount);
349 
350         uint256 currentAllowance = _allowances[sender][_msgSender()];
351         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
352         unchecked {
353             _approve(sender, _msgSender(), currentAllowance - amount);
354         }
355 
356         return true;
357     }
358 
359     /**
360      * @dev Atomically increases the allowance granted to `spender` by the caller.
361      *
362      * This is an alternative to {approve} that can be used as a mitigation for
363      * problems described in {IERC20-approve}.
364      *
365      * Emits an {Approval} event indicating the updated allowance.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
372         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
373         return true;
374     }
375 
376     /**
377      * @dev Atomically decreases the allowance granted to `spender` by the caller.
378      *
379      * This is an alternative to {approve} that can be used as a mitigation for
380      * problems described in {IERC20-approve}.
381      *
382      * Emits an {Approval} event indicating the updated allowance.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      * - `spender` must have allowance for the caller of at least
388      * `subtractedValue`.
389      */
390     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
391         uint256 currentAllowance = _allowances[_msgSender()][spender];
392         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
393         unchecked {
394             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
395         }
396 
397         return true;
398     }
399 
400     /**
401      * @dev Moves `amount` of tokens from `sender` to `recipient`.
402      *
403      * This internal function is equivalent to {transfer}, and can be used to
404      * e.g. implement automatic token fees, slashing mechanisms, etc.
405      *
406      * Emits a {Transfer} event.
407      *
408      * Requirements:
409      *
410      * - `sender` cannot be the zero address.
411      * - `recipient` cannot be the zero address.
412      * - `sender` must have a balance of at least `amount`.
413      */
414     function _transfer(
415         address sender,
416         address recipient,
417         uint256 amount
418     ) internal virtual {
419         require(sender != address(0), "ERC20: transfer from the zero address");
420         require(recipient != address(0), "ERC20: transfer to the zero address");
421 
422         _beforeTokenTransfer(sender, recipient, amount);
423 
424         uint256 senderBalance = _balances[sender];
425         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
426         unchecked {
427             _balances[sender] = senderBalance - amount;
428         }
429         _balances[recipient] += amount;
430 
431         emit Transfer(sender, recipient, amount);
432 
433         _afterTokenTransfer(sender, recipient, amount);
434     }
435 
436     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
437      * the total supply.
438      *
439      * Emits a {Transfer} event with `from` set to the zero address.
440      *
441      * Requirements:
442      *
443      * - `account` cannot be the zero address.
444      */
445     function _mint(address account, uint256 amount) internal virtual {
446         require(account != address(0), "ERC20: mint to the zero address");
447 
448         _beforeTokenTransfer(address(0), account, amount);
449 
450         _totalSupply += amount;
451         _balances[account] += amount;
452         emit Transfer(address(0), account, amount);
453 
454         _afterTokenTransfer(address(0), account, amount);
455     }
456 
457     /**
458      * @dev Destroys `amount` tokens from `account`, reducing the
459      * total supply.
460      *
461      * Emits a {Transfer} event with `to` set to the zero address.
462      *
463      * Requirements:
464      *
465      * - `account` cannot be the zero address.
466      * - `account` must have at least `amount` tokens.
467      */
468     function _burn(address account, uint256 amount) internal virtual {
469         require(account != address(0), "ERC20: burn from the zero address");
470 
471         _beforeTokenTransfer(account, address(0), amount);
472 
473         uint256 accountBalance = _balances[account];
474         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
475         unchecked {
476             _balances[account] = accountBalance - amount;
477         }
478         _totalSupply -= amount;
479 
480         emit Transfer(account, address(0), amount);
481 
482         _afterTokenTransfer(account, address(0), amount);
483     }
484 
485     /**
486      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
487      *
488      * This internal function is equivalent to `approve`, and can be used to
489      * e.g. set automatic allowances for certain subsystems, etc.
490      *
491      * Emits an {Approval} event.
492      *
493      * Requirements:
494      *
495      * - `owner` cannot be the zero address.
496      * - `spender` cannot be the zero address.
497      */
498     function _approve(
499         address owner,
500         address spender,
501         uint256 amount
502     ) internal virtual {
503         require(owner != address(0), "ERC20: approve from the zero address");
504         require(spender != address(0), "ERC20: approve to the zero address");
505 
506         _allowances[owner][spender] = amount;
507         emit Approval(owner, spender, amount);
508     }
509 
510     /**
511      * @dev Hook that is called before any transfer of tokens. This includes
512      * minting and burning.
513      *
514      * Calling conditions:
515      *
516      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
517      * will be transferred to `to`.
518      * - when `from` is zero, `amount` tokens will be minted for `to`.
519      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
520      * - `from` and `to` are never both zero.
521      *
522      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
523      */
524     function _beforeTokenTransfer(
525         address from,
526         address to,
527         uint256 amount
528     ) internal virtual {}
529 
530     /**
531      * @dev Hook that is called after any transfer of tokens. This includes
532      * minting and burning.
533      *
534      * Calling conditions:
535      *
536      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
537      * has been transferred to `to`.
538      * - when `from` is zero, `amount` tokens have been minted for `to`.
539      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
540      * - `from` and `to` are never both zero.
541      *
542      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
543      */
544     function _afterTokenTransfer(
545         address from,
546         address to,
547         uint256 amount
548     ) internal virtual {}
549 }
550 
551 contract WrappedPepe is Ownable, ERC20 {
552     bool private _tradingEnabled;
553 
554     constructor(uint256 _totalSupply) ERC20("Wrapped Pepe", "WPEPE") {
555         // internal function cannot mint after deployment
556         _mint(msg.sender, _totalSupply);
557     }
558 
559     /**
560         * @dev Once function is called there is no way back
561     */
562     function enableTrading() external onlyOwner {
563         _tradingEnabled = true;
564     }
565 
566     function _beforeTokenTransfer(
567         address from,
568         address to,
569         uint256 amount
570     ) override internal virtual {
571         if (!_tradingEnabled) {
572             require(from == owner() || to == owner(), "trading is not enabled");
573             return;
574         }
575     }
576 }