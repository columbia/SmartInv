1 pragma solidity 0.8.11;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
98 
99 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
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
178 
179 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
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
202 
203 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
204 /**
205  * @dev Implementation of the {IERC20} interface.
206  *
207  * This implementation is agnostic to the way tokens are created. This means
208  * that a supply mechanism has to be added in a derived contract using {_mint}.
209  * For a generic mechanism see {ERC20PresetMinterPauser}.
210  *
211  * TIP: For a detailed writeup see our guide
212  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
213  * to implement supply mechanisms].
214  *
215  * We have followed general OpenZeppelin Contracts guidelines: functions revert
216  * instead returning `false` on failure. This behavior is nonetheless
217  * conventional and does not conflict with the expectations of ERC20
218  * applications.
219  *
220  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
221  * This allows applications to reconstruct the allowance for all accounts just
222  * by listening to said events. Other implementations of the EIP may not emit
223  * these events, as it isn't required by the specification.
224  *
225  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
226  * functions have been added to mitigate the well-known issues around setting
227  * allowances. See {IERC20-approve}.
228  */
229 contract ERC20 is Context, IERC20, IERC20Metadata {
230     mapping(address => uint256) private _balances;
231 
232     mapping(address => mapping(address => uint256)) private _allowances;
233 
234     uint256 private _totalSupply;
235 
236     string private _name;
237     string private _symbol;
238 
239     /**
240      * @dev Sets the values for {name} and {symbol}.
241      *
242      * The default value of {decimals} is 18. To select a different value for
243      * {decimals} you should overload it.
244      *
245      * All two of these values are immutable: they can only be set once during
246      * construction.
247      */
248     constructor(string memory name_, string memory symbol_) {
249         _name = name_;
250         _symbol = symbol_;
251     }
252 
253     /**
254      * @dev Returns the name of the token.
255      */
256     function name() public view virtual override returns (string memory) {
257         return _name;
258     }
259 
260     /**
261      * @dev Returns the symbol of the token, usually a shorter version of the
262      * name.
263      */
264     function symbol() public view virtual override returns (string memory) {
265         return _symbol;
266     }
267 
268     /**
269      * @dev Returns the number of decimals used to get its user representation.
270      * For example, if `decimals` equals `2`, a balance of `505` tokens should
271      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
272      *
273      * Tokens usually opt for a value of 18, imitating the relationship between
274      * Ether and Wei. This is the value {ERC20} uses, unless this function is
275      * overridden;
276      *
277      * NOTE: This information is only used for _display_ purposes: it in
278      * no way affects any of the arithmetic of the contract, including
279      * {IERC20-balanceOf} and {IERC20-transfer}.
280      */
281     function decimals() public view virtual override returns (uint8) {
282         return 18;
283     }
284 
285     /**
286      * @dev See {IERC20-totalSupply}.
287      */
288     function totalSupply() public view virtual override returns (uint256) {
289         return _totalSupply;
290     }
291 
292     /**
293      * @dev See {IERC20-balanceOf}.
294      */
295     function balanceOf(address account) public view virtual override returns (uint256) {
296         return _balances[account];
297     }
298 
299     /**
300      * @dev See {IERC20-transfer}.
301      *
302      * Requirements:
303      *
304      * - `recipient` cannot be the zero address.
305      * - the caller must have a balance of at least `amount`.
306      */
307     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
308         _transfer(_msgSender(), recipient, amount);
309         return true;
310     }
311 
312     /**
313      * @dev See {IERC20-allowance}.
314      */
315     function allowance(address owner, address spender) public view virtual override returns (uint256) {
316         return _allowances[owner][spender];
317     }
318 
319     /**
320      * @dev See {IERC20-approve}.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function approve(address spender, uint256 amount) public virtual override returns (bool) {
327         _approve(_msgSender(), spender, amount);
328         return true;
329     }
330 
331     /**
332      * @dev See {IERC20-transferFrom}.
333      *
334      * Emits an {Approval} event indicating the updated allowance. This is not
335      * required by the EIP. See the note at the beginning of {ERC20}.
336      *
337      * Requirements:
338      *
339      * - `sender` and `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      * - the caller must have allowance for ``sender``'s tokens of at least
342      * `amount`.
343      */
344     function transferFrom(
345         address sender,
346         address recipient,
347         uint256 amount
348     ) public virtual override returns (bool) {
349         _transfer(sender, recipient, amount);
350 
351         uint256 currentAllowance = _allowances[sender][_msgSender()];
352         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
353         unchecked {
354             _approve(sender, _msgSender(), currentAllowance - amount);
355         }
356 
357         return true;
358     }
359 
360     /**
361      * @dev Atomically increases the allowance granted to `spender` by the caller.
362      *
363      * This is an alternative to {approve} that can be used as a mitigation for
364      * problems described in {IERC20-approve}.
365      *
366      * Emits an {Approval} event indicating the updated allowance.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
373         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
374         return true;
375     }
376 
377     /**
378      * @dev Atomically decreases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to {approve} that can be used as a mitigation for
381      * problems described in {IERC20-approve}.
382      *
383      * Emits an {Approval} event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      * - `spender` must have allowance for the caller of at least
389      * `subtractedValue`.
390      */
391     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
392         uint256 currentAllowance = _allowances[_msgSender()][spender];
393         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
394         unchecked {
395             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
396         }
397 
398         return true;
399     }
400 
401     /**
402      * @dev Moves `amount` of tokens from `sender` to `recipient`.
403      *
404      * This internal function is equivalent to {transfer}, and can be used to
405      * e.g. implement automatic token fees, slashing mechanisms, etc.
406      *
407      * Emits a {Transfer} event.
408      *
409      * Requirements:
410      *
411      * - `sender` cannot be the zero address.
412      * - `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      */
415     function _transfer(
416         address sender,
417         address recipient,
418         uint256 amount
419     ) internal virtual {
420         require(sender != address(0), "ERC20: transfer from the zero address");
421         require(recipient != address(0), "ERC20: transfer to the zero address");
422 
423         _beforeTokenTransfer(sender, recipient, amount);
424 
425         uint256 senderBalance = _balances[sender];
426         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
427         unchecked {
428             _balances[sender] = senderBalance - amount;
429         }
430         _balances[recipient] += amount;
431 
432         emit Transfer(sender, recipient, amount);
433 
434         _afterTokenTransfer(sender, recipient, amount);
435     }
436 
437     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
438      * the total supply.
439      *
440      * Emits a {Transfer} event with `from` set to the zero address.
441      *
442      * Requirements:
443      *
444      * - `account` cannot be the zero address.
445      */
446     function _mint(address account, uint256 amount) internal virtual {
447         require(account != address(0), "ERC20: mint to the zero address");
448 
449         _beforeTokenTransfer(address(0), account, amount);
450 
451         _totalSupply += amount;
452         _balances[account] += amount;
453         emit Transfer(address(0), account, amount);
454 
455         _afterTokenTransfer(address(0), account, amount);
456     }
457 
458     /**
459      * @dev Destroys `amount` tokens from `account`, reducing the
460      * total supply.
461      *
462      * Emits a {Transfer} event with `to` set to the zero address.
463      *
464      * Requirements:
465      *
466      * - `account` cannot be the zero address.
467      * - `account` must have at least `amount` tokens.
468      */
469     function _burn(address account, uint256 amount) internal virtual {
470         require(account != address(0), "ERC20: burn from the zero address");
471 
472         _beforeTokenTransfer(account, address(0), amount);
473 
474         uint256 accountBalance = _balances[account];
475         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
476         unchecked {
477             _balances[account] = accountBalance - amount;
478         }
479         _totalSupply -= amount;
480 
481         emit Transfer(account, address(0), amount);
482 
483         _afterTokenTransfer(account, address(0), amount);
484     }
485 
486     /**
487      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
488      *
489      * This internal function is equivalent to `approve`, and can be used to
490      * e.g. set automatic allowances for certain subsystems, etc.
491      *
492      * Emits an {Approval} event.
493      *
494      * Requirements:
495      *
496      * - `owner` cannot be the zero address.
497      * - `spender` cannot be the zero address.
498      */
499     function _approve(
500         address owner,
501         address spender,
502         uint256 amount
503     ) internal virtual {
504         require(owner != address(0), "ERC20: approve from the zero address");
505         require(spender != address(0), "ERC20: approve to the zero address");
506 
507         _allowances[owner][spender] = amount;
508         emit Approval(owner, spender, amount);
509     }
510 
511     /**
512      * @dev Hook that is called before any transfer of tokens. This includes
513      * minting and burning.
514      *
515      * Calling conditions:
516      *
517      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
518      * will be transferred to `to`.
519      * - when `from` is zero, `amount` tokens will be minted for `to`.
520      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
521      * - `from` and `to` are never both zero.
522      *
523      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
524      */
525     function _beforeTokenTransfer(
526         address from,
527         address to,
528         uint256 amount
529     ) internal virtual {}
530 
531     /**
532      * @dev Hook that is called after any transfer of tokens. This includes
533      * minting and burning.
534      *
535      * Calling conditions:
536      *
537      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
538      * has been transferred to `to`.
539      * - when `from` is zero, `amount` tokens have been minted for `to`.
540      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
541      * - `from` and `to` are never both zero.
542      *
543      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
544      */
545     function _afterTokenTransfer(
546         address from,
547         address to,
548         uint256 amount
549     ) internal virtual {}
550 }
551 
552 
553 contract RankerDAOToken is Ownable, ERC20 {
554   uint256 constant MILLION = 1_000_000 * 10**uint256(18);
555 
556   constructor() ERC20('RankerDAO', 'RANKER') {
557     _mint(msg.sender, 300 * MILLION);
558   }
559 
560 
561   /**
562    * Allows the owner of the contract to release tokens that were erronously sent to this  
563    * ERC20 smart contract. This covers any mistakes from the end-user side
564    * @param token the token that we want to withdraw
565    * @param recipient the address that will receive the tokens
566    * @param amount the amount of tokens
567    */
568   function tokenRescue(
569     IERC20 token,
570     address recipient,
571     uint256 amount
572   ) onlyOwner external {
573     token.transfer(recipient, amount);
574   }
575 }