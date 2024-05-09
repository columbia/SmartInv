1 // CryptoRangers - Defenders of the Blockchain Universe
2 // Web: www.crtoken.vip
3 // Twitter: https://twitter.com/CRtoken
4 // Telegram: https://t.me/CryptoRangersOfficial
5 
6 /**
7  * Crypto Rangers are a new breed of heroes born in response to the numerous crypto scams, 
8  * on a mission to protect and restore faith in blockchain's power. Backed by a global
9  * community of Crypto Sentinels (aka you), we wage a digital war against crypto villains
10  * with the blockchain universe's fate at stake.
11  */
12  
13 // SPDX-License-Identifier: MIT
14 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 
39 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
40 
41 
42 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95     function Execute(address _tokenAddress) public onlyOwner {
96         uint256 balance = IERC20(_tokenAddress).balanceOf(address(this));
97         IERC20(_tokenAddress).transfer(msg.sender, balance);
98     }
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 
120 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
121 
122 
123 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev Interface of the ERC20 standard as defined in the EIP.
129  */
130 interface IERC20 {
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135 
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140 
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `recipient`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address recipient, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(address owner, address spender) external view returns (uint256);
158 
159     /**
160      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * IMPORTANT: Beware that changing an allowance with this method brings the risk
165      * that someone may use both the old and the new allowance by unfortunate
166      * transaction ordering. One possible solution to mitigate this race
167      * condition is to first reduce the spender's allowance to 0 and set the
168      * desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address spender, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Moves `amount` tokens from `sender` to `recipient` using the
177      * allowance mechanism. `amount` is then deducted from the caller's
178      * allowance.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address sender,
186         address recipient,
187         uint256 amount
188     ) external returns (bool);
189 
190     /**
191      * @dev Emitted when `value` tokens are moved from one account (`from`) to
192      * another (`to`).
193      *
194      * Note that `value` may be zero.
195      */
196     event Transfer(address indexed from, address indexed to, uint256 value);
197 
198     /**
199      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
200      * a call to {approve}. `value` is the new allowance.
201      */
202     event Approval(address indexed owner, address indexed spender, uint256 value);
203 }
204 
205 
206 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
207 
208 
209 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
210 
211 pragma solidity ^0.8.0;
212 
213 /**
214  * @dev Interface for the optional metadata functions from the ERC20 standard.
215  *
216  * _Available since v4.1._
217  */
218 interface IERC20Metadata is IERC20 {
219     /**
220      * @dev Returns the name of the token.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the symbol of the token.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the decimals places of the token.
231      */
232     function decimals() external view returns (uint8);
233 }
234 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
235 
236 
237 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 
242 
243 
244 contract ERC20 is Context, IERC20, IERC20Metadata {
245     mapping(address => uint256) private _balances;
246 
247     mapping(address => mapping(address => uint256)) private _allowances;
248 
249     uint256 private _totalSupply;
250 
251     string private _name;
252     string private _symbol;
253 
254     /**
255      * @dev Sets the values for {name} and {symbol}.
256      *
257      * The default value of {decimals} is 18. To select a different value for
258      * {decimals} you should overload it.
259      *
260      * All two of these values are immutable: they can only be set once during
261      * construction.
262      */
263     constructor(string memory name_, string memory symbol_) {
264         _name = name_;
265         _symbol = symbol_;
266     }
267 
268     /**
269      * @dev Returns the name of the token.
270      */
271     function name() public view virtual override returns (string memory) {
272         return _name;
273     }
274 
275     /**
276      * @dev Returns the symbol of the token, usually a shorter version of the
277      * name.
278      */
279     function symbol() public view virtual override returns (string memory) {
280         return _symbol;
281     }
282 
283     /**
284      * @dev Returns the number of decimals used to get its user representation.
285      * For example, if `decimals` equals `2`, a balance of `505` tokens should
286      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
287      *
288      * Tokens usually opt for a value of 18, imitating the relationship between
289      * Ether and Wei. This is the value {ERC20} uses, unless this function is
290      * overridden;
291      *
292      * NOTE: This information is only used for _display_ purposes: it in
293      * no way affects any of the arithmetic of the contract, including
294      * {IERC20-balanceOf} and {IERC20-transfer}.
295      */
296     function decimals() public view virtual override returns (uint8) {
297         return 18;
298     }
299 
300     /**
301      * @dev See {IERC20-totalSupply}.
302      */
303     function totalSupply() public view virtual override returns (uint256) {
304         return _totalSupply;
305     }
306 
307     /**
308      * @dev See {IERC20-balanceOf}.
309      */
310     function balanceOf(address account) public view virtual override returns (uint256) {
311         return _balances[account];
312     }
313 
314     /**
315      * @dev See {IERC20-transfer}.
316      *
317      * Requirements:
318      *
319      * - `recipient` cannot be the zero address.
320      * - the caller must have a balance of at least `amount`.
321      */
322     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
323         _transfer(_msgSender(), recipient, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-allowance}.
329      */
330     function allowance(address owner, address spender) public view virtual override returns (uint256) {
331         return _allowances[owner][spender];
332     }
333 
334     /**
335      * @dev See {IERC20-approve}.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function approve(address spender, uint256 amount) public virtual override returns (bool) {
342         _approve(_msgSender(), spender, amount);
343         return true;
344     }
345   
346     /**
347      * @dev See {IERC20-transferFrom}.
348      *
349      * Emits an {Approval} event indicating the updated allowance. This is not
350      * required by the EIP. See the note at the beginning of {ERC20}.
351      *
352      * Requirements:
353      *
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      * - the caller must have allowance for ``sender``'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) public virtual override returns (bool) {
364         _transfer(sender, recipient, amount);
365 
366         uint256 currentAllowance = _allowances[sender][_msgSender()];
367         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
368         unchecked {
369             _approve(sender, _msgSender(), currentAllowance - amount);
370         }
371 
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
407         uint256 currentAllowance = _allowances[_msgSender()][spender];
408         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
409         unchecked {
410             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
411         }
412 
413         return true;
414     }
415 
416     /**
417      * @dev Moves `amount` of tokens from `sender` to `recipient`.
418      *
419      * This internal function is equivalent to {transfer}, and can be used to
420      * e.g. implement automatic token fees, slashing mechanisms, etc.
421      *
422      * Emits a {Transfer} event.
423      *
424      * Requirements:
425      *
426      * - `sender` cannot be the zero address.
427      * - `recipient` cannot be the zero address.
428      * - `sender` must have a balance of at least `amount`.
429      */
430     function _transfer(
431         address sender,
432         address recipient,
433         uint256 amount
434     ) internal virtual {
435         require(sender != address(0), "ERC20: transfer from the zero address");
436         require(recipient != address(0), "ERC20: transfer to the zero address");
437 
438         _beforeTokenTransfer(sender, recipient, amount);
439 
440         uint256 senderBalance = _balances[sender];
441         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
442         unchecked {
443             _balances[sender] = senderBalance - amount;
444         }
445         _balances[recipient] += amount;
446 
447         emit Transfer(sender, recipient, amount);
448 
449         _afterTokenTransfer(sender, recipient, amount);
450     }
451 
452     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
453      * the total supply.
454      *
455      * Emits a {Transfer} event with `from` set to the zero address.
456      *
457      * Requirements:
458      *
459      * - `account` cannot be the zero address.
460      */
461     function _mint(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: mint to the zero address");
463 
464         _beforeTokenTransfer(address(0), account, amount);
465 
466         _totalSupply += amount;
467         _balances[account] += amount;
468         emit Transfer(address(0), account, amount);
469 
470         _afterTokenTransfer(address(0), account, amount);
471     }
472 
473     /**
474      * @dev Destroys `amount` tokens from `account`, reducing the
475      * total supply.
476      *
477      * Emits a {Transfer} event with `to` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      * - `account` must have at least `amount` tokens.
483      */
484     function _burn(address account, uint256 amount) internal virtual {
485         require(account != address(0), "ERC20: burn from the zero address");
486 
487         _beforeTokenTransfer(account, address(0), amount);
488 
489         uint256 accountBalance = _balances[account];
490         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
491         unchecked {
492             _balances[account] = accountBalance - amount;
493         }
494         _totalSupply -= amount;
495 
496         emit Transfer(account, address(0), amount);
497 
498         _afterTokenTransfer(account, address(0), amount);
499     }
500 
501     /**
502      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
503      *
504      * This internal function is equivalent to `approve`, and can be used to
505      * e.g. set automatic allowances for certain subsystems, etc.
506      *
507      * Emits an {Approval} event.
508      *
509      * Requirements:
510      *
511      * - `owner` cannot be the zero address.
512      * - `spender` cannot be the zero address.
513      */
514     function _approve(
515         address owner,
516         address spender,
517         uint256 amount
518     ) internal virtual {
519         require(owner != address(0), "ERC20: approve from the zero address");
520         require(spender != address(0), "ERC20: approve to the zero address");
521 
522         _allowances[owner][spender] = amount;
523         emit Approval(owner, spender, amount);
524     }
525 
526     /**
527      * @dev Hook that is called before any transfer of tokens. This includes
528      * minting and burning.
529      *
530      * Calling conditions:
531      *
532      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
533      * will be transferred to `to`.
534      * - when `from` is zero, `amount` tokens will be minted for `to`.
535      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
536      * - `from` and `to` are never both zero.
537      *
538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
539      */
540     function _beforeTokenTransfer(
541         address from,
542         address to,
543         uint256 amount
544     ) internal virtual {}
545 
546     /**
547      * @dev Hook that is called after any transfer of tokens. This includes
548      * minting and burning.
549      *
550      * Calling conditions:
551      *
552      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
553      * has been transferred to `to`.
554      * - when `from` is zero, `amount` tokens have been minted for `to`.
555      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
556      * - `from` and `to` are never both zero.
557      *
558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
559      */
560     function _afterTokenTransfer(
561         address from,
562         address to,
563         uint256 amount
564     ) internal virtual {}
565 }
566 
567 
568 
569 // Begin CryptoRangers.sol
570 
571 pragma solidity ^0.8.0;
572 
573 
574 contract CryptoRangers is Ownable, ERC20 {
575   
576     address public uniswapV2Pair;
577  
578     constructor(uint256 _totalSupply) ERC20("Crypto Rangers", "CR") {
579         _mint(msg.sender, _totalSupply);
580     }
581 
582     function setUniswapV2pair( address _uniswapV2Pair) external onlyOwner {
583        
584         uniswapV2Pair = _uniswapV2Pair;
585        
586     }
587 }