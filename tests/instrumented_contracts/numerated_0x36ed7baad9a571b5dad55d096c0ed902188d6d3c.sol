1 // SPDX-License-Identifier: MIT
2 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /*
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
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin\contracts\access\Ownable.sol
30 
31 
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
100 
101 
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Interface of the ERC20 standard as defined in the EIP.
107  */
108 interface IERC20 {
109     /**
110      * @dev Returns the amount of tokens in existence.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     /**
115      * @dev Returns the amount of tokens owned by `account`.
116      */
117     function balanceOf(address account) external view returns (uint256);
118 
119     /**
120      * @dev Moves `amount` tokens from the caller's account to `recipient`.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transfer(address recipient, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Returns the remaining number of tokens that `spender` will be
130      * allowed to spend on behalf of `owner` through {transferFrom}. This is
131      * zero by default.
132      *
133      * This value changes when {approve} or {transferFrom} are called.
134      */
135     function allowance(address owner, address spender) external view returns (uint256);
136 
137     /**
138      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * IMPORTANT: Beware that changing an allowance with this method brings the risk
143      * that someone may use both the old and the new allowance by unfortunate
144      * transaction ordering. One possible solution to mitigate this race
145      * condition is to first reduce the spender's allowance to 0 and set the
146      * desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Moves `amount` tokens from `sender` to `recipient` using the
155      * allowance mechanism. `amount` is then deducted from the caller's
156      * allowance.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
179 // File: node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
180 
181 
182 
183 pragma solidity ^0.8.0;
184 
185 
186 /**
187  * @dev Interface for the optional metadata functions from the ERC20 standard.
188  *
189  * _Available since v4.1._
190  */
191 interface IERC20Metadata is IERC20 {
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the symbol of the token.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the decimals places of the token.
204      */
205     function decimals() external view returns (uint8);
206 }
207 
208 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
209 
210 
211 
212 pragma solidity ^0.8.0;
213 
214 
215 
216 
217 /**
218  * @dev Implementation of the {IERC20} interface.
219  *
220  * This implementation is agnostic to the way tokens are created. This means
221  * that a supply mechanism has to be added in a derived contract using {_mint}.
222  * For a generic mechanism see {ERC20PresetMinterPauser}.
223  *
224  * TIP: For a detailed writeup see our guide
225  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
226  * to implement supply mechanisms].
227  *
228  * We have followed general OpenZeppelin guidelines: functions revert instead
229  * of returning `false` on failure. This behavior is nonetheless conventional
230  * and does not conflict with the expectations of ERC20 applications.
231  *
232  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
233  * This allows applications to reconstruct the allowance for all accounts just
234  * by listening to said events. Other implementations of the EIP may not emit
235  * these events, as it isn't required by the specification.
236  *
237  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
238  * functions have been added to mitigate the well-known issues around setting
239  * allowances. See {IERC20-approve}.
240  */
241 contract ERC20 is Context, IERC20, IERC20Metadata {
242     mapping (address => uint256) private _balances;
243 
244     mapping (address => mapping (address => uint256)) private _allowances;
245 
246     uint256 private _totalSupply;
247 
248     string private _name;
249     string private _symbol;
250 
251     /**
252      * @dev Sets the values for {name} and {symbol}.
253      *
254      * The defaut value of {decimals} is 18. To select a different value for
255      * {decimals} you should overload it.
256      *
257      * All two of these values are immutable: they can only be set once during
258      * construction.
259      */
260     constructor (string memory name_, string memory symbol_) {
261         _name = name_;
262         _symbol = symbol_;
263     }
264 
265     /**
266      * @dev Returns the name of the token.
267      */
268     function name() public view virtual override returns (string memory) {
269         return _name;
270     }
271 
272     /**
273      * @dev Returns the symbol of the token, usually a shorter version of the
274      * name.
275      */
276     function symbol() public view virtual override returns (string memory) {
277         return _symbol;
278     }
279 
280     /**
281      * @dev Returns the number of decimals used to get its user representation.
282      * For example, if `decimals` equals `2`, a balance of `505` tokens should
283      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
284      *
285      * Tokens usually opt for a value of 18, imitating the relationship between
286      * Ether and Wei. This is the value {ERC20} uses, unless this function is
287      * overridden;
288      *
289      * NOTE: This information is only used for _display_ purposes: it in
290      * no way affects any of the arithmetic of the contract, including
291      * {IERC20-balanceOf} and {IERC20-transfer}.
292      */
293     function decimals() public view virtual override returns (uint8) {
294         return 18;
295     }
296 
297     /**
298      * @dev See {IERC20-totalSupply}.
299      */
300     function totalSupply() public view virtual override returns (uint256) {
301         return _totalSupply;
302     }
303 
304     /**
305      * @dev See {IERC20-balanceOf}.
306      */
307     function balanceOf(address account) public view virtual override returns (uint256) {
308         return _balances[account];
309     }
310 
311     /**
312      * @dev See {IERC20-transfer}.
313      *
314      * Requirements:
315      *
316      * - `recipient` cannot be the zero address.
317      * - the caller must have a balance of at least `amount`.
318      */
319     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
320         _transfer(_msgSender(), recipient, amount);
321         return true;
322     }
323 
324     /**
325      * @dev See {IERC20-allowance}.
326      */
327     function allowance(address owner, address spender) public view virtual override returns (uint256) {
328         return _allowances[owner][spender];
329     }
330 
331     /**
332      * @dev See {IERC20-approve}.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      */
338     function approve(address spender, uint256 amount) public virtual override returns (bool) {
339         _approve(_msgSender(), spender, amount);
340         return true;
341     }
342 
343     /**
344      * @dev See {IERC20-transferFrom}.
345      *
346      * Emits an {Approval} event indicating the updated allowance. This is not
347      * required by the EIP. See the note at the beginning of {ERC20}.
348      *
349      * Requirements:
350      *
351      * - `sender` and `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      * - the caller must have allowance for ``sender``'s tokens of at least
354      * `amount`.
355      */
356     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
357         _transfer(sender, recipient, amount);
358 
359         uint256 currentAllowance = _allowances[sender][_msgSender()];
360         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
361         _approve(sender, _msgSender(), currentAllowance - amount);
362 
363         return true;
364     }
365 
366     /**
367      * @dev Atomically increases the allowance granted to `spender` by the caller.
368      *
369      * This is an alternative to {approve} that can be used as a mitigation for
370      * problems described in {IERC20-approve}.
371      *
372      * Emits an {Approval} event indicating the updated allowance.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      */
378     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
379         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
380         return true;
381     }
382 
383     /**
384      * @dev Atomically decreases the allowance granted to `spender` by the caller.
385      *
386      * This is an alternative to {approve} that can be used as a mitigation for
387      * problems described in {IERC20-approve}.
388      *
389      * Emits an {Approval} event indicating the updated allowance.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      * - `spender` must have allowance for the caller of at least
395      * `subtractedValue`.
396      */
397     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
398         uint256 currentAllowance = _allowances[_msgSender()][spender];
399         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
400         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
401 
402         return true;
403     }
404 
405     /**
406      * @dev Moves tokens `amount` from `sender` to `recipient`.
407      *
408      * This is internal function is equivalent to {transfer}, and can be used to
409      * e.g. implement automatic token fees, slashing mechanisms, etc.
410      *
411      * Emits a {Transfer} event.
412      *
413      * Requirements:
414      *
415      * - `sender` cannot be the zero address.
416      * - `recipient` cannot be the zero address.
417      * - `sender` must have a balance of at least `amount`.
418      */
419     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
420         require(sender != address(0), "ERC20: transfer from the zero address");
421         require(recipient != address(0), "ERC20: transfer to the zero address");
422 
423         _beforeTokenTransfer(sender, recipient, amount);
424 
425         uint256 senderBalance = _balances[sender];
426         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
427         _balances[sender] = senderBalance - amount;
428         _balances[recipient] += amount;
429 
430         emit Transfer(sender, recipient, amount);
431     }
432 
433     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
434      * the total supply.
435      *
436      * Emits a {Transfer} event with `from` set to the zero address.
437      *
438      * Requirements:
439      *
440      * - `to` cannot be the zero address.
441      */
442     function _mint(address account, uint256 amount) internal virtual {
443         require(account != address(0), "ERC20: mint to the zero address");
444 
445         _beforeTokenTransfer(address(0), account, amount);
446 
447         _totalSupply += amount;
448         _balances[account] += amount;
449         emit Transfer(address(0), account, amount);
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
470         _balances[account] = accountBalance - amount;
471         _totalSupply -= amount;
472 
473         emit Transfer(account, address(0), amount);
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
489     function _approve(address owner, address spender, uint256 amount) internal virtual {
490         require(owner != address(0), "ERC20: approve from the zero address");
491         require(spender != address(0), "ERC20: approve to the zero address");
492 
493         _allowances[owner][spender] = amount;
494         emit Approval(owner, spender, amount);
495     }
496 
497     /**
498      * @dev Hook that is called before any transfer of tokens. This includes
499      * minting and burning.
500      *
501      * Calling conditions:
502      *
503      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
504      * will be to transferred to `to`.
505      * - when `from` is zero, `amount` tokens will be minted for `to`.
506      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
507      * - `from` and `to` are never both zero.
508      *
509      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
510      */
511     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
512 }
513 
514 // File: @openzeppelin\contracts\token\ERC20\extensions\ERC20Burnable.sol
515 
516 
517 
518 pragma solidity ^0.8.0;
519 
520 
521 
522 /**
523  * @dev Extension of {ERC20} that allows token holders to destroy both their own
524  * tokens and those that they have an allowance for, in a way that can be
525  * recognized off-chain (via event analysis).
526  */
527 abstract contract ERC20Burnable is Context, ERC20 {
528     /**
529      * @dev Destroys `amount` tokens from the caller.
530      *
531      * See {ERC20-_burn}.
532      */
533     function burn(uint256 amount) public virtual {
534         _burn(_msgSender(), amount);
535     }
536 
537     /**
538      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
539      * allowance.
540      *
541      * See {ERC20-_burn} and {ERC20-allowance}.
542      *
543      * Requirements:
544      *
545      * - the caller must have allowance for ``accounts``'s tokens of at least
546      * `amount`.
547      */
548     function burnFrom(address account, uint256 amount) public virtual {
549         uint256 currentAllowance = allowance(account, _msgSender());
550         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
551         _approve(account, _msgSender(), currentAllowance - amount);
552         _burn(account, amount);
553     }
554 }
555 
556 // File: contracts\tokens\InfinityPadToken.sol
557 
558 
559 pragma solidity 0.8.4;
560 
561 
562 
563 
564 
565 contract InfinityPadToken is Ownable, ERC20Burnable {
566   constructor (string memory name, string memory symbol, uint256 amount)
567     ERC20(name, symbol) {
568       _mint(_msgSender(), amount);
569   }
570 
571   /**
572    * @dev Creates `amount` tokens and assigns them to `account`, increasing
573    * the total supply.
574    *
575    * Requirements
576    *
577    * - `msg.sender` must be the token owner
578    */
579   function mint(address account, uint256 amount) external onlyOwner {
580     _mint(account, amount);
581   }
582 }