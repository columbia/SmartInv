1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 /**
99  * @dev Interface of the ERC20 standard as defined in the EIP.
100  */
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address recipient, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
124      * zero by default.
125      *
126      * This value changes when {approve} or {transferFrom} are called.
127      */
128     function allowance(address owner, address spender) external view returns (uint256);
129 
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 /**
177  * @dev Interface for the optional metadata functions from the ERC20 standard.
178  *
179  * _Available since v4.1._
180  */
181 interface IERC20Metadata is IERC20 {
182     /**
183      * @dev Returns the name of the token.
184      */
185     function name() external view returns (string memory);
186 
187     /**
188      * @dev Returns the symbol of the token.
189      */
190     function symbol() external view returns (string memory);
191 
192     /**
193      * @dev Returns the decimals places of the token.
194      */
195     function decimals() external view returns (uint8);
196 }
197 
198 /**
199  * @dev Implementation of the {IERC20} interface.
200  *
201  * This implementation is agnostic to the way tokens are created. This means
202  * that a supply mechanism has to be added in a derived contract using {_mint}.
203  * For a generic mechanism see {ERC20PresetMinterPauser}.
204  *
205  * TIP: For a detailed writeup see our guide
206  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
207  * to implement supply mechanisms].
208  *
209  * We have followed general OpenZeppelin Contracts guidelines: functions revert
210  * instead returning `false` on failure. This behavior is nonetheless
211  * conventional and does not conflict with the expectations of ERC20
212  * applications.
213  *
214  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
215  * This allows applications to reconstruct the allowance for all accounts just
216  * by listening to said events. Other implementations of the EIP may not emit
217  * these events, as it isn't required by the specification.
218  *
219  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
220  * functions have been added to mitigate the well-known issues around setting
221  * allowances. See {IERC20-approve}.
222  */
223 contract ERC20 is Context, IERC20, IERC20Metadata {
224     mapping(address => uint256) private _balances;
225 
226     mapping(address => mapping(address => uint256)) private _allowances;
227 
228     uint256 private _totalSupply;
229 
230     string private _name;
231     string private _symbol;
232 
233     /**
234      * @dev Sets the values for {name} and {symbol}.
235      *
236      * The default value of {decimals} is 18. To select a different value for
237      * {decimals} you should overload it.
238      *
239      * All two of these values are immutable: they can only be set once during
240      * construction.
241      */
242     constructor(string memory name_, string memory symbol_) {
243         _name = name_;
244         _symbol = symbol_;
245     }
246 
247     /**
248      * @dev Returns the name of the token.
249      */
250     function name() public view virtual override returns (string memory) {
251         return _name;
252     }
253 
254     /**
255      * @dev Returns the symbol of the token, usually a shorter version of the
256      * name.
257      */
258     function symbol() public view virtual override returns (string memory) {
259         return _symbol;
260     }
261 
262     /**
263      * @dev Returns the number of decimals used to get its user representation.
264      * For example, if `decimals` equals `2`, a balance of `505` tokens should
265      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
266      *
267      * Tokens usually opt for a value of 18, imitating the relationship between
268      * Ether and Wei. This is the value {ERC20} uses, unless this function is
269      * overridden;
270      *
271      * NOTE: This information is only used for _display_ purposes: it in
272      * no way affects any of the arithmetic of the contract, including
273      * {IERC20-balanceOf} and {IERC20-transfer}.
274      */
275     function decimals() public view virtual override returns (uint8) {
276         return 18;
277     }
278 
279     /**
280      * @dev See {IERC20-totalSupply}.
281      */
282     function totalSupply() public view virtual override returns (uint256) {
283         return _totalSupply;
284     }
285 
286     /**
287      * @dev See {IERC20-balanceOf}.
288      */
289     function balanceOf(address account) public view virtual override returns (uint256) {
290         return _balances[account];
291     }
292 
293     /**
294      * @dev See {IERC20-transfer}.
295      *
296      * Requirements:
297      *
298      * - `recipient` cannot be the zero address.
299      * - the caller must have a balance of at least `amount`.
300      */
301     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
302         _transfer(_msgSender(), recipient, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-allowance}.
308      */
309     function allowance(address owner, address spender) public view virtual override returns (uint256) {
310         return _allowances[owner][spender];
311     }
312 
313     /**
314      * @dev See {IERC20-approve}.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function approve(address spender, uint256 amount) public virtual override returns (bool) {
321         _approve(_msgSender(), spender, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-transferFrom}.
327      *
328      * Emits an {Approval} event indicating the updated allowance. This is not
329      * required by the EIP. See the note at the beginning of {ERC20}.
330      *
331      * Requirements:
332      *
333      * - `sender` and `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `amount`.
335      * - the caller must have allowance for ``sender``'s tokens of at least
336      * `amount`.
337      */
338     function transferFrom(
339         address sender,
340         address recipient,
341         uint256 amount
342     ) public virtual override returns (bool) {
343         _transfer(sender, recipient, amount);
344 
345         uint256 currentAllowance = _allowances[sender][_msgSender()];
346         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
347         unchecked {
348             _approve(sender, _msgSender(), currentAllowance - amount);
349         }
350 
351         return true;
352     }
353 
354     /**
355      * @dev Atomically increases the allowance granted to `spender` by the caller.
356      *
357      * This is an alternative to {approve} that can be used as a mitigation for
358      * problems described in {IERC20-approve}.
359      *
360      * Emits an {Approval} event indicating the updated allowance.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
367         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
368         return true;
369     }
370 
371     /**
372      * @dev Atomically decreases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to {approve} that can be used as a mitigation for
375      * problems described in {IERC20-approve}.
376      *
377      * Emits an {Approval} event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      * - `spender` must have allowance for the caller of at least
383      * `subtractedValue`.
384      */
385     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
386         uint256 currentAllowance = _allowances[_msgSender()][spender];
387         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
388         unchecked {
389             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
390         }
391 
392         return true;
393     }
394 
395     /**
396      * @dev Moves `amount` of tokens from `sender` to `recipient`.
397      *
398      * This internal function is equivalent to {transfer}, and can be used to
399      * e.g. implement automatic token fees, slashing mechanisms, etc.
400      *
401      * Emits a {Transfer} event.
402      *
403      * Requirements:
404      *
405      * - `sender` cannot be the zero address.
406      * - `recipient` cannot be the zero address.
407      * - `sender` must have a balance of at least `amount`.
408      */
409     function _transfer(
410         address sender,
411         address recipient,
412         uint256 amount
413     ) internal virtual {
414         require(sender != address(0), "ERC20: transfer from the zero address");
415         require(recipient != address(0), "ERC20: transfer to the zero address");
416 
417         _beforeTokenTransfer(sender, recipient, amount);
418 
419         uint256 senderBalance = _balances[sender];
420         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
421         unchecked {
422             _balances[sender] = senderBalance - amount;
423         }
424         _balances[recipient] += amount;
425 
426         emit Transfer(sender, recipient, amount);
427 
428         _afterTokenTransfer(sender, recipient, amount);
429     }
430 
431     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
432      * the total supply.
433      *
434      * Emits a {Transfer} event with `from` set to the zero address.
435      *
436      * Requirements:
437      *
438      * - `account` cannot be the zero address.
439      */
440     function _mint(address account, uint256 amount) internal virtual {
441         require(account != address(0), "ERC20: mint to the zero address");
442 
443         _beforeTokenTransfer(address(0), account, amount);
444 
445         _totalSupply += amount;
446         _balances[account] += amount;
447         emit Transfer(address(0), account, amount);
448 
449         _afterTokenTransfer(address(0), account, amount);
450     }
451 
452     /**
453      * @dev Destroys `amount` tokens from `account`, reducing the
454      * total supply.
455      *
456      * Emits a {Transfer} event with `to` set to the zero address.
457      *
458      * Requirements:
459      *
460      * - `account` cannot be the zero address.
461      * - `account` must have at least `amount` tokens.
462      */
463     function _burn(address account, uint256 amount) internal virtual {
464         require(account != address(0), "ERC20: burn from the zero address");
465 
466         _beforeTokenTransfer(account, address(0), amount);
467 
468         uint256 accountBalance = _balances[account];
469         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
470         unchecked {
471             _balances[account] = accountBalance - amount;
472         }
473         _totalSupply -= amount;
474 
475         emit Transfer(account, address(0), amount);
476 
477         _afterTokenTransfer(account, address(0), amount);
478     }
479 
480     /**
481      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
482      *
483      * This internal function is equivalent to `approve`, and can be used to
484      * e.g. set automatic allowances for certain subsystems, etc.
485      *
486      * Emits an {Approval} event.
487      *
488      * Requirements:
489      *
490      * - `owner` cannot be the zero address.
491      * - `spender` cannot be the zero address.
492      */
493     function _approve(
494         address owner,
495         address spender,
496         uint256 amount
497     ) internal virtual {
498         require(owner != address(0), "ERC20: approve from the zero address");
499         require(spender != address(0), "ERC20: approve to the zero address");
500 
501         _allowances[owner][spender] = amount;
502         emit Approval(owner, spender, amount);
503     }
504 
505     /**
506      * @dev Hook that is called before any transfer of tokens. This includes
507      * minting and burning.
508      *
509      * Calling conditions:
510      *
511      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
512      * will be transferred to `to`.
513      * - when `from` is zero, `amount` tokens will be minted for `to`.
514      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
515      * - `from` and `to` are never both zero.
516      *
517      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
518      */
519     function _beforeTokenTransfer(
520         address from,
521         address to,
522         uint256 amount
523     ) internal virtual {}
524 
525     /**
526      * @dev Hook that is called after any transfer of tokens. This includes
527      * minting and burning.
528      *
529      * Calling conditions:
530      *
531      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
532      * has been transferred to `to`.
533      * - when `from` is zero, `amount` tokens have been minted for `to`.
534      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
535      * - `from` and `to` are never both zero.
536      *
537      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
538      */
539     function _afterTokenTransfer(
540         address from,
541         address to,
542         uint256 amount
543     ) internal virtual {}
544 }
545 
546 contract GroguCash is Ownable, ERC20 {
547     bool public limited;
548     uint256 public maxWallet;
549     address public uniswapV2Pair;
550 
551     constructor() ERC20("Grogu Cash", "GROGU") {
552         _mint(msg.sender, 1000000000000 * 10 ** decimals());
553     }
554 
555     function setWalletRule(bool _limited, address _uniswapV2Pair, uint256 _maxWallet) external onlyOwner {
556         limited = _limited;
557         uniswapV2Pair = _uniswapV2Pair;
558         maxWallet = _maxWallet;
559     }
560 
561     function _beforeTokenTransfer(
562         address from,
563         address to,
564         uint256 amount
565     ) override internal virtual {
566 
567         if (uniswapV2Pair == address(0)) {
568             require(from == owner() || to == owner(), "trading not open yet");
569             return;
570         }
571 
572         if (limited && from == uniswapV2Pair) {
573             require(balanceOf(to) + amount <= maxWallet, "max wallet breached");
574         }
575     }
576 
577 }