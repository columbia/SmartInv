1 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
82 
83 
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  *
91  * _Available since v4.1._
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
111 
112 
113 
114 pragma solidity ^0.8.0;
115 
116 /*
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
133         return msg.data;
134     }
135 }
136 
137 /**
138  * @dev Contract module which provides a basic access control mechanism, where
139  * there is an account (an owner) that can be granted exclusive access to
140  * specific functions.
141  *
142  * By default, the owner account will be the one that deploys the contract. This
143  * can later be changed with {transferOwnership}.
144  *
145  * This module is used through inheritance. It will make available the modifier
146  * `onlyOwner`, which can be applied to your functions to restrict their use to
147  * the owner.
148  */
149 abstract contract Ownable {
150     address private _owner;
151 
152     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154     /**
155      * @dev Initializes the contract setting the deployer as the initial owner.
156      */
157     constructor() {
158         address msgSender = msg.sender;
159         _owner = msgSender;
160         emit OwnershipTransferred(address(0), msgSender);
161     }
162 
163     /**
164      * @dev Returns the address of the current owner.
165      */
166     function owner() public view virtual returns (address) {
167         return _owner;
168     }
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner() {
174         require(owner() == msg.sender, "Ownable: caller is not the owner");
175         _;
176     }
177 
178     /**
179      * @dev Leaves the contract without owner. It will not be possible to call
180      * `onlyOwner` functions anymore. Can only be called by the current owner.
181      *
182      * NOTE: Renouncing ownership will leave the contract without an owner,
183      * thereby removing any functionality that is only available to the owner.
184      */
185     function renounceOwnership() public virtual onlyOwner {
186         emit OwnershipTransferred(_owner, address(0));
187         _owner = address(0);
188     }
189 
190     /**
191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
192      * Can only be called by the current owner.
193      */
194     function transferOwnership(address newOwner) public virtual onlyOwner {
195         require(newOwner != address(0), "Ownable: new owner is the zero address");
196         emit OwnershipTransferred(_owner, newOwner);
197         _owner = newOwner;
198     }
199 }
200 
201 
202 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
203 
204 pragma solidity ^0.8.0;
205 
206 
207 
208 
209 /**
210  * @dev Implementation of the {IERC20} interface.
211  *
212  * This implementation is agnostic to the way tokens are created. This means
213  * that a supply mechanism has to be added in a derived contract using {_mint}.
214  * For a generic mechanism see {ERC20PresetMinterPauser}.
215  *
216  * TIP: For a detailed writeup see our guide
217  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
218  * to implement supply mechanisms].
219  *
220  * We have followed general OpenZeppelin guidelines: functions revert instead
221  * of returning `false` on failure. This behavior is nonetheless conventional
222  * and does not conflict with the expectations of ERC20 applications.
223  *
224  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
225  * This allows applications to reconstruct the allowance for all accounts just
226  * by listening to said events. Other implementations of the EIP may not emit
227  * these events, as it isn't required by the specification.
228  *
229  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
230  * functions have been added to mitigate the well-known issues around setting
231  * allowances. See {IERC20-approve}.
232  */
233 contract KusaTokenV1 is Context, IERC20, IERC20Metadata, Ownable {
234     mapping (address => uint256) private _balances;
235 
236     mapping (address => mapping (address => uint256)) private _allowances;
237 
238     uint256 private _totalSupply;
239 
240     string private _name;
241     string private _symbol;
242 
243     /**
244      * @dev Sets the values for {name} and {symbol}.
245      *
246      * The defaut value of {decimals} is 18. To select a different value for
247      * {decimals} you should overload it.
248      *
249      * All two of these values are immutable: they can only be set once during
250      * construction.
251      */
252     constructor () {
253         _name = "Kusa Inu";
254         _symbol = "KUSA";
255         _mint(msg.sender, 1_000_000_000 * (10 ** uint256(decimals())));
256     }
257 
258     /**
259      * @dev Returns the name of the token.
260      */
261     function name() public view virtual override returns (string memory) {
262         return _name;
263     }
264 
265     /**
266      * @dev Returns the symbol of the token, usually a shorter version of the
267      * name.
268      */
269     function symbol() public view virtual override returns (string memory) {
270         return _symbol;
271     }
272 
273     /**
274      * @dev Returns the number of decimals used to get its user representation.
275      * For example, if `decimals` equals `2`, a balance of `505` tokens should
276      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
277      *
278      * Tokens usually opt for a value of 18, imitating the relationship between
279      * Ether and Wei. This is the value {ERC20} uses, unless this function is
280      * overridden;
281      *
282      * NOTE: This information is only used for _display_ purposes: it in
283      * no way affects any of the arithmetic of the contract, including
284      * {IERC20-balanceOf} and {IERC20-transfer}.
285      */
286     function decimals() public view virtual override returns (uint8) {
287         return 18;
288     }
289 
290     /**
291      * @dev See {IERC20-totalSupply}.
292      */
293     function totalSupply() public view virtual override returns (uint256) {
294         return _totalSupply;
295     }
296 
297     /**
298      * @dev See {IERC20-balanceOf}.
299      */
300     function balanceOf(address account) public view virtual override returns (uint256) {
301         return _balances[account];
302     }
303 
304     /**
305      * @dev See {IERC20-transfer}.
306      *
307      * Requirements:
308      *
309      * - `recipient` cannot be the zero address.
310      * - the caller must have a balance of at least `amount`.
311      */
312     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
313         _transfer(_msgSender(), recipient, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-allowance}.
319      */
320     function allowance(address owner, address spender) public view virtual override returns (uint256) {
321         return _allowances[owner][spender];
322     }
323 
324     /**
325      * @dev See {IERC20-approve}.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function approve(address spender, uint256 amount) public virtual override returns (bool) {
332         _approve(_msgSender(), spender, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-transferFrom}.
338      *
339      * Emits an {Approval} event indicating the updated allowance. This is not
340      * required by the EIP. See the note at the beginning of {ERC20}.
341      *
342      * Requirements:
343      *
344      * - `sender` and `recipient` cannot be the zero address.
345      * - `sender` must have a balance of at least `amount`.
346      * - the caller must have allowance for ``sender``'s tokens of at least
347      * `amount`.
348      */
349     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
350         _transfer(sender, recipient, amount);
351 
352         uint256 currentAllowance = _allowances[sender][_msgSender()];
353         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
354         _approve(sender, _msgSender(), currentAllowance - amount);
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
393         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
394 
395         return true;
396     }
397 
398     /**
399      * @dev Moves tokens `amount` from `sender` to `recipient`.
400      *
401      * This is internal function is equivalent to {transfer}, and can be used to
402      * e.g. implement automatic token fees, slashing mechanisms, etc.
403      *
404      * Emits a {Transfer} event.
405      *
406      * Requirements:
407      *
408      * - `sender` cannot be the zero address.
409      * - `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      */
412     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
413         require(sender != address(0), "ERC20: transfer from the zero address");
414         require(recipient != address(0), "ERC20: transfer to the zero address");
415 
416         _beforeTokenTransfer(sender, recipient, amount);
417 
418         uint256 senderBalance = _balances[sender];
419         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
420         _balances[sender] = senderBalance - amount;
421         _balances[recipient] += amount;
422 
423         emit Transfer(sender, recipient, amount);
424     }
425 
426     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
427      * the total supply.
428      *
429      * Emits a {Transfer} event with `from` set to the zero address.
430      *
431      * Requirements:
432      *
433      * - `to` cannot be the zero address.
434      */
435     function _mint(address account, uint256 amount) internal virtual {
436         require(account != address(0), "ERC20: mint to the zero address");
437 
438         _beforeTokenTransfer(address(0), account, amount);
439 
440         _totalSupply += amount;
441         _balances[account] += amount;
442         emit Transfer(address(0), account, amount);
443     }
444 
445     /**
446      * @dev Destroys `amount` tokens from `account`, reducing the
447      * total supply.
448      *
449      * Emits a {Transfer} event with `to` set to the zero address.
450      *
451      * Requirements:
452      *
453      * - `account` cannot be the zero address.
454      * - `account` must have at least `amount` tokens.
455      */
456     function _burn(address account, uint256 amount) internal virtual {
457         require(account != address(0), "ERC20: burn from the zero address");
458 
459         _beforeTokenTransfer(account, address(0), amount);
460 
461         uint256 accountBalance = _balances[account];
462         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
463         _balances[account] = accountBalance - amount;
464         _totalSupply -= amount;
465 
466         emit Transfer(account, address(0), amount);
467     }
468 
469     /**
470      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
471      *
472      * This internal function is equivalent to `approve`, and can be used to
473      * e.g. set automatic allowances for certain subsystems, etc.
474      *
475      * Emits an {Approval} event.
476      *
477      * Requirements:
478      *
479      * - `owner` cannot be the zero address.
480      * - `spender` cannot be the zero address.
481      */
482     function _approve(address owner, address spender, uint256 amount) internal virtual {
483         require(owner != address(0), "ERC20: approve from the zero address");
484         require(spender != address(0), "ERC20: approve to the zero address");
485 
486         _allowances[owner][spender] = amount;
487         emit Approval(owner, spender, amount);
488     }
489 
490     /**
491      * @dev Hook that is called before any transfer of tokens. This includes
492      * minting and burning.
493      *
494      * Calling conditions:
495      *
496      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
497      * will be to transferred to `to`.
498      * - when `from` is zero, `amount` tokens will be minted for `to`.
499      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
500      * - `from` and `to` are never both zero.
501      *
502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
503      */
504     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
505 }