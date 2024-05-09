1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /******************************************/
6 /*           IERC20 starts here           */
7 /******************************************/
8 
9 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /******************************************/
90 /*           Context starts here          */
91 /******************************************/
92 
93 // File: @openzeppelin/contracts/GSN/Context.sol
94 
95 /*
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 abstract contract Context {
106     function _msgSender() internal view virtual returns (address) {
107         return msg.sender;
108     }
109 
110     function _msgData() internal view virtual returns (bytes calldata) {
111         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
112         return msg.data;
113     }
114 }
115 
116 /******************************************/
117 /*           Ownable starts here          */
118 /******************************************/
119 
120 /**
121  * @dev Contract module which provides a basic access control mechanism, where
122  * there is an account (an owner) that can be granted exclusive access to
123  * specific functions.
124  *
125  * By default, the owner account will be the one that deploys the contract. This
126  * can later be changed with {transferOwnership}.
127  *
128  * This module is used through inheritance. It will make available the modifier
129  * `onlyOwner`, which can be applied to your functions to restrict their use to
130  * the owner.
131  */
132 
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor() {
142         address msgSender = _msgSender();
143         _owner = msgSender;
144         emit OwnershipTransferred(address(0), msgSender);
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159         _;
160     }
161 
162     /**
163      * @dev Leaves the contract without owner. It will not be possible to call
164      * `onlyOwner` functions anymore. Can only be called by the current owner.
165      *
166      * NOTE: Renouncing ownership will leave the contract without an owner,
167      * thereby removing any functionality that is only available to the owner.
168      */
169     function renounceOwnership() public virtual onlyOwner {
170         emit OwnershipTransferred(_owner, address(0));
171         _owner = address(0);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Can only be called by the current owner.
177      */
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         emit OwnershipTransferred(_owner, newOwner);
181         _owner = newOwner;
182     }
183 }
184 
185 /******************************************/
186 /*      IERC20Metadata starts here        */
187 /******************************************/
188 
189 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
190 
191 /**
192  * @dev Interface for the optional metadata functions from the ERC20 standard.
193  *
194  * _Available since v4.1._
195  */
196 interface IERC20Metadata is IERC20 {
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the symbol of the token.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the decimals places of the token.
209      */
210     function decimals() external view returns (uint8);
211 }
212 
213 /******************************************/
214 /*           ERC20 starts here            */
215 /******************************************/
216 
217 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
218 
219 /**
220  * @dev Implementation of the {IERC20} interface.
221  *
222  * This implementation is agnostic to the way tokens are created. This means
223  * that a supply mechanism has to be added in a derived contract using {_mint}.
224  * For a generic mechanism see {ERC20PresetMinterPauser}.
225  *
226  * TIP: For a detailed writeup see our guide
227  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
228  * to implement supply mechanisms].
229  *
230  * We have followed general OpenZeppelin guidelines: functions revert instead
231  * of returning `false` on failure. This behavior is nonetheless conventional
232  * and does not conflict with the expectations of ERC20 applications.
233  *
234  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
235  * This allows applications to reconstruct the allowance for all accounts just
236  * by listening to said events. Other implementations of the EIP may not emit
237  * these events, as it isn't required by the specification.
238  *
239  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
240  * functions have been added to mitigate the well-known issues around setting
241  * allowances. See {IERC20-approve}.
242  */
243 contract ERC20 is Context, IERC20, IERC20Metadata {
244     mapping(address => uint256) private _balances;
245 
246     mapping(address => mapping(address => uint256)) private _allowances;
247 
248     uint256 private _totalSupply;
249 
250     string private _name;
251     string private _symbol;
252 
253     /**
254      * @dev Sets the values for {name} and {symbol}.
255      *
256      * The default value of {decimals} is 18. To select a different value for
257      * {decimals} you should overload it.
258      *
259      * All two of these values are immutable: they can only be set once during
260      * construction.
261      */
262     constructor(string memory name_, string memory symbol_) {
263         _name = name_;
264         _symbol = symbol_;
265     }
266 
267     /**
268      * @dev Returns the name of the token.
269      */
270     function name() public view virtual override returns (string memory) {
271         return _name;
272     }
273 
274     /**
275      * @dev Returns the symbol of the token, usually a shorter version of the
276      * name.
277      */
278     function symbol() public view virtual override returns (string memory) {
279         return _symbol;
280     }
281 
282     /**
283      * @dev Returns the number of decimals used to get its user representation.
284      * For example, if `decimals` equals `2`, a balance of `505` tokens should
285      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
286      *
287      * Tokens usually opt for a value of 18, imitating the relationship between
288      * Ether and Wei. This is the value {ERC20} uses, unless this function is
289      * overridden;
290      *
291      * NOTE: This information is only used for _display_ purposes: it in
292      * no way affects any of the arithmetic of the contract, including
293      * {IERC20-balanceOf} and {IERC20-transfer}.
294      */
295     function decimals() public view virtual override returns (uint8) {
296         return 18;
297     }
298 
299     /**
300      * @dev See {IERC20-totalSupply}.
301      */
302     function totalSupply() public view virtual override returns (uint256) {
303         return _totalSupply;
304     }
305 
306     /**
307      * @dev See {IERC20-balanceOf}.
308      */
309     function balanceOf(address account) public view virtual override returns (uint256) {
310         return _balances[account];
311     }
312 
313     /**
314      * @dev See {IERC20-transfer}.
315      *
316      * Requirements:
317      *
318      * - `recipient` cannot be the zero address.
319      * - the caller must have a balance of at least `amount`.
320      */
321     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
322         _transfer(_msgSender(), recipient, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-allowance}.
328      */
329     function allowance(address owner, address spender) public view virtual override returns (uint256) {
330         return _allowances[owner][spender];
331     }
332 
333     /**
334      * @dev See {IERC20-approve}.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function approve(address spender, uint256 amount) public virtual override returns (bool) {
341         _approve(_msgSender(), spender, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-transferFrom}.
347      *
348      * Emits an {Approval} event indicating the updated allowance. This is not
349      * required by the EIP. See the note at the beginning of {ERC20}.
350      *
351      * Requirements:
352      *
353      * - `sender` and `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      * - the caller must have allowance for ``sender``'s tokens of at least
356      * `amount`.
357      */
358     function transferFrom(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) public virtual override returns (bool) {
363         _transfer(sender, recipient, amount);
364 
365         uint256 currentAllowance = _allowances[sender][_msgSender()];
366         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
367         unchecked {
368             _approve(sender, _msgSender(), currentAllowance - amount);
369         }
370 
371         return true;
372     }
373 
374     /**
375      * @dev Atomically increases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
387         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
388         return true;
389     }
390 
391     /**
392      * @dev Atomically decreases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      * - `spender` must have allowance for the caller of at least
403      * `subtractedValue`.
404      */
405     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
406         uint256 currentAllowance = _allowances[_msgSender()][spender];
407         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
408         unchecked {
409             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
410         }
411 
412         return true;
413     }
414 
415     /**
416      * @dev Moves tokens `amount` from `sender` to `recipient`.
417      *
418      * This is internal function is equivalent to {transfer}, and can be used to
419      * e.g. implement automatic token fees, slashing mechanisms, etc.
420      *
421      * Emits a {Transfer} event.
422      *
423      * Requirements:
424      *
425      * - `sender` cannot be the zero address.
426      * - `recipient` cannot be the zero address.
427      * - `sender` must have a balance of at least `amount`.
428      */
429     function _transfer(
430         address sender,
431         address recipient,
432         uint256 amount
433     ) internal virtual {
434         require(sender != address(0), "ERC20: transfer from the zero address");
435         require(recipient != address(0), "ERC20: transfer to the zero address");
436 
437         _beforeTokenTransfer(sender, recipient, amount);
438 
439         uint256 senderBalance = _balances[sender];
440         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
441         unchecked {
442             _balances[sender] = senderBalance - amount;
443         }
444         _balances[recipient] += amount;
445 
446         emit Transfer(sender, recipient, amount);
447     }
448 
449     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
450      * the total supply.
451      *
452      * Emits a {Transfer} event with `from` set to the zero address.
453      *
454      * Requirements:
455      *
456      * - `account` cannot be the zero address.
457      */
458     function _mint(address account, uint256 amount) internal virtual {
459         require(account != address(0), "ERC20: mint to the zero address");
460 
461         _beforeTokenTransfer(address(0), account, amount);
462 
463         _totalSupply += amount;
464         _balances[account] += amount;
465         emit Transfer(address(0), account, amount);
466     }
467 
468     /**
469      * @dev Destroys `amount` tokens from `account`, reducing the
470      * total supply.
471      *
472      * Emits a {Transfer} event with `to` set to the zero address.
473      *
474      * Requirements:
475      *
476      * - `account` cannot be the zero address.
477      * - `account` must have at least `amount` tokens.
478      */
479     function _burn(address account, uint256 amount) internal virtual {
480         require(account != address(0), "ERC20: burn from the zero address");
481 
482         _beforeTokenTransfer(account, address(0), amount);
483 
484         uint256 accountBalance = _balances[account];
485         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
486         unchecked {
487             _balances[account] = accountBalance - amount;
488         }
489         _totalSupply -= amount;
490 
491         emit Transfer(account, address(0), amount);
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
526      * will be to transferred to `to`.
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
538 }
539 
540 /******************************************/
541 /*           DinoSwap starts here         */
542 /******************************************/
543 
544 contract DinoSwap is ERC20, Ownable {
545 
546     address public minter;
547 
548     event DinosMinted(address to, uint256 amount);
549     event DinosBurned(address from, uint256 amount);
550     event LogNewMinter(address minter);
551 
552     modifier onlyMinter() {
553         require(msg.sender == minter, "Caller is not the minter.");
554         _;
555     }
556     
557     constructor(string memory name, string memory symbol, address allocationsContract) ERC20(name, symbol) {
558         _mint(allocationsContract, 65*1e24);
559     }
560 
561     function setMinter(address newMinter) external onlyOwner {
562         minter = newMinter;
563         emit LogNewMinter(minter);
564     }
565 
566     function mintDinos(address to, uint256 amount) external onlyMinter {
567         _mint(to, amount);
568         emit DinosMinted(to, amount);
569     }
570 
571     function burnDinos(address from, uint256 amount) external onlyMinter {
572         _burn(from, amount);
573         emit DinosBurned(from, amount);
574     }
575 }